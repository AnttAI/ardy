#define WP_NO_BFLOAT16

#define WP_TILE_BLOCK_DIM 128
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


struct ContactData_40360d7c
{
    wp::vec_t<3, wp::float32> contact_point_center;
    wp::vec_t<3, wp::float32> contact_normal_a_to_b;
    wp::float32 contact_distance;
    wp::float32 radius_eff_a;
    wp::float32 radius_eff_b;
    wp::float32 margin_a;
    wp::float32 margin_b;
    wp::int32 shape_a;
    wp::int32 shape_b;
    wp::float32 gap_sum;
    wp::float32 contact_stiffness;
    wp::float32 contact_damping;
    wp::float32 contact_friction_scale;
    wp::int32 sort_sub_key;


    ContactData_40360d7c() = default;
    CUDA_CALLABLE ContactData_40360d7c(wp::vec_t<3, wp::float32> const& contact_point_center,
    wp::vec_t<3, wp::float32> const& contact_normal_a_to_b = {},
    wp::float32 const& contact_distance = {},
    wp::float32 const& radius_eff_a = {},
    wp::float32 const& radius_eff_b = {},
    wp::float32 const& margin_a = {},
    wp::float32 const& margin_b = {},
    wp::int32 const& shape_a = {},
    wp::int32 const& shape_b = {},
    wp::float32 const& gap_sum = {},
    wp::float32 const& contact_stiffness = {},
    wp::float32 const& contact_damping = {},
    wp::float32 const& contact_friction_scale = {},
    wp::int32 const& sort_sub_key = {})
        : contact_point_center{contact_point_center}
        , contact_normal_a_to_b{contact_normal_a_to_b}
        , contact_distance{contact_distance}
        , radius_eff_a{radius_eff_a}
        , radius_eff_b{radius_eff_b}
        , margin_a{margin_a}
        , margin_b{margin_b}
        , shape_a{shape_a}
        , shape_b{shape_b}
        , gap_sum{gap_sum}
        , contact_stiffness{contact_stiffness}
        , contact_damping{contact_damping}
        , contact_friction_scale{contact_friction_scale}
        , sort_sub_key{sort_sub_key}

    {
    }

    CUDA_CALLABLE ContactData_40360d7c& operator += (const ContactData_40360d7c& rhs)
    {    contact_point_center += rhs.contact_point_center;
    contact_normal_a_to_b += rhs.contact_normal_a_to_b;
    contact_distance += rhs.contact_distance;
    radius_eff_a += rhs.radius_eff_a;
    radius_eff_b += rhs.radius_eff_b;
    margin_a += rhs.margin_a;
    margin_b += rhs.margin_b;
    shape_a += rhs.shape_a;
    shape_b += rhs.shape_b;
    gap_sum += rhs.gap_sum;
    contact_stiffness += rhs.contact_stiffness;
    contact_damping += rhs.contact_damping;
    contact_friction_scale += rhs.contact_friction_scale;
    sort_sub_key += rhs.sort_sub_key;

        return *this;}

};

static CUDA_CALLABLE void adj_ContactData_40360d7c(wp::vec_t<3, wp::float32> const&,
    wp::vec_t<3, wp::float32> const&,
    wp::float32 const&,
    wp::float32 const&,
    wp::float32 const&,
    wp::float32 const&,
    wp::float32 const&,
    wp::int32 const&,
    wp::int32 const&,
    wp::float32 const&,
    wp::float32 const&,
    wp::float32 const&,
    wp::float32 const&,
    wp::int32 const&,
    wp::vec_t<3, wp::float32> & adj_contact_point_center,
    wp::vec_t<3, wp::float32> & adj_contact_normal_a_to_b,
    wp::float32 & adj_contact_distance,
    wp::float32 & adj_radius_eff_a,
    wp::float32 & adj_radius_eff_b,
    wp::float32 & adj_margin_a,
    wp::float32 & adj_margin_b,
    wp::int32 & adj_shape_a,
    wp::int32 & adj_shape_b,
    wp::float32 & adj_gap_sum,
    wp::float32 & adj_contact_stiffness,
    wp::float32 & adj_contact_damping,
    wp::float32 & adj_contact_friction_scale,
    wp::int32 & adj_sort_sub_key,
    ContactData_40360d7c & adj_ret)
{
    adj_contact_point_center += adj_ret.contact_point_center;
    adj_contact_normal_a_to_b += adj_ret.contact_normal_a_to_b;
    adj_contact_distance += adj_ret.contact_distance;
    adj_radius_eff_a += adj_ret.radius_eff_a;
    adj_radius_eff_b += adj_ret.radius_eff_b;
    adj_margin_a += adj_ret.margin_a;
    adj_margin_b += adj_ret.margin_b;
    adj_shape_a += adj_ret.shape_a;
    adj_shape_b += adj_ret.shape_b;
    adj_gap_sum += adj_ret.gap_sum;
    adj_contact_stiffness += adj_ret.contact_stiffness;
    adj_contact_damping += adj_ret.contact_damping;
    adj_contact_friction_scale += adj_ret.contact_friction_scale;
    adj_sort_sub_key += adj_ret.sort_sub_key;
}

// Required when compiling adjoints.
CUDA_CALLABLE ContactData_40360d7c add(const ContactData_40360d7c& a, const ContactData_40360d7c& b)
{
    return ContactData_40360d7c();
}

CUDA_CALLABLE void adj_atomic_add(ContactData_40360d7c* p, ContactData_40360d7c t)
{
    wp::adj_atomic_add(&p->contact_point_center, t.contact_point_center);
    wp::adj_atomic_add(&p->contact_normal_a_to_b, t.contact_normal_a_to_b);
    wp::adj_atomic_add(&p->contact_distance, t.contact_distance);
    wp::adj_atomic_add(&p->radius_eff_a, t.radius_eff_a);
    wp::adj_atomic_add(&p->radius_eff_b, t.radius_eff_b);
    wp::adj_atomic_add(&p->margin_a, t.margin_a);
    wp::adj_atomic_add(&p->margin_b, t.margin_b);
    wp::adj_atomic_add(&p->shape_a, t.shape_a);
    wp::adj_atomic_add(&p->shape_b, t.shape_b);
    wp::adj_atomic_add(&p->gap_sum, t.gap_sum);
    wp::adj_atomic_add(&p->contact_stiffness, t.contact_stiffness);
    wp::adj_atomic_add(&p->contact_damping, t.contact_damping);
    wp::adj_atomic_add(&p->contact_friction_scale, t.contact_friction_scale);
    wp::adj_atomic_add(&p->sort_sub_key, t.sort_sub_key);
}




struct ContactWriterData_4222ebad
{
    wp::int32 contact_max;
    wp::array_t<wp::transform_t<wp::float32>> body_q;
    wp::array_t<wp::int32> shape_body;
    wp::array_t<wp::float32> shape_gap;
    wp::array_t<wp::int32> contact_count;
    wp::array_t<wp::int32> out_shape0;
    wp::array_t<wp::int32> out_shape1;
    wp::array_t<wp::vec_t<3, wp::float32>> out_point0;
    wp::array_t<wp::vec_t<3, wp::float32>> out_point1;
    wp::array_t<wp::vec_t<3, wp::float32>> out_offset0;
    wp::array_t<wp::vec_t<3, wp::float32>> out_offset1;
    wp::array_t<wp::vec_t<3, wp::float32>> out_normal;
    wp::array_t<wp::float32> out_margin0;
    wp::array_t<wp::float32> out_margin1;
    wp::array_t<wp::int32> out_tids;
    wp::array_t<wp::float32> out_stiffness;
    wp::array_t<wp::float32> out_damping;
    wp::array_t<wp::float32> out_friction;
    wp::array_t<wp::int64> out_sort_key;
    wp::array_t<wp::transform_t<wp::float32>> shape_transform;
    wp::array_t<wp::vec_t<3, wp::float32>> shape_linear_velocity;
    wp::array_t<wp::vec_t<3, wp::float32>> shape_angular_velocity;
    wp::float32 collision_update_dt;
    wp::float32 max_speculative_extension;


    ContactWriterData_4222ebad() = default;
    CUDA_CALLABLE ContactWriterData_4222ebad(wp::int32 const& contact_max,
    wp::array_t<wp::transform_t<wp::float32>> const& body_q = {},
    wp::array_t<wp::int32> const& shape_body = {},
    wp::array_t<wp::float32> const& shape_gap = {},
    wp::array_t<wp::int32> const& contact_count = {},
    wp::array_t<wp::int32> const& out_shape0 = {},
    wp::array_t<wp::int32> const& out_shape1 = {},
    wp::array_t<wp::vec_t<3, wp::float32>> const& out_point0 = {},
    wp::array_t<wp::vec_t<3, wp::float32>> const& out_point1 = {},
    wp::array_t<wp::vec_t<3, wp::float32>> const& out_offset0 = {},
    wp::array_t<wp::vec_t<3, wp::float32>> const& out_offset1 = {},
    wp::array_t<wp::vec_t<3, wp::float32>> const& out_normal = {},
    wp::array_t<wp::float32> const& out_margin0 = {},
    wp::array_t<wp::float32> const& out_margin1 = {},
    wp::array_t<wp::int32> const& out_tids = {},
    wp::array_t<wp::float32> const& out_stiffness = {},
    wp::array_t<wp::float32> const& out_damping = {},
    wp::array_t<wp::float32> const& out_friction = {},
    wp::array_t<wp::int64> const& out_sort_key = {},
    wp::array_t<wp::transform_t<wp::float32>> const& shape_transform = {},
    wp::array_t<wp::vec_t<3, wp::float32>> const& shape_linear_velocity = {},
    wp::array_t<wp::vec_t<3, wp::float32>> const& shape_angular_velocity = {},
    wp::float32 const& collision_update_dt = {},
    wp::float32 const& max_speculative_extension = {})
        : contact_max{contact_max}
        , body_q{body_q}
        , shape_body{shape_body}
        , shape_gap{shape_gap}
        , contact_count{contact_count}
        , out_shape0{out_shape0}
        , out_shape1{out_shape1}
        , out_point0{out_point0}
        , out_point1{out_point1}
        , out_offset0{out_offset0}
        , out_offset1{out_offset1}
        , out_normal{out_normal}
        , out_margin0{out_margin0}
        , out_margin1{out_margin1}
        , out_tids{out_tids}
        , out_stiffness{out_stiffness}
        , out_damping{out_damping}
        , out_friction{out_friction}
        , out_sort_key{out_sort_key}
        , shape_transform{shape_transform}
        , shape_linear_velocity{shape_linear_velocity}
        , shape_angular_velocity{shape_angular_velocity}
        , collision_update_dt{collision_update_dt}
        , max_speculative_extension{max_speculative_extension}

    {
    }

    CUDA_CALLABLE ContactWriterData_4222ebad& operator += (const ContactWriterData_4222ebad& rhs)
    {    contact_max += rhs.contact_max;
    collision_update_dt += rhs.collision_update_dt;
    max_speculative_extension += rhs.max_speculative_extension;

        return *this;}

};

static CUDA_CALLABLE void adj_ContactWriterData_4222ebad(wp::int32 const&,
    wp::array_t<wp::transform_t<wp::float32>> const&,
    wp::array_t<wp::int32> const&,
    wp::array_t<wp::float32> const&,
    wp::array_t<wp::int32> const&,
    wp::array_t<wp::int32> const&,
    wp::array_t<wp::int32> const&,
    wp::array_t<wp::vec_t<3, wp::float32>> const&,
    wp::array_t<wp::vec_t<3, wp::float32>> const&,
    wp::array_t<wp::vec_t<3, wp::float32>> const&,
    wp::array_t<wp::vec_t<3, wp::float32>> const&,
    wp::array_t<wp::vec_t<3, wp::float32>> const&,
    wp::array_t<wp::float32> const&,
    wp::array_t<wp::float32> const&,
    wp::array_t<wp::int32> const&,
    wp::array_t<wp::float32> const&,
    wp::array_t<wp::float32> const&,
    wp::array_t<wp::float32> const&,
    wp::array_t<wp::int64> const&,
    wp::array_t<wp::transform_t<wp::float32>> const&,
    wp::array_t<wp::vec_t<3, wp::float32>> const&,
    wp::array_t<wp::vec_t<3, wp::float32>> const&,
    wp::float32 const&,
    wp::float32 const&,
    wp::int32 & adj_contact_max,
    wp::array_t<wp::transform_t<wp::float32>> & adj_body_q,
    wp::array_t<wp::int32> & adj_shape_body,
    wp::array_t<wp::float32> & adj_shape_gap,
    wp::array_t<wp::int32> & adj_contact_count,
    wp::array_t<wp::int32> & adj_out_shape0,
    wp::array_t<wp::int32> & adj_out_shape1,
    wp::array_t<wp::vec_t<3, wp::float32>> & adj_out_point0,
    wp::array_t<wp::vec_t<3, wp::float32>> & adj_out_point1,
    wp::array_t<wp::vec_t<3, wp::float32>> & adj_out_offset0,
    wp::array_t<wp::vec_t<3, wp::float32>> & adj_out_offset1,
    wp::array_t<wp::vec_t<3, wp::float32>> & adj_out_normal,
    wp::array_t<wp::float32> & adj_out_margin0,
    wp::array_t<wp::float32> & adj_out_margin1,
    wp::array_t<wp::int32> & adj_out_tids,
    wp::array_t<wp::float32> & adj_out_stiffness,
    wp::array_t<wp::float32> & adj_out_damping,
    wp::array_t<wp::float32> & adj_out_friction,
    wp::array_t<wp::int64> & adj_out_sort_key,
    wp::array_t<wp::transform_t<wp::float32>> & adj_shape_transform,
    wp::array_t<wp::vec_t<3, wp::float32>> & adj_shape_linear_velocity,
    wp::array_t<wp::vec_t<3, wp::float32>> & adj_shape_angular_velocity,
    wp::float32 & adj_collision_update_dt,
    wp::float32 & adj_max_speculative_extension,
    ContactWriterData_4222ebad & adj_ret)
{
    adj_contact_max += adj_ret.contact_max;
    adj_body_q = adj_ret.body_q;
    adj_shape_body = adj_ret.shape_body;
    adj_shape_gap = adj_ret.shape_gap;
    adj_contact_count = adj_ret.contact_count;
    adj_out_shape0 = adj_ret.out_shape0;
    adj_out_shape1 = adj_ret.out_shape1;
    adj_out_point0 = adj_ret.out_point0;
    adj_out_point1 = adj_ret.out_point1;
    adj_out_offset0 = adj_ret.out_offset0;
    adj_out_offset1 = adj_ret.out_offset1;
    adj_out_normal = adj_ret.out_normal;
    adj_out_margin0 = adj_ret.out_margin0;
    adj_out_margin1 = adj_ret.out_margin1;
    adj_out_tids = adj_ret.out_tids;
    adj_out_stiffness = adj_ret.out_stiffness;
    adj_out_damping = adj_ret.out_damping;
    adj_out_friction = adj_ret.out_friction;
    adj_out_sort_key = adj_ret.out_sort_key;
    adj_shape_transform = adj_ret.shape_transform;
    adj_shape_linear_velocity = adj_ret.shape_linear_velocity;
    adj_shape_angular_velocity = adj_ret.shape_angular_velocity;
    adj_collision_update_dt += adj_ret.collision_update_dt;
    adj_max_speculative_extension += adj_ret.max_speculative_extension;
}

// Required when compiling adjoints.
CUDA_CALLABLE ContactWriterData_4222ebad add(const ContactWriterData_4222ebad& a, const ContactWriterData_4222ebad& b)
{
    return ContactWriterData_4222ebad();
}

CUDA_CALLABLE void adj_atomic_add(ContactWriterData_4222ebad* p, ContactWriterData_4222ebad t)
{
    wp::adj_atomic_add(&p->contact_max, t.contact_max);
    wp::adj_atomic_add(&p->body_q, t.body_q);
    wp::adj_atomic_add(&p->shape_body, t.shape_body);
    wp::adj_atomic_add(&p->shape_gap, t.shape_gap);
    wp::adj_atomic_add(&p->contact_count, t.contact_count);
    wp::adj_atomic_add(&p->out_shape0, t.out_shape0);
    wp::adj_atomic_add(&p->out_shape1, t.out_shape1);
    wp::adj_atomic_add(&p->out_point0, t.out_point0);
    wp::adj_atomic_add(&p->out_point1, t.out_point1);
    wp::adj_atomic_add(&p->out_offset0, t.out_offset0);
    wp::adj_atomic_add(&p->out_offset1, t.out_offset1);
    wp::adj_atomic_add(&p->out_normal, t.out_normal);
    wp::adj_atomic_add(&p->out_margin0, t.out_margin0);
    wp::adj_atomic_add(&p->out_margin1, t.out_margin1);
    wp::adj_atomic_add(&p->out_tids, t.out_tids);
    wp::adj_atomic_add(&p->out_stiffness, t.out_stiffness);
    wp::adj_atomic_add(&p->out_damping, t.out_damping);
    wp::adj_atomic_add(&p->out_friction, t.out_friction);
    wp::adj_atomic_add(&p->out_sort_key, t.out_sort_key);
    wp::adj_atomic_add(&p->shape_transform, t.shape_transform);
    wp::adj_atomic_add(&p->shape_linear_velocity, t.shape_linear_velocity);
    wp::adj_atomic_add(&p->shape_angular_velocity, t.shape_angular_velocity);
    wp::adj_atomic_add(&p->collision_update_dt, t.collision_update_dt);
    wp::adj_atomic_add(&p->max_speculative_extension, t.max_speculative_extension);
}




// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/collision_primitive.py:100
static CUDA_CALLABLE void collide_plane_sphere_0(
    wp::vec_t<3, wp::float32> var_plane_normal,
    wp::vec_t<3, wp::float32> var_plane_pos,
    wp::vec_t<3, wp::float32> var_sphere_pos,
    wp::float32 var_sphere_radius,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::float32 var_1;
    wp::float32 var_2;
    const wp::float32 var_3 = 0.5;
    wp::float32 var_4;
    wp::float32 var_5;
    wp::vec_t<3, wp::float32> var_6;
    wp::vec_t<3, wp::float32> var_7;
    //---------
    // forward
    // def collide_plane_sphere(                                                              <L 101>
    // dist = wp.dot(sphere_pos - plane_pos, plane_normal) - sphere_radius                    <L 105>
    var_0 = wp::sub(var_sphere_pos, var_plane_pos);
    var_1 = wp::dot(var_0, var_plane_normal);
    var_2 = wp::sub(var_1, var_sphere_radius);
    // pos = sphere_pos - plane_normal * (sphere_radius + 0.5 * dist)                         <L 106>
    var_4 = wp::mul(var_3, var_2);
    var_5 = wp::add(var_sphere_radius, var_4);
    var_6 = wp::mul(var_plane_normal, var_5);
    var_7 = wp::sub(var_sphere_pos, var_6);
    // return dist, pos                                                                       <L 107>
    ret_0 = var_2;
    ret_1 = var_7;
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/collision_primitive.py:333
static CUDA_CALLABLE void collide_plane_ellipsoid_0(
    wp::vec_t<3, wp::float32> var_plane_normal,
    wp::vec_t<3, wp::float32> var_plane_pos,
    wp::vec_t<3, wp::float32> var_ellipsoid_pos,
    wp::mat_t<3, 3, wp::float32> var_ellipsoid_rot,
    wp::vec_t<3, wp::float32> var_ellipsoid_size,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & ret_2)
{
    //---------
    // primal vars
    wp::mat_t<3, 3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    wp::vec_t<3, wp::float32> var_4;
    wp::vec_t<3, wp::float32> var_5;
    wp::vec_t<3, wp::float32> var_6;
    wp::vec_t<3, wp::float32> var_7;
    wp::vec_t<3, wp::float32> var_8;
    wp::float32 var_9;
    wp::vec_t<3, wp::float32> var_10;
    const wp::float32 var_11 = 0.5;
    wp::vec_t<3, wp::float32> var_12;
    wp::vec_t<3, wp::float32> var_13;
    //---------
    // forward
    // def collide_plane_ellipsoid(                                                           <L 334>
    // sphere_support = -wp.normalize(wp.cw_mul(wp.transpose(ellipsoid_rot) @ plane_normal, ellipsoid_size))       <L 357>
    var_0 = wp::transpose(var_ellipsoid_rot);
    var_1 = wp::mul(var_0, var_plane_normal);
    var_2 = wp::cw_mul(var_1, var_ellipsoid_size);
    var_3 = wp::normalize(var_2);
    var_4 = wp::neg(var_3);
    // pos = ellipsoid_pos + ellipsoid_rot @ wp.cw_mul(sphere_support, ellipsoid_size)        <L 358>
    var_5 = wp::cw_mul(var_4, var_ellipsoid_size);
    var_6 = wp::mul(var_ellipsoid_rot, var_5);
    var_7 = wp::add(var_ellipsoid_pos, var_6);
    // dist = wp.dot(plane_normal, pos - plane_pos)                                           <L 359>
    var_8 = wp::sub(var_7, var_plane_pos);
    var_9 = wp::dot(var_plane_normal, var_8);
    // pos = pos - plane_normal * dist * 0.5                                                  <L 360>
    var_10 = wp::mul(var_plane_normal, var_9);
    var_12 = wp::mul(var_10, var_11);
    var_13 = wp::sub(var_7, var_12);
    // return dist, pos, plane_normal                                                         <L 362>
    ret_0 = var_9;
    ret_1 = var_13;
    ret_2 = var_plane_normal;
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/collision_primitive.py:365
static CUDA_CALLABLE void collide_plane_box_0(
    wp::vec_t<3, wp::float32> var_plane_normal,
    wp::vec_t<3, wp::float32> var_plane_pos,
    wp::vec_t<3, wp::float32> var_box_pos,
    wp::mat_t<3, 3, wp::float32> var_box_rot,
    wp::vec_t<3, wp::float32> var_box_size,
    wp::float32 var_margin,
    wp::vec_t<4, wp::float32> & ret_0,
    wp::mat_t<4, 3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & ret_2)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::float32 var_2;
    const wp::float32 var_3 = 10000000000.0;
    wp::vec_t<4, wp::float32> var_4;
    wp::mat_t<4, 3, wp::float32> var_5;
    const wp::int32 var_6 = 0;
    wp::int32 var_7;
    const wp::int32 var_8 = 0;
    wp::int32 var_9;
    const wp::int32 var_10 = 8;
    wp::range_t var_11;
    wp::int32 var_12;
    const wp::int32 var_13 = 1;
    wp::int32 var_14;
    const wp::int32 var_15 = 0;
    bool var_16;
    const wp::int32 var_17 = 0;
    wp::float32 var_18;
    const wp::int32 var_19 = 0;
    wp::float32 var_20;
    wp::float32 var_21;
    wp::float32 var_22;
    const wp::int32 var_23 = 0;
    const wp::int32 var_24 = 2;
    wp::int32 var_25;
    const wp::int32 var_26 = 0;
    bool var_27;
    const wp::int32 var_28 = 1;
    wp::float32 var_29;
    const wp::int32 var_30 = 1;
    wp::float32 var_31;
    wp::float32 var_32;
    wp::float32 var_33;
    const wp::int32 var_34 = 1;
    const wp::int32 var_35 = 4;
    wp::int32 var_36;
    const wp::int32 var_37 = 0;
    bool var_38;
    const wp::int32 var_39 = 2;
    wp::float32 var_40;
    const wp::int32 var_41 = 2;
    wp::float32 var_42;
    wp::float32 var_43;
    wp::float32 var_44;
    const wp::int32 var_45 = 2;
    wp::vec_t<3, wp::float32> var_46;
    wp::float32 var_47;
    wp::float32 var_48;
    bool var_49;
    wp::vec_t<3, wp::float32> var_50;
    wp::vec_t<3, wp::float32> var_51;
    const wp::float32 var_52 = 0.5;
    wp::vec_t<3, wp::float32> var_53;
    wp::vec_t<3, wp::float32> var_54;
    wp::vec_t<3, wp::float32> var_55;
    const wp::int32 var_56 = 4;
    bool var_57;
    bool var_58;
    const wp::int32 var_59 = 0;
    bool var_60;
    wp::float32 var_61;
    bool var_62;
    wp::int32 var_63;
    wp::int32 var_64;
    const wp::int32 var_65 = 1;
    wp::int32 var_66;
    wp::float32 var_67;
    bool var_68;
    const wp::int32 var_69 = 0;
    const wp::int32 var_70 = 1;
    wp::float32 var_71;
    wp::float32 var_72;
    bool var_73;
    const wp::int32 var_74 = 1;
    wp::int32 var_75;
    const wp::int32 var_76 = 2;
    wp::float32 var_77;
    wp::float32 var_78;
    bool var_79;
    const wp::int32 var_80 = 2;
    wp::int32 var_81;
    const wp::int32 var_82 = 3;
    wp::float32 var_83;
    wp::float32 var_84;
    bool var_85;
    const wp::int32 var_86 = 3;
    wp::int32 var_87;
    wp::int32 var_88;
    wp::int32 var_89;
    wp::int32 var_90;
    //---------
    // forward
    // def collide_plane_box(                                                                 <L 366>
    // corner = wp.vec3()                                                                     <L 392>
    var_0 = wp::vec_t<3, wp::float32>();
    // center_dist = wp.dot(box_pos - plane_pos, plane_normal)                                <L 393>
    var_1 = wp::sub(var_box_pos, var_plane_pos);
    var_2 = wp::dot(var_1, var_plane_normal);
    // dist = wp.vec4(MAXVAL)                                                                 <L 395>
    var_4 = wp::vec_t<4, wp::float32>(var_3);
    // pos = _mat43f()                                                                        <L 396>
    var_5 = wp::mat_t<4, 3, wp::float32>();
    // ncontact = wp.int32(0)                                                                 <L 400>
    var_7 = wp::int32(var_6);
    // worst_idx = wp.int32(0)                                                                <L 401>
    var_9 = wp::int32(var_8);
    // for i in range(8):                                                                     <L 402>
    var_11 = wp::range(var_10);
    start_for_0:;
        if (iter_cmp(var_11) == 0) goto end_for_0;
        var_12 = wp::iter_next(var_11);
        // corner.x = wp.where((i & 1) != 0, box_size.x, -box_size.x)                         <L 404>
        var_14 = wp::bit_and(var_12, var_13);
        var_16 = (var_14 != var_15);
        var_18 = wp::extract(var_box_size, var_17);
        var_20 = wp::extract(var_box_size, var_19);
        var_21 = wp::neg(var_20);
        var_22 = wp::where(var_16, var_18, var_21);
        wp::assign_inplace(var_0, var_23, var_22);
        // corner.y = wp.where((i & 2) != 0, box_size.y, -box_size.y)                         <L 405>
        var_25 = wp::bit_and(var_12, var_24);
        var_27 = (var_25 != var_26);
        var_29 = wp::extract(var_box_size, var_28);
        var_31 = wp::extract(var_box_size, var_30);
        var_32 = wp::neg(var_31);
        var_33 = wp::where(var_27, var_29, var_32);
        wp::assign_inplace(var_0, var_34, var_33);
        // corner.z = wp.where((i & 4) != 0, box_size.z, -box_size.z)                         <L 406>
        var_36 = wp::bit_and(var_12, var_35);
        var_38 = (var_36 != var_37);
        var_40 = wp::extract(var_box_size, var_39);
        var_42 = wp::extract(var_box_size, var_41);
        var_43 = wp::neg(var_42);
        var_44 = wp::where(var_38, var_40, var_43);
        wp::assign_inplace(var_0, var_45, var_44);
        // corner = box_rot @ corner                                                          <L 409>
        var_46 = wp::mul(var_box_rot, var_0);
        // ldist = wp.dot(plane_normal, corner)                                               <L 412>
        var_47 = wp::dot(var_plane_normal, var_46);
        // cdist = center_dist + ldist                                                        <L 413>
        var_48 = wp::add(var_2, var_47);
        // if cdist > margin:                                                                 <L 414>
        var_49 = (var_48 > var_margin);
        if (var_49) {
            // continue                                                                       <L 415>
            wp::assign(var_0, var_46);
            goto start_for_0;
        }
        var_50 = wp::where(var_49, var_0, var_46);
        // cpos = corner + box_pos - 0.5 * plane_normal * cdist                               <L 417>
        var_51 = wp::add(var_50, var_box_pos);
        var_53 = wp::mul(var_52, var_plane_normal);
        var_54 = wp::mul(var_53, var_48);
        var_55 = wp::sub(var_51, var_54);
        // if ncontact < 4:                                                                   <L 419>
        var_57 = (var_7 < var_56);
        if (var_57) {
            // dist[ncontact] = cdist                                                         <L 420>
            wp::assign_inplace(var_4, var_7, var_48);
            // pos[ncontact] = cpos                                                           <L 421>
            wp::assign_inplace(var_5, var_7, var_55);
            // if ncontact == 0 or cdist > dist[worst_idx]:                                   <L 422>
            var_60 = (var_7 == var_59);
            var_58 = var_60;
            if (!var_58) {
                var_61 = wp::extract(var_4, var_9);
                var_62 = (var_48 > var_61);
                var_58 = var_58 || var_62;
            }
            if (var_58) {
                // worst_idx = ncontact                                                       <L 423>
                var_63 = wp::copy(var_7);
            }
            var_64 = wp::where(var_58, var_63, var_9);
            // ncontact += 1                                                                  <L 424>
            var_66 = wp::add(var_7, var_65);
        }
        if (!var_57) {
            // if cdist < dist[worst_idx]:                                                    <L 426>
            var_67 = wp::extract(var_4, var_9);
            var_68 = (var_48 < var_67);
            if (var_68) {
                // dist[worst_idx] = cdist                                                    <L 427>
                wp::assign_inplace(var_4, var_9, var_48);
                // pos[worst_idx] = cpos                                                      <L 428>
                wp::assign_inplace(var_5, var_9, var_55);
                // worst_idx = 0                                                              <L 431>
                // if dist[1] > dist[worst_idx]:                                              <L 432>
                var_71 = wp::extract(var_4, var_70);
                var_72 = wp::extract(var_4, var_69);
                var_73 = (var_71 > var_72);
                if (var_73) {
                    // worst_idx = 1                                                          <L 433>
                }
                var_75 = wp::where(var_73, var_74, var_69);
                // if dist[2] > dist[worst_idx]:                                              <L 434>
                var_77 = wp::extract(var_4, var_76);
                var_78 = wp::extract(var_4, var_75);
                var_79 = (var_77 > var_78);
                if (var_79) {
                    // worst_idx = 2                                                          <L 435>
                }
                var_81 = wp::where(var_79, var_80, var_75);
                // if dist[3] > dist[worst_idx]:                                              <L 436>
                var_83 = wp::extract(var_4, var_82);
                var_84 = wp::extract(var_4, var_81);
                var_85 = (var_83 > var_84);
                if (var_85) {
                    // worst_idx = 3                                                          <L 437>
                }
                var_87 = wp::where(var_85, var_86, var_81);
            }
            var_88 = wp::where(var_68, var_87, var_9);
        }
        var_89 = wp::where(var_57, var_66, var_7);
        var_90 = wp::where(var_57, var_64, var_88);
        wp::assign(var_0, var_50);
        wp::assign(var_7, var_89);
        wp::assign(var_9, var_90);
        goto start_for_0;
    end_for_0:;
    // return dist, pos, plane_normal                                                         <L 439>
    ret_0 = var_4;
    ret_1 = var_5;
    ret_2 = var_plane_normal;
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/collision_primitive.py:110
static CUDA_CALLABLE void collide_sphere_sphere_0(
    wp::vec_t<3, wp::float32> var_pos1,
    wp::float32 var_radius1,
    wp::vec_t<3, wp::float32> var_pos2,
    wp::float32 var_radius2,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & ret_2)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::float32 var_1;
    const wp::float32 var_2 = 0.0;
    bool var_3;
    const wp::float32 var_4 = 1.0;
    const wp::float32 var_5 = 0.0;
    const wp::float32 var_6 = 0.0;
    wp::vec_t<3, wp::float32> var_7;
    wp::vec_t<3, wp::float32> var_8;
    wp::vec_t<3, wp::float32> var_9;
    wp::float32 var_10;
    wp::float32 var_11;
    const wp::float32 var_12 = 0.5;
    wp::float32 var_13;
    wp::float32 var_14;
    wp::vec_t<3, wp::float32> var_15;
    wp::vec_t<3, wp::float32> var_16;
    //---------
    // forward
    // def collide_sphere_sphere(                                                             <L 111>
    // dir = pos2 - pos1                                                                      <L 132>
    var_0 = wp::sub(var_pos2, var_pos1);
    // dist = wp.length(dir)                                                                  <L 133>
    var_1 = wp::length(var_0);
    // if dist == 0.0:                                                                        <L 134>
    var_3 = (var_1 == var_2);
    if (var_3) {
        // n = wp.vec3(1.0, 0.0, 0.0)                                                         <L 135>
        var_7 = wp::vec_t<3, wp::float32>(var_4, var_5, var_6);
    }
    if (!var_3) {
        // n = dir / dist                                                                     <L 137>
        var_8 = wp::div(var_0, var_1);
    }
    var_9 = wp::where(var_3, var_7, var_8);
    // dist = dist - (radius1 + radius2)                                                      <L 138>
    var_10 = wp::add(var_radius1, var_radius2);
    var_11 = wp::sub(var_1, var_10);
    // pos = pos1 + n * (radius1 + 0.5 * dist)                                                <L 139>
    var_13 = wp::mul(var_12, var_11);
    var_14 = wp::add(var_radius1, var_13);
    var_15 = wp::mul(var_9, var_14);
    var_16 = wp::add(var_pos1, var_15);
    // return dist, pos, n                                                                    <L 140>
    ret_0 = var_11;
    ret_1 = var_16;
    ret_2 = var_9;
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/math/__init__.py:0
static CUDA_CALLABLE void normalize_with_norm_0(
    wp::vec_t<3, wp::float32> var_x,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::float32 & ret_1)
{
    //---------
    // primal vars
    wp::float32 var_0;
    const wp::float32 var_1 = 0.0;
    bool var_2;
    const wp::float32 var_3 = 0.0;
    wp::vec_t<3, wp::float32> var_4;
    //---------
    // forward
    // def normalize_with_norm(x: Any):                                                       <L 1>
    // norm = wp.length(x)                                                                    <L 13>
    var_0 = wp::length(var_x);
    // if norm == 0.0:                                                                        <L 14>
    var_2 = (var_0 == var_1);
    if (var_2) {
        // return x, 0.0                                                                      <L 15>
        ret_0 = var_x;
        ret_1 = var_3;
        return;
    }
    // return x / norm, norm                                                                  <L 16>
    var_4 = wp::div(var_x, var_0);
    ret_0 = var_4;
    ret_1 = var_0;
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/collision_primitive.py:278
static CUDA_CALLABLE void collide_plane_capsule_0(
    wp::vec_t<3, wp::float32> var_plane_normal,
    wp::vec_t<3, wp::float32> var_plane_pos,
    wp::vec_t<3, wp::float32> var_capsule_pos,
    wp::vec_t<3, wp::float32> var_capsule_axis,
    wp::float32 var_capsule_radius,
    wp::float32 var_capsule_half_length,
    wp::vec_t<2, wp::float32> & ret_0,
    wp::mat_t<2, 3, wp::float32> & ret_1,
    wp::mat_t<3, 3, wp::float32> & ret_2)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::float32 var_2;
    wp::vec_t<3, wp::float32> var_3;
    wp::vec_t<3, wp::float32> var_4;
    wp::vec_t<3, wp::float32> var_5;
    wp::float32 var_6;
    const wp::float32 var_7 = 0.5;
    bool var_8;
    bool var_9;
    const wp::float32 var_10 = -0.5;
    const wp::int32 var_11 = 1;
    wp::float32 var_12;
    bool var_13;
    const wp::int32 var_14 = 1;
    wp::float32 var_15;
    const wp::float32 var_16 = 0.5;
    bool var_17;
    const wp::float32 var_18 = 0.0;
    const wp::float32 var_19 = 1.0;
    const wp::float32 var_20 = 0.0;
    wp::vec_t<3, wp::float32> var_21;
    const wp::float32 var_22 = 0.0;
    const wp::float32 var_23 = 0.0;
    const wp::float32 var_24 = 1.0;
    wp::vec_t<3, wp::float32> var_25;
    wp::vec_t<3, wp::float32> var_26;
    wp::vec_t<3, wp::float32> var_27;
    wp::vec_t<3, wp::float32> var_28;
    const wp::int32 var_29 = 0;
    wp::float32 var_30;
    const wp::int32 var_31 = 1;
    wp::float32 var_32;
    const wp::int32 var_33 = 2;
    wp::float32 var_34;
    const wp::int32 var_35 = 0;
    wp::float32 var_36;
    const wp::int32 var_37 = 1;
    wp::float32 var_38;
    const wp::int32 var_39 = 2;
    wp::float32 var_40;
    const wp::int32 var_41 = 0;
    wp::float32 var_42;
    const wp::int32 var_43 = 1;
    wp::float32 var_44;
    const wp::int32 var_45 = 2;
    wp::float32 var_46;
    wp::mat_t<3, 3, wp::float32> var_47;
    wp::vec_t<3, wp::float32> var_48;
    wp::vec_t<3, wp::float32> var_49;
    wp::float32 var_50;
    wp::vec_t<3, wp::float32> var_51;
    wp::vec_t<3, wp::float32> var_52;
    wp::float32 var_53;
    wp::vec_t<3, wp::float32> var_54;
    wp::vec_t<2, wp::float32> var_55;
    const wp::int32 var_56 = 0;
    wp::float32 var_57;
    const wp::int32 var_58 = 1;
    wp::float32 var_59;
    const wp::int32 var_60 = 2;
    wp::float32 var_61;
    const wp::int32 var_62 = 0;
    wp::float32 var_63;
    const wp::int32 var_64 = 1;
    wp::float32 var_65;
    const wp::int32 var_66 = 2;
    wp::float32 var_67;
    wp::mat_t<2, 3, wp::float32> var_68;
    //---------
    // forward
    // def collide_plane_capsule(                                                             <L 279>
    // n = plane_normal                                                                       <L 305>
    var_0 = wp::copy(var_plane_normal);
    // axis = capsule_axis                                                                    <L 306>
    var_1 = wp::copy(var_capsule_axis);
    // b, b_norm = normalize_with_norm(axis - n * wp.dot(n, axis))                            <L 309>
    var_2 = wp::dot(var_0, var_1);
    var_3 = wp::mul(var_0, var_2);
    var_4 = wp::sub(var_1, var_3);
    normalize_with_norm_0(var_4, var_5, var_6);
    // if b_norm < 0.5:                                                                       <L 311>
    var_8 = (var_6 < var_7);
    if (var_8) {
        // if -0.5 < n[1] and n[1] < 0.5:                                                     <L 312>
        var_12 = wp::extract(var_0, var_11);
        var_13 = (var_10 < var_12);
        var_9 = var_13;
        if (var_9) {
            var_15 = wp::extract(var_0, var_14);
            var_17 = (var_15 < var_16);
            var_9 = var_9 && var_17;
        }
        if (var_9) {
            // b = wp.vec3(0.0, 1.0, 0.0)                                                     <L 313>
            var_21 = wp::vec_t<3, wp::float32>(var_18, var_19, var_20);
        }
        if (!var_9) {
            // b = wp.vec3(0.0, 0.0, 1.0)                                                     <L 315>
            var_25 = wp::vec_t<3, wp::float32>(var_22, var_23, var_24);
        }
        var_26 = wp::where(var_9, var_21, var_25);
    }
    var_27 = wp::where(var_8, var_26, var_5);
    // c = wp.cross(n, b)                                                                     <L 317>
    var_28 = wp::cross(var_0, var_27);
    // frame = wp.mat33(n[0], n[1], n[2], b[0], b[1], b[2], c[0], c[1], c[2])                 <L 318>
    var_30 = wp::extract(var_0, var_29);
    var_32 = wp::extract(var_0, var_31);
    var_34 = wp::extract(var_0, var_33);
    var_36 = wp::extract(var_27, var_35);
    var_38 = wp::extract(var_27, var_37);
    var_40 = wp::extract(var_27, var_39);
    var_42 = wp::extract(var_28, var_41);
    var_44 = wp::extract(var_28, var_43);
    var_46 = wp::extract(var_28, var_45);
    var_47 = wp::mat_t<3, 3, wp::float32>(var_30, var_32, var_34, var_36, var_38, var_40, var_42, var_44, var_46);
    // segment = axis * capsule_half_length                                                   <L 319>
    var_48 = wp::mul(var_1, var_capsule_half_length);
    // dist1, pos1 = collide_plane_sphere(n, plane_pos, capsule_pos + segment, capsule_radius)       <L 322>
    var_49 = wp::add(var_capsule_pos, var_48);
    collide_plane_sphere_0(var_0, var_plane_pos, var_49, var_capsule_radius, var_50, var_51);
    // dist2, pos2 = collide_plane_sphere(n, plane_pos, capsule_pos - segment, capsule_radius)       <L 325>
    var_52 = wp::sub(var_capsule_pos, var_48);
    collide_plane_sphere_0(var_0, var_plane_pos, var_52, var_capsule_radius, var_53, var_54);
    // dist = wp.vec2(dist1, dist2)                                                           <L 327>
    var_55 = wp::vec_t<2, wp::float32>(var_50, var_53);
    // pos = _mat23f(pos1[0], pos1[1], pos1[2], pos2[0], pos2[1], pos2[2])                    <L 328>
    var_57 = wp::extract(var_51, var_56);
    var_59 = wp::extract(var_51, var_58);
    var_61 = wp::extract(var_51, var_60);
    var_63 = wp::extract(var_54, var_62);
    var_65 = wp::extract(var_54, var_64);
    var_67 = wp::extract(var_54, var_66);
    var_68 = wp::mat_t<2, 3, wp::float32>({var_57, var_59, var_61, var_63, var_65, var_67});
    // return dist, pos, frame                                                                <L 330>
    ret_0 = var_55;
    ret_1 = var_68;
    ret_2 = var_47;
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/collision_primitive.py:515
static CUDA_CALLABLE void collide_plane_cylinder_0(
    wp::vec_t<3, wp::float32> var_plane_normal,
    wp::vec_t<3, wp::float32> var_plane_pos,
    wp::vec_t<3, wp::float32> var_cylinder_pos,
    wp::vec_t<3, wp::float32> var_cylinder_axis,
    wp::float32 var_cylinder_radius,
    wp::float32 var_cylinder_half_height,
    wp::vec_t<4, wp::float32> & ret_0,
    wp::mat_t<4, 3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & ret_2)
{
    //---------
    // primal vars
    const wp::float32 var_0 = 10000000000.0;
    wp::vec_t<4, wp::float32> var_1;
    wp::mat_t<4, 3, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    wp::vec_t<3, wp::float32> var_4;
    wp::float32 var_5;
    const wp::float32 var_6 = 0.0;
    bool var_7;
    wp::vec_t<3, wp::float32> var_8;
    wp::float32 var_9;
    wp::vec_t<3, wp::float32> var_10;
    wp::float32 var_11;
    wp::vec_t<3, wp::float32> var_12;
    wp::vec_t<3, wp::float32> var_13;
    wp::vec_t<3, wp::float32> var_14;
    wp::vec_t<3, wp::float32> var_15;
    wp::vec_t<3, wp::float32> var_16;
    wp::float32 var_17;
    const wp::float32 var_18 = 1e-10;
    bool var_19;
    const wp::float32 var_20 = 1.0;
    wp::float32 var_21;
    wp::float32 var_22;
    wp::vec_t<3, wp::float32> var_23;
    wp::vec_t<3, wp::float32> var_24;
    const wp::float32 var_25 = 1.0;
    const wp::float32 var_26 = 0.0;
    const wp::float32 var_27 = 0.0;
    wp::vec_t<3, wp::float32> var_28;
    wp::float32 var_29;
    wp::float32 var_30;
    const wp::float32 var_31 = 0.9;
    bool var_32;
    const wp::float32 var_33 = 0.0;
    const wp::float32 var_34 = 1.0;
    const wp::float32 var_35 = 0.0;
    wp::vec_t<3, wp::float32> var_36;
    wp::vec_t<3, wp::float32> var_37;
    wp::float32 var_38;
    wp::vec_t<3, wp::float32> var_39;
    wp::vec_t<3, wp::float32> var_40;
    wp::vec_t<3, wp::float32> var_41;
    wp::float32 var_42;
    const wp::float32 var_43 = 0.9238795325112867;
    bool var_44;
    wp::vec_t<3, wp::float32> var_45;
    wp::vec_t<3, wp::float32> var_46;
    wp::vec_t<3, wp::float32> var_47;
    wp::vec_t<3, wp::float32> var_48;
    wp::float32 var_49;
    const wp::float32 var_50 = 0.5;
    wp::float32 var_51;
    wp::vec_t<3, wp::float32> var_52;
    wp::vec_t<3, wp::float32> var_53;
    const wp::int32 var_54 = 0;
    const wp::int32 var_55 = 0;
    const wp::int32 var_56 = 1;
    wp::int32 var_57;
    const wp::float32 var_58 = 0.01;
    wp::float32 var_59;
    wp::float32 var_60;
    wp::float32 var_61;
    wp::vec_t<3, wp::float32> var_62;
    wp::vec_t<3, wp::float32> var_63;
    wp::vec_t<3, wp::float32> var_64;
    const wp::float32 var_65 = -0.5;
    wp::float32 var_66;
    const wp::float32 var_67 = 0.8660254;
    wp::float32 var_68;
    wp::vec_t<3, wp::float32> var_69;
    wp::vec_t<3, wp::float32> var_70;
    wp::float32 var_71;
    const wp::float32 var_72 = 0.5;
    wp::float32 var_73;
    wp::vec_t<3, wp::float32> var_74;
    wp::vec_t<3, wp::float32> var_75;
    bool var_76;
    const wp::int32 var_77 = 4;
    bool var_78;
    wp::vec_t<3, wp::float32> var_79;
    wp::float32 var_80;
    bool var_81;
    const wp::int32 var_82 = 1;
    wp::int32 var_83;
    wp::int32 var_84;
    wp::vec_t<3, wp::float32> var_85;
    wp::vec_t<3, wp::float32> var_86;
    wp::vec_t<3, wp::float32> var_87;
    wp::vec_t<3, wp::float32> var_88;
    wp::vec_t<3, wp::float32> var_89;
    wp::float32 var_90;
    const wp::float32 var_91 = 0.5;
    wp::float32 var_92;
    wp::vec_t<3, wp::float32> var_93;
    wp::vec_t<3, wp::float32> var_94;
    bool var_95;
    const wp::int32 var_96 = 4;
    bool var_97;
    wp::vec_t<3, wp::float32> var_98;
    wp::float32 var_99;
    bool var_100;
    const wp::int32 var_101 = 1;
    wp::int32 var_102;
    wp::int32 var_103;
    wp::vec_t<3, wp::float32> var_104;
    wp::vec_t<3, wp::float32> var_105;
    wp::vec_t<3, wp::float32> var_106;
    wp::vec_t<3, wp::float32> var_107;
    wp::vec_t<3, wp::float32> var_108;
    wp::float32 var_109;
    const wp::float32 var_110 = 0.5;
    wp::float32 var_111;
    wp::vec_t<3, wp::float32> var_112;
    wp::vec_t<3, wp::float32> var_113;
    bool var_114;
    const wp::int32 var_115 = 4;
    bool var_116;
    wp::vec_t<3, wp::float32> var_117;
    wp::float32 var_118;
    bool var_119;
    const wp::int32 var_120 = 1;
    wp::int32 var_121;
    wp::int32 var_122;
    wp::vec_t<3, wp::float32> var_123;
    wp::vec_t<3, wp::float32> var_124;
    wp::vec_t<3, wp::float32> var_125;
    wp::vec_t<3, wp::float32> var_126;
    wp::vec_t<3, wp::float32> var_127;
    wp::vec_t<3, wp::float32> var_128;
    wp::vec_t<3, wp::float32> var_129;
    wp::vec_t<3, wp::float32> var_130;
    wp::float32 var_131;
    const wp::float32 var_132 = 0.5;
    wp::float32 var_133;
    wp::vec_t<3, wp::float32> var_134;
    wp::vec_t<3, wp::float32> var_135;
    bool var_136;
    const wp::int32 var_137 = 4;
    bool var_138;
    wp::vec_t<3, wp::float32> var_139;
    wp::float32 var_140;
    bool var_141;
    const wp::int32 var_142 = 1;
    wp::int32 var_143;
    wp::int32 var_144;
    wp::vec_t<3, wp::float32> var_145;
    wp::vec_t<3, wp::float32> var_146;
    wp::vec_t<3, wp::float32> var_147;
    wp::vec_t<3, wp::float32> var_148;
    wp::float32 var_149;
    const wp::float32 var_150 = 0.5;
    wp::float32 var_151;
    wp::vec_t<3, wp::float32> var_152;
    wp::vec_t<3, wp::float32> var_153;
    bool var_154;
    const wp::int32 var_155 = 4;
    bool var_156;
    wp::vec_t<3, wp::float32> var_157;
    wp::float32 var_158;
    bool var_159;
    const wp::int32 var_160 = 1;
    wp::int32 var_161;
    wp::int32 var_162;
    wp::vec_t<3, wp::float32> var_163;
    wp::vec_t<3, wp::float32> var_164;
    wp::float32 var_165;
    wp::vec_t<3, wp::float32> var_166;
    wp::vec_t<3, wp::float32> var_167;
    wp::float32 var_168;
    bool var_169;
    wp::vec_t<3, wp::float32> var_170;
    wp::float32 var_171;
    const wp::float32 var_172 = 0.5;
    wp::float32 var_173;
    wp::vec_t<3, wp::float32> var_174;
    wp::vec_t<3, wp::float32> var_175;
    bool var_176;
    const wp::int32 var_177 = 4;
    bool var_178;
    wp::vec_t<3, wp::float32> var_179;
    wp::float32 var_180;
    bool var_181;
    const wp::int32 var_182 = 1;
    wp::int32 var_183;
    wp::int32 var_184;
    wp::int32 var_185;
    //---------
    // forward
    // def collide_plane_cylinder(                                                            <L 516>
    // contact_dist = wp.vec4(MAXVAL)                                                         <L 549>
    var_1 = wp::vec_t<4, wp::float32>(var_0);
    // contact_pos = _mat43f()                                                                <L 550>
    var_2 = wp::mat_t<4, 3, wp::float32>();
    // n = plane_normal                                                                       <L 552>
    var_3 = wp::copy(var_plane_normal);
    // axis = cylinder_axis                                                                   <L 553>
    var_4 = wp::copy(var_cylinder_axis);
    // dot_na = wp.dot(n, axis)                                                               <L 556>
    var_5 = wp::dot(var_3, var_4);
    // if dot_na > 0.0:                                                                       <L 557>
    var_7 = (var_5 > var_6);
    if (var_7) {
        // axis = -axis                                                                       <L 558>
        var_8 = wp::neg(var_4);
        // dot_na = -dot_na                                                                   <L 559>
        var_9 = wp::neg(var_5);
    }
    var_10 = wp::where(var_7, var_8, var_4);
    var_11 = wp::where(var_7, var_9, var_5);
    // cap_center = cylinder_pos + axis * cylinder_half_height                                <L 562>
    var_12 = wp::mul(var_10, var_cylinder_half_height);
    var_13 = wp::add(var_cylinder_pos, var_12);
    // perp_align = -n + axis * dot_na                                                        <L 566>
    var_14 = wp::neg(var_3);
    var_15 = wp::mul(var_10, var_11);
    var_16 = wp::add(var_14, var_15);
    // perp_align_len_sq = wp.dot(perp_align, perp_align)                                     <L 567>
    var_17 = wp::dot(var_16, var_16);
    // has_align = perp_align_len_sq > 1e-10                                                  <L 568>
    var_19 = (var_17 > var_18);
    // if has_align:                                                                          <L 569>
    if (var_19) {
        // perp_align = perp_align * (1.0 / wp.sqrt(perp_align_len_sq))                       <L 570>
        var_21 = wp::sqrt(var_17);
        var_22 = wp::div(var_20, var_21);
        var_23 = wp::mul(var_16, var_22);
    }
    var_24 = wp::where(var_19, var_23, var_16);
    // ref = wp.vec3(1.0, 0.0, 0.0)                                                           <L 573>
    var_28 = wp::vec_t<3, wp::float32>(var_25, var_26, var_27);
    // if wp.abs(wp.dot(axis, ref)) > 0.9:                                                    <L 574>
    var_29 = wp::dot(var_10, var_28);
    var_30 = wp::abs(var_29);
    var_32 = (var_30 > var_31);
    if (var_32) {
        // ref = wp.vec3(0.0, 1.0, 0.0)                                                       <L 575>
        var_36 = wp::vec_t<3, wp::float32>(var_33, var_34, var_35);
    }
    var_37 = wp::where(var_32, var_36, var_28);
    // perp_fixed = ref - axis * wp.dot(axis, ref)                                            <L 576>
    var_38 = wp::dot(var_10, var_37);
    var_39 = wp::mul(var_10, var_38);
    var_40 = wp::sub(var_37, var_39);
    // perp_fixed = wp.normalize(perp_fixed)                                                  <L 577>
    var_41 = wp::normalize(var_40);
    // abs_dot = -dot_na  # in [0, 1], where 1 is upright                                     <L 579>
    var_42 = wp::neg(var_11);
    // flat_mode_cos = wp.static(CYLINDER_FLAT_MODE_COS)                                      <L 580>
    // in_flat_surface_mode = abs_dot >= flat_mode_cos                                        <L 581>
    var_44 = (var_42 >= var_43);
    // deepest_perp = wp.where(has_align, perp_align, perp_fixed)                             <L 582>
    var_45 = wp::where(var_19, var_24, var_41);
    // deepest_pt = cap_center + deepest_perp * cylinder_radius                               <L 583>
    var_46 = wp::mul(var_45, var_cylinder_radius);
    var_47 = wp::add(var_13, var_46);
    // deepest_d = wp.dot(deepest_pt - plane_pos, n)                                          <L 584>
    var_48 = wp::sub(var_47, var_plane_pos);
    var_49 = wp::dot(var_48, var_3);
    // deepest_pos = deepest_pt - n * (deepest_d * 0.5)                                       <L 585>
    var_51 = wp::mul(var_49, var_50);
    var_52 = wp::mul(var_3, var_51);
    var_53 = wp::sub(var_47, var_52);
    // contact_dist[0] = deepest_d                                                            <L 589>
    wp::assign_inplace(var_1, var_54, var_49);
    // contact_pos[0] = deepest_pos                                                           <L 590>
    wp::assign_inplace(var_2, var_55, var_53);
    // ncontact = wp.int32(1)                                                                 <L 591>
    var_57 = wp::int32(var_56);
    // merge_threshold = 0.01 * wp.max(cylinder_radius, cylinder_half_height)                 <L 592>
    var_59 = wp::max(var_cylinder_radius, var_cylinder_half_height);
    var_60 = wp::mul(var_58, var_59);
    // merge_threshold_sq = merge_threshold * merge_threshold                                 <L 593>
    var_61 = wp::mul(var_60, var_60);
    // if in_flat_surface_mode:                                                               <L 598>
    if (var_44) {
        // u_fixed = perp_fixed * cylinder_radius                                             <L 599>
        var_62 = wp::mul(var_41, var_cylinder_radius);
        // v_fixed = wp.cross(axis, perp_fixed) * cylinder_radius                             <L 600>
        var_63 = wp::cross(var_10, var_41);
        var_64 = wp::mul(var_63, var_cylinder_radius);
        // c120 = float(-0.5)                                                                 <L 603>
        var_66 = wp::float(var_65);
        // s120 = float(0.8660254)                                                            <L 604>
        var_68 = wp::float(var_67);
        // pt0 = cap_center + u_fixed                                                         <L 606>
        var_69 = wp::add(var_13, var_62);
        // d0 = wp.dot(pt0 - plane_pos, n)                                                    <L 607>
        var_70 = wp::sub(var_69, var_plane_pos);
        var_71 = wp::dot(var_70, var_3);
        // pos0 = pt0 - n * (d0 * 0.5)                                                        <L 608>
        var_73 = wp::mul(var_71, var_72);
        var_74 = wp::mul(var_3, var_73);
        var_75 = wp::sub(var_69, var_74);
        // if ncontact < 4 and wp.length_sq(pos0 - deepest_pos) > merge_threshold_sq:         <L 609>
        var_78 = (var_57 < var_77);
        var_76 = var_78;
        if (var_76) {
            var_79 = wp::sub(var_75, var_53);
            var_80 = wp::length_sq(var_79);
            var_81 = (var_80 > var_61);
            var_76 = var_76 && var_81;
        }
        if (var_76) {
            // contact_dist[ncontact] = d0                                                    <L 610>
            wp::assign_inplace(var_1, var_57, var_71);
            // contact_pos[ncontact] = pos0                                                   <L 611>
            wp::assign_inplace(var_2, var_57, var_75);
            // ncontact += 1                                                                  <L 612>
            var_83 = wp::add(var_57, var_82);
        }
        var_84 = wp::where(var_76, var_83, var_57);
        // pt1 = cap_center + c120 * u_fixed + s120 * v_fixed                                 <L 614>
        var_85 = wp::mul(var_66, var_62);
        var_86 = wp::add(var_13, var_85);
        var_87 = wp::mul(var_68, var_64);
        var_88 = wp::add(var_86, var_87);
        // d1 = wp.dot(pt1 - plane_pos, n)                                                    <L 615>
        var_89 = wp::sub(var_88, var_plane_pos);
        var_90 = wp::dot(var_89, var_3);
        // pos1 = pt1 - n * (d1 * 0.5)                                                        <L 616>
        var_92 = wp::mul(var_90, var_91);
        var_93 = wp::mul(var_3, var_92);
        var_94 = wp::sub(var_88, var_93);
        // if ncontact < 4 and wp.length_sq(pos1 - deepest_pos) > merge_threshold_sq:         <L 617>
        var_97 = (var_84 < var_96);
        var_95 = var_97;
        if (var_95) {
            var_98 = wp::sub(var_94, var_53);
            var_99 = wp::length_sq(var_98);
            var_100 = (var_99 > var_61);
            var_95 = var_95 && var_100;
        }
        if (var_95) {
            // contact_dist[ncontact] = d1                                                    <L 618>
            wp::assign_inplace(var_1, var_84, var_90);
            // contact_pos[ncontact] = pos1                                                   <L 619>
            wp::assign_inplace(var_2, var_84, var_94);
            // ncontact += 1                                                                  <L 620>
            var_102 = wp::add(var_84, var_101);
        }
        var_103 = wp::where(var_95, var_102, var_84);
        // pt2 = cap_center + c120 * u_fixed - s120 * v_fixed                                 <L 622>
        var_104 = wp::mul(var_66, var_62);
        var_105 = wp::add(var_13, var_104);
        var_106 = wp::mul(var_68, var_64);
        var_107 = wp::sub(var_105, var_106);
        // d2 = wp.dot(pt2 - plane_pos, n)                                                    <L 623>
        var_108 = wp::sub(var_107, var_plane_pos);
        var_109 = wp::dot(var_108, var_3);
        // pos2 = pt2 - n * (d2 * 0.5)                                                        <L 624>
        var_111 = wp::mul(var_109, var_110);
        var_112 = wp::mul(var_3, var_111);
        var_113 = wp::sub(var_107, var_112);
        // if ncontact < 4 and wp.length_sq(pos2 - deepest_pos) > merge_threshold_sq:         <L 625>
        var_116 = (var_103 < var_115);
        var_114 = var_116;
        if (var_114) {
            var_117 = wp::sub(var_113, var_53);
            var_118 = wp::length_sq(var_117);
            var_119 = (var_118 > var_61);
            var_114 = var_114 && var_119;
        }
        if (var_114) {
            // contact_dist[ncontact] = d2                                                    <L 626>
            wp::assign_inplace(var_1, var_103, var_109);
            // contact_pos[ncontact] = pos2                                                   <L 627>
            wp::assign_inplace(var_2, var_103, var_113);
            // ncontact += 1                                                                  <L 628>
            var_121 = wp::add(var_103, var_120);
        }
        var_122 = wp::where(var_114, var_121, var_103);
    }
    if (!var_44) {
        // perp_roll = wp.where(has_align, perp_align, perp_fixed)                            <L 632>
        var_123 = wp::where(var_19, var_24, var_41);
        // u = perp_roll * cylinder_radius                                                    <L 633>
        var_124 = wp::mul(var_123, var_cylinder_radius);
        // v = wp.cross(axis, perp_roll) * cylinder_radius                                    <L 634>
        var_125 = wp::cross(var_10, var_123);
        var_126 = wp::mul(var_125, var_cylinder_radius);
        // pt = cylinder_pos + axis * cylinder_half_height + u                                <L 637>
        var_127 = wp::mul(var_10, var_cylinder_half_height);
        var_128 = wp::add(var_cylinder_pos, var_127);
        var_129 = wp::add(var_128, var_124);
        // d = wp.dot(pt - plane_pos, n)                                                      <L 638>
        var_130 = wp::sub(var_129, var_plane_pos);
        var_131 = wp::dot(var_130, var_3);
        // pos = pt - n * (d * 0.5)                                                           <L 639>
        var_133 = wp::mul(var_131, var_132);
        var_134 = wp::mul(var_3, var_133);
        var_135 = wp::sub(var_129, var_134);
        // if ncontact < 4 and wp.length_sq(pos - deepest_pos) > merge_threshold_sq:          <L 640>
        var_138 = (var_57 < var_137);
        var_136 = var_138;
        if (var_136) {
            var_139 = wp::sub(var_135, var_53);
            var_140 = wp::length_sq(var_139);
            var_141 = (var_140 > var_61);
            var_136 = var_136 && var_141;
        }
        if (var_136) {
            // contact_dist[ncontact] = d                                                     <L 641>
            wp::assign_inplace(var_1, var_57, var_131);
            // contact_pos[ncontact] = pos                                                    <L 642>
            wp::assign_inplace(var_2, var_57, var_135);
            // ncontact += 1                                                                  <L 643>
            var_143 = wp::add(var_57, var_142);
        }
        var_144 = wp::where(var_136, var_143, var_57);
        // pt = cylinder_pos - axis * cylinder_half_height + u                                <L 646>
        var_145 = wp::mul(var_10, var_cylinder_half_height);
        var_146 = wp::sub(var_cylinder_pos, var_145);
        var_147 = wp::add(var_146, var_124);
        // d = wp.dot(pt - plane_pos, n)                                                      <L 647>
        var_148 = wp::sub(var_147, var_plane_pos);
        var_149 = wp::dot(var_148, var_3);
        // pos = pt - n * (d * 0.5)                                                           <L 648>
        var_151 = wp::mul(var_149, var_150);
        var_152 = wp::mul(var_3, var_151);
        var_153 = wp::sub(var_147, var_152);
        // if ncontact < 4 and wp.length_sq(pos - deepest_pos) > merge_threshold_sq:          <L 649>
        var_156 = (var_144 < var_155);
        var_154 = var_156;
        if (var_154) {
            var_157 = wp::sub(var_153, var_53);
            var_158 = wp::length_sq(var_157);
            var_159 = (var_158 > var_61);
            var_154 = var_154 && var_159;
        }
        if (var_154) {
            // contact_dist[ncontact] = d                                                     <L 650>
            wp::assign_inplace(var_1, var_144, var_149);
            // contact_pos[ncontact] = pos                                                    <L 651>
            wp::assign_inplace(var_2, var_144, var_153);
            // ncontact += 1                                                                  <L 652>
            var_161 = wp::add(var_144, var_160);
        }
        var_162 = wp::where(var_154, var_161, var_144);
        // pt_pos_v = cap_center + v                                                          <L 655>
        var_163 = wp::add(var_13, var_126);
        // d_pos_v = wp.dot(pt_pos_v - plane_pos, n)                                          <L 656>
        var_164 = wp::sub(var_163, var_plane_pos);
        var_165 = wp::dot(var_164, var_3);
        // pt_neg_v = cap_center - v                                                          <L 657>
        var_166 = wp::sub(var_13, var_126);
        // d_neg_v = wp.dot(pt_neg_v - plane_pos, n)                                          <L 658>
        var_167 = wp::sub(var_166, var_plane_pos);
        var_168 = wp::dot(var_167, var_3);
        // use_pos_v = d_pos_v <= d_neg_v                                                     <L 659>
        var_169 = (var_165 <= var_168);
        // pt = wp.where(use_pos_v, pt_pos_v, pt_neg_v)                                       <L 660>
        var_170 = wp::where(var_169, var_163, var_166);
        // d = wp.where(use_pos_v, d_pos_v, d_neg_v)                                          <L 661>
        var_171 = wp::where(var_169, var_165, var_168);
        // pos = pt - n * (d * 0.5)                                                           <L 662>
        var_173 = wp::mul(var_171, var_172);
        var_174 = wp::mul(var_3, var_173);
        var_175 = wp::sub(var_170, var_174);
        // if ncontact < 4 and wp.length_sq(pos - deepest_pos) > merge_threshold_sq:          <L 663>
        var_178 = (var_162 < var_177);
        var_176 = var_178;
        if (var_176) {
            var_179 = wp::sub(var_175, var_53);
            var_180 = wp::length_sq(var_179);
            var_181 = (var_180 > var_61);
            var_176 = var_176 && var_181;
        }
        if (var_176) {
            // contact_dist[ncontact] = d                                                     <L 664>
            wp::assign_inplace(var_1, var_162, var_171);
            // contact_pos[ncontact] = pos                                                    <L 665>
            wp::assign_inplace(var_2, var_162, var_175);
            // ncontact += 1                                                                  <L 666>
            var_183 = wp::add(var_162, var_182);
        }
        var_184 = wp::where(var_176, var_183, var_162);
    }
    var_185 = wp::where(var_44, var_122, var_184);
    // return contact_dist, contact_pos, n                                                    <L 668>
    ret_0 = var_1;
    ret_1 = var_2;
    ret_2 = var_3;
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/collision_primitive.py:48
static CUDA_CALLABLE wp::vec_t<3, wp::float32> closest_segment_point_0(
    wp::vec_t<3, wp::float32> var_a,
    wp::vec_t<3, wp::float32> var_b,
    wp::vec_t<3, wp::float32> var_pt)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::float32 var_2;
    wp::float32 var_3;
    const wp::float32 var_4 = 1e-06;
    wp::float32 var_5;
    wp::float32 var_6;
    const wp::float32 var_7 = 0.0;
    const wp::float32 var_8 = 1.0;
    wp::float32 var_9;
    wp::vec_t<3, wp::float32> var_10;
    wp::vec_t<3, wp::float32> var_11;
    //---------
    // forward
    // def closest_segment_point(a: wp.vec3, b: wp.vec3, pt: wp.vec3) -> wp.vec3:             <L 49>
    // ab = b - a                                                                             <L 51>
    var_0 = wp::sub(var_b, var_a);
    // t = wp.dot(pt - a, ab) / (wp.dot(ab, ab) + 1e-6)                                       <L 52>
    var_1 = wp::sub(var_pt, var_a);
    var_2 = wp::dot(var_1, var_0);
    var_3 = wp::dot(var_0, var_0);
    var_5 = wp::add(var_3, var_4);
    var_6 = wp::div(var_2, var_5);
    // return a + wp.clamp(t, 0.0, 1.0) * ab                                                  <L 53>
    var_9 = wp::clamp(var_6, var_7, var_8);
    var_10 = wp::mul(var_9, var_0);
    var_11 = wp::add(var_a, var_10);
    return var_11;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/collision_primitive.py:143
static CUDA_CALLABLE void collide_sphere_capsule_0(
    wp::vec_t<3, wp::float32> var_sphere_pos,
    wp::float32 var_sphere_radius,
    wp::vec_t<3, wp::float32> var_capsule_pos,
    wp::vec_t<3, wp::float32> var_capsule_axis,
    wp::float32 var_capsule_radius,
    wp::float32 var_capsule_half_length,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & ret_2)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    wp::float32 var_4;
    wp::vec_t<3, wp::float32> var_5;
    wp::vec_t<3, wp::float32> var_6;
    //---------
    // forward
    // def collide_sphere_capsule(                                                            <L 144>
    // segment = capsule_axis * capsule_half_length                                           <L 171>
    var_0 = wp::mul(var_capsule_axis, var_capsule_half_length);
    // pt = closest_segment_point(capsule_pos - segment, capsule_pos + segment, sphere_pos)       <L 174>
    var_1 = wp::sub(var_capsule_pos, var_0);
    var_2 = wp::add(var_capsule_pos, var_0);
    var_3 = closest_segment_point_0(var_1, var_2, var_sphere_pos);
    // return collide_sphere_sphere(sphere_pos, sphere_radius, pt, capsule_radius)            <L 177>
    collide_sphere_sphere_0(var_sphere_pos, var_sphere_radius, var_3, var_capsule_radius, var_4, var_5, var_6);
    ret_0 = var_4;
    ret_1 = var_5;
    ret_2 = var_6;
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/collision_primitive.py:180
static CUDA_CALLABLE void collide_capsule_capsule_0(
    wp::vec_t<3, wp::float32> var_cap1_pos,
    wp::vec_t<3, wp::float32> var_cap1_axis,
    wp::float32 var_cap1_radius,
    wp::float32 var_cap1_half_length,
    wp::vec_t<3, wp::float32> var_cap2_pos,
    wp::vec_t<3, wp::float32> var_cap2_axis,
    wp::float32 var_cap2_radius,
    wp::float32 var_cap2_half_length,
    wp::vec_t<2, wp::float32> & ret_0,
    wp::mat_t<2, 3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & ret_2)
{
    //---------
    // primal vars
    const wp::float32 var_0 = 10000000000.0;
    wp::vec_t<2, wp::float32> var_1;
    wp::mat_t<2, 3, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    wp::vec_t<3, wp::float32> var_4;
    wp::vec_t<3, wp::float32> var_5;
    wp::vec_t<3, wp::float32> var_6;
    wp::float32 var_7;
    wp::float32 var_8;
    wp::float32 var_9;
    wp::float32 var_10;
    wp::float32 var_11;
    wp::float32 var_12;
    wp::float32 var_13;
    wp::float32 var_14;
    wp::float32 var_15;
    wp::float32 var_16;
    wp::float32 var_17;
    const wp::float32 var_18 = 1e-15;
    bool var_19;
    const wp::float32 var_20 = 1.0;
    wp::float32 var_21;
    wp::float32 var_22;
    wp::float32 var_23;
    wp::float32 var_24;
    wp::float32 var_25;
    wp::float32 var_26;
    wp::float32 var_27;
    wp::float32 var_28;
    wp::float32 var_29;
    const wp::float32 var_30 = 1.0;
    bool var_31;
    const wp::float32 var_32 = 1.0;
    wp::float32 var_33;
    wp::float32 var_34;
    const wp::float32 var_35 = -1.0;
    bool var_36;
    const wp::float32 var_37 = -1.0;
    wp::float32 var_38;
    wp::float32 var_39;
    wp::float32 var_40;
    wp::float32 var_41;
    wp::float32 var_42;
    wp::float32 var_43;
    const wp::float32 var_44 = 1.0;
    bool var_45;
    const wp::float32 var_46 = 1.0;
    wp::float32 var_47;
    wp::float32 var_48;
    const wp::float32 var_49 = -1.0;
    const wp::float32 var_50 = 1.0;
    wp::float32 var_51;
    const wp::float32 var_52 = -1.0;
    bool var_53;
    const wp::float32 var_54 = -1.0;
    wp::float32 var_55;
    wp::float32 var_56;
    const wp::float32 var_57 = -1.0;
    const wp::float32 var_58 = 1.0;
    wp::float32 var_59;
    wp::float32 var_60;
    wp::float32 var_61;
    wp::float32 var_62;
    wp::float32 var_63;
    wp::vec_t<3, wp::float32> var_64;
    wp::vec_t<3, wp::float32> var_65;
    wp::vec_t<3, wp::float32> var_66;
    wp::vec_t<3, wp::float32> var_67;
    wp::float32 var_68;
    wp::vec_t<3, wp::float32> var_69;
    wp::vec_t<3, wp::float32> var_70;
    const wp::int32 var_71 = 0;
    const wp::int32 var_72 = 0;
    wp::vec_t<3, wp::float32> var_73;
    wp::vec_t<3, wp::float32> var_74;
    wp::float32 var_75;
    wp::float32 var_76;
    const wp::float32 var_77 = -1.0;
    const wp::float32 var_78 = 1.0;
    wp::float32 var_79;
    wp::vec_t<3, wp::float32> var_80;
    wp::vec_t<3, wp::float32> var_81;
    wp::float32 var_82;
    wp::vec_t<3, wp::float32> var_83;
    wp::vec_t<3, wp::float32> var_84;
    const wp::int32 var_85 = 0;
    const wp::int32 var_86 = 0;
    wp::vec_t<3, wp::float32> var_87;
    wp::vec_t<3, wp::float32> var_88;
    wp::float32 var_89;
    wp::float32 var_90;
    const wp::float32 var_91 = -1.0;
    const wp::float32 var_92 = 1.0;
    wp::float32 var_93;
    wp::vec_t<3, wp::float32> var_94;
    wp::vec_t<3, wp::float32> var_95;
    wp::float32 var_96;
    wp::vec_t<3, wp::float32> var_97;
    wp::vec_t<3, wp::float32> var_98;
    const wp::int32 var_99 = 1;
    const wp::int32 var_100 = 1;
    wp::vec_t<3, wp::float32> var_101;
    wp::float32 var_102;
    wp::vec_t<3, wp::float32> var_103;
    wp::vec_t<3, wp::float32> var_104;
    wp::float32 var_105;
    wp::vec_t<3, wp::float32> var_106;
    wp::vec_t<3, wp::float32> var_107;
    //---------
    // forward
    // def collide_capsule_capsule(                                                           <L 181>
    // contact_dist = wp.vec2(MAXVAL, MAXVAL)                                                 <L 210>
    var_1 = wp::vec_t<2, wp::float32>(var_0, var_0);
    // contact_pos = _mat23f()                                                                <L 211>
    var_2 = wp::mat_t<2, 3, wp::float32>();
    // contact_normal = wp.vec3()                                                             <L 212>
    var_3 = wp::vec_t<3, wp::float32>();
    // axis1 = cap1_axis * cap1_half_length                                                   <L 215>
    var_4 = wp::mul(var_cap1_axis, var_cap1_half_length);
    // axis2 = cap2_axis * cap2_half_length                                                   <L 216>
    var_5 = wp::mul(var_cap2_axis, var_cap2_half_length);
    // dif = cap1_pos - cap2_pos                                                              <L 217>
    var_6 = wp::sub(var_cap1_pos, var_cap2_pos);
    // ma = wp.dot(axis1, axis1)                                                              <L 220>
    var_7 = wp::dot(var_4, var_4);
    // mb = -wp.dot(axis1, axis2)                                                             <L 221>
    var_8 = wp::dot(var_4, var_5);
    var_9 = wp::neg(var_8);
    // mc = wp.dot(axis2, axis2)                                                              <L 222>
    var_10 = wp::dot(var_5, var_5);
    // u = -wp.dot(axis1, dif)                                                                <L 223>
    var_11 = wp::dot(var_4, var_6);
    var_12 = wp::neg(var_11);
    // v = wp.dot(axis2, dif)                                                                 <L 224>
    var_13 = wp::dot(var_5, var_6);
    // det = ma * mc - mb * mb                                                                <L 225>
    var_14 = wp::mul(var_7, var_10);
    var_15 = wp::mul(var_9, var_9);
    var_16 = wp::sub(var_14, var_15);
    // if wp.abs(det) >= MINVAL:                                                              <L 228>
    var_17 = wp::abs(var_16);
    var_19 = (var_17 >= var_18);
    if (var_19) {
        // inv_det = 1.0 / det                                                                <L 229>
        var_21 = wp::div(var_20, var_16);
        // x1 = (mc * u - mb * v) * inv_det                                                   <L 230>
        var_22 = wp::mul(var_10, var_12);
        var_23 = wp::mul(var_9, var_13);
        var_24 = wp::sub(var_22, var_23);
        var_25 = wp::mul(var_24, var_21);
        // x2 = (ma * v - mb * u) * inv_det                                                   <L 231>
        var_26 = wp::mul(var_7, var_13);
        var_27 = wp::mul(var_9, var_12);
        var_28 = wp::sub(var_26, var_27);
        var_29 = wp::mul(var_28, var_21);
        // if x1 > 1.0:                                                                       <L 233>
        var_31 = (var_25 > var_30);
        if (var_31) {
            // x1 = 1.0                                                                       <L 234>
            // x2 = (v - mb) / mc                                                             <L 235>
            var_33 = wp::sub(var_13, var_9);
            var_34 = wp::div(var_33, var_10);
        }
        if (!var_31) {
            // elif x1 < -1.0:                                                                <L 236>
            var_36 = (var_25 < var_35);
            if (var_36) {
                // x1 = -1.0                                                                  <L 237>
                // x2 = (v + mb) / mc                                                         <L 238>
                var_38 = wp::add(var_13, var_9);
                var_39 = wp::div(var_38, var_10);
            }
            var_40 = wp::where(var_36, var_37, var_25);
            var_41 = wp::where(var_36, var_39, var_29);
        }
        var_42 = wp::where(var_31, var_32, var_40);
        var_43 = wp::where(var_31, var_34, var_41);
        // if x2 > 1.0:                                                                       <L 240>
        var_45 = (var_43 > var_44);
        if (var_45) {
            // x2 = 1.0                                                                       <L 241>
            // x1 = wp.clamp((u - mb) / ma, -1.0, 1.0)                                        <L 242>
            var_47 = wp::sub(var_12, var_9);
            var_48 = wp::div(var_47, var_7);
            var_51 = wp::clamp(var_48, var_49, var_50);
        }
        if (!var_45) {
            // elif x2 < -1.0:                                                                <L 243>
            var_53 = (var_43 < var_52);
            if (var_53) {
                // x2 = -1.0                                                                  <L 244>
                // x1 = wp.clamp((u + mb) / ma, -1.0, 1.0)                                    <L 245>
                var_55 = wp::add(var_12, var_9);
                var_56 = wp::div(var_55, var_7);
                var_59 = wp::clamp(var_56, var_57, var_58);
            }
            var_60 = wp::where(var_53, var_59, var_42);
            var_61 = wp::where(var_53, var_54, var_43);
        }
        var_62 = wp::where(var_45, var_51, var_60);
        var_63 = wp::where(var_45, var_46, var_61);
        // vec1 = cap1_pos + axis1 * x1                                                       <L 248>
        var_64 = wp::mul(var_4, var_62);
        var_65 = wp::add(var_cap1_pos, var_64);
        // vec2 = cap2_pos + axis2 * x2                                                       <L 249>
        var_66 = wp::mul(var_5, var_63);
        var_67 = wp::add(var_cap2_pos, var_66);
        // dist, pos, normal = collide_sphere_sphere(vec1, cap1_radius, vec2, cap2_radius)       <L 251>
        collide_sphere_sphere_0(var_65, var_cap1_radius, var_67, var_cap2_radius, var_68, var_69, var_70);
        // contact_dist[0] = dist                                                             <L 252>
        wp::assign_inplace(var_1, var_71, var_68);
        // contact_pos[0] = pos                                                               <L 253>
        wp::assign_inplace(var_2, var_72, var_69);
        // contact_normal = normal                                                            <L 254>
        var_73 = wp::copy(var_70);
    }
    if (!var_19) {
        // vec1 = cap1_pos + axis1                                                            <L 259>
        var_74 = wp::add(var_cap1_pos, var_4);
        // x2 = wp.clamp((v - mb) / mc, -1.0, 1.0)                                            <L 260>
        var_75 = wp::sub(var_13, var_9);
        var_76 = wp::div(var_75, var_10);
        var_79 = wp::clamp(var_76, var_77, var_78);
        // vec2 = cap2_pos + axis2 * x2                                                       <L 261>
        var_80 = wp::mul(var_5, var_79);
        var_81 = wp::add(var_cap2_pos, var_80);
        // dist, pos, normal = collide_sphere_sphere(vec1, cap1_radius, vec2, cap2_radius)       <L 262>
        collide_sphere_sphere_0(var_74, var_cap1_radius, var_81, var_cap2_radius, var_82, var_83, var_84);
        // contact_dist[0] = dist                                                             <L 263>
        wp::assign_inplace(var_1, var_85, var_82);
        // contact_pos[0] = pos                                                               <L 264>
        wp::assign_inplace(var_2, var_86, var_83);
        // contact_normal = normal  # Use first contact's normal for both                     <L 265>
        var_87 = wp::copy(var_84);
        // vec1 = cap1_pos - axis1                                                            <L 268>
        var_88 = wp::sub(var_cap1_pos, var_4);
        // x2 = wp.clamp((v + mb) / mc, -1.0, 1.0)                                            <L 269>
        var_89 = wp::add(var_13, var_9);
        var_90 = wp::div(var_89, var_10);
        var_93 = wp::clamp(var_90, var_91, var_92);
        // vec2 = cap2_pos + axis2 * x2                                                       <L 270>
        var_94 = wp::mul(var_5, var_93);
        var_95 = wp::add(var_cap2_pos, var_94);
        // dist, pos, _normal = collide_sphere_sphere(vec1, cap1_radius, vec2, cap2_radius)       <L 271>
        collide_sphere_sphere_0(var_88, var_cap1_radius, var_95, var_cap2_radius, var_96, var_97, var_98);
        // contact_dist[1] = dist                                                             <L 272>
        wp::assign_inplace(var_1, var_99, var_96);
        // contact_pos[1] = pos                                                               <L 273>
        wp::assign_inplace(var_2, var_100, var_97);
    }
    var_101 = wp::where(var_19, var_73, var_87);
    var_102 = wp::where(var_19, var_63, var_93);
    var_103 = wp::where(var_19, var_65, var_88);
    var_104 = wp::where(var_19, var_67, var_95);
    var_105 = wp::where(var_19, var_68, var_96);
    var_106 = wp::where(var_19, var_69, var_97);
    var_107 = wp::where(var_19, var_70, var_84);
    // return contact_dist, contact_pos, contact_normal                                       <L 275>
    ret_0 = var_1;
    ret_1 = var_2;
    ret_2 = var_101;
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/math/__init__.py:0
static CUDA_CALLABLE wp::float32 safe_div_0(
    wp::float32 var_x,
    wp::float32 var_y,
    wp::float32 var_eps)
{
    //---------
    // primal vars
    const wp::float32 var_0 = 0.0;
    bool var_1;
    wp::float32 var_2;
    wp::float32 var_3;
    //---------
    // forward
    // def safe_div(x: Any, y: Any, eps: float = EPSILON) -> Any:                             <L 1>
    // return x / wp.where(y != 0.0, y, eps)                                                  <L 12>
    var_1 = (var_y != var_0);
    var_2 = wp::where(var_1, var_y, var_eps);
    var_3 = wp::div(var_x, var_2);
    return var_3;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/collision_primitive.py:442
static CUDA_CALLABLE void collide_sphere_cylinder_0(
    wp::vec_t<3, wp::float32> var_sphere_pos,
    wp::float32 var_sphere_radius,
    wp::vec_t<3, wp::float32> var_cylinder_pos,
    wp::vec_t<3, wp::float32> var_cylinder_axis,
    wp::float32 var_cylinder_radius,
    wp::float32 var_cylinder_half_height,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & ret_2)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::float32 var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    wp::float32 var_4;
    wp::float32 var_5;
    bool var_6;
    wp::float32 var_7;
    bool var_8;
    bool var_9;
    wp::float32 var_10;
    wp::float32 var_11;
    wp::float32 var_12;
    wp::float32 var_13;
    bool var_14;
    const bool var_15 = false;
    const bool var_16 = false;
    bool var_17;
    bool var_18;
    bool var_19;
    bool var_20;
    wp::vec_t<3, wp::float32> var_21;
    wp::float32 var_22;
    wp::vec_t<3, wp::float32> var_23;
    wp::vec_t<3, wp::float32> var_24;
    const wp::float32 var_25 = 0.0;
    bool var_26;
    wp::vec_t<3, wp::float32> var_27;
    wp::vec_t<3, wp::float32> var_28;
    wp::vec_t<3, wp::float32> var_29;
    wp::vec_t<3, wp::float32> var_30;
    wp::vec_t<3, wp::float32> var_31;
    wp::vec_t<3, wp::float32> var_32;
    wp::vec_t<3, wp::float32> var_33;
    wp::vec_t<3, wp::float32> var_34;
    wp::float32 var_35;
    wp::vec_t<3, wp::float32> var_36;
    wp::vec_t<3, wp::float32> var_37;
    const wp::float32 var_38 = 1.0;
    wp::float32 var_39;
    wp::float32 var_40;
    const wp::float32 var_41 = 1e-15;
    wp::float32 var_42;
    wp::vec_t<3, wp::float32> var_43;
    wp::float32 var_44;
    wp::float32 var_45;
    wp::vec_t<3, wp::float32> var_46;
    wp::vec_t<3, wp::float32> var_47;
    wp::vec_t<3, wp::float32> var_48;
    const wp::float32 var_49 = 0.0;
    wp::float32 var_50;
    wp::vec_t<3, wp::float32> var_51;
    wp::vec_t<3, wp::float32> var_52;
    wp::vec_t<3, wp::float32> var_53;
    wp::vec_t<3, wp::float32> var_54;
    //---------
    // forward
    // def collide_sphere_cylinder(                                                           <L 443>
    // vec = sphere_pos - cylinder_pos                                                        <L 468>
    var_0 = wp::sub(var_sphere_pos, var_cylinder_pos);
    // x = wp.dot(vec, cylinder_axis)                                                         <L 469>
    var_1 = wp::dot(var_0, var_cylinder_axis);
    // a_proj = cylinder_axis * x                                                             <L 471>
    var_2 = wp::mul(var_cylinder_axis, var_1);
    // p_proj = vec - a_proj                                                                  <L 472>
    var_3 = wp::sub(var_0, var_2);
    // p_proj_sqr = wp.dot(p_proj, p_proj)                                                    <L 473>
    var_4 = wp::dot(var_3, var_3);
    // collide_side = wp.abs(x) < cylinder_half_height                                        <L 475>
    var_5 = wp::abs(var_1);
    var_6 = (var_5 < var_cylinder_half_height);
    // collide_cap = p_proj_sqr < (cylinder_radius * cylinder_radius)                         <L 476>
    var_7 = wp::mul(var_cylinder_radius, var_cylinder_radius);
    var_8 = (var_4 < var_7);
    // if collide_side and collide_cap:                                                       <L 478>
    var_9 = var_6;
    if (var_9) {
        var_9 = var_9 && var_8;
    }
    if (var_9) {
        // dist_cap = cylinder_half_height - wp.abs(x)                                        <L 479>
        var_10 = wp::abs(var_1);
        var_11 = wp::sub(var_cylinder_half_height, var_10);
        // dist_radius = cylinder_radius - wp.sqrt(p_proj_sqr)                                <L 480>
        var_12 = wp::sqrt(var_4);
        var_13 = wp::sub(var_cylinder_radius, var_12);
        // if dist_cap < dist_radius:                                                         <L 482>
        var_14 = (var_11 < var_13);
        if (var_14) {
            // collide_side = False                                                           <L 483>
        }
        if (!var_14) {
            // collide_cap = False                                                            <L 485>
        }
        var_17 = wp::where(var_14, var_15, var_6);
        var_18 = wp::where(var_14, var_8, var_16);
    }
    var_19 = wp::where(var_9, var_17, var_6);
    var_20 = wp::where(var_9, var_18, var_8);
    // if collide_side:                                                                       <L 488>
    if (var_19) {
        // pos_target = cylinder_pos + a_proj                                                 <L 489>
        var_21 = wp::add(var_cylinder_pos, var_2);
        // return collide_sphere_sphere(sphere_pos, sphere_radius, pos_target, cylinder_radius)       <L 490>
        collide_sphere_sphere_0(var_sphere_pos, var_sphere_radius, var_21, var_cylinder_radius, var_22, var_23, var_24);
        ret_0 = var_22;
        ret_1 = var_23;
        ret_2 = var_24;
        return;
    }
    if (!var_19) {
        // elif collide_cap:                                                                  <L 492>
        if (var_20) {
            // if x > 0.0:                                                                    <L 493>
            var_26 = (var_1 > var_25);
            if (var_26) {
                // pos_cap = cylinder_pos + cylinder_axis * cylinder_half_height              <L 495>
                var_27 = wp::mul(var_cylinder_axis, var_cylinder_half_height);
                var_28 = wp::add(var_cylinder_pos, var_27);
                // plane_normal = cylinder_axis                                               <L 496>
                var_29 = wp::copy(var_cylinder_axis);
            }
            if (!var_26) {
                // pos_cap = cylinder_pos - cylinder_axis * cylinder_half_height              <L 499>
                var_30 = wp::mul(var_cylinder_axis, var_cylinder_half_height);
                var_31 = wp::sub(var_cylinder_pos, var_30);
                // plane_normal = -cylinder_axis                                              <L 500>
                var_32 = wp::neg(var_cylinder_axis);
            }
            var_33 = wp::where(var_26, var_28, var_31);
            var_34 = wp::where(var_26, var_29, var_32);
            // dist, pos = collide_plane_sphere(plane_normal, pos_cap, sphere_pos, sphere_radius)       <L 502>
            collide_plane_sphere_0(var_34, var_33, var_sphere_pos, var_sphere_radius, var_35, var_36);
            // return dist, pos, -plane_normal  # flip normal after position calculation       <L 503>
            var_37 = wp::neg(var_34);
            ret_0 = var_35;
            ret_1 = var_36;
            ret_2 = var_37;
            return;
        }
        if (!var_20) {
            // inv_len = safe_div(1.0, wp.sqrt(p_proj_sqr))                                   <L 506>
            var_39 = wp::sqrt(var_4);
            var_40 = safe_div_0(var_38, var_39, var_41);
            // p_proj = p_proj * (cylinder_radius * inv_len)                                  <L 507>
            var_42 = wp::mul(var_cylinder_radius, var_40);
            var_43 = wp::mul(var_3, var_42);
            // cap_offset = cylinder_axis * (wp.sign(x) * cylinder_half_height)               <L 509>
            var_44 = wp::sign(var_1);
            var_45 = wp::mul(var_44, var_cylinder_half_height);
            var_46 = wp::mul(var_cylinder_axis, var_45);
            // pos_corner = cylinder_pos + cap_offset + p_proj                                <L 510>
            var_47 = wp::add(var_cylinder_pos, var_46);
            var_48 = wp::add(var_47, var_43);
            // return collide_sphere_sphere(sphere_pos, sphere_radius, pos_corner, 0.0)       <L 512>
            collide_sphere_sphere_0(var_sphere_pos, var_sphere_radius, var_48, var_49, var_50, var_51, var_52);
            ret_0 = var_50;
            ret_1 = var_51;
            ret_2 = var_52;
            return;
        }
        var_53 = wp::where(var_20, var_3, var_43);
    }
    var_54 = wp::where(var_19, var_3, var_53);
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/collision_primitive.py:1161
static CUDA_CALLABLE void collide_sphere_box_0(
    wp::vec_t<3, wp::float32> var_sphere_pos,
    wp::float32 var_sphere_radius,
    wp::vec_t<3, wp::float32> var_box_pos,
    wp::mat_t<3, 3, wp::float32> var_box_rot,
    wp::vec_t<3, wp::float32> var_box_size,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & ret_2)
{
    //---------
    // primal vars
    wp::mat_t<3, 3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    wp::vec_t<3, wp::float32> var_4;
    wp::vec_t<3, wp::float32> var_5;
    wp::vec_t<3, wp::float32> var_6;
    wp::vec_t<3, wp::float32> var_7;
    wp::float32 var_8;
    const wp::float32 var_9 = 1e-06;
    bool var_10;
    const wp::float32 var_11 = 2.0;
    const wp::int32 var_12 = 0;
    wp::float32 var_13;
    const wp::int32 var_14 = 1;
    wp::float32 var_15;
    wp::float32 var_16;
    const wp::int32 var_17 = 2;
    wp::float32 var_18;
    wp::float32 var_19;
    wp::float32 var_20;
    const wp::int32 var_21 = 0;
    wp::int32 var_22;
    const wp::int32 var_23 = 0;
    const wp::int32 var_24 = 2;
    wp::int32 var_25;
    const wp::float32 var_26 = 1.0;
    const wp::float32 var_27 = -1.0;
    wp::float32 var_28;
    const wp::int32 var_29 = 2;
    wp::int32 var_30;
    wp::float32 var_31;
    wp::float32 var_32;
    const wp::int32 var_33 = 2;
    wp::int32 var_34;
    wp::float32 var_35;
    wp::float32 var_36;
    wp::float32 var_37;
    bool var_38;
    wp::float32 var_39;
    wp::int32 var_40;
    wp::float32 var_41;
    wp::int32 var_42;
    const wp::int32 var_43 = 1;
    const wp::int32 var_44 = 2;
    wp::int32 var_45;
    const wp::float32 var_46 = 1.0;
    const wp::float32 var_47 = -1.0;
    wp::float32 var_48;
    const wp::int32 var_49 = 2;
    wp::int32 var_50;
    wp::float32 var_51;
    wp::float32 var_52;
    const wp::int32 var_53 = 2;
    wp::int32 var_54;
    wp::float32 var_55;
    wp::float32 var_56;
    wp::float32 var_57;
    bool var_58;
    wp::float32 var_59;
    wp::int32 var_60;
    wp::float32 var_61;
    wp::int32 var_62;
    const wp::int32 var_63 = 2;
    const wp::int32 var_64 = 2;
    wp::int32 var_65;
    const wp::float32 var_66 = 1.0;
    const wp::float32 var_67 = -1.0;
    wp::float32 var_68;
    const wp::int32 var_69 = 2;
    wp::int32 var_70;
    wp::float32 var_71;
    wp::float32 var_72;
    const wp::int32 var_73 = 2;
    wp::int32 var_74;
    wp::float32 var_75;
    wp::float32 var_76;
    wp::float32 var_77;
    bool var_78;
    wp::float32 var_79;
    wp::int32 var_80;
    wp::float32 var_81;
    wp::int32 var_82;
    const wp::int32 var_83 = 3;
    const wp::int32 var_84 = 2;
    wp::int32 var_85;
    const wp::float32 var_86 = 1.0;
    const wp::float32 var_87 = -1.0;
    wp::float32 var_88;
    const wp::int32 var_89 = 2;
    wp::int32 var_90;
    wp::float32 var_91;
    wp::float32 var_92;
    const wp::int32 var_93 = 2;
    wp::int32 var_94;
    wp::float32 var_95;
    wp::float32 var_96;
    wp::float32 var_97;
    bool var_98;
    wp::float32 var_99;
    wp::int32 var_100;
    wp::float32 var_101;
    wp::int32 var_102;
    const wp::int32 var_103 = 4;
    const wp::int32 var_104 = 2;
    wp::int32 var_105;
    const wp::float32 var_106 = 1.0;
    const wp::float32 var_107 = -1.0;
    wp::float32 var_108;
    const wp::int32 var_109 = 2;
    wp::int32 var_110;
    wp::float32 var_111;
    wp::float32 var_112;
    const wp::int32 var_113 = 2;
    wp::int32 var_114;
    wp::float32 var_115;
    wp::float32 var_116;
    wp::float32 var_117;
    bool var_118;
    wp::float32 var_119;
    wp::int32 var_120;
    wp::float32 var_121;
    wp::int32 var_122;
    const wp::int32 var_123 = 5;
    const wp::int32 var_124 = 2;
    wp::int32 var_125;
    const wp::float32 var_126 = 1.0;
    const wp::float32 var_127 = -1.0;
    wp::float32 var_128;
    const wp::int32 var_129 = 2;
    wp::int32 var_130;
    wp::float32 var_131;
    wp::float32 var_132;
    const wp::int32 var_133 = 2;
    wp::int32 var_134;
    wp::float32 var_135;
    wp::float32 var_136;
    wp::float32 var_137;
    bool var_138;
    wp::float32 var_139;
    wp::int32 var_140;
    wp::float32 var_141;
    wp::int32 var_142;
    const wp::float32 var_143 = 0.0;
    wp::vec_t<3, wp::float32> var_144;
    const wp::int32 var_145 = 2;
    wp::int32 var_146;
    const wp::float32 var_147 = -1.0;
    const wp::float32 var_148 = 1.0;
    wp::float32 var_149;
    const wp::int32 var_150 = 2;
    wp::int32 var_151;
    wp::float32 var_152;
    wp::vec_t<3, wp::float32> var_153;
    const wp::float32 var_154 = 2.0;
    wp::vec_t<3, wp::float32> var_155;
    wp::vec_t<3, wp::float32> var_156;
    wp::vec_t<3, wp::float32> var_157;
    wp::float32 var_158;
    wp::float32 var_159;
    wp::vec_t<3, wp::float32> var_160;
    wp::vec_t<3, wp::float32> var_161;
    const wp::float32 var_162 = 0.5;
    wp::vec_t<3, wp::float32> var_163;
    wp::vec_t<3, wp::float32> var_164;
    wp::vec_t<3, wp::float32> var_165;
    wp::float32 var_166;
    wp::vec_t<3, wp::float32> var_167;
    wp::vec_t<3, wp::float32> var_168;
    wp::float32 var_169;
    wp::vec_t<3, wp::float32> var_170;
    wp::vec_t<3, wp::float32> var_171;
    //---------
    // forward
    // def collide_sphere_box(                                                                <L 1162>
    // center = wp.transpose(box_rot) @ (sphere_pos - box_pos)                                <L 1186>
    var_0 = wp::transpose(var_box_rot);
    var_1 = wp::sub(var_sphere_pos, var_box_pos);
    var_2 = wp::mul(var_0, var_1);
    // clamped = wp.max(-box_size, wp.min(box_size, center))                                  <L 1188>
    var_3 = wp::neg(var_box_size);
    var_4 = wp::min(var_box_size, var_2);
    var_5 = wp::max(var_3, var_4);
    // clamped_dir, dist = normalize_with_norm(clamped - center)                              <L 1189>
    var_6 = wp::sub(var_5, var_2);
    normalize_with_norm_0(var_6, var_7, var_8);
    // if dist <= 1e-6:                                                                       <L 1192>
    var_10 = (var_8 <= var_9);
    if (var_10) {
        // closest = 2.0 * (box_size[0] + box_size[1] + box_size[2])                          <L 1193>
        var_13 = wp::extract(var_box_size, var_12);
        var_15 = wp::extract(var_box_size, var_14);
        var_16 = wp::add(var_13, var_15);
        var_18 = wp::extract(var_box_size, var_17);
        var_19 = wp::add(var_16, var_18);
        var_20 = wp::mul(var_11, var_19);
        // k = wp.int32(0)                                                                    <L 1194>
        var_22 = wp::int32(var_21);
        // for i in range(6):                                                                 <L 1195>
        // face_dist = wp.abs(wp.where(i % 2, 1.0, -1.0) * box_size[i // 2] - center[i // 2])       <L 1196>
        var_25 = wp::mod(var_23, var_24);
        var_28 = wp::where(var_25, var_26, var_27);
        var_30 = wp::floordiv(var_23, var_29);
        var_31 = wp::extract(var_box_size, var_30);
        var_32 = wp::mul(var_28, var_31);
        var_34 = wp::floordiv(var_23, var_33);
        var_35 = wp::extract(var_2, var_34);
        var_36 = wp::sub(var_32, var_35);
        var_37 = wp::abs(var_36);
        // if closest > face_dist:                                                            <L 1197>
        var_38 = (var_20 > var_37);
        if (var_38) {
            // closest = face_dist                                                            <L 1198>
            var_39 = wp::copy(var_37);
            // k = i                                                                          <L 1199>
            var_40 = wp::copy(var_23);
        }
        var_41 = wp::where(var_38, var_39, var_20);
        var_42 = wp::where(var_38, var_40, var_22);
        // face_dist = wp.abs(wp.where(i % 2, 1.0, -1.0) * box_size[i // 2] - center[i // 2])       <L 1196>
        var_45 = wp::mod(var_43, var_44);
        var_48 = wp::where(var_45, var_46, var_47);
        var_50 = wp::floordiv(var_43, var_49);
        var_51 = wp::extract(var_box_size, var_50);
        var_52 = wp::mul(var_48, var_51);
        var_54 = wp::floordiv(var_43, var_53);
        var_55 = wp::extract(var_2, var_54);
        var_56 = wp::sub(var_52, var_55);
        var_57 = wp::abs(var_56);
        // if closest > face_dist:                                                            <L 1197>
        var_58 = (var_41 > var_57);
        if (var_58) {
            // closest = face_dist                                                            <L 1198>
            var_59 = wp::copy(var_57);
            // k = i                                                                          <L 1199>
            var_60 = wp::copy(var_43);
        }
        var_61 = wp::where(var_58, var_59, var_41);
        var_62 = wp::where(var_58, var_60, var_42);
        // face_dist = wp.abs(wp.where(i % 2, 1.0, -1.0) * box_size[i // 2] - center[i // 2])       <L 1196>
        var_65 = wp::mod(var_63, var_64);
        var_68 = wp::where(var_65, var_66, var_67);
        var_70 = wp::floordiv(var_63, var_69);
        var_71 = wp::extract(var_box_size, var_70);
        var_72 = wp::mul(var_68, var_71);
        var_74 = wp::floordiv(var_63, var_73);
        var_75 = wp::extract(var_2, var_74);
        var_76 = wp::sub(var_72, var_75);
        var_77 = wp::abs(var_76);
        // if closest > face_dist:                                                            <L 1197>
        var_78 = (var_61 > var_77);
        if (var_78) {
            // closest = face_dist                                                            <L 1198>
            var_79 = wp::copy(var_77);
            // k = i                                                                          <L 1199>
            var_80 = wp::copy(var_63);
        }
        var_81 = wp::where(var_78, var_79, var_61);
        var_82 = wp::where(var_78, var_80, var_62);
        // face_dist = wp.abs(wp.where(i % 2, 1.0, -1.0) * box_size[i // 2] - center[i // 2])       <L 1196>
        var_85 = wp::mod(var_83, var_84);
        var_88 = wp::where(var_85, var_86, var_87);
        var_90 = wp::floordiv(var_83, var_89);
        var_91 = wp::extract(var_box_size, var_90);
        var_92 = wp::mul(var_88, var_91);
        var_94 = wp::floordiv(var_83, var_93);
        var_95 = wp::extract(var_2, var_94);
        var_96 = wp::sub(var_92, var_95);
        var_97 = wp::abs(var_96);
        // if closest > face_dist:                                                            <L 1197>
        var_98 = (var_81 > var_97);
        if (var_98) {
            // closest = face_dist                                                            <L 1198>
            var_99 = wp::copy(var_97);
            // k = i                                                                          <L 1199>
            var_100 = wp::copy(var_83);
        }
        var_101 = wp::where(var_98, var_99, var_81);
        var_102 = wp::where(var_98, var_100, var_82);
        // face_dist = wp.abs(wp.where(i % 2, 1.0, -1.0) * box_size[i // 2] - center[i // 2])       <L 1196>
        var_105 = wp::mod(var_103, var_104);
        var_108 = wp::where(var_105, var_106, var_107);
        var_110 = wp::floordiv(var_103, var_109);
        var_111 = wp::extract(var_box_size, var_110);
        var_112 = wp::mul(var_108, var_111);
        var_114 = wp::floordiv(var_103, var_113);
        var_115 = wp::extract(var_2, var_114);
        var_116 = wp::sub(var_112, var_115);
        var_117 = wp::abs(var_116);
        // if closest > face_dist:                                                            <L 1197>
        var_118 = (var_101 > var_117);
        if (var_118) {
            // closest = face_dist                                                            <L 1198>
            var_119 = wp::copy(var_117);
            // k = i                                                                          <L 1199>
            var_120 = wp::copy(var_103);
        }
        var_121 = wp::where(var_118, var_119, var_101);
        var_122 = wp::where(var_118, var_120, var_102);
        // face_dist = wp.abs(wp.where(i % 2, 1.0, -1.0) * box_size[i // 2] - center[i // 2])       <L 1196>
        var_125 = wp::mod(var_123, var_124);
        var_128 = wp::where(var_125, var_126, var_127);
        var_130 = wp::floordiv(var_123, var_129);
        var_131 = wp::extract(var_box_size, var_130);
        var_132 = wp::mul(var_128, var_131);
        var_134 = wp::floordiv(var_123, var_133);
        var_135 = wp::extract(var_2, var_134);
        var_136 = wp::sub(var_132, var_135);
        var_137 = wp::abs(var_136);
        // if closest > face_dist:                                                            <L 1197>
        var_138 = (var_121 > var_137);
        if (var_138) {
            // closest = face_dist                                                            <L 1198>
            var_139 = wp::copy(var_137);
            // k = i                                                                          <L 1199>
            var_140 = wp::copy(var_123);
        }
        var_141 = wp::where(var_138, var_139, var_121);
        var_142 = wp::where(var_138, var_140, var_122);
        // nearest = wp.vec3(0.0)                                                             <L 1201>
        var_144 = wp::vec_t<3, wp::float32>(var_143);
        // nearest[k // 2] = wp.where(k % 2, -1.0, 1.0)                                       <L 1202>
        var_146 = wp::mod(var_142, var_145);
        var_149 = wp::where(var_146, var_147, var_148);
        var_151 = wp::floordiv(var_142, var_150);
        wp::assign_inplace(var_144, var_151, var_149);
        // pos = center + nearest * (sphere_radius - closest) / 2.0                           <L 1203>
        var_152 = wp::sub(var_sphere_radius, var_141);
        var_153 = wp::mul(var_144, var_152);
        var_155 = wp::div(var_153, var_154);
        var_156 = wp::add(var_2, var_155);
        // contact_normal = box_rot @ nearest                                                 <L 1204>
        var_157 = wp::mul(var_box_rot, var_144);
        // contact_distance = -closest - sphere_radius                                        <L 1205>
        var_158 = wp::neg(var_141);
        var_159 = wp::sub(var_158, var_sphere_radius);
    }
    if (!var_10) {
        // deepest = center + clamped_dir * sphere_radius                                     <L 1208>
        var_160 = wp::mul(var_7, var_sphere_radius);
        var_161 = wp::add(var_2, var_160);
        // pos = 0.5 * (clamped + deepest)                                                    <L 1209>
        var_163 = wp::add(var_5, var_161);
        var_164 = wp::mul(var_162, var_163);
        // contact_normal = box_rot @ clamped_dir                                             <L 1210>
        var_165 = wp::mul(var_box_rot, var_7);
        // contact_distance = dist - sphere_radius                                            <L 1211>
        var_166 = wp::sub(var_8, var_sphere_radius);
    }
    var_167 = wp::where(var_10, var_156, var_164);
    var_168 = wp::where(var_10, var_157, var_165);
    var_169 = wp::where(var_10, var_159, var_166);
    // contact_position = box_pos + box_rot @ pos                                             <L 1213>
    var_170 = wp::mul(var_box_rot, var_167);
    var_171 = wp::add(var_box_pos, var_170);
    // return contact_distance, contact_position, contact_normal                              <L 1215>
    ret_0 = var_169;
    ret_1 = var_171;
    ret_2 = var_168;
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_data.py:138
static CUDA_CALLABLE bool contact_passes_gap_check_0(
    ContactData_40360d7c var_contact_data)
{
    //---------
    // primal vars
    wp::float32* var_0;
    wp::float32* var_1;
    wp::float32 var_2;
    wp::float32 var_3;
    wp::float32 var_4;
    wp::float32* var_5;
    wp::float32 var_6;
    wp::float32 var_7;
    wp::float32* var_8;
    wp::float32 var_9;
    wp::float32 var_10;
    wp::vec_t<3, wp::float32>* var_11;
    wp::vec_t<3, wp::float32> var_12;
    wp::vec_t<3, wp::float32> var_13;
    wp::vec_t<3, wp::float32>* var_14;
    const wp::float32 var_15 = 0.5;
    wp::float32* var_16;
    wp::float32 var_17;
    wp::float32 var_18;
    wp::float32* var_19;
    wp::float32 var_20;
    wp::float32 var_21;
    wp::vec_t<3, wp::float32> var_22;
    wp::vec_t<3, wp::float32> var_23;
    wp::vec_t<3, wp::float32> var_24;
    wp::vec_t<3, wp::float32>* var_25;
    const wp::float32 var_26 = 0.5;
    wp::float32* var_27;
    wp::float32 var_28;
    wp::float32 var_29;
    wp::float32* var_30;
    wp::float32 var_31;
    wp::float32 var_32;
    wp::vec_t<3, wp::float32> var_33;
    wp::vec_t<3, wp::float32> var_34;
    wp::vec_t<3, wp::float32> var_35;
    wp::vec_t<3, wp::float32> var_36;
    wp::float32 var_37;
    wp::float32 var_38;
    wp::float32* var_39;
    bool var_40;
    wp::float32 var_41;
    //---------
    // forward
    // def contact_passes_gap_check(                                                          <L 139>
    // total_separation_needed = (                                                            <L 151>
    // contact_data.radius_eff_a + contact_data.radius_eff_b + contact_data.margin_a + contact_data.margin_b       <L 152>
    var_0 = &((var_contact_data).radius_eff_a);
    var_1 = &((var_contact_data).radius_eff_b);
    var_3 = wp::load(var_0);
    var_4 = wp::load(var_1);
    var_2 = wp::add(var_3, var_4);
    var_5 = &((var_contact_data).margin_a);
    var_7 = wp::load(var_5);
    var_6 = wp::add(var_2, var_7);
    var_8 = &((var_contact_data).margin_b);
    var_10 = wp::load(var_8);
    var_9 = wp::add(var_6, var_10);
    // contact_normal_a_to_b = wp.normalize(contact_data.contact_normal_a_to_b)               <L 156>
    var_11 = &((var_contact_data).contact_normal_a_to_b);
    var_13 = wp::load(var_11);
    var_12 = wp::normalize(var_13);
    // a_contact_world = contact_data.contact_point_center - contact_normal_a_to_b * (        <L 158>
    var_14 = &((var_contact_data).contact_point_center);
    // 0.5 * contact_data.contact_distance + contact_data.radius_eff_a                        <L 159>
    var_16 = &((var_contact_data).contact_distance);
    var_18 = wp::load(var_16);
    var_17 = wp::mul(var_15, var_18);
    var_19 = &((var_contact_data).radius_eff_a);
    var_21 = wp::load(var_19);
    var_20 = wp::add(var_17, var_21);
    var_22 = wp::mul(var_12, var_20);
    var_24 = wp::load(var_14);
    var_23 = wp::sub(var_24, var_22);
    // b_contact_world = contact_data.contact_point_center + contact_normal_a_to_b * (        <L 161>
    var_25 = &((var_contact_data).contact_point_center);
    // 0.5 * contact_data.contact_distance + contact_data.radius_eff_b                        <L 162>
    var_27 = &((var_contact_data).contact_distance);
    var_29 = wp::load(var_27);
    var_28 = wp::mul(var_26, var_29);
    var_30 = &((var_contact_data).radius_eff_b);
    var_32 = wp::load(var_30);
    var_31 = wp::add(var_28, var_32);
    var_33 = wp::mul(var_12, var_31);
    var_35 = wp::load(var_25);
    var_34 = wp::add(var_35, var_33);
    // diff = b_contact_world - a_contact_world                                               <L 165>
    var_36 = wp::sub(var_34, var_23);
    // distance = wp.dot(diff, contact_normal_a_to_b)                                         <L 166>
    var_37 = wp::dot(var_36, var_12);
    // d = distance - total_separation_needed                                                 <L 167>
    var_38 = wp::sub(var_37, var_9);
    // return d <= contact_data.gap_sum                                                       <L 169>
    var_39 = &((var_contact_data).gap_sum);
    var_41 = wp::load(var_39);
    var_40 = (var_38 <= var_41);
    return var_40;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/narrow_phase.py:208
static CUDA_CALLABLE bool create_narrow_phase_primitive_kernel__locals___admit_0(
    ContactData_40360d7c var_contact_data,
    wp::vec_t<3, wp::float32> var_position,
    wp::float32 var_distance,
    wp::array_t<wp::transform_t<wp::float32>> var_shape_transform,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_linear_velocity,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_angular_velocity,
    wp::float32 var_collision_update_dt,
    wp::float32 var_max_speculative_extension)
{
    //---------
    // primal vars
    const bool var_0 = false;
    bool var_1;
    //---------
    // forward
    // def _admit(                                                                            <L 209>
    // contact_data.contact_point_center = position                                           <L 219>
    var_contact_data.contact_point_center = var_position;
    // contact_data.contact_distance = distance                                               <L 220>
    var_contact_data.contact_distance = var_distance;
    // if wp.static(speculative):                                                             <L 221>
    // return contact_passes_gap_check(contact_data)                                          <L 230>
    var_1 = contact_passes_gap_check_0(var_contact_data);
    return var_1;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_data.py:59
static CUDA_CALLABLE wp::int64 make_contact_sort_key_0(
    wp::int32 var_shape_a,
    wp::int32 var_shape_b,
    wp::int32 var_sort_sub_key)
{
    //---------
    // primal vars
    wp::int64 var_0;
    wp::int64 var_1;
    wp::int64 var_2;
    wp::int64 var_3;
    wp::int64 var_4;
    wp::int64 var_5;
    wp::int64 var_6;
    wp::int64 var_7;
    wp::int64 var_8;
    wp::int64 var_9;
    wp::int64 var_10;
    wp::int64 var_11;
    wp::int64 var_12;
    wp::int64 var_13;
    wp::int64 var_14;
    //---------
    // forward
    // def make_contact_sort_key(shape_a: int, shape_b: int, sort_sub_key: int) -> wp.int64:       <L 60>
    // return (                                                                               <L 83>
    // ((wp.int64(shape_a) & wp.int64(0xFFFFF)) << wp.int64(43))                              <L 84>
    var_0 = wp::int64(var_shape_a);
    var_1 = 1048575ll;
    var_2 = wp::bit_and(var_0, var_1);
    var_3 = 43ll;
    var_4 = wp::lshift(var_2, var_3);
    // | ((wp.int64(shape_b) & wp.int64(0xFFFFF)) << wp.int64(23))                            <L 85>
    var_5 = wp::int64(var_shape_b);
    var_6 = 1048575ll;
    var_7 = wp::bit_and(var_5, var_6);
    var_8 = 23ll;
    var_9 = wp::lshift(var_7, var_8);
    var_10 = wp::bit_or(var_4, var_9);
    // | (wp.int64(sort_sub_key) & wp.int64(0x7FFFFF))                                        <L 86>
    var_11 = wp::int64(var_sort_sub_key);
    var_12 = 8388607ll;
    var_13 = wp::bit_and(var_11, var_12);
    var_14 = wp::bit_or(var_10, var_13);
    return var_14;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/sim/collide.py:90
static CUDA_CALLABLE void _write_contact_at_index_0(
    ContactData_40360d7c var_contact_data,
    ContactWriterData_4222ebad var_writer_data,
    wp::int32 var_index,
    wp::vec_t<3, wp::float32> var_point_a_world,
    wp::vec_t<3, wp::float32> var_point_b_world,
    wp::vec_t<3, wp::float32> var_normal_a_to_b)
{
    //---------
    // primal vars
    wp::int32* var_0;
    bool var_1;
    wp::int32 var_2;
    wp::int32* var_3;
    wp::array_t<wp::int32>* var_4;
    wp::array_t<wp::int32> var_5;
    wp::int32 var_6;
    wp::int32* var_7;
    wp::array_t<wp::int32>* var_8;
    wp::array_t<wp::int32> var_9;
    wp::int32 var_10;
    wp::array_t<wp::int32>* var_11;
    wp::int32* var_12;
    wp::int32* var_13;
    wp::array_t<wp::int32> var_14;
    wp::int32 var_15;
    wp::int32 var_16;
    wp::int32 var_17;
    wp::array_t<wp::int32>* var_18;
    wp::int32* var_19;
    wp::int32* var_20;
    wp::array_t<wp::int32> var_21;
    wp::int32 var_22;
    wp::int32 var_23;
    wp::int32 var_24;
    const wp::int32 var_25 = -1;
    bool var_26;
    wp::transform_t<wp::float32> var_27;
    wp::array_t<wp::transform_t<wp::float32>>* var_28;
    wp::transform_t<wp::float32>* var_29;
    wp::array_t<wp::transform_t<wp::float32>> var_30;
    wp::transform_t<wp::float32> var_31;
    wp::transform_t<wp::float32> var_32;
    wp::transform_t<wp::float32> var_33;
    const wp::int32 var_34 = -1;
    bool var_35;
    wp::transform_t<wp::float32> var_36;
    wp::array_t<wp::transform_t<wp::float32>>* var_37;
    wp::transform_t<wp::float32>* var_38;
    wp::array_t<wp::transform_t<wp::float32>> var_39;
    wp::transform_t<wp::float32> var_40;
    wp::transform_t<wp::float32> var_41;
    wp::transform_t<wp::float32> var_42;
    wp::vec_t<3, wp::float32> var_43;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_44;
    wp::array_t<wp::vec_t<3, wp::float32>> var_45;
    wp::vec_t<3, wp::float32> var_46;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_47;
    wp::array_t<wp::vec_t<3, wp::float32>> var_48;
    wp::float32* var_49;
    wp::float32* var_50;
    wp::float32 var_51;
    wp::float32 var_52;
    wp::float32 var_53;
    wp::float32* var_54;
    wp::float32* var_55;
    wp::float32 var_56;
    wp::float32 var_57;
    wp::float32 var_58;
    wp::vec_t<3, wp::float32> var_59;
    wp::vec_t<3, wp::float32> var_60;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_61;
    wp::array_t<wp::vec_t<3, wp::float32>> var_62;
    wp::float32 var_63;
    wp::vec_t<3, wp::float32> var_64;
    wp::vec_t<3, wp::float32> var_65;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_66;
    wp::array_t<wp::vec_t<3, wp::float32>> var_67;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_68;
    wp::array_t<wp::vec_t<3, wp::float32>> var_69;
    wp::array_t<wp::float32>* var_70;
    wp::array_t<wp::float32> var_71;
    wp::array_t<wp::float32>* var_72;
    wp::array_t<wp::float32> var_73;
    const wp::int32 var_74 = 0;
    wp::array_t<wp::int32>* var_75;
    wp::array_t<wp::int32> var_76;
    wp::array_t<wp::float32>* var_77;
    wp::shape_t* var_78;
    const wp::int32 var_79 = 0;
    wp::int32 var_80;
    wp::shape_t var_81;
    const wp::int32 var_82 = 0;
    bool var_83;
    wp::float32* var_84;
    wp::array_t<wp::float32>* var_85;
    wp::array_t<wp::float32> var_86;
    wp::float32 var_87;
    wp::float32* var_88;
    wp::array_t<wp::float32>* var_89;
    wp::array_t<wp::float32> var_90;
    wp::float32 var_91;
    wp::float32* var_92;
    wp::array_t<wp::float32>* var_93;
    wp::array_t<wp::float32> var_94;
    wp::float32 var_95;
    wp::array_t<wp::int64>* var_96;
    wp::shape_t* var_97;
    const wp::int32 var_98 = 0;
    wp::int32 var_99;
    wp::shape_t var_100;
    const wp::int32 var_101 = 0;
    bool var_102;
    wp::int32* var_103;
    wp::int32* var_104;
    wp::int32* var_105;
    wp::int64 var_106;
    wp::int32 var_107;
    wp::int32 var_108;
    wp::int32 var_109;
    wp::array_t<wp::int64>* var_110;
    wp::array_t<wp::int64> var_111;
    //---------
    // forward
    // def _write_contact_at_index(                                                           <L 91>
    // if index >= writer_data.contact_max:                                                   <L 100>
    var_0 = &((var_writer_data).contact_max);
    var_2 = wp::load(var_0);
    var_1 = (var_index >= var_2);
    if (var_1) {
        // return                                                                             <L 101>
        return;
    }
    // writer_data.out_shape0[index] = contact_data.shape_a                                   <L 103>
    var_3 = &((var_contact_data).shape_a);
    var_4 = &((var_writer_data).out_shape0);
    var_5 = wp::load(var_4);
    var_6 = wp::load(var_3);
    wp::array_store(var_5, var_index, var_6);
    // writer_data.out_shape1[index] = contact_data.shape_b                                   <L 104>
    var_7 = &((var_contact_data).shape_b);
    var_8 = &((var_writer_data).out_shape1);
    var_9 = wp::load(var_8);
    var_10 = wp::load(var_7);
    wp::array_store(var_9, var_index, var_10);
    // body0 = writer_data.shape_body[contact_data.shape_a]                                   <L 106>
    var_11 = &((var_writer_data).shape_body);
    var_12 = &((var_contact_data).shape_a);
    var_14 = wp::load(var_11);
    var_15 = wp::load(var_12);
    var_13 = wp::address(var_14, var_15);
    var_17 = wp::load(var_13);
    var_16 = wp::copy(var_17);
    // body1 = writer_data.shape_body[contact_data.shape_b]                                   <L 107>
    var_18 = &((var_writer_data).shape_body);
    var_19 = &((var_contact_data).shape_b);
    var_21 = wp::load(var_18);
    var_22 = wp::load(var_19);
    var_20 = wp::address(var_21, var_22);
    var_24 = wp::load(var_20);
    var_23 = wp::copy(var_24);
    // X_bw_a = wp.transform_identity() if body0 == -1 else wp.transform_inverse(writer_data.body_q[body0])       <L 108>
    var_26 = (var_16 == var_25);
    if (var_26) {
        var_27 = wp::transform_identity<wp::float32>();
    }
    if (!var_26) {
        var_28 = &((var_writer_data).body_q);
        var_30 = wp::load(var_28);
        var_29 = wp::address(var_30, var_16);
        var_32 = wp::load(var_29);
        var_31 = wp::transform_inverse(var_32);
    }
    var_33 = wp::where(var_26, var_27, var_31);
    // X_bw_b = wp.transform_identity() if body1 == -1 else wp.transform_inverse(writer_data.body_q[body1])       <L 109>
    var_35 = (var_23 == var_34);
    if (var_35) {
        var_36 = wp::transform_identity<wp::float32>();
    }
    if (!var_35) {
        var_37 = &((var_writer_data).body_q);
        var_39 = wp::load(var_37);
        var_38 = wp::address(var_39, var_23);
        var_41 = wp::load(var_38);
        var_40 = wp::transform_inverse(var_41);
    }
    var_42 = wp::where(var_35, var_36, var_40);
    // writer_data.out_point0[index] = wp.transform_point(X_bw_a, point_a_world)              <L 111>
    var_43 = wp::transform_point(var_33, var_point_a_world);
    var_44 = &((var_writer_data).out_point0);
    var_45 = wp::load(var_44);
    wp::array_store(var_45, var_index, var_43);
    // writer_data.out_point1[index] = wp.transform_point(X_bw_b, point_b_world)              <L 112>
    var_46 = wp::transform_point(var_42, var_point_b_world);
    var_47 = &((var_writer_data).out_point1);
    var_48 = wp::load(var_47);
    wp::array_store(var_48, var_index, var_46);
    // offset_mag_a = contact_data.radius_eff_a + contact_data.margin_a                       <L 114>
    var_49 = &((var_contact_data).radius_eff_a);
    var_50 = &((var_contact_data).margin_a);
    var_52 = wp::load(var_49);
    var_53 = wp::load(var_50);
    var_51 = wp::add(var_52, var_53);
    // offset_mag_b = contact_data.radius_eff_b + contact_data.margin_b                       <L 115>
    var_54 = &((var_contact_data).radius_eff_b);
    var_55 = &((var_contact_data).margin_b);
    var_57 = wp::load(var_54);
    var_58 = wp::load(var_55);
    var_56 = wp::add(var_57, var_58);
    // writer_data.out_offset0[index] = wp.transform_vector(X_bw_a, offset_mag_a * normal_a_to_b)       <L 116>
    var_59 = wp::mul(var_51, var_normal_a_to_b);
    var_60 = wp::transform_vector(var_33, var_59);
    var_61 = &((var_writer_data).out_offset0);
    var_62 = wp::load(var_61);
    wp::array_store(var_62, var_index, var_60);
    // writer_data.out_offset1[index] = wp.transform_vector(X_bw_b, -offset_mag_b * normal_a_to_b)       <L 117>
    var_63 = wp::neg(var_56);
    var_64 = wp::mul(var_63, var_normal_a_to_b);
    var_65 = wp::transform_vector(var_42, var_64);
    var_66 = &((var_writer_data).out_offset1);
    var_67 = wp::load(var_66);
    wp::array_store(var_67, var_index, var_65);
    // writer_data.out_normal[index] = normal_a_to_b                                          <L 118>
    var_68 = &((var_writer_data).out_normal);
    var_69 = wp::load(var_68);
    wp::array_store(var_69, var_index, var_normal_a_to_b);
    // writer_data.out_margin0[index] = offset_mag_a                                          <L 119>
    var_70 = &((var_writer_data).out_margin0);
    var_71 = wp::load(var_70);
    wp::array_store(var_71, var_index, var_51);
    // writer_data.out_margin1[index] = offset_mag_b                                          <L 120>
    var_72 = &((var_writer_data).out_margin1);
    var_73 = wp::load(var_72);
    wp::array_store(var_73, var_index, var_56);
    // writer_data.out_tids[index] = 0                                                        <L 121>
    var_75 = &((var_writer_data).out_tids);
    var_76 = wp::load(var_75);
    wp::array_store(var_76, var_index, var_74);
    // if writer_data.out_stiffness.shape[0] > 0:                                             <L 123>
    var_77 = &((var_writer_data).out_stiffness);
    var_78 = &(var_77->shape);
    var_81 = wp::load(var_78);
    var_80 = wp::extract(var_81, var_79);
    var_83 = (var_80 > var_82);
    if (var_83) {
        // writer_data.out_stiffness[index] = contact_data.contact_stiffness                  <L 124>
        var_84 = &((var_contact_data).contact_stiffness);
        var_85 = &((var_writer_data).out_stiffness);
        var_86 = wp::load(var_85);
        var_87 = wp::load(var_84);
        wp::array_store(var_86, var_index, var_87);
        // writer_data.out_damping[index] = contact_data.contact_damping                      <L 125>
        var_88 = &((var_contact_data).contact_damping);
        var_89 = &((var_writer_data).out_damping);
        var_90 = wp::load(var_89);
        var_91 = wp::load(var_88);
        wp::array_store(var_90, var_index, var_91);
        // writer_data.out_friction[index] = contact_data.contact_friction_scale              <L 126>
        var_92 = &((var_contact_data).contact_friction_scale);
        var_93 = &((var_writer_data).out_friction);
        var_94 = wp::load(var_93);
        var_95 = wp::load(var_92);
        wp::array_store(var_94, var_index, var_95);
    }
    // if writer_data.out_sort_key.shape[0] > 0:                                              <L 128>
    var_96 = &((var_writer_data).out_sort_key);
    var_97 = &(var_96->shape);
    var_100 = wp::load(var_97);
    var_99 = wp::extract(var_100, var_98);
    var_102 = (var_99 > var_101);
    if (var_102) {
        // writer_data.out_sort_key[index] = make_contact_sort_key(                           <L 129>
        // contact_data.shape_a, contact_data.shape_b, contact_data.sort_sub_key              <L 130>
        var_103 = &((var_contact_data).shape_a);
        var_104 = &((var_contact_data).shape_b);
        var_105 = &((var_contact_data).sort_sub_key);
        var_107 = wp::load(var_103);
        var_108 = wp::load(var_104);
        var_109 = wp::load(var_105);
        var_106 = make_contact_sort_key_0(var_107, var_108, var_109);
        // writer_data.out_sort_key[index] = make_contact_sort_key(                           <L 129>
        var_110 = &((var_writer_data).out_sort_key);
        var_111 = wp::load(var_110);
        wp::array_store(var_111, var_index, var_106);
    }
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/sim/collide.py:134
static CUDA_CALLABLE void write_contact_0(
    ContactData_40360d7c var_contact_data,
    ContactWriterData_4222ebad var_writer_data,
    wp::int32 var_output_index)
{
    //---------
    // primal vars
    wp::float32* var_0;
    wp::float32* var_1;
    wp::float32 var_2;
    wp::float32 var_3;
    wp::float32 var_4;
    wp::float32* var_5;
    wp::float32 var_6;
    wp::float32 var_7;
    wp::float32* var_8;
    wp::float32 var_9;
    wp::float32 var_10;
    wp::vec_t<3, wp::float32>* var_11;
    wp::vec_t<3, wp::float32> var_12;
    wp::vec_t<3, wp::float32> var_13;
    wp::vec_t<3, wp::float32>* var_14;
    const wp::float32 var_15 = 0.5;
    wp::float32* var_16;
    wp::float32 var_17;
    wp::float32 var_18;
    wp::float32* var_19;
    wp::float32 var_20;
    wp::float32 var_21;
    wp::vec_t<3, wp::float32> var_22;
    wp::vec_t<3, wp::float32> var_23;
    wp::vec_t<3, wp::float32> var_24;
    wp::vec_t<3, wp::float32>* var_25;
    const wp::float32 var_26 = 0.5;
    wp::float32* var_27;
    wp::float32 var_28;
    wp::float32 var_29;
    wp::float32* var_30;
    wp::float32 var_31;
    wp::float32 var_32;
    wp::vec_t<3, wp::float32> var_33;
    wp::vec_t<3, wp::float32> var_34;
    wp::vec_t<3, wp::float32> var_35;
    wp::vec_t<3, wp::float32> var_36;
    wp::float32 var_37;
    wp::float32 var_38;
    wp::array_t<wp::float32>* var_39;
    wp::int32* var_40;
    wp::float32* var_41;
    wp::array_t<wp::float32> var_42;
    wp::int32 var_43;
    wp::float32 var_44;
    wp::float32 var_45;
    wp::array_t<wp::float32>* var_46;
    wp::int32* var_47;
    wp::float32* var_48;
    wp::array_t<wp::float32> var_49;
    wp::int32 var_50;
    wp::float32 var_51;
    wp::float32 var_52;
    wp::float32 var_53;
    wp::int32 var_54;
    const wp::int32 var_55 = 0;
    bool var_56;
    bool var_57;
    wp::array_t<wp::int32>* var_58;
    const wp::int32 var_59 = 0;
    const wp::int32 var_60 = 1;
    wp::int32 var_61;
    wp::array_t<wp::int32> var_62;
    wp::int32 var_63;
    //---------
    // forward
    // def write_contact(                                                                     <L 135>
    // total_separation_needed = (                                                            <L 148>
    // contact_data.radius_eff_a + contact_data.radius_eff_b + contact_data.margin_a + contact_data.margin_b       <L 149>
    var_0 = &((var_contact_data).radius_eff_a);
    var_1 = &((var_contact_data).radius_eff_b);
    var_3 = wp::load(var_0);
    var_4 = wp::load(var_1);
    var_2 = wp::add(var_3, var_4);
    var_5 = &((var_contact_data).margin_a);
    var_7 = wp::load(var_5);
    var_6 = wp::add(var_2, var_7);
    var_8 = &((var_contact_data).margin_b);
    var_10 = wp::load(var_8);
    var_9 = wp::add(var_6, var_10);
    // contact_normal_a_to_b = wp.normalize(contact_data.contact_normal_a_to_b)               <L 153>
    var_11 = &((var_contact_data).contact_normal_a_to_b);
    var_13 = wp::load(var_11);
    var_12 = wp::normalize(var_13);
    // a_contact_world = contact_data.contact_point_center - contact_normal_a_to_b * (        <L 155>
    var_14 = &((var_contact_data).contact_point_center);
    // 0.5 * contact_data.contact_distance + contact_data.radius_eff_a                        <L 156>
    var_16 = &((var_contact_data).contact_distance);
    var_18 = wp::load(var_16);
    var_17 = wp::mul(var_15, var_18);
    var_19 = &((var_contact_data).radius_eff_a);
    var_21 = wp::load(var_19);
    var_20 = wp::add(var_17, var_21);
    var_22 = wp::mul(var_12, var_20);
    var_24 = wp::load(var_14);
    var_23 = wp::sub(var_24, var_22);
    // b_contact_world = contact_data.contact_point_center + contact_normal_a_to_b * (        <L 158>
    var_25 = &((var_contact_data).contact_point_center);
    // 0.5 * contact_data.contact_distance + contact_data.radius_eff_b                        <L 159>
    var_27 = &((var_contact_data).contact_distance);
    var_29 = wp::load(var_27);
    var_28 = wp::mul(var_26, var_29);
    var_30 = &((var_contact_data).radius_eff_b);
    var_32 = wp::load(var_30);
    var_31 = wp::add(var_28, var_32);
    var_33 = wp::mul(var_12, var_31);
    var_35 = wp::load(var_25);
    var_34 = wp::add(var_35, var_33);
    // diff = b_contact_world - a_contact_world                                               <L 162>
    var_36 = wp::sub(var_34, var_23);
    // distance = wp.dot(diff, contact_normal_a_to_b)                                         <L 163>
    var_37 = wp::dot(var_36, var_12);
    // d = distance - total_separation_needed                                                 <L 164>
    var_38 = wp::sub(var_37, var_9);
    // gap_a = writer_data.shape_gap[contact_data.shape_a]                                    <L 167>
    var_39 = &((var_writer_data).shape_gap);
    var_40 = &((var_contact_data).shape_a);
    var_42 = wp::load(var_39);
    var_43 = wp::load(var_40);
    var_41 = wp::address(var_42, var_43);
    var_45 = wp::load(var_41);
    var_44 = wp::copy(var_45);
    // gap_b = writer_data.shape_gap[contact_data.shape_b]                                    <L 168>
    var_46 = &((var_writer_data).shape_gap);
    var_47 = &((var_contact_data).shape_b);
    var_49 = wp::load(var_46);
    var_50 = wp::load(var_47);
    var_48 = wp::address(var_49, var_50);
    var_52 = wp::load(var_48);
    var_51 = wp::copy(var_52);
    // contact_gap = gap_a + gap_b                                                            <L 169>
    var_53 = wp::add(var_44, var_51);
    // index = output_index                                                                   <L 171>
    var_54 = wp::copy(var_output_index);
    // if index < 0:                                                                          <L 173>
    var_56 = (var_54 < var_55);
    if (var_56) {
        // if d > contact_gap:                                                                <L 175>
        var_57 = (var_38 > var_53);
        if (var_57) {
            // return                                                                         <L 176>
            return;
        }
        // index = wp.atomic_add(writer_data.contact_count, 0, 1)                             <L 177>
        var_58 = &((var_writer_data).contact_count);
        var_62 = wp::load(var_58);
        var_61 = wp::atomic_add(var_62, var_59, var_60);
    }
    var_63 = wp::where(var_56, var_61, var_54);
    // _write_contact_at_index(contact_data, writer_data, index, a_contact_world, b_contact_world, contact_normal_a_to_b)       <L 178>
    _write_contact_at_index_0(var_contact_data, var_writer_data, var_63, var_23, var_34, var_12);
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/collision_primitive.py:100
static CUDA_CALLABLE void adj_collide_plane_sphere_0(
    wp::vec_t<3, wp::float32> var_plane_normal,
    wp::vec_t<3, wp::float32> var_plane_pos,
    wp::vec_t<3, wp::float32> var_sphere_pos,
    wp::float32 var_sphere_radius,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & adj_plane_normal,
    wp::vec_t<3, wp::float32> & adj_plane_pos,
    wp::vec_t<3, wp::float32> & adj_sphere_pos,
    wp::float32 & adj_sphere_radius,
    wp::float32 & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/collision_primitive.py:333
static CUDA_CALLABLE void adj_collide_plane_ellipsoid_0(
    wp::vec_t<3, wp::float32> var_plane_normal,
    wp::vec_t<3, wp::float32> var_plane_pos,
    wp::vec_t<3, wp::float32> var_ellipsoid_pos,
    wp::mat_t<3, 3, wp::float32> var_ellipsoid_rot,
    wp::vec_t<3, wp::float32> var_ellipsoid_size,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & ret_2,
    wp::vec_t<3, wp::float32> & adj_plane_normal,
    wp::vec_t<3, wp::float32> & adj_plane_pos,
    wp::vec_t<3, wp::float32> & adj_ellipsoid_pos,
    wp::mat_t<3, 3, wp::float32> & adj_ellipsoid_rot,
    wp::vec_t<3, wp::float32> & adj_ellipsoid_size,
    wp::float32 & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1,
    wp::vec_t<3, wp::float32> & adj_ret_2)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/collision_primitive.py:365
static CUDA_CALLABLE void adj_collide_plane_box_0(
    wp::vec_t<3, wp::float32> var_plane_normal,
    wp::vec_t<3, wp::float32> var_plane_pos,
    wp::vec_t<3, wp::float32> var_box_pos,
    wp::mat_t<3, 3, wp::float32> var_box_rot,
    wp::vec_t<3, wp::float32> var_box_size,
    wp::float32 var_margin,
    wp::vec_t<4, wp::float32> & ret_0,
    wp::mat_t<4, 3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & ret_2,
    wp::vec_t<3, wp::float32> & adj_plane_normal,
    wp::vec_t<3, wp::float32> & adj_plane_pos,
    wp::vec_t<3, wp::float32> & adj_box_pos,
    wp::mat_t<3, 3, wp::float32> & adj_box_rot,
    wp::vec_t<3, wp::float32> & adj_box_size,
    wp::float32 & adj_margin,
    wp::vec_t<4, wp::float32> & adj_ret_0,
    wp::mat_t<4, 3, wp::float32> & adj_ret_1,
    wp::vec_t<3, wp::float32> & adj_ret_2)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/collision_primitive.py:110
static CUDA_CALLABLE void adj_collide_sphere_sphere_0(
    wp::vec_t<3, wp::float32> var_pos1,
    wp::float32 var_radius1,
    wp::vec_t<3, wp::float32> var_pos2,
    wp::float32 var_radius2,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & ret_2,
    wp::vec_t<3, wp::float32> & adj_pos1,
    wp::float32 & adj_radius1,
    wp::vec_t<3, wp::float32> & adj_pos2,
    wp::float32 & adj_radius2,
    wp::float32 & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1,
    wp::vec_t<3, wp::float32> & adj_ret_2)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/math/__init__.py:0
static CUDA_CALLABLE void adj_normalize_with_norm_0(
    wp::vec_t<3, wp::float32> var_x,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::float32 & ret_1,
    wp::vec_t<3, wp::float32> & adj_x,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::float32 & adj_ret_1)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/collision_primitive.py:278
static CUDA_CALLABLE void adj_collide_plane_capsule_0(
    wp::vec_t<3, wp::float32> var_plane_normal,
    wp::vec_t<3, wp::float32> var_plane_pos,
    wp::vec_t<3, wp::float32> var_capsule_pos,
    wp::vec_t<3, wp::float32> var_capsule_axis,
    wp::float32 var_capsule_radius,
    wp::float32 var_capsule_half_length,
    wp::vec_t<2, wp::float32> & ret_0,
    wp::mat_t<2, 3, wp::float32> & ret_1,
    wp::mat_t<3, 3, wp::float32> & ret_2,
    wp::vec_t<3, wp::float32> & adj_plane_normal,
    wp::vec_t<3, wp::float32> & adj_plane_pos,
    wp::vec_t<3, wp::float32> & adj_capsule_pos,
    wp::vec_t<3, wp::float32> & adj_capsule_axis,
    wp::float32 & adj_capsule_radius,
    wp::float32 & adj_capsule_half_length,
    wp::vec_t<2, wp::float32> & adj_ret_0,
    wp::mat_t<2, 3, wp::float32> & adj_ret_1,
    wp::mat_t<3, 3, wp::float32> & adj_ret_2)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/collision_primitive.py:515
static CUDA_CALLABLE void adj_collide_plane_cylinder_0(
    wp::vec_t<3, wp::float32> var_plane_normal,
    wp::vec_t<3, wp::float32> var_plane_pos,
    wp::vec_t<3, wp::float32> var_cylinder_pos,
    wp::vec_t<3, wp::float32> var_cylinder_axis,
    wp::float32 var_cylinder_radius,
    wp::float32 var_cylinder_half_height,
    wp::vec_t<4, wp::float32> & ret_0,
    wp::mat_t<4, 3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & ret_2,
    wp::vec_t<3, wp::float32> & adj_plane_normal,
    wp::vec_t<3, wp::float32> & adj_plane_pos,
    wp::vec_t<3, wp::float32> & adj_cylinder_pos,
    wp::vec_t<3, wp::float32> & adj_cylinder_axis,
    wp::float32 & adj_cylinder_radius,
    wp::float32 & adj_cylinder_half_height,
    wp::vec_t<4, wp::float32> & adj_ret_0,
    wp::mat_t<4, 3, wp::float32> & adj_ret_1,
    wp::vec_t<3, wp::float32> & adj_ret_2)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/collision_primitive.py:48
static CUDA_CALLABLE void adj_closest_segment_point_0(
    wp::vec_t<3, wp::float32> var_a,
    wp::vec_t<3, wp::float32> var_b,
    wp::vec_t<3, wp::float32> var_pt,
    wp::vec_t<3, wp::float32> & adj_a,
    wp::vec_t<3, wp::float32> & adj_b,
    wp::vec_t<3, wp::float32> & adj_pt,
    wp::vec_t<3, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/collision_primitive.py:143
static CUDA_CALLABLE void adj_collide_sphere_capsule_0(
    wp::vec_t<3, wp::float32> var_sphere_pos,
    wp::float32 var_sphere_radius,
    wp::vec_t<3, wp::float32> var_capsule_pos,
    wp::vec_t<3, wp::float32> var_capsule_axis,
    wp::float32 var_capsule_radius,
    wp::float32 var_capsule_half_length,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & ret_2,
    wp::vec_t<3, wp::float32> & adj_sphere_pos,
    wp::float32 & adj_sphere_radius,
    wp::vec_t<3, wp::float32> & adj_capsule_pos,
    wp::vec_t<3, wp::float32> & adj_capsule_axis,
    wp::float32 & adj_capsule_radius,
    wp::float32 & adj_capsule_half_length,
    wp::float32 & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1,
    wp::vec_t<3, wp::float32> & adj_ret_2)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/collision_primitive.py:180
static CUDA_CALLABLE void adj_collide_capsule_capsule_0(
    wp::vec_t<3, wp::float32> var_cap1_pos,
    wp::vec_t<3, wp::float32> var_cap1_axis,
    wp::float32 var_cap1_radius,
    wp::float32 var_cap1_half_length,
    wp::vec_t<3, wp::float32> var_cap2_pos,
    wp::vec_t<3, wp::float32> var_cap2_axis,
    wp::float32 var_cap2_radius,
    wp::float32 var_cap2_half_length,
    wp::vec_t<2, wp::float32> & ret_0,
    wp::mat_t<2, 3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & ret_2,
    wp::vec_t<3, wp::float32> & adj_cap1_pos,
    wp::vec_t<3, wp::float32> & adj_cap1_axis,
    wp::float32 & adj_cap1_radius,
    wp::float32 & adj_cap1_half_length,
    wp::vec_t<3, wp::float32> & adj_cap2_pos,
    wp::vec_t<3, wp::float32> & adj_cap2_axis,
    wp::float32 & adj_cap2_radius,
    wp::float32 & adj_cap2_half_length,
    wp::vec_t<2, wp::float32> & adj_ret_0,
    wp::mat_t<2, 3, wp::float32> & adj_ret_1,
    wp::vec_t<3, wp::float32> & adj_ret_2)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/math/__init__.py:0
static CUDA_CALLABLE void adj_safe_div_0(
    wp::float32 var_x,
    wp::float32 var_y,
    wp::float32 var_eps,
    wp::float32 & adj_x,
    wp::float32 & adj_y,
    wp::float32 & adj_eps,
    wp::float32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/collision_primitive.py:442
static CUDA_CALLABLE void adj_collide_sphere_cylinder_0(
    wp::vec_t<3, wp::float32> var_sphere_pos,
    wp::float32 var_sphere_radius,
    wp::vec_t<3, wp::float32> var_cylinder_pos,
    wp::vec_t<3, wp::float32> var_cylinder_axis,
    wp::float32 var_cylinder_radius,
    wp::float32 var_cylinder_half_height,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & ret_2,
    wp::vec_t<3, wp::float32> & adj_sphere_pos,
    wp::float32 & adj_sphere_radius,
    wp::vec_t<3, wp::float32> & adj_cylinder_pos,
    wp::vec_t<3, wp::float32> & adj_cylinder_axis,
    wp::float32 & adj_cylinder_radius,
    wp::float32 & adj_cylinder_half_height,
    wp::float32 & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1,
    wp::vec_t<3, wp::float32> & adj_ret_2)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/collision_primitive.py:1161
static CUDA_CALLABLE void adj_collide_sphere_box_0(
    wp::vec_t<3, wp::float32> var_sphere_pos,
    wp::float32 var_sphere_radius,
    wp::vec_t<3, wp::float32> var_box_pos,
    wp::mat_t<3, 3, wp::float32> var_box_rot,
    wp::vec_t<3, wp::float32> var_box_size,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & ret_2,
    wp::vec_t<3, wp::float32> & adj_sphere_pos,
    wp::float32 & adj_sphere_radius,
    wp::vec_t<3, wp::float32> & adj_box_pos,
    wp::mat_t<3, 3, wp::float32> & adj_box_rot,
    wp::vec_t<3, wp::float32> & adj_box_size,
    wp::float32 & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1,
    wp::vec_t<3, wp::float32> & adj_ret_2)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_data.py:138
static CUDA_CALLABLE void adj_contact_passes_gap_check_0(
    ContactData_40360d7c var_contact_data,
    ContactData_40360d7c & adj_contact_data,
    bool & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/narrow_phase.py:208
static CUDA_CALLABLE void adj_create_narrow_phase_primitive_kernel__locals___admit_0(
    ContactData_40360d7c var_contact_data,
    wp::vec_t<3, wp::float32> var_position,
    wp::float32 var_distance,
    wp::array_t<wp::transform_t<wp::float32>> var_shape_transform,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_linear_velocity,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_angular_velocity,
    wp::float32 var_collision_update_dt,
    wp::float32 var_max_speculative_extension,
    ContactData_40360d7c & adj_contact_data,
    wp::vec_t<3, wp::float32> & adj_position,
    wp::float32 & adj_distance,
    wp::array_t<wp::transform_t<wp::float32>> & adj_shape_transform,
    wp::array_t<wp::vec_t<3, wp::float32>> & adj_shape_linear_velocity,
    wp::array_t<wp::vec_t<3, wp::float32>> & adj_shape_angular_velocity,
    wp::float32 & adj_collision_update_dt,
    wp::float32 & adj_max_speculative_extension,
    bool & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_data.py:59
static CUDA_CALLABLE void adj_make_contact_sort_key_0(
    wp::int32 var_shape_a,
    wp::int32 var_shape_b,
    wp::int32 var_sort_sub_key,
    wp::int32 & adj_shape_a,
    wp::int32 & adj_shape_b,
    wp::int32 & adj_sort_sub_key,
    wp::int64 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/sim/collide.py:90
static CUDA_CALLABLE void adj__write_contact_at_index_0(
    ContactData_40360d7c var_contact_data,
    ContactWriterData_4222ebad var_writer_data,
    wp::int32 var_index,
    wp::vec_t<3, wp::float32> var_point_a_world,
    wp::vec_t<3, wp::float32> var_point_b_world,
    wp::vec_t<3, wp::float32> var_normal_a_to_b,
    ContactData_40360d7c & adj_contact_data,
    ContactWriterData_4222ebad & adj_writer_data,
    wp::int32 & adj_index,
    wp::vec_t<3, wp::float32> & adj_point_a_world,
    wp::vec_t<3, wp::float32> & adj_point_b_world,
    wp::vec_t<3, wp::float32> & adj_normal_a_to_b)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/sim/collide.py:134
static CUDA_CALLABLE void adj_write_contact_0(
    ContactData_40360d7c var_contact_data,
    ContactWriterData_4222ebad var_writer_data,
    wp::int32 var_output_index,
    ContactData_40360d7c & adj_contact_data,
    ContactWriterData_4222ebad & adj_writer_data,
    wp::int32 & adj_output_index)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}



extern "C" __global__ void create_narrow_phase_primitive_kernel__locals__narrow_phase_primitive_kernel_d6bc4a12_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::vec_t<2, wp::int32>> var_candidate_pair,
    wp::array_t<wp::int32> var_candidate_pair_count,
    wp::array_t<wp::int32> var_shape_types,
    wp::array_t<wp::vec_t<4, wp::float32>> var_shape_data,
    wp::array_t<wp::transform_t<wp::float32>> var_shape_transform,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_linear_velocity,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_angular_velocity,
    wp::float32 var_collision_update_dt,
    wp::float32 var_max_speculative_extension,
    wp::array_t<wp::uint64> var_shape_source,
    wp::array_t<wp::float32> var_shape_gap,
    wp::array_t<wp::int32> var_shape_flags,
    wp::array_t<wp::int32> var_shape_sdf_index,
    wp::array_t<wp::vec_t<2, wp::int32>> var_shape_edge_range,
    ContactWriterData_4222ebad var_writer_data,
    wp::int32 var_total_num_threads,
    wp::array_t<wp::vec_t<2, wp::int32>> var_gjk_candidate_pairs,
    wp::array_t<wp::int32> var_gjk_candidate_pairs_count,
    wp::array_t<wp::vec_t<2, wp::int32>> var_shape_pairs_mesh,
    wp::array_t<wp::int32> var_shape_pairs_mesh_count,
    wp::array_t<wp::vec_t<2, wp::int32>> var_shape_pairs_mesh_plane,
    wp::array_t<wp::int32> var_shape_pairs_mesh_plane_cumsum,
    wp::array_t<wp::int32> var_shape_pairs_mesh_plane_count,
    wp::array_t<wp::int32> var_mesh_plane_vertex_total_count,
    wp::array_t<wp::vec_t<2, wp::int32>> var_shape_pairs_mesh_mesh,
    wp::array_t<wp::int32> var_shape_pairs_mesh_mesh_count,
    wp::array_t<wp::vec_t<2, wp::int32>> var_shape_pairs_sdf_sdf,
    wp::array_t<wp::int32> var_shape_pairs_sdf_sdf_count)
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
        wp::shape_t* var_1;
        const wp::int32 var_2 = 0;
        wp::int32 var_3;
        wp::shape_t var_4;
        const wp::int32 var_5 = 0;
        wp::int32* var_6;
        wp::int32 var_7;
        wp::int32 var_8;
        const wp::int32 var_9 = 0;
        bool var_10;
        wp::range_t var_11;
        wp::int32 var_12;
        wp::vec_t<2, wp::int32>* var_13;
        wp::vec_t<2, wp::int32> var_14;
        wp::vec_t<2, wp::int32> var_15;
        const wp::int32 var_16 = 0;
        wp::int32 var_17;
        const wp::int32 var_18 = 1;
        wp::int32 var_19;
        bool var_20;
        bool var_21;
        const wp::int32 var_22 = 0;
        bool var_23;
        const wp::int32 var_24 = 0;
        bool var_25;
        wp::int32* var_26;
        wp::int32 var_27;
        wp::int32 var_28;
        wp::int32* var_29;
        wp::int32 var_30;
        wp::int32 var_31;
        bool var_32;
        wp::int32 var_33;
        wp::int32 var_34;
        wp::int32 var_35;
        wp::int32 var_36;
        wp::int32* var_37;
        const wp::int32 var_38 = 16;
        wp::int32 var_39;
        wp::int32 var_40;
        const wp::int32 var_41 = 0;
        bool var_42;
        wp::int32* var_43;
        const wp::int32 var_44 = 16;
        wp::int32 var_45;
        wp::int32 var_46;
        const wp::int32 var_47 = 0;
        bool var_48;
        bool var_49;
        const wp::int32 var_50 = 0;
        const wp::int32 var_51 = 1;
        wp::int32 var_52;
        wp::shape_t* var_53;
        const wp::int32 var_54 = 0;
        wp::int32 var_55;
        wp::shape_t var_56;
        bool var_57;
        wp::vec_t<2, wp::int32> var_58;
        wp::vec_t<4, wp::float32>* var_59;
        wp::vec_t<4, wp::float32> var_60;
        wp::vec_t<4, wp::float32> var_61;
        wp::vec_t<4, wp::float32>* var_62;
        wp::vec_t<4, wp::float32> var_63;
        wp::vec_t<4, wp::float32> var_64;
        const wp::int32 var_65 = 0;
        wp::float32 var_66;
        const wp::int32 var_67 = 1;
        wp::float32 var_68;
        const wp::int32 var_69 = 2;
        wp::float32 var_70;
        wp::vec_t<3, wp::float32> var_71;
        const wp::int32 var_72 = 0;
        wp::float32 var_73;
        const wp::int32 var_74 = 1;
        wp::float32 var_75;
        const wp::int32 var_76 = 2;
        wp::float32 var_77;
        wp::vec_t<3, wp::float32> var_78;
        const wp::int32 var_79 = 3;
        wp::float32 var_80;
        const wp::int32 var_81 = 3;
        wp::float32 var_82;
        wp::transform_t<wp::float32>* var_83;
        wp::transform_t<wp::float32> var_84;
        wp::transform_t<wp::float32> var_85;
        wp::transform_t<wp::float32>* var_86;
        wp::transform_t<wp::float32> var_87;
        wp::transform_t<wp::float32> var_88;
        wp::vec_t<3, wp::float32> var_89;
        wp::vec_t<3, wp::float32> var_90;
        wp::quat_t<wp::float32> var_91;
        wp::quat_t<wp::float32> var_92;
        wp::float32* var_93;
        wp::float32 var_94;
        wp::float32 var_95;
        wp::float32* var_96;
        wp::float32 var_97;
        wp::float32 var_98;
        wp::float32 var_99;
        const wp::int32 var_100 = 2;
        bool var_101;
        const wp::int32 var_102 = 2;
        bool var_103;
        bool var_104;
        bool var_105;
        const wp::int32 var_106 = 8;
        bool var_107;
        bool var_108;
        const wp::int32 var_109 = 8;
        bool var_110;
        bool var_111;
        bool var_112;
        const wp::int32 var_113 = 1073741824;
        wp::int32 var_114;
        wp::int32 var_115;
        const wp::int32 var_116 = 1073741824;
        wp::int32 var_117;
        wp::int32 var_118;
        wp::int32 var_119;
        wp::int32 var_120;
        wp::int32 var_121;
        wp::int32 var_122;
        wp::int32 var_123;
        wp::int32 var_124;
        wp::int32 var_125;
        const wp::int32 var_126 = 0;
        const wp::int32 var_127 = 1;
        wp::int32 var_128;
        wp::shape_t* var_129;
        const wp::int32 var_130 = 0;
        wp::int32 var_131;
        wp::shape_t var_132;
        bool var_133;
        wp::vec_t<2, wp::int32> var_134;
        wp::int32 var_135;
        wp::vec_t<2, wp::int32> var_136;
        wp::vec_t<2, wp::int32> var_137;
        wp::vec_t<2, wp::int32> var_138;
        const wp::int32 var_139 = 0;
        const wp::int32 var_140 = 1;
        wp::int32 var_141;
        wp::shape_t* var_142;
        const wp::int32 var_143 = 0;
        wp::int32 var_144;
        wp::shape_t var_145;
        bool var_146;
        wp::int32 var_147;
        const wp::int32 var_148 = 8;
        bool var_149;
        const wp::int32 var_150 = 8;
        bool var_151;
        const wp::int32 var_152 = 7;
        bool var_153;
        const wp::int32 var_154 = 7;
        bool var_155;
        const wp::int32 var_156 = 1;
        bool var_157;
        bool var_158;
        bool var_159;
        const wp::int32 var_160 = 0;
        wp::float32 var_161;
        const wp::float32 var_162 = 0.0;
        bool var_163;
        const wp::int32 var_164 = 1;
        wp::float32 var_165;
        const wp::float32 var_166 = 0.0;
        bool var_167;
        bool var_168;
        wp::int32* var_169;
        const wp::int32 var_170 = 0;
        bool var_171;
        wp::int32 var_172;
        wp::vec_t<2, wp::int32>* var_173;
        const wp::int32 var_174 = 1;
        wp::int32 var_175;
        wp::vec_t<2, wp::int32> var_176;
        const wp::int32 var_177 = 0;
        bool var_178;
        bool var_179;
        wp::int32* var_180;
        const wp::int32 var_181 = 0;
        bool var_182;
        wp::int32 var_183;
        wp::vec_t<2, wp::int32>* var_184;
        const wp::int32 var_185 = 1;
        wp::int32 var_186;
        wp::vec_t<2, wp::int32> var_187;
        const wp::int32 var_188 = 0;
        bool var_189;
        bool var_190;
        bool var_191;
        bool var_192;
        wp::shape_t* var_193;
        const wp::int32 var_194 = 0;
        wp::int32 var_195;
        wp::shape_t var_196;
        const wp::int32 var_197 = 0;
        bool var_198;
        bool var_199;
        bool var_200;
        const wp::int32 var_201 = 0;
        const wp::int32 var_202 = 1;
        wp::int32 var_203;
        wp::shape_t* var_204;
        const wp::int32 var_205 = 0;
        wp::int32 var_206;
        wp::shape_t var_207;
        bool var_208;
        wp::vec_t<2, wp::int32> var_209;
        wp::int32 var_210;
        bool var_211;
        wp::uint64* var_212;
        wp::uint64 var_213;
        wp::uint64 var_214;
        wp::uint64 var_215;
        bool var_216;
        wp::Mesh var_217;
        wp::array_t<wp::vec_t<3, wp::float32>>* var_218;
        wp::shape_t* var_219;
        const wp::int32 var_220 = 0;
        wp::int32 var_221;
        wp::shape_t var_222;
        const wp::int32 var_223 = 0;
        const wp::int32 var_224 = 1;
        wp::int32 var_225;
        wp::shape_t* var_226;
        const wp::int32 var_227 = 0;
        wp::int32 var_228;
        wp::shape_t var_229;
        bool var_230;
        wp::vec_t<2, wp::int32> var_231;
        const wp::int32 var_232 = 0;
        wp::int32 var_233;
        wp::int32 var_234;
        bool var_235;
        const wp::int32 var_236 = 0;
        const wp::int32 var_237 = 1;
        wp::int32 var_238;
        wp::shape_t* var_239;
        const wp::int32 var_240 = 0;
        wp::int32 var_241;
        wp::shape_t var_242;
        bool var_243;
        wp::vec_t<2, wp::int32> var_244;
        wp::int32 var_245;
        const wp::int32 var_246 = 3;
        bool var_247;
        const wp::int32 var_248 = 3;
        bool var_249;
        const wp::int32 var_250 = 4;
        bool var_251;
        const wp::int32 var_252 = 4;
        bool var_253;
        const wp::int32 var_254 = 5;
        bool var_255;
        const wp::int32 var_256 = 6;
        bool var_257;
        const wp::int32 var_258 = 7;
        bool var_259;
        bool var_260;
        bool var_261;
        const wp::int32 var_262 = 2;
        wp::float32 var_263;
        const wp::float32 var_264 = 0.0;
        bool var_265;
        const wp::float32 var_266 = 0.0;
        const wp::float32 var_267 = 0.0;
        const wp::float32 var_268 = 1.0;
        wp::vec_t<3, wp::float32> var_269;
        wp::vec_t<3, wp::float32> var_270;
        const wp::float32 var_271 = 0.0;
        const wp::float32 var_272 = 0.0;
        const wp::float32 var_273 = 1.0;
        wp::vec_t<3, wp::float32> var_274;
        wp::vec_t<3, wp::float32> var_275;
        wp::float32 var_276;
        wp::float32 var_277;
        const wp::int32 var_278 = 2;
        wp::float32 var_279;
        wp::float32 var_280;
        const wp::int32 var_281 = 1;
        wp::float32 var_282;
        bool var_283;
        bool var_284;
        const wp::float32 var_285 = 0.0;
        wp::float32 var_286;
        const wp::float32 var_287 = 0.0;
        wp::float32 var_288;
        bool var_289;
        const wp::int32 var_290 = 0;
        wp::float32 var_291;
        wp::float32 var_292;
        bool var_293;
        const wp::int32 var_294 = 0;
        wp::float32 var_295;
        wp::float32 var_296;
        const wp::float32 var_297 = 10000000000.0;
        wp::float32 var_298;
        wp::float32 var_299;
        wp::float32 var_300;
        wp::float32 var_301;
        wp::vec_t<3, wp::float32> var_302;
        wp::vec_t<3, wp::float32> var_303;
        wp::vec_t<3, wp::float32> var_304;
        wp::vec_t<3, wp::float32> var_305;
        wp::vec_t<3, wp::float32> var_306;
        bool var_307;
        const wp::float32 var_308 = 0.0;
        const wp::float32 var_309 = 0.0;
        const wp::float32 var_310 = 1.0;
        wp::vec_t<3, wp::float32> var_311;
        wp::vec_t<3, wp::float32> var_312;
        const wp::int32 var_313 = 0;
        wp::float32 var_314;
        wp::float32 var_315;
        wp::vec_t<3, wp::float32> var_316;
        wp::vec_t<3, wp::float32> var_317;
        bool var_318;
        const wp::float32 var_319 = 0.0;
        const wp::float32 var_320 = 0.0;
        const wp::float32 var_321 = 1.0;
        wp::vec_t<3, wp::float32> var_322;
        wp::vec_t<3, wp::float32> var_323;
        wp::mat_t<3, 3, wp::float32> var_324;
        wp::vec_t<3, wp::float32> var_325;
        wp::float32 var_326;
        wp::vec_t<3, wp::float32> var_327;
        wp::vec_t<3, wp::float32> var_328;
        bool var_329;
        const wp::float32 var_330 = 0.0;
        const wp::float32 var_331 = 0.0;
        const wp::float32 var_332 = 1.0;
        wp::vec_t<3, wp::float32> var_333;
        wp::vec_t<3, wp::float32> var_334;
        wp::mat_t<3, 3, wp::float32> var_335;
        wp::vec_t<3, wp::float32> var_336;
        wp::vec_t<4, wp::float32> var_337;
        wp::mat_t<4, 3, wp::float32> var_338;
        wp::vec_t<3, wp::float32> var_339;
        const wp::int32 var_340 = 0;
        wp::float32 var_341;
        const wp::int32 var_342 = 1;
        wp::float32 var_343;
        const wp::int32 var_344 = 2;
        wp::float32 var_345;
        const wp::int32 var_346 = 3;
        wp::float32 var_347;
        const wp::int32 var_348 = 0;
        const wp::int32 var_349 = 0;
        wp::float32 var_350;
        const wp::int32 var_351 = 0;
        const wp::int32 var_352 = 1;
        wp::float32 var_353;
        const wp::int32 var_354 = 0;
        const wp::int32 var_355 = 2;
        wp::float32 var_356;
        wp::vec_t<3, wp::float32> var_357;
        const wp::int32 var_358 = 1;
        const wp::int32 var_359 = 0;
        wp::float32 var_360;
        const wp::int32 var_361 = 1;
        const wp::int32 var_362 = 1;
        wp::float32 var_363;
        const wp::int32 var_364 = 1;
        const wp::int32 var_365 = 2;
        wp::float32 var_366;
        wp::vec_t<3, wp::float32> var_367;
        const wp::int32 var_368 = 2;
        const wp::int32 var_369 = 0;
        wp::float32 var_370;
        const wp::int32 var_371 = 2;
        const wp::int32 var_372 = 1;
        wp::float32 var_373;
        const wp::int32 var_374 = 2;
        const wp::int32 var_375 = 2;
        wp::float32 var_376;
        wp::vec_t<3, wp::float32> var_377;
        const wp::int32 var_378 = 3;
        const wp::int32 var_379 = 0;
        wp::float32 var_380;
        const wp::int32 var_381 = 3;
        const wp::int32 var_382 = 1;
        wp::float32 var_383;
        const wp::int32 var_384 = 3;
        const wp::int32 var_385 = 2;
        wp::float32 var_386;
        wp::vec_t<3, wp::float32> var_387;
        bool var_388;
        const wp::int32 var_389 = 0;
        wp::float32 var_390;
        const wp::int32 var_391 = 0;
        wp::float32 var_392;
        wp::float32 var_393;
        wp::vec_t<3, wp::float32> var_394;
        wp::vec_t<3, wp::float32> var_395;
        bool var_396;
        const wp::float32 var_397 = 0.0;
        const wp::float32 var_398 = 0.0;
        const wp::float32 var_399 = 1.0;
        wp::vec_t<3, wp::float32> var_400;
        wp::vec_t<3, wp::float32> var_401;
        const wp::float32 var_402 = 0.0;
        const wp::float32 var_403 = 0.0;
        const wp::float32 var_404 = 1.0;
        wp::vec_t<3, wp::float32> var_405;
        wp::vec_t<3, wp::float32> var_406;
        const wp::int32 var_407 = 0;
        wp::float32 var_408;
        const wp::int32 var_409 = 1;
        wp::float32 var_410;
        wp::vec_t<2, wp::float32> var_411;
        wp::mat_t<2, 3, wp::float32> var_412;
        wp::mat_t<3, 3, wp::float32> var_413;
        const wp::int32 var_414 = 0;
        wp::float32 var_415;
        const wp::int32 var_416 = 1;
        wp::float32 var_417;
        const wp::int32 var_418 = 0;
        const wp::int32 var_419 = 0;
        wp::float32 var_420;
        const wp::int32 var_421 = 0;
        const wp::int32 var_422 = 1;
        wp::float32 var_423;
        const wp::int32 var_424 = 0;
        const wp::int32 var_425 = 2;
        wp::float32 var_426;
        wp::vec_t<3, wp::float32> var_427;
        const wp::int32 var_428 = 1;
        const wp::int32 var_429 = 0;
        wp::float32 var_430;
        const wp::int32 var_431 = 1;
        const wp::int32 var_432 = 1;
        wp::float32 var_433;
        const wp::int32 var_434 = 1;
        const wp::int32 var_435 = 2;
        wp::float32 var_436;
        wp::vec_t<3, wp::float32> var_437;
        wp::vec_t<3, wp::float32> var_438;
        const wp::float32 var_439 = 0.0;
        const wp::float32 var_440 = 0.0;
        const wp::float32 var_441 = 1.0;
        wp::vec_t<3, wp::float32> var_442;
        wp::vec_t<3, wp::float32> var_443;
        const wp::float32 var_444 = 0.0;
        const wp::float32 var_445 = 0.0;
        const wp::float32 var_446 = 1.0;
        wp::vec_t<3, wp::float32> var_447;
        wp::vec_t<3, wp::float32> var_448;
        const wp::int32 var_449 = 0;
        wp::float32 var_450;
        const wp::int32 var_451 = 1;
        wp::float32 var_452;
        wp::vec_t<4, wp::float32> var_453;
        wp::mat_t<4, 3, wp::float32> var_454;
        wp::vec_t<3, wp::float32> var_455;
        const wp::int32 var_456 = 0;
        wp::float32 var_457;
        const wp::int32 var_458 = 1;
        wp::float32 var_459;
        const wp::int32 var_460 = 2;
        wp::float32 var_461;
        const wp::int32 var_462 = 3;
        wp::float32 var_463;
        const wp::int32 var_464 = 0;
        const wp::int32 var_465 = 0;
        wp::float32 var_466;
        const wp::int32 var_467 = 0;
        const wp::int32 var_468 = 1;
        wp::float32 var_469;
        const wp::int32 var_470 = 0;
        const wp::int32 var_471 = 2;
        wp::float32 var_472;
        wp::vec_t<3, wp::float32> var_473;
        const wp::int32 var_474 = 1;
        const wp::int32 var_475 = 0;
        wp::float32 var_476;
        const wp::int32 var_477 = 1;
        const wp::int32 var_478 = 1;
        wp::float32 var_479;
        const wp::int32 var_480 = 1;
        const wp::int32 var_481 = 2;
        wp::float32 var_482;
        wp::vec_t<3, wp::float32> var_483;
        const wp::int32 var_484 = 2;
        const wp::int32 var_485 = 0;
        wp::float32 var_486;
        const wp::int32 var_487 = 2;
        const wp::int32 var_488 = 1;
        wp::float32 var_489;
        const wp::int32 var_490 = 2;
        const wp::int32 var_491 = 2;
        wp::float32 var_492;
        wp::vec_t<3, wp::float32> var_493;
        const wp::int32 var_494 = 3;
        const wp::int32 var_495 = 0;
        wp::float32 var_496;
        const wp::int32 var_497 = 3;
        const wp::int32 var_498 = 1;
        wp::float32 var_499;
        const wp::int32 var_500 = 3;
        const wp::int32 var_501 = 2;
        wp::float32 var_502;
        wp::vec_t<3, wp::float32> var_503;
        bool var_504;
        const wp::int32 var_505 = 0;
        wp::float32 var_506;
        const wp::float32 var_507 = 0.0;
        const wp::float32 var_508 = 0.0;
        const wp::float32 var_509 = 1.0;
        wp::vec_t<3, wp::float32> var_510;
        wp::vec_t<3, wp::float32> var_511;
        const wp::int32 var_512 = 0;
        wp::float32 var_513;
        const wp::int32 var_514 = 1;
        wp::float32 var_515;
        wp::float32 var_516;
        wp::vec_t<3, wp::float32> var_517;
        wp::vec_t<3, wp::float32> var_518;
        bool var_519;
        const wp::float32 var_520 = 0.0;
        const wp::float32 var_521 = 0.0;
        const wp::float32 var_522 = 1.0;
        wp::vec_t<3, wp::float32> var_523;
        wp::vec_t<3, wp::float32> var_524;
        const wp::float32 var_525 = 0.0;
        const wp::float32 var_526 = 0.0;
        const wp::float32 var_527 = 1.0;
        wp::vec_t<3, wp::float32> var_528;
        wp::vec_t<3, wp::float32> var_529;
        const wp::int32 var_530 = 0;
        wp::float32 var_531;
        const wp::int32 var_532 = 1;
        wp::float32 var_533;
        const wp::int32 var_534 = 0;
        wp::float32 var_535;
        const wp::int32 var_536 = 1;
        wp::float32 var_537;
        wp::vec_t<2, wp::float32> var_538;
        wp::mat_t<2, 3, wp::float32> var_539;
        wp::vec_t<3, wp::float32> var_540;
        const wp::int32 var_541 = 0;
        wp::float32 var_542;
        const wp::int32 var_543 = 0;
        const wp::int32 var_544 = 0;
        wp::float32 var_545;
        const wp::int32 var_546 = 0;
        const wp::int32 var_547 = 1;
        wp::float32 var_548;
        const wp::int32 var_549 = 0;
        const wp::int32 var_550 = 2;
        wp::float32 var_551;
        wp::vec_t<3, wp::float32> var_552;
        const wp::int32 var_553 = 1;
        wp::float32 var_554;
        const wp::int32 var_555 = 1;
        const wp::int32 var_556 = 0;
        wp::float32 var_557;
        const wp::int32 var_558 = 1;
        const wp::int32 var_559 = 1;
        wp::float32 var_560;
        const wp::int32 var_561 = 1;
        const wp::int32 var_562 = 2;
        wp::float32 var_563;
        wp::vec_t<3, wp::float32> var_564;
        bool var_565;
        const wp::int32 var_566 = 2;
        wp::float32 var_567;
        const wp::float32 var_568 = 0.0;
        bool var_569;
        const wp::int32 var_570 = 0;
        wp::float32 var_571;
        const wp::float32 var_572 = 0.0;
        const wp::float32 var_573 = 0.0;
        const wp::float32 var_574 = 1.0;
        wp::vec_t<3, wp::float32> var_575;
        wp::vec_t<3, wp::float32> var_576;
        const wp::int32 var_577 = 0;
        wp::float32 var_578;
        const wp::int32 var_579 = 1;
        wp::float32 var_580;
        wp::float32 var_581;
        wp::vec_t<3, wp::float32> var_582;
        wp::vec_t<3, wp::float32> var_583;
        bool var_584;
        const wp::int32 var_585 = 0;
        wp::float32 var_586;
        wp::mat_t<3, 3, wp::float32> var_587;
        wp::vec_t<3, wp::float32> var_588;
        wp::float32 var_589;
        wp::vec_t<3, wp::float32> var_590;
        wp::vec_t<3, wp::float32> var_591;
        wp::float32 var_592;
        wp::vec_t<3, wp::float32> var_593;
        wp::vec_t<3, wp::float32> var_594;
        wp::vec_t<3, wp::float32> var_595;
        wp::float32 var_596;
        wp::vec_t<3, wp::float32> var_597;
        wp::vec_t<3, wp::float32> var_598;
        wp::float32 var_599;
        wp::vec_t<3, wp::float32> var_600;
        wp::float32 var_601;
        wp::float32 var_602;
        wp::vec_t<3, wp::float32> var_603;
        wp::vec_t<3, wp::float32> var_604;
        wp::vec_t<3, wp::float32> var_605;
        wp::vec_t<3, wp::float32> var_606;
        wp::float32 var_607;
        wp::float32 var_608;
        wp::vec_t<3, wp::float32> var_609;
        wp::vec_t<3, wp::float32> var_610;
        wp::vec_t<3, wp::float32> var_611;
        wp::float32 var_612;
        wp::vec_t<3, wp::float32> var_613;
        wp::vec_t<3, wp::float32> var_614;
        wp::float32 var_615;
        wp::float32 var_616;
        wp::float32 var_617;
        wp::float32 var_618;
        wp::vec_t<3, wp::float32> var_619;
        wp::vec_t<3, wp::float32> var_620;
        wp::vec_t<3, wp::float32> var_621;
        wp::vec_t<3, wp::float32> var_622;
        wp::vec_t<3, wp::float32> var_623;
        wp::float32 var_624;
        wp::float32 var_625;
        wp::vec_t<3, wp::float32> var_626;
        wp::vec_t<3, wp::float32> var_627;
        wp::float32 var_628;
        wp::float32 var_629;
        wp::float32 var_630;
        wp::float32 var_631;
        wp::vec_t<3, wp::float32> var_632;
        wp::vec_t<3, wp::float32> var_633;
        wp::vec_t<3, wp::float32> var_634;
        wp::vec_t<3, wp::float32> var_635;
        wp::vec_t<3, wp::float32> var_636;
        wp::vec_t<3, wp::float32> var_637;
        wp::float32 var_638;
        wp::float32 var_639;
        wp::vec_t<2, wp::float32> var_640;
        wp::mat_t<2, 3, wp::float32> var_641;
        wp::vec_t<3, wp::float32> var_642;
        wp::vec_t<3, wp::float32> var_643;
        wp::float32 var_644;
        wp::float32 var_645;
        wp::float32 var_646;
        wp::float32 var_647;
        wp::vec_t<3, wp::float32> var_648;
        wp::vec_t<3, wp::float32> var_649;
        wp::vec_t<3, wp::float32> var_650;
        wp::vec_t<3, wp::float32> var_651;
        wp::vec_t<3, wp::float32> var_652;
        wp::float32 var_653;
        wp::float32 var_654;
        wp::vec_t<3, wp::float32> var_655;
        wp::vec_t<3, wp::float32> var_656;
        wp::float32 var_657;
        wp::float32 var_658;
        wp::float32 var_659;
        wp::float32 var_660;
        wp::vec_t<3, wp::float32> var_661;
        wp::vec_t<3, wp::float32> var_662;
        wp::vec_t<3, wp::float32> var_663;
        wp::vec_t<3, wp::float32> var_664;
        wp::vec_t<3, wp::float32> var_665;
        wp::mat_t<3, 3, wp::float32> var_666;
        wp::vec_t<3, wp::float32> var_667;
        wp::vec_t<3, wp::float32> var_668;
        wp::vec_t<3, wp::float32> var_669;
        wp::float32 var_670;
        wp::float32 var_671;
        wp::float32 var_672;
        wp::float32 var_673;
        wp::vec_t<3, wp::float32> var_674;
        wp::vec_t<3, wp::float32> var_675;
        wp::vec_t<3, wp::float32> var_676;
        wp::vec_t<3, wp::float32> var_677;
        wp::vec_t<3, wp::float32> var_678;
        wp::vec_t<3, wp::float32> var_679;
        wp::vec_t<3, wp::float32> var_680;
        wp::float32 var_681;
        wp::float32 var_682;
        wp::float32 var_683;
        wp::float32 var_684;
        wp::vec_t<3, wp::float32> var_685;
        wp::vec_t<3, wp::float32> var_686;
        wp::vec_t<3, wp::float32> var_687;
        wp::vec_t<3, wp::float32> var_688;
        wp::vec_t<3, wp::float32> var_689;
        wp::float32 var_690;
        bool var_691;
        wp::int32 var_692;
        bool var_693;
        wp::int32 var_694;
        wp::int32 var_695;
        bool var_696;
        wp::int32 var_697;
        wp::int32 var_698;
        bool var_699;
        wp::int32 var_700;
        wp::int32 var_701;
        const wp::int32 var_702 = 0;
        bool var_703;
        ContactData_40360d7c var_704;
        const bool var_705 = false;
        const bool var_706 = false;
        bool var_707;
        bool var_708;
        bool var_709;
        const bool var_710 = false;
        bool var_711;
        bool var_712;
        bool var_713;
        const bool var_714 = false;
        bool var_715;
        bool var_716;
        bool var_717;
        const bool var_718 = false;
        bool var_719;
        bool var_720;
        bool var_721;
        wp::int32 var_722;
        wp::int32 var_723;
        wp::int32 var_724;
        wp::int32 var_725;
        wp::int32 var_726;
        wp::int32 var_727;
        wp::int32 var_728;
        const wp::int32 var_729 = 0;
        bool var_730;
        wp::array_t<wp::int32>* var_731;
        const wp::int32 var_732 = 0;
        wp::int32 var_733;
        wp::array_t<wp::int32> var_734;
        wp::int32 var_735;
        wp::int32* var_736;
        bool var_737;
        wp::int32 var_738;
        const wp::int32 var_739 = 0;
        const wp::int32 var_740 = 1;
        wp::int32 var_741;
        wp::int32 var_742;
        const wp::int32 var_743 = 1;
        const wp::int32 var_744 = 1;
        wp::int32 var_745;
        wp::int32 var_746;
        const wp::int32 var_747 = 2;
        const wp::int32 var_748 = 1;
        wp::int32 var_749;
        wp::int32 var_750;
        const wp::int32 var_751 = 3;
        const wp::int32 var_752 = 0;
        const wp::int32 var_753 = 1;
        wp::int32 var_754;
        wp::shape_t* var_755;
        const wp::int32 var_756 = 0;
        wp::int32 var_757;
        wp::shape_t var_758;
        bool var_759;
        wp::vec_t<2, wp::int32> var_760;
        //---------
        // forward
        // def narrow_phase_primitive_kernel(                                                     <L 1>
        // tid = wp.tid()                                                                         <L 43>
        var_0 = builtin_tid1d();
        // num_work_items = wp.min(candidate_pair.shape[0], candidate_pair_count[0])              <L 45>
        var_1 = &(var_candidate_pair.shape);
        var_4 = wp::load(var_1);
        var_3 = wp::extract(var_4, var_2);
        var_6 = wp::address(var_candidate_pair_count, var_5);
        var_8 = wp::load(var_6);
        var_7 = wp::min(var_3, var_8);
        // if num_work_items == 0:                                                                <L 48>
        var_10 = (var_7 == var_9);
        if (var_10) {
            // return                                                                             <L 49>
            continue;
        }
        // for t in range(tid, num_work_items, total_num_threads):                                <L 51>
        var_11 = wp::range(var_0, var_7, var_total_num_threads);
        start_for_1:;
            if (iter_cmp(var_11) == 0) goto end_for_1;
            var_12 = wp::iter_next(var_11);
            // pair = candidate_pair[t]                                                           <L 53>
            var_13 = wp::address(var_candidate_pair, var_12);
            var_15 = wp::load(var_13);
            var_14 = wp::copy(var_15);
            // shape_a = pair[0]                                                                  <L 54>
            var_17 = wp::extract(var_14, var_16);
            // shape_b = pair[1]                                                                  <L 55>
            var_19 = wp::extract(var_14, var_18);
            // if shape_a == shape_b or shape_a < 0 or shape_b < 0:                               <L 58>
            var_21 = (var_17 == var_19);
            var_20 = var_21;
            if (!var_20) {
                var_23 = (var_17 < var_22);
                var_20 = var_20 || var_23;
            }
            if (!var_20) {
                var_25 = (var_19 < var_24);
                var_20 = var_20 || var_25;
            }
            if (var_20) {
                // continue                                                                       <L 59>
                goto start_for_1;
            }
            // type_a = shape_types[shape_a]                                                      <L 62>
            var_26 = wp::address(var_shape_types, var_17);
            var_28 = wp::load(var_26);
            var_27 = wp::copy(var_28);
            // type_b = shape_types[shape_b]                                                      <L 63>
            var_29 = wp::address(var_shape_types, var_19);
            var_31 = wp::load(var_29);
            var_30 = wp::copy(var_31);
            // if type_a > type_b:                                                                <L 66>
            var_32 = (var_27 > var_30);
            if (var_32) {
                // shape_a, shape_b = shape_b, shape_a                                            <L 67>
                // type_a, type_b = type_b, type_a                                                <L 68>
            }
            var_33 = wp::where(var_32, var_19, var_17);
            var_34 = wp::where(var_32, var_17, var_19);
            var_35 = wp::where(var_32, var_30, var_27);
            var_36 = wp::where(var_32, var_27, var_30);
            // is_hydro_a = (shape_flags[shape_a] & ShapeFlags.HYDROELASTIC) != 0                 <L 71>
            var_37 = wp::address(var_shape_flags, var_33);
            var_40 = wp::load(var_37);
            var_39 = wp::bit_and(var_40, var_38);
            var_42 = (var_39 != var_41);
            // is_hydro_b = (shape_flags[shape_b] & ShapeFlags.HYDROELASTIC) != 0                 <L 72>
            var_43 = wp::address(var_shape_flags, var_34);
            var_46 = wp::load(var_43);
            var_45 = wp::bit_and(var_46, var_44);
            var_48 = (var_45 != var_47);
            // if is_hydro_a and is_hydro_b and shape_pairs_sdf_sdf:                              <L 73>
            var_49 = var_42;
            if (var_49) {
                var_49 = var_49 && var_48;
            }
            if (var_49) {
                var_49 = var_49 && var_shape_pairs_sdf_sdf;
            }
            if (var_49) {
                // idx = wp.atomic_add(shape_pairs_sdf_sdf_count, 0, 1)                           <L 74>
                var_52 = wp::atomic_add(var_shape_pairs_sdf_sdf_count, var_50, var_51);
                // if idx < shape_pairs_sdf_sdf.shape[0]:                                         <L 75>
                var_53 = &(var_shape_pairs_sdf_sdf.shape);
                var_56 = wp::load(var_53);
                var_55 = wp::extract(var_56, var_54);
                var_57 = (var_52 < var_55);
                if (var_57) {
                    // shape_pairs_sdf_sdf[idx] = wp.vec2i(shape_a, shape_b)                      <L 76>
                    var_58 = wp::vec_t<2, wp::int32>(var_33, var_34);
                    wp::array_store(var_shape_pairs_sdf_sdf, var_52, var_58);
                }
                // continue                                                                       <L 77>
                goto start_for_1;
            }
            // data_a = shape_data[shape_a]                                                       <L 80>
            var_59 = wp::address(var_shape_data, var_33);
            var_61 = wp::load(var_59);
            var_60 = wp::copy(var_61);
            // data_b = shape_data[shape_b]                                                       <L 81>
            var_62 = wp::address(var_shape_data, var_34);
            var_64 = wp::load(var_62);
            var_63 = wp::copy(var_64);
            // scale_a = wp.vec3(data_a[0], data_a[1], data_a[2])                                 <L 82>
            var_66 = wp::extract(var_60, var_65);
            var_68 = wp::extract(var_60, var_67);
            var_70 = wp::extract(var_60, var_69);
            var_71 = wp::vec_t<3, wp::float32>(var_66, var_68, var_70);
            // scale_b = wp.vec3(data_b[0], data_b[1], data_b[2])                                 <L 83>
            var_73 = wp::extract(var_63, var_72);
            var_75 = wp::extract(var_63, var_74);
            var_77 = wp::extract(var_63, var_76);
            var_78 = wp::vec_t<3, wp::float32>(var_73, var_75, var_77);
            // margin_offset_a = data_a[3]                                                        <L 84>
            var_80 = wp::extract(var_60, var_79);
            // margin_offset_b = data_b[3]                                                        <L 85>
            var_82 = wp::extract(var_63, var_81);
            // X_a = shape_transform[shape_a]                                                     <L 88>
            var_83 = wp::address(var_shape_transform, var_33);
            var_85 = wp::load(var_83);
            var_84 = wp::copy(var_85);
            // X_b = shape_transform[shape_b]                                                     <L 89>
            var_86 = wp::address(var_shape_transform, var_34);
            var_88 = wp::load(var_86);
            var_87 = wp::copy(var_88);
            // pos_a = wp.transform_get_translation(X_a)                                          <L 90>
            var_89 = wp::transform_get_translation(var_84);
            // pos_b = wp.transform_get_translation(X_b)                                          <L 91>
            var_90 = wp::transform_get_translation(var_87);
            // quat_a = wp.transform_get_rotation(X_a)                                            <L 92>
            var_91 = wp::transform_get_rotation(var_84);
            // quat_b = wp.transform_get_rotation(X_b)                                            <L 93>
            var_92 = wp::transform_get_rotation(var_87);
            // gap_a = shape_gap[shape_a]                                                         <L 94>
            var_93 = wp::address(var_shape_gap, var_33);
            var_95 = wp::load(var_93);
            var_94 = wp::copy(var_95);
            // gap_b = shape_gap[shape_b]                                                         <L 95>
            var_96 = wp::address(var_shape_gap, var_34);
            var_98 = wp::load(var_96);
            var_97 = wp::copy(var_98);
            // gap_sum = gap_a + gap_b                                                            <L 96>
            var_99 = wp::add(var_94, var_97);
            // is_hfield_a = type_a == GeoType.HFIELD                                             <L 105>
            var_101 = (var_35 == var_100);
            // is_hfield_b = type_b == GeoType.HFIELD                                             <L 106>
            var_103 = (var_36 == var_102);
            // if is_hfield_a or is_hfield_b:                                                     <L 108>
            var_104 = var_101;
            if (!var_104) {
                var_104 = var_104 || var_103;
            }
            if (var_104) {
                // is_mesh_like_a = type_a == GeoType.MESH or is_hfield_a                         <L 109>
                var_107 = (var_35 == var_106);
                var_105 = var_107;
                if (!var_105) {
                    var_105 = var_105 || var_101;
                }
                // is_mesh_like_b = type_b == GeoType.MESH or is_hfield_b                         <L 110>
                var_110 = (var_36 == var_109);
                var_108 = var_110;
                if (!var_108) {
                    var_108 = var_108 || var_103;
                }
                // if is_mesh_like_a and is_mesh_like_b:                                          <L 112>
                var_111 = var_105;
                if (var_111) {
                    var_111 = var_111 && var_108;
                }
                if (var_111) {
                    // if is_hfield_a and is_hfield_b:                                            <L 114>
                    var_112 = var_101;
                    if (var_112) {
                        var_112 = var_112 && var_103;
                    }
                    if (var_112) {
                        // continue                                                               <L 115>
                        goto start_for_1;
                    }
                    // if is_hfield_b:                                                            <L 118>
                    if (var_103) {
                        // encoded_a = shape_b | SHAPE_PAIR_HFIELD_BIT                            <L 119>
                        var_114 = wp::bit_or(var_34, var_113);
                        // encoded_b = shape_a                                                    <L 120>
                        var_115 = wp::copy(var_33);
                    }
                    if (!var_103) {
                        // elif is_hfield_a:                                                      <L 121>
                        if (var_101) {
                            // encoded_a = shape_a | SHAPE_PAIR_HFIELD_BIT                        <L 122>
                            var_117 = wp::bit_or(var_33, var_116);
                            // encoded_b = shape_b                                                <L 123>
                            var_118 = wp::copy(var_34);
                        }
                        if (!var_101) {
                            // encoded_a = shape_a                                                <L 125>
                            var_119 = wp::copy(var_33);
                            // encoded_b = shape_b                                                <L 126>
                            var_120 = wp::copy(var_34);
                        }
                        var_121 = wp::where(var_101, var_117, var_119);
                        var_122 = wp::where(var_101, var_118, var_120);
                    }
                    var_123 = wp::where(var_103, var_113, var_116);
                    var_124 = wp::where(var_103, var_114, var_121);
                    var_125 = wp::where(var_103, var_115, var_122);
                    // idx = wp.atomic_add(shape_pairs_mesh_mesh_count, 0, 1)                     <L 127>
                    var_128 = wp::atomic_add(var_shape_pairs_mesh_mesh_count, var_126, var_127);
                    // if idx < shape_pairs_mesh_mesh.shape[0]:                                   <L 128>
                    var_129 = &(var_shape_pairs_mesh_mesh.shape);
                    var_132 = wp::load(var_129);
                    var_131 = wp::extract(var_132, var_130);
                    var_133 = (var_128 < var_131);
                    if (var_133) {
                        // shape_pairs_mesh_mesh[idx] = wp.vec2i(encoded_a, encoded_b)            <L 129>
                        var_134 = wp::vec_t<2, wp::int32>(var_124, var_125);
                        wp::array_store(var_shape_pairs_mesh_mesh, var_128, var_134);
                    }
                    // continue                                                                   <L 130>
                    goto start_for_1;
                }
                var_135 = wp::where(var_111, var_128, var_52);
                // if is_hfield_a:                                                                <L 134>
                if (var_101) {
                    // hf_pair = wp.vec2i(shape_a, shape_b)                                       <L 135>
                    var_136 = wp::vec_t<2, wp::int32>(var_33, var_34);
                }
                if (!var_101) {
                    // hf_pair = wp.vec2i(shape_b, shape_a)                                       <L 137>
                    var_137 = wp::vec_t<2, wp::int32>(var_34, var_33);
                }
                var_138 = wp::where(var_101, var_136, var_137);
                // idx = wp.atomic_add(shape_pairs_mesh_count, 0, 1)                              <L 138>
                var_141 = wp::atomic_add(var_shape_pairs_mesh_count, var_139, var_140);
                // if idx < shape_pairs_mesh.shape[0]:                                            <L 139>
                var_142 = &(var_shape_pairs_mesh.shape);
                var_145 = wp::load(var_142);
                var_144 = wp::extract(var_145, var_143);
                var_146 = (var_141 < var_144);
                if (var_146) {
                    // shape_pairs_mesh[idx] = hf_pair                                            <L 140>
                    wp::array_store(var_shape_pairs_mesh, var_141, var_138);
                }
                // continue                                                                       <L 141>
                goto start_for_1;
            }
            var_147 = wp::where(var_104, var_141, var_52);
            // is_mesh_a = type_a == GeoType.MESH                                                 <L 146>
            var_149 = (var_35 == var_148);
            // is_mesh_b = type_b == GeoType.MESH                                                 <L 147>
            var_151 = (var_36 == var_150);
            // is_box_a = type_a == GeoType.BOX                                                   <L 148>
            var_153 = (var_35 == var_152);
            // is_box_b = type_b == GeoType.BOX                                                   <L 149>
            var_155 = (var_36 == var_154);
            // is_plane_a = type_a == GeoType.PLANE                                               <L 150>
            var_157 = (var_35 == var_156);
            // is_infinite_plane_a = is_plane_a and (scale_a[0] == 0.0 and scale_a[1] == 0.0)       <L 151>
            var_158 = var_157;
            if (var_158) {
                var_161 = wp::extract(var_71, var_160);
                var_163 = (var_161 == var_162);
                var_159 = var_163;
                if (var_159) {
                    var_165 = wp::extract(var_71, var_164);
                    var_167 = (var_165 == var_166);
                    var_159 = var_159 && var_167;
                }
                var_158 = var_158 && var_159;
            }
            // has_sdf_edges_a = shape_sdf_index[shape_a] >= 0 and shape_edge_range[shape_a][1] > 0       <L 152>
            var_169 = wp::address(var_shape_sdf_index, var_33);
            var_172 = wp::load(var_169);
            var_171 = (var_172 >= var_170);
            var_168 = var_171;
            if (var_168) {
                var_173 = wp::address(var_shape_edge_range, var_33);
                var_176 = wp::load(var_173);
                var_175 = wp::extract(var_176, var_174);
                var_178 = (var_175 > var_177);
                var_168 = var_168 && var_178;
            }
            // has_sdf_edges_b = shape_sdf_index[shape_b] >= 0 and shape_edge_range[shape_b][1] > 0       <L 153>
            var_180 = wp::address(var_shape_sdf_index, var_34);
            var_183 = wp::load(var_180);
            var_182 = (var_183 >= var_181);
            var_179 = var_182;
            if (var_179) {
                var_184 = wp::address(var_shape_edge_range, var_34);
                var_187 = wp::load(var_184);
                var_186 = wp::extract(var_187, var_185);
                var_189 = (var_186 > var_188);
                var_179 = var_179 && var_189;
            }
            // if (is_mesh_a and is_mesh_b) or (                                                  <L 160>
            var_191 = var_149;
            if (var_191) {
                var_191 = var_191 && var_151;
            }
            var_190 = var_191;
            if (!var_190) {
                // shape_pairs_mesh_mesh.shape[0] > 0                                             <L 161>
                var_193 = &(var_shape_pairs_mesh_mesh.shape);
                var_196 = wp::load(var_193);
                var_195 = wp::extract(var_196, var_194);
                var_198 = (var_195 > var_197);
                var_192 = var_198;
                if (var_192) {
                    // and has_sdf_edges_a                                                        <L 162>
                    var_192 = var_192 && var_168;
                }
                if (var_192) {
                    // and has_sdf_edges_b                                                        <L 163>
                    var_192 = var_192 && var_179;
                }
                if (var_192) {
                    // and not (is_box_a and is_box_b)                                            <L 164>
                    var_199 = var_153;
                    if (var_199) {
                        var_199 = var_199 && var_155;
                    }
                    var_200 = wp::unot(var_199);
                    var_192 = var_192 && var_200;
                }
                var_190 = var_190 || var_192;
            }
            if (var_190) {
                // idx = wp.atomic_add(shape_pairs_mesh_mesh_count, 0, 1)                         <L 166>
                var_203 = wp::atomic_add(var_shape_pairs_mesh_mesh_count, var_201, var_202);
                // if idx < shape_pairs_mesh_mesh.shape[0]:                                       <L 167>
                var_204 = &(var_shape_pairs_mesh_mesh.shape);
                var_207 = wp::load(var_204);
                var_206 = wp::extract(var_207, var_205);
                var_208 = (var_203 < var_206);
                if (var_208) {
                    // shape_pairs_mesh_mesh[idx] = wp.vec2i(shape_a, shape_b)                    <L 168>
                    var_209 = wp::vec_t<2, wp::int32>(var_33, var_34);
                    wp::array_store(var_shape_pairs_mesh_mesh, var_203, var_209);
                }
                // continue                                                                       <L 169>
                goto start_for_1;
            }
            var_210 = wp::where(var_190, var_203, var_147);
            // if is_infinite_plane_a and is_mesh_b:                                              <L 172>
            var_211 = var_158;
            if (var_211) {
                var_211 = var_211 && var_151;
            }
            if (var_211) {
                // mesh_id = shape_source[shape_b]                                                <L 173>
                var_212 = wp::address(var_shape_source, var_34);
                var_214 = wp::load(var_212);
                var_213 = wp::copy(var_214);
                // if mesh_id != wp.uint64(0):                                                    <L 174>
                var_215 = 0ull;
                var_216 = (var_213 != var_215);
                if (var_216) {
                    // mesh_obj = wp.mesh_get(mesh_id)                                            <L 175>
                    var_217 = wp::mesh_get(var_213);
                    // vertex_count = mesh_obj.points.shape[0]                                    <L 176>
                    var_218 = &((var_217).points);
                    var_219 = &(var_218->shape);
                    var_222 = wp::load(var_219);
                    var_221 = wp::extract(var_222, var_220);
                    // mesh_plane_idx = wp.atomic_add(shape_pairs_mesh_plane_count, 0, 1)         <L 177>
                    var_225 = wp::atomic_add(var_shape_pairs_mesh_plane_count, var_223, var_224);
                    // if mesh_plane_idx < shape_pairs_mesh_plane.shape[0]:                       <L 178>
                    var_226 = &(var_shape_pairs_mesh_plane.shape);
                    var_229 = wp::load(var_226);
                    var_228 = wp::extract(var_229, var_227);
                    var_230 = (var_225 < var_228);
                    if (var_230) {
                        // shape_pairs_mesh_plane[mesh_plane_idx] = wp.vec2i(shape_b, shape_a)       <L 180>
                        var_231 = wp::vec_t<2, wp::int32>(var_34, var_33);
                        wp::array_store(var_shape_pairs_mesh_plane, var_225, var_231);
                        // cumulative_count_before = wp.atomic_add(mesh_plane_vertex_total_count, 0, vertex_count)       <L 181>
                        var_233 = wp::atomic_add(var_mesh_plane_vertex_total_count, var_232, var_221);
                        // shape_pairs_mesh_plane_cumsum[mesh_plane_idx] = cumulative_count_before + vertex_count       <L 182>
                        var_234 = wp::add(var_233, var_221);
                        wp::array_store(var_shape_pairs_mesh_plane_cumsum, var_225, var_234);
                    }
                }
                // continue                                                                       <L 183>
                goto start_for_1;
            }
            // if is_mesh_a or is_mesh_b:                                                         <L 186>
            var_235 = var_149;
            if (!var_235) {
                var_235 = var_235 || var_151;
            }
            if (var_235) {
                // idx = wp.atomic_add(shape_pairs_mesh_count, 0, 1)                              <L 187>
                var_238 = wp::atomic_add(var_shape_pairs_mesh_count, var_236, var_237);
                // if idx < shape_pairs_mesh.shape[0]:                                            <L 188>
                var_239 = &(var_shape_pairs_mesh.shape);
                var_242 = wp::load(var_239);
                var_241 = wp::extract(var_242, var_240);
                var_243 = (var_238 < var_241);
                if (var_243) {
                    // shape_pairs_mesh[idx] = wp.vec2i(shape_a, shape_b)                         <L 189>
                    var_244 = wp::vec_t<2, wp::int32>(var_33, var_34);
                    wp::array_store(var_shape_pairs_mesh, var_238, var_244);
                }
                // continue                                                                       <L 190>
                goto start_for_1;
            }
            var_245 = wp::where(var_235, var_238, var_210);
            // is_sphere_a = type_a == GeoType.SPHERE                                             <L 195>
            var_247 = (var_35 == var_246);
            // is_sphere_b = type_b == GeoType.SPHERE                                             <L 196>
            var_249 = (var_36 == var_248);
            // is_capsule_a = type_a == GeoType.CAPSULE                                           <L 197>
            var_251 = (var_35 == var_250);
            // is_capsule_b = type_b == GeoType.CAPSULE                                           <L 198>
            var_253 = (var_36 == var_252);
            // is_ellipsoid_b = type_b == GeoType.ELLIPSOID                                       <L 199>
            var_255 = (var_36 == var_254);
            // is_cylinder_b = type_b == GeoType.CYLINDER                                         <L 200>
            var_257 = (var_36 == var_256);
            // is_box_b = type_b == GeoType.BOX                                                   <L 201>
            var_259 = (var_36 == var_258);
            // use_plane_cylinder = is_plane_a and is_cylinder_b                                  <L 203>
            var_260 = var_157;
            if (var_260) {
                var_260 = var_260 && var_257;
            }
            // if use_plane_cylinder and scale_b[2] > 0.0:                                        <L 204>
            var_261 = var_260;
            if (var_261) {
                var_263 = wp::extract(var_78, var_262);
                var_265 = (var_263 > var_264);
                var_261 = var_261 && var_265;
            }
            if (var_261) {
                // plane_normal = wp.quat_rotate(quat_a, wp.vec3(0.0, 0.0, 1.0))                  <L 205>
                var_269 = wp::vec_t<3, wp::float32>(var_266, var_267, var_268);
                var_270 = wp::quat_rotate(var_91, var_269);
                // cylinder_axis = wp.quat_rotate(quat_b, wp.vec3(0.0, 0.0, 1.0))                 <L 206>
                var_274 = wp::vec_t<3, wp::float32>(var_271, var_272, var_273);
                var_275 = wp::quat_rotate(var_92, var_274);
                // use_plane_cylinder = wp.abs(wp.dot(plane_normal, cylinder_axis)) * scale_b[2] >= scale_b[1]       <L 207>
                var_276 = wp::dot(var_270, var_275);
                var_277 = wp::abs(var_276);
                var_279 = wp::extract(var_78, var_278);
                var_280 = wp::mul(var_277, var_279);
                var_282 = wp::extract(var_78, var_281);
                var_283 = (var_280 >= var_282);
            }
            var_284 = wp::where(var_261, var_283, var_260);
            // radius_eff_a = float(0.0)                                                          <L 211>
            var_286 = wp::float(var_285);
            // radius_eff_b = float(0.0)                                                          <L 212>
            var_288 = wp::float(var_287);
            // if is_sphere_a or is_capsule_a:                                                    <L 213>
            var_289 = var_247;
            if (!var_289) {
                var_289 = var_289 || var_251;
            }
            if (var_289) {
                // radius_eff_a = scale_a[0]                                                      <L 214>
                var_291 = wp::extract(var_71, var_290);
            }
            var_292 = wp::where(var_289, var_291, var_286);
            // if is_sphere_b or is_capsule_b:                                                    <L 215>
            var_293 = var_249;
            if (!var_293) {
                var_293 = var_293 || var_253;
            }
            if (var_293) {
                // radius_eff_b = scale_b[0]                                                      <L 216>
                var_295 = wp::extract(var_78, var_294);
            }
            var_296 = wp::where(var_293, var_295, var_288);
            // contact_dist_0 = float(MAXVAL)                                                     <L 221>
            var_298 = wp::float(var_297);
            // contact_dist_1 = float(MAXVAL)                                                     <L 222>
            var_299 = wp::float(var_297);
            // contact_dist_2 = float(MAXVAL)                                                     <L 223>
            var_300 = wp::float(var_297);
            // contact_dist_3 = float(MAXVAL)                                                     <L 224>
            var_301 = wp::float(var_297);
            // contact_pos_0 = wp.vec3()                                                          <L 225>
            var_302 = wp::vec_t<3, wp::float32>();
            // contact_pos_1 = wp.vec3()                                                          <L 226>
            var_303 = wp::vec_t<3, wp::float32>();
            // contact_pos_2 = wp.vec3()                                                          <L 227>
            var_304 = wp::vec_t<3, wp::float32>();
            // contact_pos_3 = wp.vec3()                                                          <L 228>
            var_305 = wp::vec_t<3, wp::float32>();
            // contact_normal = wp.vec3()                                                         <L 229>
            var_306 = wp::vec_t<3, wp::float32>();
            // if is_plane_a and is_sphere_b:                                                     <L 234>
            var_307 = var_157;
            if (var_307) {
                var_307 = var_307 && var_249;
            }
            if (var_307) {
                // plane_normal = wp.quat_rotate(quat_a, wp.vec3(0.0, 0.0, 1.0))                  <L 235>
                var_311 = wp::vec_t<3, wp::float32>(var_308, var_309, var_310);
                var_312 = wp::quat_rotate(var_91, var_311);
                // sphere_radius = scale_b[0]                                                     <L 236>
                var_314 = wp::extract(var_78, var_313);
                // contact_dist_0, contact_pos_0 = collide_plane_sphere(plane_normal, pos_a, pos_b, sphere_radius)       <L 237>
                collide_plane_sphere_0(var_312, var_89, var_90, var_314, var_315, var_316);
                // contact_normal = plane_normal                                                  <L 238>
                var_317 = wp::copy(var_312);
            }
            if (!var_307) {
                // elif is_plane_a and is_ellipsoid_b:                                            <L 244>
                var_318 = var_157;
                if (var_318) {
                    var_318 = var_318 && var_255;
                }
                if (var_318) {
                    // plane_normal = wp.quat_rotate(quat_a, wp.vec3(0.0, 0.0, 1.0))              <L 245>
                    var_322 = wp::vec_t<3, wp::float32>(var_319, var_320, var_321);
                    var_323 = wp::quat_rotate(var_91, var_322);
                    // ellipsoid_rot = wp.quat_to_matrix(quat_b)                                  <L 246>
                    var_324 = wp::quat_to_matrix(var_92);
                    // ellipsoid_size = scale_b                                                   <L 247>
                    var_325 = wp::copy(var_78);
                    // contact_dist_0, contact_pos_0, contact_normal = collide_plane_ellipsoid(       <L 248>
                    // plane_normal, pos_a, pos_b, ellipsoid_rot, ellipsoid_size                  <L 249>
                    collide_plane_ellipsoid_0(var_323, var_89, var_90, var_324, var_325, var_326, var_327, var_328);
                }
                if (!var_318) {
                    // elif is_plane_a and is_box_b:                                              <L 256>
                    var_329 = var_157;
                    if (var_329) {
                        var_329 = var_329 && var_259;
                    }
                    if (var_329) {
                        // plane_normal = wp.quat_rotate(quat_a, wp.vec3(0.0, 0.0, 1.0))          <L 257>
                        var_333 = wp::vec_t<3, wp::float32>(var_330, var_331, var_332);
                        var_334 = wp::quat_rotate(var_91, var_333);
                        // box_rot = wp.quat_to_matrix(quat_b)                                    <L 258>
                        var_335 = wp::quat_to_matrix(var_92);
                        // box_size = scale_b                                                     <L 259>
                        var_336 = wp::copy(var_78);
                        // dists4_box, positions4_box, contact_normal = collide_plane_box(        <L 261>
                        // plane_normal, pos_a, pos_b, box_rot, box_size, gap_sum                 <L 262>
                        collide_plane_box_0(var_334, var_89, var_90, var_335, var_336, var_99, var_337, var_338, var_339);
                        // contact_dist_0 = dists4_box[0]                                         <L 265>
                        var_341 = wp::extract(var_337, var_340);
                        // contact_dist_1 = dists4_box[1]                                         <L 266>
                        var_343 = wp::extract(var_337, var_342);
                        // contact_dist_2 = dists4_box[2]                                         <L 267>
                        var_345 = wp::extract(var_337, var_344);
                        // contact_dist_3 = dists4_box[3]                                         <L 268>
                        var_347 = wp::extract(var_337, var_346);
                        // contact_pos_0 = wp.vec3(positions4_box[0, 0], positions4_box[0, 1], positions4_box[0, 2])       <L 269>
                        var_350 = wp::extract(var_338, var_348, var_349);
                        var_353 = wp::extract(var_338, var_351, var_352);
                        var_356 = wp::extract(var_338, var_354, var_355);
                        var_357 = wp::vec_t<3, wp::float32>(var_350, var_353, var_356);
                        // contact_pos_1 = wp.vec3(positions4_box[1, 0], positions4_box[1, 1], positions4_box[1, 2])       <L 270>
                        var_360 = wp::extract(var_338, var_358, var_359);
                        var_363 = wp::extract(var_338, var_361, var_362);
                        var_366 = wp::extract(var_338, var_364, var_365);
                        var_367 = wp::vec_t<3, wp::float32>(var_360, var_363, var_366);
                        // contact_pos_2 = wp.vec3(positions4_box[2, 0], positions4_box[2, 1], positions4_box[2, 2])       <L 271>
                        var_370 = wp::extract(var_338, var_368, var_369);
                        var_373 = wp::extract(var_338, var_371, var_372);
                        var_376 = wp::extract(var_338, var_374, var_375);
                        var_377 = wp::vec_t<3, wp::float32>(var_370, var_373, var_376);
                        // contact_pos_3 = wp.vec3(positions4_box[3, 0], positions4_box[3, 1], positions4_box[3, 2])       <L 272>
                        var_380 = wp::extract(var_338, var_378, var_379);
                        var_383 = wp::extract(var_338, var_381, var_382);
                        var_386 = wp::extract(var_338, var_384, var_385);
                        var_387 = wp::vec_t<3, wp::float32>(var_380, var_383, var_386);
                    }
                    if (!var_329) {
                        // elif is_sphere_a and is_sphere_b:                                      <L 277>
                        var_388 = var_247;
                        if (var_388) {
                            var_388 = var_388 && var_249;
                        }
                        if (var_388) {
                            // radius_a = scale_a[0]                                              <L 278>
                            var_390 = wp::extract(var_71, var_389);
                            // radius_b = scale_b[0]                                              <L 279>
                            var_392 = wp::extract(var_78, var_391);
                            // contact_dist_0, contact_pos_0, contact_normal = collide_sphere_sphere(pos_a, radius_a, pos_b, radius_b)       <L 280>
                            collide_sphere_sphere_0(var_89, var_390, var_90, var_392, var_393, var_394, var_395);
                        }
                        if (!var_388) {
                            // elif is_plane_a and is_capsule_b:                                  <L 286>
                            var_396 = var_157;
                            if (var_396) {
                                var_396 = var_396 && var_253;
                            }
                            if (var_396) {
                                // plane_normal = wp.quat_rotate(quat_a, wp.vec3(0.0, 0.0, 1.0))       <L 287>
                                var_400 = wp::vec_t<3, wp::float32>(var_397, var_398, var_399);
                                var_401 = wp::quat_rotate(var_91, var_400);
                                // capsule_axis = wp.quat_rotate(quat_b, wp.vec3(0.0, 0.0, 1.0))       <L 288>
                                var_405 = wp::vec_t<3, wp::float32>(var_402, var_403, var_404);
                                var_406 = wp::quat_rotate(var_92, var_405);
                                // capsule_radius = scale_b[0]                                    <L 289>
                                var_408 = wp::extract(var_78, var_407);
                                // capsule_half_length = scale_b[1]                               <L 290>
                                var_410 = wp::extract(var_78, var_409);
                                // dists, positions, _frame = collide_plane_capsule(              <L 292>
                                // plane_normal, pos_a, pos_b, capsule_axis, capsule_radius, capsule_half_length       <L 293>
                                collide_plane_capsule_0(var_401, var_89, var_90, var_406, var_408, var_410, var_411, var_412, var_413);
                                // contact_dist_0 = dists[0]                                      <L 296>
                                var_415 = wp::extract(var_411, var_414);
                                // contact_dist_1 = dists[1]                                      <L 297>
                                var_417 = wp::extract(var_411, var_416);
                                // contact_pos_0 = wp.vec3(positions[0, 0], positions[0, 1], positions[0, 2])       <L 298>
                                var_420 = wp::extract(var_412, var_418, var_419);
                                var_423 = wp::extract(var_412, var_421, var_422);
                                var_426 = wp::extract(var_412, var_424, var_425);
                                var_427 = wp::vec_t<3, wp::float32>(var_420, var_423, var_426);
                                // contact_pos_1 = wp.vec3(positions[1, 0], positions[1, 1], positions[1, 2])       <L 299>
                                var_430 = wp::extract(var_412, var_428, var_429);
                                var_433 = wp::extract(var_412, var_431, var_432);
                                var_436 = wp::extract(var_412, var_434, var_435);
                                var_437 = wp::vec_t<3, wp::float32>(var_430, var_433, var_436);
                                // contact_normal = plane_normal                                  <L 300>
                                var_438 = wp::copy(var_401);
                            }
                            if (!var_396) {
                                // elif use_plane_cylinder:                                       <L 306>
                                if (var_284) {
                                    // plane_normal = wp.quat_rotate(quat_a, wp.vec3(0.0, 0.0, 1.0))       <L 307>
                                    var_442 = wp::vec_t<3, wp::float32>(var_439, var_440, var_441);
                                    var_443 = wp::quat_rotate(var_91, var_442);
                                    // cylinder_axis = wp.quat_rotate(quat_b, wp.vec3(0.0, 0.0, 1.0))       <L 308>
                                    var_447 = wp::vec_t<3, wp::float32>(var_444, var_445, var_446);
                                    var_448 = wp::quat_rotate(var_92, var_447);
                                    // cylinder_radius = scale_b[0]                               <L 309>
                                    var_450 = wp::extract(var_78, var_449);
                                    // cylinder_half_height = scale_b[1]                          <L 310>
                                    var_452 = wp::extract(var_78, var_451);
                                    // dists4, positions4, contact_normal = collide_plane_cylinder(       <L 312>
                                    // plane_normal, pos_a, pos_b, cylinder_axis, cylinder_radius, cylinder_half_height       <L 313>
                                    collide_plane_cylinder_0(var_443, var_89, var_90, var_448, var_450, var_452, var_453, var_454, var_455);
                                    // contact_dist_0 = dists4[0]                                 <L 316>
                                    var_457 = wp::extract(var_453, var_456);
                                    // contact_dist_1 = dists4[1]                                 <L 317>
                                    var_459 = wp::extract(var_453, var_458);
                                    // contact_dist_2 = dists4[2]                                 <L 318>
                                    var_461 = wp::extract(var_453, var_460);
                                    // contact_dist_3 = dists4[3]                                 <L 319>
                                    var_463 = wp::extract(var_453, var_462);
                                    // contact_pos_0 = wp.vec3(positions4[0, 0], positions4[0, 1], positions4[0, 2])       <L 320>
                                    var_466 = wp::extract(var_454, var_464, var_465);
                                    var_469 = wp::extract(var_454, var_467, var_468);
                                    var_472 = wp::extract(var_454, var_470, var_471);
                                    var_473 = wp::vec_t<3, wp::float32>(var_466, var_469, var_472);
                                    // contact_pos_1 = wp.vec3(positions4[1, 0], positions4[1, 1], positions4[1, 2])       <L 321>
                                    var_476 = wp::extract(var_454, var_474, var_475);
                                    var_479 = wp::extract(var_454, var_477, var_478);
                                    var_482 = wp::extract(var_454, var_480, var_481);
                                    var_483 = wp::vec_t<3, wp::float32>(var_476, var_479, var_482);
                                    // contact_pos_2 = wp.vec3(positions4[2, 0], positions4[2, 1], positions4[2, 2])       <L 322>
                                    var_486 = wp::extract(var_454, var_484, var_485);
                                    var_489 = wp::extract(var_454, var_487, var_488);
                                    var_492 = wp::extract(var_454, var_490, var_491);
                                    var_493 = wp::vec_t<3, wp::float32>(var_486, var_489, var_492);
                                    // contact_pos_3 = wp.vec3(positions4[3, 0], positions4[3, 1], positions4[3, 2])       <L 323>
                                    var_496 = wp::extract(var_454, var_494, var_495);
                                    var_499 = wp::extract(var_454, var_497, var_498);
                                    var_502 = wp::extract(var_454, var_500, var_501);
                                    var_503 = wp::vec_t<3, wp::float32>(var_496, var_499, var_502);
                                }
                                if (!var_284) {
                                    // elif is_sphere_a and is_capsule_b:                         <L 328>
                                    var_504 = var_247;
                                    if (var_504) {
                                        var_504 = var_504 && var_253;
                                    }
                                    if (var_504) {
                                        // sphere_radius = scale_a[0]                             <L 329>
                                        var_506 = wp::extract(var_71, var_505);
                                        // capsule_axis = wp.quat_rotate(quat_b, wp.vec3(0.0, 0.0, 1.0))       <L 330>
                                        var_510 = wp::vec_t<3, wp::float32>(var_507, var_508, var_509);
                                        var_511 = wp::quat_rotate(var_92, var_510);
                                        // capsule_radius = scale_b[0]                            <L 331>
                                        var_513 = wp::extract(var_78, var_512);
                                        // capsule_half_length = scale_b[1]                       <L 332>
                                        var_515 = wp::extract(var_78, var_514);
                                        // contact_dist_0, contact_pos_0, contact_normal = collide_sphere_capsule(       <L 333>
                                        // pos_a, sphere_radius, pos_b, capsule_axis, capsule_radius, capsule_half_length       <L 334>
                                        collide_sphere_capsule_0(var_89, var_506, var_90, var_511, var_513, var_515, var_516, var_517, var_518);
                                    }
                                    if (!var_504) {
                                        // elif is_capsule_a and is_capsule_b:                    <L 341>
                                        var_519 = var_251;
                                        if (var_519) {
                                            var_519 = var_519 && var_253;
                                        }
                                        if (var_519) {
                                            // axis_a = wp.quat_rotate(quat_a, wp.vec3(0.0, 0.0, 1.0))       <L 342>
                                            var_523 = wp::vec_t<3, wp::float32>(var_520, var_521, var_522);
                                            var_524 = wp::quat_rotate(var_91, var_523);
                                            // axis_b = wp.quat_rotate(quat_b, wp.vec3(0.0, 0.0, 1.0))       <L 343>
                                            var_528 = wp::vec_t<3, wp::float32>(var_525, var_526, var_527);
                                            var_529 = wp::quat_rotate(var_92, var_528);
                                            // radius_a = scale_a[0]                              <L 344>
                                            var_531 = wp::extract(var_71, var_530);
                                            // half_length_a = scale_a[1]                         <L 345>
                                            var_533 = wp::extract(var_71, var_532);
                                            // radius_b = scale_b[0]                              <L 346>
                                            var_535 = wp::extract(var_78, var_534);
                                            // half_length_b = scale_b[1]                         <L 347>
                                            var_537 = wp::extract(var_78, var_536);
                                            // dists, positions, contact_normal = collide_capsule_capsule(       <L 349>
                                            // pos_a, axis_a, radius_a, half_length_a, pos_b, axis_b, radius_b, half_length_b       <L 350>
                                            collide_capsule_capsule_0(var_89, var_524, var_531, var_533, var_90, var_529, var_535, var_537, var_538, var_539, var_540);
                                            // contact_dist_0 = dists[0]                          <L 353>
                                            var_542 = wp::extract(var_538, var_541);
                                            // contact_pos_0 = wp.vec3(positions[0, 0], positions[0, 1], positions[0, 2])       <L 354>
                                            var_545 = wp::extract(var_539, var_543, var_544);
                                            var_548 = wp::extract(var_539, var_546, var_547);
                                            var_551 = wp::extract(var_539, var_549, var_550);
                                            var_552 = wp::vec_t<3, wp::float32>(var_545, var_548, var_551);
                                            // contact_dist_1 = dists[1]                          <L 355>
                                            var_554 = wp::extract(var_538, var_553);
                                            // contact_pos_1 = wp.vec3(positions[1, 0], positions[1, 1], positions[1, 2])       <L 356>
                                            var_557 = wp::extract(var_539, var_555, var_556);
                                            var_560 = wp::extract(var_539, var_558, var_559);
                                            var_563 = wp::extract(var_539, var_561, var_562);
                                            var_564 = wp::vec_t<3, wp::float32>(var_557, var_560, var_563);
                                        }
                                        if (!var_519) {
                                            // elif is_sphere_a and is_cylinder_b and scale_b[2] == 0.0:       <L 361>
                                            var_565 = var_247;
                                            if (var_565) {
                                                var_565 = var_565 && var_257;
                                            }
                                            if (var_565) {
                                                var_567 = wp::extract(var_78, var_566);
                                                var_569 = (var_567 == var_568);
                                                var_565 = var_565 && var_569;
                                            }
                                            if (var_565) {
                                                // sphere_radius = scale_a[0]                     <L 362>
                                                var_571 = wp::extract(var_71, var_570);
                                                // cylinder_axis = wp.quat_rotate(quat_b, wp.vec3(0.0, 0.0, 1.0))       <L 363>
                                                var_575 = wp::vec_t<3, wp::float32>(var_572, var_573, var_574);
                                                var_576 = wp::quat_rotate(var_92, var_575);
                                                // cylinder_radius = scale_b[0]                   <L 364>
                                                var_578 = wp::extract(var_78, var_577);
                                                // cylinder_half_height = scale_b[1]              <L 365>
                                                var_580 = wp::extract(var_78, var_579);
                                                // contact_dist_0, contact_pos_0, contact_normal = collide_sphere_cylinder(       <L 366>
                                                // pos_a, sphere_radius, pos_b, cylinder_axis, cylinder_radius, cylinder_half_height       <L 367>
                                                collide_sphere_cylinder_0(var_89, var_571, var_90, var_576, var_578, var_580, var_581, var_582, var_583);
                                            }
                                            if (!var_565) {
                                                // elif is_sphere_a and is_box_b:                 <L 373>
                                                var_584 = var_247;
                                                if (var_584) {
                                                    var_584 = var_584 && var_259;
                                                }
                                                if (var_584) {
                                                    // sphere_radius = scale_a[0]                 <L 374>
                                                    var_586 = wp::extract(var_71, var_585);
                                                    // box_rot = wp.quat_to_matrix(quat_b)        <L 375>
                                                    var_587 = wp::quat_to_matrix(var_92);
                                                    // box_size = scale_b                         <L 376>
                                                    var_588 = wp::copy(var_78);
                                                    // contact_dist_0, contact_pos_0, contact_normal = collide_sphere_box(       <L 377>
                                                    // pos_a, sphere_radius, pos_b, box_rot, box_size       <L 378>
                                                    collide_sphere_box_0(var_89, var_586, var_90, var_587, var_588, var_589, var_590, var_591);
                                                }
                                                var_592 = wp::where(var_584, var_589, var_298);
                                                var_593 = wp::where(var_584, var_590, var_302);
                                                var_594 = wp::where(var_584, var_591, var_306);
                                            }
                                            var_595 = wp::where(var_565, var_576, var_275);
                                            var_596 = wp::where(var_565, var_581, var_592);
                                            var_597 = wp::where(var_565, var_582, var_593);
                                            var_598 = wp::where(var_565, var_583, var_594);
                                            var_599 = wp::where(var_565, var_571, var_586);
                                        }
                                        var_600 = wp::where(var_519, var_275, var_595);
                                        var_601 = wp::where(var_519, var_542, var_596);
                                        var_602 = wp::where(var_519, var_554, var_299);
                                        var_603 = wp::where(var_519, var_552, var_597);
                                        var_604 = wp::where(var_519, var_564, var_303);
                                        var_605 = wp::where(var_519, var_540, var_598);
                                    }
                                    var_606 = wp::where(var_504, var_275, var_600);
                                    var_607 = wp::where(var_504, var_516, var_601);
                                    var_608 = wp::where(var_504, var_299, var_602);
                                    var_609 = wp::where(var_504, var_517, var_603);
                                    var_610 = wp::where(var_504, var_303, var_604);
                                    var_611 = wp::where(var_504, var_518, var_605);
                                    var_612 = wp::where(var_504, var_506, var_599);
                                }
                                var_613 = wp::where(var_284, var_443, var_270);
                                var_614 = wp::where(var_284, var_448, var_606);
                                var_615 = wp::where(var_284, var_457, var_607);
                                var_616 = wp::where(var_284, var_459, var_608);
                                var_617 = wp::where(var_284, var_461, var_300);
                                var_618 = wp::where(var_284, var_463, var_301);
                                var_619 = wp::where(var_284, var_473, var_609);
                                var_620 = wp::where(var_284, var_483, var_610);
                                var_621 = wp::where(var_284, var_493, var_304);
                                var_622 = wp::where(var_284, var_503, var_305);
                                var_623 = wp::where(var_284, var_455, var_611);
                                var_624 = wp::where(var_284, var_450, var_578);
                                var_625 = wp::where(var_284, var_452, var_580);
                            }
                            var_626 = wp::where(var_396, var_401, var_613);
                            var_627 = wp::where(var_396, var_275, var_614);
                            var_628 = wp::where(var_396, var_415, var_615);
                            var_629 = wp::where(var_396, var_417, var_616);
                            var_630 = wp::where(var_396, var_300, var_617);
                            var_631 = wp::where(var_396, var_301, var_618);
                            var_632 = wp::where(var_396, var_427, var_619);
                            var_633 = wp::where(var_396, var_437, var_620);
                            var_634 = wp::where(var_396, var_304, var_621);
                            var_635 = wp::where(var_396, var_305, var_622);
                            var_636 = wp::where(var_396, var_438, var_623);
                            var_637 = wp::where(var_396, var_406, var_511);
                            var_638 = wp::where(var_396, var_408, var_513);
                            var_639 = wp::where(var_396, var_410, var_515);
                            var_640 = wp::where(var_396, var_411, var_538);
                            var_641 = wp::where(var_396, var_412, var_539);
                        }
                        var_642 = wp::where(var_388, var_270, var_626);
                        var_643 = wp::where(var_388, var_275, var_627);
                        var_644 = wp::where(var_388, var_393, var_628);
                        var_645 = wp::where(var_388, var_299, var_629);
                        var_646 = wp::where(var_388, var_300, var_630);
                        var_647 = wp::where(var_388, var_301, var_631);
                        var_648 = wp::where(var_388, var_394, var_632);
                        var_649 = wp::where(var_388, var_303, var_633);
                        var_650 = wp::where(var_388, var_304, var_634);
                        var_651 = wp::where(var_388, var_305, var_635);
                        var_652 = wp::where(var_388, var_395, var_636);
                        var_653 = wp::where(var_388, var_390, var_531);
                        var_654 = wp::where(var_388, var_392, var_535);
                    }
                    var_655 = wp::where(var_329, var_334, var_642);
                    var_656 = wp::where(var_329, var_275, var_643);
                    var_657 = wp::where(var_329, var_341, var_644);
                    var_658 = wp::where(var_329, var_343, var_645);
                    var_659 = wp::where(var_329, var_345, var_646);
                    var_660 = wp::where(var_329, var_347, var_647);
                    var_661 = wp::where(var_329, var_357, var_648);
                    var_662 = wp::where(var_329, var_367, var_649);
                    var_663 = wp::where(var_329, var_377, var_650);
                    var_664 = wp::where(var_329, var_387, var_651);
                    var_665 = wp::where(var_329, var_339, var_652);
                    var_666 = wp::where(var_329, var_335, var_587);
                    var_667 = wp::where(var_329, var_336, var_588);
                }
                var_668 = wp::where(var_318, var_323, var_655);
                var_669 = wp::where(var_318, var_275, var_656);
                var_670 = wp::where(var_318, var_326, var_657);
                var_671 = wp::where(var_318, var_299, var_658);
                var_672 = wp::where(var_318, var_300, var_659);
                var_673 = wp::where(var_318, var_301, var_660);
                var_674 = wp::where(var_318, var_327, var_661);
                var_675 = wp::where(var_318, var_303, var_662);
                var_676 = wp::where(var_318, var_304, var_663);
                var_677 = wp::where(var_318, var_305, var_664);
                var_678 = wp::where(var_318, var_328, var_665);
            }
            var_679 = wp::where(var_307, var_312, var_668);
            var_680 = wp::where(var_307, var_275, var_669);
            var_681 = wp::where(var_307, var_315, var_670);
            var_682 = wp::where(var_307, var_299, var_671);
            var_683 = wp::where(var_307, var_300, var_672);
            var_684 = wp::where(var_307, var_301, var_673);
            var_685 = wp::where(var_307, var_316, var_674);
            var_686 = wp::where(var_307, var_303, var_675);
            var_687 = wp::where(var_307, var_304, var_676);
            var_688 = wp::where(var_307, var_305, var_677);
            var_689 = wp::where(var_307, var_317, var_678);
            var_690 = wp::where(var_307, var_314, var_612);
            // num_contacts = (                                                                   <L 384>
            // int(contact_dist_0 < MAXVAL)                                                       <L 385>
            var_691 = (var_681 < var_297);
            var_692 = wp::int(var_691);
            // + int(contact_dist_1 < MAXVAL)                                                     <L 386>
            var_693 = (var_682 < var_297);
            var_694 = wp::int(var_693);
            var_695 = wp::add(var_692, var_694);
            // + int(contact_dist_2 < MAXVAL)                                                     <L 387>
            var_696 = (var_683 < var_297);
            var_697 = wp::int(var_696);
            var_698 = wp::add(var_695, var_697);
            // + int(contact_dist_3 < MAXVAL)                                                     <L 388>
            var_699 = (var_684 < var_297);
            var_700 = wp::int(var_699);
            var_701 = wp::add(var_698, var_700);
            // if num_contacts > 0:                                                               <L 390>
            var_703 = (var_701 > var_702);
            if (var_703) {
                // contact_data = ContactData()                                                   <L 392>
                var_704 = ContactData_40360d7c();
                // contact_data.contact_normal_a_to_b = contact_normal                            <L 393>
                var_704.contact_normal_a_to_b = var_689;
                // contact_data.radius_eff_a = radius_eff_a                                       <L 394>
                var_704.radius_eff_a = var_292;
                // contact_data.radius_eff_b = radius_eff_b                                       <L 395>
                var_704.radius_eff_b = var_296;
                // contact_data.margin_a = margin_offset_a                                        <L 396>
                var_704.margin_a = var_80;
                // contact_data.margin_b = margin_offset_b                                        <L 397>
                var_704.margin_b = var_82;
                // contact_data.shape_a = shape_a                                                 <L 398>
                var_704.shape_a = var_33;
                // contact_data.shape_b = shape_b                                                 <L 399>
                var_704.shape_b = var_34;
                // if wp.static(speculative):                                                     <L 400>
                // contact_data.gap_sum = gap_sum                                                 <L 403>
                var_704.gap_sum = var_99;
                // contact_0_valid = False                                                        <L 406>
                // if contact_dist_0 < MAXVAL:                                                    <L 407>
                var_707 = (var_681 < var_297);
                if (var_707) {
                    // contact_0_valid = _admit(                                                  <L 408>
                    // contact_data,                                                              <L 409>
                    // contact_pos_0,                                                             <L 410>
                    // contact_dist_0,                                                            <L 411>
                    // shape_transform,                                                           <L 412>
                    // shape_linear_velocity,                                                     <L 413>
                    // shape_angular_velocity,                                                    <L 414>
                    // collision_update_dt,                                                       <L 415>
                    // max_speculative_extension,                                                 <L 416>
                    var_708 = create_narrow_phase_primitive_kernel__locals___admit_0(var_704, var_685, var_681, var_shape_transform, var_shape_linear_velocity, var_shape_angular_velocity, var_collision_update_dt, var_max_speculative_extension);
                }
                var_709 = wp::where(var_707, var_708, var_706);
                // contact_1_valid = False                                                        <L 419>
                // if contact_dist_1 < MAXVAL:                                                    <L 420>
                var_711 = (var_682 < var_297);
                if (var_711) {
                    // contact_1_valid = _admit(                                                  <L 421>
                    // contact_data,                                                              <L 422>
                    // contact_pos_1,                                                             <L 423>
                    // contact_dist_1,                                                            <L 424>
                    // shape_transform,                                                           <L 425>
                    // shape_linear_velocity,                                                     <L 426>
                    // shape_angular_velocity,                                                    <L 427>
                    // collision_update_dt,                                                       <L 428>
                    // max_speculative_extension,                                                 <L 429>
                    var_712 = create_narrow_phase_primitive_kernel__locals___admit_0(var_704, var_686, var_682, var_shape_transform, var_shape_linear_velocity, var_shape_angular_velocity, var_collision_update_dt, var_max_speculative_extension);
                }
                var_713 = wp::where(var_711, var_712, var_710);
                // contact_2_valid = False                                                        <L 432>
                // if contact_dist_2 < MAXVAL:                                                    <L 433>
                var_715 = (var_683 < var_297);
                if (var_715) {
                    // contact_2_valid = _admit(                                                  <L 434>
                    // contact_data,                                                              <L 435>
                    // contact_pos_2,                                                             <L 436>
                    // contact_dist_2,                                                            <L 437>
                    // shape_transform,                                                           <L 438>
                    // shape_linear_velocity,                                                     <L 439>
                    // shape_angular_velocity,                                                    <L 440>
                    // collision_update_dt,                                                       <L 441>
                    // max_speculative_extension,                                                 <L 442>
                    var_716 = create_narrow_phase_primitive_kernel__locals___admit_0(var_704, var_687, var_683, var_shape_transform, var_shape_linear_velocity, var_shape_angular_velocity, var_collision_update_dt, var_max_speculative_extension);
                }
                var_717 = wp::where(var_715, var_716, var_714);
                // contact_3_valid = False                                                        <L 445>
                // if contact_dist_3 < MAXVAL:                                                    <L 446>
                var_719 = (var_684 < var_297);
                if (var_719) {
                    // contact_3_valid = _admit(                                                  <L 447>
                    // contact_data,                                                              <L 448>
                    // contact_pos_3,                                                             <L 449>
                    // contact_dist_3,                                                            <L 450>
                    // shape_transform,                                                           <L 451>
                    // shape_linear_velocity,                                                     <L 452>
                    // shape_angular_velocity,                                                    <L 453>
                    // collision_update_dt,                                                       <L 454>
                    // max_speculative_extension,                                                 <L 455>
                    var_720 = create_narrow_phase_primitive_kernel__locals___admit_0(var_704, var_688, var_684, var_shape_transform, var_shape_linear_velocity, var_shape_angular_velocity, var_collision_update_dt, var_max_speculative_extension);
                }
                var_721 = wp::where(var_719, var_720, var_718);
                // num_valid = int(contact_0_valid) + int(contact_1_valid) + int(contact_2_valid) + int(contact_3_valid)       <L 459>
                var_722 = wp::int(var_709);
                var_723 = wp::int(var_713);
                var_724 = wp::add(var_722, var_723);
                var_725 = wp::int(var_717);
                var_726 = wp::add(var_724, var_725);
                var_727 = wp::int(var_721);
                var_728 = wp::add(var_726, var_727);
                // if num_valid > 0:                                                              <L 460>
                var_730 = (var_728 > var_729);
                if (var_730) {
                    // base_index = wp.atomic_add(writer_data.contact_count, 0, num_valid)        <L 461>
                    var_731 = &((var_writer_data).contact_count);
                    var_734 = wp::load(var_731);
                    var_733 = wp::atomic_add(var_734, var_732, var_728);
                    // if base_index + num_valid > writer_data.contact_max:                       <L 465>
                    var_735 = wp::add(var_733, var_728);
                    var_736 = &((var_writer_data).contact_max);
                    var_738 = wp::load(var_736);
                    var_737 = (var_735 > var_738);
                    if (var_737) {
                        // continue                                                               <L 466>
                        goto start_for_1;
                    }
                    // if contact_0_valid:                                                        <L 469>
                    if (var_709) {
                        // contact_data.contact_point_center = contact_pos_0                      <L 470>
                        var_704.contact_point_center = var_685;
                        // contact_data.contact_distance = contact_dist_0                         <L 471>
                        var_704.contact_distance = var_681;
                        // contact_data.sort_sub_key = 0                                          <L 472>
                        var_704.sort_sub_key = var_739;
                        // writer_func(contact_data, writer_data, base_index)                     <L 473>
                        write_contact_0(var_704, var_writer_data, var_733);
                        // base_index += 1                                                        <L 474>
                        var_741 = wp::add(var_733, var_740);
                    }
                    var_742 = wp::where(var_709, var_741, var_733);
                    // if contact_1_valid:                                                        <L 477>
                    if (var_713) {
                        // contact_data.contact_point_center = contact_pos_1                      <L 478>
                        var_704.contact_point_center = var_686;
                        // contact_data.contact_distance = contact_dist_1                         <L 479>
                        var_704.contact_distance = var_682;
                        // contact_data.sort_sub_key = 1                                          <L 480>
                        var_704.sort_sub_key = var_743;
                        // writer_func(contact_data, writer_data, base_index)                     <L 481>
                        write_contact_0(var_704, var_writer_data, var_742);
                        // base_index += 1                                                        <L 482>
                        var_745 = wp::add(var_742, var_744);
                    }
                    var_746 = wp::where(var_713, var_745, var_742);
                    // if contact_2_valid:                                                        <L 485>
                    if (var_717) {
                        // contact_data.contact_point_center = contact_pos_2                      <L 486>
                        var_704.contact_point_center = var_687;
                        // contact_data.contact_distance = contact_dist_2                         <L 487>
                        var_704.contact_distance = var_683;
                        // contact_data.sort_sub_key = 2                                          <L 488>
                        var_704.sort_sub_key = var_747;
                        // writer_func(contact_data, writer_data, base_index)                     <L 489>
                        write_contact_0(var_704, var_writer_data, var_746);
                        // base_index += 1                                                        <L 490>
                        var_749 = wp::add(var_746, var_748);
                    }
                    var_750 = wp::where(var_717, var_749, var_746);
                    // if contact_3_valid:                                                        <L 493>
                    if (var_721) {
                        // contact_data.contact_point_center = contact_pos_3                      <L 494>
                        var_704.contact_point_center = var_688;
                        // contact_data.contact_distance = contact_dist_3                         <L 495>
                        var_704.contact_distance = var_684;
                        // contact_data.sort_sub_key = 3                                          <L 496>
                        var_704.sort_sub_key = var_751;
                        // writer_func(contact_data, writer_data, base_index)                     <L 497>
                        write_contact_0(var_704, var_writer_data, var_750);
                    }
                }
                // continue                                                                       <L 499>
                goto start_for_1;
            }
            // idx = wp.atomic_add(gjk_candidate_pairs_count, 0, 1)                               <L 504>
            var_754 = wp::atomic_add(var_gjk_candidate_pairs_count, var_752, var_753);
            // if idx < gjk_candidate_pairs.shape[0]:                                             <L 505>
            var_755 = &(var_gjk_candidate_pairs.shape);
            var_758 = wp::load(var_755);
            var_757 = wp::extract(var_758, var_756);
            var_759 = (var_754 < var_757);
            if (var_759) {
                // gjk_candidate_pairs[idx] = wp.vec2i(shape_a, shape_b)                          <L 506>
                var_760 = wp::vec_t<2, wp::int32>(var_33, var_34);
                wp::array_store(var_gjk_candidate_pairs, var_754, var_760);
            }
            goto start_for_1;
        end_for_1:;
    }
}

