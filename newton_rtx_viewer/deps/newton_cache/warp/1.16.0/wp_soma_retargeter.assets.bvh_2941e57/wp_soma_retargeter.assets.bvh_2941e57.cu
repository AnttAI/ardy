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


// /home/jony/Downloads/soma-retargeter/soma_retargeter/assets/bvh.py:14
static CUDA_CALLABLE wp::quat_t<wp::float32> wp_axis_angle_to_quat_xyzw_0(
    wp::vec_t<3, wp::float32> var_axis,
    wp::float32 var_angle,
    wp::float32 var_eps)
{
    //---------
    // primal vars
    wp::float32 var_0;
    wp::float32 var_1;
    wp::float32 var_2;
    wp::vec_t<3, wp::float32> var_3;
    const wp::float32 var_4 = 0.5;
    wp::float32 var_5;
    wp::float32 var_6;
    wp::float32 var_7;
    wp::vec_t<3, wp::float32> var_8;
    const wp::int32 var_9 = 0;
    wp::float32 var_10;
    const wp::int32 var_11 = 1;
    wp::float32 var_12;
    const wp::int32 var_13 = 2;
    wp::float32 var_14;
    wp::quat_t<wp::float32> var_15;
    const wp::int32 var_16 = 0;
    wp::float32 var_17;
    const wp::int32 var_18 = 1;
    wp::float32 var_19;
    const wp::int32 var_20 = 2;
    wp::float32 var_21;
    const wp::int32 var_22 = 3;
    wp::float32 var_23;
    wp::quat_t<wp::float32> var_24;
    wp::quat_t<wp::float32> var_25;
    //---------
    // forward
    // def wp_axis_angle_to_quat_xyzw(                                                        <L 15>
    // angle = wp.radians(angle)                                                              <L 21>
    var_0 = wp::radians(var_angle);
    // norm = wp.length(axis)                                                                 <L 23>
    var_1 = wp::length(var_axis);
    // unit_axis = axis / wp.max(norm, eps)                                                   <L 24>
    var_2 = wp::max(var_1, var_eps);
    var_3 = wp::div(var_axis, var_2);
    // half = angle * 0.5                                                                     <L 26>
    var_5 = wp::mul(var_0, var_4);
    // s = wp.sin(half)                                                                       <L 27>
    var_6 = wp::sin(var_5);
    // c = wp.cos(half)                                                                       <L 28>
    var_7 = wp::cos(var_5);
    // xyz = unit_axis * s                                                                    <L 30>
    var_8 = wp::mul(var_3, var_6);
    // q = wp.quat(xyz[0], xyz[1], xyz[2], c)                                                 <L 31>
    var_10 = wp::extract(var_8, var_9);
    var_12 = wp::extract(var_8, var_11);
    var_14 = wp::extract(var_8, var_13);
    var_15 = wp::quat_t<wp::float32>(var_10, var_12, var_14, var_7);
    // return wp.normalize(wp.quat(q[0], q[1], q[2], q[3]))                                   <L 32>
    var_17 = wp::extract(var_15, var_16);
    var_19 = wp::extract(var_15, var_18);
    var_21 = wp::extract(var_15, var_20);
    var_23 = wp::extract(var_15, var_22);
    var_24 = wp::quat_t<wp::float32>(var_17, var_19, var_21, var_23);
    var_25 = wp::normalize(var_24);
    return var_25;
}


// /home/jony/Downloads/soma-retargeter/soma_retargeter/assets/bvh.py:35
static CUDA_CALLABLE wp::quat_t<wp::float32> wp_get_quaternion_from_axis_0(
    wp::int32 var_axis,
    wp::float32 var_angle)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    bool var_1;
    const wp::float32 var_2 = 1.0;
    const wp::float32 var_3 = 0.0;
    const wp::float32 var_4 = 0.0;
    wp::vec_t<3, wp::float32> var_5;
    wp::quat_t<wp::float32> var_6;
    const wp::float32 var_7 = 1e-08;
    const wp::int32 var_8 = 1;
    bool var_9;
    const wp::float32 var_10 = 0.0;
    const wp::float32 var_11 = 1.0;
    const wp::float32 var_12 = 0.0;
    wp::vec_t<3, wp::float32> var_13;
    wp::quat_t<wp::float32> var_14;
    const wp::float32 var_15 = 1e-08;
    const wp::float32 var_16 = 0.0;
    const wp::float32 var_17 = 0.0;
    const wp::float32 var_18 = 1.0;
    wp::vec_t<3, wp::float32> var_19;
    wp::quat_t<wp::float32> var_20;
    const wp::float32 var_21 = 1e-08;
    //---------
    // forward
    // def wp_get_quaternion_from_axis(                                                       <L 36>
    // if axis == 0:                                                                          <L 41>
    var_1 = (var_axis == var_0);
    if (var_1) {
        // return wp_axis_angle_to_quat_xyzw(wp.vec3(1.0, 0.0, 0.0), angle)                   <L 42>
        var_5 = wp::vec_t<3, wp::float32>(var_2, var_3, var_4);
        var_6 = wp_axis_angle_to_quat_xyzw_0(var_5, var_angle, var_7);
        return var_6;
    }
    if (!var_1) {
        // elif axis == 1:                                                                    <L 43>
        var_9 = (var_axis == var_8);
        if (var_9) {
            // return wp_axis_angle_to_quat_xyzw(wp.vec3(0.0, 1.0, 0.0), angle)               <L 44>
            var_13 = wp::vec_t<3, wp::float32>(var_10, var_11, var_12);
            var_14 = wp_axis_angle_to_quat_xyzw_0(var_13, var_angle, var_15);
            return var_14;
        }
        if (!var_9) {
            // return wp_axis_angle_to_quat_xyzw(wp.vec3(0.0, 0.0, 1.0), angle)               <L 46>
            var_19 = wp::vec_t<3, wp::float32>(var_16, var_17, var_18);
            var_20 = wp_axis_angle_to_quat_xyzw_0(var_19, var_angle, var_21);
            return var_20;
        }
    }
    return {};
}


// /home/jony/Downloads/soma-retargeter/soma_retargeter/assets/bvh.py:49
static CUDA_CALLABLE wp::quat_t<wp::float32> wp_euler_to_quaternion_0(
    wp::array_t<wp::float32> var_euler_angles,
    wp::array_t<wp::int32> var_rotation_order)
{
    //---------
    // primal vars
    const wp::float32 var_0 = 0.0;
    const wp::float32 var_1 = 0.0;
    const wp::float32 var_2 = 0.0;
    const wp::float32 var_3 = 1.0;
    wp::quat_t<wp::float32> var_4;
    wp::shape_t* var_5;
    const wp::int32 var_6 = 0;
    wp::int32 var_7;
    wp::shape_t var_8;
    wp::range_t var_9;
    wp::int32 var_10;
    wp::int32* var_11;
    wp::float32* var_12;
    wp::quat_t<wp::float32> var_13;
    wp::int32 var_14;
    wp::float32 var_15;
    wp::quat_t<wp::float32> var_16;
    wp::quat_t<wp::float32> var_17;
    //---------
    // forward
    // def wp_euler_to_quaternion(                                                            <L 50>
    // quaternion = wp.quat(0.0, 0.0, 0.0, 1.0)                                               <L 56>
    var_4 = wp::quat_t<wp::float32>(var_0, var_1, var_2, var_3);
    // for i in range(rotation_order.shape[0]):                                               <L 57>
    var_5 = &(var_rotation_order.shape);
    var_8 = wp::load(var_5);
    var_7 = wp::extract(var_8, var_6);
    var_9 = wp::range(var_7);
    start_for_0:;
        if (iter_cmp(var_9) == 0) goto end_for_0;
        var_10 = wp::iter_next(var_9);
        // quaternion *= wp_get_quaternion_from_axis(rotation_order[i], euler_angles[i])       <L 58>
        var_11 = wp::address(var_rotation_order, var_10);
        var_12 = wp::address(var_euler_angles, var_10);
        var_14 = wp::load(var_11);
        var_15 = wp::load(var_12);
        var_13 = wp_get_quaternion_from_axis_0(var_14, var_15);
        var_16 = wp::mul(var_4, var_13);
        wp::assign(var_4, var_16);
        goto start_for_0;
    end_for_0:;
    // return wp.normalize(quaternion)                                                        <L 60>
    var_17 = wp::normalize(var_4);
    return var_17;
}


// /home/jony/Downloads/soma-retargeter/soma_retargeter/assets/bvh.py:14
static CUDA_CALLABLE void adj_wp_axis_angle_to_quat_xyzw_0(
    wp::vec_t<3, wp::float32> var_axis,
    wp::float32 var_angle,
    wp::float32 var_eps,
    wp::vec_t<3, wp::float32> & adj_axis,
    wp::float32 & adj_angle,
    wp::float32 & adj_eps,
    wp::quat_t<wp::float32> & adj_ret)
{
    //---------
    // primal vars
    wp::float32 var_0;
    wp::float32 var_1;
    wp::float32 var_2;
    wp::vec_t<3, wp::float32> var_3;
    const wp::float32 var_4 = 0.5;
    wp::float32 var_5;
    wp::float32 var_6;
    wp::float32 var_7;
    wp::vec_t<3, wp::float32> var_8;
    const wp::int32 var_9 = 0;
    wp::float32 var_10;
    const wp::int32 var_11 = 1;
    wp::float32 var_12;
    const wp::int32 var_13 = 2;
    wp::float32 var_14;
    wp::quat_t<wp::float32> var_15;
    const wp::int32 var_16 = 0;
    wp::float32 var_17;
    const wp::int32 var_18 = 1;
    wp::float32 var_19;
    const wp::int32 var_20 = 2;
    wp::float32 var_21;
    const wp::int32 var_22 = 3;
    wp::float32 var_23;
    wp::quat_t<wp::float32> var_24;
    wp::quat_t<wp::float32> var_25;
    //---------
    // dual vars
    wp::float32 adj_0 = {};
    wp::float32 adj_1 = {};
    wp::float32 adj_2 = {};
    wp::vec_t<3, wp::float32> adj_3 = {};
    wp::float32 adj_4 = {};
    wp::float32 adj_5 = {};
    wp::float32 adj_6 = {};
    wp::float32 adj_7 = {};
    wp::vec_t<3, wp::float32> adj_8 = {};
    wp::int32 adj_9 = {};
    wp::float32 adj_10 = {};
    wp::int32 adj_11 = {};
    wp::float32 adj_12 = {};
    wp::int32 adj_13 = {};
    wp::float32 adj_14 = {};
    wp::quat_t<wp::float32> adj_15 = {};
    wp::int32 adj_16 = {};
    wp::float32 adj_17 = {};
    wp::int32 adj_18 = {};
    wp::float32 adj_19 = {};
    wp::int32 adj_20 = {};
    wp::float32 adj_21 = {};
    wp::int32 adj_22 = {};
    wp::float32 adj_23 = {};
    wp::quat_t<wp::float32> adj_24 = {};
    wp::quat_t<wp::float32> adj_25 = {};
    //---------
    // forward
    // def wp_axis_angle_to_quat_xyzw(                                                        <L 15>
    // angle = wp.radians(angle)                                                              <L 21>
    var_0 = wp::radians(var_angle);
    // norm = wp.length(axis)                                                                 <L 23>
    var_1 = wp::length(var_axis);
    // unit_axis = axis / wp.max(norm, eps)                                                   <L 24>
    var_2 = wp::max(var_1, var_eps);
    var_3 = wp::div(var_axis, var_2);
    // half = angle * 0.5                                                                     <L 26>
    var_5 = wp::mul(var_0, var_4);
    // s = wp.sin(half)                                                                       <L 27>
    var_6 = wp::sin(var_5);
    // c = wp.cos(half)                                                                       <L 28>
    var_7 = wp::cos(var_5);
    // xyz = unit_axis * s                                                                    <L 30>
    var_8 = wp::mul(var_3, var_6);
    // q = wp.quat(xyz[0], xyz[1], xyz[2], c)                                                 <L 31>
    var_10 = wp::extract(var_8, var_9);
    var_12 = wp::extract(var_8, var_11);
    var_14 = wp::extract(var_8, var_13);
    var_15 = wp::quat_t<wp::float32>(var_10, var_12, var_14, var_7);
    // return wp.normalize(wp.quat(q[0], q[1], q[2], q[3]))                                   <L 32>
    var_17 = wp::extract(var_15, var_16);
    var_19 = wp::extract(var_15, var_18);
    var_21 = wp::extract(var_15, var_20);
    var_23 = wp::extract(var_15, var_22);
    var_24 = wp::quat_t<wp::float32>(var_17, var_19, var_21, var_23);
    var_25 = wp::normalize(var_24);
    goto label0;
    //---------
    // reverse
    label0:;
    adj_25 += adj_ret;
    wp::adj_normalize(var_24, adj_24, adj_25);
    wp::adj_quat_t(var_17, var_19, var_21, var_23, adj_17, adj_19, adj_21, adj_23, adj_24);
    wp::adj_extract(var_15, var_22, adj_15, adj_22, adj_23);
    wp::adj_extract(var_15, var_20, adj_15, adj_20, adj_21);
    wp::adj_extract(var_15, var_18, adj_15, adj_18, adj_19);
    wp::adj_extract(var_15, var_16, adj_15, adj_16, adj_17);
    // adj: return wp.normalize(wp.quat(q[0], q[1], q[2], q[3]))                              <L 32>
    wp::adj_quat_t(var_10, var_12, var_14, var_7, adj_10, adj_12, adj_14, adj_7, adj_15);
    wp::adj_extract(var_8, var_13, adj_8, adj_13, adj_14);
    wp::adj_extract(var_8, var_11, adj_8, adj_11, adj_12);
    wp::adj_extract(var_8, var_9, adj_8, adj_9, adj_10);
    // adj: q = wp.quat(xyz[0], xyz[1], xyz[2], c)                                            <L 31>
    wp::adj_mul(var_3, var_6, adj_3, adj_6, adj_8);
    // adj: xyz = unit_axis * s                                                               <L 30>
    wp::adj_cos(var_5, adj_5, adj_7);
    // adj: c = wp.cos(half)                                                                  <L 28>
    wp::adj_sin(var_5, adj_5, adj_6);
    // adj: s = wp.sin(half)                                                                  <L 27>
    wp::adj_mul(var_0, var_4, adj_0, adj_4, adj_5);
    // adj: half = angle * 0.5                                                                <L 26>
    wp::adj_div(var_axis, var_2, adj_axis, adj_2, adj_3);
    wp::adj_max(var_1, var_eps, adj_1, adj_eps, adj_2);
    // adj: unit_axis = axis / wp.max(norm, eps)                                              <L 24>
    wp::adj_length(var_axis, var_1, adj_axis, adj_1);
    // adj: norm = wp.length(axis)                                                            <L 23>
    wp::adj_radians(var_angle, adj_angle, adj_0);
    // adj: angle = wp.radians(angle)                                                         <L 21>
    // adj: def wp_axis_angle_to_quat_xyzw(                                                   <L 15>
    return;
}


// /home/jony/Downloads/soma-retargeter/soma_retargeter/assets/bvh.py:35
static CUDA_CALLABLE void adj_wp_get_quaternion_from_axis_0(
    wp::int32 var_axis,
    wp::float32 var_angle,
    wp::int32 & adj_axis,
    wp::float32 & adj_angle,
    wp::quat_t<wp::float32> & adj_ret)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    bool var_1;
    const wp::float32 var_2 = 1.0;
    const wp::float32 var_3 = 0.0;
    const wp::float32 var_4 = 0.0;
    wp::vec_t<3, wp::float32> var_5;
    wp::quat_t<wp::float32> var_6;
    const wp::float32 var_7 = 1e-08;
    const wp::int32 var_8 = 1;
    bool var_9;
    const wp::float32 var_10 = 0.0;
    const wp::float32 var_11 = 1.0;
    const wp::float32 var_12 = 0.0;
    wp::vec_t<3, wp::float32> var_13;
    wp::quat_t<wp::float32> var_14;
    const wp::float32 var_15 = 1e-08;
    const wp::float32 var_16 = 0.0;
    const wp::float32 var_17 = 0.0;
    const wp::float32 var_18 = 1.0;
    wp::vec_t<3, wp::float32> var_19;
    wp::quat_t<wp::float32> var_20;
    const wp::float32 var_21 = 1e-08;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    bool adj_1 = {};
    wp::float32 adj_2 = {};
    wp::float32 adj_3 = {};
    wp::float32 adj_4 = {};
    wp::vec_t<3, wp::float32> adj_5 = {};
    wp::quat_t<wp::float32> adj_6 = {};
    wp::float32 adj_7 = {};
    wp::int32 adj_8 = {};
    bool adj_9 = {};
    wp::float32 adj_10 = {};
    wp::float32 adj_11 = {};
    wp::float32 adj_12 = {};
    wp::vec_t<3, wp::float32> adj_13 = {};
    wp::quat_t<wp::float32> adj_14 = {};
    wp::float32 adj_15 = {};
    wp::float32 adj_16 = {};
    wp::float32 adj_17 = {};
    wp::float32 adj_18 = {};
    wp::vec_t<3, wp::float32> adj_19 = {};
    wp::quat_t<wp::float32> adj_20 = {};
    wp::float32 adj_21 = {};
    //---------
    // forward
    // def wp_get_quaternion_from_axis(                                                       <L 36>
    // if axis == 0:                                                                          <L 41>
    var_1 = (var_axis == var_0);
    if (var_1) {
        // return wp_axis_angle_to_quat_xyzw(wp.vec3(1.0, 0.0, 0.0), angle)                   <L 42>
        var_5 = wp::vec_t<3, wp::float32>(var_2, var_3, var_4);
        var_6 = wp_axis_angle_to_quat_xyzw_0(var_5, var_angle, var_7);
        goto label0;
    }
    if (!var_1) {
        // elif axis == 1:                                                                    <L 43>
        var_9 = (var_axis == var_8);
        if (var_9) {
            // return wp_axis_angle_to_quat_xyzw(wp.vec3(0.0, 1.0, 0.0), angle)               <L 44>
            var_13 = wp::vec_t<3, wp::float32>(var_10, var_11, var_12);
            var_14 = wp_axis_angle_to_quat_xyzw_0(var_13, var_angle, var_15);
            goto label1;
        }
        if (!var_9) {
            // return wp_axis_angle_to_quat_xyzw(wp.vec3(0.0, 0.0, 1.0), angle)               <L 46>
            var_19 = wp::vec_t<3, wp::float32>(var_16, var_17, var_18);
            var_20 = wp_axis_angle_to_quat_xyzw_0(var_19, var_angle, var_21);
            goto label2;
        }
    }
    //---------
    // reverse
    if (!var_1) {
        if (!var_9) {
            label2:;
            adj_20 += adj_ret;
            adj_wp_axis_angle_to_quat_xyzw_0(var_19, var_angle, var_21, adj_19, adj_angle, adj_21, adj_20);
            wp::adj_vec_t(var_16, var_17, var_18, adj_16, adj_17, adj_18, adj_19);
            // adj: return wp_axis_angle_to_quat_xyzw(wp.vec3(0.0, 0.0, 1.0), angle)          <L 46>
        }
        if (var_9) {
            label1:;
            adj_14 += adj_ret;
            adj_wp_axis_angle_to_quat_xyzw_0(var_13, var_angle, var_15, adj_13, adj_angle, adj_15, adj_14);
            wp::adj_vec_t(var_10, var_11, var_12, adj_10, adj_11, adj_12, adj_13);
            // adj: return wp_axis_angle_to_quat_xyzw(wp.vec3(0.0, 1.0, 0.0), angle)          <L 44>
        }
        // adj: elif axis == 1:                                                               <L 43>
    }
    if (var_1) {
        label0:;
        adj_6 += adj_ret;
        adj_wp_axis_angle_to_quat_xyzw_0(var_5, var_angle, var_7, adj_5, adj_angle, adj_7, adj_6);
        wp::adj_vec_t(var_2, var_3, var_4, adj_2, adj_3, adj_4, adj_5);
        // adj: return wp_axis_angle_to_quat_xyzw(wp.vec3(1.0, 0.0, 0.0), angle)              <L 42>
    }
    // adj: if axis == 0:                                                                     <L 41>
    // adj: def wp_get_quaternion_from_axis(                                                  <L 36>
    return;
}


// /home/jony/Downloads/soma-retargeter/soma_retargeter/assets/bvh.py:49
static CUDA_CALLABLE void adj_wp_euler_to_quaternion_0(
    wp::array_t<wp::float32> var_euler_angles,
    wp::array_t<wp::int32> var_rotation_order,
    wp::array_t<wp::float32> & adj_euler_angles,
    wp::array_t<wp::int32> & adj_rotation_order,
    wp::quat_t<wp::float32> & adj_ret)
{
    //---------
    // primal vars
    const wp::float32 var_0 = 0.0;
    const wp::float32 var_1 = 0.0;
    const wp::float32 var_2 = 0.0;
    const wp::float32 var_3 = 1.0;
    wp::quat_t<wp::float32> var_4;
    wp::shape_t* var_5;
    const wp::int32 var_6 = 0;
    wp::int32 var_7;
    wp::shape_t var_8;
    wp::range_t var_9;
    wp::int32 var_10;
    wp::int32* var_11;
    wp::float32* var_12;
    wp::quat_t<wp::float32> var_13;
    wp::int32 var_14;
    wp::float32 var_15;
    wp::quat_t<wp::float32> var_16;
    wp::quat_t<wp::float32> var_17;
    //---------
    // dual vars
    wp::float32 adj_0 = {};
    wp::float32 adj_1 = {};
    wp::float32 adj_2 = {};
    wp::float32 adj_3 = {};
    wp::quat_t<wp::float32> adj_4 = {};
    wp::shape_t adj_5 = {};
    wp::int32 adj_6 = {};
    wp::int32 adj_7 = {};
    wp::shape_t adj_8 = {};
    wp::range_t adj_9 = {};
    wp::int32 adj_10 = {};
    wp::int32 adj_11 = {};
    wp::float32 adj_12 = {};
    wp::quat_t<wp::float32> adj_13 = {};
    wp::int32 adj_14 = {};
    wp::float32 adj_15 = {};
    wp::quat_t<wp::float32> adj_16 = {};
    wp::quat_t<wp::float32> adj_17 = {};
    //---------
    // forward
    // def wp_euler_to_quaternion(                                                            <L 50>
    // quaternion = wp.quat(0.0, 0.0, 0.0, 1.0)                                               <L 56>
    var_4 = wp::quat_t<wp::float32>(var_0, var_1, var_2, var_3);
    // for i in range(rotation_order.shape[0]):                                               <L 57>
    var_5 = &(var_rotation_order.shape);
    var_8 = wp::load(var_5);
    var_7 = wp::extract(var_8, var_6);
    var_9 = wp::range(var_7);
    // return wp.normalize(quaternion)                                                        <L 60>
    var_17 = wp::normalize(var_4);
    goto label2;
    //---------
    // reverse
    label2:;
    adj_17 += adj_ret;
    wp::adj_normalize(var_4, adj_4, adj_17);
    // adj: return wp.normalize(quaternion)                                                   <L 60>
    var_9 = wp::iter_reverse(var_9);
    start_for_0:;
        if (iter_cmp(var_9) == 0) goto end_for_0;
        var_10 = wp::iter_next(var_9);
    	adj_11 = {};
    	adj_12 = {};
    	adj_13 = {};
    	adj_14 = {};
    	adj_15 = {};
    	adj_16 = {};
        // quaternion *= wp_get_quaternion_from_axis(rotation_order[i], euler_angles[i])       <L 58>
        var_11 = wp::address(var_rotation_order, var_10);
        var_12 = wp::address(var_euler_angles, var_10);
        var_14 = wp::load(var_11);
        var_15 = wp::load(var_12);
        var_13 = wp_get_quaternion_from_axis_0(var_14, var_15);
        var_16 = wp::mul(var_4, var_13);
        wp::assign(var_4, var_16);
        wp::adj_assign(var_4, var_16, adj_4, adj_16);
        wp::adj_mul(var_4, var_13, adj_4, adj_13, adj_16);
        adj_wp_get_quaternion_from_axis_0(var_14, var_15, adj_11, adj_12, adj_13);
        wp::adj_address(var_euler_angles, var_10, adj_euler_angles, adj_10, adj_12);
        wp::adj_address(var_rotation_order, var_10, adj_rotation_order, adj_10, adj_11);
        // adj: quaternion *= wp_get_quaternion_from_axis(rotation_order[i], euler_angles[i])  <L 58>
    	goto start_for_0;
    end_for_0:;
    adj_rotation_order.shape = adj_5;
    // adj: for i in range(rotation_order.shape[0]):                                          <L 57>
    wp::adj_quat_t(var_0, var_1, var_2, var_3, adj_0, adj_1, adj_2, adj_3, adj_4);
    // adj: quaternion = wp.quat(0.0, 0.0, 0.0, 1.0)                                          <L 56>
    // adj: def wp_euler_to_quaternion(                                                       <L 50>
    return;
}



extern "C" __global__ void wp_convert_frame_animation_ae2c47d0_cuda_kernel_forward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::transform_t<wp::float32>> var_reference_local_transforms,
    wp::array_t<bool> var_positions_exists,
    wp::array_t<bool> var_rotations_exists,
    wp::array_t<wp::float32> var_animation_data_positions,
    wp::array_t<wp::float32> var_animation_data_rotations,
    wp::array_t<wp::int32> var_joint_indices,
    wp::array_t<wp::int32> var_rotate_order,
    wp::array_t<wp::transform_t<wp::float32>> var_frame_data)
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
        bool* var_2;
        bool var_3;
        const wp::int32 var_4 = 0;
        wp::float32* var_5;
        const wp::int32 var_6 = 1;
        wp::float32* var_7;
        const wp::int32 var_8 = 2;
        wp::float32* var_9;
        wp::vec_t<3, wp::float32> var_10;
        wp::float32 var_11;
        wp::float32 var_12;
        wp::float32 var_13;
        const wp::float32 var_14 = 0.01;
        wp::vec_t<3, wp::float32> var_15;
        bool var_16;
        bool var_17;
        wp::int32* var_18;
        wp::transform_t<wp::float32>* var_19;
        wp::int32 var_20;
        wp::vec_t<3, wp::float32> var_21;
        wp::transform_t<wp::float32> var_22;
        bool var_23;
        wp::vec_t<3, wp::float32> var_24;
        bool var_25;
        bool* var_26;
        bool var_27;
        wp::slice_t var_28;
        const wp::int32 var_29 = 0;
        wp::slice_t var_30;
        const wp::int32 var_31 = 0;
        wp::array_t<wp::float32> var_32;
        wp::slice_t var_33;
        const wp::int32 var_34 = 0;
        wp::array_t<wp::int32> var_35;
        wp::quat_t<wp::float32> var_36;
        bool var_37;
        bool var_38;
        wp::int32* var_39;
        wp::transform_t<wp::float32>* var_40;
        wp::int32 var_41;
        wp::quat_t<wp::float32> var_42;
        wp::transform_t<wp::float32> var_43;
        bool var_44;
        wp::quat_t<wp::float32> var_45;
        bool var_46;
        wp::transform_t<wp::float32> var_47;
        //---------
        // forward
        // def wp_convert_frame_animation(                                                        <L 64>
        // frame, joint_index = wp.tid()                                                          <L 76>
        builtin_tid2d(var_0, var_1);
        // if positions_exists[frame, joint_index]:                                               <L 78>
        var_2 = wp::address(var_positions_exists, var_0, var_1);
        var_3 = wp::load(var_2);
        if (var_3) {
            // positions = wp.vec3(animation_data_positions[frame, joint_index, 0], animation_data_positions[frame, joint_index, 1], animation_data_positions[frame, joint_index, 2]) * 0.01       <L 79>
            var_5 = wp::address(var_animation_data_positions, var_0, var_1, var_4);
            var_7 = wp::address(var_animation_data_positions, var_0, var_1, var_6);
            var_9 = wp::address(var_animation_data_positions, var_0, var_1, var_8);
            var_11 = wp::load(var_5);
            var_12 = wp::load(var_7);
            var_13 = wp::load(var_9);
            var_10 = wp::vec_t<3, wp::float32>(var_11, var_12, var_13);
            var_15 = wp::mul(var_10, var_14);
        }
        var_16 = wp::load(var_2);
        var_17 = wp::load(var_2);
        if (!var_17) {
            // positions = reference_local_transforms[joint_indices[joint_index]].p               <L 81>
            var_18 = wp::address(var_joint_indices, var_1);
            var_20 = wp::load(var_18);
            var_19 = wp::address(var_reference_local_transforms, var_20);
            var_22 = wp::load(var_19);
            var_21 = wp::transform_get_translation(var_22);
        }
        var_23 = wp::load(var_2);
        var_25 = wp::load(var_2);
        var_24 = wp::where(var_25, var_15, var_21);
        // if rotations_exists[frame, joint_index]:                                               <L 83>
        var_26 = wp::address(var_rotations_exists, var_0, var_1);
        var_27 = wp::load(var_26);
        if (var_27) {
            // rotation = wp_euler_to_quaternion(animation_data_rotations[frame, joint_index], rotate_order[joint_index])       <L 84>
            var_28 = wp::slice_t(var_0, var_0, var_29);
            var_30 = wp::slice_t(var_1, var_1, var_31);
            var_32 = wp::view(var_animation_data_rotations, var_28, var_30);
            var_33 = wp::slice_t(var_1, var_1, var_34);
            var_35 = wp::view(var_rotate_order, var_33);
            var_36 = wp_euler_to_quaternion_0(var_32, var_35);
        }
        var_37 = wp::load(var_26);
        var_38 = wp::load(var_26);
        if (!var_38) {
            // rotation = reference_local_transforms[joint_indices[joint_index]].q                <L 86>
            var_39 = wp::address(var_joint_indices, var_1);
            var_41 = wp::load(var_39);
            var_40 = wp::address(var_reference_local_transforms, var_41);
            var_43 = wp::load(var_40);
            var_42 = wp::transform_get_rotation(var_43);
        }
        var_44 = wp::load(var_26);
        var_46 = wp::load(var_26);
        var_45 = wp::where(var_46, var_36, var_42);
        // frame_data[frame, joint_index] = wp.transform(positions, rotation)                     <L 88>
        var_47 = wp::transform_t<wp::float32>(var_24, var_45);
        wp::array_store(var_frame_data, var_0, var_1, var_47);
    }
}



extern "C" __global__ void wp_convert_frame_animation_ae2c47d0_cuda_kernel_backward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::transform_t<wp::float32>> var_reference_local_transforms,
    wp::array_t<bool> var_positions_exists,
    wp::array_t<bool> var_rotations_exists,
    wp::array_t<wp::float32> var_animation_data_positions,
    wp::array_t<wp::float32> var_animation_data_rotations,
    wp::array_t<wp::int32> var_joint_indices,
    wp::array_t<wp::int32> var_rotate_order,
    wp::array_t<wp::transform_t<wp::float32>> var_frame_data,
    wp::array_t<wp::transform_t<wp::float32>> adj_reference_local_transforms,
    wp::array_t<bool> adj_positions_exists,
    wp::array_t<bool> adj_rotations_exists,
    wp::array_t<wp::float32> adj_animation_data_positions,
    wp::array_t<wp::float32> adj_animation_data_rotations,
    wp::array_t<wp::int32> adj_joint_indices,
    wp::array_t<wp::int32> adj_rotate_order,
    wp::array_t<wp::transform_t<wp::float32>> adj_frame_data)
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
        bool* var_2;
        bool var_3;
        const wp::int32 var_4 = 0;
        wp::float32* var_5;
        const wp::int32 var_6 = 1;
        wp::float32* var_7;
        const wp::int32 var_8 = 2;
        wp::float32* var_9;
        wp::vec_t<3, wp::float32> var_10;
        wp::float32 var_11;
        wp::float32 var_12;
        wp::float32 var_13;
        const wp::float32 var_14 = 0.01;
        wp::vec_t<3, wp::float32> var_15;
        bool var_16;
        bool var_17;
        wp::int32* var_18;
        wp::transform_t<wp::float32>* var_19;
        wp::int32 var_20;
        wp::vec_t<3, wp::float32> var_21;
        wp::transform_t<wp::float32> var_22;
        bool var_23;
        wp::vec_t<3, wp::float32> var_24;
        bool var_25;
        bool* var_26;
        bool var_27;
        wp::slice_t var_28;
        const wp::int32 var_29 = 0;
        wp::slice_t var_30;
        const wp::int32 var_31 = 0;
        wp::array_t<wp::float32> var_32;
        wp::slice_t var_33;
        const wp::int32 var_34 = 0;
        wp::array_t<wp::int32> var_35;
        wp::quat_t<wp::float32> var_36;
        bool var_37;
        bool var_38;
        wp::int32* var_39;
        wp::transform_t<wp::float32>* var_40;
        wp::int32 var_41;
        wp::quat_t<wp::float32> var_42;
        wp::transform_t<wp::float32> var_43;
        bool var_44;
        wp::quat_t<wp::float32> var_45;
        bool var_46;
        wp::transform_t<wp::float32> var_47;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        bool adj_2 = {};
        bool adj_3 = {};
        wp::int32 adj_4 = {};
        wp::float32 adj_5 = {};
        wp::int32 adj_6 = {};
        wp::float32 adj_7 = {};
        wp::int32 adj_8 = {};
        wp::float32 adj_9 = {};
        wp::vec_t<3, wp::float32> adj_10 = {};
        wp::float32 adj_11 = {};
        wp::float32 adj_12 = {};
        wp::float32 adj_13 = {};
        wp::float32 adj_14 = {};
        wp::vec_t<3, wp::float32> adj_15 = {};
        bool adj_16 = {};
        bool adj_17 = {};
        wp::int32 adj_18 = {};
        wp::transform_t<wp::float32> adj_19 = {};
        wp::int32 adj_20 = {};
        wp::vec_t<3, wp::float32> adj_21 = {};
        wp::transform_t<wp::float32> adj_22 = {};
        bool adj_23 = {};
        wp::vec_t<3, wp::float32> adj_24 = {};
        bool adj_25 = {};
        bool adj_26 = {};
        bool adj_27 = {};
        wp::slice_t adj_28 = {};
        wp::int32 adj_29 = {};
        wp::slice_t adj_30 = {};
        wp::int32 adj_31 = {};
        wp::array_t<wp::float32> adj_32 = {};
        wp::slice_t adj_33 = {};
        wp::int32 adj_34 = {};
        wp::array_t<wp::int32> adj_35 = {};
        wp::quat_t<wp::float32> adj_36 = {};
        bool adj_37 = {};
        bool adj_38 = {};
        wp::int32 adj_39 = {};
        wp::transform_t<wp::float32> adj_40 = {};
        wp::int32 adj_41 = {};
        wp::quat_t<wp::float32> adj_42 = {};
        wp::transform_t<wp::float32> adj_43 = {};
        bool adj_44 = {};
        wp::quat_t<wp::float32> adj_45 = {};
        bool adj_46 = {};
        wp::transform_t<wp::float32> adj_47 = {};
        //---------
        // forward
        // def wp_convert_frame_animation(                                                        <L 64>
        // frame, joint_index = wp.tid()                                                          <L 76>
        builtin_tid2d(var_0, var_1);
        // if positions_exists[frame, joint_index]:                                               <L 78>
        var_2 = wp::address(var_positions_exists, var_0, var_1);
        var_3 = wp::load(var_2);
        if (var_3) {
            // positions = wp.vec3(animation_data_positions[frame, joint_index, 0], animation_data_positions[frame, joint_index, 1], animation_data_positions[frame, joint_index, 2]) * 0.01       <L 79>
            var_5 = wp::address(var_animation_data_positions, var_0, var_1, var_4);
            var_7 = wp::address(var_animation_data_positions, var_0, var_1, var_6);
            var_9 = wp::address(var_animation_data_positions, var_0, var_1, var_8);
            var_11 = wp::load(var_5);
            var_12 = wp::load(var_7);
            var_13 = wp::load(var_9);
            var_10 = wp::vec_t<3, wp::float32>(var_11, var_12, var_13);
            var_15 = wp::mul(var_10, var_14);
        }
        var_16 = wp::load(var_2);
        var_17 = wp::load(var_2);
        if (!var_17) {
            // positions = reference_local_transforms[joint_indices[joint_index]].p               <L 81>
            var_18 = wp::address(var_joint_indices, var_1);
            var_20 = wp::load(var_18);
            var_19 = wp::address(var_reference_local_transforms, var_20);
            var_22 = wp::load(var_19);
            var_21 = wp::transform_get_translation(var_22);
        }
        var_23 = wp::load(var_2);
        var_25 = wp::load(var_2);
        var_24 = wp::where(var_25, var_15, var_21);
        // if rotations_exists[frame, joint_index]:                                               <L 83>
        var_26 = wp::address(var_rotations_exists, var_0, var_1);
        var_27 = wp::load(var_26);
        if (var_27) {
            // rotation = wp_euler_to_quaternion(animation_data_rotations[frame, joint_index], rotate_order[joint_index])       <L 84>
            var_28 = wp::slice_t(var_0, var_0, var_29);
            var_30 = wp::slice_t(var_1, var_1, var_31);
            var_32 = wp::view(var_animation_data_rotations, var_28, var_30);
            var_33 = wp::slice_t(var_1, var_1, var_34);
            var_35 = wp::view(var_rotate_order, var_33);
            var_36 = wp_euler_to_quaternion_0(var_32, var_35);
        }
        var_37 = wp::load(var_26);
        var_38 = wp::load(var_26);
        if (!var_38) {
            // rotation = reference_local_transforms[joint_indices[joint_index]].q                <L 86>
            var_39 = wp::address(var_joint_indices, var_1);
            var_41 = wp::load(var_39);
            var_40 = wp::address(var_reference_local_transforms, var_41);
            var_43 = wp::load(var_40);
            var_42 = wp::transform_get_rotation(var_43);
        }
        var_44 = wp::load(var_26);
        var_46 = wp::load(var_26);
        var_45 = wp::where(var_46, var_36, var_42);
        // frame_data[frame, joint_index] = wp.transform(positions, rotation)                     <L 88>
        var_47 = wp::transform_t<wp::float32>(var_24, var_45);
        // wp::array_store(var_frame_data, var_0, var_1, var_47);
        //---------
        // reverse
        wp::adj_array_store(var_frame_data, var_0, var_1, var_47, adj_frame_data, adj_0, adj_1, adj_47);
        wp::adj_transform_t(var_24, var_45, adj_24, adj_45, adj_47);
        // adj: frame_data[frame, joint_index] = wp.transform(positions, rotation)                <L 88>
        wp::adj_where(var_46, var_36, var_42, adj_26, adj_36, adj_42, adj_45);
        if (!var_44) {
            wp::adj_transform_get_rotation(var_43, adj_40, adj_42);
            wp::adj_address(var_reference_local_transforms, var_41, adj_reference_local_transforms, adj_39, adj_40);
            wp::adj_address(var_joint_indices, var_1, adj_joint_indices, adj_1, adj_39);
            // adj: rotation = reference_local_transforms[joint_indices[joint_index]].q           <L 86>
        }
        if (var_37) {
            adj_wp_euler_to_quaternion_0(var_32, var_35, adj_32, adj_35, adj_36);
            wp::adj_view(var_rotate_order, var_33, adj_rotate_order, adj_33, adj_35);
            wp::adj_view(var_animation_data_rotations, var_28, var_30, adj_animation_data_rotations, adj_28, adj_30, adj_32);
            // adj: rotation = wp_euler_to_quaternion(animation_data_rotations[frame, joint_index], rotate_order[joint_index])  <L 84>
        }
        wp::adj_address(var_rotations_exists, var_0, var_1, adj_rotations_exists, adj_0, adj_1, adj_26);
        // adj: if rotations_exists[frame, joint_index]:                                          <L 83>
        wp::adj_where(var_25, var_15, var_21, adj_2, adj_15, adj_21, adj_24);
        if (!var_23) {
            wp::adj_transform_get_translation(var_22, adj_19, adj_21);
            wp::adj_address(var_reference_local_transforms, var_20, adj_reference_local_transforms, adj_18, adj_19);
            wp::adj_address(var_joint_indices, var_1, adj_joint_indices, adj_1, adj_18);
            // adj: positions = reference_local_transforms[joint_indices[joint_index]].p          <L 81>
        }
        if (var_16) {
            wp::adj_mul(var_10, var_14, adj_10, adj_14, adj_15);
            wp::adj_vec_t(var_11, var_12, var_13, adj_5, adj_7, adj_9, adj_10);
            wp::adj_address(var_animation_data_positions, var_0, var_1, var_8, adj_animation_data_positions, adj_0, adj_1, adj_8, adj_9);
            wp::adj_address(var_animation_data_positions, var_0, var_1, var_6, adj_animation_data_positions, adj_0, adj_1, adj_6, adj_7);
            wp::adj_address(var_animation_data_positions, var_0, var_1, var_4, adj_animation_data_positions, adj_0, adj_1, adj_4, adj_5);
            // adj: positions = wp.vec3(animation_data_positions[frame, joint_index, 0], animation_data_positions[frame, joint_index, 1], animation_data_positions[frame, joint_index, 2]) * 0.01  <L 79>
        }
        wp::adj_address(var_positions_exists, var_0, var_1, adj_positions_exists, adj_0, adj_1, adj_2);
        // adj: if positions_exists[frame, joint_index]:                                          <L 78>
        // adj: frame, joint_index = wp.tid()                                                     <L 76>
        // adj: def wp_convert_frame_animation(                                                   <L 64>
        continue;
    }
}

