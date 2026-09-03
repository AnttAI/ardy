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


// /home/jony/Downloads/soma-retargeter/soma_retargeter/pipelines/ik_objectives.py:11
static CUDA_CALLABLE wp::float32 _wp_smooth_joint_filter_func_0(
    wp::float32 var_x,
    wp::float32 var_lower_limit,
    wp::float32 var_upper_limit,
    wp::float32 var_padding_limit,
    wp::float32 var_m,
    wp::float32 var_p)
{
    //---------
    // primal vars
    wp::float32 var_0;
    const wp::float32 var_1 = 0.5;
    wp::float32 var_2;
    wp::float32 var_3;
    wp::float32 var_4;
    wp::float32 var_5;
    wp::float32 var_6;
    bool var_7;
    bool var_8;
    bool var_9;
    const wp::float32 var_10 = 0.0;
    bool var_11;
    wp::float32 var_12;
    wp::float32 var_13;
    wp::float32 var_14;
    wp::float32 var_15;
    const wp::float32 var_16 = 1.0;
    wp::float32 var_17;
    wp::float32 var_18;
    wp::float32 var_19;
    wp::float32 var_20;
    //---------
    // forward
    // def _wp_smooth_joint_filter_func(                                                      <L 12>
    // c = (lower_limit + upper_limit) * 0.5                                                  <L 20>
    var_0 = wp::add(var_lower_limit, var_upper_limit);
    var_2 = wp::mul(var_0, var_1);
    // lower_limit += (padding_limit - c)                                                     <L 21>
    var_3 = wp::sub(var_padding_limit, var_2);
    var_4 = wp::add(var_lower_limit, var_3);
    // upper_limit -= (padding_limit + c)                                                     <L 22>
    var_5 = wp::add(var_padding_limit, var_2);
    var_6 = wp::sub(var_upper_limit, var_5);
    // if lower_limit < x and x <= upper_limit:                                               <L 23>
    var_8 = (var_4 < var_x);
    var_7 = var_8;
    if (var_7) {
        var_9 = (var_x <= var_6);
        var_7 = var_7 && var_9;
    }
    if (var_7) {
        // return 0.0                                                                         <L 24>
        return var_10;
    }
    // diff = wp.where(x <= lower_limit, lower_limit-x, x-upper_limit) * m                    <L 26>
    var_11 = (var_x <= var_4);
    var_12 = wp::sub(var_4, var_x);
    var_13 = wp::sub(var_x, var_6);
    var_14 = wp::where(var_11, var_12, var_13);
    var_15 = wp::mul(var_14, var_m);
    // return 1.0 - wp.exp(-wp.pow(diff, p))                                                  <L 27>
    var_17 = wp::pow(var_15, var_p);
    var_18 = wp::neg(var_17);
    var_19 = wp::exp(var_18);
    var_20 = wp::sub(var_16, var_19);
    return var_20;
}


// /home/jony/Downloads/soma-retargeter/soma_retargeter/pipelines/ik_objectives.py:11
static CUDA_CALLABLE void adj__wp_smooth_joint_filter_func_0(
    wp::float32 var_x,
    wp::float32 var_lower_limit,
    wp::float32 var_upper_limit,
    wp::float32 var_padding_limit,
    wp::float32 var_m,
    wp::float32 var_p,
    wp::float32 & adj_x,
    wp::float32 & adj_lower_limit,
    wp::float32 & adj_upper_limit,
    wp::float32 & adj_padding_limit,
    wp::float32 & adj_m,
    wp::float32 & adj_p,
    wp::float32 & adj_ret)
{
    //---------
    // primal vars
    wp::float32 var_0;
    const wp::float32 var_1 = 0.5;
    wp::float32 var_2;
    wp::float32 var_3;
    wp::float32 var_4;
    wp::float32 var_5;
    wp::float32 var_6;
    bool var_7;
    bool var_8;
    bool var_9;
    const wp::float32 var_10 = 0.0;
    bool var_11;
    wp::float32 var_12;
    wp::float32 var_13;
    wp::float32 var_14;
    wp::float32 var_15;
    const wp::float32 var_16 = 1.0;
    wp::float32 var_17;
    wp::float32 var_18;
    wp::float32 var_19;
    wp::float32 var_20;
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
    bool adj_8 = {};
    bool adj_9 = {};
    wp::float32 adj_10 = {};
    bool adj_11 = {};
    wp::float32 adj_12 = {};
    wp::float32 adj_13 = {};
    wp::float32 adj_14 = {};
    wp::float32 adj_15 = {};
    wp::float32 adj_16 = {};
    wp::float32 adj_17 = {};
    wp::float32 adj_18 = {};
    wp::float32 adj_19 = {};
    wp::float32 adj_20 = {};
    //---------
    // forward
    // def _wp_smooth_joint_filter_func(                                                      <L 12>
    // c = (lower_limit + upper_limit) * 0.5                                                  <L 20>
    var_0 = wp::add(var_lower_limit, var_upper_limit);
    var_2 = wp::mul(var_0, var_1);
    // lower_limit += (padding_limit - c)                                                     <L 21>
    var_3 = wp::sub(var_padding_limit, var_2);
    var_4 = wp::add(var_lower_limit, var_3);
    // upper_limit -= (padding_limit + c)                                                     <L 22>
    var_5 = wp::add(var_padding_limit, var_2);
    var_6 = wp::sub(var_upper_limit, var_5);
    // if lower_limit < x and x <= upper_limit:                                               <L 23>
    var_8 = (var_4 < var_x);
    var_7 = var_8;
    if (var_7) {
        var_9 = (var_x <= var_6);
        var_7 = var_7 && var_9;
    }
    if (var_7) {
        // return 0.0                                                                         <L 24>
        goto label0;
    }
    // diff = wp.where(x <= lower_limit, lower_limit-x, x-upper_limit) * m                    <L 26>
    var_11 = (var_x <= var_4);
    var_12 = wp::sub(var_4, var_x);
    var_13 = wp::sub(var_x, var_6);
    var_14 = wp::where(var_11, var_12, var_13);
    var_15 = wp::mul(var_14, var_m);
    // return 1.0 - wp.exp(-wp.pow(diff, p))                                                  <L 27>
    var_17 = wp::pow(var_15, var_p);
    var_18 = wp::neg(var_17);
    var_19 = wp::exp(var_18);
    var_20 = wp::sub(var_16, var_19);
    goto label1;
    //---------
    // reverse
    label1:;
    adj_20 += adj_ret;
    wp::adj_sub(var_16, var_19, adj_16, adj_19, adj_20);
    wp::adj_exp(var_18, var_19, adj_18, adj_19);
    wp::adj_neg(var_17, adj_17, adj_18);
    wp::adj_pow(var_15, var_p, var_17, adj_15, adj_p, adj_17);
    // adj: return 1.0 - wp.exp(-wp.pow(diff, p))                                             <L 27>
    wp::adj_mul(var_14, var_m, adj_14, adj_m, adj_15);
    wp::adj_where(var_11, var_12, var_13, adj_11, adj_12, adj_13, adj_14);
    wp::adj_sub(var_x, var_6, adj_x, adj_6, adj_13);
    wp::adj_sub(var_4, var_x, adj_4, adj_x, adj_12);
    // adj: diff = wp.where(x <= lower_limit, lower_limit-x, x-upper_limit) * m               <L 26>
    if (var_7) {
        label0:;
        adj_10 += adj_ret;
        // adj: return 0.0                                                                    <L 24>
    }
    if (var_7) {
    }
    // adj: if lower_limit < x and x <= upper_limit:                                          <L 23>
    wp::adj_sub(var_upper_limit, var_5, adj_upper_limit, adj_5, adj_6);
    wp::adj_add(var_padding_limit, var_2, adj_padding_limit, adj_2, adj_5);
    // adj: upper_limit -= (padding_limit + c)                                                <L 22>
    wp::adj_add(var_lower_limit, var_3, adj_lower_limit, adj_3, adj_4);
    wp::adj_sub(var_padding_limit, var_2, adj_padding_limit, adj_2, adj_3);
    // adj: lower_limit += (padding_limit - c)                                                <L 21>
    wp::adj_mul(var_0, var_1, adj_0, adj_1, adj_2);
    wp::adj_add(var_lower_limit, var_upper_limit, adj_lower_limit, adj_upper_limit, adj_0);
    // adj: c = (lower_limit + upper_limit) * 0.5                                             <L 20>
    // adj: def _wp_smooth_joint_filter_func(                                                 <L 12>
    return;
}



extern "C" __global__ void _update_weight_ec61c9a3_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::float32 var_in_value,
    wp::array_t<wp::float32> var_out_weight)
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
        const wp::int32 var_0 = 0;
        //---------
        // forward
        // def _update_weight(                                                                    <L 64>
        // out_weight[0] = in_value                                                               <L 68>
        wp::array_store(var_out_weight, var_0, var_in_value);
    }
}



extern "C" __global__ void _update_weight_ec61c9a3_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::float32 var_in_value,
    wp::array_t<wp::float32> var_out_weight,
    wp::float32 adj_in_value,
    wp::array_t<wp::float32> adj_out_weight)
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
        const wp::int32 var_0 = 0;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        //---------
        // forward
        // def _update_weight(                                                                    <L 64>
        // out_weight[0] = in_value                                                               <L 68>
        // wp::array_store(var_out_weight, var_0, var_in_value);
        //---------
        // reverse
        wp::adj_array_store(var_out_weight, var_0, var_in_value, adj_out_weight, adj_0, adj_in_value);
        // adj: out_weight[0] = in_value                                                          <L 68>
        // adj: def _update_weight(                                                               <L 64>
        continue;
    }
}



extern "C" __global__ void _smooth_joint_filter_jac_analytic_d5e133ee_cuda_kernel_forward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::int32> var_dof_to_coord,
    wp::array_t<wp::float32> var_coord_masks,
    wp::int32 var_n_dofs,
    wp::int32 var_start_idx,
    wp::array_t<wp::float32> var_weight,
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
        wp::int32* var_2;
        wp::int32 var_3;
        wp::int32 var_4;
        wp::float32* var_5;
        wp::float32 var_6;
        wp::float32 var_7;
        const wp::int32 var_8 = 0;
        bool var_9;
        const wp::int32 var_10 = 0;
        wp::float32* var_11;
        wp::float32 var_12;
        wp::float32 var_13;
        wp::int32 var_14;
        //---------
        // forward
        // def _smooth_joint_filter_jac_analytic(                                                 <L 119>
        // problem, dof_idx = wp.tid()                                                            <L 128>
        builtin_tid2d(var_0, var_1);
        // coord_idx = dof_to_coord[dof_idx]                                                      <L 129>
        var_2 = wp::address(var_dof_to_coord, var_1);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // mask = coord_masks[coord_idx]                                                          <L 130>
        var_5 = wp::address(var_coord_masks, var_3);
        var_7 = wp::load(var_5);
        var_6 = wp::copy(var_7);
        // if coord_idx < 0:                                                                      <L 132>
        var_9 = (var_3 < var_8);
        if (var_9) {
            // return                                                                             <L 133>
            continue;
        }
        // jacobian[problem, start_idx + dof_idx, dof_idx] = weight[0] * mask                     <L 136>
        var_11 = wp::address(var_weight, var_10);
        var_13 = wp::load(var_11);
        var_12 = wp::mul(var_13, var_6);
        var_14 = wp::add(var_start_idx, var_1);
        wp::array_store(var_jacobian, var_0, var_14, var_1, var_12);
    }
}



extern "C" __global__ void _smooth_joint_filter_jac_analytic_d5e133ee_cuda_kernel_backward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::int32> var_dof_to_coord,
    wp::array_t<wp::float32> var_coord_masks,
    wp::int32 var_n_dofs,
    wp::int32 var_start_idx,
    wp::array_t<wp::float32> var_weight,
    wp::array_t<wp::float32> var_jacobian,
    wp::array_t<wp::int32> adj_dof_to_coord,
    wp::array_t<wp::float32> adj_coord_masks,
    wp::int32 adj_n_dofs,
    wp::int32 adj_start_idx,
    wp::array_t<wp::float32> adj_weight,
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
        wp::int32* var_2;
        wp::int32 var_3;
        wp::int32 var_4;
        wp::float32* var_5;
        wp::float32 var_6;
        wp::float32 var_7;
        const wp::int32 var_8 = 0;
        bool var_9;
        const wp::int32 var_10 = 0;
        wp::float32* var_11;
        wp::float32 var_12;
        wp::float32 var_13;
        wp::int32 var_14;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::int32 adj_2 = {};
        wp::int32 adj_3 = {};
        wp::int32 adj_4 = {};
        wp::float32 adj_5 = {};
        wp::float32 adj_6 = {};
        wp::float32 adj_7 = {};
        wp::int32 adj_8 = {};
        bool adj_9 = {};
        wp::int32 adj_10 = {};
        wp::float32 adj_11 = {};
        wp::float32 adj_12 = {};
        wp::float32 adj_13 = {};
        wp::int32 adj_14 = {};
        //---------
        // forward
        // def _smooth_joint_filter_jac_analytic(                                                 <L 119>
        // problem, dof_idx = wp.tid()                                                            <L 128>
        builtin_tid2d(var_0, var_1);
        // coord_idx = dof_to_coord[dof_idx]                                                      <L 129>
        var_2 = wp::address(var_dof_to_coord, var_1);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // mask = coord_masks[coord_idx]                                                          <L 130>
        var_5 = wp::address(var_coord_masks, var_3);
        var_7 = wp::load(var_5);
        var_6 = wp::copy(var_7);
        // if coord_idx < 0:                                                                      <L 132>
        var_9 = (var_3 < var_8);
        if (var_9) {
            // return                                                                             <L 133>
            goto label0;
        }
        // jacobian[problem, start_idx + dof_idx, dof_idx] = weight[0] * mask                     <L 136>
        var_11 = wp::address(var_weight, var_10);
        var_13 = wp::load(var_11);
        var_12 = wp::mul(var_13, var_6);
        var_14 = wp::add(var_start_idx, var_1);
        // wp::array_store(var_jacobian, var_0, var_14, var_1, var_12);
        //---------
        // reverse
        wp::adj_array_store(var_jacobian, var_0, var_14, var_1, var_12, adj_jacobian, adj_0, adj_14, adj_1, adj_12);
        wp::adj_add(var_start_idx, var_1, adj_start_idx, adj_1, adj_14);
        wp::adj_mul(var_13, var_6, adj_11, adj_6, adj_12);
        wp::adj_address(var_weight, var_10, adj_weight, adj_10, adj_11);
        // adj: jacobian[problem, start_idx + dof_idx, dof_idx] = weight[0] * mask                <L 136>
        if (var_9) {
            label0:;
            // adj: return                                                                        <L 133>
        }
        // adj: if coord_idx < 0:                                                                 <L 132>
        wp::adj_copy(var_7, adj_5, adj_6);
        wp::adj_address(var_coord_masks, var_3, adj_coord_masks, adj_3, adj_5);
        // adj: mask = coord_masks[coord_idx]                                                     <L 130>
        wp::adj_copy(var_4, adj_2, adj_3);
        wp::adj_address(var_dof_to_coord, var_1, adj_dof_to_coord, adj_1, adj_2);
        // adj: coord_idx = dof_to_coord[dof_idx]                                                 <L 129>
        // adj: problem, dof_idx = wp.tid()                                                       <L 128>
        // adj: def _smooth_joint_filter_jac_analytic(                                            <L 119>
        continue;
    }
}



extern "C" __global__ void _joint_target_residuals_d644ae36_cuda_kernel_forward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::float32> var_joint_q,
    wp::array_t<wp::float32> var_coord_targets,
    wp::array_t<wp::float32> var_coord_masks,
    wp::array_t<wp::float32> var_weight,
    wp::int32 var_start_idx,
    wp::array_t<wp::float32> var_residuals)
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
        wp::float32* var_2;
        wp::float32* var_3;
        wp::float32 var_4;
        wp::float32 var_5;
        wp::float32 var_6;
        wp::float32* var_7;
        wp::float32 var_8;
        wp::float32 var_9;
        const wp::int32 var_10 = 0;
        wp::float32* var_11;
        wp::float32 var_12;
        wp::float32 var_13;
        wp::int32 var_14;
        //---------
        // forward
        // def _joint_target_residuals(                                                           <L 72>
        // problem, coord_idx = wp.tid()                                                          <L 81>
        builtin_tid2d(var_0, var_1);
        // residuals[problem, start_idx + coord_idx] = (                                          <L 82>
        // joint_q[problem, coord_idx] - coord_targets[coord_idx]                                 <L 83>
        var_2 = wp::address(var_joint_q, var_0, var_1);
        var_3 = wp::address(var_coord_targets, var_1);
        var_5 = wp::load(var_2);
        var_6 = wp::load(var_3);
        var_4 = wp::sub(var_5, var_6);
        // ) * coord_masks[coord_idx] * weight[0]                                                 <L 84>
        var_7 = wp::address(var_coord_masks, var_1);
        var_9 = wp::load(var_7);
        var_8 = wp::mul(var_4, var_9);
        var_11 = wp::address(var_weight, var_10);
        var_13 = wp::load(var_11);
        var_12 = wp::mul(var_8, var_13);
        // residuals[problem, start_idx + coord_idx] = (                                          <L 82>
        var_14 = wp::add(var_start_idx, var_1);
        wp::array_store(var_residuals, var_0, var_14, var_12);
    }
}



extern "C" __global__ void _joint_target_residuals_d644ae36_cuda_kernel_backward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::float32> var_joint_q,
    wp::array_t<wp::float32> var_coord_targets,
    wp::array_t<wp::float32> var_coord_masks,
    wp::array_t<wp::float32> var_weight,
    wp::int32 var_start_idx,
    wp::array_t<wp::float32> var_residuals,
    wp::array_t<wp::float32> adj_joint_q,
    wp::array_t<wp::float32> adj_coord_targets,
    wp::array_t<wp::float32> adj_coord_masks,
    wp::array_t<wp::float32> adj_weight,
    wp::int32 adj_start_idx,
    wp::array_t<wp::float32> adj_residuals)
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
        wp::float32* var_2;
        wp::float32* var_3;
        wp::float32 var_4;
        wp::float32 var_5;
        wp::float32 var_6;
        wp::float32* var_7;
        wp::float32 var_8;
        wp::float32 var_9;
        const wp::int32 var_10 = 0;
        wp::float32* var_11;
        wp::float32 var_12;
        wp::float32 var_13;
        wp::int32 var_14;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::float32 adj_2 = {};
        wp::float32 adj_3 = {};
        wp::float32 adj_4 = {};
        wp::float32 adj_5 = {};
        wp::float32 adj_6 = {};
        wp::float32 adj_7 = {};
        wp::float32 adj_8 = {};
        wp::float32 adj_9 = {};
        wp::int32 adj_10 = {};
        wp::float32 adj_11 = {};
        wp::float32 adj_12 = {};
        wp::float32 adj_13 = {};
        wp::int32 adj_14 = {};
        //---------
        // forward
        // def _joint_target_residuals(                                                           <L 72>
        // problem, coord_idx = wp.tid()                                                          <L 81>
        builtin_tid2d(var_0, var_1);
        // residuals[problem, start_idx + coord_idx] = (                                          <L 82>
        // joint_q[problem, coord_idx] - coord_targets[coord_idx]                                 <L 83>
        var_2 = wp::address(var_joint_q, var_0, var_1);
        var_3 = wp::address(var_coord_targets, var_1);
        var_5 = wp::load(var_2);
        var_6 = wp::load(var_3);
        var_4 = wp::sub(var_5, var_6);
        // ) * coord_masks[coord_idx] * weight[0]                                                 <L 84>
        var_7 = wp::address(var_coord_masks, var_1);
        var_9 = wp::load(var_7);
        var_8 = wp::mul(var_4, var_9);
        var_11 = wp::address(var_weight, var_10);
        var_13 = wp::load(var_11);
        var_12 = wp::mul(var_8, var_13);
        // residuals[problem, start_idx + coord_idx] = (                                          <L 82>
        var_14 = wp::add(var_start_idx, var_1);
        // wp::array_store(var_residuals, var_0, var_14, var_12);
        //---------
        // reverse
        wp::adj_array_store(var_residuals, var_0, var_14, var_12, adj_residuals, adj_0, adj_14, adj_12);
        wp::adj_add(var_start_idx, var_1, adj_start_idx, adj_1, adj_14);
        // adj: residuals[problem, start_idx + coord_idx] = (                                     <L 82>
        wp::adj_mul(var_8, var_13, adj_8, adj_11, adj_12);
        wp::adj_address(var_weight, var_10, adj_weight, adj_10, adj_11);
        wp::adj_mul(var_4, var_9, adj_4, adj_7, adj_8);
        wp::adj_address(var_coord_masks, var_1, adj_coord_masks, adj_1, adj_7);
        // adj: ) * coord_masks[coord_idx] * weight[0]                                            <L 84>
        wp::adj_sub(var_5, var_6, adj_2, adj_3, adj_4);
        wp::adj_address(var_coord_targets, var_1, adj_coord_targets, adj_1, adj_3);
        wp::adj_address(var_joint_q, var_0, var_1, adj_joint_q, adj_0, adj_1, adj_2);
        // adj: joint_q[problem, coord_idx] - coord_targets[coord_idx]                            <L 83>
        // adj: residuals[problem, start_idx + coord_idx] = (                                     <L 82>
        // adj: problem, coord_idx = wp.tid()                                                     <L 81>
        // adj: def _joint_target_residuals(                                                      <L 72>
        continue;
    }
}



extern "C" __global__ void _smooth_joint_filter_residuals_24fd4beb_cuda_kernel_forward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::float32> var_joint_q,
    wp::array_t<wp::int32> var_dof_to_coord,
    wp::array_t<wp::float32> var_joint_limit_lower,
    wp::array_t<wp::float32> var_joint_limit_upper,
    wp::array_t<wp::float32> var_coord_masks,
    wp::array_t<wp::float32> var_weight,
    wp::int32 var_start_idx,
    wp::array_t<wp::float32> var_residuals)
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
        wp::float32* var_5;
        wp::float32 var_6;
        wp::float32 var_7;
        const wp::int32 var_8 = 0;
        bool var_9;
        const wp::float32 var_10 = 0.0;
        bool var_11;
        wp::float32* var_12;
        wp::float32 var_13;
        wp::float32 var_14;
        wp::float32* var_15;
        wp::float32 var_16;
        wp::float32 var_17;
        wp::float32 var_18;
        const wp::float32 var_19 = 0.5;
        wp::float32 var_20;
        wp::float32* var_21;
        wp::float32 var_22;
        wp::float32 var_23;
        wp::float32 var_24;
        const wp::float32 var_25 = 1.02;
        const wp::float32 var_26 = 1.0;
        const wp::float32 var_27 = 6.5;
        wp::float32 var_28;
        wp::float32 var_29;
        const wp::int32 var_30 = 0;
        wp::float32* var_31;
        wp::float32 var_32;
        wp::float32 var_33;
        wp::float32 var_34;
        wp::int32 var_35;
        const wp::float32 var_36 = 0.0;
        wp::int32 var_37;
        //---------
        // forward
        // def _smooth_joint_filter_residuals(                                                    <L 31>
        // problem, dof_idx = wp.tid()                                                            <L 42>
        builtin_tid2d(var_0, var_1);
        // coord_idx = dof_to_coord[dof_idx]                                                      <L 43>
        var_2 = wp::address(var_dof_to_coord, var_1);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // mask = coord_masks[coord_idx]                                                          <L 44>
        var_5 = wp::address(var_coord_masks, var_3);
        var_7 = wp::load(var_5);
        var_6 = wp::copy(var_7);
        // if coord_idx < 0:                                                                      <L 46>
        var_9 = (var_3 < var_8);
        if (var_9) {
            // return                                                                             <L 47>
            continue;
        }
        // if mask > 0.0:                                                                         <L 49>
        var_11 = (var_6 > var_10);
        if (var_11) {
            // lower = joint_limit_lower[dof_idx]                                                 <L 50>
            var_12 = wp::address(var_joint_limit_lower, var_1);
            var_14 = wp::load(var_12);
            var_13 = wp::copy(var_14);
            // upper = joint_limit_upper[dof_idx]                                                 <L 51>
            var_15 = wp::address(var_joint_limit_upper, var_1);
            var_17 = wp::load(var_15);
            var_16 = wp::copy(var_17);
            // c = (lower + upper) * 0.5                                                          <L 52>
            var_18 = wp::add(var_13, var_16);
            var_20 = wp::mul(var_18, var_19);
            // q = joint_q[problem, coord_idx]                                                    <L 54>
            var_21 = wp::address(var_joint_q, var_0, var_3);
            var_23 = wp::load(var_21);
            var_22 = wp::copy(var_23);
            // error = (q - c)                                                                    <L 55>
            var_24 = wp::sub(var_22, var_20);
            // smoother = _wp_smooth_joint_filter_func(error, lower, upper, 1.02, 1.0, 6.5)       <L 57>
            var_28 = _wp_smooth_joint_filter_func_0(var_24, var_13, var_16, var_25, var_26, var_27);
            // residuals[problem, start_idx + dof_idx] = error * smoother * weight[0] * mask       <L 58>
            var_29 = wp::mul(var_24, var_28);
            var_31 = wp::address(var_weight, var_30);
            var_33 = wp::load(var_31);
            var_32 = wp::mul(var_29, var_33);
            var_34 = wp::mul(var_32, var_6);
            var_35 = wp::add(var_start_idx, var_1);
            wp::array_store(var_residuals, var_0, var_35, var_34);
        }
        if (!var_11) {
            // residuals[problem, start_idx + dof_idx] = 0.0                                      <L 60>
            var_37 = wp::add(var_start_idx, var_1);
            wp::array_store(var_residuals, var_0, var_37, var_36);
        }
    }
}



extern "C" __global__ void _smooth_joint_filter_residuals_24fd4beb_cuda_kernel_backward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::float32> var_joint_q,
    wp::array_t<wp::int32> var_dof_to_coord,
    wp::array_t<wp::float32> var_joint_limit_lower,
    wp::array_t<wp::float32> var_joint_limit_upper,
    wp::array_t<wp::float32> var_coord_masks,
    wp::array_t<wp::float32> var_weight,
    wp::int32 var_start_idx,
    wp::array_t<wp::float32> var_residuals,
    wp::array_t<wp::float32> adj_joint_q,
    wp::array_t<wp::int32> adj_dof_to_coord,
    wp::array_t<wp::float32> adj_joint_limit_lower,
    wp::array_t<wp::float32> adj_joint_limit_upper,
    wp::array_t<wp::float32> adj_coord_masks,
    wp::array_t<wp::float32> adj_weight,
    wp::int32 adj_start_idx,
    wp::array_t<wp::float32> adj_residuals)
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
        wp::float32* var_5;
        wp::float32 var_6;
        wp::float32 var_7;
        const wp::int32 var_8 = 0;
        bool var_9;
        const wp::float32 var_10 = 0.0;
        bool var_11;
        wp::float32* var_12;
        wp::float32 var_13;
        wp::float32 var_14;
        wp::float32* var_15;
        wp::float32 var_16;
        wp::float32 var_17;
        wp::float32 var_18;
        const wp::float32 var_19 = 0.5;
        wp::float32 var_20;
        wp::float32* var_21;
        wp::float32 var_22;
        wp::float32 var_23;
        wp::float32 var_24;
        const wp::float32 var_25 = 1.02;
        const wp::float32 var_26 = 1.0;
        const wp::float32 var_27 = 6.5;
        wp::float32 var_28;
        wp::float32 var_29;
        const wp::int32 var_30 = 0;
        wp::float32* var_31;
        wp::float32 var_32;
        wp::float32 var_33;
        wp::float32 var_34;
        wp::int32 var_35;
        const wp::float32 var_36 = 0.0;
        wp::int32 var_37;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::int32 adj_2 = {};
        wp::int32 adj_3 = {};
        wp::int32 adj_4 = {};
        wp::float32 adj_5 = {};
        wp::float32 adj_6 = {};
        wp::float32 adj_7 = {};
        wp::int32 adj_8 = {};
        bool adj_9 = {};
        wp::float32 adj_10 = {};
        bool adj_11 = {};
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
        wp::float32 adj_22 = {};
        wp::float32 adj_23 = {};
        wp::float32 adj_24 = {};
        wp::float32 adj_25 = {};
        wp::float32 adj_26 = {};
        wp::float32 adj_27 = {};
        wp::float32 adj_28 = {};
        wp::float32 adj_29 = {};
        wp::int32 adj_30 = {};
        wp::float32 adj_31 = {};
        wp::float32 adj_32 = {};
        wp::float32 adj_33 = {};
        wp::float32 adj_34 = {};
        wp::int32 adj_35 = {};
        wp::float32 adj_36 = {};
        wp::int32 adj_37 = {};
        //---------
        // forward
        // def _smooth_joint_filter_residuals(                                                    <L 31>
        // problem, dof_idx = wp.tid()                                                            <L 42>
        builtin_tid2d(var_0, var_1);
        // coord_idx = dof_to_coord[dof_idx]                                                      <L 43>
        var_2 = wp::address(var_dof_to_coord, var_1);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // mask = coord_masks[coord_idx]                                                          <L 44>
        var_5 = wp::address(var_coord_masks, var_3);
        var_7 = wp::load(var_5);
        var_6 = wp::copy(var_7);
        // if coord_idx < 0:                                                                      <L 46>
        var_9 = (var_3 < var_8);
        if (var_9) {
            // return                                                                             <L 47>
            goto label0;
        }
        // if mask > 0.0:                                                                         <L 49>
        var_11 = (var_6 > var_10);
        if (var_11) {
            // lower = joint_limit_lower[dof_idx]                                                 <L 50>
            var_12 = wp::address(var_joint_limit_lower, var_1);
            var_14 = wp::load(var_12);
            var_13 = wp::copy(var_14);
            // upper = joint_limit_upper[dof_idx]                                                 <L 51>
            var_15 = wp::address(var_joint_limit_upper, var_1);
            var_17 = wp::load(var_15);
            var_16 = wp::copy(var_17);
            // c = (lower + upper) * 0.5                                                          <L 52>
            var_18 = wp::add(var_13, var_16);
            var_20 = wp::mul(var_18, var_19);
            // q = joint_q[problem, coord_idx]                                                    <L 54>
            var_21 = wp::address(var_joint_q, var_0, var_3);
            var_23 = wp::load(var_21);
            var_22 = wp::copy(var_23);
            // error = (q - c)                                                                    <L 55>
            var_24 = wp::sub(var_22, var_20);
            // smoother = _wp_smooth_joint_filter_func(error, lower, upper, 1.02, 1.0, 6.5)       <L 57>
            var_28 = _wp_smooth_joint_filter_func_0(var_24, var_13, var_16, var_25, var_26, var_27);
            // residuals[problem, start_idx + dof_idx] = error * smoother * weight[0] * mask       <L 58>
            var_29 = wp::mul(var_24, var_28);
            var_31 = wp::address(var_weight, var_30);
            var_33 = wp::load(var_31);
            var_32 = wp::mul(var_29, var_33);
            var_34 = wp::mul(var_32, var_6);
            var_35 = wp::add(var_start_idx, var_1);
            // wp::array_store(var_residuals, var_0, var_35, var_34);
        }
        if (!var_11) {
            // residuals[problem, start_idx + dof_idx] = 0.0                                      <L 60>
            var_37 = wp::add(var_start_idx, var_1);
            // wp::array_store(var_residuals, var_0, var_37, var_36);
        }
        //---------
        // reverse
        if (!var_11) {
            wp::adj_array_store(var_residuals, var_0, var_37, var_36, adj_residuals, adj_0, adj_37, adj_36);
            wp::adj_add(var_start_idx, var_1, adj_start_idx, adj_1, adj_37);
            // adj: residuals[problem, start_idx + dof_idx] = 0.0                                 <L 60>
        }
        if (var_11) {
            wp::adj_array_store(var_residuals, var_0, var_35, var_34, adj_residuals, adj_0, adj_35, adj_34);
            wp::adj_add(var_start_idx, var_1, adj_start_idx, adj_1, adj_35);
            wp::adj_mul(var_32, var_6, adj_32, adj_6, adj_34);
            wp::adj_mul(var_29, var_33, adj_29, adj_31, adj_32);
            wp::adj_address(var_weight, var_30, adj_weight, adj_30, adj_31);
            wp::adj_mul(var_24, var_28, adj_24, adj_28, adj_29);
            // adj: residuals[problem, start_idx + dof_idx] = error * smoother * weight[0] * mask  <L 58>
            adj__wp_smooth_joint_filter_func_0(var_24, var_13, var_16, var_25, var_26, var_27, adj_24, adj_13, adj_16, adj_25, adj_26, adj_27, adj_28);
            // adj: smoother = _wp_smooth_joint_filter_func(error, lower, upper, 1.02, 1.0, 6.5)  <L 57>
            wp::adj_sub(var_22, var_20, adj_22, adj_20, adj_24);
            // adj: error = (q - c)                                                               <L 55>
            wp::adj_copy(var_23, adj_21, adj_22);
            wp::adj_address(var_joint_q, var_0, var_3, adj_joint_q, adj_0, adj_3, adj_21);
            // adj: q = joint_q[problem, coord_idx]                                               <L 54>
            wp::adj_mul(var_18, var_19, adj_18, adj_19, adj_20);
            wp::adj_add(var_13, var_16, adj_13, adj_16, adj_18);
            // adj: c = (lower + upper) * 0.5                                                     <L 52>
            wp::adj_copy(var_17, adj_15, adj_16);
            wp::adj_address(var_joint_limit_upper, var_1, adj_joint_limit_upper, adj_1, adj_15);
            // adj: upper = joint_limit_upper[dof_idx]                                            <L 51>
            wp::adj_copy(var_14, adj_12, adj_13);
            wp::adj_address(var_joint_limit_lower, var_1, adj_joint_limit_lower, adj_1, adj_12);
            // adj: lower = joint_limit_lower[dof_idx]                                            <L 50>
        }
        // adj: if mask > 0.0:                                                                    <L 49>
        if (var_9) {
            label0:;
            // adj: return                                                                        <L 47>
        }
        // adj: if coord_idx < 0:                                                                 <L 46>
        wp::adj_copy(var_7, adj_5, adj_6);
        wp::adj_address(var_coord_masks, var_3, adj_coord_masks, adj_3, adj_5);
        // adj: mask = coord_masks[coord_idx]                                                     <L 44>
        wp::adj_copy(var_4, adj_2, adj_3);
        wp::adj_address(var_dof_to_coord, var_1, adj_dof_to_coord, adj_1, adj_2);
        // adj: coord_idx = dof_to_coord[dof_idx]                                                 <L 43>
        // adj: problem, dof_idx = wp.tid()                                                       <L 42>
        // adj: def _smooth_joint_filter_residuals(                                               <L 31>
        continue;
    }
}



extern "C" __global__ void _temporal_joint_target_residuals_c01e4b36_cuda_kernel_forward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::float32> var_joint_q,
    wp::array_t<wp::float32> var_coord_targets,
    wp::array_t<wp::float32> var_coord_masks,
    wp::array_t<wp::float32> var_weight,
    wp::int32 var_start_idx,
    wp::array_t<wp::float32> var_residuals)
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
        wp::float32* var_2;
        wp::float32* var_3;
        wp::float32 var_4;
        wp::float32 var_5;
        wp::float32 var_6;
        wp::float32* var_7;
        wp::float32 var_8;
        wp::float32 var_9;
        const wp::int32 var_10 = 0;
        wp::float32* var_11;
        wp::float32 var_12;
        wp::float32 var_13;
        wp::int32 var_14;
        //---------
        // forward
        // def _temporal_joint_target_residuals(                                                  <L 88>
        // problem, coord_idx = wp.tid()                                                          <L 97>
        builtin_tid2d(var_0, var_1);
        // residuals[problem, start_idx + coord_idx] = (                                          <L 98>
        // joint_q[problem, coord_idx] - coord_targets[problem, coord_idx]                        <L 99>
        var_2 = wp::address(var_joint_q, var_0, var_1);
        var_3 = wp::address(var_coord_targets, var_0, var_1);
        var_5 = wp::load(var_2);
        var_6 = wp::load(var_3);
        var_4 = wp::sub(var_5, var_6);
        // ) * coord_masks[coord_idx] * weight[0]                                                 <L 100>
        var_7 = wp::address(var_coord_masks, var_1);
        var_9 = wp::load(var_7);
        var_8 = wp::mul(var_4, var_9);
        var_11 = wp::address(var_weight, var_10);
        var_13 = wp::load(var_11);
        var_12 = wp::mul(var_8, var_13);
        // residuals[problem, start_idx + coord_idx] = (                                          <L 98>
        var_14 = wp::add(var_start_idx, var_1);
        wp::array_store(var_residuals, var_0, var_14, var_12);
    }
}



extern "C" __global__ void _temporal_joint_target_residuals_c01e4b36_cuda_kernel_backward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::float32> var_joint_q,
    wp::array_t<wp::float32> var_coord_targets,
    wp::array_t<wp::float32> var_coord_masks,
    wp::array_t<wp::float32> var_weight,
    wp::int32 var_start_idx,
    wp::array_t<wp::float32> var_residuals,
    wp::array_t<wp::float32> adj_joint_q,
    wp::array_t<wp::float32> adj_coord_targets,
    wp::array_t<wp::float32> adj_coord_masks,
    wp::array_t<wp::float32> adj_weight,
    wp::int32 adj_start_idx,
    wp::array_t<wp::float32> adj_residuals)
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
        wp::float32* var_2;
        wp::float32* var_3;
        wp::float32 var_4;
        wp::float32 var_5;
        wp::float32 var_6;
        wp::float32* var_7;
        wp::float32 var_8;
        wp::float32 var_9;
        const wp::int32 var_10 = 0;
        wp::float32* var_11;
        wp::float32 var_12;
        wp::float32 var_13;
        wp::int32 var_14;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::float32 adj_2 = {};
        wp::float32 adj_3 = {};
        wp::float32 adj_4 = {};
        wp::float32 adj_5 = {};
        wp::float32 adj_6 = {};
        wp::float32 adj_7 = {};
        wp::float32 adj_8 = {};
        wp::float32 adj_9 = {};
        wp::int32 adj_10 = {};
        wp::float32 adj_11 = {};
        wp::float32 adj_12 = {};
        wp::float32 adj_13 = {};
        wp::int32 adj_14 = {};
        //---------
        // forward
        // def _temporal_joint_target_residuals(                                                  <L 88>
        // problem, coord_idx = wp.tid()                                                          <L 97>
        builtin_tid2d(var_0, var_1);
        // residuals[problem, start_idx + coord_idx] = (                                          <L 98>
        // joint_q[problem, coord_idx] - coord_targets[problem, coord_idx]                        <L 99>
        var_2 = wp::address(var_joint_q, var_0, var_1);
        var_3 = wp::address(var_coord_targets, var_0, var_1);
        var_5 = wp::load(var_2);
        var_6 = wp::load(var_3);
        var_4 = wp::sub(var_5, var_6);
        // ) * coord_masks[coord_idx] * weight[0]                                                 <L 100>
        var_7 = wp::address(var_coord_masks, var_1);
        var_9 = wp::load(var_7);
        var_8 = wp::mul(var_4, var_9);
        var_11 = wp::address(var_weight, var_10);
        var_13 = wp::load(var_11);
        var_12 = wp::mul(var_8, var_13);
        // residuals[problem, start_idx + coord_idx] = (                                          <L 98>
        var_14 = wp::add(var_start_idx, var_1);
        // wp::array_store(var_residuals, var_0, var_14, var_12);
        //---------
        // reverse
        wp::adj_array_store(var_residuals, var_0, var_14, var_12, adj_residuals, adj_0, adj_14, adj_12);
        wp::adj_add(var_start_idx, var_1, adj_start_idx, adj_1, adj_14);
        // adj: residuals[problem, start_idx + coord_idx] = (                                     <L 98>
        wp::adj_mul(var_8, var_13, adj_8, adj_11, adj_12);
        wp::adj_address(var_weight, var_10, adj_weight, adj_10, adj_11);
        wp::adj_mul(var_4, var_9, adj_4, adj_7, adj_8);
        wp::adj_address(var_coord_masks, var_1, adj_coord_masks, adj_1, adj_7);
        // adj: ) * coord_masks[coord_idx] * weight[0]                                            <L 100>
        wp::adj_sub(var_5, var_6, adj_2, adj_3, adj_4);
        wp::adj_address(var_coord_targets, var_0, var_1, adj_coord_targets, adj_0, adj_1, adj_3);
        wp::adj_address(var_joint_q, var_0, var_1, adj_joint_q, adj_0, adj_1, adj_2);
        // adj: joint_q[problem, coord_idx] - coord_targets[problem, coord_idx]                   <L 99>
        // adj: residuals[problem, start_idx + coord_idx] = (                                     <L 98>
        // adj: problem, coord_idx = wp.tid()                                                     <L 97>
        // adj: def _temporal_joint_target_residuals(                                             <L 88>
        continue;
    }
}



extern "C" __global__ void _joint_target_jac_analytic_23325330_cuda_kernel_forward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::int32> var_coord_to_dof,
    wp::array_t<wp::float32> var_coord_masks,
    wp::array_t<wp::float32> var_weight,
    wp::int32 var_start_idx,
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
        wp::int32* var_2;
        wp::int32 var_3;
        wp::int32 var_4;
        const wp::int32 var_5 = 0;
        bool var_6;
        const wp::int32 var_7 = 0;
        wp::float32* var_8;
        wp::float32* var_9;
        wp::float32 var_10;
        wp::float32 var_11;
        wp::float32 var_12;
        wp::int32 var_13;
        //---------
        // forward
        // def _joint_target_jac_analytic(                                                        <L 104>
        // problem, coord_idx = wp.tid()                                                          <L 112>
        builtin_tid2d(var_0, var_1);
        // dof_idx = coord_to_dof[coord_idx]                                                      <L 113>
        var_2 = wp::address(var_coord_to_dof, var_1);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // if dof_idx >= 0:                                                                       <L 114>
        var_6 = (var_3 >= var_5);
        if (var_6) {
            // jacobian[problem, start_idx + coord_idx, dof_idx] = weight[0] * coord_masks[coord_idx]       <L 115>
            var_8 = wp::address(var_weight, var_7);
            var_9 = wp::address(var_coord_masks, var_1);
            var_11 = wp::load(var_8);
            var_12 = wp::load(var_9);
            var_10 = wp::mul(var_11, var_12);
            var_13 = wp::add(var_start_idx, var_1);
            wp::array_store(var_jacobian, var_0, var_13, var_3, var_10);
        }
    }
}



extern "C" __global__ void _joint_target_jac_analytic_23325330_cuda_kernel_backward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::int32> var_coord_to_dof,
    wp::array_t<wp::float32> var_coord_masks,
    wp::array_t<wp::float32> var_weight,
    wp::int32 var_start_idx,
    wp::array_t<wp::float32> var_jacobian,
    wp::array_t<wp::int32> adj_coord_to_dof,
    wp::array_t<wp::float32> adj_coord_masks,
    wp::array_t<wp::float32> adj_weight,
    wp::int32 adj_start_idx,
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
        wp::int32* var_2;
        wp::int32 var_3;
        wp::int32 var_4;
        const wp::int32 var_5 = 0;
        bool var_6;
        const wp::int32 var_7 = 0;
        wp::float32* var_8;
        wp::float32* var_9;
        wp::float32 var_10;
        wp::float32 var_11;
        wp::float32 var_12;
        wp::int32 var_13;
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
        wp::float32 adj_8 = {};
        wp::float32 adj_9 = {};
        wp::float32 adj_10 = {};
        wp::float32 adj_11 = {};
        wp::float32 adj_12 = {};
        wp::int32 adj_13 = {};
        //---------
        // forward
        // def _joint_target_jac_analytic(                                                        <L 104>
        // problem, coord_idx = wp.tid()                                                          <L 112>
        builtin_tid2d(var_0, var_1);
        // dof_idx = coord_to_dof[coord_idx]                                                      <L 113>
        var_2 = wp::address(var_coord_to_dof, var_1);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // if dof_idx >= 0:                                                                       <L 114>
        var_6 = (var_3 >= var_5);
        if (var_6) {
            // jacobian[problem, start_idx + coord_idx, dof_idx] = weight[0] * coord_masks[coord_idx]       <L 115>
            var_8 = wp::address(var_weight, var_7);
            var_9 = wp::address(var_coord_masks, var_1);
            var_11 = wp::load(var_8);
            var_12 = wp::load(var_9);
            var_10 = wp::mul(var_11, var_12);
            var_13 = wp::add(var_start_idx, var_1);
            // wp::array_store(var_jacobian, var_0, var_13, var_3, var_10);
        }
        //---------
        // reverse
        if (var_6) {
            wp::adj_array_store(var_jacobian, var_0, var_13, var_3, var_10, adj_jacobian, adj_0, adj_13, adj_3, adj_10);
            wp::adj_add(var_start_idx, var_1, adj_start_idx, adj_1, adj_13);
            wp::adj_mul(var_11, var_12, adj_8, adj_9, adj_10);
            wp::adj_address(var_coord_masks, var_1, adj_coord_masks, adj_1, adj_9);
            wp::adj_address(var_weight, var_7, adj_weight, adj_7, adj_8);
            // adj: jacobian[problem, start_idx + coord_idx, dof_idx] = weight[0] * coord_masks[coord_idx]  <L 115>
        }
        // adj: if dof_idx >= 0:                                                                  <L 114>
        wp::adj_copy(var_4, adj_2, adj_3);
        wp::adj_address(var_coord_to_dof, var_1, adj_coord_to_dof, adj_1, adj_2);
        // adj: dof_idx = coord_to_dof[coord_idx]                                                 <L 113>
        // adj: problem, coord_idx = wp.tid()                                                     <L 112>
        // adj: def _joint_target_jac_analytic(                                                   <L 104>
        continue;
    }
}

