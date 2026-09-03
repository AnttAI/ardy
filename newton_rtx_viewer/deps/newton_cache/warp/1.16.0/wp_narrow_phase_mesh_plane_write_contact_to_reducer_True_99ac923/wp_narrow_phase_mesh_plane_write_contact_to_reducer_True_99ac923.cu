#define WP_NO_BFLOAT16

#define WP_TILE_BLOCK_DIM 512
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




struct GlobalContactReducerData_0c09c456
{
    wp::array_t<wp::vec_t<4, wp::float32>> position_depth;
    wp::array_t<wp::vec_t<2, wp::float32>> normal;
    wp::array_t<wp::vec_t<2, wp::int32>> shape_pairs;
    wp::array_t<wp::int32> contact_count;
    wp::array_t<wp::int32> exported_flags;
    wp::array_t<wp::uint32> reclaimed_contact_bits;
    wp::array_t<wp::int32> reclaimed_contact_cursor;
    wp::int32 capacity;
    wp::array_t<wp::int32> contact_fingerprints;
    wp::array_t<wp::float32> contact_area;
    wp::array_t<wp::int32> contact_nbin_entry;
    wp::array_t<wp::vec_t<3, wp::float32>> agg_force;
    wp::array_t<wp::vec_t<3, wp::float32>> agg_depth_volume;
    wp::array_t<wp::vec_t<3, wp::float32>> weighted_pos_sum;
    wp::array_t<wp::float32> weight_sum;
    wp::array_t<wp::float32> total_depth_reduced;
    wp::array_t<wp::vec_t<3, wp::float32>> total_normal_reduced;
    wp::array_t<wp::uint64> ht_keys;
    wp::array_t<wp::uint64> ht_values;
    wp::array_t<wp::int32> ht_active_slots;
    wp::array_t<wp::int32> ht_insert_failures;
    wp::int32 ht_capacity;
    wp::int32 ht_values_per_key;
    wp::int32 deterministic;


    GlobalContactReducerData_0c09c456() = default;
    CUDA_CALLABLE GlobalContactReducerData_0c09c456(wp::array_t<wp::vec_t<4, wp::float32>> const& position_depth,
    wp::array_t<wp::vec_t<2, wp::float32>> const& normal = {},
    wp::array_t<wp::vec_t<2, wp::int32>> const& shape_pairs = {},
    wp::array_t<wp::int32> const& contact_count = {},
    wp::array_t<wp::int32> const& exported_flags = {},
    wp::array_t<wp::uint32> const& reclaimed_contact_bits = {},
    wp::array_t<wp::int32> const& reclaimed_contact_cursor = {},
    wp::int32 const& capacity = {},
    wp::array_t<wp::int32> const& contact_fingerprints = {},
    wp::array_t<wp::float32> const& contact_area = {},
    wp::array_t<wp::int32> const& contact_nbin_entry = {},
    wp::array_t<wp::vec_t<3, wp::float32>> const& agg_force = {},
    wp::array_t<wp::vec_t<3, wp::float32>> const& agg_depth_volume = {},
    wp::array_t<wp::vec_t<3, wp::float32>> const& weighted_pos_sum = {},
    wp::array_t<wp::float32> const& weight_sum = {},
    wp::array_t<wp::float32> const& total_depth_reduced = {},
    wp::array_t<wp::vec_t<3, wp::float32>> const& total_normal_reduced = {},
    wp::array_t<wp::uint64> const& ht_keys = {},
    wp::array_t<wp::uint64> const& ht_values = {},
    wp::array_t<wp::int32> const& ht_active_slots = {},
    wp::array_t<wp::int32> const& ht_insert_failures = {},
    wp::int32 const& ht_capacity = {},
    wp::int32 const& ht_values_per_key = {},
    wp::int32 const& deterministic = {})
        : position_depth{position_depth}
        , normal{normal}
        , shape_pairs{shape_pairs}
        , contact_count{contact_count}
        , exported_flags{exported_flags}
        , reclaimed_contact_bits{reclaimed_contact_bits}
        , reclaimed_contact_cursor{reclaimed_contact_cursor}
        , capacity{capacity}
        , contact_fingerprints{contact_fingerprints}
        , contact_area{contact_area}
        , contact_nbin_entry{contact_nbin_entry}
        , agg_force{agg_force}
        , agg_depth_volume{agg_depth_volume}
        , weighted_pos_sum{weighted_pos_sum}
        , weight_sum{weight_sum}
        , total_depth_reduced{total_depth_reduced}
        , total_normal_reduced{total_normal_reduced}
        , ht_keys{ht_keys}
        , ht_values{ht_values}
        , ht_active_slots{ht_active_slots}
        , ht_insert_failures{ht_insert_failures}
        , ht_capacity{ht_capacity}
        , ht_values_per_key{ht_values_per_key}
        , deterministic{deterministic}

    {
    }

    CUDA_CALLABLE GlobalContactReducerData_0c09c456& operator += (const GlobalContactReducerData_0c09c456& rhs)
    {    capacity += rhs.capacity;
    ht_capacity += rhs.ht_capacity;
    ht_values_per_key += rhs.ht_values_per_key;
    deterministic += rhs.deterministic;

        return *this;}

};

static CUDA_CALLABLE void adj_GlobalContactReducerData_0c09c456(wp::array_t<wp::vec_t<4, wp::float32>> const&,
    wp::array_t<wp::vec_t<2, wp::float32>> const&,
    wp::array_t<wp::vec_t<2, wp::int32>> const&,
    wp::array_t<wp::int32> const&,
    wp::array_t<wp::int32> const&,
    wp::array_t<wp::uint32> const&,
    wp::array_t<wp::int32> const&,
    wp::int32 const&,
    wp::array_t<wp::int32> const&,
    wp::array_t<wp::float32> const&,
    wp::array_t<wp::int32> const&,
    wp::array_t<wp::vec_t<3, wp::float32>> const&,
    wp::array_t<wp::vec_t<3, wp::float32>> const&,
    wp::array_t<wp::vec_t<3, wp::float32>> const&,
    wp::array_t<wp::float32> const&,
    wp::array_t<wp::float32> const&,
    wp::array_t<wp::vec_t<3, wp::float32>> const&,
    wp::array_t<wp::uint64> const&,
    wp::array_t<wp::uint64> const&,
    wp::array_t<wp::int32> const&,
    wp::array_t<wp::int32> const&,
    wp::int32 const&,
    wp::int32 const&,
    wp::int32 const&,
    wp::array_t<wp::vec_t<4, wp::float32>> & adj_position_depth,
    wp::array_t<wp::vec_t<2, wp::float32>> & adj_normal,
    wp::array_t<wp::vec_t<2, wp::int32>> & adj_shape_pairs,
    wp::array_t<wp::int32> & adj_contact_count,
    wp::array_t<wp::int32> & adj_exported_flags,
    wp::array_t<wp::uint32> & adj_reclaimed_contact_bits,
    wp::array_t<wp::int32> & adj_reclaimed_contact_cursor,
    wp::int32 & adj_capacity,
    wp::array_t<wp::int32> & adj_contact_fingerprints,
    wp::array_t<wp::float32> & adj_contact_area,
    wp::array_t<wp::int32> & adj_contact_nbin_entry,
    wp::array_t<wp::vec_t<3, wp::float32>> & adj_agg_force,
    wp::array_t<wp::vec_t<3, wp::float32>> & adj_agg_depth_volume,
    wp::array_t<wp::vec_t<3, wp::float32>> & adj_weighted_pos_sum,
    wp::array_t<wp::float32> & adj_weight_sum,
    wp::array_t<wp::float32> & adj_total_depth_reduced,
    wp::array_t<wp::vec_t<3, wp::float32>> & adj_total_normal_reduced,
    wp::array_t<wp::uint64> & adj_ht_keys,
    wp::array_t<wp::uint64> & adj_ht_values,
    wp::array_t<wp::int32> & adj_ht_active_slots,
    wp::array_t<wp::int32> & adj_ht_insert_failures,
    wp::int32 & adj_ht_capacity,
    wp::int32 & adj_ht_values_per_key,
    wp::int32 & adj_deterministic,
    GlobalContactReducerData_0c09c456 & adj_ret)
{
    adj_position_depth = adj_ret.position_depth;
    adj_normal = adj_ret.normal;
    adj_shape_pairs = adj_ret.shape_pairs;
    adj_contact_count = adj_ret.contact_count;
    adj_exported_flags = adj_ret.exported_flags;
    adj_reclaimed_contact_bits = adj_ret.reclaimed_contact_bits;
    adj_reclaimed_contact_cursor = adj_ret.reclaimed_contact_cursor;
    adj_capacity += adj_ret.capacity;
    adj_contact_fingerprints = adj_ret.contact_fingerprints;
    adj_contact_area = adj_ret.contact_area;
    adj_contact_nbin_entry = adj_ret.contact_nbin_entry;
    adj_agg_force = adj_ret.agg_force;
    adj_agg_depth_volume = adj_ret.agg_depth_volume;
    adj_weighted_pos_sum = adj_ret.weighted_pos_sum;
    adj_weight_sum = adj_ret.weight_sum;
    adj_total_depth_reduced = adj_ret.total_depth_reduced;
    adj_total_normal_reduced = adj_ret.total_normal_reduced;
    adj_ht_keys = adj_ret.ht_keys;
    adj_ht_values = adj_ret.ht_values;
    adj_ht_active_slots = adj_ret.ht_active_slots;
    adj_ht_insert_failures = adj_ret.ht_insert_failures;
    adj_ht_capacity += adj_ret.ht_capacity;
    adj_ht_values_per_key += adj_ret.ht_values_per_key;
    adj_deterministic += adj_ret.deterministic;
}

// Required when compiling adjoints.
CUDA_CALLABLE GlobalContactReducerData_0c09c456 add(const GlobalContactReducerData_0c09c456& a, const GlobalContactReducerData_0c09c456& b)
{
    return GlobalContactReducerData_0c09c456();
}

CUDA_CALLABLE void adj_atomic_add(GlobalContactReducerData_0c09c456* p, GlobalContactReducerData_0c09c456 t)
{
    wp::adj_atomic_add(&p->position_depth, t.position_depth);
    wp::adj_atomic_add(&p->normal, t.normal);
    wp::adj_atomic_add(&p->shape_pairs, t.shape_pairs);
    wp::adj_atomic_add(&p->contact_count, t.contact_count);
    wp::adj_atomic_add(&p->exported_flags, t.exported_flags);
    wp::adj_atomic_add(&p->reclaimed_contact_bits, t.reclaimed_contact_bits);
    wp::adj_atomic_add(&p->reclaimed_contact_cursor, t.reclaimed_contact_cursor);
    wp::adj_atomic_add(&p->capacity, t.capacity);
    wp::adj_atomic_add(&p->contact_fingerprints, t.contact_fingerprints);
    wp::adj_atomic_add(&p->contact_area, t.contact_area);
    wp::adj_atomic_add(&p->contact_nbin_entry, t.contact_nbin_entry);
    wp::adj_atomic_add(&p->agg_force, t.agg_force);
    wp::adj_atomic_add(&p->agg_depth_volume, t.agg_depth_volume);
    wp::adj_atomic_add(&p->weighted_pos_sum, t.weighted_pos_sum);
    wp::adj_atomic_add(&p->weight_sum, t.weight_sum);
    wp::adj_atomic_add(&p->total_depth_reduced, t.total_depth_reduced);
    wp::adj_atomic_add(&p->total_normal_reduced, t.total_normal_reduced);
    wp::adj_atomic_add(&p->ht_keys, t.ht_keys);
    wp::adj_atomic_add(&p->ht_values, t.ht_values);
    wp::adj_atomic_add(&p->ht_active_slots, t.ht_active_slots);
    wp::adj_atomic_add(&p->ht_insert_failures, t.ht_insert_failures);
    wp::adj_atomic_add(&p->ht_capacity, t.ht_capacity);
    wp::adj_atomic_add(&p->ht_values_per_key, t.ht_values_per_key);
    wp::adj_atomic_add(&p->deterministic, t.deterministic);
}




// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:1158
static CUDA_CALLABLE wp::int32 _pop_reclaimed_contact_id_0(
    GlobalContactReducerData_0c09c456 var_reducer_data)
{
    //---------
    // primal vars
    wp::array_t<wp::uint32>* var_0;
    wp::shape_t* var_1;
    const wp::int32 var_2 = 0;
    wp::int32 var_3;
    wp::shape_t var_4;
    const wp::int32 var_5 = 0;
    bool var_6;
    const wp::int32 var_7 = 0;
    wp::array_t<wp::uint32>* var_8;
    wp::shape_t* var_9;
    const wp::int32 var_10 = 0;
    wp::int32 var_11;
    wp::shape_t var_12;
    wp::array_t<wp::int32>* var_13;
    const wp::int32 var_14 = 0;
    const wp::int32 var_15 = 1;
    wp::int32 var_16;
    wp::array_t<wp::int32> var_17;
    wp::int32 var_18;
    const wp::int32 var_19 = 0;
    wp::int32 var_20;
    bool var_21;
    wp::int32 var_22;
    wp::int32 var_23;
    wp::array_t<wp::uint32>* var_24;
    const wp::int32 var_25 = 0;
    wp::uint32 var_26;
    wp::uint32 var_27;
    wp::array_t<wp::uint32> var_28;
    const wp::int32 var_29 = 0;
    wp::int32 var_30;
    const wp::int32 var_31 = 32;
    bool var_32;
    const wp::int32 var_33 = 1;
    wp::uint32 var_34;
    wp::uint32 var_35;
    wp::uint32 var_36;
    wp::uint32 var_37;
    const wp::int32 var_38 = 0;
    wp::uint32 var_39;
    bool var_40;
    wp::uint32 var_41;
    wp::array_t<wp::uint32>* var_42;
    wp::uint32 var_43;
    wp::array_t<wp::uint32> var_44;
    wp::uint32 var_45;
    const wp::int32 var_46 = 0;
    wp::uint32 var_47;
    bool var_48;
    const wp::int32 var_49 = 32;
    wp::int32 var_50;
    wp::int32 var_51;
    const wp::int32 var_52 = 1;
    wp::int32 var_53;
    const wp::int32 var_54 = 1;
    wp::int32 var_55;
    const wp::int32 var_56 = 0;
    //---------
    // forward
    // def _pop_reclaimed_contact_id(reducer_data: GlobalContactReducerData) -> int:          <L 1159>
    // if reducer_data.reclaimed_contact_bits.shape[0] == 0:                                  <L 1161>
    var_0 = &((var_reducer_data).reclaimed_contact_bits);
    var_1 = &(var_0->shape);
    var_4 = wp::load(var_1);
    var_3 = wp::extract(var_4, var_2);
    var_6 = (var_3 == var_5);
    if (var_6) {
        // return 0                                                                           <L 1162>
        return var_7;
    }
    // word_count = reducer_data.reclaimed_contact_bits.shape[0]                              <L 1164>
    var_8 = &((var_reducer_data).reclaimed_contact_bits);
    var_9 = &(var_8->shape);
    var_12 = wp::load(var_9);
    var_11 = wp::extract(var_12, var_10);
    // start = wp.atomic_add(reducer_data.reclaimed_contact_cursor, 0, 1) % word_count        <L 1165>
    var_13 = &((var_reducer_data).reclaimed_contact_cursor);
    var_17 = wp::load(var_13);
    var_16 = wp::atomic_add(var_17, var_14, var_15);
    var_18 = wp::mod(var_16, var_11);
    // offset = int(0)                                                                        <L 1166>
    var_20 = wp::int(var_19);
    // while offset < word_count:                                                             <L 1167>
    start_while_1:;
    var_21 = (var_20 < var_11);
    if ((var_21) == false) goto end_while_1;
        // word = (start + offset) % word_count                                               <L 1168>
        var_22 = wp::add(var_18, var_20);
        var_23 = wp::mod(var_22, var_11);
        // bits = wp.atomic_or(reducer_data.reclaimed_contact_bits, word, wp.uint32(0))       <L 1169>
        var_24 = &((var_reducer_data).reclaimed_contact_bits);
        var_26 = wp::uint32(var_25);
        var_28 = wp::load(var_24);
        var_27 = wp::atomic_or(var_28, var_23, var_26);
        // bit = int(0)                                                                       <L 1170>
        var_30 = wp::int(var_29);
        // while bit < 32:                                                                    <L 1171>
    start_while_3:;
        var_32 = (var_30 < var_31);
    if ((var_32) == false) goto end_while_3;
            // mask = wp.uint32(1) << wp.uint32(bit)                                          <L 1172>
            var_34 = wp::uint32(var_33);
            var_35 = wp::uint32(var_30);
            var_36 = wp::lshift(var_34, var_35);
            // if bits & mask != wp.uint32(0):                                                <L 1173>
            var_37 = wp::bit_and(var_27, var_36);
            var_39 = wp::uint32(var_38);
            var_40 = (var_37 != var_39);
            if (var_40) {
                // keep_mask = ~mask                                                          <L 1174>
                var_41 = wp::invert(var_36);
                // old_bits = wp.atomic_and(reducer_data.reclaimed_contact_bits, word, keep_mask)       <L 1175>
                var_42 = &((var_reducer_data).reclaimed_contact_bits);
                var_44 = wp::load(var_42);
                var_43 = wp::atomic_and(var_44, var_23, var_41);
                // if old_bits & mask != wp.uint32(0):                                        <L 1176>
                var_45 = wp::bit_and(var_43, var_36);
                var_47 = wp::uint32(var_46);
                var_48 = (var_45 != var_47);
                if (var_48) {
                    // return word * 32 + bit                                                 <L 1177>
                    var_50 = wp::mul(var_23, var_49);
                    var_51 = wp::add(var_50, var_30);
                    return var_51;
                }
            }
            // bit += 1                                                                       <L 1178>
            var_53 = wp::add(var_30, var_52);
            wp::assign(var_30, var_53);
    goto start_while_3;
    end_while_3:;
        // offset += 1                                                                        <L 1179>
        var_55 = wp::add(var_20, var_54);
        wp::assign(var_20, var_55);
    goto start_while_1;
    end_while_1:;
    // return 0                                                                               <L 1180>
    return var_56;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:630
static CUDA_CALLABLE wp::vec_t<2, wp::float32> encode_oct_0(
    wp::vec_t<3, wp::float32> var_n)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    wp::float32 var_1;
    wp::float32 var_2;
    const wp::int32 var_3 = 1;
    wp::float32 var_4;
    wp::float32 var_5;
    wp::float32 var_6;
    const wp::int32 var_7 = 2;
    wp::float32 var_8;
    wp::float32 var_9;
    wp::float32 var_10;
    const wp::float32 var_11 = 1e-20;
    bool var_12;
    const wp::float32 var_13 = 0.0;
    const wp::float32 var_14 = 0.0;
    wp::vec_t<2, wp::float32> var_15;
    const wp::float32 var_16 = 1.0;
    wp::float32 var_17;
    const wp::int32 var_18 = 0;
    wp::float32 var_19;
    wp::float32 var_20;
    const wp::int32 var_21 = 1;
    wp::float32 var_22;
    wp::float32 var_23;
    const wp::int32 var_24 = 2;
    wp::float32 var_25;
    wp::float32 var_26;
    const wp::float32 var_27 = 0.0;
    bool var_28;
    const wp::float32 var_29 = 1.0;
    const wp::float32 var_30 = 0.0;
    bool var_31;
    const wp::float32 var_32 = -1.0;
    wp::float32 var_33;
    const wp::float32 var_34 = 1.0;
    const wp::float32 var_35 = 0.0;
    bool var_36;
    const wp::float32 var_37 = -1.0;
    wp::float32 var_38;
    const wp::float32 var_39 = 1.0;
    wp::float32 var_40;
    wp::float32 var_41;
    wp::float32 var_42;
    const wp::float32 var_43 = 1.0;
    wp::float32 var_44;
    wp::float32 var_45;
    wp::float32 var_46;
    wp::float32 var_47;
    wp::float32 var_48;
    wp::float32 var_49;
    wp::float32 var_50;
    wp::vec_t<2, wp::float32> var_51;
    //---------
    // forward
    // def encode_oct(n: wp.vec3) -> wp.vec2:                                                 <L 631>
    // l1 = wp.abs(n[0]) + wp.abs(n[1]) + wp.abs(n[2])                                        <L 637>
    var_1 = wp::extract(var_n, var_0);
    var_2 = wp::abs(var_1);
    var_4 = wp::extract(var_n, var_3);
    var_5 = wp::abs(var_4);
    var_6 = wp::add(var_2, var_5);
    var_8 = wp::extract(var_n, var_7);
    var_9 = wp::abs(var_8);
    var_10 = wp::add(var_6, var_9);
    // if l1 < 1.0e-20:                                                                       <L 638>
    var_12 = (var_10 < var_11);
    if (var_12) {
        // return wp.vec2(0.0, 0.0)                                                           <L 639>
        var_15 = wp::vec_t<2, wp::float32>(var_13, var_14);
        return var_15;
    }
    // inv_l1 = 1.0 / l1                                                                      <L 640>
    var_17 = wp::div(var_16, var_10);
    // ox = n[0] * inv_l1                                                                     <L 641>
    var_19 = wp::extract(var_n, var_18);
    var_20 = wp::mul(var_19, var_17);
    // oy = n[1] * inv_l1                                                                     <L 642>
    var_22 = wp::extract(var_n, var_21);
    var_23 = wp::mul(var_22, var_17);
    // oz = n[2] * inv_l1                                                                     <L 643>
    var_25 = wp::extract(var_n, var_24);
    var_26 = wp::mul(var_25, var_17);
    // if oz < 0.0:                                                                           <L 645>
    var_28 = (var_26 < var_27);
    if (var_28) {
        // sign_x = 1.0                                                                       <L 646>
        // if ox < 0.0:                                                                       <L 647>
        var_31 = (var_20 < var_30);
        if (var_31) {
            // sign_x = -1.0                                                                  <L 648>
        }
        var_33 = wp::where(var_31, var_32, var_29);
        // sign_y = 1.0                                                                       <L 649>
        // if oy < 0.0:                                                                       <L 650>
        var_36 = (var_23 < var_35);
        if (var_36) {
            // sign_y = -1.0                                                                  <L 651>
        }
        var_38 = wp::where(var_36, var_37, var_34);
        // new_x = (1.0 - wp.abs(oy)) * sign_x                                                <L 652>
        var_40 = wp::abs(var_23);
        var_41 = wp::sub(var_39, var_40);
        var_42 = wp::mul(var_41, var_33);
        // new_y = (1.0 - wp.abs(ox)) * sign_y                                                <L 653>
        var_44 = wp::abs(var_20);
        var_45 = wp::sub(var_43, var_44);
        var_46 = wp::mul(var_45, var_38);
        // ox = new_x                                                                         <L 654>
        var_47 = wp::copy(var_42);
        // oy = new_y                                                                         <L 655>
        var_48 = wp::copy(var_46);
    }
    var_49 = wp::where(var_28, var_47, var_20);
    var_50 = wp::where(var_28, var_48, var_23);
    // return wp.vec2(ox, oy)                                                                 <L 657>
    var_51 = wp::vec_t<2, wp::float32>(var_49, var_50);
    return var_51;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:1183
static CUDA_CALLABLE wp::int32 export_contact_to_buffer_0(
    wp::int32 var_shape_a,
    wp::int32 var_shape_b,
    wp::vec_t<3, wp::float32> var_position,
    wp::vec_t<3, wp::float32> var_normal,
    wp::float32 var_depth,
    wp::int32 var_fingerprint,
    GlobalContactReducerData_0c09c456 var_reducer_data)
{
    //---------
    // primal vars
    wp::array_t<wp::int32>* var_0;
    const wp::int32 var_1 = 0;
    const wp::int32 var_2 = 1;
    wp::int32 var_3;
    wp::array_t<wp::int32> var_4;
    wp::int32* var_5;
    bool var_6;
    wp::int32 var_7;
    const wp::int32 var_8 = 1;
    wp::int32 var_9;
    const wp::int32 var_10 = 0;
    wp::int32 var_11;
    wp::array_t<wp::uint32>* var_12;
    wp::shape_t* var_13;
    const wp::int32 var_14 = 0;
    wp::int32 var_15;
    wp::shape_t var_16;
    const wp::int32 var_17 = 0;
    bool var_18;
    wp::int32 var_19;
    wp::int32 var_20;
    const wp::int32 var_21 = 0;
    bool var_22;
    wp::array_t<wp::int32>* var_23;
    const wp::int32 var_24 = 0;
    const wp::int32 var_25 = -1;
    wp::int32 var_26;
    wp::array_t<wp::int32> var_27;
    const wp::int32 var_28 = -1;
    wp::array_t<wp::int32>* var_29;
    const wp::int32 var_30 = 0;
    const wp::int32 var_31 = -1;
    wp::int32 var_32;
    wp::array_t<wp::int32> var_33;
    wp::int32 var_34;
    wp::array_t<wp::int32>* var_35;
    wp::shape_t* var_36;
    const wp::int32 var_37 = 0;
    wp::int32 var_38;
    wp::shape_t var_39;
    const wp::int32 var_40 = 0;
    bool var_41;
    const wp::int32 var_42 = 0;
    wp::array_t<wp::int32>* var_43;
    wp::array_t<wp::int32> var_44;
    const wp::int32 var_45 = 0;
    wp::float32 var_46;
    const wp::int32 var_47 = 1;
    wp::float32 var_48;
    const wp::int32 var_49 = 2;
    wp::float32 var_50;
    wp::vec_t<4, wp::float32> var_51;
    wp::array_t<wp::vec_t<4, wp::float32>>* var_52;
    wp::array_t<wp::vec_t<4, wp::float32>> var_53;
    wp::vec_t<2, wp::float32> var_54;
    wp::array_t<wp::vec_t<2, wp::float32>>* var_55;
    wp::array_t<wp::vec_t<2, wp::float32>> var_56;
    wp::vec_t<2, wp::int32> var_57;
    wp::array_t<wp::vec_t<2, wp::int32>>* var_58;
    wp::array_t<wp::vec_t<2, wp::int32>> var_59;
    wp::array_t<wp::int32>* var_60;
    wp::array_t<wp::int32> var_61;
    //---------
    // forward
    // def export_contact_to_buffer(                                                          <L 1184>
    // buffer_idx = wp.atomic_add(reducer_data.contact_count, 0, 1)                           <L 1210>
    var_0 = &((var_reducer_data).contact_count);
    var_4 = wp::load(var_0);
    var_3 = wp::atomic_add(var_4, var_1, var_2);
    // if buffer_idx < reducer_data.capacity:                                                 <L 1211>
    var_5 = &((var_reducer_data).capacity);
    var_7 = wp::load(var_5);
    var_6 = (var_3 < var_7);
    if (var_6) {
        // contact_id = buffer_idx + 1  # ID zero is reserved for provisional winners.        <L 1212>
        var_9 = wp::add(var_3, var_8);
    }
    if (!var_6) {
        // contact_id = int(0)                                                                <L 1214>
        var_11 = wp::int(var_10);
        // if reducer_data.reclaimed_contact_bits.shape[0] > 0:                               <L 1215>
        var_12 = &((var_reducer_data).reclaimed_contact_bits);
        var_13 = &(var_12->shape);
        var_16 = wp::load(var_13);
        var_15 = wp::extract(var_16, var_14);
        var_18 = (var_15 > var_17);
        if (var_18) {
            // contact_id = _pop_reclaimed_contact_id(reducer_data)                           <L 1216>
            var_19 = _pop_reclaimed_contact_id_0(var_reducer_data);
        }
        var_20 = wp::where(var_18, var_19, var_11);
        // if contact_id == 0:                                                                <L 1217>
        var_22 = (var_20 == var_21);
        if (var_22) {
            // wp.atomic_add(reducer_data.contact_count, 0, -1)                               <L 1219>
            var_23 = &((var_reducer_data).contact_count);
            var_27 = wp::load(var_23);
            var_26 = wp::atomic_add(var_27, var_24, var_25);
            // return -1                                                                      <L 1220>
            return var_28;
        }
        // wp.atomic_add(reducer_data.contact_count, 0, -1)                                   <L 1222>
        var_29 = &((var_reducer_data).contact_count);
        var_33 = wp::load(var_29);
        var_32 = wp::atomic_add(var_33, var_30, var_31);
    }
    var_34 = wp::where(var_6, var_9, var_20);
    // if reducer_data.exported_flags.shape[0] > 0:                                           <L 1223>
    var_35 = &((var_reducer_data).exported_flags);
    var_36 = &(var_35->shape);
    var_39 = wp::load(var_36);
    var_38 = wp::extract(var_39, var_37);
    var_41 = (var_38 > var_40);
    if (var_41) {
        // reducer_data.exported_flags[contact_id] = 0                                        <L 1224>
        var_43 = &((var_reducer_data).exported_flags);
        var_44 = wp::load(var_43);
        wp::array_store(var_44, var_34, var_42);
    }
    // reducer_data.position_depth[contact_id] = wp.vec4(position[0], position[1], position[2], depth)       <L 1227>
    var_46 = wp::extract(var_position, var_45);
    var_48 = wp::extract(var_position, var_47);
    var_50 = wp::extract(var_position, var_49);
    var_51 = wp::vec_t<4, wp::float32>(var_46, var_48, var_50, var_depth);
    var_52 = &((var_reducer_data).position_depth);
    var_53 = wp::load(var_52);
    wp::array_store(var_53, var_34, var_51);
    // reducer_data.normal[contact_id] = encode_oct(normal)                                   <L 1228>
    var_54 = encode_oct_0(var_normal);
    var_55 = &((var_reducer_data).normal);
    var_56 = wp::load(var_55);
    wp::array_store(var_56, var_34, var_54);
    // reducer_data.shape_pairs[contact_id] = wp.vec2i(shape_a, shape_b)                      <L 1229>
    var_57 = wp::vec_t<2, wp::int32>(var_shape_a, var_shape_b);
    var_58 = &((var_reducer_data).shape_pairs);
    var_59 = wp::load(var_58);
    wp::array_store(var_59, var_34, var_57);
    // reducer_data.contact_fingerprints[contact_id] = fingerprint                            <L 1230>
    var_60 = &((var_reducer_data).contact_fingerprints);
    var_61 = wp::load(var_60);
    wp::array_store(var_61, var_34, var_fingerprint);
    // return contact_id                                                                      <L 1232>
    return var_34;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:0
static CUDA_CALLABLE void write_contact_to_reducer_0(
    ContactData_40360d7c var_contact_data,
    GlobalContactReducerData_0c09c456 var_reducer_data,
    wp::int32 var_output_index)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32>* var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::vec_t<3, wp::float32>* var_3;
    wp::vec_t<3, wp::float32> var_4;
    wp::vec_t<3, wp::float32> var_5;
    wp::float32* var_6;
    wp::float32 var_7;
    wp::float32 var_8;
    wp::int32* var_9;
    wp::int32 var_10;
    wp::int32 var_11;
    wp::int32* var_12;
    wp::int32 var_13;
    wp::int32 var_14;
    wp::int32* var_15;
    wp::int32 var_16;
    wp::int32 var_17;
    //---------
    // forward
    // def write_contact_to_reducer(                                                          <L 1>
    // position = contact_data.contact_point_center                                           <L 21>
    var_0 = &((var_contact_data).contact_point_center);
    var_2 = wp::load(var_0);
    var_1 = wp::copy(var_2);
    // normal = contact_data.contact_normal_a_to_b                                            <L 22>
    var_3 = &((var_contact_data).contact_normal_a_to_b);
    var_5 = wp::load(var_3);
    var_4 = wp::copy(var_5);
    // depth = contact_data.contact_distance                                                  <L 23>
    var_6 = &((var_contact_data).contact_distance);
    var_8 = wp::load(var_6);
    var_7 = wp::copy(var_8);
    // shape_a = contact_data.shape_a                                                         <L 24>
    var_9 = &((var_contact_data).shape_a);
    var_11 = wp::load(var_9);
    var_10 = wp::copy(var_11);
    // shape_b = contact_data.shape_b                                                         <L 25>
    var_12 = &((var_contact_data).shape_b);
    var_14 = wp::load(var_12);
    var_13 = wp::copy(var_14);
    // export_contact_to_buffer(                                                              <L 29>
    // shape_a=shape_a,                                                                       <L 30>
    // shape_b=shape_b,                                                                       <L 31>
    // position=position,                                                                     <L 32>
    // normal=normal,                                                                         <L 33>
    // depth=depth,                                                                           <L 34>
    // fingerprint=contact_data.sort_sub_key,                                                 <L 35>
    var_15 = &((var_contact_data).sort_sub_key);
    // reducer_data=reducer_data,                                                             <L 36>
    var_17 = wp::load(var_15);
    var_16 = export_contact_to_buffer_0(var_10, var_13, var_1, var_4, var_7, var_17, var_reducer_data);
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:1158
static CUDA_CALLABLE void adj__pop_reclaimed_contact_id_0(
    GlobalContactReducerData_0c09c456 var_reducer_data,
    GlobalContactReducerData_0c09c456 & adj_reducer_data,
    wp::int32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:630
static CUDA_CALLABLE void adj_encode_oct_0(
    wp::vec_t<3, wp::float32> var_n,
    wp::vec_t<3, wp::float32> & adj_n,
    wp::vec_t<2, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:1183
static CUDA_CALLABLE void adj_export_contact_to_buffer_0(
    wp::int32 var_shape_a,
    wp::int32 var_shape_b,
    wp::vec_t<3, wp::float32> var_position,
    wp::vec_t<3, wp::float32> var_normal,
    wp::float32 var_depth,
    wp::int32 var_fingerprint,
    GlobalContactReducerData_0c09c456 var_reducer_data,
    wp::int32 & adj_shape_a,
    wp::int32 & adj_shape_b,
    wp::vec_t<3, wp::float32> & adj_position,
    wp::vec_t<3, wp::float32> & adj_normal,
    wp::float32 & adj_depth,
    wp::int32 & adj_fingerprint,
    GlobalContactReducerData_0c09c456 & adj_reducer_data,
    wp::int32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:0
static CUDA_CALLABLE void adj_write_contact_to_reducer_0(
    ContactData_40360d7c var_contact_data,
    GlobalContactReducerData_0c09c456 var_reducer_data,
    wp::int32 var_output_index,
    ContactData_40360d7c & adj_contact_data,
    GlobalContactReducerData_0c09c456 & adj_reducer_data,
    wp::int32 & adj_output_index)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}



extern "C" __global__ void create_narrow_phase_process_mesh_plane_contacts_kernel__locals__narrow_phase_process_mesh_plane_contacts_reduce_kernel_d72fc311_cuda_kernel_forward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::vec_t<4, wp::float32>> var_shape_data,
    wp::array_t<wp::transform_t<wp::float32>> var_shape_transform,
    wp::array_t<wp::uint64> var_shape_source,
    wp::array_t<wp::float32> var_shape_gap,
    wp::array_t<wp::vec_t<3, wp::float32>> var__shape_collision_aabb_lower,
    wp::array_t<wp::vec_t<3, wp::float32>> var__shape_collision_aabb_upper,
    wp::array_t<wp::vec_t<3, wp::int32>> var__shape_voxel_resolution,
    wp::array_t<wp::vec_t<2, wp::int32>> var_shape_pairs_mesh_plane,
    wp::array_t<wp::int32> var_shape_pairs_mesh_plane_count,
    wp::array_t<wp::int32> var_block_offsets,
    GlobalContactReducerData_0c09c456 var_writer_data,
    wp::int32 var_total_num_blocks)
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
        wp::int32* var_3;
        wp::shape_t* var_4;
        const wp::int32 var_5 = 0;
        wp::int32 var_6;
        wp::shape_t var_7;
        wp::int32 var_8;
        wp::int32 var_9;
        wp::int32* var_10;
        wp::int32 var_11;
        wp::int32 var_12;
        wp::range_t var_13;
        wp::int32 var_14;
        const wp::int32 var_15 = 0;
        wp::int32 var_16;
        wp::int32 var_17;
        bool var_18;
        wp::int32 var_19;
        const wp::int32 var_20 = 2;
        wp::int32 var_21;
        const wp::int32 var_22 = 1;
        wp::int32 var_23;
        wp::int32* var_24;
        bool var_25;
        wp::int32 var_26;
        const wp::int32 var_27 = 1;
        wp::int32 var_28;
        wp::int32 var_29;
        wp::int32 var_30;
        wp::int32 var_31;
        wp::int32 var_32;
        wp::int32* var_33;
        wp::int32 var_34;
        wp::int32 var_35;
        wp::int32 var_36;
        const wp::int32 var_37 = 1;
        wp::int32 var_38;
        wp::int32* var_39;
        wp::int32 var_40;
        wp::int32 var_41;
        wp::vec_t<2, wp::int32>* var_42;
        wp::vec_t<2, wp::int32> var_43;
        wp::vec_t<2, wp::int32> var_44;
        const wp::int32 var_45 = 0;
        wp::int32 var_46;
        const wp::int32 var_47 = 1;
        wp::int32 var_48;
        wp::uint64* var_49;
        wp::uint64 var_50;
        wp::uint64 var_51;
        wp::uint64 var_52;
        bool var_53;
        wp::Mesh var_54;
        wp::array_t<wp::vec_t<3, wp::float32>>* var_55;
        wp::shape_t* var_56;
        const wp::int32 var_57 = 0;
        wp::int32 var_58;
        wp::shape_t var_59;
        wp::int32 var_60;
        const wp::int32 var_61 = 1;
        wp::int32 var_62;
        wp::int32 var_63;
        wp::int32 var_64;
        wp::int32 var_65;
        wp::int32 var_66;
        wp::transform_t<wp::float32>* var_67;
        wp::transform_t<wp::float32> var_68;
        wp::transform_t<wp::float32> var_69;
        wp::transform_t<wp::float32>* var_70;
        wp::transform_t<wp::float32> var_71;
        wp::transform_t<wp::float32> var_72;
        wp::transform_t<wp::float32> var_73;
        const wp::float32 var_74 = 0.0;
        const wp::float32 var_75 = 0.0;
        const wp::float32 var_76 = 1.0;
        wp::vec_t<3, wp::float32> var_77;
        wp::vec_t<3, wp::float32> var_78;
        wp::vec_t<4, wp::float32>* var_79;
        wp::vec_t<4, wp::float32> var_80;
        wp::vec_t<4, wp::float32> var_81;
        const wp::int32 var_82 = 0;
        wp::float32 var_83;
        const wp::int32 var_84 = 1;
        wp::float32 var_85;
        const wp::int32 var_86 = 2;
        wp::float32 var_87;
        wp::vec_t<3, wp::float32> var_88;
        wp::vec_t<4, wp::float32>* var_89;
        const wp::int32 var_90 = 3;
        wp::float32 var_91;
        wp::vec_t<4, wp::float32> var_92;
        wp::vec_t<4, wp::float32>* var_93;
        const wp::int32 var_94 = 3;
        wp::float32 var_95;
        wp::vec_t<4, wp::float32> var_96;
        wp::float32 var_97;
        wp::float32* var_98;
        wp::float32 var_99;
        wp::float32 var_100;
        wp::float32* var_101;
        wp::float32 var_102;
        wp::float32 var_103;
        wp::float32 var_104;
        wp::int32 var_105;
        wp::int32 var_106;
        wp::int32 var_107;
        const wp::int32 var_108 = 1;
        wp::int32 var_109;
        wp::int32 var_110;
        wp::int32 var_111;
        wp::range_t var_112;
        wp::int32 var_113;
        wp::int32 var_114;
        wp::int32 var_115;
        wp::int32 var_116;
        wp::int32 var_117;
        bool var_118;
        wp::array_t<wp::vec_t<3, wp::float32>>* var_119;
        wp::vec_t<3, wp::float32>* var_120;
        wp::array_t<wp::vec_t<3, wp::float32>> var_121;
        wp::vec_t<3, wp::float32> var_122;
        wp::vec_t<3, wp::float32> var_123;
        wp::vec_t<3, wp::float32> var_124;
        wp::vec_t<3, wp::float32> var_125;
        const wp::int32 var_126 = 0;
        wp::float32 var_127;
        const wp::int32 var_128 = 1;
        wp::float32 var_129;
        const wp::float32 var_130 = 0.0;
        wp::vec_t<3, wp::float32> var_131;
        wp::vec_t<3, wp::float32> var_132;
        wp::vec_t<3, wp::float32> var_133;
        wp::float32 var_134;
        wp::float32 var_135;
        bool var_136;
        wp::vec_t<3, wp::float32> var_137;
        const wp::float32 var_138 = 0.5;
        wp::vec_t<3, wp::float32> var_139;
        wp::vec_t<3, wp::float32> var_140;
        ContactData_40360d7c var_141;
        const wp::float32 var_142 = 0.0;
        const wp::float32 var_143 = 0.0;
        const wp::int32 var_144 = -1;
        //---------
        // forward
        // def narrow_phase_process_mesh_plane_contacts_reduce_kernel(                            <L 1>
        // block_id, t = wp.tid()                                                                 <L 24>
        builtin_tid2d(var_0, var_1);
        // pair_count = wp.min(shape_pairs_mesh_plane_count[0], shape_pairs_mesh_plane.shape[0])       <L 26>
        var_3 = wp::address(var_shape_pairs_mesh_plane_count, var_2);
        var_4 = &(var_shape_pairs_mesh_plane.shape);
        var_7 = wp::load(var_4);
        var_6 = wp::extract(var_7, var_5);
        var_9 = wp::load(var_3);
        var_8 = wp::min(var_9, var_6);
        // total_combos = block_offsets[pair_count]                                               <L 27>
        var_10 = wp::address(var_block_offsets, var_8);
        var_12 = wp::load(var_10);
        var_11 = wp::copy(var_12);
        // for combo_idx in range(block_id, total_combos, total_num_blocks):                      <L 30>
        var_13 = wp::range(var_0, var_11, var_total_num_blocks);
        start_for_0:;
            if (iter_cmp(var_13) == 0) goto end_for_0;
            var_14 = wp::iter_next(var_13);
            // lo = int(0)                                                                        <L 32>
            var_16 = wp::int(var_15);
            // hi = int(pair_count)                                                               <L 33>
            var_17 = wp::int(var_8);
            // while lo < hi:                                                                     <L 34>
        start_while_2:;
            var_18 = (var_16 < var_17);
        if ((var_18) == false) goto end_while_2;
                // mid = (lo + hi) // 2                                                           <L 35>
                var_19 = wp::add(var_16, var_17);
                var_21 = wp::floordiv(var_19, var_20);
                // if block_offsets[mid + 1] <= combo_idx:                                        <L 36>
                var_23 = wp::add(var_21, var_22);
                var_24 = wp::address(var_block_offsets, var_23);
                var_26 = wp::load(var_24);
                var_25 = (var_26 <= var_14);
                if (var_25) {
                    // lo = mid + 1                                                               <L 37>
                    var_28 = wp::add(var_21, var_27);
                }
                if (!var_25) {
                    // hi = mid                                                                   <L 39>
                    var_29 = wp::copy(var_21);
                }
                var_30 = wp::where(var_25, var_28, var_16);
                var_31 = wp::where(var_25, var_17, var_29);
                wp::assign(var_16, var_30);
                wp::assign(var_17, var_31);
        goto start_while_2;
        end_while_2:;
            // pair_idx = int(lo)                                                                 <L 40>
            var_32 = wp::int(var_16);
            // pair_block_start = block_offsets[pair_idx]                                         <L 41>
            var_33 = wp::address(var_block_offsets, var_32);
            var_35 = wp::load(var_33);
            var_34 = wp::copy(var_35);
            // block_in_pair = combo_idx - pair_block_start                                       <L 42>
            var_36 = wp::sub(var_14, var_34);
            // blocks_for_pair = block_offsets[pair_idx + 1] - pair_block_start                   <L 43>
            var_38 = wp::add(var_32, var_37);
            var_39 = wp::address(var_block_offsets, var_38);
            var_41 = wp::load(var_39);
            var_40 = wp::sub(var_41, var_34);
            // pair = shape_pairs_mesh_plane[pair_idx]                                            <L 46>
            var_42 = wp::address(var_shape_pairs_mesh_plane, var_32);
            var_44 = wp::load(var_42);
            var_43 = wp::copy(var_44);
            // mesh_shape = pair[0]                                                               <L 47>
            var_46 = wp::extract(var_43, var_45);
            // plane_shape = pair[1]                                                              <L 48>
            var_48 = wp::extract(var_43, var_47);
            // mesh_id = shape_source[mesh_shape]                                                 <L 51>
            var_49 = wp::address(var_shape_source, var_46);
            var_51 = wp::load(var_49);
            var_50 = wp::copy(var_51);
            // if mesh_id == wp.uint64(0):                                                        <L 52>
            var_52 = 0ull;
            var_53 = (var_50 == var_52);
            if (var_53) {
                // continue                                                                       <L 53>
                goto start_for_0;
            }
            // mesh_obj = wp.mesh_get(mesh_id)                                                    <L 55>
            var_54 = wp::mesh_get(var_50);
            // num_vertices = mesh_obj.points.shape[0]                                            <L 56>
            var_55 = &((var_54).points);
            var_56 = &(var_55->shape);
            var_59 = wp::load(var_56);
            var_58 = wp::extract(var_59, var_57);
            // chunk_size = (num_vertices + blocks_for_pair - 1) // blocks_for_pair               <L 59>
            var_60 = wp::add(var_58, var_40);
            var_62 = wp::sub(var_60, var_61);
            var_63 = wp::floordiv(var_62, var_40);
            // vert_start = block_in_pair * chunk_size                                            <L 60>
            var_64 = wp::mul(var_36, var_63);
            // vert_end = wp.min(vert_start + chunk_size, num_vertices)                           <L 61>
            var_65 = wp::add(var_64, var_63);
            var_66 = wp::min(var_65, var_58);
            // X_mesh_ws = shape_transform[mesh_shape]                                            <L 64>
            var_67 = wp::address(var_shape_transform, var_46);
            var_69 = wp::load(var_67);
            var_68 = wp::copy(var_69);
            // X_plane_ws = shape_transform[plane_shape]                                          <L 67>
            var_70 = wp::address(var_shape_transform, var_48);
            var_72 = wp::load(var_70);
            var_71 = wp::copy(var_72);
            // X_plane_sw = wp.transform_inverse(X_plane_ws)                                      <L 68>
            var_73 = wp::transform_inverse(var_71);
            // plane_normal = wp.transform_vector(X_plane_ws, wp.vec3(0.0, 0.0, 1.0))             <L 71>
            var_77 = wp::vec_t<3, wp::float32>(var_74, var_75, var_76);
            var_78 = wp::transform_vector(var_71, var_77);
            // scale_data = shape_data[mesh_shape]                                                <L 74>
            var_79 = wp::address(var_shape_data, var_46);
            var_81 = wp::load(var_79);
            var_80 = wp::copy(var_81);
            // mesh_scale = wp.vec3(scale_data[0], scale_data[1], scale_data[2])                  <L 75>
            var_83 = wp::extract(var_80, var_82);
            var_85 = wp::extract(var_80, var_84);
            var_87 = wp::extract(var_80, var_86);
            var_88 = wp::vec_t<3, wp::float32>(var_83, var_85, var_87);
            // margin_offset_mesh = shape_data[mesh_shape][3]                                     <L 78>
            var_89 = wp::address(var_shape_data, var_46);
            var_92 = wp::load(var_89);
            var_91 = wp::extract(var_92, var_90);
            // margin_offset_plane = shape_data[plane_shape][3]                                   <L 79>
            var_93 = wp::address(var_shape_data, var_48);
            var_96 = wp::load(var_93);
            var_95 = wp::extract(var_96, var_94);
            // total_margin_offset = margin_offset_mesh + margin_offset_plane                     <L 80>
            var_97 = wp::add(var_91, var_95);
            // gap_mesh = shape_gap[mesh_shape]                                                   <L 83>
            var_98 = wp::address(var_shape_gap, var_46);
            var_100 = wp::load(var_98);
            var_99 = wp::copy(var_100);
            // gap_plane = shape_gap[plane_shape]                                                 <L 84>
            var_101 = wp::address(var_shape_gap, var_48);
            var_103 = wp::load(var_101);
            var_102 = wp::copy(var_103);
            // gap_sum = gap_mesh + gap_plane                                                     <L 85>
            var_104 = wp::add(var_99, var_102);
            // chunk_len = vert_end - vert_start                                                  <L 89>
            var_105 = wp::sub(var_66, var_64);
            // num_iterations = (chunk_len + wp.block_dim() - 1) // wp.block_dim()                <L 90>
            var_106 = builtin_block_dim();
            var_107 = wp::add(var_105, var_106);
            var_109 = wp::sub(var_107, var_108);
            var_110 = builtin_block_dim();
            var_111 = wp::floordiv(var_109, var_110);
            // for i in range(num_iterations):                                                    <L 91>
            var_112 = wp::range(var_111);
            start_for_4:;
                if (iter_cmp(var_112) == 0) goto end_for_4;
                var_113 = wp::iter_next(var_112);
                // vertex_idx = vert_start + i * wp.block_dim() + t                               <L 92>
                var_114 = builtin_block_dim();
                var_115 = wp::mul(var_113, var_114);
                var_116 = wp::add(var_64, var_115);
                var_117 = wp::add(var_116, var_1);
                // if vertex_idx < vert_end:                                                      <L 94>
                var_118 = (var_117 < var_66);
                if (var_118) {
                    // vertex_local = wp.cw_mul(mesh_obj.points[vertex_idx], mesh_scale)          <L 96>
                    var_119 = &((var_54).points);
                    var_121 = wp::load(var_119);
                    var_120 = wp::address(var_121, var_117);
                    var_123 = wp::load(var_120);
                    var_122 = wp::cw_mul(var_123, var_88);
                    // vertex_world = wp.transform_point(X_mesh_ws, vertex_local)                 <L 97>
                    var_124 = wp::transform_point(var_68, var_122);
                    // vertex_in_plane_space = wp.transform_point(X_plane_sw, vertex_world)       <L 100>
                    var_125 = wp::transform_point(var_73, var_124);
                    // point_on_plane_local = wp.vec3(vertex_in_plane_space[0], vertex_in_plane_space[1], 0.0)       <L 101>
                    var_127 = wp::extract(var_125, var_126);
                    var_129 = wp::extract(var_125, var_128);
                    var_131 = wp::vec_t<3, wp::float32>(var_127, var_129, var_130);
                    // point_on_plane = wp.transform_point(X_plane_ws, point_on_plane_local)       <L 102>
                    var_132 = wp::transform_point(var_71, var_131);
                    // diff = vertex_world - point_on_plane                                       <L 105>
                    var_133 = wp::sub(var_124, var_132);
                    // distance = wp.dot(diff, plane_normal)                                      <L 106>
                    var_134 = wp::dot(var_133, var_78);
                    // if distance < gap_sum + total_margin_offset:                               <L 109>
                    var_135 = wp::add(var_104, var_97);
                    var_136 = (var_134 < var_135);
                    if (var_136) {
                        // contact_pos = (vertex_world + point_on_plane) * 0.5                    <L 111>
                        var_137 = wp::add(var_124, var_132);
                        var_139 = wp::mul(var_137, var_138);
                        // contact_normal = -plane_normal                                         <L 114>
                        var_140 = wp::neg(var_78);
                        // contact_data = ContactData()                                           <L 116>
                        var_141 = ContactData_40360d7c();
                        // contact_data.contact_point_center = contact_pos                        <L 117>
                        var_141.contact_point_center = var_139;
                        // contact_data.contact_normal_a_to_b = contact_normal                    <L 118>
                        var_141.contact_normal_a_to_b = var_140;
                        // contact_data.contact_distance = distance                               <L 119>
                        var_141.contact_distance = var_134;
                        // contact_data.radius_eff_a = 0.0                                        <L 120>
                        var_141.radius_eff_a = var_142;
                        // contact_data.radius_eff_b = 0.0                                        <L 121>
                        var_141.radius_eff_b = var_143;
                        // contact_data.margin_a = margin_offset_mesh                             <L 122>
                        var_141.margin_a = var_91;
                        // contact_data.margin_b = margin_offset_plane                            <L 123>
                        var_141.margin_b = var_95;
                        // contact_data.shape_a = mesh_shape                                      <L 124>
                        var_141.shape_a = var_46;
                        // contact_data.shape_b = plane_shape                                     <L 125>
                        var_141.shape_b = var_48;
                        // contact_data.gap_sum = gap_sum                                         <L 126>
                        var_141.gap_sum = var_104;
                        // contact_data.sort_sub_key = vertex_idx                                 <L 127>
                        var_141.sort_sub_key = var_117;
                        // writer_func(contact_data, writer_data, -1)                             <L 129>
                        write_contact_to_reducer_0(var_141, var_writer_data, var_144);
                    }
                }
                goto start_for_4;
            end_for_4:;
            goto start_for_0;
        end_for_0:;
    }
}

