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



extern "C" __global__ void set_conveyor_belt_state_edc71427_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::int32 var_belt_joint_q_start,
    wp::int32 var_belt_joint_qd_start,
    wp::array_t<wp::float32> var_sim_time,
    wp::float32 var_belt_angular_speed,
    wp::array_t<wp::float32> var_joint_q,
    wp::array_t<wp::float32> var_joint_qd)
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
        wp::float32* var_1;
        wp::float32 var_2;
        wp::float32 var_3;
        //---------
        // forward
        // def set_conveyor_belt_state(                                                           <L 133>
        // angle = belt_angular_speed * sim_time[0]                                               <L 143>
        var_1 = wp::address(var_sim_time, var_0);
        var_3 = wp::load(var_1);
        var_2 = wp::mul(var_belt_angular_speed, var_3);
        // joint_q[belt_joint_q_start] = angle                                                    <L 144>
        wp::array_store(var_joint_q, var_belt_joint_q_start, var_2);
        // joint_qd[belt_joint_qd_start] = belt_angular_speed                                     <L 145>
        wp::array_store(var_joint_qd, var_belt_joint_qd_start, var_belt_angular_speed);
    }
}



extern "C" __global__ void set_conveyor_belt_state_edc71427_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::int32 var_belt_joint_q_start,
    wp::int32 var_belt_joint_qd_start,
    wp::array_t<wp::float32> var_sim_time,
    wp::float32 var_belt_angular_speed,
    wp::array_t<wp::float32> var_joint_q,
    wp::array_t<wp::float32> var_joint_qd,
    wp::int32 adj_belt_joint_q_start,
    wp::int32 adj_belt_joint_qd_start,
    wp::array_t<wp::float32> adj_sim_time,
    wp::float32 adj_belt_angular_speed,
    wp::array_t<wp::float32> adj_joint_q,
    wp::array_t<wp::float32> adj_joint_qd)
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
        wp::float32* var_1;
        wp::float32 var_2;
        wp::float32 var_3;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::float32 adj_1 = {};
        wp::float32 adj_2 = {};
        wp::float32 adj_3 = {};
        //---------
        // forward
        // def set_conveyor_belt_state(                                                           <L 133>
        // angle = belt_angular_speed * sim_time[0]                                               <L 143>
        var_1 = wp::address(var_sim_time, var_0);
        var_3 = wp::load(var_1);
        var_2 = wp::mul(var_belt_angular_speed, var_3);
        // joint_q[belt_joint_q_start] = angle                                                    <L 144>
        // wp::array_store(var_joint_q, var_belt_joint_q_start, var_2);
        // joint_qd[belt_joint_qd_start] = belt_angular_speed                                     <L 145>
        // wp::array_store(var_joint_qd, var_belt_joint_qd_start, var_belt_angular_speed);
        //---------
        // reverse
        wp::adj_array_store(var_joint_qd, var_belt_joint_qd_start, var_belt_angular_speed, adj_joint_qd, adj_belt_joint_qd_start, adj_belt_angular_speed);
        // adj: joint_qd[belt_joint_qd_start] = belt_angular_speed                                <L 145>
        wp::adj_array_store(var_joint_q, var_belt_joint_q_start, var_2, adj_joint_q, adj_belt_joint_q_start, adj_2);
        // adj: joint_q[belt_joint_q_start] = angle                                               <L 144>
        wp::adj_mul(var_belt_angular_speed, var_3, adj_belt_angular_speed, adj_1, adj_2);
        wp::adj_address(var_sim_time, var_0, adj_sim_time, adj_0, adj_1);
        // adj: angle = belt_angular_speed * sim_time[0]                                          <L 143>
        // adj: def set_conveyor_belt_state(                                                      <L 133>
        continue;
    }
}



extern "C" __global__ void advance_time_5d255a6c_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::float32> var_sim_time,
    wp::float32 var_dt)
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
        wp::float32* var_1;
        wp::float32 var_2;
        wp::float32 var_3;
        const wp::int32 var_4 = 0;
        //---------
        // forward
        // def advance_time(sim_time: wp.array[wp.float32], dt: float):                           <L 149>
        // sim_time[0] = sim_time[0] + dt                                                         <L 150>
        var_1 = wp::address(var_sim_time, var_0);
        var_3 = wp::load(var_1);
        var_2 = wp::add(var_3, var_dt);
        wp::array_store(var_sim_time, var_4, var_2);
    }
}



extern "C" __global__ void advance_time_5d255a6c_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::float32> var_sim_time,
    wp::float32 var_dt,
    wp::array_t<wp::float32> adj_sim_time,
    wp::float32 adj_dt)
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
        wp::float32* var_1;
        wp::float32 var_2;
        wp::float32 var_3;
        const wp::int32 var_4 = 0;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::float32 adj_1 = {};
        wp::float32 adj_2 = {};
        wp::float32 adj_3 = {};
        wp::int32 adj_4 = {};
        //---------
        // forward
        // def advance_time(sim_time: wp.array[wp.float32], dt: float):                           <L 149>
        // sim_time[0] = sim_time[0] + dt                                                         <L 150>
        var_1 = wp::address(var_sim_time, var_0);
        var_3 = wp::load(var_1);
        var_2 = wp::add(var_3, var_dt);
        // wp::array_store(var_sim_time, var_4, var_2);
        //---------
        // reverse
        wp::adj_array_store(var_sim_time, var_4, var_2, adj_sim_time, adj_4, adj_2);
        wp::adj_add(var_3, var_dt, adj_1, adj_dt, adj_2);
        wp::adj_address(var_sim_time, var_0, adj_sim_time, adj_0, adj_1);
        // adj: sim_time[0] = sim_time[0] + dt                                                    <L 150>
        // adj: def advance_time(sim_time: wp.array[wp.float32], dt: float):                      <L 149>
        continue;
    }
}

