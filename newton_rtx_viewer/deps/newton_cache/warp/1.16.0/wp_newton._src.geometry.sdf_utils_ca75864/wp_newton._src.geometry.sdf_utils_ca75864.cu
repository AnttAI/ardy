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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_mc.py:105
static CUDA_CALLABLE wp::vec_t<3, wp::float32> int_to_vec3f_0(
    wp::int32 var_x,
    wp::int32 var_y,
    wp::int32 var_z)
{
    //---------
    // primal vars
    wp::float32 var_0;
    wp::float32 var_1;
    wp::float32 var_2;
    wp::vec_t<3, wp::float32> var_3;
    //---------
    // forward
    // def int_to_vec3f(x: wp.int32, y: wp.int32, z: wp.int32):                               <L 106>
    // return wp.vec3f(float(x), float(y), float(z))                                          <L 108>
    var_0 = wp::float(var_x);
    var_1 = wp::float(var_y);
    var_2 = wp::float(var_z);
    var_3 = wp::vec_t<3, wp::float32>(var_0, var_1, var_2);
    return var_3;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_utils.py:651
static CUDA_CALLABLE wp::float32 get_distance_to_mesh_0(
    wp::uint64 var_mesh,
    wp::vec_t<3, wp::float32> var_point,
    wp::float32 var_max_dist,
    wp::float32 var_winding_threshold)
{
    //---------
    // primal vars
    const wp::float32 var_0 = 2.0;
    wp::mesh_query_point_t var_1;
    bool* var_2;
    bool var_3;
    wp::int32* var_4;
    wp::float32* var_5;
    wp::float32* var_6;
    wp::vec_t<3, wp::float32> var_7;
    wp::int32 var_8;
    wp::float32 var_9;
    wp::float32 var_10;
    wp::vec_t<3, wp::float32> var_11;
    wp::float32* var_12;
    wp::float32 var_13;
    wp::float32 var_14;
    const wp::float32 var_15 = 0.0;
    bool var_16;
    wp::float32 var_17;
    wp::float32 var_18;
    wp::float32 var_19;
    wp::float32 var_20;
    bool var_21;
    //---------
    // forward
    // def get_distance_to_mesh(mesh: wp.uint64, point: wp.vec3, max_dist: wp.float32, winding_threshold: wp.float32):       <L 652>
    // res = wp.mesh_query_point_sign_winding_number(mesh, point, max_dist, 2.0, winding_threshold)       <L 653>
    var_1 = wp::mesh_query_point_sign_winding_number(var_mesh, var_point, var_max_dist, var_0, var_winding_threshold);
    // if res.result:                                                                         <L 654>
    var_2 = &((var_1).result);
    var_3 = wp::load(var_2);
    if (var_3) {
        // closest = wp.mesh_eval_position(mesh, res.face, res.u, res.v)                      <L 655>
        var_4 = &((var_1).face);
        var_5 = &((var_1).u);
        var_6 = &((var_1).v);
        var_8 = wp::load(var_4);
        var_9 = wp::load(var_5);
        var_10 = wp::load(var_6);
        var_7 = wp::mesh_eval_position(var_mesh, var_8, var_9, var_10);
        // vec_to_surface = closest - point                                                   <L 656>
        var_11 = wp::sub(var_7, var_point);
        // sign = res.sign                                                                    <L 657>
        var_12 = &((var_1).sign);
        var_14 = wp::load(var_12);
        var_13 = wp::copy(var_14);
        // if winding_threshold < 0.0:                                                        <L 660>
        var_16 = (var_winding_threshold < var_15);
        if (var_16) {
            // sign = -sign                                                                   <L 661>
            var_17 = wp::neg(var_13);
        }
        var_18 = wp::where(var_16, var_17, var_13);
        // return sign * wp.length(vec_to_surface)                                            <L 662>
        var_19 = wp::length(var_11);
        var_20 = wp::mul(var_18, var_19);
        return var_20;
    }
    var_21 = wp::load(var_2);
    // return max_dist                                                                        <L 663>
    return var_max_dist;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/kernels.py:180
static CUDA_CALLABLE wp::float32 sdf_sphere_0(
    wp::vec_t<3, wp::float32> var_point,
    wp::float32 var_radius)
{
    //---------
    // primal vars
    wp::float32 var_0;
    wp::float32 var_1;
    //---------
    // forward
    // def sdf_sphere(point: wp.vec3, radius: float):                                         <L 181>
    // return wp.length(point) - radius                                                       <L 191>
    var_0 = wp::length(var_point);
    var_1 = wp::sub(var_0, var_radius);
    return var_1;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/kernels.py:213
static CUDA_CALLABLE wp::float32 sdf_box_0(
    wp::vec_t<3, wp::float32> var_point,
    wp::float32 var_hx,
    wp::float32 var_hy,
    wp::float32 var_hz)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    wp::float32 var_1;
    wp::float32 var_2;
    wp::float32 var_3;
    const wp::int32 var_4 = 1;
    wp::float32 var_5;
    wp::float32 var_6;
    wp::float32 var_7;
    const wp::int32 var_8 = 2;
    wp::float32 var_9;
    wp::float32 var_10;
    wp::float32 var_11;
    const wp::float32 var_12 = 0.0;
    wp::float32 var_13;
    const wp::float32 var_14 = 0.0;
    wp::float32 var_15;
    const wp::float32 var_16 = 0.0;
    wp::float32 var_17;
    wp::vec_t<3, wp::float32> var_18;
    wp::float32 var_19;
    wp::float32 var_20;
    wp::float32 var_21;
    const wp::float32 var_22 = 0.0;
    wp::float32 var_23;
    wp::float32 var_24;
    //---------
    // forward
    // def sdf_box(point: wp.vec3, hx: float, hy: float, hz: float):                          <L 214>
    // qx = abs(point[0]) - hx                                                                <L 227>
    var_1 = wp::extract(var_point, var_0);
    var_2 = wp::abs(var_1);
    var_3 = wp::sub(var_2, var_hx);
    // qy = abs(point[1]) - hy                                                                <L 228>
    var_5 = wp::extract(var_point, var_4);
    var_6 = wp::abs(var_5);
    var_7 = wp::sub(var_6, var_hy);
    // qz = abs(point[2]) - hz                                                                <L 229>
    var_9 = wp::extract(var_point, var_8);
    var_10 = wp::abs(var_9);
    var_11 = wp::sub(var_10, var_hz);
    // e = wp.vec3(wp.max(qx, 0.0), wp.max(qy, 0.0), wp.max(qz, 0.0))                         <L 231>
    var_13 = wp::max(var_3, var_12);
    var_15 = wp::max(var_7, var_14);
    var_17 = wp::max(var_11, var_16);
    var_18 = wp::vec_t<3, wp::float32>(var_13, var_15, var_17);
    // return wp.length(e) + wp.min(wp.max(qx, wp.max(qy, qz)), 0.0)                          <L 233>
    var_19 = wp::length(var_18);
    var_20 = wp::max(var_7, var_11);
    var_21 = wp::max(var_3, var_20);
    var_23 = wp::min(var_21, var_22);
    var_24 = wp::add(var_19, var_23);
    return var_24;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/kernels.py:147
static CUDA_CALLABLE wp::vec_t<3, wp::float32> _sdf_point_to_z_up_0(
    wp::vec_t<3, wp::float32> var_point,
    wp::int32 var_up_axis)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    const wp::int32 var_1 = 0;
    wp::int32 var_2;
    bool var_3;
    const wp::int32 var_4 = 1;
    wp::float32 var_5;
    const wp::int32 var_6 = 2;
    wp::float32 var_7;
    const wp::int32 var_8 = 0;
    wp::float32 var_9;
    wp::vec_t<3, wp::float32> var_10;
    const wp::int32 var_11 = 1;
    const wp::int32 var_12 = 1;
    wp::int32 var_13;
    bool var_14;
    const wp::int32 var_15 = 0;
    wp::float32 var_16;
    const wp::int32 var_17 = 2;
    wp::float32 var_18;
    const wp::int32 var_19 = 1;
    wp::float32 var_20;
    wp::vec_t<3, wp::float32> var_21;
    //---------
    // forward
    // def _sdf_point_to_z_up(point: wp.vec3, up_axis: int):                                  <L 148>
    // if up_axis == int(Axis.X):                                                             <L 149>
    var_2 = wp::int(var_1);
    var_3 = (var_up_axis == var_2);
    if (var_3) {
        // return wp.vec3(point[1], point[2], point[0])                                       <L 150>
        var_5 = wp::extract(var_point, var_4);
        var_7 = wp::extract(var_point, var_6);
        var_9 = wp::extract(var_point, var_8);
        var_10 = wp::vec_t<3, wp::float32>(var_5, var_7, var_9);
        return var_10;
    }
    // if up_axis == int(Axis.Y):                                                             <L 151>
    var_13 = wp::int(var_12);
    var_14 = (var_up_axis == var_13);
    if (var_14) {
        // return wp.vec3(point[0], point[2], point[1])                                       <L 152>
        var_16 = wp::extract(var_point, var_15);
        var_18 = wp::extract(var_point, var_17);
        var_20 = wp::extract(var_point, var_19);
        var_21 = wp::vec_t<3, wp::float32>(var_16, var_18, var_20);
        return var_21;
    }
    // return point                                                                           <L 153>
    return var_point;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/kernels.py:277
static CUDA_CALLABLE wp::float32 sdf_capsule_0(
    wp::vec_t<3, wp::float32> var_point,
    wp::float32 var_radius,
    wp::float32 var_half_height,
    wp::int32 var_up_axis)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    const wp::int32 var_1 = 2;
    wp::float32 var_2;
    bool var_3;
    const wp::int32 var_4 = 0;
    wp::float32 var_5;
    const wp::int32 var_6 = 1;
    wp::float32 var_7;
    const wp::int32 var_8 = 2;
    wp::float32 var_9;
    wp::float32 var_10;
    wp::vec_t<3, wp::float32> var_11;
    wp::float32 var_12;
    wp::float32 var_13;
    const wp::int32 var_14 = 2;
    wp::float32 var_15;
    wp::float32 var_16;
    bool var_17;
    const wp::int32 var_18 = 0;
    wp::float32 var_19;
    const wp::int32 var_20 = 1;
    wp::float32 var_21;
    const wp::int32 var_22 = 2;
    wp::float32 var_23;
    wp::float32 var_24;
    wp::vec_t<3, wp::float32> var_25;
    wp::float32 var_26;
    wp::float32 var_27;
    const wp::int32 var_28 = 0;
    wp::float32 var_29;
    const wp::int32 var_30 = 1;
    wp::float32 var_31;
    const wp::float32 var_32 = 0.0;
    wp::vec_t<3, wp::float32> var_33;
    wp::float32 var_34;
    wp::float32 var_35;
    //---------
    // forward
    // def sdf_capsule(point: wp.vec3, radius: float, half_height: float, up_axis: int = int(Axis.Y)):       <L 278>
    // point_z_up = _sdf_point_to_z_up(point, up_axis)                                        <L 290>
    var_0 = _sdf_point_to_z_up_0(var_point, var_up_axis);
    // if point_z_up[2] > half_height:                                                        <L 291>
    var_2 = wp::extract(var_0, var_1);
    var_3 = (var_2 > var_half_height);
    if (var_3) {
        // return wp.length(wp.vec3(point_z_up[0], point_z_up[1], point_z_up[2] - half_height)) - radius       <L 292>
        var_5 = wp::extract(var_0, var_4);
        var_7 = wp::extract(var_0, var_6);
        var_9 = wp::extract(var_0, var_8);
        var_10 = wp::sub(var_9, var_half_height);
        var_11 = wp::vec_t<3, wp::float32>(var_5, var_7, var_10);
        var_12 = wp::length(var_11);
        var_13 = wp::sub(var_12, var_radius);
        return var_13;
    }
    // if point_z_up[2] < -half_height:                                                       <L 294>
    var_15 = wp::extract(var_0, var_14);
    var_16 = wp::neg(var_half_height);
    var_17 = (var_15 < var_16);
    if (var_17) {
        // return wp.length(wp.vec3(point_z_up[0], point_z_up[1], point_z_up[2] + half_height)) - radius       <L 295>
        var_19 = wp::extract(var_0, var_18);
        var_21 = wp::extract(var_0, var_20);
        var_23 = wp::extract(var_0, var_22);
        var_24 = wp::add(var_23, var_half_height);
        var_25 = wp::vec_t<3, wp::float32>(var_19, var_21, var_24);
        var_26 = wp::length(var_25);
        var_27 = wp::sub(var_26, var_radius);
        return var_27;
    }
    // return wp.length(wp.vec3(point_z_up[0], point_z_up[1], 0.0)) - radius                  <L 297>
    var_29 = wp::extract(var_0, var_28);
    var_31 = wp::extract(var_0, var_30);
    var_33 = wp::vec_t<3, wp::float32>(var_29, var_31, var_32);
    var_34 = wp::length(var_33);
    var_35 = wp::sub(var_34, var_radius);
    return var_35;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/kernels.py:156
static CUDA_CALLABLE wp::float32 _sdf_capped_cone_z_0(
    wp::float32 var_bottom_radius,
    wp::float32 var_top_radius,
    wp::float32 var_half_height,
    wp::vec_t<3, wp::float32> var_point_z_up)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    wp::float32 var_1;
    const wp::int32 var_2 = 1;
    wp::float32 var_3;
    wp::vec_t<2, wp::float32> var_4;
    wp::float32 var_5;
    const wp::int32 var_6 = 2;
    wp::float32 var_7;
    wp::vec_t<2, wp::float32> var_8;
    wp::vec_t<2, wp::float32> var_9;
    wp::float32 var_10;
    const wp::float32 var_11 = 2.0;
    wp::float32 var_12;
    wp::vec_t<2, wp::float32> var_13;
    const wp::int32 var_14 = 1;
    wp::float32 var_15;
    const wp::float32 var_16 = 0.0;
    bool var_17;
    const wp::int32 var_18 = 0;
    wp::float32 var_19;
    const wp::int32 var_20 = 0;
    wp::float32 var_21;
    wp::float32 var_22;
    wp::float32 var_23;
    const wp::int32 var_24 = 1;
    wp::float32 var_25;
    wp::float32 var_26;
    wp::float32 var_27;
    wp::vec_t<2, wp::float32> var_28;
    const wp::int32 var_29 = 0;
    wp::float32 var_30;
    const wp::int32 var_31 = 0;
    wp::float32 var_32;
    wp::float32 var_33;
    wp::float32 var_34;
    const wp::int32 var_35 = 1;
    wp::float32 var_36;
    wp::float32 var_37;
    wp::float32 var_38;
    wp::vec_t<2, wp::float32> var_39;
    wp::vec_t<2, wp::float32> var_40;
    wp::float32 var_41;
    const wp::float32 var_42 = 0.0;
    const wp::float32 var_43 = 0.0;
    bool var_44;
    wp::vec_t<2, wp::float32> var_45;
    wp::float32 var_46;
    wp::float32 var_47;
    const wp::float32 var_48 = 0.0;
    const wp::float32 var_49 = 1.0;
    wp::float32 var_50;
    wp::float32 var_51;
    wp::vec_t<2, wp::float32> var_52;
    wp::vec_t<2, wp::float32> var_53;
    wp::vec_t<2, wp::float32> var_54;
    const wp::float32 var_55 = 1.0;
    bool var_56;
    const wp::int32 var_57 = 0;
    wp::float32 var_58;
    const wp::float32 var_59 = 0.0;
    bool var_60;
    const wp::int32 var_61 = 1;
    wp::float32 var_62;
    const wp::float32 var_63 = 0.0;
    bool var_64;
    const wp::float32 var_65 = -1.0;
    wp::float32 var_66;
    wp::float32 var_67;
    wp::float32 var_68;
    wp::float32 var_69;
    wp::float32 var_70;
    wp::float32 var_71;
    //---------
    // forward
    // def _sdf_capped_cone_z(bottom_radius: float, top_radius: float, half_height: float, point_z_up: wp.vec3):       <L 157>
    // q = wp.vec2(wp.length(wp.vec2(point_z_up[0], point_z_up[1])), point_z_up[2])           <L 158>
    var_1 = wp::extract(var_point_z_up, var_0);
    var_3 = wp::extract(var_point_z_up, var_2);
    var_4 = wp::vec_t<2, wp::float32>(var_1, var_3);
    var_5 = wp::length(var_4);
    var_7 = wp::extract(var_point_z_up, var_6);
    var_8 = wp::vec_t<2, wp::float32>(var_5, var_7);
    // k1 = wp.vec2(top_radius, half_height)                                                  <L 159>
    var_9 = wp::vec_t<2, wp::float32>(var_top_radius, var_half_height);
    // k2 = wp.vec2(top_radius - bottom_radius, 2.0 * half_height)                            <L 160>
    var_10 = wp::sub(var_top_radius, var_bottom_radius);
    var_12 = wp::mul(var_11, var_half_height);
    var_13 = wp::vec_t<2, wp::float32>(var_10, var_12);
    // if q[1] < 0.0:                                                                         <L 162>
    var_15 = wp::extract(var_8, var_14);
    var_17 = (var_15 < var_16);
    if (var_17) {
        // ca = wp.vec2(q[0] - wp.min(q[0], bottom_radius), wp.abs(q[1]) - half_height)       <L 163>
        var_19 = wp::extract(var_8, var_18);
        var_21 = wp::extract(var_8, var_20);
        var_22 = wp::min(var_21, var_bottom_radius);
        var_23 = wp::sub(var_19, var_22);
        var_25 = wp::extract(var_8, var_24);
        var_26 = wp::abs(var_25);
        var_27 = wp::sub(var_26, var_half_height);
        var_28 = wp::vec_t<2, wp::float32>(var_23, var_27);
    }
    if (!var_17) {
        // ca = wp.vec2(q[0] - wp.min(q[0], top_radius), wp.abs(q[1]) - half_height)          <L 165>
        var_30 = wp::extract(var_8, var_29);
        var_32 = wp::extract(var_8, var_31);
        var_33 = wp::min(var_32, var_top_radius);
        var_34 = wp::sub(var_30, var_33);
        var_36 = wp::extract(var_8, var_35);
        var_37 = wp::abs(var_36);
        var_38 = wp::sub(var_37, var_half_height);
        var_39 = wp::vec_t<2, wp::float32>(var_34, var_38);
    }
    var_40 = wp::where(var_17, var_28, var_39);
    // denom = wp.dot(k2, k2)                                                                 <L 167>
    var_41 = wp::dot(var_13, var_13);
    // t = 0.0                                                                                <L 168>
    // if denom > 0.0:                                                                        <L 169>
    var_44 = (var_41 > var_43);
    if (var_44) {
        // t = wp.clamp(wp.dot(k1 - q, k2) / denom, 0.0, 1.0)                                 <L 170>
        var_45 = wp::sub(var_9, var_8);
        var_46 = wp::dot(var_45, var_13);
        var_47 = wp::div(var_46, var_41);
        var_50 = wp::clamp(var_47, var_48, var_49);
    }
    var_51 = wp::where(var_44, var_50, var_42);
    // cb = q - k1 + k2 * t                                                                   <L 171>
    var_52 = wp::sub(var_8, var_9);
    var_53 = wp::mul(var_13, var_51);
    var_54 = wp::add(var_52, var_53);
    // sign = 1.0                                                                             <L 173>
    // if cb[0] < 0.0 and ca[1] < 0.0:                                                        <L 174>
    var_58 = wp::extract(var_54, var_57);
    var_60 = (var_58 < var_59);
    var_56 = var_60;
    if (var_56) {
        var_62 = wp::extract(var_40, var_61);
        var_64 = (var_62 < var_63);
        var_56 = var_56 && var_64;
    }
    if (var_56) {
        // sign = -1.0                                                                        <L 175>
    }
    var_66 = wp::where(var_56, var_65, var_55);
    // return sign * wp.sqrt(wp.min(wp.dot(ca, ca), wp.dot(cb, cb)))                          <L 177>
    var_67 = wp::dot(var_40, var_40);
    var_68 = wp::dot(var_54, var_54);
    var_69 = wp::min(var_67, var_68);
    var_70 = wp::sqrt(var_69);
    var_71 = wp::mul(var_66, var_70);
    return var_71;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/kernels.py:347
static CUDA_CALLABLE wp::float32 sdf_cylinder_0(
    wp::vec_t<3, wp::float32> var_point,
    wp::float32 var_radius,
    wp::float32 var_half_height,
    wp::int32 var_up_axis,
    wp::float32 var_top_radius)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    bool var_1;
    const wp::float32 var_2 = 0.0;
    bool var_3;
    wp::float32 var_4;
    wp::float32 var_5;
    const wp::float32 var_6 = 1e-06;
    bool var_7;
    const wp::int32 var_8 = 0;
    wp::float32 var_9;
    const wp::int32 var_10 = 1;
    wp::float32 var_11;
    const wp::float32 var_12 = 0.0;
    wp::vec_t<3, wp::float32> var_13;
    wp::float32 var_14;
    wp::float32 var_15;
    const wp::int32 var_16 = 2;
    wp::float32 var_17;
    wp::float32 var_18;
    wp::float32 var_19;
    wp::float32 var_20;
    const wp::float32 var_21 = 0.0;
    wp::float32 var_22;
    const wp::float32 var_23 = 0.0;
    wp::float32 var_24;
    const wp::float32 var_25 = 0.0;
    wp::float32 var_26;
    wp::vec_t<2, wp::float32> var_27;
    wp::float32 var_28;
    wp::float32 var_29;
    wp::float32 var_30;
    //---------
    // forward
    // def sdf_cylinder(                                                                      <L 348>
    // point_z_up = _sdf_point_to_z_up(point, up_axis)                                        <L 367>
    var_0 = _sdf_point_to_z_up_0(var_point, var_up_axis);
    // if top_radius < 0.0 or wp.abs(top_radius - radius) <= 1.0e-6:                          <L 368>
    var_3 = (var_top_radius < var_2);
    var_1 = var_3;
    if (!var_1) {
        var_4 = wp::sub(var_top_radius, var_radius);
        var_5 = wp::abs(var_4);
        var_7 = (var_5 <= var_6);
        var_1 = var_1 || var_7;
    }
    if (var_1) {
        // dx = wp.length(wp.vec3(point_z_up[0], point_z_up[1], 0.0)) - radius                <L 369>
        var_9 = wp::extract(var_0, var_8);
        var_11 = wp::extract(var_0, var_10);
        var_13 = wp::vec_t<3, wp::float32>(var_9, var_11, var_12);
        var_14 = wp::length(var_13);
        var_15 = wp::sub(var_14, var_radius);
        // dy = wp.abs(point_z_up[2]) - half_height                                           <L 370>
        var_17 = wp::extract(var_0, var_16);
        var_18 = wp::abs(var_17);
        var_19 = wp::sub(var_18, var_half_height);
        // return wp.min(wp.max(dx, dy), 0.0) + wp.length(wp.vec2(wp.max(dx, 0.0), wp.max(dy, 0.0)))       <L 371>
        var_20 = wp::max(var_15, var_19);
        var_22 = wp::min(var_20, var_21);
        var_24 = wp::max(var_15, var_23);
        var_26 = wp::max(var_19, var_25);
        var_27 = wp::vec_t<2, wp::float32>(var_24, var_26);
        var_28 = wp::length(var_27);
        var_29 = wp::add(var_22, var_28);
        return var_29;
    }
    // return _sdf_capped_cone_z(radius, top_radius, half_height, point_z_up)                 <L 372>
    var_30 = _sdf_capped_cone_z_0(var_radius, var_top_radius, var_half_height, var_0);
    return var_30;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/kernels.py:464
static CUDA_CALLABLE wp::float32 sdf_ellipsoid_0(
    wp::vec_t<3, wp::float32> var_point,
    wp::vec_t<3, wp::float32> var_radii)
{
    //---------
    // primal vars
    const wp::float32 var_0 = 1e-08;
    const wp::int32 var_1 = 0;
    wp::float32 var_2;
    wp::float32 var_3;
    wp::float32 var_4;
    const wp::int32 var_5 = 1;
    wp::float32 var_6;
    wp::float32 var_7;
    wp::float32 var_8;
    const wp::int32 var_9 = 2;
    wp::float32 var_10;
    wp::float32 var_11;
    wp::float32 var_12;
    wp::vec_t<3, wp::float32> var_13;
    const wp::float32 var_14 = 1.0;
    const wp::float32 var_15 = 1.0;
    const wp::float32 var_16 = 1.0;
    wp::vec_t<3, wp::float32> var_17;
    wp::vec_t<3, wp::float32> var_18;
    wp::vec_t<3, wp::float32> var_19;
    wp::vec_t<3, wp::float32> var_20;
    wp::vec_t<3, wp::float32> var_21;
    wp::float32 var_22;
    wp::float32 var_23;
    bool var_24;
    const wp::float32 var_25 = 1.0;
    wp::float32 var_26;
    wp::float32 var_27;
    wp::float32 var_28;
    const wp::int32 var_29 = 0;
    wp::float32 var_30;
    const wp::int32 var_31 = 1;
    wp::float32 var_32;
    wp::float32 var_33;
    const wp::int32 var_34 = 2;
    wp::float32 var_35;
    wp::float32 var_36;
    wp::float32 var_37;
    //---------
    // forward
    // def sdf_ellipsoid(point: wp.vec3, radii: wp.vec3):                                     <L 465>
    // eps = 1.0e-8                                                                           <L 477>
    // r = wp.vec3(                                                                           <L 478>
    // wp.max(wp.abs(radii[0]), eps),                                                         <L 479>
    var_2 = wp::extract(var_radii, var_1);
    var_3 = wp::abs(var_2);
    var_4 = wp::max(var_3, var_0);
    // wp.max(wp.abs(radii[1]), eps),                                                         <L 480>
    var_6 = wp::extract(var_radii, var_5);
    var_7 = wp::abs(var_6);
    var_8 = wp::max(var_7, var_0);
    // wp.max(wp.abs(radii[2]), eps),                                                         <L 481>
    var_10 = wp::extract(var_radii, var_9);
    var_11 = wp::abs(var_10);
    var_12 = wp::max(var_11, var_0);
    var_13 = wp::vec_t<3, wp::float32>(var_4, var_8, var_12);
    // inv_r = wp.cw_div(wp.vec3(1.0, 1.0, 1.0), r)                                           <L 483>
    var_17 = wp::vec_t<3, wp::float32>(var_14, var_15, var_16);
    var_18 = wp::cw_div(var_17, var_13);
    // inv_r2 = wp.cw_mul(inv_r, inv_r)                                                       <L 484>
    var_19 = wp::cw_mul(var_18, var_18);
    // q0 = wp.cw_mul(point, inv_r)  # p / r                                                  <L 485>
    var_20 = wp::cw_mul(var_point, var_18);
    // q1 = wp.cw_mul(point, inv_r2)  # p / r^2                                               <L 486>
    var_21 = wp::cw_mul(var_point, var_19);
    // k0 = wp.length(q0)                                                                     <L 487>
    var_22 = wp::length(var_20);
    // k1 = wp.length(q1)                                                                     <L 488>
    var_23 = wp::length(var_21);
    // if k1 > eps:                                                                           <L 489>
    var_24 = (var_23 > var_0);
    if (var_24) {
        // return k0 * (k0 - 1.0) / k1                                                        <L 490>
        var_26 = wp::sub(var_22, var_25);
        var_27 = wp::mul(var_22, var_26);
        var_28 = wp::div(var_27, var_23);
        return var_28;
    }
    // return -wp.min(wp.min(r[0], r[1]), r[2])                                               <L 492>
    var_30 = wp::extract(var_13, var_29);
    var_32 = wp::extract(var_13, var_31);
    var_33 = wp::min(var_30, var_32);
    var_35 = wp::extract(var_13, var_34);
    var_36 = wp::min(var_33, var_35);
    var_37 = wp::neg(var_36);
    return var_37;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/kernels.py:530
static CUDA_CALLABLE wp::float32 sdf_cone_0(
    wp::vec_t<3, wp::float32> var_point,
    wp::float32 var_radius,
    wp::float32 var_half_height,
    wp::int32 var_up_axis)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    const wp::float32 var_1 = 0.0;
    wp::float32 var_2;
    //---------
    // forward
    // def sdf_cone(point: wp.vec3, radius: float, half_height: float, up_axis: int = int(Axis.Y)):       <L 531>
    // point_z_up = _sdf_point_to_z_up(point, up_axis)                                        <L 543>
    var_0 = _sdf_point_to_z_up_0(var_point, var_up_axis);
    // return _sdf_capped_cone_z(radius, 0.0, half_height, point_z_up)                        <L 544>
    var_2 = _sdf_capped_cone_z_0(var_radius, var_1, var_half_height, var_0);
    return var_2;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_mc.py:111
static CUDA_CALLABLE wp::float32 get_triangle_fraction_0(
    wp::vec_t<3, wp::float32> var_vert_depths,
    wp::int32 var_num_inside)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 3;
    bool var_1;
    const wp::float32 var_2 = 1.0;
    const wp::int32 var_3 = 0;
    bool var_4;
    const wp::float32 var_5 = 0.0;
    const wp::int32 var_6 = 0;
    wp::int32 var_7;
    const wp::int32 var_8 = 1;
    bool var_9;
    const wp::int32 var_10 = 1;
    wp::float32 var_11;
    const wp::float32 var_12 = 0.0;
    bool var_13;
    const wp::int32 var_14 = 1;
    const wp::int32 var_15 = 2;
    wp::float32 var_16;
    const wp::float32 var_17 = 0.0;
    bool var_18;
    const wp::int32 var_19 = 2;
    wp::int32 var_20;
    wp::int32 var_21;
    const wp::int32 var_22 = 1;
    wp::float32 var_23;
    const wp::float32 var_24 = 0.0;
    bool var_25;
    const wp::int32 var_26 = 1;
    const wp::int32 var_27 = 2;
    wp::float32 var_28;
    const wp::float32 var_29 = 0.0;
    bool var_30;
    const wp::int32 var_31 = 2;
    wp::int32 var_32;
    wp::int32 var_33;
    wp::int32 var_34;
    wp::float32 var_35;
    const wp::int32 var_36 = 1;
    wp::int32 var_37;
    const wp::int32 var_38 = 3;
    wp::int32 var_39;
    wp::float32 var_40;
    const wp::int32 var_41 = 2;
    wp::int32 var_42;
    const wp::int32 var_43 = 3;
    wp::int32 var_44;
    wp::float32 var_45;
    wp::float32 var_46;
    wp::float32 var_47;
    wp::float32 var_48;
    const wp::float32 var_49 = 1e-08;
    wp::float32 var_50;
    wp::float32 var_51;
    bool var_52;
    const wp::int32 var_53 = 1;
    bool var_54;
    const wp::float32 var_55 = 0.0;
    const wp::float32 var_56 = 1.0;
    wp::float32 var_57;
    wp::float32 var_58;
    const wp::float32 var_59 = 0.0;
    const wp::float32 var_60 = 1.0;
    wp::float32 var_61;
    const wp::int32 var_62 = 2;
    bool var_63;
    const wp::float32 var_64 = 1.0;
    wp::float32 var_65;
    //---------
    // forward
    // def get_triangle_fraction(vert_depths: wp.vec3f, num_inside: wp.int32) -> wp.float32:       <L 112>
    // if num_inside == 3:                                                                    <L 119>
    var_1 = (var_num_inside == var_0);
    if (var_1) {
        // return 1.0                                                                         <L 120>
        return var_2;
    }
    // if num_inside == 0:                                                                    <L 122>
    var_4 = (var_num_inside == var_3);
    if (var_4) {
        // return 0.0                                                                         <L 123>
        return var_5;
    }
    // idx = wp.int32(0)                                                                      <L 127>
    var_7 = wp::int32(var_6);
    // if num_inside == 1:                                                                    <L 128>
    var_9 = (var_num_inside == var_8);
    if (var_9) {
        // if vert_depths[1] < 0.0:                                                           <L 130>
        var_11 = wp::extract(var_vert_depths, var_10);
        var_13 = (var_11 < var_12);
        if (var_13) {
            // idx = 1                                                                        <L 131>
        }
        if (!var_13) {
            // elif vert_depths[2] < 0.0:                                                     <L 132>
            var_16 = wp::extract(var_vert_depths, var_15);
            var_18 = (var_16 < var_17);
            if (var_18) {
                // idx = 2                                                                    <L 133>
            }
            var_20 = wp::where(var_18, var_19, var_7);
        }
        var_21 = wp::where(var_13, var_14, var_20);
    }
    if (!var_9) {
        // if vert_depths[1] >= 0.0:                                                          <L 136>
        var_23 = wp::extract(var_vert_depths, var_22);
        var_25 = (var_23 >= var_24);
        if (var_25) {
            // idx = 1                                                                        <L 137>
        }
        if (!var_25) {
            // elif vert_depths[2] >= 0.0:                                                    <L 138>
            var_28 = wp::extract(var_vert_depths, var_27);
            var_30 = (var_28 >= var_29);
            if (var_30) {
                // idx = 2                                                                    <L 139>
            }
            var_32 = wp::where(var_30, var_31, var_7);
        }
        var_33 = wp::where(var_25, var_26, var_32);
    }
    var_34 = wp::where(var_9, var_21, var_33);
    // d0 = vert_depths[idx]                                                                  <L 141>
    var_35 = wp::extract(var_vert_depths, var_34);
    // d1 = vert_depths[(idx + 1) % 3]                                                        <L 142>
    var_37 = wp::add(var_34, var_36);
    var_39 = wp::mod(var_37, var_38);
    var_40 = wp::extract(var_vert_depths, var_39);
    // d2 = vert_depths[(idx + 2) % 3]                                                        <L 143>
    var_42 = wp::add(var_34, var_41);
    var_44 = wp::mod(var_42, var_43);
    var_45 = wp::extract(var_vert_depths, var_44);
    // denom = (d0 - d1) * (d0 - d2)                                                          <L 145>
    var_46 = wp::sub(var_35, var_40);
    var_47 = wp::sub(var_35, var_45);
    var_48 = wp::mul(var_46, var_47);
    // eps = wp.float32(1e-8)                                                                 <L 146>
    var_50 = wp::float32(var_49);
    // if wp.abs(denom) < eps:                                                                <L 147>
    var_51 = wp::abs(var_48);
    var_52 = (var_51 < var_50);
    if (var_52) {
        // if num_inside == 1:                                                                <L 148>
        var_54 = (var_num_inside == var_53);
        if (var_54) {
            // return 0.0                                                                     <L 149>
            return var_55;
        }
        if (!var_54) {
            // return 1.0                                                                     <L 151>
            return var_56;
        }
    }
    // fraction = wp.clamp((d0 * d0) / denom, 0.0, 1.0)                                       <L 153>
    var_57 = wp::mul(var_35, var_35);
    var_58 = wp::div(var_57, var_48);
    var_61 = wp::clamp(var_58, var_59, var_60);
    // if num_inside == 2:                                                                    <L 154>
    var_63 = (var_num_inside == var_62);
    if (var_63) {
        // return 1.0 - fraction                                                              <L 155>
        var_65 = wp::sub(var_64, var_61);
        return var_65;
    }
    if (!var_63) {
        // return fraction                                                                    <L 157>
        return var_61;
    }
    return {};
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_mc.py:160
static CUDA_CALLABLE void mc_calc_face_0(
    wp::array_t<wp::vec_t<2, wp::uint8>> var_flat_edge_verts_table,
    wp::array_t<wp::vec_t<3, wp::uint8>> var_corner_offsets_table,
    wp::int32 var_tri_range_start,
    wp::vec_t<8, wp::float32> var_corner_vals,
    wp::uint64 var_sdf_a,
    wp::int32 var_x_id,
    wp::int32 var_y_id,
    wp::int32 var_z_id,
    wp::float32 var_isovalue,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & ret_2,
    wp::float32 & ret_3,
    wp::mat_t<3, 3, wp::float32> & ret_4)
{
    //---------
    // primal vars
    wp::mat_t<3, 3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    const wp::int32 var_2 = 0;
    wp::int32 var_3;
    const wp::int32 var_4 = 0;
    wp::int32 var_5;
    wp::vec_t<2, wp::uint8>* var_6;
    wp::vec_t<2, wp::int32> var_7;
    wp::vec_t<2, wp::uint8> var_8;
    const wp::int32 var_9 = 0;
    wp::int32 var_10;
    const wp::int32 var_11 = 1;
    wp::int32 var_12;
    wp::float32 var_13;
    wp::float32 var_14;
    wp::float32 var_15;
    wp::float32 var_16;
    wp::vec_t<3, wp::uint8>* var_17;
    wp::vec_t<3, wp::float32> var_18;
    wp::vec_t<3, wp::uint8> var_19;
    wp::vec_t<3, wp::uint8>* var_20;
    wp::vec_t<3, wp::float32> var_21;
    wp::vec_t<3, wp::uint8> var_22;
    wp::float32 var_23;
    wp::float32 var_24;
    wp::float32 var_25;
    const wp::float32 var_26 = 1e-10;
    bool var_27;
    const wp::float32 var_28 = 0.5;
    wp::vec_t<3, wp::float32> var_29;
    wp::vec_t<3, wp::float32> var_30;
    wp::float32 var_31;
    wp::float32 var_32;
    const wp::float32 var_33 = 0.02;
    const wp::float32 var_34 = 0.98;
    wp::float32 var_35;
    wp::vec_t<3, wp::float32> var_36;
    wp::vec_t<3, wp::float32> var_37;
    wp::vec_t<3, wp::float32> var_38;
    wp::vec_t<3, wp::float32> var_39;
    wp::vec_t<3, wp::float32> var_40;
    wp::vec_t<3, wp::float32> var_41;
    wp::vec_t<3, wp::float32> var_42;
    const wp::int32 var_43 = 1;
    const wp::int32 var_44 = 1;
    wp::float32 var_45;
    bool var_46;
    const wp::float32 var_47 = 9900000000.0;
    bool var_48;
    bool var_49;
    const wp::float32 var_50 = 0.0;
    wp::float32 var_51;
    const wp::float32 var_52 = 0.0;
    bool var_53;
    const wp::int32 var_54 = 1;
    wp::int32 var_55;
    wp::int32 var_56;
    const wp::int32 var_57 = 1;
    wp::int32 var_58;
    wp::vec_t<2, wp::uint8>* var_59;
    wp::vec_t<2, wp::int32> var_60;
    wp::vec_t<2, wp::uint8> var_61;
    const wp::int32 var_62 = 0;
    wp::int32 var_63;
    const wp::int32 var_64 = 1;
    wp::int32 var_65;
    wp::float32 var_66;
    wp::float32 var_67;
    wp::float32 var_68;
    wp::float32 var_69;
    wp::vec_t<3, wp::uint8>* var_70;
    wp::vec_t<3, wp::float32> var_71;
    wp::vec_t<3, wp::uint8> var_72;
    wp::vec_t<3, wp::uint8>* var_73;
    wp::vec_t<3, wp::float32> var_74;
    wp::vec_t<3, wp::uint8> var_75;
    wp::float32 var_76;
    wp::float32 var_77;
    wp::float32 var_78;
    bool var_79;
    const wp::float32 var_80 = 0.5;
    wp::vec_t<3, wp::float32> var_81;
    wp::vec_t<3, wp::float32> var_82;
    wp::float32 var_83;
    wp::float32 var_84;
    wp::float32 var_85;
    wp::vec_t<3, wp::float32> var_86;
    wp::vec_t<3, wp::float32> var_87;
    wp::vec_t<3, wp::float32> var_88;
    wp::vec_t<3, wp::float32> var_89;
    wp::float32 var_90;
    wp::vec_t<3, wp::float32> var_91;
    wp::vec_t<3, wp::float32> var_92;
    wp::vec_t<3, wp::float32> var_93;
    const wp::int32 var_94 = 1;
    const wp::int32 var_95 = 1;
    wp::float32 var_96;
    bool var_97;
    const wp::float32 var_98 = 9900000000.0;
    bool var_99;
    bool var_100;
    const wp::float32 var_101 = 0.0;
    wp::float32 var_102;
    const wp::float32 var_103 = 0.0;
    bool var_104;
    const wp::int32 var_105 = 1;
    wp::int32 var_106;
    wp::int32 var_107;
    const wp::int32 var_108 = 2;
    wp::int32 var_109;
    wp::vec_t<2, wp::uint8>* var_110;
    wp::vec_t<2, wp::int32> var_111;
    wp::vec_t<2, wp::uint8> var_112;
    const wp::int32 var_113 = 0;
    wp::int32 var_114;
    const wp::int32 var_115 = 1;
    wp::int32 var_116;
    wp::float32 var_117;
    wp::float32 var_118;
    wp::float32 var_119;
    wp::float32 var_120;
    wp::vec_t<3, wp::uint8>* var_121;
    wp::vec_t<3, wp::float32> var_122;
    wp::vec_t<3, wp::uint8> var_123;
    wp::vec_t<3, wp::uint8>* var_124;
    wp::vec_t<3, wp::float32> var_125;
    wp::vec_t<3, wp::uint8> var_126;
    wp::float32 var_127;
    wp::float32 var_128;
    wp::float32 var_129;
    bool var_130;
    const wp::float32 var_131 = 0.5;
    wp::vec_t<3, wp::float32> var_132;
    wp::vec_t<3, wp::float32> var_133;
    wp::float32 var_134;
    wp::float32 var_135;
    wp::float32 var_136;
    wp::vec_t<3, wp::float32> var_137;
    wp::vec_t<3, wp::float32> var_138;
    wp::vec_t<3, wp::float32> var_139;
    wp::vec_t<3, wp::float32> var_140;
    wp::float32 var_141;
    wp::vec_t<3, wp::float32> var_142;
    wp::vec_t<3, wp::float32> var_143;
    wp::vec_t<3, wp::float32> var_144;
    const wp::int32 var_145 = 1;
    const wp::int32 var_146 = 1;
    wp::float32 var_147;
    bool var_148;
    const wp::float32 var_149 = 9900000000.0;
    bool var_150;
    bool var_151;
    const wp::float32 var_152 = 0.0;
    wp::float32 var_153;
    const wp::float32 var_154 = 0.0;
    bool var_155;
    const wp::int32 var_156 = 1;
    wp::int32 var_157;
    wp::int32 var_158;
    const wp::int32 var_159 = 1;
    wp::vec_t<3, wp::float32> var_160;
    const wp::int32 var_161 = 0;
    wp::vec_t<3, wp::float32> var_162;
    wp::vec_t<3, wp::float32> var_163;
    const wp::int32 var_164 = 2;
    wp::vec_t<3, wp::float32> var_165;
    const wp::int32 var_166 = 0;
    wp::vec_t<3, wp::float32> var_167;
    wp::vec_t<3, wp::float32> var_168;
    wp::vec_t<3, wp::float32> var_169;
    wp::float32 var_170;
    const wp::float32 var_171 = 1e-20;
    bool var_172;
    const wp::float32 var_173 = 0.0;
    const wp::float32 var_174 = 0.0;
    const wp::float32 var_175 = 0.0;
    const wp::float32 var_176 = 1.0;
    wp::vec_t<3, wp::float32> var_177;
    wp::float32 var_178;
    wp::vec_t<3, wp::float32> var_179;
    const wp::float32 var_180 = 2.0;
    wp::float32 var_181;
    wp::float32 var_182;
    wp::vec_t<3, wp::float32> var_183;
    const wp::int32 var_184 = 0;
    wp::vec_t<3, wp::float32> var_185;
    const wp::int32 var_186 = 1;
    wp::vec_t<3, wp::float32> var_187;
    wp::vec_t<3, wp::float32> var_188;
    const wp::int32 var_189 = 2;
    wp::vec_t<3, wp::float32> var_190;
    wp::vec_t<3, wp::float32> var_191;
    const wp::float32 var_192 = 3.0;
    wp::vec_t<3, wp::float32> var_193;
    const wp::int32 var_194 = 0;
    wp::float32 var_195;
    const wp::int32 var_196 = 1;
    wp::float32 var_197;
    wp::float32 var_198;
    const wp::int32 var_199 = 2;
    wp::float32 var_200;
    wp::float32 var_201;
    const wp::float32 var_202 = 3.0;
    wp::float32 var_203;
    wp::float32 var_204;
    wp::float32 var_205;
    //---------
    // forward
    // def mc_calc_face(                                                                      <L 161>
    // face_verts = wp.mat33f()                                                               <L 185>
    var_0 = wp::mat_t<3, 3, wp::float32>();
    // vert_depths = wp.vec3f()                                                               <L 186>
    var_1 = wp::vec_t<3, wp::float32>();
    // num_inside = wp.int32(0)                                                               <L 187>
    var_3 = wp::int32(var_2);
    // for vi in range(3):                                                                    <L 188>
    // edge_verts = wp.vec2i(flat_edge_verts_table[tri_range_start + vi])                     <L 189>
    var_5 = wp::add(var_tri_range_start, var_4);
    var_6 = wp::address(var_flat_edge_verts_table, var_5);
    var_8 = wp::load(var_6);
    var_7 = wp::vec_t<2, wp::int32>(var_8);
    // v_idx_from = edge_verts[0]                                                             <L 190>
    var_10 = wp::extract(var_7, var_9);
    // v_idx_to = edge_verts[1]                                                               <L 191>
    var_12 = wp::extract(var_7, var_11);
    // val_0 = wp.float32(corner_vals[v_idx_from])                                            <L 192>
    var_13 = wp::extract(var_corner_vals, var_10);
    var_14 = wp::float32(var_13);
    // val_1 = wp.float32(corner_vals[v_idx_to])                                              <L 193>
    var_15 = wp::extract(var_corner_vals, var_12);
    var_16 = wp::float32(var_15);
    // p_0 = wp.vec3f(corner_offsets_table[v_idx_from])                                       <L 195>
    var_17 = wp::address(var_corner_offsets_table, var_10);
    var_19 = wp::load(var_17);
    var_18 = wp::vec_t<3, wp::float32>(var_19);
    // p_1 = wp.vec3f(corner_offsets_table[v_idx_to])                                         <L 196>
    var_20 = wp::address(var_corner_offsets_table, var_12);
    var_22 = wp::load(var_20);
    var_21 = wp::vec_t<3, wp::float32>(var_22);
    // val_diff = wp.float32(val_1 - val_0)                                                   <L 197>
    var_23 = wp::sub(var_16, var_14);
    var_24 = wp::float32(var_23);
    // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 198>
    var_25 = wp::abs(var_24);
    var_27 = (var_25 < var_26);
    if (var_27) {
        // p = 0.5 * (p_0 + p_1)                                                              <L 199>
        var_29 = wp::add(var_18, var_21);
        var_30 = wp::mul(var_28, var_29);
    }
    if (!var_27) {
        // t = wp.clamp((isovalue - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 205>
        var_31 = wp::sub(var_isovalue, var_14);
        var_32 = wp::div(var_31, var_24);
        var_35 = wp::clamp(var_32, var_33, var_34);
        // p = p_0 + t * (p_1 - p_0)                                                          <L 206>
        var_36 = wp::sub(var_21, var_18);
        var_37 = wp::mul(var_35, var_36);
        var_38 = wp::add(var_18, var_37);
    }
    var_39 = wp::where(var_27, var_30, var_38);
    // vol_idx = p + int_to_vec3f(x_id, y_id, z_id)                                           <L 207>
    var_40 = int_to_vec3f_0(var_x_id, var_y_id, var_z_id);
    var_41 = wp::add(var_39, var_40);
    // p_scaled = wp.volume_index_to_world(sdf_a, vol_idx)                                    <L 208>
    var_42 = wp::volume_index_to_world(var_sdf_a, var_41);
    // face_verts[vi] = p_scaled                                                              <L 209>
    wp::assign_inplace(var_0, var_4, var_42);
    // depth = wp.volume_sample_f(sdf_a, vol_idx, wp.Volume.LINEAR)                           <L 210>
    var_45 = wp::volume_sample_f(var_sdf_a, var_41, var_44);
    // if depth >= wp.static(MAXVAL * 0.99) or wp.isnan(depth):                               <L 211>
    var_48 = (var_45 >= var_47);
    var_46 = var_48;
    if (!var_46) {
        var_49 = wp::isnan(var_45);
        var_46 = var_46 || var_49;
    }
    if (var_46) {
        // depth = 0.0                                                                        <L 212>
    }
    var_51 = wp::where(var_46, var_50, var_45);
    // vert_depths[vi] = depth  # Keep SDF convention: negative = inside/penetrating          <L 213>
    wp::assign_inplace(var_1, var_4, var_51);
    // if depth < 0.0:                                                                        <L 214>
    var_53 = (var_51 < var_52);
    if (var_53) {
        // num_inside += 1                                                                    <L 215>
        var_55 = wp::add(var_3, var_54);
    }
    var_56 = wp::where(var_53, var_55, var_3);
    // edge_verts = wp.vec2i(flat_edge_verts_table[tri_range_start + vi])                     <L 189>
    var_58 = wp::add(var_tri_range_start, var_57);
    var_59 = wp::address(var_flat_edge_verts_table, var_58);
    var_61 = wp::load(var_59);
    var_60 = wp::vec_t<2, wp::int32>(var_61);
    // v_idx_from = edge_verts[0]                                                             <L 190>
    var_63 = wp::extract(var_60, var_62);
    // v_idx_to = edge_verts[1]                                                               <L 191>
    var_65 = wp::extract(var_60, var_64);
    // val_0 = wp.float32(corner_vals[v_idx_from])                                            <L 192>
    var_66 = wp::extract(var_corner_vals, var_63);
    var_67 = wp::float32(var_66);
    // val_1 = wp.float32(corner_vals[v_idx_to])                                              <L 193>
    var_68 = wp::extract(var_corner_vals, var_65);
    var_69 = wp::float32(var_68);
    // p_0 = wp.vec3f(corner_offsets_table[v_idx_from])                                       <L 195>
    var_70 = wp::address(var_corner_offsets_table, var_63);
    var_72 = wp::load(var_70);
    var_71 = wp::vec_t<3, wp::float32>(var_72);
    // p_1 = wp.vec3f(corner_offsets_table[v_idx_to])                                         <L 196>
    var_73 = wp::address(var_corner_offsets_table, var_65);
    var_75 = wp::load(var_73);
    var_74 = wp::vec_t<3, wp::float32>(var_75);
    // val_diff = wp.float32(val_1 - val_0)                                                   <L 197>
    var_76 = wp::sub(var_69, var_67);
    var_77 = wp::float32(var_76);
    // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 198>
    var_78 = wp::abs(var_77);
    var_79 = (var_78 < var_26);
    if (var_79) {
        // p = 0.5 * (p_0 + p_1)                                                              <L 199>
        var_81 = wp::add(var_71, var_74);
        var_82 = wp::mul(var_80, var_81);
    }
    if (!var_79) {
        // t = wp.clamp((isovalue - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 205>
        var_83 = wp::sub(var_isovalue, var_67);
        var_84 = wp::div(var_83, var_77);
        var_85 = wp::clamp(var_84, var_33, var_34);
        // p = p_0 + t * (p_1 - p_0)                                                          <L 206>
        var_86 = wp::sub(var_74, var_71);
        var_87 = wp::mul(var_85, var_86);
        var_88 = wp::add(var_71, var_87);
    }
    var_89 = wp::where(var_79, var_82, var_88);
    var_90 = wp::where(var_79, var_35, var_85);
    // vol_idx = p + int_to_vec3f(x_id, y_id, z_id)                                           <L 207>
    var_91 = int_to_vec3f_0(var_x_id, var_y_id, var_z_id);
    var_92 = wp::add(var_89, var_91);
    // p_scaled = wp.volume_index_to_world(sdf_a, vol_idx)                                    <L 208>
    var_93 = wp::volume_index_to_world(var_sdf_a, var_92);
    // face_verts[vi] = p_scaled                                                              <L 209>
    wp::assign_inplace(var_0, var_57, var_93);
    // depth = wp.volume_sample_f(sdf_a, vol_idx, wp.Volume.LINEAR)                           <L 210>
    var_96 = wp::volume_sample_f(var_sdf_a, var_92, var_95);
    // if depth >= wp.static(MAXVAL * 0.99) or wp.isnan(depth):                               <L 211>
    var_99 = (var_96 >= var_98);
    var_97 = var_99;
    if (!var_97) {
        var_100 = wp::isnan(var_96);
        var_97 = var_97 || var_100;
    }
    if (var_97) {
        // depth = 0.0                                                                        <L 212>
    }
    var_102 = wp::where(var_97, var_101, var_96);
    // vert_depths[vi] = depth  # Keep SDF convention: negative = inside/penetrating          <L 213>
    wp::assign_inplace(var_1, var_57, var_102);
    // if depth < 0.0:                                                                        <L 214>
    var_104 = (var_102 < var_103);
    if (var_104) {
        // num_inside += 1                                                                    <L 215>
        var_106 = wp::add(var_56, var_105);
    }
    var_107 = wp::where(var_104, var_106, var_56);
    // edge_verts = wp.vec2i(flat_edge_verts_table[tri_range_start + vi])                     <L 189>
    var_109 = wp::add(var_tri_range_start, var_108);
    var_110 = wp::address(var_flat_edge_verts_table, var_109);
    var_112 = wp::load(var_110);
    var_111 = wp::vec_t<2, wp::int32>(var_112);
    // v_idx_from = edge_verts[0]                                                             <L 190>
    var_114 = wp::extract(var_111, var_113);
    // v_idx_to = edge_verts[1]                                                               <L 191>
    var_116 = wp::extract(var_111, var_115);
    // val_0 = wp.float32(corner_vals[v_idx_from])                                            <L 192>
    var_117 = wp::extract(var_corner_vals, var_114);
    var_118 = wp::float32(var_117);
    // val_1 = wp.float32(corner_vals[v_idx_to])                                              <L 193>
    var_119 = wp::extract(var_corner_vals, var_116);
    var_120 = wp::float32(var_119);
    // p_0 = wp.vec3f(corner_offsets_table[v_idx_from])                                       <L 195>
    var_121 = wp::address(var_corner_offsets_table, var_114);
    var_123 = wp::load(var_121);
    var_122 = wp::vec_t<3, wp::float32>(var_123);
    // p_1 = wp.vec3f(corner_offsets_table[v_idx_to])                                         <L 196>
    var_124 = wp::address(var_corner_offsets_table, var_116);
    var_126 = wp::load(var_124);
    var_125 = wp::vec_t<3, wp::float32>(var_126);
    // val_diff = wp.float32(val_1 - val_0)                                                   <L 197>
    var_127 = wp::sub(var_120, var_118);
    var_128 = wp::float32(var_127);
    // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 198>
    var_129 = wp::abs(var_128);
    var_130 = (var_129 < var_26);
    if (var_130) {
        // p = 0.5 * (p_0 + p_1)                                                              <L 199>
        var_132 = wp::add(var_122, var_125);
        var_133 = wp::mul(var_131, var_132);
    }
    if (!var_130) {
        // t = wp.clamp((isovalue - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 205>
        var_134 = wp::sub(var_isovalue, var_118);
        var_135 = wp::div(var_134, var_128);
        var_136 = wp::clamp(var_135, var_33, var_34);
        // p = p_0 + t * (p_1 - p_0)                                                          <L 206>
        var_137 = wp::sub(var_125, var_122);
        var_138 = wp::mul(var_136, var_137);
        var_139 = wp::add(var_122, var_138);
    }
    var_140 = wp::where(var_130, var_133, var_139);
    var_141 = wp::where(var_130, var_90, var_136);
    // vol_idx = p + int_to_vec3f(x_id, y_id, z_id)                                           <L 207>
    var_142 = int_to_vec3f_0(var_x_id, var_y_id, var_z_id);
    var_143 = wp::add(var_140, var_142);
    // p_scaled = wp.volume_index_to_world(sdf_a, vol_idx)                                    <L 208>
    var_144 = wp::volume_index_to_world(var_sdf_a, var_143);
    // face_verts[vi] = p_scaled                                                              <L 209>
    wp::assign_inplace(var_0, var_108, var_144);
    // depth = wp.volume_sample_f(sdf_a, vol_idx, wp.Volume.LINEAR)                           <L 210>
    var_147 = wp::volume_sample_f(var_sdf_a, var_143, var_146);
    // if depth >= wp.static(MAXVAL * 0.99) or wp.isnan(depth):                               <L 211>
    var_150 = (var_147 >= var_149);
    var_148 = var_150;
    if (!var_148) {
        var_151 = wp::isnan(var_147);
        var_148 = var_148 || var_151;
    }
    if (var_148) {
        // depth = 0.0                                                                        <L 212>
    }
    var_153 = wp::where(var_148, var_152, var_147);
    // vert_depths[vi] = depth  # Keep SDF convention: negative = inside/penetrating          <L 213>
    wp::assign_inplace(var_1, var_108, var_153);
    // if depth < 0.0:                                                                        <L 214>
    var_155 = (var_153 < var_154);
    if (var_155) {
        // num_inside += 1                                                                    <L 215>
        var_157 = wp::add(var_107, var_156);
    }
    var_158 = wp::where(var_155, var_157, var_107);
    // n = wp.cross(face_verts[1] - face_verts[0], face_verts[2] - face_verts[0])             <L 217>
    var_160 = wp::extract(var_0, var_159);
    var_162 = wp::extract(var_0, var_161);
    var_163 = wp::sub(var_160, var_162);
    var_165 = wp::extract(var_0, var_164);
    var_167 = wp::extract(var_0, var_166);
    var_168 = wp::sub(var_165, var_167);
    var_169 = wp::cross(var_163, var_168);
    // n_sq = wp.dot(n, n)                                                                    <L 218>
    var_170 = wp::dot(var_169, var_169);
    // if n_sq < MC_DEGENERATE_N_SQ_EPS:                                                      <L 219>
    var_172 = (var_170 < var_171);
    if (var_172) {
        // area = 0.0                                                                         <L 221>
        // normal = wp.vec3(0.0, 0.0, 1.0)                                                    <L 222>
        var_177 = wp::vec_t<3, wp::float32>(var_174, var_175, var_176);
    }
    if (!var_172) {
        // n_len = wp.sqrt(n_sq)                                                              <L 224>
        var_178 = wp::sqrt(var_170);
        // normal = n / n_len                                                                 <L 225>
        var_179 = wp::div(var_169, var_178);
        // area = n_len / 2.0                                                                 <L 226>
        var_181 = wp::div(var_178, var_180);
    }
    var_182 = wp::where(var_172, var_173, var_181);
    var_183 = wp::where(var_172, var_177, var_179);
    // center = (face_verts[0] + face_verts[1] + face_verts[2]) / 3.0                         <L 227>
    var_185 = wp::extract(var_0, var_184);
    var_187 = wp::extract(var_0, var_186);
    var_188 = wp::add(var_185, var_187);
    var_190 = wp::extract(var_0, var_189);
    var_191 = wp::add(var_188, var_190);
    var_193 = wp::div(var_191, var_192);
    // pen_depth = (vert_depths[0] + vert_depths[1] + vert_depths[2]) / 3.0                   <L 228>
    var_195 = wp::extract(var_1, var_194);
    var_197 = wp::extract(var_1, var_196);
    var_198 = wp::add(var_195, var_197);
    var_200 = wp::extract(var_1, var_199);
    var_201 = wp::add(var_198, var_200);
    var_203 = wp::div(var_201, var_202);
    // area *= get_triangle_fraction(vert_depths, num_inside)                                 <L 229>
    var_204 = get_triangle_fraction_0(var_1, var_158);
    var_205 = wp::mul(var_182, var_204);
    // return area, normal, center, pen_depth, face_verts                                     <L 230>
    ret_0 = var_205;
    ret_1 = var_183;
    ret_2 = var_193;
    ret_3 = var_203;
    ret_4 = var_0;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_mc.py:105
static CUDA_CALLABLE void adj_int_to_vec3f_0(
    wp::int32 var_x,
    wp::int32 var_y,
    wp::int32 var_z,
    wp::int32 & adj_x,
    wp::int32 & adj_y,
    wp::int32 & adj_z,
    wp::vec_t<3, wp::float32> & adj_ret)
{
    //---------
    // primal vars
    wp::float32 var_0;
    wp::float32 var_1;
    wp::float32 var_2;
    wp::vec_t<3, wp::float32> var_3;
    //---------
    // dual vars
    wp::float32 adj_0 = {};
    wp::float32 adj_1 = {};
    wp::float32 adj_2 = {};
    wp::vec_t<3, wp::float32> adj_3 = {};
    //---------
    // forward
    // def int_to_vec3f(x: wp.int32, y: wp.int32, z: wp.int32):                               <L 106>
    // return wp.vec3f(float(x), float(y), float(z))                                          <L 108>
    var_0 = wp::float(var_x);
    var_1 = wp::float(var_y);
    var_2 = wp::float(var_z);
    var_3 = wp::vec_t<3, wp::float32>(var_0, var_1, var_2);
    goto label0;
    //---------
    // reverse
    label0:;
    adj_3 += adj_ret;
    wp::adj_vec_t(var_0, var_1, var_2, adj_0, adj_1, adj_2, adj_3);
    wp::adj_float(var_z, adj_z, adj_2);
    wp::adj_float(var_y, adj_y, adj_1);
    wp::adj_float(var_x, adj_x, adj_0);
    // adj: return wp.vec3f(float(x), float(y), float(z))                                     <L 108>
    // adj: def int_to_vec3f(x: wp.int32, y: wp.int32, z: wp.int32):                          <L 106>
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_utils.py:651
static CUDA_CALLABLE void adj_get_distance_to_mesh_0(
    wp::uint64 var_mesh,
    wp::vec_t<3, wp::float32> var_point,
    wp::float32 var_max_dist,
    wp::float32 var_winding_threshold,
    wp::uint64 & adj_mesh,
    wp::vec_t<3, wp::float32> & adj_point,
    wp::float32 & adj_max_dist,
    wp::float32 & adj_winding_threshold,
    wp::float32 & adj_ret)
{
    //---------
    // primal vars
    const wp::float32 var_0 = 2.0;
    wp::mesh_query_point_t var_1;
    bool* var_2;
    bool var_3;
    wp::int32* var_4;
    wp::float32* var_5;
    wp::float32* var_6;
    wp::vec_t<3, wp::float32> var_7;
    wp::int32 var_8;
    wp::float32 var_9;
    wp::float32 var_10;
    wp::vec_t<3, wp::float32> var_11;
    wp::float32* var_12;
    wp::float32 var_13;
    wp::float32 var_14;
    const wp::float32 var_15 = 0.0;
    bool var_16;
    wp::float32 var_17;
    wp::float32 var_18;
    wp::float32 var_19;
    wp::float32 var_20;
    bool var_21;
    //---------
    // dual vars
    wp::float32 adj_0 = {};
    wp::mesh_query_point_t adj_1 = {};
    bool adj_2 = {};
    bool adj_3 = {};
    wp::int32 adj_4 = {};
    wp::float32 adj_5 = {};
    wp::float32 adj_6 = {};
    wp::vec_t<3, wp::float32> adj_7 = {};
    wp::int32 adj_8 = {};
    wp::float32 adj_9 = {};
    wp::float32 adj_10 = {};
    wp::vec_t<3, wp::float32> adj_11 = {};
    wp::float32 adj_12 = {};
    wp::float32 adj_13 = {};
    wp::float32 adj_14 = {};
    wp::float32 adj_15 = {};
    bool adj_16 = {};
    wp::float32 adj_17 = {};
    wp::float32 adj_18 = {};
    wp::float32 adj_19 = {};
    wp::float32 adj_20 = {};
    bool adj_21 = {};
    //---------
    // forward
    // def get_distance_to_mesh(mesh: wp.uint64, point: wp.vec3, max_dist: wp.float32, winding_threshold: wp.float32):       <L 652>
    // res = wp.mesh_query_point_sign_winding_number(mesh, point, max_dist, 2.0, winding_threshold)       <L 653>
    var_1 = wp::mesh_query_point_sign_winding_number(var_mesh, var_point, var_max_dist, var_0, var_winding_threshold);
    // if res.result:                                                                         <L 654>
    var_2 = &((var_1).result);
    var_3 = wp::load(var_2);
    if (var_3) {
        // closest = wp.mesh_eval_position(mesh, res.face, res.u, res.v)                      <L 655>
        var_4 = &((var_1).face);
        var_5 = &((var_1).u);
        var_6 = &((var_1).v);
        var_8 = wp::load(var_4);
        var_9 = wp::load(var_5);
        var_10 = wp::load(var_6);
        var_7 = wp::mesh_eval_position(var_mesh, var_8, var_9, var_10);
        // vec_to_surface = closest - point                                                   <L 656>
        var_11 = wp::sub(var_7, var_point);
        // sign = res.sign                                                                    <L 657>
        var_12 = &((var_1).sign);
        var_14 = wp::load(var_12);
        var_13 = wp::copy(var_14);
        // if winding_threshold < 0.0:                                                        <L 660>
        var_16 = (var_winding_threshold < var_15);
        if (var_16) {
            // sign = -sign                                                                   <L 661>
            var_17 = wp::neg(var_13);
        }
        var_18 = wp::where(var_16, var_17, var_13);
        // return sign * wp.length(vec_to_surface)                                            <L 662>
        var_19 = wp::length(var_11);
        var_20 = wp::mul(var_18, var_19);
        goto label0;
    }
    var_21 = wp::load(var_2);
    // return max_dist                                                                        <L 663>
    goto label1;
    //---------
    // reverse
    label1:;
    adj_max_dist += adj_ret;
    // adj: return max_dist                                                                   <L 663>
    if (var_21) {
        label0:;
        adj_20 += adj_ret;
        wp::adj_mul(var_18, var_19, adj_18, adj_19, adj_20);
        wp::adj_length(var_11, var_19, adj_11, adj_19);
        // adj: return sign * wp.length(vec_to_surface)                                       <L 662>
        wp::adj_where(var_16, var_17, var_13, adj_16, adj_17, adj_13, adj_18);
        if (var_16) {
            wp::adj_neg(var_13, adj_13, adj_17);
            // adj: sign = -sign                                                              <L 661>
        }
        // adj: if winding_threshold < 0.0:                                                   <L 660>
        wp::adj_copy(var_14, adj_12, adj_13);
        adj_1.sign += adj_12;
        // adj: sign = res.sign                                                               <L 657>
        wp::adj_sub(var_7, var_point, adj_7, adj_point, adj_11);
        // adj: vec_to_surface = closest - point                                              <L 656>
        wp::adj_mesh_eval_position(var_mesh, var_8, var_9, var_10, adj_mesh, adj_4, adj_5, adj_6, adj_7);
        adj_1.v += adj_6;
        adj_1.u += adj_5;
        adj_1.face = adj_4;
        // adj: closest = wp.mesh_eval_position(mesh, res.face, res.u, res.v)                 <L 655>
    }
    adj_1.result = adj_2;
    // adj: if res.result:                                                                    <L 654>
    wp::adj_mesh_query_point_sign_winding_number(var_mesh, var_point, var_max_dist, var_0, var_winding_threshold, var_1, adj_mesh, adj_point, adj_max_dist, adj_0, adj_winding_threshold, adj_1);
    // adj: res = wp.mesh_query_point_sign_winding_number(mesh, point, max_dist, 2.0, winding_threshold)  <L 653>
    // adj: def get_distance_to_mesh(mesh: wp.uint64, point: wp.vec3, max_dist: wp.float32, winding_threshold: wp.float32):  <L 652>
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/kernels.py:180
static CUDA_CALLABLE void adj_sdf_sphere_0(
    wp::vec_t<3, wp::float32> var_point,
    wp::float32 var_radius,
    wp::vec_t<3, wp::float32> & adj_point,
    wp::float32 & adj_radius,
    wp::float32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/kernels.py:213
static CUDA_CALLABLE void adj_sdf_box_0(
    wp::vec_t<3, wp::float32> var_point,
    wp::float32 var_hx,
    wp::float32 var_hy,
    wp::float32 var_hz,
    wp::vec_t<3, wp::float32> & adj_point,
    wp::float32 & adj_hx,
    wp::float32 & adj_hy,
    wp::float32 & adj_hz,
    wp::float32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/kernels.py:147
static CUDA_CALLABLE void adj__sdf_point_to_z_up_0(
    wp::vec_t<3, wp::float32> var_point,
    wp::int32 var_up_axis,
    wp::vec_t<3, wp::float32> & adj_point,
    wp::int32 & adj_up_axis,
    wp::vec_t<3, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/kernels.py:277
static CUDA_CALLABLE void adj_sdf_capsule_0(
    wp::vec_t<3, wp::float32> var_point,
    wp::float32 var_radius,
    wp::float32 var_half_height,
    wp::int32 var_up_axis,
    wp::vec_t<3, wp::float32> & adj_point,
    wp::float32 & adj_radius,
    wp::float32 & adj_half_height,
    wp::int32 & adj_up_axis,
    wp::float32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/kernels.py:156
static CUDA_CALLABLE void adj__sdf_capped_cone_z_0(
    wp::float32 var_bottom_radius,
    wp::float32 var_top_radius,
    wp::float32 var_half_height,
    wp::vec_t<3, wp::float32> var_point_z_up,
    wp::float32 & adj_bottom_radius,
    wp::float32 & adj_top_radius,
    wp::float32 & adj_half_height,
    wp::vec_t<3, wp::float32> & adj_point_z_up,
    wp::float32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/kernels.py:347
static CUDA_CALLABLE void adj_sdf_cylinder_0(
    wp::vec_t<3, wp::float32> var_point,
    wp::float32 var_radius,
    wp::float32 var_half_height,
    wp::int32 var_up_axis,
    wp::float32 var_top_radius,
    wp::vec_t<3, wp::float32> & adj_point,
    wp::float32 & adj_radius,
    wp::float32 & adj_half_height,
    wp::int32 & adj_up_axis,
    wp::float32 & adj_top_radius,
    wp::float32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/kernels.py:464
static CUDA_CALLABLE void adj_sdf_ellipsoid_0(
    wp::vec_t<3, wp::float32> var_point,
    wp::vec_t<3, wp::float32> var_radii,
    wp::vec_t<3, wp::float32> & adj_point,
    wp::vec_t<3, wp::float32> & adj_radii,
    wp::float32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/kernels.py:530
static CUDA_CALLABLE void adj_sdf_cone_0(
    wp::vec_t<3, wp::float32> var_point,
    wp::float32 var_radius,
    wp::float32 var_half_height,
    wp::int32 var_up_axis,
    wp::vec_t<3, wp::float32> & adj_point,
    wp::float32 & adj_radius,
    wp::float32 & adj_half_height,
    wp::int32 & adj_up_axis,
    wp::float32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_mc.py:111
static CUDA_CALLABLE void adj_get_triangle_fraction_0(
    wp::vec_t<3, wp::float32> var_vert_depths,
    wp::int32 var_num_inside,
    wp::vec_t<3, wp::float32> & adj_vert_depths,
    wp::int32 & adj_num_inside,
    wp::float32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_mc.py:160
static CUDA_CALLABLE void adj_mc_calc_face_0(
    wp::array_t<wp::vec_t<2, wp::uint8>> var_flat_edge_verts_table,
    wp::array_t<wp::vec_t<3, wp::uint8>> var_corner_offsets_table,
    wp::int32 var_tri_range_start,
    wp::vec_t<8, wp::float32> var_corner_vals,
    wp::uint64 var_sdf_a,
    wp::int32 var_x_id,
    wp::int32 var_y_id,
    wp::int32 var_z_id,
    wp::float32 var_isovalue,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & ret_2,
    wp::float32 & ret_3,
    wp::mat_t<3, 3, wp::float32> & ret_4,
    wp::array_t<wp::vec_t<2, wp::uint8>> & adj_flat_edge_verts_table,
    wp::array_t<wp::vec_t<3, wp::uint8>> & adj_corner_offsets_table,
    wp::int32 & adj_tri_range_start,
    wp::vec_t<8, wp::float32> & adj_corner_vals,
    wp::uint64 & adj_sdf_a,
    wp::int32 & adj_x_id,
    wp::int32 & adj_y_id,
    wp::int32 & adj_z_id,
    wp::float32 & adj_isovalue,
    wp::float32 & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1,
    wp::vec_t<3, wp::float32> & adj_ret_2,
    wp::float32 & adj_ret_3,
    wp::mat_t<3, 3, wp::float32> & adj_ret_4)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}



extern "C" __global__ void _count_dense_mc_faces_kernel_bf53d10a_cuda_kernel_forward(
    wp::launch_bounds_t<3> dim,
    wp::array_t<wp::float32> var_sdf_values,
    wp::int32 var_ny,
    wp::int32 var_nz,
    wp::array_t<wp::int32> var_tri_range_table,
    wp::array_t<wp::vec_t<3, wp::uint8>> var_corner_offsets_table,
    wp::array_t<wp::int32> var_face_count)
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
        const wp::int32 var_3 = 0;
        wp::int32 var_4;
        const wp::int32 var_5 = 0;
        wp::vec_t<3, wp::uint8>* var_6;
        wp::vec_t<3, wp::int32> var_7;
        wp::vec_t<3, wp::uint8> var_8;
        const wp::int32 var_9 = 0;
        wp::int32 var_10;
        wp::int32 var_11;
        wp::int32 var_12;
        wp::int32 var_13;
        const wp::int32 var_14 = 1;
        wp::int32 var_15;
        wp::int32 var_16;
        wp::int32 var_17;
        wp::int32 var_18;
        const wp::int32 var_19 = 2;
        wp::int32 var_20;
        wp::int32 var_21;
        wp::int32 var_22;
        wp::float32* var_23;
        wp::float32 var_24;
        wp::float32 var_25;
        const wp::float32 var_26 = 0.0;
        bool var_27;
        const wp::int32 var_28 = 1;
        wp::int32 var_29;
        wp::int32 var_30;
        wp::int32 var_31;
        const wp::int32 var_32 = 1;
        wp::vec_t<3, wp::uint8>* var_33;
        wp::vec_t<3, wp::int32> var_34;
        wp::vec_t<3, wp::uint8> var_35;
        const wp::int32 var_36 = 0;
        wp::int32 var_37;
        wp::int32 var_38;
        wp::int32 var_39;
        wp::int32 var_40;
        const wp::int32 var_41 = 1;
        wp::int32 var_42;
        wp::int32 var_43;
        wp::int32 var_44;
        wp::int32 var_45;
        const wp::int32 var_46 = 2;
        wp::int32 var_47;
        wp::int32 var_48;
        wp::int32 var_49;
        wp::float32* var_50;
        wp::float32 var_51;
        wp::float32 var_52;
        const wp::float32 var_53 = 0.0;
        bool var_54;
        const wp::int32 var_55 = 1;
        wp::int32 var_56;
        wp::int32 var_57;
        wp::int32 var_58;
        const wp::int32 var_59 = 2;
        wp::vec_t<3, wp::uint8>* var_60;
        wp::vec_t<3, wp::int32> var_61;
        wp::vec_t<3, wp::uint8> var_62;
        const wp::int32 var_63 = 0;
        wp::int32 var_64;
        wp::int32 var_65;
        wp::int32 var_66;
        wp::int32 var_67;
        const wp::int32 var_68 = 1;
        wp::int32 var_69;
        wp::int32 var_70;
        wp::int32 var_71;
        wp::int32 var_72;
        const wp::int32 var_73 = 2;
        wp::int32 var_74;
        wp::int32 var_75;
        wp::int32 var_76;
        wp::float32* var_77;
        wp::float32 var_78;
        wp::float32 var_79;
        const wp::float32 var_80 = 0.0;
        bool var_81;
        const wp::int32 var_82 = 1;
        wp::int32 var_83;
        wp::int32 var_84;
        wp::int32 var_85;
        const wp::int32 var_86 = 3;
        wp::vec_t<3, wp::uint8>* var_87;
        wp::vec_t<3, wp::int32> var_88;
        wp::vec_t<3, wp::uint8> var_89;
        const wp::int32 var_90 = 0;
        wp::int32 var_91;
        wp::int32 var_92;
        wp::int32 var_93;
        wp::int32 var_94;
        const wp::int32 var_95 = 1;
        wp::int32 var_96;
        wp::int32 var_97;
        wp::int32 var_98;
        wp::int32 var_99;
        const wp::int32 var_100 = 2;
        wp::int32 var_101;
        wp::int32 var_102;
        wp::int32 var_103;
        wp::float32* var_104;
        wp::float32 var_105;
        wp::float32 var_106;
        const wp::float32 var_107 = 0.0;
        bool var_108;
        const wp::int32 var_109 = 1;
        wp::int32 var_110;
        wp::int32 var_111;
        wp::int32 var_112;
        const wp::int32 var_113 = 4;
        wp::vec_t<3, wp::uint8>* var_114;
        wp::vec_t<3, wp::int32> var_115;
        wp::vec_t<3, wp::uint8> var_116;
        const wp::int32 var_117 = 0;
        wp::int32 var_118;
        wp::int32 var_119;
        wp::int32 var_120;
        wp::int32 var_121;
        const wp::int32 var_122 = 1;
        wp::int32 var_123;
        wp::int32 var_124;
        wp::int32 var_125;
        wp::int32 var_126;
        const wp::int32 var_127 = 2;
        wp::int32 var_128;
        wp::int32 var_129;
        wp::int32 var_130;
        wp::float32* var_131;
        wp::float32 var_132;
        wp::float32 var_133;
        const wp::float32 var_134 = 0.0;
        bool var_135;
        const wp::int32 var_136 = 1;
        wp::int32 var_137;
        wp::int32 var_138;
        wp::int32 var_139;
        const wp::int32 var_140 = 5;
        wp::vec_t<3, wp::uint8>* var_141;
        wp::vec_t<3, wp::int32> var_142;
        wp::vec_t<3, wp::uint8> var_143;
        const wp::int32 var_144 = 0;
        wp::int32 var_145;
        wp::int32 var_146;
        wp::int32 var_147;
        wp::int32 var_148;
        const wp::int32 var_149 = 1;
        wp::int32 var_150;
        wp::int32 var_151;
        wp::int32 var_152;
        wp::int32 var_153;
        const wp::int32 var_154 = 2;
        wp::int32 var_155;
        wp::int32 var_156;
        wp::int32 var_157;
        wp::float32* var_158;
        wp::float32 var_159;
        wp::float32 var_160;
        const wp::float32 var_161 = 0.0;
        bool var_162;
        const wp::int32 var_163 = 1;
        wp::int32 var_164;
        wp::int32 var_165;
        wp::int32 var_166;
        const wp::int32 var_167 = 6;
        wp::vec_t<3, wp::uint8>* var_168;
        wp::vec_t<3, wp::int32> var_169;
        wp::vec_t<3, wp::uint8> var_170;
        const wp::int32 var_171 = 0;
        wp::int32 var_172;
        wp::int32 var_173;
        wp::int32 var_174;
        wp::int32 var_175;
        const wp::int32 var_176 = 1;
        wp::int32 var_177;
        wp::int32 var_178;
        wp::int32 var_179;
        wp::int32 var_180;
        const wp::int32 var_181 = 2;
        wp::int32 var_182;
        wp::int32 var_183;
        wp::int32 var_184;
        wp::float32* var_185;
        wp::float32 var_186;
        wp::float32 var_187;
        const wp::float32 var_188 = 0.0;
        bool var_189;
        const wp::int32 var_190 = 1;
        wp::int32 var_191;
        wp::int32 var_192;
        wp::int32 var_193;
        const wp::int32 var_194 = 7;
        wp::vec_t<3, wp::uint8>* var_195;
        wp::vec_t<3, wp::int32> var_196;
        wp::vec_t<3, wp::uint8> var_197;
        const wp::int32 var_198 = 0;
        wp::int32 var_199;
        wp::int32 var_200;
        wp::int32 var_201;
        wp::int32 var_202;
        const wp::int32 var_203 = 1;
        wp::int32 var_204;
        wp::int32 var_205;
        wp::int32 var_206;
        wp::int32 var_207;
        const wp::int32 var_208 = 2;
        wp::int32 var_209;
        wp::int32 var_210;
        wp::int32 var_211;
        wp::float32* var_212;
        wp::float32 var_213;
        wp::float32 var_214;
        const wp::float32 var_215 = 0.0;
        bool var_216;
        const wp::int32 var_217 = 1;
        wp::int32 var_218;
        wp::int32 var_219;
        wp::int32 var_220;
        wp::int32* var_221;
        wp::int32 var_222;
        wp::int32 var_223;
        const wp::int32 var_224 = 1;
        wp::int32 var_225;
        wp::int32* var_226;
        wp::int32 var_227;
        wp::int32 var_228;
        wp::int32 var_229;
        const wp::int32 var_230 = 3;
        wp::int32 var_231;
        const wp::int32 var_232 = 0;
        bool var_233;
        const wp::int32 var_234 = 0;
        wp::int32 var_235;
        //---------
        // forward
        // def _count_dense_mc_faces_kernel(                                                      <L 1456>
        // x, y, z = wp.tid()                                                                     <L 1465>
        builtin_tid3d(var_0, var_1, var_2);
        // cube_idx = wp.int32(0)                                                                 <L 1466>
        var_4 = wp::int32(var_3);
        // for i in range(8):                                                                     <L 1467>
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 1468>
        var_6 = wp::address(var_corner_offsets_table, var_5);
        var_8 = wp::load(var_6);
        var_7 = wp::vec_t<3, wp::int32>(var_8);
        // v = sdf_values[(x + co[0]) * ny * nz + (y + co[1]) * nz + (z + co[2])]                 <L 1469>
        var_10 = wp::extract(var_7, var_9);
        var_11 = wp::add(var_0, var_10);
        var_12 = wp::mul(var_11, var_ny);
        var_13 = wp::mul(var_12, var_nz);
        var_15 = wp::extract(var_7, var_14);
        var_16 = wp::add(var_1, var_15);
        var_17 = wp::mul(var_16, var_nz);
        var_18 = wp::add(var_13, var_17);
        var_20 = wp::extract(var_7, var_19);
        var_21 = wp::add(var_2, var_20);
        var_22 = wp::add(var_18, var_21);
        var_23 = wp::address(var_sdf_values, var_22);
        var_25 = wp::load(var_23);
        var_24 = wp::copy(var_25);
        // if v < 0.0:                                                                            <L 1470>
        var_27 = (var_24 < var_26);
        if (var_27) {
            // cube_idx |= 1 << i                                                                 <L 1471>
            var_29 = wp::lshift(var_28, var_5);
            var_30 = wp::bit_or(var_4, var_29);
        }
        var_31 = wp::where(var_27, var_30, var_4);
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 1468>
        var_33 = wp::address(var_corner_offsets_table, var_32);
        var_35 = wp::load(var_33);
        var_34 = wp::vec_t<3, wp::int32>(var_35);
        // v = sdf_values[(x + co[0]) * ny * nz + (y + co[1]) * nz + (z + co[2])]                 <L 1469>
        var_37 = wp::extract(var_34, var_36);
        var_38 = wp::add(var_0, var_37);
        var_39 = wp::mul(var_38, var_ny);
        var_40 = wp::mul(var_39, var_nz);
        var_42 = wp::extract(var_34, var_41);
        var_43 = wp::add(var_1, var_42);
        var_44 = wp::mul(var_43, var_nz);
        var_45 = wp::add(var_40, var_44);
        var_47 = wp::extract(var_34, var_46);
        var_48 = wp::add(var_2, var_47);
        var_49 = wp::add(var_45, var_48);
        var_50 = wp::address(var_sdf_values, var_49);
        var_52 = wp::load(var_50);
        var_51 = wp::copy(var_52);
        // if v < 0.0:                                                                            <L 1470>
        var_54 = (var_51 < var_53);
        if (var_54) {
            // cube_idx |= 1 << i                                                                 <L 1471>
            var_56 = wp::lshift(var_55, var_32);
            var_57 = wp::bit_or(var_31, var_56);
        }
        var_58 = wp::where(var_54, var_57, var_31);
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 1468>
        var_60 = wp::address(var_corner_offsets_table, var_59);
        var_62 = wp::load(var_60);
        var_61 = wp::vec_t<3, wp::int32>(var_62);
        // v = sdf_values[(x + co[0]) * ny * nz + (y + co[1]) * nz + (z + co[2])]                 <L 1469>
        var_64 = wp::extract(var_61, var_63);
        var_65 = wp::add(var_0, var_64);
        var_66 = wp::mul(var_65, var_ny);
        var_67 = wp::mul(var_66, var_nz);
        var_69 = wp::extract(var_61, var_68);
        var_70 = wp::add(var_1, var_69);
        var_71 = wp::mul(var_70, var_nz);
        var_72 = wp::add(var_67, var_71);
        var_74 = wp::extract(var_61, var_73);
        var_75 = wp::add(var_2, var_74);
        var_76 = wp::add(var_72, var_75);
        var_77 = wp::address(var_sdf_values, var_76);
        var_79 = wp::load(var_77);
        var_78 = wp::copy(var_79);
        // if v < 0.0:                                                                            <L 1470>
        var_81 = (var_78 < var_80);
        if (var_81) {
            // cube_idx |= 1 << i                                                                 <L 1471>
            var_83 = wp::lshift(var_82, var_59);
            var_84 = wp::bit_or(var_58, var_83);
        }
        var_85 = wp::where(var_81, var_84, var_58);
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 1468>
        var_87 = wp::address(var_corner_offsets_table, var_86);
        var_89 = wp::load(var_87);
        var_88 = wp::vec_t<3, wp::int32>(var_89);
        // v = sdf_values[(x + co[0]) * ny * nz + (y + co[1]) * nz + (z + co[2])]                 <L 1469>
        var_91 = wp::extract(var_88, var_90);
        var_92 = wp::add(var_0, var_91);
        var_93 = wp::mul(var_92, var_ny);
        var_94 = wp::mul(var_93, var_nz);
        var_96 = wp::extract(var_88, var_95);
        var_97 = wp::add(var_1, var_96);
        var_98 = wp::mul(var_97, var_nz);
        var_99 = wp::add(var_94, var_98);
        var_101 = wp::extract(var_88, var_100);
        var_102 = wp::add(var_2, var_101);
        var_103 = wp::add(var_99, var_102);
        var_104 = wp::address(var_sdf_values, var_103);
        var_106 = wp::load(var_104);
        var_105 = wp::copy(var_106);
        // if v < 0.0:                                                                            <L 1470>
        var_108 = (var_105 < var_107);
        if (var_108) {
            // cube_idx |= 1 << i                                                                 <L 1471>
            var_110 = wp::lshift(var_109, var_86);
            var_111 = wp::bit_or(var_85, var_110);
        }
        var_112 = wp::where(var_108, var_111, var_85);
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 1468>
        var_114 = wp::address(var_corner_offsets_table, var_113);
        var_116 = wp::load(var_114);
        var_115 = wp::vec_t<3, wp::int32>(var_116);
        // v = sdf_values[(x + co[0]) * ny * nz + (y + co[1]) * nz + (z + co[2])]                 <L 1469>
        var_118 = wp::extract(var_115, var_117);
        var_119 = wp::add(var_0, var_118);
        var_120 = wp::mul(var_119, var_ny);
        var_121 = wp::mul(var_120, var_nz);
        var_123 = wp::extract(var_115, var_122);
        var_124 = wp::add(var_1, var_123);
        var_125 = wp::mul(var_124, var_nz);
        var_126 = wp::add(var_121, var_125);
        var_128 = wp::extract(var_115, var_127);
        var_129 = wp::add(var_2, var_128);
        var_130 = wp::add(var_126, var_129);
        var_131 = wp::address(var_sdf_values, var_130);
        var_133 = wp::load(var_131);
        var_132 = wp::copy(var_133);
        // if v < 0.0:                                                                            <L 1470>
        var_135 = (var_132 < var_134);
        if (var_135) {
            // cube_idx |= 1 << i                                                                 <L 1471>
            var_137 = wp::lshift(var_136, var_113);
            var_138 = wp::bit_or(var_112, var_137);
        }
        var_139 = wp::where(var_135, var_138, var_112);
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 1468>
        var_141 = wp::address(var_corner_offsets_table, var_140);
        var_143 = wp::load(var_141);
        var_142 = wp::vec_t<3, wp::int32>(var_143);
        // v = sdf_values[(x + co[0]) * ny * nz + (y + co[1]) * nz + (z + co[2])]                 <L 1469>
        var_145 = wp::extract(var_142, var_144);
        var_146 = wp::add(var_0, var_145);
        var_147 = wp::mul(var_146, var_ny);
        var_148 = wp::mul(var_147, var_nz);
        var_150 = wp::extract(var_142, var_149);
        var_151 = wp::add(var_1, var_150);
        var_152 = wp::mul(var_151, var_nz);
        var_153 = wp::add(var_148, var_152);
        var_155 = wp::extract(var_142, var_154);
        var_156 = wp::add(var_2, var_155);
        var_157 = wp::add(var_153, var_156);
        var_158 = wp::address(var_sdf_values, var_157);
        var_160 = wp::load(var_158);
        var_159 = wp::copy(var_160);
        // if v < 0.0:                                                                            <L 1470>
        var_162 = (var_159 < var_161);
        if (var_162) {
            // cube_idx |= 1 << i                                                                 <L 1471>
            var_164 = wp::lshift(var_163, var_140);
            var_165 = wp::bit_or(var_139, var_164);
        }
        var_166 = wp::where(var_162, var_165, var_139);
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 1468>
        var_168 = wp::address(var_corner_offsets_table, var_167);
        var_170 = wp::load(var_168);
        var_169 = wp::vec_t<3, wp::int32>(var_170);
        // v = sdf_values[(x + co[0]) * ny * nz + (y + co[1]) * nz + (z + co[2])]                 <L 1469>
        var_172 = wp::extract(var_169, var_171);
        var_173 = wp::add(var_0, var_172);
        var_174 = wp::mul(var_173, var_ny);
        var_175 = wp::mul(var_174, var_nz);
        var_177 = wp::extract(var_169, var_176);
        var_178 = wp::add(var_1, var_177);
        var_179 = wp::mul(var_178, var_nz);
        var_180 = wp::add(var_175, var_179);
        var_182 = wp::extract(var_169, var_181);
        var_183 = wp::add(var_2, var_182);
        var_184 = wp::add(var_180, var_183);
        var_185 = wp::address(var_sdf_values, var_184);
        var_187 = wp::load(var_185);
        var_186 = wp::copy(var_187);
        // if v < 0.0:                                                                            <L 1470>
        var_189 = (var_186 < var_188);
        if (var_189) {
            // cube_idx |= 1 << i                                                                 <L 1471>
            var_191 = wp::lshift(var_190, var_167);
            var_192 = wp::bit_or(var_166, var_191);
        }
        var_193 = wp::where(var_189, var_192, var_166);
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 1468>
        var_195 = wp::address(var_corner_offsets_table, var_194);
        var_197 = wp::load(var_195);
        var_196 = wp::vec_t<3, wp::int32>(var_197);
        // v = sdf_values[(x + co[0]) * ny * nz + (y + co[1]) * nz + (z + co[2])]                 <L 1469>
        var_199 = wp::extract(var_196, var_198);
        var_200 = wp::add(var_0, var_199);
        var_201 = wp::mul(var_200, var_ny);
        var_202 = wp::mul(var_201, var_nz);
        var_204 = wp::extract(var_196, var_203);
        var_205 = wp::add(var_1, var_204);
        var_206 = wp::mul(var_205, var_nz);
        var_207 = wp::add(var_202, var_206);
        var_209 = wp::extract(var_196, var_208);
        var_210 = wp::add(var_2, var_209);
        var_211 = wp::add(var_207, var_210);
        var_212 = wp::address(var_sdf_values, var_211);
        var_214 = wp::load(var_212);
        var_213 = wp::copy(var_214);
        // if v < 0.0:                                                                            <L 1470>
        var_216 = (var_213 < var_215);
        if (var_216) {
            // cube_idx |= 1 << i                                                                 <L 1471>
            var_218 = wp::lshift(var_217, var_194);
            var_219 = wp::bit_or(var_193, var_218);
        }
        var_220 = wp::where(var_216, var_219, var_193);
        // tri_start = tri_range_table[cube_idx]                                                  <L 1472>
        var_221 = wp::address(var_tri_range_table, var_220);
        var_223 = wp::load(var_221);
        var_222 = wp::copy(var_223);
        // tri_end = tri_range_table[cube_idx + 1]                                                <L 1473>
        var_225 = wp::add(var_220, var_224);
        var_226 = wp::address(var_tri_range_table, var_225);
        var_228 = wp::load(var_226);
        var_227 = wp::copy(var_228);
        // num_faces = (tri_end - tri_start) // 3                                                 <L 1474>
        var_229 = wp::sub(var_227, var_222);
        var_231 = wp::floordiv(var_229, var_230);
        // if num_faces > 0:                                                                      <L 1475>
        var_233 = (var_231 > var_232);
        if (var_233) {
            // wp.atomic_add(face_count, 0, num_faces)                                            <L 1476>
            var_235 = wp::atomic_add(var_face_count, var_234, var_231);
        }
    }
}



extern "C" __global__ void _generate_dense_mc_kernel_3e4a6177_cuda_kernel_forward(
    wp::launch_bounds_t<3> dim,
    wp::array_t<wp::float32> var_sdf_values,
    wp::int32 var_ny,
    wp::int32 var_nz,
    wp::vec_t<3, wp::float32> var_origin,
    wp::vec_t<3, wp::float32> var_voxel_size,
    wp::array_t<wp::int32> var_tri_range_table,
    wp::array_t<wp::vec_t<2, wp::uint8>> var_flat_edge_verts_table,
    wp::array_t<wp::vec_t<3, wp::uint8>> var_corner_offsets_table,
    wp::array_t<wp::int32> var_face_count,
    wp::array_t<wp::vec_t<3, wp::float32>> var_vertices,
    wp::array_t<wp::vec_t<3, wp::float32>> var_face_normals)
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
        const wp::int32 var_3 = 0;
        wp::int32 var_4;
        wp::vec_t<8, wp::float32> var_5;
        const wp::int32 var_6 = 0;
        wp::vec_t<3, wp::uint8>* var_7;
        wp::vec_t<3, wp::int32> var_8;
        wp::vec_t<3, wp::uint8> var_9;
        const wp::int32 var_10 = 0;
        wp::int32 var_11;
        wp::int32 var_12;
        wp::int32 var_13;
        wp::int32 var_14;
        const wp::int32 var_15 = 1;
        wp::int32 var_16;
        wp::int32 var_17;
        wp::int32 var_18;
        wp::int32 var_19;
        const wp::int32 var_20 = 2;
        wp::int32 var_21;
        wp::int32 var_22;
        wp::int32 var_23;
        wp::float32* var_24;
        wp::float32 var_25;
        wp::float32 var_26;
        const wp::float32 var_27 = 0.0;
        bool var_28;
        const wp::int32 var_29 = 1;
        wp::int32 var_30;
        wp::int32 var_31;
        wp::int32 var_32;
        const wp::int32 var_33 = 1;
        wp::vec_t<3, wp::uint8>* var_34;
        wp::vec_t<3, wp::int32> var_35;
        wp::vec_t<3, wp::uint8> var_36;
        const wp::int32 var_37 = 0;
        wp::int32 var_38;
        wp::int32 var_39;
        wp::int32 var_40;
        wp::int32 var_41;
        const wp::int32 var_42 = 1;
        wp::int32 var_43;
        wp::int32 var_44;
        wp::int32 var_45;
        wp::int32 var_46;
        const wp::int32 var_47 = 2;
        wp::int32 var_48;
        wp::int32 var_49;
        wp::int32 var_50;
        wp::float32* var_51;
        wp::float32 var_52;
        wp::float32 var_53;
        const wp::float32 var_54 = 0.0;
        bool var_55;
        const wp::int32 var_56 = 1;
        wp::int32 var_57;
        wp::int32 var_58;
        wp::int32 var_59;
        const wp::int32 var_60 = 2;
        wp::vec_t<3, wp::uint8>* var_61;
        wp::vec_t<3, wp::int32> var_62;
        wp::vec_t<3, wp::uint8> var_63;
        const wp::int32 var_64 = 0;
        wp::int32 var_65;
        wp::int32 var_66;
        wp::int32 var_67;
        wp::int32 var_68;
        const wp::int32 var_69 = 1;
        wp::int32 var_70;
        wp::int32 var_71;
        wp::int32 var_72;
        wp::int32 var_73;
        const wp::int32 var_74 = 2;
        wp::int32 var_75;
        wp::int32 var_76;
        wp::int32 var_77;
        wp::float32* var_78;
        wp::float32 var_79;
        wp::float32 var_80;
        const wp::float32 var_81 = 0.0;
        bool var_82;
        const wp::int32 var_83 = 1;
        wp::int32 var_84;
        wp::int32 var_85;
        wp::int32 var_86;
        const wp::int32 var_87 = 3;
        wp::vec_t<3, wp::uint8>* var_88;
        wp::vec_t<3, wp::int32> var_89;
        wp::vec_t<3, wp::uint8> var_90;
        const wp::int32 var_91 = 0;
        wp::int32 var_92;
        wp::int32 var_93;
        wp::int32 var_94;
        wp::int32 var_95;
        const wp::int32 var_96 = 1;
        wp::int32 var_97;
        wp::int32 var_98;
        wp::int32 var_99;
        wp::int32 var_100;
        const wp::int32 var_101 = 2;
        wp::int32 var_102;
        wp::int32 var_103;
        wp::int32 var_104;
        wp::float32* var_105;
        wp::float32 var_106;
        wp::float32 var_107;
        const wp::float32 var_108 = 0.0;
        bool var_109;
        const wp::int32 var_110 = 1;
        wp::int32 var_111;
        wp::int32 var_112;
        wp::int32 var_113;
        const wp::int32 var_114 = 4;
        wp::vec_t<3, wp::uint8>* var_115;
        wp::vec_t<3, wp::int32> var_116;
        wp::vec_t<3, wp::uint8> var_117;
        const wp::int32 var_118 = 0;
        wp::int32 var_119;
        wp::int32 var_120;
        wp::int32 var_121;
        wp::int32 var_122;
        const wp::int32 var_123 = 1;
        wp::int32 var_124;
        wp::int32 var_125;
        wp::int32 var_126;
        wp::int32 var_127;
        const wp::int32 var_128 = 2;
        wp::int32 var_129;
        wp::int32 var_130;
        wp::int32 var_131;
        wp::float32* var_132;
        wp::float32 var_133;
        wp::float32 var_134;
        const wp::float32 var_135 = 0.0;
        bool var_136;
        const wp::int32 var_137 = 1;
        wp::int32 var_138;
        wp::int32 var_139;
        wp::int32 var_140;
        const wp::int32 var_141 = 5;
        wp::vec_t<3, wp::uint8>* var_142;
        wp::vec_t<3, wp::int32> var_143;
        wp::vec_t<3, wp::uint8> var_144;
        const wp::int32 var_145 = 0;
        wp::int32 var_146;
        wp::int32 var_147;
        wp::int32 var_148;
        wp::int32 var_149;
        const wp::int32 var_150 = 1;
        wp::int32 var_151;
        wp::int32 var_152;
        wp::int32 var_153;
        wp::int32 var_154;
        const wp::int32 var_155 = 2;
        wp::int32 var_156;
        wp::int32 var_157;
        wp::int32 var_158;
        wp::float32* var_159;
        wp::float32 var_160;
        wp::float32 var_161;
        const wp::float32 var_162 = 0.0;
        bool var_163;
        const wp::int32 var_164 = 1;
        wp::int32 var_165;
        wp::int32 var_166;
        wp::int32 var_167;
        const wp::int32 var_168 = 6;
        wp::vec_t<3, wp::uint8>* var_169;
        wp::vec_t<3, wp::int32> var_170;
        wp::vec_t<3, wp::uint8> var_171;
        const wp::int32 var_172 = 0;
        wp::int32 var_173;
        wp::int32 var_174;
        wp::int32 var_175;
        wp::int32 var_176;
        const wp::int32 var_177 = 1;
        wp::int32 var_178;
        wp::int32 var_179;
        wp::int32 var_180;
        wp::int32 var_181;
        const wp::int32 var_182 = 2;
        wp::int32 var_183;
        wp::int32 var_184;
        wp::int32 var_185;
        wp::float32* var_186;
        wp::float32 var_187;
        wp::float32 var_188;
        const wp::float32 var_189 = 0.0;
        bool var_190;
        const wp::int32 var_191 = 1;
        wp::int32 var_192;
        wp::int32 var_193;
        wp::int32 var_194;
        const wp::int32 var_195 = 7;
        wp::vec_t<3, wp::uint8>* var_196;
        wp::vec_t<3, wp::int32> var_197;
        wp::vec_t<3, wp::uint8> var_198;
        const wp::int32 var_199 = 0;
        wp::int32 var_200;
        wp::int32 var_201;
        wp::int32 var_202;
        wp::int32 var_203;
        const wp::int32 var_204 = 1;
        wp::int32 var_205;
        wp::int32 var_206;
        wp::int32 var_207;
        wp::int32 var_208;
        const wp::int32 var_209 = 2;
        wp::int32 var_210;
        wp::int32 var_211;
        wp::int32 var_212;
        wp::float32* var_213;
        wp::float32 var_214;
        wp::float32 var_215;
        const wp::float32 var_216 = 0.0;
        bool var_217;
        const wp::int32 var_218 = 1;
        wp::int32 var_219;
        wp::int32 var_220;
        wp::int32 var_221;
        wp::int32* var_222;
        wp::int32 var_223;
        wp::int32 var_224;
        const wp::int32 var_225 = 1;
        wp::int32 var_226;
        wp::int32* var_227;
        wp::int32 var_228;
        wp::int32 var_229;
        wp::int32 var_230;
        const wp::int32 var_231 = 3;
        wp::int32 var_232;
        const wp::int32 var_233 = 0;
        wp::int32 var_234;
        const wp::int32 var_235 = 0;
        bool var_236;
        wp::float32 var_237;
        wp::float32 var_238;
        wp::float32 var_239;
        wp::vec_t<3, wp::float32> var_240;
        const wp::int32 var_241 = 0;
        bool var_242;
        wp::mat_t<3, 3, wp::float32> var_243;
        const wp::int32 var_244 = 0;
        const wp::int32 var_245 = 3;
        wp::int32 var_246;
        wp::int32 var_247;
        wp::int32 var_248;
        wp::vec_t<2, wp::uint8>* var_249;
        wp::vec_t<2, wp::int32> var_250;
        wp::vec_t<2, wp::uint8> var_251;
        const wp::int32 var_252 = 0;
        wp::int32 var_253;
        wp::float32 var_254;
        wp::float32 var_255;
        const wp::int32 var_256 = 1;
        wp::int32 var_257;
        wp::float32 var_258;
        wp::float32 var_259;
        const wp::int32 var_260 = 0;
        wp::int32 var_261;
        wp::vec_t<3, wp::uint8>* var_262;
        wp::vec_t<3, wp::float32> var_263;
        wp::vec_t<3, wp::uint8> var_264;
        const wp::int32 var_265 = 1;
        wp::int32 var_266;
        wp::vec_t<3, wp::uint8>* var_267;
        wp::vec_t<3, wp::float32> var_268;
        wp::vec_t<3, wp::uint8> var_269;
        wp::float32 var_270;
        wp::float32 var_271;
        const wp::float32 var_272 = 1e-10;
        bool var_273;
        const wp::float32 var_274 = 0.5;
        wp::vec_t<3, wp::float32> var_275;
        wp::vec_t<3, wp::float32> var_276;
        const wp::float32 var_277 = 0.0;
        wp::float32 var_278;
        wp::float32 var_279;
        const wp::float32 var_280 = 0.02;
        const wp::float32 var_281 = 0.98;
        wp::float32 var_282;
        wp::vec_t<3, wp::float32> var_283;
        wp::vec_t<3, wp::float32> var_284;
        wp::vec_t<3, wp::float32> var_285;
        wp::vec_t<3, wp::float32> var_286;
        wp::vec_t<3, wp::float32> var_287;
        const wp::int32 var_288 = 0;
        wp::float32 var_289;
        const wp::int32 var_290 = 0;
        wp::float32 var_291;
        const wp::int32 var_292 = 0;
        wp::float32 var_293;
        wp::float32 var_294;
        wp::float32 var_295;
        const wp::int32 var_296 = 1;
        wp::float32 var_297;
        const wp::int32 var_298 = 1;
        wp::float32 var_299;
        const wp::int32 var_300 = 1;
        wp::float32 var_301;
        wp::float32 var_302;
        wp::float32 var_303;
        const wp::int32 var_304 = 2;
        wp::float32 var_305;
        const wp::int32 var_306 = 2;
        wp::float32 var_307;
        const wp::int32 var_308 = 2;
        wp::float32 var_309;
        wp::float32 var_310;
        wp::float32 var_311;
        wp::vec_t<3, wp::float32> var_312;
        const wp::int32 var_313 = 1;
        const wp::int32 var_314 = 3;
        wp::int32 var_315;
        wp::int32 var_316;
        wp::int32 var_317;
        wp::vec_t<2, wp::uint8>* var_318;
        wp::vec_t<2, wp::int32> var_319;
        wp::vec_t<2, wp::uint8> var_320;
        const wp::int32 var_321 = 0;
        wp::int32 var_322;
        wp::float32 var_323;
        wp::float32 var_324;
        const wp::int32 var_325 = 1;
        wp::int32 var_326;
        wp::float32 var_327;
        wp::float32 var_328;
        const wp::int32 var_329 = 0;
        wp::int32 var_330;
        wp::vec_t<3, wp::uint8>* var_331;
        wp::vec_t<3, wp::float32> var_332;
        wp::vec_t<3, wp::uint8> var_333;
        const wp::int32 var_334 = 1;
        wp::int32 var_335;
        wp::vec_t<3, wp::uint8>* var_336;
        wp::vec_t<3, wp::float32> var_337;
        wp::vec_t<3, wp::uint8> var_338;
        wp::float32 var_339;
        wp::float32 var_340;
        bool var_341;
        const wp::float32 var_342 = 0.5;
        wp::vec_t<3, wp::float32> var_343;
        wp::vec_t<3, wp::float32> var_344;
        const wp::float32 var_345 = 0.0;
        wp::float32 var_346;
        wp::float32 var_347;
        wp::float32 var_348;
        wp::vec_t<3, wp::float32> var_349;
        wp::vec_t<3, wp::float32> var_350;
        wp::vec_t<3, wp::float32> var_351;
        wp::vec_t<3, wp::float32> var_352;
        wp::float32 var_353;
        wp::vec_t<3, wp::float32> var_354;
        const wp::int32 var_355 = 0;
        wp::float32 var_356;
        const wp::int32 var_357 = 0;
        wp::float32 var_358;
        const wp::int32 var_359 = 0;
        wp::float32 var_360;
        wp::float32 var_361;
        wp::float32 var_362;
        const wp::int32 var_363 = 1;
        wp::float32 var_364;
        const wp::int32 var_365 = 1;
        wp::float32 var_366;
        const wp::int32 var_367 = 1;
        wp::float32 var_368;
        wp::float32 var_369;
        wp::float32 var_370;
        const wp::int32 var_371 = 2;
        wp::float32 var_372;
        const wp::int32 var_373 = 2;
        wp::float32 var_374;
        const wp::int32 var_375 = 2;
        wp::float32 var_376;
        wp::float32 var_377;
        wp::float32 var_378;
        wp::vec_t<3, wp::float32> var_379;
        const wp::int32 var_380 = 2;
        const wp::int32 var_381 = 3;
        wp::int32 var_382;
        wp::int32 var_383;
        wp::int32 var_384;
        wp::vec_t<2, wp::uint8>* var_385;
        wp::vec_t<2, wp::int32> var_386;
        wp::vec_t<2, wp::uint8> var_387;
        const wp::int32 var_388 = 0;
        wp::int32 var_389;
        wp::float32 var_390;
        wp::float32 var_391;
        const wp::int32 var_392 = 1;
        wp::int32 var_393;
        wp::float32 var_394;
        wp::float32 var_395;
        const wp::int32 var_396 = 0;
        wp::int32 var_397;
        wp::vec_t<3, wp::uint8>* var_398;
        wp::vec_t<3, wp::float32> var_399;
        wp::vec_t<3, wp::uint8> var_400;
        const wp::int32 var_401 = 1;
        wp::int32 var_402;
        wp::vec_t<3, wp::uint8>* var_403;
        wp::vec_t<3, wp::float32> var_404;
        wp::vec_t<3, wp::uint8> var_405;
        wp::float32 var_406;
        wp::float32 var_407;
        bool var_408;
        const wp::float32 var_409 = 0.5;
        wp::vec_t<3, wp::float32> var_410;
        wp::vec_t<3, wp::float32> var_411;
        const wp::float32 var_412 = 0.0;
        wp::float32 var_413;
        wp::float32 var_414;
        wp::float32 var_415;
        wp::vec_t<3, wp::float32> var_416;
        wp::vec_t<3, wp::float32> var_417;
        wp::vec_t<3, wp::float32> var_418;
        wp::vec_t<3, wp::float32> var_419;
        wp::float32 var_420;
        wp::vec_t<3, wp::float32> var_421;
        const wp::int32 var_422 = 0;
        wp::float32 var_423;
        const wp::int32 var_424 = 0;
        wp::float32 var_425;
        const wp::int32 var_426 = 0;
        wp::float32 var_427;
        wp::float32 var_428;
        wp::float32 var_429;
        const wp::int32 var_430 = 1;
        wp::float32 var_431;
        const wp::int32 var_432 = 1;
        wp::float32 var_433;
        const wp::int32 var_434 = 1;
        wp::float32 var_435;
        wp::float32 var_436;
        wp::float32 var_437;
        const wp::int32 var_438 = 2;
        wp::float32 var_439;
        const wp::int32 var_440 = 2;
        wp::float32 var_441;
        const wp::int32 var_442 = 2;
        wp::float32 var_443;
        wp::float32 var_444;
        wp::float32 var_445;
        wp::vec_t<3, wp::float32> var_446;
        const wp::int32 var_447 = 1;
        wp::vec_t<3, wp::float32> var_448;
        const wp::int32 var_449 = 0;
        wp::vec_t<3, wp::float32> var_450;
        wp::vec_t<3, wp::float32> var_451;
        const wp::int32 var_452 = 2;
        wp::vec_t<3, wp::float32> var_453;
        const wp::int32 var_454 = 0;
        wp::vec_t<3, wp::float32> var_455;
        wp::vec_t<3, wp::float32> var_456;
        wp::vec_t<3, wp::float32> var_457;
        wp::float32 var_458;
        const wp::float32 var_459 = 1e-20;
        bool var_460;
        const wp::float32 var_461 = 0.0;
        const wp::float32 var_462 = 0.0;
        const wp::float32 var_463 = 1.0;
        wp::vec_t<3, wp::float32> var_464;
        wp::float32 var_465;
        wp::vec_t<3, wp::float32> var_466;
        wp::vec_t<3, wp::float32> var_467;
        const wp::int32 var_468 = 0;
        wp::vec_t<3, wp::float32> var_469;
        wp::vec_t<3, wp::float32> var_470;
        const wp::int32 var_471 = 3;
        wp::int32 var_472;
        const wp::int32 var_473 = 3;
        wp::int32 var_474;
        wp::int32 var_475;
        const wp::int32 var_476 = 0;
        wp::int32 var_477;
        const wp::int32 var_478 = 1;
        wp::vec_t<3, wp::float32> var_479;
        wp::vec_t<3, wp::float32> var_480;
        const wp::int32 var_481 = 3;
        wp::int32 var_482;
        const wp::int32 var_483 = 3;
        wp::int32 var_484;
        wp::int32 var_485;
        const wp::int32 var_486 = 1;
        wp::int32 var_487;
        const wp::int32 var_488 = 2;
        wp::vec_t<3, wp::float32> var_489;
        wp::vec_t<3, wp::float32> var_490;
        const wp::int32 var_491 = 3;
        wp::int32 var_492;
        const wp::int32 var_493 = 3;
        wp::int32 var_494;
        wp::int32 var_495;
        const wp::int32 var_496 = 2;
        wp::int32 var_497;
        wp::int32 var_498;
        const wp::int32 var_499 = 1;
        bool var_500;
        wp::mat_t<3, 3, wp::float32> var_501;
        const wp::int32 var_502 = 0;
        const wp::int32 var_503 = 3;
        wp::int32 var_504;
        wp::int32 var_505;
        wp::int32 var_506;
        wp::vec_t<2, wp::uint8>* var_507;
        wp::vec_t<2, wp::int32> var_508;
        wp::vec_t<2, wp::uint8> var_509;
        const wp::int32 var_510 = 0;
        wp::int32 var_511;
        wp::float32 var_512;
        wp::float32 var_513;
        const wp::int32 var_514 = 1;
        wp::int32 var_515;
        wp::float32 var_516;
        wp::float32 var_517;
        const wp::int32 var_518 = 0;
        wp::int32 var_519;
        wp::vec_t<3, wp::uint8>* var_520;
        wp::vec_t<3, wp::float32> var_521;
        wp::vec_t<3, wp::uint8> var_522;
        const wp::int32 var_523 = 1;
        wp::int32 var_524;
        wp::vec_t<3, wp::uint8>* var_525;
        wp::vec_t<3, wp::float32> var_526;
        wp::vec_t<3, wp::uint8> var_527;
        wp::float32 var_528;
        wp::float32 var_529;
        bool var_530;
        const wp::float32 var_531 = 0.5;
        wp::vec_t<3, wp::float32> var_532;
        wp::vec_t<3, wp::float32> var_533;
        const wp::float32 var_534 = 0.0;
        wp::float32 var_535;
        wp::float32 var_536;
        wp::float32 var_537;
        wp::vec_t<3, wp::float32> var_538;
        wp::vec_t<3, wp::float32> var_539;
        wp::vec_t<3, wp::float32> var_540;
        wp::vec_t<3, wp::float32> var_541;
        wp::float32 var_542;
        wp::vec_t<3, wp::float32> var_543;
        const wp::int32 var_544 = 0;
        wp::float32 var_545;
        const wp::int32 var_546 = 0;
        wp::float32 var_547;
        const wp::int32 var_548 = 0;
        wp::float32 var_549;
        wp::float32 var_550;
        wp::float32 var_551;
        const wp::int32 var_552 = 1;
        wp::float32 var_553;
        const wp::int32 var_554 = 1;
        wp::float32 var_555;
        const wp::int32 var_556 = 1;
        wp::float32 var_557;
        wp::float32 var_558;
        wp::float32 var_559;
        const wp::int32 var_560 = 2;
        wp::float32 var_561;
        const wp::int32 var_562 = 2;
        wp::float32 var_563;
        const wp::int32 var_564 = 2;
        wp::float32 var_565;
        wp::float32 var_566;
        wp::float32 var_567;
        wp::vec_t<3, wp::float32> var_568;
        const wp::int32 var_569 = 1;
        const wp::int32 var_570 = 3;
        wp::int32 var_571;
        wp::int32 var_572;
        wp::int32 var_573;
        wp::vec_t<2, wp::uint8>* var_574;
        wp::vec_t<2, wp::int32> var_575;
        wp::vec_t<2, wp::uint8> var_576;
        const wp::int32 var_577 = 0;
        wp::int32 var_578;
        wp::float32 var_579;
        wp::float32 var_580;
        const wp::int32 var_581 = 1;
        wp::int32 var_582;
        wp::float32 var_583;
        wp::float32 var_584;
        const wp::int32 var_585 = 0;
        wp::int32 var_586;
        wp::vec_t<3, wp::uint8>* var_587;
        wp::vec_t<3, wp::float32> var_588;
        wp::vec_t<3, wp::uint8> var_589;
        const wp::int32 var_590 = 1;
        wp::int32 var_591;
        wp::vec_t<3, wp::uint8>* var_592;
        wp::vec_t<3, wp::float32> var_593;
        wp::vec_t<3, wp::uint8> var_594;
        wp::float32 var_595;
        wp::float32 var_596;
        bool var_597;
        const wp::float32 var_598 = 0.5;
        wp::vec_t<3, wp::float32> var_599;
        wp::vec_t<3, wp::float32> var_600;
        const wp::float32 var_601 = 0.0;
        wp::float32 var_602;
        wp::float32 var_603;
        wp::float32 var_604;
        wp::vec_t<3, wp::float32> var_605;
        wp::vec_t<3, wp::float32> var_606;
        wp::vec_t<3, wp::float32> var_607;
        wp::vec_t<3, wp::float32> var_608;
        wp::float32 var_609;
        wp::vec_t<3, wp::float32> var_610;
        const wp::int32 var_611 = 0;
        wp::float32 var_612;
        const wp::int32 var_613 = 0;
        wp::float32 var_614;
        const wp::int32 var_615 = 0;
        wp::float32 var_616;
        wp::float32 var_617;
        wp::float32 var_618;
        const wp::int32 var_619 = 1;
        wp::float32 var_620;
        const wp::int32 var_621 = 1;
        wp::float32 var_622;
        const wp::int32 var_623 = 1;
        wp::float32 var_624;
        wp::float32 var_625;
        wp::float32 var_626;
        const wp::int32 var_627 = 2;
        wp::float32 var_628;
        const wp::int32 var_629 = 2;
        wp::float32 var_630;
        const wp::int32 var_631 = 2;
        wp::float32 var_632;
        wp::float32 var_633;
        wp::float32 var_634;
        wp::vec_t<3, wp::float32> var_635;
        const wp::int32 var_636 = 2;
        const wp::int32 var_637 = 3;
        wp::int32 var_638;
        wp::int32 var_639;
        wp::int32 var_640;
        wp::vec_t<2, wp::uint8>* var_641;
        wp::vec_t<2, wp::int32> var_642;
        wp::vec_t<2, wp::uint8> var_643;
        const wp::int32 var_644 = 0;
        wp::int32 var_645;
        wp::float32 var_646;
        wp::float32 var_647;
        const wp::int32 var_648 = 1;
        wp::int32 var_649;
        wp::float32 var_650;
        wp::float32 var_651;
        const wp::int32 var_652 = 0;
        wp::int32 var_653;
        wp::vec_t<3, wp::uint8>* var_654;
        wp::vec_t<3, wp::float32> var_655;
        wp::vec_t<3, wp::uint8> var_656;
        const wp::int32 var_657 = 1;
        wp::int32 var_658;
        wp::vec_t<3, wp::uint8>* var_659;
        wp::vec_t<3, wp::float32> var_660;
        wp::vec_t<3, wp::uint8> var_661;
        wp::float32 var_662;
        wp::float32 var_663;
        bool var_664;
        const wp::float32 var_665 = 0.5;
        wp::vec_t<3, wp::float32> var_666;
        wp::vec_t<3, wp::float32> var_667;
        const wp::float32 var_668 = 0.0;
        wp::float32 var_669;
        wp::float32 var_670;
        wp::float32 var_671;
        wp::vec_t<3, wp::float32> var_672;
        wp::vec_t<3, wp::float32> var_673;
        wp::vec_t<3, wp::float32> var_674;
        wp::vec_t<3, wp::float32> var_675;
        wp::float32 var_676;
        wp::vec_t<3, wp::float32> var_677;
        const wp::int32 var_678 = 0;
        wp::float32 var_679;
        const wp::int32 var_680 = 0;
        wp::float32 var_681;
        const wp::int32 var_682 = 0;
        wp::float32 var_683;
        wp::float32 var_684;
        wp::float32 var_685;
        const wp::int32 var_686 = 1;
        wp::float32 var_687;
        const wp::int32 var_688 = 1;
        wp::float32 var_689;
        const wp::int32 var_690 = 1;
        wp::float32 var_691;
        wp::float32 var_692;
        wp::float32 var_693;
        const wp::int32 var_694 = 2;
        wp::float32 var_695;
        const wp::int32 var_696 = 2;
        wp::float32 var_697;
        const wp::int32 var_698 = 2;
        wp::float32 var_699;
        wp::float32 var_700;
        wp::float32 var_701;
        wp::vec_t<3, wp::float32> var_702;
        const wp::int32 var_703 = 1;
        wp::vec_t<3, wp::float32> var_704;
        const wp::int32 var_705 = 0;
        wp::vec_t<3, wp::float32> var_706;
        wp::vec_t<3, wp::float32> var_707;
        const wp::int32 var_708 = 2;
        wp::vec_t<3, wp::float32> var_709;
        const wp::int32 var_710 = 0;
        wp::vec_t<3, wp::float32> var_711;
        wp::vec_t<3, wp::float32> var_712;
        wp::vec_t<3, wp::float32> var_713;
        wp::float32 var_714;
        bool var_715;
        const wp::float32 var_716 = 0.0;
        const wp::float32 var_717 = 0.0;
        const wp::float32 var_718 = 1.0;
        wp::vec_t<3, wp::float32> var_719;
        wp::float32 var_720;
        wp::vec_t<3, wp::float32> var_721;
        wp::vec_t<3, wp::float32> var_722;
        const wp::int32 var_723 = 0;
        wp::vec_t<3, wp::float32> var_724;
        wp::vec_t<3, wp::float32> var_725;
        const wp::int32 var_726 = 3;
        wp::int32 var_727;
        const wp::int32 var_728 = 3;
        wp::int32 var_729;
        wp::int32 var_730;
        const wp::int32 var_731 = 0;
        wp::int32 var_732;
        const wp::int32 var_733 = 1;
        wp::vec_t<3, wp::float32> var_734;
        wp::vec_t<3, wp::float32> var_735;
        const wp::int32 var_736 = 3;
        wp::int32 var_737;
        const wp::int32 var_738 = 3;
        wp::int32 var_739;
        wp::int32 var_740;
        const wp::int32 var_741 = 1;
        wp::int32 var_742;
        const wp::int32 var_743 = 2;
        wp::vec_t<3, wp::float32> var_744;
        wp::vec_t<3, wp::float32> var_745;
        const wp::int32 var_746 = 3;
        wp::int32 var_747;
        const wp::int32 var_748 = 3;
        wp::int32 var_749;
        wp::int32 var_750;
        const wp::int32 var_751 = 2;
        wp::int32 var_752;
        wp::int32 var_753;
        const wp::int32 var_754 = 2;
        bool var_755;
        wp::mat_t<3, 3, wp::float32> var_756;
        const wp::int32 var_757 = 0;
        const wp::int32 var_758 = 3;
        wp::int32 var_759;
        wp::int32 var_760;
        wp::int32 var_761;
        wp::vec_t<2, wp::uint8>* var_762;
        wp::vec_t<2, wp::int32> var_763;
        wp::vec_t<2, wp::uint8> var_764;
        const wp::int32 var_765 = 0;
        wp::int32 var_766;
        wp::float32 var_767;
        wp::float32 var_768;
        const wp::int32 var_769 = 1;
        wp::int32 var_770;
        wp::float32 var_771;
        wp::float32 var_772;
        const wp::int32 var_773 = 0;
        wp::int32 var_774;
        wp::vec_t<3, wp::uint8>* var_775;
        wp::vec_t<3, wp::float32> var_776;
        wp::vec_t<3, wp::uint8> var_777;
        const wp::int32 var_778 = 1;
        wp::int32 var_779;
        wp::vec_t<3, wp::uint8>* var_780;
        wp::vec_t<3, wp::float32> var_781;
        wp::vec_t<3, wp::uint8> var_782;
        wp::float32 var_783;
        wp::float32 var_784;
        bool var_785;
        const wp::float32 var_786 = 0.5;
        wp::vec_t<3, wp::float32> var_787;
        wp::vec_t<3, wp::float32> var_788;
        const wp::float32 var_789 = 0.0;
        wp::float32 var_790;
        wp::float32 var_791;
        wp::float32 var_792;
        wp::vec_t<3, wp::float32> var_793;
        wp::vec_t<3, wp::float32> var_794;
        wp::vec_t<3, wp::float32> var_795;
        wp::vec_t<3, wp::float32> var_796;
        wp::float32 var_797;
        wp::vec_t<3, wp::float32> var_798;
        const wp::int32 var_799 = 0;
        wp::float32 var_800;
        const wp::int32 var_801 = 0;
        wp::float32 var_802;
        const wp::int32 var_803 = 0;
        wp::float32 var_804;
        wp::float32 var_805;
        wp::float32 var_806;
        const wp::int32 var_807 = 1;
        wp::float32 var_808;
        const wp::int32 var_809 = 1;
        wp::float32 var_810;
        const wp::int32 var_811 = 1;
        wp::float32 var_812;
        wp::float32 var_813;
        wp::float32 var_814;
        const wp::int32 var_815 = 2;
        wp::float32 var_816;
        const wp::int32 var_817 = 2;
        wp::float32 var_818;
        const wp::int32 var_819 = 2;
        wp::float32 var_820;
        wp::float32 var_821;
        wp::float32 var_822;
        wp::vec_t<3, wp::float32> var_823;
        const wp::int32 var_824 = 1;
        const wp::int32 var_825 = 3;
        wp::int32 var_826;
        wp::int32 var_827;
        wp::int32 var_828;
        wp::vec_t<2, wp::uint8>* var_829;
        wp::vec_t<2, wp::int32> var_830;
        wp::vec_t<2, wp::uint8> var_831;
        const wp::int32 var_832 = 0;
        wp::int32 var_833;
        wp::float32 var_834;
        wp::float32 var_835;
        const wp::int32 var_836 = 1;
        wp::int32 var_837;
        wp::float32 var_838;
        wp::float32 var_839;
        const wp::int32 var_840 = 0;
        wp::int32 var_841;
        wp::vec_t<3, wp::uint8>* var_842;
        wp::vec_t<3, wp::float32> var_843;
        wp::vec_t<3, wp::uint8> var_844;
        const wp::int32 var_845 = 1;
        wp::int32 var_846;
        wp::vec_t<3, wp::uint8>* var_847;
        wp::vec_t<3, wp::float32> var_848;
        wp::vec_t<3, wp::uint8> var_849;
        wp::float32 var_850;
        wp::float32 var_851;
        bool var_852;
        const wp::float32 var_853 = 0.5;
        wp::vec_t<3, wp::float32> var_854;
        wp::vec_t<3, wp::float32> var_855;
        const wp::float32 var_856 = 0.0;
        wp::float32 var_857;
        wp::float32 var_858;
        wp::float32 var_859;
        wp::vec_t<3, wp::float32> var_860;
        wp::vec_t<3, wp::float32> var_861;
        wp::vec_t<3, wp::float32> var_862;
        wp::vec_t<3, wp::float32> var_863;
        wp::float32 var_864;
        wp::vec_t<3, wp::float32> var_865;
        const wp::int32 var_866 = 0;
        wp::float32 var_867;
        const wp::int32 var_868 = 0;
        wp::float32 var_869;
        const wp::int32 var_870 = 0;
        wp::float32 var_871;
        wp::float32 var_872;
        wp::float32 var_873;
        const wp::int32 var_874 = 1;
        wp::float32 var_875;
        const wp::int32 var_876 = 1;
        wp::float32 var_877;
        const wp::int32 var_878 = 1;
        wp::float32 var_879;
        wp::float32 var_880;
        wp::float32 var_881;
        const wp::int32 var_882 = 2;
        wp::float32 var_883;
        const wp::int32 var_884 = 2;
        wp::float32 var_885;
        const wp::int32 var_886 = 2;
        wp::float32 var_887;
        wp::float32 var_888;
        wp::float32 var_889;
        wp::vec_t<3, wp::float32> var_890;
        const wp::int32 var_891 = 2;
        const wp::int32 var_892 = 3;
        wp::int32 var_893;
        wp::int32 var_894;
        wp::int32 var_895;
        wp::vec_t<2, wp::uint8>* var_896;
        wp::vec_t<2, wp::int32> var_897;
        wp::vec_t<2, wp::uint8> var_898;
        const wp::int32 var_899 = 0;
        wp::int32 var_900;
        wp::float32 var_901;
        wp::float32 var_902;
        const wp::int32 var_903 = 1;
        wp::int32 var_904;
        wp::float32 var_905;
        wp::float32 var_906;
        const wp::int32 var_907 = 0;
        wp::int32 var_908;
        wp::vec_t<3, wp::uint8>* var_909;
        wp::vec_t<3, wp::float32> var_910;
        wp::vec_t<3, wp::uint8> var_911;
        const wp::int32 var_912 = 1;
        wp::int32 var_913;
        wp::vec_t<3, wp::uint8>* var_914;
        wp::vec_t<3, wp::float32> var_915;
        wp::vec_t<3, wp::uint8> var_916;
        wp::float32 var_917;
        wp::float32 var_918;
        bool var_919;
        const wp::float32 var_920 = 0.5;
        wp::vec_t<3, wp::float32> var_921;
        wp::vec_t<3, wp::float32> var_922;
        const wp::float32 var_923 = 0.0;
        wp::float32 var_924;
        wp::float32 var_925;
        wp::float32 var_926;
        wp::vec_t<3, wp::float32> var_927;
        wp::vec_t<3, wp::float32> var_928;
        wp::vec_t<3, wp::float32> var_929;
        wp::vec_t<3, wp::float32> var_930;
        wp::float32 var_931;
        wp::vec_t<3, wp::float32> var_932;
        const wp::int32 var_933 = 0;
        wp::float32 var_934;
        const wp::int32 var_935 = 0;
        wp::float32 var_936;
        const wp::int32 var_937 = 0;
        wp::float32 var_938;
        wp::float32 var_939;
        wp::float32 var_940;
        const wp::int32 var_941 = 1;
        wp::float32 var_942;
        const wp::int32 var_943 = 1;
        wp::float32 var_944;
        const wp::int32 var_945 = 1;
        wp::float32 var_946;
        wp::float32 var_947;
        wp::float32 var_948;
        const wp::int32 var_949 = 2;
        wp::float32 var_950;
        const wp::int32 var_951 = 2;
        wp::float32 var_952;
        const wp::int32 var_953 = 2;
        wp::float32 var_954;
        wp::float32 var_955;
        wp::float32 var_956;
        wp::vec_t<3, wp::float32> var_957;
        const wp::int32 var_958 = 1;
        wp::vec_t<3, wp::float32> var_959;
        const wp::int32 var_960 = 0;
        wp::vec_t<3, wp::float32> var_961;
        wp::vec_t<3, wp::float32> var_962;
        const wp::int32 var_963 = 2;
        wp::vec_t<3, wp::float32> var_964;
        const wp::int32 var_965 = 0;
        wp::vec_t<3, wp::float32> var_966;
        wp::vec_t<3, wp::float32> var_967;
        wp::vec_t<3, wp::float32> var_968;
        wp::float32 var_969;
        bool var_970;
        const wp::float32 var_971 = 0.0;
        const wp::float32 var_972 = 0.0;
        const wp::float32 var_973 = 1.0;
        wp::vec_t<3, wp::float32> var_974;
        wp::float32 var_975;
        wp::vec_t<3, wp::float32> var_976;
        wp::vec_t<3, wp::float32> var_977;
        const wp::int32 var_978 = 0;
        wp::vec_t<3, wp::float32> var_979;
        wp::vec_t<3, wp::float32> var_980;
        const wp::int32 var_981 = 3;
        wp::int32 var_982;
        const wp::int32 var_983 = 3;
        wp::int32 var_984;
        wp::int32 var_985;
        const wp::int32 var_986 = 0;
        wp::int32 var_987;
        const wp::int32 var_988 = 1;
        wp::vec_t<3, wp::float32> var_989;
        wp::vec_t<3, wp::float32> var_990;
        const wp::int32 var_991 = 3;
        wp::int32 var_992;
        const wp::int32 var_993 = 3;
        wp::int32 var_994;
        wp::int32 var_995;
        const wp::int32 var_996 = 1;
        wp::int32 var_997;
        const wp::int32 var_998 = 2;
        wp::vec_t<3, wp::float32> var_999;
        wp::vec_t<3, wp::float32> var_1000;
        const wp::int32 var_1001 = 3;
        wp::int32 var_1002;
        const wp::int32 var_1003 = 3;
        wp::int32 var_1004;
        wp::int32 var_1005;
        const wp::int32 var_1006 = 2;
        wp::int32 var_1007;
        wp::int32 var_1008;
        const wp::int32 var_1009 = 3;
        bool var_1010;
        wp::mat_t<3, 3, wp::float32> var_1011;
        const wp::int32 var_1012 = 0;
        const wp::int32 var_1013 = 3;
        wp::int32 var_1014;
        wp::int32 var_1015;
        wp::int32 var_1016;
        wp::vec_t<2, wp::uint8>* var_1017;
        wp::vec_t<2, wp::int32> var_1018;
        wp::vec_t<2, wp::uint8> var_1019;
        const wp::int32 var_1020 = 0;
        wp::int32 var_1021;
        wp::float32 var_1022;
        wp::float32 var_1023;
        const wp::int32 var_1024 = 1;
        wp::int32 var_1025;
        wp::float32 var_1026;
        wp::float32 var_1027;
        const wp::int32 var_1028 = 0;
        wp::int32 var_1029;
        wp::vec_t<3, wp::uint8>* var_1030;
        wp::vec_t<3, wp::float32> var_1031;
        wp::vec_t<3, wp::uint8> var_1032;
        const wp::int32 var_1033 = 1;
        wp::int32 var_1034;
        wp::vec_t<3, wp::uint8>* var_1035;
        wp::vec_t<3, wp::float32> var_1036;
        wp::vec_t<3, wp::uint8> var_1037;
        wp::float32 var_1038;
        wp::float32 var_1039;
        bool var_1040;
        const wp::float32 var_1041 = 0.5;
        wp::vec_t<3, wp::float32> var_1042;
        wp::vec_t<3, wp::float32> var_1043;
        const wp::float32 var_1044 = 0.0;
        wp::float32 var_1045;
        wp::float32 var_1046;
        wp::float32 var_1047;
        wp::vec_t<3, wp::float32> var_1048;
        wp::vec_t<3, wp::float32> var_1049;
        wp::vec_t<3, wp::float32> var_1050;
        wp::vec_t<3, wp::float32> var_1051;
        wp::float32 var_1052;
        wp::vec_t<3, wp::float32> var_1053;
        const wp::int32 var_1054 = 0;
        wp::float32 var_1055;
        const wp::int32 var_1056 = 0;
        wp::float32 var_1057;
        const wp::int32 var_1058 = 0;
        wp::float32 var_1059;
        wp::float32 var_1060;
        wp::float32 var_1061;
        const wp::int32 var_1062 = 1;
        wp::float32 var_1063;
        const wp::int32 var_1064 = 1;
        wp::float32 var_1065;
        const wp::int32 var_1066 = 1;
        wp::float32 var_1067;
        wp::float32 var_1068;
        wp::float32 var_1069;
        const wp::int32 var_1070 = 2;
        wp::float32 var_1071;
        const wp::int32 var_1072 = 2;
        wp::float32 var_1073;
        const wp::int32 var_1074 = 2;
        wp::float32 var_1075;
        wp::float32 var_1076;
        wp::float32 var_1077;
        wp::vec_t<3, wp::float32> var_1078;
        const wp::int32 var_1079 = 1;
        const wp::int32 var_1080 = 3;
        wp::int32 var_1081;
        wp::int32 var_1082;
        wp::int32 var_1083;
        wp::vec_t<2, wp::uint8>* var_1084;
        wp::vec_t<2, wp::int32> var_1085;
        wp::vec_t<2, wp::uint8> var_1086;
        const wp::int32 var_1087 = 0;
        wp::int32 var_1088;
        wp::float32 var_1089;
        wp::float32 var_1090;
        const wp::int32 var_1091 = 1;
        wp::int32 var_1092;
        wp::float32 var_1093;
        wp::float32 var_1094;
        const wp::int32 var_1095 = 0;
        wp::int32 var_1096;
        wp::vec_t<3, wp::uint8>* var_1097;
        wp::vec_t<3, wp::float32> var_1098;
        wp::vec_t<3, wp::uint8> var_1099;
        const wp::int32 var_1100 = 1;
        wp::int32 var_1101;
        wp::vec_t<3, wp::uint8>* var_1102;
        wp::vec_t<3, wp::float32> var_1103;
        wp::vec_t<3, wp::uint8> var_1104;
        wp::float32 var_1105;
        wp::float32 var_1106;
        bool var_1107;
        const wp::float32 var_1108 = 0.5;
        wp::vec_t<3, wp::float32> var_1109;
        wp::vec_t<3, wp::float32> var_1110;
        const wp::float32 var_1111 = 0.0;
        wp::float32 var_1112;
        wp::float32 var_1113;
        wp::float32 var_1114;
        wp::vec_t<3, wp::float32> var_1115;
        wp::vec_t<3, wp::float32> var_1116;
        wp::vec_t<3, wp::float32> var_1117;
        wp::vec_t<3, wp::float32> var_1118;
        wp::float32 var_1119;
        wp::vec_t<3, wp::float32> var_1120;
        const wp::int32 var_1121 = 0;
        wp::float32 var_1122;
        const wp::int32 var_1123 = 0;
        wp::float32 var_1124;
        const wp::int32 var_1125 = 0;
        wp::float32 var_1126;
        wp::float32 var_1127;
        wp::float32 var_1128;
        const wp::int32 var_1129 = 1;
        wp::float32 var_1130;
        const wp::int32 var_1131 = 1;
        wp::float32 var_1132;
        const wp::int32 var_1133 = 1;
        wp::float32 var_1134;
        wp::float32 var_1135;
        wp::float32 var_1136;
        const wp::int32 var_1137 = 2;
        wp::float32 var_1138;
        const wp::int32 var_1139 = 2;
        wp::float32 var_1140;
        const wp::int32 var_1141 = 2;
        wp::float32 var_1142;
        wp::float32 var_1143;
        wp::float32 var_1144;
        wp::vec_t<3, wp::float32> var_1145;
        const wp::int32 var_1146 = 2;
        const wp::int32 var_1147 = 3;
        wp::int32 var_1148;
        wp::int32 var_1149;
        wp::int32 var_1150;
        wp::vec_t<2, wp::uint8>* var_1151;
        wp::vec_t<2, wp::int32> var_1152;
        wp::vec_t<2, wp::uint8> var_1153;
        const wp::int32 var_1154 = 0;
        wp::int32 var_1155;
        wp::float32 var_1156;
        wp::float32 var_1157;
        const wp::int32 var_1158 = 1;
        wp::int32 var_1159;
        wp::float32 var_1160;
        wp::float32 var_1161;
        const wp::int32 var_1162 = 0;
        wp::int32 var_1163;
        wp::vec_t<3, wp::uint8>* var_1164;
        wp::vec_t<3, wp::float32> var_1165;
        wp::vec_t<3, wp::uint8> var_1166;
        const wp::int32 var_1167 = 1;
        wp::int32 var_1168;
        wp::vec_t<3, wp::uint8>* var_1169;
        wp::vec_t<3, wp::float32> var_1170;
        wp::vec_t<3, wp::uint8> var_1171;
        wp::float32 var_1172;
        wp::float32 var_1173;
        bool var_1174;
        const wp::float32 var_1175 = 0.5;
        wp::vec_t<3, wp::float32> var_1176;
        wp::vec_t<3, wp::float32> var_1177;
        const wp::float32 var_1178 = 0.0;
        wp::float32 var_1179;
        wp::float32 var_1180;
        wp::float32 var_1181;
        wp::vec_t<3, wp::float32> var_1182;
        wp::vec_t<3, wp::float32> var_1183;
        wp::vec_t<3, wp::float32> var_1184;
        wp::vec_t<3, wp::float32> var_1185;
        wp::float32 var_1186;
        wp::vec_t<3, wp::float32> var_1187;
        const wp::int32 var_1188 = 0;
        wp::float32 var_1189;
        const wp::int32 var_1190 = 0;
        wp::float32 var_1191;
        const wp::int32 var_1192 = 0;
        wp::float32 var_1193;
        wp::float32 var_1194;
        wp::float32 var_1195;
        const wp::int32 var_1196 = 1;
        wp::float32 var_1197;
        const wp::int32 var_1198 = 1;
        wp::float32 var_1199;
        const wp::int32 var_1200 = 1;
        wp::float32 var_1201;
        wp::float32 var_1202;
        wp::float32 var_1203;
        const wp::int32 var_1204 = 2;
        wp::float32 var_1205;
        const wp::int32 var_1206 = 2;
        wp::float32 var_1207;
        const wp::int32 var_1208 = 2;
        wp::float32 var_1209;
        wp::float32 var_1210;
        wp::float32 var_1211;
        wp::vec_t<3, wp::float32> var_1212;
        const wp::int32 var_1213 = 1;
        wp::vec_t<3, wp::float32> var_1214;
        const wp::int32 var_1215 = 0;
        wp::vec_t<3, wp::float32> var_1216;
        wp::vec_t<3, wp::float32> var_1217;
        const wp::int32 var_1218 = 2;
        wp::vec_t<3, wp::float32> var_1219;
        const wp::int32 var_1220 = 0;
        wp::vec_t<3, wp::float32> var_1221;
        wp::vec_t<3, wp::float32> var_1222;
        wp::vec_t<3, wp::float32> var_1223;
        wp::float32 var_1224;
        bool var_1225;
        const wp::float32 var_1226 = 0.0;
        const wp::float32 var_1227 = 0.0;
        const wp::float32 var_1228 = 1.0;
        wp::vec_t<3, wp::float32> var_1229;
        wp::float32 var_1230;
        wp::vec_t<3, wp::float32> var_1231;
        wp::vec_t<3, wp::float32> var_1232;
        const wp::int32 var_1233 = 0;
        wp::vec_t<3, wp::float32> var_1234;
        wp::vec_t<3, wp::float32> var_1235;
        const wp::int32 var_1236 = 3;
        wp::int32 var_1237;
        const wp::int32 var_1238 = 3;
        wp::int32 var_1239;
        wp::int32 var_1240;
        const wp::int32 var_1241 = 0;
        wp::int32 var_1242;
        const wp::int32 var_1243 = 1;
        wp::vec_t<3, wp::float32> var_1244;
        wp::vec_t<3, wp::float32> var_1245;
        const wp::int32 var_1246 = 3;
        wp::int32 var_1247;
        const wp::int32 var_1248 = 3;
        wp::int32 var_1249;
        wp::int32 var_1250;
        const wp::int32 var_1251 = 1;
        wp::int32 var_1252;
        const wp::int32 var_1253 = 2;
        wp::vec_t<3, wp::float32> var_1254;
        wp::vec_t<3, wp::float32> var_1255;
        const wp::int32 var_1256 = 3;
        wp::int32 var_1257;
        const wp::int32 var_1258 = 3;
        wp::int32 var_1259;
        wp::int32 var_1260;
        const wp::int32 var_1261 = 2;
        wp::int32 var_1262;
        wp::int32 var_1263;
        const wp::int32 var_1264 = 4;
        bool var_1265;
        wp::mat_t<3, 3, wp::float32> var_1266;
        const wp::int32 var_1267 = 0;
        const wp::int32 var_1268 = 3;
        wp::int32 var_1269;
        wp::int32 var_1270;
        wp::int32 var_1271;
        wp::vec_t<2, wp::uint8>* var_1272;
        wp::vec_t<2, wp::int32> var_1273;
        wp::vec_t<2, wp::uint8> var_1274;
        const wp::int32 var_1275 = 0;
        wp::int32 var_1276;
        wp::float32 var_1277;
        wp::float32 var_1278;
        const wp::int32 var_1279 = 1;
        wp::int32 var_1280;
        wp::float32 var_1281;
        wp::float32 var_1282;
        const wp::int32 var_1283 = 0;
        wp::int32 var_1284;
        wp::vec_t<3, wp::uint8>* var_1285;
        wp::vec_t<3, wp::float32> var_1286;
        wp::vec_t<3, wp::uint8> var_1287;
        const wp::int32 var_1288 = 1;
        wp::int32 var_1289;
        wp::vec_t<3, wp::uint8>* var_1290;
        wp::vec_t<3, wp::float32> var_1291;
        wp::vec_t<3, wp::uint8> var_1292;
        wp::float32 var_1293;
        wp::float32 var_1294;
        bool var_1295;
        const wp::float32 var_1296 = 0.5;
        wp::vec_t<3, wp::float32> var_1297;
        wp::vec_t<3, wp::float32> var_1298;
        const wp::float32 var_1299 = 0.0;
        wp::float32 var_1300;
        wp::float32 var_1301;
        wp::float32 var_1302;
        wp::vec_t<3, wp::float32> var_1303;
        wp::vec_t<3, wp::float32> var_1304;
        wp::vec_t<3, wp::float32> var_1305;
        wp::vec_t<3, wp::float32> var_1306;
        wp::float32 var_1307;
        wp::vec_t<3, wp::float32> var_1308;
        const wp::int32 var_1309 = 0;
        wp::float32 var_1310;
        const wp::int32 var_1311 = 0;
        wp::float32 var_1312;
        const wp::int32 var_1313 = 0;
        wp::float32 var_1314;
        wp::float32 var_1315;
        wp::float32 var_1316;
        const wp::int32 var_1317 = 1;
        wp::float32 var_1318;
        const wp::int32 var_1319 = 1;
        wp::float32 var_1320;
        const wp::int32 var_1321 = 1;
        wp::float32 var_1322;
        wp::float32 var_1323;
        wp::float32 var_1324;
        const wp::int32 var_1325 = 2;
        wp::float32 var_1326;
        const wp::int32 var_1327 = 2;
        wp::float32 var_1328;
        const wp::int32 var_1329 = 2;
        wp::float32 var_1330;
        wp::float32 var_1331;
        wp::float32 var_1332;
        wp::vec_t<3, wp::float32> var_1333;
        const wp::int32 var_1334 = 1;
        const wp::int32 var_1335 = 3;
        wp::int32 var_1336;
        wp::int32 var_1337;
        wp::int32 var_1338;
        wp::vec_t<2, wp::uint8>* var_1339;
        wp::vec_t<2, wp::int32> var_1340;
        wp::vec_t<2, wp::uint8> var_1341;
        const wp::int32 var_1342 = 0;
        wp::int32 var_1343;
        wp::float32 var_1344;
        wp::float32 var_1345;
        const wp::int32 var_1346 = 1;
        wp::int32 var_1347;
        wp::float32 var_1348;
        wp::float32 var_1349;
        const wp::int32 var_1350 = 0;
        wp::int32 var_1351;
        wp::vec_t<3, wp::uint8>* var_1352;
        wp::vec_t<3, wp::float32> var_1353;
        wp::vec_t<3, wp::uint8> var_1354;
        const wp::int32 var_1355 = 1;
        wp::int32 var_1356;
        wp::vec_t<3, wp::uint8>* var_1357;
        wp::vec_t<3, wp::float32> var_1358;
        wp::vec_t<3, wp::uint8> var_1359;
        wp::float32 var_1360;
        wp::float32 var_1361;
        bool var_1362;
        const wp::float32 var_1363 = 0.5;
        wp::vec_t<3, wp::float32> var_1364;
        wp::vec_t<3, wp::float32> var_1365;
        const wp::float32 var_1366 = 0.0;
        wp::float32 var_1367;
        wp::float32 var_1368;
        wp::float32 var_1369;
        wp::vec_t<3, wp::float32> var_1370;
        wp::vec_t<3, wp::float32> var_1371;
        wp::vec_t<3, wp::float32> var_1372;
        wp::vec_t<3, wp::float32> var_1373;
        wp::float32 var_1374;
        wp::vec_t<3, wp::float32> var_1375;
        const wp::int32 var_1376 = 0;
        wp::float32 var_1377;
        const wp::int32 var_1378 = 0;
        wp::float32 var_1379;
        const wp::int32 var_1380 = 0;
        wp::float32 var_1381;
        wp::float32 var_1382;
        wp::float32 var_1383;
        const wp::int32 var_1384 = 1;
        wp::float32 var_1385;
        const wp::int32 var_1386 = 1;
        wp::float32 var_1387;
        const wp::int32 var_1388 = 1;
        wp::float32 var_1389;
        wp::float32 var_1390;
        wp::float32 var_1391;
        const wp::int32 var_1392 = 2;
        wp::float32 var_1393;
        const wp::int32 var_1394 = 2;
        wp::float32 var_1395;
        const wp::int32 var_1396 = 2;
        wp::float32 var_1397;
        wp::float32 var_1398;
        wp::float32 var_1399;
        wp::vec_t<3, wp::float32> var_1400;
        const wp::int32 var_1401 = 2;
        const wp::int32 var_1402 = 3;
        wp::int32 var_1403;
        wp::int32 var_1404;
        wp::int32 var_1405;
        wp::vec_t<2, wp::uint8>* var_1406;
        wp::vec_t<2, wp::int32> var_1407;
        wp::vec_t<2, wp::uint8> var_1408;
        const wp::int32 var_1409 = 0;
        wp::int32 var_1410;
        wp::float32 var_1411;
        wp::float32 var_1412;
        const wp::int32 var_1413 = 1;
        wp::int32 var_1414;
        wp::float32 var_1415;
        wp::float32 var_1416;
        const wp::int32 var_1417 = 0;
        wp::int32 var_1418;
        wp::vec_t<3, wp::uint8>* var_1419;
        wp::vec_t<3, wp::float32> var_1420;
        wp::vec_t<3, wp::uint8> var_1421;
        const wp::int32 var_1422 = 1;
        wp::int32 var_1423;
        wp::vec_t<3, wp::uint8>* var_1424;
        wp::vec_t<3, wp::float32> var_1425;
        wp::vec_t<3, wp::uint8> var_1426;
        wp::float32 var_1427;
        wp::float32 var_1428;
        bool var_1429;
        const wp::float32 var_1430 = 0.5;
        wp::vec_t<3, wp::float32> var_1431;
        wp::vec_t<3, wp::float32> var_1432;
        const wp::float32 var_1433 = 0.0;
        wp::float32 var_1434;
        wp::float32 var_1435;
        wp::float32 var_1436;
        wp::vec_t<3, wp::float32> var_1437;
        wp::vec_t<3, wp::float32> var_1438;
        wp::vec_t<3, wp::float32> var_1439;
        wp::vec_t<3, wp::float32> var_1440;
        wp::float32 var_1441;
        wp::vec_t<3, wp::float32> var_1442;
        const wp::int32 var_1443 = 0;
        wp::float32 var_1444;
        const wp::int32 var_1445 = 0;
        wp::float32 var_1446;
        const wp::int32 var_1447 = 0;
        wp::float32 var_1448;
        wp::float32 var_1449;
        wp::float32 var_1450;
        const wp::int32 var_1451 = 1;
        wp::float32 var_1452;
        const wp::int32 var_1453 = 1;
        wp::float32 var_1454;
        const wp::int32 var_1455 = 1;
        wp::float32 var_1456;
        wp::float32 var_1457;
        wp::float32 var_1458;
        const wp::int32 var_1459 = 2;
        wp::float32 var_1460;
        const wp::int32 var_1461 = 2;
        wp::float32 var_1462;
        const wp::int32 var_1463 = 2;
        wp::float32 var_1464;
        wp::float32 var_1465;
        wp::float32 var_1466;
        wp::vec_t<3, wp::float32> var_1467;
        const wp::int32 var_1468 = 1;
        wp::vec_t<3, wp::float32> var_1469;
        const wp::int32 var_1470 = 0;
        wp::vec_t<3, wp::float32> var_1471;
        wp::vec_t<3, wp::float32> var_1472;
        const wp::int32 var_1473 = 2;
        wp::vec_t<3, wp::float32> var_1474;
        const wp::int32 var_1475 = 0;
        wp::vec_t<3, wp::float32> var_1476;
        wp::vec_t<3, wp::float32> var_1477;
        wp::vec_t<3, wp::float32> var_1478;
        wp::float32 var_1479;
        bool var_1480;
        const wp::float32 var_1481 = 0.0;
        const wp::float32 var_1482 = 0.0;
        const wp::float32 var_1483 = 1.0;
        wp::vec_t<3, wp::float32> var_1484;
        wp::float32 var_1485;
        wp::vec_t<3, wp::float32> var_1486;
        wp::vec_t<3, wp::float32> var_1487;
        const wp::int32 var_1488 = 0;
        wp::vec_t<3, wp::float32> var_1489;
        wp::vec_t<3, wp::float32> var_1490;
        const wp::int32 var_1491 = 3;
        wp::int32 var_1492;
        const wp::int32 var_1493 = 3;
        wp::int32 var_1494;
        wp::int32 var_1495;
        const wp::int32 var_1496 = 0;
        wp::int32 var_1497;
        const wp::int32 var_1498 = 1;
        wp::vec_t<3, wp::float32> var_1499;
        wp::vec_t<3, wp::float32> var_1500;
        const wp::int32 var_1501 = 3;
        wp::int32 var_1502;
        const wp::int32 var_1503 = 3;
        wp::int32 var_1504;
        wp::int32 var_1505;
        const wp::int32 var_1506 = 1;
        wp::int32 var_1507;
        const wp::int32 var_1508 = 2;
        wp::vec_t<3, wp::float32> var_1509;
        wp::vec_t<3, wp::float32> var_1510;
        const wp::int32 var_1511 = 3;
        wp::int32 var_1512;
        const wp::int32 var_1513 = 3;
        wp::int32 var_1514;
        wp::int32 var_1515;
        const wp::int32 var_1516 = 2;
        wp::int32 var_1517;
        wp::int32 var_1518;
        //---------
        // forward
        // def _generate_dense_mc_kernel(                                                         <L 1480>
        // x, y, z = wp.tid()                                                                     <L 1494>
        builtin_tid3d(var_0, var_1, var_2);
        // cube_idx = wp.int32(0)                                                                 <L 1495>
        var_4 = wp::int32(var_3);
        // corner_vals = vec8f()                                                                  <L 1496>
        var_5 = wp::vec_t<8, wp::float32>();
        // for i in range(8):                                                                     <L 1497>
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 1498>
        var_7 = wp::address(var_corner_offsets_table, var_6);
        var_9 = wp::load(var_7);
        var_8 = wp::vec_t<3, wp::int32>(var_9);
        // v = sdf_values[(x + co[0]) * ny * nz + (y + co[1]) * nz + (z + co[2])]                 <L 1499>
        var_11 = wp::extract(var_8, var_10);
        var_12 = wp::add(var_0, var_11);
        var_13 = wp::mul(var_12, var_ny);
        var_14 = wp::mul(var_13, var_nz);
        var_16 = wp::extract(var_8, var_15);
        var_17 = wp::add(var_1, var_16);
        var_18 = wp::mul(var_17, var_nz);
        var_19 = wp::add(var_14, var_18);
        var_21 = wp::extract(var_8, var_20);
        var_22 = wp::add(var_2, var_21);
        var_23 = wp::add(var_19, var_22);
        var_24 = wp::address(var_sdf_values, var_23);
        var_26 = wp::load(var_24);
        var_25 = wp::copy(var_26);
        // corner_vals[i] = v                                                                     <L 1500>
        wp::assign_inplace(var_5, var_6, var_25);
        // if v < 0.0:                                                                            <L 1501>
        var_28 = (var_25 < var_27);
        if (var_28) {
            // cube_idx |= 1 << i                                                                 <L 1502>
            var_30 = wp::lshift(var_29, var_6);
            var_31 = wp::bit_or(var_4, var_30);
        }
        var_32 = wp::where(var_28, var_31, var_4);
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 1498>
        var_34 = wp::address(var_corner_offsets_table, var_33);
        var_36 = wp::load(var_34);
        var_35 = wp::vec_t<3, wp::int32>(var_36);
        // v = sdf_values[(x + co[0]) * ny * nz + (y + co[1]) * nz + (z + co[2])]                 <L 1499>
        var_38 = wp::extract(var_35, var_37);
        var_39 = wp::add(var_0, var_38);
        var_40 = wp::mul(var_39, var_ny);
        var_41 = wp::mul(var_40, var_nz);
        var_43 = wp::extract(var_35, var_42);
        var_44 = wp::add(var_1, var_43);
        var_45 = wp::mul(var_44, var_nz);
        var_46 = wp::add(var_41, var_45);
        var_48 = wp::extract(var_35, var_47);
        var_49 = wp::add(var_2, var_48);
        var_50 = wp::add(var_46, var_49);
        var_51 = wp::address(var_sdf_values, var_50);
        var_53 = wp::load(var_51);
        var_52 = wp::copy(var_53);
        // corner_vals[i] = v                                                                     <L 1500>
        wp::assign_inplace(var_5, var_33, var_52);
        // if v < 0.0:                                                                            <L 1501>
        var_55 = (var_52 < var_54);
        if (var_55) {
            // cube_idx |= 1 << i                                                                 <L 1502>
            var_57 = wp::lshift(var_56, var_33);
            var_58 = wp::bit_or(var_32, var_57);
        }
        var_59 = wp::where(var_55, var_58, var_32);
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 1498>
        var_61 = wp::address(var_corner_offsets_table, var_60);
        var_63 = wp::load(var_61);
        var_62 = wp::vec_t<3, wp::int32>(var_63);
        // v = sdf_values[(x + co[0]) * ny * nz + (y + co[1]) * nz + (z + co[2])]                 <L 1499>
        var_65 = wp::extract(var_62, var_64);
        var_66 = wp::add(var_0, var_65);
        var_67 = wp::mul(var_66, var_ny);
        var_68 = wp::mul(var_67, var_nz);
        var_70 = wp::extract(var_62, var_69);
        var_71 = wp::add(var_1, var_70);
        var_72 = wp::mul(var_71, var_nz);
        var_73 = wp::add(var_68, var_72);
        var_75 = wp::extract(var_62, var_74);
        var_76 = wp::add(var_2, var_75);
        var_77 = wp::add(var_73, var_76);
        var_78 = wp::address(var_sdf_values, var_77);
        var_80 = wp::load(var_78);
        var_79 = wp::copy(var_80);
        // corner_vals[i] = v                                                                     <L 1500>
        wp::assign_inplace(var_5, var_60, var_79);
        // if v < 0.0:                                                                            <L 1501>
        var_82 = (var_79 < var_81);
        if (var_82) {
            // cube_idx |= 1 << i                                                                 <L 1502>
            var_84 = wp::lshift(var_83, var_60);
            var_85 = wp::bit_or(var_59, var_84);
        }
        var_86 = wp::where(var_82, var_85, var_59);
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 1498>
        var_88 = wp::address(var_corner_offsets_table, var_87);
        var_90 = wp::load(var_88);
        var_89 = wp::vec_t<3, wp::int32>(var_90);
        // v = sdf_values[(x + co[0]) * ny * nz + (y + co[1]) * nz + (z + co[2])]                 <L 1499>
        var_92 = wp::extract(var_89, var_91);
        var_93 = wp::add(var_0, var_92);
        var_94 = wp::mul(var_93, var_ny);
        var_95 = wp::mul(var_94, var_nz);
        var_97 = wp::extract(var_89, var_96);
        var_98 = wp::add(var_1, var_97);
        var_99 = wp::mul(var_98, var_nz);
        var_100 = wp::add(var_95, var_99);
        var_102 = wp::extract(var_89, var_101);
        var_103 = wp::add(var_2, var_102);
        var_104 = wp::add(var_100, var_103);
        var_105 = wp::address(var_sdf_values, var_104);
        var_107 = wp::load(var_105);
        var_106 = wp::copy(var_107);
        // corner_vals[i] = v                                                                     <L 1500>
        wp::assign_inplace(var_5, var_87, var_106);
        // if v < 0.0:                                                                            <L 1501>
        var_109 = (var_106 < var_108);
        if (var_109) {
            // cube_idx |= 1 << i                                                                 <L 1502>
            var_111 = wp::lshift(var_110, var_87);
            var_112 = wp::bit_or(var_86, var_111);
        }
        var_113 = wp::where(var_109, var_112, var_86);
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 1498>
        var_115 = wp::address(var_corner_offsets_table, var_114);
        var_117 = wp::load(var_115);
        var_116 = wp::vec_t<3, wp::int32>(var_117);
        // v = sdf_values[(x + co[0]) * ny * nz + (y + co[1]) * nz + (z + co[2])]                 <L 1499>
        var_119 = wp::extract(var_116, var_118);
        var_120 = wp::add(var_0, var_119);
        var_121 = wp::mul(var_120, var_ny);
        var_122 = wp::mul(var_121, var_nz);
        var_124 = wp::extract(var_116, var_123);
        var_125 = wp::add(var_1, var_124);
        var_126 = wp::mul(var_125, var_nz);
        var_127 = wp::add(var_122, var_126);
        var_129 = wp::extract(var_116, var_128);
        var_130 = wp::add(var_2, var_129);
        var_131 = wp::add(var_127, var_130);
        var_132 = wp::address(var_sdf_values, var_131);
        var_134 = wp::load(var_132);
        var_133 = wp::copy(var_134);
        // corner_vals[i] = v                                                                     <L 1500>
        wp::assign_inplace(var_5, var_114, var_133);
        // if v < 0.0:                                                                            <L 1501>
        var_136 = (var_133 < var_135);
        if (var_136) {
            // cube_idx |= 1 << i                                                                 <L 1502>
            var_138 = wp::lshift(var_137, var_114);
            var_139 = wp::bit_or(var_113, var_138);
        }
        var_140 = wp::where(var_136, var_139, var_113);
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 1498>
        var_142 = wp::address(var_corner_offsets_table, var_141);
        var_144 = wp::load(var_142);
        var_143 = wp::vec_t<3, wp::int32>(var_144);
        // v = sdf_values[(x + co[0]) * ny * nz + (y + co[1]) * nz + (z + co[2])]                 <L 1499>
        var_146 = wp::extract(var_143, var_145);
        var_147 = wp::add(var_0, var_146);
        var_148 = wp::mul(var_147, var_ny);
        var_149 = wp::mul(var_148, var_nz);
        var_151 = wp::extract(var_143, var_150);
        var_152 = wp::add(var_1, var_151);
        var_153 = wp::mul(var_152, var_nz);
        var_154 = wp::add(var_149, var_153);
        var_156 = wp::extract(var_143, var_155);
        var_157 = wp::add(var_2, var_156);
        var_158 = wp::add(var_154, var_157);
        var_159 = wp::address(var_sdf_values, var_158);
        var_161 = wp::load(var_159);
        var_160 = wp::copy(var_161);
        // corner_vals[i] = v                                                                     <L 1500>
        wp::assign_inplace(var_5, var_141, var_160);
        // if v < 0.0:                                                                            <L 1501>
        var_163 = (var_160 < var_162);
        if (var_163) {
            // cube_idx |= 1 << i                                                                 <L 1502>
            var_165 = wp::lshift(var_164, var_141);
            var_166 = wp::bit_or(var_140, var_165);
        }
        var_167 = wp::where(var_163, var_166, var_140);
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 1498>
        var_169 = wp::address(var_corner_offsets_table, var_168);
        var_171 = wp::load(var_169);
        var_170 = wp::vec_t<3, wp::int32>(var_171);
        // v = sdf_values[(x + co[0]) * ny * nz + (y + co[1]) * nz + (z + co[2])]                 <L 1499>
        var_173 = wp::extract(var_170, var_172);
        var_174 = wp::add(var_0, var_173);
        var_175 = wp::mul(var_174, var_ny);
        var_176 = wp::mul(var_175, var_nz);
        var_178 = wp::extract(var_170, var_177);
        var_179 = wp::add(var_1, var_178);
        var_180 = wp::mul(var_179, var_nz);
        var_181 = wp::add(var_176, var_180);
        var_183 = wp::extract(var_170, var_182);
        var_184 = wp::add(var_2, var_183);
        var_185 = wp::add(var_181, var_184);
        var_186 = wp::address(var_sdf_values, var_185);
        var_188 = wp::load(var_186);
        var_187 = wp::copy(var_188);
        // corner_vals[i] = v                                                                     <L 1500>
        wp::assign_inplace(var_5, var_168, var_187);
        // if v < 0.0:                                                                            <L 1501>
        var_190 = (var_187 < var_189);
        if (var_190) {
            // cube_idx |= 1 << i                                                                 <L 1502>
            var_192 = wp::lshift(var_191, var_168);
            var_193 = wp::bit_or(var_167, var_192);
        }
        var_194 = wp::where(var_190, var_193, var_167);
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 1498>
        var_196 = wp::address(var_corner_offsets_table, var_195);
        var_198 = wp::load(var_196);
        var_197 = wp::vec_t<3, wp::int32>(var_198);
        // v = sdf_values[(x + co[0]) * ny * nz + (y + co[1]) * nz + (z + co[2])]                 <L 1499>
        var_200 = wp::extract(var_197, var_199);
        var_201 = wp::add(var_0, var_200);
        var_202 = wp::mul(var_201, var_ny);
        var_203 = wp::mul(var_202, var_nz);
        var_205 = wp::extract(var_197, var_204);
        var_206 = wp::add(var_1, var_205);
        var_207 = wp::mul(var_206, var_nz);
        var_208 = wp::add(var_203, var_207);
        var_210 = wp::extract(var_197, var_209);
        var_211 = wp::add(var_2, var_210);
        var_212 = wp::add(var_208, var_211);
        var_213 = wp::address(var_sdf_values, var_212);
        var_215 = wp::load(var_213);
        var_214 = wp::copy(var_215);
        // corner_vals[i] = v                                                                     <L 1500>
        wp::assign_inplace(var_5, var_195, var_214);
        // if v < 0.0:                                                                            <L 1501>
        var_217 = (var_214 < var_216);
        if (var_217) {
            // cube_idx |= 1 << i                                                                 <L 1502>
            var_219 = wp::lshift(var_218, var_195);
            var_220 = wp::bit_or(var_194, var_219);
        }
        var_221 = wp::where(var_217, var_220, var_194);
        // tri_start = tri_range_table[cube_idx]                                                  <L 1504>
        var_222 = wp::address(var_tri_range_table, var_221);
        var_224 = wp::load(var_222);
        var_223 = wp::copy(var_224);
        // tri_end = tri_range_table[cube_idx + 1]                                                <L 1505>
        var_226 = wp::add(var_221, var_225);
        var_227 = wp::address(var_tri_range_table, var_226);
        var_229 = wp::load(var_227);
        var_228 = wp::copy(var_229);
        // num_verts = tri_end - tri_start                                                        <L 1506>
        var_230 = wp::sub(var_228, var_223);
        // num_faces = num_verts // 3                                                             <L 1507>
        var_232 = wp::floordiv(var_230, var_231);
        // out_idx = wp.atomic_add(face_count, 0, num_faces)                                      <L 1508>
        var_234 = wp::atomic_add(var_face_count, var_233, var_232);
        // if num_verts == 0:                                                                     <L 1509>
        var_236 = (var_230 == var_235);
        if (var_236) {
            // return                                                                             <L 1510>
            continue;
        }
        // base = wp.vec3(float(x), float(y), float(z))                                           <L 1512>
        var_237 = wp::float(var_0);
        var_238 = wp::float(var_1);
        var_239 = wp::float(var_2);
        var_240 = wp::vec_t<3, wp::float32>(var_237, var_238, var_239);
        // for fi in range(5):                                                                    <L 1513>
        // if fi >= num_faces:                                                                    <L 1514>
        var_242 = (var_241 >= var_232);
        if (var_242) {
            // return                                                                             <L 1515>
            continue;
        }
        // face_verts = wp.mat33f()                                                               <L 1516>
        var_243 = wp::mat_t<3, 3, wp::float32>();
        // for vi in range(3):                                                                    <L 1517>
        // ev = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                          <L 1518>
        var_246 = wp::mul(var_245, var_241);
        var_247 = wp::add(var_223, var_246);
        var_248 = wp::add(var_247, var_244);
        var_249 = wp::address(var_flat_edge_verts_table, var_248);
        var_251 = wp::load(var_249);
        var_250 = wp::vec_t<2, wp::int32>(var_251);
        // val_0 = wp.float32(corner_vals[ev[0]])                                                 <L 1519>
        var_253 = wp::extract(var_250, var_252);
        var_254 = wp::extract(var_5, var_253);
        var_255 = wp::float32(var_254);
        // val_1 = wp.float32(corner_vals[ev[1]])                                                 <L 1520>
        var_257 = wp::extract(var_250, var_256);
        var_258 = wp::extract(var_5, var_257);
        var_259 = wp::float32(var_258);
        // p_0 = wp.vec3f(corner_offsets_table[ev[0]])                                            <L 1521>
        var_261 = wp::extract(var_250, var_260);
        var_262 = wp::address(var_corner_offsets_table, var_261);
        var_264 = wp::load(var_262);
        var_263 = wp::vec_t<3, wp::float32>(var_264);
        // p_1 = wp.vec3f(corner_offsets_table[ev[1]])                                            <L 1522>
        var_266 = wp::extract(var_250, var_265);
        var_267 = wp::address(var_corner_offsets_table, var_266);
        var_269 = wp::load(var_267);
        var_268 = wp::vec_t<3, wp::float32>(var_269);
        // val_diff = val_1 - val_0                                                               <L 1523>
        var_270 = wp::sub(var_259, var_255);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 1524>
        var_271 = wp::abs(var_270);
        var_273 = (var_271 < var_272);
        if (var_273) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 1525>
            var_275 = wp::add(var_263, var_268);
            var_276 = wp::mul(var_274, var_275);
        }
        if (!var_273) {
            // t = wp.clamp((0.0 - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 1527>
            var_278 = wp::sub(var_277, var_255);
            var_279 = wp::div(var_278, var_270);
            var_282 = wp::clamp(var_279, var_280, var_281);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 1528>
            var_283 = wp::sub(var_268, var_263);
            var_284 = wp::mul(var_282, var_283);
            var_285 = wp::add(var_263, var_284);
        }
        var_286 = wp::where(var_273, var_276, var_285);
        // local = base + p                                                                       <L 1529>
        var_287 = wp::add(var_240, var_286);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        // origin[0] + local[0] * voxel_size[0],                                                  <L 1531>
        var_289 = wp::extract(var_origin, var_288);
        var_291 = wp::extract(var_287, var_290);
        var_293 = wp::extract(var_voxel_size, var_292);
        var_294 = wp::mul(var_291, var_293);
        var_295 = wp::add(var_289, var_294);
        // origin[1] + local[1] * voxel_size[1],                                                  <L 1532>
        var_297 = wp::extract(var_origin, var_296);
        var_299 = wp::extract(var_287, var_298);
        var_301 = wp::extract(var_voxel_size, var_300);
        var_302 = wp::mul(var_299, var_301);
        var_303 = wp::add(var_297, var_302);
        // origin[2] + local[2] * voxel_size[2],                                                  <L 1533>
        var_305 = wp::extract(var_origin, var_304);
        var_307 = wp::extract(var_287, var_306);
        var_309 = wp::extract(var_voxel_size, var_308);
        var_310 = wp::mul(var_307, var_309);
        var_311 = wp::add(var_305, var_310);
        var_312 = wp::vec_t<3, wp::float32>(var_295, var_303, var_311);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        wp::assign_inplace(var_243, var_244, var_312);
        // ev = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                          <L 1518>
        var_315 = wp::mul(var_314, var_241);
        var_316 = wp::add(var_223, var_315);
        var_317 = wp::add(var_316, var_313);
        var_318 = wp::address(var_flat_edge_verts_table, var_317);
        var_320 = wp::load(var_318);
        var_319 = wp::vec_t<2, wp::int32>(var_320);
        // val_0 = wp.float32(corner_vals[ev[0]])                                                 <L 1519>
        var_322 = wp::extract(var_319, var_321);
        var_323 = wp::extract(var_5, var_322);
        var_324 = wp::float32(var_323);
        // val_1 = wp.float32(corner_vals[ev[1]])                                                 <L 1520>
        var_326 = wp::extract(var_319, var_325);
        var_327 = wp::extract(var_5, var_326);
        var_328 = wp::float32(var_327);
        // p_0 = wp.vec3f(corner_offsets_table[ev[0]])                                            <L 1521>
        var_330 = wp::extract(var_319, var_329);
        var_331 = wp::address(var_corner_offsets_table, var_330);
        var_333 = wp::load(var_331);
        var_332 = wp::vec_t<3, wp::float32>(var_333);
        // p_1 = wp.vec3f(corner_offsets_table[ev[1]])                                            <L 1522>
        var_335 = wp::extract(var_319, var_334);
        var_336 = wp::address(var_corner_offsets_table, var_335);
        var_338 = wp::load(var_336);
        var_337 = wp::vec_t<3, wp::float32>(var_338);
        // val_diff = val_1 - val_0                                                               <L 1523>
        var_339 = wp::sub(var_328, var_324);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 1524>
        var_340 = wp::abs(var_339);
        var_341 = (var_340 < var_272);
        if (var_341) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 1525>
            var_343 = wp::add(var_332, var_337);
            var_344 = wp::mul(var_342, var_343);
        }
        if (!var_341) {
            // t = wp.clamp((0.0 - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 1527>
            var_346 = wp::sub(var_345, var_324);
            var_347 = wp::div(var_346, var_339);
            var_348 = wp::clamp(var_347, var_280, var_281);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 1528>
            var_349 = wp::sub(var_337, var_332);
            var_350 = wp::mul(var_348, var_349);
            var_351 = wp::add(var_332, var_350);
        }
        var_352 = wp::where(var_341, var_344, var_351);
        var_353 = wp::where(var_341, var_282, var_348);
        // local = base + p                                                                       <L 1529>
        var_354 = wp::add(var_240, var_352);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        // origin[0] + local[0] * voxel_size[0],                                                  <L 1531>
        var_356 = wp::extract(var_origin, var_355);
        var_358 = wp::extract(var_354, var_357);
        var_360 = wp::extract(var_voxel_size, var_359);
        var_361 = wp::mul(var_358, var_360);
        var_362 = wp::add(var_356, var_361);
        // origin[1] + local[1] * voxel_size[1],                                                  <L 1532>
        var_364 = wp::extract(var_origin, var_363);
        var_366 = wp::extract(var_354, var_365);
        var_368 = wp::extract(var_voxel_size, var_367);
        var_369 = wp::mul(var_366, var_368);
        var_370 = wp::add(var_364, var_369);
        // origin[2] + local[2] * voxel_size[2],                                                  <L 1533>
        var_372 = wp::extract(var_origin, var_371);
        var_374 = wp::extract(var_354, var_373);
        var_376 = wp::extract(var_voxel_size, var_375);
        var_377 = wp::mul(var_374, var_376);
        var_378 = wp::add(var_372, var_377);
        var_379 = wp::vec_t<3, wp::float32>(var_362, var_370, var_378);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        wp::assign_inplace(var_243, var_313, var_379);
        // ev = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                          <L 1518>
        var_382 = wp::mul(var_381, var_241);
        var_383 = wp::add(var_223, var_382);
        var_384 = wp::add(var_383, var_380);
        var_385 = wp::address(var_flat_edge_verts_table, var_384);
        var_387 = wp::load(var_385);
        var_386 = wp::vec_t<2, wp::int32>(var_387);
        // val_0 = wp.float32(corner_vals[ev[0]])                                                 <L 1519>
        var_389 = wp::extract(var_386, var_388);
        var_390 = wp::extract(var_5, var_389);
        var_391 = wp::float32(var_390);
        // val_1 = wp.float32(corner_vals[ev[1]])                                                 <L 1520>
        var_393 = wp::extract(var_386, var_392);
        var_394 = wp::extract(var_5, var_393);
        var_395 = wp::float32(var_394);
        // p_0 = wp.vec3f(corner_offsets_table[ev[0]])                                            <L 1521>
        var_397 = wp::extract(var_386, var_396);
        var_398 = wp::address(var_corner_offsets_table, var_397);
        var_400 = wp::load(var_398);
        var_399 = wp::vec_t<3, wp::float32>(var_400);
        // p_1 = wp.vec3f(corner_offsets_table[ev[1]])                                            <L 1522>
        var_402 = wp::extract(var_386, var_401);
        var_403 = wp::address(var_corner_offsets_table, var_402);
        var_405 = wp::load(var_403);
        var_404 = wp::vec_t<3, wp::float32>(var_405);
        // val_diff = val_1 - val_0                                                               <L 1523>
        var_406 = wp::sub(var_395, var_391);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 1524>
        var_407 = wp::abs(var_406);
        var_408 = (var_407 < var_272);
        if (var_408) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 1525>
            var_410 = wp::add(var_399, var_404);
            var_411 = wp::mul(var_409, var_410);
        }
        if (!var_408) {
            // t = wp.clamp((0.0 - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 1527>
            var_413 = wp::sub(var_412, var_391);
            var_414 = wp::div(var_413, var_406);
            var_415 = wp::clamp(var_414, var_280, var_281);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 1528>
            var_416 = wp::sub(var_404, var_399);
            var_417 = wp::mul(var_415, var_416);
            var_418 = wp::add(var_399, var_417);
        }
        var_419 = wp::where(var_408, var_411, var_418);
        var_420 = wp::where(var_408, var_353, var_415);
        // local = base + p                                                                       <L 1529>
        var_421 = wp::add(var_240, var_419);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        // origin[0] + local[0] * voxel_size[0],                                                  <L 1531>
        var_423 = wp::extract(var_origin, var_422);
        var_425 = wp::extract(var_421, var_424);
        var_427 = wp::extract(var_voxel_size, var_426);
        var_428 = wp::mul(var_425, var_427);
        var_429 = wp::add(var_423, var_428);
        // origin[1] + local[1] * voxel_size[1],                                                  <L 1532>
        var_431 = wp::extract(var_origin, var_430);
        var_433 = wp::extract(var_421, var_432);
        var_435 = wp::extract(var_voxel_size, var_434);
        var_436 = wp::mul(var_433, var_435);
        var_437 = wp::add(var_431, var_436);
        // origin[2] + local[2] * voxel_size[2],                                                  <L 1533>
        var_439 = wp::extract(var_origin, var_438);
        var_441 = wp::extract(var_421, var_440);
        var_443 = wp::extract(var_voxel_size, var_442);
        var_444 = wp::mul(var_441, var_443);
        var_445 = wp::add(var_439, var_444);
        var_446 = wp::vec_t<3, wp::float32>(var_429, var_437, var_445);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        wp::assign_inplace(var_243, var_380, var_446);
        // n = wp.cross(face_verts[1] - face_verts[0], face_verts[2] - face_verts[0])             <L 1535>
        var_448 = wp::extract(var_243, var_447);
        var_450 = wp::extract(var_243, var_449);
        var_451 = wp::sub(var_448, var_450);
        var_453 = wp::extract(var_243, var_452);
        var_455 = wp::extract(var_243, var_454);
        var_456 = wp::sub(var_453, var_455);
        var_457 = wp::cross(var_451, var_456);
        // n_sq = wp.dot(n, n)                                                                    <L 1536>
        var_458 = wp::dot(var_457, var_457);
        // if n_sq < MC_DEGENERATE_N_SQ_EPS:                                                      <L 1537>
        var_460 = (var_458 < var_459);
        if (var_460) {
            // normal = wp.vec3(0.0, 0.0, 1.0)                                                    <L 1538>
            var_464 = wp::vec_t<3, wp::float32>(var_461, var_462, var_463);
        }
        if (!var_460) {
            // normal = n / wp.sqrt(n_sq)                                                         <L 1540>
            var_465 = wp::sqrt(var_458);
            var_466 = wp::div(var_457, var_465);
        }
        var_467 = wp::where(var_460, var_464, var_466);
        // vertices[3 * out_idx + 3 * fi + 0] = wp.vec3(face_verts[0])                            <L 1541>
        var_469 = wp::extract(var_243, var_468);
        var_470 = wp::vec_t<3, wp::float32>(var_469);
        var_472 = wp::mul(var_471, var_234);
        var_474 = wp::mul(var_473, var_241);
        var_475 = wp::add(var_472, var_474);
        var_477 = wp::add(var_475, var_476);
        wp::array_store(var_vertices, var_477, var_470);
        // vertices[3 * out_idx + 3 * fi + 1] = wp.vec3(face_verts[1])                            <L 1542>
        var_479 = wp::extract(var_243, var_478);
        var_480 = wp::vec_t<3, wp::float32>(var_479);
        var_482 = wp::mul(var_481, var_234);
        var_484 = wp::mul(var_483, var_241);
        var_485 = wp::add(var_482, var_484);
        var_487 = wp::add(var_485, var_486);
        wp::array_store(var_vertices, var_487, var_480);
        // vertices[3 * out_idx + 3 * fi + 2] = wp.vec3(face_verts[2])                            <L 1543>
        var_489 = wp::extract(var_243, var_488);
        var_490 = wp::vec_t<3, wp::float32>(var_489);
        var_492 = wp::mul(var_491, var_234);
        var_494 = wp::mul(var_493, var_241);
        var_495 = wp::add(var_492, var_494);
        var_497 = wp::add(var_495, var_496);
        wp::array_store(var_vertices, var_497, var_490);
        // face_normals[out_idx + fi] = normal                                                    <L 1544>
        var_498 = wp::add(var_234, var_241);
        wp::array_store(var_face_normals, var_498, var_467);
        // if fi >= num_faces:                                                                    <L 1514>
        var_500 = (var_499 >= var_232);
        if (var_500) {
            // return                                                                             <L 1515>
            continue;
        }
        // face_verts = wp.mat33f()                                                               <L 1516>
        var_501 = wp::mat_t<3, 3, wp::float32>();
        // for vi in range(3):                                                                    <L 1517>
        // ev = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                          <L 1518>
        var_504 = wp::mul(var_503, var_499);
        var_505 = wp::add(var_223, var_504);
        var_506 = wp::add(var_505, var_502);
        var_507 = wp::address(var_flat_edge_verts_table, var_506);
        var_509 = wp::load(var_507);
        var_508 = wp::vec_t<2, wp::int32>(var_509);
        // val_0 = wp.float32(corner_vals[ev[0]])                                                 <L 1519>
        var_511 = wp::extract(var_508, var_510);
        var_512 = wp::extract(var_5, var_511);
        var_513 = wp::float32(var_512);
        // val_1 = wp.float32(corner_vals[ev[1]])                                                 <L 1520>
        var_515 = wp::extract(var_508, var_514);
        var_516 = wp::extract(var_5, var_515);
        var_517 = wp::float32(var_516);
        // p_0 = wp.vec3f(corner_offsets_table[ev[0]])                                            <L 1521>
        var_519 = wp::extract(var_508, var_518);
        var_520 = wp::address(var_corner_offsets_table, var_519);
        var_522 = wp::load(var_520);
        var_521 = wp::vec_t<3, wp::float32>(var_522);
        // p_1 = wp.vec3f(corner_offsets_table[ev[1]])                                            <L 1522>
        var_524 = wp::extract(var_508, var_523);
        var_525 = wp::address(var_corner_offsets_table, var_524);
        var_527 = wp::load(var_525);
        var_526 = wp::vec_t<3, wp::float32>(var_527);
        // val_diff = val_1 - val_0                                                               <L 1523>
        var_528 = wp::sub(var_517, var_513);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 1524>
        var_529 = wp::abs(var_528);
        var_530 = (var_529 < var_272);
        if (var_530) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 1525>
            var_532 = wp::add(var_521, var_526);
            var_533 = wp::mul(var_531, var_532);
        }
        if (!var_530) {
            // t = wp.clamp((0.0 - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 1527>
            var_535 = wp::sub(var_534, var_513);
            var_536 = wp::div(var_535, var_528);
            var_537 = wp::clamp(var_536, var_280, var_281);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 1528>
            var_538 = wp::sub(var_526, var_521);
            var_539 = wp::mul(var_537, var_538);
            var_540 = wp::add(var_521, var_539);
        }
        var_541 = wp::where(var_530, var_533, var_540);
        var_542 = wp::where(var_530, var_420, var_537);
        // local = base + p                                                                       <L 1529>
        var_543 = wp::add(var_240, var_541);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        // origin[0] + local[0] * voxel_size[0],                                                  <L 1531>
        var_545 = wp::extract(var_origin, var_544);
        var_547 = wp::extract(var_543, var_546);
        var_549 = wp::extract(var_voxel_size, var_548);
        var_550 = wp::mul(var_547, var_549);
        var_551 = wp::add(var_545, var_550);
        // origin[1] + local[1] * voxel_size[1],                                                  <L 1532>
        var_553 = wp::extract(var_origin, var_552);
        var_555 = wp::extract(var_543, var_554);
        var_557 = wp::extract(var_voxel_size, var_556);
        var_558 = wp::mul(var_555, var_557);
        var_559 = wp::add(var_553, var_558);
        // origin[2] + local[2] * voxel_size[2],                                                  <L 1533>
        var_561 = wp::extract(var_origin, var_560);
        var_563 = wp::extract(var_543, var_562);
        var_565 = wp::extract(var_voxel_size, var_564);
        var_566 = wp::mul(var_563, var_565);
        var_567 = wp::add(var_561, var_566);
        var_568 = wp::vec_t<3, wp::float32>(var_551, var_559, var_567);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        wp::assign_inplace(var_501, var_502, var_568);
        // ev = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                          <L 1518>
        var_571 = wp::mul(var_570, var_499);
        var_572 = wp::add(var_223, var_571);
        var_573 = wp::add(var_572, var_569);
        var_574 = wp::address(var_flat_edge_verts_table, var_573);
        var_576 = wp::load(var_574);
        var_575 = wp::vec_t<2, wp::int32>(var_576);
        // val_0 = wp.float32(corner_vals[ev[0]])                                                 <L 1519>
        var_578 = wp::extract(var_575, var_577);
        var_579 = wp::extract(var_5, var_578);
        var_580 = wp::float32(var_579);
        // val_1 = wp.float32(corner_vals[ev[1]])                                                 <L 1520>
        var_582 = wp::extract(var_575, var_581);
        var_583 = wp::extract(var_5, var_582);
        var_584 = wp::float32(var_583);
        // p_0 = wp.vec3f(corner_offsets_table[ev[0]])                                            <L 1521>
        var_586 = wp::extract(var_575, var_585);
        var_587 = wp::address(var_corner_offsets_table, var_586);
        var_589 = wp::load(var_587);
        var_588 = wp::vec_t<3, wp::float32>(var_589);
        // p_1 = wp.vec3f(corner_offsets_table[ev[1]])                                            <L 1522>
        var_591 = wp::extract(var_575, var_590);
        var_592 = wp::address(var_corner_offsets_table, var_591);
        var_594 = wp::load(var_592);
        var_593 = wp::vec_t<3, wp::float32>(var_594);
        // val_diff = val_1 - val_0                                                               <L 1523>
        var_595 = wp::sub(var_584, var_580);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 1524>
        var_596 = wp::abs(var_595);
        var_597 = (var_596 < var_272);
        if (var_597) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 1525>
            var_599 = wp::add(var_588, var_593);
            var_600 = wp::mul(var_598, var_599);
        }
        if (!var_597) {
            // t = wp.clamp((0.0 - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 1527>
            var_602 = wp::sub(var_601, var_580);
            var_603 = wp::div(var_602, var_595);
            var_604 = wp::clamp(var_603, var_280, var_281);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 1528>
            var_605 = wp::sub(var_593, var_588);
            var_606 = wp::mul(var_604, var_605);
            var_607 = wp::add(var_588, var_606);
        }
        var_608 = wp::where(var_597, var_600, var_607);
        var_609 = wp::where(var_597, var_542, var_604);
        // local = base + p                                                                       <L 1529>
        var_610 = wp::add(var_240, var_608);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        // origin[0] + local[0] * voxel_size[0],                                                  <L 1531>
        var_612 = wp::extract(var_origin, var_611);
        var_614 = wp::extract(var_610, var_613);
        var_616 = wp::extract(var_voxel_size, var_615);
        var_617 = wp::mul(var_614, var_616);
        var_618 = wp::add(var_612, var_617);
        // origin[1] + local[1] * voxel_size[1],                                                  <L 1532>
        var_620 = wp::extract(var_origin, var_619);
        var_622 = wp::extract(var_610, var_621);
        var_624 = wp::extract(var_voxel_size, var_623);
        var_625 = wp::mul(var_622, var_624);
        var_626 = wp::add(var_620, var_625);
        // origin[2] + local[2] * voxel_size[2],                                                  <L 1533>
        var_628 = wp::extract(var_origin, var_627);
        var_630 = wp::extract(var_610, var_629);
        var_632 = wp::extract(var_voxel_size, var_631);
        var_633 = wp::mul(var_630, var_632);
        var_634 = wp::add(var_628, var_633);
        var_635 = wp::vec_t<3, wp::float32>(var_618, var_626, var_634);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        wp::assign_inplace(var_501, var_569, var_635);
        // ev = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                          <L 1518>
        var_638 = wp::mul(var_637, var_499);
        var_639 = wp::add(var_223, var_638);
        var_640 = wp::add(var_639, var_636);
        var_641 = wp::address(var_flat_edge_verts_table, var_640);
        var_643 = wp::load(var_641);
        var_642 = wp::vec_t<2, wp::int32>(var_643);
        // val_0 = wp.float32(corner_vals[ev[0]])                                                 <L 1519>
        var_645 = wp::extract(var_642, var_644);
        var_646 = wp::extract(var_5, var_645);
        var_647 = wp::float32(var_646);
        // val_1 = wp.float32(corner_vals[ev[1]])                                                 <L 1520>
        var_649 = wp::extract(var_642, var_648);
        var_650 = wp::extract(var_5, var_649);
        var_651 = wp::float32(var_650);
        // p_0 = wp.vec3f(corner_offsets_table[ev[0]])                                            <L 1521>
        var_653 = wp::extract(var_642, var_652);
        var_654 = wp::address(var_corner_offsets_table, var_653);
        var_656 = wp::load(var_654);
        var_655 = wp::vec_t<3, wp::float32>(var_656);
        // p_1 = wp.vec3f(corner_offsets_table[ev[1]])                                            <L 1522>
        var_658 = wp::extract(var_642, var_657);
        var_659 = wp::address(var_corner_offsets_table, var_658);
        var_661 = wp::load(var_659);
        var_660 = wp::vec_t<3, wp::float32>(var_661);
        // val_diff = val_1 - val_0                                                               <L 1523>
        var_662 = wp::sub(var_651, var_647);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 1524>
        var_663 = wp::abs(var_662);
        var_664 = (var_663 < var_272);
        if (var_664) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 1525>
            var_666 = wp::add(var_655, var_660);
            var_667 = wp::mul(var_665, var_666);
        }
        if (!var_664) {
            // t = wp.clamp((0.0 - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 1527>
            var_669 = wp::sub(var_668, var_647);
            var_670 = wp::div(var_669, var_662);
            var_671 = wp::clamp(var_670, var_280, var_281);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 1528>
            var_672 = wp::sub(var_660, var_655);
            var_673 = wp::mul(var_671, var_672);
            var_674 = wp::add(var_655, var_673);
        }
        var_675 = wp::where(var_664, var_667, var_674);
        var_676 = wp::where(var_664, var_609, var_671);
        // local = base + p                                                                       <L 1529>
        var_677 = wp::add(var_240, var_675);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        // origin[0] + local[0] * voxel_size[0],                                                  <L 1531>
        var_679 = wp::extract(var_origin, var_678);
        var_681 = wp::extract(var_677, var_680);
        var_683 = wp::extract(var_voxel_size, var_682);
        var_684 = wp::mul(var_681, var_683);
        var_685 = wp::add(var_679, var_684);
        // origin[1] + local[1] * voxel_size[1],                                                  <L 1532>
        var_687 = wp::extract(var_origin, var_686);
        var_689 = wp::extract(var_677, var_688);
        var_691 = wp::extract(var_voxel_size, var_690);
        var_692 = wp::mul(var_689, var_691);
        var_693 = wp::add(var_687, var_692);
        // origin[2] + local[2] * voxel_size[2],                                                  <L 1533>
        var_695 = wp::extract(var_origin, var_694);
        var_697 = wp::extract(var_677, var_696);
        var_699 = wp::extract(var_voxel_size, var_698);
        var_700 = wp::mul(var_697, var_699);
        var_701 = wp::add(var_695, var_700);
        var_702 = wp::vec_t<3, wp::float32>(var_685, var_693, var_701);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        wp::assign_inplace(var_501, var_636, var_702);
        // n = wp.cross(face_verts[1] - face_verts[0], face_verts[2] - face_verts[0])             <L 1535>
        var_704 = wp::extract(var_501, var_703);
        var_706 = wp::extract(var_501, var_705);
        var_707 = wp::sub(var_704, var_706);
        var_709 = wp::extract(var_501, var_708);
        var_711 = wp::extract(var_501, var_710);
        var_712 = wp::sub(var_709, var_711);
        var_713 = wp::cross(var_707, var_712);
        // n_sq = wp.dot(n, n)                                                                    <L 1536>
        var_714 = wp::dot(var_713, var_713);
        // if n_sq < MC_DEGENERATE_N_SQ_EPS:                                                      <L 1537>
        var_715 = (var_714 < var_459);
        if (var_715) {
            // normal = wp.vec3(0.0, 0.0, 1.0)                                                    <L 1538>
            var_719 = wp::vec_t<3, wp::float32>(var_716, var_717, var_718);
        }
        if (!var_715) {
            // normal = n / wp.sqrt(n_sq)                                                         <L 1540>
            var_720 = wp::sqrt(var_714);
            var_721 = wp::div(var_713, var_720);
        }
        var_722 = wp::where(var_715, var_719, var_721);
        // vertices[3 * out_idx + 3 * fi + 0] = wp.vec3(face_verts[0])                            <L 1541>
        var_724 = wp::extract(var_501, var_723);
        var_725 = wp::vec_t<3, wp::float32>(var_724);
        var_727 = wp::mul(var_726, var_234);
        var_729 = wp::mul(var_728, var_499);
        var_730 = wp::add(var_727, var_729);
        var_732 = wp::add(var_730, var_731);
        wp::array_store(var_vertices, var_732, var_725);
        // vertices[3 * out_idx + 3 * fi + 1] = wp.vec3(face_verts[1])                            <L 1542>
        var_734 = wp::extract(var_501, var_733);
        var_735 = wp::vec_t<3, wp::float32>(var_734);
        var_737 = wp::mul(var_736, var_234);
        var_739 = wp::mul(var_738, var_499);
        var_740 = wp::add(var_737, var_739);
        var_742 = wp::add(var_740, var_741);
        wp::array_store(var_vertices, var_742, var_735);
        // vertices[3 * out_idx + 3 * fi + 2] = wp.vec3(face_verts[2])                            <L 1543>
        var_744 = wp::extract(var_501, var_743);
        var_745 = wp::vec_t<3, wp::float32>(var_744);
        var_747 = wp::mul(var_746, var_234);
        var_749 = wp::mul(var_748, var_499);
        var_750 = wp::add(var_747, var_749);
        var_752 = wp::add(var_750, var_751);
        wp::array_store(var_vertices, var_752, var_745);
        // face_normals[out_idx + fi] = normal                                                    <L 1544>
        var_753 = wp::add(var_234, var_499);
        wp::array_store(var_face_normals, var_753, var_722);
        // if fi >= num_faces:                                                                    <L 1514>
        var_755 = (var_754 >= var_232);
        if (var_755) {
            // return                                                                             <L 1515>
            continue;
        }
        // face_verts = wp.mat33f()                                                               <L 1516>
        var_756 = wp::mat_t<3, 3, wp::float32>();
        // for vi in range(3):                                                                    <L 1517>
        // ev = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                          <L 1518>
        var_759 = wp::mul(var_758, var_754);
        var_760 = wp::add(var_223, var_759);
        var_761 = wp::add(var_760, var_757);
        var_762 = wp::address(var_flat_edge_verts_table, var_761);
        var_764 = wp::load(var_762);
        var_763 = wp::vec_t<2, wp::int32>(var_764);
        // val_0 = wp.float32(corner_vals[ev[0]])                                                 <L 1519>
        var_766 = wp::extract(var_763, var_765);
        var_767 = wp::extract(var_5, var_766);
        var_768 = wp::float32(var_767);
        // val_1 = wp.float32(corner_vals[ev[1]])                                                 <L 1520>
        var_770 = wp::extract(var_763, var_769);
        var_771 = wp::extract(var_5, var_770);
        var_772 = wp::float32(var_771);
        // p_0 = wp.vec3f(corner_offsets_table[ev[0]])                                            <L 1521>
        var_774 = wp::extract(var_763, var_773);
        var_775 = wp::address(var_corner_offsets_table, var_774);
        var_777 = wp::load(var_775);
        var_776 = wp::vec_t<3, wp::float32>(var_777);
        // p_1 = wp.vec3f(corner_offsets_table[ev[1]])                                            <L 1522>
        var_779 = wp::extract(var_763, var_778);
        var_780 = wp::address(var_corner_offsets_table, var_779);
        var_782 = wp::load(var_780);
        var_781 = wp::vec_t<3, wp::float32>(var_782);
        // val_diff = val_1 - val_0                                                               <L 1523>
        var_783 = wp::sub(var_772, var_768);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 1524>
        var_784 = wp::abs(var_783);
        var_785 = (var_784 < var_272);
        if (var_785) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 1525>
            var_787 = wp::add(var_776, var_781);
            var_788 = wp::mul(var_786, var_787);
        }
        if (!var_785) {
            // t = wp.clamp((0.0 - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 1527>
            var_790 = wp::sub(var_789, var_768);
            var_791 = wp::div(var_790, var_783);
            var_792 = wp::clamp(var_791, var_280, var_281);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 1528>
            var_793 = wp::sub(var_781, var_776);
            var_794 = wp::mul(var_792, var_793);
            var_795 = wp::add(var_776, var_794);
        }
        var_796 = wp::where(var_785, var_788, var_795);
        var_797 = wp::where(var_785, var_676, var_792);
        // local = base + p                                                                       <L 1529>
        var_798 = wp::add(var_240, var_796);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        // origin[0] + local[0] * voxel_size[0],                                                  <L 1531>
        var_800 = wp::extract(var_origin, var_799);
        var_802 = wp::extract(var_798, var_801);
        var_804 = wp::extract(var_voxel_size, var_803);
        var_805 = wp::mul(var_802, var_804);
        var_806 = wp::add(var_800, var_805);
        // origin[1] + local[1] * voxel_size[1],                                                  <L 1532>
        var_808 = wp::extract(var_origin, var_807);
        var_810 = wp::extract(var_798, var_809);
        var_812 = wp::extract(var_voxel_size, var_811);
        var_813 = wp::mul(var_810, var_812);
        var_814 = wp::add(var_808, var_813);
        // origin[2] + local[2] * voxel_size[2],                                                  <L 1533>
        var_816 = wp::extract(var_origin, var_815);
        var_818 = wp::extract(var_798, var_817);
        var_820 = wp::extract(var_voxel_size, var_819);
        var_821 = wp::mul(var_818, var_820);
        var_822 = wp::add(var_816, var_821);
        var_823 = wp::vec_t<3, wp::float32>(var_806, var_814, var_822);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        wp::assign_inplace(var_756, var_757, var_823);
        // ev = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                          <L 1518>
        var_826 = wp::mul(var_825, var_754);
        var_827 = wp::add(var_223, var_826);
        var_828 = wp::add(var_827, var_824);
        var_829 = wp::address(var_flat_edge_verts_table, var_828);
        var_831 = wp::load(var_829);
        var_830 = wp::vec_t<2, wp::int32>(var_831);
        // val_0 = wp.float32(corner_vals[ev[0]])                                                 <L 1519>
        var_833 = wp::extract(var_830, var_832);
        var_834 = wp::extract(var_5, var_833);
        var_835 = wp::float32(var_834);
        // val_1 = wp.float32(corner_vals[ev[1]])                                                 <L 1520>
        var_837 = wp::extract(var_830, var_836);
        var_838 = wp::extract(var_5, var_837);
        var_839 = wp::float32(var_838);
        // p_0 = wp.vec3f(corner_offsets_table[ev[0]])                                            <L 1521>
        var_841 = wp::extract(var_830, var_840);
        var_842 = wp::address(var_corner_offsets_table, var_841);
        var_844 = wp::load(var_842);
        var_843 = wp::vec_t<3, wp::float32>(var_844);
        // p_1 = wp.vec3f(corner_offsets_table[ev[1]])                                            <L 1522>
        var_846 = wp::extract(var_830, var_845);
        var_847 = wp::address(var_corner_offsets_table, var_846);
        var_849 = wp::load(var_847);
        var_848 = wp::vec_t<3, wp::float32>(var_849);
        // val_diff = val_1 - val_0                                                               <L 1523>
        var_850 = wp::sub(var_839, var_835);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 1524>
        var_851 = wp::abs(var_850);
        var_852 = (var_851 < var_272);
        if (var_852) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 1525>
            var_854 = wp::add(var_843, var_848);
            var_855 = wp::mul(var_853, var_854);
        }
        if (!var_852) {
            // t = wp.clamp((0.0 - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 1527>
            var_857 = wp::sub(var_856, var_835);
            var_858 = wp::div(var_857, var_850);
            var_859 = wp::clamp(var_858, var_280, var_281);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 1528>
            var_860 = wp::sub(var_848, var_843);
            var_861 = wp::mul(var_859, var_860);
            var_862 = wp::add(var_843, var_861);
        }
        var_863 = wp::where(var_852, var_855, var_862);
        var_864 = wp::where(var_852, var_797, var_859);
        // local = base + p                                                                       <L 1529>
        var_865 = wp::add(var_240, var_863);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        // origin[0] + local[0] * voxel_size[0],                                                  <L 1531>
        var_867 = wp::extract(var_origin, var_866);
        var_869 = wp::extract(var_865, var_868);
        var_871 = wp::extract(var_voxel_size, var_870);
        var_872 = wp::mul(var_869, var_871);
        var_873 = wp::add(var_867, var_872);
        // origin[1] + local[1] * voxel_size[1],                                                  <L 1532>
        var_875 = wp::extract(var_origin, var_874);
        var_877 = wp::extract(var_865, var_876);
        var_879 = wp::extract(var_voxel_size, var_878);
        var_880 = wp::mul(var_877, var_879);
        var_881 = wp::add(var_875, var_880);
        // origin[2] + local[2] * voxel_size[2],                                                  <L 1533>
        var_883 = wp::extract(var_origin, var_882);
        var_885 = wp::extract(var_865, var_884);
        var_887 = wp::extract(var_voxel_size, var_886);
        var_888 = wp::mul(var_885, var_887);
        var_889 = wp::add(var_883, var_888);
        var_890 = wp::vec_t<3, wp::float32>(var_873, var_881, var_889);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        wp::assign_inplace(var_756, var_824, var_890);
        // ev = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                          <L 1518>
        var_893 = wp::mul(var_892, var_754);
        var_894 = wp::add(var_223, var_893);
        var_895 = wp::add(var_894, var_891);
        var_896 = wp::address(var_flat_edge_verts_table, var_895);
        var_898 = wp::load(var_896);
        var_897 = wp::vec_t<2, wp::int32>(var_898);
        // val_0 = wp.float32(corner_vals[ev[0]])                                                 <L 1519>
        var_900 = wp::extract(var_897, var_899);
        var_901 = wp::extract(var_5, var_900);
        var_902 = wp::float32(var_901);
        // val_1 = wp.float32(corner_vals[ev[1]])                                                 <L 1520>
        var_904 = wp::extract(var_897, var_903);
        var_905 = wp::extract(var_5, var_904);
        var_906 = wp::float32(var_905);
        // p_0 = wp.vec3f(corner_offsets_table[ev[0]])                                            <L 1521>
        var_908 = wp::extract(var_897, var_907);
        var_909 = wp::address(var_corner_offsets_table, var_908);
        var_911 = wp::load(var_909);
        var_910 = wp::vec_t<3, wp::float32>(var_911);
        // p_1 = wp.vec3f(corner_offsets_table[ev[1]])                                            <L 1522>
        var_913 = wp::extract(var_897, var_912);
        var_914 = wp::address(var_corner_offsets_table, var_913);
        var_916 = wp::load(var_914);
        var_915 = wp::vec_t<3, wp::float32>(var_916);
        // val_diff = val_1 - val_0                                                               <L 1523>
        var_917 = wp::sub(var_906, var_902);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 1524>
        var_918 = wp::abs(var_917);
        var_919 = (var_918 < var_272);
        if (var_919) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 1525>
            var_921 = wp::add(var_910, var_915);
            var_922 = wp::mul(var_920, var_921);
        }
        if (!var_919) {
            // t = wp.clamp((0.0 - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 1527>
            var_924 = wp::sub(var_923, var_902);
            var_925 = wp::div(var_924, var_917);
            var_926 = wp::clamp(var_925, var_280, var_281);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 1528>
            var_927 = wp::sub(var_915, var_910);
            var_928 = wp::mul(var_926, var_927);
            var_929 = wp::add(var_910, var_928);
        }
        var_930 = wp::where(var_919, var_922, var_929);
        var_931 = wp::where(var_919, var_864, var_926);
        // local = base + p                                                                       <L 1529>
        var_932 = wp::add(var_240, var_930);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        // origin[0] + local[0] * voxel_size[0],                                                  <L 1531>
        var_934 = wp::extract(var_origin, var_933);
        var_936 = wp::extract(var_932, var_935);
        var_938 = wp::extract(var_voxel_size, var_937);
        var_939 = wp::mul(var_936, var_938);
        var_940 = wp::add(var_934, var_939);
        // origin[1] + local[1] * voxel_size[1],                                                  <L 1532>
        var_942 = wp::extract(var_origin, var_941);
        var_944 = wp::extract(var_932, var_943);
        var_946 = wp::extract(var_voxel_size, var_945);
        var_947 = wp::mul(var_944, var_946);
        var_948 = wp::add(var_942, var_947);
        // origin[2] + local[2] * voxel_size[2],                                                  <L 1533>
        var_950 = wp::extract(var_origin, var_949);
        var_952 = wp::extract(var_932, var_951);
        var_954 = wp::extract(var_voxel_size, var_953);
        var_955 = wp::mul(var_952, var_954);
        var_956 = wp::add(var_950, var_955);
        var_957 = wp::vec_t<3, wp::float32>(var_940, var_948, var_956);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        wp::assign_inplace(var_756, var_891, var_957);
        // n = wp.cross(face_verts[1] - face_verts[0], face_verts[2] - face_verts[0])             <L 1535>
        var_959 = wp::extract(var_756, var_958);
        var_961 = wp::extract(var_756, var_960);
        var_962 = wp::sub(var_959, var_961);
        var_964 = wp::extract(var_756, var_963);
        var_966 = wp::extract(var_756, var_965);
        var_967 = wp::sub(var_964, var_966);
        var_968 = wp::cross(var_962, var_967);
        // n_sq = wp.dot(n, n)                                                                    <L 1536>
        var_969 = wp::dot(var_968, var_968);
        // if n_sq < MC_DEGENERATE_N_SQ_EPS:                                                      <L 1537>
        var_970 = (var_969 < var_459);
        if (var_970) {
            // normal = wp.vec3(0.0, 0.0, 1.0)                                                    <L 1538>
            var_974 = wp::vec_t<3, wp::float32>(var_971, var_972, var_973);
        }
        if (!var_970) {
            // normal = n / wp.sqrt(n_sq)                                                         <L 1540>
            var_975 = wp::sqrt(var_969);
            var_976 = wp::div(var_968, var_975);
        }
        var_977 = wp::where(var_970, var_974, var_976);
        // vertices[3 * out_idx + 3 * fi + 0] = wp.vec3(face_verts[0])                            <L 1541>
        var_979 = wp::extract(var_756, var_978);
        var_980 = wp::vec_t<3, wp::float32>(var_979);
        var_982 = wp::mul(var_981, var_234);
        var_984 = wp::mul(var_983, var_754);
        var_985 = wp::add(var_982, var_984);
        var_987 = wp::add(var_985, var_986);
        wp::array_store(var_vertices, var_987, var_980);
        // vertices[3 * out_idx + 3 * fi + 1] = wp.vec3(face_verts[1])                            <L 1542>
        var_989 = wp::extract(var_756, var_988);
        var_990 = wp::vec_t<3, wp::float32>(var_989);
        var_992 = wp::mul(var_991, var_234);
        var_994 = wp::mul(var_993, var_754);
        var_995 = wp::add(var_992, var_994);
        var_997 = wp::add(var_995, var_996);
        wp::array_store(var_vertices, var_997, var_990);
        // vertices[3 * out_idx + 3 * fi + 2] = wp.vec3(face_verts[2])                            <L 1543>
        var_999 = wp::extract(var_756, var_998);
        var_1000 = wp::vec_t<3, wp::float32>(var_999);
        var_1002 = wp::mul(var_1001, var_234);
        var_1004 = wp::mul(var_1003, var_754);
        var_1005 = wp::add(var_1002, var_1004);
        var_1007 = wp::add(var_1005, var_1006);
        wp::array_store(var_vertices, var_1007, var_1000);
        // face_normals[out_idx + fi] = normal                                                    <L 1544>
        var_1008 = wp::add(var_234, var_754);
        wp::array_store(var_face_normals, var_1008, var_977);
        // if fi >= num_faces:                                                                    <L 1514>
        var_1010 = (var_1009 >= var_232);
        if (var_1010) {
            // return                                                                             <L 1515>
            continue;
        }
        // face_verts = wp.mat33f()                                                               <L 1516>
        var_1011 = wp::mat_t<3, 3, wp::float32>();
        // for vi in range(3):                                                                    <L 1517>
        // ev = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                          <L 1518>
        var_1014 = wp::mul(var_1013, var_1009);
        var_1015 = wp::add(var_223, var_1014);
        var_1016 = wp::add(var_1015, var_1012);
        var_1017 = wp::address(var_flat_edge_verts_table, var_1016);
        var_1019 = wp::load(var_1017);
        var_1018 = wp::vec_t<2, wp::int32>(var_1019);
        // val_0 = wp.float32(corner_vals[ev[0]])                                                 <L 1519>
        var_1021 = wp::extract(var_1018, var_1020);
        var_1022 = wp::extract(var_5, var_1021);
        var_1023 = wp::float32(var_1022);
        // val_1 = wp.float32(corner_vals[ev[1]])                                                 <L 1520>
        var_1025 = wp::extract(var_1018, var_1024);
        var_1026 = wp::extract(var_5, var_1025);
        var_1027 = wp::float32(var_1026);
        // p_0 = wp.vec3f(corner_offsets_table[ev[0]])                                            <L 1521>
        var_1029 = wp::extract(var_1018, var_1028);
        var_1030 = wp::address(var_corner_offsets_table, var_1029);
        var_1032 = wp::load(var_1030);
        var_1031 = wp::vec_t<3, wp::float32>(var_1032);
        // p_1 = wp.vec3f(corner_offsets_table[ev[1]])                                            <L 1522>
        var_1034 = wp::extract(var_1018, var_1033);
        var_1035 = wp::address(var_corner_offsets_table, var_1034);
        var_1037 = wp::load(var_1035);
        var_1036 = wp::vec_t<3, wp::float32>(var_1037);
        // val_diff = val_1 - val_0                                                               <L 1523>
        var_1038 = wp::sub(var_1027, var_1023);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 1524>
        var_1039 = wp::abs(var_1038);
        var_1040 = (var_1039 < var_272);
        if (var_1040) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 1525>
            var_1042 = wp::add(var_1031, var_1036);
            var_1043 = wp::mul(var_1041, var_1042);
        }
        if (!var_1040) {
            // t = wp.clamp((0.0 - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 1527>
            var_1045 = wp::sub(var_1044, var_1023);
            var_1046 = wp::div(var_1045, var_1038);
            var_1047 = wp::clamp(var_1046, var_280, var_281);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 1528>
            var_1048 = wp::sub(var_1036, var_1031);
            var_1049 = wp::mul(var_1047, var_1048);
            var_1050 = wp::add(var_1031, var_1049);
        }
        var_1051 = wp::where(var_1040, var_1043, var_1050);
        var_1052 = wp::where(var_1040, var_931, var_1047);
        // local = base + p                                                                       <L 1529>
        var_1053 = wp::add(var_240, var_1051);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        // origin[0] + local[0] * voxel_size[0],                                                  <L 1531>
        var_1055 = wp::extract(var_origin, var_1054);
        var_1057 = wp::extract(var_1053, var_1056);
        var_1059 = wp::extract(var_voxel_size, var_1058);
        var_1060 = wp::mul(var_1057, var_1059);
        var_1061 = wp::add(var_1055, var_1060);
        // origin[1] + local[1] * voxel_size[1],                                                  <L 1532>
        var_1063 = wp::extract(var_origin, var_1062);
        var_1065 = wp::extract(var_1053, var_1064);
        var_1067 = wp::extract(var_voxel_size, var_1066);
        var_1068 = wp::mul(var_1065, var_1067);
        var_1069 = wp::add(var_1063, var_1068);
        // origin[2] + local[2] * voxel_size[2],                                                  <L 1533>
        var_1071 = wp::extract(var_origin, var_1070);
        var_1073 = wp::extract(var_1053, var_1072);
        var_1075 = wp::extract(var_voxel_size, var_1074);
        var_1076 = wp::mul(var_1073, var_1075);
        var_1077 = wp::add(var_1071, var_1076);
        var_1078 = wp::vec_t<3, wp::float32>(var_1061, var_1069, var_1077);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        wp::assign_inplace(var_1011, var_1012, var_1078);
        // ev = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                          <L 1518>
        var_1081 = wp::mul(var_1080, var_1009);
        var_1082 = wp::add(var_223, var_1081);
        var_1083 = wp::add(var_1082, var_1079);
        var_1084 = wp::address(var_flat_edge_verts_table, var_1083);
        var_1086 = wp::load(var_1084);
        var_1085 = wp::vec_t<2, wp::int32>(var_1086);
        // val_0 = wp.float32(corner_vals[ev[0]])                                                 <L 1519>
        var_1088 = wp::extract(var_1085, var_1087);
        var_1089 = wp::extract(var_5, var_1088);
        var_1090 = wp::float32(var_1089);
        // val_1 = wp.float32(corner_vals[ev[1]])                                                 <L 1520>
        var_1092 = wp::extract(var_1085, var_1091);
        var_1093 = wp::extract(var_5, var_1092);
        var_1094 = wp::float32(var_1093);
        // p_0 = wp.vec3f(corner_offsets_table[ev[0]])                                            <L 1521>
        var_1096 = wp::extract(var_1085, var_1095);
        var_1097 = wp::address(var_corner_offsets_table, var_1096);
        var_1099 = wp::load(var_1097);
        var_1098 = wp::vec_t<3, wp::float32>(var_1099);
        // p_1 = wp.vec3f(corner_offsets_table[ev[1]])                                            <L 1522>
        var_1101 = wp::extract(var_1085, var_1100);
        var_1102 = wp::address(var_corner_offsets_table, var_1101);
        var_1104 = wp::load(var_1102);
        var_1103 = wp::vec_t<3, wp::float32>(var_1104);
        // val_diff = val_1 - val_0                                                               <L 1523>
        var_1105 = wp::sub(var_1094, var_1090);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 1524>
        var_1106 = wp::abs(var_1105);
        var_1107 = (var_1106 < var_272);
        if (var_1107) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 1525>
            var_1109 = wp::add(var_1098, var_1103);
            var_1110 = wp::mul(var_1108, var_1109);
        }
        if (!var_1107) {
            // t = wp.clamp((0.0 - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 1527>
            var_1112 = wp::sub(var_1111, var_1090);
            var_1113 = wp::div(var_1112, var_1105);
            var_1114 = wp::clamp(var_1113, var_280, var_281);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 1528>
            var_1115 = wp::sub(var_1103, var_1098);
            var_1116 = wp::mul(var_1114, var_1115);
            var_1117 = wp::add(var_1098, var_1116);
        }
        var_1118 = wp::where(var_1107, var_1110, var_1117);
        var_1119 = wp::where(var_1107, var_1052, var_1114);
        // local = base + p                                                                       <L 1529>
        var_1120 = wp::add(var_240, var_1118);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        // origin[0] + local[0] * voxel_size[0],                                                  <L 1531>
        var_1122 = wp::extract(var_origin, var_1121);
        var_1124 = wp::extract(var_1120, var_1123);
        var_1126 = wp::extract(var_voxel_size, var_1125);
        var_1127 = wp::mul(var_1124, var_1126);
        var_1128 = wp::add(var_1122, var_1127);
        // origin[1] + local[1] * voxel_size[1],                                                  <L 1532>
        var_1130 = wp::extract(var_origin, var_1129);
        var_1132 = wp::extract(var_1120, var_1131);
        var_1134 = wp::extract(var_voxel_size, var_1133);
        var_1135 = wp::mul(var_1132, var_1134);
        var_1136 = wp::add(var_1130, var_1135);
        // origin[2] + local[2] * voxel_size[2],                                                  <L 1533>
        var_1138 = wp::extract(var_origin, var_1137);
        var_1140 = wp::extract(var_1120, var_1139);
        var_1142 = wp::extract(var_voxel_size, var_1141);
        var_1143 = wp::mul(var_1140, var_1142);
        var_1144 = wp::add(var_1138, var_1143);
        var_1145 = wp::vec_t<3, wp::float32>(var_1128, var_1136, var_1144);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        wp::assign_inplace(var_1011, var_1079, var_1145);
        // ev = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                          <L 1518>
        var_1148 = wp::mul(var_1147, var_1009);
        var_1149 = wp::add(var_223, var_1148);
        var_1150 = wp::add(var_1149, var_1146);
        var_1151 = wp::address(var_flat_edge_verts_table, var_1150);
        var_1153 = wp::load(var_1151);
        var_1152 = wp::vec_t<2, wp::int32>(var_1153);
        // val_0 = wp.float32(corner_vals[ev[0]])                                                 <L 1519>
        var_1155 = wp::extract(var_1152, var_1154);
        var_1156 = wp::extract(var_5, var_1155);
        var_1157 = wp::float32(var_1156);
        // val_1 = wp.float32(corner_vals[ev[1]])                                                 <L 1520>
        var_1159 = wp::extract(var_1152, var_1158);
        var_1160 = wp::extract(var_5, var_1159);
        var_1161 = wp::float32(var_1160);
        // p_0 = wp.vec3f(corner_offsets_table[ev[0]])                                            <L 1521>
        var_1163 = wp::extract(var_1152, var_1162);
        var_1164 = wp::address(var_corner_offsets_table, var_1163);
        var_1166 = wp::load(var_1164);
        var_1165 = wp::vec_t<3, wp::float32>(var_1166);
        // p_1 = wp.vec3f(corner_offsets_table[ev[1]])                                            <L 1522>
        var_1168 = wp::extract(var_1152, var_1167);
        var_1169 = wp::address(var_corner_offsets_table, var_1168);
        var_1171 = wp::load(var_1169);
        var_1170 = wp::vec_t<3, wp::float32>(var_1171);
        // val_diff = val_1 - val_0                                                               <L 1523>
        var_1172 = wp::sub(var_1161, var_1157);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 1524>
        var_1173 = wp::abs(var_1172);
        var_1174 = (var_1173 < var_272);
        if (var_1174) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 1525>
            var_1176 = wp::add(var_1165, var_1170);
            var_1177 = wp::mul(var_1175, var_1176);
        }
        if (!var_1174) {
            // t = wp.clamp((0.0 - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 1527>
            var_1179 = wp::sub(var_1178, var_1157);
            var_1180 = wp::div(var_1179, var_1172);
            var_1181 = wp::clamp(var_1180, var_280, var_281);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 1528>
            var_1182 = wp::sub(var_1170, var_1165);
            var_1183 = wp::mul(var_1181, var_1182);
            var_1184 = wp::add(var_1165, var_1183);
        }
        var_1185 = wp::where(var_1174, var_1177, var_1184);
        var_1186 = wp::where(var_1174, var_1119, var_1181);
        // local = base + p                                                                       <L 1529>
        var_1187 = wp::add(var_240, var_1185);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        // origin[0] + local[0] * voxel_size[0],                                                  <L 1531>
        var_1189 = wp::extract(var_origin, var_1188);
        var_1191 = wp::extract(var_1187, var_1190);
        var_1193 = wp::extract(var_voxel_size, var_1192);
        var_1194 = wp::mul(var_1191, var_1193);
        var_1195 = wp::add(var_1189, var_1194);
        // origin[1] + local[1] * voxel_size[1],                                                  <L 1532>
        var_1197 = wp::extract(var_origin, var_1196);
        var_1199 = wp::extract(var_1187, var_1198);
        var_1201 = wp::extract(var_voxel_size, var_1200);
        var_1202 = wp::mul(var_1199, var_1201);
        var_1203 = wp::add(var_1197, var_1202);
        // origin[2] + local[2] * voxel_size[2],                                                  <L 1533>
        var_1205 = wp::extract(var_origin, var_1204);
        var_1207 = wp::extract(var_1187, var_1206);
        var_1209 = wp::extract(var_voxel_size, var_1208);
        var_1210 = wp::mul(var_1207, var_1209);
        var_1211 = wp::add(var_1205, var_1210);
        var_1212 = wp::vec_t<3, wp::float32>(var_1195, var_1203, var_1211);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        wp::assign_inplace(var_1011, var_1146, var_1212);
        // n = wp.cross(face_verts[1] - face_verts[0], face_verts[2] - face_verts[0])             <L 1535>
        var_1214 = wp::extract(var_1011, var_1213);
        var_1216 = wp::extract(var_1011, var_1215);
        var_1217 = wp::sub(var_1214, var_1216);
        var_1219 = wp::extract(var_1011, var_1218);
        var_1221 = wp::extract(var_1011, var_1220);
        var_1222 = wp::sub(var_1219, var_1221);
        var_1223 = wp::cross(var_1217, var_1222);
        // n_sq = wp.dot(n, n)                                                                    <L 1536>
        var_1224 = wp::dot(var_1223, var_1223);
        // if n_sq < MC_DEGENERATE_N_SQ_EPS:                                                      <L 1537>
        var_1225 = (var_1224 < var_459);
        if (var_1225) {
            // normal = wp.vec3(0.0, 0.0, 1.0)                                                    <L 1538>
            var_1229 = wp::vec_t<3, wp::float32>(var_1226, var_1227, var_1228);
        }
        if (!var_1225) {
            // normal = n / wp.sqrt(n_sq)                                                         <L 1540>
            var_1230 = wp::sqrt(var_1224);
            var_1231 = wp::div(var_1223, var_1230);
        }
        var_1232 = wp::where(var_1225, var_1229, var_1231);
        // vertices[3 * out_idx + 3 * fi + 0] = wp.vec3(face_verts[0])                            <L 1541>
        var_1234 = wp::extract(var_1011, var_1233);
        var_1235 = wp::vec_t<3, wp::float32>(var_1234);
        var_1237 = wp::mul(var_1236, var_234);
        var_1239 = wp::mul(var_1238, var_1009);
        var_1240 = wp::add(var_1237, var_1239);
        var_1242 = wp::add(var_1240, var_1241);
        wp::array_store(var_vertices, var_1242, var_1235);
        // vertices[3 * out_idx + 3 * fi + 1] = wp.vec3(face_verts[1])                            <L 1542>
        var_1244 = wp::extract(var_1011, var_1243);
        var_1245 = wp::vec_t<3, wp::float32>(var_1244);
        var_1247 = wp::mul(var_1246, var_234);
        var_1249 = wp::mul(var_1248, var_1009);
        var_1250 = wp::add(var_1247, var_1249);
        var_1252 = wp::add(var_1250, var_1251);
        wp::array_store(var_vertices, var_1252, var_1245);
        // vertices[3 * out_idx + 3 * fi + 2] = wp.vec3(face_verts[2])                            <L 1543>
        var_1254 = wp::extract(var_1011, var_1253);
        var_1255 = wp::vec_t<3, wp::float32>(var_1254);
        var_1257 = wp::mul(var_1256, var_234);
        var_1259 = wp::mul(var_1258, var_1009);
        var_1260 = wp::add(var_1257, var_1259);
        var_1262 = wp::add(var_1260, var_1261);
        wp::array_store(var_vertices, var_1262, var_1255);
        // face_normals[out_idx + fi] = normal                                                    <L 1544>
        var_1263 = wp::add(var_234, var_1009);
        wp::array_store(var_face_normals, var_1263, var_1232);
        // if fi >= num_faces:                                                                    <L 1514>
        var_1265 = (var_1264 >= var_232);
        if (var_1265) {
            // return                                                                             <L 1515>
            continue;
        }
        // face_verts = wp.mat33f()                                                               <L 1516>
        var_1266 = wp::mat_t<3, 3, wp::float32>();
        // for vi in range(3):                                                                    <L 1517>
        // ev = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                          <L 1518>
        var_1269 = wp::mul(var_1268, var_1264);
        var_1270 = wp::add(var_223, var_1269);
        var_1271 = wp::add(var_1270, var_1267);
        var_1272 = wp::address(var_flat_edge_verts_table, var_1271);
        var_1274 = wp::load(var_1272);
        var_1273 = wp::vec_t<2, wp::int32>(var_1274);
        // val_0 = wp.float32(corner_vals[ev[0]])                                                 <L 1519>
        var_1276 = wp::extract(var_1273, var_1275);
        var_1277 = wp::extract(var_5, var_1276);
        var_1278 = wp::float32(var_1277);
        // val_1 = wp.float32(corner_vals[ev[1]])                                                 <L 1520>
        var_1280 = wp::extract(var_1273, var_1279);
        var_1281 = wp::extract(var_5, var_1280);
        var_1282 = wp::float32(var_1281);
        // p_0 = wp.vec3f(corner_offsets_table[ev[0]])                                            <L 1521>
        var_1284 = wp::extract(var_1273, var_1283);
        var_1285 = wp::address(var_corner_offsets_table, var_1284);
        var_1287 = wp::load(var_1285);
        var_1286 = wp::vec_t<3, wp::float32>(var_1287);
        // p_1 = wp.vec3f(corner_offsets_table[ev[1]])                                            <L 1522>
        var_1289 = wp::extract(var_1273, var_1288);
        var_1290 = wp::address(var_corner_offsets_table, var_1289);
        var_1292 = wp::load(var_1290);
        var_1291 = wp::vec_t<3, wp::float32>(var_1292);
        // val_diff = val_1 - val_0                                                               <L 1523>
        var_1293 = wp::sub(var_1282, var_1278);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 1524>
        var_1294 = wp::abs(var_1293);
        var_1295 = (var_1294 < var_272);
        if (var_1295) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 1525>
            var_1297 = wp::add(var_1286, var_1291);
            var_1298 = wp::mul(var_1296, var_1297);
        }
        if (!var_1295) {
            // t = wp.clamp((0.0 - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 1527>
            var_1300 = wp::sub(var_1299, var_1278);
            var_1301 = wp::div(var_1300, var_1293);
            var_1302 = wp::clamp(var_1301, var_280, var_281);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 1528>
            var_1303 = wp::sub(var_1291, var_1286);
            var_1304 = wp::mul(var_1302, var_1303);
            var_1305 = wp::add(var_1286, var_1304);
        }
        var_1306 = wp::where(var_1295, var_1298, var_1305);
        var_1307 = wp::where(var_1295, var_1186, var_1302);
        // local = base + p                                                                       <L 1529>
        var_1308 = wp::add(var_240, var_1306);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        // origin[0] + local[0] * voxel_size[0],                                                  <L 1531>
        var_1310 = wp::extract(var_origin, var_1309);
        var_1312 = wp::extract(var_1308, var_1311);
        var_1314 = wp::extract(var_voxel_size, var_1313);
        var_1315 = wp::mul(var_1312, var_1314);
        var_1316 = wp::add(var_1310, var_1315);
        // origin[1] + local[1] * voxel_size[1],                                                  <L 1532>
        var_1318 = wp::extract(var_origin, var_1317);
        var_1320 = wp::extract(var_1308, var_1319);
        var_1322 = wp::extract(var_voxel_size, var_1321);
        var_1323 = wp::mul(var_1320, var_1322);
        var_1324 = wp::add(var_1318, var_1323);
        // origin[2] + local[2] * voxel_size[2],                                                  <L 1533>
        var_1326 = wp::extract(var_origin, var_1325);
        var_1328 = wp::extract(var_1308, var_1327);
        var_1330 = wp::extract(var_voxel_size, var_1329);
        var_1331 = wp::mul(var_1328, var_1330);
        var_1332 = wp::add(var_1326, var_1331);
        var_1333 = wp::vec_t<3, wp::float32>(var_1316, var_1324, var_1332);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        wp::assign_inplace(var_1266, var_1267, var_1333);
        // ev = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                          <L 1518>
        var_1336 = wp::mul(var_1335, var_1264);
        var_1337 = wp::add(var_223, var_1336);
        var_1338 = wp::add(var_1337, var_1334);
        var_1339 = wp::address(var_flat_edge_verts_table, var_1338);
        var_1341 = wp::load(var_1339);
        var_1340 = wp::vec_t<2, wp::int32>(var_1341);
        // val_0 = wp.float32(corner_vals[ev[0]])                                                 <L 1519>
        var_1343 = wp::extract(var_1340, var_1342);
        var_1344 = wp::extract(var_5, var_1343);
        var_1345 = wp::float32(var_1344);
        // val_1 = wp.float32(corner_vals[ev[1]])                                                 <L 1520>
        var_1347 = wp::extract(var_1340, var_1346);
        var_1348 = wp::extract(var_5, var_1347);
        var_1349 = wp::float32(var_1348);
        // p_0 = wp.vec3f(corner_offsets_table[ev[0]])                                            <L 1521>
        var_1351 = wp::extract(var_1340, var_1350);
        var_1352 = wp::address(var_corner_offsets_table, var_1351);
        var_1354 = wp::load(var_1352);
        var_1353 = wp::vec_t<3, wp::float32>(var_1354);
        // p_1 = wp.vec3f(corner_offsets_table[ev[1]])                                            <L 1522>
        var_1356 = wp::extract(var_1340, var_1355);
        var_1357 = wp::address(var_corner_offsets_table, var_1356);
        var_1359 = wp::load(var_1357);
        var_1358 = wp::vec_t<3, wp::float32>(var_1359);
        // val_diff = val_1 - val_0                                                               <L 1523>
        var_1360 = wp::sub(var_1349, var_1345);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 1524>
        var_1361 = wp::abs(var_1360);
        var_1362 = (var_1361 < var_272);
        if (var_1362) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 1525>
            var_1364 = wp::add(var_1353, var_1358);
            var_1365 = wp::mul(var_1363, var_1364);
        }
        if (!var_1362) {
            // t = wp.clamp((0.0 - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 1527>
            var_1367 = wp::sub(var_1366, var_1345);
            var_1368 = wp::div(var_1367, var_1360);
            var_1369 = wp::clamp(var_1368, var_280, var_281);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 1528>
            var_1370 = wp::sub(var_1358, var_1353);
            var_1371 = wp::mul(var_1369, var_1370);
            var_1372 = wp::add(var_1353, var_1371);
        }
        var_1373 = wp::where(var_1362, var_1365, var_1372);
        var_1374 = wp::where(var_1362, var_1307, var_1369);
        // local = base + p                                                                       <L 1529>
        var_1375 = wp::add(var_240, var_1373);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        // origin[0] + local[0] * voxel_size[0],                                                  <L 1531>
        var_1377 = wp::extract(var_origin, var_1376);
        var_1379 = wp::extract(var_1375, var_1378);
        var_1381 = wp::extract(var_voxel_size, var_1380);
        var_1382 = wp::mul(var_1379, var_1381);
        var_1383 = wp::add(var_1377, var_1382);
        // origin[1] + local[1] * voxel_size[1],                                                  <L 1532>
        var_1385 = wp::extract(var_origin, var_1384);
        var_1387 = wp::extract(var_1375, var_1386);
        var_1389 = wp::extract(var_voxel_size, var_1388);
        var_1390 = wp::mul(var_1387, var_1389);
        var_1391 = wp::add(var_1385, var_1390);
        // origin[2] + local[2] * voxel_size[2],                                                  <L 1533>
        var_1393 = wp::extract(var_origin, var_1392);
        var_1395 = wp::extract(var_1375, var_1394);
        var_1397 = wp::extract(var_voxel_size, var_1396);
        var_1398 = wp::mul(var_1395, var_1397);
        var_1399 = wp::add(var_1393, var_1398);
        var_1400 = wp::vec_t<3, wp::float32>(var_1383, var_1391, var_1399);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        wp::assign_inplace(var_1266, var_1334, var_1400);
        // ev = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                          <L 1518>
        var_1403 = wp::mul(var_1402, var_1264);
        var_1404 = wp::add(var_223, var_1403);
        var_1405 = wp::add(var_1404, var_1401);
        var_1406 = wp::address(var_flat_edge_verts_table, var_1405);
        var_1408 = wp::load(var_1406);
        var_1407 = wp::vec_t<2, wp::int32>(var_1408);
        // val_0 = wp.float32(corner_vals[ev[0]])                                                 <L 1519>
        var_1410 = wp::extract(var_1407, var_1409);
        var_1411 = wp::extract(var_5, var_1410);
        var_1412 = wp::float32(var_1411);
        // val_1 = wp.float32(corner_vals[ev[1]])                                                 <L 1520>
        var_1414 = wp::extract(var_1407, var_1413);
        var_1415 = wp::extract(var_5, var_1414);
        var_1416 = wp::float32(var_1415);
        // p_0 = wp.vec3f(corner_offsets_table[ev[0]])                                            <L 1521>
        var_1418 = wp::extract(var_1407, var_1417);
        var_1419 = wp::address(var_corner_offsets_table, var_1418);
        var_1421 = wp::load(var_1419);
        var_1420 = wp::vec_t<3, wp::float32>(var_1421);
        // p_1 = wp.vec3f(corner_offsets_table[ev[1]])                                            <L 1522>
        var_1423 = wp::extract(var_1407, var_1422);
        var_1424 = wp::address(var_corner_offsets_table, var_1423);
        var_1426 = wp::load(var_1424);
        var_1425 = wp::vec_t<3, wp::float32>(var_1426);
        // val_diff = val_1 - val_0                                                               <L 1523>
        var_1427 = wp::sub(var_1416, var_1412);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 1524>
        var_1428 = wp::abs(var_1427);
        var_1429 = (var_1428 < var_272);
        if (var_1429) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 1525>
            var_1431 = wp::add(var_1420, var_1425);
            var_1432 = wp::mul(var_1430, var_1431);
        }
        if (!var_1429) {
            // t = wp.clamp((0.0 - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 1527>
            var_1434 = wp::sub(var_1433, var_1412);
            var_1435 = wp::div(var_1434, var_1427);
            var_1436 = wp::clamp(var_1435, var_280, var_281);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 1528>
            var_1437 = wp::sub(var_1425, var_1420);
            var_1438 = wp::mul(var_1436, var_1437);
            var_1439 = wp::add(var_1420, var_1438);
        }
        var_1440 = wp::where(var_1429, var_1432, var_1439);
        var_1441 = wp::where(var_1429, var_1374, var_1436);
        // local = base + p                                                                       <L 1529>
        var_1442 = wp::add(var_240, var_1440);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        // origin[0] + local[0] * voxel_size[0],                                                  <L 1531>
        var_1444 = wp::extract(var_origin, var_1443);
        var_1446 = wp::extract(var_1442, var_1445);
        var_1448 = wp::extract(var_voxel_size, var_1447);
        var_1449 = wp::mul(var_1446, var_1448);
        var_1450 = wp::add(var_1444, var_1449);
        // origin[1] + local[1] * voxel_size[1],                                                  <L 1532>
        var_1452 = wp::extract(var_origin, var_1451);
        var_1454 = wp::extract(var_1442, var_1453);
        var_1456 = wp::extract(var_voxel_size, var_1455);
        var_1457 = wp::mul(var_1454, var_1456);
        var_1458 = wp::add(var_1452, var_1457);
        // origin[2] + local[2] * voxel_size[2],                                                  <L 1533>
        var_1460 = wp::extract(var_origin, var_1459);
        var_1462 = wp::extract(var_1442, var_1461);
        var_1464 = wp::extract(var_voxel_size, var_1463);
        var_1465 = wp::mul(var_1462, var_1464);
        var_1466 = wp::add(var_1460, var_1465);
        var_1467 = wp::vec_t<3, wp::float32>(var_1450, var_1458, var_1466);
        // face_verts[vi] = wp.vec3(                                                              <L 1530>
        wp::assign_inplace(var_1266, var_1401, var_1467);
        // n = wp.cross(face_verts[1] - face_verts[0], face_verts[2] - face_verts[0])             <L 1535>
        var_1469 = wp::extract(var_1266, var_1468);
        var_1471 = wp::extract(var_1266, var_1470);
        var_1472 = wp::sub(var_1469, var_1471);
        var_1474 = wp::extract(var_1266, var_1473);
        var_1476 = wp::extract(var_1266, var_1475);
        var_1477 = wp::sub(var_1474, var_1476);
        var_1478 = wp::cross(var_1472, var_1477);
        // n_sq = wp.dot(n, n)                                                                    <L 1536>
        var_1479 = wp::dot(var_1478, var_1478);
        // if n_sq < MC_DEGENERATE_N_SQ_EPS:                                                      <L 1537>
        var_1480 = (var_1479 < var_459);
        if (var_1480) {
            // normal = wp.vec3(0.0, 0.0, 1.0)                                                    <L 1538>
            var_1484 = wp::vec_t<3, wp::float32>(var_1481, var_1482, var_1483);
        }
        if (!var_1480) {
            // normal = n / wp.sqrt(n_sq)                                                         <L 1540>
            var_1485 = wp::sqrt(var_1479);
            var_1486 = wp::div(var_1478, var_1485);
        }
        var_1487 = wp::where(var_1480, var_1484, var_1486);
        // vertices[3 * out_idx + 3 * fi + 0] = wp.vec3(face_verts[0])                            <L 1541>
        var_1489 = wp::extract(var_1266, var_1488);
        var_1490 = wp::vec_t<3, wp::float32>(var_1489);
        var_1492 = wp::mul(var_1491, var_234);
        var_1494 = wp::mul(var_1493, var_1264);
        var_1495 = wp::add(var_1492, var_1494);
        var_1497 = wp::add(var_1495, var_1496);
        wp::array_store(var_vertices, var_1497, var_1490);
        // vertices[3 * out_idx + 3 * fi + 1] = wp.vec3(face_verts[1])                            <L 1542>
        var_1499 = wp::extract(var_1266, var_1498);
        var_1500 = wp::vec_t<3, wp::float32>(var_1499);
        var_1502 = wp::mul(var_1501, var_234);
        var_1504 = wp::mul(var_1503, var_1264);
        var_1505 = wp::add(var_1502, var_1504);
        var_1507 = wp::add(var_1505, var_1506);
        wp::array_store(var_vertices, var_1507, var_1500);
        // vertices[3 * out_idx + 3 * fi + 2] = wp.vec3(face_verts[2])                            <L 1543>
        var_1509 = wp::extract(var_1266, var_1508);
        var_1510 = wp::vec_t<3, wp::float32>(var_1509);
        var_1512 = wp::mul(var_1511, var_234);
        var_1514 = wp::mul(var_1513, var_1264);
        var_1515 = wp::add(var_1512, var_1514);
        var_1517 = wp::add(var_1515, var_1516);
        wp::array_store(var_vertices, var_1517, var_1510);
        // face_normals[out_idx + fi] = normal                                                    <L 1544>
        var_1518 = wp::add(var_234, var_1264);
        wp::array_store(var_face_normals, var_1518, var_1487);
    }
}



extern "C" __global__ void sdf_from_mesh_kernel_cb6de318_cuda_kernel_forward(
    wp::launch_bounds_t<4> dim,
    wp::uint64 var_mesh,
    wp::uint64 var_sdf,
    wp::array_t<wp::vec_t<3, wp::int32>> var_tile_points,
    wp::float32 var_shape_margin,
    wp::float32 var_winding_threshold)
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
        wp::int32 var_3;
        wp::vec_t<3, wp::int32>* var_4;
        wp::vec_t<3, wp::int32> var_5;
        wp::vec_t<3, wp::int32> var_6;
        const wp::int32 var_7 = 0;
        wp::int32 var_8;
        wp::int32 var_9;
        const wp::int32 var_10 = 1;
        wp::int32 var_11;
        wp::int32 var_12;
        const wp::int32 var_13 = 2;
        wp::int32 var_14;
        wp::int32 var_15;
        wp::vec_t<3, wp::float32> var_16;
        wp::vec_t<3, wp::float32> var_17;
        const wp::float32 var_18 = 10000.0;
        wp::float32 var_19;
        wp::float32 var_20;
        //---------
        // forward
        // def sdf_from_mesh_kernel(                                                              <L 696>
        // tile_idx, local_x, local_y, local_z = wp.tid()                                         <L 707>
        builtin_tid4d(var_0, var_1, var_2, var_3);
        // tile_origin = tile_points[tile_idx]                                                    <L 710>
        var_4 = wp::address(var_tile_points, var_0);
        var_6 = wp::load(var_4);
        var_5 = wp::copy(var_6);
        // x_id = tile_origin[0] + local_x                                                        <L 711>
        var_8 = wp::extract(var_5, var_7);
        var_9 = wp::add(var_8, var_1);
        // y_id = tile_origin[1] + local_y                                                        <L 712>
        var_11 = wp::extract(var_5, var_10);
        var_12 = wp::add(var_11, var_2);
        // z_id = tile_origin[2] + local_z                                                        <L 713>
        var_14 = wp::extract(var_5, var_13);
        var_15 = wp::add(var_14, var_3);
        // sample_pos = wp.volume_index_to_world(sdf, int_to_vec3f(x_id, y_id, z_id))             <L 715>
        var_16 = int_to_vec3f_0(var_9, var_12, var_15);
        var_17 = wp::volume_index_to_world(var_sdf, var_16);
        // signed_distance = get_distance_to_mesh(mesh, sample_pos, 10000.0, winding_threshold)       <L 716>
        var_19 = get_distance_to_mesh_0(var_mesh, var_17, var_18, var_winding_threshold);
        // signed_distance -= shape_margin                                                        <L 717>
        var_20 = wp::sub(var_19, var_shape_margin);
        // wp.volume_store(sdf, x_id, y_id, z_id, signed_distance)                                <L 718>
        wp::volume_store(var_sdf, var_9, var_12, var_15, var_20);
    }
}



extern "C" __global__ void sdf_from_mesh_kernel_cb6de318_cuda_kernel_backward(
    wp::launch_bounds_t<4> dim,
    wp::uint64 var_mesh,
    wp::uint64 var_sdf,
    wp::array_t<wp::vec_t<3, wp::int32>> var_tile_points,
    wp::float32 var_shape_margin,
    wp::float32 var_winding_threshold,
    wp::uint64 adj_mesh,
    wp::uint64 adj_sdf,
    wp::array_t<wp::vec_t<3, wp::int32>> adj_tile_points,
    wp::float32 adj_shape_margin,
    wp::float32 adj_winding_threshold)
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
        wp::int32 var_3;
        wp::vec_t<3, wp::int32>* var_4;
        wp::vec_t<3, wp::int32> var_5;
        wp::vec_t<3, wp::int32> var_6;
        const wp::int32 var_7 = 0;
        wp::int32 var_8;
        wp::int32 var_9;
        const wp::int32 var_10 = 1;
        wp::int32 var_11;
        wp::int32 var_12;
        const wp::int32 var_13 = 2;
        wp::int32 var_14;
        wp::int32 var_15;
        wp::vec_t<3, wp::float32> var_16;
        wp::vec_t<3, wp::float32> var_17;
        const wp::float32 var_18 = 10000.0;
        wp::float32 var_19;
        wp::float32 var_20;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::int32 adj_2 = {};
        wp::int32 adj_3 = {};
        wp::vec_t<3, wp::int32> adj_4 = {};
        wp::vec_t<3, wp::int32> adj_5 = {};
        wp::vec_t<3, wp::int32> adj_6 = {};
        wp::int32 adj_7 = {};
        wp::int32 adj_8 = {};
        wp::int32 adj_9 = {};
        wp::int32 adj_10 = {};
        wp::int32 adj_11 = {};
        wp::int32 adj_12 = {};
        wp::int32 adj_13 = {};
        wp::int32 adj_14 = {};
        wp::int32 adj_15 = {};
        wp::vec_t<3, wp::float32> adj_16 = {};
        wp::vec_t<3, wp::float32> adj_17 = {};
        wp::float32 adj_18 = {};
        wp::float32 adj_19 = {};
        wp::float32 adj_20 = {};
        //---------
        // forward
        // def sdf_from_mesh_kernel(                                                              <L 696>
        // tile_idx, local_x, local_y, local_z = wp.tid()                                         <L 707>
        builtin_tid4d(var_0, var_1, var_2, var_3);
        // tile_origin = tile_points[tile_idx]                                                    <L 710>
        var_4 = wp::address(var_tile_points, var_0);
        var_6 = wp::load(var_4);
        var_5 = wp::copy(var_6);
        // x_id = tile_origin[0] + local_x                                                        <L 711>
        var_8 = wp::extract(var_5, var_7);
        var_9 = wp::add(var_8, var_1);
        // y_id = tile_origin[1] + local_y                                                        <L 712>
        var_11 = wp::extract(var_5, var_10);
        var_12 = wp::add(var_11, var_2);
        // z_id = tile_origin[2] + local_z                                                        <L 713>
        var_14 = wp::extract(var_5, var_13);
        var_15 = wp::add(var_14, var_3);
        // sample_pos = wp.volume_index_to_world(sdf, int_to_vec3f(x_id, y_id, z_id))             <L 715>
        var_16 = int_to_vec3f_0(var_9, var_12, var_15);
        var_17 = wp::volume_index_to_world(var_sdf, var_16);
        // signed_distance = get_distance_to_mesh(mesh, sample_pos, 10000.0, winding_threshold)       <L 716>
        var_19 = get_distance_to_mesh_0(var_mesh, var_17, var_18, var_winding_threshold);
        // signed_distance -= shape_margin                                                        <L 717>
        var_20 = wp::sub(var_19, var_shape_margin);
        // wp.volume_store(sdf, x_id, y_id, z_id, signed_distance)                                <L 718>
        wp::volume_store(var_sdf, var_9, var_12, var_15, var_20);
        //---------
        // reverse
        // adj: wp.volume_store(sdf, x_id, y_id, z_id, signed_distance)                           <L 718>
        wp::adj_sub(var_19, var_shape_margin, adj_19, adj_shape_margin, adj_20);
        // adj: signed_distance -= shape_margin                                                   <L 717>
        adj_get_distance_to_mesh_0(var_mesh, var_17, var_18, var_winding_threshold, adj_mesh, adj_17, adj_18, adj_winding_threshold, adj_19);
        // adj: signed_distance = get_distance_to_mesh(mesh, sample_pos, 10000.0, winding_threshold)  <L 716>
        wp::adj_volume_index_to_world(var_sdf, var_16, adj_sdf, adj_16, adj_17);
        adj_int_to_vec3f_0(var_9, var_12, var_15, adj_9, adj_12, adj_15, adj_16);
        // adj: sample_pos = wp.volume_index_to_world(sdf, int_to_vec3f(x_id, y_id, z_id))        <L 715>
        wp::adj_add(var_14, var_3, adj_14, adj_3, adj_15);
        wp::adj_extract(var_5, var_13, adj_5, adj_13, adj_14);
        // adj: z_id = tile_origin[2] + local_z                                                   <L 713>
        wp::adj_add(var_11, var_2, adj_11, adj_2, adj_12);
        wp::adj_extract(var_5, var_10, adj_5, adj_10, adj_11);
        // adj: y_id = tile_origin[1] + local_y                                                   <L 712>
        wp::adj_add(var_8, var_1, adj_8, adj_1, adj_9);
        wp::adj_extract(var_5, var_7, adj_5, adj_7, adj_8);
        // adj: x_id = tile_origin[0] + local_x                                                   <L 711>
        wp::adj_copy(var_6, adj_4, adj_5);
        wp::adj_address(var_tile_points, var_0, adj_tile_points, adj_0, adj_4);
        // adj: tile_origin = tile_points[tile_idx]                                               <L 710>
        // adj: tile_idx, local_x, local_y, local_z = wp.tid()                                    <L 707>
        // adj: def sdf_from_mesh_kernel(                                                         <L 696>
        continue;
    }
}



extern "C" __global__ void sdf_from_primitive_kernel_f27fe889_cuda_kernel_forward(
    wp::launch_bounds_t<4> dim,
    wp::int32 var_shape_type,
    wp::vec_t<3, wp::float32> var_shape_scale,
    wp::uint64 var_sdf,
    wp::array_t<wp::vec_t<3, wp::int32>> var_tile_points,
    wp::float32 var_shape_margin)
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
        wp::int32 var_3;
        wp::vec_t<3, wp::int32>* var_4;
        wp::vec_t<3, wp::int32> var_5;
        wp::vec_t<3, wp::int32> var_6;
        const wp::int32 var_7 = 0;
        wp::int32 var_8;
        wp::int32 var_9;
        const wp::int32 var_10 = 1;
        wp::int32 var_11;
        wp::int32 var_12;
        const wp::int32 var_13 = 2;
        wp::int32 var_14;
        wp::int32 var_15;
        wp::vec_t<3, wp::float32> var_16;
        wp::vec_t<3, wp::float32> var_17;
        const wp::float32 var_18 = 1000000.0;
        wp::float32 var_19;
        const wp::int32 var_20 = 3;
        bool var_21;
        const wp::int32 var_22 = 0;
        wp::float32 var_23;
        wp::float32 var_24;
        const wp::int32 var_25 = 7;
        bool var_26;
        const wp::int32 var_27 = 0;
        wp::float32 var_28;
        const wp::int32 var_29 = 1;
        wp::float32 var_30;
        const wp::int32 var_31 = 2;
        wp::float32 var_32;
        wp::float32 var_33;
        const wp::int32 var_34 = 4;
        bool var_35;
        const wp::int32 var_36 = 0;
        wp::float32 var_37;
        const wp::int32 var_38 = 1;
        wp::float32 var_39;
        const wp::int32 var_40 = 2;
        const wp::int32 var_41 = 2;
        wp::int32 var_42;
        wp::float32 var_43;
        const wp::int32 var_44 = 6;
        bool var_45;
        const wp::int32 var_46 = 0;
        wp::float32 var_47;
        const wp::int32 var_48 = 1;
        wp::float32 var_49;
        const wp::int32 var_50 = 2;
        const wp::int32 var_51 = 2;
        wp::int32 var_52;
        wp::float32 var_53;
        const wp::float32 var_54 = -1.0;
        const wp::int32 var_55 = 5;
        bool var_56;
        wp::float32 var_57;
        const wp::int32 var_58 = 9;
        bool var_59;
        const wp::int32 var_60 = 0;
        wp::float32 var_61;
        const wp::int32 var_62 = 1;
        wp::float32 var_63;
        const wp::int32 var_64 = 2;
        const wp::int32 var_65 = 2;
        wp::int32 var_66;
        wp::float32 var_67;
        wp::float32 var_68;
        wp::float32 var_69;
        wp::float32 var_70;
        wp::float32 var_71;
        wp::float32 var_72;
        wp::float32 var_73;
        wp::float32 var_74;
        //---------
        // forward
        // def sdf_from_primitive_kernel(                                                         <L 722>
        // tile_idx, local_x, local_y, local_z = wp.tid()                                         <L 733>
        builtin_tid4d(var_0, var_1, var_2, var_3);
        // tile_origin = tile_points[tile_idx]                                                    <L 735>
        var_4 = wp::address(var_tile_points, var_0);
        var_6 = wp::load(var_4);
        var_5 = wp::copy(var_6);
        // x_id = tile_origin[0] + local_x                                                        <L 736>
        var_8 = wp::extract(var_5, var_7);
        var_9 = wp::add(var_8, var_1);
        // y_id = tile_origin[1] + local_y                                                        <L 737>
        var_11 = wp::extract(var_5, var_10);
        var_12 = wp::add(var_11, var_2);
        // z_id = tile_origin[2] + local_z                                                        <L 738>
        var_14 = wp::extract(var_5, var_13);
        var_15 = wp::add(var_14, var_3);
        // sample_pos = wp.volume_index_to_world(sdf, int_to_vec3f(x_id, y_id, z_id))             <L 740>
        var_16 = int_to_vec3f_0(var_9, var_12, var_15);
        var_17 = wp::volume_index_to_world(var_sdf, var_16);
        // signed_distance = float(1.0e6)                                                         <L 741>
        var_19 = wp::float(var_18);
        // if shape_type == GeoType.SPHERE:                                                       <L 742>
        var_21 = (var_shape_type == var_20);
        if (var_21) {
            // signed_distance = sdf_sphere(sample_pos, shape_scale[0])                           <L 743>
            var_23 = wp::extract(var_shape_scale, var_22);
            var_24 = sdf_sphere_0(var_17, var_23);
        }
        if (!var_21) {
            // elif shape_type == GeoType.BOX:                                                    <L 744>
            var_26 = (var_shape_type == var_25);
            if (var_26) {
                // signed_distance = sdf_box(sample_pos, shape_scale[0], shape_scale[1], shape_scale[2])       <L 745>
                var_28 = wp::extract(var_shape_scale, var_27);
                var_30 = wp::extract(var_shape_scale, var_29);
                var_32 = wp::extract(var_shape_scale, var_31);
                var_33 = sdf_box_0(var_17, var_28, var_30, var_32);
            }
            if (!var_26) {
                // elif shape_type == GeoType.CAPSULE:                                            <L 746>
                var_35 = (var_shape_type == var_34);
                if (var_35) {
                    // signed_distance = sdf_capsule(sample_pos, shape_scale[0], shape_scale[1], int(Axis.Z))       <L 747>
                    var_37 = wp::extract(var_shape_scale, var_36);
                    var_39 = wp::extract(var_shape_scale, var_38);
                    var_42 = wp::int(var_41);
                    var_43 = sdf_capsule_0(var_17, var_37, var_39, var_42);
                }
                if (!var_35) {
                    // elif shape_type == GeoType.CYLINDER:                                       <L 748>
                    var_45 = (var_shape_type == var_44);
                    if (var_45) {
                        // signed_distance = sdf_cylinder(sample_pos, shape_scale[0], shape_scale[1], int(Axis.Z))       <L 749>
                        var_47 = wp::extract(var_shape_scale, var_46);
                        var_49 = wp::extract(var_shape_scale, var_48);
                        var_52 = wp::int(var_51);
                        var_53 = sdf_cylinder_0(var_17, var_47, var_49, var_52, var_54);
                    }
                    if (!var_45) {
                        // elif shape_type == GeoType.ELLIPSOID:                                  <L 750>
                        var_56 = (var_shape_type == var_55);
                        if (var_56) {
                            // signed_distance = sdf_ellipsoid(sample_pos, shape_scale)           <L 751>
                            var_57 = sdf_ellipsoid_0(var_17, var_shape_scale);
                        }
                        if (!var_56) {
                            // elif shape_type == GeoType.CONE:                                   <L 752>
                            var_59 = (var_shape_type == var_58);
                            if (var_59) {
                                // signed_distance = sdf_cone(sample_pos, shape_scale[0], shape_scale[1], int(Axis.Z))       <L 753>
                                var_61 = wp::extract(var_shape_scale, var_60);
                                var_63 = wp::extract(var_shape_scale, var_62);
                                var_66 = wp::int(var_65);
                                var_67 = sdf_cone_0(var_17, var_61, var_63, var_66);
                            }
                            var_68 = wp::where(var_59, var_67, var_19);
                        }
                        var_69 = wp::where(var_56, var_57, var_68);
                    }
                    var_70 = wp::where(var_45, var_53, var_69);
                }
                var_71 = wp::where(var_35, var_43, var_70);
            }
            var_72 = wp::where(var_26, var_33, var_71);
        }
        var_73 = wp::where(var_21, var_24, var_72);
        // signed_distance -= shape_margin                                                        <L 754>
        var_74 = wp::sub(var_73, var_shape_margin);
        // wp.volume_store(sdf, x_id, y_id, z_id, signed_distance)                                <L 755>
        wp::volume_store(var_sdf, var_9, var_12, var_15, var_74);
    }
}



extern "C" __global__ void count_isomesh_faces_kernel_d47df750_cuda_kernel_forward(
    wp::launch_bounds_t<4> dim,
    wp::uint64 var_sdf,
    wp::array_t<wp::vec_t<3, wp::int32>> var_tile_points,
    wp::array_t<wp::int32> var_tri_range_table,
    wp::array_t<wp::vec_t<3, wp::uint8>> var_corner_offsets_table,
    wp::float32 var_isovalue,
    wp::array_t<wp::int32> var_face_count)
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
        wp::int32 var_3;
        wp::vec_t<3, wp::int32>* var_4;
        wp::vec_t<3, wp::int32> var_5;
        wp::vec_t<3, wp::int32> var_6;
        const wp::int32 var_7 = 0;
        wp::int32 var_8;
        wp::int32 var_9;
        const wp::int32 var_10 = 1;
        wp::int32 var_11;
        wp::int32 var_12;
        const wp::int32 var_13 = 2;
        wp::int32 var_14;
        wp::int32 var_15;
        const wp::int32 var_16 = 0;
        wp::int32 var_17;
        const wp::int32 var_18 = 0;
        wp::vec_t<3, wp::uint8>* var_19;
        wp::vec_t<3, wp::int32> var_20;
        wp::vec_t<3, wp::uint8> var_21;
        const wp::int32 var_22 = 0;
        wp::int32 var_23;
        wp::int32 var_24;
        const wp::int32 var_25 = 1;
        wp::int32 var_26;
        wp::int32 var_27;
        const wp::int32 var_28 = 2;
        wp::int32 var_29;
        wp::int32 var_30;
        wp::float32 var_31;
        const wp::float32 var_32 = 9900000000.0;
        bool var_33;
        bool var_34;
        const wp::int32 var_35 = 1;
        wp::int32 var_36;
        wp::int32 var_37;
        wp::int32 var_38;
        const wp::int32 var_39 = 1;
        wp::vec_t<3, wp::uint8>* var_40;
        wp::vec_t<3, wp::int32> var_41;
        wp::vec_t<3, wp::uint8> var_42;
        const wp::int32 var_43 = 0;
        wp::int32 var_44;
        wp::int32 var_45;
        const wp::int32 var_46 = 1;
        wp::int32 var_47;
        wp::int32 var_48;
        const wp::int32 var_49 = 2;
        wp::int32 var_50;
        wp::int32 var_51;
        wp::float32 var_52;
        const wp::float32 var_53 = 9900000000.0;
        bool var_54;
        bool var_55;
        const wp::int32 var_56 = 1;
        wp::int32 var_57;
        wp::int32 var_58;
        wp::int32 var_59;
        const wp::int32 var_60 = 2;
        wp::vec_t<3, wp::uint8>* var_61;
        wp::vec_t<3, wp::int32> var_62;
        wp::vec_t<3, wp::uint8> var_63;
        const wp::int32 var_64 = 0;
        wp::int32 var_65;
        wp::int32 var_66;
        const wp::int32 var_67 = 1;
        wp::int32 var_68;
        wp::int32 var_69;
        const wp::int32 var_70 = 2;
        wp::int32 var_71;
        wp::int32 var_72;
        wp::float32 var_73;
        const wp::float32 var_74 = 9900000000.0;
        bool var_75;
        bool var_76;
        const wp::int32 var_77 = 1;
        wp::int32 var_78;
        wp::int32 var_79;
        wp::int32 var_80;
        const wp::int32 var_81 = 3;
        wp::vec_t<3, wp::uint8>* var_82;
        wp::vec_t<3, wp::int32> var_83;
        wp::vec_t<3, wp::uint8> var_84;
        const wp::int32 var_85 = 0;
        wp::int32 var_86;
        wp::int32 var_87;
        const wp::int32 var_88 = 1;
        wp::int32 var_89;
        wp::int32 var_90;
        const wp::int32 var_91 = 2;
        wp::int32 var_92;
        wp::int32 var_93;
        wp::float32 var_94;
        const wp::float32 var_95 = 9900000000.0;
        bool var_96;
        bool var_97;
        const wp::int32 var_98 = 1;
        wp::int32 var_99;
        wp::int32 var_100;
        wp::int32 var_101;
        const wp::int32 var_102 = 4;
        wp::vec_t<3, wp::uint8>* var_103;
        wp::vec_t<3, wp::int32> var_104;
        wp::vec_t<3, wp::uint8> var_105;
        const wp::int32 var_106 = 0;
        wp::int32 var_107;
        wp::int32 var_108;
        const wp::int32 var_109 = 1;
        wp::int32 var_110;
        wp::int32 var_111;
        const wp::int32 var_112 = 2;
        wp::int32 var_113;
        wp::int32 var_114;
        wp::float32 var_115;
        const wp::float32 var_116 = 9900000000.0;
        bool var_117;
        bool var_118;
        const wp::int32 var_119 = 1;
        wp::int32 var_120;
        wp::int32 var_121;
        wp::int32 var_122;
        const wp::int32 var_123 = 5;
        wp::vec_t<3, wp::uint8>* var_124;
        wp::vec_t<3, wp::int32> var_125;
        wp::vec_t<3, wp::uint8> var_126;
        const wp::int32 var_127 = 0;
        wp::int32 var_128;
        wp::int32 var_129;
        const wp::int32 var_130 = 1;
        wp::int32 var_131;
        wp::int32 var_132;
        const wp::int32 var_133 = 2;
        wp::int32 var_134;
        wp::int32 var_135;
        wp::float32 var_136;
        const wp::float32 var_137 = 9900000000.0;
        bool var_138;
        bool var_139;
        const wp::int32 var_140 = 1;
        wp::int32 var_141;
        wp::int32 var_142;
        wp::int32 var_143;
        const wp::int32 var_144 = 6;
        wp::vec_t<3, wp::uint8>* var_145;
        wp::vec_t<3, wp::int32> var_146;
        wp::vec_t<3, wp::uint8> var_147;
        const wp::int32 var_148 = 0;
        wp::int32 var_149;
        wp::int32 var_150;
        const wp::int32 var_151 = 1;
        wp::int32 var_152;
        wp::int32 var_153;
        const wp::int32 var_154 = 2;
        wp::int32 var_155;
        wp::int32 var_156;
        wp::float32 var_157;
        const wp::float32 var_158 = 9900000000.0;
        bool var_159;
        bool var_160;
        const wp::int32 var_161 = 1;
        wp::int32 var_162;
        wp::int32 var_163;
        wp::int32 var_164;
        const wp::int32 var_165 = 7;
        wp::vec_t<3, wp::uint8>* var_166;
        wp::vec_t<3, wp::int32> var_167;
        wp::vec_t<3, wp::uint8> var_168;
        const wp::int32 var_169 = 0;
        wp::int32 var_170;
        wp::int32 var_171;
        const wp::int32 var_172 = 1;
        wp::int32 var_173;
        wp::int32 var_174;
        const wp::int32 var_175 = 2;
        wp::int32 var_176;
        wp::int32 var_177;
        wp::float32 var_178;
        const wp::float32 var_179 = 9900000000.0;
        bool var_180;
        bool var_181;
        const wp::int32 var_182 = 1;
        wp::int32 var_183;
        wp::int32 var_184;
        wp::int32 var_185;
        wp::int32* var_186;
        wp::int32 var_187;
        wp::int32 var_188;
        const wp::int32 var_189 = 1;
        wp::int32 var_190;
        wp::int32* var_191;
        wp::int32 var_192;
        wp::int32 var_193;
        wp::int32 var_194;
        const wp::int32 var_195 = 3;
        wp::int32 var_196;
        const wp::int32 var_197 = 0;
        bool var_198;
        const wp::int32 var_199 = 0;
        wp::int32 var_200;
        //---------
        // forward
        // def count_isomesh_faces_kernel(                                                        <L 1294>
        // tile_idx, local_x, local_y, local_z = wp.tid()                                         <L 1305>
        builtin_tid4d(var_0, var_1, var_2, var_3);
        // tile_origin = tile_points[tile_idx]                                                    <L 1307>
        var_4 = wp::address(var_tile_points, var_0);
        var_6 = wp::load(var_4);
        var_5 = wp::copy(var_6);
        // x_id = tile_origin[0] + local_x                                                        <L 1308>
        var_8 = wp::extract(var_5, var_7);
        var_9 = wp::add(var_8, var_1);
        // y_id = tile_origin[1] + local_y                                                        <L 1309>
        var_11 = wp::extract(var_5, var_10);
        var_12 = wp::add(var_11, var_2);
        // z_id = tile_origin[2] + local_z                                                        <L 1310>
        var_14 = wp::extract(var_5, var_13);
        var_15 = wp::add(var_14, var_3);
        // cube_idx = wp.int32(0)                                                                 <L 1312>
        var_17 = wp::int32(var_16);
        // for i in range(8):                                                                     <L 1313>
        // corner_offset = wp.vec3i(corner_offsets_table[i])                                      <L 1314>
        var_19 = wp::address(var_corner_offsets_table, var_18);
        var_21 = wp::load(var_19);
        var_20 = wp::vec_t<3, wp::int32>(var_21);
        // x = x_id + corner_offset.x                                                             <L 1315>
        var_23 = wp::extract(var_20, var_22);
        var_24 = wp::add(var_9, var_23);
        // y = y_id + corner_offset.y                                                             <L 1316>
        var_26 = wp::extract(var_20, var_25);
        var_27 = wp::add(var_12, var_26);
        // z = z_id + corner_offset.z                                                             <L 1317>
        var_29 = wp::extract(var_20, var_28);
        var_30 = wp::add(var_15, var_29);
        // v = wp.volume_lookup_f(sdf, x, y, z)                                                   <L 1318>
        var_31 = wp::volume_lookup_f(var_sdf, var_24, var_27, var_30);
        // if v >= wp.static(MAXVAL * 0.99):                                                      <L 1319>
        var_33 = (var_31 >= var_32);
        if (var_33) {
            // return                                                                             <L 1320>
            continue;
        }
        // if v < isovalue:                                                                       <L 1321>
        var_34 = (var_31 < var_isovalue);
        if (var_34) {
            // cube_idx |= 1 << i                                                                 <L 1322>
            var_36 = wp::lshift(var_35, var_18);
            var_37 = wp::bit_or(var_17, var_36);
        }
        var_38 = wp::where(var_34, var_37, var_17);
        // corner_offset = wp.vec3i(corner_offsets_table[i])                                      <L 1314>
        var_40 = wp::address(var_corner_offsets_table, var_39);
        var_42 = wp::load(var_40);
        var_41 = wp::vec_t<3, wp::int32>(var_42);
        // x = x_id + corner_offset.x                                                             <L 1315>
        var_44 = wp::extract(var_41, var_43);
        var_45 = wp::add(var_9, var_44);
        // y = y_id + corner_offset.y                                                             <L 1316>
        var_47 = wp::extract(var_41, var_46);
        var_48 = wp::add(var_12, var_47);
        // z = z_id + corner_offset.z                                                             <L 1317>
        var_50 = wp::extract(var_41, var_49);
        var_51 = wp::add(var_15, var_50);
        // v = wp.volume_lookup_f(sdf, x, y, z)                                                   <L 1318>
        var_52 = wp::volume_lookup_f(var_sdf, var_45, var_48, var_51);
        // if v >= wp.static(MAXVAL * 0.99):                                                      <L 1319>
        var_54 = (var_52 >= var_53);
        if (var_54) {
            // return                                                                             <L 1320>
            continue;
        }
        // if v < isovalue:                                                                       <L 1321>
        var_55 = (var_52 < var_isovalue);
        if (var_55) {
            // cube_idx |= 1 << i                                                                 <L 1322>
            var_57 = wp::lshift(var_56, var_39);
            var_58 = wp::bit_or(var_38, var_57);
        }
        var_59 = wp::where(var_55, var_58, var_38);
        // corner_offset = wp.vec3i(corner_offsets_table[i])                                      <L 1314>
        var_61 = wp::address(var_corner_offsets_table, var_60);
        var_63 = wp::load(var_61);
        var_62 = wp::vec_t<3, wp::int32>(var_63);
        // x = x_id + corner_offset.x                                                             <L 1315>
        var_65 = wp::extract(var_62, var_64);
        var_66 = wp::add(var_9, var_65);
        // y = y_id + corner_offset.y                                                             <L 1316>
        var_68 = wp::extract(var_62, var_67);
        var_69 = wp::add(var_12, var_68);
        // z = z_id + corner_offset.z                                                             <L 1317>
        var_71 = wp::extract(var_62, var_70);
        var_72 = wp::add(var_15, var_71);
        // v = wp.volume_lookup_f(sdf, x, y, z)                                                   <L 1318>
        var_73 = wp::volume_lookup_f(var_sdf, var_66, var_69, var_72);
        // if v >= wp.static(MAXVAL * 0.99):                                                      <L 1319>
        var_75 = (var_73 >= var_74);
        if (var_75) {
            // return                                                                             <L 1320>
            continue;
        }
        // if v < isovalue:                                                                       <L 1321>
        var_76 = (var_73 < var_isovalue);
        if (var_76) {
            // cube_idx |= 1 << i                                                                 <L 1322>
            var_78 = wp::lshift(var_77, var_60);
            var_79 = wp::bit_or(var_59, var_78);
        }
        var_80 = wp::where(var_76, var_79, var_59);
        // corner_offset = wp.vec3i(corner_offsets_table[i])                                      <L 1314>
        var_82 = wp::address(var_corner_offsets_table, var_81);
        var_84 = wp::load(var_82);
        var_83 = wp::vec_t<3, wp::int32>(var_84);
        // x = x_id + corner_offset.x                                                             <L 1315>
        var_86 = wp::extract(var_83, var_85);
        var_87 = wp::add(var_9, var_86);
        // y = y_id + corner_offset.y                                                             <L 1316>
        var_89 = wp::extract(var_83, var_88);
        var_90 = wp::add(var_12, var_89);
        // z = z_id + corner_offset.z                                                             <L 1317>
        var_92 = wp::extract(var_83, var_91);
        var_93 = wp::add(var_15, var_92);
        // v = wp.volume_lookup_f(sdf, x, y, z)                                                   <L 1318>
        var_94 = wp::volume_lookup_f(var_sdf, var_87, var_90, var_93);
        // if v >= wp.static(MAXVAL * 0.99):                                                      <L 1319>
        var_96 = (var_94 >= var_95);
        if (var_96) {
            // return                                                                             <L 1320>
            continue;
        }
        // if v < isovalue:                                                                       <L 1321>
        var_97 = (var_94 < var_isovalue);
        if (var_97) {
            // cube_idx |= 1 << i                                                                 <L 1322>
            var_99 = wp::lshift(var_98, var_81);
            var_100 = wp::bit_or(var_80, var_99);
        }
        var_101 = wp::where(var_97, var_100, var_80);
        // corner_offset = wp.vec3i(corner_offsets_table[i])                                      <L 1314>
        var_103 = wp::address(var_corner_offsets_table, var_102);
        var_105 = wp::load(var_103);
        var_104 = wp::vec_t<3, wp::int32>(var_105);
        // x = x_id + corner_offset.x                                                             <L 1315>
        var_107 = wp::extract(var_104, var_106);
        var_108 = wp::add(var_9, var_107);
        // y = y_id + corner_offset.y                                                             <L 1316>
        var_110 = wp::extract(var_104, var_109);
        var_111 = wp::add(var_12, var_110);
        // z = z_id + corner_offset.z                                                             <L 1317>
        var_113 = wp::extract(var_104, var_112);
        var_114 = wp::add(var_15, var_113);
        // v = wp.volume_lookup_f(sdf, x, y, z)                                                   <L 1318>
        var_115 = wp::volume_lookup_f(var_sdf, var_108, var_111, var_114);
        // if v >= wp.static(MAXVAL * 0.99):                                                      <L 1319>
        var_117 = (var_115 >= var_116);
        if (var_117) {
            // return                                                                             <L 1320>
            continue;
        }
        // if v < isovalue:                                                                       <L 1321>
        var_118 = (var_115 < var_isovalue);
        if (var_118) {
            // cube_idx |= 1 << i                                                                 <L 1322>
            var_120 = wp::lshift(var_119, var_102);
            var_121 = wp::bit_or(var_101, var_120);
        }
        var_122 = wp::where(var_118, var_121, var_101);
        // corner_offset = wp.vec3i(corner_offsets_table[i])                                      <L 1314>
        var_124 = wp::address(var_corner_offsets_table, var_123);
        var_126 = wp::load(var_124);
        var_125 = wp::vec_t<3, wp::int32>(var_126);
        // x = x_id + corner_offset.x                                                             <L 1315>
        var_128 = wp::extract(var_125, var_127);
        var_129 = wp::add(var_9, var_128);
        // y = y_id + corner_offset.y                                                             <L 1316>
        var_131 = wp::extract(var_125, var_130);
        var_132 = wp::add(var_12, var_131);
        // z = z_id + corner_offset.z                                                             <L 1317>
        var_134 = wp::extract(var_125, var_133);
        var_135 = wp::add(var_15, var_134);
        // v = wp.volume_lookup_f(sdf, x, y, z)                                                   <L 1318>
        var_136 = wp::volume_lookup_f(var_sdf, var_129, var_132, var_135);
        // if v >= wp.static(MAXVAL * 0.99):                                                      <L 1319>
        var_138 = (var_136 >= var_137);
        if (var_138) {
            // return                                                                             <L 1320>
            continue;
        }
        // if v < isovalue:                                                                       <L 1321>
        var_139 = (var_136 < var_isovalue);
        if (var_139) {
            // cube_idx |= 1 << i                                                                 <L 1322>
            var_141 = wp::lshift(var_140, var_123);
            var_142 = wp::bit_or(var_122, var_141);
        }
        var_143 = wp::where(var_139, var_142, var_122);
        // corner_offset = wp.vec3i(corner_offsets_table[i])                                      <L 1314>
        var_145 = wp::address(var_corner_offsets_table, var_144);
        var_147 = wp::load(var_145);
        var_146 = wp::vec_t<3, wp::int32>(var_147);
        // x = x_id + corner_offset.x                                                             <L 1315>
        var_149 = wp::extract(var_146, var_148);
        var_150 = wp::add(var_9, var_149);
        // y = y_id + corner_offset.y                                                             <L 1316>
        var_152 = wp::extract(var_146, var_151);
        var_153 = wp::add(var_12, var_152);
        // z = z_id + corner_offset.z                                                             <L 1317>
        var_155 = wp::extract(var_146, var_154);
        var_156 = wp::add(var_15, var_155);
        // v = wp.volume_lookup_f(sdf, x, y, z)                                                   <L 1318>
        var_157 = wp::volume_lookup_f(var_sdf, var_150, var_153, var_156);
        // if v >= wp.static(MAXVAL * 0.99):                                                      <L 1319>
        var_159 = (var_157 >= var_158);
        if (var_159) {
            // return                                                                             <L 1320>
            continue;
        }
        // if v < isovalue:                                                                       <L 1321>
        var_160 = (var_157 < var_isovalue);
        if (var_160) {
            // cube_idx |= 1 << i                                                                 <L 1322>
            var_162 = wp::lshift(var_161, var_144);
            var_163 = wp::bit_or(var_143, var_162);
        }
        var_164 = wp::where(var_160, var_163, var_143);
        // corner_offset = wp.vec3i(corner_offsets_table[i])                                      <L 1314>
        var_166 = wp::address(var_corner_offsets_table, var_165);
        var_168 = wp::load(var_166);
        var_167 = wp::vec_t<3, wp::int32>(var_168);
        // x = x_id + corner_offset.x                                                             <L 1315>
        var_170 = wp::extract(var_167, var_169);
        var_171 = wp::add(var_9, var_170);
        // y = y_id + corner_offset.y                                                             <L 1316>
        var_173 = wp::extract(var_167, var_172);
        var_174 = wp::add(var_12, var_173);
        // z = z_id + corner_offset.z                                                             <L 1317>
        var_176 = wp::extract(var_167, var_175);
        var_177 = wp::add(var_15, var_176);
        // v = wp.volume_lookup_f(sdf, x, y, z)                                                   <L 1318>
        var_178 = wp::volume_lookup_f(var_sdf, var_171, var_174, var_177);
        // if v >= wp.static(MAXVAL * 0.99):                                                      <L 1319>
        var_180 = (var_178 >= var_179);
        if (var_180) {
            // return                                                                             <L 1320>
            continue;
        }
        // if v < isovalue:                                                                       <L 1321>
        var_181 = (var_178 < var_isovalue);
        if (var_181) {
            // cube_idx |= 1 << i                                                                 <L 1322>
            var_183 = wp::lshift(var_182, var_165);
            var_184 = wp::bit_or(var_164, var_183);
        }
        var_185 = wp::where(var_181, var_184, var_164);
        // tri_range_start = tri_range_table[cube_idx]                                            <L 1325>
        var_186 = wp::address(var_tri_range_table, var_185);
        var_188 = wp::load(var_186);
        var_187 = wp::copy(var_188);
        // tri_range_end = tri_range_table[cube_idx + 1]                                          <L 1326>
        var_190 = wp::add(var_185, var_189);
        var_191 = wp::address(var_tri_range_table, var_190);
        var_193 = wp::load(var_191);
        var_192 = wp::copy(var_193);
        // num_verts = tri_range_end - tri_range_start                                            <L 1327>
        var_194 = wp::sub(var_192, var_187);
        // num_faces = num_verts // 3                                                             <L 1329>
        var_196 = wp::floordiv(var_194, var_195);
        // if num_faces > 0:                                                                      <L 1330>
        var_198 = (var_196 > var_197);
        if (var_198) {
            // wp.atomic_add(face_count, 0, num_faces)                                            <L 1331>
            var_200 = wp::atomic_add(var_face_count, var_199, var_196);
        }
    }
}



extern "C" __global__ void generate_isomesh_kernel_f14cc984_cuda_kernel_forward(
    wp::launch_bounds_t<4> dim,
    wp::uint64 var_sdf,
    wp::array_t<wp::vec_t<3, wp::int32>> var_tile_points,
    wp::array_t<wp::int32> var_tri_range_table,
    wp::array_t<wp::vec_t<2, wp::uint8>> var_flat_edge_verts_table,
    wp::array_t<wp::vec_t<3, wp::uint8>> var_corner_offsets_table,
    wp::float32 var_isovalue,
    wp::array_t<wp::int32> var_face_count,
    wp::array_t<wp::vec_t<3, wp::float32>> var_vertices,
    wp::array_t<wp::vec_t<3, wp::float32>> var_face_normals)
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
        wp::int32 var_3;
        wp::vec_t<3, wp::int32>* var_4;
        wp::vec_t<3, wp::int32> var_5;
        wp::vec_t<3, wp::int32> var_6;
        const wp::int32 var_7 = 0;
        wp::int32 var_8;
        wp::int32 var_9;
        const wp::int32 var_10 = 1;
        wp::int32 var_11;
        wp::int32 var_12;
        const wp::int32 var_13 = 2;
        wp::int32 var_14;
        wp::int32 var_15;
        const wp::int32 var_16 = 0;
        wp::int32 var_17;
        wp::vec_t<8, wp::float32> var_18;
        const wp::int32 var_19 = 0;
        wp::vec_t<3, wp::uint8>* var_20;
        wp::vec_t<3, wp::int32> var_21;
        wp::vec_t<3, wp::uint8> var_22;
        const wp::int32 var_23 = 0;
        wp::int32 var_24;
        wp::int32 var_25;
        const wp::int32 var_26 = 1;
        wp::int32 var_27;
        wp::int32 var_28;
        const wp::int32 var_29 = 2;
        wp::int32 var_30;
        wp::int32 var_31;
        wp::float32 var_32;
        const wp::float32 var_33 = 9900000000.0;
        bool var_34;
        bool var_35;
        const wp::int32 var_36 = 1;
        wp::int32 var_37;
        wp::int32 var_38;
        wp::int32 var_39;
        const wp::int32 var_40 = 1;
        wp::vec_t<3, wp::uint8>* var_41;
        wp::vec_t<3, wp::int32> var_42;
        wp::vec_t<3, wp::uint8> var_43;
        const wp::int32 var_44 = 0;
        wp::int32 var_45;
        wp::int32 var_46;
        const wp::int32 var_47 = 1;
        wp::int32 var_48;
        wp::int32 var_49;
        const wp::int32 var_50 = 2;
        wp::int32 var_51;
        wp::int32 var_52;
        wp::float32 var_53;
        const wp::float32 var_54 = 9900000000.0;
        bool var_55;
        bool var_56;
        const wp::int32 var_57 = 1;
        wp::int32 var_58;
        wp::int32 var_59;
        wp::int32 var_60;
        const wp::int32 var_61 = 2;
        wp::vec_t<3, wp::uint8>* var_62;
        wp::vec_t<3, wp::int32> var_63;
        wp::vec_t<3, wp::uint8> var_64;
        const wp::int32 var_65 = 0;
        wp::int32 var_66;
        wp::int32 var_67;
        const wp::int32 var_68 = 1;
        wp::int32 var_69;
        wp::int32 var_70;
        const wp::int32 var_71 = 2;
        wp::int32 var_72;
        wp::int32 var_73;
        wp::float32 var_74;
        const wp::float32 var_75 = 9900000000.0;
        bool var_76;
        bool var_77;
        const wp::int32 var_78 = 1;
        wp::int32 var_79;
        wp::int32 var_80;
        wp::int32 var_81;
        const wp::int32 var_82 = 3;
        wp::vec_t<3, wp::uint8>* var_83;
        wp::vec_t<3, wp::int32> var_84;
        wp::vec_t<3, wp::uint8> var_85;
        const wp::int32 var_86 = 0;
        wp::int32 var_87;
        wp::int32 var_88;
        const wp::int32 var_89 = 1;
        wp::int32 var_90;
        wp::int32 var_91;
        const wp::int32 var_92 = 2;
        wp::int32 var_93;
        wp::int32 var_94;
        wp::float32 var_95;
        const wp::float32 var_96 = 9900000000.0;
        bool var_97;
        bool var_98;
        const wp::int32 var_99 = 1;
        wp::int32 var_100;
        wp::int32 var_101;
        wp::int32 var_102;
        const wp::int32 var_103 = 4;
        wp::vec_t<3, wp::uint8>* var_104;
        wp::vec_t<3, wp::int32> var_105;
        wp::vec_t<3, wp::uint8> var_106;
        const wp::int32 var_107 = 0;
        wp::int32 var_108;
        wp::int32 var_109;
        const wp::int32 var_110 = 1;
        wp::int32 var_111;
        wp::int32 var_112;
        const wp::int32 var_113 = 2;
        wp::int32 var_114;
        wp::int32 var_115;
        wp::float32 var_116;
        const wp::float32 var_117 = 9900000000.0;
        bool var_118;
        bool var_119;
        const wp::int32 var_120 = 1;
        wp::int32 var_121;
        wp::int32 var_122;
        wp::int32 var_123;
        const wp::int32 var_124 = 5;
        wp::vec_t<3, wp::uint8>* var_125;
        wp::vec_t<3, wp::int32> var_126;
        wp::vec_t<3, wp::uint8> var_127;
        const wp::int32 var_128 = 0;
        wp::int32 var_129;
        wp::int32 var_130;
        const wp::int32 var_131 = 1;
        wp::int32 var_132;
        wp::int32 var_133;
        const wp::int32 var_134 = 2;
        wp::int32 var_135;
        wp::int32 var_136;
        wp::float32 var_137;
        const wp::float32 var_138 = 9900000000.0;
        bool var_139;
        bool var_140;
        const wp::int32 var_141 = 1;
        wp::int32 var_142;
        wp::int32 var_143;
        wp::int32 var_144;
        const wp::int32 var_145 = 6;
        wp::vec_t<3, wp::uint8>* var_146;
        wp::vec_t<3, wp::int32> var_147;
        wp::vec_t<3, wp::uint8> var_148;
        const wp::int32 var_149 = 0;
        wp::int32 var_150;
        wp::int32 var_151;
        const wp::int32 var_152 = 1;
        wp::int32 var_153;
        wp::int32 var_154;
        const wp::int32 var_155 = 2;
        wp::int32 var_156;
        wp::int32 var_157;
        wp::float32 var_158;
        const wp::float32 var_159 = 9900000000.0;
        bool var_160;
        bool var_161;
        const wp::int32 var_162 = 1;
        wp::int32 var_163;
        wp::int32 var_164;
        wp::int32 var_165;
        const wp::int32 var_166 = 7;
        wp::vec_t<3, wp::uint8>* var_167;
        wp::vec_t<3, wp::int32> var_168;
        wp::vec_t<3, wp::uint8> var_169;
        const wp::int32 var_170 = 0;
        wp::int32 var_171;
        wp::int32 var_172;
        const wp::int32 var_173 = 1;
        wp::int32 var_174;
        wp::int32 var_175;
        const wp::int32 var_176 = 2;
        wp::int32 var_177;
        wp::int32 var_178;
        wp::float32 var_179;
        const wp::float32 var_180 = 9900000000.0;
        bool var_181;
        bool var_182;
        const wp::int32 var_183 = 1;
        wp::int32 var_184;
        wp::int32 var_185;
        wp::int32 var_186;
        wp::int32* var_187;
        wp::int32 var_188;
        wp::int32 var_189;
        const wp::int32 var_190 = 1;
        wp::int32 var_191;
        wp::int32* var_192;
        wp::int32 var_193;
        wp::int32 var_194;
        wp::int32 var_195;
        const wp::int32 var_196 = 3;
        wp::int32 var_197;
        const wp::int32 var_198 = 0;
        wp::int32 var_199;
        const wp::int32 var_200 = 0;
        bool var_201;
        const wp::int32 var_202 = 0;
        bool var_203;
        const wp::int32 var_204 = 3;
        wp::int32 var_205;
        wp::int32 var_206;
        wp::float32 var_207;
        wp::vec_t<3, wp::float32> var_208;
        wp::vec_t<3, wp::float32> var_209;
        wp::float32 var_210;
        wp::mat_t<3, 3, wp::float32> var_211;
        const wp::int32 var_212 = 0;
        wp::vec_t<3, wp::float32> var_213;
        wp::vec_t<3, wp::float32> var_214;
        const wp::int32 var_215 = 3;
        wp::int32 var_216;
        const wp::int32 var_217 = 3;
        wp::int32 var_218;
        wp::int32 var_219;
        const wp::int32 var_220 = 0;
        wp::int32 var_221;
        const wp::int32 var_222 = 1;
        wp::vec_t<3, wp::float32> var_223;
        wp::vec_t<3, wp::float32> var_224;
        const wp::int32 var_225 = 3;
        wp::int32 var_226;
        const wp::int32 var_227 = 3;
        wp::int32 var_228;
        wp::int32 var_229;
        const wp::int32 var_230 = 1;
        wp::int32 var_231;
        const wp::int32 var_232 = 2;
        wp::vec_t<3, wp::float32> var_233;
        wp::vec_t<3, wp::float32> var_234;
        const wp::int32 var_235 = 3;
        wp::int32 var_236;
        const wp::int32 var_237 = 3;
        wp::int32 var_238;
        wp::int32 var_239;
        const wp::int32 var_240 = 2;
        wp::int32 var_241;
        wp::int32 var_242;
        const wp::int32 var_243 = 1;
        bool var_244;
        const wp::int32 var_245 = 3;
        wp::int32 var_246;
        wp::int32 var_247;
        wp::float32 var_248;
        wp::vec_t<3, wp::float32> var_249;
        wp::vec_t<3, wp::float32> var_250;
        wp::float32 var_251;
        wp::mat_t<3, 3, wp::float32> var_252;
        const wp::int32 var_253 = 0;
        wp::vec_t<3, wp::float32> var_254;
        wp::vec_t<3, wp::float32> var_255;
        const wp::int32 var_256 = 3;
        wp::int32 var_257;
        const wp::int32 var_258 = 3;
        wp::int32 var_259;
        wp::int32 var_260;
        const wp::int32 var_261 = 0;
        wp::int32 var_262;
        const wp::int32 var_263 = 1;
        wp::vec_t<3, wp::float32> var_264;
        wp::vec_t<3, wp::float32> var_265;
        const wp::int32 var_266 = 3;
        wp::int32 var_267;
        const wp::int32 var_268 = 3;
        wp::int32 var_269;
        wp::int32 var_270;
        const wp::int32 var_271 = 1;
        wp::int32 var_272;
        const wp::int32 var_273 = 2;
        wp::vec_t<3, wp::float32> var_274;
        wp::vec_t<3, wp::float32> var_275;
        const wp::int32 var_276 = 3;
        wp::int32 var_277;
        const wp::int32 var_278 = 3;
        wp::int32 var_279;
        wp::int32 var_280;
        const wp::int32 var_281 = 2;
        wp::int32 var_282;
        wp::int32 var_283;
        const wp::int32 var_284 = 2;
        bool var_285;
        const wp::int32 var_286 = 3;
        wp::int32 var_287;
        wp::int32 var_288;
        wp::float32 var_289;
        wp::vec_t<3, wp::float32> var_290;
        wp::vec_t<3, wp::float32> var_291;
        wp::float32 var_292;
        wp::mat_t<3, 3, wp::float32> var_293;
        const wp::int32 var_294 = 0;
        wp::vec_t<3, wp::float32> var_295;
        wp::vec_t<3, wp::float32> var_296;
        const wp::int32 var_297 = 3;
        wp::int32 var_298;
        const wp::int32 var_299 = 3;
        wp::int32 var_300;
        wp::int32 var_301;
        const wp::int32 var_302 = 0;
        wp::int32 var_303;
        const wp::int32 var_304 = 1;
        wp::vec_t<3, wp::float32> var_305;
        wp::vec_t<3, wp::float32> var_306;
        const wp::int32 var_307 = 3;
        wp::int32 var_308;
        const wp::int32 var_309 = 3;
        wp::int32 var_310;
        wp::int32 var_311;
        const wp::int32 var_312 = 1;
        wp::int32 var_313;
        const wp::int32 var_314 = 2;
        wp::vec_t<3, wp::float32> var_315;
        wp::vec_t<3, wp::float32> var_316;
        const wp::int32 var_317 = 3;
        wp::int32 var_318;
        const wp::int32 var_319 = 3;
        wp::int32 var_320;
        wp::int32 var_321;
        const wp::int32 var_322 = 2;
        wp::int32 var_323;
        wp::int32 var_324;
        const wp::int32 var_325 = 3;
        bool var_326;
        const wp::int32 var_327 = 3;
        wp::int32 var_328;
        wp::int32 var_329;
        wp::float32 var_330;
        wp::vec_t<3, wp::float32> var_331;
        wp::vec_t<3, wp::float32> var_332;
        wp::float32 var_333;
        wp::mat_t<3, 3, wp::float32> var_334;
        const wp::int32 var_335 = 0;
        wp::vec_t<3, wp::float32> var_336;
        wp::vec_t<3, wp::float32> var_337;
        const wp::int32 var_338 = 3;
        wp::int32 var_339;
        const wp::int32 var_340 = 3;
        wp::int32 var_341;
        wp::int32 var_342;
        const wp::int32 var_343 = 0;
        wp::int32 var_344;
        const wp::int32 var_345 = 1;
        wp::vec_t<3, wp::float32> var_346;
        wp::vec_t<3, wp::float32> var_347;
        const wp::int32 var_348 = 3;
        wp::int32 var_349;
        const wp::int32 var_350 = 3;
        wp::int32 var_351;
        wp::int32 var_352;
        const wp::int32 var_353 = 1;
        wp::int32 var_354;
        const wp::int32 var_355 = 2;
        wp::vec_t<3, wp::float32> var_356;
        wp::vec_t<3, wp::float32> var_357;
        const wp::int32 var_358 = 3;
        wp::int32 var_359;
        const wp::int32 var_360 = 3;
        wp::int32 var_361;
        wp::int32 var_362;
        const wp::int32 var_363 = 2;
        wp::int32 var_364;
        wp::int32 var_365;
        const wp::int32 var_366 = 4;
        bool var_367;
        const wp::int32 var_368 = 3;
        wp::int32 var_369;
        wp::int32 var_370;
        wp::float32 var_371;
        wp::vec_t<3, wp::float32> var_372;
        wp::vec_t<3, wp::float32> var_373;
        wp::float32 var_374;
        wp::mat_t<3, 3, wp::float32> var_375;
        const wp::int32 var_376 = 0;
        wp::vec_t<3, wp::float32> var_377;
        wp::vec_t<3, wp::float32> var_378;
        const wp::int32 var_379 = 3;
        wp::int32 var_380;
        const wp::int32 var_381 = 3;
        wp::int32 var_382;
        wp::int32 var_383;
        const wp::int32 var_384 = 0;
        wp::int32 var_385;
        const wp::int32 var_386 = 1;
        wp::vec_t<3, wp::float32> var_387;
        wp::vec_t<3, wp::float32> var_388;
        const wp::int32 var_389 = 3;
        wp::int32 var_390;
        const wp::int32 var_391 = 3;
        wp::int32 var_392;
        wp::int32 var_393;
        const wp::int32 var_394 = 1;
        wp::int32 var_395;
        const wp::int32 var_396 = 2;
        wp::vec_t<3, wp::float32> var_397;
        wp::vec_t<3, wp::float32> var_398;
        const wp::int32 var_399 = 3;
        wp::int32 var_400;
        const wp::int32 var_401 = 3;
        wp::int32 var_402;
        wp::int32 var_403;
        const wp::int32 var_404 = 2;
        wp::int32 var_405;
        wp::int32 var_406;
        //---------
        // forward
        // def generate_isomesh_kernel(                                                           <L 1335>
        // tile_idx, local_x, local_y, local_z = wp.tid()                                         <L 1349>
        builtin_tid4d(var_0, var_1, var_2, var_3);
        // tile_origin = tile_points[tile_idx]                                                    <L 1351>
        var_4 = wp::address(var_tile_points, var_0);
        var_6 = wp::load(var_4);
        var_5 = wp::copy(var_6);
        // x_id = tile_origin[0] + local_x                                                        <L 1352>
        var_8 = wp::extract(var_5, var_7);
        var_9 = wp::add(var_8, var_1);
        // y_id = tile_origin[1] + local_y                                                        <L 1353>
        var_11 = wp::extract(var_5, var_10);
        var_12 = wp::add(var_11, var_2);
        // z_id = tile_origin[2] + local_z                                                        <L 1354>
        var_14 = wp::extract(var_5, var_13);
        var_15 = wp::add(var_14, var_3);
        // cube_idx = wp.int32(0)                                                                 <L 1356>
        var_17 = wp::int32(var_16);
        // corner_vals = vec8f()                                                                  <L 1357>
        var_18 = wp::vec_t<8, wp::float32>();
        // for i in range(8):                                                                     <L 1358>
        // corner_offset = wp.vec3i(corner_offsets_table[i])                                      <L 1359>
        var_20 = wp::address(var_corner_offsets_table, var_19);
        var_22 = wp::load(var_20);
        var_21 = wp::vec_t<3, wp::int32>(var_22);
        // x = x_id + corner_offset.x                                                             <L 1360>
        var_24 = wp::extract(var_21, var_23);
        var_25 = wp::add(var_9, var_24);
        // y = y_id + corner_offset.y                                                             <L 1361>
        var_27 = wp::extract(var_21, var_26);
        var_28 = wp::add(var_12, var_27);
        // z = z_id + corner_offset.z                                                             <L 1362>
        var_30 = wp::extract(var_21, var_29);
        var_31 = wp::add(var_15, var_30);
        // v = wp.volume_lookup_f(sdf, x, y, z)                                                   <L 1363>
        var_32 = wp::volume_lookup_f(var_sdf, var_25, var_28, var_31);
        // if v >= wp.static(MAXVAL * 0.99):                                                      <L 1364>
        var_34 = (var_32 >= var_33);
        if (var_34) {
            // return                                                                             <L 1365>
            continue;
        }
        // corner_vals[i] = v                                                                     <L 1366>
        wp::assign_inplace(var_18, var_19, var_32);
        // if v < isovalue:                                                                       <L 1368>
        var_35 = (var_32 < var_isovalue);
        if (var_35) {
            // cube_idx |= 1 << i                                                                 <L 1369>
            var_37 = wp::lshift(var_36, var_19);
            var_38 = wp::bit_or(var_17, var_37);
        }
        var_39 = wp::where(var_35, var_38, var_17);
        // corner_offset = wp.vec3i(corner_offsets_table[i])                                      <L 1359>
        var_41 = wp::address(var_corner_offsets_table, var_40);
        var_43 = wp::load(var_41);
        var_42 = wp::vec_t<3, wp::int32>(var_43);
        // x = x_id + corner_offset.x                                                             <L 1360>
        var_45 = wp::extract(var_42, var_44);
        var_46 = wp::add(var_9, var_45);
        // y = y_id + corner_offset.y                                                             <L 1361>
        var_48 = wp::extract(var_42, var_47);
        var_49 = wp::add(var_12, var_48);
        // z = z_id + corner_offset.z                                                             <L 1362>
        var_51 = wp::extract(var_42, var_50);
        var_52 = wp::add(var_15, var_51);
        // v = wp.volume_lookup_f(sdf, x, y, z)                                                   <L 1363>
        var_53 = wp::volume_lookup_f(var_sdf, var_46, var_49, var_52);
        // if v >= wp.static(MAXVAL * 0.99):                                                      <L 1364>
        var_55 = (var_53 >= var_54);
        if (var_55) {
            // return                                                                             <L 1365>
            continue;
        }
        // corner_vals[i] = v                                                                     <L 1366>
        wp::assign_inplace(var_18, var_40, var_53);
        // if v < isovalue:                                                                       <L 1368>
        var_56 = (var_53 < var_isovalue);
        if (var_56) {
            // cube_idx |= 1 << i                                                                 <L 1369>
            var_58 = wp::lshift(var_57, var_40);
            var_59 = wp::bit_or(var_39, var_58);
        }
        var_60 = wp::where(var_56, var_59, var_39);
        // corner_offset = wp.vec3i(corner_offsets_table[i])                                      <L 1359>
        var_62 = wp::address(var_corner_offsets_table, var_61);
        var_64 = wp::load(var_62);
        var_63 = wp::vec_t<3, wp::int32>(var_64);
        // x = x_id + corner_offset.x                                                             <L 1360>
        var_66 = wp::extract(var_63, var_65);
        var_67 = wp::add(var_9, var_66);
        // y = y_id + corner_offset.y                                                             <L 1361>
        var_69 = wp::extract(var_63, var_68);
        var_70 = wp::add(var_12, var_69);
        // z = z_id + corner_offset.z                                                             <L 1362>
        var_72 = wp::extract(var_63, var_71);
        var_73 = wp::add(var_15, var_72);
        // v = wp.volume_lookup_f(sdf, x, y, z)                                                   <L 1363>
        var_74 = wp::volume_lookup_f(var_sdf, var_67, var_70, var_73);
        // if v >= wp.static(MAXVAL * 0.99):                                                      <L 1364>
        var_76 = (var_74 >= var_75);
        if (var_76) {
            // return                                                                             <L 1365>
            continue;
        }
        // corner_vals[i] = v                                                                     <L 1366>
        wp::assign_inplace(var_18, var_61, var_74);
        // if v < isovalue:                                                                       <L 1368>
        var_77 = (var_74 < var_isovalue);
        if (var_77) {
            // cube_idx |= 1 << i                                                                 <L 1369>
            var_79 = wp::lshift(var_78, var_61);
            var_80 = wp::bit_or(var_60, var_79);
        }
        var_81 = wp::where(var_77, var_80, var_60);
        // corner_offset = wp.vec3i(corner_offsets_table[i])                                      <L 1359>
        var_83 = wp::address(var_corner_offsets_table, var_82);
        var_85 = wp::load(var_83);
        var_84 = wp::vec_t<3, wp::int32>(var_85);
        // x = x_id + corner_offset.x                                                             <L 1360>
        var_87 = wp::extract(var_84, var_86);
        var_88 = wp::add(var_9, var_87);
        // y = y_id + corner_offset.y                                                             <L 1361>
        var_90 = wp::extract(var_84, var_89);
        var_91 = wp::add(var_12, var_90);
        // z = z_id + corner_offset.z                                                             <L 1362>
        var_93 = wp::extract(var_84, var_92);
        var_94 = wp::add(var_15, var_93);
        // v = wp.volume_lookup_f(sdf, x, y, z)                                                   <L 1363>
        var_95 = wp::volume_lookup_f(var_sdf, var_88, var_91, var_94);
        // if v >= wp.static(MAXVAL * 0.99):                                                      <L 1364>
        var_97 = (var_95 >= var_96);
        if (var_97) {
            // return                                                                             <L 1365>
            continue;
        }
        // corner_vals[i] = v                                                                     <L 1366>
        wp::assign_inplace(var_18, var_82, var_95);
        // if v < isovalue:                                                                       <L 1368>
        var_98 = (var_95 < var_isovalue);
        if (var_98) {
            // cube_idx |= 1 << i                                                                 <L 1369>
            var_100 = wp::lshift(var_99, var_82);
            var_101 = wp::bit_or(var_81, var_100);
        }
        var_102 = wp::where(var_98, var_101, var_81);
        // corner_offset = wp.vec3i(corner_offsets_table[i])                                      <L 1359>
        var_104 = wp::address(var_corner_offsets_table, var_103);
        var_106 = wp::load(var_104);
        var_105 = wp::vec_t<3, wp::int32>(var_106);
        // x = x_id + corner_offset.x                                                             <L 1360>
        var_108 = wp::extract(var_105, var_107);
        var_109 = wp::add(var_9, var_108);
        // y = y_id + corner_offset.y                                                             <L 1361>
        var_111 = wp::extract(var_105, var_110);
        var_112 = wp::add(var_12, var_111);
        // z = z_id + corner_offset.z                                                             <L 1362>
        var_114 = wp::extract(var_105, var_113);
        var_115 = wp::add(var_15, var_114);
        // v = wp.volume_lookup_f(sdf, x, y, z)                                                   <L 1363>
        var_116 = wp::volume_lookup_f(var_sdf, var_109, var_112, var_115);
        // if v >= wp.static(MAXVAL * 0.99):                                                      <L 1364>
        var_118 = (var_116 >= var_117);
        if (var_118) {
            // return                                                                             <L 1365>
            continue;
        }
        // corner_vals[i] = v                                                                     <L 1366>
        wp::assign_inplace(var_18, var_103, var_116);
        // if v < isovalue:                                                                       <L 1368>
        var_119 = (var_116 < var_isovalue);
        if (var_119) {
            // cube_idx |= 1 << i                                                                 <L 1369>
            var_121 = wp::lshift(var_120, var_103);
            var_122 = wp::bit_or(var_102, var_121);
        }
        var_123 = wp::where(var_119, var_122, var_102);
        // corner_offset = wp.vec3i(corner_offsets_table[i])                                      <L 1359>
        var_125 = wp::address(var_corner_offsets_table, var_124);
        var_127 = wp::load(var_125);
        var_126 = wp::vec_t<3, wp::int32>(var_127);
        // x = x_id + corner_offset.x                                                             <L 1360>
        var_129 = wp::extract(var_126, var_128);
        var_130 = wp::add(var_9, var_129);
        // y = y_id + corner_offset.y                                                             <L 1361>
        var_132 = wp::extract(var_126, var_131);
        var_133 = wp::add(var_12, var_132);
        // z = z_id + corner_offset.z                                                             <L 1362>
        var_135 = wp::extract(var_126, var_134);
        var_136 = wp::add(var_15, var_135);
        // v = wp.volume_lookup_f(sdf, x, y, z)                                                   <L 1363>
        var_137 = wp::volume_lookup_f(var_sdf, var_130, var_133, var_136);
        // if v >= wp.static(MAXVAL * 0.99):                                                      <L 1364>
        var_139 = (var_137 >= var_138);
        if (var_139) {
            // return                                                                             <L 1365>
            continue;
        }
        // corner_vals[i] = v                                                                     <L 1366>
        wp::assign_inplace(var_18, var_124, var_137);
        // if v < isovalue:                                                                       <L 1368>
        var_140 = (var_137 < var_isovalue);
        if (var_140) {
            // cube_idx |= 1 << i                                                                 <L 1369>
            var_142 = wp::lshift(var_141, var_124);
            var_143 = wp::bit_or(var_123, var_142);
        }
        var_144 = wp::where(var_140, var_143, var_123);
        // corner_offset = wp.vec3i(corner_offsets_table[i])                                      <L 1359>
        var_146 = wp::address(var_corner_offsets_table, var_145);
        var_148 = wp::load(var_146);
        var_147 = wp::vec_t<3, wp::int32>(var_148);
        // x = x_id + corner_offset.x                                                             <L 1360>
        var_150 = wp::extract(var_147, var_149);
        var_151 = wp::add(var_9, var_150);
        // y = y_id + corner_offset.y                                                             <L 1361>
        var_153 = wp::extract(var_147, var_152);
        var_154 = wp::add(var_12, var_153);
        // z = z_id + corner_offset.z                                                             <L 1362>
        var_156 = wp::extract(var_147, var_155);
        var_157 = wp::add(var_15, var_156);
        // v = wp.volume_lookup_f(sdf, x, y, z)                                                   <L 1363>
        var_158 = wp::volume_lookup_f(var_sdf, var_151, var_154, var_157);
        // if v >= wp.static(MAXVAL * 0.99):                                                      <L 1364>
        var_160 = (var_158 >= var_159);
        if (var_160) {
            // return                                                                             <L 1365>
            continue;
        }
        // corner_vals[i] = v                                                                     <L 1366>
        wp::assign_inplace(var_18, var_145, var_158);
        // if v < isovalue:                                                                       <L 1368>
        var_161 = (var_158 < var_isovalue);
        if (var_161) {
            // cube_idx |= 1 << i                                                                 <L 1369>
            var_163 = wp::lshift(var_162, var_145);
            var_164 = wp::bit_or(var_144, var_163);
        }
        var_165 = wp::where(var_161, var_164, var_144);
        // corner_offset = wp.vec3i(corner_offsets_table[i])                                      <L 1359>
        var_167 = wp::address(var_corner_offsets_table, var_166);
        var_169 = wp::load(var_167);
        var_168 = wp::vec_t<3, wp::int32>(var_169);
        // x = x_id + corner_offset.x                                                             <L 1360>
        var_171 = wp::extract(var_168, var_170);
        var_172 = wp::add(var_9, var_171);
        // y = y_id + corner_offset.y                                                             <L 1361>
        var_174 = wp::extract(var_168, var_173);
        var_175 = wp::add(var_12, var_174);
        // z = z_id + corner_offset.z                                                             <L 1362>
        var_177 = wp::extract(var_168, var_176);
        var_178 = wp::add(var_15, var_177);
        // v = wp.volume_lookup_f(sdf, x, y, z)                                                   <L 1363>
        var_179 = wp::volume_lookup_f(var_sdf, var_172, var_175, var_178);
        // if v >= wp.static(MAXVAL * 0.99):                                                      <L 1364>
        var_181 = (var_179 >= var_180);
        if (var_181) {
            // return                                                                             <L 1365>
            continue;
        }
        // corner_vals[i] = v                                                                     <L 1366>
        wp::assign_inplace(var_18, var_166, var_179);
        // if v < isovalue:                                                                       <L 1368>
        var_182 = (var_179 < var_isovalue);
        if (var_182) {
            // cube_idx |= 1 << i                                                                 <L 1369>
            var_184 = wp::lshift(var_183, var_166);
            var_185 = wp::bit_or(var_165, var_184);
        }
        var_186 = wp::where(var_182, var_185, var_165);
        // tri_range_start = tri_range_table[cube_idx]                                            <L 1371>
        var_187 = wp::address(var_tri_range_table, var_186);
        var_189 = wp::load(var_187);
        var_188 = wp::copy(var_189);
        // tri_range_end = tri_range_table[cube_idx + 1]                                          <L 1372>
        var_191 = wp::add(var_186, var_190);
        var_192 = wp::address(var_tri_range_table, var_191);
        var_194 = wp::load(var_192);
        var_193 = wp::copy(var_194);
        // num_verts = tri_range_end - tri_range_start                                            <L 1373>
        var_195 = wp::sub(var_193, var_188);
        // num_faces = num_verts // 3                                                             <L 1375>
        var_197 = wp::floordiv(var_195, var_196);
        // out_idx_faces = wp.atomic_add(face_count, 0, num_faces)                                <L 1376>
        var_199 = wp::atomic_add(var_face_count, var_198, var_197);
        // if num_verts == 0:                                                                     <L 1378>
        var_201 = (var_195 == var_200);
        if (var_201) {
            // return                                                                             <L 1379>
            continue;
        }
        // for fi in range(5):                                                                    <L 1381>
        // if fi >= num_faces:                                                                    <L 1382>
        var_203 = (var_202 >= var_197);
        if (var_203) {
            // return                                                                             <L 1383>
            continue;
        }
        // _area, normal, _face_center, _pen_depth, face_verts = mc_calc_face(                    <L 1384>
        // flat_edge_verts_table,                                                                 <L 1385>
        // corner_offsets_table,                                                                  <L 1386>
        // tri_range_start + 3 * fi,                                                              <L 1387>
        var_205 = wp::mul(var_204, var_202);
        var_206 = wp::add(var_188, var_205);
        // corner_vals,                                                                           <L 1388>
        // sdf,                                                                                   <L 1389>
        // x_id,                                                                                  <L 1390>
        // y_id,                                                                                  <L 1391>
        // z_id,                                                                                  <L 1392>
        // isovalue,                                                                              <L 1393>
        mc_calc_face_0(var_flat_edge_verts_table, var_corner_offsets_table, var_206, var_18, var_sdf, var_9, var_12, var_15, var_isovalue, var_207, var_208, var_209, var_210, var_211);
        // vertices[3 * out_idx_faces + 3 * fi + 0] = wp.vec3(face_verts[0])                      <L 1395>
        var_213 = wp::extract(var_211, var_212);
        var_214 = wp::vec_t<3, wp::float32>(var_213);
        var_216 = wp::mul(var_215, var_199);
        var_218 = wp::mul(var_217, var_202);
        var_219 = wp::add(var_216, var_218);
        var_221 = wp::add(var_219, var_220);
        wp::array_store(var_vertices, var_221, var_214);
        // vertices[3 * out_idx_faces + 3 * fi + 1] = wp.vec3(face_verts[1])                      <L 1396>
        var_223 = wp::extract(var_211, var_222);
        var_224 = wp::vec_t<3, wp::float32>(var_223);
        var_226 = wp::mul(var_225, var_199);
        var_228 = wp::mul(var_227, var_202);
        var_229 = wp::add(var_226, var_228);
        var_231 = wp::add(var_229, var_230);
        wp::array_store(var_vertices, var_231, var_224);
        // vertices[3 * out_idx_faces + 3 * fi + 2] = wp.vec3(face_verts[2])                      <L 1397>
        var_233 = wp::extract(var_211, var_232);
        var_234 = wp::vec_t<3, wp::float32>(var_233);
        var_236 = wp::mul(var_235, var_199);
        var_238 = wp::mul(var_237, var_202);
        var_239 = wp::add(var_236, var_238);
        var_241 = wp::add(var_239, var_240);
        wp::array_store(var_vertices, var_241, var_234);
        // face_normals[out_idx_faces + fi] = normal                                              <L 1398>
        var_242 = wp::add(var_199, var_202);
        wp::array_store(var_face_normals, var_242, var_208);
        // if fi >= num_faces:                                                                    <L 1382>
        var_244 = (var_243 >= var_197);
        if (var_244) {
            // return                                                                             <L 1383>
            continue;
        }
        // _area, normal, _face_center, _pen_depth, face_verts = mc_calc_face(                    <L 1384>
        // flat_edge_verts_table,                                                                 <L 1385>
        // corner_offsets_table,                                                                  <L 1386>
        // tri_range_start + 3 * fi,                                                              <L 1387>
        var_246 = wp::mul(var_245, var_243);
        var_247 = wp::add(var_188, var_246);
        // corner_vals,                                                                           <L 1388>
        // sdf,                                                                                   <L 1389>
        // x_id,                                                                                  <L 1390>
        // y_id,                                                                                  <L 1391>
        // z_id,                                                                                  <L 1392>
        // isovalue,                                                                              <L 1393>
        mc_calc_face_0(var_flat_edge_verts_table, var_corner_offsets_table, var_247, var_18, var_sdf, var_9, var_12, var_15, var_isovalue, var_248, var_249, var_250, var_251, var_252);
        // vertices[3 * out_idx_faces + 3 * fi + 0] = wp.vec3(face_verts[0])                      <L 1395>
        var_254 = wp::extract(var_252, var_253);
        var_255 = wp::vec_t<3, wp::float32>(var_254);
        var_257 = wp::mul(var_256, var_199);
        var_259 = wp::mul(var_258, var_243);
        var_260 = wp::add(var_257, var_259);
        var_262 = wp::add(var_260, var_261);
        wp::array_store(var_vertices, var_262, var_255);
        // vertices[3 * out_idx_faces + 3 * fi + 1] = wp.vec3(face_verts[1])                      <L 1396>
        var_264 = wp::extract(var_252, var_263);
        var_265 = wp::vec_t<3, wp::float32>(var_264);
        var_267 = wp::mul(var_266, var_199);
        var_269 = wp::mul(var_268, var_243);
        var_270 = wp::add(var_267, var_269);
        var_272 = wp::add(var_270, var_271);
        wp::array_store(var_vertices, var_272, var_265);
        // vertices[3 * out_idx_faces + 3 * fi + 2] = wp.vec3(face_verts[2])                      <L 1397>
        var_274 = wp::extract(var_252, var_273);
        var_275 = wp::vec_t<3, wp::float32>(var_274);
        var_277 = wp::mul(var_276, var_199);
        var_279 = wp::mul(var_278, var_243);
        var_280 = wp::add(var_277, var_279);
        var_282 = wp::add(var_280, var_281);
        wp::array_store(var_vertices, var_282, var_275);
        // face_normals[out_idx_faces + fi] = normal                                              <L 1398>
        var_283 = wp::add(var_199, var_243);
        wp::array_store(var_face_normals, var_283, var_249);
        // if fi >= num_faces:                                                                    <L 1382>
        var_285 = (var_284 >= var_197);
        if (var_285) {
            // return                                                                             <L 1383>
            continue;
        }
        // _area, normal, _face_center, _pen_depth, face_verts = mc_calc_face(                    <L 1384>
        // flat_edge_verts_table,                                                                 <L 1385>
        // corner_offsets_table,                                                                  <L 1386>
        // tri_range_start + 3 * fi,                                                              <L 1387>
        var_287 = wp::mul(var_286, var_284);
        var_288 = wp::add(var_188, var_287);
        // corner_vals,                                                                           <L 1388>
        // sdf,                                                                                   <L 1389>
        // x_id,                                                                                  <L 1390>
        // y_id,                                                                                  <L 1391>
        // z_id,                                                                                  <L 1392>
        // isovalue,                                                                              <L 1393>
        mc_calc_face_0(var_flat_edge_verts_table, var_corner_offsets_table, var_288, var_18, var_sdf, var_9, var_12, var_15, var_isovalue, var_289, var_290, var_291, var_292, var_293);
        // vertices[3 * out_idx_faces + 3 * fi + 0] = wp.vec3(face_verts[0])                      <L 1395>
        var_295 = wp::extract(var_293, var_294);
        var_296 = wp::vec_t<3, wp::float32>(var_295);
        var_298 = wp::mul(var_297, var_199);
        var_300 = wp::mul(var_299, var_284);
        var_301 = wp::add(var_298, var_300);
        var_303 = wp::add(var_301, var_302);
        wp::array_store(var_vertices, var_303, var_296);
        // vertices[3 * out_idx_faces + 3 * fi + 1] = wp.vec3(face_verts[1])                      <L 1396>
        var_305 = wp::extract(var_293, var_304);
        var_306 = wp::vec_t<3, wp::float32>(var_305);
        var_308 = wp::mul(var_307, var_199);
        var_310 = wp::mul(var_309, var_284);
        var_311 = wp::add(var_308, var_310);
        var_313 = wp::add(var_311, var_312);
        wp::array_store(var_vertices, var_313, var_306);
        // vertices[3 * out_idx_faces + 3 * fi + 2] = wp.vec3(face_verts[2])                      <L 1397>
        var_315 = wp::extract(var_293, var_314);
        var_316 = wp::vec_t<3, wp::float32>(var_315);
        var_318 = wp::mul(var_317, var_199);
        var_320 = wp::mul(var_319, var_284);
        var_321 = wp::add(var_318, var_320);
        var_323 = wp::add(var_321, var_322);
        wp::array_store(var_vertices, var_323, var_316);
        // face_normals[out_idx_faces + fi] = normal                                              <L 1398>
        var_324 = wp::add(var_199, var_284);
        wp::array_store(var_face_normals, var_324, var_290);
        // if fi >= num_faces:                                                                    <L 1382>
        var_326 = (var_325 >= var_197);
        if (var_326) {
            // return                                                                             <L 1383>
            continue;
        }
        // _area, normal, _face_center, _pen_depth, face_verts = mc_calc_face(                    <L 1384>
        // flat_edge_verts_table,                                                                 <L 1385>
        // corner_offsets_table,                                                                  <L 1386>
        // tri_range_start + 3 * fi,                                                              <L 1387>
        var_328 = wp::mul(var_327, var_325);
        var_329 = wp::add(var_188, var_328);
        // corner_vals,                                                                           <L 1388>
        // sdf,                                                                                   <L 1389>
        // x_id,                                                                                  <L 1390>
        // y_id,                                                                                  <L 1391>
        // z_id,                                                                                  <L 1392>
        // isovalue,                                                                              <L 1393>
        mc_calc_face_0(var_flat_edge_verts_table, var_corner_offsets_table, var_329, var_18, var_sdf, var_9, var_12, var_15, var_isovalue, var_330, var_331, var_332, var_333, var_334);
        // vertices[3 * out_idx_faces + 3 * fi + 0] = wp.vec3(face_verts[0])                      <L 1395>
        var_336 = wp::extract(var_334, var_335);
        var_337 = wp::vec_t<3, wp::float32>(var_336);
        var_339 = wp::mul(var_338, var_199);
        var_341 = wp::mul(var_340, var_325);
        var_342 = wp::add(var_339, var_341);
        var_344 = wp::add(var_342, var_343);
        wp::array_store(var_vertices, var_344, var_337);
        // vertices[3 * out_idx_faces + 3 * fi + 1] = wp.vec3(face_verts[1])                      <L 1396>
        var_346 = wp::extract(var_334, var_345);
        var_347 = wp::vec_t<3, wp::float32>(var_346);
        var_349 = wp::mul(var_348, var_199);
        var_351 = wp::mul(var_350, var_325);
        var_352 = wp::add(var_349, var_351);
        var_354 = wp::add(var_352, var_353);
        wp::array_store(var_vertices, var_354, var_347);
        // vertices[3 * out_idx_faces + 3 * fi + 2] = wp.vec3(face_verts[2])                      <L 1397>
        var_356 = wp::extract(var_334, var_355);
        var_357 = wp::vec_t<3, wp::float32>(var_356);
        var_359 = wp::mul(var_358, var_199);
        var_361 = wp::mul(var_360, var_325);
        var_362 = wp::add(var_359, var_361);
        var_364 = wp::add(var_362, var_363);
        wp::array_store(var_vertices, var_364, var_357);
        // face_normals[out_idx_faces + fi] = normal                                              <L 1398>
        var_365 = wp::add(var_199, var_325);
        wp::array_store(var_face_normals, var_365, var_331);
        // if fi >= num_faces:                                                                    <L 1382>
        var_367 = (var_366 >= var_197);
        if (var_367) {
            // return                                                                             <L 1383>
            continue;
        }
        // _area, normal, _face_center, _pen_depth, face_verts = mc_calc_face(                    <L 1384>
        // flat_edge_verts_table,                                                                 <L 1385>
        // corner_offsets_table,                                                                  <L 1386>
        // tri_range_start + 3 * fi,                                                              <L 1387>
        var_369 = wp::mul(var_368, var_366);
        var_370 = wp::add(var_188, var_369);
        // corner_vals,                                                                           <L 1388>
        // sdf,                                                                                   <L 1389>
        // x_id,                                                                                  <L 1390>
        // y_id,                                                                                  <L 1391>
        // z_id,                                                                                  <L 1392>
        // isovalue,                                                                              <L 1393>
        mc_calc_face_0(var_flat_edge_verts_table, var_corner_offsets_table, var_370, var_18, var_sdf, var_9, var_12, var_15, var_isovalue, var_371, var_372, var_373, var_374, var_375);
        // vertices[3 * out_idx_faces + 3 * fi + 0] = wp.vec3(face_verts[0])                      <L 1395>
        var_377 = wp::extract(var_375, var_376);
        var_378 = wp::vec_t<3, wp::float32>(var_377);
        var_380 = wp::mul(var_379, var_199);
        var_382 = wp::mul(var_381, var_366);
        var_383 = wp::add(var_380, var_382);
        var_385 = wp::add(var_383, var_384);
        wp::array_store(var_vertices, var_385, var_378);
        // vertices[3 * out_idx_faces + 3 * fi + 1] = wp.vec3(face_verts[1])                      <L 1396>
        var_387 = wp::extract(var_375, var_386);
        var_388 = wp::vec_t<3, wp::float32>(var_387);
        var_390 = wp::mul(var_389, var_199);
        var_392 = wp::mul(var_391, var_366);
        var_393 = wp::add(var_390, var_392);
        var_395 = wp::add(var_393, var_394);
        wp::array_store(var_vertices, var_395, var_388);
        // vertices[3 * out_idx_faces + 3 * fi + 2] = wp.vec3(face_verts[2])                      <L 1397>
        var_397 = wp::extract(var_375, var_396);
        var_398 = wp::vec_t<3, wp::float32>(var_397);
        var_400 = wp::mul(var_399, var_199);
        var_402 = wp::mul(var_401, var_366);
        var_403 = wp::add(var_400, var_402);
        var_405 = wp::add(var_403, var_404);
        wp::array_store(var_vertices, var_405, var_398);
        // face_normals[out_idx_faces + fi] = normal                                              <L 1398>
        var_406 = wp::add(var_199, var_366);
        wp::array_store(var_face_normals, var_406, var_372);
    }
}



extern "C" __global__ void compute_mesh_signed_volume_kernel_dbc49a38_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::vec_t<3, wp::float32>> var_points,
    wp::array_t<wp::int32> var_indices,
    wp::array_t<wp::float32> var_volume_sum)
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
        const wp::int32 var_1 = 3;
        wp::int32 var_2;
        const wp::int32 var_3 = 0;
        wp::int32 var_4;
        wp::int32* var_5;
        wp::vec_t<3, wp::float32>* var_6;
        wp::int32 var_7;
        wp::vec_t<3, wp::float32> var_8;
        wp::vec_t<3, wp::float32> var_9;
        const wp::int32 var_10 = 3;
        wp::int32 var_11;
        const wp::int32 var_12 = 1;
        wp::int32 var_13;
        wp::int32* var_14;
        wp::vec_t<3, wp::float32>* var_15;
        wp::int32 var_16;
        wp::vec_t<3, wp::float32> var_17;
        wp::vec_t<3, wp::float32> var_18;
        const wp::int32 var_19 = 3;
        wp::int32 var_20;
        const wp::int32 var_21 = 2;
        wp::int32 var_22;
        wp::int32* var_23;
        wp::vec_t<3, wp::float32>* var_24;
        wp::int32 var_25;
        wp::vec_t<3, wp::float32> var_26;
        wp::vec_t<3, wp::float32> var_27;
        const wp::int32 var_28 = 0;
        wp::vec_t<3, wp::float32> var_29;
        wp::float32 var_30;
        const wp::float32 var_31 = 6.0;
        wp::float32 var_32;
        wp::float32 var_33;
        //---------
        // forward
        // def compute_mesh_signed_volume_kernel(                                                 <L 630>
        // tri_idx = wp.tid()                                                                     <L 636>
        var_0 = builtin_tid1d();
        // v0 = points[indices[tri_idx * 3 + 0]]                                                  <L 637>
        var_2 = wp::mul(var_0, var_1);
        var_4 = wp::add(var_2, var_3);
        var_5 = wp::address(var_indices, var_4);
        var_7 = wp::load(var_5);
        var_6 = wp::address(var_points, var_7);
        var_9 = wp::load(var_6);
        var_8 = wp::copy(var_9);
        // v1 = points[indices[tri_idx * 3 + 1]]                                                  <L 638>
        var_11 = wp::mul(var_0, var_10);
        var_13 = wp::add(var_11, var_12);
        var_14 = wp::address(var_indices, var_13);
        var_16 = wp::load(var_14);
        var_15 = wp::address(var_points, var_16);
        var_18 = wp::load(var_15);
        var_17 = wp::copy(var_18);
        // v2 = points[indices[tri_idx * 3 + 2]]                                                  <L 639>
        var_20 = wp::mul(var_0, var_19);
        var_22 = wp::add(var_20, var_21);
        var_23 = wp::address(var_indices, var_22);
        var_25 = wp::load(var_23);
        var_24 = wp::address(var_points, var_25);
        var_27 = wp::load(var_24);
        var_26 = wp::copy(var_27);
        // wp.atomic_add(volume_sum, 0, wp.dot(v0, wp.cross(v1, v2)) / 6.0)                       <L 640>
        var_29 = wp::cross(var_17, var_26);
        var_30 = wp::dot(var_8, var_29);
        var_32 = wp::div(var_30, var_31);
        var_33 = wp::atomic_add(var_volume_sum, var_28, var_32);
    }
}



extern "C" __global__ void compute_mesh_signed_volume_kernel_dbc49a38_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::vec_t<3, wp::float32>> var_points,
    wp::array_t<wp::int32> var_indices,
    wp::array_t<wp::float32> var_volume_sum,
    wp::array_t<wp::vec_t<3, wp::float32>> adj_points,
    wp::array_t<wp::int32> adj_indices,
    wp::array_t<wp::float32> adj_volume_sum)
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
        const wp::int32 var_1 = 3;
        wp::int32 var_2;
        const wp::int32 var_3 = 0;
        wp::int32 var_4;
        wp::int32* var_5;
        wp::vec_t<3, wp::float32>* var_6;
        wp::int32 var_7;
        wp::vec_t<3, wp::float32> var_8;
        wp::vec_t<3, wp::float32> var_9;
        const wp::int32 var_10 = 3;
        wp::int32 var_11;
        const wp::int32 var_12 = 1;
        wp::int32 var_13;
        wp::int32* var_14;
        wp::vec_t<3, wp::float32>* var_15;
        wp::int32 var_16;
        wp::vec_t<3, wp::float32> var_17;
        wp::vec_t<3, wp::float32> var_18;
        const wp::int32 var_19 = 3;
        wp::int32 var_20;
        const wp::int32 var_21 = 2;
        wp::int32 var_22;
        wp::int32* var_23;
        wp::vec_t<3, wp::float32>* var_24;
        wp::int32 var_25;
        wp::vec_t<3, wp::float32> var_26;
        wp::vec_t<3, wp::float32> var_27;
        const wp::int32 var_28 = 0;
        wp::vec_t<3, wp::float32> var_29;
        wp::float32 var_30;
        const wp::float32 var_31 = 6.0;
        wp::float32 var_32;
        wp::float32 var_33;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::int32 adj_2 = {};
        wp::int32 adj_3 = {};
        wp::int32 adj_4 = {};
        wp::int32 adj_5 = {};
        wp::vec_t<3, wp::float32> adj_6 = {};
        wp::int32 adj_7 = {};
        wp::vec_t<3, wp::float32> adj_8 = {};
        wp::vec_t<3, wp::float32> adj_9 = {};
        wp::int32 adj_10 = {};
        wp::int32 adj_11 = {};
        wp::int32 adj_12 = {};
        wp::int32 adj_13 = {};
        wp::int32 adj_14 = {};
        wp::vec_t<3, wp::float32> adj_15 = {};
        wp::int32 adj_16 = {};
        wp::vec_t<3, wp::float32> adj_17 = {};
        wp::vec_t<3, wp::float32> adj_18 = {};
        wp::int32 adj_19 = {};
        wp::int32 adj_20 = {};
        wp::int32 adj_21 = {};
        wp::int32 adj_22 = {};
        wp::int32 adj_23 = {};
        wp::vec_t<3, wp::float32> adj_24 = {};
        wp::int32 adj_25 = {};
        wp::vec_t<3, wp::float32> adj_26 = {};
        wp::vec_t<3, wp::float32> adj_27 = {};
        wp::int32 adj_28 = {};
        wp::vec_t<3, wp::float32> adj_29 = {};
        wp::float32 adj_30 = {};
        wp::float32 adj_31 = {};
        wp::float32 adj_32 = {};
        wp::float32 adj_33 = {};
        //---------
        // forward
        // def compute_mesh_signed_volume_kernel(                                                 <L 630>
        // tri_idx = wp.tid()                                                                     <L 636>
        var_0 = builtin_tid1d();
        // v0 = points[indices[tri_idx * 3 + 0]]                                                  <L 637>
        var_2 = wp::mul(var_0, var_1);
        var_4 = wp::add(var_2, var_3);
        var_5 = wp::address(var_indices, var_4);
        var_7 = wp::load(var_5);
        var_6 = wp::address(var_points, var_7);
        var_9 = wp::load(var_6);
        var_8 = wp::copy(var_9);
        // v1 = points[indices[tri_idx * 3 + 1]]                                                  <L 638>
        var_11 = wp::mul(var_0, var_10);
        var_13 = wp::add(var_11, var_12);
        var_14 = wp::address(var_indices, var_13);
        var_16 = wp::load(var_14);
        var_15 = wp::address(var_points, var_16);
        var_18 = wp::load(var_15);
        var_17 = wp::copy(var_18);
        // v2 = points[indices[tri_idx * 3 + 2]]                                                  <L 639>
        var_20 = wp::mul(var_0, var_19);
        var_22 = wp::add(var_20, var_21);
        var_23 = wp::address(var_indices, var_22);
        var_25 = wp::load(var_23);
        var_24 = wp::address(var_points, var_25);
        var_27 = wp::load(var_24);
        var_26 = wp::copy(var_27);
        // wp.atomic_add(volume_sum, 0, wp.dot(v0, wp.cross(v1, v2)) / 6.0)                       <L 640>
        var_29 = wp::cross(var_17, var_26);
        var_30 = wp::dot(var_8, var_29);
        var_32 = wp::div(var_30, var_31);
        // var_33 = wp::atomic_add(var_volume_sum, var_28, var_32);
        //---------
        // reverse
        wp::adj_atomic_add(var_volume_sum, var_28, var_32, adj_volume_sum, adj_28, adj_32, adj_33);
        wp::adj_div(var_30, var_31, var_32, adj_30, adj_31, adj_32);
        wp::adj_dot(var_8, var_29, adj_8, adj_29, adj_30);
        wp::adj_cross(var_17, var_26, adj_17, adj_26, adj_29);
        // adj: wp.atomic_add(volume_sum, 0, wp.dot(v0, wp.cross(v1, v2)) / 6.0)                  <L 640>
        wp::adj_copy(var_27, adj_24, adj_26);
        wp::adj_address(var_points, var_25, adj_points, adj_23, adj_24);
        wp::adj_address(var_indices, var_22, adj_indices, adj_22, adj_23);
        wp::adj_add(var_20, var_21, adj_20, adj_21, adj_22);
        wp::adj_mul(var_0, var_19, adj_0, adj_19, adj_20);
        // adj: v2 = points[indices[tri_idx * 3 + 2]]                                             <L 639>
        wp::adj_copy(var_18, adj_15, adj_17);
        wp::adj_address(var_points, var_16, adj_points, adj_14, adj_15);
        wp::adj_address(var_indices, var_13, adj_indices, adj_13, adj_14);
        wp::adj_add(var_11, var_12, adj_11, adj_12, adj_13);
        wp::adj_mul(var_0, var_10, adj_0, adj_10, adj_11);
        // adj: v1 = points[indices[tri_idx * 3 + 1]]                                             <L 638>
        wp::adj_copy(var_9, adj_6, adj_8);
        wp::adj_address(var_points, var_7, adj_points, adj_5, adj_6);
        wp::adj_address(var_indices, var_4, adj_indices, adj_4, adj_5);
        wp::adj_add(var_2, var_3, adj_2, adj_3, adj_4);
        wp::adj_mul(var_0, var_1, adj_0, adj_1, adj_2);
        // adj: v0 = points[indices[tri_idx * 3 + 0]]                                             <L 637>
        // adj: tri_idx = wp.tid()                                                                <L 636>
        // adj: def compute_mesh_signed_volume_kernel(                                            <L 630>
        continue;
    }
}



extern "C" __global__ void check_tile_occupied_mesh_kernel_c36ede5b_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::uint64 var_mesh,
    wp::array_t<wp::vec_t<3, wp::float32>> var_tile_points,
    wp::vec_t<2, wp::float32> var_threshold,
    wp::float32 var_winding_threshold,
    wp::array_t<bool> var_tile_occupied)
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
        wp::vec_t<3, wp::float32> var_3;
        const wp::float32 var_4 = 10000.0;
        wp::float32 var_5;
        const bool var_6 = false;
        bool var_7;
        wp::float32 var_8;
        const wp::float32 var_9 = 0.0;
        bool var_10;
        const wp::int32 var_11 = 1;
        wp::float32 var_12;
        bool var_13;
        const wp::int32 var_14 = 0;
        wp::float32 var_15;
        bool var_16;
        bool var_17;
        //---------
        // forward
        // def check_tile_occupied_mesh_kernel(                                                   <L 759>
        // tid = wp.tid()                                                                         <L 766>
        var_0 = builtin_tid1d();
        // sample_pos = tile_points[tid]                                                          <L 767>
        var_1 = wp::address(var_tile_points, var_0);
        var_3 = wp::load(var_1);
        var_2 = wp::copy(var_3);
        // signed_distance = get_distance_to_mesh(mesh, sample_pos, 10000.0, winding_threshold)       <L 769>
        var_5 = get_distance_to_mesh_0(var_mesh, var_2, var_4, var_winding_threshold);
        // is_occupied = wp.bool(False)                                                           <L 770>
        var_7 = bool(var_6);
        // if wp.sign(signed_distance) > 0.0:                                                     <L 771>
        var_8 = wp::sign(var_5);
        var_10 = (var_8 > var_9);
        if (var_10) {
            // is_occupied = signed_distance < threshold[1]                                       <L 772>
            var_12 = wp::extract(var_threshold, var_11);
            var_13 = (var_5 < var_12);
        }
        if (!var_10) {
            // is_occupied = signed_distance > threshold[0]                                       <L 774>
            var_15 = wp::extract(var_threshold, var_14);
            var_16 = (var_5 > var_15);
        }
        var_17 = wp::where(var_10, var_13, var_16);
        // tile_occupied[tid] = is_occupied                                                       <L 775>
        wp::array_store(var_tile_occupied, var_0, var_17);
    }
}



extern "C" __global__ void check_tile_occupied_mesh_kernel_c36ede5b_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::uint64 var_mesh,
    wp::array_t<wp::vec_t<3, wp::float32>> var_tile_points,
    wp::vec_t<2, wp::float32> var_threshold,
    wp::float32 var_winding_threshold,
    wp::array_t<bool> var_tile_occupied,
    wp::uint64 adj_mesh,
    wp::array_t<wp::vec_t<3, wp::float32>> adj_tile_points,
    wp::vec_t<2, wp::float32> adj_threshold,
    wp::float32 adj_winding_threshold,
    wp::array_t<bool> adj_tile_occupied)
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
        wp::vec_t<3, wp::float32> var_3;
        const wp::float32 var_4 = 10000.0;
        wp::float32 var_5;
        const bool var_6 = false;
        bool var_7;
        wp::float32 var_8;
        const wp::float32 var_9 = 0.0;
        bool var_10;
        const wp::int32 var_11 = 1;
        wp::float32 var_12;
        bool var_13;
        const wp::int32 var_14 = 0;
        wp::float32 var_15;
        bool var_16;
        bool var_17;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::vec_t<3, wp::float32> adj_1 = {};
        wp::vec_t<3, wp::float32> adj_2 = {};
        wp::vec_t<3, wp::float32> adj_3 = {};
        wp::float32 adj_4 = {};
        wp::float32 adj_5 = {};
        bool adj_6 = {};
        bool adj_7 = {};
        wp::float32 adj_8 = {};
        wp::float32 adj_9 = {};
        bool adj_10 = {};
        wp::int32 adj_11 = {};
        wp::float32 adj_12 = {};
        bool adj_13 = {};
        wp::int32 adj_14 = {};
        wp::float32 adj_15 = {};
        bool adj_16 = {};
        bool adj_17 = {};
        //---------
        // forward
        // def check_tile_occupied_mesh_kernel(                                                   <L 759>
        // tid = wp.tid()                                                                         <L 766>
        var_0 = builtin_tid1d();
        // sample_pos = tile_points[tid]                                                          <L 767>
        var_1 = wp::address(var_tile_points, var_0);
        var_3 = wp::load(var_1);
        var_2 = wp::copy(var_3);
        // signed_distance = get_distance_to_mesh(mesh, sample_pos, 10000.0, winding_threshold)       <L 769>
        var_5 = get_distance_to_mesh_0(var_mesh, var_2, var_4, var_winding_threshold);
        // is_occupied = wp.bool(False)                                                           <L 770>
        var_7 = bool(var_6);
        // if wp.sign(signed_distance) > 0.0:                                                     <L 771>
        var_8 = wp::sign(var_5);
        var_10 = (var_8 > var_9);
        if (var_10) {
            // is_occupied = signed_distance < threshold[1]                                       <L 772>
            var_12 = wp::extract(var_threshold, var_11);
            var_13 = (var_5 < var_12);
        }
        if (!var_10) {
            // is_occupied = signed_distance > threshold[0]                                       <L 774>
            var_15 = wp::extract(var_threshold, var_14);
            var_16 = (var_5 > var_15);
        }
        var_17 = wp::where(var_10, var_13, var_16);
        // tile_occupied[tid] = is_occupied                                                       <L 775>
        // wp::array_store(var_tile_occupied, var_0, var_17);
        //---------
        // reverse
        wp::adj_array_store(var_tile_occupied, var_0, var_17, adj_tile_occupied, adj_0, adj_17);
        // adj: tile_occupied[tid] = is_occupied                                                  <L 775>
        wp::adj_where(var_10, var_13, var_16, adj_10, adj_13, adj_16, adj_17);
        if (!var_10) {
            wp::adj_extract(var_threshold, var_14, adj_threshold, adj_14, adj_15);
            // adj: is_occupied = signed_distance > threshold[0]                                  <L 774>
        }
        if (var_10) {
            wp::adj_extract(var_threshold, var_11, adj_threshold, adj_11, adj_12);
            // adj: is_occupied = signed_distance < threshold[1]                                  <L 772>
        }
        // adj: if wp.sign(signed_distance) > 0.0:                                                <L 771>
        // adj: is_occupied = wp.bool(False)                                                      <L 770>
        adj_get_distance_to_mesh_0(var_mesh, var_2, var_4, var_winding_threshold, adj_mesh, adj_2, adj_4, adj_winding_threshold, adj_5);
        // adj: signed_distance = get_distance_to_mesh(mesh, sample_pos, 10000.0, winding_threshold)  <L 769>
        wp::adj_copy(var_3, adj_1, adj_2);
        wp::adj_address(var_tile_points, var_0, adj_tile_points, adj_0, adj_1);
        // adj: sample_pos = tile_points[tid]                                                     <L 767>
        // adj: tid = wp.tid()                                                                    <L 766>
        // adj: def check_tile_occupied_mesh_kernel(                                              <L 759>
        continue;
    }
}



extern "C" __global__ void check_tile_occupied_primitive_kernel_55670b38_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::int32 var_shape_type,
    wp::vec_t<3, wp::float32> var_shape_scale,
    wp::array_t<wp::vec_t<3, wp::float32>> var_tile_points,
    wp::vec_t<2, wp::float32> var_threshold,
    wp::array_t<bool> var_tile_occupied)
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
        wp::vec_t<3, wp::float32> var_3;
        const wp::float32 var_4 = 1000000.0;
        wp::float32 var_5;
        const wp::int32 var_6 = 3;
        bool var_7;
        const wp::int32 var_8 = 0;
        wp::float32 var_9;
        wp::float32 var_10;
        const wp::int32 var_11 = 7;
        bool var_12;
        const wp::int32 var_13 = 0;
        wp::float32 var_14;
        const wp::int32 var_15 = 1;
        wp::float32 var_16;
        const wp::int32 var_17 = 2;
        wp::float32 var_18;
        wp::float32 var_19;
        const wp::int32 var_20 = 4;
        bool var_21;
        const wp::int32 var_22 = 0;
        wp::float32 var_23;
        const wp::int32 var_24 = 1;
        wp::float32 var_25;
        const wp::int32 var_26 = 2;
        const wp::int32 var_27 = 2;
        wp::int32 var_28;
        wp::float32 var_29;
        const wp::int32 var_30 = 6;
        bool var_31;
        const wp::int32 var_32 = 0;
        wp::float32 var_33;
        const wp::int32 var_34 = 1;
        wp::float32 var_35;
        const wp::int32 var_36 = 2;
        const wp::int32 var_37 = 2;
        wp::int32 var_38;
        wp::float32 var_39;
        const wp::float32 var_40 = -1.0;
        const wp::int32 var_41 = 5;
        bool var_42;
        wp::float32 var_43;
        const wp::int32 var_44 = 9;
        bool var_45;
        const wp::int32 var_46 = 0;
        wp::float32 var_47;
        const wp::int32 var_48 = 1;
        wp::float32 var_49;
        const wp::int32 var_50 = 2;
        const wp::int32 var_51 = 2;
        wp::int32 var_52;
        wp::float32 var_53;
        wp::float32 var_54;
        wp::float32 var_55;
        wp::float32 var_56;
        wp::float32 var_57;
        wp::float32 var_58;
        wp::float32 var_59;
        const bool var_60 = false;
        bool var_61;
        wp::float32 var_62;
        const wp::float32 var_63 = 0.0;
        bool var_64;
        const wp::int32 var_65 = 1;
        wp::float32 var_66;
        bool var_67;
        const wp::int32 var_68 = 0;
        wp::float32 var_69;
        bool var_70;
        bool var_71;
        //---------
        // forward
        // def check_tile_occupied_primitive_kernel(                                              <L 779>
        // tid = wp.tid()                                                                         <L 786>
        var_0 = builtin_tid1d();
        // sample_pos = tile_points[tid]                                                          <L 787>
        var_1 = wp::address(var_tile_points, var_0);
        var_3 = wp::load(var_1);
        var_2 = wp::copy(var_3);
        // signed_distance = float(1.0e6)                                                         <L 789>
        var_5 = wp::float(var_4);
        // if shape_type == GeoType.SPHERE:                                                       <L 790>
        var_7 = (var_shape_type == var_6);
        if (var_7) {
            // signed_distance = sdf_sphere(sample_pos, shape_scale[0])                           <L 791>
            var_9 = wp::extract(var_shape_scale, var_8);
            var_10 = sdf_sphere_0(var_2, var_9);
        }
        if (!var_7) {
            // elif shape_type == GeoType.BOX:                                                    <L 792>
            var_12 = (var_shape_type == var_11);
            if (var_12) {
                // signed_distance = sdf_box(sample_pos, shape_scale[0], shape_scale[1], shape_scale[2])       <L 793>
                var_14 = wp::extract(var_shape_scale, var_13);
                var_16 = wp::extract(var_shape_scale, var_15);
                var_18 = wp::extract(var_shape_scale, var_17);
                var_19 = sdf_box_0(var_2, var_14, var_16, var_18);
            }
            if (!var_12) {
                // elif shape_type == GeoType.CAPSULE:                                            <L 794>
                var_21 = (var_shape_type == var_20);
                if (var_21) {
                    // signed_distance = sdf_capsule(sample_pos, shape_scale[0], shape_scale[1], int(Axis.Z))       <L 795>
                    var_23 = wp::extract(var_shape_scale, var_22);
                    var_25 = wp::extract(var_shape_scale, var_24);
                    var_28 = wp::int(var_27);
                    var_29 = sdf_capsule_0(var_2, var_23, var_25, var_28);
                }
                if (!var_21) {
                    // elif shape_type == GeoType.CYLINDER:                                       <L 796>
                    var_31 = (var_shape_type == var_30);
                    if (var_31) {
                        // signed_distance = sdf_cylinder(sample_pos, shape_scale[0], shape_scale[1], int(Axis.Z))       <L 797>
                        var_33 = wp::extract(var_shape_scale, var_32);
                        var_35 = wp::extract(var_shape_scale, var_34);
                        var_38 = wp::int(var_37);
                        var_39 = sdf_cylinder_0(var_2, var_33, var_35, var_38, var_40);
                    }
                    if (!var_31) {
                        // elif shape_type == GeoType.ELLIPSOID:                                  <L 798>
                        var_42 = (var_shape_type == var_41);
                        if (var_42) {
                            // signed_distance = sdf_ellipsoid(sample_pos, shape_scale)           <L 799>
                            var_43 = sdf_ellipsoid_0(var_2, var_shape_scale);
                        }
                        if (!var_42) {
                            // elif shape_type == GeoType.CONE:                                   <L 800>
                            var_45 = (var_shape_type == var_44);
                            if (var_45) {
                                // signed_distance = sdf_cone(sample_pos, shape_scale[0], shape_scale[1], int(Axis.Z))       <L 801>
                                var_47 = wp::extract(var_shape_scale, var_46);
                                var_49 = wp::extract(var_shape_scale, var_48);
                                var_52 = wp::int(var_51);
                                var_53 = sdf_cone_0(var_2, var_47, var_49, var_52);
                            }
                            var_54 = wp::where(var_45, var_53, var_5);
                        }
                        var_55 = wp::where(var_42, var_43, var_54);
                    }
                    var_56 = wp::where(var_31, var_39, var_55);
                }
                var_57 = wp::where(var_21, var_29, var_56);
            }
            var_58 = wp::where(var_12, var_19, var_57);
        }
        var_59 = wp::where(var_7, var_10, var_58);
        // is_occupied = wp.bool(False)                                                           <L 803>
        var_61 = bool(var_60);
        // if wp.sign(signed_distance) > 0.0:                                                     <L 804>
        var_62 = wp::sign(var_59);
        var_64 = (var_62 > var_63);
        if (var_64) {
            // is_occupied = signed_distance < threshold[1]                                       <L 805>
            var_66 = wp::extract(var_threshold, var_65);
            var_67 = (var_59 < var_66);
        }
        if (!var_64) {
            // is_occupied = signed_distance > threshold[0]                                       <L 807>
            var_69 = wp::extract(var_threshold, var_68);
            var_70 = (var_59 > var_69);
        }
        var_71 = wp::where(var_64, var_67, var_70);
        // tile_occupied[tid] = is_occupied                                                       <L 808>
        wp::array_store(var_tile_occupied, var_0, var_71);
    }
}



extern "C" __global__ void _populate_dense_sdf_kernel_0f64c8c6_cuda_kernel_forward(
    wp::launch_bounds_t<3> dim,
    wp::int32 var_shape_type,
    wp::vec_t<3, wp::float32> var_shape_scale,
    wp::vec_t<3, wp::float32> var_origin,
    wp::vec_t<3, wp::float32> var_voxel_size,
    wp::int32 var_ny,
    wp::int32 var_nz,
    wp::float32 var_shape_offset,
    wp::array_t<wp::float32> var_sdf_values)
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
        const wp::int32 var_3 = 0;
        wp::float32 var_4;
        wp::float32 var_5;
        const wp::int32 var_6 = 0;
        wp::float32 var_7;
        wp::float32 var_8;
        wp::float32 var_9;
        const wp::int32 var_10 = 1;
        wp::float32 var_11;
        wp::float32 var_12;
        const wp::int32 var_13 = 1;
        wp::float32 var_14;
        wp::float32 var_15;
        wp::float32 var_16;
        const wp::int32 var_17 = 2;
        wp::float32 var_18;
        wp::float32 var_19;
        const wp::int32 var_20 = 2;
        wp::float32 var_21;
        wp::float32 var_22;
        wp::float32 var_23;
        wp::vec_t<3, wp::float32> var_24;
        const wp::float32 var_25 = 1000000.0;
        wp::float32 var_26;
        const wp::int32 var_27 = 3;
        bool var_28;
        const wp::int32 var_29 = 0;
        wp::float32 var_30;
        wp::float32 var_31;
        const wp::int32 var_32 = 7;
        bool var_33;
        const wp::int32 var_34 = 0;
        wp::float32 var_35;
        const wp::int32 var_36 = 1;
        wp::float32 var_37;
        const wp::int32 var_38 = 2;
        wp::float32 var_39;
        wp::float32 var_40;
        const wp::int32 var_41 = 4;
        bool var_42;
        const wp::int32 var_43 = 0;
        wp::float32 var_44;
        const wp::int32 var_45 = 1;
        wp::float32 var_46;
        const wp::int32 var_47 = 2;
        const wp::int32 var_48 = 2;
        wp::int32 var_49;
        wp::float32 var_50;
        const wp::int32 var_51 = 6;
        bool var_52;
        const wp::int32 var_53 = 0;
        wp::float32 var_54;
        const wp::int32 var_55 = 1;
        wp::float32 var_56;
        const wp::int32 var_57 = 2;
        const wp::int32 var_58 = 2;
        wp::int32 var_59;
        wp::float32 var_60;
        const wp::float32 var_61 = -1.0;
        const wp::int32 var_62 = 5;
        bool var_63;
        wp::float32 var_64;
        const wp::int32 var_65 = 9;
        bool var_66;
        const wp::int32 var_67 = 0;
        wp::float32 var_68;
        const wp::int32 var_69 = 1;
        wp::float32 var_70;
        const wp::int32 var_71 = 2;
        const wp::int32 var_72 = 2;
        wp::int32 var_73;
        wp::float32 var_74;
        wp::float32 var_75;
        wp::float32 var_76;
        wp::float32 var_77;
        wp::float32 var_78;
        wp::float32 var_79;
        wp::float32 var_80;
        wp::float32 var_81;
        wp::int32 var_82;
        wp::int32 var_83;
        wp::int32 var_84;
        wp::int32 var_85;
        wp::int32 var_86;
        //---------
        // forward
        // def _populate_dense_sdf_kernel(                                                        <L 1422>
        // x, y, z = wp.tid()                                                                     <L 1433>
        builtin_tid3d(var_0, var_1, var_2);
        // pos = wp.vec3(                                                                         <L 1434>
        // origin[0] + float(x) * voxel_size[0],                                                  <L 1435>
        var_4 = wp::extract(var_origin, var_3);
        var_5 = wp::float(var_0);
        var_7 = wp::extract(var_voxel_size, var_6);
        var_8 = wp::mul(var_5, var_7);
        var_9 = wp::add(var_4, var_8);
        // origin[1] + float(y) * voxel_size[1],                                                  <L 1436>
        var_11 = wp::extract(var_origin, var_10);
        var_12 = wp::float(var_1);
        var_14 = wp::extract(var_voxel_size, var_13);
        var_15 = wp::mul(var_12, var_14);
        var_16 = wp::add(var_11, var_15);
        // origin[2] + float(z) * voxel_size[2],                                                  <L 1437>
        var_18 = wp::extract(var_origin, var_17);
        var_19 = wp::float(var_2);
        var_21 = wp::extract(var_voxel_size, var_20);
        var_22 = wp::mul(var_19, var_21);
        var_23 = wp::add(var_18, var_22);
        var_24 = wp::vec_t<3, wp::float32>(var_9, var_16, var_23);
        // d = float(1.0e6)                                                                       <L 1439>
        var_26 = wp::float(var_25);
        // if shape_type == GeoType.SPHERE:                                                       <L 1440>
        var_28 = (var_shape_type == var_27);
        if (var_28) {
            // d = sdf_sphere(pos, shape_scale[0])                                                <L 1441>
            var_30 = wp::extract(var_shape_scale, var_29);
            var_31 = sdf_sphere_0(var_24, var_30);
        }
        if (!var_28) {
            // elif shape_type == GeoType.BOX:                                                    <L 1442>
            var_33 = (var_shape_type == var_32);
            if (var_33) {
                // d = sdf_box(pos, shape_scale[0], shape_scale[1], shape_scale[2])               <L 1443>
                var_35 = wp::extract(var_shape_scale, var_34);
                var_37 = wp::extract(var_shape_scale, var_36);
                var_39 = wp::extract(var_shape_scale, var_38);
                var_40 = sdf_box_0(var_24, var_35, var_37, var_39);
            }
            if (!var_33) {
                // elif shape_type == GeoType.CAPSULE:                                            <L 1444>
                var_42 = (var_shape_type == var_41);
                if (var_42) {
                    // d = sdf_capsule(pos, shape_scale[0], shape_scale[1], int(Axis.Z))          <L 1445>
                    var_44 = wp::extract(var_shape_scale, var_43);
                    var_46 = wp::extract(var_shape_scale, var_45);
                    var_49 = wp::int(var_48);
                    var_50 = sdf_capsule_0(var_24, var_44, var_46, var_49);
                }
                if (!var_42) {
                    // elif shape_type == GeoType.CYLINDER:                                       <L 1446>
                    var_52 = (var_shape_type == var_51);
                    if (var_52) {
                        // d = sdf_cylinder(pos, shape_scale[0], shape_scale[1], int(Axis.Z))       <L 1447>
                        var_54 = wp::extract(var_shape_scale, var_53);
                        var_56 = wp::extract(var_shape_scale, var_55);
                        var_59 = wp::int(var_58);
                        var_60 = sdf_cylinder_0(var_24, var_54, var_56, var_59, var_61);
                    }
                    if (!var_52) {
                        // elif shape_type == GeoType.ELLIPSOID:                                  <L 1448>
                        var_63 = (var_shape_type == var_62);
                        if (var_63) {
                            // d = sdf_ellipsoid(pos, shape_scale)                                <L 1449>
                            var_64 = sdf_ellipsoid_0(var_24, var_shape_scale);
                        }
                        if (!var_63) {
                            // elif shape_type == GeoType.CONE:                                   <L 1450>
                            var_66 = (var_shape_type == var_65);
                            if (var_66) {
                                // d = sdf_cone(pos, shape_scale[0], shape_scale[1], int(Axis.Z))       <L 1451>
                                var_68 = wp::extract(var_shape_scale, var_67);
                                var_70 = wp::extract(var_shape_scale, var_69);
                                var_73 = wp::int(var_72);
                                var_74 = sdf_cone_0(var_24, var_68, var_70, var_73);
                            }
                            var_75 = wp::where(var_66, var_74, var_26);
                        }
                        var_76 = wp::where(var_63, var_64, var_75);
                    }
                    var_77 = wp::where(var_52, var_60, var_76);
                }
                var_78 = wp::where(var_42, var_50, var_77);
            }
            var_79 = wp::where(var_33, var_40, var_78);
        }
        var_80 = wp::where(var_28, var_31, var_79);
        // sdf_values[x * ny * nz + y * nz + z] = d - shape_offset                                <L 1452>
        var_81 = wp::sub(var_80, var_shape_offset);
        var_82 = wp::mul(var_0, var_ny);
        var_83 = wp::mul(var_82, var_nz);
        var_84 = wp::mul(var_1, var_nz);
        var_85 = wp::add(var_83, var_84);
        var_86 = wp::add(var_85, var_2);
        wp::array_store(var_sdf_values, var_86, var_81);
    }
}

