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



extern "C" __global__ void _ovstream_swap_rb_kernel__locals__swap_rb_b569b601_cuda_kernel_forward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::uint8> var_buf)
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
        wp::uint8* var_3;
        wp::uint8 var_4;
        wp::uint8 var_5;
        const wp::int32 var_6 = 2;
        wp::uint8* var_7;
        wp::uint8 var_8;
        wp::uint8 var_9;
        const wp::int32 var_10 = 0;
        const wp::int32 var_11 = 2;
        //---------
        // forward
        // def swap_rb(buf: wp.array3d(dtype=wp.uint8)):                                          <L 1289>
        // x, y = wp.tid()                                                                        <L 1290>
        builtin_tid2d(var_0, var_1);
        // r = buf[y, x, 0]                                                                       <L 1291>
        var_3 = wp::address(var_buf, var_1, var_0, var_2);
        var_5 = wp::load(var_3);
        var_4 = wp::copy(var_5);
        // b = buf[y, x, 2]                                                                       <L 1292>
        var_7 = wp::address(var_buf, var_1, var_0, var_6);
        var_9 = wp::load(var_7);
        var_8 = wp::copy(var_9);
        // buf[y, x, 0] = b                                                                       <L 1293>
        wp::array_store(var_buf, var_1, var_0, var_10, var_8);
        // buf[y, x, 2] = r                                                                       <L 1294>
        wp::array_store(var_buf, var_1, var_0, var_11, var_4);
    }
}



extern "C" __global__ void _ovstream_swap_rb_kernel__locals__swap_rb_b569b601_cuda_kernel_backward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::uint8> var_buf,
    wp::array_t<wp::uint8> adj_buf)
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
        wp::uint8* var_3;
        wp::uint8 var_4;
        wp::uint8 var_5;
        const wp::int32 var_6 = 2;
        wp::uint8* var_7;
        wp::uint8 var_8;
        wp::uint8 var_9;
        const wp::int32 var_10 = 0;
        const wp::int32 var_11 = 2;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::int32 adj_2 = {};
        wp::uint8 adj_3 = {};
        wp::uint8 adj_4 = {};
        wp::uint8 adj_5 = {};
        wp::int32 adj_6 = {};
        wp::uint8 adj_7 = {};
        wp::uint8 adj_8 = {};
        wp::uint8 adj_9 = {};
        wp::int32 adj_10 = {};
        wp::int32 adj_11 = {};
        //---------
        // forward
        // def swap_rb(buf: wp.array3d(dtype=wp.uint8)):                                          <L 1289>
        // x, y = wp.tid()                                                                        <L 1290>
        builtin_tid2d(var_0, var_1);
        // r = buf[y, x, 0]                                                                       <L 1291>
        var_3 = wp::address(var_buf, var_1, var_0, var_2);
        var_5 = wp::load(var_3);
        var_4 = wp::copy(var_5);
        // b = buf[y, x, 2]                                                                       <L 1292>
        var_7 = wp::address(var_buf, var_1, var_0, var_6);
        var_9 = wp::load(var_7);
        var_8 = wp::copy(var_9);
        // buf[y, x, 0] = b                                                                       <L 1293>
        // wp::array_store(var_buf, var_1, var_0, var_10, var_8);
        // buf[y, x, 2] = r                                                                       <L 1294>
        // wp::array_store(var_buf, var_1, var_0, var_11, var_4);
        //---------
        // reverse
        wp::adj_array_store(var_buf, var_1, var_0, var_11, var_4, adj_buf, adj_1, adj_0, adj_11, adj_4);
        // adj: buf[y, x, 2] = r                                                                  <L 1294>
        wp::adj_array_store(var_buf, var_1, var_0, var_10, var_8, adj_buf, adj_1, adj_0, adj_10, adj_8);
        // adj: buf[y, x, 0] = b                                                                  <L 1293>
        wp::adj_copy(var_9, adj_7, adj_8);
        wp::adj_address(var_buf, var_1, var_0, var_6, adj_buf, adj_1, adj_0, adj_6, adj_7);
        // adj: b = buf[y, x, 2]                                                                  <L 1292>
        wp::adj_copy(var_5, adj_3, adj_4);
        wp::adj_address(var_buf, var_1, var_0, var_2, adj_buf, adj_1, adj_0, adj_2, adj_3);
        // adj: r = buf[y, x, 0]                                                                  <L 1291>
        // adj: x, y = wp.tid()                                                                   <L 1290>
        // adj: def swap_rb(buf: wp.array3d(dtype=wp.uint8)):                                     <L 1289>
        continue;
    }
}

