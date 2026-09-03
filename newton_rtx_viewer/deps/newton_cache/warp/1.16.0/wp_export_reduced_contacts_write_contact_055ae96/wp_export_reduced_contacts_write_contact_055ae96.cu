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




struct ContactWriterData_6ba3bf0a
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


    ContactWriterData_6ba3bf0a() = default;
    CUDA_CALLABLE ContactWriterData_6ba3bf0a(wp::int32 const& contact_max,
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
    wp::array_t<wp::int64> const& out_sort_key = {})
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

    {
    }

    CUDA_CALLABLE ContactWriterData_6ba3bf0a& operator += (const ContactWriterData_6ba3bf0a& rhs)
    {    contact_max += rhs.contact_max;

        return *this;}

};

static CUDA_CALLABLE void adj_ContactWriterData_6ba3bf0a(wp::int32 const&,
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
    ContactWriterData_6ba3bf0a & adj_ret)
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
}

// Required when compiling adjoints.
CUDA_CALLABLE ContactWriterData_6ba3bf0a add(const ContactWriterData_6ba3bf0a& a, const ContactWriterData_6ba3bf0a& b)
{
    return ContactWriterData_6ba3bf0a();
}

CUDA_CALLABLE void adj_atomic_add(ContactWriterData_6ba3bf0a* p, ContactWriterData_6ba3bf0a t)
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
}




// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:461
static CUDA_CALLABLE wp::int32 _unpack_contact_id_det_0(
    wp::uint64 packed)
{

return static_cast<int32_t>(packed & 0xFFFFFull);
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:337
static CUDA_CALLABLE wp::int32 _unpack_contact_id_fast_0(
    wp::uint64 packed)
{

return static_cast<int32_t>(packed & 0xFFFFFFFFull);
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:516
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
    // def unpack_contact_id(packed: wp.uint64, deterministic: int) -> int:                   <L 517>
    // if deterministic != 0:                                                                 <L 527>
    var_1 = (var_deterministic != var_0);
    if (var_1) {
        // return _unpack_contact_id_det(packed)                                              <L 528>
        var_2 = _unpack_contact_id_det_0(var_packed);
        return var_2;
    }
    // return _unpack_contact_id_fast(packed)                                                 <L 529>
    var_3 = _unpack_contact_id_fast_0(var_packed);
    return var_3;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:99
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
    // def is_contact_already_exported(                                                       <L 100>
    // j = int(0)                                                                             <L 115>
    var_1 = wp::int(var_0);
    // while j < num_exported:                                                                <L 116>
    start_while_0:;
    var_2 = (var_1 < var_num_exported);
    if ((var_2) == false) goto end_while_0;
        // if exported_ids[j] == contact_id:                                                  <L 117>
        var_3 = wp::extract(var_exported_ids, var_1);
        var_4 = (var_3 == var_contact_id);
        if (var_4) {
            // return True                                                                    <L 118>
            return var_5;
        }
        // j = j + 1                                                                          <L 119>
        var_7 = wp::add(var_1, var_6);
        wp::assign(var_1, var_7);
    goto start_while_0;
    end_while_0:;
    // return False                                                                           <L 120>
    return var_8;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:562
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
    // def decode_oct(e: wp.vec2) -> wp.vec3:                                                 <L 563>
    // nz = 1.0 - wp.abs(e[0]) - wp.abs(e[1])                                                 <L 568>
    var_2 = wp::extract(var_e, var_1);
    var_3 = wp::abs(var_2);
    var_4 = wp::sub(var_0, var_3);
    var_6 = wp::extract(var_e, var_5);
    var_7 = wp::abs(var_6);
    var_8 = wp::sub(var_4, var_7);
    // nx = e[0]                                                                              <L 569>
    var_10 = wp::extract(var_e, var_9);
    // ny = e[1]                                                                              <L 570>
    var_12 = wp::extract(var_e, var_11);
    // if nz < 0.0:                                                                           <L 572>
    var_14 = (var_8 < var_13);
    if (var_14) {
        // sign_x = 1.0                                                                       <L 573>
        // if nx < 0.0:                                                                       <L 574>
        var_17 = (var_10 < var_16);
        if (var_17) {
            // sign_x = -1.0                                                                  <L 575>
        }
        var_19 = wp::where(var_17, var_18, var_15);
        // sign_y = 1.0                                                                       <L 576>
        // if ny < 0.0:                                                                       <L 577>
        var_22 = (var_12 < var_21);
        if (var_22) {
            // sign_y = -1.0                                                                  <L 578>
        }
        var_24 = wp::where(var_22, var_23, var_20);
        // new_x = (1.0 - wp.abs(ny)) * sign_x                                                <L 579>
        var_26 = wp::abs(var_12);
        var_27 = wp::sub(var_25, var_26);
        var_28 = wp::mul(var_27, var_19);
        // new_y = (1.0 - wp.abs(nx)) * sign_y                                                <L 580>
        var_30 = wp::abs(var_10);
        var_31 = wp::sub(var_29, var_30);
        var_32 = wp::mul(var_31, var_24);
        // nx = new_x                                                                         <L 581>
        var_33 = wp::copy(var_28);
        // ny = new_y                                                                         <L 582>
        var_34 = wp::copy(var_32);
    }
    var_35 = wp::where(var_14, var_33, var_10);
    var_36 = wp::where(var_14, var_34, var_12);
    // return wp.normalize(wp.vec3(nx, ny, nz))                                               <L 584>
    var_37 = wp::vec_t<3, wp::float32>(var_35, var_36, var_8);
    var_38 = wp::normalize(var_37);
    return var_38;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:1480
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
    // def unpack_contact(                                                                    <L 1481>
    // pd = position_depth[contact_id]                                                        <L 1498>
    var_0 = wp::address(var_position_depth, var_contact_id);
    var_2 = wp::load(var_0);
    var_1 = wp::copy(var_2);
    // n = decode_oct(normal[contact_id])                                                     <L 1499>
    var_3 = wp::address(var_normal, var_contact_id);
    var_5 = wp::load(var_3);
    var_4 = decode_oct_0(var_5);
    // position = wp.vec3(pd[0], pd[1], pd[2])                                                <L 1501>
    var_7 = wp::extract(var_1, var_6);
    var_9 = wp::extract(var_1, var_8);
    var_11 = wp::extract(var_1, var_10);
    var_12 = wp::vec_t<3, wp::float32>(var_7, var_9, var_11);
    // depth = pd[3]                                                                          <L 1502>
    var_14 = wp::extract(var_1, var_13);
    // return position, n, depth                                                              <L 1504>
    ret_0 = var_12;
    ret_1 = var_4;
    ret_2 = var_14;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:123
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
    // def compute_effective_radius(shape_type: int, shape_scale: wp.vec4) -> float:          <L 124>
    // if shape_type == GeoType.SPHERE or shape_type == GeoType.CAPSULE:                      <L 137>
    var_2 = (var_shape_type == var_1);
    var_0 = var_2;
    if (!var_0) {
        var_4 = (var_shape_type == var_3);
        var_0 = var_0 || var_4;
    }
    if (var_0) {
        // return shape_scale[0]                                                              <L 138>
        var_6 = wp::extract(var_shape_scale, var_5);
        return var_6;
    }
    // return 0.0                                                                             <L 139>
    return var_7;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_data.py:59
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/sim/collide.py:78
static CUDA_CALLABLE void write_contact_0(
    ContactData_40360d7c var_contact_data,
    ContactWriterData_6ba3bf0a var_writer_data,
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
    wp::float32* var_11;
    wp::float32* var_12;
    wp::float32 var_13;
    wp::float32 var_14;
    wp::float32 var_15;
    wp::float32* var_16;
    wp::float32* var_17;
    wp::float32 var_18;
    wp::float32 var_19;
    wp::float32 var_20;
    wp::vec_t<3, wp::float32>* var_21;
    wp::vec_t<3, wp::float32> var_22;
    wp::vec_t<3, wp::float32> var_23;
    wp::vec_t<3, wp::float32>* var_24;
    const wp::float32 var_25 = 0.5;
    wp::float32* var_26;
    wp::float32 var_27;
    wp::float32 var_28;
    wp::float32* var_29;
    wp::float32 var_30;
    wp::float32 var_31;
    wp::vec_t<3, wp::float32> var_32;
    wp::vec_t<3, wp::float32> var_33;
    wp::vec_t<3, wp::float32> var_34;
    wp::vec_t<3, wp::float32>* var_35;
    const wp::float32 var_36 = 0.5;
    wp::float32* var_37;
    wp::float32 var_38;
    wp::float32 var_39;
    wp::float32* var_40;
    wp::float32 var_41;
    wp::float32 var_42;
    wp::vec_t<3, wp::float32> var_43;
    wp::vec_t<3, wp::float32> var_44;
    wp::vec_t<3, wp::float32> var_45;
    wp::vec_t<3, wp::float32> var_46;
    wp::float32 var_47;
    wp::float32 var_48;
    wp::array_t<wp::float32>* var_49;
    wp::int32* var_50;
    wp::float32* var_51;
    wp::array_t<wp::float32> var_52;
    wp::int32 var_53;
    wp::float32 var_54;
    wp::float32 var_55;
    wp::array_t<wp::float32>* var_56;
    wp::int32* var_57;
    wp::float32* var_58;
    wp::array_t<wp::float32> var_59;
    wp::int32 var_60;
    wp::float32 var_61;
    wp::float32 var_62;
    wp::float32 var_63;
    wp::int32 var_64;
    const wp::int32 var_65 = 0;
    bool var_66;
    bool var_67;
    wp::array_t<wp::int32>* var_68;
    const wp::int32 var_69 = 0;
    const wp::int32 var_70 = 1;
    wp::int32 var_71;
    wp::array_t<wp::int32> var_72;
    wp::int32 var_73;
    wp::int32* var_74;
    bool var_75;
    wp::int32 var_76;
    wp::int32* var_77;
    wp::array_t<wp::int32>* var_78;
    wp::array_t<wp::int32> var_79;
    wp::int32 var_80;
    wp::int32* var_81;
    wp::array_t<wp::int32>* var_82;
    wp::array_t<wp::int32> var_83;
    wp::int32 var_84;
    wp::array_t<wp::int32>* var_85;
    wp::int32* var_86;
    wp::int32* var_87;
    wp::array_t<wp::int32> var_88;
    wp::int32 var_89;
    wp::int32 var_90;
    wp::int32 var_91;
    wp::array_t<wp::int32>* var_92;
    wp::int32* var_93;
    wp::int32* var_94;
    wp::array_t<wp::int32> var_95;
    wp::int32 var_96;
    wp::int32 var_97;
    wp::int32 var_98;
    const wp::int32 var_99 = -1;
    bool var_100;
    wp::transform_t<wp::float32> var_101;
    wp::array_t<wp::transform_t<wp::float32>>* var_102;
    wp::transform_t<wp::float32>* var_103;
    wp::array_t<wp::transform_t<wp::float32>> var_104;
    wp::transform_t<wp::float32> var_105;
    wp::transform_t<wp::float32> var_106;
    wp::transform_t<wp::float32> var_107;
    const wp::int32 var_108 = -1;
    bool var_109;
    wp::transform_t<wp::float32> var_110;
    wp::array_t<wp::transform_t<wp::float32>>* var_111;
    wp::transform_t<wp::float32>* var_112;
    wp::array_t<wp::transform_t<wp::float32>> var_113;
    wp::transform_t<wp::float32> var_114;
    wp::transform_t<wp::float32> var_115;
    wp::transform_t<wp::float32> var_116;
    wp::vec_t<3, wp::float32> var_117;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_118;
    wp::array_t<wp::vec_t<3, wp::float32>> var_119;
    wp::vec_t<3, wp::float32> var_120;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_121;
    wp::array_t<wp::vec_t<3, wp::float32>> var_122;
    wp::vec_t<3, wp::float32> var_123;
    wp::vec_t<3, wp::float32> var_124;
    wp::vec_t<3, wp::float32> var_125;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_126;
    wp::array_t<wp::vec_t<3, wp::float32>> var_127;
    wp::float32 var_128;
    wp::vec_t<3, wp::float32> var_129;
    wp::vec_t<3, wp::float32> var_130;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_131;
    wp::array_t<wp::vec_t<3, wp::float32>> var_132;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_133;
    wp::array_t<wp::vec_t<3, wp::float32>> var_134;
    wp::array_t<wp::float32>* var_135;
    wp::array_t<wp::float32> var_136;
    wp::array_t<wp::float32>* var_137;
    wp::array_t<wp::float32> var_138;
    const wp::int32 var_139 = 0;
    wp::array_t<wp::int32>* var_140;
    wp::array_t<wp::int32> var_141;
    wp::array_t<wp::float32>* var_142;
    wp::shape_t* var_143;
    const wp::int32 var_144 = 0;
    wp::int32 var_145;
    wp::shape_t var_146;
    const wp::int32 var_147 = 0;
    bool var_148;
    wp::float32* var_149;
    wp::array_t<wp::float32>* var_150;
    wp::array_t<wp::float32> var_151;
    wp::float32 var_152;
    wp::float32* var_153;
    wp::array_t<wp::float32>* var_154;
    wp::array_t<wp::float32> var_155;
    wp::float32 var_156;
    wp::float32* var_157;
    wp::array_t<wp::float32>* var_158;
    wp::array_t<wp::float32> var_159;
    wp::float32 var_160;
    wp::array_t<wp::int64>* var_161;
    wp::shape_t* var_162;
    const wp::int32 var_163 = 0;
    wp::int32 var_164;
    wp::shape_t var_165;
    const wp::int32 var_166 = 0;
    bool var_167;
    wp::int32* var_168;
    wp::int32* var_169;
    wp::int32* var_170;
    wp::int64 var_171;
    wp::int32 var_172;
    wp::int32 var_173;
    wp::int32 var_174;
    wp::array_t<wp::int64>* var_175;
    wp::array_t<wp::int64> var_176;
    //---------
    // forward
    // def write_contact(                                                                     <L 79>
    // total_separation_needed = (                                                            <L 92>
    // contact_data.radius_eff_a + contact_data.radius_eff_b + contact_data.margin_a + contact_data.margin_b       <L 93>
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
    // offset_mag_a = contact_data.radius_eff_a + contact_data.margin_a                       <L 96>
    var_11 = &((var_contact_data).radius_eff_a);
    var_12 = &((var_contact_data).margin_a);
    var_14 = wp::load(var_11);
    var_15 = wp::load(var_12);
    var_13 = wp::add(var_14, var_15);
    // offset_mag_b = contact_data.radius_eff_b + contact_data.margin_b                       <L 97>
    var_16 = &((var_contact_data).radius_eff_b);
    var_17 = &((var_contact_data).margin_b);
    var_19 = wp::load(var_16);
    var_20 = wp::load(var_17);
    var_18 = wp::add(var_19, var_20);
    // contact_normal_a_to_b = wp.normalize(contact_data.contact_normal_a_to_b)               <L 100>
    var_21 = &((var_contact_data).contact_normal_a_to_b);
    var_23 = wp::load(var_21);
    var_22 = wp::normalize(var_23);
    // a_contact_world = contact_data.contact_point_center - contact_normal_a_to_b * (        <L 102>
    var_24 = &((var_contact_data).contact_point_center);
    // 0.5 * contact_data.contact_distance + contact_data.radius_eff_a                        <L 103>
    var_26 = &((var_contact_data).contact_distance);
    var_28 = wp::load(var_26);
    var_27 = wp::mul(var_25, var_28);
    var_29 = &((var_contact_data).radius_eff_a);
    var_31 = wp::load(var_29);
    var_30 = wp::add(var_27, var_31);
    var_32 = wp::mul(var_22, var_30);
    var_34 = wp::load(var_24);
    var_33 = wp::sub(var_34, var_32);
    // b_contact_world = contact_data.contact_point_center + contact_normal_a_to_b * (        <L 105>
    var_35 = &((var_contact_data).contact_point_center);
    // 0.5 * contact_data.contact_distance + contact_data.radius_eff_b                        <L 106>
    var_37 = &((var_contact_data).contact_distance);
    var_39 = wp::load(var_37);
    var_38 = wp::mul(var_36, var_39);
    var_40 = &((var_contact_data).radius_eff_b);
    var_42 = wp::load(var_40);
    var_41 = wp::add(var_38, var_42);
    var_43 = wp::mul(var_22, var_41);
    var_45 = wp::load(var_35);
    var_44 = wp::add(var_45, var_43);
    // diff = b_contact_world - a_contact_world                                               <L 109>
    var_46 = wp::sub(var_44, var_33);
    // distance = wp.dot(diff, contact_normal_a_to_b)                                         <L 110>
    var_47 = wp::dot(var_46, var_22);
    // d = distance - total_separation_needed                                                 <L 111>
    var_48 = wp::sub(var_47, var_9);
    // gap_a = writer_data.shape_gap[contact_data.shape_a]                                    <L 114>
    var_49 = &((var_writer_data).shape_gap);
    var_50 = &((var_contact_data).shape_a);
    var_52 = wp::load(var_49);
    var_53 = wp::load(var_50);
    var_51 = wp::address(var_52, var_53);
    var_55 = wp::load(var_51);
    var_54 = wp::copy(var_55);
    // gap_b = writer_data.shape_gap[contact_data.shape_b]                                    <L 115>
    var_56 = &((var_writer_data).shape_gap);
    var_57 = &((var_contact_data).shape_b);
    var_59 = wp::load(var_56);
    var_60 = wp::load(var_57);
    var_58 = wp::address(var_59, var_60);
    var_62 = wp::load(var_58);
    var_61 = wp::copy(var_62);
    // contact_gap = gap_a + gap_b                                                            <L 116>
    var_63 = wp::add(var_54, var_61);
    // index = output_index                                                                   <L 118>
    var_64 = wp::copy(var_output_index);
    // if index < 0:                                                                          <L 120>
    var_66 = (var_64 < var_65);
    if (var_66) {
        // if d > contact_gap:                                                                <L 122>
        var_67 = (var_48 > var_63);
        if (var_67) {
            // return                                                                         <L 123>
            return;
        }
        // index = wp.atomic_add(writer_data.contact_count, 0, 1)                             <L 124>
        var_68 = &((var_writer_data).contact_count);
        var_72 = wp::load(var_68);
        var_71 = wp::atomic_add(var_72, var_69, var_70);
    }
    var_73 = wp::where(var_66, var_71, var_64);
    // if index >= writer_data.contact_max:                                                   <L 125>
    var_74 = &((var_writer_data).contact_max);
    var_76 = wp::load(var_74);
    var_75 = (var_73 >= var_76);
    if (var_75) {
        // return                                                                             <L 126>
        return;
    }
    // writer_data.out_shape0[index] = contact_data.shape_a                                   <L 128>
    var_77 = &((var_contact_data).shape_a);
    var_78 = &((var_writer_data).out_shape0);
    var_79 = wp::load(var_78);
    var_80 = wp::load(var_77);
    wp::array_store(var_79, var_73, var_80);
    // writer_data.out_shape1[index] = contact_data.shape_b                                   <L 129>
    var_81 = &((var_contact_data).shape_b);
    var_82 = &((var_writer_data).out_shape1);
    var_83 = wp::load(var_82);
    var_84 = wp::load(var_81);
    wp::array_store(var_83, var_73, var_84);
    // body0 = writer_data.shape_body[contact_data.shape_a]                                   <L 132>
    var_85 = &((var_writer_data).shape_body);
    var_86 = &((var_contact_data).shape_a);
    var_88 = wp::load(var_85);
    var_89 = wp::load(var_86);
    var_87 = wp::address(var_88, var_89);
    var_91 = wp::load(var_87);
    var_90 = wp::copy(var_91);
    // body1 = writer_data.shape_body[contact_data.shape_b]                                   <L 133>
    var_92 = &((var_writer_data).shape_body);
    var_93 = &((var_contact_data).shape_b);
    var_95 = wp::load(var_92);
    var_96 = wp::load(var_93);
    var_94 = wp::address(var_95, var_96);
    var_98 = wp::load(var_94);
    var_97 = wp::copy(var_98);
    // X_bw_a = wp.transform_identity() if body0 == -1 else wp.transform_inverse(writer_data.body_q[body0])       <L 136>
    var_100 = (var_90 == var_99);
    if (var_100) {
        var_101 = wp::transform_identity<wp::float32>();
    }
    if (!var_100) {
        var_102 = &((var_writer_data).body_q);
        var_104 = wp::load(var_102);
        var_103 = wp::address(var_104, var_90);
        var_106 = wp::load(var_103);
        var_105 = wp::transform_inverse(var_106);
    }
    var_107 = wp::where(var_100, var_101, var_105);
    // X_bw_b = wp.transform_identity() if body1 == -1 else wp.transform_inverse(writer_data.body_q[body1])       <L 137>
    var_109 = (var_97 == var_108);
    if (var_109) {
        var_110 = wp::transform_identity<wp::float32>();
    }
    if (!var_109) {
        var_111 = &((var_writer_data).body_q);
        var_113 = wp::load(var_111);
        var_112 = wp::address(var_113, var_97);
        var_115 = wp::load(var_112);
        var_114 = wp::transform_inverse(var_115);
    }
    var_116 = wp::where(var_109, var_110, var_114);
    // writer_data.out_point0[index] = wp.transform_point(X_bw_a, a_contact_world)            <L 140>
    var_117 = wp::transform_point(var_107, var_33);
    var_118 = &((var_writer_data).out_point0);
    var_119 = wp::load(var_118);
    wp::array_store(var_119, var_73, var_117);
    // writer_data.out_point1[index] = wp.transform_point(X_bw_b, b_contact_world)            <L 141>
    var_120 = wp::transform_point(var_116, var_44);
    var_121 = &((var_writer_data).out_point1);
    var_122 = wp::load(var_121);
    wp::array_store(var_122, var_73, var_120);
    // contact_normal = contact_normal_a_to_b                                                 <L 143>
    var_123 = wp::copy(var_22);
    // writer_data.out_offset0[index] = wp.transform_vector(X_bw_a, offset_mag_a * contact_normal)       <L 146>
    var_124 = wp::mul(var_13, var_123);
    var_125 = wp::transform_vector(var_107, var_124);
    var_126 = &((var_writer_data).out_offset0);
    var_127 = wp::load(var_126);
    wp::array_store(var_127, var_73, var_125);
    // writer_data.out_offset1[index] = wp.transform_vector(X_bw_b, -offset_mag_b * contact_normal)       <L 147>
    var_128 = wp::neg(var_18);
    var_129 = wp::mul(var_128, var_123);
    var_130 = wp::transform_vector(var_116, var_129);
    var_131 = &((var_writer_data).out_offset1);
    var_132 = wp::load(var_131);
    wp::array_store(var_132, var_73, var_130);
    // writer_data.out_normal[index] = contact_normal                                         <L 149>
    var_133 = &((var_writer_data).out_normal);
    var_134 = wp::load(var_133);
    wp::array_store(var_134, var_73, var_123);
    // writer_data.out_margin0[index] = offset_mag_a                                          <L 150>
    var_135 = &((var_writer_data).out_margin0);
    var_136 = wp::load(var_135);
    wp::array_store(var_136, var_73, var_13);
    // writer_data.out_margin1[index] = offset_mag_b                                          <L 151>
    var_137 = &((var_writer_data).out_margin1);
    var_138 = wp::load(var_137);
    wp::array_store(var_138, var_73, var_18);
    // writer_data.out_tids[index] = 0  # tid not available in this context                   <L 152>
    var_140 = &((var_writer_data).out_tids);
    var_141 = wp::load(var_140);
    wp::array_store(var_141, var_73, var_139);
    // if writer_data.out_stiffness.shape[0] > 0:                                             <L 155>
    var_142 = &((var_writer_data).out_stiffness);
    var_143 = &(var_142->shape);
    var_146 = wp::load(var_143);
    var_145 = wp::extract(var_146, var_144);
    var_148 = (var_145 > var_147);
    if (var_148) {
        // writer_data.out_stiffness[index] = contact_data.contact_stiffness                  <L 156>
        var_149 = &((var_contact_data).contact_stiffness);
        var_150 = &((var_writer_data).out_stiffness);
        var_151 = wp::load(var_150);
        var_152 = wp::load(var_149);
        wp::array_store(var_151, var_73, var_152);
        // writer_data.out_damping[index] = contact_data.contact_damping                      <L 157>
        var_153 = &((var_contact_data).contact_damping);
        var_154 = &((var_writer_data).out_damping);
        var_155 = wp::load(var_154);
        var_156 = wp::load(var_153);
        wp::array_store(var_155, var_73, var_156);
        // writer_data.out_friction[index] = contact_data.contact_friction_scale              <L 158>
        var_157 = &((var_contact_data).contact_friction_scale);
        var_158 = &((var_writer_data).out_friction);
        var_159 = wp::load(var_158);
        var_160 = wp::load(var_157);
        wp::array_store(var_159, var_73, var_160);
    }
    // if writer_data.out_sort_key.shape[0] > 0:                                              <L 160>
    var_161 = &((var_writer_data).out_sort_key);
    var_162 = &(var_161->shape);
    var_165 = wp::load(var_162);
    var_164 = wp::extract(var_165, var_163);
    var_167 = (var_164 > var_166);
    if (var_167) {
        // writer_data.out_sort_key[index] = make_contact_sort_key(                           <L 161>
        // contact_data.shape_a, contact_data.shape_b, contact_data.sort_sub_key              <L 162>
        var_168 = &((var_contact_data).shape_a);
        var_169 = &((var_contact_data).shape_b);
        var_170 = &((var_contact_data).sort_sub_key);
        var_172 = wp::load(var_168);
        var_173 = wp::load(var_169);
        var_174 = wp::load(var_170);
        var_171 = make_contact_sort_key_0(var_172, var_173, var_174);
        // writer_data.out_sort_key[index] = make_contact_sort_key(                           <L 161>
        var_175 = &((var_writer_data).out_sort_key);
        var_176 = wp::load(var_175);
        wp::array_store(var_176, var_73, var_171);
    }
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:461
static CUDA_CALLABLE void adj__unpack_contact_id_det_0(
    wp::uint64 packed,
    wp::uint64 & adj_packed,
    wp::int32 & adj_ret)
{
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:337
static CUDA_CALLABLE void adj__unpack_contact_id_fast_0(
    wp::uint64 packed,
    wp::uint64 & adj_packed,
    wp::int32 & adj_ret)
{
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:516
static CUDA_CALLABLE void adj_unpack_contact_id_0(
    wp::uint64 var_packed,
    wp::int32 var_deterministic,
    wp::uint64 & adj_packed,
    wp::int32 & adj_deterministic,
    wp::int32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:99
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:562
static CUDA_CALLABLE void adj_decode_oct_0(
    wp::vec_t<2, wp::float32> var_e,
    wp::vec_t<2, wp::float32> & adj_e,
    wp::vec_t<3, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:1480
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:123
static CUDA_CALLABLE void adj_compute_effective_radius_0(
    wp::int32 var_shape_type,
    wp::vec_t<4, wp::float32> var_shape_scale,
    wp::int32 & adj_shape_type,
    wp::vec_t<4, wp::float32> & adj_shape_scale,
    wp::float32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_data.py:59
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/sim/collide.py:78
static CUDA_CALLABLE void adj_write_contact_0(
    ContactData_40360d7c var_contact_data,
    ContactWriterData_6ba3bf0a var_writer_data,
    wp::int32 var_output_index,
    ContactData_40360d7c & adj_contact_data,
    ContactWriterData_6ba3bf0a & adj_writer_data,
    wp::int32 & adj_output_index)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}



extern "C" __global__ void create_export_reduced_contacts_kernel__locals__export_reduced_contacts_kernel_5ba2e084_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
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
    ContactWriterData_6ba3bf0a var_writer_data,
    wp::int32 var_total_num_threads,
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
        wp::shape_t* var_1;
        const wp::int32 var_2 = 0;
        wp::int32 var_3;
        wp::shape_t var_4;
        wp::int32* var_5;
        wp::int32 var_6;
        wp::int32 var_7;
        const wp::int32 var_8 = 0;
        bool var_9;
        wp::range_t var_10;
        wp::int32 var_11;
        wp::int32* var_12;
        wp::int32 var_13;
        wp::int32 var_14;
        wp::vec_t<7, wp::int32> var_15;
        const wp::int32 var_16 = 0;
        wp::int32 var_17;
        const wp::int32 var_18 = 7;
        wp::range_t var_19;
        wp::int32 var_20;
        wp::int32 var_21;
        wp::int32 var_22;
        wp::uint64* var_23;
        wp::uint64 var_24;
        wp::uint64 var_25;
        wp::uint64 var_26;
        bool var_27;
        wp::int32 var_28;
        bool var_29;
        const wp::int32 var_30 = 1;
        wp::int32 var_31;
        const wp::int32 var_32 = 1;
        wp::int32 var_33;
        const wp::int32 var_34 = 0;
        bool var_35;
        wp::int32 var_36;
        wp::vec_t<3, wp::float32> var_37;
        wp::vec_t<3, wp::float32> var_38;
        wp::float32 var_39;
        wp::vec_t<2, wp::int32>* var_40;
        wp::vec_t<2, wp::int32> var_41;
        wp::vec_t<2, wp::int32> var_42;
        const wp::int32 var_43 = 0;
        wp::int32 var_44;
        const wp::int32 var_45 = 1;
        wp::int32 var_46;
        wp::vec_t<4, wp::float32>* var_47;
        const wp::int32 var_48 = 3;
        wp::float32 var_49;
        wp::vec_t<4, wp::float32> var_50;
        wp::vec_t<4, wp::float32>* var_51;
        const wp::int32 var_52 = 3;
        wp::float32 var_53;
        wp::vec_t<4, wp::float32> var_54;
        wp::int32* var_55;
        wp::vec_t<4, wp::float32>* var_56;
        wp::float32 var_57;
        wp::int32 var_58;
        wp::vec_t<4, wp::float32> var_59;
        wp::int32* var_60;
        wp::vec_t<4, wp::float32>* var_61;
        wp::float32 var_62;
        wp::int32 var_63;
        wp::vec_t<4, wp::float32> var_64;
        wp::float32* var_65;
        wp::float32 var_66;
        wp::float32 var_67;
        wp::float32* var_68;
        wp::float32 var_69;
        wp::float32 var_70;
        wp::float32 var_71;
        ContactData_40360d7c var_72;
        wp::int32* var_73;
        wp::int32 var_74;
        wp::int32 var_75;
        const wp::int32 var_76 = -1;
        //---------
        // forward
        // def export_reduced_contacts_kernel(                                                    <L 1>
        // tid = wp.tid()                                                                         <L 32>
        var_0 = builtin_tid1d();
        // ht_capacity = ht_keys.shape[0]                                                         <L 35>
        var_1 = &(var_ht_keys.shape);
        var_4 = wp::load(var_1);
        var_3 = wp::extract(var_4, var_2);
        // num_active = ht_active_slots[ht_capacity]                                              <L 36>
        var_5 = wp::address(var_ht_active_slots, var_3);
        var_7 = wp::load(var_5);
        var_6 = wp::copy(var_7);
        // if num_active == 0:                                                                    <L 39>
        var_9 = (var_6 == var_8);
        if (var_9) {
            // return                                                                             <L 40>
            continue;
        }
        // for i in range(tid, num_active, total_num_threads):                                    <L 43>
        var_10 = wp::range(var_0, var_6, var_total_num_threads);
        start_for_1:;
            if (iter_cmp(var_10) == 0) goto end_for_1;
            var_11 = wp::iter_next(var_10);
            // entry_idx = ht_active_slots[i]                                                     <L 45>
            var_12 = wp::address(var_ht_active_slots, var_11);
            var_14 = wp::load(var_12);
            var_13 = wp::copy(var_14);
            // exported_ids = exported_ids_vec()                                                  <L 48>
            var_15 = wp::vec_t<7, wp::int32>();
            // num_exported = int(0)                                                              <L 49>
            var_17 = wp::int(var_16);
            // for slot in range(wp.static(VALUES_PER_KEY)):                                      <L 52>
            var_19 = wp::range(var_18);
            start_for_3:;
                if (iter_cmp(var_19) == 0) goto end_for_3;
                var_20 = wp::iter_next(var_19);
                // value = ht_values[slot * ht_capacity + entry_idx]                              <L 53>
                var_21 = wp::mul(var_20, var_3);
                var_22 = wp::add(var_21, var_13);
                var_23 = wp::address(var_ht_values, var_22);
                var_25 = wp::load(var_23);
                var_24 = wp::copy(var_25);
                // if value == wp.uint64(0):                                                      <L 56>
                var_26 = 0ull;
                var_27 = (var_24 == var_26);
                if (var_27) {
                    // continue                                                                   <L 57>
                    goto start_for_3;
                }
                // contact_id = unpack_contact_id(value, deterministic)                           <L 60>
                var_28 = unpack_contact_id_0(var_24, var_deterministic);
                // if is_contact_already_exported(contact_id, exported_ids, num_exported):        <L 63>
                var_29 = is_contact_already_exported_0(var_28, var_15, var_17);
                if (var_29) {
                    // continue                                                                   <L 64>
                    goto start_for_3;
                }
                // exported_ids[num_exported] = contact_id                                        <L 67>
                wp::assign_inplace(var_15, var_17, var_28);
                // num_exported = num_exported + 1                                                <L 68>
                var_31 = wp::add(var_17, var_30);
                // old_flag = wp.atomic_add(exported_flags, contact_id, 1)                        <L 72>
                var_33 = wp::atomic_add(var_exported_flags, var_28, var_32);
                // if old_flag > 0:                                                               <L 73>
                var_35 = (var_33 > var_34);
                if (var_35) {
                    // continue                                                                   <L 74>
                    wp::assign(var_17, var_31);
                    goto start_for_3;
                }
                var_36 = wp::where(var_35, var_17, var_31);
                // position, contact_normal, depth = unpack_contact(contact_id, position_depth, normal)       <L 77>
                unpack_contact_0(var_28, var_position_depth, var_normal, var_37, var_38, var_39);
                // pair = shape_pairs[contact_id]                                                 <L 80>
                var_40 = wp::address(var_shape_pairs, var_28);
                var_42 = wp::load(var_40);
                var_41 = wp::copy(var_42);
                // shape_a = pair[0]                                                              <L 81>
                var_44 = wp::extract(var_41, var_43);
                // shape_b = pair[1]                                                              <L 82>
                var_46 = wp::extract(var_41, var_45);
                // margin_offset_a = shape_data[shape_a][3]                                       <L 85>
                var_47 = wp::address(var_shape_data, var_44);
                var_50 = wp::load(var_47);
                var_49 = wp::extract(var_50, var_48);
                // margin_offset_b = shape_data[shape_b][3]                                       <L 86>
                var_51 = wp::address(var_shape_data, var_46);
                var_54 = wp::load(var_51);
                var_53 = wp::extract(var_54, var_52);
                // radius_eff_a = compute_effective_radius(shape_types[shape_a], shape_data[shape_a])       <L 89>
                var_55 = wp::address(var_shape_types, var_44);
                var_56 = wp::address(var_shape_data, var_44);
                var_58 = wp::load(var_55);
                var_59 = wp::load(var_56);
                var_57 = compute_effective_radius_0(var_58, var_59);
                // radius_eff_b = compute_effective_radius(shape_types[shape_b], shape_data[shape_b])       <L 90>
                var_60 = wp::address(var_shape_types, var_46);
                var_61 = wp::address(var_shape_data, var_46);
                var_63 = wp::load(var_60);
                var_64 = wp::load(var_61);
                var_62 = compute_effective_radius_0(var_63, var_64);
                // gap_a = shape_gap[shape_a]                                                     <L 93>
                var_65 = wp::address(var_shape_gap, var_44);
                var_67 = wp::load(var_65);
                var_66 = wp::copy(var_67);
                // gap_b = shape_gap[shape_b]                                                     <L 94>
                var_68 = wp::address(var_shape_gap, var_46);
                var_70 = wp::load(var_68);
                var_69 = wp::copy(var_70);
                // gap_sum = gap_a + gap_b                                                        <L 95>
                var_71 = wp::add(var_66, var_69);
                // contact_data = ContactData()                                                   <L 98>
                var_72 = ContactData_40360d7c();
                // contact_data.contact_point_center = position                                   <L 99>
                var_72.contact_point_center = var_37;
                // contact_data.contact_normal_a_to_b = contact_normal                            <L 100>
                var_72.contact_normal_a_to_b = var_38;
                // contact_data.contact_distance = depth                                          <L 101>
                var_72.contact_distance = var_39;
                // contact_data.radius_eff_a = radius_eff_a                                       <L 102>
                var_72.radius_eff_a = var_57;
                // contact_data.radius_eff_b = radius_eff_b                                       <L 103>
                var_72.radius_eff_b = var_62;
                // contact_data.margin_a = margin_offset_a                                        <L 104>
                var_72.margin_a = var_49;
                // contact_data.margin_b = margin_offset_b                                        <L 105>
                var_72.margin_b = var_53;
                // contact_data.shape_a = shape_a                                                 <L 106>
                var_72.shape_a = var_44;
                // contact_data.shape_b = shape_b                                                 <L 107>
                var_72.shape_b = var_46;
                // contact_data.gap_sum = gap_sum                                                 <L 108>
                var_72.gap_sum = var_71;
                // contact_data.sort_sub_key = contact_fingerprints[contact_id]                   <L 109>
                var_73 = wp::address(var_contact_fingerprints, var_28);
                var_75 = wp::load(var_73);
                var_74 = wp::copy(var_75);
                var_72.sort_sub_key = var_74;
                // writer_func(contact_data, writer_data, -1)                                     <L 112>
                write_contact_0(var_72, var_writer_data, var_76);
                wp::assign(var_17, var_36);
                goto start_for_3;
            end_for_3:;
            goto start_for_1;
        end_for_1:;
    }
}

