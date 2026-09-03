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



extern "C" __global__ void _compute_coordinate_lines_kernel_357f50ca_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::transform_t<wp::float32>> var_in_transforms,
    wp::float32 var_in_scale,
    wp::array_t<wp::vec_t<3, wp::float32>> var_out_axes_starts,
    wp::array_t<wp::vec_t<3, wp::float32>> var_out_axes_ends,
    wp::array_t<wp::vec_t<3, wp::float32>> var_out_axes_colors)
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
        const wp::int32 var_4 = 3;
        wp::int32 var_5;
        wp::vec_t<3, wp::float32> var_6;
        const wp::int32 var_7 = 0;
        wp::int32 var_8;
        wp::vec_t<3, wp::float32> var_9;
        const wp::int32 var_10 = 1;
        wp::int32 var_11;
        wp::vec_t<3, wp::float32> var_12;
        const wp::int32 var_13 = 2;
        wp::int32 var_14;
        wp::vec_t<3, wp::float32> var_15;
        wp::quat_t<wp::float32> var_16;
        const wp::float32 var_17 = 1.0;
        const wp::float32 var_18 = 0.0;
        const wp::float32 var_19 = 0.0;
        wp::vec_t<3, wp::float32> var_20;
        wp::vec_t<3, wp::float32> var_21;
        wp::vec_t<3, wp::float32> var_22;
        wp::vec_t<3, wp::float32> var_23;
        const wp::int32 var_24 = 0;
        wp::int32 var_25;
        wp::vec_t<3, wp::float32> var_26;
        wp::quat_t<wp::float32> var_27;
        const wp::float32 var_28 = 0.0;
        const wp::float32 var_29 = 1.0;
        const wp::float32 var_30 = 0.0;
        wp::vec_t<3, wp::float32> var_31;
        wp::vec_t<3, wp::float32> var_32;
        wp::vec_t<3, wp::float32> var_33;
        wp::vec_t<3, wp::float32> var_34;
        const wp::int32 var_35 = 1;
        wp::int32 var_36;
        wp::vec_t<3, wp::float32> var_37;
        wp::quat_t<wp::float32> var_38;
        const wp::float32 var_39 = 0.0;
        const wp::float32 var_40 = 0.0;
        const wp::float32 var_41 = 1.0;
        wp::vec_t<3, wp::float32> var_42;
        wp::vec_t<3, wp::float32> var_43;
        wp::vec_t<3, wp::float32> var_44;
        wp::vec_t<3, wp::float32> var_45;
        const wp::int32 var_46 = 2;
        wp::int32 var_47;
        const wp::float32 var_48 = 1.0;
        const wp::float32 var_49 = 0.0;
        const wp::float32 var_50 = 0.0;
        wp::vec_t<3, wp::float32> var_51;
        const wp::int32 var_52 = 0;
        wp::int32 var_53;
        const wp::float32 var_54 = 0.0;
        const wp::float32 var_55 = 1.0;
        const wp::float32 var_56 = 0.0;
        wp::vec_t<3, wp::float32> var_57;
        const wp::int32 var_58 = 1;
        wp::int32 var_59;
        const wp::float32 var_60 = 0.0;
        const wp::float32 var_61 = 0.0;
        const wp::float32 var_62 = 1.0;
        wp::vec_t<3, wp::float32> var_63;
        const wp::int32 var_64 = 2;
        wp::int32 var_65;
        //---------
        // forward
        // def _compute_coordinate_lines_kernel(                                                  <L 13>
        // in_idx = wp.tid()                                                                      <L 20>
        var_0 = builtin_tid1d();
        // in_tx = in_transforms[in_idx]                                                          <L 21>
        var_1 = wp::address(var_in_transforms, var_0);
        var_3 = wp::load(var_1);
        var_2 = wp::copy(var_3);
        // out_idx = in_idx * 3                                                                   <L 23>
        var_5 = wp::mul(var_0, var_4);
        // out_axes_starts[out_idx + 0] = in_tx.p                                                 <L 24>
        var_6 = wp::transform_get_translation(var_2);
        var_8 = wp::add(var_5, var_7);
        wp::array_store(var_out_axes_starts, var_8, var_6);
        // out_axes_starts[out_idx + 1] = in_tx.p                                                 <L 25>
        var_9 = wp::transform_get_translation(var_2);
        var_11 = wp::add(var_5, var_10);
        wp::array_store(var_out_axes_starts, var_11, var_9);
        // out_axes_starts[out_idx + 2] = in_tx.p                                                 <L 26>
        var_12 = wp::transform_get_translation(var_2);
        var_14 = wp::add(var_5, var_13);
        wp::array_store(var_out_axes_starts, var_14, var_12);
        // out_axes_ends[out_idx + 0] = in_tx.p + wp.mul(wp.quat_rotate(in_tx.q, wp.vec3(1.0, 0.0, 0.0)), in_scale)       <L 28>
        var_15 = wp::transform_get_translation(var_2);
        var_16 = wp::transform_get_rotation(var_2);
        var_20 = wp::vec_t<3, wp::float32>(var_17, var_18, var_19);
        var_21 = wp::quat_rotate(var_16, var_20);
        var_22 = wp::mul(var_21, var_in_scale);
        var_23 = wp::add(var_15, var_22);
        var_25 = wp::add(var_5, var_24);
        wp::array_store(var_out_axes_ends, var_25, var_23);
        // out_axes_ends[out_idx + 1] = in_tx.p + wp.mul(wp.quat_rotate(in_tx.q, wp.vec3(0.0, 1.0, 0.0)), in_scale)       <L 29>
        var_26 = wp::transform_get_translation(var_2);
        var_27 = wp::transform_get_rotation(var_2);
        var_31 = wp::vec_t<3, wp::float32>(var_28, var_29, var_30);
        var_32 = wp::quat_rotate(var_27, var_31);
        var_33 = wp::mul(var_32, var_in_scale);
        var_34 = wp::add(var_26, var_33);
        var_36 = wp::add(var_5, var_35);
        wp::array_store(var_out_axes_ends, var_36, var_34);
        // out_axes_ends[out_idx + 2] = in_tx.p + wp.mul(wp.quat_rotate(in_tx.q, wp.vec3(0.0, 0.0, 1.0)), in_scale)       <L 30>
        var_37 = wp::transform_get_translation(var_2);
        var_38 = wp::transform_get_rotation(var_2);
        var_42 = wp::vec_t<3, wp::float32>(var_39, var_40, var_41);
        var_43 = wp::quat_rotate(var_38, var_42);
        var_44 = wp::mul(var_43, var_in_scale);
        var_45 = wp::add(var_37, var_44);
        var_47 = wp::add(var_5, var_46);
        wp::array_store(var_out_axes_ends, var_47, var_45);
        // out_axes_colors[out_idx + 0] = wp.vec3(1.0, 0.0, 0.0)                                  <L 32>
        var_51 = wp::vec_t<3, wp::float32>(var_48, var_49, var_50);
        var_53 = wp::add(var_5, var_52);
        wp::array_store(var_out_axes_colors, var_53, var_51);
        // out_axes_colors[out_idx + 1] = wp.vec3(0.0, 1.0, 0.0)                                  <L 33>
        var_57 = wp::vec_t<3, wp::float32>(var_54, var_55, var_56);
        var_59 = wp::add(var_5, var_58);
        wp::array_store(var_out_axes_colors, var_59, var_57);
        // out_axes_colors[out_idx + 2] = wp.vec3(0.0, 0.0, 1.0)                                  <L 34>
        var_63 = wp::vec_t<3, wp::float32>(var_60, var_61, var_62);
        var_65 = wp::add(var_5, var_64);
        wp::array_store(var_out_axes_colors, var_65, var_63);
    }
}



extern "C" __global__ void _compute_coordinate_lines_kernel_357f50ca_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::transform_t<wp::float32>> var_in_transforms,
    wp::float32 var_in_scale,
    wp::array_t<wp::vec_t<3, wp::float32>> var_out_axes_starts,
    wp::array_t<wp::vec_t<3, wp::float32>> var_out_axes_ends,
    wp::array_t<wp::vec_t<3, wp::float32>> var_out_axes_colors,
    wp::array_t<wp::transform_t<wp::float32>> adj_in_transforms,
    wp::float32 adj_in_scale,
    wp::array_t<wp::vec_t<3, wp::float32>> adj_out_axes_starts,
    wp::array_t<wp::vec_t<3, wp::float32>> adj_out_axes_ends,
    wp::array_t<wp::vec_t<3, wp::float32>> adj_out_axes_colors)
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
        const wp::int32 var_4 = 3;
        wp::int32 var_5;
        wp::vec_t<3, wp::float32> var_6;
        const wp::int32 var_7 = 0;
        wp::int32 var_8;
        wp::vec_t<3, wp::float32> var_9;
        const wp::int32 var_10 = 1;
        wp::int32 var_11;
        wp::vec_t<3, wp::float32> var_12;
        const wp::int32 var_13 = 2;
        wp::int32 var_14;
        wp::vec_t<3, wp::float32> var_15;
        wp::quat_t<wp::float32> var_16;
        const wp::float32 var_17 = 1.0;
        const wp::float32 var_18 = 0.0;
        const wp::float32 var_19 = 0.0;
        wp::vec_t<3, wp::float32> var_20;
        wp::vec_t<3, wp::float32> var_21;
        wp::vec_t<3, wp::float32> var_22;
        wp::vec_t<3, wp::float32> var_23;
        const wp::int32 var_24 = 0;
        wp::int32 var_25;
        wp::vec_t<3, wp::float32> var_26;
        wp::quat_t<wp::float32> var_27;
        const wp::float32 var_28 = 0.0;
        const wp::float32 var_29 = 1.0;
        const wp::float32 var_30 = 0.0;
        wp::vec_t<3, wp::float32> var_31;
        wp::vec_t<3, wp::float32> var_32;
        wp::vec_t<3, wp::float32> var_33;
        wp::vec_t<3, wp::float32> var_34;
        const wp::int32 var_35 = 1;
        wp::int32 var_36;
        wp::vec_t<3, wp::float32> var_37;
        wp::quat_t<wp::float32> var_38;
        const wp::float32 var_39 = 0.0;
        const wp::float32 var_40 = 0.0;
        const wp::float32 var_41 = 1.0;
        wp::vec_t<3, wp::float32> var_42;
        wp::vec_t<3, wp::float32> var_43;
        wp::vec_t<3, wp::float32> var_44;
        wp::vec_t<3, wp::float32> var_45;
        const wp::int32 var_46 = 2;
        wp::int32 var_47;
        const wp::float32 var_48 = 1.0;
        const wp::float32 var_49 = 0.0;
        const wp::float32 var_50 = 0.0;
        wp::vec_t<3, wp::float32> var_51;
        const wp::int32 var_52 = 0;
        wp::int32 var_53;
        const wp::float32 var_54 = 0.0;
        const wp::float32 var_55 = 1.0;
        const wp::float32 var_56 = 0.0;
        wp::vec_t<3, wp::float32> var_57;
        const wp::int32 var_58 = 1;
        wp::int32 var_59;
        const wp::float32 var_60 = 0.0;
        const wp::float32 var_61 = 0.0;
        const wp::float32 var_62 = 1.0;
        wp::vec_t<3, wp::float32> var_63;
        const wp::int32 var_64 = 2;
        wp::int32 var_65;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::transform_t<wp::float32> adj_1 = {};
        wp::transform_t<wp::float32> adj_2 = {};
        wp::transform_t<wp::float32> adj_3 = {};
        wp::int32 adj_4 = {};
        wp::int32 adj_5 = {};
        wp::vec_t<3, wp::float32> adj_6 = {};
        wp::int32 adj_7 = {};
        wp::int32 adj_8 = {};
        wp::vec_t<3, wp::float32> adj_9 = {};
        wp::int32 adj_10 = {};
        wp::int32 adj_11 = {};
        wp::vec_t<3, wp::float32> adj_12 = {};
        wp::int32 adj_13 = {};
        wp::int32 adj_14 = {};
        wp::vec_t<3, wp::float32> adj_15 = {};
        wp::quat_t<wp::float32> adj_16 = {};
        wp::float32 adj_17 = {};
        wp::float32 adj_18 = {};
        wp::float32 adj_19 = {};
        wp::vec_t<3, wp::float32> adj_20 = {};
        wp::vec_t<3, wp::float32> adj_21 = {};
        wp::vec_t<3, wp::float32> adj_22 = {};
        wp::vec_t<3, wp::float32> adj_23 = {};
        wp::int32 adj_24 = {};
        wp::int32 adj_25 = {};
        wp::vec_t<3, wp::float32> adj_26 = {};
        wp::quat_t<wp::float32> adj_27 = {};
        wp::float32 adj_28 = {};
        wp::float32 adj_29 = {};
        wp::float32 adj_30 = {};
        wp::vec_t<3, wp::float32> adj_31 = {};
        wp::vec_t<3, wp::float32> adj_32 = {};
        wp::vec_t<3, wp::float32> adj_33 = {};
        wp::vec_t<3, wp::float32> adj_34 = {};
        wp::int32 adj_35 = {};
        wp::int32 adj_36 = {};
        wp::vec_t<3, wp::float32> adj_37 = {};
        wp::quat_t<wp::float32> adj_38 = {};
        wp::float32 adj_39 = {};
        wp::float32 adj_40 = {};
        wp::float32 adj_41 = {};
        wp::vec_t<3, wp::float32> adj_42 = {};
        wp::vec_t<3, wp::float32> adj_43 = {};
        wp::vec_t<3, wp::float32> adj_44 = {};
        wp::vec_t<3, wp::float32> adj_45 = {};
        wp::int32 adj_46 = {};
        wp::int32 adj_47 = {};
        wp::float32 adj_48 = {};
        wp::float32 adj_49 = {};
        wp::float32 adj_50 = {};
        wp::vec_t<3, wp::float32> adj_51 = {};
        wp::int32 adj_52 = {};
        wp::int32 adj_53 = {};
        wp::float32 adj_54 = {};
        wp::float32 adj_55 = {};
        wp::float32 adj_56 = {};
        wp::vec_t<3, wp::float32> adj_57 = {};
        wp::int32 adj_58 = {};
        wp::int32 adj_59 = {};
        wp::float32 adj_60 = {};
        wp::float32 adj_61 = {};
        wp::float32 adj_62 = {};
        wp::vec_t<3, wp::float32> adj_63 = {};
        wp::int32 adj_64 = {};
        wp::int32 adj_65 = {};
        //---------
        // forward
        // def _compute_coordinate_lines_kernel(                                                  <L 13>
        // in_idx = wp.tid()                                                                      <L 20>
        var_0 = builtin_tid1d();
        // in_tx = in_transforms[in_idx]                                                          <L 21>
        var_1 = wp::address(var_in_transforms, var_0);
        var_3 = wp::load(var_1);
        var_2 = wp::copy(var_3);
        // out_idx = in_idx * 3                                                                   <L 23>
        var_5 = wp::mul(var_0, var_4);
        // out_axes_starts[out_idx + 0] = in_tx.p                                                 <L 24>
        var_6 = wp::transform_get_translation(var_2);
        var_8 = wp::add(var_5, var_7);
        // wp::array_store(var_out_axes_starts, var_8, var_6);
        // out_axes_starts[out_idx + 1] = in_tx.p                                                 <L 25>
        var_9 = wp::transform_get_translation(var_2);
        var_11 = wp::add(var_5, var_10);
        // wp::array_store(var_out_axes_starts, var_11, var_9);
        // out_axes_starts[out_idx + 2] = in_tx.p                                                 <L 26>
        var_12 = wp::transform_get_translation(var_2);
        var_14 = wp::add(var_5, var_13);
        // wp::array_store(var_out_axes_starts, var_14, var_12);
        // out_axes_ends[out_idx + 0] = in_tx.p + wp.mul(wp.quat_rotate(in_tx.q, wp.vec3(1.0, 0.0, 0.0)), in_scale)       <L 28>
        var_15 = wp::transform_get_translation(var_2);
        var_16 = wp::transform_get_rotation(var_2);
        var_20 = wp::vec_t<3, wp::float32>(var_17, var_18, var_19);
        var_21 = wp::quat_rotate(var_16, var_20);
        var_22 = wp::mul(var_21, var_in_scale);
        var_23 = wp::add(var_15, var_22);
        var_25 = wp::add(var_5, var_24);
        // wp::array_store(var_out_axes_ends, var_25, var_23);
        // out_axes_ends[out_idx + 1] = in_tx.p + wp.mul(wp.quat_rotate(in_tx.q, wp.vec3(0.0, 1.0, 0.0)), in_scale)       <L 29>
        var_26 = wp::transform_get_translation(var_2);
        var_27 = wp::transform_get_rotation(var_2);
        var_31 = wp::vec_t<3, wp::float32>(var_28, var_29, var_30);
        var_32 = wp::quat_rotate(var_27, var_31);
        var_33 = wp::mul(var_32, var_in_scale);
        var_34 = wp::add(var_26, var_33);
        var_36 = wp::add(var_5, var_35);
        // wp::array_store(var_out_axes_ends, var_36, var_34);
        // out_axes_ends[out_idx + 2] = in_tx.p + wp.mul(wp.quat_rotate(in_tx.q, wp.vec3(0.0, 0.0, 1.0)), in_scale)       <L 30>
        var_37 = wp::transform_get_translation(var_2);
        var_38 = wp::transform_get_rotation(var_2);
        var_42 = wp::vec_t<3, wp::float32>(var_39, var_40, var_41);
        var_43 = wp::quat_rotate(var_38, var_42);
        var_44 = wp::mul(var_43, var_in_scale);
        var_45 = wp::add(var_37, var_44);
        var_47 = wp::add(var_5, var_46);
        // wp::array_store(var_out_axes_ends, var_47, var_45);
        // out_axes_colors[out_idx + 0] = wp.vec3(1.0, 0.0, 0.0)                                  <L 32>
        var_51 = wp::vec_t<3, wp::float32>(var_48, var_49, var_50);
        var_53 = wp::add(var_5, var_52);
        // wp::array_store(var_out_axes_colors, var_53, var_51);
        // out_axes_colors[out_idx + 1] = wp.vec3(0.0, 1.0, 0.0)                                  <L 33>
        var_57 = wp::vec_t<3, wp::float32>(var_54, var_55, var_56);
        var_59 = wp::add(var_5, var_58);
        // wp::array_store(var_out_axes_colors, var_59, var_57);
        // out_axes_colors[out_idx + 2] = wp.vec3(0.0, 0.0, 1.0)                                  <L 34>
        var_63 = wp::vec_t<3, wp::float32>(var_60, var_61, var_62);
        var_65 = wp::add(var_5, var_64);
        // wp::array_store(var_out_axes_colors, var_65, var_63);
        //---------
        // reverse
        wp::adj_array_store(var_out_axes_colors, var_65, var_63, adj_out_axes_colors, adj_65, adj_63);
        wp::adj_add(var_5, var_64, adj_5, adj_64, adj_65);
        wp::adj_vec_t(var_60, var_61, var_62, adj_60, adj_61, adj_62, adj_63);
        // adj: out_axes_colors[out_idx + 2] = wp.vec3(0.0, 0.0, 1.0)                             <L 34>
        wp::adj_array_store(var_out_axes_colors, var_59, var_57, adj_out_axes_colors, adj_59, adj_57);
        wp::adj_add(var_5, var_58, adj_5, adj_58, adj_59);
        wp::adj_vec_t(var_54, var_55, var_56, adj_54, adj_55, adj_56, adj_57);
        // adj: out_axes_colors[out_idx + 1] = wp.vec3(0.0, 1.0, 0.0)                             <L 33>
        wp::adj_array_store(var_out_axes_colors, var_53, var_51, adj_out_axes_colors, adj_53, adj_51);
        wp::adj_add(var_5, var_52, adj_5, adj_52, adj_53);
        wp::adj_vec_t(var_48, var_49, var_50, adj_48, adj_49, adj_50, adj_51);
        // adj: out_axes_colors[out_idx + 0] = wp.vec3(1.0, 0.0, 0.0)                             <L 32>
        wp::adj_array_store(var_out_axes_ends, var_47, var_45, adj_out_axes_ends, adj_47, adj_45);
        wp::adj_add(var_5, var_46, adj_5, adj_46, adj_47);
        wp::adj_add(var_37, var_44, adj_37, adj_44, adj_45);
        wp::adj_mul(var_43, var_in_scale, adj_43, adj_in_scale, adj_44);
        wp::adj_quat_rotate(var_38, var_42, adj_38, adj_42, adj_43);
        wp::adj_vec_t(var_39, var_40, var_41, adj_39, adj_40, adj_41, adj_42);
        wp::adj_transform_get_rotation(var_2, adj_2, adj_38);
        wp::adj_transform_get_translation(var_2, adj_2, adj_37);
        // adj: out_axes_ends[out_idx + 2] = in_tx.p + wp.mul(wp.quat_rotate(in_tx.q, wp.vec3(0.0, 0.0, 1.0)), in_scale)  <L 30>
        wp::adj_array_store(var_out_axes_ends, var_36, var_34, adj_out_axes_ends, adj_36, adj_34);
        wp::adj_add(var_5, var_35, adj_5, adj_35, adj_36);
        wp::adj_add(var_26, var_33, adj_26, adj_33, adj_34);
        wp::adj_mul(var_32, var_in_scale, adj_32, adj_in_scale, adj_33);
        wp::adj_quat_rotate(var_27, var_31, adj_27, adj_31, adj_32);
        wp::adj_vec_t(var_28, var_29, var_30, adj_28, adj_29, adj_30, adj_31);
        wp::adj_transform_get_rotation(var_2, adj_2, adj_27);
        wp::adj_transform_get_translation(var_2, adj_2, adj_26);
        // adj: out_axes_ends[out_idx + 1] = in_tx.p + wp.mul(wp.quat_rotate(in_tx.q, wp.vec3(0.0, 1.0, 0.0)), in_scale)  <L 29>
        wp::adj_array_store(var_out_axes_ends, var_25, var_23, adj_out_axes_ends, adj_25, adj_23);
        wp::adj_add(var_5, var_24, adj_5, adj_24, adj_25);
        wp::adj_add(var_15, var_22, adj_15, adj_22, adj_23);
        wp::adj_mul(var_21, var_in_scale, adj_21, adj_in_scale, adj_22);
        wp::adj_quat_rotate(var_16, var_20, adj_16, adj_20, adj_21);
        wp::adj_vec_t(var_17, var_18, var_19, adj_17, adj_18, adj_19, adj_20);
        wp::adj_transform_get_rotation(var_2, adj_2, adj_16);
        wp::adj_transform_get_translation(var_2, adj_2, adj_15);
        // adj: out_axes_ends[out_idx + 0] = in_tx.p + wp.mul(wp.quat_rotate(in_tx.q, wp.vec3(1.0, 0.0, 0.0)), in_scale)  <L 28>
        wp::adj_array_store(var_out_axes_starts, var_14, var_12, adj_out_axes_starts, adj_14, adj_12);
        wp::adj_add(var_5, var_13, adj_5, adj_13, adj_14);
        wp::adj_transform_get_translation(var_2, adj_2, adj_12);
        // adj: out_axes_starts[out_idx + 2] = in_tx.p                                            <L 26>
        wp::adj_array_store(var_out_axes_starts, var_11, var_9, adj_out_axes_starts, adj_11, adj_9);
        wp::adj_add(var_5, var_10, adj_5, adj_10, adj_11);
        wp::adj_transform_get_translation(var_2, adj_2, adj_9);
        // adj: out_axes_starts[out_idx + 1] = in_tx.p                                            <L 25>
        wp::adj_array_store(var_out_axes_starts, var_8, var_6, adj_out_axes_starts, adj_8, adj_6);
        wp::adj_add(var_5, var_7, adj_5, adj_7, adj_8);
        wp::adj_transform_get_translation(var_2, adj_2, adj_6);
        // adj: out_axes_starts[out_idx + 0] = in_tx.p                                            <L 24>
        wp::adj_mul(var_0, var_4, adj_0, adj_4, adj_5);
        // adj: out_idx = in_idx * 3                                                              <L 23>
        wp::adj_copy(var_3, adj_1, adj_2);
        wp::adj_address(var_in_transforms, var_0, adj_in_transforms, adj_0, adj_1);
        // adj: in_tx = in_transforms[in_idx]                                                     <L 21>
        // adj: in_idx = wp.tid()                                                                 <L 20>
        // adj: def _compute_coordinate_lines_kernel(                                             <L 13>
        continue;
    }
}

