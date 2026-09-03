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



extern "C" __global__ void JointLimitClamper__apply__locals__clamp_to_joint_limits_kernel_abc510a6_cuda_kernel_forward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::float32> var_in_joint_limit_lower,
    wp::array_t<wp::float32> var_in_joint_limit_upper,
    wp::array_t<wp::int32> var_in_dof_to_coord,
    wp::array_t<wp::float32> var_inout_joint_q)
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
        const wp::int32 var_5 = 0;
        bool var_6;
        wp::float32* var_7;
        wp::float32* var_8;
        wp::float32* var_9;
        wp::float32 var_10;
        wp::float32 var_11;
        wp::float32 var_12;
        wp::float32 var_13;
        //---------
        // forward
        // def clamp_to_joint_limits_kernel(                                                      <L 48>
        // env, dof_idx = wp.tid()                                                                <L 54>
        builtin_tid2d(var_0, var_1);
        // coord_idx = in_dof_to_coord[dof_idx]                                                   <L 55>
        var_2 = wp::address(var_in_dof_to_coord, var_1);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // if coord_idx < 0:                                                                      <L 56>
        var_6 = (var_3 < var_5);
        if (var_6) {
            // return                                                                             <L 57>
            continue;
        }
        // inout_joint_q[env, coord_idx] = wp.clamp(                                              <L 59>
        // inout_joint_q[env, coord_idx],                                                         <L 60>
        var_7 = wp::address(var_inout_joint_q, var_0, var_3);
        // in_joint_limit_lower[dof_idx],                                                         <L 61>
        var_8 = wp::address(var_in_joint_limit_lower, var_1);
        // in_joint_limit_upper[dof_idx])                                                         <L 62>
        var_9 = wp::address(var_in_joint_limit_upper, var_1);
        var_11 = wp::load(var_7);
        var_12 = wp::load(var_8);
        var_13 = wp::load(var_9);
        var_10 = wp::clamp(var_11, var_12, var_13);
        // inout_joint_q[env, coord_idx] = wp.clamp(                                              <L 59>
        wp::array_store(var_inout_joint_q, var_0, var_3, var_10);
    }
}



extern "C" __global__ void JointLimitClamper__apply__locals__clamp_to_joint_limits_kernel_abc510a6_cuda_kernel_backward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::float32> var_in_joint_limit_lower,
    wp::array_t<wp::float32> var_in_joint_limit_upper,
    wp::array_t<wp::int32> var_in_dof_to_coord,
    wp::array_t<wp::float32> var_inout_joint_q,
    wp::array_t<wp::float32> adj_in_joint_limit_lower,
    wp::array_t<wp::float32> adj_in_joint_limit_upper,
    wp::array_t<wp::int32> adj_in_dof_to_coord,
    wp::array_t<wp::float32> adj_inout_joint_q)
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
        const wp::int32 var_5 = 0;
        bool var_6;
        wp::float32* var_7;
        wp::float32* var_8;
        wp::float32* var_9;
        wp::float32 var_10;
        wp::float32 var_11;
        wp::float32 var_12;
        wp::float32 var_13;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::int32 adj_2 = {};
        wp::int32 adj_3 = {};
        wp::int32 adj_4 = {};
        wp::int32 adj_5 = {};
        bool adj_6 = {};
        wp::float32 adj_7 = {};
        wp::float32 adj_8 = {};
        wp::float32 adj_9 = {};
        wp::float32 adj_10 = {};
        wp::float32 adj_11 = {};
        wp::float32 adj_12 = {};
        wp::float32 adj_13 = {};
        //---------
        // forward
        // def clamp_to_joint_limits_kernel(                                                      <L 48>
        // env, dof_idx = wp.tid()                                                                <L 54>
        builtin_tid2d(var_0, var_1);
        // coord_idx = in_dof_to_coord[dof_idx]                                                   <L 55>
        var_2 = wp::address(var_in_dof_to_coord, var_1);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // if coord_idx < 0:                                                                      <L 56>
        var_6 = (var_3 < var_5);
        if (var_6) {
            // return                                                                             <L 57>
            goto label0;
        }
        // inout_joint_q[env, coord_idx] = wp.clamp(                                              <L 59>
        // inout_joint_q[env, coord_idx],                                                         <L 60>
        var_7 = wp::address(var_inout_joint_q, var_0, var_3);
        // in_joint_limit_lower[dof_idx],                                                         <L 61>
        var_8 = wp::address(var_in_joint_limit_lower, var_1);
        // in_joint_limit_upper[dof_idx])                                                         <L 62>
        var_9 = wp::address(var_in_joint_limit_upper, var_1);
        var_11 = wp::load(var_7);
        var_12 = wp::load(var_8);
        var_13 = wp::load(var_9);
        var_10 = wp::clamp(var_11, var_12, var_13);
        // inout_joint_q[env, coord_idx] = wp.clamp(                                              <L 59>
        // wp::array_store(var_inout_joint_q, var_0, var_3, var_10);
        //---------
        // reverse
        wp::adj_array_store(var_inout_joint_q, var_0, var_3, var_10, adj_inout_joint_q, adj_0, adj_3, adj_10);
        // adj: inout_joint_q[env, coord_idx] = wp.clamp(                                         <L 59>
        wp::adj_clamp(var_11, var_12, var_13, adj_7, adj_8, adj_9, adj_10);
        wp::adj_address(var_in_joint_limit_upper, var_1, adj_in_joint_limit_upper, adj_1, adj_9);
        // adj: in_joint_limit_upper[dof_idx])                                                    <L 62>
        wp::adj_address(var_in_joint_limit_lower, var_1, adj_in_joint_limit_lower, adj_1, adj_8);
        // adj: in_joint_limit_lower[dof_idx],                                                    <L 61>
        wp::adj_address(var_inout_joint_q, var_0, var_3, adj_inout_joint_q, adj_0, adj_3, adj_7);
        // adj: inout_joint_q[env, coord_idx],                                                    <L 60>
        // adj: inout_joint_q[env, coord_idx] = wp.clamp(                                         <L 59>
        if (var_6) {
            label0:;
            // adj: return                                                                        <L 57>
        }
        // adj: if coord_idx < 0:                                                                 <L 56>
        wp::adj_copy(var_4, adj_2, adj_3);
        wp::adj_address(var_in_dof_to_coord, var_1, adj_in_dof_to_coord, adj_1, adj_2);
        // adj: coord_idx = in_dof_to_coord[dof_idx]                                              <L 55>
        // adj: env, dof_idx = wp.tid()                                                           <L 54>
        // adj: def clamp_to_joint_limits_kernel(                                                 <L 48>
        continue;
    }
}

