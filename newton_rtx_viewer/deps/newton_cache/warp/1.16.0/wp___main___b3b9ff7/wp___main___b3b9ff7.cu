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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/warp/_src/utils.py:36
static CUDA_CALLABLE wp::quat_t<wp::float32> quat_between_vectors_0(
    wp::vec_t<3, wp::float32> var_a,
    wp::vec_t<3, wp::float32> var_b)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::float32 var_3;
    const wp::int32 var_4 = 0;
    wp::float32 var_5;
    const wp::int32 var_6 = 1;
    wp::float32 var_7;
    const wp::int32 var_8 = 2;
    wp::float32 var_9;
    const wp::float32 var_10 = 1.0;
    wp::float32 var_11;
    wp::quat_t<wp::float32> var_12;
    wp::quat_t<wp::float32> var_13;
    //---------
    // forward
    // def quat_between_vectors(a: wp.vec3, b: wp.vec3) -> wp.quat:                           <L 37>
    // a = wp.normalize(a)                                                                    <L 39>
    var_0 = wp::normalize(var_a);
    // b = wp.normalize(b)                                                                    <L 40>
    var_1 = wp::normalize(var_b);
    // c = wp.cross(a, b)                                                                     <L 41>
    var_2 = wp::cross(var_0, var_1);
    // d = wp.dot(a, b)                                                                       <L 42>
    var_3 = wp::dot(var_0, var_1);
    // q = wp.quat(c[0], c[1], c[2], 1.0 + d)                                                 <L 43>
    var_5 = wp::extract(var_2, var_4);
    var_7 = wp::extract(var_2, var_6);
    var_9 = wp::extract(var_2, var_8);
    var_11 = wp::add(var_10, var_3);
    var_12 = wp::quat_t<wp::float32>(var_5, var_7, var_9, var_11);
    // return wp.normalize(q)                                                                 <L 44>
    var_13 = wp::normalize(var_12);
    return var_13;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/math/spatial.py:9
static CUDA_CALLABLE wp::quat_t<wp::float32> quat_between_vectors_robust_0(
    wp::vec_t<3, wp::float32> var_from_vec,
    wp::vec_t<3, wp::float32> var_to_vec,
    wp::float32 var_eps)
{
    //---------
    // primal vars
    wp::float32 var_0;
    const wp::float32 var_1 = 1.0;
    wp::float32 var_2;
    bool var_3;
    wp::quat_t<wp::float32> var_4;
    const wp::float32 var_5 = -1.0;
    wp::float32 var_6;
    bool var_7;
    const wp::float32 var_8 = 1.0;
    const wp::float32 var_9 = 0.0;
    const wp::float32 var_10 = 0.0;
    wp::vec_t<3, wp::float32> var_11;
    const wp::int32 var_12 = 0;
    wp::float32 var_13;
    wp::float32 var_14;
    const wp::float32 var_15 = 0.9;
    bool var_16;
    const wp::float32 var_17 = 0.0;
    const wp::float32 var_18 = 1.0;
    const wp::float32 var_19 = 0.0;
    wp::vec_t<3, wp::float32> var_20;
    wp::vec_t<3, wp::float32> var_21;
    wp::vec_t<3, wp::float32> var_22;
    wp::float32 var_23;
    bool var_24;
    const wp::float32 var_25 = 0.0;
    const wp::float32 var_26 = 0.0;
    const wp::float32 var_27 = 1.0;
    wp::vec_t<3, wp::float32> var_28;
    wp::vec_t<3, wp::float32> var_29;
    wp::float32 var_30;
    wp::vec_t<3, wp::float32> var_31;
    wp::float32 var_32;
    bool var_33;
    const wp::float32 var_34 = 1.0;
    const wp::float32 var_35 = 0.0;
    const wp::float32 var_36 = 0.0;
    wp::vec_t<3, wp::float32> var_37;
    const wp::float32 var_38 = 3.141592653589793;
    const wp::float32 var_39 = 3.141592653589793;
    wp::quat_t<wp::float32> var_40;
    wp::vec_t<3, wp::float32> var_41;
    const wp::float32 var_42 = 3.141592653589793;
    const wp::float32 var_43 = 3.141592653589793;
    wp::quat_t<wp::float32> var_44;
    wp::quat_t<wp::float32> var_45;
    //---------
    // forward
    // def quat_between_vectors_robust(from_vec: wp.vec3, to_vec: wp.vec3, eps: float = 1.0e-8) -> wp.quat:       <L 10>
    // d = wp.dot(from_vec, to_vec)                                                           <L 25>
    var_0 = wp::dot(var_from_vec, var_to_vec);
    // if d >= 1.0 - eps:                                                                     <L 27>
    var_2 = wp::sub(var_1, var_eps);
    var_3 = (var_0 >= var_2);
    if (var_3) {
        // return wp.quat_identity()                                                          <L 28>
        var_4 = wp::quat_identity<wp::float32>();
        return var_4;
    }
    // if d <= -1.0 + eps:                                                                    <L 30>
    var_6 = wp::add(var_5, var_eps);
    var_7 = (var_0 <= var_6);
    if (var_7) {
        // helper = wp.vec3(1.0, 0.0, 0.0)                                                    <L 33>
        var_11 = wp::vec_t<3, wp::float32>(var_8, var_9, var_10);
        // if wp.abs(from_vec[0]) >= 0.9:                                                     <L 34>
        var_13 = wp::extract(var_from_vec, var_12);
        var_14 = wp::abs(var_13);
        var_16 = (var_14 >= var_15);
        if (var_16) {
            // helper = wp.vec3(0.0, 1.0, 0.0)                                                <L 35>
            var_20 = wp::vec_t<3, wp::float32>(var_17, var_18, var_19);
        }
        var_21 = wp::where(var_16, var_20, var_11);
        // axis = wp.cross(from_vec, helper)                                                  <L 37>
        var_22 = wp::cross(var_from_vec, var_21);
        // axis_len = wp.length(axis)                                                         <L 38>
        var_23 = wp::length(var_22);
        // if axis_len <= eps:                                                                <L 39>
        var_24 = (var_23 <= var_eps);
        if (var_24) {
            // axis = wp.cross(from_vec, wp.vec3(0.0, 0.0, 1.0))                              <L 40>
            var_28 = wp::vec_t<3, wp::float32>(var_25, var_26, var_27);
            var_29 = wp::cross(var_from_vec, var_28);
            // axis_len = wp.length(axis)                                                     <L 41>
            var_30 = wp::length(var_29);
        }
        var_31 = wp::where(var_24, var_29, var_22);
        var_32 = wp::where(var_24, var_30, var_23);
        // if axis_len <= eps:                                                                <L 44>
        var_33 = (var_32 <= var_eps);
        if (var_33) {
            // return wp.quat_from_axis_angle(wp.vec3(1.0, 0.0, 0.0), wp.pi)                  <L 45>
            var_37 = wp::vec_t<3, wp::float32>(var_34, var_35, var_36);
            var_40 = wp::quat_from_axis_angle(var_37, var_39);
            return var_40;
        }
        // axis = axis / axis_len                                                             <L 47>
        var_41 = wp::div(var_31, var_32);
        // return wp.quat_from_axis_angle(axis, wp.pi)                                        <L 48>
        var_44 = wp::quat_from_axis_angle(var_41, var_43);
        return var_44;
    }
    // return wp.quat_between_vectors(from_vec, to_vec)                                       <L 50>
    var_45 = quat_between_vectors_0(var_from_vec, var_to_vec);
    return var_45;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/warp/_src/utils.py:36
static CUDA_CALLABLE void adj_quat_between_vectors_0(
    wp::vec_t<3, wp::float32> var_a,
    wp::vec_t<3, wp::float32> var_b,
    wp::vec_t<3, wp::float32> & adj_a,
    wp::vec_t<3, wp::float32> & adj_b,
    wp::quat_t<wp::float32> & adj_ret)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::float32 var_3;
    const wp::int32 var_4 = 0;
    wp::float32 var_5;
    const wp::int32 var_6 = 1;
    wp::float32 var_7;
    const wp::int32 var_8 = 2;
    wp::float32 var_9;
    const wp::float32 var_10 = 1.0;
    wp::float32 var_11;
    wp::quat_t<wp::float32> var_12;
    wp::quat_t<wp::float32> var_13;
    //---------
    // dual vars
    wp::vec_t<3, wp::float32> adj_0 = {};
    wp::vec_t<3, wp::float32> adj_1 = {};
    wp::vec_t<3, wp::float32> adj_2 = {};
    wp::float32 adj_3 = {};
    wp::int32 adj_4 = {};
    wp::float32 adj_5 = {};
    wp::int32 adj_6 = {};
    wp::float32 adj_7 = {};
    wp::int32 adj_8 = {};
    wp::float32 adj_9 = {};
    wp::float32 adj_10 = {};
    wp::float32 adj_11 = {};
    wp::quat_t<wp::float32> adj_12 = {};
    wp::quat_t<wp::float32> adj_13 = {};
    //---------
    // forward
    // def quat_between_vectors(a: wp.vec3, b: wp.vec3) -> wp.quat:                           <L 37>
    // a = wp.normalize(a)                                                                    <L 39>
    var_0 = wp::normalize(var_a);
    // b = wp.normalize(b)                                                                    <L 40>
    var_1 = wp::normalize(var_b);
    // c = wp.cross(a, b)                                                                     <L 41>
    var_2 = wp::cross(var_0, var_1);
    // d = wp.dot(a, b)                                                                       <L 42>
    var_3 = wp::dot(var_0, var_1);
    // q = wp.quat(c[0], c[1], c[2], 1.0 + d)                                                 <L 43>
    var_5 = wp::extract(var_2, var_4);
    var_7 = wp::extract(var_2, var_6);
    var_9 = wp::extract(var_2, var_8);
    var_11 = wp::add(var_10, var_3);
    var_12 = wp::quat_t<wp::float32>(var_5, var_7, var_9, var_11);
    // return wp.normalize(q)                                                                 <L 44>
    var_13 = wp::normalize(var_12);
    goto label0;
    //---------
    // reverse
    label0:;
    adj_13 += adj_ret;
    wp::adj_normalize(var_12, adj_12, adj_13);
    // adj: return wp.normalize(q)                                                            <L 44>
    wp::adj_quat_t(var_5, var_7, var_9, var_11, adj_5, adj_7, adj_9, adj_11, adj_12);
    wp::adj_add(var_10, var_3, adj_10, adj_3, adj_11);
    wp::adj_extract(var_2, var_8, adj_2, adj_8, adj_9);
    wp::adj_extract(var_2, var_6, adj_2, adj_6, adj_7);
    wp::adj_extract(var_2, var_4, adj_2, adj_4, adj_5);
    // adj: q = wp.quat(c[0], c[1], c[2], 1.0 + d)                                            <L 43>
    wp::adj_dot(var_0, var_1, adj_0, adj_1, adj_3);
    // adj: d = wp.dot(a, b)                                                                  <L 42>
    wp::adj_cross(var_0, var_1, adj_0, adj_1, adj_2);
    // adj: c = wp.cross(a, b)                                                                <L 41>
    wp::adj_normalize(var_b, var_1, adj_b, adj_1);
    // adj: b = wp.normalize(b)                                                               <L 40>
    wp::adj_normalize(var_a, var_0, adj_a, adj_0);
    // adj: a = wp.normalize(a)                                                               <L 39>
    // adj: def quat_between_vectors(a: wp.vec3, b: wp.vec3) -> wp.quat:                      <L 37>
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/math/spatial.py:9
static CUDA_CALLABLE void adj_quat_between_vectors_robust_0(
    wp::vec_t<3, wp::float32> var_from_vec,
    wp::vec_t<3, wp::float32> var_to_vec,
    wp::float32 var_eps,
    wp::vec_t<3, wp::float32> & adj_from_vec,
    wp::vec_t<3, wp::float32> & adj_to_vec,
    wp::float32 & adj_eps,
    wp::quat_t<wp::float32> & adj_ret)
{
    //---------
    // primal vars
    wp::float32 var_0;
    const wp::float32 var_1 = 1.0;
    wp::float32 var_2;
    bool var_3;
    wp::quat_t<wp::float32> var_4;
    const wp::float32 var_5 = -1.0;
    wp::float32 var_6;
    bool var_7;
    const wp::float32 var_8 = 1.0;
    const wp::float32 var_9 = 0.0;
    const wp::float32 var_10 = 0.0;
    wp::vec_t<3, wp::float32> var_11;
    const wp::int32 var_12 = 0;
    wp::float32 var_13;
    wp::float32 var_14;
    const wp::float32 var_15 = 0.9;
    bool var_16;
    const wp::float32 var_17 = 0.0;
    const wp::float32 var_18 = 1.0;
    const wp::float32 var_19 = 0.0;
    wp::vec_t<3, wp::float32> var_20;
    wp::vec_t<3, wp::float32> var_21;
    wp::vec_t<3, wp::float32> var_22;
    wp::float32 var_23;
    bool var_24;
    const wp::float32 var_25 = 0.0;
    const wp::float32 var_26 = 0.0;
    const wp::float32 var_27 = 1.0;
    wp::vec_t<3, wp::float32> var_28;
    wp::vec_t<3, wp::float32> var_29;
    wp::float32 var_30;
    wp::vec_t<3, wp::float32> var_31;
    wp::float32 var_32;
    bool var_33;
    const wp::float32 var_34 = 1.0;
    const wp::float32 var_35 = 0.0;
    const wp::float32 var_36 = 0.0;
    wp::vec_t<3, wp::float32> var_37;
    const wp::float32 var_38 = 3.141592653589793;
    const wp::float32 var_39 = 3.141592653589793;
    wp::quat_t<wp::float32> var_40;
    wp::vec_t<3, wp::float32> var_41;
    const wp::float32 var_42 = 3.141592653589793;
    const wp::float32 var_43 = 3.141592653589793;
    wp::quat_t<wp::float32> var_44;
    wp::quat_t<wp::float32> var_45;
    //---------
    // dual vars
    wp::float32 adj_0 = {};
    wp::float32 adj_1 = {};
    wp::float32 adj_2 = {};
    bool adj_3 = {};
    wp::quat_t<wp::float32> adj_4 = {};
    wp::float32 adj_5 = {};
    wp::float32 adj_6 = {};
    bool adj_7 = {};
    wp::float32 adj_8 = {};
    wp::float32 adj_9 = {};
    wp::float32 adj_10 = {};
    wp::vec_t<3, wp::float32> adj_11 = {};
    wp::int32 adj_12 = {};
    wp::float32 adj_13 = {};
    wp::float32 adj_14 = {};
    wp::float32 adj_15 = {};
    bool adj_16 = {};
    wp::float32 adj_17 = {};
    wp::float32 adj_18 = {};
    wp::float32 adj_19 = {};
    wp::vec_t<3, wp::float32> adj_20 = {};
    wp::vec_t<3, wp::float32> adj_21 = {};
    wp::vec_t<3, wp::float32> adj_22 = {};
    wp::float32 adj_23 = {};
    bool adj_24 = {};
    wp::float32 adj_25 = {};
    wp::float32 adj_26 = {};
    wp::float32 adj_27 = {};
    wp::vec_t<3, wp::float32> adj_28 = {};
    wp::vec_t<3, wp::float32> adj_29 = {};
    wp::float32 adj_30 = {};
    wp::vec_t<3, wp::float32> adj_31 = {};
    wp::float32 adj_32 = {};
    bool adj_33 = {};
    wp::float32 adj_34 = {};
    wp::float32 adj_35 = {};
    wp::float32 adj_36 = {};
    wp::vec_t<3, wp::float32> adj_37 = {};
    wp::float32 adj_38 = {};
    wp::float32 adj_39 = {};
    wp::quat_t<wp::float32> adj_40 = {};
    wp::vec_t<3, wp::float32> adj_41 = {};
    wp::float32 adj_42 = {};
    wp::float32 adj_43 = {};
    wp::quat_t<wp::float32> adj_44 = {};
    wp::quat_t<wp::float32> adj_45 = {};
    //---------
    // forward
    // def quat_between_vectors_robust(from_vec: wp.vec3, to_vec: wp.vec3, eps: float = 1.0e-8) -> wp.quat:       <L 10>
    // d = wp.dot(from_vec, to_vec)                                                           <L 25>
    var_0 = wp::dot(var_from_vec, var_to_vec);
    // if d >= 1.0 - eps:                                                                     <L 27>
    var_2 = wp::sub(var_1, var_eps);
    var_3 = (var_0 >= var_2);
    if (var_3) {
        // return wp.quat_identity()                                                          <L 28>
        var_4 = wp::quat_identity<wp::float32>();
        goto label0;
    }
    // if d <= -1.0 + eps:                                                                    <L 30>
    var_6 = wp::add(var_5, var_eps);
    var_7 = (var_0 <= var_6);
    if (var_7) {
        // helper = wp.vec3(1.0, 0.0, 0.0)                                                    <L 33>
        var_11 = wp::vec_t<3, wp::float32>(var_8, var_9, var_10);
        // if wp.abs(from_vec[0]) >= 0.9:                                                     <L 34>
        var_13 = wp::extract(var_from_vec, var_12);
        var_14 = wp::abs(var_13);
        var_16 = (var_14 >= var_15);
        if (var_16) {
            // helper = wp.vec3(0.0, 1.0, 0.0)                                                <L 35>
            var_20 = wp::vec_t<3, wp::float32>(var_17, var_18, var_19);
        }
        var_21 = wp::where(var_16, var_20, var_11);
        // axis = wp.cross(from_vec, helper)                                                  <L 37>
        var_22 = wp::cross(var_from_vec, var_21);
        // axis_len = wp.length(axis)                                                         <L 38>
        var_23 = wp::length(var_22);
        // if axis_len <= eps:                                                                <L 39>
        var_24 = (var_23 <= var_eps);
        if (var_24) {
            // axis = wp.cross(from_vec, wp.vec3(0.0, 0.0, 1.0))                              <L 40>
            var_28 = wp::vec_t<3, wp::float32>(var_25, var_26, var_27);
            var_29 = wp::cross(var_from_vec, var_28);
            // axis_len = wp.length(axis)                                                     <L 41>
            var_30 = wp::length(var_29);
        }
        var_31 = wp::where(var_24, var_29, var_22);
        var_32 = wp::where(var_24, var_30, var_23);
        // if axis_len <= eps:                                                                <L 44>
        var_33 = (var_32 <= var_eps);
        if (var_33) {
            // return wp.quat_from_axis_angle(wp.vec3(1.0, 0.0, 0.0), wp.pi)                  <L 45>
            var_37 = wp::vec_t<3, wp::float32>(var_34, var_35, var_36);
            var_40 = wp::quat_from_axis_angle(var_37, var_39);
            goto label1;
        }
        // axis = axis / axis_len                                                             <L 47>
        var_41 = wp::div(var_31, var_32);
        // return wp.quat_from_axis_angle(axis, wp.pi)                                        <L 48>
        var_44 = wp::quat_from_axis_angle(var_41, var_43);
        goto label2;
    }
    // return wp.quat_between_vectors(from_vec, to_vec)                                       <L 50>
    var_45 = quat_between_vectors_0(var_from_vec, var_to_vec);
    goto label3;
    //---------
    // reverse
    label3:;
    adj_45 += adj_ret;
    adj_quat_between_vectors_0(var_from_vec, var_to_vec, adj_from_vec, adj_to_vec, adj_45);
    // adj: return wp.quat_between_vectors(from_vec, to_vec)                                  <L 50>
    if (var_7) {
        label2:;
        adj_44 += adj_ret;
        wp::adj_quat_from_axis_angle(var_41, var_43, adj_41, adj_43, adj_44);
        // adj: return wp.quat_from_axis_angle(axis, wp.pi)                                   <L 48>
        wp::adj_div(var_31, var_32, adj_31, adj_32, adj_41);
        // adj: axis = axis / axis_len                                                        <L 47>
        if (var_33) {
            label1:;
            adj_40 += adj_ret;
            wp::adj_quat_from_axis_angle(var_37, var_39, adj_37, adj_39, adj_40);
            wp::adj_vec_t(var_34, var_35, var_36, adj_34, adj_35, adj_36, adj_37);
            // adj: return wp.quat_from_axis_angle(wp.vec3(1.0, 0.0, 0.0), wp.pi)             <L 45>
        }
        // adj: if axis_len <= eps:                                                           <L 44>
        wp::adj_where(var_24, var_30, var_23, adj_24, adj_30, adj_23, adj_32);
        wp::adj_where(var_24, var_29, var_22, adj_24, adj_29, adj_22, adj_31);
        if (var_24) {
            wp::adj_length(var_29, var_30, adj_29, adj_30);
            // adj: axis_len = wp.length(axis)                                                <L 41>
            wp::adj_cross(var_from_vec, var_28, adj_from_vec, adj_28, adj_29);
            wp::adj_vec_t(var_25, var_26, var_27, adj_25, adj_26, adj_27, adj_28);
            // adj: axis = wp.cross(from_vec, wp.vec3(0.0, 0.0, 1.0))                         <L 40>
        }
        // adj: if axis_len <= eps:                                                           <L 39>
        wp::adj_length(var_22, var_23, adj_22, adj_23);
        // adj: axis_len = wp.length(axis)                                                    <L 38>
        wp::adj_cross(var_from_vec, var_21, adj_from_vec, adj_21, adj_22);
        // adj: axis = wp.cross(from_vec, helper)                                             <L 37>
        wp::adj_where(var_16, var_20, var_11, adj_16, adj_20, adj_11, adj_21);
        if (var_16) {
            wp::adj_vec_t(var_17, var_18, var_19, adj_17, adj_18, adj_19, adj_20);
            // adj: helper = wp.vec3(0.0, 1.0, 0.0)                                           <L 35>
        }
        wp::adj_abs(var_13, adj_13, adj_14);
        wp::adj_extract(var_from_vec, var_12, adj_from_vec, adj_12, adj_13);
        // adj: if wp.abs(from_vec[0]) >= 0.9:                                                <L 34>
        wp::adj_vec_t(var_8, var_9, var_10, adj_8, adj_9, adj_10, adj_11);
        // adj: helper = wp.vec3(1.0, 0.0, 0.0)                                               <L 33>
    }
    wp::adj_add(var_5, var_eps, adj_5, adj_eps, adj_6);
    // adj: if d <= -1.0 + eps:                                                               <L 30>
    if (var_3) {
        label0:;
        adj_4 += adj_ret;
        // adj: return wp.quat_identity()                                                     <L 28>
    }
    wp::adj_sub(var_1, var_eps, adj_1, adj_eps, adj_2);
    // adj: if d >= 1.0 - eps:                                                                <L 27>
    wp::adj_dot(var_from_vec, var_to_vec, adj_from_vec, adj_to_vec, adj_0);
    // adj: d = wp.dot(from_vec, to_vec)                                                      <L 25>
    // adj: def quat_between_vectors_robust(from_vec: wp.vec3, to_vec: wp.vec3, eps: float = 1.0e-8) -> wp.quat:  <L 10>
    return;
}



extern "C" __global__ void _apply_gizmo_force_46ea1041_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::vec_t<6, wp::float32>> var_body_qd,
    wp::array_t<wp::vec_t<6, wp::float32>> var_body_f,
    wp::array_t<wp::float32> var_body_mass,
    wp::array_t<wp::vec_t<3, wp::float32>> var_pick_target,
    wp::float32 var_stiffness,
    wp::float32 var_damping,
    wp::array_t<wp::int32> var_pick_body,
    wp::int32 var_plug_idx,
    wp::int32 var_latch_idx,
    wp::vec_t<3, wp::float32> var_gravity)
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
        wp::vec_t<3, wp::float32> var_0;
        wp::float32* var_1;
        wp::vec_t<3, wp::float32> var_2;
        wp::float32 var_3;
        wp::vec_t<3, wp::float32> var_4;
        wp::float32* var_5;
        wp::vec_t<3, wp::float32> var_6;
        wp::float32 var_7;
        const wp::float32 var_8 = 0.0;
        wp::vec_t<3, wp::float32> var_9;
        wp::vec_t<6, wp::float32> var_10;
        wp::vec_t<6, wp::float32> var_11;
        const wp::float32 var_12 = 0.0;
        wp::vec_t<3, wp::float32> var_13;
        wp::vec_t<6, wp::float32> var_14;
        wp::vec_t<6, wp::float32> var_15;
        const wp::int32 var_16 = 0;
        wp::vec_t<3, wp::float32>* var_17;
        wp::vec_t<3, wp::float32> var_18;
        wp::vec_t<3, wp::float32> var_19;
        const wp::int32 var_20 = 0;
        wp::int32* var_21;
        wp::int32 var_22;
        wp::int32 var_23;
        const wp::int32 var_24 = 0;
        bool var_25;
        bool var_26;
        wp::vec_t<6, wp::float32>* var_27;
        wp::vec_t<3, wp::float32> var_28;
        wp::vec_t<6, wp::float32> var_29;
        wp::float32* var_30;
        wp::float32 var_31;
        wp::float32 var_32;
        const wp::float32 var_33 = 10.0;
        wp::float32 var_34;
        wp::float32 var_35;
        wp::float32 var_36;
        wp::vec_t<3, wp::float32> var_37;
        const wp::float32 var_38 = 0.0;
        wp::vec_t<3, wp::float32> var_39;
        wp::vec_t<6, wp::float32> var_40;
        wp::vec_t<6, wp::float32> var_41;
        bool var_42;
        wp::vec_t<6, wp::float32>* var_43;
        wp::vec_t<3, wp::float32> var_44;
        wp::vec_t<6, wp::float32> var_45;
        wp::float32* var_46;
        wp::float32 var_47;
        wp::float32 var_48;
        const wp::float32 var_49 = 10.0;
        wp::float32 var_50;
        wp::float32 var_51;
        wp::float32 var_52;
        wp::vec_t<3, wp::float32> var_53;
        const wp::float32 var_54 = 0.0;
        wp::vec_t<3, wp::float32> var_55;
        wp::vec_t<6, wp::float32> var_56;
        wp::vec_t<6, wp::float32> var_57;
        wp::transform_t<wp::float32>* var_58;
        wp::vec_t<3, wp::float32> var_59;
        wp::transform_t<wp::float32> var_60;
        wp::vec_t<6, wp::float32>* var_61;
        wp::vec_t<3, wp::float32> var_62;
        wp::vec_t<6, wp::float32> var_63;
        wp::float32* var_64;
        wp::float32 var_65;
        wp::float32 var_66;
        const wp::float32 var_67 = 10.0;
        wp::float32 var_68;
        wp::vec_t<3, wp::float32> var_69;
        wp::vec_t<3, wp::float32> var_70;
        wp::vec_t<3, wp::float32> var_71;
        wp::vec_t<3, wp::float32> var_72;
        wp::vec_t<3, wp::float32> var_73;
        const wp::float32 var_74 = 0.0;
        wp::vec_t<3, wp::float32> var_75;
        wp::vec_t<6, wp::float32> var_76;
        wp::vec_t<6, wp::float32> var_77;
        wp::vec_t<6, wp::float32>* var_78;
        wp::vec_t<3, wp::float32> var_79;
        wp::vec_t<6, wp::float32> var_80;
        wp::float32* var_81;
        wp::float32 var_82;
        wp::float32 var_83;
        wp::vec_t<3, wp::float32> var_84;
        wp::float32 var_85;
        wp::float32 var_86;
        wp::vec_t<3, wp::float32> var_87;
        wp::vec_t<3, wp::float32> var_88;
        const wp::float32 var_89 = 10.0;
        wp::float32 var_90;
        wp::float32 var_91;
        wp::vec_t<3, wp::float32> var_92;
        wp::vec_t<3, wp::float32> var_93;
        const wp::float32 var_94 = 0.0;
        wp::vec_t<3, wp::float32> var_95;
        wp::vec_t<6, wp::float32> var_96;
        wp::vec_t<6, wp::float32> var_97;
        //---------
        // forward
        // def _apply_gizmo_force(                                                                <L 62>
        // anti_g0 = -gravity * body_mass[plug_idx]                                               <L 84>
        var_0 = wp::neg(var_gravity);
        var_1 = wp::address(var_body_mass, var_plug_idx);
        var_3 = wp::load(var_1);
        var_2 = wp::mul(var_0, var_3);
        // anti_g1 = -gravity * body_mass[latch_idx]                                              <L 85>
        var_4 = wp::neg(var_gravity);
        var_5 = wp::address(var_body_mass, var_latch_idx);
        var_7 = wp::load(var_5);
        var_6 = wp::mul(var_4, var_7);
        // wp.atomic_add(body_f, plug_idx, wp.spatial_vector(anti_g0, wp.vec3(0.0)))              <L 86>
        var_9 = wp::vec_t<3, wp::float32>(var_8);
        var_10 = wp::vec_t<6, wp::float32>(var_2, var_9);
        var_11 = wp::atomic_add(var_body_f, var_plug_idx, var_10);
        // wp.atomic_add(body_f, latch_idx, wp.spatial_vector(anti_g1, wp.vec3(0.0)))             <L 87>
        var_13 = wp::vec_t<3, wp::float32>(var_12);
        var_14 = wp::vec_t<6, wp::float32>(var_6, var_13);
        var_15 = wp::atomic_add(var_body_f, var_latch_idx, var_14);
        // target = pick_target[0]                                                                <L 89>
        var_17 = wp::address(var_pick_target, var_16);
        var_19 = wp::load(var_17);
        var_18 = wp::copy(var_19);
        // picked_body = pick_body[0]                                                             <L 90>
        var_21 = wp::address(var_pick_body, var_20);
        var_23 = wp::load(var_21);
        var_22 = wp::copy(var_23);
        // if picked_body >= 0:                                                                   <L 92>
        var_25 = (var_22 >= var_24);
        if (var_25) {
            // if picked_body != plug_idx:                                                        <L 93>
            var_26 = (var_22 != var_plug_idx);
            if (var_26) {
                // vel0 = wp.spatial_top(body_qd[plug_idx])                                       <L 94>
                var_27 = wp::address(var_body_qd, var_plug_idx);
                var_29 = wp::load(var_27);
                var_28 = wp::spatial_top(var_29);
                // mass0 = body_mass[plug_idx]                                                    <L 95>
                var_30 = wp::address(var_body_mass, var_plug_idx);
                var_32 = wp::load(var_30);
                var_31 = wp::copy(var_32);
                // f0 = -(10.0 + mass0) * damping * vel0                                          <L 96>
                var_34 = wp::add(var_33, var_31);
                var_35 = wp::neg(var_34);
                var_36 = wp::mul(var_35, var_damping);
                var_37 = wp::mul(var_36, var_28);
                // wp.atomic_add(body_f, plug_idx, wp.spatial_vector(f0, wp.vec3(0.0)))           <L 97>
                var_39 = wp::vec_t<3, wp::float32>(var_38);
                var_40 = wp::vec_t<6, wp::float32>(var_37, var_39);
                var_41 = wp::atomic_add(var_body_f, var_plug_idx, var_40);
            }
            // if picked_body != latch_idx:                                                       <L 98>
            var_42 = (var_22 != var_latch_idx);
            if (var_42) {
                // vel1 = wp.spatial_top(body_qd[latch_idx])                                      <L 99>
                var_43 = wp::address(var_body_qd, var_latch_idx);
                var_45 = wp::load(var_43);
                var_44 = wp::spatial_top(var_45);
                // mass1 = body_mass[latch_idx]                                                   <L 100>
                var_46 = wp::address(var_body_mass, var_latch_idx);
                var_48 = wp::load(var_46);
                var_47 = wp::copy(var_48);
                // f1 = -(10.0 + mass1) * damping * vel1                                          <L 101>
                var_50 = wp::add(var_49, var_47);
                var_51 = wp::neg(var_50);
                var_52 = wp::mul(var_51, var_damping);
                var_53 = wp::mul(var_52, var_44);
                // wp.atomic_add(body_f, latch_idx, wp.spatial_vector(f1, wp.vec3(0.0)))          <L 102>
                var_55 = wp::vec_t<3, wp::float32>(var_54);
                var_56 = wp::vec_t<6, wp::float32>(var_53, var_55);
                var_57 = wp::atomic_add(var_body_f, var_latch_idx, var_56);
            }
            // return                                                                             <L 103>
            continue;
        }
        // pos0 = wp.transform_get_translation(body_q[plug_idx])                                  <L 105>
        var_58 = wp::address(var_body_q, var_plug_idx);
        var_60 = wp::load(var_58);
        var_59 = wp::transform_get_translation(var_60);
        // vel0 = wp.spatial_top(body_qd[plug_idx])                                               <L 106>
        var_61 = wp::address(var_body_qd, var_plug_idx);
        var_63 = wp::load(var_61);
        var_62 = wp::spatial_top(var_63);
        // mass0 = body_mass[plug_idx]                                                            <L 107>
        var_64 = wp::address(var_body_mass, var_plug_idx);
        var_66 = wp::load(var_64);
        var_65 = wp::copy(var_66);
        // mult0 = 10.0 + mass0                                                                   <L 108>
        var_68 = wp::add(var_67, var_65);
        // f0 = mult0 * (stiffness * (target - pos0) - damping * vel0)                            <L 110>
        var_69 = wp::sub(var_18, var_59);
        var_70 = wp::mul(var_stiffness, var_69);
        var_71 = wp::mul(var_damping, var_62);
        var_72 = wp::sub(var_70, var_71);
        var_73 = wp::mul(var_68, var_72);
        // wp.atomic_add(body_f, plug_idx, wp.spatial_vector(f0, wp.vec3(0.0)))                   <L 111>
        var_75 = wp::vec_t<3, wp::float32>(var_74);
        var_76 = wp::vec_t<6, wp::float32>(var_73, var_75);
        var_77 = wp::atomic_add(var_body_f, var_plug_idx, var_76);
        // vel1 = wp.spatial_top(body_qd[latch_idx])                                              <L 113>
        var_78 = wp::address(var_body_qd, var_latch_idx);
        var_80 = wp::load(var_78);
        var_79 = wp::spatial_top(var_80);
        // mass1 = body_mass[latch_idx]                                                           <L 114>
        var_81 = wp::address(var_body_mass, var_latch_idx);
        var_83 = wp::load(var_81);
        var_82 = wp::copy(var_83);
        // spring_accel = (target - pos0) * (mult0 * stiffness / mass0)                           <L 115>
        var_84 = wp::sub(var_18, var_59);
        var_85 = wp::mul(var_68, var_stiffness);
        var_86 = wp::div(var_85, var_65);
        var_87 = wp::mul(var_84, var_86);
        // f1 = spring_accel * mass1 - vel1 * ((10.0 + mass1) * damping)                          <L 116>
        var_88 = wp::mul(var_87, var_82);
        var_90 = wp::add(var_89, var_82);
        var_91 = wp::mul(var_90, var_damping);
        var_92 = wp::mul(var_79, var_91);
        var_93 = wp::sub(var_88, var_92);
        // wp.atomic_add(body_f, latch_idx, wp.spatial_vector(f1, wp.vec3(0.0)))                  <L 117>
        var_95 = wp::vec_t<3, wp::float32>(var_94);
        var_96 = wp::vec_t<6, wp::float32>(var_93, var_95);
        var_97 = wp::atomic_add(var_body_f, var_latch_idx, var_96);
    }
}



extern "C" __global__ void _apply_gizmo_force_46ea1041_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::vec_t<6, wp::float32>> var_body_qd,
    wp::array_t<wp::vec_t<6, wp::float32>> var_body_f,
    wp::array_t<wp::float32> var_body_mass,
    wp::array_t<wp::vec_t<3, wp::float32>> var_pick_target,
    wp::float32 var_stiffness,
    wp::float32 var_damping,
    wp::array_t<wp::int32> var_pick_body,
    wp::int32 var_plug_idx,
    wp::int32 var_latch_idx,
    wp::vec_t<3, wp::float32> var_gravity,
    wp::array_t<wp::transform_t<wp::float32>> adj_body_q,
    wp::array_t<wp::vec_t<6, wp::float32>> adj_body_qd,
    wp::array_t<wp::vec_t<6, wp::float32>> adj_body_f,
    wp::array_t<wp::float32> adj_body_mass,
    wp::array_t<wp::vec_t<3, wp::float32>> adj_pick_target,
    wp::float32 adj_stiffness,
    wp::float32 adj_damping,
    wp::array_t<wp::int32> adj_pick_body,
    wp::int32 adj_plug_idx,
    wp::int32 adj_latch_idx,
    wp::vec_t<3, wp::float32> adj_gravity)
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
        wp::vec_t<3, wp::float32> var_0;
        wp::float32* var_1;
        wp::vec_t<3, wp::float32> var_2;
        wp::float32 var_3;
        wp::vec_t<3, wp::float32> var_4;
        wp::float32* var_5;
        wp::vec_t<3, wp::float32> var_6;
        wp::float32 var_7;
        const wp::float32 var_8 = 0.0;
        wp::vec_t<3, wp::float32> var_9;
        wp::vec_t<6, wp::float32> var_10;
        wp::vec_t<6, wp::float32> var_11;
        const wp::float32 var_12 = 0.0;
        wp::vec_t<3, wp::float32> var_13;
        wp::vec_t<6, wp::float32> var_14;
        wp::vec_t<6, wp::float32> var_15;
        const wp::int32 var_16 = 0;
        wp::vec_t<3, wp::float32>* var_17;
        wp::vec_t<3, wp::float32> var_18;
        wp::vec_t<3, wp::float32> var_19;
        const wp::int32 var_20 = 0;
        wp::int32* var_21;
        wp::int32 var_22;
        wp::int32 var_23;
        const wp::int32 var_24 = 0;
        bool var_25;
        bool var_26;
        wp::vec_t<6, wp::float32>* var_27;
        wp::vec_t<3, wp::float32> var_28;
        wp::vec_t<6, wp::float32> var_29;
        wp::float32* var_30;
        wp::float32 var_31;
        wp::float32 var_32;
        const wp::float32 var_33 = 10.0;
        wp::float32 var_34;
        wp::float32 var_35;
        wp::float32 var_36;
        wp::vec_t<3, wp::float32> var_37;
        const wp::float32 var_38 = 0.0;
        wp::vec_t<3, wp::float32> var_39;
        wp::vec_t<6, wp::float32> var_40;
        wp::vec_t<6, wp::float32> var_41;
        bool var_42;
        wp::vec_t<6, wp::float32>* var_43;
        wp::vec_t<3, wp::float32> var_44;
        wp::vec_t<6, wp::float32> var_45;
        wp::float32* var_46;
        wp::float32 var_47;
        wp::float32 var_48;
        const wp::float32 var_49 = 10.0;
        wp::float32 var_50;
        wp::float32 var_51;
        wp::float32 var_52;
        wp::vec_t<3, wp::float32> var_53;
        const wp::float32 var_54 = 0.0;
        wp::vec_t<3, wp::float32> var_55;
        wp::vec_t<6, wp::float32> var_56;
        wp::vec_t<6, wp::float32> var_57;
        wp::transform_t<wp::float32>* var_58;
        wp::vec_t<3, wp::float32> var_59;
        wp::transform_t<wp::float32> var_60;
        wp::vec_t<6, wp::float32>* var_61;
        wp::vec_t<3, wp::float32> var_62;
        wp::vec_t<6, wp::float32> var_63;
        wp::float32* var_64;
        wp::float32 var_65;
        wp::float32 var_66;
        const wp::float32 var_67 = 10.0;
        wp::float32 var_68;
        wp::vec_t<3, wp::float32> var_69;
        wp::vec_t<3, wp::float32> var_70;
        wp::vec_t<3, wp::float32> var_71;
        wp::vec_t<3, wp::float32> var_72;
        wp::vec_t<3, wp::float32> var_73;
        const wp::float32 var_74 = 0.0;
        wp::vec_t<3, wp::float32> var_75;
        wp::vec_t<6, wp::float32> var_76;
        wp::vec_t<6, wp::float32> var_77;
        wp::vec_t<6, wp::float32>* var_78;
        wp::vec_t<3, wp::float32> var_79;
        wp::vec_t<6, wp::float32> var_80;
        wp::float32* var_81;
        wp::float32 var_82;
        wp::float32 var_83;
        wp::vec_t<3, wp::float32> var_84;
        wp::float32 var_85;
        wp::float32 var_86;
        wp::vec_t<3, wp::float32> var_87;
        wp::vec_t<3, wp::float32> var_88;
        const wp::float32 var_89 = 10.0;
        wp::float32 var_90;
        wp::float32 var_91;
        wp::vec_t<3, wp::float32> var_92;
        wp::vec_t<3, wp::float32> var_93;
        const wp::float32 var_94 = 0.0;
        wp::vec_t<3, wp::float32> var_95;
        wp::vec_t<6, wp::float32> var_96;
        wp::vec_t<6, wp::float32> var_97;
        //---------
        // dual vars
        wp::vec_t<3, wp::float32> adj_0 = {};
        wp::float32 adj_1 = {};
        wp::vec_t<3, wp::float32> adj_2 = {};
        wp::float32 adj_3 = {};
        wp::vec_t<3, wp::float32> adj_4 = {};
        wp::float32 adj_5 = {};
        wp::vec_t<3, wp::float32> adj_6 = {};
        wp::float32 adj_7 = {};
        wp::float32 adj_8 = {};
        wp::vec_t<3, wp::float32> adj_9 = {};
        wp::vec_t<6, wp::float32> adj_10 = {};
        wp::vec_t<6, wp::float32> adj_11 = {};
        wp::float32 adj_12 = {};
        wp::vec_t<3, wp::float32> adj_13 = {};
        wp::vec_t<6, wp::float32> adj_14 = {};
        wp::vec_t<6, wp::float32> adj_15 = {};
        wp::int32 adj_16 = {};
        wp::vec_t<3, wp::float32> adj_17 = {};
        wp::vec_t<3, wp::float32> adj_18 = {};
        wp::vec_t<3, wp::float32> adj_19 = {};
        wp::int32 adj_20 = {};
        wp::int32 adj_21 = {};
        wp::int32 adj_22 = {};
        wp::int32 adj_23 = {};
        wp::int32 adj_24 = {};
        bool adj_25 = {};
        bool adj_26 = {};
        wp::vec_t<6, wp::float32> adj_27 = {};
        wp::vec_t<3, wp::float32> adj_28 = {};
        wp::vec_t<6, wp::float32> adj_29 = {};
        wp::float32 adj_30 = {};
        wp::float32 adj_31 = {};
        wp::float32 adj_32 = {};
        wp::float32 adj_33 = {};
        wp::float32 adj_34 = {};
        wp::float32 adj_35 = {};
        wp::float32 adj_36 = {};
        wp::vec_t<3, wp::float32> adj_37 = {};
        wp::float32 adj_38 = {};
        wp::vec_t<3, wp::float32> adj_39 = {};
        wp::vec_t<6, wp::float32> adj_40 = {};
        wp::vec_t<6, wp::float32> adj_41 = {};
        bool adj_42 = {};
        wp::vec_t<6, wp::float32> adj_43 = {};
        wp::vec_t<3, wp::float32> adj_44 = {};
        wp::vec_t<6, wp::float32> adj_45 = {};
        wp::float32 adj_46 = {};
        wp::float32 adj_47 = {};
        wp::float32 adj_48 = {};
        wp::float32 adj_49 = {};
        wp::float32 adj_50 = {};
        wp::float32 adj_51 = {};
        wp::float32 adj_52 = {};
        wp::vec_t<3, wp::float32> adj_53 = {};
        wp::float32 adj_54 = {};
        wp::vec_t<3, wp::float32> adj_55 = {};
        wp::vec_t<6, wp::float32> adj_56 = {};
        wp::vec_t<6, wp::float32> adj_57 = {};
        wp::transform_t<wp::float32> adj_58 = {};
        wp::vec_t<3, wp::float32> adj_59 = {};
        wp::transform_t<wp::float32> adj_60 = {};
        wp::vec_t<6, wp::float32> adj_61 = {};
        wp::vec_t<3, wp::float32> adj_62 = {};
        wp::vec_t<6, wp::float32> adj_63 = {};
        wp::float32 adj_64 = {};
        wp::float32 adj_65 = {};
        wp::float32 adj_66 = {};
        wp::float32 adj_67 = {};
        wp::float32 adj_68 = {};
        wp::vec_t<3, wp::float32> adj_69 = {};
        wp::vec_t<3, wp::float32> adj_70 = {};
        wp::vec_t<3, wp::float32> adj_71 = {};
        wp::vec_t<3, wp::float32> adj_72 = {};
        wp::vec_t<3, wp::float32> adj_73 = {};
        wp::float32 adj_74 = {};
        wp::vec_t<3, wp::float32> adj_75 = {};
        wp::vec_t<6, wp::float32> adj_76 = {};
        wp::vec_t<6, wp::float32> adj_77 = {};
        wp::vec_t<6, wp::float32> adj_78 = {};
        wp::vec_t<3, wp::float32> adj_79 = {};
        wp::vec_t<6, wp::float32> adj_80 = {};
        wp::float32 adj_81 = {};
        wp::float32 adj_82 = {};
        wp::float32 adj_83 = {};
        wp::vec_t<3, wp::float32> adj_84 = {};
        wp::float32 adj_85 = {};
        wp::float32 adj_86 = {};
        wp::vec_t<3, wp::float32> adj_87 = {};
        wp::vec_t<3, wp::float32> adj_88 = {};
        wp::float32 adj_89 = {};
        wp::float32 adj_90 = {};
        wp::float32 adj_91 = {};
        wp::vec_t<3, wp::float32> adj_92 = {};
        wp::vec_t<3, wp::float32> adj_93 = {};
        wp::float32 adj_94 = {};
        wp::vec_t<3, wp::float32> adj_95 = {};
        wp::vec_t<6, wp::float32> adj_96 = {};
        wp::vec_t<6, wp::float32> adj_97 = {};
        //---------
        // forward
        // def _apply_gizmo_force(                                                                <L 62>
        // anti_g0 = -gravity * body_mass[plug_idx]                                               <L 84>
        var_0 = wp::neg(var_gravity);
        var_1 = wp::address(var_body_mass, var_plug_idx);
        var_3 = wp::load(var_1);
        var_2 = wp::mul(var_0, var_3);
        // anti_g1 = -gravity * body_mass[latch_idx]                                              <L 85>
        var_4 = wp::neg(var_gravity);
        var_5 = wp::address(var_body_mass, var_latch_idx);
        var_7 = wp::load(var_5);
        var_6 = wp::mul(var_4, var_7);
        // wp.atomic_add(body_f, plug_idx, wp.spatial_vector(anti_g0, wp.vec3(0.0)))              <L 86>
        var_9 = wp::vec_t<3, wp::float32>(var_8);
        var_10 = wp::vec_t<6, wp::float32>(var_2, var_9);
        // var_11 = wp::atomic_add(var_body_f, var_plug_idx, var_10);
        // wp.atomic_add(body_f, latch_idx, wp.spatial_vector(anti_g1, wp.vec3(0.0)))             <L 87>
        var_13 = wp::vec_t<3, wp::float32>(var_12);
        var_14 = wp::vec_t<6, wp::float32>(var_6, var_13);
        // var_15 = wp::atomic_add(var_body_f, var_latch_idx, var_14);
        // target = pick_target[0]                                                                <L 89>
        var_17 = wp::address(var_pick_target, var_16);
        var_19 = wp::load(var_17);
        var_18 = wp::copy(var_19);
        // picked_body = pick_body[0]                                                             <L 90>
        var_21 = wp::address(var_pick_body, var_20);
        var_23 = wp::load(var_21);
        var_22 = wp::copy(var_23);
        // if picked_body >= 0:                                                                   <L 92>
        var_25 = (var_22 >= var_24);
        if (var_25) {
            // if picked_body != plug_idx:                                                        <L 93>
            var_26 = (var_22 != var_plug_idx);
            if (var_26) {
                // vel0 = wp.spatial_top(body_qd[plug_idx])                                       <L 94>
                var_27 = wp::address(var_body_qd, var_plug_idx);
                var_29 = wp::load(var_27);
                var_28 = wp::spatial_top(var_29);
                // mass0 = body_mass[plug_idx]                                                    <L 95>
                var_30 = wp::address(var_body_mass, var_plug_idx);
                var_32 = wp::load(var_30);
                var_31 = wp::copy(var_32);
                // f0 = -(10.0 + mass0) * damping * vel0                                          <L 96>
                var_34 = wp::add(var_33, var_31);
                var_35 = wp::neg(var_34);
                var_36 = wp::mul(var_35, var_damping);
                var_37 = wp::mul(var_36, var_28);
                // wp.atomic_add(body_f, plug_idx, wp.spatial_vector(f0, wp.vec3(0.0)))           <L 97>
                var_39 = wp::vec_t<3, wp::float32>(var_38);
                var_40 = wp::vec_t<6, wp::float32>(var_37, var_39);
                // var_41 = wp::atomic_add(var_body_f, var_plug_idx, var_40);
            }
            // if picked_body != latch_idx:                                                       <L 98>
            var_42 = (var_22 != var_latch_idx);
            if (var_42) {
                // vel1 = wp.spatial_top(body_qd[latch_idx])                                      <L 99>
                var_43 = wp::address(var_body_qd, var_latch_idx);
                var_45 = wp::load(var_43);
                var_44 = wp::spatial_top(var_45);
                // mass1 = body_mass[latch_idx]                                                   <L 100>
                var_46 = wp::address(var_body_mass, var_latch_idx);
                var_48 = wp::load(var_46);
                var_47 = wp::copy(var_48);
                // f1 = -(10.0 + mass1) * damping * vel1                                          <L 101>
                var_50 = wp::add(var_49, var_47);
                var_51 = wp::neg(var_50);
                var_52 = wp::mul(var_51, var_damping);
                var_53 = wp::mul(var_52, var_44);
                // wp.atomic_add(body_f, latch_idx, wp.spatial_vector(f1, wp.vec3(0.0)))          <L 102>
                var_55 = wp::vec_t<3, wp::float32>(var_54);
                var_56 = wp::vec_t<6, wp::float32>(var_53, var_55);
                // var_57 = wp::atomic_add(var_body_f, var_latch_idx, var_56);
            }
            // return                                                                             <L 103>
            goto label0;
        }
        // pos0 = wp.transform_get_translation(body_q[plug_idx])                                  <L 105>
        var_58 = wp::address(var_body_q, var_plug_idx);
        var_60 = wp::load(var_58);
        var_59 = wp::transform_get_translation(var_60);
        // vel0 = wp.spatial_top(body_qd[plug_idx])                                               <L 106>
        var_61 = wp::address(var_body_qd, var_plug_idx);
        var_63 = wp::load(var_61);
        var_62 = wp::spatial_top(var_63);
        // mass0 = body_mass[plug_idx]                                                            <L 107>
        var_64 = wp::address(var_body_mass, var_plug_idx);
        var_66 = wp::load(var_64);
        var_65 = wp::copy(var_66);
        // mult0 = 10.0 + mass0                                                                   <L 108>
        var_68 = wp::add(var_67, var_65);
        // f0 = mult0 * (stiffness * (target - pos0) - damping * vel0)                            <L 110>
        var_69 = wp::sub(var_18, var_59);
        var_70 = wp::mul(var_stiffness, var_69);
        var_71 = wp::mul(var_damping, var_62);
        var_72 = wp::sub(var_70, var_71);
        var_73 = wp::mul(var_68, var_72);
        // wp.atomic_add(body_f, plug_idx, wp.spatial_vector(f0, wp.vec3(0.0)))                   <L 111>
        var_75 = wp::vec_t<3, wp::float32>(var_74);
        var_76 = wp::vec_t<6, wp::float32>(var_73, var_75);
        // var_77 = wp::atomic_add(var_body_f, var_plug_idx, var_76);
        // vel1 = wp.spatial_top(body_qd[latch_idx])                                              <L 113>
        var_78 = wp::address(var_body_qd, var_latch_idx);
        var_80 = wp::load(var_78);
        var_79 = wp::spatial_top(var_80);
        // mass1 = body_mass[latch_idx]                                                           <L 114>
        var_81 = wp::address(var_body_mass, var_latch_idx);
        var_83 = wp::load(var_81);
        var_82 = wp::copy(var_83);
        // spring_accel = (target - pos0) * (mult0 * stiffness / mass0)                           <L 115>
        var_84 = wp::sub(var_18, var_59);
        var_85 = wp::mul(var_68, var_stiffness);
        var_86 = wp::div(var_85, var_65);
        var_87 = wp::mul(var_84, var_86);
        // f1 = spring_accel * mass1 - vel1 * ((10.0 + mass1) * damping)                          <L 116>
        var_88 = wp::mul(var_87, var_82);
        var_90 = wp::add(var_89, var_82);
        var_91 = wp::mul(var_90, var_damping);
        var_92 = wp::mul(var_79, var_91);
        var_93 = wp::sub(var_88, var_92);
        // wp.atomic_add(body_f, latch_idx, wp.spatial_vector(f1, wp.vec3(0.0)))                  <L 117>
        var_95 = wp::vec_t<3, wp::float32>(var_94);
        var_96 = wp::vec_t<6, wp::float32>(var_93, var_95);
        // var_97 = wp::atomic_add(var_body_f, var_latch_idx, var_96);
        //---------
        // reverse
        wp::adj_atomic_add(var_body_f, var_latch_idx, var_96, adj_body_f, adj_latch_idx, adj_96, adj_97);
        wp::adj_vec_t(var_93, var_95, adj_93, adj_95, adj_96);
        wp::adj_vec_t(var_94, adj_94, adj_95);
        // adj: wp.atomic_add(body_f, latch_idx, wp.spatial_vector(f1, wp.vec3(0.0)))             <L 117>
        wp::adj_sub(var_88, var_92, adj_88, adj_92, adj_93);
        wp::adj_mul(var_79, var_91, adj_79, adj_91, adj_92);
        wp::adj_mul(var_90, var_damping, adj_90, adj_damping, adj_91);
        wp::adj_add(var_89, var_82, adj_89, adj_82, adj_90);
        wp::adj_mul(var_87, var_82, adj_87, adj_82, adj_88);
        // adj: f1 = spring_accel * mass1 - vel1 * ((10.0 + mass1) * damping)                     <L 116>
        wp::adj_mul(var_84, var_86, adj_84, adj_86, adj_87);
        wp::adj_div(var_85, var_65, var_86, adj_85, adj_65, adj_86);
        wp::adj_mul(var_68, var_stiffness, adj_68, adj_stiffness, adj_85);
        wp::adj_sub(var_18, var_59, adj_18, adj_59, adj_84);
        // adj: spring_accel = (target - pos0) * (mult0 * stiffness / mass0)                      <L 115>
        wp::adj_copy(var_83, adj_81, adj_82);
        wp::adj_address(var_body_mass, var_latch_idx, adj_body_mass, adj_latch_idx, adj_81);
        // adj: mass1 = body_mass[latch_idx]                                                      <L 114>
        wp::adj_spatial_top(var_80, adj_78, adj_79);
        wp::adj_address(var_body_qd, var_latch_idx, adj_body_qd, adj_latch_idx, adj_78);
        // adj: vel1 = wp.spatial_top(body_qd[latch_idx])                                         <L 113>
        wp::adj_atomic_add(var_body_f, var_plug_idx, var_76, adj_body_f, adj_plug_idx, adj_76, adj_77);
        wp::adj_vec_t(var_73, var_75, adj_73, adj_75, adj_76);
        wp::adj_vec_t(var_74, adj_74, adj_75);
        // adj: wp.atomic_add(body_f, plug_idx, wp.spatial_vector(f0, wp.vec3(0.0)))              <L 111>
        wp::adj_mul(var_68, var_72, adj_68, adj_72, adj_73);
        wp::adj_sub(var_70, var_71, adj_70, adj_71, adj_72);
        wp::adj_mul(var_damping, var_62, adj_damping, adj_62, adj_71);
        wp::adj_mul(var_stiffness, var_69, adj_stiffness, adj_69, adj_70);
        wp::adj_sub(var_18, var_59, adj_18, adj_59, adj_69);
        // adj: f0 = mult0 * (stiffness * (target - pos0) - damping * vel0)                       <L 110>
        wp::adj_add(var_67, var_65, adj_67, adj_65, adj_68);
        // adj: mult0 = 10.0 + mass0                                                              <L 108>
        wp::adj_copy(var_66, adj_64, adj_65);
        wp::adj_address(var_body_mass, var_plug_idx, adj_body_mass, adj_plug_idx, adj_64);
        // adj: mass0 = body_mass[plug_idx]                                                       <L 107>
        wp::adj_spatial_top(var_63, adj_61, adj_62);
        wp::adj_address(var_body_qd, var_plug_idx, adj_body_qd, adj_plug_idx, adj_61);
        // adj: vel0 = wp.spatial_top(body_qd[plug_idx])                                          <L 106>
        wp::adj_transform_get_translation(var_60, adj_58, adj_59);
        wp::adj_address(var_body_q, var_plug_idx, adj_body_q, adj_plug_idx, adj_58);
        // adj: pos0 = wp.transform_get_translation(body_q[plug_idx])                             <L 105>
        if (var_25) {
            label0:;
            // adj: return                                                                        <L 103>
            if (var_42) {
                wp::adj_atomic_add(var_body_f, var_latch_idx, var_56, adj_body_f, adj_latch_idx, adj_56, adj_57);
                wp::adj_vec_t(var_53, var_55, adj_53, adj_55, adj_56);
                wp::adj_vec_t(var_54, adj_54, adj_55);
                // adj: wp.atomic_add(body_f, latch_idx, wp.spatial_vector(f1, wp.vec3(0.0)))     <L 102>
                wp::adj_mul(var_52, var_44, adj_52, adj_44, adj_53);
                wp::adj_mul(var_51, var_damping, adj_51, adj_damping, adj_52);
                wp::adj_neg(var_50, adj_50, adj_51);
                wp::adj_add(var_49, var_47, adj_49, adj_47, adj_50);
                // adj: f1 = -(10.0 + mass1) * damping * vel1                                     <L 101>
                wp::adj_copy(var_48, adj_46, adj_47);
                wp::adj_address(var_body_mass, var_latch_idx, adj_body_mass, adj_latch_idx, adj_46);
                // adj: mass1 = body_mass[latch_idx]                                              <L 100>
                wp::adj_spatial_top(var_45, adj_43, adj_44);
                wp::adj_address(var_body_qd, var_latch_idx, adj_body_qd, adj_latch_idx, adj_43);
                // adj: vel1 = wp.spatial_top(body_qd[latch_idx])                                 <L 99>
            }
            // adj: if picked_body != latch_idx:                                                  <L 98>
            if (var_26) {
                wp::adj_atomic_add(var_body_f, var_plug_idx, var_40, adj_body_f, adj_plug_idx, adj_40, adj_41);
                wp::adj_vec_t(var_37, var_39, adj_37, adj_39, adj_40);
                wp::adj_vec_t(var_38, adj_38, adj_39);
                // adj: wp.atomic_add(body_f, plug_idx, wp.spatial_vector(f0, wp.vec3(0.0)))      <L 97>
                wp::adj_mul(var_36, var_28, adj_36, adj_28, adj_37);
                wp::adj_mul(var_35, var_damping, adj_35, adj_damping, adj_36);
                wp::adj_neg(var_34, adj_34, adj_35);
                wp::adj_add(var_33, var_31, adj_33, adj_31, adj_34);
                // adj: f0 = -(10.0 + mass0) * damping * vel0                                     <L 96>
                wp::adj_copy(var_32, adj_30, adj_31);
                wp::adj_address(var_body_mass, var_plug_idx, adj_body_mass, adj_plug_idx, adj_30);
                // adj: mass0 = body_mass[plug_idx]                                               <L 95>
                wp::adj_spatial_top(var_29, adj_27, adj_28);
                wp::adj_address(var_body_qd, var_plug_idx, adj_body_qd, adj_plug_idx, adj_27);
                // adj: vel0 = wp.spatial_top(body_qd[plug_idx])                                  <L 94>
            }
            // adj: if picked_body != plug_idx:                                                   <L 93>
        }
        // adj: if picked_body >= 0:                                                              <L 92>
        wp::adj_copy(var_23, adj_21, adj_22);
        wp::adj_address(var_pick_body, var_20, adj_pick_body, adj_20, adj_21);
        // adj: picked_body = pick_body[0]                                                        <L 90>
        wp::adj_copy(var_19, adj_17, adj_18);
        wp::adj_address(var_pick_target, var_16, adj_pick_target, adj_16, adj_17);
        // adj: target = pick_target[0]                                                           <L 89>
        wp::adj_atomic_add(var_body_f, var_latch_idx, var_14, adj_body_f, adj_latch_idx, adj_14, adj_15);
        wp::adj_vec_t(var_6, var_13, adj_6, adj_13, adj_14);
        wp::adj_vec_t(var_12, adj_12, adj_13);
        // adj: wp.atomic_add(body_f, latch_idx, wp.spatial_vector(anti_g1, wp.vec3(0.0)))        <L 87>
        wp::adj_atomic_add(var_body_f, var_plug_idx, var_10, adj_body_f, adj_plug_idx, adj_10, adj_11);
        wp::adj_vec_t(var_2, var_9, adj_2, adj_9, adj_10);
        wp::adj_vec_t(var_8, adj_8, adj_9);
        // adj: wp.atomic_add(body_f, plug_idx, wp.spatial_vector(anti_g0, wp.vec3(0.0)))         <L 86>
        wp::adj_mul(var_4, var_7, adj_4, adj_5, adj_6);
        wp::adj_address(var_body_mass, var_latch_idx, adj_body_mass, adj_latch_idx, adj_5);
        wp::adj_neg(var_gravity, adj_gravity, adj_4);
        // adj: anti_g1 = -gravity * body_mass[latch_idx]                                         <L 85>
        wp::adj_mul(var_0, var_3, adj_0, adj_1, adj_2);
        wp::adj_address(var_body_mass, var_plug_idx, adj_body_mass, adj_plug_idx, adj_1);
        wp::adj_neg(var_gravity, adj_gravity, adj_0);
        // adj: anti_g0 = -gravity * body_mass[plug_idx]                                          <L 84>
        // adj: def _apply_gizmo_force(                                                           <L 62>
        continue;
    }
}



extern "C" __global__ void _align_cable_orientations_9081a226_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::int32> var_cable_body_idx,
    wp::array_t<wp::int32> var_cable_next_idx,
    wp::array_t<wp::vec_t<3, wp::float32>> var_cable_next_start_offsets)
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
        wp::int32* var_4;
        wp::int32 var_5;
        wp::int32 var_6;
        wp::transform_t<wp::float32>* var_7;
        wp::transform_t<wp::float32> var_8;
        wp::transform_t<wp::float32> var_9;
        wp::vec_t<3, wp::float32> var_10;
        wp::quat_t<wp::float32> var_11;
        wp::transform_t<wp::float32>* var_12;
        wp::transform_t<wp::float32> var_13;
        wp::transform_t<wp::float32> var_14;
        wp::vec_t<3, wp::float32> var_15;
        wp::quat_t<wp::float32> var_16;
        wp::vec_t<3, wp::float32>* var_17;
        wp::vec_t<3, wp::float32> var_18;
        wp::vec_t<3, wp::float32> var_19;
        wp::vec_t<3, wp::float32> var_20;
        wp::vec_t<3, wp::float32> var_21;
        wp::float32 var_22;
        const wp::float32 var_23 = 1e-10;
        bool var_24;
        wp::vec_t<3, wp::float32> var_25;
        const wp::float32 var_26 = 0.0;
        const wp::float32 var_27 = 0.0;
        const wp::float32 var_28 = 1.0;
        wp::vec_t<3, wp::float32> var_29;
        wp::vec_t<3, wp::float32> var_30;
        wp::quat_t<wp::float32> var_31;
        const wp::float32 var_32 = 1e-08;
        wp::quat_t<wp::float32> var_33;
        wp::quat_t<wp::float32> var_34;
        wp::transform_t<wp::float32> var_35;
        //---------
        // forward
        // def _align_cable_orientations(                                                         <L 142>
        // tid = wp.tid()                                                                         <L 153>
        var_0 = builtin_tid1d();
        // bi = cable_body_idx[tid]                                                               <L 154>
        var_1 = wp::address(var_cable_body_idx, var_0);
        var_3 = wp::load(var_1);
        var_2 = wp::copy(var_3);
        // bi_next = cable_next_idx[tid]                                                          <L 155>
        var_4 = wp::address(var_cable_next_idx, var_0);
        var_6 = wp::load(var_4);
        var_5 = wp::copy(var_6);
        // tf = body_q[bi]                                                                        <L 157>
        var_7 = wp::address(var_body_q, var_2);
        var_9 = wp::load(var_7);
        var_8 = wp::copy(var_9);
        // pos = wp.transform_get_translation(tf)                                                 <L 158>
        var_10 = wp::transform_get_translation(var_8);
        // rot = wp.transform_get_rotation(tf)                                                    <L 159>
        var_11 = wp::transform_get_rotation(var_8);
        // next_tf = body_q[bi_next]                                                              <L 161>
        var_12 = wp::address(var_body_q, var_5);
        var_14 = wp::load(var_12);
        var_13 = wp::copy(var_14);
        // next_pos = wp.transform_get_translation(next_tf)                                       <L 162>
        var_15 = wp::transform_get_translation(var_13);
        // next_rot = wp.transform_get_rotation(next_tf)                                          <L 163>
        var_16 = wp::transform_get_rotation(var_13);
        // seg = next_pos + wp.quat_rotate(next_rot, cable_next_start_offsets[tid]) - pos         <L 164>
        var_17 = wp::address(var_cable_next_start_offsets, var_0);
        var_19 = wp::load(var_17);
        var_18 = wp::quat_rotate(var_16, var_19);
        var_20 = wp::add(var_15, var_18);
        var_21 = wp::sub(var_20, var_10);
        // seg_len = wp.length(seg)                                                               <L 165>
        var_22 = wp::length(var_21);
        // if seg_len < 1.0e-10:                                                                  <L 166>
        var_24 = (var_22 < var_23);
        if (var_24) {
            // return                                                                             <L 167>
            continue;
        }
        // d = seg / seg_len                                                                      <L 168>
        var_25 = wp::div(var_21, var_22);
        // z_current = wp.quat_rotate(rot, wp.vec3(0.0, 0.0, 1.0))                                <L 170>
        var_29 = wp::vec_t<3, wp::float32>(var_26, var_27, var_28);
        var_30 = wp::quat_rotate(var_11, var_29);
        // q_swing = quat_between_vectors_robust(z_current, d)                                    <L 171>
        var_31 = quat_between_vectors_robust_0(var_30, var_25, var_32);
        // rot_new = wp.normalize(wp.mul(q_swing, rot))                                           <L 172>
        var_33 = wp::mul(var_31, var_11);
        var_34 = wp::normalize(var_33);
        // body_q[bi] = wp.transform(pos, rot_new)                                                <L 174>
        var_35 = wp::transform_t<wp::float32>(var_10, var_34);
        wp::array_store(var_body_q, var_2, var_35);
    }
}



extern "C" __global__ void _align_cable_orientations_9081a226_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::int32> var_cable_body_idx,
    wp::array_t<wp::int32> var_cable_next_idx,
    wp::array_t<wp::vec_t<3, wp::float32>> var_cable_next_start_offsets,
    wp::array_t<wp::transform_t<wp::float32>> adj_body_q,
    wp::array_t<wp::int32> adj_cable_body_idx,
    wp::array_t<wp::int32> adj_cable_next_idx,
    wp::array_t<wp::vec_t<3, wp::float32>> adj_cable_next_start_offsets)
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
        wp::int32* var_4;
        wp::int32 var_5;
        wp::int32 var_6;
        wp::transform_t<wp::float32>* var_7;
        wp::transform_t<wp::float32> var_8;
        wp::transform_t<wp::float32> var_9;
        wp::vec_t<3, wp::float32> var_10;
        wp::quat_t<wp::float32> var_11;
        wp::transform_t<wp::float32>* var_12;
        wp::transform_t<wp::float32> var_13;
        wp::transform_t<wp::float32> var_14;
        wp::vec_t<3, wp::float32> var_15;
        wp::quat_t<wp::float32> var_16;
        wp::vec_t<3, wp::float32>* var_17;
        wp::vec_t<3, wp::float32> var_18;
        wp::vec_t<3, wp::float32> var_19;
        wp::vec_t<3, wp::float32> var_20;
        wp::vec_t<3, wp::float32> var_21;
        wp::float32 var_22;
        const wp::float32 var_23 = 1e-10;
        bool var_24;
        wp::vec_t<3, wp::float32> var_25;
        const wp::float32 var_26 = 0.0;
        const wp::float32 var_27 = 0.0;
        const wp::float32 var_28 = 1.0;
        wp::vec_t<3, wp::float32> var_29;
        wp::vec_t<3, wp::float32> var_30;
        wp::quat_t<wp::float32> var_31;
        const wp::float32 var_32 = 1e-08;
        wp::quat_t<wp::float32> var_33;
        wp::quat_t<wp::float32> var_34;
        wp::transform_t<wp::float32> var_35;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::int32 adj_2 = {};
        wp::int32 adj_3 = {};
        wp::int32 adj_4 = {};
        wp::int32 adj_5 = {};
        wp::int32 adj_6 = {};
        wp::transform_t<wp::float32> adj_7 = {};
        wp::transform_t<wp::float32> adj_8 = {};
        wp::transform_t<wp::float32> adj_9 = {};
        wp::vec_t<3, wp::float32> adj_10 = {};
        wp::quat_t<wp::float32> adj_11 = {};
        wp::transform_t<wp::float32> adj_12 = {};
        wp::transform_t<wp::float32> adj_13 = {};
        wp::transform_t<wp::float32> adj_14 = {};
        wp::vec_t<3, wp::float32> adj_15 = {};
        wp::quat_t<wp::float32> adj_16 = {};
        wp::vec_t<3, wp::float32> adj_17 = {};
        wp::vec_t<3, wp::float32> adj_18 = {};
        wp::vec_t<3, wp::float32> adj_19 = {};
        wp::vec_t<3, wp::float32> adj_20 = {};
        wp::vec_t<3, wp::float32> adj_21 = {};
        wp::float32 adj_22 = {};
        wp::float32 adj_23 = {};
        bool adj_24 = {};
        wp::vec_t<3, wp::float32> adj_25 = {};
        wp::float32 adj_26 = {};
        wp::float32 adj_27 = {};
        wp::float32 adj_28 = {};
        wp::vec_t<3, wp::float32> adj_29 = {};
        wp::vec_t<3, wp::float32> adj_30 = {};
        wp::quat_t<wp::float32> adj_31 = {};
        wp::float32 adj_32 = {};
        wp::quat_t<wp::float32> adj_33 = {};
        wp::quat_t<wp::float32> adj_34 = {};
        wp::transform_t<wp::float32> adj_35 = {};
        //---------
        // forward
        // def _align_cable_orientations(                                                         <L 142>
        // tid = wp.tid()                                                                         <L 153>
        var_0 = builtin_tid1d();
        // bi = cable_body_idx[tid]                                                               <L 154>
        var_1 = wp::address(var_cable_body_idx, var_0);
        var_3 = wp::load(var_1);
        var_2 = wp::copy(var_3);
        // bi_next = cable_next_idx[tid]                                                          <L 155>
        var_4 = wp::address(var_cable_next_idx, var_0);
        var_6 = wp::load(var_4);
        var_5 = wp::copy(var_6);
        // tf = body_q[bi]                                                                        <L 157>
        var_7 = wp::address(var_body_q, var_2);
        var_9 = wp::load(var_7);
        var_8 = wp::copy(var_9);
        // pos = wp.transform_get_translation(tf)                                                 <L 158>
        var_10 = wp::transform_get_translation(var_8);
        // rot = wp.transform_get_rotation(tf)                                                    <L 159>
        var_11 = wp::transform_get_rotation(var_8);
        // next_tf = body_q[bi_next]                                                              <L 161>
        var_12 = wp::address(var_body_q, var_5);
        var_14 = wp::load(var_12);
        var_13 = wp::copy(var_14);
        // next_pos = wp.transform_get_translation(next_tf)                                       <L 162>
        var_15 = wp::transform_get_translation(var_13);
        // next_rot = wp.transform_get_rotation(next_tf)                                          <L 163>
        var_16 = wp::transform_get_rotation(var_13);
        // seg = next_pos + wp.quat_rotate(next_rot, cable_next_start_offsets[tid]) - pos         <L 164>
        var_17 = wp::address(var_cable_next_start_offsets, var_0);
        var_19 = wp::load(var_17);
        var_18 = wp::quat_rotate(var_16, var_19);
        var_20 = wp::add(var_15, var_18);
        var_21 = wp::sub(var_20, var_10);
        // seg_len = wp.length(seg)                                                               <L 165>
        var_22 = wp::length(var_21);
        // if seg_len < 1.0e-10:                                                                  <L 166>
        var_24 = (var_22 < var_23);
        if (var_24) {
            // return                                                                             <L 167>
            goto label0;
        }
        // d = seg / seg_len                                                                      <L 168>
        var_25 = wp::div(var_21, var_22);
        // z_current = wp.quat_rotate(rot, wp.vec3(0.0, 0.0, 1.0))                                <L 170>
        var_29 = wp::vec_t<3, wp::float32>(var_26, var_27, var_28);
        var_30 = wp::quat_rotate(var_11, var_29);
        // q_swing = quat_between_vectors_robust(z_current, d)                                    <L 171>
        var_31 = quat_between_vectors_robust_0(var_30, var_25, var_32);
        // rot_new = wp.normalize(wp.mul(q_swing, rot))                                           <L 172>
        var_33 = wp::mul(var_31, var_11);
        var_34 = wp::normalize(var_33);
        // body_q[bi] = wp.transform(pos, rot_new)                                                <L 174>
        var_35 = wp::transform_t<wp::float32>(var_10, var_34);
        // wp::array_store(var_body_q, var_2, var_35);
        //---------
        // reverse
        wp::adj_array_store(var_body_q, var_2, var_35, adj_body_q, adj_2, adj_35);
        wp::adj_transform_t(var_10, var_34, adj_10, adj_34, adj_35);
        // adj: body_q[bi] = wp.transform(pos, rot_new)                                           <L 174>
        wp::adj_normalize(var_33, adj_33, adj_34);
        wp::adj_mul(var_31, var_11, adj_31, adj_11, adj_33);
        // adj: rot_new = wp.normalize(wp.mul(q_swing, rot))                                      <L 172>
        adj_quat_between_vectors_robust_0(var_30, var_25, var_32, adj_30, adj_25, adj_32, adj_31);
        // adj: q_swing = quat_between_vectors_robust(z_current, d)                               <L 171>
        wp::adj_quat_rotate(var_11, var_29, adj_11, adj_29, adj_30);
        wp::adj_vec_t(var_26, var_27, var_28, adj_26, adj_27, adj_28, adj_29);
        // adj: z_current = wp.quat_rotate(rot, wp.vec3(0.0, 0.0, 1.0))                           <L 170>
        wp::adj_div(var_21, var_22, adj_21, adj_22, adj_25);
        // adj: d = seg / seg_len                                                                 <L 168>
        if (var_24) {
            label0:;
            // adj: return                                                                        <L 167>
        }
        // adj: if seg_len < 1.0e-10:                                                             <L 166>
        wp::adj_length(var_21, var_22, adj_21, adj_22);
        // adj: seg_len = wp.length(seg)                                                          <L 165>
        wp::adj_sub(var_20, var_10, adj_20, adj_10, adj_21);
        wp::adj_add(var_15, var_18, adj_15, adj_18, adj_20);
        wp::adj_quat_rotate(var_16, var_19, adj_16, adj_17, adj_18);
        wp::adj_address(var_cable_next_start_offsets, var_0, adj_cable_next_start_offsets, adj_0, adj_17);
        // adj: seg = next_pos + wp.quat_rotate(next_rot, cable_next_start_offsets[tid]) - pos    <L 164>
        wp::adj_transform_get_rotation(var_13, adj_13, adj_16);
        // adj: next_rot = wp.transform_get_rotation(next_tf)                                     <L 163>
        wp::adj_transform_get_translation(var_13, adj_13, adj_15);
        // adj: next_pos = wp.transform_get_translation(next_tf)                                  <L 162>
        wp::adj_copy(var_14, adj_12, adj_13);
        wp::adj_address(var_body_q, var_5, adj_body_q, adj_5, adj_12);
        // adj: next_tf = body_q[bi_next]                                                         <L 161>
        wp::adj_transform_get_rotation(var_8, adj_8, adj_11);
        // adj: rot = wp.transform_get_rotation(tf)                                               <L 159>
        wp::adj_transform_get_translation(var_8, adj_8, adj_10);
        // adj: pos = wp.transform_get_translation(tf)                                            <L 158>
        wp::adj_copy(var_9, adj_7, adj_8);
        wp::adj_address(var_body_q, var_2, adj_body_q, adj_2, adj_7);
        // adj: tf = body_q[bi]                                                                   <L 157>
        wp::adj_copy(var_6, adj_4, adj_5);
        wp::adj_address(var_cable_next_idx, var_0, adj_cable_next_idx, adj_0, adj_4);
        // adj: bi_next = cable_next_idx[tid]                                                     <L 155>
        wp::adj_copy(var_3, adj_1, adj_2);
        wp::adj_address(var_cable_body_idx, var_0, adj_cable_body_idx, adj_0, adj_1);
        // adj: bi = cable_body_idx[tid]                                                          <L 154>
        // adj: tid = wp.tid()                                                                    <L 153>
        // adj: def _align_cable_orientations(                                                    <L 142>
        continue;
    }
}



extern "C" __global__ void _sync_cable_anchors_bc812dd1_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::vec_t<6, wp::float32>> var_body_qd,
    wp::int32 var_plug_idx,
    wp::array_t<wp::int32> var_anchor_indices,
    wp::array_t<wp::vec_t<3, wp::float32>> var_anchor_offsets,
    wp::array_t<wp::quat_t<wp::float32>> var_anchor_rotations)
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
        wp::vec_t<3, wp::float32> var_4;
        wp::quat_t<wp::float32> var_5;
        wp::int32* var_6;
        wp::int32 var_7;
        wp::int32 var_8;
        wp::vec_t<3, wp::float32>* var_9;
        wp::vec_t<3, wp::float32> var_10;
        wp::vec_t<3, wp::float32> var_11;
        wp::vec_t<3, wp::float32> var_12;
        wp::quat_t<wp::float32>* var_13;
        wp::quat_t<wp::float32> var_14;
        wp::quat_t<wp::float32> var_15;
        wp::quat_t<wp::float32> var_16;
        wp::transform_t<wp::float32> var_17;
        const wp::float32 var_18 = 0.0;
        const wp::float32 var_19 = 0.0;
        const wp::float32 var_20 = 0.0;
        const wp::float32 var_21 = 0.0;
        const wp::float32 var_22 = 0.0;
        const wp::float32 var_23 = 0.0;
        wp::vec_t<6, wp::float32> var_24;
        //---------
        // forward
        // def _sync_cable_anchors(                                                               <L 121>
        // tid = wp.tid()                                                                         <L 130>
        var_0 = builtin_tid1d();
        // plug_tf = body_q[plug_idx]                                                             <L 131>
        var_1 = wp::address(var_body_q, var_plug_idx);
        var_3 = wp::load(var_1);
        var_2 = wp::copy(var_3);
        // plug_pos = wp.transform_get_translation(plug_tf)                                       <L 132>
        var_4 = wp::transform_get_translation(var_2);
        // plug_rot = wp.transform_get_rotation(plug_tf)                                          <L 133>
        var_5 = wp::transform_get_rotation(var_2);
        // idx = anchor_indices[tid]                                                              <L 134>
        var_6 = wp::address(var_anchor_indices, var_0);
        var_8 = wp::load(var_6);
        var_7 = wp::copy(var_8);
        // anchor_world = plug_pos + wp.quat_rotate(plug_rot, anchor_offsets[tid])                <L 135>
        var_9 = wp::address(var_anchor_offsets, var_0);
        var_11 = wp::load(var_9);
        var_10 = wp::quat_rotate(var_5, var_11);
        var_12 = wp::add(var_4, var_10);
        // cable_rot = wp.normalize(wp.mul(plug_rot, anchor_rotations[tid]))                      <L 136>
        var_13 = wp::address(var_anchor_rotations, var_0);
        var_15 = wp::load(var_13);
        var_14 = wp::mul(var_5, var_15);
        var_16 = wp::normalize(var_14);
        // body_q[idx] = wp.transform(anchor_world, cable_rot)                                    <L 137>
        var_17 = wp::transform_t<wp::float32>(var_12, var_16);
        wp::array_store(var_body_q, var_7, var_17);
        // body_qd[idx] = wp.spatial_vector(0.0, 0.0, 0.0, 0.0, 0.0, 0.0)                         <L 138>
        var_24 = wp::vec_t<6, wp::float32>({var_18, var_19, var_20, var_21, var_22, var_23});
        wp::array_store(var_body_qd, var_7, var_24);
    }
}



extern "C" __global__ void _sync_cable_anchors_bc812dd1_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::vec_t<6, wp::float32>> var_body_qd,
    wp::int32 var_plug_idx,
    wp::array_t<wp::int32> var_anchor_indices,
    wp::array_t<wp::vec_t<3, wp::float32>> var_anchor_offsets,
    wp::array_t<wp::quat_t<wp::float32>> var_anchor_rotations,
    wp::array_t<wp::transform_t<wp::float32>> adj_body_q,
    wp::array_t<wp::vec_t<6, wp::float32>> adj_body_qd,
    wp::int32 adj_plug_idx,
    wp::array_t<wp::int32> adj_anchor_indices,
    wp::array_t<wp::vec_t<3, wp::float32>> adj_anchor_offsets,
    wp::array_t<wp::quat_t<wp::float32>> adj_anchor_rotations)
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
        wp::vec_t<3, wp::float32> var_4;
        wp::quat_t<wp::float32> var_5;
        wp::int32* var_6;
        wp::int32 var_7;
        wp::int32 var_8;
        wp::vec_t<3, wp::float32>* var_9;
        wp::vec_t<3, wp::float32> var_10;
        wp::vec_t<3, wp::float32> var_11;
        wp::vec_t<3, wp::float32> var_12;
        wp::quat_t<wp::float32>* var_13;
        wp::quat_t<wp::float32> var_14;
        wp::quat_t<wp::float32> var_15;
        wp::quat_t<wp::float32> var_16;
        wp::transform_t<wp::float32> var_17;
        const wp::float32 var_18 = 0.0;
        const wp::float32 var_19 = 0.0;
        const wp::float32 var_20 = 0.0;
        const wp::float32 var_21 = 0.0;
        const wp::float32 var_22 = 0.0;
        const wp::float32 var_23 = 0.0;
        wp::vec_t<6, wp::float32> var_24;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::transform_t<wp::float32> adj_1 = {};
        wp::transform_t<wp::float32> adj_2 = {};
        wp::transform_t<wp::float32> adj_3 = {};
        wp::vec_t<3, wp::float32> adj_4 = {};
        wp::quat_t<wp::float32> adj_5 = {};
        wp::int32 adj_6 = {};
        wp::int32 adj_7 = {};
        wp::int32 adj_8 = {};
        wp::vec_t<3, wp::float32> adj_9 = {};
        wp::vec_t<3, wp::float32> adj_10 = {};
        wp::vec_t<3, wp::float32> adj_11 = {};
        wp::vec_t<3, wp::float32> adj_12 = {};
        wp::quat_t<wp::float32> adj_13 = {};
        wp::quat_t<wp::float32> adj_14 = {};
        wp::quat_t<wp::float32> adj_15 = {};
        wp::quat_t<wp::float32> adj_16 = {};
        wp::transform_t<wp::float32> adj_17 = {};
        wp::float32 adj_18 = {};
        wp::float32 adj_19 = {};
        wp::float32 adj_20 = {};
        wp::float32 adj_21 = {};
        wp::float32 adj_22 = {};
        wp::float32 adj_23 = {};
        wp::vec_t<6, wp::float32> adj_24 = {};
        //---------
        // forward
        // def _sync_cable_anchors(                                                               <L 121>
        // tid = wp.tid()                                                                         <L 130>
        var_0 = builtin_tid1d();
        // plug_tf = body_q[plug_idx]                                                             <L 131>
        var_1 = wp::address(var_body_q, var_plug_idx);
        var_3 = wp::load(var_1);
        var_2 = wp::copy(var_3);
        // plug_pos = wp.transform_get_translation(plug_tf)                                       <L 132>
        var_4 = wp::transform_get_translation(var_2);
        // plug_rot = wp.transform_get_rotation(plug_tf)                                          <L 133>
        var_5 = wp::transform_get_rotation(var_2);
        // idx = anchor_indices[tid]                                                              <L 134>
        var_6 = wp::address(var_anchor_indices, var_0);
        var_8 = wp::load(var_6);
        var_7 = wp::copy(var_8);
        // anchor_world = plug_pos + wp.quat_rotate(plug_rot, anchor_offsets[tid])                <L 135>
        var_9 = wp::address(var_anchor_offsets, var_0);
        var_11 = wp::load(var_9);
        var_10 = wp::quat_rotate(var_5, var_11);
        var_12 = wp::add(var_4, var_10);
        // cable_rot = wp.normalize(wp.mul(plug_rot, anchor_rotations[tid]))                      <L 136>
        var_13 = wp::address(var_anchor_rotations, var_0);
        var_15 = wp::load(var_13);
        var_14 = wp::mul(var_5, var_15);
        var_16 = wp::normalize(var_14);
        // body_q[idx] = wp.transform(anchor_world, cable_rot)                                    <L 137>
        var_17 = wp::transform_t<wp::float32>(var_12, var_16);
        // wp::array_store(var_body_q, var_7, var_17);
        // body_qd[idx] = wp.spatial_vector(0.0, 0.0, 0.0, 0.0, 0.0, 0.0)                         <L 138>
        var_24 = wp::vec_t<6, wp::float32>({var_18, var_19, var_20, var_21, var_22, var_23});
        // wp::array_store(var_body_qd, var_7, var_24);
        //---------
        // reverse
        wp::adj_array_store(var_body_qd, var_7, var_24, adj_body_qd, adj_7, adj_24);
        wp::adj_vec_t({var_18, var_19, var_20, var_21, var_22, var_23}, {&adj_18, &adj_19, &adj_20, &adj_21, &adj_22, &adj_23}, adj_24);
        // adj: body_qd[idx] = wp.spatial_vector(0.0, 0.0, 0.0, 0.0, 0.0, 0.0)                    <L 138>
        wp::adj_array_store(var_body_q, var_7, var_17, adj_body_q, adj_7, adj_17);
        wp::adj_transform_t(var_12, var_16, adj_12, adj_16, adj_17);
        // adj: body_q[idx] = wp.transform(anchor_world, cable_rot)                               <L 137>
        wp::adj_normalize(var_14, adj_14, adj_16);
        wp::adj_mul(var_5, var_15, adj_5, adj_13, adj_14);
        wp::adj_address(var_anchor_rotations, var_0, adj_anchor_rotations, adj_0, adj_13);
        // adj: cable_rot = wp.normalize(wp.mul(plug_rot, anchor_rotations[tid]))                 <L 136>
        wp::adj_add(var_4, var_10, adj_4, adj_10, adj_12);
        wp::adj_quat_rotate(var_5, var_11, adj_5, adj_9, adj_10);
        wp::adj_address(var_anchor_offsets, var_0, adj_anchor_offsets, adj_0, adj_9);
        // adj: anchor_world = plug_pos + wp.quat_rotate(plug_rot, anchor_offsets[tid])           <L 135>
        wp::adj_copy(var_8, adj_6, adj_7);
        wp::adj_address(var_anchor_indices, var_0, adj_anchor_indices, adj_0, adj_6);
        // adj: idx = anchor_indices[tid]                                                         <L 134>
        wp::adj_transform_get_rotation(var_2, adj_2, adj_5);
        // adj: plug_rot = wp.transform_get_rotation(plug_tf)                                     <L 133>
        wp::adj_transform_get_translation(var_2, adj_2, adj_4);
        // adj: plug_pos = wp.transform_get_translation(plug_tf)                                  <L 132>
        wp::adj_copy(var_3, adj_1, adj_2);
        wp::adj_address(var_body_q, var_plug_idx, adj_body_q, adj_plug_idx, adj_1);
        // adj: plug_tf = body_q[plug_idx]                                                        <L 131>
        // adj: tid = wp.tid()                                                                    <L 130>
        // adj: def _sync_cable_anchors(                                                          <L 121>
        continue;
    }
}

