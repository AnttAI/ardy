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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/sim/articulation.py:36
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/sim/articulation.py:61
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/sim/articulation.py:127
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/sim/articulation.py:151
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/warp/_src/math.py:131
static CUDA_CALLABLE wp::vec_t<3, wp::float32> velocity_at_point_0(
    wp::vec_t<6, wp::float32> var_qd,
    wp::vec_t<3, wp::float32> var_r)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    //---------
    // forward
    // def velocity_at_point(qd: wp.spatial_vector, r: wp.vec3) -> wp.vec3:                   <L 132>
    // return wp.spatial_bottom(qd) + wp.cross(wp.spatial_top(qd), r)                         <L 148>
    var_0 = wp::spatial_bottom(var_qd);
    var_1 = wp::spatial_top(var_qd);
    var_2 = wp::cross(var_1, var_r);
    var_3 = wp::add(var_0, var_2);
    return var_3;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/math/spatial.py:53
static CUDA_CALLABLE wp::vec_t<3, wp::float32> velocity_at_point_1(
    wp::vec_t<6, wp::float32> var_qd,
    wp::vec_t<3, wp::float32> var_r)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<6, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    //---------
    // forward
    // def velocity_at_point(qd: wp.spatial_vector, r: wp.vec3) -> wp.vec3:                   <L 54>
    // qd_wp = wp.spatial_vector(wp.spatial_bottom(qd), wp.spatial_top(qd))                   <L 77>
    var_0 = wp::spatial_bottom(var_qd);
    var_1 = wp::spatial_top(var_qd);
    var_2 = wp::vec_t<6, wp::float32>(var_0, var_1);
    // return wp.velocity_at_point(qd_wp, r)                                                  <L 78>
    var_3 = velocity_at_point_0(var_2, var_r);
    return var_3;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/sim/articulation.py:14
static CUDA_CALLABLE wp::vec_t<3, wp::float32> com_twist_to_point_velocity_0(
    wp::vec_t<6, wp::float32> var_qd,
    wp::transform_t<wp::float32> var_X_wb,
    wp::vec_t<3, wp::float32> var_body_com,
    wp::vec_t<3, wp::float32> var_point)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    //---------
    // forward
    // def com_twist_to_point_velocity(qd: wp.spatial_vector, X_wb: wp.transform, body_com: wp.vec3, point: wp.vec3):       <L 15>
    // return velocity_at_point(qd, point - wp.transform_point(X_wb, body_com))               <L 17>
    var_0 = wp::transform_point(var_X_wb, var_body_com);
    var_1 = wp::sub(var_point, var_0);
    var_2 = velocity_at_point_1(var_qd, var_1);
    return var_2;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/sim/articulation.py:28
static CUDA_CALLABLE wp::vec_t<6, wp::float32> com_twist_to_origin_twist_0(
    wp::vec_t<6, wp::float32> var_qd,
    wp::transform_t<wp::float32> var_X_wb,
    wp::vec_t<3, wp::float32> var_body_com)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    wp::vec_t<3, wp::float32> var_4;
    wp::vec_t<6, wp::float32> var_5;
    //---------
    // forward
    // def com_twist_to_origin_twist(qd: wp.spatial_vector, X_wb: wp.transform, body_com: wp.vec3):       <L 29>
    // omega = wp.spatial_bottom(qd)                                                          <L 31>
    var_0 = wp::spatial_bottom(var_qd);
    // v_origin = wp.spatial_top(qd) - wp.cross(omega, wp.transform_vector(X_wb, body_com))       <L 32>
    var_1 = wp::spatial_top(var_qd);
    var_2 = wp::transform_vector(var_X_wb, var_body_com);
    var_3 = wp::cross(var_0, var_2);
    var_4 = wp::sub(var_1, var_3);
    // return wp.spatial_vector(v_origin, omega)                                              <L 33>
    var_5 = wp::vec_t<6, wp::float32>(var_4, var_0);
    return var_5;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/sim/articulation.py:20
static CUDA_CALLABLE wp::vec_t<6, wp::float32> origin_twist_to_com_twist_0(
    wp::vec_t<6, wp::float32> var_qd,
    wp::transform_t<wp::float32> var_X_wb,
    wp::vec_t<3, wp::float32> var_body_com)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::vec_t<6, wp::float32> var_3;
    //---------
    // forward
    // def origin_twist_to_com_twist(qd: wp.spatial_vector, X_wb: wp.transform, body_com: wp.vec3):       <L 21>
    // omega = wp.spatial_bottom(qd)                                                          <L 23>
    var_0 = wp::spatial_bottom(var_qd);
    // v_com = velocity_at_point(qd, wp.transform_vector(X_wb, body_com))                     <L 24>
    var_1 = wp::transform_vector(var_X_wb, var_body_com);
    var_2 = velocity_at_point_1(var_qd, var_1);
    // return wp.spatial_vector(v_com, omega)                                                 <L 25>
    var_3 = wp::vec_t<6, wp::float32>(var_2, var_0);
    return var_3;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/sim/articulation.py:236
static CUDA_CALLABLE void eval_single_articulation_fk_0(
    wp::int32 var_joint_start,
    wp::int32 var_joint_end,
    wp::array_t<wp::int32> var_joint_articulation,
    wp::array_t<wp::float32> var_joint_q,
    wp::array_t<wp::float32> var_joint_qd,
    wp::array_t<wp::int32> var_joint_q_start,
    wp::array_t<wp::int32> var_joint_qd_start,
    wp::array_t<wp::int32> var_joint_type,
    wp::array_t<wp::int32> var_joint_parent,
    wp::array_t<wp::int32> var_joint_child,
    wp::array_t<wp::transform_t<wp::float32>> var_joint_X_p,
    wp::array_t<wp::transform_t<wp::float32>> var_joint_X_c,
    wp::array_t<wp::vec_t<3, wp::float32>> var_joint_axis,
    wp::array_t<wp::int32> var_joint_dof_dim,
    wp::array_t<wp::vec_t<3, wp::float32>> var_body_com,
    wp::array_t<wp::int32> var_body_flags,
    wp::int32 var_body_flag_filter,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::vec_t<6, wp::float32>> var_body_qd)
{
    //---------
    // primal vars
    wp::range_t var_0;
    wp::int32 var_1;
    wp::int32* var_2;
    wp::int32 var_3;
    wp::int32 var_4;
    const wp::int32 var_5 = -1;
    bool var_6;
    wp::int32* var_7;
    wp::int32 var_8;
    wp::int32 var_9;
    wp::int32* var_10;
    wp::int32 var_11;
    wp::int32 var_12;
    wp::int32* var_13;
    wp::int32 var_14;
    wp::int32 var_15;
    const wp::int32 var_16 = 7;
    bool var_17;
    wp::transform_t<wp::float32>* var_18;
    wp::transform_t<wp::float32> var_19;
    wp::transform_t<wp::float32> var_20;
    wp::transform_t<wp::float32>* var_21;
    wp::transform_t<wp::float32> var_22;
    wp::transform_t<wp::float32> var_23;
    wp::int32* var_24;
    wp::int32 var_25;
    wp::int32 var_26;
    wp::int32* var_27;
    wp::int32 var_28;
    wp::int32 var_29;
    const wp::int32 var_30 = 0;
    wp::int32* var_31;
    wp::int32 var_32;
    wp::int32 var_33;
    const wp::int32 var_34 = 1;
    wp::int32* var_35;
    wp::int32 var_36;
    wp::int32 var_37;
    wp::transform_t<wp::float32> var_38;
    wp::vec_t<3, wp::float32> var_39;
    wp::vec_t<3, wp::float32> var_40;
    wp::vec_t<6, wp::float32> var_41;
    const wp::int32 var_42 = 0;
    bool var_43;
    wp::vec_t<3, wp::float32>* var_44;
    wp::vec_t<3, wp::float32> var_45;
    wp::vec_t<3, wp::float32> var_46;
    wp::float32* var_47;
    wp::float32 var_48;
    wp::float32 var_49;
    wp::float32* var_50;
    wp::float32 var_51;
    wp::float32 var_52;
    wp::vec_t<3, wp::float32> var_53;
    wp::quat_t<wp::float32> var_54;
    wp::transform_t<wp::float32> var_55;
    wp::vec_t<3, wp::float32> var_56;
    wp::vec_t<3, wp::float32> var_57;
    wp::vec_t<6, wp::float32> var_58;
    wp::transform_t<wp::float32> var_59;
    wp::vec_t<6, wp::float32> var_60;
    const wp::int32 var_61 = 1;
    bool var_62;
    wp::vec_t<3, wp::float32>* var_63;
    wp::vec_t<3, wp::float32> var_64;
    wp::vec_t<3, wp::float32> var_65;
    wp::float32* var_66;
    wp::float32 var_67;
    wp::float32 var_68;
    wp::float32* var_69;
    wp::float32 var_70;
    wp::float32 var_71;
    wp::vec_t<3, wp::float32> var_72;
    wp::quat_t<wp::float32> var_73;
    wp::transform_t<wp::float32> var_74;
    wp::vec_t<3, wp::float32> var_75;
    wp::vec_t<3, wp::float32> var_76;
    wp::vec_t<6, wp::float32> var_77;
    wp::transform_t<wp::float32> var_78;
    wp::vec_t<6, wp::float32> var_79;
    wp::vec_t<3, wp::float32> var_80;
    wp::float32 var_81;
    wp::float32 var_82;
    const wp::int32 var_83 = 2;
    bool var_84;
    const wp::int32 var_85 = 0;
    wp::int32 var_86;
    wp::float32* var_87;
    const wp::int32 var_88 = 1;
    wp::int32 var_89;
    wp::float32* var_90;
    const wp::int32 var_91 = 2;
    wp::int32 var_92;
    wp::float32* var_93;
    const wp::int32 var_94 = 3;
    wp::int32 var_95;
    wp::float32* var_96;
    wp::quat_t<wp::float32> var_97;
    wp::float32 var_98;
    wp::float32 var_99;
    wp::float32 var_100;
    wp::float32 var_101;
    const wp::int32 var_102 = 0;
    wp::int32 var_103;
    wp::float32* var_104;
    const wp::int32 var_105 = 1;
    wp::int32 var_106;
    wp::float32* var_107;
    const wp::int32 var_108 = 2;
    wp::int32 var_109;
    wp::float32* var_110;
    wp::vec_t<3, wp::float32> var_111;
    wp::float32 var_112;
    wp::float32 var_113;
    wp::float32 var_114;
    wp::vec_t<3, wp::float32> var_115;
    wp::transform_t<wp::float32> var_116;
    wp::vec_t<3, wp::float32> var_117;
    wp::vec_t<6, wp::float32> var_118;
    wp::transform_t<wp::float32> var_119;
    wp::vec_t<6, wp::float32> var_120;
    bool var_121;
    const wp::int32 var_122 = 4;
    bool var_123;
    const wp::int32 var_124 = 5;
    bool var_125;
    const wp::int32 var_126 = 0;
    wp::int32 var_127;
    wp::float32* var_128;
    const wp::int32 var_129 = 1;
    wp::int32 var_130;
    wp::float32* var_131;
    const wp::int32 var_132 = 2;
    wp::int32 var_133;
    wp::float32* var_134;
    wp::vec_t<3, wp::float32> var_135;
    wp::float32 var_136;
    wp::float32 var_137;
    wp::float32 var_138;
    const wp::int32 var_139 = 3;
    wp::int32 var_140;
    wp::float32* var_141;
    const wp::int32 var_142 = 4;
    wp::int32 var_143;
    wp::float32* var_144;
    const wp::int32 var_145 = 5;
    wp::int32 var_146;
    wp::float32* var_147;
    const wp::int32 var_148 = 6;
    wp::int32 var_149;
    wp::float32* var_150;
    wp::quat_t<wp::float32> var_151;
    wp::float32 var_152;
    wp::float32 var_153;
    wp::float32 var_154;
    wp::float32 var_155;
    wp::transform_t<wp::float32> var_156;
    const wp::int32 var_157 = 0;
    wp::int32 var_158;
    wp::float32* var_159;
    const wp::int32 var_160 = 1;
    wp::int32 var_161;
    wp::float32* var_162;
    const wp::int32 var_163 = 2;
    wp::int32 var_164;
    wp::float32* var_165;
    wp::vec_t<3, wp::float32> var_166;
    wp::float32 var_167;
    wp::float32 var_168;
    wp::float32 var_169;
    const wp::int32 var_170 = 3;
    wp::int32 var_171;
    wp::float32* var_172;
    const wp::int32 var_173 = 4;
    wp::int32 var_174;
    wp::float32* var_175;
    const wp::int32 var_176 = 5;
    wp::int32 var_177;
    wp::float32* var_178;
    wp::vec_t<3, wp::float32> var_179;
    wp::float32 var_180;
    wp::float32 var_181;
    wp::float32 var_182;
    wp::vec_t<6, wp::float32> var_183;
    wp::transform_t<wp::float32> var_184;
    wp::vec_t<6, wp::float32> var_185;
    wp::transform_t<wp::float32> var_186;
    wp::vec_t<6, wp::float32> var_187;
    const wp::int32 var_188 = 6;
    bool var_189;
    const wp::float32 var_190 = 0.0;
    wp::vec_t<3, wp::float32> var_191;
    wp::quat_t<wp::float32> var_192;
    const wp::float32 var_193 = 0.0;
    wp::vec_t<3, wp::float32> var_194;
    const wp::float32 var_195 = 0.0;
    wp::vec_t<3, wp::float32> var_196;
    const wp::int32 var_197 = 0;
    bool var_198;
    const wp::int32 var_199 = 0;
    wp::int32 var_200;
    wp::vec_t<3, wp::float32>* var_201;
    wp::vec_t<3, wp::float32> var_202;
    wp::vec_t<3, wp::float32> var_203;
    const wp::int32 var_204 = 0;
    wp::int32 var_205;
    wp::float32* var_206;
    wp::vec_t<3, wp::float32> var_207;
    wp::float32 var_208;
    wp::vec_t<3, wp::float32> var_209;
    const wp::int32 var_210 = 0;
    wp::int32 var_211;
    wp::float32* var_212;
    wp::vec_t<3, wp::float32> var_213;
    wp::float32 var_214;
    wp::vec_t<3, wp::float32> var_215;
    wp::vec_t<3, wp::float32> var_216;
    wp::vec_t<3, wp::float32> var_217;
    wp::vec_t<3, wp::float32> var_218;
    const wp::int32 var_219 = 1;
    bool var_220;
    const wp::int32 var_221 = 1;
    wp::int32 var_222;
    wp::vec_t<3, wp::float32>* var_223;
    wp::vec_t<3, wp::float32> var_224;
    wp::vec_t<3, wp::float32> var_225;
    const wp::int32 var_226 = 1;
    wp::int32 var_227;
    wp::float32* var_228;
    wp::vec_t<3, wp::float32> var_229;
    wp::float32 var_230;
    wp::vec_t<3, wp::float32> var_231;
    const wp::int32 var_232 = 1;
    wp::int32 var_233;
    wp::float32* var_234;
    wp::vec_t<3, wp::float32> var_235;
    wp::float32 var_236;
    wp::vec_t<3, wp::float32> var_237;
    wp::vec_t<3, wp::float32> var_238;
    wp::vec_t<3, wp::float32> var_239;
    wp::vec_t<3, wp::float32> var_240;
    const wp::int32 var_241 = 2;
    bool var_242;
    const wp::int32 var_243 = 2;
    wp::int32 var_244;
    wp::vec_t<3, wp::float32>* var_245;
    wp::vec_t<3, wp::float32> var_246;
    wp::vec_t<3, wp::float32> var_247;
    const wp::int32 var_248 = 2;
    wp::int32 var_249;
    wp::float32* var_250;
    wp::vec_t<3, wp::float32> var_251;
    wp::float32 var_252;
    wp::vec_t<3, wp::float32> var_253;
    const wp::int32 var_254 = 2;
    wp::int32 var_255;
    wp::float32* var_256;
    wp::vec_t<3, wp::float32> var_257;
    wp::float32 var_258;
    wp::vec_t<3, wp::float32> var_259;
    wp::vec_t<3, wp::float32> var_260;
    wp::vec_t<3, wp::float32> var_261;
    wp::vec_t<3, wp::float32> var_262;
    wp::int32 var_263;
    wp::int32 var_264;
    const wp::int32 var_265 = 1;
    bool var_266;
    wp::vec_t<3, wp::float32>* var_267;
    wp::vec_t<3, wp::float32> var_268;
    wp::vec_t<3, wp::float32> var_269;
    wp::float32* var_270;
    wp::quat_t<wp::float32> var_271;
    wp::float32 var_272;
    wp::float32* var_273;
    wp::vec_t<3, wp::float32> var_274;
    wp::float32 var_275;
    wp::vec_t<3, wp::float32> var_276;
    wp::quat_t<wp::float32> var_277;
    wp::vec_t<3, wp::float32> var_278;
    const wp::int32 var_279 = 2;
    bool var_280;
    const wp::int32 var_281 = 0;
    wp::int32 var_282;
    wp::vec_t<3, wp::float32>* var_283;
    const wp::int32 var_284 = 1;
    wp::int32 var_285;
    wp::vec_t<3, wp::float32>* var_286;
    const wp::int32 var_287 = 0;
    wp::int32 var_288;
    wp::float32* var_289;
    const wp::int32 var_290 = 1;
    wp::int32 var_291;
    wp::float32* var_292;
    const wp::int32 var_293 = 0;
    wp::int32 var_294;
    wp::float32* var_295;
    const wp::int32 var_296 = 1;
    wp::int32 var_297;
    wp::float32* var_298;
    wp::quat_t<wp::float32> var_299;
    wp::vec_t<3, wp::float32> var_300;
    wp::vec_t<3, wp::float32> var_301;
    wp::vec_t<3, wp::float32> var_302;
    wp::float32 var_303;
    wp::float32 var_304;
    wp::float32 var_305;
    wp::float32 var_306;
    wp::quat_t<wp::float32> var_307;
    wp::vec_t<3, wp::float32> var_308;
    const wp::int32 var_309 = 3;
    bool var_310;
    const wp::int32 var_311 = 0;
    wp::int32 var_312;
    wp::vec_t<3, wp::float32>* var_313;
    const wp::int32 var_314 = 1;
    wp::int32 var_315;
    wp::vec_t<3, wp::float32>* var_316;
    const wp::int32 var_317 = 2;
    wp::int32 var_318;
    wp::vec_t<3, wp::float32>* var_319;
    const wp::int32 var_320 = 0;
    wp::int32 var_321;
    wp::float32* var_322;
    const wp::int32 var_323 = 1;
    wp::int32 var_324;
    wp::float32* var_325;
    const wp::int32 var_326 = 2;
    wp::int32 var_327;
    wp::float32* var_328;
    const wp::int32 var_329 = 0;
    wp::int32 var_330;
    wp::float32* var_331;
    const wp::int32 var_332 = 1;
    wp::int32 var_333;
    wp::float32* var_334;
    const wp::int32 var_335 = 2;
    wp::int32 var_336;
    wp::float32* var_337;
    wp::quat_t<wp::float32> var_338;
    wp::vec_t<3, wp::float32> var_339;
    wp::vec_t<3, wp::float32> var_340;
    wp::vec_t<3, wp::float32> var_341;
    wp::vec_t<3, wp::float32> var_342;
    wp::float32 var_343;
    wp::float32 var_344;
    wp::float32 var_345;
    wp::float32 var_346;
    wp::float32 var_347;
    wp::float32 var_348;
    wp::quat_t<wp::float32> var_349;
    wp::vec_t<3, wp::float32> var_350;
    wp::transform_t<wp::float32> var_351;
    wp::vec_t<6, wp::float32> var_352;
    wp::transform_t<wp::float32> var_353;
    wp::vec_t<6, wp::float32> var_354;
    wp::vec_t<3, wp::float32> var_355;
    wp::transform_t<wp::float32> var_356;
    const wp::int32 var_357 = 0;
    bool var_358;
    wp::transform_t<wp::float32>* var_359;
    wp::transform_t<wp::float32> var_360;
    wp::transform_t<wp::float32> var_361;
    wp::transform_t<wp::float32> var_362;
    wp::transform_t<wp::float32> var_363;
    wp::transform_t<wp::float32> var_364;
    wp::transform_t<wp::float32> var_365;
    wp::transform_t<wp::float32> var_366;
    wp::vec_t<3, wp::float32> var_367;
    wp::vec_t<3, wp::float32> var_368;
    wp::vec_t<3, wp::float32> var_369;
    const wp::int32 var_370 = 0;
    bool var_371;
    wp::vec_t<6, wp::float32>* var_372;
    wp::vec_t<6, wp::float32> var_373;
    wp::vec_t<6, wp::float32> var_374;
    wp::vec_t<3, wp::float32> var_375;
    wp::vec_t<3, wp::float32>* var_376;
    wp::vec_t<3, wp::float32> var_377;
    wp::vec_t<3, wp::float32> var_378;
    wp::vec_t<3, wp::float32> var_379;
    wp::vec_t<3, wp::float32> var_380;
    wp::vec_t<3, wp::float32> var_381;
    wp::vec_t<3, wp::float32> var_382;
    wp::vec_t<3, wp::float32> var_383;
    wp::vec_t<3, wp::float32> var_384;
    bool var_385;
    const wp::int32 var_386 = 4;
    bool var_387;
    const wp::int32 var_388 = 5;
    bool var_389;
    wp::vec_t<6, wp::float32> var_390;
    wp::vec_t<3, wp::float32>* var_391;
    wp::vec_t<6, wp::float32> var_392;
    wp::vec_t<3, wp::float32> var_393;
    wp::vec_t<3, wp::float32> var_394;
    wp::vec_t<3, wp::float32> var_395;
    wp::vec_t<3, wp::float32> var_396;
    wp::vec_t<3, wp::float32> var_397;
    wp::vec_t<3, wp::float32> var_398;
    wp::vec_t<3, wp::float32> var_399;
    wp::vec_t<3, wp::float32> var_400;
    wp::vec_t<3, wp::float32> var_401;
    wp::vec_t<6, wp::float32> var_402;
    wp::int32* var_403;
    wp::int32 var_404;
    wp::int32 var_405;
    const wp::int32 var_406 = 0;
    bool var_407;
    wp::vec_t<3, wp::float32>* var_408;
    wp::vec_t<6, wp::float32> var_409;
    wp::vec_t<3, wp::float32> var_410;
    //---------
    // forward
    // def eval_single_articulation_fk(                                                       <L 237>
    // for i in range(joint_start, joint_end):                                                <L 259>
    var_0 = wp::range(var_joint_start, var_joint_end);
    start_for_0:;
        if (iter_cmp(var_0) == 0) goto end_for_0;
        var_1 = wp::iter_next(var_0);
        // articulation = joint_articulation[i]                                               <L 260>
        var_2 = wp::address(var_joint_articulation, var_1);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // if articulation == -1:                                                             <L 261>
        var_6 = (var_3 == var_5);
        if (var_6) {
            // continue                                                                       <L 262>
            goto start_for_0;
        }
        // parent = joint_parent[i]                                                           <L 264>
        var_7 = wp::address(var_joint_parent, var_1);
        var_9 = wp::load(var_7);
        var_8 = wp::copy(var_9);
        // child = joint_child[i]                                                             <L 265>
        var_10 = wp::address(var_joint_child, var_1);
        var_12 = wp::load(var_10);
        var_11 = wp::copy(var_12);
        // type = joint_type[i]                                                               <L 268>
        var_13 = wp::address(var_joint_type, var_1);
        var_15 = wp::load(var_13);
        var_14 = wp::copy(var_15);
        // if type == JointType.CABLE:                                                        <L 269>
        var_17 = (var_14 == var_16);
        if (var_17) {
            // continue                                                                       <L 271>
            goto start_for_0;
        }
        // X_pj = joint_X_p[i]                                                                <L 273>
        var_18 = wp::address(var_joint_X_p, var_1);
        var_20 = wp::load(var_18);
        var_19 = wp::copy(var_20);
        // X_cj = joint_X_c[i]                                                                <L 274>
        var_21 = wp::address(var_joint_X_c, var_1);
        var_23 = wp::load(var_21);
        var_22 = wp::copy(var_23);
        // q_start = joint_q_start[i]                                                         <L 276>
        var_24 = wp::address(var_joint_q_start, var_1);
        var_26 = wp::load(var_24);
        var_25 = wp::copy(var_26);
        // qd_start = joint_qd_start[i]                                                       <L 277>
        var_27 = wp::address(var_joint_qd_start, var_1);
        var_29 = wp::load(var_27);
        var_28 = wp::copy(var_29);
        // lin_axis_count = joint_dof_dim[i, 0]                                               <L 278>
        var_31 = wp::address(var_joint_dof_dim, var_1, var_30);
        var_33 = wp::load(var_31);
        var_32 = wp::copy(var_33);
        // ang_axis_count = joint_dof_dim[i, 1]                                               <L 279>
        var_35 = wp::address(var_joint_dof_dim, var_1, var_34);
        var_37 = wp::load(var_35);
        var_36 = wp::copy(var_37);
        // X_j = wp.transform_identity()                                                      <L 281>
        var_38 = wp::transform_identity<wp::float32>();
        // v_j = wp.spatial_vector(wp.vec3(), wp.vec3())                                      <L 282>
        var_39 = wp::vec_t<3, wp::float32>();
        var_40 = wp::vec_t<3, wp::float32>();
        var_41 = wp::vec_t<6, wp::float32>(var_39, var_40);
        // if type == JointType.PRISMATIC:                                                    <L 284>
        var_43 = (var_14 == var_42);
        if (var_43) {
            // axis = joint_axis[qd_start]                                                    <L 285>
            var_44 = wp::address(var_joint_axis, var_28);
            var_46 = wp::load(var_44);
            var_45 = wp::copy(var_46);
            // q = joint_q[q_start]                                                           <L 287>
            var_47 = wp::address(var_joint_q, var_25);
            var_49 = wp::load(var_47);
            var_48 = wp::copy(var_49);
            // qd = joint_qd[qd_start]                                                        <L 288>
            var_50 = wp::address(var_joint_qd, var_28);
            var_52 = wp::load(var_50);
            var_51 = wp::copy(var_52);
            // X_j = wp.transform(axis * q, wp.quat_identity())                               <L 290>
            var_53 = wp::mul(var_45, var_48);
            var_54 = wp::quat_identity<wp::float32>();
            var_55 = wp::transform_t<wp::float32>(var_53, var_54);
            // v_j = wp.spatial_vector(axis * qd, wp.vec3())                                  <L 291>
            var_56 = wp::mul(var_45, var_51);
            var_57 = wp::vec_t<3, wp::float32>();
            var_58 = wp::vec_t<6, wp::float32>(var_56, var_57);
        }
        var_59 = wp::where(var_43, var_55, var_38);
        var_60 = wp::where(var_43, var_58, var_41);
        // if type == JointType.REVOLUTE:                                                     <L 293>
        var_62 = (var_14 == var_61);
        if (var_62) {
            // axis = joint_axis[qd_start]                                                    <L 294>
            var_63 = wp::address(var_joint_axis, var_28);
            var_65 = wp::load(var_63);
            var_64 = wp::copy(var_65);
            // q = joint_q[q_start]                                                           <L 296>
            var_66 = wp::address(var_joint_q, var_25);
            var_68 = wp::load(var_66);
            var_67 = wp::copy(var_68);
            // qd = joint_qd[qd_start]                                                        <L 297>
            var_69 = wp::address(var_joint_qd, var_28);
            var_71 = wp::load(var_69);
            var_70 = wp::copy(var_71);
            // X_j = wp.transform(wp.vec3(), wp.quat_from_axis_angle(axis, q))                <L 299>
            var_72 = wp::vec_t<3, wp::float32>();
            var_73 = wp::quat_from_axis_angle(var_64, var_67);
            var_74 = wp::transform_t<wp::float32>(var_72, var_73);
            // v_j = wp.spatial_vector(wp.vec3(), axis * qd)                                  <L 300>
            var_75 = wp::vec_t<3, wp::float32>();
            var_76 = wp::mul(var_64, var_70);
            var_77 = wp::vec_t<6, wp::float32>(var_75, var_76);
        }
        var_78 = wp::where(var_62, var_74, var_59);
        var_79 = wp::where(var_62, var_77, var_60);
        var_80 = wp::where(var_62, var_64, var_45);
        var_81 = wp::where(var_62, var_67, var_48);
        var_82 = wp::where(var_62, var_70, var_51);
        // if type == JointType.BALL:                                                         <L 302>
        var_84 = (var_14 == var_83);
        if (var_84) {
            // r = wp.quat(joint_q[q_start + 0], joint_q[q_start + 1], joint_q[q_start + 2], joint_q[q_start + 3])       <L 303>
            var_86 = wp::add(var_25, var_85);
            var_87 = wp::address(var_joint_q, var_86);
            var_89 = wp::add(var_25, var_88);
            var_90 = wp::address(var_joint_q, var_89);
            var_92 = wp::add(var_25, var_91);
            var_93 = wp::address(var_joint_q, var_92);
            var_95 = wp::add(var_25, var_94);
            var_96 = wp::address(var_joint_q, var_95);
            var_98 = wp::load(var_87);
            var_99 = wp::load(var_90);
            var_100 = wp::load(var_93);
            var_101 = wp::load(var_96);
            var_97 = wp::quat_t<wp::float32>(var_98, var_99, var_100, var_101);
            // w = wp.vec3(joint_qd[qd_start + 0], joint_qd[qd_start + 1], joint_qd[qd_start + 2])       <L 305>
            var_103 = wp::add(var_28, var_102);
            var_104 = wp::address(var_joint_qd, var_103);
            var_106 = wp::add(var_28, var_105);
            var_107 = wp::address(var_joint_qd, var_106);
            var_109 = wp::add(var_28, var_108);
            var_110 = wp::address(var_joint_qd, var_109);
            var_112 = wp::load(var_104);
            var_113 = wp::load(var_107);
            var_114 = wp::load(var_110);
            var_111 = wp::vec_t<3, wp::float32>(var_112, var_113, var_114);
            // X_j = wp.transform(wp.vec3(), r)                                               <L 307>
            var_115 = wp::vec_t<3, wp::float32>();
            var_116 = wp::transform_t<wp::float32>(var_115, var_97);
            // v_j = wp.spatial_vector(wp.vec3(), w)                                          <L 308>
            var_117 = wp::vec_t<3, wp::float32>();
            var_118 = wp::vec_t<6, wp::float32>(var_117, var_111);
        }
        var_119 = wp::where(var_84, var_116, var_78);
        var_120 = wp::where(var_84, var_118, var_79);
        // if type == JointType.FREE or type == JointType.DISTANCE:                           <L 310>
        var_123 = (var_14 == var_122);
        var_121 = var_123;
        if (!var_121) {
            var_125 = (var_14 == var_124);
            var_121 = var_121 || var_125;
        }
        if (var_121) {
            // t = wp.transform(                                                              <L 311>
            // wp.vec3(joint_q[q_start + 0], joint_q[q_start + 1], joint_q[q_start + 2]),       <L 312>
            var_127 = wp::add(var_25, var_126);
            var_128 = wp::address(var_joint_q, var_127);
            var_130 = wp::add(var_25, var_129);
            var_131 = wp::address(var_joint_q, var_130);
            var_133 = wp::add(var_25, var_132);
            var_134 = wp::address(var_joint_q, var_133);
            var_136 = wp::load(var_128);
            var_137 = wp::load(var_131);
            var_138 = wp::load(var_134);
            var_135 = wp::vec_t<3, wp::float32>(var_136, var_137, var_138);
            // wp.quat(joint_q[q_start + 3], joint_q[q_start + 4], joint_q[q_start + 5], joint_q[q_start + 6]),       <L 313>
            var_140 = wp::add(var_25, var_139);
            var_141 = wp::address(var_joint_q, var_140);
            var_143 = wp::add(var_25, var_142);
            var_144 = wp::address(var_joint_q, var_143);
            var_146 = wp::add(var_25, var_145);
            var_147 = wp::address(var_joint_q, var_146);
            var_149 = wp::add(var_25, var_148);
            var_150 = wp::address(var_joint_q, var_149);
            var_152 = wp::load(var_141);
            var_153 = wp::load(var_144);
            var_154 = wp::load(var_147);
            var_155 = wp::load(var_150);
            var_151 = wp::quat_t<wp::float32>(var_152, var_153, var_154, var_155);
            var_156 = wp::transform_t<wp::float32>(var_135, var_151);
            // v = wp.spatial_vector(                                                         <L 316>
            // wp.vec3(joint_qd[qd_start + 0], joint_qd[qd_start + 1], joint_qd[qd_start + 2]),       <L 317>
            var_158 = wp::add(var_28, var_157);
            var_159 = wp::address(var_joint_qd, var_158);
            var_161 = wp::add(var_28, var_160);
            var_162 = wp::address(var_joint_qd, var_161);
            var_164 = wp::add(var_28, var_163);
            var_165 = wp::address(var_joint_qd, var_164);
            var_167 = wp::load(var_159);
            var_168 = wp::load(var_162);
            var_169 = wp::load(var_165);
            var_166 = wp::vec_t<3, wp::float32>(var_167, var_168, var_169);
            // wp.vec3(joint_qd[qd_start + 3], joint_qd[qd_start + 4], joint_qd[qd_start + 5]),       <L 318>
            var_171 = wp::add(var_28, var_170);
            var_172 = wp::address(var_joint_qd, var_171);
            var_174 = wp::add(var_28, var_173);
            var_175 = wp::address(var_joint_qd, var_174);
            var_177 = wp::add(var_28, var_176);
            var_178 = wp::address(var_joint_qd, var_177);
            var_180 = wp::load(var_172);
            var_181 = wp::load(var_175);
            var_182 = wp::load(var_178);
            var_179 = wp::vec_t<3, wp::float32>(var_180, var_181, var_182);
            var_183 = wp::vec_t<6, wp::float32>(var_166, var_179);
            // X_j = t                                                                        <L 321>
            var_184 = wp::copy(var_156);
            // v_j = v                                                                        <L 322>
            var_185 = wp::copy(var_183);
        }
        var_186 = wp::where(var_121, var_184, var_119);
        var_187 = wp::where(var_121, var_185, var_120);
        // if type == JointType.D6:                                                           <L 324>
        var_189 = (var_14 == var_188);
        if (var_189) {
            // pos = wp.vec3(0.0)                                                             <L 325>
            var_191 = wp::vec_t<3, wp::float32>(var_190);
            // rot = wp.quat_identity()                                                       <L 326>
            var_192 = wp::quat_identity<wp::float32>();
            // vel_v = wp.vec3(0.0)                                                           <L 327>
            var_194 = wp::vec_t<3, wp::float32>(var_193);
            // vel_w = wp.vec3(0.0)                                                           <L 328>
            var_196 = wp::vec_t<3, wp::float32>(var_195);
            // if lin_axis_count > 0:                                                         <L 333>
            var_198 = (var_32 > var_197);
            if (var_198) {
                // axis = joint_axis[qd_start + 0]                                            <L 334>
                var_200 = wp::add(var_28, var_199);
                var_201 = wp::address(var_joint_axis, var_200);
                var_203 = wp::load(var_201);
                var_202 = wp::copy(var_203);
                // pos += axis * joint_q[q_start + 0]                                         <L 335>
                var_205 = wp::add(var_25, var_204);
                var_206 = wp::address(var_joint_q, var_205);
                var_208 = wp::load(var_206);
                var_207 = wp::mul(var_202, var_208);
                var_209 = wp::add(var_191, var_207);
                // vel_v += axis * joint_qd[qd_start + 0]                                     <L 336>
                var_211 = wp::add(var_28, var_210);
                var_212 = wp::address(var_joint_qd, var_211);
                var_214 = wp::load(var_212);
                var_213 = wp::mul(var_202, var_214);
                var_215 = wp::add(var_194, var_213);
            }
            var_216 = wp::where(var_198, var_202, var_80);
            var_217 = wp::where(var_198, var_209, var_191);
            var_218 = wp::where(var_198, var_215, var_194);
            // if lin_axis_count > 1:                                                         <L 337>
            var_220 = (var_32 > var_219);
            if (var_220) {
                // axis = joint_axis[qd_start + 1]                                            <L 338>
                var_222 = wp::add(var_28, var_221);
                var_223 = wp::address(var_joint_axis, var_222);
                var_225 = wp::load(var_223);
                var_224 = wp::copy(var_225);
                // pos += axis * joint_q[q_start + 1]                                         <L 339>
                var_227 = wp::add(var_25, var_226);
                var_228 = wp::address(var_joint_q, var_227);
                var_230 = wp::load(var_228);
                var_229 = wp::mul(var_224, var_230);
                var_231 = wp::add(var_217, var_229);
                // vel_v += axis * joint_qd[qd_start + 1]                                     <L 340>
                var_233 = wp::add(var_28, var_232);
                var_234 = wp::address(var_joint_qd, var_233);
                var_236 = wp::load(var_234);
                var_235 = wp::mul(var_224, var_236);
                var_237 = wp::add(var_218, var_235);
            }
            var_238 = wp::where(var_220, var_224, var_216);
            var_239 = wp::where(var_220, var_231, var_217);
            var_240 = wp::where(var_220, var_237, var_218);
            // if lin_axis_count > 2:                                                         <L 341>
            var_242 = (var_32 > var_241);
            if (var_242) {
                // axis = joint_axis[qd_start + 2]                                            <L 342>
                var_244 = wp::add(var_28, var_243);
                var_245 = wp::address(var_joint_axis, var_244);
                var_247 = wp::load(var_245);
                var_246 = wp::copy(var_247);
                // pos += axis * joint_q[q_start + 2]                                         <L 343>
                var_249 = wp::add(var_25, var_248);
                var_250 = wp::address(var_joint_q, var_249);
                var_252 = wp::load(var_250);
                var_251 = wp::mul(var_246, var_252);
                var_253 = wp::add(var_239, var_251);
                // vel_v += axis * joint_qd[qd_start + 2]                                     <L 344>
                var_255 = wp::add(var_28, var_254);
                var_256 = wp::address(var_joint_qd, var_255);
                var_258 = wp::load(var_256);
                var_257 = wp::mul(var_246, var_258);
                var_259 = wp::add(var_240, var_257);
            }
            var_260 = wp::where(var_242, var_246, var_238);
            var_261 = wp::where(var_242, var_253, var_239);
            var_262 = wp::where(var_242, var_259, var_240);
            // iq = q_start + lin_axis_count                                                  <L 346>
            var_263 = wp::add(var_25, var_32);
            // iqd = qd_start + lin_axis_count                                                <L 347>
            var_264 = wp::add(var_28, var_32);
            // if ang_axis_count == 1:                                                        <L 348>
            var_266 = (var_36 == var_265);
            if (var_266) {
                // axis = joint_axis[iqd]                                                     <L 349>
                var_267 = wp::address(var_joint_axis, var_264);
                var_269 = wp::load(var_267);
                var_268 = wp::copy(var_269);
                // rot = wp.quat_from_axis_angle(axis, joint_q[iq])                           <L 350>
                var_270 = wp::address(var_joint_q, var_263);
                var_272 = wp::load(var_270);
                var_271 = wp::quat_from_axis_angle(var_268, var_272);
                // vel_w = joint_qd[iqd] * axis                                               <L 351>
                var_273 = wp::address(var_joint_qd, var_264);
                var_275 = wp::load(var_273);
                var_274 = wp::mul(var_275, var_268);
            }
            var_276 = wp::where(var_266, var_268, var_260);
            var_277 = wp::where(var_266, var_271, var_192);
            var_278 = wp::where(var_266, var_274, var_196);
            // if ang_axis_count == 2:                                                        <L 352>
            var_280 = (var_36 == var_279);
            if (var_280) {
                // rot, vel_w = compute_2d_rotational_dofs(                                   <L 353>
                // joint_axis[iqd + 0],                                                       <L 354>
                var_282 = wp::add(var_264, var_281);
                var_283 = wp::address(var_joint_axis, var_282);
                // joint_axis[iqd + 1],                                                       <L 355>
                var_285 = wp::add(var_264, var_284);
                var_286 = wp::address(var_joint_axis, var_285);
                // joint_q[iq + 0],                                                           <L 356>
                var_288 = wp::add(var_263, var_287);
                var_289 = wp::address(var_joint_q, var_288);
                // joint_q[iq + 1],                                                           <L 357>
                var_291 = wp::add(var_263, var_290);
                var_292 = wp::address(var_joint_q, var_291);
                // joint_qd[iqd + 0],                                                         <L 358>
                var_294 = wp::add(var_264, var_293);
                var_295 = wp::address(var_joint_qd, var_294);
                // joint_qd[iqd + 1],                                                         <L 359>
                var_297 = wp::add(var_264, var_296);
                var_298 = wp::address(var_joint_qd, var_297);
                var_301 = wp::load(var_283);
                var_302 = wp::load(var_286);
                var_303 = wp::load(var_289);
                var_304 = wp::load(var_292);
                var_305 = wp::load(var_295);
                var_306 = wp::load(var_298);
                compute_2d_rotational_dofs_0(var_301, var_302, var_303, var_304, var_305, var_306, var_299, var_300);
            }
            var_307 = wp::where(var_280, var_299, var_277);
            var_308 = wp::where(var_280, var_300, var_278);
            // if ang_axis_count == 3:                                                        <L 361>
            var_310 = (var_36 == var_309);
            if (var_310) {
                // rot, vel_w = compute_3d_rotational_dofs(                                   <L 362>
                // joint_axis[iqd + 0],                                                       <L 363>
                var_312 = wp::add(var_264, var_311);
                var_313 = wp::address(var_joint_axis, var_312);
                // joint_axis[iqd + 1],                                                       <L 364>
                var_315 = wp::add(var_264, var_314);
                var_316 = wp::address(var_joint_axis, var_315);
                // joint_axis[iqd + 2],                                                       <L 365>
                var_318 = wp::add(var_264, var_317);
                var_319 = wp::address(var_joint_axis, var_318);
                // joint_q[iq + 0],                                                           <L 366>
                var_321 = wp::add(var_263, var_320);
                var_322 = wp::address(var_joint_q, var_321);
                // joint_q[iq + 1],                                                           <L 367>
                var_324 = wp::add(var_263, var_323);
                var_325 = wp::address(var_joint_q, var_324);
                // joint_q[iq + 2],                                                           <L 368>
                var_327 = wp::add(var_263, var_326);
                var_328 = wp::address(var_joint_q, var_327);
                // joint_qd[iqd + 0],                                                         <L 369>
                var_330 = wp::add(var_264, var_329);
                var_331 = wp::address(var_joint_qd, var_330);
                // joint_qd[iqd + 1],                                                         <L 370>
                var_333 = wp::add(var_264, var_332);
                var_334 = wp::address(var_joint_qd, var_333);
                // joint_qd[iqd + 2],                                                         <L 371>
                var_336 = wp::add(var_264, var_335);
                var_337 = wp::address(var_joint_qd, var_336);
                var_340 = wp::load(var_313);
                var_341 = wp::load(var_316);
                var_342 = wp::load(var_319);
                var_343 = wp::load(var_322);
                var_344 = wp::load(var_325);
                var_345 = wp::load(var_328);
                var_346 = wp::load(var_331);
                var_347 = wp::load(var_334);
                var_348 = wp::load(var_337);
                compute_3d_rotational_dofs_0(var_340, var_341, var_342, var_343, var_344, var_345, var_346, var_347, var_348, var_338, var_339);
            }
            var_349 = wp::where(var_310, var_338, var_307);
            var_350 = wp::where(var_310, var_339, var_308);
            // X_j = wp.transform(pos, rot)                                                   <L 374>
            var_351 = wp::transform_t<wp::float32>(var_261, var_349);
            // v_j = wp.spatial_vector(vel_v, vel_w)                                          <L 375>
            var_352 = wp::vec_t<6, wp::float32>(var_262, var_350);
        }
        var_353 = wp::where(var_189, var_351, var_186);
        var_354 = wp::where(var_189, var_352, var_187);
        var_355 = wp::where(var_189, var_276, var_80);
        // X_wpj = X_pj                                                                       <L 378>
        var_356 = wp::copy(var_19);
        // if parent >= 0:                                                                    <L 379>
        var_358 = (var_8 >= var_357);
        if (var_358) {
            // X_wp = body_q[parent]                                                          <L 380>
            var_359 = wp::address(var_body_q, var_8);
            var_361 = wp::load(var_359);
            var_360 = wp::copy(var_361);
            // X_wpj = X_wp * X_wpj                                                           <L 381>
            var_362 = wp::mul(var_360, var_356);
        }
        var_363 = wp::where(var_358, var_362, var_356);
        // X_wcj = X_wpj * X_j                                                                <L 384>
        var_364 = wp::mul(var_363, var_353);
        // X_wc = X_wcj * wp.transform_inverse(X_cj)                                          <L 386>
        var_365 = wp::transform_inverse(var_22);
        var_366 = wp::mul(var_364, var_365);
        // x_child_origin = wp.transform_get_translation(X_wc)                                <L 391>
        var_367 = wp::transform_get_translation(var_366);
        // v_parent_origin = wp.vec3()                                                        <L 392>
        var_368 = wp::vec_t<3, wp::float32>();
        // w_parent = wp.vec3()                                                               <L 393>
        var_369 = wp::vec_t<3, wp::float32>();
        // if parent >= 0:                                                                    <L 394>
        var_371 = (var_8 >= var_370);
        if (var_371) {
            // v_wp = body_qd[parent]                                                         <L 395>
            var_372 = wp::address(var_body_qd, var_8);
            var_374 = wp::load(var_372);
            var_373 = wp::copy(var_374);
            // w_parent = wp.spatial_bottom(v_wp)                                             <L 396>
            var_375 = wp::spatial_bottom(var_373);
            // v_parent_origin = com_twist_to_point_velocity(v_wp, X_wp, body_com[parent], x_child_origin)       <L 397>
            var_376 = wp::address(var_body_com, var_8);
            var_378 = wp::load(var_376);
            var_377 = com_twist_to_point_velocity_0(var_373, var_360, var_378, var_367);
        }
        var_379 = wp::where(var_371, var_377, var_368);
        var_380 = wp::where(var_371, var_375, var_369);
        // linear_joint_world = wp.transform_vector(X_wpj, wp.spatial_top(v_j))               <L 400>
        var_381 = wp::spatial_top(var_354);
        var_382 = wp::transform_vector(var_363, var_381);
        // angular_joint_world = wp.transform_vector(X_wpj, wp.spatial_bottom(v_j))           <L 401>
        var_383 = wp::spatial_bottom(var_354);
        var_384 = wp::transform_vector(var_363, var_383);
        // if type == JointType.FREE or type == JointType.DISTANCE:                           <L 402>
        var_387 = (var_14 == var_386);
        var_385 = var_387;
        if (!var_385) {
            var_389 = (var_14 == var_388);
            var_385 = var_385 || var_389;
        }
        if (var_385) {
            // v_joint_origin = com_twist_to_origin_twist(                                    <L 406>
            // wp.spatial_vector(linear_joint_world, angular_joint_world),                    <L 407>
            var_390 = wp::vec_t<6, wp::float32>(var_382, var_384);
            // X_wc,                                                                          <L 408>
            // body_com[child],                                                               <L 409>
            var_391 = wp::address(var_body_com, var_11);
            var_393 = wp::load(var_391);
            var_392 = com_twist_to_origin_twist_0(var_390, var_366, var_393);
            // linear_joint_origin = wp.spatial_top(v_joint_origin)                           <L 411>
            var_394 = wp::spatial_top(var_392);
        }
        if (!var_385) {
            // child_origin_offset_world = x_child_origin - wp.transform_get_translation(X_wcj)       <L 416>
            var_395 = wp::transform_get_translation(var_364);
            var_396 = wp::sub(var_367, var_395);
            // linear_joint_origin = linear_joint_world + wp.cross(angular_joint_world, child_origin_offset_world)       <L 417>
            var_397 = wp::cross(var_384, var_396);
            var_398 = wp::add(var_382, var_397);
        }
        var_399 = wp::where(var_385, var_394, var_398);
        // v_wc_origin = wp.spatial_vector(v_parent_origin + linear_joint_origin, w_parent + angular_joint_world)       <L 419>
        var_400 = wp::add(var_379, var_399);
        var_401 = wp::add(var_380, var_384);
        var_402 = wp::vec_t<6, wp::float32>(var_400, var_401);
        // if (body_flags[child] & body_flag_filter) != 0:                                    <L 421>
        var_403 = wp::address(var_body_flags, var_11);
        var_405 = wp::load(var_403);
        var_404 = wp::bit_and(var_405, var_body_flag_filter);
        var_407 = (var_404 != var_406);
        if (var_407) {
            // body_q[child] = X_wc                                                           <L 422>
            wp::array_store(var_body_q, var_11, var_366);
            // body_qd[child] = origin_twist_to_com_twist(v_wc_origin, X_wc, body_com[child])       <L 423>
            var_408 = wp::address(var_body_com, var_11);
            var_410 = wp::load(var_408);
            var_409 = origin_twist_to_com_twist_0(var_402, var_366, var_410);
            wp::array_store(var_body_qd, var_11, var_409);
        }
        goto start_for_0;
    end_for_0:;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/warp/_src/math.py:196
static CUDA_CALLABLE wp::float32 quat_twist_angle_signed_0(
    wp::vec_t<3, wp::float32> var_axis,
    wp::quat_t<wp::float32> var_q)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    wp::float32 var_1;
    const wp::int32 var_2 = 1;
    wp::float32 var_3;
    const wp::int32 var_4 = 2;
    wp::float32 var_5;
    wp::vec_t<3, wp::float32> var_6;
    wp::float32 var_7;
    const wp::float32 var_8 = 2.0;
    const wp::int32 var_9 = 3;
    wp::float32 var_10;
    wp::float32 var_11;
    wp::float32 var_12;
    //---------
    // forward
    // def quat_twist_angle_signed(axis: wp.vec3, q: wp.quat) -> float:                       <L 197>
    // vector = wp.vec3(q[0], q[1], q[2])                                                     <L 215>
    var_1 = wp::extract(var_q, var_0);
    var_3 = wp::extract(var_q, var_2);
    var_5 = wp::extract(var_q, var_4);
    var_6 = wp::vec_t<3, wp::float32>(var_1, var_3, var_5);
    // sin_half = wp.dot(axis, vector)                                                        <L 216>
    var_7 = wp::dot(var_axis, var_6);
    // return 2.0 * wp.atan2(sin_half, q[3])                                                  <L 217>
    var_10 = wp::extract(var_q, var_9);
    var_11 = wp::atan2(var_7, var_10);
    var_12 = wp::mul(var_8, var_11);
    return var_12;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/sim/articulation.py:617
static CUDA_CALLABLE void reconstruct_angular_q_qd_0(
    wp::quat_t<wp::float32> var_q_pc,
    wp::vec_t<3, wp::float32> var_w_err,
    wp::transform_t<wp::float32> var_X_wp,
    wp::vec_t<3, wp::float32> var_axis,
    wp::float32 & ret_0,
    wp::float32 & ret_1)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::float32 var_1;
    wp::float32 var_2;
    //---------
    // forward
    // def reconstruct_angular_q_qd(q_pc: wp.quat, w_err: wp.vec3, X_wp: wp.transform, axis: wp.vec3):       <L 618>
    // axis_p = wp.transform_vector(X_wp, axis)                                               <L 633>
    var_0 = wp::transform_vector(var_X_wp, var_axis);
    // q = wp.quat_twist_angle_signed(axis, q_pc)                                             <L 634>
    var_1 = quat_twist_angle_signed_0(var_axis, var_q_pc);
    // qd = wp.dot(w_err, axis_p)                                                             <L 635>
    var_2 = wp::dot(var_w_err, var_0);
    // return q, qd                                                                           <L 636>
    ret_0 = var_1;
    ret_1 = var_2;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/warp/_src/math.py:253
static CUDA_CALLABLE wp::vec_t<3, wp::float32> quat_to_euler_0(
    wp::quat_t<wp::float32> var_q,
    wp::int32 var_i,
    wp::int32 var_j,
    wp::int32 var_k)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 3;
    wp::float32 var_1;
    const wp::int32 var_2 = 0;
    wp::float32 var_3;
    const wp::int32 var_4 = 1;
    wp::float32 var_5;
    const wp::int32 var_6 = 2;
    wp::float32 var_7;
    const wp::int32 var_8 = 1;
    wp::int32 var_9;
    const wp::int32 var_10 = 1;
    wp::int32 var_11;
    const wp::int32 var_12 = 1;
    wp::int32 var_13;
    const bool var_14 = true;
    bool var_15;
    const bool var_16 = false;
    const wp::int32 var_17 = 6;
    wp::int32 var_18;
    wp::int32 var_19;
    wp::int32 var_20;
    bool var_21;
    wp::int32 var_22;
    wp::int32 var_23;
    wp::int32 var_24;
    wp::int32 var_25;
    wp::int32 var_26;
    wp::float32 var_27;
    const wp::float32 var_28 = 2.0;
    wp::float32 var_29;
    wp::float32 var_30;
    wp::float32 var_31;
    wp::float32 var_32;
    wp::float32 var_33;
    const wp::int32 var_34 = 2;
    bool var_35;
    wp::float32 var_36;
    const wp::int32 var_37 = 3;
    bool var_38;
    wp::float32 var_39;
    wp::float32 var_40;
    wp::float32 var_41;
    const wp::int32 var_42 = 2;
    bool var_43;
    wp::float32 var_44;
    const wp::int32 var_45 = 3;
    bool var_46;
    wp::float32 var_47;
    wp::float32 var_48;
    wp::float32 var_49;
    const wp::int32 var_50 = 2;
    bool var_51;
    wp::float32 var_52;
    const wp::int32 var_53 = 3;
    bool var_54;
    wp::float32 var_55;
    wp::float32 var_56;
    wp::float32 var_57;
    wp::float32 var_58;
    wp::float32 var_59;
    wp::float32 var_60;
    const wp::int32 var_61 = 2;
    bool var_62;
    wp::float32 var_63;
    const wp::int32 var_64 = 3;
    bool var_65;
    wp::float32 var_66;
    wp::float32 var_67;
    wp::float32 var_68;
    const wp::int32 var_69 = 2;
    bool var_70;
    wp::float32 var_71;
    const wp::int32 var_72 = 3;
    bool var_73;
    wp::float32 var_74;
    wp::float32 var_75;
    wp::float32 var_76;
    const wp::int32 var_77 = 2;
    bool var_78;
    wp::float32 var_79;
    const wp::int32 var_80 = 3;
    bool var_81;
    wp::float32 var_82;
    wp::float32 var_83;
    wp::float32 var_84;
    wp::float32 var_85;
    wp::float32 var_86;
    wp::float32 var_87;
    wp::float32 var_88;
    wp::float32 var_89;
    wp::float32 var_90;
    wp::float32 var_91;
    wp::float32 var_92;
    wp::float32 var_93;
    const wp::float32 var_94 = 2.0;
    wp::float32 var_95;
    wp::float32 var_96;
    wp::float32 var_97;
    wp::float32 var_98;
    wp::float32 var_99;
    wp::float32 var_100;
    wp::float32 var_101;
    wp::float32 var_102;
    wp::float32 var_103;
    wp::float32 var_104;
    wp::float32 var_105;
    wp::float32 var_106;
    const wp::float32 var_107 = 1.0;
    wp::float32 var_108;
    wp::float32 var_109;
    wp::float32 var_110;
    wp::float32 var_111;
    const wp::float32 var_112 = 0.0;
    const wp::float32 var_113 = 0.0;
    wp::float32 var_114;
    const wp::float32 var_115 = 1e-06;
    bool var_116;
    const wp::float32 var_117 = 2.0;
    wp::float32 var_118;
    wp::float32 var_119;
    const wp::float32 var_120 = 3.141592653589793;
    wp::float32 var_121;
    wp::float32 var_122;
    const wp::float32 var_123 = 1e-06;
    bool var_124;
    const wp::float32 var_125 = 2.0;
    wp::float32 var_126;
    wp::float32 var_127;
    wp::float32 var_128;
    wp::float32 var_129;
    wp::float32 var_130;
    wp::float32 var_131;
    wp::float32 var_132;
    wp::float32 var_133;
    const wp::float32 var_134 = 1.5707963267948966;
    wp::float32 var_135;
    wp::float32 var_136;
    wp::float32 var_137;
    wp::float32 var_138;
    wp::float32 var_139;
    wp::float32 var_140;
    wp::float32 var_141;
    const wp::int32 var_142 = 2;
    bool var_143;
    wp::float32 var_144;
    wp::float32 var_145;
    const wp::int32 var_146 = 3;
    bool var_147;
    wp::float32 var_148;
    wp::float32 var_149;
    wp::float32 var_150;
    wp::float32 var_151;
    wp::float32 var_152;
    wp::float32 var_153;
    wp::float32 var_154;
    const wp::int32 var_155 = 1;
    bool var_156;
    wp::float32 var_157;
    const wp::int32 var_158 = 2;
    bool var_159;
    wp::float32 var_160;
    wp::float32 var_161;
    wp::float32 var_162;
    wp::float32 var_163;
    wp::float32 var_164;
    wp::float32 var_165;
    wp::float32 var_166;
    const wp::int32 var_167 = 1;
    bool var_168;
    wp::float32 var_169;
    const wp::int32 var_170 = 2;
    bool var_171;
    wp::float32 var_172;
    wp::float32 var_173;
    wp::float32 var_174;
    wp::float32 var_175;
    wp::float32 var_176;
    wp::float32 var_177;
    wp::float32 var_178;
    wp::vec_t<3, wp::float32> var_179;
    //---------
    // forward
    // def quat_to_euler(q: wp.quat, i: int, j: int, k: int) -> wp.vec3:                      <L 254>
    // q0 = q[3]                                                                              <L 287>
    var_1 = wp::extract(var_q, var_0);
    // q1 = q[0]                                                                              <L 288>
    var_3 = wp::extract(var_q, var_2);
    // q2 = q[1]                                                                              <L 289>
    var_5 = wp::extract(var_q, var_4);
    // q3 = q[2]                                                                              <L 290>
    var_7 = wp::extract(var_q, var_6);
    // i += 1                                                                                 <L 294>
    var_9 = wp::add(var_i, var_8);
    // j += 1                                                                                 <L 295>
    var_11 = wp::add(var_j, var_10);
    // k += 1                                                                                 <L 296>
    var_13 = wp::add(var_k, var_12);
    // not_proper = True                                                                      <L 297>
    // if i == k:                                                                             <L 298>
    var_15 = (var_9 == var_13);
    if (var_15) {
        // not_proper = False                                                                 <L 299>
        // k = 6 - i - j  # because i + j + k = 1 + 2 + 3 = 6                                 <L 300>
        var_18 = wp::sub(var_17, var_9);
        var_19 = wp::sub(var_18, var_11);
    }
    var_20 = wp::where(var_15, var_19, var_13);
    var_21 = wp::where(var_15, var_16, var_14);
    // e = float((i - j) * (j - k) * (k - i)) / 2.0  # Levi-Civita symbol                     <L 301>
    var_22 = wp::sub(var_9, var_11);
    var_23 = wp::sub(var_11, var_20);
    var_24 = wp::mul(var_22, var_23);
    var_25 = wp::sub(var_20, var_9);
    var_26 = wp::mul(var_24, var_25);
    var_27 = wp::float(var_26);
    var_29 = wp::div(var_27, var_28);
    // a = q0                                                                                 <L 302>
    var_30 = wp::copy(var_1);
    // b = q1                                                                                 <L 303>
    var_31 = wp::copy(var_3);
    // c = q1                                                                                 <L 304>
    var_32 = wp::copy(var_3);
    // d = q1 * e                                                                             <L 305>
    var_33 = wp::mul(var_3, var_29);
    // if i == 2:                                                                             <L 307>
    var_35 = (var_9 == var_34);
    if (var_35) {
        // b = q2                                                                             <L 308>
        var_36 = wp::copy(var_5);
    }
    if (!var_35) {
        // elif i == 3:                                                                       <L 309>
        var_38 = (var_9 == var_37);
        if (var_38) {
            // b = q3                                                                         <L 310>
            var_39 = wp::copy(var_7);
        }
        var_40 = wp::where(var_38, var_39, var_31);
    }
    var_41 = wp::where(var_35, var_36, var_40);
    // if j == 2:                                                                             <L 312>
    var_43 = (var_11 == var_42);
    if (var_43) {
        // c = q2                                                                             <L 313>
        var_44 = wp::copy(var_5);
    }
    if (!var_43) {
        // elif j == 3:                                                                       <L 314>
        var_46 = (var_11 == var_45);
        if (var_46) {
            // c = q3                                                                         <L 315>
            var_47 = wp::copy(var_7);
        }
        var_48 = wp::where(var_46, var_47, var_32);
    }
    var_49 = wp::where(var_43, var_44, var_48);
    // if k == 2:                                                                             <L 317>
    var_51 = (var_20 == var_50);
    if (var_51) {
        // d = q2 * e                                                                         <L 318>
        var_52 = wp::mul(var_5, var_29);
    }
    if (!var_51) {
        // elif k == 3:                                                                       <L 319>
        var_54 = (var_20 == var_53);
        if (var_54) {
            // d = q3 * e                                                                     <L 320>
            var_55 = wp::mul(var_7, var_29);
        }
        var_56 = wp::where(var_54, var_55, var_33);
    }
    var_57 = wp::where(var_51, var_52, var_56);
    // if not_proper:                                                                         <L 322>
    if (var_21) {
        // qj = q1                                                                            <L 323>
        var_58 = wp::copy(var_3);
        // qk = q1                                                                            <L 324>
        var_59 = wp::copy(var_3);
        // qi = q1                                                                            <L 325>
        var_60 = wp::copy(var_3);
        // if j == 2:                                                                         <L 326>
        var_62 = (var_11 == var_61);
        if (var_62) {
            // qj = q2                                                                        <L 327>
            var_63 = wp::copy(var_5);
        }
        if (!var_62) {
            // elif j == 3:                                                                   <L 328>
            var_65 = (var_11 == var_64);
            if (var_65) {
                // qj = q3                                                                    <L 329>
                var_66 = wp::copy(var_7);
            }
            var_67 = wp::where(var_65, var_66, var_58);
        }
        var_68 = wp::where(var_62, var_63, var_67);
        // if k == 2:                                                                         <L 330>
        var_70 = (var_20 == var_69);
        if (var_70) {
            // qk = q2                                                                        <L 331>
            var_71 = wp::copy(var_5);
        }
        if (!var_70) {
            // elif k == 3:                                                                   <L 332>
            var_73 = (var_20 == var_72);
            if (var_73) {
                // qk = q3                                                                    <L 333>
                var_74 = wp::copy(var_7);
            }
            var_75 = wp::where(var_73, var_74, var_59);
        }
        var_76 = wp::where(var_70, var_71, var_75);
        // if i == 2:                                                                         <L 334>
        var_78 = (var_9 == var_77);
        if (var_78) {
            // qi = q2                                                                        <L 335>
            var_79 = wp::copy(var_5);
        }
        if (!var_78) {
            // elif i == 3:                                                                   <L 336>
            var_81 = (var_9 == var_80);
            if (var_81) {
                // qi = q3                                                                    <L 337>
                var_82 = wp::copy(var_7);
            }
            var_83 = wp::where(var_81, var_82, var_60);
        }
        var_84 = wp::where(var_78, var_79, var_83);
        // a -= qj                                                                            <L 339>
        var_85 = wp::sub(var_30, var_68);
        // b += qk * e                                                                        <L 340>
        var_86 = wp::mul(var_76, var_29);
        var_87 = wp::add(var_41, var_86);
        // c += q0                                                                            <L 341>
        var_88 = wp::add(var_49, var_1);
        // d -= qi                                                                            <L 342>
        var_89 = wp::sub(var_57, var_84);
    }
    var_90 = wp::where(var_21, var_85, var_30);
    var_91 = wp::where(var_21, var_87, var_41);
    var_92 = wp::where(var_21, var_88, var_49);
    var_93 = wp::where(var_21, var_89, var_57);
    // t2 = wp.acos(2.0 * (a * a + b * b) / (a * a + b * b + c * c + d * d) - 1.0)            <L 343>
    var_95 = wp::mul(var_90, var_90);
    var_96 = wp::mul(var_91, var_91);
    var_97 = wp::add(var_95, var_96);
    var_98 = wp::mul(var_94, var_97);
    var_99 = wp::mul(var_90, var_90);
    var_100 = wp::mul(var_91, var_91);
    var_101 = wp::add(var_99, var_100);
    var_102 = wp::mul(var_92, var_92);
    var_103 = wp::add(var_101, var_102);
    var_104 = wp::mul(var_93, var_93);
    var_105 = wp::add(var_103, var_104);
    var_106 = wp::div(var_98, var_105);
    var_108 = wp::sub(var_106, var_107);
    var_109 = wp::acos(var_108);
    // tp = wp.atan2(b, a)                                                                    <L 344>
    var_110 = wp::atan2(var_91, var_90);
    // tm = wp.atan2(d, c)                                                                    <L 345>
    var_111 = wp::atan2(var_93, var_92);
    // t1 = 0.0                                                                               <L 346>
    // t3 = 0.0                                                                               <L 347>
    // if wp.abs(t2) < 1e-6:                                                                  <L 348>
    var_114 = wp::abs(var_109);
    var_116 = (var_114 < var_115);
    if (var_116) {
        // t3 = 2.0 * tp - t1                                                                 <L 349>
        var_118 = wp::mul(var_117, var_110);
        var_119 = wp::sub(var_118, var_112);
    }
    if (!var_116) {
        // elif wp.abs(t2 - wp.pi) < 1e-6:                                                    <L 350>
        var_121 = wp::sub(var_109, var_120);
        var_122 = wp::abs(var_121);
        var_124 = (var_122 < var_123);
        if (var_124) {
            // t3 = 2.0 * tm + t1                                                             <L 351>
            var_126 = wp::mul(var_125, var_111);
            var_127 = wp::add(var_126, var_112);
        }
        if (!var_124) {
            // t1 = tp - tm                                                                   <L 353>
            var_128 = wp::sub(var_110, var_111);
            // t3 = tp + tm                                                                   <L 354>
            var_129 = wp::add(var_110, var_111);
        }
        var_130 = wp::where(var_124, var_112, var_128);
        var_131 = wp::where(var_124, var_127, var_129);
    }
    var_132 = wp::where(var_116, var_112, var_130);
    var_133 = wp::where(var_116, var_119, var_131);
    // if not_proper:                                                                         <L 355>
    if (var_21) {
        // t2 -= wp.HALF_PI                                                                   <L 356>
        var_135 = wp::sub(var_109, var_134);
        // t3 *= e                                                                            <L 357>
        var_136 = wp::mul(var_133, var_29);
    }
    var_137 = wp::where(var_21, var_135, var_109);
    var_138 = wp::where(var_21, var_136, var_133);
    // ex = t1                                                                                <L 362>
    var_139 = wp::copy(var_132);
    // ey = t2                                                                                <L 363>
    var_140 = wp::copy(var_137);
    // ez = t3                                                                                <L 364>
    var_141 = wp::copy(var_138);
    // if i == 2:                                                                             <L 365>
    var_143 = (var_9 == var_142);
    if (var_143) {
        // ex = t2                                                                            <L 366>
        var_144 = wp::copy(var_137);
        // ey = t1                                                                            <L 367>
        var_145 = wp::copy(var_132);
    }
    if (!var_143) {
        // elif i == 3:                                                                       <L 368>
        var_147 = (var_9 == var_146);
        if (var_147) {
            // ex = t3                                                                        <L 369>
            var_148 = wp::copy(var_138);
            // ez = t1                                                                        <L 370>
            var_149 = wp::copy(var_132);
        }
        var_150 = wp::where(var_147, var_148, var_139);
        var_151 = wp::where(var_147, var_149, var_141);
    }
    var_152 = wp::where(var_143, var_144, var_150);
    var_153 = wp::where(var_143, var_145, var_140);
    var_154 = wp::where(var_143, var_141, var_151);
    // if j == 1:                                                                             <L 372>
    var_156 = (var_11 == var_155);
    if (var_156) {
        // ex = t2                                                                            <L 373>
        var_157 = wp::copy(var_137);
    }
    if (!var_156) {
        // elif j == 2:                                                                       <L 374>
        var_159 = (var_11 == var_158);
        if (var_159) {
            // ey = t2                                                                        <L 375>
            var_160 = wp::copy(var_137);
        }
        if (!var_159) {
            // ez = t2                                                                        <L 377>
            var_161 = wp::copy(var_137);
        }
        var_162 = wp::where(var_159, var_160, var_153);
        var_163 = wp::where(var_159, var_154, var_161);
    }
    var_164 = wp::where(var_156, var_157, var_152);
    var_165 = wp::where(var_156, var_153, var_162);
    var_166 = wp::where(var_156, var_154, var_163);
    // if k == 1:                                                                             <L 379>
    var_168 = (var_20 == var_167);
    if (var_168) {
        // ex = t3                                                                            <L 380>
        var_169 = wp::copy(var_138);
    }
    if (!var_168) {
        // elif k == 2:                                                                       <L 381>
        var_171 = (var_20 == var_170);
        if (var_171) {
            // ey = t3                                                                        <L 382>
            var_172 = wp::copy(var_138);
        }
        if (!var_171) {
            // ez = t3                                                                        <L 384>
            var_173 = wp::copy(var_138);
        }
        var_174 = wp::where(var_171, var_172, var_165);
        var_175 = wp::where(var_171, var_166, var_173);
    }
    var_176 = wp::where(var_168, var_169, var_164);
    var_177 = wp::where(var_168, var_165, var_174);
    var_178 = wp::where(var_168, var_166, var_175);
    // return wp.vec3(ex, ey, ez)                                                             <L 386>
    var_179 = wp::vec_t<3, wp::float32>(var_176, var_177, var_178);
    return var_179;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/math/spatial.py:133
static CUDA_CALLABLE wp::float32 _wrap_angle_pm_pi_0(
    wp::float32 var_theta)
{
    //---------
    // primal vars
    const wp::float32 var_0 = 2.0;
    const wp::float32 var_1 = 3.141592653589793;
    wp::float32 var_2;
    const wp::float32 var_3 = 3.141592653589793;
    wp::float32 var_4;
    wp::float32 var_5;
    const wp::float32 var_6 = 0.0;
    bool var_7;
    wp::float32 var_8;
    wp::float32 var_9;
    const wp::float32 var_10 = 3.141592653589793;
    wp::float32 var_11;
    //---------
    // forward
    // def _wrap_angle_pm_pi(theta: float) -> float:                                          <L 134>
    // two_pi = 2.0 * wp.pi                                                                   <L 143>
    var_2 = wp::mul(var_0, var_1);
    // wrapped = wp.mod(theta + wp.pi, two_pi)                                                <L 144>
    var_4 = wp::add(var_theta, var_3);
    var_5 = wp::mod(var_4, var_2);
    // if wrapped < 0.0:                                                                      <L 145>
    var_7 = (var_5 < var_6);
    if (var_7) {
        // wrapped += two_pi                                                                  <L 146>
        var_8 = wp::add(var_5, var_2);
    }
    var_9 = wp::where(var_7, var_8, var_5);
    // return wrapped - wp.pi                                                                 <L 147>
    var_11 = wp::sub(var_9, var_10);
    return var_11;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/math/spatial.py:150
static CUDA_CALLABLE wp::vec_t<3, wp::float32> quat_decompose_0(
    wp::quat_t<wp::float32> var_q)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 2;
    const wp::int32 var_1 = 1;
    const wp::int32 var_2 = 0;
    wp::vec_t<3, wp::float32> var_3;
    const wp::int32 var_4 = 0;
    wp::float32 var_5;
    wp::float32 var_6;
    const wp::int32 var_7 = 1;
    wp::float32 var_8;
    wp::float32 var_9;
    const wp::int32 var_10 = 2;
    wp::float32 var_11;
    wp::float32 var_12;
    wp::vec_t<3, wp::float32> var_13;
    //---------
    // forward
    // def quat_decompose(q: wp.quat) -> wp.vec3:                                             <L 151>
    // angles = wp.quat_to_euler(q, 2, 1, 0)                                                  <L 170>
    var_3 = quat_to_euler_0(var_q, var_0, var_1, var_2);
    // return wp.vec3(                                                                        <L 171>
    // _wrap_angle_pm_pi(angles[0]),                                                          <L 172>
    var_5 = wp::extract(var_3, var_4);
    var_6 = _wrap_angle_pm_pi_0(var_5);
    // _wrap_angle_pm_pi(angles[1]),                                                          <L 173>
    var_8 = wp::extract(var_3, var_7);
    var_9 = _wrap_angle_pm_pi_0(var_8);
    // _wrap_angle_pm_pi(angles[2]),                                                          <L 174>
    var_11 = wp::extract(var_3, var_10);
    var_12 = _wrap_angle_pm_pi_0(var_11);
    var_13 = wp::vec_t<3, wp::float32>(var_6, var_9, var_12);
    return var_13;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/sim/articulation.py:85
static CUDA_CALLABLE void invert_2d_rotational_dofs_0(
    wp::vec_t<3, wp::float32> var_axis_0,
    wp::vec_t<3, wp::float32> var_axis_1,
    wp::quat_t<wp::float32> var_q_p,
    wp::quat_t<wp::float32> var_q_c,
    wp::vec_t<3, wp::float32> var_w_err,
    wp::vec_t<2, wp::float32> & ret_0,
    wp::vec_t<2, wp::float32> & ret_1)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::mat_t<3, 3, wp::float32> var_1;
    wp::quat_t<wp::float32> var_2;
    wp::quat_t<wp::float32> var_3;
    wp::quat_t<wp::float32> var_4;
    wp::quat_t<wp::float32> var_5;
    wp::quat_t<wp::float32> var_6;
    wp::quat_t<wp::float32> var_7;
    wp::vec_t<3, wp::float32> var_8;
    const wp::float32 var_9 = 1.0;
    const wp::float32 var_10 = 0.0;
    const wp::float32 var_11 = 0.0;
    wp::vec_t<3, wp::float32> var_12;
    wp::vec_t<3, wp::float32> var_13;
    const wp::float32 var_14 = 0.0;
    const wp::float32 var_15 = 1.0;
    const wp::float32 var_16 = 0.0;
    wp::vec_t<3, wp::float32> var_17;
    wp::vec_t<3, wp::float32> var_18;
    const wp::float32 var_19 = 0.0;
    const wp::float32 var_20 = 0.0;
    const wp::float32 var_21 = 1.0;
    wp::vec_t<3, wp::float32> var_22;
    wp::vec_t<3, wp::float32> var_23;
    wp::vec_t<3, wp::float32> var_24;
    const wp::int32 var_25 = 0;
    wp::float32 var_26;
    wp::quat_t<wp::float32> var_27;
    wp::vec_t<3, wp::float32> var_28;
    const wp::int32 var_29 = 1;
    wp::float32 var_30;
    wp::quat_t<wp::float32> var_31;
    wp::quat_t<wp::float32> var_32;
    wp::vec_t<3, wp::float32> var_33;
    wp::vec_t<3, wp::float32> var_34;
    wp::vec_t<3, wp::float32> var_35;
    wp::vec_t<3, wp::float32> var_36;
    wp::float32 var_37;
    wp::float32 var_38;
    wp::float32 var_39;
    wp::float32 var_40;
    wp::float32 var_41;
    wp::float32 var_42;
    wp::vec_t<2, wp::float32> var_43;
    const wp::int32 var_44 = 0;
    wp::float32 var_45;
    const wp::int32 var_46 = 1;
    wp::float32 var_47;
    wp::vec_t<2, wp::float32> var_48;
    //---------
    // forward
    // def invert_2d_rotational_dofs(                                                         <L 86>
    // q_off = wp.quat_from_matrix(wp.matrix_from_cols(axis_0, axis_1, wp.cross(axis_0, axis_1)))       <L 96>
    var_0 = wp::cross(var_axis_0, var_axis_1);
    var_1 = wp::matrix_from_cols<wp::float32>(var_axis_0, var_axis_1, var_0);
    var_2 = wp::quat_from_matrix(var_1);
    // q_pc = wp.quat_inverse(q_off) * wp.quat_inverse(q_p) * q_c * q_off                     <L 97>
    var_3 = wp::quat_inverse(var_2);
    var_4 = wp::quat_inverse(var_q_p);
    var_5 = wp::mul(var_3, var_4);
    var_6 = wp::mul(var_5, var_q_c);
    var_7 = wp::mul(var_6, var_2);
    // angles = quat_decompose(q_pc)                                                          <L 100>
    var_8 = quat_decompose_0(var_7);
    // local_0 = wp.quat_rotate(q_off, wp.vec3(1.0, 0.0, 0.0))                                <L 103>
    var_12 = wp::vec_t<3, wp::float32>(var_9, var_10, var_11);
    var_13 = wp::quat_rotate(var_2, var_12);
    // local_1 = wp.quat_rotate(q_off, wp.vec3(0.0, 1.0, 0.0))                                <L 104>
    var_17 = wp::vec_t<3, wp::float32>(var_14, var_15, var_16);
    var_18 = wp::quat_rotate(var_2, var_17);
    // local_2 = wp.quat_rotate(q_off, wp.vec3(0.0, 0.0, 1.0))                                <L 105>
    var_22 = wp::vec_t<3, wp::float32>(var_19, var_20, var_21);
    var_23 = wp::quat_rotate(var_2, var_22);
    // axis_0 = local_0                                                                       <L 107>
    var_24 = wp::copy(var_13);
    // q_0 = wp.quat_from_axis_angle(axis_0, angles[0])                                       <L 108>
    var_26 = wp::extract(var_8, var_25);
    var_27 = wp::quat_from_axis_angle(var_24, var_26);
    // axis_1 = wp.quat_rotate(q_0, local_1)                                                  <L 110>
    var_28 = wp::quat_rotate(var_27, var_18);
    // q_1 = wp.quat_from_axis_angle(axis_1, angles[1])                                       <L 111>
    var_30 = wp::extract(var_8, var_29);
    var_31 = wp::quat_from_axis_angle(var_28, var_30);
    // axis_2 = wp.quat_rotate(q_1 * q_0, local_2)                                            <L 113>
    var_32 = wp::mul(var_31, var_27);
    var_33 = wp::quat_rotate(var_32, var_23);
    // w_err_p = wp.quat_rotate_inv(q_p, w_err)                                               <L 116>
    var_34 = wp::quat_rotate_inv(var_q_p, var_w_err);
    // c12 = wp.cross(axis_1, axis_2)                                                         <L 119>
    var_35 = wp::cross(var_28, var_33);
    // c02 = wp.cross(axis_0, axis_2)                                                         <L 120>
    var_36 = wp::cross(var_24, var_33);
    // vel = wp.vec2(wp.dot(w_err_p, c12) / wp.dot(axis_0, c12), wp.dot(w_err_p, c02) / wp.dot(axis_1, c02))       <L 122>
    var_37 = wp::dot(var_34, var_35);
    var_38 = wp::dot(var_24, var_35);
    var_39 = wp::div(var_37, var_38);
    var_40 = wp::dot(var_34, var_36);
    var_41 = wp::dot(var_28, var_36);
    var_42 = wp::div(var_40, var_41);
    var_43 = wp::vec_t<2, wp::float32>(var_39, var_42);
    // return wp.vec2(angles[0], angles[1]), vel                                              <L 124>
    var_45 = wp::extract(var_8, var_44);
    var_47 = wp::extract(var_8, var_46);
    var_48 = wp::vec_t<2, wp::float32>(var_45, var_47);
    ret_0 = var_48;
    ret_1 = var_43;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/sim/articulation.py:181
static CUDA_CALLABLE void invert_3d_rotational_dofs_0(
    wp::vec_t<3, wp::float32> var_axis_0,
    wp::vec_t<3, wp::float32> var_axis_1,
    wp::vec_t<3, wp::float32> var_axis_2,
    wp::quat_t<wp::float32> var_q_p,
    wp::quat_t<wp::float32> var_q_c,
    wp::vec_t<3, wp::float32> var_w_err,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    const wp::float32 var_1 = 1.0;
    wp::float32 var_2;
    wp::float32 var_3;
    const wp::float32 var_4 = 0.0;
    bool var_5;
    const wp::float32 var_6 = -1.0;
    wp::float32 var_7;
    wp::float32 var_8;
    wp::mat_t<3, 3, wp::float32> var_9;
    wp::quat_t<wp::float32> var_10;
    wp::quat_t<wp::float32> var_11;
    wp::quat_t<wp::float32> var_12;
    wp::quat_t<wp::float32> var_13;
    wp::quat_t<wp::float32> var_14;
    wp::quat_t<wp::float32> var_15;
    wp::vec_t<3, wp::float32> var_16;
    const wp::float32 var_17 = 1.0;
    const wp::float32 var_18 = 0.0;
    const wp::float32 var_19 = 0.0;
    wp::vec_t<3, wp::float32> var_20;
    wp::vec_t<3, wp::float32> var_21;
    const wp::float32 var_22 = 0.0;
    const wp::float32 var_23 = 1.0;
    const wp::float32 var_24 = 0.0;
    wp::vec_t<3, wp::float32> var_25;
    wp::vec_t<3, wp::float32> var_26;
    const wp::float32 var_27 = 0.0;
    const wp::float32 var_28 = 0.0;
    const wp::float32 var_29 = 1.0;
    wp::vec_t<3, wp::float32> var_30;
    wp::vec_t<3, wp::float32> var_31;
    wp::vec_t<3, wp::float32> var_32;
    const wp::int32 var_33 = 0;
    wp::float32 var_34;
    wp::quat_t<wp::float32> var_35;
    wp::vec_t<3, wp::float32> var_36;
    const wp::int32 var_37 = 1;
    wp::float32 var_38;
    wp::quat_t<wp::float32> var_39;
    wp::quat_t<wp::float32> var_40;
    wp::vec_t<3, wp::float32> var_41;
    wp::vec_t<3, wp::float32> var_42;
    wp::vec_t<3, wp::float32> var_43;
    wp::vec_t<3, wp::float32> var_44;
    wp::vec_t<3, wp::float32> var_45;
    wp::float32 var_46;
    wp::float32 var_47;
    wp::float32 var_48;
    wp::float32 var_49;
    wp::float32 var_50;
    wp::float32 var_51;
    wp::float32 var_52;
    wp::float32 var_53;
    wp::float32 var_54;
    wp::vec_t<3, wp::float32> var_55;
    const wp::int32 var_56 = 0;
    wp::float32 var_57;
    const wp::int32 var_58 = 1;
    wp::float32 var_59;
    const wp::int32 var_60 = 2;
    wp::float32 var_61;
    wp::float32 var_62;
    wp::vec_t<3, wp::float32> var_63;
    const wp::int32 var_64 = 0;
    wp::float32 var_65;
    const wp::int32 var_66 = 1;
    wp::float32 var_67;
    const wp::int32 var_68 = 2;
    wp::float32 var_69;
    wp::float32 var_70;
    wp::vec_t<3, wp::float32> var_71;
    //---------
    // forward
    // def invert_3d_rotational_dofs(                                                         <L 182>
    // axis_2_rh = wp.cross(axis_0, axis_1)                                                   <L 193>
    var_0 = wp::cross(var_axis_0, var_axis_1);
    // s = float(1.0)                                                                         <L 194>
    var_2 = wp::float(var_1);
    // if wp.dot(axis_2_rh, axis_2) < 0.0:                                                    <L 195>
    var_3 = wp::dot(var_0, var_axis_2);
    var_5 = (var_3 < var_4);
    if (var_5) {
        // s = float(-1.0)                                                                    <L 196>
        var_7 = wp::float(var_6);
    }
    var_8 = wp::where(var_5, var_7, var_2);
    // q_off = wp.quat_from_matrix(wp.matrix_from_cols(axis_0, axis_1, axis_2_rh))            <L 198>
    var_9 = wp::matrix_from_cols<wp::float32>(var_axis_0, var_axis_1, var_0);
    var_10 = wp::quat_from_matrix(var_9);
    // q_pc = wp.quat_inverse(q_off) * wp.quat_inverse(q_p) * q_c * q_off                     <L 199>
    var_11 = wp::quat_inverse(var_10);
    var_12 = wp::quat_inverse(var_q_p);
    var_13 = wp::mul(var_11, var_12);
    var_14 = wp::mul(var_13, var_q_c);
    var_15 = wp::mul(var_14, var_10);
    // angles = quat_decompose(q_pc)                                                          <L 202>
    var_16 = quat_decompose_0(var_15);
    // local_0 = wp.quat_rotate(q_off, wp.vec3(1.0, 0.0, 0.0))                                <L 205>
    var_20 = wp::vec_t<3, wp::float32>(var_17, var_18, var_19);
    var_21 = wp::quat_rotate(var_10, var_20);
    // local_1 = wp.quat_rotate(q_off, wp.vec3(0.0, 1.0, 0.0))                                <L 206>
    var_25 = wp::vec_t<3, wp::float32>(var_22, var_23, var_24);
    var_26 = wp::quat_rotate(var_10, var_25);
    // local_2 = wp.quat_rotate(q_off, wp.vec3(0.0, 0.0, 1.0))                                <L 207>
    var_30 = wp::vec_t<3, wp::float32>(var_27, var_28, var_29);
    var_31 = wp::quat_rotate(var_10, var_30);
    // a0 = local_0                                                                           <L 209>
    var_32 = wp::copy(var_21);
    // q_0 = wp.quat_from_axis_angle(a0, angles[0])                                           <L 210>
    var_34 = wp::extract(var_16, var_33);
    var_35 = wp::quat_from_axis_angle(var_32, var_34);
    // a1 = wp.quat_rotate(q_0, local_1)                                                      <L 212>
    var_36 = wp::quat_rotate(var_35, var_26);
    // q_1 = wp.quat_from_axis_angle(a1, angles[1])                                           <L 213>
    var_38 = wp::extract(var_16, var_37);
    var_39 = wp::quat_from_axis_angle(var_36, var_38);
    // a2 = wp.quat_rotate(q_1 * q_0, local_2)                                                <L 215>
    var_40 = wp::mul(var_39, var_35);
    var_41 = wp::quat_rotate(var_40, var_31);
    // w_err_p = wp.quat_rotate_inv(q_p, w_err)                                               <L 218>
    var_42 = wp::quat_rotate_inv(var_q_p, var_w_err);
    // c12 = wp.cross(a1, a2)                                                                 <L 221>
    var_43 = wp::cross(var_36, var_41);
    // c02 = wp.cross(a0, a2)                                                                 <L 222>
    var_44 = wp::cross(var_32, var_41);
    // c01 = wp.cross(a0, a1)                                                                 <L 223>
    var_45 = wp::cross(var_32, var_36);
    // velocities = wp.vec3(                                                                  <L 225>
    // wp.dot(w_err_p, c12) / wp.dot(a0, c12),                                                <L 226>
    var_46 = wp::dot(var_42, var_43);
    var_47 = wp::dot(var_32, var_43);
    var_48 = wp::div(var_46, var_47);
    // wp.dot(w_err_p, c02) / wp.dot(a1, c02),                                                <L 227>
    var_49 = wp::dot(var_42, var_44);
    var_50 = wp::dot(var_36, var_44);
    var_51 = wp::div(var_49, var_50);
    // wp.dot(w_err_p, c01) / wp.dot(a2, c01),                                                <L 228>
    var_52 = wp::dot(var_42, var_45);
    var_53 = wp::dot(var_41, var_45);
    var_54 = wp::div(var_52, var_53);
    var_55 = wp::vec_t<3, wp::float32>(var_48, var_51, var_54);
    // return wp.vec3(angles[0], angles[1], s * angles[2]), wp.vec3(velocities[0], velocities[1], s * velocities[2])       <L 233>
    var_57 = wp::extract(var_16, var_56);
    var_59 = wp::extract(var_16, var_58);
    var_61 = wp::extract(var_16, var_60);
    var_62 = wp::mul(var_8, var_61);
    var_63 = wp::vec_t<3, wp::float32>(var_57, var_59, var_62);
    var_65 = wp::extract(var_55, var_64);
    var_67 = wp::extract(var_55, var_66);
    var_69 = wp::extract(var_55, var_68);
    var_70 = wp::mul(var_8, var_69);
    var_71 = wp::vec_t<3, wp::float32>(var_65, var_67, var_70);
    ret_0 = var_63;
    ret_1 = var_71;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/warp/_src/math.py:452
static CUDA_CALLABLE wp::vec_t<6, wp::float32> transform_twist_0(
    wp::transform_t<wp::float32> var_t,
    wp::vec_t<6, wp::float32> var_x)
{
    //---------
    // primal vars
    wp::quat_t<wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    wp::vec_t<3, wp::float32> var_4;
    wp::vec_t<3, wp::float32> var_5;
    wp::vec_t<3, wp::float32> var_6;
    wp::vec_t<3, wp::float32> var_7;
    wp::vec_t<6, wp::float32> var_8;
    //---------
    // forward
    // def transform_twist(t: wp.transform, x: wp.spatial_vector) -> wp.spatial_vector:       <L 453>
    // q = wp.transform_get_rotation(t)                                                       <L 469>
    var_0 = wp::transform_get_rotation(var_t);
    // p = wp.transform_get_translation(t)                                                    <L 470>
    var_1 = wp::transform_get_translation(var_t);
    // w = wp.spatial_top(x)                                                                  <L 472>
    var_2 = wp::spatial_top(var_x);
    // v = wp.spatial_bottom(x)                                                               <L 473>
    var_3 = wp::spatial_bottom(var_x);
    // w = wp.quat_rotate(q, w)                                                               <L 475>
    var_4 = wp::quat_rotate(var_0, var_2);
    // v = wp.quat_rotate(q, v) + wp.cross(p, w)                                              <L 476>
    var_5 = wp::quat_rotate(var_0, var_3);
    var_6 = wp::cross(var_1, var_4);
    var_7 = wp::add(var_5, var_6);
    // return wp.spatial_vector(w, v)                                                         <L 478>
    var_8 = wp::vec_t<6, wp::float32>(var_4, var_7);
    return var_8;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/math/spatial.py:81
static CUDA_CALLABLE wp::vec_t<6, wp::float32> transform_twist_1(
    wp::transform_t<wp::float32> var_t,
    wp::vec_t<6, wp::float32> var_x)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<6, wp::float32> var_2;
    wp::vec_t<6, wp::float32> var_3;
    wp::vec_t<3, wp::float32> var_4;
    wp::vec_t<3, wp::float32> var_5;
    wp::vec_t<6, wp::float32> var_6;
    //---------
    // forward
    // def transform_twist(t: wp.transform, x: wp.spatial_vector) -> wp.spatial_vector:       <L 82>
    // x_wp = wp.spatial_vector(wp.spatial_bottom(x), wp.spatial_top(x))                      <L 102>
    var_0 = wp::spatial_bottom(var_x);
    var_1 = wp::spatial_top(var_x);
    var_2 = wp::vec_t<6, wp::float32>(var_0, var_1);
    // y_wp = wp.transform_twist(t, x_wp)                                                     <L 103>
    var_3 = transform_twist_0(var_t, var_2);
    // return wp.spatial_vector(wp.spatial_bottom(y_wp), wp.spatial_top(y_wp))                <L 104>
    var_4 = wp::spatial_bottom(var_3);
    var_5 = wp::spatial_top(var_3);
    var_6 = wp::vec_t<6, wp::float32>(var_4, var_5);
    return var_6;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/sim/articulation.py:934
static CUDA_CALLABLE void write_free_distance_motion_subspace_0(
    wp::transform_t<wp::float32> var_X_pa_world,
    wp::vec_t<3, wp::float32> var_x_child_com_world,
    wp::int32 var_qd_start,
    wp::array_t<wp::vec_t<6, wp::float32>> var_joint_S_s)
{
    //---------
    // primal vars
    const wp::float32 var_0 = 1.0;
    const wp::float32 var_1 = 0.0;
    const wp::float32 var_2 = 0.0;
    wp::vec_t<3, wp::float32> var_3;
    wp::vec_t<3, wp::float32> var_4;
    const wp::float32 var_5 = 0.0;
    const wp::float32 var_6 = 1.0;
    const wp::float32 var_7 = 0.0;
    wp::vec_t<3, wp::float32> var_8;
    wp::vec_t<3, wp::float32> var_9;
    const wp::float32 var_10 = 0.0;
    const wp::float32 var_11 = 0.0;
    const wp::float32 var_12 = 1.0;
    wp::vec_t<3, wp::float32> var_13;
    wp::vec_t<3, wp::float32> var_14;
    wp::vec_t<3, wp::float32> var_15;
    wp::vec_t<6, wp::float32> var_16;
    const wp::int32 var_17 = 0;
    wp::int32 var_18;
    wp::vec_t<3, wp::float32> var_19;
    wp::vec_t<6, wp::float32> var_20;
    const wp::int32 var_21 = 1;
    wp::int32 var_22;
    wp::vec_t<3, wp::float32> var_23;
    wp::vec_t<6, wp::float32> var_24;
    const wp::int32 var_25 = 2;
    wp::int32 var_26;
    wp::vec_t<3, wp::float32> var_27;
    wp::vec_t<3, wp::float32> var_28;
    wp::vec_t<6, wp::float32> var_29;
    const wp::int32 var_30 = 3;
    wp::int32 var_31;
    wp::vec_t<3, wp::float32> var_32;
    wp::vec_t<3, wp::float32> var_33;
    wp::vec_t<6, wp::float32> var_34;
    const wp::int32 var_35 = 4;
    wp::int32 var_36;
    wp::vec_t<3, wp::float32> var_37;
    wp::vec_t<3, wp::float32> var_38;
    wp::vec_t<6, wp::float32> var_39;
    const wp::int32 var_40 = 5;
    wp::int32 var_41;
    //---------
    // forward
    // def write_free_distance_motion_subspace(                                               <L 935>
    // axis_world_x = wp.transform_vector(X_pa_world, wp.vec3(1.0, 0.0, 0.0))                 <L 960>
    var_3 = wp::vec_t<3, wp::float32>(var_0, var_1, var_2);
    var_4 = wp::transform_vector(var_X_pa_world, var_3);
    // axis_world_y = wp.transform_vector(X_pa_world, wp.vec3(0.0, 1.0, 0.0))                 <L 961>
    var_8 = wp::vec_t<3, wp::float32>(var_5, var_6, var_7);
    var_9 = wp::transform_vector(var_X_pa_world, var_8);
    // axis_world_z = wp.transform_vector(X_pa_world, wp.vec3(0.0, 0.0, 1.0))                 <L 962>
    var_13 = wp::vec_t<3, wp::float32>(var_10, var_11, var_12);
    var_14 = wp::transform_vector(var_X_pa_world, var_13);
    // joint_S_s[qd_start + 0] = wp.spatial_vector(axis_world_x, wp.vec3())                   <L 964>
    var_15 = wp::vec_t<3, wp::float32>();
    var_16 = wp::vec_t<6, wp::float32>(var_4, var_15);
    var_18 = wp::add(var_qd_start, var_17);
    wp::array_store(var_joint_S_s, var_18, var_16);
    // joint_S_s[qd_start + 1] = wp.spatial_vector(axis_world_y, wp.vec3())                   <L 965>
    var_19 = wp::vec_t<3, wp::float32>();
    var_20 = wp::vec_t<6, wp::float32>(var_9, var_19);
    var_22 = wp::add(var_qd_start, var_21);
    wp::array_store(var_joint_S_s, var_22, var_20);
    // joint_S_s[qd_start + 2] = wp.spatial_vector(axis_world_z, wp.vec3())                   <L 966>
    var_23 = wp::vec_t<3, wp::float32>();
    var_24 = wp::vec_t<6, wp::float32>(var_14, var_23);
    var_26 = wp::add(var_qd_start, var_25);
    wp::array_store(var_joint_S_s, var_26, var_24);
    // joint_S_s[qd_start + 3] = wp.spatial_vector(-wp.cross(axis_world_x, x_child_com_world), axis_world_x)       <L 967>
    var_27 = wp::cross(var_4, var_x_child_com_world);
    var_28 = wp::neg(var_27);
    var_29 = wp::vec_t<6, wp::float32>(var_28, var_4);
    var_31 = wp::add(var_qd_start, var_30);
    wp::array_store(var_joint_S_s, var_31, var_29);
    // joint_S_s[qd_start + 4] = wp.spatial_vector(-wp.cross(axis_world_y, x_child_com_world), axis_world_y)       <L 968>
    var_32 = wp::cross(var_9, var_x_child_com_world);
    var_33 = wp::neg(var_32);
    var_34 = wp::vec_t<6, wp::float32>(var_33, var_9);
    var_36 = wp::add(var_qd_start, var_35);
    wp::array_store(var_joint_S_s, var_36, var_34);
    // joint_S_s[qd_start + 5] = wp.spatial_vector(-wp.cross(axis_world_z, x_child_com_world), axis_world_z)       <L 969>
    var_37 = wp::cross(var_14, var_x_child_com_world);
    var_38 = wp::neg(var_37);
    var_39 = wp::vec_t<6, wp::float32>(var_38, var_14);
    var_41 = wp::add(var_qd_start, var_40);
    wp::array_store(var_joint_S_s, var_41, var_39);
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/sim/articulation.py:972
static CUDA_CALLABLE void jcalc_motion_subspace_0(
    wp::int32 var_joint_type_value,
    wp::array_t<wp::vec_t<3, wp::float32>> var_joint_axis,
    wp::array_t<wp::float32> var_joint_q,
    wp::int32 var_lin_axis_count,
    wp::int32 var_ang_axis_count,
    wp::transform_t<wp::float32> var_X_pa_world,
    wp::transform_t<wp::float32> var_X_wc,
    wp::vec_t<3, wp::float32> var_body_com_child,
    wp::int32 var_q_start,
    wp::int32 var_qd_start,
    wp::array_t<wp::vec_t<6, wp::float32>> var_joint_S_s)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    bool var_1;
    wp::vec_t<3, wp::float32>* var_2;
    wp::vec_t<3, wp::float32> var_3;
    wp::vec_t<3, wp::float32> var_4;
    wp::vec_t<3, wp::float32> var_5;
    wp::vec_t<6, wp::float32> var_6;
    wp::vec_t<6, wp::float32> var_7;
    const wp::int32 var_8 = 1;
    bool var_9;
    wp::vec_t<3, wp::float32>* var_10;
    wp::vec_t<3, wp::float32> var_11;
    wp::vec_t<3, wp::float32> var_12;
    wp::vec_t<3, wp::float32> var_13;
    wp::vec_t<6, wp::float32> var_14;
    wp::vec_t<6, wp::float32> var_15;
    const wp::int32 var_16 = 6;
    bool var_17;
    const wp::int32 var_18 = 0;
    bool var_19;
    const wp::int32 var_20 = 0;
    wp::int32 var_21;
    wp::vec_t<3, wp::float32>* var_22;
    wp::vec_t<3, wp::float32> var_23;
    wp::vec_t<3, wp::float32> var_24;
    wp::vec_t<3, wp::float32> var_25;
    wp::vec_t<6, wp::float32> var_26;
    wp::vec_t<6, wp::float32> var_27;
    const wp::int32 var_28 = 0;
    wp::int32 var_29;
    const wp::int32 var_30 = 1;
    bool var_31;
    const wp::int32 var_32 = 1;
    wp::int32 var_33;
    wp::vec_t<3, wp::float32>* var_34;
    wp::vec_t<3, wp::float32> var_35;
    wp::vec_t<3, wp::float32> var_36;
    wp::vec_t<3, wp::float32> var_37;
    wp::vec_t<6, wp::float32> var_38;
    wp::vec_t<6, wp::float32> var_39;
    const wp::int32 var_40 = 1;
    wp::int32 var_41;
    wp::vec_t<3, wp::float32> var_42;
    wp::vec_t<6, wp::float32> var_43;
    const wp::int32 var_44 = 2;
    bool var_45;
    const wp::int32 var_46 = 2;
    wp::int32 var_47;
    wp::vec_t<3, wp::float32>* var_48;
    wp::vec_t<3, wp::float32> var_49;
    wp::vec_t<3, wp::float32> var_50;
    wp::vec_t<3, wp::float32> var_51;
    wp::vec_t<6, wp::float32> var_52;
    wp::vec_t<6, wp::float32> var_53;
    const wp::int32 var_54 = 2;
    wp::int32 var_55;
    wp::vec_t<3, wp::float32> var_56;
    wp::vec_t<6, wp::float32> var_57;
    wp::int32 var_58;
    wp::int32 var_59;
    const wp::int32 var_60 = 1;
    bool var_61;
    wp::vec_t<3, wp::float32>* var_62;
    wp::vec_t<3, wp::float32> var_63;
    wp::vec_t<3, wp::float32> var_64;
    wp::vec_t<3, wp::float32> var_65;
    wp::vec_t<6, wp::float32> var_66;
    wp::vec_t<6, wp::float32> var_67;
    wp::vec_t<3, wp::float32> var_68;
    const wp::int32 var_69 = 2;
    bool var_70;
    const wp::int32 var_71 = 0;
    wp::int32 var_72;
    wp::vec_t<3, wp::float32>* var_73;
    const wp::int32 var_74 = 1;
    wp::int32 var_75;
    wp::vec_t<3, wp::float32>* var_76;
    const wp::int32 var_77 = 0;
    wp::int32 var_78;
    wp::float32* var_79;
    wp::vec_t<3, wp::float32> var_80;
    wp::vec_t<3, wp::float32> var_81;
    wp::vec_t<3, wp::float32> var_82;
    wp::vec_t<3, wp::float32> var_83;
    wp::float32 var_84;
    wp::vec_t<3, wp::float32> var_85;
    wp::vec_t<6, wp::float32> var_86;
    wp::vec_t<6, wp::float32> var_87;
    const wp::int32 var_88 = 0;
    wp::int32 var_89;
    wp::vec_t<3, wp::float32> var_90;
    wp::vec_t<6, wp::float32> var_91;
    wp::vec_t<6, wp::float32> var_92;
    const wp::int32 var_93 = 1;
    wp::int32 var_94;
    const wp::int32 var_95 = 3;
    bool var_96;
    const wp::int32 var_97 = 0;
    wp::int32 var_98;
    wp::vec_t<3, wp::float32>* var_99;
    const wp::int32 var_100 = 1;
    wp::int32 var_101;
    wp::vec_t<3, wp::float32>* var_102;
    const wp::int32 var_103 = 2;
    wp::int32 var_104;
    wp::vec_t<3, wp::float32>* var_105;
    const wp::int32 var_106 = 0;
    wp::int32 var_107;
    wp::float32* var_108;
    const wp::int32 var_109 = 1;
    wp::int32 var_110;
    wp::float32* var_111;
    wp::vec_t<3, wp::float32> var_112;
    wp::vec_t<3, wp::float32> var_113;
    wp::vec_t<3, wp::float32> var_114;
    wp::vec_t<3, wp::float32> var_115;
    wp::vec_t<3, wp::float32> var_116;
    wp::vec_t<3, wp::float32> var_117;
    wp::float32 var_118;
    wp::float32 var_119;
    wp::vec_t<3, wp::float32> var_120;
    wp::vec_t<6, wp::float32> var_121;
    wp::vec_t<6, wp::float32> var_122;
    const wp::int32 var_123 = 0;
    wp::int32 var_124;
    wp::vec_t<3, wp::float32> var_125;
    wp::vec_t<6, wp::float32> var_126;
    wp::vec_t<6, wp::float32> var_127;
    const wp::int32 var_128 = 1;
    wp::int32 var_129;
    wp::vec_t<3, wp::float32> var_130;
    wp::vec_t<6, wp::float32> var_131;
    wp::vec_t<6, wp::float32> var_132;
    const wp::int32 var_133 = 2;
    wp::int32 var_134;
    wp::vec_t<3, wp::float32> var_135;
    wp::vec_t<3, wp::float32> var_136;
    const wp::int32 var_137 = 2;
    bool var_138;
    const wp::float32 var_139 = 0.0;
    const wp::float32 var_140 = 0.0;
    const wp::float32 var_141 = 0.0;
    const wp::float32 var_142 = 1.0;
    const wp::float32 var_143 = 0.0;
    const wp::float32 var_144 = 0.0;
    wp::vec_t<6, wp::float32> var_145;
    wp::vec_t<6, wp::float32> var_146;
    const wp::float32 var_147 = 0.0;
    const wp::float32 var_148 = 0.0;
    const wp::float32 var_149 = 0.0;
    const wp::float32 var_150 = 0.0;
    const wp::float32 var_151 = 1.0;
    const wp::float32 var_152 = 0.0;
    wp::vec_t<6, wp::float32> var_153;
    wp::vec_t<6, wp::float32> var_154;
    const wp::float32 var_155 = 0.0;
    const wp::float32 var_156 = 0.0;
    const wp::float32 var_157 = 0.0;
    const wp::float32 var_158 = 0.0;
    const wp::float32 var_159 = 0.0;
    const wp::float32 var_160 = 1.0;
    wp::vec_t<6, wp::float32> var_161;
    wp::vec_t<6, wp::float32> var_162;
    const wp::int32 var_163 = 0;
    wp::int32 var_164;
    const wp::int32 var_165 = 1;
    wp::int32 var_166;
    const wp::int32 var_167 = 2;
    wp::int32 var_168;
    bool var_169;
    const wp::int32 var_170 = 4;
    bool var_171;
    const wp::int32 var_172 = 5;
    bool var_173;
    wp::vec_t<3, wp::float32> var_174;
    wp::vec_t<3, wp::float32> var_175;
    wp::vec_t<6, wp::float32> var_176;
    wp::vec_t<3, wp::float32> var_177;
    wp::vec_t<6, wp::float32> var_178;
    //---------
    // forward
    // def jcalc_motion_subspace(                                                             <L 973>
    // if joint_type_value == JointType.PRISMATIC:                                            <L 1016>
    var_1 = (var_joint_type_value == var_0);
    if (var_1) {
        // axis = joint_axis[qd_start]                                                        <L 1017>
        var_2 = wp::address(var_joint_axis, var_qd_start);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // S_s = transform_twist(X_pa_world, wp.spatial_vector(axis, wp.vec3()))              <L 1018>
        var_5 = wp::vec_t<3, wp::float32>();
        var_6 = wp::vec_t<6, wp::float32>(var_3, var_5);
        var_7 = transform_twist_1(var_X_pa_world, var_6);
        // joint_S_s[qd_start] = S_s                                                          <L 1019>
        wp::array_store(var_joint_S_s, var_qd_start, var_7);
    }
    if (!var_1) {
        // elif joint_type_value == JointType.REVOLUTE:                                       <L 1021>
        var_9 = (var_joint_type_value == var_8);
        if (var_9) {
            // axis = joint_axis[qd_start]                                                    <L 1022>
            var_10 = wp::address(var_joint_axis, var_qd_start);
            var_12 = wp::load(var_10);
            var_11 = wp::copy(var_12);
            // S_s = transform_twist(X_pa_world, wp.spatial_vector(wp.vec3(), axis))          <L 1023>
            var_13 = wp::vec_t<3, wp::float32>();
            var_14 = wp::vec_t<6, wp::float32>(var_13, var_11);
            var_15 = transform_twist_1(var_X_pa_world, var_14);
            // joint_S_s[qd_start] = S_s                                                      <L 1024>
            wp::array_store(var_joint_S_s, var_qd_start, var_15);
        }
        if (!var_9) {
            // elif joint_type_value == JointType.D6:                                         <L 1026>
            var_17 = (var_joint_type_value == var_16);
            if (var_17) {
                // if lin_axis_count > 0:                                                     <L 1027>
                var_19 = (var_lin_axis_count > var_18);
                if (var_19) {
                    // axis = joint_axis[qd_start + 0]                                        <L 1028>
                    var_21 = wp::add(var_qd_start, var_20);
                    var_22 = wp::address(var_joint_axis, var_21);
                    var_24 = wp::load(var_22);
                    var_23 = wp::copy(var_24);
                    // S_s = transform_twist(X_pa_world, wp.spatial_vector(axis, wp.vec3()))       <L 1029>
                    var_25 = wp::vec_t<3, wp::float32>();
                    var_26 = wp::vec_t<6, wp::float32>(var_23, var_25);
                    var_27 = transform_twist_1(var_X_pa_world, var_26);
                    // joint_S_s[qd_start + 0] = S_s                                          <L 1030>
                    var_29 = wp::add(var_qd_start, var_28);
                    wp::array_store(var_joint_S_s, var_29, var_27);
                }
                // if lin_axis_count > 1:                                                     <L 1031>
                var_31 = (var_lin_axis_count > var_30);
                if (var_31) {
                    // axis = joint_axis[qd_start + 1]                                        <L 1032>
                    var_33 = wp::add(var_qd_start, var_32);
                    var_34 = wp::address(var_joint_axis, var_33);
                    var_36 = wp::load(var_34);
                    var_35 = wp::copy(var_36);
                    // S_s = transform_twist(X_pa_world, wp.spatial_vector(axis, wp.vec3()))       <L 1033>
                    var_37 = wp::vec_t<3, wp::float32>();
                    var_38 = wp::vec_t<6, wp::float32>(var_35, var_37);
                    var_39 = transform_twist_1(var_X_pa_world, var_38);
                    // joint_S_s[qd_start + 1] = S_s                                          <L 1034>
                    var_41 = wp::add(var_qd_start, var_40);
                    wp::array_store(var_joint_S_s, var_41, var_39);
                }
                var_42 = wp::where(var_31, var_35, var_23);
                var_43 = wp::where(var_31, var_39, var_27);
                // if lin_axis_count > 2:                                                     <L 1035>
                var_45 = (var_lin_axis_count > var_44);
                if (var_45) {
                    // axis = joint_axis[qd_start + 2]                                        <L 1036>
                    var_47 = wp::add(var_qd_start, var_46);
                    var_48 = wp::address(var_joint_axis, var_47);
                    var_50 = wp::load(var_48);
                    var_49 = wp::copy(var_50);
                    // S_s = transform_twist(X_pa_world, wp.spatial_vector(axis, wp.vec3()))       <L 1037>
                    var_51 = wp::vec_t<3, wp::float32>();
                    var_52 = wp::vec_t<6, wp::float32>(var_49, var_51);
                    var_53 = transform_twist_1(var_X_pa_world, var_52);
                    // joint_S_s[qd_start + 2] = S_s                                          <L 1038>
                    var_55 = wp::add(var_qd_start, var_54);
                    wp::array_store(var_joint_S_s, var_55, var_53);
                }
                var_56 = wp::where(var_45, var_49, var_42);
                var_57 = wp::where(var_45, var_53, var_43);
                // iqd = qd_start + lin_axis_count                                            <L 1039>
                var_58 = wp::add(var_qd_start, var_lin_axis_count);
                // iq = q_start + lin_axis_count                                              <L 1040>
                var_59 = wp::add(var_q_start, var_lin_axis_count);
                // if ang_axis_count == 1:                                                    <L 1041>
                var_61 = (var_ang_axis_count == var_60);
                if (var_61) {
                    // axis = joint_axis[iqd]                                                 <L 1042>
                    var_62 = wp::address(var_joint_axis, var_58);
                    var_64 = wp::load(var_62);
                    var_63 = wp::copy(var_64);
                    // joint_S_s[iqd] = transform_twist(X_pa_world, wp.spatial_vector(wp.vec3(), axis))       <L 1043>
                    var_65 = wp::vec_t<3, wp::float32>();
                    var_66 = wp::vec_t<6, wp::float32>(var_65, var_63);
                    var_67 = transform_twist_1(var_X_pa_world, var_66);
                    wp::array_store(var_joint_S_s, var_58, var_67);
                }
                var_68 = wp::where(var_61, var_63, var_56);
                // if ang_axis_count == 2:                                                    <L 1044>
                var_70 = (var_ang_axis_count == var_69);
                if (var_70) {
                    // a0, a1 = transform_2d_rotational_axes(joint_axis[iqd + 0], joint_axis[iqd + 1], joint_q[iq + 0])       <L 1045>
                    var_72 = wp::add(var_58, var_71);
                    var_73 = wp::address(var_joint_axis, var_72);
                    var_75 = wp::add(var_58, var_74);
                    var_76 = wp::address(var_joint_axis, var_75);
                    var_78 = wp::add(var_59, var_77);
                    var_79 = wp::address(var_joint_q, var_78);
                    var_82 = wp::load(var_73);
                    var_83 = wp::load(var_76);
                    var_84 = wp::load(var_79);
                    transform_2d_rotational_axes_0(var_82, var_83, var_84, var_80, var_81);
                    // joint_S_s[iqd + 0] = transform_twist(X_pa_world, wp.spatial_vector(wp.vec3(), a0))       <L 1046>
                    var_85 = wp::vec_t<3, wp::float32>();
                    var_86 = wp::vec_t<6, wp::float32>(var_85, var_80);
                    var_87 = transform_twist_1(var_X_pa_world, var_86);
                    var_89 = wp::add(var_58, var_88);
                    wp::array_store(var_joint_S_s, var_89, var_87);
                    // joint_S_s[iqd + 1] = transform_twist(X_pa_world, wp.spatial_vector(wp.vec3(), a1))       <L 1047>
                    var_90 = wp::vec_t<3, wp::float32>();
                    var_91 = wp::vec_t<6, wp::float32>(var_90, var_81);
                    var_92 = transform_twist_1(var_X_pa_world, var_91);
                    var_94 = wp::add(var_58, var_93);
                    wp::array_store(var_joint_S_s, var_94, var_92);
                }
                // if ang_axis_count == 3:                                                    <L 1048>
                var_96 = (var_ang_axis_count == var_95);
                if (var_96) {
                    // a0, a1, a2 = transform_3d_rotational_axes(                             <L 1049>
                    // joint_axis[iqd + 0],                                                   <L 1050>
                    var_98 = wp::add(var_58, var_97);
                    var_99 = wp::address(var_joint_axis, var_98);
                    // joint_axis[iqd + 1],                                                   <L 1051>
                    var_101 = wp::add(var_58, var_100);
                    var_102 = wp::address(var_joint_axis, var_101);
                    // joint_axis[iqd + 2],                                                   <L 1052>
                    var_104 = wp::add(var_58, var_103);
                    var_105 = wp::address(var_joint_axis, var_104);
                    // joint_q[iq + 0],                                                       <L 1053>
                    var_107 = wp::add(var_59, var_106);
                    var_108 = wp::address(var_joint_q, var_107);
                    // joint_q[iq + 1],                                                       <L 1054>
                    var_110 = wp::add(var_59, var_109);
                    var_111 = wp::address(var_joint_q, var_110);
                    var_115 = wp::load(var_99);
                    var_116 = wp::load(var_102);
                    var_117 = wp::load(var_105);
                    var_118 = wp::load(var_108);
                    var_119 = wp::load(var_111);
                    transform_3d_rotational_axes_0(var_115, var_116, var_117, var_118, var_119, var_112, var_113, var_114);
                    // joint_S_s[iqd + 0] = transform_twist(X_pa_world, wp.spatial_vector(wp.vec3(), a0))       <L 1056>
                    var_120 = wp::vec_t<3, wp::float32>();
                    var_121 = wp::vec_t<6, wp::float32>(var_120, var_112);
                    var_122 = transform_twist_1(var_X_pa_world, var_121);
                    var_124 = wp::add(var_58, var_123);
                    wp::array_store(var_joint_S_s, var_124, var_122);
                    // joint_S_s[iqd + 1] = transform_twist(X_pa_world, wp.spatial_vector(wp.vec3(), a1))       <L 1057>
                    var_125 = wp::vec_t<3, wp::float32>();
                    var_126 = wp::vec_t<6, wp::float32>(var_125, var_113);
                    var_127 = transform_twist_1(var_X_pa_world, var_126);
                    var_129 = wp::add(var_58, var_128);
                    wp::array_store(var_joint_S_s, var_129, var_127);
                    // joint_S_s[iqd + 2] = transform_twist(X_pa_world, wp.spatial_vector(wp.vec3(), a2))       <L 1058>
                    var_130 = wp::vec_t<3, wp::float32>();
                    var_131 = wp::vec_t<6, wp::float32>(var_130, var_114);
                    var_132 = transform_twist_1(var_X_pa_world, var_131);
                    var_134 = wp::add(var_58, var_133);
                    wp::array_store(var_joint_S_s, var_134, var_132);
                }
                var_135 = wp::where(var_96, var_112, var_80);
                var_136 = wp::where(var_96, var_113, var_81);
            }
            if (!var_17) {
                // elif joint_type_value == JointType.BALL:                                   <L 1060>
                var_138 = (var_joint_type_value == var_137);
                if (var_138) {
                    // S_0 = transform_twist(X_pa_world, wp.spatial_vector(0.0, 0.0, 0.0, 1.0, 0.0, 0.0))       <L 1061>
                    var_145 = wp::vec_t<6, wp::float32>({var_139, var_140, var_141, var_142, var_143, var_144});
                    var_146 = transform_twist_1(var_X_pa_world, var_145);
                    // S_1 = transform_twist(X_pa_world, wp.spatial_vector(0.0, 0.0, 0.0, 0.0, 1.0, 0.0))       <L 1062>
                    var_153 = wp::vec_t<6, wp::float32>({var_147, var_148, var_149, var_150, var_151, var_152});
                    var_154 = transform_twist_1(var_X_pa_world, var_153);
                    // S_2 = transform_twist(X_pa_world, wp.spatial_vector(0.0, 0.0, 0.0, 0.0, 0.0, 1.0))       <L 1063>
                    var_161 = wp::vec_t<6, wp::float32>({var_155, var_156, var_157, var_158, var_159, var_160});
                    var_162 = transform_twist_1(var_X_pa_world, var_161);
                    // joint_S_s[qd_start + 0] = S_0                                          <L 1064>
                    var_164 = wp::add(var_qd_start, var_163);
                    wp::array_store(var_joint_S_s, var_164, var_146);
                    // joint_S_s[qd_start + 1] = S_1                                          <L 1065>
                    var_166 = wp::add(var_qd_start, var_165);
                    wp::array_store(var_joint_S_s, var_166, var_154);
                    // joint_S_s[qd_start + 2] = S_2                                          <L 1066>
                    var_168 = wp::add(var_qd_start, var_167);
                    wp::array_store(var_joint_S_s, var_168, var_162);
                }
                if (!var_138) {
                    // elif joint_type_value == JointType.FREE or joint_type_value == JointType.DISTANCE:       <L 1068>
                    var_171 = (var_joint_type_value == var_170);
                    var_169 = var_171;
                    if (!var_169) {
                        var_173 = (var_joint_type_value == var_172);
                        var_169 = var_169 || var_173;
                    }
                    if (var_169) {
                        // x_child_com_world = wp.transform_point(X_wc, body_com_child)       <L 1069>
                        var_174 = wp::transform_point(var_X_wc, var_body_com_child);
                        // write_free_distance_motion_subspace(X_pa_world, x_child_com_world, qd_start, joint_S_s)       <L 1070>
                        write_free_distance_motion_subspace_0(var_X_pa_world, var_174, var_qd_start, var_joint_S_s);
                    }
                }
            }
        }
        var_175 = wp::where(var_9, var_11, var_68);
        var_176 = wp::where(var_9, var_15, var_57);
    }
    var_177 = wp::where(var_1, var_3, var_175);
    var_178 = wp::where(var_1, var_7, var_176);
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/sim/articulation.py:36
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/sim/articulation.py:61
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/sim/articulation.py:127
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/sim/articulation.py:151
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/warp/_src/math.py:131
static CUDA_CALLABLE void adj_velocity_at_point_0(
    wp::vec_t<6, wp::float32> var_qd,
    wp::vec_t<3, wp::float32> var_r,
    wp::vec_t<6, wp::float32> & adj_qd,
    wp::vec_t<3, wp::float32> & adj_r,
    wp::vec_t<3, wp::float32> & adj_ret)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    //---------
    // dual vars
    wp::vec_t<3, wp::float32> adj_0 = {};
    wp::vec_t<3, wp::float32> adj_1 = {};
    wp::vec_t<3, wp::float32> adj_2 = {};
    wp::vec_t<3, wp::float32> adj_3 = {};
    //---------
    // forward
    // def velocity_at_point(qd: wp.spatial_vector, r: wp.vec3) -> wp.vec3:                   <L 132>
    // return wp.spatial_bottom(qd) + wp.cross(wp.spatial_top(qd), r)                         <L 148>
    var_0 = wp::spatial_bottom(var_qd);
    var_1 = wp::spatial_top(var_qd);
    var_2 = wp::cross(var_1, var_r);
    var_3 = wp::add(var_0, var_2);
    goto label0;
    //---------
    // reverse
    label0:;
    adj_3 += adj_ret;
    wp::adj_add(var_0, var_2, adj_0, adj_2, adj_3);
    wp::adj_cross(var_1, var_r, adj_1, adj_r, adj_2);
    wp::adj_spatial_top(var_qd, adj_qd, adj_1);
    wp::adj_spatial_bottom(var_qd, adj_qd, adj_0);
    // adj: return wp.spatial_bottom(qd) + wp.cross(wp.spatial_top(qd), r)                    <L 148>
    // adj: def velocity_at_point(qd: wp.spatial_vector, r: wp.vec3) -> wp.vec3:              <L 132>
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/math/spatial.py:53
static CUDA_CALLABLE void adj_velocity_at_point_1(
    wp::vec_t<6, wp::float32> var_qd,
    wp::vec_t<3, wp::float32> var_r,
    wp::vec_t<6, wp::float32> & adj_qd,
    wp::vec_t<3, wp::float32> & adj_r,
    wp::vec_t<3, wp::float32> & adj_ret)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<6, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    //---------
    // dual vars
    wp::vec_t<3, wp::float32> adj_0 = {};
    wp::vec_t<3, wp::float32> adj_1 = {};
    wp::vec_t<6, wp::float32> adj_2 = {};
    wp::vec_t<3, wp::float32> adj_3 = {};
    //---------
    // forward
    // def velocity_at_point(qd: wp.spatial_vector, r: wp.vec3) -> wp.vec3:                   <L 54>
    // qd_wp = wp.spatial_vector(wp.spatial_bottom(qd), wp.spatial_top(qd))                   <L 77>
    var_0 = wp::spatial_bottom(var_qd);
    var_1 = wp::spatial_top(var_qd);
    var_2 = wp::vec_t<6, wp::float32>(var_0, var_1);
    // return wp.velocity_at_point(qd_wp, r)                                                  <L 78>
    var_3 = velocity_at_point_0(var_2, var_r);
    goto label0;
    //---------
    // reverse
    label0:;
    adj_3 += adj_ret;
    adj_velocity_at_point_0(var_2, var_r, adj_2, adj_r, adj_3);
    // adj: return wp.velocity_at_point(qd_wp, r)                                             <L 78>
    wp::adj_vec_t(var_0, var_1, adj_0, adj_1, adj_2);
    wp::adj_spatial_top(var_qd, adj_qd, adj_1);
    wp::adj_spatial_bottom(var_qd, adj_qd, adj_0);
    // adj: qd_wp = wp.spatial_vector(wp.spatial_bottom(qd), wp.spatial_top(qd))              <L 77>
    // adj: def velocity_at_point(qd: wp.spatial_vector, r: wp.vec3) -> wp.vec3:              <L 54>
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/sim/articulation.py:14
static CUDA_CALLABLE void adj_com_twist_to_point_velocity_0(
    wp::vec_t<6, wp::float32> var_qd,
    wp::transform_t<wp::float32> var_X_wb,
    wp::vec_t<3, wp::float32> var_body_com,
    wp::vec_t<3, wp::float32> var_point,
    wp::vec_t<6, wp::float32> & adj_qd,
    wp::transform_t<wp::float32> & adj_X_wb,
    wp::vec_t<3, wp::float32> & adj_body_com,
    wp::vec_t<3, wp::float32> & adj_point,
    wp::vec_t<3, wp::float32> & adj_ret)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    //---------
    // dual vars
    wp::vec_t<3, wp::float32> adj_0 = {};
    wp::vec_t<3, wp::float32> adj_1 = {};
    wp::vec_t<3, wp::float32> adj_2 = {};
    //---------
    // forward
    // def com_twist_to_point_velocity(qd: wp.spatial_vector, X_wb: wp.transform, body_com: wp.vec3, point: wp.vec3):       <L 15>
    // return velocity_at_point(qd, point - wp.transform_point(X_wb, body_com))               <L 17>
    var_0 = wp::transform_point(var_X_wb, var_body_com);
    var_1 = wp::sub(var_point, var_0);
    var_2 = velocity_at_point_1(var_qd, var_1);
    goto label0;
    //---------
    // reverse
    label0:;
    adj_2 += adj_ret;
    adj_velocity_at_point_1(var_qd, var_1, adj_qd, adj_1, adj_2);
    wp::adj_sub(var_point, var_0, adj_point, adj_0, adj_1);
    wp::adj_transform_point(var_X_wb, var_body_com, adj_X_wb, adj_body_com, adj_0);
    // adj: return velocity_at_point(qd, point - wp.transform_point(X_wb, body_com))          <L 17>
    // adj: def com_twist_to_point_velocity(qd: wp.spatial_vector, X_wb: wp.transform, body_com: wp.vec3, point: wp.vec3):  <L 15>
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/sim/articulation.py:28
static CUDA_CALLABLE void adj_com_twist_to_origin_twist_0(
    wp::vec_t<6, wp::float32> var_qd,
    wp::transform_t<wp::float32> var_X_wb,
    wp::vec_t<3, wp::float32> var_body_com,
    wp::vec_t<6, wp::float32> & adj_qd,
    wp::transform_t<wp::float32> & adj_X_wb,
    wp::vec_t<3, wp::float32> & adj_body_com,
    wp::vec_t<6, wp::float32> & adj_ret)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    wp::vec_t<3, wp::float32> var_4;
    wp::vec_t<6, wp::float32> var_5;
    //---------
    // dual vars
    wp::vec_t<3, wp::float32> adj_0 = {};
    wp::vec_t<3, wp::float32> adj_1 = {};
    wp::vec_t<3, wp::float32> adj_2 = {};
    wp::vec_t<3, wp::float32> adj_3 = {};
    wp::vec_t<3, wp::float32> adj_4 = {};
    wp::vec_t<6, wp::float32> adj_5 = {};
    //---------
    // forward
    // def com_twist_to_origin_twist(qd: wp.spatial_vector, X_wb: wp.transform, body_com: wp.vec3):       <L 29>
    // omega = wp.spatial_bottom(qd)                                                          <L 31>
    var_0 = wp::spatial_bottom(var_qd);
    // v_origin = wp.spatial_top(qd) - wp.cross(omega, wp.transform_vector(X_wb, body_com))       <L 32>
    var_1 = wp::spatial_top(var_qd);
    var_2 = wp::transform_vector(var_X_wb, var_body_com);
    var_3 = wp::cross(var_0, var_2);
    var_4 = wp::sub(var_1, var_3);
    // return wp.spatial_vector(v_origin, omega)                                              <L 33>
    var_5 = wp::vec_t<6, wp::float32>(var_4, var_0);
    goto label0;
    //---------
    // reverse
    label0:;
    adj_5 += adj_ret;
    wp::adj_vec_t(var_4, var_0, adj_4, adj_0, adj_5);
    // adj: return wp.spatial_vector(v_origin, omega)                                         <L 33>
    wp::adj_sub(var_1, var_3, adj_1, adj_3, adj_4);
    wp::adj_cross(var_0, var_2, adj_0, adj_2, adj_3);
    wp::adj_transform_vector(var_X_wb, var_body_com, adj_X_wb, adj_body_com, adj_2);
    wp::adj_spatial_top(var_qd, adj_qd, adj_1);
    // adj: v_origin = wp.spatial_top(qd) - wp.cross(omega, wp.transform_vector(X_wb, body_com))  <L 32>
    wp::adj_spatial_bottom(var_qd, adj_qd, adj_0);
    // adj: omega = wp.spatial_bottom(qd)                                                     <L 31>
    // adj: def com_twist_to_origin_twist(qd: wp.spatial_vector, X_wb: wp.transform, body_com: wp.vec3):  <L 29>
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/sim/articulation.py:20
static CUDA_CALLABLE void adj_origin_twist_to_com_twist_0(
    wp::vec_t<6, wp::float32> var_qd,
    wp::transform_t<wp::float32> var_X_wb,
    wp::vec_t<3, wp::float32> var_body_com,
    wp::vec_t<6, wp::float32> & adj_qd,
    wp::transform_t<wp::float32> & adj_X_wb,
    wp::vec_t<3, wp::float32> & adj_body_com,
    wp::vec_t<6, wp::float32> & adj_ret)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::vec_t<6, wp::float32> var_3;
    //---------
    // dual vars
    wp::vec_t<3, wp::float32> adj_0 = {};
    wp::vec_t<3, wp::float32> adj_1 = {};
    wp::vec_t<3, wp::float32> adj_2 = {};
    wp::vec_t<6, wp::float32> adj_3 = {};
    //---------
    // forward
    // def origin_twist_to_com_twist(qd: wp.spatial_vector, X_wb: wp.transform, body_com: wp.vec3):       <L 21>
    // omega = wp.spatial_bottom(qd)                                                          <L 23>
    var_0 = wp::spatial_bottom(var_qd);
    // v_com = velocity_at_point(qd, wp.transform_vector(X_wb, body_com))                     <L 24>
    var_1 = wp::transform_vector(var_X_wb, var_body_com);
    var_2 = velocity_at_point_1(var_qd, var_1);
    // return wp.spatial_vector(v_com, omega)                                                 <L 25>
    var_3 = wp::vec_t<6, wp::float32>(var_2, var_0);
    goto label0;
    //---------
    // reverse
    label0:;
    adj_3 += adj_ret;
    wp::adj_vec_t(var_2, var_0, adj_2, adj_0, adj_3);
    // adj: return wp.spatial_vector(v_com, omega)                                            <L 25>
    adj_velocity_at_point_1(var_qd, var_1, adj_qd, adj_1, adj_2);
    wp::adj_transform_vector(var_X_wb, var_body_com, adj_X_wb, adj_body_com, adj_1);
    // adj: v_com = velocity_at_point(qd, wp.transform_vector(X_wb, body_com))                <L 24>
    wp::adj_spatial_bottom(var_qd, adj_qd, adj_0);
    // adj: omega = wp.spatial_bottom(qd)                                                     <L 23>
    // adj: def origin_twist_to_com_twist(qd: wp.spatial_vector, X_wb: wp.transform, body_com: wp.vec3):  <L 21>
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/sim/articulation.py:236
static CUDA_CALLABLE void adj_eval_single_articulation_fk_0(
    wp::int32 var_joint_start,
    wp::int32 var_joint_end,
    wp::array_t<wp::int32> var_joint_articulation,
    wp::array_t<wp::float32> var_joint_q,
    wp::array_t<wp::float32> var_joint_qd,
    wp::array_t<wp::int32> var_joint_q_start,
    wp::array_t<wp::int32> var_joint_qd_start,
    wp::array_t<wp::int32> var_joint_type,
    wp::array_t<wp::int32> var_joint_parent,
    wp::array_t<wp::int32> var_joint_child,
    wp::array_t<wp::transform_t<wp::float32>> var_joint_X_p,
    wp::array_t<wp::transform_t<wp::float32>> var_joint_X_c,
    wp::array_t<wp::vec_t<3, wp::float32>> var_joint_axis,
    wp::array_t<wp::int32> var_joint_dof_dim,
    wp::array_t<wp::vec_t<3, wp::float32>> var_body_com,
    wp::array_t<wp::int32> var_body_flags,
    wp::int32 var_body_flag_filter,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::vec_t<6, wp::float32>> var_body_qd,
    wp::int32 & adj_joint_start,
    wp::int32 & adj_joint_end,
    wp::array_t<wp::int32> & adj_joint_articulation,
    wp::array_t<wp::float32> & adj_joint_q,
    wp::array_t<wp::float32> & adj_joint_qd,
    wp::array_t<wp::int32> & adj_joint_q_start,
    wp::array_t<wp::int32> & adj_joint_qd_start,
    wp::array_t<wp::int32> & adj_joint_type,
    wp::array_t<wp::int32> & adj_joint_parent,
    wp::array_t<wp::int32> & adj_joint_child,
    wp::array_t<wp::transform_t<wp::float32>> & adj_joint_X_p,
    wp::array_t<wp::transform_t<wp::float32>> & adj_joint_X_c,
    wp::array_t<wp::vec_t<3, wp::float32>> & adj_joint_axis,
    wp::array_t<wp::int32> & adj_joint_dof_dim,
    wp::array_t<wp::vec_t<3, wp::float32>> & adj_body_com,
    wp::array_t<wp::int32> & adj_body_flags,
    wp::int32 & adj_body_flag_filter,
    wp::array_t<wp::transform_t<wp::float32>> & adj_body_q,
    wp::array_t<wp::vec_t<6, wp::float32>> & adj_body_qd)
{
    //---------
    // primal vars
    wp::range_t var_0;
    wp::int32 var_1;
    wp::int32* var_2;
    wp::int32 var_3;
    wp::int32 var_4;
    const wp::int32 var_5 = -1;
    bool var_6;
    wp::int32* var_7;
    wp::int32 var_8;
    wp::int32 var_9;
    wp::int32* var_10;
    wp::int32 var_11;
    wp::int32 var_12;
    wp::int32* var_13;
    wp::int32 var_14;
    wp::int32 var_15;
    const wp::int32 var_16 = 7;
    bool var_17;
    wp::transform_t<wp::float32>* var_18;
    wp::transform_t<wp::float32> var_19;
    wp::transform_t<wp::float32> var_20;
    wp::transform_t<wp::float32>* var_21;
    wp::transform_t<wp::float32> var_22;
    wp::transform_t<wp::float32> var_23;
    wp::int32* var_24;
    wp::int32 var_25;
    wp::int32 var_26;
    wp::int32* var_27;
    wp::int32 var_28;
    wp::int32 var_29;
    const wp::int32 var_30 = 0;
    wp::int32* var_31;
    wp::int32 var_32;
    wp::int32 var_33;
    const wp::int32 var_34 = 1;
    wp::int32* var_35;
    wp::int32 var_36;
    wp::int32 var_37;
    wp::transform_t<wp::float32> var_38;
    wp::vec_t<3, wp::float32> var_39;
    wp::vec_t<3, wp::float32> var_40;
    wp::vec_t<6, wp::float32> var_41;
    const wp::int32 var_42 = 0;
    bool var_43;
    wp::vec_t<3, wp::float32>* var_44;
    wp::vec_t<3, wp::float32> var_45;
    wp::vec_t<3, wp::float32> var_46;
    wp::float32* var_47;
    wp::float32 var_48;
    wp::float32 var_49;
    wp::float32* var_50;
    wp::float32 var_51;
    wp::float32 var_52;
    wp::vec_t<3, wp::float32> var_53;
    wp::quat_t<wp::float32> var_54;
    wp::transform_t<wp::float32> var_55;
    wp::vec_t<3, wp::float32> var_56;
    wp::vec_t<3, wp::float32> var_57;
    wp::vec_t<6, wp::float32> var_58;
    wp::transform_t<wp::float32> var_59;
    wp::vec_t<6, wp::float32> var_60;
    const wp::int32 var_61 = 1;
    bool var_62;
    wp::vec_t<3, wp::float32>* var_63;
    wp::vec_t<3, wp::float32> var_64;
    wp::vec_t<3, wp::float32> var_65;
    wp::float32* var_66;
    wp::float32 var_67;
    wp::float32 var_68;
    wp::float32* var_69;
    wp::float32 var_70;
    wp::float32 var_71;
    wp::vec_t<3, wp::float32> var_72;
    wp::quat_t<wp::float32> var_73;
    wp::transform_t<wp::float32> var_74;
    wp::vec_t<3, wp::float32> var_75;
    wp::vec_t<3, wp::float32> var_76;
    wp::vec_t<6, wp::float32> var_77;
    wp::transform_t<wp::float32> var_78;
    wp::vec_t<6, wp::float32> var_79;
    wp::vec_t<3, wp::float32> var_80;
    wp::float32 var_81;
    wp::float32 var_82;
    const wp::int32 var_83 = 2;
    bool var_84;
    const wp::int32 var_85 = 0;
    wp::int32 var_86;
    wp::float32* var_87;
    const wp::int32 var_88 = 1;
    wp::int32 var_89;
    wp::float32* var_90;
    const wp::int32 var_91 = 2;
    wp::int32 var_92;
    wp::float32* var_93;
    const wp::int32 var_94 = 3;
    wp::int32 var_95;
    wp::float32* var_96;
    wp::quat_t<wp::float32> var_97;
    wp::float32 var_98;
    wp::float32 var_99;
    wp::float32 var_100;
    wp::float32 var_101;
    const wp::int32 var_102 = 0;
    wp::int32 var_103;
    wp::float32* var_104;
    const wp::int32 var_105 = 1;
    wp::int32 var_106;
    wp::float32* var_107;
    const wp::int32 var_108 = 2;
    wp::int32 var_109;
    wp::float32* var_110;
    wp::vec_t<3, wp::float32> var_111;
    wp::float32 var_112;
    wp::float32 var_113;
    wp::float32 var_114;
    wp::vec_t<3, wp::float32> var_115;
    wp::transform_t<wp::float32> var_116;
    wp::vec_t<3, wp::float32> var_117;
    wp::vec_t<6, wp::float32> var_118;
    wp::transform_t<wp::float32> var_119;
    wp::vec_t<6, wp::float32> var_120;
    bool var_121;
    const wp::int32 var_122 = 4;
    bool var_123;
    const wp::int32 var_124 = 5;
    bool var_125;
    const wp::int32 var_126 = 0;
    wp::int32 var_127;
    wp::float32* var_128;
    const wp::int32 var_129 = 1;
    wp::int32 var_130;
    wp::float32* var_131;
    const wp::int32 var_132 = 2;
    wp::int32 var_133;
    wp::float32* var_134;
    wp::vec_t<3, wp::float32> var_135;
    wp::float32 var_136;
    wp::float32 var_137;
    wp::float32 var_138;
    const wp::int32 var_139 = 3;
    wp::int32 var_140;
    wp::float32* var_141;
    const wp::int32 var_142 = 4;
    wp::int32 var_143;
    wp::float32* var_144;
    const wp::int32 var_145 = 5;
    wp::int32 var_146;
    wp::float32* var_147;
    const wp::int32 var_148 = 6;
    wp::int32 var_149;
    wp::float32* var_150;
    wp::quat_t<wp::float32> var_151;
    wp::float32 var_152;
    wp::float32 var_153;
    wp::float32 var_154;
    wp::float32 var_155;
    wp::transform_t<wp::float32> var_156;
    const wp::int32 var_157 = 0;
    wp::int32 var_158;
    wp::float32* var_159;
    const wp::int32 var_160 = 1;
    wp::int32 var_161;
    wp::float32* var_162;
    const wp::int32 var_163 = 2;
    wp::int32 var_164;
    wp::float32* var_165;
    wp::vec_t<3, wp::float32> var_166;
    wp::float32 var_167;
    wp::float32 var_168;
    wp::float32 var_169;
    const wp::int32 var_170 = 3;
    wp::int32 var_171;
    wp::float32* var_172;
    const wp::int32 var_173 = 4;
    wp::int32 var_174;
    wp::float32* var_175;
    const wp::int32 var_176 = 5;
    wp::int32 var_177;
    wp::float32* var_178;
    wp::vec_t<3, wp::float32> var_179;
    wp::float32 var_180;
    wp::float32 var_181;
    wp::float32 var_182;
    wp::vec_t<6, wp::float32> var_183;
    wp::transform_t<wp::float32> var_184;
    wp::vec_t<6, wp::float32> var_185;
    wp::transform_t<wp::float32> var_186;
    wp::vec_t<6, wp::float32> var_187;
    const wp::int32 var_188 = 6;
    bool var_189;
    const wp::float32 var_190 = 0.0;
    wp::vec_t<3, wp::float32> var_191;
    wp::quat_t<wp::float32> var_192;
    const wp::float32 var_193 = 0.0;
    wp::vec_t<3, wp::float32> var_194;
    const wp::float32 var_195 = 0.0;
    wp::vec_t<3, wp::float32> var_196;
    const wp::int32 var_197 = 0;
    bool var_198;
    const wp::int32 var_199 = 0;
    wp::int32 var_200;
    wp::vec_t<3, wp::float32>* var_201;
    wp::vec_t<3, wp::float32> var_202;
    wp::vec_t<3, wp::float32> var_203;
    const wp::int32 var_204 = 0;
    wp::int32 var_205;
    wp::float32* var_206;
    wp::vec_t<3, wp::float32> var_207;
    wp::float32 var_208;
    wp::vec_t<3, wp::float32> var_209;
    const wp::int32 var_210 = 0;
    wp::int32 var_211;
    wp::float32* var_212;
    wp::vec_t<3, wp::float32> var_213;
    wp::float32 var_214;
    wp::vec_t<3, wp::float32> var_215;
    wp::vec_t<3, wp::float32> var_216;
    wp::vec_t<3, wp::float32> var_217;
    wp::vec_t<3, wp::float32> var_218;
    const wp::int32 var_219 = 1;
    bool var_220;
    const wp::int32 var_221 = 1;
    wp::int32 var_222;
    wp::vec_t<3, wp::float32>* var_223;
    wp::vec_t<3, wp::float32> var_224;
    wp::vec_t<3, wp::float32> var_225;
    const wp::int32 var_226 = 1;
    wp::int32 var_227;
    wp::float32* var_228;
    wp::vec_t<3, wp::float32> var_229;
    wp::float32 var_230;
    wp::vec_t<3, wp::float32> var_231;
    const wp::int32 var_232 = 1;
    wp::int32 var_233;
    wp::float32* var_234;
    wp::vec_t<3, wp::float32> var_235;
    wp::float32 var_236;
    wp::vec_t<3, wp::float32> var_237;
    wp::vec_t<3, wp::float32> var_238;
    wp::vec_t<3, wp::float32> var_239;
    wp::vec_t<3, wp::float32> var_240;
    const wp::int32 var_241 = 2;
    bool var_242;
    const wp::int32 var_243 = 2;
    wp::int32 var_244;
    wp::vec_t<3, wp::float32>* var_245;
    wp::vec_t<3, wp::float32> var_246;
    wp::vec_t<3, wp::float32> var_247;
    const wp::int32 var_248 = 2;
    wp::int32 var_249;
    wp::float32* var_250;
    wp::vec_t<3, wp::float32> var_251;
    wp::float32 var_252;
    wp::vec_t<3, wp::float32> var_253;
    const wp::int32 var_254 = 2;
    wp::int32 var_255;
    wp::float32* var_256;
    wp::vec_t<3, wp::float32> var_257;
    wp::float32 var_258;
    wp::vec_t<3, wp::float32> var_259;
    wp::vec_t<3, wp::float32> var_260;
    wp::vec_t<3, wp::float32> var_261;
    wp::vec_t<3, wp::float32> var_262;
    wp::int32 var_263;
    wp::int32 var_264;
    const wp::int32 var_265 = 1;
    bool var_266;
    wp::vec_t<3, wp::float32>* var_267;
    wp::vec_t<3, wp::float32> var_268;
    wp::vec_t<3, wp::float32> var_269;
    wp::float32* var_270;
    wp::quat_t<wp::float32> var_271;
    wp::float32 var_272;
    wp::float32* var_273;
    wp::vec_t<3, wp::float32> var_274;
    wp::float32 var_275;
    wp::vec_t<3, wp::float32> var_276;
    wp::quat_t<wp::float32> var_277;
    wp::vec_t<3, wp::float32> var_278;
    const wp::int32 var_279 = 2;
    bool var_280;
    const wp::int32 var_281 = 0;
    wp::int32 var_282;
    wp::vec_t<3, wp::float32>* var_283;
    const wp::int32 var_284 = 1;
    wp::int32 var_285;
    wp::vec_t<3, wp::float32>* var_286;
    const wp::int32 var_287 = 0;
    wp::int32 var_288;
    wp::float32* var_289;
    const wp::int32 var_290 = 1;
    wp::int32 var_291;
    wp::float32* var_292;
    const wp::int32 var_293 = 0;
    wp::int32 var_294;
    wp::float32* var_295;
    const wp::int32 var_296 = 1;
    wp::int32 var_297;
    wp::float32* var_298;
    wp::quat_t<wp::float32> var_299;
    wp::vec_t<3, wp::float32> var_300;
    wp::vec_t<3, wp::float32> var_301;
    wp::vec_t<3, wp::float32> var_302;
    wp::float32 var_303;
    wp::float32 var_304;
    wp::float32 var_305;
    wp::float32 var_306;
    wp::quat_t<wp::float32> var_307;
    wp::vec_t<3, wp::float32> var_308;
    const wp::int32 var_309 = 3;
    bool var_310;
    const wp::int32 var_311 = 0;
    wp::int32 var_312;
    wp::vec_t<3, wp::float32>* var_313;
    const wp::int32 var_314 = 1;
    wp::int32 var_315;
    wp::vec_t<3, wp::float32>* var_316;
    const wp::int32 var_317 = 2;
    wp::int32 var_318;
    wp::vec_t<3, wp::float32>* var_319;
    const wp::int32 var_320 = 0;
    wp::int32 var_321;
    wp::float32* var_322;
    const wp::int32 var_323 = 1;
    wp::int32 var_324;
    wp::float32* var_325;
    const wp::int32 var_326 = 2;
    wp::int32 var_327;
    wp::float32* var_328;
    const wp::int32 var_329 = 0;
    wp::int32 var_330;
    wp::float32* var_331;
    const wp::int32 var_332 = 1;
    wp::int32 var_333;
    wp::float32* var_334;
    const wp::int32 var_335 = 2;
    wp::int32 var_336;
    wp::float32* var_337;
    wp::quat_t<wp::float32> var_338;
    wp::vec_t<3, wp::float32> var_339;
    wp::vec_t<3, wp::float32> var_340;
    wp::vec_t<3, wp::float32> var_341;
    wp::vec_t<3, wp::float32> var_342;
    wp::float32 var_343;
    wp::float32 var_344;
    wp::float32 var_345;
    wp::float32 var_346;
    wp::float32 var_347;
    wp::float32 var_348;
    wp::quat_t<wp::float32> var_349;
    wp::vec_t<3, wp::float32> var_350;
    wp::transform_t<wp::float32> var_351;
    wp::vec_t<6, wp::float32> var_352;
    wp::transform_t<wp::float32> var_353;
    wp::vec_t<6, wp::float32> var_354;
    wp::vec_t<3, wp::float32> var_355;
    wp::transform_t<wp::float32> var_356;
    const wp::int32 var_357 = 0;
    bool var_358;
    wp::transform_t<wp::float32>* var_359;
    wp::transform_t<wp::float32> var_360;
    wp::transform_t<wp::float32> var_361;
    wp::transform_t<wp::float32> var_362;
    wp::transform_t<wp::float32> var_363;
    wp::transform_t<wp::float32> var_364;
    wp::transform_t<wp::float32> var_365;
    wp::transform_t<wp::float32> var_366;
    wp::vec_t<3, wp::float32> var_367;
    wp::vec_t<3, wp::float32> var_368;
    wp::vec_t<3, wp::float32> var_369;
    const wp::int32 var_370 = 0;
    bool var_371;
    wp::vec_t<6, wp::float32>* var_372;
    wp::vec_t<6, wp::float32> var_373;
    wp::vec_t<6, wp::float32> var_374;
    wp::vec_t<3, wp::float32> var_375;
    wp::vec_t<3, wp::float32>* var_376;
    wp::vec_t<3, wp::float32> var_377;
    wp::vec_t<3, wp::float32> var_378;
    wp::vec_t<3, wp::float32> var_379;
    wp::vec_t<3, wp::float32> var_380;
    wp::vec_t<3, wp::float32> var_381;
    wp::vec_t<3, wp::float32> var_382;
    wp::vec_t<3, wp::float32> var_383;
    wp::vec_t<3, wp::float32> var_384;
    bool var_385;
    const wp::int32 var_386 = 4;
    bool var_387;
    const wp::int32 var_388 = 5;
    bool var_389;
    wp::vec_t<6, wp::float32> var_390;
    wp::vec_t<3, wp::float32>* var_391;
    wp::vec_t<6, wp::float32> var_392;
    wp::vec_t<3, wp::float32> var_393;
    wp::vec_t<3, wp::float32> var_394;
    wp::vec_t<3, wp::float32> var_395;
    wp::vec_t<3, wp::float32> var_396;
    wp::vec_t<3, wp::float32> var_397;
    wp::vec_t<3, wp::float32> var_398;
    wp::vec_t<3, wp::float32> var_399;
    wp::vec_t<3, wp::float32> var_400;
    wp::vec_t<3, wp::float32> var_401;
    wp::vec_t<6, wp::float32> var_402;
    wp::int32* var_403;
    wp::int32 var_404;
    wp::int32 var_405;
    const wp::int32 var_406 = 0;
    bool var_407;
    wp::vec_t<3, wp::float32>* var_408;
    wp::vec_t<6, wp::float32> var_409;
    wp::vec_t<3, wp::float32> var_410;
    //---------
    // dual vars
    wp::range_t adj_0 = {};
    wp::int32 adj_1 = {};
    wp::int32 adj_2 = {};
    wp::int32 adj_3 = {};
    wp::int32 adj_4 = {};
    wp::int32 adj_5 = {};
    bool adj_6 = {};
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
    bool adj_17 = {};
    wp::transform_t<wp::float32> adj_18 = {};
    wp::transform_t<wp::float32> adj_19 = {};
    wp::transform_t<wp::float32> adj_20 = {};
    wp::transform_t<wp::float32> adj_21 = {};
    wp::transform_t<wp::float32> adj_22 = {};
    wp::transform_t<wp::float32> adj_23 = {};
    wp::int32 adj_24 = {};
    wp::int32 adj_25 = {};
    wp::int32 adj_26 = {};
    wp::int32 adj_27 = {};
    wp::int32 adj_28 = {};
    wp::int32 adj_29 = {};
    wp::int32 adj_30 = {};
    wp::int32 adj_31 = {};
    wp::int32 adj_32 = {};
    wp::int32 adj_33 = {};
    wp::int32 adj_34 = {};
    wp::int32 adj_35 = {};
    wp::int32 adj_36 = {};
    wp::int32 adj_37 = {};
    wp::transform_t<wp::float32> adj_38 = {};
    wp::vec_t<3, wp::float32> adj_39 = {};
    wp::vec_t<3, wp::float32> adj_40 = {};
    wp::vec_t<6, wp::float32> adj_41 = {};
    wp::int32 adj_42 = {};
    bool adj_43 = {};
    wp::vec_t<3, wp::float32> adj_44 = {};
    wp::vec_t<3, wp::float32> adj_45 = {};
    wp::vec_t<3, wp::float32> adj_46 = {};
    wp::float32 adj_47 = {};
    wp::float32 adj_48 = {};
    wp::float32 adj_49 = {};
    wp::float32 adj_50 = {};
    wp::float32 adj_51 = {};
    wp::float32 adj_52 = {};
    wp::vec_t<3, wp::float32> adj_53 = {};
    wp::quat_t<wp::float32> adj_54 = {};
    wp::transform_t<wp::float32> adj_55 = {};
    wp::vec_t<3, wp::float32> adj_56 = {};
    wp::vec_t<3, wp::float32> adj_57 = {};
    wp::vec_t<6, wp::float32> adj_58 = {};
    wp::transform_t<wp::float32> adj_59 = {};
    wp::vec_t<6, wp::float32> adj_60 = {};
    wp::int32 adj_61 = {};
    bool adj_62 = {};
    wp::vec_t<3, wp::float32> adj_63 = {};
    wp::vec_t<3, wp::float32> adj_64 = {};
    wp::vec_t<3, wp::float32> adj_65 = {};
    wp::float32 adj_66 = {};
    wp::float32 adj_67 = {};
    wp::float32 adj_68 = {};
    wp::float32 adj_69 = {};
    wp::float32 adj_70 = {};
    wp::float32 adj_71 = {};
    wp::vec_t<3, wp::float32> adj_72 = {};
    wp::quat_t<wp::float32> adj_73 = {};
    wp::transform_t<wp::float32> adj_74 = {};
    wp::vec_t<3, wp::float32> adj_75 = {};
    wp::vec_t<3, wp::float32> adj_76 = {};
    wp::vec_t<6, wp::float32> adj_77 = {};
    wp::transform_t<wp::float32> adj_78 = {};
    wp::vec_t<6, wp::float32> adj_79 = {};
    wp::vec_t<3, wp::float32> adj_80 = {};
    wp::float32 adj_81 = {};
    wp::float32 adj_82 = {};
    wp::int32 adj_83 = {};
    bool adj_84 = {};
    wp::int32 adj_85 = {};
    wp::int32 adj_86 = {};
    wp::float32 adj_87 = {};
    wp::int32 adj_88 = {};
    wp::int32 adj_89 = {};
    wp::float32 adj_90 = {};
    wp::int32 adj_91 = {};
    wp::int32 adj_92 = {};
    wp::float32 adj_93 = {};
    wp::int32 adj_94 = {};
    wp::int32 adj_95 = {};
    wp::float32 adj_96 = {};
    wp::quat_t<wp::float32> adj_97 = {};
    wp::float32 adj_98 = {};
    wp::float32 adj_99 = {};
    wp::float32 adj_100 = {};
    wp::float32 adj_101 = {};
    wp::int32 adj_102 = {};
    wp::int32 adj_103 = {};
    wp::float32 adj_104 = {};
    wp::int32 adj_105 = {};
    wp::int32 adj_106 = {};
    wp::float32 adj_107 = {};
    wp::int32 adj_108 = {};
    wp::int32 adj_109 = {};
    wp::float32 adj_110 = {};
    wp::vec_t<3, wp::float32> adj_111 = {};
    wp::float32 adj_112 = {};
    wp::float32 adj_113 = {};
    wp::float32 adj_114 = {};
    wp::vec_t<3, wp::float32> adj_115 = {};
    wp::transform_t<wp::float32> adj_116 = {};
    wp::vec_t<3, wp::float32> adj_117 = {};
    wp::vec_t<6, wp::float32> adj_118 = {};
    wp::transform_t<wp::float32> adj_119 = {};
    wp::vec_t<6, wp::float32> adj_120 = {};
    bool adj_121 = {};
    wp::int32 adj_122 = {};
    bool adj_123 = {};
    wp::int32 adj_124 = {};
    bool adj_125 = {};
    wp::int32 adj_126 = {};
    wp::int32 adj_127 = {};
    wp::float32 adj_128 = {};
    wp::int32 adj_129 = {};
    wp::int32 adj_130 = {};
    wp::float32 adj_131 = {};
    wp::int32 adj_132 = {};
    wp::int32 adj_133 = {};
    wp::float32 adj_134 = {};
    wp::vec_t<3, wp::float32> adj_135 = {};
    wp::float32 adj_136 = {};
    wp::float32 adj_137 = {};
    wp::float32 adj_138 = {};
    wp::int32 adj_139 = {};
    wp::int32 adj_140 = {};
    wp::float32 adj_141 = {};
    wp::int32 adj_142 = {};
    wp::int32 adj_143 = {};
    wp::float32 adj_144 = {};
    wp::int32 adj_145 = {};
    wp::int32 adj_146 = {};
    wp::float32 adj_147 = {};
    wp::int32 adj_148 = {};
    wp::int32 adj_149 = {};
    wp::float32 adj_150 = {};
    wp::quat_t<wp::float32> adj_151 = {};
    wp::float32 adj_152 = {};
    wp::float32 adj_153 = {};
    wp::float32 adj_154 = {};
    wp::float32 adj_155 = {};
    wp::transform_t<wp::float32> adj_156 = {};
    wp::int32 adj_157 = {};
    wp::int32 adj_158 = {};
    wp::float32 adj_159 = {};
    wp::int32 adj_160 = {};
    wp::int32 adj_161 = {};
    wp::float32 adj_162 = {};
    wp::int32 adj_163 = {};
    wp::int32 adj_164 = {};
    wp::float32 adj_165 = {};
    wp::vec_t<3, wp::float32> adj_166 = {};
    wp::float32 adj_167 = {};
    wp::float32 adj_168 = {};
    wp::float32 adj_169 = {};
    wp::int32 adj_170 = {};
    wp::int32 adj_171 = {};
    wp::float32 adj_172 = {};
    wp::int32 adj_173 = {};
    wp::int32 adj_174 = {};
    wp::float32 adj_175 = {};
    wp::int32 adj_176 = {};
    wp::int32 adj_177 = {};
    wp::float32 adj_178 = {};
    wp::vec_t<3, wp::float32> adj_179 = {};
    wp::float32 adj_180 = {};
    wp::float32 adj_181 = {};
    wp::float32 adj_182 = {};
    wp::vec_t<6, wp::float32> adj_183 = {};
    wp::transform_t<wp::float32> adj_184 = {};
    wp::vec_t<6, wp::float32> adj_185 = {};
    wp::transform_t<wp::float32> adj_186 = {};
    wp::vec_t<6, wp::float32> adj_187 = {};
    wp::int32 adj_188 = {};
    bool adj_189 = {};
    wp::float32 adj_190 = {};
    wp::vec_t<3, wp::float32> adj_191 = {};
    wp::quat_t<wp::float32> adj_192 = {};
    wp::float32 adj_193 = {};
    wp::vec_t<3, wp::float32> adj_194 = {};
    wp::float32 adj_195 = {};
    wp::vec_t<3, wp::float32> adj_196 = {};
    wp::int32 adj_197 = {};
    bool adj_198 = {};
    wp::int32 adj_199 = {};
    wp::int32 adj_200 = {};
    wp::vec_t<3, wp::float32> adj_201 = {};
    wp::vec_t<3, wp::float32> adj_202 = {};
    wp::vec_t<3, wp::float32> adj_203 = {};
    wp::int32 adj_204 = {};
    wp::int32 adj_205 = {};
    wp::float32 adj_206 = {};
    wp::vec_t<3, wp::float32> adj_207 = {};
    wp::float32 adj_208 = {};
    wp::vec_t<3, wp::float32> adj_209 = {};
    wp::int32 adj_210 = {};
    wp::int32 adj_211 = {};
    wp::float32 adj_212 = {};
    wp::vec_t<3, wp::float32> adj_213 = {};
    wp::float32 adj_214 = {};
    wp::vec_t<3, wp::float32> adj_215 = {};
    wp::vec_t<3, wp::float32> adj_216 = {};
    wp::vec_t<3, wp::float32> adj_217 = {};
    wp::vec_t<3, wp::float32> adj_218 = {};
    wp::int32 adj_219 = {};
    bool adj_220 = {};
    wp::int32 adj_221 = {};
    wp::int32 adj_222 = {};
    wp::vec_t<3, wp::float32> adj_223 = {};
    wp::vec_t<3, wp::float32> adj_224 = {};
    wp::vec_t<3, wp::float32> adj_225 = {};
    wp::int32 adj_226 = {};
    wp::int32 adj_227 = {};
    wp::float32 adj_228 = {};
    wp::vec_t<3, wp::float32> adj_229 = {};
    wp::float32 adj_230 = {};
    wp::vec_t<3, wp::float32> adj_231 = {};
    wp::int32 adj_232 = {};
    wp::int32 adj_233 = {};
    wp::float32 adj_234 = {};
    wp::vec_t<3, wp::float32> adj_235 = {};
    wp::float32 adj_236 = {};
    wp::vec_t<3, wp::float32> adj_237 = {};
    wp::vec_t<3, wp::float32> adj_238 = {};
    wp::vec_t<3, wp::float32> adj_239 = {};
    wp::vec_t<3, wp::float32> adj_240 = {};
    wp::int32 adj_241 = {};
    bool adj_242 = {};
    wp::int32 adj_243 = {};
    wp::int32 adj_244 = {};
    wp::vec_t<3, wp::float32> adj_245 = {};
    wp::vec_t<3, wp::float32> adj_246 = {};
    wp::vec_t<3, wp::float32> adj_247 = {};
    wp::int32 adj_248 = {};
    wp::int32 adj_249 = {};
    wp::float32 adj_250 = {};
    wp::vec_t<3, wp::float32> adj_251 = {};
    wp::float32 adj_252 = {};
    wp::vec_t<3, wp::float32> adj_253 = {};
    wp::int32 adj_254 = {};
    wp::int32 adj_255 = {};
    wp::float32 adj_256 = {};
    wp::vec_t<3, wp::float32> adj_257 = {};
    wp::float32 adj_258 = {};
    wp::vec_t<3, wp::float32> adj_259 = {};
    wp::vec_t<3, wp::float32> adj_260 = {};
    wp::vec_t<3, wp::float32> adj_261 = {};
    wp::vec_t<3, wp::float32> adj_262 = {};
    wp::int32 adj_263 = {};
    wp::int32 adj_264 = {};
    wp::int32 adj_265 = {};
    bool adj_266 = {};
    wp::vec_t<3, wp::float32> adj_267 = {};
    wp::vec_t<3, wp::float32> adj_268 = {};
    wp::vec_t<3, wp::float32> adj_269 = {};
    wp::float32 adj_270 = {};
    wp::quat_t<wp::float32> adj_271 = {};
    wp::float32 adj_272 = {};
    wp::float32 adj_273 = {};
    wp::vec_t<3, wp::float32> adj_274 = {};
    wp::float32 adj_275 = {};
    wp::vec_t<3, wp::float32> adj_276 = {};
    wp::quat_t<wp::float32> adj_277 = {};
    wp::vec_t<3, wp::float32> adj_278 = {};
    wp::int32 adj_279 = {};
    bool adj_280 = {};
    wp::int32 adj_281 = {};
    wp::int32 adj_282 = {};
    wp::vec_t<3, wp::float32> adj_283 = {};
    wp::int32 adj_284 = {};
    wp::int32 adj_285 = {};
    wp::vec_t<3, wp::float32> adj_286 = {};
    wp::int32 adj_287 = {};
    wp::int32 adj_288 = {};
    wp::float32 adj_289 = {};
    wp::int32 adj_290 = {};
    wp::int32 adj_291 = {};
    wp::float32 adj_292 = {};
    wp::int32 adj_293 = {};
    wp::int32 adj_294 = {};
    wp::float32 adj_295 = {};
    wp::int32 adj_296 = {};
    wp::int32 adj_297 = {};
    wp::float32 adj_298 = {};
    wp::quat_t<wp::float32> adj_299 = {};
    wp::vec_t<3, wp::float32> adj_300 = {};
    wp::vec_t<3, wp::float32> adj_301 = {};
    wp::vec_t<3, wp::float32> adj_302 = {};
    wp::float32 adj_303 = {};
    wp::float32 adj_304 = {};
    wp::float32 adj_305 = {};
    wp::float32 adj_306 = {};
    wp::quat_t<wp::float32> adj_307 = {};
    wp::vec_t<3, wp::float32> adj_308 = {};
    wp::int32 adj_309 = {};
    bool adj_310 = {};
    wp::int32 adj_311 = {};
    wp::int32 adj_312 = {};
    wp::vec_t<3, wp::float32> adj_313 = {};
    wp::int32 adj_314 = {};
    wp::int32 adj_315 = {};
    wp::vec_t<3, wp::float32> adj_316 = {};
    wp::int32 adj_317 = {};
    wp::int32 adj_318 = {};
    wp::vec_t<3, wp::float32> adj_319 = {};
    wp::int32 adj_320 = {};
    wp::int32 adj_321 = {};
    wp::float32 adj_322 = {};
    wp::int32 adj_323 = {};
    wp::int32 adj_324 = {};
    wp::float32 adj_325 = {};
    wp::int32 adj_326 = {};
    wp::int32 adj_327 = {};
    wp::float32 adj_328 = {};
    wp::int32 adj_329 = {};
    wp::int32 adj_330 = {};
    wp::float32 adj_331 = {};
    wp::int32 adj_332 = {};
    wp::int32 adj_333 = {};
    wp::float32 adj_334 = {};
    wp::int32 adj_335 = {};
    wp::int32 adj_336 = {};
    wp::float32 adj_337 = {};
    wp::quat_t<wp::float32> adj_338 = {};
    wp::vec_t<3, wp::float32> adj_339 = {};
    wp::vec_t<3, wp::float32> adj_340 = {};
    wp::vec_t<3, wp::float32> adj_341 = {};
    wp::vec_t<3, wp::float32> adj_342 = {};
    wp::float32 adj_343 = {};
    wp::float32 adj_344 = {};
    wp::float32 adj_345 = {};
    wp::float32 adj_346 = {};
    wp::float32 adj_347 = {};
    wp::float32 adj_348 = {};
    wp::quat_t<wp::float32> adj_349 = {};
    wp::vec_t<3, wp::float32> adj_350 = {};
    wp::transform_t<wp::float32> adj_351 = {};
    wp::vec_t<6, wp::float32> adj_352 = {};
    wp::transform_t<wp::float32> adj_353 = {};
    wp::vec_t<6, wp::float32> adj_354 = {};
    wp::vec_t<3, wp::float32> adj_355 = {};
    wp::transform_t<wp::float32> adj_356 = {};
    wp::int32 adj_357 = {};
    bool adj_358 = {};
    wp::transform_t<wp::float32> adj_359 = {};
    wp::transform_t<wp::float32> adj_360 = {};
    wp::transform_t<wp::float32> adj_361 = {};
    wp::transform_t<wp::float32> adj_362 = {};
    wp::transform_t<wp::float32> adj_363 = {};
    wp::transform_t<wp::float32> adj_364 = {};
    wp::transform_t<wp::float32> adj_365 = {};
    wp::transform_t<wp::float32> adj_366 = {};
    wp::vec_t<3, wp::float32> adj_367 = {};
    wp::vec_t<3, wp::float32> adj_368 = {};
    wp::vec_t<3, wp::float32> adj_369 = {};
    wp::int32 adj_370 = {};
    bool adj_371 = {};
    wp::vec_t<6, wp::float32> adj_372 = {};
    wp::vec_t<6, wp::float32> adj_373 = {};
    wp::vec_t<6, wp::float32> adj_374 = {};
    wp::vec_t<3, wp::float32> adj_375 = {};
    wp::vec_t<3, wp::float32> adj_376 = {};
    wp::vec_t<3, wp::float32> adj_377 = {};
    wp::vec_t<3, wp::float32> adj_378 = {};
    wp::vec_t<3, wp::float32> adj_379 = {};
    wp::vec_t<3, wp::float32> adj_380 = {};
    wp::vec_t<3, wp::float32> adj_381 = {};
    wp::vec_t<3, wp::float32> adj_382 = {};
    wp::vec_t<3, wp::float32> adj_383 = {};
    wp::vec_t<3, wp::float32> adj_384 = {};
    bool adj_385 = {};
    wp::int32 adj_386 = {};
    bool adj_387 = {};
    wp::int32 adj_388 = {};
    bool adj_389 = {};
    wp::vec_t<6, wp::float32> adj_390 = {};
    wp::vec_t<3, wp::float32> adj_391 = {};
    wp::vec_t<6, wp::float32> adj_392 = {};
    wp::vec_t<3, wp::float32> adj_393 = {};
    wp::vec_t<3, wp::float32> adj_394 = {};
    wp::vec_t<3, wp::float32> adj_395 = {};
    wp::vec_t<3, wp::float32> adj_396 = {};
    wp::vec_t<3, wp::float32> adj_397 = {};
    wp::vec_t<3, wp::float32> adj_398 = {};
    wp::vec_t<3, wp::float32> adj_399 = {};
    wp::vec_t<3, wp::float32> adj_400 = {};
    wp::vec_t<3, wp::float32> adj_401 = {};
    wp::vec_t<6, wp::float32> adj_402 = {};
    wp::int32 adj_403 = {};
    wp::int32 adj_404 = {};
    wp::int32 adj_405 = {};
    wp::int32 adj_406 = {};
    bool adj_407 = {};
    wp::vec_t<3, wp::float32> adj_408 = {};
    wp::vec_t<6, wp::float32> adj_409 = {};
    wp::vec_t<3, wp::float32> adj_410 = {};
    //---------
    // forward
    // def eval_single_articulation_fk(                                                       <L 237>
    // for i in range(joint_start, joint_end):                                                <L 259>
    var_0 = wp::range(var_joint_start, var_joint_end);
    //---------
    // reverse
    var_0 = wp::iter_reverse(var_0);
    start_for_0:;
        if (iter_cmp(var_0) == 0) goto end_for_0;
        var_1 = wp::iter_next(var_0);
    	adj_2 = {};
    	adj_3 = {};
    	adj_4 = {};
    	adj_5 = {};
    	adj_6 = {};
    	adj_7 = {};
    	adj_8 = {};
    	adj_9 = {};
    	adj_10 = {};
    	adj_11 = {};
    	adj_12 = {};
    	adj_13 = {};
    	adj_14 = {};
    	adj_15 = {};
    	adj_16 = {};
    	adj_17 = {};
    	adj_18 = {};
    	adj_19 = {};
    	adj_20 = {};
    	adj_21 = {};
    	adj_22 = {};
    	adj_23 = {};
    	adj_24 = {};
    	adj_25 = {};
    	adj_26 = {};
    	adj_27 = {};
    	adj_28 = {};
    	adj_29 = {};
    	adj_30 = {};
    	adj_31 = {};
    	adj_32 = {};
    	adj_33 = {};
    	adj_34 = {};
    	adj_35 = {};
    	adj_36 = {};
    	adj_37 = {};
    	adj_38 = {};
    	adj_39 = {};
    	adj_40 = {};
    	adj_41 = {};
    	adj_42 = {};
    	adj_43 = {};
    	adj_44 = {};
    	adj_45 = {};
    	adj_46 = {};
    	adj_47 = {};
    	adj_48 = {};
    	adj_49 = {};
    	adj_50 = {};
    	adj_51 = {};
    	adj_52 = {};
    	adj_53 = {};
    	adj_54 = {};
    	adj_55 = {};
    	adj_56 = {};
    	adj_57 = {};
    	adj_58 = {};
    	adj_59 = {};
    	adj_60 = {};
    	adj_61 = {};
    	adj_62 = {};
    	adj_63 = {};
    	adj_64 = {};
    	adj_65 = {};
    	adj_66 = {};
    	adj_67 = {};
    	adj_68 = {};
    	adj_69 = {};
    	adj_70 = {};
    	adj_71 = {};
    	adj_72 = {};
    	adj_73 = {};
    	adj_74 = {};
    	adj_75 = {};
    	adj_76 = {};
    	adj_77 = {};
    	adj_78 = {};
    	adj_79 = {};
    	adj_80 = {};
    	adj_81 = {};
    	adj_82 = {};
    	adj_83 = {};
    	adj_84 = {};
    	adj_85 = {};
    	adj_86 = {};
    	adj_87 = {};
    	adj_88 = {};
    	adj_89 = {};
    	adj_90 = {};
    	adj_91 = {};
    	adj_92 = {};
    	adj_93 = {};
    	adj_94 = {};
    	adj_95 = {};
    	adj_96 = {};
    	adj_97 = {};
    	adj_98 = {};
    	adj_99 = {};
    	adj_100 = {};
    	adj_101 = {};
    	adj_102 = {};
    	adj_103 = {};
    	adj_104 = {};
    	adj_105 = {};
    	adj_106 = {};
    	adj_107 = {};
    	adj_108 = {};
    	adj_109 = {};
    	adj_110 = {};
    	adj_111 = {};
    	adj_112 = {};
    	adj_113 = {};
    	adj_114 = {};
    	adj_115 = {};
    	adj_116 = {};
    	adj_117 = {};
    	adj_118 = {};
    	adj_119 = {};
    	adj_120 = {};
    	adj_121 = {};
    	adj_122 = {};
    	adj_123 = {};
    	adj_124 = {};
    	adj_125 = {};
    	adj_126 = {};
    	adj_127 = {};
    	adj_128 = {};
    	adj_129 = {};
    	adj_130 = {};
    	adj_131 = {};
    	adj_132 = {};
    	adj_133 = {};
    	adj_134 = {};
    	adj_135 = {};
    	adj_136 = {};
    	adj_137 = {};
    	adj_138 = {};
    	adj_139 = {};
    	adj_140 = {};
    	adj_141 = {};
    	adj_142 = {};
    	adj_143 = {};
    	adj_144 = {};
    	adj_145 = {};
    	adj_146 = {};
    	adj_147 = {};
    	adj_148 = {};
    	adj_149 = {};
    	adj_150 = {};
    	adj_151 = {};
    	adj_152 = {};
    	adj_153 = {};
    	adj_154 = {};
    	adj_155 = {};
    	adj_156 = {};
    	adj_157 = {};
    	adj_158 = {};
    	adj_159 = {};
    	adj_160 = {};
    	adj_161 = {};
    	adj_162 = {};
    	adj_163 = {};
    	adj_164 = {};
    	adj_165 = {};
    	adj_166 = {};
    	adj_167 = {};
    	adj_168 = {};
    	adj_169 = {};
    	adj_170 = {};
    	adj_171 = {};
    	adj_172 = {};
    	adj_173 = {};
    	adj_174 = {};
    	adj_175 = {};
    	adj_176 = {};
    	adj_177 = {};
    	adj_178 = {};
    	adj_179 = {};
    	adj_180 = {};
    	adj_181 = {};
    	adj_182 = {};
    	adj_183 = {};
    	adj_184 = {};
    	adj_185 = {};
    	adj_186 = {};
    	adj_187 = {};
    	adj_188 = {};
    	adj_189 = {};
    	adj_190 = {};
    	adj_191 = {};
    	adj_192 = {};
    	adj_193 = {};
    	adj_194 = {};
    	adj_195 = {};
    	adj_196 = {};
    	adj_197 = {};
    	adj_198 = {};
    	adj_199 = {};
    	adj_200 = {};
    	adj_201 = {};
    	adj_202 = {};
    	adj_203 = {};
    	adj_204 = {};
    	adj_205 = {};
    	adj_206 = {};
    	adj_207 = {};
    	adj_208 = {};
    	adj_209 = {};
    	adj_210 = {};
    	adj_211 = {};
    	adj_212 = {};
    	adj_213 = {};
    	adj_214 = {};
    	adj_215 = {};
    	adj_216 = {};
    	adj_217 = {};
    	adj_218 = {};
    	adj_219 = {};
    	adj_220 = {};
    	adj_221 = {};
    	adj_222 = {};
    	adj_223 = {};
    	adj_224 = {};
    	adj_225 = {};
    	adj_226 = {};
    	adj_227 = {};
    	adj_228 = {};
    	adj_229 = {};
    	adj_230 = {};
    	adj_231 = {};
    	adj_232 = {};
    	adj_233 = {};
    	adj_234 = {};
    	adj_235 = {};
    	adj_236 = {};
    	adj_237 = {};
    	adj_238 = {};
    	adj_239 = {};
    	adj_240 = {};
    	adj_241 = {};
    	adj_242 = {};
    	adj_243 = {};
    	adj_244 = {};
    	adj_245 = {};
    	adj_246 = {};
    	adj_247 = {};
    	adj_248 = {};
    	adj_249 = {};
    	adj_250 = {};
    	adj_251 = {};
    	adj_252 = {};
    	adj_253 = {};
    	adj_254 = {};
    	adj_255 = {};
    	adj_256 = {};
    	adj_257 = {};
    	adj_258 = {};
    	adj_259 = {};
    	adj_260 = {};
    	adj_261 = {};
    	adj_262 = {};
    	adj_263 = {};
    	adj_264 = {};
    	adj_265 = {};
    	adj_266 = {};
    	adj_267 = {};
    	adj_268 = {};
    	adj_269 = {};
    	adj_270 = {};
    	adj_271 = {};
    	adj_272 = {};
    	adj_273 = {};
    	adj_274 = {};
    	adj_275 = {};
    	adj_276 = {};
    	adj_277 = {};
    	adj_278 = {};
    	adj_279 = {};
    	adj_280 = {};
    	adj_281 = {};
    	adj_282 = {};
    	adj_283 = {};
    	adj_284 = {};
    	adj_285 = {};
    	adj_286 = {};
    	adj_287 = {};
    	adj_288 = {};
    	adj_289 = {};
    	adj_290 = {};
    	adj_291 = {};
    	adj_292 = {};
    	adj_293 = {};
    	adj_294 = {};
    	adj_295 = {};
    	adj_296 = {};
    	adj_297 = {};
    	adj_298 = {};
    	adj_299 = {};
    	adj_300 = {};
    	adj_301 = {};
    	adj_302 = {};
    	adj_303 = {};
    	adj_304 = {};
    	adj_305 = {};
    	adj_306 = {};
    	adj_307 = {};
    	adj_308 = {};
    	adj_309 = {};
    	adj_310 = {};
    	adj_311 = {};
    	adj_312 = {};
    	adj_313 = {};
    	adj_314 = {};
    	adj_315 = {};
    	adj_316 = {};
    	adj_317 = {};
    	adj_318 = {};
    	adj_319 = {};
    	adj_320 = {};
    	adj_321 = {};
    	adj_322 = {};
    	adj_323 = {};
    	adj_324 = {};
    	adj_325 = {};
    	adj_326 = {};
    	adj_327 = {};
    	adj_328 = {};
    	adj_329 = {};
    	adj_330 = {};
    	adj_331 = {};
    	adj_332 = {};
    	adj_333 = {};
    	adj_334 = {};
    	adj_335 = {};
    	adj_336 = {};
    	adj_337 = {};
    	adj_338 = {};
    	adj_339 = {};
    	adj_340 = {};
    	adj_341 = {};
    	adj_342 = {};
    	adj_343 = {};
    	adj_344 = {};
    	adj_345 = {};
    	adj_346 = {};
    	adj_347 = {};
    	adj_348 = {};
    	adj_349 = {};
    	adj_350 = {};
    	adj_351 = {};
    	adj_352 = {};
    	adj_353 = {};
    	adj_354 = {};
    	adj_355 = {};
    	adj_356 = {};
    	adj_357 = {};
    	adj_358 = {};
    	adj_359 = {};
    	adj_360 = {};
    	adj_361 = {};
    	adj_362 = {};
    	adj_363 = {};
    	adj_364 = {};
    	adj_365 = {};
    	adj_366 = {};
    	adj_367 = {};
    	adj_368 = {};
    	adj_369 = {};
    	adj_370 = {};
    	adj_371 = {};
    	adj_372 = {};
    	adj_373 = {};
    	adj_374 = {};
    	adj_375 = {};
    	adj_376 = {};
    	adj_377 = {};
    	adj_378 = {};
    	adj_379 = {};
    	adj_380 = {};
    	adj_381 = {};
    	adj_382 = {};
    	adj_383 = {};
    	adj_384 = {};
    	adj_385 = {};
    	adj_386 = {};
    	adj_387 = {};
    	adj_388 = {};
    	adj_389 = {};
    	adj_390 = {};
    	adj_391 = {};
    	adj_392 = {};
    	adj_393 = {};
    	adj_394 = {};
    	adj_395 = {};
    	adj_396 = {};
    	adj_397 = {};
    	adj_398 = {};
    	adj_399 = {};
    	adj_400 = {};
    	adj_401 = {};
    	adj_402 = {};
    	adj_403 = {};
    	adj_404 = {};
    	adj_405 = {};
    	adj_406 = {};
    	adj_407 = {};
    	adj_408 = {};
    	adj_409 = {};
    	adj_410 = {};
        // articulation = joint_articulation[i]                                               <L 260>
        var_2 = wp::address(var_joint_articulation, var_1);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // if articulation == -1:                                                             <L 261>
        var_6 = (var_3 == var_5);
        if (var_6) {
            // continue                                                                       <L 262>
            goto start_for_0;
        }
        // parent = joint_parent[i]                                                           <L 264>
        var_7 = wp::address(var_joint_parent, var_1);
        var_9 = wp::load(var_7);
        var_8 = wp::copy(var_9);
        // child = joint_child[i]                                                             <L 265>
        var_10 = wp::address(var_joint_child, var_1);
        var_12 = wp::load(var_10);
        var_11 = wp::copy(var_12);
        // type = joint_type[i]                                                               <L 268>
        var_13 = wp::address(var_joint_type, var_1);
        var_15 = wp::load(var_13);
        var_14 = wp::copy(var_15);
        // if type == JointType.CABLE:                                                        <L 269>
        var_17 = (var_14 == var_16);
        if (var_17) {
            // continue                                                                       <L 271>
            goto start_for_0;
        }
        // X_pj = joint_X_p[i]                                                                <L 273>
        var_18 = wp::address(var_joint_X_p, var_1);
        var_20 = wp::load(var_18);
        var_19 = wp::copy(var_20);
        // X_cj = joint_X_c[i]                                                                <L 274>
        var_21 = wp::address(var_joint_X_c, var_1);
        var_23 = wp::load(var_21);
        var_22 = wp::copy(var_23);
        // q_start = joint_q_start[i]                                                         <L 276>
        var_24 = wp::address(var_joint_q_start, var_1);
        var_26 = wp::load(var_24);
        var_25 = wp::copy(var_26);
        // qd_start = joint_qd_start[i]                                                       <L 277>
        var_27 = wp::address(var_joint_qd_start, var_1);
        var_29 = wp::load(var_27);
        var_28 = wp::copy(var_29);
        // lin_axis_count = joint_dof_dim[i, 0]                                               <L 278>
        var_31 = wp::address(var_joint_dof_dim, var_1, var_30);
        var_33 = wp::load(var_31);
        var_32 = wp::copy(var_33);
        // ang_axis_count = joint_dof_dim[i, 1]                                               <L 279>
        var_35 = wp::address(var_joint_dof_dim, var_1, var_34);
        var_37 = wp::load(var_35);
        var_36 = wp::copy(var_37);
        // X_j = wp.transform_identity()                                                      <L 281>
        var_38 = wp::transform_identity<wp::float32>();
        // v_j = wp.spatial_vector(wp.vec3(), wp.vec3())                                      <L 282>
        var_39 = wp::vec_t<3, wp::float32>();
        var_40 = wp::vec_t<3, wp::float32>();
        var_41 = wp::vec_t<6, wp::float32>(var_39, var_40);
        // if type == JointType.PRISMATIC:                                                    <L 284>
        var_43 = (var_14 == var_42);
        if (var_43) {
            // axis = joint_axis[qd_start]                                                    <L 285>
            var_44 = wp::address(var_joint_axis, var_28);
            var_46 = wp::load(var_44);
            var_45 = wp::copy(var_46);
            // q = joint_q[q_start]                                                           <L 287>
            var_47 = wp::address(var_joint_q, var_25);
            var_49 = wp::load(var_47);
            var_48 = wp::copy(var_49);
            // qd = joint_qd[qd_start]                                                        <L 288>
            var_50 = wp::address(var_joint_qd, var_28);
            var_52 = wp::load(var_50);
            var_51 = wp::copy(var_52);
            // X_j = wp.transform(axis * q, wp.quat_identity())                               <L 290>
            var_53 = wp::mul(var_45, var_48);
            var_54 = wp::quat_identity<wp::float32>();
            var_55 = wp::transform_t<wp::float32>(var_53, var_54);
            // v_j = wp.spatial_vector(axis * qd, wp.vec3())                                  <L 291>
            var_56 = wp::mul(var_45, var_51);
            var_57 = wp::vec_t<3, wp::float32>();
            var_58 = wp::vec_t<6, wp::float32>(var_56, var_57);
        }
        var_59 = wp::where(var_43, var_55, var_38);
        var_60 = wp::where(var_43, var_58, var_41);
        // if type == JointType.REVOLUTE:                                                     <L 293>
        var_62 = (var_14 == var_61);
        if (var_62) {
            // axis = joint_axis[qd_start]                                                    <L 294>
            var_63 = wp::address(var_joint_axis, var_28);
            var_65 = wp::load(var_63);
            var_64 = wp::copy(var_65);
            // q = joint_q[q_start]                                                           <L 296>
            var_66 = wp::address(var_joint_q, var_25);
            var_68 = wp::load(var_66);
            var_67 = wp::copy(var_68);
            // qd = joint_qd[qd_start]                                                        <L 297>
            var_69 = wp::address(var_joint_qd, var_28);
            var_71 = wp::load(var_69);
            var_70 = wp::copy(var_71);
            // X_j = wp.transform(wp.vec3(), wp.quat_from_axis_angle(axis, q))                <L 299>
            var_72 = wp::vec_t<3, wp::float32>();
            var_73 = wp::quat_from_axis_angle(var_64, var_67);
            var_74 = wp::transform_t<wp::float32>(var_72, var_73);
            // v_j = wp.spatial_vector(wp.vec3(), axis * qd)                                  <L 300>
            var_75 = wp::vec_t<3, wp::float32>();
            var_76 = wp::mul(var_64, var_70);
            var_77 = wp::vec_t<6, wp::float32>(var_75, var_76);
        }
        var_78 = wp::where(var_62, var_74, var_59);
        var_79 = wp::where(var_62, var_77, var_60);
        var_80 = wp::where(var_62, var_64, var_45);
        var_81 = wp::where(var_62, var_67, var_48);
        var_82 = wp::where(var_62, var_70, var_51);
        // if type == JointType.BALL:                                                         <L 302>
        var_84 = (var_14 == var_83);
        if (var_84) {
            // r = wp.quat(joint_q[q_start + 0], joint_q[q_start + 1], joint_q[q_start + 2], joint_q[q_start + 3])       <L 303>
            var_86 = wp::add(var_25, var_85);
            var_87 = wp::address(var_joint_q, var_86);
            var_89 = wp::add(var_25, var_88);
            var_90 = wp::address(var_joint_q, var_89);
            var_92 = wp::add(var_25, var_91);
            var_93 = wp::address(var_joint_q, var_92);
            var_95 = wp::add(var_25, var_94);
            var_96 = wp::address(var_joint_q, var_95);
            var_98 = wp::load(var_87);
            var_99 = wp::load(var_90);
            var_100 = wp::load(var_93);
            var_101 = wp::load(var_96);
            var_97 = wp::quat_t<wp::float32>(var_98, var_99, var_100, var_101);
            // w = wp.vec3(joint_qd[qd_start + 0], joint_qd[qd_start + 1], joint_qd[qd_start + 2])       <L 305>
            var_103 = wp::add(var_28, var_102);
            var_104 = wp::address(var_joint_qd, var_103);
            var_106 = wp::add(var_28, var_105);
            var_107 = wp::address(var_joint_qd, var_106);
            var_109 = wp::add(var_28, var_108);
            var_110 = wp::address(var_joint_qd, var_109);
            var_112 = wp::load(var_104);
            var_113 = wp::load(var_107);
            var_114 = wp::load(var_110);
            var_111 = wp::vec_t<3, wp::float32>(var_112, var_113, var_114);
            // X_j = wp.transform(wp.vec3(), r)                                               <L 307>
            var_115 = wp::vec_t<3, wp::float32>();
            var_116 = wp::transform_t<wp::float32>(var_115, var_97);
            // v_j = wp.spatial_vector(wp.vec3(), w)                                          <L 308>
            var_117 = wp::vec_t<3, wp::float32>();
            var_118 = wp::vec_t<6, wp::float32>(var_117, var_111);
        }
        var_119 = wp::where(var_84, var_116, var_78);
        var_120 = wp::where(var_84, var_118, var_79);
        // if type == JointType.FREE or type == JointType.DISTANCE:                           <L 310>
        var_123 = (var_14 == var_122);
        var_121 = var_123;
        if (!var_121) {
            var_125 = (var_14 == var_124);
            var_121 = var_121 || var_125;
        }
        if (var_121) {
            // t = wp.transform(                                                              <L 311>
            // wp.vec3(joint_q[q_start + 0], joint_q[q_start + 1], joint_q[q_start + 2]),       <L 312>
            var_127 = wp::add(var_25, var_126);
            var_128 = wp::address(var_joint_q, var_127);
            var_130 = wp::add(var_25, var_129);
            var_131 = wp::address(var_joint_q, var_130);
            var_133 = wp::add(var_25, var_132);
            var_134 = wp::address(var_joint_q, var_133);
            var_136 = wp::load(var_128);
            var_137 = wp::load(var_131);
            var_138 = wp::load(var_134);
            var_135 = wp::vec_t<3, wp::float32>(var_136, var_137, var_138);
            // wp.quat(joint_q[q_start + 3], joint_q[q_start + 4], joint_q[q_start + 5], joint_q[q_start + 6]),       <L 313>
            var_140 = wp::add(var_25, var_139);
            var_141 = wp::address(var_joint_q, var_140);
            var_143 = wp::add(var_25, var_142);
            var_144 = wp::address(var_joint_q, var_143);
            var_146 = wp::add(var_25, var_145);
            var_147 = wp::address(var_joint_q, var_146);
            var_149 = wp::add(var_25, var_148);
            var_150 = wp::address(var_joint_q, var_149);
            var_152 = wp::load(var_141);
            var_153 = wp::load(var_144);
            var_154 = wp::load(var_147);
            var_155 = wp::load(var_150);
            var_151 = wp::quat_t<wp::float32>(var_152, var_153, var_154, var_155);
            var_156 = wp::transform_t<wp::float32>(var_135, var_151);
            // v = wp.spatial_vector(                                                         <L 316>
            // wp.vec3(joint_qd[qd_start + 0], joint_qd[qd_start + 1], joint_qd[qd_start + 2]),       <L 317>
            var_158 = wp::add(var_28, var_157);
            var_159 = wp::address(var_joint_qd, var_158);
            var_161 = wp::add(var_28, var_160);
            var_162 = wp::address(var_joint_qd, var_161);
            var_164 = wp::add(var_28, var_163);
            var_165 = wp::address(var_joint_qd, var_164);
            var_167 = wp::load(var_159);
            var_168 = wp::load(var_162);
            var_169 = wp::load(var_165);
            var_166 = wp::vec_t<3, wp::float32>(var_167, var_168, var_169);
            // wp.vec3(joint_qd[qd_start + 3], joint_qd[qd_start + 4], joint_qd[qd_start + 5]),       <L 318>
            var_171 = wp::add(var_28, var_170);
            var_172 = wp::address(var_joint_qd, var_171);
            var_174 = wp::add(var_28, var_173);
            var_175 = wp::address(var_joint_qd, var_174);
            var_177 = wp::add(var_28, var_176);
            var_178 = wp::address(var_joint_qd, var_177);
            var_180 = wp::load(var_172);
            var_181 = wp::load(var_175);
            var_182 = wp::load(var_178);
            var_179 = wp::vec_t<3, wp::float32>(var_180, var_181, var_182);
            var_183 = wp::vec_t<6, wp::float32>(var_166, var_179);
            // X_j = t                                                                        <L 321>
            var_184 = wp::copy(var_156);
            // v_j = v                                                                        <L 322>
            var_185 = wp::copy(var_183);
        }
        var_186 = wp::where(var_121, var_184, var_119);
        var_187 = wp::where(var_121, var_185, var_120);
        // if type == JointType.D6:                                                           <L 324>
        var_189 = (var_14 == var_188);
        if (var_189) {
            // pos = wp.vec3(0.0)                                                             <L 325>
            var_191 = wp::vec_t<3, wp::float32>(var_190);
            // rot = wp.quat_identity()                                                       <L 326>
            var_192 = wp::quat_identity<wp::float32>();
            // vel_v = wp.vec3(0.0)                                                           <L 327>
            var_194 = wp::vec_t<3, wp::float32>(var_193);
            // vel_w = wp.vec3(0.0)                                                           <L 328>
            var_196 = wp::vec_t<3, wp::float32>(var_195);
            // if lin_axis_count > 0:                                                         <L 333>
            var_198 = (var_32 > var_197);
            if (var_198) {
                // axis = joint_axis[qd_start + 0]                                            <L 334>
                var_200 = wp::add(var_28, var_199);
                var_201 = wp::address(var_joint_axis, var_200);
                var_203 = wp::load(var_201);
                var_202 = wp::copy(var_203);
                // pos += axis * joint_q[q_start + 0]                                         <L 335>
                var_205 = wp::add(var_25, var_204);
                var_206 = wp::address(var_joint_q, var_205);
                var_208 = wp::load(var_206);
                var_207 = wp::mul(var_202, var_208);
                var_209 = wp::add(var_191, var_207);
                // vel_v += axis * joint_qd[qd_start + 0]                                     <L 336>
                var_211 = wp::add(var_28, var_210);
                var_212 = wp::address(var_joint_qd, var_211);
                var_214 = wp::load(var_212);
                var_213 = wp::mul(var_202, var_214);
                var_215 = wp::add(var_194, var_213);
            }
            var_216 = wp::where(var_198, var_202, var_80);
            var_217 = wp::where(var_198, var_209, var_191);
            var_218 = wp::where(var_198, var_215, var_194);
            // if lin_axis_count > 1:                                                         <L 337>
            var_220 = (var_32 > var_219);
            if (var_220) {
                // axis = joint_axis[qd_start + 1]                                            <L 338>
                var_222 = wp::add(var_28, var_221);
                var_223 = wp::address(var_joint_axis, var_222);
                var_225 = wp::load(var_223);
                var_224 = wp::copy(var_225);
                // pos += axis * joint_q[q_start + 1]                                         <L 339>
                var_227 = wp::add(var_25, var_226);
                var_228 = wp::address(var_joint_q, var_227);
                var_230 = wp::load(var_228);
                var_229 = wp::mul(var_224, var_230);
                var_231 = wp::add(var_217, var_229);
                // vel_v += axis * joint_qd[qd_start + 1]                                     <L 340>
                var_233 = wp::add(var_28, var_232);
                var_234 = wp::address(var_joint_qd, var_233);
                var_236 = wp::load(var_234);
                var_235 = wp::mul(var_224, var_236);
                var_237 = wp::add(var_218, var_235);
            }
            var_238 = wp::where(var_220, var_224, var_216);
            var_239 = wp::where(var_220, var_231, var_217);
            var_240 = wp::where(var_220, var_237, var_218);
            // if lin_axis_count > 2:                                                         <L 341>
            var_242 = (var_32 > var_241);
            if (var_242) {
                // axis = joint_axis[qd_start + 2]                                            <L 342>
                var_244 = wp::add(var_28, var_243);
                var_245 = wp::address(var_joint_axis, var_244);
                var_247 = wp::load(var_245);
                var_246 = wp::copy(var_247);
                // pos += axis * joint_q[q_start + 2]                                         <L 343>
                var_249 = wp::add(var_25, var_248);
                var_250 = wp::address(var_joint_q, var_249);
                var_252 = wp::load(var_250);
                var_251 = wp::mul(var_246, var_252);
                var_253 = wp::add(var_239, var_251);
                // vel_v += axis * joint_qd[qd_start + 2]                                     <L 344>
                var_255 = wp::add(var_28, var_254);
                var_256 = wp::address(var_joint_qd, var_255);
                var_258 = wp::load(var_256);
                var_257 = wp::mul(var_246, var_258);
                var_259 = wp::add(var_240, var_257);
            }
            var_260 = wp::where(var_242, var_246, var_238);
            var_261 = wp::where(var_242, var_253, var_239);
            var_262 = wp::where(var_242, var_259, var_240);
            // iq = q_start + lin_axis_count                                                  <L 346>
            var_263 = wp::add(var_25, var_32);
            // iqd = qd_start + lin_axis_count                                                <L 347>
            var_264 = wp::add(var_28, var_32);
            // if ang_axis_count == 1:                                                        <L 348>
            var_266 = (var_36 == var_265);
            if (var_266) {
                // axis = joint_axis[iqd]                                                     <L 349>
                var_267 = wp::address(var_joint_axis, var_264);
                var_269 = wp::load(var_267);
                var_268 = wp::copy(var_269);
                // rot = wp.quat_from_axis_angle(axis, joint_q[iq])                           <L 350>
                var_270 = wp::address(var_joint_q, var_263);
                var_272 = wp::load(var_270);
                var_271 = wp::quat_from_axis_angle(var_268, var_272);
                // vel_w = joint_qd[iqd] * axis                                               <L 351>
                var_273 = wp::address(var_joint_qd, var_264);
                var_275 = wp::load(var_273);
                var_274 = wp::mul(var_275, var_268);
            }
            var_276 = wp::where(var_266, var_268, var_260);
            var_277 = wp::where(var_266, var_271, var_192);
            var_278 = wp::where(var_266, var_274, var_196);
            // if ang_axis_count == 2:                                                        <L 352>
            var_280 = (var_36 == var_279);
            if (var_280) {
                // rot, vel_w = compute_2d_rotational_dofs(                                   <L 353>
                // joint_axis[iqd + 0],                                                       <L 354>
                var_282 = wp::add(var_264, var_281);
                var_283 = wp::address(var_joint_axis, var_282);
                // joint_axis[iqd + 1],                                                       <L 355>
                var_285 = wp::add(var_264, var_284);
                var_286 = wp::address(var_joint_axis, var_285);
                // joint_q[iq + 0],                                                           <L 356>
                var_288 = wp::add(var_263, var_287);
                var_289 = wp::address(var_joint_q, var_288);
                // joint_q[iq + 1],                                                           <L 357>
                var_291 = wp::add(var_263, var_290);
                var_292 = wp::address(var_joint_q, var_291);
                // joint_qd[iqd + 0],                                                         <L 358>
                var_294 = wp::add(var_264, var_293);
                var_295 = wp::address(var_joint_qd, var_294);
                // joint_qd[iqd + 1],                                                         <L 359>
                var_297 = wp::add(var_264, var_296);
                var_298 = wp::address(var_joint_qd, var_297);
                var_301 = wp::load(var_283);
                var_302 = wp::load(var_286);
                var_303 = wp::load(var_289);
                var_304 = wp::load(var_292);
                var_305 = wp::load(var_295);
                var_306 = wp::load(var_298);
                compute_2d_rotational_dofs_0(var_301, var_302, var_303, var_304, var_305, var_306, var_299, var_300);
            }
            var_307 = wp::where(var_280, var_299, var_277);
            var_308 = wp::where(var_280, var_300, var_278);
            // if ang_axis_count == 3:                                                        <L 361>
            var_310 = (var_36 == var_309);
            if (var_310) {
                // rot, vel_w = compute_3d_rotational_dofs(                                   <L 362>
                // joint_axis[iqd + 0],                                                       <L 363>
                var_312 = wp::add(var_264, var_311);
                var_313 = wp::address(var_joint_axis, var_312);
                // joint_axis[iqd + 1],                                                       <L 364>
                var_315 = wp::add(var_264, var_314);
                var_316 = wp::address(var_joint_axis, var_315);
                // joint_axis[iqd + 2],                                                       <L 365>
                var_318 = wp::add(var_264, var_317);
                var_319 = wp::address(var_joint_axis, var_318);
                // joint_q[iq + 0],                                                           <L 366>
                var_321 = wp::add(var_263, var_320);
                var_322 = wp::address(var_joint_q, var_321);
                // joint_q[iq + 1],                                                           <L 367>
                var_324 = wp::add(var_263, var_323);
                var_325 = wp::address(var_joint_q, var_324);
                // joint_q[iq + 2],                                                           <L 368>
                var_327 = wp::add(var_263, var_326);
                var_328 = wp::address(var_joint_q, var_327);
                // joint_qd[iqd + 0],                                                         <L 369>
                var_330 = wp::add(var_264, var_329);
                var_331 = wp::address(var_joint_qd, var_330);
                // joint_qd[iqd + 1],                                                         <L 370>
                var_333 = wp::add(var_264, var_332);
                var_334 = wp::address(var_joint_qd, var_333);
                // joint_qd[iqd + 2],                                                         <L 371>
                var_336 = wp::add(var_264, var_335);
                var_337 = wp::address(var_joint_qd, var_336);
                var_340 = wp::load(var_313);
                var_341 = wp::load(var_316);
                var_342 = wp::load(var_319);
                var_343 = wp::load(var_322);
                var_344 = wp::load(var_325);
                var_345 = wp::load(var_328);
                var_346 = wp::load(var_331);
                var_347 = wp::load(var_334);
                var_348 = wp::load(var_337);
                compute_3d_rotational_dofs_0(var_340, var_341, var_342, var_343, var_344, var_345, var_346, var_347, var_348, var_338, var_339);
            }
            var_349 = wp::where(var_310, var_338, var_307);
            var_350 = wp::where(var_310, var_339, var_308);
            // X_j = wp.transform(pos, rot)                                                   <L 374>
            var_351 = wp::transform_t<wp::float32>(var_261, var_349);
            // v_j = wp.spatial_vector(vel_v, vel_w)                                          <L 375>
            var_352 = wp::vec_t<6, wp::float32>(var_262, var_350);
        }
        var_353 = wp::where(var_189, var_351, var_186);
        var_354 = wp::where(var_189, var_352, var_187);
        var_355 = wp::where(var_189, var_276, var_80);
        // X_wpj = X_pj                                                                       <L 378>
        var_356 = wp::copy(var_19);
        // if parent >= 0:                                                                    <L 379>
        var_358 = (var_8 >= var_357);
        if (var_358) {
            // X_wp = body_q[parent]                                                          <L 380>
            var_359 = wp::address(var_body_q, var_8);
            var_361 = wp::load(var_359);
            var_360 = wp::copy(var_361);
            // X_wpj = X_wp * X_wpj                                                           <L 381>
            var_362 = wp::mul(var_360, var_356);
        }
        var_363 = wp::where(var_358, var_362, var_356);
        // X_wcj = X_wpj * X_j                                                                <L 384>
        var_364 = wp::mul(var_363, var_353);
        // X_wc = X_wcj * wp.transform_inverse(X_cj)                                          <L 386>
        var_365 = wp::transform_inverse(var_22);
        var_366 = wp::mul(var_364, var_365);
        // x_child_origin = wp.transform_get_translation(X_wc)                                <L 391>
        var_367 = wp::transform_get_translation(var_366);
        // v_parent_origin = wp.vec3()                                                        <L 392>
        var_368 = wp::vec_t<3, wp::float32>();
        // w_parent = wp.vec3()                                                               <L 393>
        var_369 = wp::vec_t<3, wp::float32>();
        // if parent >= 0:                                                                    <L 394>
        var_371 = (var_8 >= var_370);
        if (var_371) {
            // v_wp = body_qd[parent]                                                         <L 395>
            var_372 = wp::address(var_body_qd, var_8);
            var_374 = wp::load(var_372);
            var_373 = wp::copy(var_374);
            // w_parent = wp.spatial_bottom(v_wp)                                             <L 396>
            var_375 = wp::spatial_bottom(var_373);
            // v_parent_origin = com_twist_to_point_velocity(v_wp, X_wp, body_com[parent], x_child_origin)       <L 397>
            var_376 = wp::address(var_body_com, var_8);
            var_378 = wp::load(var_376);
            var_377 = com_twist_to_point_velocity_0(var_373, var_360, var_378, var_367);
        }
        var_379 = wp::where(var_371, var_377, var_368);
        var_380 = wp::where(var_371, var_375, var_369);
        // linear_joint_world = wp.transform_vector(X_wpj, wp.spatial_top(v_j))               <L 400>
        var_381 = wp::spatial_top(var_354);
        var_382 = wp::transform_vector(var_363, var_381);
        // angular_joint_world = wp.transform_vector(X_wpj, wp.spatial_bottom(v_j))           <L 401>
        var_383 = wp::spatial_bottom(var_354);
        var_384 = wp::transform_vector(var_363, var_383);
        // if type == JointType.FREE or type == JointType.DISTANCE:                           <L 402>
        var_387 = (var_14 == var_386);
        var_385 = var_387;
        if (!var_385) {
            var_389 = (var_14 == var_388);
            var_385 = var_385 || var_389;
        }
        if (var_385) {
            // v_joint_origin = com_twist_to_origin_twist(                                    <L 406>
            // wp.spatial_vector(linear_joint_world, angular_joint_world),                    <L 407>
            var_390 = wp::vec_t<6, wp::float32>(var_382, var_384);
            // X_wc,                                                                          <L 408>
            // body_com[child],                                                               <L 409>
            var_391 = wp::address(var_body_com, var_11);
            var_393 = wp::load(var_391);
            var_392 = com_twist_to_origin_twist_0(var_390, var_366, var_393);
            // linear_joint_origin = wp.spatial_top(v_joint_origin)                           <L 411>
            var_394 = wp::spatial_top(var_392);
        }
        if (!var_385) {
            // child_origin_offset_world = x_child_origin - wp.transform_get_translation(X_wcj)       <L 416>
            var_395 = wp::transform_get_translation(var_364);
            var_396 = wp::sub(var_367, var_395);
            // linear_joint_origin = linear_joint_world + wp.cross(angular_joint_world, child_origin_offset_world)       <L 417>
            var_397 = wp::cross(var_384, var_396);
            var_398 = wp::add(var_382, var_397);
        }
        var_399 = wp::where(var_385, var_394, var_398);
        // v_wc_origin = wp.spatial_vector(v_parent_origin + linear_joint_origin, w_parent + angular_joint_world)       <L 419>
        var_400 = wp::add(var_379, var_399);
        var_401 = wp::add(var_380, var_384);
        var_402 = wp::vec_t<6, wp::float32>(var_400, var_401);
        // if (body_flags[child] & body_flag_filter) != 0:                                    <L 421>
        var_403 = wp::address(var_body_flags, var_11);
        var_405 = wp::load(var_403);
        var_404 = wp::bit_and(var_405, var_body_flag_filter);
        var_407 = (var_404 != var_406);
        if (var_407) {
            // body_q[child] = X_wc                                                           <L 422>
            // wp::array_store(var_body_q, var_11, var_366);
            // body_qd[child] = origin_twist_to_com_twist(v_wc_origin, X_wc, body_com[child])       <L 423>
            var_408 = wp::address(var_body_com, var_11);
            var_410 = wp::load(var_408);
            var_409 = origin_twist_to_com_twist_0(var_402, var_366, var_410);
            // wp::array_store(var_body_qd, var_11, var_409);
        }
        if (var_407) {
            wp::adj_array_store(var_body_qd, var_11, var_409, adj_body_qd, adj_11, adj_409);
            adj_origin_twist_to_com_twist_0(var_402, var_366, var_410, adj_402, adj_366, adj_408, adj_409);
            wp::adj_address(var_body_com, var_11, adj_body_com, adj_11, adj_408);
            // adj: body_qd[child] = origin_twist_to_com_twist(v_wc_origin, X_wc, body_com[child])  <L 423>
            wp::adj_array_store(var_body_q, var_11, var_366, adj_body_q, adj_11, adj_366);
            // adj: body_q[child] = X_wc                                                      <L 422>
        }
        wp::adj_address(var_body_flags, var_11, adj_body_flags, adj_11, adj_403);
        // adj: if (body_flags[child] & body_flag_filter) != 0:                               <L 421>
        wp::adj_vec_t(var_400, var_401, adj_400, adj_401, adj_402);
        wp::adj_add(var_380, var_384, adj_380, adj_384, adj_401);
        wp::adj_add(var_379, var_399, adj_379, adj_399, adj_400);
        // adj: v_wc_origin = wp.spatial_vector(v_parent_origin + linear_joint_origin, w_parent + angular_joint_world)  <L 419>
        wp::adj_where(var_385, var_394, var_398, adj_385, adj_394, adj_398, adj_399);
        if (!var_385) {
            wp::adj_add(var_382, var_397, adj_382, adj_397, adj_398);
            wp::adj_cross(var_384, var_396, adj_384, adj_396, adj_397);
            // adj: linear_joint_origin = linear_joint_world + wp.cross(angular_joint_world, child_origin_offset_world)  <L 417>
            wp::adj_sub(var_367, var_395, adj_367, adj_395, adj_396);
            wp::adj_transform_get_translation(var_364, adj_364, adj_395);
            // adj: child_origin_offset_world = x_child_origin - wp.transform_get_translation(X_wcj)  <L 416>
        }
        if (var_385) {
            wp::adj_spatial_top(var_392, adj_392, adj_394);
            // adj: linear_joint_origin = wp.spatial_top(v_joint_origin)                      <L 411>
            adj_com_twist_to_origin_twist_0(var_390, var_366, var_393, adj_390, adj_366, adj_391, adj_392);
            wp::adj_address(var_body_com, var_11, adj_body_com, adj_11, adj_391);
            // adj: body_com[child],                                                          <L 409>
            // adj: X_wc,                                                                     <L 408>
            wp::adj_vec_t(var_382, var_384, adj_382, adj_384, adj_390);
            // adj: wp.spatial_vector(linear_joint_world, angular_joint_world),               <L 407>
            // adj: v_joint_origin = com_twist_to_origin_twist(                               <L 406>
        }
        if (!var_385) {
        }
        // adj: if type == JointType.FREE or type == JointType.DISTANCE:                      <L 402>
        wp::adj_transform_vector(var_363, var_383, adj_363, adj_383, adj_384);
        wp::adj_spatial_bottom(var_354, adj_354, adj_383);
        // adj: angular_joint_world = wp.transform_vector(X_wpj, wp.spatial_bottom(v_j))      <L 401>
        wp::adj_transform_vector(var_363, var_381, adj_363, adj_381, adj_382);
        wp::adj_spatial_top(var_354, adj_354, adj_381);
        // adj: linear_joint_world = wp.transform_vector(X_wpj, wp.spatial_top(v_j))          <L 400>
        wp::adj_where(var_371, var_375, var_369, adj_371, adj_375, adj_369, adj_380);
        wp::adj_where(var_371, var_377, var_368, adj_371, adj_377, adj_368, adj_379);
        if (var_371) {
            adj_com_twist_to_point_velocity_0(var_373, var_360, var_378, var_367, adj_373, adj_360, adj_376, adj_367, adj_377);
            wp::adj_address(var_body_com, var_8, adj_body_com, adj_8, adj_376);
            // adj: v_parent_origin = com_twist_to_point_velocity(v_wp, X_wp, body_com[parent], x_child_origin)  <L 397>
            wp::adj_spatial_bottom(var_373, adj_373, adj_375);
            // adj: w_parent = wp.spatial_bottom(v_wp)                                        <L 396>
            wp::adj_copy(var_374, adj_372, adj_373);
            wp::adj_address(var_body_qd, var_8, adj_body_qd, adj_8, adj_372);
            // adj: v_wp = body_qd[parent]                                                    <L 395>
        }
        // adj: if parent >= 0:                                                               <L 394>
        // adj: w_parent = wp.vec3()                                                          <L 393>
        // adj: v_parent_origin = wp.vec3()                                                   <L 392>
        wp::adj_transform_get_translation(var_366, adj_366, adj_367);
        // adj: x_child_origin = wp.transform_get_translation(X_wc)                           <L 391>
        wp::adj_mul(var_364, var_365, adj_364, adj_365, adj_366);
        wp::adj_transform_inverse(var_22, adj_22, adj_365);
        // adj: X_wc = X_wcj * wp.transform_inverse(X_cj)                                     <L 386>
        wp::adj_mul(var_363, var_353, adj_363, adj_353, adj_364);
        // adj: X_wcj = X_wpj * X_j                                                           <L 384>
        wp::adj_where(var_358, var_362, var_356, adj_358, adj_362, adj_356, adj_363);
        if (var_358) {
            wp::adj_mul(var_360, var_356, adj_360, adj_356, adj_362);
            // adj: X_wpj = X_wp * X_wpj                                                      <L 381>
            wp::adj_copy(var_361, adj_359, adj_360);
            wp::adj_address(var_body_q, var_8, adj_body_q, adj_8, adj_359);
            // adj: X_wp = body_q[parent]                                                     <L 380>
        }
        // adj: if parent >= 0:                                                               <L 379>
        wp::adj_copy(var_19, adj_19, adj_356);
        // adj: X_wpj = X_pj                                                                  <L 378>
        wp::adj_where(var_189, var_276, var_80, adj_189, adj_276, adj_80, adj_355);
        wp::adj_where(var_189, var_352, var_187, adj_189, adj_352, adj_187, adj_354);
        wp::adj_where(var_189, var_351, var_186, adj_189, adj_351, adj_186, adj_353);
        if (var_189) {
            wp::adj_vec_t(var_262, var_350, adj_262, adj_350, adj_352);
            // adj: v_j = wp.spatial_vector(vel_v, vel_w)                                     <L 375>
            wp::adj_transform_t(var_261, var_349, adj_261, adj_349, adj_351);
            // adj: X_j = wp.transform(pos, rot)                                              <L 374>
            wp::adj_where(var_310, var_339, var_308, adj_310, adj_339, adj_308, adj_350);
            wp::adj_where(var_310, var_338, var_307, adj_310, adj_338, adj_307, adj_349);
            if (var_310) {
                adj_compute_3d_rotational_dofs_0(var_340, var_341, var_342, var_343, var_344, var_345, var_346, var_347, var_348, var_338, var_339, adj_313, adj_316, adj_319, adj_322, adj_325, adj_328, adj_331, adj_334, adj_337, adj_338, adj_339);
                wp::adj_address(var_joint_qd, var_336, adj_joint_qd, adj_336, adj_337);
                wp::adj_add(var_264, var_335, adj_264, adj_335, adj_336);
                // adj: joint_qd[iqd + 2],                                                    <L 371>
                wp::adj_address(var_joint_qd, var_333, adj_joint_qd, adj_333, adj_334);
                wp::adj_add(var_264, var_332, adj_264, adj_332, adj_333);
                // adj: joint_qd[iqd + 1],                                                    <L 370>
                wp::adj_address(var_joint_qd, var_330, adj_joint_qd, adj_330, adj_331);
                wp::adj_add(var_264, var_329, adj_264, adj_329, adj_330);
                // adj: joint_qd[iqd + 0],                                                    <L 369>
                wp::adj_address(var_joint_q, var_327, adj_joint_q, adj_327, adj_328);
                wp::adj_add(var_263, var_326, adj_263, adj_326, adj_327);
                // adj: joint_q[iq + 2],                                                      <L 368>
                wp::adj_address(var_joint_q, var_324, adj_joint_q, adj_324, adj_325);
                wp::adj_add(var_263, var_323, adj_263, adj_323, adj_324);
                // adj: joint_q[iq + 1],                                                      <L 367>
                wp::adj_address(var_joint_q, var_321, adj_joint_q, adj_321, adj_322);
                wp::adj_add(var_263, var_320, adj_263, adj_320, adj_321);
                // adj: joint_q[iq + 0],                                                      <L 366>
                wp::adj_address(var_joint_axis, var_318, adj_joint_axis, adj_318, adj_319);
                wp::adj_add(var_264, var_317, adj_264, adj_317, adj_318);
                // adj: joint_axis[iqd + 2],                                                  <L 365>
                wp::adj_address(var_joint_axis, var_315, adj_joint_axis, adj_315, adj_316);
                wp::adj_add(var_264, var_314, adj_264, adj_314, adj_315);
                // adj: joint_axis[iqd + 1],                                                  <L 364>
                wp::adj_address(var_joint_axis, var_312, adj_joint_axis, adj_312, adj_313);
                wp::adj_add(var_264, var_311, adj_264, adj_311, adj_312);
                // adj: joint_axis[iqd + 0],                                                  <L 363>
                // adj: rot, vel_w = compute_3d_rotational_dofs(                              <L 362>
            }
            // adj: if ang_axis_count == 3:                                                   <L 361>
            wp::adj_where(var_280, var_300, var_278, adj_280, adj_300, adj_278, adj_308);
            wp::adj_where(var_280, var_299, var_277, adj_280, adj_299, adj_277, adj_307);
            if (var_280) {
                adj_compute_2d_rotational_dofs_0(var_301, var_302, var_303, var_304, var_305, var_306, var_299, var_300, adj_283, adj_286, adj_289, adj_292, adj_295, adj_298, adj_299, adj_300);
                wp::adj_address(var_joint_qd, var_297, adj_joint_qd, adj_297, adj_298);
                wp::adj_add(var_264, var_296, adj_264, adj_296, adj_297);
                // adj: joint_qd[iqd + 1],                                                    <L 359>
                wp::adj_address(var_joint_qd, var_294, adj_joint_qd, adj_294, adj_295);
                wp::adj_add(var_264, var_293, adj_264, adj_293, adj_294);
                // adj: joint_qd[iqd + 0],                                                    <L 358>
                wp::adj_address(var_joint_q, var_291, adj_joint_q, adj_291, adj_292);
                wp::adj_add(var_263, var_290, adj_263, adj_290, adj_291);
                // adj: joint_q[iq + 1],                                                      <L 357>
                wp::adj_address(var_joint_q, var_288, adj_joint_q, adj_288, adj_289);
                wp::adj_add(var_263, var_287, adj_263, adj_287, adj_288);
                // adj: joint_q[iq + 0],                                                      <L 356>
                wp::adj_address(var_joint_axis, var_285, adj_joint_axis, adj_285, adj_286);
                wp::adj_add(var_264, var_284, adj_264, adj_284, adj_285);
                // adj: joint_axis[iqd + 1],                                                  <L 355>
                wp::adj_address(var_joint_axis, var_282, adj_joint_axis, adj_282, adj_283);
                wp::adj_add(var_264, var_281, adj_264, adj_281, adj_282);
                // adj: joint_axis[iqd + 0],                                                  <L 354>
                // adj: rot, vel_w = compute_2d_rotational_dofs(                              <L 353>
            }
            // adj: if ang_axis_count == 2:                                                   <L 352>
            wp::adj_where(var_266, var_274, var_196, adj_266, adj_274, adj_196, adj_278);
            wp::adj_where(var_266, var_271, var_192, adj_266, adj_271, adj_192, adj_277);
            wp::adj_where(var_266, var_268, var_260, adj_266, adj_268, adj_260, adj_276);
            if (var_266) {
                wp::adj_mul(var_275, var_268, adj_273, adj_268, adj_274);
                wp::adj_address(var_joint_qd, var_264, adj_joint_qd, adj_264, adj_273);
                // adj: vel_w = joint_qd[iqd] * axis                                          <L 351>
                wp::adj_quat_from_axis_angle(var_268, var_272, adj_268, adj_270, adj_271);
                wp::adj_address(var_joint_q, var_263, adj_joint_q, adj_263, adj_270);
                // adj: rot = wp.quat_from_axis_angle(axis, joint_q[iq])                      <L 350>
                wp::adj_copy(var_269, adj_267, adj_268);
                wp::adj_address(var_joint_axis, var_264, adj_joint_axis, adj_264, adj_267);
                // adj: axis = joint_axis[iqd]                                                <L 349>
            }
            // adj: if ang_axis_count == 1:                                                   <L 348>
            wp::adj_add(var_28, var_32, adj_28, adj_32, adj_264);
            // adj: iqd = qd_start + lin_axis_count                                           <L 347>
            wp::adj_add(var_25, var_32, adj_25, adj_32, adj_263);
            // adj: iq = q_start + lin_axis_count                                             <L 346>
            wp::adj_where(var_242, var_259, var_240, adj_242, adj_259, adj_240, adj_262);
            wp::adj_where(var_242, var_253, var_239, adj_242, adj_253, adj_239, adj_261);
            wp::adj_where(var_242, var_246, var_238, adj_242, adj_246, adj_238, adj_260);
            if (var_242) {
                wp::adj_add(var_240, var_257, adj_240, adj_257, adj_259);
                wp::adj_mul(var_246, var_258, adj_246, adj_256, adj_257);
                wp::adj_address(var_joint_qd, var_255, adj_joint_qd, adj_255, adj_256);
                wp::adj_add(var_28, var_254, adj_28, adj_254, adj_255);
                // adj: vel_v += axis * joint_qd[qd_start + 2]                                <L 344>
                wp::adj_add(var_239, var_251, adj_239, adj_251, adj_253);
                wp::adj_mul(var_246, var_252, adj_246, adj_250, adj_251);
                wp::adj_address(var_joint_q, var_249, adj_joint_q, adj_249, adj_250);
                wp::adj_add(var_25, var_248, adj_25, adj_248, adj_249);
                // adj: pos += axis * joint_q[q_start + 2]                                    <L 343>
                wp::adj_copy(var_247, adj_245, adj_246);
                wp::adj_address(var_joint_axis, var_244, adj_joint_axis, adj_244, adj_245);
                wp::adj_add(var_28, var_243, adj_28, adj_243, adj_244);
                // adj: axis = joint_axis[qd_start + 2]                                       <L 342>
            }
            // adj: if lin_axis_count > 2:                                                    <L 341>
            wp::adj_where(var_220, var_237, var_218, adj_220, adj_237, adj_218, adj_240);
            wp::adj_where(var_220, var_231, var_217, adj_220, adj_231, adj_217, adj_239);
            wp::adj_where(var_220, var_224, var_216, adj_220, adj_224, adj_216, adj_238);
            if (var_220) {
                wp::adj_add(var_218, var_235, adj_218, adj_235, adj_237);
                wp::adj_mul(var_224, var_236, adj_224, adj_234, adj_235);
                wp::adj_address(var_joint_qd, var_233, adj_joint_qd, adj_233, adj_234);
                wp::adj_add(var_28, var_232, adj_28, adj_232, adj_233);
                // adj: vel_v += axis * joint_qd[qd_start + 1]                                <L 340>
                wp::adj_add(var_217, var_229, adj_217, adj_229, adj_231);
                wp::adj_mul(var_224, var_230, adj_224, adj_228, adj_229);
                wp::adj_address(var_joint_q, var_227, adj_joint_q, adj_227, adj_228);
                wp::adj_add(var_25, var_226, adj_25, adj_226, adj_227);
                // adj: pos += axis * joint_q[q_start + 1]                                    <L 339>
                wp::adj_copy(var_225, adj_223, adj_224);
                wp::adj_address(var_joint_axis, var_222, adj_joint_axis, adj_222, adj_223);
                wp::adj_add(var_28, var_221, adj_28, adj_221, adj_222);
                // adj: axis = joint_axis[qd_start + 1]                                       <L 338>
            }
            // adj: if lin_axis_count > 1:                                                    <L 337>
            wp::adj_where(var_198, var_215, var_194, adj_198, adj_215, adj_194, adj_218);
            wp::adj_where(var_198, var_209, var_191, adj_198, adj_209, adj_191, adj_217);
            wp::adj_where(var_198, var_202, var_80, adj_198, adj_202, adj_80, adj_216);
            if (var_198) {
                wp::adj_add(var_194, var_213, adj_194, adj_213, adj_215);
                wp::adj_mul(var_202, var_214, adj_202, adj_212, adj_213);
                wp::adj_address(var_joint_qd, var_211, adj_joint_qd, adj_211, adj_212);
                wp::adj_add(var_28, var_210, adj_28, adj_210, adj_211);
                // adj: vel_v += axis * joint_qd[qd_start + 0]                                <L 336>
                wp::adj_add(var_191, var_207, adj_191, adj_207, adj_209);
                wp::adj_mul(var_202, var_208, adj_202, adj_206, adj_207);
                wp::adj_address(var_joint_q, var_205, adj_joint_q, adj_205, adj_206);
                wp::adj_add(var_25, var_204, adj_25, adj_204, adj_205);
                // adj: pos += axis * joint_q[q_start + 0]                                    <L 335>
                wp::adj_copy(var_203, adj_201, adj_202);
                wp::adj_address(var_joint_axis, var_200, adj_joint_axis, adj_200, adj_201);
                wp::adj_add(var_28, var_199, adj_28, adj_199, adj_200);
                // adj: axis = joint_axis[qd_start + 0]                                       <L 334>
            }
            // adj: if lin_axis_count > 0:                                                    <L 333>
            wp::adj_vec_t(var_195, adj_195, adj_196);
            // adj: vel_w = wp.vec3(0.0)                                                      <L 328>
            wp::adj_vec_t(var_193, adj_193, adj_194);
            // adj: vel_v = wp.vec3(0.0)                                                      <L 327>
            // adj: rot = wp.quat_identity()                                                  <L 326>
            wp::adj_vec_t(var_190, adj_190, adj_191);
            // adj: pos = wp.vec3(0.0)                                                        <L 325>
        }
        // adj: if type == JointType.D6:                                                      <L 324>
        wp::adj_where(var_121, var_185, var_120, adj_121, adj_185, adj_120, adj_187);
        wp::adj_where(var_121, var_184, var_119, adj_121, adj_184, adj_119, adj_186);
        if (var_121) {
            wp::adj_copy(var_183, adj_183, adj_185);
            // adj: v_j = v                                                                   <L 322>
            wp::adj_copy(var_156, adj_156, adj_184);
            // adj: X_j = t                                                                   <L 321>
            wp::adj_vec_t(var_166, var_179, adj_166, adj_179, adj_183);
            wp::adj_vec_t(var_180, var_181, var_182, adj_172, adj_175, adj_178, adj_179);
            wp::adj_address(var_joint_qd, var_177, adj_joint_qd, adj_177, adj_178);
            wp::adj_add(var_28, var_176, adj_28, adj_176, adj_177);
            wp::adj_address(var_joint_qd, var_174, adj_joint_qd, adj_174, adj_175);
            wp::adj_add(var_28, var_173, adj_28, adj_173, adj_174);
            wp::adj_address(var_joint_qd, var_171, adj_joint_qd, adj_171, adj_172);
            wp::adj_add(var_28, var_170, adj_28, adj_170, adj_171);
            // adj: wp.vec3(joint_qd[qd_start + 3], joint_qd[qd_start + 4], joint_qd[qd_start + 5]),  <L 318>
            wp::adj_vec_t(var_167, var_168, var_169, adj_159, adj_162, adj_165, adj_166);
            wp::adj_address(var_joint_qd, var_164, adj_joint_qd, adj_164, adj_165);
            wp::adj_add(var_28, var_163, adj_28, adj_163, adj_164);
            wp::adj_address(var_joint_qd, var_161, adj_joint_qd, adj_161, adj_162);
            wp::adj_add(var_28, var_160, adj_28, adj_160, adj_161);
            wp::adj_address(var_joint_qd, var_158, adj_joint_qd, adj_158, adj_159);
            wp::adj_add(var_28, var_157, adj_28, adj_157, adj_158);
            // adj: wp.vec3(joint_qd[qd_start + 0], joint_qd[qd_start + 1], joint_qd[qd_start + 2]),  <L 317>
            // adj: v = wp.spatial_vector(                                                    <L 316>
            wp::adj_transform_t(var_135, var_151, adj_135, adj_151, adj_156);
            wp::adj_quat_t(var_152, var_153, var_154, var_155, adj_141, adj_144, adj_147, adj_150, adj_151);
            wp::adj_address(var_joint_q, var_149, adj_joint_q, adj_149, adj_150);
            wp::adj_add(var_25, var_148, adj_25, adj_148, adj_149);
            wp::adj_address(var_joint_q, var_146, adj_joint_q, adj_146, adj_147);
            wp::adj_add(var_25, var_145, adj_25, adj_145, adj_146);
            wp::adj_address(var_joint_q, var_143, adj_joint_q, adj_143, adj_144);
            wp::adj_add(var_25, var_142, adj_25, adj_142, adj_143);
            wp::adj_address(var_joint_q, var_140, adj_joint_q, adj_140, adj_141);
            wp::adj_add(var_25, var_139, adj_25, adj_139, adj_140);
            // adj: wp.quat(joint_q[q_start + 3], joint_q[q_start + 4], joint_q[q_start + 5], joint_q[q_start + 6]),  <L 313>
            wp::adj_vec_t(var_136, var_137, var_138, adj_128, adj_131, adj_134, adj_135);
            wp::adj_address(var_joint_q, var_133, adj_joint_q, adj_133, adj_134);
            wp::adj_add(var_25, var_132, adj_25, adj_132, adj_133);
            wp::adj_address(var_joint_q, var_130, adj_joint_q, adj_130, adj_131);
            wp::adj_add(var_25, var_129, adj_25, adj_129, adj_130);
            wp::adj_address(var_joint_q, var_127, adj_joint_q, adj_127, adj_128);
            wp::adj_add(var_25, var_126, adj_25, adj_126, adj_127);
            // adj: wp.vec3(joint_q[q_start + 0], joint_q[q_start + 1], joint_q[q_start + 2]),  <L 312>
            // adj: t = wp.transform(                                                         <L 311>
        }
        if (!var_121) {
        }
        // adj: if type == JointType.FREE or type == JointType.DISTANCE:                      <L 310>
        wp::adj_where(var_84, var_118, var_79, adj_84, adj_118, adj_79, adj_120);
        wp::adj_where(var_84, var_116, var_78, adj_84, adj_116, adj_78, adj_119);
        if (var_84) {
            wp::adj_vec_t(var_117, var_111, adj_117, adj_111, adj_118);
            // adj: v_j = wp.spatial_vector(wp.vec3(), w)                                     <L 308>
            wp::adj_transform_t(var_115, var_97, adj_115, adj_97, adj_116);
            // adj: X_j = wp.transform(wp.vec3(), r)                                          <L 307>
            wp::adj_vec_t(var_112, var_113, var_114, adj_104, adj_107, adj_110, adj_111);
            wp::adj_address(var_joint_qd, var_109, adj_joint_qd, adj_109, adj_110);
            wp::adj_add(var_28, var_108, adj_28, adj_108, adj_109);
            wp::adj_address(var_joint_qd, var_106, adj_joint_qd, adj_106, adj_107);
            wp::adj_add(var_28, var_105, adj_28, adj_105, adj_106);
            wp::adj_address(var_joint_qd, var_103, adj_joint_qd, adj_103, adj_104);
            wp::adj_add(var_28, var_102, adj_28, adj_102, adj_103);
            // adj: w = wp.vec3(joint_qd[qd_start + 0], joint_qd[qd_start + 1], joint_qd[qd_start + 2])  <L 305>
            wp::adj_quat_t(var_98, var_99, var_100, var_101, adj_87, adj_90, adj_93, adj_96, adj_97);
            wp::adj_address(var_joint_q, var_95, adj_joint_q, adj_95, adj_96);
            wp::adj_add(var_25, var_94, adj_25, adj_94, adj_95);
            wp::adj_address(var_joint_q, var_92, adj_joint_q, adj_92, adj_93);
            wp::adj_add(var_25, var_91, adj_25, adj_91, adj_92);
            wp::adj_address(var_joint_q, var_89, adj_joint_q, adj_89, adj_90);
            wp::adj_add(var_25, var_88, adj_25, adj_88, adj_89);
            wp::adj_address(var_joint_q, var_86, adj_joint_q, adj_86, adj_87);
            wp::adj_add(var_25, var_85, adj_25, adj_85, adj_86);
            // adj: r = wp.quat(joint_q[q_start + 0], joint_q[q_start + 1], joint_q[q_start + 2], joint_q[q_start + 3])  <L 303>
        }
        // adj: if type == JointType.BALL:                                                    <L 302>
        wp::adj_where(var_62, var_70, var_51, adj_62, adj_70, adj_51, adj_82);
        wp::adj_where(var_62, var_67, var_48, adj_62, adj_67, adj_48, adj_81);
        wp::adj_where(var_62, var_64, var_45, adj_62, adj_64, adj_45, adj_80);
        wp::adj_where(var_62, var_77, var_60, adj_62, adj_77, adj_60, adj_79);
        wp::adj_where(var_62, var_74, var_59, adj_62, adj_74, adj_59, adj_78);
        if (var_62) {
            wp::adj_vec_t(var_75, var_76, adj_75, adj_76, adj_77);
            wp::adj_mul(var_64, var_70, adj_64, adj_70, adj_76);
            // adj: v_j = wp.spatial_vector(wp.vec3(), axis * qd)                             <L 300>
            wp::adj_transform_t(var_72, var_73, adj_72, adj_73, adj_74);
            wp::adj_quat_from_axis_angle(var_64, var_67, adj_64, adj_67, adj_73);
            // adj: X_j = wp.transform(wp.vec3(), wp.quat_from_axis_angle(axis, q))           <L 299>
            wp::adj_copy(var_71, adj_69, adj_70);
            wp::adj_address(var_joint_qd, var_28, adj_joint_qd, adj_28, adj_69);
            // adj: qd = joint_qd[qd_start]                                                   <L 297>
            wp::adj_copy(var_68, adj_66, adj_67);
            wp::adj_address(var_joint_q, var_25, adj_joint_q, adj_25, adj_66);
            // adj: q = joint_q[q_start]                                                      <L 296>
            wp::adj_copy(var_65, adj_63, adj_64);
            wp::adj_address(var_joint_axis, var_28, adj_joint_axis, adj_28, adj_63);
            // adj: axis = joint_axis[qd_start]                                               <L 294>
        }
        // adj: if type == JointType.REVOLUTE:                                                <L 293>
        wp::adj_where(var_43, var_58, var_41, adj_43, adj_58, adj_41, adj_60);
        wp::adj_where(var_43, var_55, var_38, adj_43, adj_55, adj_38, adj_59);
        if (var_43) {
            wp::adj_vec_t(var_56, var_57, adj_56, adj_57, adj_58);
            wp::adj_mul(var_45, var_51, adj_45, adj_51, adj_56);
            // adj: v_j = wp.spatial_vector(axis * qd, wp.vec3())                             <L 291>
            wp::adj_transform_t(var_53, var_54, adj_53, adj_54, adj_55);
            wp::adj_mul(var_45, var_48, adj_45, adj_48, adj_53);
            // adj: X_j = wp.transform(axis * q, wp.quat_identity())                          <L 290>
            wp::adj_copy(var_52, adj_50, adj_51);
            wp::adj_address(var_joint_qd, var_28, adj_joint_qd, adj_28, adj_50);
            // adj: qd = joint_qd[qd_start]                                                   <L 288>
            wp::adj_copy(var_49, adj_47, adj_48);
            wp::adj_address(var_joint_q, var_25, adj_joint_q, adj_25, adj_47);
            // adj: q = joint_q[q_start]                                                      <L 287>
            wp::adj_copy(var_46, adj_44, adj_45);
            wp::adj_address(var_joint_axis, var_28, adj_joint_axis, adj_28, adj_44);
            // adj: axis = joint_axis[qd_start]                                               <L 285>
        }
        // adj: if type == JointType.PRISMATIC:                                               <L 284>
        wp::adj_vec_t(var_39, var_40, adj_39, adj_40, adj_41);
        // adj: v_j = wp.spatial_vector(wp.vec3(), wp.vec3())                                 <L 282>
        // adj: X_j = wp.transform_identity()                                                 <L 281>
        wp::adj_copy(var_37, adj_35, adj_36);
        wp::adj_address(var_joint_dof_dim, var_1, var_34, adj_joint_dof_dim, adj_1, adj_34, adj_35);
        // adj: ang_axis_count = joint_dof_dim[i, 1]                                          <L 279>
        wp::adj_copy(var_33, adj_31, adj_32);
        wp::adj_address(var_joint_dof_dim, var_1, var_30, adj_joint_dof_dim, adj_1, adj_30, adj_31);
        // adj: lin_axis_count = joint_dof_dim[i, 0]                                          <L 278>
        wp::adj_copy(var_29, adj_27, adj_28);
        wp::adj_address(var_joint_qd_start, var_1, adj_joint_qd_start, adj_1, adj_27);
        // adj: qd_start = joint_qd_start[i]                                                  <L 277>
        wp::adj_copy(var_26, adj_24, adj_25);
        wp::adj_address(var_joint_q_start, var_1, adj_joint_q_start, adj_1, adj_24);
        // adj: q_start = joint_q_start[i]                                                    <L 276>
        wp::adj_copy(var_23, adj_21, adj_22);
        wp::adj_address(var_joint_X_c, var_1, adj_joint_X_c, adj_1, adj_21);
        // adj: X_cj = joint_X_c[i]                                                           <L 274>
        wp::adj_copy(var_20, adj_18, adj_19);
        wp::adj_address(var_joint_X_p, var_1, adj_joint_X_p, adj_1, adj_18);
        // adj: X_pj = joint_X_p[i]                                                           <L 273>
        if (var_17) {
            // adj: continue                                                                  <L 271>
        }
        // adj: if type == JointType.CABLE:                                                   <L 269>
        wp::adj_copy(var_15, adj_13, adj_14);
        wp::adj_address(var_joint_type, var_1, adj_joint_type, adj_1, adj_13);
        // adj: type = joint_type[i]                                                          <L 268>
        wp::adj_copy(var_12, adj_10, adj_11);
        wp::adj_address(var_joint_child, var_1, adj_joint_child, adj_1, adj_10);
        // adj: child = joint_child[i]                                                        <L 265>
        wp::adj_copy(var_9, adj_7, adj_8);
        wp::adj_address(var_joint_parent, var_1, adj_joint_parent, adj_1, adj_7);
        // adj: parent = joint_parent[i]                                                      <L 264>
        if (var_6) {
            // adj: continue                                                                  <L 262>
        }
        // adj: if articulation == -1:                                                        <L 261>
        wp::adj_copy(var_4, adj_2, adj_3);
        wp::adj_address(var_joint_articulation, var_1, adj_joint_articulation, adj_1, adj_2);
        // adj: articulation = joint_articulation[i]                                          <L 260>
    	goto start_for_0;
    end_for_0:;
    // adj: for i in range(joint_start, joint_end):                                           <L 259>
    // adj: def eval_single_articulation_fk(                                                  <L 237>
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/warp/_src/math.py:196
static CUDA_CALLABLE void adj_quat_twist_angle_signed_0(
    wp::vec_t<3, wp::float32> var_axis,
    wp::quat_t<wp::float32> var_q,
    wp::vec_t<3, wp::float32> & adj_axis,
    wp::quat_t<wp::float32> & adj_q,
    wp::float32 & adj_ret)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    wp::float32 var_1;
    const wp::int32 var_2 = 1;
    wp::float32 var_3;
    const wp::int32 var_4 = 2;
    wp::float32 var_5;
    wp::vec_t<3, wp::float32> var_6;
    wp::float32 var_7;
    const wp::float32 var_8 = 2.0;
    const wp::int32 var_9 = 3;
    wp::float32 var_10;
    wp::float32 var_11;
    wp::float32 var_12;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    wp::float32 adj_1 = {};
    wp::int32 adj_2 = {};
    wp::float32 adj_3 = {};
    wp::int32 adj_4 = {};
    wp::float32 adj_5 = {};
    wp::vec_t<3, wp::float32> adj_6 = {};
    wp::float32 adj_7 = {};
    wp::float32 adj_8 = {};
    wp::int32 adj_9 = {};
    wp::float32 adj_10 = {};
    wp::float32 adj_11 = {};
    wp::float32 adj_12 = {};
    //---------
    // forward
    // def quat_twist_angle_signed(axis: wp.vec3, q: wp.quat) -> float:                       <L 197>
    // vector = wp.vec3(q[0], q[1], q[2])                                                     <L 215>
    var_1 = wp::extract(var_q, var_0);
    var_3 = wp::extract(var_q, var_2);
    var_5 = wp::extract(var_q, var_4);
    var_6 = wp::vec_t<3, wp::float32>(var_1, var_3, var_5);
    // sin_half = wp.dot(axis, vector)                                                        <L 216>
    var_7 = wp::dot(var_axis, var_6);
    // return 2.0 * wp.atan2(sin_half, q[3])                                                  <L 217>
    var_10 = wp::extract(var_q, var_9);
    var_11 = wp::atan2(var_7, var_10);
    var_12 = wp::mul(var_8, var_11);
    goto label0;
    //---------
    // reverse
    label0:;
    adj_12 += adj_ret;
    wp::adj_mul(var_8, var_11, adj_8, adj_11, adj_12);
    wp::adj_atan2(var_7, var_10, adj_7, adj_10, adj_11);
    wp::adj_extract(var_q, var_9, adj_q, adj_9, adj_10);
    // adj: return 2.0 * wp.atan2(sin_half, q[3])                                             <L 217>
    wp::adj_dot(var_axis, var_6, adj_axis, adj_6, adj_7);
    // adj: sin_half = wp.dot(axis, vector)                                                   <L 216>
    wp::adj_vec_t(var_1, var_3, var_5, adj_1, adj_3, adj_5, adj_6);
    wp::adj_extract(var_q, var_4, adj_q, adj_4, adj_5);
    wp::adj_extract(var_q, var_2, adj_q, adj_2, adj_3);
    wp::adj_extract(var_q, var_0, adj_q, adj_0, adj_1);
    // adj: vector = wp.vec3(q[0], q[1], q[2])                                                <L 215>
    // adj: def quat_twist_angle_signed(axis: wp.vec3, q: wp.quat) -> float:                  <L 197>
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/sim/articulation.py:617
static CUDA_CALLABLE void adj_reconstruct_angular_q_qd_0(
    wp::quat_t<wp::float32> var_q_pc,
    wp::vec_t<3, wp::float32> var_w_err,
    wp::transform_t<wp::float32> var_X_wp,
    wp::vec_t<3, wp::float32> var_axis,
    wp::float32 & ret_0,
    wp::float32 & ret_1,
    wp::quat_t<wp::float32> & adj_q_pc,
    wp::vec_t<3, wp::float32> & adj_w_err,
    wp::transform_t<wp::float32> & adj_X_wp,
    wp::vec_t<3, wp::float32> & adj_axis,
    wp::float32 & adj_ret_0,
    wp::float32 & adj_ret_1)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::float32 var_1;
    wp::float32 var_2;
    //---------
    // dual vars
    wp::vec_t<3, wp::float32> adj_0 = {};
    wp::float32 adj_1 = {};
    wp::float32 adj_2 = {};
    //---------
    // forward
    // def reconstruct_angular_q_qd(q_pc: wp.quat, w_err: wp.vec3, X_wp: wp.transform, axis: wp.vec3):       <L 618>
    // axis_p = wp.transform_vector(X_wp, axis)                                               <L 633>
    var_0 = wp::transform_vector(var_X_wp, var_axis);
    // q = wp.quat_twist_angle_signed(axis, q_pc)                                             <L 634>
    var_1 = quat_twist_angle_signed_0(var_axis, var_q_pc);
    // qd = wp.dot(w_err, axis_p)                                                             <L 635>
    var_2 = wp::dot(var_w_err, var_0);
    // return q, qd                                                                           <L 636>
    ret_0 = var_1;
    ret_1 = var_2;
    goto label0;
    //---------
    // reverse
    label0:;
    adj_2 += adj_ret_1;
    adj_1 += adj_ret_0;
    // adj: return q, qd                                                                      <L 636>
    wp::adj_dot(var_w_err, var_0, adj_w_err, adj_0, adj_2);
    // adj: qd = wp.dot(w_err, axis_p)                                                        <L 635>
    adj_quat_twist_angle_signed_0(var_axis, var_q_pc, adj_axis, adj_q_pc, adj_1);
    // adj: q = wp.quat_twist_angle_signed(axis, q_pc)                                        <L 634>
    wp::adj_transform_vector(var_X_wp, var_axis, adj_X_wp, adj_axis, adj_0);
    // adj: axis_p = wp.transform_vector(X_wp, axis)                                          <L 633>
    // adj: def reconstruct_angular_q_qd(q_pc: wp.quat, w_err: wp.vec3, X_wp: wp.transform, axis: wp.vec3):  <L 618>
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/warp/_src/math.py:253
static CUDA_CALLABLE void adj_quat_to_euler_0(
    wp::quat_t<wp::float32> var_q,
    wp::int32 var_i,
    wp::int32 var_j,
    wp::int32 var_k,
    wp::quat_t<wp::float32> & adj_q,
    wp::int32 & adj_i,
    wp::int32 & adj_j,
    wp::int32 & adj_k,
    wp::vec_t<3, wp::float32> & adj_ret)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 3;
    wp::float32 var_1;
    const wp::int32 var_2 = 0;
    wp::float32 var_3;
    const wp::int32 var_4 = 1;
    wp::float32 var_5;
    const wp::int32 var_6 = 2;
    wp::float32 var_7;
    const wp::int32 var_8 = 1;
    wp::int32 var_9;
    const wp::int32 var_10 = 1;
    wp::int32 var_11;
    const wp::int32 var_12 = 1;
    wp::int32 var_13;
    const bool var_14 = true;
    bool var_15;
    const bool var_16 = false;
    const wp::int32 var_17 = 6;
    wp::int32 var_18;
    wp::int32 var_19;
    wp::int32 var_20;
    bool var_21;
    wp::int32 var_22;
    wp::int32 var_23;
    wp::int32 var_24;
    wp::int32 var_25;
    wp::int32 var_26;
    wp::float32 var_27;
    const wp::float32 var_28 = 2.0;
    wp::float32 var_29;
    wp::float32 var_30;
    wp::float32 var_31;
    wp::float32 var_32;
    wp::float32 var_33;
    const wp::int32 var_34 = 2;
    bool var_35;
    wp::float32 var_36;
    const wp::int32 var_37 = 3;
    bool var_38;
    wp::float32 var_39;
    wp::float32 var_40;
    wp::float32 var_41;
    const wp::int32 var_42 = 2;
    bool var_43;
    wp::float32 var_44;
    const wp::int32 var_45 = 3;
    bool var_46;
    wp::float32 var_47;
    wp::float32 var_48;
    wp::float32 var_49;
    const wp::int32 var_50 = 2;
    bool var_51;
    wp::float32 var_52;
    const wp::int32 var_53 = 3;
    bool var_54;
    wp::float32 var_55;
    wp::float32 var_56;
    wp::float32 var_57;
    wp::float32 var_58;
    wp::float32 var_59;
    wp::float32 var_60;
    const wp::int32 var_61 = 2;
    bool var_62;
    wp::float32 var_63;
    const wp::int32 var_64 = 3;
    bool var_65;
    wp::float32 var_66;
    wp::float32 var_67;
    wp::float32 var_68;
    const wp::int32 var_69 = 2;
    bool var_70;
    wp::float32 var_71;
    const wp::int32 var_72 = 3;
    bool var_73;
    wp::float32 var_74;
    wp::float32 var_75;
    wp::float32 var_76;
    const wp::int32 var_77 = 2;
    bool var_78;
    wp::float32 var_79;
    const wp::int32 var_80 = 3;
    bool var_81;
    wp::float32 var_82;
    wp::float32 var_83;
    wp::float32 var_84;
    wp::float32 var_85;
    wp::float32 var_86;
    wp::float32 var_87;
    wp::float32 var_88;
    wp::float32 var_89;
    wp::float32 var_90;
    wp::float32 var_91;
    wp::float32 var_92;
    wp::float32 var_93;
    const wp::float32 var_94 = 2.0;
    wp::float32 var_95;
    wp::float32 var_96;
    wp::float32 var_97;
    wp::float32 var_98;
    wp::float32 var_99;
    wp::float32 var_100;
    wp::float32 var_101;
    wp::float32 var_102;
    wp::float32 var_103;
    wp::float32 var_104;
    wp::float32 var_105;
    wp::float32 var_106;
    const wp::float32 var_107 = 1.0;
    wp::float32 var_108;
    wp::float32 var_109;
    wp::float32 var_110;
    wp::float32 var_111;
    const wp::float32 var_112 = 0.0;
    const wp::float32 var_113 = 0.0;
    wp::float32 var_114;
    const wp::float32 var_115 = 1e-06;
    bool var_116;
    const wp::float32 var_117 = 2.0;
    wp::float32 var_118;
    wp::float32 var_119;
    const wp::float32 var_120 = 3.141592653589793;
    wp::float32 var_121;
    wp::float32 var_122;
    const wp::float32 var_123 = 1e-06;
    bool var_124;
    const wp::float32 var_125 = 2.0;
    wp::float32 var_126;
    wp::float32 var_127;
    wp::float32 var_128;
    wp::float32 var_129;
    wp::float32 var_130;
    wp::float32 var_131;
    wp::float32 var_132;
    wp::float32 var_133;
    const wp::float32 var_134 = 1.5707963267948966;
    wp::float32 var_135;
    wp::float32 var_136;
    wp::float32 var_137;
    wp::float32 var_138;
    wp::float32 var_139;
    wp::float32 var_140;
    wp::float32 var_141;
    const wp::int32 var_142 = 2;
    bool var_143;
    wp::float32 var_144;
    wp::float32 var_145;
    const wp::int32 var_146 = 3;
    bool var_147;
    wp::float32 var_148;
    wp::float32 var_149;
    wp::float32 var_150;
    wp::float32 var_151;
    wp::float32 var_152;
    wp::float32 var_153;
    wp::float32 var_154;
    const wp::int32 var_155 = 1;
    bool var_156;
    wp::float32 var_157;
    const wp::int32 var_158 = 2;
    bool var_159;
    wp::float32 var_160;
    wp::float32 var_161;
    wp::float32 var_162;
    wp::float32 var_163;
    wp::float32 var_164;
    wp::float32 var_165;
    wp::float32 var_166;
    const wp::int32 var_167 = 1;
    bool var_168;
    wp::float32 var_169;
    const wp::int32 var_170 = 2;
    bool var_171;
    wp::float32 var_172;
    wp::float32 var_173;
    wp::float32 var_174;
    wp::float32 var_175;
    wp::float32 var_176;
    wp::float32 var_177;
    wp::float32 var_178;
    wp::vec_t<3, wp::float32> var_179;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    wp::float32 adj_1 = {};
    wp::int32 adj_2 = {};
    wp::float32 adj_3 = {};
    wp::int32 adj_4 = {};
    wp::float32 adj_5 = {};
    wp::int32 adj_6 = {};
    wp::float32 adj_7 = {};
    wp::int32 adj_8 = {};
    wp::int32 adj_9 = {};
    wp::int32 adj_10 = {};
    wp::int32 adj_11 = {};
    wp::int32 adj_12 = {};
    wp::int32 adj_13 = {};
    bool adj_14 = {};
    bool adj_15 = {};
    bool adj_16 = {};
    wp::int32 adj_17 = {};
    wp::int32 adj_18 = {};
    wp::int32 adj_19 = {};
    wp::int32 adj_20 = {};
    bool adj_21 = {};
    wp::int32 adj_22 = {};
    wp::int32 adj_23 = {};
    wp::int32 adj_24 = {};
    wp::int32 adj_25 = {};
    wp::int32 adj_26 = {};
    wp::float32 adj_27 = {};
    wp::float32 adj_28 = {};
    wp::float32 adj_29 = {};
    wp::float32 adj_30 = {};
    wp::float32 adj_31 = {};
    wp::float32 adj_32 = {};
    wp::float32 adj_33 = {};
    wp::int32 adj_34 = {};
    bool adj_35 = {};
    wp::float32 adj_36 = {};
    wp::int32 adj_37 = {};
    bool adj_38 = {};
    wp::float32 adj_39 = {};
    wp::float32 adj_40 = {};
    wp::float32 adj_41 = {};
    wp::int32 adj_42 = {};
    bool adj_43 = {};
    wp::float32 adj_44 = {};
    wp::int32 adj_45 = {};
    bool adj_46 = {};
    wp::float32 adj_47 = {};
    wp::float32 adj_48 = {};
    wp::float32 adj_49 = {};
    wp::int32 adj_50 = {};
    bool adj_51 = {};
    wp::float32 adj_52 = {};
    wp::int32 adj_53 = {};
    bool adj_54 = {};
    wp::float32 adj_55 = {};
    wp::float32 adj_56 = {};
    wp::float32 adj_57 = {};
    wp::float32 adj_58 = {};
    wp::float32 adj_59 = {};
    wp::float32 adj_60 = {};
    wp::int32 adj_61 = {};
    bool adj_62 = {};
    wp::float32 adj_63 = {};
    wp::int32 adj_64 = {};
    bool adj_65 = {};
    wp::float32 adj_66 = {};
    wp::float32 adj_67 = {};
    wp::float32 adj_68 = {};
    wp::int32 adj_69 = {};
    bool adj_70 = {};
    wp::float32 adj_71 = {};
    wp::int32 adj_72 = {};
    bool adj_73 = {};
    wp::float32 adj_74 = {};
    wp::float32 adj_75 = {};
    wp::float32 adj_76 = {};
    wp::int32 adj_77 = {};
    bool adj_78 = {};
    wp::float32 adj_79 = {};
    wp::int32 adj_80 = {};
    bool adj_81 = {};
    wp::float32 adj_82 = {};
    wp::float32 adj_83 = {};
    wp::float32 adj_84 = {};
    wp::float32 adj_85 = {};
    wp::float32 adj_86 = {};
    wp::float32 adj_87 = {};
    wp::float32 adj_88 = {};
    wp::float32 adj_89 = {};
    wp::float32 adj_90 = {};
    wp::float32 adj_91 = {};
    wp::float32 adj_92 = {};
    wp::float32 adj_93 = {};
    wp::float32 adj_94 = {};
    wp::float32 adj_95 = {};
    wp::float32 adj_96 = {};
    wp::float32 adj_97 = {};
    wp::float32 adj_98 = {};
    wp::float32 adj_99 = {};
    wp::float32 adj_100 = {};
    wp::float32 adj_101 = {};
    wp::float32 adj_102 = {};
    wp::float32 adj_103 = {};
    wp::float32 adj_104 = {};
    wp::float32 adj_105 = {};
    wp::float32 adj_106 = {};
    wp::float32 adj_107 = {};
    wp::float32 adj_108 = {};
    wp::float32 adj_109 = {};
    wp::float32 adj_110 = {};
    wp::float32 adj_111 = {};
    wp::float32 adj_112 = {};
    wp::float32 adj_113 = {};
    wp::float32 adj_114 = {};
    wp::float32 adj_115 = {};
    bool adj_116 = {};
    wp::float32 adj_117 = {};
    wp::float32 adj_118 = {};
    wp::float32 adj_119 = {};
    wp::float32 adj_120 = {};
    wp::float32 adj_121 = {};
    wp::float32 adj_122 = {};
    wp::float32 adj_123 = {};
    bool adj_124 = {};
    wp::float32 adj_125 = {};
    wp::float32 adj_126 = {};
    wp::float32 adj_127 = {};
    wp::float32 adj_128 = {};
    wp::float32 adj_129 = {};
    wp::float32 adj_130 = {};
    wp::float32 adj_131 = {};
    wp::float32 adj_132 = {};
    wp::float32 adj_133 = {};
    wp::float32 adj_134 = {};
    wp::float32 adj_135 = {};
    wp::float32 adj_136 = {};
    wp::float32 adj_137 = {};
    wp::float32 adj_138 = {};
    wp::float32 adj_139 = {};
    wp::float32 adj_140 = {};
    wp::float32 adj_141 = {};
    wp::int32 adj_142 = {};
    bool adj_143 = {};
    wp::float32 adj_144 = {};
    wp::float32 adj_145 = {};
    wp::int32 adj_146 = {};
    bool adj_147 = {};
    wp::float32 adj_148 = {};
    wp::float32 adj_149 = {};
    wp::float32 adj_150 = {};
    wp::float32 adj_151 = {};
    wp::float32 adj_152 = {};
    wp::float32 adj_153 = {};
    wp::float32 adj_154 = {};
    wp::int32 adj_155 = {};
    bool adj_156 = {};
    wp::float32 adj_157 = {};
    wp::int32 adj_158 = {};
    bool adj_159 = {};
    wp::float32 adj_160 = {};
    wp::float32 adj_161 = {};
    wp::float32 adj_162 = {};
    wp::float32 adj_163 = {};
    wp::float32 adj_164 = {};
    wp::float32 adj_165 = {};
    wp::float32 adj_166 = {};
    wp::int32 adj_167 = {};
    bool adj_168 = {};
    wp::float32 adj_169 = {};
    wp::int32 adj_170 = {};
    bool adj_171 = {};
    wp::float32 adj_172 = {};
    wp::float32 adj_173 = {};
    wp::float32 adj_174 = {};
    wp::float32 adj_175 = {};
    wp::float32 adj_176 = {};
    wp::float32 adj_177 = {};
    wp::float32 adj_178 = {};
    wp::vec_t<3, wp::float32> adj_179 = {};
    //---------
    // forward
    // def quat_to_euler(q: wp.quat, i: int, j: int, k: int) -> wp.vec3:                      <L 254>
    // q0 = q[3]                                                                              <L 287>
    var_1 = wp::extract(var_q, var_0);
    // q1 = q[0]                                                                              <L 288>
    var_3 = wp::extract(var_q, var_2);
    // q2 = q[1]                                                                              <L 289>
    var_5 = wp::extract(var_q, var_4);
    // q3 = q[2]                                                                              <L 290>
    var_7 = wp::extract(var_q, var_6);
    // i += 1                                                                                 <L 294>
    var_9 = wp::add(var_i, var_8);
    // j += 1                                                                                 <L 295>
    var_11 = wp::add(var_j, var_10);
    // k += 1                                                                                 <L 296>
    var_13 = wp::add(var_k, var_12);
    // not_proper = True                                                                      <L 297>
    // if i == k:                                                                             <L 298>
    var_15 = (var_9 == var_13);
    if (var_15) {
        // not_proper = False                                                                 <L 299>
        // k = 6 - i - j  # because i + j + k = 1 + 2 + 3 = 6                                 <L 300>
        var_18 = wp::sub(var_17, var_9);
        var_19 = wp::sub(var_18, var_11);
    }
    var_20 = wp::where(var_15, var_19, var_13);
    var_21 = wp::where(var_15, var_16, var_14);
    // e = float((i - j) * (j - k) * (k - i)) / 2.0  # Levi-Civita symbol                     <L 301>
    var_22 = wp::sub(var_9, var_11);
    var_23 = wp::sub(var_11, var_20);
    var_24 = wp::mul(var_22, var_23);
    var_25 = wp::sub(var_20, var_9);
    var_26 = wp::mul(var_24, var_25);
    var_27 = wp::float(var_26);
    var_29 = wp::div(var_27, var_28);
    // a = q0                                                                                 <L 302>
    var_30 = wp::copy(var_1);
    // b = q1                                                                                 <L 303>
    var_31 = wp::copy(var_3);
    // c = q1                                                                                 <L 304>
    var_32 = wp::copy(var_3);
    // d = q1 * e                                                                             <L 305>
    var_33 = wp::mul(var_3, var_29);
    // if i == 2:                                                                             <L 307>
    var_35 = (var_9 == var_34);
    if (var_35) {
        // b = q2                                                                             <L 308>
        var_36 = wp::copy(var_5);
    }
    if (!var_35) {
        // elif i == 3:                                                                       <L 309>
        var_38 = (var_9 == var_37);
        if (var_38) {
            // b = q3                                                                         <L 310>
            var_39 = wp::copy(var_7);
        }
        var_40 = wp::where(var_38, var_39, var_31);
    }
    var_41 = wp::where(var_35, var_36, var_40);
    // if j == 2:                                                                             <L 312>
    var_43 = (var_11 == var_42);
    if (var_43) {
        // c = q2                                                                             <L 313>
        var_44 = wp::copy(var_5);
    }
    if (!var_43) {
        // elif j == 3:                                                                       <L 314>
        var_46 = (var_11 == var_45);
        if (var_46) {
            // c = q3                                                                         <L 315>
            var_47 = wp::copy(var_7);
        }
        var_48 = wp::where(var_46, var_47, var_32);
    }
    var_49 = wp::where(var_43, var_44, var_48);
    // if k == 2:                                                                             <L 317>
    var_51 = (var_20 == var_50);
    if (var_51) {
        // d = q2 * e                                                                         <L 318>
        var_52 = wp::mul(var_5, var_29);
    }
    if (!var_51) {
        // elif k == 3:                                                                       <L 319>
        var_54 = (var_20 == var_53);
        if (var_54) {
            // d = q3 * e                                                                     <L 320>
            var_55 = wp::mul(var_7, var_29);
        }
        var_56 = wp::where(var_54, var_55, var_33);
    }
    var_57 = wp::where(var_51, var_52, var_56);
    // if not_proper:                                                                         <L 322>
    if (var_21) {
        // qj = q1                                                                            <L 323>
        var_58 = wp::copy(var_3);
        // qk = q1                                                                            <L 324>
        var_59 = wp::copy(var_3);
        // qi = q1                                                                            <L 325>
        var_60 = wp::copy(var_3);
        // if j == 2:                                                                         <L 326>
        var_62 = (var_11 == var_61);
        if (var_62) {
            // qj = q2                                                                        <L 327>
            var_63 = wp::copy(var_5);
        }
        if (!var_62) {
            // elif j == 3:                                                                   <L 328>
            var_65 = (var_11 == var_64);
            if (var_65) {
                // qj = q3                                                                    <L 329>
                var_66 = wp::copy(var_7);
            }
            var_67 = wp::where(var_65, var_66, var_58);
        }
        var_68 = wp::where(var_62, var_63, var_67);
        // if k == 2:                                                                         <L 330>
        var_70 = (var_20 == var_69);
        if (var_70) {
            // qk = q2                                                                        <L 331>
            var_71 = wp::copy(var_5);
        }
        if (!var_70) {
            // elif k == 3:                                                                   <L 332>
            var_73 = (var_20 == var_72);
            if (var_73) {
                // qk = q3                                                                    <L 333>
                var_74 = wp::copy(var_7);
            }
            var_75 = wp::where(var_73, var_74, var_59);
        }
        var_76 = wp::where(var_70, var_71, var_75);
        // if i == 2:                                                                         <L 334>
        var_78 = (var_9 == var_77);
        if (var_78) {
            // qi = q2                                                                        <L 335>
            var_79 = wp::copy(var_5);
        }
        if (!var_78) {
            // elif i == 3:                                                                   <L 336>
            var_81 = (var_9 == var_80);
            if (var_81) {
                // qi = q3                                                                    <L 337>
                var_82 = wp::copy(var_7);
            }
            var_83 = wp::where(var_81, var_82, var_60);
        }
        var_84 = wp::where(var_78, var_79, var_83);
        // a -= qj                                                                            <L 339>
        var_85 = wp::sub(var_30, var_68);
        // b += qk * e                                                                        <L 340>
        var_86 = wp::mul(var_76, var_29);
        var_87 = wp::add(var_41, var_86);
        // c += q0                                                                            <L 341>
        var_88 = wp::add(var_49, var_1);
        // d -= qi                                                                            <L 342>
        var_89 = wp::sub(var_57, var_84);
    }
    var_90 = wp::where(var_21, var_85, var_30);
    var_91 = wp::where(var_21, var_87, var_41);
    var_92 = wp::where(var_21, var_88, var_49);
    var_93 = wp::where(var_21, var_89, var_57);
    // t2 = wp.acos(2.0 * (a * a + b * b) / (a * a + b * b + c * c + d * d) - 1.0)            <L 343>
    var_95 = wp::mul(var_90, var_90);
    var_96 = wp::mul(var_91, var_91);
    var_97 = wp::add(var_95, var_96);
    var_98 = wp::mul(var_94, var_97);
    var_99 = wp::mul(var_90, var_90);
    var_100 = wp::mul(var_91, var_91);
    var_101 = wp::add(var_99, var_100);
    var_102 = wp::mul(var_92, var_92);
    var_103 = wp::add(var_101, var_102);
    var_104 = wp::mul(var_93, var_93);
    var_105 = wp::add(var_103, var_104);
    var_106 = wp::div(var_98, var_105);
    var_108 = wp::sub(var_106, var_107);
    var_109 = wp::acos(var_108);
    // tp = wp.atan2(b, a)                                                                    <L 344>
    var_110 = wp::atan2(var_91, var_90);
    // tm = wp.atan2(d, c)                                                                    <L 345>
    var_111 = wp::atan2(var_93, var_92);
    // t1 = 0.0                                                                               <L 346>
    // t3 = 0.0                                                                               <L 347>
    // if wp.abs(t2) < 1e-6:                                                                  <L 348>
    var_114 = wp::abs(var_109);
    var_116 = (var_114 < var_115);
    if (var_116) {
        // t3 = 2.0 * tp - t1                                                                 <L 349>
        var_118 = wp::mul(var_117, var_110);
        var_119 = wp::sub(var_118, var_112);
    }
    if (!var_116) {
        // elif wp.abs(t2 - wp.pi) < 1e-6:                                                    <L 350>
        var_121 = wp::sub(var_109, var_120);
        var_122 = wp::abs(var_121);
        var_124 = (var_122 < var_123);
        if (var_124) {
            // t3 = 2.0 * tm + t1                                                             <L 351>
            var_126 = wp::mul(var_125, var_111);
            var_127 = wp::add(var_126, var_112);
        }
        if (!var_124) {
            // t1 = tp - tm                                                                   <L 353>
            var_128 = wp::sub(var_110, var_111);
            // t3 = tp + tm                                                                   <L 354>
            var_129 = wp::add(var_110, var_111);
        }
        var_130 = wp::where(var_124, var_112, var_128);
        var_131 = wp::where(var_124, var_127, var_129);
    }
    var_132 = wp::where(var_116, var_112, var_130);
    var_133 = wp::where(var_116, var_119, var_131);
    // if not_proper:                                                                         <L 355>
    if (var_21) {
        // t2 -= wp.HALF_PI                                                                   <L 356>
        var_135 = wp::sub(var_109, var_134);
        // t3 *= e                                                                            <L 357>
        var_136 = wp::mul(var_133, var_29);
    }
    var_137 = wp::where(var_21, var_135, var_109);
    var_138 = wp::where(var_21, var_136, var_133);
    // ex = t1                                                                                <L 362>
    var_139 = wp::copy(var_132);
    // ey = t2                                                                                <L 363>
    var_140 = wp::copy(var_137);
    // ez = t3                                                                                <L 364>
    var_141 = wp::copy(var_138);
    // if i == 2:                                                                             <L 365>
    var_143 = (var_9 == var_142);
    if (var_143) {
        // ex = t2                                                                            <L 366>
        var_144 = wp::copy(var_137);
        // ey = t1                                                                            <L 367>
        var_145 = wp::copy(var_132);
    }
    if (!var_143) {
        // elif i == 3:                                                                       <L 368>
        var_147 = (var_9 == var_146);
        if (var_147) {
            // ex = t3                                                                        <L 369>
            var_148 = wp::copy(var_138);
            // ez = t1                                                                        <L 370>
            var_149 = wp::copy(var_132);
        }
        var_150 = wp::where(var_147, var_148, var_139);
        var_151 = wp::where(var_147, var_149, var_141);
    }
    var_152 = wp::where(var_143, var_144, var_150);
    var_153 = wp::where(var_143, var_145, var_140);
    var_154 = wp::where(var_143, var_141, var_151);
    // if j == 1:                                                                             <L 372>
    var_156 = (var_11 == var_155);
    if (var_156) {
        // ex = t2                                                                            <L 373>
        var_157 = wp::copy(var_137);
    }
    if (!var_156) {
        // elif j == 2:                                                                       <L 374>
        var_159 = (var_11 == var_158);
        if (var_159) {
            // ey = t2                                                                        <L 375>
            var_160 = wp::copy(var_137);
        }
        if (!var_159) {
            // ez = t2                                                                        <L 377>
            var_161 = wp::copy(var_137);
        }
        var_162 = wp::where(var_159, var_160, var_153);
        var_163 = wp::where(var_159, var_154, var_161);
    }
    var_164 = wp::where(var_156, var_157, var_152);
    var_165 = wp::where(var_156, var_153, var_162);
    var_166 = wp::where(var_156, var_154, var_163);
    // if k == 1:                                                                             <L 379>
    var_168 = (var_20 == var_167);
    if (var_168) {
        // ex = t3                                                                            <L 380>
        var_169 = wp::copy(var_138);
    }
    if (!var_168) {
        // elif k == 2:                                                                       <L 381>
        var_171 = (var_20 == var_170);
        if (var_171) {
            // ey = t3                                                                        <L 382>
            var_172 = wp::copy(var_138);
        }
        if (!var_171) {
            // ez = t3                                                                        <L 384>
            var_173 = wp::copy(var_138);
        }
        var_174 = wp::where(var_171, var_172, var_165);
        var_175 = wp::where(var_171, var_166, var_173);
    }
    var_176 = wp::where(var_168, var_169, var_164);
    var_177 = wp::where(var_168, var_165, var_174);
    var_178 = wp::where(var_168, var_166, var_175);
    // return wp.vec3(ex, ey, ez)                                                             <L 386>
    var_179 = wp::vec_t<3, wp::float32>(var_176, var_177, var_178);
    goto label0;
    //---------
    // reverse
    label0:;
    adj_179 += adj_ret;
    wp::adj_vec_t(var_176, var_177, var_178, adj_176, adj_177, adj_178, adj_179);
    // adj: return wp.vec3(ex, ey, ez)                                                        <L 386>
    wp::adj_where(var_168, var_166, var_175, adj_168, adj_166, adj_175, adj_178);
    wp::adj_where(var_168, var_165, var_174, adj_168, adj_165, adj_174, adj_177);
    wp::adj_where(var_168, var_169, var_164, adj_168, adj_169, adj_164, adj_176);
    if (!var_168) {
        wp::adj_where(var_171, var_166, var_173, adj_171, adj_166, adj_173, adj_175);
        wp::adj_where(var_171, var_172, var_165, adj_171, adj_172, adj_165, adj_174);
        if (!var_171) {
            wp::adj_copy(var_138, adj_138, adj_173);
            // adj: ez = t3                                                                   <L 384>
        }
        if (var_171) {
            wp::adj_copy(var_138, adj_138, adj_172);
            // adj: ey = t3                                                                   <L 382>
        }
        // adj: elif k == 2:                                                                  <L 381>
    }
    if (var_168) {
        wp::adj_copy(var_138, adj_138, adj_169);
        // adj: ex = t3                                                                       <L 380>
    }
    // adj: if k == 1:                                                                        <L 379>
    wp::adj_where(var_156, var_154, var_163, adj_156, adj_154, adj_163, adj_166);
    wp::adj_where(var_156, var_153, var_162, adj_156, adj_153, adj_162, adj_165);
    wp::adj_where(var_156, var_157, var_152, adj_156, adj_157, adj_152, adj_164);
    if (!var_156) {
        wp::adj_where(var_159, var_154, var_161, adj_159, adj_154, adj_161, adj_163);
        wp::adj_where(var_159, var_160, var_153, adj_159, adj_160, adj_153, adj_162);
        if (!var_159) {
            wp::adj_copy(var_137, adj_137, adj_161);
            // adj: ez = t2                                                                   <L 377>
        }
        if (var_159) {
            wp::adj_copy(var_137, adj_137, adj_160);
            // adj: ey = t2                                                                   <L 375>
        }
        // adj: elif j == 2:                                                                  <L 374>
    }
    if (var_156) {
        wp::adj_copy(var_137, adj_137, adj_157);
        // adj: ex = t2                                                                       <L 373>
    }
    // adj: if j == 1:                                                                        <L 372>
    wp::adj_where(var_143, var_141, var_151, adj_143, adj_141, adj_151, adj_154);
    wp::adj_where(var_143, var_145, var_140, adj_143, adj_145, adj_140, adj_153);
    wp::adj_where(var_143, var_144, var_150, adj_143, adj_144, adj_150, adj_152);
    if (!var_143) {
        wp::adj_where(var_147, var_149, var_141, adj_147, adj_149, adj_141, adj_151);
        wp::adj_where(var_147, var_148, var_139, adj_147, adj_148, adj_139, adj_150);
        if (var_147) {
            wp::adj_copy(var_132, adj_132, adj_149);
            // adj: ez = t1                                                                   <L 370>
            wp::adj_copy(var_138, adj_138, adj_148);
            // adj: ex = t3                                                                   <L 369>
        }
        // adj: elif i == 3:                                                                  <L 368>
    }
    if (var_143) {
        wp::adj_copy(var_132, adj_132, adj_145);
        // adj: ey = t1                                                                       <L 367>
        wp::adj_copy(var_137, adj_137, adj_144);
        // adj: ex = t2                                                                       <L 366>
    }
    // adj: if i == 2:                                                                        <L 365>
    wp::adj_copy(var_138, adj_138, adj_141);
    // adj: ez = t3                                                                           <L 364>
    wp::adj_copy(var_137, adj_137, adj_140);
    // adj: ey = t2                                                                           <L 363>
    wp::adj_copy(var_132, adj_132, adj_139);
    // adj: ex = t1                                                                           <L 362>
    wp::adj_where(var_21, var_136, var_133, adj_21, adj_136, adj_133, adj_138);
    wp::adj_where(var_21, var_135, var_109, adj_21, adj_135, adj_109, adj_137);
    if (var_21) {
        wp::adj_mul(var_133, var_29, adj_133, adj_29, adj_136);
        // adj: t3 *= e                                                                       <L 357>
        wp::adj_sub(var_109, var_134, adj_109, adj_134, adj_135);
        // adj: t2 -= wp.HALF_PI                                                              <L 356>
    }
    // adj: if not_proper:                                                                    <L 355>
    wp::adj_where(var_116, var_119, var_131, adj_116, adj_119, adj_131, adj_133);
    wp::adj_where(var_116, var_112, var_130, adj_116, adj_112, adj_130, adj_132);
    if (!var_116) {
        wp::adj_where(var_124, var_127, var_129, adj_124, adj_127, adj_129, adj_131);
        wp::adj_where(var_124, var_112, var_128, adj_124, adj_112, adj_128, adj_130);
        if (!var_124) {
            wp::adj_add(var_110, var_111, adj_110, adj_111, adj_129);
            // adj: t3 = tp + tm                                                              <L 354>
            wp::adj_sub(var_110, var_111, adj_110, adj_111, adj_128);
            // adj: t1 = tp - tm                                                              <L 353>
        }
        if (var_124) {
            wp::adj_add(var_126, var_112, adj_126, adj_112, adj_127);
            wp::adj_mul(var_125, var_111, adj_125, adj_111, adj_126);
            // adj: t3 = 2.0 * tm + t1                                                        <L 351>
        }
        wp::adj_abs(var_121, adj_121, adj_122);
        wp::adj_sub(var_109, var_120, adj_109, adj_120, adj_121);
        // adj: elif wp.abs(t2 - wp.pi) < 1e-6:                                               <L 350>
    }
    if (var_116) {
        wp::adj_sub(var_118, var_112, adj_118, adj_112, adj_119);
        wp::adj_mul(var_117, var_110, adj_117, adj_110, adj_118);
        // adj: t3 = 2.0 * tp - t1                                                            <L 349>
    }
    wp::adj_abs(var_109, adj_109, adj_114);
    // adj: if wp.abs(t2) < 1e-6:                                                             <L 348>
    // adj: t3 = 0.0                                                                          <L 347>
    // adj: t1 = 0.0                                                                          <L 346>
    wp::adj_atan2(var_93, var_92, adj_93, adj_92, adj_111);
    // adj: tm = wp.atan2(d, c)                                                               <L 345>
    wp::adj_atan2(var_91, var_90, adj_91, adj_90, adj_110);
    // adj: tp = wp.atan2(b, a)                                                               <L 344>
    wp::adj_acos(var_108, adj_108, adj_109);
    wp::adj_sub(var_106, var_107, adj_106, adj_107, adj_108);
    wp::adj_div(var_98, var_105, var_106, adj_98, adj_105, adj_106);
    wp::adj_add(var_103, var_104, adj_103, adj_104, adj_105);
    wp::adj_mul(var_93, var_93, adj_93, adj_93, adj_104);
    wp::adj_add(var_101, var_102, adj_101, adj_102, adj_103);
    wp::adj_mul(var_92, var_92, adj_92, adj_92, adj_102);
    wp::adj_add(var_99, var_100, adj_99, adj_100, adj_101);
    wp::adj_mul(var_91, var_91, adj_91, adj_91, adj_100);
    wp::adj_mul(var_90, var_90, adj_90, adj_90, adj_99);
    wp::adj_mul(var_94, var_97, adj_94, adj_97, adj_98);
    wp::adj_add(var_95, var_96, adj_95, adj_96, adj_97);
    wp::adj_mul(var_91, var_91, adj_91, adj_91, adj_96);
    wp::adj_mul(var_90, var_90, adj_90, adj_90, adj_95);
    // adj: t2 = wp.acos(2.0 * (a * a + b * b) / (a * a + b * b + c * c + d * d) - 1.0)       <L 343>
    wp::adj_where(var_21, var_89, var_57, adj_21, adj_89, adj_57, adj_93);
    wp::adj_where(var_21, var_88, var_49, adj_21, adj_88, adj_49, adj_92);
    wp::adj_where(var_21, var_87, var_41, adj_21, adj_87, adj_41, adj_91);
    wp::adj_where(var_21, var_85, var_30, adj_21, adj_85, adj_30, adj_90);
    if (var_21) {
        wp::adj_sub(var_57, var_84, adj_57, adj_84, adj_89);
        // adj: d -= qi                                                                       <L 342>
        wp::adj_add(var_49, var_1, adj_49, adj_1, adj_88);
        // adj: c += q0                                                                       <L 341>
        wp::adj_add(var_41, var_86, adj_41, adj_86, adj_87);
        wp::adj_mul(var_76, var_29, adj_76, adj_29, adj_86);
        // adj: b += qk * e                                                                   <L 340>
        wp::adj_sub(var_30, var_68, adj_30, adj_68, adj_85);
        // adj: a -= qj                                                                       <L 339>
        wp::adj_where(var_78, var_79, var_83, adj_78, adj_79, adj_83, adj_84);
        if (!var_78) {
            wp::adj_where(var_81, var_82, var_60, adj_81, adj_82, adj_60, adj_83);
            if (var_81) {
                wp::adj_copy(var_7, adj_7, adj_82);
                // adj: qi = q3                                                               <L 337>
            }
            // adj: elif i == 3:                                                              <L 336>
        }
        if (var_78) {
            wp::adj_copy(var_5, adj_5, adj_79);
            // adj: qi = q2                                                                   <L 335>
        }
        // adj: if i == 2:                                                                    <L 334>
        wp::adj_where(var_70, var_71, var_75, adj_70, adj_71, adj_75, adj_76);
        if (!var_70) {
            wp::adj_where(var_73, var_74, var_59, adj_73, adj_74, adj_59, adj_75);
            if (var_73) {
                wp::adj_copy(var_7, adj_7, adj_74);
                // adj: qk = q3                                                               <L 333>
            }
            // adj: elif k == 3:                                                              <L 332>
        }
        if (var_70) {
            wp::adj_copy(var_5, adj_5, adj_71);
            // adj: qk = q2                                                                   <L 331>
        }
        // adj: if k == 2:                                                                    <L 330>
        wp::adj_where(var_62, var_63, var_67, adj_62, adj_63, adj_67, adj_68);
        if (!var_62) {
            wp::adj_where(var_65, var_66, var_58, adj_65, adj_66, adj_58, adj_67);
            if (var_65) {
                wp::adj_copy(var_7, adj_7, adj_66);
                // adj: qj = q3                                                               <L 329>
            }
            // adj: elif j == 3:                                                              <L 328>
        }
        if (var_62) {
            wp::adj_copy(var_5, adj_5, adj_63);
            // adj: qj = q2                                                                   <L 327>
        }
        // adj: if j == 2:                                                                    <L 326>
        wp::adj_copy(var_3, adj_3, adj_60);
        // adj: qi = q1                                                                       <L 325>
        wp::adj_copy(var_3, adj_3, adj_59);
        // adj: qk = q1                                                                       <L 324>
        wp::adj_copy(var_3, adj_3, adj_58);
        // adj: qj = q1                                                                       <L 323>
    }
    // adj: if not_proper:                                                                    <L 322>
    wp::adj_where(var_51, var_52, var_56, adj_51, adj_52, adj_56, adj_57);
    if (!var_51) {
        wp::adj_where(var_54, var_55, var_33, adj_54, adj_55, adj_33, adj_56);
        if (var_54) {
            wp::adj_mul(var_7, var_29, adj_7, adj_29, adj_55);
            // adj: d = q3 * e                                                                <L 320>
        }
        // adj: elif k == 3:                                                                  <L 319>
    }
    if (var_51) {
        wp::adj_mul(var_5, var_29, adj_5, adj_29, adj_52);
        // adj: d = q2 * e                                                                    <L 318>
    }
    // adj: if k == 2:                                                                        <L 317>
    wp::adj_where(var_43, var_44, var_48, adj_43, adj_44, adj_48, adj_49);
    if (!var_43) {
        wp::adj_where(var_46, var_47, var_32, adj_46, adj_47, adj_32, adj_48);
        if (var_46) {
            wp::adj_copy(var_7, adj_7, adj_47);
            // adj: c = q3                                                                    <L 315>
        }
        // adj: elif j == 3:                                                                  <L 314>
    }
    if (var_43) {
        wp::adj_copy(var_5, adj_5, adj_44);
        // adj: c = q2                                                                        <L 313>
    }
    // adj: if j == 2:                                                                        <L 312>
    wp::adj_where(var_35, var_36, var_40, adj_35, adj_36, adj_40, adj_41);
    if (!var_35) {
        wp::adj_where(var_38, var_39, var_31, adj_38, adj_39, adj_31, adj_40);
        if (var_38) {
            wp::adj_copy(var_7, adj_7, adj_39);
            // adj: b = q3                                                                    <L 310>
        }
        // adj: elif i == 3:                                                                  <L 309>
    }
    if (var_35) {
        wp::adj_copy(var_5, adj_5, adj_36);
        // adj: b = q2                                                                        <L 308>
    }
    // adj: if i == 2:                                                                        <L 307>
    wp::adj_mul(var_3, var_29, adj_3, adj_29, adj_33);
    // adj: d = q1 * e                                                                        <L 305>
    wp::adj_copy(var_3, adj_3, adj_32);
    // adj: c = q1                                                                            <L 304>
    wp::adj_copy(var_3, adj_3, adj_31);
    // adj: b = q1                                                                            <L 303>
    wp::adj_copy(var_1, adj_1, adj_30);
    // adj: a = q0                                                                            <L 302>
    wp::adj_div(var_27, var_28, var_29, adj_27, adj_28, adj_29);
    wp::adj_float(var_26, adj_26, adj_27);
    wp::adj_mul(var_24, var_25, adj_24, adj_25, adj_26);
    wp::adj_sub(var_20, var_9, adj_20, adj_9, adj_25);
    wp::adj_mul(var_22, var_23, adj_22, adj_23, adj_24);
    wp::adj_sub(var_11, var_20, adj_11, adj_20, adj_23);
    wp::adj_sub(var_9, var_11, adj_9, adj_11, adj_22);
    // adj: e = float((i - j) * (j - k) * (k - i)) / 2.0  # Levi-Civita symbol                <L 301>
    wp::adj_where(var_15, var_16, var_14, adj_15, adj_16, adj_14, adj_21);
    wp::adj_where(var_15, var_19, var_13, adj_15, adj_19, adj_13, adj_20);
    if (var_15) {
        wp::adj_sub(var_18, var_11, adj_18, adj_11, adj_19);
        wp::adj_sub(var_17, var_9, adj_17, adj_9, adj_18);
        // adj: k = 6 - i - j  # because i + j + k = 1 + 2 + 3 = 6                            <L 300>
        // adj: not_proper = False                                                            <L 299>
    }
    // adj: if i == k:                                                                        <L 298>
    // adj: not_proper = True                                                                 <L 297>
    wp::adj_add(var_k, var_12, adj_k, adj_12, adj_13);
    // adj: k += 1                                                                            <L 296>
    wp::adj_add(var_j, var_10, adj_j, adj_10, adj_11);
    // adj: j += 1                                                                            <L 295>
    wp::adj_add(var_i, var_8, adj_i, adj_8, adj_9);
    // adj: i += 1                                                                            <L 294>
    wp::adj_extract(var_q, var_6, adj_q, adj_6, adj_7);
    // adj: q3 = q[2]                                                                         <L 290>
    wp::adj_extract(var_q, var_4, adj_q, adj_4, adj_5);
    // adj: q2 = q[1]                                                                         <L 289>
    wp::adj_extract(var_q, var_2, adj_q, adj_2, adj_3);
    // adj: q1 = q[0]                                                                         <L 288>
    wp::adj_extract(var_q, var_0, adj_q, adj_0, adj_1);
    // adj: q0 = q[3]                                                                         <L 287>
    // adj: def quat_to_euler(q: wp.quat, i: int, j: int, k: int) -> wp.vec3:                 <L 254>
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/math/spatial.py:133
static CUDA_CALLABLE void adj__wrap_angle_pm_pi_0(
    wp::float32 var_theta,
    wp::float32 & adj_theta,
    wp::float32 & adj_ret)
{
    //---------
    // primal vars
    const wp::float32 var_0 = 2.0;
    const wp::float32 var_1 = 3.141592653589793;
    wp::float32 var_2;
    const wp::float32 var_3 = 3.141592653589793;
    wp::float32 var_4;
    wp::float32 var_5;
    const wp::float32 var_6 = 0.0;
    bool var_7;
    wp::float32 var_8;
    wp::float32 var_9;
    const wp::float32 var_10 = 3.141592653589793;
    wp::float32 var_11;
    //---------
    // dual vars
    wp::float32 adj_0 = {};
    wp::float32 adj_1 = {};
    wp::float32 adj_2 = {};
    wp::float32 adj_3 = {};
    wp::float32 adj_4 = {};
    wp::float32 adj_5 = {};
    wp::float32 adj_6 = {};
    bool adj_7 = {};
    wp::float32 adj_8 = {};
    wp::float32 adj_9 = {};
    wp::float32 adj_10 = {};
    wp::float32 adj_11 = {};
    //---------
    // forward
    // def _wrap_angle_pm_pi(theta: float) -> float:                                          <L 134>
    // two_pi = 2.0 * wp.pi                                                                   <L 143>
    var_2 = wp::mul(var_0, var_1);
    // wrapped = wp.mod(theta + wp.pi, two_pi)                                                <L 144>
    var_4 = wp::add(var_theta, var_3);
    var_5 = wp::mod(var_4, var_2);
    // if wrapped < 0.0:                                                                      <L 145>
    var_7 = (var_5 < var_6);
    if (var_7) {
        // wrapped += two_pi                                                                  <L 146>
        var_8 = wp::add(var_5, var_2);
    }
    var_9 = wp::where(var_7, var_8, var_5);
    // return wrapped - wp.pi                                                                 <L 147>
    var_11 = wp::sub(var_9, var_10);
    goto label0;
    //---------
    // reverse
    label0:;
    adj_11 += adj_ret;
    wp::adj_sub(var_9, var_10, adj_9, adj_10, adj_11);
    // adj: return wrapped - wp.pi                                                            <L 147>
    wp::adj_where(var_7, var_8, var_5, adj_7, adj_8, adj_5, adj_9);
    if (var_7) {
        wp::adj_add(var_5, var_2, adj_5, adj_2, adj_8);
        // adj: wrapped += two_pi                                                             <L 146>
    }
    // adj: if wrapped < 0.0:                                                                 <L 145>
    wp::adj_mod(var_4, var_2, adj_4, adj_2, adj_5);
    wp::adj_add(var_theta, var_3, adj_theta, adj_3, adj_4);
    // adj: wrapped = wp.mod(theta + wp.pi, two_pi)                                           <L 144>
    wp::adj_mul(var_0, var_1, adj_0, adj_1, adj_2);
    // adj: two_pi = 2.0 * wp.pi                                                              <L 143>
    // adj: def _wrap_angle_pm_pi(theta: float) -> float:                                     <L 134>
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/math/spatial.py:150
static CUDA_CALLABLE void adj_quat_decompose_0(
    wp::quat_t<wp::float32> var_q,
    wp::quat_t<wp::float32> & adj_q,
    wp::vec_t<3, wp::float32> & adj_ret)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 2;
    const wp::int32 var_1 = 1;
    const wp::int32 var_2 = 0;
    wp::vec_t<3, wp::float32> var_3;
    const wp::int32 var_4 = 0;
    wp::float32 var_5;
    wp::float32 var_6;
    const wp::int32 var_7 = 1;
    wp::float32 var_8;
    wp::float32 var_9;
    const wp::int32 var_10 = 2;
    wp::float32 var_11;
    wp::float32 var_12;
    wp::vec_t<3, wp::float32> var_13;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    wp::int32 adj_1 = {};
    wp::int32 adj_2 = {};
    wp::vec_t<3, wp::float32> adj_3 = {};
    wp::int32 adj_4 = {};
    wp::float32 adj_5 = {};
    wp::float32 adj_6 = {};
    wp::int32 adj_7 = {};
    wp::float32 adj_8 = {};
    wp::float32 adj_9 = {};
    wp::int32 adj_10 = {};
    wp::float32 adj_11 = {};
    wp::float32 adj_12 = {};
    wp::vec_t<3, wp::float32> adj_13 = {};
    //---------
    // forward
    // def quat_decompose(q: wp.quat) -> wp.vec3:                                             <L 151>
    // angles = wp.quat_to_euler(q, 2, 1, 0)                                                  <L 170>
    var_3 = quat_to_euler_0(var_q, var_0, var_1, var_2);
    // return wp.vec3(                                                                        <L 171>
    // _wrap_angle_pm_pi(angles[0]),                                                          <L 172>
    var_5 = wp::extract(var_3, var_4);
    var_6 = _wrap_angle_pm_pi_0(var_5);
    // _wrap_angle_pm_pi(angles[1]),                                                          <L 173>
    var_8 = wp::extract(var_3, var_7);
    var_9 = _wrap_angle_pm_pi_0(var_8);
    // _wrap_angle_pm_pi(angles[2]),                                                          <L 174>
    var_11 = wp::extract(var_3, var_10);
    var_12 = _wrap_angle_pm_pi_0(var_11);
    var_13 = wp::vec_t<3, wp::float32>(var_6, var_9, var_12);
    goto label0;
    //---------
    // reverse
    label0:;
    adj_13 += adj_ret;
    wp::adj_vec_t(var_6, var_9, var_12, adj_6, adj_9, adj_12, adj_13);
    adj__wrap_angle_pm_pi_0(var_11, adj_11, adj_12);
    wp::adj_extract(var_3, var_10, adj_3, adj_10, adj_11);
    // adj: _wrap_angle_pm_pi(angles[2]),                                                     <L 174>
    adj__wrap_angle_pm_pi_0(var_8, adj_8, adj_9);
    wp::adj_extract(var_3, var_7, adj_3, adj_7, adj_8);
    // adj: _wrap_angle_pm_pi(angles[1]),                                                     <L 173>
    adj__wrap_angle_pm_pi_0(var_5, adj_5, adj_6);
    wp::adj_extract(var_3, var_4, adj_3, adj_4, adj_5);
    // adj: _wrap_angle_pm_pi(angles[0]),                                                     <L 172>
    // adj: return wp.vec3(                                                                   <L 171>
    adj_quat_to_euler_0(var_q, var_0, var_1, var_2, adj_q, adj_0, adj_1, adj_2, adj_3);
    // adj: angles = wp.quat_to_euler(q, 2, 1, 0)                                             <L 170>
    // adj: def quat_decompose(q: wp.quat) -> wp.vec3:                                        <L 151>
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/sim/articulation.py:85
static CUDA_CALLABLE void adj_invert_2d_rotational_dofs_0(
    wp::vec_t<3, wp::float32> var_axis_0,
    wp::vec_t<3, wp::float32> var_axis_1,
    wp::quat_t<wp::float32> var_q_p,
    wp::quat_t<wp::float32> var_q_c,
    wp::vec_t<3, wp::float32> var_w_err,
    wp::vec_t<2, wp::float32> & ret_0,
    wp::vec_t<2, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & adj_axis_0,
    wp::vec_t<3, wp::float32> & adj_axis_1,
    wp::quat_t<wp::float32> & adj_q_p,
    wp::quat_t<wp::float32> & adj_q_c,
    wp::vec_t<3, wp::float32> & adj_w_err,
    wp::vec_t<2, wp::float32> & adj_ret_0,
    wp::vec_t<2, wp::float32> & adj_ret_1)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::mat_t<3, 3, wp::float32> var_1;
    wp::quat_t<wp::float32> var_2;
    wp::quat_t<wp::float32> var_3;
    wp::quat_t<wp::float32> var_4;
    wp::quat_t<wp::float32> var_5;
    wp::quat_t<wp::float32> var_6;
    wp::quat_t<wp::float32> var_7;
    wp::vec_t<3, wp::float32> var_8;
    const wp::float32 var_9 = 1.0;
    const wp::float32 var_10 = 0.0;
    const wp::float32 var_11 = 0.0;
    wp::vec_t<3, wp::float32> var_12;
    wp::vec_t<3, wp::float32> var_13;
    const wp::float32 var_14 = 0.0;
    const wp::float32 var_15 = 1.0;
    const wp::float32 var_16 = 0.0;
    wp::vec_t<3, wp::float32> var_17;
    wp::vec_t<3, wp::float32> var_18;
    const wp::float32 var_19 = 0.0;
    const wp::float32 var_20 = 0.0;
    const wp::float32 var_21 = 1.0;
    wp::vec_t<3, wp::float32> var_22;
    wp::vec_t<3, wp::float32> var_23;
    wp::vec_t<3, wp::float32> var_24;
    const wp::int32 var_25 = 0;
    wp::float32 var_26;
    wp::quat_t<wp::float32> var_27;
    wp::vec_t<3, wp::float32> var_28;
    const wp::int32 var_29 = 1;
    wp::float32 var_30;
    wp::quat_t<wp::float32> var_31;
    wp::quat_t<wp::float32> var_32;
    wp::vec_t<3, wp::float32> var_33;
    wp::vec_t<3, wp::float32> var_34;
    wp::vec_t<3, wp::float32> var_35;
    wp::vec_t<3, wp::float32> var_36;
    wp::float32 var_37;
    wp::float32 var_38;
    wp::float32 var_39;
    wp::float32 var_40;
    wp::float32 var_41;
    wp::float32 var_42;
    wp::vec_t<2, wp::float32> var_43;
    const wp::int32 var_44 = 0;
    wp::float32 var_45;
    const wp::int32 var_46 = 1;
    wp::float32 var_47;
    wp::vec_t<2, wp::float32> var_48;
    //---------
    // dual vars
    wp::vec_t<3, wp::float32> adj_0 = {};
    wp::mat_t<3, 3, wp::float32> adj_1 = {};
    wp::quat_t<wp::float32> adj_2 = {};
    wp::quat_t<wp::float32> adj_3 = {};
    wp::quat_t<wp::float32> adj_4 = {};
    wp::quat_t<wp::float32> adj_5 = {};
    wp::quat_t<wp::float32> adj_6 = {};
    wp::quat_t<wp::float32> adj_7 = {};
    wp::vec_t<3, wp::float32> adj_8 = {};
    wp::float32 adj_9 = {};
    wp::float32 adj_10 = {};
    wp::float32 adj_11 = {};
    wp::vec_t<3, wp::float32> adj_12 = {};
    wp::vec_t<3, wp::float32> adj_13 = {};
    wp::float32 adj_14 = {};
    wp::float32 adj_15 = {};
    wp::float32 adj_16 = {};
    wp::vec_t<3, wp::float32> adj_17 = {};
    wp::vec_t<3, wp::float32> adj_18 = {};
    wp::float32 adj_19 = {};
    wp::float32 adj_20 = {};
    wp::float32 adj_21 = {};
    wp::vec_t<3, wp::float32> adj_22 = {};
    wp::vec_t<3, wp::float32> adj_23 = {};
    wp::vec_t<3, wp::float32> adj_24 = {};
    wp::int32 adj_25 = {};
    wp::float32 adj_26 = {};
    wp::quat_t<wp::float32> adj_27 = {};
    wp::vec_t<3, wp::float32> adj_28 = {};
    wp::int32 adj_29 = {};
    wp::float32 adj_30 = {};
    wp::quat_t<wp::float32> adj_31 = {};
    wp::quat_t<wp::float32> adj_32 = {};
    wp::vec_t<3, wp::float32> adj_33 = {};
    wp::vec_t<3, wp::float32> adj_34 = {};
    wp::vec_t<3, wp::float32> adj_35 = {};
    wp::vec_t<3, wp::float32> adj_36 = {};
    wp::float32 adj_37 = {};
    wp::float32 adj_38 = {};
    wp::float32 adj_39 = {};
    wp::float32 adj_40 = {};
    wp::float32 adj_41 = {};
    wp::float32 adj_42 = {};
    wp::vec_t<2, wp::float32> adj_43 = {};
    wp::int32 adj_44 = {};
    wp::float32 adj_45 = {};
    wp::int32 adj_46 = {};
    wp::float32 adj_47 = {};
    wp::vec_t<2, wp::float32> adj_48 = {};
    //---------
    // forward
    // def invert_2d_rotational_dofs(                                                         <L 86>
    // q_off = wp.quat_from_matrix(wp.matrix_from_cols(axis_0, axis_1, wp.cross(axis_0, axis_1)))       <L 96>
    var_0 = wp::cross(var_axis_0, var_axis_1);
    var_1 = wp::matrix_from_cols<wp::float32>(var_axis_0, var_axis_1, var_0);
    var_2 = wp::quat_from_matrix(var_1);
    // q_pc = wp.quat_inverse(q_off) * wp.quat_inverse(q_p) * q_c * q_off                     <L 97>
    var_3 = wp::quat_inverse(var_2);
    var_4 = wp::quat_inverse(var_q_p);
    var_5 = wp::mul(var_3, var_4);
    var_6 = wp::mul(var_5, var_q_c);
    var_7 = wp::mul(var_6, var_2);
    // angles = quat_decompose(q_pc)                                                          <L 100>
    var_8 = quat_decompose_0(var_7);
    // local_0 = wp.quat_rotate(q_off, wp.vec3(1.0, 0.0, 0.0))                                <L 103>
    var_12 = wp::vec_t<3, wp::float32>(var_9, var_10, var_11);
    var_13 = wp::quat_rotate(var_2, var_12);
    // local_1 = wp.quat_rotate(q_off, wp.vec3(0.0, 1.0, 0.0))                                <L 104>
    var_17 = wp::vec_t<3, wp::float32>(var_14, var_15, var_16);
    var_18 = wp::quat_rotate(var_2, var_17);
    // local_2 = wp.quat_rotate(q_off, wp.vec3(0.0, 0.0, 1.0))                                <L 105>
    var_22 = wp::vec_t<3, wp::float32>(var_19, var_20, var_21);
    var_23 = wp::quat_rotate(var_2, var_22);
    // axis_0 = local_0                                                                       <L 107>
    var_24 = wp::copy(var_13);
    // q_0 = wp.quat_from_axis_angle(axis_0, angles[0])                                       <L 108>
    var_26 = wp::extract(var_8, var_25);
    var_27 = wp::quat_from_axis_angle(var_24, var_26);
    // axis_1 = wp.quat_rotate(q_0, local_1)                                                  <L 110>
    var_28 = wp::quat_rotate(var_27, var_18);
    // q_1 = wp.quat_from_axis_angle(axis_1, angles[1])                                       <L 111>
    var_30 = wp::extract(var_8, var_29);
    var_31 = wp::quat_from_axis_angle(var_28, var_30);
    // axis_2 = wp.quat_rotate(q_1 * q_0, local_2)                                            <L 113>
    var_32 = wp::mul(var_31, var_27);
    var_33 = wp::quat_rotate(var_32, var_23);
    // w_err_p = wp.quat_rotate_inv(q_p, w_err)                                               <L 116>
    var_34 = wp::quat_rotate_inv(var_q_p, var_w_err);
    // c12 = wp.cross(axis_1, axis_2)                                                         <L 119>
    var_35 = wp::cross(var_28, var_33);
    // c02 = wp.cross(axis_0, axis_2)                                                         <L 120>
    var_36 = wp::cross(var_24, var_33);
    // vel = wp.vec2(wp.dot(w_err_p, c12) / wp.dot(axis_0, c12), wp.dot(w_err_p, c02) / wp.dot(axis_1, c02))       <L 122>
    var_37 = wp::dot(var_34, var_35);
    var_38 = wp::dot(var_24, var_35);
    var_39 = wp::div(var_37, var_38);
    var_40 = wp::dot(var_34, var_36);
    var_41 = wp::dot(var_28, var_36);
    var_42 = wp::div(var_40, var_41);
    var_43 = wp::vec_t<2, wp::float32>(var_39, var_42);
    // return wp.vec2(angles[0], angles[1]), vel                                              <L 124>
    var_45 = wp::extract(var_8, var_44);
    var_47 = wp::extract(var_8, var_46);
    var_48 = wp::vec_t<2, wp::float32>(var_45, var_47);
    ret_0 = var_48;
    ret_1 = var_43;
    goto label0;
    //---------
    // reverse
    label0:;
    adj_43 += adj_ret_1;
    adj_48 += adj_ret_0;
    wp::adj_vec_t(var_45, var_47, adj_45, adj_47, adj_48);
    wp::adj_extract(var_8, var_46, adj_8, adj_46, adj_47);
    wp::adj_extract(var_8, var_44, adj_8, adj_44, adj_45);
    // adj: return wp.vec2(angles[0], angles[1]), vel                                         <L 124>
    wp::adj_vec_t(var_39, var_42, adj_39, adj_42, adj_43);
    wp::adj_div(var_40, var_41, var_42, adj_40, adj_41, adj_42);
    wp::adj_dot(var_28, var_36, adj_28, adj_36, adj_41);
    wp::adj_dot(var_34, var_36, adj_34, adj_36, adj_40);
    wp::adj_div(var_37, var_38, var_39, adj_37, adj_38, adj_39);
    wp::adj_dot(var_24, var_35, adj_24, adj_35, adj_38);
    wp::adj_dot(var_34, var_35, adj_34, adj_35, adj_37);
    // adj: vel = wp.vec2(wp.dot(w_err_p, c12) / wp.dot(axis_0, c12), wp.dot(w_err_p, c02) / wp.dot(axis_1, c02))  <L 122>
    wp::adj_cross(var_24, var_33, adj_24, adj_33, adj_36);
    // adj: c02 = wp.cross(axis_0, axis_2)                                                    <L 120>
    wp::adj_cross(var_28, var_33, adj_28, adj_33, adj_35);
    // adj: c12 = wp.cross(axis_1, axis_2)                                                    <L 119>
    wp::adj_quat_rotate_inv(var_q_p, var_w_err, adj_q_p, adj_w_err, adj_34);
    // adj: w_err_p = wp.quat_rotate_inv(q_p, w_err)                                          <L 116>
    wp::adj_quat_rotate(var_32, var_23, adj_32, adj_23, adj_33);
    wp::adj_mul(var_31, var_27, adj_31, adj_27, adj_32);
    // adj: axis_2 = wp.quat_rotate(q_1 * q_0, local_2)                                       <L 113>
    wp::adj_quat_from_axis_angle(var_28, var_30, adj_28, adj_30, adj_31);
    wp::adj_extract(var_8, var_29, adj_8, adj_29, adj_30);
    // adj: q_1 = wp.quat_from_axis_angle(axis_1, angles[1])                                  <L 111>
    wp::adj_quat_rotate(var_27, var_18, adj_27, adj_18, adj_28);
    // adj: axis_1 = wp.quat_rotate(q_0, local_1)                                             <L 110>
    wp::adj_quat_from_axis_angle(var_24, var_26, adj_24, adj_26, adj_27);
    wp::adj_extract(var_8, var_25, adj_8, adj_25, adj_26);
    // adj: q_0 = wp.quat_from_axis_angle(axis_0, angles[0])                                  <L 108>
    wp::adj_copy(var_13, adj_13, adj_24);
    // adj: axis_0 = local_0                                                                  <L 107>
    wp::adj_quat_rotate(var_2, var_22, adj_2, adj_22, adj_23);
    wp::adj_vec_t(var_19, var_20, var_21, adj_19, adj_20, adj_21, adj_22);
    // adj: local_2 = wp.quat_rotate(q_off, wp.vec3(0.0, 0.0, 1.0))                           <L 105>
    wp::adj_quat_rotate(var_2, var_17, adj_2, adj_17, adj_18);
    wp::adj_vec_t(var_14, var_15, var_16, adj_14, adj_15, adj_16, adj_17);
    // adj: local_1 = wp.quat_rotate(q_off, wp.vec3(0.0, 1.0, 0.0))                           <L 104>
    wp::adj_quat_rotate(var_2, var_12, adj_2, adj_12, adj_13);
    wp::adj_vec_t(var_9, var_10, var_11, adj_9, adj_10, adj_11, adj_12);
    // adj: local_0 = wp.quat_rotate(q_off, wp.vec3(1.0, 0.0, 0.0))                           <L 103>
    adj_quat_decompose_0(var_7, adj_7, adj_8);
    // adj: angles = quat_decompose(q_pc)                                                     <L 100>
    wp::adj_mul(var_6, var_2, adj_6, adj_2, adj_7);
    wp::adj_mul(var_5, var_q_c, adj_5, adj_q_c, adj_6);
    wp::adj_mul(var_3, var_4, adj_3, adj_4, adj_5);
    wp::adj_quat_inverse(var_q_p, adj_q_p, adj_4);
    wp::adj_quat_inverse(var_2, adj_2, adj_3);
    // adj: q_pc = wp.quat_inverse(q_off) * wp.quat_inverse(q_p) * q_c * q_off                <L 97>
    wp::adj_quat_from_matrix(var_1, adj_1, adj_2);
    wp::adj_matrix_from_cols(var_axis_0, var_axis_1, var_0, adj_axis_0, adj_axis_1, adj_0, adj_1);
    wp::adj_cross(var_axis_0, var_axis_1, adj_axis_0, adj_axis_1, adj_0);
    // adj: q_off = wp.quat_from_matrix(wp.matrix_from_cols(axis_0, axis_1, wp.cross(axis_0, axis_1)))  <L 96>
    // adj: def invert_2d_rotational_dofs(                                                    <L 86>
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/sim/articulation.py:181
static CUDA_CALLABLE void adj_invert_3d_rotational_dofs_0(
    wp::vec_t<3, wp::float32> var_axis_0,
    wp::vec_t<3, wp::float32> var_axis_1,
    wp::vec_t<3, wp::float32> var_axis_2,
    wp::quat_t<wp::float32> var_q_p,
    wp::quat_t<wp::float32> var_q_c,
    wp::vec_t<3, wp::float32> var_w_err,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & adj_axis_0,
    wp::vec_t<3, wp::float32> & adj_axis_1,
    wp::vec_t<3, wp::float32> & adj_axis_2,
    wp::quat_t<wp::float32> & adj_q_p,
    wp::quat_t<wp::float32> & adj_q_c,
    wp::vec_t<3, wp::float32> & adj_w_err,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    const wp::float32 var_1 = 1.0;
    wp::float32 var_2;
    wp::float32 var_3;
    const wp::float32 var_4 = 0.0;
    bool var_5;
    const wp::float32 var_6 = -1.0;
    wp::float32 var_7;
    wp::float32 var_8;
    wp::mat_t<3, 3, wp::float32> var_9;
    wp::quat_t<wp::float32> var_10;
    wp::quat_t<wp::float32> var_11;
    wp::quat_t<wp::float32> var_12;
    wp::quat_t<wp::float32> var_13;
    wp::quat_t<wp::float32> var_14;
    wp::quat_t<wp::float32> var_15;
    wp::vec_t<3, wp::float32> var_16;
    const wp::float32 var_17 = 1.0;
    const wp::float32 var_18 = 0.0;
    const wp::float32 var_19 = 0.0;
    wp::vec_t<3, wp::float32> var_20;
    wp::vec_t<3, wp::float32> var_21;
    const wp::float32 var_22 = 0.0;
    const wp::float32 var_23 = 1.0;
    const wp::float32 var_24 = 0.0;
    wp::vec_t<3, wp::float32> var_25;
    wp::vec_t<3, wp::float32> var_26;
    const wp::float32 var_27 = 0.0;
    const wp::float32 var_28 = 0.0;
    const wp::float32 var_29 = 1.0;
    wp::vec_t<3, wp::float32> var_30;
    wp::vec_t<3, wp::float32> var_31;
    wp::vec_t<3, wp::float32> var_32;
    const wp::int32 var_33 = 0;
    wp::float32 var_34;
    wp::quat_t<wp::float32> var_35;
    wp::vec_t<3, wp::float32> var_36;
    const wp::int32 var_37 = 1;
    wp::float32 var_38;
    wp::quat_t<wp::float32> var_39;
    wp::quat_t<wp::float32> var_40;
    wp::vec_t<3, wp::float32> var_41;
    wp::vec_t<3, wp::float32> var_42;
    wp::vec_t<3, wp::float32> var_43;
    wp::vec_t<3, wp::float32> var_44;
    wp::vec_t<3, wp::float32> var_45;
    wp::float32 var_46;
    wp::float32 var_47;
    wp::float32 var_48;
    wp::float32 var_49;
    wp::float32 var_50;
    wp::float32 var_51;
    wp::float32 var_52;
    wp::float32 var_53;
    wp::float32 var_54;
    wp::vec_t<3, wp::float32> var_55;
    const wp::int32 var_56 = 0;
    wp::float32 var_57;
    const wp::int32 var_58 = 1;
    wp::float32 var_59;
    const wp::int32 var_60 = 2;
    wp::float32 var_61;
    wp::float32 var_62;
    wp::vec_t<3, wp::float32> var_63;
    const wp::int32 var_64 = 0;
    wp::float32 var_65;
    const wp::int32 var_66 = 1;
    wp::float32 var_67;
    const wp::int32 var_68 = 2;
    wp::float32 var_69;
    wp::float32 var_70;
    wp::vec_t<3, wp::float32> var_71;
    //---------
    // dual vars
    wp::vec_t<3, wp::float32> adj_0 = {};
    wp::float32 adj_1 = {};
    wp::float32 adj_2 = {};
    wp::float32 adj_3 = {};
    wp::float32 adj_4 = {};
    bool adj_5 = {};
    wp::float32 adj_6 = {};
    wp::float32 adj_7 = {};
    wp::float32 adj_8 = {};
    wp::mat_t<3, 3, wp::float32> adj_9 = {};
    wp::quat_t<wp::float32> adj_10 = {};
    wp::quat_t<wp::float32> adj_11 = {};
    wp::quat_t<wp::float32> adj_12 = {};
    wp::quat_t<wp::float32> adj_13 = {};
    wp::quat_t<wp::float32> adj_14 = {};
    wp::quat_t<wp::float32> adj_15 = {};
    wp::vec_t<3, wp::float32> adj_16 = {};
    wp::float32 adj_17 = {};
    wp::float32 adj_18 = {};
    wp::float32 adj_19 = {};
    wp::vec_t<3, wp::float32> adj_20 = {};
    wp::vec_t<3, wp::float32> adj_21 = {};
    wp::float32 adj_22 = {};
    wp::float32 adj_23 = {};
    wp::float32 adj_24 = {};
    wp::vec_t<3, wp::float32> adj_25 = {};
    wp::vec_t<3, wp::float32> adj_26 = {};
    wp::float32 adj_27 = {};
    wp::float32 adj_28 = {};
    wp::float32 adj_29 = {};
    wp::vec_t<3, wp::float32> adj_30 = {};
    wp::vec_t<3, wp::float32> adj_31 = {};
    wp::vec_t<3, wp::float32> adj_32 = {};
    wp::int32 adj_33 = {};
    wp::float32 adj_34 = {};
    wp::quat_t<wp::float32> adj_35 = {};
    wp::vec_t<3, wp::float32> adj_36 = {};
    wp::int32 adj_37 = {};
    wp::float32 adj_38 = {};
    wp::quat_t<wp::float32> adj_39 = {};
    wp::quat_t<wp::float32> adj_40 = {};
    wp::vec_t<3, wp::float32> adj_41 = {};
    wp::vec_t<3, wp::float32> adj_42 = {};
    wp::vec_t<3, wp::float32> adj_43 = {};
    wp::vec_t<3, wp::float32> adj_44 = {};
    wp::vec_t<3, wp::float32> adj_45 = {};
    wp::float32 adj_46 = {};
    wp::float32 adj_47 = {};
    wp::float32 adj_48 = {};
    wp::float32 adj_49 = {};
    wp::float32 adj_50 = {};
    wp::float32 adj_51 = {};
    wp::float32 adj_52 = {};
    wp::float32 adj_53 = {};
    wp::float32 adj_54 = {};
    wp::vec_t<3, wp::float32> adj_55 = {};
    wp::int32 adj_56 = {};
    wp::float32 adj_57 = {};
    wp::int32 adj_58 = {};
    wp::float32 adj_59 = {};
    wp::int32 adj_60 = {};
    wp::float32 adj_61 = {};
    wp::float32 adj_62 = {};
    wp::vec_t<3, wp::float32> adj_63 = {};
    wp::int32 adj_64 = {};
    wp::float32 adj_65 = {};
    wp::int32 adj_66 = {};
    wp::float32 adj_67 = {};
    wp::int32 adj_68 = {};
    wp::float32 adj_69 = {};
    wp::float32 adj_70 = {};
    wp::vec_t<3, wp::float32> adj_71 = {};
    //---------
    // forward
    // def invert_3d_rotational_dofs(                                                         <L 182>
    // axis_2_rh = wp.cross(axis_0, axis_1)                                                   <L 193>
    var_0 = wp::cross(var_axis_0, var_axis_1);
    // s = float(1.0)                                                                         <L 194>
    var_2 = wp::float(var_1);
    // if wp.dot(axis_2_rh, axis_2) < 0.0:                                                    <L 195>
    var_3 = wp::dot(var_0, var_axis_2);
    var_5 = (var_3 < var_4);
    if (var_5) {
        // s = float(-1.0)                                                                    <L 196>
        var_7 = wp::float(var_6);
    }
    var_8 = wp::where(var_5, var_7, var_2);
    // q_off = wp.quat_from_matrix(wp.matrix_from_cols(axis_0, axis_1, axis_2_rh))            <L 198>
    var_9 = wp::matrix_from_cols<wp::float32>(var_axis_0, var_axis_1, var_0);
    var_10 = wp::quat_from_matrix(var_9);
    // q_pc = wp.quat_inverse(q_off) * wp.quat_inverse(q_p) * q_c * q_off                     <L 199>
    var_11 = wp::quat_inverse(var_10);
    var_12 = wp::quat_inverse(var_q_p);
    var_13 = wp::mul(var_11, var_12);
    var_14 = wp::mul(var_13, var_q_c);
    var_15 = wp::mul(var_14, var_10);
    // angles = quat_decompose(q_pc)                                                          <L 202>
    var_16 = quat_decompose_0(var_15);
    // local_0 = wp.quat_rotate(q_off, wp.vec3(1.0, 0.0, 0.0))                                <L 205>
    var_20 = wp::vec_t<3, wp::float32>(var_17, var_18, var_19);
    var_21 = wp::quat_rotate(var_10, var_20);
    // local_1 = wp.quat_rotate(q_off, wp.vec3(0.0, 1.0, 0.0))                                <L 206>
    var_25 = wp::vec_t<3, wp::float32>(var_22, var_23, var_24);
    var_26 = wp::quat_rotate(var_10, var_25);
    // local_2 = wp.quat_rotate(q_off, wp.vec3(0.0, 0.0, 1.0))                                <L 207>
    var_30 = wp::vec_t<3, wp::float32>(var_27, var_28, var_29);
    var_31 = wp::quat_rotate(var_10, var_30);
    // a0 = local_0                                                                           <L 209>
    var_32 = wp::copy(var_21);
    // q_0 = wp.quat_from_axis_angle(a0, angles[0])                                           <L 210>
    var_34 = wp::extract(var_16, var_33);
    var_35 = wp::quat_from_axis_angle(var_32, var_34);
    // a1 = wp.quat_rotate(q_0, local_1)                                                      <L 212>
    var_36 = wp::quat_rotate(var_35, var_26);
    // q_1 = wp.quat_from_axis_angle(a1, angles[1])                                           <L 213>
    var_38 = wp::extract(var_16, var_37);
    var_39 = wp::quat_from_axis_angle(var_36, var_38);
    // a2 = wp.quat_rotate(q_1 * q_0, local_2)                                                <L 215>
    var_40 = wp::mul(var_39, var_35);
    var_41 = wp::quat_rotate(var_40, var_31);
    // w_err_p = wp.quat_rotate_inv(q_p, w_err)                                               <L 218>
    var_42 = wp::quat_rotate_inv(var_q_p, var_w_err);
    // c12 = wp.cross(a1, a2)                                                                 <L 221>
    var_43 = wp::cross(var_36, var_41);
    // c02 = wp.cross(a0, a2)                                                                 <L 222>
    var_44 = wp::cross(var_32, var_41);
    // c01 = wp.cross(a0, a1)                                                                 <L 223>
    var_45 = wp::cross(var_32, var_36);
    // velocities = wp.vec3(                                                                  <L 225>
    // wp.dot(w_err_p, c12) / wp.dot(a0, c12),                                                <L 226>
    var_46 = wp::dot(var_42, var_43);
    var_47 = wp::dot(var_32, var_43);
    var_48 = wp::div(var_46, var_47);
    // wp.dot(w_err_p, c02) / wp.dot(a1, c02),                                                <L 227>
    var_49 = wp::dot(var_42, var_44);
    var_50 = wp::dot(var_36, var_44);
    var_51 = wp::div(var_49, var_50);
    // wp.dot(w_err_p, c01) / wp.dot(a2, c01),                                                <L 228>
    var_52 = wp::dot(var_42, var_45);
    var_53 = wp::dot(var_41, var_45);
    var_54 = wp::div(var_52, var_53);
    var_55 = wp::vec_t<3, wp::float32>(var_48, var_51, var_54);
    // return wp.vec3(angles[0], angles[1], s * angles[2]), wp.vec3(velocities[0], velocities[1], s * velocities[2])       <L 233>
    var_57 = wp::extract(var_16, var_56);
    var_59 = wp::extract(var_16, var_58);
    var_61 = wp::extract(var_16, var_60);
    var_62 = wp::mul(var_8, var_61);
    var_63 = wp::vec_t<3, wp::float32>(var_57, var_59, var_62);
    var_65 = wp::extract(var_55, var_64);
    var_67 = wp::extract(var_55, var_66);
    var_69 = wp::extract(var_55, var_68);
    var_70 = wp::mul(var_8, var_69);
    var_71 = wp::vec_t<3, wp::float32>(var_65, var_67, var_70);
    ret_0 = var_63;
    ret_1 = var_71;
    goto label0;
    //---------
    // reverse
    label0:;
    adj_71 += adj_ret_1;
    adj_63 += adj_ret_0;
    wp::adj_vec_t(var_65, var_67, var_70, adj_65, adj_67, adj_70, adj_71);
    wp::adj_mul(var_8, var_69, adj_8, adj_69, adj_70);
    wp::adj_extract(var_55, var_68, adj_55, adj_68, adj_69);
    wp::adj_extract(var_55, var_66, adj_55, adj_66, adj_67);
    wp::adj_extract(var_55, var_64, adj_55, adj_64, adj_65);
    wp::adj_vec_t(var_57, var_59, var_62, adj_57, adj_59, adj_62, adj_63);
    wp::adj_mul(var_8, var_61, adj_8, adj_61, adj_62);
    wp::adj_extract(var_16, var_60, adj_16, adj_60, adj_61);
    wp::adj_extract(var_16, var_58, adj_16, adj_58, adj_59);
    wp::adj_extract(var_16, var_56, adj_16, adj_56, adj_57);
    // adj: return wp.vec3(angles[0], angles[1], s * angles[2]), wp.vec3(velocities[0], velocities[1], s * velocities[2])  <L 233>
    wp::adj_vec_t(var_48, var_51, var_54, adj_48, adj_51, adj_54, adj_55);
    wp::adj_div(var_52, var_53, var_54, adj_52, adj_53, adj_54);
    wp::adj_dot(var_41, var_45, adj_41, adj_45, adj_53);
    wp::adj_dot(var_42, var_45, adj_42, adj_45, adj_52);
    // adj: wp.dot(w_err_p, c01) / wp.dot(a2, c01),                                           <L 228>
    wp::adj_div(var_49, var_50, var_51, adj_49, adj_50, adj_51);
    wp::adj_dot(var_36, var_44, adj_36, adj_44, adj_50);
    wp::adj_dot(var_42, var_44, adj_42, adj_44, adj_49);
    // adj: wp.dot(w_err_p, c02) / wp.dot(a1, c02),                                           <L 227>
    wp::adj_div(var_46, var_47, var_48, adj_46, adj_47, adj_48);
    wp::adj_dot(var_32, var_43, adj_32, adj_43, adj_47);
    wp::adj_dot(var_42, var_43, adj_42, adj_43, adj_46);
    // adj: wp.dot(w_err_p, c12) / wp.dot(a0, c12),                                           <L 226>
    // adj: velocities = wp.vec3(                                                             <L 225>
    wp::adj_cross(var_32, var_36, adj_32, adj_36, adj_45);
    // adj: c01 = wp.cross(a0, a1)                                                            <L 223>
    wp::adj_cross(var_32, var_41, adj_32, adj_41, adj_44);
    // adj: c02 = wp.cross(a0, a2)                                                            <L 222>
    wp::adj_cross(var_36, var_41, adj_36, adj_41, adj_43);
    // adj: c12 = wp.cross(a1, a2)                                                            <L 221>
    wp::adj_quat_rotate_inv(var_q_p, var_w_err, adj_q_p, adj_w_err, adj_42);
    // adj: w_err_p = wp.quat_rotate_inv(q_p, w_err)                                          <L 218>
    wp::adj_quat_rotate(var_40, var_31, adj_40, adj_31, adj_41);
    wp::adj_mul(var_39, var_35, adj_39, adj_35, adj_40);
    // adj: a2 = wp.quat_rotate(q_1 * q_0, local_2)                                           <L 215>
    wp::adj_quat_from_axis_angle(var_36, var_38, adj_36, adj_38, adj_39);
    wp::adj_extract(var_16, var_37, adj_16, adj_37, adj_38);
    // adj: q_1 = wp.quat_from_axis_angle(a1, angles[1])                                      <L 213>
    wp::adj_quat_rotate(var_35, var_26, adj_35, adj_26, adj_36);
    // adj: a1 = wp.quat_rotate(q_0, local_1)                                                 <L 212>
    wp::adj_quat_from_axis_angle(var_32, var_34, adj_32, adj_34, adj_35);
    wp::adj_extract(var_16, var_33, adj_16, adj_33, adj_34);
    // adj: q_0 = wp.quat_from_axis_angle(a0, angles[0])                                      <L 210>
    wp::adj_copy(var_21, adj_21, adj_32);
    // adj: a0 = local_0                                                                      <L 209>
    wp::adj_quat_rotate(var_10, var_30, adj_10, adj_30, adj_31);
    wp::adj_vec_t(var_27, var_28, var_29, adj_27, adj_28, adj_29, adj_30);
    // adj: local_2 = wp.quat_rotate(q_off, wp.vec3(0.0, 0.0, 1.0))                           <L 207>
    wp::adj_quat_rotate(var_10, var_25, adj_10, adj_25, adj_26);
    wp::adj_vec_t(var_22, var_23, var_24, adj_22, adj_23, adj_24, adj_25);
    // adj: local_1 = wp.quat_rotate(q_off, wp.vec3(0.0, 1.0, 0.0))                           <L 206>
    wp::adj_quat_rotate(var_10, var_20, adj_10, adj_20, adj_21);
    wp::adj_vec_t(var_17, var_18, var_19, adj_17, adj_18, adj_19, adj_20);
    // adj: local_0 = wp.quat_rotate(q_off, wp.vec3(1.0, 0.0, 0.0))                           <L 205>
    adj_quat_decompose_0(var_15, adj_15, adj_16);
    // adj: angles = quat_decompose(q_pc)                                                     <L 202>
    wp::adj_mul(var_14, var_10, adj_14, adj_10, adj_15);
    wp::adj_mul(var_13, var_q_c, adj_13, adj_q_c, adj_14);
    wp::adj_mul(var_11, var_12, adj_11, adj_12, adj_13);
    wp::adj_quat_inverse(var_q_p, adj_q_p, adj_12);
    wp::adj_quat_inverse(var_10, adj_10, adj_11);
    // adj: q_pc = wp.quat_inverse(q_off) * wp.quat_inverse(q_p) * q_c * q_off                <L 199>
    wp::adj_quat_from_matrix(var_9, adj_9, adj_10);
    wp::adj_matrix_from_cols(var_axis_0, var_axis_1, var_0, adj_axis_0, adj_axis_1, adj_0, adj_9);
    // adj: q_off = wp.quat_from_matrix(wp.matrix_from_cols(axis_0, axis_1, axis_2_rh))       <L 198>
    wp::adj_where(var_5, var_7, var_2, adj_5, adj_7, adj_2, adj_8);
    if (var_5) {
        wp::adj_float(var_6, adj_6, adj_7);
        // adj: s = float(-1.0)                                                               <L 196>
    }
    wp::adj_dot(var_0, var_axis_2, adj_0, adj_axis_2, adj_3);
    // adj: if wp.dot(axis_2_rh, axis_2) < 0.0:                                               <L 195>
    wp::adj_float(var_1, adj_1, adj_2);
    // adj: s = float(1.0)                                                                    <L 194>
    wp::adj_cross(var_axis_0, var_axis_1, adj_axis_0, adj_axis_1, adj_0);
    // adj: axis_2_rh = wp.cross(axis_0, axis_1)                                              <L 193>
    // adj: def invert_3d_rotational_dofs(                                                    <L 182>
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/warp/_src/math.py:452
static CUDA_CALLABLE void adj_transform_twist_0(
    wp::transform_t<wp::float32> var_t,
    wp::vec_t<6, wp::float32> var_x,
    wp::transform_t<wp::float32> & adj_t,
    wp::vec_t<6, wp::float32> & adj_x,
    wp::vec_t<6, wp::float32> & adj_ret)
{
    //---------
    // primal vars
    wp::quat_t<wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    wp::vec_t<3, wp::float32> var_4;
    wp::vec_t<3, wp::float32> var_5;
    wp::vec_t<3, wp::float32> var_6;
    wp::vec_t<3, wp::float32> var_7;
    wp::vec_t<6, wp::float32> var_8;
    //---------
    // dual vars
    wp::quat_t<wp::float32> adj_0 = {};
    wp::vec_t<3, wp::float32> adj_1 = {};
    wp::vec_t<3, wp::float32> adj_2 = {};
    wp::vec_t<3, wp::float32> adj_3 = {};
    wp::vec_t<3, wp::float32> adj_4 = {};
    wp::vec_t<3, wp::float32> adj_5 = {};
    wp::vec_t<3, wp::float32> adj_6 = {};
    wp::vec_t<3, wp::float32> adj_7 = {};
    wp::vec_t<6, wp::float32> adj_8 = {};
    //---------
    // forward
    // def transform_twist(t: wp.transform, x: wp.spatial_vector) -> wp.spatial_vector:       <L 453>
    // q = wp.transform_get_rotation(t)                                                       <L 469>
    var_0 = wp::transform_get_rotation(var_t);
    // p = wp.transform_get_translation(t)                                                    <L 470>
    var_1 = wp::transform_get_translation(var_t);
    // w = wp.spatial_top(x)                                                                  <L 472>
    var_2 = wp::spatial_top(var_x);
    // v = wp.spatial_bottom(x)                                                               <L 473>
    var_3 = wp::spatial_bottom(var_x);
    // w = wp.quat_rotate(q, w)                                                               <L 475>
    var_4 = wp::quat_rotate(var_0, var_2);
    // v = wp.quat_rotate(q, v) + wp.cross(p, w)                                              <L 476>
    var_5 = wp::quat_rotate(var_0, var_3);
    var_6 = wp::cross(var_1, var_4);
    var_7 = wp::add(var_5, var_6);
    // return wp.spatial_vector(w, v)                                                         <L 478>
    var_8 = wp::vec_t<6, wp::float32>(var_4, var_7);
    goto label0;
    //---------
    // reverse
    label0:;
    adj_8 += adj_ret;
    wp::adj_vec_t(var_4, var_7, adj_4, adj_7, adj_8);
    // adj: return wp.spatial_vector(w, v)                                                    <L 478>
    wp::adj_add(var_5, var_6, adj_5, adj_6, adj_7);
    wp::adj_cross(var_1, var_4, adj_1, adj_4, adj_6);
    wp::adj_quat_rotate(var_0, var_3, adj_0, adj_3, adj_5);
    // adj: v = wp.quat_rotate(q, v) + wp.cross(p, w)                                         <L 476>
    wp::adj_quat_rotate(var_0, var_2, adj_0, adj_2, adj_4);
    // adj: w = wp.quat_rotate(q, w)                                                          <L 475>
    wp::adj_spatial_bottom(var_x, adj_x, adj_3);
    // adj: v = wp.spatial_bottom(x)                                                          <L 473>
    wp::adj_spatial_top(var_x, adj_x, adj_2);
    // adj: w = wp.spatial_top(x)                                                             <L 472>
    wp::adj_transform_get_translation(var_t, adj_t, adj_1);
    // adj: p = wp.transform_get_translation(t)                                               <L 470>
    wp::adj_transform_get_rotation(var_t, adj_t, adj_0);
    // adj: q = wp.transform_get_rotation(t)                                                  <L 469>
    // adj: def transform_twist(t: wp.transform, x: wp.spatial_vector) -> wp.spatial_vector:  <L 453>
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/math/spatial.py:81
static CUDA_CALLABLE void adj_transform_twist_1(
    wp::transform_t<wp::float32> var_t,
    wp::vec_t<6, wp::float32> var_x,
    wp::transform_t<wp::float32> & adj_t,
    wp::vec_t<6, wp::float32> & adj_x,
    wp::vec_t<6, wp::float32> & adj_ret)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<6, wp::float32> var_2;
    wp::vec_t<6, wp::float32> var_3;
    wp::vec_t<3, wp::float32> var_4;
    wp::vec_t<3, wp::float32> var_5;
    wp::vec_t<6, wp::float32> var_6;
    //---------
    // dual vars
    wp::vec_t<3, wp::float32> adj_0 = {};
    wp::vec_t<3, wp::float32> adj_1 = {};
    wp::vec_t<6, wp::float32> adj_2 = {};
    wp::vec_t<6, wp::float32> adj_3 = {};
    wp::vec_t<3, wp::float32> adj_4 = {};
    wp::vec_t<3, wp::float32> adj_5 = {};
    wp::vec_t<6, wp::float32> adj_6 = {};
    //---------
    // forward
    // def transform_twist(t: wp.transform, x: wp.spatial_vector) -> wp.spatial_vector:       <L 82>
    // x_wp = wp.spatial_vector(wp.spatial_bottom(x), wp.spatial_top(x))                      <L 102>
    var_0 = wp::spatial_bottom(var_x);
    var_1 = wp::spatial_top(var_x);
    var_2 = wp::vec_t<6, wp::float32>(var_0, var_1);
    // y_wp = wp.transform_twist(t, x_wp)                                                     <L 103>
    var_3 = transform_twist_0(var_t, var_2);
    // return wp.spatial_vector(wp.spatial_bottom(y_wp), wp.spatial_top(y_wp))                <L 104>
    var_4 = wp::spatial_bottom(var_3);
    var_5 = wp::spatial_top(var_3);
    var_6 = wp::vec_t<6, wp::float32>(var_4, var_5);
    goto label0;
    //---------
    // reverse
    label0:;
    adj_6 += adj_ret;
    wp::adj_vec_t(var_4, var_5, adj_4, adj_5, adj_6);
    wp::adj_spatial_top(var_3, adj_3, adj_5);
    wp::adj_spatial_bottom(var_3, adj_3, adj_4);
    // adj: return wp.spatial_vector(wp.spatial_bottom(y_wp), wp.spatial_top(y_wp))           <L 104>
    adj_transform_twist_0(var_t, var_2, adj_t, adj_2, adj_3);
    // adj: y_wp = wp.transform_twist(t, x_wp)                                                <L 103>
    wp::adj_vec_t(var_0, var_1, adj_0, adj_1, adj_2);
    wp::adj_spatial_top(var_x, adj_x, adj_1);
    wp::adj_spatial_bottom(var_x, adj_x, adj_0);
    // adj: x_wp = wp.spatial_vector(wp.spatial_bottom(x), wp.spatial_top(x))                 <L 102>
    // adj: def transform_twist(t: wp.transform, x: wp.spatial_vector) -> wp.spatial_vector:  <L 82>
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/sim/articulation.py:934
static CUDA_CALLABLE void adj_write_free_distance_motion_subspace_0(
    wp::transform_t<wp::float32> var_X_pa_world,
    wp::vec_t<3, wp::float32> var_x_child_com_world,
    wp::int32 var_qd_start,
    wp::array_t<wp::vec_t<6, wp::float32>> var_joint_S_s,
    wp::transform_t<wp::float32> & adj_X_pa_world,
    wp::vec_t<3, wp::float32> & adj_x_child_com_world,
    wp::int32 & adj_qd_start,
    wp::array_t<wp::vec_t<6, wp::float32>> & adj_joint_S_s)
{
    //---------
    // primal vars
    const wp::float32 var_0 = 1.0;
    const wp::float32 var_1 = 0.0;
    const wp::float32 var_2 = 0.0;
    wp::vec_t<3, wp::float32> var_3;
    wp::vec_t<3, wp::float32> var_4;
    const wp::float32 var_5 = 0.0;
    const wp::float32 var_6 = 1.0;
    const wp::float32 var_7 = 0.0;
    wp::vec_t<3, wp::float32> var_8;
    wp::vec_t<3, wp::float32> var_9;
    const wp::float32 var_10 = 0.0;
    const wp::float32 var_11 = 0.0;
    const wp::float32 var_12 = 1.0;
    wp::vec_t<3, wp::float32> var_13;
    wp::vec_t<3, wp::float32> var_14;
    wp::vec_t<3, wp::float32> var_15;
    wp::vec_t<6, wp::float32> var_16;
    const wp::int32 var_17 = 0;
    wp::int32 var_18;
    wp::vec_t<3, wp::float32> var_19;
    wp::vec_t<6, wp::float32> var_20;
    const wp::int32 var_21 = 1;
    wp::int32 var_22;
    wp::vec_t<3, wp::float32> var_23;
    wp::vec_t<6, wp::float32> var_24;
    const wp::int32 var_25 = 2;
    wp::int32 var_26;
    wp::vec_t<3, wp::float32> var_27;
    wp::vec_t<3, wp::float32> var_28;
    wp::vec_t<6, wp::float32> var_29;
    const wp::int32 var_30 = 3;
    wp::int32 var_31;
    wp::vec_t<3, wp::float32> var_32;
    wp::vec_t<3, wp::float32> var_33;
    wp::vec_t<6, wp::float32> var_34;
    const wp::int32 var_35 = 4;
    wp::int32 var_36;
    wp::vec_t<3, wp::float32> var_37;
    wp::vec_t<3, wp::float32> var_38;
    wp::vec_t<6, wp::float32> var_39;
    const wp::int32 var_40 = 5;
    wp::int32 var_41;
    //---------
    // dual vars
    wp::float32 adj_0 = {};
    wp::float32 adj_1 = {};
    wp::float32 adj_2 = {};
    wp::vec_t<3, wp::float32> adj_3 = {};
    wp::vec_t<3, wp::float32> adj_4 = {};
    wp::float32 adj_5 = {};
    wp::float32 adj_6 = {};
    wp::float32 adj_7 = {};
    wp::vec_t<3, wp::float32> adj_8 = {};
    wp::vec_t<3, wp::float32> adj_9 = {};
    wp::float32 adj_10 = {};
    wp::float32 adj_11 = {};
    wp::float32 adj_12 = {};
    wp::vec_t<3, wp::float32> adj_13 = {};
    wp::vec_t<3, wp::float32> adj_14 = {};
    wp::vec_t<3, wp::float32> adj_15 = {};
    wp::vec_t<6, wp::float32> adj_16 = {};
    wp::int32 adj_17 = {};
    wp::int32 adj_18 = {};
    wp::vec_t<3, wp::float32> adj_19 = {};
    wp::vec_t<6, wp::float32> adj_20 = {};
    wp::int32 adj_21 = {};
    wp::int32 adj_22 = {};
    wp::vec_t<3, wp::float32> adj_23 = {};
    wp::vec_t<6, wp::float32> adj_24 = {};
    wp::int32 adj_25 = {};
    wp::int32 adj_26 = {};
    wp::vec_t<3, wp::float32> adj_27 = {};
    wp::vec_t<3, wp::float32> adj_28 = {};
    wp::vec_t<6, wp::float32> adj_29 = {};
    wp::int32 adj_30 = {};
    wp::int32 adj_31 = {};
    wp::vec_t<3, wp::float32> adj_32 = {};
    wp::vec_t<3, wp::float32> adj_33 = {};
    wp::vec_t<6, wp::float32> adj_34 = {};
    wp::int32 adj_35 = {};
    wp::int32 adj_36 = {};
    wp::vec_t<3, wp::float32> adj_37 = {};
    wp::vec_t<3, wp::float32> adj_38 = {};
    wp::vec_t<6, wp::float32> adj_39 = {};
    wp::int32 adj_40 = {};
    wp::int32 adj_41 = {};
    //---------
    // forward
    // def write_free_distance_motion_subspace(                                               <L 935>
    // axis_world_x = wp.transform_vector(X_pa_world, wp.vec3(1.0, 0.0, 0.0))                 <L 960>
    var_3 = wp::vec_t<3, wp::float32>(var_0, var_1, var_2);
    var_4 = wp::transform_vector(var_X_pa_world, var_3);
    // axis_world_y = wp.transform_vector(X_pa_world, wp.vec3(0.0, 1.0, 0.0))                 <L 961>
    var_8 = wp::vec_t<3, wp::float32>(var_5, var_6, var_7);
    var_9 = wp::transform_vector(var_X_pa_world, var_8);
    // axis_world_z = wp.transform_vector(X_pa_world, wp.vec3(0.0, 0.0, 1.0))                 <L 962>
    var_13 = wp::vec_t<3, wp::float32>(var_10, var_11, var_12);
    var_14 = wp::transform_vector(var_X_pa_world, var_13);
    // joint_S_s[qd_start + 0] = wp.spatial_vector(axis_world_x, wp.vec3())                   <L 964>
    var_15 = wp::vec_t<3, wp::float32>();
    var_16 = wp::vec_t<6, wp::float32>(var_4, var_15);
    var_18 = wp::add(var_qd_start, var_17);
    // wp::array_store(var_joint_S_s, var_18, var_16);
    // joint_S_s[qd_start + 1] = wp.spatial_vector(axis_world_y, wp.vec3())                   <L 965>
    var_19 = wp::vec_t<3, wp::float32>();
    var_20 = wp::vec_t<6, wp::float32>(var_9, var_19);
    var_22 = wp::add(var_qd_start, var_21);
    // wp::array_store(var_joint_S_s, var_22, var_20);
    // joint_S_s[qd_start + 2] = wp.spatial_vector(axis_world_z, wp.vec3())                   <L 966>
    var_23 = wp::vec_t<3, wp::float32>();
    var_24 = wp::vec_t<6, wp::float32>(var_14, var_23);
    var_26 = wp::add(var_qd_start, var_25);
    // wp::array_store(var_joint_S_s, var_26, var_24);
    // joint_S_s[qd_start + 3] = wp.spatial_vector(-wp.cross(axis_world_x, x_child_com_world), axis_world_x)       <L 967>
    var_27 = wp::cross(var_4, var_x_child_com_world);
    var_28 = wp::neg(var_27);
    var_29 = wp::vec_t<6, wp::float32>(var_28, var_4);
    var_31 = wp::add(var_qd_start, var_30);
    // wp::array_store(var_joint_S_s, var_31, var_29);
    // joint_S_s[qd_start + 4] = wp.spatial_vector(-wp.cross(axis_world_y, x_child_com_world), axis_world_y)       <L 968>
    var_32 = wp::cross(var_9, var_x_child_com_world);
    var_33 = wp::neg(var_32);
    var_34 = wp::vec_t<6, wp::float32>(var_33, var_9);
    var_36 = wp::add(var_qd_start, var_35);
    // wp::array_store(var_joint_S_s, var_36, var_34);
    // joint_S_s[qd_start + 5] = wp.spatial_vector(-wp.cross(axis_world_z, x_child_com_world), axis_world_z)       <L 969>
    var_37 = wp::cross(var_14, var_x_child_com_world);
    var_38 = wp::neg(var_37);
    var_39 = wp::vec_t<6, wp::float32>(var_38, var_14);
    var_41 = wp::add(var_qd_start, var_40);
    // wp::array_store(var_joint_S_s, var_41, var_39);
    //---------
    // reverse
    wp::adj_array_store(var_joint_S_s, var_41, var_39, adj_joint_S_s, adj_41, adj_39);
    wp::adj_add(var_qd_start, var_40, adj_qd_start, adj_40, adj_41);
    wp::adj_vec_t(var_38, var_14, adj_38, adj_14, adj_39);
    wp::adj_neg(var_37, adj_37, adj_38);
    wp::adj_cross(var_14, var_x_child_com_world, adj_14, adj_x_child_com_world, adj_37);
    // adj: joint_S_s[qd_start + 5] = wp.spatial_vector(-wp.cross(axis_world_z, x_child_com_world), axis_world_z)  <L 969>
    wp::adj_array_store(var_joint_S_s, var_36, var_34, adj_joint_S_s, adj_36, adj_34);
    wp::adj_add(var_qd_start, var_35, adj_qd_start, adj_35, adj_36);
    wp::adj_vec_t(var_33, var_9, adj_33, adj_9, adj_34);
    wp::adj_neg(var_32, adj_32, adj_33);
    wp::adj_cross(var_9, var_x_child_com_world, adj_9, adj_x_child_com_world, adj_32);
    // adj: joint_S_s[qd_start + 4] = wp.spatial_vector(-wp.cross(axis_world_y, x_child_com_world), axis_world_y)  <L 968>
    wp::adj_array_store(var_joint_S_s, var_31, var_29, adj_joint_S_s, adj_31, adj_29);
    wp::adj_add(var_qd_start, var_30, adj_qd_start, adj_30, adj_31);
    wp::adj_vec_t(var_28, var_4, adj_28, adj_4, adj_29);
    wp::adj_neg(var_27, adj_27, adj_28);
    wp::adj_cross(var_4, var_x_child_com_world, adj_4, adj_x_child_com_world, adj_27);
    // adj: joint_S_s[qd_start + 3] = wp.spatial_vector(-wp.cross(axis_world_x, x_child_com_world), axis_world_x)  <L 967>
    wp::adj_array_store(var_joint_S_s, var_26, var_24, adj_joint_S_s, adj_26, adj_24);
    wp::adj_add(var_qd_start, var_25, adj_qd_start, adj_25, adj_26);
    wp::adj_vec_t(var_14, var_23, adj_14, adj_23, adj_24);
    // adj: joint_S_s[qd_start + 2] = wp.spatial_vector(axis_world_z, wp.vec3())              <L 966>
    wp::adj_array_store(var_joint_S_s, var_22, var_20, adj_joint_S_s, adj_22, adj_20);
    wp::adj_add(var_qd_start, var_21, adj_qd_start, adj_21, adj_22);
    wp::adj_vec_t(var_9, var_19, adj_9, adj_19, adj_20);
    // adj: joint_S_s[qd_start + 1] = wp.spatial_vector(axis_world_y, wp.vec3())              <L 965>
    wp::adj_array_store(var_joint_S_s, var_18, var_16, adj_joint_S_s, adj_18, adj_16);
    wp::adj_add(var_qd_start, var_17, adj_qd_start, adj_17, adj_18);
    wp::adj_vec_t(var_4, var_15, adj_4, adj_15, adj_16);
    // adj: joint_S_s[qd_start + 0] = wp.spatial_vector(axis_world_x, wp.vec3())              <L 964>
    wp::adj_transform_vector(var_X_pa_world, var_13, adj_X_pa_world, adj_13, adj_14);
    wp::adj_vec_t(var_10, var_11, var_12, adj_10, adj_11, adj_12, adj_13);
    // adj: axis_world_z = wp.transform_vector(X_pa_world, wp.vec3(0.0, 0.0, 1.0))            <L 962>
    wp::adj_transform_vector(var_X_pa_world, var_8, adj_X_pa_world, adj_8, adj_9);
    wp::adj_vec_t(var_5, var_6, var_7, adj_5, adj_6, adj_7, adj_8);
    // adj: axis_world_y = wp.transform_vector(X_pa_world, wp.vec3(0.0, 1.0, 0.0))            <L 961>
    wp::adj_transform_vector(var_X_pa_world, var_3, adj_X_pa_world, adj_3, adj_4);
    wp::adj_vec_t(var_0, var_1, var_2, adj_0, adj_1, adj_2, adj_3);
    // adj: axis_world_x = wp.transform_vector(X_pa_world, wp.vec3(1.0, 0.0, 0.0))            <L 960>
    // adj: def write_free_distance_motion_subspace(                                          <L 935>
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/sim/articulation.py:972
static CUDA_CALLABLE void adj_jcalc_motion_subspace_0(
    wp::int32 var_joint_type_value,
    wp::array_t<wp::vec_t<3, wp::float32>> var_joint_axis,
    wp::array_t<wp::float32> var_joint_q,
    wp::int32 var_lin_axis_count,
    wp::int32 var_ang_axis_count,
    wp::transform_t<wp::float32> var_X_pa_world,
    wp::transform_t<wp::float32> var_X_wc,
    wp::vec_t<3, wp::float32> var_body_com_child,
    wp::int32 var_q_start,
    wp::int32 var_qd_start,
    wp::array_t<wp::vec_t<6, wp::float32>> var_joint_S_s,
    wp::int32 & adj_joint_type_value,
    wp::array_t<wp::vec_t<3, wp::float32>> & adj_joint_axis,
    wp::array_t<wp::float32> & adj_joint_q,
    wp::int32 & adj_lin_axis_count,
    wp::int32 & adj_ang_axis_count,
    wp::transform_t<wp::float32> & adj_X_pa_world,
    wp::transform_t<wp::float32> & adj_X_wc,
    wp::vec_t<3, wp::float32> & adj_body_com_child,
    wp::int32 & adj_q_start,
    wp::int32 & adj_qd_start,
    wp::array_t<wp::vec_t<6, wp::float32>> & adj_joint_S_s)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    bool var_1;
    wp::vec_t<3, wp::float32>* var_2;
    wp::vec_t<3, wp::float32> var_3;
    wp::vec_t<3, wp::float32> var_4;
    wp::vec_t<3, wp::float32> var_5;
    wp::vec_t<6, wp::float32> var_6;
    wp::vec_t<6, wp::float32> var_7;
    const wp::int32 var_8 = 1;
    bool var_9;
    wp::vec_t<3, wp::float32>* var_10;
    wp::vec_t<3, wp::float32> var_11;
    wp::vec_t<3, wp::float32> var_12;
    wp::vec_t<3, wp::float32> var_13;
    wp::vec_t<6, wp::float32> var_14;
    wp::vec_t<6, wp::float32> var_15;
    const wp::int32 var_16 = 6;
    bool var_17;
    const wp::int32 var_18 = 0;
    bool var_19;
    const wp::int32 var_20 = 0;
    wp::int32 var_21;
    wp::vec_t<3, wp::float32>* var_22;
    wp::vec_t<3, wp::float32> var_23;
    wp::vec_t<3, wp::float32> var_24;
    wp::vec_t<3, wp::float32> var_25;
    wp::vec_t<6, wp::float32> var_26;
    wp::vec_t<6, wp::float32> var_27;
    const wp::int32 var_28 = 0;
    wp::int32 var_29;
    const wp::int32 var_30 = 1;
    bool var_31;
    const wp::int32 var_32 = 1;
    wp::int32 var_33;
    wp::vec_t<3, wp::float32>* var_34;
    wp::vec_t<3, wp::float32> var_35;
    wp::vec_t<3, wp::float32> var_36;
    wp::vec_t<3, wp::float32> var_37;
    wp::vec_t<6, wp::float32> var_38;
    wp::vec_t<6, wp::float32> var_39;
    const wp::int32 var_40 = 1;
    wp::int32 var_41;
    wp::vec_t<3, wp::float32> var_42;
    wp::vec_t<6, wp::float32> var_43;
    const wp::int32 var_44 = 2;
    bool var_45;
    const wp::int32 var_46 = 2;
    wp::int32 var_47;
    wp::vec_t<3, wp::float32>* var_48;
    wp::vec_t<3, wp::float32> var_49;
    wp::vec_t<3, wp::float32> var_50;
    wp::vec_t<3, wp::float32> var_51;
    wp::vec_t<6, wp::float32> var_52;
    wp::vec_t<6, wp::float32> var_53;
    const wp::int32 var_54 = 2;
    wp::int32 var_55;
    wp::vec_t<3, wp::float32> var_56;
    wp::vec_t<6, wp::float32> var_57;
    wp::int32 var_58;
    wp::int32 var_59;
    const wp::int32 var_60 = 1;
    bool var_61;
    wp::vec_t<3, wp::float32>* var_62;
    wp::vec_t<3, wp::float32> var_63;
    wp::vec_t<3, wp::float32> var_64;
    wp::vec_t<3, wp::float32> var_65;
    wp::vec_t<6, wp::float32> var_66;
    wp::vec_t<6, wp::float32> var_67;
    wp::vec_t<3, wp::float32> var_68;
    const wp::int32 var_69 = 2;
    bool var_70;
    const wp::int32 var_71 = 0;
    wp::int32 var_72;
    wp::vec_t<3, wp::float32>* var_73;
    const wp::int32 var_74 = 1;
    wp::int32 var_75;
    wp::vec_t<3, wp::float32>* var_76;
    const wp::int32 var_77 = 0;
    wp::int32 var_78;
    wp::float32* var_79;
    wp::vec_t<3, wp::float32> var_80;
    wp::vec_t<3, wp::float32> var_81;
    wp::vec_t<3, wp::float32> var_82;
    wp::vec_t<3, wp::float32> var_83;
    wp::float32 var_84;
    wp::vec_t<3, wp::float32> var_85;
    wp::vec_t<6, wp::float32> var_86;
    wp::vec_t<6, wp::float32> var_87;
    const wp::int32 var_88 = 0;
    wp::int32 var_89;
    wp::vec_t<3, wp::float32> var_90;
    wp::vec_t<6, wp::float32> var_91;
    wp::vec_t<6, wp::float32> var_92;
    const wp::int32 var_93 = 1;
    wp::int32 var_94;
    const wp::int32 var_95 = 3;
    bool var_96;
    const wp::int32 var_97 = 0;
    wp::int32 var_98;
    wp::vec_t<3, wp::float32>* var_99;
    const wp::int32 var_100 = 1;
    wp::int32 var_101;
    wp::vec_t<3, wp::float32>* var_102;
    const wp::int32 var_103 = 2;
    wp::int32 var_104;
    wp::vec_t<3, wp::float32>* var_105;
    const wp::int32 var_106 = 0;
    wp::int32 var_107;
    wp::float32* var_108;
    const wp::int32 var_109 = 1;
    wp::int32 var_110;
    wp::float32* var_111;
    wp::vec_t<3, wp::float32> var_112;
    wp::vec_t<3, wp::float32> var_113;
    wp::vec_t<3, wp::float32> var_114;
    wp::vec_t<3, wp::float32> var_115;
    wp::vec_t<3, wp::float32> var_116;
    wp::vec_t<3, wp::float32> var_117;
    wp::float32 var_118;
    wp::float32 var_119;
    wp::vec_t<3, wp::float32> var_120;
    wp::vec_t<6, wp::float32> var_121;
    wp::vec_t<6, wp::float32> var_122;
    const wp::int32 var_123 = 0;
    wp::int32 var_124;
    wp::vec_t<3, wp::float32> var_125;
    wp::vec_t<6, wp::float32> var_126;
    wp::vec_t<6, wp::float32> var_127;
    const wp::int32 var_128 = 1;
    wp::int32 var_129;
    wp::vec_t<3, wp::float32> var_130;
    wp::vec_t<6, wp::float32> var_131;
    wp::vec_t<6, wp::float32> var_132;
    const wp::int32 var_133 = 2;
    wp::int32 var_134;
    wp::vec_t<3, wp::float32> var_135;
    wp::vec_t<3, wp::float32> var_136;
    const wp::int32 var_137 = 2;
    bool var_138;
    const wp::float32 var_139 = 0.0;
    const wp::float32 var_140 = 0.0;
    const wp::float32 var_141 = 0.0;
    const wp::float32 var_142 = 1.0;
    const wp::float32 var_143 = 0.0;
    const wp::float32 var_144 = 0.0;
    wp::vec_t<6, wp::float32> var_145;
    wp::vec_t<6, wp::float32> var_146;
    const wp::float32 var_147 = 0.0;
    const wp::float32 var_148 = 0.0;
    const wp::float32 var_149 = 0.0;
    const wp::float32 var_150 = 0.0;
    const wp::float32 var_151 = 1.0;
    const wp::float32 var_152 = 0.0;
    wp::vec_t<6, wp::float32> var_153;
    wp::vec_t<6, wp::float32> var_154;
    const wp::float32 var_155 = 0.0;
    const wp::float32 var_156 = 0.0;
    const wp::float32 var_157 = 0.0;
    const wp::float32 var_158 = 0.0;
    const wp::float32 var_159 = 0.0;
    const wp::float32 var_160 = 1.0;
    wp::vec_t<6, wp::float32> var_161;
    wp::vec_t<6, wp::float32> var_162;
    const wp::int32 var_163 = 0;
    wp::int32 var_164;
    const wp::int32 var_165 = 1;
    wp::int32 var_166;
    const wp::int32 var_167 = 2;
    wp::int32 var_168;
    bool var_169;
    const wp::int32 var_170 = 4;
    bool var_171;
    const wp::int32 var_172 = 5;
    bool var_173;
    wp::vec_t<3, wp::float32> var_174;
    wp::vec_t<3, wp::float32> var_175;
    wp::vec_t<6, wp::float32> var_176;
    wp::vec_t<3, wp::float32> var_177;
    wp::vec_t<6, wp::float32> var_178;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    bool adj_1 = {};
    wp::vec_t<3, wp::float32> adj_2 = {};
    wp::vec_t<3, wp::float32> adj_3 = {};
    wp::vec_t<3, wp::float32> adj_4 = {};
    wp::vec_t<3, wp::float32> adj_5 = {};
    wp::vec_t<6, wp::float32> adj_6 = {};
    wp::vec_t<6, wp::float32> adj_7 = {};
    wp::int32 adj_8 = {};
    bool adj_9 = {};
    wp::vec_t<3, wp::float32> adj_10 = {};
    wp::vec_t<3, wp::float32> adj_11 = {};
    wp::vec_t<3, wp::float32> adj_12 = {};
    wp::vec_t<3, wp::float32> adj_13 = {};
    wp::vec_t<6, wp::float32> adj_14 = {};
    wp::vec_t<6, wp::float32> adj_15 = {};
    wp::int32 adj_16 = {};
    bool adj_17 = {};
    wp::int32 adj_18 = {};
    bool adj_19 = {};
    wp::int32 adj_20 = {};
    wp::int32 adj_21 = {};
    wp::vec_t<3, wp::float32> adj_22 = {};
    wp::vec_t<3, wp::float32> adj_23 = {};
    wp::vec_t<3, wp::float32> adj_24 = {};
    wp::vec_t<3, wp::float32> adj_25 = {};
    wp::vec_t<6, wp::float32> adj_26 = {};
    wp::vec_t<6, wp::float32> adj_27 = {};
    wp::int32 adj_28 = {};
    wp::int32 adj_29 = {};
    wp::int32 adj_30 = {};
    bool adj_31 = {};
    wp::int32 adj_32 = {};
    wp::int32 adj_33 = {};
    wp::vec_t<3, wp::float32> adj_34 = {};
    wp::vec_t<3, wp::float32> adj_35 = {};
    wp::vec_t<3, wp::float32> adj_36 = {};
    wp::vec_t<3, wp::float32> adj_37 = {};
    wp::vec_t<6, wp::float32> adj_38 = {};
    wp::vec_t<6, wp::float32> adj_39 = {};
    wp::int32 adj_40 = {};
    wp::int32 adj_41 = {};
    wp::vec_t<3, wp::float32> adj_42 = {};
    wp::vec_t<6, wp::float32> adj_43 = {};
    wp::int32 adj_44 = {};
    bool adj_45 = {};
    wp::int32 adj_46 = {};
    wp::int32 adj_47 = {};
    wp::vec_t<3, wp::float32> adj_48 = {};
    wp::vec_t<3, wp::float32> adj_49 = {};
    wp::vec_t<3, wp::float32> adj_50 = {};
    wp::vec_t<3, wp::float32> adj_51 = {};
    wp::vec_t<6, wp::float32> adj_52 = {};
    wp::vec_t<6, wp::float32> adj_53 = {};
    wp::int32 adj_54 = {};
    wp::int32 adj_55 = {};
    wp::vec_t<3, wp::float32> adj_56 = {};
    wp::vec_t<6, wp::float32> adj_57 = {};
    wp::int32 adj_58 = {};
    wp::int32 adj_59 = {};
    wp::int32 adj_60 = {};
    bool adj_61 = {};
    wp::vec_t<3, wp::float32> adj_62 = {};
    wp::vec_t<3, wp::float32> adj_63 = {};
    wp::vec_t<3, wp::float32> adj_64 = {};
    wp::vec_t<3, wp::float32> adj_65 = {};
    wp::vec_t<6, wp::float32> adj_66 = {};
    wp::vec_t<6, wp::float32> adj_67 = {};
    wp::vec_t<3, wp::float32> adj_68 = {};
    wp::int32 adj_69 = {};
    bool adj_70 = {};
    wp::int32 adj_71 = {};
    wp::int32 adj_72 = {};
    wp::vec_t<3, wp::float32> adj_73 = {};
    wp::int32 adj_74 = {};
    wp::int32 adj_75 = {};
    wp::vec_t<3, wp::float32> adj_76 = {};
    wp::int32 adj_77 = {};
    wp::int32 adj_78 = {};
    wp::float32 adj_79 = {};
    wp::vec_t<3, wp::float32> adj_80 = {};
    wp::vec_t<3, wp::float32> adj_81 = {};
    wp::vec_t<3, wp::float32> adj_82 = {};
    wp::vec_t<3, wp::float32> adj_83 = {};
    wp::float32 adj_84 = {};
    wp::vec_t<3, wp::float32> adj_85 = {};
    wp::vec_t<6, wp::float32> adj_86 = {};
    wp::vec_t<6, wp::float32> adj_87 = {};
    wp::int32 adj_88 = {};
    wp::int32 adj_89 = {};
    wp::vec_t<3, wp::float32> adj_90 = {};
    wp::vec_t<6, wp::float32> adj_91 = {};
    wp::vec_t<6, wp::float32> adj_92 = {};
    wp::int32 adj_93 = {};
    wp::int32 adj_94 = {};
    wp::int32 adj_95 = {};
    bool adj_96 = {};
    wp::int32 adj_97 = {};
    wp::int32 adj_98 = {};
    wp::vec_t<3, wp::float32> adj_99 = {};
    wp::int32 adj_100 = {};
    wp::int32 adj_101 = {};
    wp::vec_t<3, wp::float32> adj_102 = {};
    wp::int32 adj_103 = {};
    wp::int32 adj_104 = {};
    wp::vec_t<3, wp::float32> adj_105 = {};
    wp::int32 adj_106 = {};
    wp::int32 adj_107 = {};
    wp::float32 adj_108 = {};
    wp::int32 adj_109 = {};
    wp::int32 adj_110 = {};
    wp::float32 adj_111 = {};
    wp::vec_t<3, wp::float32> adj_112 = {};
    wp::vec_t<3, wp::float32> adj_113 = {};
    wp::vec_t<3, wp::float32> adj_114 = {};
    wp::vec_t<3, wp::float32> adj_115 = {};
    wp::vec_t<3, wp::float32> adj_116 = {};
    wp::vec_t<3, wp::float32> adj_117 = {};
    wp::float32 adj_118 = {};
    wp::float32 adj_119 = {};
    wp::vec_t<3, wp::float32> adj_120 = {};
    wp::vec_t<6, wp::float32> adj_121 = {};
    wp::vec_t<6, wp::float32> adj_122 = {};
    wp::int32 adj_123 = {};
    wp::int32 adj_124 = {};
    wp::vec_t<3, wp::float32> adj_125 = {};
    wp::vec_t<6, wp::float32> adj_126 = {};
    wp::vec_t<6, wp::float32> adj_127 = {};
    wp::int32 adj_128 = {};
    wp::int32 adj_129 = {};
    wp::vec_t<3, wp::float32> adj_130 = {};
    wp::vec_t<6, wp::float32> adj_131 = {};
    wp::vec_t<6, wp::float32> adj_132 = {};
    wp::int32 adj_133 = {};
    wp::int32 adj_134 = {};
    wp::vec_t<3, wp::float32> adj_135 = {};
    wp::vec_t<3, wp::float32> adj_136 = {};
    wp::int32 adj_137 = {};
    bool adj_138 = {};
    wp::float32 adj_139 = {};
    wp::float32 adj_140 = {};
    wp::float32 adj_141 = {};
    wp::float32 adj_142 = {};
    wp::float32 adj_143 = {};
    wp::float32 adj_144 = {};
    wp::vec_t<6, wp::float32> adj_145 = {};
    wp::vec_t<6, wp::float32> adj_146 = {};
    wp::float32 adj_147 = {};
    wp::float32 adj_148 = {};
    wp::float32 adj_149 = {};
    wp::float32 adj_150 = {};
    wp::float32 adj_151 = {};
    wp::float32 adj_152 = {};
    wp::vec_t<6, wp::float32> adj_153 = {};
    wp::vec_t<6, wp::float32> adj_154 = {};
    wp::float32 adj_155 = {};
    wp::float32 adj_156 = {};
    wp::float32 adj_157 = {};
    wp::float32 adj_158 = {};
    wp::float32 adj_159 = {};
    wp::float32 adj_160 = {};
    wp::vec_t<6, wp::float32> adj_161 = {};
    wp::vec_t<6, wp::float32> adj_162 = {};
    wp::int32 adj_163 = {};
    wp::int32 adj_164 = {};
    wp::int32 adj_165 = {};
    wp::int32 adj_166 = {};
    wp::int32 adj_167 = {};
    wp::int32 adj_168 = {};
    bool adj_169 = {};
    wp::int32 adj_170 = {};
    bool adj_171 = {};
    wp::int32 adj_172 = {};
    bool adj_173 = {};
    wp::vec_t<3, wp::float32> adj_174 = {};
    wp::vec_t<3, wp::float32> adj_175 = {};
    wp::vec_t<6, wp::float32> adj_176 = {};
    wp::vec_t<3, wp::float32> adj_177 = {};
    wp::vec_t<6, wp::float32> adj_178 = {};
    //---------
    // forward
    // def jcalc_motion_subspace(                                                             <L 973>
    // if joint_type_value == JointType.PRISMATIC:                                            <L 1016>
    var_1 = (var_joint_type_value == var_0);
    if (var_1) {
        // axis = joint_axis[qd_start]                                                        <L 1017>
        var_2 = wp::address(var_joint_axis, var_qd_start);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // S_s = transform_twist(X_pa_world, wp.spatial_vector(axis, wp.vec3()))              <L 1018>
        var_5 = wp::vec_t<3, wp::float32>();
        var_6 = wp::vec_t<6, wp::float32>(var_3, var_5);
        var_7 = transform_twist_1(var_X_pa_world, var_6);
        // joint_S_s[qd_start] = S_s                                                          <L 1019>
        // wp::array_store(var_joint_S_s, var_qd_start, var_7);
    }
    if (!var_1) {
        // elif joint_type_value == JointType.REVOLUTE:                                       <L 1021>
        var_9 = (var_joint_type_value == var_8);
        if (var_9) {
            // axis = joint_axis[qd_start]                                                    <L 1022>
            var_10 = wp::address(var_joint_axis, var_qd_start);
            var_12 = wp::load(var_10);
            var_11 = wp::copy(var_12);
            // S_s = transform_twist(X_pa_world, wp.spatial_vector(wp.vec3(), axis))          <L 1023>
            var_13 = wp::vec_t<3, wp::float32>();
            var_14 = wp::vec_t<6, wp::float32>(var_13, var_11);
            var_15 = transform_twist_1(var_X_pa_world, var_14);
            // joint_S_s[qd_start] = S_s                                                      <L 1024>
            // wp::array_store(var_joint_S_s, var_qd_start, var_15);
        }
        if (!var_9) {
            // elif joint_type_value == JointType.D6:                                         <L 1026>
            var_17 = (var_joint_type_value == var_16);
            if (var_17) {
                // if lin_axis_count > 0:                                                     <L 1027>
                var_19 = (var_lin_axis_count > var_18);
                if (var_19) {
                    // axis = joint_axis[qd_start + 0]                                        <L 1028>
                    var_21 = wp::add(var_qd_start, var_20);
                    var_22 = wp::address(var_joint_axis, var_21);
                    var_24 = wp::load(var_22);
                    var_23 = wp::copy(var_24);
                    // S_s = transform_twist(X_pa_world, wp.spatial_vector(axis, wp.vec3()))       <L 1029>
                    var_25 = wp::vec_t<3, wp::float32>();
                    var_26 = wp::vec_t<6, wp::float32>(var_23, var_25);
                    var_27 = transform_twist_1(var_X_pa_world, var_26);
                    // joint_S_s[qd_start + 0] = S_s                                          <L 1030>
                    var_29 = wp::add(var_qd_start, var_28);
                    // wp::array_store(var_joint_S_s, var_29, var_27);
                }
                // if lin_axis_count > 1:                                                     <L 1031>
                var_31 = (var_lin_axis_count > var_30);
                if (var_31) {
                    // axis = joint_axis[qd_start + 1]                                        <L 1032>
                    var_33 = wp::add(var_qd_start, var_32);
                    var_34 = wp::address(var_joint_axis, var_33);
                    var_36 = wp::load(var_34);
                    var_35 = wp::copy(var_36);
                    // S_s = transform_twist(X_pa_world, wp.spatial_vector(axis, wp.vec3()))       <L 1033>
                    var_37 = wp::vec_t<3, wp::float32>();
                    var_38 = wp::vec_t<6, wp::float32>(var_35, var_37);
                    var_39 = transform_twist_1(var_X_pa_world, var_38);
                    // joint_S_s[qd_start + 1] = S_s                                          <L 1034>
                    var_41 = wp::add(var_qd_start, var_40);
                    // wp::array_store(var_joint_S_s, var_41, var_39);
                }
                var_42 = wp::where(var_31, var_35, var_23);
                var_43 = wp::where(var_31, var_39, var_27);
                // if lin_axis_count > 2:                                                     <L 1035>
                var_45 = (var_lin_axis_count > var_44);
                if (var_45) {
                    // axis = joint_axis[qd_start + 2]                                        <L 1036>
                    var_47 = wp::add(var_qd_start, var_46);
                    var_48 = wp::address(var_joint_axis, var_47);
                    var_50 = wp::load(var_48);
                    var_49 = wp::copy(var_50);
                    // S_s = transform_twist(X_pa_world, wp.spatial_vector(axis, wp.vec3()))       <L 1037>
                    var_51 = wp::vec_t<3, wp::float32>();
                    var_52 = wp::vec_t<6, wp::float32>(var_49, var_51);
                    var_53 = transform_twist_1(var_X_pa_world, var_52);
                    // joint_S_s[qd_start + 2] = S_s                                          <L 1038>
                    var_55 = wp::add(var_qd_start, var_54);
                    // wp::array_store(var_joint_S_s, var_55, var_53);
                }
                var_56 = wp::where(var_45, var_49, var_42);
                var_57 = wp::where(var_45, var_53, var_43);
                // iqd = qd_start + lin_axis_count                                            <L 1039>
                var_58 = wp::add(var_qd_start, var_lin_axis_count);
                // iq = q_start + lin_axis_count                                              <L 1040>
                var_59 = wp::add(var_q_start, var_lin_axis_count);
                // if ang_axis_count == 1:                                                    <L 1041>
                var_61 = (var_ang_axis_count == var_60);
                if (var_61) {
                    // axis = joint_axis[iqd]                                                 <L 1042>
                    var_62 = wp::address(var_joint_axis, var_58);
                    var_64 = wp::load(var_62);
                    var_63 = wp::copy(var_64);
                    // joint_S_s[iqd] = transform_twist(X_pa_world, wp.spatial_vector(wp.vec3(), axis))       <L 1043>
                    var_65 = wp::vec_t<3, wp::float32>();
                    var_66 = wp::vec_t<6, wp::float32>(var_65, var_63);
                    var_67 = transform_twist_1(var_X_pa_world, var_66);
                    // wp::array_store(var_joint_S_s, var_58, var_67);
                }
                var_68 = wp::where(var_61, var_63, var_56);
                // if ang_axis_count == 2:                                                    <L 1044>
                var_70 = (var_ang_axis_count == var_69);
                if (var_70) {
                    // a0, a1 = transform_2d_rotational_axes(joint_axis[iqd + 0], joint_axis[iqd + 1], joint_q[iq + 0])       <L 1045>
                    var_72 = wp::add(var_58, var_71);
                    var_73 = wp::address(var_joint_axis, var_72);
                    var_75 = wp::add(var_58, var_74);
                    var_76 = wp::address(var_joint_axis, var_75);
                    var_78 = wp::add(var_59, var_77);
                    var_79 = wp::address(var_joint_q, var_78);
                    var_82 = wp::load(var_73);
                    var_83 = wp::load(var_76);
                    var_84 = wp::load(var_79);
                    transform_2d_rotational_axes_0(var_82, var_83, var_84, var_80, var_81);
                    // joint_S_s[iqd + 0] = transform_twist(X_pa_world, wp.spatial_vector(wp.vec3(), a0))       <L 1046>
                    var_85 = wp::vec_t<3, wp::float32>();
                    var_86 = wp::vec_t<6, wp::float32>(var_85, var_80);
                    var_87 = transform_twist_1(var_X_pa_world, var_86);
                    var_89 = wp::add(var_58, var_88);
                    // wp::array_store(var_joint_S_s, var_89, var_87);
                    // joint_S_s[iqd + 1] = transform_twist(X_pa_world, wp.spatial_vector(wp.vec3(), a1))       <L 1047>
                    var_90 = wp::vec_t<3, wp::float32>();
                    var_91 = wp::vec_t<6, wp::float32>(var_90, var_81);
                    var_92 = transform_twist_1(var_X_pa_world, var_91);
                    var_94 = wp::add(var_58, var_93);
                    // wp::array_store(var_joint_S_s, var_94, var_92);
                }
                // if ang_axis_count == 3:                                                    <L 1048>
                var_96 = (var_ang_axis_count == var_95);
                if (var_96) {
                    // a0, a1, a2 = transform_3d_rotational_axes(                             <L 1049>
                    // joint_axis[iqd + 0],                                                   <L 1050>
                    var_98 = wp::add(var_58, var_97);
                    var_99 = wp::address(var_joint_axis, var_98);
                    // joint_axis[iqd + 1],                                                   <L 1051>
                    var_101 = wp::add(var_58, var_100);
                    var_102 = wp::address(var_joint_axis, var_101);
                    // joint_axis[iqd + 2],                                                   <L 1052>
                    var_104 = wp::add(var_58, var_103);
                    var_105 = wp::address(var_joint_axis, var_104);
                    // joint_q[iq + 0],                                                       <L 1053>
                    var_107 = wp::add(var_59, var_106);
                    var_108 = wp::address(var_joint_q, var_107);
                    // joint_q[iq + 1],                                                       <L 1054>
                    var_110 = wp::add(var_59, var_109);
                    var_111 = wp::address(var_joint_q, var_110);
                    var_115 = wp::load(var_99);
                    var_116 = wp::load(var_102);
                    var_117 = wp::load(var_105);
                    var_118 = wp::load(var_108);
                    var_119 = wp::load(var_111);
                    transform_3d_rotational_axes_0(var_115, var_116, var_117, var_118, var_119, var_112, var_113, var_114);
                    // joint_S_s[iqd + 0] = transform_twist(X_pa_world, wp.spatial_vector(wp.vec3(), a0))       <L 1056>
                    var_120 = wp::vec_t<3, wp::float32>();
                    var_121 = wp::vec_t<6, wp::float32>(var_120, var_112);
                    var_122 = transform_twist_1(var_X_pa_world, var_121);
                    var_124 = wp::add(var_58, var_123);
                    // wp::array_store(var_joint_S_s, var_124, var_122);
                    // joint_S_s[iqd + 1] = transform_twist(X_pa_world, wp.spatial_vector(wp.vec3(), a1))       <L 1057>
                    var_125 = wp::vec_t<3, wp::float32>();
                    var_126 = wp::vec_t<6, wp::float32>(var_125, var_113);
                    var_127 = transform_twist_1(var_X_pa_world, var_126);
                    var_129 = wp::add(var_58, var_128);
                    // wp::array_store(var_joint_S_s, var_129, var_127);
                    // joint_S_s[iqd + 2] = transform_twist(X_pa_world, wp.spatial_vector(wp.vec3(), a2))       <L 1058>
                    var_130 = wp::vec_t<3, wp::float32>();
                    var_131 = wp::vec_t<6, wp::float32>(var_130, var_114);
                    var_132 = transform_twist_1(var_X_pa_world, var_131);
                    var_134 = wp::add(var_58, var_133);
                    // wp::array_store(var_joint_S_s, var_134, var_132);
                }
                var_135 = wp::where(var_96, var_112, var_80);
                var_136 = wp::where(var_96, var_113, var_81);
            }
            if (!var_17) {
                // elif joint_type_value == JointType.BALL:                                   <L 1060>
                var_138 = (var_joint_type_value == var_137);
                if (var_138) {
                    // S_0 = transform_twist(X_pa_world, wp.spatial_vector(0.0, 0.0, 0.0, 1.0, 0.0, 0.0))       <L 1061>
                    var_145 = wp::vec_t<6, wp::float32>({var_139, var_140, var_141, var_142, var_143, var_144});
                    var_146 = transform_twist_1(var_X_pa_world, var_145);
                    // S_1 = transform_twist(X_pa_world, wp.spatial_vector(0.0, 0.0, 0.0, 0.0, 1.0, 0.0))       <L 1062>
                    var_153 = wp::vec_t<6, wp::float32>({var_147, var_148, var_149, var_150, var_151, var_152});
                    var_154 = transform_twist_1(var_X_pa_world, var_153);
                    // S_2 = transform_twist(X_pa_world, wp.spatial_vector(0.0, 0.0, 0.0, 0.0, 0.0, 1.0))       <L 1063>
                    var_161 = wp::vec_t<6, wp::float32>({var_155, var_156, var_157, var_158, var_159, var_160});
                    var_162 = transform_twist_1(var_X_pa_world, var_161);
                    // joint_S_s[qd_start + 0] = S_0                                          <L 1064>
                    var_164 = wp::add(var_qd_start, var_163);
                    // wp::array_store(var_joint_S_s, var_164, var_146);
                    // joint_S_s[qd_start + 1] = S_1                                          <L 1065>
                    var_166 = wp::add(var_qd_start, var_165);
                    // wp::array_store(var_joint_S_s, var_166, var_154);
                    // joint_S_s[qd_start + 2] = S_2                                          <L 1066>
                    var_168 = wp::add(var_qd_start, var_167);
                    // wp::array_store(var_joint_S_s, var_168, var_162);
                }
                if (!var_138) {
                    // elif joint_type_value == JointType.FREE or joint_type_value == JointType.DISTANCE:       <L 1068>
                    var_171 = (var_joint_type_value == var_170);
                    var_169 = var_171;
                    if (!var_169) {
                        var_173 = (var_joint_type_value == var_172);
                        var_169 = var_169 || var_173;
                    }
                    if (var_169) {
                        // x_child_com_world = wp.transform_point(X_wc, body_com_child)       <L 1069>
                        var_174 = wp::transform_point(var_X_wc, var_body_com_child);
                        // write_free_distance_motion_subspace(X_pa_world, x_child_com_world, qd_start, joint_S_s)       <L 1070>
                        write_free_distance_motion_subspace_0(var_X_pa_world, var_174, var_qd_start, var_joint_S_s);
                    }
                }
            }
        }
        var_175 = wp::where(var_9, var_11, var_68);
        var_176 = wp::where(var_9, var_15, var_57);
    }
    var_177 = wp::where(var_1, var_3, var_175);
    var_178 = wp::where(var_1, var_7, var_176);
    //---------
    // reverse
    wp::adj_where(var_1, var_7, var_176, adj_1, adj_7, adj_176, adj_178);
    wp::adj_where(var_1, var_3, var_175, adj_1, adj_3, adj_175, adj_177);
    if (!var_1) {
        wp::adj_where(var_9, var_15, var_57, adj_9, adj_15, adj_57, adj_176);
        wp::adj_where(var_9, var_11, var_68, adj_9, adj_11, adj_68, adj_175);
        if (!var_9) {
            if (!var_17) {
                if (!var_138) {
                    if (var_169) {
                        adj_write_free_distance_motion_subspace_0(var_X_pa_world, var_174, var_qd_start, var_joint_S_s, adj_X_pa_world, adj_174, adj_qd_start, adj_joint_S_s);
                        // adj: write_free_distance_motion_subspace(X_pa_world, x_child_com_world, qd_start, joint_S_s)  <L 1070>
                        wp::adj_transform_point(var_X_wc, var_body_com_child, adj_X_wc, adj_body_com_child, adj_174);
                        // adj: x_child_com_world = wp.transform_point(X_wc, body_com_child)  <L 1069>
                    }
                    if (!var_169) {
                    }
                    // adj: elif joint_type_value == JointType.FREE or joint_type_value == JointType.DISTANCE:  <L 1068>
                }
                if (var_138) {
                    wp::adj_array_store(var_joint_S_s, var_168, var_162, adj_joint_S_s, adj_168, adj_162);
                    wp::adj_add(var_qd_start, var_167, adj_qd_start, adj_167, adj_168);
                    // adj: joint_S_s[qd_start + 2] = S_2                                     <L 1066>
                    wp::adj_array_store(var_joint_S_s, var_166, var_154, adj_joint_S_s, adj_166, adj_154);
                    wp::adj_add(var_qd_start, var_165, adj_qd_start, adj_165, adj_166);
                    // adj: joint_S_s[qd_start + 1] = S_1                                     <L 1065>
                    wp::adj_array_store(var_joint_S_s, var_164, var_146, adj_joint_S_s, adj_164, adj_146);
                    wp::adj_add(var_qd_start, var_163, adj_qd_start, adj_163, adj_164);
                    // adj: joint_S_s[qd_start + 0] = S_0                                     <L 1064>
                    adj_transform_twist_1(var_X_pa_world, var_161, adj_X_pa_world, adj_161, adj_162);
                    wp::adj_vec_t({var_155, var_156, var_157, var_158, var_159, var_160}, {&adj_155, &adj_156, &adj_157, &adj_158, &adj_159, &adj_160}, adj_161);
                    // adj: S_2 = transform_twist(X_pa_world, wp.spatial_vector(0.0, 0.0, 0.0, 0.0, 0.0, 1.0))  <L 1063>
                    adj_transform_twist_1(var_X_pa_world, var_153, adj_X_pa_world, adj_153, adj_154);
                    wp::adj_vec_t({var_147, var_148, var_149, var_150, var_151, var_152}, {&adj_147, &adj_148, &adj_149, &adj_150, &adj_151, &adj_152}, adj_153);
                    // adj: S_1 = transform_twist(X_pa_world, wp.spatial_vector(0.0, 0.0, 0.0, 0.0, 1.0, 0.0))  <L 1062>
                    adj_transform_twist_1(var_X_pa_world, var_145, adj_X_pa_world, adj_145, adj_146);
                    wp::adj_vec_t({var_139, var_140, var_141, var_142, var_143, var_144}, {&adj_139, &adj_140, &adj_141, &adj_142, &adj_143, &adj_144}, adj_145);
                    // adj: S_0 = transform_twist(X_pa_world, wp.spatial_vector(0.0, 0.0, 0.0, 1.0, 0.0, 0.0))  <L 1061>
                }
                // adj: elif joint_type_value == JointType.BALL:                              <L 1060>
            }
            if (var_17) {
                wp::adj_where(var_96, var_113, var_81, adj_96, adj_113, adj_81, adj_136);
                wp::adj_where(var_96, var_112, var_80, adj_96, adj_112, adj_80, adj_135);
                if (var_96) {
                    wp::adj_array_store(var_joint_S_s, var_134, var_132, adj_joint_S_s, adj_134, adj_132);
                    wp::adj_add(var_58, var_133, adj_58, adj_133, adj_134);
                    adj_transform_twist_1(var_X_pa_world, var_131, adj_X_pa_world, adj_131, adj_132);
                    wp::adj_vec_t(var_130, var_114, adj_130, adj_114, adj_131);
                    // adj: joint_S_s[iqd + 2] = transform_twist(X_pa_world, wp.spatial_vector(wp.vec3(), a2))  <L 1058>
                    wp::adj_array_store(var_joint_S_s, var_129, var_127, adj_joint_S_s, adj_129, adj_127);
                    wp::adj_add(var_58, var_128, adj_58, adj_128, adj_129);
                    adj_transform_twist_1(var_X_pa_world, var_126, adj_X_pa_world, adj_126, adj_127);
                    wp::adj_vec_t(var_125, var_113, adj_125, adj_113, adj_126);
                    // adj: joint_S_s[iqd + 1] = transform_twist(X_pa_world, wp.spatial_vector(wp.vec3(), a1))  <L 1057>
                    wp::adj_array_store(var_joint_S_s, var_124, var_122, adj_joint_S_s, adj_124, adj_122);
                    wp::adj_add(var_58, var_123, adj_58, adj_123, adj_124);
                    adj_transform_twist_1(var_X_pa_world, var_121, adj_X_pa_world, adj_121, adj_122);
                    wp::adj_vec_t(var_120, var_112, adj_120, adj_112, adj_121);
                    // adj: joint_S_s[iqd + 0] = transform_twist(X_pa_world, wp.spatial_vector(wp.vec3(), a0))  <L 1056>
                    adj_transform_3d_rotational_axes_0(var_115, var_116, var_117, var_118, var_119, var_112, var_113, var_114, adj_99, adj_102, adj_105, adj_108, adj_111, adj_112, adj_113, adj_114);
                    wp::adj_address(var_joint_q, var_110, adj_joint_q, adj_110, adj_111);
                    wp::adj_add(var_59, var_109, adj_59, adj_109, adj_110);
                    // adj: joint_q[iq + 1],                                                  <L 1054>
                    wp::adj_address(var_joint_q, var_107, adj_joint_q, adj_107, adj_108);
                    wp::adj_add(var_59, var_106, adj_59, adj_106, adj_107);
                    // adj: joint_q[iq + 0],                                                  <L 1053>
                    wp::adj_address(var_joint_axis, var_104, adj_joint_axis, adj_104, adj_105);
                    wp::adj_add(var_58, var_103, adj_58, adj_103, adj_104);
                    // adj: joint_axis[iqd + 2],                                              <L 1052>
                    wp::adj_address(var_joint_axis, var_101, adj_joint_axis, adj_101, adj_102);
                    wp::adj_add(var_58, var_100, adj_58, adj_100, adj_101);
                    // adj: joint_axis[iqd + 1],                                              <L 1051>
                    wp::adj_address(var_joint_axis, var_98, adj_joint_axis, adj_98, adj_99);
                    wp::adj_add(var_58, var_97, adj_58, adj_97, adj_98);
                    // adj: joint_axis[iqd + 0],                                              <L 1050>
                    // adj: a0, a1, a2 = transform_3d_rotational_axes(                        <L 1049>
                }
                // adj: if ang_axis_count == 3:                                               <L 1048>
                if (var_70) {
                    wp::adj_array_store(var_joint_S_s, var_94, var_92, adj_joint_S_s, adj_94, adj_92);
                    wp::adj_add(var_58, var_93, adj_58, adj_93, adj_94);
                    adj_transform_twist_1(var_X_pa_world, var_91, adj_X_pa_world, adj_91, adj_92);
                    wp::adj_vec_t(var_90, var_81, adj_90, adj_81, adj_91);
                    // adj: joint_S_s[iqd + 1] = transform_twist(X_pa_world, wp.spatial_vector(wp.vec3(), a1))  <L 1047>
                    wp::adj_array_store(var_joint_S_s, var_89, var_87, adj_joint_S_s, adj_89, adj_87);
                    wp::adj_add(var_58, var_88, adj_58, adj_88, adj_89);
                    adj_transform_twist_1(var_X_pa_world, var_86, adj_X_pa_world, adj_86, adj_87);
                    wp::adj_vec_t(var_85, var_80, adj_85, adj_80, adj_86);
                    // adj: joint_S_s[iqd + 0] = transform_twist(X_pa_world, wp.spatial_vector(wp.vec3(), a0))  <L 1046>
                    adj_transform_2d_rotational_axes_0(var_82, var_83, var_84, var_80, var_81, adj_73, adj_76, adj_79, adj_80, adj_81);
                    wp::adj_address(var_joint_q, var_78, adj_joint_q, adj_78, adj_79);
                    wp::adj_add(var_59, var_77, adj_59, adj_77, adj_78);
                    wp::adj_address(var_joint_axis, var_75, adj_joint_axis, adj_75, adj_76);
                    wp::adj_add(var_58, var_74, adj_58, adj_74, adj_75);
                    wp::adj_address(var_joint_axis, var_72, adj_joint_axis, adj_72, adj_73);
                    wp::adj_add(var_58, var_71, adj_58, adj_71, adj_72);
                    // adj: a0, a1 = transform_2d_rotational_axes(joint_axis[iqd + 0], joint_axis[iqd + 1], joint_q[iq + 0])  <L 1045>
                }
                // adj: if ang_axis_count == 2:                                               <L 1044>
                wp::adj_where(var_61, var_63, var_56, adj_61, adj_63, adj_56, adj_68);
                if (var_61) {
                    wp::adj_array_store(var_joint_S_s, var_58, var_67, adj_joint_S_s, adj_58, adj_67);
                    adj_transform_twist_1(var_X_pa_world, var_66, adj_X_pa_world, adj_66, adj_67);
                    wp::adj_vec_t(var_65, var_63, adj_65, adj_63, adj_66);
                    // adj: joint_S_s[iqd] = transform_twist(X_pa_world, wp.spatial_vector(wp.vec3(), axis))  <L 1043>
                    wp::adj_copy(var_64, adj_62, adj_63);
                    wp::adj_address(var_joint_axis, var_58, adj_joint_axis, adj_58, adj_62);
                    // adj: axis = joint_axis[iqd]                                            <L 1042>
                }
                // adj: if ang_axis_count == 1:                                               <L 1041>
                wp::adj_add(var_q_start, var_lin_axis_count, adj_q_start, adj_lin_axis_count, adj_59);
                // adj: iq = q_start + lin_axis_count                                         <L 1040>
                wp::adj_add(var_qd_start, var_lin_axis_count, adj_qd_start, adj_lin_axis_count, adj_58);
                // adj: iqd = qd_start + lin_axis_count                                       <L 1039>
                wp::adj_where(var_45, var_53, var_43, adj_45, adj_53, adj_43, adj_57);
                wp::adj_where(var_45, var_49, var_42, adj_45, adj_49, adj_42, adj_56);
                if (var_45) {
                    wp::adj_array_store(var_joint_S_s, var_55, var_53, adj_joint_S_s, adj_55, adj_53);
                    wp::adj_add(var_qd_start, var_54, adj_qd_start, adj_54, adj_55);
                    // adj: joint_S_s[qd_start + 2] = S_s                                     <L 1038>
                    adj_transform_twist_1(var_X_pa_world, var_52, adj_X_pa_world, adj_52, adj_53);
                    wp::adj_vec_t(var_49, var_51, adj_49, adj_51, adj_52);
                    // adj: S_s = transform_twist(X_pa_world, wp.spatial_vector(axis, wp.vec3()))  <L 1037>
                    wp::adj_copy(var_50, adj_48, adj_49);
                    wp::adj_address(var_joint_axis, var_47, adj_joint_axis, adj_47, adj_48);
                    wp::adj_add(var_qd_start, var_46, adj_qd_start, adj_46, adj_47);
                    // adj: axis = joint_axis[qd_start + 2]                                   <L 1036>
                }
                // adj: if lin_axis_count > 2:                                                <L 1035>
                wp::adj_where(var_31, var_39, var_27, adj_31, adj_39, adj_27, adj_43);
                wp::adj_where(var_31, var_35, var_23, adj_31, adj_35, adj_23, adj_42);
                if (var_31) {
                    wp::adj_array_store(var_joint_S_s, var_41, var_39, adj_joint_S_s, adj_41, adj_39);
                    wp::adj_add(var_qd_start, var_40, adj_qd_start, adj_40, adj_41);
                    // adj: joint_S_s[qd_start + 1] = S_s                                     <L 1034>
                    adj_transform_twist_1(var_X_pa_world, var_38, adj_X_pa_world, adj_38, adj_39);
                    wp::adj_vec_t(var_35, var_37, adj_35, adj_37, adj_38);
                    // adj: S_s = transform_twist(X_pa_world, wp.spatial_vector(axis, wp.vec3()))  <L 1033>
                    wp::adj_copy(var_36, adj_34, adj_35);
                    wp::adj_address(var_joint_axis, var_33, adj_joint_axis, adj_33, adj_34);
                    wp::adj_add(var_qd_start, var_32, adj_qd_start, adj_32, adj_33);
                    // adj: axis = joint_axis[qd_start + 1]                                   <L 1032>
                }
                // adj: if lin_axis_count > 1:                                                <L 1031>
                if (var_19) {
                    wp::adj_array_store(var_joint_S_s, var_29, var_27, adj_joint_S_s, adj_29, adj_27);
                    wp::adj_add(var_qd_start, var_28, adj_qd_start, adj_28, adj_29);
                    // adj: joint_S_s[qd_start + 0] = S_s                                     <L 1030>
                    adj_transform_twist_1(var_X_pa_world, var_26, adj_X_pa_world, adj_26, adj_27);
                    wp::adj_vec_t(var_23, var_25, adj_23, adj_25, adj_26);
                    // adj: S_s = transform_twist(X_pa_world, wp.spatial_vector(axis, wp.vec3()))  <L 1029>
                    wp::adj_copy(var_24, adj_22, adj_23);
                    wp::adj_address(var_joint_axis, var_21, adj_joint_axis, adj_21, adj_22);
                    wp::adj_add(var_qd_start, var_20, adj_qd_start, adj_20, adj_21);
                    // adj: axis = joint_axis[qd_start + 0]                                   <L 1028>
                }
                // adj: if lin_axis_count > 0:                                                <L 1027>
            }
            // adj: elif joint_type_value == JointType.D6:                                    <L 1026>
        }
        if (var_9) {
            wp::adj_array_store(var_joint_S_s, var_qd_start, var_15, adj_joint_S_s, adj_qd_start, adj_15);
            // adj: joint_S_s[qd_start] = S_s                                                 <L 1024>
            adj_transform_twist_1(var_X_pa_world, var_14, adj_X_pa_world, adj_14, adj_15);
            wp::adj_vec_t(var_13, var_11, adj_13, adj_11, adj_14);
            // adj: S_s = transform_twist(X_pa_world, wp.spatial_vector(wp.vec3(), axis))     <L 1023>
            wp::adj_copy(var_12, adj_10, adj_11);
            wp::adj_address(var_joint_axis, var_qd_start, adj_joint_axis, adj_qd_start, adj_10);
            // adj: axis = joint_axis[qd_start]                                               <L 1022>
        }
        // adj: elif joint_type_value == JointType.REVOLUTE:                                  <L 1021>
    }
    if (var_1) {
        wp::adj_array_store(var_joint_S_s, var_qd_start, var_7, adj_joint_S_s, adj_qd_start, adj_7);
        // adj: joint_S_s[qd_start] = S_s                                                     <L 1019>
        adj_transform_twist_1(var_X_pa_world, var_6, adj_X_pa_world, adj_6, adj_7);
        wp::adj_vec_t(var_3, var_5, adj_3, adj_5, adj_6);
        // adj: S_s = transform_twist(X_pa_world, wp.spatial_vector(axis, wp.vec3()))         <L 1018>
        wp::adj_copy(var_4, adj_2, adj_3);
        wp::adj_address(var_joint_axis, var_qd_start, adj_joint_axis, adj_qd_start, adj_2);
        // adj: axis = joint_axis[qd_start]                                                   <L 1017>
    }
    // adj: if joint_type_value == JointType.PRISMATIC:                                       <L 1016>
    // adj: def jcalc_motion_subspace(                                                        <L 973>
    return;
}



extern "C" __global__ void eval_articulation_inverse_dynamics_force_kernel_cb757198_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::int32> var_articulation_start,
    wp::array_t<wp::int32> var_articulation_end,
    wp::int32 var_articulation_count,
    wp::array_t<bool> var_articulation_mask,
    wp::array_t<wp::int32> var_joint_type,
    wp::array_t<wp::int32> var_joint_parent,
    wp::array_t<wp::int32> var_joint_qd_start,
    wp::array_t<wp::transform_t<wp::float32>> var_joint_X_p,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::float32> var_mass_matrix,
    wp::array_t<wp::float32> var_joint_qdd,
    wp::array_t<wp::float32> var_coriolis_force,
    wp::array_t<wp::float32> var_gravity_force,
    wp::array_t<wp::float32> var_tau)
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
        bool var_1;
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
        wp::int32 var_14;
        const wp::int32 var_15 = 1;
        wp::int32 var_16;
        wp::int32* var_17;
        wp::int32* var_18;
        wp::int32 var_19;
        wp::int32 var_20;
        wp::int32 var_21;
        bool* var_22;
        bool var_23;
        bool var_24;
        wp::range_t var_25;
        wp::int32 var_26;
        const wp::float32 var_27 = 0.0;
        wp::float32 var_28;
        wp::range_t var_29;
        wp::int32 var_30;
        const wp::float32 var_31 = 0.0;
        wp::float32 var_32;
        wp::range_t var_33;
        wp::int32 var_34;
        wp::float32* var_35;
        wp::int32 var_36;
        wp::float32* var_37;
        wp::float32 var_38;
        wp::float32 var_39;
        wp::float32 var_40;
        wp::float32 var_41;
        wp::int32 var_42;
        wp::range_t var_43;
        wp::int32 var_44;
        wp::int32* var_45;
        wp::int32 var_46;
        wp::int32 var_47;
        bool var_48;
        const wp::int32 var_49 = 4;
        bool var_50;
        const wp::int32 var_51 = 5;
        bool var_52;
        wp::int32* var_53;
        wp::int32 var_54;
        wp::int32 var_55;
        wp::transform_t<wp::float32>* var_56;
        wp::transform_t<wp::float32> var_57;
        wp::transform_t<wp::float32> var_58;
        wp::int32* var_59;
        wp::int32 var_60;
        wp::int32 var_61;
        const wp::int32 var_62 = 0;
        bool var_63;
        wp::transform_t<wp::float32>* var_64;
        wp::transform_t<wp::float32> var_65;
        wp::transform_t<wp::float32> var_66;
        wp::transform_t<wp::float32> var_67;
        wp::quat_t<wp::float32> var_68;
        const wp::int32 var_69 = 0;
        wp::int32 var_70;
        wp::float32* var_71;
        const wp::int32 var_72 = 1;
        wp::int32 var_73;
        wp::float32* var_74;
        const wp::int32 var_75 = 2;
        wp::int32 var_76;
        wp::float32* var_77;
        wp::vec_t<3, wp::float32> var_78;
        wp::float32 var_79;
        wp::float32 var_80;
        wp::float32 var_81;
        wp::vec_t<3, wp::float32> var_82;
        const wp::int32 var_83 = 3;
        wp::int32 var_84;
        wp::float32* var_85;
        const wp::int32 var_86 = 4;
        wp::int32 var_87;
        wp::float32* var_88;
        const wp::int32 var_89 = 5;
        wp::int32 var_90;
        wp::float32* var_91;
        wp::vec_t<3, wp::float32> var_92;
        wp::float32 var_93;
        wp::float32 var_94;
        wp::float32 var_95;
        wp::vec_t<3, wp::float32> var_96;
        const wp::int32 var_97 = 0;
        wp::float32 var_98;
        const wp::int32 var_99 = 0;
        wp::int32 var_100;
        const wp::int32 var_101 = 1;
        wp::float32 var_102;
        const wp::int32 var_103 = 1;
        wp::int32 var_104;
        const wp::int32 var_105 = 2;
        wp::float32 var_106;
        const wp::int32 var_107 = 2;
        wp::int32 var_108;
        const wp::int32 var_109 = 0;
        wp::float32 var_110;
        const wp::int32 var_111 = 3;
        wp::int32 var_112;
        const wp::int32 var_113 = 1;
        wp::float32 var_114;
        const wp::int32 var_115 = 4;
        wp::int32 var_116;
        const wp::int32 var_117 = 2;
        wp::float32 var_118;
        const wp::int32 var_119 = 5;
        wp::int32 var_120;
        wp::range_t var_121;
        wp::int32 var_122;
        wp::int32 var_123;
        wp::float32* var_124;
        wp::int32 var_125;
        wp::float32* var_126;
        wp::float32 var_127;
        wp::float32 var_128;
        wp::float32 var_129;
        wp::int32 var_130;
        wp::float32* var_131;
        wp::float32 var_132;
        wp::float32 var_133;
        wp::int32 var_134;
        wp::range_t var_135;
        wp::int32 var_136;
        const wp::float32 var_137 = 0.0;
        wp::float32 var_138;
        //---------
        // forward
        // def eval_articulation_inverse_dynamics_force_kernel(                                   <L 1381>
        // art_idx = wp.tid()                                                                     <L 1411>
        var_0 = builtin_tid1d();
        // if art_idx >= articulation_count:                                                      <L 1413>
        var_1 = (var_0 >= var_articulation_count);
        if (var_1) {
            // return                                                                             <L 1414>
            continue;
        }
        // joint_start = articulation_start[art_idx]                                              <L 1416>
        var_2 = wp::address(var_articulation_start, var_0);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // joint_end = articulation_end[art_idx]                                                  <L 1417>
        var_5 = wp::address(var_articulation_end, var_0);
        var_7 = wp::load(var_5);
        var_6 = wp::copy(var_7);
        // dof_start = joint_qd_start[joint_start]                                                <L 1418>
        var_8 = wp::address(var_joint_qd_start, var_3);
        var_10 = wp::load(var_8);
        var_9 = wp::copy(var_10);
        // dof_end = joint_qd_start[joint_end]                                                    <L 1419>
        var_11 = wp::address(var_joint_qd_start, var_6);
        var_13 = wp::load(var_11);
        var_12 = wp::copy(var_13);
        // dof_count = dof_end - dof_start                                                        <L 1420>
        var_14 = wp::sub(var_12, var_9);
        // gap_end = joint_qd_start[articulation_start[art_idx + 1]]                              <L 1421>
        var_16 = wp::add(var_0, var_15);
        var_17 = wp::address(var_articulation_start, var_16);
        var_19 = wp::load(var_17);
        var_18 = wp::address(var_joint_qd_start, var_19);
        var_21 = wp::load(var_18);
        var_20 = wp::copy(var_21);
        // if articulation_mask:                                                                  <L 1423>
        if (var_articulation_mask) {
            // if not articulation_mask[art_idx]:                                                 <L 1424>
            var_22 = wp::address(var_articulation_mask, var_0);
            var_24 = wp::load(var_22);
            var_23 = wp::unot(var_24);
            if (var_23) {
                // for k in range(dof_start, gap_end):                                            <L 1425>
                var_25 = wp::range(var_9, var_20);
                start_for_1:;
                    if (iter_cmp(var_25) == 0) goto end_for_1;
                    var_26 = wp::iter_next(var_25);
                    // tau[k] = float(0.0)                                                        <L 1426>
                    var_28 = wp::float(var_27);
                    wp::array_store(var_tau, var_26, var_28);
                    goto start_for_1;
                end_for_1:;
                // return                                                                         <L 1427>
                continue;
            }
        }
        // for i in range(dof_count):                                                             <L 1430>
        var_29 = wp::range(var_14);
        start_for_4:;
            if (iter_cmp(var_29) == 0) goto end_for_4;
            var_30 = wp::iter_next(var_29);
            // sum_val = float(0.0)                                                               <L 1431>
            var_32 = wp::float(var_31);
            // for j in range(dof_count):                                                         <L 1432>
            var_33 = wp::range(var_14);
            start_for_6:;
                if (iter_cmp(var_33) == 0) goto end_for_6;
                var_34 = wp::iter_next(var_33);
                // sum_val += mass_matrix[art_idx, i, j] * joint_qdd[dof_start + j]               <L 1433>
                var_35 = wp::address(var_mass_matrix, var_0, var_30, var_34);
                var_36 = wp::add(var_9, var_34);
                var_37 = wp::address(var_joint_qdd, var_36);
                var_39 = wp::load(var_35);
                var_40 = wp::load(var_37);
                var_38 = wp::mul(var_39, var_40);
                var_41 = wp::add(var_32, var_38);
                wp::assign(var_32, var_41);
                goto start_for_6;
            end_for_6:;
            // tau[dof_start + i] = sum_val                                                       <L 1434>
            var_42 = wp::add(var_9, var_30);
            wp::array_store(var_tau, var_42, var_32);
            goto start_for_4;
        end_for_4:;
        // for ji in range(joint_start, joint_end):                                               <L 1442>
        var_43 = wp::range(var_3, var_6);
        start_for_8:;
            if (iter_cmp(var_43) == 0) goto end_for_8;
            var_44 = wp::iter_next(var_43);
            // jtype = joint_type[ji]                                                             <L 1443>
            var_45 = wp::address(var_joint_type, var_44);
            var_47 = wp::load(var_45);
            var_46 = wp::copy(var_47);
            // if jtype == JointType.FREE or jtype == JointType.DISTANCE:                         <L 1444>
            var_50 = (var_46 == var_49);
            var_48 = var_50;
            if (!var_48) {
                var_52 = (var_46 == var_51);
                var_48 = var_48 || var_52;
            }
            if (var_48) {
                // jdof = joint_qd_start[ji]                                                      <L 1445>
                var_53 = wp::address(var_joint_qd_start, var_44);
                var_55 = wp::load(var_53);
                var_54 = wp::copy(var_55);
                // X_wpj = joint_X_p[ji]                                                          <L 1446>
                var_56 = wp::address(var_joint_X_p, var_44);
                var_58 = wp::load(var_56);
                var_57 = wp::copy(var_58);
                // parent = joint_parent[ji]                                                      <L 1447>
                var_59 = wp::address(var_joint_parent, var_44);
                var_61 = wp::load(var_59);
                var_60 = wp::copy(var_61);
                // if parent >= 0:                                                                <L 1448>
                var_63 = (var_60 >= var_62);
                if (var_63) {
                    // X_wpj = body_q[parent] * X_wpj                                             <L 1449>
                    var_64 = wp::address(var_body_q, var_60);
                    var_66 = wp::load(var_64);
                    var_65 = wp::mul(var_66, var_57);
                }
                var_67 = wp::where(var_63, var_65, var_57);
                // q_p = wp.transform_get_rotation(X_wpj)                                         <L 1450>
                var_68 = wp::transform_get_rotation(var_67);
                // f_lin = wp.quat_rotate(q_p, wp.vec3(tau[jdof + 0], tau[jdof + 1], tau[jdof + 2]))       <L 1451>
                var_70 = wp::add(var_54, var_69);
                var_71 = wp::address(var_tau, var_70);
                var_73 = wp::add(var_54, var_72);
                var_74 = wp::address(var_tau, var_73);
                var_76 = wp::add(var_54, var_75);
                var_77 = wp::address(var_tau, var_76);
                var_79 = wp::load(var_71);
                var_80 = wp::load(var_74);
                var_81 = wp::load(var_77);
                var_78 = wp::vec_t<3, wp::float32>(var_79, var_80, var_81);
                var_82 = wp::quat_rotate(var_68, var_78);
                // f_ang = wp.quat_rotate(q_p, wp.vec3(tau[jdof + 3], tau[jdof + 4], tau[jdof + 5]))       <L 1452>
                var_84 = wp::add(var_54, var_83);
                var_85 = wp::address(var_tau, var_84);
                var_87 = wp::add(var_54, var_86);
                var_88 = wp::address(var_tau, var_87);
                var_90 = wp::add(var_54, var_89);
                var_91 = wp::address(var_tau, var_90);
                var_93 = wp::load(var_85);
                var_94 = wp::load(var_88);
                var_95 = wp::load(var_91);
                var_92 = wp::vec_t<3, wp::float32>(var_93, var_94, var_95);
                var_96 = wp::quat_rotate(var_68, var_92);
                // tau[jdof + 0] = f_lin[0]                                                       <L 1453>
                var_98 = wp::extract(var_82, var_97);
                var_100 = wp::add(var_54, var_99);
                wp::array_store(var_tau, var_100, var_98);
                // tau[jdof + 1] = f_lin[1]                                                       <L 1454>
                var_102 = wp::extract(var_82, var_101);
                var_104 = wp::add(var_54, var_103);
                wp::array_store(var_tau, var_104, var_102);
                // tau[jdof + 2] = f_lin[2]                                                       <L 1455>
                var_106 = wp::extract(var_82, var_105);
                var_108 = wp::add(var_54, var_107);
                wp::array_store(var_tau, var_108, var_106);
                // tau[jdof + 3] = f_ang[0]                                                       <L 1456>
                var_110 = wp::extract(var_96, var_109);
                var_112 = wp::add(var_54, var_111);
                wp::array_store(var_tau, var_112, var_110);
                // tau[jdof + 4] = f_ang[1]                                                       <L 1457>
                var_114 = wp::extract(var_96, var_113);
                var_116 = wp::add(var_54, var_115);
                wp::array_store(var_tau, var_116, var_114);
                // tau[jdof + 5] = f_ang[2]                                                       <L 1458>
                var_118 = wp::extract(var_96, var_117);
                var_120 = wp::add(var_54, var_119);
                wp::array_store(var_tau, var_120, var_118);
            }
            goto start_for_8;
        end_for_8:;
        // for i in range(dof_count):                                                             <L 1461>
        var_121 = wp::range(var_14);
        start_for_10:;
            if (iter_cmp(var_121) == 0) goto end_for_10;
            var_122 = wp::iter_next(var_121);
            // tau[dof_start + i] = tau[dof_start + i] + coriolis_force[dof_start + i] + gravity_force[dof_start + i]       <L 1462>
            var_123 = wp::add(var_9, var_122);
            var_124 = wp::address(var_tau, var_123);
            var_125 = wp::add(var_9, var_122);
            var_126 = wp::address(var_coriolis_force, var_125);
            var_128 = wp::load(var_124);
            var_129 = wp::load(var_126);
            var_127 = wp::add(var_128, var_129);
            var_130 = wp::add(var_9, var_122);
            var_131 = wp::address(var_gravity_force, var_130);
            var_133 = wp::load(var_131);
            var_132 = wp::add(var_127, var_133);
            var_134 = wp::add(var_9, var_122);
            wp::array_store(var_tau, var_134, var_132);
            goto start_for_10;
        end_for_10:;
        // for k in range(dof_end, gap_end):                                                      <L 1468>
        var_135 = wp::range(var_12, var_20);
        start_for_12:;
            if (iter_cmp(var_135) == 0) goto end_for_12;
            var_136 = wp::iter_next(var_135);
            // tau[k] = float(0.0)                                                                <L 1469>
            var_138 = wp::float(var_137);
            wp::array_store(var_tau, var_136, var_138);
            goto start_for_12;
        end_for_12:;
    }
}



extern "C" __global__ void eval_articulation_inverse_dynamics_force_kernel_cb757198_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::int32> var_articulation_start,
    wp::array_t<wp::int32> var_articulation_end,
    wp::int32 var_articulation_count,
    wp::array_t<bool> var_articulation_mask,
    wp::array_t<wp::int32> var_joint_type,
    wp::array_t<wp::int32> var_joint_parent,
    wp::array_t<wp::int32> var_joint_qd_start,
    wp::array_t<wp::transform_t<wp::float32>> var_joint_X_p,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::float32> var_mass_matrix,
    wp::array_t<wp::float32> var_joint_qdd,
    wp::array_t<wp::float32> var_coriolis_force,
    wp::array_t<wp::float32> var_gravity_force,
    wp::array_t<wp::float32> var_tau,
    wp::array_t<wp::int32> adj_articulation_start,
    wp::array_t<wp::int32> adj_articulation_end,
    wp::int32 adj_articulation_count,
    wp::array_t<bool> adj_articulation_mask,
    wp::array_t<wp::int32> adj_joint_type,
    wp::array_t<wp::int32> adj_joint_parent,
    wp::array_t<wp::int32> adj_joint_qd_start,
    wp::array_t<wp::transform_t<wp::float32>> adj_joint_X_p,
    wp::array_t<wp::transform_t<wp::float32>> adj_body_q,
    wp::array_t<wp::float32> adj_mass_matrix,
    wp::array_t<wp::float32> adj_joint_qdd,
    wp::array_t<wp::float32> adj_coriolis_force,
    wp::array_t<wp::float32> adj_gravity_force,
    wp::array_t<wp::float32> adj_tau)
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
        bool var_1;
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
        wp::int32 var_14;
        const wp::int32 var_15 = 1;
        wp::int32 var_16;
        wp::int32* var_17;
        wp::int32* var_18;
        wp::int32 var_19;
        wp::int32 var_20;
        wp::int32 var_21;
        bool* var_22;
        bool var_23;
        bool var_24;
        wp::range_t var_25;
        wp::int32 var_26;
        const wp::float32 var_27 = 0.0;
        wp::float32 var_28;
        wp::range_t var_29;
        wp::int32 var_30;
        const wp::float32 var_31 = 0.0;
        wp::float32 var_32;
        wp::range_t var_33;
        wp::int32 var_34;
        wp::float32* var_35;
        wp::int32 var_36;
        wp::float32* var_37;
        wp::float32 var_38;
        wp::float32 var_39;
        wp::float32 var_40;
        wp::float32 var_41;
        wp::int32 var_42;
        wp::range_t var_43;
        wp::int32 var_44;
        wp::int32* var_45;
        wp::int32 var_46;
        wp::int32 var_47;
        bool var_48;
        const wp::int32 var_49 = 4;
        bool var_50;
        const wp::int32 var_51 = 5;
        bool var_52;
        wp::int32* var_53;
        wp::int32 var_54;
        wp::int32 var_55;
        wp::transform_t<wp::float32>* var_56;
        wp::transform_t<wp::float32> var_57;
        wp::transform_t<wp::float32> var_58;
        wp::int32* var_59;
        wp::int32 var_60;
        wp::int32 var_61;
        const wp::int32 var_62 = 0;
        bool var_63;
        wp::transform_t<wp::float32>* var_64;
        wp::transform_t<wp::float32> var_65;
        wp::transform_t<wp::float32> var_66;
        wp::transform_t<wp::float32> var_67;
        wp::quat_t<wp::float32> var_68;
        const wp::int32 var_69 = 0;
        wp::int32 var_70;
        wp::float32* var_71;
        const wp::int32 var_72 = 1;
        wp::int32 var_73;
        wp::float32* var_74;
        const wp::int32 var_75 = 2;
        wp::int32 var_76;
        wp::float32* var_77;
        wp::vec_t<3, wp::float32> var_78;
        wp::float32 var_79;
        wp::float32 var_80;
        wp::float32 var_81;
        wp::vec_t<3, wp::float32> var_82;
        const wp::int32 var_83 = 3;
        wp::int32 var_84;
        wp::float32* var_85;
        const wp::int32 var_86 = 4;
        wp::int32 var_87;
        wp::float32* var_88;
        const wp::int32 var_89 = 5;
        wp::int32 var_90;
        wp::float32* var_91;
        wp::vec_t<3, wp::float32> var_92;
        wp::float32 var_93;
        wp::float32 var_94;
        wp::float32 var_95;
        wp::vec_t<3, wp::float32> var_96;
        const wp::int32 var_97 = 0;
        wp::float32 var_98;
        const wp::int32 var_99 = 0;
        wp::int32 var_100;
        const wp::int32 var_101 = 1;
        wp::float32 var_102;
        const wp::int32 var_103 = 1;
        wp::int32 var_104;
        const wp::int32 var_105 = 2;
        wp::float32 var_106;
        const wp::int32 var_107 = 2;
        wp::int32 var_108;
        const wp::int32 var_109 = 0;
        wp::float32 var_110;
        const wp::int32 var_111 = 3;
        wp::int32 var_112;
        const wp::int32 var_113 = 1;
        wp::float32 var_114;
        const wp::int32 var_115 = 4;
        wp::int32 var_116;
        const wp::int32 var_117 = 2;
        wp::float32 var_118;
        const wp::int32 var_119 = 5;
        wp::int32 var_120;
        wp::range_t var_121;
        wp::int32 var_122;
        wp::int32 var_123;
        wp::float32* var_124;
        wp::int32 var_125;
        wp::float32* var_126;
        wp::float32 var_127;
        wp::float32 var_128;
        wp::float32 var_129;
        wp::int32 var_130;
        wp::float32* var_131;
        wp::float32 var_132;
        wp::float32 var_133;
        wp::int32 var_134;
        wp::range_t var_135;
        wp::int32 var_136;
        const wp::float32 var_137 = 0.0;
        wp::float32 var_138;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        bool adj_1 = {};
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
        bool adj_22 = {};
        bool adj_23 = {};
        bool adj_24 = {};
        wp::range_t adj_25 = {};
        wp::int32 adj_26 = {};
        wp::float32 adj_27 = {};
        wp::float32 adj_28 = {};
        wp::range_t adj_29 = {};
        wp::int32 adj_30 = {};
        wp::float32 adj_31 = {};
        wp::float32 adj_32 = {};
        wp::range_t adj_33 = {};
        wp::int32 adj_34 = {};
        wp::float32 adj_35 = {};
        wp::int32 adj_36 = {};
        wp::float32 adj_37 = {};
        wp::float32 adj_38 = {};
        wp::float32 adj_39 = {};
        wp::float32 adj_40 = {};
        wp::float32 adj_41 = {};
        wp::int32 adj_42 = {};
        wp::range_t adj_43 = {};
        wp::int32 adj_44 = {};
        wp::int32 adj_45 = {};
        wp::int32 adj_46 = {};
        wp::int32 adj_47 = {};
        bool adj_48 = {};
        wp::int32 adj_49 = {};
        bool adj_50 = {};
        wp::int32 adj_51 = {};
        bool adj_52 = {};
        wp::int32 adj_53 = {};
        wp::int32 adj_54 = {};
        wp::int32 adj_55 = {};
        wp::transform_t<wp::float32> adj_56 = {};
        wp::transform_t<wp::float32> adj_57 = {};
        wp::transform_t<wp::float32> adj_58 = {};
        wp::int32 adj_59 = {};
        wp::int32 adj_60 = {};
        wp::int32 adj_61 = {};
        wp::int32 adj_62 = {};
        bool adj_63 = {};
        wp::transform_t<wp::float32> adj_64 = {};
        wp::transform_t<wp::float32> adj_65 = {};
        wp::transform_t<wp::float32> adj_66 = {};
        wp::transform_t<wp::float32> adj_67 = {};
        wp::quat_t<wp::float32> adj_68 = {};
        wp::int32 adj_69 = {};
        wp::int32 adj_70 = {};
        wp::float32 adj_71 = {};
        wp::int32 adj_72 = {};
        wp::int32 adj_73 = {};
        wp::float32 adj_74 = {};
        wp::int32 adj_75 = {};
        wp::int32 adj_76 = {};
        wp::float32 adj_77 = {};
        wp::vec_t<3, wp::float32> adj_78 = {};
        wp::float32 adj_79 = {};
        wp::float32 adj_80 = {};
        wp::float32 adj_81 = {};
        wp::vec_t<3, wp::float32> adj_82 = {};
        wp::int32 adj_83 = {};
        wp::int32 adj_84 = {};
        wp::float32 adj_85 = {};
        wp::int32 adj_86 = {};
        wp::int32 adj_87 = {};
        wp::float32 adj_88 = {};
        wp::int32 adj_89 = {};
        wp::int32 adj_90 = {};
        wp::float32 adj_91 = {};
        wp::vec_t<3, wp::float32> adj_92 = {};
        wp::float32 adj_93 = {};
        wp::float32 adj_94 = {};
        wp::float32 adj_95 = {};
        wp::vec_t<3, wp::float32> adj_96 = {};
        wp::int32 adj_97 = {};
        wp::float32 adj_98 = {};
        wp::int32 adj_99 = {};
        wp::int32 adj_100 = {};
        wp::int32 adj_101 = {};
        wp::float32 adj_102 = {};
        wp::int32 adj_103 = {};
        wp::int32 adj_104 = {};
        wp::int32 adj_105 = {};
        wp::float32 adj_106 = {};
        wp::int32 adj_107 = {};
        wp::int32 adj_108 = {};
        wp::int32 adj_109 = {};
        wp::float32 adj_110 = {};
        wp::int32 adj_111 = {};
        wp::int32 adj_112 = {};
        wp::int32 adj_113 = {};
        wp::float32 adj_114 = {};
        wp::int32 adj_115 = {};
        wp::int32 adj_116 = {};
        wp::int32 adj_117 = {};
        wp::float32 adj_118 = {};
        wp::int32 adj_119 = {};
        wp::int32 adj_120 = {};
        wp::range_t adj_121 = {};
        wp::int32 adj_122 = {};
        wp::int32 adj_123 = {};
        wp::float32 adj_124 = {};
        wp::int32 adj_125 = {};
        wp::float32 adj_126 = {};
        wp::float32 adj_127 = {};
        wp::float32 adj_128 = {};
        wp::float32 adj_129 = {};
        wp::int32 adj_130 = {};
        wp::float32 adj_131 = {};
        wp::float32 adj_132 = {};
        wp::float32 adj_133 = {};
        wp::int32 adj_134 = {};
        wp::range_t adj_135 = {};
        wp::int32 adj_136 = {};
        wp::float32 adj_137 = {};
        wp::float32 adj_138 = {};
        //---------
        // forward
        // def eval_articulation_inverse_dynamics_force_kernel(                                   <L 1381>
        // art_idx = wp.tid()                                                                     <L 1411>
        var_0 = builtin_tid1d();
        // if art_idx >= articulation_count:                                                      <L 1413>
        var_1 = (var_0 >= var_articulation_count);
        if (var_1) {
            // return                                                                             <L 1414>
            goto label0;
        }
        // joint_start = articulation_start[art_idx]                                              <L 1416>
        var_2 = wp::address(var_articulation_start, var_0);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // joint_end = articulation_end[art_idx]                                                  <L 1417>
        var_5 = wp::address(var_articulation_end, var_0);
        var_7 = wp::load(var_5);
        var_6 = wp::copy(var_7);
        // dof_start = joint_qd_start[joint_start]                                                <L 1418>
        var_8 = wp::address(var_joint_qd_start, var_3);
        var_10 = wp::load(var_8);
        var_9 = wp::copy(var_10);
        // dof_end = joint_qd_start[joint_end]                                                    <L 1419>
        var_11 = wp::address(var_joint_qd_start, var_6);
        var_13 = wp::load(var_11);
        var_12 = wp::copy(var_13);
        // dof_count = dof_end - dof_start                                                        <L 1420>
        var_14 = wp::sub(var_12, var_9);
        // gap_end = joint_qd_start[articulation_start[art_idx + 1]]                              <L 1421>
        var_16 = wp::add(var_0, var_15);
        var_17 = wp::address(var_articulation_start, var_16);
        var_19 = wp::load(var_17);
        var_18 = wp::address(var_joint_qd_start, var_19);
        var_21 = wp::load(var_18);
        var_20 = wp::copy(var_21);
        // if articulation_mask:                                                                  <L 1423>
        if (var_articulation_mask) {
            // if not articulation_mask[art_idx]:                                                 <L 1424>
            var_22 = wp::address(var_articulation_mask, var_0);
            var_24 = wp::load(var_22);
            var_23 = wp::unot(var_24);
            if (var_23) {
                // for k in range(dof_start, gap_end):                                            <L 1425>
                var_25 = wp::range(var_9, var_20);
                // return                                                                         <L 1427>
                goto label3;
            }
        }
        // for i in range(dof_count):                                                             <L 1430>
        var_29 = wp::range(var_14);
        // for ji in range(joint_start, joint_end):                                               <L 1442>
        var_43 = wp::range(var_3, var_6);
        // for i in range(dof_count):                                                             <L 1461>
        var_121 = wp::range(var_14);
        // for k in range(dof_end, gap_end):                                                      <L 1468>
        var_135 = wp::range(var_12, var_20);
        //---------
        // reverse
        var_135 = wp::iter_reverse(var_135);
        start_for_12:;
            if (iter_cmp(var_135) == 0) goto end_for_12;
            var_136 = wp::iter_next(var_135);
        	adj_137 = {};
        	adj_138 = {};
            // tau[k] = float(0.0)                                                                <L 1469>
            var_138 = wp::float(var_137);
            // wp::array_store(var_tau, var_136, var_138);
            wp::adj_array_store(var_tau, var_136, var_138, adj_tau, adj_136, adj_138);
            wp::adj_float(var_137, adj_137, adj_138);
            // adj: tau[k] = float(0.0)                                                           <L 1469>
        	goto start_for_12;
        end_for_12:;
        // adj: for k in range(dof_end, gap_end):                                                 <L 1468>
        var_121 = wp::iter_reverse(var_121);
        start_for_10:;
            if (iter_cmp(var_121) == 0) goto end_for_10;
            var_122 = wp::iter_next(var_121);
        	adj_123 = {};
        	adj_124 = {};
        	adj_125 = {};
        	adj_126 = {};
        	adj_127 = {};
        	adj_128 = {};
        	adj_129 = {};
        	adj_130 = {};
        	adj_131 = {};
        	adj_132 = {};
        	adj_133 = {};
        	adj_134 = {};
            // tau[dof_start + i] = tau[dof_start + i] + coriolis_force[dof_start + i] + gravity_force[dof_start + i]       <L 1462>
            var_123 = wp::add(var_9, var_122);
            var_124 = wp::address(var_tau, var_123);
            var_125 = wp::add(var_9, var_122);
            var_126 = wp::address(var_coriolis_force, var_125);
            var_128 = wp::load(var_124);
            var_129 = wp::load(var_126);
            var_127 = wp::add(var_128, var_129);
            var_130 = wp::add(var_9, var_122);
            var_131 = wp::address(var_gravity_force, var_130);
            var_133 = wp::load(var_131);
            var_132 = wp::add(var_127, var_133);
            var_134 = wp::add(var_9, var_122);
            // wp::array_store(var_tau, var_134, var_132);
            wp::adj_array_store(var_tau, var_134, var_132, adj_tau, adj_134, adj_132);
            wp::adj_add(var_9, var_122, adj_9, adj_122, adj_134);
            wp::adj_add(var_127, var_133, adj_127, adj_131, adj_132);
            wp::adj_address(var_gravity_force, var_130, adj_gravity_force, adj_130, adj_131);
            wp::adj_add(var_9, var_122, adj_9, adj_122, adj_130);
            wp::adj_add(var_128, var_129, adj_124, adj_126, adj_127);
            wp::adj_address(var_coriolis_force, var_125, adj_coriolis_force, adj_125, adj_126);
            wp::adj_add(var_9, var_122, adj_9, adj_122, adj_125);
            wp::adj_address(var_tau, var_123, adj_tau, adj_123, adj_124);
            wp::adj_add(var_9, var_122, adj_9, adj_122, adj_123);
            // adj: tau[dof_start + i] = tau[dof_start + i] + coriolis_force[dof_start + i] + gravity_force[dof_start + i]  <L 1462>
        	goto start_for_10;
        end_for_10:;
        // adj: for i in range(dof_count):                                                        <L 1461>
        var_43 = wp::iter_reverse(var_43);
        start_for_8:;
            if (iter_cmp(var_43) == 0) goto end_for_8;
            var_44 = wp::iter_next(var_43);
        	adj_45 = {};
        	adj_46 = {};
        	adj_47 = {};
        	adj_48 = {};
        	adj_49 = {};
        	adj_50 = {};
        	adj_51 = {};
        	adj_52 = {};
        	adj_53 = {};
        	adj_54 = {};
        	adj_55 = {};
        	adj_56 = {};
        	adj_57 = {};
        	adj_58 = {};
        	adj_59 = {};
        	adj_60 = {};
        	adj_61 = {};
        	adj_62 = {};
        	adj_63 = {};
        	adj_64 = {};
        	adj_65 = {};
        	adj_66 = {};
        	adj_67 = {};
        	adj_68 = {};
        	adj_69 = {};
        	adj_70 = {};
        	adj_71 = {};
        	adj_72 = {};
        	adj_73 = {};
        	adj_74 = {};
        	adj_75 = {};
        	adj_76 = {};
        	adj_77 = {};
        	adj_78 = {};
        	adj_79 = {};
        	adj_80 = {};
        	adj_81 = {};
        	adj_82 = {};
        	adj_83 = {};
        	adj_84 = {};
        	adj_85 = {};
        	adj_86 = {};
        	adj_87 = {};
        	adj_88 = {};
        	adj_89 = {};
        	adj_90 = {};
        	adj_91 = {};
        	adj_92 = {};
        	adj_93 = {};
        	adj_94 = {};
        	adj_95 = {};
        	adj_96 = {};
        	adj_97 = {};
        	adj_98 = {};
        	adj_99 = {};
        	adj_100 = {};
        	adj_101 = {};
        	adj_102 = {};
        	adj_103 = {};
        	adj_104 = {};
        	adj_105 = {};
        	adj_106 = {};
        	adj_107 = {};
        	adj_108 = {};
        	adj_109 = {};
        	adj_110 = {};
        	adj_111 = {};
        	adj_112 = {};
        	adj_113 = {};
        	adj_114 = {};
        	adj_115 = {};
        	adj_116 = {};
        	adj_117 = {};
        	adj_118 = {};
        	adj_119 = {};
        	adj_120 = {};
            // jtype = joint_type[ji]                                                             <L 1443>
            var_45 = wp::address(var_joint_type, var_44);
            var_47 = wp::load(var_45);
            var_46 = wp::copy(var_47);
            // if jtype == JointType.FREE or jtype == JointType.DISTANCE:                         <L 1444>
            var_50 = (var_46 == var_49);
            var_48 = var_50;
            if (!var_48) {
                var_52 = (var_46 == var_51);
                var_48 = var_48 || var_52;
            }
            if (var_48) {
                // jdof = joint_qd_start[ji]                                                      <L 1445>
                var_53 = wp::address(var_joint_qd_start, var_44);
                var_55 = wp::load(var_53);
                var_54 = wp::copy(var_55);
                // X_wpj = joint_X_p[ji]                                                          <L 1446>
                var_56 = wp::address(var_joint_X_p, var_44);
                var_58 = wp::load(var_56);
                var_57 = wp::copy(var_58);
                // parent = joint_parent[ji]                                                      <L 1447>
                var_59 = wp::address(var_joint_parent, var_44);
                var_61 = wp::load(var_59);
                var_60 = wp::copy(var_61);
                // if parent >= 0:                                                                <L 1448>
                var_63 = (var_60 >= var_62);
                if (var_63) {
                    // X_wpj = body_q[parent] * X_wpj                                             <L 1449>
                    var_64 = wp::address(var_body_q, var_60);
                    var_66 = wp::load(var_64);
                    var_65 = wp::mul(var_66, var_57);
                }
                var_67 = wp::where(var_63, var_65, var_57);
                // q_p = wp.transform_get_rotation(X_wpj)                                         <L 1450>
                var_68 = wp::transform_get_rotation(var_67);
                // f_lin = wp.quat_rotate(q_p, wp.vec3(tau[jdof + 0], tau[jdof + 1], tau[jdof + 2]))       <L 1451>
                var_70 = wp::add(var_54, var_69);
                var_71 = wp::address(var_tau, var_70);
                var_73 = wp::add(var_54, var_72);
                var_74 = wp::address(var_tau, var_73);
                var_76 = wp::add(var_54, var_75);
                var_77 = wp::address(var_tau, var_76);
                var_79 = wp::load(var_71);
                var_80 = wp::load(var_74);
                var_81 = wp::load(var_77);
                var_78 = wp::vec_t<3, wp::float32>(var_79, var_80, var_81);
                var_82 = wp::quat_rotate(var_68, var_78);
                // f_ang = wp.quat_rotate(q_p, wp.vec3(tau[jdof + 3], tau[jdof + 4], tau[jdof + 5]))       <L 1452>
                var_84 = wp::add(var_54, var_83);
                var_85 = wp::address(var_tau, var_84);
                var_87 = wp::add(var_54, var_86);
                var_88 = wp::address(var_tau, var_87);
                var_90 = wp::add(var_54, var_89);
                var_91 = wp::address(var_tau, var_90);
                var_93 = wp::load(var_85);
                var_94 = wp::load(var_88);
                var_95 = wp::load(var_91);
                var_92 = wp::vec_t<3, wp::float32>(var_93, var_94, var_95);
                var_96 = wp::quat_rotate(var_68, var_92);
                // tau[jdof + 0] = f_lin[0]                                                       <L 1453>
                var_98 = wp::extract(var_82, var_97);
                var_100 = wp::add(var_54, var_99);
                // wp::array_store(var_tau, var_100, var_98);
                // tau[jdof + 1] = f_lin[1]                                                       <L 1454>
                var_102 = wp::extract(var_82, var_101);
                var_104 = wp::add(var_54, var_103);
                // wp::array_store(var_tau, var_104, var_102);
                // tau[jdof + 2] = f_lin[2]                                                       <L 1455>
                var_106 = wp::extract(var_82, var_105);
                var_108 = wp::add(var_54, var_107);
                // wp::array_store(var_tau, var_108, var_106);
                // tau[jdof + 3] = f_ang[0]                                                       <L 1456>
                var_110 = wp::extract(var_96, var_109);
                var_112 = wp::add(var_54, var_111);
                // wp::array_store(var_tau, var_112, var_110);
                // tau[jdof + 4] = f_ang[1]                                                       <L 1457>
                var_114 = wp::extract(var_96, var_113);
                var_116 = wp::add(var_54, var_115);
                // wp::array_store(var_tau, var_116, var_114);
                // tau[jdof + 5] = f_ang[2]                                                       <L 1458>
                var_118 = wp::extract(var_96, var_117);
                var_120 = wp::add(var_54, var_119);
                // wp::array_store(var_tau, var_120, var_118);
            }
            if (var_48) {
                wp::adj_array_store(var_tau, var_120, var_118, adj_tau, adj_120, adj_118);
                wp::adj_add(var_54, var_119, adj_54, adj_119, adj_120);
                wp::adj_extract(var_96, var_117, adj_96, adj_117, adj_118);
                // adj: tau[jdof + 5] = f_ang[2]                                                  <L 1458>
                wp::adj_array_store(var_tau, var_116, var_114, adj_tau, adj_116, adj_114);
                wp::adj_add(var_54, var_115, adj_54, adj_115, adj_116);
                wp::adj_extract(var_96, var_113, adj_96, adj_113, adj_114);
                // adj: tau[jdof + 4] = f_ang[1]                                                  <L 1457>
                wp::adj_array_store(var_tau, var_112, var_110, adj_tau, adj_112, adj_110);
                wp::adj_add(var_54, var_111, adj_54, adj_111, adj_112);
                wp::adj_extract(var_96, var_109, adj_96, adj_109, adj_110);
                // adj: tau[jdof + 3] = f_ang[0]                                                  <L 1456>
                wp::adj_array_store(var_tau, var_108, var_106, adj_tau, adj_108, adj_106);
                wp::adj_add(var_54, var_107, adj_54, adj_107, adj_108);
                wp::adj_extract(var_82, var_105, adj_82, adj_105, adj_106);
                // adj: tau[jdof + 2] = f_lin[2]                                                  <L 1455>
                wp::adj_array_store(var_tau, var_104, var_102, adj_tau, adj_104, adj_102);
                wp::adj_add(var_54, var_103, adj_54, adj_103, adj_104);
                wp::adj_extract(var_82, var_101, adj_82, adj_101, adj_102);
                // adj: tau[jdof + 1] = f_lin[1]                                                  <L 1454>
                wp::adj_array_store(var_tau, var_100, var_98, adj_tau, adj_100, adj_98);
                wp::adj_add(var_54, var_99, adj_54, adj_99, adj_100);
                wp::adj_extract(var_82, var_97, adj_82, adj_97, adj_98);
                // adj: tau[jdof + 0] = f_lin[0]                                                  <L 1453>
                wp::adj_quat_rotate(var_68, var_92, adj_68, adj_92, adj_96);
                wp::adj_vec_t(var_93, var_94, var_95, adj_85, adj_88, adj_91, adj_92);
                wp::adj_address(var_tau, var_90, adj_tau, adj_90, adj_91);
                wp::adj_add(var_54, var_89, adj_54, adj_89, adj_90);
                wp::adj_address(var_tau, var_87, adj_tau, adj_87, adj_88);
                wp::adj_add(var_54, var_86, adj_54, adj_86, adj_87);
                wp::adj_address(var_tau, var_84, adj_tau, adj_84, adj_85);
                wp::adj_add(var_54, var_83, adj_54, adj_83, adj_84);
                // adj: f_ang = wp.quat_rotate(q_p, wp.vec3(tau[jdof + 3], tau[jdof + 4], tau[jdof + 5]))  <L 1452>
                wp::adj_quat_rotate(var_68, var_78, adj_68, adj_78, adj_82);
                wp::adj_vec_t(var_79, var_80, var_81, adj_71, adj_74, adj_77, adj_78);
                wp::adj_address(var_tau, var_76, adj_tau, adj_76, adj_77);
                wp::adj_add(var_54, var_75, adj_54, adj_75, adj_76);
                wp::adj_address(var_tau, var_73, adj_tau, adj_73, adj_74);
                wp::adj_add(var_54, var_72, adj_54, adj_72, adj_73);
                wp::adj_address(var_tau, var_70, adj_tau, adj_70, adj_71);
                wp::adj_add(var_54, var_69, adj_54, adj_69, adj_70);
                // adj: f_lin = wp.quat_rotate(q_p, wp.vec3(tau[jdof + 0], tau[jdof + 1], tau[jdof + 2]))  <L 1451>
                wp::adj_transform_get_rotation(var_67, adj_67, adj_68);
                // adj: q_p = wp.transform_get_rotation(X_wpj)                                    <L 1450>
                wp::adj_where(var_63, var_65, var_57, adj_63, adj_65, adj_57, adj_67);
                if (var_63) {
                    wp::adj_mul(var_66, var_57, adj_64, adj_57, adj_65);
                    wp::adj_address(var_body_q, var_60, adj_body_q, adj_60, adj_64);
                    // adj: X_wpj = body_q[parent] * X_wpj                                        <L 1449>
                }
                // adj: if parent >= 0:                                                           <L 1448>
                wp::adj_copy(var_61, adj_59, adj_60);
                wp::adj_address(var_joint_parent, var_44, adj_joint_parent, adj_44, adj_59);
                // adj: parent = joint_parent[ji]                                                 <L 1447>
                wp::adj_copy(var_58, adj_56, adj_57);
                wp::adj_address(var_joint_X_p, var_44, adj_joint_X_p, adj_44, adj_56);
                // adj: X_wpj = joint_X_p[ji]                                                     <L 1446>
                wp::adj_copy(var_55, adj_53, adj_54);
                wp::adj_address(var_joint_qd_start, var_44, adj_joint_qd_start, adj_44, adj_53);
                // adj: jdof = joint_qd_start[ji]                                                 <L 1445>
            }
            if (!var_48) {
            }
            // adj: if jtype == JointType.FREE or jtype == JointType.DISTANCE:                    <L 1444>
            wp::adj_copy(var_47, adj_45, adj_46);
            wp::adj_address(var_joint_type, var_44, adj_joint_type, adj_44, adj_45);
            // adj: jtype = joint_type[ji]                                                        <L 1443>
        	goto start_for_8;
        end_for_8:;
        // adj: for ji in range(joint_start, joint_end):                                          <L 1442>
        var_29 = wp::iter_reverse(var_29);
        start_for_4:;
            if (iter_cmp(var_29) == 0) goto end_for_4;
            var_30 = wp::iter_next(var_29);
        	adj_31 = {};
        	adj_32 = {};
        	adj_33 = {};
        	adj_42 = {};
            // sum_val = float(0.0)                                                               <L 1431>
            var_32 = wp::float(var_31);
            // for j in range(dof_count):                                                         <L 1432>
            var_33 = wp::range(var_14);
            // tau[dof_start + i] = sum_val                                                       <L 1434>
            var_42 = wp::add(var_9, var_30);
            // wp::array_store(var_tau, var_42, var_32);
            wp::adj_array_store(var_tau, var_42, var_32, adj_tau, adj_42, adj_32);
            wp::adj_add(var_9, var_30, adj_9, adj_30, adj_42);
            // adj: tau[dof_start + i] = sum_val                                                  <L 1434>
            var_33 = wp::iter_reverse(var_33);
            start_for_6:;
                if (iter_cmp(var_33) == 0) goto end_for_6;
                var_34 = wp::iter_next(var_33);
            	adj_35 = {};
            	adj_36 = {};
            	adj_37 = {};
            	adj_38 = {};
            	adj_39 = {};
            	adj_40 = {};
            	adj_41 = {};
                // sum_val += mass_matrix[art_idx, i, j] * joint_qdd[dof_start + j]               <L 1433>
                var_35 = wp::address(var_mass_matrix, var_0, var_30, var_34);
                var_36 = wp::add(var_9, var_34);
                var_37 = wp::address(var_joint_qdd, var_36);
                var_39 = wp::load(var_35);
                var_40 = wp::load(var_37);
                var_38 = wp::mul(var_39, var_40);
                var_41 = wp::add(var_32, var_38);
                wp::assign(var_32, var_41);
                wp::adj_assign(var_32, var_41, adj_32, adj_41);
                wp::adj_add(var_32, var_38, adj_32, adj_38, adj_41);
                wp::adj_mul(var_39, var_40, adj_35, adj_37, adj_38);
                wp::adj_address(var_joint_qdd, var_36, adj_joint_qdd, adj_36, adj_37);
                wp::adj_add(var_9, var_34, adj_9, adj_34, adj_36);
                wp::adj_address(var_mass_matrix, var_0, var_30, var_34, adj_mass_matrix, adj_0, adj_30, adj_34, adj_35);
                // adj: sum_val += mass_matrix[art_idx, i, j] * joint_qdd[dof_start + j]          <L 1433>
            	goto start_for_6;
            end_for_6:;
            // adj: for j in range(dof_count):                                                    <L 1432>
            wp::adj_float(var_31, adj_31, adj_32);
            // adj: sum_val = float(0.0)                                                          <L 1431>
        	goto start_for_4;
        end_for_4:;
        // adj: for i in range(dof_count):                                                        <L 1430>
        if (var_articulation_mask) {
            if (var_23) {
                label3:;
                // adj: return                                                                    <L 1427>
                var_25 = wp::iter_reverse(var_25);
                start_for_1:;
                    if (iter_cmp(var_25) == 0) goto end_for_1;
                    var_26 = wp::iter_next(var_25);
                	adj_27 = {};
                	adj_28 = {};
                    // tau[k] = float(0.0)                                                        <L 1426>
                    var_28 = wp::float(var_27);
                    // wp::array_store(var_tau, var_26, var_28);
                    wp::adj_array_store(var_tau, var_26, var_28, adj_tau, adj_26, adj_28);
                    wp::adj_float(var_27, adj_27, adj_28);
                    // adj: tau[k] = float(0.0)                                                   <L 1426>
                	goto start_for_1;
                end_for_1:;
                // adj: for k in range(dof_start, gap_end):                                       <L 1425>
            }
            wp::adj_address(var_articulation_mask, var_0, adj_articulation_mask, adj_0, adj_22);
            // adj: if not articulation_mask[art_idx]:                                            <L 1424>
        }
        // adj: if articulation_mask:                                                             <L 1423>
        wp::adj_copy(var_21, adj_18, adj_20);
        wp::adj_address(var_joint_qd_start, var_19, adj_joint_qd_start, adj_17, adj_18);
        wp::adj_address(var_articulation_start, var_16, adj_articulation_start, adj_16, adj_17);
        wp::adj_add(var_0, var_15, adj_0, adj_15, adj_16);
        // adj: gap_end = joint_qd_start[articulation_start[art_idx + 1]]                         <L 1421>
        wp::adj_sub(var_12, var_9, adj_12, adj_9, adj_14);
        // adj: dof_count = dof_end - dof_start                                                   <L 1420>
        wp::adj_copy(var_13, adj_11, adj_12);
        wp::adj_address(var_joint_qd_start, var_6, adj_joint_qd_start, adj_6, adj_11);
        // adj: dof_end = joint_qd_start[joint_end]                                               <L 1419>
        wp::adj_copy(var_10, adj_8, adj_9);
        wp::adj_address(var_joint_qd_start, var_3, adj_joint_qd_start, adj_3, adj_8);
        // adj: dof_start = joint_qd_start[joint_start]                                           <L 1418>
        wp::adj_copy(var_7, adj_5, adj_6);
        wp::adj_address(var_articulation_end, var_0, adj_articulation_end, adj_0, adj_5);
        // adj: joint_end = articulation_end[art_idx]                                             <L 1417>
        wp::adj_copy(var_4, adj_2, adj_3);
        wp::adj_address(var_articulation_start, var_0, adj_articulation_start, adj_0, adj_2);
        // adj: joint_start = articulation_start[art_idx]                                         <L 1416>
        if (var_1) {
            label0:;
            // adj: return                                                                        <L 1414>
        }
        // adj: if art_idx >= articulation_count:                                                 <L 1413>
        // adj: art_idx = wp.tid()                                                                <L 1411>
        // adj: def eval_articulation_inverse_dynamics_force_kernel(                              <L 1381>
        continue;
    }
}



extern "C" __global__ void eval_articulation_mass_matrix_2c202997_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::int32> var_articulation_start,
    wp::array_t<wp::int32> var_articulation_end,
    wp::int32 var_articulation_count,
    wp::array_t<bool> var_articulation_mask,
    wp::array_t<wp::int32> var_joint_child,
    wp::array_t<wp::int32> var_joint_qd_start,
    wp::array_t<wp::mat_t<6, 6, wp::float32>> var_body_I_s,
    wp::array_t<wp::float32> var_J,
    wp::array_t<wp::float32> var_H)
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
        bool var_1;
        bool* var_2;
        bool var_3;
        bool var_4;
        wp::int32* var_5;
        wp::int32 var_6;
        wp::int32 var_7;
        wp::int32* var_8;
        wp::int32 var_9;
        wp::int32 var_10;
        wp::int32 var_11;
        wp::int32* var_12;
        wp::int32 var_13;
        wp::int32 var_14;
        wp::int32* var_15;
        wp::int32 var_16;
        wp::int32 var_17;
        wp::int32 var_18;
        wp::range_t var_19;
        wp::int32 var_20;
        wp::int32 var_21;
        wp::int32* var_22;
        wp::int32 var_23;
        wp::int32 var_24;
        wp::mat_t<6, 6, wp::float32>* var_25;
        wp::mat_t<6, 6, wp::float32> var_26;
        wp::mat_t<6, 6, wp::float32> var_27;
        const wp::int32 var_28 = 6;
        wp::int32 var_29;
        wp::range_t var_30;
        wp::int32 var_31;
        wp::range_t var_32;
        wp::int32 var_33;
        const wp::float32 var_34 = 0.0;
        wp::float32 var_35;
        const wp::int32 var_36 = 0;
        const wp::int32 var_37 = 0;
        wp::int32 var_38;
        wp::float32* var_39;
        wp::float32 var_40;
        wp::float32 var_41;
        wp::int32 var_42;
        wp::float32* var_43;
        wp::float32 var_44;
        wp::float32 var_45;
        wp::float32 var_46;
        wp::float32 var_47;
        wp::float32 var_48;
        wp::float32 var_49;
        const wp::int32 var_50 = 1;
        wp::int32 var_51;
        wp::float32* var_52;
        wp::float32 var_53;
        wp::float32 var_54;
        wp::int32 var_55;
        wp::float32* var_56;
        wp::float32 var_57;
        wp::float32 var_58;
        wp::float32 var_59;
        wp::float32 var_60;
        wp::float32 var_61;
        wp::float32 var_62;
        const wp::int32 var_63 = 2;
        wp::int32 var_64;
        wp::float32* var_65;
        wp::float32 var_66;
        wp::float32 var_67;
        wp::int32 var_68;
        wp::float32* var_69;
        wp::float32 var_70;
        wp::float32 var_71;
        wp::float32 var_72;
        wp::float32 var_73;
        wp::float32 var_74;
        wp::float32 var_75;
        const wp::int32 var_76 = 3;
        wp::int32 var_77;
        wp::float32* var_78;
        wp::float32 var_79;
        wp::float32 var_80;
        wp::int32 var_81;
        wp::float32* var_82;
        wp::float32 var_83;
        wp::float32 var_84;
        wp::float32 var_85;
        wp::float32 var_86;
        wp::float32 var_87;
        wp::float32 var_88;
        const wp::int32 var_89 = 4;
        wp::int32 var_90;
        wp::float32* var_91;
        wp::float32 var_92;
        wp::float32 var_93;
        wp::int32 var_94;
        wp::float32* var_95;
        wp::float32 var_96;
        wp::float32 var_97;
        wp::float32 var_98;
        wp::float32 var_99;
        wp::float32 var_100;
        wp::float32 var_101;
        const wp::int32 var_102 = 5;
        wp::int32 var_103;
        wp::float32* var_104;
        wp::float32 var_105;
        wp::float32 var_106;
        wp::int32 var_107;
        wp::float32* var_108;
        wp::float32 var_109;
        wp::float32 var_110;
        wp::float32 var_111;
        wp::float32 var_112;
        wp::float32 var_113;
        wp::float32 var_114;
        const wp::int32 var_115 = 1;
        const wp::int32 var_116 = 0;
        wp::int32 var_117;
        wp::float32* var_118;
        wp::float32 var_119;
        wp::float32 var_120;
        wp::int32 var_121;
        wp::float32* var_122;
        wp::float32 var_123;
        wp::float32 var_124;
        wp::float32 var_125;
        wp::float32 var_126;
        wp::float32 var_127;
        wp::float32 var_128;
        const wp::int32 var_129 = 1;
        wp::int32 var_130;
        wp::float32* var_131;
        wp::float32 var_132;
        wp::float32 var_133;
        wp::int32 var_134;
        wp::float32* var_135;
        wp::float32 var_136;
        wp::float32 var_137;
        wp::float32 var_138;
        wp::float32 var_139;
        wp::float32 var_140;
        wp::float32 var_141;
        const wp::int32 var_142 = 2;
        wp::int32 var_143;
        wp::float32* var_144;
        wp::float32 var_145;
        wp::float32 var_146;
        wp::int32 var_147;
        wp::float32* var_148;
        wp::float32 var_149;
        wp::float32 var_150;
        wp::float32 var_151;
        wp::float32 var_152;
        wp::float32 var_153;
        wp::float32 var_154;
        const wp::int32 var_155 = 3;
        wp::int32 var_156;
        wp::float32* var_157;
        wp::float32 var_158;
        wp::float32 var_159;
        wp::int32 var_160;
        wp::float32* var_161;
        wp::float32 var_162;
        wp::float32 var_163;
        wp::float32 var_164;
        wp::float32 var_165;
        wp::float32 var_166;
        wp::float32 var_167;
        const wp::int32 var_168 = 4;
        wp::int32 var_169;
        wp::float32* var_170;
        wp::float32 var_171;
        wp::float32 var_172;
        wp::int32 var_173;
        wp::float32* var_174;
        wp::float32 var_175;
        wp::float32 var_176;
        wp::float32 var_177;
        wp::float32 var_178;
        wp::float32 var_179;
        wp::float32 var_180;
        const wp::int32 var_181 = 5;
        wp::int32 var_182;
        wp::float32* var_183;
        wp::float32 var_184;
        wp::float32 var_185;
        wp::int32 var_186;
        wp::float32* var_187;
        wp::float32 var_188;
        wp::float32 var_189;
        wp::float32 var_190;
        wp::float32 var_191;
        wp::float32 var_192;
        wp::float32 var_193;
        const wp::int32 var_194 = 2;
        const wp::int32 var_195 = 0;
        wp::int32 var_196;
        wp::float32* var_197;
        wp::float32 var_198;
        wp::float32 var_199;
        wp::int32 var_200;
        wp::float32* var_201;
        wp::float32 var_202;
        wp::float32 var_203;
        wp::float32 var_204;
        wp::float32 var_205;
        wp::float32 var_206;
        wp::float32 var_207;
        const wp::int32 var_208 = 1;
        wp::int32 var_209;
        wp::float32* var_210;
        wp::float32 var_211;
        wp::float32 var_212;
        wp::int32 var_213;
        wp::float32* var_214;
        wp::float32 var_215;
        wp::float32 var_216;
        wp::float32 var_217;
        wp::float32 var_218;
        wp::float32 var_219;
        wp::float32 var_220;
        const wp::int32 var_221 = 2;
        wp::int32 var_222;
        wp::float32* var_223;
        wp::float32 var_224;
        wp::float32 var_225;
        wp::int32 var_226;
        wp::float32* var_227;
        wp::float32 var_228;
        wp::float32 var_229;
        wp::float32 var_230;
        wp::float32 var_231;
        wp::float32 var_232;
        wp::float32 var_233;
        const wp::int32 var_234 = 3;
        wp::int32 var_235;
        wp::float32* var_236;
        wp::float32 var_237;
        wp::float32 var_238;
        wp::int32 var_239;
        wp::float32* var_240;
        wp::float32 var_241;
        wp::float32 var_242;
        wp::float32 var_243;
        wp::float32 var_244;
        wp::float32 var_245;
        wp::float32 var_246;
        const wp::int32 var_247 = 4;
        wp::int32 var_248;
        wp::float32* var_249;
        wp::float32 var_250;
        wp::float32 var_251;
        wp::int32 var_252;
        wp::float32* var_253;
        wp::float32 var_254;
        wp::float32 var_255;
        wp::float32 var_256;
        wp::float32 var_257;
        wp::float32 var_258;
        wp::float32 var_259;
        const wp::int32 var_260 = 5;
        wp::int32 var_261;
        wp::float32* var_262;
        wp::float32 var_263;
        wp::float32 var_264;
        wp::int32 var_265;
        wp::float32* var_266;
        wp::float32 var_267;
        wp::float32 var_268;
        wp::float32 var_269;
        wp::float32 var_270;
        wp::float32 var_271;
        wp::float32 var_272;
        const wp::int32 var_273 = 3;
        const wp::int32 var_274 = 0;
        wp::int32 var_275;
        wp::float32* var_276;
        wp::float32 var_277;
        wp::float32 var_278;
        wp::int32 var_279;
        wp::float32* var_280;
        wp::float32 var_281;
        wp::float32 var_282;
        wp::float32 var_283;
        wp::float32 var_284;
        wp::float32 var_285;
        wp::float32 var_286;
        const wp::int32 var_287 = 1;
        wp::int32 var_288;
        wp::float32* var_289;
        wp::float32 var_290;
        wp::float32 var_291;
        wp::int32 var_292;
        wp::float32* var_293;
        wp::float32 var_294;
        wp::float32 var_295;
        wp::float32 var_296;
        wp::float32 var_297;
        wp::float32 var_298;
        wp::float32 var_299;
        const wp::int32 var_300 = 2;
        wp::int32 var_301;
        wp::float32* var_302;
        wp::float32 var_303;
        wp::float32 var_304;
        wp::int32 var_305;
        wp::float32* var_306;
        wp::float32 var_307;
        wp::float32 var_308;
        wp::float32 var_309;
        wp::float32 var_310;
        wp::float32 var_311;
        wp::float32 var_312;
        const wp::int32 var_313 = 3;
        wp::int32 var_314;
        wp::float32* var_315;
        wp::float32 var_316;
        wp::float32 var_317;
        wp::int32 var_318;
        wp::float32* var_319;
        wp::float32 var_320;
        wp::float32 var_321;
        wp::float32 var_322;
        wp::float32 var_323;
        wp::float32 var_324;
        wp::float32 var_325;
        const wp::int32 var_326 = 4;
        wp::int32 var_327;
        wp::float32* var_328;
        wp::float32 var_329;
        wp::float32 var_330;
        wp::int32 var_331;
        wp::float32* var_332;
        wp::float32 var_333;
        wp::float32 var_334;
        wp::float32 var_335;
        wp::float32 var_336;
        wp::float32 var_337;
        wp::float32 var_338;
        const wp::int32 var_339 = 5;
        wp::int32 var_340;
        wp::float32* var_341;
        wp::float32 var_342;
        wp::float32 var_343;
        wp::int32 var_344;
        wp::float32* var_345;
        wp::float32 var_346;
        wp::float32 var_347;
        wp::float32 var_348;
        wp::float32 var_349;
        wp::float32 var_350;
        wp::float32 var_351;
        const wp::int32 var_352 = 4;
        const wp::int32 var_353 = 0;
        wp::int32 var_354;
        wp::float32* var_355;
        wp::float32 var_356;
        wp::float32 var_357;
        wp::int32 var_358;
        wp::float32* var_359;
        wp::float32 var_360;
        wp::float32 var_361;
        wp::float32 var_362;
        wp::float32 var_363;
        wp::float32 var_364;
        wp::float32 var_365;
        const wp::int32 var_366 = 1;
        wp::int32 var_367;
        wp::float32* var_368;
        wp::float32 var_369;
        wp::float32 var_370;
        wp::int32 var_371;
        wp::float32* var_372;
        wp::float32 var_373;
        wp::float32 var_374;
        wp::float32 var_375;
        wp::float32 var_376;
        wp::float32 var_377;
        wp::float32 var_378;
        const wp::int32 var_379 = 2;
        wp::int32 var_380;
        wp::float32* var_381;
        wp::float32 var_382;
        wp::float32 var_383;
        wp::int32 var_384;
        wp::float32* var_385;
        wp::float32 var_386;
        wp::float32 var_387;
        wp::float32 var_388;
        wp::float32 var_389;
        wp::float32 var_390;
        wp::float32 var_391;
        const wp::int32 var_392 = 3;
        wp::int32 var_393;
        wp::float32* var_394;
        wp::float32 var_395;
        wp::float32 var_396;
        wp::int32 var_397;
        wp::float32* var_398;
        wp::float32 var_399;
        wp::float32 var_400;
        wp::float32 var_401;
        wp::float32 var_402;
        wp::float32 var_403;
        wp::float32 var_404;
        const wp::int32 var_405 = 4;
        wp::int32 var_406;
        wp::float32* var_407;
        wp::float32 var_408;
        wp::float32 var_409;
        wp::int32 var_410;
        wp::float32* var_411;
        wp::float32 var_412;
        wp::float32 var_413;
        wp::float32 var_414;
        wp::float32 var_415;
        wp::float32 var_416;
        wp::float32 var_417;
        const wp::int32 var_418 = 5;
        wp::int32 var_419;
        wp::float32* var_420;
        wp::float32 var_421;
        wp::float32 var_422;
        wp::int32 var_423;
        wp::float32* var_424;
        wp::float32 var_425;
        wp::float32 var_426;
        wp::float32 var_427;
        wp::float32 var_428;
        wp::float32 var_429;
        wp::float32 var_430;
        const wp::int32 var_431 = 5;
        const wp::int32 var_432 = 0;
        wp::int32 var_433;
        wp::float32* var_434;
        wp::float32 var_435;
        wp::float32 var_436;
        wp::int32 var_437;
        wp::float32* var_438;
        wp::float32 var_439;
        wp::float32 var_440;
        wp::float32 var_441;
        wp::float32 var_442;
        wp::float32 var_443;
        wp::float32 var_444;
        const wp::int32 var_445 = 1;
        wp::int32 var_446;
        wp::float32* var_447;
        wp::float32 var_448;
        wp::float32 var_449;
        wp::int32 var_450;
        wp::float32* var_451;
        wp::float32 var_452;
        wp::float32 var_453;
        wp::float32 var_454;
        wp::float32 var_455;
        wp::float32 var_456;
        wp::float32 var_457;
        const wp::int32 var_458 = 2;
        wp::int32 var_459;
        wp::float32* var_460;
        wp::float32 var_461;
        wp::float32 var_462;
        wp::int32 var_463;
        wp::float32* var_464;
        wp::float32 var_465;
        wp::float32 var_466;
        wp::float32 var_467;
        wp::float32 var_468;
        wp::float32 var_469;
        wp::float32 var_470;
        const wp::int32 var_471 = 3;
        wp::int32 var_472;
        wp::float32* var_473;
        wp::float32 var_474;
        wp::float32 var_475;
        wp::int32 var_476;
        wp::float32* var_477;
        wp::float32 var_478;
        wp::float32 var_479;
        wp::float32 var_480;
        wp::float32 var_481;
        wp::float32 var_482;
        wp::float32 var_483;
        const wp::int32 var_484 = 4;
        wp::int32 var_485;
        wp::float32* var_486;
        wp::float32 var_487;
        wp::float32 var_488;
        wp::int32 var_489;
        wp::float32* var_490;
        wp::float32 var_491;
        wp::float32 var_492;
        wp::float32 var_493;
        wp::float32 var_494;
        wp::float32 var_495;
        wp::float32 var_496;
        const wp::int32 var_497 = 5;
        wp::int32 var_498;
        wp::float32* var_499;
        wp::float32 var_500;
        wp::float32 var_501;
        wp::int32 var_502;
        wp::float32* var_503;
        wp::float32 var_504;
        wp::float32 var_505;
        wp::float32 var_506;
        wp::float32 var_507;
        wp::float32 var_508;
        wp::float32 var_509;
        wp::float32* var_510;
        wp::float32 var_511;
        wp::float32 var_512;
        //---------
        // forward
        // def eval_articulation_mass_matrix(                                                     <L 1320>
        // art_idx = wp.tid()                                                                     <L 1337>
        var_0 = builtin_tid1d();
        // if art_idx >= articulation_count:                                                      <L 1339>
        var_1 = (var_0 >= var_articulation_count);
        if (var_1) {
            // return                                                                             <L 1340>
            continue;
        }
        // if articulation_mask:                                                                  <L 1342>
        if (var_articulation_mask) {
            // if not articulation_mask[art_idx]:                                                 <L 1343>
            var_2 = wp::address(var_articulation_mask, var_0);
            var_4 = wp::load(var_2);
            var_3 = wp::unot(var_4);
            if (var_3) {
                // return                                                                         <L 1344>
                continue;
            }
        }
        // joint_start = articulation_start[art_idx]                                              <L 1346>
        var_5 = wp::address(var_articulation_start, var_0);
        var_7 = wp::load(var_5);
        var_6 = wp::copy(var_7);
        // joint_end = articulation_end[art_idx]                                                  <L 1347>
        var_8 = wp::address(var_articulation_end, var_0);
        var_10 = wp::load(var_8);
        var_9 = wp::copy(var_10);
        // joint_count = joint_end - joint_start                                                  <L 1348>
        var_11 = wp::sub(var_9, var_6);
        // articulation_dof_start = joint_qd_start[joint_start]                                   <L 1350>
        var_12 = wp::address(var_joint_qd_start, var_6);
        var_14 = wp::load(var_12);
        var_13 = wp::copy(var_14);
        // articulation_dof_end = joint_qd_start[joint_end]                                       <L 1351>
        var_15 = wp::address(var_joint_qd_start, var_9);
        var_17 = wp::load(var_15);
        var_16 = wp::copy(var_17);
        // articulation_dof_count = articulation_dof_end - articulation_dof_start                 <L 1352>
        var_18 = wp::sub(var_16, var_13);
        // for link_idx in range(joint_count):                                                    <L 1358>
        var_19 = wp::range(var_11);
        start_for_2:;
            if (iter_cmp(var_19) == 0) goto end_for_2;
            var_20 = wp::iter_next(var_19);
            // j = joint_start + link_idx                                                         <L 1359>
            var_21 = wp::add(var_6, var_20);
            // child = joint_child[j]                                                             <L 1360>
            var_22 = wp::address(var_joint_child, var_21);
            var_24 = wp::load(var_22);
            var_23 = wp::copy(var_24);
            // I_s = body_I_s[child]                                                              <L 1361>
            var_25 = wp::address(var_body_I_s, var_23);
            var_27 = wp::load(var_25);
            var_26 = wp::copy(var_27);
            // row_start = link_idx * 6                                                           <L 1363>
            var_29 = wp::mul(var_20, var_28);
            // for dof_i in range(articulation_dof_count):                                        <L 1366>
            var_30 = wp::range(var_18);
            start_for_4:;
                if (iter_cmp(var_30) == 0) goto end_for_4;
                var_31 = wp::iter_next(var_30);
                // for dof_j in range(articulation_dof_count):                                    <L 1367>
                var_32 = wp::range(var_18);
                start_for_6:;
                    if (iter_cmp(var_32) == 0) goto end_for_6;
                    var_33 = wp::iter_next(var_32);
                    // sum_val = float(0.0)                                                       <L 1368>
                    var_35 = wp::float(var_34);
                    // for k in range(6):                                                         <L 1371>
                    // for l in range(6):                                                         <L 1372>
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_38 = wp::add(var_29, var_36);
                    var_39 = wp::address(var_J, var_0, var_38, var_31);
                    var_41 = wp::load(var_39);
                    var_40 = wp::copy(var_41);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_42 = wp::add(var_29, var_37);
                    var_43 = wp::address(var_J, var_0, var_42, var_33);
                    var_45 = wp::load(var_43);
                    var_44 = wp::copy(var_45);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_46 = wp::extract(var_26, var_36, var_37);
                    var_47 = wp::mul(var_40, var_46);
                    var_48 = wp::mul(var_47, var_44);
                    var_49 = wp::add(var_35, var_48);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_51 = wp::add(var_29, var_36);
                    var_52 = wp::address(var_J, var_0, var_51, var_31);
                    var_54 = wp::load(var_52);
                    var_53 = wp::copy(var_54);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_55 = wp::add(var_29, var_50);
                    var_56 = wp::address(var_J, var_0, var_55, var_33);
                    var_58 = wp::load(var_56);
                    var_57 = wp::copy(var_58);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_59 = wp::extract(var_26, var_36, var_50);
                    var_60 = wp::mul(var_53, var_59);
                    var_61 = wp::mul(var_60, var_57);
                    var_62 = wp::add(var_49, var_61);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_64 = wp::add(var_29, var_36);
                    var_65 = wp::address(var_J, var_0, var_64, var_31);
                    var_67 = wp::load(var_65);
                    var_66 = wp::copy(var_67);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_68 = wp::add(var_29, var_63);
                    var_69 = wp::address(var_J, var_0, var_68, var_33);
                    var_71 = wp::load(var_69);
                    var_70 = wp::copy(var_71);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_72 = wp::extract(var_26, var_36, var_63);
                    var_73 = wp::mul(var_66, var_72);
                    var_74 = wp::mul(var_73, var_70);
                    var_75 = wp::add(var_62, var_74);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_77 = wp::add(var_29, var_36);
                    var_78 = wp::address(var_J, var_0, var_77, var_31);
                    var_80 = wp::load(var_78);
                    var_79 = wp::copy(var_80);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_81 = wp::add(var_29, var_76);
                    var_82 = wp::address(var_J, var_0, var_81, var_33);
                    var_84 = wp::load(var_82);
                    var_83 = wp::copy(var_84);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_85 = wp::extract(var_26, var_36, var_76);
                    var_86 = wp::mul(var_79, var_85);
                    var_87 = wp::mul(var_86, var_83);
                    var_88 = wp::add(var_75, var_87);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_90 = wp::add(var_29, var_36);
                    var_91 = wp::address(var_J, var_0, var_90, var_31);
                    var_93 = wp::load(var_91);
                    var_92 = wp::copy(var_93);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_94 = wp::add(var_29, var_89);
                    var_95 = wp::address(var_J, var_0, var_94, var_33);
                    var_97 = wp::load(var_95);
                    var_96 = wp::copy(var_97);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_98 = wp::extract(var_26, var_36, var_89);
                    var_99 = wp::mul(var_92, var_98);
                    var_100 = wp::mul(var_99, var_96);
                    var_101 = wp::add(var_88, var_100);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_103 = wp::add(var_29, var_36);
                    var_104 = wp::address(var_J, var_0, var_103, var_31);
                    var_106 = wp::load(var_104);
                    var_105 = wp::copy(var_106);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_107 = wp::add(var_29, var_102);
                    var_108 = wp::address(var_J, var_0, var_107, var_33);
                    var_110 = wp::load(var_108);
                    var_109 = wp::copy(var_110);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_111 = wp::extract(var_26, var_36, var_102);
                    var_112 = wp::mul(var_105, var_111);
                    var_113 = wp::mul(var_112, var_109);
                    var_114 = wp::add(var_101, var_113);
                    // for l in range(6):                                                         <L 1372>
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_117 = wp::add(var_29, var_115);
                    var_118 = wp::address(var_J, var_0, var_117, var_31);
                    var_120 = wp::load(var_118);
                    var_119 = wp::copy(var_120);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_121 = wp::add(var_29, var_116);
                    var_122 = wp::address(var_J, var_0, var_121, var_33);
                    var_124 = wp::load(var_122);
                    var_123 = wp::copy(var_124);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_125 = wp::extract(var_26, var_115, var_116);
                    var_126 = wp::mul(var_119, var_125);
                    var_127 = wp::mul(var_126, var_123);
                    var_128 = wp::add(var_114, var_127);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_130 = wp::add(var_29, var_115);
                    var_131 = wp::address(var_J, var_0, var_130, var_31);
                    var_133 = wp::load(var_131);
                    var_132 = wp::copy(var_133);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_134 = wp::add(var_29, var_129);
                    var_135 = wp::address(var_J, var_0, var_134, var_33);
                    var_137 = wp::load(var_135);
                    var_136 = wp::copy(var_137);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_138 = wp::extract(var_26, var_115, var_129);
                    var_139 = wp::mul(var_132, var_138);
                    var_140 = wp::mul(var_139, var_136);
                    var_141 = wp::add(var_128, var_140);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_143 = wp::add(var_29, var_115);
                    var_144 = wp::address(var_J, var_0, var_143, var_31);
                    var_146 = wp::load(var_144);
                    var_145 = wp::copy(var_146);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_147 = wp::add(var_29, var_142);
                    var_148 = wp::address(var_J, var_0, var_147, var_33);
                    var_150 = wp::load(var_148);
                    var_149 = wp::copy(var_150);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_151 = wp::extract(var_26, var_115, var_142);
                    var_152 = wp::mul(var_145, var_151);
                    var_153 = wp::mul(var_152, var_149);
                    var_154 = wp::add(var_141, var_153);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_156 = wp::add(var_29, var_115);
                    var_157 = wp::address(var_J, var_0, var_156, var_31);
                    var_159 = wp::load(var_157);
                    var_158 = wp::copy(var_159);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_160 = wp::add(var_29, var_155);
                    var_161 = wp::address(var_J, var_0, var_160, var_33);
                    var_163 = wp::load(var_161);
                    var_162 = wp::copy(var_163);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_164 = wp::extract(var_26, var_115, var_155);
                    var_165 = wp::mul(var_158, var_164);
                    var_166 = wp::mul(var_165, var_162);
                    var_167 = wp::add(var_154, var_166);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_169 = wp::add(var_29, var_115);
                    var_170 = wp::address(var_J, var_0, var_169, var_31);
                    var_172 = wp::load(var_170);
                    var_171 = wp::copy(var_172);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_173 = wp::add(var_29, var_168);
                    var_174 = wp::address(var_J, var_0, var_173, var_33);
                    var_176 = wp::load(var_174);
                    var_175 = wp::copy(var_176);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_177 = wp::extract(var_26, var_115, var_168);
                    var_178 = wp::mul(var_171, var_177);
                    var_179 = wp::mul(var_178, var_175);
                    var_180 = wp::add(var_167, var_179);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_182 = wp::add(var_29, var_115);
                    var_183 = wp::address(var_J, var_0, var_182, var_31);
                    var_185 = wp::load(var_183);
                    var_184 = wp::copy(var_185);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_186 = wp::add(var_29, var_181);
                    var_187 = wp::address(var_J, var_0, var_186, var_33);
                    var_189 = wp::load(var_187);
                    var_188 = wp::copy(var_189);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_190 = wp::extract(var_26, var_115, var_181);
                    var_191 = wp::mul(var_184, var_190);
                    var_192 = wp::mul(var_191, var_188);
                    var_193 = wp::add(var_180, var_192);
                    // for l in range(6):                                                         <L 1372>
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_196 = wp::add(var_29, var_194);
                    var_197 = wp::address(var_J, var_0, var_196, var_31);
                    var_199 = wp::load(var_197);
                    var_198 = wp::copy(var_199);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_200 = wp::add(var_29, var_195);
                    var_201 = wp::address(var_J, var_0, var_200, var_33);
                    var_203 = wp::load(var_201);
                    var_202 = wp::copy(var_203);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_204 = wp::extract(var_26, var_194, var_195);
                    var_205 = wp::mul(var_198, var_204);
                    var_206 = wp::mul(var_205, var_202);
                    var_207 = wp::add(var_193, var_206);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_209 = wp::add(var_29, var_194);
                    var_210 = wp::address(var_J, var_0, var_209, var_31);
                    var_212 = wp::load(var_210);
                    var_211 = wp::copy(var_212);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_213 = wp::add(var_29, var_208);
                    var_214 = wp::address(var_J, var_0, var_213, var_33);
                    var_216 = wp::load(var_214);
                    var_215 = wp::copy(var_216);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_217 = wp::extract(var_26, var_194, var_208);
                    var_218 = wp::mul(var_211, var_217);
                    var_219 = wp::mul(var_218, var_215);
                    var_220 = wp::add(var_207, var_219);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_222 = wp::add(var_29, var_194);
                    var_223 = wp::address(var_J, var_0, var_222, var_31);
                    var_225 = wp::load(var_223);
                    var_224 = wp::copy(var_225);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_226 = wp::add(var_29, var_221);
                    var_227 = wp::address(var_J, var_0, var_226, var_33);
                    var_229 = wp::load(var_227);
                    var_228 = wp::copy(var_229);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_230 = wp::extract(var_26, var_194, var_221);
                    var_231 = wp::mul(var_224, var_230);
                    var_232 = wp::mul(var_231, var_228);
                    var_233 = wp::add(var_220, var_232);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_235 = wp::add(var_29, var_194);
                    var_236 = wp::address(var_J, var_0, var_235, var_31);
                    var_238 = wp::load(var_236);
                    var_237 = wp::copy(var_238);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_239 = wp::add(var_29, var_234);
                    var_240 = wp::address(var_J, var_0, var_239, var_33);
                    var_242 = wp::load(var_240);
                    var_241 = wp::copy(var_242);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_243 = wp::extract(var_26, var_194, var_234);
                    var_244 = wp::mul(var_237, var_243);
                    var_245 = wp::mul(var_244, var_241);
                    var_246 = wp::add(var_233, var_245);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_248 = wp::add(var_29, var_194);
                    var_249 = wp::address(var_J, var_0, var_248, var_31);
                    var_251 = wp::load(var_249);
                    var_250 = wp::copy(var_251);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_252 = wp::add(var_29, var_247);
                    var_253 = wp::address(var_J, var_0, var_252, var_33);
                    var_255 = wp::load(var_253);
                    var_254 = wp::copy(var_255);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_256 = wp::extract(var_26, var_194, var_247);
                    var_257 = wp::mul(var_250, var_256);
                    var_258 = wp::mul(var_257, var_254);
                    var_259 = wp::add(var_246, var_258);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_261 = wp::add(var_29, var_194);
                    var_262 = wp::address(var_J, var_0, var_261, var_31);
                    var_264 = wp::load(var_262);
                    var_263 = wp::copy(var_264);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_265 = wp::add(var_29, var_260);
                    var_266 = wp::address(var_J, var_0, var_265, var_33);
                    var_268 = wp::load(var_266);
                    var_267 = wp::copy(var_268);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_269 = wp::extract(var_26, var_194, var_260);
                    var_270 = wp::mul(var_263, var_269);
                    var_271 = wp::mul(var_270, var_267);
                    var_272 = wp::add(var_259, var_271);
                    // for l in range(6):                                                         <L 1372>
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_275 = wp::add(var_29, var_273);
                    var_276 = wp::address(var_J, var_0, var_275, var_31);
                    var_278 = wp::load(var_276);
                    var_277 = wp::copy(var_278);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_279 = wp::add(var_29, var_274);
                    var_280 = wp::address(var_J, var_0, var_279, var_33);
                    var_282 = wp::load(var_280);
                    var_281 = wp::copy(var_282);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_283 = wp::extract(var_26, var_273, var_274);
                    var_284 = wp::mul(var_277, var_283);
                    var_285 = wp::mul(var_284, var_281);
                    var_286 = wp::add(var_272, var_285);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_288 = wp::add(var_29, var_273);
                    var_289 = wp::address(var_J, var_0, var_288, var_31);
                    var_291 = wp::load(var_289);
                    var_290 = wp::copy(var_291);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_292 = wp::add(var_29, var_287);
                    var_293 = wp::address(var_J, var_0, var_292, var_33);
                    var_295 = wp::load(var_293);
                    var_294 = wp::copy(var_295);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_296 = wp::extract(var_26, var_273, var_287);
                    var_297 = wp::mul(var_290, var_296);
                    var_298 = wp::mul(var_297, var_294);
                    var_299 = wp::add(var_286, var_298);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_301 = wp::add(var_29, var_273);
                    var_302 = wp::address(var_J, var_0, var_301, var_31);
                    var_304 = wp::load(var_302);
                    var_303 = wp::copy(var_304);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_305 = wp::add(var_29, var_300);
                    var_306 = wp::address(var_J, var_0, var_305, var_33);
                    var_308 = wp::load(var_306);
                    var_307 = wp::copy(var_308);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_309 = wp::extract(var_26, var_273, var_300);
                    var_310 = wp::mul(var_303, var_309);
                    var_311 = wp::mul(var_310, var_307);
                    var_312 = wp::add(var_299, var_311);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_314 = wp::add(var_29, var_273);
                    var_315 = wp::address(var_J, var_0, var_314, var_31);
                    var_317 = wp::load(var_315);
                    var_316 = wp::copy(var_317);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_318 = wp::add(var_29, var_313);
                    var_319 = wp::address(var_J, var_0, var_318, var_33);
                    var_321 = wp::load(var_319);
                    var_320 = wp::copy(var_321);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_322 = wp::extract(var_26, var_273, var_313);
                    var_323 = wp::mul(var_316, var_322);
                    var_324 = wp::mul(var_323, var_320);
                    var_325 = wp::add(var_312, var_324);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_327 = wp::add(var_29, var_273);
                    var_328 = wp::address(var_J, var_0, var_327, var_31);
                    var_330 = wp::load(var_328);
                    var_329 = wp::copy(var_330);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_331 = wp::add(var_29, var_326);
                    var_332 = wp::address(var_J, var_0, var_331, var_33);
                    var_334 = wp::load(var_332);
                    var_333 = wp::copy(var_334);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_335 = wp::extract(var_26, var_273, var_326);
                    var_336 = wp::mul(var_329, var_335);
                    var_337 = wp::mul(var_336, var_333);
                    var_338 = wp::add(var_325, var_337);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_340 = wp::add(var_29, var_273);
                    var_341 = wp::address(var_J, var_0, var_340, var_31);
                    var_343 = wp::load(var_341);
                    var_342 = wp::copy(var_343);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_344 = wp::add(var_29, var_339);
                    var_345 = wp::address(var_J, var_0, var_344, var_33);
                    var_347 = wp::load(var_345);
                    var_346 = wp::copy(var_347);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_348 = wp::extract(var_26, var_273, var_339);
                    var_349 = wp::mul(var_342, var_348);
                    var_350 = wp::mul(var_349, var_346);
                    var_351 = wp::add(var_338, var_350);
                    // for l in range(6):                                                         <L 1372>
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_354 = wp::add(var_29, var_352);
                    var_355 = wp::address(var_J, var_0, var_354, var_31);
                    var_357 = wp::load(var_355);
                    var_356 = wp::copy(var_357);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_358 = wp::add(var_29, var_353);
                    var_359 = wp::address(var_J, var_0, var_358, var_33);
                    var_361 = wp::load(var_359);
                    var_360 = wp::copy(var_361);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_362 = wp::extract(var_26, var_352, var_353);
                    var_363 = wp::mul(var_356, var_362);
                    var_364 = wp::mul(var_363, var_360);
                    var_365 = wp::add(var_351, var_364);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_367 = wp::add(var_29, var_352);
                    var_368 = wp::address(var_J, var_0, var_367, var_31);
                    var_370 = wp::load(var_368);
                    var_369 = wp::copy(var_370);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_371 = wp::add(var_29, var_366);
                    var_372 = wp::address(var_J, var_0, var_371, var_33);
                    var_374 = wp::load(var_372);
                    var_373 = wp::copy(var_374);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_375 = wp::extract(var_26, var_352, var_366);
                    var_376 = wp::mul(var_369, var_375);
                    var_377 = wp::mul(var_376, var_373);
                    var_378 = wp::add(var_365, var_377);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_380 = wp::add(var_29, var_352);
                    var_381 = wp::address(var_J, var_0, var_380, var_31);
                    var_383 = wp::load(var_381);
                    var_382 = wp::copy(var_383);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_384 = wp::add(var_29, var_379);
                    var_385 = wp::address(var_J, var_0, var_384, var_33);
                    var_387 = wp::load(var_385);
                    var_386 = wp::copy(var_387);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_388 = wp::extract(var_26, var_352, var_379);
                    var_389 = wp::mul(var_382, var_388);
                    var_390 = wp::mul(var_389, var_386);
                    var_391 = wp::add(var_378, var_390);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_393 = wp::add(var_29, var_352);
                    var_394 = wp::address(var_J, var_0, var_393, var_31);
                    var_396 = wp::load(var_394);
                    var_395 = wp::copy(var_396);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_397 = wp::add(var_29, var_392);
                    var_398 = wp::address(var_J, var_0, var_397, var_33);
                    var_400 = wp::load(var_398);
                    var_399 = wp::copy(var_400);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_401 = wp::extract(var_26, var_352, var_392);
                    var_402 = wp::mul(var_395, var_401);
                    var_403 = wp::mul(var_402, var_399);
                    var_404 = wp::add(var_391, var_403);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_406 = wp::add(var_29, var_352);
                    var_407 = wp::address(var_J, var_0, var_406, var_31);
                    var_409 = wp::load(var_407);
                    var_408 = wp::copy(var_409);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_410 = wp::add(var_29, var_405);
                    var_411 = wp::address(var_J, var_0, var_410, var_33);
                    var_413 = wp::load(var_411);
                    var_412 = wp::copy(var_413);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_414 = wp::extract(var_26, var_352, var_405);
                    var_415 = wp::mul(var_408, var_414);
                    var_416 = wp::mul(var_415, var_412);
                    var_417 = wp::add(var_404, var_416);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_419 = wp::add(var_29, var_352);
                    var_420 = wp::address(var_J, var_0, var_419, var_31);
                    var_422 = wp::load(var_420);
                    var_421 = wp::copy(var_422);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_423 = wp::add(var_29, var_418);
                    var_424 = wp::address(var_J, var_0, var_423, var_33);
                    var_426 = wp::load(var_424);
                    var_425 = wp::copy(var_426);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_427 = wp::extract(var_26, var_352, var_418);
                    var_428 = wp::mul(var_421, var_427);
                    var_429 = wp::mul(var_428, var_425);
                    var_430 = wp::add(var_417, var_429);
                    // for l in range(6):                                                         <L 1372>
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_433 = wp::add(var_29, var_431);
                    var_434 = wp::address(var_J, var_0, var_433, var_31);
                    var_436 = wp::load(var_434);
                    var_435 = wp::copy(var_436);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_437 = wp::add(var_29, var_432);
                    var_438 = wp::address(var_J, var_0, var_437, var_33);
                    var_440 = wp::load(var_438);
                    var_439 = wp::copy(var_440);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_441 = wp::extract(var_26, var_431, var_432);
                    var_442 = wp::mul(var_435, var_441);
                    var_443 = wp::mul(var_442, var_439);
                    var_444 = wp::add(var_430, var_443);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_446 = wp::add(var_29, var_431);
                    var_447 = wp::address(var_J, var_0, var_446, var_31);
                    var_449 = wp::load(var_447);
                    var_448 = wp::copy(var_449);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_450 = wp::add(var_29, var_445);
                    var_451 = wp::address(var_J, var_0, var_450, var_33);
                    var_453 = wp::load(var_451);
                    var_452 = wp::copy(var_453);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_454 = wp::extract(var_26, var_431, var_445);
                    var_455 = wp::mul(var_448, var_454);
                    var_456 = wp::mul(var_455, var_452);
                    var_457 = wp::add(var_444, var_456);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_459 = wp::add(var_29, var_431);
                    var_460 = wp::address(var_J, var_0, var_459, var_31);
                    var_462 = wp::load(var_460);
                    var_461 = wp::copy(var_462);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_463 = wp::add(var_29, var_458);
                    var_464 = wp::address(var_J, var_0, var_463, var_33);
                    var_466 = wp::load(var_464);
                    var_465 = wp::copy(var_466);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_467 = wp::extract(var_26, var_431, var_458);
                    var_468 = wp::mul(var_461, var_467);
                    var_469 = wp::mul(var_468, var_465);
                    var_470 = wp::add(var_457, var_469);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_472 = wp::add(var_29, var_431);
                    var_473 = wp::address(var_J, var_0, var_472, var_31);
                    var_475 = wp::load(var_473);
                    var_474 = wp::copy(var_475);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_476 = wp::add(var_29, var_471);
                    var_477 = wp::address(var_J, var_0, var_476, var_33);
                    var_479 = wp::load(var_477);
                    var_478 = wp::copy(var_479);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_480 = wp::extract(var_26, var_431, var_471);
                    var_481 = wp::mul(var_474, var_480);
                    var_482 = wp::mul(var_481, var_478);
                    var_483 = wp::add(var_470, var_482);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_485 = wp::add(var_29, var_431);
                    var_486 = wp::address(var_J, var_0, var_485, var_31);
                    var_488 = wp::load(var_486);
                    var_487 = wp::copy(var_488);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_489 = wp::add(var_29, var_484);
                    var_490 = wp::address(var_J, var_0, var_489, var_33);
                    var_492 = wp::load(var_490);
                    var_491 = wp::copy(var_492);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_493 = wp::extract(var_26, var_431, var_484);
                    var_494 = wp::mul(var_487, var_493);
                    var_495 = wp::mul(var_494, var_491);
                    var_496 = wp::add(var_483, var_495);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_498 = wp::add(var_29, var_431);
                    var_499 = wp::address(var_J, var_0, var_498, var_31);
                    var_501 = wp::load(var_499);
                    var_500 = wp::copy(var_501);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_502 = wp::add(var_29, var_497);
                    var_503 = wp::address(var_J, var_0, var_502, var_33);
                    var_505 = wp::load(var_503);
                    var_504 = wp::copy(var_505);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_506 = wp::extract(var_26, var_431, var_497);
                    var_507 = wp::mul(var_500, var_506);
                    var_508 = wp::mul(var_507, var_504);
                    var_509 = wp::add(var_496, var_508);
                    // H[art_idx, dof_i, dof_j] = H[art_idx, dof_i, dof_j] + sum_val              <L 1377>
                    var_510 = wp::address(var_H, var_0, var_31, var_33);
                    var_512 = wp::load(var_510);
                    var_511 = wp::add(var_512, var_509);
                    wp::array_store(var_H, var_0, var_31, var_33, var_511);
                    goto start_for_6;
                end_for_6:;
                goto start_for_4;
            end_for_4:;
            goto start_for_2;
        end_for_2:;
    }
}



extern "C" __global__ void eval_articulation_mass_matrix_2c202997_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::int32> var_articulation_start,
    wp::array_t<wp::int32> var_articulation_end,
    wp::int32 var_articulation_count,
    wp::array_t<bool> var_articulation_mask,
    wp::array_t<wp::int32> var_joint_child,
    wp::array_t<wp::int32> var_joint_qd_start,
    wp::array_t<wp::mat_t<6, 6, wp::float32>> var_body_I_s,
    wp::array_t<wp::float32> var_J,
    wp::array_t<wp::float32> var_H,
    wp::array_t<wp::int32> adj_articulation_start,
    wp::array_t<wp::int32> adj_articulation_end,
    wp::int32 adj_articulation_count,
    wp::array_t<bool> adj_articulation_mask,
    wp::array_t<wp::int32> adj_joint_child,
    wp::array_t<wp::int32> adj_joint_qd_start,
    wp::array_t<wp::mat_t<6, 6, wp::float32>> adj_body_I_s,
    wp::array_t<wp::float32> adj_J,
    wp::array_t<wp::float32> adj_H)
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
        bool var_1;
        bool* var_2;
        bool var_3;
        bool var_4;
        wp::int32* var_5;
        wp::int32 var_6;
        wp::int32 var_7;
        wp::int32* var_8;
        wp::int32 var_9;
        wp::int32 var_10;
        wp::int32 var_11;
        wp::int32* var_12;
        wp::int32 var_13;
        wp::int32 var_14;
        wp::int32* var_15;
        wp::int32 var_16;
        wp::int32 var_17;
        wp::int32 var_18;
        wp::range_t var_19;
        wp::int32 var_20;
        wp::int32 var_21;
        wp::int32* var_22;
        wp::int32 var_23;
        wp::int32 var_24;
        wp::mat_t<6, 6, wp::float32>* var_25;
        wp::mat_t<6, 6, wp::float32> var_26;
        wp::mat_t<6, 6, wp::float32> var_27;
        const wp::int32 var_28 = 6;
        wp::int32 var_29;
        wp::range_t var_30;
        wp::int32 var_31;
        wp::range_t var_32;
        wp::int32 var_33;
        const wp::float32 var_34 = 0.0;
        wp::float32 var_35;
        const wp::int32 var_36 = 0;
        const wp::int32 var_37 = 0;
        wp::int32 var_38;
        wp::float32* var_39;
        wp::float32 var_40;
        wp::float32 var_41;
        wp::int32 var_42;
        wp::float32* var_43;
        wp::float32 var_44;
        wp::float32 var_45;
        wp::float32 var_46;
        wp::float32 var_47;
        wp::float32 var_48;
        wp::float32 var_49;
        const wp::int32 var_50 = 1;
        wp::int32 var_51;
        wp::float32* var_52;
        wp::float32 var_53;
        wp::float32 var_54;
        wp::int32 var_55;
        wp::float32* var_56;
        wp::float32 var_57;
        wp::float32 var_58;
        wp::float32 var_59;
        wp::float32 var_60;
        wp::float32 var_61;
        wp::float32 var_62;
        const wp::int32 var_63 = 2;
        wp::int32 var_64;
        wp::float32* var_65;
        wp::float32 var_66;
        wp::float32 var_67;
        wp::int32 var_68;
        wp::float32* var_69;
        wp::float32 var_70;
        wp::float32 var_71;
        wp::float32 var_72;
        wp::float32 var_73;
        wp::float32 var_74;
        wp::float32 var_75;
        const wp::int32 var_76 = 3;
        wp::int32 var_77;
        wp::float32* var_78;
        wp::float32 var_79;
        wp::float32 var_80;
        wp::int32 var_81;
        wp::float32* var_82;
        wp::float32 var_83;
        wp::float32 var_84;
        wp::float32 var_85;
        wp::float32 var_86;
        wp::float32 var_87;
        wp::float32 var_88;
        const wp::int32 var_89 = 4;
        wp::int32 var_90;
        wp::float32* var_91;
        wp::float32 var_92;
        wp::float32 var_93;
        wp::int32 var_94;
        wp::float32* var_95;
        wp::float32 var_96;
        wp::float32 var_97;
        wp::float32 var_98;
        wp::float32 var_99;
        wp::float32 var_100;
        wp::float32 var_101;
        const wp::int32 var_102 = 5;
        wp::int32 var_103;
        wp::float32* var_104;
        wp::float32 var_105;
        wp::float32 var_106;
        wp::int32 var_107;
        wp::float32* var_108;
        wp::float32 var_109;
        wp::float32 var_110;
        wp::float32 var_111;
        wp::float32 var_112;
        wp::float32 var_113;
        wp::float32 var_114;
        const wp::int32 var_115 = 1;
        const wp::int32 var_116 = 0;
        wp::int32 var_117;
        wp::float32* var_118;
        wp::float32 var_119;
        wp::float32 var_120;
        wp::int32 var_121;
        wp::float32* var_122;
        wp::float32 var_123;
        wp::float32 var_124;
        wp::float32 var_125;
        wp::float32 var_126;
        wp::float32 var_127;
        wp::float32 var_128;
        const wp::int32 var_129 = 1;
        wp::int32 var_130;
        wp::float32* var_131;
        wp::float32 var_132;
        wp::float32 var_133;
        wp::int32 var_134;
        wp::float32* var_135;
        wp::float32 var_136;
        wp::float32 var_137;
        wp::float32 var_138;
        wp::float32 var_139;
        wp::float32 var_140;
        wp::float32 var_141;
        const wp::int32 var_142 = 2;
        wp::int32 var_143;
        wp::float32* var_144;
        wp::float32 var_145;
        wp::float32 var_146;
        wp::int32 var_147;
        wp::float32* var_148;
        wp::float32 var_149;
        wp::float32 var_150;
        wp::float32 var_151;
        wp::float32 var_152;
        wp::float32 var_153;
        wp::float32 var_154;
        const wp::int32 var_155 = 3;
        wp::int32 var_156;
        wp::float32* var_157;
        wp::float32 var_158;
        wp::float32 var_159;
        wp::int32 var_160;
        wp::float32* var_161;
        wp::float32 var_162;
        wp::float32 var_163;
        wp::float32 var_164;
        wp::float32 var_165;
        wp::float32 var_166;
        wp::float32 var_167;
        const wp::int32 var_168 = 4;
        wp::int32 var_169;
        wp::float32* var_170;
        wp::float32 var_171;
        wp::float32 var_172;
        wp::int32 var_173;
        wp::float32* var_174;
        wp::float32 var_175;
        wp::float32 var_176;
        wp::float32 var_177;
        wp::float32 var_178;
        wp::float32 var_179;
        wp::float32 var_180;
        const wp::int32 var_181 = 5;
        wp::int32 var_182;
        wp::float32* var_183;
        wp::float32 var_184;
        wp::float32 var_185;
        wp::int32 var_186;
        wp::float32* var_187;
        wp::float32 var_188;
        wp::float32 var_189;
        wp::float32 var_190;
        wp::float32 var_191;
        wp::float32 var_192;
        wp::float32 var_193;
        const wp::int32 var_194 = 2;
        const wp::int32 var_195 = 0;
        wp::int32 var_196;
        wp::float32* var_197;
        wp::float32 var_198;
        wp::float32 var_199;
        wp::int32 var_200;
        wp::float32* var_201;
        wp::float32 var_202;
        wp::float32 var_203;
        wp::float32 var_204;
        wp::float32 var_205;
        wp::float32 var_206;
        wp::float32 var_207;
        const wp::int32 var_208 = 1;
        wp::int32 var_209;
        wp::float32* var_210;
        wp::float32 var_211;
        wp::float32 var_212;
        wp::int32 var_213;
        wp::float32* var_214;
        wp::float32 var_215;
        wp::float32 var_216;
        wp::float32 var_217;
        wp::float32 var_218;
        wp::float32 var_219;
        wp::float32 var_220;
        const wp::int32 var_221 = 2;
        wp::int32 var_222;
        wp::float32* var_223;
        wp::float32 var_224;
        wp::float32 var_225;
        wp::int32 var_226;
        wp::float32* var_227;
        wp::float32 var_228;
        wp::float32 var_229;
        wp::float32 var_230;
        wp::float32 var_231;
        wp::float32 var_232;
        wp::float32 var_233;
        const wp::int32 var_234 = 3;
        wp::int32 var_235;
        wp::float32* var_236;
        wp::float32 var_237;
        wp::float32 var_238;
        wp::int32 var_239;
        wp::float32* var_240;
        wp::float32 var_241;
        wp::float32 var_242;
        wp::float32 var_243;
        wp::float32 var_244;
        wp::float32 var_245;
        wp::float32 var_246;
        const wp::int32 var_247 = 4;
        wp::int32 var_248;
        wp::float32* var_249;
        wp::float32 var_250;
        wp::float32 var_251;
        wp::int32 var_252;
        wp::float32* var_253;
        wp::float32 var_254;
        wp::float32 var_255;
        wp::float32 var_256;
        wp::float32 var_257;
        wp::float32 var_258;
        wp::float32 var_259;
        const wp::int32 var_260 = 5;
        wp::int32 var_261;
        wp::float32* var_262;
        wp::float32 var_263;
        wp::float32 var_264;
        wp::int32 var_265;
        wp::float32* var_266;
        wp::float32 var_267;
        wp::float32 var_268;
        wp::float32 var_269;
        wp::float32 var_270;
        wp::float32 var_271;
        wp::float32 var_272;
        const wp::int32 var_273 = 3;
        const wp::int32 var_274 = 0;
        wp::int32 var_275;
        wp::float32* var_276;
        wp::float32 var_277;
        wp::float32 var_278;
        wp::int32 var_279;
        wp::float32* var_280;
        wp::float32 var_281;
        wp::float32 var_282;
        wp::float32 var_283;
        wp::float32 var_284;
        wp::float32 var_285;
        wp::float32 var_286;
        const wp::int32 var_287 = 1;
        wp::int32 var_288;
        wp::float32* var_289;
        wp::float32 var_290;
        wp::float32 var_291;
        wp::int32 var_292;
        wp::float32* var_293;
        wp::float32 var_294;
        wp::float32 var_295;
        wp::float32 var_296;
        wp::float32 var_297;
        wp::float32 var_298;
        wp::float32 var_299;
        const wp::int32 var_300 = 2;
        wp::int32 var_301;
        wp::float32* var_302;
        wp::float32 var_303;
        wp::float32 var_304;
        wp::int32 var_305;
        wp::float32* var_306;
        wp::float32 var_307;
        wp::float32 var_308;
        wp::float32 var_309;
        wp::float32 var_310;
        wp::float32 var_311;
        wp::float32 var_312;
        const wp::int32 var_313 = 3;
        wp::int32 var_314;
        wp::float32* var_315;
        wp::float32 var_316;
        wp::float32 var_317;
        wp::int32 var_318;
        wp::float32* var_319;
        wp::float32 var_320;
        wp::float32 var_321;
        wp::float32 var_322;
        wp::float32 var_323;
        wp::float32 var_324;
        wp::float32 var_325;
        const wp::int32 var_326 = 4;
        wp::int32 var_327;
        wp::float32* var_328;
        wp::float32 var_329;
        wp::float32 var_330;
        wp::int32 var_331;
        wp::float32* var_332;
        wp::float32 var_333;
        wp::float32 var_334;
        wp::float32 var_335;
        wp::float32 var_336;
        wp::float32 var_337;
        wp::float32 var_338;
        const wp::int32 var_339 = 5;
        wp::int32 var_340;
        wp::float32* var_341;
        wp::float32 var_342;
        wp::float32 var_343;
        wp::int32 var_344;
        wp::float32* var_345;
        wp::float32 var_346;
        wp::float32 var_347;
        wp::float32 var_348;
        wp::float32 var_349;
        wp::float32 var_350;
        wp::float32 var_351;
        const wp::int32 var_352 = 4;
        const wp::int32 var_353 = 0;
        wp::int32 var_354;
        wp::float32* var_355;
        wp::float32 var_356;
        wp::float32 var_357;
        wp::int32 var_358;
        wp::float32* var_359;
        wp::float32 var_360;
        wp::float32 var_361;
        wp::float32 var_362;
        wp::float32 var_363;
        wp::float32 var_364;
        wp::float32 var_365;
        const wp::int32 var_366 = 1;
        wp::int32 var_367;
        wp::float32* var_368;
        wp::float32 var_369;
        wp::float32 var_370;
        wp::int32 var_371;
        wp::float32* var_372;
        wp::float32 var_373;
        wp::float32 var_374;
        wp::float32 var_375;
        wp::float32 var_376;
        wp::float32 var_377;
        wp::float32 var_378;
        const wp::int32 var_379 = 2;
        wp::int32 var_380;
        wp::float32* var_381;
        wp::float32 var_382;
        wp::float32 var_383;
        wp::int32 var_384;
        wp::float32* var_385;
        wp::float32 var_386;
        wp::float32 var_387;
        wp::float32 var_388;
        wp::float32 var_389;
        wp::float32 var_390;
        wp::float32 var_391;
        const wp::int32 var_392 = 3;
        wp::int32 var_393;
        wp::float32* var_394;
        wp::float32 var_395;
        wp::float32 var_396;
        wp::int32 var_397;
        wp::float32* var_398;
        wp::float32 var_399;
        wp::float32 var_400;
        wp::float32 var_401;
        wp::float32 var_402;
        wp::float32 var_403;
        wp::float32 var_404;
        const wp::int32 var_405 = 4;
        wp::int32 var_406;
        wp::float32* var_407;
        wp::float32 var_408;
        wp::float32 var_409;
        wp::int32 var_410;
        wp::float32* var_411;
        wp::float32 var_412;
        wp::float32 var_413;
        wp::float32 var_414;
        wp::float32 var_415;
        wp::float32 var_416;
        wp::float32 var_417;
        const wp::int32 var_418 = 5;
        wp::int32 var_419;
        wp::float32* var_420;
        wp::float32 var_421;
        wp::float32 var_422;
        wp::int32 var_423;
        wp::float32* var_424;
        wp::float32 var_425;
        wp::float32 var_426;
        wp::float32 var_427;
        wp::float32 var_428;
        wp::float32 var_429;
        wp::float32 var_430;
        const wp::int32 var_431 = 5;
        const wp::int32 var_432 = 0;
        wp::int32 var_433;
        wp::float32* var_434;
        wp::float32 var_435;
        wp::float32 var_436;
        wp::int32 var_437;
        wp::float32* var_438;
        wp::float32 var_439;
        wp::float32 var_440;
        wp::float32 var_441;
        wp::float32 var_442;
        wp::float32 var_443;
        wp::float32 var_444;
        const wp::int32 var_445 = 1;
        wp::int32 var_446;
        wp::float32* var_447;
        wp::float32 var_448;
        wp::float32 var_449;
        wp::int32 var_450;
        wp::float32* var_451;
        wp::float32 var_452;
        wp::float32 var_453;
        wp::float32 var_454;
        wp::float32 var_455;
        wp::float32 var_456;
        wp::float32 var_457;
        const wp::int32 var_458 = 2;
        wp::int32 var_459;
        wp::float32* var_460;
        wp::float32 var_461;
        wp::float32 var_462;
        wp::int32 var_463;
        wp::float32* var_464;
        wp::float32 var_465;
        wp::float32 var_466;
        wp::float32 var_467;
        wp::float32 var_468;
        wp::float32 var_469;
        wp::float32 var_470;
        const wp::int32 var_471 = 3;
        wp::int32 var_472;
        wp::float32* var_473;
        wp::float32 var_474;
        wp::float32 var_475;
        wp::int32 var_476;
        wp::float32* var_477;
        wp::float32 var_478;
        wp::float32 var_479;
        wp::float32 var_480;
        wp::float32 var_481;
        wp::float32 var_482;
        wp::float32 var_483;
        const wp::int32 var_484 = 4;
        wp::int32 var_485;
        wp::float32* var_486;
        wp::float32 var_487;
        wp::float32 var_488;
        wp::int32 var_489;
        wp::float32* var_490;
        wp::float32 var_491;
        wp::float32 var_492;
        wp::float32 var_493;
        wp::float32 var_494;
        wp::float32 var_495;
        wp::float32 var_496;
        const wp::int32 var_497 = 5;
        wp::int32 var_498;
        wp::float32* var_499;
        wp::float32 var_500;
        wp::float32 var_501;
        wp::int32 var_502;
        wp::float32* var_503;
        wp::float32 var_504;
        wp::float32 var_505;
        wp::float32 var_506;
        wp::float32 var_507;
        wp::float32 var_508;
        wp::float32 var_509;
        wp::float32* var_510;
        wp::float32 var_511;
        wp::float32 var_512;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        bool adj_1 = {};
        bool adj_2 = {};
        bool adj_3 = {};
        bool adj_4 = {};
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
        wp::range_t adj_19 = {};
        wp::int32 adj_20 = {};
        wp::int32 adj_21 = {};
        wp::int32 adj_22 = {};
        wp::int32 adj_23 = {};
        wp::int32 adj_24 = {};
        wp::mat_t<6, 6, wp::float32> adj_25 = {};
        wp::mat_t<6, 6, wp::float32> adj_26 = {};
        wp::mat_t<6, 6, wp::float32> adj_27 = {};
        wp::int32 adj_28 = {};
        wp::int32 adj_29 = {};
        wp::range_t adj_30 = {};
        wp::int32 adj_31 = {};
        wp::range_t adj_32 = {};
        wp::int32 adj_33 = {};
        wp::float32 adj_34 = {};
        wp::float32 adj_35 = {};
        wp::int32 adj_36 = {};
        wp::int32 adj_37 = {};
        wp::int32 adj_38 = {};
        wp::float32 adj_39 = {};
        wp::float32 adj_40 = {};
        wp::float32 adj_41 = {};
        wp::int32 adj_42 = {};
        wp::float32 adj_43 = {};
        wp::float32 adj_44 = {};
        wp::float32 adj_45 = {};
        wp::float32 adj_46 = {};
        wp::float32 adj_47 = {};
        wp::float32 adj_48 = {};
        wp::float32 adj_49 = {};
        wp::int32 adj_50 = {};
        wp::int32 adj_51 = {};
        wp::float32 adj_52 = {};
        wp::float32 adj_53 = {};
        wp::float32 adj_54 = {};
        wp::int32 adj_55 = {};
        wp::float32 adj_56 = {};
        wp::float32 adj_57 = {};
        wp::float32 adj_58 = {};
        wp::float32 adj_59 = {};
        wp::float32 adj_60 = {};
        wp::float32 adj_61 = {};
        wp::float32 adj_62 = {};
        wp::int32 adj_63 = {};
        wp::int32 adj_64 = {};
        wp::float32 adj_65 = {};
        wp::float32 adj_66 = {};
        wp::float32 adj_67 = {};
        wp::int32 adj_68 = {};
        wp::float32 adj_69 = {};
        wp::float32 adj_70 = {};
        wp::float32 adj_71 = {};
        wp::float32 adj_72 = {};
        wp::float32 adj_73 = {};
        wp::float32 adj_74 = {};
        wp::float32 adj_75 = {};
        wp::int32 adj_76 = {};
        wp::int32 adj_77 = {};
        wp::float32 adj_78 = {};
        wp::float32 adj_79 = {};
        wp::float32 adj_80 = {};
        wp::int32 adj_81 = {};
        wp::float32 adj_82 = {};
        wp::float32 adj_83 = {};
        wp::float32 adj_84 = {};
        wp::float32 adj_85 = {};
        wp::float32 adj_86 = {};
        wp::float32 adj_87 = {};
        wp::float32 adj_88 = {};
        wp::int32 adj_89 = {};
        wp::int32 adj_90 = {};
        wp::float32 adj_91 = {};
        wp::float32 adj_92 = {};
        wp::float32 adj_93 = {};
        wp::int32 adj_94 = {};
        wp::float32 adj_95 = {};
        wp::float32 adj_96 = {};
        wp::float32 adj_97 = {};
        wp::float32 adj_98 = {};
        wp::float32 adj_99 = {};
        wp::float32 adj_100 = {};
        wp::float32 adj_101 = {};
        wp::int32 adj_102 = {};
        wp::int32 adj_103 = {};
        wp::float32 adj_104 = {};
        wp::float32 adj_105 = {};
        wp::float32 adj_106 = {};
        wp::int32 adj_107 = {};
        wp::float32 adj_108 = {};
        wp::float32 adj_109 = {};
        wp::float32 adj_110 = {};
        wp::float32 adj_111 = {};
        wp::float32 adj_112 = {};
        wp::float32 adj_113 = {};
        wp::float32 adj_114 = {};
        wp::int32 adj_115 = {};
        wp::int32 adj_116 = {};
        wp::int32 adj_117 = {};
        wp::float32 adj_118 = {};
        wp::float32 adj_119 = {};
        wp::float32 adj_120 = {};
        wp::int32 adj_121 = {};
        wp::float32 adj_122 = {};
        wp::float32 adj_123 = {};
        wp::float32 adj_124 = {};
        wp::float32 adj_125 = {};
        wp::float32 adj_126 = {};
        wp::float32 adj_127 = {};
        wp::float32 adj_128 = {};
        wp::int32 adj_129 = {};
        wp::int32 adj_130 = {};
        wp::float32 adj_131 = {};
        wp::float32 adj_132 = {};
        wp::float32 adj_133 = {};
        wp::int32 adj_134 = {};
        wp::float32 adj_135 = {};
        wp::float32 adj_136 = {};
        wp::float32 adj_137 = {};
        wp::float32 adj_138 = {};
        wp::float32 adj_139 = {};
        wp::float32 adj_140 = {};
        wp::float32 adj_141 = {};
        wp::int32 adj_142 = {};
        wp::int32 adj_143 = {};
        wp::float32 adj_144 = {};
        wp::float32 adj_145 = {};
        wp::float32 adj_146 = {};
        wp::int32 adj_147 = {};
        wp::float32 adj_148 = {};
        wp::float32 adj_149 = {};
        wp::float32 adj_150 = {};
        wp::float32 adj_151 = {};
        wp::float32 adj_152 = {};
        wp::float32 adj_153 = {};
        wp::float32 adj_154 = {};
        wp::int32 adj_155 = {};
        wp::int32 adj_156 = {};
        wp::float32 adj_157 = {};
        wp::float32 adj_158 = {};
        wp::float32 adj_159 = {};
        wp::int32 adj_160 = {};
        wp::float32 adj_161 = {};
        wp::float32 adj_162 = {};
        wp::float32 adj_163 = {};
        wp::float32 adj_164 = {};
        wp::float32 adj_165 = {};
        wp::float32 adj_166 = {};
        wp::float32 adj_167 = {};
        wp::int32 adj_168 = {};
        wp::int32 adj_169 = {};
        wp::float32 adj_170 = {};
        wp::float32 adj_171 = {};
        wp::float32 adj_172 = {};
        wp::int32 adj_173 = {};
        wp::float32 adj_174 = {};
        wp::float32 adj_175 = {};
        wp::float32 adj_176 = {};
        wp::float32 adj_177 = {};
        wp::float32 adj_178 = {};
        wp::float32 adj_179 = {};
        wp::float32 adj_180 = {};
        wp::int32 adj_181 = {};
        wp::int32 adj_182 = {};
        wp::float32 adj_183 = {};
        wp::float32 adj_184 = {};
        wp::float32 adj_185 = {};
        wp::int32 adj_186 = {};
        wp::float32 adj_187 = {};
        wp::float32 adj_188 = {};
        wp::float32 adj_189 = {};
        wp::float32 adj_190 = {};
        wp::float32 adj_191 = {};
        wp::float32 adj_192 = {};
        wp::float32 adj_193 = {};
        wp::int32 adj_194 = {};
        wp::int32 adj_195 = {};
        wp::int32 adj_196 = {};
        wp::float32 adj_197 = {};
        wp::float32 adj_198 = {};
        wp::float32 adj_199 = {};
        wp::int32 adj_200 = {};
        wp::float32 adj_201 = {};
        wp::float32 adj_202 = {};
        wp::float32 adj_203 = {};
        wp::float32 adj_204 = {};
        wp::float32 adj_205 = {};
        wp::float32 adj_206 = {};
        wp::float32 adj_207 = {};
        wp::int32 adj_208 = {};
        wp::int32 adj_209 = {};
        wp::float32 adj_210 = {};
        wp::float32 adj_211 = {};
        wp::float32 adj_212 = {};
        wp::int32 adj_213 = {};
        wp::float32 adj_214 = {};
        wp::float32 adj_215 = {};
        wp::float32 adj_216 = {};
        wp::float32 adj_217 = {};
        wp::float32 adj_218 = {};
        wp::float32 adj_219 = {};
        wp::float32 adj_220 = {};
        wp::int32 adj_221 = {};
        wp::int32 adj_222 = {};
        wp::float32 adj_223 = {};
        wp::float32 adj_224 = {};
        wp::float32 adj_225 = {};
        wp::int32 adj_226 = {};
        wp::float32 adj_227 = {};
        wp::float32 adj_228 = {};
        wp::float32 adj_229 = {};
        wp::float32 adj_230 = {};
        wp::float32 adj_231 = {};
        wp::float32 adj_232 = {};
        wp::float32 adj_233 = {};
        wp::int32 adj_234 = {};
        wp::int32 adj_235 = {};
        wp::float32 adj_236 = {};
        wp::float32 adj_237 = {};
        wp::float32 adj_238 = {};
        wp::int32 adj_239 = {};
        wp::float32 adj_240 = {};
        wp::float32 adj_241 = {};
        wp::float32 adj_242 = {};
        wp::float32 adj_243 = {};
        wp::float32 adj_244 = {};
        wp::float32 adj_245 = {};
        wp::float32 adj_246 = {};
        wp::int32 adj_247 = {};
        wp::int32 adj_248 = {};
        wp::float32 adj_249 = {};
        wp::float32 adj_250 = {};
        wp::float32 adj_251 = {};
        wp::int32 adj_252 = {};
        wp::float32 adj_253 = {};
        wp::float32 adj_254 = {};
        wp::float32 adj_255 = {};
        wp::float32 adj_256 = {};
        wp::float32 adj_257 = {};
        wp::float32 adj_258 = {};
        wp::float32 adj_259 = {};
        wp::int32 adj_260 = {};
        wp::int32 adj_261 = {};
        wp::float32 adj_262 = {};
        wp::float32 adj_263 = {};
        wp::float32 adj_264 = {};
        wp::int32 adj_265 = {};
        wp::float32 adj_266 = {};
        wp::float32 adj_267 = {};
        wp::float32 adj_268 = {};
        wp::float32 adj_269 = {};
        wp::float32 adj_270 = {};
        wp::float32 adj_271 = {};
        wp::float32 adj_272 = {};
        wp::int32 adj_273 = {};
        wp::int32 adj_274 = {};
        wp::int32 adj_275 = {};
        wp::float32 adj_276 = {};
        wp::float32 adj_277 = {};
        wp::float32 adj_278 = {};
        wp::int32 adj_279 = {};
        wp::float32 adj_280 = {};
        wp::float32 adj_281 = {};
        wp::float32 adj_282 = {};
        wp::float32 adj_283 = {};
        wp::float32 adj_284 = {};
        wp::float32 adj_285 = {};
        wp::float32 adj_286 = {};
        wp::int32 adj_287 = {};
        wp::int32 adj_288 = {};
        wp::float32 adj_289 = {};
        wp::float32 adj_290 = {};
        wp::float32 adj_291 = {};
        wp::int32 adj_292 = {};
        wp::float32 adj_293 = {};
        wp::float32 adj_294 = {};
        wp::float32 adj_295 = {};
        wp::float32 adj_296 = {};
        wp::float32 adj_297 = {};
        wp::float32 adj_298 = {};
        wp::float32 adj_299 = {};
        wp::int32 adj_300 = {};
        wp::int32 adj_301 = {};
        wp::float32 adj_302 = {};
        wp::float32 adj_303 = {};
        wp::float32 adj_304 = {};
        wp::int32 adj_305 = {};
        wp::float32 adj_306 = {};
        wp::float32 adj_307 = {};
        wp::float32 adj_308 = {};
        wp::float32 adj_309 = {};
        wp::float32 adj_310 = {};
        wp::float32 adj_311 = {};
        wp::float32 adj_312 = {};
        wp::int32 adj_313 = {};
        wp::int32 adj_314 = {};
        wp::float32 adj_315 = {};
        wp::float32 adj_316 = {};
        wp::float32 adj_317 = {};
        wp::int32 adj_318 = {};
        wp::float32 adj_319 = {};
        wp::float32 adj_320 = {};
        wp::float32 adj_321 = {};
        wp::float32 adj_322 = {};
        wp::float32 adj_323 = {};
        wp::float32 adj_324 = {};
        wp::float32 adj_325 = {};
        wp::int32 adj_326 = {};
        wp::int32 adj_327 = {};
        wp::float32 adj_328 = {};
        wp::float32 adj_329 = {};
        wp::float32 adj_330 = {};
        wp::int32 adj_331 = {};
        wp::float32 adj_332 = {};
        wp::float32 adj_333 = {};
        wp::float32 adj_334 = {};
        wp::float32 adj_335 = {};
        wp::float32 adj_336 = {};
        wp::float32 adj_337 = {};
        wp::float32 adj_338 = {};
        wp::int32 adj_339 = {};
        wp::int32 adj_340 = {};
        wp::float32 adj_341 = {};
        wp::float32 adj_342 = {};
        wp::float32 adj_343 = {};
        wp::int32 adj_344 = {};
        wp::float32 adj_345 = {};
        wp::float32 adj_346 = {};
        wp::float32 adj_347 = {};
        wp::float32 adj_348 = {};
        wp::float32 adj_349 = {};
        wp::float32 adj_350 = {};
        wp::float32 adj_351 = {};
        wp::int32 adj_352 = {};
        wp::int32 adj_353 = {};
        wp::int32 adj_354 = {};
        wp::float32 adj_355 = {};
        wp::float32 adj_356 = {};
        wp::float32 adj_357 = {};
        wp::int32 adj_358 = {};
        wp::float32 adj_359 = {};
        wp::float32 adj_360 = {};
        wp::float32 adj_361 = {};
        wp::float32 adj_362 = {};
        wp::float32 adj_363 = {};
        wp::float32 adj_364 = {};
        wp::float32 adj_365 = {};
        wp::int32 adj_366 = {};
        wp::int32 adj_367 = {};
        wp::float32 adj_368 = {};
        wp::float32 adj_369 = {};
        wp::float32 adj_370 = {};
        wp::int32 adj_371 = {};
        wp::float32 adj_372 = {};
        wp::float32 adj_373 = {};
        wp::float32 adj_374 = {};
        wp::float32 adj_375 = {};
        wp::float32 adj_376 = {};
        wp::float32 adj_377 = {};
        wp::float32 adj_378 = {};
        wp::int32 adj_379 = {};
        wp::int32 adj_380 = {};
        wp::float32 adj_381 = {};
        wp::float32 adj_382 = {};
        wp::float32 adj_383 = {};
        wp::int32 adj_384 = {};
        wp::float32 adj_385 = {};
        wp::float32 adj_386 = {};
        wp::float32 adj_387 = {};
        wp::float32 adj_388 = {};
        wp::float32 adj_389 = {};
        wp::float32 adj_390 = {};
        wp::float32 adj_391 = {};
        wp::int32 adj_392 = {};
        wp::int32 adj_393 = {};
        wp::float32 adj_394 = {};
        wp::float32 adj_395 = {};
        wp::float32 adj_396 = {};
        wp::int32 adj_397 = {};
        wp::float32 adj_398 = {};
        wp::float32 adj_399 = {};
        wp::float32 adj_400 = {};
        wp::float32 adj_401 = {};
        wp::float32 adj_402 = {};
        wp::float32 adj_403 = {};
        wp::float32 adj_404 = {};
        wp::int32 adj_405 = {};
        wp::int32 adj_406 = {};
        wp::float32 adj_407 = {};
        wp::float32 adj_408 = {};
        wp::float32 adj_409 = {};
        wp::int32 adj_410 = {};
        wp::float32 adj_411 = {};
        wp::float32 adj_412 = {};
        wp::float32 adj_413 = {};
        wp::float32 adj_414 = {};
        wp::float32 adj_415 = {};
        wp::float32 adj_416 = {};
        wp::float32 adj_417 = {};
        wp::int32 adj_418 = {};
        wp::int32 adj_419 = {};
        wp::float32 adj_420 = {};
        wp::float32 adj_421 = {};
        wp::float32 adj_422 = {};
        wp::int32 adj_423 = {};
        wp::float32 adj_424 = {};
        wp::float32 adj_425 = {};
        wp::float32 adj_426 = {};
        wp::float32 adj_427 = {};
        wp::float32 adj_428 = {};
        wp::float32 adj_429 = {};
        wp::float32 adj_430 = {};
        wp::int32 adj_431 = {};
        wp::int32 adj_432 = {};
        wp::int32 adj_433 = {};
        wp::float32 adj_434 = {};
        wp::float32 adj_435 = {};
        wp::float32 adj_436 = {};
        wp::int32 adj_437 = {};
        wp::float32 adj_438 = {};
        wp::float32 adj_439 = {};
        wp::float32 adj_440 = {};
        wp::float32 adj_441 = {};
        wp::float32 adj_442 = {};
        wp::float32 adj_443 = {};
        wp::float32 adj_444 = {};
        wp::int32 adj_445 = {};
        wp::int32 adj_446 = {};
        wp::float32 adj_447 = {};
        wp::float32 adj_448 = {};
        wp::float32 adj_449 = {};
        wp::int32 adj_450 = {};
        wp::float32 adj_451 = {};
        wp::float32 adj_452 = {};
        wp::float32 adj_453 = {};
        wp::float32 adj_454 = {};
        wp::float32 adj_455 = {};
        wp::float32 adj_456 = {};
        wp::float32 adj_457 = {};
        wp::int32 adj_458 = {};
        wp::int32 adj_459 = {};
        wp::float32 adj_460 = {};
        wp::float32 adj_461 = {};
        wp::float32 adj_462 = {};
        wp::int32 adj_463 = {};
        wp::float32 adj_464 = {};
        wp::float32 adj_465 = {};
        wp::float32 adj_466 = {};
        wp::float32 adj_467 = {};
        wp::float32 adj_468 = {};
        wp::float32 adj_469 = {};
        wp::float32 adj_470 = {};
        wp::int32 adj_471 = {};
        wp::int32 adj_472 = {};
        wp::float32 adj_473 = {};
        wp::float32 adj_474 = {};
        wp::float32 adj_475 = {};
        wp::int32 adj_476 = {};
        wp::float32 adj_477 = {};
        wp::float32 adj_478 = {};
        wp::float32 adj_479 = {};
        wp::float32 adj_480 = {};
        wp::float32 adj_481 = {};
        wp::float32 adj_482 = {};
        wp::float32 adj_483 = {};
        wp::int32 adj_484 = {};
        wp::int32 adj_485 = {};
        wp::float32 adj_486 = {};
        wp::float32 adj_487 = {};
        wp::float32 adj_488 = {};
        wp::int32 adj_489 = {};
        wp::float32 adj_490 = {};
        wp::float32 adj_491 = {};
        wp::float32 adj_492 = {};
        wp::float32 adj_493 = {};
        wp::float32 adj_494 = {};
        wp::float32 adj_495 = {};
        wp::float32 adj_496 = {};
        wp::int32 adj_497 = {};
        wp::int32 adj_498 = {};
        wp::float32 adj_499 = {};
        wp::float32 adj_500 = {};
        wp::float32 adj_501 = {};
        wp::int32 adj_502 = {};
        wp::float32 adj_503 = {};
        wp::float32 adj_504 = {};
        wp::float32 adj_505 = {};
        wp::float32 adj_506 = {};
        wp::float32 adj_507 = {};
        wp::float32 adj_508 = {};
        wp::float32 adj_509 = {};
        wp::float32 adj_510 = {};
        wp::float32 adj_511 = {};
        wp::float32 adj_512 = {};
        //---------
        // forward
        // def eval_articulation_mass_matrix(                                                     <L 1320>
        // art_idx = wp.tid()                                                                     <L 1337>
        var_0 = builtin_tid1d();
        // if art_idx >= articulation_count:                                                      <L 1339>
        var_1 = (var_0 >= var_articulation_count);
        if (var_1) {
            // return                                                                             <L 1340>
            goto label0;
        }
        // if articulation_mask:                                                                  <L 1342>
        if (var_articulation_mask) {
            // if not articulation_mask[art_idx]:                                                 <L 1343>
            var_2 = wp::address(var_articulation_mask, var_0);
            var_4 = wp::load(var_2);
            var_3 = wp::unot(var_4);
            if (var_3) {
                // return                                                                         <L 1344>
                goto label1;
            }
        }
        // joint_start = articulation_start[art_idx]                                              <L 1346>
        var_5 = wp::address(var_articulation_start, var_0);
        var_7 = wp::load(var_5);
        var_6 = wp::copy(var_7);
        // joint_end = articulation_end[art_idx]                                                  <L 1347>
        var_8 = wp::address(var_articulation_end, var_0);
        var_10 = wp::load(var_8);
        var_9 = wp::copy(var_10);
        // joint_count = joint_end - joint_start                                                  <L 1348>
        var_11 = wp::sub(var_9, var_6);
        // articulation_dof_start = joint_qd_start[joint_start]                                   <L 1350>
        var_12 = wp::address(var_joint_qd_start, var_6);
        var_14 = wp::load(var_12);
        var_13 = wp::copy(var_14);
        // articulation_dof_end = joint_qd_start[joint_end]                                       <L 1351>
        var_15 = wp::address(var_joint_qd_start, var_9);
        var_17 = wp::load(var_15);
        var_16 = wp::copy(var_17);
        // articulation_dof_count = articulation_dof_end - articulation_dof_start                 <L 1352>
        var_18 = wp::sub(var_16, var_13);
        // for link_idx in range(joint_count):                                                    <L 1358>
        var_19 = wp::range(var_11);
        //---------
        // reverse
        var_19 = wp::iter_reverse(var_19);
        start_for_2:;
            if (iter_cmp(var_19) == 0) goto end_for_2;
            var_20 = wp::iter_next(var_19);
        	adj_21 = {};
        	adj_22 = {};
        	adj_23 = {};
        	adj_24 = {};
        	adj_25 = {};
        	adj_26 = {};
        	adj_27 = {};
        	adj_28 = {};
        	adj_29 = {};
        	adj_30 = {};
            // j = joint_start + link_idx                                                         <L 1359>
            var_21 = wp::add(var_6, var_20);
            // child = joint_child[j]                                                             <L 1360>
            var_22 = wp::address(var_joint_child, var_21);
            var_24 = wp::load(var_22);
            var_23 = wp::copy(var_24);
            // I_s = body_I_s[child]                                                              <L 1361>
            var_25 = wp::address(var_body_I_s, var_23);
            var_27 = wp::load(var_25);
            var_26 = wp::copy(var_27);
            // row_start = link_idx * 6                                                           <L 1363>
            var_29 = wp::mul(var_20, var_28);
            // for dof_i in range(articulation_dof_count):                                        <L 1366>
            var_30 = wp::range(var_18);
            var_30 = wp::iter_reverse(var_30);
            start_for_4:;
                if (iter_cmp(var_30) == 0) goto end_for_4;
                var_31 = wp::iter_next(var_30);
            	adj_32 = {};
                // for dof_j in range(articulation_dof_count):                                    <L 1367>
                var_32 = wp::range(var_18);
                var_32 = wp::iter_reverse(var_32);
                start_for_6:;
                    if (iter_cmp(var_32) == 0) goto end_for_6;
                    var_33 = wp::iter_next(var_32);
                	adj_34 = {};
                	adj_35 = {};
                	adj_36 = {};
                	adj_37 = {};
                	adj_38 = {};
                	adj_39 = {};
                	adj_40 = {};
                	adj_41 = {};
                	adj_42 = {};
                	adj_43 = {};
                	adj_44 = {};
                	adj_45 = {};
                	adj_46 = {};
                	adj_47 = {};
                	adj_48 = {};
                	adj_49 = {};
                	adj_50 = {};
                	adj_51 = {};
                	adj_52 = {};
                	adj_53 = {};
                	adj_54 = {};
                	adj_55 = {};
                	adj_56 = {};
                	adj_57 = {};
                	adj_58 = {};
                	adj_59 = {};
                	adj_60 = {};
                	adj_61 = {};
                	adj_62 = {};
                	adj_63 = {};
                	adj_64 = {};
                	adj_65 = {};
                	adj_66 = {};
                	adj_67 = {};
                	adj_68 = {};
                	adj_69 = {};
                	adj_70 = {};
                	adj_71 = {};
                	adj_72 = {};
                	adj_73 = {};
                	adj_74 = {};
                	adj_75 = {};
                	adj_76 = {};
                	adj_77 = {};
                	adj_78 = {};
                	adj_79 = {};
                	adj_80 = {};
                	adj_81 = {};
                	adj_82 = {};
                	adj_83 = {};
                	adj_84 = {};
                	adj_85 = {};
                	adj_86 = {};
                	adj_87 = {};
                	adj_88 = {};
                	adj_89 = {};
                	adj_90 = {};
                	adj_91 = {};
                	adj_92 = {};
                	adj_93 = {};
                	adj_94 = {};
                	adj_95 = {};
                	adj_96 = {};
                	adj_97 = {};
                	adj_98 = {};
                	adj_99 = {};
                	adj_100 = {};
                	adj_101 = {};
                	adj_102 = {};
                	adj_103 = {};
                	adj_104 = {};
                	adj_105 = {};
                	adj_106 = {};
                	adj_107 = {};
                	adj_108 = {};
                	adj_109 = {};
                	adj_110 = {};
                	adj_111 = {};
                	adj_112 = {};
                	adj_113 = {};
                	adj_114 = {};
                	adj_115 = {};
                	adj_116 = {};
                	adj_117 = {};
                	adj_118 = {};
                	adj_119 = {};
                	adj_120 = {};
                	adj_121 = {};
                	adj_122 = {};
                	adj_123 = {};
                	adj_124 = {};
                	adj_125 = {};
                	adj_126 = {};
                	adj_127 = {};
                	adj_128 = {};
                	adj_129 = {};
                	adj_130 = {};
                	adj_131 = {};
                	adj_132 = {};
                	adj_133 = {};
                	adj_134 = {};
                	adj_135 = {};
                	adj_136 = {};
                	adj_137 = {};
                	adj_138 = {};
                	adj_139 = {};
                	adj_140 = {};
                	adj_141 = {};
                	adj_142 = {};
                	adj_143 = {};
                	adj_144 = {};
                	adj_145 = {};
                	adj_146 = {};
                	adj_147 = {};
                	adj_148 = {};
                	adj_149 = {};
                	adj_150 = {};
                	adj_151 = {};
                	adj_152 = {};
                	adj_153 = {};
                	adj_154 = {};
                	adj_155 = {};
                	adj_156 = {};
                	adj_157 = {};
                	adj_158 = {};
                	adj_159 = {};
                	adj_160 = {};
                	adj_161 = {};
                	adj_162 = {};
                	adj_163 = {};
                	adj_164 = {};
                	adj_165 = {};
                	adj_166 = {};
                	adj_167 = {};
                	adj_168 = {};
                	adj_169 = {};
                	adj_170 = {};
                	adj_171 = {};
                	adj_172 = {};
                	adj_173 = {};
                	adj_174 = {};
                	adj_175 = {};
                	adj_176 = {};
                	adj_177 = {};
                	adj_178 = {};
                	adj_179 = {};
                	adj_180 = {};
                	adj_181 = {};
                	adj_182 = {};
                	adj_183 = {};
                	adj_184 = {};
                	adj_185 = {};
                	adj_186 = {};
                	adj_187 = {};
                	adj_188 = {};
                	adj_189 = {};
                	adj_190 = {};
                	adj_191 = {};
                	adj_192 = {};
                	adj_193 = {};
                	adj_194 = {};
                	adj_195 = {};
                	adj_196 = {};
                	adj_197 = {};
                	adj_198 = {};
                	adj_199 = {};
                	adj_200 = {};
                	adj_201 = {};
                	adj_202 = {};
                	adj_203 = {};
                	adj_204 = {};
                	adj_205 = {};
                	adj_206 = {};
                	adj_207 = {};
                	adj_208 = {};
                	adj_209 = {};
                	adj_210 = {};
                	adj_211 = {};
                	adj_212 = {};
                	adj_213 = {};
                	adj_214 = {};
                	adj_215 = {};
                	adj_216 = {};
                	adj_217 = {};
                	adj_218 = {};
                	adj_219 = {};
                	adj_220 = {};
                	adj_221 = {};
                	adj_222 = {};
                	adj_223 = {};
                	adj_224 = {};
                	adj_225 = {};
                	adj_226 = {};
                	adj_227 = {};
                	adj_228 = {};
                	adj_229 = {};
                	adj_230 = {};
                	adj_231 = {};
                	adj_232 = {};
                	adj_233 = {};
                	adj_234 = {};
                	adj_235 = {};
                	adj_236 = {};
                	adj_237 = {};
                	adj_238 = {};
                	adj_239 = {};
                	adj_240 = {};
                	adj_241 = {};
                	adj_242 = {};
                	adj_243 = {};
                	adj_244 = {};
                	adj_245 = {};
                	adj_246 = {};
                	adj_247 = {};
                	adj_248 = {};
                	adj_249 = {};
                	adj_250 = {};
                	adj_251 = {};
                	adj_252 = {};
                	adj_253 = {};
                	adj_254 = {};
                	adj_255 = {};
                	adj_256 = {};
                	adj_257 = {};
                	adj_258 = {};
                	adj_259 = {};
                	adj_260 = {};
                	adj_261 = {};
                	adj_262 = {};
                	adj_263 = {};
                	adj_264 = {};
                	adj_265 = {};
                	adj_266 = {};
                	adj_267 = {};
                	adj_268 = {};
                	adj_269 = {};
                	adj_270 = {};
                	adj_271 = {};
                	adj_272 = {};
                	adj_273 = {};
                	adj_274 = {};
                	adj_275 = {};
                	adj_276 = {};
                	adj_277 = {};
                	adj_278 = {};
                	adj_279 = {};
                	adj_280 = {};
                	adj_281 = {};
                	adj_282 = {};
                	adj_283 = {};
                	adj_284 = {};
                	adj_285 = {};
                	adj_286 = {};
                	adj_287 = {};
                	adj_288 = {};
                	adj_289 = {};
                	adj_290 = {};
                	adj_291 = {};
                	adj_292 = {};
                	adj_293 = {};
                	adj_294 = {};
                	adj_295 = {};
                	adj_296 = {};
                	adj_297 = {};
                	adj_298 = {};
                	adj_299 = {};
                	adj_300 = {};
                	adj_301 = {};
                	adj_302 = {};
                	adj_303 = {};
                	adj_304 = {};
                	adj_305 = {};
                	adj_306 = {};
                	adj_307 = {};
                	adj_308 = {};
                	adj_309 = {};
                	adj_310 = {};
                	adj_311 = {};
                	adj_312 = {};
                	adj_313 = {};
                	adj_314 = {};
                	adj_315 = {};
                	adj_316 = {};
                	adj_317 = {};
                	adj_318 = {};
                	adj_319 = {};
                	adj_320 = {};
                	adj_321 = {};
                	adj_322 = {};
                	adj_323 = {};
                	adj_324 = {};
                	adj_325 = {};
                	adj_326 = {};
                	adj_327 = {};
                	adj_328 = {};
                	adj_329 = {};
                	adj_330 = {};
                	adj_331 = {};
                	adj_332 = {};
                	adj_333 = {};
                	adj_334 = {};
                	adj_335 = {};
                	adj_336 = {};
                	adj_337 = {};
                	adj_338 = {};
                	adj_339 = {};
                	adj_340 = {};
                	adj_341 = {};
                	adj_342 = {};
                	adj_343 = {};
                	adj_344 = {};
                	adj_345 = {};
                	adj_346 = {};
                	adj_347 = {};
                	adj_348 = {};
                	adj_349 = {};
                	adj_350 = {};
                	adj_351 = {};
                	adj_352 = {};
                	adj_353 = {};
                	adj_354 = {};
                	adj_355 = {};
                	adj_356 = {};
                	adj_357 = {};
                	adj_358 = {};
                	adj_359 = {};
                	adj_360 = {};
                	adj_361 = {};
                	adj_362 = {};
                	adj_363 = {};
                	adj_364 = {};
                	adj_365 = {};
                	adj_366 = {};
                	adj_367 = {};
                	adj_368 = {};
                	adj_369 = {};
                	adj_370 = {};
                	adj_371 = {};
                	adj_372 = {};
                	adj_373 = {};
                	adj_374 = {};
                	adj_375 = {};
                	adj_376 = {};
                	adj_377 = {};
                	adj_378 = {};
                	adj_379 = {};
                	adj_380 = {};
                	adj_381 = {};
                	adj_382 = {};
                	adj_383 = {};
                	adj_384 = {};
                	adj_385 = {};
                	adj_386 = {};
                	adj_387 = {};
                	adj_388 = {};
                	adj_389 = {};
                	adj_390 = {};
                	adj_391 = {};
                	adj_392 = {};
                	adj_393 = {};
                	adj_394 = {};
                	adj_395 = {};
                	adj_396 = {};
                	adj_397 = {};
                	adj_398 = {};
                	adj_399 = {};
                	adj_400 = {};
                	adj_401 = {};
                	adj_402 = {};
                	adj_403 = {};
                	adj_404 = {};
                	adj_405 = {};
                	adj_406 = {};
                	adj_407 = {};
                	adj_408 = {};
                	adj_409 = {};
                	adj_410 = {};
                	adj_411 = {};
                	adj_412 = {};
                	adj_413 = {};
                	adj_414 = {};
                	adj_415 = {};
                	adj_416 = {};
                	adj_417 = {};
                	adj_418 = {};
                	adj_419 = {};
                	adj_420 = {};
                	adj_421 = {};
                	adj_422 = {};
                	adj_423 = {};
                	adj_424 = {};
                	adj_425 = {};
                	adj_426 = {};
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
                	adj_445 = {};
                	adj_446 = {};
                	adj_447 = {};
                	adj_448 = {};
                	adj_449 = {};
                	adj_450 = {};
                	adj_451 = {};
                	adj_452 = {};
                	adj_453 = {};
                	adj_454 = {};
                	adj_455 = {};
                	adj_456 = {};
                	adj_457 = {};
                	adj_458 = {};
                	adj_459 = {};
                	adj_460 = {};
                	adj_461 = {};
                	adj_462 = {};
                	adj_463 = {};
                	adj_464 = {};
                	adj_465 = {};
                	adj_466 = {};
                	adj_467 = {};
                	adj_468 = {};
                	adj_469 = {};
                	adj_470 = {};
                	adj_471 = {};
                	adj_472 = {};
                	adj_473 = {};
                	adj_474 = {};
                	adj_475 = {};
                	adj_476 = {};
                	adj_477 = {};
                	adj_478 = {};
                	adj_479 = {};
                	adj_480 = {};
                	adj_481 = {};
                	adj_482 = {};
                	adj_483 = {};
                	adj_484 = {};
                	adj_485 = {};
                	adj_486 = {};
                	adj_487 = {};
                	adj_488 = {};
                	adj_489 = {};
                	adj_490 = {};
                	adj_491 = {};
                	adj_492 = {};
                	adj_493 = {};
                	adj_494 = {};
                	adj_495 = {};
                	adj_496 = {};
                	adj_497 = {};
                	adj_498 = {};
                	adj_499 = {};
                	adj_500 = {};
                	adj_501 = {};
                	adj_502 = {};
                	adj_503 = {};
                	adj_504 = {};
                	adj_505 = {};
                	adj_506 = {};
                	adj_507 = {};
                	adj_508 = {};
                	adj_509 = {};
                	adj_510 = {};
                	adj_511 = {};
                	adj_512 = {};
                    // sum_val = float(0.0)                                                       <L 1368>
                    var_35 = wp::float(var_34);
                    // for k in range(6):                                                         <L 1371>
                    // for l in range(6):                                                         <L 1372>
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_38 = wp::add(var_29, var_36);
                    var_39 = wp::address(var_J, var_0, var_38, var_31);
                    var_41 = wp::load(var_39);
                    var_40 = wp::copy(var_41);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_42 = wp::add(var_29, var_37);
                    var_43 = wp::address(var_J, var_0, var_42, var_33);
                    var_45 = wp::load(var_43);
                    var_44 = wp::copy(var_45);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_46 = wp::extract(var_26, var_36, var_37);
                    var_47 = wp::mul(var_40, var_46);
                    var_48 = wp::mul(var_47, var_44);
                    var_49 = wp::add(var_35, var_48);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_51 = wp::add(var_29, var_36);
                    var_52 = wp::address(var_J, var_0, var_51, var_31);
                    var_54 = wp::load(var_52);
                    var_53 = wp::copy(var_54);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_55 = wp::add(var_29, var_50);
                    var_56 = wp::address(var_J, var_0, var_55, var_33);
                    var_58 = wp::load(var_56);
                    var_57 = wp::copy(var_58);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_59 = wp::extract(var_26, var_36, var_50);
                    var_60 = wp::mul(var_53, var_59);
                    var_61 = wp::mul(var_60, var_57);
                    var_62 = wp::add(var_49, var_61);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_64 = wp::add(var_29, var_36);
                    var_65 = wp::address(var_J, var_0, var_64, var_31);
                    var_67 = wp::load(var_65);
                    var_66 = wp::copy(var_67);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_68 = wp::add(var_29, var_63);
                    var_69 = wp::address(var_J, var_0, var_68, var_33);
                    var_71 = wp::load(var_69);
                    var_70 = wp::copy(var_71);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_72 = wp::extract(var_26, var_36, var_63);
                    var_73 = wp::mul(var_66, var_72);
                    var_74 = wp::mul(var_73, var_70);
                    var_75 = wp::add(var_62, var_74);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_77 = wp::add(var_29, var_36);
                    var_78 = wp::address(var_J, var_0, var_77, var_31);
                    var_80 = wp::load(var_78);
                    var_79 = wp::copy(var_80);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_81 = wp::add(var_29, var_76);
                    var_82 = wp::address(var_J, var_0, var_81, var_33);
                    var_84 = wp::load(var_82);
                    var_83 = wp::copy(var_84);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_85 = wp::extract(var_26, var_36, var_76);
                    var_86 = wp::mul(var_79, var_85);
                    var_87 = wp::mul(var_86, var_83);
                    var_88 = wp::add(var_75, var_87);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_90 = wp::add(var_29, var_36);
                    var_91 = wp::address(var_J, var_0, var_90, var_31);
                    var_93 = wp::load(var_91);
                    var_92 = wp::copy(var_93);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_94 = wp::add(var_29, var_89);
                    var_95 = wp::address(var_J, var_0, var_94, var_33);
                    var_97 = wp::load(var_95);
                    var_96 = wp::copy(var_97);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_98 = wp::extract(var_26, var_36, var_89);
                    var_99 = wp::mul(var_92, var_98);
                    var_100 = wp::mul(var_99, var_96);
                    var_101 = wp::add(var_88, var_100);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_103 = wp::add(var_29, var_36);
                    var_104 = wp::address(var_J, var_0, var_103, var_31);
                    var_106 = wp::load(var_104);
                    var_105 = wp::copy(var_106);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_107 = wp::add(var_29, var_102);
                    var_108 = wp::address(var_J, var_0, var_107, var_33);
                    var_110 = wp::load(var_108);
                    var_109 = wp::copy(var_110);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_111 = wp::extract(var_26, var_36, var_102);
                    var_112 = wp::mul(var_105, var_111);
                    var_113 = wp::mul(var_112, var_109);
                    var_114 = wp::add(var_101, var_113);
                    // for l in range(6):                                                         <L 1372>
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_117 = wp::add(var_29, var_115);
                    var_118 = wp::address(var_J, var_0, var_117, var_31);
                    var_120 = wp::load(var_118);
                    var_119 = wp::copy(var_120);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_121 = wp::add(var_29, var_116);
                    var_122 = wp::address(var_J, var_0, var_121, var_33);
                    var_124 = wp::load(var_122);
                    var_123 = wp::copy(var_124);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_125 = wp::extract(var_26, var_115, var_116);
                    var_126 = wp::mul(var_119, var_125);
                    var_127 = wp::mul(var_126, var_123);
                    var_128 = wp::add(var_114, var_127);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_130 = wp::add(var_29, var_115);
                    var_131 = wp::address(var_J, var_0, var_130, var_31);
                    var_133 = wp::load(var_131);
                    var_132 = wp::copy(var_133);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_134 = wp::add(var_29, var_129);
                    var_135 = wp::address(var_J, var_0, var_134, var_33);
                    var_137 = wp::load(var_135);
                    var_136 = wp::copy(var_137);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_138 = wp::extract(var_26, var_115, var_129);
                    var_139 = wp::mul(var_132, var_138);
                    var_140 = wp::mul(var_139, var_136);
                    var_141 = wp::add(var_128, var_140);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_143 = wp::add(var_29, var_115);
                    var_144 = wp::address(var_J, var_0, var_143, var_31);
                    var_146 = wp::load(var_144);
                    var_145 = wp::copy(var_146);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_147 = wp::add(var_29, var_142);
                    var_148 = wp::address(var_J, var_0, var_147, var_33);
                    var_150 = wp::load(var_148);
                    var_149 = wp::copy(var_150);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_151 = wp::extract(var_26, var_115, var_142);
                    var_152 = wp::mul(var_145, var_151);
                    var_153 = wp::mul(var_152, var_149);
                    var_154 = wp::add(var_141, var_153);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_156 = wp::add(var_29, var_115);
                    var_157 = wp::address(var_J, var_0, var_156, var_31);
                    var_159 = wp::load(var_157);
                    var_158 = wp::copy(var_159);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_160 = wp::add(var_29, var_155);
                    var_161 = wp::address(var_J, var_0, var_160, var_33);
                    var_163 = wp::load(var_161);
                    var_162 = wp::copy(var_163);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_164 = wp::extract(var_26, var_115, var_155);
                    var_165 = wp::mul(var_158, var_164);
                    var_166 = wp::mul(var_165, var_162);
                    var_167 = wp::add(var_154, var_166);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_169 = wp::add(var_29, var_115);
                    var_170 = wp::address(var_J, var_0, var_169, var_31);
                    var_172 = wp::load(var_170);
                    var_171 = wp::copy(var_172);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_173 = wp::add(var_29, var_168);
                    var_174 = wp::address(var_J, var_0, var_173, var_33);
                    var_176 = wp::load(var_174);
                    var_175 = wp::copy(var_176);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_177 = wp::extract(var_26, var_115, var_168);
                    var_178 = wp::mul(var_171, var_177);
                    var_179 = wp::mul(var_178, var_175);
                    var_180 = wp::add(var_167, var_179);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_182 = wp::add(var_29, var_115);
                    var_183 = wp::address(var_J, var_0, var_182, var_31);
                    var_185 = wp::load(var_183);
                    var_184 = wp::copy(var_185);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_186 = wp::add(var_29, var_181);
                    var_187 = wp::address(var_J, var_0, var_186, var_33);
                    var_189 = wp::load(var_187);
                    var_188 = wp::copy(var_189);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_190 = wp::extract(var_26, var_115, var_181);
                    var_191 = wp::mul(var_184, var_190);
                    var_192 = wp::mul(var_191, var_188);
                    var_193 = wp::add(var_180, var_192);
                    // for l in range(6):                                                         <L 1372>
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_196 = wp::add(var_29, var_194);
                    var_197 = wp::address(var_J, var_0, var_196, var_31);
                    var_199 = wp::load(var_197);
                    var_198 = wp::copy(var_199);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_200 = wp::add(var_29, var_195);
                    var_201 = wp::address(var_J, var_0, var_200, var_33);
                    var_203 = wp::load(var_201);
                    var_202 = wp::copy(var_203);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_204 = wp::extract(var_26, var_194, var_195);
                    var_205 = wp::mul(var_198, var_204);
                    var_206 = wp::mul(var_205, var_202);
                    var_207 = wp::add(var_193, var_206);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_209 = wp::add(var_29, var_194);
                    var_210 = wp::address(var_J, var_0, var_209, var_31);
                    var_212 = wp::load(var_210);
                    var_211 = wp::copy(var_212);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_213 = wp::add(var_29, var_208);
                    var_214 = wp::address(var_J, var_0, var_213, var_33);
                    var_216 = wp::load(var_214);
                    var_215 = wp::copy(var_216);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_217 = wp::extract(var_26, var_194, var_208);
                    var_218 = wp::mul(var_211, var_217);
                    var_219 = wp::mul(var_218, var_215);
                    var_220 = wp::add(var_207, var_219);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_222 = wp::add(var_29, var_194);
                    var_223 = wp::address(var_J, var_0, var_222, var_31);
                    var_225 = wp::load(var_223);
                    var_224 = wp::copy(var_225);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_226 = wp::add(var_29, var_221);
                    var_227 = wp::address(var_J, var_0, var_226, var_33);
                    var_229 = wp::load(var_227);
                    var_228 = wp::copy(var_229);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_230 = wp::extract(var_26, var_194, var_221);
                    var_231 = wp::mul(var_224, var_230);
                    var_232 = wp::mul(var_231, var_228);
                    var_233 = wp::add(var_220, var_232);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_235 = wp::add(var_29, var_194);
                    var_236 = wp::address(var_J, var_0, var_235, var_31);
                    var_238 = wp::load(var_236);
                    var_237 = wp::copy(var_238);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_239 = wp::add(var_29, var_234);
                    var_240 = wp::address(var_J, var_0, var_239, var_33);
                    var_242 = wp::load(var_240);
                    var_241 = wp::copy(var_242);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_243 = wp::extract(var_26, var_194, var_234);
                    var_244 = wp::mul(var_237, var_243);
                    var_245 = wp::mul(var_244, var_241);
                    var_246 = wp::add(var_233, var_245);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_248 = wp::add(var_29, var_194);
                    var_249 = wp::address(var_J, var_0, var_248, var_31);
                    var_251 = wp::load(var_249);
                    var_250 = wp::copy(var_251);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_252 = wp::add(var_29, var_247);
                    var_253 = wp::address(var_J, var_0, var_252, var_33);
                    var_255 = wp::load(var_253);
                    var_254 = wp::copy(var_255);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_256 = wp::extract(var_26, var_194, var_247);
                    var_257 = wp::mul(var_250, var_256);
                    var_258 = wp::mul(var_257, var_254);
                    var_259 = wp::add(var_246, var_258);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_261 = wp::add(var_29, var_194);
                    var_262 = wp::address(var_J, var_0, var_261, var_31);
                    var_264 = wp::load(var_262);
                    var_263 = wp::copy(var_264);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_265 = wp::add(var_29, var_260);
                    var_266 = wp::address(var_J, var_0, var_265, var_33);
                    var_268 = wp::load(var_266);
                    var_267 = wp::copy(var_268);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_269 = wp::extract(var_26, var_194, var_260);
                    var_270 = wp::mul(var_263, var_269);
                    var_271 = wp::mul(var_270, var_267);
                    var_272 = wp::add(var_259, var_271);
                    // for l in range(6):                                                         <L 1372>
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_275 = wp::add(var_29, var_273);
                    var_276 = wp::address(var_J, var_0, var_275, var_31);
                    var_278 = wp::load(var_276);
                    var_277 = wp::copy(var_278);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_279 = wp::add(var_29, var_274);
                    var_280 = wp::address(var_J, var_0, var_279, var_33);
                    var_282 = wp::load(var_280);
                    var_281 = wp::copy(var_282);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_283 = wp::extract(var_26, var_273, var_274);
                    var_284 = wp::mul(var_277, var_283);
                    var_285 = wp::mul(var_284, var_281);
                    var_286 = wp::add(var_272, var_285);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_288 = wp::add(var_29, var_273);
                    var_289 = wp::address(var_J, var_0, var_288, var_31);
                    var_291 = wp::load(var_289);
                    var_290 = wp::copy(var_291);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_292 = wp::add(var_29, var_287);
                    var_293 = wp::address(var_J, var_0, var_292, var_33);
                    var_295 = wp::load(var_293);
                    var_294 = wp::copy(var_295);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_296 = wp::extract(var_26, var_273, var_287);
                    var_297 = wp::mul(var_290, var_296);
                    var_298 = wp::mul(var_297, var_294);
                    var_299 = wp::add(var_286, var_298);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_301 = wp::add(var_29, var_273);
                    var_302 = wp::address(var_J, var_0, var_301, var_31);
                    var_304 = wp::load(var_302);
                    var_303 = wp::copy(var_304);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_305 = wp::add(var_29, var_300);
                    var_306 = wp::address(var_J, var_0, var_305, var_33);
                    var_308 = wp::load(var_306);
                    var_307 = wp::copy(var_308);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_309 = wp::extract(var_26, var_273, var_300);
                    var_310 = wp::mul(var_303, var_309);
                    var_311 = wp::mul(var_310, var_307);
                    var_312 = wp::add(var_299, var_311);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_314 = wp::add(var_29, var_273);
                    var_315 = wp::address(var_J, var_0, var_314, var_31);
                    var_317 = wp::load(var_315);
                    var_316 = wp::copy(var_317);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_318 = wp::add(var_29, var_313);
                    var_319 = wp::address(var_J, var_0, var_318, var_33);
                    var_321 = wp::load(var_319);
                    var_320 = wp::copy(var_321);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_322 = wp::extract(var_26, var_273, var_313);
                    var_323 = wp::mul(var_316, var_322);
                    var_324 = wp::mul(var_323, var_320);
                    var_325 = wp::add(var_312, var_324);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_327 = wp::add(var_29, var_273);
                    var_328 = wp::address(var_J, var_0, var_327, var_31);
                    var_330 = wp::load(var_328);
                    var_329 = wp::copy(var_330);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_331 = wp::add(var_29, var_326);
                    var_332 = wp::address(var_J, var_0, var_331, var_33);
                    var_334 = wp::load(var_332);
                    var_333 = wp::copy(var_334);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_335 = wp::extract(var_26, var_273, var_326);
                    var_336 = wp::mul(var_329, var_335);
                    var_337 = wp::mul(var_336, var_333);
                    var_338 = wp::add(var_325, var_337);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_340 = wp::add(var_29, var_273);
                    var_341 = wp::address(var_J, var_0, var_340, var_31);
                    var_343 = wp::load(var_341);
                    var_342 = wp::copy(var_343);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_344 = wp::add(var_29, var_339);
                    var_345 = wp::address(var_J, var_0, var_344, var_33);
                    var_347 = wp::load(var_345);
                    var_346 = wp::copy(var_347);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_348 = wp::extract(var_26, var_273, var_339);
                    var_349 = wp::mul(var_342, var_348);
                    var_350 = wp::mul(var_349, var_346);
                    var_351 = wp::add(var_338, var_350);
                    // for l in range(6):                                                         <L 1372>
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_354 = wp::add(var_29, var_352);
                    var_355 = wp::address(var_J, var_0, var_354, var_31);
                    var_357 = wp::load(var_355);
                    var_356 = wp::copy(var_357);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_358 = wp::add(var_29, var_353);
                    var_359 = wp::address(var_J, var_0, var_358, var_33);
                    var_361 = wp::load(var_359);
                    var_360 = wp::copy(var_361);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_362 = wp::extract(var_26, var_352, var_353);
                    var_363 = wp::mul(var_356, var_362);
                    var_364 = wp::mul(var_363, var_360);
                    var_365 = wp::add(var_351, var_364);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_367 = wp::add(var_29, var_352);
                    var_368 = wp::address(var_J, var_0, var_367, var_31);
                    var_370 = wp::load(var_368);
                    var_369 = wp::copy(var_370);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_371 = wp::add(var_29, var_366);
                    var_372 = wp::address(var_J, var_0, var_371, var_33);
                    var_374 = wp::load(var_372);
                    var_373 = wp::copy(var_374);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_375 = wp::extract(var_26, var_352, var_366);
                    var_376 = wp::mul(var_369, var_375);
                    var_377 = wp::mul(var_376, var_373);
                    var_378 = wp::add(var_365, var_377);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_380 = wp::add(var_29, var_352);
                    var_381 = wp::address(var_J, var_0, var_380, var_31);
                    var_383 = wp::load(var_381);
                    var_382 = wp::copy(var_383);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_384 = wp::add(var_29, var_379);
                    var_385 = wp::address(var_J, var_0, var_384, var_33);
                    var_387 = wp::load(var_385);
                    var_386 = wp::copy(var_387);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_388 = wp::extract(var_26, var_352, var_379);
                    var_389 = wp::mul(var_382, var_388);
                    var_390 = wp::mul(var_389, var_386);
                    var_391 = wp::add(var_378, var_390);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_393 = wp::add(var_29, var_352);
                    var_394 = wp::address(var_J, var_0, var_393, var_31);
                    var_396 = wp::load(var_394);
                    var_395 = wp::copy(var_396);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_397 = wp::add(var_29, var_392);
                    var_398 = wp::address(var_J, var_0, var_397, var_33);
                    var_400 = wp::load(var_398);
                    var_399 = wp::copy(var_400);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_401 = wp::extract(var_26, var_352, var_392);
                    var_402 = wp::mul(var_395, var_401);
                    var_403 = wp::mul(var_402, var_399);
                    var_404 = wp::add(var_391, var_403);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_406 = wp::add(var_29, var_352);
                    var_407 = wp::address(var_J, var_0, var_406, var_31);
                    var_409 = wp::load(var_407);
                    var_408 = wp::copy(var_409);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_410 = wp::add(var_29, var_405);
                    var_411 = wp::address(var_J, var_0, var_410, var_33);
                    var_413 = wp::load(var_411);
                    var_412 = wp::copy(var_413);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_414 = wp::extract(var_26, var_352, var_405);
                    var_415 = wp::mul(var_408, var_414);
                    var_416 = wp::mul(var_415, var_412);
                    var_417 = wp::add(var_404, var_416);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_419 = wp::add(var_29, var_352);
                    var_420 = wp::address(var_J, var_0, var_419, var_31);
                    var_422 = wp::load(var_420);
                    var_421 = wp::copy(var_422);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_423 = wp::add(var_29, var_418);
                    var_424 = wp::address(var_J, var_0, var_423, var_33);
                    var_426 = wp::load(var_424);
                    var_425 = wp::copy(var_426);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_427 = wp::extract(var_26, var_352, var_418);
                    var_428 = wp::mul(var_421, var_427);
                    var_429 = wp::mul(var_428, var_425);
                    var_430 = wp::add(var_417, var_429);
                    // for l in range(6):                                                         <L 1372>
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_433 = wp::add(var_29, var_431);
                    var_434 = wp::address(var_J, var_0, var_433, var_31);
                    var_436 = wp::load(var_434);
                    var_435 = wp::copy(var_436);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_437 = wp::add(var_29, var_432);
                    var_438 = wp::address(var_J, var_0, var_437, var_33);
                    var_440 = wp::load(var_438);
                    var_439 = wp::copy(var_440);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_441 = wp::extract(var_26, var_431, var_432);
                    var_442 = wp::mul(var_435, var_441);
                    var_443 = wp::mul(var_442, var_439);
                    var_444 = wp::add(var_430, var_443);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_446 = wp::add(var_29, var_431);
                    var_447 = wp::address(var_J, var_0, var_446, var_31);
                    var_449 = wp::load(var_447);
                    var_448 = wp::copy(var_449);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_450 = wp::add(var_29, var_445);
                    var_451 = wp::address(var_J, var_0, var_450, var_33);
                    var_453 = wp::load(var_451);
                    var_452 = wp::copy(var_453);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_454 = wp::extract(var_26, var_431, var_445);
                    var_455 = wp::mul(var_448, var_454);
                    var_456 = wp::mul(var_455, var_452);
                    var_457 = wp::add(var_444, var_456);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_459 = wp::add(var_29, var_431);
                    var_460 = wp::address(var_J, var_0, var_459, var_31);
                    var_462 = wp::load(var_460);
                    var_461 = wp::copy(var_462);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_463 = wp::add(var_29, var_458);
                    var_464 = wp::address(var_J, var_0, var_463, var_33);
                    var_466 = wp::load(var_464);
                    var_465 = wp::copy(var_466);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_467 = wp::extract(var_26, var_431, var_458);
                    var_468 = wp::mul(var_461, var_467);
                    var_469 = wp::mul(var_468, var_465);
                    var_470 = wp::add(var_457, var_469);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_472 = wp::add(var_29, var_431);
                    var_473 = wp::address(var_J, var_0, var_472, var_31);
                    var_475 = wp::load(var_473);
                    var_474 = wp::copy(var_475);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_476 = wp::add(var_29, var_471);
                    var_477 = wp::address(var_J, var_0, var_476, var_33);
                    var_479 = wp::load(var_477);
                    var_478 = wp::copy(var_479);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_480 = wp::extract(var_26, var_431, var_471);
                    var_481 = wp::mul(var_474, var_480);
                    var_482 = wp::mul(var_481, var_478);
                    var_483 = wp::add(var_470, var_482);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_485 = wp::add(var_29, var_431);
                    var_486 = wp::address(var_J, var_0, var_485, var_31);
                    var_488 = wp::load(var_486);
                    var_487 = wp::copy(var_488);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_489 = wp::add(var_29, var_484);
                    var_490 = wp::address(var_J, var_0, var_489, var_33);
                    var_492 = wp::load(var_490);
                    var_491 = wp::copy(var_492);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_493 = wp::extract(var_26, var_431, var_484);
                    var_494 = wp::mul(var_487, var_493);
                    var_495 = wp::mul(var_494, var_491);
                    var_496 = wp::add(var_483, var_495);
                    // J_ik = J[art_idx, row_start + k, dof_i]                                    <L 1373>
                    var_498 = wp::add(var_29, var_431);
                    var_499 = wp::address(var_J, var_0, var_498, var_31);
                    var_501 = wp::load(var_499);
                    var_500 = wp::copy(var_501);
                    // J_jl = J[art_idx, row_start + l, dof_j]                                    <L 1374>
                    var_502 = wp::add(var_29, var_497);
                    var_503 = wp::address(var_J, var_0, var_502, var_33);
                    var_505 = wp::load(var_503);
                    var_504 = wp::copy(var_505);
                    // sum_val += J_ik * I_s[k, l] * J_jl                                         <L 1375>
                    var_506 = wp::extract(var_26, var_431, var_497);
                    var_507 = wp::mul(var_500, var_506);
                    var_508 = wp::mul(var_507, var_504);
                    var_509 = wp::add(var_496, var_508);
                    // H[art_idx, dof_i, dof_j] = H[art_idx, dof_i, dof_j] + sum_val              <L 1377>
                    var_510 = wp::address(var_H, var_0, var_31, var_33);
                    var_512 = wp::load(var_510);
                    var_511 = wp::add(var_512, var_509);
                    // wp::array_store(var_H, var_0, var_31, var_33, var_511);
                    wp::adj_array_store(var_H, var_0, var_31, var_33, var_511, adj_H, adj_0, adj_31, adj_33, adj_511);
                    wp::adj_add(var_512, var_509, adj_510, adj_509, adj_511);
                    wp::adj_address(var_H, var_0, var_31, var_33, adj_H, adj_0, adj_31, adj_33, adj_510);
                    // adj: H[art_idx, dof_i, dof_j] = H[art_idx, dof_i, dof_j] + sum_val         <L 1377>
                    wp::adj_add(var_496, var_508, adj_496, adj_508, adj_509);
                    wp::adj_mul(var_507, var_504, adj_507, adj_504, adj_508);
                    wp::adj_mul(var_500, var_506, adj_500, adj_506, adj_507);
                    wp::adj_extract(var_26, var_431, var_497, adj_26, adj_431, adj_497, adj_506);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_505, adj_503, adj_504);
                    wp::adj_address(var_J, var_0, var_502, var_33, adj_J, adj_0, adj_502, adj_33, adj_503);
                    wp::adj_add(var_29, var_497, adj_29, adj_497, adj_502);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_501, adj_499, adj_500);
                    wp::adj_address(var_J, var_0, var_498, var_31, adj_J, adj_0, adj_498, adj_31, adj_499);
                    wp::adj_add(var_29, var_431, adj_29, adj_431, adj_498);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_483, var_495, adj_483, adj_495, adj_496);
                    wp::adj_mul(var_494, var_491, adj_494, adj_491, adj_495);
                    wp::adj_mul(var_487, var_493, adj_487, adj_493, adj_494);
                    wp::adj_extract(var_26, var_431, var_484, adj_26, adj_431, adj_484, adj_493);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_492, adj_490, adj_491);
                    wp::adj_address(var_J, var_0, var_489, var_33, adj_J, adj_0, adj_489, adj_33, adj_490);
                    wp::adj_add(var_29, var_484, adj_29, adj_484, adj_489);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_488, adj_486, adj_487);
                    wp::adj_address(var_J, var_0, var_485, var_31, adj_J, adj_0, adj_485, adj_31, adj_486);
                    wp::adj_add(var_29, var_431, adj_29, adj_431, adj_485);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_470, var_482, adj_470, adj_482, adj_483);
                    wp::adj_mul(var_481, var_478, adj_481, adj_478, adj_482);
                    wp::adj_mul(var_474, var_480, adj_474, adj_480, adj_481);
                    wp::adj_extract(var_26, var_431, var_471, adj_26, adj_431, adj_471, adj_480);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_479, adj_477, adj_478);
                    wp::adj_address(var_J, var_0, var_476, var_33, adj_J, adj_0, adj_476, adj_33, adj_477);
                    wp::adj_add(var_29, var_471, adj_29, adj_471, adj_476);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_475, adj_473, adj_474);
                    wp::adj_address(var_J, var_0, var_472, var_31, adj_J, adj_0, adj_472, adj_31, adj_473);
                    wp::adj_add(var_29, var_431, adj_29, adj_431, adj_472);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_457, var_469, adj_457, adj_469, adj_470);
                    wp::adj_mul(var_468, var_465, adj_468, adj_465, adj_469);
                    wp::adj_mul(var_461, var_467, adj_461, adj_467, adj_468);
                    wp::adj_extract(var_26, var_431, var_458, adj_26, adj_431, adj_458, adj_467);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_466, adj_464, adj_465);
                    wp::adj_address(var_J, var_0, var_463, var_33, adj_J, adj_0, adj_463, adj_33, adj_464);
                    wp::adj_add(var_29, var_458, adj_29, adj_458, adj_463);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_462, adj_460, adj_461);
                    wp::adj_address(var_J, var_0, var_459, var_31, adj_J, adj_0, adj_459, adj_31, adj_460);
                    wp::adj_add(var_29, var_431, adj_29, adj_431, adj_459);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_444, var_456, adj_444, adj_456, adj_457);
                    wp::adj_mul(var_455, var_452, adj_455, adj_452, adj_456);
                    wp::adj_mul(var_448, var_454, adj_448, adj_454, adj_455);
                    wp::adj_extract(var_26, var_431, var_445, adj_26, adj_431, adj_445, adj_454);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_453, adj_451, adj_452);
                    wp::adj_address(var_J, var_0, var_450, var_33, adj_J, adj_0, adj_450, adj_33, adj_451);
                    wp::adj_add(var_29, var_445, adj_29, adj_445, adj_450);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_449, adj_447, adj_448);
                    wp::adj_address(var_J, var_0, var_446, var_31, adj_J, adj_0, adj_446, adj_31, adj_447);
                    wp::adj_add(var_29, var_431, adj_29, adj_431, adj_446);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_430, var_443, adj_430, adj_443, adj_444);
                    wp::adj_mul(var_442, var_439, adj_442, adj_439, adj_443);
                    wp::adj_mul(var_435, var_441, adj_435, adj_441, adj_442);
                    wp::adj_extract(var_26, var_431, var_432, adj_26, adj_431, adj_432, adj_441);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_440, adj_438, adj_439);
                    wp::adj_address(var_J, var_0, var_437, var_33, adj_J, adj_0, adj_437, adj_33, adj_438);
                    wp::adj_add(var_29, var_432, adj_29, adj_432, adj_437);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_436, adj_434, adj_435);
                    wp::adj_address(var_J, var_0, var_433, var_31, adj_J, adj_0, adj_433, adj_31, adj_434);
                    wp::adj_add(var_29, var_431, adj_29, adj_431, adj_433);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    // adj: for l in range(6):                                                    <L 1372>
                    wp::adj_add(var_417, var_429, adj_417, adj_429, adj_430);
                    wp::adj_mul(var_428, var_425, adj_428, adj_425, adj_429);
                    wp::adj_mul(var_421, var_427, adj_421, adj_427, adj_428);
                    wp::adj_extract(var_26, var_352, var_418, adj_26, adj_352, adj_418, adj_427);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_426, adj_424, adj_425);
                    wp::adj_address(var_J, var_0, var_423, var_33, adj_J, adj_0, adj_423, adj_33, adj_424);
                    wp::adj_add(var_29, var_418, adj_29, adj_418, adj_423);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_422, adj_420, adj_421);
                    wp::adj_address(var_J, var_0, var_419, var_31, adj_J, adj_0, adj_419, adj_31, adj_420);
                    wp::adj_add(var_29, var_352, adj_29, adj_352, adj_419);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_404, var_416, adj_404, adj_416, adj_417);
                    wp::adj_mul(var_415, var_412, adj_415, adj_412, adj_416);
                    wp::adj_mul(var_408, var_414, adj_408, adj_414, adj_415);
                    wp::adj_extract(var_26, var_352, var_405, adj_26, adj_352, adj_405, adj_414);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_413, adj_411, adj_412);
                    wp::adj_address(var_J, var_0, var_410, var_33, adj_J, adj_0, adj_410, adj_33, adj_411);
                    wp::adj_add(var_29, var_405, adj_29, adj_405, adj_410);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_409, adj_407, adj_408);
                    wp::adj_address(var_J, var_0, var_406, var_31, adj_J, adj_0, adj_406, adj_31, adj_407);
                    wp::adj_add(var_29, var_352, adj_29, adj_352, adj_406);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_391, var_403, adj_391, adj_403, adj_404);
                    wp::adj_mul(var_402, var_399, adj_402, adj_399, adj_403);
                    wp::adj_mul(var_395, var_401, adj_395, adj_401, adj_402);
                    wp::adj_extract(var_26, var_352, var_392, adj_26, adj_352, adj_392, adj_401);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_400, adj_398, adj_399);
                    wp::adj_address(var_J, var_0, var_397, var_33, adj_J, adj_0, adj_397, adj_33, adj_398);
                    wp::adj_add(var_29, var_392, adj_29, adj_392, adj_397);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_396, adj_394, adj_395);
                    wp::adj_address(var_J, var_0, var_393, var_31, adj_J, adj_0, adj_393, adj_31, adj_394);
                    wp::adj_add(var_29, var_352, adj_29, adj_352, adj_393);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_378, var_390, adj_378, adj_390, adj_391);
                    wp::adj_mul(var_389, var_386, adj_389, adj_386, adj_390);
                    wp::adj_mul(var_382, var_388, adj_382, adj_388, adj_389);
                    wp::adj_extract(var_26, var_352, var_379, adj_26, adj_352, adj_379, adj_388);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_387, adj_385, adj_386);
                    wp::adj_address(var_J, var_0, var_384, var_33, adj_J, adj_0, adj_384, adj_33, adj_385);
                    wp::adj_add(var_29, var_379, adj_29, adj_379, adj_384);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_383, adj_381, adj_382);
                    wp::adj_address(var_J, var_0, var_380, var_31, adj_J, adj_0, adj_380, adj_31, adj_381);
                    wp::adj_add(var_29, var_352, adj_29, adj_352, adj_380);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_365, var_377, adj_365, adj_377, adj_378);
                    wp::adj_mul(var_376, var_373, adj_376, adj_373, adj_377);
                    wp::adj_mul(var_369, var_375, adj_369, adj_375, adj_376);
                    wp::adj_extract(var_26, var_352, var_366, adj_26, adj_352, adj_366, adj_375);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_374, adj_372, adj_373);
                    wp::adj_address(var_J, var_0, var_371, var_33, adj_J, adj_0, adj_371, adj_33, adj_372);
                    wp::adj_add(var_29, var_366, adj_29, adj_366, adj_371);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_370, adj_368, adj_369);
                    wp::adj_address(var_J, var_0, var_367, var_31, adj_J, adj_0, adj_367, adj_31, adj_368);
                    wp::adj_add(var_29, var_352, adj_29, adj_352, adj_367);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_351, var_364, adj_351, adj_364, adj_365);
                    wp::adj_mul(var_363, var_360, adj_363, adj_360, adj_364);
                    wp::adj_mul(var_356, var_362, adj_356, adj_362, adj_363);
                    wp::adj_extract(var_26, var_352, var_353, adj_26, adj_352, adj_353, adj_362);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_361, adj_359, adj_360);
                    wp::adj_address(var_J, var_0, var_358, var_33, adj_J, adj_0, adj_358, adj_33, adj_359);
                    wp::adj_add(var_29, var_353, adj_29, adj_353, adj_358);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_357, adj_355, adj_356);
                    wp::adj_address(var_J, var_0, var_354, var_31, adj_J, adj_0, adj_354, adj_31, adj_355);
                    wp::adj_add(var_29, var_352, adj_29, adj_352, adj_354);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    // adj: for l in range(6):                                                    <L 1372>
                    wp::adj_add(var_338, var_350, adj_338, adj_350, adj_351);
                    wp::adj_mul(var_349, var_346, adj_349, adj_346, adj_350);
                    wp::adj_mul(var_342, var_348, adj_342, adj_348, adj_349);
                    wp::adj_extract(var_26, var_273, var_339, adj_26, adj_273, adj_339, adj_348);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_347, adj_345, adj_346);
                    wp::adj_address(var_J, var_0, var_344, var_33, adj_J, adj_0, adj_344, adj_33, adj_345);
                    wp::adj_add(var_29, var_339, adj_29, adj_339, adj_344);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_343, adj_341, adj_342);
                    wp::adj_address(var_J, var_0, var_340, var_31, adj_J, adj_0, adj_340, adj_31, adj_341);
                    wp::adj_add(var_29, var_273, adj_29, adj_273, adj_340);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_325, var_337, adj_325, adj_337, adj_338);
                    wp::adj_mul(var_336, var_333, adj_336, adj_333, adj_337);
                    wp::adj_mul(var_329, var_335, adj_329, adj_335, adj_336);
                    wp::adj_extract(var_26, var_273, var_326, adj_26, adj_273, adj_326, adj_335);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_334, adj_332, adj_333);
                    wp::adj_address(var_J, var_0, var_331, var_33, adj_J, adj_0, adj_331, adj_33, adj_332);
                    wp::adj_add(var_29, var_326, adj_29, adj_326, adj_331);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_330, adj_328, adj_329);
                    wp::adj_address(var_J, var_0, var_327, var_31, adj_J, adj_0, adj_327, adj_31, adj_328);
                    wp::adj_add(var_29, var_273, adj_29, adj_273, adj_327);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_312, var_324, adj_312, adj_324, adj_325);
                    wp::adj_mul(var_323, var_320, adj_323, adj_320, adj_324);
                    wp::adj_mul(var_316, var_322, adj_316, adj_322, adj_323);
                    wp::adj_extract(var_26, var_273, var_313, adj_26, adj_273, adj_313, adj_322);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_321, adj_319, adj_320);
                    wp::adj_address(var_J, var_0, var_318, var_33, adj_J, adj_0, adj_318, adj_33, adj_319);
                    wp::adj_add(var_29, var_313, adj_29, adj_313, adj_318);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_317, adj_315, adj_316);
                    wp::adj_address(var_J, var_0, var_314, var_31, adj_J, adj_0, adj_314, adj_31, adj_315);
                    wp::adj_add(var_29, var_273, adj_29, adj_273, adj_314);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_299, var_311, adj_299, adj_311, adj_312);
                    wp::adj_mul(var_310, var_307, adj_310, adj_307, adj_311);
                    wp::adj_mul(var_303, var_309, adj_303, adj_309, adj_310);
                    wp::adj_extract(var_26, var_273, var_300, adj_26, adj_273, adj_300, adj_309);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_308, adj_306, adj_307);
                    wp::adj_address(var_J, var_0, var_305, var_33, adj_J, adj_0, adj_305, adj_33, adj_306);
                    wp::adj_add(var_29, var_300, adj_29, adj_300, adj_305);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_304, adj_302, adj_303);
                    wp::adj_address(var_J, var_0, var_301, var_31, adj_J, adj_0, adj_301, adj_31, adj_302);
                    wp::adj_add(var_29, var_273, adj_29, adj_273, adj_301);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_286, var_298, adj_286, adj_298, adj_299);
                    wp::adj_mul(var_297, var_294, adj_297, adj_294, adj_298);
                    wp::adj_mul(var_290, var_296, adj_290, adj_296, adj_297);
                    wp::adj_extract(var_26, var_273, var_287, adj_26, adj_273, adj_287, adj_296);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_295, adj_293, adj_294);
                    wp::adj_address(var_J, var_0, var_292, var_33, adj_J, adj_0, adj_292, adj_33, adj_293);
                    wp::adj_add(var_29, var_287, adj_29, adj_287, adj_292);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_291, adj_289, adj_290);
                    wp::adj_address(var_J, var_0, var_288, var_31, adj_J, adj_0, adj_288, adj_31, adj_289);
                    wp::adj_add(var_29, var_273, adj_29, adj_273, adj_288);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_272, var_285, adj_272, adj_285, adj_286);
                    wp::adj_mul(var_284, var_281, adj_284, adj_281, adj_285);
                    wp::adj_mul(var_277, var_283, adj_277, adj_283, adj_284);
                    wp::adj_extract(var_26, var_273, var_274, adj_26, adj_273, adj_274, adj_283);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_282, adj_280, adj_281);
                    wp::adj_address(var_J, var_0, var_279, var_33, adj_J, adj_0, adj_279, adj_33, adj_280);
                    wp::adj_add(var_29, var_274, adj_29, adj_274, adj_279);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_278, adj_276, adj_277);
                    wp::adj_address(var_J, var_0, var_275, var_31, adj_J, adj_0, adj_275, adj_31, adj_276);
                    wp::adj_add(var_29, var_273, adj_29, adj_273, adj_275);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    // adj: for l in range(6):                                                    <L 1372>
                    wp::adj_add(var_259, var_271, adj_259, adj_271, adj_272);
                    wp::adj_mul(var_270, var_267, adj_270, adj_267, adj_271);
                    wp::adj_mul(var_263, var_269, adj_263, adj_269, adj_270);
                    wp::adj_extract(var_26, var_194, var_260, adj_26, adj_194, adj_260, adj_269);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_268, adj_266, adj_267);
                    wp::adj_address(var_J, var_0, var_265, var_33, adj_J, adj_0, adj_265, adj_33, adj_266);
                    wp::adj_add(var_29, var_260, adj_29, adj_260, adj_265);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_264, adj_262, adj_263);
                    wp::adj_address(var_J, var_0, var_261, var_31, adj_J, adj_0, adj_261, adj_31, adj_262);
                    wp::adj_add(var_29, var_194, adj_29, adj_194, adj_261);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_246, var_258, adj_246, adj_258, adj_259);
                    wp::adj_mul(var_257, var_254, adj_257, adj_254, adj_258);
                    wp::adj_mul(var_250, var_256, adj_250, adj_256, adj_257);
                    wp::adj_extract(var_26, var_194, var_247, adj_26, adj_194, adj_247, adj_256);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_255, adj_253, adj_254);
                    wp::adj_address(var_J, var_0, var_252, var_33, adj_J, adj_0, adj_252, adj_33, adj_253);
                    wp::adj_add(var_29, var_247, adj_29, adj_247, adj_252);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_251, adj_249, adj_250);
                    wp::adj_address(var_J, var_0, var_248, var_31, adj_J, adj_0, adj_248, adj_31, adj_249);
                    wp::adj_add(var_29, var_194, adj_29, adj_194, adj_248);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_233, var_245, adj_233, adj_245, adj_246);
                    wp::adj_mul(var_244, var_241, adj_244, adj_241, adj_245);
                    wp::adj_mul(var_237, var_243, adj_237, adj_243, adj_244);
                    wp::adj_extract(var_26, var_194, var_234, adj_26, adj_194, adj_234, adj_243);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_242, adj_240, adj_241);
                    wp::adj_address(var_J, var_0, var_239, var_33, adj_J, adj_0, adj_239, adj_33, adj_240);
                    wp::adj_add(var_29, var_234, adj_29, adj_234, adj_239);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_238, adj_236, adj_237);
                    wp::adj_address(var_J, var_0, var_235, var_31, adj_J, adj_0, adj_235, adj_31, adj_236);
                    wp::adj_add(var_29, var_194, adj_29, adj_194, adj_235);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_220, var_232, adj_220, adj_232, adj_233);
                    wp::adj_mul(var_231, var_228, adj_231, adj_228, adj_232);
                    wp::adj_mul(var_224, var_230, adj_224, adj_230, adj_231);
                    wp::adj_extract(var_26, var_194, var_221, adj_26, adj_194, adj_221, adj_230);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_229, adj_227, adj_228);
                    wp::adj_address(var_J, var_0, var_226, var_33, adj_J, adj_0, adj_226, adj_33, adj_227);
                    wp::adj_add(var_29, var_221, adj_29, adj_221, adj_226);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_225, adj_223, adj_224);
                    wp::adj_address(var_J, var_0, var_222, var_31, adj_J, adj_0, adj_222, adj_31, adj_223);
                    wp::adj_add(var_29, var_194, adj_29, adj_194, adj_222);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_207, var_219, adj_207, adj_219, adj_220);
                    wp::adj_mul(var_218, var_215, adj_218, adj_215, adj_219);
                    wp::adj_mul(var_211, var_217, adj_211, adj_217, adj_218);
                    wp::adj_extract(var_26, var_194, var_208, adj_26, adj_194, adj_208, adj_217);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_216, adj_214, adj_215);
                    wp::adj_address(var_J, var_0, var_213, var_33, adj_J, adj_0, adj_213, adj_33, adj_214);
                    wp::adj_add(var_29, var_208, adj_29, adj_208, adj_213);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_212, adj_210, adj_211);
                    wp::adj_address(var_J, var_0, var_209, var_31, adj_J, adj_0, adj_209, adj_31, adj_210);
                    wp::adj_add(var_29, var_194, adj_29, adj_194, adj_209);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_193, var_206, adj_193, adj_206, adj_207);
                    wp::adj_mul(var_205, var_202, adj_205, adj_202, adj_206);
                    wp::adj_mul(var_198, var_204, adj_198, adj_204, adj_205);
                    wp::adj_extract(var_26, var_194, var_195, adj_26, adj_194, adj_195, adj_204);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_203, adj_201, adj_202);
                    wp::adj_address(var_J, var_0, var_200, var_33, adj_J, adj_0, adj_200, adj_33, adj_201);
                    wp::adj_add(var_29, var_195, adj_29, adj_195, adj_200);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_199, adj_197, adj_198);
                    wp::adj_address(var_J, var_0, var_196, var_31, adj_J, adj_0, adj_196, adj_31, adj_197);
                    wp::adj_add(var_29, var_194, adj_29, adj_194, adj_196);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    // adj: for l in range(6):                                                    <L 1372>
                    wp::adj_add(var_180, var_192, adj_180, adj_192, adj_193);
                    wp::adj_mul(var_191, var_188, adj_191, adj_188, adj_192);
                    wp::adj_mul(var_184, var_190, adj_184, adj_190, adj_191);
                    wp::adj_extract(var_26, var_115, var_181, adj_26, adj_115, adj_181, adj_190);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_189, adj_187, adj_188);
                    wp::adj_address(var_J, var_0, var_186, var_33, adj_J, adj_0, adj_186, adj_33, adj_187);
                    wp::adj_add(var_29, var_181, adj_29, adj_181, adj_186);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_185, adj_183, adj_184);
                    wp::adj_address(var_J, var_0, var_182, var_31, adj_J, adj_0, adj_182, adj_31, adj_183);
                    wp::adj_add(var_29, var_115, adj_29, adj_115, adj_182);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_167, var_179, adj_167, adj_179, adj_180);
                    wp::adj_mul(var_178, var_175, adj_178, adj_175, adj_179);
                    wp::adj_mul(var_171, var_177, adj_171, adj_177, adj_178);
                    wp::adj_extract(var_26, var_115, var_168, adj_26, adj_115, adj_168, adj_177);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_176, adj_174, adj_175);
                    wp::adj_address(var_J, var_0, var_173, var_33, adj_J, adj_0, adj_173, adj_33, adj_174);
                    wp::adj_add(var_29, var_168, adj_29, adj_168, adj_173);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_172, adj_170, adj_171);
                    wp::adj_address(var_J, var_0, var_169, var_31, adj_J, adj_0, adj_169, adj_31, adj_170);
                    wp::adj_add(var_29, var_115, adj_29, adj_115, adj_169);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_154, var_166, adj_154, adj_166, adj_167);
                    wp::adj_mul(var_165, var_162, adj_165, adj_162, adj_166);
                    wp::adj_mul(var_158, var_164, adj_158, adj_164, adj_165);
                    wp::adj_extract(var_26, var_115, var_155, adj_26, adj_115, adj_155, adj_164);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_163, adj_161, adj_162);
                    wp::adj_address(var_J, var_0, var_160, var_33, adj_J, adj_0, adj_160, adj_33, adj_161);
                    wp::adj_add(var_29, var_155, adj_29, adj_155, adj_160);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_159, adj_157, adj_158);
                    wp::adj_address(var_J, var_0, var_156, var_31, adj_J, adj_0, adj_156, adj_31, adj_157);
                    wp::adj_add(var_29, var_115, adj_29, adj_115, adj_156);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_141, var_153, adj_141, adj_153, adj_154);
                    wp::adj_mul(var_152, var_149, adj_152, adj_149, adj_153);
                    wp::adj_mul(var_145, var_151, adj_145, adj_151, adj_152);
                    wp::adj_extract(var_26, var_115, var_142, adj_26, adj_115, adj_142, adj_151);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_150, adj_148, adj_149);
                    wp::adj_address(var_J, var_0, var_147, var_33, adj_J, adj_0, adj_147, adj_33, adj_148);
                    wp::adj_add(var_29, var_142, adj_29, adj_142, adj_147);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_146, adj_144, adj_145);
                    wp::adj_address(var_J, var_0, var_143, var_31, adj_J, adj_0, adj_143, adj_31, adj_144);
                    wp::adj_add(var_29, var_115, adj_29, adj_115, adj_143);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_128, var_140, adj_128, adj_140, adj_141);
                    wp::adj_mul(var_139, var_136, adj_139, adj_136, adj_140);
                    wp::adj_mul(var_132, var_138, adj_132, adj_138, adj_139);
                    wp::adj_extract(var_26, var_115, var_129, adj_26, adj_115, adj_129, adj_138);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_137, adj_135, adj_136);
                    wp::adj_address(var_J, var_0, var_134, var_33, adj_J, adj_0, adj_134, adj_33, adj_135);
                    wp::adj_add(var_29, var_129, adj_29, adj_129, adj_134);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_133, adj_131, adj_132);
                    wp::adj_address(var_J, var_0, var_130, var_31, adj_J, adj_0, adj_130, adj_31, adj_131);
                    wp::adj_add(var_29, var_115, adj_29, adj_115, adj_130);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_114, var_127, adj_114, adj_127, adj_128);
                    wp::adj_mul(var_126, var_123, adj_126, adj_123, adj_127);
                    wp::adj_mul(var_119, var_125, adj_119, adj_125, adj_126);
                    wp::adj_extract(var_26, var_115, var_116, adj_26, adj_115, adj_116, adj_125);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_124, adj_122, adj_123);
                    wp::adj_address(var_J, var_0, var_121, var_33, adj_J, adj_0, adj_121, adj_33, adj_122);
                    wp::adj_add(var_29, var_116, adj_29, adj_116, adj_121);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_120, adj_118, adj_119);
                    wp::adj_address(var_J, var_0, var_117, var_31, adj_J, adj_0, adj_117, adj_31, adj_118);
                    wp::adj_add(var_29, var_115, adj_29, adj_115, adj_117);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    // adj: for l in range(6):                                                    <L 1372>
                    wp::adj_add(var_101, var_113, adj_101, adj_113, adj_114);
                    wp::adj_mul(var_112, var_109, adj_112, adj_109, adj_113);
                    wp::adj_mul(var_105, var_111, adj_105, adj_111, adj_112);
                    wp::adj_extract(var_26, var_36, var_102, adj_26, adj_36, adj_102, adj_111);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_110, adj_108, adj_109);
                    wp::adj_address(var_J, var_0, var_107, var_33, adj_J, adj_0, adj_107, adj_33, adj_108);
                    wp::adj_add(var_29, var_102, adj_29, adj_102, adj_107);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_106, adj_104, adj_105);
                    wp::adj_address(var_J, var_0, var_103, var_31, adj_J, adj_0, adj_103, adj_31, adj_104);
                    wp::adj_add(var_29, var_36, adj_29, adj_36, adj_103);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_88, var_100, adj_88, adj_100, adj_101);
                    wp::adj_mul(var_99, var_96, adj_99, adj_96, adj_100);
                    wp::adj_mul(var_92, var_98, adj_92, adj_98, adj_99);
                    wp::adj_extract(var_26, var_36, var_89, adj_26, adj_36, adj_89, adj_98);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_97, adj_95, adj_96);
                    wp::adj_address(var_J, var_0, var_94, var_33, adj_J, adj_0, adj_94, adj_33, adj_95);
                    wp::adj_add(var_29, var_89, adj_29, adj_89, adj_94);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_93, adj_91, adj_92);
                    wp::adj_address(var_J, var_0, var_90, var_31, adj_J, adj_0, adj_90, adj_31, adj_91);
                    wp::adj_add(var_29, var_36, adj_29, adj_36, adj_90);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_75, var_87, adj_75, adj_87, adj_88);
                    wp::adj_mul(var_86, var_83, adj_86, adj_83, adj_87);
                    wp::adj_mul(var_79, var_85, adj_79, adj_85, adj_86);
                    wp::adj_extract(var_26, var_36, var_76, adj_26, adj_36, adj_76, adj_85);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_84, adj_82, adj_83);
                    wp::adj_address(var_J, var_0, var_81, var_33, adj_J, adj_0, adj_81, adj_33, adj_82);
                    wp::adj_add(var_29, var_76, adj_29, adj_76, adj_81);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_80, adj_78, adj_79);
                    wp::adj_address(var_J, var_0, var_77, var_31, adj_J, adj_0, adj_77, adj_31, adj_78);
                    wp::adj_add(var_29, var_36, adj_29, adj_36, adj_77);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_62, var_74, adj_62, adj_74, adj_75);
                    wp::adj_mul(var_73, var_70, adj_73, adj_70, adj_74);
                    wp::adj_mul(var_66, var_72, adj_66, adj_72, adj_73);
                    wp::adj_extract(var_26, var_36, var_63, adj_26, adj_36, adj_63, adj_72);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_71, adj_69, adj_70);
                    wp::adj_address(var_J, var_0, var_68, var_33, adj_J, adj_0, adj_68, adj_33, adj_69);
                    wp::adj_add(var_29, var_63, adj_29, adj_63, adj_68);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_67, adj_65, adj_66);
                    wp::adj_address(var_J, var_0, var_64, var_31, adj_J, adj_0, adj_64, adj_31, adj_65);
                    wp::adj_add(var_29, var_36, adj_29, adj_36, adj_64);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_49, var_61, adj_49, adj_61, adj_62);
                    wp::adj_mul(var_60, var_57, adj_60, adj_57, adj_61);
                    wp::adj_mul(var_53, var_59, adj_53, adj_59, adj_60);
                    wp::adj_extract(var_26, var_36, var_50, adj_26, adj_36, adj_50, adj_59);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_58, adj_56, adj_57);
                    wp::adj_address(var_J, var_0, var_55, var_33, adj_J, adj_0, adj_55, adj_33, adj_56);
                    wp::adj_add(var_29, var_50, adj_29, adj_50, adj_55);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_54, adj_52, adj_53);
                    wp::adj_address(var_J, var_0, var_51, var_31, adj_J, adj_0, adj_51, adj_31, adj_52);
                    wp::adj_add(var_29, var_36, adj_29, adj_36, adj_51);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    wp::adj_add(var_35, var_48, adj_35, adj_48, adj_49);
                    wp::adj_mul(var_47, var_44, adj_47, adj_44, adj_48);
                    wp::adj_mul(var_40, var_46, adj_40, adj_46, adj_47);
                    wp::adj_extract(var_26, var_36, var_37, adj_26, adj_36, adj_37, adj_46);
                    // adj: sum_val += J_ik * I_s[k, l] * J_jl                                    <L 1375>
                    wp::adj_copy(var_45, adj_43, adj_44);
                    wp::adj_address(var_J, var_0, var_42, var_33, adj_J, adj_0, adj_42, adj_33, adj_43);
                    wp::adj_add(var_29, var_37, adj_29, adj_37, adj_42);
                    // adj: J_jl = J[art_idx, row_start + l, dof_j]                               <L 1374>
                    wp::adj_copy(var_41, adj_39, adj_40);
                    wp::adj_address(var_J, var_0, var_38, var_31, adj_J, adj_0, adj_38, adj_31, adj_39);
                    wp::adj_add(var_29, var_36, adj_29, adj_36, adj_38);
                    // adj: J_ik = J[art_idx, row_start + k, dof_i]                               <L 1373>
                    // adj: for l in range(6):                                                    <L 1372>
                    // adj: for k in range(6):                                                    <L 1371>
                    wp::adj_float(var_34, adj_34, adj_35);
                    // adj: sum_val = float(0.0)                                                  <L 1368>
                	goto start_for_6;
                end_for_6:;
                // adj: for dof_j in range(articulation_dof_count):                               <L 1367>
            	goto start_for_4;
            end_for_4:;
            // adj: for dof_i in range(articulation_dof_count):                                   <L 1366>
            wp::adj_mul(var_20, var_28, adj_20, adj_28, adj_29);
            // adj: row_start = link_idx * 6                                                      <L 1363>
            wp::adj_copy(var_27, adj_25, adj_26);
            wp::adj_address(var_body_I_s, var_23, adj_body_I_s, adj_23, adj_25);
            // adj: I_s = body_I_s[child]                                                         <L 1361>
            wp::adj_copy(var_24, adj_22, adj_23);
            wp::adj_address(var_joint_child, var_21, adj_joint_child, adj_21, adj_22);
            // adj: child = joint_child[j]                                                        <L 1360>
            wp::adj_add(var_6, var_20, adj_6, adj_20, adj_21);
            // adj: j = joint_start + link_idx                                                    <L 1359>
        	goto start_for_2;
        end_for_2:;
        // adj: for link_idx in range(joint_count):                                               <L 1358>
        wp::adj_sub(var_16, var_13, adj_16, adj_13, adj_18);
        // adj: articulation_dof_count = articulation_dof_end - articulation_dof_start            <L 1352>
        wp::adj_copy(var_17, adj_15, adj_16);
        wp::adj_address(var_joint_qd_start, var_9, adj_joint_qd_start, adj_9, adj_15);
        // adj: articulation_dof_end = joint_qd_start[joint_end]                                  <L 1351>
        wp::adj_copy(var_14, adj_12, adj_13);
        wp::adj_address(var_joint_qd_start, var_6, adj_joint_qd_start, adj_6, adj_12);
        // adj: articulation_dof_start = joint_qd_start[joint_start]                              <L 1350>
        wp::adj_sub(var_9, var_6, adj_9, adj_6, adj_11);
        // adj: joint_count = joint_end - joint_start                                             <L 1348>
        wp::adj_copy(var_10, adj_8, adj_9);
        wp::adj_address(var_articulation_end, var_0, adj_articulation_end, adj_0, adj_8);
        // adj: joint_end = articulation_end[art_idx]                                             <L 1347>
        wp::adj_copy(var_7, adj_5, adj_6);
        wp::adj_address(var_articulation_start, var_0, adj_articulation_start, adj_0, adj_5);
        // adj: joint_start = articulation_start[art_idx]                                         <L 1346>
        if (var_articulation_mask) {
            if (var_3) {
                label1:;
                // adj: return                                                                    <L 1344>
            }
            wp::adj_address(var_articulation_mask, var_0, adj_articulation_mask, adj_0, adj_2);
            // adj: if not articulation_mask[art_idx]:                                            <L 1343>
        }
        // adj: if articulation_mask:                                                             <L 1342>
        if (var_1) {
            label0:;
            // adj: return                                                                        <L 1340>
        }
        // adj: if art_idx >= articulation_count:                                                 <L 1339>
        // adj: art_idx = wp.tid()                                                                <L 1337>
        // adj: def eval_articulation_mass_matrix(                                                <L 1320>
        continue;
    }
}



extern "C" __global__ void compute_body_spatial_inertia_5e864b14_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::mat_t<3, 3, wp::float32>> var_body_inertia,
    wp::array_t<wp::float32> var_body_mass,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::mat_t<6, 6, wp::float32>> var_body_I_s)
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
        wp::mat_t<3, 3, wp::float32>* var_1;
        wp::mat_t<3, 3, wp::float32> var_2;
        wp::mat_t<3, 3, wp::float32> var_3;
        wp::float32* var_4;
        wp::float32 var_5;
        wp::float32 var_6;
        wp::transform_t<wp::float32>* var_7;
        wp::transform_t<wp::float32> var_8;
        wp::transform_t<wp::float32> var_9;
        wp::quat_t<wp::float32> var_10;
        const wp::float32 var_11 = 1.0;
        const wp::float32 var_12 = 0.0;
        const wp::float32 var_13 = 0.0;
        wp::vec_t<3, wp::float32> var_14;
        wp::vec_t<3, wp::float32> var_15;
        const wp::float32 var_16 = 0.0;
        const wp::float32 var_17 = 1.0;
        const wp::float32 var_18 = 0.0;
        wp::vec_t<3, wp::float32> var_19;
        wp::vec_t<3, wp::float32> var_20;
        const wp::float32 var_21 = 0.0;
        const wp::float32 var_22 = 0.0;
        const wp::float32 var_23 = 1.0;
        wp::vec_t<3, wp::float32> var_24;
        wp::vec_t<3, wp::float32> var_25;
        wp::mat_t<3, 3, wp::float32> var_26;
        wp::mat_t<3, 3, wp::float32> var_27;
        wp::mat_t<3, 3, wp::float32> var_28;
        wp::mat_t<3, 3, wp::float32> var_29;
        const wp::float32 var_30 = 0.0;
        const wp::float32 var_31 = 0.0;
        const wp::float32 var_32 = 0.0;
        const wp::float32 var_33 = 0.0;
        const wp::float32 var_34 = 0.0;
        const wp::float32 var_35 = 0.0;
        const wp::float32 var_36 = 0.0;
        const wp::float32 var_37 = 0.0;
        const wp::float32 var_38 = 0.0;
        const wp::float32 var_39 = 0.0;
        const wp::float32 var_40 = 0.0;
        const wp::float32 var_41 = 0.0;
        const wp::float32 var_42 = 0.0;
        const wp::float32 var_43 = 0.0;
        const wp::float32 var_44 = 0.0;
        const wp::float32 var_45 = 0.0;
        const wp::float32 var_46 = 0.0;
        const wp::float32 var_47 = 0.0;
        const wp::int32 var_48 = 0;
        const wp::int32 var_49 = 0;
        wp::float32 var_50;
        const wp::int32 var_51 = 0;
        const wp::int32 var_52 = 1;
        wp::float32 var_53;
        const wp::int32 var_54 = 0;
        const wp::int32 var_55 = 2;
        wp::float32 var_56;
        const wp::float32 var_57 = 0.0;
        const wp::float32 var_58 = 0.0;
        const wp::float32 var_59 = 0.0;
        const wp::int32 var_60 = 1;
        const wp::int32 var_61 = 0;
        wp::float32 var_62;
        const wp::int32 var_63 = 1;
        const wp::int32 var_64 = 1;
        wp::float32 var_65;
        const wp::int32 var_66 = 1;
        const wp::int32 var_67 = 2;
        wp::float32 var_68;
        const wp::float32 var_69 = 0.0;
        const wp::float32 var_70 = 0.0;
        const wp::float32 var_71 = 0.0;
        const wp::int32 var_72 = 2;
        const wp::int32 var_73 = 0;
        wp::float32 var_74;
        const wp::int32 var_75 = 2;
        const wp::int32 var_76 = 1;
        wp::float32 var_77;
        const wp::int32 var_78 = 2;
        const wp::int32 var_79 = 2;
        wp::float32 var_80;
        wp::mat_t<6, 6, wp::float32> var_81;
        //---------
        // forward
        // def compute_body_spatial_inertia(                                                      <L 1285>
        // tid = wp.tid()                                                                         <L 1293>
        var_0 = builtin_tid1d();
        // I_local = body_inertia[tid]                                                            <L 1295>
        var_1 = wp::address(var_body_inertia, var_0);
        var_3 = wp::load(var_1);
        var_2 = wp::copy(var_3);
        // m = body_mass[tid]                                                                     <L 1296>
        var_4 = wp::address(var_body_mass, var_0);
        var_6 = wp::load(var_4);
        var_5 = wp::copy(var_6);
        // X_wb = body_q[tid]                                                                     <L 1297>
        var_7 = wp::address(var_body_q, var_0);
        var_9 = wp::load(var_7);
        var_8 = wp::copy(var_9);
        // q = wp.transform_get_rotation(X_wb)                                                    <L 1298>
        var_10 = wp::transform_get_rotation(var_8);
        // r1 = wp.quat_rotate(q, wp.vec3(1.0, 0.0, 0.0))                                         <L 1300>
        var_14 = wp::vec_t<3, wp::float32>(var_11, var_12, var_13);
        var_15 = wp::quat_rotate(var_10, var_14);
        // r2 = wp.quat_rotate(q, wp.vec3(0.0, 1.0, 0.0))                                         <L 1301>
        var_19 = wp::vec_t<3, wp::float32>(var_16, var_17, var_18);
        var_20 = wp::quat_rotate(var_10, var_19);
        // r3 = wp.quat_rotate(q, wp.vec3(0.0, 0.0, 1.0))                                         <L 1302>
        var_24 = wp::vec_t<3, wp::float32>(var_21, var_22, var_23);
        var_25 = wp::quat_rotate(var_10, var_24);
        // R = wp.matrix_from_cols(r1, r2, r3)                                                    <L 1303>
        var_26 = wp::matrix_from_cols<wp::float32>(var_15, var_20, var_25);
        // I_world = R * I_local * wp.transpose(R)                                                <L 1304>
        var_27 = wp::mul(var_26, var_2);
        var_28 = wp::transpose(var_26);
        var_29 = wp::mul(var_27, var_28);
        // body_I_s[tid] = wp.spatial_matrix(                                                     <L 1308>
        // m,   0.0, 0.0, 0.0,           0.0,           0.0,                                      <L 1309>
        // 0.0, m,   0.0, 0.0,           0.0,           0.0,                                      <L 1310>
        // 0.0, 0.0, m,   0.0,           0.0,           0.0,                                      <L 1311>
        // 0.0, 0.0, 0.0, I_world[0, 0], I_world[0, 1], I_world[0, 2],                            <L 1312>
        var_50 = wp::extract(var_29, var_48, var_49);
        var_53 = wp::extract(var_29, var_51, var_52);
        var_56 = wp::extract(var_29, var_54, var_55);
        // 0.0, 0.0, 0.0, I_world[1, 0], I_world[1, 1], I_world[1, 2],                            <L 1313>
        var_62 = wp::extract(var_29, var_60, var_61);
        var_65 = wp::extract(var_29, var_63, var_64);
        var_68 = wp::extract(var_29, var_66, var_67);
        // 0.0, 0.0, 0.0, I_world[2, 0], I_world[2, 1], I_world[2, 2],                            <L 1314>
        var_74 = wp::extract(var_29, var_72, var_73);
        var_77 = wp::extract(var_29, var_75, var_76);
        var_80 = wp::extract(var_29, var_78, var_79);
        var_81 = wp::mat_t<6, 6, wp::float32>({var_5, var_30, var_31, var_32, var_33, var_34, var_35, var_5, var_36, var_37, var_38, var_39, var_40, var_41, var_5, var_42, var_43, var_44, var_45, var_46, var_47, var_50, var_53, var_56, var_57, var_58, var_59, var_62, var_65, var_68, var_69, var_70, var_71, var_74, var_77, var_80});
        // body_I_s[tid] = wp.spatial_matrix(                                                     <L 1308>
        wp::array_store(var_body_I_s, var_0, var_81);
    }
}



extern "C" __global__ void compute_body_spatial_inertia_5e864b14_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::mat_t<3, 3, wp::float32>> var_body_inertia,
    wp::array_t<wp::float32> var_body_mass,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::mat_t<6, 6, wp::float32>> var_body_I_s,
    wp::array_t<wp::mat_t<3, 3, wp::float32>> adj_body_inertia,
    wp::array_t<wp::float32> adj_body_mass,
    wp::array_t<wp::transform_t<wp::float32>> adj_body_q,
    wp::array_t<wp::mat_t<6, 6, wp::float32>> adj_body_I_s)
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
        wp::mat_t<3, 3, wp::float32>* var_1;
        wp::mat_t<3, 3, wp::float32> var_2;
        wp::mat_t<3, 3, wp::float32> var_3;
        wp::float32* var_4;
        wp::float32 var_5;
        wp::float32 var_6;
        wp::transform_t<wp::float32>* var_7;
        wp::transform_t<wp::float32> var_8;
        wp::transform_t<wp::float32> var_9;
        wp::quat_t<wp::float32> var_10;
        const wp::float32 var_11 = 1.0;
        const wp::float32 var_12 = 0.0;
        const wp::float32 var_13 = 0.0;
        wp::vec_t<3, wp::float32> var_14;
        wp::vec_t<3, wp::float32> var_15;
        const wp::float32 var_16 = 0.0;
        const wp::float32 var_17 = 1.0;
        const wp::float32 var_18 = 0.0;
        wp::vec_t<3, wp::float32> var_19;
        wp::vec_t<3, wp::float32> var_20;
        const wp::float32 var_21 = 0.0;
        const wp::float32 var_22 = 0.0;
        const wp::float32 var_23 = 1.0;
        wp::vec_t<3, wp::float32> var_24;
        wp::vec_t<3, wp::float32> var_25;
        wp::mat_t<3, 3, wp::float32> var_26;
        wp::mat_t<3, 3, wp::float32> var_27;
        wp::mat_t<3, 3, wp::float32> var_28;
        wp::mat_t<3, 3, wp::float32> var_29;
        const wp::float32 var_30 = 0.0;
        const wp::float32 var_31 = 0.0;
        const wp::float32 var_32 = 0.0;
        const wp::float32 var_33 = 0.0;
        const wp::float32 var_34 = 0.0;
        const wp::float32 var_35 = 0.0;
        const wp::float32 var_36 = 0.0;
        const wp::float32 var_37 = 0.0;
        const wp::float32 var_38 = 0.0;
        const wp::float32 var_39 = 0.0;
        const wp::float32 var_40 = 0.0;
        const wp::float32 var_41 = 0.0;
        const wp::float32 var_42 = 0.0;
        const wp::float32 var_43 = 0.0;
        const wp::float32 var_44 = 0.0;
        const wp::float32 var_45 = 0.0;
        const wp::float32 var_46 = 0.0;
        const wp::float32 var_47 = 0.0;
        const wp::int32 var_48 = 0;
        const wp::int32 var_49 = 0;
        wp::float32 var_50;
        const wp::int32 var_51 = 0;
        const wp::int32 var_52 = 1;
        wp::float32 var_53;
        const wp::int32 var_54 = 0;
        const wp::int32 var_55 = 2;
        wp::float32 var_56;
        const wp::float32 var_57 = 0.0;
        const wp::float32 var_58 = 0.0;
        const wp::float32 var_59 = 0.0;
        const wp::int32 var_60 = 1;
        const wp::int32 var_61 = 0;
        wp::float32 var_62;
        const wp::int32 var_63 = 1;
        const wp::int32 var_64 = 1;
        wp::float32 var_65;
        const wp::int32 var_66 = 1;
        const wp::int32 var_67 = 2;
        wp::float32 var_68;
        const wp::float32 var_69 = 0.0;
        const wp::float32 var_70 = 0.0;
        const wp::float32 var_71 = 0.0;
        const wp::int32 var_72 = 2;
        const wp::int32 var_73 = 0;
        wp::float32 var_74;
        const wp::int32 var_75 = 2;
        const wp::int32 var_76 = 1;
        wp::float32 var_77;
        const wp::int32 var_78 = 2;
        const wp::int32 var_79 = 2;
        wp::float32 var_80;
        wp::mat_t<6, 6, wp::float32> var_81;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::mat_t<3, 3, wp::float32> adj_1 = {};
        wp::mat_t<3, 3, wp::float32> adj_2 = {};
        wp::mat_t<3, 3, wp::float32> adj_3 = {};
        wp::float32 adj_4 = {};
        wp::float32 adj_5 = {};
        wp::float32 adj_6 = {};
        wp::transform_t<wp::float32> adj_7 = {};
        wp::transform_t<wp::float32> adj_8 = {};
        wp::transform_t<wp::float32> adj_9 = {};
        wp::quat_t<wp::float32> adj_10 = {};
        wp::float32 adj_11 = {};
        wp::float32 adj_12 = {};
        wp::float32 adj_13 = {};
        wp::vec_t<3, wp::float32> adj_14 = {};
        wp::vec_t<3, wp::float32> adj_15 = {};
        wp::float32 adj_16 = {};
        wp::float32 adj_17 = {};
        wp::float32 adj_18 = {};
        wp::vec_t<3, wp::float32> adj_19 = {};
        wp::vec_t<3, wp::float32> adj_20 = {};
        wp::float32 adj_21 = {};
        wp::float32 adj_22 = {};
        wp::float32 adj_23 = {};
        wp::vec_t<3, wp::float32> adj_24 = {};
        wp::vec_t<3, wp::float32> adj_25 = {};
        wp::mat_t<3, 3, wp::float32> adj_26 = {};
        wp::mat_t<3, 3, wp::float32> adj_27 = {};
        wp::mat_t<3, 3, wp::float32> adj_28 = {};
        wp::mat_t<3, 3, wp::float32> adj_29 = {};
        wp::float32 adj_30 = {};
        wp::float32 adj_31 = {};
        wp::float32 adj_32 = {};
        wp::float32 adj_33 = {};
        wp::float32 adj_34 = {};
        wp::float32 adj_35 = {};
        wp::float32 adj_36 = {};
        wp::float32 adj_37 = {};
        wp::float32 adj_38 = {};
        wp::float32 adj_39 = {};
        wp::float32 adj_40 = {};
        wp::float32 adj_41 = {};
        wp::float32 adj_42 = {};
        wp::float32 adj_43 = {};
        wp::float32 adj_44 = {};
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
        wp::float32 adj_57 = {};
        wp::float32 adj_58 = {};
        wp::float32 adj_59 = {};
        wp::int32 adj_60 = {};
        wp::int32 adj_61 = {};
        wp::float32 adj_62 = {};
        wp::int32 adj_63 = {};
        wp::int32 adj_64 = {};
        wp::float32 adj_65 = {};
        wp::int32 adj_66 = {};
        wp::int32 adj_67 = {};
        wp::float32 adj_68 = {};
        wp::float32 adj_69 = {};
        wp::float32 adj_70 = {};
        wp::float32 adj_71 = {};
        wp::int32 adj_72 = {};
        wp::int32 adj_73 = {};
        wp::float32 adj_74 = {};
        wp::int32 adj_75 = {};
        wp::int32 adj_76 = {};
        wp::float32 adj_77 = {};
        wp::int32 adj_78 = {};
        wp::int32 adj_79 = {};
        wp::float32 adj_80 = {};
        wp::mat_t<6, 6, wp::float32> adj_81 = {};
        //---------
        // forward
        // def compute_body_spatial_inertia(                                                      <L 1285>
        // tid = wp.tid()                                                                         <L 1293>
        var_0 = builtin_tid1d();
        // I_local = body_inertia[tid]                                                            <L 1295>
        var_1 = wp::address(var_body_inertia, var_0);
        var_3 = wp::load(var_1);
        var_2 = wp::copy(var_3);
        // m = body_mass[tid]                                                                     <L 1296>
        var_4 = wp::address(var_body_mass, var_0);
        var_6 = wp::load(var_4);
        var_5 = wp::copy(var_6);
        // X_wb = body_q[tid]                                                                     <L 1297>
        var_7 = wp::address(var_body_q, var_0);
        var_9 = wp::load(var_7);
        var_8 = wp::copy(var_9);
        // q = wp.transform_get_rotation(X_wb)                                                    <L 1298>
        var_10 = wp::transform_get_rotation(var_8);
        // r1 = wp.quat_rotate(q, wp.vec3(1.0, 0.0, 0.0))                                         <L 1300>
        var_14 = wp::vec_t<3, wp::float32>(var_11, var_12, var_13);
        var_15 = wp::quat_rotate(var_10, var_14);
        // r2 = wp.quat_rotate(q, wp.vec3(0.0, 1.0, 0.0))                                         <L 1301>
        var_19 = wp::vec_t<3, wp::float32>(var_16, var_17, var_18);
        var_20 = wp::quat_rotate(var_10, var_19);
        // r3 = wp.quat_rotate(q, wp.vec3(0.0, 0.0, 1.0))                                         <L 1302>
        var_24 = wp::vec_t<3, wp::float32>(var_21, var_22, var_23);
        var_25 = wp::quat_rotate(var_10, var_24);
        // R = wp.matrix_from_cols(r1, r2, r3)                                                    <L 1303>
        var_26 = wp::matrix_from_cols<wp::float32>(var_15, var_20, var_25);
        // I_world = R * I_local * wp.transpose(R)                                                <L 1304>
        var_27 = wp::mul(var_26, var_2);
        var_28 = wp::transpose(var_26);
        var_29 = wp::mul(var_27, var_28);
        // body_I_s[tid] = wp.spatial_matrix(                                                     <L 1308>
        // m,   0.0, 0.0, 0.0,           0.0,           0.0,                                      <L 1309>
        // 0.0, m,   0.0, 0.0,           0.0,           0.0,                                      <L 1310>
        // 0.0, 0.0, m,   0.0,           0.0,           0.0,                                      <L 1311>
        // 0.0, 0.0, 0.0, I_world[0, 0], I_world[0, 1], I_world[0, 2],                            <L 1312>
        var_50 = wp::extract(var_29, var_48, var_49);
        var_53 = wp::extract(var_29, var_51, var_52);
        var_56 = wp::extract(var_29, var_54, var_55);
        // 0.0, 0.0, 0.0, I_world[1, 0], I_world[1, 1], I_world[1, 2],                            <L 1313>
        var_62 = wp::extract(var_29, var_60, var_61);
        var_65 = wp::extract(var_29, var_63, var_64);
        var_68 = wp::extract(var_29, var_66, var_67);
        // 0.0, 0.0, 0.0, I_world[2, 0], I_world[2, 1], I_world[2, 2],                            <L 1314>
        var_74 = wp::extract(var_29, var_72, var_73);
        var_77 = wp::extract(var_29, var_75, var_76);
        var_80 = wp::extract(var_29, var_78, var_79);
        var_81 = wp::mat_t<6, 6, wp::float32>({var_5, var_30, var_31, var_32, var_33, var_34, var_35, var_5, var_36, var_37, var_38, var_39, var_40, var_41, var_5, var_42, var_43, var_44, var_45, var_46, var_47, var_50, var_53, var_56, var_57, var_58, var_59, var_62, var_65, var_68, var_69, var_70, var_71, var_74, var_77, var_80});
        // body_I_s[tid] = wp.spatial_matrix(                                                     <L 1308>
        // wp::array_store(var_body_I_s, var_0, var_81);
        //---------
        // reverse
        wp::adj_array_store(var_body_I_s, var_0, var_81, adj_body_I_s, adj_0, adj_81);
        // adj: body_I_s[tid] = wp.spatial_matrix(                                                <L 1308>
        wp::adj_mat_t({var_5, var_30, var_31, var_32, var_33, var_34, var_35, var_5, var_36, var_37, var_38, var_39, var_40, var_41, var_5, var_42, var_43, var_44, var_45, var_46, var_47, var_50, var_53, var_56, var_57, var_58, var_59, var_62, var_65, var_68, var_69, var_70, var_71, var_74, var_77, var_80}, {&adj_5, &adj_30, &adj_31, &adj_32, &adj_33, &adj_34, &adj_35, &adj_5, &adj_36, &adj_37, &adj_38, &adj_39, &adj_40, &adj_41, &adj_5, &adj_42, &adj_43, &adj_44, &adj_45, &adj_46, &adj_47, &adj_50, &adj_53, &adj_56, &adj_57, &adj_58, &adj_59, &adj_62, &adj_65, &adj_68, &adj_69, &adj_70, &adj_71, &adj_74, &adj_77, &adj_80}, adj_81);
        wp::adj_extract(var_29, var_78, var_79, adj_29, adj_78, adj_79, adj_80);
        wp::adj_extract(var_29, var_75, var_76, adj_29, adj_75, adj_76, adj_77);
        wp::adj_extract(var_29, var_72, var_73, adj_29, adj_72, adj_73, adj_74);
        // adj: 0.0, 0.0, 0.0, I_world[2, 0], I_world[2, 1], I_world[2, 2],                       <L 1314>
        wp::adj_extract(var_29, var_66, var_67, adj_29, adj_66, adj_67, adj_68);
        wp::adj_extract(var_29, var_63, var_64, adj_29, adj_63, adj_64, adj_65);
        wp::adj_extract(var_29, var_60, var_61, adj_29, adj_60, adj_61, adj_62);
        // adj: 0.0, 0.0, 0.0, I_world[1, 0], I_world[1, 1], I_world[1, 2],                       <L 1313>
        wp::adj_extract(var_29, var_54, var_55, adj_29, adj_54, adj_55, adj_56);
        wp::adj_extract(var_29, var_51, var_52, adj_29, adj_51, adj_52, adj_53);
        wp::adj_extract(var_29, var_48, var_49, adj_29, adj_48, adj_49, adj_50);
        // adj: 0.0, 0.0, 0.0, I_world[0, 0], I_world[0, 1], I_world[0, 2],                       <L 1312>
        // adj: 0.0, 0.0, m,   0.0,           0.0,           0.0,                                 <L 1311>
        // adj: 0.0, m,   0.0, 0.0,           0.0,           0.0,                                 <L 1310>
        // adj: m,   0.0, 0.0, 0.0,           0.0,           0.0,                                 <L 1309>
        // adj: body_I_s[tid] = wp.spatial_matrix(                                                <L 1308>
        wp::adj_mul(var_27, var_28, adj_27, adj_28, adj_29);
        wp::adj_transpose(var_26, adj_26, adj_28);
        wp::adj_mul(var_26, var_2, adj_26, adj_2, adj_27);
        // adj: I_world = R * I_local * wp.transpose(R)                                           <L 1304>
        wp::adj_matrix_from_cols(var_15, var_20, var_25, adj_15, adj_20, adj_25, adj_26);
        // adj: R = wp.matrix_from_cols(r1, r2, r3)                                               <L 1303>
        wp::adj_quat_rotate(var_10, var_24, adj_10, adj_24, adj_25);
        wp::adj_vec_t(var_21, var_22, var_23, adj_21, adj_22, adj_23, adj_24);
        // adj: r3 = wp.quat_rotate(q, wp.vec3(0.0, 0.0, 1.0))                                    <L 1302>
        wp::adj_quat_rotate(var_10, var_19, adj_10, adj_19, adj_20);
        wp::adj_vec_t(var_16, var_17, var_18, adj_16, adj_17, adj_18, adj_19);
        // adj: r2 = wp.quat_rotate(q, wp.vec3(0.0, 1.0, 0.0))                                    <L 1301>
        wp::adj_quat_rotate(var_10, var_14, adj_10, adj_14, adj_15);
        wp::adj_vec_t(var_11, var_12, var_13, adj_11, adj_12, adj_13, adj_14);
        // adj: r1 = wp.quat_rotate(q, wp.vec3(1.0, 0.0, 0.0))                                    <L 1300>
        wp::adj_transform_get_rotation(var_8, adj_8, adj_10);
        // adj: q = wp.transform_get_rotation(X_wb)                                               <L 1298>
        wp::adj_copy(var_9, adj_7, adj_8);
        wp::adj_address(var_body_q, var_0, adj_body_q, adj_0, adj_7);
        // adj: X_wb = body_q[tid]                                                                <L 1297>
        wp::adj_copy(var_6, adj_4, adj_5);
        wp::adj_address(var_body_mass, var_0, adj_body_mass, adj_0, adj_4);
        // adj: m = body_mass[tid]                                                                <L 1296>
        wp::adj_copy(var_3, adj_1, adj_2);
        wp::adj_address(var_body_inertia, var_0, adj_body_inertia, adj_0, adj_1);
        // adj: I_local = body_inertia[tid]                                                       <L 1295>
        // adj: tid = wp.tid()                                                                    <L 1293>
        // adj: def compute_body_spatial_inertia(                                                 <L 1285>
        continue;
    }
}



extern "C" __global__ void eval_articulation_fk_6c60ba16_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::int32> var_articulation_start,
    wp::array_t<wp::int32> var_articulation_end,
    wp::int32 var_articulation_count,
    wp::array_t<bool> var_articulation_mask,
    wp::array_t<wp::int32> var_articulation_indices,
    wp::array_t<wp::int32> var_joint_articulation,
    wp::array_t<wp::float32> var_joint_q,
    wp::array_t<wp::float32> var_joint_qd,
    wp::array_t<wp::int32> var_joint_q_start,
    wp::array_t<wp::int32> var_joint_qd_start,
    wp::array_t<wp::int32> var_joint_type,
    wp::array_t<wp::int32> var_joint_parent,
    wp::array_t<wp::int32> var_joint_child,
    wp::array_t<wp::transform_t<wp::float32>> var_joint_X_p,
    wp::array_t<wp::transform_t<wp::float32>> var_joint_X_c,
    wp::array_t<wp::vec_t<3, wp::float32>> var_joint_axis,
    wp::array_t<wp::int32> var_joint_dof_dim,
    wp::array_t<wp::vec_t<3, wp::float32>> var_body_com,
    wp::array_t<wp::int32> var_body_flags,
    wp::int32 var_body_flag_filter,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::vec_t<6, wp::float32>> var_body_qd)
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
        wp::int32 var_2;
        wp::int32 var_3;
        wp::int32 var_4;
        wp::int32 var_5;
        bool var_6;
        const wp::int32 var_7 = 0;
        bool var_8;
        bool var_9;
        bool* var_10;
        bool var_11;
        bool var_12;
        wp::int32* var_13;
        wp::int32 var_14;
        wp::int32 var_15;
        wp::int32* var_16;
        wp::int32 var_17;
        wp::int32 var_18;
        //---------
        // forward
        // def eval_articulation_fk(                                                              <L 427>
        // tid = wp.tid()                                                                         <L 454>
        var_0 = builtin_tid1d();
        // if articulation_indices:                                                               <L 457>
        if (var_articulation_indices) {
            // articulation_id = articulation_indices[tid]                                        <L 459>
            var_1 = wp::address(var_articulation_indices, var_0);
            var_3 = wp::load(var_1);
            var_2 = wp::copy(var_3);
        }
        if (!var_articulation_indices) {
            // articulation_id = tid                                                              <L 462>
            var_4 = wp::copy(var_0);
        }
        var_5 = wp::where(var_articulation_indices, var_2, var_4);
        // if articulation_id < 0 or articulation_id >= articulation_count:                       <L 465>
        var_8 = (var_5 < var_7);
        var_6 = var_8;
        if (!var_6) {
            var_9 = (var_5 >= var_articulation_count);
            var_6 = var_6 || var_9;
        }
        if (var_6) {
            // return  # Invalid articulation index                                               <L 466>
            continue;
        }
        // if articulation_mask:                                                                  <L 469>
        if (var_articulation_mask) {
            // if not articulation_mask[articulation_id]:                                         <L 470>
            var_10 = wp::address(var_articulation_mask, var_5);
            var_12 = wp::load(var_10);
            var_11 = wp::unot(var_12);
            if (var_11) {
                // return                                                                         <L 471>
                continue;
            }
        }
        // joint_start = articulation_start[articulation_id]                                      <L 473>
        var_13 = wp::address(var_articulation_start, var_5);
        var_15 = wp::load(var_13);
        var_14 = wp::copy(var_15);
        // joint_end = articulation_end[articulation_id]                                          <L 474>
        var_16 = wp::address(var_articulation_end, var_5);
        var_18 = wp::load(var_16);
        var_17 = wp::copy(var_18);
        // eval_single_articulation_fk(                                                           <L 476>
        // joint_start,                                                                           <L 477>
        // joint_end,                                                                             <L 478>
        // joint_articulation,                                                                    <L 479>
        // joint_q,                                                                               <L 480>
        // joint_qd,                                                                              <L 481>
        // joint_q_start,                                                                         <L 482>
        // joint_qd_start,                                                                        <L 483>
        // joint_type,                                                                            <L 484>
        // joint_parent,                                                                          <L 485>
        // joint_child,                                                                           <L 486>
        // joint_X_p,                                                                             <L 487>
        // joint_X_c,                                                                             <L 488>
        // joint_axis,                                                                            <L 489>
        // joint_dof_dim,                                                                         <L 490>
        // body_com,                                                                              <L 491>
        // body_flags,                                                                            <L 492>
        // body_flag_filter,                                                                      <L 493>
        // body_q,                                                                                <L 495>
        // body_qd,                                                                               <L 496>
        eval_single_articulation_fk_0(var_14, var_17, var_joint_articulation, var_joint_q, var_joint_qd, var_joint_q_start, var_joint_qd_start, var_joint_type, var_joint_parent, var_joint_child, var_joint_X_p, var_joint_X_c, var_joint_axis, var_joint_dof_dim, var_body_com, var_body_flags, var_body_flag_filter, var_body_q, var_body_qd);
    }
}



extern "C" __global__ void eval_articulation_fk_6c60ba16_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::int32> var_articulation_start,
    wp::array_t<wp::int32> var_articulation_end,
    wp::int32 var_articulation_count,
    wp::array_t<bool> var_articulation_mask,
    wp::array_t<wp::int32> var_articulation_indices,
    wp::array_t<wp::int32> var_joint_articulation,
    wp::array_t<wp::float32> var_joint_q,
    wp::array_t<wp::float32> var_joint_qd,
    wp::array_t<wp::int32> var_joint_q_start,
    wp::array_t<wp::int32> var_joint_qd_start,
    wp::array_t<wp::int32> var_joint_type,
    wp::array_t<wp::int32> var_joint_parent,
    wp::array_t<wp::int32> var_joint_child,
    wp::array_t<wp::transform_t<wp::float32>> var_joint_X_p,
    wp::array_t<wp::transform_t<wp::float32>> var_joint_X_c,
    wp::array_t<wp::vec_t<3, wp::float32>> var_joint_axis,
    wp::array_t<wp::int32> var_joint_dof_dim,
    wp::array_t<wp::vec_t<3, wp::float32>> var_body_com,
    wp::array_t<wp::int32> var_body_flags,
    wp::int32 var_body_flag_filter,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::vec_t<6, wp::float32>> var_body_qd,
    wp::array_t<wp::int32> adj_articulation_start,
    wp::array_t<wp::int32> adj_articulation_end,
    wp::int32 adj_articulation_count,
    wp::array_t<bool> adj_articulation_mask,
    wp::array_t<wp::int32> adj_articulation_indices,
    wp::array_t<wp::int32> adj_joint_articulation,
    wp::array_t<wp::float32> adj_joint_q,
    wp::array_t<wp::float32> adj_joint_qd,
    wp::array_t<wp::int32> adj_joint_q_start,
    wp::array_t<wp::int32> adj_joint_qd_start,
    wp::array_t<wp::int32> adj_joint_type,
    wp::array_t<wp::int32> adj_joint_parent,
    wp::array_t<wp::int32> adj_joint_child,
    wp::array_t<wp::transform_t<wp::float32>> adj_joint_X_p,
    wp::array_t<wp::transform_t<wp::float32>> adj_joint_X_c,
    wp::array_t<wp::vec_t<3, wp::float32>> adj_joint_axis,
    wp::array_t<wp::int32> adj_joint_dof_dim,
    wp::array_t<wp::vec_t<3, wp::float32>> adj_body_com,
    wp::array_t<wp::int32> adj_body_flags,
    wp::int32 adj_body_flag_filter,
    wp::array_t<wp::transform_t<wp::float32>> adj_body_q,
    wp::array_t<wp::vec_t<6, wp::float32>> adj_body_qd)
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
        wp::int32 var_2;
        wp::int32 var_3;
        wp::int32 var_4;
        wp::int32 var_5;
        bool var_6;
        const wp::int32 var_7 = 0;
        bool var_8;
        bool var_9;
        bool* var_10;
        bool var_11;
        bool var_12;
        wp::int32* var_13;
        wp::int32 var_14;
        wp::int32 var_15;
        wp::int32* var_16;
        wp::int32 var_17;
        wp::int32 var_18;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::int32 adj_2 = {};
        wp::int32 adj_3 = {};
        wp::int32 adj_4 = {};
        wp::int32 adj_5 = {};
        bool adj_6 = {};
        wp::int32 adj_7 = {};
        bool adj_8 = {};
        bool adj_9 = {};
        bool adj_10 = {};
        bool adj_11 = {};
        bool adj_12 = {};
        wp::int32 adj_13 = {};
        wp::int32 adj_14 = {};
        wp::int32 adj_15 = {};
        wp::int32 adj_16 = {};
        wp::int32 adj_17 = {};
        wp::int32 adj_18 = {};
        //---------
        // forward
        // def eval_articulation_fk(                                                              <L 427>
        // tid = wp.tid()                                                                         <L 454>
        var_0 = builtin_tid1d();
        // if articulation_indices:                                                               <L 457>
        if (var_articulation_indices) {
            // articulation_id = articulation_indices[tid]                                        <L 459>
            var_1 = wp::address(var_articulation_indices, var_0);
            var_3 = wp::load(var_1);
            var_2 = wp::copy(var_3);
        }
        if (!var_articulation_indices) {
            // articulation_id = tid                                                              <L 462>
            var_4 = wp::copy(var_0);
        }
        var_5 = wp::where(var_articulation_indices, var_2, var_4);
        // if articulation_id < 0 or articulation_id >= articulation_count:                       <L 465>
        var_8 = (var_5 < var_7);
        var_6 = var_8;
        if (!var_6) {
            var_9 = (var_5 >= var_articulation_count);
            var_6 = var_6 || var_9;
        }
        if (var_6) {
            // return  # Invalid articulation index                                               <L 466>
            goto label0;
        }
        // if articulation_mask:                                                                  <L 469>
        if (var_articulation_mask) {
            // if not articulation_mask[articulation_id]:                                         <L 470>
            var_10 = wp::address(var_articulation_mask, var_5);
            var_12 = wp::load(var_10);
            var_11 = wp::unot(var_12);
            if (var_11) {
                // return                                                                         <L 471>
                goto label1;
            }
        }
        // joint_start = articulation_start[articulation_id]                                      <L 473>
        var_13 = wp::address(var_articulation_start, var_5);
        var_15 = wp::load(var_13);
        var_14 = wp::copy(var_15);
        // joint_end = articulation_end[articulation_id]                                          <L 474>
        var_16 = wp::address(var_articulation_end, var_5);
        var_18 = wp::load(var_16);
        var_17 = wp::copy(var_18);
        // eval_single_articulation_fk(                                                           <L 476>
        // joint_start,                                                                           <L 477>
        // joint_end,                                                                             <L 478>
        // joint_articulation,                                                                    <L 479>
        // joint_q,                                                                               <L 480>
        // joint_qd,                                                                              <L 481>
        // joint_q_start,                                                                         <L 482>
        // joint_qd_start,                                                                        <L 483>
        // joint_type,                                                                            <L 484>
        // joint_parent,                                                                          <L 485>
        // joint_child,                                                                           <L 486>
        // joint_X_p,                                                                             <L 487>
        // joint_X_c,                                                                             <L 488>
        // joint_axis,                                                                            <L 489>
        // joint_dof_dim,                                                                         <L 490>
        // body_com,                                                                              <L 491>
        // body_flags,                                                                            <L 492>
        // body_flag_filter,                                                                      <L 493>
        // body_q,                                                                                <L 495>
        // body_qd,                                                                               <L 496>
        eval_single_articulation_fk_0(var_14, var_17, var_joint_articulation, var_joint_q, var_joint_qd, var_joint_q_start, var_joint_qd_start, var_joint_type, var_joint_parent, var_joint_child, var_joint_X_p, var_joint_X_c, var_joint_axis, var_joint_dof_dim, var_body_com, var_body_flags, var_body_flag_filter, var_body_q, var_body_qd);
        //---------
        // reverse
        adj_eval_single_articulation_fk_0(var_14, var_17, var_joint_articulation, var_joint_q, var_joint_qd, var_joint_q_start, var_joint_qd_start, var_joint_type, var_joint_parent, var_joint_child, var_joint_X_p, var_joint_X_c, var_joint_axis, var_joint_dof_dim, var_body_com, var_body_flags, var_body_flag_filter, var_body_q, var_body_qd, adj_14, adj_17, adj_joint_articulation, adj_joint_q, adj_joint_qd, adj_joint_q_start, adj_joint_qd_start, adj_joint_type, adj_joint_parent, adj_joint_child, adj_joint_X_p, adj_joint_X_c, adj_joint_axis, adj_joint_dof_dim, adj_body_com, adj_body_flags, adj_body_flag_filter, adj_body_q, adj_body_qd);
        // adj: body_qd,                                                                          <L 496>
        // adj: body_q,                                                                           <L 495>
        // adj: body_flag_filter,                                                                 <L 493>
        // adj: body_flags,                                                                       <L 492>
        // adj: body_com,                                                                         <L 491>
        // adj: joint_dof_dim,                                                                    <L 490>
        // adj: joint_axis,                                                                       <L 489>
        // adj: joint_X_c,                                                                        <L 488>
        // adj: joint_X_p,                                                                        <L 487>
        // adj: joint_child,                                                                      <L 486>
        // adj: joint_parent,                                                                     <L 485>
        // adj: joint_type,                                                                       <L 484>
        // adj: joint_qd_start,                                                                   <L 483>
        // adj: joint_q_start,                                                                    <L 482>
        // adj: joint_qd,                                                                         <L 481>
        // adj: joint_q,                                                                          <L 480>
        // adj: joint_articulation,                                                               <L 479>
        // adj: joint_end,                                                                        <L 478>
        // adj: joint_start,                                                                      <L 477>
        // adj: eval_single_articulation_fk(                                                      <L 476>
        wp::adj_copy(var_18, adj_16, adj_17);
        wp::adj_address(var_articulation_end, var_5, adj_articulation_end, adj_5, adj_16);
        // adj: joint_end = articulation_end[articulation_id]                                     <L 474>
        wp::adj_copy(var_15, adj_13, adj_14);
        wp::adj_address(var_articulation_start, var_5, adj_articulation_start, adj_5, adj_13);
        // adj: joint_start = articulation_start[articulation_id]                                 <L 473>
        if (var_articulation_mask) {
            if (var_11) {
                label1:;
                // adj: return                                                                    <L 471>
            }
            wp::adj_address(var_articulation_mask, var_5, adj_articulation_mask, adj_5, adj_10);
            // adj: if not articulation_mask[articulation_id]:                                    <L 470>
        }
        // adj: if articulation_mask:                                                             <L 469>
        if (var_6) {
            label0:;
            // adj: return  # Invalid articulation index                                          <L 466>
        }
        if (!var_6) {
        }
        // adj: if articulation_id < 0 or articulation_id >= articulation_count:                  <L 465>
        wp::adj_where(var_articulation_indices, var_2, var_4, adj_articulation_indices, adj_2, adj_4, adj_5);
        if (!var_articulation_indices) {
            wp::adj_copy(var_0, adj_0, adj_4);
            // adj: articulation_id = tid                                                         <L 462>
        }
        if (var_articulation_indices) {
            wp::adj_copy(var_3, adj_1, adj_2);
            wp::adj_address(var_articulation_indices, var_0, adj_articulation_indices, adj_0, adj_1);
            // adj: articulation_id = articulation_indices[tid]                                   <L 459>
        }
        // adj: if articulation_indices:                                                          <L 457>
        // adj: tid = wp.tid()                                                                    <L 454>
        // adj: def eval_articulation_fk(                                                         <L 427>
        continue;
    }
}



extern "C" __global__ void compute_shape_world_transforms_6d10d931_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::transform_t<wp::float32>> var_shape_transform,
    wp::array_t<wp::int32> var_shape_body,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::transform_t<wp::float32>> var_shape_world_transform)
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
        wp::transform_t<wp::float32>* var_1;
        wp::transform_t<wp::float32> var_2;
        wp::transform_t<wp::float32> var_3;
        wp::int32* var_4;
        wp::int32 var_5;
        wp::int32 var_6;
        const wp::int32 var_7 = 0;
        bool var_8;
        wp::transform_t<wp::float32>* var_9;
        wp::transform_t<wp::float32> var_10;
        wp::transform_t<wp::float32> var_11;
        wp::transform_t<wp::float32> var_12;
        //---------
        // forward
        // def compute_shape_world_transforms(                                                    <L 577>
        // shape_idx = wp.tid()                                                                   <L 595>
        var_0 = builtin_tid1d();
        // X_bs = shape_transform[shape_idx]                                                      <L 598>
        var_1 = wp::address(var_shape_transform, var_0);
        var_3 = wp::load(var_1);
        var_2 = wp::copy(var_3);
        // body_idx = shape_body[shape_idx]                                                       <L 601>
        var_4 = wp::address(var_shape_body, var_0);
        var_6 = wp::load(var_4);
        var_5 = wp::copy(var_6);
        // if body_idx >= 0:                                                                      <L 604>
        var_8 = (var_5 >= var_7);
        if (var_8) {
            // X_wb = body_q[body_idx]                                                            <L 606>
            var_9 = wp::address(var_body_q, var_5);
            var_11 = wp::load(var_9);
            var_10 = wp::copy(var_11);
            // X_ws = wp.transform_multiply(X_wb, X_bs)                                           <L 609>
            var_12 = wp::transform_multiply(var_10, var_2);
            // shape_world_transform[shape_idx] = X_ws                                            <L 610>
            wp::array_store(var_shape_world_transform, var_0, var_12);
        }
        if (!var_8) {
            // shape_world_transform[shape_idx] = X_bs                                            <L 614>
            wp::array_store(var_shape_world_transform, var_0, var_2);
        }
    }
}



extern "C" __global__ void compute_shape_world_transforms_6d10d931_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::transform_t<wp::float32>> var_shape_transform,
    wp::array_t<wp::int32> var_shape_body,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::transform_t<wp::float32>> var_shape_world_transform,
    wp::array_t<wp::transform_t<wp::float32>> adj_shape_transform,
    wp::array_t<wp::int32> adj_shape_body,
    wp::array_t<wp::transform_t<wp::float32>> adj_body_q,
    wp::array_t<wp::transform_t<wp::float32>> adj_shape_world_transform)
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
        wp::transform_t<wp::float32>* var_1;
        wp::transform_t<wp::float32> var_2;
        wp::transform_t<wp::float32> var_3;
        wp::int32* var_4;
        wp::int32 var_5;
        wp::int32 var_6;
        const wp::int32 var_7 = 0;
        bool var_8;
        wp::transform_t<wp::float32>* var_9;
        wp::transform_t<wp::float32> var_10;
        wp::transform_t<wp::float32> var_11;
        wp::transform_t<wp::float32> var_12;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::transform_t<wp::float32> adj_1 = {};
        wp::transform_t<wp::float32> adj_2 = {};
        wp::transform_t<wp::float32> adj_3 = {};
        wp::int32 adj_4 = {};
        wp::int32 adj_5 = {};
        wp::int32 adj_6 = {};
        wp::int32 adj_7 = {};
        bool adj_8 = {};
        wp::transform_t<wp::float32> adj_9 = {};
        wp::transform_t<wp::float32> adj_10 = {};
        wp::transform_t<wp::float32> adj_11 = {};
        wp::transform_t<wp::float32> adj_12 = {};
        //---------
        // forward
        // def compute_shape_world_transforms(                                                    <L 577>
        // shape_idx = wp.tid()                                                                   <L 595>
        var_0 = builtin_tid1d();
        // X_bs = shape_transform[shape_idx]                                                      <L 598>
        var_1 = wp::address(var_shape_transform, var_0);
        var_3 = wp::load(var_1);
        var_2 = wp::copy(var_3);
        // body_idx = shape_body[shape_idx]                                                       <L 601>
        var_4 = wp::address(var_shape_body, var_0);
        var_6 = wp::load(var_4);
        var_5 = wp::copy(var_6);
        // if body_idx >= 0:                                                                      <L 604>
        var_8 = (var_5 >= var_7);
        if (var_8) {
            // X_wb = body_q[body_idx]                                                            <L 606>
            var_9 = wp::address(var_body_q, var_5);
            var_11 = wp::load(var_9);
            var_10 = wp::copy(var_11);
            // X_ws = wp.transform_multiply(X_wb, X_bs)                                           <L 609>
            var_12 = wp::transform_multiply(var_10, var_2);
            // shape_world_transform[shape_idx] = X_ws                                            <L 610>
            // wp::array_store(var_shape_world_transform, var_0, var_12);
        }
        if (!var_8) {
            // shape_world_transform[shape_idx] = X_bs                                            <L 614>
            // wp::array_store(var_shape_world_transform, var_0, var_2);
        }
        //---------
        // reverse
        if (!var_8) {
            wp::adj_array_store(var_shape_world_transform, var_0, var_2, adj_shape_world_transform, adj_0, adj_2);
            // adj: shape_world_transform[shape_idx] = X_bs                                       <L 614>
        }
        if (var_8) {
            wp::adj_array_store(var_shape_world_transform, var_0, var_12, adj_shape_world_transform, adj_0, adj_12);
            // adj: shape_world_transform[shape_idx] = X_ws                                       <L 610>
            wp::adj_transform_multiply(var_10, var_2, adj_10, adj_2, adj_12);
            // adj: X_ws = wp.transform_multiply(X_wb, X_bs)                                      <L 609>
            wp::adj_copy(var_11, adj_9, adj_10);
            wp::adj_address(var_body_q, var_5, adj_body_q, adj_5, adj_9);
            // adj: X_wb = body_q[body_idx]                                                       <L 606>
        }
        // adj: if body_idx >= 0:                                                                 <L 604>
        wp::adj_copy(var_6, adj_4, adj_5);
        wp::adj_address(var_shape_body, var_0, adj_shape_body, adj_0, adj_4);
        // adj: body_idx = shape_body[shape_idx]                                                  <L 601>
        wp::adj_copy(var_3, adj_1, adj_2);
        wp::adj_address(var_shape_transform, var_0, adj_shape_transform, adj_0, adj_1);
        // adj: X_bs = shape_transform[shape_idx]                                                 <L 598>
        // adj: shape_idx = wp.tid()                                                              <L 595>
        // adj: def compute_shape_world_transforms(                                               <L 577>
        continue;
    }
}



extern "C" __global__ void eval_articulation_ik_95f9da1d_cuda_kernel_forward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::int32> var_articulation_start,
    wp::array_t<wp::int32> var_articulation_end,
    wp::int32 var_articulation_count,
    wp::array_t<bool> var_articulation_mask,
    wp::array_t<wp::int32> var_articulation_indices,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::vec_t<6, wp::float32>> var_body_qd,
    wp::array_t<wp::vec_t<3, wp::float32>> var_body_com,
    wp::array_t<wp::int32> var_joint_type,
    wp::array_t<wp::int32> var_joint_parent,
    wp::array_t<wp::int32> var_joint_child,
    wp::array_t<wp::transform_t<wp::float32>> var_joint_X_p,
    wp::array_t<wp::transform_t<wp::float32>> var_joint_X_c,
    wp::array_t<wp::vec_t<3, wp::float32>> var_joint_axis,
    wp::array_t<wp::int32> var_joint_dof_dim,
    wp::array_t<wp::int32> var_joint_q_start,
    wp::array_t<wp::int32> var_joint_qd_start,
    wp::array_t<wp::int32> var_body_flags,
    wp::int32 var_body_flag_filter,
    wp::array_t<wp::float32> var_joint_q,
    wp::array_t<wp::float32> var_joint_qd)
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
        wp::int32 var_5;
        wp::int32 var_6;
        bool var_7;
        const wp::int32 var_8 = 0;
        bool var_9;
        bool var_10;
        bool* var_11;
        bool var_12;
        bool var_13;
        wp::int32* var_14;
        wp::int32 var_15;
        wp::int32 var_16;
        wp::int32* var_17;
        wp::int32 var_18;
        wp::int32 var_19;
        wp::int32 var_20;
        bool var_21;
        wp::int32* var_22;
        wp::int32 var_23;
        wp::int32 var_24;
        wp::int32* var_25;
        wp::int32 var_26;
        wp::int32 var_27;
        wp::int32* var_28;
        wp::int32 var_29;
        wp::int32 var_30;
        const wp::int32 var_31 = 0;
        bool var_32;
        wp::transform_t<wp::float32>* var_33;
        wp::transform_t<wp::float32> var_34;
        wp::transform_t<wp::float32> var_35;
        wp::transform_t<wp::float32>* var_36;
        wp::transform_t<wp::float32> var_37;
        wp::transform_t<wp::float32> var_38;
        wp::vec_t<3, wp::float32> var_39;
        wp::vec_t<3, wp::float32> var_40;
        wp::vec_t<6, wp::float32> var_41;
        wp::transform_t<wp::float32> var_42;
        const wp::int32 var_43 = 0;
        bool var_44;
        wp::transform_t<wp::float32>* var_45;
        wp::transform_t<wp::float32> var_46;
        wp::transform_t<wp::float32> var_47;
        wp::transform_t<wp::float32> var_48;
        wp::vec_t<6, wp::float32>* var_49;
        wp::vec_t<6, wp::float32> var_50;
        wp::vec_t<6, wp::float32> var_51;
        wp::vec_t<3, wp::float32> var_52;
        wp::vec_t<3, wp::float32>* var_53;
        wp::vec_t<3, wp::float32> var_54;
        wp::vec_t<3, wp::float32> var_55;
        wp::vec_t<3, wp::float32> var_56;
        wp::vec_t<3, wp::float32> var_57;
        wp::vec_t<3, wp::float32> var_58;
        wp::vec_t<6, wp::float32> var_59;
        wp::transform_t<wp::float32> var_60;
        wp::transform_t<wp::float32>* var_61;
        wp::transform_t<wp::float32> var_62;
        wp::transform_t<wp::float32> var_63;
        wp::transform_t<wp::float32> var_64;
        wp::vec_t<6, wp::float32>* var_65;
        wp::vec_t<6, wp::float32> var_66;
        wp::vec_t<6, wp::float32> var_67;
        wp::vec_t<3, wp::float32> var_68;
        wp::vec_t<3, wp::float32>* var_69;
        wp::vec_t<3, wp::float32> var_70;
        wp::vec_t<3, wp::float32> var_71;
        wp::vec_t<3, wp::float32> var_72;
        wp::int32* var_73;
        wp::int32 var_74;
        wp::int32 var_75;
        wp::vec_t<3, wp::float32> var_76;
        wp::vec_t<3, wp::float32> var_77;
        wp::quat_t<wp::float32> var_78;
        wp::quat_t<wp::float32> var_79;
        wp::vec_t<3, wp::float32> var_80;
        wp::vec_t<3, wp::float32> var_81;
        wp::vec_t<3, wp::float32> var_82;
        wp::int32* var_83;
        wp::int32 var_84;
        wp::int32 var_85;
        wp::int32* var_86;
        wp::int32 var_87;
        wp::int32 var_88;
        const wp::int32 var_89 = 0;
        wp::int32* var_90;
        wp::int32 var_91;
        wp::int32 var_92;
        const wp::int32 var_93 = 1;
        wp::int32* var_94;
        wp::int32 var_95;
        wp::int32 var_96;
        const wp::int32 var_97 = 0;
        bool var_98;
        wp::vec_t<3, wp::float32>* var_99;
        wp::vec_t<3, wp::float32> var_100;
        wp::vec_t<3, wp::float32> var_101;
        wp::vec_t<3, wp::float32> var_102;
        wp::float32 var_103;
        wp::float32 var_104;
        const wp::int32 var_105 = 1;
        bool var_106;
        wp::vec_t<3, wp::float32>* var_107;
        wp::vec_t<3, wp::float32> var_108;
        wp::vec_t<3, wp::float32> var_109;
        wp::quat_t<wp::float32> var_110;
        wp::quat_t<wp::float32> var_111;
        wp::float32 var_112;
        wp::float32 var_113;
        wp::vec_t<3, wp::float32> var_114;
        wp::float32 var_115;
        wp::float32 var_116;
        const wp::int32 var_117 = 2;
        bool var_118;
        wp::quat_t<wp::float32> var_119;
        wp::quat_t<wp::float32> var_120;
        const wp::int32 var_121 = 0;
        wp::float32 var_122;
        const wp::int32 var_123 = 0;
        wp::int32 var_124;
        const wp::int32 var_125 = 1;
        wp::float32 var_126;
        const wp::int32 var_127 = 1;
        wp::int32 var_128;
        const wp::int32 var_129 = 2;
        wp::float32 var_130;
        const wp::int32 var_131 = 2;
        wp::int32 var_132;
        const wp::int32 var_133 = 3;
        wp::float32 var_134;
        const wp::int32 var_135 = 3;
        wp::int32 var_136;
        wp::transform_t<wp::float32> var_137;
        wp::vec_t<3, wp::float32> var_138;
        const wp::int32 var_139 = 0;
        wp::float32 var_140;
        const wp::int32 var_141 = 0;
        wp::int32 var_142;
        const wp::int32 var_143 = 1;
        wp::float32 var_144;
        const wp::int32 var_145 = 1;
        wp::int32 var_146;
        const wp::int32 var_147 = 2;
        wp::float32 var_148;
        const wp::int32 var_149 = 2;
        wp::int32 var_150;
        wp::quat_t<wp::float32> var_151;
        const wp::int32 var_152 = 3;
        bool var_153;
        bool var_154;
        const wp::int32 var_155 = 4;
        bool var_156;
        const wp::int32 var_157 = 5;
        bool var_158;
        wp::quat_t<wp::float32> var_159;
        wp::quat_t<wp::float32> var_160;
        wp::vec_t<3, wp::float32> var_161;
        wp::vec_t<3, wp::float32>* var_162;
        wp::vec_t<3, wp::float32> var_163;
        wp::vec_t<3, wp::float32> var_164;
        wp::vec_t<3, wp::float32> var_165;
        const wp::int32 var_166 = 0;
        bool var_167;
        wp::vec_t<3, wp::float32>* var_168;
        wp::vec_t<3, wp::float32> var_169;
        wp::vec_t<3, wp::float32> var_170;
        wp::vec_t<3, wp::float32> var_171;
        wp::vec_t<3, wp::float32> var_172;
        wp::vec_t<3, wp::float32> var_173;
        wp::vec_t<3, wp::float32> var_174;
        const wp::int32 var_175 = 0;
        wp::float32 var_176;
        const wp::int32 var_177 = 0;
        wp::int32 var_178;
        const wp::int32 var_179 = 1;
        wp::float32 var_180;
        const wp::int32 var_181 = 1;
        wp::int32 var_182;
        const wp::int32 var_183 = 2;
        wp::float32 var_184;
        const wp::int32 var_185 = 2;
        wp::int32 var_186;
        const wp::int32 var_187 = 0;
        wp::float32 var_188;
        const wp::int32 var_189 = 3;
        wp::int32 var_190;
        const wp::int32 var_191 = 1;
        wp::float32 var_192;
        const wp::int32 var_193 = 4;
        wp::int32 var_194;
        const wp::int32 var_195 = 2;
        wp::float32 var_196;
        const wp::int32 var_197 = 5;
        wp::int32 var_198;
        const wp::int32 var_199 = 3;
        wp::float32 var_200;
        const wp::int32 var_201 = 6;
        wp::int32 var_202;
        const wp::int32 var_203 = 0;
        wp::float32 var_204;
        const wp::int32 var_205 = 0;
        wp::int32 var_206;
        const wp::int32 var_207 = 1;
        wp::float32 var_208;
        const wp::int32 var_209 = 1;
        wp::int32 var_210;
        const wp::int32 var_211 = 2;
        wp::float32 var_212;
        const wp::int32 var_213 = 2;
        wp::int32 var_214;
        const wp::int32 var_215 = 0;
        wp::float32 var_216;
        const wp::int32 var_217 = 3;
        wp::int32 var_218;
        const wp::int32 var_219 = 1;
        wp::float32 var_220;
        const wp::int32 var_221 = 4;
        wp::int32 var_222;
        const wp::int32 var_223 = 2;
        wp::float32 var_224;
        const wp::int32 var_225 = 5;
        wp::int32 var_226;
        wp::quat_t<wp::float32> var_227;
        const wp::int32 var_228 = 6;
        bool var_229;
        wp::vec_t<3, wp::float32> var_230;
        wp::vec_t<3, wp::float32> var_231;
        const wp::int32 var_232 = 0;
        bool var_233;
        const wp::int32 var_234 = 0;
        wp::int32 var_235;
        wp::vec_t<3, wp::float32>* var_236;
        wp::vec_t<3, wp::float32> var_237;
        wp::vec_t<3, wp::float32> var_238;
        wp::float32 var_239;
        const wp::int32 var_240 = 0;
        wp::int32 var_241;
        wp::float32 var_242;
        const wp::int32 var_243 = 0;
        wp::int32 var_244;
        wp::vec_t<3, wp::float32> var_245;
        const wp::int32 var_246 = 1;
        bool var_247;
        const wp::int32 var_248 = 1;
        wp::int32 var_249;
        wp::vec_t<3, wp::float32>* var_250;
        wp::vec_t<3, wp::float32> var_251;
        wp::vec_t<3, wp::float32> var_252;
        wp::float32 var_253;
        const wp::int32 var_254 = 1;
        wp::int32 var_255;
        wp::float32 var_256;
        const wp::int32 var_257 = 1;
        wp::int32 var_258;
        wp::vec_t<3, wp::float32> var_259;
        const wp::int32 var_260 = 2;
        bool var_261;
        const wp::int32 var_262 = 2;
        wp::int32 var_263;
        wp::vec_t<3, wp::float32>* var_264;
        wp::vec_t<3, wp::float32> var_265;
        wp::vec_t<3, wp::float32> var_266;
        wp::float32 var_267;
        const wp::int32 var_268 = 2;
        wp::int32 var_269;
        wp::float32 var_270;
        const wp::int32 var_271 = 2;
        wp::int32 var_272;
        wp::vec_t<3, wp::float32> var_273;
        const wp::int32 var_274 = 1;
        bool var_275;
        wp::vec_t<3, wp::float32>* var_276;
        wp::vec_t<3, wp::float32> var_277;
        wp::vec_t<3, wp::float32> var_278;
        wp::quat_t<wp::float32> var_279;
        wp::quat_t<wp::float32> var_280;
        wp::int32 var_281;
        wp::vec_t<3, wp::float32>* var_282;
        wp::float32 var_283;
        wp::float32 var_284;
        wp::vec_t<3, wp::float32> var_285;
        wp::int32 var_286;
        wp::int32 var_287;
        wp::vec_t<3, wp::float32> var_288;
        wp::float32 var_289;
        wp::float32 var_290;
        wp::quat_t<wp::float32> var_291;
        const wp::int32 var_292 = 2;
        bool var_293;
        wp::int32 var_294;
        const wp::int32 var_295 = 0;
        wp::int32 var_296;
        wp::vec_t<3, wp::float32>* var_297;
        wp::vec_t<3, wp::float32> var_298;
        wp::vec_t<3, wp::float32> var_299;
        wp::int32 var_300;
        const wp::int32 var_301 = 1;
        wp::int32 var_302;
        wp::vec_t<3, wp::float32>* var_303;
        wp::vec_t<3, wp::float32> var_304;
        wp::vec_t<3, wp::float32> var_305;
        wp::vec_t<2, wp::float32> var_306;
        wp::vec_t<2, wp::float32> var_307;
        const wp::int32 var_308 = 0;
        wp::float32 var_309;
        wp::int32 var_310;
        const wp::int32 var_311 = 0;
        wp::int32 var_312;
        const wp::int32 var_313 = 1;
        wp::float32 var_314;
        wp::int32 var_315;
        const wp::int32 var_316 = 1;
        wp::int32 var_317;
        const wp::int32 var_318 = 0;
        wp::float32 var_319;
        wp::int32 var_320;
        const wp::int32 var_321 = 0;
        wp::int32 var_322;
        const wp::int32 var_323 = 1;
        wp::float32 var_324;
        wp::int32 var_325;
        const wp::int32 var_326 = 1;
        wp::int32 var_327;
        const wp::int32 var_328 = 3;
        bool var_329;
        wp::int32 var_330;
        const wp::int32 var_331 = 0;
        wp::int32 var_332;
        wp::vec_t<3, wp::float32>* var_333;
        wp::vec_t<3, wp::float32> var_334;
        wp::vec_t<3, wp::float32> var_335;
        wp::int32 var_336;
        const wp::int32 var_337 = 1;
        wp::int32 var_338;
        wp::vec_t<3, wp::float32>* var_339;
        wp::vec_t<3, wp::float32> var_340;
        wp::vec_t<3, wp::float32> var_341;
        wp::int32 var_342;
        const wp::int32 var_343 = 2;
        wp::int32 var_344;
        wp::vec_t<3, wp::float32>* var_345;
        wp::vec_t<3, wp::float32> var_346;
        wp::vec_t<3, wp::float32> var_347;
        wp::vec_t<3, wp::float32> var_348;
        wp::vec_t<3, wp::float32> var_349;
        const wp::int32 var_350 = 0;
        wp::float32 var_351;
        wp::int32 var_352;
        const wp::int32 var_353 = 0;
        wp::int32 var_354;
        const wp::int32 var_355 = 1;
        wp::float32 var_356;
        wp::int32 var_357;
        const wp::int32 var_358 = 1;
        wp::int32 var_359;
        const wp::int32 var_360 = 2;
        wp::float32 var_361;
        wp::int32 var_362;
        const wp::int32 var_363 = 2;
        wp::int32 var_364;
        const wp::int32 var_365 = 0;
        wp::float32 var_366;
        wp::int32 var_367;
        const wp::int32 var_368 = 0;
        wp::int32 var_369;
        const wp::int32 var_370 = 1;
        wp::float32 var_371;
        wp::int32 var_372;
        const wp::int32 var_373 = 1;
        wp::int32 var_374;
        const wp::int32 var_375 = 2;
        wp::float32 var_376;
        wp::int32 var_377;
        const wp::int32 var_378 = 2;
        wp::int32 var_379;
        wp::vec_t<3, wp::float32> var_380;
        wp::vec_t<3, wp::float32> var_381;
        wp::vec_t<3, wp::float32> var_382;
        wp::float32 var_383;
        wp::float32 var_384;
        wp::quat_t<wp::float32> var_385;
        wp::vec_t<3, wp::float32> var_386;
        wp::vec_t<3, wp::float32> var_387;
        //---------
        // forward
        // def eval_articulation_ik(                                                              <L 640>
        // art_idx, joint_offset = wp.tid()  # articulation index and joint offset within articulation       <L 663>
        builtin_tid2d(var_0, var_1);
        // if articulation_indices:                                                               <L 666>
        if (var_articulation_indices) {
            // articulation_id = articulation_indices[art_idx]                                    <L 667>
            var_2 = wp::address(var_articulation_indices, var_0);
            var_4 = wp::load(var_2);
            var_3 = wp::copy(var_4);
        }
        if (!var_articulation_indices) {
            // articulation_id = art_idx                                                          <L 669>
            var_5 = wp::copy(var_0);
        }
        var_6 = wp::where(var_articulation_indices, var_3, var_5);
        // if articulation_id < 0 or articulation_id >= articulation_count:                       <L 672>
        var_9 = (var_6 < var_8);
        var_7 = var_9;
        if (!var_7) {
            var_10 = (var_6 >= var_articulation_count);
            var_7 = var_7 || var_10;
        }
        if (var_7) {
            // return  # Invalid articulation index                                               <L 673>
            continue;
        }
        // if articulation_mask:                                                                  <L 676>
        if (var_articulation_mask) {
            // if not articulation_mask[articulation_id]:                                         <L 677>
            var_11 = wp::address(var_articulation_mask, var_6);
            var_13 = wp::load(var_11);
            var_12 = wp::unot(var_13);
            if (var_12) {
                // return                                                                         <L 678>
                continue;
            }
        }
        // joint_start = articulation_start[articulation_id]                                      <L 681>
        var_14 = wp::address(var_articulation_start, var_6);
        var_16 = wp::load(var_14);
        var_15 = wp::copy(var_16);
        // joint_end = articulation_end[articulation_id]                                          <L 682>
        var_17 = wp::address(var_articulation_end, var_6);
        var_19 = wp::load(var_17);
        var_18 = wp::copy(var_19);
        // joint_idx = joint_start + joint_offset                                                 <L 685>
        var_20 = wp::add(var_15, var_1);
        // if joint_idx >= joint_end:                                                             <L 686>
        var_21 = (var_20 >= var_18);
        if (var_21) {
            // return  # This thread has no joint (padding thread)                                <L 687>
            continue;
        }
        // parent = joint_parent[joint_idx]                                                       <L 689>
        var_22 = wp::address(var_joint_parent, var_20);
        var_24 = wp::load(var_22);
        var_23 = wp::copy(var_24);
        // child = joint_child[joint_idx]                                                         <L 690>
        var_25 = wp::address(var_joint_child, var_20);
        var_27 = wp::load(var_25);
        var_26 = wp::copy(var_27);
        // if (body_flags[child] & body_flag_filter) == 0:                                        <L 691>
        var_28 = wp::address(var_body_flags, var_26);
        var_30 = wp::load(var_28);
        var_29 = wp::bit_and(var_30, var_body_flag_filter);
        var_32 = (var_29 == var_31);
        if (var_32) {
            // return                                                                             <L 692>
            continue;
        }
        // X_pj = joint_X_p[joint_idx]                                                            <L 694>
        var_33 = wp::address(var_joint_X_p, var_20);
        var_35 = wp::load(var_33);
        var_34 = wp::copy(var_35);
        // X_cj = joint_X_c[joint_idx]                                                            <L 695>
        var_36 = wp::address(var_joint_X_c, var_20);
        var_38 = wp::load(var_36);
        var_37 = wp::copy(var_38);
        // w_p = wp.vec3()                                                                        <L 697>
        var_39 = wp::vec_t<3, wp::float32>();
        // v_p = wp.vec3()                                                                        <L 698>
        var_40 = wp::vec_t<3, wp::float32>();
        // v_wp = wp.spatial_vector()                                                             <L 699>
        var_41 = wp::vec_t<6, wp::float32>();
        // X_wpj = X_pj                                                                           <L 702>
        var_42 = wp::copy(var_34);
        // if parent >= 0:                                                                        <L 703>
        var_44 = (var_23 >= var_43);
        if (var_44) {
            // X_wp = body_q[parent]                                                              <L 704>
            var_45 = wp::address(var_body_q, var_23);
            var_47 = wp::load(var_45);
            var_46 = wp::copy(var_47);
            // X_wpj = X_wp * X_pj                                                                <L 705>
            var_48 = wp::mul(var_46, var_34);
            // v_wp = body_qd[parent]                                                             <L 707>
            var_49 = wp::address(var_body_qd, var_23);
            var_51 = wp::load(var_49);
            var_50 = wp::copy(var_51);
            // w_p = wp.spatial_bottom(v_wp)                                                      <L 708>
            var_52 = wp::spatial_bottom(var_50);
            // v_p = com_twist_to_point_velocity(v_wp, X_wp, body_com[parent], wp.transform_get_translation(X_wpj))       <L 709>
            var_53 = wp::address(var_body_com, var_23);
            var_54 = wp::transform_get_translation(var_48);
            var_56 = wp::load(var_53);
            var_55 = com_twist_to_point_velocity_0(var_50, var_46, var_56, var_54);
        }
        var_57 = wp::where(var_44, var_52, var_39);
        var_58 = wp::where(var_44, var_55, var_40);
        var_59 = wp::where(var_44, var_50, var_41);
        var_60 = wp::where(var_44, var_48, var_42);
        // X_wc = body_q[child]                                                                   <L 712>
        var_61 = wp::address(var_body_q, var_26);
        var_63 = wp::load(var_61);
        var_62 = wp::copy(var_63);
        // X_wcj = X_wc * X_cj                                                                    <L 713>
        var_64 = wp::mul(var_62, var_37);
        // v_wc = body_qd[child]                                                                  <L 715>
        var_65 = wp::address(var_body_qd, var_26);
        var_67 = wp::load(var_65);
        var_66 = wp::copy(var_67);
        // w_c = wp.spatial_bottom(v_wc)                                                          <L 717>
        var_68 = wp::spatial_bottom(var_66);
        // v_c = com_twist_to_point_velocity(v_wc, X_wc, body_com[child], wp.transform_get_translation(X_wcj))       <L 718>
        var_69 = wp::address(var_body_com, var_26);
        var_70 = wp::transform_get_translation(var_64);
        var_72 = wp::load(var_69);
        var_71 = com_twist_to_point_velocity_0(var_66, var_62, var_72, var_70);
        // type = joint_type[joint_idx]                                                           <L 721>
        var_73 = wp::address(var_joint_type, var_20);
        var_75 = wp::load(var_73);
        var_74 = wp::copy(var_75);
        // x_p = wp.transform_get_translation(X_wpj)                                              <L 724>
        var_76 = wp::transform_get_translation(var_60);
        // x_c = wp.transform_get_translation(X_wcj)                                              <L 725>
        var_77 = wp::transform_get_translation(var_64);
        // q_p = wp.transform_get_rotation(X_wpj)                                                 <L 727>
        var_78 = wp::transform_get_rotation(var_60);
        // q_c = wp.transform_get_rotation(X_wcj)                                                 <L 728>
        var_79 = wp::transform_get_rotation(var_64);
        // x_err = x_c - x_p                                                                      <L 730>
        var_80 = wp::sub(var_77, var_76);
        // v_err = v_c - v_p                                                                      <L 731>
        var_81 = wp::sub(var_71, var_58);
        // w_err = w_c - w_p                                                                      <L 732>
        var_82 = wp::sub(var_68, var_57);
        // q_start = joint_q_start[joint_idx]                                                     <L 734>
        var_83 = wp::address(var_joint_q_start, var_20);
        var_85 = wp::load(var_83);
        var_84 = wp::copy(var_85);
        // qd_start = joint_qd_start[joint_idx]                                                   <L 735>
        var_86 = wp::address(var_joint_qd_start, var_20);
        var_88 = wp::load(var_86);
        var_87 = wp::copy(var_88);
        // lin_axis_count = joint_dof_dim[joint_idx, 0]                                           <L 736>
        var_90 = wp::address(var_joint_dof_dim, var_20, var_89);
        var_92 = wp::load(var_90);
        var_91 = wp::copy(var_92);
        // ang_axis_count = joint_dof_dim[joint_idx, 1]                                           <L 737>
        var_94 = wp::address(var_joint_dof_dim, var_20, var_93);
        var_96 = wp::load(var_94);
        var_95 = wp::copy(var_96);
        // if type == JointType.PRISMATIC:                                                        <L 739>
        var_98 = (var_74 == var_97);
        if (var_98) {
            // axis = joint_axis[qd_start]                                                        <L 740>
            var_99 = wp::address(var_joint_axis, var_87);
            var_101 = wp::load(var_99);
            var_100 = wp::copy(var_101);
            // axis_p = wp.quat_rotate(q_p, axis)                                                 <L 743>
            var_102 = wp::quat_rotate(var_78, var_100);
            // q = wp.dot(x_err, axis_p)                                                          <L 746>
            var_103 = wp::dot(var_80, var_102);
            // qd = wp.dot(v_err, axis_p)                                                         <L 747>
            var_104 = wp::dot(var_81, var_102);
            // joint_q[q_start] = q                                                               <L 749>
            wp::array_store(var_joint_q, var_84, var_103);
            // joint_qd[qd_start] = qd                                                            <L 750>
            wp::array_store(var_joint_qd, var_87, var_104);
            // return                                                                             <L 752>
            continue;
        }
        // if type == JointType.REVOLUTE:                                                         <L 754>
        var_106 = (var_74 == var_105);
        if (var_106) {
            // axis = joint_axis[qd_start]                                                        <L 755>
            var_107 = wp::address(var_joint_axis, var_87);
            var_109 = wp::load(var_107);
            var_108 = wp::copy(var_109);
            // q_pc = wp.quat_inverse(q_p) * q_c                                                  <L 756>
            var_110 = wp::quat_inverse(var_78);
            var_111 = wp::mul(var_110, var_79);
            // q, qd = reconstruct_angular_q_qd(q_pc, w_err, X_wpj, axis)                         <L 758>
            reconstruct_angular_q_qd_0(var_111, var_82, var_60, var_108, var_112, var_113);
            // joint_q[q_start] = q                                                               <L 760>
            wp::array_store(var_joint_q, var_84, var_112);
            // joint_qd[qd_start] = qd                                                            <L 761>
            wp::array_store(var_joint_qd, var_87, var_113);
            // return                                                                             <L 763>
            continue;
        }
        var_114 = wp::where(var_106, var_108, var_100);
        var_115 = wp::where(var_106, var_112, var_103);
        var_116 = wp::where(var_106, var_113, var_104);
        // if type == JointType.BALL:                                                             <L 765>
        var_118 = (var_74 == var_117);
        if (var_118) {
            // q_pc = wp.quat_inverse(q_p) * q_c                                                  <L 766>
            var_119 = wp::quat_inverse(var_78);
            var_120 = wp::mul(var_119, var_79);
            // joint_q[q_start + 0] = q_pc[0]                                                     <L 768>
            var_122 = wp::extract(var_120, var_121);
            var_124 = wp::add(var_84, var_123);
            wp::array_store(var_joint_q, var_124, var_122);
            // joint_q[q_start + 1] = q_pc[1]                                                     <L 769>
            var_126 = wp::extract(var_120, var_125);
            var_128 = wp::add(var_84, var_127);
            wp::array_store(var_joint_q, var_128, var_126);
            // joint_q[q_start + 2] = q_pc[2]                                                     <L 770>
            var_130 = wp::extract(var_120, var_129);
            var_132 = wp::add(var_84, var_131);
            wp::array_store(var_joint_q, var_132, var_130);
            // joint_q[q_start + 3] = q_pc[3]                                                     <L 771>
            var_134 = wp::extract(var_120, var_133);
            var_136 = wp::add(var_84, var_135);
            wp::array_store(var_joint_q, var_136, var_134);
            // ang_vel = wp.transform_vector(wp.transform_inverse(X_wpj), w_err)                  <L 773>
            var_137 = wp::transform_inverse(var_60);
            var_138 = wp::transform_vector(var_137, var_82);
            // joint_qd[qd_start + 0] = ang_vel[0]                                                <L 774>
            var_140 = wp::extract(var_138, var_139);
            var_142 = wp::add(var_87, var_141);
            wp::array_store(var_joint_qd, var_142, var_140);
            // joint_qd[qd_start + 1] = ang_vel[1]                                                <L 775>
            var_144 = wp::extract(var_138, var_143);
            var_146 = wp::add(var_87, var_145);
            wp::array_store(var_joint_qd, var_146, var_144);
            // joint_qd[qd_start + 2] = ang_vel[2]                                                <L 776>
            var_148 = wp::extract(var_138, var_147);
            var_150 = wp::add(var_87, var_149);
            wp::array_store(var_joint_qd, var_150, var_148);
            // return                                                                             <L 778>
            continue;
        }
        var_151 = wp::where(var_118, var_120, var_111);
        // if type == JointType.FIXED:                                                            <L 780>
        var_153 = (var_74 == var_152);
        if (var_153) {
            // return                                                                             <L 781>
            continue;
        }
        // if type == JointType.FREE or type == JointType.DISTANCE:                               <L 783>
        var_156 = (var_74 == var_155);
        var_154 = var_156;
        if (!var_154) {
            var_158 = (var_74 == var_157);
            var_154 = var_154 || var_158;
        }
        if (var_154) {
            // q_pc = wp.quat_inverse(q_p) * q_c                                                  <L 784>
            var_159 = wp::quat_inverse(var_78);
            var_160 = wp::mul(var_159, var_79);
            // x_err_c = wp.quat_rotate_inv(q_p, x_err)                                           <L 786>
            var_161 = wp::quat_rotate_inv(var_78, var_80);
            // x_child_com_world = wp.transform_point(X_wc, body_com[child])                      <L 787>
            var_162 = wp::address(var_body_com, var_26);
            var_164 = wp::load(var_162);
            var_163 = wp::transform_point(var_62, var_164);
            // v_com_err = wp.spatial_top(v_wc)                                                   <L 788>
            var_165 = wp::spatial_top(var_66);
            // if parent >= 0:                                                                    <L 789>
            var_167 = (var_23 >= var_166);
            if (var_167) {
                // v_com_err = v_com_err - com_twist_to_point_velocity(v_wp, X_wp, body_com[parent], x_child_com_world)       <L 790>
                var_168 = wp::address(var_body_com, var_23);
                var_170 = wp::load(var_168);
                var_169 = com_twist_to_point_velocity_0(var_59, var_46, var_170, var_163);
                var_171 = wp::sub(var_165, var_169);
            }
            var_172 = wp::where(var_167, var_171, var_165);
            // v_err_c = wp.quat_rotate_inv(q_p, v_com_err)                                       <L 791>
            var_173 = wp::quat_rotate_inv(var_78, var_172);
            // w_err_c = wp.quat_rotate_inv(q_p, w_err)                                           <L 792>
            var_174 = wp::quat_rotate_inv(var_78, var_82);
            // joint_q[q_start + 0] = x_err_c[0]                                                  <L 794>
            var_176 = wp::extract(var_161, var_175);
            var_178 = wp::add(var_84, var_177);
            wp::array_store(var_joint_q, var_178, var_176);
            // joint_q[q_start + 1] = x_err_c[1]                                                  <L 795>
            var_180 = wp::extract(var_161, var_179);
            var_182 = wp::add(var_84, var_181);
            wp::array_store(var_joint_q, var_182, var_180);
            // joint_q[q_start + 2] = x_err_c[2]                                                  <L 796>
            var_184 = wp::extract(var_161, var_183);
            var_186 = wp::add(var_84, var_185);
            wp::array_store(var_joint_q, var_186, var_184);
            // joint_q[q_start + 3] = q_pc[0]                                                     <L 798>
            var_188 = wp::extract(var_160, var_187);
            var_190 = wp::add(var_84, var_189);
            wp::array_store(var_joint_q, var_190, var_188);
            // joint_q[q_start + 4] = q_pc[1]                                                     <L 799>
            var_192 = wp::extract(var_160, var_191);
            var_194 = wp::add(var_84, var_193);
            wp::array_store(var_joint_q, var_194, var_192);
            // joint_q[q_start + 5] = q_pc[2]                                                     <L 800>
            var_196 = wp::extract(var_160, var_195);
            var_198 = wp::add(var_84, var_197);
            wp::array_store(var_joint_q, var_198, var_196);
            // joint_q[q_start + 6] = q_pc[3]                                                     <L 801>
            var_200 = wp::extract(var_160, var_199);
            var_202 = wp::add(var_84, var_201);
            wp::array_store(var_joint_q, var_202, var_200);
            // joint_qd[qd_start + 0] = v_err_c[0]                                                <L 803>
            var_204 = wp::extract(var_173, var_203);
            var_206 = wp::add(var_87, var_205);
            wp::array_store(var_joint_qd, var_206, var_204);
            // joint_qd[qd_start + 1] = v_err_c[1]                                                <L 804>
            var_208 = wp::extract(var_173, var_207);
            var_210 = wp::add(var_87, var_209);
            wp::array_store(var_joint_qd, var_210, var_208);
            // joint_qd[qd_start + 2] = v_err_c[2]                                                <L 805>
            var_212 = wp::extract(var_173, var_211);
            var_214 = wp::add(var_87, var_213);
            wp::array_store(var_joint_qd, var_214, var_212);
            // joint_qd[qd_start + 3] = w_err_c[0]                                                <L 807>
            var_216 = wp::extract(var_174, var_215);
            var_218 = wp::add(var_87, var_217);
            wp::array_store(var_joint_qd, var_218, var_216);
            // joint_qd[qd_start + 4] = w_err_c[1]                                                <L 808>
            var_220 = wp::extract(var_174, var_219);
            var_222 = wp::add(var_87, var_221);
            wp::array_store(var_joint_qd, var_222, var_220);
            // joint_qd[qd_start + 5] = w_err_c[2]                                                <L 809>
            var_224 = wp::extract(var_174, var_223);
            var_226 = wp::add(var_87, var_225);
            wp::array_store(var_joint_qd, var_226, var_224);
            // return                                                                             <L 811>
            continue;
        }
        var_227 = wp::where(var_154, var_160, var_151);
        // if type == JointType.D6:                                                               <L 813>
        var_229 = (var_74 == var_228);
        if (var_229) {
            // x_err_c = wp.quat_rotate_inv(q_p, x_err)                                           <L 814>
            var_230 = wp::quat_rotate_inv(var_78, var_80);
            // v_err_c = wp.quat_rotate_inv(q_p, v_err)                                           <L 815>
            var_231 = wp::quat_rotate_inv(var_78, var_81);
            // if lin_axis_count > 0:                                                             <L 816>
            var_233 = (var_91 > var_232);
            if (var_233) {
                // axis = joint_axis[qd_start + 0]                                                <L 817>
                var_235 = wp::add(var_87, var_234);
                var_236 = wp::address(var_joint_axis, var_235);
                var_238 = wp::load(var_236);
                var_237 = wp::copy(var_238);
                // joint_q[q_start + 0] = wp.dot(x_err_c, axis)                                   <L 818>
                var_239 = wp::dot(var_230, var_237);
                var_241 = wp::add(var_84, var_240);
                wp::array_store(var_joint_q, var_241, var_239);
                // joint_qd[qd_start + 0] = wp.dot(v_err_c, axis)                                 <L 819>
                var_242 = wp::dot(var_231, var_237);
                var_244 = wp::add(var_87, var_243);
                wp::array_store(var_joint_qd, var_244, var_242);
            }
            var_245 = wp::where(var_233, var_237, var_114);
            // if lin_axis_count > 1:                                                             <L 821>
            var_247 = (var_91 > var_246);
            if (var_247) {
                // axis = joint_axis[qd_start + 1]                                                <L 822>
                var_249 = wp::add(var_87, var_248);
                var_250 = wp::address(var_joint_axis, var_249);
                var_252 = wp::load(var_250);
                var_251 = wp::copy(var_252);
                // joint_q[q_start + 1] = wp.dot(x_err_c, axis)                                   <L 823>
                var_253 = wp::dot(var_230, var_251);
                var_255 = wp::add(var_84, var_254);
                wp::array_store(var_joint_q, var_255, var_253);
                // joint_qd[qd_start + 1] = wp.dot(v_err_c, axis)                                 <L 824>
                var_256 = wp::dot(var_231, var_251);
                var_258 = wp::add(var_87, var_257);
                wp::array_store(var_joint_qd, var_258, var_256);
            }
            var_259 = wp::where(var_247, var_251, var_245);
            // if lin_axis_count > 2:                                                             <L 826>
            var_261 = (var_91 > var_260);
            if (var_261) {
                // axis = joint_axis[qd_start + 2]                                                <L 827>
                var_263 = wp::add(var_87, var_262);
                var_264 = wp::address(var_joint_axis, var_263);
                var_266 = wp::load(var_264);
                var_265 = wp::copy(var_266);
                // joint_q[q_start + 2] = wp.dot(x_err_c, axis)                                   <L 828>
                var_267 = wp::dot(var_230, var_265);
                var_269 = wp::add(var_84, var_268);
                wp::array_store(var_joint_q, var_269, var_267);
                // joint_qd[qd_start + 2] = wp.dot(v_err_c, axis)                                 <L 829>
                var_270 = wp::dot(var_231, var_265);
                var_272 = wp::add(var_87, var_271);
                wp::array_store(var_joint_qd, var_272, var_270);
            }
            var_273 = wp::where(var_261, var_265, var_259);
            // if ang_axis_count == 1:                                                            <L 831>
            var_275 = (var_95 == var_274);
            if (var_275) {
                // axis = joint_axis[qd_start]                                                    <L 832>
                var_276 = wp::address(var_joint_axis, var_87);
                var_278 = wp::load(var_276);
                var_277 = wp::copy(var_278);
                // q_pc = wp.quat_inverse(q_p) * q_c                                              <L 833>
                var_279 = wp::quat_inverse(var_78);
                var_280 = wp::mul(var_279, var_79);
                // q, qd = reconstruct_angular_q_qd(q_pc, w_err, X_wpj, joint_axis[qd_start + lin_axis_count])       <L 834>
                var_281 = wp::add(var_87, var_91);
                var_282 = wp::address(var_joint_axis, var_281);
                var_285 = wp::load(var_282);
                reconstruct_angular_q_qd_0(var_280, var_82, var_60, var_285, var_283, var_284);
                // joint_q[q_start + lin_axis_count] = q                                          <L 835>
                var_286 = wp::add(var_84, var_91);
                wp::array_store(var_joint_q, var_286, var_283);
                // joint_qd[qd_start + lin_axis_count] = qd                                       <L 836>
                var_287 = wp::add(var_87, var_91);
                wp::array_store(var_joint_qd, var_287, var_284);
            }
            var_288 = wp::where(var_275, var_277, var_273);
            var_289 = wp::where(var_275, var_283, var_115);
            var_290 = wp::where(var_275, var_284, var_116);
            var_291 = wp::where(var_275, var_280, var_227);
            // if ang_axis_count == 2:                                                            <L 838>
            var_293 = (var_95 == var_292);
            if (var_293) {
                // axis_0 = joint_axis[qd_start + lin_axis_count + 0]                             <L 839>
                var_294 = wp::add(var_87, var_91);
                var_296 = wp::add(var_294, var_295);
                var_297 = wp::address(var_joint_axis, var_296);
                var_299 = wp::load(var_297);
                var_298 = wp::copy(var_299);
                // axis_1 = joint_axis[qd_start + lin_axis_count + 1]                             <L 840>
                var_300 = wp::add(var_87, var_91);
                var_302 = wp::add(var_300, var_301);
                var_303 = wp::address(var_joint_axis, var_302);
                var_305 = wp::load(var_303);
                var_304 = wp::copy(var_305);
                // qs2, qds2 = invert_2d_rotational_dofs(axis_0, axis_1, q_p, q_c, w_err)         <L 841>
                invert_2d_rotational_dofs_0(var_298, var_304, var_78, var_79, var_82, var_306, var_307);
                // joint_q[q_start + lin_axis_count + 0] = qs2[0]                                 <L 842>
                var_309 = wp::extract(var_306, var_308);
                var_310 = wp::add(var_84, var_91);
                var_312 = wp::add(var_310, var_311);
                wp::array_store(var_joint_q, var_312, var_309);
                // joint_q[q_start + lin_axis_count + 1] = qs2[1]                                 <L 843>
                var_314 = wp::extract(var_306, var_313);
                var_315 = wp::add(var_84, var_91);
                var_317 = wp::add(var_315, var_316);
                wp::array_store(var_joint_q, var_317, var_314);
                // joint_qd[qd_start + lin_axis_count + 0] = qds2[0]                              <L 844>
                var_319 = wp::extract(var_307, var_318);
                var_320 = wp::add(var_87, var_91);
                var_322 = wp::add(var_320, var_321);
                wp::array_store(var_joint_qd, var_322, var_319);
                // joint_qd[qd_start + lin_axis_count + 1] = qds2[1]                              <L 845>
                var_324 = wp::extract(var_307, var_323);
                var_325 = wp::add(var_87, var_91);
                var_327 = wp::add(var_325, var_326);
                wp::array_store(var_joint_qd, var_327, var_324);
            }
            // if ang_axis_count == 3:                                                            <L 847>
            var_329 = (var_95 == var_328);
            if (var_329) {
                // axis_0 = joint_axis[qd_start + lin_axis_count + 0]                             <L 848>
                var_330 = wp::add(var_87, var_91);
                var_332 = wp::add(var_330, var_331);
                var_333 = wp::address(var_joint_axis, var_332);
                var_335 = wp::load(var_333);
                var_334 = wp::copy(var_335);
                // axis_1 = joint_axis[qd_start + lin_axis_count + 1]                             <L 849>
                var_336 = wp::add(var_87, var_91);
                var_338 = wp::add(var_336, var_337);
                var_339 = wp::address(var_joint_axis, var_338);
                var_341 = wp::load(var_339);
                var_340 = wp::copy(var_341);
                // axis_2 = joint_axis[qd_start + lin_axis_count + 2]                             <L 850>
                var_342 = wp::add(var_87, var_91);
                var_344 = wp::add(var_342, var_343);
                var_345 = wp::address(var_joint_axis, var_344);
                var_347 = wp::load(var_345);
                var_346 = wp::copy(var_347);
                // qs3, qds3 = invert_3d_rotational_dofs(axis_0, axis_1, axis_2, q_p, q_c, w_err)       <L 851>
                invert_3d_rotational_dofs_0(var_334, var_340, var_346, var_78, var_79, var_82, var_348, var_349);
                // joint_q[q_start + lin_axis_count + 0] = qs3[0]                                 <L 852>
                var_351 = wp::extract(var_348, var_350);
                var_352 = wp::add(var_84, var_91);
                var_354 = wp::add(var_352, var_353);
                wp::array_store(var_joint_q, var_354, var_351);
                // joint_q[q_start + lin_axis_count + 1] = qs3[1]                                 <L 853>
                var_356 = wp::extract(var_348, var_355);
                var_357 = wp::add(var_84, var_91);
                var_359 = wp::add(var_357, var_358);
                wp::array_store(var_joint_q, var_359, var_356);
                // joint_q[q_start + lin_axis_count + 2] = qs3[2]                                 <L 854>
                var_361 = wp::extract(var_348, var_360);
                var_362 = wp::add(var_84, var_91);
                var_364 = wp::add(var_362, var_363);
                wp::array_store(var_joint_q, var_364, var_361);
                // joint_qd[qd_start + lin_axis_count + 0] = qds3[0]                              <L 855>
                var_366 = wp::extract(var_349, var_365);
                var_367 = wp::add(var_87, var_91);
                var_369 = wp::add(var_367, var_368);
                wp::array_store(var_joint_qd, var_369, var_366);
                // joint_qd[qd_start + lin_axis_count + 1] = qds3[1]                              <L 856>
                var_371 = wp::extract(var_349, var_370);
                var_372 = wp::add(var_87, var_91);
                var_374 = wp::add(var_372, var_373);
                wp::array_store(var_joint_qd, var_374, var_371);
                // joint_qd[qd_start + lin_axis_count + 2] = qds3[2]                              <L 857>
                var_376 = wp::extract(var_349, var_375);
                var_377 = wp::add(var_87, var_91);
                var_379 = wp::add(var_377, var_378);
                wp::array_store(var_joint_qd, var_379, var_376);
            }
            var_380 = wp::where(var_329, var_334, var_298);
            var_381 = wp::where(var_329, var_340, var_304);
            // return                                                                             <L 859>
            continue;
        }
        var_382 = wp::where(var_229, var_288, var_114);
        var_383 = wp::where(var_229, var_289, var_115);
        var_384 = wp::where(var_229, var_290, var_116);
        var_385 = wp::where(var_229, var_291, var_227);
        var_386 = wp::where(var_229, var_230, var_161);
        var_387 = wp::where(var_229, var_231, var_173);
    }
}



extern "C" __global__ void eval_articulation_ik_95f9da1d_cuda_kernel_backward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::int32> var_articulation_start,
    wp::array_t<wp::int32> var_articulation_end,
    wp::int32 var_articulation_count,
    wp::array_t<bool> var_articulation_mask,
    wp::array_t<wp::int32> var_articulation_indices,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::vec_t<6, wp::float32>> var_body_qd,
    wp::array_t<wp::vec_t<3, wp::float32>> var_body_com,
    wp::array_t<wp::int32> var_joint_type,
    wp::array_t<wp::int32> var_joint_parent,
    wp::array_t<wp::int32> var_joint_child,
    wp::array_t<wp::transform_t<wp::float32>> var_joint_X_p,
    wp::array_t<wp::transform_t<wp::float32>> var_joint_X_c,
    wp::array_t<wp::vec_t<3, wp::float32>> var_joint_axis,
    wp::array_t<wp::int32> var_joint_dof_dim,
    wp::array_t<wp::int32> var_joint_q_start,
    wp::array_t<wp::int32> var_joint_qd_start,
    wp::array_t<wp::int32> var_body_flags,
    wp::int32 var_body_flag_filter,
    wp::array_t<wp::float32> var_joint_q,
    wp::array_t<wp::float32> var_joint_qd,
    wp::array_t<wp::int32> adj_articulation_start,
    wp::array_t<wp::int32> adj_articulation_end,
    wp::int32 adj_articulation_count,
    wp::array_t<bool> adj_articulation_mask,
    wp::array_t<wp::int32> adj_articulation_indices,
    wp::array_t<wp::transform_t<wp::float32>> adj_body_q,
    wp::array_t<wp::vec_t<6, wp::float32>> adj_body_qd,
    wp::array_t<wp::vec_t<3, wp::float32>> adj_body_com,
    wp::array_t<wp::int32> adj_joint_type,
    wp::array_t<wp::int32> adj_joint_parent,
    wp::array_t<wp::int32> adj_joint_child,
    wp::array_t<wp::transform_t<wp::float32>> adj_joint_X_p,
    wp::array_t<wp::transform_t<wp::float32>> adj_joint_X_c,
    wp::array_t<wp::vec_t<3, wp::float32>> adj_joint_axis,
    wp::array_t<wp::int32> adj_joint_dof_dim,
    wp::array_t<wp::int32> adj_joint_q_start,
    wp::array_t<wp::int32> adj_joint_qd_start,
    wp::array_t<wp::int32> adj_body_flags,
    wp::int32 adj_body_flag_filter,
    wp::array_t<wp::float32> adj_joint_q,
    wp::array_t<wp::float32> adj_joint_qd)
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
        wp::int32 var_5;
        wp::int32 var_6;
        bool var_7;
        const wp::int32 var_8 = 0;
        bool var_9;
        bool var_10;
        bool* var_11;
        bool var_12;
        bool var_13;
        wp::int32* var_14;
        wp::int32 var_15;
        wp::int32 var_16;
        wp::int32* var_17;
        wp::int32 var_18;
        wp::int32 var_19;
        wp::int32 var_20;
        bool var_21;
        wp::int32* var_22;
        wp::int32 var_23;
        wp::int32 var_24;
        wp::int32* var_25;
        wp::int32 var_26;
        wp::int32 var_27;
        wp::int32* var_28;
        wp::int32 var_29;
        wp::int32 var_30;
        const wp::int32 var_31 = 0;
        bool var_32;
        wp::transform_t<wp::float32>* var_33;
        wp::transform_t<wp::float32> var_34;
        wp::transform_t<wp::float32> var_35;
        wp::transform_t<wp::float32>* var_36;
        wp::transform_t<wp::float32> var_37;
        wp::transform_t<wp::float32> var_38;
        wp::vec_t<3, wp::float32> var_39;
        wp::vec_t<3, wp::float32> var_40;
        wp::vec_t<6, wp::float32> var_41;
        wp::transform_t<wp::float32> var_42;
        const wp::int32 var_43 = 0;
        bool var_44;
        wp::transform_t<wp::float32>* var_45;
        wp::transform_t<wp::float32> var_46;
        wp::transform_t<wp::float32> var_47;
        wp::transform_t<wp::float32> var_48;
        wp::vec_t<6, wp::float32>* var_49;
        wp::vec_t<6, wp::float32> var_50;
        wp::vec_t<6, wp::float32> var_51;
        wp::vec_t<3, wp::float32> var_52;
        wp::vec_t<3, wp::float32>* var_53;
        wp::vec_t<3, wp::float32> var_54;
        wp::vec_t<3, wp::float32> var_55;
        wp::vec_t<3, wp::float32> var_56;
        wp::vec_t<3, wp::float32> var_57;
        wp::vec_t<3, wp::float32> var_58;
        wp::vec_t<6, wp::float32> var_59;
        wp::transform_t<wp::float32> var_60;
        wp::transform_t<wp::float32>* var_61;
        wp::transform_t<wp::float32> var_62;
        wp::transform_t<wp::float32> var_63;
        wp::transform_t<wp::float32> var_64;
        wp::vec_t<6, wp::float32>* var_65;
        wp::vec_t<6, wp::float32> var_66;
        wp::vec_t<6, wp::float32> var_67;
        wp::vec_t<3, wp::float32> var_68;
        wp::vec_t<3, wp::float32>* var_69;
        wp::vec_t<3, wp::float32> var_70;
        wp::vec_t<3, wp::float32> var_71;
        wp::vec_t<3, wp::float32> var_72;
        wp::int32* var_73;
        wp::int32 var_74;
        wp::int32 var_75;
        wp::vec_t<3, wp::float32> var_76;
        wp::vec_t<3, wp::float32> var_77;
        wp::quat_t<wp::float32> var_78;
        wp::quat_t<wp::float32> var_79;
        wp::vec_t<3, wp::float32> var_80;
        wp::vec_t<3, wp::float32> var_81;
        wp::vec_t<3, wp::float32> var_82;
        wp::int32* var_83;
        wp::int32 var_84;
        wp::int32 var_85;
        wp::int32* var_86;
        wp::int32 var_87;
        wp::int32 var_88;
        const wp::int32 var_89 = 0;
        wp::int32* var_90;
        wp::int32 var_91;
        wp::int32 var_92;
        const wp::int32 var_93 = 1;
        wp::int32* var_94;
        wp::int32 var_95;
        wp::int32 var_96;
        const wp::int32 var_97 = 0;
        bool var_98;
        wp::vec_t<3, wp::float32>* var_99;
        wp::vec_t<3, wp::float32> var_100;
        wp::vec_t<3, wp::float32> var_101;
        wp::vec_t<3, wp::float32> var_102;
        wp::float32 var_103;
        wp::float32 var_104;
        const wp::int32 var_105 = 1;
        bool var_106;
        wp::vec_t<3, wp::float32>* var_107;
        wp::vec_t<3, wp::float32> var_108;
        wp::vec_t<3, wp::float32> var_109;
        wp::quat_t<wp::float32> var_110;
        wp::quat_t<wp::float32> var_111;
        wp::float32 var_112;
        wp::float32 var_113;
        wp::vec_t<3, wp::float32> var_114;
        wp::float32 var_115;
        wp::float32 var_116;
        const wp::int32 var_117 = 2;
        bool var_118;
        wp::quat_t<wp::float32> var_119;
        wp::quat_t<wp::float32> var_120;
        const wp::int32 var_121 = 0;
        wp::float32 var_122;
        const wp::int32 var_123 = 0;
        wp::int32 var_124;
        const wp::int32 var_125 = 1;
        wp::float32 var_126;
        const wp::int32 var_127 = 1;
        wp::int32 var_128;
        const wp::int32 var_129 = 2;
        wp::float32 var_130;
        const wp::int32 var_131 = 2;
        wp::int32 var_132;
        const wp::int32 var_133 = 3;
        wp::float32 var_134;
        const wp::int32 var_135 = 3;
        wp::int32 var_136;
        wp::transform_t<wp::float32> var_137;
        wp::vec_t<3, wp::float32> var_138;
        const wp::int32 var_139 = 0;
        wp::float32 var_140;
        const wp::int32 var_141 = 0;
        wp::int32 var_142;
        const wp::int32 var_143 = 1;
        wp::float32 var_144;
        const wp::int32 var_145 = 1;
        wp::int32 var_146;
        const wp::int32 var_147 = 2;
        wp::float32 var_148;
        const wp::int32 var_149 = 2;
        wp::int32 var_150;
        wp::quat_t<wp::float32> var_151;
        const wp::int32 var_152 = 3;
        bool var_153;
        bool var_154;
        const wp::int32 var_155 = 4;
        bool var_156;
        const wp::int32 var_157 = 5;
        bool var_158;
        wp::quat_t<wp::float32> var_159;
        wp::quat_t<wp::float32> var_160;
        wp::vec_t<3, wp::float32> var_161;
        wp::vec_t<3, wp::float32>* var_162;
        wp::vec_t<3, wp::float32> var_163;
        wp::vec_t<3, wp::float32> var_164;
        wp::vec_t<3, wp::float32> var_165;
        const wp::int32 var_166 = 0;
        bool var_167;
        wp::vec_t<3, wp::float32>* var_168;
        wp::vec_t<3, wp::float32> var_169;
        wp::vec_t<3, wp::float32> var_170;
        wp::vec_t<3, wp::float32> var_171;
        wp::vec_t<3, wp::float32> var_172;
        wp::vec_t<3, wp::float32> var_173;
        wp::vec_t<3, wp::float32> var_174;
        const wp::int32 var_175 = 0;
        wp::float32 var_176;
        const wp::int32 var_177 = 0;
        wp::int32 var_178;
        const wp::int32 var_179 = 1;
        wp::float32 var_180;
        const wp::int32 var_181 = 1;
        wp::int32 var_182;
        const wp::int32 var_183 = 2;
        wp::float32 var_184;
        const wp::int32 var_185 = 2;
        wp::int32 var_186;
        const wp::int32 var_187 = 0;
        wp::float32 var_188;
        const wp::int32 var_189 = 3;
        wp::int32 var_190;
        const wp::int32 var_191 = 1;
        wp::float32 var_192;
        const wp::int32 var_193 = 4;
        wp::int32 var_194;
        const wp::int32 var_195 = 2;
        wp::float32 var_196;
        const wp::int32 var_197 = 5;
        wp::int32 var_198;
        const wp::int32 var_199 = 3;
        wp::float32 var_200;
        const wp::int32 var_201 = 6;
        wp::int32 var_202;
        const wp::int32 var_203 = 0;
        wp::float32 var_204;
        const wp::int32 var_205 = 0;
        wp::int32 var_206;
        const wp::int32 var_207 = 1;
        wp::float32 var_208;
        const wp::int32 var_209 = 1;
        wp::int32 var_210;
        const wp::int32 var_211 = 2;
        wp::float32 var_212;
        const wp::int32 var_213 = 2;
        wp::int32 var_214;
        const wp::int32 var_215 = 0;
        wp::float32 var_216;
        const wp::int32 var_217 = 3;
        wp::int32 var_218;
        const wp::int32 var_219 = 1;
        wp::float32 var_220;
        const wp::int32 var_221 = 4;
        wp::int32 var_222;
        const wp::int32 var_223 = 2;
        wp::float32 var_224;
        const wp::int32 var_225 = 5;
        wp::int32 var_226;
        wp::quat_t<wp::float32> var_227;
        const wp::int32 var_228 = 6;
        bool var_229;
        wp::vec_t<3, wp::float32> var_230;
        wp::vec_t<3, wp::float32> var_231;
        const wp::int32 var_232 = 0;
        bool var_233;
        const wp::int32 var_234 = 0;
        wp::int32 var_235;
        wp::vec_t<3, wp::float32>* var_236;
        wp::vec_t<3, wp::float32> var_237;
        wp::vec_t<3, wp::float32> var_238;
        wp::float32 var_239;
        const wp::int32 var_240 = 0;
        wp::int32 var_241;
        wp::float32 var_242;
        const wp::int32 var_243 = 0;
        wp::int32 var_244;
        wp::vec_t<3, wp::float32> var_245;
        const wp::int32 var_246 = 1;
        bool var_247;
        const wp::int32 var_248 = 1;
        wp::int32 var_249;
        wp::vec_t<3, wp::float32>* var_250;
        wp::vec_t<3, wp::float32> var_251;
        wp::vec_t<3, wp::float32> var_252;
        wp::float32 var_253;
        const wp::int32 var_254 = 1;
        wp::int32 var_255;
        wp::float32 var_256;
        const wp::int32 var_257 = 1;
        wp::int32 var_258;
        wp::vec_t<3, wp::float32> var_259;
        const wp::int32 var_260 = 2;
        bool var_261;
        const wp::int32 var_262 = 2;
        wp::int32 var_263;
        wp::vec_t<3, wp::float32>* var_264;
        wp::vec_t<3, wp::float32> var_265;
        wp::vec_t<3, wp::float32> var_266;
        wp::float32 var_267;
        const wp::int32 var_268 = 2;
        wp::int32 var_269;
        wp::float32 var_270;
        const wp::int32 var_271 = 2;
        wp::int32 var_272;
        wp::vec_t<3, wp::float32> var_273;
        const wp::int32 var_274 = 1;
        bool var_275;
        wp::vec_t<3, wp::float32>* var_276;
        wp::vec_t<3, wp::float32> var_277;
        wp::vec_t<3, wp::float32> var_278;
        wp::quat_t<wp::float32> var_279;
        wp::quat_t<wp::float32> var_280;
        wp::int32 var_281;
        wp::vec_t<3, wp::float32>* var_282;
        wp::float32 var_283;
        wp::float32 var_284;
        wp::vec_t<3, wp::float32> var_285;
        wp::int32 var_286;
        wp::int32 var_287;
        wp::vec_t<3, wp::float32> var_288;
        wp::float32 var_289;
        wp::float32 var_290;
        wp::quat_t<wp::float32> var_291;
        const wp::int32 var_292 = 2;
        bool var_293;
        wp::int32 var_294;
        const wp::int32 var_295 = 0;
        wp::int32 var_296;
        wp::vec_t<3, wp::float32>* var_297;
        wp::vec_t<3, wp::float32> var_298;
        wp::vec_t<3, wp::float32> var_299;
        wp::int32 var_300;
        const wp::int32 var_301 = 1;
        wp::int32 var_302;
        wp::vec_t<3, wp::float32>* var_303;
        wp::vec_t<3, wp::float32> var_304;
        wp::vec_t<3, wp::float32> var_305;
        wp::vec_t<2, wp::float32> var_306;
        wp::vec_t<2, wp::float32> var_307;
        const wp::int32 var_308 = 0;
        wp::float32 var_309;
        wp::int32 var_310;
        const wp::int32 var_311 = 0;
        wp::int32 var_312;
        const wp::int32 var_313 = 1;
        wp::float32 var_314;
        wp::int32 var_315;
        const wp::int32 var_316 = 1;
        wp::int32 var_317;
        const wp::int32 var_318 = 0;
        wp::float32 var_319;
        wp::int32 var_320;
        const wp::int32 var_321 = 0;
        wp::int32 var_322;
        const wp::int32 var_323 = 1;
        wp::float32 var_324;
        wp::int32 var_325;
        const wp::int32 var_326 = 1;
        wp::int32 var_327;
        const wp::int32 var_328 = 3;
        bool var_329;
        wp::int32 var_330;
        const wp::int32 var_331 = 0;
        wp::int32 var_332;
        wp::vec_t<3, wp::float32>* var_333;
        wp::vec_t<3, wp::float32> var_334;
        wp::vec_t<3, wp::float32> var_335;
        wp::int32 var_336;
        const wp::int32 var_337 = 1;
        wp::int32 var_338;
        wp::vec_t<3, wp::float32>* var_339;
        wp::vec_t<3, wp::float32> var_340;
        wp::vec_t<3, wp::float32> var_341;
        wp::int32 var_342;
        const wp::int32 var_343 = 2;
        wp::int32 var_344;
        wp::vec_t<3, wp::float32>* var_345;
        wp::vec_t<3, wp::float32> var_346;
        wp::vec_t<3, wp::float32> var_347;
        wp::vec_t<3, wp::float32> var_348;
        wp::vec_t<3, wp::float32> var_349;
        const wp::int32 var_350 = 0;
        wp::float32 var_351;
        wp::int32 var_352;
        const wp::int32 var_353 = 0;
        wp::int32 var_354;
        const wp::int32 var_355 = 1;
        wp::float32 var_356;
        wp::int32 var_357;
        const wp::int32 var_358 = 1;
        wp::int32 var_359;
        const wp::int32 var_360 = 2;
        wp::float32 var_361;
        wp::int32 var_362;
        const wp::int32 var_363 = 2;
        wp::int32 var_364;
        const wp::int32 var_365 = 0;
        wp::float32 var_366;
        wp::int32 var_367;
        const wp::int32 var_368 = 0;
        wp::int32 var_369;
        const wp::int32 var_370 = 1;
        wp::float32 var_371;
        wp::int32 var_372;
        const wp::int32 var_373 = 1;
        wp::int32 var_374;
        const wp::int32 var_375 = 2;
        wp::float32 var_376;
        wp::int32 var_377;
        const wp::int32 var_378 = 2;
        wp::int32 var_379;
        wp::vec_t<3, wp::float32> var_380;
        wp::vec_t<3, wp::float32> var_381;
        wp::vec_t<3, wp::float32> var_382;
        wp::float32 var_383;
        wp::float32 var_384;
        wp::quat_t<wp::float32> var_385;
        wp::vec_t<3, wp::float32> var_386;
        wp::vec_t<3, wp::float32> var_387;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::int32 adj_2 = {};
        wp::int32 adj_3 = {};
        wp::int32 adj_4 = {};
        wp::int32 adj_5 = {};
        wp::int32 adj_6 = {};
        bool adj_7 = {};
        wp::int32 adj_8 = {};
        bool adj_9 = {};
        bool adj_10 = {};
        bool adj_11 = {};
        bool adj_12 = {};
        bool adj_13 = {};
        wp::int32 adj_14 = {};
        wp::int32 adj_15 = {};
        wp::int32 adj_16 = {};
        wp::int32 adj_17 = {};
        wp::int32 adj_18 = {};
        wp::int32 adj_19 = {};
        wp::int32 adj_20 = {};
        bool adj_21 = {};
        wp::int32 adj_22 = {};
        wp::int32 adj_23 = {};
        wp::int32 adj_24 = {};
        wp::int32 adj_25 = {};
        wp::int32 adj_26 = {};
        wp::int32 adj_27 = {};
        wp::int32 adj_28 = {};
        wp::int32 adj_29 = {};
        wp::int32 adj_30 = {};
        wp::int32 adj_31 = {};
        bool adj_32 = {};
        wp::transform_t<wp::float32> adj_33 = {};
        wp::transform_t<wp::float32> adj_34 = {};
        wp::transform_t<wp::float32> adj_35 = {};
        wp::transform_t<wp::float32> adj_36 = {};
        wp::transform_t<wp::float32> adj_37 = {};
        wp::transform_t<wp::float32> adj_38 = {};
        wp::vec_t<3, wp::float32> adj_39 = {};
        wp::vec_t<3, wp::float32> adj_40 = {};
        wp::vec_t<6, wp::float32> adj_41 = {};
        wp::transform_t<wp::float32> adj_42 = {};
        wp::int32 adj_43 = {};
        bool adj_44 = {};
        wp::transform_t<wp::float32> adj_45 = {};
        wp::transform_t<wp::float32> adj_46 = {};
        wp::transform_t<wp::float32> adj_47 = {};
        wp::transform_t<wp::float32> adj_48 = {};
        wp::vec_t<6, wp::float32> adj_49 = {};
        wp::vec_t<6, wp::float32> adj_50 = {};
        wp::vec_t<6, wp::float32> adj_51 = {};
        wp::vec_t<3, wp::float32> adj_52 = {};
        wp::vec_t<3, wp::float32> adj_53 = {};
        wp::vec_t<3, wp::float32> adj_54 = {};
        wp::vec_t<3, wp::float32> adj_55 = {};
        wp::vec_t<3, wp::float32> adj_56 = {};
        wp::vec_t<3, wp::float32> adj_57 = {};
        wp::vec_t<3, wp::float32> adj_58 = {};
        wp::vec_t<6, wp::float32> adj_59 = {};
        wp::transform_t<wp::float32> adj_60 = {};
        wp::transform_t<wp::float32> adj_61 = {};
        wp::transform_t<wp::float32> adj_62 = {};
        wp::transform_t<wp::float32> adj_63 = {};
        wp::transform_t<wp::float32> adj_64 = {};
        wp::vec_t<6, wp::float32> adj_65 = {};
        wp::vec_t<6, wp::float32> adj_66 = {};
        wp::vec_t<6, wp::float32> adj_67 = {};
        wp::vec_t<3, wp::float32> adj_68 = {};
        wp::vec_t<3, wp::float32> adj_69 = {};
        wp::vec_t<3, wp::float32> adj_70 = {};
        wp::vec_t<3, wp::float32> adj_71 = {};
        wp::vec_t<3, wp::float32> adj_72 = {};
        wp::int32 adj_73 = {};
        wp::int32 adj_74 = {};
        wp::int32 adj_75 = {};
        wp::vec_t<3, wp::float32> adj_76 = {};
        wp::vec_t<3, wp::float32> adj_77 = {};
        wp::quat_t<wp::float32> adj_78 = {};
        wp::quat_t<wp::float32> adj_79 = {};
        wp::vec_t<3, wp::float32> adj_80 = {};
        wp::vec_t<3, wp::float32> adj_81 = {};
        wp::vec_t<3, wp::float32> adj_82 = {};
        wp::int32 adj_83 = {};
        wp::int32 adj_84 = {};
        wp::int32 adj_85 = {};
        wp::int32 adj_86 = {};
        wp::int32 adj_87 = {};
        wp::int32 adj_88 = {};
        wp::int32 adj_89 = {};
        wp::int32 adj_90 = {};
        wp::int32 adj_91 = {};
        wp::int32 adj_92 = {};
        wp::int32 adj_93 = {};
        wp::int32 adj_94 = {};
        wp::int32 adj_95 = {};
        wp::int32 adj_96 = {};
        wp::int32 adj_97 = {};
        bool adj_98 = {};
        wp::vec_t<3, wp::float32> adj_99 = {};
        wp::vec_t<3, wp::float32> adj_100 = {};
        wp::vec_t<3, wp::float32> adj_101 = {};
        wp::vec_t<3, wp::float32> adj_102 = {};
        wp::float32 adj_103 = {};
        wp::float32 adj_104 = {};
        wp::int32 adj_105 = {};
        bool adj_106 = {};
        wp::vec_t<3, wp::float32> adj_107 = {};
        wp::vec_t<3, wp::float32> adj_108 = {};
        wp::vec_t<3, wp::float32> adj_109 = {};
        wp::quat_t<wp::float32> adj_110 = {};
        wp::quat_t<wp::float32> adj_111 = {};
        wp::float32 adj_112 = {};
        wp::float32 adj_113 = {};
        wp::vec_t<3, wp::float32> adj_114 = {};
        wp::float32 adj_115 = {};
        wp::float32 adj_116 = {};
        wp::int32 adj_117 = {};
        bool adj_118 = {};
        wp::quat_t<wp::float32> adj_119 = {};
        wp::quat_t<wp::float32> adj_120 = {};
        wp::int32 adj_121 = {};
        wp::float32 adj_122 = {};
        wp::int32 adj_123 = {};
        wp::int32 adj_124 = {};
        wp::int32 adj_125 = {};
        wp::float32 adj_126 = {};
        wp::int32 adj_127 = {};
        wp::int32 adj_128 = {};
        wp::int32 adj_129 = {};
        wp::float32 adj_130 = {};
        wp::int32 adj_131 = {};
        wp::int32 adj_132 = {};
        wp::int32 adj_133 = {};
        wp::float32 adj_134 = {};
        wp::int32 adj_135 = {};
        wp::int32 adj_136 = {};
        wp::transform_t<wp::float32> adj_137 = {};
        wp::vec_t<3, wp::float32> adj_138 = {};
        wp::int32 adj_139 = {};
        wp::float32 adj_140 = {};
        wp::int32 adj_141 = {};
        wp::int32 adj_142 = {};
        wp::int32 adj_143 = {};
        wp::float32 adj_144 = {};
        wp::int32 adj_145 = {};
        wp::int32 adj_146 = {};
        wp::int32 adj_147 = {};
        wp::float32 adj_148 = {};
        wp::int32 adj_149 = {};
        wp::int32 adj_150 = {};
        wp::quat_t<wp::float32> adj_151 = {};
        wp::int32 adj_152 = {};
        bool adj_153 = {};
        bool adj_154 = {};
        wp::int32 adj_155 = {};
        bool adj_156 = {};
        wp::int32 adj_157 = {};
        bool adj_158 = {};
        wp::quat_t<wp::float32> adj_159 = {};
        wp::quat_t<wp::float32> adj_160 = {};
        wp::vec_t<3, wp::float32> adj_161 = {};
        wp::vec_t<3, wp::float32> adj_162 = {};
        wp::vec_t<3, wp::float32> adj_163 = {};
        wp::vec_t<3, wp::float32> adj_164 = {};
        wp::vec_t<3, wp::float32> adj_165 = {};
        wp::int32 adj_166 = {};
        bool adj_167 = {};
        wp::vec_t<3, wp::float32> adj_168 = {};
        wp::vec_t<3, wp::float32> adj_169 = {};
        wp::vec_t<3, wp::float32> adj_170 = {};
        wp::vec_t<3, wp::float32> adj_171 = {};
        wp::vec_t<3, wp::float32> adj_172 = {};
        wp::vec_t<3, wp::float32> adj_173 = {};
        wp::vec_t<3, wp::float32> adj_174 = {};
        wp::int32 adj_175 = {};
        wp::float32 adj_176 = {};
        wp::int32 adj_177 = {};
        wp::int32 adj_178 = {};
        wp::int32 adj_179 = {};
        wp::float32 adj_180 = {};
        wp::int32 adj_181 = {};
        wp::int32 adj_182 = {};
        wp::int32 adj_183 = {};
        wp::float32 adj_184 = {};
        wp::int32 adj_185 = {};
        wp::int32 adj_186 = {};
        wp::int32 adj_187 = {};
        wp::float32 adj_188 = {};
        wp::int32 adj_189 = {};
        wp::int32 adj_190 = {};
        wp::int32 adj_191 = {};
        wp::float32 adj_192 = {};
        wp::int32 adj_193 = {};
        wp::int32 adj_194 = {};
        wp::int32 adj_195 = {};
        wp::float32 adj_196 = {};
        wp::int32 adj_197 = {};
        wp::int32 adj_198 = {};
        wp::int32 adj_199 = {};
        wp::float32 adj_200 = {};
        wp::int32 adj_201 = {};
        wp::int32 adj_202 = {};
        wp::int32 adj_203 = {};
        wp::float32 adj_204 = {};
        wp::int32 adj_205 = {};
        wp::int32 adj_206 = {};
        wp::int32 adj_207 = {};
        wp::float32 adj_208 = {};
        wp::int32 adj_209 = {};
        wp::int32 adj_210 = {};
        wp::int32 adj_211 = {};
        wp::float32 adj_212 = {};
        wp::int32 adj_213 = {};
        wp::int32 adj_214 = {};
        wp::int32 adj_215 = {};
        wp::float32 adj_216 = {};
        wp::int32 adj_217 = {};
        wp::int32 adj_218 = {};
        wp::int32 adj_219 = {};
        wp::float32 adj_220 = {};
        wp::int32 adj_221 = {};
        wp::int32 adj_222 = {};
        wp::int32 adj_223 = {};
        wp::float32 adj_224 = {};
        wp::int32 adj_225 = {};
        wp::int32 adj_226 = {};
        wp::quat_t<wp::float32> adj_227 = {};
        wp::int32 adj_228 = {};
        bool adj_229 = {};
        wp::vec_t<3, wp::float32> adj_230 = {};
        wp::vec_t<3, wp::float32> adj_231 = {};
        wp::int32 adj_232 = {};
        bool adj_233 = {};
        wp::int32 adj_234 = {};
        wp::int32 adj_235 = {};
        wp::vec_t<3, wp::float32> adj_236 = {};
        wp::vec_t<3, wp::float32> adj_237 = {};
        wp::vec_t<3, wp::float32> adj_238 = {};
        wp::float32 adj_239 = {};
        wp::int32 adj_240 = {};
        wp::int32 adj_241 = {};
        wp::float32 adj_242 = {};
        wp::int32 adj_243 = {};
        wp::int32 adj_244 = {};
        wp::vec_t<3, wp::float32> adj_245 = {};
        wp::int32 adj_246 = {};
        bool adj_247 = {};
        wp::int32 adj_248 = {};
        wp::int32 adj_249 = {};
        wp::vec_t<3, wp::float32> adj_250 = {};
        wp::vec_t<3, wp::float32> adj_251 = {};
        wp::vec_t<3, wp::float32> adj_252 = {};
        wp::float32 adj_253 = {};
        wp::int32 adj_254 = {};
        wp::int32 adj_255 = {};
        wp::float32 adj_256 = {};
        wp::int32 adj_257 = {};
        wp::int32 adj_258 = {};
        wp::vec_t<3, wp::float32> adj_259 = {};
        wp::int32 adj_260 = {};
        bool adj_261 = {};
        wp::int32 adj_262 = {};
        wp::int32 adj_263 = {};
        wp::vec_t<3, wp::float32> adj_264 = {};
        wp::vec_t<3, wp::float32> adj_265 = {};
        wp::vec_t<3, wp::float32> adj_266 = {};
        wp::float32 adj_267 = {};
        wp::int32 adj_268 = {};
        wp::int32 adj_269 = {};
        wp::float32 adj_270 = {};
        wp::int32 adj_271 = {};
        wp::int32 adj_272 = {};
        wp::vec_t<3, wp::float32> adj_273 = {};
        wp::int32 adj_274 = {};
        bool adj_275 = {};
        wp::vec_t<3, wp::float32> adj_276 = {};
        wp::vec_t<3, wp::float32> adj_277 = {};
        wp::vec_t<3, wp::float32> adj_278 = {};
        wp::quat_t<wp::float32> adj_279 = {};
        wp::quat_t<wp::float32> adj_280 = {};
        wp::int32 adj_281 = {};
        wp::vec_t<3, wp::float32> adj_282 = {};
        wp::float32 adj_283 = {};
        wp::float32 adj_284 = {};
        wp::vec_t<3, wp::float32> adj_285 = {};
        wp::int32 adj_286 = {};
        wp::int32 adj_287 = {};
        wp::vec_t<3, wp::float32> adj_288 = {};
        wp::float32 adj_289 = {};
        wp::float32 adj_290 = {};
        wp::quat_t<wp::float32> adj_291 = {};
        wp::int32 adj_292 = {};
        bool adj_293 = {};
        wp::int32 adj_294 = {};
        wp::int32 adj_295 = {};
        wp::int32 adj_296 = {};
        wp::vec_t<3, wp::float32> adj_297 = {};
        wp::vec_t<3, wp::float32> adj_298 = {};
        wp::vec_t<3, wp::float32> adj_299 = {};
        wp::int32 adj_300 = {};
        wp::int32 adj_301 = {};
        wp::int32 adj_302 = {};
        wp::vec_t<3, wp::float32> adj_303 = {};
        wp::vec_t<3, wp::float32> adj_304 = {};
        wp::vec_t<3, wp::float32> adj_305 = {};
        wp::vec_t<2, wp::float32> adj_306 = {};
        wp::vec_t<2, wp::float32> adj_307 = {};
        wp::int32 adj_308 = {};
        wp::float32 adj_309 = {};
        wp::int32 adj_310 = {};
        wp::int32 adj_311 = {};
        wp::int32 adj_312 = {};
        wp::int32 adj_313 = {};
        wp::float32 adj_314 = {};
        wp::int32 adj_315 = {};
        wp::int32 adj_316 = {};
        wp::int32 adj_317 = {};
        wp::int32 adj_318 = {};
        wp::float32 adj_319 = {};
        wp::int32 adj_320 = {};
        wp::int32 adj_321 = {};
        wp::int32 adj_322 = {};
        wp::int32 adj_323 = {};
        wp::float32 adj_324 = {};
        wp::int32 adj_325 = {};
        wp::int32 adj_326 = {};
        wp::int32 adj_327 = {};
        wp::int32 adj_328 = {};
        bool adj_329 = {};
        wp::int32 adj_330 = {};
        wp::int32 adj_331 = {};
        wp::int32 adj_332 = {};
        wp::vec_t<3, wp::float32> adj_333 = {};
        wp::vec_t<3, wp::float32> adj_334 = {};
        wp::vec_t<3, wp::float32> adj_335 = {};
        wp::int32 adj_336 = {};
        wp::int32 adj_337 = {};
        wp::int32 adj_338 = {};
        wp::vec_t<3, wp::float32> adj_339 = {};
        wp::vec_t<3, wp::float32> adj_340 = {};
        wp::vec_t<3, wp::float32> adj_341 = {};
        wp::int32 adj_342 = {};
        wp::int32 adj_343 = {};
        wp::int32 adj_344 = {};
        wp::vec_t<3, wp::float32> adj_345 = {};
        wp::vec_t<3, wp::float32> adj_346 = {};
        wp::vec_t<3, wp::float32> adj_347 = {};
        wp::vec_t<3, wp::float32> adj_348 = {};
        wp::vec_t<3, wp::float32> adj_349 = {};
        wp::int32 adj_350 = {};
        wp::float32 adj_351 = {};
        wp::int32 adj_352 = {};
        wp::int32 adj_353 = {};
        wp::int32 adj_354 = {};
        wp::int32 adj_355 = {};
        wp::float32 adj_356 = {};
        wp::int32 adj_357 = {};
        wp::int32 adj_358 = {};
        wp::int32 adj_359 = {};
        wp::int32 adj_360 = {};
        wp::float32 adj_361 = {};
        wp::int32 adj_362 = {};
        wp::int32 adj_363 = {};
        wp::int32 adj_364 = {};
        wp::int32 adj_365 = {};
        wp::float32 adj_366 = {};
        wp::int32 adj_367 = {};
        wp::int32 adj_368 = {};
        wp::int32 adj_369 = {};
        wp::int32 adj_370 = {};
        wp::float32 adj_371 = {};
        wp::int32 adj_372 = {};
        wp::int32 adj_373 = {};
        wp::int32 adj_374 = {};
        wp::int32 adj_375 = {};
        wp::float32 adj_376 = {};
        wp::int32 adj_377 = {};
        wp::int32 adj_378 = {};
        wp::int32 adj_379 = {};
        wp::vec_t<3, wp::float32> adj_380 = {};
        wp::vec_t<3, wp::float32> adj_381 = {};
        wp::vec_t<3, wp::float32> adj_382 = {};
        wp::float32 adj_383 = {};
        wp::float32 adj_384 = {};
        wp::quat_t<wp::float32> adj_385 = {};
        wp::vec_t<3, wp::float32> adj_386 = {};
        wp::vec_t<3, wp::float32> adj_387 = {};
        //---------
        // forward
        // def eval_articulation_ik(                                                              <L 640>
        // art_idx, joint_offset = wp.tid()  # articulation index and joint offset within articulation       <L 663>
        builtin_tid2d(var_0, var_1);
        // if articulation_indices:                                                               <L 666>
        if (var_articulation_indices) {
            // articulation_id = articulation_indices[art_idx]                                    <L 667>
            var_2 = wp::address(var_articulation_indices, var_0);
            var_4 = wp::load(var_2);
            var_3 = wp::copy(var_4);
        }
        if (!var_articulation_indices) {
            // articulation_id = art_idx                                                          <L 669>
            var_5 = wp::copy(var_0);
        }
        var_6 = wp::where(var_articulation_indices, var_3, var_5);
        // if articulation_id < 0 or articulation_id >= articulation_count:                       <L 672>
        var_9 = (var_6 < var_8);
        var_7 = var_9;
        if (!var_7) {
            var_10 = (var_6 >= var_articulation_count);
            var_7 = var_7 || var_10;
        }
        if (var_7) {
            // return  # Invalid articulation index                                               <L 673>
            goto label0;
        }
        // if articulation_mask:                                                                  <L 676>
        if (var_articulation_mask) {
            // if not articulation_mask[articulation_id]:                                         <L 677>
            var_11 = wp::address(var_articulation_mask, var_6);
            var_13 = wp::load(var_11);
            var_12 = wp::unot(var_13);
            if (var_12) {
                // return                                                                         <L 678>
                goto label1;
            }
        }
        // joint_start = articulation_start[articulation_id]                                      <L 681>
        var_14 = wp::address(var_articulation_start, var_6);
        var_16 = wp::load(var_14);
        var_15 = wp::copy(var_16);
        // joint_end = articulation_end[articulation_id]                                          <L 682>
        var_17 = wp::address(var_articulation_end, var_6);
        var_19 = wp::load(var_17);
        var_18 = wp::copy(var_19);
        // joint_idx = joint_start + joint_offset                                                 <L 685>
        var_20 = wp::add(var_15, var_1);
        // if joint_idx >= joint_end:                                                             <L 686>
        var_21 = (var_20 >= var_18);
        if (var_21) {
            // return  # This thread has no joint (padding thread)                                <L 687>
            goto label2;
        }
        // parent = joint_parent[joint_idx]                                                       <L 689>
        var_22 = wp::address(var_joint_parent, var_20);
        var_24 = wp::load(var_22);
        var_23 = wp::copy(var_24);
        // child = joint_child[joint_idx]                                                         <L 690>
        var_25 = wp::address(var_joint_child, var_20);
        var_27 = wp::load(var_25);
        var_26 = wp::copy(var_27);
        // if (body_flags[child] & body_flag_filter) == 0:                                        <L 691>
        var_28 = wp::address(var_body_flags, var_26);
        var_30 = wp::load(var_28);
        var_29 = wp::bit_and(var_30, var_body_flag_filter);
        var_32 = (var_29 == var_31);
        if (var_32) {
            // return                                                                             <L 692>
            goto label3;
        }
        // X_pj = joint_X_p[joint_idx]                                                            <L 694>
        var_33 = wp::address(var_joint_X_p, var_20);
        var_35 = wp::load(var_33);
        var_34 = wp::copy(var_35);
        // X_cj = joint_X_c[joint_idx]                                                            <L 695>
        var_36 = wp::address(var_joint_X_c, var_20);
        var_38 = wp::load(var_36);
        var_37 = wp::copy(var_38);
        // w_p = wp.vec3()                                                                        <L 697>
        var_39 = wp::vec_t<3, wp::float32>();
        // v_p = wp.vec3()                                                                        <L 698>
        var_40 = wp::vec_t<3, wp::float32>();
        // v_wp = wp.spatial_vector()                                                             <L 699>
        var_41 = wp::vec_t<6, wp::float32>();
        // X_wpj = X_pj                                                                           <L 702>
        var_42 = wp::copy(var_34);
        // if parent >= 0:                                                                        <L 703>
        var_44 = (var_23 >= var_43);
        if (var_44) {
            // X_wp = body_q[parent]                                                              <L 704>
            var_45 = wp::address(var_body_q, var_23);
            var_47 = wp::load(var_45);
            var_46 = wp::copy(var_47);
            // X_wpj = X_wp * X_pj                                                                <L 705>
            var_48 = wp::mul(var_46, var_34);
            // v_wp = body_qd[parent]                                                             <L 707>
            var_49 = wp::address(var_body_qd, var_23);
            var_51 = wp::load(var_49);
            var_50 = wp::copy(var_51);
            // w_p = wp.spatial_bottom(v_wp)                                                      <L 708>
            var_52 = wp::spatial_bottom(var_50);
            // v_p = com_twist_to_point_velocity(v_wp, X_wp, body_com[parent], wp.transform_get_translation(X_wpj))       <L 709>
            var_53 = wp::address(var_body_com, var_23);
            var_54 = wp::transform_get_translation(var_48);
            var_56 = wp::load(var_53);
            var_55 = com_twist_to_point_velocity_0(var_50, var_46, var_56, var_54);
        }
        var_57 = wp::where(var_44, var_52, var_39);
        var_58 = wp::where(var_44, var_55, var_40);
        var_59 = wp::where(var_44, var_50, var_41);
        var_60 = wp::where(var_44, var_48, var_42);
        // X_wc = body_q[child]                                                                   <L 712>
        var_61 = wp::address(var_body_q, var_26);
        var_63 = wp::load(var_61);
        var_62 = wp::copy(var_63);
        // X_wcj = X_wc * X_cj                                                                    <L 713>
        var_64 = wp::mul(var_62, var_37);
        // v_wc = body_qd[child]                                                                  <L 715>
        var_65 = wp::address(var_body_qd, var_26);
        var_67 = wp::load(var_65);
        var_66 = wp::copy(var_67);
        // w_c = wp.spatial_bottom(v_wc)                                                          <L 717>
        var_68 = wp::spatial_bottom(var_66);
        // v_c = com_twist_to_point_velocity(v_wc, X_wc, body_com[child], wp.transform_get_translation(X_wcj))       <L 718>
        var_69 = wp::address(var_body_com, var_26);
        var_70 = wp::transform_get_translation(var_64);
        var_72 = wp::load(var_69);
        var_71 = com_twist_to_point_velocity_0(var_66, var_62, var_72, var_70);
        // type = joint_type[joint_idx]                                                           <L 721>
        var_73 = wp::address(var_joint_type, var_20);
        var_75 = wp::load(var_73);
        var_74 = wp::copy(var_75);
        // x_p = wp.transform_get_translation(X_wpj)                                              <L 724>
        var_76 = wp::transform_get_translation(var_60);
        // x_c = wp.transform_get_translation(X_wcj)                                              <L 725>
        var_77 = wp::transform_get_translation(var_64);
        // q_p = wp.transform_get_rotation(X_wpj)                                                 <L 727>
        var_78 = wp::transform_get_rotation(var_60);
        // q_c = wp.transform_get_rotation(X_wcj)                                                 <L 728>
        var_79 = wp::transform_get_rotation(var_64);
        // x_err = x_c - x_p                                                                      <L 730>
        var_80 = wp::sub(var_77, var_76);
        // v_err = v_c - v_p                                                                      <L 731>
        var_81 = wp::sub(var_71, var_58);
        // w_err = w_c - w_p                                                                      <L 732>
        var_82 = wp::sub(var_68, var_57);
        // q_start = joint_q_start[joint_idx]                                                     <L 734>
        var_83 = wp::address(var_joint_q_start, var_20);
        var_85 = wp::load(var_83);
        var_84 = wp::copy(var_85);
        // qd_start = joint_qd_start[joint_idx]                                                   <L 735>
        var_86 = wp::address(var_joint_qd_start, var_20);
        var_88 = wp::load(var_86);
        var_87 = wp::copy(var_88);
        // lin_axis_count = joint_dof_dim[joint_idx, 0]                                           <L 736>
        var_90 = wp::address(var_joint_dof_dim, var_20, var_89);
        var_92 = wp::load(var_90);
        var_91 = wp::copy(var_92);
        // ang_axis_count = joint_dof_dim[joint_idx, 1]                                           <L 737>
        var_94 = wp::address(var_joint_dof_dim, var_20, var_93);
        var_96 = wp::load(var_94);
        var_95 = wp::copy(var_96);
        // if type == JointType.PRISMATIC:                                                        <L 739>
        var_98 = (var_74 == var_97);
        if (var_98) {
            // axis = joint_axis[qd_start]                                                        <L 740>
            var_99 = wp::address(var_joint_axis, var_87);
            var_101 = wp::load(var_99);
            var_100 = wp::copy(var_101);
            // axis_p = wp.quat_rotate(q_p, axis)                                                 <L 743>
            var_102 = wp::quat_rotate(var_78, var_100);
            // q = wp.dot(x_err, axis_p)                                                          <L 746>
            var_103 = wp::dot(var_80, var_102);
            // qd = wp.dot(v_err, axis_p)                                                         <L 747>
            var_104 = wp::dot(var_81, var_102);
            // joint_q[q_start] = q                                                               <L 749>
            // wp::array_store(var_joint_q, var_84, var_103);
            // joint_qd[qd_start] = qd                                                            <L 750>
            // wp::array_store(var_joint_qd, var_87, var_104);
            // return                                                                             <L 752>
            goto label4;
        }
        // if type == JointType.REVOLUTE:                                                         <L 754>
        var_106 = (var_74 == var_105);
        if (var_106) {
            // axis = joint_axis[qd_start]                                                        <L 755>
            var_107 = wp::address(var_joint_axis, var_87);
            var_109 = wp::load(var_107);
            var_108 = wp::copy(var_109);
            // q_pc = wp.quat_inverse(q_p) * q_c                                                  <L 756>
            var_110 = wp::quat_inverse(var_78);
            var_111 = wp::mul(var_110, var_79);
            // q, qd = reconstruct_angular_q_qd(q_pc, w_err, X_wpj, axis)                         <L 758>
            reconstruct_angular_q_qd_0(var_111, var_82, var_60, var_108, var_112, var_113);
            // joint_q[q_start] = q                                                               <L 760>
            // wp::array_store(var_joint_q, var_84, var_112);
            // joint_qd[qd_start] = qd                                                            <L 761>
            // wp::array_store(var_joint_qd, var_87, var_113);
            // return                                                                             <L 763>
            goto label5;
        }
        var_114 = wp::where(var_106, var_108, var_100);
        var_115 = wp::where(var_106, var_112, var_103);
        var_116 = wp::where(var_106, var_113, var_104);
        // if type == JointType.BALL:                                                             <L 765>
        var_118 = (var_74 == var_117);
        if (var_118) {
            // q_pc = wp.quat_inverse(q_p) * q_c                                                  <L 766>
            var_119 = wp::quat_inverse(var_78);
            var_120 = wp::mul(var_119, var_79);
            // joint_q[q_start + 0] = q_pc[0]                                                     <L 768>
            var_122 = wp::extract(var_120, var_121);
            var_124 = wp::add(var_84, var_123);
            // wp::array_store(var_joint_q, var_124, var_122);
            // joint_q[q_start + 1] = q_pc[1]                                                     <L 769>
            var_126 = wp::extract(var_120, var_125);
            var_128 = wp::add(var_84, var_127);
            // wp::array_store(var_joint_q, var_128, var_126);
            // joint_q[q_start + 2] = q_pc[2]                                                     <L 770>
            var_130 = wp::extract(var_120, var_129);
            var_132 = wp::add(var_84, var_131);
            // wp::array_store(var_joint_q, var_132, var_130);
            // joint_q[q_start + 3] = q_pc[3]                                                     <L 771>
            var_134 = wp::extract(var_120, var_133);
            var_136 = wp::add(var_84, var_135);
            // wp::array_store(var_joint_q, var_136, var_134);
            // ang_vel = wp.transform_vector(wp.transform_inverse(X_wpj), w_err)                  <L 773>
            var_137 = wp::transform_inverse(var_60);
            var_138 = wp::transform_vector(var_137, var_82);
            // joint_qd[qd_start + 0] = ang_vel[0]                                                <L 774>
            var_140 = wp::extract(var_138, var_139);
            var_142 = wp::add(var_87, var_141);
            // wp::array_store(var_joint_qd, var_142, var_140);
            // joint_qd[qd_start + 1] = ang_vel[1]                                                <L 775>
            var_144 = wp::extract(var_138, var_143);
            var_146 = wp::add(var_87, var_145);
            // wp::array_store(var_joint_qd, var_146, var_144);
            // joint_qd[qd_start + 2] = ang_vel[2]                                                <L 776>
            var_148 = wp::extract(var_138, var_147);
            var_150 = wp::add(var_87, var_149);
            // wp::array_store(var_joint_qd, var_150, var_148);
            // return                                                                             <L 778>
            goto label6;
        }
        var_151 = wp::where(var_118, var_120, var_111);
        // if type == JointType.FIXED:                                                            <L 780>
        var_153 = (var_74 == var_152);
        if (var_153) {
            // return                                                                             <L 781>
            goto label7;
        }
        // if type == JointType.FREE or type == JointType.DISTANCE:                               <L 783>
        var_156 = (var_74 == var_155);
        var_154 = var_156;
        if (!var_154) {
            var_158 = (var_74 == var_157);
            var_154 = var_154 || var_158;
        }
        if (var_154) {
            // q_pc = wp.quat_inverse(q_p) * q_c                                                  <L 784>
            var_159 = wp::quat_inverse(var_78);
            var_160 = wp::mul(var_159, var_79);
            // x_err_c = wp.quat_rotate_inv(q_p, x_err)                                           <L 786>
            var_161 = wp::quat_rotate_inv(var_78, var_80);
            // x_child_com_world = wp.transform_point(X_wc, body_com[child])                      <L 787>
            var_162 = wp::address(var_body_com, var_26);
            var_164 = wp::load(var_162);
            var_163 = wp::transform_point(var_62, var_164);
            // v_com_err = wp.spatial_top(v_wc)                                                   <L 788>
            var_165 = wp::spatial_top(var_66);
            // if parent >= 0:                                                                    <L 789>
            var_167 = (var_23 >= var_166);
            if (var_167) {
                // v_com_err = v_com_err - com_twist_to_point_velocity(v_wp, X_wp, body_com[parent], x_child_com_world)       <L 790>
                var_168 = wp::address(var_body_com, var_23);
                var_170 = wp::load(var_168);
                var_169 = com_twist_to_point_velocity_0(var_59, var_46, var_170, var_163);
                var_171 = wp::sub(var_165, var_169);
            }
            var_172 = wp::where(var_167, var_171, var_165);
            // v_err_c = wp.quat_rotate_inv(q_p, v_com_err)                                       <L 791>
            var_173 = wp::quat_rotate_inv(var_78, var_172);
            // w_err_c = wp.quat_rotate_inv(q_p, w_err)                                           <L 792>
            var_174 = wp::quat_rotate_inv(var_78, var_82);
            // joint_q[q_start + 0] = x_err_c[0]                                                  <L 794>
            var_176 = wp::extract(var_161, var_175);
            var_178 = wp::add(var_84, var_177);
            // wp::array_store(var_joint_q, var_178, var_176);
            // joint_q[q_start + 1] = x_err_c[1]                                                  <L 795>
            var_180 = wp::extract(var_161, var_179);
            var_182 = wp::add(var_84, var_181);
            // wp::array_store(var_joint_q, var_182, var_180);
            // joint_q[q_start + 2] = x_err_c[2]                                                  <L 796>
            var_184 = wp::extract(var_161, var_183);
            var_186 = wp::add(var_84, var_185);
            // wp::array_store(var_joint_q, var_186, var_184);
            // joint_q[q_start + 3] = q_pc[0]                                                     <L 798>
            var_188 = wp::extract(var_160, var_187);
            var_190 = wp::add(var_84, var_189);
            // wp::array_store(var_joint_q, var_190, var_188);
            // joint_q[q_start + 4] = q_pc[1]                                                     <L 799>
            var_192 = wp::extract(var_160, var_191);
            var_194 = wp::add(var_84, var_193);
            // wp::array_store(var_joint_q, var_194, var_192);
            // joint_q[q_start + 5] = q_pc[2]                                                     <L 800>
            var_196 = wp::extract(var_160, var_195);
            var_198 = wp::add(var_84, var_197);
            // wp::array_store(var_joint_q, var_198, var_196);
            // joint_q[q_start + 6] = q_pc[3]                                                     <L 801>
            var_200 = wp::extract(var_160, var_199);
            var_202 = wp::add(var_84, var_201);
            // wp::array_store(var_joint_q, var_202, var_200);
            // joint_qd[qd_start + 0] = v_err_c[0]                                                <L 803>
            var_204 = wp::extract(var_173, var_203);
            var_206 = wp::add(var_87, var_205);
            // wp::array_store(var_joint_qd, var_206, var_204);
            // joint_qd[qd_start + 1] = v_err_c[1]                                                <L 804>
            var_208 = wp::extract(var_173, var_207);
            var_210 = wp::add(var_87, var_209);
            // wp::array_store(var_joint_qd, var_210, var_208);
            // joint_qd[qd_start + 2] = v_err_c[2]                                                <L 805>
            var_212 = wp::extract(var_173, var_211);
            var_214 = wp::add(var_87, var_213);
            // wp::array_store(var_joint_qd, var_214, var_212);
            // joint_qd[qd_start + 3] = w_err_c[0]                                                <L 807>
            var_216 = wp::extract(var_174, var_215);
            var_218 = wp::add(var_87, var_217);
            // wp::array_store(var_joint_qd, var_218, var_216);
            // joint_qd[qd_start + 4] = w_err_c[1]                                                <L 808>
            var_220 = wp::extract(var_174, var_219);
            var_222 = wp::add(var_87, var_221);
            // wp::array_store(var_joint_qd, var_222, var_220);
            // joint_qd[qd_start + 5] = w_err_c[2]                                                <L 809>
            var_224 = wp::extract(var_174, var_223);
            var_226 = wp::add(var_87, var_225);
            // wp::array_store(var_joint_qd, var_226, var_224);
            // return                                                                             <L 811>
            goto label8;
        }
        var_227 = wp::where(var_154, var_160, var_151);
        // if type == JointType.D6:                                                               <L 813>
        var_229 = (var_74 == var_228);
        if (var_229) {
            // x_err_c = wp.quat_rotate_inv(q_p, x_err)                                           <L 814>
            var_230 = wp::quat_rotate_inv(var_78, var_80);
            // v_err_c = wp.quat_rotate_inv(q_p, v_err)                                           <L 815>
            var_231 = wp::quat_rotate_inv(var_78, var_81);
            // if lin_axis_count > 0:                                                             <L 816>
            var_233 = (var_91 > var_232);
            if (var_233) {
                // axis = joint_axis[qd_start + 0]                                                <L 817>
                var_235 = wp::add(var_87, var_234);
                var_236 = wp::address(var_joint_axis, var_235);
                var_238 = wp::load(var_236);
                var_237 = wp::copy(var_238);
                // joint_q[q_start + 0] = wp.dot(x_err_c, axis)                                   <L 818>
                var_239 = wp::dot(var_230, var_237);
                var_241 = wp::add(var_84, var_240);
                // wp::array_store(var_joint_q, var_241, var_239);
                // joint_qd[qd_start + 0] = wp.dot(v_err_c, axis)                                 <L 819>
                var_242 = wp::dot(var_231, var_237);
                var_244 = wp::add(var_87, var_243);
                // wp::array_store(var_joint_qd, var_244, var_242);
            }
            var_245 = wp::where(var_233, var_237, var_114);
            // if lin_axis_count > 1:                                                             <L 821>
            var_247 = (var_91 > var_246);
            if (var_247) {
                // axis = joint_axis[qd_start + 1]                                                <L 822>
                var_249 = wp::add(var_87, var_248);
                var_250 = wp::address(var_joint_axis, var_249);
                var_252 = wp::load(var_250);
                var_251 = wp::copy(var_252);
                // joint_q[q_start + 1] = wp.dot(x_err_c, axis)                                   <L 823>
                var_253 = wp::dot(var_230, var_251);
                var_255 = wp::add(var_84, var_254);
                // wp::array_store(var_joint_q, var_255, var_253);
                // joint_qd[qd_start + 1] = wp.dot(v_err_c, axis)                                 <L 824>
                var_256 = wp::dot(var_231, var_251);
                var_258 = wp::add(var_87, var_257);
                // wp::array_store(var_joint_qd, var_258, var_256);
            }
            var_259 = wp::where(var_247, var_251, var_245);
            // if lin_axis_count > 2:                                                             <L 826>
            var_261 = (var_91 > var_260);
            if (var_261) {
                // axis = joint_axis[qd_start + 2]                                                <L 827>
                var_263 = wp::add(var_87, var_262);
                var_264 = wp::address(var_joint_axis, var_263);
                var_266 = wp::load(var_264);
                var_265 = wp::copy(var_266);
                // joint_q[q_start + 2] = wp.dot(x_err_c, axis)                                   <L 828>
                var_267 = wp::dot(var_230, var_265);
                var_269 = wp::add(var_84, var_268);
                // wp::array_store(var_joint_q, var_269, var_267);
                // joint_qd[qd_start + 2] = wp.dot(v_err_c, axis)                                 <L 829>
                var_270 = wp::dot(var_231, var_265);
                var_272 = wp::add(var_87, var_271);
                // wp::array_store(var_joint_qd, var_272, var_270);
            }
            var_273 = wp::where(var_261, var_265, var_259);
            // if ang_axis_count == 1:                                                            <L 831>
            var_275 = (var_95 == var_274);
            if (var_275) {
                // axis = joint_axis[qd_start]                                                    <L 832>
                var_276 = wp::address(var_joint_axis, var_87);
                var_278 = wp::load(var_276);
                var_277 = wp::copy(var_278);
                // q_pc = wp.quat_inverse(q_p) * q_c                                              <L 833>
                var_279 = wp::quat_inverse(var_78);
                var_280 = wp::mul(var_279, var_79);
                // q, qd = reconstruct_angular_q_qd(q_pc, w_err, X_wpj, joint_axis[qd_start + lin_axis_count])       <L 834>
                var_281 = wp::add(var_87, var_91);
                var_282 = wp::address(var_joint_axis, var_281);
                var_285 = wp::load(var_282);
                reconstruct_angular_q_qd_0(var_280, var_82, var_60, var_285, var_283, var_284);
                // joint_q[q_start + lin_axis_count] = q                                          <L 835>
                var_286 = wp::add(var_84, var_91);
                // wp::array_store(var_joint_q, var_286, var_283);
                // joint_qd[qd_start + lin_axis_count] = qd                                       <L 836>
                var_287 = wp::add(var_87, var_91);
                // wp::array_store(var_joint_qd, var_287, var_284);
            }
            var_288 = wp::where(var_275, var_277, var_273);
            var_289 = wp::where(var_275, var_283, var_115);
            var_290 = wp::where(var_275, var_284, var_116);
            var_291 = wp::where(var_275, var_280, var_227);
            // if ang_axis_count == 2:                                                            <L 838>
            var_293 = (var_95 == var_292);
            if (var_293) {
                // axis_0 = joint_axis[qd_start + lin_axis_count + 0]                             <L 839>
                var_294 = wp::add(var_87, var_91);
                var_296 = wp::add(var_294, var_295);
                var_297 = wp::address(var_joint_axis, var_296);
                var_299 = wp::load(var_297);
                var_298 = wp::copy(var_299);
                // axis_1 = joint_axis[qd_start + lin_axis_count + 1]                             <L 840>
                var_300 = wp::add(var_87, var_91);
                var_302 = wp::add(var_300, var_301);
                var_303 = wp::address(var_joint_axis, var_302);
                var_305 = wp::load(var_303);
                var_304 = wp::copy(var_305);
                // qs2, qds2 = invert_2d_rotational_dofs(axis_0, axis_1, q_p, q_c, w_err)         <L 841>
                invert_2d_rotational_dofs_0(var_298, var_304, var_78, var_79, var_82, var_306, var_307);
                // joint_q[q_start + lin_axis_count + 0] = qs2[0]                                 <L 842>
                var_309 = wp::extract(var_306, var_308);
                var_310 = wp::add(var_84, var_91);
                var_312 = wp::add(var_310, var_311);
                // wp::array_store(var_joint_q, var_312, var_309);
                // joint_q[q_start + lin_axis_count + 1] = qs2[1]                                 <L 843>
                var_314 = wp::extract(var_306, var_313);
                var_315 = wp::add(var_84, var_91);
                var_317 = wp::add(var_315, var_316);
                // wp::array_store(var_joint_q, var_317, var_314);
                // joint_qd[qd_start + lin_axis_count + 0] = qds2[0]                              <L 844>
                var_319 = wp::extract(var_307, var_318);
                var_320 = wp::add(var_87, var_91);
                var_322 = wp::add(var_320, var_321);
                // wp::array_store(var_joint_qd, var_322, var_319);
                // joint_qd[qd_start + lin_axis_count + 1] = qds2[1]                              <L 845>
                var_324 = wp::extract(var_307, var_323);
                var_325 = wp::add(var_87, var_91);
                var_327 = wp::add(var_325, var_326);
                // wp::array_store(var_joint_qd, var_327, var_324);
            }
            // if ang_axis_count == 3:                                                            <L 847>
            var_329 = (var_95 == var_328);
            if (var_329) {
                // axis_0 = joint_axis[qd_start + lin_axis_count + 0]                             <L 848>
                var_330 = wp::add(var_87, var_91);
                var_332 = wp::add(var_330, var_331);
                var_333 = wp::address(var_joint_axis, var_332);
                var_335 = wp::load(var_333);
                var_334 = wp::copy(var_335);
                // axis_1 = joint_axis[qd_start + lin_axis_count + 1]                             <L 849>
                var_336 = wp::add(var_87, var_91);
                var_338 = wp::add(var_336, var_337);
                var_339 = wp::address(var_joint_axis, var_338);
                var_341 = wp::load(var_339);
                var_340 = wp::copy(var_341);
                // axis_2 = joint_axis[qd_start + lin_axis_count + 2]                             <L 850>
                var_342 = wp::add(var_87, var_91);
                var_344 = wp::add(var_342, var_343);
                var_345 = wp::address(var_joint_axis, var_344);
                var_347 = wp::load(var_345);
                var_346 = wp::copy(var_347);
                // qs3, qds3 = invert_3d_rotational_dofs(axis_0, axis_1, axis_2, q_p, q_c, w_err)       <L 851>
                invert_3d_rotational_dofs_0(var_334, var_340, var_346, var_78, var_79, var_82, var_348, var_349);
                // joint_q[q_start + lin_axis_count + 0] = qs3[0]                                 <L 852>
                var_351 = wp::extract(var_348, var_350);
                var_352 = wp::add(var_84, var_91);
                var_354 = wp::add(var_352, var_353);
                // wp::array_store(var_joint_q, var_354, var_351);
                // joint_q[q_start + lin_axis_count + 1] = qs3[1]                                 <L 853>
                var_356 = wp::extract(var_348, var_355);
                var_357 = wp::add(var_84, var_91);
                var_359 = wp::add(var_357, var_358);
                // wp::array_store(var_joint_q, var_359, var_356);
                // joint_q[q_start + lin_axis_count + 2] = qs3[2]                                 <L 854>
                var_361 = wp::extract(var_348, var_360);
                var_362 = wp::add(var_84, var_91);
                var_364 = wp::add(var_362, var_363);
                // wp::array_store(var_joint_q, var_364, var_361);
                // joint_qd[qd_start + lin_axis_count + 0] = qds3[0]                              <L 855>
                var_366 = wp::extract(var_349, var_365);
                var_367 = wp::add(var_87, var_91);
                var_369 = wp::add(var_367, var_368);
                // wp::array_store(var_joint_qd, var_369, var_366);
                // joint_qd[qd_start + lin_axis_count + 1] = qds3[1]                              <L 856>
                var_371 = wp::extract(var_349, var_370);
                var_372 = wp::add(var_87, var_91);
                var_374 = wp::add(var_372, var_373);
                // wp::array_store(var_joint_qd, var_374, var_371);
                // joint_qd[qd_start + lin_axis_count + 2] = qds3[2]                              <L 857>
                var_376 = wp::extract(var_349, var_375);
                var_377 = wp::add(var_87, var_91);
                var_379 = wp::add(var_377, var_378);
                // wp::array_store(var_joint_qd, var_379, var_376);
            }
            var_380 = wp::where(var_329, var_334, var_298);
            var_381 = wp::where(var_329, var_340, var_304);
            // return                                                                             <L 859>
            goto label9;
        }
        var_382 = wp::where(var_229, var_288, var_114);
        var_383 = wp::where(var_229, var_289, var_115);
        var_384 = wp::where(var_229, var_290, var_116);
        var_385 = wp::where(var_229, var_291, var_227);
        var_386 = wp::where(var_229, var_230, var_161);
        var_387 = wp::where(var_229, var_231, var_173);
        //---------
        // reverse
        wp::adj_where(var_229, var_231, var_173, adj_229, adj_231, adj_173, adj_387);
        wp::adj_where(var_229, var_230, var_161, adj_229, adj_230, adj_161, adj_386);
        wp::adj_where(var_229, var_291, var_227, adj_229, adj_291, adj_227, adj_385);
        wp::adj_where(var_229, var_290, var_116, adj_229, adj_290, adj_116, adj_384);
        wp::adj_where(var_229, var_289, var_115, adj_229, adj_289, adj_115, adj_383);
        wp::adj_where(var_229, var_288, var_114, adj_229, adj_288, adj_114, adj_382);
        if (var_229) {
            label9:;
            // adj: return                                                                        <L 859>
            wp::adj_where(var_329, var_340, var_304, adj_329, adj_340, adj_304, adj_381);
            wp::adj_where(var_329, var_334, var_298, adj_329, adj_334, adj_298, adj_380);
            if (var_329) {
                wp::adj_array_store(var_joint_qd, var_379, var_376, adj_joint_qd, adj_379, adj_376);
                wp::adj_add(var_377, var_378, adj_377, adj_378, adj_379);
                wp::adj_add(var_87, var_91, adj_87, adj_91, adj_377);
                wp::adj_extract(var_349, var_375, adj_349, adj_375, adj_376);
                // adj: joint_qd[qd_start + lin_axis_count + 2] = qds3[2]                         <L 857>
                wp::adj_array_store(var_joint_qd, var_374, var_371, adj_joint_qd, adj_374, adj_371);
                wp::adj_add(var_372, var_373, adj_372, adj_373, adj_374);
                wp::adj_add(var_87, var_91, adj_87, adj_91, adj_372);
                wp::adj_extract(var_349, var_370, adj_349, adj_370, adj_371);
                // adj: joint_qd[qd_start + lin_axis_count + 1] = qds3[1]                         <L 856>
                wp::adj_array_store(var_joint_qd, var_369, var_366, adj_joint_qd, adj_369, adj_366);
                wp::adj_add(var_367, var_368, adj_367, adj_368, adj_369);
                wp::adj_add(var_87, var_91, adj_87, adj_91, adj_367);
                wp::adj_extract(var_349, var_365, adj_349, adj_365, adj_366);
                // adj: joint_qd[qd_start + lin_axis_count + 0] = qds3[0]                         <L 855>
                wp::adj_array_store(var_joint_q, var_364, var_361, adj_joint_q, adj_364, adj_361);
                wp::adj_add(var_362, var_363, adj_362, adj_363, adj_364);
                wp::adj_add(var_84, var_91, adj_84, adj_91, adj_362);
                wp::adj_extract(var_348, var_360, adj_348, adj_360, adj_361);
                // adj: joint_q[q_start + lin_axis_count + 2] = qs3[2]                            <L 854>
                wp::adj_array_store(var_joint_q, var_359, var_356, adj_joint_q, adj_359, adj_356);
                wp::adj_add(var_357, var_358, adj_357, adj_358, adj_359);
                wp::adj_add(var_84, var_91, adj_84, adj_91, adj_357);
                wp::adj_extract(var_348, var_355, adj_348, adj_355, adj_356);
                // adj: joint_q[q_start + lin_axis_count + 1] = qs3[1]                            <L 853>
                wp::adj_array_store(var_joint_q, var_354, var_351, adj_joint_q, adj_354, adj_351);
                wp::adj_add(var_352, var_353, adj_352, adj_353, adj_354);
                wp::adj_add(var_84, var_91, adj_84, adj_91, adj_352);
                wp::adj_extract(var_348, var_350, adj_348, adj_350, adj_351);
                // adj: joint_q[q_start + lin_axis_count + 0] = qs3[0]                            <L 852>
                adj_invert_3d_rotational_dofs_0(var_334, var_340, var_346, var_78, var_79, var_82, var_348, var_349, adj_334, adj_340, adj_346, adj_78, adj_79, adj_82, adj_348, adj_349);
                // adj: qs3, qds3 = invert_3d_rotational_dofs(axis_0, axis_1, axis_2, q_p, q_c, w_err)  <L 851>
                wp::adj_copy(var_347, adj_345, adj_346);
                wp::adj_address(var_joint_axis, var_344, adj_joint_axis, adj_344, adj_345);
                wp::adj_add(var_342, var_343, adj_342, adj_343, adj_344);
                wp::adj_add(var_87, var_91, adj_87, adj_91, adj_342);
                // adj: axis_2 = joint_axis[qd_start + lin_axis_count + 2]                        <L 850>
                wp::adj_copy(var_341, adj_339, adj_340);
                wp::adj_address(var_joint_axis, var_338, adj_joint_axis, adj_338, adj_339);
                wp::adj_add(var_336, var_337, adj_336, adj_337, adj_338);
                wp::adj_add(var_87, var_91, adj_87, adj_91, adj_336);
                // adj: axis_1 = joint_axis[qd_start + lin_axis_count + 1]                        <L 849>
                wp::adj_copy(var_335, adj_333, adj_334);
                wp::adj_address(var_joint_axis, var_332, adj_joint_axis, adj_332, adj_333);
                wp::adj_add(var_330, var_331, adj_330, adj_331, adj_332);
                wp::adj_add(var_87, var_91, adj_87, adj_91, adj_330);
                // adj: axis_0 = joint_axis[qd_start + lin_axis_count + 0]                        <L 848>
            }
            // adj: if ang_axis_count == 3:                                                       <L 847>
            if (var_293) {
                wp::adj_array_store(var_joint_qd, var_327, var_324, adj_joint_qd, adj_327, adj_324);
                wp::adj_add(var_325, var_326, adj_325, adj_326, adj_327);
                wp::adj_add(var_87, var_91, adj_87, adj_91, adj_325);
                wp::adj_extract(var_307, var_323, adj_307, adj_323, adj_324);
                // adj: joint_qd[qd_start + lin_axis_count + 1] = qds2[1]                         <L 845>
                wp::adj_array_store(var_joint_qd, var_322, var_319, adj_joint_qd, adj_322, adj_319);
                wp::adj_add(var_320, var_321, adj_320, adj_321, adj_322);
                wp::adj_add(var_87, var_91, adj_87, adj_91, adj_320);
                wp::adj_extract(var_307, var_318, adj_307, adj_318, adj_319);
                // adj: joint_qd[qd_start + lin_axis_count + 0] = qds2[0]                         <L 844>
                wp::adj_array_store(var_joint_q, var_317, var_314, adj_joint_q, adj_317, adj_314);
                wp::adj_add(var_315, var_316, adj_315, adj_316, adj_317);
                wp::adj_add(var_84, var_91, adj_84, adj_91, adj_315);
                wp::adj_extract(var_306, var_313, adj_306, adj_313, adj_314);
                // adj: joint_q[q_start + lin_axis_count + 1] = qs2[1]                            <L 843>
                wp::adj_array_store(var_joint_q, var_312, var_309, adj_joint_q, adj_312, adj_309);
                wp::adj_add(var_310, var_311, adj_310, adj_311, adj_312);
                wp::adj_add(var_84, var_91, adj_84, adj_91, adj_310);
                wp::adj_extract(var_306, var_308, adj_306, adj_308, adj_309);
                // adj: joint_q[q_start + lin_axis_count + 0] = qs2[0]                            <L 842>
                adj_invert_2d_rotational_dofs_0(var_298, var_304, var_78, var_79, var_82, var_306, var_307, adj_298, adj_304, adj_78, adj_79, adj_82, adj_306, adj_307);
                // adj: qs2, qds2 = invert_2d_rotational_dofs(axis_0, axis_1, q_p, q_c, w_err)    <L 841>
                wp::adj_copy(var_305, adj_303, adj_304);
                wp::adj_address(var_joint_axis, var_302, adj_joint_axis, adj_302, adj_303);
                wp::adj_add(var_300, var_301, adj_300, adj_301, adj_302);
                wp::adj_add(var_87, var_91, adj_87, adj_91, adj_300);
                // adj: axis_1 = joint_axis[qd_start + lin_axis_count + 1]                        <L 840>
                wp::adj_copy(var_299, adj_297, adj_298);
                wp::adj_address(var_joint_axis, var_296, adj_joint_axis, adj_296, adj_297);
                wp::adj_add(var_294, var_295, adj_294, adj_295, adj_296);
                wp::adj_add(var_87, var_91, adj_87, adj_91, adj_294);
                // adj: axis_0 = joint_axis[qd_start + lin_axis_count + 0]                        <L 839>
            }
            // adj: if ang_axis_count == 2:                                                       <L 838>
            wp::adj_where(var_275, var_280, var_227, adj_275, adj_280, adj_227, adj_291);
            wp::adj_where(var_275, var_284, var_116, adj_275, adj_284, adj_116, adj_290);
            wp::adj_where(var_275, var_283, var_115, adj_275, adj_283, adj_115, adj_289);
            wp::adj_where(var_275, var_277, var_273, adj_275, adj_277, adj_273, adj_288);
            if (var_275) {
                wp::adj_array_store(var_joint_qd, var_287, var_284, adj_joint_qd, adj_287, adj_284);
                wp::adj_add(var_87, var_91, adj_87, adj_91, adj_287);
                // adj: joint_qd[qd_start + lin_axis_count] = qd                                  <L 836>
                wp::adj_array_store(var_joint_q, var_286, var_283, adj_joint_q, adj_286, adj_283);
                wp::adj_add(var_84, var_91, adj_84, adj_91, adj_286);
                // adj: joint_q[q_start + lin_axis_count] = q                                     <L 835>
                adj_reconstruct_angular_q_qd_0(var_280, var_82, var_60, var_285, var_283, var_284, adj_280, adj_82, adj_60, adj_282, adj_283, adj_284);
                wp::adj_address(var_joint_axis, var_281, adj_joint_axis, adj_281, adj_282);
                wp::adj_add(var_87, var_91, adj_87, adj_91, adj_281);
                // adj: q, qd = reconstruct_angular_q_qd(q_pc, w_err, X_wpj, joint_axis[qd_start + lin_axis_count])  <L 834>
                wp::adj_mul(var_279, var_79, adj_279, adj_79, adj_280);
                wp::adj_quat_inverse(var_78, adj_78, adj_279);
                // adj: q_pc = wp.quat_inverse(q_p) * q_c                                         <L 833>
                wp::adj_copy(var_278, adj_276, adj_277);
                wp::adj_address(var_joint_axis, var_87, adj_joint_axis, adj_87, adj_276);
                // adj: axis = joint_axis[qd_start]                                               <L 832>
            }
            // adj: if ang_axis_count == 1:                                                       <L 831>
            wp::adj_where(var_261, var_265, var_259, adj_261, adj_265, adj_259, adj_273);
            if (var_261) {
                wp::adj_array_store(var_joint_qd, var_272, var_270, adj_joint_qd, adj_272, adj_270);
                wp::adj_add(var_87, var_271, adj_87, adj_271, adj_272);
                wp::adj_dot(var_231, var_265, adj_231, adj_265, adj_270);
                // adj: joint_qd[qd_start + 2] = wp.dot(v_err_c, axis)                            <L 829>
                wp::adj_array_store(var_joint_q, var_269, var_267, adj_joint_q, adj_269, adj_267);
                wp::adj_add(var_84, var_268, adj_84, adj_268, adj_269);
                wp::adj_dot(var_230, var_265, adj_230, adj_265, adj_267);
                // adj: joint_q[q_start + 2] = wp.dot(x_err_c, axis)                              <L 828>
                wp::adj_copy(var_266, adj_264, adj_265);
                wp::adj_address(var_joint_axis, var_263, adj_joint_axis, adj_263, adj_264);
                wp::adj_add(var_87, var_262, adj_87, adj_262, adj_263);
                // adj: axis = joint_axis[qd_start + 2]                                           <L 827>
            }
            // adj: if lin_axis_count > 2:                                                        <L 826>
            wp::adj_where(var_247, var_251, var_245, adj_247, adj_251, adj_245, adj_259);
            if (var_247) {
                wp::adj_array_store(var_joint_qd, var_258, var_256, adj_joint_qd, adj_258, adj_256);
                wp::adj_add(var_87, var_257, adj_87, adj_257, adj_258);
                wp::adj_dot(var_231, var_251, adj_231, adj_251, adj_256);
                // adj: joint_qd[qd_start + 1] = wp.dot(v_err_c, axis)                            <L 824>
                wp::adj_array_store(var_joint_q, var_255, var_253, adj_joint_q, adj_255, adj_253);
                wp::adj_add(var_84, var_254, adj_84, adj_254, adj_255);
                wp::adj_dot(var_230, var_251, adj_230, adj_251, adj_253);
                // adj: joint_q[q_start + 1] = wp.dot(x_err_c, axis)                              <L 823>
                wp::adj_copy(var_252, adj_250, adj_251);
                wp::adj_address(var_joint_axis, var_249, adj_joint_axis, adj_249, adj_250);
                wp::adj_add(var_87, var_248, adj_87, adj_248, adj_249);
                // adj: axis = joint_axis[qd_start + 1]                                           <L 822>
            }
            // adj: if lin_axis_count > 1:                                                        <L 821>
            wp::adj_where(var_233, var_237, var_114, adj_233, adj_237, adj_114, adj_245);
            if (var_233) {
                wp::adj_array_store(var_joint_qd, var_244, var_242, adj_joint_qd, adj_244, adj_242);
                wp::adj_add(var_87, var_243, adj_87, adj_243, adj_244);
                wp::adj_dot(var_231, var_237, adj_231, adj_237, adj_242);
                // adj: joint_qd[qd_start + 0] = wp.dot(v_err_c, axis)                            <L 819>
                wp::adj_array_store(var_joint_q, var_241, var_239, adj_joint_q, adj_241, adj_239);
                wp::adj_add(var_84, var_240, adj_84, adj_240, adj_241);
                wp::adj_dot(var_230, var_237, adj_230, adj_237, adj_239);
                // adj: joint_q[q_start + 0] = wp.dot(x_err_c, axis)                              <L 818>
                wp::adj_copy(var_238, adj_236, adj_237);
                wp::adj_address(var_joint_axis, var_235, adj_joint_axis, adj_235, adj_236);
                wp::adj_add(var_87, var_234, adj_87, adj_234, adj_235);
                // adj: axis = joint_axis[qd_start + 0]                                           <L 817>
            }
            // adj: if lin_axis_count > 0:                                                        <L 816>
            wp::adj_quat_rotate_inv(var_78, var_81, adj_78, adj_81, adj_231);
            // adj: v_err_c = wp.quat_rotate_inv(q_p, v_err)                                      <L 815>
            wp::adj_quat_rotate_inv(var_78, var_80, adj_78, adj_80, adj_230);
            // adj: x_err_c = wp.quat_rotate_inv(q_p, x_err)                                      <L 814>
        }
        // adj: if type == JointType.D6:                                                          <L 813>
        wp::adj_where(var_154, var_160, var_151, adj_154, adj_160, adj_151, adj_227);
        if (var_154) {
            label8:;
            // adj: return                                                                        <L 811>
            wp::adj_array_store(var_joint_qd, var_226, var_224, adj_joint_qd, adj_226, adj_224);
            wp::adj_add(var_87, var_225, adj_87, adj_225, adj_226);
            wp::adj_extract(var_174, var_223, adj_174, adj_223, adj_224);
            // adj: joint_qd[qd_start + 5] = w_err_c[2]                                           <L 809>
            wp::adj_array_store(var_joint_qd, var_222, var_220, adj_joint_qd, adj_222, adj_220);
            wp::adj_add(var_87, var_221, adj_87, adj_221, adj_222);
            wp::adj_extract(var_174, var_219, adj_174, adj_219, adj_220);
            // adj: joint_qd[qd_start + 4] = w_err_c[1]                                           <L 808>
            wp::adj_array_store(var_joint_qd, var_218, var_216, adj_joint_qd, adj_218, adj_216);
            wp::adj_add(var_87, var_217, adj_87, adj_217, adj_218);
            wp::adj_extract(var_174, var_215, adj_174, adj_215, adj_216);
            // adj: joint_qd[qd_start + 3] = w_err_c[0]                                           <L 807>
            wp::adj_array_store(var_joint_qd, var_214, var_212, adj_joint_qd, adj_214, adj_212);
            wp::adj_add(var_87, var_213, adj_87, adj_213, adj_214);
            wp::adj_extract(var_173, var_211, adj_173, adj_211, adj_212);
            // adj: joint_qd[qd_start + 2] = v_err_c[2]                                           <L 805>
            wp::adj_array_store(var_joint_qd, var_210, var_208, adj_joint_qd, adj_210, adj_208);
            wp::adj_add(var_87, var_209, adj_87, adj_209, adj_210);
            wp::adj_extract(var_173, var_207, adj_173, adj_207, adj_208);
            // adj: joint_qd[qd_start + 1] = v_err_c[1]                                           <L 804>
            wp::adj_array_store(var_joint_qd, var_206, var_204, adj_joint_qd, adj_206, adj_204);
            wp::adj_add(var_87, var_205, adj_87, adj_205, adj_206);
            wp::adj_extract(var_173, var_203, adj_173, adj_203, adj_204);
            // adj: joint_qd[qd_start + 0] = v_err_c[0]                                           <L 803>
            wp::adj_array_store(var_joint_q, var_202, var_200, adj_joint_q, adj_202, adj_200);
            wp::adj_add(var_84, var_201, adj_84, adj_201, adj_202);
            wp::adj_extract(var_160, var_199, adj_160, adj_199, adj_200);
            // adj: joint_q[q_start + 6] = q_pc[3]                                                <L 801>
            wp::adj_array_store(var_joint_q, var_198, var_196, adj_joint_q, adj_198, adj_196);
            wp::adj_add(var_84, var_197, adj_84, adj_197, adj_198);
            wp::adj_extract(var_160, var_195, adj_160, adj_195, adj_196);
            // adj: joint_q[q_start + 5] = q_pc[2]                                                <L 800>
            wp::adj_array_store(var_joint_q, var_194, var_192, adj_joint_q, adj_194, adj_192);
            wp::adj_add(var_84, var_193, adj_84, adj_193, adj_194);
            wp::adj_extract(var_160, var_191, adj_160, adj_191, adj_192);
            // adj: joint_q[q_start + 4] = q_pc[1]                                                <L 799>
            wp::adj_array_store(var_joint_q, var_190, var_188, adj_joint_q, adj_190, adj_188);
            wp::adj_add(var_84, var_189, adj_84, adj_189, adj_190);
            wp::adj_extract(var_160, var_187, adj_160, adj_187, adj_188);
            // adj: joint_q[q_start + 3] = q_pc[0]                                                <L 798>
            wp::adj_array_store(var_joint_q, var_186, var_184, adj_joint_q, adj_186, adj_184);
            wp::adj_add(var_84, var_185, adj_84, adj_185, adj_186);
            wp::adj_extract(var_161, var_183, adj_161, adj_183, adj_184);
            // adj: joint_q[q_start + 2] = x_err_c[2]                                             <L 796>
            wp::adj_array_store(var_joint_q, var_182, var_180, adj_joint_q, adj_182, adj_180);
            wp::adj_add(var_84, var_181, adj_84, adj_181, adj_182);
            wp::adj_extract(var_161, var_179, adj_161, adj_179, adj_180);
            // adj: joint_q[q_start + 1] = x_err_c[1]                                             <L 795>
            wp::adj_array_store(var_joint_q, var_178, var_176, adj_joint_q, adj_178, adj_176);
            wp::adj_add(var_84, var_177, adj_84, adj_177, adj_178);
            wp::adj_extract(var_161, var_175, adj_161, adj_175, adj_176);
            // adj: joint_q[q_start + 0] = x_err_c[0]                                             <L 794>
            wp::adj_quat_rotate_inv(var_78, var_82, adj_78, adj_82, adj_174);
            // adj: w_err_c = wp.quat_rotate_inv(q_p, w_err)                                      <L 792>
            wp::adj_quat_rotate_inv(var_78, var_172, adj_78, adj_172, adj_173);
            // adj: v_err_c = wp.quat_rotate_inv(q_p, v_com_err)                                  <L 791>
            wp::adj_where(var_167, var_171, var_165, adj_167, adj_171, adj_165, adj_172);
            if (var_167) {
                wp::adj_sub(var_165, var_169, adj_165, adj_169, adj_171);
                adj_com_twist_to_point_velocity_0(var_59, var_46, var_170, var_163, adj_59, adj_46, adj_168, adj_163, adj_169);
                wp::adj_address(var_body_com, var_23, adj_body_com, adj_23, adj_168);
                // adj: v_com_err = v_com_err - com_twist_to_point_velocity(v_wp, X_wp, body_com[parent], x_child_com_world)  <L 790>
            }
            // adj: if parent >= 0:                                                               <L 789>
            wp::adj_spatial_top(var_66, adj_66, adj_165);
            // adj: v_com_err = wp.spatial_top(v_wc)                                              <L 788>
            wp::adj_transform_point(var_62, var_164, adj_62, adj_162, adj_163);
            wp::adj_address(var_body_com, var_26, adj_body_com, adj_26, adj_162);
            // adj: x_child_com_world = wp.transform_point(X_wc, body_com[child])                 <L 787>
            wp::adj_quat_rotate_inv(var_78, var_80, adj_78, adj_80, adj_161);
            // adj: x_err_c = wp.quat_rotate_inv(q_p, x_err)                                      <L 786>
            wp::adj_mul(var_159, var_79, adj_159, adj_79, adj_160);
            wp::adj_quat_inverse(var_78, adj_78, adj_159);
            // adj: q_pc = wp.quat_inverse(q_p) * q_c                                             <L 784>
        }
        if (!var_154) {
        }
        // adj: if type == JointType.FREE or type == JointType.DISTANCE:                          <L 783>
        if (var_153) {
            label7:;
            // adj: return                                                                        <L 781>
        }
        // adj: if type == JointType.FIXED:                                                       <L 780>
        wp::adj_where(var_118, var_120, var_111, adj_118, adj_120, adj_111, adj_151);
        if (var_118) {
            label6:;
            // adj: return                                                                        <L 778>
            wp::adj_array_store(var_joint_qd, var_150, var_148, adj_joint_qd, adj_150, adj_148);
            wp::adj_add(var_87, var_149, adj_87, adj_149, adj_150);
            wp::adj_extract(var_138, var_147, adj_138, adj_147, adj_148);
            // adj: joint_qd[qd_start + 2] = ang_vel[2]                                           <L 776>
            wp::adj_array_store(var_joint_qd, var_146, var_144, adj_joint_qd, adj_146, adj_144);
            wp::adj_add(var_87, var_145, adj_87, adj_145, adj_146);
            wp::adj_extract(var_138, var_143, adj_138, adj_143, adj_144);
            // adj: joint_qd[qd_start + 1] = ang_vel[1]                                           <L 775>
            wp::adj_array_store(var_joint_qd, var_142, var_140, adj_joint_qd, adj_142, adj_140);
            wp::adj_add(var_87, var_141, adj_87, adj_141, adj_142);
            wp::adj_extract(var_138, var_139, adj_138, adj_139, adj_140);
            // adj: joint_qd[qd_start + 0] = ang_vel[0]                                           <L 774>
            wp::adj_transform_vector(var_137, var_82, adj_137, adj_82, adj_138);
            wp::adj_transform_inverse(var_60, adj_60, adj_137);
            // adj: ang_vel = wp.transform_vector(wp.transform_inverse(X_wpj), w_err)             <L 773>
            wp::adj_array_store(var_joint_q, var_136, var_134, adj_joint_q, adj_136, adj_134);
            wp::adj_add(var_84, var_135, adj_84, adj_135, adj_136);
            wp::adj_extract(var_120, var_133, adj_120, adj_133, adj_134);
            // adj: joint_q[q_start + 3] = q_pc[3]                                                <L 771>
            wp::adj_array_store(var_joint_q, var_132, var_130, adj_joint_q, adj_132, adj_130);
            wp::adj_add(var_84, var_131, adj_84, adj_131, adj_132);
            wp::adj_extract(var_120, var_129, adj_120, adj_129, adj_130);
            // adj: joint_q[q_start + 2] = q_pc[2]                                                <L 770>
            wp::adj_array_store(var_joint_q, var_128, var_126, adj_joint_q, adj_128, adj_126);
            wp::adj_add(var_84, var_127, adj_84, adj_127, adj_128);
            wp::adj_extract(var_120, var_125, adj_120, adj_125, adj_126);
            // adj: joint_q[q_start + 1] = q_pc[1]                                                <L 769>
            wp::adj_array_store(var_joint_q, var_124, var_122, adj_joint_q, adj_124, adj_122);
            wp::adj_add(var_84, var_123, adj_84, adj_123, adj_124);
            wp::adj_extract(var_120, var_121, adj_120, adj_121, adj_122);
            // adj: joint_q[q_start + 0] = q_pc[0]                                                <L 768>
            wp::adj_mul(var_119, var_79, adj_119, adj_79, adj_120);
            wp::adj_quat_inverse(var_78, adj_78, adj_119);
            // adj: q_pc = wp.quat_inverse(q_p) * q_c                                             <L 766>
        }
        // adj: if type == JointType.BALL:                                                        <L 765>
        wp::adj_where(var_106, var_113, var_104, adj_106, adj_113, adj_104, adj_116);
        wp::adj_where(var_106, var_112, var_103, adj_106, adj_112, adj_103, adj_115);
        wp::adj_where(var_106, var_108, var_100, adj_106, adj_108, adj_100, adj_114);
        if (var_106) {
            label5:;
            // adj: return                                                                        <L 763>
            wp::adj_array_store(var_joint_qd, var_87, var_113, adj_joint_qd, adj_87, adj_113);
            // adj: joint_qd[qd_start] = qd                                                       <L 761>
            wp::adj_array_store(var_joint_q, var_84, var_112, adj_joint_q, adj_84, adj_112);
            // adj: joint_q[q_start] = q                                                          <L 760>
            adj_reconstruct_angular_q_qd_0(var_111, var_82, var_60, var_108, var_112, var_113, adj_111, adj_82, adj_60, adj_108, adj_112, adj_113);
            // adj: q, qd = reconstruct_angular_q_qd(q_pc, w_err, X_wpj, axis)                    <L 758>
            wp::adj_mul(var_110, var_79, adj_110, adj_79, adj_111);
            wp::adj_quat_inverse(var_78, adj_78, adj_110);
            // adj: q_pc = wp.quat_inverse(q_p) * q_c                                             <L 756>
            wp::adj_copy(var_109, adj_107, adj_108);
            wp::adj_address(var_joint_axis, var_87, adj_joint_axis, adj_87, adj_107);
            // adj: axis = joint_axis[qd_start]                                                   <L 755>
        }
        // adj: if type == JointType.REVOLUTE:                                                    <L 754>
        if (var_98) {
            label4:;
            // adj: return                                                                        <L 752>
            wp::adj_array_store(var_joint_qd, var_87, var_104, adj_joint_qd, adj_87, adj_104);
            // adj: joint_qd[qd_start] = qd                                                       <L 750>
            wp::adj_array_store(var_joint_q, var_84, var_103, adj_joint_q, adj_84, adj_103);
            // adj: joint_q[q_start] = q                                                          <L 749>
            wp::adj_dot(var_81, var_102, adj_81, adj_102, adj_104);
            // adj: qd = wp.dot(v_err, axis_p)                                                    <L 747>
            wp::adj_dot(var_80, var_102, adj_80, adj_102, adj_103);
            // adj: q = wp.dot(x_err, axis_p)                                                     <L 746>
            wp::adj_quat_rotate(var_78, var_100, adj_78, adj_100, adj_102);
            // adj: axis_p = wp.quat_rotate(q_p, axis)                                            <L 743>
            wp::adj_copy(var_101, adj_99, adj_100);
            wp::adj_address(var_joint_axis, var_87, adj_joint_axis, adj_87, adj_99);
            // adj: axis = joint_axis[qd_start]                                                   <L 740>
        }
        // adj: if type == JointType.PRISMATIC:                                                   <L 739>
        wp::adj_copy(var_96, adj_94, adj_95);
        wp::adj_address(var_joint_dof_dim, var_20, var_93, adj_joint_dof_dim, adj_20, adj_93, adj_94);
        // adj: ang_axis_count = joint_dof_dim[joint_idx, 1]                                      <L 737>
        wp::adj_copy(var_92, adj_90, adj_91);
        wp::adj_address(var_joint_dof_dim, var_20, var_89, adj_joint_dof_dim, adj_20, adj_89, adj_90);
        // adj: lin_axis_count = joint_dof_dim[joint_idx, 0]                                      <L 736>
        wp::adj_copy(var_88, adj_86, adj_87);
        wp::adj_address(var_joint_qd_start, var_20, adj_joint_qd_start, adj_20, adj_86);
        // adj: qd_start = joint_qd_start[joint_idx]                                              <L 735>
        wp::adj_copy(var_85, adj_83, adj_84);
        wp::adj_address(var_joint_q_start, var_20, adj_joint_q_start, adj_20, adj_83);
        // adj: q_start = joint_q_start[joint_idx]                                                <L 734>
        wp::adj_sub(var_68, var_57, adj_68, adj_57, adj_82);
        // adj: w_err = w_c - w_p                                                                 <L 732>
        wp::adj_sub(var_71, var_58, adj_71, adj_58, adj_81);
        // adj: v_err = v_c - v_p                                                                 <L 731>
        wp::adj_sub(var_77, var_76, adj_77, adj_76, adj_80);
        // adj: x_err = x_c - x_p                                                                 <L 730>
        wp::adj_transform_get_rotation(var_64, adj_64, adj_79);
        // adj: q_c = wp.transform_get_rotation(X_wcj)                                            <L 728>
        wp::adj_transform_get_rotation(var_60, adj_60, adj_78);
        // adj: q_p = wp.transform_get_rotation(X_wpj)                                            <L 727>
        wp::adj_transform_get_translation(var_64, adj_64, adj_77);
        // adj: x_c = wp.transform_get_translation(X_wcj)                                         <L 725>
        wp::adj_transform_get_translation(var_60, adj_60, adj_76);
        // adj: x_p = wp.transform_get_translation(X_wpj)                                         <L 724>
        wp::adj_copy(var_75, adj_73, adj_74);
        wp::adj_address(var_joint_type, var_20, adj_joint_type, adj_20, adj_73);
        // adj: type = joint_type[joint_idx]                                                      <L 721>
        adj_com_twist_to_point_velocity_0(var_66, var_62, var_72, var_70, adj_66, adj_62, adj_69, adj_70, adj_71);
        wp::adj_transform_get_translation(var_64, adj_64, adj_70);
        wp::adj_address(var_body_com, var_26, adj_body_com, adj_26, adj_69);
        // adj: v_c = com_twist_to_point_velocity(v_wc, X_wc, body_com[child], wp.transform_get_translation(X_wcj))  <L 718>
        wp::adj_spatial_bottom(var_66, adj_66, adj_68);
        // adj: w_c = wp.spatial_bottom(v_wc)                                                     <L 717>
        wp::adj_copy(var_67, adj_65, adj_66);
        wp::adj_address(var_body_qd, var_26, adj_body_qd, adj_26, adj_65);
        // adj: v_wc = body_qd[child]                                                             <L 715>
        wp::adj_mul(var_62, var_37, adj_62, adj_37, adj_64);
        // adj: X_wcj = X_wc * X_cj                                                               <L 713>
        wp::adj_copy(var_63, adj_61, adj_62);
        wp::adj_address(var_body_q, var_26, adj_body_q, adj_26, adj_61);
        // adj: X_wc = body_q[child]                                                              <L 712>
        wp::adj_where(var_44, var_48, var_42, adj_44, adj_48, adj_42, adj_60);
        wp::adj_where(var_44, var_50, var_41, adj_44, adj_50, adj_41, adj_59);
        wp::adj_where(var_44, var_55, var_40, adj_44, adj_55, adj_40, adj_58);
        wp::adj_where(var_44, var_52, var_39, adj_44, adj_52, adj_39, adj_57);
        if (var_44) {
            adj_com_twist_to_point_velocity_0(var_50, var_46, var_56, var_54, adj_50, adj_46, adj_53, adj_54, adj_55);
            wp::adj_transform_get_translation(var_48, adj_48, adj_54);
            wp::adj_address(var_body_com, var_23, adj_body_com, adj_23, adj_53);
            // adj: v_p = com_twist_to_point_velocity(v_wp, X_wp, body_com[parent], wp.transform_get_translation(X_wpj))  <L 709>
            wp::adj_spatial_bottom(var_50, adj_50, adj_52);
            // adj: w_p = wp.spatial_bottom(v_wp)                                                 <L 708>
            wp::adj_copy(var_51, adj_49, adj_50);
            wp::adj_address(var_body_qd, var_23, adj_body_qd, adj_23, adj_49);
            // adj: v_wp = body_qd[parent]                                                        <L 707>
            wp::adj_mul(var_46, var_34, adj_46, adj_34, adj_48);
            // adj: X_wpj = X_wp * X_pj                                                           <L 705>
            wp::adj_copy(var_47, adj_45, adj_46);
            wp::adj_address(var_body_q, var_23, adj_body_q, adj_23, adj_45);
            // adj: X_wp = body_q[parent]                                                         <L 704>
        }
        // adj: if parent >= 0:                                                                   <L 703>
        wp::adj_copy(var_34, adj_34, adj_42);
        // adj: X_wpj = X_pj                                                                      <L 702>
        // adj: v_wp = wp.spatial_vector()                                                        <L 699>
        // adj: v_p = wp.vec3()                                                                   <L 698>
        // adj: w_p = wp.vec3()                                                                   <L 697>
        wp::adj_copy(var_38, adj_36, adj_37);
        wp::adj_address(var_joint_X_c, var_20, adj_joint_X_c, adj_20, adj_36);
        // adj: X_cj = joint_X_c[joint_idx]                                                       <L 695>
        wp::adj_copy(var_35, adj_33, adj_34);
        wp::adj_address(var_joint_X_p, var_20, adj_joint_X_p, adj_20, adj_33);
        // adj: X_pj = joint_X_p[joint_idx]                                                       <L 694>
        if (var_32) {
            label3:;
            // adj: return                                                                        <L 692>
        }
        wp::adj_address(var_body_flags, var_26, adj_body_flags, adj_26, adj_28);
        // adj: if (body_flags[child] & body_flag_filter) == 0:                                   <L 691>
        wp::adj_copy(var_27, adj_25, adj_26);
        wp::adj_address(var_joint_child, var_20, adj_joint_child, adj_20, adj_25);
        // adj: child = joint_child[joint_idx]                                                    <L 690>
        wp::adj_copy(var_24, adj_22, adj_23);
        wp::adj_address(var_joint_parent, var_20, adj_joint_parent, adj_20, adj_22);
        // adj: parent = joint_parent[joint_idx]                                                  <L 689>
        if (var_21) {
            label2:;
            // adj: return  # This thread has no joint (padding thread)                           <L 687>
        }
        // adj: if joint_idx >= joint_end:                                                        <L 686>
        wp::adj_add(var_15, var_1, adj_15, adj_1, adj_20);
        // adj: joint_idx = joint_start + joint_offset                                            <L 685>
        wp::adj_copy(var_19, adj_17, adj_18);
        wp::adj_address(var_articulation_end, var_6, adj_articulation_end, adj_6, adj_17);
        // adj: joint_end = articulation_end[articulation_id]                                     <L 682>
        wp::adj_copy(var_16, adj_14, adj_15);
        wp::adj_address(var_articulation_start, var_6, adj_articulation_start, adj_6, adj_14);
        // adj: joint_start = articulation_start[articulation_id]                                 <L 681>
        if (var_articulation_mask) {
            if (var_12) {
                label1:;
                // adj: return                                                                    <L 678>
            }
            wp::adj_address(var_articulation_mask, var_6, adj_articulation_mask, adj_6, adj_11);
            // adj: if not articulation_mask[articulation_id]:                                    <L 677>
        }
        // adj: if articulation_mask:                                                             <L 676>
        if (var_7) {
            label0:;
            // adj: return  # Invalid articulation index                                          <L 673>
        }
        if (!var_7) {
        }
        // adj: if articulation_id < 0 or articulation_id >= articulation_count:                  <L 672>
        wp::adj_where(var_articulation_indices, var_3, var_5, adj_articulation_indices, adj_3, adj_5, adj_6);
        if (!var_articulation_indices) {
            wp::adj_copy(var_0, adj_0, adj_5);
            // adj: articulation_id = art_idx                                                     <L 669>
        }
        if (var_articulation_indices) {
            wp::adj_copy(var_4, adj_2, adj_3);
            wp::adj_address(var_articulation_indices, var_0, adj_articulation_indices, adj_0, adj_2);
            // adj: articulation_id = articulation_indices[art_idx]                               <L 667>
        }
        // adj: if articulation_indices:                                                          <L 666>
        // adj: art_idx, joint_offset = wp.tid()  # articulation index and joint offset within articulation  <L 663>
        // adj: def eval_articulation_ik(                                                         <L 640>
        continue;
    }
}



extern "C" __global__ void eval_articulation_jacobian_9489ec59_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::int32> var_articulation_start,
    wp::array_t<wp::int32> var_articulation_end,
    wp::int32 var_articulation_count,
    wp::array_t<bool> var_articulation_mask,
    wp::array_t<wp::int32> var_joint_type,
    wp::array_t<wp::int32> var_joint_parent,
    wp::array_t<wp::int32> var_joint_child,
    wp::array_t<wp::int32> var_joint_ancestor,
    wp::array_t<wp::int32> var_joint_q_start,
    wp::array_t<wp::int32> var_joint_qd_start,
    wp::array_t<wp::transform_t<wp::float32>> var_joint_X_p,
    wp::array_t<wp::vec_t<3, wp::float32>> var_joint_axis,
    wp::array_t<wp::float32> var_joint_q,
    wp::array_t<wp::int32> var_joint_dof_dim,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::vec_t<3, wp::float32>> var_body_com,
    wp::array_t<wp::float32> var_J,
    wp::array_t<wp::vec_t<6, wp::float32>> var_joint_S_s)
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
        bool var_1;
        bool* var_2;
        bool var_3;
        bool var_4;
        wp::int32* var_5;
        wp::int32 var_6;
        wp::int32 var_7;
        wp::int32* var_8;
        wp::int32 var_9;
        wp::int32 var_10;
        wp::int32 var_11;
        wp::int32* var_12;
        wp::int32 var_13;
        wp::int32 var_14;
        wp::range_t var_15;
        wp::int32 var_16;
        wp::int32 var_17;
        wp::int32* var_18;
        wp::int32 var_19;
        wp::int32 var_20;
        wp::int32* var_21;
        wp::int32 var_22;
        wp::int32 var_23;
        wp::transform_t<wp::float32>* var_24;
        wp::transform_t<wp::float32> var_25;
        wp::transform_t<wp::float32> var_26;
        wp::transform_t<wp::float32> var_27;
        const wp::int32 var_28 = 0;
        bool var_29;
        wp::transform_t<wp::float32>* var_30;
        wp::transform_t<wp::float32> var_31;
        wp::transform_t<wp::float32> var_32;
        wp::transform_t<wp::float32> var_33;
        wp::transform_t<wp::float32> var_34;
        wp::int32* var_35;
        wp::int32 var_36;
        wp::int32 var_37;
        wp::int32* var_38;
        wp::int32 var_39;
        wp::int32 var_40;
        const wp::int32 var_41 = 0;
        wp::int32* var_42;
        wp::int32 var_43;
        wp::int32 var_44;
        const wp::int32 var_45 = 1;
        wp::int32* var_46;
        wp::int32 var_47;
        wp::int32 var_48;
        wp::int32* var_49;
        wp::transform_t<wp::float32>* var_50;
        wp::int32 var_51;
        wp::int32* var_52;
        wp::vec_t<3, wp::float32>* var_53;
        wp::int32 var_54;
        wp::transform_t<wp::float32> var_55;
        wp::vec_t<3, wp::float32> var_56;
        wp::range_t var_57;
        wp::int32 var_58;
        const wp::int32 var_59 = 6;
        wp::int32 var_60;
        wp::int32 var_61;
        wp::int32* var_62;
        wp::int32 var_63;
        wp::int32 var_64;
        wp::transform_t<wp::float32>* var_65;
        wp::vec_t<3, wp::float32>* var_66;
        wp::vec_t<3, wp::float32> var_67;
        wp::transform_t<wp::float32> var_68;
        wp::vec_t<3, wp::float32> var_69;
        const wp::int32 var_70 = -1;
        bool var_71;
        wp::int32* var_72;
        wp::int32 var_73;
        wp::int32 var_74;
        const wp::int32 var_75 = 1;
        wp::int32 var_76;
        wp::int32* var_77;
        wp::int32 var_78;
        wp::int32 var_79;
        wp::int32 var_80;
        wp::range_t var_81;
        wp::int32 var_82;
        wp::int32 var_83;
        wp::int32 var_84;
        wp::int32 var_85;
        wp::vec_t<6, wp::float32>* var_86;
        wp::vec_t<6, wp::float32> var_87;
        wp::vec_t<6, wp::float32> var_88;
        wp::vec_t<3, wp::float32> var_89;
        wp::vec_t<3, wp::float32> var_90;
        wp::vec_t<6, wp::float32> var_91;
        const wp::int32 var_92 = 0;
        wp::float32 var_93;
        wp::int32 var_94;
        const wp::int32 var_95 = 1;
        wp::float32 var_96;
        wp::int32 var_97;
        const wp::int32 var_98 = 2;
        wp::float32 var_99;
        wp::int32 var_100;
        const wp::int32 var_101 = 3;
        wp::float32 var_102;
        wp::int32 var_103;
        const wp::int32 var_104 = 4;
        wp::float32 var_105;
        wp::int32 var_106;
        const wp::int32 var_107 = 5;
        wp::float32 var_108;
        wp::int32 var_109;
        wp::int32* var_110;
        wp::int32 var_111;
        wp::int32 var_112;
        //---------
        // forward
        // def eval_articulation_jacobian(                                                        <L 1074>
        // art_idx = wp.tid()                                                                     <L 1100>
        var_0 = builtin_tid1d();
        // if art_idx >= articulation_count:                                                      <L 1102>
        var_1 = (var_0 >= var_articulation_count);
        if (var_1) {
            // return                                                                             <L 1103>
            continue;
        }
        // if articulation_mask:                                                                  <L 1105>
        if (var_articulation_mask) {
            // if not articulation_mask[art_idx]:                                                 <L 1106>
            var_2 = wp::address(var_articulation_mask, var_0);
            var_4 = wp::load(var_2);
            var_3 = wp::unot(var_4);
            if (var_3) {
                // return                                                                         <L 1107>
                continue;
            }
        }
        // joint_start = articulation_start[art_idx]                                              <L 1109>
        var_5 = wp::address(var_articulation_start, var_0);
        var_7 = wp::load(var_5);
        var_6 = wp::copy(var_7);
        // joint_end = articulation_end[art_idx]                                                  <L 1110>
        var_8 = wp::address(var_articulation_end, var_0);
        var_10 = wp::load(var_8);
        var_9 = wp::copy(var_10);
        // joint_count = joint_end - joint_start                                                  <L 1111>
        var_11 = wp::sub(var_9, var_6);
        // articulation_dof_start = joint_qd_start[joint_start]                                   <L 1113>
        var_12 = wp::address(var_joint_qd_start, var_6);
        var_14 = wp::load(var_12);
        var_13 = wp::copy(var_14);
        // for i in range(joint_count):                                                           <L 1116>
        var_15 = wp::range(var_11);
        start_for_2:;
            if (iter_cmp(var_15) == 0) goto end_for_2;
            var_16 = wp::iter_next(var_15);
            // j = joint_start + i                                                                <L 1117>
            var_17 = wp::add(var_6, var_16);
            // parent = joint_parent[j]                                                           <L 1118>
            var_18 = wp::address(var_joint_parent, var_17);
            var_20 = wp::load(var_18);
            var_19 = wp::copy(var_20);
            // type = joint_type[j]                                                               <L 1119>
            var_21 = wp::address(var_joint_type, var_17);
            var_23 = wp::load(var_21);
            var_22 = wp::copy(var_23);
            // X_pj = joint_X_p[j]                                                                <L 1121>
            var_24 = wp::address(var_joint_X_p, var_17);
            var_26 = wp::load(var_24);
            var_25 = wp::copy(var_26);
            // X_wpj = X_pj                                                                       <L 1124>
            var_27 = wp::copy(var_25);
            // if parent >= 0:                                                                    <L 1125>
            var_29 = (var_19 >= var_28);
            if (var_29) {
                // X_wp = body_q[parent]                                                          <L 1126>
                var_30 = wp::address(var_body_q, var_19);
                var_32 = wp::load(var_30);
                var_31 = wp::copy(var_32);
                // X_wpj = X_wp * X_pj                                                            <L 1127>
                var_33 = wp::mul(var_31, var_25);
            }
            var_34 = wp::where(var_29, var_33, var_27);
            // q_start = joint_q_start[j]                                                         <L 1129>
            var_35 = wp::address(var_joint_q_start, var_17);
            var_37 = wp::load(var_35);
            var_36 = wp::copy(var_37);
            // qd_start = joint_qd_start[j]                                                       <L 1130>
            var_38 = wp::address(var_joint_qd_start, var_17);
            var_40 = wp::load(var_38);
            var_39 = wp::copy(var_40);
            // lin_axis_count = joint_dof_dim[j, 0]                                               <L 1131>
            var_42 = wp::address(var_joint_dof_dim, var_17, var_41);
            var_44 = wp::load(var_42);
            var_43 = wp::copy(var_44);
            // ang_axis_count = joint_dof_dim[j, 1]                                               <L 1132>
            var_46 = wp::address(var_joint_dof_dim, var_17, var_45);
            var_48 = wp::load(var_46);
            var_47 = wp::copy(var_48);
            // jcalc_motion_subspace(                                                             <L 1134>
            // type,                                                                              <L 1135>
            // joint_axis,                                                                        <L 1136>
            // joint_q,                                                                           <L 1137>
            // lin_axis_count,                                                                    <L 1138>
            // ang_axis_count,                                                                    <L 1139>
            // X_wpj,                                                                             <L 1140>
            // body_q[joint_child[j]],                                                            <L 1141>
            var_49 = wp::address(var_joint_child, var_17);
            var_51 = wp::load(var_49);
            var_50 = wp::address(var_body_q, var_51);
            // body_com[joint_child[j]],                                                          <L 1142>
            var_52 = wp::address(var_joint_child, var_17);
            var_54 = wp::load(var_52);
            var_53 = wp::address(var_body_com, var_54);
            // q_start,                                                                           <L 1143>
            // qd_start,                                                                          <L 1144>
            // joint_S_s,                                                                         <L 1145>
            var_55 = wp::load(var_50);
            var_56 = wp::load(var_53);
            jcalc_motion_subspace_0(var_22, var_joint_axis, var_joint_q, var_43, var_47, var_34, var_55, var_56, var_36, var_39, var_joint_S_s);
            goto start_for_2;
        end_for_2:;
        // for i in range(joint_count):                                                           <L 1149>
        var_57 = wp::range(var_11);
        start_for_4:;
            if (iter_cmp(var_57) == 0) goto end_for_4;
            var_58 = wp::iter_next(var_57);
            // row_start = i * 6                                                                  <L 1150>
            var_60 = wp::mul(var_58, var_59);
            // j = joint_start + i                                                                <L 1152>
            var_61 = wp::add(var_6, var_58);
            // child = joint_child[j]                                                             <L 1153>
            var_62 = wp::address(var_joint_child, var_61);
            var_64 = wp::load(var_62);
            var_63 = wp::copy(var_64);
            // x_com_world = wp.transform_point(body_q[child], body_com[child])                   <L 1154>
            var_65 = wp::address(var_body_q, var_63);
            var_66 = wp::address(var_body_com, var_63);
            var_68 = wp::load(var_65);
            var_69 = wp::load(var_66);
            var_67 = wp::transform_point(var_68, var_69);
            // while j != -1:                                                                     <L 1155>
        start_while_6:;
            var_71 = (var_61 != var_70);
        if ((var_71) == false) goto end_while_6;
                // joint_dof_start = joint_qd_start[j]                                            <L 1156>
                var_72 = wp::address(var_joint_qd_start, var_61);
                var_74 = wp::load(var_72);
                var_73 = wp::copy(var_74);
                // joint_dof_end = joint_qd_start[j + 1]                                          <L 1157>
                var_76 = wp::add(var_61, var_75);
                var_77 = wp::address(var_joint_qd_start, var_76);
                var_79 = wp::load(var_77);
                var_78 = wp::copy(var_79);
                // joint_dof_count = joint_dof_end - joint_dof_start                              <L 1158>
                var_80 = wp::sub(var_78, var_73);
                // for dof in range(joint_dof_count):                                             <L 1161>
                var_81 = wp::range(var_80);
                start_for_8:;
                    if (iter_cmp(var_81) == 0) goto end_for_8;
                    var_82 = wp::iter_next(var_81);
                    // col = (joint_dof_start - articulation_dof_start) + dof                     <L 1162>
                    var_83 = wp::sub(var_73, var_13);
                    var_84 = wp::add(var_83, var_82);
                    // S = joint_S_s[joint_dof_start + dof]                                       <L 1163>
                    var_85 = wp::add(var_73, var_82);
                    var_86 = wp::address(var_joint_S_s, var_85);
                    var_88 = wp::load(var_86);
                    var_87 = wp::copy(var_88);
                    // S_com = wp.spatial_vector(velocity_at_point(S, x_com_world), wp.spatial_bottom(S))       <L 1164>
                    var_89 = velocity_at_point_1(var_87, var_67);
                    var_90 = wp::spatial_bottom(var_87);
                    var_91 = wp::vec_t<6, wp::float32>(var_89, var_90);
                    // for k in range(6):                                                         <L 1166>
                    // J[art_idx, row_start + k, col] = S_com[k]                                  <L 1167>
                    var_93 = wp::extract(var_91, var_92);
                    var_94 = wp::add(var_60, var_92);
                    wp::array_store(var_J, var_0, var_94, var_84, var_93);
                    var_96 = wp::extract(var_91, var_95);
                    var_97 = wp::add(var_60, var_95);
                    wp::array_store(var_J, var_0, var_97, var_84, var_96);
                    var_99 = wp::extract(var_91, var_98);
                    var_100 = wp::add(var_60, var_98);
                    wp::array_store(var_J, var_0, var_100, var_84, var_99);
                    var_102 = wp::extract(var_91, var_101);
                    var_103 = wp::add(var_60, var_101);
                    wp::array_store(var_J, var_0, var_103, var_84, var_102);
                    var_105 = wp::extract(var_91, var_104);
                    var_106 = wp::add(var_60, var_104);
                    wp::array_store(var_J, var_0, var_106, var_84, var_105);
                    var_108 = wp::extract(var_91, var_107);
                    var_109 = wp::add(var_60, var_107);
                    wp::array_store(var_J, var_0, var_109, var_84, var_108);
                    goto start_for_8;
                end_for_8:;
                // j = joint_ancestor[j]                                                          <L 1169>
                var_110 = wp::address(var_joint_ancestor, var_61);
                var_112 = wp::load(var_110);
                var_111 = wp::copy(var_112);
                wp::assign(var_61, var_111);
        goto start_while_6;
        end_while_6:;
            wp::assign(var_17, var_61);
            goto start_for_4;
        end_for_4:;
    }
}



extern "C" __global__ void eval_articulation_jacobian_9489ec59_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::int32> var_articulation_start,
    wp::array_t<wp::int32> var_articulation_end,
    wp::int32 var_articulation_count,
    wp::array_t<bool> var_articulation_mask,
    wp::array_t<wp::int32> var_joint_type,
    wp::array_t<wp::int32> var_joint_parent,
    wp::array_t<wp::int32> var_joint_child,
    wp::array_t<wp::int32> var_joint_ancestor,
    wp::array_t<wp::int32> var_joint_q_start,
    wp::array_t<wp::int32> var_joint_qd_start,
    wp::array_t<wp::transform_t<wp::float32>> var_joint_X_p,
    wp::array_t<wp::vec_t<3, wp::float32>> var_joint_axis,
    wp::array_t<wp::float32> var_joint_q,
    wp::array_t<wp::int32> var_joint_dof_dim,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::vec_t<3, wp::float32>> var_body_com,
    wp::array_t<wp::float32> var_J,
    wp::array_t<wp::vec_t<6, wp::float32>> var_joint_S_s,
    wp::array_t<wp::int32> adj_articulation_start,
    wp::array_t<wp::int32> adj_articulation_end,
    wp::int32 adj_articulation_count,
    wp::array_t<bool> adj_articulation_mask,
    wp::array_t<wp::int32> adj_joint_type,
    wp::array_t<wp::int32> adj_joint_parent,
    wp::array_t<wp::int32> adj_joint_child,
    wp::array_t<wp::int32> adj_joint_ancestor,
    wp::array_t<wp::int32> adj_joint_q_start,
    wp::array_t<wp::int32> adj_joint_qd_start,
    wp::array_t<wp::transform_t<wp::float32>> adj_joint_X_p,
    wp::array_t<wp::vec_t<3, wp::float32>> adj_joint_axis,
    wp::array_t<wp::float32> adj_joint_q,
    wp::array_t<wp::int32> adj_joint_dof_dim,
    wp::array_t<wp::transform_t<wp::float32>> adj_body_q,
    wp::array_t<wp::vec_t<3, wp::float32>> adj_body_com,
    wp::array_t<wp::float32> adj_J,
    wp::array_t<wp::vec_t<6, wp::float32>> adj_joint_S_s)
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
        bool var_1;
        bool* var_2;
        bool var_3;
        bool var_4;
        wp::int32* var_5;
        wp::int32 var_6;
        wp::int32 var_7;
        wp::int32* var_8;
        wp::int32 var_9;
        wp::int32 var_10;
        wp::int32 var_11;
        wp::int32* var_12;
        wp::int32 var_13;
        wp::int32 var_14;
        wp::range_t var_15;
        wp::int32 var_16;
        wp::int32 var_17;
        wp::int32* var_18;
        wp::int32 var_19;
        wp::int32 var_20;
        wp::int32* var_21;
        wp::int32 var_22;
        wp::int32 var_23;
        wp::transform_t<wp::float32>* var_24;
        wp::transform_t<wp::float32> var_25;
        wp::transform_t<wp::float32> var_26;
        wp::transform_t<wp::float32> var_27;
        const wp::int32 var_28 = 0;
        bool var_29;
        wp::transform_t<wp::float32>* var_30;
        wp::transform_t<wp::float32> var_31;
        wp::transform_t<wp::float32> var_32;
        wp::transform_t<wp::float32> var_33;
        wp::transform_t<wp::float32> var_34;
        wp::int32* var_35;
        wp::int32 var_36;
        wp::int32 var_37;
        wp::int32* var_38;
        wp::int32 var_39;
        wp::int32 var_40;
        const wp::int32 var_41 = 0;
        wp::int32* var_42;
        wp::int32 var_43;
        wp::int32 var_44;
        const wp::int32 var_45 = 1;
        wp::int32* var_46;
        wp::int32 var_47;
        wp::int32 var_48;
        wp::int32* var_49;
        wp::transform_t<wp::float32>* var_50;
        wp::int32 var_51;
        wp::int32* var_52;
        wp::vec_t<3, wp::float32>* var_53;
        wp::int32 var_54;
        wp::transform_t<wp::float32> var_55;
        wp::vec_t<3, wp::float32> var_56;
        wp::range_t var_57;
        wp::int32 var_58;
        const wp::int32 var_59 = 6;
        wp::int32 var_60;
        wp::int32 var_61;
        wp::int32* var_62;
        wp::int32 var_63;
        wp::int32 var_64;
        wp::transform_t<wp::float32>* var_65;
        wp::vec_t<3, wp::float32>* var_66;
        wp::vec_t<3, wp::float32> var_67;
        wp::transform_t<wp::float32> var_68;
        wp::vec_t<3, wp::float32> var_69;
        const wp::int32 var_70 = -1;
        bool var_71;
        wp::int32* var_72;
        wp::int32 var_73;
        wp::int32 var_74;
        const wp::int32 var_75 = 1;
        wp::int32 var_76;
        wp::int32* var_77;
        wp::int32 var_78;
        wp::int32 var_79;
        wp::int32 var_80;
        wp::range_t var_81;
        wp::int32 var_82;
        wp::int32 var_83;
        wp::int32 var_84;
        wp::int32 var_85;
        wp::vec_t<6, wp::float32>* var_86;
        wp::vec_t<6, wp::float32> var_87;
        wp::vec_t<6, wp::float32> var_88;
        wp::vec_t<3, wp::float32> var_89;
        wp::vec_t<3, wp::float32> var_90;
        wp::vec_t<6, wp::float32> var_91;
        const wp::int32 var_92 = 0;
        wp::float32 var_93;
        wp::int32 var_94;
        const wp::int32 var_95 = 1;
        wp::float32 var_96;
        wp::int32 var_97;
        const wp::int32 var_98 = 2;
        wp::float32 var_99;
        wp::int32 var_100;
        const wp::int32 var_101 = 3;
        wp::float32 var_102;
        wp::int32 var_103;
        const wp::int32 var_104 = 4;
        wp::float32 var_105;
        wp::int32 var_106;
        const wp::int32 var_107 = 5;
        wp::float32 var_108;
        wp::int32 var_109;
        wp::int32* var_110;
        wp::int32 var_111;
        wp::int32 var_112;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        bool adj_1 = {};
        bool adj_2 = {};
        bool adj_3 = {};
        bool adj_4 = {};
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
        wp::range_t adj_15 = {};
        wp::int32 adj_16 = {};
        wp::int32 adj_17 = {};
        wp::int32 adj_18 = {};
        wp::int32 adj_19 = {};
        wp::int32 adj_20 = {};
        wp::int32 adj_21 = {};
        wp::int32 adj_22 = {};
        wp::int32 adj_23 = {};
        wp::transform_t<wp::float32> adj_24 = {};
        wp::transform_t<wp::float32> adj_25 = {};
        wp::transform_t<wp::float32> adj_26 = {};
        wp::transform_t<wp::float32> adj_27 = {};
        wp::int32 adj_28 = {};
        bool adj_29 = {};
        wp::transform_t<wp::float32> adj_30 = {};
        wp::transform_t<wp::float32> adj_31 = {};
        wp::transform_t<wp::float32> adj_32 = {};
        wp::transform_t<wp::float32> adj_33 = {};
        wp::transform_t<wp::float32> adj_34 = {};
        wp::int32 adj_35 = {};
        wp::int32 adj_36 = {};
        wp::int32 adj_37 = {};
        wp::int32 adj_38 = {};
        wp::int32 adj_39 = {};
        wp::int32 adj_40 = {};
        wp::int32 adj_41 = {};
        wp::int32 adj_42 = {};
        wp::int32 adj_43 = {};
        wp::int32 adj_44 = {};
        wp::int32 adj_45 = {};
        wp::int32 adj_46 = {};
        wp::int32 adj_47 = {};
        wp::int32 adj_48 = {};
        wp::int32 adj_49 = {};
        wp::transform_t<wp::float32> adj_50 = {};
        wp::int32 adj_51 = {};
        wp::int32 adj_52 = {};
        wp::vec_t<3, wp::float32> adj_53 = {};
        wp::int32 adj_54 = {};
        wp::transform_t<wp::float32> adj_55 = {};
        wp::vec_t<3, wp::float32> adj_56 = {};
        wp::range_t adj_57 = {};
        wp::int32 adj_58 = {};
        wp::int32 adj_59 = {};
        wp::int32 adj_60 = {};
        wp::int32 adj_61 = {};
        wp::int32 adj_62 = {};
        wp::int32 adj_63 = {};
        wp::int32 adj_64 = {};
        wp::transform_t<wp::float32> adj_65 = {};
        wp::vec_t<3, wp::float32> adj_66 = {};
        wp::vec_t<3, wp::float32> adj_67 = {};
        wp::transform_t<wp::float32> adj_68 = {};
        wp::vec_t<3, wp::float32> adj_69 = {};
        wp::int32 adj_70 = {};
        bool adj_71 = {};
        wp::int32 adj_72 = {};
        wp::int32 adj_73 = {};
        wp::int32 adj_74 = {};
        wp::int32 adj_75 = {};
        wp::int32 adj_76 = {};
        wp::int32 adj_77 = {};
        wp::int32 adj_78 = {};
        wp::int32 adj_79 = {};
        wp::int32 adj_80 = {};
        wp::range_t adj_81 = {};
        wp::int32 adj_82 = {};
        wp::int32 adj_83 = {};
        wp::int32 adj_84 = {};
        wp::int32 adj_85 = {};
        wp::vec_t<6, wp::float32> adj_86 = {};
        wp::vec_t<6, wp::float32> adj_87 = {};
        wp::vec_t<6, wp::float32> adj_88 = {};
        wp::vec_t<3, wp::float32> adj_89 = {};
        wp::vec_t<3, wp::float32> adj_90 = {};
        wp::vec_t<6, wp::float32> adj_91 = {};
        wp::int32 adj_92 = {};
        wp::float32 adj_93 = {};
        wp::int32 adj_94 = {};
        wp::int32 adj_95 = {};
        wp::float32 adj_96 = {};
        wp::int32 adj_97 = {};
        wp::int32 adj_98 = {};
        wp::float32 adj_99 = {};
        wp::int32 adj_100 = {};
        wp::int32 adj_101 = {};
        wp::float32 adj_102 = {};
        wp::int32 adj_103 = {};
        wp::int32 adj_104 = {};
        wp::float32 adj_105 = {};
        wp::int32 adj_106 = {};
        wp::int32 adj_107 = {};
        wp::float32 adj_108 = {};
        wp::int32 adj_109 = {};
        wp::int32 adj_110 = {};
        wp::int32 adj_111 = {};
        wp::int32 adj_112 = {};
        //---------
        // forward
        // def eval_articulation_jacobian(                                                        <L 1074>
        // art_idx = wp.tid()                                                                     <L 1100>
        var_0 = builtin_tid1d();
        // if art_idx >= articulation_count:                                                      <L 1102>
        var_1 = (var_0 >= var_articulation_count);
        if (var_1) {
            // return                                                                             <L 1103>
            goto label0;
        }
        // if articulation_mask:                                                                  <L 1105>
        if (var_articulation_mask) {
            // if not articulation_mask[art_idx]:                                                 <L 1106>
            var_2 = wp::address(var_articulation_mask, var_0);
            var_4 = wp::load(var_2);
            var_3 = wp::unot(var_4);
            if (var_3) {
                // return                                                                         <L 1107>
                goto label1;
            }
        }
        // joint_start = articulation_start[art_idx]                                              <L 1109>
        var_5 = wp::address(var_articulation_start, var_0);
        var_7 = wp::load(var_5);
        var_6 = wp::copy(var_7);
        // joint_end = articulation_end[art_idx]                                                  <L 1110>
        var_8 = wp::address(var_articulation_end, var_0);
        var_10 = wp::load(var_8);
        var_9 = wp::copy(var_10);
        // joint_count = joint_end - joint_start                                                  <L 1111>
        var_11 = wp::sub(var_9, var_6);
        // articulation_dof_start = joint_qd_start[joint_start]                                   <L 1113>
        var_12 = wp::address(var_joint_qd_start, var_6);
        var_14 = wp::load(var_12);
        var_13 = wp::copy(var_14);
        // for i in range(joint_count):                                                           <L 1116>
        var_15 = wp::range(var_11);
        // for i in range(joint_count):                                                           <L 1149>
        var_57 = wp::range(var_11);
        //---------
        // reverse
        var_57 = wp::iter_reverse(var_57);
        start_for_4:;
            if (iter_cmp(var_57) == 0) goto end_for_4;
            var_58 = wp::iter_next(var_57);
        	adj_59 = {};
        	adj_60 = {};
        	adj_61 = {};
        	adj_62 = {};
        	adj_63 = {};
        	adj_64 = {};
        	adj_65 = {};
        	adj_66 = {};
        	adj_67 = {};
        	adj_68 = {};
        	adj_69 = {};
            // row_start = i * 6                                                                  <L 1150>
            var_60 = wp::mul(var_58, var_59);
            // j = joint_start + i                                                                <L 1152>
            var_61 = wp::add(var_6, var_58);
            // child = joint_child[j]                                                             <L 1153>
            var_62 = wp::address(var_joint_child, var_61);
            var_64 = wp::load(var_62);
            var_63 = wp::copy(var_64);
            // x_com_world = wp.transform_point(body_q[child], body_com[child])                   <L 1154>
            var_65 = wp::address(var_body_q, var_63);
            var_66 = wp::address(var_body_com, var_63);
            var_68 = wp::load(var_65);
            var_69 = wp::load(var_66);
            var_67 = wp::transform_point(var_68, var_69);
            // while j != -1:                                                                     <L 1155>
            wp::assign(var_17, var_61);
            wp::adj_assign(var_17, var_61, adj_17, adj_61);
        start_while_6:;
            var_71 = (var_61 != var_70);
        if ((var_71) == false) goto end_while_6;
        adj_72 = {};
        adj_73 = {};
        adj_74 = {};
        adj_75 = {};
        adj_76 = {};
        adj_77 = {};
        adj_78 = {};
        adj_79 = {};
        adj_80 = {};
        adj_81 = {};
        adj_110 = {};
        adj_111 = {};
        adj_112 = {};
                // joint_dof_start = joint_qd_start[j]                                            <L 1156>
                var_72 = wp::address(var_joint_qd_start, var_61);
                var_74 = wp::load(var_72);
                var_73 = wp::copy(var_74);
                // joint_dof_end = joint_qd_start[j + 1]                                          <L 1157>
                var_76 = wp::add(var_61, var_75);
                var_77 = wp::address(var_joint_qd_start, var_76);
                var_79 = wp::load(var_77);
                var_78 = wp::copy(var_79);
                // joint_dof_count = joint_dof_end - joint_dof_start                              <L 1158>
                var_80 = wp::sub(var_78, var_73);
                // for dof in range(joint_dof_count):                                             <L 1161>
                var_81 = wp::range(var_80);
                // j = joint_ancestor[j]                                                          <L 1169>
                var_110 = wp::address(var_joint_ancestor, var_61);
                var_112 = wp::load(var_110);
                var_111 = wp::copy(var_112);
                wp::assign(var_61, var_111);
                wp::adj_assign(var_61, var_111, adj_61, adj_111);
                wp::adj_copy(var_112, adj_110, adj_111);
                wp::adj_address(var_joint_ancestor, var_61, adj_joint_ancestor, adj_61, adj_110);
                // adj: j = joint_ancestor[j]                                                     <L 1169>
                var_81 = wp::iter_reverse(var_81);
                start_for_8:;
                    if (iter_cmp(var_81) == 0) goto end_for_8;
                    var_82 = wp::iter_next(var_81);
                	adj_83 = {};
                	adj_84 = {};
                	adj_85 = {};
                	adj_86 = {};
                	adj_87 = {};
                	adj_88 = {};
                	adj_89 = {};
                	adj_90 = {};
                	adj_91 = {};
                	adj_92 = {};
                	adj_93 = {};
                	adj_94 = {};
                	adj_95 = {};
                	adj_96 = {};
                	adj_97 = {};
                	adj_98 = {};
                	adj_99 = {};
                	adj_100 = {};
                	adj_101 = {};
                	adj_102 = {};
                	adj_103 = {};
                	adj_104 = {};
                	adj_105 = {};
                	adj_106 = {};
                	adj_107 = {};
                	adj_108 = {};
                	adj_109 = {};
                    // col = (joint_dof_start - articulation_dof_start) + dof                     <L 1162>
                    var_83 = wp::sub(var_73, var_13);
                    var_84 = wp::add(var_83, var_82);
                    // S = joint_S_s[joint_dof_start + dof]                                       <L 1163>
                    var_85 = wp::add(var_73, var_82);
                    var_86 = wp::address(var_joint_S_s, var_85);
                    var_88 = wp::load(var_86);
                    var_87 = wp::copy(var_88);
                    // S_com = wp.spatial_vector(velocity_at_point(S, x_com_world), wp.spatial_bottom(S))       <L 1164>
                    var_89 = velocity_at_point_1(var_87, var_67);
                    var_90 = wp::spatial_bottom(var_87);
                    var_91 = wp::vec_t<6, wp::float32>(var_89, var_90);
                    // for k in range(6):                                                         <L 1166>
                    // J[art_idx, row_start + k, col] = S_com[k]                                  <L 1167>
                    var_93 = wp::extract(var_91, var_92);
                    var_94 = wp::add(var_60, var_92);
                    // wp::array_store(var_J, var_0, var_94, var_84, var_93);
                    var_96 = wp::extract(var_91, var_95);
                    var_97 = wp::add(var_60, var_95);
                    // wp::array_store(var_J, var_0, var_97, var_84, var_96);
                    var_99 = wp::extract(var_91, var_98);
                    var_100 = wp::add(var_60, var_98);
                    // wp::array_store(var_J, var_0, var_100, var_84, var_99);
                    var_102 = wp::extract(var_91, var_101);
                    var_103 = wp::add(var_60, var_101);
                    // wp::array_store(var_J, var_0, var_103, var_84, var_102);
                    var_105 = wp::extract(var_91, var_104);
                    var_106 = wp::add(var_60, var_104);
                    // wp::array_store(var_J, var_0, var_106, var_84, var_105);
                    var_108 = wp::extract(var_91, var_107);
                    var_109 = wp::add(var_60, var_107);
                    // wp::array_store(var_J, var_0, var_109, var_84, var_108);
                    wp::adj_array_store(var_J, var_0, var_109, var_84, var_108, adj_J, adj_0, adj_109, adj_84, adj_108);
                    wp::adj_add(var_60, var_107, adj_60, adj_107, adj_109);
                    wp::adj_extract(var_91, var_107, adj_91, adj_107, adj_108);
                    wp::adj_array_store(var_J, var_0, var_106, var_84, var_105, adj_J, adj_0, adj_106, adj_84, adj_105);
                    wp::adj_add(var_60, var_104, adj_60, adj_104, adj_106);
                    wp::adj_extract(var_91, var_104, adj_91, adj_104, adj_105);
                    wp::adj_array_store(var_J, var_0, var_103, var_84, var_102, adj_J, adj_0, adj_103, adj_84, adj_102);
                    wp::adj_add(var_60, var_101, adj_60, adj_101, adj_103);
                    wp::adj_extract(var_91, var_101, adj_91, adj_101, adj_102);
                    wp::adj_array_store(var_J, var_0, var_100, var_84, var_99, adj_J, adj_0, adj_100, adj_84, adj_99);
                    wp::adj_add(var_60, var_98, adj_60, adj_98, adj_100);
                    wp::adj_extract(var_91, var_98, adj_91, adj_98, adj_99);
                    wp::adj_array_store(var_J, var_0, var_97, var_84, var_96, adj_J, adj_0, adj_97, adj_84, adj_96);
                    wp::adj_add(var_60, var_95, adj_60, adj_95, adj_97);
                    wp::adj_extract(var_91, var_95, adj_91, adj_95, adj_96);
                    wp::adj_array_store(var_J, var_0, var_94, var_84, var_93, adj_J, adj_0, adj_94, adj_84, adj_93);
                    wp::adj_add(var_60, var_92, adj_60, adj_92, adj_94);
                    wp::adj_extract(var_91, var_92, adj_91, adj_92, adj_93);
                    // adj: J[art_idx, row_start + k, col] = S_com[k]                             <L 1167>
                    // adj: for k in range(6):                                                    <L 1166>
                    wp::adj_vec_t(var_89, var_90, adj_89, adj_90, adj_91);
                    wp::adj_spatial_bottom(var_87, adj_87, adj_90);
                    adj_velocity_at_point_1(var_87, var_67, adj_87, adj_67, adj_89);
                    // adj: S_com = wp.spatial_vector(velocity_at_point(S, x_com_world), wp.spatial_bottom(S))  <L 1164>
                    wp::adj_copy(var_88, adj_86, adj_87);
                    wp::adj_address(var_joint_S_s, var_85, adj_joint_S_s, adj_85, adj_86);
                    wp::adj_add(var_73, var_82, adj_73, adj_82, adj_85);
                    // adj: S = joint_S_s[joint_dof_start + dof]                                  <L 1163>
                    wp::adj_add(var_83, var_82, adj_83, adj_82, adj_84);
                    wp::adj_sub(var_73, var_13, adj_73, adj_13, adj_83);
                    // adj: col = (joint_dof_start - articulation_dof_start) + dof                <L 1162>
                	goto start_for_8;
                end_for_8:;
                // adj: for dof in range(joint_dof_count):                                        <L 1161>
                wp::adj_sub(var_78, var_73, adj_78, adj_73, adj_80);
                // adj: joint_dof_count = joint_dof_end - joint_dof_start                         <L 1158>
                wp::adj_copy(var_79, adj_77, adj_78);
                wp::adj_address(var_joint_qd_start, var_76, adj_joint_qd_start, adj_76, adj_77);
                wp::adj_add(var_61, var_75, adj_61, adj_75, adj_76);
                // adj: joint_dof_end = joint_qd_start[j + 1]                                     <L 1157>
                wp::adj_copy(var_74, adj_72, adj_73);
                wp::adj_address(var_joint_qd_start, var_61, adj_joint_qd_start, adj_61, adj_72);
                // adj: joint_dof_start = joint_qd_start[j]                                       <L 1156>
        goto start_while_6;
        end_while_6:;
            // adj: while j != -1:                                                                <L 1155>
            wp::adj_transform_point(var_68, var_69, adj_65, adj_66, adj_67);
            wp::adj_address(var_body_com, var_63, adj_body_com, adj_63, adj_66);
            wp::adj_address(var_body_q, var_63, adj_body_q, adj_63, adj_65);
            // adj: x_com_world = wp.transform_point(body_q[child], body_com[child])              <L 1154>
            wp::adj_copy(var_64, adj_62, adj_63);
            wp::adj_address(var_joint_child, var_61, adj_joint_child, adj_61, adj_62);
            // adj: child = joint_child[j]                                                        <L 1153>
            wp::adj_add(var_6, var_58, adj_6, adj_58, adj_61);
            // adj: j = joint_start + i                                                           <L 1152>
            wp::adj_mul(var_58, var_59, adj_58, adj_59, adj_60);
            // adj: row_start = i * 6                                                             <L 1150>
        	goto start_for_4;
        end_for_4:;
        // adj: for i in range(joint_count):                                                      <L 1149>
        var_15 = wp::iter_reverse(var_15);
        start_for_2:;
            if (iter_cmp(var_15) == 0) goto end_for_2;
            var_16 = wp::iter_next(var_15);
        	adj_17 = {};
        	adj_18 = {};
        	adj_19 = {};
        	adj_20 = {};
        	adj_21 = {};
        	adj_22 = {};
        	adj_23 = {};
        	adj_24 = {};
        	adj_25 = {};
        	adj_26 = {};
        	adj_27 = {};
        	adj_28 = {};
        	adj_29 = {};
        	adj_30 = {};
        	adj_31 = {};
        	adj_32 = {};
        	adj_33 = {};
        	adj_34 = {};
        	adj_35 = {};
        	adj_36 = {};
        	adj_37 = {};
        	adj_38 = {};
        	adj_39 = {};
        	adj_40 = {};
        	adj_41 = {};
        	adj_42 = {};
        	adj_43 = {};
        	adj_44 = {};
        	adj_45 = {};
        	adj_46 = {};
        	adj_47 = {};
        	adj_48 = {};
        	adj_49 = {};
        	adj_50 = {};
        	adj_51 = {};
        	adj_52 = {};
        	adj_53 = {};
        	adj_54 = {};
        	adj_55 = {};
        	adj_56 = {};
            // j = joint_start + i                                                                <L 1117>
            var_17 = wp::add(var_6, var_16);
            // parent = joint_parent[j]                                                           <L 1118>
            var_18 = wp::address(var_joint_parent, var_17);
            var_20 = wp::load(var_18);
            var_19 = wp::copy(var_20);
            // type = joint_type[j]                                                               <L 1119>
            var_21 = wp::address(var_joint_type, var_17);
            var_23 = wp::load(var_21);
            var_22 = wp::copy(var_23);
            // X_pj = joint_X_p[j]                                                                <L 1121>
            var_24 = wp::address(var_joint_X_p, var_17);
            var_26 = wp::load(var_24);
            var_25 = wp::copy(var_26);
            // X_wpj = X_pj                                                                       <L 1124>
            var_27 = wp::copy(var_25);
            // if parent >= 0:                                                                    <L 1125>
            var_29 = (var_19 >= var_28);
            if (var_29) {
                // X_wp = body_q[parent]                                                          <L 1126>
                var_30 = wp::address(var_body_q, var_19);
                var_32 = wp::load(var_30);
                var_31 = wp::copy(var_32);
                // X_wpj = X_wp * X_pj                                                            <L 1127>
                var_33 = wp::mul(var_31, var_25);
            }
            var_34 = wp::where(var_29, var_33, var_27);
            // q_start = joint_q_start[j]                                                         <L 1129>
            var_35 = wp::address(var_joint_q_start, var_17);
            var_37 = wp::load(var_35);
            var_36 = wp::copy(var_37);
            // qd_start = joint_qd_start[j]                                                       <L 1130>
            var_38 = wp::address(var_joint_qd_start, var_17);
            var_40 = wp::load(var_38);
            var_39 = wp::copy(var_40);
            // lin_axis_count = joint_dof_dim[j, 0]                                               <L 1131>
            var_42 = wp::address(var_joint_dof_dim, var_17, var_41);
            var_44 = wp::load(var_42);
            var_43 = wp::copy(var_44);
            // ang_axis_count = joint_dof_dim[j, 1]                                               <L 1132>
            var_46 = wp::address(var_joint_dof_dim, var_17, var_45);
            var_48 = wp::load(var_46);
            var_47 = wp::copy(var_48);
            // jcalc_motion_subspace(                                                             <L 1134>
            // type,                                                                              <L 1135>
            // joint_axis,                                                                        <L 1136>
            // joint_q,                                                                           <L 1137>
            // lin_axis_count,                                                                    <L 1138>
            // ang_axis_count,                                                                    <L 1139>
            // X_wpj,                                                                             <L 1140>
            // body_q[joint_child[j]],                                                            <L 1141>
            var_49 = wp::address(var_joint_child, var_17);
            var_51 = wp::load(var_49);
            var_50 = wp::address(var_body_q, var_51);
            // body_com[joint_child[j]],                                                          <L 1142>
            var_52 = wp::address(var_joint_child, var_17);
            var_54 = wp::load(var_52);
            var_53 = wp::address(var_body_com, var_54);
            // q_start,                                                                           <L 1143>
            // qd_start,                                                                          <L 1144>
            // joint_S_s,                                                                         <L 1145>
            var_55 = wp::load(var_50);
            var_56 = wp::load(var_53);
            jcalc_motion_subspace_0(var_22, var_joint_axis, var_joint_q, var_43, var_47, var_34, var_55, var_56, var_36, var_39, var_joint_S_s);
            adj_jcalc_motion_subspace_0(var_22, var_joint_axis, var_joint_q, var_43, var_47, var_34, var_55, var_56, var_36, var_39, var_joint_S_s, adj_22, adj_joint_axis, adj_joint_q, adj_43, adj_47, adj_34, adj_50, adj_53, adj_36, adj_39, adj_joint_S_s);
            // adj: joint_S_s,                                                                    <L 1145>
            // adj: qd_start,                                                                     <L 1144>
            // adj: q_start,                                                                      <L 1143>
            wp::adj_address(var_body_com, var_54, adj_body_com, adj_52, adj_53);
            wp::adj_address(var_joint_child, var_17, adj_joint_child, adj_17, adj_52);
            // adj: body_com[joint_child[j]],                                                     <L 1142>
            wp::adj_address(var_body_q, var_51, adj_body_q, adj_49, adj_50);
            wp::adj_address(var_joint_child, var_17, adj_joint_child, adj_17, adj_49);
            // adj: body_q[joint_child[j]],                                                       <L 1141>
            // adj: X_wpj,                                                                        <L 1140>
            // adj: ang_axis_count,                                                               <L 1139>
            // adj: lin_axis_count,                                                               <L 1138>
            // adj: joint_q,                                                                      <L 1137>
            // adj: joint_axis,                                                                   <L 1136>
            // adj: type,                                                                         <L 1135>
            // adj: jcalc_motion_subspace(                                                        <L 1134>
            wp::adj_copy(var_48, adj_46, adj_47);
            wp::adj_address(var_joint_dof_dim, var_17, var_45, adj_joint_dof_dim, adj_17, adj_45, adj_46);
            // adj: ang_axis_count = joint_dof_dim[j, 1]                                          <L 1132>
            wp::adj_copy(var_44, adj_42, adj_43);
            wp::adj_address(var_joint_dof_dim, var_17, var_41, adj_joint_dof_dim, adj_17, adj_41, adj_42);
            // adj: lin_axis_count = joint_dof_dim[j, 0]                                          <L 1131>
            wp::adj_copy(var_40, adj_38, adj_39);
            wp::adj_address(var_joint_qd_start, var_17, adj_joint_qd_start, adj_17, adj_38);
            // adj: qd_start = joint_qd_start[j]                                                  <L 1130>
            wp::adj_copy(var_37, adj_35, adj_36);
            wp::adj_address(var_joint_q_start, var_17, adj_joint_q_start, adj_17, adj_35);
            // adj: q_start = joint_q_start[j]                                                    <L 1129>
            wp::adj_where(var_29, var_33, var_27, adj_29, adj_33, adj_27, adj_34);
            if (var_29) {
                wp::adj_mul(var_31, var_25, adj_31, adj_25, adj_33);
                // adj: X_wpj = X_wp * X_pj                                                       <L 1127>
                wp::adj_copy(var_32, adj_30, adj_31);
                wp::adj_address(var_body_q, var_19, adj_body_q, adj_19, adj_30);
                // adj: X_wp = body_q[parent]                                                     <L 1126>
            }
            // adj: if parent >= 0:                                                               <L 1125>
            wp::adj_copy(var_25, adj_25, adj_27);
            // adj: X_wpj = X_pj                                                                  <L 1124>
            wp::adj_copy(var_26, adj_24, adj_25);
            wp::adj_address(var_joint_X_p, var_17, adj_joint_X_p, adj_17, adj_24);
            // adj: X_pj = joint_X_p[j]                                                           <L 1121>
            wp::adj_copy(var_23, adj_21, adj_22);
            wp::adj_address(var_joint_type, var_17, adj_joint_type, adj_17, adj_21);
            // adj: type = joint_type[j]                                                          <L 1119>
            wp::adj_copy(var_20, adj_18, adj_19);
            wp::adj_address(var_joint_parent, var_17, adj_joint_parent, adj_17, adj_18);
            // adj: parent = joint_parent[j]                                                      <L 1118>
            wp::adj_add(var_6, var_16, adj_6, adj_16, adj_17);
            // adj: j = joint_start + i                                                           <L 1117>
        	goto start_for_2;
        end_for_2:;
        // adj: for i in range(joint_count):                                                      <L 1116>
        wp::adj_copy(var_14, adj_12, adj_13);
        wp::adj_address(var_joint_qd_start, var_6, adj_joint_qd_start, adj_6, adj_12);
        // adj: articulation_dof_start = joint_qd_start[joint_start]                              <L 1113>
        wp::adj_sub(var_9, var_6, adj_9, adj_6, adj_11);
        // adj: joint_count = joint_end - joint_start                                             <L 1111>
        wp::adj_copy(var_10, adj_8, adj_9);
        wp::adj_address(var_articulation_end, var_0, adj_articulation_end, adj_0, adj_8);
        // adj: joint_end = articulation_end[art_idx]                                             <L 1110>
        wp::adj_copy(var_7, adj_5, adj_6);
        wp::adj_address(var_articulation_start, var_0, adj_articulation_start, adj_0, adj_5);
        // adj: joint_start = articulation_start[art_idx]                                         <L 1109>
        if (var_articulation_mask) {
            if (var_3) {
                label1:;
                // adj: return                                                                    <L 1107>
            }
            wp::adj_address(var_articulation_mask, var_0, adj_articulation_mask, adj_0, adj_2);
            // adj: if not articulation_mask[art_idx]:                                            <L 1106>
        }
        // adj: if articulation_mask:                                                             <L 1105>
        if (var_1) {
            label0:;
            // adj: return                                                                        <L 1103>
        }
        // adj: if art_idx >= articulation_count:                                                 <L 1102>
        // adj: art_idx = wp.tid()                                                                <L 1100>
        // adj: def eval_articulation_jacobian(                                                   <L 1074>
        continue;
    }
}

