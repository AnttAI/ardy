const els = {
  loadForm: document.querySelector("#loadForm"),
  csvFile: document.querySelector("#csvFile"),
  csvPath: document.querySelector("#csvPath"),
  segment: document.querySelector("#segment"),
  fps: document.querySelector("#fps"),
  liftStepFrames: document.querySelector("#liftStepFrames"),
  dryRun: document.querySelector("#dryRun"),
  rightTopic: document.querySelector("#rightTopic"),
  leftTopic: document.querySelector("#leftTopic"),
  gripperTopic: document.querySelector("#gripperTopic"),
  baseTopic: document.querySelector("#baseTopic"),
  liftTopic: document.querySelector("#liftTopic"),
  statusText: document.querySelector("#statusText"),
  statePill: document.querySelector("#statePill"),
  frameNumber: document.querySelector("#frameNumber"),
  rowNumber: document.querySelector("#rowNumber"),
  fpsValue: document.querySelector("#fpsValue"),
  csvName: document.querySelector("#csvName"),
  rowCount: document.querySelector("#rowCount"),
  capabilities: document.querySelector("#capabilities"),
  baseValues: document.querySelector("#baseValues"),
  liftValues: document.querySelector("#liftValues"),
  rightValues: document.querySelector("#rightValues"),
  leftValues: document.querySelector("#leftValues"),
  errorBox: document.querySelector("#errorBox"),
  pauseButton: document.querySelector("#pauseButton"),
  stopButton: document.querySelector("#stopButton"),
  playButtons: [...document.querySelectorAll(".play")],
};

function numberValue(input, fallback) {
  const value = Number(input.value);
  return Number.isFinite(value) ? value : fallback;
}

async function postJson(url, data) {
  const response = await fetch(url, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(data),
  });
  const payload = await response.json();
  if (!response.ok) {
    throw new Error(payload.error || "Request failed");
  }
  return payload;
}

function playOptions(mode) {
  return {
    mode,
    dry_run: els.dryRun.checked,
    fps: numberValue(els.fps, 20),
    lift_step_frames: numberValue(els.liftStepFrames, 10),
    rpm_scale: 1,
    max_abs_rpm: 90,
    linear_scale: 1,
    backward_scale: 1,
    yaw_scale: 1,
    wait_for_subscribers: 5,
    require_lift_subscriber: false,
    right_topic: els.rightTopic.value,
    left_topic: els.leftTopic.value,
    gripper_topic: els.gripperTopic.value,
    base_topic: els.baseTopic.value,
    lift_topic: els.liftTopic.value,
  };
}

function formatArray(title, names, values, unit) {
  if (!Array.isArray(values)) {
    return `No ${title} values`;
  }
  return values.map((value, idx) => {
    const name = names[idx] || `v${idx + 1}`;
    return `${name.padEnd(8)} ${Number(value).toFixed(4)} ${unit}`;
  }).join("\n");
}

function setButtonStates(state) {
  const caps = state.capabilities || {};
  const loaded = Boolean(state.rows);
  const playing = Boolean(state.playing);
  const paused = Boolean(state.paused);
  const needs = {
    robot: ["robot"],
    robot_lift: ["robot", "lift"],
    base_lift: ["base", "lift"],
    full: ["robot", "base", "lift"],
  };
  els.playButtons.forEach((button) => {
    const mode = button.dataset.mode;
    const missing = (needs[mode] || []).some((key) => !caps[key]);
    button.disabled = !loaded || playing || missing;
    button.title = missing ? "Loaded CSV does not contain all columns for this mode" : "";
  });
  els.pauseButton.disabled = !playing;
  els.pauseButton.textContent = paused ? "Resume" : "Pause";
  els.pauseButton.classList.toggle("resume", paused);
  els.stopButton.disabled = !playing;
}

function render(state) {
  els.statusText.textContent = state.status || "Idle";
  els.statePill.textContent = state.paused
    ? "Paused"
    : state.playing
      ? (state.dry_run ? "Dry Run" : "Publishing")
      : "Idle";
  els.statePill.className = `pill ${state.error ? "failed" : state.paused ? "paused" : state.playing ? "running" : "idle"}`;
  els.frameNumber.textContent = state.frame_index >= 0 ? state.frame_index : "-";
  els.rowNumber.textContent = state.row_index >= 0 && state.rows ? `${state.row_index + 1}/${state.rows}` : "-";
  els.fpsValue.textContent = state.fps ? Number(state.fps).toFixed(2) : "-";
  els.csvName.textContent = state.csv_path || "-";
  els.rowCount.textContent = state.rows ? `${state.rows} rows, segment ${state.segment_index + 1}/${state.segment_count}` : "-";

  const caps = state.capabilities || {};
  els.capabilities.textContent = ["robot", "base", "lift"]
    .map((key) => `${key}: ${caps[key] ? "yes" : "no"}`)
    .join("  ");

  const payload = state.payload || {};
  els.baseValues.textContent = Array.isArray(payload.base_wheel_rpm)
    ? `left_rpm   ${Number(payload.base_wheel_rpm[0]).toFixed(0)}\nright_rpm  ${Number(payload.base_wheel_rpm[1]).toFixed(0)}`
    : "No base values";
  els.liftValues.textContent = payload.lift !== undefined
    ? `frame      ${payload.lift_frame_index ?? payload.frame_index}\nheight_cm  ${Number(payload.lift).toFixed(3)}`
    : "No lift value";
  els.rightValues.textContent = formatArray("right arm", ["j1", "j2", "j3", "j4", "j5", "j6", "j7"], payload.right, "rad");
  els.leftValues.textContent = formatArray("left arm", ["j1", "j2", "j3", "j4", "j5", "j6", "j7"], payload.left, "rad");

  els.errorBox.hidden = !state.error;
  els.errorBox.textContent = state.error || "";
  setButtonStates(state);
}

async function loadCsv(event) {
  event.preventDefault();
  try {
    if (els.csvFile.files.length > 0) {
      const form = new FormData();
      form.append("csv", els.csvFile.files[0]);
      form.append("segment", els.segment.value);
      form.append("fps", els.fps.value);
      const response = await fetch("/api/upload", { method: "POST", body: form });
      const payload = await response.json();
      if (!response.ok) {
        throw new Error(payload.error || "Upload failed");
      }
      render(payload);
    } else {
      const payload = await postJson("/api/load-path", {
        path: els.csvPath.value,
        segment: numberValue(els.segment, 0),
        fps: numberValue(els.fps, 0),
      });
      render(payload);
    }
  } catch (error) {
    els.errorBox.hidden = false;
    els.errorBox.textContent = error.message;
  }
}

els.loadForm.addEventListener("submit", loadCsv);

els.playButtons.forEach((button) => {
  button.addEventListener("click", async () => {
    try {
      const payload = await postJson("/api/play", playOptions(button.dataset.mode));
      render(payload);
    } catch (error) {
      els.errorBox.hidden = false;
      els.errorBox.textContent = error.message;
    }
  });
});

els.pauseButton.addEventListener("click", async () => {
  try {
    const paused = els.pauseButton.textContent === "Resume";
    const payload = await postJson(paused ? "/api/resume" : "/api/pause", {});
    render(payload);
  } catch (error) {
    els.errorBox.hidden = false;
    els.errorBox.textContent = error.message;
  }
});

els.stopButton.addEventListener("click", async () => {
  try {
    const payload = await postJson("/api/stop", {});
    render(payload);
  } catch (error) {
    els.errorBox.hidden = false;
    els.errorBox.textContent = error.message;
  }
});

const events = new EventSource("/api/events");
events.onmessage = (event) => render(JSON.parse(event.data));

setInterval(() => {
  fetch("/api/status", { cache: "no-store" })
    .then((response) => response.json())
    .then(render)
    .catch(() => {});
}, 200);

fetch("/api/status")
  .then((response) => response.json())
  .then(render)
  .catch((error) => {
    els.errorBox.hidden = false;
    els.errorBox.textContent = error.message;
  });
