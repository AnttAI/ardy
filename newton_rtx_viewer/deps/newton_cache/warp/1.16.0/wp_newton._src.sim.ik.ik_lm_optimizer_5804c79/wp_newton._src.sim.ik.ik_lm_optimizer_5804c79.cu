#define WP_NO_BFLOAT16

#define WP_TILE_BLOCK_DIM 256
#define WP_NO_CRT
#include "builtin.h"
#include "deterministic.h"

// Map wp.breakpoint() to a device brkpt at the call site so cuda-gdb attributes the stop to the generated .cu line
#if defined(__CUDACC__) && !defined(_MSC_VER)
#define __debugbreak() __brkpt()
#endif

// avoid namespacing of float type for casting to float type, this is to avoid wp::float(x), which is not valid in C++
#define float(x) cast_float(x)
#define adj_float(x, adj_x, adj_ret) adj_cast_float(x, adj_x, adj_ret)

#define int(x) cast_int(x)
#define adj_int(x, adj_x, adj_ret) adj_cast_int(x, adj_x, adj_ret)

#define builtin_tid1d() wp::tid(_idx, dim)
#define builtin_tid2d(x, y) wp::tid(x, y, _idx, dim)
#define builtin_tid3d(x, y, z) wp::tid(x, y, z, _idx, dim)
#define builtin_tid4d(x, y, z, w) wp::tid(x, y, z, w, _idx, dim)

#define builtin_block_dim() wp::block_dim()

// CUDA Thread Block Cluster shape declaration. Expands to __cluster_dims__
// only on devices that support clusters (compute capability 9.0+); otherwise
// expands to nothing so the same source compiles cleanly for any target arch.
#if defined(__CUDA_ARCH__) && (__CUDA_ARCH__ >= 900)
#define WP_CLUSTER_DIMS(x, y, z) __cluster_dims__(x, y, z)
#else
#define WP_CLUSTER_DIMS(x, y, z)
#endif


// /home/jony/Downloads/newton/repos/newton/newton/_src/solvers/featherstone/kernels.py:464
static CUDA_CALLABLE void jcalc_integrate_0(
    wp::int32 var_parent,
    wp::transform_t<wp::float32> var_joint_X_c,
    wp::vec_t<3, wp::float32> var_body_com_child,
    wp::int32 var_type,
    wp::array_t<wp::float32> var_joint_q,
    wp::array_t<wp::float32> var_joint_qd,
    wp::array_t<wp::float32> var_joint_qdd,
    wp::int32 var_coord_start,
    wp::int32 var_dof_start,
    wp::int32 var_lin_axis_count,
    wp::int32 var_ang_axis_count,
    wp::float32 var_dt,
    wp::array_t<wp::float32> var_joint_q_new,
    wp::array_t<wp::float32> var_joint_qd_new)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 3;
    bool var_1;
    bool var_2;
    const wp::int32 var_3 = 0;
    bool var_4;
    const wp::int32 var_5 = 1;
    bool var_6;
    wp::float32* var_7;
    wp::float32 var_8;
    wp::float32 var_9;
    wp::float32* var_10;
    wp::float32 var_11;
    wp::float32 var_12;
    wp::float32* var_13;
    wp::float32 var_14;
    wp::float32 var_15;
    wp::float32 var_16;
    wp::float32 var_17;
    wp::float32 var_18;
    wp::float32 var_19;
    const wp::int32 var_20 = 2;
    bool var_21;
    const wp::int32 var_22 = 0;
    wp::int32 var_23;
    wp::float32* var_24;
    const wp::int32 var_25 = 1;
    wp::int32 var_26;
    wp::float32* var_27;
    const wp::int32 var_28 = 2;
    wp::int32 var_29;
    wp::float32* var_30;
    wp::vec_t<3, wp::float32> var_31;
    wp::float32 var_32;
    wp::float32 var_33;
    wp::float32 var_34;
    const wp::int32 var_35 = 0;
    wp::int32 var_36;
    wp::float32* var_37;
    const wp::int32 var_38 = 1;
    wp::int32 var_39;
    wp::float32* var_40;
    const wp::int32 var_41 = 2;
    wp::int32 var_42;
    wp::float32* var_43;
    wp::vec_t<3, wp::float32> var_44;
    wp::float32 var_45;
    wp::float32 var_46;
    wp::float32 var_47;
    const wp::int32 var_48 = 0;
    wp::int32 var_49;
    wp::float32* var_50;
    const wp::int32 var_51 = 1;
    wp::int32 var_52;
    wp::float32* var_53;
    const wp::int32 var_54 = 2;
    wp::int32 var_55;
    wp::float32* var_56;
    const wp::int32 var_57 = 3;
    wp::int32 var_58;
    wp::float32* var_59;
    wp::quat_t<wp::float32> var_60;
    wp::float32 var_61;
    wp::float32 var_62;
    wp::float32 var_63;
    wp::float32 var_64;
    wp::vec_t<3, wp::float32> var_65;
    wp::vec_t<3, wp::float32> var_66;
    const wp::float32 var_67 = 0.0;
    wp::quat_t<wp::float32> var_68;
    wp::quat_t<wp::float32> var_69;
    const wp::float32 var_70 = 0.5;
    wp::quat_t<wp::float32> var_71;
    wp::quat_t<wp::float32> var_72;
    wp::quat_t<wp::float32> var_73;
    wp::quat_t<wp::float32> var_74;
    const wp::int32 var_75 = 0;
    wp::float32 var_76;
    const wp::int32 var_77 = 0;
    wp::int32 var_78;
    const wp::int32 var_79 = 1;
    wp::float32 var_80;
    const wp::int32 var_81 = 1;
    wp::int32 var_82;
    const wp::int32 var_83 = 2;
    wp::float32 var_84;
    const wp::int32 var_85 = 2;
    wp::int32 var_86;
    const wp::int32 var_87 = 3;
    wp::float32 var_88;
    const wp::int32 var_89 = 3;
    wp::int32 var_90;
    const wp::int32 var_91 = 0;
    wp::float32 var_92;
    const wp::int32 var_93 = 0;
    wp::int32 var_94;
    const wp::int32 var_95 = 1;
    wp::float32 var_96;
    const wp::int32 var_97 = 1;
    wp::int32 var_98;
    const wp::int32 var_99 = 2;
    wp::float32 var_100;
    const wp::int32 var_101 = 2;
    wp::int32 var_102;
    bool var_103;
    const wp::int32 var_104 = 4;
    bool var_105;
    const wp::int32 var_106 = 5;
    bool var_107;
    const wp::int32 var_108 = 0;
    bool var_109;
    const wp::int32 var_110 = 0;
    wp::int32 var_111;
    wp::float32* var_112;
    const wp::int32 var_113 = 1;
    wp::int32 var_114;
    wp::float32* var_115;
    const wp::int32 var_116 = 2;
    wp::int32 var_117;
    wp::float32* var_118;
    wp::vec_t<3, wp::float32> var_119;
    wp::float32 var_120;
    wp::float32 var_121;
    wp::float32 var_122;
    const wp::int32 var_123 = 3;
    wp::int32 var_124;
    wp::float32* var_125;
    const wp::int32 var_126 = 4;
    wp::int32 var_127;
    wp::float32* var_128;
    const wp::int32 var_129 = 5;
    wp::int32 var_130;
    wp::float32* var_131;
    wp::vec_t<3, wp::float32> var_132;
    wp::float32 var_133;
    wp::float32 var_134;
    wp::float32 var_135;
    const wp::int32 var_136 = 0;
    wp::int32 var_137;
    wp::float32* var_138;
    const wp::int32 var_139 = 1;
    wp::int32 var_140;
    wp::float32* var_141;
    const wp::int32 var_142 = 2;
    wp::int32 var_143;
    wp::float32* var_144;
    wp::vec_t<3, wp::float32> var_145;
    wp::float32 var_146;
    wp::float32 var_147;
    wp::float32 var_148;
    const wp::int32 var_149 = 3;
    wp::int32 var_150;
    wp::float32* var_151;
    const wp::int32 var_152 = 4;
    wp::int32 var_153;
    wp::float32* var_154;
    const wp::int32 var_155 = 5;
    wp::int32 var_156;
    wp::float32* var_157;
    wp::vec_t<3, wp::float32> var_158;
    wp::float32 var_159;
    wp::float32 var_160;
    wp::float32 var_161;
    const wp::int32 var_162 = 0;
    wp::int32 var_163;
    wp::float32* var_164;
    const wp::int32 var_165 = 1;
    wp::int32 var_166;
    wp::float32* var_167;
    const wp::int32 var_168 = 2;
    wp::int32 var_169;
    wp::float32* var_170;
    wp::vec_t<3, wp::float32> var_171;
    wp::float32 var_172;
    wp::float32 var_173;
    wp::float32 var_174;
    const wp::int32 var_175 = 3;
    wp::int32 var_176;
    wp::float32* var_177;
    const wp::int32 var_178 = 4;
    wp::int32 var_179;
    wp::float32* var_180;
    const wp::int32 var_181 = 5;
    wp::int32 var_182;
    wp::float32* var_183;
    const wp::int32 var_184 = 6;
    wp::int32 var_185;
    wp::float32* var_186;
    wp::quat_t<wp::float32> var_187;
    wp::float32 var_188;
    wp::float32 var_189;
    wp::float32 var_190;
    wp::float32 var_191;
    wp::transform_t<wp::float32> var_192;
    wp::vec_t<3, wp::float32> var_193;
    wp::vec_t<3, wp::float32> var_194;
    wp::vec_t<3, wp::float32> var_195;
    wp::vec_t<3, wp::float32> var_196;
    wp::vec_t<3, wp::float32> var_197;
    wp::vec_t<3, wp::float32> var_198;
    wp::vec_t<3, wp::float32> var_199;
    wp::vec_t<3, wp::float32> var_200;
    wp::vec_t<3, wp::float32> var_201;
    wp::vec_t<3, wp::float32> var_202;
    wp::vec_t<3, wp::float32> var_203;
    wp::vec_t<3, wp::float32> var_204;
    wp::vec_t<3, wp::float32> var_205;
    const wp::float32 var_206 = 0.0;
    wp::quat_t<wp::float32> var_207;
    wp::quat_t<wp::float32> var_208;
    const wp::float32 var_209 = 0.5;
    wp::quat_t<wp::float32> var_210;
    wp::quat_t<wp::float32> var_211;
    wp::quat_t<wp::float32> var_212;
    wp::quat_t<wp::float32> var_213;
    wp::vec_t<3, wp::float32> var_214;
    wp::vec_t<3, wp::float32> var_215;
    wp::vec_t<3, wp::float32> var_216;
    wp::vec_t<3, wp::float32> var_217;
    wp::vec_t<3, wp::float32> var_218;
    wp::vec_t<3, wp::float32> var_219;
    const wp::int32 var_220 = 0;
    wp::float32 var_221;
    const wp::int32 var_222 = 0;
    wp::int32 var_223;
    const wp::int32 var_224 = 1;
    wp::float32 var_225;
    const wp::int32 var_226 = 1;
    wp::int32 var_227;
    const wp::int32 var_228 = 2;
    wp::float32 var_229;
    const wp::int32 var_230 = 2;
    wp::int32 var_231;
    const wp::int32 var_232 = 0;
    wp::float32 var_233;
    const wp::int32 var_234 = 3;
    wp::int32 var_235;
    const wp::int32 var_236 = 1;
    wp::float32 var_237;
    const wp::int32 var_238 = 4;
    wp::int32 var_239;
    const wp::int32 var_240 = 2;
    wp::float32 var_241;
    const wp::int32 var_242 = 5;
    wp::int32 var_243;
    const wp::int32 var_244 = 3;
    wp::float32 var_245;
    const wp::int32 var_246 = 6;
    wp::int32 var_247;
    const wp::int32 var_248 = 0;
    wp::float32 var_249;
    const wp::int32 var_250 = 0;
    wp::int32 var_251;
    const wp::int32 var_252 = 1;
    wp::float32 var_253;
    const wp::int32 var_254 = 1;
    wp::int32 var_255;
    const wp::int32 var_256 = 2;
    wp::float32 var_257;
    const wp::int32 var_258 = 2;
    wp::int32 var_259;
    const wp::int32 var_260 = 0;
    wp::float32 var_261;
    const wp::int32 var_262 = 3;
    wp::int32 var_263;
    const wp::int32 var_264 = 1;
    wp::float32 var_265;
    const wp::int32 var_266 = 4;
    wp::int32 var_267;
    const wp::int32 var_268 = 2;
    wp::float32 var_269;
    const wp::int32 var_270 = 5;
    wp::int32 var_271;
    const wp::int32 var_272 = 0;
    wp::int32 var_273;
    wp::float32* var_274;
    const wp::int32 var_275 = 1;
    wp::int32 var_276;
    wp::float32* var_277;
    const wp::int32 var_278 = 2;
    wp::int32 var_279;
    wp::float32* var_280;
    wp::vec_t<3, wp::float32> var_281;
    wp::float32 var_282;
    wp::float32 var_283;
    wp::float32 var_284;
    const wp::int32 var_285 = 3;
    wp::int32 var_286;
    wp::float32* var_287;
    const wp::int32 var_288 = 4;
    wp::int32 var_289;
    wp::float32* var_290;
    const wp::int32 var_291 = 5;
    wp::int32 var_292;
    wp::float32* var_293;
    wp::vec_t<3, wp::float32> var_294;
    wp::float32 var_295;
    wp::float32 var_296;
    wp::float32 var_297;
    const wp::int32 var_298 = 0;
    wp::int32 var_299;
    wp::float32* var_300;
    const wp::int32 var_301 = 1;
    wp::int32 var_302;
    wp::float32* var_303;
    const wp::int32 var_304 = 2;
    wp::int32 var_305;
    wp::float32* var_306;
    wp::vec_t<3, wp::float32> var_307;
    wp::float32 var_308;
    wp::float32 var_309;
    wp::float32 var_310;
    const wp::int32 var_311 = 3;
    wp::int32 var_312;
    wp::float32* var_313;
    const wp::int32 var_314 = 4;
    wp::int32 var_315;
    wp::float32* var_316;
    const wp::int32 var_317 = 5;
    wp::int32 var_318;
    wp::float32* var_319;
    wp::vec_t<3, wp::float32> var_320;
    wp::float32 var_321;
    wp::float32 var_322;
    wp::float32 var_323;
    wp::vec_t<3, wp::float32> var_324;
    wp::vec_t<3, wp::float32> var_325;
    wp::vec_t<3, wp::float32> var_326;
    wp::vec_t<3, wp::float32> var_327;
    const wp::int32 var_328 = 0;
    wp::int32 var_329;
    wp::float32* var_330;
    const wp::int32 var_331 = 1;
    wp::int32 var_332;
    wp::float32* var_333;
    const wp::int32 var_334 = 2;
    wp::int32 var_335;
    wp::float32* var_336;
    wp::vec_t<3, wp::float32> var_337;
    wp::float32 var_338;
    wp::float32 var_339;
    wp::float32 var_340;
    wp::vec_t<3, wp::float32> var_341;
    wp::vec_t<3, wp::float32> var_342;
    const wp::int32 var_343 = 3;
    wp::int32 var_344;
    wp::float32* var_345;
    const wp::int32 var_346 = 4;
    wp::int32 var_347;
    wp::float32* var_348;
    const wp::int32 var_349 = 5;
    wp::int32 var_350;
    wp::float32* var_351;
    const wp::int32 var_352 = 6;
    wp::int32 var_353;
    wp::float32* var_354;
    wp::quat_t<wp::float32> var_355;
    wp::float32 var_356;
    wp::float32 var_357;
    wp::float32 var_358;
    wp::float32 var_359;
    const wp::float32 var_360 = 0.0;
    wp::quat_t<wp::float32> var_361;
    wp::quat_t<wp::float32> var_362;
    const wp::float32 var_363 = 0.5;
    wp::quat_t<wp::float32> var_364;
    wp::vec_t<3, wp::float32> var_365;
    wp::vec_t<3, wp::float32> var_366;
    wp::quat_t<wp::float32> var_367;
    wp::quat_t<wp::float32> var_368;
    wp::quat_t<wp::float32> var_369;
    const wp::int32 var_370 = 0;
    wp::float32 var_371;
    const wp::int32 var_372 = 0;
    wp::int32 var_373;
    const wp::int32 var_374 = 1;
    wp::float32 var_375;
    const wp::int32 var_376 = 1;
    wp::int32 var_377;
    const wp::int32 var_378 = 2;
    wp::float32 var_379;
    const wp::int32 var_380 = 2;
    wp::int32 var_381;
    const wp::int32 var_382 = 0;
    wp::float32 var_383;
    const wp::int32 var_384 = 3;
    wp::int32 var_385;
    const wp::int32 var_386 = 1;
    wp::float32 var_387;
    const wp::int32 var_388 = 4;
    wp::int32 var_389;
    const wp::int32 var_390 = 2;
    wp::float32 var_391;
    const wp::int32 var_392 = 5;
    wp::int32 var_393;
    const wp::int32 var_394 = 3;
    wp::float32 var_395;
    const wp::int32 var_396 = 6;
    wp::int32 var_397;
    const wp::int32 var_398 = 0;
    wp::float32 var_399;
    const wp::int32 var_400 = 0;
    wp::int32 var_401;
    const wp::int32 var_402 = 1;
    wp::float32 var_403;
    const wp::int32 var_404 = 1;
    wp::int32 var_405;
    const wp::int32 var_406 = 2;
    wp::float32 var_407;
    const wp::int32 var_408 = 2;
    wp::int32 var_409;
    const wp::int32 var_410 = 0;
    wp::float32 var_411;
    const wp::int32 var_412 = 3;
    wp::int32 var_413;
    const wp::int32 var_414 = 1;
    wp::float32 var_415;
    const wp::int32 var_416 = 4;
    wp::int32 var_417;
    const wp::int32 var_418 = 2;
    wp::float32 var_419;
    const wp::int32 var_420 = 5;
    wp::int32 var_421;
    const wp::int32 var_422 = 6;
    bool var_423;
    wp::int32 var_424;
    wp::range_t var_425;
    wp::int32 var_426;
    wp::int32 var_427;
    wp::float32* var_428;
    wp::float32 var_429;
    wp::float32 var_430;
    wp::int32 var_431;
    wp::float32* var_432;
    wp::float32 var_433;
    wp::float32 var_434;
    wp::int32 var_435;
    wp::float32* var_436;
    wp::float32 var_437;
    wp::float32 var_438;
    wp::float32 var_439;
    wp::float32 var_440;
    wp::float32 var_441;
    wp::float32 var_442;
    wp::int32 var_443;
    wp::int32 var_444;
    //---------
    // forward
    // def jcalc_integrate(                                                                   <L 465>
    // if type == JointType.FIXED:                                                            <L 482>
    var_1 = (var_type == var_0);
    if (var_1) {
        // return                                                                             <L 483>
        return;
    }
    // if type == JointType.PRISMATIC or type == JointType.REVOLUTE:                          <L 486>
    var_4 = (var_type == var_3);
    var_2 = var_4;
    if (!var_2) {
        var_6 = (var_type == var_5);
        var_2 = var_2 || var_6;
    }
    if (var_2) {
        // qdd = joint_qdd[dof_start]                                                         <L 487>
        var_7 = wp::address(var_joint_qdd, var_dof_start);
        var_9 = wp::load(var_7);
        var_8 = wp::copy(var_9);
        // qd = joint_qd[dof_start]                                                           <L 488>
        var_10 = wp::address(var_joint_qd, var_dof_start);
        var_12 = wp::load(var_10);
        var_11 = wp::copy(var_12);
        // q = joint_q[coord_start]                                                           <L 489>
        var_13 = wp::address(var_joint_q, var_coord_start);
        var_15 = wp::load(var_13);
        var_14 = wp::copy(var_15);
        // qd_new = qd + qdd * dt                                                             <L 491>
        var_16 = wp::mul(var_8, var_dt);
        var_17 = wp::add(var_11, var_16);
        // q_new = q + qd_new * dt                                                            <L 492>
        var_18 = wp::mul(var_17, var_dt);
        var_19 = wp::add(var_14, var_18);
        // joint_qd_new[dof_start] = qd_new                                                   <L 494>
        wp::array_store(var_joint_qd_new, var_dof_start, var_17);
        // joint_q_new[coord_start] = q_new                                                   <L 495>
        wp::array_store(var_joint_q_new, var_coord_start, var_19);
        // return                                                                             <L 497>
        return;
    }
    // if type == JointType.BALL:                                                             <L 500>
    var_21 = (var_type == var_20);
    if (var_21) {
        // m_j = wp.vec3(joint_qdd[dof_start + 0], joint_qdd[dof_start + 1], joint_qdd[dof_start + 2])       <L 501>
        var_23 = wp::add(var_dof_start, var_22);
        var_24 = wp::address(var_joint_qdd, var_23);
        var_26 = wp::add(var_dof_start, var_25);
        var_27 = wp::address(var_joint_qdd, var_26);
        var_29 = wp::add(var_dof_start, var_28);
        var_30 = wp::address(var_joint_qdd, var_29);
        var_32 = wp::load(var_24);
        var_33 = wp::load(var_27);
        var_34 = wp::load(var_30);
        var_31 = wp::vec_t<3, wp::float32>(var_32, var_33, var_34);
        // w_j = wp.vec3(joint_qd[dof_start + 0], joint_qd[dof_start + 1], joint_qd[dof_start + 2])       <L 502>
        var_36 = wp::add(var_dof_start, var_35);
        var_37 = wp::address(var_joint_qd, var_36);
        var_39 = wp::add(var_dof_start, var_38);
        var_40 = wp::address(var_joint_qd, var_39);
        var_42 = wp::add(var_dof_start, var_41);
        var_43 = wp::address(var_joint_qd, var_42);
        var_45 = wp::load(var_37);
        var_46 = wp::load(var_40);
        var_47 = wp::load(var_43);
        var_44 = wp::vec_t<3, wp::float32>(var_45, var_46, var_47);
        // r_j = wp.quat(                                                                     <L 504>
        // joint_q[coord_start + 0], joint_q[coord_start + 1], joint_q[coord_start + 2], joint_q[coord_start + 3]       <L 505>
        var_49 = wp::add(var_coord_start, var_48);
        var_50 = wp::address(var_joint_q, var_49);
        var_52 = wp::add(var_coord_start, var_51);
        var_53 = wp::address(var_joint_q, var_52);
        var_55 = wp::add(var_coord_start, var_54);
        var_56 = wp::address(var_joint_q, var_55);
        var_58 = wp::add(var_coord_start, var_57);
        var_59 = wp::address(var_joint_q, var_58);
        var_61 = wp::load(var_50);
        var_62 = wp::load(var_53);
        var_63 = wp::load(var_56);
        var_64 = wp::load(var_59);
        var_60 = wp::quat_t<wp::float32>(var_61, var_62, var_63, var_64);
        // w_j_new = w_j + m_j * dt                                                           <L 509>
        var_65 = wp::mul(var_31, var_dt);
        var_66 = wp::add(var_44, var_65);
        // drdt_j = wp.quat(w_j_new, 0.0) * r_j * 0.5                                         <L 511>
        var_68 = wp::quat_t<wp::float32>(var_66, var_67);
        var_69 = wp::mul(var_68, var_60);
        var_71 = wp::mul(var_69, var_70);
        // r_j_new = wp.normalize(r_j + drdt_j * dt)                                          <L 514>
        var_72 = wp::mul(var_71, var_dt);
        var_73 = wp::add(var_60, var_72);
        var_74 = wp::normalize(var_73);
        // joint_q_new[coord_start + 0] = r_j_new[0]                                          <L 517>
        var_76 = wp::extract(var_74, var_75);
        var_78 = wp::add(var_coord_start, var_77);
        wp::array_store(var_joint_q_new, var_78, var_76);
        // joint_q_new[coord_start + 1] = r_j_new[1]                                          <L 518>
        var_80 = wp::extract(var_74, var_79);
        var_82 = wp::add(var_coord_start, var_81);
        wp::array_store(var_joint_q_new, var_82, var_80);
        // joint_q_new[coord_start + 2] = r_j_new[2]                                          <L 519>
        var_84 = wp::extract(var_74, var_83);
        var_86 = wp::add(var_coord_start, var_85);
        wp::array_store(var_joint_q_new, var_86, var_84);
        // joint_q_new[coord_start + 3] = r_j_new[3]                                          <L 520>
        var_88 = wp::extract(var_74, var_87);
        var_90 = wp::add(var_coord_start, var_89);
        wp::array_store(var_joint_q_new, var_90, var_88);
        // joint_qd_new[dof_start + 0] = w_j_new[0]                                           <L 523>
        var_92 = wp::extract(var_66, var_91);
        var_94 = wp::add(var_dof_start, var_93);
        wp::array_store(var_joint_qd_new, var_94, var_92);
        // joint_qd_new[dof_start + 1] = w_j_new[1]                                           <L 524>
        var_96 = wp::extract(var_66, var_95);
        var_98 = wp::add(var_dof_start, var_97);
        wp::array_store(var_joint_qd_new, var_98, var_96);
        // joint_qd_new[dof_start + 2] = w_j_new[2]                                           <L 525>
        var_100 = wp::extract(var_66, var_99);
        var_102 = wp::add(var_dof_start, var_101);
        wp::array_store(var_joint_qd_new, var_102, var_100);
        // return                                                                             <L 527>
        return;
    }
    // if type == JointType.FREE or type == JointType.DISTANCE:                               <L 529>
    var_105 = (var_type == var_104);
    var_103 = var_105;
    if (!var_103) {
        var_107 = (var_type == var_106);
        var_103 = var_103 || var_107;
    }
    if (var_103) {
        // if parent < 0:                                                                     <L 530>
        var_109 = (var_parent < var_108);
        if (var_109) {
            // a_parent = wp.vec3(joint_qdd[dof_start + 0], joint_qdd[dof_start + 1], joint_qdd[dof_start + 2])       <L 531>
            var_111 = wp::add(var_dof_start, var_110);
            var_112 = wp::address(var_joint_qdd, var_111);
            var_114 = wp::add(var_dof_start, var_113);
            var_115 = wp::address(var_joint_qdd, var_114);
            var_117 = wp::add(var_dof_start, var_116);
            var_118 = wp::address(var_joint_qdd, var_117);
            var_120 = wp::load(var_112);
            var_121 = wp::load(var_115);
            var_122 = wp::load(var_118);
            var_119 = wp::vec_t<3, wp::float32>(var_120, var_121, var_122);
            // alpha = wp.vec3(joint_qdd[dof_start + 3], joint_qdd[dof_start + 4], joint_qdd[dof_start + 5])       <L 532>
            var_124 = wp::add(var_dof_start, var_123);
            var_125 = wp::address(var_joint_qdd, var_124);
            var_127 = wp::add(var_dof_start, var_126);
            var_128 = wp::address(var_joint_qdd, var_127);
            var_130 = wp::add(var_dof_start, var_129);
            var_131 = wp::address(var_joint_qdd, var_130);
            var_133 = wp::load(var_125);
            var_134 = wp::load(var_128);
            var_135 = wp::load(var_131);
            var_132 = wp::vec_t<3, wp::float32>(var_133, var_134, var_135);
            // v_parent = wp.vec3(joint_qd[dof_start + 0], joint_qd[dof_start + 1], joint_qd[dof_start + 2])       <L 534>
            var_137 = wp::add(var_dof_start, var_136);
            var_138 = wp::address(var_joint_qd, var_137);
            var_140 = wp::add(var_dof_start, var_139);
            var_141 = wp::address(var_joint_qd, var_140);
            var_143 = wp::add(var_dof_start, var_142);
            var_144 = wp::address(var_joint_qd, var_143);
            var_146 = wp::load(var_138);
            var_147 = wp::load(var_141);
            var_148 = wp::load(var_144);
            var_145 = wp::vec_t<3, wp::float32>(var_146, var_147, var_148);
            // omega = wp.vec3(joint_qd[dof_start + 3], joint_qd[dof_start + 4], joint_qd[dof_start + 5])       <L 535>
            var_150 = wp::add(var_dof_start, var_149);
            var_151 = wp::address(var_joint_qd, var_150);
            var_153 = wp::add(var_dof_start, var_152);
            var_154 = wp::address(var_joint_qd, var_153);
            var_156 = wp::add(var_dof_start, var_155);
            var_157 = wp::address(var_joint_qd, var_156);
            var_159 = wp::load(var_151);
            var_160 = wp::load(var_154);
            var_161 = wp::load(var_157);
            var_158 = wp::vec_t<3, wp::float32>(var_159, var_160, var_161);
            // p = wp.vec3(joint_q[coord_start + 0], joint_q[coord_start + 1], joint_q[coord_start + 2])       <L 537>
            var_163 = wp::add(var_coord_start, var_162);
            var_164 = wp::address(var_joint_q, var_163);
            var_166 = wp::add(var_coord_start, var_165);
            var_167 = wp::address(var_joint_q, var_166);
            var_169 = wp::add(var_coord_start, var_168);
            var_170 = wp::address(var_joint_q, var_169);
            var_172 = wp::load(var_164);
            var_173 = wp::load(var_167);
            var_174 = wp::load(var_170);
            var_171 = wp::vec_t<3, wp::float32>(var_172, var_173, var_174);
            // r = wp.quat(                                                                   <L 538>
            // joint_q[coord_start + 3], joint_q[coord_start + 4], joint_q[coord_start + 5], joint_q[coord_start + 6]       <L 539>
            var_176 = wp::add(var_coord_start, var_175);
            var_177 = wp::address(var_joint_q, var_176);
            var_179 = wp::add(var_coord_start, var_178);
            var_180 = wp::address(var_joint_q, var_179);
            var_182 = wp::add(var_coord_start, var_181);
            var_183 = wp::address(var_joint_q, var_182);
            var_185 = wp::add(var_coord_start, var_184);
            var_186 = wp::address(var_joint_q, var_185);
            var_188 = wp::load(var_177);
            var_189 = wp::load(var_180);
            var_190 = wp::load(var_183);
            var_191 = wp::load(var_186);
            var_187 = wp::quat_t<wp::float32>(var_188, var_189, var_190, var_191);
            // r_com_joint = wp.transform_point(wp.transform_inverse(joint_X_c), body_com_child)       <L 542>
            var_192 = wp::transform_inverse(var_joint_X_c);
            var_193 = wp::transform_point(var_192, var_body_com_child);
            // x_com = p + wp.quat_rotate(r, r_com_joint)                                     <L 543>
            var_194 = wp::quat_rotate(var_187, var_193);
            var_195 = wp::add(var_171, var_194);
            // v_com = v_parent + wp.cross(omega, x_com)                                      <L 544>
            var_196 = wp::cross(var_158, var_195);
            var_197 = wp::add(var_145, var_196);
            // a_com = a_parent + wp.cross(alpha, x_com) + wp.cross(omega, v_com)             <L 545>
            var_198 = wp::cross(var_132, var_195);
            var_199 = wp::add(var_119, var_198);
            var_200 = wp::cross(var_158, var_197);
            var_201 = wp::add(var_199, var_200);
            // omega_new = omega + alpha * dt                                                 <L 547>
            var_202 = wp::mul(var_132, var_dt);
            var_203 = wp::add(var_158, var_202);
            // v_com_new = v_com + a_com * dt                                                 <L 548>
            var_204 = wp::mul(var_201, var_dt);
            var_205 = wp::add(var_197, var_204);
            // drdt = wp.quat(omega_new, 0.0) * r * 0.5                                       <L 550>
            var_207 = wp::quat_t<wp::float32>(var_203, var_206);
            var_208 = wp::mul(var_207, var_187);
            var_210 = wp::mul(var_208, var_209);
            // r_new = wp.normalize(r + drdt * dt)                                            <L 551>
            var_211 = wp::mul(var_210, var_dt);
            var_212 = wp::add(var_187, var_211);
            var_213 = wp::normalize(var_212);
            // x_com_new = x_com + v_com_new * dt                                             <L 552>
            var_214 = wp::mul(var_205, var_dt);
            var_215 = wp::add(var_195, var_214);
            // p_new = x_com_new - wp.quat_rotate(r_new, r_com_joint)                         <L 553>
            var_216 = wp::quat_rotate(var_213, var_193);
            var_217 = wp::sub(var_215, var_216);
            // v_parent_new = v_com_new - wp.cross(omega_new, x_com_new)                      <L 554>
            var_218 = wp::cross(var_203, var_215);
            var_219 = wp::sub(var_205, var_218);
            // joint_q_new[coord_start + 0] = p_new[0]                                        <L 556>
            var_221 = wp::extract(var_217, var_220);
            var_223 = wp::add(var_coord_start, var_222);
            wp::array_store(var_joint_q_new, var_223, var_221);
            // joint_q_new[coord_start + 1] = p_new[1]                                        <L 557>
            var_225 = wp::extract(var_217, var_224);
            var_227 = wp::add(var_coord_start, var_226);
            wp::array_store(var_joint_q_new, var_227, var_225);
            // joint_q_new[coord_start + 2] = p_new[2]                                        <L 558>
            var_229 = wp::extract(var_217, var_228);
            var_231 = wp::add(var_coord_start, var_230);
            wp::array_store(var_joint_q_new, var_231, var_229);
            // joint_q_new[coord_start + 3] = r_new[0]                                        <L 560>
            var_233 = wp::extract(var_213, var_232);
            var_235 = wp::add(var_coord_start, var_234);
            wp::array_store(var_joint_q_new, var_235, var_233);
            // joint_q_new[coord_start + 4] = r_new[1]                                        <L 561>
            var_237 = wp::extract(var_213, var_236);
            var_239 = wp::add(var_coord_start, var_238);
            wp::array_store(var_joint_q_new, var_239, var_237);
            // joint_q_new[coord_start + 5] = r_new[2]                                        <L 562>
            var_241 = wp::extract(var_213, var_240);
            var_243 = wp::add(var_coord_start, var_242);
            wp::array_store(var_joint_q_new, var_243, var_241);
            // joint_q_new[coord_start + 6] = r_new[3]                                        <L 563>
            var_245 = wp::extract(var_213, var_244);
            var_247 = wp::add(var_coord_start, var_246);
            wp::array_store(var_joint_q_new, var_247, var_245);
            // joint_qd_new[dof_start + 0] = v_parent_new[0]                                  <L 565>
            var_249 = wp::extract(var_219, var_248);
            var_251 = wp::add(var_dof_start, var_250);
            wp::array_store(var_joint_qd_new, var_251, var_249);
            // joint_qd_new[dof_start + 1] = v_parent_new[1]                                  <L 566>
            var_253 = wp::extract(var_219, var_252);
            var_255 = wp::add(var_dof_start, var_254);
            wp::array_store(var_joint_qd_new, var_255, var_253);
            // joint_qd_new[dof_start + 2] = v_parent_new[2]                                  <L 567>
            var_257 = wp::extract(var_219, var_256);
            var_259 = wp::add(var_dof_start, var_258);
            wp::array_store(var_joint_qd_new, var_259, var_257);
            // joint_qd_new[dof_start + 3] = omega_new[0]                                     <L 568>
            var_261 = wp::extract(var_203, var_260);
            var_263 = wp::add(var_dof_start, var_262);
            wp::array_store(var_joint_qd_new, var_263, var_261);
            // joint_qd_new[dof_start + 4] = omega_new[1]                                     <L 569>
            var_265 = wp::extract(var_203, var_264);
            var_267 = wp::add(var_dof_start, var_266);
            wp::array_store(var_joint_qd_new, var_267, var_265);
            // joint_qd_new[dof_start + 5] = omega_new[2]                                     <L 570>
            var_269 = wp::extract(var_203, var_268);
            var_271 = wp::add(var_dof_start, var_270);
            wp::array_store(var_joint_qd_new, var_271, var_269);
            // return                                                                         <L 571>
            return;
        }
        // a_s = wp.vec3(joint_qdd[dof_start + 0], joint_qdd[dof_start + 1], joint_qdd[dof_start + 2])       <L 573>
        var_273 = wp::add(var_dof_start, var_272);
        var_274 = wp::address(var_joint_qdd, var_273);
        var_276 = wp::add(var_dof_start, var_275);
        var_277 = wp::address(var_joint_qdd, var_276);
        var_279 = wp::add(var_dof_start, var_278);
        var_280 = wp::address(var_joint_qdd, var_279);
        var_282 = wp::load(var_274);
        var_283 = wp::load(var_277);
        var_284 = wp::load(var_280);
        var_281 = wp::vec_t<3, wp::float32>(var_282, var_283, var_284);
        // m_s = wp.vec3(joint_qdd[dof_start + 3], joint_qdd[dof_start + 4], joint_qdd[dof_start + 5])       <L 574>
        var_286 = wp::add(var_dof_start, var_285);
        var_287 = wp::address(var_joint_qdd, var_286);
        var_289 = wp::add(var_dof_start, var_288);
        var_290 = wp::address(var_joint_qdd, var_289);
        var_292 = wp::add(var_dof_start, var_291);
        var_293 = wp::address(var_joint_qdd, var_292);
        var_295 = wp::load(var_287);
        var_296 = wp::load(var_290);
        var_297 = wp::load(var_293);
        var_294 = wp::vec_t<3, wp::float32>(var_295, var_296, var_297);
        // v_s = wp.vec3(joint_qd[dof_start + 0], joint_qd[dof_start + 1], joint_qd[dof_start + 2])       <L 576>
        var_299 = wp::add(var_dof_start, var_298);
        var_300 = wp::address(var_joint_qd, var_299);
        var_302 = wp::add(var_dof_start, var_301);
        var_303 = wp::address(var_joint_qd, var_302);
        var_305 = wp::add(var_dof_start, var_304);
        var_306 = wp::address(var_joint_qd, var_305);
        var_308 = wp::load(var_300);
        var_309 = wp::load(var_303);
        var_310 = wp::load(var_306);
        var_307 = wp::vec_t<3, wp::float32>(var_308, var_309, var_310);
        // w_s = wp.vec3(joint_qd[dof_start + 3], joint_qd[dof_start + 4], joint_qd[dof_start + 5])       <L 577>
        var_312 = wp::add(var_dof_start, var_311);
        var_313 = wp::address(var_joint_qd, var_312);
        var_315 = wp::add(var_dof_start, var_314);
        var_316 = wp::address(var_joint_qd, var_315);
        var_318 = wp::add(var_dof_start, var_317);
        var_319 = wp::address(var_joint_qd, var_318);
        var_321 = wp::load(var_313);
        var_322 = wp::load(var_316);
        var_323 = wp::load(var_319);
        var_320 = wp::vec_t<3, wp::float32>(var_321, var_322, var_323);
        // w_s = w_s + m_s * dt                                                               <L 582>
        var_324 = wp::mul(var_294, var_dt);
        var_325 = wp::add(var_320, var_324);
        // v_s = v_s + a_s * dt                                                               <L 583>
        var_326 = wp::mul(var_281, var_dt);
        var_327 = wp::add(var_307, var_326);
        // p_s = wp.vec3(joint_q[coord_start + 0], joint_q[coord_start + 1], joint_q[coord_start + 2])       <L 585>
        var_329 = wp::add(var_coord_start, var_328);
        var_330 = wp::address(var_joint_q, var_329);
        var_332 = wp::add(var_coord_start, var_331);
        var_333 = wp::address(var_joint_q, var_332);
        var_335 = wp::add(var_coord_start, var_334);
        var_336 = wp::address(var_joint_q, var_335);
        var_338 = wp::load(var_330);
        var_339 = wp::load(var_333);
        var_340 = wp::load(var_336);
        var_337 = wp::vec_t<3, wp::float32>(var_338, var_339, var_340);
        // dpdt_s = v_s + wp.cross(w_s, p_s)                                                  <L 587>
        var_341 = wp::cross(var_325, var_337);
        var_342 = wp::add(var_327, var_341);
        // r_s = wp.quat(                                                                     <L 588>
        // joint_q[coord_start + 3], joint_q[coord_start + 4], joint_q[coord_start + 5], joint_q[coord_start + 6]       <L 589>
        var_344 = wp::add(var_coord_start, var_343);
        var_345 = wp::address(var_joint_q, var_344);
        var_347 = wp::add(var_coord_start, var_346);
        var_348 = wp::address(var_joint_q, var_347);
        var_350 = wp::add(var_coord_start, var_349);
        var_351 = wp::address(var_joint_q, var_350);
        var_353 = wp::add(var_coord_start, var_352);
        var_354 = wp::address(var_joint_q, var_353);
        var_356 = wp::load(var_345);
        var_357 = wp::load(var_348);
        var_358 = wp::load(var_351);
        var_359 = wp::load(var_354);
        var_355 = wp::quat_t<wp::float32>(var_356, var_357, var_358, var_359);
        // drdt_s = wp.quat(w_s, 0.0) * r_s * 0.5                                             <L 592>
        var_361 = wp::quat_t<wp::float32>(var_325, var_360);
        var_362 = wp::mul(var_361, var_355);
        var_364 = wp::mul(var_362, var_363);
        // p_s_new = p_s + dpdt_s * dt                                                        <L 594>
        var_365 = wp::mul(var_342, var_dt);
        var_366 = wp::add(var_337, var_365);
        // r_s_new = wp.normalize(r_s + drdt_s * dt)                                          <L 595>
        var_367 = wp::mul(var_364, var_dt);
        var_368 = wp::add(var_355, var_367);
        var_369 = wp::normalize(var_368);
        // joint_q_new[coord_start + 0] = p_s_new[0]                                          <L 597>
        var_371 = wp::extract(var_366, var_370);
        var_373 = wp::add(var_coord_start, var_372);
        wp::array_store(var_joint_q_new, var_373, var_371);
        // joint_q_new[coord_start + 1] = p_s_new[1]                                          <L 598>
        var_375 = wp::extract(var_366, var_374);
        var_377 = wp::add(var_coord_start, var_376);
        wp::array_store(var_joint_q_new, var_377, var_375);
        // joint_q_new[coord_start + 2] = p_s_new[2]                                          <L 599>
        var_379 = wp::extract(var_366, var_378);
        var_381 = wp::add(var_coord_start, var_380);
        wp::array_store(var_joint_q_new, var_381, var_379);
        // joint_q_new[coord_start + 3] = r_s_new[0]                                          <L 601>
        var_383 = wp::extract(var_369, var_382);
        var_385 = wp::add(var_coord_start, var_384);
        wp::array_store(var_joint_q_new, var_385, var_383);
        // joint_q_new[coord_start + 4] = r_s_new[1]                                          <L 602>
        var_387 = wp::extract(var_369, var_386);
        var_389 = wp::add(var_coord_start, var_388);
        wp::array_store(var_joint_q_new, var_389, var_387);
        // joint_q_new[coord_start + 5] = r_s_new[2]                                          <L 603>
        var_391 = wp::extract(var_369, var_390);
        var_393 = wp::add(var_coord_start, var_392);
        wp::array_store(var_joint_q_new, var_393, var_391);
        // joint_q_new[coord_start + 6] = r_s_new[3]                                          <L 604>
        var_395 = wp::extract(var_369, var_394);
        var_397 = wp::add(var_coord_start, var_396);
        wp::array_store(var_joint_q_new, var_397, var_395);
        // joint_qd_new[dof_start + 0] = v_s[0]                                               <L 606>
        var_399 = wp::extract(var_327, var_398);
        var_401 = wp::add(var_dof_start, var_400);
        wp::array_store(var_joint_qd_new, var_401, var_399);
        // joint_qd_new[dof_start + 1] = v_s[1]                                               <L 607>
        var_403 = wp::extract(var_327, var_402);
        var_405 = wp::add(var_dof_start, var_404);
        wp::array_store(var_joint_qd_new, var_405, var_403);
        // joint_qd_new[dof_start + 2] = v_s[2]                                               <L 608>
        var_407 = wp::extract(var_327, var_406);
        var_409 = wp::add(var_dof_start, var_408);
        wp::array_store(var_joint_qd_new, var_409, var_407);
        // joint_qd_new[dof_start + 3] = w_s[0]                                               <L 609>
        var_411 = wp::extract(var_325, var_410);
        var_413 = wp::add(var_dof_start, var_412);
        wp::array_store(var_joint_qd_new, var_413, var_411);
        // joint_qd_new[dof_start + 4] = w_s[1]                                               <L 610>
        var_415 = wp::extract(var_325, var_414);
        var_417 = wp::add(var_dof_start, var_416);
        wp::array_store(var_joint_qd_new, var_417, var_415);
        // joint_qd_new[dof_start + 5] = w_s[2]                                               <L 611>
        var_419 = wp::extract(var_325, var_418);
        var_421 = wp::add(var_dof_start, var_420);
        wp::array_store(var_joint_qd_new, var_421, var_419);
        // return                                                                             <L 613>
        return;
    }
    // if type == JointType.D6:                                                               <L 616>
    var_423 = (var_type == var_422);
    if (var_423) {
        // axis_count = lin_axis_count + ang_axis_count                                       <L 617>
        var_424 = wp::add(var_lin_axis_count, var_ang_axis_count);
        // for i in range(axis_count):                                                        <L 619>
        var_425 = wp::range(var_424);
        start_for_5:;
            if (iter_cmp(var_425) == 0) goto end_for_5;
            var_426 = wp::iter_next(var_425);
            // qdd = joint_qdd[dof_start + i]                                                 <L 620>
            var_427 = wp::add(var_dof_start, var_426);
            var_428 = wp::address(var_joint_qdd, var_427);
            var_430 = wp::load(var_428);
            var_429 = wp::copy(var_430);
            // qd = joint_qd[dof_start + i]                                                   <L 621>
            var_431 = wp::add(var_dof_start, var_426);
            var_432 = wp::address(var_joint_qd, var_431);
            var_434 = wp::load(var_432);
            var_433 = wp::copy(var_434);
            // q = joint_q[coord_start + i]                                                   <L 622>
            var_435 = wp::add(var_coord_start, var_426);
            var_436 = wp::address(var_joint_q, var_435);
            var_438 = wp::load(var_436);
            var_437 = wp::copy(var_438);
            // qd_new = qd + qdd * dt                                                         <L 624>
            var_439 = wp::mul(var_429, var_dt);
            var_440 = wp::add(var_433, var_439);
            // q_new = q + qd_new * dt                                                        <L 625>
            var_441 = wp::mul(var_440, var_dt);
            var_442 = wp::add(var_437, var_441);
            // joint_qd_new[dof_start + i] = qd_new                                           <L 627>
            var_443 = wp::add(var_dof_start, var_426);
            wp::array_store(var_joint_qd_new, var_443, var_440);
            // joint_q_new[coord_start + i] = q_new                                           <L 628>
            var_444 = wp::add(var_coord_start, var_426);
            wp::array_store(var_joint_q_new, var_444, var_442);
            wp::assign(var_8, var_429);
            wp::assign(var_11, var_433);
            wp::assign(var_14, var_437);
            wp::assign(var_17, var_440);
            wp::assign(var_19, var_442);
            goto start_for_5;
        end_for_5:;
        // return                                                                             <L 630>
        return;
    }
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/solvers/featherstone/kernels.py:464
static CUDA_CALLABLE void adj_jcalc_integrate_0(
    wp::int32 var_parent,
    wp::transform_t<wp::float32> var_joint_X_c,
    wp::vec_t<3, wp::float32> var_body_com_child,
    wp::int32 var_type,
    wp::array_t<wp::float32> var_joint_q,
    wp::array_t<wp::float32> var_joint_qd,
    wp::array_t<wp::float32> var_joint_qdd,
    wp::int32 var_coord_start,
    wp::int32 var_dof_start,
    wp::int32 var_lin_axis_count,
    wp::int32 var_ang_axis_count,
    wp::float32 var_dt,
    wp::array_t<wp::float32> var_joint_q_new,
    wp::array_t<wp::float32> var_joint_qd_new,
    wp::int32 & adj_parent,
    wp::transform_t<wp::float32> & adj_joint_X_c,
    wp::vec_t<3, wp::float32> & adj_body_com_child,
    wp::int32 & adj_type,
    wp::array_t<wp::float32> & adj_joint_q,
    wp::array_t<wp::float32> & adj_joint_qd,
    wp::array_t<wp::float32> & adj_joint_qdd,
    wp::int32 & adj_coord_start,
    wp::int32 & adj_dof_start,
    wp::int32 & adj_lin_axis_count,
    wp::int32 & adj_ang_axis_count,
    wp::float32 & adj_dt,
    wp::array_t<wp::float32> & adj_joint_q_new,
    wp::array_t<wp::float32> & adj_joint_qd_new)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 3;
    bool var_1;
    bool var_2;
    const wp::int32 var_3 = 0;
    bool var_4;
    const wp::int32 var_5 = 1;
    bool var_6;
    wp::float32* var_7;
    wp::float32 var_8;
    wp::float32 var_9;
    wp::float32* var_10;
    wp::float32 var_11;
    wp::float32 var_12;
    wp::float32* var_13;
    wp::float32 var_14;
    wp::float32 var_15;
    wp::float32 var_16;
    wp::float32 var_17;
    wp::float32 var_18;
    wp::float32 var_19;
    const wp::int32 var_20 = 2;
    bool var_21;
    const wp::int32 var_22 = 0;
    wp::int32 var_23;
    wp::float32* var_24;
    const wp::int32 var_25 = 1;
    wp::int32 var_26;
    wp::float32* var_27;
    const wp::int32 var_28 = 2;
    wp::int32 var_29;
    wp::float32* var_30;
    wp::vec_t<3, wp::float32> var_31;
    wp::float32 var_32;
    wp::float32 var_33;
    wp::float32 var_34;
    const wp::int32 var_35 = 0;
    wp::int32 var_36;
    wp::float32* var_37;
    const wp::int32 var_38 = 1;
    wp::int32 var_39;
    wp::float32* var_40;
    const wp::int32 var_41 = 2;
    wp::int32 var_42;
    wp::float32* var_43;
    wp::vec_t<3, wp::float32> var_44;
    wp::float32 var_45;
    wp::float32 var_46;
    wp::float32 var_47;
    const wp::int32 var_48 = 0;
    wp::int32 var_49;
    wp::float32* var_50;
    const wp::int32 var_51 = 1;
    wp::int32 var_52;
    wp::float32* var_53;
    const wp::int32 var_54 = 2;
    wp::int32 var_55;
    wp::float32* var_56;
    const wp::int32 var_57 = 3;
    wp::int32 var_58;
    wp::float32* var_59;
    wp::quat_t<wp::float32> var_60;
    wp::float32 var_61;
    wp::float32 var_62;
    wp::float32 var_63;
    wp::float32 var_64;
    wp::vec_t<3, wp::float32> var_65;
    wp::vec_t<3, wp::float32> var_66;
    const wp::float32 var_67 = 0.0;
    wp::quat_t<wp::float32> var_68;
    wp::quat_t<wp::float32> var_69;
    const wp::float32 var_70 = 0.5;
    wp::quat_t<wp::float32> var_71;
    wp::quat_t<wp::float32> var_72;
    wp::quat_t<wp::float32> var_73;
    wp::quat_t<wp::float32> var_74;
    const wp::int32 var_75 = 0;
    wp::float32 var_76;
    const wp::int32 var_77 = 0;
    wp::int32 var_78;
    const wp::int32 var_79 = 1;
    wp::float32 var_80;
    const wp::int32 var_81 = 1;
    wp::int32 var_82;
    const wp::int32 var_83 = 2;
    wp::float32 var_84;
    const wp::int32 var_85 = 2;
    wp::int32 var_86;
    const wp::int32 var_87 = 3;
    wp::float32 var_88;
    const wp::int32 var_89 = 3;
    wp::int32 var_90;
    const wp::int32 var_91 = 0;
    wp::float32 var_92;
    const wp::int32 var_93 = 0;
    wp::int32 var_94;
    const wp::int32 var_95 = 1;
    wp::float32 var_96;
    const wp::int32 var_97 = 1;
    wp::int32 var_98;
    const wp::int32 var_99 = 2;
    wp::float32 var_100;
    const wp::int32 var_101 = 2;
    wp::int32 var_102;
    bool var_103;
    const wp::int32 var_104 = 4;
    bool var_105;
    const wp::int32 var_106 = 5;
    bool var_107;
    const wp::int32 var_108 = 0;
    bool var_109;
    const wp::int32 var_110 = 0;
    wp::int32 var_111;
    wp::float32* var_112;
    const wp::int32 var_113 = 1;
    wp::int32 var_114;
    wp::float32* var_115;
    const wp::int32 var_116 = 2;
    wp::int32 var_117;
    wp::float32* var_118;
    wp::vec_t<3, wp::float32> var_119;
    wp::float32 var_120;
    wp::float32 var_121;
    wp::float32 var_122;
    const wp::int32 var_123 = 3;
    wp::int32 var_124;
    wp::float32* var_125;
    const wp::int32 var_126 = 4;
    wp::int32 var_127;
    wp::float32* var_128;
    const wp::int32 var_129 = 5;
    wp::int32 var_130;
    wp::float32* var_131;
    wp::vec_t<3, wp::float32> var_132;
    wp::float32 var_133;
    wp::float32 var_134;
    wp::float32 var_135;
    const wp::int32 var_136 = 0;
    wp::int32 var_137;
    wp::float32* var_138;
    const wp::int32 var_139 = 1;
    wp::int32 var_140;
    wp::float32* var_141;
    const wp::int32 var_142 = 2;
    wp::int32 var_143;
    wp::float32* var_144;
    wp::vec_t<3, wp::float32> var_145;
    wp::float32 var_146;
    wp::float32 var_147;
    wp::float32 var_148;
    const wp::int32 var_149 = 3;
    wp::int32 var_150;
    wp::float32* var_151;
    const wp::int32 var_152 = 4;
    wp::int32 var_153;
    wp::float32* var_154;
    const wp::int32 var_155 = 5;
    wp::int32 var_156;
    wp::float32* var_157;
    wp::vec_t<3, wp::float32> var_158;
    wp::float32 var_159;
    wp::float32 var_160;
    wp::float32 var_161;
    const wp::int32 var_162 = 0;
    wp::int32 var_163;
    wp::float32* var_164;
    const wp::int32 var_165 = 1;
    wp::int32 var_166;
    wp::float32* var_167;
    const wp::int32 var_168 = 2;
    wp::int32 var_169;
    wp::float32* var_170;
    wp::vec_t<3, wp::float32> var_171;
    wp::float32 var_172;
    wp::float32 var_173;
    wp::float32 var_174;
    const wp::int32 var_175 = 3;
    wp::int32 var_176;
    wp::float32* var_177;
    const wp::int32 var_178 = 4;
    wp::int32 var_179;
    wp::float32* var_180;
    const wp::int32 var_181 = 5;
    wp::int32 var_182;
    wp::float32* var_183;
    const wp::int32 var_184 = 6;
    wp::int32 var_185;
    wp::float32* var_186;
    wp::quat_t<wp::float32> var_187;
    wp::float32 var_188;
    wp::float32 var_189;
    wp::float32 var_190;
    wp::float32 var_191;
    wp::transform_t<wp::float32> var_192;
    wp::vec_t<3, wp::float32> var_193;
    wp::vec_t<3, wp::float32> var_194;
    wp::vec_t<3, wp::float32> var_195;
    wp::vec_t<3, wp::float32> var_196;
    wp::vec_t<3, wp::float32> var_197;
    wp::vec_t<3, wp::float32> var_198;
    wp::vec_t<3, wp::float32> var_199;
    wp::vec_t<3, wp::float32> var_200;
    wp::vec_t<3, wp::float32> var_201;
    wp::vec_t<3, wp::float32> var_202;
    wp::vec_t<3, wp::float32> var_203;
    wp::vec_t<3, wp::float32> var_204;
    wp::vec_t<3, wp::float32> var_205;
    const wp::float32 var_206 = 0.0;
    wp::quat_t<wp::float32> var_207;
    wp::quat_t<wp::float32> var_208;
    const wp::float32 var_209 = 0.5;
    wp::quat_t<wp::float32> var_210;
    wp::quat_t<wp::float32> var_211;
    wp::quat_t<wp::float32> var_212;
    wp::quat_t<wp::float32> var_213;
    wp::vec_t<3, wp::float32> var_214;
    wp::vec_t<3, wp::float32> var_215;
    wp::vec_t<3, wp::float32> var_216;
    wp::vec_t<3, wp::float32> var_217;
    wp::vec_t<3, wp::float32> var_218;
    wp::vec_t<3, wp::float32> var_219;
    const wp::int32 var_220 = 0;
    wp::float32 var_221;
    const wp::int32 var_222 = 0;
    wp::int32 var_223;
    const wp::int32 var_224 = 1;
    wp::float32 var_225;
    const wp::int32 var_226 = 1;
    wp::int32 var_227;
    const wp::int32 var_228 = 2;
    wp::float32 var_229;
    const wp::int32 var_230 = 2;
    wp::int32 var_231;
    const wp::int32 var_232 = 0;
    wp::float32 var_233;
    const wp::int32 var_234 = 3;
    wp::int32 var_235;
    const wp::int32 var_236 = 1;
    wp::float32 var_237;
    const wp::int32 var_238 = 4;
    wp::int32 var_239;
    const wp::int32 var_240 = 2;
    wp::float32 var_241;
    const wp::int32 var_242 = 5;
    wp::int32 var_243;
    const wp::int32 var_244 = 3;
    wp::float32 var_245;
    const wp::int32 var_246 = 6;
    wp::int32 var_247;
    const wp::int32 var_248 = 0;
    wp::float32 var_249;
    const wp::int32 var_250 = 0;
    wp::int32 var_251;
    const wp::int32 var_252 = 1;
    wp::float32 var_253;
    const wp::int32 var_254 = 1;
    wp::int32 var_255;
    const wp::int32 var_256 = 2;
    wp::float32 var_257;
    const wp::int32 var_258 = 2;
    wp::int32 var_259;
    const wp::int32 var_260 = 0;
    wp::float32 var_261;
    const wp::int32 var_262 = 3;
    wp::int32 var_263;
    const wp::int32 var_264 = 1;
    wp::float32 var_265;
    const wp::int32 var_266 = 4;
    wp::int32 var_267;
    const wp::int32 var_268 = 2;
    wp::float32 var_269;
    const wp::int32 var_270 = 5;
    wp::int32 var_271;
    const wp::int32 var_272 = 0;
    wp::int32 var_273;
    wp::float32* var_274;
    const wp::int32 var_275 = 1;
    wp::int32 var_276;
    wp::float32* var_277;
    const wp::int32 var_278 = 2;
    wp::int32 var_279;
    wp::float32* var_280;
    wp::vec_t<3, wp::float32> var_281;
    wp::float32 var_282;
    wp::float32 var_283;
    wp::float32 var_284;
    const wp::int32 var_285 = 3;
    wp::int32 var_286;
    wp::float32* var_287;
    const wp::int32 var_288 = 4;
    wp::int32 var_289;
    wp::float32* var_290;
    const wp::int32 var_291 = 5;
    wp::int32 var_292;
    wp::float32* var_293;
    wp::vec_t<3, wp::float32> var_294;
    wp::float32 var_295;
    wp::float32 var_296;
    wp::float32 var_297;
    const wp::int32 var_298 = 0;
    wp::int32 var_299;
    wp::float32* var_300;
    const wp::int32 var_301 = 1;
    wp::int32 var_302;
    wp::float32* var_303;
    const wp::int32 var_304 = 2;
    wp::int32 var_305;
    wp::float32* var_306;
    wp::vec_t<3, wp::float32> var_307;
    wp::float32 var_308;
    wp::float32 var_309;
    wp::float32 var_310;
    const wp::int32 var_311 = 3;
    wp::int32 var_312;
    wp::float32* var_313;
    const wp::int32 var_314 = 4;
    wp::int32 var_315;
    wp::float32* var_316;
    const wp::int32 var_317 = 5;
    wp::int32 var_318;
    wp::float32* var_319;
    wp::vec_t<3, wp::float32> var_320;
    wp::float32 var_321;
    wp::float32 var_322;
    wp::float32 var_323;
    wp::vec_t<3, wp::float32> var_324;
    wp::vec_t<3, wp::float32> var_325;
    wp::vec_t<3, wp::float32> var_326;
    wp::vec_t<3, wp::float32> var_327;
    const wp::int32 var_328 = 0;
    wp::int32 var_329;
    wp::float32* var_330;
    const wp::int32 var_331 = 1;
    wp::int32 var_332;
    wp::float32* var_333;
    const wp::int32 var_334 = 2;
    wp::int32 var_335;
    wp::float32* var_336;
    wp::vec_t<3, wp::float32> var_337;
    wp::float32 var_338;
    wp::float32 var_339;
    wp::float32 var_340;
    wp::vec_t<3, wp::float32> var_341;
    wp::vec_t<3, wp::float32> var_342;
    const wp::int32 var_343 = 3;
    wp::int32 var_344;
    wp::float32* var_345;
    const wp::int32 var_346 = 4;
    wp::int32 var_347;
    wp::float32* var_348;
    const wp::int32 var_349 = 5;
    wp::int32 var_350;
    wp::float32* var_351;
    const wp::int32 var_352 = 6;
    wp::int32 var_353;
    wp::float32* var_354;
    wp::quat_t<wp::float32> var_355;
    wp::float32 var_356;
    wp::float32 var_357;
    wp::float32 var_358;
    wp::float32 var_359;
    const wp::float32 var_360 = 0.0;
    wp::quat_t<wp::float32> var_361;
    wp::quat_t<wp::float32> var_362;
    const wp::float32 var_363 = 0.5;
    wp::quat_t<wp::float32> var_364;
    wp::vec_t<3, wp::float32> var_365;
    wp::vec_t<3, wp::float32> var_366;
    wp::quat_t<wp::float32> var_367;
    wp::quat_t<wp::float32> var_368;
    wp::quat_t<wp::float32> var_369;
    const wp::int32 var_370 = 0;
    wp::float32 var_371;
    const wp::int32 var_372 = 0;
    wp::int32 var_373;
    const wp::int32 var_374 = 1;
    wp::float32 var_375;
    const wp::int32 var_376 = 1;
    wp::int32 var_377;
    const wp::int32 var_378 = 2;
    wp::float32 var_379;
    const wp::int32 var_380 = 2;
    wp::int32 var_381;
    const wp::int32 var_382 = 0;
    wp::float32 var_383;
    const wp::int32 var_384 = 3;
    wp::int32 var_385;
    const wp::int32 var_386 = 1;
    wp::float32 var_387;
    const wp::int32 var_388 = 4;
    wp::int32 var_389;
    const wp::int32 var_390 = 2;
    wp::float32 var_391;
    const wp::int32 var_392 = 5;
    wp::int32 var_393;
    const wp::int32 var_394 = 3;
    wp::float32 var_395;
    const wp::int32 var_396 = 6;
    wp::int32 var_397;
    const wp::int32 var_398 = 0;
    wp::float32 var_399;
    const wp::int32 var_400 = 0;
    wp::int32 var_401;
    const wp::int32 var_402 = 1;
    wp::float32 var_403;
    const wp::int32 var_404 = 1;
    wp::int32 var_405;
    const wp::int32 var_406 = 2;
    wp::float32 var_407;
    const wp::int32 var_408 = 2;
    wp::int32 var_409;
    const wp::int32 var_410 = 0;
    wp::float32 var_411;
    const wp::int32 var_412 = 3;
    wp::int32 var_413;
    const wp::int32 var_414 = 1;
    wp::float32 var_415;
    const wp::int32 var_416 = 4;
    wp::int32 var_417;
    const wp::int32 var_418 = 2;
    wp::float32 var_419;
    const wp::int32 var_420 = 5;
    wp::int32 var_421;
    const wp::int32 var_422 = 6;
    bool var_423;
    wp::int32 var_424;
    wp::range_t var_425;
    wp::int32 var_426;
    wp::int32 var_427;
    wp::float32* var_428;
    wp::float32 var_429;
    wp::float32 var_430;
    wp::int32 var_431;
    wp::float32* var_432;
    wp::float32 var_433;
    wp::float32 var_434;
    wp::int32 var_435;
    wp::float32* var_436;
    wp::float32 var_437;
    wp::float32 var_438;
    wp::float32 var_439;
    wp::float32 var_440;
    wp::float32 var_441;
    wp::float32 var_442;
    wp::int32 var_443;
    wp::int32 var_444;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    bool adj_1 = {};
    bool adj_2 = {};
    wp::int32 adj_3 = {};
    bool adj_4 = {};
    wp::int32 adj_5 = {};
    bool adj_6 = {};
    wp::float32 adj_7 = {};
    wp::float32 adj_8 = {};
    wp::float32 adj_9 = {};
    wp::float32 adj_10 = {};
    wp::float32 adj_11 = {};
    wp::float32 adj_12 = {};
    wp::float32 adj_13 = {};
    wp::float32 adj_14 = {};
    wp::float32 adj_15 = {};
    wp::float32 adj_16 = {};
    wp::float32 adj_17 = {};
    wp::float32 adj_18 = {};
    wp::float32 adj_19 = {};
    wp::int32 adj_20 = {};
    bool adj_21 = {};
    wp::int32 adj_22 = {};
    wp::int32 adj_23 = {};
    wp::float32 adj_24 = {};
    wp::int32 adj_25 = {};
    wp::int32 adj_26 = {};
    wp::float32 adj_27 = {};
    wp::int32 adj_28 = {};
    wp::int32 adj_29 = {};
    wp::float32 adj_30 = {};
    wp::vec_t<3, wp::float32> adj_31 = {};
    wp::float32 adj_32 = {};
    wp::float32 adj_33 = {};
    wp::float32 adj_34 = {};
    wp::int32 adj_35 = {};
    wp::int32 adj_36 = {};
    wp::float32 adj_37 = {};
    wp::int32 adj_38 = {};
    wp::int32 adj_39 = {};
    wp::float32 adj_40 = {};
    wp::int32 adj_41 = {};
    wp::int32 adj_42 = {};
    wp::float32 adj_43 = {};
    wp::vec_t<3, wp::float32> adj_44 = {};
    wp::float32 adj_45 = {};
    wp::float32 adj_46 = {};
    wp::float32 adj_47 = {};
    wp::int32 adj_48 = {};
    wp::int32 adj_49 = {};
    wp::float32 adj_50 = {};
    wp::int32 adj_51 = {};
    wp::int32 adj_52 = {};
    wp::float32 adj_53 = {};
    wp::int32 adj_54 = {};
    wp::int32 adj_55 = {};
    wp::float32 adj_56 = {};
    wp::int32 adj_57 = {};
    wp::int32 adj_58 = {};
    wp::float32 adj_59 = {};
    wp::quat_t<wp::float32> adj_60 = {};
    wp::float32 adj_61 = {};
    wp::float32 adj_62 = {};
    wp::float32 adj_63 = {};
    wp::float32 adj_64 = {};
    wp::vec_t<3, wp::float32> adj_65 = {};
    wp::vec_t<3, wp::float32> adj_66 = {};
    wp::float32 adj_67 = {};
    wp::quat_t<wp::float32> adj_68 = {};
    wp::quat_t<wp::float32> adj_69 = {};
    wp::float32 adj_70 = {};
    wp::quat_t<wp::float32> adj_71 = {};
    wp::quat_t<wp::float32> adj_72 = {};
    wp::quat_t<wp::float32> adj_73 = {};
    wp::quat_t<wp::float32> adj_74 = {};
    wp::int32 adj_75 = {};
    wp::float32 adj_76 = {};
    wp::int32 adj_77 = {};
    wp::int32 adj_78 = {};
    wp::int32 adj_79 = {};
    wp::float32 adj_80 = {};
    wp::int32 adj_81 = {};
    wp::int32 adj_82 = {};
    wp::int32 adj_83 = {};
    wp::float32 adj_84 = {};
    wp::int32 adj_85 = {};
    wp::int32 adj_86 = {};
    wp::int32 adj_87 = {};
    wp::float32 adj_88 = {};
    wp::int32 adj_89 = {};
    wp::int32 adj_90 = {};
    wp::int32 adj_91 = {};
    wp::float32 adj_92 = {};
    wp::int32 adj_93 = {};
    wp::int32 adj_94 = {};
    wp::int32 adj_95 = {};
    wp::float32 adj_96 = {};
    wp::int32 adj_97 = {};
    wp::int32 adj_98 = {};
    wp::int32 adj_99 = {};
    wp::float32 adj_100 = {};
    wp::int32 adj_101 = {};
    wp::int32 adj_102 = {};
    bool adj_103 = {};
    wp::int32 adj_104 = {};
    bool adj_105 = {};
    wp::int32 adj_106 = {};
    bool adj_107 = {};
    wp::int32 adj_108 = {};
    bool adj_109 = {};
    wp::int32 adj_110 = {};
    wp::int32 adj_111 = {};
    wp::float32 adj_112 = {};
    wp::int32 adj_113 = {};
    wp::int32 adj_114 = {};
    wp::float32 adj_115 = {};
    wp::int32 adj_116 = {};
    wp::int32 adj_117 = {};
    wp::float32 adj_118 = {};
    wp::vec_t<3, wp::float32> adj_119 = {};
    wp::float32 adj_120 = {};
    wp::float32 adj_121 = {};
    wp::float32 adj_122 = {};
    wp::int32 adj_123 = {};
    wp::int32 adj_124 = {};
    wp::float32 adj_125 = {};
    wp::int32 adj_126 = {};
    wp::int32 adj_127 = {};
    wp::float32 adj_128 = {};
    wp::int32 adj_129 = {};
    wp::int32 adj_130 = {};
    wp::float32 adj_131 = {};
    wp::vec_t<3, wp::float32> adj_132 = {};
    wp::float32 adj_133 = {};
    wp::float32 adj_134 = {};
    wp::float32 adj_135 = {};
    wp::int32 adj_136 = {};
    wp::int32 adj_137 = {};
    wp::float32 adj_138 = {};
    wp::int32 adj_139 = {};
    wp::int32 adj_140 = {};
    wp::float32 adj_141 = {};
    wp::int32 adj_142 = {};
    wp::int32 adj_143 = {};
    wp::float32 adj_144 = {};
    wp::vec_t<3, wp::float32> adj_145 = {};
    wp::float32 adj_146 = {};
    wp::float32 adj_147 = {};
    wp::float32 adj_148 = {};
    wp::int32 adj_149 = {};
    wp::int32 adj_150 = {};
    wp::float32 adj_151 = {};
    wp::int32 adj_152 = {};
    wp::int32 adj_153 = {};
    wp::float32 adj_154 = {};
    wp::int32 adj_155 = {};
    wp::int32 adj_156 = {};
    wp::float32 adj_157 = {};
    wp::vec_t<3, wp::float32> adj_158 = {};
    wp::float32 adj_159 = {};
    wp::float32 adj_160 = {};
    wp::float32 adj_161 = {};
    wp::int32 adj_162 = {};
    wp::int32 adj_163 = {};
    wp::float32 adj_164 = {};
    wp::int32 adj_165 = {};
    wp::int32 adj_166 = {};
    wp::float32 adj_167 = {};
    wp::int32 adj_168 = {};
    wp::int32 adj_169 = {};
    wp::float32 adj_170 = {};
    wp::vec_t<3, wp::float32> adj_171 = {};
    wp::float32 adj_172 = {};
    wp::float32 adj_173 = {};
    wp::float32 adj_174 = {};
    wp::int32 adj_175 = {};
    wp::int32 adj_176 = {};
    wp::float32 adj_177 = {};
    wp::int32 adj_178 = {};
    wp::int32 adj_179 = {};
    wp::float32 adj_180 = {};
    wp::int32 adj_181 = {};
    wp::int32 adj_182 = {};
    wp::float32 adj_183 = {};
    wp::int32 adj_184 = {};
    wp::int32 adj_185 = {};
    wp::float32 adj_186 = {};
    wp::quat_t<wp::float32> adj_187 = {};
    wp::float32 adj_188 = {};
    wp::float32 adj_189 = {};
    wp::float32 adj_190 = {};
    wp::float32 adj_191 = {};
    wp::transform_t<wp::float32> adj_192 = {};
    wp::vec_t<3, wp::float32> adj_193 = {};
    wp::vec_t<3, wp::float32> adj_194 = {};
    wp::vec_t<3, wp::float32> adj_195 = {};
    wp::vec_t<3, wp::float32> adj_196 = {};
    wp::vec_t<3, wp::float32> adj_197 = {};
    wp::vec_t<3, wp::float32> adj_198 = {};
    wp::vec_t<3, wp::float32> adj_199 = {};
    wp::vec_t<3, wp::float32> adj_200 = {};
    wp::vec_t<3, wp::float32> adj_201 = {};
    wp::vec_t<3, wp::float32> adj_202 = {};
    wp::vec_t<3, wp::float32> adj_203 = {};
    wp::vec_t<3, wp::float32> adj_204 = {};
    wp::vec_t<3, wp::float32> adj_205 = {};
    wp::float32 adj_206 = {};
    wp::quat_t<wp::float32> adj_207 = {};
    wp::quat_t<wp::float32> adj_208 = {};
    wp::float32 adj_209 = {};
    wp::quat_t<wp::float32> adj_210 = {};
    wp::quat_t<wp::float32> adj_211 = {};
    wp::quat_t<wp::float32> adj_212 = {};
    wp::quat_t<wp::float32> adj_213 = {};
    wp::vec_t<3, wp::float32> adj_214 = {};
    wp::vec_t<3, wp::float32> adj_215 = {};
    wp::vec_t<3, wp::float32> adj_216 = {};
    wp::vec_t<3, wp::float32> adj_217 = {};
    wp::vec_t<3, wp::float32> adj_218 = {};
    wp::vec_t<3, wp::float32> adj_219 = {};
    wp::int32 adj_220 = {};
    wp::float32 adj_221 = {};
    wp::int32 adj_222 = {};
    wp::int32 adj_223 = {};
    wp::int32 adj_224 = {};
    wp::float32 adj_225 = {};
    wp::int32 adj_226 = {};
    wp::int32 adj_227 = {};
    wp::int32 adj_228 = {};
    wp::float32 adj_229 = {};
    wp::int32 adj_230 = {};
    wp::int32 adj_231 = {};
    wp::int32 adj_232 = {};
    wp::float32 adj_233 = {};
    wp::int32 adj_234 = {};
    wp::int32 adj_235 = {};
    wp::int32 adj_236 = {};
    wp::float32 adj_237 = {};
    wp::int32 adj_238 = {};
    wp::int32 adj_239 = {};
    wp::int32 adj_240 = {};
    wp::float32 adj_241 = {};
    wp::int32 adj_242 = {};
    wp::int32 adj_243 = {};
    wp::int32 adj_244 = {};
    wp::float32 adj_245 = {};
    wp::int32 adj_246 = {};
    wp::int32 adj_247 = {};
    wp::int32 adj_248 = {};
    wp::float32 adj_249 = {};
    wp::int32 adj_250 = {};
    wp::int32 adj_251 = {};
    wp::int32 adj_252 = {};
    wp::float32 adj_253 = {};
    wp::int32 adj_254 = {};
    wp::int32 adj_255 = {};
    wp::int32 adj_256 = {};
    wp::float32 adj_257 = {};
    wp::int32 adj_258 = {};
    wp::int32 adj_259 = {};
    wp::int32 adj_260 = {};
    wp::float32 adj_261 = {};
    wp::int32 adj_262 = {};
    wp::int32 adj_263 = {};
    wp::int32 adj_264 = {};
    wp::float32 adj_265 = {};
    wp::int32 adj_266 = {};
    wp::int32 adj_267 = {};
    wp::int32 adj_268 = {};
    wp::float32 adj_269 = {};
    wp::int32 adj_270 = {};
    wp::int32 adj_271 = {};
    wp::int32 adj_272 = {};
    wp::int32 adj_273 = {};
    wp::float32 adj_274 = {};
    wp::int32 adj_275 = {};
    wp::int32 adj_276 = {};
    wp::float32 adj_277 = {};
    wp::int32 adj_278 = {};
    wp::int32 adj_279 = {};
    wp::float32 adj_280 = {};
    wp::vec_t<3, wp::float32> adj_281 = {};
    wp::float32 adj_282 = {};
    wp::float32 adj_283 = {};
    wp::float32 adj_284 = {};
    wp::int32 adj_285 = {};
    wp::int32 adj_286 = {};
    wp::float32 adj_287 = {};
    wp::int32 adj_288 = {};
    wp::int32 adj_289 = {};
    wp::float32 adj_290 = {};
    wp::int32 adj_291 = {};
    wp::int32 adj_292 = {};
    wp::float32 adj_293 = {};
    wp::vec_t<3, wp::float32> adj_294 = {};
    wp::float32 adj_295 = {};
    wp::float32 adj_296 = {};
    wp::float32 adj_297 = {};
    wp::int32 adj_298 = {};
    wp::int32 adj_299 = {};
    wp::float32 adj_300 = {};
    wp::int32 adj_301 = {};
    wp::int32 adj_302 = {};
    wp::float32 adj_303 = {};
    wp::int32 adj_304 = {};
    wp::int32 adj_305 = {};
    wp::float32 adj_306 = {};
    wp::vec_t<3, wp::float32> adj_307 = {};
    wp::float32 adj_308 = {};
    wp::float32 adj_309 = {};
    wp::float32 adj_310 = {};
    wp::int32 adj_311 = {};
    wp::int32 adj_312 = {};
    wp::float32 adj_313 = {};
    wp::int32 adj_314 = {};
    wp::int32 adj_315 = {};
    wp::float32 adj_316 = {};
    wp::int32 adj_317 = {};
    wp::int32 adj_318 = {};
    wp::float32 adj_319 = {};
    wp::vec_t<3, wp::float32> adj_320 = {};
    wp::float32 adj_321 = {};
    wp::float32 adj_322 = {};
    wp::float32 adj_323 = {};
    wp::vec_t<3, wp::float32> adj_324 = {};
    wp::vec_t<3, wp::float32> adj_325 = {};
    wp::vec_t<3, wp::float32> adj_326 = {};
    wp::vec_t<3, wp::float32> adj_327 = {};
    wp::int32 adj_328 = {};
    wp::int32 adj_329 = {};
    wp::float32 adj_330 = {};
    wp::int32 adj_331 = {};
    wp::int32 adj_332 = {};
    wp::float32 adj_333 = {};
    wp::int32 adj_334 = {};
    wp::int32 adj_335 = {};
    wp::float32 adj_336 = {};
    wp::vec_t<3, wp::float32> adj_337 = {};
    wp::float32 adj_338 = {};
    wp::float32 adj_339 = {};
    wp::float32 adj_340 = {};
    wp::vec_t<3, wp::float32> adj_341 = {};
    wp::vec_t<3, wp::float32> adj_342 = {};
    wp::int32 adj_343 = {};
    wp::int32 adj_344 = {};
    wp::float32 adj_345 = {};
    wp::int32 adj_346 = {};
    wp::int32 adj_347 = {};
    wp::float32 adj_348 = {};
    wp::int32 adj_349 = {};
    wp::int32 adj_350 = {};
    wp::float32 adj_351 = {};
    wp::int32 adj_352 = {};
    wp::int32 adj_353 = {};
    wp::float32 adj_354 = {};
    wp::quat_t<wp::float32> adj_355 = {};
    wp::float32 adj_356 = {};
    wp::float32 adj_357 = {};
    wp::float32 adj_358 = {};
    wp::float32 adj_359 = {};
    wp::float32 adj_360 = {};
    wp::quat_t<wp::float32> adj_361 = {};
    wp::quat_t<wp::float32> adj_362 = {};
    wp::float32 adj_363 = {};
    wp::quat_t<wp::float32> adj_364 = {};
    wp::vec_t<3, wp::float32> adj_365 = {};
    wp::vec_t<3, wp::float32> adj_366 = {};
    wp::quat_t<wp::float32> adj_367 = {};
    wp::quat_t<wp::float32> adj_368 = {};
    wp::quat_t<wp::float32> adj_369 = {};
    wp::int32 adj_370 = {};
    wp::float32 adj_371 = {};
    wp::int32 adj_372 = {};
    wp::int32 adj_373 = {};
    wp::int32 adj_374 = {};
    wp::float32 adj_375 = {};
    wp::int32 adj_376 = {};
    wp::int32 adj_377 = {};
    wp::int32 adj_378 = {};
    wp::float32 adj_379 = {};
    wp::int32 adj_380 = {};
    wp::int32 adj_381 = {};
    wp::int32 adj_382 = {};
    wp::float32 adj_383 = {};
    wp::int32 adj_384 = {};
    wp::int32 adj_385 = {};
    wp::int32 adj_386 = {};
    wp::float32 adj_387 = {};
    wp::int32 adj_388 = {};
    wp::int32 adj_389 = {};
    wp::int32 adj_390 = {};
    wp::float32 adj_391 = {};
    wp::int32 adj_392 = {};
    wp::int32 adj_393 = {};
    wp::int32 adj_394 = {};
    wp::float32 adj_395 = {};
    wp::int32 adj_396 = {};
    wp::int32 adj_397 = {};
    wp::int32 adj_398 = {};
    wp::float32 adj_399 = {};
    wp::int32 adj_400 = {};
    wp::int32 adj_401 = {};
    wp::int32 adj_402 = {};
    wp::float32 adj_403 = {};
    wp::int32 adj_404 = {};
    wp::int32 adj_405 = {};
    wp::int32 adj_406 = {};
    wp::float32 adj_407 = {};
    wp::int32 adj_408 = {};
    wp::int32 adj_409 = {};
    wp::int32 adj_410 = {};
    wp::float32 adj_411 = {};
    wp::int32 adj_412 = {};
    wp::int32 adj_413 = {};
    wp::int32 adj_414 = {};
    wp::float32 adj_415 = {};
    wp::int32 adj_416 = {};
    wp::int32 adj_417 = {};
    wp::int32 adj_418 = {};
    wp::float32 adj_419 = {};
    wp::int32 adj_420 = {};
    wp::int32 adj_421 = {};
    wp::int32 adj_422 = {};
    bool adj_423 = {};
    wp::int32 adj_424 = {};
    wp::range_t adj_425 = {};
    wp::int32 adj_426 = {};
    wp::int32 adj_427 = {};
    wp::float32 adj_428 = {};
    wp::float32 adj_429 = {};
    wp::float32 adj_430 = {};
    wp::int32 adj_431 = {};
    wp::float32 adj_432 = {};
    wp::float32 adj_433 = {};
    wp::float32 adj_434 = {};
    wp::int32 adj_435 = {};
    wp::float32 adj_436 = {};
    wp::float32 adj_437 = {};
    wp::float32 adj_438 = {};
    wp::float32 adj_439 = {};
    wp::float32 adj_440 = {};
    wp::float32 adj_441 = {};
    wp::float32 adj_442 = {};
    wp::int32 adj_443 = {};
    wp::int32 adj_444 = {};
    //---------
    // forward
    // def jcalc_integrate(                                                                   <L 465>
    // if type == JointType.FIXED:                                                            <L 482>
    var_1 = (var_type == var_0);
    if (var_1) {
        // return                                                                             <L 483>
        goto label0;
    }
    // if type == JointType.PRISMATIC or type == JointType.REVOLUTE:                          <L 486>
    var_4 = (var_type == var_3);
    var_2 = var_4;
    if (!var_2) {
        var_6 = (var_type == var_5);
        var_2 = var_2 || var_6;
    }
    if (var_2) {
        // qdd = joint_qdd[dof_start]                                                         <L 487>
        var_7 = wp::address(var_joint_qdd, var_dof_start);
        var_9 = wp::load(var_7);
        var_8 = wp::copy(var_9);
        // qd = joint_qd[dof_start]                                                           <L 488>
        var_10 = wp::address(var_joint_qd, var_dof_start);
        var_12 = wp::load(var_10);
        var_11 = wp::copy(var_12);
        // q = joint_q[coord_start]                                                           <L 489>
        var_13 = wp::address(var_joint_q, var_coord_start);
        var_15 = wp::load(var_13);
        var_14 = wp::copy(var_15);
        // qd_new = qd + qdd * dt                                                             <L 491>
        var_16 = wp::mul(var_8, var_dt);
        var_17 = wp::add(var_11, var_16);
        // q_new = q + qd_new * dt                                                            <L 492>
        var_18 = wp::mul(var_17, var_dt);
        var_19 = wp::add(var_14, var_18);
        // joint_qd_new[dof_start] = qd_new                                                   <L 494>
        // wp::array_store(var_joint_qd_new, var_dof_start, var_17);
        // joint_q_new[coord_start] = q_new                                                   <L 495>
        // wp::array_store(var_joint_q_new, var_coord_start, var_19);
        // return                                                                             <L 497>
        goto label1;
    }
    // if type == JointType.BALL:                                                             <L 500>
    var_21 = (var_type == var_20);
    if (var_21) {
        // m_j = wp.vec3(joint_qdd[dof_start + 0], joint_qdd[dof_start + 1], joint_qdd[dof_start + 2])       <L 501>
        var_23 = wp::add(var_dof_start, var_22);
        var_24 = wp::address(var_joint_qdd, var_23);
        var_26 = wp::add(var_dof_start, var_25);
        var_27 = wp::address(var_joint_qdd, var_26);
        var_29 = wp::add(var_dof_start, var_28);
        var_30 = wp::address(var_joint_qdd, var_29);
        var_32 = wp::load(var_24);
        var_33 = wp::load(var_27);
        var_34 = wp::load(var_30);
        var_31 = wp::vec_t<3, wp::float32>(var_32, var_33, var_34);
        // w_j = wp.vec3(joint_qd[dof_start + 0], joint_qd[dof_start + 1], joint_qd[dof_start + 2])       <L 502>
        var_36 = wp::add(var_dof_start, var_35);
        var_37 = wp::address(var_joint_qd, var_36);
        var_39 = wp::add(var_dof_start, var_38);
        var_40 = wp::address(var_joint_qd, var_39);
        var_42 = wp::add(var_dof_start, var_41);
        var_43 = wp::address(var_joint_qd, var_42);
        var_45 = wp::load(var_37);
        var_46 = wp::load(var_40);
        var_47 = wp::load(var_43);
        var_44 = wp::vec_t<3, wp::float32>(var_45, var_46, var_47);
        // r_j = wp.quat(                                                                     <L 504>
        // joint_q[coord_start + 0], joint_q[coord_start + 1], joint_q[coord_start + 2], joint_q[coord_start + 3]       <L 505>
        var_49 = wp::add(var_coord_start, var_48);
        var_50 = wp::address(var_joint_q, var_49);
        var_52 = wp::add(var_coord_start, var_51);
        var_53 = wp::address(var_joint_q, var_52);
        var_55 = wp::add(var_coord_start, var_54);
        var_56 = wp::address(var_joint_q, var_55);
        var_58 = wp::add(var_coord_start, var_57);
        var_59 = wp::address(var_joint_q, var_58);
        var_61 = wp::load(var_50);
        var_62 = wp::load(var_53);
        var_63 = wp::load(var_56);
        var_64 = wp::load(var_59);
        var_60 = wp::quat_t<wp::float32>(var_61, var_62, var_63, var_64);
        // w_j_new = w_j + m_j * dt                                                           <L 509>
        var_65 = wp::mul(var_31, var_dt);
        var_66 = wp::add(var_44, var_65);
        // drdt_j = wp.quat(w_j_new, 0.0) * r_j * 0.5                                         <L 511>
        var_68 = wp::quat_t<wp::float32>(var_66, var_67);
        var_69 = wp::mul(var_68, var_60);
        var_71 = wp::mul(var_69, var_70);
        // r_j_new = wp.normalize(r_j + drdt_j * dt)                                          <L 514>
        var_72 = wp::mul(var_71, var_dt);
        var_73 = wp::add(var_60, var_72);
        var_74 = wp::normalize(var_73);
        // joint_q_new[coord_start + 0] = r_j_new[0]                                          <L 517>
        var_76 = wp::extract(var_74, var_75);
        var_78 = wp::add(var_coord_start, var_77);
        // wp::array_store(var_joint_q_new, var_78, var_76);
        // joint_q_new[coord_start + 1] = r_j_new[1]                                          <L 518>
        var_80 = wp::extract(var_74, var_79);
        var_82 = wp::add(var_coord_start, var_81);
        // wp::array_store(var_joint_q_new, var_82, var_80);
        // joint_q_new[coord_start + 2] = r_j_new[2]                                          <L 519>
        var_84 = wp::extract(var_74, var_83);
        var_86 = wp::add(var_coord_start, var_85);
        // wp::array_store(var_joint_q_new, var_86, var_84);
        // joint_q_new[coord_start + 3] = r_j_new[3]                                          <L 520>
        var_88 = wp::extract(var_74, var_87);
        var_90 = wp::add(var_coord_start, var_89);
        // wp::array_store(var_joint_q_new, var_90, var_88);
        // joint_qd_new[dof_start + 0] = w_j_new[0]                                           <L 523>
        var_92 = wp::extract(var_66, var_91);
        var_94 = wp::add(var_dof_start, var_93);
        // wp::array_store(var_joint_qd_new, var_94, var_92);
        // joint_qd_new[dof_start + 1] = w_j_new[1]                                           <L 524>
        var_96 = wp::extract(var_66, var_95);
        var_98 = wp::add(var_dof_start, var_97);
        // wp::array_store(var_joint_qd_new, var_98, var_96);
        // joint_qd_new[dof_start + 2] = w_j_new[2]                                           <L 525>
        var_100 = wp::extract(var_66, var_99);
        var_102 = wp::add(var_dof_start, var_101);
        // wp::array_store(var_joint_qd_new, var_102, var_100);
        // return                                                                             <L 527>
        goto label2;
    }
    // if type == JointType.FREE or type == JointType.DISTANCE:                               <L 529>
    var_105 = (var_type == var_104);
    var_103 = var_105;
    if (!var_103) {
        var_107 = (var_type == var_106);
        var_103 = var_103 || var_107;
    }
    if (var_103) {
        // if parent < 0:                                                                     <L 530>
        var_109 = (var_parent < var_108);
        if (var_109) {
            // a_parent = wp.vec3(joint_qdd[dof_start + 0], joint_qdd[dof_start + 1], joint_qdd[dof_start + 2])       <L 531>
            var_111 = wp::add(var_dof_start, var_110);
            var_112 = wp::address(var_joint_qdd, var_111);
            var_114 = wp::add(var_dof_start, var_113);
            var_115 = wp::address(var_joint_qdd, var_114);
            var_117 = wp::add(var_dof_start, var_116);
            var_118 = wp::address(var_joint_qdd, var_117);
            var_120 = wp::load(var_112);
            var_121 = wp::load(var_115);
            var_122 = wp::load(var_118);
            var_119 = wp::vec_t<3, wp::float32>(var_120, var_121, var_122);
            // alpha = wp.vec3(joint_qdd[dof_start + 3], joint_qdd[dof_start + 4], joint_qdd[dof_start + 5])       <L 532>
            var_124 = wp::add(var_dof_start, var_123);
            var_125 = wp::address(var_joint_qdd, var_124);
            var_127 = wp::add(var_dof_start, var_126);
            var_128 = wp::address(var_joint_qdd, var_127);
            var_130 = wp::add(var_dof_start, var_129);
            var_131 = wp::address(var_joint_qdd, var_130);
            var_133 = wp::load(var_125);
            var_134 = wp::load(var_128);
            var_135 = wp::load(var_131);
            var_132 = wp::vec_t<3, wp::float32>(var_133, var_134, var_135);
            // v_parent = wp.vec3(joint_qd[dof_start + 0], joint_qd[dof_start + 1], joint_qd[dof_start + 2])       <L 534>
            var_137 = wp::add(var_dof_start, var_136);
            var_138 = wp::address(var_joint_qd, var_137);
            var_140 = wp::add(var_dof_start, var_139);
            var_141 = wp::address(var_joint_qd, var_140);
            var_143 = wp::add(var_dof_start, var_142);
            var_144 = wp::address(var_joint_qd, var_143);
            var_146 = wp::load(var_138);
            var_147 = wp::load(var_141);
            var_148 = wp::load(var_144);
            var_145 = wp::vec_t<3, wp::float32>(var_146, var_147, var_148);
            // omega = wp.vec3(joint_qd[dof_start + 3], joint_qd[dof_start + 4], joint_qd[dof_start + 5])       <L 535>
            var_150 = wp::add(var_dof_start, var_149);
            var_151 = wp::address(var_joint_qd, var_150);
            var_153 = wp::add(var_dof_start, var_152);
            var_154 = wp::address(var_joint_qd, var_153);
            var_156 = wp::add(var_dof_start, var_155);
            var_157 = wp::address(var_joint_qd, var_156);
            var_159 = wp::load(var_151);
            var_160 = wp::load(var_154);
            var_161 = wp::load(var_157);
            var_158 = wp::vec_t<3, wp::float32>(var_159, var_160, var_161);
            // p = wp.vec3(joint_q[coord_start + 0], joint_q[coord_start + 1], joint_q[coord_start + 2])       <L 537>
            var_163 = wp::add(var_coord_start, var_162);
            var_164 = wp::address(var_joint_q, var_163);
            var_166 = wp::add(var_coord_start, var_165);
            var_167 = wp::address(var_joint_q, var_166);
            var_169 = wp::add(var_coord_start, var_168);
            var_170 = wp::address(var_joint_q, var_169);
            var_172 = wp::load(var_164);
            var_173 = wp::load(var_167);
            var_174 = wp::load(var_170);
            var_171 = wp::vec_t<3, wp::float32>(var_172, var_173, var_174);
            // r = wp.quat(                                                                   <L 538>
            // joint_q[coord_start + 3], joint_q[coord_start + 4], joint_q[coord_start + 5], joint_q[coord_start + 6]       <L 539>
            var_176 = wp::add(var_coord_start, var_175);
            var_177 = wp::address(var_joint_q, var_176);
            var_179 = wp::add(var_coord_start, var_178);
            var_180 = wp::address(var_joint_q, var_179);
            var_182 = wp::add(var_coord_start, var_181);
            var_183 = wp::address(var_joint_q, var_182);
            var_185 = wp::add(var_coord_start, var_184);
            var_186 = wp::address(var_joint_q, var_185);
            var_188 = wp::load(var_177);
            var_189 = wp::load(var_180);
            var_190 = wp::load(var_183);
            var_191 = wp::load(var_186);
            var_187 = wp::quat_t<wp::float32>(var_188, var_189, var_190, var_191);
            // r_com_joint = wp.transform_point(wp.transform_inverse(joint_X_c), body_com_child)       <L 542>
            var_192 = wp::transform_inverse(var_joint_X_c);
            var_193 = wp::transform_point(var_192, var_body_com_child);
            // x_com = p + wp.quat_rotate(r, r_com_joint)                                     <L 543>
            var_194 = wp::quat_rotate(var_187, var_193);
            var_195 = wp::add(var_171, var_194);
            // v_com = v_parent + wp.cross(omega, x_com)                                      <L 544>
            var_196 = wp::cross(var_158, var_195);
            var_197 = wp::add(var_145, var_196);
            // a_com = a_parent + wp.cross(alpha, x_com) + wp.cross(omega, v_com)             <L 545>
            var_198 = wp::cross(var_132, var_195);
            var_199 = wp::add(var_119, var_198);
            var_200 = wp::cross(var_158, var_197);
            var_201 = wp::add(var_199, var_200);
            // omega_new = omega + alpha * dt                                                 <L 547>
            var_202 = wp::mul(var_132, var_dt);
            var_203 = wp::add(var_158, var_202);
            // v_com_new = v_com + a_com * dt                                                 <L 548>
            var_204 = wp::mul(var_201, var_dt);
            var_205 = wp::add(var_197, var_204);
            // drdt = wp.quat(omega_new, 0.0) * r * 0.5                                       <L 550>
            var_207 = wp::quat_t<wp::float32>(var_203, var_206);
            var_208 = wp::mul(var_207, var_187);
            var_210 = wp::mul(var_208, var_209);
            // r_new = wp.normalize(r + drdt * dt)                                            <L 551>
            var_211 = wp::mul(var_210, var_dt);
            var_212 = wp::add(var_187, var_211);
            var_213 = wp::normalize(var_212);
            // x_com_new = x_com + v_com_new * dt                                             <L 552>
            var_214 = wp::mul(var_205, var_dt);
            var_215 = wp::add(var_195, var_214);
            // p_new = x_com_new - wp.quat_rotate(r_new, r_com_joint)                         <L 553>
            var_216 = wp::quat_rotate(var_213, var_193);
            var_217 = wp::sub(var_215, var_216);
            // v_parent_new = v_com_new - wp.cross(omega_new, x_com_new)                      <L 554>
            var_218 = wp::cross(var_203, var_215);
            var_219 = wp::sub(var_205, var_218);
            // joint_q_new[coord_start + 0] = p_new[0]                                        <L 556>
            var_221 = wp::extract(var_217, var_220);
            var_223 = wp::add(var_coord_start, var_222);
            // wp::array_store(var_joint_q_new, var_223, var_221);
            // joint_q_new[coord_start + 1] = p_new[1]                                        <L 557>
            var_225 = wp::extract(var_217, var_224);
            var_227 = wp::add(var_coord_start, var_226);
            // wp::array_store(var_joint_q_new, var_227, var_225);
            // joint_q_new[coord_start + 2] = p_new[2]                                        <L 558>
            var_229 = wp::extract(var_217, var_228);
            var_231 = wp::add(var_coord_start, var_230);
            // wp::array_store(var_joint_q_new, var_231, var_229);
            // joint_q_new[coord_start + 3] = r_new[0]                                        <L 560>
            var_233 = wp::extract(var_213, var_232);
            var_235 = wp::add(var_coord_start, var_234);
            // wp::array_store(var_joint_q_new, var_235, var_233);
            // joint_q_new[coord_start + 4] = r_new[1]                                        <L 561>
            var_237 = wp::extract(var_213, var_236);
            var_239 = wp::add(var_coord_start, var_238);
            // wp::array_store(var_joint_q_new, var_239, var_237);
            // joint_q_new[coord_start + 5] = r_new[2]                                        <L 562>
            var_241 = wp::extract(var_213, var_240);
            var_243 = wp::add(var_coord_start, var_242);
            // wp::array_store(var_joint_q_new, var_243, var_241);
            // joint_q_new[coord_start + 6] = r_new[3]                                        <L 563>
            var_245 = wp::extract(var_213, var_244);
            var_247 = wp::add(var_coord_start, var_246);
            // wp::array_store(var_joint_q_new, var_247, var_245);
            // joint_qd_new[dof_start + 0] = v_parent_new[0]                                  <L 565>
            var_249 = wp::extract(var_219, var_248);
            var_251 = wp::add(var_dof_start, var_250);
            // wp::array_store(var_joint_qd_new, var_251, var_249);
            // joint_qd_new[dof_start + 1] = v_parent_new[1]                                  <L 566>
            var_253 = wp::extract(var_219, var_252);
            var_255 = wp::add(var_dof_start, var_254);
            // wp::array_store(var_joint_qd_new, var_255, var_253);
            // joint_qd_new[dof_start + 2] = v_parent_new[2]                                  <L 567>
            var_257 = wp::extract(var_219, var_256);
            var_259 = wp::add(var_dof_start, var_258);
            // wp::array_store(var_joint_qd_new, var_259, var_257);
            // joint_qd_new[dof_start + 3] = omega_new[0]                                     <L 568>
            var_261 = wp::extract(var_203, var_260);
            var_263 = wp::add(var_dof_start, var_262);
            // wp::array_store(var_joint_qd_new, var_263, var_261);
            // joint_qd_new[dof_start + 4] = omega_new[1]                                     <L 569>
            var_265 = wp::extract(var_203, var_264);
            var_267 = wp::add(var_dof_start, var_266);
            // wp::array_store(var_joint_qd_new, var_267, var_265);
            // joint_qd_new[dof_start + 5] = omega_new[2]                                     <L 570>
            var_269 = wp::extract(var_203, var_268);
            var_271 = wp::add(var_dof_start, var_270);
            // wp::array_store(var_joint_qd_new, var_271, var_269);
            // return                                                                         <L 571>
            goto label3;
        }
        // a_s = wp.vec3(joint_qdd[dof_start + 0], joint_qdd[dof_start + 1], joint_qdd[dof_start + 2])       <L 573>
        var_273 = wp::add(var_dof_start, var_272);
        var_274 = wp::address(var_joint_qdd, var_273);
        var_276 = wp::add(var_dof_start, var_275);
        var_277 = wp::address(var_joint_qdd, var_276);
        var_279 = wp::add(var_dof_start, var_278);
        var_280 = wp::address(var_joint_qdd, var_279);
        var_282 = wp::load(var_274);
        var_283 = wp::load(var_277);
        var_284 = wp::load(var_280);
        var_281 = wp::vec_t<3, wp::float32>(var_282, var_283, var_284);
        // m_s = wp.vec3(joint_qdd[dof_start + 3], joint_qdd[dof_start + 4], joint_qdd[dof_start + 5])       <L 574>
        var_286 = wp::add(var_dof_start, var_285);
        var_287 = wp::address(var_joint_qdd, var_286);
        var_289 = wp::add(var_dof_start, var_288);
        var_290 = wp::address(var_joint_qdd, var_289);
        var_292 = wp::add(var_dof_start, var_291);
        var_293 = wp::address(var_joint_qdd, var_292);
        var_295 = wp::load(var_287);
        var_296 = wp::load(var_290);
        var_297 = wp::load(var_293);
        var_294 = wp::vec_t<3, wp::float32>(var_295, var_296, var_297);
        // v_s = wp.vec3(joint_qd[dof_start + 0], joint_qd[dof_start + 1], joint_qd[dof_start + 2])       <L 576>
        var_299 = wp::add(var_dof_start, var_298);
        var_300 = wp::address(var_joint_qd, var_299);
        var_302 = wp::add(var_dof_start, var_301);
        var_303 = wp::address(var_joint_qd, var_302);
        var_305 = wp::add(var_dof_start, var_304);
        var_306 = wp::address(var_joint_qd, var_305);
        var_308 = wp::load(var_300);
        var_309 = wp::load(var_303);
        var_310 = wp::load(var_306);
        var_307 = wp::vec_t<3, wp::float32>(var_308, var_309, var_310);
        // w_s = wp.vec3(joint_qd[dof_start + 3], joint_qd[dof_start + 4], joint_qd[dof_start + 5])       <L 577>
        var_312 = wp::add(var_dof_start, var_311);
        var_313 = wp::address(var_joint_qd, var_312);
        var_315 = wp::add(var_dof_start, var_314);
        var_316 = wp::address(var_joint_qd, var_315);
        var_318 = wp::add(var_dof_start, var_317);
        var_319 = wp::address(var_joint_qd, var_318);
        var_321 = wp::load(var_313);
        var_322 = wp::load(var_316);
        var_323 = wp::load(var_319);
        var_320 = wp::vec_t<3, wp::float32>(var_321, var_322, var_323);
        // w_s = w_s + m_s * dt                                                               <L 582>
        var_324 = wp::mul(var_294, var_dt);
        var_325 = wp::add(var_320, var_324);
        // v_s = v_s + a_s * dt                                                               <L 583>
        var_326 = wp::mul(var_281, var_dt);
        var_327 = wp::add(var_307, var_326);
        // p_s = wp.vec3(joint_q[coord_start + 0], joint_q[coord_start + 1], joint_q[coord_start + 2])       <L 585>
        var_329 = wp::add(var_coord_start, var_328);
        var_330 = wp::address(var_joint_q, var_329);
        var_332 = wp::add(var_coord_start, var_331);
        var_333 = wp::address(var_joint_q, var_332);
        var_335 = wp::add(var_coord_start, var_334);
        var_336 = wp::address(var_joint_q, var_335);
        var_338 = wp::load(var_330);
        var_339 = wp::load(var_333);
        var_340 = wp::load(var_336);
        var_337 = wp::vec_t<3, wp::float32>(var_338, var_339, var_340);
        // dpdt_s = v_s + wp.cross(w_s, p_s)                                                  <L 587>
        var_341 = wp::cross(var_325, var_337);
        var_342 = wp::add(var_327, var_341);
        // r_s = wp.quat(                                                                     <L 588>
        // joint_q[coord_start + 3], joint_q[coord_start + 4], joint_q[coord_start + 5], joint_q[coord_start + 6]       <L 589>
        var_344 = wp::add(var_coord_start, var_343);
        var_345 = wp::address(var_joint_q, var_344);
        var_347 = wp::add(var_coord_start, var_346);
        var_348 = wp::address(var_joint_q, var_347);
        var_350 = wp::add(var_coord_start, var_349);
        var_351 = wp::address(var_joint_q, var_350);
        var_353 = wp::add(var_coord_start, var_352);
        var_354 = wp::address(var_joint_q, var_353);
        var_356 = wp::load(var_345);
        var_357 = wp::load(var_348);
        var_358 = wp::load(var_351);
        var_359 = wp::load(var_354);
        var_355 = wp::quat_t<wp::float32>(var_356, var_357, var_358, var_359);
        // drdt_s = wp.quat(w_s, 0.0) * r_s * 0.5                                             <L 592>
        var_361 = wp::quat_t<wp::float32>(var_325, var_360);
        var_362 = wp::mul(var_361, var_355);
        var_364 = wp::mul(var_362, var_363);
        // p_s_new = p_s + dpdt_s * dt                                                        <L 594>
        var_365 = wp::mul(var_342, var_dt);
        var_366 = wp::add(var_337, var_365);
        // r_s_new = wp.normalize(r_s + drdt_s * dt)                                          <L 595>
        var_367 = wp::mul(var_364, var_dt);
        var_368 = wp::add(var_355, var_367);
        var_369 = wp::normalize(var_368);
        // joint_q_new[coord_start + 0] = p_s_new[0]                                          <L 597>
        var_371 = wp::extract(var_366, var_370);
        var_373 = wp::add(var_coord_start, var_372);
        // wp::array_store(var_joint_q_new, var_373, var_371);
        // joint_q_new[coord_start + 1] = p_s_new[1]                                          <L 598>
        var_375 = wp::extract(var_366, var_374);
        var_377 = wp::add(var_coord_start, var_376);
        // wp::array_store(var_joint_q_new, var_377, var_375);
        // joint_q_new[coord_start + 2] = p_s_new[2]                                          <L 599>
        var_379 = wp::extract(var_366, var_378);
        var_381 = wp::add(var_coord_start, var_380);
        // wp::array_store(var_joint_q_new, var_381, var_379);
        // joint_q_new[coord_start + 3] = r_s_new[0]                                          <L 601>
        var_383 = wp::extract(var_369, var_382);
        var_385 = wp::add(var_coord_start, var_384);
        // wp::array_store(var_joint_q_new, var_385, var_383);
        // joint_q_new[coord_start + 4] = r_s_new[1]                                          <L 602>
        var_387 = wp::extract(var_369, var_386);
        var_389 = wp::add(var_coord_start, var_388);
        // wp::array_store(var_joint_q_new, var_389, var_387);
        // joint_q_new[coord_start + 5] = r_s_new[2]                                          <L 603>
        var_391 = wp::extract(var_369, var_390);
        var_393 = wp::add(var_coord_start, var_392);
        // wp::array_store(var_joint_q_new, var_393, var_391);
        // joint_q_new[coord_start + 6] = r_s_new[3]                                          <L 604>
        var_395 = wp::extract(var_369, var_394);
        var_397 = wp::add(var_coord_start, var_396);
        // wp::array_store(var_joint_q_new, var_397, var_395);
        // joint_qd_new[dof_start + 0] = v_s[0]                                               <L 606>
        var_399 = wp::extract(var_327, var_398);
        var_401 = wp::add(var_dof_start, var_400);
        // wp::array_store(var_joint_qd_new, var_401, var_399);
        // joint_qd_new[dof_start + 1] = v_s[1]                                               <L 607>
        var_403 = wp::extract(var_327, var_402);
        var_405 = wp::add(var_dof_start, var_404);
        // wp::array_store(var_joint_qd_new, var_405, var_403);
        // joint_qd_new[dof_start + 2] = v_s[2]                                               <L 608>
        var_407 = wp::extract(var_327, var_406);
        var_409 = wp::add(var_dof_start, var_408);
        // wp::array_store(var_joint_qd_new, var_409, var_407);
        // joint_qd_new[dof_start + 3] = w_s[0]                                               <L 609>
        var_411 = wp::extract(var_325, var_410);
        var_413 = wp::add(var_dof_start, var_412);
        // wp::array_store(var_joint_qd_new, var_413, var_411);
        // joint_qd_new[dof_start + 4] = w_s[1]                                               <L 610>
        var_415 = wp::extract(var_325, var_414);
        var_417 = wp::add(var_dof_start, var_416);
        // wp::array_store(var_joint_qd_new, var_417, var_415);
        // joint_qd_new[dof_start + 5] = w_s[2]                                               <L 611>
        var_419 = wp::extract(var_325, var_418);
        var_421 = wp::add(var_dof_start, var_420);
        // wp::array_store(var_joint_qd_new, var_421, var_419);
        // return                                                                             <L 613>
        goto label4;
    }
    // if type == JointType.D6:                                                               <L 616>
    var_423 = (var_type == var_422);
    if (var_423) {
        // axis_count = lin_axis_count + ang_axis_count                                       <L 617>
        var_424 = wp::add(var_lin_axis_count, var_ang_axis_count);
        // for i in range(axis_count):                                                        <L 619>
        var_425 = wp::range(var_424);
        // return                                                                             <L 630>
        goto label7;
    }
    //---------
    // reverse
    if (var_423) {
        label7:;
        // adj: return                                                                        <L 630>
        var_425 = wp::iter_reverse(var_425);
        start_for_5:;
            if (iter_cmp(var_425) == 0) goto end_for_5;
            var_426 = wp::iter_next(var_425);
        	adj_427 = {};
        	adj_428 = {};
        	adj_429 = {};
        	adj_430 = {};
        	adj_431 = {};
        	adj_432 = {};
        	adj_433 = {};
        	adj_434 = {};
        	adj_435 = {};
        	adj_436 = {};
        	adj_437 = {};
        	adj_438 = {};
        	adj_439 = {};
        	adj_440 = {};
        	adj_441 = {};
        	adj_442 = {};
        	adj_443 = {};
        	adj_444 = {};
            // qdd = joint_qdd[dof_start + i]                                                 <L 620>
            var_427 = wp::add(var_dof_start, var_426);
            var_428 = wp::address(var_joint_qdd, var_427);
            var_430 = wp::load(var_428);
            var_429 = wp::copy(var_430);
            // qd = joint_qd[dof_start + i]                                                   <L 621>
            var_431 = wp::add(var_dof_start, var_426);
            var_432 = wp::address(var_joint_qd, var_431);
            var_434 = wp::load(var_432);
            var_433 = wp::copy(var_434);
            // q = joint_q[coord_start + i]                                                   <L 622>
            var_435 = wp::add(var_coord_start, var_426);
            var_436 = wp::address(var_joint_q, var_435);
            var_438 = wp::load(var_436);
            var_437 = wp::copy(var_438);
            // qd_new = qd + qdd * dt                                                         <L 624>
            var_439 = wp::mul(var_429, var_dt);
            var_440 = wp::add(var_433, var_439);
            // q_new = q + qd_new * dt                                                        <L 625>
            var_441 = wp::mul(var_440, var_dt);
            var_442 = wp::add(var_437, var_441);
            // joint_qd_new[dof_start + i] = qd_new                                           <L 627>
            var_443 = wp::add(var_dof_start, var_426);
            // wp::array_store(var_joint_qd_new, var_443, var_440);
            // joint_q_new[coord_start + i] = q_new                                           <L 628>
            var_444 = wp::add(var_coord_start, var_426);
            // wp::array_store(var_joint_q_new, var_444, var_442);
            wp::assign(var_8, var_429);
            wp::assign(var_11, var_433);
            wp::assign(var_14, var_437);
            wp::assign(var_17, var_440);
            wp::assign(var_19, var_442);
            wp::adj_assign(var_19, var_442, adj_19, adj_442);
            wp::adj_assign(var_17, var_440, adj_17, adj_440);
            wp::adj_assign(var_14, var_437, adj_14, adj_437);
            wp::adj_assign(var_11, var_433, adj_11, adj_433);
            wp::adj_assign(var_8, var_429, adj_8, adj_429);
            wp::adj_array_store(var_joint_q_new, var_444, var_442, adj_joint_q_new, adj_444, adj_442);
            wp::adj_add(var_coord_start, var_426, adj_coord_start, adj_426, adj_444);
            // adj: joint_q_new[coord_start + i] = q_new                                      <L 628>
            wp::adj_array_store(var_joint_qd_new, var_443, var_440, adj_joint_qd_new, adj_443, adj_440);
            wp::adj_add(var_dof_start, var_426, adj_dof_start, adj_426, adj_443);
            // adj: joint_qd_new[dof_start + i] = qd_new                                      <L 627>
            wp::adj_add(var_437, var_441, adj_437, adj_441, adj_442);
            wp::adj_mul(var_440, var_dt, adj_440, adj_dt, adj_441);
            // adj: q_new = q + qd_new * dt                                                   <L 625>
            wp::adj_add(var_433, var_439, adj_433, adj_439, adj_440);
            wp::adj_mul(var_429, var_dt, adj_429, adj_dt, adj_439);
            // adj: qd_new = qd + qdd * dt                                                    <L 624>
            wp::adj_copy(var_438, adj_436, adj_437);
            wp::adj_address(var_joint_q, var_435, adj_joint_q, adj_435, adj_436);
            wp::adj_add(var_coord_start, var_426, adj_coord_start, adj_426, adj_435);
            // adj: q = joint_q[coord_start + i]                                              <L 622>
            wp::adj_copy(var_434, adj_432, adj_433);
            wp::adj_address(var_joint_qd, var_431, adj_joint_qd, adj_431, adj_432);
            wp::adj_add(var_dof_start, var_426, adj_dof_start, adj_426, adj_431);
            // adj: qd = joint_qd[dof_start + i]                                              <L 621>
            wp::adj_copy(var_430, adj_428, adj_429);
            wp::adj_address(var_joint_qdd, var_427, adj_joint_qdd, adj_427, adj_428);
            wp::adj_add(var_dof_start, var_426, adj_dof_start, adj_426, adj_427);
            // adj: qdd = joint_qdd[dof_start + i]                                            <L 620>
        	goto start_for_5;
        end_for_5:;
        // adj: for i in range(axis_count):                                                   <L 619>
        wp::adj_add(var_lin_axis_count, var_ang_axis_count, adj_lin_axis_count, adj_ang_axis_count, adj_424);
        // adj: axis_count = lin_axis_count + ang_axis_count                                  <L 617>
    }
    // adj: if type == JointType.D6:                                                          <L 616>
    if (var_103) {
        label4:;
        // adj: return                                                                        <L 613>
        wp::adj_array_store(var_joint_qd_new, var_421, var_419, adj_joint_qd_new, adj_421, adj_419);
        wp::adj_add(var_dof_start, var_420, adj_dof_start, adj_420, adj_421);
        wp::adj_extract(var_325, var_418, adj_325, adj_418, adj_419);
        // adj: joint_qd_new[dof_start + 5] = w_s[2]                                          <L 611>
        wp::adj_array_store(var_joint_qd_new, var_417, var_415, adj_joint_qd_new, adj_417, adj_415);
        wp::adj_add(var_dof_start, var_416, adj_dof_start, adj_416, adj_417);
        wp::adj_extract(var_325, var_414, adj_325, adj_414, adj_415);
        // adj: joint_qd_new[dof_start + 4] = w_s[1]                                          <L 610>
        wp::adj_array_store(var_joint_qd_new, var_413, var_411, adj_joint_qd_new, adj_413, adj_411);
        wp::adj_add(var_dof_start, var_412, adj_dof_start, adj_412, adj_413);
        wp::adj_extract(var_325, var_410, adj_325, adj_410, adj_411);
        // adj: joint_qd_new[dof_start + 3] = w_s[0]                                          <L 609>
        wp::adj_array_store(var_joint_qd_new, var_409, var_407, adj_joint_qd_new, adj_409, adj_407);
        wp::adj_add(var_dof_start, var_408, adj_dof_start, adj_408, adj_409);
        wp::adj_extract(var_327, var_406, adj_327, adj_406, adj_407);
        // adj: joint_qd_new[dof_start + 2] = v_s[2]                                          <L 608>
        wp::adj_array_store(var_joint_qd_new, var_405, var_403, adj_joint_qd_new, adj_405, adj_403);
        wp::adj_add(var_dof_start, var_404, adj_dof_start, adj_404, adj_405);
        wp::adj_extract(var_327, var_402, adj_327, adj_402, adj_403);
        // adj: joint_qd_new[dof_start + 1] = v_s[1]                                          <L 607>
        wp::adj_array_store(var_joint_qd_new, var_401, var_399, adj_joint_qd_new, adj_401, adj_399);
        wp::adj_add(var_dof_start, var_400, adj_dof_start, adj_400, adj_401);
        wp::adj_extract(var_327, var_398, adj_327, adj_398, adj_399);
        // adj: joint_qd_new[dof_start + 0] = v_s[0]                                          <L 606>
        wp::adj_array_store(var_joint_q_new, var_397, var_395, adj_joint_q_new, adj_397, adj_395);
        wp::adj_add(var_coord_start, var_396, adj_coord_start, adj_396, adj_397);
        wp::adj_extract(var_369, var_394, adj_369, adj_394, adj_395);
        // adj: joint_q_new[coord_start + 6] = r_s_new[3]                                     <L 604>
        wp::adj_array_store(var_joint_q_new, var_393, var_391, adj_joint_q_new, adj_393, adj_391);
        wp::adj_add(var_coord_start, var_392, adj_coord_start, adj_392, adj_393);
        wp::adj_extract(var_369, var_390, adj_369, adj_390, adj_391);
        // adj: joint_q_new[coord_start + 5] = r_s_new[2]                                     <L 603>
        wp::adj_array_store(var_joint_q_new, var_389, var_387, adj_joint_q_new, adj_389, adj_387);
        wp::adj_add(var_coord_start, var_388, adj_coord_start, adj_388, adj_389);
        wp::adj_extract(var_369, var_386, adj_369, adj_386, adj_387);
        // adj: joint_q_new[coord_start + 4] = r_s_new[1]                                     <L 602>
        wp::adj_array_store(var_joint_q_new, var_385, var_383, adj_joint_q_new, adj_385, adj_383);
        wp::adj_add(var_coord_start, var_384, adj_coord_start, adj_384, adj_385);
        wp::adj_extract(var_369, var_382, adj_369, adj_382, adj_383);
        // adj: joint_q_new[coord_start + 3] = r_s_new[0]                                     <L 601>
        wp::adj_array_store(var_joint_q_new, var_381, var_379, adj_joint_q_new, adj_381, adj_379);
        wp::adj_add(var_coord_start, var_380, adj_coord_start, adj_380, adj_381);
        wp::adj_extract(var_366, var_378, adj_366, adj_378, adj_379);
        // adj: joint_q_new[coord_start + 2] = p_s_new[2]                                     <L 599>
        wp::adj_array_store(var_joint_q_new, var_377, var_375, adj_joint_q_new, adj_377, adj_375);
        wp::adj_add(var_coord_start, var_376, adj_coord_start, adj_376, adj_377);
        wp::adj_extract(var_366, var_374, adj_366, adj_374, adj_375);
        // adj: joint_q_new[coord_start + 1] = p_s_new[1]                                     <L 598>
        wp::adj_array_store(var_joint_q_new, var_373, var_371, adj_joint_q_new, adj_373, adj_371);
        wp::adj_add(var_coord_start, var_372, adj_coord_start, adj_372, adj_373);
        wp::adj_extract(var_366, var_370, adj_366, adj_370, adj_371);
        // adj: joint_q_new[coord_start + 0] = p_s_new[0]                                     <L 597>
        wp::adj_normalize(var_368, adj_368, adj_369);
        wp::adj_add(var_355, var_367, adj_355, adj_367, adj_368);
        wp::adj_mul(var_364, var_dt, adj_364, adj_dt, adj_367);
        // adj: r_s_new = wp.normalize(r_s + drdt_s * dt)                                     <L 595>
        wp::adj_add(var_337, var_365, adj_337, adj_365, adj_366);
        wp::adj_mul(var_342, var_dt, adj_342, adj_dt, adj_365);
        // adj: p_s_new = p_s + dpdt_s * dt                                                   <L 594>
        wp::adj_mul(var_362, var_363, adj_362, adj_363, adj_364);
        wp::adj_mul(var_361, var_355, adj_361, adj_355, adj_362);
        wp::adj_quat_t(var_325, var_360, adj_325, adj_360, adj_361);
        // adj: drdt_s = wp.quat(w_s, 0.0) * r_s * 0.5                                        <L 592>
        wp::adj_quat_t(var_356, var_357, var_358, var_359, adj_345, adj_348, adj_351, adj_354, adj_355);
        wp::adj_address(var_joint_q, var_353, adj_joint_q, adj_353, adj_354);
        wp::adj_add(var_coord_start, var_352, adj_coord_start, adj_352, adj_353);
        wp::adj_address(var_joint_q, var_350, adj_joint_q, adj_350, adj_351);
        wp::adj_add(var_coord_start, var_349, adj_coord_start, adj_349, adj_350);
        wp::adj_address(var_joint_q, var_347, adj_joint_q, adj_347, adj_348);
        wp::adj_add(var_coord_start, var_346, adj_coord_start, adj_346, adj_347);
        wp::adj_address(var_joint_q, var_344, adj_joint_q, adj_344, adj_345);
        wp::adj_add(var_coord_start, var_343, adj_coord_start, adj_343, adj_344);
        // adj: joint_q[coord_start + 3], joint_q[coord_start + 4], joint_q[coord_start + 5], joint_q[coord_start + 6]  <L 589>
        // adj: r_s = wp.quat(                                                                <L 588>
        wp::adj_add(var_327, var_341, adj_327, adj_341, adj_342);
        wp::adj_cross(var_325, var_337, adj_325, adj_337, adj_341);
        // adj: dpdt_s = v_s + wp.cross(w_s, p_s)                                             <L 587>
        wp::adj_vec_t(var_338, var_339, var_340, adj_330, adj_333, adj_336, adj_337);
        wp::adj_address(var_joint_q, var_335, adj_joint_q, adj_335, adj_336);
        wp::adj_add(var_coord_start, var_334, adj_coord_start, adj_334, adj_335);
        wp::adj_address(var_joint_q, var_332, adj_joint_q, adj_332, adj_333);
        wp::adj_add(var_coord_start, var_331, adj_coord_start, adj_331, adj_332);
        wp::adj_address(var_joint_q, var_329, adj_joint_q, adj_329, adj_330);
        wp::adj_add(var_coord_start, var_328, adj_coord_start, adj_328, adj_329);
        // adj: p_s = wp.vec3(joint_q[coord_start + 0], joint_q[coord_start + 1], joint_q[coord_start + 2])  <L 585>
        wp::adj_add(var_307, var_326, adj_307, adj_326, adj_327);
        wp::adj_mul(var_281, var_dt, adj_281, adj_dt, adj_326);
        // adj: v_s = v_s + a_s * dt                                                          <L 583>
        wp::adj_add(var_320, var_324, adj_320, adj_324, adj_325);
        wp::adj_mul(var_294, var_dt, adj_294, adj_dt, adj_324);
        // adj: w_s = w_s + m_s * dt                                                          <L 582>
        wp::adj_vec_t(var_321, var_322, var_323, adj_313, adj_316, adj_319, adj_320);
        wp::adj_address(var_joint_qd, var_318, adj_joint_qd, adj_318, adj_319);
        wp::adj_add(var_dof_start, var_317, adj_dof_start, adj_317, adj_318);
        wp::adj_address(var_joint_qd, var_315, adj_joint_qd, adj_315, adj_316);
        wp::adj_add(var_dof_start, var_314, adj_dof_start, adj_314, adj_315);
        wp::adj_address(var_joint_qd, var_312, adj_joint_qd, adj_312, adj_313);
        wp::adj_add(var_dof_start, var_311, adj_dof_start, adj_311, adj_312);
        // adj: w_s = wp.vec3(joint_qd[dof_start + 3], joint_qd[dof_start + 4], joint_qd[dof_start + 5])  <L 577>
        wp::adj_vec_t(var_308, var_309, var_310, adj_300, adj_303, adj_306, adj_307);
        wp::adj_address(var_joint_qd, var_305, adj_joint_qd, adj_305, adj_306);
        wp::adj_add(var_dof_start, var_304, adj_dof_start, adj_304, adj_305);
        wp::adj_address(var_joint_qd, var_302, adj_joint_qd, adj_302, adj_303);
        wp::adj_add(var_dof_start, var_301, adj_dof_start, adj_301, adj_302);
        wp::adj_address(var_joint_qd, var_299, adj_joint_qd, adj_299, adj_300);
        wp::adj_add(var_dof_start, var_298, adj_dof_start, adj_298, adj_299);
        // adj: v_s = wp.vec3(joint_qd[dof_start + 0], joint_qd[dof_start + 1], joint_qd[dof_start + 2])  <L 576>
        wp::adj_vec_t(var_295, var_296, var_297, adj_287, adj_290, adj_293, adj_294);
        wp::adj_address(var_joint_qdd, var_292, adj_joint_qdd, adj_292, adj_293);
        wp::adj_add(var_dof_start, var_291, adj_dof_start, adj_291, adj_292);
        wp::adj_address(var_joint_qdd, var_289, adj_joint_qdd, adj_289, adj_290);
        wp::adj_add(var_dof_start, var_288, adj_dof_start, adj_288, adj_289);
        wp::adj_address(var_joint_qdd, var_286, adj_joint_qdd, adj_286, adj_287);
        wp::adj_add(var_dof_start, var_285, adj_dof_start, adj_285, adj_286);
        // adj: m_s = wp.vec3(joint_qdd[dof_start + 3], joint_qdd[dof_start + 4], joint_qdd[dof_start + 5])  <L 574>
        wp::adj_vec_t(var_282, var_283, var_284, adj_274, adj_277, adj_280, adj_281);
        wp::adj_address(var_joint_qdd, var_279, adj_joint_qdd, adj_279, adj_280);
        wp::adj_add(var_dof_start, var_278, adj_dof_start, adj_278, adj_279);
        wp::adj_address(var_joint_qdd, var_276, adj_joint_qdd, adj_276, adj_277);
        wp::adj_add(var_dof_start, var_275, adj_dof_start, adj_275, adj_276);
        wp::adj_address(var_joint_qdd, var_273, adj_joint_qdd, adj_273, adj_274);
        wp::adj_add(var_dof_start, var_272, adj_dof_start, adj_272, adj_273);
        // adj: a_s = wp.vec3(joint_qdd[dof_start + 0], joint_qdd[dof_start + 1], joint_qdd[dof_start + 2])  <L 573>
        if (var_109) {
            label3:;
            // adj: return                                                                    <L 571>
            wp::adj_array_store(var_joint_qd_new, var_271, var_269, adj_joint_qd_new, adj_271, adj_269);
            wp::adj_add(var_dof_start, var_270, adj_dof_start, adj_270, adj_271);
            wp::adj_extract(var_203, var_268, adj_203, adj_268, adj_269);
            // adj: joint_qd_new[dof_start + 5] = omega_new[2]                                <L 570>
            wp::adj_array_store(var_joint_qd_new, var_267, var_265, adj_joint_qd_new, adj_267, adj_265);
            wp::adj_add(var_dof_start, var_266, adj_dof_start, adj_266, adj_267);
            wp::adj_extract(var_203, var_264, adj_203, adj_264, adj_265);
            // adj: joint_qd_new[dof_start + 4] = omega_new[1]                                <L 569>
            wp::adj_array_store(var_joint_qd_new, var_263, var_261, adj_joint_qd_new, adj_263, adj_261);
            wp::adj_add(var_dof_start, var_262, adj_dof_start, adj_262, adj_263);
            wp::adj_extract(var_203, var_260, adj_203, adj_260, adj_261);
            // adj: joint_qd_new[dof_start + 3] = omega_new[0]                                <L 568>
            wp::adj_array_store(var_joint_qd_new, var_259, var_257, adj_joint_qd_new, adj_259, adj_257);
            wp::adj_add(var_dof_start, var_258, adj_dof_start, adj_258, adj_259);
            wp::adj_extract(var_219, var_256, adj_219, adj_256, adj_257);
            // adj: joint_qd_new[dof_start + 2] = v_parent_new[2]                             <L 567>
            wp::adj_array_store(var_joint_qd_new, var_255, var_253, adj_joint_qd_new, adj_255, adj_253);
            wp::adj_add(var_dof_start, var_254, adj_dof_start, adj_254, adj_255);
            wp::adj_extract(var_219, var_252, adj_219, adj_252, adj_253);
            // adj: joint_qd_new[dof_start + 1] = v_parent_new[1]                             <L 566>
            wp::adj_array_store(var_joint_qd_new, var_251, var_249, adj_joint_qd_new, adj_251, adj_249);
            wp::adj_add(var_dof_start, var_250, adj_dof_start, adj_250, adj_251);
            wp::adj_extract(var_219, var_248, adj_219, adj_248, adj_249);
            // adj: joint_qd_new[dof_start + 0] = v_parent_new[0]                             <L 565>
            wp::adj_array_store(var_joint_q_new, var_247, var_245, adj_joint_q_new, adj_247, adj_245);
            wp::adj_add(var_coord_start, var_246, adj_coord_start, adj_246, adj_247);
            wp::adj_extract(var_213, var_244, adj_213, adj_244, adj_245);
            // adj: joint_q_new[coord_start + 6] = r_new[3]                                   <L 563>
            wp::adj_array_store(var_joint_q_new, var_243, var_241, adj_joint_q_new, adj_243, adj_241);
            wp::adj_add(var_coord_start, var_242, adj_coord_start, adj_242, adj_243);
            wp::adj_extract(var_213, var_240, adj_213, adj_240, adj_241);
            // adj: joint_q_new[coord_start + 5] = r_new[2]                                   <L 562>
            wp::adj_array_store(var_joint_q_new, var_239, var_237, adj_joint_q_new, adj_239, adj_237);
            wp::adj_add(var_coord_start, var_238, adj_coord_start, adj_238, adj_239);
            wp::adj_extract(var_213, var_236, adj_213, adj_236, adj_237);
            // adj: joint_q_new[coord_start + 4] = r_new[1]                                   <L 561>
            wp::adj_array_store(var_joint_q_new, var_235, var_233, adj_joint_q_new, adj_235, adj_233);
            wp::adj_add(var_coord_start, var_234, adj_coord_start, adj_234, adj_235);
            wp::adj_extract(var_213, var_232, adj_213, adj_232, adj_233);
            // adj: joint_q_new[coord_start + 3] = r_new[0]                                   <L 560>
            wp::adj_array_store(var_joint_q_new, var_231, var_229, adj_joint_q_new, adj_231, adj_229);
            wp::adj_add(var_coord_start, var_230, adj_coord_start, adj_230, adj_231);
            wp::adj_extract(var_217, var_228, adj_217, adj_228, adj_229);
            // adj: joint_q_new[coord_start + 2] = p_new[2]                                   <L 558>
            wp::adj_array_store(var_joint_q_new, var_227, var_225, adj_joint_q_new, adj_227, adj_225);
            wp::adj_add(var_coord_start, var_226, adj_coord_start, adj_226, adj_227);
            wp::adj_extract(var_217, var_224, adj_217, adj_224, adj_225);
            // adj: joint_q_new[coord_start + 1] = p_new[1]                                   <L 557>
            wp::adj_array_store(var_joint_q_new, var_223, var_221, adj_joint_q_new, adj_223, adj_221);
            wp::adj_add(var_coord_start, var_222, adj_coord_start, adj_222, adj_223);
            wp::adj_extract(var_217, var_220, adj_217, adj_220, adj_221);
            // adj: joint_q_new[coord_start + 0] = p_new[0]                                   <L 556>
            wp::adj_sub(var_205, var_218, adj_205, adj_218, adj_219);
            wp::adj_cross(var_203, var_215, adj_203, adj_215, adj_218);
            // adj: v_parent_new = v_com_new - wp.cross(omega_new, x_com_new)                 <L 554>
            wp::adj_sub(var_215, var_216, adj_215, adj_216, adj_217);
            wp::adj_quat_rotate(var_213, var_193, adj_213, adj_193, adj_216);
            // adj: p_new = x_com_new - wp.quat_rotate(r_new, r_com_joint)                    <L 553>
            wp::adj_add(var_195, var_214, adj_195, adj_214, adj_215);
            wp::adj_mul(var_205, var_dt, adj_205, adj_dt, adj_214);
            // adj: x_com_new = x_com + v_com_new * dt                                        <L 552>
            wp::adj_normalize(var_212, adj_212, adj_213);
            wp::adj_add(var_187, var_211, adj_187, adj_211, adj_212);
            wp::adj_mul(var_210, var_dt, adj_210, adj_dt, adj_211);
            // adj: r_new = wp.normalize(r + drdt * dt)                                       <L 551>
            wp::adj_mul(var_208, var_209, adj_208, adj_209, adj_210);
            wp::adj_mul(var_207, var_187, adj_207, adj_187, adj_208);
            wp::adj_quat_t(var_203, var_206, adj_203, adj_206, adj_207);
            // adj: drdt = wp.quat(omega_new, 0.0) * r * 0.5                                  <L 550>
            wp::adj_add(var_197, var_204, adj_197, adj_204, adj_205);
            wp::adj_mul(var_201, var_dt, adj_201, adj_dt, adj_204);
            // adj: v_com_new = v_com + a_com * dt                                            <L 548>
            wp::adj_add(var_158, var_202, adj_158, adj_202, adj_203);
            wp::adj_mul(var_132, var_dt, adj_132, adj_dt, adj_202);
            // adj: omega_new = omega + alpha * dt                                            <L 547>
            wp::adj_add(var_199, var_200, adj_199, adj_200, adj_201);
            wp::adj_cross(var_158, var_197, adj_158, adj_197, adj_200);
            wp::adj_add(var_119, var_198, adj_119, adj_198, adj_199);
            wp::adj_cross(var_132, var_195, adj_132, adj_195, adj_198);
            // adj: a_com = a_parent + wp.cross(alpha, x_com) + wp.cross(omega, v_com)        <L 545>
            wp::adj_add(var_145, var_196, adj_145, adj_196, adj_197);
            wp::adj_cross(var_158, var_195, adj_158, adj_195, adj_196);
            // adj: v_com = v_parent + wp.cross(omega, x_com)                                 <L 544>
            wp::adj_add(var_171, var_194, adj_171, adj_194, adj_195);
            wp::adj_quat_rotate(var_187, var_193, adj_187, adj_193, adj_194);
            // adj: x_com = p + wp.quat_rotate(r, r_com_joint)                                <L 543>
            wp::adj_transform_point(var_192, var_body_com_child, adj_192, adj_body_com_child, adj_193);
            wp::adj_transform_inverse(var_joint_X_c, adj_joint_X_c, adj_192);
            // adj: r_com_joint = wp.transform_point(wp.transform_inverse(joint_X_c), body_com_child)  <L 542>
            wp::adj_quat_t(var_188, var_189, var_190, var_191, adj_177, adj_180, adj_183, adj_186, adj_187);
            wp::adj_address(var_joint_q, var_185, adj_joint_q, adj_185, adj_186);
            wp::adj_add(var_coord_start, var_184, adj_coord_start, adj_184, adj_185);
            wp::adj_address(var_joint_q, var_182, adj_joint_q, adj_182, adj_183);
            wp::adj_add(var_coord_start, var_181, adj_coord_start, adj_181, adj_182);
            wp::adj_address(var_joint_q, var_179, adj_joint_q, adj_179, adj_180);
            wp::adj_add(var_coord_start, var_178, adj_coord_start, adj_178, adj_179);
            wp::adj_address(var_joint_q, var_176, adj_joint_q, adj_176, adj_177);
            wp::adj_add(var_coord_start, var_175, adj_coord_start, adj_175, adj_176);
            // adj: joint_q[coord_start + 3], joint_q[coord_start + 4], joint_q[coord_start + 5], joint_q[coord_start + 6]  <L 539>
            // adj: r = wp.quat(                                                              <L 538>
            wp::adj_vec_t(var_172, var_173, var_174, adj_164, adj_167, adj_170, adj_171);
            wp::adj_address(var_joint_q, var_169, adj_joint_q, adj_169, adj_170);
            wp::adj_add(var_coord_start, var_168, adj_coord_start, adj_168, adj_169);
            wp::adj_address(var_joint_q, var_166, adj_joint_q, adj_166, adj_167);
            wp::adj_add(var_coord_start, var_165, adj_coord_start, adj_165, adj_166);
            wp::adj_address(var_joint_q, var_163, adj_joint_q, adj_163, adj_164);
            wp::adj_add(var_coord_start, var_162, adj_coord_start, adj_162, adj_163);
            // adj: p = wp.vec3(joint_q[coord_start + 0], joint_q[coord_start + 1], joint_q[coord_start + 2])  <L 537>
            wp::adj_vec_t(var_159, var_160, var_161, adj_151, adj_154, adj_157, adj_158);
            wp::adj_address(var_joint_qd, var_156, adj_joint_qd, adj_156, adj_157);
            wp::adj_add(var_dof_start, var_155, adj_dof_start, adj_155, adj_156);
            wp::adj_address(var_joint_qd, var_153, adj_joint_qd, adj_153, adj_154);
            wp::adj_add(var_dof_start, var_152, adj_dof_start, adj_152, adj_153);
            wp::adj_address(var_joint_qd, var_150, adj_joint_qd, adj_150, adj_151);
            wp::adj_add(var_dof_start, var_149, adj_dof_start, adj_149, adj_150);
            // adj: omega = wp.vec3(joint_qd[dof_start + 3], joint_qd[dof_start + 4], joint_qd[dof_start + 5])  <L 535>
            wp::adj_vec_t(var_146, var_147, var_148, adj_138, adj_141, adj_144, adj_145);
            wp::adj_address(var_joint_qd, var_143, adj_joint_qd, adj_143, adj_144);
            wp::adj_add(var_dof_start, var_142, adj_dof_start, adj_142, adj_143);
            wp::adj_address(var_joint_qd, var_140, adj_joint_qd, adj_140, adj_141);
            wp::adj_add(var_dof_start, var_139, adj_dof_start, adj_139, adj_140);
            wp::adj_address(var_joint_qd, var_137, adj_joint_qd, adj_137, adj_138);
            wp::adj_add(var_dof_start, var_136, adj_dof_start, adj_136, adj_137);
            // adj: v_parent = wp.vec3(joint_qd[dof_start + 0], joint_qd[dof_start + 1], joint_qd[dof_start + 2])  <L 534>
            wp::adj_vec_t(var_133, var_134, var_135, adj_125, adj_128, adj_131, adj_132);
            wp::adj_address(var_joint_qdd, var_130, adj_joint_qdd, adj_130, adj_131);
            wp::adj_add(var_dof_start, var_129, adj_dof_start, adj_129, adj_130);
            wp::adj_address(var_joint_qdd, var_127, adj_joint_qdd, adj_127, adj_128);
            wp::adj_add(var_dof_start, var_126, adj_dof_start, adj_126, adj_127);
            wp::adj_address(var_joint_qdd, var_124, adj_joint_qdd, adj_124, adj_125);
            wp::adj_add(var_dof_start, var_123, adj_dof_start, adj_123, adj_124);
            // adj: alpha = wp.vec3(joint_qdd[dof_start + 3], joint_qdd[dof_start + 4], joint_qdd[dof_start + 5])  <L 532>
            wp::adj_vec_t(var_120, var_121, var_122, adj_112, adj_115, adj_118, adj_119);
            wp::adj_address(var_joint_qdd, var_117, adj_joint_qdd, adj_117, adj_118);
            wp::adj_add(var_dof_start, var_116, adj_dof_start, adj_116, adj_117);
            wp::adj_address(var_joint_qdd, var_114, adj_joint_qdd, adj_114, adj_115);
            wp::adj_add(var_dof_start, var_113, adj_dof_start, adj_113, adj_114);
            wp::adj_address(var_joint_qdd, var_111, adj_joint_qdd, adj_111, adj_112);
            wp::adj_add(var_dof_start, var_110, adj_dof_start, adj_110, adj_111);
            // adj: a_parent = wp.vec3(joint_qdd[dof_start + 0], joint_qdd[dof_start + 1], joint_qdd[dof_start + 2])  <L 531>
        }
        // adj: if parent < 0:                                                                <L 530>
    }
    if (!var_103) {
    }
    // adj: if type == JointType.FREE or type == JointType.DISTANCE:                          <L 529>
    if (var_21) {
        label2:;
        // adj: return                                                                        <L 527>
        wp::adj_array_store(var_joint_qd_new, var_102, var_100, adj_joint_qd_new, adj_102, adj_100);
        wp::adj_add(var_dof_start, var_101, adj_dof_start, adj_101, adj_102);
        wp::adj_extract(var_66, var_99, adj_66, adj_99, adj_100);
        // adj: joint_qd_new[dof_start + 2] = w_j_new[2]                                      <L 525>
        wp::adj_array_store(var_joint_qd_new, var_98, var_96, adj_joint_qd_new, adj_98, adj_96);
        wp::adj_add(var_dof_start, var_97, adj_dof_start, adj_97, adj_98);
        wp::adj_extract(var_66, var_95, adj_66, adj_95, adj_96);
        // adj: joint_qd_new[dof_start + 1] = w_j_new[1]                                      <L 524>
        wp::adj_array_store(var_joint_qd_new, var_94, var_92, adj_joint_qd_new, adj_94, adj_92);
        wp::adj_add(var_dof_start, var_93, adj_dof_start, adj_93, adj_94);
        wp::adj_extract(var_66, var_91, adj_66, adj_91, adj_92);
        // adj: joint_qd_new[dof_start + 0] = w_j_new[0]                                      <L 523>
        wp::adj_array_store(var_joint_q_new, var_90, var_88, adj_joint_q_new, adj_90, adj_88);
        wp::adj_add(var_coord_start, var_89, adj_coord_start, adj_89, adj_90);
        wp::adj_extract(var_74, var_87, adj_74, adj_87, adj_88);
        // adj: joint_q_new[coord_start + 3] = r_j_new[3]                                     <L 520>
        wp::adj_array_store(var_joint_q_new, var_86, var_84, adj_joint_q_new, adj_86, adj_84);
        wp::adj_add(var_coord_start, var_85, adj_coord_start, adj_85, adj_86);
        wp::adj_extract(var_74, var_83, adj_74, adj_83, adj_84);
        // adj: joint_q_new[coord_start + 2] = r_j_new[2]                                     <L 519>
        wp::adj_array_store(var_joint_q_new, var_82, var_80, adj_joint_q_new, adj_82, adj_80);
        wp::adj_add(var_coord_start, var_81, adj_coord_start, adj_81, adj_82);
        wp::adj_extract(var_74, var_79, adj_74, adj_79, adj_80);
        // adj: joint_q_new[coord_start + 1] = r_j_new[1]                                     <L 518>
        wp::adj_array_store(var_joint_q_new, var_78, var_76, adj_joint_q_new, adj_78, adj_76);
        wp::adj_add(var_coord_start, var_77, adj_coord_start, adj_77, adj_78);
        wp::adj_extract(var_74, var_75, adj_74, adj_75, adj_76);
        // adj: joint_q_new[coord_start + 0] = r_j_new[0]                                     <L 517>
        wp::adj_normalize(var_73, adj_73, adj_74);
        wp::adj_add(var_60, var_72, adj_60, adj_72, adj_73);
        wp::adj_mul(var_71, var_dt, adj_71, adj_dt, adj_72);
        // adj: r_j_new = wp.normalize(r_j + drdt_j * dt)                                     <L 514>
        wp::adj_mul(var_69, var_70, adj_69, adj_70, adj_71);
        wp::adj_mul(var_68, var_60, adj_68, adj_60, adj_69);
        wp::adj_quat_t(var_66, var_67, adj_66, adj_67, adj_68);
        // adj: drdt_j = wp.quat(w_j_new, 0.0) * r_j * 0.5                                    <L 511>
        wp::adj_add(var_44, var_65, adj_44, adj_65, adj_66);
        wp::adj_mul(var_31, var_dt, adj_31, adj_dt, adj_65);
        // adj: w_j_new = w_j + m_j * dt                                                      <L 509>
        wp::adj_quat_t(var_61, var_62, var_63, var_64, adj_50, adj_53, adj_56, adj_59, adj_60);
        wp::adj_address(var_joint_q, var_58, adj_joint_q, adj_58, adj_59);
        wp::adj_add(var_coord_start, var_57, adj_coord_start, adj_57, adj_58);
        wp::adj_address(var_joint_q, var_55, adj_joint_q, adj_55, adj_56);
        wp::adj_add(var_coord_start, var_54, adj_coord_start, adj_54, adj_55);
        wp::adj_address(var_joint_q, var_52, adj_joint_q, adj_52, adj_53);
        wp::adj_add(var_coord_start, var_51, adj_coord_start, adj_51, adj_52);
        wp::adj_address(var_joint_q, var_49, adj_joint_q, adj_49, adj_50);
        wp::adj_add(var_coord_start, var_48, adj_coord_start, adj_48, adj_49);
        // adj: joint_q[coord_start + 0], joint_q[coord_start + 1], joint_q[coord_start + 2], joint_q[coord_start + 3]  <L 505>
        // adj: r_j = wp.quat(                                                                <L 504>
        wp::adj_vec_t(var_45, var_46, var_47, adj_37, adj_40, adj_43, adj_44);
        wp::adj_address(var_joint_qd, var_42, adj_joint_qd, adj_42, adj_43);
        wp::adj_add(var_dof_start, var_41, adj_dof_start, adj_41, adj_42);
        wp::adj_address(var_joint_qd, var_39, adj_joint_qd, adj_39, adj_40);
        wp::adj_add(var_dof_start, var_38, adj_dof_start, adj_38, adj_39);
        wp::adj_address(var_joint_qd, var_36, adj_joint_qd, adj_36, adj_37);
        wp::adj_add(var_dof_start, var_35, adj_dof_start, adj_35, adj_36);
        // adj: w_j = wp.vec3(joint_qd[dof_start + 0], joint_qd[dof_start + 1], joint_qd[dof_start + 2])  <L 502>
        wp::adj_vec_t(var_32, var_33, var_34, adj_24, adj_27, adj_30, adj_31);
        wp::adj_address(var_joint_qdd, var_29, adj_joint_qdd, adj_29, adj_30);
        wp::adj_add(var_dof_start, var_28, adj_dof_start, adj_28, adj_29);
        wp::adj_address(var_joint_qdd, var_26, adj_joint_qdd, adj_26, adj_27);
        wp::adj_add(var_dof_start, var_25, adj_dof_start, adj_25, adj_26);
        wp::adj_address(var_joint_qdd, var_23, adj_joint_qdd, adj_23, adj_24);
        wp::adj_add(var_dof_start, var_22, adj_dof_start, adj_22, adj_23);
        // adj: m_j = wp.vec3(joint_qdd[dof_start + 0], joint_qdd[dof_start + 1], joint_qdd[dof_start + 2])  <L 501>
    }
    // adj: if type == JointType.BALL:                                                        <L 500>
    if (var_2) {
        label1:;
        // adj: return                                                                        <L 497>
        wp::adj_array_store(var_joint_q_new, var_coord_start, var_19, adj_joint_q_new, adj_coord_start, adj_19);
        // adj: joint_q_new[coord_start] = q_new                                              <L 495>
        wp::adj_array_store(var_joint_qd_new, var_dof_start, var_17, adj_joint_qd_new, adj_dof_start, adj_17);
        // adj: joint_qd_new[dof_start] = qd_new                                              <L 494>
        wp::adj_add(var_14, var_18, adj_14, adj_18, adj_19);
        wp::adj_mul(var_17, var_dt, adj_17, adj_dt, adj_18);
        // adj: q_new = q + qd_new * dt                                                       <L 492>
        wp::adj_add(var_11, var_16, adj_11, adj_16, adj_17);
        wp::adj_mul(var_8, var_dt, adj_8, adj_dt, adj_16);
        // adj: qd_new = qd + qdd * dt                                                        <L 491>
        wp::adj_copy(var_15, adj_13, adj_14);
        wp::adj_address(var_joint_q, var_coord_start, adj_joint_q, adj_coord_start, adj_13);
        // adj: q = joint_q[coord_start]                                                      <L 489>
        wp::adj_copy(var_12, adj_10, adj_11);
        wp::adj_address(var_joint_qd, var_dof_start, adj_joint_qd, adj_dof_start, adj_10);
        // adj: qd = joint_qd[dof_start]                                                      <L 488>
        wp::adj_copy(var_9, adj_7, adj_8);
        wp::adj_address(var_joint_qdd, var_dof_start, adj_joint_qdd, adj_dof_start, adj_7);
        // adj: qdd = joint_qdd[dof_start]                                                    <L 487>
    }
    if (!var_2) {
    }
    // adj: if type == JointType.PRISMATIC or type == JointType.REVOLUTE:                     <L 486>
    if (var_1) {
        label0:;
        // adj: return                                                                        <L 483>
    }
    // adj: if type == JointType.FIXED:                                                       <L 482>
    // adj: def jcalc_integrate(                                                              <L 465>
    return;
}



extern "C" __global__ void _zero_fixed_dof_jacobian_columns_c2b2f50c_cuda_kernel_forward(
    wp::launch_bounds_t<3> dim,
    wp::array_t<bool> var_joint_dof_mask,
    wp::array_t<wp::float32> var_jacobian)
{
    wp::tile_shared_storage_t tile_mem;

    for (size_t _idx = static_cast<size_t>(blockDim.x) * static_cast<size_t>(blockIdx.x) + static_cast<size_t>(threadIdx.x);
         _idx < dim.size;
         _idx += static_cast<size_t>(blockDim.x) * static_cast<size_t>(gridDim.x))
    {
            // reset shared memory allocator
        wp::tile_shared_storage_t::init();

        //---------
        // primal vars
        wp::int32 var_0;
        wp::int32 var_1;
        wp::int32 var_2;
        bool* var_3;
        bool var_4;
        bool var_5;
        const wp::float32 var_6 = 0.0;
        //---------
        // forward
        // def _zero_fixed_dof_jacobian_columns(                                                  <L 84>
        // row, residual, dof = wp.tid()                                                          <L 88>
        builtin_tid3d(var_0, var_1, var_2);
        // if not joint_dof_mask[dof]:                                                            <L 89>
        var_3 = wp::address(var_joint_dof_mask, var_2);
        var_5 = wp::load(var_3);
        var_4 = wp::unot(var_5);
        if (var_4) {
            // jacobian[row, residual, dof] = 0.0                                                 <L 90>
            wp::array_store(var_jacobian, var_0, var_1, var_2, var_6);
        }
    }
}



extern "C" __global__ void _zero_fixed_dof_jacobian_columns_c2b2f50c_cuda_kernel_backward(
    wp::launch_bounds_t<3> dim,
    wp::array_t<bool> var_joint_dof_mask,
    wp::array_t<wp::float32> var_jacobian,
    wp::array_t<bool> adj_joint_dof_mask,
    wp::array_t<wp::float32> adj_jacobian)
{
    wp::tile_shared_storage_t tile_mem;

    for (size_t _idx = static_cast<size_t>(blockDim.x) * static_cast<size_t>(blockIdx.x) + static_cast<size_t>(threadIdx.x);
         _idx < dim.size;
         _idx += static_cast<size_t>(blockDim.x) * static_cast<size_t>(gridDim.x))
    {
            // reset shared memory allocator
        wp::tile_shared_storage_t::init();

        //---------
        // primal vars
        wp::int32 var_0;
        wp::int32 var_1;
        wp::int32 var_2;
        bool* var_3;
        bool var_4;
        bool var_5;
        const wp::float32 var_6 = 0.0;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::int32 adj_2 = {};
        bool adj_3 = {};
        bool adj_4 = {};
        bool adj_5 = {};
        wp::float32 adj_6 = {};
        //---------
        // forward
        // def _zero_fixed_dof_jacobian_columns(                                                  <L 84>
        // row, residual, dof = wp.tid()                                                          <L 88>
        builtin_tid3d(var_0, var_1, var_2);
        // if not joint_dof_mask[dof]:                                                            <L 89>
        var_3 = wp::address(var_joint_dof_mask, var_2);
        var_5 = wp::load(var_3);
        var_4 = wp::unot(var_5);
        if (var_4) {
            // jacobian[row, residual, dof] = 0.0                                                 <L 90>
            // wp::array_store(var_jacobian, var_0, var_1, var_2, var_6);
        }
        //---------
        // reverse
        if (var_4) {
            wp::adj_array_store(var_jacobian, var_0, var_1, var_2, var_6, adj_jacobian, adj_0, adj_1, adj_2, adj_6);
            // adj: jacobian[row, residual, dof] = 0.0                                            <L 90>
        }
        wp::adj_address(var_joint_dof_mask, var_2, adj_joint_dof_mask, adj_2, adj_3);
        // adj: if not joint_dof_mask[dof]:                                                       <L 89>
        // adj: row, residual, dof = wp.tid()                                                     <L 88>
        // adj: def _zero_fixed_dof_jacobian_columns(                                             <L 84>
        continue;
    }
}



extern "C" __global__ void IKOptimizerLM___build_specialized__locals___integrate_dq_dof_168191bb_cuda_kernel_forward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::int32> var_joint_type,
    wp::array_t<wp::int32> var_joint_parent,
    wp::array_t<wp::int32> var_joint_child,
    wp::array_t<wp::int32> var_joint_q_start,
    wp::array_t<wp::int32> var_joint_qd_start,
    wp::array_t<wp::int32> var_joint_dof_dim,
    wp::array_t<wp::transform_t<wp::float32>> var_joint_X_c,
    wp::array_t<wp::vec_t<3, wp::float32>> var_body_com,
    wp::array_t<wp::float32> var_joint_q_curr,
    wp::array_t<wp::float32> var_joint_qd_curr,
    wp::array_t<wp::float32> var_dq_dof,
    wp::float32 var_dt,
    wp::array_t<wp::float32> var_joint_q_out,
    wp::array_t<wp::float32> var_joint_qd_out)
{
    wp::tile_shared_storage_t tile_mem;

    for (size_t _idx = static_cast<size_t>(blockDim.x) * static_cast<size_t>(blockIdx.x) + static_cast<size_t>(threadIdx.x);
         _idx < dim.size;
         _idx += static_cast<size_t>(blockDim.x) * static_cast<size_t>(gridDim.x))
    {
            // reset shared memory allocator
        wp::tile_shared_storage_t::init();

        //---------
        // primal vars
        wp::int32 var_0;
        wp::int32 var_1;
        wp::int32* var_2;
        wp::int32 var_3;
        wp::int32 var_4;
        wp::int32* var_5;
        wp::int32 var_6;
        wp::int32 var_7;
        wp::int32* var_8;
        wp::int32 var_9;
        wp::int32 var_10;
        wp::int32* var_11;
        wp::int32 var_12;
        wp::int32 var_13;
        wp::int32* var_14;
        wp::int32 var_15;
        wp::int32 var_16;
        const wp::int32 var_17 = 0;
        wp::int32* var_18;
        wp::int32 var_19;
        wp::int32 var_20;
        const wp::int32 var_21 = 1;
        wp::int32* var_22;
        wp::int32 var_23;
        wp::int32 var_24;
        wp::slice_t var_25;
        const wp::int32 var_26 = 0;
        wp::array_t<wp::float32> var_27;
        wp::slice_t var_28;
        const wp::int32 var_29 = 0;
        wp::array_t<wp::float32> var_30;
        wp::slice_t var_31;
        const wp::int32 var_32 = 0;
        wp::array_t<wp::float32> var_33;
        wp::slice_t var_34;
        const wp::int32 var_35 = 0;
        wp::array_t<wp::float32> var_36;
        wp::slice_t var_37;
        const wp::int32 var_38 = 0;
        wp::array_t<wp::float32> var_39;
        wp::transform_t<wp::float32>* var_40;
        wp::vec_t<3, wp::float32>* var_41;
        wp::transform_t<wp::float32> var_42;
        wp::vec_t<3, wp::float32> var_43;
        //---------
        // forward
        // def _integrate_dq_dof(                                                                 <L 800>
        // row, joint_idx = wp.tid()                                                              <L 829>
        builtin_tid2d(var_0, var_1);
        // t = joint_type[joint_idx]                                                              <L 832>
        var_2 = wp::address(var_joint_type, var_1);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // parent = joint_parent[joint_idx]                                                       <L 833>
        var_5 = wp::address(var_joint_parent, var_1);
        var_7 = wp::load(var_5);
        var_6 = wp::copy(var_7);
        // child = joint_child[joint_idx]                                                         <L 834>
        var_8 = wp::address(var_joint_child, var_1);
        var_10 = wp::load(var_8);
        var_9 = wp::copy(var_10);
        // coord_start = joint_q_start[joint_idx]                                                 <L 835>
        var_11 = wp::address(var_joint_q_start, var_1);
        var_13 = wp::load(var_11);
        var_12 = wp::copy(var_13);
        // dof_start = joint_qd_start[joint_idx]                                                  <L 836>
        var_14 = wp::address(var_joint_qd_start, var_1);
        var_16 = wp::load(var_14);
        var_15 = wp::copy(var_16);
        // lin_axes = joint_dof_dim[joint_idx, 0]                                                 <L 837>
        var_18 = wp::address(var_joint_dof_dim, var_1, var_17);
        var_20 = wp::load(var_18);
        var_19 = wp::copy(var_20);
        // ang_axes = joint_dof_dim[joint_idx, 1]                                                 <L 838>
        var_22 = wp::address(var_joint_dof_dim, var_1, var_21);
        var_24 = wp::load(var_22);
        var_23 = wp::copy(var_24);
        // q_row = joint_q_curr[row]                                                              <L 841>
        var_25 = wp::slice_t(var_0, var_0, var_26);
        var_27 = wp::view(var_joint_q_curr, var_25);
        // qd_row = joint_qd_curr[row]  # typically zero                                          <L 842>
        var_28 = wp::slice_t(var_0, var_0, var_29);
        var_30 = wp::view(var_joint_qd_curr, var_28);
        // delta_row = dq_dof[row]  # update vector                                               <L 843>
        var_31 = wp::slice_t(var_0, var_0, var_32);
        var_33 = wp::view(var_dq_dof, var_31);
        // q_out_row = joint_q_out[row]                                                           <L 845>
        var_34 = wp::slice_t(var_0, var_0, var_35);
        var_36 = wp::view(var_joint_q_out, var_34);
        // qd_out_row = joint_qd_out[row]                                                         <L 846>
        var_37 = wp::slice_t(var_0, var_0, var_38);
        var_39 = wp::view(var_joint_qd_out, var_37);
        // jcalc_integrate(                                                                       <L 851>
        // parent,                                                                                <L 852>
        // joint_X_c[joint_idx],                                                                  <L 853>
        var_40 = wp::address(var_joint_X_c, var_1);
        // body_com[child],                                                                       <L 854>
        var_41 = wp::address(var_body_com, var_9);
        // t,                                                                                     <L 855>
        // q_row,                                                                                 <L 856>
        // qd_row,                                                                                <L 857>
        // delta_row,  # passed as joint_qdd                                                      <L 858>
        // coord_start,                                                                           <L 859>
        // dof_start,                                                                             <L 860>
        // lin_axes,                                                                              <L 861>
        // ang_axes,                                                                              <L 862>
        // dt,                                                                                    <L 863>
        // q_out_row,                                                                             <L 864>
        // qd_out_row,                                                                            <L 865>
        var_42 = wp::load(var_40);
        var_43 = wp::load(var_41);
        jcalc_integrate_0(var_6, var_42, var_43, var_3, var_27, var_30, var_33, var_12, var_15, var_19, var_23, var_dt, var_36, var_39);
    }
}



extern "C" __global__ void IKOptimizerLM___build_specialized__locals___integrate_dq_dof_168191bb_cuda_kernel_backward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::int32> var_joint_type,
    wp::array_t<wp::int32> var_joint_parent,
    wp::array_t<wp::int32> var_joint_child,
    wp::array_t<wp::int32> var_joint_q_start,
    wp::array_t<wp::int32> var_joint_qd_start,
    wp::array_t<wp::int32> var_joint_dof_dim,
    wp::array_t<wp::transform_t<wp::float32>> var_joint_X_c,
    wp::array_t<wp::vec_t<3, wp::float32>> var_body_com,
    wp::array_t<wp::float32> var_joint_q_curr,
    wp::array_t<wp::float32> var_joint_qd_curr,
    wp::array_t<wp::float32> var_dq_dof,
    wp::float32 var_dt,
    wp::array_t<wp::float32> var_joint_q_out,
    wp::array_t<wp::float32> var_joint_qd_out,
    wp::array_t<wp::int32> adj_joint_type,
    wp::array_t<wp::int32> adj_joint_parent,
    wp::array_t<wp::int32> adj_joint_child,
    wp::array_t<wp::int32> adj_joint_q_start,
    wp::array_t<wp::int32> adj_joint_qd_start,
    wp::array_t<wp::int32> adj_joint_dof_dim,
    wp::array_t<wp::transform_t<wp::float32>> adj_joint_X_c,
    wp::array_t<wp::vec_t<3, wp::float32>> adj_body_com,
    wp::array_t<wp::float32> adj_joint_q_curr,
    wp::array_t<wp::float32> adj_joint_qd_curr,
    wp::array_t<wp::float32> adj_dq_dof,
    wp::float32 adj_dt,
    wp::array_t<wp::float32> adj_joint_q_out,
    wp::array_t<wp::float32> adj_joint_qd_out)
{
    wp::tile_shared_storage_t tile_mem;

    for (size_t _idx = static_cast<size_t>(blockDim.x) * static_cast<size_t>(blockIdx.x) + static_cast<size_t>(threadIdx.x);
         _idx < dim.size;
         _idx += static_cast<size_t>(blockDim.x) * static_cast<size_t>(gridDim.x))
    {
            // reset shared memory allocator
        wp::tile_shared_storage_t::init();

        //---------
        // primal vars
        wp::int32 var_0;
        wp::int32 var_1;
        wp::int32* var_2;
        wp::int32 var_3;
        wp::int32 var_4;
        wp::int32* var_5;
        wp::int32 var_6;
        wp::int32 var_7;
        wp::int32* var_8;
        wp::int32 var_9;
        wp::int32 var_10;
        wp::int32* var_11;
        wp::int32 var_12;
        wp::int32 var_13;
        wp::int32* var_14;
        wp::int32 var_15;
        wp::int32 var_16;
        const wp::int32 var_17 = 0;
        wp::int32* var_18;
        wp::int32 var_19;
        wp::int32 var_20;
        const wp::int32 var_21 = 1;
        wp::int32* var_22;
        wp::int32 var_23;
        wp::int32 var_24;
        wp::slice_t var_25;
        const wp::int32 var_26 = 0;
        wp::array_t<wp::float32> var_27;
        wp::slice_t var_28;
        const wp::int32 var_29 = 0;
        wp::array_t<wp::float32> var_30;
        wp::slice_t var_31;
        const wp::int32 var_32 = 0;
        wp::array_t<wp::float32> var_33;
        wp::slice_t var_34;
        const wp::int32 var_35 = 0;
        wp::array_t<wp::float32> var_36;
        wp::slice_t var_37;
        const wp::int32 var_38 = 0;
        wp::array_t<wp::float32> var_39;
        wp::transform_t<wp::float32>* var_40;
        wp::vec_t<3, wp::float32>* var_41;
        wp::transform_t<wp::float32> var_42;
        wp::vec_t<3, wp::float32> var_43;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::int32 adj_2 = {};
        wp::int32 adj_3 = {};
        wp::int32 adj_4 = {};
        wp::int32 adj_5 = {};
        wp::int32 adj_6 = {};
        wp::int32 adj_7 = {};
        wp::int32 adj_8 = {};
        wp::int32 adj_9 = {};
        wp::int32 adj_10 = {};
        wp::int32 adj_11 = {};
        wp::int32 adj_12 = {};
        wp::int32 adj_13 = {};
        wp::int32 adj_14 = {};
        wp::int32 adj_15 = {};
        wp::int32 adj_16 = {};
        wp::int32 adj_17 = {};
        wp::int32 adj_18 = {};
        wp::int32 adj_19 = {};
        wp::int32 adj_20 = {};
        wp::int32 adj_21 = {};
        wp::int32 adj_22 = {};
        wp::int32 adj_23 = {};
        wp::int32 adj_24 = {};
        wp::slice_t adj_25 = {};
        wp::int32 adj_26 = {};
        wp::array_t<wp::float32> adj_27 = {};
        wp::slice_t adj_28 = {};
        wp::int32 adj_29 = {};
        wp::array_t<wp::float32> adj_30 = {};
        wp::slice_t adj_31 = {};
        wp::int32 adj_32 = {};
        wp::array_t<wp::float32> adj_33 = {};
        wp::slice_t adj_34 = {};
        wp::int32 adj_35 = {};
        wp::array_t<wp::float32> adj_36 = {};
        wp::slice_t adj_37 = {};
        wp::int32 adj_38 = {};
        wp::array_t<wp::float32> adj_39 = {};
        wp::transform_t<wp::float32> adj_40 = {};
        wp::vec_t<3, wp::float32> adj_41 = {};
        wp::transform_t<wp::float32> adj_42 = {};
        wp::vec_t<3, wp::float32> adj_43 = {};
        //---------
        // forward
        // def _integrate_dq_dof(                                                                 <L 800>
        // row, joint_idx = wp.tid()                                                              <L 829>
        builtin_tid2d(var_0, var_1);
        // t = joint_type[joint_idx]                                                              <L 832>
        var_2 = wp::address(var_joint_type, var_1);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // parent = joint_parent[joint_idx]                                                       <L 833>
        var_5 = wp::address(var_joint_parent, var_1);
        var_7 = wp::load(var_5);
        var_6 = wp::copy(var_7);
        // child = joint_child[joint_idx]                                                         <L 834>
        var_8 = wp::address(var_joint_child, var_1);
        var_10 = wp::load(var_8);
        var_9 = wp::copy(var_10);
        // coord_start = joint_q_start[joint_idx]                                                 <L 835>
        var_11 = wp::address(var_joint_q_start, var_1);
        var_13 = wp::load(var_11);
        var_12 = wp::copy(var_13);
        // dof_start = joint_qd_start[joint_idx]                                                  <L 836>
        var_14 = wp::address(var_joint_qd_start, var_1);
        var_16 = wp::load(var_14);
        var_15 = wp::copy(var_16);
        // lin_axes = joint_dof_dim[joint_idx, 0]                                                 <L 837>
        var_18 = wp::address(var_joint_dof_dim, var_1, var_17);
        var_20 = wp::load(var_18);
        var_19 = wp::copy(var_20);
        // ang_axes = joint_dof_dim[joint_idx, 1]                                                 <L 838>
        var_22 = wp::address(var_joint_dof_dim, var_1, var_21);
        var_24 = wp::load(var_22);
        var_23 = wp::copy(var_24);
        // q_row = joint_q_curr[row]                                                              <L 841>
        var_25 = wp::slice_t(var_0, var_0, var_26);
        var_27 = wp::view(var_joint_q_curr, var_25);
        // qd_row = joint_qd_curr[row]  # typically zero                                          <L 842>
        var_28 = wp::slice_t(var_0, var_0, var_29);
        var_30 = wp::view(var_joint_qd_curr, var_28);
        // delta_row = dq_dof[row]  # update vector                                               <L 843>
        var_31 = wp::slice_t(var_0, var_0, var_32);
        var_33 = wp::view(var_dq_dof, var_31);
        // q_out_row = joint_q_out[row]                                                           <L 845>
        var_34 = wp::slice_t(var_0, var_0, var_35);
        var_36 = wp::view(var_joint_q_out, var_34);
        // qd_out_row = joint_qd_out[row]                                                         <L 846>
        var_37 = wp::slice_t(var_0, var_0, var_38);
        var_39 = wp::view(var_joint_qd_out, var_37);
        // jcalc_integrate(                                                                       <L 851>
        // parent,                                                                                <L 852>
        // joint_X_c[joint_idx],                                                                  <L 853>
        var_40 = wp::address(var_joint_X_c, var_1);
        // body_com[child],                                                                       <L 854>
        var_41 = wp::address(var_body_com, var_9);
        // t,                                                                                     <L 855>
        // q_row,                                                                                 <L 856>
        // qd_row,                                                                                <L 857>
        // delta_row,  # passed as joint_qdd                                                      <L 858>
        // coord_start,                                                                           <L 859>
        // dof_start,                                                                             <L 860>
        // lin_axes,                                                                              <L 861>
        // ang_axes,                                                                              <L 862>
        // dt,                                                                                    <L 863>
        // q_out_row,                                                                             <L 864>
        // qd_out_row,                                                                            <L 865>
        var_42 = wp::load(var_40);
        var_43 = wp::load(var_41);
        jcalc_integrate_0(var_6, var_42, var_43, var_3, var_27, var_30, var_33, var_12, var_15, var_19, var_23, var_dt, var_36, var_39);
        //---------
        // reverse
        adj_jcalc_integrate_0(var_6, var_42, var_43, var_3, var_27, var_30, var_33, var_12, var_15, var_19, var_23, var_dt, var_36, var_39, adj_6, adj_40, adj_41, adj_3, adj_27, adj_30, adj_33, adj_12, adj_15, adj_19, adj_23, adj_dt, adj_36, adj_39);
        // adj: qd_out_row,                                                                       <L 865>
        // adj: q_out_row,                                                                        <L 864>
        // adj: dt,                                                                               <L 863>
        // adj: ang_axes,                                                                         <L 862>
        // adj: lin_axes,                                                                         <L 861>
        // adj: dof_start,                                                                        <L 860>
        // adj: coord_start,                                                                      <L 859>
        // adj: delta_row,  # passed as joint_qdd                                                 <L 858>
        // adj: qd_row,                                                                           <L 857>
        // adj: q_row,                                                                            <L 856>
        // adj: t,                                                                                <L 855>
        wp::adj_address(var_body_com, var_9, adj_body_com, adj_9, adj_41);
        // adj: body_com[child],                                                                  <L 854>
        wp::adj_address(var_joint_X_c, var_1, adj_joint_X_c, adj_1, adj_40);
        // adj: joint_X_c[joint_idx],                                                             <L 853>
        // adj: parent,                                                                           <L 852>
        // adj: jcalc_integrate(                                                                  <L 851>
        wp::adj_view(var_joint_qd_out, var_37, adj_joint_qd_out, adj_37, adj_39);
        // adj: qd_out_row = joint_qd_out[row]                                                    <L 846>
        wp::adj_view(var_joint_q_out, var_34, adj_joint_q_out, adj_34, adj_36);
        // adj: q_out_row = joint_q_out[row]                                                      <L 845>
        wp::adj_view(var_dq_dof, var_31, adj_dq_dof, adj_31, adj_33);
        // adj: delta_row = dq_dof[row]  # update vector                                          <L 843>
        wp::adj_view(var_joint_qd_curr, var_28, adj_joint_qd_curr, adj_28, adj_30);
        // adj: qd_row = joint_qd_curr[row]  # typically zero                                     <L 842>
        wp::adj_view(var_joint_q_curr, var_25, adj_joint_q_curr, adj_25, adj_27);
        // adj: q_row = joint_q_curr[row]                                                         <L 841>
        wp::adj_copy(var_24, adj_22, adj_23);
        wp::adj_address(var_joint_dof_dim, var_1, var_21, adj_joint_dof_dim, adj_1, adj_21, adj_22);
        // adj: ang_axes = joint_dof_dim[joint_idx, 1]                                            <L 838>
        wp::adj_copy(var_20, adj_18, adj_19);
        wp::adj_address(var_joint_dof_dim, var_1, var_17, adj_joint_dof_dim, adj_1, adj_17, adj_18);
        // adj: lin_axes = joint_dof_dim[joint_idx, 0]                                            <L 837>
        wp::adj_copy(var_16, adj_14, adj_15);
        wp::adj_address(var_joint_qd_start, var_1, adj_joint_qd_start, adj_1, adj_14);
        // adj: dof_start = joint_qd_start[joint_idx]                                             <L 836>
        wp::adj_copy(var_13, adj_11, adj_12);
        wp::adj_address(var_joint_q_start, var_1, adj_joint_q_start, adj_1, adj_11);
        // adj: coord_start = joint_q_start[joint_idx]                                            <L 835>
        wp::adj_copy(var_10, adj_8, adj_9);
        wp::adj_address(var_joint_child, var_1, adj_joint_child, adj_1, adj_8);
        // adj: child = joint_child[joint_idx]                                                    <L 834>
        wp::adj_copy(var_7, adj_5, adj_6);
        wp::adj_address(var_joint_parent, var_1, adj_joint_parent, adj_1, adj_5);
        // adj: parent = joint_parent[joint_idx]                                                  <L 833>
        wp::adj_copy(var_4, adj_2, adj_3);
        wp::adj_address(var_joint_type, var_1, adj_joint_type, adj_1, adj_2);
        // adj: t = joint_type[joint_idx]                                                         <L 832>
        // adj: row, joint_idx = wp.tid()                                                         <L 829>
        // adj: def _integrate_dq_dof(                                                            <L 800>
        continue;
    }
}



extern "C" __global__ void _update_lm_state_dd8fb981_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::float32> var_joint_q_proposed,
    wp::array_t<wp::float32> var_residuals_proposed,
    wp::array_t<wp::float32> var_costs_proposed,
    wp::array_t<wp::int32> var_accept_flags,
    wp::int32 var_n_coords,
    wp::int32 var_num_residuals,
    wp::float32 var_lambda_factor,
    wp::float32 var_lambda_min,
    wp::float32 var_lambda_max,
    wp::array_t<wp::float32> var_joint_q_current,
    wp::array_t<wp::float32> var_residuals_current,
    wp::array_t<wp::float32> var_costs,
    wp::array_t<wp::float32> var_lambda_values)
{
    wp::tile_shared_storage_t tile_mem;

    for (size_t _idx = static_cast<size_t>(blockDim.x) * static_cast<size_t>(blockIdx.x) + static_cast<size_t>(threadIdx.x);
         _idx < dim.size;
         _idx += static_cast<size_t>(blockDim.x) * static_cast<size_t>(gridDim.x))
    {
            // reset shared memory allocator
        wp::tile_shared_storage_t::init();

        //---------
        // primal vars
        wp::int32 var_0;
        wp::int32* var_1;
        const wp::int32 var_2 = 1;
        bool var_3;
        wp::int32 var_4;
        wp::range_t var_5;
        wp::int32 var_6;
        wp::float32* var_7;
        wp::float32 var_8;
        wp::range_t var_9;
        wp::int32 var_10;
        wp::float32* var_11;
        wp::float32 var_12;
        wp::float32* var_13;
        wp::float32 var_14;
        wp::float32* var_15;
        wp::float32 var_16;
        wp::float32 var_17;
        wp::float32* var_18;
        wp::float32 var_19;
        wp::float32 var_20;
        wp::float32 var_21;
        //---------
        // forward
        // def _update_lm_state(                                                                  <L 54>
        // row = wp.tid()                                                                         <L 69>
        var_0 = builtin_tid1d();
        // if accept_flags[row] == 1:                                                             <L 71>
        var_1 = wp::address(var_accept_flags, var_0);
        var_4 = wp::load(var_1);
        var_3 = (var_4 == var_2);
        if (var_3) {
            // for i in range(n_coords):                                                          <L 72>
            var_5 = wp::range(var_n_coords);
            start_for_0:;
                if (iter_cmp(var_5) == 0) goto end_for_0;
                var_6 = wp::iter_next(var_5);
                // joint_q_current[row, i] = joint_q_proposed[row, i]                             <L 73>
                var_7 = wp::address(var_joint_q_proposed, var_0, var_6);
                var_8 = wp::load(var_7);
                wp::array_store(var_joint_q_current, var_0, var_6, var_8);
                goto start_for_0;
            end_for_0:;
            // for i in range(num_residuals):                                                     <L 74>
            var_9 = wp::range(var_num_residuals);
            start_for_2:;
                if (iter_cmp(var_9) == 0) goto end_for_2;
                var_10 = wp::iter_next(var_9);
                // residuals_current[row, i] = residuals_proposed[row, i]                         <L 75>
                var_11 = wp::address(var_residuals_proposed, var_0, var_10);
                var_12 = wp::load(var_11);
                wp::array_store(var_residuals_current, var_0, var_10, var_12);
                goto start_for_2;
            end_for_2:;
            // costs[row] = costs_proposed[row]                                                   <L 76>
            var_13 = wp::address(var_costs_proposed, var_0);
            var_14 = wp::load(var_13);
            wp::array_store(var_costs, var_0, var_14);
            // lambda_values[row] = lambda_values[row] / lambda_factor                            <L 77>
            var_15 = wp::address(var_lambda_values, var_0);
            var_17 = wp::load(var_15);
            var_16 = wp::div(var_17, var_lambda_factor);
            wp::array_store(var_lambda_values, var_0, var_16);
        }
        if (!var_3) {
            // new_lambda = lambda_values[row] * lambda_factor                                    <L 79>
            var_18 = wp::address(var_lambda_values, var_0);
            var_20 = wp::load(var_18);
            var_19 = wp::mul(var_20, var_lambda_factor);
            // lambda_values[row] = wp.clamp(new_lambda, lambda_min, lambda_max)                  <L 80>
            var_21 = wp::clamp(var_19, var_lambda_min, var_lambda_max);
            wp::array_store(var_lambda_values, var_0, var_21);
        }
    }
}



extern "C" __global__ void _update_lm_state_dd8fb981_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::float32> var_joint_q_proposed,
    wp::array_t<wp::float32> var_residuals_proposed,
    wp::array_t<wp::float32> var_costs_proposed,
    wp::array_t<wp::int32> var_accept_flags,
    wp::int32 var_n_coords,
    wp::int32 var_num_residuals,
    wp::float32 var_lambda_factor,
    wp::float32 var_lambda_min,
    wp::float32 var_lambda_max,
    wp::array_t<wp::float32> var_joint_q_current,
    wp::array_t<wp::float32> var_residuals_current,
    wp::array_t<wp::float32> var_costs,
    wp::array_t<wp::float32> var_lambda_values,
    wp::array_t<wp::float32> adj_joint_q_proposed,
    wp::array_t<wp::float32> adj_residuals_proposed,
    wp::array_t<wp::float32> adj_costs_proposed,
    wp::array_t<wp::int32> adj_accept_flags,
    wp::int32 adj_n_coords,
    wp::int32 adj_num_residuals,
    wp::float32 adj_lambda_factor,
    wp::float32 adj_lambda_min,
    wp::float32 adj_lambda_max,
    wp::array_t<wp::float32> adj_joint_q_current,
    wp::array_t<wp::float32> adj_residuals_current,
    wp::array_t<wp::float32> adj_costs,
    wp::array_t<wp::float32> adj_lambda_values)
{
    wp::tile_shared_storage_t tile_mem;

    for (size_t _idx = static_cast<size_t>(blockDim.x) * static_cast<size_t>(blockIdx.x) + static_cast<size_t>(threadIdx.x);
         _idx < dim.size;
         _idx += static_cast<size_t>(blockDim.x) * static_cast<size_t>(gridDim.x))
    {
            // reset shared memory allocator
        wp::tile_shared_storage_t::init();

        //---------
        // primal vars
        wp::int32 var_0;
        wp::int32* var_1;
        const wp::int32 var_2 = 1;
        bool var_3;
        wp::int32 var_4;
        wp::range_t var_5;
        wp::int32 var_6;
        wp::float32* var_7;
        wp::float32 var_8;
        wp::range_t var_9;
        wp::int32 var_10;
        wp::float32* var_11;
        wp::float32 var_12;
        wp::float32* var_13;
        wp::float32 var_14;
        wp::float32* var_15;
        wp::float32 var_16;
        wp::float32 var_17;
        wp::float32* var_18;
        wp::float32 var_19;
        wp::float32 var_20;
        wp::float32 var_21;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::int32 adj_2 = {};
        bool adj_3 = {};
        wp::int32 adj_4 = {};
        wp::range_t adj_5 = {};
        wp::int32 adj_6 = {};
        wp::float32 adj_7 = {};
        wp::float32 adj_8 = {};
        wp::range_t adj_9 = {};
        wp::int32 adj_10 = {};
        wp::float32 adj_11 = {};
        wp::float32 adj_12 = {};
        wp::float32 adj_13 = {};
        wp::float32 adj_14 = {};
        wp::float32 adj_15 = {};
        wp::float32 adj_16 = {};
        wp::float32 adj_17 = {};
        wp::float32 adj_18 = {};
        wp::float32 adj_19 = {};
        wp::float32 adj_20 = {};
        wp::float32 adj_21 = {};
        //---------
        // forward
        // def _update_lm_state(                                                                  <L 54>
        // row = wp.tid()                                                                         <L 69>
        var_0 = builtin_tid1d();
        // if accept_flags[row] == 1:                                                             <L 71>
        var_1 = wp::address(var_accept_flags, var_0);
        var_4 = wp::load(var_1);
        var_3 = (var_4 == var_2);
        if (var_3) {
            // for i in range(n_coords):                                                          <L 72>
            var_5 = wp::range(var_n_coords);
            // for i in range(num_residuals):                                                     <L 74>
            var_9 = wp::range(var_num_residuals);
            // costs[row] = costs_proposed[row]                                                   <L 76>
            var_13 = wp::address(var_costs_proposed, var_0);
            var_14 = wp::load(var_13);
            // wp::array_store(var_costs, var_0, var_14);
            // lambda_values[row] = lambda_values[row] / lambda_factor                            <L 77>
            var_15 = wp::address(var_lambda_values, var_0);
            var_17 = wp::load(var_15);
            var_16 = wp::div(var_17, var_lambda_factor);
            // wp::array_store(var_lambda_values, var_0, var_16);
        }
        if (!var_3) {
            // new_lambda = lambda_values[row] * lambda_factor                                    <L 79>
            var_18 = wp::address(var_lambda_values, var_0);
            var_20 = wp::load(var_18);
            var_19 = wp::mul(var_20, var_lambda_factor);
            // lambda_values[row] = wp.clamp(new_lambda, lambda_min, lambda_max)                  <L 80>
            var_21 = wp::clamp(var_19, var_lambda_min, var_lambda_max);
            // wp::array_store(var_lambda_values, var_0, var_21);
        }
        //---------
        // reverse
        if (!var_3) {
            wp::adj_array_store(var_lambda_values, var_0, var_21, adj_lambda_values, adj_0, adj_21);
            wp::adj_clamp(var_19, var_lambda_min, var_lambda_max, adj_19, adj_lambda_min, adj_lambda_max, adj_21);
            // adj: lambda_values[row] = wp.clamp(new_lambda, lambda_min, lambda_max)             <L 80>
            wp::adj_mul(var_20, var_lambda_factor, adj_18, adj_lambda_factor, adj_19);
            wp::adj_address(var_lambda_values, var_0, adj_lambda_values, adj_0, adj_18);
            // adj: new_lambda = lambda_values[row] * lambda_factor                               <L 79>
        }
        if (var_3) {
            wp::adj_array_store(var_lambda_values, var_0, var_16, adj_lambda_values, adj_0, adj_16);
            wp::adj_div(var_17, var_lambda_factor, var_16, adj_15, adj_lambda_factor, adj_16);
            wp::adj_address(var_lambda_values, var_0, adj_lambda_values, adj_0, adj_15);
            // adj: lambda_values[row] = lambda_values[row] / lambda_factor                       <L 77>
            wp::adj_array_store(var_costs, var_0, var_14, adj_costs, adj_0, adj_13);
            wp::adj_address(var_costs_proposed, var_0, adj_costs_proposed, adj_0, adj_13);
            // adj: costs[row] = costs_proposed[row]                                              <L 76>
            var_9 = wp::iter_reverse(var_9);
            start_for_2:;
                if (iter_cmp(var_9) == 0) goto end_for_2;
                var_10 = wp::iter_next(var_9);
            	adj_11 = {};
            	adj_12 = {};
                // residuals_current[row, i] = residuals_proposed[row, i]                         <L 75>
                var_11 = wp::address(var_residuals_proposed, var_0, var_10);
                var_12 = wp::load(var_11);
                // wp::array_store(var_residuals_current, var_0, var_10, var_12);
                wp::adj_array_store(var_residuals_current, var_0, var_10, var_12, adj_residuals_current, adj_0, adj_10, adj_11);
                wp::adj_address(var_residuals_proposed, var_0, var_10, adj_residuals_proposed, adj_0, adj_10, adj_11);
                // adj: residuals_current[row, i] = residuals_proposed[row, i]                    <L 75>
            	goto start_for_2;
            end_for_2:;
            // adj: for i in range(num_residuals):                                                <L 74>
            var_5 = wp::iter_reverse(var_5);
            start_for_0:;
                if (iter_cmp(var_5) == 0) goto end_for_0;
                var_6 = wp::iter_next(var_5);
            	adj_7 = {};
            	adj_8 = {};
                // joint_q_current[row, i] = joint_q_proposed[row, i]                             <L 73>
                var_7 = wp::address(var_joint_q_proposed, var_0, var_6);
                var_8 = wp::load(var_7);
                // wp::array_store(var_joint_q_current, var_0, var_6, var_8);
                wp::adj_array_store(var_joint_q_current, var_0, var_6, var_8, adj_joint_q_current, adj_0, adj_6, adj_7);
                wp::adj_address(var_joint_q_proposed, var_0, var_6, adj_joint_q_proposed, adj_0, adj_6, adj_7);
                // adj: joint_q_current[row, i] = joint_q_proposed[row, i]                        <L 73>
            	goto start_for_0;
            end_for_0:;
            // adj: for i in range(n_coords):                                                     <L 72>
        }
        wp::adj_address(var_accept_flags, var_0, adj_accept_flags, adj_0, adj_1);
        // adj: if accept_flags[row] == 1:                                                        <L 71>
        // adj: row = wp.tid()                                                                    <L 69>
        // adj: def _update_lm_state(                                                             <L 54>
        continue;
    }
}



extern "C" __global__ void _accept_reject_996e522e_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::float32> var_cost_curr,
    wp::array_t<wp::float32> var_cost_prop,
    wp::array_t<wp::float32> var_pred_red,
    wp::float32 var_rho_min,
    wp::array_t<wp::int32> var_accept)
{
    wp::tile_shared_storage_t tile_mem;

    for (size_t _idx = static_cast<size_t>(blockDim.x) * static_cast<size_t>(blockIdx.x) + static_cast<size_t>(threadIdx.x);
         _idx < dim.size;
         _idx += static_cast<size_t>(blockDim.x) * static_cast<size_t>(gridDim.x))
    {
            // reset shared memory allocator
        wp::tile_shared_storage_t::init();

        //---------
        // primal vars
        wp::int32 var_0;
        wp::float32* var_1;
        wp::float32* var_2;
        wp::float32 var_3;
        wp::float32 var_4;
        wp::float32 var_5;
        wp::float32* var_6;
        const wp::float32 var_7 = 1e-08;
        wp::float32 var_8;
        wp::float32 var_9;
        wp::float32 var_10;
        bool var_11;
        const wp::int32 var_12 = 1;
        wp::int32 var_13;
        const wp::int32 var_14 = 0;
        wp::int32 var_15;
        wp::int32 var_16;
        //---------
        // forward
        // def _accept_reject(                                                                    <L 41>
        // row = wp.tid()                                                                         <L 48>
        var_0 = builtin_tid1d();
        // rho = (cost_curr[row] - cost_prop[row]) / (pred_red[row] + 1.0e-8)                     <L 49>
        var_1 = wp::address(var_cost_curr, var_0);
        var_2 = wp::address(var_cost_prop, var_0);
        var_4 = wp::load(var_1);
        var_5 = wp::load(var_2);
        var_3 = wp::sub(var_4, var_5);
        var_6 = wp::address(var_pred_red, var_0);
        var_9 = wp::load(var_6);
        var_8 = wp::add(var_9, var_7);
        var_10 = wp::div(var_3, var_8);
        // accept[row] = wp.int32(1) if rho >= rho_min else wp.int32(0)                           <L 50>
        var_11 = (var_10 >= var_rho_min);
        if (var_11) {
            var_13 = wp::int32(var_12);
        }
        if (!var_11) {
            var_15 = wp::int32(var_14);
        }
        var_16 = wp::where(var_11, var_13, var_15);
        wp::array_store(var_accept, var_0, var_16);
    }
}



extern "C" __global__ void _accept_reject_996e522e_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::float32> var_cost_curr,
    wp::array_t<wp::float32> var_cost_prop,
    wp::array_t<wp::float32> var_pred_red,
    wp::float32 var_rho_min,
    wp::array_t<wp::int32> var_accept,
    wp::array_t<wp::float32> adj_cost_curr,
    wp::array_t<wp::float32> adj_cost_prop,
    wp::array_t<wp::float32> adj_pred_red,
    wp::float32 adj_rho_min,
    wp::array_t<wp::int32> adj_accept)
{
    wp::tile_shared_storage_t tile_mem;

    for (size_t _idx = static_cast<size_t>(blockDim.x) * static_cast<size_t>(blockIdx.x) + static_cast<size_t>(threadIdx.x);
         _idx < dim.size;
         _idx += static_cast<size_t>(blockDim.x) * static_cast<size_t>(gridDim.x))
    {
            // reset shared memory allocator
        wp::tile_shared_storage_t::init();

        //---------
        // primal vars
        wp::int32 var_0;
        wp::float32* var_1;
        wp::float32* var_2;
        wp::float32 var_3;
        wp::float32 var_4;
        wp::float32 var_5;
        wp::float32* var_6;
        const wp::float32 var_7 = 1e-08;
        wp::float32 var_8;
        wp::float32 var_9;
        wp::float32 var_10;
        bool var_11;
        const wp::int32 var_12 = 1;
        wp::int32 var_13;
        const wp::int32 var_14 = 0;
        wp::int32 var_15;
        wp::int32 var_16;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::float32 adj_1 = {};
        wp::float32 adj_2 = {};
        wp::float32 adj_3 = {};
        wp::float32 adj_4 = {};
        wp::float32 adj_5 = {};
        wp::float32 adj_6 = {};
        wp::float32 adj_7 = {};
        wp::float32 adj_8 = {};
        wp::float32 adj_9 = {};
        wp::float32 adj_10 = {};
        bool adj_11 = {};
        wp::int32 adj_12 = {};
        wp::int32 adj_13 = {};
        wp::int32 adj_14 = {};
        wp::int32 adj_15 = {};
        wp::int32 adj_16 = {};
        //---------
        // forward
        // def _accept_reject(                                                                    <L 41>
        // row = wp.tid()                                                                         <L 48>
        var_0 = builtin_tid1d();
        // rho = (cost_curr[row] - cost_prop[row]) / (pred_red[row] + 1.0e-8)                     <L 49>
        var_1 = wp::address(var_cost_curr, var_0);
        var_2 = wp::address(var_cost_prop, var_0);
        var_4 = wp::load(var_1);
        var_5 = wp::load(var_2);
        var_3 = wp::sub(var_4, var_5);
        var_6 = wp::address(var_pred_red, var_0);
        var_9 = wp::load(var_6);
        var_8 = wp::add(var_9, var_7);
        var_10 = wp::div(var_3, var_8);
        // accept[row] = wp.int32(1) if rho >= rho_min else wp.int32(0)                           <L 50>
        var_11 = (var_10 >= var_rho_min);
        if (var_11) {
            var_13 = wp::int32(var_12);
        }
        if (!var_11) {
            var_15 = wp::int32(var_14);
        }
        var_16 = wp::where(var_11, var_13, var_15);
        // wp::array_store(var_accept, var_0, var_16);
        //---------
        // reverse
        wp::adj_array_store(var_accept, var_0, var_16, adj_accept, adj_0, adj_16);
        wp::adj_where(var_11, var_13, var_15, adj_11, adj_13, adj_15, adj_16);
        if (!var_11) {
        }
        if (var_11) {
        }
        // adj: accept[row] = wp.int32(1) if rho >= rho_min else wp.int32(0)                      <L 50>
        wp::adj_div(var_3, var_8, var_10, adj_3, adj_8, adj_10);
        wp::adj_add(var_9, var_7, adj_6, adj_7, adj_8);
        wp::adj_address(var_pred_red, var_0, adj_pred_red, adj_0, adj_6);
        wp::adj_sub(var_4, var_5, adj_1, adj_2, adj_3);
        wp::adj_address(var_cost_prop, var_0, adj_cost_prop, adj_0, adj_2);
        wp::adj_address(var_cost_curr, var_0, adj_cost_curr, adj_0, adj_1);
        // adj: rho = (cost_curr[row] - cost_prop[row]) / (pred_red[row] + 1.0e-8)                <L 49>
        // adj: row = wp.tid()                                                                    <L 48>
        // adj: def _accept_reject(                                                               <L 41>
        continue;
    }
}

