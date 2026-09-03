#define WP_NO_BFLOAT16

#define WP_TILE_BLOCK_DIM 256
#define WP_NO_CRT
#include "builtin.h"
#include "deterministic.h"

// avoid namespacing of float type for casting to float type, this is to avoid wp::float(x), which is not valid in C++
#define float(x) cast_float(x)
#define adj_float(x, adj_x, adj_ret) adj_cast_float(x, adj_x, adj_ret)

#define int(x) cast_int(x)
#define adj_int(x, adj_x, adj_ret) adj_cast_int(x, adj_x, adj_ret)

#define builtin_tid1d() wp::tid(task_index, dim)
#define builtin_tid2d(x, y) wp::tid(x, y, task_index, dim)
#define builtin_tid3d(x, y, z) wp::tid(x, y, z, task_index, dim)
#define builtin_tid4d(x, y, z, w) wp::tid(x, y, z, w, task_index, dim)

#define builtin_block_dim() wp::block_dim()


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/geometry/raycast.py:41
static wp::vec_t<3, wp::float32> safe_div_vec3_0(
    wp::vec_t<3, wp::float32> var_x,
    wp::vec_t<3, wp::float32> var_y)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    wp::float32 var_1;
    const wp::int32 var_2 = 0;
    wp::float32 var_3;
    const wp::float32 var_4 = 0.0;
    bool var_5;
    const wp::int32 var_6 = 0;
    wp::float32 var_7;
    const wp::float32 var_8 = 1e-06;
    wp::float32 var_9;
    wp::float32 var_10;
    const wp::int32 var_11 = 1;
    wp::float32 var_12;
    const wp::int32 var_13 = 1;
    wp::float32 var_14;
    const wp::float32 var_15 = 0.0;
    bool var_16;
    const wp::int32 var_17 = 1;
    wp::float32 var_18;
    wp::float32 var_19;
    wp::float32 var_20;
    const wp::int32 var_21 = 2;
    wp::float32 var_22;
    const wp::int32 var_23 = 2;
    wp::float32 var_24;
    const wp::float32 var_25 = 0.0;
    bool var_26;
    const wp::int32 var_27 = 2;
    wp::float32 var_28;
    wp::float32 var_29;
    wp::float32 var_30;
    wp::vec_t<3, wp::float32> var_31;
    //---------
    // forward
    // def safe_div_vec3(x: wp.vec3, y: wp.vec3) -> wp.vec3:                                  <L 42>
    // return wp.vec3(                                                                        <L 44>
    // x[0] / wp.where(y[0] != 0.0, y[0], EPSILON),                                           <L 45>
    var_1 = wp::extract(var_x, var_0);
    var_3 = wp::extract(var_y, var_2);
    var_5 = (var_3 != var_4);
    var_7 = wp::extract(var_y, var_6);
    var_9 = wp::where(var_5, var_7, var_8);
    var_10 = wp::div(var_1, var_9);
    // x[1] / wp.where(y[1] != 0.0, y[1], EPSILON),                                           <L 46>
    var_12 = wp::extract(var_x, var_11);
    var_14 = wp::extract(var_y, var_13);
    var_16 = (var_14 != var_15);
    var_18 = wp::extract(var_y, var_17);
    var_19 = wp::where(var_16, var_18, var_8);
    var_20 = wp::div(var_12, var_19);
    // x[2] / wp.where(y[2] != 0.0, y[2], EPSILON),                                           <L 47>
    var_22 = wp::extract(var_x, var_21);
    var_24 = wp::extract(var_y, var_23);
    var_26 = (var_24 != var_25);
    var_28 = wp::extract(var_y, var_27);
    var_29 = wp::where(var_26, var_28, var_8);
    var_30 = wp::div(var_22, var_29);
    var_31 = wp::vec_t<3, wp::float32>(var_10, var_20, var_30);
    return var_31;
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/geometry/raycast.py:51
static void map_ray_to_local_0(
    wp::transform_t<wp::float32> var_transform,
    wp::vec_t<3, wp::float32> var_ray_origin,
    wp::vec_t<3, wp::float32> var_ray_direction,
    wp::vec_t<3, wp::float32> var_scale,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    wp::transform_t<wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    bool var_3;
    const wp::int32 var_4 = 0;
    wp::float32 var_5;
    const wp::float32 var_6 = 1.0;
    bool var_7;
    const wp::int32 var_8 = 1;
    wp::float32 var_9;
    const wp::float32 var_10 = 1.0;
    bool var_11;
    const wp::int32 var_12 = 2;
    wp::float32 var_13;
    const wp::float32 var_14 = 1.0;
    bool var_15;
    const wp::float32 var_16 = 1.0;
    wp::vec_t<3, wp::float32> var_17;
    wp::vec_t<3, wp::float32> var_18;
    wp::vec_t<3, wp::float32> var_19;
    wp::vec_t<3, wp::float32> var_20;
    wp::vec_t<3, wp::float32> var_21;
    wp::vec_t<3, wp::float32> var_22;
    //---------
    // forward
    // def map_ray_to_local(                                                                  <L 52>
    // inv_transform = wp.transform_inverse(transform)                                        <L 69>
    var_0 = wp::transform_inverse(var_transform);
    // ray_origin_local = wp.transform_point(inv_transform, ray_origin)                       <L 70>
    var_1 = wp::transform_point(var_0, var_ray_origin);
    // ray_direction_local = wp.transform_vector(inv_transform, ray_direction)                <L 71>
    var_2 = wp::transform_vector(var_0, var_ray_direction);
    // if scale[0] != 1.0 or scale[1] != 1.0 or scale[2] != 1.0:                              <L 72>
    var_5 = wp::extract(var_scale, var_4);
    var_7 = (var_5 != var_6);
    var_3 = var_7;
    if (!var_3) {
        var_9 = wp::extract(var_scale, var_8);
        var_11 = (var_9 != var_10);
        var_3 = var_3 || var_11;
    }
    if (!var_3) {
        var_13 = wp::extract(var_scale, var_12);
        var_15 = (var_13 != var_14);
        var_3 = var_3 || var_15;
    }
    if (var_3) {
        // inv_size = safe_div_vec3(wp.vec3(1.0), scale)                                      <L 73>
        var_17 = wp::vec_t<3, wp::float32>(var_16);
        var_18 = safe_div_vec3_0(var_17, var_scale);
        // ray_origin_local = wp.cw_mul(ray_origin_local, inv_size)                           <L 74>
        var_19 = wp::cw_mul(var_1, var_18);
        // ray_direction_local = wp.cw_mul(ray_direction_local, inv_size)                     <L 75>
        var_20 = wp::cw_mul(var_2, var_18);
    }
    var_21 = wp::where(var_3, var_19, var_1);
    var_22 = wp::where(var_3, var_20, var_2);
    // return ray_origin_local, ray_direction_local                                           <L 76>
    ret_0 = var_21;
    ret_1 = var_22;
    return;
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/geometry/raycast.py:656
static void _make_ray_intersect_mesh__locals__ray_intersect_mesh_0(
    wp::vec_t<3, wp::float32> var_ray_origin,
    wp::vec_t<3, wp::float32> var_ray_direction,
    wp::vec_t<3, wp::float32> var_size,
    wp::uint64 var_mesh_id,
    bool var_enable_backface_culling,
    wp::float32 var_max_t,
    wp::int32 var_root,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::float32 & ret_2,
    wp::float32 & ret_3,
    wp::int32 & ret_4)
{
    //---------
    // primal vars
    wp::uint64 var_0;
    bool var_1;
    const wp::float32 var_2 = -1.0;
    const wp::float32 var_3 = 0.0;
    wp::vec_t<3, wp::float32> var_4;
    const wp::float32 var_5 = 0.0;
    const wp::float32 var_6 = 0.0;
    const wp::int32 var_7 = -1;
    wp::mesh_query_ray_t var_8;
    bool* var_9;
    bool var_10;
    bool var_11;
    bool var_12;
    wp::vec_t<3, wp::float32>* var_13;
    wp::float32 var_14;
    wp::vec_t<3, wp::float32> var_15;
    const wp::float32 var_16 = 0.0;
    bool var_17;
    const wp::float32 var_18 = 0.0;
    wp::vec_t<3, wp::float32> var_19;
    const bool var_20 = true;
    wp::vec_t<3, wp::float32>* var_21;
    wp::vec_t<3, wp::float32> var_22;
    wp::vec_t<3, wp::float32> var_23;
    wp::vec_t<3, wp::float32> var_24;
    wp::float32* var_25;
    wp::float32* var_26;
    wp::float32* var_27;
    wp::int32* var_28;
    wp::float32 var_29;
    wp::float32 var_30;
    wp::float32 var_31;
    wp::float32 var_32;
    wp::float32 var_33;
    wp::float32 var_34;
    wp::int32 var_35;
    wp::int32 var_36;
    bool var_37;
    const wp::float32 var_38 = -1.0;
    const wp::float32 var_39 = 0.0;
    wp::vec_t<3, wp::float32> var_40;
    const wp::float32 var_41 = 0.0;
    const wp::float32 var_42 = 0.0;
    const wp::int32 var_43 = -1;
    //---------
    // forward
    // def ray_intersect_mesh(                                                                <L 657>
    // if mesh_id == wp.uint64(0):                                                            <L 681>
    var_0 = 0ull;
    var_1 = (var_mesh_id == var_0);
    if (var_1) {
        // return -1.0, wp.vec3(0.0), 0.0, 0.0, -1                                            <L 682>
        var_4 = wp::vec_t<3, wp::float32>(var_3);
        ret_0 = var_2;
        ret_1 = var_4;
        ret_2 = var_5;
        ret_3 = var_6;
        ret_4 = var_7;
        return;
    }
    // query = wp.mesh_query_ray(mesh_id, ray_origin, ray_direction, max_t, root)             <L 684>
    var_8 = wp::mesh_query_ray(var_mesh_id, var_ray_origin, var_ray_direction, var_max_t, var_root);
    // if query.result:                                                                       <L 686>
    var_9 = &((var_8).result);
    var_10 = wp::load(var_9);
    if (var_10) {
        // if not enable_backface_culling or wp.dot(ray_direction, query.normal) < 0.0:       <L 687>
        var_12 = wp::unot(var_enable_backface_culling);
        var_11 = var_12;
        if (!var_11) {
            var_13 = &((var_8).normal);
            var_15 = wp::load(var_13);
            var_14 = wp::dot(var_ray_direction, var_15);
            var_17 = (var_14 < var_16);
            var_11 = var_11 || var_17;
        }
        if (var_11) {
            // normal = wp.vec3(0.0)                                                          <L 688>
            var_19 = wp::vec_t<3, wp::float32>(var_18);
            // if wp.static(compute_normal):                                                  <L 689>
            // normal = wp.normalize(safe_div_vec3(query.normal, size))                       <L 690>
            var_21 = &((var_8).normal);
            var_23 = wp::load(var_21);
            var_22 = safe_div_vec3_0(var_23, var_size);
            var_24 = wp::normalize(var_22);
            // return query.t, normal, query.u, query.v, query.face                           <L 691>
            var_25 = &((var_8).t);
            var_26 = &((var_8).u);
            var_27 = &((var_8).v);
            var_28 = &((var_8).face);
            var_30 = wp::load(var_25);
            var_29 = wp::copy(var_30);
            var_32 = wp::load(var_26);
            var_31 = wp::copy(var_32);
            var_34 = wp::load(var_27);
            var_33 = wp::copy(var_34);
            var_36 = wp::load(var_28);
            var_35 = wp::copy(var_36);
            ret_0 = var_29;
            ret_1 = var_24;
            ret_2 = var_31;
            ret_3 = var_33;
            ret_4 = var_35;
            return;
        }
    }
    var_37 = wp::load(var_9);
    // return -1.0, wp.vec3(0.0), 0.0, 0.0, -1                                                <L 693>
    var_40 = wp::vec_t<3, wp::float32>(var_39);
    ret_0 = var_38;
    ret_1 = var_40;
    ret_2 = var_41;
    ret_3 = var_42;
    ret_4 = var_43;
    return;
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/geometry/raycast.py:594
static void ray_intersect_plane_0(
    wp::vec_t<3, wp::float32> var_ray_origin,
    wp::vec_t<3, wp::float32> var_ray_direction,
    wp::vec_t<3, wp::float32> var_size,
    bool var_enable_backface_culling,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    const wp::float32 var_0 = -1.0;
    const wp::float32 var_1 = 0.0;
    wp::vec_t<3, wp::float32> var_2;
    const wp::int32 var_3 = 2;
    wp::float32 var_4;
    wp::float32 var_5;
    const wp::float32 var_6 = 1e-06;
    bool var_7;
    bool var_8;
    const wp::int32 var_9 = 2;
    wp::float32 var_10;
    const wp::float32 var_11 = 0.0;
    bool var_12;
    const wp::int32 var_13 = 2;
    wp::float32 var_14;
    wp::float32 var_15;
    const wp::int32 var_16 = 2;
    wp::float32 var_17;
    wp::float32 var_18;
    const wp::float32 var_19 = 0.0;
    bool var_20;
    const wp::int32 var_21 = 0;
    wp::float32 var_22;
    const wp::int32 var_23 = 0;
    wp::float32 var_24;
    wp::float32 var_25;
    wp::float32 var_26;
    const wp::int32 var_27 = 1;
    wp::float32 var_28;
    const wp::int32 var_29 = 1;
    wp::float32 var_30;
    wp::float32 var_31;
    wp::float32 var_32;
    const wp::int32 var_33 = 0;
    wp::float32 var_34;
    const wp::float32 var_35 = 0.5;
    wp::float32 var_36;
    const wp::int32 var_37 = 1;
    wp::float32 var_38;
    const wp::float32 var_39 = 0.5;
    wp::float32 var_40;
    bool var_41;
    const wp::float32 var_42 = 0.0;
    bool var_43;
    wp::float32 var_44;
    bool var_45;
    bool var_46;
    const wp::float32 var_47 = 0.0;
    bool var_48;
    wp::float32 var_49;
    bool var_50;
    wp::float32 var_51;
    const wp::float32 var_52 = 0.0;
    const wp::float32 var_53 = 0.0;
    const wp::float32 var_54 = 1.0;
    wp::vec_t<3, wp::float32> var_55;
    //---------
    // forward
    // def ray_intersect_plane(                                                               <L 595>
    // t_hit = -1.0                                                                           <L 617>
    // normal = wp.vec3(0.0)                                                                  <L 618>
    var_2 = wp::vec_t<3, wp::float32>(var_1);
    // if wp.abs(ray_direction[2]) < PARALLEL_TOL:                                            <L 621>
    var_4 = wp::extract(var_ray_direction, var_3);
    var_5 = wp::abs(var_4);
    var_7 = (var_5 < var_6);
    if (var_7) {
        // return t_hit, normal                                                               <L 622>
        ret_0 = var_0;
        ret_1 = var_2;
        return;
    }
    // if enable_backface_culling and ray_direction[2] > 0.0:                                 <L 625>
    var_8 = var_enable_backface_culling;
    if (var_8) {
        var_10 = wp::extract(var_ray_direction, var_9);
        var_12 = (var_10 > var_11);
        var_8 = var_8 && var_12;
    }
    if (var_8) {
        // return t_hit, normal                                                               <L 626>
        ret_0 = var_0;
        ret_1 = var_2;
        return;
    }
    // t = -ray_origin[2] / ray_direction[2]                                                  <L 628>
    var_14 = wp::extract(var_ray_origin, var_13);
    var_15 = wp::neg(var_14);
    var_17 = wp::extract(var_ray_direction, var_16);
    var_18 = wp::div(var_15, var_17);
    // if t < 0.0:                                                                            <L 629>
    var_20 = (var_18 < var_19);
    if (var_20) {
        // return t_hit, normal                                                               <L 630>
        ret_0 = var_0;
        ret_1 = var_2;
        return;
    }
    // hit_x = ray_origin[0] + t * ray_direction[0]                                           <L 632>
    var_22 = wp::extract(var_ray_origin, var_21);
    var_24 = wp::extract(var_ray_direction, var_23);
    var_25 = wp::mul(var_18, var_24);
    var_26 = wp::add(var_22, var_25);
    // hit_y = ray_origin[1] + t * ray_direction[1]                                           <L 633>
    var_28 = wp::extract(var_ray_origin, var_27);
    var_30 = wp::extract(var_ray_direction, var_29);
    var_31 = wp::mul(var_18, var_30);
    var_32 = wp::add(var_28, var_31);
    // half_w = size[0] * 0.5                                                                 <L 635>
    var_34 = wp::extract(var_size, var_33);
    var_36 = wp::mul(var_34, var_35);
    // half_l = size[1] * 0.5                                                                 <L 636>
    var_38 = wp::extract(var_size, var_37);
    var_40 = wp::mul(var_38, var_39);
    // if half_w > 0.0 and wp.abs(hit_x) > half_w:                                            <L 638>
    var_43 = (var_36 > var_42);
    var_41 = var_43;
    if (var_41) {
        var_44 = wp::abs(var_26);
        var_45 = (var_44 > var_36);
        var_41 = var_41 && var_45;
    }
    if (var_41) {
        // return t_hit, normal                                                               <L 639>
        ret_0 = var_0;
        ret_1 = var_2;
        return;
    }
    // if half_l > 0.0 and wp.abs(hit_y) > half_l:                                            <L 640>
    var_48 = (var_40 > var_47);
    var_46 = var_48;
    if (var_46) {
        var_49 = wp::abs(var_32);
        var_50 = (var_49 > var_40);
        var_46 = var_46 && var_50;
    }
    if (var_46) {
        // return t_hit, normal                                                               <L 641>
        ret_0 = var_0;
        ret_1 = var_2;
        return;
    }
    // t_hit = t                                                                              <L 643>
    var_51 = wp::copy(var_18);
    // normal = wp.vec3(0.0, 0.0, 1.0)                                                        <L 644>
    var_55 = wp::vec_t<3, wp::float32>(var_52, var_53, var_54);
    // return t_hit, normal                                                                   <L 646>
    ret_0 = var_51;
    ret_1 = var_55;
    return;
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/geometry/raycast.py:79
static void ray_intersect_sphere_0(
    wp::vec_t<3, wp::float32> var_ray_origin,
    wp::vec_t<3, wp::float32> var_ray_direction,
    wp::float32 var_r,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    const wp::float32 var_0 = -1.0;
    const wp::float32 var_1 = 0.0;
    wp::vec_t<3, wp::float32> var_2;
    wp::float32 var_3;
    const wp::float32 var_4 = 1e-15;
    bool var_5;
    const wp::float32 var_6 = 1.0;
    wp::float32 var_7;
    wp::float32 var_8;
    wp::vec_t<3, wp::float32> var_9;
    wp::vec_t<3, wp::float32> var_10;
    wp::float32 var_11;
    wp::float32 var_12;
    wp::float32 var_13;
    wp::float32 var_14;
    wp::float32 var_15;
    wp::float32 var_16;
    const wp::float32 var_17 = 0.0;
    bool var_18;
    wp::float32 var_19;
    wp::float32 var_20;
    wp::float32 var_21;
    const wp::float32 var_22 = 0.0;
    bool var_23;
    wp::float32 var_24;
    wp::float32 var_25;
    wp::float32 var_26;
    const wp::float32 var_27 = 0.0;
    bool var_28;
    wp::float32 var_29;
    wp::float32 var_30;
    wp::float32 var_31;
    wp::float32 var_32;
    const wp::float32 var_33 = 0.0;
    bool var_34;
    wp::vec_t<3, wp::float32> var_35;
    wp::vec_t<3, wp::float32> var_36;
    wp::vec_t<3, wp::float32> var_37;
    wp::vec_t<3, wp::float32> var_38;
    //---------
    // forward
    // def ray_intersect_sphere(ray_origin: wp.vec3, ray_direction: wp.vec3, r: float) -> tuple[float, wp.vec3]:       <L 80>
    // t_hit = -1.0                                                                           <L 91>
    // normal = wp.vec3(0.0)                                                                  <L 92>
    var_2 = wp::vec_t<3, wp::float32>(var_1);
    // d_len_sq = wp.dot(ray_direction, ray_direction)                                        <L 94>
    var_3 = wp::dot(var_ray_direction, var_ray_direction);
    // if d_len_sq < MINVAL:                                                                  <L 95>
    var_5 = (var_3 < var_4);
    if (var_5) {
        // return t_hit, normal                                                               <L 96>
        ret_0 = var_0;
        ret_1 = var_2;
        return;
    }
    // inv_d_len = 1.0 / wp.sqrt(d_len_sq)                                                    <L 98>
    var_7 = wp::sqrt(var_3);
    var_8 = wp::div(var_6, var_7);
    // d_local_norm = ray_direction * inv_d_len                                               <L 99>
    var_9 = wp::mul(var_ray_direction, var_8);
    // oc = ray_origin                                                                        <L 101>
    var_10 = wp::copy(var_ray_origin);
    // b = wp.dot(oc, d_local_norm)                                                           <L 102>
    var_11 = wp::dot(var_10, var_9);
    // c = wp.dot(oc, oc) - r * r                                                             <L 103>
    var_12 = wp::dot(var_10, var_10);
    var_13 = wp::mul(var_r, var_r);
    var_14 = wp::sub(var_12, var_13);
    // delta = b * b - c                                                                      <L 105>
    var_15 = wp::mul(var_11, var_11);
    var_16 = wp::sub(var_15, var_14);
    // if delta >= 0.0:                                                                       <L 106>
    var_18 = (var_16 >= var_17);
    if (var_18) {
        // sqrt_delta = wp.sqrt(delta)                                                        <L 107>
        var_19 = wp::sqrt(var_16);
        // t1 = -b - sqrt_delta                                                               <L 108>
        var_20 = wp::neg(var_11);
        var_21 = wp::sub(var_20, var_19);
        // if t1 >= 0.0:                                                                      <L 109>
        var_23 = (var_21 >= var_22);
        if (var_23) {
            // t_hit = t1 * inv_d_len                                                         <L 110>
            var_24 = wp::mul(var_21, var_8);
        }
        if (!var_23) {
            // t2 = -b + sqrt_delta                                                           <L 112>
            var_25 = wp::neg(var_11);
            var_26 = wp::add(var_25, var_19);
            // if t2 >= 0.0:                                                                  <L 113>
            var_28 = (var_26 >= var_27);
            if (var_28) {
                // t_hit = t2 * inv_d_len                                                     <L 114>
                var_29 = wp::mul(var_26, var_8);
            }
            var_30 = wp::where(var_28, var_29, var_0);
        }
        var_31 = wp::where(var_23, var_24, var_30);
    }
    var_32 = wp::where(var_18, var_31, var_0);
    // if t_hit >= 0.0:                                                                       <L 116>
    var_34 = (var_32 >= var_33);
    if (var_34) {
        // normal = wp.normalize(ray_origin + t_hit * ray_direction)                          <L 117>
        var_35 = wp::mul(var_32, var_ray_direction);
        var_36 = wp::add(var_ray_origin, var_35);
        var_37 = wp::normalize(var_36);
    }
    var_38 = wp::where(var_34, var_37, var_2);
    // return t_hit, normal                                                                   <L 119>
    ret_0 = var_32;
    ret_1 = var_38;
    return;
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/geometry/raycast.py:226
static void ray_intersect_box_0(
    wp::vec_t<3, wp::float32> var_ray_origin,
    wp::vec_t<3, wp::float32> var_ray_direction,
    wp::vec_t<3, wp::float32> var_size,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    const wp::float32 var_0 = -1.0;
    const wp::float32 var_1 = 0.0;
    wp::vec_t<3, wp::float32> var_2;
    const wp::float32 var_3 = -10000000000.0;
    const wp::float32 var_4 = 10000000000.0;
    const wp::int32 var_5 = 1;
    const wp::int32 var_6 = 0;
    wp::float32 var_7;
    wp::float32 var_8;
    const wp::float32 var_9 = 1e-15;
    bool var_10;
    bool var_11;
    wp::float32 var_12;
    wp::float32 var_13;
    wp::float32 var_14;
    bool var_15;
    wp::float32 var_16;
    wp::float32 var_17;
    bool var_18;
    const wp::int32 var_19 = 0;
    wp::int32 var_20;
    const wp::float32 var_21 = 1.0;
    wp::float32 var_22;
    wp::float32 var_23;
    wp::float32 var_24;
    wp::float32 var_25;
    wp::float32 var_26;
    wp::float32 var_27;
    wp::float32 var_28;
    wp::float32 var_29;
    wp::float32 var_30;
    wp::float32 var_31;
    wp::float32 var_32;
    bool var_33;
    wp::float32 var_34;
    wp::float32 var_35;
    wp::float32 var_36;
    wp::float32 var_37;
    wp::float32 var_38;
    wp::float32 var_39;
    wp::float32 var_40;
    wp::float32 var_41;
    wp::float32 var_42;
    wp::int32 var_43;
    const wp::int32 var_44 = 1;
    wp::float32 var_45;
    wp::float32 var_46;
    bool var_47;
    bool var_48;
    wp::float32 var_49;
    wp::float32 var_50;
    wp::float32 var_51;
    bool var_52;
    wp::float32 var_53;
    wp::float32 var_54;
    bool var_55;
    const wp::int32 var_56 = 0;
    wp::int32 var_57;
    const wp::float32 var_58 = 1.0;
    wp::float32 var_59;
    wp::float32 var_60;
    wp::float32 var_61;
    wp::float32 var_62;
    wp::float32 var_63;
    wp::float32 var_64;
    wp::float32 var_65;
    wp::float32 var_66;
    wp::float32 var_67;
    wp::float32 var_68;
    wp::float32 var_69;
    bool var_70;
    wp::float32 var_71;
    wp::float32 var_72;
    wp::float32 var_73;
    wp::float32 var_74;
    wp::float32 var_75;
    wp::float32 var_76;
    wp::float32 var_77;
    wp::float32 var_78;
    wp::float32 var_79;
    wp::float32 var_80;
    wp::int32 var_81;
    wp::float32 var_82;
    wp::float32 var_83;
    wp::float32 var_84;
    wp::float32 var_85;
    const wp::int32 var_86 = 2;
    wp::float32 var_87;
    wp::float32 var_88;
    bool var_89;
    bool var_90;
    wp::float32 var_91;
    wp::float32 var_92;
    wp::float32 var_93;
    bool var_94;
    wp::float32 var_95;
    wp::float32 var_96;
    bool var_97;
    const wp::int32 var_98 = 0;
    wp::int32 var_99;
    const wp::float32 var_100 = 1.0;
    wp::float32 var_101;
    wp::float32 var_102;
    wp::float32 var_103;
    wp::float32 var_104;
    wp::float32 var_105;
    wp::float32 var_106;
    wp::float32 var_107;
    wp::float32 var_108;
    wp::float32 var_109;
    wp::float32 var_110;
    wp::float32 var_111;
    bool var_112;
    wp::float32 var_113;
    wp::float32 var_114;
    wp::float32 var_115;
    wp::float32 var_116;
    wp::float32 var_117;
    wp::float32 var_118;
    wp::float32 var_119;
    wp::float32 var_120;
    wp::float32 var_121;
    wp::float32 var_122;
    wp::int32 var_123;
    wp::float32 var_124;
    wp::float32 var_125;
    wp::float32 var_126;
    wp::float32 var_127;
    bool var_128;
    const wp::int32 var_129 = 1;
    bool var_130;
    bool var_131;
    const wp::float32 var_132 = 0.0;
    bool var_133;
    const wp::float32 var_134 = 0.0;
    bool var_135;
    wp::float32 var_136;
    wp::float32 var_137;
    wp::float32 var_138;
    wp::float32 var_139;
    const wp::float32 var_140 = 0.0;
    bool var_141;
    const wp::float32 var_142 = 0.0;
    wp::vec_t<3, wp::float32> var_143;
    const wp::int32 var_144 = 0;
    wp::float32 var_145;
    wp::float32 var_146;
    const wp::float32 var_147 = 1e-06;
    bool var_148;
    const wp::int32 var_149 = -1;
    wp::float32 var_150;
    wp::float32 var_151;
    wp::float32 var_152;
    wp::float32 var_153;
    wp::float32 var_154;
    wp::float32 var_155;
    wp::float32 var_156;
    const wp::float32 var_157 = 0.0;
    bool var_158;
    const wp::mat_t<3, 2, wp::int32> var_159 = wp::initializer_array<6,wp::int32>{1, 2, 0, 2, 0, 1};
    const wp::int32 var_160 = 0;
    wp::int32 var_161;
    const wp::int32 var_162 = 1;
    wp::int32 var_163;
    wp::float32 var_164;
    wp::float32 var_165;
    wp::float32 var_166;
    wp::float32 var_167;
    wp::float32 var_168;
    wp::float32 var_169;
    wp::float32 var_170;
    wp::float32 var_171;
    bool var_172;
    wp::float32 var_173;
    wp::float32 var_174;
    bool var_175;
    wp::float32 var_176;
    wp::float32 var_177;
    bool var_178;
    wp::float32 var_179;
    wp::float32 var_180;
    bool var_181;
    const wp::int32 var_182 = 0;
    bool var_183;
    const wp::float32 var_184 = -1.0;
    const wp::float32 var_185 = 1.0;
    wp::float32 var_186;
    const wp::int32 var_187 = 1;
    wp::float32 var_188;
    wp::float32 var_189;
    wp::float32 var_190;
    wp::float32 var_191;
    wp::float32 var_192;
    wp::float32 var_193;
    wp::float32 var_194;
    const wp::float32 var_195 = 0.0;
    bool var_196;
    const wp::int32 var_197 = 0;
    wp::int32 var_198;
    const wp::int32 var_199 = 1;
    wp::int32 var_200;
    wp::float32 var_201;
    wp::float32 var_202;
    wp::float32 var_203;
    wp::float32 var_204;
    wp::float32 var_205;
    wp::float32 var_206;
    wp::float32 var_207;
    wp::float32 var_208;
    bool var_209;
    wp::float32 var_210;
    wp::float32 var_211;
    bool var_212;
    wp::float32 var_213;
    wp::float32 var_214;
    bool var_215;
    wp::float32 var_216;
    wp::float32 var_217;
    bool var_218;
    const wp::int32 var_219 = 0;
    bool var_220;
    const wp::float32 var_221 = -1.0;
    const wp::float32 var_222 = 1.0;
    wp::float32 var_223;
    wp::int32 var_224;
    wp::int32 var_225;
    wp::float32 var_226;
    wp::float32 var_227;
    const wp::int32 var_228 = 1;
    wp::float32 var_229;
    wp::float32 var_230;
    bool var_231;
    const wp::int32 var_232 = -1;
    wp::float32 var_233;
    wp::float32 var_234;
    wp::float32 var_235;
    wp::float32 var_236;
    wp::float32 var_237;
    wp::float32 var_238;
    wp::float32 var_239;
    const wp::float32 var_240 = 0.0;
    bool var_241;
    const wp::int32 var_242 = 0;
    wp::int32 var_243;
    const wp::int32 var_244 = 1;
    wp::int32 var_245;
    wp::float32 var_246;
    wp::float32 var_247;
    wp::float32 var_248;
    wp::float32 var_249;
    wp::float32 var_250;
    wp::float32 var_251;
    wp::float32 var_252;
    wp::float32 var_253;
    bool var_254;
    wp::float32 var_255;
    wp::float32 var_256;
    bool var_257;
    wp::float32 var_258;
    wp::float32 var_259;
    bool var_260;
    wp::float32 var_261;
    wp::float32 var_262;
    bool var_263;
    const wp::int32 var_264 = 0;
    bool var_265;
    const wp::float32 var_266 = -1.0;
    const wp::float32 var_267 = 1.0;
    wp::float32 var_268;
    wp::int32 var_269;
    wp::int32 var_270;
    wp::float32 var_271;
    wp::float32 var_272;
    const wp::int32 var_273 = 1;
    wp::float32 var_274;
    wp::float32 var_275;
    wp::float32 var_276;
    wp::float32 var_277;
    wp::float32 var_278;
    wp::float32 var_279;
    wp::float32 var_280;
    const wp::float32 var_281 = 0.0;
    bool var_282;
    const wp::int32 var_283 = 0;
    wp::int32 var_284;
    const wp::int32 var_285 = 1;
    wp::int32 var_286;
    wp::float32 var_287;
    wp::float32 var_288;
    wp::float32 var_289;
    wp::float32 var_290;
    wp::float32 var_291;
    wp::float32 var_292;
    wp::float32 var_293;
    wp::float32 var_294;
    bool var_295;
    wp::float32 var_296;
    wp::float32 var_297;
    bool var_298;
    wp::float32 var_299;
    wp::float32 var_300;
    bool var_301;
    wp::float32 var_302;
    wp::float32 var_303;
    bool var_304;
    const wp::int32 var_305 = 0;
    bool var_306;
    const wp::float32 var_307 = -1.0;
    const wp::float32 var_308 = 1.0;
    wp::float32 var_309;
    wp::int32 var_310;
    wp::int32 var_311;
    wp::float32 var_312;
    wp::float32 var_313;
    wp::int32 var_314;
    wp::float32 var_315;
    wp::int32 var_316;
    wp::int32 var_317;
    wp::float32 var_318;
    wp::float32 var_319;
    const wp::int32 var_320 = 2;
    wp::float32 var_321;
    wp::float32 var_322;
    bool var_323;
    const wp::int32 var_324 = -1;
    wp::float32 var_325;
    wp::float32 var_326;
    wp::float32 var_327;
    wp::float32 var_328;
    wp::float32 var_329;
    wp::float32 var_330;
    wp::float32 var_331;
    const wp::float32 var_332 = 0.0;
    bool var_333;
    const wp::int32 var_334 = 0;
    wp::int32 var_335;
    const wp::int32 var_336 = 1;
    wp::int32 var_337;
    wp::float32 var_338;
    wp::float32 var_339;
    wp::float32 var_340;
    wp::float32 var_341;
    wp::float32 var_342;
    wp::float32 var_343;
    wp::float32 var_344;
    wp::float32 var_345;
    bool var_346;
    wp::float32 var_347;
    wp::float32 var_348;
    bool var_349;
    wp::float32 var_350;
    wp::float32 var_351;
    bool var_352;
    wp::float32 var_353;
    wp::float32 var_354;
    bool var_355;
    const wp::int32 var_356 = 0;
    bool var_357;
    const wp::float32 var_358 = -1.0;
    const wp::float32 var_359 = 1.0;
    wp::float32 var_360;
    wp::int32 var_361;
    wp::int32 var_362;
    wp::float32 var_363;
    wp::float32 var_364;
    const wp::int32 var_365 = 1;
    wp::float32 var_366;
    wp::float32 var_367;
    wp::float32 var_368;
    wp::float32 var_369;
    wp::float32 var_370;
    wp::float32 var_371;
    wp::float32 var_372;
    const wp::float32 var_373 = 0.0;
    bool var_374;
    const wp::int32 var_375 = 0;
    wp::int32 var_376;
    const wp::int32 var_377 = 1;
    wp::int32 var_378;
    wp::float32 var_379;
    wp::float32 var_380;
    wp::float32 var_381;
    wp::float32 var_382;
    wp::float32 var_383;
    wp::float32 var_384;
    wp::float32 var_385;
    wp::float32 var_386;
    bool var_387;
    wp::float32 var_388;
    wp::float32 var_389;
    bool var_390;
    wp::float32 var_391;
    wp::float32 var_392;
    bool var_393;
    wp::float32 var_394;
    wp::float32 var_395;
    bool var_396;
    const wp::int32 var_397 = 0;
    bool var_398;
    const wp::float32 var_399 = -1.0;
    const wp::float32 var_400 = 1.0;
    wp::float32 var_401;
    wp::int32 var_402;
    wp::int32 var_403;
    wp::float32 var_404;
    wp::float32 var_405;
    wp::int32 var_406;
    wp::float32 var_407;
    wp::int32 var_408;
    wp::int32 var_409;
    wp::float32 var_410;
    wp::float32 var_411;
    wp::vec_t<3, wp::float32> var_412;
    wp::vec_t<3, wp::float32> var_413;
    wp::int32 var_414;
    //---------
    // forward
    // def ray_intersect_box(ray_origin: wp.vec3, ray_direction: wp.vec3, size: wp.vec3) -> tuple[float, wp.vec3]:       <L 227>
    // t_hit = -1.0                                                                           <L 238>
    // normal = wp.vec3(0.0)                                                                  <L 239>
    var_2 = wp::vec_t<3, wp::float32>(var_1);
    // t_near = -1.0e10                                                                       <L 240>
    // t_far = 1.0e10                                                                         <L 241>
    // hit = 1                                                                                <L 242>
    // for i in range(3):                                                                     <L 244>
    // if wp.abs(ray_direction[i]) < MINVAL:                                                  <L 245>
    var_7 = wp::extract(var_ray_direction, var_6);
    var_8 = wp::abs(var_7);
    var_10 = (var_8 < var_9);
    if (var_10) {
        // if ray_origin[i] < -size[i] or ray_origin[i] > size[i]:                            <L 246>
        var_12 = wp::extract(var_ray_origin, var_6);
        var_13 = wp::extract(var_size, var_6);
        var_14 = wp::neg(var_13);
        var_15 = (var_12 < var_14);
        var_11 = var_15;
        if (!var_11) {
            var_16 = wp::extract(var_ray_origin, var_6);
            var_17 = wp::extract(var_size, var_6);
            var_18 = (var_16 > var_17);
            var_11 = var_11 || var_18;
        }
        if (var_11) {
            // hit = 0                                                                        <L 247>
        }
        var_20 = wp::where(var_11, var_19, var_5);
    }
    if (!var_10) {
        // inv_d_i = 1.0 / ray_direction[i]                                                   <L 249>
        var_22 = wp::extract(var_ray_direction, var_6);
        var_23 = wp::div(var_21, var_22);
        // t1 = (-size[i] - ray_origin[i]) * inv_d_i                                          <L 250>
        var_24 = wp::extract(var_size, var_6);
        var_25 = wp::neg(var_24);
        var_26 = wp::extract(var_ray_origin, var_6);
        var_27 = wp::sub(var_25, var_26);
        var_28 = wp::mul(var_27, var_23);
        // t2 = (size[i] - ray_origin[i]) * inv_d_i                                           <L 251>
        var_29 = wp::extract(var_size, var_6);
        var_30 = wp::extract(var_ray_origin, var_6);
        var_31 = wp::sub(var_29, var_30);
        var_32 = wp::mul(var_31, var_23);
        // if t1 > t2:                                                                        <L 253>
        var_33 = (var_28 > var_32);
        if (var_33) {
            // temp = t1                                                                      <L 254>
            var_34 = wp::copy(var_28);
            // t1 = t2                                                                        <L 255>
            var_35 = wp::copy(var_32);
            // t2 = temp                                                                      <L 256>
            var_36 = wp::copy(var_34);
        }
        var_37 = wp::where(var_33, var_35, var_28);
        var_38 = wp::where(var_33, var_36, var_32);
        // t_near = wp.max(t_near, t1)                                                        <L 258>
        var_39 = wp::max(var_3, var_37);
        // t_far = wp.min(t_far, t2)                                                          <L 259>
        var_40 = wp::min(var_4, var_38);
    }
    var_41 = wp::where(var_10, var_3, var_39);
    var_42 = wp::where(var_10, var_4, var_40);
    var_43 = wp::where(var_10, var_20, var_5);
    // if wp.abs(ray_direction[i]) < MINVAL:                                                  <L 245>
    var_45 = wp::extract(var_ray_direction, var_44);
    var_46 = wp::abs(var_45);
    var_47 = (var_46 < var_9);
    if (var_47) {
        // if ray_origin[i] < -size[i] or ray_origin[i] > size[i]:                            <L 246>
        var_49 = wp::extract(var_ray_origin, var_44);
        var_50 = wp::extract(var_size, var_44);
        var_51 = wp::neg(var_50);
        var_52 = (var_49 < var_51);
        var_48 = var_52;
        if (!var_48) {
            var_53 = wp::extract(var_ray_origin, var_44);
            var_54 = wp::extract(var_size, var_44);
            var_55 = (var_53 > var_54);
            var_48 = var_48 || var_55;
        }
        if (var_48) {
            // hit = 0                                                                        <L 247>
        }
        var_57 = wp::where(var_48, var_56, var_43);
    }
    if (!var_47) {
        // inv_d_i = 1.0 / ray_direction[i]                                                   <L 249>
        var_59 = wp::extract(var_ray_direction, var_44);
        var_60 = wp::div(var_58, var_59);
        // t1 = (-size[i] - ray_origin[i]) * inv_d_i                                          <L 250>
        var_61 = wp::extract(var_size, var_44);
        var_62 = wp::neg(var_61);
        var_63 = wp::extract(var_ray_origin, var_44);
        var_64 = wp::sub(var_62, var_63);
        var_65 = wp::mul(var_64, var_60);
        // t2 = (size[i] - ray_origin[i]) * inv_d_i                                           <L 251>
        var_66 = wp::extract(var_size, var_44);
        var_67 = wp::extract(var_ray_origin, var_44);
        var_68 = wp::sub(var_66, var_67);
        var_69 = wp::mul(var_68, var_60);
        // if t1 > t2:                                                                        <L 253>
        var_70 = (var_65 > var_69);
        if (var_70) {
            // temp = t1                                                                      <L 254>
            var_71 = wp::copy(var_65);
            // t1 = t2                                                                        <L 255>
            var_72 = wp::copy(var_69);
            // t2 = temp                                                                      <L 256>
            var_73 = wp::copy(var_71);
        }
        var_74 = wp::where(var_70, var_72, var_65);
        var_75 = wp::where(var_70, var_73, var_69);
        var_76 = wp::where(var_70, var_71, var_34);
        // t_near = wp.max(t_near, t1)                                                        <L 258>
        var_77 = wp::max(var_41, var_74);
        // t_far = wp.min(t_far, t2)                                                          <L 259>
        var_78 = wp::min(var_42, var_75);
    }
    var_79 = wp::where(var_47, var_41, var_77);
    var_80 = wp::where(var_47, var_42, var_78);
    var_81 = wp::where(var_47, var_57, var_43);
    var_82 = wp::where(var_47, var_23, var_60);
    var_83 = wp::where(var_47, var_37, var_74);
    var_84 = wp::where(var_47, var_38, var_75);
    var_85 = wp::where(var_47, var_34, var_76);
    // if wp.abs(ray_direction[i]) < MINVAL:                                                  <L 245>
    var_87 = wp::extract(var_ray_direction, var_86);
    var_88 = wp::abs(var_87);
    var_89 = (var_88 < var_9);
    if (var_89) {
        // if ray_origin[i] < -size[i] or ray_origin[i] > size[i]:                            <L 246>
        var_91 = wp::extract(var_ray_origin, var_86);
        var_92 = wp::extract(var_size, var_86);
        var_93 = wp::neg(var_92);
        var_94 = (var_91 < var_93);
        var_90 = var_94;
        if (!var_90) {
            var_95 = wp::extract(var_ray_origin, var_86);
            var_96 = wp::extract(var_size, var_86);
            var_97 = (var_95 > var_96);
            var_90 = var_90 || var_97;
        }
        if (var_90) {
            // hit = 0                                                                        <L 247>
        }
        var_99 = wp::where(var_90, var_98, var_81);
    }
    if (!var_89) {
        // inv_d_i = 1.0 / ray_direction[i]                                                   <L 249>
        var_101 = wp::extract(var_ray_direction, var_86);
        var_102 = wp::div(var_100, var_101);
        // t1 = (-size[i] - ray_origin[i]) * inv_d_i                                          <L 250>
        var_103 = wp::extract(var_size, var_86);
        var_104 = wp::neg(var_103);
        var_105 = wp::extract(var_ray_origin, var_86);
        var_106 = wp::sub(var_104, var_105);
        var_107 = wp::mul(var_106, var_102);
        // t2 = (size[i] - ray_origin[i]) * inv_d_i                                           <L 251>
        var_108 = wp::extract(var_size, var_86);
        var_109 = wp::extract(var_ray_origin, var_86);
        var_110 = wp::sub(var_108, var_109);
        var_111 = wp::mul(var_110, var_102);
        // if t1 > t2:                                                                        <L 253>
        var_112 = (var_107 > var_111);
        if (var_112) {
            // temp = t1                                                                      <L 254>
            var_113 = wp::copy(var_107);
            // t1 = t2                                                                        <L 255>
            var_114 = wp::copy(var_111);
            // t2 = temp                                                                      <L 256>
            var_115 = wp::copy(var_113);
        }
        var_116 = wp::where(var_112, var_114, var_107);
        var_117 = wp::where(var_112, var_115, var_111);
        var_118 = wp::where(var_112, var_113, var_85);
        // t_near = wp.max(t_near, t1)                                                        <L 258>
        var_119 = wp::max(var_79, var_116);
        // t_far = wp.min(t_far, t2)                                                          <L 259>
        var_120 = wp::min(var_80, var_117);
    }
    var_121 = wp::where(var_89, var_79, var_119);
    var_122 = wp::where(var_89, var_80, var_120);
    var_123 = wp::where(var_89, var_99, var_81);
    var_124 = wp::where(var_89, var_82, var_102);
    var_125 = wp::where(var_89, var_83, var_116);
    var_126 = wp::where(var_89, var_84, var_117);
    var_127 = wp::where(var_89, var_85, var_118);
    // if hit == 1 and t_near <= t_far and t_far >= 0.0:                                      <L 261>
    var_130 = (var_123 == var_129);
    var_128 = var_130;
    if (var_128) {
        var_131 = (var_121 <= var_122);
        var_128 = var_128 && var_131;
    }
    if (var_128) {
        var_133 = (var_122 >= var_132);
        var_128 = var_128 && var_133;
    }
    if (var_128) {
        // if t_near >= 0.0:                                                                  <L 262>
        var_135 = (var_121 >= var_134);
        if (var_135) {
            // t_hit = t_near                                                                 <L 263>
            var_136 = wp::copy(var_121);
        }
        if (!var_135) {
            // t_hit = t_far                                                                  <L 265>
            var_137 = wp::copy(var_122);
        }
        var_138 = wp::where(var_135, var_136, var_137);
    }
    var_139 = wp::where(var_128, var_138, var_0);
    // if t_hit >= 0.0:                                                                       <L 267>
    var_141 = (var_139 >= var_140);
    if (var_141) {
        // normal_local = wp.vec3(0.0)                                                        <L 269>
        var_143 = wp::vec_t<3, wp::float32>(var_142);
        // for i in range(3):                                                                 <L 270>
        // if wp.abs(ray_direction[i]) > EPSILON:                                             <L 271>
        var_145 = wp::extract(var_ray_direction, var_144);
        var_146 = wp::abs(var_145);
        var_148 = (var_146 > var_147);
        if (var_148) {
            // for side in range(-1, 2, 2):                                                   <L 272>
            // sol = (float(side) * size[i] - ray_origin[i]) / ray_direction[i]               <L 273>
            var_150 = wp::float(var_149);
            var_151 = wp::extract(var_size, var_144);
            var_152 = wp::mul(var_150, var_151);
            var_153 = wp::extract(var_ray_origin, var_144);
            var_154 = wp::sub(var_152, var_153);
            var_155 = wp::extract(var_ray_direction, var_144);
            var_156 = wp::div(var_154, var_155);
            // if sol >= 0.0:                                                                 <L 274>
            var_158 = (var_156 >= var_157);
            if (var_158) {
                // id0 = _IFACE[i][0]                                                         <L 275>
                var_161 = wp::extract(var_159, var_144, var_160);
                // id1 = _IFACE[i][1]                                                         <L 276>
                var_163 = wp::extract(var_159, var_144, var_162);
                // p0 = ray_origin[id0] + sol * ray_direction[id0]                            <L 277>
                var_164 = wp::extract(var_ray_origin, var_161);
                var_165 = wp::extract(var_ray_direction, var_161);
                var_166 = wp::mul(var_156, var_165);
                var_167 = wp::add(var_164, var_166);
                // p1 = ray_origin[id1] + sol * ray_direction[id1]                            <L 278>
                var_168 = wp::extract(var_ray_origin, var_163);
                var_169 = wp::extract(var_ray_direction, var_163);
                var_170 = wp::mul(var_156, var_169);
                var_171 = wp::add(var_168, var_170);
                // if wp.abs(p0) <= size[id0] and wp.abs(p1) <= size[id1]:                    <L 279>
                var_173 = wp::abs(var_167);
                var_174 = wp::extract(var_size, var_161);
                var_175 = (var_173 <= var_174);
                var_172 = var_175;
                if (var_172) {
                    var_176 = wp::abs(var_171);
                    var_177 = wp::extract(var_size, var_163);
                    var_178 = (var_176 <= var_177);
                    var_172 = var_172 && var_178;
                }
                if (var_172) {
                    // if wp.abs(sol - t_hit) < EPSILON:                                      <L 280>
                    var_179 = wp::sub(var_156, var_139);
                    var_180 = wp::abs(var_179);
                    var_181 = (var_180 < var_147);
                    if (var_181) {
                        // normal_local[i] = -1.0 if side < 0 else 1.0                        <L 281>
                        var_183 = (var_149 < var_182);
                        if (var_183) {
                        }
                        if (!var_183) {
                        }
                        var_186 = wp::where(var_183, var_184, var_185);
                        wp::assign_inplace(var_143, var_144, var_186);
                    }
                }
            }
            // sol = (float(side) * size[i] - ray_origin[i]) / ray_direction[i]               <L 273>
            var_188 = wp::float(var_187);
            var_189 = wp::extract(var_size, var_144);
            var_190 = wp::mul(var_188, var_189);
            var_191 = wp::extract(var_ray_origin, var_144);
            var_192 = wp::sub(var_190, var_191);
            var_193 = wp::extract(var_ray_direction, var_144);
            var_194 = wp::div(var_192, var_193);
            // if sol >= 0.0:                                                                 <L 274>
            var_196 = (var_194 >= var_195);
            if (var_196) {
                // id0 = _IFACE[i][0]                                                         <L 275>
                var_198 = wp::extract(var_159, var_144, var_197);
                // id1 = _IFACE[i][1]                                                         <L 276>
                var_200 = wp::extract(var_159, var_144, var_199);
                // p0 = ray_origin[id0] + sol * ray_direction[id0]                            <L 277>
                var_201 = wp::extract(var_ray_origin, var_198);
                var_202 = wp::extract(var_ray_direction, var_198);
                var_203 = wp::mul(var_194, var_202);
                var_204 = wp::add(var_201, var_203);
                // p1 = ray_origin[id1] + sol * ray_direction[id1]                            <L 278>
                var_205 = wp::extract(var_ray_origin, var_200);
                var_206 = wp::extract(var_ray_direction, var_200);
                var_207 = wp::mul(var_194, var_206);
                var_208 = wp::add(var_205, var_207);
                // if wp.abs(p0) <= size[id0] and wp.abs(p1) <= size[id1]:                    <L 279>
                var_210 = wp::abs(var_204);
                var_211 = wp::extract(var_size, var_198);
                var_212 = (var_210 <= var_211);
                var_209 = var_212;
                if (var_209) {
                    var_213 = wp::abs(var_208);
                    var_214 = wp::extract(var_size, var_200);
                    var_215 = (var_213 <= var_214);
                    var_209 = var_209 && var_215;
                }
                if (var_209) {
                    // if wp.abs(sol - t_hit) < EPSILON:                                      <L 280>
                    var_216 = wp::sub(var_194, var_139);
                    var_217 = wp::abs(var_216);
                    var_218 = (var_217 < var_147);
                    if (var_218) {
                        // normal_local[i] = -1.0 if side < 0 else 1.0                        <L 281>
                        var_220 = (var_187 < var_219);
                        if (var_220) {
                        }
                        if (!var_220) {
                        }
                        var_223 = wp::where(var_220, var_221, var_222);
                        wp::assign_inplace(var_143, var_144, var_223);
                    }
                }
            }
            var_224 = wp::where(var_196, var_198, var_161);
            var_225 = wp::where(var_196, var_200, var_163);
            var_226 = wp::where(var_196, var_204, var_167);
            var_227 = wp::where(var_196, var_208, var_171);
        }
        // if wp.abs(ray_direction[i]) > EPSILON:                                             <L 271>
        var_229 = wp::extract(var_ray_direction, var_228);
        var_230 = wp::abs(var_229);
        var_231 = (var_230 > var_147);
        if (var_231) {
            // for side in range(-1, 2, 2):                                                   <L 272>
            // sol = (float(side) * size[i] - ray_origin[i]) / ray_direction[i]               <L 273>
            var_233 = wp::float(var_232);
            var_234 = wp::extract(var_size, var_228);
            var_235 = wp::mul(var_233, var_234);
            var_236 = wp::extract(var_ray_origin, var_228);
            var_237 = wp::sub(var_235, var_236);
            var_238 = wp::extract(var_ray_direction, var_228);
            var_239 = wp::div(var_237, var_238);
            // if sol >= 0.0:                                                                 <L 274>
            var_241 = (var_239 >= var_240);
            if (var_241) {
                // id0 = _IFACE[i][0]                                                         <L 275>
                var_243 = wp::extract(var_159, var_228, var_242);
                // id1 = _IFACE[i][1]                                                         <L 276>
                var_245 = wp::extract(var_159, var_228, var_244);
                // p0 = ray_origin[id0] + sol * ray_direction[id0]                            <L 277>
                var_246 = wp::extract(var_ray_origin, var_243);
                var_247 = wp::extract(var_ray_direction, var_243);
                var_248 = wp::mul(var_239, var_247);
                var_249 = wp::add(var_246, var_248);
                // p1 = ray_origin[id1] + sol * ray_direction[id1]                            <L 278>
                var_250 = wp::extract(var_ray_origin, var_245);
                var_251 = wp::extract(var_ray_direction, var_245);
                var_252 = wp::mul(var_239, var_251);
                var_253 = wp::add(var_250, var_252);
                // if wp.abs(p0) <= size[id0] and wp.abs(p1) <= size[id1]:                    <L 279>
                var_255 = wp::abs(var_249);
                var_256 = wp::extract(var_size, var_243);
                var_257 = (var_255 <= var_256);
                var_254 = var_257;
                if (var_254) {
                    var_258 = wp::abs(var_253);
                    var_259 = wp::extract(var_size, var_245);
                    var_260 = (var_258 <= var_259);
                    var_254 = var_254 && var_260;
                }
                if (var_254) {
                    // if wp.abs(sol - t_hit) < EPSILON:                                      <L 280>
                    var_261 = wp::sub(var_239, var_139);
                    var_262 = wp::abs(var_261);
                    var_263 = (var_262 < var_147);
                    if (var_263) {
                        // normal_local[i] = -1.0 if side < 0 else 1.0                        <L 281>
                        var_265 = (var_232 < var_264);
                        if (var_265) {
                        }
                        if (!var_265) {
                        }
                        var_268 = wp::where(var_265, var_266, var_267);
                        wp::assign_inplace(var_143, var_228, var_268);
                    }
                }
            }
            var_269 = wp::where(var_241, var_243, var_224);
            var_270 = wp::where(var_241, var_245, var_225);
            var_271 = wp::where(var_241, var_249, var_226);
            var_272 = wp::where(var_241, var_253, var_227);
            // sol = (float(side) * size[i] - ray_origin[i]) / ray_direction[i]               <L 273>
            var_274 = wp::float(var_273);
            var_275 = wp::extract(var_size, var_228);
            var_276 = wp::mul(var_274, var_275);
            var_277 = wp::extract(var_ray_origin, var_228);
            var_278 = wp::sub(var_276, var_277);
            var_279 = wp::extract(var_ray_direction, var_228);
            var_280 = wp::div(var_278, var_279);
            // if sol >= 0.0:                                                                 <L 274>
            var_282 = (var_280 >= var_281);
            if (var_282) {
                // id0 = _IFACE[i][0]                                                         <L 275>
                var_284 = wp::extract(var_159, var_228, var_283);
                // id1 = _IFACE[i][1]                                                         <L 276>
                var_286 = wp::extract(var_159, var_228, var_285);
                // p0 = ray_origin[id0] + sol * ray_direction[id0]                            <L 277>
                var_287 = wp::extract(var_ray_origin, var_284);
                var_288 = wp::extract(var_ray_direction, var_284);
                var_289 = wp::mul(var_280, var_288);
                var_290 = wp::add(var_287, var_289);
                // p1 = ray_origin[id1] + sol * ray_direction[id1]                            <L 278>
                var_291 = wp::extract(var_ray_origin, var_286);
                var_292 = wp::extract(var_ray_direction, var_286);
                var_293 = wp::mul(var_280, var_292);
                var_294 = wp::add(var_291, var_293);
                // if wp.abs(p0) <= size[id0] and wp.abs(p1) <= size[id1]:                    <L 279>
                var_296 = wp::abs(var_290);
                var_297 = wp::extract(var_size, var_284);
                var_298 = (var_296 <= var_297);
                var_295 = var_298;
                if (var_295) {
                    var_299 = wp::abs(var_294);
                    var_300 = wp::extract(var_size, var_286);
                    var_301 = (var_299 <= var_300);
                    var_295 = var_295 && var_301;
                }
                if (var_295) {
                    // if wp.abs(sol - t_hit) < EPSILON:                                      <L 280>
                    var_302 = wp::sub(var_280, var_139);
                    var_303 = wp::abs(var_302);
                    var_304 = (var_303 < var_147);
                    if (var_304) {
                        // normal_local[i] = -1.0 if side < 0 else 1.0                        <L 281>
                        var_306 = (var_273 < var_305);
                        if (var_306) {
                        }
                        if (!var_306) {
                        }
                        var_309 = wp::where(var_306, var_307, var_308);
                        wp::assign_inplace(var_143, var_228, var_309);
                    }
                }
            }
            var_310 = wp::where(var_282, var_284, var_269);
            var_311 = wp::where(var_282, var_286, var_270);
            var_312 = wp::where(var_282, var_290, var_271);
            var_313 = wp::where(var_282, var_294, var_272);
        }
        var_314 = wp::where(var_231, var_273, var_187);
        var_315 = wp::where(var_231, var_280, var_194);
        var_316 = wp::where(var_231, var_310, var_224);
        var_317 = wp::where(var_231, var_311, var_225);
        var_318 = wp::where(var_231, var_312, var_226);
        var_319 = wp::where(var_231, var_313, var_227);
        // if wp.abs(ray_direction[i]) > EPSILON:                                             <L 271>
        var_321 = wp::extract(var_ray_direction, var_320);
        var_322 = wp::abs(var_321);
        var_323 = (var_322 > var_147);
        if (var_323) {
            // for side in range(-1, 2, 2):                                                   <L 272>
            // sol = (float(side) * size[i] - ray_origin[i]) / ray_direction[i]               <L 273>
            var_325 = wp::float(var_324);
            var_326 = wp::extract(var_size, var_320);
            var_327 = wp::mul(var_325, var_326);
            var_328 = wp::extract(var_ray_origin, var_320);
            var_329 = wp::sub(var_327, var_328);
            var_330 = wp::extract(var_ray_direction, var_320);
            var_331 = wp::div(var_329, var_330);
            // if sol >= 0.0:                                                                 <L 274>
            var_333 = (var_331 >= var_332);
            if (var_333) {
                // id0 = _IFACE[i][0]                                                         <L 275>
                var_335 = wp::extract(var_159, var_320, var_334);
                // id1 = _IFACE[i][1]                                                         <L 276>
                var_337 = wp::extract(var_159, var_320, var_336);
                // p0 = ray_origin[id0] + sol * ray_direction[id0]                            <L 277>
                var_338 = wp::extract(var_ray_origin, var_335);
                var_339 = wp::extract(var_ray_direction, var_335);
                var_340 = wp::mul(var_331, var_339);
                var_341 = wp::add(var_338, var_340);
                // p1 = ray_origin[id1] + sol * ray_direction[id1]                            <L 278>
                var_342 = wp::extract(var_ray_origin, var_337);
                var_343 = wp::extract(var_ray_direction, var_337);
                var_344 = wp::mul(var_331, var_343);
                var_345 = wp::add(var_342, var_344);
                // if wp.abs(p0) <= size[id0] and wp.abs(p1) <= size[id1]:                    <L 279>
                var_347 = wp::abs(var_341);
                var_348 = wp::extract(var_size, var_335);
                var_349 = (var_347 <= var_348);
                var_346 = var_349;
                if (var_346) {
                    var_350 = wp::abs(var_345);
                    var_351 = wp::extract(var_size, var_337);
                    var_352 = (var_350 <= var_351);
                    var_346 = var_346 && var_352;
                }
                if (var_346) {
                    // if wp.abs(sol - t_hit) < EPSILON:                                      <L 280>
                    var_353 = wp::sub(var_331, var_139);
                    var_354 = wp::abs(var_353);
                    var_355 = (var_354 < var_147);
                    if (var_355) {
                        // normal_local[i] = -1.0 if side < 0 else 1.0                        <L 281>
                        var_357 = (var_324 < var_356);
                        if (var_357) {
                        }
                        if (!var_357) {
                        }
                        var_360 = wp::where(var_357, var_358, var_359);
                        wp::assign_inplace(var_143, var_320, var_360);
                    }
                }
            }
            var_361 = wp::where(var_333, var_335, var_316);
            var_362 = wp::where(var_333, var_337, var_317);
            var_363 = wp::where(var_333, var_341, var_318);
            var_364 = wp::where(var_333, var_345, var_319);
            // sol = (float(side) * size[i] - ray_origin[i]) / ray_direction[i]               <L 273>
            var_366 = wp::float(var_365);
            var_367 = wp::extract(var_size, var_320);
            var_368 = wp::mul(var_366, var_367);
            var_369 = wp::extract(var_ray_origin, var_320);
            var_370 = wp::sub(var_368, var_369);
            var_371 = wp::extract(var_ray_direction, var_320);
            var_372 = wp::div(var_370, var_371);
            // if sol >= 0.0:                                                                 <L 274>
            var_374 = (var_372 >= var_373);
            if (var_374) {
                // id0 = _IFACE[i][0]                                                         <L 275>
                var_376 = wp::extract(var_159, var_320, var_375);
                // id1 = _IFACE[i][1]                                                         <L 276>
                var_378 = wp::extract(var_159, var_320, var_377);
                // p0 = ray_origin[id0] + sol * ray_direction[id0]                            <L 277>
                var_379 = wp::extract(var_ray_origin, var_376);
                var_380 = wp::extract(var_ray_direction, var_376);
                var_381 = wp::mul(var_372, var_380);
                var_382 = wp::add(var_379, var_381);
                // p1 = ray_origin[id1] + sol * ray_direction[id1]                            <L 278>
                var_383 = wp::extract(var_ray_origin, var_378);
                var_384 = wp::extract(var_ray_direction, var_378);
                var_385 = wp::mul(var_372, var_384);
                var_386 = wp::add(var_383, var_385);
                // if wp.abs(p0) <= size[id0] and wp.abs(p1) <= size[id1]:                    <L 279>
                var_388 = wp::abs(var_382);
                var_389 = wp::extract(var_size, var_376);
                var_390 = (var_388 <= var_389);
                var_387 = var_390;
                if (var_387) {
                    var_391 = wp::abs(var_386);
                    var_392 = wp::extract(var_size, var_378);
                    var_393 = (var_391 <= var_392);
                    var_387 = var_387 && var_393;
                }
                if (var_387) {
                    // if wp.abs(sol - t_hit) < EPSILON:                                      <L 280>
                    var_394 = wp::sub(var_372, var_139);
                    var_395 = wp::abs(var_394);
                    var_396 = (var_395 < var_147);
                    if (var_396) {
                        // normal_local[i] = -1.0 if side < 0 else 1.0                        <L 281>
                        var_398 = (var_365 < var_397);
                        if (var_398) {
                        }
                        if (!var_398) {
                        }
                        var_401 = wp::where(var_398, var_399, var_400);
                        wp::assign_inplace(var_143, var_320, var_401);
                    }
                }
            }
            var_402 = wp::where(var_374, var_376, var_361);
            var_403 = wp::where(var_374, var_378, var_362);
            var_404 = wp::where(var_374, var_382, var_363);
            var_405 = wp::where(var_374, var_386, var_364);
        }
        var_406 = wp::where(var_323, var_365, var_314);
        var_407 = wp::where(var_323, var_372, var_315);
        var_408 = wp::where(var_323, var_402, var_316);
        var_409 = wp::where(var_323, var_403, var_317);
        var_410 = wp::where(var_323, var_404, var_318);
        var_411 = wp::where(var_323, var_405, var_319);
        // normal = wp.normalize(normal_local)                                                <L 282>
        var_412 = wp::normalize(var_143);
    }
    var_413 = wp::where(var_141, var_412, var_2);
    var_414 = wp::where(var_141, var_320, var_86);
    // return t_hit, normal                                                                   <L 284>
    ret_0 = var_139;
    ret_1 = var_413;
    return;
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/geometry/raycast.py:287
static void ray_intersect_capsule_0(
    wp::vec_t<3, wp::float32> var_ray_origin,
    wp::vec_t<3, wp::float32> var_ray_direction,
    wp::float32 var_r,
    wp::float32 var_h,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    const wp::float32 var_0 = -1.0;
    const wp::float32 var_1 = 0.0;
    wp::vec_t<3, wp::float32> var_2;
    wp::float32 var_3;
    const wp::float32 var_4 = 1e-15;
    bool var_5;
    const wp::float32 var_6 = 1.0;
    wp::float32 var_7;
    wp::float32 var_8;
    wp::vec_t<3, wp::float32> var_9;
    const wp::float32 var_10 = 10000000000.0;
    const wp::int32 var_11 = 0;
    wp::float32 var_12;
    const wp::int32 var_13 = 0;
    wp::float32 var_14;
    wp::float32 var_15;
    const wp::int32 var_16 = 1;
    wp::float32 var_17;
    const wp::int32 var_18 = 1;
    wp::float32 var_19;
    wp::float32 var_20;
    wp::float32 var_21;
    bool var_22;
    const wp::float32 var_23 = 2.0;
    const wp::int32 var_24 = 0;
    wp::float32 var_25;
    const wp::int32 var_26 = 0;
    wp::float32 var_27;
    wp::float32 var_28;
    const wp::int32 var_29 = 1;
    wp::float32 var_30;
    const wp::int32 var_31 = 1;
    wp::float32 var_32;
    wp::float32 var_33;
    wp::float32 var_34;
    wp::float32 var_35;
    const wp::int32 var_36 = 0;
    wp::float32 var_37;
    const wp::int32 var_38 = 0;
    wp::float32 var_39;
    wp::float32 var_40;
    const wp::int32 var_41 = 1;
    wp::float32 var_42;
    const wp::int32 var_43 = 1;
    wp::float32 var_44;
    wp::float32 var_45;
    wp::float32 var_46;
    wp::float32 var_47;
    wp::float32 var_48;
    wp::float32 var_49;
    const wp::float32 var_50 = 4.0;
    wp::float32 var_51;
    wp::float32 var_52;
    wp::float32 var_53;
    const wp::float32 var_54 = 0.0;
    bool var_55;
    wp::float32 var_56;
    wp::float32 var_57;
    wp::float32 var_58;
    const wp::float32 var_59 = 2.0;
    wp::float32 var_60;
    wp::float32 var_61;
    const wp::float32 var_62 = 0.0;
    bool var_63;
    const wp::int32 var_64 = 2;
    wp::float32 var_65;
    const wp::int32 var_66 = 2;
    wp::float32 var_67;
    wp::float32 var_68;
    wp::float32 var_69;
    wp::float32 var_70;
    bool var_71;
    wp::float32 var_72;
    wp::float32 var_73;
    wp::float32 var_74;
    wp::float32 var_75;
    wp::float32 var_76;
    const wp::float32 var_77 = 2.0;
    wp::float32 var_78;
    wp::float32 var_79;
    const wp::float32 var_80 = 0.0;
    bool var_81;
    const wp::int32 var_82 = 2;
    wp::float32 var_83;
    const wp::int32 var_84 = 2;
    wp::float32 var_85;
    wp::float32 var_86;
    wp::float32 var_87;
    wp::float32 var_88;
    bool var_89;
    wp::float32 var_90;
    wp::float32 var_91;
    wp::float32 var_92;
    wp::float32 var_93;
    wp::float32 var_94;
    wp::float32 var_95;
    const wp::float32 var_96 = 0.0;
    const wp::float32 var_97 = 0.0;
    wp::vec_t<3, wp::float32> var_98;
    wp::vec_t<3, wp::float32> var_99;
    wp::float32 var_100;
    wp::float32 var_101;
    wp::float32 var_102;
    wp::float32 var_103;
    wp::float32 var_104;
    wp::float32 var_105;
    const wp::float32 var_106 = 0.0;
    bool var_107;
    wp::float32 var_108;
    wp::float32 var_109;
    wp::float32 var_110;
    const wp::float32 var_111 = 0.0;
    bool var_112;
    const wp::int32 var_113 = 2;
    wp::float32 var_114;
    const wp::int32 var_115 = 2;
    wp::float32 var_116;
    wp::float32 var_117;
    wp::float32 var_118;
    bool var_119;
    wp::float32 var_120;
    wp::float32 var_121;
    wp::float32 var_122;
    wp::float32 var_123;
    wp::float32 var_124;
    const wp::float32 var_125 = 0.0;
    bool var_126;
    const wp::int32 var_127 = 2;
    wp::float32 var_128;
    const wp::int32 var_129 = 2;
    wp::float32 var_130;
    wp::float32 var_131;
    wp::float32 var_132;
    bool var_133;
    wp::float32 var_134;
    wp::float32 var_135;
    wp::float32 var_136;
    wp::float32 var_137;
    const wp::float32 var_138 = 0.0;
    const wp::float32 var_139 = 0.0;
    wp::float32 var_140;
    wp::vec_t<3, wp::float32> var_141;
    wp::vec_t<3, wp::float32> var_142;
    wp::float32 var_143;
    wp::float32 var_144;
    wp::float32 var_145;
    wp::float32 var_146;
    wp::float32 var_147;
    wp::float32 var_148;
    const wp::float32 var_149 = 0.0;
    bool var_150;
    wp::float32 var_151;
    wp::float32 var_152;
    wp::float32 var_153;
    const wp::float32 var_154 = 0.0;
    bool var_155;
    const wp::int32 var_156 = 2;
    wp::float32 var_157;
    const wp::int32 var_158 = 2;
    wp::float32 var_159;
    wp::float32 var_160;
    wp::float32 var_161;
    wp::float32 var_162;
    bool var_163;
    wp::float32 var_164;
    wp::float32 var_165;
    wp::float32 var_166;
    wp::float32 var_167;
    wp::float32 var_168;
    const wp::float32 var_169 = 0.0;
    bool var_170;
    const wp::int32 var_171 = 2;
    wp::float32 var_172;
    const wp::int32 var_173 = 2;
    wp::float32 var_174;
    wp::float32 var_175;
    wp::float32 var_176;
    wp::float32 var_177;
    bool var_178;
    wp::float32 var_179;
    wp::float32 var_180;
    wp::float32 var_181;
    wp::float32 var_182;
    const wp::float32 var_183 = 1000000000.0;
    bool var_184;
    wp::float32 var_185;
    wp::float32 var_186;
    const wp::float32 var_187 = 0.0;
    bool var_188;
    wp::vec_t<3, wp::float32> var_189;
    wp::vec_t<3, wp::float32> var_190;
    wp::float32 var_191;
    const wp::int32 var_192 = 2;
    wp::float32 var_193;
    wp::float32 var_194;
    wp::float32 var_195;
    const wp::float32 var_196 = 0.0;
    const wp::float32 var_197 = 0.0;
    wp::vec_t<3, wp::float32> var_198;
    wp::vec_t<3, wp::float32> var_199;
    wp::vec_t<3, wp::float32> var_200;
    wp::vec_t<3, wp::float32> var_201;
    //---------
    // forward
    // def ray_intersect_capsule(ray_origin: wp.vec3, ray_direction: wp.vec3, r: float, h: float) -> tuple[float, wp.vec3]:       <L 288>
    // t_hit = -1.0                                                                           <L 302>
    // normal = wp.vec3(0.0)                                                                  <L 303>
    var_2 = wp::vec_t<3, wp::float32>(var_1);
    // d_len_sq = wp.dot(ray_direction, ray_direction)                                        <L 305>
    var_3 = wp::dot(var_ray_direction, var_ray_direction);
    // if d_len_sq < MINVAL:                                                                  <L 306>
    var_5 = (var_3 < var_4);
    if (var_5) {
        // return t_hit, normal                                                               <L 307>
        ret_0 = var_0;
        ret_1 = var_2;
        return;
    }
    // inv_d_len = 1.0 / wp.sqrt(d_len_sq)                                                    <L 309>
    var_7 = wp::sqrt(var_3);
    var_8 = wp::div(var_6, var_7);
    // d_local_norm = ray_direction * inv_d_len                                               <L 310>
    var_9 = wp::mul(var_ray_direction, var_8);
    // min_t = 1.0e10                                                                         <L 312>
    // a_cyl = d_local_norm[0] * d_local_norm[0] + d_local_norm[1] * d_local_norm[1]          <L 315>
    var_12 = wp::extract(var_9, var_11);
    var_14 = wp::extract(var_9, var_13);
    var_15 = wp::mul(var_12, var_14);
    var_17 = wp::extract(var_9, var_16);
    var_19 = wp::extract(var_9, var_18);
    var_20 = wp::mul(var_17, var_19);
    var_21 = wp::add(var_15, var_20);
    // if a_cyl > MINVAL:                                                                     <L 316>
    var_22 = (var_21 > var_4);
    if (var_22) {
        // b_cyl = 2.0 * (ray_origin[0] * d_local_norm[0] + ray_origin[1] * d_local_norm[1])       <L 317>
        var_25 = wp::extract(var_ray_origin, var_24);
        var_27 = wp::extract(var_9, var_26);
        var_28 = wp::mul(var_25, var_27);
        var_30 = wp::extract(var_ray_origin, var_29);
        var_32 = wp::extract(var_9, var_31);
        var_33 = wp::mul(var_30, var_32);
        var_34 = wp::add(var_28, var_33);
        var_35 = wp::mul(var_23, var_34);
        // c_cyl = ray_origin[0] * ray_origin[0] + ray_origin[1] * ray_origin[1] - r * r       <L 318>
        var_37 = wp::extract(var_ray_origin, var_36);
        var_39 = wp::extract(var_ray_origin, var_38);
        var_40 = wp::mul(var_37, var_39);
        var_42 = wp::extract(var_ray_origin, var_41);
        var_44 = wp::extract(var_ray_origin, var_43);
        var_45 = wp::mul(var_42, var_44);
        var_46 = wp::add(var_40, var_45);
        var_47 = wp::mul(var_r, var_r);
        var_48 = wp::sub(var_46, var_47);
        // delta_cyl = b_cyl * b_cyl - 4.0 * a_cyl * c_cyl                                    <L 319>
        var_49 = wp::mul(var_35, var_35);
        var_51 = wp::mul(var_50, var_21);
        var_52 = wp::mul(var_51, var_48);
        var_53 = wp::sub(var_49, var_52);
        // if delta_cyl >= 0.0:                                                               <L 320>
        var_55 = (var_53 >= var_54);
        if (var_55) {
            // sqrt_delta_cyl = wp.sqrt(delta_cyl)                                            <L 321>
            var_56 = wp::sqrt(var_53);
            // t1 = (-b_cyl - sqrt_delta_cyl) / (2.0 * a_cyl)                                 <L 322>
            var_57 = wp::neg(var_35);
            var_58 = wp::sub(var_57, var_56);
            var_60 = wp::mul(var_59, var_21);
            var_61 = wp::div(var_58, var_60);
            // if t1 >= 0.0:                                                                  <L 323>
            var_63 = (var_61 >= var_62);
            if (var_63) {
                // z = ray_origin[2] + t1 * d_local_norm[2]                                   <L 324>
                var_65 = wp::extract(var_ray_origin, var_64);
                var_67 = wp::extract(var_9, var_66);
                var_68 = wp::mul(var_61, var_67);
                var_69 = wp::add(var_65, var_68);
                // if wp.abs(z) <= h:                                                         <L 325>
                var_70 = wp::abs(var_69);
                var_71 = (var_70 <= var_h);
                if (var_71) {
                    // min_t = wp.min(min_t, t1)                                              <L 326>
                    var_72 = wp::min(var_10, var_61);
                }
                var_73 = wp::where(var_71, var_72, var_10);
            }
            var_74 = wp::where(var_63, var_73, var_10);
            // t2 = (-b_cyl + sqrt_delta_cyl) / (2.0 * a_cyl)                                 <L 328>
            var_75 = wp::neg(var_35);
            var_76 = wp::add(var_75, var_56);
            var_78 = wp::mul(var_77, var_21);
            var_79 = wp::div(var_76, var_78);
            // if t2 >= 0.0:                                                                  <L 329>
            var_81 = (var_79 >= var_80);
            if (var_81) {
                // z = ray_origin[2] + t2 * d_local_norm[2]                                   <L 330>
                var_83 = wp::extract(var_ray_origin, var_82);
                var_85 = wp::extract(var_9, var_84);
                var_86 = wp::mul(var_79, var_85);
                var_87 = wp::add(var_83, var_86);
                // if wp.abs(z) <= h:                                                         <L 331>
                var_88 = wp::abs(var_87);
                var_89 = (var_88 <= var_h);
                if (var_89) {
                    // min_t = wp.min(min_t, t2)                                              <L 332>
                    var_90 = wp::min(var_74, var_79);
                }
                var_91 = wp::where(var_89, var_90, var_74);
            }
            var_92 = wp::where(var_81, var_91, var_74);
            var_93 = wp::where(var_81, var_87, var_69);
        }
        var_94 = wp::where(var_55, var_92, var_10);
    }
    var_95 = wp::where(var_22, var_94, var_10);
    // oc_top = ray_origin - wp.vec3(0.0, 0.0, h)                                             <L 336>
    var_98 = wp::vec_t<3, wp::float32>(var_96, var_97, var_h);
    var_99 = wp::sub(var_ray_origin, var_98);
    // b_top = wp.dot(oc_top, d_local_norm)                                                   <L 337>
    var_100 = wp::dot(var_99, var_9);
    // c_top = wp.dot(oc_top, oc_top) - r * r                                                 <L 338>
    var_101 = wp::dot(var_99, var_99);
    var_102 = wp::mul(var_r, var_r);
    var_103 = wp::sub(var_101, var_102);
    // delta_top = b_top * b_top - c_top                                                      <L 339>
    var_104 = wp::mul(var_100, var_100);
    var_105 = wp::sub(var_104, var_103);
    // if delta_top >= 0.0:                                                                   <L 340>
    var_107 = (var_105 >= var_106);
    if (var_107) {
        // sqrt_delta_top = wp.sqrt(delta_top)                                                <L 341>
        var_108 = wp::sqrt(var_105);
        // t1_top = -b_top - sqrt_delta_top                                                   <L 342>
        var_109 = wp::neg(var_100);
        var_110 = wp::sub(var_109, var_108);
        // if t1_top >= 0.0:                                                                  <L 343>
        var_112 = (var_110 >= var_111);
        if (var_112) {
            // if (ray_origin[2] + t1_top * d_local_norm[2]) >= h:                            <L 344>
            var_114 = wp::extract(var_ray_origin, var_113);
            var_116 = wp::extract(var_9, var_115);
            var_117 = wp::mul(var_110, var_116);
            var_118 = wp::add(var_114, var_117);
            var_119 = (var_118 >= var_h);
            if (var_119) {
                // min_t = wp.min(min_t, t1_top)                                              <L 345>
                var_120 = wp::min(var_95, var_110);
            }
            var_121 = wp::where(var_119, var_120, var_95);
        }
        var_122 = wp::where(var_112, var_121, var_95);
        // t2_top = -b_top + sqrt_delta_top                                                   <L 347>
        var_123 = wp::neg(var_100);
        var_124 = wp::add(var_123, var_108);
        // if t2_top >= 0.0:                                                                  <L 348>
        var_126 = (var_124 >= var_125);
        if (var_126) {
            // if (ray_origin[2] + t2_top * d_local_norm[2]) >= h:                            <L 349>
            var_128 = wp::extract(var_ray_origin, var_127);
            var_130 = wp::extract(var_9, var_129);
            var_131 = wp::mul(var_124, var_130);
            var_132 = wp::add(var_128, var_131);
            var_133 = (var_132 >= var_h);
            if (var_133) {
                // min_t = wp.min(min_t, t2_top)                                              <L 350>
                var_134 = wp::min(var_122, var_124);
            }
            var_135 = wp::where(var_133, var_134, var_122);
        }
        var_136 = wp::where(var_126, var_135, var_122);
    }
    var_137 = wp::where(var_107, var_136, var_95);
    // oc_bot = ray_origin - wp.vec3(0.0, 0.0, -h)                                            <L 353>
    var_140 = wp::neg(var_h);
    var_141 = wp::vec_t<3, wp::float32>(var_138, var_139, var_140);
    var_142 = wp::sub(var_ray_origin, var_141);
    // b_bot = wp.dot(oc_bot, d_local_norm)                                                   <L 354>
    var_143 = wp::dot(var_142, var_9);
    // c_bot = wp.dot(oc_bot, oc_bot) - r * r                                                 <L 355>
    var_144 = wp::dot(var_142, var_142);
    var_145 = wp::mul(var_r, var_r);
    var_146 = wp::sub(var_144, var_145);
    // delta_bot = b_bot * b_bot - c_bot                                                      <L 356>
    var_147 = wp::mul(var_143, var_143);
    var_148 = wp::sub(var_147, var_146);
    // if delta_bot >= 0.0:                                                                   <L 357>
    var_150 = (var_148 >= var_149);
    if (var_150) {
        // sqrt_delta_bot = wp.sqrt(delta_bot)                                                <L 358>
        var_151 = wp::sqrt(var_148);
        // t1_bot = -b_bot - sqrt_delta_bot                                                   <L 359>
        var_152 = wp::neg(var_143);
        var_153 = wp::sub(var_152, var_151);
        // if t1_bot >= 0.0:                                                                  <L 360>
        var_155 = (var_153 >= var_154);
        if (var_155) {
            // if (ray_origin[2] + t1_bot * d_local_norm[2]) <= -h:                           <L 361>
            var_157 = wp::extract(var_ray_origin, var_156);
            var_159 = wp::extract(var_9, var_158);
            var_160 = wp::mul(var_153, var_159);
            var_161 = wp::add(var_157, var_160);
            var_162 = wp::neg(var_h);
            var_163 = (var_161 <= var_162);
            if (var_163) {
                // min_t = wp.min(min_t, t1_bot)                                              <L 362>
                var_164 = wp::min(var_137, var_153);
            }
            var_165 = wp::where(var_163, var_164, var_137);
        }
        var_166 = wp::where(var_155, var_165, var_137);
        // t2_bot = -b_bot + sqrt_delta_bot                                                   <L 364>
        var_167 = wp::neg(var_143);
        var_168 = wp::add(var_167, var_151);
        // if t2_bot >= 0.0:                                                                  <L 365>
        var_170 = (var_168 >= var_169);
        if (var_170) {
            // if (ray_origin[2] + t2_bot * d_local_norm[2]) <= -h:                           <L 366>
            var_172 = wp::extract(var_ray_origin, var_171);
            var_174 = wp::extract(var_9, var_173);
            var_175 = wp::mul(var_168, var_174);
            var_176 = wp::add(var_172, var_175);
            var_177 = wp::neg(var_h);
            var_178 = (var_176 <= var_177);
            if (var_178) {
                // min_t = wp.min(min_t, t2_bot)                                              <L 367>
                var_179 = wp::min(var_166, var_168);
            }
            var_180 = wp::where(var_178, var_179, var_166);
        }
        var_181 = wp::where(var_170, var_180, var_166);
    }
    var_182 = wp::where(var_150, var_181, var_137);
    // if min_t < 1.0e9:                                                                      <L 369>
    var_184 = (var_182 < var_183);
    if (var_184) {
        // t_hit = min_t * inv_d_len                                                          <L 370>
        var_185 = wp::mul(var_182, var_8);
    }
    var_186 = wp::where(var_184, var_185, var_0);
    // if t_hit >= 0.0:                                                                       <L 372>
    var_188 = (var_186 >= var_187);
    if (var_188) {
        // hit_local = ray_origin + t_hit * ray_direction                                     <L 373>
        var_189 = wp::mul(var_186, var_ray_direction);
        var_190 = wp::add(var_ray_origin, var_189);
        // z_clamped = wp.min(h, wp.max(-h, hit_local[2]))                                    <L 374>
        var_191 = wp::neg(var_h);
        var_193 = wp::extract(var_190, var_192);
        var_194 = wp::max(var_191, var_193);
        var_195 = wp::min(var_h, var_194);
        // axis_point = wp.vec3(0.0, 0.0, z_clamped)                                          <L 375>
        var_198 = wp::vec_t<3, wp::float32>(var_196, var_197, var_195);
        // normal = wp.normalize(hit_local - axis_point)                                      <L 376>
        var_199 = wp::sub(var_190, var_198);
        var_200 = wp::normalize(var_199);
    }
    var_201 = wp::where(var_188, var_200, var_2);
    // return t_hit, normal                                                                   <L 378>
    ret_0 = var_186;
    ret_1 = var_201;
    return;
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/geometry/raycast.py:381
static void ray_intersect_cylinder_0(
    wp::vec_t<3, wp::float32> var_ray_origin,
    wp::vec_t<3, wp::float32> var_ray_direction,
    wp::float32 var_r,
    wp::float32 var_h,
    wp::float32 var_barrel_radius,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    const wp::float32 var_0 = -1.0;
    const wp::float32 var_1 = 0.0;
    wp::vec_t<3, wp::float32> var_2;
    const wp::float32 var_3 = 10000000000.0;
    const wp::float32 var_4 = 0.0;
    wp::float32 var_5;
    bool var_6;
    const wp::float32 var_7 = 0.0;
    bool var_8;
    const wp::float32 var_9 = 1e-15;
    bool var_10;
    wp::float32 var_11;
    wp::float32 var_12;
    wp::float32 var_13;
    wp::float32 var_14;
    wp::float32 var_15;
    wp::float32 var_16;
    wp::float32 var_17;
    wp::float32 var_18;
    wp::float32 var_19;
    wp::float32 var_20;
    wp::float32 var_21;
    wp::float32 var_22;
    wp::float32 var_23;
    const wp::int32 var_24 = 0;
    wp::float32 var_25;
    const wp::int32 var_26 = 0;
    wp::float32 var_27;
    wp::float32 var_28;
    const wp::int32 var_29 = 1;
    wp::float32 var_30;
    const wp::int32 var_31 = 1;
    wp::float32 var_32;
    wp::float32 var_33;
    wp::float32 var_34;
    const wp::int32 var_35 = 2;
    wp::float32 var_36;
    wp::float32 var_37;
    const wp::int32 var_38 = 2;
    wp::float32 var_39;
    wp::float32 var_40;
    wp::float32 var_41;
    bool var_42;
    const wp::float32 var_43 = 2.0;
    const wp::int32 var_44 = 0;
    wp::float32 var_45;
    const wp::int32 var_46 = 0;
    wp::float32 var_47;
    wp::float32 var_48;
    const wp::int32 var_49 = 1;
    wp::float32 var_50;
    const wp::int32 var_51 = 1;
    wp::float32 var_52;
    wp::float32 var_53;
    wp::float32 var_54;
    const wp::int32 var_55 = 2;
    wp::float32 var_56;
    wp::float32 var_57;
    const wp::int32 var_58 = 2;
    wp::float32 var_59;
    wp::float32 var_60;
    wp::float32 var_61;
    wp::float32 var_62;
    const wp::int32 var_63 = 0;
    wp::float32 var_64;
    const wp::int32 var_65 = 0;
    wp::float32 var_66;
    wp::float32 var_67;
    const wp::int32 var_68 = 1;
    wp::float32 var_69;
    const wp::int32 var_70 = 1;
    wp::float32 var_71;
    wp::float32 var_72;
    wp::float32 var_73;
    const wp::int32 var_74 = 2;
    wp::float32 var_75;
    wp::float32 var_76;
    const wp::int32 var_77 = 2;
    wp::float32 var_78;
    wp::float32 var_79;
    wp::float32 var_80;
    wp::float32 var_81;
    wp::float32 var_82;
    wp::float32 var_83;
    const wp::float32 var_84 = 4.0;
    wp::float32 var_85;
    wp::float32 var_86;
    wp::float32 var_87;
    const wp::float32 var_88 = 0.0;
    bool var_89;
    wp::float32 var_90;
    const wp::float32 var_91 = 1.0;
    const wp::float32 var_92 = 2.0;
    wp::float32 var_93;
    wp::float32 var_94;
    wp::float32 var_95;
    wp::float32 var_96;
    wp::float32 var_97;
    const wp::int32 var_98 = 2;
    wp::float32 var_99;
    const wp::int32 var_100 = 2;
    wp::float32 var_101;
    wp::float32 var_102;
    wp::float32 var_103;
    bool var_104;
    const wp::float32 var_105 = 0.0;
    bool var_106;
    wp::float32 var_107;
    bool var_108;
    wp::float32 var_109;
    wp::float32 var_110;
    wp::float32 var_111;
    const wp::int32 var_112 = 2;
    wp::float32 var_113;
    const wp::int32 var_114 = 2;
    wp::float32 var_115;
    wp::float32 var_116;
    wp::float32 var_117;
    wp::float32 var_118;
    wp::float32 var_119;
    bool var_120;
    const wp::float32 var_121 = 0.0;
    bool var_122;
    wp::float32 var_123;
    bool var_124;
    wp::float32 var_125;
    wp::float32 var_126;
    wp::float32 var_127;
    wp::float32 var_128;
    bool var_129;
    const wp::float32 var_130 = 0.0;
    bool var_131;
    const wp::float32 var_132 = 10000000000.0;
    bool var_133;
    wp::vec_t<3, wp::float32> var_134;
    wp::vec_t<3, wp::float32> var_135;
    const wp::int32 var_136 = 0;
    wp::float32 var_137;
    const wp::int32 var_138 = 0;
    wp::float32 var_139;
    wp::float32 var_140;
    const wp::int32 var_141 = 1;
    wp::float32 var_142;
    const wp::int32 var_143 = 1;
    wp::float32 var_144;
    wp::float32 var_145;
    wp::float32 var_146;
    wp::float32 var_147;
    wp::float32 var_148;
    const wp::int32 var_149 = 2;
    wp::float32 var_150;
    const wp::int32 var_151 = 2;
    wp::float32 var_152;
    wp::float32 var_153;
    wp::float32 var_154;
    bool var_155;
    bool var_156;
    bool var_157;
    wp::float32 var_158;
    wp::float32 var_159;
    wp::float32 var_160;
    wp::float32 var_161;
    wp::float32 var_162;
    wp::float32 var_163;
    wp::float32 var_164;
    wp::float32 var_165;
    const wp::int32 var_166 = 0;
    wp::float32 var_167;
    const wp::int32 var_168 = 0;
    wp::float32 var_169;
    wp::float32 var_170;
    const wp::int32 var_171 = 1;
    wp::float32 var_172;
    const wp::int32 var_173 = 1;
    wp::float32 var_174;
    wp::float32 var_175;
    wp::float32 var_176;
    wp::float32 var_177;
    const wp::int32 var_178 = 2;
    wp::float32 var_179;
    const wp::int32 var_180 = 2;
    wp::float32 var_181;
    wp::float32 var_182;
    wp::float32 var_183;
    wp::float32 var_184;
    wp::float32 var_185;
    bool var_186;
    wp::float32 var_187;
    wp::float32 var_188;
    const wp::int32 var_189 = 2;
    wp::float32 var_190;
    const wp::int32 var_191 = 2;
    wp::float32 var_192;
    wp::float32 var_193;
    wp::float32 var_194;
    bool var_195;
    const wp::float32 var_196 = 0.0;
    bool var_197;
    wp::float32 var_198;
    bool var_199;
    wp::float32 var_200;
    wp::float32 var_201;
    wp::float32 var_202;
    wp::float32 var_203;
    wp::float32 var_204;
    const wp::int32 var_205 = 2;
    wp::float32 var_206;
    wp::float32 var_207;
    bool var_208;
    const wp::float32 var_209 = 1.0;
    const wp::int32 var_210 = 2;
    wp::float32 var_211;
    wp::float32 var_212;
    const wp::int32 var_213 = 2;
    wp::float32 var_214;
    wp::float32 var_215;
    wp::float32 var_216;
    const wp::float32 var_217 = 0.0;
    bool var_218;
    const wp::int32 var_219 = 0;
    wp::float32 var_220;
    const wp::int32 var_221 = 0;
    wp::float32 var_222;
    wp::float32 var_223;
    wp::float32 var_224;
    const wp::int32 var_225 = 1;
    wp::float32 var_226;
    const wp::int32 var_227 = 1;
    wp::float32 var_228;
    wp::float32 var_229;
    wp::float32 var_230;
    wp::float32 var_231;
    wp::float32 var_232;
    wp::float32 var_233;
    wp::float32 var_234;
    bool var_235;
    wp::float32 var_236;
    wp::float32 var_237;
    wp::float32 var_238;
    wp::float32 var_239;
    const wp::int32 var_240 = 2;
    wp::float32 var_241;
    wp::float32 var_242;
    wp::float32 var_243;
    const wp::float32 var_244 = 0.0;
    bool var_245;
    const wp::int32 var_246 = 0;
    wp::float32 var_247;
    const wp::int32 var_248 = 0;
    wp::float32 var_249;
    wp::float32 var_250;
    wp::float32 var_251;
    const wp::int32 var_252 = 1;
    wp::float32 var_253;
    const wp::int32 var_254 = 1;
    wp::float32 var_255;
    wp::float32 var_256;
    wp::float32 var_257;
    wp::float32 var_258;
    wp::float32 var_259;
    wp::float32 var_260;
    wp::float32 var_261;
    bool var_262;
    wp::float32 var_263;
    wp::float32 var_264;
    wp::float32 var_265;
    wp::float32 var_266;
    wp::float32 var_267;
    wp::float32 var_268;
    const wp::float32 var_269 = 1000000000.0;
    bool var_270;
    wp::float32 var_271;
    wp::float32 var_272;
    const wp::float32 var_273 = 0.0;
    bool var_274;
    wp::vec_t<3, wp::float32> var_275;
    wp::vec_t<3, wp::float32> var_276;
    wp::float32 var_277;
    const wp::int32 var_278 = 2;
    wp::float32 var_279;
    wp::float32 var_280;
    wp::float32 var_281;
    bool var_282;
    const wp::float32 var_283 = 1e-06;
    wp::float32 var_284;
    bool var_285;
    wp::float32 var_286;
    wp::float32 var_287;
    bool var_288;
    const wp::float32 var_289 = 0.0;
    const wp::float32 var_290 = 0.0;
    wp::vec_t<3, wp::float32> var_291;
    const wp::float32 var_292 = 0.0;
    bool var_293;
    const wp::int32 var_294 = 0;
    wp::float32 var_295;
    const wp::int32 var_296 = 0;
    wp::float32 var_297;
    wp::float32 var_298;
    const wp::int32 var_299 = 1;
    wp::float32 var_300;
    const wp::int32 var_301 = 1;
    wp::float32 var_302;
    wp::float32 var_303;
    wp::float32 var_304;
    wp::float32 var_305;
    wp::float32 var_306;
    const wp::int32 var_307 = 2;
    wp::float32 var_308;
    const wp::int32 var_309 = 2;
    wp::float32 var_310;
    wp::float32 var_311;
    wp::float32 var_312;
    wp::float32 var_313;
    const wp::int32 var_314 = 0;
    wp::float32 var_315;
    wp::float32 var_316;
    const wp::int32 var_317 = 1;
    wp::float32 var_318;
    wp::float32 var_319;
    const wp::int32 var_320 = 2;
    wp::float32 var_321;
    wp::float32 var_322;
    wp::vec_t<3, wp::float32> var_323;
    const wp::int32 var_324 = 0;
    wp::float32 var_325;
    const wp::int32 var_326 = 1;
    wp::float32 var_327;
    const wp::int32 var_328 = 2;
    wp::float32 var_329;
    wp::float32 var_330;
    wp::vec_t<3, wp::float32> var_331;
    wp::vec_t<3, wp::float32> var_332;
    wp::vec_t<3, wp::float32> var_333;
    wp::vec_t<3, wp::float32> var_334;
    wp::vec_t<3, wp::float32> var_335;
    //---------
    // forward
    // def ray_intersect_cylinder(                                                            <L 382>
    // t_hit = -1.0                                                                           <L 401>
    // normal = wp.vec3(0.0)                                                                  <L 402>
    var_2 = wp::vec_t<3, wp::float32>(var_1);
    // min_t = 1.0e10                                                                         <L 403>
    // axial_scale = 0.0                                                                      <L 404>
    // equatorial_radius = r                                                                  <L 405>
    var_5 = wp::copy(var_r);
    // if barrel_radius > 0.0 and h > MINVAL:                                                 <L 407>
    var_8 = (var_barrel_radius > var_7);
    var_6 = var_8;
    if (var_6) {
        var_10 = (var_h > var_9);
        var_6 = var_6 && var_10;
    }
    if (var_6) {
        // equatorial_radius = r + barrel_radius - wp.sqrt(barrel_radius * barrel_radius - h * h)       <L 408>
        var_11 = wp::add(var_r, var_barrel_radius);
        var_12 = wp::mul(var_barrel_radius, var_barrel_radius);
        var_13 = wp::mul(var_h, var_h);
        var_14 = wp::sub(var_12, var_13);
        var_15 = wp::sqrt(var_14);
        var_16 = wp::sub(var_11, var_15);
        // axial_scale = (equatorial_radius * equatorial_radius - r * r) / (h * h)            <L 409>
        var_17 = wp::mul(var_16, var_16);
        var_18 = wp::mul(var_r, var_r);
        var_19 = wp::sub(var_17, var_18);
        var_20 = wp::mul(var_h, var_h);
        var_21 = wp::div(var_19, var_20);
    }
    var_22 = wp::where(var_6, var_21, var_4);
    var_23 = wp::where(var_6, var_16, var_5);
    // a_side = (                                                                             <L 413>
    // ray_direction[0] * ray_direction[0]                                                    <L 414>
    var_25 = wp::extract(var_ray_direction, var_24);
    var_27 = wp::extract(var_ray_direction, var_26);
    var_28 = wp::mul(var_25, var_27);
    // + ray_direction[1] * ray_direction[1]                                                  <L 415>
    var_30 = wp::extract(var_ray_direction, var_29);
    var_32 = wp::extract(var_ray_direction, var_31);
    var_33 = wp::mul(var_30, var_32);
    var_34 = wp::add(var_28, var_33);
    // + axial_scale * ray_direction[2] * ray_direction[2]                                    <L 416>
    var_36 = wp::extract(var_ray_direction, var_35);
    var_37 = wp::mul(var_22, var_36);
    var_39 = wp::extract(var_ray_direction, var_38);
    var_40 = wp::mul(var_37, var_39);
    var_41 = wp::add(var_34, var_40);
    // if a_side > MINVAL:                                                                    <L 418>
    var_42 = (var_41 > var_9);
    if (var_42) {
        // b_side = 2.0 * (                                                                   <L 419>
        // ray_origin[0] * ray_direction[0]                                                   <L 420>
        var_45 = wp::extract(var_ray_origin, var_44);
        var_47 = wp::extract(var_ray_direction, var_46);
        var_48 = wp::mul(var_45, var_47);
        // + ray_origin[1] * ray_direction[1]                                                 <L 421>
        var_50 = wp::extract(var_ray_origin, var_49);
        var_52 = wp::extract(var_ray_direction, var_51);
        var_53 = wp::mul(var_50, var_52);
        var_54 = wp::add(var_48, var_53);
        // + axial_scale * ray_origin[2] * ray_direction[2]                                   <L 422>
        var_56 = wp::extract(var_ray_origin, var_55);
        var_57 = wp::mul(var_22, var_56);
        var_59 = wp::extract(var_ray_direction, var_58);
        var_60 = wp::mul(var_57, var_59);
        var_61 = wp::add(var_54, var_60);
        var_62 = wp::mul(var_43, var_61);
        // c_side = (                                                                         <L 424>
        // ray_origin[0] * ray_origin[0]                                                      <L 425>
        var_64 = wp::extract(var_ray_origin, var_63);
        var_66 = wp::extract(var_ray_origin, var_65);
        var_67 = wp::mul(var_64, var_66);
        // + ray_origin[1] * ray_origin[1]                                                    <L 426>
        var_69 = wp::extract(var_ray_origin, var_68);
        var_71 = wp::extract(var_ray_origin, var_70);
        var_72 = wp::mul(var_69, var_71);
        var_73 = wp::add(var_67, var_72);
        // + axial_scale * ray_origin[2] * ray_origin[2]                                      <L 427>
        var_75 = wp::extract(var_ray_origin, var_74);
        var_76 = wp::mul(var_22, var_75);
        var_78 = wp::extract(var_ray_origin, var_77);
        var_79 = wp::mul(var_76, var_78);
        var_80 = wp::add(var_73, var_79);
        // - equatorial_radius * equatorial_radius                                            <L 428>
        var_81 = wp::mul(var_23, var_23);
        var_82 = wp::sub(var_80, var_81);
        // delta_side = b_side * b_side - 4.0 * a_side * c_side                               <L 430>
        var_83 = wp::mul(var_62, var_62);
        var_85 = wp::mul(var_84, var_41);
        var_86 = wp::mul(var_85, var_82);
        var_87 = wp::sub(var_83, var_86);
        // if delta_side >= 0.0:                                                              <L 431>
        var_89 = (var_87 >= var_88);
        if (var_89) {
            // sqrt_delta_side = wp.sqrt(delta_side)                                          <L 432>
            var_90 = wp::sqrt(var_87);
            // inv_2a_side = 1.0 / (2.0 * a_side)                                             <L 433>
            var_93 = wp::mul(var_92, var_41);
            var_94 = wp::div(var_91, var_93);
            // t_side = (-b_side - sqrt_delta_side) * inv_2a_side                             <L 434>
            var_95 = wp::neg(var_62);
            var_96 = wp::sub(var_95, var_90);
            var_97 = wp::mul(var_96, var_94);
            // z_side = ray_origin[2] + t_side * ray_direction[2]                             <L 435>
            var_99 = wp::extract(var_ray_origin, var_98);
            var_101 = wp::extract(var_ray_direction, var_100);
            var_102 = wp::mul(var_97, var_101);
            var_103 = wp::add(var_99, var_102);
            // if t_side < 0.0 or wp.abs(z_side) > h:                                         <L 436>
            var_106 = (var_97 < var_105);
            var_104 = var_106;
            if (!var_104) {
                var_107 = wp::abs(var_103);
                var_108 = (var_107 > var_h);
                var_104 = var_104 || var_108;
            }
            if (var_104) {
                // t_side = (-b_side + sqrt_delta_side) * inv_2a_side                         <L 437>
                var_109 = wp::neg(var_62);
                var_110 = wp::add(var_109, var_90);
                var_111 = wp::mul(var_110, var_94);
                // z_side = ray_origin[2] + t_side * ray_direction[2]                         <L 438>
                var_113 = wp::extract(var_ray_origin, var_112);
                var_115 = wp::extract(var_ray_direction, var_114);
                var_116 = wp::mul(var_111, var_115);
                var_117 = wp::add(var_113, var_116);
            }
            var_118 = wp::where(var_104, var_111, var_97);
            var_119 = wp::where(var_104, var_117, var_103);
            // if t_side >= 0.0 and wp.abs(z_side) <= h:                                      <L 439>
            var_122 = (var_118 >= var_121);
            var_120 = var_122;
            if (var_120) {
                var_123 = wp::abs(var_119);
                var_124 = (var_123 <= var_h);
                var_120 = var_120 && var_124;
            }
            if (var_120) {
                // min_t = t_side                                                             <L 440>
                var_125 = wp::copy(var_118);
            }
            var_126 = wp::where(var_120, var_125, var_3);
        }
        var_127 = wp::where(var_89, var_126, var_3);
    }
    var_128 = wp::where(var_42, var_127, var_3);
    // if barrel_radius > 0.0 and min_t < 1.0e10:                                             <L 444>
    var_131 = (var_barrel_radius > var_130);
    var_129 = var_131;
    if (var_129) {
        var_133 = (var_128 < var_132);
        var_129 = var_129 && var_133;
    }
    if (var_129) {
        // hit_side = ray_origin + min_t * ray_direction                                      <L 445>
        var_134 = wp::mul(var_128, var_ray_direction);
        var_135 = wp::add(var_ray_origin, var_134);
        // radial_side = wp.sqrt(hit_side[0] * hit_side[0] + hit_side[1] * hit_side[1])       <L 446>
        var_137 = wp::extract(var_135, var_136);
        var_139 = wp::extract(var_135, var_138);
        var_140 = wp::mul(var_137, var_139);
        var_142 = wp::extract(var_135, var_141);
        var_144 = wp::extract(var_135, var_143);
        var_145 = wp::mul(var_142, var_144);
        var_146 = wp::add(var_140, var_145);
        var_147 = wp::sqrt(var_146);
        // circle_sq = barrel_radius * barrel_radius - hit_side[2] * hit_side[2]              <L 447>
        var_148 = wp::mul(var_barrel_radius, var_barrel_radius);
        var_150 = wp::extract(var_135, var_149);
        var_152 = wp::extract(var_135, var_151);
        var_153 = wp::mul(var_150, var_152);
        var_154 = wp::sub(var_148, var_153);
        // if radial_side > MINVAL and circle_sq > MINVAL:                                    <L 448>
        var_156 = (var_147 > var_9);
        var_155 = var_156;
        if (var_155) {
            var_157 = (var_154 > var_9);
            var_155 = var_155 && var_157;
        }
        if (var_155) {
            // circle_side = wp.sqrt(circle_sq)                                               <L 449>
            var_158 = wp::sqrt(var_154);
            // end_radial_offset = wp.sqrt(barrel_radius * barrel_radius - h * h)             <L 450>
            var_159 = wp::mul(var_barrel_radius, var_barrel_radius);
            var_160 = wp::mul(var_h, var_h);
            var_161 = wp::sub(var_159, var_160);
            var_162 = wp::sqrt(var_161);
            // residual = radial_side - r - circle_side + end_radial_offset                   <L 451>
            var_163 = wp::sub(var_147, var_r);
            var_164 = wp::sub(var_163, var_158);
            var_165 = wp::add(var_164, var_162);
            // radial_derivative = (hit_side[0] * ray_direction[0] + hit_side[1] * ray_direction[1]) / radial_side       <L 452>
            var_167 = wp::extract(var_135, var_166);
            var_169 = wp::extract(var_ray_direction, var_168);
            var_170 = wp::mul(var_167, var_169);
            var_172 = wp::extract(var_135, var_171);
            var_174 = wp::extract(var_ray_direction, var_173);
            var_175 = wp::mul(var_172, var_174);
            var_176 = wp::add(var_170, var_175);
            var_177 = wp::div(var_176, var_147);
            // axial_derivative = hit_side[2] * ray_direction[2] / circle_side                <L 453>
            var_179 = wp::extract(var_135, var_178);
            var_181 = wp::extract(var_ray_direction, var_180);
            var_182 = wp::mul(var_179, var_181);
            var_183 = wp::div(var_182, var_158);
            // derivative = radial_derivative + axial_derivative                              <L 454>
            var_184 = wp::add(var_177, var_183);
            // if wp.abs(derivative) > MINVAL:                                                <L 455>
            var_185 = wp::abs(var_184);
            var_186 = (var_185 > var_9);
            if (var_186) {
                // refined_t = min_t - residual / derivative                                  <L 456>
                var_187 = wp::div(var_165, var_184);
                var_188 = wp::sub(var_128, var_187);
                // refined_z = ray_origin[2] + refined_t * ray_direction[2]                   <L 457>
                var_190 = wp::extract(var_ray_origin, var_189);
                var_192 = wp::extract(var_ray_direction, var_191);
                var_193 = wp::mul(var_188, var_192);
                var_194 = wp::add(var_190, var_193);
                // if refined_t >= 0.0 and wp.abs(refined_z) <= h:                            <L 458>
                var_197 = (var_188 >= var_196);
                var_195 = var_197;
                if (var_195) {
                    var_198 = wp::abs(var_194);
                    var_199 = (var_198 <= var_h);
                    var_195 = var_195 && var_199;
                }
                if (var_195) {
                    // min_t = refined_t                                                      <L 459>
                    var_200 = wp::copy(var_188);
                }
                var_201 = wp::where(var_195, var_200, var_128);
            }
            var_202 = wp::where(var_186, var_201, var_128);
        }
        var_203 = wp::where(var_155, var_202, var_128);
    }
    var_204 = wp::where(var_129, var_203, var_128);
    // if wp.abs(ray_direction[2]) > MINVAL:                                                  <L 462>
    var_206 = wp::extract(var_ray_direction, var_205);
    var_207 = wp::abs(var_206);
    var_208 = (var_207 > var_9);
    if (var_208) {
        // inv_d_z = 1.0 / ray_direction[2]                                                   <L 463>
        var_211 = wp::extract(var_ray_direction, var_210);
        var_212 = wp::div(var_209, var_211);
        // t_top = (h - ray_origin[2]) * inv_d_z                                              <L 465>
        var_214 = wp::extract(var_ray_origin, var_213);
        var_215 = wp::sub(var_h, var_214);
        var_216 = wp::mul(var_215, var_212);
        // if t_top >= 0.0:                                                                   <L 466>
        var_218 = (var_216 >= var_217);
        if (var_218) {
            // x = ray_origin[0] + t_top * ray_direction[0]                                   <L 467>
            var_220 = wp::extract(var_ray_origin, var_219);
            var_222 = wp::extract(var_ray_direction, var_221);
            var_223 = wp::mul(var_216, var_222);
            var_224 = wp::add(var_220, var_223);
            // y = ray_origin[1] + t_top * ray_direction[1]                                   <L 468>
            var_226 = wp::extract(var_ray_origin, var_225);
            var_228 = wp::extract(var_ray_direction, var_227);
            var_229 = wp::mul(var_216, var_228);
            var_230 = wp::add(var_226, var_229);
            // if x * x + y * y <= r * r:                                                     <L 469>
            var_231 = wp::mul(var_224, var_224);
            var_232 = wp::mul(var_230, var_230);
            var_233 = wp::add(var_231, var_232);
            var_234 = wp::mul(var_r, var_r);
            var_235 = (var_233 <= var_234);
            if (var_235) {
                // min_t = wp.min(min_t, t_top)                                               <L 470>
                var_236 = wp::min(var_204, var_216);
            }
            var_237 = wp::where(var_235, var_236, var_204);
        }
        var_238 = wp::where(var_218, var_237, var_204);
        // t_bot = (-h - ray_origin[2]) * inv_d_z                                             <L 473>
        var_239 = wp::neg(var_h);
        var_241 = wp::extract(var_ray_origin, var_240);
        var_242 = wp::sub(var_239, var_241);
        var_243 = wp::mul(var_242, var_212);
        // if t_bot >= 0.0:                                                                   <L 474>
        var_245 = (var_243 >= var_244);
        if (var_245) {
            // x = ray_origin[0] + t_bot * ray_direction[0]                                   <L 475>
            var_247 = wp::extract(var_ray_origin, var_246);
            var_249 = wp::extract(var_ray_direction, var_248);
            var_250 = wp::mul(var_243, var_249);
            var_251 = wp::add(var_247, var_250);
            // y = ray_origin[1] + t_bot * ray_direction[1]                                   <L 476>
            var_253 = wp::extract(var_ray_origin, var_252);
            var_255 = wp::extract(var_ray_direction, var_254);
            var_256 = wp::mul(var_243, var_255);
            var_257 = wp::add(var_253, var_256);
            // if x * x + y * y <= r * r:                                                     <L 477>
            var_258 = wp::mul(var_251, var_251);
            var_259 = wp::mul(var_257, var_257);
            var_260 = wp::add(var_258, var_259);
            var_261 = wp::mul(var_r, var_r);
            var_262 = (var_260 <= var_261);
            if (var_262) {
                // min_t = wp.min(min_t, t_bot)                                               <L 478>
                var_263 = wp::min(var_238, var_243);
            }
            var_264 = wp::where(var_262, var_263, var_238);
        }
        var_265 = wp::where(var_245, var_264, var_238);
        var_266 = wp::where(var_245, var_251, var_224);
        var_267 = wp::where(var_245, var_257, var_230);
    }
    var_268 = wp::where(var_208, var_265, var_204);
    // if min_t < 1.0e9:                                                                      <L 480>
    var_270 = (var_268 < var_269);
    if (var_270) {
        // t_hit = min_t                                                                      <L 481>
        var_271 = wp::copy(var_268);
    }
    var_272 = wp::where(var_270, var_271, var_0);
    // if t_hit >= 0.0:                                                                       <L 483>
    var_274 = (var_272 >= var_273);
    if (var_274) {
        // hit_local = ray_origin + t_hit * ray_direction                                     <L 484>
        var_275 = wp::mul(var_272, var_ray_direction);
        var_276 = wp::add(var_ray_origin, var_275);
        // z_clamped = wp.min(h, wp.max(-h, hit_local[2]))                                    <L 485>
        var_277 = wp::neg(var_h);
        var_279 = wp::extract(var_276, var_278);
        var_280 = wp::max(var_277, var_279);
        var_281 = wp::min(var_h, var_280);
        // if z_clamped >= (h - EPSILON) or z_clamped <= (-h + EPSILON):                      <L 486>
        var_284 = wp::sub(var_h, var_283);
        var_285 = (var_281 >= var_284);
        var_282 = var_285;
        if (!var_282) {
            var_286 = wp::neg(var_h);
            var_287 = wp::add(var_286, var_283);
            var_288 = (var_281 <= var_287);
            var_282 = var_282 || var_288;
        }
        if (var_282) {
            // normal_local = wp.vec3(0.0, 0.0, z_clamped)                                    <L 487>
            var_291 = wp::vec_t<3, wp::float32>(var_289, var_290, var_281);
        }
        if (!var_282) {
            // elif barrel_radius > 0.0:                                                      <L 488>
            var_293 = (var_barrel_radius > var_292);
            if (var_293) {
                // radial_length = wp.sqrt(hit_local[0] * hit_local[0] + hit_local[1] * hit_local[1])       <L 489>
                var_295 = wp::extract(var_276, var_294);
                var_297 = wp::extract(var_276, var_296);
                var_298 = wp::mul(var_295, var_297);
                var_300 = wp::extract(var_276, var_299);
                var_302 = wp::extract(var_276, var_301);
                var_303 = wp::mul(var_300, var_302);
                var_304 = wp::add(var_298, var_303);
                var_305 = wp::sqrt(var_304);
                // circle_height = wp.sqrt(barrel_radius * barrel_radius - hit_local[2] * hit_local[2])       <L 490>
                var_306 = wp::mul(var_barrel_radius, var_barrel_radius);
                var_308 = wp::extract(var_276, var_307);
                var_310 = wp::extract(var_276, var_309);
                var_311 = wp::mul(var_308, var_310);
                var_312 = wp::sub(var_306, var_311);
                var_313 = wp::sqrt(var_312);
                // normal_local = wp.vec3(                                                    <L 491>
                // hit_local[0] / radial_length,                                              <L 492>
                var_315 = wp::extract(var_276, var_314);
                var_316 = wp::div(var_315, var_305);
                // hit_local[1] / radial_length,                                              <L 493>
                var_318 = wp::extract(var_276, var_317);
                var_319 = wp::div(var_318, var_305);
                // hit_local[2] / circle_height,                                              <L 494>
                var_321 = wp::extract(var_276, var_320);
                var_322 = wp::div(var_321, var_313);
                var_323 = wp::vec_t<3, wp::float32>(var_316, var_319, var_322);
            }
            if (!var_293) {
                // normal_local = wp.vec3(hit_local[0], hit_local[1], axial_scale * hit_local[2])       <L 497>
                var_325 = wp::extract(var_276, var_324);
                var_327 = wp::extract(var_276, var_326);
                var_329 = wp::extract(var_276, var_328);
                var_330 = wp::mul(var_22, var_329);
                var_331 = wp::vec_t<3, wp::float32>(var_325, var_327, var_330);
            }
            var_332 = wp::where(var_293, var_323, var_331);
        }
        var_333 = wp::where(var_282, var_291, var_332);
        // normal = wp.normalize(normal_local)                                                <L 498>
        var_334 = wp::normalize(var_333);
    }
    var_335 = wp::where(var_274, var_334, var_2);
    // return t_hit, normal                                                                   <L 500>
    ret_0 = var_272;
    ret_1 = var_335;
    return;
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/geometry/raycast.py:503
static void ray_intersect_cone_0(
    wp::vec_t<3, wp::float32> var_ray_origin,
    wp::vec_t<3, wp::float32> var_ray_direction,
    wp::float32 var_radius,
    wp::float32 var_half_height,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    const wp::float32 var_0 = -1.0;
    const wp::float32 var_1 = 0.0;
    wp::vec_t<3, wp::float32> var_2;
    wp::float32 var_3;
    const wp::float32 var_4 = 1e-15;
    bool var_5;
    const wp::float32 var_6 = 0.0;
    bool var_7;
    const wp::float32 var_8 = 0.0;
    const wp::float32 var_9 = 0.0;
    wp::vec_t<3, wp::float32> var_10;
    const wp::float32 var_11 = 0.0;
    const wp::float32 var_12 = 0.0;
    wp::float32 var_13;
    wp::vec_t<3, wp::float32> var_14;
    const wp::float32 var_15 = 0.0;
    wp::float32 var_16;
    wp::vec_t<3, wp::float32> var_17;
    wp::vec_t<3, wp::float32> var_18;
    wp::vec_t<3, wp::float32> var_19;
    wp::float32 var_20;
    wp::float32 var_21;
    wp::float32 var_22;
    wp::float32 var_23;
    wp::float32 var_24;
    wp::float32 var_25;
    const wp::float32 var_26 = 0.0;
    bool var_27;
    wp::vec_t<3, wp::float32> var_28;
    wp::vec_t<3, wp::float32> var_29;
    wp::vec_t<3, wp::float32> var_30;
    wp::float32 var_31;
    wp::float32 var_32;
    wp::float32 var_33;
    wp::float32 var_34;
    bool var_35;
    wp::float32 var_36;
    bool var_37;
    wp::float32 var_38;
    wp::float32 var_39;
    wp::float32 var_40;
    wp::float32 var_41;
    const wp::float32 var_42 = 0.0;
    bool var_43;
    wp::float32 var_44;
    bool var_45;
    wp::float32 var_46;
    wp::float32 var_47;
    wp::vec_t<3, wp::float32> var_48;
    wp::vec_t<3, wp::float32> var_49;
    wp::float32 var_50;
    wp::float32 var_51;
    bool var_52;
    wp::float32 var_53;
    wp::float32 var_54;
    wp::float32 var_55;
    wp::float32 var_56;
    wp::float32 var_57;
    const wp::float32 var_58 = 0.0;
    bool var_59;
    wp::float32 var_60;
    wp::float32 var_61;
    wp::float32 var_62;
    wp::float32 var_63;
    wp::float32 var_64;
    wp::float32 var_65;
    wp::float32 var_66;
    wp::float32 var_67;
    wp::float32 var_68;
    wp::float32 var_69;
    wp::float32 var_70;
    wp::float32 var_71;
    wp::float32 var_72;
    wp::float32 var_73;
    const wp::float32 var_74 = 1.0;
    wp::float32 var_75;
    wp::float32 var_76;
    wp::float32 var_77;
    wp::float32 var_78;
    wp::float32 var_79;
    wp::float32 var_80;
    wp::float32 var_81;
    wp::float32 var_82;
    wp::float32 var_83;
    wp::float32 var_84;
    const wp::float32 var_85 = 2.0;
    wp::float32 var_86;
    wp::float32 var_87;
    wp::float32 var_88;
    wp::float32 var_89;
    wp::float32 var_90;
    wp::float32 var_91;
    wp::float32 var_92;
    wp::float32 var_93;
    bool var_94;
    const wp::float32 var_95 = 0.0;
    bool var_96;
    wp::float32 var_97;
    bool var_98;
    wp::float32 var_99;
    wp::float32 var_100;
    wp::float32 var_101;
    wp::float32 var_102;
    wp::float32 var_103;
    wp::float32 var_104;
    bool var_105;
    const wp::float32 var_106 = 0.0;
    bool var_107;
    bool var_108;
    wp::float32 var_109;
    wp::float32 var_110;
    wp::float32 var_111;
    wp::float32 var_112;
    wp::float32 var_113;
    wp::float32 var_114;
    const wp::float32 var_115 = 0.0;
    bool var_116;
    wp::vec_t<3, wp::float32> var_117;
    wp::vec_t<3, wp::float32> var_118;
    const wp::int32 var_119 = 2;
    wp::float32 var_120;
    wp::float32 var_121;
    wp::float32 var_122;
    const wp::float32 var_123 = 1e-06;
    bool var_124;
    const wp::float32 var_125 = 0.0;
    const wp::float32 var_126 = 0.0;
    const wp::float32 var_127 = 1.0;
    wp::vec_t<3, wp::float32> var_128;
    const wp::int32 var_129 = 2;
    wp::float32 var_130;
    wp::float32 var_131;
    wp::float32 var_132;
    bool var_133;
    const wp::float32 var_134 = 0.0;
    const wp::float32 var_135 = 0.0;
    const wp::float32 var_136 = -1.0;
    wp::vec_t<3, wp::float32> var_137;
    const wp::int32 var_138 = 0;
    wp::float32 var_139;
    const wp::int32 var_140 = 0;
    wp::float32 var_141;
    wp::float32 var_142;
    const wp::int32 var_143 = 1;
    wp::float32 var_144;
    const wp::int32 var_145 = 1;
    wp::float32 var_146;
    wp::float32 var_147;
    wp::float32 var_148;
    wp::float32 var_149;
    bool var_150;
    const wp::float32 var_151 = 0.0;
    const wp::float32 var_152 = 0.0;
    const wp::float32 var_153 = 1.0;
    wp::vec_t<3, wp::float32> var_154;
    const wp::float32 var_155 = 2.0;
    wp::float32 var_156;
    wp::float32 var_157;
    wp::float32 var_158;
    wp::float32 var_159;
    const wp::int32 var_160 = 0;
    wp::float32 var_161;
    const wp::int32 var_162 = 1;
    wp::float32 var_163;
    wp::float32 var_164;
    wp::vec_t<3, wp::float32> var_165;
    wp::vec_t<3, wp::float32> var_166;
    wp::vec_t<3, wp::float32> var_167;
    wp::vec_t<3, wp::float32> var_168;
    wp::vec_t<3, wp::float32> var_169;
    wp::vec_t<3, wp::float32> var_170;
    wp::vec_t<3, wp::float32> var_171;
    //---------
    // forward
    // def ray_intersect_cone(                                                                <L 504>
    // t_hit = -1.0                                                                           <L 520>
    // normal = wp.vec3(0.0)                                                                  <L 521>
    var_2 = wp::vec_t<3, wp::float32>(var_1);
    // if wp.abs(half_height) < MINVAL:                                                       <L 523>
    var_3 = wp::abs(var_half_height);
    var_5 = (var_3 < var_4);
    if (var_5) {
        // return t_hit, normal                                                               <L 524>
        ret_0 = var_0;
        ret_1 = var_2;
        return;
    }
    // if radius <= 0.0:                                                                      <L 526>
    var_7 = (var_radius <= var_6);
    if (var_7) {
        // return t_hit, normal                                                               <L 527>
        ret_0 = var_0;
        ret_1 = var_2;
        return;
    }
    // pa = wp.vec3(0.0, 0.0, half_height)  # tip at +half_height                             <L 531>
    var_10 = wp::vec_t<3, wp::float32>(var_8, var_9, var_half_height);
    // pb = wp.vec3(0.0, 0.0, -half_height)  # base center at -half_height                    <L 532>
    var_13 = wp::neg(var_half_height);
    var_14 = wp::vec_t<3, wp::float32>(var_11, var_12, var_13);
    // ra = 0.0  # radius at tip                                                              <L 533>
    // rb = radius  # radius at base                                                          <L 534>
    var_16 = wp::copy(var_radius);
    // ba = pb - pa                                                                           <L 536>
    var_17 = wp::sub(var_14, var_10);
    // oa = ray_origin - pa                                                                   <L 537>
    var_18 = wp::sub(var_ray_origin, var_10);
    // ob = ray_origin - pb                                                                   <L 538>
    var_19 = wp::sub(var_ray_origin, var_14);
    // m0 = wp.dot(ba, ba)                                                                    <L 539>
    var_20 = wp::dot(var_17, var_17);
    // m1 = wp.dot(oa, ba)                                                                    <L 540>
    var_21 = wp::dot(var_18, var_17);
    // m2 = wp.dot(ray_direction, ba)                                                         <L 541>
    var_22 = wp::dot(var_ray_direction, var_17);
    // m3 = wp.dot(ray_direction, oa)                                                         <L 542>
    var_23 = wp::dot(var_ray_direction, var_18);
    // m5 = wp.dot(oa, oa)                                                                    <L 543>
    var_24 = wp::dot(var_18, var_18);
    // m9 = wp.dot(ob, ba)                                                                    <L 544>
    var_25 = wp::dot(var_19, var_17);
    // if m1 < 0.0:                                                                           <L 547>
    var_27 = (var_21 < var_26);
    if (var_27) {
        // temp = oa * m2 - ray_direction * m1                                                <L 548>
        var_28 = wp::mul(var_18, var_22);
        var_29 = wp::mul(var_ray_direction, var_21);
        var_30 = wp::sub(var_28, var_29);
        // if wp.dot(temp, temp) < (ra * ra * m2 * m2):                                       <L 549>
        var_31 = wp::dot(var_30, var_30);
        var_32 = wp::mul(var_15, var_15);
        var_33 = wp::mul(var_32, var_22);
        var_34 = wp::mul(var_33, var_22);
        var_35 = (var_31 < var_34);
        if (var_35) {
            // if wp.abs(m2) > MINVAL:                                                        <L 550>
            var_36 = wp::abs(var_22);
            var_37 = (var_36 > var_4);
            if (var_37) {
                // t_hit = -m1 / m2                                                           <L 551>
                var_38 = wp::neg(var_21);
                var_39 = wp::div(var_38, var_22);
            }
            var_40 = wp::where(var_37, var_39, var_0);
        }
        var_41 = wp::where(var_35, var_40, var_0);
    }
    if (!var_27) {
        // elif m9 > 0.0:                                                                     <L 552>
        var_43 = (var_25 > var_42);
        if (var_43) {
            // if wp.abs(m2) > MINVAL:                                                        <L 553>
            var_44 = wp::abs(var_22);
            var_45 = (var_44 > var_4);
            if (var_45) {
                // t = -m9 / m2                                                               <L 554>
                var_46 = wp::neg(var_25);
                var_47 = wp::div(var_46, var_22);
                // temp_ob = ob + ray_direction * t                                           <L 555>
                var_48 = wp::mul(var_ray_direction, var_47);
                var_49 = wp::add(var_19, var_48);
                // if wp.dot(temp_ob, temp_ob) < (rb * rb):                                   <L 556>
                var_50 = wp::dot(var_49, var_49);
                var_51 = wp::mul(var_16, var_16);
                var_52 = (var_50 < var_51);
                if (var_52) {
                    // t_hit = t                                                              <L 557>
                    var_53 = wp::copy(var_47);
                }
                var_54 = wp::where(var_52, var_53, var_0);
            }
            var_55 = wp::where(var_45, var_54, var_0);
        }
        var_56 = wp::where(var_43, var_55, var_0);
    }
    var_57 = wp::where(var_27, var_41, var_56);
    // if t_hit < 0.0:                                                                        <L 559>
    var_59 = (var_57 < var_58);
    if (var_59) {
        // rr = ra - rb                                                                       <L 561>
        var_60 = wp::sub(var_15, var_16);
        // hy = m0 + rr * rr                                                                  <L 562>
        var_61 = wp::mul(var_60, var_60);
        var_62 = wp::add(var_20, var_61);
        // k2 = m0 * m0 - m2 * m2 * hy                                                        <L 563>
        var_63 = wp::mul(var_20, var_20);
        var_64 = wp::mul(var_22, var_22);
        var_65 = wp::mul(var_64, var_62);
        var_66 = wp::sub(var_63, var_65);
        // k1 = m0 * m0 * m3 - m1 * m2 * hy + m0 * ra * (rr * m2 * 1.0)                       <L 564>
        var_67 = wp::mul(var_20, var_20);
        var_68 = wp::mul(var_67, var_23);
        var_69 = wp::mul(var_21, var_22);
        var_70 = wp::mul(var_69, var_62);
        var_71 = wp::sub(var_68, var_70);
        var_72 = wp::mul(var_20, var_15);
        var_73 = wp::mul(var_60, var_22);
        var_75 = wp::mul(var_73, var_74);
        var_76 = wp::mul(var_72, var_75);
        var_77 = wp::add(var_71, var_76);
        // k0 = m0 * m0 * m5 - m1 * m1 * hy + m0 * ra * (rr * m1 * 2.0 - m0 * ra)             <L 565>
        var_78 = wp::mul(var_20, var_20);
        var_79 = wp::mul(var_78, var_24);
        var_80 = wp::mul(var_21, var_21);
        var_81 = wp::mul(var_80, var_62);
        var_82 = wp::sub(var_79, var_81);
        var_83 = wp::mul(var_20, var_15);
        var_84 = wp::mul(var_60, var_21);
        var_86 = wp::mul(var_84, var_85);
        var_87 = wp::mul(var_20, var_15);
        var_88 = wp::sub(var_86, var_87);
        var_89 = wp::mul(var_83, var_88);
        var_90 = wp::add(var_82, var_89);
        // h = k1 * k1 - k2 * k0                                                              <L 566>
        var_91 = wp::mul(var_77, var_77);
        var_92 = wp::mul(var_66, var_90);
        var_93 = wp::sub(var_91, var_92);
        // if h >= 0.0 and wp.abs(k2) >= MINVAL:                                              <L 568>
        var_96 = (var_93 >= var_95);
        var_94 = var_96;
        if (var_94) {
            var_97 = wp::abs(var_66);
            var_98 = (var_97 >= var_4);
            var_94 = var_94 && var_98;
        }
        if (var_94) {
            // t = (-k1 - wp.sqrt(h)) / k2                                                    <L 569>
            var_99 = wp::neg(var_77);
            var_100 = wp::sqrt(var_93);
            var_101 = wp::sub(var_99, var_100);
            var_102 = wp::div(var_101, var_66);
            // y = m1 + t * m2                                                                <L 570>
            var_103 = wp::mul(var_102, var_22);
            var_104 = wp::add(var_21, var_103);
            // if y >= 0.0 and y <= m0:                                                       <L 571>
            var_107 = (var_104 >= var_106);
            var_105 = var_107;
            if (var_105) {
                var_108 = (var_104 <= var_20);
                var_105 = var_105 && var_108;
            }
            if (var_105) {
                // t_hit = t                                                                  <L 572>
                var_109 = wp::copy(var_102);
            }
            var_110 = wp::where(var_105, var_109, var_57);
        }
        var_111 = wp::where(var_94, var_110, var_57);
        var_112 = wp::where(var_94, var_102, var_47);
    }
    var_113 = wp::where(var_59, var_111, var_57);
    var_114 = wp::where(var_59, var_112, var_47);
    // if t_hit >= 0.0:                                                                       <L 574>
    var_116 = (var_113 >= var_115);
    if (var_116) {
        // hit_local = ray_origin + t_hit * ray_direction                                     <L 575>
        var_117 = wp::mul(var_113, var_ray_direction);
        var_118 = wp::add(var_ray_origin, var_117);
        // if wp.abs(hit_local[2] - half_height) <= EPSILON:                                  <L 576>
        var_120 = wp::extract(var_118, var_119);
        var_121 = wp::sub(var_120, var_half_height);
        var_122 = wp::abs(var_121);
        var_124 = (var_122 <= var_123);
        if (var_124) {
            // normal_local = wp.vec3(0.0, 0.0, 1.0)                                          <L 577>
            var_128 = wp::vec_t<3, wp::float32>(var_125, var_126, var_127);
        }
        if (!var_124) {
            // elif wp.abs(hit_local[2] + half_height) <= EPSILON:                            <L 578>
            var_130 = wp::extract(var_118, var_129);
            var_131 = wp::add(var_130, var_half_height);
            var_132 = wp::abs(var_131);
            var_133 = (var_132 <= var_123);
            if (var_133) {
                // normal_local = wp.vec3(0.0, 0.0, -1.0)                                     <L 579>
                var_137 = wp::vec_t<3, wp::float32>(var_134, var_135, var_136);
            }
            if (!var_133) {
                // radial_sq = hit_local[0] * hit_local[0] + hit_local[1] * hit_local[1]       <L 581>
                var_139 = wp::extract(var_118, var_138);
                var_141 = wp::extract(var_118, var_140);
                var_142 = wp::mul(var_139, var_141);
                var_144 = wp::extract(var_118, var_143);
                var_146 = wp::extract(var_118, var_145);
                var_147 = wp::mul(var_144, var_146);
                var_148 = wp::add(var_142, var_147);
                // radial = wp.sqrt(radial_sq)                                                <L 582>
                var_149 = wp::sqrt(var_148);
                // if radial <= EPSILON:                                                      <L 583>
                var_150 = (var_149 <= var_123);
                if (var_150) {
                    // normal_local = wp.vec3(0.0, 0.0, 1.0)                                  <L 584>
                    var_154 = wp::vec_t<3, wp::float32>(var_151, var_152, var_153);
                }
                if (!var_150) {
                    // denom = wp.max(2.0 * wp.abs(half_height), EPSILON)                     <L 586>
                    var_156 = wp::abs(var_half_height);
                    var_157 = wp::mul(var_155, var_156);
                    var_158 = wp::max(var_157, var_123);
                    // slope = radius / denom                                                 <L 587>
                    var_159 = wp::div(var_radius, var_158);
                    // normal_local = wp.normalize(wp.vec3(hit_local[0], hit_local[1], slope * radial))       <L 588>
                    var_161 = wp::extract(var_118, var_160);
                    var_163 = wp::extract(var_118, var_162);
                    var_164 = wp::mul(var_159, var_149);
                    var_165 = wp::vec_t<3, wp::float32>(var_161, var_163, var_164);
                    var_166 = wp::normalize(var_165);
                }
                var_167 = wp::where(var_150, var_154, var_166);
            }
            var_168 = wp::where(var_133, var_137, var_167);
        }
        var_169 = wp::where(var_124, var_128, var_168);
        // normal = wp.normalize(normal_local)                                                <L 589>
        var_170 = wp::normalize(var_169);
    }
    var_171 = wp::where(var_116, var_170, var_2);
    // return t_hit, normal                                                                   <L 591>
    ret_0 = var_113;
    ret_1 = var_171;
    return;
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/geometry/raycast.py:161
static void ray_intersect_ellipsoid_0(
    wp::vec_t<3, wp::float32> var_ray_origin,
    wp::vec_t<3, wp::float32> var_ray_direction,
    wp::vec_t<3, wp::float32> var_semi_axes,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    const wp::float32 var_0 = -1.0;
    const wp::float32 var_1 = 0.0;
    wp::vec_t<3, wp::float32> var_2;
    wp::float32 var_3;
    const wp::float32 var_4 = 1e-15;
    bool var_5;
    wp::vec_t<3, wp::float32> var_6;
    bool var_7;
    const wp::int32 var_8 = 0;
    wp::float32 var_9;
    bool var_10;
    const wp::int32 var_11 = 1;
    wp::float32 var_12;
    bool var_13;
    const wp::int32 var_14 = 2;
    wp::float32 var_15;
    bool var_16;
    wp::vec_t<3, wp::float32> var_17;
    wp::vec_t<3, wp::float32> var_18;
    wp::float32 var_19;
    wp::float32 var_20;
    wp::float32 var_21;
    wp::float32 var_22;
    const wp::float32 var_23 = 1.0;
    wp::float32 var_24;
    wp::float32 var_25;
    wp::float32 var_26;
    const wp::float32 var_27 = 0.0;
    bool var_28;
    wp::float32 var_29;
    wp::float32 var_30;
    wp::float32 var_31;
    wp::float32 var_32;
    wp::float32 var_33;
    wp::float32 var_34;
    wp::float32 var_35;
    const wp::float32 var_36 = 0.0;
    bool var_37;
    wp::float32 var_38;
    const wp::float32 var_39 = 0.0;
    bool var_40;
    wp::float32 var_41;
    wp::float32 var_42;
    wp::float32 var_43;
    const wp::float32 var_44 = 0.0;
    bool var_45;
    wp::vec_t<3, wp::float32> var_46;
    wp::vec_t<3, wp::float32> var_47;
    const wp::float32 var_48 = 1.0;
    wp::vec_t<3, wp::float32> var_49;
    wp::vec_t<3, wp::float32> var_50;
    wp::vec_t<3, wp::float32> var_51;
    wp::vec_t<3, wp::float32> var_52;
    wp::vec_t<3, wp::float32> var_53;
    wp::vec_t<3, wp::float32> var_54;
    //---------
    // forward
    // def ray_intersect_ellipsoid(ray_origin: wp.vec3, ray_direction: wp.vec3, semi_axes: wp.vec3) -> tuple[float, wp.vec3]:       <L 162>
    // t_hit = -1.0                                                                           <L 176>
    // normal = wp.vec3(0.0)                                                                  <L 177>
    var_2 = wp::vec_t<3, wp::float32>(var_1);
    // d_len_sq = wp.dot(ray_direction, ray_direction)                                        <L 180>
    var_3 = wp::dot(var_ray_direction, var_ray_direction);
    // if d_len_sq < MINVAL:                                                                  <L 181>
    var_5 = (var_3 < var_4);
    if (var_5) {
        // return t_hit, normal                                                               <L 182>
        ret_0 = var_0;
        ret_1 = var_2;
        return;
    }
    // ra = semi_axes                                                                         <L 184>
    var_6 = wp::copy(var_semi_axes);
    // if ra[0] < MINVAL or ra[1] < MINVAL or ra[2] < MINVAL:                                 <L 187>
    var_9 = wp::extract(var_6, var_8);
    var_10 = (var_9 < var_4);
    var_7 = var_10;
    if (!var_7) {
        var_12 = wp::extract(var_6, var_11);
        var_13 = (var_12 < var_4);
        var_7 = var_7 || var_13;
    }
    if (!var_7) {
        var_15 = wp::extract(var_6, var_14);
        var_16 = (var_15 < var_4);
        var_7 = var_7 || var_16;
    }
    if (var_7) {
        // return t_hit, normal                                                               <L 188>
        ret_0 = var_0;
        ret_1 = var_2;
        return;
    }
    // ocn = wp.cw_div(ray_origin, ra)                                                        <L 191>
    var_17 = wp::cw_div(var_ray_origin, var_6);
    // rdn = wp.cw_div(ray_direction, ra)                                                     <L 192>
    var_18 = wp::cw_div(var_ray_direction, var_6);
    // a = wp.dot(rdn, rdn)                                                                   <L 194>
    var_19 = wp::dot(var_18, var_18);
    // b = wp.dot(ocn, rdn)                                                                   <L 195>
    var_20 = wp::dot(var_17, var_18);
    // c = wp.dot(ocn, ocn)                                                                   <L 196>
    var_21 = wp::dot(var_17, var_17);
    // h = b * b - a * (c - 1.0)                                                              <L 198>
    var_22 = wp::mul(var_20, var_20);
    var_24 = wp::sub(var_21, var_23);
    var_25 = wp::mul(var_19, var_24);
    var_26 = wp::sub(var_22, var_25);
    // if h < 0.0:                                                                            <L 199>
    var_28 = (var_26 < var_27);
    if (var_28) {
        // return t_hit, normal  # No intersection                                            <L 200>
        ret_0 = var_0;
        ret_1 = var_2;
        return;
    }
    // h = wp.sqrt(h)                                                                         <L 202>
    var_29 = wp::sqrt(var_26);
    // t1 = (-b - h) / a                                                                      <L 205>
    var_30 = wp::neg(var_20);
    var_31 = wp::sub(var_30, var_29);
    var_32 = wp::div(var_31, var_19);
    // t2 = (-b + h) / a                                                                      <L 206>
    var_33 = wp::neg(var_20);
    var_34 = wp::add(var_33, var_29);
    var_35 = wp::div(var_34, var_19);
    // if t1 >= 0.0:                                                                          <L 209>
    var_37 = (var_32 >= var_36);
    if (var_37) {
        // t_hit = t1                                                                         <L 210>
        var_38 = wp::copy(var_32);
    }
    if (!var_37) {
        // elif t2 >= 0.0:                                                                    <L 211>
        var_40 = (var_35 >= var_39);
        if (var_40) {
            // t_hit = t2                                                                     <L 212>
            var_41 = wp::copy(var_35);
        }
        var_42 = wp::where(var_40, var_41, var_0);
    }
    var_43 = wp::where(var_37, var_38, var_42);
    // if t_hit >= 0.0:                                                                       <L 214>
    var_45 = (var_43 >= var_44);
    if (var_45) {
        // hit_local = ray_origin + t_hit * ray_direction                                     <L 215>
        var_46 = wp::mul(var_43, var_ray_direction);
        var_47 = wp::add(var_ray_origin, var_46);
        // inv_size = safe_div_vec3(wp.vec3(1.0), semi_axes)                                  <L 216>
        var_49 = wp::vec_t<3, wp::float32>(var_48);
        var_50 = safe_div_vec3_0(var_49, var_semi_axes);
        // inv_size_sq = wp.cw_mul(inv_size, inv_size)                                        <L 217>
        var_51 = wp::cw_mul(var_50, var_50);
        // normal = wp.normalize(wp.cw_mul(hit_local, inv_size_sq))                           <L 218>
        var_52 = wp::cw_mul(var_47, var_51);
        var_53 = wp::normalize(var_52);
    }
    var_54 = wp::where(var_45, var_53, var_2);
    // return t_hit, normal                                                                   <L 220>
    ret_0 = var_43;
    ret_1 = var_54;
    return;
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/geometry/raycast.py:745
static void _make_ray_intersect_shape__locals__ray_intersect_shape_0(
    wp::transform_t<wp::float32> var_geom_to_world,
    wp::vec_t<3, wp::float32> var_size,
    wp::int32 var_geomtype,
    wp::vec_t<3, wp::float32> var_ray_origin,
    wp::vec_t<3, wp::float32> var_ray_direction,
    bool var_enable_backface_culling,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    const wp::vec_t<3, wp::float32> var_2 = wp::initializer_array<3,wp::float32>{1.0, 1.0, 1.0};
    const wp::float32 var_3 = -1.0;
    const wp::float32 var_4 = 0.0;
    wp::vec_t<3, wp::float32> var_5;
    const wp::int32 var_6 = 1;
    bool var_7;
    wp::float32 var_8;
    wp::vec_t<3, wp::float32> var_9;
    const wp::int32 var_10 = 3;
    bool var_11;
    const wp::int32 var_12 = 0;
    wp::float32 var_13;
    wp::float32 var_14;
    wp::vec_t<3, wp::float32> var_15;
    const wp::int32 var_16 = 7;
    bool var_17;
    wp::float32 var_18;
    wp::vec_t<3, wp::float32> var_19;
    const wp::int32 var_20 = 4;
    bool var_21;
    const wp::int32 var_22 = 0;
    wp::float32 var_23;
    const wp::int32 var_24 = 1;
    wp::float32 var_25;
    wp::float32 var_26;
    wp::vec_t<3, wp::float32> var_27;
    const wp::int32 var_28 = 6;
    bool var_29;
    const wp::int32 var_30 = 0;
    wp::float32 var_31;
    const wp::int32 var_32 = 1;
    wp::float32 var_33;
    const wp::int32 var_34 = 2;
    wp::float32 var_35;
    wp::float32 var_36;
    wp::vec_t<3, wp::float32> var_37;
    const wp::int32 var_38 = 9;
    bool var_39;
    const wp::int32 var_40 = 0;
    wp::float32 var_41;
    const wp::int32 var_42 = 1;
    wp::float32 var_43;
    wp::float32 var_44;
    wp::vec_t<3, wp::float32> var_45;
    const wp::int32 var_46 = 5;
    bool var_47;
    wp::float32 var_48;
    wp::vec_t<3, wp::float32> var_49;
    wp::float32 var_50;
    wp::vec_t<3, wp::float32> var_51;
    wp::float32 var_52;
    wp::vec_t<3, wp::float32> var_53;
    wp::float32 var_54;
    wp::vec_t<3, wp::float32> var_55;
    wp::float32 var_56;
    wp::vec_t<3, wp::float32> var_57;
    wp::float32 var_58;
    wp::vec_t<3, wp::float32> var_59;
    wp::float32 var_60;
    wp::vec_t<3, wp::float32> var_61;
    wp::float32 var_62;
    wp::vec_t<3, wp::float32> var_63;
    const wp::float32 var_64 = 0.0;
    wp::vec_t<3, wp::float32> var_65;
    const bool var_66 = true;
    const wp::float32 var_67 = 0.0;
    bool var_68;
    wp::vec_t<3, wp::float32> var_69;
    wp::vec_t<3, wp::float32> var_70;
    wp::vec_t<3, wp::float32> var_71;
    //---------
    // forward
    // def ray_intersect_shape(                                                               <L 746>
    // ray_origin_local, ray_direction_local = map_ray_to_local(geom_to_world, ray_origin, ray_direction)       <L 772>
    map_ray_to_local_0(var_geom_to_world, var_ray_origin, var_ray_direction, var_2, var_0, var_1);
    // t_hit = -1.0                                                                           <L 774>
    // normal_local = wp.vec3(0.0)                                                            <L 775>
    var_5 = wp::vec_t<3, wp::float32>(var_4);
    // if geomtype == GeoType.PLANE:                                                          <L 777>
    var_7 = (var_geomtype == var_6);
    if (var_7) {
        // t_hit, normal_local = ray_intersect_plane(                                         <L 778>
        // ray_origin_local, ray_direction_local, size, enable_backface_culling               <L 779>
        ray_intersect_plane_0(var_0, var_1, var_size, var_enable_backface_culling, var_8, var_9);
    }
    if (!var_7) {
        // elif geomtype == GeoType.SPHERE:                                                   <L 781>
        var_11 = (var_geomtype == var_10);
        if (var_11) {
            // t_hit, normal_local = ray_intersect_sphere(ray_origin_local, ray_direction_local, size[0])       <L 782>
            var_13 = wp::extract(var_size, var_12);
            ray_intersect_sphere_0(var_0, var_1, var_13, var_14, var_15);
        }
        if (!var_11) {
            // elif geomtype == GeoType.BOX:                                                  <L 783>
            var_17 = (var_geomtype == var_16);
            if (var_17) {
                // t_hit, normal_local = ray_intersect_box(ray_origin_local, ray_direction_local, size)       <L 784>
                ray_intersect_box_0(var_0, var_1, var_size, var_18, var_19);
            }
            if (!var_17) {
                // elif geomtype == GeoType.CAPSULE:                                          <L 785>
                var_21 = (var_geomtype == var_20);
                if (var_21) {
                    // t_hit, normal_local = ray_intersect_capsule(ray_origin_local, ray_direction_local, size[0], size[1])       <L 786>
                    var_23 = wp::extract(var_size, var_22);
                    var_25 = wp::extract(var_size, var_24);
                    ray_intersect_capsule_0(var_0, var_1, var_23, var_25, var_26, var_27);
                }
                if (!var_21) {
                    // elif geomtype == GeoType.CYLINDER:                                     <L 787>
                    var_29 = (var_geomtype == var_28);
                    if (var_29) {
                        // t_hit, normal_local = ray_intersect_cylinder(                      <L 788>
                        // ray_origin_local, ray_direction_local, size[0], size[1], size[2]       <L 789>
                        var_31 = wp::extract(var_size, var_30);
                        var_33 = wp::extract(var_size, var_32);
                        var_35 = wp::extract(var_size, var_34);
                        ray_intersect_cylinder_0(var_0, var_1, var_31, var_33, var_35, var_36, var_37);
                    }
                    if (!var_29) {
                        // elif geomtype == GeoType.CONE:                                     <L 791>
                        var_39 = (var_geomtype == var_38);
                        if (var_39) {
                            // t_hit, normal_local = ray_intersect_cone(ray_origin_local, ray_direction_local, size[0], size[1])       <L 792>
                            var_41 = wp::extract(var_size, var_40);
                            var_43 = wp::extract(var_size, var_42);
                            ray_intersect_cone_0(var_0, var_1, var_41, var_43, var_44, var_45);
                        }
                        if (!var_39) {
                            // elif geomtype == GeoType.ELLIPSOID:                            <L 793>
                            var_47 = (var_geomtype == var_46);
                            if (var_47) {
                                // t_hit, normal_local = ray_intersect_ellipsoid(ray_origin_local, ray_direction_local, size)       <L 794>
                                ray_intersect_ellipsoid_0(var_0, var_1, var_size, var_48, var_49);
                            }
                            var_50 = wp::where(var_47, var_48, var_3);
                            var_51 = wp::where(var_47, var_49, var_5);
                        }
                        var_52 = wp::where(var_39, var_44, var_50);
                        var_53 = wp::where(var_39, var_45, var_51);
                    }
                    var_54 = wp::where(var_29, var_36, var_52);
                    var_55 = wp::where(var_29, var_37, var_53);
                }
                var_56 = wp::where(var_21, var_26, var_54);
                var_57 = wp::where(var_21, var_27, var_55);
            }
            var_58 = wp::where(var_17, var_18, var_56);
            var_59 = wp::where(var_17, var_19, var_57);
        }
        var_60 = wp::where(var_11, var_14, var_58);
        var_61 = wp::where(var_11, var_15, var_59);
    }
    var_62 = wp::where(var_7, var_8, var_60);
    var_63 = wp::where(var_7, var_9, var_61);
    // normal = wp.vec3(0.0)                                                                  <L 796>
    var_65 = wp::vec_t<3, wp::float32>(var_64);
    // if wp.static(compute_normal):                                                          <L 797>
    // if t_hit >= 0.0:                                                                       <L 798>
    var_68 = (var_62 >= var_67);
    if (var_68) {
        // normal = wp.normalize(wp.transform_vector(geom_to_world, normal_local))            <L 799>
        var_69 = wp::transform_vector(var_geom_to_world, var_63);
        var_70 = wp::normalize(var_69);
    }
    var_71 = wp::where(var_68, var_70, var_65);
    // return t_hit, normal                                                                   <L 801>
    ret_0 = var_62;
    ret_1 = var_71;
    return;
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/geometry/raycast.py:28
static void _spinlock_acquire_0(
    wp::array_t<wp::int32> var_lock)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    const wp::int32 var_1 = 0;
    const wp::int32 var_2 = 1;
    wp::int32 var_3;
    const wp::int32 var_4 = 1;
    bool var_5;
    //---------
    // forward
    // def _spinlock_acquire(lock: wp.array[wp.int32]):                                       <L 29>
    // while wp.atomic_cas(lock, 0, 0, 1) == 1:                                               <L 31>
    start_while_0:;
    var_3 = wp::atomic_cas(var_lock, var_0, var_1, var_2);
    var_5 = (var_3 == var_4);
    if ((var_5) == false) goto end_while_0;
        // pass                                                                               <L 32>
    goto start_while_0;
    end_while_0:;
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/geometry/raycast.py:35
static void _spinlock_release_0(
    wp::array_t<wp::int32> var_lock)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    const wp::int32 var_1 = 0;
    wp::int32 var_2;
    //---------
    // forward
    // def _spinlock_release(lock: wp.array[wp.int32]):                                       <L 36>
    // wp.atomic_exch(lock, 0, 0)                                                             <L 38>
    var_2 = wp::atomic_exch(var_lock, var_0, var_1);
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/geometry/raycast.py:41
static void adj_safe_div_vec3_0(
    wp::vec_t<3, wp::float32> var_x,
    wp::vec_t<3, wp::float32> var_y,
    wp::vec_t<3, wp::float32> & adj_x,
    wp::vec_t<3, wp::float32> & adj_y,
    wp::vec_t<3, wp::float32> & adj_ret)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    wp::float32 var_1;
    const wp::int32 var_2 = 0;
    wp::float32 var_3;
    const wp::float32 var_4 = 0.0;
    bool var_5;
    const wp::int32 var_6 = 0;
    wp::float32 var_7;
    const wp::float32 var_8 = 1e-06;
    wp::float32 var_9;
    wp::float32 var_10;
    const wp::int32 var_11 = 1;
    wp::float32 var_12;
    const wp::int32 var_13 = 1;
    wp::float32 var_14;
    const wp::float32 var_15 = 0.0;
    bool var_16;
    const wp::int32 var_17 = 1;
    wp::float32 var_18;
    wp::float32 var_19;
    wp::float32 var_20;
    const wp::int32 var_21 = 2;
    wp::float32 var_22;
    const wp::int32 var_23 = 2;
    wp::float32 var_24;
    const wp::float32 var_25 = 0.0;
    bool var_26;
    const wp::int32 var_27 = 2;
    wp::float32 var_28;
    wp::float32 var_29;
    wp::float32 var_30;
    wp::vec_t<3, wp::float32> var_31;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    wp::float32 adj_1 = {};
    wp::int32 adj_2 = {};
    wp::float32 adj_3 = {};
    wp::float32 adj_4 = {};
    bool adj_5 = {};
    wp::int32 adj_6 = {};
    wp::float32 adj_7 = {};
    wp::float32 adj_8 = {};
    wp::float32 adj_9 = {};
    wp::float32 adj_10 = {};
    wp::int32 adj_11 = {};
    wp::float32 adj_12 = {};
    wp::int32 adj_13 = {};
    wp::float32 adj_14 = {};
    wp::float32 adj_15 = {};
    bool adj_16 = {};
    wp::int32 adj_17 = {};
    wp::float32 adj_18 = {};
    wp::float32 adj_19 = {};
    wp::float32 adj_20 = {};
    wp::int32 adj_21 = {};
    wp::float32 adj_22 = {};
    wp::int32 adj_23 = {};
    wp::float32 adj_24 = {};
    wp::float32 adj_25 = {};
    bool adj_26 = {};
    wp::int32 adj_27 = {};
    wp::float32 adj_28 = {};
    wp::float32 adj_29 = {};
    wp::float32 adj_30 = {};
    wp::vec_t<3, wp::float32> adj_31 = {};
    //---------
    // forward
    // def safe_div_vec3(x: wp.vec3, y: wp.vec3) -> wp.vec3:                                  <L 42>
    // return wp.vec3(                                                                        <L 44>
    // x[0] / wp.where(y[0] != 0.0, y[0], EPSILON),                                           <L 45>
    var_1 = wp::extract(var_x, var_0);
    var_3 = wp::extract(var_y, var_2);
    var_5 = (var_3 != var_4);
    var_7 = wp::extract(var_y, var_6);
    var_9 = wp::where(var_5, var_7, var_8);
    var_10 = wp::div(var_1, var_9);
    // x[1] / wp.where(y[1] != 0.0, y[1], EPSILON),                                           <L 46>
    var_12 = wp::extract(var_x, var_11);
    var_14 = wp::extract(var_y, var_13);
    var_16 = (var_14 != var_15);
    var_18 = wp::extract(var_y, var_17);
    var_19 = wp::where(var_16, var_18, var_8);
    var_20 = wp::div(var_12, var_19);
    // x[2] / wp.where(y[2] != 0.0, y[2], EPSILON),                                           <L 47>
    var_22 = wp::extract(var_x, var_21);
    var_24 = wp::extract(var_y, var_23);
    var_26 = (var_24 != var_25);
    var_28 = wp::extract(var_y, var_27);
    var_29 = wp::where(var_26, var_28, var_8);
    var_30 = wp::div(var_22, var_29);
    var_31 = wp::vec_t<3, wp::float32>(var_10, var_20, var_30);
    goto label0;
    //---------
    // reverse
    label0:;
    adj_31 += adj_ret;
    wp::adj_vec_t(var_10, var_20, var_30, adj_10, adj_20, adj_30, adj_31);
    wp::adj_div(var_22, var_29, var_30, adj_22, adj_29, adj_30);
    wp::adj_where(var_26, var_28, var_8, adj_26, adj_28, adj_8, adj_29);
    wp::adj_extract(var_y, var_27, adj_y, adj_27, adj_28);
    wp::adj_extract(var_y, var_23, adj_y, adj_23, adj_24);
    wp::adj_extract(var_x, var_21, adj_x, adj_21, adj_22);
    // adj: x[2] / wp.where(y[2] != 0.0, y[2], EPSILON),                                      <L 47>
    wp::adj_div(var_12, var_19, var_20, adj_12, adj_19, adj_20);
    wp::adj_where(var_16, var_18, var_8, adj_16, adj_18, adj_8, adj_19);
    wp::adj_extract(var_y, var_17, adj_y, adj_17, adj_18);
    wp::adj_extract(var_y, var_13, adj_y, adj_13, adj_14);
    wp::adj_extract(var_x, var_11, adj_x, adj_11, adj_12);
    // adj: x[1] / wp.where(y[1] != 0.0, y[1], EPSILON),                                      <L 46>
    wp::adj_div(var_1, var_9, var_10, adj_1, adj_9, adj_10);
    wp::adj_where(var_5, var_7, var_8, adj_5, adj_7, adj_8, adj_9);
    wp::adj_extract(var_y, var_6, adj_y, adj_6, adj_7);
    wp::adj_extract(var_y, var_2, adj_y, adj_2, adj_3);
    wp::adj_extract(var_x, var_0, adj_x, adj_0, adj_1);
    // adj: x[0] / wp.where(y[0] != 0.0, y[0], EPSILON),                                      <L 45>
    // adj: return wp.vec3(                                                                   <L 44>
    // adj: def safe_div_vec3(x: wp.vec3, y: wp.vec3) -> wp.vec3:                             <L 42>
    return;
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/geometry/raycast.py:51
static void adj_map_ray_to_local_0(
    wp::transform_t<wp::float32> var_transform,
    wp::vec_t<3, wp::float32> var_ray_origin,
    wp::vec_t<3, wp::float32> var_ray_direction,
    wp::vec_t<3, wp::float32> var_scale,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::transform_t<wp::float32> & adj_transform,
    wp::vec_t<3, wp::float32> & adj_ray_origin,
    wp::vec_t<3, wp::float32> & adj_ray_direction,
    wp::vec_t<3, wp::float32> & adj_scale,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
    //---------
    // primal vars
    wp::transform_t<wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    bool var_3;
    const wp::int32 var_4 = 0;
    wp::float32 var_5;
    const wp::float32 var_6 = 1.0;
    bool var_7;
    const wp::int32 var_8 = 1;
    wp::float32 var_9;
    const wp::float32 var_10 = 1.0;
    bool var_11;
    const wp::int32 var_12 = 2;
    wp::float32 var_13;
    const wp::float32 var_14 = 1.0;
    bool var_15;
    const wp::float32 var_16 = 1.0;
    wp::vec_t<3, wp::float32> var_17;
    wp::vec_t<3, wp::float32> var_18;
    wp::vec_t<3, wp::float32> var_19;
    wp::vec_t<3, wp::float32> var_20;
    wp::vec_t<3, wp::float32> var_21;
    wp::vec_t<3, wp::float32> var_22;
    //---------
    // dual vars
    wp::transform_t<wp::float32> adj_0 = {};
    wp::vec_t<3, wp::float32> adj_1 = {};
    wp::vec_t<3, wp::float32> adj_2 = {};
    bool adj_3 = {};
    wp::int32 adj_4 = {};
    wp::float32 adj_5 = {};
    wp::float32 adj_6 = {};
    bool adj_7 = {};
    wp::int32 adj_8 = {};
    wp::float32 adj_9 = {};
    wp::float32 adj_10 = {};
    bool adj_11 = {};
    wp::int32 adj_12 = {};
    wp::float32 adj_13 = {};
    wp::float32 adj_14 = {};
    bool adj_15 = {};
    wp::float32 adj_16 = {};
    wp::vec_t<3, wp::float32> adj_17 = {};
    wp::vec_t<3, wp::float32> adj_18 = {};
    wp::vec_t<3, wp::float32> adj_19 = {};
    wp::vec_t<3, wp::float32> adj_20 = {};
    wp::vec_t<3, wp::float32> adj_21 = {};
    wp::vec_t<3, wp::float32> adj_22 = {};
    //---------
    // forward
    // def map_ray_to_local(                                                                  <L 52>
    // inv_transform = wp.transform_inverse(transform)                                        <L 69>
    var_0 = wp::transform_inverse(var_transform);
    // ray_origin_local = wp.transform_point(inv_transform, ray_origin)                       <L 70>
    var_1 = wp::transform_point(var_0, var_ray_origin);
    // ray_direction_local = wp.transform_vector(inv_transform, ray_direction)                <L 71>
    var_2 = wp::transform_vector(var_0, var_ray_direction);
    // if scale[0] != 1.0 or scale[1] != 1.0 or scale[2] != 1.0:                              <L 72>
    var_5 = wp::extract(var_scale, var_4);
    var_7 = (var_5 != var_6);
    var_3 = var_7;
    if (!var_3) {
        var_9 = wp::extract(var_scale, var_8);
        var_11 = (var_9 != var_10);
        var_3 = var_3 || var_11;
    }
    if (!var_3) {
        var_13 = wp::extract(var_scale, var_12);
        var_15 = (var_13 != var_14);
        var_3 = var_3 || var_15;
    }
    if (var_3) {
        // inv_size = safe_div_vec3(wp.vec3(1.0), scale)                                      <L 73>
        var_17 = wp::vec_t<3, wp::float32>(var_16);
        var_18 = safe_div_vec3_0(var_17, var_scale);
        // ray_origin_local = wp.cw_mul(ray_origin_local, inv_size)                           <L 74>
        var_19 = wp::cw_mul(var_1, var_18);
        // ray_direction_local = wp.cw_mul(ray_direction_local, inv_size)                     <L 75>
        var_20 = wp::cw_mul(var_2, var_18);
    }
    var_21 = wp::where(var_3, var_19, var_1);
    var_22 = wp::where(var_3, var_20, var_2);
    // return ray_origin_local, ray_direction_local                                           <L 76>
    ret_0 = var_21;
    ret_1 = var_22;
    goto label0;
    //---------
    // reverse
    label0:;
    adj_22 += adj_ret_1;
    adj_21 += adj_ret_0;
    // adj: return ray_origin_local, ray_direction_local                                      <L 76>
    wp::adj_where(var_3, var_20, var_2, adj_3, adj_20, adj_2, adj_22);
    wp::adj_where(var_3, var_19, var_1, adj_3, adj_19, adj_1, adj_21);
    if (var_3) {
        wp::adj_cw_mul(var_2, var_18, adj_2, adj_18, adj_20);
        // adj: ray_direction_local = wp.cw_mul(ray_direction_local, inv_size)                <L 75>
        wp::adj_cw_mul(var_1, var_18, adj_1, adj_18, adj_19);
        // adj: ray_origin_local = wp.cw_mul(ray_origin_local, inv_size)                      <L 74>
        adj_safe_div_vec3_0(var_17, var_scale, adj_17, adj_scale, adj_18);
        wp::adj_vec_t(var_16, adj_16, adj_17);
        // adj: inv_size = safe_div_vec3(wp.vec3(1.0), scale)                                 <L 73>
    }
    if (!var_3) {
        wp::adj_extract(var_scale, var_12, adj_scale, adj_12, adj_13);
    }
    if (!var_3) {
        wp::adj_extract(var_scale, var_8, adj_scale, adj_8, adj_9);
    }
    wp::adj_extract(var_scale, var_4, adj_scale, adj_4, adj_5);
    // adj: if scale[0] != 1.0 or scale[1] != 1.0 or scale[2] != 1.0:                         <L 72>
    wp::adj_transform_vector(var_0, var_ray_direction, adj_0, adj_ray_direction, adj_2);
    // adj: ray_direction_local = wp.transform_vector(inv_transform, ray_direction)           <L 71>
    wp::adj_transform_point(var_0, var_ray_origin, adj_0, adj_ray_origin, adj_1);
    // adj: ray_origin_local = wp.transform_point(inv_transform, ray_origin)                  <L 70>
    wp::adj_transform_inverse(var_transform, adj_transform, adj_0);
    // adj: inv_transform = wp.transform_inverse(transform)                                   <L 69>
    // adj: def map_ray_to_local(                                                             <L 52>
    return;
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/geometry/raycast.py:656
static void adj__make_ray_intersect_mesh__locals__ray_intersect_mesh_0(
    wp::vec_t<3, wp::float32> var_ray_origin,
    wp::vec_t<3, wp::float32> var_ray_direction,
    wp::vec_t<3, wp::float32> var_size,
    wp::uint64 var_mesh_id,
    bool var_enable_backface_culling,
    wp::float32 var_max_t,
    wp::int32 var_root,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::float32 & ret_2,
    wp::float32 & ret_3,
    wp::int32 & ret_4,
    wp::vec_t<3, wp::float32> & adj_ray_origin,
    wp::vec_t<3, wp::float32> & adj_ray_direction,
    wp::vec_t<3, wp::float32> & adj_size,
    wp::uint64 & adj_mesh_id,
    bool & adj_enable_backface_culling,
    wp::float32 & adj_max_t,
    wp::int32 & adj_root,
    wp::float32 & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1,
    wp::float32 & adj_ret_2,
    wp::float32 & adj_ret_3,
    wp::int32 & adj_ret_4)
{
    //---------
    // primal vars
    wp::uint64 var_0;
    bool var_1;
    const wp::float32 var_2 = -1.0;
    const wp::float32 var_3 = 0.0;
    wp::vec_t<3, wp::float32> var_4;
    const wp::float32 var_5 = 0.0;
    const wp::float32 var_6 = 0.0;
    const wp::int32 var_7 = -1;
    wp::mesh_query_ray_t var_8;
    bool* var_9;
    bool var_10;
    bool var_11;
    bool var_12;
    wp::vec_t<3, wp::float32>* var_13;
    wp::float32 var_14;
    wp::vec_t<3, wp::float32> var_15;
    const wp::float32 var_16 = 0.0;
    bool var_17;
    const wp::float32 var_18 = 0.0;
    wp::vec_t<3, wp::float32> var_19;
    const bool var_20 = true;
    wp::vec_t<3, wp::float32>* var_21;
    wp::vec_t<3, wp::float32> var_22;
    wp::vec_t<3, wp::float32> var_23;
    wp::vec_t<3, wp::float32> var_24;
    wp::float32* var_25;
    wp::float32* var_26;
    wp::float32* var_27;
    wp::int32* var_28;
    wp::float32 var_29;
    wp::float32 var_30;
    wp::float32 var_31;
    wp::float32 var_32;
    wp::float32 var_33;
    wp::float32 var_34;
    wp::int32 var_35;
    wp::int32 var_36;
    bool var_37;
    const wp::float32 var_38 = -1.0;
    const wp::float32 var_39 = 0.0;
    wp::vec_t<3, wp::float32> var_40;
    const wp::float32 var_41 = 0.0;
    const wp::float32 var_42 = 0.0;
    const wp::int32 var_43 = -1;
    //---------
    // dual vars
    wp::uint64 adj_0 = {};
    bool adj_1 = {};
    wp::float32 adj_2 = {};
    wp::float32 adj_3 = {};
    wp::vec_t<3, wp::float32> adj_4 = {};
    wp::float32 adj_5 = {};
    wp::float32 adj_6 = {};
    wp::int32 adj_7 = {};
    wp::mesh_query_ray_t adj_8 = {};
    bool adj_9 = {};
    bool adj_10 = {};
    bool adj_11 = {};
    bool adj_12 = {};
    wp::vec_t<3, wp::float32> adj_13 = {};
    wp::float32 adj_14 = {};
    wp::vec_t<3, wp::float32> adj_15 = {};
    wp::float32 adj_16 = {};
    bool adj_17 = {};
    wp::float32 adj_18 = {};
    wp::vec_t<3, wp::float32> adj_19 = {};
    bool adj_20 = {};
    wp::vec_t<3, wp::float32> adj_21 = {};
    wp::vec_t<3, wp::float32> adj_22 = {};
    wp::vec_t<3, wp::float32> adj_23 = {};
    wp::vec_t<3, wp::float32> adj_24 = {};
    wp::float32 adj_25 = {};
    wp::float32 adj_26 = {};
    wp::float32 adj_27 = {};
    wp::int32 adj_28 = {};
    wp::float32 adj_29 = {};
    wp::float32 adj_30 = {};
    wp::float32 adj_31 = {};
    wp::float32 adj_32 = {};
    wp::float32 adj_33 = {};
    wp::float32 adj_34 = {};
    wp::int32 adj_35 = {};
    wp::int32 adj_36 = {};
    bool adj_37 = {};
    wp::float32 adj_38 = {};
    wp::float32 adj_39 = {};
    wp::vec_t<3, wp::float32> adj_40 = {};
    wp::float32 adj_41 = {};
    wp::float32 adj_42 = {};
    wp::int32 adj_43 = {};
    //---------
    // forward
    // def ray_intersect_mesh(                                                                <L 657>
    // if mesh_id == wp.uint64(0):                                                            <L 681>
    var_0 = 0ull;
    var_1 = (var_mesh_id == var_0);
    if (var_1) {
        // return -1.0, wp.vec3(0.0), 0.0, 0.0, -1                                            <L 682>
        var_4 = wp::vec_t<3, wp::float32>(var_3);
        ret_0 = var_2;
        ret_1 = var_4;
        ret_2 = var_5;
        ret_3 = var_6;
        ret_4 = var_7;
        goto label0;
    }
    // query = wp.mesh_query_ray(mesh_id, ray_origin, ray_direction, max_t, root)             <L 684>
    var_8 = wp::mesh_query_ray(var_mesh_id, var_ray_origin, var_ray_direction, var_max_t, var_root);
    // if query.result:                                                                       <L 686>
    var_9 = &((var_8).result);
    var_10 = wp::load(var_9);
    if (var_10) {
        // if not enable_backface_culling or wp.dot(ray_direction, query.normal) < 0.0:       <L 687>
        var_12 = wp::unot(var_enable_backface_culling);
        var_11 = var_12;
        if (!var_11) {
            var_13 = &((var_8).normal);
            var_15 = wp::load(var_13);
            var_14 = wp::dot(var_ray_direction, var_15);
            var_17 = (var_14 < var_16);
            var_11 = var_11 || var_17;
        }
        if (var_11) {
            // normal = wp.vec3(0.0)                                                          <L 688>
            var_19 = wp::vec_t<3, wp::float32>(var_18);
            // if wp.static(compute_normal):                                                  <L 689>
            // normal = wp.normalize(safe_div_vec3(query.normal, size))                       <L 690>
            var_21 = &((var_8).normal);
            var_23 = wp::load(var_21);
            var_22 = safe_div_vec3_0(var_23, var_size);
            var_24 = wp::normalize(var_22);
            // return query.t, normal, query.u, query.v, query.face                           <L 691>
            var_25 = &((var_8).t);
            var_26 = &((var_8).u);
            var_27 = &((var_8).v);
            var_28 = &((var_8).face);
            var_30 = wp::load(var_25);
            var_29 = wp::copy(var_30);
            var_32 = wp::load(var_26);
            var_31 = wp::copy(var_32);
            var_34 = wp::load(var_27);
            var_33 = wp::copy(var_34);
            var_36 = wp::load(var_28);
            var_35 = wp::copy(var_36);
            ret_0 = var_29;
            ret_1 = var_24;
            ret_2 = var_31;
            ret_3 = var_33;
            ret_4 = var_35;
            goto label1;
        }
    }
    var_37 = wp::load(var_9);
    // return -1.0, wp.vec3(0.0), 0.0, 0.0, -1                                                <L 693>
    var_40 = wp::vec_t<3, wp::float32>(var_39);
    ret_0 = var_38;
    ret_1 = var_40;
    ret_2 = var_41;
    ret_3 = var_42;
    ret_4 = var_43;
    goto label2;
    //---------
    // reverse
    label2:;
    adj_43 += adj_ret_4;
    adj_42 += adj_ret_3;
    adj_41 += adj_ret_2;
    adj_40 += adj_ret_1;
    adj_38 += adj_ret_0;
    wp::adj_vec_t(var_39, adj_39, adj_40);
    // adj: return -1.0, wp.vec3(0.0), 0.0, 0.0, -1                                           <L 693>
    if (var_37) {
        if (var_11) {
            label1:;
            adj_35 += adj_ret_4;
            adj_33 += adj_ret_3;
            adj_31 += adj_ret_2;
            adj_24 += adj_ret_1;
            adj_29 += adj_ret_0;
            wp::adj_copy(var_36, adj_28, adj_35);
            wp::adj_copy(var_34, adj_27, adj_33);
            wp::adj_copy(var_32, adj_26, adj_31);
            wp::adj_copy(var_30, adj_25, adj_29);
            adj_8.face = adj_28;
            adj_8.v += adj_27;
            adj_8.u += adj_26;
            adj_8.t += adj_25;
            // adj: return query.t, normal, query.u, query.v, query.face                      <L 691>
            wp::adj_normalize(var_22, var_24, adj_22, adj_24);
            adj_safe_div_vec3_0(var_23, var_size, adj_21, adj_size, adj_22);
            adj_8.normal += adj_21;
            // adj: normal = wp.normalize(safe_div_vec3(query.normal, size))                  <L 690>
            // adj: if wp.static(compute_normal):                                             <L 689>
            wp::adj_vec_t(var_18, adj_18, adj_19);
            // adj: normal = wp.vec3(0.0)                                                     <L 688>
        }
        if (!var_11) {
            wp::adj_dot(var_ray_direction, var_15, adj_ray_direction, adj_13, adj_14);
            adj_8.normal += adj_13;
        }
        // adj: if not enable_backface_culling or wp.dot(ray_direction, query.normal) < 0.0:  <L 687>
    }
    adj_8.result = adj_9;
    // adj: if query.result:                                                                  <L 686>
    wp::adj_mesh_query_ray(var_mesh_id, var_ray_origin, var_ray_direction, var_max_t, var_root, var_8, adj_mesh_id, adj_ray_origin, adj_ray_direction, adj_max_t, adj_root, adj_8);
    // adj: query = wp.mesh_query_ray(mesh_id, ray_origin, ray_direction, max_t, root)        <L 684>
    if (var_1) {
        label0:;
        adj_7 += adj_ret_4;
        adj_6 += adj_ret_3;
        adj_5 += adj_ret_2;
        adj_4 += adj_ret_1;
        adj_2 += adj_ret_0;
        wp::adj_vec_t(var_3, adj_3, adj_4);
        // adj: return -1.0, wp.vec3(0.0), 0.0, 0.0, -1                                       <L 682>
    }
    // adj: if mesh_id == wp.uint64(0):                                                       <L 681>
    // adj: def ray_intersect_mesh(                                                           <L 657>
    return;
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/geometry/raycast.py:594
static void adj_ray_intersect_plane_0(
    wp::vec_t<3, wp::float32> var_ray_origin,
    wp::vec_t<3, wp::float32> var_ray_direction,
    wp::vec_t<3, wp::float32> var_size,
    bool var_enable_backface_culling,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & adj_ray_origin,
    wp::vec_t<3, wp::float32> & adj_ray_direction,
    wp::vec_t<3, wp::float32> & adj_size,
    bool & adj_enable_backface_culling,
    wp::float32 & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
    //---------
    // primal vars
    const wp::float32 var_0 = -1.0;
    const wp::float32 var_1 = 0.0;
    wp::vec_t<3, wp::float32> var_2;
    const wp::int32 var_3 = 2;
    wp::float32 var_4;
    wp::float32 var_5;
    const wp::float32 var_6 = 1e-06;
    bool var_7;
    bool var_8;
    const wp::int32 var_9 = 2;
    wp::float32 var_10;
    const wp::float32 var_11 = 0.0;
    bool var_12;
    const wp::int32 var_13 = 2;
    wp::float32 var_14;
    wp::float32 var_15;
    const wp::int32 var_16 = 2;
    wp::float32 var_17;
    wp::float32 var_18;
    const wp::float32 var_19 = 0.0;
    bool var_20;
    const wp::int32 var_21 = 0;
    wp::float32 var_22;
    const wp::int32 var_23 = 0;
    wp::float32 var_24;
    wp::float32 var_25;
    wp::float32 var_26;
    const wp::int32 var_27 = 1;
    wp::float32 var_28;
    const wp::int32 var_29 = 1;
    wp::float32 var_30;
    wp::float32 var_31;
    wp::float32 var_32;
    const wp::int32 var_33 = 0;
    wp::float32 var_34;
    const wp::float32 var_35 = 0.5;
    wp::float32 var_36;
    const wp::int32 var_37 = 1;
    wp::float32 var_38;
    const wp::float32 var_39 = 0.5;
    wp::float32 var_40;
    bool var_41;
    const wp::float32 var_42 = 0.0;
    bool var_43;
    wp::float32 var_44;
    bool var_45;
    bool var_46;
    const wp::float32 var_47 = 0.0;
    bool var_48;
    wp::float32 var_49;
    bool var_50;
    wp::float32 var_51;
    const wp::float32 var_52 = 0.0;
    const wp::float32 var_53 = 0.0;
    const wp::float32 var_54 = 1.0;
    wp::vec_t<3, wp::float32> var_55;
    //---------
    // dual vars
    wp::float32 adj_0 = {};
    wp::float32 adj_1 = {};
    wp::vec_t<3, wp::float32> adj_2 = {};
    wp::int32 adj_3 = {};
    wp::float32 adj_4 = {};
    wp::float32 adj_5 = {};
    wp::float32 adj_6 = {};
    bool adj_7 = {};
    bool adj_8 = {};
    wp::int32 adj_9 = {};
    wp::float32 adj_10 = {};
    wp::float32 adj_11 = {};
    bool adj_12 = {};
    wp::int32 adj_13 = {};
    wp::float32 adj_14 = {};
    wp::float32 adj_15 = {};
    wp::int32 adj_16 = {};
    wp::float32 adj_17 = {};
    wp::float32 adj_18 = {};
    wp::float32 adj_19 = {};
    bool adj_20 = {};
    wp::int32 adj_21 = {};
    wp::float32 adj_22 = {};
    wp::int32 adj_23 = {};
    wp::float32 adj_24 = {};
    wp::float32 adj_25 = {};
    wp::float32 adj_26 = {};
    wp::int32 adj_27 = {};
    wp::float32 adj_28 = {};
    wp::int32 adj_29 = {};
    wp::float32 adj_30 = {};
    wp::float32 adj_31 = {};
    wp::float32 adj_32 = {};
    wp::int32 adj_33 = {};
    wp::float32 adj_34 = {};
    wp::float32 adj_35 = {};
    wp::float32 adj_36 = {};
    wp::int32 adj_37 = {};
    wp::float32 adj_38 = {};
    wp::float32 adj_39 = {};
    wp::float32 adj_40 = {};
    bool adj_41 = {};
    wp::float32 adj_42 = {};
    bool adj_43 = {};
    wp::float32 adj_44 = {};
    bool adj_45 = {};
    bool adj_46 = {};
    wp::float32 adj_47 = {};
    bool adj_48 = {};
    wp::float32 adj_49 = {};
    bool adj_50 = {};
    wp::float32 adj_51 = {};
    wp::float32 adj_52 = {};
    wp::float32 adj_53 = {};
    wp::float32 adj_54 = {};
    wp::vec_t<3, wp::float32> adj_55 = {};
    //---------
    // forward
    // def ray_intersect_plane(                                                               <L 595>
    // t_hit = -1.0                                                                           <L 617>
    // normal = wp.vec3(0.0)                                                                  <L 618>
    var_2 = wp::vec_t<3, wp::float32>(var_1);
    // if wp.abs(ray_direction[2]) < PARALLEL_TOL:                                            <L 621>
    var_4 = wp::extract(var_ray_direction, var_3);
    var_5 = wp::abs(var_4);
    var_7 = (var_5 < var_6);
    if (var_7) {
        // return t_hit, normal                                                               <L 622>
        ret_0 = var_0;
        ret_1 = var_2;
        goto label0;
    }
    // if enable_backface_culling and ray_direction[2] > 0.0:                                 <L 625>
    var_8 = var_enable_backface_culling;
    if (var_8) {
        var_10 = wp::extract(var_ray_direction, var_9);
        var_12 = (var_10 > var_11);
        var_8 = var_8 && var_12;
    }
    if (var_8) {
        // return t_hit, normal                                                               <L 626>
        ret_0 = var_0;
        ret_1 = var_2;
        goto label1;
    }
    // t = -ray_origin[2] / ray_direction[2]                                                  <L 628>
    var_14 = wp::extract(var_ray_origin, var_13);
    var_15 = wp::neg(var_14);
    var_17 = wp::extract(var_ray_direction, var_16);
    var_18 = wp::div(var_15, var_17);
    // if t < 0.0:                                                                            <L 629>
    var_20 = (var_18 < var_19);
    if (var_20) {
        // return t_hit, normal                                                               <L 630>
        ret_0 = var_0;
        ret_1 = var_2;
        goto label2;
    }
    // hit_x = ray_origin[0] + t * ray_direction[0]                                           <L 632>
    var_22 = wp::extract(var_ray_origin, var_21);
    var_24 = wp::extract(var_ray_direction, var_23);
    var_25 = wp::mul(var_18, var_24);
    var_26 = wp::add(var_22, var_25);
    // hit_y = ray_origin[1] + t * ray_direction[1]                                           <L 633>
    var_28 = wp::extract(var_ray_origin, var_27);
    var_30 = wp::extract(var_ray_direction, var_29);
    var_31 = wp::mul(var_18, var_30);
    var_32 = wp::add(var_28, var_31);
    // half_w = size[0] * 0.5                                                                 <L 635>
    var_34 = wp::extract(var_size, var_33);
    var_36 = wp::mul(var_34, var_35);
    // half_l = size[1] * 0.5                                                                 <L 636>
    var_38 = wp::extract(var_size, var_37);
    var_40 = wp::mul(var_38, var_39);
    // if half_w > 0.0 and wp.abs(hit_x) > half_w:                                            <L 638>
    var_43 = (var_36 > var_42);
    var_41 = var_43;
    if (var_41) {
        var_44 = wp::abs(var_26);
        var_45 = (var_44 > var_36);
        var_41 = var_41 && var_45;
    }
    if (var_41) {
        // return t_hit, normal                                                               <L 639>
        ret_0 = var_0;
        ret_1 = var_2;
        goto label3;
    }
    // if half_l > 0.0 and wp.abs(hit_y) > half_l:                                            <L 640>
    var_48 = (var_40 > var_47);
    var_46 = var_48;
    if (var_46) {
        var_49 = wp::abs(var_32);
        var_50 = (var_49 > var_40);
        var_46 = var_46 && var_50;
    }
    if (var_46) {
        // return t_hit, normal                                                               <L 641>
        ret_0 = var_0;
        ret_1 = var_2;
        goto label4;
    }
    // t_hit = t                                                                              <L 643>
    var_51 = wp::copy(var_18);
    // normal = wp.vec3(0.0, 0.0, 1.0)                                                        <L 644>
    var_55 = wp::vec_t<3, wp::float32>(var_52, var_53, var_54);
    // return t_hit, normal                                                                   <L 646>
    ret_0 = var_51;
    ret_1 = var_55;
    goto label5;
    //---------
    // reverse
    label5:;
    adj_55 += adj_ret_1;
    adj_51 += adj_ret_0;
    // adj: return t_hit, normal                                                              <L 646>
    wp::adj_vec_t(var_52, var_53, var_54, adj_52, adj_53, adj_54, adj_55);
    // adj: normal = wp.vec3(0.0, 0.0, 1.0)                                                   <L 644>
    wp::adj_copy(var_18, adj_18, adj_51);
    // adj: t_hit = t                                                                         <L 643>
    if (var_46) {
        label4:;
        adj_2 += adj_ret_1;
        adj_0 += adj_ret_0;
        // adj: return t_hit, normal                                                          <L 641>
    }
    if (var_46) {
        wp::adj_abs(var_32, adj_32, adj_49);
    }
    // adj: if half_l > 0.0 and wp.abs(hit_y) > half_l:                                       <L 640>
    if (var_41) {
        label3:;
        adj_2 += adj_ret_1;
        adj_0 += adj_ret_0;
        // adj: return t_hit, normal                                                          <L 639>
    }
    if (var_41) {
        wp::adj_abs(var_26, adj_26, adj_44);
    }
    // adj: if half_w > 0.0 and wp.abs(hit_x) > half_w:                                       <L 638>
    wp::adj_mul(var_38, var_39, adj_38, adj_39, adj_40);
    wp::adj_extract(var_size, var_37, adj_size, adj_37, adj_38);
    // adj: half_l = size[1] * 0.5                                                            <L 636>
    wp::adj_mul(var_34, var_35, adj_34, adj_35, adj_36);
    wp::adj_extract(var_size, var_33, adj_size, adj_33, adj_34);
    // adj: half_w = size[0] * 0.5                                                            <L 635>
    wp::adj_add(var_28, var_31, adj_28, adj_31, adj_32);
    wp::adj_mul(var_18, var_30, adj_18, adj_30, adj_31);
    wp::adj_extract(var_ray_direction, var_29, adj_ray_direction, adj_29, adj_30);
    wp::adj_extract(var_ray_origin, var_27, adj_ray_origin, adj_27, adj_28);
    // adj: hit_y = ray_origin[1] + t * ray_direction[1]                                      <L 633>
    wp::adj_add(var_22, var_25, adj_22, adj_25, adj_26);
    wp::adj_mul(var_18, var_24, adj_18, adj_24, adj_25);
    wp::adj_extract(var_ray_direction, var_23, adj_ray_direction, adj_23, adj_24);
    wp::adj_extract(var_ray_origin, var_21, adj_ray_origin, adj_21, adj_22);
    // adj: hit_x = ray_origin[0] + t * ray_direction[0]                                      <L 632>
    if (var_20) {
        label2:;
        adj_2 += adj_ret_1;
        adj_0 += adj_ret_0;
        // adj: return t_hit, normal                                                          <L 630>
    }
    // adj: if t < 0.0:                                                                       <L 629>
    wp::adj_div(var_15, var_17, var_18, adj_15, adj_17, adj_18);
    wp::adj_extract(var_ray_direction, var_16, adj_ray_direction, adj_16, adj_17);
    wp::adj_neg(var_14, adj_14, adj_15);
    wp::adj_extract(var_ray_origin, var_13, adj_ray_origin, adj_13, adj_14);
    // adj: t = -ray_origin[2] / ray_direction[2]                                             <L 628>
    if (var_8) {
        label1:;
        adj_2 += adj_ret_1;
        adj_0 += adj_ret_0;
        // adj: return t_hit, normal                                                          <L 626>
    }
    if (var_8) {
        wp::adj_extract(var_ray_direction, var_9, adj_ray_direction, adj_9, adj_10);
    }
    // adj: if enable_backface_culling and ray_direction[2] > 0.0:                            <L 625>
    if (var_7) {
        label0:;
        adj_2 += adj_ret_1;
        adj_0 += adj_ret_0;
        // adj: return t_hit, normal                                                          <L 622>
    }
    wp::adj_abs(var_4, adj_4, adj_5);
    wp::adj_extract(var_ray_direction, var_3, adj_ray_direction, adj_3, adj_4);
    // adj: if wp.abs(ray_direction[2]) < PARALLEL_TOL:                                       <L 621>
    wp::adj_vec_t(var_1, adj_1, adj_2);
    // adj: normal = wp.vec3(0.0)                                                             <L 618>
    // adj: t_hit = -1.0                                                                      <L 617>
    // adj: def ray_intersect_plane(                                                          <L 595>
    return;
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/geometry/raycast.py:79
static void adj_ray_intersect_sphere_0(
    wp::vec_t<3, wp::float32> var_ray_origin,
    wp::vec_t<3, wp::float32> var_ray_direction,
    wp::float32 var_r,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & adj_ray_origin,
    wp::vec_t<3, wp::float32> & adj_ray_direction,
    wp::float32 & adj_r,
    wp::float32 & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
    //---------
    // primal vars
    const wp::float32 var_0 = -1.0;
    const wp::float32 var_1 = 0.0;
    wp::vec_t<3, wp::float32> var_2;
    wp::float32 var_3;
    const wp::float32 var_4 = 1e-15;
    bool var_5;
    const wp::float32 var_6 = 1.0;
    wp::float32 var_7;
    wp::float32 var_8;
    wp::vec_t<3, wp::float32> var_9;
    wp::vec_t<3, wp::float32> var_10;
    wp::float32 var_11;
    wp::float32 var_12;
    wp::float32 var_13;
    wp::float32 var_14;
    wp::float32 var_15;
    wp::float32 var_16;
    const wp::float32 var_17 = 0.0;
    bool var_18;
    wp::float32 var_19;
    wp::float32 var_20;
    wp::float32 var_21;
    const wp::float32 var_22 = 0.0;
    bool var_23;
    wp::float32 var_24;
    wp::float32 var_25;
    wp::float32 var_26;
    const wp::float32 var_27 = 0.0;
    bool var_28;
    wp::float32 var_29;
    wp::float32 var_30;
    wp::float32 var_31;
    wp::float32 var_32;
    const wp::float32 var_33 = 0.0;
    bool var_34;
    wp::vec_t<3, wp::float32> var_35;
    wp::vec_t<3, wp::float32> var_36;
    wp::vec_t<3, wp::float32> var_37;
    wp::vec_t<3, wp::float32> var_38;
    //---------
    // dual vars
    wp::float32 adj_0 = {};
    wp::float32 adj_1 = {};
    wp::vec_t<3, wp::float32> adj_2 = {};
    wp::float32 adj_3 = {};
    wp::float32 adj_4 = {};
    bool adj_5 = {};
    wp::float32 adj_6 = {};
    wp::float32 adj_7 = {};
    wp::float32 adj_8 = {};
    wp::vec_t<3, wp::float32> adj_9 = {};
    wp::vec_t<3, wp::float32> adj_10 = {};
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
    bool adj_23 = {};
    wp::float32 adj_24 = {};
    wp::float32 adj_25 = {};
    wp::float32 adj_26 = {};
    wp::float32 adj_27 = {};
    bool adj_28 = {};
    wp::float32 adj_29 = {};
    wp::float32 adj_30 = {};
    wp::float32 adj_31 = {};
    wp::float32 adj_32 = {};
    wp::float32 adj_33 = {};
    bool adj_34 = {};
    wp::vec_t<3, wp::float32> adj_35 = {};
    wp::vec_t<3, wp::float32> adj_36 = {};
    wp::vec_t<3, wp::float32> adj_37 = {};
    wp::vec_t<3, wp::float32> adj_38 = {};
    //---------
    // forward
    // def ray_intersect_sphere(ray_origin: wp.vec3, ray_direction: wp.vec3, r: float) -> tuple[float, wp.vec3]:       <L 80>
    // t_hit = -1.0                                                                           <L 91>
    // normal = wp.vec3(0.0)                                                                  <L 92>
    var_2 = wp::vec_t<3, wp::float32>(var_1);
    // d_len_sq = wp.dot(ray_direction, ray_direction)                                        <L 94>
    var_3 = wp::dot(var_ray_direction, var_ray_direction);
    // if d_len_sq < MINVAL:                                                                  <L 95>
    var_5 = (var_3 < var_4);
    if (var_5) {
        // return t_hit, normal                                                               <L 96>
        ret_0 = var_0;
        ret_1 = var_2;
        goto label0;
    }
    // inv_d_len = 1.0 / wp.sqrt(d_len_sq)                                                    <L 98>
    var_7 = wp::sqrt(var_3);
    var_8 = wp::div(var_6, var_7);
    // d_local_norm = ray_direction * inv_d_len                                               <L 99>
    var_9 = wp::mul(var_ray_direction, var_8);
    // oc = ray_origin                                                                        <L 101>
    var_10 = wp::copy(var_ray_origin);
    // b = wp.dot(oc, d_local_norm)                                                           <L 102>
    var_11 = wp::dot(var_10, var_9);
    // c = wp.dot(oc, oc) - r * r                                                             <L 103>
    var_12 = wp::dot(var_10, var_10);
    var_13 = wp::mul(var_r, var_r);
    var_14 = wp::sub(var_12, var_13);
    // delta = b * b - c                                                                      <L 105>
    var_15 = wp::mul(var_11, var_11);
    var_16 = wp::sub(var_15, var_14);
    // if delta >= 0.0:                                                                       <L 106>
    var_18 = (var_16 >= var_17);
    if (var_18) {
        // sqrt_delta = wp.sqrt(delta)                                                        <L 107>
        var_19 = wp::sqrt(var_16);
        // t1 = -b - sqrt_delta                                                               <L 108>
        var_20 = wp::neg(var_11);
        var_21 = wp::sub(var_20, var_19);
        // if t1 >= 0.0:                                                                      <L 109>
        var_23 = (var_21 >= var_22);
        if (var_23) {
            // t_hit = t1 * inv_d_len                                                         <L 110>
            var_24 = wp::mul(var_21, var_8);
        }
        if (!var_23) {
            // t2 = -b + sqrt_delta                                                           <L 112>
            var_25 = wp::neg(var_11);
            var_26 = wp::add(var_25, var_19);
            // if t2 >= 0.0:                                                                  <L 113>
            var_28 = (var_26 >= var_27);
            if (var_28) {
                // t_hit = t2 * inv_d_len                                                     <L 114>
                var_29 = wp::mul(var_26, var_8);
            }
            var_30 = wp::where(var_28, var_29, var_0);
        }
        var_31 = wp::where(var_23, var_24, var_30);
    }
    var_32 = wp::where(var_18, var_31, var_0);
    // if t_hit >= 0.0:                                                                       <L 116>
    var_34 = (var_32 >= var_33);
    if (var_34) {
        // normal = wp.normalize(ray_origin + t_hit * ray_direction)                          <L 117>
        var_35 = wp::mul(var_32, var_ray_direction);
        var_36 = wp::add(var_ray_origin, var_35);
        var_37 = wp::normalize(var_36);
    }
    var_38 = wp::where(var_34, var_37, var_2);
    // return t_hit, normal                                                                   <L 119>
    ret_0 = var_32;
    ret_1 = var_38;
    goto label1;
    //---------
    // reverse
    label1:;
    adj_38 += adj_ret_1;
    adj_32 += adj_ret_0;
    // adj: return t_hit, normal                                                              <L 119>
    wp::adj_where(var_34, var_37, var_2, adj_34, adj_37, adj_2, adj_38);
    if (var_34) {
        wp::adj_normalize(var_36, var_37, adj_36, adj_37);
        wp::adj_add(var_ray_origin, var_35, adj_ray_origin, adj_35, adj_36);
        wp::adj_mul(var_32, var_ray_direction, adj_32, adj_ray_direction, adj_35);
        // adj: normal = wp.normalize(ray_origin + t_hit * ray_direction)                     <L 117>
    }
    // adj: if t_hit >= 0.0:                                                                  <L 116>
    wp::adj_where(var_18, var_31, var_0, adj_18, adj_31, adj_0, adj_32);
    if (var_18) {
        wp::adj_where(var_23, var_24, var_30, adj_23, adj_24, adj_30, adj_31);
        if (!var_23) {
            wp::adj_where(var_28, var_29, var_0, adj_28, adj_29, adj_0, adj_30);
            if (var_28) {
                wp::adj_mul(var_26, var_8, adj_26, adj_8, adj_29);
                // adj: t_hit = t2 * inv_d_len                                                <L 114>
            }
            // adj: if t2 >= 0.0:                                                             <L 113>
            wp::adj_add(var_25, var_19, adj_25, adj_19, adj_26);
            wp::adj_neg(var_11, adj_11, adj_25);
            // adj: t2 = -b + sqrt_delta                                                      <L 112>
        }
        if (var_23) {
            wp::adj_mul(var_21, var_8, adj_21, adj_8, adj_24);
            // adj: t_hit = t1 * inv_d_len                                                    <L 110>
        }
        // adj: if t1 >= 0.0:                                                                 <L 109>
        wp::adj_sub(var_20, var_19, adj_20, adj_19, adj_21);
        wp::adj_neg(var_11, adj_11, adj_20);
        // adj: t1 = -b - sqrt_delta                                                          <L 108>
        wp::adj_sqrt(var_16, var_19, adj_16, adj_19);
        // adj: sqrt_delta = wp.sqrt(delta)                                                   <L 107>
    }
    // adj: if delta >= 0.0:                                                                  <L 106>
    wp::adj_sub(var_15, var_14, adj_15, adj_14, adj_16);
    wp::adj_mul(var_11, var_11, adj_11, adj_11, adj_15);
    // adj: delta = b * b - c                                                                 <L 105>
    wp::adj_sub(var_12, var_13, adj_12, adj_13, adj_14);
    wp::adj_mul(var_r, var_r, adj_r, adj_r, adj_13);
    wp::adj_dot(var_10, var_10, adj_10, adj_10, adj_12);
    // adj: c = wp.dot(oc, oc) - r * r                                                        <L 103>
    wp::adj_dot(var_10, var_9, adj_10, adj_9, adj_11);
    // adj: b = wp.dot(oc, d_local_norm)                                                      <L 102>
    wp::adj_copy(var_ray_origin, adj_ray_origin, adj_10);
    // adj: oc = ray_origin                                                                   <L 101>
    wp::adj_mul(var_ray_direction, var_8, adj_ray_direction, adj_8, adj_9);
    // adj: d_local_norm = ray_direction * inv_d_len                                          <L 99>
    wp::adj_div(var_6, var_7, var_8, adj_6, adj_7, adj_8);
    wp::adj_sqrt(var_3, var_7, adj_3, adj_7);
    // adj: inv_d_len = 1.0 / wp.sqrt(d_len_sq)                                               <L 98>
    if (var_5) {
        label0:;
        adj_2 += adj_ret_1;
        adj_0 += adj_ret_0;
        // adj: return t_hit, normal                                                          <L 96>
    }
    // adj: if d_len_sq < MINVAL:                                                             <L 95>
    wp::adj_dot(var_ray_direction, var_ray_direction, adj_ray_direction, adj_ray_direction, adj_3);
    // adj: d_len_sq = wp.dot(ray_direction, ray_direction)                                   <L 94>
    wp::adj_vec_t(var_1, adj_1, adj_2);
    // adj: normal = wp.vec3(0.0)                                                             <L 92>
    // adj: t_hit = -1.0                                                                      <L 91>
    // adj: def ray_intersect_sphere(ray_origin: wp.vec3, ray_direction: wp.vec3, r: float) -> tuple[float, wp.vec3]:  <L 80>
    return;
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/geometry/raycast.py:226
static void adj_ray_intersect_box_0(
    wp::vec_t<3, wp::float32> var_ray_origin,
    wp::vec_t<3, wp::float32> var_ray_direction,
    wp::vec_t<3, wp::float32> var_size,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & adj_ray_origin,
    wp::vec_t<3, wp::float32> & adj_ray_direction,
    wp::vec_t<3, wp::float32> & adj_size,
    wp::float32 & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
    //---------
    // primal vars
    const wp::float32 var_0 = -1.0;
    const wp::float32 var_1 = 0.0;
    wp::vec_t<3, wp::float32> var_2;
    const wp::float32 var_3 = -10000000000.0;
    const wp::float32 var_4 = 10000000000.0;
    const wp::int32 var_5 = 1;
    const wp::int32 var_6 = 0;
    wp::float32 var_7;
    wp::float32 var_8;
    const wp::float32 var_9 = 1e-15;
    bool var_10;
    bool var_11;
    wp::float32 var_12;
    wp::float32 var_13;
    wp::float32 var_14;
    bool var_15;
    wp::float32 var_16;
    wp::float32 var_17;
    bool var_18;
    const wp::int32 var_19 = 0;
    wp::int32 var_20;
    const wp::float32 var_21 = 1.0;
    wp::float32 var_22;
    wp::float32 var_23;
    wp::float32 var_24;
    wp::float32 var_25;
    wp::float32 var_26;
    wp::float32 var_27;
    wp::float32 var_28;
    wp::float32 var_29;
    wp::float32 var_30;
    wp::float32 var_31;
    wp::float32 var_32;
    bool var_33;
    wp::float32 var_34;
    wp::float32 var_35;
    wp::float32 var_36;
    wp::float32 var_37;
    wp::float32 var_38;
    wp::float32 var_39;
    wp::float32 var_40;
    wp::float32 var_41;
    wp::float32 var_42;
    wp::int32 var_43;
    const wp::int32 var_44 = 1;
    wp::float32 var_45;
    wp::float32 var_46;
    bool var_47;
    bool var_48;
    wp::float32 var_49;
    wp::float32 var_50;
    wp::float32 var_51;
    bool var_52;
    wp::float32 var_53;
    wp::float32 var_54;
    bool var_55;
    const wp::int32 var_56 = 0;
    wp::int32 var_57;
    const wp::float32 var_58 = 1.0;
    wp::float32 var_59;
    wp::float32 var_60;
    wp::float32 var_61;
    wp::float32 var_62;
    wp::float32 var_63;
    wp::float32 var_64;
    wp::float32 var_65;
    wp::float32 var_66;
    wp::float32 var_67;
    wp::float32 var_68;
    wp::float32 var_69;
    bool var_70;
    wp::float32 var_71;
    wp::float32 var_72;
    wp::float32 var_73;
    wp::float32 var_74;
    wp::float32 var_75;
    wp::float32 var_76;
    wp::float32 var_77;
    wp::float32 var_78;
    wp::float32 var_79;
    wp::float32 var_80;
    wp::int32 var_81;
    wp::float32 var_82;
    wp::float32 var_83;
    wp::float32 var_84;
    wp::float32 var_85;
    const wp::int32 var_86 = 2;
    wp::float32 var_87;
    wp::float32 var_88;
    bool var_89;
    bool var_90;
    wp::float32 var_91;
    wp::float32 var_92;
    wp::float32 var_93;
    bool var_94;
    wp::float32 var_95;
    wp::float32 var_96;
    bool var_97;
    const wp::int32 var_98 = 0;
    wp::int32 var_99;
    const wp::float32 var_100 = 1.0;
    wp::float32 var_101;
    wp::float32 var_102;
    wp::float32 var_103;
    wp::float32 var_104;
    wp::float32 var_105;
    wp::float32 var_106;
    wp::float32 var_107;
    wp::float32 var_108;
    wp::float32 var_109;
    wp::float32 var_110;
    wp::float32 var_111;
    bool var_112;
    wp::float32 var_113;
    wp::float32 var_114;
    wp::float32 var_115;
    wp::float32 var_116;
    wp::float32 var_117;
    wp::float32 var_118;
    wp::float32 var_119;
    wp::float32 var_120;
    wp::float32 var_121;
    wp::float32 var_122;
    wp::int32 var_123;
    wp::float32 var_124;
    wp::float32 var_125;
    wp::float32 var_126;
    wp::float32 var_127;
    bool var_128;
    const wp::int32 var_129 = 1;
    bool var_130;
    bool var_131;
    const wp::float32 var_132 = 0.0;
    bool var_133;
    const wp::float32 var_134 = 0.0;
    bool var_135;
    wp::float32 var_136;
    wp::float32 var_137;
    wp::float32 var_138;
    wp::float32 var_139;
    const wp::float32 var_140 = 0.0;
    bool var_141;
    const wp::float32 var_142 = 0.0;
    wp::vec_t<3, wp::float32> var_143;
    const wp::int32 var_144 = 0;
    wp::float32 var_145;
    wp::float32 var_146;
    const wp::float32 var_147 = 1e-06;
    bool var_148;
    const wp::int32 var_149 = -1;
    wp::float32 var_150;
    wp::float32 var_151;
    wp::float32 var_152;
    wp::float32 var_153;
    wp::float32 var_154;
    wp::float32 var_155;
    wp::float32 var_156;
    const wp::float32 var_157 = 0.0;
    bool var_158;
    const wp::mat_t<3, 2, wp::int32> var_159 = wp::initializer_array<6,wp::int32>{1, 2, 0, 2, 0, 1};
    const wp::int32 var_160 = 0;
    wp::int32 var_161;
    const wp::int32 var_162 = 1;
    wp::int32 var_163;
    wp::float32 var_164;
    wp::float32 var_165;
    wp::float32 var_166;
    wp::float32 var_167;
    wp::float32 var_168;
    wp::float32 var_169;
    wp::float32 var_170;
    wp::float32 var_171;
    bool var_172;
    wp::float32 var_173;
    wp::float32 var_174;
    bool var_175;
    wp::float32 var_176;
    wp::float32 var_177;
    bool var_178;
    wp::float32 var_179;
    wp::float32 var_180;
    bool var_181;
    const wp::int32 var_182 = 0;
    bool var_183;
    const wp::float32 var_184 = -1.0;
    const wp::float32 var_185 = 1.0;
    wp::float32 var_186;
    const wp::int32 var_187 = 1;
    wp::float32 var_188;
    wp::float32 var_189;
    wp::float32 var_190;
    wp::float32 var_191;
    wp::float32 var_192;
    wp::float32 var_193;
    wp::float32 var_194;
    const wp::float32 var_195 = 0.0;
    bool var_196;
    const wp::int32 var_197 = 0;
    wp::int32 var_198;
    const wp::int32 var_199 = 1;
    wp::int32 var_200;
    wp::float32 var_201;
    wp::float32 var_202;
    wp::float32 var_203;
    wp::float32 var_204;
    wp::float32 var_205;
    wp::float32 var_206;
    wp::float32 var_207;
    wp::float32 var_208;
    bool var_209;
    wp::float32 var_210;
    wp::float32 var_211;
    bool var_212;
    wp::float32 var_213;
    wp::float32 var_214;
    bool var_215;
    wp::float32 var_216;
    wp::float32 var_217;
    bool var_218;
    const wp::int32 var_219 = 0;
    bool var_220;
    const wp::float32 var_221 = -1.0;
    const wp::float32 var_222 = 1.0;
    wp::float32 var_223;
    wp::int32 var_224;
    wp::int32 var_225;
    wp::float32 var_226;
    wp::float32 var_227;
    const wp::int32 var_228 = 1;
    wp::float32 var_229;
    wp::float32 var_230;
    bool var_231;
    const wp::int32 var_232 = -1;
    wp::float32 var_233;
    wp::float32 var_234;
    wp::float32 var_235;
    wp::float32 var_236;
    wp::float32 var_237;
    wp::float32 var_238;
    wp::float32 var_239;
    const wp::float32 var_240 = 0.0;
    bool var_241;
    const wp::int32 var_242 = 0;
    wp::int32 var_243;
    const wp::int32 var_244 = 1;
    wp::int32 var_245;
    wp::float32 var_246;
    wp::float32 var_247;
    wp::float32 var_248;
    wp::float32 var_249;
    wp::float32 var_250;
    wp::float32 var_251;
    wp::float32 var_252;
    wp::float32 var_253;
    bool var_254;
    wp::float32 var_255;
    wp::float32 var_256;
    bool var_257;
    wp::float32 var_258;
    wp::float32 var_259;
    bool var_260;
    wp::float32 var_261;
    wp::float32 var_262;
    bool var_263;
    const wp::int32 var_264 = 0;
    bool var_265;
    const wp::float32 var_266 = -1.0;
    const wp::float32 var_267 = 1.0;
    wp::float32 var_268;
    wp::int32 var_269;
    wp::int32 var_270;
    wp::float32 var_271;
    wp::float32 var_272;
    const wp::int32 var_273 = 1;
    wp::float32 var_274;
    wp::float32 var_275;
    wp::float32 var_276;
    wp::float32 var_277;
    wp::float32 var_278;
    wp::float32 var_279;
    wp::float32 var_280;
    const wp::float32 var_281 = 0.0;
    bool var_282;
    const wp::int32 var_283 = 0;
    wp::int32 var_284;
    const wp::int32 var_285 = 1;
    wp::int32 var_286;
    wp::float32 var_287;
    wp::float32 var_288;
    wp::float32 var_289;
    wp::float32 var_290;
    wp::float32 var_291;
    wp::float32 var_292;
    wp::float32 var_293;
    wp::float32 var_294;
    bool var_295;
    wp::float32 var_296;
    wp::float32 var_297;
    bool var_298;
    wp::float32 var_299;
    wp::float32 var_300;
    bool var_301;
    wp::float32 var_302;
    wp::float32 var_303;
    bool var_304;
    const wp::int32 var_305 = 0;
    bool var_306;
    const wp::float32 var_307 = -1.0;
    const wp::float32 var_308 = 1.0;
    wp::float32 var_309;
    wp::int32 var_310;
    wp::int32 var_311;
    wp::float32 var_312;
    wp::float32 var_313;
    wp::int32 var_314;
    wp::float32 var_315;
    wp::int32 var_316;
    wp::int32 var_317;
    wp::float32 var_318;
    wp::float32 var_319;
    const wp::int32 var_320 = 2;
    wp::float32 var_321;
    wp::float32 var_322;
    bool var_323;
    const wp::int32 var_324 = -1;
    wp::float32 var_325;
    wp::float32 var_326;
    wp::float32 var_327;
    wp::float32 var_328;
    wp::float32 var_329;
    wp::float32 var_330;
    wp::float32 var_331;
    const wp::float32 var_332 = 0.0;
    bool var_333;
    const wp::int32 var_334 = 0;
    wp::int32 var_335;
    const wp::int32 var_336 = 1;
    wp::int32 var_337;
    wp::float32 var_338;
    wp::float32 var_339;
    wp::float32 var_340;
    wp::float32 var_341;
    wp::float32 var_342;
    wp::float32 var_343;
    wp::float32 var_344;
    wp::float32 var_345;
    bool var_346;
    wp::float32 var_347;
    wp::float32 var_348;
    bool var_349;
    wp::float32 var_350;
    wp::float32 var_351;
    bool var_352;
    wp::float32 var_353;
    wp::float32 var_354;
    bool var_355;
    const wp::int32 var_356 = 0;
    bool var_357;
    const wp::float32 var_358 = -1.0;
    const wp::float32 var_359 = 1.0;
    wp::float32 var_360;
    wp::int32 var_361;
    wp::int32 var_362;
    wp::float32 var_363;
    wp::float32 var_364;
    const wp::int32 var_365 = 1;
    wp::float32 var_366;
    wp::float32 var_367;
    wp::float32 var_368;
    wp::float32 var_369;
    wp::float32 var_370;
    wp::float32 var_371;
    wp::float32 var_372;
    const wp::float32 var_373 = 0.0;
    bool var_374;
    const wp::int32 var_375 = 0;
    wp::int32 var_376;
    const wp::int32 var_377 = 1;
    wp::int32 var_378;
    wp::float32 var_379;
    wp::float32 var_380;
    wp::float32 var_381;
    wp::float32 var_382;
    wp::float32 var_383;
    wp::float32 var_384;
    wp::float32 var_385;
    wp::float32 var_386;
    bool var_387;
    wp::float32 var_388;
    wp::float32 var_389;
    bool var_390;
    wp::float32 var_391;
    wp::float32 var_392;
    bool var_393;
    wp::float32 var_394;
    wp::float32 var_395;
    bool var_396;
    const wp::int32 var_397 = 0;
    bool var_398;
    const wp::float32 var_399 = -1.0;
    const wp::float32 var_400 = 1.0;
    wp::float32 var_401;
    wp::int32 var_402;
    wp::int32 var_403;
    wp::float32 var_404;
    wp::float32 var_405;
    wp::int32 var_406;
    wp::float32 var_407;
    wp::int32 var_408;
    wp::int32 var_409;
    wp::float32 var_410;
    wp::float32 var_411;
    wp::vec_t<3, wp::float32> var_412;
    wp::vec_t<3, wp::float32> var_413;
    wp::int32 var_414;
    //---------
    // dual vars
    wp::float32 adj_0 = {};
    wp::float32 adj_1 = {};
    wp::vec_t<3, wp::float32> adj_2 = {};
    wp::float32 adj_3 = {};
    wp::float32 adj_4 = {};
    wp::int32 adj_5 = {};
    wp::int32 adj_6 = {};
    wp::float32 adj_7 = {};
    wp::float32 adj_8 = {};
    wp::float32 adj_9 = {};
    bool adj_10 = {};
    bool adj_11 = {};
    wp::float32 adj_12 = {};
    wp::float32 adj_13 = {};
    wp::float32 adj_14 = {};
    bool adj_15 = {};
    wp::float32 adj_16 = {};
    wp::float32 adj_17 = {};
    bool adj_18 = {};
    wp::int32 adj_19 = {};
    wp::int32 adj_20 = {};
    wp::float32 adj_21 = {};
    wp::float32 adj_22 = {};
    wp::float32 adj_23 = {};
    wp::float32 adj_24 = {};
    wp::float32 adj_25 = {};
    wp::float32 adj_26 = {};
    wp::float32 adj_27 = {};
    wp::float32 adj_28 = {};
    wp::float32 adj_29 = {};
    wp::float32 adj_30 = {};
    wp::float32 adj_31 = {};
    wp::float32 adj_32 = {};
    bool adj_33 = {};
    wp::float32 adj_34 = {};
    wp::float32 adj_35 = {};
    wp::float32 adj_36 = {};
    wp::float32 adj_37 = {};
    wp::float32 adj_38 = {};
    wp::float32 adj_39 = {};
    wp::float32 adj_40 = {};
    wp::float32 adj_41 = {};
    wp::float32 adj_42 = {};
    wp::int32 adj_43 = {};
    wp::int32 adj_44 = {};
    wp::float32 adj_45 = {};
    wp::float32 adj_46 = {};
    bool adj_47 = {};
    bool adj_48 = {};
    wp::float32 adj_49 = {};
    wp::float32 adj_50 = {};
    wp::float32 adj_51 = {};
    bool adj_52 = {};
    wp::float32 adj_53 = {};
    wp::float32 adj_54 = {};
    bool adj_55 = {};
    wp::int32 adj_56 = {};
    wp::int32 adj_57 = {};
    wp::float32 adj_58 = {};
    wp::float32 adj_59 = {};
    wp::float32 adj_60 = {};
    wp::float32 adj_61 = {};
    wp::float32 adj_62 = {};
    wp::float32 adj_63 = {};
    wp::float32 adj_64 = {};
    wp::float32 adj_65 = {};
    wp::float32 adj_66 = {};
    wp::float32 adj_67 = {};
    wp::float32 adj_68 = {};
    wp::float32 adj_69 = {};
    bool adj_70 = {};
    wp::float32 adj_71 = {};
    wp::float32 adj_72 = {};
    wp::float32 adj_73 = {};
    wp::float32 adj_74 = {};
    wp::float32 adj_75 = {};
    wp::float32 adj_76 = {};
    wp::float32 adj_77 = {};
    wp::float32 adj_78 = {};
    wp::float32 adj_79 = {};
    wp::float32 adj_80 = {};
    wp::int32 adj_81 = {};
    wp::float32 adj_82 = {};
    wp::float32 adj_83 = {};
    wp::float32 adj_84 = {};
    wp::float32 adj_85 = {};
    wp::int32 adj_86 = {};
    wp::float32 adj_87 = {};
    wp::float32 adj_88 = {};
    bool adj_89 = {};
    bool adj_90 = {};
    wp::float32 adj_91 = {};
    wp::float32 adj_92 = {};
    wp::float32 adj_93 = {};
    bool adj_94 = {};
    wp::float32 adj_95 = {};
    wp::float32 adj_96 = {};
    bool adj_97 = {};
    wp::int32 adj_98 = {};
    wp::int32 adj_99 = {};
    wp::float32 adj_100 = {};
    wp::float32 adj_101 = {};
    wp::float32 adj_102 = {};
    wp::float32 adj_103 = {};
    wp::float32 adj_104 = {};
    wp::float32 adj_105 = {};
    wp::float32 adj_106 = {};
    wp::float32 adj_107 = {};
    wp::float32 adj_108 = {};
    wp::float32 adj_109 = {};
    wp::float32 adj_110 = {};
    wp::float32 adj_111 = {};
    bool adj_112 = {};
    wp::float32 adj_113 = {};
    wp::float32 adj_114 = {};
    wp::float32 adj_115 = {};
    wp::float32 adj_116 = {};
    wp::float32 adj_117 = {};
    wp::float32 adj_118 = {};
    wp::float32 adj_119 = {};
    wp::float32 adj_120 = {};
    wp::float32 adj_121 = {};
    wp::float32 adj_122 = {};
    wp::int32 adj_123 = {};
    wp::float32 adj_124 = {};
    wp::float32 adj_125 = {};
    wp::float32 adj_126 = {};
    wp::float32 adj_127 = {};
    bool adj_128 = {};
    wp::int32 adj_129 = {};
    bool adj_130 = {};
    bool adj_131 = {};
    wp::float32 adj_132 = {};
    bool adj_133 = {};
    wp::float32 adj_134 = {};
    bool adj_135 = {};
    wp::float32 adj_136 = {};
    wp::float32 adj_137 = {};
    wp::float32 adj_138 = {};
    wp::float32 adj_139 = {};
    wp::float32 adj_140 = {};
    bool adj_141 = {};
    wp::float32 adj_142 = {};
    wp::vec_t<3, wp::float32> adj_143 = {};
    wp::int32 adj_144 = {};
    wp::float32 adj_145 = {};
    wp::float32 adj_146 = {};
    wp::float32 adj_147 = {};
    bool adj_148 = {};
    wp::int32 adj_149 = {};
    wp::float32 adj_150 = {};
    wp::float32 adj_151 = {};
    wp::float32 adj_152 = {};
    wp::float32 adj_153 = {};
    wp::float32 adj_154 = {};
    wp::float32 adj_155 = {};
    wp::float32 adj_156 = {};
    wp::float32 adj_157 = {};
    bool adj_158 = {};
    wp::mat_t<3, 2, wp::int32> adj_159 = {};
    wp::int32 adj_160 = {};
    wp::int32 adj_161 = {};
    wp::int32 adj_162 = {};
    wp::int32 adj_163 = {};
    wp::float32 adj_164 = {};
    wp::float32 adj_165 = {};
    wp::float32 adj_166 = {};
    wp::float32 adj_167 = {};
    wp::float32 adj_168 = {};
    wp::float32 adj_169 = {};
    wp::float32 adj_170 = {};
    wp::float32 adj_171 = {};
    bool adj_172 = {};
    wp::float32 adj_173 = {};
    wp::float32 adj_174 = {};
    bool adj_175 = {};
    wp::float32 adj_176 = {};
    wp::float32 adj_177 = {};
    bool adj_178 = {};
    wp::float32 adj_179 = {};
    wp::float32 adj_180 = {};
    bool adj_181 = {};
    wp::int32 adj_182 = {};
    bool adj_183 = {};
    wp::float32 adj_184 = {};
    wp::float32 adj_185 = {};
    wp::float32 adj_186 = {};
    wp::int32 adj_187 = {};
    wp::float32 adj_188 = {};
    wp::float32 adj_189 = {};
    wp::float32 adj_190 = {};
    wp::float32 adj_191 = {};
    wp::float32 adj_192 = {};
    wp::float32 adj_193 = {};
    wp::float32 adj_194 = {};
    wp::float32 adj_195 = {};
    bool adj_196 = {};
    wp::int32 adj_197 = {};
    wp::int32 adj_198 = {};
    wp::int32 adj_199 = {};
    wp::int32 adj_200 = {};
    wp::float32 adj_201 = {};
    wp::float32 adj_202 = {};
    wp::float32 adj_203 = {};
    wp::float32 adj_204 = {};
    wp::float32 adj_205 = {};
    wp::float32 adj_206 = {};
    wp::float32 adj_207 = {};
    wp::float32 adj_208 = {};
    bool adj_209 = {};
    wp::float32 adj_210 = {};
    wp::float32 adj_211 = {};
    bool adj_212 = {};
    wp::float32 adj_213 = {};
    wp::float32 adj_214 = {};
    bool adj_215 = {};
    wp::float32 adj_216 = {};
    wp::float32 adj_217 = {};
    bool adj_218 = {};
    wp::int32 adj_219 = {};
    bool adj_220 = {};
    wp::float32 adj_221 = {};
    wp::float32 adj_222 = {};
    wp::float32 adj_223 = {};
    wp::int32 adj_224 = {};
    wp::int32 adj_225 = {};
    wp::float32 adj_226 = {};
    wp::float32 adj_227 = {};
    wp::int32 adj_228 = {};
    wp::float32 adj_229 = {};
    wp::float32 adj_230 = {};
    bool adj_231 = {};
    wp::int32 adj_232 = {};
    wp::float32 adj_233 = {};
    wp::float32 adj_234 = {};
    wp::float32 adj_235 = {};
    wp::float32 adj_236 = {};
    wp::float32 adj_237 = {};
    wp::float32 adj_238 = {};
    wp::float32 adj_239 = {};
    wp::float32 adj_240 = {};
    bool adj_241 = {};
    wp::int32 adj_242 = {};
    wp::int32 adj_243 = {};
    wp::int32 adj_244 = {};
    wp::int32 adj_245 = {};
    wp::float32 adj_246 = {};
    wp::float32 adj_247 = {};
    wp::float32 adj_248 = {};
    wp::float32 adj_249 = {};
    wp::float32 adj_250 = {};
    wp::float32 adj_251 = {};
    wp::float32 adj_252 = {};
    wp::float32 adj_253 = {};
    bool adj_254 = {};
    wp::float32 adj_255 = {};
    wp::float32 adj_256 = {};
    bool adj_257 = {};
    wp::float32 adj_258 = {};
    wp::float32 adj_259 = {};
    bool adj_260 = {};
    wp::float32 adj_261 = {};
    wp::float32 adj_262 = {};
    bool adj_263 = {};
    wp::int32 adj_264 = {};
    bool adj_265 = {};
    wp::float32 adj_266 = {};
    wp::float32 adj_267 = {};
    wp::float32 adj_268 = {};
    wp::int32 adj_269 = {};
    wp::int32 adj_270 = {};
    wp::float32 adj_271 = {};
    wp::float32 adj_272 = {};
    wp::int32 adj_273 = {};
    wp::float32 adj_274 = {};
    wp::float32 adj_275 = {};
    wp::float32 adj_276 = {};
    wp::float32 adj_277 = {};
    wp::float32 adj_278 = {};
    wp::float32 adj_279 = {};
    wp::float32 adj_280 = {};
    wp::float32 adj_281 = {};
    bool adj_282 = {};
    wp::int32 adj_283 = {};
    wp::int32 adj_284 = {};
    wp::int32 adj_285 = {};
    wp::int32 adj_286 = {};
    wp::float32 adj_287 = {};
    wp::float32 adj_288 = {};
    wp::float32 adj_289 = {};
    wp::float32 adj_290 = {};
    wp::float32 adj_291 = {};
    wp::float32 adj_292 = {};
    wp::float32 adj_293 = {};
    wp::float32 adj_294 = {};
    bool adj_295 = {};
    wp::float32 adj_296 = {};
    wp::float32 adj_297 = {};
    bool adj_298 = {};
    wp::float32 adj_299 = {};
    wp::float32 adj_300 = {};
    bool adj_301 = {};
    wp::float32 adj_302 = {};
    wp::float32 adj_303 = {};
    bool adj_304 = {};
    wp::int32 adj_305 = {};
    bool adj_306 = {};
    wp::float32 adj_307 = {};
    wp::float32 adj_308 = {};
    wp::float32 adj_309 = {};
    wp::int32 adj_310 = {};
    wp::int32 adj_311 = {};
    wp::float32 adj_312 = {};
    wp::float32 adj_313 = {};
    wp::int32 adj_314 = {};
    wp::float32 adj_315 = {};
    wp::int32 adj_316 = {};
    wp::int32 adj_317 = {};
    wp::float32 adj_318 = {};
    wp::float32 adj_319 = {};
    wp::int32 adj_320 = {};
    wp::float32 adj_321 = {};
    wp::float32 adj_322 = {};
    bool adj_323 = {};
    wp::int32 adj_324 = {};
    wp::float32 adj_325 = {};
    wp::float32 adj_326 = {};
    wp::float32 adj_327 = {};
    wp::float32 adj_328 = {};
    wp::float32 adj_329 = {};
    wp::float32 adj_330 = {};
    wp::float32 adj_331 = {};
    wp::float32 adj_332 = {};
    bool adj_333 = {};
    wp::int32 adj_334 = {};
    wp::int32 adj_335 = {};
    wp::int32 adj_336 = {};
    wp::int32 adj_337 = {};
    wp::float32 adj_338 = {};
    wp::float32 adj_339 = {};
    wp::float32 adj_340 = {};
    wp::float32 adj_341 = {};
    wp::float32 adj_342 = {};
    wp::float32 adj_343 = {};
    wp::float32 adj_344 = {};
    wp::float32 adj_345 = {};
    bool adj_346 = {};
    wp::float32 adj_347 = {};
    wp::float32 adj_348 = {};
    bool adj_349 = {};
    wp::float32 adj_350 = {};
    wp::float32 adj_351 = {};
    bool adj_352 = {};
    wp::float32 adj_353 = {};
    wp::float32 adj_354 = {};
    bool adj_355 = {};
    wp::int32 adj_356 = {};
    bool adj_357 = {};
    wp::float32 adj_358 = {};
    wp::float32 adj_359 = {};
    wp::float32 adj_360 = {};
    wp::int32 adj_361 = {};
    wp::int32 adj_362 = {};
    wp::float32 adj_363 = {};
    wp::float32 adj_364 = {};
    wp::int32 adj_365 = {};
    wp::float32 adj_366 = {};
    wp::float32 adj_367 = {};
    wp::float32 adj_368 = {};
    wp::float32 adj_369 = {};
    wp::float32 adj_370 = {};
    wp::float32 adj_371 = {};
    wp::float32 adj_372 = {};
    wp::float32 adj_373 = {};
    bool adj_374 = {};
    wp::int32 adj_375 = {};
    wp::int32 adj_376 = {};
    wp::int32 adj_377 = {};
    wp::int32 adj_378 = {};
    wp::float32 adj_379 = {};
    wp::float32 adj_380 = {};
    wp::float32 adj_381 = {};
    wp::float32 adj_382 = {};
    wp::float32 adj_383 = {};
    wp::float32 adj_384 = {};
    wp::float32 adj_385 = {};
    wp::float32 adj_386 = {};
    bool adj_387 = {};
    wp::float32 adj_388 = {};
    wp::float32 adj_389 = {};
    bool adj_390 = {};
    wp::float32 adj_391 = {};
    wp::float32 adj_392 = {};
    bool adj_393 = {};
    wp::float32 adj_394 = {};
    wp::float32 adj_395 = {};
    bool adj_396 = {};
    wp::int32 adj_397 = {};
    bool adj_398 = {};
    wp::float32 adj_399 = {};
    wp::float32 adj_400 = {};
    wp::float32 adj_401 = {};
    wp::int32 adj_402 = {};
    wp::int32 adj_403 = {};
    wp::float32 adj_404 = {};
    wp::float32 adj_405 = {};
    wp::int32 adj_406 = {};
    wp::float32 adj_407 = {};
    wp::int32 adj_408 = {};
    wp::int32 adj_409 = {};
    wp::float32 adj_410 = {};
    wp::float32 adj_411 = {};
    wp::vec_t<3, wp::float32> adj_412 = {};
    wp::vec_t<3, wp::float32> adj_413 = {};
    wp::int32 adj_414 = {};
    //---------
    // forward
    // def ray_intersect_box(ray_origin: wp.vec3, ray_direction: wp.vec3, size: wp.vec3) -> tuple[float, wp.vec3]:       <L 227>
    // t_hit = -1.0                                                                           <L 238>
    // normal = wp.vec3(0.0)                                                                  <L 239>
    var_2 = wp::vec_t<3, wp::float32>(var_1);
    // t_near = -1.0e10                                                                       <L 240>
    // t_far = 1.0e10                                                                         <L 241>
    // hit = 1                                                                                <L 242>
    // for i in range(3):                                                                     <L 244>
    // if wp.abs(ray_direction[i]) < MINVAL:                                                  <L 245>
    var_7 = wp::extract(var_ray_direction, var_6);
    var_8 = wp::abs(var_7);
    var_10 = (var_8 < var_9);
    if (var_10) {
        // if ray_origin[i] < -size[i] or ray_origin[i] > size[i]:                            <L 246>
        var_12 = wp::extract(var_ray_origin, var_6);
        var_13 = wp::extract(var_size, var_6);
        var_14 = wp::neg(var_13);
        var_15 = (var_12 < var_14);
        var_11 = var_15;
        if (!var_11) {
            var_16 = wp::extract(var_ray_origin, var_6);
            var_17 = wp::extract(var_size, var_6);
            var_18 = (var_16 > var_17);
            var_11 = var_11 || var_18;
        }
        if (var_11) {
            // hit = 0                                                                        <L 247>
        }
        var_20 = wp::where(var_11, var_19, var_5);
    }
    if (!var_10) {
        // inv_d_i = 1.0 / ray_direction[i]                                                   <L 249>
        var_22 = wp::extract(var_ray_direction, var_6);
        var_23 = wp::div(var_21, var_22);
        // t1 = (-size[i] - ray_origin[i]) * inv_d_i                                          <L 250>
        var_24 = wp::extract(var_size, var_6);
        var_25 = wp::neg(var_24);
        var_26 = wp::extract(var_ray_origin, var_6);
        var_27 = wp::sub(var_25, var_26);
        var_28 = wp::mul(var_27, var_23);
        // t2 = (size[i] - ray_origin[i]) * inv_d_i                                           <L 251>
        var_29 = wp::extract(var_size, var_6);
        var_30 = wp::extract(var_ray_origin, var_6);
        var_31 = wp::sub(var_29, var_30);
        var_32 = wp::mul(var_31, var_23);
        // if t1 > t2:                                                                        <L 253>
        var_33 = (var_28 > var_32);
        if (var_33) {
            // temp = t1                                                                      <L 254>
            var_34 = wp::copy(var_28);
            // t1 = t2                                                                        <L 255>
            var_35 = wp::copy(var_32);
            // t2 = temp                                                                      <L 256>
            var_36 = wp::copy(var_34);
        }
        var_37 = wp::where(var_33, var_35, var_28);
        var_38 = wp::where(var_33, var_36, var_32);
        // t_near = wp.max(t_near, t1)                                                        <L 258>
        var_39 = wp::max(var_3, var_37);
        // t_far = wp.min(t_far, t2)                                                          <L 259>
        var_40 = wp::min(var_4, var_38);
    }
    var_41 = wp::where(var_10, var_3, var_39);
    var_42 = wp::where(var_10, var_4, var_40);
    var_43 = wp::where(var_10, var_20, var_5);
    // if wp.abs(ray_direction[i]) < MINVAL:                                                  <L 245>
    var_45 = wp::extract(var_ray_direction, var_44);
    var_46 = wp::abs(var_45);
    var_47 = (var_46 < var_9);
    if (var_47) {
        // if ray_origin[i] < -size[i] or ray_origin[i] > size[i]:                            <L 246>
        var_49 = wp::extract(var_ray_origin, var_44);
        var_50 = wp::extract(var_size, var_44);
        var_51 = wp::neg(var_50);
        var_52 = (var_49 < var_51);
        var_48 = var_52;
        if (!var_48) {
            var_53 = wp::extract(var_ray_origin, var_44);
            var_54 = wp::extract(var_size, var_44);
            var_55 = (var_53 > var_54);
            var_48 = var_48 || var_55;
        }
        if (var_48) {
            // hit = 0                                                                        <L 247>
        }
        var_57 = wp::where(var_48, var_56, var_43);
    }
    if (!var_47) {
        // inv_d_i = 1.0 / ray_direction[i]                                                   <L 249>
        var_59 = wp::extract(var_ray_direction, var_44);
        var_60 = wp::div(var_58, var_59);
        // t1 = (-size[i] - ray_origin[i]) * inv_d_i                                          <L 250>
        var_61 = wp::extract(var_size, var_44);
        var_62 = wp::neg(var_61);
        var_63 = wp::extract(var_ray_origin, var_44);
        var_64 = wp::sub(var_62, var_63);
        var_65 = wp::mul(var_64, var_60);
        // t2 = (size[i] - ray_origin[i]) * inv_d_i                                           <L 251>
        var_66 = wp::extract(var_size, var_44);
        var_67 = wp::extract(var_ray_origin, var_44);
        var_68 = wp::sub(var_66, var_67);
        var_69 = wp::mul(var_68, var_60);
        // if t1 > t2:                                                                        <L 253>
        var_70 = (var_65 > var_69);
        if (var_70) {
            // temp = t1                                                                      <L 254>
            var_71 = wp::copy(var_65);
            // t1 = t2                                                                        <L 255>
            var_72 = wp::copy(var_69);
            // t2 = temp                                                                      <L 256>
            var_73 = wp::copy(var_71);
        }
        var_74 = wp::where(var_70, var_72, var_65);
        var_75 = wp::where(var_70, var_73, var_69);
        var_76 = wp::where(var_70, var_71, var_34);
        // t_near = wp.max(t_near, t1)                                                        <L 258>
        var_77 = wp::max(var_41, var_74);
        // t_far = wp.min(t_far, t2)                                                          <L 259>
        var_78 = wp::min(var_42, var_75);
    }
    var_79 = wp::where(var_47, var_41, var_77);
    var_80 = wp::where(var_47, var_42, var_78);
    var_81 = wp::where(var_47, var_57, var_43);
    var_82 = wp::where(var_47, var_23, var_60);
    var_83 = wp::where(var_47, var_37, var_74);
    var_84 = wp::where(var_47, var_38, var_75);
    var_85 = wp::where(var_47, var_34, var_76);
    // if wp.abs(ray_direction[i]) < MINVAL:                                                  <L 245>
    var_87 = wp::extract(var_ray_direction, var_86);
    var_88 = wp::abs(var_87);
    var_89 = (var_88 < var_9);
    if (var_89) {
        // if ray_origin[i] < -size[i] or ray_origin[i] > size[i]:                            <L 246>
        var_91 = wp::extract(var_ray_origin, var_86);
        var_92 = wp::extract(var_size, var_86);
        var_93 = wp::neg(var_92);
        var_94 = (var_91 < var_93);
        var_90 = var_94;
        if (!var_90) {
            var_95 = wp::extract(var_ray_origin, var_86);
            var_96 = wp::extract(var_size, var_86);
            var_97 = (var_95 > var_96);
            var_90 = var_90 || var_97;
        }
        if (var_90) {
            // hit = 0                                                                        <L 247>
        }
        var_99 = wp::where(var_90, var_98, var_81);
    }
    if (!var_89) {
        // inv_d_i = 1.0 / ray_direction[i]                                                   <L 249>
        var_101 = wp::extract(var_ray_direction, var_86);
        var_102 = wp::div(var_100, var_101);
        // t1 = (-size[i] - ray_origin[i]) * inv_d_i                                          <L 250>
        var_103 = wp::extract(var_size, var_86);
        var_104 = wp::neg(var_103);
        var_105 = wp::extract(var_ray_origin, var_86);
        var_106 = wp::sub(var_104, var_105);
        var_107 = wp::mul(var_106, var_102);
        // t2 = (size[i] - ray_origin[i]) * inv_d_i                                           <L 251>
        var_108 = wp::extract(var_size, var_86);
        var_109 = wp::extract(var_ray_origin, var_86);
        var_110 = wp::sub(var_108, var_109);
        var_111 = wp::mul(var_110, var_102);
        // if t1 > t2:                                                                        <L 253>
        var_112 = (var_107 > var_111);
        if (var_112) {
            // temp = t1                                                                      <L 254>
            var_113 = wp::copy(var_107);
            // t1 = t2                                                                        <L 255>
            var_114 = wp::copy(var_111);
            // t2 = temp                                                                      <L 256>
            var_115 = wp::copy(var_113);
        }
        var_116 = wp::where(var_112, var_114, var_107);
        var_117 = wp::where(var_112, var_115, var_111);
        var_118 = wp::where(var_112, var_113, var_85);
        // t_near = wp.max(t_near, t1)                                                        <L 258>
        var_119 = wp::max(var_79, var_116);
        // t_far = wp.min(t_far, t2)                                                          <L 259>
        var_120 = wp::min(var_80, var_117);
    }
    var_121 = wp::where(var_89, var_79, var_119);
    var_122 = wp::where(var_89, var_80, var_120);
    var_123 = wp::where(var_89, var_99, var_81);
    var_124 = wp::where(var_89, var_82, var_102);
    var_125 = wp::where(var_89, var_83, var_116);
    var_126 = wp::where(var_89, var_84, var_117);
    var_127 = wp::where(var_89, var_85, var_118);
    // if hit == 1 and t_near <= t_far and t_far >= 0.0:                                      <L 261>
    var_130 = (var_123 == var_129);
    var_128 = var_130;
    if (var_128) {
        var_131 = (var_121 <= var_122);
        var_128 = var_128 && var_131;
    }
    if (var_128) {
        var_133 = (var_122 >= var_132);
        var_128 = var_128 && var_133;
    }
    if (var_128) {
        // if t_near >= 0.0:                                                                  <L 262>
        var_135 = (var_121 >= var_134);
        if (var_135) {
            // t_hit = t_near                                                                 <L 263>
            var_136 = wp::copy(var_121);
        }
        if (!var_135) {
            // t_hit = t_far                                                                  <L 265>
            var_137 = wp::copy(var_122);
        }
        var_138 = wp::where(var_135, var_136, var_137);
    }
    var_139 = wp::where(var_128, var_138, var_0);
    // if t_hit >= 0.0:                                                                       <L 267>
    var_141 = (var_139 >= var_140);
    if (var_141) {
        // normal_local = wp.vec3(0.0)                                                        <L 269>
        var_143 = wp::vec_t<3, wp::float32>(var_142);
        // for i in range(3):                                                                 <L 270>
        // if wp.abs(ray_direction[i]) > EPSILON:                                             <L 271>
        var_145 = wp::extract(var_ray_direction, var_144);
        var_146 = wp::abs(var_145);
        var_148 = (var_146 > var_147);
        if (var_148) {
            // for side in range(-1, 2, 2):                                                   <L 272>
            // sol = (float(side) * size[i] - ray_origin[i]) / ray_direction[i]               <L 273>
            var_150 = wp::float(var_149);
            var_151 = wp::extract(var_size, var_144);
            var_152 = wp::mul(var_150, var_151);
            var_153 = wp::extract(var_ray_origin, var_144);
            var_154 = wp::sub(var_152, var_153);
            var_155 = wp::extract(var_ray_direction, var_144);
            var_156 = wp::div(var_154, var_155);
            // if sol >= 0.0:                                                                 <L 274>
            var_158 = (var_156 >= var_157);
            if (var_158) {
                // id0 = _IFACE[i][0]                                                         <L 275>
                var_161 = wp::extract(var_159, var_144, var_160);
                // id1 = _IFACE[i][1]                                                         <L 276>
                var_163 = wp::extract(var_159, var_144, var_162);
                // p0 = ray_origin[id0] + sol * ray_direction[id0]                            <L 277>
                var_164 = wp::extract(var_ray_origin, var_161);
                var_165 = wp::extract(var_ray_direction, var_161);
                var_166 = wp::mul(var_156, var_165);
                var_167 = wp::add(var_164, var_166);
                // p1 = ray_origin[id1] + sol * ray_direction[id1]                            <L 278>
                var_168 = wp::extract(var_ray_origin, var_163);
                var_169 = wp::extract(var_ray_direction, var_163);
                var_170 = wp::mul(var_156, var_169);
                var_171 = wp::add(var_168, var_170);
                // if wp.abs(p0) <= size[id0] and wp.abs(p1) <= size[id1]:                    <L 279>
                var_173 = wp::abs(var_167);
                var_174 = wp::extract(var_size, var_161);
                var_175 = (var_173 <= var_174);
                var_172 = var_175;
                if (var_172) {
                    var_176 = wp::abs(var_171);
                    var_177 = wp::extract(var_size, var_163);
                    var_178 = (var_176 <= var_177);
                    var_172 = var_172 && var_178;
                }
                if (var_172) {
                    // if wp.abs(sol - t_hit) < EPSILON:                                      <L 280>
                    var_179 = wp::sub(var_156, var_139);
                    var_180 = wp::abs(var_179);
                    var_181 = (var_180 < var_147);
                    if (var_181) {
                        // normal_local[i] = -1.0 if side < 0 else 1.0                        <L 281>
                        var_183 = (var_149 < var_182);
                        if (var_183) {
                        }
                        if (!var_183) {
                        }
                        var_186 = wp::where(var_183, var_184, var_185);
                        wp::assign_inplace(var_143, var_144, var_186);
                    }
                }
            }
            // sol = (float(side) * size[i] - ray_origin[i]) / ray_direction[i]               <L 273>
            var_188 = wp::float(var_187);
            var_189 = wp::extract(var_size, var_144);
            var_190 = wp::mul(var_188, var_189);
            var_191 = wp::extract(var_ray_origin, var_144);
            var_192 = wp::sub(var_190, var_191);
            var_193 = wp::extract(var_ray_direction, var_144);
            var_194 = wp::div(var_192, var_193);
            // if sol >= 0.0:                                                                 <L 274>
            var_196 = (var_194 >= var_195);
            if (var_196) {
                // id0 = _IFACE[i][0]                                                         <L 275>
                var_198 = wp::extract(var_159, var_144, var_197);
                // id1 = _IFACE[i][1]                                                         <L 276>
                var_200 = wp::extract(var_159, var_144, var_199);
                // p0 = ray_origin[id0] + sol * ray_direction[id0]                            <L 277>
                var_201 = wp::extract(var_ray_origin, var_198);
                var_202 = wp::extract(var_ray_direction, var_198);
                var_203 = wp::mul(var_194, var_202);
                var_204 = wp::add(var_201, var_203);
                // p1 = ray_origin[id1] + sol * ray_direction[id1]                            <L 278>
                var_205 = wp::extract(var_ray_origin, var_200);
                var_206 = wp::extract(var_ray_direction, var_200);
                var_207 = wp::mul(var_194, var_206);
                var_208 = wp::add(var_205, var_207);
                // if wp.abs(p0) <= size[id0] and wp.abs(p1) <= size[id1]:                    <L 279>
                var_210 = wp::abs(var_204);
                var_211 = wp::extract(var_size, var_198);
                var_212 = (var_210 <= var_211);
                var_209 = var_212;
                if (var_209) {
                    var_213 = wp::abs(var_208);
                    var_214 = wp::extract(var_size, var_200);
                    var_215 = (var_213 <= var_214);
                    var_209 = var_209 && var_215;
                }
                if (var_209) {
                    // if wp.abs(sol - t_hit) < EPSILON:                                      <L 280>
                    var_216 = wp::sub(var_194, var_139);
                    var_217 = wp::abs(var_216);
                    var_218 = (var_217 < var_147);
                    if (var_218) {
                        // normal_local[i] = -1.0 if side < 0 else 1.0                        <L 281>
                        var_220 = (var_187 < var_219);
                        if (var_220) {
                        }
                        if (!var_220) {
                        }
                        var_223 = wp::where(var_220, var_221, var_222);
                        wp::assign_inplace(var_143, var_144, var_223);
                    }
                }
            }
            var_224 = wp::where(var_196, var_198, var_161);
            var_225 = wp::where(var_196, var_200, var_163);
            var_226 = wp::where(var_196, var_204, var_167);
            var_227 = wp::where(var_196, var_208, var_171);
        }
        // if wp.abs(ray_direction[i]) > EPSILON:                                             <L 271>
        var_229 = wp::extract(var_ray_direction, var_228);
        var_230 = wp::abs(var_229);
        var_231 = (var_230 > var_147);
        if (var_231) {
            // for side in range(-1, 2, 2):                                                   <L 272>
            // sol = (float(side) * size[i] - ray_origin[i]) / ray_direction[i]               <L 273>
            var_233 = wp::float(var_232);
            var_234 = wp::extract(var_size, var_228);
            var_235 = wp::mul(var_233, var_234);
            var_236 = wp::extract(var_ray_origin, var_228);
            var_237 = wp::sub(var_235, var_236);
            var_238 = wp::extract(var_ray_direction, var_228);
            var_239 = wp::div(var_237, var_238);
            // if sol >= 0.0:                                                                 <L 274>
            var_241 = (var_239 >= var_240);
            if (var_241) {
                // id0 = _IFACE[i][0]                                                         <L 275>
                var_243 = wp::extract(var_159, var_228, var_242);
                // id1 = _IFACE[i][1]                                                         <L 276>
                var_245 = wp::extract(var_159, var_228, var_244);
                // p0 = ray_origin[id0] + sol * ray_direction[id0]                            <L 277>
                var_246 = wp::extract(var_ray_origin, var_243);
                var_247 = wp::extract(var_ray_direction, var_243);
                var_248 = wp::mul(var_239, var_247);
                var_249 = wp::add(var_246, var_248);
                // p1 = ray_origin[id1] + sol * ray_direction[id1]                            <L 278>
                var_250 = wp::extract(var_ray_origin, var_245);
                var_251 = wp::extract(var_ray_direction, var_245);
                var_252 = wp::mul(var_239, var_251);
                var_253 = wp::add(var_250, var_252);
                // if wp.abs(p0) <= size[id0] and wp.abs(p1) <= size[id1]:                    <L 279>
                var_255 = wp::abs(var_249);
                var_256 = wp::extract(var_size, var_243);
                var_257 = (var_255 <= var_256);
                var_254 = var_257;
                if (var_254) {
                    var_258 = wp::abs(var_253);
                    var_259 = wp::extract(var_size, var_245);
                    var_260 = (var_258 <= var_259);
                    var_254 = var_254 && var_260;
                }
                if (var_254) {
                    // if wp.abs(sol - t_hit) < EPSILON:                                      <L 280>
                    var_261 = wp::sub(var_239, var_139);
                    var_262 = wp::abs(var_261);
                    var_263 = (var_262 < var_147);
                    if (var_263) {
                        // normal_local[i] = -1.0 if side < 0 else 1.0                        <L 281>
                        var_265 = (var_232 < var_264);
                        if (var_265) {
                        }
                        if (!var_265) {
                        }
                        var_268 = wp::where(var_265, var_266, var_267);
                        wp::assign_inplace(var_143, var_228, var_268);
                    }
                }
            }
            var_269 = wp::where(var_241, var_243, var_224);
            var_270 = wp::where(var_241, var_245, var_225);
            var_271 = wp::where(var_241, var_249, var_226);
            var_272 = wp::where(var_241, var_253, var_227);
            // sol = (float(side) * size[i] - ray_origin[i]) / ray_direction[i]               <L 273>
            var_274 = wp::float(var_273);
            var_275 = wp::extract(var_size, var_228);
            var_276 = wp::mul(var_274, var_275);
            var_277 = wp::extract(var_ray_origin, var_228);
            var_278 = wp::sub(var_276, var_277);
            var_279 = wp::extract(var_ray_direction, var_228);
            var_280 = wp::div(var_278, var_279);
            // if sol >= 0.0:                                                                 <L 274>
            var_282 = (var_280 >= var_281);
            if (var_282) {
                // id0 = _IFACE[i][0]                                                         <L 275>
                var_284 = wp::extract(var_159, var_228, var_283);
                // id1 = _IFACE[i][1]                                                         <L 276>
                var_286 = wp::extract(var_159, var_228, var_285);
                // p0 = ray_origin[id0] + sol * ray_direction[id0]                            <L 277>
                var_287 = wp::extract(var_ray_origin, var_284);
                var_288 = wp::extract(var_ray_direction, var_284);
                var_289 = wp::mul(var_280, var_288);
                var_290 = wp::add(var_287, var_289);
                // p1 = ray_origin[id1] + sol * ray_direction[id1]                            <L 278>
                var_291 = wp::extract(var_ray_origin, var_286);
                var_292 = wp::extract(var_ray_direction, var_286);
                var_293 = wp::mul(var_280, var_292);
                var_294 = wp::add(var_291, var_293);
                // if wp.abs(p0) <= size[id0] and wp.abs(p1) <= size[id1]:                    <L 279>
                var_296 = wp::abs(var_290);
                var_297 = wp::extract(var_size, var_284);
                var_298 = (var_296 <= var_297);
                var_295 = var_298;
                if (var_295) {
                    var_299 = wp::abs(var_294);
                    var_300 = wp::extract(var_size, var_286);
                    var_301 = (var_299 <= var_300);
                    var_295 = var_295 && var_301;
                }
                if (var_295) {
                    // if wp.abs(sol - t_hit) < EPSILON:                                      <L 280>
                    var_302 = wp::sub(var_280, var_139);
                    var_303 = wp::abs(var_302);
                    var_304 = (var_303 < var_147);
                    if (var_304) {
                        // normal_local[i] = -1.0 if side < 0 else 1.0                        <L 281>
                        var_306 = (var_273 < var_305);
                        if (var_306) {
                        }
                        if (!var_306) {
                        }
                        var_309 = wp::where(var_306, var_307, var_308);
                        wp::assign_inplace(var_143, var_228, var_309);
                    }
                }
            }
            var_310 = wp::where(var_282, var_284, var_269);
            var_311 = wp::where(var_282, var_286, var_270);
            var_312 = wp::where(var_282, var_290, var_271);
            var_313 = wp::where(var_282, var_294, var_272);
        }
        var_314 = wp::where(var_231, var_273, var_187);
        var_315 = wp::where(var_231, var_280, var_194);
        var_316 = wp::where(var_231, var_310, var_224);
        var_317 = wp::where(var_231, var_311, var_225);
        var_318 = wp::where(var_231, var_312, var_226);
        var_319 = wp::where(var_231, var_313, var_227);
        // if wp.abs(ray_direction[i]) > EPSILON:                                             <L 271>
        var_321 = wp::extract(var_ray_direction, var_320);
        var_322 = wp::abs(var_321);
        var_323 = (var_322 > var_147);
        if (var_323) {
            // for side in range(-1, 2, 2):                                                   <L 272>
            // sol = (float(side) * size[i] - ray_origin[i]) / ray_direction[i]               <L 273>
            var_325 = wp::float(var_324);
            var_326 = wp::extract(var_size, var_320);
            var_327 = wp::mul(var_325, var_326);
            var_328 = wp::extract(var_ray_origin, var_320);
            var_329 = wp::sub(var_327, var_328);
            var_330 = wp::extract(var_ray_direction, var_320);
            var_331 = wp::div(var_329, var_330);
            // if sol >= 0.0:                                                                 <L 274>
            var_333 = (var_331 >= var_332);
            if (var_333) {
                // id0 = _IFACE[i][0]                                                         <L 275>
                var_335 = wp::extract(var_159, var_320, var_334);
                // id1 = _IFACE[i][1]                                                         <L 276>
                var_337 = wp::extract(var_159, var_320, var_336);
                // p0 = ray_origin[id0] + sol * ray_direction[id0]                            <L 277>
                var_338 = wp::extract(var_ray_origin, var_335);
                var_339 = wp::extract(var_ray_direction, var_335);
                var_340 = wp::mul(var_331, var_339);
                var_341 = wp::add(var_338, var_340);
                // p1 = ray_origin[id1] + sol * ray_direction[id1]                            <L 278>
                var_342 = wp::extract(var_ray_origin, var_337);
                var_343 = wp::extract(var_ray_direction, var_337);
                var_344 = wp::mul(var_331, var_343);
                var_345 = wp::add(var_342, var_344);
                // if wp.abs(p0) <= size[id0] and wp.abs(p1) <= size[id1]:                    <L 279>
                var_347 = wp::abs(var_341);
                var_348 = wp::extract(var_size, var_335);
                var_349 = (var_347 <= var_348);
                var_346 = var_349;
                if (var_346) {
                    var_350 = wp::abs(var_345);
                    var_351 = wp::extract(var_size, var_337);
                    var_352 = (var_350 <= var_351);
                    var_346 = var_346 && var_352;
                }
                if (var_346) {
                    // if wp.abs(sol - t_hit) < EPSILON:                                      <L 280>
                    var_353 = wp::sub(var_331, var_139);
                    var_354 = wp::abs(var_353);
                    var_355 = (var_354 < var_147);
                    if (var_355) {
                        // normal_local[i] = -1.0 if side < 0 else 1.0                        <L 281>
                        var_357 = (var_324 < var_356);
                        if (var_357) {
                        }
                        if (!var_357) {
                        }
                        var_360 = wp::where(var_357, var_358, var_359);
                        wp::assign_inplace(var_143, var_320, var_360);
                    }
                }
            }
            var_361 = wp::where(var_333, var_335, var_316);
            var_362 = wp::where(var_333, var_337, var_317);
            var_363 = wp::where(var_333, var_341, var_318);
            var_364 = wp::where(var_333, var_345, var_319);
            // sol = (float(side) * size[i] - ray_origin[i]) / ray_direction[i]               <L 273>
            var_366 = wp::float(var_365);
            var_367 = wp::extract(var_size, var_320);
            var_368 = wp::mul(var_366, var_367);
            var_369 = wp::extract(var_ray_origin, var_320);
            var_370 = wp::sub(var_368, var_369);
            var_371 = wp::extract(var_ray_direction, var_320);
            var_372 = wp::div(var_370, var_371);
            // if sol >= 0.0:                                                                 <L 274>
            var_374 = (var_372 >= var_373);
            if (var_374) {
                // id0 = _IFACE[i][0]                                                         <L 275>
                var_376 = wp::extract(var_159, var_320, var_375);
                // id1 = _IFACE[i][1]                                                         <L 276>
                var_378 = wp::extract(var_159, var_320, var_377);
                // p0 = ray_origin[id0] + sol * ray_direction[id0]                            <L 277>
                var_379 = wp::extract(var_ray_origin, var_376);
                var_380 = wp::extract(var_ray_direction, var_376);
                var_381 = wp::mul(var_372, var_380);
                var_382 = wp::add(var_379, var_381);
                // p1 = ray_origin[id1] + sol * ray_direction[id1]                            <L 278>
                var_383 = wp::extract(var_ray_origin, var_378);
                var_384 = wp::extract(var_ray_direction, var_378);
                var_385 = wp::mul(var_372, var_384);
                var_386 = wp::add(var_383, var_385);
                // if wp.abs(p0) <= size[id0] and wp.abs(p1) <= size[id1]:                    <L 279>
                var_388 = wp::abs(var_382);
                var_389 = wp::extract(var_size, var_376);
                var_390 = (var_388 <= var_389);
                var_387 = var_390;
                if (var_387) {
                    var_391 = wp::abs(var_386);
                    var_392 = wp::extract(var_size, var_378);
                    var_393 = (var_391 <= var_392);
                    var_387 = var_387 && var_393;
                }
                if (var_387) {
                    // if wp.abs(sol - t_hit) < EPSILON:                                      <L 280>
                    var_394 = wp::sub(var_372, var_139);
                    var_395 = wp::abs(var_394);
                    var_396 = (var_395 < var_147);
                    if (var_396) {
                        // normal_local[i] = -1.0 if side < 0 else 1.0                        <L 281>
                        var_398 = (var_365 < var_397);
                        if (var_398) {
                        }
                        if (!var_398) {
                        }
                        var_401 = wp::where(var_398, var_399, var_400);
                        wp::assign_inplace(var_143, var_320, var_401);
                    }
                }
            }
            var_402 = wp::where(var_374, var_376, var_361);
            var_403 = wp::where(var_374, var_378, var_362);
            var_404 = wp::where(var_374, var_382, var_363);
            var_405 = wp::where(var_374, var_386, var_364);
        }
        var_406 = wp::where(var_323, var_365, var_314);
        var_407 = wp::where(var_323, var_372, var_315);
        var_408 = wp::where(var_323, var_402, var_316);
        var_409 = wp::where(var_323, var_403, var_317);
        var_410 = wp::where(var_323, var_404, var_318);
        var_411 = wp::where(var_323, var_405, var_319);
        // normal = wp.normalize(normal_local)                                                <L 282>
        var_412 = wp::normalize(var_143);
    }
    var_413 = wp::where(var_141, var_412, var_2);
    var_414 = wp::where(var_141, var_320, var_86);
    // return t_hit, normal                                                                   <L 284>
    ret_0 = var_139;
    ret_1 = var_413;
    goto label0;
    //---------
    // reverse
    label0:;
    adj_413 += adj_ret_1;
    adj_139 += adj_ret_0;
    // adj: return t_hit, normal                                                              <L 284>
    wp::adj_where(var_141, var_320, var_86, adj_141, adj_320, adj_86, adj_414);
    wp::adj_where(var_141, var_412, var_2, adj_141, adj_412, adj_2, adj_413);
    if (var_141) {
        wp::adj_normalize(var_143, var_412, adj_143, adj_412);
        // adj: normal = wp.normalize(normal_local)                                           <L 282>
        wp::adj_where(var_323, var_405, var_319, adj_323, adj_405, adj_319, adj_411);
        wp::adj_where(var_323, var_404, var_318, adj_323, adj_404, adj_318, adj_410);
        wp::adj_where(var_323, var_403, var_317, adj_323, adj_403, adj_317, adj_409);
        wp::adj_where(var_323, var_402, var_316, adj_323, adj_402, adj_316, adj_408);
        wp::adj_where(var_323, var_372, var_315, adj_323, adj_372, adj_315, adj_407);
        wp::adj_where(var_323, var_365, var_314, adj_323, adj_365, adj_314, adj_406);
        if (var_323) {
            wp::adj_where(var_374, var_386, var_364, adj_374, adj_386, adj_364, adj_405);
            wp::adj_where(var_374, var_382, var_363, adj_374, adj_382, adj_363, adj_404);
            wp::adj_where(var_374, var_378, var_362, adj_374, adj_378, adj_362, adj_403);
            wp::adj_where(var_374, var_376, var_361, adj_374, adj_376, adj_361, adj_402);
            if (var_374) {
                if (var_387) {
                    if (var_396) {
                        wp::adj_assign_inplace(var_143, var_320, var_401, adj_143, adj_320, adj_401);
                        wp::adj_where(var_398, var_399, var_400, adj_398, adj_399, adj_400, adj_401);
                        if (!var_398) {
                        }
                        if (var_398) {
                        }
                        // adj: normal_local[i] = -1.0 if side < 0 else 1.0                   <L 281>
                    }
                    wp::adj_abs(var_394, adj_394, adj_395);
                    wp::adj_sub(var_372, var_139, adj_372, adj_139, adj_394);
                    // adj: if wp.abs(sol - t_hit) < EPSILON:                                 <L 280>
                }
                if (var_387) {
                    wp::adj_extract(var_size, var_378, adj_size, adj_378, adj_392);
                    wp::adj_abs(var_386, adj_386, adj_391);
                }
                wp::adj_extract(var_size, var_376, adj_size, adj_376, adj_389);
                wp::adj_abs(var_382, adj_382, adj_388);
                // adj: if wp.abs(p0) <= size[id0] and wp.abs(p1) <= size[id1]:               <L 279>
                wp::adj_add(var_383, var_385, adj_383, adj_385, adj_386);
                wp::adj_mul(var_372, var_384, adj_372, adj_384, adj_385);
                wp::adj_extract(var_ray_direction, var_378, adj_ray_direction, adj_378, adj_384);
                wp::adj_extract(var_ray_origin, var_378, adj_ray_origin, adj_378, adj_383);
                // adj: p1 = ray_origin[id1] + sol * ray_direction[id1]                       <L 278>
                wp::adj_add(var_379, var_381, adj_379, adj_381, adj_382);
                wp::adj_mul(var_372, var_380, adj_372, adj_380, adj_381);
                wp::adj_extract(var_ray_direction, var_376, adj_ray_direction, adj_376, adj_380);
                wp::adj_extract(var_ray_origin, var_376, adj_ray_origin, adj_376, adj_379);
                // adj: p0 = ray_origin[id0] + sol * ray_direction[id0]                       <L 277>
                wp::adj_extract(var_159, var_320, var_377, adj_159, adj_320, adj_377, adj_378);
                // adj: id1 = _IFACE[i][1]                                                    <L 276>
                wp::adj_extract(var_159, var_320, var_375, adj_159, adj_320, adj_375, adj_376);
                // adj: id0 = _IFACE[i][0]                                                    <L 275>
            }
            // adj: if sol >= 0.0:                                                            <L 274>
            wp::adj_div(var_370, var_371, var_372, adj_370, adj_371, adj_372);
            wp::adj_extract(var_ray_direction, var_320, adj_ray_direction, adj_320, adj_371);
            wp::adj_sub(var_368, var_369, adj_368, adj_369, adj_370);
            wp::adj_extract(var_ray_origin, var_320, adj_ray_origin, adj_320, adj_369);
            wp::adj_mul(var_366, var_367, adj_366, adj_367, adj_368);
            wp::adj_extract(var_size, var_320, adj_size, adj_320, adj_367);
            wp::adj_float(var_365, adj_365, adj_366);
            // adj: sol = (float(side) * size[i] - ray_origin[i]) / ray_direction[i]          <L 273>
            wp::adj_where(var_333, var_345, var_319, adj_333, adj_345, adj_319, adj_364);
            wp::adj_where(var_333, var_341, var_318, adj_333, adj_341, adj_318, adj_363);
            wp::adj_where(var_333, var_337, var_317, adj_333, adj_337, adj_317, adj_362);
            wp::adj_where(var_333, var_335, var_316, adj_333, adj_335, adj_316, adj_361);
            if (var_333) {
                if (var_346) {
                    if (var_355) {
                        wp::adj_assign_inplace(var_143, var_320, var_360, adj_143, adj_320, adj_360);
                        wp::adj_where(var_357, var_358, var_359, adj_357, adj_358, adj_359, adj_360);
                        if (!var_357) {
                        }
                        if (var_357) {
                        }
                        // adj: normal_local[i] = -1.0 if side < 0 else 1.0                   <L 281>
                    }
                    wp::adj_abs(var_353, adj_353, adj_354);
                    wp::adj_sub(var_331, var_139, adj_331, adj_139, adj_353);
                    // adj: if wp.abs(sol - t_hit) < EPSILON:                                 <L 280>
                }
                if (var_346) {
                    wp::adj_extract(var_size, var_337, adj_size, adj_337, adj_351);
                    wp::adj_abs(var_345, adj_345, adj_350);
                }
                wp::adj_extract(var_size, var_335, adj_size, adj_335, adj_348);
                wp::adj_abs(var_341, adj_341, adj_347);
                // adj: if wp.abs(p0) <= size[id0] and wp.abs(p1) <= size[id1]:               <L 279>
                wp::adj_add(var_342, var_344, adj_342, adj_344, adj_345);
                wp::adj_mul(var_331, var_343, adj_331, adj_343, adj_344);
                wp::adj_extract(var_ray_direction, var_337, adj_ray_direction, adj_337, adj_343);
                wp::adj_extract(var_ray_origin, var_337, adj_ray_origin, adj_337, adj_342);
                // adj: p1 = ray_origin[id1] + sol * ray_direction[id1]                       <L 278>
                wp::adj_add(var_338, var_340, adj_338, adj_340, adj_341);
                wp::adj_mul(var_331, var_339, adj_331, adj_339, adj_340);
                wp::adj_extract(var_ray_direction, var_335, adj_ray_direction, adj_335, adj_339);
                wp::adj_extract(var_ray_origin, var_335, adj_ray_origin, adj_335, adj_338);
                // adj: p0 = ray_origin[id0] + sol * ray_direction[id0]                       <L 277>
                wp::adj_extract(var_159, var_320, var_336, adj_159, adj_320, adj_336, adj_337);
                // adj: id1 = _IFACE[i][1]                                                    <L 276>
                wp::adj_extract(var_159, var_320, var_334, adj_159, adj_320, adj_334, adj_335);
                // adj: id0 = _IFACE[i][0]                                                    <L 275>
            }
            // adj: if sol >= 0.0:                                                            <L 274>
            wp::adj_div(var_329, var_330, var_331, adj_329, adj_330, adj_331);
            wp::adj_extract(var_ray_direction, var_320, adj_ray_direction, adj_320, adj_330);
            wp::adj_sub(var_327, var_328, adj_327, adj_328, adj_329);
            wp::adj_extract(var_ray_origin, var_320, adj_ray_origin, adj_320, adj_328);
            wp::adj_mul(var_325, var_326, adj_325, adj_326, adj_327);
            wp::adj_extract(var_size, var_320, adj_size, adj_320, adj_326);
            wp::adj_float(var_324, adj_324, adj_325);
            // adj: sol = (float(side) * size[i] - ray_origin[i]) / ray_direction[i]          <L 273>
            // adj: for side in range(-1, 2, 2):                                              <L 272>
        }
        wp::adj_abs(var_321, adj_321, adj_322);
        wp::adj_extract(var_ray_direction, var_320, adj_ray_direction, adj_320, adj_321);
        // adj: if wp.abs(ray_direction[i]) > EPSILON:                                        <L 271>
        wp::adj_where(var_231, var_313, var_227, adj_231, adj_313, adj_227, adj_319);
        wp::adj_where(var_231, var_312, var_226, adj_231, adj_312, adj_226, adj_318);
        wp::adj_where(var_231, var_311, var_225, adj_231, adj_311, adj_225, adj_317);
        wp::adj_where(var_231, var_310, var_224, adj_231, adj_310, adj_224, adj_316);
        wp::adj_where(var_231, var_280, var_194, adj_231, adj_280, adj_194, adj_315);
        wp::adj_where(var_231, var_273, var_187, adj_231, adj_273, adj_187, adj_314);
        if (var_231) {
            wp::adj_where(var_282, var_294, var_272, adj_282, adj_294, adj_272, adj_313);
            wp::adj_where(var_282, var_290, var_271, adj_282, adj_290, adj_271, adj_312);
            wp::adj_where(var_282, var_286, var_270, adj_282, adj_286, adj_270, adj_311);
            wp::adj_where(var_282, var_284, var_269, adj_282, adj_284, adj_269, adj_310);
            if (var_282) {
                if (var_295) {
                    if (var_304) {
                        wp::adj_assign_inplace(var_143, var_228, var_309, adj_143, adj_228, adj_309);
                        wp::adj_where(var_306, var_307, var_308, adj_306, adj_307, adj_308, adj_309);
                        if (!var_306) {
                        }
                        if (var_306) {
                        }
                        // adj: normal_local[i] = -1.0 if side < 0 else 1.0                   <L 281>
                    }
                    wp::adj_abs(var_302, adj_302, adj_303);
                    wp::adj_sub(var_280, var_139, adj_280, adj_139, adj_302);
                    // adj: if wp.abs(sol - t_hit) < EPSILON:                                 <L 280>
                }
                if (var_295) {
                    wp::adj_extract(var_size, var_286, adj_size, adj_286, adj_300);
                    wp::adj_abs(var_294, adj_294, adj_299);
                }
                wp::adj_extract(var_size, var_284, adj_size, adj_284, adj_297);
                wp::adj_abs(var_290, adj_290, adj_296);
                // adj: if wp.abs(p0) <= size[id0] and wp.abs(p1) <= size[id1]:               <L 279>
                wp::adj_add(var_291, var_293, adj_291, adj_293, adj_294);
                wp::adj_mul(var_280, var_292, adj_280, adj_292, adj_293);
                wp::adj_extract(var_ray_direction, var_286, adj_ray_direction, adj_286, adj_292);
                wp::adj_extract(var_ray_origin, var_286, adj_ray_origin, adj_286, adj_291);
                // adj: p1 = ray_origin[id1] + sol * ray_direction[id1]                       <L 278>
                wp::adj_add(var_287, var_289, adj_287, adj_289, adj_290);
                wp::adj_mul(var_280, var_288, adj_280, adj_288, adj_289);
                wp::adj_extract(var_ray_direction, var_284, adj_ray_direction, adj_284, adj_288);
                wp::adj_extract(var_ray_origin, var_284, adj_ray_origin, adj_284, adj_287);
                // adj: p0 = ray_origin[id0] + sol * ray_direction[id0]                       <L 277>
                wp::adj_extract(var_159, var_228, var_285, adj_159, adj_228, adj_285, adj_286);
                // adj: id1 = _IFACE[i][1]                                                    <L 276>
                wp::adj_extract(var_159, var_228, var_283, adj_159, adj_228, adj_283, adj_284);
                // adj: id0 = _IFACE[i][0]                                                    <L 275>
            }
            // adj: if sol >= 0.0:                                                            <L 274>
            wp::adj_div(var_278, var_279, var_280, adj_278, adj_279, adj_280);
            wp::adj_extract(var_ray_direction, var_228, adj_ray_direction, adj_228, adj_279);
            wp::adj_sub(var_276, var_277, adj_276, adj_277, adj_278);
            wp::adj_extract(var_ray_origin, var_228, adj_ray_origin, adj_228, adj_277);
            wp::adj_mul(var_274, var_275, adj_274, adj_275, adj_276);
            wp::adj_extract(var_size, var_228, adj_size, adj_228, adj_275);
            wp::adj_float(var_273, adj_273, adj_274);
            // adj: sol = (float(side) * size[i] - ray_origin[i]) / ray_direction[i]          <L 273>
            wp::adj_where(var_241, var_253, var_227, adj_241, adj_253, adj_227, adj_272);
            wp::adj_where(var_241, var_249, var_226, adj_241, adj_249, adj_226, adj_271);
            wp::adj_where(var_241, var_245, var_225, adj_241, adj_245, adj_225, adj_270);
            wp::adj_where(var_241, var_243, var_224, adj_241, adj_243, adj_224, adj_269);
            if (var_241) {
                if (var_254) {
                    if (var_263) {
                        wp::adj_assign_inplace(var_143, var_228, var_268, adj_143, adj_228, adj_268);
                        wp::adj_where(var_265, var_266, var_267, adj_265, adj_266, adj_267, adj_268);
                        if (!var_265) {
                        }
                        if (var_265) {
                        }
                        // adj: normal_local[i] = -1.0 if side < 0 else 1.0                   <L 281>
                    }
                    wp::adj_abs(var_261, adj_261, adj_262);
                    wp::adj_sub(var_239, var_139, adj_239, adj_139, adj_261);
                    // adj: if wp.abs(sol - t_hit) < EPSILON:                                 <L 280>
                }
                if (var_254) {
                    wp::adj_extract(var_size, var_245, adj_size, adj_245, adj_259);
                    wp::adj_abs(var_253, adj_253, adj_258);
                }
                wp::adj_extract(var_size, var_243, adj_size, adj_243, adj_256);
                wp::adj_abs(var_249, adj_249, adj_255);
                // adj: if wp.abs(p0) <= size[id0] and wp.abs(p1) <= size[id1]:               <L 279>
                wp::adj_add(var_250, var_252, adj_250, adj_252, adj_253);
                wp::adj_mul(var_239, var_251, adj_239, adj_251, adj_252);
                wp::adj_extract(var_ray_direction, var_245, adj_ray_direction, adj_245, adj_251);
                wp::adj_extract(var_ray_origin, var_245, adj_ray_origin, adj_245, adj_250);
                // adj: p1 = ray_origin[id1] + sol * ray_direction[id1]                       <L 278>
                wp::adj_add(var_246, var_248, adj_246, adj_248, adj_249);
                wp::adj_mul(var_239, var_247, adj_239, adj_247, adj_248);
                wp::adj_extract(var_ray_direction, var_243, adj_ray_direction, adj_243, adj_247);
                wp::adj_extract(var_ray_origin, var_243, adj_ray_origin, adj_243, adj_246);
                // adj: p0 = ray_origin[id0] + sol * ray_direction[id0]                       <L 277>
                wp::adj_extract(var_159, var_228, var_244, adj_159, adj_228, adj_244, adj_245);
                // adj: id1 = _IFACE[i][1]                                                    <L 276>
                wp::adj_extract(var_159, var_228, var_242, adj_159, adj_228, adj_242, adj_243);
                // adj: id0 = _IFACE[i][0]                                                    <L 275>
            }
            // adj: if sol >= 0.0:                                                            <L 274>
            wp::adj_div(var_237, var_238, var_239, adj_237, adj_238, adj_239);
            wp::adj_extract(var_ray_direction, var_228, adj_ray_direction, adj_228, adj_238);
            wp::adj_sub(var_235, var_236, adj_235, adj_236, adj_237);
            wp::adj_extract(var_ray_origin, var_228, adj_ray_origin, adj_228, adj_236);
            wp::adj_mul(var_233, var_234, adj_233, adj_234, adj_235);
            wp::adj_extract(var_size, var_228, adj_size, adj_228, adj_234);
            wp::adj_float(var_232, adj_232, adj_233);
            // adj: sol = (float(side) * size[i] - ray_origin[i]) / ray_direction[i]          <L 273>
            // adj: for side in range(-1, 2, 2):                                              <L 272>
        }
        wp::adj_abs(var_229, adj_229, adj_230);
        wp::adj_extract(var_ray_direction, var_228, adj_ray_direction, adj_228, adj_229);
        // adj: if wp.abs(ray_direction[i]) > EPSILON:                                        <L 271>
        if (var_148) {
            wp::adj_where(var_196, var_208, var_171, adj_196, adj_208, adj_171, adj_227);
            wp::adj_where(var_196, var_204, var_167, adj_196, adj_204, adj_167, adj_226);
            wp::adj_where(var_196, var_200, var_163, adj_196, adj_200, adj_163, adj_225);
            wp::adj_where(var_196, var_198, var_161, adj_196, adj_198, adj_161, adj_224);
            if (var_196) {
                if (var_209) {
                    if (var_218) {
                        wp::adj_assign_inplace(var_143, var_144, var_223, adj_143, adj_144, adj_223);
                        wp::adj_where(var_220, var_221, var_222, adj_220, adj_221, adj_222, adj_223);
                        if (!var_220) {
                        }
                        if (var_220) {
                        }
                        // adj: normal_local[i] = -1.0 if side < 0 else 1.0                   <L 281>
                    }
                    wp::adj_abs(var_216, adj_216, adj_217);
                    wp::adj_sub(var_194, var_139, adj_194, adj_139, adj_216);
                    // adj: if wp.abs(sol - t_hit) < EPSILON:                                 <L 280>
                }
                if (var_209) {
                    wp::adj_extract(var_size, var_200, adj_size, adj_200, adj_214);
                    wp::adj_abs(var_208, adj_208, adj_213);
                }
                wp::adj_extract(var_size, var_198, adj_size, adj_198, adj_211);
                wp::adj_abs(var_204, adj_204, adj_210);
                // adj: if wp.abs(p0) <= size[id0] and wp.abs(p1) <= size[id1]:               <L 279>
                wp::adj_add(var_205, var_207, adj_205, adj_207, adj_208);
                wp::adj_mul(var_194, var_206, adj_194, adj_206, adj_207);
                wp::adj_extract(var_ray_direction, var_200, adj_ray_direction, adj_200, adj_206);
                wp::adj_extract(var_ray_origin, var_200, adj_ray_origin, adj_200, adj_205);
                // adj: p1 = ray_origin[id1] + sol * ray_direction[id1]                       <L 278>
                wp::adj_add(var_201, var_203, adj_201, adj_203, adj_204);
                wp::adj_mul(var_194, var_202, adj_194, adj_202, adj_203);
                wp::adj_extract(var_ray_direction, var_198, adj_ray_direction, adj_198, adj_202);
                wp::adj_extract(var_ray_origin, var_198, adj_ray_origin, adj_198, adj_201);
                // adj: p0 = ray_origin[id0] + sol * ray_direction[id0]                       <L 277>
                wp::adj_extract(var_159, var_144, var_199, adj_159, adj_144, adj_199, adj_200);
                // adj: id1 = _IFACE[i][1]                                                    <L 276>
                wp::adj_extract(var_159, var_144, var_197, adj_159, adj_144, adj_197, adj_198);
                // adj: id0 = _IFACE[i][0]                                                    <L 275>
            }
            // adj: if sol >= 0.0:                                                            <L 274>
            wp::adj_div(var_192, var_193, var_194, adj_192, adj_193, adj_194);
            wp::adj_extract(var_ray_direction, var_144, adj_ray_direction, adj_144, adj_193);
            wp::adj_sub(var_190, var_191, adj_190, adj_191, adj_192);
            wp::adj_extract(var_ray_origin, var_144, adj_ray_origin, adj_144, adj_191);
            wp::adj_mul(var_188, var_189, adj_188, adj_189, adj_190);
            wp::adj_extract(var_size, var_144, adj_size, adj_144, adj_189);
            wp::adj_float(var_187, adj_187, adj_188);
            // adj: sol = (float(side) * size[i] - ray_origin[i]) / ray_direction[i]          <L 273>
            if (var_158) {
                if (var_172) {
                    if (var_181) {
                        wp::adj_assign_inplace(var_143, var_144, var_186, adj_143, adj_144, adj_186);
                        wp::adj_where(var_183, var_184, var_185, adj_183, adj_184, adj_185, adj_186);
                        if (!var_183) {
                        }
                        if (var_183) {
                        }
                        // adj: normal_local[i] = -1.0 if side < 0 else 1.0                   <L 281>
                    }
                    wp::adj_abs(var_179, adj_179, adj_180);
                    wp::adj_sub(var_156, var_139, adj_156, adj_139, adj_179);
                    // adj: if wp.abs(sol - t_hit) < EPSILON:                                 <L 280>
                }
                if (var_172) {
                    wp::adj_extract(var_size, var_163, adj_size, adj_163, adj_177);
                    wp::adj_abs(var_171, adj_171, adj_176);
                }
                wp::adj_extract(var_size, var_161, adj_size, adj_161, adj_174);
                wp::adj_abs(var_167, adj_167, adj_173);
                // adj: if wp.abs(p0) <= size[id0] and wp.abs(p1) <= size[id1]:               <L 279>
                wp::adj_add(var_168, var_170, adj_168, adj_170, adj_171);
                wp::adj_mul(var_156, var_169, adj_156, adj_169, adj_170);
                wp::adj_extract(var_ray_direction, var_163, adj_ray_direction, adj_163, adj_169);
                wp::adj_extract(var_ray_origin, var_163, adj_ray_origin, adj_163, adj_168);
                // adj: p1 = ray_origin[id1] + sol * ray_direction[id1]                       <L 278>
                wp::adj_add(var_164, var_166, adj_164, adj_166, adj_167);
                wp::adj_mul(var_156, var_165, adj_156, adj_165, adj_166);
                wp::adj_extract(var_ray_direction, var_161, adj_ray_direction, adj_161, adj_165);
                wp::adj_extract(var_ray_origin, var_161, adj_ray_origin, adj_161, adj_164);
                // adj: p0 = ray_origin[id0] + sol * ray_direction[id0]                       <L 277>
                wp::adj_extract(var_159, var_144, var_162, adj_159, adj_144, adj_162, adj_163);
                // adj: id1 = _IFACE[i][1]                                                    <L 276>
                wp::adj_extract(var_159, var_144, var_160, adj_159, adj_144, adj_160, adj_161);
                // adj: id0 = _IFACE[i][0]                                                    <L 275>
            }
            // adj: if sol >= 0.0:                                                            <L 274>
            wp::adj_div(var_154, var_155, var_156, adj_154, adj_155, adj_156);
            wp::adj_extract(var_ray_direction, var_144, adj_ray_direction, adj_144, adj_155);
            wp::adj_sub(var_152, var_153, adj_152, adj_153, adj_154);
            wp::adj_extract(var_ray_origin, var_144, adj_ray_origin, adj_144, adj_153);
            wp::adj_mul(var_150, var_151, adj_150, adj_151, adj_152);
            wp::adj_extract(var_size, var_144, adj_size, adj_144, adj_151);
            wp::adj_float(var_149, adj_149, adj_150);
            // adj: sol = (float(side) * size[i] - ray_origin[i]) / ray_direction[i]          <L 273>
            // adj: for side in range(-1, 2, 2):                                              <L 272>
        }
        wp::adj_abs(var_145, adj_145, adj_146);
        wp::adj_extract(var_ray_direction, var_144, adj_ray_direction, adj_144, adj_145);
        // adj: if wp.abs(ray_direction[i]) > EPSILON:                                        <L 271>
        // adj: for i in range(3):                                                            <L 270>
        wp::adj_vec_t(var_142, adj_142, adj_143);
        // adj: normal_local = wp.vec3(0.0)                                                   <L 269>
    }
    // adj: if t_hit >= 0.0:                                                                  <L 267>
    wp::adj_where(var_128, var_138, var_0, adj_128, adj_138, adj_0, adj_139);
    if (var_128) {
        wp::adj_where(var_135, var_136, var_137, adj_135, adj_136, adj_137, adj_138);
        if (!var_135) {
            wp::adj_copy(var_122, adj_122, adj_137);
            // adj: t_hit = t_far                                                             <L 265>
        }
        if (var_135) {
            wp::adj_copy(var_121, adj_121, adj_136);
            // adj: t_hit = t_near                                                            <L 263>
        }
        // adj: if t_near >= 0.0:                                                             <L 262>
    }
    if (var_128) {
    }
    if (var_128) {
    }
    // adj: if hit == 1 and t_near <= t_far and t_far >= 0.0:                                 <L 261>
    wp::adj_where(var_89, var_85, var_118, adj_89, adj_85, adj_118, adj_127);
    wp::adj_where(var_89, var_84, var_117, adj_89, adj_84, adj_117, adj_126);
    wp::adj_where(var_89, var_83, var_116, adj_89, adj_83, adj_116, adj_125);
    wp::adj_where(var_89, var_82, var_102, adj_89, adj_82, adj_102, adj_124);
    wp::adj_where(var_89, var_99, var_81, adj_89, adj_99, adj_81, adj_123);
    wp::adj_where(var_89, var_80, var_120, adj_89, adj_80, adj_120, adj_122);
    wp::adj_where(var_89, var_79, var_119, adj_89, adj_79, adj_119, adj_121);
    if (!var_89) {
        wp::adj_min(var_80, var_117, adj_80, adj_117, adj_120);
        // adj: t_far = wp.min(t_far, t2)                                                     <L 259>
        wp::adj_max(var_79, var_116, adj_79, adj_116, adj_119);
        // adj: t_near = wp.max(t_near, t1)                                                   <L 258>
        wp::adj_where(var_112, var_113, var_85, adj_112, adj_113, adj_85, adj_118);
        wp::adj_where(var_112, var_115, var_111, adj_112, adj_115, adj_111, adj_117);
        wp::adj_where(var_112, var_114, var_107, adj_112, adj_114, adj_107, adj_116);
        if (var_112) {
            wp::adj_copy(var_113, adj_113, adj_115);
            // adj: t2 = temp                                                                 <L 256>
            wp::adj_copy(var_111, adj_111, adj_114);
            // adj: t1 = t2                                                                   <L 255>
            wp::adj_copy(var_107, adj_107, adj_113);
            // adj: temp = t1                                                                 <L 254>
        }
        // adj: if t1 > t2:                                                                   <L 253>
        wp::adj_mul(var_110, var_102, adj_110, adj_102, adj_111);
        wp::adj_sub(var_108, var_109, adj_108, adj_109, adj_110);
        wp::adj_extract(var_ray_origin, var_86, adj_ray_origin, adj_86, adj_109);
        wp::adj_extract(var_size, var_86, adj_size, adj_86, adj_108);
        // adj: t2 = (size[i] - ray_origin[i]) * inv_d_i                                      <L 251>
        wp::adj_mul(var_106, var_102, adj_106, adj_102, adj_107);
        wp::adj_sub(var_104, var_105, adj_104, adj_105, adj_106);
        wp::adj_extract(var_ray_origin, var_86, adj_ray_origin, adj_86, adj_105);
        wp::adj_neg(var_103, adj_103, adj_104);
        wp::adj_extract(var_size, var_86, adj_size, adj_86, adj_103);
        // adj: t1 = (-size[i] - ray_origin[i]) * inv_d_i                                     <L 250>
        wp::adj_div(var_100, var_101, var_102, adj_100, adj_101, adj_102);
        wp::adj_extract(var_ray_direction, var_86, adj_ray_direction, adj_86, adj_101);
        // adj: inv_d_i = 1.0 / ray_direction[i]                                              <L 249>
    }
    if (var_89) {
        wp::adj_where(var_90, var_98, var_81, adj_90, adj_98, adj_81, adj_99);
        if (var_90) {
            // adj: hit = 0                                                                   <L 247>
        }
        if (!var_90) {
            wp::adj_extract(var_size, var_86, adj_size, adj_86, adj_96);
            wp::adj_extract(var_ray_origin, var_86, adj_ray_origin, adj_86, adj_95);
        }
        wp::adj_neg(var_92, adj_92, adj_93);
        wp::adj_extract(var_size, var_86, adj_size, adj_86, adj_92);
        wp::adj_extract(var_ray_origin, var_86, adj_ray_origin, adj_86, adj_91);
        // adj: if ray_origin[i] < -size[i] or ray_origin[i] > size[i]:                       <L 246>
    }
    wp::adj_abs(var_87, adj_87, adj_88);
    wp::adj_extract(var_ray_direction, var_86, adj_ray_direction, adj_86, adj_87);
    // adj: if wp.abs(ray_direction[i]) < MINVAL:                                             <L 245>
    wp::adj_where(var_47, var_34, var_76, adj_47, adj_34, adj_76, adj_85);
    wp::adj_where(var_47, var_38, var_75, adj_47, adj_38, adj_75, adj_84);
    wp::adj_where(var_47, var_37, var_74, adj_47, adj_37, adj_74, adj_83);
    wp::adj_where(var_47, var_23, var_60, adj_47, adj_23, adj_60, adj_82);
    wp::adj_where(var_47, var_57, var_43, adj_47, adj_57, adj_43, adj_81);
    wp::adj_where(var_47, var_42, var_78, adj_47, adj_42, adj_78, adj_80);
    wp::adj_where(var_47, var_41, var_77, adj_47, adj_41, adj_77, adj_79);
    if (!var_47) {
        wp::adj_min(var_42, var_75, adj_42, adj_75, adj_78);
        // adj: t_far = wp.min(t_far, t2)                                                     <L 259>
        wp::adj_max(var_41, var_74, adj_41, adj_74, adj_77);
        // adj: t_near = wp.max(t_near, t1)                                                   <L 258>
        wp::adj_where(var_70, var_71, var_34, adj_70, adj_71, adj_34, adj_76);
        wp::adj_where(var_70, var_73, var_69, adj_70, adj_73, adj_69, adj_75);
        wp::adj_where(var_70, var_72, var_65, adj_70, adj_72, adj_65, adj_74);
        if (var_70) {
            wp::adj_copy(var_71, adj_71, adj_73);
            // adj: t2 = temp                                                                 <L 256>
            wp::adj_copy(var_69, adj_69, adj_72);
            // adj: t1 = t2                                                                   <L 255>
            wp::adj_copy(var_65, adj_65, adj_71);
            // adj: temp = t1                                                                 <L 254>
        }
        // adj: if t1 > t2:                                                                   <L 253>
        wp::adj_mul(var_68, var_60, adj_68, adj_60, adj_69);
        wp::adj_sub(var_66, var_67, adj_66, adj_67, adj_68);
        wp::adj_extract(var_ray_origin, var_44, adj_ray_origin, adj_44, adj_67);
        wp::adj_extract(var_size, var_44, adj_size, adj_44, adj_66);
        // adj: t2 = (size[i] - ray_origin[i]) * inv_d_i                                      <L 251>
        wp::adj_mul(var_64, var_60, adj_64, adj_60, adj_65);
        wp::adj_sub(var_62, var_63, adj_62, adj_63, adj_64);
        wp::adj_extract(var_ray_origin, var_44, adj_ray_origin, adj_44, adj_63);
        wp::adj_neg(var_61, adj_61, adj_62);
        wp::adj_extract(var_size, var_44, adj_size, adj_44, adj_61);
        // adj: t1 = (-size[i] - ray_origin[i]) * inv_d_i                                     <L 250>
        wp::adj_div(var_58, var_59, var_60, adj_58, adj_59, adj_60);
        wp::adj_extract(var_ray_direction, var_44, adj_ray_direction, adj_44, adj_59);
        // adj: inv_d_i = 1.0 / ray_direction[i]                                              <L 249>
    }
    if (var_47) {
        wp::adj_where(var_48, var_56, var_43, adj_48, adj_56, adj_43, adj_57);
        if (var_48) {
            // adj: hit = 0                                                                   <L 247>
        }
        if (!var_48) {
            wp::adj_extract(var_size, var_44, adj_size, adj_44, adj_54);
            wp::adj_extract(var_ray_origin, var_44, adj_ray_origin, adj_44, adj_53);
        }
        wp::adj_neg(var_50, adj_50, adj_51);
        wp::adj_extract(var_size, var_44, adj_size, adj_44, adj_50);
        wp::adj_extract(var_ray_origin, var_44, adj_ray_origin, adj_44, adj_49);
        // adj: if ray_origin[i] < -size[i] or ray_origin[i] > size[i]:                       <L 246>
    }
    wp::adj_abs(var_45, adj_45, adj_46);
    wp::adj_extract(var_ray_direction, var_44, adj_ray_direction, adj_44, adj_45);
    // adj: if wp.abs(ray_direction[i]) < MINVAL:                                             <L 245>
    wp::adj_where(var_10, var_20, var_5, adj_10, adj_20, adj_5, adj_43);
    wp::adj_where(var_10, var_4, var_40, adj_10, adj_4, adj_40, adj_42);
    wp::adj_where(var_10, var_3, var_39, adj_10, adj_3, adj_39, adj_41);
    if (!var_10) {
        wp::adj_min(var_4, var_38, adj_4, adj_38, adj_40);
        // adj: t_far = wp.min(t_far, t2)                                                     <L 259>
        wp::adj_max(var_3, var_37, adj_3, adj_37, adj_39);
        // adj: t_near = wp.max(t_near, t1)                                                   <L 258>
        wp::adj_where(var_33, var_36, var_32, adj_33, adj_36, adj_32, adj_38);
        wp::adj_where(var_33, var_35, var_28, adj_33, adj_35, adj_28, adj_37);
        if (var_33) {
            wp::adj_copy(var_34, adj_34, adj_36);
            // adj: t2 = temp                                                                 <L 256>
            wp::adj_copy(var_32, adj_32, adj_35);
            // adj: t1 = t2                                                                   <L 255>
            wp::adj_copy(var_28, adj_28, adj_34);
            // adj: temp = t1                                                                 <L 254>
        }
        // adj: if t1 > t2:                                                                   <L 253>
        wp::adj_mul(var_31, var_23, adj_31, adj_23, adj_32);
        wp::adj_sub(var_29, var_30, adj_29, adj_30, adj_31);
        wp::adj_extract(var_ray_origin, var_6, adj_ray_origin, adj_6, adj_30);
        wp::adj_extract(var_size, var_6, adj_size, adj_6, adj_29);
        // adj: t2 = (size[i] - ray_origin[i]) * inv_d_i                                      <L 251>
        wp::adj_mul(var_27, var_23, adj_27, adj_23, adj_28);
        wp::adj_sub(var_25, var_26, adj_25, adj_26, adj_27);
        wp::adj_extract(var_ray_origin, var_6, adj_ray_origin, adj_6, adj_26);
        wp::adj_neg(var_24, adj_24, adj_25);
        wp::adj_extract(var_size, var_6, adj_size, adj_6, adj_24);
        // adj: t1 = (-size[i] - ray_origin[i]) * inv_d_i                                     <L 250>
        wp::adj_div(var_21, var_22, var_23, adj_21, adj_22, adj_23);
        wp::adj_extract(var_ray_direction, var_6, adj_ray_direction, adj_6, adj_22);
        // adj: inv_d_i = 1.0 / ray_direction[i]                                              <L 249>
    }
    if (var_10) {
        wp::adj_where(var_11, var_19, var_5, adj_11, adj_19, adj_5, adj_20);
        if (var_11) {
            // adj: hit = 0                                                                   <L 247>
        }
        if (!var_11) {
            wp::adj_extract(var_size, var_6, adj_size, adj_6, adj_17);
            wp::adj_extract(var_ray_origin, var_6, adj_ray_origin, adj_6, adj_16);
        }
        wp::adj_neg(var_13, adj_13, adj_14);
        wp::adj_extract(var_size, var_6, adj_size, adj_6, adj_13);
        wp::adj_extract(var_ray_origin, var_6, adj_ray_origin, adj_6, adj_12);
        // adj: if ray_origin[i] < -size[i] or ray_origin[i] > size[i]:                       <L 246>
    }
    wp::adj_abs(var_7, adj_7, adj_8);
    wp::adj_extract(var_ray_direction, var_6, adj_ray_direction, adj_6, adj_7);
    // adj: if wp.abs(ray_direction[i]) < MINVAL:                                             <L 245>
    // adj: for i in range(3):                                                                <L 244>
    // adj: hit = 1                                                                           <L 242>
    // adj: t_far = 1.0e10                                                                    <L 241>
    // adj: t_near = -1.0e10                                                                  <L 240>
    wp::adj_vec_t(var_1, adj_1, adj_2);
    // adj: normal = wp.vec3(0.0)                                                             <L 239>
    // adj: t_hit = -1.0                                                                      <L 238>
    // adj: def ray_intersect_box(ray_origin: wp.vec3, ray_direction: wp.vec3, size: wp.vec3) -> tuple[float, wp.vec3]:  <L 227>
    return;
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/geometry/raycast.py:287
static void adj_ray_intersect_capsule_0(
    wp::vec_t<3, wp::float32> var_ray_origin,
    wp::vec_t<3, wp::float32> var_ray_direction,
    wp::float32 var_r,
    wp::float32 var_h,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & adj_ray_origin,
    wp::vec_t<3, wp::float32> & adj_ray_direction,
    wp::float32 & adj_r,
    wp::float32 & adj_h,
    wp::float32 & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
    //---------
    // primal vars
    const wp::float32 var_0 = -1.0;
    const wp::float32 var_1 = 0.0;
    wp::vec_t<3, wp::float32> var_2;
    wp::float32 var_3;
    const wp::float32 var_4 = 1e-15;
    bool var_5;
    const wp::float32 var_6 = 1.0;
    wp::float32 var_7;
    wp::float32 var_8;
    wp::vec_t<3, wp::float32> var_9;
    const wp::float32 var_10 = 10000000000.0;
    const wp::int32 var_11 = 0;
    wp::float32 var_12;
    const wp::int32 var_13 = 0;
    wp::float32 var_14;
    wp::float32 var_15;
    const wp::int32 var_16 = 1;
    wp::float32 var_17;
    const wp::int32 var_18 = 1;
    wp::float32 var_19;
    wp::float32 var_20;
    wp::float32 var_21;
    bool var_22;
    const wp::float32 var_23 = 2.0;
    const wp::int32 var_24 = 0;
    wp::float32 var_25;
    const wp::int32 var_26 = 0;
    wp::float32 var_27;
    wp::float32 var_28;
    const wp::int32 var_29 = 1;
    wp::float32 var_30;
    const wp::int32 var_31 = 1;
    wp::float32 var_32;
    wp::float32 var_33;
    wp::float32 var_34;
    wp::float32 var_35;
    const wp::int32 var_36 = 0;
    wp::float32 var_37;
    const wp::int32 var_38 = 0;
    wp::float32 var_39;
    wp::float32 var_40;
    const wp::int32 var_41 = 1;
    wp::float32 var_42;
    const wp::int32 var_43 = 1;
    wp::float32 var_44;
    wp::float32 var_45;
    wp::float32 var_46;
    wp::float32 var_47;
    wp::float32 var_48;
    wp::float32 var_49;
    const wp::float32 var_50 = 4.0;
    wp::float32 var_51;
    wp::float32 var_52;
    wp::float32 var_53;
    const wp::float32 var_54 = 0.0;
    bool var_55;
    wp::float32 var_56;
    wp::float32 var_57;
    wp::float32 var_58;
    const wp::float32 var_59 = 2.0;
    wp::float32 var_60;
    wp::float32 var_61;
    const wp::float32 var_62 = 0.0;
    bool var_63;
    const wp::int32 var_64 = 2;
    wp::float32 var_65;
    const wp::int32 var_66 = 2;
    wp::float32 var_67;
    wp::float32 var_68;
    wp::float32 var_69;
    wp::float32 var_70;
    bool var_71;
    wp::float32 var_72;
    wp::float32 var_73;
    wp::float32 var_74;
    wp::float32 var_75;
    wp::float32 var_76;
    const wp::float32 var_77 = 2.0;
    wp::float32 var_78;
    wp::float32 var_79;
    const wp::float32 var_80 = 0.0;
    bool var_81;
    const wp::int32 var_82 = 2;
    wp::float32 var_83;
    const wp::int32 var_84 = 2;
    wp::float32 var_85;
    wp::float32 var_86;
    wp::float32 var_87;
    wp::float32 var_88;
    bool var_89;
    wp::float32 var_90;
    wp::float32 var_91;
    wp::float32 var_92;
    wp::float32 var_93;
    wp::float32 var_94;
    wp::float32 var_95;
    const wp::float32 var_96 = 0.0;
    const wp::float32 var_97 = 0.0;
    wp::vec_t<3, wp::float32> var_98;
    wp::vec_t<3, wp::float32> var_99;
    wp::float32 var_100;
    wp::float32 var_101;
    wp::float32 var_102;
    wp::float32 var_103;
    wp::float32 var_104;
    wp::float32 var_105;
    const wp::float32 var_106 = 0.0;
    bool var_107;
    wp::float32 var_108;
    wp::float32 var_109;
    wp::float32 var_110;
    const wp::float32 var_111 = 0.0;
    bool var_112;
    const wp::int32 var_113 = 2;
    wp::float32 var_114;
    const wp::int32 var_115 = 2;
    wp::float32 var_116;
    wp::float32 var_117;
    wp::float32 var_118;
    bool var_119;
    wp::float32 var_120;
    wp::float32 var_121;
    wp::float32 var_122;
    wp::float32 var_123;
    wp::float32 var_124;
    const wp::float32 var_125 = 0.0;
    bool var_126;
    const wp::int32 var_127 = 2;
    wp::float32 var_128;
    const wp::int32 var_129 = 2;
    wp::float32 var_130;
    wp::float32 var_131;
    wp::float32 var_132;
    bool var_133;
    wp::float32 var_134;
    wp::float32 var_135;
    wp::float32 var_136;
    wp::float32 var_137;
    const wp::float32 var_138 = 0.0;
    const wp::float32 var_139 = 0.0;
    wp::float32 var_140;
    wp::vec_t<3, wp::float32> var_141;
    wp::vec_t<3, wp::float32> var_142;
    wp::float32 var_143;
    wp::float32 var_144;
    wp::float32 var_145;
    wp::float32 var_146;
    wp::float32 var_147;
    wp::float32 var_148;
    const wp::float32 var_149 = 0.0;
    bool var_150;
    wp::float32 var_151;
    wp::float32 var_152;
    wp::float32 var_153;
    const wp::float32 var_154 = 0.0;
    bool var_155;
    const wp::int32 var_156 = 2;
    wp::float32 var_157;
    const wp::int32 var_158 = 2;
    wp::float32 var_159;
    wp::float32 var_160;
    wp::float32 var_161;
    wp::float32 var_162;
    bool var_163;
    wp::float32 var_164;
    wp::float32 var_165;
    wp::float32 var_166;
    wp::float32 var_167;
    wp::float32 var_168;
    const wp::float32 var_169 = 0.0;
    bool var_170;
    const wp::int32 var_171 = 2;
    wp::float32 var_172;
    const wp::int32 var_173 = 2;
    wp::float32 var_174;
    wp::float32 var_175;
    wp::float32 var_176;
    wp::float32 var_177;
    bool var_178;
    wp::float32 var_179;
    wp::float32 var_180;
    wp::float32 var_181;
    wp::float32 var_182;
    const wp::float32 var_183 = 1000000000.0;
    bool var_184;
    wp::float32 var_185;
    wp::float32 var_186;
    const wp::float32 var_187 = 0.0;
    bool var_188;
    wp::vec_t<3, wp::float32> var_189;
    wp::vec_t<3, wp::float32> var_190;
    wp::float32 var_191;
    const wp::int32 var_192 = 2;
    wp::float32 var_193;
    wp::float32 var_194;
    wp::float32 var_195;
    const wp::float32 var_196 = 0.0;
    const wp::float32 var_197 = 0.0;
    wp::vec_t<3, wp::float32> var_198;
    wp::vec_t<3, wp::float32> var_199;
    wp::vec_t<3, wp::float32> var_200;
    wp::vec_t<3, wp::float32> var_201;
    //---------
    // dual vars
    wp::float32 adj_0 = {};
    wp::float32 adj_1 = {};
    wp::vec_t<3, wp::float32> adj_2 = {};
    wp::float32 adj_3 = {};
    wp::float32 adj_4 = {};
    bool adj_5 = {};
    wp::float32 adj_6 = {};
    wp::float32 adj_7 = {};
    wp::float32 adj_8 = {};
    wp::vec_t<3, wp::float32> adj_9 = {};
    wp::float32 adj_10 = {};
    wp::int32 adj_11 = {};
    wp::float32 adj_12 = {};
    wp::int32 adj_13 = {};
    wp::float32 adj_14 = {};
    wp::float32 adj_15 = {};
    wp::int32 adj_16 = {};
    wp::float32 adj_17 = {};
    wp::int32 adj_18 = {};
    wp::float32 adj_19 = {};
    wp::float32 adj_20 = {};
    wp::float32 adj_21 = {};
    bool adj_22 = {};
    wp::float32 adj_23 = {};
    wp::int32 adj_24 = {};
    wp::float32 adj_25 = {};
    wp::int32 adj_26 = {};
    wp::float32 adj_27 = {};
    wp::float32 adj_28 = {};
    wp::int32 adj_29 = {};
    wp::float32 adj_30 = {};
    wp::int32 adj_31 = {};
    wp::float32 adj_32 = {};
    wp::float32 adj_33 = {};
    wp::float32 adj_34 = {};
    wp::float32 adj_35 = {};
    wp::int32 adj_36 = {};
    wp::float32 adj_37 = {};
    wp::int32 adj_38 = {};
    wp::float32 adj_39 = {};
    wp::float32 adj_40 = {};
    wp::int32 adj_41 = {};
    wp::float32 adj_42 = {};
    wp::int32 adj_43 = {};
    wp::float32 adj_44 = {};
    wp::float32 adj_45 = {};
    wp::float32 adj_46 = {};
    wp::float32 adj_47 = {};
    wp::float32 adj_48 = {};
    wp::float32 adj_49 = {};
    wp::float32 adj_50 = {};
    wp::float32 adj_51 = {};
    wp::float32 adj_52 = {};
    wp::float32 adj_53 = {};
    wp::float32 adj_54 = {};
    bool adj_55 = {};
    wp::float32 adj_56 = {};
    wp::float32 adj_57 = {};
    wp::float32 adj_58 = {};
    wp::float32 adj_59 = {};
    wp::float32 adj_60 = {};
    wp::float32 adj_61 = {};
    wp::float32 adj_62 = {};
    bool adj_63 = {};
    wp::int32 adj_64 = {};
    wp::float32 adj_65 = {};
    wp::int32 adj_66 = {};
    wp::float32 adj_67 = {};
    wp::float32 adj_68 = {};
    wp::float32 adj_69 = {};
    wp::float32 adj_70 = {};
    bool adj_71 = {};
    wp::float32 adj_72 = {};
    wp::float32 adj_73 = {};
    wp::float32 adj_74 = {};
    wp::float32 adj_75 = {};
    wp::float32 adj_76 = {};
    wp::float32 adj_77 = {};
    wp::float32 adj_78 = {};
    wp::float32 adj_79 = {};
    wp::float32 adj_80 = {};
    bool adj_81 = {};
    wp::int32 adj_82 = {};
    wp::float32 adj_83 = {};
    wp::int32 adj_84 = {};
    wp::float32 adj_85 = {};
    wp::float32 adj_86 = {};
    wp::float32 adj_87 = {};
    wp::float32 adj_88 = {};
    bool adj_89 = {};
    wp::float32 adj_90 = {};
    wp::float32 adj_91 = {};
    wp::float32 adj_92 = {};
    wp::float32 adj_93 = {};
    wp::float32 adj_94 = {};
    wp::float32 adj_95 = {};
    wp::float32 adj_96 = {};
    wp::float32 adj_97 = {};
    wp::vec_t<3, wp::float32> adj_98 = {};
    wp::vec_t<3, wp::float32> adj_99 = {};
    wp::float32 adj_100 = {};
    wp::float32 adj_101 = {};
    wp::float32 adj_102 = {};
    wp::float32 adj_103 = {};
    wp::float32 adj_104 = {};
    wp::float32 adj_105 = {};
    wp::float32 adj_106 = {};
    bool adj_107 = {};
    wp::float32 adj_108 = {};
    wp::float32 adj_109 = {};
    wp::float32 adj_110 = {};
    wp::float32 adj_111 = {};
    bool adj_112 = {};
    wp::int32 adj_113 = {};
    wp::float32 adj_114 = {};
    wp::int32 adj_115 = {};
    wp::float32 adj_116 = {};
    wp::float32 adj_117 = {};
    wp::float32 adj_118 = {};
    bool adj_119 = {};
    wp::float32 adj_120 = {};
    wp::float32 adj_121 = {};
    wp::float32 adj_122 = {};
    wp::float32 adj_123 = {};
    wp::float32 adj_124 = {};
    wp::float32 adj_125 = {};
    bool adj_126 = {};
    wp::int32 adj_127 = {};
    wp::float32 adj_128 = {};
    wp::int32 adj_129 = {};
    wp::float32 adj_130 = {};
    wp::float32 adj_131 = {};
    wp::float32 adj_132 = {};
    bool adj_133 = {};
    wp::float32 adj_134 = {};
    wp::float32 adj_135 = {};
    wp::float32 adj_136 = {};
    wp::float32 adj_137 = {};
    wp::float32 adj_138 = {};
    wp::float32 adj_139 = {};
    wp::float32 adj_140 = {};
    wp::vec_t<3, wp::float32> adj_141 = {};
    wp::vec_t<3, wp::float32> adj_142 = {};
    wp::float32 adj_143 = {};
    wp::float32 adj_144 = {};
    wp::float32 adj_145 = {};
    wp::float32 adj_146 = {};
    wp::float32 adj_147 = {};
    wp::float32 adj_148 = {};
    wp::float32 adj_149 = {};
    bool adj_150 = {};
    wp::float32 adj_151 = {};
    wp::float32 adj_152 = {};
    wp::float32 adj_153 = {};
    wp::float32 adj_154 = {};
    bool adj_155 = {};
    wp::int32 adj_156 = {};
    wp::float32 adj_157 = {};
    wp::int32 adj_158 = {};
    wp::float32 adj_159 = {};
    wp::float32 adj_160 = {};
    wp::float32 adj_161 = {};
    wp::float32 adj_162 = {};
    bool adj_163 = {};
    wp::float32 adj_164 = {};
    wp::float32 adj_165 = {};
    wp::float32 adj_166 = {};
    wp::float32 adj_167 = {};
    wp::float32 adj_168 = {};
    wp::float32 adj_169 = {};
    bool adj_170 = {};
    wp::int32 adj_171 = {};
    wp::float32 adj_172 = {};
    wp::int32 adj_173 = {};
    wp::float32 adj_174 = {};
    wp::float32 adj_175 = {};
    wp::float32 adj_176 = {};
    wp::float32 adj_177 = {};
    bool adj_178 = {};
    wp::float32 adj_179 = {};
    wp::float32 adj_180 = {};
    wp::float32 adj_181 = {};
    wp::float32 adj_182 = {};
    wp::float32 adj_183 = {};
    bool adj_184 = {};
    wp::float32 adj_185 = {};
    wp::float32 adj_186 = {};
    wp::float32 adj_187 = {};
    bool adj_188 = {};
    wp::vec_t<3, wp::float32> adj_189 = {};
    wp::vec_t<3, wp::float32> adj_190 = {};
    wp::float32 adj_191 = {};
    wp::int32 adj_192 = {};
    wp::float32 adj_193 = {};
    wp::float32 adj_194 = {};
    wp::float32 adj_195 = {};
    wp::float32 adj_196 = {};
    wp::float32 adj_197 = {};
    wp::vec_t<3, wp::float32> adj_198 = {};
    wp::vec_t<3, wp::float32> adj_199 = {};
    wp::vec_t<3, wp::float32> adj_200 = {};
    wp::vec_t<3, wp::float32> adj_201 = {};
    //---------
    // forward
    // def ray_intersect_capsule(ray_origin: wp.vec3, ray_direction: wp.vec3, r: float, h: float) -> tuple[float, wp.vec3]:       <L 288>
    // t_hit = -1.0                                                                           <L 302>
    // normal = wp.vec3(0.0)                                                                  <L 303>
    var_2 = wp::vec_t<3, wp::float32>(var_1);
    // d_len_sq = wp.dot(ray_direction, ray_direction)                                        <L 305>
    var_3 = wp::dot(var_ray_direction, var_ray_direction);
    // if d_len_sq < MINVAL:                                                                  <L 306>
    var_5 = (var_3 < var_4);
    if (var_5) {
        // return t_hit, normal                                                               <L 307>
        ret_0 = var_0;
        ret_1 = var_2;
        goto label0;
    }
    // inv_d_len = 1.0 / wp.sqrt(d_len_sq)                                                    <L 309>
    var_7 = wp::sqrt(var_3);
    var_8 = wp::div(var_6, var_7);
    // d_local_norm = ray_direction * inv_d_len                                               <L 310>
    var_9 = wp::mul(var_ray_direction, var_8);
    // min_t = 1.0e10                                                                         <L 312>
    // a_cyl = d_local_norm[0] * d_local_norm[0] + d_local_norm[1] * d_local_norm[1]          <L 315>
    var_12 = wp::extract(var_9, var_11);
    var_14 = wp::extract(var_9, var_13);
    var_15 = wp::mul(var_12, var_14);
    var_17 = wp::extract(var_9, var_16);
    var_19 = wp::extract(var_9, var_18);
    var_20 = wp::mul(var_17, var_19);
    var_21 = wp::add(var_15, var_20);
    // if a_cyl > MINVAL:                                                                     <L 316>
    var_22 = (var_21 > var_4);
    if (var_22) {
        // b_cyl = 2.0 * (ray_origin[0] * d_local_norm[0] + ray_origin[1] * d_local_norm[1])       <L 317>
        var_25 = wp::extract(var_ray_origin, var_24);
        var_27 = wp::extract(var_9, var_26);
        var_28 = wp::mul(var_25, var_27);
        var_30 = wp::extract(var_ray_origin, var_29);
        var_32 = wp::extract(var_9, var_31);
        var_33 = wp::mul(var_30, var_32);
        var_34 = wp::add(var_28, var_33);
        var_35 = wp::mul(var_23, var_34);
        // c_cyl = ray_origin[0] * ray_origin[0] + ray_origin[1] * ray_origin[1] - r * r       <L 318>
        var_37 = wp::extract(var_ray_origin, var_36);
        var_39 = wp::extract(var_ray_origin, var_38);
        var_40 = wp::mul(var_37, var_39);
        var_42 = wp::extract(var_ray_origin, var_41);
        var_44 = wp::extract(var_ray_origin, var_43);
        var_45 = wp::mul(var_42, var_44);
        var_46 = wp::add(var_40, var_45);
        var_47 = wp::mul(var_r, var_r);
        var_48 = wp::sub(var_46, var_47);
        // delta_cyl = b_cyl * b_cyl - 4.0 * a_cyl * c_cyl                                    <L 319>
        var_49 = wp::mul(var_35, var_35);
        var_51 = wp::mul(var_50, var_21);
        var_52 = wp::mul(var_51, var_48);
        var_53 = wp::sub(var_49, var_52);
        // if delta_cyl >= 0.0:                                                               <L 320>
        var_55 = (var_53 >= var_54);
        if (var_55) {
            // sqrt_delta_cyl = wp.sqrt(delta_cyl)                                            <L 321>
            var_56 = wp::sqrt(var_53);
            // t1 = (-b_cyl - sqrt_delta_cyl) / (2.0 * a_cyl)                                 <L 322>
            var_57 = wp::neg(var_35);
            var_58 = wp::sub(var_57, var_56);
            var_60 = wp::mul(var_59, var_21);
            var_61 = wp::div(var_58, var_60);
            // if t1 >= 0.0:                                                                  <L 323>
            var_63 = (var_61 >= var_62);
            if (var_63) {
                // z = ray_origin[2] + t1 * d_local_norm[2]                                   <L 324>
                var_65 = wp::extract(var_ray_origin, var_64);
                var_67 = wp::extract(var_9, var_66);
                var_68 = wp::mul(var_61, var_67);
                var_69 = wp::add(var_65, var_68);
                // if wp.abs(z) <= h:                                                         <L 325>
                var_70 = wp::abs(var_69);
                var_71 = (var_70 <= var_h);
                if (var_71) {
                    // min_t = wp.min(min_t, t1)                                              <L 326>
                    var_72 = wp::min(var_10, var_61);
                }
                var_73 = wp::where(var_71, var_72, var_10);
            }
            var_74 = wp::where(var_63, var_73, var_10);
            // t2 = (-b_cyl + sqrt_delta_cyl) / (2.0 * a_cyl)                                 <L 328>
            var_75 = wp::neg(var_35);
            var_76 = wp::add(var_75, var_56);
            var_78 = wp::mul(var_77, var_21);
            var_79 = wp::div(var_76, var_78);
            // if t2 >= 0.0:                                                                  <L 329>
            var_81 = (var_79 >= var_80);
            if (var_81) {
                // z = ray_origin[2] + t2 * d_local_norm[2]                                   <L 330>
                var_83 = wp::extract(var_ray_origin, var_82);
                var_85 = wp::extract(var_9, var_84);
                var_86 = wp::mul(var_79, var_85);
                var_87 = wp::add(var_83, var_86);
                // if wp.abs(z) <= h:                                                         <L 331>
                var_88 = wp::abs(var_87);
                var_89 = (var_88 <= var_h);
                if (var_89) {
                    // min_t = wp.min(min_t, t2)                                              <L 332>
                    var_90 = wp::min(var_74, var_79);
                }
                var_91 = wp::where(var_89, var_90, var_74);
            }
            var_92 = wp::where(var_81, var_91, var_74);
            var_93 = wp::where(var_81, var_87, var_69);
        }
        var_94 = wp::where(var_55, var_92, var_10);
    }
    var_95 = wp::where(var_22, var_94, var_10);
    // oc_top = ray_origin - wp.vec3(0.0, 0.0, h)                                             <L 336>
    var_98 = wp::vec_t<3, wp::float32>(var_96, var_97, var_h);
    var_99 = wp::sub(var_ray_origin, var_98);
    // b_top = wp.dot(oc_top, d_local_norm)                                                   <L 337>
    var_100 = wp::dot(var_99, var_9);
    // c_top = wp.dot(oc_top, oc_top) - r * r                                                 <L 338>
    var_101 = wp::dot(var_99, var_99);
    var_102 = wp::mul(var_r, var_r);
    var_103 = wp::sub(var_101, var_102);
    // delta_top = b_top * b_top - c_top                                                      <L 339>
    var_104 = wp::mul(var_100, var_100);
    var_105 = wp::sub(var_104, var_103);
    // if delta_top >= 0.0:                                                                   <L 340>
    var_107 = (var_105 >= var_106);
    if (var_107) {
        // sqrt_delta_top = wp.sqrt(delta_top)                                                <L 341>
        var_108 = wp::sqrt(var_105);
        // t1_top = -b_top - sqrt_delta_top                                                   <L 342>
        var_109 = wp::neg(var_100);
        var_110 = wp::sub(var_109, var_108);
        // if t1_top >= 0.0:                                                                  <L 343>
        var_112 = (var_110 >= var_111);
        if (var_112) {
            // if (ray_origin[2] + t1_top * d_local_norm[2]) >= h:                            <L 344>
            var_114 = wp::extract(var_ray_origin, var_113);
            var_116 = wp::extract(var_9, var_115);
            var_117 = wp::mul(var_110, var_116);
            var_118 = wp::add(var_114, var_117);
            var_119 = (var_118 >= var_h);
            if (var_119) {
                // min_t = wp.min(min_t, t1_top)                                              <L 345>
                var_120 = wp::min(var_95, var_110);
            }
            var_121 = wp::where(var_119, var_120, var_95);
        }
        var_122 = wp::where(var_112, var_121, var_95);
        // t2_top = -b_top + sqrt_delta_top                                                   <L 347>
        var_123 = wp::neg(var_100);
        var_124 = wp::add(var_123, var_108);
        // if t2_top >= 0.0:                                                                  <L 348>
        var_126 = (var_124 >= var_125);
        if (var_126) {
            // if (ray_origin[2] + t2_top * d_local_norm[2]) >= h:                            <L 349>
            var_128 = wp::extract(var_ray_origin, var_127);
            var_130 = wp::extract(var_9, var_129);
            var_131 = wp::mul(var_124, var_130);
            var_132 = wp::add(var_128, var_131);
            var_133 = (var_132 >= var_h);
            if (var_133) {
                // min_t = wp.min(min_t, t2_top)                                              <L 350>
                var_134 = wp::min(var_122, var_124);
            }
            var_135 = wp::where(var_133, var_134, var_122);
        }
        var_136 = wp::where(var_126, var_135, var_122);
    }
    var_137 = wp::where(var_107, var_136, var_95);
    // oc_bot = ray_origin - wp.vec3(0.0, 0.0, -h)                                            <L 353>
    var_140 = wp::neg(var_h);
    var_141 = wp::vec_t<3, wp::float32>(var_138, var_139, var_140);
    var_142 = wp::sub(var_ray_origin, var_141);
    // b_bot = wp.dot(oc_bot, d_local_norm)                                                   <L 354>
    var_143 = wp::dot(var_142, var_9);
    // c_bot = wp.dot(oc_bot, oc_bot) - r * r                                                 <L 355>
    var_144 = wp::dot(var_142, var_142);
    var_145 = wp::mul(var_r, var_r);
    var_146 = wp::sub(var_144, var_145);
    // delta_bot = b_bot * b_bot - c_bot                                                      <L 356>
    var_147 = wp::mul(var_143, var_143);
    var_148 = wp::sub(var_147, var_146);
    // if delta_bot >= 0.0:                                                                   <L 357>
    var_150 = (var_148 >= var_149);
    if (var_150) {
        // sqrt_delta_bot = wp.sqrt(delta_bot)                                                <L 358>
        var_151 = wp::sqrt(var_148);
        // t1_bot = -b_bot - sqrt_delta_bot                                                   <L 359>
        var_152 = wp::neg(var_143);
        var_153 = wp::sub(var_152, var_151);
        // if t1_bot >= 0.0:                                                                  <L 360>
        var_155 = (var_153 >= var_154);
        if (var_155) {
            // if (ray_origin[2] + t1_bot * d_local_norm[2]) <= -h:                           <L 361>
            var_157 = wp::extract(var_ray_origin, var_156);
            var_159 = wp::extract(var_9, var_158);
            var_160 = wp::mul(var_153, var_159);
            var_161 = wp::add(var_157, var_160);
            var_162 = wp::neg(var_h);
            var_163 = (var_161 <= var_162);
            if (var_163) {
                // min_t = wp.min(min_t, t1_bot)                                              <L 362>
                var_164 = wp::min(var_137, var_153);
            }
            var_165 = wp::where(var_163, var_164, var_137);
        }
        var_166 = wp::where(var_155, var_165, var_137);
        // t2_bot = -b_bot + sqrt_delta_bot                                                   <L 364>
        var_167 = wp::neg(var_143);
        var_168 = wp::add(var_167, var_151);
        // if t2_bot >= 0.0:                                                                  <L 365>
        var_170 = (var_168 >= var_169);
        if (var_170) {
            // if (ray_origin[2] + t2_bot * d_local_norm[2]) <= -h:                           <L 366>
            var_172 = wp::extract(var_ray_origin, var_171);
            var_174 = wp::extract(var_9, var_173);
            var_175 = wp::mul(var_168, var_174);
            var_176 = wp::add(var_172, var_175);
            var_177 = wp::neg(var_h);
            var_178 = (var_176 <= var_177);
            if (var_178) {
                // min_t = wp.min(min_t, t2_bot)                                              <L 367>
                var_179 = wp::min(var_166, var_168);
            }
            var_180 = wp::where(var_178, var_179, var_166);
        }
        var_181 = wp::where(var_170, var_180, var_166);
    }
    var_182 = wp::where(var_150, var_181, var_137);
    // if min_t < 1.0e9:                                                                      <L 369>
    var_184 = (var_182 < var_183);
    if (var_184) {
        // t_hit = min_t * inv_d_len                                                          <L 370>
        var_185 = wp::mul(var_182, var_8);
    }
    var_186 = wp::where(var_184, var_185, var_0);
    // if t_hit >= 0.0:                                                                       <L 372>
    var_188 = (var_186 >= var_187);
    if (var_188) {
        // hit_local = ray_origin + t_hit * ray_direction                                     <L 373>
        var_189 = wp::mul(var_186, var_ray_direction);
        var_190 = wp::add(var_ray_origin, var_189);
        // z_clamped = wp.min(h, wp.max(-h, hit_local[2]))                                    <L 374>
        var_191 = wp::neg(var_h);
        var_193 = wp::extract(var_190, var_192);
        var_194 = wp::max(var_191, var_193);
        var_195 = wp::min(var_h, var_194);
        // axis_point = wp.vec3(0.0, 0.0, z_clamped)                                          <L 375>
        var_198 = wp::vec_t<3, wp::float32>(var_196, var_197, var_195);
        // normal = wp.normalize(hit_local - axis_point)                                      <L 376>
        var_199 = wp::sub(var_190, var_198);
        var_200 = wp::normalize(var_199);
    }
    var_201 = wp::where(var_188, var_200, var_2);
    // return t_hit, normal                                                                   <L 378>
    ret_0 = var_186;
    ret_1 = var_201;
    goto label1;
    //---------
    // reverse
    label1:;
    adj_201 += adj_ret_1;
    adj_186 += adj_ret_0;
    // adj: return t_hit, normal                                                              <L 378>
    wp::adj_where(var_188, var_200, var_2, adj_188, adj_200, adj_2, adj_201);
    if (var_188) {
        wp::adj_normalize(var_199, var_200, adj_199, adj_200);
        wp::adj_sub(var_190, var_198, adj_190, adj_198, adj_199);
        // adj: normal = wp.normalize(hit_local - axis_point)                                 <L 376>
        wp::adj_vec_t(var_196, var_197, var_195, adj_196, adj_197, adj_195, adj_198);
        // adj: axis_point = wp.vec3(0.0, 0.0, z_clamped)                                     <L 375>
        wp::adj_min(var_h, var_194, adj_h, adj_194, adj_195);
        wp::adj_max(var_191, var_193, adj_191, adj_193, adj_194);
        wp::adj_extract(var_190, var_192, adj_190, adj_192, adj_193);
        wp::adj_neg(var_h, adj_h, adj_191);
        // adj: z_clamped = wp.min(h, wp.max(-h, hit_local[2]))                               <L 374>
        wp::adj_add(var_ray_origin, var_189, adj_ray_origin, adj_189, adj_190);
        wp::adj_mul(var_186, var_ray_direction, adj_186, adj_ray_direction, adj_189);
        // adj: hit_local = ray_origin + t_hit * ray_direction                                <L 373>
    }
    // adj: if t_hit >= 0.0:                                                                  <L 372>
    wp::adj_where(var_184, var_185, var_0, adj_184, adj_185, adj_0, adj_186);
    if (var_184) {
        wp::adj_mul(var_182, var_8, adj_182, adj_8, adj_185);
        // adj: t_hit = min_t * inv_d_len                                                     <L 370>
    }
    // adj: if min_t < 1.0e9:                                                                 <L 369>
    wp::adj_where(var_150, var_181, var_137, adj_150, adj_181, adj_137, adj_182);
    if (var_150) {
        wp::adj_where(var_170, var_180, var_166, adj_170, adj_180, adj_166, adj_181);
        if (var_170) {
            wp::adj_where(var_178, var_179, var_166, adj_178, adj_179, adj_166, adj_180);
            if (var_178) {
                wp::adj_min(var_166, var_168, adj_166, adj_168, adj_179);
                // adj: min_t = wp.min(min_t, t2_bot)                                         <L 367>
            }
            wp::adj_neg(var_h, adj_h, adj_177);
            wp::adj_add(var_172, var_175, adj_172, adj_175, adj_176);
            wp::adj_mul(var_168, var_174, adj_168, adj_174, adj_175);
            wp::adj_extract(var_9, var_173, adj_9, adj_173, adj_174);
            wp::adj_extract(var_ray_origin, var_171, adj_ray_origin, adj_171, adj_172);
            // adj: if (ray_origin[2] + t2_bot * d_local_norm[2]) <= -h:                      <L 366>
        }
        // adj: if t2_bot >= 0.0:                                                             <L 365>
        wp::adj_add(var_167, var_151, adj_167, adj_151, adj_168);
        wp::adj_neg(var_143, adj_143, adj_167);
        // adj: t2_bot = -b_bot + sqrt_delta_bot                                              <L 364>
        wp::adj_where(var_155, var_165, var_137, adj_155, adj_165, adj_137, adj_166);
        if (var_155) {
            wp::adj_where(var_163, var_164, var_137, adj_163, adj_164, adj_137, adj_165);
            if (var_163) {
                wp::adj_min(var_137, var_153, adj_137, adj_153, adj_164);
                // adj: min_t = wp.min(min_t, t1_bot)                                         <L 362>
            }
            wp::adj_neg(var_h, adj_h, adj_162);
            wp::adj_add(var_157, var_160, adj_157, adj_160, adj_161);
            wp::adj_mul(var_153, var_159, adj_153, adj_159, adj_160);
            wp::adj_extract(var_9, var_158, adj_9, adj_158, adj_159);
            wp::adj_extract(var_ray_origin, var_156, adj_ray_origin, adj_156, adj_157);
            // adj: if (ray_origin[2] + t1_bot * d_local_norm[2]) <= -h:                      <L 361>
        }
        // adj: if t1_bot >= 0.0:                                                             <L 360>
        wp::adj_sub(var_152, var_151, adj_152, adj_151, adj_153);
        wp::adj_neg(var_143, adj_143, adj_152);
        // adj: t1_bot = -b_bot - sqrt_delta_bot                                              <L 359>
        wp::adj_sqrt(var_148, var_151, adj_148, adj_151);
        // adj: sqrt_delta_bot = wp.sqrt(delta_bot)                                           <L 358>
    }
    // adj: if delta_bot >= 0.0:                                                              <L 357>
    wp::adj_sub(var_147, var_146, adj_147, adj_146, adj_148);
    wp::adj_mul(var_143, var_143, adj_143, adj_143, adj_147);
    // adj: delta_bot = b_bot * b_bot - c_bot                                                 <L 356>
    wp::adj_sub(var_144, var_145, adj_144, adj_145, adj_146);
    wp::adj_mul(var_r, var_r, adj_r, adj_r, adj_145);
    wp::adj_dot(var_142, var_142, adj_142, adj_142, adj_144);
    // adj: c_bot = wp.dot(oc_bot, oc_bot) - r * r                                            <L 355>
    wp::adj_dot(var_142, var_9, adj_142, adj_9, adj_143);
    // adj: b_bot = wp.dot(oc_bot, d_local_norm)                                              <L 354>
    wp::adj_sub(var_ray_origin, var_141, adj_ray_origin, adj_141, adj_142);
    wp::adj_vec_t(var_138, var_139, var_140, adj_138, adj_139, adj_140, adj_141);
    wp::adj_neg(var_h, adj_h, adj_140);
    // adj: oc_bot = ray_origin - wp.vec3(0.0, 0.0, -h)                                       <L 353>
    wp::adj_where(var_107, var_136, var_95, adj_107, adj_136, adj_95, adj_137);
    if (var_107) {
        wp::adj_where(var_126, var_135, var_122, adj_126, adj_135, adj_122, adj_136);
        if (var_126) {
            wp::adj_where(var_133, var_134, var_122, adj_133, adj_134, adj_122, adj_135);
            if (var_133) {
                wp::adj_min(var_122, var_124, adj_122, adj_124, adj_134);
                // adj: min_t = wp.min(min_t, t2_top)                                         <L 350>
            }
            wp::adj_add(var_128, var_131, adj_128, adj_131, adj_132);
            wp::adj_mul(var_124, var_130, adj_124, adj_130, adj_131);
            wp::adj_extract(var_9, var_129, adj_9, adj_129, adj_130);
            wp::adj_extract(var_ray_origin, var_127, adj_ray_origin, adj_127, adj_128);
            // adj: if (ray_origin[2] + t2_top * d_local_norm[2]) >= h:                       <L 349>
        }
        // adj: if t2_top >= 0.0:                                                             <L 348>
        wp::adj_add(var_123, var_108, adj_123, adj_108, adj_124);
        wp::adj_neg(var_100, adj_100, adj_123);
        // adj: t2_top = -b_top + sqrt_delta_top                                              <L 347>
        wp::adj_where(var_112, var_121, var_95, adj_112, adj_121, adj_95, adj_122);
        if (var_112) {
            wp::adj_where(var_119, var_120, var_95, adj_119, adj_120, adj_95, adj_121);
            if (var_119) {
                wp::adj_min(var_95, var_110, adj_95, adj_110, adj_120);
                // adj: min_t = wp.min(min_t, t1_top)                                         <L 345>
            }
            wp::adj_add(var_114, var_117, adj_114, adj_117, adj_118);
            wp::adj_mul(var_110, var_116, adj_110, adj_116, adj_117);
            wp::adj_extract(var_9, var_115, adj_9, adj_115, adj_116);
            wp::adj_extract(var_ray_origin, var_113, adj_ray_origin, adj_113, adj_114);
            // adj: if (ray_origin[2] + t1_top * d_local_norm[2]) >= h:                       <L 344>
        }
        // adj: if t1_top >= 0.0:                                                             <L 343>
        wp::adj_sub(var_109, var_108, adj_109, adj_108, adj_110);
        wp::adj_neg(var_100, adj_100, adj_109);
        // adj: t1_top = -b_top - sqrt_delta_top                                              <L 342>
        wp::adj_sqrt(var_105, var_108, adj_105, adj_108);
        // adj: sqrt_delta_top = wp.sqrt(delta_top)                                           <L 341>
    }
    // adj: if delta_top >= 0.0:                                                              <L 340>
    wp::adj_sub(var_104, var_103, adj_104, adj_103, adj_105);
    wp::adj_mul(var_100, var_100, adj_100, adj_100, adj_104);
    // adj: delta_top = b_top * b_top - c_top                                                 <L 339>
    wp::adj_sub(var_101, var_102, adj_101, adj_102, adj_103);
    wp::adj_mul(var_r, var_r, adj_r, adj_r, adj_102);
    wp::adj_dot(var_99, var_99, adj_99, adj_99, adj_101);
    // adj: c_top = wp.dot(oc_top, oc_top) - r * r                                            <L 338>
    wp::adj_dot(var_99, var_9, adj_99, adj_9, adj_100);
    // adj: b_top = wp.dot(oc_top, d_local_norm)                                              <L 337>
    wp::adj_sub(var_ray_origin, var_98, adj_ray_origin, adj_98, adj_99);
    wp::adj_vec_t(var_96, var_97, var_h, adj_96, adj_97, adj_h, adj_98);
    // adj: oc_top = ray_origin - wp.vec3(0.0, 0.0, h)                                        <L 336>
    wp::adj_where(var_22, var_94, var_10, adj_22, adj_94, adj_10, adj_95);
    if (var_22) {
        wp::adj_where(var_55, var_92, var_10, adj_55, adj_92, adj_10, adj_94);
        if (var_55) {
            wp::adj_where(var_81, var_87, var_69, adj_81, adj_87, adj_69, adj_93);
            wp::adj_where(var_81, var_91, var_74, adj_81, adj_91, adj_74, adj_92);
            if (var_81) {
                wp::adj_where(var_89, var_90, var_74, adj_89, adj_90, adj_74, adj_91);
                if (var_89) {
                    wp::adj_min(var_74, var_79, adj_74, adj_79, adj_90);
                    // adj: min_t = wp.min(min_t, t2)                                         <L 332>
                }
                wp::adj_abs(var_87, adj_87, adj_88);
                // adj: if wp.abs(z) <= h:                                                    <L 331>
                wp::adj_add(var_83, var_86, adj_83, adj_86, adj_87);
                wp::adj_mul(var_79, var_85, adj_79, adj_85, adj_86);
                wp::adj_extract(var_9, var_84, adj_9, adj_84, adj_85);
                wp::adj_extract(var_ray_origin, var_82, adj_ray_origin, adj_82, adj_83);
                // adj: z = ray_origin[2] + t2 * d_local_norm[2]                              <L 330>
            }
            // adj: if t2 >= 0.0:                                                             <L 329>
            wp::adj_div(var_76, var_78, var_79, adj_76, adj_78, adj_79);
            wp::adj_mul(var_77, var_21, adj_77, adj_21, adj_78);
            wp::adj_add(var_75, var_56, adj_75, adj_56, adj_76);
            wp::adj_neg(var_35, adj_35, adj_75);
            // adj: t2 = (-b_cyl + sqrt_delta_cyl) / (2.0 * a_cyl)                            <L 328>
            wp::adj_where(var_63, var_73, var_10, adj_63, adj_73, adj_10, adj_74);
            if (var_63) {
                wp::adj_where(var_71, var_72, var_10, adj_71, adj_72, adj_10, adj_73);
                if (var_71) {
                    wp::adj_min(var_10, var_61, adj_10, adj_61, adj_72);
                    // adj: min_t = wp.min(min_t, t1)                                         <L 326>
                }
                wp::adj_abs(var_69, adj_69, adj_70);
                // adj: if wp.abs(z) <= h:                                                    <L 325>
                wp::adj_add(var_65, var_68, adj_65, adj_68, adj_69);
                wp::adj_mul(var_61, var_67, adj_61, adj_67, adj_68);
                wp::adj_extract(var_9, var_66, adj_9, adj_66, adj_67);
                wp::adj_extract(var_ray_origin, var_64, adj_ray_origin, adj_64, adj_65);
                // adj: z = ray_origin[2] + t1 * d_local_norm[2]                              <L 324>
            }
            // adj: if t1 >= 0.0:                                                             <L 323>
            wp::adj_div(var_58, var_60, var_61, adj_58, adj_60, adj_61);
            wp::adj_mul(var_59, var_21, adj_59, adj_21, adj_60);
            wp::adj_sub(var_57, var_56, adj_57, adj_56, adj_58);
            wp::adj_neg(var_35, adj_35, adj_57);
            // adj: t1 = (-b_cyl - sqrt_delta_cyl) / (2.0 * a_cyl)                            <L 322>
            wp::adj_sqrt(var_53, var_56, adj_53, adj_56);
            // adj: sqrt_delta_cyl = wp.sqrt(delta_cyl)                                       <L 321>
        }
        // adj: if delta_cyl >= 0.0:                                                          <L 320>
        wp::adj_sub(var_49, var_52, adj_49, adj_52, adj_53);
        wp::adj_mul(var_51, var_48, adj_51, adj_48, adj_52);
        wp::adj_mul(var_50, var_21, adj_50, adj_21, adj_51);
        wp::adj_mul(var_35, var_35, adj_35, adj_35, adj_49);
        // adj: delta_cyl = b_cyl * b_cyl - 4.0 * a_cyl * c_cyl                               <L 319>
        wp::adj_sub(var_46, var_47, adj_46, adj_47, adj_48);
        wp::adj_mul(var_r, var_r, adj_r, adj_r, adj_47);
        wp::adj_add(var_40, var_45, adj_40, adj_45, adj_46);
        wp::adj_mul(var_42, var_44, adj_42, adj_44, adj_45);
        wp::adj_extract(var_ray_origin, var_43, adj_ray_origin, adj_43, adj_44);
        wp::adj_extract(var_ray_origin, var_41, adj_ray_origin, adj_41, adj_42);
        wp::adj_mul(var_37, var_39, adj_37, adj_39, adj_40);
        wp::adj_extract(var_ray_origin, var_38, adj_ray_origin, adj_38, adj_39);
        wp::adj_extract(var_ray_origin, var_36, adj_ray_origin, adj_36, adj_37);
        // adj: c_cyl = ray_origin[0] * ray_origin[0] + ray_origin[1] * ray_origin[1] - r * r  <L 318>
        wp::adj_mul(var_23, var_34, adj_23, adj_34, adj_35);
        wp::adj_add(var_28, var_33, adj_28, adj_33, adj_34);
        wp::adj_mul(var_30, var_32, adj_30, adj_32, adj_33);
        wp::adj_extract(var_9, var_31, adj_9, adj_31, adj_32);
        wp::adj_extract(var_ray_origin, var_29, adj_ray_origin, adj_29, adj_30);
        wp::adj_mul(var_25, var_27, adj_25, adj_27, adj_28);
        wp::adj_extract(var_9, var_26, adj_9, adj_26, adj_27);
        wp::adj_extract(var_ray_origin, var_24, adj_ray_origin, adj_24, adj_25);
        // adj: b_cyl = 2.0 * (ray_origin[0] * d_local_norm[0] + ray_origin[1] * d_local_norm[1])  <L 317>
    }
    // adj: if a_cyl > MINVAL:                                                                <L 316>
    wp::adj_add(var_15, var_20, adj_15, adj_20, adj_21);
    wp::adj_mul(var_17, var_19, adj_17, adj_19, adj_20);
    wp::adj_extract(var_9, var_18, adj_9, adj_18, adj_19);
    wp::adj_extract(var_9, var_16, adj_9, adj_16, adj_17);
    wp::adj_mul(var_12, var_14, adj_12, adj_14, adj_15);
    wp::adj_extract(var_9, var_13, adj_9, adj_13, adj_14);
    wp::adj_extract(var_9, var_11, adj_9, adj_11, adj_12);
    // adj: a_cyl = d_local_norm[0] * d_local_norm[0] + d_local_norm[1] * d_local_norm[1]     <L 315>
    // adj: min_t = 1.0e10                                                                    <L 312>
    wp::adj_mul(var_ray_direction, var_8, adj_ray_direction, adj_8, adj_9);
    // adj: d_local_norm = ray_direction * inv_d_len                                          <L 310>
    wp::adj_div(var_6, var_7, var_8, adj_6, adj_7, adj_8);
    wp::adj_sqrt(var_3, var_7, adj_3, adj_7);
    // adj: inv_d_len = 1.0 / wp.sqrt(d_len_sq)                                               <L 309>
    if (var_5) {
        label0:;
        adj_2 += adj_ret_1;
        adj_0 += adj_ret_0;
        // adj: return t_hit, normal                                                          <L 307>
    }
    // adj: if d_len_sq < MINVAL:                                                             <L 306>
    wp::adj_dot(var_ray_direction, var_ray_direction, adj_ray_direction, adj_ray_direction, adj_3);
    // adj: d_len_sq = wp.dot(ray_direction, ray_direction)                                   <L 305>
    wp::adj_vec_t(var_1, adj_1, adj_2);
    // adj: normal = wp.vec3(0.0)                                                             <L 303>
    // adj: t_hit = -1.0                                                                      <L 302>
    // adj: def ray_intersect_capsule(ray_origin: wp.vec3, ray_direction: wp.vec3, r: float, h: float) -> tuple[float, wp.vec3]:  <L 288>
    return;
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/geometry/raycast.py:381
static void adj_ray_intersect_cylinder_0(
    wp::vec_t<3, wp::float32> var_ray_origin,
    wp::vec_t<3, wp::float32> var_ray_direction,
    wp::float32 var_r,
    wp::float32 var_h,
    wp::float32 var_barrel_radius,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & adj_ray_origin,
    wp::vec_t<3, wp::float32> & adj_ray_direction,
    wp::float32 & adj_r,
    wp::float32 & adj_h,
    wp::float32 & adj_barrel_radius,
    wp::float32 & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
    //---------
    // primal vars
    const wp::float32 var_0 = -1.0;
    const wp::float32 var_1 = 0.0;
    wp::vec_t<3, wp::float32> var_2;
    const wp::float32 var_3 = 10000000000.0;
    const wp::float32 var_4 = 0.0;
    wp::float32 var_5;
    bool var_6;
    const wp::float32 var_7 = 0.0;
    bool var_8;
    const wp::float32 var_9 = 1e-15;
    bool var_10;
    wp::float32 var_11;
    wp::float32 var_12;
    wp::float32 var_13;
    wp::float32 var_14;
    wp::float32 var_15;
    wp::float32 var_16;
    wp::float32 var_17;
    wp::float32 var_18;
    wp::float32 var_19;
    wp::float32 var_20;
    wp::float32 var_21;
    wp::float32 var_22;
    wp::float32 var_23;
    const wp::int32 var_24 = 0;
    wp::float32 var_25;
    const wp::int32 var_26 = 0;
    wp::float32 var_27;
    wp::float32 var_28;
    const wp::int32 var_29 = 1;
    wp::float32 var_30;
    const wp::int32 var_31 = 1;
    wp::float32 var_32;
    wp::float32 var_33;
    wp::float32 var_34;
    const wp::int32 var_35 = 2;
    wp::float32 var_36;
    wp::float32 var_37;
    const wp::int32 var_38 = 2;
    wp::float32 var_39;
    wp::float32 var_40;
    wp::float32 var_41;
    bool var_42;
    const wp::float32 var_43 = 2.0;
    const wp::int32 var_44 = 0;
    wp::float32 var_45;
    const wp::int32 var_46 = 0;
    wp::float32 var_47;
    wp::float32 var_48;
    const wp::int32 var_49 = 1;
    wp::float32 var_50;
    const wp::int32 var_51 = 1;
    wp::float32 var_52;
    wp::float32 var_53;
    wp::float32 var_54;
    const wp::int32 var_55 = 2;
    wp::float32 var_56;
    wp::float32 var_57;
    const wp::int32 var_58 = 2;
    wp::float32 var_59;
    wp::float32 var_60;
    wp::float32 var_61;
    wp::float32 var_62;
    const wp::int32 var_63 = 0;
    wp::float32 var_64;
    const wp::int32 var_65 = 0;
    wp::float32 var_66;
    wp::float32 var_67;
    const wp::int32 var_68 = 1;
    wp::float32 var_69;
    const wp::int32 var_70 = 1;
    wp::float32 var_71;
    wp::float32 var_72;
    wp::float32 var_73;
    const wp::int32 var_74 = 2;
    wp::float32 var_75;
    wp::float32 var_76;
    const wp::int32 var_77 = 2;
    wp::float32 var_78;
    wp::float32 var_79;
    wp::float32 var_80;
    wp::float32 var_81;
    wp::float32 var_82;
    wp::float32 var_83;
    const wp::float32 var_84 = 4.0;
    wp::float32 var_85;
    wp::float32 var_86;
    wp::float32 var_87;
    const wp::float32 var_88 = 0.0;
    bool var_89;
    wp::float32 var_90;
    const wp::float32 var_91 = 1.0;
    const wp::float32 var_92 = 2.0;
    wp::float32 var_93;
    wp::float32 var_94;
    wp::float32 var_95;
    wp::float32 var_96;
    wp::float32 var_97;
    const wp::int32 var_98 = 2;
    wp::float32 var_99;
    const wp::int32 var_100 = 2;
    wp::float32 var_101;
    wp::float32 var_102;
    wp::float32 var_103;
    bool var_104;
    const wp::float32 var_105 = 0.0;
    bool var_106;
    wp::float32 var_107;
    bool var_108;
    wp::float32 var_109;
    wp::float32 var_110;
    wp::float32 var_111;
    const wp::int32 var_112 = 2;
    wp::float32 var_113;
    const wp::int32 var_114 = 2;
    wp::float32 var_115;
    wp::float32 var_116;
    wp::float32 var_117;
    wp::float32 var_118;
    wp::float32 var_119;
    bool var_120;
    const wp::float32 var_121 = 0.0;
    bool var_122;
    wp::float32 var_123;
    bool var_124;
    wp::float32 var_125;
    wp::float32 var_126;
    wp::float32 var_127;
    wp::float32 var_128;
    bool var_129;
    const wp::float32 var_130 = 0.0;
    bool var_131;
    const wp::float32 var_132 = 10000000000.0;
    bool var_133;
    wp::vec_t<3, wp::float32> var_134;
    wp::vec_t<3, wp::float32> var_135;
    const wp::int32 var_136 = 0;
    wp::float32 var_137;
    const wp::int32 var_138 = 0;
    wp::float32 var_139;
    wp::float32 var_140;
    const wp::int32 var_141 = 1;
    wp::float32 var_142;
    const wp::int32 var_143 = 1;
    wp::float32 var_144;
    wp::float32 var_145;
    wp::float32 var_146;
    wp::float32 var_147;
    wp::float32 var_148;
    const wp::int32 var_149 = 2;
    wp::float32 var_150;
    const wp::int32 var_151 = 2;
    wp::float32 var_152;
    wp::float32 var_153;
    wp::float32 var_154;
    bool var_155;
    bool var_156;
    bool var_157;
    wp::float32 var_158;
    wp::float32 var_159;
    wp::float32 var_160;
    wp::float32 var_161;
    wp::float32 var_162;
    wp::float32 var_163;
    wp::float32 var_164;
    wp::float32 var_165;
    const wp::int32 var_166 = 0;
    wp::float32 var_167;
    const wp::int32 var_168 = 0;
    wp::float32 var_169;
    wp::float32 var_170;
    const wp::int32 var_171 = 1;
    wp::float32 var_172;
    const wp::int32 var_173 = 1;
    wp::float32 var_174;
    wp::float32 var_175;
    wp::float32 var_176;
    wp::float32 var_177;
    const wp::int32 var_178 = 2;
    wp::float32 var_179;
    const wp::int32 var_180 = 2;
    wp::float32 var_181;
    wp::float32 var_182;
    wp::float32 var_183;
    wp::float32 var_184;
    wp::float32 var_185;
    bool var_186;
    wp::float32 var_187;
    wp::float32 var_188;
    const wp::int32 var_189 = 2;
    wp::float32 var_190;
    const wp::int32 var_191 = 2;
    wp::float32 var_192;
    wp::float32 var_193;
    wp::float32 var_194;
    bool var_195;
    const wp::float32 var_196 = 0.0;
    bool var_197;
    wp::float32 var_198;
    bool var_199;
    wp::float32 var_200;
    wp::float32 var_201;
    wp::float32 var_202;
    wp::float32 var_203;
    wp::float32 var_204;
    const wp::int32 var_205 = 2;
    wp::float32 var_206;
    wp::float32 var_207;
    bool var_208;
    const wp::float32 var_209 = 1.0;
    const wp::int32 var_210 = 2;
    wp::float32 var_211;
    wp::float32 var_212;
    const wp::int32 var_213 = 2;
    wp::float32 var_214;
    wp::float32 var_215;
    wp::float32 var_216;
    const wp::float32 var_217 = 0.0;
    bool var_218;
    const wp::int32 var_219 = 0;
    wp::float32 var_220;
    const wp::int32 var_221 = 0;
    wp::float32 var_222;
    wp::float32 var_223;
    wp::float32 var_224;
    const wp::int32 var_225 = 1;
    wp::float32 var_226;
    const wp::int32 var_227 = 1;
    wp::float32 var_228;
    wp::float32 var_229;
    wp::float32 var_230;
    wp::float32 var_231;
    wp::float32 var_232;
    wp::float32 var_233;
    wp::float32 var_234;
    bool var_235;
    wp::float32 var_236;
    wp::float32 var_237;
    wp::float32 var_238;
    wp::float32 var_239;
    const wp::int32 var_240 = 2;
    wp::float32 var_241;
    wp::float32 var_242;
    wp::float32 var_243;
    const wp::float32 var_244 = 0.0;
    bool var_245;
    const wp::int32 var_246 = 0;
    wp::float32 var_247;
    const wp::int32 var_248 = 0;
    wp::float32 var_249;
    wp::float32 var_250;
    wp::float32 var_251;
    const wp::int32 var_252 = 1;
    wp::float32 var_253;
    const wp::int32 var_254 = 1;
    wp::float32 var_255;
    wp::float32 var_256;
    wp::float32 var_257;
    wp::float32 var_258;
    wp::float32 var_259;
    wp::float32 var_260;
    wp::float32 var_261;
    bool var_262;
    wp::float32 var_263;
    wp::float32 var_264;
    wp::float32 var_265;
    wp::float32 var_266;
    wp::float32 var_267;
    wp::float32 var_268;
    const wp::float32 var_269 = 1000000000.0;
    bool var_270;
    wp::float32 var_271;
    wp::float32 var_272;
    const wp::float32 var_273 = 0.0;
    bool var_274;
    wp::vec_t<3, wp::float32> var_275;
    wp::vec_t<3, wp::float32> var_276;
    wp::float32 var_277;
    const wp::int32 var_278 = 2;
    wp::float32 var_279;
    wp::float32 var_280;
    wp::float32 var_281;
    bool var_282;
    const wp::float32 var_283 = 1e-06;
    wp::float32 var_284;
    bool var_285;
    wp::float32 var_286;
    wp::float32 var_287;
    bool var_288;
    const wp::float32 var_289 = 0.0;
    const wp::float32 var_290 = 0.0;
    wp::vec_t<3, wp::float32> var_291;
    const wp::float32 var_292 = 0.0;
    bool var_293;
    const wp::int32 var_294 = 0;
    wp::float32 var_295;
    const wp::int32 var_296 = 0;
    wp::float32 var_297;
    wp::float32 var_298;
    const wp::int32 var_299 = 1;
    wp::float32 var_300;
    const wp::int32 var_301 = 1;
    wp::float32 var_302;
    wp::float32 var_303;
    wp::float32 var_304;
    wp::float32 var_305;
    wp::float32 var_306;
    const wp::int32 var_307 = 2;
    wp::float32 var_308;
    const wp::int32 var_309 = 2;
    wp::float32 var_310;
    wp::float32 var_311;
    wp::float32 var_312;
    wp::float32 var_313;
    const wp::int32 var_314 = 0;
    wp::float32 var_315;
    wp::float32 var_316;
    const wp::int32 var_317 = 1;
    wp::float32 var_318;
    wp::float32 var_319;
    const wp::int32 var_320 = 2;
    wp::float32 var_321;
    wp::float32 var_322;
    wp::vec_t<3, wp::float32> var_323;
    const wp::int32 var_324 = 0;
    wp::float32 var_325;
    const wp::int32 var_326 = 1;
    wp::float32 var_327;
    const wp::int32 var_328 = 2;
    wp::float32 var_329;
    wp::float32 var_330;
    wp::vec_t<3, wp::float32> var_331;
    wp::vec_t<3, wp::float32> var_332;
    wp::vec_t<3, wp::float32> var_333;
    wp::vec_t<3, wp::float32> var_334;
    wp::vec_t<3, wp::float32> var_335;
    //---------
    // dual vars
    wp::float32 adj_0 = {};
    wp::float32 adj_1 = {};
    wp::vec_t<3, wp::float32> adj_2 = {};
    wp::float32 adj_3 = {};
    wp::float32 adj_4 = {};
    wp::float32 adj_5 = {};
    bool adj_6 = {};
    wp::float32 adj_7 = {};
    bool adj_8 = {};
    wp::float32 adj_9 = {};
    bool adj_10 = {};
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
    wp::float32 adj_22 = {};
    wp::float32 adj_23 = {};
    wp::int32 adj_24 = {};
    wp::float32 adj_25 = {};
    wp::int32 adj_26 = {};
    wp::float32 adj_27 = {};
    wp::float32 adj_28 = {};
    wp::int32 adj_29 = {};
    wp::float32 adj_30 = {};
    wp::int32 adj_31 = {};
    wp::float32 adj_32 = {};
    wp::float32 adj_33 = {};
    wp::float32 adj_34 = {};
    wp::int32 adj_35 = {};
    wp::float32 adj_36 = {};
    wp::float32 adj_37 = {};
    wp::int32 adj_38 = {};
    wp::float32 adj_39 = {};
    wp::float32 adj_40 = {};
    wp::float32 adj_41 = {};
    bool adj_42 = {};
    wp::float32 adj_43 = {};
    wp::int32 adj_44 = {};
    wp::float32 adj_45 = {};
    wp::int32 adj_46 = {};
    wp::float32 adj_47 = {};
    wp::float32 adj_48 = {};
    wp::int32 adj_49 = {};
    wp::float32 adj_50 = {};
    wp::int32 adj_51 = {};
    wp::float32 adj_52 = {};
    wp::float32 adj_53 = {};
    wp::float32 adj_54 = {};
    wp::int32 adj_55 = {};
    wp::float32 adj_56 = {};
    wp::float32 adj_57 = {};
    wp::int32 adj_58 = {};
    wp::float32 adj_59 = {};
    wp::float32 adj_60 = {};
    wp::float32 adj_61 = {};
    wp::float32 adj_62 = {};
    wp::int32 adj_63 = {};
    wp::float32 adj_64 = {};
    wp::int32 adj_65 = {};
    wp::float32 adj_66 = {};
    wp::float32 adj_67 = {};
    wp::int32 adj_68 = {};
    wp::float32 adj_69 = {};
    wp::int32 adj_70 = {};
    wp::float32 adj_71 = {};
    wp::float32 adj_72 = {};
    wp::float32 adj_73 = {};
    wp::int32 adj_74 = {};
    wp::float32 adj_75 = {};
    wp::float32 adj_76 = {};
    wp::int32 adj_77 = {};
    wp::float32 adj_78 = {};
    wp::float32 adj_79 = {};
    wp::float32 adj_80 = {};
    wp::float32 adj_81 = {};
    wp::float32 adj_82 = {};
    wp::float32 adj_83 = {};
    wp::float32 adj_84 = {};
    wp::float32 adj_85 = {};
    wp::float32 adj_86 = {};
    wp::float32 adj_87 = {};
    wp::float32 adj_88 = {};
    bool adj_89 = {};
    wp::float32 adj_90 = {};
    wp::float32 adj_91 = {};
    wp::float32 adj_92 = {};
    wp::float32 adj_93 = {};
    wp::float32 adj_94 = {};
    wp::float32 adj_95 = {};
    wp::float32 adj_96 = {};
    wp::float32 adj_97 = {};
    wp::int32 adj_98 = {};
    wp::float32 adj_99 = {};
    wp::int32 adj_100 = {};
    wp::float32 adj_101 = {};
    wp::float32 adj_102 = {};
    wp::float32 adj_103 = {};
    bool adj_104 = {};
    wp::float32 adj_105 = {};
    bool adj_106 = {};
    wp::float32 adj_107 = {};
    bool adj_108 = {};
    wp::float32 adj_109 = {};
    wp::float32 adj_110 = {};
    wp::float32 adj_111 = {};
    wp::int32 adj_112 = {};
    wp::float32 adj_113 = {};
    wp::int32 adj_114 = {};
    wp::float32 adj_115 = {};
    wp::float32 adj_116 = {};
    wp::float32 adj_117 = {};
    wp::float32 adj_118 = {};
    wp::float32 adj_119 = {};
    bool adj_120 = {};
    wp::float32 adj_121 = {};
    bool adj_122 = {};
    wp::float32 adj_123 = {};
    bool adj_124 = {};
    wp::float32 adj_125 = {};
    wp::float32 adj_126 = {};
    wp::float32 adj_127 = {};
    wp::float32 adj_128 = {};
    bool adj_129 = {};
    wp::float32 adj_130 = {};
    bool adj_131 = {};
    wp::float32 adj_132 = {};
    bool adj_133 = {};
    wp::vec_t<3, wp::float32> adj_134 = {};
    wp::vec_t<3, wp::float32> adj_135 = {};
    wp::int32 adj_136 = {};
    wp::float32 adj_137 = {};
    wp::int32 adj_138 = {};
    wp::float32 adj_139 = {};
    wp::float32 adj_140 = {};
    wp::int32 adj_141 = {};
    wp::float32 adj_142 = {};
    wp::int32 adj_143 = {};
    wp::float32 adj_144 = {};
    wp::float32 adj_145 = {};
    wp::float32 adj_146 = {};
    wp::float32 adj_147 = {};
    wp::float32 adj_148 = {};
    wp::int32 adj_149 = {};
    wp::float32 adj_150 = {};
    wp::int32 adj_151 = {};
    wp::float32 adj_152 = {};
    wp::float32 adj_153 = {};
    wp::float32 adj_154 = {};
    bool adj_155 = {};
    bool adj_156 = {};
    bool adj_157 = {};
    wp::float32 adj_158 = {};
    wp::float32 adj_159 = {};
    wp::float32 adj_160 = {};
    wp::float32 adj_161 = {};
    wp::float32 adj_162 = {};
    wp::float32 adj_163 = {};
    wp::float32 adj_164 = {};
    wp::float32 adj_165 = {};
    wp::int32 adj_166 = {};
    wp::float32 adj_167 = {};
    wp::int32 adj_168 = {};
    wp::float32 adj_169 = {};
    wp::float32 adj_170 = {};
    wp::int32 adj_171 = {};
    wp::float32 adj_172 = {};
    wp::int32 adj_173 = {};
    wp::float32 adj_174 = {};
    wp::float32 adj_175 = {};
    wp::float32 adj_176 = {};
    wp::float32 adj_177 = {};
    wp::int32 adj_178 = {};
    wp::float32 adj_179 = {};
    wp::int32 adj_180 = {};
    wp::float32 adj_181 = {};
    wp::float32 adj_182 = {};
    wp::float32 adj_183 = {};
    wp::float32 adj_184 = {};
    wp::float32 adj_185 = {};
    bool adj_186 = {};
    wp::float32 adj_187 = {};
    wp::float32 adj_188 = {};
    wp::int32 adj_189 = {};
    wp::float32 adj_190 = {};
    wp::int32 adj_191 = {};
    wp::float32 adj_192 = {};
    wp::float32 adj_193 = {};
    wp::float32 adj_194 = {};
    bool adj_195 = {};
    wp::float32 adj_196 = {};
    bool adj_197 = {};
    wp::float32 adj_198 = {};
    bool adj_199 = {};
    wp::float32 adj_200 = {};
    wp::float32 adj_201 = {};
    wp::float32 adj_202 = {};
    wp::float32 adj_203 = {};
    wp::float32 adj_204 = {};
    wp::int32 adj_205 = {};
    wp::float32 adj_206 = {};
    wp::float32 adj_207 = {};
    bool adj_208 = {};
    wp::float32 adj_209 = {};
    wp::int32 adj_210 = {};
    wp::float32 adj_211 = {};
    wp::float32 adj_212 = {};
    wp::int32 adj_213 = {};
    wp::float32 adj_214 = {};
    wp::float32 adj_215 = {};
    wp::float32 adj_216 = {};
    wp::float32 adj_217 = {};
    bool adj_218 = {};
    wp::int32 adj_219 = {};
    wp::float32 adj_220 = {};
    wp::int32 adj_221 = {};
    wp::float32 adj_222 = {};
    wp::float32 adj_223 = {};
    wp::float32 adj_224 = {};
    wp::int32 adj_225 = {};
    wp::float32 adj_226 = {};
    wp::int32 adj_227 = {};
    wp::float32 adj_228 = {};
    wp::float32 adj_229 = {};
    wp::float32 adj_230 = {};
    wp::float32 adj_231 = {};
    wp::float32 adj_232 = {};
    wp::float32 adj_233 = {};
    wp::float32 adj_234 = {};
    bool adj_235 = {};
    wp::float32 adj_236 = {};
    wp::float32 adj_237 = {};
    wp::float32 adj_238 = {};
    wp::float32 adj_239 = {};
    wp::int32 adj_240 = {};
    wp::float32 adj_241 = {};
    wp::float32 adj_242 = {};
    wp::float32 adj_243 = {};
    wp::float32 adj_244 = {};
    bool adj_245 = {};
    wp::int32 adj_246 = {};
    wp::float32 adj_247 = {};
    wp::int32 adj_248 = {};
    wp::float32 adj_249 = {};
    wp::float32 adj_250 = {};
    wp::float32 adj_251 = {};
    wp::int32 adj_252 = {};
    wp::float32 adj_253 = {};
    wp::int32 adj_254 = {};
    wp::float32 adj_255 = {};
    wp::float32 adj_256 = {};
    wp::float32 adj_257 = {};
    wp::float32 adj_258 = {};
    wp::float32 adj_259 = {};
    wp::float32 adj_260 = {};
    wp::float32 adj_261 = {};
    bool adj_262 = {};
    wp::float32 adj_263 = {};
    wp::float32 adj_264 = {};
    wp::float32 adj_265 = {};
    wp::float32 adj_266 = {};
    wp::float32 adj_267 = {};
    wp::float32 adj_268 = {};
    wp::float32 adj_269 = {};
    bool adj_270 = {};
    wp::float32 adj_271 = {};
    wp::float32 adj_272 = {};
    wp::float32 adj_273 = {};
    bool adj_274 = {};
    wp::vec_t<3, wp::float32> adj_275 = {};
    wp::vec_t<3, wp::float32> adj_276 = {};
    wp::float32 adj_277 = {};
    wp::int32 adj_278 = {};
    wp::float32 adj_279 = {};
    wp::float32 adj_280 = {};
    wp::float32 adj_281 = {};
    bool adj_282 = {};
    wp::float32 adj_283 = {};
    wp::float32 adj_284 = {};
    bool adj_285 = {};
    wp::float32 adj_286 = {};
    wp::float32 adj_287 = {};
    bool adj_288 = {};
    wp::float32 adj_289 = {};
    wp::float32 adj_290 = {};
    wp::vec_t<3, wp::float32> adj_291 = {};
    wp::float32 adj_292 = {};
    bool adj_293 = {};
    wp::int32 adj_294 = {};
    wp::float32 adj_295 = {};
    wp::int32 adj_296 = {};
    wp::float32 adj_297 = {};
    wp::float32 adj_298 = {};
    wp::int32 adj_299 = {};
    wp::float32 adj_300 = {};
    wp::int32 adj_301 = {};
    wp::float32 adj_302 = {};
    wp::float32 adj_303 = {};
    wp::float32 adj_304 = {};
    wp::float32 adj_305 = {};
    wp::float32 adj_306 = {};
    wp::int32 adj_307 = {};
    wp::float32 adj_308 = {};
    wp::int32 adj_309 = {};
    wp::float32 adj_310 = {};
    wp::float32 adj_311 = {};
    wp::float32 adj_312 = {};
    wp::float32 adj_313 = {};
    wp::int32 adj_314 = {};
    wp::float32 adj_315 = {};
    wp::float32 adj_316 = {};
    wp::int32 adj_317 = {};
    wp::float32 adj_318 = {};
    wp::float32 adj_319 = {};
    wp::int32 adj_320 = {};
    wp::float32 adj_321 = {};
    wp::float32 adj_322 = {};
    wp::vec_t<3, wp::float32> adj_323 = {};
    wp::int32 adj_324 = {};
    wp::float32 adj_325 = {};
    wp::int32 adj_326 = {};
    wp::float32 adj_327 = {};
    wp::int32 adj_328 = {};
    wp::float32 adj_329 = {};
    wp::float32 adj_330 = {};
    wp::vec_t<3, wp::float32> adj_331 = {};
    wp::vec_t<3, wp::float32> adj_332 = {};
    wp::vec_t<3, wp::float32> adj_333 = {};
    wp::vec_t<3, wp::float32> adj_334 = {};
    wp::vec_t<3, wp::float32> adj_335 = {};
    //---------
    // forward
    // def ray_intersect_cylinder(                                                            <L 382>
    // t_hit = -1.0                                                                           <L 401>
    // normal = wp.vec3(0.0)                                                                  <L 402>
    var_2 = wp::vec_t<3, wp::float32>(var_1);
    // min_t = 1.0e10                                                                         <L 403>
    // axial_scale = 0.0                                                                      <L 404>
    // equatorial_radius = r                                                                  <L 405>
    var_5 = wp::copy(var_r);
    // if barrel_radius > 0.0 and h > MINVAL:                                                 <L 407>
    var_8 = (var_barrel_radius > var_7);
    var_6 = var_8;
    if (var_6) {
        var_10 = (var_h > var_9);
        var_6 = var_6 && var_10;
    }
    if (var_6) {
        // equatorial_radius = r + barrel_radius - wp.sqrt(barrel_radius * barrel_radius - h * h)       <L 408>
        var_11 = wp::add(var_r, var_barrel_radius);
        var_12 = wp::mul(var_barrel_radius, var_barrel_radius);
        var_13 = wp::mul(var_h, var_h);
        var_14 = wp::sub(var_12, var_13);
        var_15 = wp::sqrt(var_14);
        var_16 = wp::sub(var_11, var_15);
        // axial_scale = (equatorial_radius * equatorial_radius - r * r) / (h * h)            <L 409>
        var_17 = wp::mul(var_16, var_16);
        var_18 = wp::mul(var_r, var_r);
        var_19 = wp::sub(var_17, var_18);
        var_20 = wp::mul(var_h, var_h);
        var_21 = wp::div(var_19, var_20);
    }
    var_22 = wp::where(var_6, var_21, var_4);
    var_23 = wp::where(var_6, var_16, var_5);
    // a_side = (                                                                             <L 413>
    // ray_direction[0] * ray_direction[0]                                                    <L 414>
    var_25 = wp::extract(var_ray_direction, var_24);
    var_27 = wp::extract(var_ray_direction, var_26);
    var_28 = wp::mul(var_25, var_27);
    // + ray_direction[1] * ray_direction[1]                                                  <L 415>
    var_30 = wp::extract(var_ray_direction, var_29);
    var_32 = wp::extract(var_ray_direction, var_31);
    var_33 = wp::mul(var_30, var_32);
    var_34 = wp::add(var_28, var_33);
    // + axial_scale * ray_direction[2] * ray_direction[2]                                    <L 416>
    var_36 = wp::extract(var_ray_direction, var_35);
    var_37 = wp::mul(var_22, var_36);
    var_39 = wp::extract(var_ray_direction, var_38);
    var_40 = wp::mul(var_37, var_39);
    var_41 = wp::add(var_34, var_40);
    // if a_side > MINVAL:                                                                    <L 418>
    var_42 = (var_41 > var_9);
    if (var_42) {
        // b_side = 2.0 * (                                                                   <L 419>
        // ray_origin[0] * ray_direction[0]                                                   <L 420>
        var_45 = wp::extract(var_ray_origin, var_44);
        var_47 = wp::extract(var_ray_direction, var_46);
        var_48 = wp::mul(var_45, var_47);
        // + ray_origin[1] * ray_direction[1]                                                 <L 421>
        var_50 = wp::extract(var_ray_origin, var_49);
        var_52 = wp::extract(var_ray_direction, var_51);
        var_53 = wp::mul(var_50, var_52);
        var_54 = wp::add(var_48, var_53);
        // + axial_scale * ray_origin[2] * ray_direction[2]                                   <L 422>
        var_56 = wp::extract(var_ray_origin, var_55);
        var_57 = wp::mul(var_22, var_56);
        var_59 = wp::extract(var_ray_direction, var_58);
        var_60 = wp::mul(var_57, var_59);
        var_61 = wp::add(var_54, var_60);
        var_62 = wp::mul(var_43, var_61);
        // c_side = (                                                                         <L 424>
        // ray_origin[0] * ray_origin[0]                                                      <L 425>
        var_64 = wp::extract(var_ray_origin, var_63);
        var_66 = wp::extract(var_ray_origin, var_65);
        var_67 = wp::mul(var_64, var_66);
        // + ray_origin[1] * ray_origin[1]                                                    <L 426>
        var_69 = wp::extract(var_ray_origin, var_68);
        var_71 = wp::extract(var_ray_origin, var_70);
        var_72 = wp::mul(var_69, var_71);
        var_73 = wp::add(var_67, var_72);
        // + axial_scale * ray_origin[2] * ray_origin[2]                                      <L 427>
        var_75 = wp::extract(var_ray_origin, var_74);
        var_76 = wp::mul(var_22, var_75);
        var_78 = wp::extract(var_ray_origin, var_77);
        var_79 = wp::mul(var_76, var_78);
        var_80 = wp::add(var_73, var_79);
        // - equatorial_radius * equatorial_radius                                            <L 428>
        var_81 = wp::mul(var_23, var_23);
        var_82 = wp::sub(var_80, var_81);
        // delta_side = b_side * b_side - 4.0 * a_side * c_side                               <L 430>
        var_83 = wp::mul(var_62, var_62);
        var_85 = wp::mul(var_84, var_41);
        var_86 = wp::mul(var_85, var_82);
        var_87 = wp::sub(var_83, var_86);
        // if delta_side >= 0.0:                                                              <L 431>
        var_89 = (var_87 >= var_88);
        if (var_89) {
            // sqrt_delta_side = wp.sqrt(delta_side)                                          <L 432>
            var_90 = wp::sqrt(var_87);
            // inv_2a_side = 1.0 / (2.0 * a_side)                                             <L 433>
            var_93 = wp::mul(var_92, var_41);
            var_94 = wp::div(var_91, var_93);
            // t_side = (-b_side - sqrt_delta_side) * inv_2a_side                             <L 434>
            var_95 = wp::neg(var_62);
            var_96 = wp::sub(var_95, var_90);
            var_97 = wp::mul(var_96, var_94);
            // z_side = ray_origin[2] + t_side * ray_direction[2]                             <L 435>
            var_99 = wp::extract(var_ray_origin, var_98);
            var_101 = wp::extract(var_ray_direction, var_100);
            var_102 = wp::mul(var_97, var_101);
            var_103 = wp::add(var_99, var_102);
            // if t_side < 0.0 or wp.abs(z_side) > h:                                         <L 436>
            var_106 = (var_97 < var_105);
            var_104 = var_106;
            if (!var_104) {
                var_107 = wp::abs(var_103);
                var_108 = (var_107 > var_h);
                var_104 = var_104 || var_108;
            }
            if (var_104) {
                // t_side = (-b_side + sqrt_delta_side) * inv_2a_side                         <L 437>
                var_109 = wp::neg(var_62);
                var_110 = wp::add(var_109, var_90);
                var_111 = wp::mul(var_110, var_94);
                // z_side = ray_origin[2] + t_side * ray_direction[2]                         <L 438>
                var_113 = wp::extract(var_ray_origin, var_112);
                var_115 = wp::extract(var_ray_direction, var_114);
                var_116 = wp::mul(var_111, var_115);
                var_117 = wp::add(var_113, var_116);
            }
            var_118 = wp::where(var_104, var_111, var_97);
            var_119 = wp::where(var_104, var_117, var_103);
            // if t_side >= 0.0 and wp.abs(z_side) <= h:                                      <L 439>
            var_122 = (var_118 >= var_121);
            var_120 = var_122;
            if (var_120) {
                var_123 = wp::abs(var_119);
                var_124 = (var_123 <= var_h);
                var_120 = var_120 && var_124;
            }
            if (var_120) {
                // min_t = t_side                                                             <L 440>
                var_125 = wp::copy(var_118);
            }
            var_126 = wp::where(var_120, var_125, var_3);
        }
        var_127 = wp::where(var_89, var_126, var_3);
    }
    var_128 = wp::where(var_42, var_127, var_3);
    // if barrel_radius > 0.0 and min_t < 1.0e10:                                             <L 444>
    var_131 = (var_barrel_radius > var_130);
    var_129 = var_131;
    if (var_129) {
        var_133 = (var_128 < var_132);
        var_129 = var_129 && var_133;
    }
    if (var_129) {
        // hit_side = ray_origin + min_t * ray_direction                                      <L 445>
        var_134 = wp::mul(var_128, var_ray_direction);
        var_135 = wp::add(var_ray_origin, var_134);
        // radial_side = wp.sqrt(hit_side[0] * hit_side[0] + hit_side[1] * hit_side[1])       <L 446>
        var_137 = wp::extract(var_135, var_136);
        var_139 = wp::extract(var_135, var_138);
        var_140 = wp::mul(var_137, var_139);
        var_142 = wp::extract(var_135, var_141);
        var_144 = wp::extract(var_135, var_143);
        var_145 = wp::mul(var_142, var_144);
        var_146 = wp::add(var_140, var_145);
        var_147 = wp::sqrt(var_146);
        // circle_sq = barrel_radius * barrel_radius - hit_side[2] * hit_side[2]              <L 447>
        var_148 = wp::mul(var_barrel_radius, var_barrel_radius);
        var_150 = wp::extract(var_135, var_149);
        var_152 = wp::extract(var_135, var_151);
        var_153 = wp::mul(var_150, var_152);
        var_154 = wp::sub(var_148, var_153);
        // if radial_side > MINVAL and circle_sq > MINVAL:                                    <L 448>
        var_156 = (var_147 > var_9);
        var_155 = var_156;
        if (var_155) {
            var_157 = (var_154 > var_9);
            var_155 = var_155 && var_157;
        }
        if (var_155) {
            // circle_side = wp.sqrt(circle_sq)                                               <L 449>
            var_158 = wp::sqrt(var_154);
            // end_radial_offset = wp.sqrt(barrel_radius * barrel_radius - h * h)             <L 450>
            var_159 = wp::mul(var_barrel_radius, var_barrel_radius);
            var_160 = wp::mul(var_h, var_h);
            var_161 = wp::sub(var_159, var_160);
            var_162 = wp::sqrt(var_161);
            // residual = radial_side - r - circle_side + end_radial_offset                   <L 451>
            var_163 = wp::sub(var_147, var_r);
            var_164 = wp::sub(var_163, var_158);
            var_165 = wp::add(var_164, var_162);
            // radial_derivative = (hit_side[0] * ray_direction[0] + hit_side[1] * ray_direction[1]) / radial_side       <L 452>
            var_167 = wp::extract(var_135, var_166);
            var_169 = wp::extract(var_ray_direction, var_168);
            var_170 = wp::mul(var_167, var_169);
            var_172 = wp::extract(var_135, var_171);
            var_174 = wp::extract(var_ray_direction, var_173);
            var_175 = wp::mul(var_172, var_174);
            var_176 = wp::add(var_170, var_175);
            var_177 = wp::div(var_176, var_147);
            // axial_derivative = hit_side[2] * ray_direction[2] / circle_side                <L 453>
            var_179 = wp::extract(var_135, var_178);
            var_181 = wp::extract(var_ray_direction, var_180);
            var_182 = wp::mul(var_179, var_181);
            var_183 = wp::div(var_182, var_158);
            // derivative = radial_derivative + axial_derivative                              <L 454>
            var_184 = wp::add(var_177, var_183);
            // if wp.abs(derivative) > MINVAL:                                                <L 455>
            var_185 = wp::abs(var_184);
            var_186 = (var_185 > var_9);
            if (var_186) {
                // refined_t = min_t - residual / derivative                                  <L 456>
                var_187 = wp::div(var_165, var_184);
                var_188 = wp::sub(var_128, var_187);
                // refined_z = ray_origin[2] + refined_t * ray_direction[2]                   <L 457>
                var_190 = wp::extract(var_ray_origin, var_189);
                var_192 = wp::extract(var_ray_direction, var_191);
                var_193 = wp::mul(var_188, var_192);
                var_194 = wp::add(var_190, var_193);
                // if refined_t >= 0.0 and wp.abs(refined_z) <= h:                            <L 458>
                var_197 = (var_188 >= var_196);
                var_195 = var_197;
                if (var_195) {
                    var_198 = wp::abs(var_194);
                    var_199 = (var_198 <= var_h);
                    var_195 = var_195 && var_199;
                }
                if (var_195) {
                    // min_t = refined_t                                                      <L 459>
                    var_200 = wp::copy(var_188);
                }
                var_201 = wp::where(var_195, var_200, var_128);
            }
            var_202 = wp::where(var_186, var_201, var_128);
        }
        var_203 = wp::where(var_155, var_202, var_128);
    }
    var_204 = wp::where(var_129, var_203, var_128);
    // if wp.abs(ray_direction[2]) > MINVAL:                                                  <L 462>
    var_206 = wp::extract(var_ray_direction, var_205);
    var_207 = wp::abs(var_206);
    var_208 = (var_207 > var_9);
    if (var_208) {
        // inv_d_z = 1.0 / ray_direction[2]                                                   <L 463>
        var_211 = wp::extract(var_ray_direction, var_210);
        var_212 = wp::div(var_209, var_211);
        // t_top = (h - ray_origin[2]) * inv_d_z                                              <L 465>
        var_214 = wp::extract(var_ray_origin, var_213);
        var_215 = wp::sub(var_h, var_214);
        var_216 = wp::mul(var_215, var_212);
        // if t_top >= 0.0:                                                                   <L 466>
        var_218 = (var_216 >= var_217);
        if (var_218) {
            // x = ray_origin[0] + t_top * ray_direction[0]                                   <L 467>
            var_220 = wp::extract(var_ray_origin, var_219);
            var_222 = wp::extract(var_ray_direction, var_221);
            var_223 = wp::mul(var_216, var_222);
            var_224 = wp::add(var_220, var_223);
            // y = ray_origin[1] + t_top * ray_direction[1]                                   <L 468>
            var_226 = wp::extract(var_ray_origin, var_225);
            var_228 = wp::extract(var_ray_direction, var_227);
            var_229 = wp::mul(var_216, var_228);
            var_230 = wp::add(var_226, var_229);
            // if x * x + y * y <= r * r:                                                     <L 469>
            var_231 = wp::mul(var_224, var_224);
            var_232 = wp::mul(var_230, var_230);
            var_233 = wp::add(var_231, var_232);
            var_234 = wp::mul(var_r, var_r);
            var_235 = (var_233 <= var_234);
            if (var_235) {
                // min_t = wp.min(min_t, t_top)                                               <L 470>
                var_236 = wp::min(var_204, var_216);
            }
            var_237 = wp::where(var_235, var_236, var_204);
        }
        var_238 = wp::where(var_218, var_237, var_204);
        // t_bot = (-h - ray_origin[2]) * inv_d_z                                             <L 473>
        var_239 = wp::neg(var_h);
        var_241 = wp::extract(var_ray_origin, var_240);
        var_242 = wp::sub(var_239, var_241);
        var_243 = wp::mul(var_242, var_212);
        // if t_bot >= 0.0:                                                                   <L 474>
        var_245 = (var_243 >= var_244);
        if (var_245) {
            // x = ray_origin[0] + t_bot * ray_direction[0]                                   <L 475>
            var_247 = wp::extract(var_ray_origin, var_246);
            var_249 = wp::extract(var_ray_direction, var_248);
            var_250 = wp::mul(var_243, var_249);
            var_251 = wp::add(var_247, var_250);
            // y = ray_origin[1] + t_bot * ray_direction[1]                                   <L 476>
            var_253 = wp::extract(var_ray_origin, var_252);
            var_255 = wp::extract(var_ray_direction, var_254);
            var_256 = wp::mul(var_243, var_255);
            var_257 = wp::add(var_253, var_256);
            // if x * x + y * y <= r * r:                                                     <L 477>
            var_258 = wp::mul(var_251, var_251);
            var_259 = wp::mul(var_257, var_257);
            var_260 = wp::add(var_258, var_259);
            var_261 = wp::mul(var_r, var_r);
            var_262 = (var_260 <= var_261);
            if (var_262) {
                // min_t = wp.min(min_t, t_bot)                                               <L 478>
                var_263 = wp::min(var_238, var_243);
            }
            var_264 = wp::where(var_262, var_263, var_238);
        }
        var_265 = wp::where(var_245, var_264, var_238);
        var_266 = wp::where(var_245, var_251, var_224);
        var_267 = wp::where(var_245, var_257, var_230);
    }
    var_268 = wp::where(var_208, var_265, var_204);
    // if min_t < 1.0e9:                                                                      <L 480>
    var_270 = (var_268 < var_269);
    if (var_270) {
        // t_hit = min_t                                                                      <L 481>
        var_271 = wp::copy(var_268);
    }
    var_272 = wp::where(var_270, var_271, var_0);
    // if t_hit >= 0.0:                                                                       <L 483>
    var_274 = (var_272 >= var_273);
    if (var_274) {
        // hit_local = ray_origin + t_hit * ray_direction                                     <L 484>
        var_275 = wp::mul(var_272, var_ray_direction);
        var_276 = wp::add(var_ray_origin, var_275);
        // z_clamped = wp.min(h, wp.max(-h, hit_local[2]))                                    <L 485>
        var_277 = wp::neg(var_h);
        var_279 = wp::extract(var_276, var_278);
        var_280 = wp::max(var_277, var_279);
        var_281 = wp::min(var_h, var_280);
        // if z_clamped >= (h - EPSILON) or z_clamped <= (-h + EPSILON):                      <L 486>
        var_284 = wp::sub(var_h, var_283);
        var_285 = (var_281 >= var_284);
        var_282 = var_285;
        if (!var_282) {
            var_286 = wp::neg(var_h);
            var_287 = wp::add(var_286, var_283);
            var_288 = (var_281 <= var_287);
            var_282 = var_282 || var_288;
        }
        if (var_282) {
            // normal_local = wp.vec3(0.0, 0.0, z_clamped)                                    <L 487>
            var_291 = wp::vec_t<3, wp::float32>(var_289, var_290, var_281);
        }
        if (!var_282) {
            // elif barrel_radius > 0.0:                                                      <L 488>
            var_293 = (var_barrel_radius > var_292);
            if (var_293) {
                // radial_length = wp.sqrt(hit_local[0] * hit_local[0] + hit_local[1] * hit_local[1])       <L 489>
                var_295 = wp::extract(var_276, var_294);
                var_297 = wp::extract(var_276, var_296);
                var_298 = wp::mul(var_295, var_297);
                var_300 = wp::extract(var_276, var_299);
                var_302 = wp::extract(var_276, var_301);
                var_303 = wp::mul(var_300, var_302);
                var_304 = wp::add(var_298, var_303);
                var_305 = wp::sqrt(var_304);
                // circle_height = wp.sqrt(barrel_radius * barrel_radius - hit_local[2] * hit_local[2])       <L 490>
                var_306 = wp::mul(var_barrel_radius, var_barrel_radius);
                var_308 = wp::extract(var_276, var_307);
                var_310 = wp::extract(var_276, var_309);
                var_311 = wp::mul(var_308, var_310);
                var_312 = wp::sub(var_306, var_311);
                var_313 = wp::sqrt(var_312);
                // normal_local = wp.vec3(                                                    <L 491>
                // hit_local[0] / radial_length,                                              <L 492>
                var_315 = wp::extract(var_276, var_314);
                var_316 = wp::div(var_315, var_305);
                // hit_local[1] / radial_length,                                              <L 493>
                var_318 = wp::extract(var_276, var_317);
                var_319 = wp::div(var_318, var_305);
                // hit_local[2] / circle_height,                                              <L 494>
                var_321 = wp::extract(var_276, var_320);
                var_322 = wp::div(var_321, var_313);
                var_323 = wp::vec_t<3, wp::float32>(var_316, var_319, var_322);
            }
            if (!var_293) {
                // normal_local = wp.vec3(hit_local[0], hit_local[1], axial_scale * hit_local[2])       <L 497>
                var_325 = wp::extract(var_276, var_324);
                var_327 = wp::extract(var_276, var_326);
                var_329 = wp::extract(var_276, var_328);
                var_330 = wp::mul(var_22, var_329);
                var_331 = wp::vec_t<3, wp::float32>(var_325, var_327, var_330);
            }
            var_332 = wp::where(var_293, var_323, var_331);
        }
        var_333 = wp::where(var_282, var_291, var_332);
        // normal = wp.normalize(normal_local)                                                <L 498>
        var_334 = wp::normalize(var_333);
    }
    var_335 = wp::where(var_274, var_334, var_2);
    // return t_hit, normal                                                                   <L 500>
    ret_0 = var_272;
    ret_1 = var_335;
    goto label0;
    //---------
    // reverse
    label0:;
    adj_335 += adj_ret_1;
    adj_272 += adj_ret_0;
    // adj: return t_hit, normal                                                              <L 500>
    wp::adj_where(var_274, var_334, var_2, adj_274, adj_334, adj_2, adj_335);
    if (var_274) {
        wp::adj_normalize(var_333, var_334, adj_333, adj_334);
        // adj: normal = wp.normalize(normal_local)                                           <L 498>
        wp::adj_where(var_282, var_291, var_332, adj_282, adj_291, adj_332, adj_333);
        if (!var_282) {
            wp::adj_where(var_293, var_323, var_331, adj_293, adj_323, adj_331, adj_332);
            if (!var_293) {
                wp::adj_vec_t(var_325, var_327, var_330, adj_325, adj_327, adj_330, adj_331);
                wp::adj_mul(var_22, var_329, adj_22, adj_329, adj_330);
                wp::adj_extract(var_276, var_328, adj_276, adj_328, adj_329);
                wp::adj_extract(var_276, var_326, adj_276, adj_326, adj_327);
                wp::adj_extract(var_276, var_324, adj_276, adj_324, adj_325);
                // adj: normal_local = wp.vec3(hit_local[0], hit_local[1], axial_scale * hit_local[2])  <L 497>
            }
            if (var_293) {
                wp::adj_vec_t(var_316, var_319, var_322, adj_316, adj_319, adj_322, adj_323);
                wp::adj_div(var_321, var_313, var_322, adj_321, adj_313, adj_322);
                wp::adj_extract(var_276, var_320, adj_276, adj_320, adj_321);
                // adj: hit_local[2] / circle_height,                                         <L 494>
                wp::adj_div(var_318, var_305, var_319, adj_318, adj_305, adj_319);
                wp::adj_extract(var_276, var_317, adj_276, adj_317, adj_318);
                // adj: hit_local[1] / radial_length,                                         <L 493>
                wp::adj_div(var_315, var_305, var_316, adj_315, adj_305, adj_316);
                wp::adj_extract(var_276, var_314, adj_276, adj_314, adj_315);
                // adj: hit_local[0] / radial_length,                                         <L 492>
                // adj: normal_local = wp.vec3(                                               <L 491>
                wp::adj_sqrt(var_312, var_313, adj_312, adj_313);
                wp::adj_sub(var_306, var_311, adj_306, adj_311, adj_312);
                wp::adj_mul(var_308, var_310, adj_308, adj_310, adj_311);
                wp::adj_extract(var_276, var_309, adj_276, adj_309, adj_310);
                wp::adj_extract(var_276, var_307, adj_276, adj_307, adj_308);
                wp::adj_mul(var_barrel_radius, var_barrel_radius, adj_barrel_radius, adj_barrel_radius, adj_306);
                // adj: circle_height = wp.sqrt(barrel_radius * barrel_radius - hit_local[2] * hit_local[2])  <L 490>
                wp::adj_sqrt(var_304, var_305, adj_304, adj_305);
                wp::adj_add(var_298, var_303, adj_298, adj_303, adj_304);
                wp::adj_mul(var_300, var_302, adj_300, adj_302, adj_303);
                wp::adj_extract(var_276, var_301, adj_276, adj_301, adj_302);
                wp::adj_extract(var_276, var_299, adj_276, adj_299, adj_300);
                wp::adj_mul(var_295, var_297, adj_295, adj_297, adj_298);
                wp::adj_extract(var_276, var_296, adj_276, adj_296, adj_297);
                wp::adj_extract(var_276, var_294, adj_276, adj_294, adj_295);
                // adj: radial_length = wp.sqrt(hit_local[0] * hit_local[0] + hit_local[1] * hit_local[1])  <L 489>
            }
            // adj: elif barrel_radius > 0.0:                                                 <L 488>
        }
        if (var_282) {
            wp::adj_vec_t(var_289, var_290, var_281, adj_289, adj_290, adj_281, adj_291);
            // adj: normal_local = wp.vec3(0.0, 0.0, z_clamped)                               <L 487>
        }
        if (!var_282) {
            wp::adj_add(var_286, var_283, adj_286, adj_283, adj_287);
            wp::adj_neg(var_h, adj_h, adj_286);
        }
        wp::adj_sub(var_h, var_283, adj_h, adj_283, adj_284);
        // adj: if z_clamped >= (h - EPSILON) or z_clamped <= (-h + EPSILON):                 <L 486>
        wp::adj_min(var_h, var_280, adj_h, adj_280, adj_281);
        wp::adj_max(var_277, var_279, adj_277, adj_279, adj_280);
        wp::adj_extract(var_276, var_278, adj_276, adj_278, adj_279);
        wp::adj_neg(var_h, adj_h, adj_277);
        // adj: z_clamped = wp.min(h, wp.max(-h, hit_local[2]))                               <L 485>
        wp::adj_add(var_ray_origin, var_275, adj_ray_origin, adj_275, adj_276);
        wp::adj_mul(var_272, var_ray_direction, adj_272, adj_ray_direction, adj_275);
        // adj: hit_local = ray_origin + t_hit * ray_direction                                <L 484>
    }
    // adj: if t_hit >= 0.0:                                                                  <L 483>
    wp::adj_where(var_270, var_271, var_0, adj_270, adj_271, adj_0, adj_272);
    if (var_270) {
        wp::adj_copy(var_268, adj_268, adj_271);
        // adj: t_hit = min_t                                                                 <L 481>
    }
    // adj: if min_t < 1.0e9:                                                                 <L 480>
    wp::adj_where(var_208, var_265, var_204, adj_208, adj_265, adj_204, adj_268);
    if (var_208) {
        wp::adj_where(var_245, var_257, var_230, adj_245, adj_257, adj_230, adj_267);
        wp::adj_where(var_245, var_251, var_224, adj_245, adj_251, adj_224, adj_266);
        wp::adj_where(var_245, var_264, var_238, adj_245, adj_264, adj_238, adj_265);
        if (var_245) {
            wp::adj_where(var_262, var_263, var_238, adj_262, adj_263, adj_238, adj_264);
            if (var_262) {
                wp::adj_min(var_238, var_243, adj_238, adj_243, adj_263);
                // adj: min_t = wp.min(min_t, t_bot)                                          <L 478>
            }
            wp::adj_mul(var_r, var_r, adj_r, adj_r, adj_261);
            wp::adj_add(var_258, var_259, adj_258, adj_259, adj_260);
            wp::adj_mul(var_257, var_257, adj_257, adj_257, adj_259);
            wp::adj_mul(var_251, var_251, adj_251, adj_251, adj_258);
            // adj: if x * x + y * y <= r * r:                                                <L 477>
            wp::adj_add(var_253, var_256, adj_253, adj_256, adj_257);
            wp::adj_mul(var_243, var_255, adj_243, adj_255, adj_256);
            wp::adj_extract(var_ray_direction, var_254, adj_ray_direction, adj_254, adj_255);
            wp::adj_extract(var_ray_origin, var_252, adj_ray_origin, adj_252, adj_253);
            // adj: y = ray_origin[1] + t_bot * ray_direction[1]                              <L 476>
            wp::adj_add(var_247, var_250, adj_247, adj_250, adj_251);
            wp::adj_mul(var_243, var_249, adj_243, adj_249, adj_250);
            wp::adj_extract(var_ray_direction, var_248, adj_ray_direction, adj_248, adj_249);
            wp::adj_extract(var_ray_origin, var_246, adj_ray_origin, adj_246, adj_247);
            // adj: x = ray_origin[0] + t_bot * ray_direction[0]                              <L 475>
        }
        // adj: if t_bot >= 0.0:                                                              <L 474>
        wp::adj_mul(var_242, var_212, adj_242, adj_212, adj_243);
        wp::adj_sub(var_239, var_241, adj_239, adj_241, adj_242);
        wp::adj_extract(var_ray_origin, var_240, adj_ray_origin, adj_240, adj_241);
        wp::adj_neg(var_h, adj_h, adj_239);
        // adj: t_bot = (-h - ray_origin[2]) * inv_d_z                                        <L 473>
        wp::adj_where(var_218, var_237, var_204, adj_218, adj_237, adj_204, adj_238);
        if (var_218) {
            wp::adj_where(var_235, var_236, var_204, adj_235, adj_236, adj_204, adj_237);
            if (var_235) {
                wp::adj_min(var_204, var_216, adj_204, adj_216, adj_236);
                // adj: min_t = wp.min(min_t, t_top)                                          <L 470>
            }
            wp::adj_mul(var_r, var_r, adj_r, adj_r, adj_234);
            wp::adj_add(var_231, var_232, adj_231, adj_232, adj_233);
            wp::adj_mul(var_230, var_230, adj_230, adj_230, adj_232);
            wp::adj_mul(var_224, var_224, adj_224, adj_224, adj_231);
            // adj: if x * x + y * y <= r * r:                                                <L 469>
            wp::adj_add(var_226, var_229, adj_226, adj_229, adj_230);
            wp::adj_mul(var_216, var_228, adj_216, adj_228, adj_229);
            wp::adj_extract(var_ray_direction, var_227, adj_ray_direction, adj_227, adj_228);
            wp::adj_extract(var_ray_origin, var_225, adj_ray_origin, adj_225, adj_226);
            // adj: y = ray_origin[1] + t_top * ray_direction[1]                              <L 468>
            wp::adj_add(var_220, var_223, adj_220, adj_223, adj_224);
            wp::adj_mul(var_216, var_222, adj_216, adj_222, adj_223);
            wp::adj_extract(var_ray_direction, var_221, adj_ray_direction, adj_221, adj_222);
            wp::adj_extract(var_ray_origin, var_219, adj_ray_origin, adj_219, adj_220);
            // adj: x = ray_origin[0] + t_top * ray_direction[0]                              <L 467>
        }
        // adj: if t_top >= 0.0:                                                              <L 466>
        wp::adj_mul(var_215, var_212, adj_215, adj_212, adj_216);
        wp::adj_sub(var_h, var_214, adj_h, adj_214, adj_215);
        wp::adj_extract(var_ray_origin, var_213, adj_ray_origin, adj_213, adj_214);
        // adj: t_top = (h - ray_origin[2]) * inv_d_z                                         <L 465>
        wp::adj_div(var_209, var_211, var_212, adj_209, adj_211, adj_212);
        wp::adj_extract(var_ray_direction, var_210, adj_ray_direction, adj_210, adj_211);
        // adj: inv_d_z = 1.0 / ray_direction[2]                                              <L 463>
    }
    wp::adj_abs(var_206, adj_206, adj_207);
    wp::adj_extract(var_ray_direction, var_205, adj_ray_direction, adj_205, adj_206);
    // adj: if wp.abs(ray_direction[2]) > MINVAL:                                             <L 462>
    wp::adj_where(var_129, var_203, var_128, adj_129, adj_203, adj_128, adj_204);
    if (var_129) {
        wp::adj_where(var_155, var_202, var_128, adj_155, adj_202, adj_128, adj_203);
        if (var_155) {
            wp::adj_where(var_186, var_201, var_128, adj_186, adj_201, adj_128, adj_202);
            if (var_186) {
                wp::adj_where(var_195, var_200, var_128, adj_195, adj_200, adj_128, adj_201);
                if (var_195) {
                    wp::adj_copy(var_188, adj_188, adj_200);
                    // adj: min_t = refined_t                                                 <L 459>
                }
                if (var_195) {
                    wp::adj_abs(var_194, adj_194, adj_198);
                }
                // adj: if refined_t >= 0.0 and wp.abs(refined_z) <= h:                       <L 458>
                wp::adj_add(var_190, var_193, adj_190, adj_193, adj_194);
                wp::adj_mul(var_188, var_192, adj_188, adj_192, adj_193);
                wp::adj_extract(var_ray_direction, var_191, adj_ray_direction, adj_191, adj_192);
                wp::adj_extract(var_ray_origin, var_189, adj_ray_origin, adj_189, adj_190);
                // adj: refined_z = ray_origin[2] + refined_t * ray_direction[2]              <L 457>
                wp::adj_sub(var_128, var_187, adj_128, adj_187, adj_188);
                wp::adj_div(var_165, var_184, var_187, adj_165, adj_184, adj_187);
                // adj: refined_t = min_t - residual / derivative                             <L 456>
            }
            wp::adj_abs(var_184, adj_184, adj_185);
            // adj: if wp.abs(derivative) > MINVAL:                                           <L 455>
            wp::adj_add(var_177, var_183, adj_177, adj_183, adj_184);
            // adj: derivative = radial_derivative + axial_derivative                         <L 454>
            wp::adj_div(var_182, var_158, var_183, adj_182, adj_158, adj_183);
            wp::adj_mul(var_179, var_181, adj_179, adj_181, adj_182);
            wp::adj_extract(var_ray_direction, var_180, adj_ray_direction, adj_180, adj_181);
            wp::adj_extract(var_135, var_178, adj_135, adj_178, adj_179);
            // adj: axial_derivative = hit_side[2] * ray_direction[2] / circle_side           <L 453>
            wp::adj_div(var_176, var_147, var_177, adj_176, adj_147, adj_177);
            wp::adj_add(var_170, var_175, adj_170, adj_175, adj_176);
            wp::adj_mul(var_172, var_174, adj_172, adj_174, adj_175);
            wp::adj_extract(var_ray_direction, var_173, adj_ray_direction, adj_173, adj_174);
            wp::adj_extract(var_135, var_171, adj_135, adj_171, adj_172);
            wp::adj_mul(var_167, var_169, adj_167, adj_169, adj_170);
            wp::adj_extract(var_ray_direction, var_168, adj_ray_direction, adj_168, adj_169);
            wp::adj_extract(var_135, var_166, adj_135, adj_166, adj_167);
            // adj: radial_derivative = (hit_side[0] * ray_direction[0] + hit_side[1] * ray_direction[1]) / radial_side  <L 452>
            wp::adj_add(var_164, var_162, adj_164, adj_162, adj_165);
            wp::adj_sub(var_163, var_158, adj_163, adj_158, adj_164);
            wp::adj_sub(var_147, var_r, adj_147, adj_r, adj_163);
            // adj: residual = radial_side - r - circle_side + end_radial_offset              <L 451>
            wp::adj_sqrt(var_161, var_162, adj_161, adj_162);
            wp::adj_sub(var_159, var_160, adj_159, adj_160, adj_161);
            wp::adj_mul(var_h, var_h, adj_h, adj_h, adj_160);
            wp::adj_mul(var_barrel_radius, var_barrel_radius, adj_barrel_radius, adj_barrel_radius, adj_159);
            // adj: end_radial_offset = wp.sqrt(barrel_radius * barrel_radius - h * h)        <L 450>
            wp::adj_sqrt(var_154, var_158, adj_154, adj_158);
            // adj: circle_side = wp.sqrt(circle_sq)                                          <L 449>
        }
        if (var_155) {
        }
        // adj: if radial_side > MINVAL and circle_sq > MINVAL:                               <L 448>
        wp::adj_sub(var_148, var_153, adj_148, adj_153, adj_154);
        wp::adj_mul(var_150, var_152, adj_150, adj_152, adj_153);
        wp::adj_extract(var_135, var_151, adj_135, adj_151, adj_152);
        wp::adj_extract(var_135, var_149, adj_135, adj_149, adj_150);
        wp::adj_mul(var_barrel_radius, var_barrel_radius, adj_barrel_radius, adj_barrel_radius, adj_148);
        // adj: circle_sq = barrel_radius * barrel_radius - hit_side[2] * hit_side[2]         <L 447>
        wp::adj_sqrt(var_146, var_147, adj_146, adj_147);
        wp::adj_add(var_140, var_145, adj_140, adj_145, adj_146);
        wp::adj_mul(var_142, var_144, adj_142, adj_144, adj_145);
        wp::adj_extract(var_135, var_143, adj_135, adj_143, adj_144);
        wp::adj_extract(var_135, var_141, adj_135, adj_141, adj_142);
        wp::adj_mul(var_137, var_139, adj_137, adj_139, adj_140);
        wp::adj_extract(var_135, var_138, adj_135, adj_138, adj_139);
        wp::adj_extract(var_135, var_136, adj_135, adj_136, adj_137);
        // adj: radial_side = wp.sqrt(hit_side[0] * hit_side[0] + hit_side[1] * hit_side[1])  <L 446>
        wp::adj_add(var_ray_origin, var_134, adj_ray_origin, adj_134, adj_135);
        wp::adj_mul(var_128, var_ray_direction, adj_128, adj_ray_direction, adj_134);
        // adj: hit_side = ray_origin + min_t * ray_direction                                 <L 445>
    }
    if (var_129) {
    }
    // adj: if barrel_radius > 0.0 and min_t < 1.0e10:                                        <L 444>
    wp::adj_where(var_42, var_127, var_3, adj_42, adj_127, adj_3, adj_128);
    if (var_42) {
        wp::adj_where(var_89, var_126, var_3, adj_89, adj_126, adj_3, adj_127);
        if (var_89) {
            wp::adj_where(var_120, var_125, var_3, adj_120, adj_125, adj_3, adj_126);
            if (var_120) {
                wp::adj_copy(var_118, adj_118, adj_125);
                // adj: min_t = t_side                                                        <L 440>
            }
            if (var_120) {
                wp::adj_abs(var_119, adj_119, adj_123);
            }
            // adj: if t_side >= 0.0 and wp.abs(z_side) <= h:                                 <L 439>
            wp::adj_where(var_104, var_117, var_103, adj_104, adj_117, adj_103, adj_119);
            wp::adj_where(var_104, var_111, var_97, adj_104, adj_111, adj_97, adj_118);
            if (var_104) {
                wp::adj_add(var_113, var_116, adj_113, adj_116, adj_117);
                wp::adj_mul(var_111, var_115, adj_111, adj_115, adj_116);
                wp::adj_extract(var_ray_direction, var_114, adj_ray_direction, adj_114, adj_115);
                wp::adj_extract(var_ray_origin, var_112, adj_ray_origin, adj_112, adj_113);
                // adj: z_side = ray_origin[2] + t_side * ray_direction[2]                    <L 438>
                wp::adj_mul(var_110, var_94, adj_110, adj_94, adj_111);
                wp::adj_add(var_109, var_90, adj_109, adj_90, adj_110);
                wp::adj_neg(var_62, adj_62, adj_109);
                // adj: t_side = (-b_side + sqrt_delta_side) * inv_2a_side                    <L 437>
            }
            if (!var_104) {
                wp::adj_abs(var_103, adj_103, adj_107);
            }
            // adj: if t_side < 0.0 or wp.abs(z_side) > h:                                    <L 436>
            wp::adj_add(var_99, var_102, adj_99, adj_102, adj_103);
            wp::adj_mul(var_97, var_101, adj_97, adj_101, adj_102);
            wp::adj_extract(var_ray_direction, var_100, adj_ray_direction, adj_100, adj_101);
            wp::adj_extract(var_ray_origin, var_98, adj_ray_origin, adj_98, adj_99);
            // adj: z_side = ray_origin[2] + t_side * ray_direction[2]                        <L 435>
            wp::adj_mul(var_96, var_94, adj_96, adj_94, adj_97);
            wp::adj_sub(var_95, var_90, adj_95, adj_90, adj_96);
            wp::adj_neg(var_62, adj_62, adj_95);
            // adj: t_side = (-b_side - sqrt_delta_side) * inv_2a_side                        <L 434>
            wp::adj_div(var_91, var_93, var_94, adj_91, adj_93, adj_94);
            wp::adj_mul(var_92, var_41, adj_92, adj_41, adj_93);
            // adj: inv_2a_side = 1.0 / (2.0 * a_side)                                        <L 433>
            wp::adj_sqrt(var_87, var_90, adj_87, adj_90);
            // adj: sqrt_delta_side = wp.sqrt(delta_side)                                     <L 432>
        }
        // adj: if delta_side >= 0.0:                                                         <L 431>
        wp::adj_sub(var_83, var_86, adj_83, adj_86, adj_87);
        wp::adj_mul(var_85, var_82, adj_85, adj_82, adj_86);
        wp::adj_mul(var_84, var_41, adj_84, adj_41, adj_85);
        wp::adj_mul(var_62, var_62, adj_62, adj_62, adj_83);
        // adj: delta_side = b_side * b_side - 4.0 * a_side * c_side                          <L 430>
        wp::adj_sub(var_80, var_81, adj_80, adj_81, adj_82);
        wp::adj_mul(var_23, var_23, adj_23, adj_23, adj_81);
        // adj: - equatorial_radius * equatorial_radius                                       <L 428>
        wp::adj_add(var_73, var_79, adj_73, adj_79, adj_80);
        wp::adj_mul(var_76, var_78, adj_76, adj_78, adj_79);
        wp::adj_extract(var_ray_origin, var_77, adj_ray_origin, adj_77, adj_78);
        wp::adj_mul(var_22, var_75, adj_22, adj_75, adj_76);
        wp::adj_extract(var_ray_origin, var_74, adj_ray_origin, adj_74, adj_75);
        // adj: + axial_scale * ray_origin[2] * ray_origin[2]                                 <L 427>
        wp::adj_add(var_67, var_72, adj_67, adj_72, adj_73);
        wp::adj_mul(var_69, var_71, adj_69, adj_71, adj_72);
        wp::adj_extract(var_ray_origin, var_70, adj_ray_origin, adj_70, adj_71);
        wp::adj_extract(var_ray_origin, var_68, adj_ray_origin, adj_68, adj_69);
        // adj: + ray_origin[1] * ray_origin[1]                                               <L 426>
        wp::adj_mul(var_64, var_66, adj_64, adj_66, adj_67);
        wp::adj_extract(var_ray_origin, var_65, adj_ray_origin, adj_65, adj_66);
        wp::adj_extract(var_ray_origin, var_63, adj_ray_origin, adj_63, adj_64);
        // adj: ray_origin[0] * ray_origin[0]                                                 <L 425>
        // adj: c_side = (                                                                    <L 424>
        wp::adj_mul(var_43, var_61, adj_43, adj_61, adj_62);
        wp::adj_add(var_54, var_60, adj_54, adj_60, adj_61);
        wp::adj_mul(var_57, var_59, adj_57, adj_59, adj_60);
        wp::adj_extract(var_ray_direction, var_58, adj_ray_direction, adj_58, adj_59);
        wp::adj_mul(var_22, var_56, adj_22, adj_56, adj_57);
        wp::adj_extract(var_ray_origin, var_55, adj_ray_origin, adj_55, adj_56);
        // adj: + axial_scale * ray_origin[2] * ray_direction[2]                              <L 422>
        wp::adj_add(var_48, var_53, adj_48, adj_53, adj_54);
        wp::adj_mul(var_50, var_52, adj_50, adj_52, adj_53);
        wp::adj_extract(var_ray_direction, var_51, adj_ray_direction, adj_51, adj_52);
        wp::adj_extract(var_ray_origin, var_49, adj_ray_origin, adj_49, adj_50);
        // adj: + ray_origin[1] * ray_direction[1]                                            <L 421>
        wp::adj_mul(var_45, var_47, adj_45, adj_47, adj_48);
        wp::adj_extract(var_ray_direction, var_46, adj_ray_direction, adj_46, adj_47);
        wp::adj_extract(var_ray_origin, var_44, adj_ray_origin, adj_44, adj_45);
        // adj: ray_origin[0] * ray_direction[0]                                              <L 420>
        // adj: b_side = 2.0 * (                                                              <L 419>
    }
    // adj: if a_side > MINVAL:                                                               <L 418>
    wp::adj_add(var_34, var_40, adj_34, adj_40, adj_41);
    wp::adj_mul(var_37, var_39, adj_37, adj_39, adj_40);
    wp::adj_extract(var_ray_direction, var_38, adj_ray_direction, adj_38, adj_39);
    wp::adj_mul(var_22, var_36, adj_22, adj_36, adj_37);
    wp::adj_extract(var_ray_direction, var_35, adj_ray_direction, adj_35, adj_36);
    // adj: + axial_scale * ray_direction[2] * ray_direction[2]                               <L 416>
    wp::adj_add(var_28, var_33, adj_28, adj_33, adj_34);
    wp::adj_mul(var_30, var_32, adj_30, adj_32, adj_33);
    wp::adj_extract(var_ray_direction, var_31, adj_ray_direction, adj_31, adj_32);
    wp::adj_extract(var_ray_direction, var_29, adj_ray_direction, adj_29, adj_30);
    // adj: + ray_direction[1] * ray_direction[1]                                             <L 415>
    wp::adj_mul(var_25, var_27, adj_25, adj_27, adj_28);
    wp::adj_extract(var_ray_direction, var_26, adj_ray_direction, adj_26, adj_27);
    wp::adj_extract(var_ray_direction, var_24, adj_ray_direction, adj_24, adj_25);
    // adj: ray_direction[0] * ray_direction[0]                                               <L 414>
    // adj: a_side = (                                                                        <L 413>
    wp::adj_where(var_6, var_16, var_5, adj_6, adj_16, adj_5, adj_23);
    wp::adj_where(var_6, var_21, var_4, adj_6, adj_21, adj_4, adj_22);
    if (var_6) {
        wp::adj_div(var_19, var_20, var_21, adj_19, adj_20, adj_21);
        wp::adj_mul(var_h, var_h, adj_h, adj_h, adj_20);
        wp::adj_sub(var_17, var_18, adj_17, adj_18, adj_19);
        wp::adj_mul(var_r, var_r, adj_r, adj_r, adj_18);
        wp::adj_mul(var_16, var_16, adj_16, adj_16, adj_17);
        // adj: axial_scale = (equatorial_radius * equatorial_radius - r * r) / (h * h)       <L 409>
        wp::adj_sub(var_11, var_15, adj_11, adj_15, adj_16);
        wp::adj_sqrt(var_14, var_15, adj_14, adj_15);
        wp::adj_sub(var_12, var_13, adj_12, adj_13, adj_14);
        wp::adj_mul(var_h, var_h, adj_h, adj_h, adj_13);
        wp::adj_mul(var_barrel_radius, var_barrel_radius, adj_barrel_radius, adj_barrel_radius, adj_12);
        wp::adj_add(var_r, var_barrel_radius, adj_r, adj_barrel_radius, adj_11);
        // adj: equatorial_radius = r + barrel_radius - wp.sqrt(barrel_radius * barrel_radius - h * h)  <L 408>
    }
    if (var_6) {
    }
    // adj: if barrel_radius > 0.0 and h > MINVAL:                                            <L 407>
    wp::adj_copy(var_r, adj_r, adj_5);
    // adj: equatorial_radius = r                                                             <L 405>
    // adj: axial_scale = 0.0                                                                 <L 404>
    // adj: min_t = 1.0e10                                                                    <L 403>
    wp::adj_vec_t(var_1, adj_1, adj_2);
    // adj: normal = wp.vec3(0.0)                                                             <L 402>
    // adj: t_hit = -1.0                                                                      <L 401>
    // adj: def ray_intersect_cylinder(                                                       <L 382>
    return;
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/geometry/raycast.py:503
static void adj_ray_intersect_cone_0(
    wp::vec_t<3, wp::float32> var_ray_origin,
    wp::vec_t<3, wp::float32> var_ray_direction,
    wp::float32 var_radius,
    wp::float32 var_half_height,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & adj_ray_origin,
    wp::vec_t<3, wp::float32> & adj_ray_direction,
    wp::float32 & adj_radius,
    wp::float32 & adj_half_height,
    wp::float32 & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
    //---------
    // primal vars
    const wp::float32 var_0 = -1.0;
    const wp::float32 var_1 = 0.0;
    wp::vec_t<3, wp::float32> var_2;
    wp::float32 var_3;
    const wp::float32 var_4 = 1e-15;
    bool var_5;
    const wp::float32 var_6 = 0.0;
    bool var_7;
    const wp::float32 var_8 = 0.0;
    const wp::float32 var_9 = 0.0;
    wp::vec_t<3, wp::float32> var_10;
    const wp::float32 var_11 = 0.0;
    const wp::float32 var_12 = 0.0;
    wp::float32 var_13;
    wp::vec_t<3, wp::float32> var_14;
    const wp::float32 var_15 = 0.0;
    wp::float32 var_16;
    wp::vec_t<3, wp::float32> var_17;
    wp::vec_t<3, wp::float32> var_18;
    wp::vec_t<3, wp::float32> var_19;
    wp::float32 var_20;
    wp::float32 var_21;
    wp::float32 var_22;
    wp::float32 var_23;
    wp::float32 var_24;
    wp::float32 var_25;
    const wp::float32 var_26 = 0.0;
    bool var_27;
    wp::vec_t<3, wp::float32> var_28;
    wp::vec_t<3, wp::float32> var_29;
    wp::vec_t<3, wp::float32> var_30;
    wp::float32 var_31;
    wp::float32 var_32;
    wp::float32 var_33;
    wp::float32 var_34;
    bool var_35;
    wp::float32 var_36;
    bool var_37;
    wp::float32 var_38;
    wp::float32 var_39;
    wp::float32 var_40;
    wp::float32 var_41;
    const wp::float32 var_42 = 0.0;
    bool var_43;
    wp::float32 var_44;
    bool var_45;
    wp::float32 var_46;
    wp::float32 var_47;
    wp::vec_t<3, wp::float32> var_48;
    wp::vec_t<3, wp::float32> var_49;
    wp::float32 var_50;
    wp::float32 var_51;
    bool var_52;
    wp::float32 var_53;
    wp::float32 var_54;
    wp::float32 var_55;
    wp::float32 var_56;
    wp::float32 var_57;
    const wp::float32 var_58 = 0.0;
    bool var_59;
    wp::float32 var_60;
    wp::float32 var_61;
    wp::float32 var_62;
    wp::float32 var_63;
    wp::float32 var_64;
    wp::float32 var_65;
    wp::float32 var_66;
    wp::float32 var_67;
    wp::float32 var_68;
    wp::float32 var_69;
    wp::float32 var_70;
    wp::float32 var_71;
    wp::float32 var_72;
    wp::float32 var_73;
    const wp::float32 var_74 = 1.0;
    wp::float32 var_75;
    wp::float32 var_76;
    wp::float32 var_77;
    wp::float32 var_78;
    wp::float32 var_79;
    wp::float32 var_80;
    wp::float32 var_81;
    wp::float32 var_82;
    wp::float32 var_83;
    wp::float32 var_84;
    const wp::float32 var_85 = 2.0;
    wp::float32 var_86;
    wp::float32 var_87;
    wp::float32 var_88;
    wp::float32 var_89;
    wp::float32 var_90;
    wp::float32 var_91;
    wp::float32 var_92;
    wp::float32 var_93;
    bool var_94;
    const wp::float32 var_95 = 0.0;
    bool var_96;
    wp::float32 var_97;
    bool var_98;
    wp::float32 var_99;
    wp::float32 var_100;
    wp::float32 var_101;
    wp::float32 var_102;
    wp::float32 var_103;
    wp::float32 var_104;
    bool var_105;
    const wp::float32 var_106 = 0.0;
    bool var_107;
    bool var_108;
    wp::float32 var_109;
    wp::float32 var_110;
    wp::float32 var_111;
    wp::float32 var_112;
    wp::float32 var_113;
    wp::float32 var_114;
    const wp::float32 var_115 = 0.0;
    bool var_116;
    wp::vec_t<3, wp::float32> var_117;
    wp::vec_t<3, wp::float32> var_118;
    const wp::int32 var_119 = 2;
    wp::float32 var_120;
    wp::float32 var_121;
    wp::float32 var_122;
    const wp::float32 var_123 = 1e-06;
    bool var_124;
    const wp::float32 var_125 = 0.0;
    const wp::float32 var_126 = 0.0;
    const wp::float32 var_127 = 1.0;
    wp::vec_t<3, wp::float32> var_128;
    const wp::int32 var_129 = 2;
    wp::float32 var_130;
    wp::float32 var_131;
    wp::float32 var_132;
    bool var_133;
    const wp::float32 var_134 = 0.0;
    const wp::float32 var_135 = 0.0;
    const wp::float32 var_136 = -1.0;
    wp::vec_t<3, wp::float32> var_137;
    const wp::int32 var_138 = 0;
    wp::float32 var_139;
    const wp::int32 var_140 = 0;
    wp::float32 var_141;
    wp::float32 var_142;
    const wp::int32 var_143 = 1;
    wp::float32 var_144;
    const wp::int32 var_145 = 1;
    wp::float32 var_146;
    wp::float32 var_147;
    wp::float32 var_148;
    wp::float32 var_149;
    bool var_150;
    const wp::float32 var_151 = 0.0;
    const wp::float32 var_152 = 0.0;
    const wp::float32 var_153 = 1.0;
    wp::vec_t<3, wp::float32> var_154;
    const wp::float32 var_155 = 2.0;
    wp::float32 var_156;
    wp::float32 var_157;
    wp::float32 var_158;
    wp::float32 var_159;
    const wp::int32 var_160 = 0;
    wp::float32 var_161;
    const wp::int32 var_162 = 1;
    wp::float32 var_163;
    wp::float32 var_164;
    wp::vec_t<3, wp::float32> var_165;
    wp::vec_t<3, wp::float32> var_166;
    wp::vec_t<3, wp::float32> var_167;
    wp::vec_t<3, wp::float32> var_168;
    wp::vec_t<3, wp::float32> var_169;
    wp::vec_t<3, wp::float32> var_170;
    wp::vec_t<3, wp::float32> var_171;
    //---------
    // dual vars
    wp::float32 adj_0 = {};
    wp::float32 adj_1 = {};
    wp::vec_t<3, wp::float32> adj_2 = {};
    wp::float32 adj_3 = {};
    wp::float32 adj_4 = {};
    bool adj_5 = {};
    wp::float32 adj_6 = {};
    bool adj_7 = {};
    wp::float32 adj_8 = {};
    wp::float32 adj_9 = {};
    wp::vec_t<3, wp::float32> adj_10 = {};
    wp::float32 adj_11 = {};
    wp::float32 adj_12 = {};
    wp::float32 adj_13 = {};
    wp::vec_t<3, wp::float32> adj_14 = {};
    wp::float32 adj_15 = {};
    wp::float32 adj_16 = {};
    wp::vec_t<3, wp::float32> adj_17 = {};
    wp::vec_t<3, wp::float32> adj_18 = {};
    wp::vec_t<3, wp::float32> adj_19 = {};
    wp::float32 adj_20 = {};
    wp::float32 adj_21 = {};
    wp::float32 adj_22 = {};
    wp::float32 adj_23 = {};
    wp::float32 adj_24 = {};
    wp::float32 adj_25 = {};
    wp::float32 adj_26 = {};
    bool adj_27 = {};
    wp::vec_t<3, wp::float32> adj_28 = {};
    wp::vec_t<3, wp::float32> adj_29 = {};
    wp::vec_t<3, wp::float32> adj_30 = {};
    wp::float32 adj_31 = {};
    wp::float32 adj_32 = {};
    wp::float32 adj_33 = {};
    wp::float32 adj_34 = {};
    bool adj_35 = {};
    wp::float32 adj_36 = {};
    bool adj_37 = {};
    wp::float32 adj_38 = {};
    wp::float32 adj_39 = {};
    wp::float32 adj_40 = {};
    wp::float32 adj_41 = {};
    wp::float32 adj_42 = {};
    bool adj_43 = {};
    wp::float32 adj_44 = {};
    bool adj_45 = {};
    wp::float32 adj_46 = {};
    wp::float32 adj_47 = {};
    wp::vec_t<3, wp::float32> adj_48 = {};
    wp::vec_t<3, wp::float32> adj_49 = {};
    wp::float32 adj_50 = {};
    wp::float32 adj_51 = {};
    bool adj_52 = {};
    wp::float32 adj_53 = {};
    wp::float32 adj_54 = {};
    wp::float32 adj_55 = {};
    wp::float32 adj_56 = {};
    wp::float32 adj_57 = {};
    wp::float32 adj_58 = {};
    bool adj_59 = {};
    wp::float32 adj_60 = {};
    wp::float32 adj_61 = {};
    wp::float32 adj_62 = {};
    wp::float32 adj_63 = {};
    wp::float32 adj_64 = {};
    wp::float32 adj_65 = {};
    wp::float32 adj_66 = {};
    wp::float32 adj_67 = {};
    wp::float32 adj_68 = {};
    wp::float32 adj_69 = {};
    wp::float32 adj_70 = {};
    wp::float32 adj_71 = {};
    wp::float32 adj_72 = {};
    wp::float32 adj_73 = {};
    wp::float32 adj_74 = {};
    wp::float32 adj_75 = {};
    wp::float32 adj_76 = {};
    wp::float32 adj_77 = {};
    wp::float32 adj_78 = {};
    wp::float32 adj_79 = {};
    wp::float32 adj_80 = {};
    wp::float32 adj_81 = {};
    wp::float32 adj_82 = {};
    wp::float32 adj_83 = {};
    wp::float32 adj_84 = {};
    wp::float32 adj_85 = {};
    wp::float32 adj_86 = {};
    wp::float32 adj_87 = {};
    wp::float32 adj_88 = {};
    wp::float32 adj_89 = {};
    wp::float32 adj_90 = {};
    wp::float32 adj_91 = {};
    wp::float32 adj_92 = {};
    wp::float32 adj_93 = {};
    bool adj_94 = {};
    wp::float32 adj_95 = {};
    bool adj_96 = {};
    wp::float32 adj_97 = {};
    bool adj_98 = {};
    wp::float32 adj_99 = {};
    wp::float32 adj_100 = {};
    wp::float32 adj_101 = {};
    wp::float32 adj_102 = {};
    wp::float32 adj_103 = {};
    wp::float32 adj_104 = {};
    bool adj_105 = {};
    wp::float32 adj_106 = {};
    bool adj_107 = {};
    bool adj_108 = {};
    wp::float32 adj_109 = {};
    wp::float32 adj_110 = {};
    wp::float32 adj_111 = {};
    wp::float32 adj_112 = {};
    wp::float32 adj_113 = {};
    wp::float32 adj_114 = {};
    wp::float32 adj_115 = {};
    bool adj_116 = {};
    wp::vec_t<3, wp::float32> adj_117 = {};
    wp::vec_t<3, wp::float32> adj_118 = {};
    wp::int32 adj_119 = {};
    wp::float32 adj_120 = {};
    wp::float32 adj_121 = {};
    wp::float32 adj_122 = {};
    wp::float32 adj_123 = {};
    bool adj_124 = {};
    wp::float32 adj_125 = {};
    wp::float32 adj_126 = {};
    wp::float32 adj_127 = {};
    wp::vec_t<3, wp::float32> adj_128 = {};
    wp::int32 adj_129 = {};
    wp::float32 adj_130 = {};
    wp::float32 adj_131 = {};
    wp::float32 adj_132 = {};
    bool adj_133 = {};
    wp::float32 adj_134 = {};
    wp::float32 adj_135 = {};
    wp::float32 adj_136 = {};
    wp::vec_t<3, wp::float32> adj_137 = {};
    wp::int32 adj_138 = {};
    wp::float32 adj_139 = {};
    wp::int32 adj_140 = {};
    wp::float32 adj_141 = {};
    wp::float32 adj_142 = {};
    wp::int32 adj_143 = {};
    wp::float32 adj_144 = {};
    wp::int32 adj_145 = {};
    wp::float32 adj_146 = {};
    wp::float32 adj_147 = {};
    wp::float32 adj_148 = {};
    wp::float32 adj_149 = {};
    bool adj_150 = {};
    wp::float32 adj_151 = {};
    wp::float32 adj_152 = {};
    wp::float32 adj_153 = {};
    wp::vec_t<3, wp::float32> adj_154 = {};
    wp::float32 adj_155 = {};
    wp::float32 adj_156 = {};
    wp::float32 adj_157 = {};
    wp::float32 adj_158 = {};
    wp::float32 adj_159 = {};
    wp::int32 adj_160 = {};
    wp::float32 adj_161 = {};
    wp::int32 adj_162 = {};
    wp::float32 adj_163 = {};
    wp::float32 adj_164 = {};
    wp::vec_t<3, wp::float32> adj_165 = {};
    wp::vec_t<3, wp::float32> adj_166 = {};
    wp::vec_t<3, wp::float32> adj_167 = {};
    wp::vec_t<3, wp::float32> adj_168 = {};
    wp::vec_t<3, wp::float32> adj_169 = {};
    wp::vec_t<3, wp::float32> adj_170 = {};
    wp::vec_t<3, wp::float32> adj_171 = {};
    //---------
    // forward
    // def ray_intersect_cone(                                                                <L 504>
    // t_hit = -1.0                                                                           <L 520>
    // normal = wp.vec3(0.0)                                                                  <L 521>
    var_2 = wp::vec_t<3, wp::float32>(var_1);
    // if wp.abs(half_height) < MINVAL:                                                       <L 523>
    var_3 = wp::abs(var_half_height);
    var_5 = (var_3 < var_4);
    if (var_5) {
        // return t_hit, normal                                                               <L 524>
        ret_0 = var_0;
        ret_1 = var_2;
        goto label0;
    }
    // if radius <= 0.0:                                                                      <L 526>
    var_7 = (var_radius <= var_6);
    if (var_7) {
        // return t_hit, normal                                                               <L 527>
        ret_0 = var_0;
        ret_1 = var_2;
        goto label1;
    }
    // pa = wp.vec3(0.0, 0.0, half_height)  # tip at +half_height                             <L 531>
    var_10 = wp::vec_t<3, wp::float32>(var_8, var_9, var_half_height);
    // pb = wp.vec3(0.0, 0.0, -half_height)  # base center at -half_height                    <L 532>
    var_13 = wp::neg(var_half_height);
    var_14 = wp::vec_t<3, wp::float32>(var_11, var_12, var_13);
    // ra = 0.0  # radius at tip                                                              <L 533>
    // rb = radius  # radius at base                                                          <L 534>
    var_16 = wp::copy(var_radius);
    // ba = pb - pa                                                                           <L 536>
    var_17 = wp::sub(var_14, var_10);
    // oa = ray_origin - pa                                                                   <L 537>
    var_18 = wp::sub(var_ray_origin, var_10);
    // ob = ray_origin - pb                                                                   <L 538>
    var_19 = wp::sub(var_ray_origin, var_14);
    // m0 = wp.dot(ba, ba)                                                                    <L 539>
    var_20 = wp::dot(var_17, var_17);
    // m1 = wp.dot(oa, ba)                                                                    <L 540>
    var_21 = wp::dot(var_18, var_17);
    // m2 = wp.dot(ray_direction, ba)                                                         <L 541>
    var_22 = wp::dot(var_ray_direction, var_17);
    // m3 = wp.dot(ray_direction, oa)                                                         <L 542>
    var_23 = wp::dot(var_ray_direction, var_18);
    // m5 = wp.dot(oa, oa)                                                                    <L 543>
    var_24 = wp::dot(var_18, var_18);
    // m9 = wp.dot(ob, ba)                                                                    <L 544>
    var_25 = wp::dot(var_19, var_17);
    // if m1 < 0.0:                                                                           <L 547>
    var_27 = (var_21 < var_26);
    if (var_27) {
        // temp = oa * m2 - ray_direction * m1                                                <L 548>
        var_28 = wp::mul(var_18, var_22);
        var_29 = wp::mul(var_ray_direction, var_21);
        var_30 = wp::sub(var_28, var_29);
        // if wp.dot(temp, temp) < (ra * ra * m2 * m2):                                       <L 549>
        var_31 = wp::dot(var_30, var_30);
        var_32 = wp::mul(var_15, var_15);
        var_33 = wp::mul(var_32, var_22);
        var_34 = wp::mul(var_33, var_22);
        var_35 = (var_31 < var_34);
        if (var_35) {
            // if wp.abs(m2) > MINVAL:                                                        <L 550>
            var_36 = wp::abs(var_22);
            var_37 = (var_36 > var_4);
            if (var_37) {
                // t_hit = -m1 / m2                                                           <L 551>
                var_38 = wp::neg(var_21);
                var_39 = wp::div(var_38, var_22);
            }
            var_40 = wp::where(var_37, var_39, var_0);
        }
        var_41 = wp::where(var_35, var_40, var_0);
    }
    if (!var_27) {
        // elif m9 > 0.0:                                                                     <L 552>
        var_43 = (var_25 > var_42);
        if (var_43) {
            // if wp.abs(m2) > MINVAL:                                                        <L 553>
            var_44 = wp::abs(var_22);
            var_45 = (var_44 > var_4);
            if (var_45) {
                // t = -m9 / m2                                                               <L 554>
                var_46 = wp::neg(var_25);
                var_47 = wp::div(var_46, var_22);
                // temp_ob = ob + ray_direction * t                                           <L 555>
                var_48 = wp::mul(var_ray_direction, var_47);
                var_49 = wp::add(var_19, var_48);
                // if wp.dot(temp_ob, temp_ob) < (rb * rb):                                   <L 556>
                var_50 = wp::dot(var_49, var_49);
                var_51 = wp::mul(var_16, var_16);
                var_52 = (var_50 < var_51);
                if (var_52) {
                    // t_hit = t                                                              <L 557>
                    var_53 = wp::copy(var_47);
                }
                var_54 = wp::where(var_52, var_53, var_0);
            }
            var_55 = wp::where(var_45, var_54, var_0);
        }
        var_56 = wp::where(var_43, var_55, var_0);
    }
    var_57 = wp::where(var_27, var_41, var_56);
    // if t_hit < 0.0:                                                                        <L 559>
    var_59 = (var_57 < var_58);
    if (var_59) {
        // rr = ra - rb                                                                       <L 561>
        var_60 = wp::sub(var_15, var_16);
        // hy = m0 + rr * rr                                                                  <L 562>
        var_61 = wp::mul(var_60, var_60);
        var_62 = wp::add(var_20, var_61);
        // k2 = m0 * m0 - m2 * m2 * hy                                                        <L 563>
        var_63 = wp::mul(var_20, var_20);
        var_64 = wp::mul(var_22, var_22);
        var_65 = wp::mul(var_64, var_62);
        var_66 = wp::sub(var_63, var_65);
        // k1 = m0 * m0 * m3 - m1 * m2 * hy + m0 * ra * (rr * m2 * 1.0)                       <L 564>
        var_67 = wp::mul(var_20, var_20);
        var_68 = wp::mul(var_67, var_23);
        var_69 = wp::mul(var_21, var_22);
        var_70 = wp::mul(var_69, var_62);
        var_71 = wp::sub(var_68, var_70);
        var_72 = wp::mul(var_20, var_15);
        var_73 = wp::mul(var_60, var_22);
        var_75 = wp::mul(var_73, var_74);
        var_76 = wp::mul(var_72, var_75);
        var_77 = wp::add(var_71, var_76);
        // k0 = m0 * m0 * m5 - m1 * m1 * hy + m0 * ra * (rr * m1 * 2.0 - m0 * ra)             <L 565>
        var_78 = wp::mul(var_20, var_20);
        var_79 = wp::mul(var_78, var_24);
        var_80 = wp::mul(var_21, var_21);
        var_81 = wp::mul(var_80, var_62);
        var_82 = wp::sub(var_79, var_81);
        var_83 = wp::mul(var_20, var_15);
        var_84 = wp::mul(var_60, var_21);
        var_86 = wp::mul(var_84, var_85);
        var_87 = wp::mul(var_20, var_15);
        var_88 = wp::sub(var_86, var_87);
        var_89 = wp::mul(var_83, var_88);
        var_90 = wp::add(var_82, var_89);
        // h = k1 * k1 - k2 * k0                                                              <L 566>
        var_91 = wp::mul(var_77, var_77);
        var_92 = wp::mul(var_66, var_90);
        var_93 = wp::sub(var_91, var_92);
        // if h >= 0.0 and wp.abs(k2) >= MINVAL:                                              <L 568>
        var_96 = (var_93 >= var_95);
        var_94 = var_96;
        if (var_94) {
            var_97 = wp::abs(var_66);
            var_98 = (var_97 >= var_4);
            var_94 = var_94 && var_98;
        }
        if (var_94) {
            // t = (-k1 - wp.sqrt(h)) / k2                                                    <L 569>
            var_99 = wp::neg(var_77);
            var_100 = wp::sqrt(var_93);
            var_101 = wp::sub(var_99, var_100);
            var_102 = wp::div(var_101, var_66);
            // y = m1 + t * m2                                                                <L 570>
            var_103 = wp::mul(var_102, var_22);
            var_104 = wp::add(var_21, var_103);
            // if y >= 0.0 and y <= m0:                                                       <L 571>
            var_107 = (var_104 >= var_106);
            var_105 = var_107;
            if (var_105) {
                var_108 = (var_104 <= var_20);
                var_105 = var_105 && var_108;
            }
            if (var_105) {
                // t_hit = t                                                                  <L 572>
                var_109 = wp::copy(var_102);
            }
            var_110 = wp::where(var_105, var_109, var_57);
        }
        var_111 = wp::where(var_94, var_110, var_57);
        var_112 = wp::where(var_94, var_102, var_47);
    }
    var_113 = wp::where(var_59, var_111, var_57);
    var_114 = wp::where(var_59, var_112, var_47);
    // if t_hit >= 0.0:                                                                       <L 574>
    var_116 = (var_113 >= var_115);
    if (var_116) {
        // hit_local = ray_origin + t_hit * ray_direction                                     <L 575>
        var_117 = wp::mul(var_113, var_ray_direction);
        var_118 = wp::add(var_ray_origin, var_117);
        // if wp.abs(hit_local[2] - half_height) <= EPSILON:                                  <L 576>
        var_120 = wp::extract(var_118, var_119);
        var_121 = wp::sub(var_120, var_half_height);
        var_122 = wp::abs(var_121);
        var_124 = (var_122 <= var_123);
        if (var_124) {
            // normal_local = wp.vec3(0.0, 0.0, 1.0)                                          <L 577>
            var_128 = wp::vec_t<3, wp::float32>(var_125, var_126, var_127);
        }
        if (!var_124) {
            // elif wp.abs(hit_local[2] + half_height) <= EPSILON:                            <L 578>
            var_130 = wp::extract(var_118, var_129);
            var_131 = wp::add(var_130, var_half_height);
            var_132 = wp::abs(var_131);
            var_133 = (var_132 <= var_123);
            if (var_133) {
                // normal_local = wp.vec3(0.0, 0.0, -1.0)                                     <L 579>
                var_137 = wp::vec_t<3, wp::float32>(var_134, var_135, var_136);
            }
            if (!var_133) {
                // radial_sq = hit_local[0] * hit_local[0] + hit_local[1] * hit_local[1]       <L 581>
                var_139 = wp::extract(var_118, var_138);
                var_141 = wp::extract(var_118, var_140);
                var_142 = wp::mul(var_139, var_141);
                var_144 = wp::extract(var_118, var_143);
                var_146 = wp::extract(var_118, var_145);
                var_147 = wp::mul(var_144, var_146);
                var_148 = wp::add(var_142, var_147);
                // radial = wp.sqrt(radial_sq)                                                <L 582>
                var_149 = wp::sqrt(var_148);
                // if radial <= EPSILON:                                                      <L 583>
                var_150 = (var_149 <= var_123);
                if (var_150) {
                    // normal_local = wp.vec3(0.0, 0.0, 1.0)                                  <L 584>
                    var_154 = wp::vec_t<3, wp::float32>(var_151, var_152, var_153);
                }
                if (!var_150) {
                    // denom = wp.max(2.0 * wp.abs(half_height), EPSILON)                     <L 586>
                    var_156 = wp::abs(var_half_height);
                    var_157 = wp::mul(var_155, var_156);
                    var_158 = wp::max(var_157, var_123);
                    // slope = radius / denom                                                 <L 587>
                    var_159 = wp::div(var_radius, var_158);
                    // normal_local = wp.normalize(wp.vec3(hit_local[0], hit_local[1], slope * radial))       <L 588>
                    var_161 = wp::extract(var_118, var_160);
                    var_163 = wp::extract(var_118, var_162);
                    var_164 = wp::mul(var_159, var_149);
                    var_165 = wp::vec_t<3, wp::float32>(var_161, var_163, var_164);
                    var_166 = wp::normalize(var_165);
                }
                var_167 = wp::where(var_150, var_154, var_166);
            }
            var_168 = wp::where(var_133, var_137, var_167);
        }
        var_169 = wp::where(var_124, var_128, var_168);
        // normal = wp.normalize(normal_local)                                                <L 589>
        var_170 = wp::normalize(var_169);
    }
    var_171 = wp::where(var_116, var_170, var_2);
    // return t_hit, normal                                                                   <L 591>
    ret_0 = var_113;
    ret_1 = var_171;
    goto label2;
    //---------
    // reverse
    label2:;
    adj_171 += adj_ret_1;
    adj_113 += adj_ret_0;
    // adj: return t_hit, normal                                                              <L 591>
    wp::adj_where(var_116, var_170, var_2, adj_116, adj_170, adj_2, adj_171);
    if (var_116) {
        wp::adj_normalize(var_169, var_170, adj_169, adj_170);
        // adj: normal = wp.normalize(normal_local)                                           <L 589>
        wp::adj_where(var_124, var_128, var_168, adj_124, adj_128, adj_168, adj_169);
        if (!var_124) {
            wp::adj_where(var_133, var_137, var_167, adj_133, adj_137, adj_167, adj_168);
            if (!var_133) {
                wp::adj_where(var_150, var_154, var_166, adj_150, adj_154, adj_166, adj_167);
                if (!var_150) {
                    wp::adj_normalize(var_165, var_166, adj_165, adj_166);
                    wp::adj_vec_t(var_161, var_163, var_164, adj_161, adj_163, adj_164, adj_165);
                    wp::adj_mul(var_159, var_149, adj_159, adj_149, adj_164);
                    wp::adj_extract(var_118, var_162, adj_118, adj_162, adj_163);
                    wp::adj_extract(var_118, var_160, adj_118, adj_160, adj_161);
                    // adj: normal_local = wp.normalize(wp.vec3(hit_local[0], hit_local[1], slope * radial))  <L 588>
                    wp::adj_div(var_radius, var_158, var_159, adj_radius, adj_158, adj_159);
                    // adj: slope = radius / denom                                            <L 587>
                    wp::adj_max(var_157, var_123, adj_157, adj_123, adj_158);
                    wp::adj_mul(var_155, var_156, adj_155, adj_156, adj_157);
                    wp::adj_abs(var_half_height, adj_half_height, adj_156);
                    // adj: denom = wp.max(2.0 * wp.abs(half_height), EPSILON)                <L 586>
                }
                if (var_150) {
                    wp::adj_vec_t(var_151, var_152, var_153, adj_151, adj_152, adj_153, adj_154);
                    // adj: normal_local = wp.vec3(0.0, 0.0, 1.0)                             <L 584>
                }
                // adj: if radial <= EPSILON:                                                 <L 583>
                wp::adj_sqrt(var_148, var_149, adj_148, adj_149);
                // adj: radial = wp.sqrt(radial_sq)                                           <L 582>
                wp::adj_add(var_142, var_147, adj_142, adj_147, adj_148);
                wp::adj_mul(var_144, var_146, adj_144, adj_146, adj_147);
                wp::adj_extract(var_118, var_145, adj_118, adj_145, adj_146);
                wp::adj_extract(var_118, var_143, adj_118, adj_143, adj_144);
                wp::adj_mul(var_139, var_141, adj_139, adj_141, adj_142);
                wp::adj_extract(var_118, var_140, adj_118, adj_140, adj_141);
                wp::adj_extract(var_118, var_138, adj_118, adj_138, adj_139);
                // adj: radial_sq = hit_local[0] * hit_local[0] + hit_local[1] * hit_local[1]  <L 581>
            }
            if (var_133) {
                wp::adj_vec_t(var_134, var_135, var_136, adj_134, adj_135, adj_136, adj_137);
                // adj: normal_local = wp.vec3(0.0, 0.0, -1.0)                                <L 579>
            }
            wp::adj_abs(var_131, adj_131, adj_132);
            wp::adj_add(var_130, var_half_height, adj_130, adj_half_height, adj_131);
            wp::adj_extract(var_118, var_129, adj_118, adj_129, adj_130);
            // adj: elif wp.abs(hit_local[2] + half_height) <= EPSILON:                       <L 578>
        }
        if (var_124) {
            wp::adj_vec_t(var_125, var_126, var_127, adj_125, adj_126, adj_127, adj_128);
            // adj: normal_local = wp.vec3(0.0, 0.0, 1.0)                                     <L 577>
        }
        wp::adj_abs(var_121, adj_121, adj_122);
        wp::adj_sub(var_120, var_half_height, adj_120, adj_half_height, adj_121);
        wp::adj_extract(var_118, var_119, adj_118, adj_119, adj_120);
        // adj: if wp.abs(hit_local[2] - half_height) <= EPSILON:                             <L 576>
        wp::adj_add(var_ray_origin, var_117, adj_ray_origin, adj_117, adj_118);
        wp::adj_mul(var_113, var_ray_direction, adj_113, adj_ray_direction, adj_117);
        // adj: hit_local = ray_origin + t_hit * ray_direction                                <L 575>
    }
    // adj: if t_hit >= 0.0:                                                                  <L 574>
    wp::adj_where(var_59, var_112, var_47, adj_59, adj_112, adj_47, adj_114);
    wp::adj_where(var_59, var_111, var_57, adj_59, adj_111, adj_57, adj_113);
    if (var_59) {
        wp::adj_where(var_94, var_102, var_47, adj_94, adj_102, adj_47, adj_112);
        wp::adj_where(var_94, var_110, var_57, adj_94, adj_110, adj_57, adj_111);
        if (var_94) {
            wp::adj_where(var_105, var_109, var_57, adj_105, adj_109, adj_57, adj_110);
            if (var_105) {
                wp::adj_copy(var_102, adj_102, adj_109);
                // adj: t_hit = t                                                             <L 572>
            }
            if (var_105) {
            }
            // adj: if y >= 0.0 and y <= m0:                                                  <L 571>
            wp::adj_add(var_21, var_103, adj_21, adj_103, adj_104);
            wp::adj_mul(var_102, var_22, adj_102, adj_22, adj_103);
            // adj: y = m1 + t * m2                                                           <L 570>
            wp::adj_div(var_101, var_66, var_102, adj_101, adj_66, adj_102);
            wp::adj_sub(var_99, var_100, adj_99, adj_100, adj_101);
            wp::adj_sqrt(var_93, var_100, adj_93, adj_100);
            wp::adj_neg(var_77, adj_77, adj_99);
            // adj: t = (-k1 - wp.sqrt(h)) / k2                                               <L 569>
        }
        if (var_94) {
            wp::adj_abs(var_66, adj_66, adj_97);
        }
        // adj: if h >= 0.0 and wp.abs(k2) >= MINVAL:                                         <L 568>
        wp::adj_sub(var_91, var_92, adj_91, adj_92, adj_93);
        wp::adj_mul(var_66, var_90, adj_66, adj_90, adj_92);
        wp::adj_mul(var_77, var_77, adj_77, adj_77, adj_91);
        // adj: h = k1 * k1 - k2 * k0                                                         <L 566>
        wp::adj_add(var_82, var_89, adj_82, adj_89, adj_90);
        wp::adj_mul(var_83, var_88, adj_83, adj_88, adj_89);
        wp::adj_sub(var_86, var_87, adj_86, adj_87, adj_88);
        wp::adj_mul(var_20, var_15, adj_20, adj_15, adj_87);
        wp::adj_mul(var_84, var_85, adj_84, adj_85, adj_86);
        wp::adj_mul(var_60, var_21, adj_60, adj_21, adj_84);
        wp::adj_mul(var_20, var_15, adj_20, adj_15, adj_83);
        wp::adj_sub(var_79, var_81, adj_79, adj_81, adj_82);
        wp::adj_mul(var_80, var_62, adj_80, adj_62, adj_81);
        wp::adj_mul(var_21, var_21, adj_21, adj_21, adj_80);
        wp::adj_mul(var_78, var_24, adj_78, adj_24, adj_79);
        wp::adj_mul(var_20, var_20, adj_20, adj_20, adj_78);
        // adj: k0 = m0 * m0 * m5 - m1 * m1 * hy + m0 * ra * (rr * m1 * 2.0 - m0 * ra)        <L 565>
        wp::adj_add(var_71, var_76, adj_71, adj_76, adj_77);
        wp::adj_mul(var_72, var_75, adj_72, adj_75, adj_76);
        wp::adj_mul(var_73, var_74, adj_73, adj_74, adj_75);
        wp::adj_mul(var_60, var_22, adj_60, adj_22, adj_73);
        wp::adj_mul(var_20, var_15, adj_20, adj_15, adj_72);
        wp::adj_sub(var_68, var_70, adj_68, adj_70, adj_71);
        wp::adj_mul(var_69, var_62, adj_69, adj_62, adj_70);
        wp::adj_mul(var_21, var_22, adj_21, adj_22, adj_69);
        wp::adj_mul(var_67, var_23, adj_67, adj_23, adj_68);
        wp::adj_mul(var_20, var_20, adj_20, adj_20, adj_67);
        // adj: k1 = m0 * m0 * m3 - m1 * m2 * hy + m0 * ra * (rr * m2 * 1.0)                  <L 564>
        wp::adj_sub(var_63, var_65, adj_63, adj_65, adj_66);
        wp::adj_mul(var_64, var_62, adj_64, adj_62, adj_65);
        wp::adj_mul(var_22, var_22, adj_22, adj_22, adj_64);
        wp::adj_mul(var_20, var_20, adj_20, adj_20, adj_63);
        // adj: k2 = m0 * m0 - m2 * m2 * hy                                                   <L 563>
        wp::adj_add(var_20, var_61, adj_20, adj_61, adj_62);
        wp::adj_mul(var_60, var_60, adj_60, adj_60, adj_61);
        // adj: hy = m0 + rr * rr                                                             <L 562>
        wp::adj_sub(var_15, var_16, adj_15, adj_16, adj_60);
        // adj: rr = ra - rb                                                                  <L 561>
    }
    // adj: if t_hit < 0.0:                                                                   <L 559>
    wp::adj_where(var_27, var_41, var_56, adj_27, adj_41, adj_56, adj_57);
    if (!var_27) {
        wp::adj_where(var_43, var_55, var_0, adj_43, adj_55, adj_0, adj_56);
        if (var_43) {
            wp::adj_where(var_45, var_54, var_0, adj_45, adj_54, adj_0, adj_55);
            if (var_45) {
                wp::adj_where(var_52, var_53, var_0, adj_52, adj_53, adj_0, adj_54);
                if (var_52) {
                    wp::adj_copy(var_47, adj_47, adj_53);
                    // adj: t_hit = t                                                         <L 557>
                }
                wp::adj_mul(var_16, var_16, adj_16, adj_16, adj_51);
                wp::adj_dot(var_49, var_49, adj_49, adj_49, adj_50);
                // adj: if wp.dot(temp_ob, temp_ob) < (rb * rb):                              <L 556>
                wp::adj_add(var_19, var_48, adj_19, adj_48, adj_49);
                wp::adj_mul(var_ray_direction, var_47, adj_ray_direction, adj_47, adj_48);
                // adj: temp_ob = ob + ray_direction * t                                      <L 555>
                wp::adj_div(var_46, var_22, var_47, adj_46, adj_22, adj_47);
                wp::adj_neg(var_25, adj_25, adj_46);
                // adj: t = -m9 / m2                                                          <L 554>
            }
            wp::adj_abs(var_22, adj_22, adj_44);
            // adj: if wp.abs(m2) > MINVAL:                                                   <L 553>
        }
        // adj: elif m9 > 0.0:                                                                <L 552>
    }
    if (var_27) {
        wp::adj_where(var_35, var_40, var_0, adj_35, adj_40, adj_0, adj_41);
        if (var_35) {
            wp::adj_where(var_37, var_39, var_0, adj_37, adj_39, adj_0, adj_40);
            if (var_37) {
                wp::adj_div(var_38, var_22, var_39, adj_38, adj_22, adj_39);
                wp::adj_neg(var_21, adj_21, adj_38);
                // adj: t_hit = -m1 / m2                                                      <L 551>
            }
            wp::adj_abs(var_22, adj_22, adj_36);
            // adj: if wp.abs(m2) > MINVAL:                                                   <L 550>
        }
        wp::adj_mul(var_33, var_22, adj_33, adj_22, adj_34);
        wp::adj_mul(var_32, var_22, adj_32, adj_22, adj_33);
        wp::adj_mul(var_15, var_15, adj_15, adj_15, adj_32);
        wp::adj_dot(var_30, var_30, adj_30, adj_30, adj_31);
        // adj: if wp.dot(temp, temp) < (ra * ra * m2 * m2):                                  <L 549>
        wp::adj_sub(var_28, var_29, adj_28, adj_29, adj_30);
        wp::adj_mul(var_ray_direction, var_21, adj_ray_direction, adj_21, adj_29);
        wp::adj_mul(var_18, var_22, adj_18, adj_22, adj_28);
        // adj: temp = oa * m2 - ray_direction * m1                                           <L 548>
    }
    // adj: if m1 < 0.0:                                                                      <L 547>
    wp::adj_dot(var_19, var_17, adj_19, adj_17, adj_25);
    // adj: m9 = wp.dot(ob, ba)                                                               <L 544>
    wp::adj_dot(var_18, var_18, adj_18, adj_18, adj_24);
    // adj: m5 = wp.dot(oa, oa)                                                               <L 543>
    wp::adj_dot(var_ray_direction, var_18, adj_ray_direction, adj_18, adj_23);
    // adj: m3 = wp.dot(ray_direction, oa)                                                    <L 542>
    wp::adj_dot(var_ray_direction, var_17, adj_ray_direction, adj_17, adj_22);
    // adj: m2 = wp.dot(ray_direction, ba)                                                    <L 541>
    wp::adj_dot(var_18, var_17, adj_18, adj_17, adj_21);
    // adj: m1 = wp.dot(oa, ba)                                                               <L 540>
    wp::adj_dot(var_17, var_17, adj_17, adj_17, adj_20);
    // adj: m0 = wp.dot(ba, ba)                                                               <L 539>
    wp::adj_sub(var_ray_origin, var_14, adj_ray_origin, adj_14, adj_19);
    // adj: ob = ray_origin - pb                                                              <L 538>
    wp::adj_sub(var_ray_origin, var_10, adj_ray_origin, adj_10, adj_18);
    // adj: oa = ray_origin - pa                                                              <L 537>
    wp::adj_sub(var_14, var_10, adj_14, adj_10, adj_17);
    // adj: ba = pb - pa                                                                      <L 536>
    wp::adj_copy(var_radius, adj_radius, adj_16);
    // adj: rb = radius  # radius at base                                                     <L 534>
    // adj: ra = 0.0  # radius at tip                                                         <L 533>
    wp::adj_vec_t(var_11, var_12, var_13, adj_11, adj_12, adj_13, adj_14);
    wp::adj_neg(var_half_height, adj_half_height, adj_13);
    // adj: pb = wp.vec3(0.0, 0.0, -half_height)  # base center at -half_height               <L 532>
    wp::adj_vec_t(var_8, var_9, var_half_height, adj_8, adj_9, adj_half_height, adj_10);
    // adj: pa = wp.vec3(0.0, 0.0, half_height)  # tip at +half_height                        <L 531>
    if (var_7) {
        label1:;
        adj_2 += adj_ret_1;
        adj_0 += adj_ret_0;
        // adj: return t_hit, normal                                                          <L 527>
    }
    // adj: if radius <= 0.0:                                                                 <L 526>
    if (var_5) {
        label0:;
        adj_2 += adj_ret_1;
        adj_0 += adj_ret_0;
        // adj: return t_hit, normal                                                          <L 524>
    }
    wp::adj_abs(var_half_height, adj_half_height, adj_3);
    // adj: if wp.abs(half_height) < MINVAL:                                                  <L 523>
    wp::adj_vec_t(var_1, adj_1, adj_2);
    // adj: normal = wp.vec3(0.0)                                                             <L 521>
    // adj: t_hit = -1.0                                                                      <L 520>
    // adj: def ray_intersect_cone(                                                           <L 504>
    return;
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/geometry/raycast.py:161
static void adj_ray_intersect_ellipsoid_0(
    wp::vec_t<3, wp::float32> var_ray_origin,
    wp::vec_t<3, wp::float32> var_ray_direction,
    wp::vec_t<3, wp::float32> var_semi_axes,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & adj_ray_origin,
    wp::vec_t<3, wp::float32> & adj_ray_direction,
    wp::vec_t<3, wp::float32> & adj_semi_axes,
    wp::float32 & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
    //---------
    // primal vars
    const wp::float32 var_0 = -1.0;
    const wp::float32 var_1 = 0.0;
    wp::vec_t<3, wp::float32> var_2;
    wp::float32 var_3;
    const wp::float32 var_4 = 1e-15;
    bool var_5;
    wp::vec_t<3, wp::float32> var_6;
    bool var_7;
    const wp::int32 var_8 = 0;
    wp::float32 var_9;
    bool var_10;
    const wp::int32 var_11 = 1;
    wp::float32 var_12;
    bool var_13;
    const wp::int32 var_14 = 2;
    wp::float32 var_15;
    bool var_16;
    wp::vec_t<3, wp::float32> var_17;
    wp::vec_t<3, wp::float32> var_18;
    wp::float32 var_19;
    wp::float32 var_20;
    wp::float32 var_21;
    wp::float32 var_22;
    const wp::float32 var_23 = 1.0;
    wp::float32 var_24;
    wp::float32 var_25;
    wp::float32 var_26;
    const wp::float32 var_27 = 0.0;
    bool var_28;
    wp::float32 var_29;
    wp::float32 var_30;
    wp::float32 var_31;
    wp::float32 var_32;
    wp::float32 var_33;
    wp::float32 var_34;
    wp::float32 var_35;
    const wp::float32 var_36 = 0.0;
    bool var_37;
    wp::float32 var_38;
    const wp::float32 var_39 = 0.0;
    bool var_40;
    wp::float32 var_41;
    wp::float32 var_42;
    wp::float32 var_43;
    const wp::float32 var_44 = 0.0;
    bool var_45;
    wp::vec_t<3, wp::float32> var_46;
    wp::vec_t<3, wp::float32> var_47;
    const wp::float32 var_48 = 1.0;
    wp::vec_t<3, wp::float32> var_49;
    wp::vec_t<3, wp::float32> var_50;
    wp::vec_t<3, wp::float32> var_51;
    wp::vec_t<3, wp::float32> var_52;
    wp::vec_t<3, wp::float32> var_53;
    wp::vec_t<3, wp::float32> var_54;
    //---------
    // dual vars
    wp::float32 adj_0 = {};
    wp::float32 adj_1 = {};
    wp::vec_t<3, wp::float32> adj_2 = {};
    wp::float32 adj_3 = {};
    wp::float32 adj_4 = {};
    bool adj_5 = {};
    wp::vec_t<3, wp::float32> adj_6 = {};
    bool adj_7 = {};
    wp::int32 adj_8 = {};
    wp::float32 adj_9 = {};
    bool adj_10 = {};
    wp::int32 adj_11 = {};
    wp::float32 adj_12 = {};
    bool adj_13 = {};
    wp::int32 adj_14 = {};
    wp::float32 adj_15 = {};
    bool adj_16 = {};
    wp::vec_t<3, wp::float32> adj_17 = {};
    wp::vec_t<3, wp::float32> adj_18 = {};
    wp::float32 adj_19 = {};
    wp::float32 adj_20 = {};
    wp::float32 adj_21 = {};
    wp::float32 adj_22 = {};
    wp::float32 adj_23 = {};
    wp::float32 adj_24 = {};
    wp::float32 adj_25 = {};
    wp::float32 adj_26 = {};
    wp::float32 adj_27 = {};
    bool adj_28 = {};
    wp::float32 adj_29 = {};
    wp::float32 adj_30 = {};
    wp::float32 adj_31 = {};
    wp::float32 adj_32 = {};
    wp::float32 adj_33 = {};
    wp::float32 adj_34 = {};
    wp::float32 adj_35 = {};
    wp::float32 adj_36 = {};
    bool adj_37 = {};
    wp::float32 adj_38 = {};
    wp::float32 adj_39 = {};
    bool adj_40 = {};
    wp::float32 adj_41 = {};
    wp::float32 adj_42 = {};
    wp::float32 adj_43 = {};
    wp::float32 adj_44 = {};
    bool adj_45 = {};
    wp::vec_t<3, wp::float32> adj_46 = {};
    wp::vec_t<3, wp::float32> adj_47 = {};
    wp::float32 adj_48 = {};
    wp::vec_t<3, wp::float32> adj_49 = {};
    wp::vec_t<3, wp::float32> adj_50 = {};
    wp::vec_t<3, wp::float32> adj_51 = {};
    wp::vec_t<3, wp::float32> adj_52 = {};
    wp::vec_t<3, wp::float32> adj_53 = {};
    wp::vec_t<3, wp::float32> adj_54 = {};
    //---------
    // forward
    // def ray_intersect_ellipsoid(ray_origin: wp.vec3, ray_direction: wp.vec3, semi_axes: wp.vec3) -> tuple[float, wp.vec3]:       <L 162>
    // t_hit = -1.0                                                                           <L 176>
    // normal = wp.vec3(0.0)                                                                  <L 177>
    var_2 = wp::vec_t<3, wp::float32>(var_1);
    // d_len_sq = wp.dot(ray_direction, ray_direction)                                        <L 180>
    var_3 = wp::dot(var_ray_direction, var_ray_direction);
    // if d_len_sq < MINVAL:                                                                  <L 181>
    var_5 = (var_3 < var_4);
    if (var_5) {
        // return t_hit, normal                                                               <L 182>
        ret_0 = var_0;
        ret_1 = var_2;
        goto label0;
    }
    // ra = semi_axes                                                                         <L 184>
    var_6 = wp::copy(var_semi_axes);
    // if ra[0] < MINVAL or ra[1] < MINVAL or ra[2] < MINVAL:                                 <L 187>
    var_9 = wp::extract(var_6, var_8);
    var_10 = (var_9 < var_4);
    var_7 = var_10;
    if (!var_7) {
        var_12 = wp::extract(var_6, var_11);
        var_13 = (var_12 < var_4);
        var_7 = var_7 || var_13;
    }
    if (!var_7) {
        var_15 = wp::extract(var_6, var_14);
        var_16 = (var_15 < var_4);
        var_7 = var_7 || var_16;
    }
    if (var_7) {
        // return t_hit, normal                                                               <L 188>
        ret_0 = var_0;
        ret_1 = var_2;
        goto label1;
    }
    // ocn = wp.cw_div(ray_origin, ra)                                                        <L 191>
    var_17 = wp::cw_div(var_ray_origin, var_6);
    // rdn = wp.cw_div(ray_direction, ra)                                                     <L 192>
    var_18 = wp::cw_div(var_ray_direction, var_6);
    // a = wp.dot(rdn, rdn)                                                                   <L 194>
    var_19 = wp::dot(var_18, var_18);
    // b = wp.dot(ocn, rdn)                                                                   <L 195>
    var_20 = wp::dot(var_17, var_18);
    // c = wp.dot(ocn, ocn)                                                                   <L 196>
    var_21 = wp::dot(var_17, var_17);
    // h = b * b - a * (c - 1.0)                                                              <L 198>
    var_22 = wp::mul(var_20, var_20);
    var_24 = wp::sub(var_21, var_23);
    var_25 = wp::mul(var_19, var_24);
    var_26 = wp::sub(var_22, var_25);
    // if h < 0.0:                                                                            <L 199>
    var_28 = (var_26 < var_27);
    if (var_28) {
        // return t_hit, normal  # No intersection                                            <L 200>
        ret_0 = var_0;
        ret_1 = var_2;
        goto label2;
    }
    // h = wp.sqrt(h)                                                                         <L 202>
    var_29 = wp::sqrt(var_26);
    // t1 = (-b - h) / a                                                                      <L 205>
    var_30 = wp::neg(var_20);
    var_31 = wp::sub(var_30, var_29);
    var_32 = wp::div(var_31, var_19);
    // t2 = (-b + h) / a                                                                      <L 206>
    var_33 = wp::neg(var_20);
    var_34 = wp::add(var_33, var_29);
    var_35 = wp::div(var_34, var_19);
    // if t1 >= 0.0:                                                                          <L 209>
    var_37 = (var_32 >= var_36);
    if (var_37) {
        // t_hit = t1                                                                         <L 210>
        var_38 = wp::copy(var_32);
    }
    if (!var_37) {
        // elif t2 >= 0.0:                                                                    <L 211>
        var_40 = (var_35 >= var_39);
        if (var_40) {
            // t_hit = t2                                                                     <L 212>
            var_41 = wp::copy(var_35);
        }
        var_42 = wp::where(var_40, var_41, var_0);
    }
    var_43 = wp::where(var_37, var_38, var_42);
    // if t_hit >= 0.0:                                                                       <L 214>
    var_45 = (var_43 >= var_44);
    if (var_45) {
        // hit_local = ray_origin + t_hit * ray_direction                                     <L 215>
        var_46 = wp::mul(var_43, var_ray_direction);
        var_47 = wp::add(var_ray_origin, var_46);
        // inv_size = safe_div_vec3(wp.vec3(1.0), semi_axes)                                  <L 216>
        var_49 = wp::vec_t<3, wp::float32>(var_48);
        var_50 = safe_div_vec3_0(var_49, var_semi_axes);
        // inv_size_sq = wp.cw_mul(inv_size, inv_size)                                        <L 217>
        var_51 = wp::cw_mul(var_50, var_50);
        // normal = wp.normalize(wp.cw_mul(hit_local, inv_size_sq))                           <L 218>
        var_52 = wp::cw_mul(var_47, var_51);
        var_53 = wp::normalize(var_52);
    }
    var_54 = wp::where(var_45, var_53, var_2);
    // return t_hit, normal                                                                   <L 220>
    ret_0 = var_43;
    ret_1 = var_54;
    goto label3;
    //---------
    // reverse
    label3:;
    adj_54 += adj_ret_1;
    adj_43 += adj_ret_0;
    // adj: return t_hit, normal                                                              <L 220>
    wp::adj_where(var_45, var_53, var_2, adj_45, adj_53, adj_2, adj_54);
    if (var_45) {
        wp::adj_normalize(var_52, var_53, adj_52, adj_53);
        wp::adj_cw_mul(var_47, var_51, adj_47, adj_51, adj_52);
        // adj: normal = wp.normalize(wp.cw_mul(hit_local, inv_size_sq))                      <L 218>
        wp::adj_cw_mul(var_50, var_50, adj_50, adj_50, adj_51);
        // adj: inv_size_sq = wp.cw_mul(inv_size, inv_size)                                   <L 217>
        adj_safe_div_vec3_0(var_49, var_semi_axes, adj_49, adj_semi_axes, adj_50);
        wp::adj_vec_t(var_48, adj_48, adj_49);
        // adj: inv_size = safe_div_vec3(wp.vec3(1.0), semi_axes)                             <L 216>
        wp::adj_add(var_ray_origin, var_46, adj_ray_origin, adj_46, adj_47);
        wp::adj_mul(var_43, var_ray_direction, adj_43, adj_ray_direction, adj_46);
        // adj: hit_local = ray_origin + t_hit * ray_direction                                <L 215>
    }
    // adj: if t_hit >= 0.0:                                                                  <L 214>
    wp::adj_where(var_37, var_38, var_42, adj_37, adj_38, adj_42, adj_43);
    if (!var_37) {
        wp::adj_where(var_40, var_41, var_0, adj_40, adj_41, adj_0, adj_42);
        if (var_40) {
            wp::adj_copy(var_35, adj_35, adj_41);
            // adj: t_hit = t2                                                                <L 212>
        }
        // adj: elif t2 >= 0.0:                                                               <L 211>
    }
    if (var_37) {
        wp::adj_copy(var_32, adj_32, adj_38);
        // adj: t_hit = t1                                                                    <L 210>
    }
    // adj: if t1 >= 0.0:                                                                     <L 209>
    wp::adj_div(var_34, var_19, var_35, adj_34, adj_19, adj_35);
    wp::adj_add(var_33, var_29, adj_33, adj_29, adj_34);
    wp::adj_neg(var_20, adj_20, adj_33);
    // adj: t2 = (-b + h) / a                                                                 <L 206>
    wp::adj_div(var_31, var_19, var_32, adj_31, adj_19, adj_32);
    wp::adj_sub(var_30, var_29, adj_30, adj_29, adj_31);
    wp::adj_neg(var_20, adj_20, adj_30);
    // adj: t1 = (-b - h) / a                                                                 <L 205>
    wp::adj_sqrt(var_26, var_29, adj_26, adj_29);
    // adj: h = wp.sqrt(h)                                                                    <L 202>
    if (var_28) {
        label2:;
        adj_2 += adj_ret_1;
        adj_0 += adj_ret_0;
        // adj: return t_hit, normal  # No intersection                                       <L 200>
    }
    // adj: if h < 0.0:                                                                       <L 199>
    wp::adj_sub(var_22, var_25, adj_22, adj_25, adj_26);
    wp::adj_mul(var_19, var_24, adj_19, adj_24, adj_25);
    wp::adj_sub(var_21, var_23, adj_21, adj_23, adj_24);
    wp::adj_mul(var_20, var_20, adj_20, adj_20, adj_22);
    // adj: h = b * b - a * (c - 1.0)                                                         <L 198>
    wp::adj_dot(var_17, var_17, adj_17, adj_17, adj_21);
    // adj: c = wp.dot(ocn, ocn)                                                              <L 196>
    wp::adj_dot(var_17, var_18, adj_17, adj_18, adj_20);
    // adj: b = wp.dot(ocn, rdn)                                                              <L 195>
    wp::adj_dot(var_18, var_18, adj_18, adj_18, adj_19);
    // adj: a = wp.dot(rdn, rdn)                                                              <L 194>
    wp::adj_cw_div(var_ray_direction, var_6, var_18, adj_ray_direction, adj_6, adj_18);
    // adj: rdn = wp.cw_div(ray_direction, ra)                                                <L 192>
    wp::adj_cw_div(var_ray_origin, var_6, var_17, adj_ray_origin, adj_6, adj_17);
    // adj: ocn = wp.cw_div(ray_origin, ra)                                                   <L 191>
    if (var_7) {
        label1:;
        adj_2 += adj_ret_1;
        adj_0 += adj_ret_0;
        // adj: return t_hit, normal                                                          <L 188>
    }
    if (!var_7) {
        wp::adj_extract(var_6, var_14, adj_6, adj_14, adj_15);
    }
    if (!var_7) {
        wp::adj_extract(var_6, var_11, adj_6, adj_11, adj_12);
    }
    wp::adj_extract(var_6, var_8, adj_6, adj_8, adj_9);
    // adj: if ra[0] < MINVAL or ra[1] < MINVAL or ra[2] < MINVAL:                            <L 187>
    wp::adj_copy(var_semi_axes, adj_semi_axes, adj_6);
    // adj: ra = semi_axes                                                                    <L 184>
    if (var_5) {
        label0:;
        adj_2 += adj_ret_1;
        adj_0 += adj_ret_0;
        // adj: return t_hit, normal                                                          <L 182>
    }
    // adj: if d_len_sq < MINVAL:                                                             <L 181>
    wp::adj_dot(var_ray_direction, var_ray_direction, adj_ray_direction, adj_ray_direction, adj_3);
    // adj: d_len_sq = wp.dot(ray_direction, ray_direction)                                   <L 180>
    wp::adj_vec_t(var_1, adj_1, adj_2);
    // adj: normal = wp.vec3(0.0)                                                             <L 177>
    // adj: t_hit = -1.0                                                                      <L 176>
    // adj: def ray_intersect_ellipsoid(ray_origin: wp.vec3, ray_direction: wp.vec3, semi_axes: wp.vec3) -> tuple[float, wp.vec3]:  <L 162>
    return;
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/geometry/raycast.py:745
static void adj__make_ray_intersect_shape__locals__ray_intersect_shape_0(
    wp::transform_t<wp::float32> var_geom_to_world,
    wp::vec_t<3, wp::float32> var_size,
    wp::int32 var_geomtype,
    wp::vec_t<3, wp::float32> var_ray_origin,
    wp::vec_t<3, wp::float32> var_ray_direction,
    bool var_enable_backface_culling,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::transform_t<wp::float32> & adj_geom_to_world,
    wp::vec_t<3, wp::float32> & adj_size,
    wp::int32 & adj_geomtype,
    wp::vec_t<3, wp::float32> & adj_ray_origin,
    wp::vec_t<3, wp::float32> & adj_ray_direction,
    bool & adj_enable_backface_culling,
    wp::float32 & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    const wp::vec_t<3, wp::float32> var_2 = wp::initializer_array<3,wp::float32>{1.0, 1.0, 1.0};
    const wp::float32 var_3 = -1.0;
    const wp::float32 var_4 = 0.0;
    wp::vec_t<3, wp::float32> var_5;
    const wp::int32 var_6 = 1;
    bool var_7;
    wp::float32 var_8;
    wp::vec_t<3, wp::float32> var_9;
    const wp::int32 var_10 = 3;
    bool var_11;
    const wp::int32 var_12 = 0;
    wp::float32 var_13;
    wp::float32 var_14;
    wp::vec_t<3, wp::float32> var_15;
    const wp::int32 var_16 = 7;
    bool var_17;
    wp::float32 var_18;
    wp::vec_t<3, wp::float32> var_19;
    const wp::int32 var_20 = 4;
    bool var_21;
    const wp::int32 var_22 = 0;
    wp::float32 var_23;
    const wp::int32 var_24 = 1;
    wp::float32 var_25;
    wp::float32 var_26;
    wp::vec_t<3, wp::float32> var_27;
    const wp::int32 var_28 = 6;
    bool var_29;
    const wp::int32 var_30 = 0;
    wp::float32 var_31;
    const wp::int32 var_32 = 1;
    wp::float32 var_33;
    const wp::int32 var_34 = 2;
    wp::float32 var_35;
    wp::float32 var_36;
    wp::vec_t<3, wp::float32> var_37;
    const wp::int32 var_38 = 9;
    bool var_39;
    const wp::int32 var_40 = 0;
    wp::float32 var_41;
    const wp::int32 var_42 = 1;
    wp::float32 var_43;
    wp::float32 var_44;
    wp::vec_t<3, wp::float32> var_45;
    const wp::int32 var_46 = 5;
    bool var_47;
    wp::float32 var_48;
    wp::vec_t<3, wp::float32> var_49;
    wp::float32 var_50;
    wp::vec_t<3, wp::float32> var_51;
    wp::float32 var_52;
    wp::vec_t<3, wp::float32> var_53;
    wp::float32 var_54;
    wp::vec_t<3, wp::float32> var_55;
    wp::float32 var_56;
    wp::vec_t<3, wp::float32> var_57;
    wp::float32 var_58;
    wp::vec_t<3, wp::float32> var_59;
    wp::float32 var_60;
    wp::vec_t<3, wp::float32> var_61;
    wp::float32 var_62;
    wp::vec_t<3, wp::float32> var_63;
    const wp::float32 var_64 = 0.0;
    wp::vec_t<3, wp::float32> var_65;
    const bool var_66 = true;
    const wp::float32 var_67 = 0.0;
    bool var_68;
    wp::vec_t<3, wp::float32> var_69;
    wp::vec_t<3, wp::float32> var_70;
    wp::vec_t<3, wp::float32> var_71;
    //---------
    // dual vars
    wp::vec_t<3, wp::float32> adj_0 = {};
    wp::vec_t<3, wp::float32> adj_1 = {};
    wp::vec_t<3, wp::float32> adj_2 = {};
    wp::float32 adj_3 = {};
    wp::float32 adj_4 = {};
    wp::vec_t<3, wp::float32> adj_5 = {};
    wp::int32 adj_6 = {};
    bool adj_7 = {};
    wp::float32 adj_8 = {};
    wp::vec_t<3, wp::float32> adj_9 = {};
    wp::int32 adj_10 = {};
    bool adj_11 = {};
    wp::int32 adj_12 = {};
    wp::float32 adj_13 = {};
    wp::float32 adj_14 = {};
    wp::vec_t<3, wp::float32> adj_15 = {};
    wp::int32 adj_16 = {};
    bool adj_17 = {};
    wp::float32 adj_18 = {};
    wp::vec_t<3, wp::float32> adj_19 = {};
    wp::int32 adj_20 = {};
    bool adj_21 = {};
    wp::int32 adj_22 = {};
    wp::float32 adj_23 = {};
    wp::int32 adj_24 = {};
    wp::float32 adj_25 = {};
    wp::float32 adj_26 = {};
    wp::vec_t<3, wp::float32> adj_27 = {};
    wp::int32 adj_28 = {};
    bool adj_29 = {};
    wp::int32 adj_30 = {};
    wp::float32 adj_31 = {};
    wp::int32 adj_32 = {};
    wp::float32 adj_33 = {};
    wp::int32 adj_34 = {};
    wp::float32 adj_35 = {};
    wp::float32 adj_36 = {};
    wp::vec_t<3, wp::float32> adj_37 = {};
    wp::int32 adj_38 = {};
    bool adj_39 = {};
    wp::int32 adj_40 = {};
    wp::float32 adj_41 = {};
    wp::int32 adj_42 = {};
    wp::float32 adj_43 = {};
    wp::float32 adj_44 = {};
    wp::vec_t<3, wp::float32> adj_45 = {};
    wp::int32 adj_46 = {};
    bool adj_47 = {};
    wp::float32 adj_48 = {};
    wp::vec_t<3, wp::float32> adj_49 = {};
    wp::float32 adj_50 = {};
    wp::vec_t<3, wp::float32> adj_51 = {};
    wp::float32 adj_52 = {};
    wp::vec_t<3, wp::float32> adj_53 = {};
    wp::float32 adj_54 = {};
    wp::vec_t<3, wp::float32> adj_55 = {};
    wp::float32 adj_56 = {};
    wp::vec_t<3, wp::float32> adj_57 = {};
    wp::float32 adj_58 = {};
    wp::vec_t<3, wp::float32> adj_59 = {};
    wp::float32 adj_60 = {};
    wp::vec_t<3, wp::float32> adj_61 = {};
    wp::float32 adj_62 = {};
    wp::vec_t<3, wp::float32> adj_63 = {};
    wp::float32 adj_64 = {};
    wp::vec_t<3, wp::float32> adj_65 = {};
    bool adj_66 = {};
    wp::float32 adj_67 = {};
    bool adj_68 = {};
    wp::vec_t<3, wp::float32> adj_69 = {};
    wp::vec_t<3, wp::float32> adj_70 = {};
    wp::vec_t<3, wp::float32> adj_71 = {};
    //---------
    // forward
    // def ray_intersect_shape(                                                               <L 746>
    // ray_origin_local, ray_direction_local = map_ray_to_local(geom_to_world, ray_origin, ray_direction)       <L 772>
    map_ray_to_local_0(var_geom_to_world, var_ray_origin, var_ray_direction, var_2, var_0, var_1);
    // t_hit = -1.0                                                                           <L 774>
    // normal_local = wp.vec3(0.0)                                                            <L 775>
    var_5 = wp::vec_t<3, wp::float32>(var_4);
    // if geomtype == GeoType.PLANE:                                                          <L 777>
    var_7 = (var_geomtype == var_6);
    if (var_7) {
        // t_hit, normal_local = ray_intersect_plane(                                         <L 778>
        // ray_origin_local, ray_direction_local, size, enable_backface_culling               <L 779>
        ray_intersect_plane_0(var_0, var_1, var_size, var_enable_backface_culling, var_8, var_9);
    }
    if (!var_7) {
        // elif geomtype == GeoType.SPHERE:                                                   <L 781>
        var_11 = (var_geomtype == var_10);
        if (var_11) {
            // t_hit, normal_local = ray_intersect_sphere(ray_origin_local, ray_direction_local, size[0])       <L 782>
            var_13 = wp::extract(var_size, var_12);
            ray_intersect_sphere_0(var_0, var_1, var_13, var_14, var_15);
        }
        if (!var_11) {
            // elif geomtype == GeoType.BOX:                                                  <L 783>
            var_17 = (var_geomtype == var_16);
            if (var_17) {
                // t_hit, normal_local = ray_intersect_box(ray_origin_local, ray_direction_local, size)       <L 784>
                ray_intersect_box_0(var_0, var_1, var_size, var_18, var_19);
            }
            if (!var_17) {
                // elif geomtype == GeoType.CAPSULE:                                          <L 785>
                var_21 = (var_geomtype == var_20);
                if (var_21) {
                    // t_hit, normal_local = ray_intersect_capsule(ray_origin_local, ray_direction_local, size[0], size[1])       <L 786>
                    var_23 = wp::extract(var_size, var_22);
                    var_25 = wp::extract(var_size, var_24);
                    ray_intersect_capsule_0(var_0, var_1, var_23, var_25, var_26, var_27);
                }
                if (!var_21) {
                    // elif geomtype == GeoType.CYLINDER:                                     <L 787>
                    var_29 = (var_geomtype == var_28);
                    if (var_29) {
                        // t_hit, normal_local = ray_intersect_cylinder(                      <L 788>
                        // ray_origin_local, ray_direction_local, size[0], size[1], size[2]       <L 789>
                        var_31 = wp::extract(var_size, var_30);
                        var_33 = wp::extract(var_size, var_32);
                        var_35 = wp::extract(var_size, var_34);
                        ray_intersect_cylinder_0(var_0, var_1, var_31, var_33, var_35, var_36, var_37);
                    }
                    if (!var_29) {
                        // elif geomtype == GeoType.CONE:                                     <L 791>
                        var_39 = (var_geomtype == var_38);
                        if (var_39) {
                            // t_hit, normal_local = ray_intersect_cone(ray_origin_local, ray_direction_local, size[0], size[1])       <L 792>
                            var_41 = wp::extract(var_size, var_40);
                            var_43 = wp::extract(var_size, var_42);
                            ray_intersect_cone_0(var_0, var_1, var_41, var_43, var_44, var_45);
                        }
                        if (!var_39) {
                            // elif geomtype == GeoType.ELLIPSOID:                            <L 793>
                            var_47 = (var_geomtype == var_46);
                            if (var_47) {
                                // t_hit, normal_local = ray_intersect_ellipsoid(ray_origin_local, ray_direction_local, size)       <L 794>
                                ray_intersect_ellipsoid_0(var_0, var_1, var_size, var_48, var_49);
                            }
                            var_50 = wp::where(var_47, var_48, var_3);
                            var_51 = wp::where(var_47, var_49, var_5);
                        }
                        var_52 = wp::where(var_39, var_44, var_50);
                        var_53 = wp::where(var_39, var_45, var_51);
                    }
                    var_54 = wp::where(var_29, var_36, var_52);
                    var_55 = wp::where(var_29, var_37, var_53);
                }
                var_56 = wp::where(var_21, var_26, var_54);
                var_57 = wp::where(var_21, var_27, var_55);
            }
            var_58 = wp::where(var_17, var_18, var_56);
            var_59 = wp::where(var_17, var_19, var_57);
        }
        var_60 = wp::where(var_11, var_14, var_58);
        var_61 = wp::where(var_11, var_15, var_59);
    }
    var_62 = wp::where(var_7, var_8, var_60);
    var_63 = wp::where(var_7, var_9, var_61);
    // normal = wp.vec3(0.0)                                                                  <L 796>
    var_65 = wp::vec_t<3, wp::float32>(var_64);
    // if wp.static(compute_normal):                                                          <L 797>
    // if t_hit >= 0.0:                                                                       <L 798>
    var_68 = (var_62 >= var_67);
    if (var_68) {
        // normal = wp.normalize(wp.transform_vector(geom_to_world, normal_local))            <L 799>
        var_69 = wp::transform_vector(var_geom_to_world, var_63);
        var_70 = wp::normalize(var_69);
    }
    var_71 = wp::where(var_68, var_70, var_65);
    // return t_hit, normal                                                                   <L 801>
    ret_0 = var_62;
    ret_1 = var_71;
    goto label0;
    //---------
    // reverse
    label0:;
    adj_71 += adj_ret_1;
    adj_62 += adj_ret_0;
    // adj: return t_hit, normal                                                              <L 801>
    wp::adj_where(var_68, var_70, var_65, adj_68, adj_70, adj_65, adj_71);
    if (var_68) {
        wp::adj_normalize(var_69, var_70, adj_69, adj_70);
        wp::adj_transform_vector(var_geom_to_world, var_63, adj_geom_to_world, adj_63, adj_69);
        // adj: normal = wp.normalize(wp.transform_vector(geom_to_world, normal_local))       <L 799>
    }
    // adj: if t_hit >= 0.0:                                                                  <L 798>
    // adj: if wp.static(compute_normal):                                                     <L 797>
    wp::adj_vec_t(var_64, adj_64, adj_65);
    // adj: normal = wp.vec3(0.0)                                                             <L 796>
    wp::adj_where(var_7, var_9, var_61, adj_7, adj_9, adj_61, adj_63);
    wp::adj_where(var_7, var_8, var_60, adj_7, adj_8, adj_60, adj_62);
    if (!var_7) {
        wp::adj_where(var_11, var_15, var_59, adj_11, adj_15, adj_59, adj_61);
        wp::adj_where(var_11, var_14, var_58, adj_11, adj_14, adj_58, adj_60);
        if (!var_11) {
            wp::adj_where(var_17, var_19, var_57, adj_17, adj_19, adj_57, adj_59);
            wp::adj_where(var_17, var_18, var_56, adj_17, adj_18, adj_56, adj_58);
            if (!var_17) {
                wp::adj_where(var_21, var_27, var_55, adj_21, adj_27, adj_55, adj_57);
                wp::adj_where(var_21, var_26, var_54, adj_21, adj_26, adj_54, adj_56);
                if (!var_21) {
                    wp::adj_where(var_29, var_37, var_53, adj_29, adj_37, adj_53, adj_55);
                    wp::adj_where(var_29, var_36, var_52, adj_29, adj_36, adj_52, adj_54);
                    if (!var_29) {
                        wp::adj_where(var_39, var_45, var_51, adj_39, adj_45, adj_51, adj_53);
                        wp::adj_where(var_39, var_44, var_50, adj_39, adj_44, adj_50, adj_52);
                        if (!var_39) {
                            wp::adj_where(var_47, var_49, var_5, adj_47, adj_49, adj_5, adj_51);
                            wp::adj_where(var_47, var_48, var_3, adj_47, adj_48, adj_3, adj_50);
                            if (var_47) {
                                adj_ray_intersect_ellipsoid_0(var_0, var_1, var_size, var_48, var_49, adj_0, adj_1, adj_size, adj_48, adj_49);
                                // adj: t_hit, normal_local = ray_intersect_ellipsoid(ray_origin_local, ray_direction_local, size)  <L 794>
                            }
                            // adj: elif geomtype == GeoType.ELLIPSOID:                       <L 793>
                        }
                        if (var_39) {
                            adj_ray_intersect_cone_0(var_0, var_1, var_41, var_43, var_44, var_45, adj_0, adj_1, adj_41, adj_43, adj_44, adj_45);
                            wp::adj_extract(var_size, var_42, adj_size, adj_42, adj_43);
                            wp::adj_extract(var_size, var_40, adj_size, adj_40, adj_41);
                            // adj: t_hit, normal_local = ray_intersect_cone(ray_origin_local, ray_direction_local, size[0], size[1])  <L 792>
                        }
                        // adj: elif geomtype == GeoType.CONE:                                <L 791>
                    }
                    if (var_29) {
                        adj_ray_intersect_cylinder_0(var_0, var_1, var_31, var_33, var_35, var_36, var_37, adj_0, adj_1, adj_31, adj_33, adj_35, adj_36, adj_37);
                        wp::adj_extract(var_size, var_34, adj_size, adj_34, adj_35);
                        wp::adj_extract(var_size, var_32, adj_size, adj_32, adj_33);
                        wp::adj_extract(var_size, var_30, adj_size, adj_30, adj_31);
                        // adj: ray_origin_local, ray_direction_local, size[0], size[1], size[2]  <L 789>
                        // adj: t_hit, normal_local = ray_intersect_cylinder(                 <L 788>
                    }
                    // adj: elif geomtype == GeoType.CYLINDER:                                <L 787>
                }
                if (var_21) {
                    adj_ray_intersect_capsule_0(var_0, var_1, var_23, var_25, var_26, var_27, adj_0, adj_1, adj_23, adj_25, adj_26, adj_27);
                    wp::adj_extract(var_size, var_24, adj_size, adj_24, adj_25);
                    wp::adj_extract(var_size, var_22, adj_size, adj_22, adj_23);
                    // adj: t_hit, normal_local = ray_intersect_capsule(ray_origin_local, ray_direction_local, size[0], size[1])  <L 786>
                }
                // adj: elif geomtype == GeoType.CAPSULE:                                     <L 785>
            }
            if (var_17) {
                adj_ray_intersect_box_0(var_0, var_1, var_size, var_18, var_19, adj_0, adj_1, adj_size, adj_18, adj_19);
                // adj: t_hit, normal_local = ray_intersect_box(ray_origin_local, ray_direction_local, size)  <L 784>
            }
            // adj: elif geomtype == GeoType.BOX:                                             <L 783>
        }
        if (var_11) {
            adj_ray_intersect_sphere_0(var_0, var_1, var_13, var_14, var_15, adj_0, adj_1, adj_13, adj_14, adj_15);
            wp::adj_extract(var_size, var_12, adj_size, adj_12, adj_13);
            // adj: t_hit, normal_local = ray_intersect_sphere(ray_origin_local, ray_direction_local, size[0])  <L 782>
        }
        // adj: elif geomtype == GeoType.SPHERE:                                              <L 781>
    }
    if (var_7) {
        adj_ray_intersect_plane_0(var_0, var_1, var_size, var_enable_backface_culling, var_8, var_9, adj_0, adj_1, adj_size, adj_enable_backface_culling, adj_8, adj_9);
        // adj: ray_origin_local, ray_direction_local, size, enable_backface_culling          <L 779>
        // adj: t_hit, normal_local = ray_intersect_plane(                                    <L 778>
    }
    // adj: if geomtype == GeoType.PLANE:                                                     <L 777>
    wp::adj_vec_t(var_4, adj_4, adj_5);
    // adj: normal_local = wp.vec3(0.0)                                                       <L 775>
    // adj: t_hit = -1.0                                                                      <L 774>
    adj_map_ray_to_local_0(var_geom_to_world, var_ray_origin, var_ray_direction, var_2, var_0, var_1, adj_geom_to_world, adj_ray_origin, adj_ray_direction, adj_2, adj_0, adj_1);
    // adj: ray_origin_local, ray_direction_local = map_ray_to_local(geom_to_world, ray_origin, ray_direction)  <L 772>
    // adj: def ray_intersect_shape(                                                          <L 746>
    return;
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/geometry/raycast.py:28
static void adj__spinlock_acquire_0(
    wp::array_t<wp::int32> var_lock,
    wp::array_t<wp::int32> & adj_lock)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    const wp::int32 var_1 = 0;
    const wp::int32 var_2 = 1;
    wp::int32 var_3;
    const wp::int32 var_4 = 1;
    bool var_5;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    wp::int32 adj_1 = {};
    wp::int32 adj_2 = {};
    wp::int32 adj_3 = {};
    wp::int32 adj_4 = {};
    bool adj_5 = {};
    //---------
    // forward
    // def _spinlock_acquire(lock: wp.array[wp.int32]):                                       <L 29>
    // while wp.atomic_cas(lock, 0, 0, 1) == 1:                                               <L 31>
    //---------
    // reverse
    start_while_0:;
    var_3 = wp::atomic_cas(var_lock, var_0, var_1, var_2);
    var_5 = (var_3 == var_4);
    if ((var_5) == false) goto end_while_0;
        // pass                                                                               <L 32>
        // adj: pass                                                                          <L 32>
    goto start_while_0;
    end_while_0:;
    // adj: while wp.atomic_cas(lock, 0, 0, 1) == 1:                                          <L 31>
    // adj: def _spinlock_acquire(lock: wp.array[wp.int32]):                                  <L 29>
    return;
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/geometry/raycast.py:35
static void adj__spinlock_release_0(
    wp::array_t<wp::int32> var_lock,
    wp::array_t<wp::int32> & adj_lock)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    const wp::int32 var_1 = 0;
    wp::int32 var_2;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    wp::int32 adj_1 = {};
    wp::int32 adj_2 = {};
    //---------
    // forward
    // def _spinlock_release(lock: wp.array[wp.int32]):                                       <L 36>
    // wp.atomic_exch(lock, 0, 0)                                                             <L 38>
    // var_2 = wp::atomic_exch(var_lock, var_0, var_1);
    //---------
    // reverse
    // adj: wp.atomic_exch(lock, 0, 0)                                                        <L 38>
    // adj: def _spinlock_release(lock: wp.array[wp.int32]):                                  <L 36>
    return;
}

struct wp_args_raycast_kernel_12252ff2 {
    wp::array_t<wp::transform_t<wp::float32>> body_q;
    wp::array_t<wp::int32> shape_body;
    wp::array_t<wp::transform_t<wp::float32>> shape_transform;
    wp::array_t<wp::int32> geom_type;
    wp::array_t<wp::vec_t<3, wp::float32>> geom_size;
    wp::array_t<wp::uint64> shape_source_ptr;
    wp::vec_t<3, wp::float32> ray_origin;
    wp::vec_t<3, wp::float32> ray_direction;
    wp::array_t<wp::int32> lock;
    wp::array_t<wp::float32> min_dist;
    wp::array_t<wp::int32> min_index;
    wp::array_t<wp::int32> min_body_index;
    wp::array_t<wp::int32> shape_world;
    wp::array_t<wp::vec_t<3, wp::float32>> world_offsets;
    wp::array_t<wp::int32> visible_worlds_mask;
};


void raycast_kernel_12252ff2_cpu_kernel_forward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_raycast_kernel_12252ff2 *_wp_args)
{
    //---------
    // argument vars
    wp::array_t<wp::transform_t<wp::float32>> var_body_q = _wp_args->body_q;
    wp::array_t<wp::int32> var_shape_body = _wp_args->shape_body;
    wp::array_t<wp::transform_t<wp::float32>> var_shape_transform = _wp_args->shape_transform;
    wp::array_t<wp::int32> var_geom_type = _wp_args->geom_type;
    wp::array_t<wp::vec_t<3, wp::float32>> var_geom_size = _wp_args->geom_size;
    wp::array_t<wp::uint64> var_shape_source_ptr = _wp_args->shape_source_ptr;
    wp::vec_t<3, wp::float32> var_ray_origin = _wp_args->ray_origin;
    wp::vec_t<3, wp::float32> var_ray_direction = _wp_args->ray_direction;
    wp::array_t<wp::int32> var_lock = _wp_args->lock;
    wp::array_t<wp::float32> var_min_dist = _wp_args->min_dist;
    wp::array_t<wp::int32> var_min_index = _wp_args->min_index;
    wp::array_t<wp::int32> var_min_body_index = _wp_args->min_body_index;
    wp::array_t<wp::int32> var_shape_world = _wp_args->shape_world;
    wp::array_t<wp::vec_t<3, wp::float32>> var_world_offsets = _wp_args->world_offsets;
    wp::array_t<wp::int32> var_visible_worlds_mask = _wp_args->visible_worlds_mask;
    //---------
    // primal vars
    wp::int32 var_0;
    bool var_1;
    wp::shape_t* var_2;
    const wp::int32 var_3 = 0;
    wp::int32 var_4;
    wp::shape_t var_5;
    const wp::int32 var_6 = 0;
    bool var_7;
    wp::int32* var_8;
    wp::int32 var_9;
    wp::int32 var_10;
    const wp::int32 var_11 = 0;
    bool var_12;
    wp::int32* var_13;
    const wp::int32 var_14 = 0;
    bool var_15;
    wp::int32 var_16;
    wp::int32* var_17;
    wp::int32 var_18;
    wp::int32 var_19;
    wp::transform_t<wp::float32> var_20;
    const wp::int32 var_21 = 0;
    bool var_22;
    wp::transform_t<wp::float32>* var_23;
    wp::transform_t<wp::float32> var_24;
    wp::transform_t<wp::float32> var_25;
    wp::transform_t<wp::float32> var_26;
    wp::transform_t<wp::float32>* var_27;
    wp::transform_t<wp::float32> var_28;
    wp::transform_t<wp::float32> var_29;
    wp::transform_t<wp::float32> var_30;
    bool var_31;
    wp::shape_t* var_32;
    const wp::int32 var_33 = 0;
    wp::int32 var_34;
    wp::shape_t var_35;
    const wp::int32 var_36 = 0;
    bool var_37;
    wp::shape_t* var_38;
    const wp::int32 var_39 = 0;
    wp::int32 var_40;
    wp::shape_t var_41;
    const wp::int32 var_42 = 0;
    bool var_43;
    wp::int32* var_44;
    wp::int32 var_45;
    wp::int32 var_46;
    bool var_47;
    const wp::int32 var_48 = 0;
    bool var_49;
    wp::shape_t* var_50;
    const wp::int32 var_51 = 0;
    wp::int32 var_52;
    wp::shape_t var_53;
    bool var_54;
    wp::vec_t<3, wp::float32>* var_55;
    wp::vec_t<3, wp::float32> var_56;
    wp::vec_t<3, wp::float32> var_57;
    wp::vec_t<3, wp::float32> var_58;
    wp::vec_t<3, wp::float32> var_59;
    wp::quat_t<wp::float32> var_60;
    wp::transform_t<wp::float32> var_61;
    wp::transform_t<wp::float32> var_62;
    wp::int32 var_63;
    wp::transform_t<wp::float32> var_64;
    wp::int32* var_65;
    wp::int32 var_66;
    wp::int32 var_67;
    bool var_68;
    const wp::int32 var_69 = 8;
    bool var_70;
    const wp::int32 var_71 = 10;
    bool var_72;
    const wp::int32 var_73 = 2;
    bool var_74;
    wp::vec_t<3, wp::float32>* var_75;
    wp::vec_t<3, wp::float32> var_76;
    wp::vec_t<3, wp::float32> var_77;
    wp::vec_t<3, wp::float32> var_78;
    wp::vec_t<3, wp::float32>* var_79;
    wp::uint64* var_80;
    const bool var_81 = false;
    const wp::float32 var_82 = 1000000.0;
    wp::float32 var_83;
    wp::vec_t<3, wp::float32> var_84;
    wp::float32 var_85;
    wp::float32 var_86;
    wp::int32 var_87;
    const wp::int32 var_88 = -1;
    wp::vec_t<3, wp::float32> var_89;
    wp::uint64 var_90;
    wp::vec_t<3, wp::float32>* var_91;
    const bool var_92 = false;
    wp::float32 var_93;
    wp::vec_t<3, wp::float32> var_94;
    wp::vec_t<3, wp::float32> var_95;
    wp::float32 var_96;
    wp::vec_t<3, wp::float32> var_97;
    bool var_98;
    const wp::float32 var_99 = 0.0;
    bool var_100;
    const wp::int32 var_101 = 0;
    wp::float32* var_102;
    bool var_103;
    wp::float32 var_104;
    const wp::int32 var_105 = 0;
    wp::float32 var_106;
    bool var_107;
    const wp::int32 var_108 = 0;
    const wp::int32 var_109 = 0;
    //---------
    // forward
    // def raycast_kernel(                                                                    <L 811>
    // shape_idx = wp.tid()                                                                   <L 855>
    var_0 = builtin_tid1d();
    // if visible_worlds_mask and shape_world.shape[0] > 0:                                   <L 858>
    var_1 = var_visible_worlds_mask;
    if (var_1) {
        var_2 = &(var_shape_world.shape);
        var_5 = wp::load(var_2);
        var_4 = wp::extract(var_5, var_3);
        var_7 = (var_4 > var_6);
        var_1 = var_1 && var_7;
    }
    if (var_1) {
        // world_idx = shape_world[shape_idx]                                                 <L 859>
        var_8 = wp::address(var_shape_world, var_0);
        var_10 = wp::load(var_8);
        var_9 = wp::copy(var_10);
        // if world_idx >= 0:                                                                 <L 860>
        var_12 = (var_9 >= var_11);
        if (var_12) {
            // if visible_worlds_mask[world_idx] == 0:                                        <L 861>
            var_13 = wp::address(var_visible_worlds_mask, var_9);
            var_16 = wp::load(var_13);
            var_15 = (var_16 == var_14);
            if (var_15) {
                // return                                                                     <L 862>
                return;
            }
        }
    }
    // b = shape_body[shape_idx]                                                              <L 865>
    var_17 = wp::address(var_shape_body, var_0);
    var_19 = wp::load(var_17);
    var_18 = wp::copy(var_19);
    // X_wb = wp.transform_identity()                                                         <L 867>
    var_20 = wp::transform_identity<wp::float32>();
    // if b >= 0:                                                                             <L 868>
    var_22 = (var_18 >= var_21);
    if (var_22) {
        // X_wb = body_q[b]                                                                   <L 869>
        var_23 = wp::address(var_body_q, var_18);
        var_25 = wp::load(var_23);
        var_24 = wp::copy(var_25);
    }
    var_26 = wp::where(var_22, var_24, var_20);
    // X_bs = shape_transform[shape_idx]                                                      <L 871>
    var_27 = wp::address(var_shape_transform, var_0);
    var_29 = wp::load(var_27);
    var_28 = wp::copy(var_29);
    // geom_to_world = wp.mul(X_wb, X_bs)                                                     <L 873>
    var_30 = wp::mul(var_26, var_28);
    // if shape_world.shape[0] > 0 and world_offsets.shape[0] > 0:                            <L 876>
    var_32 = &(var_shape_world.shape);
    var_35 = wp::load(var_32);
    var_34 = wp::extract(var_35, var_33);
    var_37 = (var_34 > var_36);
    var_31 = var_37;
    if (var_31) {
        var_38 = &(var_world_offsets.shape);
        var_41 = wp::load(var_38);
        var_40 = wp::extract(var_41, var_39);
        var_43 = (var_40 > var_42);
        var_31 = var_31 && var_43;
    }
    if (var_31) {
        // world_idx = shape_world[shape_idx]                                                 <L 877>
        var_44 = wp::address(var_shape_world, var_0);
        var_46 = wp::load(var_44);
        var_45 = wp::copy(var_46);
        // if world_idx >= 0 and world_idx < world_offsets.shape[0]:                          <L 878>
        var_49 = (var_45 >= var_48);
        var_47 = var_49;
        if (var_47) {
            var_50 = &(var_world_offsets.shape);
            var_53 = wp::load(var_50);
            var_52 = wp::extract(var_53, var_51);
            var_54 = (var_45 < var_52);
            var_47 = var_47 && var_54;
        }
        if (var_47) {
            // offset = world_offsets[world_idx]                                              <L 879>
            var_55 = wp::address(var_world_offsets, var_45);
            var_57 = wp::load(var_55);
            var_56 = wp::copy(var_57);
            // geom_to_world = wp.transform(geom_to_world.p + offset, geom_to_world.q)        <L 880>
            var_58 = wp::transform_get_translation(var_30);
            var_59 = wp::add(var_58, var_56);
            var_60 = wp::transform_get_rotation(var_30);
            var_61 = wp::transform_t<wp::float32>(var_59, var_60);
        }
        var_62 = wp::where(var_47, var_61, var_30);
    }
    var_63 = wp::where(var_31, var_45, var_9);
    var_64 = wp::where(var_31, var_62, var_30);
    // geomtype = geom_type[shape_idx]                                                        <L 882>
    var_65 = wp::address(var_geom_type, var_0);
    var_67 = wp::load(var_65);
    var_66 = wp::copy(var_67);
    // if geomtype == GeoType.MESH or geomtype == GeoType.CONVEX_MESH or geomtype == GeoType.HFIELD:       <L 884>
    var_70 = (var_66 == var_69);
    var_68 = var_70;
    if (!var_68) {
        var_72 = (var_66 == var_71);
        var_68 = var_68 || var_72;
    }
    if (!var_68) {
        var_74 = (var_66 == var_73);
        var_68 = var_68 || var_74;
    }
    if (var_68) {
        // ray_origin_local, ray_direction_local = map_ray_to_local(                          <L 885>
        // geom_to_world, ray_origin, ray_direction, geom_size[shape_idx]                     <L 886>
        var_75 = wp::address(var_geom_size, var_0);
        var_78 = wp::load(var_75);
        map_ray_to_local_0(var_64, var_ray_origin, var_ray_direction, var_78, var_76, var_77);
        // t, _normal, _u, _v, _face = ray_intersect_mesh(                                    <L 888>
        // ray_origin_local,                                                                  <L 889>
        // ray_direction_local,                                                               <L 890>
        // geom_size[shape_idx],                                                              <L 891>
        var_79 = wp::address(var_geom_size, var_0);
        // shape_source_ptr[shape_idx],                                                       <L 892>
        var_80 = wp::address(var_shape_source_ptr, var_0);
        // False,                                                                             <L 893>
        // _DEFAULT_MESH_MAX_T,                                                               <L 894>
        var_89 = wp::load(var_79);
        var_90 = wp::load(var_80);
        _make_ray_intersect_mesh__locals__ray_intersect_mesh_0(var_76, var_77, var_89, var_90, var_81, var_82, var_88, var_83, var_84, var_85, var_86, var_87);
    }
    if (!var_68) {
        // t, _normal = ray_intersect_shape(                                                  <L 897>
        // geom_to_world,                                                                     <L 898>
        // geom_size[shape_idx],                                                              <L 899>
        var_91 = wp::address(var_geom_size, var_0);
        // geomtype,                                                                          <L 900>
        // ray_origin,                                                                        <L 901>
        // ray_direction,                                                                     <L 902>
        // False,                                                                             <L 903>
        var_95 = wp::load(var_91);
        _make_ray_intersect_shape__locals__ray_intersect_shape_0(var_64, var_95, var_66, var_ray_origin, var_ray_direction, var_92, var_93, var_94);
    }
    var_96 = wp::where(var_68, var_83, var_93);
    var_97 = wp::where(var_68, var_84, var_94);
    // if t >= 0.0 and t < min_dist[0]:                                                       <L 906>
    var_100 = (var_96 >= var_99);
    var_98 = var_100;
    if (var_98) {
        var_102 = wp::address(var_min_dist, var_101);
        var_104 = wp::load(var_102);
        var_103 = (var_96 < var_104);
        var_98 = var_98 && var_103;
    }
    if (var_98) {
        // _spinlock_acquire(lock)                                                            <L 907>
        _spinlock_acquire_0(var_lock);
        // old_min = wp.atomic_min(min_dist, 0, t)                                            <L 909>
        var_106 = wp::atomic_min(var_min_dist, var_105, var_96);
        // if t <= old_min:                                                                   <L 910>
        var_107 = (var_96 <= var_106);
        if (var_107) {
            // min_index[0] = shape_idx                                                       <L 911>
            wp::array_store(var_min_index, var_108, var_0);
            // min_body_index[0] = b                                                          <L 912>
            wp::array_store(var_min_body_index, var_109, var_18);
        }
        // _spinlock_release(lock)                                                            <L 913>
        _spinlock_release_0(var_lock);
    }
}



void raycast_kernel_12252ff2_cpu_kernel_backward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_raycast_kernel_12252ff2 *_wp_args,
    wp_args_raycast_kernel_12252ff2 *_wp_adj_args)
{
    //---------
    // argument vars
    wp::array_t<wp::transform_t<wp::float32>> var_body_q = _wp_args->body_q;
    wp::array_t<wp::int32> var_shape_body = _wp_args->shape_body;
    wp::array_t<wp::transform_t<wp::float32>> var_shape_transform = _wp_args->shape_transform;
    wp::array_t<wp::int32> var_geom_type = _wp_args->geom_type;
    wp::array_t<wp::vec_t<3, wp::float32>> var_geom_size = _wp_args->geom_size;
    wp::array_t<wp::uint64> var_shape_source_ptr = _wp_args->shape_source_ptr;
    wp::vec_t<3, wp::float32> var_ray_origin = _wp_args->ray_origin;
    wp::vec_t<3, wp::float32> var_ray_direction = _wp_args->ray_direction;
    wp::array_t<wp::int32> var_lock = _wp_args->lock;
    wp::array_t<wp::float32> var_min_dist = _wp_args->min_dist;
    wp::array_t<wp::int32> var_min_index = _wp_args->min_index;
    wp::array_t<wp::int32> var_min_body_index = _wp_args->min_body_index;
    wp::array_t<wp::int32> var_shape_world = _wp_args->shape_world;
    wp::array_t<wp::vec_t<3, wp::float32>> var_world_offsets = _wp_args->world_offsets;
    wp::array_t<wp::int32> var_visible_worlds_mask = _wp_args->visible_worlds_mask;
    wp::array_t<wp::transform_t<wp::float32>> adj_body_q = _wp_adj_args->body_q;
    wp::array_t<wp::int32> adj_shape_body = _wp_adj_args->shape_body;
    wp::array_t<wp::transform_t<wp::float32>> adj_shape_transform = _wp_adj_args->shape_transform;
    wp::array_t<wp::int32> adj_geom_type = _wp_adj_args->geom_type;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_geom_size = _wp_adj_args->geom_size;
    wp::array_t<wp::uint64> adj_shape_source_ptr = _wp_adj_args->shape_source_ptr;
    wp::vec_t<3, wp::float32> adj_ray_origin = _wp_adj_args->ray_origin;
    wp::vec_t<3, wp::float32> adj_ray_direction = _wp_adj_args->ray_direction;
    wp::array_t<wp::int32> adj_lock = _wp_adj_args->lock;
    wp::array_t<wp::float32> adj_min_dist = _wp_adj_args->min_dist;
    wp::array_t<wp::int32> adj_min_index = _wp_adj_args->min_index;
    wp::array_t<wp::int32> adj_min_body_index = _wp_adj_args->min_body_index;
    wp::array_t<wp::int32> adj_shape_world = _wp_adj_args->shape_world;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_world_offsets = _wp_adj_args->world_offsets;
    wp::array_t<wp::int32> adj_visible_worlds_mask = _wp_adj_args->visible_worlds_mask;
    //---------
    // primal vars
    wp::int32 var_0;
    bool var_1;
    wp::shape_t* var_2;
    const wp::int32 var_3 = 0;
    wp::int32 var_4;
    wp::shape_t var_5;
    const wp::int32 var_6 = 0;
    bool var_7;
    wp::int32* var_8;
    wp::int32 var_9;
    wp::int32 var_10;
    const wp::int32 var_11 = 0;
    bool var_12;
    wp::int32* var_13;
    const wp::int32 var_14 = 0;
    bool var_15;
    wp::int32 var_16;
    wp::int32* var_17;
    wp::int32 var_18;
    wp::int32 var_19;
    wp::transform_t<wp::float32> var_20;
    const wp::int32 var_21 = 0;
    bool var_22;
    wp::transform_t<wp::float32>* var_23;
    wp::transform_t<wp::float32> var_24;
    wp::transform_t<wp::float32> var_25;
    wp::transform_t<wp::float32> var_26;
    wp::transform_t<wp::float32>* var_27;
    wp::transform_t<wp::float32> var_28;
    wp::transform_t<wp::float32> var_29;
    wp::transform_t<wp::float32> var_30;
    bool var_31;
    wp::shape_t* var_32;
    const wp::int32 var_33 = 0;
    wp::int32 var_34;
    wp::shape_t var_35;
    const wp::int32 var_36 = 0;
    bool var_37;
    wp::shape_t* var_38;
    const wp::int32 var_39 = 0;
    wp::int32 var_40;
    wp::shape_t var_41;
    const wp::int32 var_42 = 0;
    bool var_43;
    wp::int32* var_44;
    wp::int32 var_45;
    wp::int32 var_46;
    bool var_47;
    const wp::int32 var_48 = 0;
    bool var_49;
    wp::shape_t* var_50;
    const wp::int32 var_51 = 0;
    wp::int32 var_52;
    wp::shape_t var_53;
    bool var_54;
    wp::vec_t<3, wp::float32>* var_55;
    wp::vec_t<3, wp::float32> var_56;
    wp::vec_t<3, wp::float32> var_57;
    wp::vec_t<3, wp::float32> var_58;
    wp::vec_t<3, wp::float32> var_59;
    wp::quat_t<wp::float32> var_60;
    wp::transform_t<wp::float32> var_61;
    wp::transform_t<wp::float32> var_62;
    wp::int32 var_63;
    wp::transform_t<wp::float32> var_64;
    wp::int32* var_65;
    wp::int32 var_66;
    wp::int32 var_67;
    bool var_68;
    const wp::int32 var_69 = 8;
    bool var_70;
    const wp::int32 var_71 = 10;
    bool var_72;
    const wp::int32 var_73 = 2;
    bool var_74;
    wp::vec_t<3, wp::float32>* var_75;
    wp::vec_t<3, wp::float32> var_76;
    wp::vec_t<3, wp::float32> var_77;
    wp::vec_t<3, wp::float32> var_78;
    wp::vec_t<3, wp::float32>* var_79;
    wp::uint64* var_80;
    const bool var_81 = false;
    const wp::float32 var_82 = 1000000.0;
    wp::float32 var_83;
    wp::vec_t<3, wp::float32> var_84;
    wp::float32 var_85;
    wp::float32 var_86;
    wp::int32 var_87;
    const wp::int32 var_88 = -1;
    wp::vec_t<3, wp::float32> var_89;
    wp::uint64 var_90;
    wp::vec_t<3, wp::float32>* var_91;
    const bool var_92 = false;
    wp::float32 var_93;
    wp::vec_t<3, wp::float32> var_94;
    wp::vec_t<3, wp::float32> var_95;
    wp::float32 var_96;
    wp::vec_t<3, wp::float32> var_97;
    bool var_98;
    const wp::float32 var_99 = 0.0;
    bool var_100;
    const wp::int32 var_101 = 0;
    wp::float32* var_102;
    bool var_103;
    wp::float32 var_104;
    const wp::int32 var_105 = 0;
    wp::float32 var_106;
    bool var_107;
    const wp::int32 var_108 = 0;
    const wp::int32 var_109 = 0;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    bool adj_1 = {};
    wp::shape_t adj_2 = {};
    wp::int32 adj_3 = {};
    wp::int32 adj_4 = {};
    wp::shape_t adj_5 = {};
    wp::int32 adj_6 = {};
    bool adj_7 = {};
    wp::int32 adj_8 = {};
    wp::int32 adj_9 = {};
    wp::int32 adj_10 = {};
    wp::int32 adj_11 = {};
    bool adj_12 = {};
    wp::int32 adj_13 = {};
    wp::int32 adj_14 = {};
    bool adj_15 = {};
    wp::int32 adj_16 = {};
    wp::int32 adj_17 = {};
    wp::int32 adj_18 = {};
    wp::int32 adj_19 = {};
    wp::transform_t<wp::float32> adj_20 = {};
    wp::int32 adj_21 = {};
    bool adj_22 = {};
    wp::transform_t<wp::float32> adj_23 = {};
    wp::transform_t<wp::float32> adj_24 = {};
    wp::transform_t<wp::float32> adj_25 = {};
    wp::transform_t<wp::float32> adj_26 = {};
    wp::transform_t<wp::float32> adj_27 = {};
    wp::transform_t<wp::float32> adj_28 = {};
    wp::transform_t<wp::float32> adj_29 = {};
    wp::transform_t<wp::float32> adj_30 = {};
    bool adj_31 = {};
    wp::shape_t adj_32 = {};
    wp::int32 adj_33 = {};
    wp::int32 adj_34 = {};
    wp::shape_t adj_35 = {};
    wp::int32 adj_36 = {};
    bool adj_37 = {};
    wp::shape_t adj_38 = {};
    wp::int32 adj_39 = {};
    wp::int32 adj_40 = {};
    wp::shape_t adj_41 = {};
    wp::int32 adj_42 = {};
    bool adj_43 = {};
    wp::int32 adj_44 = {};
    wp::int32 adj_45 = {};
    wp::int32 adj_46 = {};
    bool adj_47 = {};
    wp::int32 adj_48 = {};
    bool adj_49 = {};
    wp::shape_t adj_50 = {};
    wp::int32 adj_51 = {};
    wp::int32 adj_52 = {};
    wp::shape_t adj_53 = {};
    bool adj_54 = {};
    wp::vec_t<3, wp::float32> adj_55 = {};
    wp::vec_t<3, wp::float32> adj_56 = {};
    wp::vec_t<3, wp::float32> adj_57 = {};
    wp::vec_t<3, wp::float32> adj_58 = {};
    wp::vec_t<3, wp::float32> adj_59 = {};
    wp::quat_t<wp::float32> adj_60 = {};
    wp::transform_t<wp::float32> adj_61 = {};
    wp::transform_t<wp::float32> adj_62 = {};
    wp::int32 adj_63 = {};
    wp::transform_t<wp::float32> adj_64 = {};
    wp::int32 adj_65 = {};
    wp::int32 adj_66 = {};
    wp::int32 adj_67 = {};
    bool adj_68 = {};
    wp::int32 adj_69 = {};
    bool adj_70 = {};
    wp::int32 adj_71 = {};
    bool adj_72 = {};
    wp::int32 adj_73 = {};
    bool adj_74 = {};
    wp::vec_t<3, wp::float32> adj_75 = {};
    wp::vec_t<3, wp::float32> adj_76 = {};
    wp::vec_t<3, wp::float32> adj_77 = {};
    wp::vec_t<3, wp::float32> adj_78 = {};
    wp::vec_t<3, wp::float32> adj_79 = {};
    wp::uint64 adj_80 = {};
    bool adj_81 = {};
    wp::float32 adj_82 = {};
    wp::float32 adj_83 = {};
    wp::vec_t<3, wp::float32> adj_84 = {};
    wp::float32 adj_85 = {};
    wp::float32 adj_86 = {};
    wp::int32 adj_87 = {};
    wp::int32 adj_88 = {};
    wp::vec_t<3, wp::float32> adj_89 = {};
    wp::uint64 adj_90 = {};
    wp::vec_t<3, wp::float32> adj_91 = {};
    bool adj_92 = {};
    wp::float32 adj_93 = {};
    wp::vec_t<3, wp::float32> adj_94 = {};
    wp::vec_t<3, wp::float32> adj_95 = {};
    wp::float32 adj_96 = {};
    wp::vec_t<3, wp::float32> adj_97 = {};
    bool adj_98 = {};
    wp::float32 adj_99 = {};
    bool adj_100 = {};
    wp::int32 adj_101 = {};
    wp::float32 adj_102 = {};
    bool adj_103 = {};
    wp::float32 adj_104 = {};
    wp::int32 adj_105 = {};
    wp::float32 adj_106 = {};
    bool adj_107 = {};
    wp::int32 adj_108 = {};
    wp::int32 adj_109 = {};
    //---------
    // forward
    // def raycast_kernel(                                                                    <L 811>
    // shape_idx = wp.tid()                                                                   <L 855>
    var_0 = builtin_tid1d();
    // if visible_worlds_mask and shape_world.shape[0] > 0:                                   <L 858>
    var_1 = var_visible_worlds_mask;
    if (var_1) {
        var_2 = &(var_shape_world.shape);
        var_5 = wp::load(var_2);
        var_4 = wp::extract(var_5, var_3);
        var_7 = (var_4 > var_6);
        var_1 = var_1 && var_7;
    }
    if (var_1) {
        // world_idx = shape_world[shape_idx]                                                 <L 859>
        var_8 = wp::address(var_shape_world, var_0);
        var_10 = wp::load(var_8);
        var_9 = wp::copy(var_10);
        // if world_idx >= 0:                                                                 <L 860>
        var_12 = (var_9 >= var_11);
        if (var_12) {
            // if visible_worlds_mask[world_idx] == 0:                                        <L 861>
            var_13 = wp::address(var_visible_worlds_mask, var_9);
            var_16 = wp::load(var_13);
            var_15 = (var_16 == var_14);
            if (var_15) {
                // return                                                                     <L 862>
                goto label0;
            }
        }
    }
    // b = shape_body[shape_idx]                                                              <L 865>
    var_17 = wp::address(var_shape_body, var_0);
    var_19 = wp::load(var_17);
    var_18 = wp::copy(var_19);
    // X_wb = wp.transform_identity()                                                         <L 867>
    var_20 = wp::transform_identity<wp::float32>();
    // if b >= 0:                                                                             <L 868>
    var_22 = (var_18 >= var_21);
    if (var_22) {
        // X_wb = body_q[b]                                                                   <L 869>
        var_23 = wp::address(var_body_q, var_18);
        var_25 = wp::load(var_23);
        var_24 = wp::copy(var_25);
    }
    var_26 = wp::where(var_22, var_24, var_20);
    // X_bs = shape_transform[shape_idx]                                                      <L 871>
    var_27 = wp::address(var_shape_transform, var_0);
    var_29 = wp::load(var_27);
    var_28 = wp::copy(var_29);
    // geom_to_world = wp.mul(X_wb, X_bs)                                                     <L 873>
    var_30 = wp::mul(var_26, var_28);
    // if shape_world.shape[0] > 0 and world_offsets.shape[0] > 0:                            <L 876>
    var_32 = &(var_shape_world.shape);
    var_35 = wp::load(var_32);
    var_34 = wp::extract(var_35, var_33);
    var_37 = (var_34 > var_36);
    var_31 = var_37;
    if (var_31) {
        var_38 = &(var_world_offsets.shape);
        var_41 = wp::load(var_38);
        var_40 = wp::extract(var_41, var_39);
        var_43 = (var_40 > var_42);
        var_31 = var_31 && var_43;
    }
    if (var_31) {
        // world_idx = shape_world[shape_idx]                                                 <L 877>
        var_44 = wp::address(var_shape_world, var_0);
        var_46 = wp::load(var_44);
        var_45 = wp::copy(var_46);
        // if world_idx >= 0 and world_idx < world_offsets.shape[0]:                          <L 878>
        var_49 = (var_45 >= var_48);
        var_47 = var_49;
        if (var_47) {
            var_50 = &(var_world_offsets.shape);
            var_53 = wp::load(var_50);
            var_52 = wp::extract(var_53, var_51);
            var_54 = (var_45 < var_52);
            var_47 = var_47 && var_54;
        }
        if (var_47) {
            // offset = world_offsets[world_idx]                                              <L 879>
            var_55 = wp::address(var_world_offsets, var_45);
            var_57 = wp::load(var_55);
            var_56 = wp::copy(var_57);
            // geom_to_world = wp.transform(geom_to_world.p + offset, geom_to_world.q)        <L 880>
            var_58 = wp::transform_get_translation(var_30);
            var_59 = wp::add(var_58, var_56);
            var_60 = wp::transform_get_rotation(var_30);
            var_61 = wp::transform_t<wp::float32>(var_59, var_60);
        }
        var_62 = wp::where(var_47, var_61, var_30);
    }
    var_63 = wp::where(var_31, var_45, var_9);
    var_64 = wp::where(var_31, var_62, var_30);
    // geomtype = geom_type[shape_idx]                                                        <L 882>
    var_65 = wp::address(var_geom_type, var_0);
    var_67 = wp::load(var_65);
    var_66 = wp::copy(var_67);
    // if geomtype == GeoType.MESH or geomtype == GeoType.CONVEX_MESH or geomtype == GeoType.HFIELD:       <L 884>
    var_70 = (var_66 == var_69);
    var_68 = var_70;
    if (!var_68) {
        var_72 = (var_66 == var_71);
        var_68 = var_68 || var_72;
    }
    if (!var_68) {
        var_74 = (var_66 == var_73);
        var_68 = var_68 || var_74;
    }
    if (var_68) {
        // ray_origin_local, ray_direction_local = map_ray_to_local(                          <L 885>
        // geom_to_world, ray_origin, ray_direction, geom_size[shape_idx]                     <L 886>
        var_75 = wp::address(var_geom_size, var_0);
        var_78 = wp::load(var_75);
        map_ray_to_local_0(var_64, var_ray_origin, var_ray_direction, var_78, var_76, var_77);
        // t, _normal, _u, _v, _face = ray_intersect_mesh(                                    <L 888>
        // ray_origin_local,                                                                  <L 889>
        // ray_direction_local,                                                               <L 890>
        // geom_size[shape_idx],                                                              <L 891>
        var_79 = wp::address(var_geom_size, var_0);
        // shape_source_ptr[shape_idx],                                                       <L 892>
        var_80 = wp::address(var_shape_source_ptr, var_0);
        // False,                                                                             <L 893>
        // _DEFAULT_MESH_MAX_T,                                                               <L 894>
        var_89 = wp::load(var_79);
        var_90 = wp::load(var_80);
        _make_ray_intersect_mesh__locals__ray_intersect_mesh_0(var_76, var_77, var_89, var_90, var_81, var_82, var_88, var_83, var_84, var_85, var_86, var_87);
    }
    if (!var_68) {
        // t, _normal = ray_intersect_shape(                                                  <L 897>
        // geom_to_world,                                                                     <L 898>
        // geom_size[shape_idx],                                                              <L 899>
        var_91 = wp::address(var_geom_size, var_0);
        // geomtype,                                                                          <L 900>
        // ray_origin,                                                                        <L 901>
        // ray_direction,                                                                     <L 902>
        // False,                                                                             <L 903>
        var_95 = wp::load(var_91);
        _make_ray_intersect_shape__locals__ray_intersect_shape_0(var_64, var_95, var_66, var_ray_origin, var_ray_direction, var_92, var_93, var_94);
    }
    var_96 = wp::where(var_68, var_83, var_93);
    var_97 = wp::where(var_68, var_84, var_94);
    // if t >= 0.0 and t < min_dist[0]:                                                       <L 906>
    var_100 = (var_96 >= var_99);
    var_98 = var_100;
    if (var_98) {
        var_102 = wp::address(var_min_dist, var_101);
        var_104 = wp::load(var_102);
        var_103 = (var_96 < var_104);
        var_98 = var_98 && var_103;
    }
    if (var_98) {
        // _spinlock_acquire(lock)                                                            <L 907>
        _spinlock_acquire_0(var_lock);
        // old_min = wp.atomic_min(min_dist, 0, t)                                            <L 909>
        // var_106 = wp::atomic_min(var_min_dist, var_105, var_96);
        // if t <= old_min:                                                                   <L 910>
        var_107 = (var_96 <= var_106);
        if (var_107) {
            // min_index[0] = shape_idx                                                       <L 911>
            // wp::array_store(var_min_index, var_108, var_0);
            // min_body_index[0] = b                                                          <L 912>
            // wp::array_store(var_min_body_index, var_109, var_18);
        }
        // _spinlock_release(lock)                                                            <L 913>
        _spinlock_release_0(var_lock);
    }
    //---------
    // reverse
    if (var_98) {
        adj__spinlock_release_0(var_lock, adj_lock);
        // adj: _spinlock_release(lock)                                                       <L 913>
        if (var_107) {
            wp::adj_array_store(var_min_body_index, var_109, var_18, adj_min_body_index, adj_109, adj_18);
            // adj: min_body_index[0] = b                                                     <L 912>
            wp::adj_array_store(var_min_index, var_108, var_0, adj_min_index, adj_108, adj_0);
            // adj: min_index[0] = shape_idx                                                  <L 911>
        }
        // adj: if t <= old_min:                                                              <L 910>
        wp::adj_atomic_min(var_min_dist, var_105, var_96, adj_min_dist, adj_105, adj_96, adj_106);
        // adj: old_min = wp.atomic_min(min_dist, 0, t)                                       <L 909>
        adj__spinlock_acquire_0(var_lock, adj_lock);
        // adj: _spinlock_acquire(lock)                                                       <L 907>
    }
    if (var_98) {
        wp::adj_address(var_min_dist, var_101, adj_min_dist, adj_101, adj_102);
    }
    // adj: if t >= 0.0 and t < min_dist[0]:                                                  <L 906>
    wp::adj_where(var_68, var_84, var_94, adj_68, adj_84, adj_94, adj_97);
    wp::adj_where(var_68, var_83, var_93, adj_68, adj_83, adj_93, adj_96);
    if (!var_68) {
        adj__make_ray_intersect_shape__locals__ray_intersect_shape_0(var_64, var_95, var_66, var_ray_origin, var_ray_direction, var_92, var_93, var_94, adj_64, adj_91, adj_66, adj_ray_origin, adj_ray_direction, adj_92, adj_93, adj_94);
        // adj: False,                                                                        <L 903>
        // adj: ray_direction,                                                                <L 902>
        // adj: ray_origin,                                                                   <L 901>
        // adj: geomtype,                                                                     <L 900>
        wp::adj_address(var_geom_size, var_0, adj_geom_size, adj_0, adj_91);
        // adj: geom_size[shape_idx],                                                         <L 899>
        // adj: geom_to_world,                                                                <L 898>
        // adj: t, _normal = ray_intersect_shape(                                             <L 897>
    }
    if (var_68) {
        adj__make_ray_intersect_mesh__locals__ray_intersect_mesh_0(var_76, var_77, var_89, var_90, var_81, var_82, var_88, var_83, var_84, var_85, var_86, var_87, adj_76, adj_77, adj_79, adj_80, adj_81, adj_82, adj_88, adj_83, adj_84, adj_85, adj_86, adj_87);
        // adj: _DEFAULT_MESH_MAX_T,                                                          <L 894>
        // adj: False,                                                                        <L 893>
        wp::adj_address(var_shape_source_ptr, var_0, adj_shape_source_ptr, adj_0, adj_80);
        // adj: shape_source_ptr[shape_idx],                                                  <L 892>
        wp::adj_address(var_geom_size, var_0, adj_geom_size, adj_0, adj_79);
        // adj: geom_size[shape_idx],                                                         <L 891>
        // adj: ray_direction_local,                                                          <L 890>
        // adj: ray_origin_local,                                                             <L 889>
        // adj: t, _normal, _u, _v, _face = ray_intersect_mesh(                               <L 888>
        adj_map_ray_to_local_0(var_64, var_ray_origin, var_ray_direction, var_78, var_76, var_77, adj_64, adj_ray_origin, adj_ray_direction, adj_75, adj_76, adj_77);
        wp::adj_address(var_geom_size, var_0, adj_geom_size, adj_0, adj_75);
        // adj: geom_to_world, ray_origin, ray_direction, geom_size[shape_idx]                <L 886>
        // adj: ray_origin_local, ray_direction_local = map_ray_to_local(                     <L 885>
    }
    if (!var_68) {
    }
    if (!var_68) {
    }
    // adj: if geomtype == GeoType.MESH or geomtype == GeoType.CONVEX_MESH or geomtype == GeoType.HFIELD:  <L 884>
    wp::adj_copy(var_67, adj_65, adj_66);
    wp::adj_address(var_geom_type, var_0, adj_geom_type, adj_0, adj_65);
    // adj: geomtype = geom_type[shape_idx]                                                   <L 882>
    wp::adj_where(var_31, var_62, var_30, adj_31, adj_62, adj_30, adj_64);
    wp::adj_where(var_31, var_45, var_9, adj_31, adj_45, adj_9, adj_63);
    if (var_31) {
        wp::adj_where(var_47, var_61, var_30, adj_47, adj_61, adj_30, adj_62);
        if (var_47) {
            wp::adj_transform_t(var_59, var_60, adj_59, adj_60, adj_61);
            wp::adj_transform_get_rotation(var_30, adj_30, adj_60);
            wp::adj_add(var_58, var_56, adj_58, adj_56, adj_59);
            wp::adj_transform_get_translation(var_30, adj_30, adj_58);
            // adj: geom_to_world = wp.transform(geom_to_world.p + offset, geom_to_world.q)   <L 880>
            wp::adj_copy(var_57, adj_55, adj_56);
            wp::adj_address(var_world_offsets, var_45, adj_world_offsets, adj_45, adj_55);
            // adj: offset = world_offsets[world_idx]                                         <L 879>
        }
        if (var_47) {
            adj_world_offsets.shape = adj_50;
        }
        // adj: if world_idx >= 0 and world_idx < world_offsets.shape[0]:                     <L 878>
        wp::adj_copy(var_46, adj_44, adj_45);
        wp::adj_address(var_shape_world, var_0, adj_shape_world, adj_0, adj_44);
        // adj: world_idx = shape_world[shape_idx]                                            <L 877>
    }
    if (var_31) {
        adj_world_offsets.shape = adj_38;
    }
    adj_shape_world.shape = adj_32;
    // adj: if shape_world.shape[0] > 0 and world_offsets.shape[0] > 0:                       <L 876>
    wp::adj_mul(var_26, var_28, adj_26, adj_28, adj_30);
    // adj: geom_to_world = wp.mul(X_wb, X_bs)                                                <L 873>
    wp::adj_copy(var_29, adj_27, adj_28);
    wp::adj_address(var_shape_transform, var_0, adj_shape_transform, adj_0, adj_27);
    // adj: X_bs = shape_transform[shape_idx]                                                 <L 871>
    wp::adj_where(var_22, var_24, var_20, adj_22, adj_24, adj_20, adj_26);
    if (var_22) {
        wp::adj_copy(var_25, adj_23, adj_24);
        wp::adj_address(var_body_q, var_18, adj_body_q, adj_18, adj_23);
        // adj: X_wb = body_q[b]                                                              <L 869>
    }
    // adj: if b >= 0:                                                                        <L 868>
    // adj: X_wb = wp.transform_identity()                                                    <L 867>
    wp::adj_copy(var_19, adj_17, adj_18);
    wp::adj_address(var_shape_body, var_0, adj_shape_body, adj_0, adj_17);
    // adj: b = shape_body[shape_idx]                                                         <L 865>
    if (var_1) {
        if (var_12) {
            if (var_15) {
                label0:;
                // adj: return                                                                <L 862>
            }
            wp::adj_address(var_visible_worlds_mask, var_9, adj_visible_worlds_mask, adj_9, adj_13);
            // adj: if visible_worlds_mask[world_idx] == 0:                                   <L 861>
        }
        // adj: if world_idx >= 0:                                                            <L 860>
        wp::adj_copy(var_10, adj_8, adj_9);
        wp::adj_address(var_shape_world, var_0, adj_shape_world, adj_0, adj_8);
        // adj: world_idx = shape_world[shape_idx]                                            <L 859>
    }
    if (var_1) {
        adj_shape_world.shape = adj_2;
    }
    // adj: if visible_worlds_mask and shape_world.shape[0] > 0:                              <L 858>
    // adj: shape_idx = wp.tid()                                                              <L 855>
    // adj: def raycast_kernel(                                                               <L 811>
    return;
}



extern "C" {

// Python CPU entry points
WP_API void raycast_kernel_12252ff2_cpu_forward(
    wp::launch_bounds_t<1> *dim,
    wp_args_raycast_kernel_12252ff2 *_wp_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        raycast_kernel_12252ff2_cpu_kernel_forward(*dim, task_index, _wp_args);
    }
}

} // extern C



extern "C" {

WP_API void raycast_kernel_12252ff2_cpu_backward(
    wp::launch_bounds_t<1> *dim,
    wp_args_raycast_kernel_12252ff2 *_wp_args,
    wp_args_raycast_kernel_12252ff2 *_wp_adj_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        raycast_kernel_12252ff2_cpu_kernel_backward(*dim, task_index, _wp_args, _wp_adj_args);
    }
}

} // extern C

