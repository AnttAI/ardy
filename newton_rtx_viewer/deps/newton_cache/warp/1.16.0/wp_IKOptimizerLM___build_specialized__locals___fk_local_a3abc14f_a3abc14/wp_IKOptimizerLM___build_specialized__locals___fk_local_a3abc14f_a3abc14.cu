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


// /home/jony/Downloads/newton/repos/newton/newton/_src/sim/articulation.py:36
static CUDA_CALLABLE void transform_2d_rotational_axes_0(
    wp::vec_t<3, wp::float32> var_axis_0,
    wp::vec_t<3, wp::float32> var_axis_1,
    wp::float32 var_q0,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::mat_t<3, 3, wp::float32> var_1;
    wp::quat_t<wp::float32> var_2;
    const wp::float32 var_3 = 1.0;
    const wp::float32 var_4 = 0.0;
    const wp::float32 var_5 = 0.0;
    wp::vec_t<3, wp::float32> var_6;
    wp::vec_t<3, wp::float32> var_7;
    const wp::float32 var_8 = 0.0;
    const wp::float32 var_9 = 1.0;
    const wp::float32 var_10 = 0.0;
    wp::vec_t<3, wp::float32> var_11;
    wp::vec_t<3, wp::float32> var_12;
    wp::vec_t<3, wp::float32> var_13;
    wp::quat_t<wp::float32> var_14;
    wp::vec_t<3, wp::float32> var_15;
    //---------
    // forward
    // def transform_2d_rotational_axes(                                                      <L 37>
    // q_off = wp.quat_from_matrix(wp.matrix_from_cols(axis_0, axis_1, wp.cross(axis_0, axis_1)))       <L 48>
    var_0 = wp::cross(var_axis_0, var_axis_1);
    var_1 = wp::matrix_from_cols<wp::float32>(var_axis_0, var_axis_1, var_0);
    var_2 = wp::quat_from_matrix(var_1);
    // local_0 = wp.quat_rotate(q_off, wp.vec3(1.0, 0.0, 0.0))                                <L 51>
    var_6 = wp::vec_t<3, wp::float32>(var_3, var_4, var_5);
    var_7 = wp::quat_rotate(var_2, var_6);
    // local_1 = wp.quat_rotate(q_off, wp.vec3(0.0, 1.0, 0.0))                                <L 52>
    var_11 = wp::vec_t<3, wp::float32>(var_8, var_9, var_10);
    var_12 = wp::quat_rotate(var_2, var_11);
    // a0 = local_0                                                                           <L 54>
    var_13 = wp::copy(var_7);
    // q_0 = wp.quat_from_axis_angle(a0, q0)                                                  <L 55>
    var_14 = wp::quat_from_axis_angle(var_13, var_q0);
    // a1 = wp.quat_rotate(q_0, local_1)                                                      <L 56>
    var_15 = wp::quat_rotate(var_14, var_12);
    // return a0, a1                                                                          <L 58>
    ret_0 = var_13;
    ret_1 = var_15;
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/sim/articulation.py:61
static CUDA_CALLABLE void compute_2d_rotational_dofs_0(
    wp::vec_t<3, wp::float32> var_axis_0,
    wp::vec_t<3, wp::float32> var_axis_1,
    wp::float32 var_q0,
    wp::float32 var_q1,
    wp::float32 var_qd0,
    wp::float32 var_qd1,
    wp::quat_t<wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::quat_t<wp::float32> var_2;
    wp::quat_t<wp::float32> var_3;
    wp::quat_t<wp::float32> var_4;
    wp::vec_t<3, wp::float32> var_5;
    wp::vec_t<3, wp::float32> var_6;
    wp::vec_t<3, wp::float32> var_7;
    //---------
    // forward
    // def compute_2d_rotational_dofs(                                                        <L 62>
    // a0, a1 = transform_2d_rotational_axes(axis_0, axis_1, q0)                              <L 73>
    transform_2d_rotational_axes_0(var_axis_0, var_axis_1, var_q0, var_0, var_1);
    // q_0 = wp.quat_from_axis_angle(a0, q0)                                                  <L 75>
    var_2 = wp::quat_from_axis_angle(var_0, var_q0);
    // q_1 = wp.quat_from_axis_angle(a1, q1)                                                  <L 76>
    var_3 = wp::quat_from_axis_angle(var_1, var_q1);
    // rot = q_1 * q_0                                                                        <L 78>
    var_4 = wp::mul(var_3, var_2);
    // vel = a0 * qd0 + a1 * qd1                                                              <L 80>
    var_5 = wp::mul(var_0, var_qd0);
    var_6 = wp::mul(var_1, var_qd1);
    var_7 = wp::add(var_5, var_6);
    // return rot, vel                                                                        <L 82>
    ret_0 = var_4;
    ret_1 = var_7;
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/sim/articulation.py:127
static CUDA_CALLABLE void transform_3d_rotational_axes_0(
    wp::vec_t<3, wp::float32> var_axis_0,
    wp::vec_t<3, wp::float32> var_axis_1,
    wp::vec_t<3, wp::float32> var_axis_2,
    wp::float32 var_q0,
    wp::float32 var_q1,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & ret_2)
{
    //---------
    // primal vars
    wp::quat_t<wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::quat_t<wp::float32> var_2;
    wp::quat_t<wp::float32> var_3;
    wp::vec_t<3, wp::float32> var_4;
    //---------
    // forward
    // def transform_3d_rotational_axes(                                                      <L 128>
    // q_0 = wp.quat_from_axis_angle(axis_0, q0)                                              <L 141>
    var_0 = wp::quat_from_axis_angle(var_axis_0, var_q0);
    // axis_1_w = wp.quat_rotate(q_0, axis_1)                                                 <L 143>
    var_1 = wp::quat_rotate(var_0, var_axis_1);
    // q_1 = wp.quat_from_axis_angle(axis_1_w, q1)                                            <L 144>
    var_2 = wp::quat_from_axis_angle(var_1, var_q1);
    // axis_2_w = wp.quat_rotate(q_1 * q_0, axis_2)                                           <L 146>
    var_3 = wp::mul(var_2, var_0);
    var_4 = wp::quat_rotate(var_3, var_axis_2);
    // return axis_0, axis_1_w, axis_2_w                                                      <L 148>
    ret_0 = var_axis_0;
    ret_1 = var_1;
    ret_2 = var_4;
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/sim/articulation.py:151
static CUDA_CALLABLE void compute_3d_rotational_dofs_0(
    wp::vec_t<3, wp::float32> var_axis_0,
    wp::vec_t<3, wp::float32> var_axis_1,
    wp::vec_t<3, wp::float32> var_axis_2,
    wp::float32 var_q0,
    wp::float32 var_q1,
    wp::float32 var_q2,
    wp::float32 var_qd0,
    wp::float32 var_qd1,
    wp::float32 var_qd2,
    wp::quat_t<wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::quat_t<wp::float32> var_3;
    wp::quat_t<wp::float32> var_4;
    wp::quat_t<wp::float32> var_5;
    wp::quat_t<wp::float32> var_6;
    wp::quat_t<wp::float32> var_7;
    wp::vec_t<3, wp::float32> var_8;
    wp::vec_t<3, wp::float32> var_9;
    wp::vec_t<3, wp::float32> var_10;
    wp::vec_t<3, wp::float32> var_11;
    wp::vec_t<3, wp::float32> var_12;
    //---------
    // forward
    // def compute_3d_rotational_dofs(                                                        <L 152>
    // axis_0_w, axis_1_w, axis_2_w = transform_3d_rotational_axes(axis_0, axis_1, axis_2, q0, q1)       <L 169>
    transform_3d_rotational_axes_0(var_axis_0, var_axis_1, var_axis_2, var_q0, var_q1, var_0, var_1, var_2);
    // q_0 = wp.quat_from_axis_angle(axis_0_w, q0)                                            <L 171>
    var_3 = wp::quat_from_axis_angle(var_0, var_q0);
    // q_1 = wp.quat_from_axis_angle(axis_1_w, q1)                                            <L 172>
    var_4 = wp::quat_from_axis_angle(var_1, var_q1);
    // q_2 = wp.quat_from_axis_angle(axis_2_w, q2)                                            <L 173>
    var_5 = wp::quat_from_axis_angle(var_2, var_q2);
    // rot = q_2 * q_1 * q_0                                                                  <L 175>
    var_6 = wp::mul(var_5, var_4);
    var_7 = wp::mul(var_6, var_3);
    // vel = axis_0_w * qd0 + axis_1_w * qd1 + axis_2_w * qd2                                 <L 176>
    var_8 = wp::mul(var_0, var_qd0);
    var_9 = wp::mul(var_1, var_qd1);
    var_10 = wp::add(var_8, var_9);
    var_11 = wp::mul(var_2, var_qd2);
    var_12 = wp::add(var_10, var_11);
    // return rot, vel                                                                        <L 178>
    ret_0 = var_7;
    ret_1 = var_12;
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/solvers/featherstone/kernels.py:142
static CUDA_CALLABLE wp::transform_t<wp::float32> jcalc_transform_0(
    wp::int32 var_type,
    wp::array_t<wp::vec_t<3, wp::float32>> var_joint_axis,
    wp::int32 var_axis_start,
    wp::int32 var_lin_axis_count,
    wp::int32 var_ang_axis_count,
    wp::array_t<wp::float32> var_joint_q,
    wp::int32 var_q_start)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    bool var_1;
    wp::float32* var_2;
    wp::float32 var_3;
    wp::float32 var_4;
    wp::vec_t<3, wp::float32>* var_5;
    wp::vec_t<3, wp::float32> var_6;
    wp::vec_t<3, wp::float32> var_7;
    wp::vec_t<3, wp::float32> var_8;
    wp::quat_t<wp::float32> var_9;
    wp::transform_t<wp::float32> var_10;
    const wp::int32 var_11 = 1;
    bool var_12;
    wp::float32* var_13;
    wp::float32 var_14;
    wp::float32 var_15;
    wp::vec_t<3, wp::float32>* var_16;
    wp::vec_t<3, wp::float32> var_17;
    wp::vec_t<3, wp::float32> var_18;
    wp::vec_t<3, wp::float32> var_19;
    wp::quat_t<wp::float32> var_20;
    wp::transform_t<wp::float32> var_21;
    wp::float32 var_22;
    wp::vec_t<3, wp::float32> var_23;
    wp::transform_t<wp::float32> var_24;
    const wp::int32 var_25 = 2;
    bool var_26;
    const wp::int32 var_27 = 0;
    wp::int32 var_28;
    wp::float32* var_29;
    wp::float32 var_30;
    wp::float32 var_31;
    const wp::int32 var_32 = 1;
    wp::int32 var_33;
    wp::float32* var_34;
    wp::float32 var_35;
    wp::float32 var_36;
    const wp::int32 var_37 = 2;
    wp::int32 var_38;
    wp::float32* var_39;
    wp::float32 var_40;
    wp::float32 var_41;
    const wp::int32 var_42 = 3;
    wp::int32 var_43;
    wp::float32* var_44;
    wp::float32 var_45;
    wp::float32 var_46;
    wp::vec_t<3, wp::float32> var_47;
    wp::quat_t<wp::float32> var_48;
    wp::transform_t<wp::float32> var_49;
    wp::transform_t<wp::float32> var_50;
    const wp::int32 var_51 = 3;
    bool var_52;
    wp::transform_t<wp::float32> var_53;
    wp::transform_t<wp::float32> var_54;
    bool var_55;
    const wp::int32 var_56 = 4;
    bool var_57;
    const wp::int32 var_58 = 5;
    bool var_59;
    const wp::int32 var_60 = 0;
    wp::int32 var_61;
    wp::float32* var_62;
    wp::float32 var_63;
    wp::float32 var_64;
    const wp::int32 var_65 = 1;
    wp::int32 var_66;
    wp::float32* var_67;
    wp::float32 var_68;
    wp::float32 var_69;
    const wp::int32 var_70 = 2;
    wp::int32 var_71;
    wp::float32* var_72;
    wp::float32 var_73;
    wp::float32 var_74;
    const wp::int32 var_75 = 3;
    wp::int32 var_76;
    wp::float32* var_77;
    wp::float32 var_78;
    wp::float32 var_79;
    const wp::int32 var_80 = 4;
    wp::int32 var_81;
    wp::float32* var_82;
    wp::float32 var_83;
    wp::float32 var_84;
    const wp::int32 var_85 = 5;
    wp::int32 var_86;
    wp::float32* var_87;
    wp::float32 var_88;
    wp::float32 var_89;
    const wp::int32 var_90 = 6;
    wp::int32 var_91;
    wp::float32* var_92;
    wp::float32 var_93;
    wp::float32 var_94;
    wp::vec_t<3, wp::float32> var_95;
    wp::quat_t<wp::float32> var_96;
    wp::transform_t<wp::float32> var_97;
    wp::transform_t<wp::float32> var_98;
    wp::float32 var_99;
    wp::float32 var_100;
    wp::float32 var_101;
    wp::float32 var_102;
    const wp::int32 var_103 = 6;
    bool var_104;
    const wp::float32 var_105 = 0.0;
    wp::vec_t<3, wp::float32> var_106;
    wp::quat_t<wp::float32> var_107;
    const wp::int32 var_108 = 0;
    bool var_109;
    const wp::int32 var_110 = 0;
    wp::int32 var_111;
    wp::vec_t<3, wp::float32>* var_112;
    wp::vec_t<3, wp::float32> var_113;
    wp::vec_t<3, wp::float32> var_114;
    const wp::int32 var_115 = 0;
    wp::int32 var_116;
    wp::float32* var_117;
    wp::vec_t<3, wp::float32> var_118;
    wp::float32 var_119;
    wp::vec_t<3, wp::float32> var_120;
    wp::vec_t<3, wp::float32> var_121;
    wp::vec_t<3, wp::float32> var_122;
    const wp::int32 var_123 = 1;
    bool var_124;
    const wp::int32 var_125 = 1;
    wp::int32 var_126;
    wp::vec_t<3, wp::float32>* var_127;
    wp::vec_t<3, wp::float32> var_128;
    wp::vec_t<3, wp::float32> var_129;
    const wp::int32 var_130 = 1;
    wp::int32 var_131;
    wp::float32* var_132;
    wp::vec_t<3, wp::float32> var_133;
    wp::float32 var_134;
    wp::vec_t<3, wp::float32> var_135;
    wp::vec_t<3, wp::float32> var_136;
    wp::vec_t<3, wp::float32> var_137;
    const wp::int32 var_138 = 2;
    bool var_139;
    const wp::int32 var_140 = 2;
    wp::int32 var_141;
    wp::vec_t<3, wp::float32>* var_142;
    wp::vec_t<3, wp::float32> var_143;
    wp::vec_t<3, wp::float32> var_144;
    const wp::int32 var_145 = 2;
    wp::int32 var_146;
    wp::float32* var_147;
    wp::vec_t<3, wp::float32> var_148;
    wp::float32 var_149;
    wp::vec_t<3, wp::float32> var_150;
    wp::vec_t<3, wp::float32> var_151;
    wp::vec_t<3, wp::float32> var_152;
    wp::int32 var_153;
    wp::int32 var_154;
    const wp::int32 var_155 = 1;
    bool var_156;
    wp::vec_t<3, wp::float32>* var_157;
    wp::vec_t<3, wp::float32> var_158;
    wp::vec_t<3, wp::float32> var_159;
    wp::float32* var_160;
    wp::quat_t<wp::float32> var_161;
    wp::float32 var_162;
    wp::vec_t<3, wp::float32> var_163;
    wp::quat_t<wp::float32> var_164;
    const wp::int32 var_165 = 2;
    bool var_166;
    const wp::int32 var_167 = 0;
    wp::int32 var_168;
    wp::vec_t<3, wp::float32>* var_169;
    const wp::int32 var_170 = 1;
    wp::int32 var_171;
    wp::vec_t<3, wp::float32>* var_172;
    const wp::int32 var_173 = 0;
    wp::int32 var_174;
    wp::float32* var_175;
    const wp::int32 var_176 = 1;
    wp::int32 var_177;
    wp::float32* var_178;
    const wp::float32 var_179 = 0.0;
    const wp::float32 var_180 = 0.0;
    wp::quat_t<wp::float32> var_181;
    wp::vec_t<3, wp::float32> var_182;
    wp::vec_t<3, wp::float32> var_183;
    wp::vec_t<3, wp::float32> var_184;
    wp::float32 var_185;
    wp::float32 var_186;
    wp::quat_t<wp::float32> var_187;
    const wp::int32 var_188 = 3;
    bool var_189;
    const wp::int32 var_190 = 0;
    wp::int32 var_191;
    wp::vec_t<3, wp::float32>* var_192;
    const wp::int32 var_193 = 1;
    wp::int32 var_194;
    wp::vec_t<3, wp::float32>* var_195;
    const wp::int32 var_196 = 2;
    wp::int32 var_197;
    wp::vec_t<3, wp::float32>* var_198;
    const wp::int32 var_199 = 0;
    wp::int32 var_200;
    wp::float32* var_201;
    const wp::int32 var_202 = 1;
    wp::int32 var_203;
    wp::float32* var_204;
    const wp::int32 var_205 = 2;
    wp::int32 var_206;
    wp::float32* var_207;
    const wp::float32 var_208 = 0.0;
    const wp::float32 var_209 = 0.0;
    const wp::float32 var_210 = 0.0;
    wp::quat_t<wp::float32> var_211;
    wp::vec_t<3, wp::float32> var_212;
    wp::vec_t<3, wp::float32> var_213;
    wp::vec_t<3, wp::float32> var_214;
    wp::vec_t<3, wp::float32> var_215;
    wp::float32 var_216;
    wp::float32 var_217;
    wp::float32 var_218;
    wp::quat_t<wp::float32> var_219;
    wp::vec_t<3, wp::float32> var_220;
    wp::transform_t<wp::float32> var_221;
    wp::vec_t<3, wp::float32> var_222;
    wp::transform_t<wp::float32> var_223;
    wp::transform_t<wp::float32> var_224;
    //---------
    // forward
    // def jcalc_transform(                                                                   <L 143>
    // if type == JointType.PRISMATIC:                                                        <L 152>
    var_1 = (var_type == var_0);
    if (var_1) {
        // q = joint_q[q_start]                                                               <L 153>
        var_2 = wp::address(var_joint_q, var_q_start);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // axis = joint_axis[axis_start]                                                      <L 154>
        var_5 = wp::address(var_joint_axis, var_axis_start);
        var_7 = wp::load(var_5);
        var_6 = wp::copy(var_7);
        // X_jc = wp.transform(axis * q, wp.quat_identity())                                  <L 155>
        var_8 = wp::mul(var_6, var_3);
        var_9 = wp::quat_identity<wp::float32>();
        var_10 = wp::transform_t<wp::float32>(var_8, var_9);
        // return X_jc                                                                        <L 156>
        return var_10;
    }
    // if type == JointType.REVOLUTE:                                                         <L 158>
    var_12 = (var_type == var_11);
    if (var_12) {
        // q = joint_q[q_start]                                                               <L 159>
        var_13 = wp::address(var_joint_q, var_q_start);
        var_15 = wp::load(var_13);
        var_14 = wp::copy(var_15);
        // axis = joint_axis[axis_start]                                                      <L 160>
        var_16 = wp::address(var_joint_axis, var_axis_start);
        var_18 = wp::load(var_16);
        var_17 = wp::copy(var_18);
        // X_jc = wp.transform(wp.vec3(), wp.quat_from_axis_angle(axis, q))                   <L 161>
        var_19 = wp::vec_t<3, wp::float32>();
        var_20 = wp::quat_from_axis_angle(var_17, var_14);
        var_21 = wp::transform_t<wp::float32>(var_19, var_20);
        // return X_jc                                                                        <L 162>
        return var_21;
    }
    var_22 = wp::where(var_12, var_14, var_3);
    var_23 = wp::where(var_12, var_17, var_6);
    var_24 = wp::where(var_12, var_21, var_10);
    // if type == JointType.BALL:                                                             <L 164>
    var_26 = (var_type == var_25);
    if (var_26) {
        // qx = joint_q[q_start + 0]                                                          <L 165>
        var_28 = wp::add(var_q_start, var_27);
        var_29 = wp::address(var_joint_q, var_28);
        var_31 = wp::load(var_29);
        var_30 = wp::copy(var_31);
        // qy = joint_q[q_start + 1]                                                          <L 166>
        var_33 = wp::add(var_q_start, var_32);
        var_34 = wp::address(var_joint_q, var_33);
        var_36 = wp::load(var_34);
        var_35 = wp::copy(var_36);
        // qz = joint_q[q_start + 2]                                                          <L 167>
        var_38 = wp::add(var_q_start, var_37);
        var_39 = wp::address(var_joint_q, var_38);
        var_41 = wp::load(var_39);
        var_40 = wp::copy(var_41);
        // qw = joint_q[q_start + 3]                                                          <L 168>
        var_43 = wp::add(var_q_start, var_42);
        var_44 = wp::address(var_joint_q, var_43);
        var_46 = wp::load(var_44);
        var_45 = wp::copy(var_46);
        // X_jc = wp.transform(wp.vec3(), wp.quat(qx, qy, qz, qw))                            <L 170>
        var_47 = wp::vec_t<3, wp::float32>();
        var_48 = wp::quat_t<wp::float32>(var_30, var_35, var_40, var_45);
        var_49 = wp::transform_t<wp::float32>(var_47, var_48);
        // return X_jc                                                                        <L 171>
        return var_49;
    }
    var_50 = wp::where(var_26, var_49, var_24);
    // if type == JointType.FIXED:                                                            <L 173>
    var_52 = (var_type == var_51);
    if (var_52) {
        // X_jc = wp.transform_identity()                                                     <L 174>
        var_53 = wp::transform_identity<wp::float32>();
        // return X_jc                                                                        <L 175>
        return var_53;
    }
    var_54 = wp::where(var_52, var_53, var_50);
    // if type == JointType.FREE or type == JointType.DISTANCE:                               <L 177>
    var_57 = (var_type == var_56);
    var_55 = var_57;
    if (!var_55) {
        var_59 = (var_type == var_58);
        var_55 = var_55 || var_59;
    }
    if (var_55) {
        // px = joint_q[q_start + 0]                                                          <L 178>
        var_61 = wp::add(var_q_start, var_60);
        var_62 = wp::address(var_joint_q, var_61);
        var_64 = wp::load(var_62);
        var_63 = wp::copy(var_64);
        // py = joint_q[q_start + 1]                                                          <L 179>
        var_66 = wp::add(var_q_start, var_65);
        var_67 = wp::address(var_joint_q, var_66);
        var_69 = wp::load(var_67);
        var_68 = wp::copy(var_69);
        // pz = joint_q[q_start + 2]                                                          <L 180>
        var_71 = wp::add(var_q_start, var_70);
        var_72 = wp::address(var_joint_q, var_71);
        var_74 = wp::load(var_72);
        var_73 = wp::copy(var_74);
        // qx = joint_q[q_start + 3]                                                          <L 182>
        var_76 = wp::add(var_q_start, var_75);
        var_77 = wp::address(var_joint_q, var_76);
        var_79 = wp::load(var_77);
        var_78 = wp::copy(var_79);
        // qy = joint_q[q_start + 4]                                                          <L 183>
        var_81 = wp::add(var_q_start, var_80);
        var_82 = wp::address(var_joint_q, var_81);
        var_84 = wp::load(var_82);
        var_83 = wp::copy(var_84);
        // qz = joint_q[q_start + 5]                                                          <L 184>
        var_86 = wp::add(var_q_start, var_85);
        var_87 = wp::address(var_joint_q, var_86);
        var_89 = wp::load(var_87);
        var_88 = wp::copy(var_89);
        // qw = joint_q[q_start + 6]                                                          <L 185>
        var_91 = wp::add(var_q_start, var_90);
        var_92 = wp::address(var_joint_q, var_91);
        var_94 = wp::load(var_92);
        var_93 = wp::copy(var_94);
        // X_jc = wp.transform(wp.vec3(px, py, pz), wp.quat(qx, qy, qz, qw))                  <L 187>
        var_95 = wp::vec_t<3, wp::float32>(var_63, var_68, var_73);
        var_96 = wp::quat_t<wp::float32>(var_78, var_83, var_88, var_93);
        var_97 = wp::transform_t<wp::float32>(var_95, var_96);
        // return X_jc                                                                        <L 188>
        return var_97;
    }
    var_98 = wp::where(var_55, var_97, var_54);
    var_99 = wp::where(var_55, var_78, var_30);
    var_100 = wp::where(var_55, var_83, var_35);
    var_101 = wp::where(var_55, var_88, var_40);
    var_102 = wp::where(var_55, var_93, var_45);
    // if type == JointType.D6:                                                               <L 190>
    var_104 = (var_type == var_103);
    if (var_104) {
        // pos = wp.vec3(0.0)                                                                 <L 191>
        var_106 = wp::vec_t<3, wp::float32>(var_105);
        // rot = wp.quat_identity()                                                           <L 192>
        var_107 = wp::quat_identity<wp::float32>();
        // if lin_axis_count > 0:                                                             <L 197>
        var_109 = (var_lin_axis_count > var_108);
        if (var_109) {
            // axis = joint_axis[axis_start + 0]                                              <L 198>
            var_111 = wp::add(var_axis_start, var_110);
            var_112 = wp::address(var_joint_axis, var_111);
            var_114 = wp::load(var_112);
            var_113 = wp::copy(var_114);
            // pos += axis * joint_q[q_start + 0]                                             <L 199>
            var_116 = wp::add(var_q_start, var_115);
            var_117 = wp::address(var_joint_q, var_116);
            var_119 = wp::load(var_117);
            var_118 = wp::mul(var_113, var_119);
            var_120 = wp::add(var_106, var_118);
        }
        var_121 = wp::where(var_109, var_113, var_23);
        var_122 = wp::where(var_109, var_120, var_106);
        // if lin_axis_count > 1:                                                             <L 200>
        var_124 = (var_lin_axis_count > var_123);
        if (var_124) {
            // axis = joint_axis[axis_start + 1]                                              <L 201>
            var_126 = wp::add(var_axis_start, var_125);
            var_127 = wp::address(var_joint_axis, var_126);
            var_129 = wp::load(var_127);
            var_128 = wp::copy(var_129);
            // pos += axis * joint_q[q_start + 1]                                             <L 202>
            var_131 = wp::add(var_q_start, var_130);
            var_132 = wp::address(var_joint_q, var_131);
            var_134 = wp::load(var_132);
            var_133 = wp::mul(var_128, var_134);
            var_135 = wp::add(var_122, var_133);
        }
        var_136 = wp::where(var_124, var_128, var_121);
        var_137 = wp::where(var_124, var_135, var_122);
        // if lin_axis_count > 2:                                                             <L 203>
        var_139 = (var_lin_axis_count > var_138);
        if (var_139) {
            // axis = joint_axis[axis_start + 2]                                              <L 204>
            var_141 = wp::add(var_axis_start, var_140);
            var_142 = wp::address(var_joint_axis, var_141);
            var_144 = wp::load(var_142);
            var_143 = wp::copy(var_144);
            // pos += axis * joint_q[q_start + 2]                                             <L 205>
            var_146 = wp::add(var_q_start, var_145);
            var_147 = wp::address(var_joint_q, var_146);
            var_149 = wp::load(var_147);
            var_148 = wp::mul(var_143, var_149);
            var_150 = wp::add(var_137, var_148);
        }
        var_151 = wp::where(var_139, var_143, var_136);
        var_152 = wp::where(var_139, var_150, var_137);
        // ia = axis_start + lin_axis_count                                                   <L 207>
        var_153 = wp::add(var_axis_start, var_lin_axis_count);
        // iq = q_start + lin_axis_count                                                      <L 208>
        var_154 = wp::add(var_q_start, var_lin_axis_count);
        // if ang_axis_count == 1:                                                            <L 209>
        var_156 = (var_ang_axis_count == var_155);
        if (var_156) {
            // axis = joint_axis[ia]                                                          <L 210>
            var_157 = wp::address(var_joint_axis, var_153);
            var_159 = wp::load(var_157);
            var_158 = wp::copy(var_159);
            // rot = wp.quat_from_axis_angle(axis, joint_q[iq])                               <L 211>
            var_160 = wp::address(var_joint_q, var_154);
            var_162 = wp::load(var_160);
            var_161 = wp::quat_from_axis_angle(var_158, var_162);
        }
        var_163 = wp::where(var_156, var_158, var_151);
        var_164 = wp::where(var_156, var_161, var_107);
        // if ang_axis_count == 2:                                                            <L 212>
        var_166 = (var_ang_axis_count == var_165);
        if (var_166) {
            // rot, _ = compute_2d_rotational_dofs(                                           <L 213>
            // joint_axis[ia + 0],                                                            <L 214>
            var_168 = wp::add(var_153, var_167);
            var_169 = wp::address(var_joint_axis, var_168);
            // joint_axis[ia + 1],                                                            <L 215>
            var_171 = wp::add(var_153, var_170);
            var_172 = wp::address(var_joint_axis, var_171);
            // joint_q[iq + 0],                                                               <L 216>
            var_174 = wp::add(var_154, var_173);
            var_175 = wp::address(var_joint_q, var_174);
            // joint_q[iq + 1],                                                               <L 217>
            var_177 = wp::add(var_154, var_176);
            var_178 = wp::address(var_joint_q, var_177);
            // 0.0,                                                                           <L 218>
            // 0.0,                                                                           <L 219>
            var_183 = wp::load(var_169);
            var_184 = wp::load(var_172);
            var_185 = wp::load(var_175);
            var_186 = wp::load(var_178);
            compute_2d_rotational_dofs_0(var_183, var_184, var_185, var_186, var_179, var_180, var_181, var_182);
        }
        var_187 = wp::where(var_166, var_181, var_164);
        // if ang_axis_count == 3:                                                            <L 221>
        var_189 = (var_ang_axis_count == var_188);
        if (var_189) {
            // rot, _ = compute_3d_rotational_dofs(                                           <L 222>
            // joint_axis[ia + 0],                                                            <L 223>
            var_191 = wp::add(var_153, var_190);
            var_192 = wp::address(var_joint_axis, var_191);
            // joint_axis[ia + 1],                                                            <L 224>
            var_194 = wp::add(var_153, var_193);
            var_195 = wp::address(var_joint_axis, var_194);
            // joint_axis[ia + 2],                                                            <L 225>
            var_197 = wp::add(var_153, var_196);
            var_198 = wp::address(var_joint_axis, var_197);
            // joint_q[iq + 0],                                                               <L 226>
            var_200 = wp::add(var_154, var_199);
            var_201 = wp::address(var_joint_q, var_200);
            // joint_q[iq + 1],                                                               <L 227>
            var_203 = wp::add(var_154, var_202);
            var_204 = wp::address(var_joint_q, var_203);
            // joint_q[iq + 2],                                                               <L 228>
            var_206 = wp::add(var_154, var_205);
            var_207 = wp::address(var_joint_q, var_206);
            // 0.0,                                                                           <L 229>
            // 0.0,                                                                           <L 230>
            // 0.0,                                                                           <L 231>
            var_213 = wp::load(var_192);
            var_214 = wp::load(var_195);
            var_215 = wp::load(var_198);
            var_216 = wp::load(var_201);
            var_217 = wp::load(var_204);
            var_218 = wp::load(var_207);
            compute_3d_rotational_dofs_0(var_213, var_214, var_215, var_216, var_217, var_218, var_208, var_209, var_210, var_211, var_212);
        }
        var_219 = wp::where(var_189, var_211, var_187);
        var_220 = wp::where(var_189, var_212, var_182);
        // X_jc = wp.transform(pos, rot)                                                      <L 234>
        var_221 = wp::transform_t<wp::float32>(var_152, var_219);
        // return X_jc                                                                        <L 235>
        return var_221;
    }
    var_222 = wp::where(var_104, var_163, var_23);
    var_223 = wp::where(var_104, var_221, var_98);
    // return wp.transform_identity()                                                         <L 238>
    var_224 = wp::transform_identity<wp::float32>();
    return var_224;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/sim/articulation.py:36
static CUDA_CALLABLE void adj_transform_2d_rotational_axes_0(
    wp::vec_t<3, wp::float32> var_axis_0,
    wp::vec_t<3, wp::float32> var_axis_1,
    wp::float32 var_q0,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & adj_axis_0,
    wp::vec_t<3, wp::float32> & adj_axis_1,
    wp::float32 & adj_q0,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::mat_t<3, 3, wp::float32> var_1;
    wp::quat_t<wp::float32> var_2;
    const wp::float32 var_3 = 1.0;
    const wp::float32 var_4 = 0.0;
    const wp::float32 var_5 = 0.0;
    wp::vec_t<3, wp::float32> var_6;
    wp::vec_t<3, wp::float32> var_7;
    const wp::float32 var_8 = 0.0;
    const wp::float32 var_9 = 1.0;
    const wp::float32 var_10 = 0.0;
    wp::vec_t<3, wp::float32> var_11;
    wp::vec_t<3, wp::float32> var_12;
    wp::vec_t<3, wp::float32> var_13;
    wp::quat_t<wp::float32> var_14;
    wp::vec_t<3, wp::float32> var_15;
    //---------
    // dual vars
    wp::vec_t<3, wp::float32> adj_0 = {};
    wp::mat_t<3, 3, wp::float32> adj_1 = {};
    wp::quat_t<wp::float32> adj_2 = {};
    wp::float32 adj_3 = {};
    wp::float32 adj_4 = {};
    wp::float32 adj_5 = {};
    wp::vec_t<3, wp::float32> adj_6 = {};
    wp::vec_t<3, wp::float32> adj_7 = {};
    wp::float32 adj_8 = {};
    wp::float32 adj_9 = {};
    wp::float32 adj_10 = {};
    wp::vec_t<3, wp::float32> adj_11 = {};
    wp::vec_t<3, wp::float32> adj_12 = {};
    wp::vec_t<3, wp::float32> adj_13 = {};
    wp::quat_t<wp::float32> adj_14 = {};
    wp::vec_t<3, wp::float32> adj_15 = {};
    //---------
    // forward
    // def transform_2d_rotational_axes(                                                      <L 37>
    // q_off = wp.quat_from_matrix(wp.matrix_from_cols(axis_0, axis_1, wp.cross(axis_0, axis_1)))       <L 48>
    var_0 = wp::cross(var_axis_0, var_axis_1);
    var_1 = wp::matrix_from_cols<wp::float32>(var_axis_0, var_axis_1, var_0);
    var_2 = wp::quat_from_matrix(var_1);
    // local_0 = wp.quat_rotate(q_off, wp.vec3(1.0, 0.0, 0.0))                                <L 51>
    var_6 = wp::vec_t<3, wp::float32>(var_3, var_4, var_5);
    var_7 = wp::quat_rotate(var_2, var_6);
    // local_1 = wp.quat_rotate(q_off, wp.vec3(0.0, 1.0, 0.0))                                <L 52>
    var_11 = wp::vec_t<3, wp::float32>(var_8, var_9, var_10);
    var_12 = wp::quat_rotate(var_2, var_11);
    // a0 = local_0                                                                           <L 54>
    var_13 = wp::copy(var_7);
    // q_0 = wp.quat_from_axis_angle(a0, q0)                                                  <L 55>
    var_14 = wp::quat_from_axis_angle(var_13, var_q0);
    // a1 = wp.quat_rotate(q_0, local_1)                                                      <L 56>
    var_15 = wp::quat_rotate(var_14, var_12);
    // return a0, a1                                                                          <L 58>
    ret_0 = var_13;
    ret_1 = var_15;
    goto label0;
    //---------
    // reverse
    label0:;
    adj_15 += adj_ret_1;
    adj_13 += adj_ret_0;
    // adj: return a0, a1                                                                     <L 58>
    wp::adj_quat_rotate(var_14, var_12, adj_14, adj_12, adj_15);
    // adj: a1 = wp.quat_rotate(q_0, local_1)                                                 <L 56>
    wp::adj_quat_from_axis_angle(var_13, var_q0, adj_13, adj_q0, adj_14);
    // adj: q_0 = wp.quat_from_axis_angle(a0, q0)                                             <L 55>
    wp::adj_copy(var_7, adj_7, adj_13);
    // adj: a0 = local_0                                                                      <L 54>
    wp::adj_quat_rotate(var_2, var_11, adj_2, adj_11, adj_12);
    wp::adj_vec_t(var_8, var_9, var_10, adj_8, adj_9, adj_10, adj_11);
    // adj: local_1 = wp.quat_rotate(q_off, wp.vec3(0.0, 1.0, 0.0))                           <L 52>
    wp::adj_quat_rotate(var_2, var_6, adj_2, adj_6, adj_7);
    wp::adj_vec_t(var_3, var_4, var_5, adj_3, adj_4, adj_5, adj_6);
    // adj: local_0 = wp.quat_rotate(q_off, wp.vec3(1.0, 0.0, 0.0))                           <L 51>
    wp::adj_quat_from_matrix(var_1, adj_1, adj_2);
    wp::adj_matrix_from_cols(var_axis_0, var_axis_1, var_0, adj_axis_0, adj_axis_1, adj_0, adj_1);
    wp::adj_cross(var_axis_0, var_axis_1, adj_axis_0, adj_axis_1, adj_0);
    // adj: q_off = wp.quat_from_matrix(wp.matrix_from_cols(axis_0, axis_1, wp.cross(axis_0, axis_1)))  <L 48>
    // adj: def transform_2d_rotational_axes(                                                 <L 37>
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/sim/articulation.py:61
static CUDA_CALLABLE void adj_compute_2d_rotational_dofs_0(
    wp::vec_t<3, wp::float32> var_axis_0,
    wp::vec_t<3, wp::float32> var_axis_1,
    wp::float32 var_q0,
    wp::float32 var_q1,
    wp::float32 var_qd0,
    wp::float32 var_qd1,
    wp::quat_t<wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & adj_axis_0,
    wp::vec_t<3, wp::float32> & adj_axis_1,
    wp::float32 & adj_q0,
    wp::float32 & adj_q1,
    wp::float32 & adj_qd0,
    wp::float32 & adj_qd1,
    wp::quat_t<wp::float32> & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::quat_t<wp::float32> var_2;
    wp::quat_t<wp::float32> var_3;
    wp::quat_t<wp::float32> var_4;
    wp::vec_t<3, wp::float32> var_5;
    wp::vec_t<3, wp::float32> var_6;
    wp::vec_t<3, wp::float32> var_7;
    //---------
    // dual vars
    wp::vec_t<3, wp::float32> adj_0 = {};
    wp::vec_t<3, wp::float32> adj_1 = {};
    wp::quat_t<wp::float32> adj_2 = {};
    wp::quat_t<wp::float32> adj_3 = {};
    wp::quat_t<wp::float32> adj_4 = {};
    wp::vec_t<3, wp::float32> adj_5 = {};
    wp::vec_t<3, wp::float32> adj_6 = {};
    wp::vec_t<3, wp::float32> adj_7 = {};
    //---------
    // forward
    // def compute_2d_rotational_dofs(                                                        <L 62>
    // a0, a1 = transform_2d_rotational_axes(axis_0, axis_1, q0)                              <L 73>
    transform_2d_rotational_axes_0(var_axis_0, var_axis_1, var_q0, var_0, var_1);
    // q_0 = wp.quat_from_axis_angle(a0, q0)                                                  <L 75>
    var_2 = wp::quat_from_axis_angle(var_0, var_q0);
    // q_1 = wp.quat_from_axis_angle(a1, q1)                                                  <L 76>
    var_3 = wp::quat_from_axis_angle(var_1, var_q1);
    // rot = q_1 * q_0                                                                        <L 78>
    var_4 = wp::mul(var_3, var_2);
    // vel = a0 * qd0 + a1 * qd1                                                              <L 80>
    var_5 = wp::mul(var_0, var_qd0);
    var_6 = wp::mul(var_1, var_qd1);
    var_7 = wp::add(var_5, var_6);
    // return rot, vel                                                                        <L 82>
    ret_0 = var_4;
    ret_1 = var_7;
    goto label0;
    //---------
    // reverse
    label0:;
    adj_7 += adj_ret_1;
    adj_4 += adj_ret_0;
    // adj: return rot, vel                                                                   <L 82>
    wp::adj_add(var_5, var_6, adj_5, adj_6, adj_7);
    wp::adj_mul(var_1, var_qd1, adj_1, adj_qd1, adj_6);
    wp::adj_mul(var_0, var_qd0, adj_0, adj_qd0, adj_5);
    // adj: vel = a0 * qd0 + a1 * qd1                                                         <L 80>
    wp::adj_mul(var_3, var_2, adj_3, adj_2, adj_4);
    // adj: rot = q_1 * q_0                                                                   <L 78>
    wp::adj_quat_from_axis_angle(var_1, var_q1, adj_1, adj_q1, adj_3);
    // adj: q_1 = wp.quat_from_axis_angle(a1, q1)                                             <L 76>
    wp::adj_quat_from_axis_angle(var_0, var_q0, adj_0, adj_q0, adj_2);
    // adj: q_0 = wp.quat_from_axis_angle(a0, q0)                                             <L 75>
    adj_transform_2d_rotational_axes_0(var_axis_0, var_axis_1, var_q0, var_0, var_1, adj_axis_0, adj_axis_1, adj_q0, adj_0, adj_1);
    // adj: a0, a1 = transform_2d_rotational_axes(axis_0, axis_1, q0)                         <L 73>
    // adj: def compute_2d_rotational_dofs(                                                   <L 62>
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/sim/articulation.py:127
static CUDA_CALLABLE void adj_transform_3d_rotational_axes_0(
    wp::vec_t<3, wp::float32> var_axis_0,
    wp::vec_t<3, wp::float32> var_axis_1,
    wp::vec_t<3, wp::float32> var_axis_2,
    wp::float32 var_q0,
    wp::float32 var_q1,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & ret_2,
    wp::vec_t<3, wp::float32> & adj_axis_0,
    wp::vec_t<3, wp::float32> & adj_axis_1,
    wp::vec_t<3, wp::float32> & adj_axis_2,
    wp::float32 & adj_q0,
    wp::float32 & adj_q1,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1,
    wp::vec_t<3, wp::float32> & adj_ret_2)
{
    //---------
    // primal vars
    wp::quat_t<wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::quat_t<wp::float32> var_2;
    wp::quat_t<wp::float32> var_3;
    wp::vec_t<3, wp::float32> var_4;
    //---------
    // dual vars
    wp::quat_t<wp::float32> adj_0 = {};
    wp::vec_t<3, wp::float32> adj_1 = {};
    wp::quat_t<wp::float32> adj_2 = {};
    wp::quat_t<wp::float32> adj_3 = {};
    wp::vec_t<3, wp::float32> adj_4 = {};
    //---------
    // forward
    // def transform_3d_rotational_axes(                                                      <L 128>
    // q_0 = wp.quat_from_axis_angle(axis_0, q0)                                              <L 141>
    var_0 = wp::quat_from_axis_angle(var_axis_0, var_q0);
    // axis_1_w = wp.quat_rotate(q_0, axis_1)                                                 <L 143>
    var_1 = wp::quat_rotate(var_0, var_axis_1);
    // q_1 = wp.quat_from_axis_angle(axis_1_w, q1)                                            <L 144>
    var_2 = wp::quat_from_axis_angle(var_1, var_q1);
    // axis_2_w = wp.quat_rotate(q_1 * q_0, axis_2)                                           <L 146>
    var_3 = wp::mul(var_2, var_0);
    var_4 = wp::quat_rotate(var_3, var_axis_2);
    // return axis_0, axis_1_w, axis_2_w                                                      <L 148>
    ret_0 = var_axis_0;
    ret_1 = var_1;
    ret_2 = var_4;
    goto label0;
    //---------
    // reverse
    label0:;
    adj_4 += adj_ret_2;
    adj_1 += adj_ret_1;
    adj_axis_0 += adj_ret_0;
    // adj: return axis_0, axis_1_w, axis_2_w                                                 <L 148>
    wp::adj_quat_rotate(var_3, var_axis_2, adj_3, adj_axis_2, adj_4);
    wp::adj_mul(var_2, var_0, adj_2, adj_0, adj_3);
    // adj: axis_2_w = wp.quat_rotate(q_1 * q_0, axis_2)                                      <L 146>
    wp::adj_quat_from_axis_angle(var_1, var_q1, adj_1, adj_q1, adj_2);
    // adj: q_1 = wp.quat_from_axis_angle(axis_1_w, q1)                                       <L 144>
    wp::adj_quat_rotate(var_0, var_axis_1, adj_0, adj_axis_1, adj_1);
    // adj: axis_1_w = wp.quat_rotate(q_0, axis_1)                                            <L 143>
    wp::adj_quat_from_axis_angle(var_axis_0, var_q0, adj_axis_0, adj_q0, adj_0);
    // adj: q_0 = wp.quat_from_axis_angle(axis_0, q0)                                         <L 141>
    // adj: def transform_3d_rotational_axes(                                                 <L 128>
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/sim/articulation.py:151
static CUDA_CALLABLE void adj_compute_3d_rotational_dofs_0(
    wp::vec_t<3, wp::float32> var_axis_0,
    wp::vec_t<3, wp::float32> var_axis_1,
    wp::vec_t<3, wp::float32> var_axis_2,
    wp::float32 var_q0,
    wp::float32 var_q1,
    wp::float32 var_q2,
    wp::float32 var_qd0,
    wp::float32 var_qd1,
    wp::float32 var_qd2,
    wp::quat_t<wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & adj_axis_0,
    wp::vec_t<3, wp::float32> & adj_axis_1,
    wp::vec_t<3, wp::float32> & adj_axis_2,
    wp::float32 & adj_q0,
    wp::float32 & adj_q1,
    wp::float32 & adj_q2,
    wp::float32 & adj_qd0,
    wp::float32 & adj_qd1,
    wp::float32 & adj_qd2,
    wp::quat_t<wp::float32> & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::quat_t<wp::float32> var_3;
    wp::quat_t<wp::float32> var_4;
    wp::quat_t<wp::float32> var_5;
    wp::quat_t<wp::float32> var_6;
    wp::quat_t<wp::float32> var_7;
    wp::vec_t<3, wp::float32> var_8;
    wp::vec_t<3, wp::float32> var_9;
    wp::vec_t<3, wp::float32> var_10;
    wp::vec_t<3, wp::float32> var_11;
    wp::vec_t<3, wp::float32> var_12;
    //---------
    // dual vars
    wp::vec_t<3, wp::float32> adj_0 = {};
    wp::vec_t<3, wp::float32> adj_1 = {};
    wp::vec_t<3, wp::float32> adj_2 = {};
    wp::quat_t<wp::float32> adj_3 = {};
    wp::quat_t<wp::float32> adj_4 = {};
    wp::quat_t<wp::float32> adj_5 = {};
    wp::quat_t<wp::float32> adj_6 = {};
    wp::quat_t<wp::float32> adj_7 = {};
    wp::vec_t<3, wp::float32> adj_8 = {};
    wp::vec_t<3, wp::float32> adj_9 = {};
    wp::vec_t<3, wp::float32> adj_10 = {};
    wp::vec_t<3, wp::float32> adj_11 = {};
    wp::vec_t<3, wp::float32> adj_12 = {};
    //---------
    // forward
    // def compute_3d_rotational_dofs(                                                        <L 152>
    // axis_0_w, axis_1_w, axis_2_w = transform_3d_rotational_axes(axis_0, axis_1, axis_2, q0, q1)       <L 169>
    transform_3d_rotational_axes_0(var_axis_0, var_axis_1, var_axis_2, var_q0, var_q1, var_0, var_1, var_2);
    // q_0 = wp.quat_from_axis_angle(axis_0_w, q0)                                            <L 171>
    var_3 = wp::quat_from_axis_angle(var_0, var_q0);
    // q_1 = wp.quat_from_axis_angle(axis_1_w, q1)                                            <L 172>
    var_4 = wp::quat_from_axis_angle(var_1, var_q1);
    // q_2 = wp.quat_from_axis_angle(axis_2_w, q2)                                            <L 173>
    var_5 = wp::quat_from_axis_angle(var_2, var_q2);
    // rot = q_2 * q_1 * q_0                                                                  <L 175>
    var_6 = wp::mul(var_5, var_4);
    var_7 = wp::mul(var_6, var_3);
    // vel = axis_0_w * qd0 + axis_1_w * qd1 + axis_2_w * qd2                                 <L 176>
    var_8 = wp::mul(var_0, var_qd0);
    var_9 = wp::mul(var_1, var_qd1);
    var_10 = wp::add(var_8, var_9);
    var_11 = wp::mul(var_2, var_qd2);
    var_12 = wp::add(var_10, var_11);
    // return rot, vel                                                                        <L 178>
    ret_0 = var_7;
    ret_1 = var_12;
    goto label0;
    //---------
    // reverse
    label0:;
    adj_12 += adj_ret_1;
    adj_7 += adj_ret_0;
    // adj: return rot, vel                                                                   <L 178>
    wp::adj_add(var_10, var_11, adj_10, adj_11, adj_12);
    wp::adj_mul(var_2, var_qd2, adj_2, adj_qd2, adj_11);
    wp::adj_add(var_8, var_9, adj_8, adj_9, adj_10);
    wp::adj_mul(var_1, var_qd1, adj_1, adj_qd1, adj_9);
    wp::adj_mul(var_0, var_qd0, adj_0, adj_qd0, adj_8);
    // adj: vel = axis_0_w * qd0 + axis_1_w * qd1 + axis_2_w * qd2                            <L 176>
    wp::adj_mul(var_6, var_3, adj_6, adj_3, adj_7);
    wp::adj_mul(var_5, var_4, adj_5, adj_4, adj_6);
    // adj: rot = q_2 * q_1 * q_0                                                             <L 175>
    wp::adj_quat_from_axis_angle(var_2, var_q2, adj_2, adj_q2, adj_5);
    // adj: q_2 = wp.quat_from_axis_angle(axis_2_w, q2)                                       <L 173>
    wp::adj_quat_from_axis_angle(var_1, var_q1, adj_1, adj_q1, adj_4);
    // adj: q_1 = wp.quat_from_axis_angle(axis_1_w, q1)                                       <L 172>
    wp::adj_quat_from_axis_angle(var_0, var_q0, adj_0, adj_q0, adj_3);
    // adj: q_0 = wp.quat_from_axis_angle(axis_0_w, q0)                                       <L 171>
    adj_transform_3d_rotational_axes_0(var_axis_0, var_axis_1, var_axis_2, var_q0, var_q1, var_0, var_1, var_2, adj_axis_0, adj_axis_1, adj_axis_2, adj_q0, adj_q1, adj_0, adj_1, adj_2);
    // adj: axis_0_w, axis_1_w, axis_2_w = transform_3d_rotational_axes(axis_0, axis_1, axis_2, q0, q1)  <L 169>
    // adj: def compute_3d_rotational_dofs(                                                   <L 152>
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/solvers/featherstone/kernels.py:142
static CUDA_CALLABLE void adj_jcalc_transform_0(
    wp::int32 var_type,
    wp::array_t<wp::vec_t<3, wp::float32>> var_joint_axis,
    wp::int32 var_axis_start,
    wp::int32 var_lin_axis_count,
    wp::int32 var_ang_axis_count,
    wp::array_t<wp::float32> var_joint_q,
    wp::int32 var_q_start,
    wp::int32 & adj_type,
    wp::array_t<wp::vec_t<3, wp::float32>> & adj_joint_axis,
    wp::int32 & adj_axis_start,
    wp::int32 & adj_lin_axis_count,
    wp::int32 & adj_ang_axis_count,
    wp::array_t<wp::float32> & adj_joint_q,
    wp::int32 & adj_q_start,
    wp::transform_t<wp::float32> & adj_ret)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    bool var_1;
    wp::float32* var_2;
    wp::float32 var_3;
    wp::float32 var_4;
    wp::vec_t<3, wp::float32>* var_5;
    wp::vec_t<3, wp::float32> var_6;
    wp::vec_t<3, wp::float32> var_7;
    wp::vec_t<3, wp::float32> var_8;
    wp::quat_t<wp::float32> var_9;
    wp::transform_t<wp::float32> var_10;
    const wp::int32 var_11 = 1;
    bool var_12;
    wp::float32* var_13;
    wp::float32 var_14;
    wp::float32 var_15;
    wp::vec_t<3, wp::float32>* var_16;
    wp::vec_t<3, wp::float32> var_17;
    wp::vec_t<3, wp::float32> var_18;
    wp::vec_t<3, wp::float32> var_19;
    wp::quat_t<wp::float32> var_20;
    wp::transform_t<wp::float32> var_21;
    wp::float32 var_22;
    wp::vec_t<3, wp::float32> var_23;
    wp::transform_t<wp::float32> var_24;
    const wp::int32 var_25 = 2;
    bool var_26;
    const wp::int32 var_27 = 0;
    wp::int32 var_28;
    wp::float32* var_29;
    wp::float32 var_30;
    wp::float32 var_31;
    const wp::int32 var_32 = 1;
    wp::int32 var_33;
    wp::float32* var_34;
    wp::float32 var_35;
    wp::float32 var_36;
    const wp::int32 var_37 = 2;
    wp::int32 var_38;
    wp::float32* var_39;
    wp::float32 var_40;
    wp::float32 var_41;
    const wp::int32 var_42 = 3;
    wp::int32 var_43;
    wp::float32* var_44;
    wp::float32 var_45;
    wp::float32 var_46;
    wp::vec_t<3, wp::float32> var_47;
    wp::quat_t<wp::float32> var_48;
    wp::transform_t<wp::float32> var_49;
    wp::transform_t<wp::float32> var_50;
    const wp::int32 var_51 = 3;
    bool var_52;
    wp::transform_t<wp::float32> var_53;
    wp::transform_t<wp::float32> var_54;
    bool var_55;
    const wp::int32 var_56 = 4;
    bool var_57;
    const wp::int32 var_58 = 5;
    bool var_59;
    const wp::int32 var_60 = 0;
    wp::int32 var_61;
    wp::float32* var_62;
    wp::float32 var_63;
    wp::float32 var_64;
    const wp::int32 var_65 = 1;
    wp::int32 var_66;
    wp::float32* var_67;
    wp::float32 var_68;
    wp::float32 var_69;
    const wp::int32 var_70 = 2;
    wp::int32 var_71;
    wp::float32* var_72;
    wp::float32 var_73;
    wp::float32 var_74;
    const wp::int32 var_75 = 3;
    wp::int32 var_76;
    wp::float32* var_77;
    wp::float32 var_78;
    wp::float32 var_79;
    const wp::int32 var_80 = 4;
    wp::int32 var_81;
    wp::float32* var_82;
    wp::float32 var_83;
    wp::float32 var_84;
    const wp::int32 var_85 = 5;
    wp::int32 var_86;
    wp::float32* var_87;
    wp::float32 var_88;
    wp::float32 var_89;
    const wp::int32 var_90 = 6;
    wp::int32 var_91;
    wp::float32* var_92;
    wp::float32 var_93;
    wp::float32 var_94;
    wp::vec_t<3, wp::float32> var_95;
    wp::quat_t<wp::float32> var_96;
    wp::transform_t<wp::float32> var_97;
    wp::transform_t<wp::float32> var_98;
    wp::float32 var_99;
    wp::float32 var_100;
    wp::float32 var_101;
    wp::float32 var_102;
    const wp::int32 var_103 = 6;
    bool var_104;
    const wp::float32 var_105 = 0.0;
    wp::vec_t<3, wp::float32> var_106;
    wp::quat_t<wp::float32> var_107;
    const wp::int32 var_108 = 0;
    bool var_109;
    const wp::int32 var_110 = 0;
    wp::int32 var_111;
    wp::vec_t<3, wp::float32>* var_112;
    wp::vec_t<3, wp::float32> var_113;
    wp::vec_t<3, wp::float32> var_114;
    const wp::int32 var_115 = 0;
    wp::int32 var_116;
    wp::float32* var_117;
    wp::vec_t<3, wp::float32> var_118;
    wp::float32 var_119;
    wp::vec_t<3, wp::float32> var_120;
    wp::vec_t<3, wp::float32> var_121;
    wp::vec_t<3, wp::float32> var_122;
    const wp::int32 var_123 = 1;
    bool var_124;
    const wp::int32 var_125 = 1;
    wp::int32 var_126;
    wp::vec_t<3, wp::float32>* var_127;
    wp::vec_t<3, wp::float32> var_128;
    wp::vec_t<3, wp::float32> var_129;
    const wp::int32 var_130 = 1;
    wp::int32 var_131;
    wp::float32* var_132;
    wp::vec_t<3, wp::float32> var_133;
    wp::float32 var_134;
    wp::vec_t<3, wp::float32> var_135;
    wp::vec_t<3, wp::float32> var_136;
    wp::vec_t<3, wp::float32> var_137;
    const wp::int32 var_138 = 2;
    bool var_139;
    const wp::int32 var_140 = 2;
    wp::int32 var_141;
    wp::vec_t<3, wp::float32>* var_142;
    wp::vec_t<3, wp::float32> var_143;
    wp::vec_t<3, wp::float32> var_144;
    const wp::int32 var_145 = 2;
    wp::int32 var_146;
    wp::float32* var_147;
    wp::vec_t<3, wp::float32> var_148;
    wp::float32 var_149;
    wp::vec_t<3, wp::float32> var_150;
    wp::vec_t<3, wp::float32> var_151;
    wp::vec_t<3, wp::float32> var_152;
    wp::int32 var_153;
    wp::int32 var_154;
    const wp::int32 var_155 = 1;
    bool var_156;
    wp::vec_t<3, wp::float32>* var_157;
    wp::vec_t<3, wp::float32> var_158;
    wp::vec_t<3, wp::float32> var_159;
    wp::float32* var_160;
    wp::quat_t<wp::float32> var_161;
    wp::float32 var_162;
    wp::vec_t<3, wp::float32> var_163;
    wp::quat_t<wp::float32> var_164;
    const wp::int32 var_165 = 2;
    bool var_166;
    const wp::int32 var_167 = 0;
    wp::int32 var_168;
    wp::vec_t<3, wp::float32>* var_169;
    const wp::int32 var_170 = 1;
    wp::int32 var_171;
    wp::vec_t<3, wp::float32>* var_172;
    const wp::int32 var_173 = 0;
    wp::int32 var_174;
    wp::float32* var_175;
    const wp::int32 var_176 = 1;
    wp::int32 var_177;
    wp::float32* var_178;
    const wp::float32 var_179 = 0.0;
    const wp::float32 var_180 = 0.0;
    wp::quat_t<wp::float32> var_181;
    wp::vec_t<3, wp::float32> var_182;
    wp::vec_t<3, wp::float32> var_183;
    wp::vec_t<3, wp::float32> var_184;
    wp::float32 var_185;
    wp::float32 var_186;
    wp::quat_t<wp::float32> var_187;
    const wp::int32 var_188 = 3;
    bool var_189;
    const wp::int32 var_190 = 0;
    wp::int32 var_191;
    wp::vec_t<3, wp::float32>* var_192;
    const wp::int32 var_193 = 1;
    wp::int32 var_194;
    wp::vec_t<3, wp::float32>* var_195;
    const wp::int32 var_196 = 2;
    wp::int32 var_197;
    wp::vec_t<3, wp::float32>* var_198;
    const wp::int32 var_199 = 0;
    wp::int32 var_200;
    wp::float32* var_201;
    const wp::int32 var_202 = 1;
    wp::int32 var_203;
    wp::float32* var_204;
    const wp::int32 var_205 = 2;
    wp::int32 var_206;
    wp::float32* var_207;
    const wp::float32 var_208 = 0.0;
    const wp::float32 var_209 = 0.0;
    const wp::float32 var_210 = 0.0;
    wp::quat_t<wp::float32> var_211;
    wp::vec_t<3, wp::float32> var_212;
    wp::vec_t<3, wp::float32> var_213;
    wp::vec_t<3, wp::float32> var_214;
    wp::vec_t<3, wp::float32> var_215;
    wp::float32 var_216;
    wp::float32 var_217;
    wp::float32 var_218;
    wp::quat_t<wp::float32> var_219;
    wp::vec_t<3, wp::float32> var_220;
    wp::transform_t<wp::float32> var_221;
    wp::vec_t<3, wp::float32> var_222;
    wp::transform_t<wp::float32> var_223;
    wp::transform_t<wp::float32> var_224;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    bool adj_1 = {};
    wp::float32 adj_2 = {};
    wp::float32 adj_3 = {};
    wp::float32 adj_4 = {};
    wp::vec_t<3, wp::float32> adj_5 = {};
    wp::vec_t<3, wp::float32> adj_6 = {};
    wp::vec_t<3, wp::float32> adj_7 = {};
    wp::vec_t<3, wp::float32> adj_8 = {};
    wp::quat_t<wp::float32> adj_9 = {};
    wp::transform_t<wp::float32> adj_10 = {};
    wp::int32 adj_11 = {};
    bool adj_12 = {};
    wp::float32 adj_13 = {};
    wp::float32 adj_14 = {};
    wp::float32 adj_15 = {};
    wp::vec_t<3, wp::float32> adj_16 = {};
    wp::vec_t<3, wp::float32> adj_17 = {};
    wp::vec_t<3, wp::float32> adj_18 = {};
    wp::vec_t<3, wp::float32> adj_19 = {};
    wp::quat_t<wp::float32> adj_20 = {};
    wp::transform_t<wp::float32> adj_21 = {};
    wp::float32 adj_22 = {};
    wp::vec_t<3, wp::float32> adj_23 = {};
    wp::transform_t<wp::float32> adj_24 = {};
    wp::int32 adj_25 = {};
    bool adj_26 = {};
    wp::int32 adj_27 = {};
    wp::int32 adj_28 = {};
    wp::float32 adj_29 = {};
    wp::float32 adj_30 = {};
    wp::float32 adj_31 = {};
    wp::int32 adj_32 = {};
    wp::int32 adj_33 = {};
    wp::float32 adj_34 = {};
    wp::float32 adj_35 = {};
    wp::float32 adj_36 = {};
    wp::int32 adj_37 = {};
    wp::int32 adj_38 = {};
    wp::float32 adj_39 = {};
    wp::float32 adj_40 = {};
    wp::float32 adj_41 = {};
    wp::int32 adj_42 = {};
    wp::int32 adj_43 = {};
    wp::float32 adj_44 = {};
    wp::float32 adj_45 = {};
    wp::float32 adj_46 = {};
    wp::vec_t<3, wp::float32> adj_47 = {};
    wp::quat_t<wp::float32> adj_48 = {};
    wp::transform_t<wp::float32> adj_49 = {};
    wp::transform_t<wp::float32> adj_50 = {};
    wp::int32 adj_51 = {};
    bool adj_52 = {};
    wp::transform_t<wp::float32> adj_53 = {};
    wp::transform_t<wp::float32> adj_54 = {};
    bool adj_55 = {};
    wp::int32 adj_56 = {};
    bool adj_57 = {};
    wp::int32 adj_58 = {};
    bool adj_59 = {};
    wp::int32 adj_60 = {};
    wp::int32 adj_61 = {};
    wp::float32 adj_62 = {};
    wp::float32 adj_63 = {};
    wp::float32 adj_64 = {};
    wp::int32 adj_65 = {};
    wp::int32 adj_66 = {};
    wp::float32 adj_67 = {};
    wp::float32 adj_68 = {};
    wp::float32 adj_69 = {};
    wp::int32 adj_70 = {};
    wp::int32 adj_71 = {};
    wp::float32 adj_72 = {};
    wp::float32 adj_73 = {};
    wp::float32 adj_74 = {};
    wp::int32 adj_75 = {};
    wp::int32 adj_76 = {};
    wp::float32 adj_77 = {};
    wp::float32 adj_78 = {};
    wp::float32 adj_79 = {};
    wp::int32 adj_80 = {};
    wp::int32 adj_81 = {};
    wp::float32 adj_82 = {};
    wp::float32 adj_83 = {};
    wp::float32 adj_84 = {};
    wp::int32 adj_85 = {};
    wp::int32 adj_86 = {};
    wp::float32 adj_87 = {};
    wp::float32 adj_88 = {};
    wp::float32 adj_89 = {};
    wp::int32 adj_90 = {};
    wp::int32 adj_91 = {};
    wp::float32 adj_92 = {};
    wp::float32 adj_93 = {};
    wp::float32 adj_94 = {};
    wp::vec_t<3, wp::float32> adj_95 = {};
    wp::quat_t<wp::float32> adj_96 = {};
    wp::transform_t<wp::float32> adj_97 = {};
    wp::transform_t<wp::float32> adj_98 = {};
    wp::float32 adj_99 = {};
    wp::float32 adj_100 = {};
    wp::float32 adj_101 = {};
    wp::float32 adj_102 = {};
    wp::int32 adj_103 = {};
    bool adj_104 = {};
    wp::float32 adj_105 = {};
    wp::vec_t<3, wp::float32> adj_106 = {};
    wp::quat_t<wp::float32> adj_107 = {};
    wp::int32 adj_108 = {};
    bool adj_109 = {};
    wp::int32 adj_110 = {};
    wp::int32 adj_111 = {};
    wp::vec_t<3, wp::float32> adj_112 = {};
    wp::vec_t<3, wp::float32> adj_113 = {};
    wp::vec_t<3, wp::float32> adj_114 = {};
    wp::int32 adj_115 = {};
    wp::int32 adj_116 = {};
    wp::float32 adj_117 = {};
    wp::vec_t<3, wp::float32> adj_118 = {};
    wp::float32 adj_119 = {};
    wp::vec_t<3, wp::float32> adj_120 = {};
    wp::vec_t<3, wp::float32> adj_121 = {};
    wp::vec_t<3, wp::float32> adj_122 = {};
    wp::int32 adj_123 = {};
    bool adj_124 = {};
    wp::int32 adj_125 = {};
    wp::int32 adj_126 = {};
    wp::vec_t<3, wp::float32> adj_127 = {};
    wp::vec_t<3, wp::float32> adj_128 = {};
    wp::vec_t<3, wp::float32> adj_129 = {};
    wp::int32 adj_130 = {};
    wp::int32 adj_131 = {};
    wp::float32 adj_132 = {};
    wp::vec_t<3, wp::float32> adj_133 = {};
    wp::float32 adj_134 = {};
    wp::vec_t<3, wp::float32> adj_135 = {};
    wp::vec_t<3, wp::float32> adj_136 = {};
    wp::vec_t<3, wp::float32> adj_137 = {};
    wp::int32 adj_138 = {};
    bool adj_139 = {};
    wp::int32 adj_140 = {};
    wp::int32 adj_141 = {};
    wp::vec_t<3, wp::float32> adj_142 = {};
    wp::vec_t<3, wp::float32> adj_143 = {};
    wp::vec_t<3, wp::float32> adj_144 = {};
    wp::int32 adj_145 = {};
    wp::int32 adj_146 = {};
    wp::float32 adj_147 = {};
    wp::vec_t<3, wp::float32> adj_148 = {};
    wp::float32 adj_149 = {};
    wp::vec_t<3, wp::float32> adj_150 = {};
    wp::vec_t<3, wp::float32> adj_151 = {};
    wp::vec_t<3, wp::float32> adj_152 = {};
    wp::int32 adj_153 = {};
    wp::int32 adj_154 = {};
    wp::int32 adj_155 = {};
    bool adj_156 = {};
    wp::vec_t<3, wp::float32> adj_157 = {};
    wp::vec_t<3, wp::float32> adj_158 = {};
    wp::vec_t<3, wp::float32> adj_159 = {};
    wp::float32 adj_160 = {};
    wp::quat_t<wp::float32> adj_161 = {};
    wp::float32 adj_162 = {};
    wp::vec_t<3, wp::float32> adj_163 = {};
    wp::quat_t<wp::float32> adj_164 = {};
    wp::int32 adj_165 = {};
    bool adj_166 = {};
    wp::int32 adj_167 = {};
    wp::int32 adj_168 = {};
    wp::vec_t<3, wp::float32> adj_169 = {};
    wp::int32 adj_170 = {};
    wp::int32 adj_171 = {};
    wp::vec_t<3, wp::float32> adj_172 = {};
    wp::int32 adj_173 = {};
    wp::int32 adj_174 = {};
    wp::float32 adj_175 = {};
    wp::int32 adj_176 = {};
    wp::int32 adj_177 = {};
    wp::float32 adj_178 = {};
    wp::float32 adj_179 = {};
    wp::float32 adj_180 = {};
    wp::quat_t<wp::float32> adj_181 = {};
    wp::vec_t<3, wp::float32> adj_182 = {};
    wp::vec_t<3, wp::float32> adj_183 = {};
    wp::vec_t<3, wp::float32> adj_184 = {};
    wp::float32 adj_185 = {};
    wp::float32 adj_186 = {};
    wp::quat_t<wp::float32> adj_187 = {};
    wp::int32 adj_188 = {};
    bool adj_189 = {};
    wp::int32 adj_190 = {};
    wp::int32 adj_191 = {};
    wp::vec_t<3, wp::float32> adj_192 = {};
    wp::int32 adj_193 = {};
    wp::int32 adj_194 = {};
    wp::vec_t<3, wp::float32> adj_195 = {};
    wp::int32 adj_196 = {};
    wp::int32 adj_197 = {};
    wp::vec_t<3, wp::float32> adj_198 = {};
    wp::int32 adj_199 = {};
    wp::int32 adj_200 = {};
    wp::float32 adj_201 = {};
    wp::int32 adj_202 = {};
    wp::int32 adj_203 = {};
    wp::float32 adj_204 = {};
    wp::int32 adj_205 = {};
    wp::int32 adj_206 = {};
    wp::float32 adj_207 = {};
    wp::float32 adj_208 = {};
    wp::float32 adj_209 = {};
    wp::float32 adj_210 = {};
    wp::quat_t<wp::float32> adj_211 = {};
    wp::vec_t<3, wp::float32> adj_212 = {};
    wp::vec_t<3, wp::float32> adj_213 = {};
    wp::vec_t<3, wp::float32> adj_214 = {};
    wp::vec_t<3, wp::float32> adj_215 = {};
    wp::float32 adj_216 = {};
    wp::float32 adj_217 = {};
    wp::float32 adj_218 = {};
    wp::quat_t<wp::float32> adj_219 = {};
    wp::vec_t<3, wp::float32> adj_220 = {};
    wp::transform_t<wp::float32> adj_221 = {};
    wp::vec_t<3, wp::float32> adj_222 = {};
    wp::transform_t<wp::float32> adj_223 = {};
    wp::transform_t<wp::float32> adj_224 = {};
    //---------
    // forward
    // def jcalc_transform(                                                                   <L 143>
    // if type == JointType.PRISMATIC:                                                        <L 152>
    var_1 = (var_type == var_0);
    if (var_1) {
        // q = joint_q[q_start]                                                               <L 153>
        var_2 = wp::address(var_joint_q, var_q_start);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // axis = joint_axis[axis_start]                                                      <L 154>
        var_5 = wp::address(var_joint_axis, var_axis_start);
        var_7 = wp::load(var_5);
        var_6 = wp::copy(var_7);
        // X_jc = wp.transform(axis * q, wp.quat_identity())                                  <L 155>
        var_8 = wp::mul(var_6, var_3);
        var_9 = wp::quat_identity<wp::float32>();
        var_10 = wp::transform_t<wp::float32>(var_8, var_9);
        // return X_jc                                                                        <L 156>
        goto label0;
    }
    // if type == JointType.REVOLUTE:                                                         <L 158>
    var_12 = (var_type == var_11);
    if (var_12) {
        // q = joint_q[q_start]                                                               <L 159>
        var_13 = wp::address(var_joint_q, var_q_start);
        var_15 = wp::load(var_13);
        var_14 = wp::copy(var_15);
        // axis = joint_axis[axis_start]                                                      <L 160>
        var_16 = wp::address(var_joint_axis, var_axis_start);
        var_18 = wp::load(var_16);
        var_17 = wp::copy(var_18);
        // X_jc = wp.transform(wp.vec3(), wp.quat_from_axis_angle(axis, q))                   <L 161>
        var_19 = wp::vec_t<3, wp::float32>();
        var_20 = wp::quat_from_axis_angle(var_17, var_14);
        var_21 = wp::transform_t<wp::float32>(var_19, var_20);
        // return X_jc                                                                        <L 162>
        goto label1;
    }
    var_22 = wp::where(var_12, var_14, var_3);
    var_23 = wp::where(var_12, var_17, var_6);
    var_24 = wp::where(var_12, var_21, var_10);
    // if type == JointType.BALL:                                                             <L 164>
    var_26 = (var_type == var_25);
    if (var_26) {
        // qx = joint_q[q_start + 0]                                                          <L 165>
        var_28 = wp::add(var_q_start, var_27);
        var_29 = wp::address(var_joint_q, var_28);
        var_31 = wp::load(var_29);
        var_30 = wp::copy(var_31);
        // qy = joint_q[q_start + 1]                                                          <L 166>
        var_33 = wp::add(var_q_start, var_32);
        var_34 = wp::address(var_joint_q, var_33);
        var_36 = wp::load(var_34);
        var_35 = wp::copy(var_36);
        // qz = joint_q[q_start + 2]                                                          <L 167>
        var_38 = wp::add(var_q_start, var_37);
        var_39 = wp::address(var_joint_q, var_38);
        var_41 = wp::load(var_39);
        var_40 = wp::copy(var_41);
        // qw = joint_q[q_start + 3]                                                          <L 168>
        var_43 = wp::add(var_q_start, var_42);
        var_44 = wp::address(var_joint_q, var_43);
        var_46 = wp::load(var_44);
        var_45 = wp::copy(var_46);
        // X_jc = wp.transform(wp.vec3(), wp.quat(qx, qy, qz, qw))                            <L 170>
        var_47 = wp::vec_t<3, wp::float32>();
        var_48 = wp::quat_t<wp::float32>(var_30, var_35, var_40, var_45);
        var_49 = wp::transform_t<wp::float32>(var_47, var_48);
        // return X_jc                                                                        <L 171>
        goto label2;
    }
    var_50 = wp::where(var_26, var_49, var_24);
    // if type == JointType.FIXED:                                                            <L 173>
    var_52 = (var_type == var_51);
    if (var_52) {
        // X_jc = wp.transform_identity()                                                     <L 174>
        var_53 = wp::transform_identity<wp::float32>();
        // return X_jc                                                                        <L 175>
        goto label3;
    }
    var_54 = wp::where(var_52, var_53, var_50);
    // if type == JointType.FREE or type == JointType.DISTANCE:                               <L 177>
    var_57 = (var_type == var_56);
    var_55 = var_57;
    if (!var_55) {
        var_59 = (var_type == var_58);
        var_55 = var_55 || var_59;
    }
    if (var_55) {
        // px = joint_q[q_start + 0]                                                          <L 178>
        var_61 = wp::add(var_q_start, var_60);
        var_62 = wp::address(var_joint_q, var_61);
        var_64 = wp::load(var_62);
        var_63 = wp::copy(var_64);
        // py = joint_q[q_start + 1]                                                          <L 179>
        var_66 = wp::add(var_q_start, var_65);
        var_67 = wp::address(var_joint_q, var_66);
        var_69 = wp::load(var_67);
        var_68 = wp::copy(var_69);
        // pz = joint_q[q_start + 2]                                                          <L 180>
        var_71 = wp::add(var_q_start, var_70);
        var_72 = wp::address(var_joint_q, var_71);
        var_74 = wp::load(var_72);
        var_73 = wp::copy(var_74);
        // qx = joint_q[q_start + 3]                                                          <L 182>
        var_76 = wp::add(var_q_start, var_75);
        var_77 = wp::address(var_joint_q, var_76);
        var_79 = wp::load(var_77);
        var_78 = wp::copy(var_79);
        // qy = joint_q[q_start + 4]                                                          <L 183>
        var_81 = wp::add(var_q_start, var_80);
        var_82 = wp::address(var_joint_q, var_81);
        var_84 = wp::load(var_82);
        var_83 = wp::copy(var_84);
        // qz = joint_q[q_start + 5]                                                          <L 184>
        var_86 = wp::add(var_q_start, var_85);
        var_87 = wp::address(var_joint_q, var_86);
        var_89 = wp::load(var_87);
        var_88 = wp::copy(var_89);
        // qw = joint_q[q_start + 6]                                                          <L 185>
        var_91 = wp::add(var_q_start, var_90);
        var_92 = wp::address(var_joint_q, var_91);
        var_94 = wp::load(var_92);
        var_93 = wp::copy(var_94);
        // X_jc = wp.transform(wp.vec3(px, py, pz), wp.quat(qx, qy, qz, qw))                  <L 187>
        var_95 = wp::vec_t<3, wp::float32>(var_63, var_68, var_73);
        var_96 = wp::quat_t<wp::float32>(var_78, var_83, var_88, var_93);
        var_97 = wp::transform_t<wp::float32>(var_95, var_96);
        // return X_jc                                                                        <L 188>
        goto label4;
    }
    var_98 = wp::where(var_55, var_97, var_54);
    var_99 = wp::where(var_55, var_78, var_30);
    var_100 = wp::where(var_55, var_83, var_35);
    var_101 = wp::where(var_55, var_88, var_40);
    var_102 = wp::where(var_55, var_93, var_45);
    // if type == JointType.D6:                                                               <L 190>
    var_104 = (var_type == var_103);
    if (var_104) {
        // pos = wp.vec3(0.0)                                                                 <L 191>
        var_106 = wp::vec_t<3, wp::float32>(var_105);
        // rot = wp.quat_identity()                                                           <L 192>
        var_107 = wp::quat_identity<wp::float32>();
        // if lin_axis_count > 0:                                                             <L 197>
        var_109 = (var_lin_axis_count > var_108);
        if (var_109) {
            // axis = joint_axis[axis_start + 0]                                              <L 198>
            var_111 = wp::add(var_axis_start, var_110);
            var_112 = wp::address(var_joint_axis, var_111);
            var_114 = wp::load(var_112);
            var_113 = wp::copy(var_114);
            // pos += axis * joint_q[q_start + 0]                                             <L 199>
            var_116 = wp::add(var_q_start, var_115);
            var_117 = wp::address(var_joint_q, var_116);
            var_119 = wp::load(var_117);
            var_118 = wp::mul(var_113, var_119);
            var_120 = wp::add(var_106, var_118);
        }
        var_121 = wp::where(var_109, var_113, var_23);
        var_122 = wp::where(var_109, var_120, var_106);
        // if lin_axis_count > 1:                                                             <L 200>
        var_124 = (var_lin_axis_count > var_123);
        if (var_124) {
            // axis = joint_axis[axis_start + 1]                                              <L 201>
            var_126 = wp::add(var_axis_start, var_125);
            var_127 = wp::address(var_joint_axis, var_126);
            var_129 = wp::load(var_127);
            var_128 = wp::copy(var_129);
            // pos += axis * joint_q[q_start + 1]                                             <L 202>
            var_131 = wp::add(var_q_start, var_130);
            var_132 = wp::address(var_joint_q, var_131);
            var_134 = wp::load(var_132);
            var_133 = wp::mul(var_128, var_134);
            var_135 = wp::add(var_122, var_133);
        }
        var_136 = wp::where(var_124, var_128, var_121);
        var_137 = wp::where(var_124, var_135, var_122);
        // if lin_axis_count > 2:                                                             <L 203>
        var_139 = (var_lin_axis_count > var_138);
        if (var_139) {
            // axis = joint_axis[axis_start + 2]                                              <L 204>
            var_141 = wp::add(var_axis_start, var_140);
            var_142 = wp::address(var_joint_axis, var_141);
            var_144 = wp::load(var_142);
            var_143 = wp::copy(var_144);
            // pos += axis * joint_q[q_start + 2]                                             <L 205>
            var_146 = wp::add(var_q_start, var_145);
            var_147 = wp::address(var_joint_q, var_146);
            var_149 = wp::load(var_147);
            var_148 = wp::mul(var_143, var_149);
            var_150 = wp::add(var_137, var_148);
        }
        var_151 = wp::where(var_139, var_143, var_136);
        var_152 = wp::where(var_139, var_150, var_137);
        // ia = axis_start + lin_axis_count                                                   <L 207>
        var_153 = wp::add(var_axis_start, var_lin_axis_count);
        // iq = q_start + lin_axis_count                                                      <L 208>
        var_154 = wp::add(var_q_start, var_lin_axis_count);
        // if ang_axis_count == 1:                                                            <L 209>
        var_156 = (var_ang_axis_count == var_155);
        if (var_156) {
            // axis = joint_axis[ia]                                                          <L 210>
            var_157 = wp::address(var_joint_axis, var_153);
            var_159 = wp::load(var_157);
            var_158 = wp::copy(var_159);
            // rot = wp.quat_from_axis_angle(axis, joint_q[iq])                               <L 211>
            var_160 = wp::address(var_joint_q, var_154);
            var_162 = wp::load(var_160);
            var_161 = wp::quat_from_axis_angle(var_158, var_162);
        }
        var_163 = wp::where(var_156, var_158, var_151);
        var_164 = wp::where(var_156, var_161, var_107);
        // if ang_axis_count == 2:                                                            <L 212>
        var_166 = (var_ang_axis_count == var_165);
        if (var_166) {
            // rot, _ = compute_2d_rotational_dofs(                                           <L 213>
            // joint_axis[ia + 0],                                                            <L 214>
            var_168 = wp::add(var_153, var_167);
            var_169 = wp::address(var_joint_axis, var_168);
            // joint_axis[ia + 1],                                                            <L 215>
            var_171 = wp::add(var_153, var_170);
            var_172 = wp::address(var_joint_axis, var_171);
            // joint_q[iq + 0],                                                               <L 216>
            var_174 = wp::add(var_154, var_173);
            var_175 = wp::address(var_joint_q, var_174);
            // joint_q[iq + 1],                                                               <L 217>
            var_177 = wp::add(var_154, var_176);
            var_178 = wp::address(var_joint_q, var_177);
            // 0.0,                                                                           <L 218>
            // 0.0,                                                                           <L 219>
            var_183 = wp::load(var_169);
            var_184 = wp::load(var_172);
            var_185 = wp::load(var_175);
            var_186 = wp::load(var_178);
            compute_2d_rotational_dofs_0(var_183, var_184, var_185, var_186, var_179, var_180, var_181, var_182);
        }
        var_187 = wp::where(var_166, var_181, var_164);
        // if ang_axis_count == 3:                                                            <L 221>
        var_189 = (var_ang_axis_count == var_188);
        if (var_189) {
            // rot, _ = compute_3d_rotational_dofs(                                           <L 222>
            // joint_axis[ia + 0],                                                            <L 223>
            var_191 = wp::add(var_153, var_190);
            var_192 = wp::address(var_joint_axis, var_191);
            // joint_axis[ia + 1],                                                            <L 224>
            var_194 = wp::add(var_153, var_193);
            var_195 = wp::address(var_joint_axis, var_194);
            // joint_axis[ia + 2],                                                            <L 225>
            var_197 = wp::add(var_153, var_196);
            var_198 = wp::address(var_joint_axis, var_197);
            // joint_q[iq + 0],                                                               <L 226>
            var_200 = wp::add(var_154, var_199);
            var_201 = wp::address(var_joint_q, var_200);
            // joint_q[iq + 1],                                                               <L 227>
            var_203 = wp::add(var_154, var_202);
            var_204 = wp::address(var_joint_q, var_203);
            // joint_q[iq + 2],                                                               <L 228>
            var_206 = wp::add(var_154, var_205);
            var_207 = wp::address(var_joint_q, var_206);
            // 0.0,                                                                           <L 229>
            // 0.0,                                                                           <L 230>
            // 0.0,                                                                           <L 231>
            var_213 = wp::load(var_192);
            var_214 = wp::load(var_195);
            var_215 = wp::load(var_198);
            var_216 = wp::load(var_201);
            var_217 = wp::load(var_204);
            var_218 = wp::load(var_207);
            compute_3d_rotational_dofs_0(var_213, var_214, var_215, var_216, var_217, var_218, var_208, var_209, var_210, var_211, var_212);
        }
        var_219 = wp::where(var_189, var_211, var_187);
        var_220 = wp::where(var_189, var_212, var_182);
        // X_jc = wp.transform(pos, rot)                                                      <L 234>
        var_221 = wp::transform_t<wp::float32>(var_152, var_219);
        // return X_jc                                                                        <L 235>
        goto label5;
    }
    var_222 = wp::where(var_104, var_163, var_23);
    var_223 = wp::where(var_104, var_221, var_98);
    // return wp.transform_identity()                                                         <L 238>
    var_224 = wp::transform_identity<wp::float32>();
    goto label6;
    //---------
    // reverse
    label6:;
    adj_224 += adj_ret;
    // adj: return wp.transform_identity()                                                    <L 238>
    wp::adj_where(var_104, var_221, var_98, adj_104, adj_221, adj_98, adj_223);
    wp::adj_where(var_104, var_163, var_23, adj_104, adj_163, adj_23, adj_222);
    if (var_104) {
        label5:;
        adj_221 += adj_ret;
        // adj: return X_jc                                                                   <L 235>
        wp::adj_transform_t(var_152, var_219, adj_152, adj_219, adj_221);
        // adj: X_jc = wp.transform(pos, rot)                                                 <L 234>
        wp::adj_where(var_189, var_212, var_182, adj_189, adj_212, adj_182, adj_220);
        wp::adj_where(var_189, var_211, var_187, adj_189, adj_211, adj_187, adj_219);
        if (var_189) {
            adj_compute_3d_rotational_dofs_0(var_213, var_214, var_215, var_216, var_217, var_218, var_208, var_209, var_210, var_211, var_212, adj_192, adj_195, adj_198, adj_201, adj_204, adj_207, adj_208, adj_209, adj_210, adj_211, adj_212);
            // adj: 0.0,                                                                      <L 231>
            // adj: 0.0,                                                                      <L 230>
            // adj: 0.0,                                                                      <L 229>
            wp::adj_address(var_joint_q, var_206, adj_joint_q, adj_206, adj_207);
            wp::adj_add(var_154, var_205, adj_154, adj_205, adj_206);
            // adj: joint_q[iq + 2],                                                          <L 228>
            wp::adj_address(var_joint_q, var_203, adj_joint_q, adj_203, adj_204);
            wp::adj_add(var_154, var_202, adj_154, adj_202, adj_203);
            // adj: joint_q[iq + 1],                                                          <L 227>
            wp::adj_address(var_joint_q, var_200, adj_joint_q, adj_200, adj_201);
            wp::adj_add(var_154, var_199, adj_154, adj_199, adj_200);
            // adj: joint_q[iq + 0],                                                          <L 226>
            wp::adj_address(var_joint_axis, var_197, adj_joint_axis, adj_197, adj_198);
            wp::adj_add(var_153, var_196, adj_153, adj_196, adj_197);
            // adj: joint_axis[ia + 2],                                                       <L 225>
            wp::adj_address(var_joint_axis, var_194, adj_joint_axis, adj_194, adj_195);
            wp::adj_add(var_153, var_193, adj_153, adj_193, adj_194);
            // adj: joint_axis[ia + 1],                                                       <L 224>
            wp::adj_address(var_joint_axis, var_191, adj_joint_axis, adj_191, adj_192);
            wp::adj_add(var_153, var_190, adj_153, adj_190, adj_191);
            // adj: joint_axis[ia + 0],                                                       <L 223>
            // adj: rot, _ = compute_3d_rotational_dofs(                                      <L 222>
        }
        // adj: if ang_axis_count == 3:                                                       <L 221>
        wp::adj_where(var_166, var_181, var_164, adj_166, adj_181, adj_164, adj_187);
        if (var_166) {
            adj_compute_2d_rotational_dofs_0(var_183, var_184, var_185, var_186, var_179, var_180, var_181, var_182, adj_169, adj_172, adj_175, adj_178, adj_179, adj_180, adj_181, adj_182);
            // adj: 0.0,                                                                      <L 219>
            // adj: 0.0,                                                                      <L 218>
            wp::adj_address(var_joint_q, var_177, adj_joint_q, adj_177, adj_178);
            wp::adj_add(var_154, var_176, adj_154, adj_176, adj_177);
            // adj: joint_q[iq + 1],                                                          <L 217>
            wp::adj_address(var_joint_q, var_174, adj_joint_q, adj_174, adj_175);
            wp::adj_add(var_154, var_173, adj_154, adj_173, adj_174);
            // adj: joint_q[iq + 0],                                                          <L 216>
            wp::adj_address(var_joint_axis, var_171, adj_joint_axis, adj_171, adj_172);
            wp::adj_add(var_153, var_170, adj_153, adj_170, adj_171);
            // adj: joint_axis[ia + 1],                                                       <L 215>
            wp::adj_address(var_joint_axis, var_168, adj_joint_axis, adj_168, adj_169);
            wp::adj_add(var_153, var_167, adj_153, adj_167, adj_168);
            // adj: joint_axis[ia + 0],                                                       <L 214>
            // adj: rot, _ = compute_2d_rotational_dofs(                                      <L 213>
        }
        // adj: if ang_axis_count == 2:                                                       <L 212>
        wp::adj_where(var_156, var_161, var_107, adj_156, adj_161, adj_107, adj_164);
        wp::adj_where(var_156, var_158, var_151, adj_156, adj_158, adj_151, adj_163);
        if (var_156) {
            wp::adj_quat_from_axis_angle(var_158, var_162, adj_158, adj_160, adj_161);
            wp::adj_address(var_joint_q, var_154, adj_joint_q, adj_154, adj_160);
            // adj: rot = wp.quat_from_axis_angle(axis, joint_q[iq])                          <L 211>
            wp::adj_copy(var_159, adj_157, adj_158);
            wp::adj_address(var_joint_axis, var_153, adj_joint_axis, adj_153, adj_157);
            // adj: axis = joint_axis[ia]                                                     <L 210>
        }
        // adj: if ang_axis_count == 1:                                                       <L 209>
        wp::adj_add(var_q_start, var_lin_axis_count, adj_q_start, adj_lin_axis_count, adj_154);
        // adj: iq = q_start + lin_axis_count                                                 <L 208>
        wp::adj_add(var_axis_start, var_lin_axis_count, adj_axis_start, adj_lin_axis_count, adj_153);
        // adj: ia = axis_start + lin_axis_count                                              <L 207>
        wp::adj_where(var_139, var_150, var_137, adj_139, adj_150, adj_137, adj_152);
        wp::adj_where(var_139, var_143, var_136, adj_139, adj_143, adj_136, adj_151);
        if (var_139) {
            wp::adj_add(var_137, var_148, adj_137, adj_148, adj_150);
            wp::adj_mul(var_143, var_149, adj_143, adj_147, adj_148);
            wp::adj_address(var_joint_q, var_146, adj_joint_q, adj_146, adj_147);
            wp::adj_add(var_q_start, var_145, adj_q_start, adj_145, adj_146);
            // adj: pos += axis * joint_q[q_start + 2]                                        <L 205>
            wp::adj_copy(var_144, adj_142, adj_143);
            wp::adj_address(var_joint_axis, var_141, adj_joint_axis, adj_141, adj_142);
            wp::adj_add(var_axis_start, var_140, adj_axis_start, adj_140, adj_141);
            // adj: axis = joint_axis[axis_start + 2]                                         <L 204>
        }
        // adj: if lin_axis_count > 2:                                                        <L 203>
        wp::adj_where(var_124, var_135, var_122, adj_124, adj_135, adj_122, adj_137);
        wp::adj_where(var_124, var_128, var_121, adj_124, adj_128, adj_121, adj_136);
        if (var_124) {
            wp::adj_add(var_122, var_133, adj_122, adj_133, adj_135);
            wp::adj_mul(var_128, var_134, adj_128, adj_132, adj_133);
            wp::adj_address(var_joint_q, var_131, adj_joint_q, adj_131, adj_132);
            wp::adj_add(var_q_start, var_130, adj_q_start, adj_130, adj_131);
            // adj: pos += axis * joint_q[q_start + 1]                                        <L 202>
            wp::adj_copy(var_129, adj_127, adj_128);
            wp::adj_address(var_joint_axis, var_126, adj_joint_axis, adj_126, adj_127);
            wp::adj_add(var_axis_start, var_125, adj_axis_start, adj_125, adj_126);
            // adj: axis = joint_axis[axis_start + 1]                                         <L 201>
        }
        // adj: if lin_axis_count > 1:                                                        <L 200>
        wp::adj_where(var_109, var_120, var_106, adj_109, adj_120, adj_106, adj_122);
        wp::adj_where(var_109, var_113, var_23, adj_109, adj_113, adj_23, adj_121);
        if (var_109) {
            wp::adj_add(var_106, var_118, adj_106, adj_118, adj_120);
            wp::adj_mul(var_113, var_119, adj_113, adj_117, adj_118);
            wp::adj_address(var_joint_q, var_116, adj_joint_q, adj_116, adj_117);
            wp::adj_add(var_q_start, var_115, adj_q_start, adj_115, adj_116);
            // adj: pos += axis * joint_q[q_start + 0]                                        <L 199>
            wp::adj_copy(var_114, adj_112, adj_113);
            wp::adj_address(var_joint_axis, var_111, adj_joint_axis, adj_111, adj_112);
            wp::adj_add(var_axis_start, var_110, adj_axis_start, adj_110, adj_111);
            // adj: axis = joint_axis[axis_start + 0]                                         <L 198>
        }
        // adj: if lin_axis_count > 0:                                                        <L 197>
        // adj: rot = wp.quat_identity()                                                      <L 192>
        wp::adj_vec_t(var_105, adj_105, adj_106);
        // adj: pos = wp.vec3(0.0)                                                            <L 191>
    }
    // adj: if type == JointType.D6:                                                          <L 190>
    wp::adj_where(var_55, var_93, var_45, adj_55, adj_93, adj_45, adj_102);
    wp::adj_where(var_55, var_88, var_40, adj_55, adj_88, adj_40, adj_101);
    wp::adj_where(var_55, var_83, var_35, adj_55, adj_83, adj_35, adj_100);
    wp::adj_where(var_55, var_78, var_30, adj_55, adj_78, adj_30, adj_99);
    wp::adj_where(var_55, var_97, var_54, adj_55, adj_97, adj_54, adj_98);
    if (var_55) {
        label4:;
        adj_97 += adj_ret;
        // adj: return X_jc                                                                   <L 188>
        wp::adj_transform_t(var_95, var_96, adj_95, adj_96, adj_97);
        wp::adj_quat_t(var_78, var_83, var_88, var_93, adj_78, adj_83, adj_88, adj_93, adj_96);
        wp::adj_vec_t(var_63, var_68, var_73, adj_63, adj_68, adj_73, adj_95);
        // adj: X_jc = wp.transform(wp.vec3(px, py, pz), wp.quat(qx, qy, qz, qw))             <L 187>
        wp::adj_copy(var_94, adj_92, adj_93);
        wp::adj_address(var_joint_q, var_91, adj_joint_q, adj_91, adj_92);
        wp::adj_add(var_q_start, var_90, adj_q_start, adj_90, adj_91);
        // adj: qw = joint_q[q_start + 6]                                                     <L 185>
        wp::adj_copy(var_89, adj_87, adj_88);
        wp::adj_address(var_joint_q, var_86, adj_joint_q, adj_86, adj_87);
        wp::adj_add(var_q_start, var_85, adj_q_start, adj_85, adj_86);
        // adj: qz = joint_q[q_start + 5]                                                     <L 184>
        wp::adj_copy(var_84, adj_82, adj_83);
        wp::adj_address(var_joint_q, var_81, adj_joint_q, adj_81, adj_82);
        wp::adj_add(var_q_start, var_80, adj_q_start, adj_80, adj_81);
        // adj: qy = joint_q[q_start + 4]                                                     <L 183>
        wp::adj_copy(var_79, adj_77, adj_78);
        wp::adj_address(var_joint_q, var_76, adj_joint_q, adj_76, adj_77);
        wp::adj_add(var_q_start, var_75, adj_q_start, adj_75, adj_76);
        // adj: qx = joint_q[q_start + 3]                                                     <L 182>
        wp::adj_copy(var_74, adj_72, adj_73);
        wp::adj_address(var_joint_q, var_71, adj_joint_q, adj_71, adj_72);
        wp::adj_add(var_q_start, var_70, adj_q_start, adj_70, adj_71);
        // adj: pz = joint_q[q_start + 2]                                                     <L 180>
        wp::adj_copy(var_69, adj_67, adj_68);
        wp::adj_address(var_joint_q, var_66, adj_joint_q, adj_66, adj_67);
        wp::adj_add(var_q_start, var_65, adj_q_start, adj_65, adj_66);
        // adj: py = joint_q[q_start + 1]                                                     <L 179>
        wp::adj_copy(var_64, adj_62, adj_63);
        wp::adj_address(var_joint_q, var_61, adj_joint_q, adj_61, adj_62);
        wp::adj_add(var_q_start, var_60, adj_q_start, adj_60, adj_61);
        // adj: px = joint_q[q_start + 0]                                                     <L 178>
    }
    if (!var_55) {
    }
    // adj: if type == JointType.FREE or type == JointType.DISTANCE:                          <L 177>
    wp::adj_where(var_52, var_53, var_50, adj_52, adj_53, adj_50, adj_54);
    if (var_52) {
        label3:;
        adj_53 += adj_ret;
        // adj: return X_jc                                                                   <L 175>
        // adj: X_jc = wp.transform_identity()                                                <L 174>
    }
    // adj: if type == JointType.FIXED:                                                       <L 173>
    wp::adj_where(var_26, var_49, var_24, adj_26, adj_49, adj_24, adj_50);
    if (var_26) {
        label2:;
        adj_49 += adj_ret;
        // adj: return X_jc                                                                   <L 171>
        wp::adj_transform_t(var_47, var_48, adj_47, adj_48, adj_49);
        wp::adj_quat_t(var_30, var_35, var_40, var_45, adj_30, adj_35, adj_40, adj_45, adj_48);
        // adj: X_jc = wp.transform(wp.vec3(), wp.quat(qx, qy, qz, qw))                       <L 170>
        wp::adj_copy(var_46, adj_44, adj_45);
        wp::adj_address(var_joint_q, var_43, adj_joint_q, adj_43, adj_44);
        wp::adj_add(var_q_start, var_42, adj_q_start, adj_42, adj_43);
        // adj: qw = joint_q[q_start + 3]                                                     <L 168>
        wp::adj_copy(var_41, adj_39, adj_40);
        wp::adj_address(var_joint_q, var_38, adj_joint_q, adj_38, adj_39);
        wp::adj_add(var_q_start, var_37, adj_q_start, adj_37, adj_38);
        // adj: qz = joint_q[q_start + 2]                                                     <L 167>
        wp::adj_copy(var_36, adj_34, adj_35);
        wp::adj_address(var_joint_q, var_33, adj_joint_q, adj_33, adj_34);
        wp::adj_add(var_q_start, var_32, adj_q_start, adj_32, adj_33);
        // adj: qy = joint_q[q_start + 1]                                                     <L 166>
        wp::adj_copy(var_31, adj_29, adj_30);
        wp::adj_address(var_joint_q, var_28, adj_joint_q, adj_28, adj_29);
        wp::adj_add(var_q_start, var_27, adj_q_start, adj_27, adj_28);
        // adj: qx = joint_q[q_start + 0]                                                     <L 165>
    }
    // adj: if type == JointType.BALL:                                                        <L 164>
    wp::adj_where(var_12, var_21, var_10, adj_12, adj_21, adj_10, adj_24);
    wp::adj_where(var_12, var_17, var_6, adj_12, adj_17, adj_6, adj_23);
    wp::adj_where(var_12, var_14, var_3, adj_12, adj_14, adj_3, adj_22);
    if (var_12) {
        label1:;
        adj_21 += adj_ret;
        // adj: return X_jc                                                                   <L 162>
        wp::adj_transform_t(var_19, var_20, adj_19, adj_20, adj_21);
        wp::adj_quat_from_axis_angle(var_17, var_14, adj_17, adj_14, adj_20);
        // adj: X_jc = wp.transform(wp.vec3(), wp.quat_from_axis_angle(axis, q))              <L 161>
        wp::adj_copy(var_18, adj_16, adj_17);
        wp::adj_address(var_joint_axis, var_axis_start, adj_joint_axis, adj_axis_start, adj_16);
        // adj: axis = joint_axis[axis_start]                                                 <L 160>
        wp::adj_copy(var_15, adj_13, adj_14);
        wp::adj_address(var_joint_q, var_q_start, adj_joint_q, adj_q_start, adj_13);
        // adj: q = joint_q[q_start]                                                          <L 159>
    }
    // adj: if type == JointType.REVOLUTE:                                                    <L 158>
    if (var_1) {
        label0:;
        adj_10 += adj_ret;
        // adj: return X_jc                                                                   <L 156>
        wp::adj_transform_t(var_8, var_9, adj_8, adj_9, adj_10);
        wp::adj_mul(var_6, var_3, adj_6, adj_3, adj_8);
        // adj: X_jc = wp.transform(axis * q, wp.quat_identity())                             <L 155>
        wp::adj_copy(var_7, adj_5, adj_6);
        wp::adj_address(var_joint_axis, var_axis_start, adj_joint_axis, adj_axis_start, adj_5);
        // adj: axis = joint_axis[axis_start]                                                 <L 154>
        wp::adj_copy(var_4, adj_2, adj_3);
        wp::adj_address(var_joint_q, var_q_start, adj_joint_q, adj_q_start, adj_2);
        // adj: q = joint_q[q_start]                                                          <L 153>
    }
    // adj: if type == JointType.PRISMATIC:                                                   <L 152>
    // adj: def jcalc_transform(                                                              <L 143>
    return;
}



extern "C" __global__ void IKOptimizerLM___build_specialized__locals___fk_local_717a4416_cuda_kernel_forward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::int32> var_joint_type,
    wp::array_t<wp::float32> var_joint_q,
    wp::array_t<wp::int32> var_joint_q_start,
    wp::array_t<wp::int32> var_joint_qd_start,
    wp::array_t<wp::vec_t<3, wp::float32>> var_joint_axis,
    wp::array_t<wp::int32> var_joint_dof_dim,
    wp::array_t<wp::transform_t<wp::float32>> var_joint_X_p,
    wp::array_t<wp::transform_t<wp::float32>> var_joint_X_c,
    wp::array_t<wp::transform_t<wp::float32>> var_X_local_out)
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
        const wp::int32 var_11 = 0;
        wp::int32* var_12;
        wp::int32 var_13;
        wp::int32 var_14;
        const wp::int32 var_15 = 1;
        wp::int32* var_16;
        wp::int32 var_17;
        wp::int32 var_18;
        wp::slice_t var_19;
        const wp::int32 var_20 = 0;
        wp::array_t<wp::float32> var_21;
        wp::transform_t<wp::float32> var_22;
        wp::transform_t<wp::float32>* var_23;
        wp::transform_t<wp::float32> var_24;
        wp::transform_t<wp::float32> var_25;
        wp::transform_t<wp::float32>* var_26;
        wp::transform_t<wp::float32> var_27;
        wp::transform_t<wp::float32> var_28;
        wp::transform_t<wp::float32> var_29;
        //---------
        // forward
        // def _fk_local(                                                                         <L 933>
        // row, local_joint_idx = wp.tid()                                                        <L 945>
        builtin_tid2d(var_0, var_1);
        // t = joint_type[local_joint_idx]                                                        <L 947>
        var_2 = wp::address(var_joint_type, var_1);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // q_start = joint_q_start[local_joint_idx]                                               <L 948>
        var_5 = wp::address(var_joint_q_start, var_1);
        var_7 = wp::load(var_5);
        var_6 = wp::copy(var_7);
        // axis_start = joint_qd_start[local_joint_idx]                                           <L 949>
        var_8 = wp::address(var_joint_qd_start, var_1);
        var_10 = wp::load(var_8);
        var_9 = wp::copy(var_10);
        // lin_axes = joint_dof_dim[local_joint_idx, 0]                                           <L 950>
        var_12 = wp::address(var_joint_dof_dim, var_1, var_11);
        var_14 = wp::load(var_12);
        var_13 = wp::copy(var_14);
        // ang_axes = joint_dof_dim[local_joint_idx, 1]                                           <L 951>
        var_16 = wp::address(var_joint_dof_dim, var_1, var_15);
        var_18 = wp::load(var_16);
        var_17 = wp::copy(var_18);
        // X_j = jcalc_transform(                                                                 <L 953>
        // t,                                                                                     <L 954>
        // joint_axis,                                                                            <L 955>
        // axis_start,                                                                            <L 956>
        // lin_axes,                                                                              <L 957>
        // ang_axes,                                                                              <L 958>
        // joint_q[row],  # 1-D row slice                                                         <L 959>
        var_19 = wp::slice_t(var_0, var_0, var_20);
        var_21 = wp::view(var_joint_q, var_19);
        // q_start,                                                                               <L 960>
        var_22 = jcalc_transform_0(var_3, var_joint_axis, var_9, var_13, var_17, var_21, var_6);
        // X_rel = joint_X_p[local_joint_idx] * X_j * wp.transform_inverse(joint_X_c[local_joint_idx])       <L 963>
        var_23 = wp::address(var_joint_X_p, var_1);
        var_25 = wp::load(var_23);
        var_24 = wp::mul(var_25, var_22);
        var_26 = wp::address(var_joint_X_c, var_1);
        var_28 = wp::load(var_26);
        var_27 = wp::transform_inverse(var_28);
        var_29 = wp::mul(var_24, var_27);
        // X_local_out[row, local_joint_idx] = X_rel                                              <L 964>
        wp::array_store(var_X_local_out, var_0, var_1, var_29);
    }
}



extern "C" __global__ void IKOptimizerLM___build_specialized__locals___fk_local_717a4416_cuda_kernel_backward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::int32> var_joint_type,
    wp::array_t<wp::float32> var_joint_q,
    wp::array_t<wp::int32> var_joint_q_start,
    wp::array_t<wp::int32> var_joint_qd_start,
    wp::array_t<wp::vec_t<3, wp::float32>> var_joint_axis,
    wp::array_t<wp::int32> var_joint_dof_dim,
    wp::array_t<wp::transform_t<wp::float32>> var_joint_X_p,
    wp::array_t<wp::transform_t<wp::float32>> var_joint_X_c,
    wp::array_t<wp::transform_t<wp::float32>> var_X_local_out,
    wp::array_t<wp::int32> adj_joint_type,
    wp::array_t<wp::float32> adj_joint_q,
    wp::array_t<wp::int32> adj_joint_q_start,
    wp::array_t<wp::int32> adj_joint_qd_start,
    wp::array_t<wp::vec_t<3, wp::float32>> adj_joint_axis,
    wp::array_t<wp::int32> adj_joint_dof_dim,
    wp::array_t<wp::transform_t<wp::float32>> adj_joint_X_p,
    wp::array_t<wp::transform_t<wp::float32>> adj_joint_X_c,
    wp::array_t<wp::transform_t<wp::float32>> adj_X_local_out)
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
        const wp::int32 var_11 = 0;
        wp::int32* var_12;
        wp::int32 var_13;
        wp::int32 var_14;
        const wp::int32 var_15 = 1;
        wp::int32* var_16;
        wp::int32 var_17;
        wp::int32 var_18;
        wp::slice_t var_19;
        const wp::int32 var_20 = 0;
        wp::array_t<wp::float32> var_21;
        wp::transform_t<wp::float32> var_22;
        wp::transform_t<wp::float32>* var_23;
        wp::transform_t<wp::float32> var_24;
        wp::transform_t<wp::float32> var_25;
        wp::transform_t<wp::float32>* var_26;
        wp::transform_t<wp::float32> var_27;
        wp::transform_t<wp::float32> var_28;
        wp::transform_t<wp::float32> var_29;
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
        wp::slice_t adj_19 = {};
        wp::int32 adj_20 = {};
        wp::array_t<wp::float32> adj_21 = {};
        wp::transform_t<wp::float32> adj_22 = {};
        wp::transform_t<wp::float32> adj_23 = {};
        wp::transform_t<wp::float32> adj_24 = {};
        wp::transform_t<wp::float32> adj_25 = {};
        wp::transform_t<wp::float32> adj_26 = {};
        wp::transform_t<wp::float32> adj_27 = {};
        wp::transform_t<wp::float32> adj_28 = {};
        wp::transform_t<wp::float32> adj_29 = {};
        //---------
        // forward
        // def _fk_local(                                                                         <L 933>
        // row, local_joint_idx = wp.tid()                                                        <L 945>
        builtin_tid2d(var_0, var_1);
        // t = joint_type[local_joint_idx]                                                        <L 947>
        var_2 = wp::address(var_joint_type, var_1);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // q_start = joint_q_start[local_joint_idx]                                               <L 948>
        var_5 = wp::address(var_joint_q_start, var_1);
        var_7 = wp::load(var_5);
        var_6 = wp::copy(var_7);
        // axis_start = joint_qd_start[local_joint_idx]                                           <L 949>
        var_8 = wp::address(var_joint_qd_start, var_1);
        var_10 = wp::load(var_8);
        var_9 = wp::copy(var_10);
        // lin_axes = joint_dof_dim[local_joint_idx, 0]                                           <L 950>
        var_12 = wp::address(var_joint_dof_dim, var_1, var_11);
        var_14 = wp::load(var_12);
        var_13 = wp::copy(var_14);
        // ang_axes = joint_dof_dim[local_joint_idx, 1]                                           <L 951>
        var_16 = wp::address(var_joint_dof_dim, var_1, var_15);
        var_18 = wp::load(var_16);
        var_17 = wp::copy(var_18);
        // X_j = jcalc_transform(                                                                 <L 953>
        // t,                                                                                     <L 954>
        // joint_axis,                                                                            <L 955>
        // axis_start,                                                                            <L 956>
        // lin_axes,                                                                              <L 957>
        // ang_axes,                                                                              <L 958>
        // joint_q[row],  # 1-D row slice                                                         <L 959>
        var_19 = wp::slice_t(var_0, var_0, var_20);
        var_21 = wp::view(var_joint_q, var_19);
        // q_start,                                                                               <L 960>
        var_22 = jcalc_transform_0(var_3, var_joint_axis, var_9, var_13, var_17, var_21, var_6);
        // X_rel = joint_X_p[local_joint_idx] * X_j * wp.transform_inverse(joint_X_c[local_joint_idx])       <L 963>
        var_23 = wp::address(var_joint_X_p, var_1);
        var_25 = wp::load(var_23);
        var_24 = wp::mul(var_25, var_22);
        var_26 = wp::address(var_joint_X_c, var_1);
        var_28 = wp::load(var_26);
        var_27 = wp::transform_inverse(var_28);
        var_29 = wp::mul(var_24, var_27);
        // X_local_out[row, local_joint_idx] = X_rel                                              <L 964>
        // wp::array_store(var_X_local_out, var_0, var_1, var_29);
        //---------
        // reverse
        wp::adj_array_store(var_X_local_out, var_0, var_1, var_29, adj_X_local_out, adj_0, adj_1, adj_29);
        // adj: X_local_out[row, local_joint_idx] = X_rel                                         <L 964>
        wp::adj_mul(var_24, var_27, adj_24, adj_27, adj_29);
        wp::adj_transform_inverse(var_28, adj_26, adj_27);
        wp::adj_address(var_joint_X_c, var_1, adj_joint_X_c, adj_1, adj_26);
        wp::adj_mul(var_25, var_22, adj_23, adj_22, adj_24);
        wp::adj_address(var_joint_X_p, var_1, adj_joint_X_p, adj_1, adj_23);
        // adj: X_rel = joint_X_p[local_joint_idx] * X_j * wp.transform_inverse(joint_X_c[local_joint_idx])  <L 963>
        adj_jcalc_transform_0(var_3, var_joint_axis, var_9, var_13, var_17, var_21, var_6, adj_3, adj_joint_axis, adj_9, adj_13, adj_17, adj_21, adj_6, adj_22);
        // adj: q_start,                                                                          <L 960>
        wp::adj_view(var_joint_q, var_19, adj_joint_q, adj_19, adj_21);
        // adj: joint_q[row],  # 1-D row slice                                                    <L 959>
        // adj: ang_axes,                                                                         <L 958>
        // adj: lin_axes,                                                                         <L 957>
        // adj: axis_start,                                                                       <L 956>
        // adj: joint_axis,                                                                       <L 955>
        // adj: t,                                                                                <L 954>
        // adj: X_j = jcalc_transform(                                                            <L 953>
        wp::adj_copy(var_18, adj_16, adj_17);
        wp::adj_address(var_joint_dof_dim, var_1, var_15, adj_joint_dof_dim, adj_1, adj_15, adj_16);
        // adj: ang_axes = joint_dof_dim[local_joint_idx, 1]                                      <L 951>
        wp::adj_copy(var_14, adj_12, adj_13);
        wp::adj_address(var_joint_dof_dim, var_1, var_11, adj_joint_dof_dim, adj_1, adj_11, adj_12);
        // adj: lin_axes = joint_dof_dim[local_joint_idx, 0]                                      <L 950>
        wp::adj_copy(var_10, adj_8, adj_9);
        wp::adj_address(var_joint_qd_start, var_1, adj_joint_qd_start, adj_1, adj_8);
        // adj: axis_start = joint_qd_start[local_joint_idx]                                      <L 949>
        wp::adj_copy(var_7, adj_5, adj_6);
        wp::adj_address(var_joint_q_start, var_1, adj_joint_q_start, adj_1, adj_5);
        // adj: q_start = joint_q_start[local_joint_idx]                                          <L 948>
        wp::adj_copy(var_4, adj_2, adj_3);
        wp::adj_address(var_joint_type, var_1, adj_joint_type, adj_1, adj_2);
        // adj: t = joint_type[local_joint_idx]                                                   <L 947>
        // adj: row, local_joint_idx = wp.tid()                                                   <L 945>
        // adj: def _fk_local(                                                                    <L 933>
        continue;
    }
}

