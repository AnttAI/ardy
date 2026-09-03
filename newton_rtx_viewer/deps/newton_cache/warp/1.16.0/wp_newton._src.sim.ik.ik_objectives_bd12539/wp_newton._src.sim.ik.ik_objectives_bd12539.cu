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



extern "C" __global__ void _update_rotation_targets_01974e9f_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::vec_t<4, wp::float32>> var_new_rotation,
    wp::array_t<wp::vec_t<4, wp::float32>> var_target_array)
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
        wp::vec_t<4, wp::float32>* var_1;
        wp::vec_t<4, wp::float32> var_2;
        //---------
        // forward
        // def _update_rotation_targets(                                                          <L 839>
        // problem_idx = wp.tid()                                                                 <L 844>
        var_0 = builtin_tid1d();
        // target_array[problem_idx] = new_rotation[problem_idx]                                  <L 845>
        var_1 = wp::address(var_new_rotation, var_0);
        var_2 = wp::load(var_1);
        wp::array_store(var_target_array, var_0, var_2);
    }
}



extern "C" __global__ void _update_rotation_targets_01974e9f_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::vec_t<4, wp::float32>> var_new_rotation,
    wp::array_t<wp::vec_t<4, wp::float32>> var_target_array,
    wp::array_t<wp::vec_t<4, wp::float32>> adj_new_rotation,
    wp::array_t<wp::vec_t<4, wp::float32>> adj_target_array)
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
        wp::vec_t<4, wp::float32>* var_1;
        wp::vec_t<4, wp::float32> var_2;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::vec_t<4, wp::float32> adj_1 = {};
        wp::vec_t<4, wp::float32> adj_2 = {};
        //---------
        // forward
        // def _update_rotation_targets(                                                          <L 839>
        // problem_idx = wp.tid()                                                                 <L 844>
        var_0 = builtin_tid1d();
        // target_array[problem_idx] = new_rotation[problem_idx]                                  <L 845>
        var_1 = wp::address(var_new_rotation, var_0);
        var_2 = wp::load(var_1);
        // wp::array_store(var_target_array, var_0, var_2);
        //---------
        // reverse
        wp::adj_array_store(var_target_array, var_0, var_2, adj_target_array, adj_0, adj_1);
        wp::adj_address(var_new_rotation, var_0, adj_new_rotation, adj_0, adj_1);
        // adj: target_array[problem_idx] = new_rotation[problem_idx]                             <L 845>
        // adj: problem_idx = wp.tid()                                                            <L 844>
        // adj: def _update_rotation_targets(                                                     <L 839>
        continue;
    }
}



extern "C" __global__ void _pos_residuals_57d9d4c0_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::vec_t<3, wp::float32>> var_target_pos,
    wp::int32 var_link_index,
    wp::vec_t<3, wp::float32> var_link_offset,
    wp::int32 var_start_idx,
    wp::float32 var_weight,
    wp::array_t<wp::int32> var_problem_idx_map,
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
        wp::int32* var_1;
        wp::int32 var_2;
        wp::int32 var_3;
        wp::transform_t<wp::float32>* var_4;
        wp::transform_t<wp::float32> var_5;
        wp::transform_t<wp::float32> var_6;
        wp::vec_t<3, wp::float32> var_7;
        wp::vec_t<3, wp::float32>* var_8;
        wp::vec_t<3, wp::float32> var_9;
        wp::vec_t<3, wp::float32> var_10;
        const wp::int32 var_11 = 0;
        wp::float32 var_12;
        wp::float32 var_13;
        const wp::int32 var_14 = 0;
        wp::int32 var_15;
        const wp::int32 var_16 = 1;
        wp::float32 var_17;
        wp::float32 var_18;
        const wp::int32 var_19 = 1;
        wp::int32 var_20;
        const wp::int32 var_21 = 2;
        wp::float32 var_22;
        wp::float32 var_23;
        const wp::int32 var_24 = 2;
        wp::int32 var_25;
        //---------
        // forward
        // def _pos_residuals(                                                                    <L 160>
        // row = wp.tid()                                                                         <L 171>
        var_0 = builtin_tid1d();
        // base = problem_idx_map[row]                                                            <L 172>
        var_1 = wp::address(var_problem_idx_map, var_0);
        var_3 = wp::load(var_1);
        var_2 = wp::copy(var_3);
        // body_tf = body_q[row, link_index]                                                      <L 174>
        var_4 = wp::address(var_body_q, var_0, var_link_index);
        var_6 = wp::load(var_4);
        var_5 = wp::copy(var_6);
        // ee_pos = wp.transform_point(body_tf, link_offset)                                      <L 175>
        var_7 = wp::transform_point(var_5, var_link_offset);
        // error = target_pos[base] - ee_pos                                                      <L 177>
        var_8 = wp::address(var_target_pos, var_2);
        var_10 = wp::load(var_8);
        var_9 = wp::sub(var_10, var_7);
        // residuals[row, start_idx + 0] = weight * error[0]                                      <L 178>
        var_12 = wp::extract(var_9, var_11);
        var_13 = wp::mul(var_weight, var_12);
        var_15 = wp::add(var_start_idx, var_14);
        wp::array_store(var_residuals, var_0, var_15, var_13);
        // residuals[row, start_idx + 1] = weight * error[1]                                      <L 179>
        var_17 = wp::extract(var_9, var_16);
        var_18 = wp::mul(var_weight, var_17);
        var_20 = wp::add(var_start_idx, var_19);
        wp::array_store(var_residuals, var_0, var_20, var_18);
        // residuals[row, start_idx + 2] = weight * error[2]                                      <L 180>
        var_22 = wp::extract(var_9, var_21);
        var_23 = wp::mul(var_weight, var_22);
        var_25 = wp::add(var_start_idx, var_24);
        wp::array_store(var_residuals, var_0, var_25, var_23);
    }
}



extern "C" __global__ void _pos_residuals_57d9d4c0_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::vec_t<3, wp::float32>> var_target_pos,
    wp::int32 var_link_index,
    wp::vec_t<3, wp::float32> var_link_offset,
    wp::int32 var_start_idx,
    wp::float32 var_weight,
    wp::array_t<wp::int32> var_problem_idx_map,
    wp::array_t<wp::float32> var_residuals,
    wp::array_t<wp::transform_t<wp::float32>> adj_body_q,
    wp::array_t<wp::vec_t<3, wp::float32>> adj_target_pos,
    wp::int32 adj_link_index,
    wp::vec_t<3, wp::float32> adj_link_offset,
    wp::int32 adj_start_idx,
    wp::float32 adj_weight,
    wp::array_t<wp::int32> adj_problem_idx_map,
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
        wp::int32* var_1;
        wp::int32 var_2;
        wp::int32 var_3;
        wp::transform_t<wp::float32>* var_4;
        wp::transform_t<wp::float32> var_5;
        wp::transform_t<wp::float32> var_6;
        wp::vec_t<3, wp::float32> var_7;
        wp::vec_t<3, wp::float32>* var_8;
        wp::vec_t<3, wp::float32> var_9;
        wp::vec_t<3, wp::float32> var_10;
        const wp::int32 var_11 = 0;
        wp::float32 var_12;
        wp::float32 var_13;
        const wp::int32 var_14 = 0;
        wp::int32 var_15;
        const wp::int32 var_16 = 1;
        wp::float32 var_17;
        wp::float32 var_18;
        const wp::int32 var_19 = 1;
        wp::int32 var_20;
        const wp::int32 var_21 = 2;
        wp::float32 var_22;
        wp::float32 var_23;
        const wp::int32 var_24 = 2;
        wp::int32 var_25;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::int32 adj_2 = {};
        wp::int32 adj_3 = {};
        wp::transform_t<wp::float32> adj_4 = {};
        wp::transform_t<wp::float32> adj_5 = {};
        wp::transform_t<wp::float32> adj_6 = {};
        wp::vec_t<3, wp::float32> adj_7 = {};
        wp::vec_t<3, wp::float32> adj_8 = {};
        wp::vec_t<3, wp::float32> adj_9 = {};
        wp::vec_t<3, wp::float32> adj_10 = {};
        wp::int32 adj_11 = {};
        wp::float32 adj_12 = {};
        wp::float32 adj_13 = {};
        wp::int32 adj_14 = {};
        wp::int32 adj_15 = {};
        wp::int32 adj_16 = {};
        wp::float32 adj_17 = {};
        wp::float32 adj_18 = {};
        wp::int32 adj_19 = {};
        wp::int32 adj_20 = {};
        wp::int32 adj_21 = {};
        wp::float32 adj_22 = {};
        wp::float32 adj_23 = {};
        wp::int32 adj_24 = {};
        wp::int32 adj_25 = {};
        //---------
        // forward
        // def _pos_residuals(                                                                    <L 160>
        // row = wp.tid()                                                                         <L 171>
        var_0 = builtin_tid1d();
        // base = problem_idx_map[row]                                                            <L 172>
        var_1 = wp::address(var_problem_idx_map, var_0);
        var_3 = wp::load(var_1);
        var_2 = wp::copy(var_3);
        // body_tf = body_q[row, link_index]                                                      <L 174>
        var_4 = wp::address(var_body_q, var_0, var_link_index);
        var_6 = wp::load(var_4);
        var_5 = wp::copy(var_6);
        // ee_pos = wp.transform_point(body_tf, link_offset)                                      <L 175>
        var_7 = wp::transform_point(var_5, var_link_offset);
        // error = target_pos[base] - ee_pos                                                      <L 177>
        var_8 = wp::address(var_target_pos, var_2);
        var_10 = wp::load(var_8);
        var_9 = wp::sub(var_10, var_7);
        // residuals[row, start_idx + 0] = weight * error[0]                                      <L 178>
        var_12 = wp::extract(var_9, var_11);
        var_13 = wp::mul(var_weight, var_12);
        var_15 = wp::add(var_start_idx, var_14);
        // wp::array_store(var_residuals, var_0, var_15, var_13);
        // residuals[row, start_idx + 1] = weight * error[1]                                      <L 179>
        var_17 = wp::extract(var_9, var_16);
        var_18 = wp::mul(var_weight, var_17);
        var_20 = wp::add(var_start_idx, var_19);
        // wp::array_store(var_residuals, var_0, var_20, var_18);
        // residuals[row, start_idx + 2] = weight * error[2]                                      <L 180>
        var_22 = wp::extract(var_9, var_21);
        var_23 = wp::mul(var_weight, var_22);
        var_25 = wp::add(var_start_idx, var_24);
        // wp::array_store(var_residuals, var_0, var_25, var_23);
        //---------
        // reverse
        wp::adj_array_store(var_residuals, var_0, var_25, var_23, adj_residuals, adj_0, adj_25, adj_23);
        wp::adj_add(var_start_idx, var_24, adj_start_idx, adj_24, adj_25);
        wp::adj_mul(var_weight, var_22, adj_weight, adj_22, adj_23);
        wp::adj_extract(var_9, var_21, adj_9, adj_21, adj_22);
        // adj: residuals[row, start_idx + 2] = weight * error[2]                                 <L 180>
        wp::adj_array_store(var_residuals, var_0, var_20, var_18, adj_residuals, adj_0, adj_20, adj_18);
        wp::adj_add(var_start_idx, var_19, adj_start_idx, adj_19, adj_20);
        wp::adj_mul(var_weight, var_17, adj_weight, adj_17, adj_18);
        wp::adj_extract(var_9, var_16, adj_9, adj_16, adj_17);
        // adj: residuals[row, start_idx + 1] = weight * error[1]                                 <L 179>
        wp::adj_array_store(var_residuals, var_0, var_15, var_13, adj_residuals, adj_0, adj_15, adj_13);
        wp::adj_add(var_start_idx, var_14, adj_start_idx, adj_14, adj_15);
        wp::adj_mul(var_weight, var_12, adj_weight, adj_12, adj_13);
        wp::adj_extract(var_9, var_11, adj_9, adj_11, adj_12);
        // adj: residuals[row, start_idx + 0] = weight * error[0]                                 <L 178>
        wp::adj_sub(var_10, var_7, adj_8, adj_7, adj_9);
        wp::adj_address(var_target_pos, var_2, adj_target_pos, adj_2, adj_8);
        // adj: error = target_pos[base] - ee_pos                                                 <L 177>
        wp::adj_transform_point(var_5, var_link_offset, adj_5, adj_link_offset, adj_7);
        // adj: ee_pos = wp.transform_point(body_tf, link_offset)                                 <L 175>
        wp::adj_copy(var_6, adj_4, adj_5);
        wp::adj_address(var_body_q, var_0, var_link_index, adj_body_q, adj_0, adj_link_index, adj_4);
        // adj: body_tf = body_q[row, link_index]                                                 <L 174>
        wp::adj_copy(var_3, adj_1, adj_2);
        wp::adj_address(var_problem_idx_map, var_0, adj_problem_idx_map, adj_0, adj_1);
        // adj: base = problem_idx_map[row]                                                       <L 172>
        // adj: row = wp.tid()                                                                    <L 171>
        // adj: def _pos_residuals(                                                               <L 160>
        continue;
    }
}



extern "C" __global__ void _rot_jac_analytic_68109a34_cuda_kernel_forward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::uint8> var_affects_dof,
    wp::array_t<wp::vec_t<6, wp::float32>> var_joint_S_s,
    wp::int32 var_start_idx,
    wp::int32 var_n_dofs,
    wp::float32 var_weight,
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
        wp::uint8* var_2;
        const wp::int32 var_3 = 0;
        bool var_4;
        wp::uint8 var_5;
        wp::vec_t<6, wp::float32>* var_6;
        wp::vec_t<6, wp::float32> var_7;
        wp::vec_t<6, wp::float32> var_8;
        const wp::int32 var_9 = 3;
        wp::float32 var_10;
        const wp::int32 var_11 = 4;
        wp::float32 var_12;
        const wp::int32 var_13 = 5;
        wp::float32 var_14;
        wp::vec_t<3, wp::float32> var_15;
        const wp::int32 var_16 = 0;
        wp::float32 var_17;
        wp::float32 var_18;
        const wp::int32 var_19 = 0;
        wp::int32 var_20;
        const wp::int32 var_21 = 1;
        wp::float32 var_22;
        wp::float32 var_23;
        const wp::int32 var_24 = 1;
        wp::int32 var_25;
        const wp::int32 var_26 = 2;
        wp::float32 var_27;
        wp::float32 var_28;
        const wp::int32 var_29 = 2;
        wp::int32 var_30;
        //---------
        // forward
        // def _rot_jac_analytic(                                                                 <L 849>
        // problem_idx, dof_idx = wp.tid()                                                        <L 859>
        builtin_tid2d(var_0, var_1);
        // if affects_dof[dof_idx] == 0:                                                          <L 862>
        var_2 = wp::address(var_affects_dof, var_1);
        var_5 = wp::load(var_2);
        var_4 = (var_5 == var_3);
        if (var_4) {
            // return                                                                             <L 863>
            continue;
        }
        // S = joint_S_s[problem_idx, dof_idx]                                                    <L 866>
        var_6 = wp::address(var_joint_S_s, var_0, var_1);
        var_8 = wp::load(var_6);
        var_7 = wp::copy(var_8);
        // omega = wp.vec3(S[3], S[4], S[5])                                                      <L 867>
        var_10 = wp::extract(var_7, var_9);
        var_12 = wp::extract(var_7, var_11);
        var_14 = wp::extract(var_7, var_13);
        var_15 = wp::vec_t<3, wp::float32>(var_10, var_12, var_14);
        // jacobian[problem_idx, start_idx + 0, dof_idx] = weight * omega[0]                      <L 870>
        var_17 = wp::extract(var_15, var_16);
        var_18 = wp::mul(var_weight, var_17);
        var_20 = wp::add(var_start_idx, var_19);
        wp::array_store(var_jacobian, var_0, var_20, var_1, var_18);
        // jacobian[problem_idx, start_idx + 1, dof_idx] = weight * omega[1]                      <L 871>
        var_22 = wp::extract(var_15, var_21);
        var_23 = wp::mul(var_weight, var_22);
        var_25 = wp::add(var_start_idx, var_24);
        wp::array_store(var_jacobian, var_0, var_25, var_1, var_23);
        // jacobian[problem_idx, start_idx + 2, dof_idx] = weight * omega[2]                      <L 872>
        var_27 = wp::extract(var_15, var_26);
        var_28 = wp::mul(var_weight, var_27);
        var_30 = wp::add(var_start_idx, var_29);
        wp::array_store(var_jacobian, var_0, var_30, var_1, var_28);
    }
}



extern "C" __global__ void _rot_jac_analytic_68109a34_cuda_kernel_backward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::uint8> var_affects_dof,
    wp::array_t<wp::vec_t<6, wp::float32>> var_joint_S_s,
    wp::int32 var_start_idx,
    wp::int32 var_n_dofs,
    wp::float32 var_weight,
    wp::array_t<wp::float32> var_jacobian,
    wp::array_t<wp::uint8> adj_affects_dof,
    wp::array_t<wp::vec_t<6, wp::float32>> adj_joint_S_s,
    wp::int32 adj_start_idx,
    wp::int32 adj_n_dofs,
    wp::float32 adj_weight,
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
        wp::uint8* var_2;
        const wp::int32 var_3 = 0;
        bool var_4;
        wp::uint8 var_5;
        wp::vec_t<6, wp::float32>* var_6;
        wp::vec_t<6, wp::float32> var_7;
        wp::vec_t<6, wp::float32> var_8;
        const wp::int32 var_9 = 3;
        wp::float32 var_10;
        const wp::int32 var_11 = 4;
        wp::float32 var_12;
        const wp::int32 var_13 = 5;
        wp::float32 var_14;
        wp::vec_t<3, wp::float32> var_15;
        const wp::int32 var_16 = 0;
        wp::float32 var_17;
        wp::float32 var_18;
        const wp::int32 var_19 = 0;
        wp::int32 var_20;
        const wp::int32 var_21 = 1;
        wp::float32 var_22;
        wp::float32 var_23;
        const wp::int32 var_24 = 1;
        wp::int32 var_25;
        const wp::int32 var_26 = 2;
        wp::float32 var_27;
        wp::float32 var_28;
        const wp::int32 var_29 = 2;
        wp::int32 var_30;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::uint8 adj_2 = {};
        wp::int32 adj_3 = {};
        bool adj_4 = {};
        wp::uint8 adj_5 = {};
        wp::vec_t<6, wp::float32> adj_6 = {};
        wp::vec_t<6, wp::float32> adj_7 = {};
        wp::vec_t<6, wp::float32> adj_8 = {};
        wp::int32 adj_9 = {};
        wp::float32 adj_10 = {};
        wp::int32 adj_11 = {};
        wp::float32 adj_12 = {};
        wp::int32 adj_13 = {};
        wp::float32 adj_14 = {};
        wp::vec_t<3, wp::float32> adj_15 = {};
        wp::int32 adj_16 = {};
        wp::float32 adj_17 = {};
        wp::float32 adj_18 = {};
        wp::int32 adj_19 = {};
        wp::int32 adj_20 = {};
        wp::int32 adj_21 = {};
        wp::float32 adj_22 = {};
        wp::float32 adj_23 = {};
        wp::int32 adj_24 = {};
        wp::int32 adj_25 = {};
        wp::int32 adj_26 = {};
        wp::float32 adj_27 = {};
        wp::float32 adj_28 = {};
        wp::int32 adj_29 = {};
        wp::int32 adj_30 = {};
        //---------
        // forward
        // def _rot_jac_analytic(                                                                 <L 849>
        // problem_idx, dof_idx = wp.tid()                                                        <L 859>
        builtin_tid2d(var_0, var_1);
        // if affects_dof[dof_idx] == 0:                                                          <L 862>
        var_2 = wp::address(var_affects_dof, var_1);
        var_5 = wp::load(var_2);
        var_4 = (var_5 == var_3);
        if (var_4) {
            // return                                                                             <L 863>
            goto label0;
        }
        // S = joint_S_s[problem_idx, dof_idx]                                                    <L 866>
        var_6 = wp::address(var_joint_S_s, var_0, var_1);
        var_8 = wp::load(var_6);
        var_7 = wp::copy(var_8);
        // omega = wp.vec3(S[3], S[4], S[5])                                                      <L 867>
        var_10 = wp::extract(var_7, var_9);
        var_12 = wp::extract(var_7, var_11);
        var_14 = wp::extract(var_7, var_13);
        var_15 = wp::vec_t<3, wp::float32>(var_10, var_12, var_14);
        // jacobian[problem_idx, start_idx + 0, dof_idx] = weight * omega[0]                      <L 870>
        var_17 = wp::extract(var_15, var_16);
        var_18 = wp::mul(var_weight, var_17);
        var_20 = wp::add(var_start_idx, var_19);
        // wp::array_store(var_jacobian, var_0, var_20, var_1, var_18);
        // jacobian[problem_idx, start_idx + 1, dof_idx] = weight * omega[1]                      <L 871>
        var_22 = wp::extract(var_15, var_21);
        var_23 = wp::mul(var_weight, var_22);
        var_25 = wp::add(var_start_idx, var_24);
        // wp::array_store(var_jacobian, var_0, var_25, var_1, var_23);
        // jacobian[problem_idx, start_idx + 2, dof_idx] = weight * omega[2]                      <L 872>
        var_27 = wp::extract(var_15, var_26);
        var_28 = wp::mul(var_weight, var_27);
        var_30 = wp::add(var_start_idx, var_29);
        // wp::array_store(var_jacobian, var_0, var_30, var_1, var_28);
        //---------
        // reverse
        wp::adj_array_store(var_jacobian, var_0, var_30, var_1, var_28, adj_jacobian, adj_0, adj_30, adj_1, adj_28);
        wp::adj_add(var_start_idx, var_29, adj_start_idx, adj_29, adj_30);
        wp::adj_mul(var_weight, var_27, adj_weight, adj_27, adj_28);
        wp::adj_extract(var_15, var_26, adj_15, adj_26, adj_27);
        // adj: jacobian[problem_idx, start_idx + 2, dof_idx] = weight * omega[2]                 <L 872>
        wp::adj_array_store(var_jacobian, var_0, var_25, var_1, var_23, adj_jacobian, adj_0, adj_25, adj_1, adj_23);
        wp::adj_add(var_start_idx, var_24, adj_start_idx, adj_24, adj_25);
        wp::adj_mul(var_weight, var_22, adj_weight, adj_22, adj_23);
        wp::adj_extract(var_15, var_21, adj_15, adj_21, adj_22);
        // adj: jacobian[problem_idx, start_idx + 1, dof_idx] = weight * omega[1]                 <L 871>
        wp::adj_array_store(var_jacobian, var_0, var_20, var_1, var_18, adj_jacobian, adj_0, adj_20, adj_1, adj_18);
        wp::adj_add(var_start_idx, var_19, adj_start_idx, adj_19, adj_20);
        wp::adj_mul(var_weight, var_17, adj_weight, adj_17, adj_18);
        wp::adj_extract(var_15, var_16, adj_15, adj_16, adj_17);
        // adj: jacobian[problem_idx, start_idx + 0, dof_idx] = weight * omega[0]                 <L 870>
        wp::adj_vec_t(var_10, var_12, var_14, adj_10, adj_12, adj_14, adj_15);
        wp::adj_extract(var_7, var_13, adj_7, adj_13, adj_14);
        wp::adj_extract(var_7, var_11, adj_7, adj_11, adj_12);
        wp::adj_extract(var_7, var_9, adj_7, adj_9, adj_10);
        // adj: omega = wp.vec3(S[3], S[4], S[5])                                                 <L 867>
        wp::adj_copy(var_8, adj_6, adj_7);
        wp::adj_address(var_joint_S_s, var_0, var_1, adj_joint_S_s, adj_0, adj_1, adj_6);
        // adj: S = joint_S_s[problem_idx, dof_idx]                                               <L 866>
        if (var_4) {
            label0:;
            // adj: return                                                                        <L 863>
        }
        wp::adj_address(var_affects_dof, var_1, adj_affects_dof, adj_1, adj_2);
        // adj: if affects_dof[dof_idx] == 0:                                                     <L 862>
        // adj: problem_idx, dof_idx = wp.tid()                                                   <L 859>
        // adj: def _rot_jac_analytic(                                                            <L 849>
        continue;
    }
}



extern "C" __global__ void _update_position_targets_52987d3d_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::vec_t<3, wp::float32>> var_new_positions,
    wp::array_t<wp::vec_t<3, wp::float32>> var_target_array)
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
        wp::vec_t<3, wp::float32>* var_1;
        wp::vec_t<3, wp::float32> var_2;
        //---------
        // forward
        // def _update_position_targets(                                                          <L 210>
        // problem_idx = wp.tid()                                                                 <L 215>
        var_0 = builtin_tid1d();
        // target_array[problem_idx] = new_positions[problem_idx]                                 <L 216>
        var_1 = wp::address(var_new_positions, var_0);
        var_2 = wp::load(var_1);
        wp::array_store(var_target_array, var_0, var_2);
    }
}



extern "C" __global__ void _update_position_targets_52987d3d_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::vec_t<3, wp::float32>> var_new_positions,
    wp::array_t<wp::vec_t<3, wp::float32>> var_target_array,
    wp::array_t<wp::vec_t<3, wp::float32>> adj_new_positions,
    wp::array_t<wp::vec_t<3, wp::float32>> adj_target_array)
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
        wp::vec_t<3, wp::float32>* var_1;
        wp::vec_t<3, wp::float32> var_2;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::vec_t<3, wp::float32> adj_1 = {};
        wp::vec_t<3, wp::float32> adj_2 = {};
        //---------
        // forward
        // def _update_position_targets(                                                          <L 210>
        // problem_idx = wp.tid()                                                                 <L 215>
        var_0 = builtin_tid1d();
        // target_array[problem_idx] = new_positions[problem_idx]                                 <L 216>
        var_1 = wp::address(var_new_positions, var_0);
        var_2 = wp::load(var_1);
        // wp::array_store(var_target_array, var_0, var_2);
        //---------
        // reverse
        wp::adj_array_store(var_target_array, var_0, var_2, adj_target_array, adj_0, adj_1);
        wp::adj_address(var_new_positions, var_0, adj_new_positions, adj_0, adj_1);
        // adj: target_array[problem_idx] = new_positions[problem_idx]                            <L 216>
        // adj: problem_idx = wp.tid()                                                            <L 215>
        // adj: def _update_position_targets(                                                     <L 210>
        continue;
    }
}



extern "C" __global__ void _rot_jac_fill_e463e17d_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::float32> var_q_grad,
    wp::int32 var_n_dofs,
    wp::int32 var_start_idx,
    wp::int32 var_component,
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
        wp::range_t var_2;
        wp::int32 var_3;
        wp::float32* var_4;
        wp::float32 var_5;
        //---------
        // forward
        // def _rot_jac_fill(                                                                     <L 812>
        // problem_idx = wp.tid()                                                                 <L 820>
        var_0 = builtin_tid1d();
        // residual_idx = start_idx + component                                                   <L 822>
        var_1 = wp::add(var_start_idx, var_component);
        // for j in range(n_dofs):                                                                <L 824>
        var_2 = wp::range(var_n_dofs);
        start_for_0:;
            if (iter_cmp(var_2) == 0) goto end_for_0;
            var_3 = wp::iter_next(var_2);
            // jacobian[problem_idx, residual_idx, j] = q_grad[problem_idx, j]                    <L 825>
            var_4 = wp::address(var_q_grad, var_0, var_3);
            var_5 = wp::load(var_4);
            wp::array_store(var_jacobian, var_0, var_1, var_3, var_5);
            goto start_for_0;
        end_for_0:;
    }
}



extern "C" __global__ void _rot_jac_fill_e463e17d_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::float32> var_q_grad,
    wp::int32 var_n_dofs,
    wp::int32 var_start_idx,
    wp::int32 var_component,
    wp::array_t<wp::float32> var_jacobian,
    wp::array_t<wp::float32> adj_q_grad,
    wp::int32 adj_n_dofs,
    wp::int32 adj_start_idx,
    wp::int32 adj_component,
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
        wp::range_t var_2;
        wp::int32 var_3;
        wp::float32* var_4;
        wp::float32 var_5;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::range_t adj_2 = {};
        wp::int32 adj_3 = {};
        wp::float32 adj_4 = {};
        wp::float32 adj_5 = {};
        //---------
        // forward
        // def _rot_jac_fill(                                                                     <L 812>
        // problem_idx = wp.tid()                                                                 <L 820>
        var_0 = builtin_tid1d();
        // residual_idx = start_idx + component                                                   <L 822>
        var_1 = wp::add(var_start_idx, var_component);
        // for j in range(n_dofs):                                                                <L 824>
        var_2 = wp::range(var_n_dofs);
        //---------
        // reverse
        var_2 = wp::iter_reverse(var_2);
        start_for_0:;
            if (iter_cmp(var_2) == 0) goto end_for_0;
            var_3 = wp::iter_next(var_2);
        	adj_4 = {};
        	adj_5 = {};
            // jacobian[problem_idx, residual_idx, j] = q_grad[problem_idx, j]                    <L 825>
            var_4 = wp::address(var_q_grad, var_0, var_3);
            var_5 = wp::load(var_4);
            // wp::array_store(var_jacobian, var_0, var_1, var_3, var_5);
            wp::adj_array_store(var_jacobian, var_0, var_1, var_3, var_5, adj_jacobian, adj_0, adj_1, adj_3, adj_4);
            wp::adj_address(var_q_grad, var_0, var_3, adj_q_grad, adj_0, adj_3, adj_4);
            // adj: jacobian[problem_idx, residual_idx, j] = q_grad[problem_idx, j]               <L 825>
        	goto start_for_0;
        end_for_0:;
        // adj: for j in range(n_dofs):                                                           <L 824>
        wp::adj_add(var_start_idx, var_component, adj_start_idx, adj_component, adj_1);
        // adj: residual_idx = start_idx + component                                              <L 822>
        // adj: problem_idx = wp.tid()                                                            <L 820>
        // adj: def _rot_jac_fill(                                                                <L 812>
        continue;
    }
}



extern "C" __global__ void _rot_residuals_41a9264e_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::vec_t<4, wp::float32>> var_target_rot,
    wp::int32 var_link_index,
    wp::quat_t<wp::float32> var_link_offset_rotation,
    bool var_canonicalize_quat_err,
    wp::int32 var_start_idx,
    wp::float32 var_weight,
    wp::array_t<wp::int32> var_problem_idx_map,
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
        wp::int32* var_1;
        wp::int32 var_2;
        wp::int32 var_3;
        wp::transform_t<wp::float32>* var_4;
        wp::transform_t<wp::float32> var_5;
        wp::transform_t<wp::float32> var_6;
        const wp::int32 var_7 = 3;
        wp::float32 var_8;
        const wp::int32 var_9 = 4;
        wp::float32 var_10;
        const wp::int32 var_11 = 5;
        wp::float32 var_12;
        const wp::int32 var_13 = 6;
        wp::float32 var_14;
        wp::quat_t<wp::float32> var_15;
        wp::quat_t<wp::float32> var_16;
        wp::vec_t<4, wp::float32>* var_17;
        wp::vec_t<4, wp::float32> var_18;
        wp::vec_t<4, wp::float32> var_19;
        const wp::int32 var_20 = 0;
        wp::float32 var_21;
        const wp::int32 var_22 = 1;
        wp::float32 var_23;
        const wp::int32 var_24 = 2;
        wp::float32 var_25;
        const wp::int32 var_26 = 3;
        wp::float32 var_27;
        wp::quat_t<wp::float32> var_28;
        wp::quat_t<wp::float32> var_29;
        wp::quat_t<wp::float32> var_30;
        bool var_31;
        wp::float32 var_32;
        const wp::float32 var_33 = 0.0;
        bool var_34;
        wp::quat_t<wp::float32> var_35;
        wp::quat_t<wp::float32> var_36;
        const wp::int32 var_37 = 0;
        wp::float32 var_38;
        const wp::int32 var_39 = 0;
        wp::float32 var_40;
        wp::float32 var_41;
        const wp::int32 var_42 = 1;
        wp::float32 var_43;
        const wp::int32 var_44 = 1;
        wp::float32 var_45;
        wp::float32 var_46;
        wp::float32 var_47;
        const wp::int32 var_48 = 2;
        wp::float32 var_49;
        const wp::int32 var_50 = 2;
        wp::float32 var_51;
        wp::float32 var_52;
        wp::float32 var_53;
        wp::float32 var_54;
        const wp::float32 var_55 = 2.0;
        const wp::int32 var_56 = 3;
        wp::float32 var_57;
        wp::float32 var_58;
        wp::float32 var_59;
        const wp::float32 var_60 = 1e-08;
        wp::float32 var_61;
        const wp::float32 var_62 = 0.0;
        const wp::float32 var_63 = 0.0;
        const wp::float32 var_64 = 0.0;
        wp::vec_t<3, wp::float32> var_65;
        bool var_66;
        const wp::int32 var_67 = 0;
        wp::float32 var_68;
        wp::float32 var_69;
        const wp::int32 var_70 = 1;
        wp::float32 var_71;
        wp::float32 var_72;
        const wp::int32 var_73 = 2;
        wp::float32 var_74;
        wp::float32 var_75;
        wp::vec_t<3, wp::float32> var_76;
        wp::vec_t<3, wp::float32> var_77;
        const wp::float32 var_78 = 2.0;
        const wp::int32 var_79 = 0;
        wp::float32 var_80;
        wp::float32 var_81;
        const wp::float32 var_82 = 2.0;
        const wp::int32 var_83 = 1;
        wp::float32 var_84;
        wp::float32 var_85;
        const wp::float32 var_86 = 2.0;
        const wp::int32 var_87 = 2;
        wp::float32 var_88;
        wp::float32 var_89;
        wp::vec_t<3, wp::float32> var_90;
        wp::vec_t<3, wp::float32> var_91;
        const wp::int32 var_92 = 0;
        wp::float32 var_93;
        wp::float32 var_94;
        const wp::int32 var_95 = 0;
        wp::int32 var_96;
        const wp::int32 var_97 = 1;
        wp::float32 var_98;
        wp::float32 var_99;
        const wp::int32 var_100 = 1;
        wp::int32 var_101;
        const wp::int32 var_102 = 2;
        wp::float32 var_103;
        wp::float32 var_104;
        const wp::int32 var_105 = 2;
        wp::int32 var_106;
        //---------
        // forward
        // def _rot_residuals(                                                                    <L 766>
        // row = wp.tid()                                                                         <L 778>
        var_0 = builtin_tid1d();
        // base = problem_idx_map[row]                                                            <L 779>
        var_1 = wp::address(var_problem_idx_map, var_0);
        var_3 = wp::load(var_1);
        var_2 = wp::copy(var_3);
        // body_tf = body_q[row, link_index]                                                      <L 781>
        var_4 = wp::address(var_body_q, var_0, var_link_index);
        var_6 = wp::load(var_4);
        var_5 = wp::copy(var_6);
        // body_rot = wp.quat(body_tf[3], body_tf[4], body_tf[5], body_tf[6])                     <L 782>
        var_8 = wp::extract(var_5, var_7);
        var_10 = wp::extract(var_5, var_9);
        var_12 = wp::extract(var_5, var_11);
        var_14 = wp::extract(var_5, var_13);
        var_15 = wp::quat_t<wp::float32>(var_8, var_10, var_12, var_14);
        // actual_rot = body_rot * link_offset_rotation                                           <L 784>
        var_16 = wp::mul(var_15, var_link_offset_rotation);
        // target_quat_vec = target_rot[base]                                                     <L 786>
        var_17 = wp::address(var_target_rot, var_2);
        var_19 = wp::load(var_17);
        var_18 = wp::copy(var_19);
        // target_quat = wp.quat(target_quat_vec[0], target_quat_vec[1], target_quat_vec[2], target_quat_vec[3])       <L 787>
        var_21 = wp::extract(var_18, var_20);
        var_23 = wp::extract(var_18, var_22);
        var_25 = wp::extract(var_18, var_24);
        var_27 = wp::extract(var_18, var_26);
        var_28 = wp::quat_t<wp::float32>(var_21, var_23, var_25, var_27);
        // q_err = actual_rot * wp.quat_inverse(target_quat)                                      <L 789>
        var_29 = wp::quat_inverse(var_28);
        var_30 = wp::mul(var_16, var_29);
        // if canonicalize_quat_err and wp.dot(actual_rot, target_quat) < 0.0:                    <L 790>
        var_31 = var_canonicalize_quat_err;
        if (var_31) {
            var_32 = wp::dot(var_16, var_28);
            var_34 = (var_32 < var_33);
            var_31 = var_31 && var_34;
        }
        if (var_31) {
            // q_err = -q_err                                                                     <L 791>
            var_35 = wp::neg(var_30);
        }
        var_36 = wp::where(var_31, var_35, var_30);
        // v_norm = wp.sqrt(q_err[0] * q_err[0] + q_err[1] * q_err[1] + q_err[2] * q_err[2])       <L 793>
        var_38 = wp::extract(var_36, var_37);
        var_40 = wp::extract(var_36, var_39);
        var_41 = wp::mul(var_38, var_40);
        var_43 = wp::extract(var_36, var_42);
        var_45 = wp::extract(var_36, var_44);
        var_46 = wp::mul(var_43, var_45);
        var_47 = wp::add(var_41, var_46);
        var_49 = wp::extract(var_36, var_48);
        var_51 = wp::extract(var_36, var_50);
        var_52 = wp::mul(var_49, var_51);
        var_53 = wp::add(var_47, var_52);
        var_54 = wp::sqrt(var_53);
        // angle = 2.0 * wp.atan2(v_norm, q_err[3])                                               <L 795>
        var_57 = wp::extract(var_36, var_56);
        var_58 = wp::atan2(var_54, var_57);
        var_59 = wp::mul(var_55, var_58);
        // eps = float(1e-8)                                                                      <L 797>
        var_61 = wp::float(var_60);
        // axis_angle = wp.vec3(0.0, 0.0, 0.0)                                                    <L 798>
        var_65 = wp::vec_t<3, wp::float32>(var_62, var_63, var_64);
        // if v_norm > eps:                                                                       <L 800>
        var_66 = (var_54 > var_61);
        if (var_66) {
            // axis = wp.vec3(q_err[0] / v_norm, q_err[1] / v_norm, q_err[2] / v_norm)            <L 801>
            var_68 = wp::extract(var_36, var_67);
            var_69 = wp::div(var_68, var_54);
            var_71 = wp::extract(var_36, var_70);
            var_72 = wp::div(var_71, var_54);
            var_74 = wp::extract(var_36, var_73);
            var_75 = wp::div(var_74, var_54);
            var_76 = wp::vec_t<3, wp::float32>(var_69, var_72, var_75);
            // axis_angle = axis * angle                                                          <L 802>
            var_77 = wp::mul(var_76, var_59);
        }
        if (!var_66) {
            // axis_angle = wp.vec3(2.0 * q_err[0], 2.0 * q_err[1], 2.0 * q_err[2])               <L 804>
            var_80 = wp::extract(var_36, var_79);
            var_81 = wp::mul(var_78, var_80);
            var_84 = wp::extract(var_36, var_83);
            var_85 = wp::mul(var_82, var_84);
            var_88 = wp::extract(var_36, var_87);
            var_89 = wp::mul(var_86, var_88);
            var_90 = wp::vec_t<3, wp::float32>(var_81, var_85, var_89);
        }
        var_91 = wp::where(var_66, var_77, var_90);
        // residuals[row, start_idx + 0] = weight * axis_angle[0]                                 <L 806>
        var_93 = wp::extract(var_91, var_92);
        var_94 = wp::mul(var_weight, var_93);
        var_96 = wp::add(var_start_idx, var_95);
        wp::array_store(var_residuals, var_0, var_96, var_94);
        // residuals[row, start_idx + 1] = weight * axis_angle[1]                                 <L 807>
        var_98 = wp::extract(var_91, var_97);
        var_99 = wp::mul(var_weight, var_98);
        var_101 = wp::add(var_start_idx, var_100);
        wp::array_store(var_residuals, var_0, var_101, var_99);
        // residuals[row, start_idx + 2] = weight * axis_angle[2]                                 <L 808>
        var_103 = wp::extract(var_91, var_102);
        var_104 = wp::mul(var_weight, var_103);
        var_106 = wp::add(var_start_idx, var_105);
        wp::array_store(var_residuals, var_0, var_106, var_104);
    }
}



extern "C" __global__ void _rot_residuals_41a9264e_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::vec_t<4, wp::float32>> var_target_rot,
    wp::int32 var_link_index,
    wp::quat_t<wp::float32> var_link_offset_rotation,
    bool var_canonicalize_quat_err,
    wp::int32 var_start_idx,
    wp::float32 var_weight,
    wp::array_t<wp::int32> var_problem_idx_map,
    wp::array_t<wp::float32> var_residuals,
    wp::array_t<wp::transform_t<wp::float32>> adj_body_q,
    wp::array_t<wp::vec_t<4, wp::float32>> adj_target_rot,
    wp::int32 adj_link_index,
    wp::quat_t<wp::float32> adj_link_offset_rotation,
    bool adj_canonicalize_quat_err,
    wp::int32 adj_start_idx,
    wp::float32 adj_weight,
    wp::array_t<wp::int32> adj_problem_idx_map,
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
        wp::int32* var_1;
        wp::int32 var_2;
        wp::int32 var_3;
        wp::transform_t<wp::float32>* var_4;
        wp::transform_t<wp::float32> var_5;
        wp::transform_t<wp::float32> var_6;
        const wp::int32 var_7 = 3;
        wp::float32 var_8;
        const wp::int32 var_9 = 4;
        wp::float32 var_10;
        const wp::int32 var_11 = 5;
        wp::float32 var_12;
        const wp::int32 var_13 = 6;
        wp::float32 var_14;
        wp::quat_t<wp::float32> var_15;
        wp::quat_t<wp::float32> var_16;
        wp::vec_t<4, wp::float32>* var_17;
        wp::vec_t<4, wp::float32> var_18;
        wp::vec_t<4, wp::float32> var_19;
        const wp::int32 var_20 = 0;
        wp::float32 var_21;
        const wp::int32 var_22 = 1;
        wp::float32 var_23;
        const wp::int32 var_24 = 2;
        wp::float32 var_25;
        const wp::int32 var_26 = 3;
        wp::float32 var_27;
        wp::quat_t<wp::float32> var_28;
        wp::quat_t<wp::float32> var_29;
        wp::quat_t<wp::float32> var_30;
        bool var_31;
        wp::float32 var_32;
        const wp::float32 var_33 = 0.0;
        bool var_34;
        wp::quat_t<wp::float32> var_35;
        wp::quat_t<wp::float32> var_36;
        const wp::int32 var_37 = 0;
        wp::float32 var_38;
        const wp::int32 var_39 = 0;
        wp::float32 var_40;
        wp::float32 var_41;
        const wp::int32 var_42 = 1;
        wp::float32 var_43;
        const wp::int32 var_44 = 1;
        wp::float32 var_45;
        wp::float32 var_46;
        wp::float32 var_47;
        const wp::int32 var_48 = 2;
        wp::float32 var_49;
        const wp::int32 var_50 = 2;
        wp::float32 var_51;
        wp::float32 var_52;
        wp::float32 var_53;
        wp::float32 var_54;
        const wp::float32 var_55 = 2.0;
        const wp::int32 var_56 = 3;
        wp::float32 var_57;
        wp::float32 var_58;
        wp::float32 var_59;
        const wp::float32 var_60 = 1e-08;
        wp::float32 var_61;
        const wp::float32 var_62 = 0.0;
        const wp::float32 var_63 = 0.0;
        const wp::float32 var_64 = 0.0;
        wp::vec_t<3, wp::float32> var_65;
        bool var_66;
        const wp::int32 var_67 = 0;
        wp::float32 var_68;
        wp::float32 var_69;
        const wp::int32 var_70 = 1;
        wp::float32 var_71;
        wp::float32 var_72;
        const wp::int32 var_73 = 2;
        wp::float32 var_74;
        wp::float32 var_75;
        wp::vec_t<3, wp::float32> var_76;
        wp::vec_t<3, wp::float32> var_77;
        const wp::float32 var_78 = 2.0;
        const wp::int32 var_79 = 0;
        wp::float32 var_80;
        wp::float32 var_81;
        const wp::float32 var_82 = 2.0;
        const wp::int32 var_83 = 1;
        wp::float32 var_84;
        wp::float32 var_85;
        const wp::float32 var_86 = 2.0;
        const wp::int32 var_87 = 2;
        wp::float32 var_88;
        wp::float32 var_89;
        wp::vec_t<3, wp::float32> var_90;
        wp::vec_t<3, wp::float32> var_91;
        const wp::int32 var_92 = 0;
        wp::float32 var_93;
        wp::float32 var_94;
        const wp::int32 var_95 = 0;
        wp::int32 var_96;
        const wp::int32 var_97 = 1;
        wp::float32 var_98;
        wp::float32 var_99;
        const wp::int32 var_100 = 1;
        wp::int32 var_101;
        const wp::int32 var_102 = 2;
        wp::float32 var_103;
        wp::float32 var_104;
        const wp::int32 var_105 = 2;
        wp::int32 var_106;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::int32 adj_2 = {};
        wp::int32 adj_3 = {};
        wp::transform_t<wp::float32> adj_4 = {};
        wp::transform_t<wp::float32> adj_5 = {};
        wp::transform_t<wp::float32> adj_6 = {};
        wp::int32 adj_7 = {};
        wp::float32 adj_8 = {};
        wp::int32 adj_9 = {};
        wp::float32 adj_10 = {};
        wp::int32 adj_11 = {};
        wp::float32 adj_12 = {};
        wp::int32 adj_13 = {};
        wp::float32 adj_14 = {};
        wp::quat_t<wp::float32> adj_15 = {};
        wp::quat_t<wp::float32> adj_16 = {};
        wp::vec_t<4, wp::float32> adj_17 = {};
        wp::vec_t<4, wp::float32> adj_18 = {};
        wp::vec_t<4, wp::float32> adj_19 = {};
        wp::int32 adj_20 = {};
        wp::float32 adj_21 = {};
        wp::int32 adj_22 = {};
        wp::float32 adj_23 = {};
        wp::int32 adj_24 = {};
        wp::float32 adj_25 = {};
        wp::int32 adj_26 = {};
        wp::float32 adj_27 = {};
        wp::quat_t<wp::float32> adj_28 = {};
        wp::quat_t<wp::float32> adj_29 = {};
        wp::quat_t<wp::float32> adj_30 = {};
        bool adj_31 = {};
        wp::float32 adj_32 = {};
        wp::float32 adj_33 = {};
        bool adj_34 = {};
        wp::quat_t<wp::float32> adj_35 = {};
        wp::quat_t<wp::float32> adj_36 = {};
        wp::int32 adj_37 = {};
        wp::float32 adj_38 = {};
        wp::int32 adj_39 = {};
        wp::float32 adj_40 = {};
        wp::float32 adj_41 = {};
        wp::int32 adj_42 = {};
        wp::float32 adj_43 = {};
        wp::int32 adj_44 = {};
        wp::float32 adj_45 = {};
        wp::float32 adj_46 = {};
        wp::float32 adj_47 = {};
        wp::int32 adj_48 = {};
        wp::float32 adj_49 = {};
        wp::int32 adj_50 = {};
        wp::float32 adj_51 = {};
        wp::float32 adj_52 = {};
        wp::float32 adj_53 = {};
        wp::float32 adj_54 = {};
        wp::float32 adj_55 = {};
        wp::int32 adj_56 = {};
        wp::float32 adj_57 = {};
        wp::float32 adj_58 = {};
        wp::float32 adj_59 = {};
        wp::float32 adj_60 = {};
        wp::float32 adj_61 = {};
        wp::float32 adj_62 = {};
        wp::float32 adj_63 = {};
        wp::float32 adj_64 = {};
        wp::vec_t<3, wp::float32> adj_65 = {};
        bool adj_66 = {};
        wp::int32 adj_67 = {};
        wp::float32 adj_68 = {};
        wp::float32 adj_69 = {};
        wp::int32 adj_70 = {};
        wp::float32 adj_71 = {};
        wp::float32 adj_72 = {};
        wp::int32 adj_73 = {};
        wp::float32 adj_74 = {};
        wp::float32 adj_75 = {};
        wp::vec_t<3, wp::float32> adj_76 = {};
        wp::vec_t<3, wp::float32> adj_77 = {};
        wp::float32 adj_78 = {};
        wp::int32 adj_79 = {};
        wp::float32 adj_80 = {};
        wp::float32 adj_81 = {};
        wp::float32 adj_82 = {};
        wp::int32 adj_83 = {};
        wp::float32 adj_84 = {};
        wp::float32 adj_85 = {};
        wp::float32 adj_86 = {};
        wp::int32 adj_87 = {};
        wp::float32 adj_88 = {};
        wp::float32 adj_89 = {};
        wp::vec_t<3, wp::float32> adj_90 = {};
        wp::vec_t<3, wp::float32> adj_91 = {};
        wp::int32 adj_92 = {};
        wp::float32 adj_93 = {};
        wp::float32 adj_94 = {};
        wp::int32 adj_95 = {};
        wp::int32 adj_96 = {};
        wp::int32 adj_97 = {};
        wp::float32 adj_98 = {};
        wp::float32 adj_99 = {};
        wp::int32 adj_100 = {};
        wp::int32 adj_101 = {};
        wp::int32 adj_102 = {};
        wp::float32 adj_103 = {};
        wp::float32 adj_104 = {};
        wp::int32 adj_105 = {};
        wp::int32 adj_106 = {};
        //---------
        // forward
        // def _rot_residuals(                                                                    <L 766>
        // row = wp.tid()                                                                         <L 778>
        var_0 = builtin_tid1d();
        // base = problem_idx_map[row]                                                            <L 779>
        var_1 = wp::address(var_problem_idx_map, var_0);
        var_3 = wp::load(var_1);
        var_2 = wp::copy(var_3);
        // body_tf = body_q[row, link_index]                                                      <L 781>
        var_4 = wp::address(var_body_q, var_0, var_link_index);
        var_6 = wp::load(var_4);
        var_5 = wp::copy(var_6);
        // body_rot = wp.quat(body_tf[3], body_tf[4], body_tf[5], body_tf[6])                     <L 782>
        var_8 = wp::extract(var_5, var_7);
        var_10 = wp::extract(var_5, var_9);
        var_12 = wp::extract(var_5, var_11);
        var_14 = wp::extract(var_5, var_13);
        var_15 = wp::quat_t<wp::float32>(var_8, var_10, var_12, var_14);
        // actual_rot = body_rot * link_offset_rotation                                           <L 784>
        var_16 = wp::mul(var_15, var_link_offset_rotation);
        // target_quat_vec = target_rot[base]                                                     <L 786>
        var_17 = wp::address(var_target_rot, var_2);
        var_19 = wp::load(var_17);
        var_18 = wp::copy(var_19);
        // target_quat = wp.quat(target_quat_vec[0], target_quat_vec[1], target_quat_vec[2], target_quat_vec[3])       <L 787>
        var_21 = wp::extract(var_18, var_20);
        var_23 = wp::extract(var_18, var_22);
        var_25 = wp::extract(var_18, var_24);
        var_27 = wp::extract(var_18, var_26);
        var_28 = wp::quat_t<wp::float32>(var_21, var_23, var_25, var_27);
        // q_err = actual_rot * wp.quat_inverse(target_quat)                                      <L 789>
        var_29 = wp::quat_inverse(var_28);
        var_30 = wp::mul(var_16, var_29);
        // if canonicalize_quat_err and wp.dot(actual_rot, target_quat) < 0.0:                    <L 790>
        var_31 = var_canonicalize_quat_err;
        if (var_31) {
            var_32 = wp::dot(var_16, var_28);
            var_34 = (var_32 < var_33);
            var_31 = var_31 && var_34;
        }
        if (var_31) {
            // q_err = -q_err                                                                     <L 791>
            var_35 = wp::neg(var_30);
        }
        var_36 = wp::where(var_31, var_35, var_30);
        // v_norm = wp.sqrt(q_err[0] * q_err[0] + q_err[1] * q_err[1] + q_err[2] * q_err[2])       <L 793>
        var_38 = wp::extract(var_36, var_37);
        var_40 = wp::extract(var_36, var_39);
        var_41 = wp::mul(var_38, var_40);
        var_43 = wp::extract(var_36, var_42);
        var_45 = wp::extract(var_36, var_44);
        var_46 = wp::mul(var_43, var_45);
        var_47 = wp::add(var_41, var_46);
        var_49 = wp::extract(var_36, var_48);
        var_51 = wp::extract(var_36, var_50);
        var_52 = wp::mul(var_49, var_51);
        var_53 = wp::add(var_47, var_52);
        var_54 = wp::sqrt(var_53);
        // angle = 2.0 * wp.atan2(v_norm, q_err[3])                                               <L 795>
        var_57 = wp::extract(var_36, var_56);
        var_58 = wp::atan2(var_54, var_57);
        var_59 = wp::mul(var_55, var_58);
        // eps = float(1e-8)                                                                      <L 797>
        var_61 = wp::float(var_60);
        // axis_angle = wp.vec3(0.0, 0.0, 0.0)                                                    <L 798>
        var_65 = wp::vec_t<3, wp::float32>(var_62, var_63, var_64);
        // if v_norm > eps:                                                                       <L 800>
        var_66 = (var_54 > var_61);
        if (var_66) {
            // axis = wp.vec3(q_err[0] / v_norm, q_err[1] / v_norm, q_err[2] / v_norm)            <L 801>
            var_68 = wp::extract(var_36, var_67);
            var_69 = wp::div(var_68, var_54);
            var_71 = wp::extract(var_36, var_70);
            var_72 = wp::div(var_71, var_54);
            var_74 = wp::extract(var_36, var_73);
            var_75 = wp::div(var_74, var_54);
            var_76 = wp::vec_t<3, wp::float32>(var_69, var_72, var_75);
            // axis_angle = axis * angle                                                          <L 802>
            var_77 = wp::mul(var_76, var_59);
        }
        if (!var_66) {
            // axis_angle = wp.vec3(2.0 * q_err[0], 2.0 * q_err[1], 2.0 * q_err[2])               <L 804>
            var_80 = wp::extract(var_36, var_79);
            var_81 = wp::mul(var_78, var_80);
            var_84 = wp::extract(var_36, var_83);
            var_85 = wp::mul(var_82, var_84);
            var_88 = wp::extract(var_36, var_87);
            var_89 = wp::mul(var_86, var_88);
            var_90 = wp::vec_t<3, wp::float32>(var_81, var_85, var_89);
        }
        var_91 = wp::where(var_66, var_77, var_90);
        // residuals[row, start_idx + 0] = weight * axis_angle[0]                                 <L 806>
        var_93 = wp::extract(var_91, var_92);
        var_94 = wp::mul(var_weight, var_93);
        var_96 = wp::add(var_start_idx, var_95);
        // wp::array_store(var_residuals, var_0, var_96, var_94);
        // residuals[row, start_idx + 1] = weight * axis_angle[1]                                 <L 807>
        var_98 = wp::extract(var_91, var_97);
        var_99 = wp::mul(var_weight, var_98);
        var_101 = wp::add(var_start_idx, var_100);
        // wp::array_store(var_residuals, var_0, var_101, var_99);
        // residuals[row, start_idx + 2] = weight * axis_angle[2]                                 <L 808>
        var_103 = wp::extract(var_91, var_102);
        var_104 = wp::mul(var_weight, var_103);
        var_106 = wp::add(var_start_idx, var_105);
        // wp::array_store(var_residuals, var_0, var_106, var_104);
        //---------
        // reverse
        wp::adj_array_store(var_residuals, var_0, var_106, var_104, adj_residuals, adj_0, adj_106, adj_104);
        wp::adj_add(var_start_idx, var_105, adj_start_idx, adj_105, adj_106);
        wp::adj_mul(var_weight, var_103, adj_weight, adj_103, adj_104);
        wp::adj_extract(var_91, var_102, adj_91, adj_102, adj_103);
        // adj: residuals[row, start_idx + 2] = weight * axis_angle[2]                            <L 808>
        wp::adj_array_store(var_residuals, var_0, var_101, var_99, adj_residuals, adj_0, adj_101, adj_99);
        wp::adj_add(var_start_idx, var_100, adj_start_idx, adj_100, adj_101);
        wp::adj_mul(var_weight, var_98, adj_weight, adj_98, adj_99);
        wp::adj_extract(var_91, var_97, adj_91, adj_97, adj_98);
        // adj: residuals[row, start_idx + 1] = weight * axis_angle[1]                            <L 807>
        wp::adj_array_store(var_residuals, var_0, var_96, var_94, adj_residuals, adj_0, adj_96, adj_94);
        wp::adj_add(var_start_idx, var_95, adj_start_idx, adj_95, adj_96);
        wp::adj_mul(var_weight, var_93, adj_weight, adj_93, adj_94);
        wp::adj_extract(var_91, var_92, adj_91, adj_92, adj_93);
        // adj: residuals[row, start_idx + 0] = weight * axis_angle[0]                            <L 806>
        wp::adj_where(var_66, var_77, var_90, adj_66, adj_77, adj_90, adj_91);
        if (!var_66) {
            wp::adj_vec_t(var_81, var_85, var_89, adj_81, adj_85, adj_89, adj_90);
            wp::adj_mul(var_86, var_88, adj_86, adj_88, adj_89);
            wp::adj_extract(var_36, var_87, adj_36, adj_87, adj_88);
            wp::adj_mul(var_82, var_84, adj_82, adj_84, adj_85);
            wp::adj_extract(var_36, var_83, adj_36, adj_83, adj_84);
            wp::adj_mul(var_78, var_80, adj_78, adj_80, adj_81);
            wp::adj_extract(var_36, var_79, adj_36, adj_79, adj_80);
            // adj: axis_angle = wp.vec3(2.0 * q_err[0], 2.0 * q_err[1], 2.0 * q_err[2])          <L 804>
        }
        if (var_66) {
            wp::adj_mul(var_76, var_59, adj_76, adj_59, adj_77);
            // adj: axis_angle = axis * angle                                                     <L 802>
            wp::adj_vec_t(var_69, var_72, var_75, adj_69, adj_72, adj_75, adj_76);
            wp::adj_div(var_74, var_54, var_75, adj_74, adj_54, adj_75);
            wp::adj_extract(var_36, var_73, adj_36, adj_73, adj_74);
            wp::adj_div(var_71, var_54, var_72, adj_71, adj_54, adj_72);
            wp::adj_extract(var_36, var_70, adj_36, adj_70, adj_71);
            wp::adj_div(var_68, var_54, var_69, adj_68, adj_54, adj_69);
            wp::adj_extract(var_36, var_67, adj_36, adj_67, adj_68);
            // adj: axis = wp.vec3(q_err[0] / v_norm, q_err[1] / v_norm, q_err[2] / v_norm)       <L 801>
        }
        // adj: if v_norm > eps:                                                                  <L 800>
        wp::adj_vec_t(var_62, var_63, var_64, adj_62, adj_63, adj_64, adj_65);
        // adj: axis_angle = wp.vec3(0.0, 0.0, 0.0)                                               <L 798>
        wp::adj_float(var_60, adj_60, adj_61);
        // adj: eps = float(1e-8)                                                                 <L 797>
        wp::adj_mul(var_55, var_58, adj_55, adj_58, adj_59);
        wp::adj_atan2(var_54, var_57, adj_54, adj_57, adj_58);
        wp::adj_extract(var_36, var_56, adj_36, adj_56, adj_57);
        // adj: angle = 2.0 * wp.atan2(v_norm, q_err[3])                                          <L 795>
        wp::adj_sqrt(var_53, var_54, adj_53, adj_54);
        wp::adj_add(var_47, var_52, adj_47, adj_52, adj_53);
        wp::adj_mul(var_49, var_51, adj_49, adj_51, adj_52);
        wp::adj_extract(var_36, var_50, adj_36, adj_50, adj_51);
        wp::adj_extract(var_36, var_48, adj_36, adj_48, adj_49);
        wp::adj_add(var_41, var_46, adj_41, adj_46, adj_47);
        wp::adj_mul(var_43, var_45, adj_43, adj_45, adj_46);
        wp::adj_extract(var_36, var_44, adj_36, adj_44, adj_45);
        wp::adj_extract(var_36, var_42, adj_36, adj_42, adj_43);
        wp::adj_mul(var_38, var_40, adj_38, adj_40, adj_41);
        wp::adj_extract(var_36, var_39, adj_36, adj_39, adj_40);
        wp::adj_extract(var_36, var_37, adj_36, adj_37, adj_38);
        // adj: v_norm = wp.sqrt(q_err[0] * q_err[0] + q_err[1] * q_err[1] + q_err[2] * q_err[2])  <L 793>
        wp::adj_where(var_31, var_35, var_30, adj_31, adj_35, adj_30, adj_36);
        if (var_31) {
            wp::adj_neg(var_30, adj_30, adj_35);
            // adj: q_err = -q_err                                                                <L 791>
        }
        if (var_31) {
            wp::adj_dot(var_16, var_28, adj_16, adj_28, adj_32);
        }
        // adj: if canonicalize_quat_err and wp.dot(actual_rot, target_quat) < 0.0:               <L 790>
        wp::adj_mul(var_16, var_29, adj_16, adj_29, adj_30);
        wp::adj_quat_inverse(var_28, adj_28, adj_29);
        // adj: q_err = actual_rot * wp.quat_inverse(target_quat)                                 <L 789>
        wp::adj_quat_t(var_21, var_23, var_25, var_27, adj_21, adj_23, adj_25, adj_27, adj_28);
        wp::adj_extract(var_18, var_26, adj_18, adj_26, adj_27);
        wp::adj_extract(var_18, var_24, adj_18, adj_24, adj_25);
        wp::adj_extract(var_18, var_22, adj_18, adj_22, adj_23);
        wp::adj_extract(var_18, var_20, adj_18, adj_20, adj_21);
        // adj: target_quat = wp.quat(target_quat_vec[0], target_quat_vec[1], target_quat_vec[2], target_quat_vec[3])  <L 787>
        wp::adj_copy(var_19, adj_17, adj_18);
        wp::adj_address(var_target_rot, var_2, adj_target_rot, adj_2, adj_17);
        // adj: target_quat_vec = target_rot[base]                                                <L 786>
        wp::adj_mul(var_15, var_link_offset_rotation, adj_15, adj_link_offset_rotation, adj_16);
        // adj: actual_rot = body_rot * link_offset_rotation                                      <L 784>
        wp::adj_quat_t(var_8, var_10, var_12, var_14, adj_8, adj_10, adj_12, adj_14, adj_15);
        wp::adj_extract(var_5, var_13, adj_5, adj_13, adj_14);
        wp::adj_extract(var_5, var_11, adj_5, adj_11, adj_12);
        wp::adj_extract(var_5, var_9, adj_5, adj_9, adj_10);
        wp::adj_extract(var_5, var_7, adj_5, adj_7, adj_8);
        // adj: body_rot = wp.quat(body_tf[3], body_tf[4], body_tf[5], body_tf[6])                <L 782>
        wp::adj_copy(var_6, adj_4, adj_5);
        wp::adj_address(var_body_q, var_0, var_link_index, adj_body_q, adj_0, adj_link_index, adj_4);
        // adj: body_tf = body_q[row, link_index]                                                 <L 781>
        wp::adj_copy(var_3, adj_1, adj_2);
        wp::adj_address(var_problem_idx_map, var_0, adj_problem_idx_map, adj_0, adj_1);
        // adj: base = problem_idx_map[row]                                                       <L 779>
        // adj: row = wp.tid()                                                                    <L 778>
        // adj: def _rot_residuals(                                                               <L 766>
        continue;
    }
}



extern "C" __global__ void _limit_jac_fill_78c0dfcc_cuda_kernel_forward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::float32> var_q_grad,
    wp::int32 var_n_dofs,
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
        wp::float32* var_2;
        wp::int32 var_3;
        wp::float32 var_4;
        //---------
        // forward
        // def _limit_jac_fill(                                                                   <L 529>
        // problem_idx, dof_idx = wp.tid()                                                        <L 536>
        builtin_tid2d(var_0, var_1);
        // jacobian[problem_idx, start_idx + dof_idx, dof_idx] = q_grad[problem_idx, dof_idx]       <L 538>
        var_2 = wp::address(var_q_grad, var_0, var_1);
        var_3 = wp::add(var_start_idx, var_1);
        var_4 = wp::load(var_2);
        wp::array_store(var_jacobian, var_0, var_3, var_1, var_4);
    }
}



extern "C" __global__ void _limit_jac_fill_78c0dfcc_cuda_kernel_backward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::float32> var_q_grad,
    wp::int32 var_n_dofs,
    wp::int32 var_start_idx,
    wp::array_t<wp::float32> var_jacobian,
    wp::array_t<wp::float32> adj_q_grad,
    wp::int32 adj_n_dofs,
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
        wp::float32* var_2;
        wp::int32 var_3;
        wp::float32 var_4;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::float32 adj_2 = {};
        wp::int32 adj_3 = {};
        wp::float32 adj_4 = {};
        //---------
        // forward
        // def _limit_jac_fill(                                                                   <L 529>
        // problem_idx, dof_idx = wp.tid()                                                        <L 536>
        builtin_tid2d(var_0, var_1);
        // jacobian[problem_idx, start_idx + dof_idx, dof_idx] = q_grad[problem_idx, dof_idx]       <L 538>
        var_2 = wp::address(var_q_grad, var_0, var_1);
        var_3 = wp::add(var_start_idx, var_1);
        var_4 = wp::load(var_2);
        // wp::array_store(var_jacobian, var_0, var_3, var_1, var_4);
        //---------
        // reverse
        wp::adj_array_store(var_jacobian, var_0, var_3, var_1, var_4, adj_jacobian, adj_0, adj_3, adj_1, adj_2);
        wp::adj_add(var_start_idx, var_1, adj_start_idx, adj_1, adj_3);
        wp::adj_address(var_q_grad, var_0, var_1, adj_q_grad, adj_0, adj_1, adj_2);
        // adj: jacobian[problem_idx, start_idx + dof_idx, dof_idx] = q_grad[problem_idx, dof_idx]  <L 538>
        // adj: problem_idx, dof_idx = wp.tid()                                                   <L 536>
        // adj: def _limit_jac_fill(                                                              <L 529>
        continue;
    }
}



extern "C" __global__ void _pos_jac_analytic_ce031784_cuda_kernel_forward(
    wp::launch_bounds_t<2> dim,
    wp::int32 var_link_index,
    wp::vec_t<3, wp::float32> var_link_offset,
    wp::array_t<wp::uint8> var_affects_dof,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::vec_t<6, wp::float32>> var_joint_S_s,
    wp::int32 var_start_idx,
    wp::int32 var_n_dofs,
    wp::float32 var_weight,
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
        wp::uint8* var_2;
        const wp::int32 var_3 = 0;
        bool var_4;
        wp::uint8 var_5;
        wp::transform_t<wp::float32>* var_6;
        wp::transform_t<wp::float32> var_7;
        wp::transform_t<wp::float32> var_8;
        const wp::int32 var_9 = 3;
        wp::float32 var_10;
        const wp::int32 var_11 = 4;
        wp::float32 var_12;
        const wp::int32 var_13 = 5;
        wp::float32 var_14;
        const wp::int32 var_15 = 6;
        wp::float32 var_16;
        wp::quat_t<wp::float32> var_17;
        const wp::int32 var_18 = 0;
        wp::float32 var_19;
        const wp::int32 var_20 = 1;
        wp::float32 var_21;
        const wp::int32 var_22 = 2;
        wp::float32 var_23;
        wp::vec_t<3, wp::float32> var_24;
        wp::vec_t<3, wp::float32> var_25;
        wp::vec_t<3, wp::float32> var_26;
        wp::vec_t<6, wp::float32>* var_27;
        wp::vec_t<6, wp::float32> var_28;
        wp::vec_t<6, wp::float32> var_29;
        const wp::int32 var_30 = 0;
        wp::float32 var_31;
        const wp::int32 var_32 = 1;
        wp::float32 var_33;
        const wp::int32 var_34 = 2;
        wp::float32 var_35;
        wp::vec_t<3, wp::float32> var_36;
        const wp::int32 var_37 = 3;
        wp::float32 var_38;
        const wp::int32 var_39 = 4;
        wp::float32 var_40;
        const wp::int32 var_41 = 5;
        wp::float32 var_42;
        wp::vec_t<3, wp::float32> var_43;
        wp::vec_t<3, wp::float32> var_44;
        wp::vec_t<3, wp::float32> var_45;
        wp::float32 var_46;
        const wp::int32 var_47 = 0;
        wp::float32 var_48;
        wp::float32 var_49;
        const wp::int32 var_50 = 0;
        wp::int32 var_51;
        wp::float32 var_52;
        const wp::int32 var_53 = 1;
        wp::float32 var_54;
        wp::float32 var_55;
        const wp::int32 var_56 = 1;
        wp::int32 var_57;
        wp::float32 var_58;
        const wp::int32 var_59 = 2;
        wp::float32 var_60;
        wp::float32 var_61;
        const wp::int32 var_62 = 2;
        wp::int32 var_63;
        //---------
        // forward
        // def _pos_jac_analytic(                                                                 <L 220>
        // problem_idx, dof_idx = wp.tid()                                                        <L 233>
        builtin_tid2d(var_0, var_1);
        // if affects_dof[dof_idx] == 0:                                                          <L 236>
        var_2 = wp::address(var_affects_dof, var_1);
        var_5 = wp::load(var_2);
        var_4 = (var_5 == var_3);
        if (var_4) {
            // return                                                                             <L 237>
            continue;
        }
        // body_tf = body_q[problem_idx, link_index]                                              <L 240>
        var_6 = wp::address(var_body_q, var_0, var_link_index);
        var_8 = wp::load(var_6);
        var_7 = wp::copy(var_8);
        // rot_w = wp.quat(body_tf[3], body_tf[4], body_tf[5], body_tf[6])                        <L 241>
        var_10 = wp::extract(var_7, var_9);
        var_12 = wp::extract(var_7, var_11);
        var_14 = wp::extract(var_7, var_13);
        var_16 = wp::extract(var_7, var_15);
        var_17 = wp::quat_t<wp::float32>(var_10, var_12, var_14, var_16);
        // pos_w = wp.vec3(body_tf[0], body_tf[1], body_tf[2])                                    <L 242>
        var_19 = wp::extract(var_7, var_18);
        var_21 = wp::extract(var_7, var_20);
        var_23 = wp::extract(var_7, var_22);
        var_24 = wp::vec_t<3, wp::float32>(var_19, var_21, var_23);
        // ee_pos_world = pos_w + wp.quat_rotate(rot_w, link_offset)                              <L 243>
        var_25 = wp::quat_rotate(var_17, var_link_offset);
        var_26 = wp::add(var_24, var_25);
        // S = joint_S_s[problem_idx, dof_idx]                                                    <L 246>
        var_27 = wp::address(var_joint_S_s, var_0, var_1);
        var_29 = wp::load(var_27);
        var_28 = wp::copy(var_29);
        // v_orig = wp.vec3(S[0], S[1], S[2])                                                     <L 247>
        var_31 = wp::extract(var_28, var_30);
        var_33 = wp::extract(var_28, var_32);
        var_35 = wp::extract(var_28, var_34);
        var_36 = wp::vec_t<3, wp::float32>(var_31, var_33, var_35);
        // omega = wp.vec3(S[3], S[4], S[5])                                                      <L 248>
        var_38 = wp::extract(var_28, var_37);
        var_40 = wp::extract(var_28, var_39);
        var_42 = wp::extract(var_28, var_41);
        var_43 = wp::vec_t<3, wp::float32>(var_38, var_40, var_42);
        // v_ee = v_orig + wp.cross(omega, ee_pos_world)                                          <L 249>
        var_44 = wp::cross(var_43, var_26);
        var_45 = wp::add(var_36, var_44);
        // jacobian[problem_idx, start_idx + 0, dof_idx] = -weight * v_ee[0]                      <L 252>
        var_46 = wp::neg(var_weight);
        var_48 = wp::extract(var_45, var_47);
        var_49 = wp::mul(var_46, var_48);
        var_51 = wp::add(var_start_idx, var_50);
        wp::array_store(var_jacobian, var_0, var_51, var_1, var_49);
        // jacobian[problem_idx, start_idx + 1, dof_idx] = -weight * v_ee[1]                      <L 253>
        var_52 = wp::neg(var_weight);
        var_54 = wp::extract(var_45, var_53);
        var_55 = wp::mul(var_52, var_54);
        var_57 = wp::add(var_start_idx, var_56);
        wp::array_store(var_jacobian, var_0, var_57, var_1, var_55);
        // jacobian[problem_idx, start_idx + 2, dof_idx] = -weight * v_ee[2]                      <L 254>
        var_58 = wp::neg(var_weight);
        var_60 = wp::extract(var_45, var_59);
        var_61 = wp::mul(var_58, var_60);
        var_63 = wp::add(var_start_idx, var_62);
        wp::array_store(var_jacobian, var_0, var_63, var_1, var_61);
    }
}



extern "C" __global__ void _pos_jac_analytic_ce031784_cuda_kernel_backward(
    wp::launch_bounds_t<2> dim,
    wp::int32 var_link_index,
    wp::vec_t<3, wp::float32> var_link_offset,
    wp::array_t<wp::uint8> var_affects_dof,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::vec_t<6, wp::float32>> var_joint_S_s,
    wp::int32 var_start_idx,
    wp::int32 var_n_dofs,
    wp::float32 var_weight,
    wp::array_t<wp::float32> var_jacobian,
    wp::int32 adj_link_index,
    wp::vec_t<3, wp::float32> adj_link_offset,
    wp::array_t<wp::uint8> adj_affects_dof,
    wp::array_t<wp::transform_t<wp::float32>> adj_body_q,
    wp::array_t<wp::vec_t<6, wp::float32>> adj_joint_S_s,
    wp::int32 adj_start_idx,
    wp::int32 adj_n_dofs,
    wp::float32 adj_weight,
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
        wp::uint8* var_2;
        const wp::int32 var_3 = 0;
        bool var_4;
        wp::uint8 var_5;
        wp::transform_t<wp::float32>* var_6;
        wp::transform_t<wp::float32> var_7;
        wp::transform_t<wp::float32> var_8;
        const wp::int32 var_9 = 3;
        wp::float32 var_10;
        const wp::int32 var_11 = 4;
        wp::float32 var_12;
        const wp::int32 var_13 = 5;
        wp::float32 var_14;
        const wp::int32 var_15 = 6;
        wp::float32 var_16;
        wp::quat_t<wp::float32> var_17;
        const wp::int32 var_18 = 0;
        wp::float32 var_19;
        const wp::int32 var_20 = 1;
        wp::float32 var_21;
        const wp::int32 var_22 = 2;
        wp::float32 var_23;
        wp::vec_t<3, wp::float32> var_24;
        wp::vec_t<3, wp::float32> var_25;
        wp::vec_t<3, wp::float32> var_26;
        wp::vec_t<6, wp::float32>* var_27;
        wp::vec_t<6, wp::float32> var_28;
        wp::vec_t<6, wp::float32> var_29;
        const wp::int32 var_30 = 0;
        wp::float32 var_31;
        const wp::int32 var_32 = 1;
        wp::float32 var_33;
        const wp::int32 var_34 = 2;
        wp::float32 var_35;
        wp::vec_t<3, wp::float32> var_36;
        const wp::int32 var_37 = 3;
        wp::float32 var_38;
        const wp::int32 var_39 = 4;
        wp::float32 var_40;
        const wp::int32 var_41 = 5;
        wp::float32 var_42;
        wp::vec_t<3, wp::float32> var_43;
        wp::vec_t<3, wp::float32> var_44;
        wp::vec_t<3, wp::float32> var_45;
        wp::float32 var_46;
        const wp::int32 var_47 = 0;
        wp::float32 var_48;
        wp::float32 var_49;
        const wp::int32 var_50 = 0;
        wp::int32 var_51;
        wp::float32 var_52;
        const wp::int32 var_53 = 1;
        wp::float32 var_54;
        wp::float32 var_55;
        const wp::int32 var_56 = 1;
        wp::int32 var_57;
        wp::float32 var_58;
        const wp::int32 var_59 = 2;
        wp::float32 var_60;
        wp::float32 var_61;
        const wp::int32 var_62 = 2;
        wp::int32 var_63;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::uint8 adj_2 = {};
        wp::int32 adj_3 = {};
        bool adj_4 = {};
        wp::uint8 adj_5 = {};
        wp::transform_t<wp::float32> adj_6 = {};
        wp::transform_t<wp::float32> adj_7 = {};
        wp::transform_t<wp::float32> adj_8 = {};
        wp::int32 adj_9 = {};
        wp::float32 adj_10 = {};
        wp::int32 adj_11 = {};
        wp::float32 adj_12 = {};
        wp::int32 adj_13 = {};
        wp::float32 adj_14 = {};
        wp::int32 adj_15 = {};
        wp::float32 adj_16 = {};
        wp::quat_t<wp::float32> adj_17 = {};
        wp::int32 adj_18 = {};
        wp::float32 adj_19 = {};
        wp::int32 adj_20 = {};
        wp::float32 adj_21 = {};
        wp::int32 adj_22 = {};
        wp::float32 adj_23 = {};
        wp::vec_t<3, wp::float32> adj_24 = {};
        wp::vec_t<3, wp::float32> adj_25 = {};
        wp::vec_t<3, wp::float32> adj_26 = {};
        wp::vec_t<6, wp::float32> adj_27 = {};
        wp::vec_t<6, wp::float32> adj_28 = {};
        wp::vec_t<6, wp::float32> adj_29 = {};
        wp::int32 adj_30 = {};
        wp::float32 adj_31 = {};
        wp::int32 adj_32 = {};
        wp::float32 adj_33 = {};
        wp::int32 adj_34 = {};
        wp::float32 adj_35 = {};
        wp::vec_t<3, wp::float32> adj_36 = {};
        wp::int32 adj_37 = {};
        wp::float32 adj_38 = {};
        wp::int32 adj_39 = {};
        wp::float32 adj_40 = {};
        wp::int32 adj_41 = {};
        wp::float32 adj_42 = {};
        wp::vec_t<3, wp::float32> adj_43 = {};
        wp::vec_t<3, wp::float32> adj_44 = {};
        wp::vec_t<3, wp::float32> adj_45 = {};
        wp::float32 adj_46 = {};
        wp::int32 adj_47 = {};
        wp::float32 adj_48 = {};
        wp::float32 adj_49 = {};
        wp::int32 adj_50 = {};
        wp::int32 adj_51 = {};
        wp::float32 adj_52 = {};
        wp::int32 adj_53 = {};
        wp::float32 adj_54 = {};
        wp::float32 adj_55 = {};
        wp::int32 adj_56 = {};
        wp::int32 adj_57 = {};
        wp::float32 adj_58 = {};
        wp::int32 adj_59 = {};
        wp::float32 adj_60 = {};
        wp::float32 adj_61 = {};
        wp::int32 adj_62 = {};
        wp::int32 adj_63 = {};
        //---------
        // forward
        // def _pos_jac_analytic(                                                                 <L 220>
        // problem_idx, dof_idx = wp.tid()                                                        <L 233>
        builtin_tid2d(var_0, var_1);
        // if affects_dof[dof_idx] == 0:                                                          <L 236>
        var_2 = wp::address(var_affects_dof, var_1);
        var_5 = wp::load(var_2);
        var_4 = (var_5 == var_3);
        if (var_4) {
            // return                                                                             <L 237>
            goto label0;
        }
        // body_tf = body_q[problem_idx, link_index]                                              <L 240>
        var_6 = wp::address(var_body_q, var_0, var_link_index);
        var_8 = wp::load(var_6);
        var_7 = wp::copy(var_8);
        // rot_w = wp.quat(body_tf[3], body_tf[4], body_tf[5], body_tf[6])                        <L 241>
        var_10 = wp::extract(var_7, var_9);
        var_12 = wp::extract(var_7, var_11);
        var_14 = wp::extract(var_7, var_13);
        var_16 = wp::extract(var_7, var_15);
        var_17 = wp::quat_t<wp::float32>(var_10, var_12, var_14, var_16);
        // pos_w = wp.vec3(body_tf[0], body_tf[1], body_tf[2])                                    <L 242>
        var_19 = wp::extract(var_7, var_18);
        var_21 = wp::extract(var_7, var_20);
        var_23 = wp::extract(var_7, var_22);
        var_24 = wp::vec_t<3, wp::float32>(var_19, var_21, var_23);
        // ee_pos_world = pos_w + wp.quat_rotate(rot_w, link_offset)                              <L 243>
        var_25 = wp::quat_rotate(var_17, var_link_offset);
        var_26 = wp::add(var_24, var_25);
        // S = joint_S_s[problem_idx, dof_idx]                                                    <L 246>
        var_27 = wp::address(var_joint_S_s, var_0, var_1);
        var_29 = wp::load(var_27);
        var_28 = wp::copy(var_29);
        // v_orig = wp.vec3(S[0], S[1], S[2])                                                     <L 247>
        var_31 = wp::extract(var_28, var_30);
        var_33 = wp::extract(var_28, var_32);
        var_35 = wp::extract(var_28, var_34);
        var_36 = wp::vec_t<3, wp::float32>(var_31, var_33, var_35);
        // omega = wp.vec3(S[3], S[4], S[5])                                                      <L 248>
        var_38 = wp::extract(var_28, var_37);
        var_40 = wp::extract(var_28, var_39);
        var_42 = wp::extract(var_28, var_41);
        var_43 = wp::vec_t<3, wp::float32>(var_38, var_40, var_42);
        // v_ee = v_orig + wp.cross(omega, ee_pos_world)                                          <L 249>
        var_44 = wp::cross(var_43, var_26);
        var_45 = wp::add(var_36, var_44);
        // jacobian[problem_idx, start_idx + 0, dof_idx] = -weight * v_ee[0]                      <L 252>
        var_46 = wp::neg(var_weight);
        var_48 = wp::extract(var_45, var_47);
        var_49 = wp::mul(var_46, var_48);
        var_51 = wp::add(var_start_idx, var_50);
        // wp::array_store(var_jacobian, var_0, var_51, var_1, var_49);
        // jacobian[problem_idx, start_idx + 1, dof_idx] = -weight * v_ee[1]                      <L 253>
        var_52 = wp::neg(var_weight);
        var_54 = wp::extract(var_45, var_53);
        var_55 = wp::mul(var_52, var_54);
        var_57 = wp::add(var_start_idx, var_56);
        // wp::array_store(var_jacobian, var_0, var_57, var_1, var_55);
        // jacobian[problem_idx, start_idx + 2, dof_idx] = -weight * v_ee[2]                      <L 254>
        var_58 = wp::neg(var_weight);
        var_60 = wp::extract(var_45, var_59);
        var_61 = wp::mul(var_58, var_60);
        var_63 = wp::add(var_start_idx, var_62);
        // wp::array_store(var_jacobian, var_0, var_63, var_1, var_61);
        //---------
        // reverse
        wp::adj_array_store(var_jacobian, var_0, var_63, var_1, var_61, adj_jacobian, adj_0, adj_63, adj_1, adj_61);
        wp::adj_add(var_start_idx, var_62, adj_start_idx, adj_62, adj_63);
        wp::adj_mul(var_58, var_60, adj_58, adj_60, adj_61);
        wp::adj_extract(var_45, var_59, adj_45, adj_59, adj_60);
        wp::adj_neg(var_weight, adj_weight, adj_58);
        // adj: jacobian[problem_idx, start_idx + 2, dof_idx] = -weight * v_ee[2]                 <L 254>
        wp::adj_array_store(var_jacobian, var_0, var_57, var_1, var_55, adj_jacobian, adj_0, adj_57, adj_1, adj_55);
        wp::adj_add(var_start_idx, var_56, adj_start_idx, adj_56, adj_57);
        wp::adj_mul(var_52, var_54, adj_52, adj_54, adj_55);
        wp::adj_extract(var_45, var_53, adj_45, adj_53, adj_54);
        wp::adj_neg(var_weight, adj_weight, adj_52);
        // adj: jacobian[problem_idx, start_idx + 1, dof_idx] = -weight * v_ee[1]                 <L 253>
        wp::adj_array_store(var_jacobian, var_0, var_51, var_1, var_49, adj_jacobian, adj_0, adj_51, adj_1, adj_49);
        wp::adj_add(var_start_idx, var_50, adj_start_idx, adj_50, adj_51);
        wp::adj_mul(var_46, var_48, adj_46, adj_48, adj_49);
        wp::adj_extract(var_45, var_47, adj_45, adj_47, adj_48);
        wp::adj_neg(var_weight, adj_weight, adj_46);
        // adj: jacobian[problem_idx, start_idx + 0, dof_idx] = -weight * v_ee[0]                 <L 252>
        wp::adj_add(var_36, var_44, adj_36, adj_44, adj_45);
        wp::adj_cross(var_43, var_26, adj_43, adj_26, adj_44);
        // adj: v_ee = v_orig + wp.cross(omega, ee_pos_world)                                     <L 249>
        wp::adj_vec_t(var_38, var_40, var_42, adj_38, adj_40, adj_42, adj_43);
        wp::adj_extract(var_28, var_41, adj_28, adj_41, adj_42);
        wp::adj_extract(var_28, var_39, adj_28, adj_39, adj_40);
        wp::adj_extract(var_28, var_37, adj_28, adj_37, adj_38);
        // adj: omega = wp.vec3(S[3], S[4], S[5])                                                 <L 248>
        wp::adj_vec_t(var_31, var_33, var_35, adj_31, adj_33, adj_35, adj_36);
        wp::adj_extract(var_28, var_34, adj_28, adj_34, adj_35);
        wp::adj_extract(var_28, var_32, adj_28, adj_32, adj_33);
        wp::adj_extract(var_28, var_30, adj_28, adj_30, adj_31);
        // adj: v_orig = wp.vec3(S[0], S[1], S[2])                                                <L 247>
        wp::adj_copy(var_29, adj_27, adj_28);
        wp::adj_address(var_joint_S_s, var_0, var_1, adj_joint_S_s, adj_0, adj_1, adj_27);
        // adj: S = joint_S_s[problem_idx, dof_idx]                                               <L 246>
        wp::adj_add(var_24, var_25, adj_24, adj_25, adj_26);
        wp::adj_quat_rotate(var_17, var_link_offset, adj_17, adj_link_offset, adj_25);
        // adj: ee_pos_world = pos_w + wp.quat_rotate(rot_w, link_offset)                         <L 243>
        wp::adj_vec_t(var_19, var_21, var_23, adj_19, adj_21, adj_23, adj_24);
        wp::adj_extract(var_7, var_22, adj_7, adj_22, adj_23);
        wp::adj_extract(var_7, var_20, adj_7, adj_20, adj_21);
        wp::adj_extract(var_7, var_18, adj_7, adj_18, adj_19);
        // adj: pos_w = wp.vec3(body_tf[0], body_tf[1], body_tf[2])                               <L 242>
        wp::adj_quat_t(var_10, var_12, var_14, var_16, adj_10, adj_12, adj_14, adj_16, adj_17);
        wp::adj_extract(var_7, var_15, adj_7, adj_15, adj_16);
        wp::adj_extract(var_7, var_13, adj_7, adj_13, adj_14);
        wp::adj_extract(var_7, var_11, adj_7, adj_11, adj_12);
        wp::adj_extract(var_7, var_9, adj_7, adj_9, adj_10);
        // adj: rot_w = wp.quat(body_tf[3], body_tf[4], body_tf[5], body_tf[6])                   <L 241>
        wp::adj_copy(var_8, adj_6, adj_7);
        wp::adj_address(var_body_q, var_0, var_link_index, adj_body_q, adj_0, adj_link_index, adj_6);
        // adj: body_tf = body_q[problem_idx, link_index]                                         <L 240>
        if (var_4) {
            label0:;
            // adj: return                                                                        <L 237>
        }
        wp::adj_address(var_affects_dof, var_1, adj_affects_dof, adj_1, adj_2);
        // adj: if affects_dof[dof_idx] == 0:                                                     <L 236>
        // adj: problem_idx, dof_idx = wp.tid()                                                   <L 233>
        // adj: def _pos_jac_analytic(                                                            <L 220>
        continue;
    }
}



extern "C" __global__ void _limit_jac_analytic_93de7b12_cuda_kernel_forward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::float32> var_joint_q,
    wp::array_t<wp::float32> var_joint_limit_lower,
    wp::array_t<wp::float32> var_joint_limit_upper,
    wp::array_t<wp::int32> var_dof_to_coord,
    wp::int32 var_n_dofs,
    wp::int32 var_start_idx,
    wp::float32 var_weight,
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
        const wp::float32 var_17 = 990000.0;
        bool var_18;
        const wp::float32 var_19 = 0.0;
        wp::float32 var_20;
        bool var_21;
        wp::float32 var_22;
        bool var_23;
        wp::float32 var_24;
        wp::float32 var_25;
        wp::float32 var_26;
        wp::int32 var_27;
        //---------
        // forward
        // def _limit_jac_analytic(                                                               <L 542>
        // problem, dof_idx = wp.tid()                                                            <L 553>
        builtin_tid2d(var_0, var_1);
        // coord_idx = dof_to_coord[dof_idx]                                                      <L 554>
        var_2 = wp::address(var_dof_to_coord, var_1);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // if coord_idx < 0:                                                                      <L 556>
        var_6 = (var_3 < var_5);
        if (var_6) {
            // return                                                                             <L 557>
            continue;
        }
        // q = joint_q[problem, coord_idx]                                                        <L 559>
        var_7 = wp::address(var_joint_q, var_0, var_3);
        var_9 = wp::load(var_7);
        var_8 = wp::copy(var_9);
        // lower = joint_limit_lower[dof_idx]                                                     <L 560>
        var_10 = wp::address(var_joint_limit_lower, var_1);
        var_12 = wp::load(var_10);
        var_11 = wp::copy(var_12);
        // upper = joint_limit_upper[dof_idx]                                                     <L 561>
        var_13 = wp::address(var_joint_limit_upper, var_1);
        var_15 = wp::load(var_13);
        var_14 = wp::copy(var_15);
        // if upper - lower > 9.9e5:                                                              <L 563>
        var_16 = wp::sub(var_14, var_11);
        var_18 = (var_16 > var_17);
        if (var_18) {
            // return                                                                             <L 564>
            continue;
        }
        // grad = float(0.0)                                                                      <L 566>
        var_20 = wp::float(var_19);
        // if q >= upper:                                                                         <L 567>
        var_21 = (var_8 >= var_14);
        if (var_21) {
            // grad = weight                                                                      <L 568>
            var_22 = wp::copy(var_weight);
        }
        if (!var_21) {
            // elif q <= lower:                                                                   <L 569>
            var_23 = (var_8 <= var_11);
            if (var_23) {
                // grad = -weight                                                                 <L 570>
                var_24 = wp::neg(var_weight);
            }
            var_25 = wp::where(var_23, var_24, var_20);
        }
        var_26 = wp::where(var_21, var_22, var_25);
        // jacobian[problem, start_idx + dof_idx, dof_idx] = grad                                 <L 572>
        var_27 = wp::add(var_start_idx, var_1);
        wp::array_store(var_jacobian, var_0, var_27, var_1, var_26);
    }
}



extern "C" __global__ void _limit_jac_analytic_93de7b12_cuda_kernel_backward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::float32> var_joint_q,
    wp::array_t<wp::float32> var_joint_limit_lower,
    wp::array_t<wp::float32> var_joint_limit_upper,
    wp::array_t<wp::int32> var_dof_to_coord,
    wp::int32 var_n_dofs,
    wp::int32 var_start_idx,
    wp::float32 var_weight,
    wp::array_t<wp::float32> var_jacobian,
    wp::array_t<wp::float32> adj_joint_q,
    wp::array_t<wp::float32> adj_joint_limit_lower,
    wp::array_t<wp::float32> adj_joint_limit_upper,
    wp::array_t<wp::int32> adj_dof_to_coord,
    wp::int32 adj_n_dofs,
    wp::int32 adj_start_idx,
    wp::float32 adj_weight,
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
        const wp::float32 var_17 = 990000.0;
        bool var_18;
        const wp::float32 var_19 = 0.0;
        wp::float32 var_20;
        bool var_21;
        wp::float32 var_22;
        bool var_23;
        wp::float32 var_24;
        wp::float32 var_25;
        wp::float32 var_26;
        wp::int32 var_27;
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
        wp::float32 adj_14 = {};
        wp::float32 adj_15 = {};
        wp::float32 adj_16 = {};
        wp::float32 adj_17 = {};
        bool adj_18 = {};
        wp::float32 adj_19 = {};
        wp::float32 adj_20 = {};
        bool adj_21 = {};
        wp::float32 adj_22 = {};
        bool adj_23 = {};
        wp::float32 adj_24 = {};
        wp::float32 adj_25 = {};
        wp::float32 adj_26 = {};
        wp::int32 adj_27 = {};
        //---------
        // forward
        // def _limit_jac_analytic(                                                               <L 542>
        // problem, dof_idx = wp.tid()                                                            <L 553>
        builtin_tid2d(var_0, var_1);
        // coord_idx = dof_to_coord[dof_idx]                                                      <L 554>
        var_2 = wp::address(var_dof_to_coord, var_1);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // if coord_idx < 0:                                                                      <L 556>
        var_6 = (var_3 < var_5);
        if (var_6) {
            // return                                                                             <L 557>
            goto label0;
        }
        // q = joint_q[problem, coord_idx]                                                        <L 559>
        var_7 = wp::address(var_joint_q, var_0, var_3);
        var_9 = wp::load(var_7);
        var_8 = wp::copy(var_9);
        // lower = joint_limit_lower[dof_idx]                                                     <L 560>
        var_10 = wp::address(var_joint_limit_lower, var_1);
        var_12 = wp::load(var_10);
        var_11 = wp::copy(var_12);
        // upper = joint_limit_upper[dof_idx]                                                     <L 561>
        var_13 = wp::address(var_joint_limit_upper, var_1);
        var_15 = wp::load(var_13);
        var_14 = wp::copy(var_15);
        // if upper - lower > 9.9e5:                                                              <L 563>
        var_16 = wp::sub(var_14, var_11);
        var_18 = (var_16 > var_17);
        if (var_18) {
            // return                                                                             <L 564>
            goto label1;
        }
        // grad = float(0.0)                                                                      <L 566>
        var_20 = wp::float(var_19);
        // if q >= upper:                                                                         <L 567>
        var_21 = (var_8 >= var_14);
        if (var_21) {
            // grad = weight                                                                      <L 568>
            var_22 = wp::copy(var_weight);
        }
        if (!var_21) {
            // elif q <= lower:                                                                   <L 569>
            var_23 = (var_8 <= var_11);
            if (var_23) {
                // grad = -weight                                                                 <L 570>
                var_24 = wp::neg(var_weight);
            }
            var_25 = wp::where(var_23, var_24, var_20);
        }
        var_26 = wp::where(var_21, var_22, var_25);
        // jacobian[problem, start_idx + dof_idx, dof_idx] = grad                                 <L 572>
        var_27 = wp::add(var_start_idx, var_1);
        // wp::array_store(var_jacobian, var_0, var_27, var_1, var_26);
        //---------
        // reverse
        wp::adj_array_store(var_jacobian, var_0, var_27, var_1, var_26, adj_jacobian, adj_0, adj_27, adj_1, adj_26);
        wp::adj_add(var_start_idx, var_1, adj_start_idx, adj_1, adj_27);
        // adj: jacobian[problem, start_idx + dof_idx, dof_idx] = grad                            <L 572>
        wp::adj_where(var_21, var_22, var_25, adj_21, adj_22, adj_25, adj_26);
        if (!var_21) {
            wp::adj_where(var_23, var_24, var_20, adj_23, adj_24, adj_20, adj_25);
            if (var_23) {
                wp::adj_neg(var_weight, adj_weight, adj_24);
                // adj: grad = -weight                                                            <L 570>
            }
            // adj: elif q <= lower:                                                              <L 569>
        }
        if (var_21) {
            wp::adj_copy(var_weight, adj_weight, adj_22);
            // adj: grad = weight                                                                 <L 568>
        }
        // adj: if q >= upper:                                                                    <L 567>
        wp::adj_float(var_19, adj_19, adj_20);
        // adj: grad = float(0.0)                                                                 <L 566>
        if (var_18) {
            label1:;
            // adj: return                                                                        <L 564>
        }
        wp::adj_sub(var_14, var_11, adj_14, adj_11, adj_16);
        // adj: if upper - lower > 9.9e5:                                                         <L 563>
        wp::adj_copy(var_15, adj_13, adj_14);
        wp::adj_address(var_joint_limit_upper, var_1, adj_joint_limit_upper, adj_1, adj_13);
        // adj: upper = joint_limit_upper[dof_idx]                                                <L 561>
        wp::adj_copy(var_12, adj_10, adj_11);
        wp::adj_address(var_joint_limit_lower, var_1, adj_joint_limit_lower, adj_1, adj_10);
        // adj: lower = joint_limit_lower[dof_idx]                                                <L 560>
        wp::adj_copy(var_9, adj_7, adj_8);
        wp::adj_address(var_joint_q, var_0, var_3, adj_joint_q, adj_0, adj_3, adj_7);
        // adj: q = joint_q[problem, coord_idx]                                                   <L 559>
        if (var_6) {
            label0:;
            // adj: return                                                                        <L 557>
        }
        // adj: if coord_idx < 0:                                                                 <L 556>
        wp::adj_copy(var_4, adj_2, adj_3);
        wp::adj_address(var_dof_to_coord, var_1, adj_dof_to_coord, adj_1, adj_2);
        // adj: coord_idx = dof_to_coord[dof_idx]                                                 <L 554>
        // adj: problem, dof_idx = wp.tid()                                                       <L 553>
        // adj: def _limit_jac_analytic(                                                          <L 542>
        continue;
    }
}



extern "C" __global__ void _update_rotation_target_7631472e_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::int32 var_problem_idx,
    wp::vec_t<4, wp::float32> var_new_rotation,
    wp::array_t<wp::vec_t<4, wp::float32>> var_target_array)
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
        // def _update_rotation_target(                                                           <L 829>
        // target_array[problem_idx] = new_rotation                                               <L 835>
        wp::array_store(var_target_array, var_problem_idx, var_new_rotation);
    }
}



extern "C" __global__ void _update_rotation_target_7631472e_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::int32 var_problem_idx,
    wp::vec_t<4, wp::float32> var_new_rotation,
    wp::array_t<wp::vec_t<4, wp::float32>> var_target_array,
    wp::int32 adj_problem_idx,
    wp::vec_t<4, wp::float32> adj_new_rotation,
    wp::array_t<wp::vec_t<4, wp::float32>> adj_target_array)
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
        // def _update_rotation_target(                                                           <L 829>
        // target_array[problem_idx] = new_rotation                                               <L 835>
        // wp::array_store(var_target_array, var_problem_idx, var_new_rotation);
        //---------
        // reverse
        wp::adj_array_store(var_target_array, var_problem_idx, var_new_rotation, adj_target_array, adj_problem_idx, adj_new_rotation);
        // adj: target_array[problem_idx] = new_rotation                                          <L 835>
        // adj: def _update_rotation_target(                                                      <L 829>
        continue;
    }
}



extern "C" __global__ void _limit_residuals_825db813_cuda_kernel_forward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::float32> var_joint_q,
    wp::array_t<wp::float32> var_joint_limit_lower,
    wp::array_t<wp::float32> var_joint_limit_upper,
    wp::array_t<wp::int32> var_dof_to_coord,
    wp::int32 var_n_dofs,
    wp::float32 var_weight,
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
        const wp::int32 var_5 = 0;
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
        const wp::float32 var_17 = 990000.0;
        bool var_18;
        const wp::float32 var_19 = 0.0;
        wp::float32 var_20;
        wp::float32 var_21;
        const wp::float32 var_22 = 0.0;
        wp::float32 var_23;
        wp::float32 var_24;
        wp::float32 var_25;
        wp::float32 var_26;
        wp::int32 var_27;
        //---------
        // forward
        // def _limit_residuals(                                                                  <L 499>
        // problem, dof_idx = wp.tid()                                                            <L 510>
        builtin_tid2d(var_0, var_1);
        // coord_idx = dof_to_coord[dof_idx]                                                      <L 511>
        var_2 = wp::address(var_dof_to_coord, var_1);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // if coord_idx < 0:                                                                      <L 513>
        var_6 = (var_3 < var_5);
        if (var_6) {
            // return                                                                             <L 514>
            continue;
        }
        // q = joint_q[problem, coord_idx]                                                        <L 516>
        var_7 = wp::address(var_joint_q, var_0, var_3);
        var_9 = wp::load(var_7);
        var_8 = wp::copy(var_9);
        // lower = joint_limit_lower[dof_idx]                                                     <L 517>
        var_10 = wp::address(var_joint_limit_lower, var_1);
        var_12 = wp::load(var_10);
        var_11 = wp::copy(var_12);
        // upper = joint_limit_upper[dof_idx]                                                     <L 518>
        var_13 = wp::address(var_joint_limit_upper, var_1);
        var_15 = wp::load(var_13);
        var_14 = wp::copy(var_15);
        // if upper - lower > 9.9e5:                                                              <L 521>
        var_16 = wp::sub(var_14, var_11);
        var_18 = (var_16 > var_17);
        if (var_18) {
            // return                                                                             <L 522>
            continue;
        }
        // viol = wp.max(0.0, q - upper) + wp.max(0.0, lower - q)                                 <L 524>
        var_20 = wp::sub(var_8, var_14);
        var_21 = wp::max(var_19, var_20);
        var_23 = wp::sub(var_11, var_8);
        var_24 = wp::max(var_22, var_23);
        var_25 = wp::add(var_21, var_24);
        // residuals[problem, start_idx + dof_idx] = weight * viol                                <L 525>
        var_26 = wp::mul(var_weight, var_25);
        var_27 = wp::add(var_start_idx, var_1);
        wp::array_store(var_residuals, var_0, var_27, var_26);
    }
}



extern "C" __global__ void _limit_residuals_825db813_cuda_kernel_backward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::float32> var_joint_q,
    wp::array_t<wp::float32> var_joint_limit_lower,
    wp::array_t<wp::float32> var_joint_limit_upper,
    wp::array_t<wp::int32> var_dof_to_coord,
    wp::int32 var_n_dofs,
    wp::float32 var_weight,
    wp::int32 var_start_idx,
    wp::array_t<wp::float32> var_residuals,
    wp::array_t<wp::float32> adj_joint_q,
    wp::array_t<wp::float32> adj_joint_limit_lower,
    wp::array_t<wp::float32> adj_joint_limit_upper,
    wp::array_t<wp::int32> adj_dof_to_coord,
    wp::int32 adj_n_dofs,
    wp::float32 adj_weight,
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
        const wp::int32 var_5 = 0;
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
        const wp::float32 var_17 = 990000.0;
        bool var_18;
        const wp::float32 var_19 = 0.0;
        wp::float32 var_20;
        wp::float32 var_21;
        const wp::float32 var_22 = 0.0;
        wp::float32 var_23;
        wp::float32 var_24;
        wp::float32 var_25;
        wp::float32 var_26;
        wp::int32 var_27;
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
        wp::float32 adj_14 = {};
        wp::float32 adj_15 = {};
        wp::float32 adj_16 = {};
        wp::float32 adj_17 = {};
        bool adj_18 = {};
        wp::float32 adj_19 = {};
        wp::float32 adj_20 = {};
        wp::float32 adj_21 = {};
        wp::float32 adj_22 = {};
        wp::float32 adj_23 = {};
        wp::float32 adj_24 = {};
        wp::float32 adj_25 = {};
        wp::float32 adj_26 = {};
        wp::int32 adj_27 = {};
        //---------
        // forward
        // def _limit_residuals(                                                                  <L 499>
        // problem, dof_idx = wp.tid()                                                            <L 510>
        builtin_tid2d(var_0, var_1);
        // coord_idx = dof_to_coord[dof_idx]                                                      <L 511>
        var_2 = wp::address(var_dof_to_coord, var_1);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // if coord_idx < 0:                                                                      <L 513>
        var_6 = (var_3 < var_5);
        if (var_6) {
            // return                                                                             <L 514>
            goto label0;
        }
        // q = joint_q[problem, coord_idx]                                                        <L 516>
        var_7 = wp::address(var_joint_q, var_0, var_3);
        var_9 = wp::load(var_7);
        var_8 = wp::copy(var_9);
        // lower = joint_limit_lower[dof_idx]                                                     <L 517>
        var_10 = wp::address(var_joint_limit_lower, var_1);
        var_12 = wp::load(var_10);
        var_11 = wp::copy(var_12);
        // upper = joint_limit_upper[dof_idx]                                                     <L 518>
        var_13 = wp::address(var_joint_limit_upper, var_1);
        var_15 = wp::load(var_13);
        var_14 = wp::copy(var_15);
        // if upper - lower > 9.9e5:                                                              <L 521>
        var_16 = wp::sub(var_14, var_11);
        var_18 = (var_16 > var_17);
        if (var_18) {
            // return                                                                             <L 522>
            goto label1;
        }
        // viol = wp.max(0.0, q - upper) + wp.max(0.0, lower - q)                                 <L 524>
        var_20 = wp::sub(var_8, var_14);
        var_21 = wp::max(var_19, var_20);
        var_23 = wp::sub(var_11, var_8);
        var_24 = wp::max(var_22, var_23);
        var_25 = wp::add(var_21, var_24);
        // residuals[problem, start_idx + dof_idx] = weight * viol                                <L 525>
        var_26 = wp::mul(var_weight, var_25);
        var_27 = wp::add(var_start_idx, var_1);
        // wp::array_store(var_residuals, var_0, var_27, var_26);
        //---------
        // reverse
        wp::adj_array_store(var_residuals, var_0, var_27, var_26, adj_residuals, adj_0, adj_27, adj_26);
        wp::adj_add(var_start_idx, var_1, adj_start_idx, adj_1, adj_27);
        wp::adj_mul(var_weight, var_25, adj_weight, adj_25, adj_26);
        // adj: residuals[problem, start_idx + dof_idx] = weight * viol                           <L 525>
        wp::adj_add(var_21, var_24, adj_21, adj_24, adj_25);
        wp::adj_max(var_22, var_23, adj_22, adj_23, adj_24);
        wp::adj_sub(var_11, var_8, adj_11, adj_8, adj_23);
        wp::adj_max(var_19, var_20, adj_19, adj_20, adj_21);
        wp::adj_sub(var_8, var_14, adj_8, adj_14, adj_20);
        // adj: viol = wp.max(0.0, q - upper) + wp.max(0.0, lower - q)                            <L 524>
        if (var_18) {
            label1:;
            // adj: return                                                                        <L 522>
        }
        wp::adj_sub(var_14, var_11, adj_14, adj_11, adj_16);
        // adj: if upper - lower > 9.9e5:                                                         <L 521>
        wp::adj_copy(var_15, adj_13, adj_14);
        wp::adj_address(var_joint_limit_upper, var_1, adj_joint_limit_upper, adj_1, adj_13);
        // adj: upper = joint_limit_upper[dof_idx]                                                <L 518>
        wp::adj_copy(var_12, adj_10, adj_11);
        wp::adj_address(var_joint_limit_lower, var_1, adj_joint_limit_lower, adj_1, adj_10);
        // adj: lower = joint_limit_lower[dof_idx]                                                <L 517>
        wp::adj_copy(var_9, adj_7, adj_8);
        wp::adj_address(var_joint_q, var_0, var_3, adj_joint_q, adj_0, adj_3, adj_7);
        // adj: q = joint_q[problem, coord_idx]                                                   <L 516>
        if (var_6) {
            label0:;
            // adj: return                                                                        <L 514>
        }
        // adj: if coord_idx < 0:                                                                 <L 513>
        wp::adj_copy(var_4, adj_2, adj_3);
        wp::adj_address(var_dof_to_coord, var_1, adj_dof_to_coord, adj_1, adj_2);
        // adj: coord_idx = dof_to_coord[dof_idx]                                                 <L 511>
        // adj: problem, dof_idx = wp.tid()                                                       <L 510>
        // adj: def _limit_residuals(                                                             <L 499>
        continue;
    }
}



extern "C" __global__ void _pos_jac_fill_3756bf9d_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::float32> var_q_grad,
    wp::int32 var_n_dofs,
    wp::int32 var_start_idx,
    wp::int32 var_component,
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
        wp::range_t var_2;
        wp::int32 var_3;
        wp::float32* var_4;
        wp::float32 var_5;
        //---------
        // forward
        // def _pos_jac_fill(                                                                     <L 184>
        // problem_idx = wp.tid()                                                                 <L 192>
        var_0 = builtin_tid1d();
        // residual_idx = start_idx + component                                                   <L 193>
        var_1 = wp::add(var_start_idx, var_component);
        // for j in range(n_dofs):                                                                <L 195>
        var_2 = wp::range(var_n_dofs);
        start_for_0:;
            if (iter_cmp(var_2) == 0) goto end_for_0;
            var_3 = wp::iter_next(var_2);
            // jacobian[problem_idx, residual_idx, j] = q_grad[problem_idx, j]                    <L 196>
            var_4 = wp::address(var_q_grad, var_0, var_3);
            var_5 = wp::load(var_4);
            wp::array_store(var_jacobian, var_0, var_1, var_3, var_5);
            goto start_for_0;
        end_for_0:;
    }
}



extern "C" __global__ void _pos_jac_fill_3756bf9d_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::float32> var_q_grad,
    wp::int32 var_n_dofs,
    wp::int32 var_start_idx,
    wp::int32 var_component,
    wp::array_t<wp::float32> var_jacobian,
    wp::array_t<wp::float32> adj_q_grad,
    wp::int32 adj_n_dofs,
    wp::int32 adj_start_idx,
    wp::int32 adj_component,
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
        wp::range_t var_2;
        wp::int32 var_3;
        wp::float32* var_4;
        wp::float32 var_5;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::range_t adj_2 = {};
        wp::int32 adj_3 = {};
        wp::float32 adj_4 = {};
        wp::float32 adj_5 = {};
        //---------
        // forward
        // def _pos_jac_fill(                                                                     <L 184>
        // problem_idx = wp.tid()                                                                 <L 192>
        var_0 = builtin_tid1d();
        // residual_idx = start_idx + component                                                   <L 193>
        var_1 = wp::add(var_start_idx, var_component);
        // for j in range(n_dofs):                                                                <L 195>
        var_2 = wp::range(var_n_dofs);
        //---------
        // reverse
        var_2 = wp::iter_reverse(var_2);
        start_for_0:;
            if (iter_cmp(var_2) == 0) goto end_for_0;
            var_3 = wp::iter_next(var_2);
        	adj_4 = {};
        	adj_5 = {};
            // jacobian[problem_idx, residual_idx, j] = q_grad[problem_idx, j]                    <L 196>
            var_4 = wp::address(var_q_grad, var_0, var_3);
            var_5 = wp::load(var_4);
            // wp::array_store(var_jacobian, var_0, var_1, var_3, var_5);
            wp::adj_array_store(var_jacobian, var_0, var_1, var_3, var_5, adj_jacobian, adj_0, adj_1, adj_3, adj_4);
            wp::adj_address(var_q_grad, var_0, var_3, adj_q_grad, adj_0, adj_3, adj_4);
            // adj: jacobian[problem_idx, residual_idx, j] = q_grad[problem_idx, j]               <L 196>
        	goto start_for_0;
        end_for_0:;
        // adj: for j in range(n_dofs):                                                           <L 195>
        wp::adj_add(var_start_idx, var_component, adj_start_idx, adj_component, adj_1);
        // adj: residual_idx = start_idx + component                                              <L 193>
        // adj: problem_idx = wp.tid()                                                            <L 192>
        // adj: def _pos_jac_fill(                                                                <L 184>
        continue;
    }
}



extern "C" __global__ void _update_position_target_436ffc9e_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::int32 var_problem_idx,
    wp::vec_t<3, wp::float32> var_new_position,
    wp::array_t<wp::vec_t<3, wp::float32>> var_target_array)
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
        // def _update_position_target(                                                           <L 200>
        // target_array[problem_idx] = new_position                                               <L 206>
        wp::array_store(var_target_array, var_problem_idx, var_new_position);
    }
}



extern "C" __global__ void _update_position_target_436ffc9e_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::int32 var_problem_idx,
    wp::vec_t<3, wp::float32> var_new_position,
    wp::array_t<wp::vec_t<3, wp::float32>> var_target_array,
    wp::int32 adj_problem_idx,
    wp::vec_t<3, wp::float32> adj_new_position,
    wp::array_t<wp::vec_t<3, wp::float32>> adj_target_array)
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
        // def _update_position_target(                                                           <L 200>
        // target_array[problem_idx] = new_position                                               <L 206>
        // wp::array_store(var_target_array, var_problem_idx, var_new_position);
        //---------
        // reverse
        wp::adj_array_store(var_target_array, var_problem_idx, var_new_position, adj_target_array, adj_problem_idx, adj_new_position);
        // adj: target_array[problem_idx] = new_position                                          <L 206>
        // adj: def _update_position_target(                                                      <L 200>
        continue;
    }
}

