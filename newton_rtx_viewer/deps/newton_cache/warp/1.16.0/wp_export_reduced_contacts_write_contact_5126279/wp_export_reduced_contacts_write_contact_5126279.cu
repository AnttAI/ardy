#define WP_NO_BFLOAT16

#define WP_TILE_BLOCK_DIM 32
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




// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:559
static CUDA_CALLABLE wp::int32 _unpack_contact_id_det_0(
    wp::uint64 packed)
{

return static_cast<int32_t>(packed & 0xFFFFFull);
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:435
static CUDA_CALLABLE wp::int32 _unpack_contact_id_fast_0(
    wp::uint64 packed)
{

return static_cast<int32_t>(packed & 0xFFFFFFFFull);
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:614
static CUDA_CALLABLE wp::int32 unpack_contact_id_0(
    wp::uint64 var_packed,
    wp::int32 var_deterministic)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    bool var_1;
    wp::int32 var_2;
    wp::int32 var_3;
    //---------
    // forward
    // def unpack_contact_id(packed: wp.uint64, deterministic: int) -> int:                   <L 615>
    // if deterministic != 0:                                                                 <L 625>
    var_1 = (var_deterministic != var_0);
    if (var_1) {
        // return _unpack_contact_id_det(packed)                                              <L 626>
        var_2 = _unpack_contact_id_det_0(var_packed);
        return var_2;
    }
    // return _unpack_contact_id_fast(packed)                                                 <L 627>
    var_3 = _unpack_contact_id_fast_0(var_packed);
    return var_3;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction.py:104
static CUDA_CALLABLE wp::uint32 float_flip_0(
    wp::float32 f)
{

uint32_t i = reinterpret_cast<uint32_t&>(f);
uint32_t mask = (uint32_t)(-(int)(i >> 31)) | 0x80000000;
return i ^ mask;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:139
static CUDA_CALLABLE bool _floats_are_near_ulps_0(
    wp::float32 var_a,
    wp::float32 var_b)
{
    //---------
    // primal vars
    wp::float32 var_0;
    wp::float32 var_1;
    const wp::float32 var_2 = 1e-08;
    bool var_3;
    const bool var_4 = false;
    wp::uint32 var_5;
    wp::uint32 var_6;
    bool var_7;
    wp::uint32 var_8;
    const wp::int32 var_9 = 16;
    wp::uint32 var_10;
    bool var_11;
    wp::uint32 var_12;
    const wp::int32 var_13 = 16;
    wp::uint32 var_14;
    bool var_15;
    //---------
    // forward
    // def _floats_are_near_ulps(a: float, b: float) -> bool:                                 <L 140>
    // if wp.abs(a - b) > 1.0e-8:                                                             <L 142>
    var_0 = wp::sub(var_a, var_b);
    var_1 = wp::abs(var_0);
    var_3 = (var_1 > var_2);
    if (var_3) {
        // return False                                                                       <L 143>
        return var_4;
    }
    // a_bits = float_flip(a)                                                                 <L 144>
    var_5 = float_flip_0(var_a);
    // b_bits = float_flip(b)                                                                 <L 145>
    var_6 = float_flip_0(var_b);
    // if a_bits > b_bits:                                                                    <L 146>
    var_7 = (var_5 > var_6);
    if (var_7) {
        // return a_bits - b_bits <= wp.uint32(16)                                            <L 147>
        var_8 = wp::sub(var_5, var_6);
        var_10 = wp::uint32(var_9);
        var_11 = (var_8 <= var_10);
        return var_11;
    }
    // return b_bits - a_bits <= wp.uint32(16)                                                <L 148>
    var_12 = wp::sub(var_6, var_5);
    var_14 = wp::uint32(var_13);
    var_15 = (var_12 <= var_14);
    return var_15;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:151
static CUDA_CALLABLE bool _contacts_are_numerically_equivalent_0(
    wp::int32 var_contact_a,
    wp::int32 var_contact_b,
    wp::array_t<wp::vec_t<4, wp::float32>> var_position_depth,
    wp::array_t<wp::vec_t<2, wp::float32>> var_normal)
{
    //---------
    // primal vars
    wp::vec_t<4, wp::float32>* var_0;
    wp::vec_t<4, wp::float32> var_1;
    wp::vec_t<4, wp::float32> var_2;
    wp::vec_t<4, wp::float32>* var_3;
    wp::vec_t<4, wp::float32> var_4;
    wp::vec_t<4, wp::float32> var_5;
    const wp::int32 var_6 = 0;
    wp::float32 var_7;
    const wp::int32 var_8 = 0;
    wp::float32 var_9;
    bool var_10;
    bool var_11;
    const bool var_12 = false;
    const wp::int32 var_13 = 1;
    wp::float32 var_14;
    const wp::int32 var_15 = 1;
    wp::float32 var_16;
    bool var_17;
    bool var_18;
    const bool var_19 = false;
    const wp::int32 var_20 = 2;
    wp::float32 var_21;
    const wp::int32 var_22 = 2;
    wp::float32 var_23;
    bool var_24;
    bool var_25;
    const bool var_26 = false;
    const wp::int32 var_27 = 3;
    wp::float32 var_28;
    const wp::int32 var_29 = 3;
    wp::float32 var_30;
    bool var_31;
    bool var_32;
    const bool var_33 = false;
    wp::vec_t<2, wp::float32>* var_34;
    wp::vec_t<2, wp::float32> var_35;
    wp::vec_t<2, wp::float32> var_36;
    wp::vec_t<2, wp::float32>* var_37;
    wp::vec_t<2, wp::float32> var_38;
    wp::vec_t<2, wp::float32> var_39;
    const wp::int32 var_40 = 0;
    wp::float32 var_41;
    const wp::int32 var_42 = 0;
    wp::float32 var_43;
    bool var_44;
    bool var_45;
    const bool var_46 = false;
    const wp::int32 var_47 = 1;
    wp::float32 var_48;
    const wp::int32 var_49 = 1;
    wp::float32 var_50;
    bool var_51;
    //---------
    // forward
    // def _contacts_are_numerically_equivalent(                                              <L 152>
    // pd_a = position_depth[contact_a]                                                       <L 159>
    var_0 = wp::address(var_position_depth, var_contact_a);
    var_2 = wp::load(var_0);
    var_1 = wp::copy(var_2);
    // pd_b = position_depth[contact_b]                                                       <L 160>
    var_3 = wp::address(var_position_depth, var_contact_b);
    var_5 = wp::load(var_3);
    var_4 = wp::copy(var_5);
    // if not _floats_are_near_ulps(pd_a[0], pd_b[0]):                                        <L 161>
    var_7 = wp::extract(var_1, var_6);
    var_9 = wp::extract(var_4, var_8);
    var_10 = _floats_are_near_ulps_0(var_7, var_9);
    var_11 = wp::unot(var_10);
    if (var_11) {
        // return False                                                                       <L 162>
        return var_12;
    }
    // if not _floats_are_near_ulps(pd_a[1], pd_b[1]):                                        <L 163>
    var_14 = wp::extract(var_1, var_13);
    var_16 = wp::extract(var_4, var_15);
    var_17 = _floats_are_near_ulps_0(var_14, var_16);
    var_18 = wp::unot(var_17);
    if (var_18) {
        // return False                                                                       <L 164>
        return var_19;
    }
    // if not _floats_are_near_ulps(pd_a[2], pd_b[2]):                                        <L 165>
    var_21 = wp::extract(var_1, var_20);
    var_23 = wp::extract(var_4, var_22);
    var_24 = _floats_are_near_ulps_0(var_21, var_23);
    var_25 = wp::unot(var_24);
    if (var_25) {
        // return False                                                                       <L 166>
        return var_26;
    }
    // if not _floats_are_near_ulps(pd_a[3], pd_b[3]):                                        <L 167>
    var_28 = wp::extract(var_1, var_27);
    var_30 = wp::extract(var_4, var_29);
    var_31 = _floats_are_near_ulps_0(var_28, var_30);
    var_32 = wp::unot(var_31);
    if (var_32) {
        // return False                                                                       <L 168>
        return var_33;
    }
    // n_a = normal[contact_a]                                                                <L 170>
    var_34 = wp::address(var_normal, var_contact_a);
    var_36 = wp::load(var_34);
    var_35 = wp::copy(var_36);
    // n_b = normal[contact_b]                                                                <L 171>
    var_37 = wp::address(var_normal, var_contact_b);
    var_39 = wp::load(var_37);
    var_38 = wp::copy(var_39);
    // if not _floats_are_near_ulps(n_a[0], n_b[0]):                                          <L 172>
    var_41 = wp::extract(var_35, var_40);
    var_43 = wp::extract(var_38, var_42);
    var_44 = _floats_are_near_ulps_0(var_41, var_43);
    var_45 = wp::unot(var_44);
    if (var_45) {
        // return False                                                                       <L 173>
        return var_46;
    }
    // return _floats_are_near_ulps(n_a[1], n_b[1])                                           <L 174>
    var_48 = wp::extract(var_35, var_47);
    var_50 = wp::extract(var_38, var_49);
    var_51 = _floats_are_near_ulps_0(var_48, var_50);
    return var_51;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:2088
static CUDA_CALLABLE wp::int32 _roundoff_duplicate_bit_for_slot_pair_0(
    wp::int32 var_pair_idx,
    wp::int32 var_entry_idx,
    wp::int32 var_ht_capacity,
    wp::array_t<wp::uint64> var_ht_values,
    wp::array_t<wp::vec_t<4, wp::float32>> var_position_depth,
    wp::array_t<wp::vec_t<2, wp::float32>> var_normal,
    wp::array_t<wp::int32> var_contact_fingerprints,
    wp::int32 var_deterministic)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 1;
    wp::int32 var_1;
    bool var_2;
    wp::int32 var_3;
    const wp::int32 var_4 = 1;
    wp::int32 var_5;
    wp::int32 var_6;
    wp::int32 var_7;
    wp::int32 var_8;
    wp::uint64* var_9;
    wp::uint64 var_10;
    wp::uint64 var_11;
    wp::int32 var_12;
    wp::int32 var_13;
    wp::uint64* var_14;
    wp::uint64 var_15;
    wp::uint64 var_16;
    bool var_17;
    wp::uint64 var_18;
    bool var_19;
    wp::uint64 var_20;
    bool var_21;
    const wp::int32 var_22 = 0;
    wp::int32 var_23;
    wp::int32 var_24;
    bool var_25;
    const wp::int32 var_26 = 0;
    bool var_27;
    bool var_28;
    const wp::int32 var_29 = 0;
    wp::int32* var_30;
    wp::int32* var_31;
    bool var_32;
    wp::int32 var_33;
    wp::int32 var_34;
    const wp::int32 var_35 = 1;
    wp::int32 var_36;
    const wp::int32 var_37 = 1;
    wp::int32 var_38;
    //---------
    // forward
    // def _roundoff_duplicate_bit_for_slot_pair(                                             <L 2089>
    // slot_b = int(1)                                                                        <L 2100>
    var_1 = wp::int(var_0);
    // while pair_idx >= slot_b:                                                              <L 2101>
    start_while_0:;
    var_2 = (var_pair_idx >= var_1);
    if ((var_2) == false) goto end_while_0;
        // pair_idx = pair_idx - slot_b                                                       <L 2102>
        var_3 = wp::sub(var_pair_idx, var_1);
        // slot_b = slot_b + 1                                                                <L 2103>
        var_5 = wp::add(var_1, var_4);
        wp::assign(var_pair_idx, var_3);
        wp::assign(var_1, var_5);
    goto start_while_0;
    end_while_0:;
    // slot_a = pair_idx                                                                      <L 2104>
    var_6 = wp::copy(var_pair_idx);
    // value_a = ht_values[slot_a * ht_capacity + entry_idx]                                  <L 2106>
    var_7 = wp::mul(var_6, var_ht_capacity);
    var_8 = wp::add(var_7, var_entry_idx);
    var_9 = wp::address(var_ht_values, var_8);
    var_11 = wp::load(var_9);
    var_10 = wp::copy(var_11);
    // value_b = ht_values[slot_b * ht_capacity + entry_idx]                                  <L 2107>
    var_12 = wp::mul(var_1, var_ht_capacity);
    var_13 = wp::add(var_12, var_entry_idx);
    var_14 = wp::address(var_ht_values, var_13);
    var_16 = wp::load(var_14);
    var_15 = wp::copy(var_16);
    // if value_a == wp.uint64(0) or value_b == wp.uint64(0):                                 <L 2108>
    var_18 = 0ull;
    var_19 = (var_10 == var_18);
    var_17 = var_19;
    if (!var_17) {
        var_20 = 0ull;
        var_21 = (var_15 == var_20);
        var_17 = var_17 || var_21;
    }
    if (var_17) {
        // return 0                                                                           <L 2109>
        return var_22;
    }
    // contact_a = unpack_contact_id(value_a, deterministic)                                  <L 2111>
    var_23 = unpack_contact_id_0(var_10, var_deterministic);
    // contact_b = unpack_contact_id(value_b, deterministic)                                  <L 2112>
    var_24 = unpack_contact_id_0(var_15, var_deterministic);
    // if contact_a == contact_b:                                                             <L 2113>
    var_25 = (var_23 == var_24);
    if (var_25) {
        // return 0                                                                           <L 2114>
        return var_26;
    }
    // if not _contacts_are_numerically_equivalent(contact_a, contact_b, position_depth, normal):       <L 2115>
    var_27 = _contacts_are_numerically_equivalent_0(var_23, var_24, var_position_depth, var_normal);
    var_28 = wp::unot(var_27);
    if (var_28) {
        // return 0                                                                           <L 2116>
        return var_29;
    }
    // if contact_fingerprints[contact_b] < contact_fingerprints[contact_a]:                  <L 2118>
    var_30 = wp::address(var_contact_fingerprints, var_24);
    var_31 = wp::address(var_contact_fingerprints, var_23);
    var_33 = wp::load(var_30);
    var_34 = wp::load(var_31);
    var_32 = (var_33 < var_34);
    if (var_32) {
        // return 1 << slot_a                                                                 <L 2119>
        var_36 = wp::lshift(var_35, var_6);
        return var_36;
    }
    // return 1 << slot_b                                                                     <L 2120>
    var_38 = wp::lshift(var_37, var_1);
    return var_38;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:660
static CUDA_CALLABLE wp::vec_t<3, wp::float32> decode_oct_0(
    wp::vec_t<2, wp::float32> var_e)
{
    //---------
    // primal vars
    const wp::float32 var_0 = 1.0;
    const wp::int32 var_1 = 0;
    wp::float32 var_2;
    wp::float32 var_3;
    wp::float32 var_4;
    const wp::int32 var_5 = 1;
    wp::float32 var_6;
    wp::float32 var_7;
    wp::float32 var_8;
    const wp::int32 var_9 = 0;
    wp::float32 var_10;
    const wp::int32 var_11 = 1;
    wp::float32 var_12;
    const wp::float32 var_13 = 0.0;
    bool var_14;
    const wp::float32 var_15 = 1.0;
    const wp::float32 var_16 = 0.0;
    bool var_17;
    const wp::float32 var_18 = -1.0;
    wp::float32 var_19;
    const wp::float32 var_20 = 1.0;
    const wp::float32 var_21 = 0.0;
    bool var_22;
    const wp::float32 var_23 = -1.0;
    wp::float32 var_24;
    const wp::float32 var_25 = 1.0;
    wp::float32 var_26;
    wp::float32 var_27;
    wp::float32 var_28;
    const wp::float32 var_29 = 1.0;
    wp::float32 var_30;
    wp::float32 var_31;
    wp::float32 var_32;
    wp::float32 var_33;
    wp::float32 var_34;
    wp::float32 var_35;
    wp::float32 var_36;
    wp::vec_t<3, wp::float32> var_37;
    wp::vec_t<3, wp::float32> var_38;
    //---------
    // forward
    // def decode_oct(e: wp.vec2) -> wp.vec3:                                                 <L 661>
    // nz = 1.0 - wp.abs(e[0]) - wp.abs(e[1])                                                 <L 666>
    var_2 = wp::extract(var_e, var_1);
    var_3 = wp::abs(var_2);
    var_4 = wp::sub(var_0, var_3);
    var_6 = wp::extract(var_e, var_5);
    var_7 = wp::abs(var_6);
    var_8 = wp::sub(var_4, var_7);
    // nx = e[0]                                                                              <L 667>
    var_10 = wp::extract(var_e, var_9);
    // ny = e[1]                                                                              <L 668>
    var_12 = wp::extract(var_e, var_11);
    // if nz < 0.0:                                                                           <L 670>
    var_14 = (var_8 < var_13);
    if (var_14) {
        // sign_x = 1.0                                                                       <L 671>
        // if nx < 0.0:                                                                       <L 672>
        var_17 = (var_10 < var_16);
        if (var_17) {
            // sign_x = -1.0                                                                  <L 673>
        }
        var_19 = wp::where(var_17, var_18, var_15);
        // sign_y = 1.0                                                                       <L 674>
        // if ny < 0.0:                                                                       <L 675>
        var_22 = (var_12 < var_21);
        if (var_22) {
            // sign_y = -1.0                                                                  <L 676>
        }
        var_24 = wp::where(var_22, var_23, var_20);
        // new_x = (1.0 - wp.abs(ny)) * sign_x                                                <L 677>
        var_26 = wp::abs(var_12);
        var_27 = wp::sub(var_25, var_26);
        var_28 = wp::mul(var_27, var_19);
        // new_y = (1.0 - wp.abs(nx)) * sign_y                                                <L 678>
        var_30 = wp::abs(var_10);
        var_31 = wp::sub(var_29, var_30);
        var_32 = wp::mul(var_31, var_24);
        // nx = new_x                                                                         <L 679>
        var_33 = wp::copy(var_28);
        // ny = new_y                                                                         <L 680>
        var_34 = wp::copy(var_32);
    }
    var_35 = wp::where(var_14, var_33, var_10);
    var_36 = wp::where(var_14, var_34, var_12);
    // return wp.normalize(wp.vec3(nx, ny, nz))                                               <L 682>
    var_37 = wp::vec_t<3, wp::float32>(var_35, var_36, var_8);
    var_38 = wp::normalize(var_37);
    return var_38;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:2021
static CUDA_CALLABLE void unpack_contact_0(
    wp::int32 var_contact_id,
    wp::array_t<wp::vec_t<4, wp::float32>> var_position_depth,
    wp::array_t<wp::vec_t<2, wp::float32>> var_normal,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::float32 & ret_2)
{
    //---------
    // primal vars
    wp::vec_t<4, wp::float32>* var_0;
    wp::vec_t<4, wp::float32> var_1;
    wp::vec_t<4, wp::float32> var_2;
    wp::vec_t<2, wp::float32>* var_3;
    wp::vec_t<3, wp::float32> var_4;
    wp::vec_t<2, wp::float32> var_5;
    const wp::int32 var_6 = 0;
    wp::float32 var_7;
    const wp::int32 var_8 = 1;
    wp::float32 var_9;
    const wp::int32 var_10 = 2;
    wp::float32 var_11;
    wp::vec_t<3, wp::float32> var_12;
    const wp::int32 var_13 = 3;
    wp::float32 var_14;
    //---------
    // forward
    // def unpack_contact(                                                                    <L 2022>
    // pd = position_depth[contact_id]                                                        <L 2039>
    var_0 = wp::address(var_position_depth, var_contact_id);
    var_2 = wp::load(var_0);
    var_1 = wp::copy(var_2);
    // n = decode_oct(normal[contact_id])                                                     <L 2040>
    var_3 = wp::address(var_normal, var_contact_id);
    var_5 = wp::load(var_3);
    var_4 = decode_oct_0(var_5);
    // position = wp.vec3(pd[0], pd[1], pd[2])                                                <L 2042>
    var_7 = wp::extract(var_1, var_6);
    var_9 = wp::extract(var_1, var_8);
    var_11 = wp::extract(var_1, var_10);
    var_12 = wp::vec_t<3, wp::float32>(var_7, var_9, var_11);
    // depth = pd[3]                                                                          <L 2043>
    var_14 = wp::extract(var_1, var_13);
    // return position, n, depth                                                              <L 2045>
    ret_0 = var_12;
    ret_1 = var_4;
    ret_2 = var_14;
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:177
static CUDA_CALLABLE wp::float32 compute_effective_radius_0(
    wp::int32 var_shape_type,
    wp::vec_t<4, wp::float32> var_shape_scale)
{
    //---------
    // primal vars
    bool var_0;
    const wp::int32 var_1 = 3;
    bool var_2;
    const wp::int32 var_3 = 4;
    bool var_4;
    const wp::int32 var_5 = 0;
    wp::float32 var_6;
    const wp::float32 var_7 = 0.0;
    //---------
    // forward
    // def compute_effective_radius(shape_type: int, shape_scale: wp.vec4) -> float:          <L 178>
    // if shape_type == GeoType.SPHERE or shape_type == GeoType.CAPSULE:                      <L 191>
    var_2 = (var_shape_type == var_1);
    var_0 = var_2;
    if (!var_0) {
        var_4 = (var_shape_type == var_3);
        var_0 = var_0 || var_4;
    }
    if (var_0) {
        // return shape_scale[0]                                                              <L 192>
        var_6 = wp::extract(var_shape_scale, var_5);
        return var_6;
    }
    // return 0.0                                                                             <L 193>
    return var_7;
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:0
static CUDA_CALLABLE void create_export_reduced_contacts_kernel__locals__export_contact_id_0(
    wp::int32 var_contact_id,
    wp::array_t<wp::vec_t<4, wp::float32>> var_position_depth,
    wp::array_t<wp::vec_t<2, wp::float32>> var_normal,
    wp::array_t<wp::vec_t<2, wp::int32>> var_shape_pairs,
    wp::array_t<wp::int32> var_contact_fingerprints,
    wp::array_t<wp::int32> var_exported_flags,
    wp::array_t<wp::int32> var_shape_types,
    wp::array_t<wp::vec_t<4, wp::float32>> var_shape_data,
    wp::array_t<wp::float32> var_shape_gap,
    ContactWriterData_4222ebad var_writer_data)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 1;
    wp::int32 var_1;
    const wp::int32 var_2 = 0;
    bool var_3;
    wp::vec_t<3, wp::float32> var_4;
    wp::vec_t<3, wp::float32> var_5;
    wp::float32 var_6;
    wp::vec_t<2, wp::int32>* var_7;
    wp::vec_t<2, wp::int32> var_8;
    wp::vec_t<2, wp::int32> var_9;
    const wp::int32 var_10 = 0;
    wp::int32 var_11;
    const wp::int32 var_12 = 1;
    wp::int32 var_13;
    wp::vec_t<4, wp::float32>* var_14;
    const wp::int32 var_15 = 3;
    wp::float32 var_16;
    wp::vec_t<4, wp::float32> var_17;
    wp::vec_t<4, wp::float32>* var_18;
    const wp::int32 var_19 = 3;
    wp::float32 var_20;
    wp::vec_t<4, wp::float32> var_21;
    wp::int32* var_22;
    wp::vec_t<4, wp::float32>* var_23;
    wp::float32 var_24;
    wp::int32 var_25;
    wp::vec_t<4, wp::float32> var_26;
    wp::int32* var_27;
    wp::vec_t<4, wp::float32>* var_28;
    wp::float32 var_29;
    wp::int32 var_30;
    wp::vec_t<4, wp::float32> var_31;
    wp::float32* var_32;
    wp::float32* var_33;
    wp::float32 var_34;
    wp::float32 var_35;
    wp::float32 var_36;
    ContactData_40360d7c var_37;
    wp::int32* var_38;
    wp::int32 var_39;
    wp::int32 var_40;
    const wp::int32 var_41 = -1;
    //---------
    // forward
    // def export_contact_id(                                                                 <L 1>
    // old_flag = wp.atomic_add(exported_flags, contact_id, 1)                                <L 13>
    var_1 = wp::atomic_add(var_exported_flags, var_contact_id, var_0);
    // if old_flag > 0:                                                                       <L 14>
    var_3 = (var_1 > var_2);
    if (var_3) {
        // return                                                                             <L 15>
        return;
    }
    // position, contact_normal, depth = unpack_contact(contact_id, position_depth, normal)       <L 17>
    unpack_contact_0(var_contact_id, var_position_depth, var_normal, var_4, var_5, var_6);
    // pair = shape_pairs[contact_id]                                                         <L 18>
    var_7 = wp::address(var_shape_pairs, var_contact_id);
    var_9 = wp::load(var_7);
    var_8 = wp::copy(var_9);
    // shape_a = pair[0]                                                                      <L 19>
    var_11 = wp::extract(var_8, var_10);
    // shape_b = pair[1]                                                                      <L 20>
    var_13 = wp::extract(var_8, var_12);
    // margin_offset_a = shape_data[shape_a][3]                                               <L 21>
    var_14 = wp::address(var_shape_data, var_11);
    var_17 = wp::load(var_14);
    var_16 = wp::extract(var_17, var_15);
    // margin_offset_b = shape_data[shape_b][3]                                               <L 22>
    var_18 = wp::address(var_shape_data, var_13);
    var_21 = wp::load(var_18);
    var_20 = wp::extract(var_21, var_19);
    // radius_eff_a = compute_effective_radius(shape_types[shape_a], shape_data[shape_a])       <L 23>
    var_22 = wp::address(var_shape_types, var_11);
    var_23 = wp::address(var_shape_data, var_11);
    var_25 = wp::load(var_22);
    var_26 = wp::load(var_23);
    var_24 = compute_effective_radius_0(var_25, var_26);
    // radius_eff_b = compute_effective_radius(shape_types[shape_b], shape_data[shape_b])       <L 24>
    var_27 = wp::address(var_shape_types, var_13);
    var_28 = wp::address(var_shape_data, var_13);
    var_30 = wp::load(var_27);
    var_31 = wp::load(var_28);
    var_29 = compute_effective_radius_0(var_30, var_31);
    // gap_sum = shape_gap[shape_a] + shape_gap[shape_b]                                      <L 25>
    var_32 = wp::address(var_shape_gap, var_11);
    var_33 = wp::address(var_shape_gap, var_13);
    var_35 = wp::load(var_32);
    var_36 = wp::load(var_33);
    var_34 = wp::add(var_35, var_36);
    // contact_data = ContactData()                                                           <L 27>
    var_37 = ContactData_40360d7c();
    // contact_data.contact_point_center = position                                           <L 28>
    var_37.contact_point_center = var_4;
    // contact_data.contact_normal_a_to_b = contact_normal                                    <L 29>
    var_37.contact_normal_a_to_b = var_5;
    // contact_data.contact_distance = depth                                                  <L 30>
    var_37.contact_distance = var_6;
    // contact_data.radius_eff_a = radius_eff_a                                               <L 31>
    var_37.radius_eff_a = var_24;
    // contact_data.radius_eff_b = radius_eff_b                                               <L 32>
    var_37.radius_eff_b = var_29;
    // contact_data.margin_a = margin_offset_a                                                <L 33>
    var_37.margin_a = var_16;
    // contact_data.margin_b = margin_offset_b                                                <L 34>
    var_37.margin_b = var_20;
    // contact_data.shape_a = shape_a                                                         <L 35>
    var_37.shape_a = var_11;
    // contact_data.shape_b = shape_b                                                         <L 36>
    var_37.shape_b = var_13;
    // contact_data.gap_sum = gap_sum                                                         <L 37>
    var_37.gap_sum = var_34;
    // contact_data.sort_sub_key = contact_fingerprints[contact_id]                           <L 38>
    var_38 = wp::address(var_contact_fingerprints, var_contact_id);
    var_40 = wp::load(var_38);
    var_39 = wp::copy(var_40);
    var_37.sort_sub_key = var_39;
    // writer_func(contact_data, writer_data, -1)                                             <L 39>
    write_contact_0(var_37, var_writer_data, var_41);
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:115
static CUDA_CALLABLE bool is_contact_already_exported_0(
    wp::int32 var_contact_id,
    wp::vec_t<7, wp::int32> var_exported_ids,
    wp::int32 var_num_exported)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    wp::int32 var_1;
    bool var_2;
    wp::int32 var_3;
    bool var_4;
    const bool var_5 = true;
    const wp::int32 var_6 = 1;
    wp::int32 var_7;
    const bool var_8 = false;
    //---------
    // forward
    // def is_contact_already_exported(                                                       <L 116>
    // j = int(0)                                                                             <L 131>
    var_1 = wp::int(var_0);
    // while j < num_exported:                                                                <L 132>
    start_while_0:;
    var_2 = (var_1 < var_num_exported);
    if ((var_2) == false) goto end_while_0;
        // if exported_ids[j] == contact_id:                                                  <L 133>
        var_3 = wp::extract(var_exported_ids, var_1);
        var_4 = (var_3 == var_contact_id);
        if (var_4) {
            // return True                                                                    <L 134>
            return var_5;
        }
        // j = j + 1                                                                          <L 135>
        var_7 = wp::add(var_1, var_6);
        wp::assign(var_1, var_7);
    goto start_while_0;
    end_while_0:;
    // return False                                                                           <L 136>
    return var_8;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:559
static CUDA_CALLABLE void adj__unpack_contact_id_det_0(
    wp::uint64 packed,
    wp::uint64 & adj_packed,
    wp::int32 & adj_ret)
{
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:435
static CUDA_CALLABLE void adj__unpack_contact_id_fast_0(
    wp::uint64 packed,
    wp::uint64 & adj_packed,
    wp::int32 & adj_ret)
{
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:614
static CUDA_CALLABLE void adj_unpack_contact_id_0(
    wp::uint64 var_packed,
    wp::int32 var_deterministic,
    wp::uint64 & adj_packed,
    wp::int32 & adj_deterministic,
    wp::int32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction.py:104
static CUDA_CALLABLE void adj_float_flip_0(
    wp::float32 f,
    wp::float32 & adj_f,
    wp::uint32 & adj_ret)
{
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:139
static CUDA_CALLABLE void adj__floats_are_near_ulps_0(
    wp::float32 var_a,
    wp::float32 var_b,
    wp::float32 & adj_a,
    wp::float32 & adj_b,
    bool & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:151
static CUDA_CALLABLE void adj__contacts_are_numerically_equivalent_0(
    wp::int32 var_contact_a,
    wp::int32 var_contact_b,
    wp::array_t<wp::vec_t<4, wp::float32>> var_position_depth,
    wp::array_t<wp::vec_t<2, wp::float32>> var_normal,
    wp::int32 & adj_contact_a,
    wp::int32 & adj_contact_b,
    wp::array_t<wp::vec_t<4, wp::float32>> & adj_position_depth,
    wp::array_t<wp::vec_t<2, wp::float32>> & adj_normal,
    bool & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:2088
static CUDA_CALLABLE void adj__roundoff_duplicate_bit_for_slot_pair_0(
    wp::int32 var_pair_idx,
    wp::int32 var_entry_idx,
    wp::int32 var_ht_capacity,
    wp::array_t<wp::uint64> var_ht_values,
    wp::array_t<wp::vec_t<4, wp::float32>> var_position_depth,
    wp::array_t<wp::vec_t<2, wp::float32>> var_normal,
    wp::array_t<wp::int32> var_contact_fingerprints,
    wp::int32 var_deterministic,
    wp::int32 & adj_pair_idx,
    wp::int32 & adj_entry_idx,
    wp::int32 & adj_ht_capacity,
    wp::array_t<wp::uint64> & adj_ht_values,
    wp::array_t<wp::vec_t<4, wp::float32>> & adj_position_depth,
    wp::array_t<wp::vec_t<2, wp::float32>> & adj_normal,
    wp::array_t<wp::int32> & adj_contact_fingerprints,
    wp::int32 & adj_deterministic,
    wp::int32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:660
static CUDA_CALLABLE void adj_decode_oct_0(
    wp::vec_t<2, wp::float32> var_e,
    wp::vec_t<2, wp::float32> & adj_e,
    wp::vec_t<3, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:2021
static CUDA_CALLABLE void adj_unpack_contact_0(
    wp::int32 var_contact_id,
    wp::array_t<wp::vec_t<4, wp::float32>> var_position_depth,
    wp::array_t<wp::vec_t<2, wp::float32>> var_normal,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::float32 & ret_2,
    wp::int32 & adj_contact_id,
    wp::array_t<wp::vec_t<4, wp::float32>> & adj_position_depth,
    wp::array_t<wp::vec_t<2, wp::float32>> & adj_normal,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1,
    wp::float32 & adj_ret_2)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:177
static CUDA_CALLABLE void adj_compute_effective_radius_0(
    wp::int32 var_shape_type,
    wp::vec_t<4, wp::float32> var_shape_scale,
    wp::int32 & adj_shape_type,
    wp::vec_t<4, wp::float32> & adj_shape_scale,
    wp::float32 & adj_ret)
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:0
static CUDA_CALLABLE void adj_create_export_reduced_contacts_kernel__locals__export_contact_id_0(
    wp::int32 var_contact_id,
    wp::array_t<wp::vec_t<4, wp::float32>> var_position_depth,
    wp::array_t<wp::vec_t<2, wp::float32>> var_normal,
    wp::array_t<wp::vec_t<2, wp::int32>> var_shape_pairs,
    wp::array_t<wp::int32> var_contact_fingerprints,
    wp::array_t<wp::int32> var_exported_flags,
    wp::array_t<wp::int32> var_shape_types,
    wp::array_t<wp::vec_t<4, wp::float32>> var_shape_data,
    wp::array_t<wp::float32> var_shape_gap,
    ContactWriterData_4222ebad var_writer_data,
    wp::int32 & adj_contact_id,
    wp::array_t<wp::vec_t<4, wp::float32>> & adj_position_depth,
    wp::array_t<wp::vec_t<2, wp::float32>> & adj_normal,
    wp::array_t<wp::vec_t<2, wp::int32>> & adj_shape_pairs,
    wp::array_t<wp::int32> & adj_contact_fingerprints,
    wp::array_t<wp::int32> & adj_exported_flags,
    wp::array_t<wp::int32> & adj_shape_types,
    wp::array_t<wp::vec_t<4, wp::float32>> & adj_shape_data,
    wp::array_t<wp::float32> & adj_shape_gap,
    ContactWriterData_4222ebad & adj_writer_data)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:115
static CUDA_CALLABLE void adj_is_contact_already_exported_0(
    wp::int32 var_contact_id,
    wp::vec_t<7, wp::int32> var_exported_ids,
    wp::int32 var_num_exported,
    wp::int32 & adj_contact_id,
    wp::vec_t<7, wp::int32> & adj_exported_ids,
    wp::int32 & adj_num_exported,
    bool & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}



extern "C" __global__ void create_export_reduced_contacts_kernel__locals__export_reduced_contacts_kernel_4848e044_cuda_kernel_forward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::uint64> var_ht_keys,
    wp::array_t<wp::uint64> var_ht_values,
    wp::array_t<wp::int32> var_ht_active_slots,
    wp::array_t<wp::vec_t<4, wp::float32>> var_position_depth,
    wp::array_t<wp::vec_t<2, wp::float32>> var_normal,
    wp::array_t<wp::vec_t<2, wp::int32>> var_shape_pairs,
    wp::array_t<wp::int32> var_contact_fingerprints,
    wp::array_t<wp::int32> var_exported_flags,
    wp::array_t<wp::int32> var_shape_types,
    wp::array_t<wp::vec_t<4, wp::float32>> var_shape_data,
    wp::array_t<wp::float32> var_shape_gap,
    ContactWriterData_4222ebad var_writer_data,
    wp::int32 var_total_num_blocks,
    wp::int32 var_parallel_pairs,
    wp::int32 var_deterministic)
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
        wp::shape_t* var_2;
        const wp::int32 var_3 = 0;
        wp::int32 var_4;
        wp::shape_t var_5;
        wp::int32* var_6;
        wp::int32 var_7;
        wp::int32 var_8;
        const wp::int32 var_9 = 32;
        const wp::str var_10 = "shared";
        wp::tile_shared_t<wp::int32,wp::tile_layout_strided_t<wp::tile_shape_t<32>, wp::tile_stride_t<1>>, true> var_11 = wp::tile_alloc_empty<wp::int32,wp::tile_shape_t<32>,wp::tile_stride_t<1>,false>();
        wp::range_t var_12;
        wp::int32 var_13;
        wp::int32* var_14;
        wp::int32 var_15;
        wp::int32 var_16;
        const wp::int32 var_17 = 0;
        wp::int32 var_18;
        const wp::int32 var_19 = 0;
        bool var_20;
        const wp::int32 var_21 = 21;
        bool var_22;
        wp::int32 var_23;
        wp::int32 var_24;
        const wp::int32 var_25 = 0;
        bool var_26;
        const wp::int32 var_27 = 21;
        wp::range_t var_28;
        wp::int32 var_29;
        wp::int32 var_30;
        wp::int32 var_31;
        wp::int32 var_32;
        const bool var_33 = true;
        wp::tile_shared_t<wp::int32,wp::tile_layout_strided_t<wp::tile_shape_t<1>, wp::tile_stride_t<1>>, true> var_34 = wp::tile_alloc_empty<wp::int32,wp::tile_shape_t<1>,wp::tile_stride_t<1>,false>();
        const wp::int32 var_35 = 0;
        wp::int32 var_36;
        bool var_37;
        const wp::int32 var_38 = 0;
        bool var_39;
        const wp::int32 var_40 = 0;
        bool var_41;
        bool var_42;
        const wp::int32 var_43 = 7;
        bool var_44;
        const wp::int32 var_45 = 1;
        wp::int32 var_46;
        wp::int32 var_47;
        const wp::int32 var_48 = 0;
        bool var_49;
        wp::int32 var_50;
        wp::int32 var_51;
        wp::uint64* var_52;
        wp::uint64 var_53;
        wp::uint64 var_54;
        wp::uint64 var_55;
        bool var_56;
        wp::int32 var_57;
        const wp::int32 var_58 = 0;
        bool var_59;
        const wp::int32 var_60 = 0;
        bool var_61;
        wp::vec_t<7, wp::int32> var_62;
        const wp::int32 var_63 = 0;
        wp::int32 var_64;
        const wp::int32 var_65 = 7;
        wp::range_t var_66;
        wp::int32 var_67;
        const wp::int32 var_68 = 1;
        wp::int32 var_69;
        wp::int32 var_70;
        const wp::int32 var_71 = 0;
        bool var_72;
        wp::int32 var_73;
        wp::int32 var_74;
        wp::uint64* var_75;
        wp::uint64 var_76;
        wp::uint64 var_77;
        wp::uint64 var_78;
        bool var_79;
        wp::int32 var_80;
        const wp::int32 var_81 = 0;
        bool var_82;
        bool var_83;
        const wp::int32 var_84 = 1;
        wp::int32 var_85;
        wp::uint64 var_86;
        wp::int32 var_87;
        const wp::int32 var_88 = 0;
        wp::int32 var_89;
        const bool var_90 = true;
        //---------
        // forward
        // def export_reduced_contacts_kernel(                                                    <L 1>
        // block_id, lane = wp.tid()                                                              <L 18>
        builtin_tid2d(var_0, var_1);
        // ht_capacity = ht_keys.shape[0]                                                         <L 19>
        var_2 = &(var_ht_keys.shape);
        var_5 = wp::load(var_2);
        var_4 = wp::extract(var_5, var_3);
        // num_active = ht_active_slots[ht_capacity]                                              <L 20>
        var_6 = wp::address(var_ht_active_slots, var_4);
        var_8 = wp::load(var_6);
        var_7 = wp::copy(var_8);
        // duplicate_bits = wp.tile_zeros(shape=wp.static(EXPORT_REDUCED_CONTACTS_BLOCK_DIM), dtype=int, storage="shared")       <L 21>
        var_11 = wp::tile_zeros<int, 32>();
        // for active_idx in range(block_id, num_active, total_num_blocks):                       <L 23>
        var_12 = wp::range(var_0, var_7, var_total_num_blocks);
        start_for_0:;
            if (iter_cmp(var_12) == 0) goto end_for_0;
            var_13 = wp::iter_next(var_12);
            // entry_idx = ht_active_slots[active_idx]                                            <L 24>
            var_14 = wp::address(var_ht_active_slots, var_13);
            var_16 = wp::load(var_14);
            var_15 = wp::copy(var_16);
            // duplicate_bit = int(0)                                                             <L 25>
            var_18 = wp::int(var_17);
            // if parallel_pairs != 0:                                                            <L 27>
            var_20 = (var_parallel_pairs != var_19);
            if (var_20) {
                // if lane < wp.static(PAIRS_PER_KEY):                                            <L 28>
                var_22 = (var_1 < var_21);
                if (var_22) {
                    // duplicate_bit = _roundoff_duplicate_bit_for_slot_pair(                     <L 29>
                    // lane,                                                                      <L 30>
                    // entry_idx,                                                                 <L 31>
                    // ht_capacity,                                                               <L 32>
                    // ht_values,                                                                 <L 33>
                    // position_depth,                                                            <L 34>
                    // normal,                                                                    <L 35>
                    // contact_fingerprints,                                                      <L 36>
                    // deterministic,                                                             <L 37>
                    var_23 = _roundoff_duplicate_bit_for_slot_pair_0(var_1, var_15, var_4, var_ht_values, var_position_depth, var_normal, var_contact_fingerprints, var_deterministic);
                }
                var_24 = wp::where(var_22, var_23, var_18);
            }
            if (!var_20) {
                // elif lane == 0:                                                                <L 39>
                var_26 = (var_1 == var_25);
                if (var_26) {
                    // for pair_idx in range(wp.static(PAIRS_PER_KEY)):                           <L 40>
                    var_28 = wp::range(var_27);
                    start_for_2:;
                        if (iter_cmp(var_28) == 0) goto end_for_2;
                        var_29 = wp::iter_next(var_28);
                        // duplicate_bit = duplicate_bit | _roundoff_duplicate_bit_for_slot_pair(       <L 41>
                        // pair_idx,                                                              <L 42>
                        // entry_idx,                                                             <L 43>
                        // ht_capacity,                                                           <L 44>
                        // ht_values,                                                             <L 45>
                        // position_depth,                                                        <L 46>
                        // normal,                                                                <L 47>
                        // contact_fingerprints,                                                  <L 48>
                        // deterministic,                                                         <L 49>
                        var_30 = _roundoff_duplicate_bit_for_slot_pair_0(var_29, var_15, var_4, var_ht_values, var_position_depth, var_normal, var_contact_fingerprints, var_deterministic);
                        var_31 = wp::bit_or(var_18, var_30);
                        wp::assign(var_18, var_31);
                        goto start_for_2;
                    end_for_2:;
                }
            }
            var_32 = wp::where(var_20, var_24, var_18);
            // wp.tile_scatter_masked(duplicate_bits, lane, duplicate_bit, True)                  <L 52>
            wp::tile_scatter_masked(var_11, var_1, var_32, var_33);
            // duplicate_mask = wp.tile_reduce(wp.bit_or, duplicate_bits)[0]                      <L 53>
            var_34 = wp::tile_reduce(wp::bit_or, var_11);
            var_36 = wp::tile_extract(var_34, var_35);
            // if parallel_pairs != 0 and deterministic == 0:                                     <L 55>
            var_39 = (var_parallel_pairs != var_38);
            var_37 = var_39;
            if (var_37) {
                var_41 = (var_deterministic == var_40);
                var_37 = var_37 && var_41;
            }
            if (var_37) {
                // if lane < wp.static(VALUES_PER_KEY) and duplicate_mask & (1 << lane) == 0:       <L 56>
                var_44 = (var_1 < var_43);
                var_42 = var_44;
                if (var_42) {
                    var_46 = wp::lshift(var_45, var_1);
                    var_47 = wp::bit_and(var_36, var_46);
                    var_49 = (var_47 == var_48);
                    var_42 = var_42 && var_49;
                }
                if (var_42) {
                    // value = ht_values[lane * ht_capacity + entry_idx]                          <L 57>
                    var_50 = wp::mul(var_1, var_4);
                    var_51 = wp::add(var_50, var_15);
                    var_52 = wp::address(var_ht_values, var_51);
                    var_54 = wp::load(var_52);
                    var_53 = wp::copy(var_54);
                    // if value != wp.uint64(0):                                                  <L 58>
                    var_55 = 0ull;
                    var_56 = (var_53 != var_55);
                    if (var_56) {
                        // contact_id = unpack_contact_id(value, deterministic)                   <L 59>
                        var_57 = unpack_contact_id_0(var_53, var_deterministic);
                        // if contact_id != 0:                                                    <L 60>
                        var_59 = (var_57 != var_58);
                        if (var_59) {
                            // export_contact_id(                                                 <L 61>
                            // contact_id,                                                        <L 62>
                            // position_depth,                                                    <L 63>
                            // normal,                                                            <L 64>
                            // shape_pairs,                                                       <L 65>
                            // contact_fingerprints,                                              <L 66>
                            // exported_flags,                                                    <L 67>
                            // shape_types,                                                       <L 68>
                            // shape_data,                                                        <L 69>
                            // shape_gap,                                                         <L 70>
                            // writer_data,                                                       <L 71>
                            create_export_reduced_contacts_kernel__locals__export_contact_id_0(var_57, var_position_depth, var_normal, var_shape_pairs, var_contact_fingerprints, var_exported_flags, var_shape_types, var_shape_data, var_shape_gap, var_writer_data);
                        }
                    }
                }
            }
            if (!var_37) {
                // elif lane == 0:                                                                <L 73>
                var_61 = (var_1 == var_60);
                if (var_61) {
                    // exported_ids = exported_ids_vec()                                          <L 74>
                    var_62 = wp::vec_t<7, wp::int32>();
                    // num_exported = int(0)                                                      <L 75>
                    var_64 = wp::int(var_63);
                    // for slot in range(wp.static(VALUES_PER_KEY)):                              <L 77>
                    var_66 = wp::range(var_65);
                    start_for_4:;
                        if (iter_cmp(var_66) == 0) goto end_for_4;
                        var_67 = wp::iter_next(var_66);
                        // if duplicate_mask & (1 << slot) != 0:                                  <L 78>
                        var_69 = wp::lshift(var_68, var_67);
                        var_70 = wp::bit_and(var_36, var_69);
                        var_72 = (var_70 != var_71);
                        if (var_72) {
                            // continue                                                           <L 79>
                            goto start_for_4;
                        }
                        // value = ht_values[slot * ht_capacity + entry_idx]                      <L 80>
                        var_73 = wp::mul(var_67, var_4);
                        var_74 = wp::add(var_73, var_15);
                        var_75 = wp::address(var_ht_values, var_74);
                        var_77 = wp::load(var_75);
                        var_76 = wp::copy(var_77);
                        // if value == wp.uint64(0):                                              <L 81>
                        var_78 = 0ull;
                        var_79 = (var_76 == var_78);
                        if (var_79) {
                            // continue                                                           <L 82>
                            goto start_for_4;
                        }
                        // contact_id = unpack_contact_id(value, deterministic)                   <L 84>
                        var_80 = unpack_contact_id_0(var_76, var_deterministic);
                        // if contact_id == 0:                                                    <L 85>
                        var_82 = (var_80 == var_81);
                        if (var_82) {
                            // continue                                                           <L 86>
                            goto start_for_4;
                        }
                        // if is_contact_already_exported(contact_id, exported_ids, num_exported):       <L 87>
                        var_83 = is_contact_already_exported_0(var_80, var_62, var_64);
                        if (var_83) {
                            // continue                                                           <L 88>
                            goto start_for_4;
                        }
                        // exported_ids[num_exported] = contact_id                                <L 89>
                        wp::assign_inplace(var_62, var_64, var_80);
                        // num_exported = num_exported + 1                                        <L 90>
                        var_85 = wp::add(var_64, var_84);
                        // export_contact_id(                                                     <L 92>
                        // contact_id,                                                            <L 93>
                        // position_depth,                                                        <L 94>
                        // normal,                                                                <L 95>
                        // shape_pairs,                                                           <L 96>
                        // contact_fingerprints,                                                  <L 97>
                        // exported_flags,                                                        <L 98>
                        // shape_types,                                                           <L 99>
                        // shape_data,                                                            <L 100>
                        // shape_gap,                                                             <L 101>
                        // writer_data,                                                           <L 102>
                        create_export_reduced_contacts_kernel__locals__export_contact_id_0(var_80, var_position_depth, var_normal, var_shape_pairs, var_contact_fingerprints, var_exported_flags, var_shape_types, var_shape_data, var_shape_gap, var_writer_data);
                        wp::assign(var_64, var_85);
                        goto start_for_4;
                    end_for_4:;
                }
            }
            var_86 = wp::where(var_37, var_53, var_76);
            var_87 = wp::where(var_37, var_57, var_80);
            // wp.tile_scatter_masked(duplicate_bits, lane, int(0), True)                         <L 107>
            var_89 = wp::int(var_88);
            wp::tile_scatter_masked(var_11, var_1, var_89, var_90);
            goto start_for_0;
        end_for_0:;
    }
}

