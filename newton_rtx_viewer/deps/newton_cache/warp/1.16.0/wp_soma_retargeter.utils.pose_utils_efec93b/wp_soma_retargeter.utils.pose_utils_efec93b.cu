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


// /home/jony/Downloads/soma-retargeter/soma_retargeter/utils/pose_utils.py:10
static CUDA_CALLABLE void wp_compute_local_pose_0(
    wp::int32 var_in_num_joints,
    wp::transform_t<wp::float32> var_in_root_tx,
    wp::array_t<wp::int32> var_in_parent_indices,
    wp::array_t<wp::transform_t<wp::float32>> var_in_global_pose,
    wp::array_t<wp::transform_t<wp::float32>> var_out_result)
{
    //---------
    // primal vars
    wp::transform_t<wp::float32> var_0;
    const wp::int32 var_1 = 0;
    wp::transform_t<wp::float32>* var_2;
    wp::transform_t<wp::float32> var_3;
    wp::transform_t<wp::float32> var_4;
    const wp::int32 var_5 = 0;
    const wp::int32 var_6 = 1;
    wp::range_t var_7;
    wp::int32 var_8;
    wp::int32* var_9;
    wp::transform_t<wp::float32>* var_10;
    wp::int32 var_11;
    wp::transform_t<wp::float32> var_12;
    wp::transform_t<wp::float32> var_13;
    wp::transform_t<wp::float32> var_14;
    wp::transform_t<wp::float32>* var_15;
    wp::transform_t<wp::float32> var_16;
    wp::transform_t<wp::float32> var_17;
    //---------
    // forward
    // def wp_compute_local_pose(                                                             <L 11>
    // out_result[0] = wp.transform_multiply(wp.transform_inverse(in_root_tx), in_global_pose[0])       <L 19>
    var_0 = wp::transform_inverse(var_in_root_tx);
    var_2 = wp::address(var_in_global_pose, var_1);
    var_4 = wp::load(var_2);
    var_3 = wp::transform_multiply(var_0, var_4);
    wp::array_store(var_out_result, var_5, var_3);
    // for idx in range(1, in_num_joints):                                                    <L 20>
    var_7 = wp::range(var_6, var_in_num_joints);
    start_for_0:;
        if (iter_cmp(var_7) == 0) goto end_for_0;
        var_8 = wp::iter_next(var_7);
        // parent_tx = in_global_pose[in_parent_indices[idx]]                                 <L 21>
        var_9 = wp::address(var_in_parent_indices, var_8);
        var_11 = wp::load(var_9);
        var_10 = wp::address(var_in_global_pose, var_11);
        var_13 = wp::load(var_10);
        var_12 = wp::copy(var_13);
        // out_result[idx] = wp.transform_multiply(wp.transform_inverse(parent_tx), in_global_pose[idx])       <L 22>
        var_14 = wp::transform_inverse(var_12);
        var_15 = wp::address(var_in_global_pose, var_8);
        var_17 = wp::load(var_15);
        var_16 = wp::transform_multiply(var_14, var_17);
        wp::array_store(var_out_result, var_8, var_16);
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


// /home/jony/Downloads/soma-retargeter/soma_retargeter/utils/pose_utils.py:10
static CUDA_CALLABLE void adj_wp_compute_local_pose_0(
    wp::int32 var_in_num_joints,
    wp::transform_t<wp::float32> var_in_root_tx,
    wp::array_t<wp::int32> var_in_parent_indices,
    wp::array_t<wp::transform_t<wp::float32>> var_in_global_pose,
    wp::array_t<wp::transform_t<wp::float32>> var_out_result,
    wp::int32 & adj_in_num_joints,
    wp::transform_t<wp::float32> & adj_in_root_tx,
    wp::array_t<wp::int32> & adj_in_parent_indices,
    wp::array_t<wp::transform_t<wp::float32>> & adj_in_global_pose,
    wp::array_t<wp::transform_t<wp::float32>> & adj_out_result)
{
    //---------
    // primal vars
    wp::transform_t<wp::float32> var_0;
    const wp::int32 var_1 = 0;
    wp::transform_t<wp::float32>* var_2;
    wp::transform_t<wp::float32> var_3;
    wp::transform_t<wp::float32> var_4;
    const wp::int32 var_5 = 0;
    const wp::int32 var_6 = 1;
    wp::range_t var_7;
    wp::int32 var_8;
    wp::int32* var_9;
    wp::transform_t<wp::float32>* var_10;
    wp::int32 var_11;
    wp::transform_t<wp::float32> var_12;
    wp::transform_t<wp::float32> var_13;
    wp::transform_t<wp::float32> var_14;
    wp::transform_t<wp::float32>* var_15;
    wp::transform_t<wp::float32> var_16;
    wp::transform_t<wp::float32> var_17;
    //---------
    // dual vars
    wp::transform_t<wp::float32> adj_0 = {};
    wp::int32 adj_1 = {};
    wp::transform_t<wp::float32> adj_2 = {};
    wp::transform_t<wp::float32> adj_3 = {};
    wp::transform_t<wp::float32> adj_4 = {};
    wp::int32 adj_5 = {};
    wp::int32 adj_6 = {};
    wp::range_t adj_7 = {};
    wp::int32 adj_8 = {};
    wp::int32 adj_9 = {};
    wp::transform_t<wp::float32> adj_10 = {};
    wp::int32 adj_11 = {};
    wp::transform_t<wp::float32> adj_12 = {};
    wp::transform_t<wp::float32> adj_13 = {};
    wp::transform_t<wp::float32> adj_14 = {};
    wp::transform_t<wp::float32> adj_15 = {};
    wp::transform_t<wp::float32> adj_16 = {};
    wp::transform_t<wp::float32> adj_17 = {};
    //---------
    // forward
    // def wp_compute_local_pose(                                                             <L 11>
    // out_result[0] = wp.transform_multiply(wp.transform_inverse(in_root_tx), in_global_pose[0])       <L 19>
    var_0 = wp::transform_inverse(var_in_root_tx);
    var_2 = wp::address(var_in_global_pose, var_1);
    var_4 = wp::load(var_2);
    var_3 = wp::transform_multiply(var_0, var_4);
    // wp::array_store(var_out_result, var_5, var_3);
    // for idx in range(1, in_num_joints):                                                    <L 20>
    var_7 = wp::range(var_6, var_in_num_joints);
    //---------
    // reverse
    var_7 = wp::iter_reverse(var_7);
    start_for_0:;
        if (iter_cmp(var_7) == 0) goto end_for_0;
        var_8 = wp::iter_next(var_7);
    	adj_9 = {};
    	adj_10 = {};
    	adj_11 = {};
    	adj_12 = {};
    	adj_13 = {};
    	adj_14 = {};
    	adj_15 = {};
    	adj_16 = {};
    	adj_17 = {};
        // parent_tx = in_global_pose[in_parent_indices[idx]]                                 <L 21>
        var_9 = wp::address(var_in_parent_indices, var_8);
        var_11 = wp::load(var_9);
        var_10 = wp::address(var_in_global_pose, var_11);
        var_13 = wp::load(var_10);
        var_12 = wp::copy(var_13);
        // out_result[idx] = wp.transform_multiply(wp.transform_inverse(parent_tx), in_global_pose[idx])       <L 22>
        var_14 = wp::transform_inverse(var_12);
        var_15 = wp::address(var_in_global_pose, var_8);
        var_17 = wp::load(var_15);
        var_16 = wp::transform_multiply(var_14, var_17);
        // wp::array_store(var_out_result, var_8, var_16);
        wp::adj_array_store(var_out_result, var_8, var_16, adj_out_result, adj_8, adj_16);
        wp::adj_transform_multiply(var_14, var_17, adj_14, adj_15, adj_16);
        wp::adj_address(var_in_global_pose, var_8, adj_in_global_pose, adj_8, adj_15);
        wp::adj_transform_inverse(var_12, adj_12, adj_14);
        // adj: out_result[idx] = wp.transform_multiply(wp.transform_inverse(parent_tx), in_global_pose[idx])  <L 22>
        wp::adj_copy(var_13, adj_10, adj_12);
        wp::adj_address(var_in_global_pose, var_11, adj_in_global_pose, adj_9, adj_10);
        wp::adj_address(var_in_parent_indices, var_8, adj_in_parent_indices, adj_8, adj_9);
        // adj: parent_tx = in_global_pose[in_parent_indices[idx]]                            <L 21>
    	goto start_for_0;
    end_for_0:;
    // adj: for idx in range(1, in_num_joints):                                               <L 20>
    wp::adj_array_store(var_out_result, var_5, var_3, adj_out_result, adj_5, adj_3);
    wp::adj_transform_multiply(var_0, var_4, adj_0, adj_2, adj_3);
    wp::adj_address(var_in_global_pose, var_1, adj_in_global_pose, adj_1, adj_2);
    wp::adj_transform_inverse(var_in_root_tx, adj_in_root_tx, adj_0);
    // adj: out_result[0] = wp.transform_multiply(wp.transform_inverse(in_root_tx), in_global_pose[0])  <L 19>
    // adj: def wp_compute_local_pose(                                                        <L 11>
    return;
}



extern "C" __global__ void blend_pose_kernel_723ef2aa_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::transform_t<wp::float32>> var_in_local_pose0,
    wp::array_t<wp::transform_t<wp::float32>> var_in_local_pose1,
    wp::float32 var_theta,
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
        wp::transform_t<wp::float32>* var_1;
        wp::vec_t<3, wp::float32> var_2;
        wp::transform_t<wp::float32> var_3;
        wp::transform_t<wp::float32>* var_4;
        wp::vec_t<3, wp::float32> var_5;
        wp::transform_t<wp::float32> var_6;
        wp::vec_t<3, wp::float32> var_7;
        wp::transform_t<wp::float32>* var_8;
        wp::quat_t<wp::float32> var_9;
        wp::transform_t<wp::float32> var_10;
        wp::transform_t<wp::float32>* var_11;
        wp::quat_t<wp::float32> var_12;
        wp::transform_t<wp::float32> var_13;
        wp::quat_t<wp::float32> var_14;
        wp::transform_t<wp::float32> var_15;
        //---------
        // forward
        // def blend_pose_kernel(                                                                 <L 128>
        // idx = wp.tid()                                                                         <L 135>
        var_0 = builtin_tid1d();
        // t = wp.lerp(in_local_pose0[idx].p, in_local_pose1[idx].p, theta)                       <L 136>
        var_1 = wp::address(var_in_local_pose0, var_0);
        var_3 = wp::load(var_1);
        var_2 = wp::transform_get_translation(var_3);
        var_4 = wp::address(var_in_local_pose1, var_0);
        var_6 = wp::load(var_4);
        var_5 = wp::transform_get_translation(var_6);
        var_7 = wp::lerp(var_2, var_5, var_theta);
        // q = wp.quat_slerp(in_local_pose0[idx].q, in_local_pose1[idx].q, theta)                 <L 137>
        var_8 = wp::address(var_in_local_pose0, var_0);
        var_10 = wp::load(var_8);
        var_9 = wp::transform_get_rotation(var_10);
        var_11 = wp::address(var_in_local_pose1, var_0);
        var_13 = wp::load(var_11);
        var_12 = wp::transform_get_rotation(var_13);
        var_14 = wp::quat_slerp(var_9, var_12, var_theta);
        // out_result[idx] = wp.transform(t, q)                                                   <L 138>
        var_15 = wp::transform_t<wp::float32>(var_7, var_14);
        wp::array_store(var_out_result, var_0, var_15);
    }
}



extern "C" __global__ void blend_pose_kernel_723ef2aa_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::transform_t<wp::float32>> var_in_local_pose0,
    wp::array_t<wp::transform_t<wp::float32>> var_in_local_pose1,
    wp::float32 var_theta,
    wp::array_t<wp::transform_t<wp::float32>> var_out_result,
    wp::array_t<wp::transform_t<wp::float32>> adj_in_local_pose0,
    wp::array_t<wp::transform_t<wp::float32>> adj_in_local_pose1,
    wp::float32 adj_theta,
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
        wp::transform_t<wp::float32>* var_1;
        wp::vec_t<3, wp::float32> var_2;
        wp::transform_t<wp::float32> var_3;
        wp::transform_t<wp::float32>* var_4;
        wp::vec_t<3, wp::float32> var_5;
        wp::transform_t<wp::float32> var_6;
        wp::vec_t<3, wp::float32> var_7;
        wp::transform_t<wp::float32>* var_8;
        wp::quat_t<wp::float32> var_9;
        wp::transform_t<wp::float32> var_10;
        wp::transform_t<wp::float32>* var_11;
        wp::quat_t<wp::float32> var_12;
        wp::transform_t<wp::float32> var_13;
        wp::quat_t<wp::float32> var_14;
        wp::transform_t<wp::float32> var_15;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::transform_t<wp::float32> adj_1 = {};
        wp::vec_t<3, wp::float32> adj_2 = {};
        wp::transform_t<wp::float32> adj_3 = {};
        wp::transform_t<wp::float32> adj_4 = {};
        wp::vec_t<3, wp::float32> adj_5 = {};
        wp::transform_t<wp::float32> adj_6 = {};
        wp::vec_t<3, wp::float32> adj_7 = {};
        wp::transform_t<wp::float32> adj_8 = {};
        wp::quat_t<wp::float32> adj_9 = {};
        wp::transform_t<wp::float32> adj_10 = {};
        wp::transform_t<wp::float32> adj_11 = {};
        wp::quat_t<wp::float32> adj_12 = {};
        wp::transform_t<wp::float32> adj_13 = {};
        wp::quat_t<wp::float32> adj_14 = {};
        wp::transform_t<wp::float32> adj_15 = {};
        //---------
        // forward
        // def blend_pose_kernel(                                                                 <L 128>
        // idx = wp.tid()                                                                         <L 135>
        var_0 = builtin_tid1d();
        // t = wp.lerp(in_local_pose0[idx].p, in_local_pose1[idx].p, theta)                       <L 136>
        var_1 = wp::address(var_in_local_pose0, var_0);
        var_3 = wp::load(var_1);
        var_2 = wp::transform_get_translation(var_3);
        var_4 = wp::address(var_in_local_pose1, var_0);
        var_6 = wp::load(var_4);
        var_5 = wp::transform_get_translation(var_6);
        var_7 = wp::lerp(var_2, var_5, var_theta);
        // q = wp.quat_slerp(in_local_pose0[idx].q, in_local_pose1[idx].q, theta)                 <L 137>
        var_8 = wp::address(var_in_local_pose0, var_0);
        var_10 = wp::load(var_8);
        var_9 = wp::transform_get_rotation(var_10);
        var_11 = wp::address(var_in_local_pose1, var_0);
        var_13 = wp::load(var_11);
        var_12 = wp::transform_get_rotation(var_13);
        var_14 = wp::quat_slerp(var_9, var_12, var_theta);
        // out_result[idx] = wp.transform(t, q)                                                   <L 138>
        var_15 = wp::transform_t<wp::float32>(var_7, var_14);
        // wp::array_store(var_out_result, var_0, var_15);
        //---------
        // reverse
        wp::adj_array_store(var_out_result, var_0, var_15, adj_out_result, adj_0, adj_15);
        wp::adj_transform_t(var_7, var_14, adj_7, adj_14, adj_15);
        // adj: out_result[idx] = wp.transform(t, q)                                              <L 138>
        wp::adj_quat_slerp(var_9, var_12, var_theta, var_14, adj_9, adj_12, adj_theta, adj_14);
        wp::adj_transform_get_rotation(var_13, adj_11, adj_12);
        wp::adj_address(var_in_local_pose1, var_0, adj_in_local_pose1, adj_0, adj_11);
        wp::adj_transform_get_rotation(var_10, adj_8, adj_9);
        wp::adj_address(var_in_local_pose0, var_0, adj_in_local_pose0, adj_0, adj_8);
        // adj: q = wp.quat_slerp(in_local_pose0[idx].q, in_local_pose1[idx].q, theta)            <L 137>
        wp::adj_lerp(var_2, var_5, var_theta, adj_2, adj_5, adj_theta, adj_7);
        wp::adj_transform_get_translation(var_6, adj_4, adj_5);
        wp::adj_address(var_in_local_pose1, var_0, adj_in_local_pose1, adj_0, adj_4);
        wp::adj_transform_get_translation(var_3, adj_1, adj_2);
        wp::adj_address(var_in_local_pose0, var_0, adj_in_local_pose0, adj_0, adj_1);
        // adj: t = wp.lerp(in_local_pose0[idx].p, in_local_pose1[idx].p, theta)                  <L 136>
        // adj: idx = wp.tid()                                                                    <L 135>
        // adj: def blend_pose_kernel(                                                            <L 128>
        continue;
    }
}



extern "C" __global__ void compute_global_pose_kernel_d101d3f4_cuda_kernel_forward(
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
        //---------
        // forward
        // def compute_global_pose_kernel(                                                        <L 53>
        // wp_compute_global_pose(in_num_joints, in_root_tx, in_parent_indices, in_local_pose, out_result)       <L 61>
        wp_compute_global_pose_0(var_in_num_joints, var_in_root_tx, var_in_parent_indices, var_in_local_pose, var_out_result);
    }
}



extern "C" __global__ void compute_global_pose_kernel_d101d3f4_cuda_kernel_backward(
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
        //---------
        // dual vars
        //---------
        // forward
        // def compute_global_pose_kernel(                                                        <L 53>
        // wp_compute_global_pose(in_num_joints, in_root_tx, in_parent_indices, in_local_pose, out_result)       <L 61>
        wp_compute_global_pose_0(var_in_num_joints, var_in_root_tx, var_in_parent_indices, var_in_local_pose, var_out_result);
        //---------
        // reverse
        adj_wp_compute_global_pose_0(var_in_num_joints, var_in_root_tx, var_in_parent_indices, var_in_local_pose, var_out_result, adj_in_num_joints, adj_in_root_tx, adj_in_parent_indices, adj_in_local_pose, adj_out_result);
        // adj: wp_compute_global_pose(in_num_joints, in_root_tx, in_parent_indices, in_local_pose, out_result)  <L 61>
        // adj: def compute_global_pose_kernel(                                                   <L 53>
        continue;
    }
}



extern "C" __global__ void compute_local_pose_kernel_0ad6fa42_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::int32 var_in_num_joints,
    wp::transform_t<wp::float32> var_in_root_tx,
    wp::array_t<wp::int32> var_in_parent_indices,
    wp::array_t<wp::transform_t<wp::float32>> var_in_global_pose,
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
        //---------
        // forward
        // def compute_local_pose_kernel(                                                         <L 26>
        // wp_compute_local_pose(in_num_joints, in_root_tx, in_parent_indices, in_global_pose, out_result)       <L 34>
        wp_compute_local_pose_0(var_in_num_joints, var_in_root_tx, var_in_parent_indices, var_in_global_pose, var_out_result);
    }
}



extern "C" __global__ void compute_local_pose_kernel_0ad6fa42_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::int32 var_in_num_joints,
    wp::transform_t<wp::float32> var_in_root_tx,
    wp::array_t<wp::int32> var_in_parent_indices,
    wp::array_t<wp::transform_t<wp::float32>> var_in_global_pose,
    wp::array_t<wp::transform_t<wp::float32>> var_out_result,
    wp::int32 adj_in_num_joints,
    wp::transform_t<wp::float32> adj_in_root_tx,
    wp::array_t<wp::int32> adj_in_parent_indices,
    wp::array_t<wp::transform_t<wp::float32>> adj_in_global_pose,
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
        //---------
        // dual vars
        //---------
        // forward
        // def compute_local_pose_kernel(                                                         <L 26>
        // wp_compute_local_pose(in_num_joints, in_root_tx, in_parent_indices, in_global_pose, out_result)       <L 34>
        wp_compute_local_pose_0(var_in_num_joints, var_in_root_tx, var_in_parent_indices, var_in_global_pose, var_out_result);
        //---------
        // reverse
        adj_wp_compute_local_pose_0(var_in_num_joints, var_in_root_tx, var_in_parent_indices, var_in_global_pose, var_out_result, adj_in_num_joints, adj_in_root_tx, adj_in_parent_indices, adj_in_global_pose, adj_out_result);
        // adj: wp_compute_local_pose(in_num_joints, in_root_tx, in_parent_indices, in_global_pose, out_result)  <L 34>
        // adj: def compute_local_pose_kernel(                                                    <L 26>
        continue;
    }
}

