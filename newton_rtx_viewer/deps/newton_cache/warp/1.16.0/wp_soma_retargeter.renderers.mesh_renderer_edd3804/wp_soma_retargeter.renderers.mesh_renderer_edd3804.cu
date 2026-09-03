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



extern "C" __global__ void update_skinned_transform_kernel_fb5f6ed8_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::int32 var_num_joints,
    wp::array_t<wp::transform_t<wp::float32>> var_local_transforms,
    wp::array_t<wp::int32> var_parent_indices,
    wp::array_t<wp::transform_t<wp::float32>> var_bind_transforms,
    wp::transform_t<wp::float32> var_character_transform,
    wp::array_t<wp::transform_t<wp::float32>> var_skinned_transforms)
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
        const wp::int32 var_1 = 0;
        wp::transform_t<wp::float32>* var_2;
        const wp::int32 var_3 = 0;
        wp::transform_t<wp::float32> var_4;
        const wp::int32 var_5 = 1;
        wp::range_t var_6;
        wp::int32 var_7;
        wp::int32* var_8;
        wp::transform_t<wp::float32>* var_9;
        wp::int32 var_10;
        wp::transform_t<wp::float32>* var_11;
        wp::transform_t<wp::float32> var_12;
        wp::transform_t<wp::float32> var_13;
        wp::transform_t<wp::float32> var_14;
        wp::range_t var_15;
        wp::int32 var_16;
        wp::transform_t<wp::float32>* var_17;
        wp::transform_t<wp::float32> var_18;
        wp::transform_t<wp::float32> var_19;
        wp::transform_t<wp::float32>* var_20;
        wp::transform_t<wp::float32> var_21;
        wp::transform_t<wp::float32> var_22;
        wp::transform_t<wp::float32> var_23;
        //---------
        // forward
        // def update_skinned_transform_kernel(                                                   <L 28>
        // frame = wp.tid()                                                                       <L 36>
        var_0 = builtin_tid1d();
        // skinned_transforms[frame, 0] = local_transforms[0]                                     <L 37>
        var_2 = wp::address(var_local_transforms, var_1);
        var_4 = wp::load(var_2);
        wp::array_store(var_skinned_transforms, var_0, var_3, var_4);
        // for joint_index in range(1, num_joints):                                               <L 38>
        var_6 = wp::range(var_5, var_num_joints);
        start_for_0:;
            if (iter_cmp(var_6) == 0) goto end_for_0;
            var_7 = wp::iter_next(var_6);
            // skinned_transforms[frame, joint_index] = skinned_transforms[frame, parent_indices[joint_index]] * local_transforms[joint_index]       <L 39>
            var_8 = wp::address(var_parent_indices, var_7);
            var_10 = wp::load(var_8);
            var_9 = wp::address(var_skinned_transforms, var_0, var_10);
            var_11 = wp::address(var_local_transforms, var_7);
            var_13 = wp::load(var_9);
            var_14 = wp::load(var_11);
            var_12 = wp::mul(var_13, var_14);
            wp::array_store(var_skinned_transforms, var_0, var_7, var_12);
            goto start_for_0;
        end_for_0:;
        // for joint_index in range(num_joints):                                                  <L 41>
        var_15 = wp::range(var_num_joints);
        start_for_2:;
            if (iter_cmp(var_15) == 0) goto end_for_2;
            var_16 = wp::iter_next(var_15);
            // skinned_transforms[frame, joint_index] = character_transform*skinned_transforms[frame, joint_index]*wp.transform_inverse(bind_transforms[joint_index])       <L 42>
            var_17 = wp::address(var_skinned_transforms, var_0, var_16);
            var_19 = wp::load(var_17);
            var_18 = wp::mul(var_character_transform, var_19);
            var_20 = wp::address(var_bind_transforms, var_16);
            var_22 = wp::load(var_20);
            var_21 = wp::transform_inverse(var_22);
            var_23 = wp::mul(var_18, var_21);
            wp::array_store(var_skinned_transforms, var_0, var_16, var_23);
            goto start_for_2;
        end_for_2:;
    }
}



extern "C" __global__ void update_skinned_transform_kernel_fb5f6ed8_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::int32 var_num_joints,
    wp::array_t<wp::transform_t<wp::float32>> var_local_transforms,
    wp::array_t<wp::int32> var_parent_indices,
    wp::array_t<wp::transform_t<wp::float32>> var_bind_transforms,
    wp::transform_t<wp::float32> var_character_transform,
    wp::array_t<wp::transform_t<wp::float32>> var_skinned_transforms,
    wp::int32 adj_num_joints,
    wp::array_t<wp::transform_t<wp::float32>> adj_local_transforms,
    wp::array_t<wp::int32> adj_parent_indices,
    wp::array_t<wp::transform_t<wp::float32>> adj_bind_transforms,
    wp::transform_t<wp::float32> adj_character_transform,
    wp::array_t<wp::transform_t<wp::float32>> adj_skinned_transforms)
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
        const wp::int32 var_1 = 0;
        wp::transform_t<wp::float32>* var_2;
        const wp::int32 var_3 = 0;
        wp::transform_t<wp::float32> var_4;
        const wp::int32 var_5 = 1;
        wp::range_t var_6;
        wp::int32 var_7;
        wp::int32* var_8;
        wp::transform_t<wp::float32>* var_9;
        wp::int32 var_10;
        wp::transform_t<wp::float32>* var_11;
        wp::transform_t<wp::float32> var_12;
        wp::transform_t<wp::float32> var_13;
        wp::transform_t<wp::float32> var_14;
        wp::range_t var_15;
        wp::int32 var_16;
        wp::transform_t<wp::float32>* var_17;
        wp::transform_t<wp::float32> var_18;
        wp::transform_t<wp::float32> var_19;
        wp::transform_t<wp::float32>* var_20;
        wp::transform_t<wp::float32> var_21;
        wp::transform_t<wp::float32> var_22;
        wp::transform_t<wp::float32> var_23;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::transform_t<wp::float32> adj_2 = {};
        wp::int32 adj_3 = {};
        wp::transform_t<wp::float32> adj_4 = {};
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
        wp::range_t adj_15 = {};
        wp::int32 adj_16 = {};
        wp::transform_t<wp::float32> adj_17 = {};
        wp::transform_t<wp::float32> adj_18 = {};
        wp::transform_t<wp::float32> adj_19 = {};
        wp::transform_t<wp::float32> adj_20 = {};
        wp::transform_t<wp::float32> adj_21 = {};
        wp::transform_t<wp::float32> adj_22 = {};
        wp::transform_t<wp::float32> adj_23 = {};
        //---------
        // forward
        // def update_skinned_transform_kernel(                                                   <L 28>
        // frame = wp.tid()                                                                       <L 36>
        var_0 = builtin_tid1d();
        // skinned_transforms[frame, 0] = local_transforms[0]                                     <L 37>
        var_2 = wp::address(var_local_transforms, var_1);
        var_4 = wp::load(var_2);
        // wp::array_store(var_skinned_transforms, var_0, var_3, var_4);
        // for joint_index in range(1, num_joints):                                               <L 38>
        var_6 = wp::range(var_5, var_num_joints);
        // for joint_index in range(num_joints):                                                  <L 41>
        var_15 = wp::range(var_num_joints);
        //---------
        // reverse
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
            // skinned_transforms[frame, joint_index] = character_transform*skinned_transforms[frame, joint_index]*wp.transform_inverse(bind_transforms[joint_index])       <L 42>
            var_17 = wp::address(var_skinned_transforms, var_0, var_16);
            var_19 = wp::load(var_17);
            var_18 = wp::mul(var_character_transform, var_19);
            var_20 = wp::address(var_bind_transforms, var_16);
            var_22 = wp::load(var_20);
            var_21 = wp::transform_inverse(var_22);
            var_23 = wp::mul(var_18, var_21);
            // wp::array_store(var_skinned_transforms, var_0, var_16, var_23);
            wp::adj_array_store(var_skinned_transforms, var_0, var_16, var_23, adj_skinned_transforms, adj_0, adj_16, adj_23);
            wp::adj_mul(var_18, var_21, adj_18, adj_21, adj_23);
            wp::adj_transform_inverse(var_22, adj_20, adj_21);
            wp::adj_address(var_bind_transforms, var_16, adj_bind_transforms, adj_16, adj_20);
            wp::adj_mul(var_character_transform, var_19, adj_character_transform, adj_17, adj_18);
            wp::adj_address(var_skinned_transforms, var_0, var_16, adj_skinned_transforms, adj_0, adj_16, adj_17);
            // adj: skinned_transforms[frame, joint_index] = character_transform*skinned_transforms[frame, joint_index]*wp.transform_inverse(bind_transforms[joint_index])  <L 42>
        	goto start_for_2;
        end_for_2:;
        // adj: for joint_index in range(num_joints):                                             <L 41>
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
            // skinned_transforms[frame, joint_index] = skinned_transforms[frame, parent_indices[joint_index]] * local_transforms[joint_index]       <L 39>
            var_8 = wp::address(var_parent_indices, var_7);
            var_10 = wp::load(var_8);
            var_9 = wp::address(var_skinned_transforms, var_0, var_10);
            var_11 = wp::address(var_local_transforms, var_7);
            var_13 = wp::load(var_9);
            var_14 = wp::load(var_11);
            var_12 = wp::mul(var_13, var_14);
            // wp::array_store(var_skinned_transforms, var_0, var_7, var_12);
            wp::adj_array_store(var_skinned_transforms, var_0, var_7, var_12, adj_skinned_transforms, adj_0, adj_7, adj_12);
            wp::adj_mul(var_13, var_14, adj_9, adj_11, adj_12);
            wp::adj_address(var_local_transforms, var_7, adj_local_transforms, adj_7, adj_11);
            wp::adj_address(var_skinned_transforms, var_0, var_10, adj_skinned_transforms, adj_0, adj_8, adj_9);
            wp::adj_address(var_parent_indices, var_7, adj_parent_indices, adj_7, adj_8);
            // adj: skinned_transforms[frame, joint_index] = skinned_transforms[frame, parent_indices[joint_index]] * local_transforms[joint_index]  <L 39>
        	goto start_for_0;
        end_for_0:;
        // adj: for joint_index in range(1, num_joints):                                          <L 38>
        wp::adj_array_store(var_skinned_transforms, var_0, var_3, var_4, adj_skinned_transforms, adj_0, adj_3, adj_2);
        wp::adj_address(var_local_transforms, var_1, adj_local_transforms, adj_1, adj_2);
        // adj: skinned_transforms[frame, 0] = local_transforms[0]                                <L 37>
        // adj: frame = wp.tid()                                                                  <L 36>
        // adj: def update_skinned_transform_kernel(                                              <L 28>
        continue;
    }
}



extern "C" __global__ void skinning_kernel_1eba8a71_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::vec_t<3, wp::float32>> var_points,
    wp::array_t<wp::int32> var_joint_indices,
    wp::array_t<wp::float32> var_joint_weights,
    wp::int32 var_num_influences,
    wp::array_t<wp::transform_t<wp::float32>> var_xform,
    wp::array_t<wp::vec_t<3, wp::float32>> var_output_points)
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
        const wp::float32 var_2 = 0.0;
        const wp::float32 var_3 = 0.0;
        wp::vec_t<3, wp::float32> var_4;
        wp::range_t var_5;
        wp::int32 var_6;
        wp::int32 var_7;
        wp::int32 var_8;
        wp::int32* var_9;
        wp::transform_t<wp::float32>* var_10;
        wp::int32 var_11;
        wp::vec_t<3, wp::float32>* var_12;
        wp::vec_t<3, wp::float32> var_13;
        wp::transform_t<wp::float32> var_14;
        wp::vec_t<3, wp::float32> var_15;
        wp::int32 var_16;
        wp::int32 var_17;
        wp::float32* var_18;
        wp::vec_t<3, wp::float32> var_19;
        wp::float32 var_20;
        wp::vec_t<3, wp::float32> var_21;
        //---------
        // forward
        // def skinning_kernel(                                                                   <L 13>
        // i = wp.tid()                                                                           <L 21>
        var_0 = builtin_tid1d();
        // output_points[i] = wp.vec3(0.0, 0.0, 0.0)                                              <L 22>
        var_4 = wp::vec_t<3, wp::float32>(var_1, var_2, var_3);
        wp::array_store(var_output_points, var_0, var_4);
        // for j in range(num_influences):                                                        <L 23>
        var_5 = wp::range(var_num_influences);
        start_for_0:;
            if (iter_cmp(var_5) == 0) goto end_for_0;
            var_6 = wp::iter_next(var_5);
            // output_points[i] += wp.transform_point(xform[joint_indices[i*num_influences + j]], points[i]) * joint_weights[i*num_influences + j]       <L 24>
            var_7 = wp::mul(var_0, var_num_influences);
            var_8 = wp::add(var_7, var_6);
            var_9 = wp::address(var_joint_indices, var_8);
            var_11 = wp::load(var_9);
            var_10 = wp::address(var_xform, var_11);
            var_12 = wp::address(var_points, var_0);
            var_14 = wp::load(var_10);
            var_15 = wp::load(var_12);
            var_13 = wp::transform_point(var_14, var_15);
            var_16 = wp::mul(var_0, var_num_influences);
            var_17 = wp::add(var_16, var_6);
            var_18 = wp::address(var_joint_weights, var_17);
            var_20 = wp::load(var_18);
            var_19 = wp::mul(var_13, var_20);
            var_21 = wp::atomic_add(var_output_points, var_0, var_19);
            goto start_for_0;
        end_for_0:;
    }
}



extern "C" __global__ void skinning_kernel_1eba8a71_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::vec_t<3, wp::float32>> var_points,
    wp::array_t<wp::int32> var_joint_indices,
    wp::array_t<wp::float32> var_joint_weights,
    wp::int32 var_num_influences,
    wp::array_t<wp::transform_t<wp::float32>> var_xform,
    wp::array_t<wp::vec_t<3, wp::float32>> var_output_points,
    wp::array_t<wp::vec_t<3, wp::float32>> adj_points,
    wp::array_t<wp::int32> adj_joint_indices,
    wp::array_t<wp::float32> adj_joint_weights,
    wp::int32 adj_num_influences,
    wp::array_t<wp::transform_t<wp::float32>> adj_xform,
    wp::array_t<wp::vec_t<3, wp::float32>> adj_output_points)
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
        const wp::float32 var_2 = 0.0;
        const wp::float32 var_3 = 0.0;
        wp::vec_t<3, wp::float32> var_4;
        wp::range_t var_5;
        wp::int32 var_6;
        wp::int32 var_7;
        wp::int32 var_8;
        wp::int32* var_9;
        wp::transform_t<wp::float32>* var_10;
        wp::int32 var_11;
        wp::vec_t<3, wp::float32>* var_12;
        wp::vec_t<3, wp::float32> var_13;
        wp::transform_t<wp::float32> var_14;
        wp::vec_t<3, wp::float32> var_15;
        wp::int32 var_16;
        wp::int32 var_17;
        wp::float32* var_18;
        wp::vec_t<3, wp::float32> var_19;
        wp::float32 var_20;
        wp::vec_t<3, wp::float32> var_21;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::float32 adj_1 = {};
        wp::float32 adj_2 = {};
        wp::float32 adj_3 = {};
        wp::vec_t<3, wp::float32> adj_4 = {};
        wp::range_t adj_5 = {};
        wp::int32 adj_6 = {};
        wp::int32 adj_7 = {};
        wp::int32 adj_8 = {};
        wp::int32 adj_9 = {};
        wp::transform_t<wp::float32> adj_10 = {};
        wp::int32 adj_11 = {};
        wp::vec_t<3, wp::float32> adj_12 = {};
        wp::vec_t<3, wp::float32> adj_13 = {};
        wp::transform_t<wp::float32> adj_14 = {};
        wp::vec_t<3, wp::float32> adj_15 = {};
        wp::int32 adj_16 = {};
        wp::int32 adj_17 = {};
        wp::float32 adj_18 = {};
        wp::vec_t<3, wp::float32> adj_19 = {};
        wp::float32 adj_20 = {};
        wp::vec_t<3, wp::float32> adj_21 = {};
        //---------
        // forward
        // def skinning_kernel(                                                                   <L 13>
        // i = wp.tid()                                                                           <L 21>
        var_0 = builtin_tid1d();
        // output_points[i] = wp.vec3(0.0, 0.0, 0.0)                                              <L 22>
        var_4 = wp::vec_t<3, wp::float32>(var_1, var_2, var_3);
        // wp::array_store(var_output_points, var_0, var_4);
        // for j in range(num_influences):                                                        <L 23>
        var_5 = wp::range(var_num_influences);
        //---------
        // reverse
        var_5 = wp::iter_reverse(var_5);
        start_for_0:;
            if (iter_cmp(var_5) == 0) goto end_for_0;
            var_6 = wp::iter_next(var_5);
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
            // output_points[i] += wp.transform_point(xform[joint_indices[i*num_influences + j]], points[i]) * joint_weights[i*num_influences + j]       <L 24>
            var_7 = wp::mul(var_0, var_num_influences);
            var_8 = wp::add(var_7, var_6);
            var_9 = wp::address(var_joint_indices, var_8);
            var_11 = wp::load(var_9);
            var_10 = wp::address(var_xform, var_11);
            var_12 = wp::address(var_points, var_0);
            var_14 = wp::load(var_10);
            var_15 = wp::load(var_12);
            var_13 = wp::transform_point(var_14, var_15);
            var_16 = wp::mul(var_0, var_num_influences);
            var_17 = wp::add(var_16, var_6);
            var_18 = wp::address(var_joint_weights, var_17);
            var_20 = wp::load(var_18);
            var_19 = wp::mul(var_13, var_20);
            // var_21 = wp::atomic_add(var_output_points, var_0, var_19);
            wp::adj_atomic_add(var_output_points, var_0, var_19, adj_output_points, adj_0, adj_19, adj_21);
            wp::adj_mul(var_13, var_20, adj_13, adj_18, adj_19);
            wp::adj_address(var_joint_weights, var_17, adj_joint_weights, adj_17, adj_18);
            wp::adj_add(var_16, var_6, adj_16, adj_6, adj_17);
            wp::adj_mul(var_0, var_num_influences, adj_0, adj_num_influences, adj_16);
            wp::adj_transform_point(var_14, var_15, adj_10, adj_12, adj_13);
            wp::adj_address(var_points, var_0, adj_points, adj_0, adj_12);
            wp::adj_address(var_xform, var_11, adj_xform, adj_9, adj_10);
            wp::adj_address(var_joint_indices, var_8, adj_joint_indices, adj_8, adj_9);
            wp::adj_add(var_7, var_6, adj_7, adj_6, adj_8);
            wp::adj_mul(var_0, var_num_influences, adj_0, adj_num_influences, adj_7);
            // adj: output_points[i] += wp.transform_point(xform[joint_indices[i*num_influences + j]], points[i]) * joint_weights[i*num_influences + j]  <L 24>
        	goto start_for_0;
        end_for_0:;
        // adj: for j in range(num_influences):                                                   <L 23>
        wp::adj_array_store(var_output_points, var_0, var_4, adj_output_points, adj_0, adj_4);
        wp::adj_vec_t(var_1, var_2, var_3, adj_1, adj_2, adj_3, adj_4);
        // adj: output_points[i] = wp.vec3(0.0, 0.0, 0.0)                                         <L 22>
        // adj: i = wp.tid()                                                                      <L 21>
        // adj: def skinning_kernel(                                                              <L 13>
        continue;
    }
}

