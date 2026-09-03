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


// /home/jony/Downloads/soma-retargeter/soma_retargeter/utils/pose_utils.py:37
static CUDA_CALLABLE void wp_compute_global_pose_0(
    wp::int32 var_in_num_joints,
    wp::transform_t<wp::float32> var_in_root_tx,
    wp::array_t<wp::int32> var_in_parent_indices,
    wp::array_t<wp::transform_t<wp::float32>> var_in_local_pose,
    wp::array_t<wp::transform_t<wp::float32>> var_out_result)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    wp::transform_t<wp::float32>* var_1;
    wp::transform_t<wp::float32> var_2;
    wp::transform_t<wp::float32> var_3;
    const wp::int32 var_4 = 0;
    const wp::int32 var_5 = 1;
    wp::range_t var_6;
    wp::int32 var_7;
    wp::int32* var_8;
    wp::transform_t<wp::float32>* var_9;
    wp::int32 var_10;
    wp::transform_t<wp::float32> var_11;
    wp::transform_t<wp::float32> var_12;
    wp::transform_t<wp::float32>* var_13;
    wp::transform_t<wp::float32> var_14;
    wp::transform_t<wp::float32> var_15;
    //---------
    // forward
    // def wp_compute_global_pose(                                                            <L 38>
    // out_result[0] = wp.mul(in_root_tx, in_local_pose[0])                                   <L 46>
    var_1 = wp::address(var_in_local_pose, var_0);
    var_3 = wp::load(var_1);
    var_2 = wp::mul(var_in_root_tx, var_3);
    wp::array_store(var_out_result, var_4, var_2);
    // for idx in range(1, in_num_joints):                                                    <L 47>
    var_6 = wp::range(var_5, var_in_num_joints);
    start_for_0:;
        if (iter_cmp(var_6) == 0) goto end_for_0;
        var_7 = wp::iter_next(var_6);
        // parent_tx = out_result[in_parent_indices[idx]]                                     <L 48>
        var_8 = wp::address(var_in_parent_indices, var_7);
        var_10 = wp::load(var_8);
        var_9 = wp::address(var_out_result, var_10);
        var_12 = wp::load(var_9);
        var_11 = wp::copy(var_12);
        // out_result[idx] = wp.transform_multiply(parent_tx, in_local_pose[idx])             <L 49>
        var_13 = wp::address(var_in_local_pose, var_7);
        var_15 = wp::load(var_13);
        var_14 = wp::transform_multiply(var_11, var_15);
        wp::array_store(var_out_result, var_7, var_14);
        goto start_for_0;
    end_for_0:;
}


// /home/jony/Downloads/soma-retargeter/soma_retargeter/robotics/human_to_robot_scaler.py:244
static CUDA_CALLABLE void HumanToRobotScaler__wp_compute_scaled_effectors_0(
    wp::int32 var_in_num_mapped_joints,
    wp::array_t<wp::transform_t<wp::float32>> var_in_global_pose,
    wp::array_t<wp::int32> var_in_mapped_joint_indices,
    wp::array_t<wp::float32> var_in_mapped_joint_scales,
    wp::array_t<wp::transform_t<wp::float32>> var_in_mapped_joint_offsets,
    bool var_in_scale_animation,
    wp::array_t<wp::transform_t<wp::float32>> var_out_result)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    wp::int32* var_1;
    wp::transform_t<wp::float32>* var_2;
    wp::int32 var_3;
    wp::vec_t<3, wp::float32> var_4;
    wp::transform_t<wp::float32> var_5;
    const wp::int32 var_6 = 0;
    wp::float32* var_7;
    wp::vec_t<3, wp::float32> var_8;
    wp::float32 var_9;
    const wp::float32 var_10 = 1.0;
    const wp::float32 var_11 = 1.0;
    const wp::int32 var_12 = 0;
    wp::float32* var_13;
    wp::vec_t<3, wp::float32> var_14;
    wp::float32 var_15;
    wp::vec_t<3, wp::float32> var_16;
    wp::vec_t<3, wp::float32> var_17;
    wp::range_t var_18;
    wp::int32 var_19;
    wp::int32* var_20;
    wp::int32 var_21;
    wp::int32 var_22;
    wp::transform_t<wp::float32>* var_23;
    wp::transform_t<wp::float32> var_24;
    wp::transform_t<wp::float32> var_25;
    wp::transform_t<wp::float32>* var_26;
    wp::transform_t<wp::float32> var_27;
    wp::transform_t<wp::float32> var_28;
    wp::float32* var_29;
    wp::vec_t<3, wp::float32> var_30;
    wp::float32 var_31;
    const wp::float32 var_32 = 1.0;
    const wp::float32 var_33 = 1.0;
    wp::float32* var_34;
    wp::vec_t<3, wp::float32> var_35;
    wp::float32 var_36;
    wp::vec_t<3, wp::float32> var_37;
    wp::vec_t<3, wp::float32> var_38;
    wp::vec_t<3, wp::float32> var_39;
    wp::vec_t<3, wp::float32> var_40;
    wp::quat_t<wp::float32> var_41;
    wp::quat_t<wp::float32> var_42;
    wp::quat_t<wp::float32> var_43;
    wp::vec_t<3, wp::float32> var_44;
    wp::vec_t<3, wp::float32> var_45;
    wp::vec_t<3, wp::float32> var_46;
    wp::vec_t<3, wp::float32> var_47;
    wp::transform_t<wp::float32> var_48;
    //---------
    // forward
    // def wp_compute_scaled_effectors(                                                       <L 245>
    // root_t = in_global_pose[in_mapped_joint_indices[0]].p                                  <L 254>
    var_1 = wp::address(var_in_mapped_joint_indices, var_0);
    var_3 = wp::load(var_1);
    var_2 = wp::address(var_in_global_pose, var_3);
    var_5 = wp::load(var_2);
    var_4 = wp::transform_get_translation(var_5);
    // scale = wp.where(in_scale_animation, wp.vec3(in_mapped_joint_scales[0]), wp.vec3(1.0, 1.0, in_mapped_joint_scales[0]))       <L 256>
    var_7 = wp::address(var_in_mapped_joint_scales, var_6);
    var_9 = wp::load(var_7);
    var_8 = wp::vec_t<3, wp::float32>(var_9);
    var_13 = wp::address(var_in_mapped_joint_scales, var_12);
    var_15 = wp::load(var_13);
    var_14 = wp::vec_t<3, wp::float32>(var_10, var_11, var_15);
    var_16 = wp::where(var_in_scale_animation, var_8, var_14);
    // scaled_root_t = wp.cw_mul(root_t, scale)                                               <L 257>
    var_17 = wp::cw_mul(var_4, var_16);
    // for i in range(in_num_mapped_joints):                                                  <L 259>
    var_18 = wp::range(var_in_num_mapped_joints);
    start_for_0:;
        if (iter_cmp(var_18) == 0) goto end_for_0;
        var_19 = wp::iter_next(var_18);
        // idx = in_mapped_joint_indices[i]                                                   <L 260>
        var_20 = wp::address(var_in_mapped_joint_indices, var_19);
        var_22 = wp::load(var_20);
        var_21 = wp::copy(var_22);
        // pose_tx = in_global_pose[idx]                                                      <L 261>
        var_23 = wp::address(var_in_global_pose, var_21);
        var_25 = wp::load(var_23);
        var_24 = wp::copy(var_25);
        // offset_tx = in_mapped_joint_offsets[i]                                             <L 262>
        var_26 = wp::address(var_in_mapped_joint_offsets, var_19);
        var_28 = wp::load(var_26);
        var_27 = wp::copy(var_28);
        // scale = wp.where(in_scale_animation, wp.vec3(in_mapped_joint_scales[i]), wp.vec3(1.0, 1.0, in_mapped_joint_scales[i]))       <L 264>
        var_29 = wp::address(var_in_mapped_joint_scales, var_19);
        var_31 = wp::load(var_29);
        var_30 = wp::vec_t<3, wp::float32>(var_31);
        var_34 = wp::address(var_in_mapped_joint_scales, var_19);
        var_36 = wp::load(var_34);
        var_35 = wp::vec_t<3, wp::float32>(var_32, var_33, var_36);
        var_37 = wp::where(var_in_scale_animation, var_30, var_35);
        // geocentric_scaled_t = wp.cw_mul((pose_tx.p - root_t), scale)                       <L 265>
        var_38 = wp::transform_get_translation(var_24);
        var_39 = wp::sub(var_38, var_4);
        var_40 = wp::cw_mul(var_39, var_37);
        // q = wp.mul(pose_tx.q, offset_tx.q)                                                 <L 267>
        var_41 = wp::transform_get_rotation(var_24);
        var_42 = wp::transform_get_rotation(var_27);
        var_43 = wp::mul(var_41, var_42);
        // t = geocentric_scaled_t + scaled_root_t + wp.quat_rotate(q, offset_tx.p)           <L 268>
        var_44 = wp::add(var_40, var_17);
        var_45 = wp::transform_get_translation(var_27);
        var_46 = wp::quat_rotate(var_43, var_45);
        var_47 = wp::add(var_44, var_46);
        // out_result[i] = wp.transform(t, q)                                                 <L 269>
        var_48 = wp::transform_t<wp::float32>(var_47, var_43);
        wp::array_store(var_out_result, var_19, var_48);
        wp::assign(var_16, var_37);
        goto start_for_0;
    end_for_0:;
}


// /home/jony/Downloads/soma-retargeter/soma_retargeter/utils/pose_utils.py:37
static CUDA_CALLABLE void adj_wp_compute_global_pose_0(
    wp::int32 var_in_num_joints,
    wp::transform_t<wp::float32> var_in_root_tx,
    wp::array_t<wp::int32> var_in_parent_indices,
    wp::array_t<wp::transform_t<wp::float32>> var_in_local_pose,
    wp::array_t<wp::transform_t<wp::float32>> var_out_result,
    wp::int32 & adj_in_num_joints,
    wp::transform_t<wp::float32> & adj_in_root_tx,
    wp::array_t<wp::int32> & adj_in_parent_indices,
    wp::array_t<wp::transform_t<wp::float32>> & adj_in_local_pose,
    wp::array_t<wp::transform_t<wp::float32>> & adj_out_result)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    wp::transform_t<wp::float32>* var_1;
    wp::transform_t<wp::float32> var_2;
    wp::transform_t<wp::float32> var_3;
    const wp::int32 var_4 = 0;
    const wp::int32 var_5 = 1;
    wp::range_t var_6;
    wp::int32 var_7;
    wp::int32* var_8;
    wp::transform_t<wp::float32>* var_9;
    wp::int32 var_10;
    wp::transform_t<wp::float32> var_11;
    wp::transform_t<wp::float32> var_12;
    wp::transform_t<wp::float32>* var_13;
    wp::transform_t<wp::float32> var_14;
    wp::transform_t<wp::float32> var_15;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    wp::transform_t<wp::float32> adj_1 = {};
    wp::transform_t<wp::float32> adj_2 = {};
    wp::transform_t<wp::float32> adj_3 = {};
    wp::int32 adj_4 = {};
    wp::int32 adj_5 = {};
    wp::range_t adj_6 = {};
    wp::int32 adj_7 = {};
    wp::int32 adj_8 = {};
    wp::transform_t<wp::float32> adj_9 = {};
    wp::int32 adj_10 = {};
    wp::transform_t<wp::float32> adj_11 = {};
    wp::transform_t<wp::float32> adj_12 = {};
    wp::transform_t<wp::float32> adj_13 = {};
    wp::transform_t<wp::float32> adj_14 = {};
    wp::transform_t<wp::float32> adj_15 = {};
    //---------
    // forward
    // def wp_compute_global_pose(                                                            <L 38>
    // out_result[0] = wp.mul(in_root_tx, in_local_pose[0])                                   <L 46>
    var_1 = wp::address(var_in_local_pose, var_0);
    var_3 = wp::load(var_1);
    var_2 = wp::mul(var_in_root_tx, var_3);
    // wp::array_store(var_out_result, var_4, var_2);
    // for idx in range(1, in_num_joints):                                                    <L 47>
    var_6 = wp::range(var_5, var_in_num_joints);
    //---------
    // reverse
    var_6 = wp::iter_reverse(var_6);
    start_for_0:;
        if (iter_cmp(var_6) == 0) goto end_for_0;
        var_7 = wp::iter_next(var_6);
    	adj_8 = {};
    	adj_9 = {};
    	adj_10 = {};
    	adj_11 = {};
    	adj_12 = {};
    	adj_13 = {};
    	adj_14 = {};
    	adj_15 = {};
        // parent_tx = out_result[in_parent_indices[idx]]                                     <L 48>
        var_8 = wp::address(var_in_parent_indices, var_7);
        var_10 = wp::load(var_8);
        var_9 = wp::address(var_out_result, var_10);
        var_12 = wp::load(var_9);
        var_11 = wp::copy(var_12);
        // out_result[idx] = wp.transform_multiply(parent_tx, in_local_pose[idx])             <L 49>
        var_13 = wp::address(var_in_local_pose, var_7);
        var_15 = wp::load(var_13);
        var_14 = wp::transform_multiply(var_11, var_15);
        // wp::array_store(var_out_result, var_7, var_14);
        wp::adj_array_store(var_out_result, var_7, var_14, adj_out_result, adj_7, adj_14);
        wp::adj_transform_multiply(var_11, var_15, adj_11, adj_13, adj_14);
        wp::adj_address(var_in_local_pose, var_7, adj_in_local_pose, adj_7, adj_13);
        // adj: out_result[idx] = wp.transform_multiply(parent_tx, in_local_pose[idx])        <L 49>
        wp::adj_copy(var_12, adj_9, adj_11);
        wp::adj_address(var_out_result, var_10, adj_out_result, adj_8, adj_9);
        wp::adj_address(var_in_parent_indices, var_7, adj_in_parent_indices, adj_7, adj_8);
        // adj: parent_tx = out_result[in_parent_indices[idx]]                                <L 48>
    	goto start_for_0;
    end_for_0:;
    // adj: for idx in range(1, in_num_joints):                                               <L 47>
    wp::adj_array_store(var_out_result, var_4, var_2, adj_out_result, adj_4, adj_2);
    wp::adj_mul(var_in_root_tx, var_3, adj_in_root_tx, adj_1, adj_2);
    wp::adj_address(var_in_local_pose, var_0, adj_in_local_pose, adj_0, adj_1);
    // adj: out_result[0] = wp.mul(in_root_tx, in_local_pose[0])                              <L 46>
    // adj: def wp_compute_global_pose(                                                       <L 38>
    return;
}


// /home/jony/Downloads/soma-retargeter/soma_retargeter/robotics/human_to_robot_scaler.py:244
static CUDA_CALLABLE void adj_HumanToRobotScaler__wp_compute_scaled_effectors_0(
    wp::int32 var_in_num_mapped_joints,
    wp::array_t<wp::transform_t<wp::float32>> var_in_global_pose,
    wp::array_t<wp::int32> var_in_mapped_joint_indices,
    wp::array_t<wp::float32> var_in_mapped_joint_scales,
    wp::array_t<wp::transform_t<wp::float32>> var_in_mapped_joint_offsets,
    bool var_in_scale_animation,
    wp::array_t<wp::transform_t<wp::float32>> var_out_result,
    wp::int32 & adj_in_num_mapped_joints,
    wp::array_t<wp::transform_t<wp::float32>> & adj_in_global_pose,
    wp::array_t<wp::int32> & adj_in_mapped_joint_indices,
    wp::array_t<wp::float32> & adj_in_mapped_joint_scales,
    wp::array_t<wp::transform_t<wp::float32>> & adj_in_mapped_joint_offsets,
    bool & adj_in_scale_animation,
    wp::array_t<wp::transform_t<wp::float32>> & adj_out_result)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    wp::int32* var_1;
    wp::transform_t<wp::float32>* var_2;
    wp::int32 var_3;
    wp::vec_t<3, wp::float32> var_4;
    wp::transform_t<wp::float32> var_5;
    const wp::int32 var_6 = 0;
    wp::float32* var_7;
    wp::vec_t<3, wp::float32> var_8;
    wp::float32 var_9;
    const wp::float32 var_10 = 1.0;
    const wp::float32 var_11 = 1.0;
    const wp::int32 var_12 = 0;
    wp::float32* var_13;
    wp::vec_t<3, wp::float32> var_14;
    wp::float32 var_15;
    wp::vec_t<3, wp::float32> var_16;
    wp::vec_t<3, wp::float32> var_17;
    wp::range_t var_18;
    wp::int32 var_19;
    wp::int32* var_20;
    wp::int32 var_21;
    wp::int32 var_22;
    wp::transform_t<wp::float32>* var_23;
    wp::transform_t<wp::float32> var_24;
    wp::transform_t<wp::float32> var_25;
    wp::transform_t<wp::float32>* var_26;
    wp::transform_t<wp::float32> var_27;
    wp::transform_t<wp::float32> var_28;
    wp::float32* var_29;
    wp::vec_t<3, wp::float32> var_30;
    wp::float32 var_31;
    const wp::float32 var_32 = 1.0;
    const wp::float32 var_33 = 1.0;
    wp::float32* var_34;
    wp::vec_t<3, wp::float32> var_35;
    wp::float32 var_36;
    wp::vec_t<3, wp::float32> var_37;
    wp::vec_t<3, wp::float32> var_38;
    wp::vec_t<3, wp::float32> var_39;
    wp::vec_t<3, wp::float32> var_40;
    wp::quat_t<wp::float32> var_41;
    wp::quat_t<wp::float32> var_42;
    wp::quat_t<wp::float32> var_43;
    wp::vec_t<3, wp::float32> var_44;
    wp::vec_t<3, wp::float32> var_45;
    wp::vec_t<3, wp::float32> var_46;
    wp::vec_t<3, wp::float32> var_47;
    wp::transform_t<wp::float32> var_48;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    wp::int32 adj_1 = {};
    wp::transform_t<wp::float32> adj_2 = {};
    wp::int32 adj_3 = {};
    wp::vec_t<3, wp::float32> adj_4 = {};
    wp::transform_t<wp::float32> adj_5 = {};
    wp::int32 adj_6 = {};
    wp::float32 adj_7 = {};
    wp::vec_t<3, wp::float32> adj_8 = {};
    wp::float32 adj_9 = {};
    wp::float32 adj_10 = {};
    wp::float32 adj_11 = {};
    wp::int32 adj_12 = {};
    wp::float32 adj_13 = {};
    wp::vec_t<3, wp::float32> adj_14 = {};
    wp::float32 adj_15 = {};
    wp::vec_t<3, wp::float32> adj_16 = {};
    wp::vec_t<3, wp::float32> adj_17 = {};
    wp::range_t adj_18 = {};
    wp::int32 adj_19 = {};
    wp::int32 adj_20 = {};
    wp::int32 adj_21 = {};
    wp::int32 adj_22 = {};
    wp::transform_t<wp::float32> adj_23 = {};
    wp::transform_t<wp::float32> adj_24 = {};
    wp::transform_t<wp::float32> adj_25 = {};
    wp::transform_t<wp::float32> adj_26 = {};
    wp::transform_t<wp::float32> adj_27 = {};
    wp::transform_t<wp::float32> adj_28 = {};
    wp::float32 adj_29 = {};
    wp::vec_t<3, wp::float32> adj_30 = {};
    wp::float32 adj_31 = {};
    wp::float32 adj_32 = {};
    wp::float32 adj_33 = {};
    wp::float32 adj_34 = {};
    wp::vec_t<3, wp::float32> adj_35 = {};
    wp::float32 adj_36 = {};
    wp::vec_t<3, wp::float32> adj_37 = {};
    wp::vec_t<3, wp::float32> adj_38 = {};
    wp::vec_t<3, wp::float32> adj_39 = {};
    wp::vec_t<3, wp::float32> adj_40 = {};
    wp::quat_t<wp::float32> adj_41 = {};
    wp::quat_t<wp::float32> adj_42 = {};
    wp::quat_t<wp::float32> adj_43 = {};
    wp::vec_t<3, wp::float32> adj_44 = {};
    wp::vec_t<3, wp::float32> adj_45 = {};
    wp::vec_t<3, wp::float32> adj_46 = {};
    wp::vec_t<3, wp::float32> adj_47 = {};
    wp::transform_t<wp::float32> adj_48 = {};
    //---------
    // forward
    // def wp_compute_scaled_effectors(                                                       <L 245>
    // root_t = in_global_pose[in_mapped_joint_indices[0]].p                                  <L 254>
    var_1 = wp::address(var_in_mapped_joint_indices, var_0);
    var_3 = wp::load(var_1);
    var_2 = wp::address(var_in_global_pose, var_3);
    var_5 = wp::load(var_2);
    var_4 = wp::transform_get_translation(var_5);
    // scale = wp.where(in_scale_animation, wp.vec3(in_mapped_joint_scales[0]), wp.vec3(1.0, 1.0, in_mapped_joint_scales[0]))       <L 256>
    var_7 = wp::address(var_in_mapped_joint_scales, var_6);
    var_9 = wp::load(var_7);
    var_8 = wp::vec_t<3, wp::float32>(var_9);
    var_13 = wp::address(var_in_mapped_joint_scales, var_12);
    var_15 = wp::load(var_13);
    var_14 = wp::vec_t<3, wp::float32>(var_10, var_11, var_15);
    var_16 = wp::where(var_in_scale_animation, var_8, var_14);
    // scaled_root_t = wp.cw_mul(root_t, scale)                                               <L 257>
    var_17 = wp::cw_mul(var_4, var_16);
    // for i in range(in_num_mapped_joints):                                                  <L 259>
    var_18 = wp::range(var_in_num_mapped_joints);
    //---------
    // reverse
    var_18 = wp::iter_reverse(var_18);
    start_for_0:;
        if (iter_cmp(var_18) == 0) goto end_for_0;
        var_19 = wp::iter_next(var_18);
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
        // idx = in_mapped_joint_indices[i]                                                   <L 260>
        var_20 = wp::address(var_in_mapped_joint_indices, var_19);
        var_22 = wp::load(var_20);
        var_21 = wp::copy(var_22);
        // pose_tx = in_global_pose[idx]                                                      <L 261>
        var_23 = wp::address(var_in_global_pose, var_21);
        var_25 = wp::load(var_23);
        var_24 = wp::copy(var_25);
        // offset_tx = in_mapped_joint_offsets[i]                                             <L 262>
        var_26 = wp::address(var_in_mapped_joint_offsets, var_19);
        var_28 = wp::load(var_26);
        var_27 = wp::copy(var_28);
        // scale = wp.where(in_scale_animation, wp.vec3(in_mapped_joint_scales[i]), wp.vec3(1.0, 1.0, in_mapped_joint_scales[i]))       <L 264>
        var_29 = wp::address(var_in_mapped_joint_scales, var_19);
        var_31 = wp::load(var_29);
        var_30 = wp::vec_t<3, wp::float32>(var_31);
        var_34 = wp::address(var_in_mapped_joint_scales, var_19);
        var_36 = wp::load(var_34);
        var_35 = wp::vec_t<3, wp::float32>(var_32, var_33, var_36);
        var_37 = wp::where(var_in_scale_animation, var_30, var_35);
        // geocentric_scaled_t = wp.cw_mul((pose_tx.p - root_t), scale)                       <L 265>
        var_38 = wp::transform_get_translation(var_24);
        var_39 = wp::sub(var_38, var_4);
        var_40 = wp::cw_mul(var_39, var_37);
        // q = wp.mul(pose_tx.q, offset_tx.q)                                                 <L 267>
        var_41 = wp::transform_get_rotation(var_24);
        var_42 = wp::transform_get_rotation(var_27);
        var_43 = wp::mul(var_41, var_42);
        // t = geocentric_scaled_t + scaled_root_t + wp.quat_rotate(q, offset_tx.p)           <L 268>
        var_44 = wp::add(var_40, var_17);
        var_45 = wp::transform_get_translation(var_27);
        var_46 = wp::quat_rotate(var_43, var_45);
        var_47 = wp::add(var_44, var_46);
        // out_result[i] = wp.transform(t, q)                                                 <L 269>
        var_48 = wp::transform_t<wp::float32>(var_47, var_43);
        // wp::array_store(var_out_result, var_19, var_48);
        wp::assign(var_16, var_37);
        wp::adj_assign(var_16, var_37, adj_16, adj_37);
        wp::adj_array_store(var_out_result, var_19, var_48, adj_out_result, adj_19, adj_48);
        wp::adj_transform_t(var_47, var_43, adj_47, adj_43, adj_48);
        // adj: out_result[i] = wp.transform(t, q)                                            <L 269>
        wp::adj_add(var_44, var_46, adj_44, adj_46, adj_47);
        wp::adj_quat_rotate(var_43, var_45, adj_43, adj_45, adj_46);
        wp::adj_transform_get_translation(var_27, adj_27, adj_45);
        wp::adj_add(var_40, var_17, adj_40, adj_17, adj_44);
        // adj: t = geocentric_scaled_t + scaled_root_t + wp.quat_rotate(q, offset_tx.p)      <L 268>
        wp::adj_mul(var_41, var_42, adj_41, adj_42, adj_43);
        wp::adj_transform_get_rotation(var_27, adj_27, adj_42);
        wp::adj_transform_get_rotation(var_24, adj_24, adj_41);
        // adj: q = wp.mul(pose_tx.q, offset_tx.q)                                            <L 267>
        wp::adj_cw_mul(var_39, var_37, adj_39, adj_37, adj_40);
        wp::adj_sub(var_38, var_4, adj_38, adj_4, adj_39);
        wp::adj_transform_get_translation(var_24, adj_24, adj_38);
        // adj: geocentric_scaled_t = wp.cw_mul((pose_tx.p - root_t), scale)                  <L 265>
        wp::adj_where(var_in_scale_animation, var_30, var_35, adj_in_scale_animation, adj_30, adj_35, adj_37);
        wp::adj_vec_t(var_32, var_33, var_36, adj_32, adj_33, adj_34, adj_35);
        wp::adj_address(var_in_mapped_joint_scales, var_19, adj_in_mapped_joint_scales, adj_19, adj_34);
        wp::adj_vec_t(var_31, adj_29, adj_30);
        wp::adj_address(var_in_mapped_joint_scales, var_19, adj_in_mapped_joint_scales, adj_19, adj_29);
        // adj: scale = wp.where(in_scale_animation, wp.vec3(in_mapped_joint_scales[i]), wp.vec3(1.0, 1.0, in_mapped_joint_scales[i]))  <L 264>
        wp::adj_copy(var_28, adj_26, adj_27);
        wp::adj_address(var_in_mapped_joint_offsets, var_19, adj_in_mapped_joint_offsets, adj_19, adj_26);
        // adj: offset_tx = in_mapped_joint_offsets[i]                                        <L 262>
        wp::adj_copy(var_25, adj_23, adj_24);
        wp::adj_address(var_in_global_pose, var_21, adj_in_global_pose, adj_21, adj_23);
        // adj: pose_tx = in_global_pose[idx]                                                 <L 261>
        wp::adj_copy(var_22, adj_20, adj_21);
        wp::adj_address(var_in_mapped_joint_indices, var_19, adj_in_mapped_joint_indices, adj_19, adj_20);
        // adj: idx = in_mapped_joint_indices[i]                                              <L 260>
    	goto start_for_0;
    end_for_0:;
    // adj: for i in range(in_num_mapped_joints):                                             <L 259>
    wp::adj_cw_mul(var_4, var_16, adj_4, adj_16, adj_17);
    // adj: scaled_root_t = wp.cw_mul(root_t, scale)                                          <L 257>
    wp::adj_where(var_in_scale_animation, var_8, var_14, adj_in_scale_animation, adj_8, adj_14, adj_16);
    wp::adj_vec_t(var_10, var_11, var_15, adj_10, adj_11, adj_13, adj_14);
    wp::adj_address(var_in_mapped_joint_scales, var_12, adj_in_mapped_joint_scales, adj_12, adj_13);
    wp::adj_vec_t(var_9, adj_7, adj_8);
    wp::adj_address(var_in_mapped_joint_scales, var_6, adj_in_mapped_joint_scales, adj_6, adj_7);
    // adj: scale = wp.where(in_scale_animation, wp.vec3(in_mapped_joint_scales[0]), wp.vec3(1.0, 1.0, in_mapped_joint_scales[0]))  <L 256>
    wp::adj_transform_get_translation(var_5, adj_2, adj_4);
    wp::adj_address(var_in_global_pose, var_3, adj_in_global_pose, adj_1, adj_2);
    wp::adj_address(var_in_mapped_joint_indices, var_0, adj_in_mapped_joint_indices, adj_0, adj_1);
    // adj: root_t = in_global_pose[in_mapped_joint_indices[0]].p                             <L 254>
    // adj: def wp_compute_scaled_effectors(                                                  <L 245>
    return;
}



extern "C" __global__ void HumanToRobotScaler__compute_effectors_from_buffer__locals__batched_compute_global_pose_kernel_83f9e813_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::int32 var_in_num_joints,
    wp::transform_t<wp::float32> var_in_root_tx,
    wp::array_t<wp::int32> var_in_parent_indices,
    wp::array_t<wp::transform_t<wp::float32>> var_in_local_pose,
    wp::array_t<wp::transform_t<wp::float32>> var_out_result)
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
        wp::slice_t var_1;
        const wp::int32 var_2 = 0;
        wp::array_t<wp::transform_t<wp::float32>> var_3;
        wp::slice_t var_4;
        const wp::int32 var_5 = 0;
        wp::array_t<wp::transform_t<wp::float32>> var_6;
        //---------
        // forward
        // def batched_compute_global_pose_kernel(                                                <L 155>
        // frame_idx = wp.tid()                                                                   <L 162>
        var_0 = builtin_tid1d();
        // pose_utils.wp_compute_global_pose(                                                     <L 163>
        // in_num_joints, in_root_tx, in_parent_indices, in_local_pose[frame_idx], out_result[frame_idx])       <L 164>
        var_1 = wp::slice_t(var_0, var_0, var_2);
        var_3 = wp::view(var_in_local_pose, var_1);
        var_4 = wp::slice_t(var_0, var_0, var_5);
        var_6 = wp::view(var_out_result, var_4);
        wp_compute_global_pose_0(var_in_num_joints, var_in_root_tx, var_in_parent_indices, var_3, var_6);
    }
}



extern "C" __global__ void HumanToRobotScaler__compute_effectors_from_buffer__locals__batched_compute_global_pose_kernel_83f9e813_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::int32 var_in_num_joints,
    wp::transform_t<wp::float32> var_in_root_tx,
    wp::array_t<wp::int32> var_in_parent_indices,
    wp::array_t<wp::transform_t<wp::float32>> var_in_local_pose,
    wp::array_t<wp::transform_t<wp::float32>> var_out_result,
    wp::int32 adj_in_num_joints,
    wp::transform_t<wp::float32> adj_in_root_tx,
    wp::array_t<wp::int32> adj_in_parent_indices,
    wp::array_t<wp::transform_t<wp::float32>> adj_in_local_pose,
    wp::array_t<wp::transform_t<wp::float32>> adj_out_result)
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
        wp::slice_t var_1;
        const wp::int32 var_2 = 0;
        wp::array_t<wp::transform_t<wp::float32>> var_3;
        wp::slice_t var_4;
        const wp::int32 var_5 = 0;
        wp::array_t<wp::transform_t<wp::float32>> var_6;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::slice_t adj_1 = {};
        wp::int32 adj_2 = {};
        wp::array_t<wp::transform_t<wp::float32>> adj_3 = {};
        wp::slice_t adj_4 = {};
        wp::int32 adj_5 = {};
        wp::array_t<wp::transform_t<wp::float32>> adj_6 = {};
        //---------
        // forward
        // def batched_compute_global_pose_kernel(                                                <L 155>
        // frame_idx = wp.tid()                                                                   <L 162>
        var_0 = builtin_tid1d();
        // pose_utils.wp_compute_global_pose(                                                     <L 163>
        // in_num_joints, in_root_tx, in_parent_indices, in_local_pose[frame_idx], out_result[frame_idx])       <L 164>
        var_1 = wp::slice_t(var_0, var_0, var_2);
        var_3 = wp::view(var_in_local_pose, var_1);
        var_4 = wp::slice_t(var_0, var_0, var_5);
        var_6 = wp::view(var_out_result, var_4);
        wp_compute_global_pose_0(var_in_num_joints, var_in_root_tx, var_in_parent_indices, var_3, var_6);
        //---------
        // reverse
        adj_wp_compute_global_pose_0(var_in_num_joints, var_in_root_tx, var_in_parent_indices, var_3, var_6, adj_in_num_joints, adj_in_root_tx, adj_in_parent_indices, adj_3, adj_6);
        wp::adj_view(var_out_result, var_4, adj_out_result, adj_4, adj_6);
        wp::adj_view(var_in_local_pose, var_1, adj_in_local_pose, adj_1, adj_3);
        // adj: in_num_joints, in_root_tx, in_parent_indices, in_local_pose[frame_idx], out_result[frame_idx])  <L 164>
        // adj: pose_utils.wp_compute_global_pose(                                                <L 163>
        // adj: frame_idx = wp.tid()                                                              <L 162>
        // adj: def batched_compute_global_pose_kernel(                                           <L 155>
        continue;
    }
}



extern "C" __global__ void HumanToRobotScaler__compute_effectors_from_buffer__locals__batched_compute_scaled_effectors_2d_kernel_66a28758_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::int32 var_in_num_mapped_joints,
    wp::array_t<wp::transform_t<wp::float32>> var_in_global_pose,
    wp::array_t<wp::int32> var_in_mapped_joint_indices,
    wp::array_t<wp::float32> var_in_mapped_joint_scales,
    wp::array_t<wp::transform_t<wp::float32>> var_in_mapped_joint_offsets,
    bool var_in_scale_animation,
    wp::array_t<wp::transform_t<wp::float32>> var_out_result)
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
        wp::slice_t var_1;
        const wp::int32 var_2 = 0;
        wp::array_t<wp::transform_t<wp::float32>> var_3;
        wp::slice_t var_4;
        const wp::int32 var_5 = 0;
        wp::array_t<wp::transform_t<wp::float32>> var_6;
        //---------
        // forward
        // def batched_compute_scaled_effectors_2d_kernel(                                        <L 167>
        // frame_idx = wp.tid()                                                                   <L 176>
        var_0 = builtin_tid1d();
        // HumanToRobotScaler.wp_compute_scaled_effectors(                                        <L 177>
        // in_num_mapped_joints, in_global_pose[frame_idx], in_mapped_joint_indices,              <L 178>
        var_1 = wp::slice_t(var_0, var_0, var_2);
        var_3 = wp::view(var_in_global_pose, var_1);
        // in_mapped_joint_scales, in_mapped_joint_offsets, in_scale_animation, out_result[frame_idx])       <L 179>
        var_4 = wp::slice_t(var_0, var_0, var_5);
        var_6 = wp::view(var_out_result, var_4);
        HumanToRobotScaler__wp_compute_scaled_effectors_0(var_in_num_mapped_joints, var_3, var_in_mapped_joint_indices, var_in_mapped_joint_scales, var_in_mapped_joint_offsets, var_in_scale_animation, var_6);
    }
}



extern "C" __global__ void HumanToRobotScaler__compute_effectors_from_buffer__locals__batched_compute_scaled_effectors_2d_kernel_66a28758_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::int32 var_in_num_mapped_joints,
    wp::array_t<wp::transform_t<wp::float32>> var_in_global_pose,
    wp::array_t<wp::int32> var_in_mapped_joint_indices,
    wp::array_t<wp::float32> var_in_mapped_joint_scales,
    wp::array_t<wp::transform_t<wp::float32>> var_in_mapped_joint_offsets,
    bool var_in_scale_animation,
    wp::array_t<wp::transform_t<wp::float32>> var_out_result,
    wp::int32 adj_in_num_mapped_joints,
    wp::array_t<wp::transform_t<wp::float32>> adj_in_global_pose,
    wp::array_t<wp::int32> adj_in_mapped_joint_indices,
    wp::array_t<wp::float32> adj_in_mapped_joint_scales,
    wp::array_t<wp::transform_t<wp::float32>> adj_in_mapped_joint_offsets,
    bool adj_in_scale_animation,
    wp::array_t<wp::transform_t<wp::float32>> adj_out_result)
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
        wp::slice_t var_1;
        const wp::int32 var_2 = 0;
        wp::array_t<wp::transform_t<wp::float32>> var_3;
        wp::slice_t var_4;
        const wp::int32 var_5 = 0;
        wp::array_t<wp::transform_t<wp::float32>> var_6;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::slice_t adj_1 = {};
        wp::int32 adj_2 = {};
        wp::array_t<wp::transform_t<wp::float32>> adj_3 = {};
        wp::slice_t adj_4 = {};
        wp::int32 adj_5 = {};
        wp::array_t<wp::transform_t<wp::float32>> adj_6 = {};
        //---------
        // forward
        // def batched_compute_scaled_effectors_2d_kernel(                                        <L 167>
        // frame_idx = wp.tid()                                                                   <L 176>
        var_0 = builtin_tid1d();
        // HumanToRobotScaler.wp_compute_scaled_effectors(                                        <L 177>
        // in_num_mapped_joints, in_global_pose[frame_idx], in_mapped_joint_indices,              <L 178>
        var_1 = wp::slice_t(var_0, var_0, var_2);
        var_3 = wp::view(var_in_global_pose, var_1);
        // in_mapped_joint_scales, in_mapped_joint_offsets, in_scale_animation, out_result[frame_idx])       <L 179>
        var_4 = wp::slice_t(var_0, var_0, var_5);
        var_6 = wp::view(var_out_result, var_4);
        HumanToRobotScaler__wp_compute_scaled_effectors_0(var_in_num_mapped_joints, var_3, var_in_mapped_joint_indices, var_in_mapped_joint_scales, var_in_mapped_joint_offsets, var_in_scale_animation, var_6);
        //---------
        // reverse
        adj_HumanToRobotScaler__wp_compute_scaled_effectors_0(var_in_num_mapped_joints, var_3, var_in_mapped_joint_indices, var_in_mapped_joint_scales, var_in_mapped_joint_offsets, var_in_scale_animation, var_6, adj_in_num_mapped_joints, adj_3, adj_in_mapped_joint_indices, adj_in_mapped_joint_scales, adj_in_mapped_joint_offsets, adj_in_scale_animation, adj_6);
        wp::adj_view(var_out_result, var_4, adj_out_result, adj_4, adj_6);
        // adj: in_mapped_joint_scales, in_mapped_joint_offsets, in_scale_animation, out_result[frame_idx])  <L 179>
        wp::adj_view(var_in_global_pose, var_1, adj_in_global_pose, adj_1, adj_3);
        // adj: in_num_mapped_joints, in_global_pose[frame_idx], in_mapped_joint_indices,         <L 178>
        // adj: HumanToRobotScaler.wp_compute_scaled_effectors(                                   <L 177>
        // adj: frame_idx = wp.tid()                                                              <L 176>
        // adj: def batched_compute_scaled_effectors_2d_kernel(                                   <L 167>
        continue;
    }
}

