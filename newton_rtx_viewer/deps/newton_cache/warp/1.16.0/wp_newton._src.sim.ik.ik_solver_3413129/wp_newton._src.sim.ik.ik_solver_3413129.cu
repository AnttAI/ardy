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



extern "C" __global__ void _set_seed_90e4cfd1_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::uint32> var_seed_state,
    wp::uint32 var_value)
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
        // def _set_seed(                                                                         <L 189>
        // seed_state[0] = value                                                                  <L 193>
        wp::array_store(var_seed_state, var_0, var_value);
    }
}



extern "C" __global__ void _set_seed_90e4cfd1_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::uint32> var_seed_state,
    wp::uint32 var_value,
    wp::array_t<wp::uint32> adj_seed_state,
    wp::uint32 adj_value)
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
        // def _set_seed(                                                                         <L 189>
        // seed_state[0] = value                                                                  <L 193>
        // wp::array_store(var_seed_state, var_0, var_value);
        //---------
        // reverse
        wp::adj_array_store(var_seed_state, var_0, var_value, adj_seed_state, adj_0, adj_value);
        // adj: seed_state[0] = value                                                             <L 193>
        // adj: def _set_seed(                                                                    <L 189>
        continue;
    }
}



extern "C" __global__ void _sample_uniform_kernel_9b3c7b3e_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::int32 var_n_coords,
    wp::array_t<wp::float32> var_joint_lower,
    wp::array_t<wp::float32> var_joint_upper,
    wp::array_t<wp::int32> var_joint_bounded,
    wp::array_t<wp::uint32> var_base_seed,
    wp::array_t<wp::float32> var_joint_q_out)
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
        wp::range_t var_1;
        wp::int32 var_2;
        wp::int32* var_3;
        wp::int32 var_4;
        wp::float32* var_5;
        wp::float32 var_6;
        wp::float32 var_7;
        wp::float32* var_8;
        wp::float32 var_9;
        wp::float32 var_10;
        wp::float32 var_11;
        const wp::int32 var_12 = 0;
        wp::uint32* var_13;
        wp::int32 var_14;
        wp::uint32 var_15;
        wp::int32 var_16;
        wp::int32 var_17;
        wp::int32 var_18;
        wp::int32 var_19;
        wp::int32 var_20;
        wp::uint32 var_21;
        wp::float32 var_22;
        wp::float32 var_23;
        wp::float32 var_24;
        wp::int32 var_25;
        wp::int32 var_26;
        const wp::float32 var_27 = 0.0;
        wp::int32 var_28;
        wp::float32 var_29;
        wp::int32 var_30;
        //---------
        // forward
        // def _sample_uniform_kernel(                                                            <L 95>
        // expanded_idx = wp.tid()                                                                <L 103>
        var_0 = builtin_tid1d();
        // for coord in range(n_coords):                                                          <L 105>
        var_1 = wp::range(var_n_coords);
        start_for_0:;
            if (iter_cmp(var_1) == 0) goto end_for_0;
            var_2 = wp::iter_next(var_1);
            // if joint_bounded[coord]:                                                           <L 106>
            var_3 = wp::address(var_joint_bounded, var_2);
            var_4 = wp::load(var_3);
            if (var_4) {
                // lo = joint_lower[coord]                                                        <L 107>
                var_5 = wp::address(var_joint_lower, var_2);
                var_7 = wp::load(var_5);
                var_6 = wp::copy(var_7);
                // hi = joint_upper[coord]                                                        <L 108>
                var_8 = wp::address(var_joint_upper, var_2);
                var_10 = wp::load(var_8);
                var_9 = wp::copy(var_10);
                // span = hi - lo                                                                 <L 109>
                var_11 = wp::sub(var_9, var_6);
                // seed = wp.int32(base_seed[0])                                                  <L 110>
                var_13 = wp::address(var_base_seed, var_12);
                var_15 = wp::load(var_13);
                var_14 = wp::int32(var_15);
                // offset = wp.int32(expanded_idx) * wp.int32(n_coords) + wp.int32(coord)         <L 111>
                var_16 = wp::int32(var_0);
                var_17 = wp::int32(var_n_coords);
                var_18 = wp::mul(var_16, var_17);
                var_19 = wp::int32(var_2);
                var_20 = wp::add(var_18, var_19);
                // state = wp.rand_init(seed, offset)                                             <L 112>
                var_21 = wp::rand_init(var_14, var_20);
                // val = lo + wp.randf(state) * span                                              <L 113>
                var_22 = wp::randf(var_21);
                var_23 = wp::mul(var_22, var_11);
                var_24 = wp::add(var_6, var_23);
            }
            var_25 = wp::load(var_3);
            var_26 = wp::load(var_3);
            if (!var_26) {
                // val = 0.0                                                                      <L 115>
            }
            var_28 = wp::load(var_3);
            var_30 = wp::load(var_3);
            var_29 = wp::where(var_30, var_24, var_27);
            // joint_q_out[expanded_idx, coord] = val                                             <L 116>
            wp::array_store(var_joint_q_out, var_0, var_2, var_29);
            goto start_for_0;
        end_for_0:;
    }
}



extern "C" __global__ void _sample_uniform_kernel_9b3c7b3e_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::int32 var_n_coords,
    wp::array_t<wp::float32> var_joint_lower,
    wp::array_t<wp::float32> var_joint_upper,
    wp::array_t<wp::int32> var_joint_bounded,
    wp::array_t<wp::uint32> var_base_seed,
    wp::array_t<wp::float32> var_joint_q_out,
    wp::int32 adj_n_coords,
    wp::array_t<wp::float32> adj_joint_lower,
    wp::array_t<wp::float32> adj_joint_upper,
    wp::array_t<wp::int32> adj_joint_bounded,
    wp::array_t<wp::uint32> adj_base_seed,
    wp::array_t<wp::float32> adj_joint_q_out)
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
        wp::range_t var_1;
        wp::int32 var_2;
        wp::int32* var_3;
        wp::int32 var_4;
        wp::float32* var_5;
        wp::float32 var_6;
        wp::float32 var_7;
        wp::float32* var_8;
        wp::float32 var_9;
        wp::float32 var_10;
        wp::float32 var_11;
        const wp::int32 var_12 = 0;
        wp::uint32* var_13;
        wp::int32 var_14;
        wp::uint32 var_15;
        wp::int32 var_16;
        wp::int32 var_17;
        wp::int32 var_18;
        wp::int32 var_19;
        wp::int32 var_20;
        wp::uint32 var_21;
        wp::float32 var_22;
        wp::float32 var_23;
        wp::float32 var_24;
        wp::int32 var_25;
        wp::int32 var_26;
        const wp::float32 var_27 = 0.0;
        wp::int32 var_28;
        wp::float32 var_29;
        wp::int32 var_30;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::range_t adj_1 = {};
        wp::int32 adj_2 = {};
        wp::int32 adj_3 = {};
        wp::int32 adj_4 = {};
        wp::float32 adj_5 = {};
        wp::float32 adj_6 = {};
        wp::float32 adj_7 = {};
        wp::float32 adj_8 = {};
        wp::float32 adj_9 = {};
        wp::float32 adj_10 = {};
        wp::float32 adj_11 = {};
        wp::int32 adj_12 = {};
        wp::uint32 adj_13 = {};
        wp::int32 adj_14 = {};
        wp::uint32 adj_15 = {};
        wp::int32 adj_16 = {};
        wp::int32 adj_17 = {};
        wp::int32 adj_18 = {};
        wp::int32 adj_19 = {};
        wp::int32 adj_20 = {};
        wp::uint32 adj_21 = {};
        wp::float32 adj_22 = {};
        wp::float32 adj_23 = {};
        wp::float32 adj_24 = {};
        wp::int32 adj_25 = {};
        wp::int32 adj_26 = {};
        wp::float32 adj_27 = {};
        wp::int32 adj_28 = {};
        wp::float32 adj_29 = {};
        wp::int32 adj_30 = {};
        //---------
        // forward
        // def _sample_uniform_kernel(                                                            <L 95>
        // expanded_idx = wp.tid()                                                                <L 103>
        var_0 = builtin_tid1d();
        // for coord in range(n_coords):                                                          <L 105>
        var_1 = wp::range(var_n_coords);
        //---------
        // reverse
        var_1 = wp::iter_reverse(var_1);
        start_for_0:;
            if (iter_cmp(var_1) == 0) goto end_for_0;
            var_2 = wp::iter_next(var_1);
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
            // if joint_bounded[coord]:                                                           <L 106>
            var_3 = wp::address(var_joint_bounded, var_2);
            var_4 = wp::load(var_3);
            if (var_4) {
                // lo = joint_lower[coord]                                                        <L 107>
                var_5 = wp::address(var_joint_lower, var_2);
                var_7 = wp::load(var_5);
                var_6 = wp::copy(var_7);
                // hi = joint_upper[coord]                                                        <L 108>
                var_8 = wp::address(var_joint_upper, var_2);
                var_10 = wp::load(var_8);
                var_9 = wp::copy(var_10);
                // span = hi - lo                                                                 <L 109>
                var_11 = wp::sub(var_9, var_6);
                // seed = wp.int32(base_seed[0])                                                  <L 110>
                var_13 = wp::address(var_base_seed, var_12);
                var_15 = wp::load(var_13);
                var_14 = wp::int32(var_15);
                // offset = wp.int32(expanded_idx) * wp.int32(n_coords) + wp.int32(coord)         <L 111>
                var_16 = wp::int32(var_0);
                var_17 = wp::int32(var_n_coords);
                var_18 = wp::mul(var_16, var_17);
                var_19 = wp::int32(var_2);
                var_20 = wp::add(var_18, var_19);
                // state = wp.rand_init(seed, offset)                                             <L 112>
                var_21 = wp::rand_init(var_14, var_20);
                // val = lo + wp.randf(state) * span                                              <L 113>
                var_22 = wp::randf(var_21);
                var_23 = wp::mul(var_22, var_11);
                var_24 = wp::add(var_6, var_23);
            }
            var_25 = wp::load(var_3);
            var_26 = wp::load(var_3);
            if (!var_26) {
                // val = 0.0                                                                      <L 115>
            }
            var_28 = wp::load(var_3);
            var_30 = wp::load(var_3);
            var_29 = wp::where(var_30, var_24, var_27);
            // joint_q_out[expanded_idx, coord] = val                                             <L 116>
            // wp::array_store(var_joint_q_out, var_0, var_2, var_29);
            wp::adj_array_store(var_joint_q_out, var_0, var_2, var_29, adj_joint_q_out, adj_0, adj_2, adj_29);
            // adj: joint_q_out[expanded_idx, coord] = val                                        <L 116>
            wp::adj_where(var_30, var_24, var_27, adj_3, adj_24, adj_27, adj_29);
            if (!var_28) {
                // adj: val = 0.0                                                                 <L 115>
            }
            if (var_25) {
                wp::adj_add(var_6, var_23, adj_6, adj_23, adj_24);
                wp::adj_mul(var_22, var_11, adj_22, adj_11, adj_23);
                // adj: val = lo + wp.randf(state) * span                                         <L 113>
                // adj: state = wp.rand_init(seed, offset)                                        <L 112>
                wp::adj_add(var_18, var_19, adj_18, adj_19, adj_20);
                wp::adj_mul(var_16, var_17, adj_16, adj_17, adj_18);
                // adj: offset = wp.int32(expanded_idx) * wp.int32(n_coords) + wp.int32(coord)    <L 111>
                wp::adj_address(var_base_seed, var_12, adj_base_seed, adj_12, adj_13);
                // adj: seed = wp.int32(base_seed[0])                                             <L 110>
                wp::adj_sub(var_9, var_6, adj_9, adj_6, adj_11);
                // adj: span = hi - lo                                                            <L 109>
                wp::adj_copy(var_10, adj_8, adj_9);
                wp::adj_address(var_joint_upper, var_2, adj_joint_upper, adj_2, adj_8);
                // adj: hi = joint_upper[coord]                                                   <L 108>
                wp::adj_copy(var_7, adj_5, adj_6);
                wp::adj_address(var_joint_lower, var_2, adj_joint_lower, adj_2, adj_5);
                // adj: lo = joint_lower[coord]                                                   <L 107>
            }
            wp::adj_address(var_joint_bounded, var_2, adj_joint_bounded, adj_2, adj_3);
            // adj: if joint_bounded[coord]:                                                      <L 106>
        	goto start_for_0;
        end_for_0:;
        // adj: for coord in range(n_coords):                                                     <L 105>
        // adj: expanded_idx = wp.tid()                                                           <L 103>
        // adj: def _sample_uniform_kernel(                                                       <L 95>
        continue;
    }
}



extern "C" __global__ void _sample_roberts_kernel_b70bd200_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::int32 var_n_seeds,
    wp::int32 var_n_coords,
    wp::array_t<wp::float32> var_roberts_basis,
    wp::array_t<wp::float32> var_joint_lower,
    wp::array_t<wp::float32> var_joint_upper,
    wp::array_t<wp::int32> var_joint_bounded,
    wp::array_t<wp::float32> var_joint_q_out)
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
        wp::int32* var_4;
        wp::int32 var_5;
        wp::float32* var_6;
        wp::float32 var_7;
        wp::float32 var_8;
        wp::float32* var_9;
        wp::float32 var_10;
        wp::float32 var_11;
        wp::float32 var_12;
        wp::float32* var_13;
        wp::float32 var_14;
        wp::float32 var_15;
        wp::float32 var_16;
        wp::float32 var_17;
        const wp::float32 var_18 = 1.0;
        wp::float32 var_19;
        wp::float32 var_20;
        wp::float32 var_21;
        wp::int32 var_22;
        wp::int32 var_23;
        const wp::float32 var_24 = 0.0;
        wp::int32 var_25;
        wp::float32 var_26;
        wp::int32 var_27;
        //---------
        // forward
        // def _sample_roberts_kernel(                                                            <L 120>
        // expanded_idx = wp.tid()                                                                <L 129>
        var_0 = builtin_tid1d();
        // seed_idx = expanded_idx % n_seeds                                                      <L 130>
        var_1 = wp::mod(var_0, var_n_seeds);
        // for coord in range(n_coords):                                                          <L 132>
        var_2 = wp::range(var_n_coords);
        start_for_0:;
            if (iter_cmp(var_2) == 0) goto end_for_0;
            var_3 = wp::iter_next(var_2);
            // if joint_bounded[coord]:                                                           <L 133>
            var_4 = wp::address(var_joint_bounded, var_3);
            var_5 = wp::load(var_4);
            if (var_5) {
                // lo = joint_lower[coord]                                                        <L 134>
                var_6 = wp::address(var_joint_lower, var_3);
                var_8 = wp::load(var_6);
                var_7 = wp::copy(var_8);
                // hi = joint_upper[coord]                                                        <L 135>
                var_9 = wp::address(var_joint_upper, var_3);
                var_11 = wp::load(var_9);
                var_10 = wp::copy(var_11);
                // span = hi - lo                                                                 <L 136>
                var_12 = wp::sub(var_10, var_7);
                // basis = roberts_basis[coord]                                                   <L 137>
                var_13 = wp::address(var_roberts_basis, var_3);
                var_15 = wp::load(var_13);
                var_14 = wp::copy(var_15);
                // val = lo + wp.mod(float(seed_idx) * basis, 1.0) * span                         <L 138>
                var_16 = wp::float(var_1);
                var_17 = wp::mul(var_16, var_14);
                var_19 = wp::mod(var_17, var_18);
                var_20 = wp::mul(var_19, var_12);
                var_21 = wp::add(var_7, var_20);
            }
            var_22 = wp::load(var_4);
            var_23 = wp::load(var_4);
            if (!var_23) {
                // val = 0.0                                                                      <L 140>
            }
            var_25 = wp::load(var_4);
            var_27 = wp::load(var_4);
            var_26 = wp::where(var_27, var_21, var_24);
            // joint_q_out[expanded_idx, coord] = val                                             <L 141>
            wp::array_store(var_joint_q_out, var_0, var_3, var_26);
            goto start_for_0;
        end_for_0:;
    }
}



extern "C" __global__ void _sample_roberts_kernel_b70bd200_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::int32 var_n_seeds,
    wp::int32 var_n_coords,
    wp::array_t<wp::float32> var_roberts_basis,
    wp::array_t<wp::float32> var_joint_lower,
    wp::array_t<wp::float32> var_joint_upper,
    wp::array_t<wp::int32> var_joint_bounded,
    wp::array_t<wp::float32> var_joint_q_out,
    wp::int32 adj_n_seeds,
    wp::int32 adj_n_coords,
    wp::array_t<wp::float32> adj_roberts_basis,
    wp::array_t<wp::float32> adj_joint_lower,
    wp::array_t<wp::float32> adj_joint_upper,
    wp::array_t<wp::int32> adj_joint_bounded,
    wp::array_t<wp::float32> adj_joint_q_out)
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
        wp::int32* var_4;
        wp::int32 var_5;
        wp::float32* var_6;
        wp::float32 var_7;
        wp::float32 var_8;
        wp::float32* var_9;
        wp::float32 var_10;
        wp::float32 var_11;
        wp::float32 var_12;
        wp::float32* var_13;
        wp::float32 var_14;
        wp::float32 var_15;
        wp::float32 var_16;
        wp::float32 var_17;
        const wp::float32 var_18 = 1.0;
        wp::float32 var_19;
        wp::float32 var_20;
        wp::float32 var_21;
        wp::int32 var_22;
        wp::int32 var_23;
        const wp::float32 var_24 = 0.0;
        wp::int32 var_25;
        wp::float32 var_26;
        wp::int32 var_27;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::range_t adj_2 = {};
        wp::int32 adj_3 = {};
        wp::int32 adj_4 = {};
        wp::int32 adj_5 = {};
        wp::float32 adj_6 = {};
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
        wp::float32 adj_18 = {};
        wp::float32 adj_19 = {};
        wp::float32 adj_20 = {};
        wp::float32 adj_21 = {};
        wp::int32 adj_22 = {};
        wp::int32 adj_23 = {};
        wp::float32 adj_24 = {};
        wp::int32 adj_25 = {};
        wp::float32 adj_26 = {};
        wp::int32 adj_27 = {};
        //---------
        // forward
        // def _sample_roberts_kernel(                                                            <L 120>
        // expanded_idx = wp.tid()                                                                <L 129>
        var_0 = builtin_tid1d();
        // seed_idx = expanded_idx % n_seeds                                                      <L 130>
        var_1 = wp::mod(var_0, var_n_seeds);
        // for coord in range(n_coords):                                                          <L 132>
        var_2 = wp::range(var_n_coords);
        //---------
        // reverse
        var_2 = wp::iter_reverse(var_2);
        start_for_0:;
            if (iter_cmp(var_2) == 0) goto end_for_0;
            var_3 = wp::iter_next(var_2);
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
            // if joint_bounded[coord]:                                                           <L 133>
            var_4 = wp::address(var_joint_bounded, var_3);
            var_5 = wp::load(var_4);
            if (var_5) {
                // lo = joint_lower[coord]                                                        <L 134>
                var_6 = wp::address(var_joint_lower, var_3);
                var_8 = wp::load(var_6);
                var_7 = wp::copy(var_8);
                // hi = joint_upper[coord]                                                        <L 135>
                var_9 = wp::address(var_joint_upper, var_3);
                var_11 = wp::load(var_9);
                var_10 = wp::copy(var_11);
                // span = hi - lo                                                                 <L 136>
                var_12 = wp::sub(var_10, var_7);
                // basis = roberts_basis[coord]                                                   <L 137>
                var_13 = wp::address(var_roberts_basis, var_3);
                var_15 = wp::load(var_13);
                var_14 = wp::copy(var_15);
                // val = lo + wp.mod(float(seed_idx) * basis, 1.0) * span                         <L 138>
                var_16 = wp::float(var_1);
                var_17 = wp::mul(var_16, var_14);
                var_19 = wp::mod(var_17, var_18);
                var_20 = wp::mul(var_19, var_12);
                var_21 = wp::add(var_7, var_20);
            }
            var_22 = wp::load(var_4);
            var_23 = wp::load(var_4);
            if (!var_23) {
                // val = 0.0                                                                      <L 140>
            }
            var_25 = wp::load(var_4);
            var_27 = wp::load(var_4);
            var_26 = wp::where(var_27, var_21, var_24);
            // joint_q_out[expanded_idx, coord] = val                                             <L 141>
            // wp::array_store(var_joint_q_out, var_0, var_3, var_26);
            wp::adj_array_store(var_joint_q_out, var_0, var_3, var_26, adj_joint_q_out, adj_0, adj_3, adj_26);
            // adj: joint_q_out[expanded_idx, coord] = val                                        <L 141>
            wp::adj_where(var_27, var_21, var_24, adj_4, adj_21, adj_24, adj_26);
            if (!var_25) {
                // adj: val = 0.0                                                                 <L 140>
            }
            if (var_22) {
                wp::adj_add(var_7, var_20, adj_7, adj_20, adj_21);
                wp::adj_mul(var_19, var_12, adj_19, adj_12, adj_20);
                wp::adj_mod(var_17, var_18, adj_17, adj_18, adj_19);
                wp::adj_mul(var_16, var_14, adj_16, adj_14, adj_17);
                wp::adj_float(var_1, adj_1, adj_16);
                // adj: val = lo + wp.mod(float(seed_idx) * basis, 1.0) * span                    <L 138>
                wp::adj_copy(var_15, adj_13, adj_14);
                wp::adj_address(var_roberts_basis, var_3, adj_roberts_basis, adj_3, adj_13);
                // adj: basis = roberts_basis[coord]                                              <L 137>
                wp::adj_sub(var_10, var_7, adj_10, adj_7, adj_12);
                // adj: span = hi - lo                                                            <L 136>
                wp::adj_copy(var_11, adj_9, adj_10);
                wp::adj_address(var_joint_upper, var_3, adj_joint_upper, adj_3, adj_9);
                // adj: hi = joint_upper[coord]                                                   <L 135>
                wp::adj_copy(var_8, adj_6, adj_7);
                wp::adj_address(var_joint_lower, var_3, adj_joint_lower, adj_3, adj_6);
                // adj: lo = joint_lower[coord]                                                   <L 134>
            }
            wp::adj_address(var_joint_bounded, var_3, adj_joint_bounded, adj_3, adj_4);
            // adj: if joint_bounded[coord]:                                                      <L 133>
        	goto start_for_0;
        end_for_0:;
        // adj: for coord in range(n_coords):                                                     <L 132>
        wp::adj_mod(var_0, var_n_seeds, adj_0, adj_n_seeds, adj_1);
        // adj: seed_idx = expanded_idx % n_seeds                                                 <L 130>
        // adj: expanded_idx = wp.tid()                                                           <L 129>
        // adj: def _sample_roberts_kernel(                                                       <L 120>
        continue;
    }
}



extern "C" __global__ void _gather_best_seed_283d786f_cuda_kernel_forward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::float32> var_joint_q_expanded,
    wp::array_t<wp::int32> var_best,
    wp::int32 var_n_seeds,
    wp::int32 var_n_coords,
    wp::array_t<wp::float32> var_joint_q_out)
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
        wp::float32* var_7;
        wp::float32 var_8;
        //---------
        // forward
        // def _gather_best_seed(                                                                 <L 166>
        // problem_idx, coord_idx = wp.tid()                                                      <L 173>
        builtin_tid2d(var_0, var_1);
        // best_seed = best[problem_idx]                                                          <L 174>
        var_2 = wp::address(var_best, var_0);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // expanded_idx = problem_idx * n_seeds + best_seed                                       <L 175>
        var_5 = wp::mul(var_0, var_n_seeds);
        var_6 = wp::add(var_5, var_3);
        // joint_q_out[problem_idx, coord_idx] = joint_q_expanded[expanded_idx, coord_idx]        <L 176>
        var_7 = wp::address(var_joint_q_expanded, var_6, var_1);
        var_8 = wp::load(var_7);
        wp::array_store(var_joint_q_out, var_0, var_1, var_8);
    }
}



extern "C" __global__ void _gather_best_seed_283d786f_cuda_kernel_backward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::float32> var_joint_q_expanded,
    wp::array_t<wp::int32> var_best,
    wp::int32 var_n_seeds,
    wp::int32 var_n_coords,
    wp::array_t<wp::float32> var_joint_q_out,
    wp::array_t<wp::float32> adj_joint_q_expanded,
    wp::array_t<wp::int32> adj_best,
    wp::int32 adj_n_seeds,
    wp::int32 adj_n_coords,
    wp::array_t<wp::float32> adj_joint_q_out)
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
        wp::float32* var_7;
        wp::float32 var_8;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::int32 adj_2 = {};
        wp::int32 adj_3 = {};
        wp::int32 adj_4 = {};
        wp::int32 adj_5 = {};
        wp::int32 adj_6 = {};
        wp::float32 adj_7 = {};
        wp::float32 adj_8 = {};
        //---------
        // forward
        // def _gather_best_seed(                                                                 <L 166>
        // problem_idx, coord_idx = wp.tid()                                                      <L 173>
        builtin_tid2d(var_0, var_1);
        // best_seed = best[problem_idx]                                                          <L 174>
        var_2 = wp::address(var_best, var_0);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // expanded_idx = problem_idx * n_seeds + best_seed                                       <L 175>
        var_5 = wp::mul(var_0, var_n_seeds);
        var_6 = wp::add(var_5, var_3);
        // joint_q_out[problem_idx, coord_idx] = joint_q_expanded[expanded_idx, coord_idx]        <L 176>
        var_7 = wp::address(var_joint_q_expanded, var_6, var_1);
        var_8 = wp::load(var_7);
        // wp::array_store(var_joint_q_out, var_0, var_1, var_8);
        //---------
        // reverse
        wp::adj_array_store(var_joint_q_out, var_0, var_1, var_8, adj_joint_q_out, adj_0, adj_1, adj_7);
        wp::adj_address(var_joint_q_expanded, var_6, var_1, adj_joint_q_expanded, adj_6, adj_1, adj_7);
        // adj: joint_q_out[problem_idx, coord_idx] = joint_q_expanded[expanded_idx, coord_idx]   <L 176>
        wp::adj_add(var_5, var_3, adj_5, adj_3, adj_6);
        wp::adj_mul(var_0, var_n_seeds, adj_0, adj_n_seeds, adj_5);
        // adj: expanded_idx = problem_idx * n_seeds + best_seed                                  <L 175>
        wp::adj_copy(var_4, adj_2, adj_3);
        wp::adj_address(var_best, var_0, adj_best, adj_0, adj_2);
        // adj: best_seed = best[problem_idx]                                                     <L 174>
        // adj: problem_idx, coord_idx = wp.tid()                                                 <L 173>
        // adj: def _gather_best_seed(                                                            <L 166>
        continue;
    }
}



extern "C" __global__ void _select_best_seed_indices_77f49db1_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::float32> var_costs,
    wp::int32 var_n_seeds,
    wp::array_t<wp::int32> var_best)
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
        const wp::int32 var_2 = 0;
        wp::int32 var_3;
        wp::float32* var_4;
        wp::float32 var_5;
        wp::float32 var_6;
        const wp::int32 var_7 = 1;
        wp::range_t var_8;
        wp::int32 var_9;
        wp::int32 var_10;
        wp::float32* var_11;
        wp::float32 var_12;
        wp::float32 var_13;
        bool var_14;
        wp::float32 var_15;
        wp::int32 var_16;
        wp::int32 var_17;
        wp::float32 var_18;
        //---------
        // forward
        // def _select_best_seed_indices(                                                         <L 145>
        // problem_idx = wp.tid()                                                                 <L 150>
        var_0 = builtin_tid1d();
        // base = problem_idx * n_seeds                                                           <L 151>
        var_1 = wp::mul(var_0, var_n_seeds);
        // best_seed = wp.int32(0)                                                                <L 152>
        var_3 = wp::int32(var_2);
        // best_cost = wp.float32(costs[base])                                                    <L 153>
        var_4 = wp::address(var_costs, var_1);
        var_6 = wp::load(var_4);
        var_5 = wp::float32(var_6);
        // for seed_idx in range(1, n_seeds):                                                     <L 155>
        var_8 = wp::range(var_7, var_n_seeds);
        start_for_0:;
            if (iter_cmp(var_8) == 0) goto end_for_0;
            var_9 = wp::iter_next(var_8);
            // idx = base + seed_idx                                                              <L 156>
            var_10 = wp::add(var_1, var_9);
            // cost = wp.float32(costs[idx])                                                      <L 157>
            var_11 = wp::address(var_costs, var_10);
            var_13 = wp::load(var_11);
            var_12 = wp::float32(var_13);
            // if cost < best_cost:                                                               <L 158>
            var_14 = (var_12 < var_5);
            if (var_14) {
                // best_cost = cost                                                               <L 159>
                var_15 = wp::copy(var_12);
                // best_seed = wp.int32(seed_idx)                                                 <L 160>
                var_16 = wp::int32(var_9);
            }
            var_17 = wp::where(var_14, var_16, var_3);
            var_18 = wp::where(var_14, var_15, var_5);
            wp::assign(var_3, var_17);
            wp::assign(var_5, var_18);
            goto start_for_0;
        end_for_0:;
        // best[problem_idx] = best_seed                                                          <L 162>
        wp::array_store(var_best, var_0, var_3);
    }
}



extern "C" __global__ void _select_best_seed_indices_77f49db1_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::float32> var_costs,
    wp::int32 var_n_seeds,
    wp::array_t<wp::int32> var_best,
    wp::array_t<wp::float32> adj_costs,
    wp::int32 adj_n_seeds,
    wp::array_t<wp::int32> adj_best)
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
        const wp::int32 var_2 = 0;
        wp::int32 var_3;
        wp::float32* var_4;
        wp::float32 var_5;
        wp::float32 var_6;
        const wp::int32 var_7 = 1;
        wp::range_t var_8;
        wp::int32 var_9;
        wp::int32 var_10;
        wp::float32* var_11;
        wp::float32 var_12;
        wp::float32 var_13;
        bool var_14;
        wp::float32 var_15;
        wp::int32 var_16;
        wp::int32 var_17;
        wp::float32 var_18;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::int32 adj_2 = {};
        wp::int32 adj_3 = {};
        wp::float32 adj_4 = {};
        wp::float32 adj_5 = {};
        wp::float32 adj_6 = {};
        wp::int32 adj_7 = {};
        wp::range_t adj_8 = {};
        wp::int32 adj_9 = {};
        wp::int32 adj_10 = {};
        wp::float32 adj_11 = {};
        wp::float32 adj_12 = {};
        wp::float32 adj_13 = {};
        bool adj_14 = {};
        wp::float32 adj_15 = {};
        wp::int32 adj_16 = {};
        wp::int32 adj_17 = {};
        wp::float32 adj_18 = {};
        //---------
        // forward
        // def _select_best_seed_indices(                                                         <L 145>
        // problem_idx = wp.tid()                                                                 <L 150>
        var_0 = builtin_tid1d();
        // base = problem_idx * n_seeds                                                           <L 151>
        var_1 = wp::mul(var_0, var_n_seeds);
        // best_seed = wp.int32(0)                                                                <L 152>
        var_3 = wp::int32(var_2);
        // best_cost = wp.float32(costs[base])                                                    <L 153>
        var_4 = wp::address(var_costs, var_1);
        var_6 = wp::load(var_4);
        var_5 = wp::float32(var_6);
        // for seed_idx in range(1, n_seeds):                                                     <L 155>
        var_8 = wp::range(var_7, var_n_seeds);
        // best[problem_idx] = best_seed                                                          <L 162>
        // wp::array_store(var_best, var_0, var_3);
        //---------
        // reverse
        wp::adj_array_store(var_best, var_0, var_3, adj_best, adj_0, adj_3);
        // adj: best[problem_idx] = best_seed                                                     <L 162>
        var_8 = wp::iter_reverse(var_8);
        start_for_0:;
            if (iter_cmp(var_8) == 0) goto end_for_0;
            var_9 = wp::iter_next(var_8);
        	adj_10 = {};
        	adj_11 = {};
        	adj_12 = {};
        	adj_13 = {};
        	adj_14 = {};
        	adj_15 = {};
        	adj_16 = {};
        	adj_17 = {};
        	adj_18 = {};
            // idx = base + seed_idx                                                              <L 156>
            var_10 = wp::add(var_1, var_9);
            // cost = wp.float32(costs[idx])                                                      <L 157>
            var_11 = wp::address(var_costs, var_10);
            var_13 = wp::load(var_11);
            var_12 = wp::float32(var_13);
            // if cost < best_cost:                                                               <L 158>
            var_14 = (var_12 < var_5);
            if (var_14) {
                // best_cost = cost                                                               <L 159>
                var_15 = wp::copy(var_12);
                // best_seed = wp.int32(seed_idx)                                                 <L 160>
                var_16 = wp::int32(var_9);
            }
            var_17 = wp::where(var_14, var_16, var_3);
            var_18 = wp::where(var_14, var_15, var_5);
            wp::assign(var_3, var_17);
            wp::assign(var_5, var_18);
            wp::adj_assign(var_5, var_18, adj_5, adj_18);
            wp::adj_assign(var_3, var_17, adj_3, adj_17);
            wp::adj_where(var_14, var_15, var_5, adj_14, adj_15, adj_5, adj_18);
            wp::adj_where(var_14, var_16, var_3, adj_14, adj_16, adj_3, adj_17);
            if (var_14) {
                // adj: best_seed = wp.int32(seed_idx)                                            <L 160>
                wp::adj_copy(var_12, adj_12, adj_15);
                // adj: best_cost = cost                                                          <L 159>
            }
            // adj: if cost < best_cost:                                                          <L 158>
            wp::adj_float32(var_13, adj_11, adj_12);
            wp::adj_address(var_costs, var_10, adj_costs, adj_10, adj_11);
            // adj: cost = wp.float32(costs[idx])                                                 <L 157>
            wp::adj_add(var_1, var_9, adj_1, adj_9, adj_10);
            // adj: idx = base + seed_idx                                                         <L 156>
        	goto start_for_0;
        end_for_0:;
        // adj: for seed_idx in range(1, n_seeds):                                                <L 155>
        wp::adj_float32(var_6, adj_4, adj_5);
        wp::adj_address(var_costs, var_1, adj_costs, adj_1, adj_4);
        // adj: best_cost = wp.float32(costs[base])                                               <L 153>
        // adj: best_seed = wp.int32(0)                                                           <L 152>
        wp::adj_mul(var_0, var_n_seeds, adj_0, adj_n_seeds, adj_1);
        // adj: base = problem_idx * n_seeds                                                      <L 151>
        // adj: problem_idx = wp.tid()                                                            <L 150>
        // adj: def _select_best_seed_indices(                                                    <L 145>
        continue;
    }
}



extern "C" __global__ void _sample_gauss_kernel_589a8227_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::float32> var_joint_q_in,
    wp::int32 var_n_seeds,
    wp::int32 var_n_coords,
    wp::float32 var_noise_std,
    wp::array_t<wp::float32> var_joint_lower,
    wp::array_t<wp::float32> var_joint_upper,
    wp::array_t<wp::int32> var_joint_bounded,
    wp::array_t<wp::uint32> var_base_seed,
    wp::array_t<wp::float32> var_joint_q_out)
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
        wp::int32 var_2;
        wp::range_t var_3;
        wp::int32 var_4;
        wp::float32* var_5;
        wp::float32 var_6;
        wp::float32 var_7;
        const wp::int32 var_8 = 0;
        bool var_9;
        wp::float32 var_10;
        const wp::int32 var_11 = 0;
        wp::uint32* var_12;
        wp::int32 var_13;
        wp::uint32 var_14;
        wp::int32 var_15;
        wp::int32 var_16;
        wp::int32 var_17;
        wp::int32 var_18;
        wp::int32 var_19;
        wp::uint32 var_20;
        wp::float32 var_21;
        wp::float32 var_22;
        wp::float32 var_23;
        wp::int32* var_24;
        wp::int32 var_25;
        wp::float32* var_26;
        wp::float32 var_27;
        wp::float32 var_28;
        wp::float32* var_29;
        wp::float32 var_30;
        wp::float32 var_31;
        wp::float32 var_32;
        wp::float32 var_33;
        wp::int32 var_34;
        wp::float32 var_35;
        wp::int32 var_36;
        wp::float32 var_37;
        //---------
        // forward
        // def _sample_gauss_kernel(                                                              <L 63>
        // expanded_idx = wp.tid()                                                                <L 74>
        var_0 = builtin_tid1d();
        // problem_idx = expanded_idx // n_seeds                                                  <L 75>
        var_1 = wp::floordiv(var_0, var_n_seeds);
        // seed_idx = expanded_idx % n_seeds                                                      <L 76>
        var_2 = wp::mod(var_0, var_n_seeds);
        // for coord in range(n_coords):                                                          <L 78>
        var_3 = wp::range(var_n_coords);
        start_for_0:;
            if (iter_cmp(var_3) == 0) goto end_for_0;
            var_4 = wp::iter_next(var_3);
            // base = joint_q_in[problem_idx, coord]                                              <L 79>
            var_5 = wp::address(var_joint_q_in, var_1, var_4);
            var_7 = wp::load(var_5);
            var_6 = wp::copy(var_7);
            // if seed_idx == 0:                                                                  <L 80>
            var_9 = (var_2 == var_8);
            if (var_9) {
                // val = base                                                                     <L 81>
                var_10 = wp::copy(var_6);
            }
            if (!var_9) {
                // seed = wp.int32(base_seed[0])                                                  <L 83>
                var_12 = wp::address(var_base_seed, var_11);
                var_14 = wp::load(var_12);
                var_13 = wp::int32(var_14);
                // offset = wp.int32(expanded_idx) * wp.int32(n_coords) + wp.int32(coord)         <L 84>
                var_15 = wp::int32(var_0);
                var_16 = wp::int32(var_n_coords);
                var_17 = wp::mul(var_15, var_16);
                var_18 = wp::int32(var_4);
                var_19 = wp::add(var_17, var_18);
                // state = wp.rand_init(seed, offset)                                             <L 85>
                var_20 = wp::rand_init(var_13, var_19);
                // val = base + wp.randn(state) * noise_std                                       <L 86>
                var_21 = wp::randn(var_20);
                var_22 = wp::mul(var_21, var_noise_std);
                var_23 = wp::add(var_6, var_22);
                // if joint_bounded[coord]:                                                       <L 87>
                var_24 = wp::address(var_joint_bounded, var_4);
                var_25 = wp::load(var_24);
                if (var_25) {
                    // lo = joint_lower[coord]                                                    <L 88>
                    var_26 = wp::address(var_joint_lower, var_4);
                    var_28 = wp::load(var_26);
                    var_27 = wp::copy(var_28);
                    // hi = joint_upper[coord]                                                    <L 89>
                    var_29 = wp::address(var_joint_upper, var_4);
                    var_31 = wp::load(var_29);
                    var_30 = wp::copy(var_31);
                    // val = wp.min(wp.max(val, lo), hi)                                          <L 90>
                    var_32 = wp::max(var_23, var_27);
                    var_33 = wp::min(var_32, var_30);
                }
                var_34 = wp::load(var_24);
                var_36 = wp::load(var_24);
                var_35 = wp::where(var_36, var_33, var_23);
            }
            var_37 = wp::where(var_9, var_10, var_35);
            // joint_q_out[expanded_idx, coord] = val                                             <L 91>
            wp::array_store(var_joint_q_out, var_0, var_4, var_37);
            goto start_for_0;
        end_for_0:;
    }
}



extern "C" __global__ void _sample_gauss_kernel_589a8227_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::float32> var_joint_q_in,
    wp::int32 var_n_seeds,
    wp::int32 var_n_coords,
    wp::float32 var_noise_std,
    wp::array_t<wp::float32> var_joint_lower,
    wp::array_t<wp::float32> var_joint_upper,
    wp::array_t<wp::int32> var_joint_bounded,
    wp::array_t<wp::uint32> var_base_seed,
    wp::array_t<wp::float32> var_joint_q_out,
    wp::array_t<wp::float32> adj_joint_q_in,
    wp::int32 adj_n_seeds,
    wp::int32 adj_n_coords,
    wp::float32 adj_noise_std,
    wp::array_t<wp::float32> adj_joint_lower,
    wp::array_t<wp::float32> adj_joint_upper,
    wp::array_t<wp::int32> adj_joint_bounded,
    wp::array_t<wp::uint32> adj_base_seed,
    wp::array_t<wp::float32> adj_joint_q_out)
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
        wp::int32 var_2;
        wp::range_t var_3;
        wp::int32 var_4;
        wp::float32* var_5;
        wp::float32 var_6;
        wp::float32 var_7;
        const wp::int32 var_8 = 0;
        bool var_9;
        wp::float32 var_10;
        const wp::int32 var_11 = 0;
        wp::uint32* var_12;
        wp::int32 var_13;
        wp::uint32 var_14;
        wp::int32 var_15;
        wp::int32 var_16;
        wp::int32 var_17;
        wp::int32 var_18;
        wp::int32 var_19;
        wp::uint32 var_20;
        wp::float32 var_21;
        wp::float32 var_22;
        wp::float32 var_23;
        wp::int32* var_24;
        wp::int32 var_25;
        wp::float32* var_26;
        wp::float32 var_27;
        wp::float32 var_28;
        wp::float32* var_29;
        wp::float32 var_30;
        wp::float32 var_31;
        wp::float32 var_32;
        wp::float32 var_33;
        wp::int32 var_34;
        wp::float32 var_35;
        wp::int32 var_36;
        wp::float32 var_37;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::int32 adj_2 = {};
        wp::range_t adj_3 = {};
        wp::int32 adj_4 = {};
        wp::float32 adj_5 = {};
        wp::float32 adj_6 = {};
        wp::float32 adj_7 = {};
        wp::int32 adj_8 = {};
        bool adj_9 = {};
        wp::float32 adj_10 = {};
        wp::int32 adj_11 = {};
        wp::uint32 adj_12 = {};
        wp::int32 adj_13 = {};
        wp::uint32 adj_14 = {};
        wp::int32 adj_15 = {};
        wp::int32 adj_16 = {};
        wp::int32 adj_17 = {};
        wp::int32 adj_18 = {};
        wp::int32 adj_19 = {};
        wp::uint32 adj_20 = {};
        wp::float32 adj_21 = {};
        wp::float32 adj_22 = {};
        wp::float32 adj_23 = {};
        wp::int32 adj_24 = {};
        wp::int32 adj_25 = {};
        wp::float32 adj_26 = {};
        wp::float32 adj_27 = {};
        wp::float32 adj_28 = {};
        wp::float32 adj_29 = {};
        wp::float32 adj_30 = {};
        wp::float32 adj_31 = {};
        wp::float32 adj_32 = {};
        wp::float32 adj_33 = {};
        wp::int32 adj_34 = {};
        wp::float32 adj_35 = {};
        wp::int32 adj_36 = {};
        wp::float32 adj_37 = {};
        //---------
        // forward
        // def _sample_gauss_kernel(                                                              <L 63>
        // expanded_idx = wp.tid()                                                                <L 74>
        var_0 = builtin_tid1d();
        // problem_idx = expanded_idx // n_seeds                                                  <L 75>
        var_1 = wp::floordiv(var_0, var_n_seeds);
        // seed_idx = expanded_idx % n_seeds                                                      <L 76>
        var_2 = wp::mod(var_0, var_n_seeds);
        // for coord in range(n_coords):                                                          <L 78>
        var_3 = wp::range(var_n_coords);
        //---------
        // reverse
        var_3 = wp::iter_reverse(var_3);
        start_for_0:;
            if (iter_cmp(var_3) == 0) goto end_for_0;
            var_4 = wp::iter_next(var_3);
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
            // base = joint_q_in[problem_idx, coord]                                              <L 79>
            var_5 = wp::address(var_joint_q_in, var_1, var_4);
            var_7 = wp::load(var_5);
            var_6 = wp::copy(var_7);
            // if seed_idx == 0:                                                                  <L 80>
            var_9 = (var_2 == var_8);
            if (var_9) {
                // val = base                                                                     <L 81>
                var_10 = wp::copy(var_6);
            }
            if (!var_9) {
                // seed = wp.int32(base_seed[0])                                                  <L 83>
                var_12 = wp::address(var_base_seed, var_11);
                var_14 = wp::load(var_12);
                var_13 = wp::int32(var_14);
                // offset = wp.int32(expanded_idx) * wp.int32(n_coords) + wp.int32(coord)         <L 84>
                var_15 = wp::int32(var_0);
                var_16 = wp::int32(var_n_coords);
                var_17 = wp::mul(var_15, var_16);
                var_18 = wp::int32(var_4);
                var_19 = wp::add(var_17, var_18);
                // state = wp.rand_init(seed, offset)                                             <L 85>
                var_20 = wp::rand_init(var_13, var_19);
                // val = base + wp.randn(state) * noise_std                                       <L 86>
                var_21 = wp::randn(var_20);
                var_22 = wp::mul(var_21, var_noise_std);
                var_23 = wp::add(var_6, var_22);
                // if joint_bounded[coord]:                                                       <L 87>
                var_24 = wp::address(var_joint_bounded, var_4);
                var_25 = wp::load(var_24);
                if (var_25) {
                    // lo = joint_lower[coord]                                                    <L 88>
                    var_26 = wp::address(var_joint_lower, var_4);
                    var_28 = wp::load(var_26);
                    var_27 = wp::copy(var_28);
                    // hi = joint_upper[coord]                                                    <L 89>
                    var_29 = wp::address(var_joint_upper, var_4);
                    var_31 = wp::load(var_29);
                    var_30 = wp::copy(var_31);
                    // val = wp.min(wp.max(val, lo), hi)                                          <L 90>
                    var_32 = wp::max(var_23, var_27);
                    var_33 = wp::min(var_32, var_30);
                }
                var_34 = wp::load(var_24);
                var_36 = wp::load(var_24);
                var_35 = wp::where(var_36, var_33, var_23);
            }
            var_37 = wp::where(var_9, var_10, var_35);
            // joint_q_out[expanded_idx, coord] = val                                             <L 91>
            // wp::array_store(var_joint_q_out, var_0, var_4, var_37);
            wp::adj_array_store(var_joint_q_out, var_0, var_4, var_37, adj_joint_q_out, adj_0, adj_4, adj_37);
            // adj: joint_q_out[expanded_idx, coord] = val                                        <L 91>
            wp::adj_where(var_9, var_10, var_35, adj_9, adj_10, adj_35, adj_37);
            if (!var_9) {
                wp::adj_where(var_36, var_33, var_23, adj_24, adj_33, adj_23, adj_35);
                if (var_34) {
                    wp::adj_min(var_32, var_30, adj_32, adj_30, adj_33);
                    wp::adj_max(var_23, var_27, adj_23, adj_27, adj_32);
                    // adj: val = wp.min(wp.max(val, lo), hi)                                     <L 90>
                    wp::adj_copy(var_31, adj_29, adj_30);
                    wp::adj_address(var_joint_upper, var_4, adj_joint_upper, adj_4, adj_29);
                    // adj: hi = joint_upper[coord]                                               <L 89>
                    wp::adj_copy(var_28, adj_26, adj_27);
                    wp::adj_address(var_joint_lower, var_4, adj_joint_lower, adj_4, adj_26);
                    // adj: lo = joint_lower[coord]                                               <L 88>
                }
                wp::adj_address(var_joint_bounded, var_4, adj_joint_bounded, adj_4, adj_24);
                // adj: if joint_bounded[coord]:                                                  <L 87>
                wp::adj_add(var_6, var_22, adj_6, adj_22, adj_23);
                wp::adj_mul(var_21, var_noise_std, adj_21, adj_noise_std, adj_22);
                // adj: val = base + wp.randn(state) * noise_std                                  <L 86>
                // adj: state = wp.rand_init(seed, offset)                                        <L 85>
                wp::adj_add(var_17, var_18, adj_17, adj_18, adj_19);
                wp::adj_mul(var_15, var_16, adj_15, adj_16, adj_17);
                // adj: offset = wp.int32(expanded_idx) * wp.int32(n_coords) + wp.int32(coord)    <L 84>
                wp::adj_address(var_base_seed, var_11, adj_base_seed, adj_11, adj_12);
                // adj: seed = wp.int32(base_seed[0])                                             <L 83>
            }
            if (var_9) {
                wp::adj_copy(var_6, adj_6, adj_10);
                // adj: val = base                                                                <L 81>
            }
            // adj: if seed_idx == 0:                                                             <L 80>
            wp::adj_copy(var_7, adj_5, adj_6);
            wp::adj_address(var_joint_q_in, var_1, var_4, adj_joint_q_in, adj_1, adj_4, adj_5);
            // adj: base = joint_q_in[problem_idx, coord]                                         <L 79>
        	goto start_for_0;
        end_for_0:;
        // adj: for coord in range(n_coords):                                                     <L 78>
        wp::adj_mod(var_0, var_n_seeds, adj_0, adj_n_seeds, adj_2);
        // adj: seed_idx = expanded_idx % n_seeds                                                 <L 76>
        // adj: problem_idx = expanded_idx // n_seeds                                             <L 75>
        // adj: expanded_idx = wp.tid()                                                           <L 74>
        // adj: def _sample_gauss_kernel(                                                         <L 63>
        continue;
    }
}



extern "C" __global__ void _sample_none_kernel_facdbc61_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::float32> var_joint_q_in,
    wp::int32 var_n_seeds,
    wp::int32 var_n_coords,
    wp::array_t<wp::float32> var_joint_q_out)
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
        // def _sample_none_kernel(                                                               <L 49>
        // expanded_idx = wp.tid()                                                                <L 55>
        var_0 = builtin_tid1d();
        // problem_idx = expanded_idx // n_seeds                                                  <L 56>
        var_1 = wp::floordiv(var_0, var_n_seeds);
        // for coord in range(n_coords):                                                          <L 58>
        var_2 = wp::range(var_n_coords);
        start_for_0:;
            if (iter_cmp(var_2) == 0) goto end_for_0;
            var_3 = wp::iter_next(var_2);
            // joint_q_out[expanded_idx, coord] = joint_q_in[problem_idx, coord]                  <L 59>
            var_4 = wp::address(var_joint_q_in, var_1, var_3);
            var_5 = wp::load(var_4);
            wp::array_store(var_joint_q_out, var_0, var_3, var_5);
            goto start_for_0;
        end_for_0:;
    }
}



extern "C" __global__ void _sample_none_kernel_facdbc61_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::float32> var_joint_q_in,
    wp::int32 var_n_seeds,
    wp::int32 var_n_coords,
    wp::array_t<wp::float32> var_joint_q_out,
    wp::array_t<wp::float32> adj_joint_q_in,
    wp::int32 adj_n_seeds,
    wp::int32 adj_n_coords,
    wp::array_t<wp::float32> adj_joint_q_out)
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
        // def _sample_none_kernel(                                                               <L 49>
        // expanded_idx = wp.tid()                                                                <L 55>
        var_0 = builtin_tid1d();
        // problem_idx = expanded_idx // n_seeds                                                  <L 56>
        var_1 = wp::floordiv(var_0, var_n_seeds);
        // for coord in range(n_coords):                                                          <L 58>
        var_2 = wp::range(var_n_coords);
        //---------
        // reverse
        var_2 = wp::iter_reverse(var_2);
        start_for_0:;
            if (iter_cmp(var_2) == 0) goto end_for_0;
            var_3 = wp::iter_next(var_2);
        	adj_4 = {};
        	adj_5 = {};
            // joint_q_out[expanded_idx, coord] = joint_q_in[problem_idx, coord]                  <L 59>
            var_4 = wp::address(var_joint_q_in, var_1, var_3);
            var_5 = wp::load(var_4);
            // wp::array_store(var_joint_q_out, var_0, var_3, var_5);
            wp::adj_array_store(var_joint_q_out, var_0, var_3, var_5, adj_joint_q_out, adj_0, adj_3, adj_4);
            wp::adj_address(var_joint_q_in, var_1, var_3, adj_joint_q_in, adj_1, adj_3, adj_4);
            // adj: joint_q_out[expanded_idx, coord] = joint_q_in[problem_idx, coord]             <L 59>
        	goto start_for_0;
        end_for_0:;
        // adj: for coord in range(n_coords):                                                     <L 58>
        // adj: problem_idx = expanded_idx // n_seeds                                             <L 56>
        // adj: expanded_idx = wp.tid()                                                           <L 55>
        // adj: def _sample_none_kernel(                                                          <L 49>
        continue;
    }
}



extern "C" __global__ void _pull_seed_372939a8_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::uint32> var_seed_state,
    wp::array_t<wp::uint32> var_out_seed)
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
        wp::uint32* var_1;
        const wp::int32 var_2 = 0;
        wp::uint32 var_3;
        const wp::int32 var_4 = 0;
        wp::uint32* var_5;
        const wp::int32 var_6 = 1;
        wp::uint32 var_7;
        wp::uint32 var_8;
        wp::uint32 var_9;
        const wp::int32 var_10 = 0;
        //---------
        // forward
        // def _pull_seed(                                                                        <L 180>
        // out_seed[0] = seed_state[0]                                                            <L 184>
        var_1 = wp::address(var_seed_state, var_0);
        var_3 = wp::load(var_1);
        wp::array_store(var_out_seed, var_2, var_3);
        // seed_state[0] = seed_state[0] + wp.uint32(1)                                           <L 185>
        var_5 = wp::address(var_seed_state, var_4);
        var_7 = wp::uint32(var_6);
        var_9 = wp::load(var_5);
        var_8 = wp::add(var_9, var_7);
        wp::array_store(var_seed_state, var_10, var_8);
    }
}



extern "C" __global__ void _pull_seed_372939a8_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::uint32> var_seed_state,
    wp::array_t<wp::uint32> var_out_seed,
    wp::array_t<wp::uint32> adj_seed_state,
    wp::array_t<wp::uint32> adj_out_seed)
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
        wp::uint32* var_1;
        const wp::int32 var_2 = 0;
        wp::uint32 var_3;
        const wp::int32 var_4 = 0;
        wp::uint32* var_5;
        const wp::int32 var_6 = 1;
        wp::uint32 var_7;
        wp::uint32 var_8;
        wp::uint32 var_9;
        const wp::int32 var_10 = 0;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::uint32 adj_1 = {};
        wp::int32 adj_2 = {};
        wp::uint32 adj_3 = {};
        wp::int32 adj_4 = {};
        wp::uint32 adj_5 = {};
        wp::int32 adj_6 = {};
        wp::uint32 adj_7 = {};
        wp::uint32 adj_8 = {};
        wp::uint32 adj_9 = {};
        wp::int32 adj_10 = {};
        //---------
        // forward
        // def _pull_seed(                                                                        <L 180>
        // out_seed[0] = seed_state[0]                                                            <L 184>
        var_1 = wp::address(var_seed_state, var_0);
        var_3 = wp::load(var_1);
        // wp::array_store(var_out_seed, var_2, var_3);
        // seed_state[0] = seed_state[0] + wp.uint32(1)                                           <L 185>
        var_5 = wp::address(var_seed_state, var_4);
        var_7 = wp::uint32(var_6);
        var_9 = wp::load(var_5);
        var_8 = wp::add(var_9, var_7);
        // wp::array_store(var_seed_state, var_10, var_8);
        //---------
        // reverse
        wp::adj_array_store(var_seed_state, var_10, var_8, adj_seed_state, adj_10, adj_8);
        wp::adj_add(var_9, var_7, adj_5, adj_7, adj_8);
        wp::adj_address(var_seed_state, var_4, adj_seed_state, adj_4, adj_5);
        // adj: seed_state[0] = seed_state[0] + wp.uint32(1)                                      <L 185>
        wp::adj_array_store(var_out_seed, var_2, var_3, adj_out_seed, adj_2, adj_1);
        wp::adj_address(var_seed_state, var_0, adj_seed_state, adj_0, adj_1);
        // adj: out_seed[0] = seed_state[0]                                                       <L 184>
        // adj: def _pull_seed(                                                                   <L 180>
        continue;
    }
}

