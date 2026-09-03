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


// /home/jony/Downloads/newton/repos/newton/newton/_src/math/spatial.py:81
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/sim/articulation.py:934
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/sim/articulation.py:972
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/math/spatial.py:81
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/sim/articulation.py:934
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/sim/articulation.py:972
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



extern "C" __global__ void IKOptimizerLM___build_specialized__locals___compute_motion_subspace_2d_f6d1a7fb_cuda_kernel_forward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::int32> var_joint_type,
    wp::array_t<wp::int32> var_joint_parent,
    wp::array_t<wp::int32> var_joint_child,
    wp::array_t<wp::int32> var_joint_q_start,
    wp::array_t<wp::int32> var_joint_qd_start,
    wp::array_t<wp::float32> var_joint_q,
    wp::array_t<wp::vec_t<3, wp::float32>> var_joint_axis,
    wp::array_t<wp::int32> var_joint_dof_dim,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::vec_t<3, wp::float32>> var_body_com,
    wp::array_t<wp::transform_t<wp::float32>> var_joint_X_p,
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
        wp::transform_t<wp::float32>* var_17;
        wp::transform_t<wp::float32> var_18;
        wp::transform_t<wp::float32> var_19;
        wp::transform_t<wp::float32> var_20;
        const wp::int32 var_21 = 0;
        bool var_22;
        wp::transform_t<wp::float32>* var_23;
        wp::transform_t<wp::float32> var_24;
        wp::transform_t<wp::float32> var_25;
        wp::transform_t<wp::float32> var_26;
        const wp::int32 var_27 = 0;
        wp::int32* var_28;
        wp::int32 var_29;
        wp::int32 var_30;
        const wp::int32 var_31 = 1;
        wp::int32* var_32;
        wp::int32 var_33;
        wp::int32 var_34;
        wp::slice_t var_35;
        const wp::int32 var_36 = 0;
        wp::array_t<wp::float32> var_37;
        wp::slice_t var_38;
        const wp::int32 var_39 = 0;
        wp::array_t<wp::vec_t<6, wp::float32>> var_40;
        bool var_41;
        const wp::int32 var_42 = 4;
        bool var_43;
        const wp::int32 var_44 = 5;
        bool var_45;
        wp::transform_t<wp::float32>* var_46;
        wp::vec_t<3, wp::float32>* var_47;
        wp::transform_t<wp::float32> var_48;
        wp::vec_t<3, wp::float32> var_49;
        wp::transform_t<wp::float32> var_50;
        wp::vec_t<3, wp::float32> var_51;
        //---------
        // forward
        // def _compute_motion_subspace_2d(                                                       <L 869>
        // row, joint_idx = wp.tid()                                                              <L 884>
        builtin_tid2d(var_0, var_1);
        // type = joint_type[joint_idx]                                                           <L 886>
        var_2 = wp::address(var_joint_type, var_1);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // parent = joint_parent[joint_idx]                                                       <L 887>
        var_5 = wp::address(var_joint_parent, var_1);
        var_7 = wp::load(var_5);
        var_6 = wp::copy(var_7);
        // child = joint_child[joint_idx]                                                         <L 888>
        var_8 = wp::address(var_joint_child, var_1);
        var_10 = wp::load(var_8);
        var_9 = wp::copy(var_10);
        // q_start = joint_q_start[joint_idx]                                                     <L 889>
        var_11 = wp::address(var_joint_q_start, var_1);
        var_13 = wp::load(var_11);
        var_12 = wp::copy(var_13);
        // qd_start = joint_qd_start[joint_idx]                                                   <L 890>
        var_14 = wp::address(var_joint_qd_start, var_1);
        var_16 = wp::load(var_14);
        var_15 = wp::copy(var_16);
        // X_pj = joint_X_p[joint_idx]                                                            <L 892>
        var_17 = wp::address(var_joint_X_p, var_1);
        var_19 = wp::load(var_17);
        var_18 = wp::copy(var_19);
        // X_wpj = X_pj                                                                           <L 893>
        var_20 = wp::copy(var_18);
        // if parent >= 0:                                                                        <L 894>
        var_22 = (var_6 >= var_21);
        if (var_22) {
            // X_wpj = body_q[row, parent] * X_pj                                                 <L 895>
            var_23 = wp::address(var_body_q, var_0, var_6);
            var_25 = wp::load(var_23);
            var_24 = wp::mul(var_25, var_18);
        }
        var_26 = wp::where(var_22, var_24, var_20);
        // lin_axis_count = joint_dof_dim[joint_idx, 0]                                           <L 897>
        var_28 = wp::address(var_joint_dof_dim, var_1, var_27);
        var_30 = wp::load(var_28);
        var_29 = wp::copy(var_30);
        // ang_axis_count = joint_dof_dim[joint_idx, 1]                                           <L 898>
        var_32 = wp::address(var_joint_dof_dim, var_1, var_31);
        var_34 = wp::load(var_32);
        var_33 = wp::copy(var_34);
        // joint_q_1d = joint_q[row]                                                              <L 900>
        var_35 = wp::slice_t(var_0, var_0, var_36);
        var_37 = wp::view(var_joint_q, var_35);
        // S_s_out = joint_S_s[row]                                                               <L 901>
        var_38 = wp::slice_t(var_0, var_0, var_39);
        var_40 = wp::view(var_joint_S_s, var_38);
        // if type == JointType.FREE or type == JointType.DISTANCE:                               <L 903>
        var_43 = (var_3 == var_42);
        var_41 = var_43;
        if (!var_41) {
            var_45 = (var_3 == var_44);
            var_41 = var_41 || var_45;
        }
        if (var_41) {
            // jcalc_motion_subspace(                                                             <L 904>
            // type,                                                                              <L 905>
            // joint_axis,                                                                        <L 906>
            // joint_q_1d,                                                                        <L 907>
            // lin_axis_count,                                                                    <L 908>
            // ang_axis_count,                                                                    <L 909>
            // X_wpj,                                                                             <L 910>
            // body_q[row, child],                                                                <L 911>
            var_46 = wp::address(var_body_q, var_0, var_9);
            // body_com[child],                                                                   <L 912>
            var_47 = wp::address(var_body_com, var_9);
            // q_start,                                                                           <L 913>
            // qd_start,                                                                          <L 914>
            // S_s_out,                                                                           <L 915>
            var_48 = wp::load(var_46);
            var_49 = wp::load(var_47);
            jcalc_motion_subspace_0(var_3, var_joint_axis, var_37, var_29, var_33, var_26, var_48, var_49, var_12, var_15, var_40);
        }
        if (!var_41) {
            // jcalc_motion_subspace(                                                             <L 918>
            // type,                                                                              <L 919>
            // joint_axis,                                                                        <L 920>
            // joint_q_1d,                                                                        <L 921>
            // lin_axis_count,                                                                    <L 922>
            // ang_axis_count,                                                                    <L 923>
            // X_wpj,                                                                             <L 924>
            // wp.transform_identity(),                                                           <L 925>
            var_50 = wp::transform_identity<wp::float32>();
            // wp.vec3(),                                                                         <L 926>
            var_51 = wp::vec_t<3, wp::float32>();
            // q_start,                                                                           <L 927>
            // qd_start,                                                                          <L 928>
            // S_s_out,                                                                           <L 929>
            jcalc_motion_subspace_0(var_3, var_joint_axis, var_37, var_29, var_33, var_26, var_50, var_51, var_12, var_15, var_40);
        }
    }
}



extern "C" __global__ void IKOptimizerLM___build_specialized__locals___compute_motion_subspace_2d_f6d1a7fb_cuda_kernel_backward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::int32> var_joint_type,
    wp::array_t<wp::int32> var_joint_parent,
    wp::array_t<wp::int32> var_joint_child,
    wp::array_t<wp::int32> var_joint_q_start,
    wp::array_t<wp::int32> var_joint_qd_start,
    wp::array_t<wp::float32> var_joint_q,
    wp::array_t<wp::vec_t<3, wp::float32>> var_joint_axis,
    wp::array_t<wp::int32> var_joint_dof_dim,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::vec_t<3, wp::float32>> var_body_com,
    wp::array_t<wp::transform_t<wp::float32>> var_joint_X_p,
    wp::array_t<wp::vec_t<6, wp::float32>> var_joint_S_s,
    wp::array_t<wp::int32> adj_joint_type,
    wp::array_t<wp::int32> adj_joint_parent,
    wp::array_t<wp::int32> adj_joint_child,
    wp::array_t<wp::int32> adj_joint_q_start,
    wp::array_t<wp::int32> adj_joint_qd_start,
    wp::array_t<wp::float32> adj_joint_q,
    wp::array_t<wp::vec_t<3, wp::float32>> adj_joint_axis,
    wp::array_t<wp::int32> adj_joint_dof_dim,
    wp::array_t<wp::transform_t<wp::float32>> adj_body_q,
    wp::array_t<wp::vec_t<3, wp::float32>> adj_body_com,
    wp::array_t<wp::transform_t<wp::float32>> adj_joint_X_p,
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
        wp::transform_t<wp::float32>* var_17;
        wp::transform_t<wp::float32> var_18;
        wp::transform_t<wp::float32> var_19;
        wp::transform_t<wp::float32> var_20;
        const wp::int32 var_21 = 0;
        bool var_22;
        wp::transform_t<wp::float32>* var_23;
        wp::transform_t<wp::float32> var_24;
        wp::transform_t<wp::float32> var_25;
        wp::transform_t<wp::float32> var_26;
        const wp::int32 var_27 = 0;
        wp::int32* var_28;
        wp::int32 var_29;
        wp::int32 var_30;
        const wp::int32 var_31 = 1;
        wp::int32* var_32;
        wp::int32 var_33;
        wp::int32 var_34;
        wp::slice_t var_35;
        const wp::int32 var_36 = 0;
        wp::array_t<wp::float32> var_37;
        wp::slice_t var_38;
        const wp::int32 var_39 = 0;
        wp::array_t<wp::vec_t<6, wp::float32>> var_40;
        bool var_41;
        const wp::int32 var_42 = 4;
        bool var_43;
        const wp::int32 var_44 = 5;
        bool var_45;
        wp::transform_t<wp::float32>* var_46;
        wp::vec_t<3, wp::float32>* var_47;
        wp::transform_t<wp::float32> var_48;
        wp::vec_t<3, wp::float32> var_49;
        wp::transform_t<wp::float32> var_50;
        wp::vec_t<3, wp::float32> var_51;
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
        wp::transform_t<wp::float32> adj_17 = {};
        wp::transform_t<wp::float32> adj_18 = {};
        wp::transform_t<wp::float32> adj_19 = {};
        wp::transform_t<wp::float32> adj_20 = {};
        wp::int32 adj_21 = {};
        bool adj_22 = {};
        wp::transform_t<wp::float32> adj_23 = {};
        wp::transform_t<wp::float32> adj_24 = {};
        wp::transform_t<wp::float32> adj_25 = {};
        wp::transform_t<wp::float32> adj_26 = {};
        wp::int32 adj_27 = {};
        wp::int32 adj_28 = {};
        wp::int32 adj_29 = {};
        wp::int32 adj_30 = {};
        wp::int32 adj_31 = {};
        wp::int32 adj_32 = {};
        wp::int32 adj_33 = {};
        wp::int32 adj_34 = {};
        wp::slice_t adj_35 = {};
        wp::int32 adj_36 = {};
        wp::array_t<wp::float32> adj_37 = {};
        wp::slice_t adj_38 = {};
        wp::int32 adj_39 = {};
        wp::array_t<wp::vec_t<6, wp::float32>> adj_40 = {};
        bool adj_41 = {};
        wp::int32 adj_42 = {};
        bool adj_43 = {};
        wp::int32 adj_44 = {};
        bool adj_45 = {};
        wp::transform_t<wp::float32> adj_46 = {};
        wp::vec_t<3, wp::float32> adj_47 = {};
        wp::transform_t<wp::float32> adj_48 = {};
        wp::vec_t<3, wp::float32> adj_49 = {};
        wp::transform_t<wp::float32> adj_50 = {};
        wp::vec_t<3, wp::float32> adj_51 = {};
        //---------
        // forward
        // def _compute_motion_subspace_2d(                                                       <L 869>
        // row, joint_idx = wp.tid()                                                              <L 884>
        builtin_tid2d(var_0, var_1);
        // type = joint_type[joint_idx]                                                           <L 886>
        var_2 = wp::address(var_joint_type, var_1);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // parent = joint_parent[joint_idx]                                                       <L 887>
        var_5 = wp::address(var_joint_parent, var_1);
        var_7 = wp::load(var_5);
        var_6 = wp::copy(var_7);
        // child = joint_child[joint_idx]                                                         <L 888>
        var_8 = wp::address(var_joint_child, var_1);
        var_10 = wp::load(var_8);
        var_9 = wp::copy(var_10);
        // q_start = joint_q_start[joint_idx]                                                     <L 889>
        var_11 = wp::address(var_joint_q_start, var_1);
        var_13 = wp::load(var_11);
        var_12 = wp::copy(var_13);
        // qd_start = joint_qd_start[joint_idx]                                                   <L 890>
        var_14 = wp::address(var_joint_qd_start, var_1);
        var_16 = wp::load(var_14);
        var_15 = wp::copy(var_16);
        // X_pj = joint_X_p[joint_idx]                                                            <L 892>
        var_17 = wp::address(var_joint_X_p, var_1);
        var_19 = wp::load(var_17);
        var_18 = wp::copy(var_19);
        // X_wpj = X_pj                                                                           <L 893>
        var_20 = wp::copy(var_18);
        // if parent >= 0:                                                                        <L 894>
        var_22 = (var_6 >= var_21);
        if (var_22) {
            // X_wpj = body_q[row, parent] * X_pj                                                 <L 895>
            var_23 = wp::address(var_body_q, var_0, var_6);
            var_25 = wp::load(var_23);
            var_24 = wp::mul(var_25, var_18);
        }
        var_26 = wp::where(var_22, var_24, var_20);
        // lin_axis_count = joint_dof_dim[joint_idx, 0]                                           <L 897>
        var_28 = wp::address(var_joint_dof_dim, var_1, var_27);
        var_30 = wp::load(var_28);
        var_29 = wp::copy(var_30);
        // ang_axis_count = joint_dof_dim[joint_idx, 1]                                           <L 898>
        var_32 = wp::address(var_joint_dof_dim, var_1, var_31);
        var_34 = wp::load(var_32);
        var_33 = wp::copy(var_34);
        // joint_q_1d = joint_q[row]                                                              <L 900>
        var_35 = wp::slice_t(var_0, var_0, var_36);
        var_37 = wp::view(var_joint_q, var_35);
        // S_s_out = joint_S_s[row]                                                               <L 901>
        var_38 = wp::slice_t(var_0, var_0, var_39);
        var_40 = wp::view(var_joint_S_s, var_38);
        // if type == JointType.FREE or type == JointType.DISTANCE:                               <L 903>
        var_43 = (var_3 == var_42);
        var_41 = var_43;
        if (!var_41) {
            var_45 = (var_3 == var_44);
            var_41 = var_41 || var_45;
        }
        if (var_41) {
            // jcalc_motion_subspace(                                                             <L 904>
            // type,                                                                              <L 905>
            // joint_axis,                                                                        <L 906>
            // joint_q_1d,                                                                        <L 907>
            // lin_axis_count,                                                                    <L 908>
            // ang_axis_count,                                                                    <L 909>
            // X_wpj,                                                                             <L 910>
            // body_q[row, child],                                                                <L 911>
            var_46 = wp::address(var_body_q, var_0, var_9);
            // body_com[child],                                                                   <L 912>
            var_47 = wp::address(var_body_com, var_9);
            // q_start,                                                                           <L 913>
            // qd_start,                                                                          <L 914>
            // S_s_out,                                                                           <L 915>
            var_48 = wp::load(var_46);
            var_49 = wp::load(var_47);
            jcalc_motion_subspace_0(var_3, var_joint_axis, var_37, var_29, var_33, var_26, var_48, var_49, var_12, var_15, var_40);
        }
        if (!var_41) {
            // jcalc_motion_subspace(                                                             <L 918>
            // type,                                                                              <L 919>
            // joint_axis,                                                                        <L 920>
            // joint_q_1d,                                                                        <L 921>
            // lin_axis_count,                                                                    <L 922>
            // ang_axis_count,                                                                    <L 923>
            // X_wpj,                                                                             <L 924>
            // wp.transform_identity(),                                                           <L 925>
            var_50 = wp::transform_identity<wp::float32>();
            // wp.vec3(),                                                                         <L 926>
            var_51 = wp::vec_t<3, wp::float32>();
            // q_start,                                                                           <L 927>
            // qd_start,                                                                          <L 928>
            // S_s_out,                                                                           <L 929>
            jcalc_motion_subspace_0(var_3, var_joint_axis, var_37, var_29, var_33, var_26, var_50, var_51, var_12, var_15, var_40);
        }
        //---------
        // reverse
        if (!var_41) {
            adj_jcalc_motion_subspace_0(var_3, var_joint_axis, var_37, var_29, var_33, var_26, var_50, var_51, var_12, var_15, var_40, adj_3, adj_joint_axis, adj_37, adj_29, adj_33, adj_26, adj_50, adj_51, adj_12, adj_15, adj_40);
            // adj: S_s_out,                                                                      <L 929>
            // adj: qd_start,                                                                     <L 928>
            // adj: q_start,                                                                      <L 927>
            // adj: wp.vec3(),                                                                    <L 926>
            // adj: wp.transform_identity(),                                                      <L 925>
            // adj: X_wpj,                                                                        <L 924>
            // adj: ang_axis_count,                                                               <L 923>
            // adj: lin_axis_count,                                                               <L 922>
            // adj: joint_q_1d,                                                                   <L 921>
            // adj: joint_axis,                                                                   <L 920>
            // adj: type,                                                                         <L 919>
            // adj: jcalc_motion_subspace(                                                        <L 918>
        }
        if (var_41) {
            adj_jcalc_motion_subspace_0(var_3, var_joint_axis, var_37, var_29, var_33, var_26, var_48, var_49, var_12, var_15, var_40, adj_3, adj_joint_axis, adj_37, adj_29, adj_33, adj_26, adj_46, adj_47, adj_12, adj_15, adj_40);
            // adj: S_s_out,                                                                      <L 915>
            // adj: qd_start,                                                                     <L 914>
            // adj: q_start,                                                                      <L 913>
            wp::adj_address(var_body_com, var_9, adj_body_com, adj_9, adj_47);
            // adj: body_com[child],                                                              <L 912>
            wp::adj_address(var_body_q, var_0, var_9, adj_body_q, adj_0, adj_9, adj_46);
            // adj: body_q[row, child],                                                           <L 911>
            // adj: X_wpj,                                                                        <L 910>
            // adj: ang_axis_count,                                                               <L 909>
            // adj: lin_axis_count,                                                               <L 908>
            // adj: joint_q_1d,                                                                   <L 907>
            // adj: joint_axis,                                                                   <L 906>
            // adj: type,                                                                         <L 905>
            // adj: jcalc_motion_subspace(                                                        <L 904>
        }
        if (!var_41) {
        }
        // adj: if type == JointType.FREE or type == JointType.DISTANCE:                          <L 903>
        wp::adj_view(var_joint_S_s, var_38, adj_joint_S_s, adj_38, adj_40);
        // adj: S_s_out = joint_S_s[row]                                                          <L 901>
        wp::adj_view(var_joint_q, var_35, adj_joint_q, adj_35, adj_37);
        // adj: joint_q_1d = joint_q[row]                                                         <L 900>
        wp::adj_copy(var_34, adj_32, adj_33);
        wp::adj_address(var_joint_dof_dim, var_1, var_31, adj_joint_dof_dim, adj_1, adj_31, adj_32);
        // adj: ang_axis_count = joint_dof_dim[joint_idx, 1]                                      <L 898>
        wp::adj_copy(var_30, adj_28, adj_29);
        wp::adj_address(var_joint_dof_dim, var_1, var_27, adj_joint_dof_dim, adj_1, adj_27, adj_28);
        // adj: lin_axis_count = joint_dof_dim[joint_idx, 0]                                      <L 897>
        wp::adj_where(var_22, var_24, var_20, adj_22, adj_24, adj_20, adj_26);
        if (var_22) {
            wp::adj_mul(var_25, var_18, adj_23, adj_18, adj_24);
            wp::adj_address(var_body_q, var_0, var_6, adj_body_q, adj_0, adj_6, adj_23);
            // adj: X_wpj = body_q[row, parent] * X_pj                                            <L 895>
        }
        // adj: if parent >= 0:                                                                   <L 894>
        wp::adj_copy(var_18, adj_18, adj_20);
        // adj: X_wpj = X_pj                                                                      <L 893>
        wp::adj_copy(var_19, adj_17, adj_18);
        wp::adj_address(var_joint_X_p, var_1, adj_joint_X_p, adj_1, adj_17);
        // adj: X_pj = joint_X_p[joint_idx]                                                       <L 892>
        wp::adj_copy(var_16, adj_14, adj_15);
        wp::adj_address(var_joint_qd_start, var_1, adj_joint_qd_start, adj_1, adj_14);
        // adj: qd_start = joint_qd_start[joint_idx]                                              <L 890>
        wp::adj_copy(var_13, adj_11, adj_12);
        wp::adj_address(var_joint_q_start, var_1, adj_joint_q_start, adj_1, adj_11);
        // adj: q_start = joint_q_start[joint_idx]                                                <L 889>
        wp::adj_copy(var_10, adj_8, adj_9);
        wp::adj_address(var_joint_child, var_1, adj_joint_child, adj_1, adj_8);
        // adj: child = joint_child[joint_idx]                                                    <L 888>
        wp::adj_copy(var_7, adj_5, adj_6);
        wp::adj_address(var_joint_parent, var_1, adj_joint_parent, adj_1, adj_5);
        // adj: parent = joint_parent[joint_idx]                                                  <L 887>
        wp::adj_copy(var_4, adj_2, adj_3);
        wp::adj_address(var_joint_type, var_1, adj_joint_type, adj_1, adj_2);
        // adj: type = joint_type[joint_idx]                                                      <L 886>
        // adj: row, joint_idx = wp.tid()                                                         <L 884>
        // adj: def _compute_motion_subspace_2d(                                                  <L 869>
        continue;
    }
}

