"""Reusable Viser environments for the interactive demo."""

from .retail_store import add_retail_store_environment

ENVIRONMENT_NONE_LABEL = "None"
DEFAULT_ENVIRONMENT_LABEL = "Retail Store"
ENVIRONMENT_OPTIONS = (ENVIRONMENT_NONE_LABEL, DEFAULT_ENVIRONMENT_LABEL)


def add_environment_to_scene(client, label: str):
    """Add one named environment to a Viser client scene."""
    if label == ENVIRONMENT_NONE_LABEL:
        return []
    if label == DEFAULT_ENVIRONMENT_LABEL:
        return add_retail_store_environment(client)
    raise ValueError(f"Unknown environment: {label}")


__all__ = [
    "DEFAULT_ENVIRONMENT_LABEL",
    "ENVIRONMENT_NONE_LABEL",
    "ENVIRONMENT_OPTIONS",
    "add_environment_to_scene",
    "add_retail_store_environment",
]
