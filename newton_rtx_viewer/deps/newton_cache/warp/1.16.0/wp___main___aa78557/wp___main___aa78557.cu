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



extern "C" __global__ void _ovstream_copy_vec4ub_to_bgra_kernel__locals__copy_vec4ub_to_bgra_8191a9a3_cuda_kernel_forward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::vec_t<4, wp::uint8>> var_src,
    wp::array_t<wp::uint8> var_dst)
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
        wp::vec_t<4, wp::uint8>* var_2;
        wp::vec_t<4, wp::uint8> var_3;
        wp::vec_t<4, wp::uint8> var_4;
        const wp::int32 var_5 = 2;
        wp::uint8 var_6;
        const wp::int32 var_7 = 0;
        const wp::int32 var_8 = 1;
        wp::uint8 var_9;
        const wp::int32 var_10 = 1;
        const wp::int32 var_11 = 0;
        wp::uint8 var_12;
        const wp::int32 var_13 = 2;
        const wp::int32 var_14 = 3;
        wp::uint8 var_15;
        const wp::int32 var_16 = 3;
        //---------
        // forward
        // def copy_vec4ub_to_bgra(src: wp.array2d(dtype=wp.vec4ub), dst: wp.array3d(dtype=wp.uint8)):       <L 1327>
        // x, y = wp.tid()                                                                        <L 1328>
        builtin_tid2d(var_0, var_1);
        // rgba = src[y, x]                                                                       <L 1329>
        var_2 = wp::address(var_src, var_1, var_0);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // dst[y, x, 0] = rgba[2]                                                                 <L 1330>
        var_6 = wp::extract(var_3, var_5);
        wp::array_store(var_dst, var_1, var_0, var_7, var_6);
        // dst[y, x, 1] = rgba[1]                                                                 <L 1331>
        var_9 = wp::extract(var_3, var_8);
        wp::array_store(var_dst, var_1, var_0, var_10, var_9);
        // dst[y, x, 2] = rgba[0]                                                                 <L 1332>
        var_12 = wp::extract(var_3, var_11);
        wp::array_store(var_dst, var_1, var_0, var_13, var_12);
        // dst[y, x, 3] = rgba[3]                                                                 <L 1333>
        var_15 = wp::extract(var_3, var_14);
        wp::array_store(var_dst, var_1, var_0, var_16, var_15);
    }
}



extern "C" __global__ void _ovstream_copy_vec4ub_to_bgra_kernel__locals__copy_vec4ub_to_bgra_8191a9a3_cuda_kernel_backward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::vec_t<4, wp::uint8>> var_src,
    wp::array_t<wp::uint8> var_dst,
    wp::array_t<wp::vec_t<4, wp::uint8>> adj_src,
    wp::array_t<wp::uint8> adj_dst)
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
        wp::vec_t<4, wp::uint8>* var_2;
        wp::vec_t<4, wp::uint8> var_3;
        wp::vec_t<4, wp::uint8> var_4;
        const wp::int32 var_5 = 2;
        wp::uint8 var_6;
        const wp::int32 var_7 = 0;
        const wp::int32 var_8 = 1;
        wp::uint8 var_9;
        const wp::int32 var_10 = 1;
        const wp::int32 var_11 = 0;
        wp::uint8 var_12;
        const wp::int32 var_13 = 2;
        const wp::int32 var_14 = 3;
        wp::uint8 var_15;
        const wp::int32 var_16 = 3;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::vec_t<4, wp::uint8> adj_2 = {};
        wp::vec_t<4, wp::uint8> adj_3 = {};
        wp::vec_t<4, wp::uint8> adj_4 = {};
        wp::int32 adj_5 = {};
        wp::uint8 adj_6 = {};
        wp::int32 adj_7 = {};
        wp::int32 adj_8 = {};
        wp::uint8 adj_9 = {};
        wp::int32 adj_10 = {};
        wp::int32 adj_11 = {};
        wp::uint8 adj_12 = {};
        wp::int32 adj_13 = {};
        wp::int32 adj_14 = {};
        wp::uint8 adj_15 = {};
        wp::int32 adj_16 = {};
        //---------
        // forward
        // def copy_vec4ub_to_bgra(src: wp.array2d(dtype=wp.vec4ub), dst: wp.array3d(dtype=wp.uint8)):       <L 1327>
        // x, y = wp.tid()                                                                        <L 1328>
        builtin_tid2d(var_0, var_1);
        // rgba = src[y, x]                                                                       <L 1329>
        var_2 = wp::address(var_src, var_1, var_0);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // dst[y, x, 0] = rgba[2]                                                                 <L 1330>
        var_6 = wp::extract(var_3, var_5);
        // wp::array_store(var_dst, var_1, var_0, var_7, var_6);
        // dst[y, x, 1] = rgba[1]                                                                 <L 1331>
        var_9 = wp::extract(var_3, var_8);
        // wp::array_store(var_dst, var_1, var_0, var_10, var_9);
        // dst[y, x, 2] = rgba[0]                                                                 <L 1332>
        var_12 = wp::extract(var_3, var_11);
        // wp::array_store(var_dst, var_1, var_0, var_13, var_12);
        // dst[y, x, 3] = rgba[3]                                                                 <L 1333>
        var_15 = wp::extract(var_3, var_14);
        // wp::array_store(var_dst, var_1, var_0, var_16, var_15);
        //---------
        // reverse
        wp::adj_array_store(var_dst, var_1, var_0, var_16, var_15, adj_dst, adj_1, adj_0, adj_16, adj_15);
        wp::adj_extract(var_3, var_14, adj_3, adj_14, adj_15);
        // adj: dst[y, x, 3] = rgba[3]                                                            <L 1333>
        wp::adj_array_store(var_dst, var_1, var_0, var_13, var_12, adj_dst, adj_1, adj_0, adj_13, adj_12);
        wp::adj_extract(var_3, var_11, adj_3, adj_11, adj_12);
        // adj: dst[y, x, 2] = rgba[0]                                                            <L 1332>
        wp::adj_array_store(var_dst, var_1, var_0, var_10, var_9, adj_dst, adj_1, adj_0, adj_10, adj_9);
        wp::adj_extract(var_3, var_8, adj_3, adj_8, adj_9);
        // adj: dst[y, x, 1] = rgba[1]                                                            <L 1331>
        wp::adj_array_store(var_dst, var_1, var_0, var_7, var_6, adj_dst, adj_1, adj_0, adj_7, adj_6);
        wp::adj_extract(var_3, var_5, adj_3, adj_5, adj_6);
        // adj: dst[y, x, 0] = rgba[2]                                                            <L 1330>
        wp::adj_copy(var_4, adj_2, adj_3);
        wp::adj_address(var_src, var_1, var_0, adj_src, adj_1, adj_0, adj_2);
        // adj: rgba = src[y, x]                                                                  <L 1329>
        // adj: x, y = wp.tid()                                                                   <L 1328>
        // adj: def copy_vec4ub_to_bgra(src: wp.array2d(dtype=wp.vec4ub), dst: wp.array3d(dtype=wp.uint8)):  <L 1327>
        continue;
    }
}



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
        // def swap_rb(buf: wp.array3d(dtype=wp.uint8)):                                          <L 1315>
        // x, y = wp.tid()                                                                        <L 1316>
        builtin_tid2d(var_0, var_1);
        // r = buf[y, x, 0]                                                                       <L 1317>
        var_3 = wp::address(var_buf, var_1, var_0, var_2);
        var_5 = wp::load(var_3);
        var_4 = wp::copy(var_5);
        // b = buf[y, x, 2]                                                                       <L 1318>
        var_7 = wp::address(var_buf, var_1, var_0, var_6);
        var_9 = wp::load(var_7);
        var_8 = wp::copy(var_9);
        // buf[y, x, 0] = b                                                                       <L 1319>
        wp::array_store(var_buf, var_1, var_0, var_10, var_8);
        // buf[y, x, 2] = r                                                                       <L 1320>
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
        // def swap_rb(buf: wp.array3d(dtype=wp.uint8)):                                          <L 1315>
        // x, y = wp.tid()                                                                        <L 1316>
        builtin_tid2d(var_0, var_1);
        // r = buf[y, x, 0]                                                                       <L 1317>
        var_3 = wp::address(var_buf, var_1, var_0, var_2);
        var_5 = wp::load(var_3);
        var_4 = wp::copy(var_5);
        // b = buf[y, x, 2]                                                                       <L 1318>
        var_7 = wp::address(var_buf, var_1, var_0, var_6);
        var_9 = wp::load(var_7);
        var_8 = wp::copy(var_9);
        // buf[y, x, 0] = b                                                                       <L 1319>
        // wp::array_store(var_buf, var_1, var_0, var_10, var_8);
        // buf[y, x, 2] = r                                                                       <L 1320>
        // wp::array_store(var_buf, var_1, var_0, var_11, var_4);
        //---------
        // reverse
        wp::adj_array_store(var_buf, var_1, var_0, var_11, var_4, adj_buf, adj_1, adj_0, adj_11, adj_4);
        // adj: buf[y, x, 2] = r                                                                  <L 1320>
        wp::adj_array_store(var_buf, var_1, var_0, var_10, var_8, adj_buf, adj_1, adj_0, adj_10, adj_8);
        // adj: buf[y, x, 0] = b                                                                  <L 1319>
        wp::adj_copy(var_9, adj_7, adj_8);
        wp::adj_address(var_buf, var_1, var_0, var_6, adj_buf, adj_1, adj_0, adj_6, adj_7);
        // adj: b = buf[y, x, 2]                                                                  <L 1318>
        wp::adj_copy(var_5, adj_3, adj_4);
        wp::adj_address(var_buf, var_1, var_0, var_2, adj_buf, adj_1, adj_0, adj_2, adj_3);
        // adj: r = buf[y, x, 0]                                                                  <L 1317>
        // adj: x, y = wp.tid()                                                                   <L 1316>
        // adj: def swap_rb(buf: wp.array3d(dtype=wp.uint8)):                                     <L 1315>
        continue;
    }
}

