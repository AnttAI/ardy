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


// /home/jony/Downloads/newton/repos/newton/newton/_src/math/spatial.py:53
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/sim/articulation.py:14
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/sim/articulation.py:28
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/sim/articulation.py:20
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/sim/articulation.py:236
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/math/spatial.py:53
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/sim/articulation.py:14
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/sim/articulation.py:28
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/sim/articulation.py:20
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/sim/articulation.py:236
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



extern "C" __global__ void compute_costs_c68a0f19_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::float32> var_residuals,
    wp::int32 var_num_residuals,
    wp::array_t<wp::float32> var_costs)
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
        const wp::float32 var_1 = 0.0;
        wp::float32 var_2;
        wp::range_t var_3;
        wp::int32 var_4;
        wp::float32* var_5;
        wp::float32 var_6;
        wp::float32 var_7;
        wp::float32 var_8;
        wp::float32 var_9;
        //---------
        // forward
        // def compute_costs(                                                                     <L 125>
        // problem_idx = wp.tid()                                                                 <L 130>
        var_0 = builtin_tid1d();
        // cost = float(0.0)                                                                      <L 131>
        var_2 = wp::float(var_1);
        // for i in range(num_residuals):                                                         <L 132>
        var_3 = wp::range(var_num_residuals);
        start_for_0:;
            if (iter_cmp(var_3) == 0) goto end_for_0;
            var_4 = wp::iter_next(var_3);
            // r = residuals[problem_idx, i]                                                      <L 133>
            var_5 = wp::address(var_residuals, var_0, var_4);
            var_7 = wp::load(var_5);
            var_6 = wp::copy(var_7);
            // cost += r * r                                                                      <L 134>
            var_8 = wp::mul(var_6, var_6);
            var_9 = wp::add(var_2, var_8);
            wp::assign(var_2, var_9);
            goto start_for_0;
        end_for_0:;
        // costs[problem_idx] = cost                                                              <L 135>
        wp::array_store(var_costs, var_0, var_2);
    }
}



extern "C" __global__ void compute_costs_c68a0f19_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::float32> var_residuals,
    wp::int32 var_num_residuals,
    wp::array_t<wp::float32> var_costs,
    wp::array_t<wp::float32> adj_residuals,
    wp::int32 adj_num_residuals,
    wp::array_t<wp::float32> adj_costs)
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
        const wp::float32 var_1 = 0.0;
        wp::float32 var_2;
        wp::range_t var_3;
        wp::int32 var_4;
        wp::float32* var_5;
        wp::float32 var_6;
        wp::float32 var_7;
        wp::float32 var_8;
        wp::float32 var_9;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::float32 adj_1 = {};
        wp::float32 adj_2 = {};
        wp::range_t adj_3 = {};
        wp::int32 adj_4 = {};
        wp::float32 adj_5 = {};
        wp::float32 adj_6 = {};
        wp::float32 adj_7 = {};
        wp::float32 adj_8 = {};
        wp::float32 adj_9 = {};
        //---------
        // forward
        // def compute_costs(                                                                     <L 125>
        // problem_idx = wp.tid()                                                                 <L 130>
        var_0 = builtin_tid1d();
        // cost = float(0.0)                                                                      <L 131>
        var_2 = wp::float(var_1);
        // for i in range(num_residuals):                                                         <L 132>
        var_3 = wp::range(var_num_residuals);
        // costs[problem_idx] = cost                                                              <L 135>
        // wp::array_store(var_costs, var_0, var_2);
        //---------
        // reverse
        wp::adj_array_store(var_costs, var_0, var_2, adj_costs, adj_0, adj_2);
        // adj: costs[problem_idx] = cost                                                         <L 135>
        var_3 = wp::iter_reverse(var_3);
        start_for_0:;
            if (iter_cmp(var_3) == 0) goto end_for_0;
            var_4 = wp::iter_next(var_3);
        	adj_5 = {};
        	adj_6 = {};
        	adj_7 = {};
        	adj_8 = {};
        	adj_9 = {};
            // r = residuals[problem_idx, i]                                                      <L 133>
            var_5 = wp::address(var_residuals, var_0, var_4);
            var_7 = wp::load(var_5);
            var_6 = wp::copy(var_7);
            // cost += r * r                                                                      <L 134>
            var_8 = wp::mul(var_6, var_6);
            var_9 = wp::add(var_2, var_8);
            wp::assign(var_2, var_9);
            wp::adj_assign(var_2, var_9, adj_2, adj_9);
            wp::adj_add(var_2, var_8, adj_2, adj_8, adj_9);
            wp::adj_mul(var_6, var_6, adj_6, adj_6, adj_8);
            // adj: cost += r * r                                                                 <L 134>
            wp::adj_copy(var_7, adj_5, adj_6);
            wp::adj_address(var_residuals, var_0, var_4, adj_residuals, adj_0, adj_4, adj_5);
            // adj: r = residuals[problem_idx, i]                                                 <L 133>
        	goto start_for_0;
        end_for_0:;
        // adj: for i in range(num_residuals):                                                    <L 132>
        wp::adj_float(var_1, adj_1, adj_2);
        // adj: cost = float(0.0)                                                                 <L 131>
        // adj: problem_idx = wp.tid()                                                            <L 130>
        // adj: def compute_costs(                                                                <L 125>
        continue;
    }
}



extern "C" __global__ void fk_accum_ff2018c4_cuda_kernel_forward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::int32> var_joint_parent,
    wp::array_t<wp::transform_t<wp::float32>> var_X_local,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q)
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
        wp::transform_t<wp::float32>* var_2;
        wp::transform_t<wp::float32> var_3;
        wp::transform_t<wp::float32> var_4;
        wp::int32* var_5;
        wp::int32 var_6;
        wp::int32 var_7;
        const wp::int32 var_8 = 0;
        bool var_9;
        wp::transform_t<wp::float32>* var_10;
        wp::transform_t<wp::float32> var_11;
        wp::transform_t<wp::float32> var_12;
        wp::int32* var_13;
        wp::int32 var_14;
        wp::int32 var_15;
        //---------
        // forward
        // def fk_accum(                                                                          <L 110>
        // problem_idx, local_joint_idx = wp.tid()                                                <L 115>
        builtin_tid2d(var_0, var_1);
        // Xw = X_local[problem_idx, local_joint_idx]                                             <L 116>
        var_2 = wp::address(var_X_local, var_0, var_1);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // parent = joint_parent[local_joint_idx]                                                 <L 117>
        var_5 = wp::address(var_joint_parent, var_1);
        var_7 = wp::load(var_5);
        var_6 = wp::copy(var_7);
        // while parent >= 0:                                                                     <L 118>
        start_while_0:;
        var_9 = (var_6 >= var_8);
        if ((var_9) == false) goto end_while_0;
            // Xw = X_local[problem_idx, parent] * Xw                                             <L 119>
            var_10 = wp::address(var_X_local, var_0, var_6);
            var_12 = wp::load(var_10);
            var_11 = wp::mul(var_12, var_3);
            // parent = joint_parent[parent]                                                      <L 120>
            var_13 = wp::address(var_joint_parent, var_6);
            var_15 = wp::load(var_13);
            var_14 = wp::copy(var_15);
            wp::assign(var_3, var_11);
            wp::assign(var_6, var_14);
        goto start_while_0;
        end_while_0:;
        // body_q[problem_idx, local_joint_idx] = Xw                                              <L 121>
        wp::array_store(var_body_q, var_0, var_1, var_3);
    }
}



extern "C" __global__ void fk_accum_ff2018c4_cuda_kernel_backward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::int32> var_joint_parent,
    wp::array_t<wp::transform_t<wp::float32>> var_X_local,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::int32> adj_joint_parent,
    wp::array_t<wp::transform_t<wp::float32>> adj_X_local,
    wp::array_t<wp::transform_t<wp::float32>> adj_body_q)
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
        wp::transform_t<wp::float32>* var_2;
        wp::transform_t<wp::float32> var_3;
        wp::transform_t<wp::float32> var_4;
        wp::int32* var_5;
        wp::int32 var_6;
        wp::int32 var_7;
        const wp::int32 var_8 = 0;
        bool var_9;
        wp::transform_t<wp::float32>* var_10;
        wp::transform_t<wp::float32> var_11;
        wp::transform_t<wp::float32> var_12;
        wp::int32* var_13;
        wp::int32 var_14;
        wp::int32 var_15;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::transform_t<wp::float32> adj_2 = {};
        wp::transform_t<wp::float32> adj_3 = {};
        wp::transform_t<wp::float32> adj_4 = {};
        wp::int32 adj_5 = {};
        wp::int32 adj_6 = {};
        wp::int32 adj_7 = {};
        wp::int32 adj_8 = {};
        bool adj_9 = {};
        wp::transform_t<wp::float32> adj_10 = {};
        wp::transform_t<wp::float32> adj_11 = {};
        wp::transform_t<wp::float32> adj_12 = {};
        wp::int32 adj_13 = {};
        wp::int32 adj_14 = {};
        wp::int32 adj_15 = {};
        //---------
        // forward
        // def fk_accum(                                                                          <L 110>
        // problem_idx, local_joint_idx = wp.tid()                                                <L 115>
        builtin_tid2d(var_0, var_1);
        // Xw = X_local[problem_idx, local_joint_idx]                                             <L 116>
        var_2 = wp::address(var_X_local, var_0, var_1);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // parent = joint_parent[local_joint_idx]                                                 <L 117>
        var_5 = wp::address(var_joint_parent, var_1);
        var_7 = wp::load(var_5);
        var_6 = wp::copy(var_7);
        // while parent >= 0:                                                                     <L 118>
        // body_q[problem_idx, local_joint_idx] = Xw                                              <L 121>
        // wp::array_store(var_body_q, var_0, var_1, var_3);
        //---------
        // reverse
        wp::adj_array_store(var_body_q, var_0, var_1, var_3, adj_body_q, adj_0, adj_1, adj_3);
        // adj: body_q[problem_idx, local_joint_idx] = Xw                                         <L 121>
        start_while_0:;
        var_9 = (var_6 >= var_8);
        if ((var_9) == false) goto end_while_0;
        adj_10 = {};
        adj_11 = {};
        adj_12 = {};
        adj_13 = {};
        adj_14 = {};
        adj_15 = {};
            // Xw = X_local[problem_idx, parent] * Xw                                             <L 119>
            var_10 = wp::address(var_X_local, var_0, var_6);
            var_12 = wp::load(var_10);
            var_11 = wp::mul(var_12, var_3);
            // parent = joint_parent[parent]                                                      <L 120>
            var_13 = wp::address(var_joint_parent, var_6);
            var_15 = wp::load(var_13);
            var_14 = wp::copy(var_15);
            wp::assign(var_3, var_11);
            wp::assign(var_6, var_14);
            wp::adj_assign(var_6, var_14, adj_6, adj_14);
            wp::adj_assign(var_3, var_11, adj_3, adj_11);
            wp::adj_copy(var_15, adj_13, adj_14);
            wp::adj_address(var_joint_parent, var_6, adj_joint_parent, adj_6, adj_13);
            // adj: parent = joint_parent[parent]                                                 <L 120>
            wp::adj_mul(var_12, var_3, adj_10, adj_3, adj_11);
            wp::adj_address(var_X_local, var_0, var_6, adj_X_local, adj_0, adj_6, adj_10);
            // adj: Xw = X_local[problem_idx, parent] * Xw                                        <L 119>
        goto start_while_0;
        end_while_0:;
        // adj: while parent >= 0:                                                                <L 118>
        wp::adj_copy(var_7, adj_5, adj_6);
        wp::adj_address(var_joint_parent, var_1, adj_joint_parent, adj_1, adj_5);
        // adj: parent = joint_parent[local_joint_idx]                                            <L 117>
        wp::adj_copy(var_4, adj_2, adj_3);
        wp::adj_address(var_X_local, var_0, var_1, adj_X_local, adj_0, adj_1, adj_2);
        // adj: Xw = X_local[problem_idx, local_joint_idx]                                        <L 116>
        // adj: problem_idx, local_joint_idx = wp.tid()                                           <L 115>
        // adj: def fk_accum(                                                                     <L 110>
        continue;
    }
}



extern "C" __global__ void _eval_fk_articulation_batched_1662e69c_cuda_kernel_forward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::int32> var_articulation_start,
    wp::array_t<wp::int32> var_articulation_end,
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
        wp::int32 var_1;
        wp::int32* var_2;
        wp::int32 var_3;
        wp::int32 var_4;
        wp::int32* var_5;
        wp::int32 var_6;
        wp::int32 var_7;
        wp::slice_t var_8;
        const wp::int32 var_9 = 0;
        wp::array_t<wp::float32> var_10;
        wp::slice_t var_11;
        const wp::int32 var_12 = 0;
        wp::array_t<wp::float32> var_13;
        const wp::int32 var_14 = 7;
        const wp::int32 var_15 = 7;
        wp::int32 var_16;
        wp::slice_t var_17;
        const wp::int32 var_18 = 0;
        wp::array_t<wp::transform_t<wp::float32>> var_19;
        wp::slice_t var_20;
        const wp::int32 var_21 = 0;
        wp::array_t<wp::vec_t<6, wp::float32>> var_22;
        //---------
        // forward
        // def _eval_fk_articulation_batched(                                                     <L 32>
        // problem_idx, articulation_idx = wp.tid()                                               <L 52>
        builtin_tid2d(var_0, var_1);
        // joint_start = articulation_start[articulation_idx]                                     <L 54>
        var_2 = wp::address(var_articulation_start, var_1);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // joint_end = articulation_end[articulation_idx]                                         <L 55>
        var_5 = wp::address(var_articulation_end, var_1);
        var_7 = wp::load(var_5);
        var_6 = wp::copy(var_7);
        // eval_single_articulation_fk(                                                           <L 57>
        // joint_start,                                                                           <L 58>
        // joint_end,                                                                             <L 59>
        // joint_articulation,                                                                    <L 60>
        // joint_q[problem_idx],                                                                  <L 61>
        var_8 = wp::slice_t(var_0, var_0, var_9);
        var_10 = wp::view(var_joint_q, var_8);
        // joint_qd[problem_idx],                                                                 <L 62>
        var_11 = wp::slice_t(var_0, var_0, var_12);
        var_13 = wp::view(var_joint_qd, var_11);
        // joint_q_start,                                                                         <L 63>
        // joint_qd_start,                                                                        <L 64>
        // joint_type,                                                                            <L 65>
        // joint_parent,                                                                          <L 66>
        // joint_child,                                                                           <L 67>
        // joint_X_p,                                                                             <L 68>
        // joint_X_c,                                                                             <L 69>
        // joint_axis,                                                                            <L 70>
        // joint_dof_dim,                                                                         <L 71>
        // body_com,                                                                              <L 72>
        // body_flags,                                                                            <L 73>
        // int(BodyFlags.ALL),                                                                    <L 74>
        var_16 = wp::int(var_15);
        // body_q[problem_idx],                                                                   <L 75>
        var_17 = wp::slice_t(var_0, var_0, var_18);
        var_19 = wp::view(var_body_q, var_17);
        // body_qd[problem_idx],                                                                  <L 76>
        var_20 = wp::slice_t(var_0, var_0, var_21);
        var_22 = wp::view(var_body_qd, var_20);
        eval_single_articulation_fk_0(var_3, var_6, var_joint_articulation, var_10, var_13, var_joint_q_start, var_joint_qd_start, var_joint_type, var_joint_parent, var_joint_child, var_joint_X_p, var_joint_X_c, var_joint_axis, var_joint_dof_dim, var_body_com, var_body_flags, var_16, var_19, var_22);
    }
}



extern "C" __global__ void _eval_fk_articulation_batched_1662e69c_cuda_kernel_backward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::int32> var_articulation_start,
    wp::array_t<wp::int32> var_articulation_end,
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
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::vec_t<6, wp::float32>> var_body_qd,
    wp::array_t<wp::int32> adj_articulation_start,
    wp::array_t<wp::int32> adj_articulation_end,
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
        wp::int32 var_1;
        wp::int32* var_2;
        wp::int32 var_3;
        wp::int32 var_4;
        wp::int32* var_5;
        wp::int32 var_6;
        wp::int32 var_7;
        wp::slice_t var_8;
        const wp::int32 var_9 = 0;
        wp::array_t<wp::float32> var_10;
        wp::slice_t var_11;
        const wp::int32 var_12 = 0;
        wp::array_t<wp::float32> var_13;
        const wp::int32 var_14 = 7;
        const wp::int32 var_15 = 7;
        wp::int32 var_16;
        wp::slice_t var_17;
        const wp::int32 var_18 = 0;
        wp::array_t<wp::transform_t<wp::float32>> var_19;
        wp::slice_t var_20;
        const wp::int32 var_21 = 0;
        wp::array_t<wp::vec_t<6, wp::float32>> var_22;
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
        wp::slice_t adj_8 = {};
        wp::int32 adj_9 = {};
        wp::array_t<wp::float32> adj_10 = {};
        wp::slice_t adj_11 = {};
        wp::int32 adj_12 = {};
        wp::array_t<wp::float32> adj_13 = {};
        wp::int32 adj_14 = {};
        wp::int32 adj_15 = {};
        wp::int32 adj_16 = {};
        wp::slice_t adj_17 = {};
        wp::int32 adj_18 = {};
        wp::array_t<wp::transform_t<wp::float32>> adj_19 = {};
        wp::slice_t adj_20 = {};
        wp::int32 adj_21 = {};
        wp::array_t<wp::vec_t<6, wp::float32>> adj_22 = {};
        //---------
        // forward
        // def _eval_fk_articulation_batched(                                                     <L 32>
        // problem_idx, articulation_idx = wp.tid()                                               <L 52>
        builtin_tid2d(var_0, var_1);
        // joint_start = articulation_start[articulation_idx]                                     <L 54>
        var_2 = wp::address(var_articulation_start, var_1);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // joint_end = articulation_end[articulation_idx]                                         <L 55>
        var_5 = wp::address(var_articulation_end, var_1);
        var_7 = wp::load(var_5);
        var_6 = wp::copy(var_7);
        // eval_single_articulation_fk(                                                           <L 57>
        // joint_start,                                                                           <L 58>
        // joint_end,                                                                             <L 59>
        // joint_articulation,                                                                    <L 60>
        // joint_q[problem_idx],                                                                  <L 61>
        var_8 = wp::slice_t(var_0, var_0, var_9);
        var_10 = wp::view(var_joint_q, var_8);
        // joint_qd[problem_idx],                                                                 <L 62>
        var_11 = wp::slice_t(var_0, var_0, var_12);
        var_13 = wp::view(var_joint_qd, var_11);
        // joint_q_start,                                                                         <L 63>
        // joint_qd_start,                                                                        <L 64>
        // joint_type,                                                                            <L 65>
        // joint_parent,                                                                          <L 66>
        // joint_child,                                                                           <L 67>
        // joint_X_p,                                                                             <L 68>
        // joint_X_c,                                                                             <L 69>
        // joint_axis,                                                                            <L 70>
        // joint_dof_dim,                                                                         <L 71>
        // body_com,                                                                              <L 72>
        // body_flags,                                                                            <L 73>
        // int(BodyFlags.ALL),                                                                    <L 74>
        var_16 = wp::int(var_15);
        // body_q[problem_idx],                                                                   <L 75>
        var_17 = wp::slice_t(var_0, var_0, var_18);
        var_19 = wp::view(var_body_q, var_17);
        // body_qd[problem_idx],                                                                  <L 76>
        var_20 = wp::slice_t(var_0, var_0, var_21);
        var_22 = wp::view(var_body_qd, var_20);
        eval_single_articulation_fk_0(var_3, var_6, var_joint_articulation, var_10, var_13, var_joint_q_start, var_joint_qd_start, var_joint_type, var_joint_parent, var_joint_child, var_joint_X_p, var_joint_X_c, var_joint_axis, var_joint_dof_dim, var_body_com, var_body_flags, var_16, var_19, var_22);
        //---------
        // reverse
        adj_eval_single_articulation_fk_0(var_3, var_6, var_joint_articulation, var_10, var_13, var_joint_q_start, var_joint_qd_start, var_joint_type, var_joint_parent, var_joint_child, var_joint_X_p, var_joint_X_c, var_joint_axis, var_joint_dof_dim, var_body_com, var_body_flags, var_16, var_19, var_22, adj_3, adj_6, adj_joint_articulation, adj_10, adj_13, adj_joint_q_start, adj_joint_qd_start, adj_joint_type, adj_joint_parent, adj_joint_child, adj_joint_X_p, adj_joint_X_c, adj_joint_axis, adj_joint_dof_dim, adj_body_com, adj_body_flags, adj_16, adj_19, adj_22);
        wp::adj_view(var_body_qd, var_20, adj_body_qd, adj_20, adj_22);
        // adj: body_qd[problem_idx],                                                             <L 76>
        wp::adj_view(var_body_q, var_17, adj_body_q, adj_17, adj_19);
        // adj: body_q[problem_idx],                                                              <L 75>
        // adj: int(BodyFlags.ALL),                                                               <L 74>
        // adj: body_flags,                                                                       <L 73>
        // adj: body_com,                                                                         <L 72>
        // adj: joint_dof_dim,                                                                    <L 71>
        // adj: joint_axis,                                                                       <L 70>
        // adj: joint_X_c,                                                                        <L 69>
        // adj: joint_X_p,                                                                        <L 68>
        // adj: joint_child,                                                                      <L 67>
        // adj: joint_parent,                                                                     <L 66>
        // adj: joint_type,                                                                       <L 65>
        // adj: joint_qd_start,                                                                   <L 64>
        // adj: joint_q_start,                                                                    <L 63>
        wp::adj_view(var_joint_qd, var_11, adj_joint_qd, adj_11, adj_13);
        // adj: joint_qd[problem_idx],                                                            <L 62>
        wp::adj_view(var_joint_q, var_8, adj_joint_q, adj_8, adj_10);
        // adj: joint_q[problem_idx],                                                             <L 61>
        // adj: joint_articulation,                                                               <L 60>
        // adj: joint_end,                                                                        <L 59>
        // adj: joint_start,                                                                      <L 58>
        // adj: eval_single_articulation_fk(                                                      <L 57>
        wp::adj_copy(var_7, adj_5, adj_6);
        wp::adj_address(var_articulation_end, var_1, adj_articulation_end, adj_1, adj_5);
        // adj: joint_end = articulation_end[articulation_idx]                                    <L 55>
        wp::adj_copy(var_4, adj_2, adj_3);
        wp::adj_address(var_articulation_start, var_1, adj_articulation_start, adj_1, adj_2);
        // adj: joint_start = articulation_start[articulation_idx]                                <L 54>
        // adj: problem_idx, articulation_idx = wp.tid()                                          <L 52>
        // adj: def _eval_fk_articulation_batched(                                                <L 32>
        continue;
    }
}

