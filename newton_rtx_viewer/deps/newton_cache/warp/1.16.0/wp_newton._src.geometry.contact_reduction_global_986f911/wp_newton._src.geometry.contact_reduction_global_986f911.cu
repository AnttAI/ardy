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


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction.py:256
static CUDA_CALLABLE wp::int32 get_slot_0(
    wp::vec_t<3, wp::float32> var_normal)
{
    //---------
    // primal vars
    const bool var_0 = false;
    const bool var_1 = false;
    const bool var_2 = true;
    const wp::int32 var_3 = 1;
    wp::float32 var_4;
    const wp::float32 var_5 = 0.65;
    bool var_6;
    const wp::int32 var_7 = 0;
    const wp::mat_t<20, 3, wp::float32> var_8 = wp::initializer_array<60,wp::float32>{0.49112337827682495, 0.7946545481681824, 0.3568221628665924, -0.18759243190288544, 0.7946544885635376, 0.5773502588272095, -0.6070619225502014, 0.7946544885635376, 0.0, -0.18759237229824066, 0.7946544885635376, -0.5773502588272095, 0.49112340807914734, 0.7946545481681824, -0.35682210326194763, 0.9822468757629395, -0.18759256601333618, 0.0, 0.7946544289588928, 0.18759238719940186, -0.5773503184318542, 0.3035309612751007, -0.1875925213098526, 0.9341723322868347, 0.7946544289588928, 0.18759243190288544, 0.5773503184318542, -0.7946544885635376, -0.1875924915075302, 0.5773503184318542, -0.30353105068206787, 0.18759243190288544, 0.9341723918914795, -0.7946544289588928, -0.18759240210056305, -0.5773503184318542, -0.9822468757629395, 0.1875925362110138, 0.0, 0.3035309612751007, -0.1875925064086914, -0.9341723322868347, -0.30353084206581116, 0.18759246170520782, -0.9341723918914795, 0.1875924915075302, -0.7946544289588928, 0.5773502588272095, -0.49112337827682495, -0.7946544885635376, 0.35682213306427, -0.49112337827682495, -0.7946545481681824, -0.35682213306427, 0.18759243190288544, -0.7946544289588928, -0.5773502588272095, 0.6070619821548462, -0.7946544289588928, 0.0};
    const wp::int32 var_9 = 0;
    wp::vec_t<3, wp::float32> var_10;
    wp::float32 var_11;
    const wp::int32 var_12 = 1;
    wp::vec_t<3, wp::float32> var_13;
    wp::float32 var_14;
    bool var_15;
    wp::float32 var_16;
    wp::int32 var_17;
    wp::int32 var_18;
    wp::float32 var_19;
    const wp::int32 var_20 = 2;
    wp::vec_t<3, wp::float32> var_21;
    wp::float32 var_22;
    bool var_23;
    wp::float32 var_24;
    wp::int32 var_25;
    wp::int32 var_26;
    wp::float32 var_27;
    const wp::int32 var_28 = 3;
    wp::vec_t<3, wp::float32> var_29;
    wp::float32 var_30;
    bool var_31;
    wp::float32 var_32;
    wp::int32 var_33;
    wp::int32 var_34;
    wp::float32 var_35;
    const wp::int32 var_36 = 4;
    wp::vec_t<3, wp::float32> var_37;
    wp::float32 var_38;
    bool var_39;
    wp::float32 var_40;
    wp::int32 var_41;
    wp::int32 var_42;
    wp::float32 var_43;
    const wp::float32 var_44 = -0.65;
    bool var_45;
    const wp::int32 var_46 = 15;
    const wp::mat_t<20, 3, wp::float32> var_47 = wp::initializer_array<60,wp::float32>{0.49112337827682495, 0.7946545481681824, 0.3568221628665924, -0.18759243190288544, 0.7946544885635376, 0.5773502588272095, -0.6070619225502014, 0.7946544885635376, 0.0, -0.18759237229824066, 0.7946544885635376, -0.5773502588272095, 0.49112340807914734, 0.7946545481681824, -0.35682210326194763, 0.9822468757629395, -0.18759256601333618, 0.0, 0.7946544289588928, 0.18759238719940186, -0.5773503184318542, 0.3035309612751007, -0.1875925213098526, 0.9341723322868347, 0.7946544289588928, 0.18759243190288544, 0.5773503184318542, -0.7946544885635376, -0.1875924915075302, 0.5773503184318542, -0.30353105068206787, 0.18759243190288544, 0.9341723918914795, -0.7946544289588928, -0.18759240210056305, -0.5773503184318542, -0.9822468757629395, 0.1875925362110138, 0.0, 0.3035309612751007, -0.1875925064086914, -0.9341723322868347, -0.30353084206581116, 0.18759246170520782, -0.9341723918914795, 0.1875924915075302, -0.7946544289588928, 0.5773502588272095, -0.49112337827682495, -0.7946544885635376, 0.35682213306427, -0.49112337827682495, -0.7946545481681824, -0.35682213306427, 0.18759243190288544, -0.7946544289588928, -0.5773502588272095, 0.6070619821548462, -0.7946544289588928, 0.0};
    const wp::int32 var_48 = 15;
    wp::vec_t<3, wp::float32> var_49;
    wp::float32 var_50;
    const wp::int32 var_51 = 16;
    wp::vec_t<3, wp::float32> var_52;
    wp::float32 var_53;
    bool var_54;
    wp::float32 var_55;
    wp::int32 var_56;
    wp::int32 var_57;
    wp::float32 var_58;
    const wp::int32 var_59 = 17;
    wp::vec_t<3, wp::float32> var_60;
    wp::float32 var_61;
    bool var_62;
    wp::float32 var_63;
    wp::int32 var_64;
    wp::int32 var_65;
    wp::float32 var_66;
    const wp::int32 var_67 = 18;
    wp::vec_t<3, wp::float32> var_68;
    wp::float32 var_69;
    bool var_70;
    wp::float32 var_71;
    wp::int32 var_72;
    wp::int32 var_73;
    wp::float32 var_74;
    const wp::int32 var_75 = 19;
    wp::vec_t<3, wp::float32> var_76;
    wp::float32 var_77;
    bool var_78;
    wp::float32 var_79;
    wp::int32 var_80;
    wp::int32 var_81;
    wp::float32 var_82;
    const wp::float32 var_83 = 0.0;
    bool var_84;
    const wp::int32 var_85 = 0;
    const wp::mat_t<20, 3, wp::float32> var_86 = wp::initializer_array<60,wp::float32>{0.49112337827682495, 0.7946545481681824, 0.3568221628665924, -0.18759243190288544, 0.7946544885635376, 0.5773502588272095, -0.6070619225502014, 0.7946544885635376, 0.0, -0.18759237229824066, 0.7946544885635376, -0.5773502588272095, 0.49112340807914734, 0.7946545481681824, -0.35682210326194763, 0.9822468757629395, -0.18759256601333618, 0.0, 0.7946544289588928, 0.18759238719940186, -0.5773503184318542, 0.3035309612751007, -0.1875925213098526, 0.9341723322868347, 0.7946544289588928, 0.18759243190288544, 0.5773503184318542, -0.7946544885635376, -0.1875924915075302, 0.5773503184318542, -0.30353105068206787, 0.18759243190288544, 0.9341723918914795, -0.7946544289588928, -0.18759240210056305, -0.5773503184318542, -0.9822468757629395, 0.1875925362110138, 0.0, 0.3035309612751007, -0.1875925064086914, -0.9341723322868347, -0.30353084206581116, 0.18759246170520782, -0.9341723918914795, 0.1875924915075302, -0.7946544289588928, 0.5773502588272095, -0.49112337827682495, -0.7946544885635376, 0.35682213306427, -0.49112337827682495, -0.7946545481681824, -0.35682213306427, 0.18759243190288544, -0.7946544289588928, -0.5773502588272095, 0.6070619821548462, -0.7946544289588928, 0.0};
    const wp::int32 var_87 = 0;
    wp::vec_t<3, wp::float32> var_88;
    wp::float32 var_89;
    const wp::int32 var_90 = 1;
    wp::vec_t<3, wp::float32> var_91;
    wp::float32 var_92;
    bool var_93;
    wp::float32 var_94;
    wp::int32 var_95;
    wp::int32 var_96;
    wp::float32 var_97;
    const wp::int32 var_98 = 2;
    wp::vec_t<3, wp::float32> var_99;
    wp::float32 var_100;
    bool var_101;
    wp::float32 var_102;
    wp::int32 var_103;
    wp::int32 var_104;
    wp::float32 var_105;
    const wp::int32 var_106 = 3;
    wp::vec_t<3, wp::float32> var_107;
    wp::float32 var_108;
    bool var_109;
    wp::float32 var_110;
    wp::int32 var_111;
    wp::int32 var_112;
    wp::float32 var_113;
    const wp::int32 var_114 = 4;
    wp::vec_t<3, wp::float32> var_115;
    wp::float32 var_116;
    bool var_117;
    wp::float32 var_118;
    wp::int32 var_119;
    wp::int32 var_120;
    wp::float32 var_121;
    const wp::int32 var_122 = 5;
    wp::vec_t<3, wp::float32> var_123;
    wp::float32 var_124;
    bool var_125;
    wp::float32 var_126;
    wp::int32 var_127;
    wp::int32 var_128;
    wp::float32 var_129;
    const wp::int32 var_130 = 6;
    wp::vec_t<3, wp::float32> var_131;
    wp::float32 var_132;
    bool var_133;
    wp::float32 var_134;
    wp::int32 var_135;
    wp::int32 var_136;
    wp::float32 var_137;
    const wp::int32 var_138 = 7;
    wp::vec_t<3, wp::float32> var_139;
    wp::float32 var_140;
    bool var_141;
    wp::float32 var_142;
    wp::int32 var_143;
    wp::int32 var_144;
    wp::float32 var_145;
    const wp::int32 var_146 = 8;
    wp::vec_t<3, wp::float32> var_147;
    wp::float32 var_148;
    bool var_149;
    wp::float32 var_150;
    wp::int32 var_151;
    wp::int32 var_152;
    wp::float32 var_153;
    const wp::int32 var_154 = 9;
    wp::vec_t<3, wp::float32> var_155;
    wp::float32 var_156;
    bool var_157;
    wp::float32 var_158;
    wp::int32 var_159;
    wp::int32 var_160;
    wp::float32 var_161;
    const wp::int32 var_162 = 10;
    wp::vec_t<3, wp::float32> var_163;
    wp::float32 var_164;
    bool var_165;
    wp::float32 var_166;
    wp::int32 var_167;
    wp::int32 var_168;
    wp::float32 var_169;
    const wp::int32 var_170 = 11;
    wp::vec_t<3, wp::float32> var_171;
    wp::float32 var_172;
    bool var_173;
    wp::float32 var_174;
    wp::int32 var_175;
    wp::int32 var_176;
    wp::float32 var_177;
    const wp::int32 var_178 = 12;
    wp::vec_t<3, wp::float32> var_179;
    wp::float32 var_180;
    bool var_181;
    wp::float32 var_182;
    wp::int32 var_183;
    wp::int32 var_184;
    wp::float32 var_185;
    const wp::int32 var_186 = 13;
    wp::vec_t<3, wp::float32> var_187;
    wp::float32 var_188;
    bool var_189;
    wp::float32 var_190;
    wp::int32 var_191;
    wp::int32 var_192;
    wp::float32 var_193;
    const wp::int32 var_194 = 14;
    wp::vec_t<3, wp::float32> var_195;
    wp::float32 var_196;
    bool var_197;
    wp::float32 var_198;
    wp::int32 var_199;
    wp::int32 var_200;
    wp::float32 var_201;
    const wp::int32 var_202 = 5;
    const wp::mat_t<20, 3, wp::float32> var_203 = wp::initializer_array<60,wp::float32>{0.49112337827682495, 0.7946545481681824, 0.3568221628665924, -0.18759243190288544, 0.7946544885635376, 0.5773502588272095, -0.6070619225502014, 0.7946544885635376, 0.0, -0.18759237229824066, 0.7946544885635376, -0.5773502588272095, 0.49112340807914734, 0.7946545481681824, -0.35682210326194763, 0.9822468757629395, -0.18759256601333618, 0.0, 0.7946544289588928, 0.18759238719940186, -0.5773503184318542, 0.3035309612751007, -0.1875925213098526, 0.9341723322868347, 0.7946544289588928, 0.18759243190288544, 0.5773503184318542, -0.7946544885635376, -0.1875924915075302, 0.5773503184318542, -0.30353105068206787, 0.18759243190288544, 0.9341723918914795, -0.7946544289588928, -0.18759240210056305, -0.5773503184318542, -0.9822468757629395, 0.1875925362110138, 0.0, 0.3035309612751007, -0.1875925064086914, -0.9341723322868347, -0.30353084206581116, 0.18759246170520782, -0.9341723918914795, 0.1875924915075302, -0.7946544289588928, 0.5773502588272095, -0.49112337827682495, -0.7946544885635376, 0.35682213306427, -0.49112337827682495, -0.7946545481681824, -0.35682213306427, 0.18759243190288544, -0.7946544289588928, -0.5773502588272095, 0.6070619821548462, -0.7946544289588928, 0.0};
    const wp::int32 var_204 = 5;
    wp::vec_t<3, wp::float32> var_205;
    wp::float32 var_206;
    const wp::int32 var_207 = 6;
    wp::vec_t<3, wp::float32> var_208;
    wp::float32 var_209;
    bool var_210;
    wp::float32 var_211;
    wp::int32 var_212;
    wp::int32 var_213;
    wp::float32 var_214;
    const wp::int32 var_215 = 7;
    wp::vec_t<3, wp::float32> var_216;
    wp::float32 var_217;
    bool var_218;
    wp::float32 var_219;
    wp::int32 var_220;
    wp::int32 var_221;
    wp::float32 var_222;
    const wp::int32 var_223 = 8;
    wp::vec_t<3, wp::float32> var_224;
    wp::float32 var_225;
    bool var_226;
    wp::float32 var_227;
    wp::int32 var_228;
    wp::int32 var_229;
    wp::float32 var_230;
    const wp::int32 var_231 = 9;
    wp::vec_t<3, wp::float32> var_232;
    wp::float32 var_233;
    bool var_234;
    wp::float32 var_235;
    wp::int32 var_236;
    wp::int32 var_237;
    wp::float32 var_238;
    const wp::int32 var_239 = 10;
    wp::vec_t<3, wp::float32> var_240;
    wp::float32 var_241;
    bool var_242;
    wp::float32 var_243;
    wp::int32 var_244;
    wp::int32 var_245;
    wp::float32 var_246;
    const wp::int32 var_247 = 11;
    wp::vec_t<3, wp::float32> var_248;
    wp::float32 var_249;
    bool var_250;
    wp::float32 var_251;
    wp::int32 var_252;
    wp::int32 var_253;
    wp::float32 var_254;
    const wp::int32 var_255 = 12;
    wp::vec_t<3, wp::float32> var_256;
    wp::float32 var_257;
    bool var_258;
    wp::float32 var_259;
    wp::int32 var_260;
    wp::int32 var_261;
    wp::float32 var_262;
    const wp::int32 var_263 = 13;
    wp::vec_t<3, wp::float32> var_264;
    wp::float32 var_265;
    bool var_266;
    wp::float32 var_267;
    wp::int32 var_268;
    wp::int32 var_269;
    wp::float32 var_270;
    const wp::int32 var_271 = 14;
    wp::vec_t<3, wp::float32> var_272;
    wp::float32 var_273;
    bool var_274;
    wp::float32 var_275;
    wp::int32 var_276;
    wp::int32 var_277;
    wp::float32 var_278;
    const wp::int32 var_279 = 15;
    wp::vec_t<3, wp::float32> var_280;
    wp::float32 var_281;
    bool var_282;
    wp::float32 var_283;
    wp::int32 var_284;
    wp::int32 var_285;
    wp::float32 var_286;
    const wp::int32 var_287 = 16;
    wp::vec_t<3, wp::float32> var_288;
    wp::float32 var_289;
    bool var_290;
    wp::float32 var_291;
    wp::int32 var_292;
    wp::int32 var_293;
    wp::float32 var_294;
    const wp::int32 var_295 = 17;
    wp::vec_t<3, wp::float32> var_296;
    wp::float32 var_297;
    bool var_298;
    wp::float32 var_299;
    wp::int32 var_300;
    wp::int32 var_301;
    wp::float32 var_302;
    const wp::int32 var_303 = 18;
    wp::vec_t<3, wp::float32> var_304;
    wp::float32 var_305;
    bool var_306;
    wp::float32 var_307;
    wp::int32 var_308;
    wp::int32 var_309;
    wp::float32 var_310;
    const wp::int32 var_311 = 19;
    wp::vec_t<3, wp::float32> var_312;
    wp::float32 var_313;
    bool var_314;
    wp::float32 var_315;
    wp::int32 var_316;
    wp::int32 var_317;
    wp::float32 var_318;
    wp::int32 var_319;
    wp::mat_t<20, 3, wp::float32> var_320;
    wp::float32 var_321;
    wp::int32 var_322;
    wp::float32 var_323;
    wp::int32 var_324;
    wp::mat_t<20, 3, wp::float32> var_325;
    wp::float32 var_326;
    wp::int32 var_327;
    wp::float32 var_328;
    wp::int32 var_329;
    wp::mat_t<20, 3, wp::float32> var_330;
    wp::float32 var_331;
    wp::int32 var_332;
    wp::float32 var_333;
    //---------
    // forward
    // def get_slot(normal: wp.vec3) -> int:                                                  <L 257>
    // if wp.static(NORMAL_BINNING_POLYHEDRON == "hexahedron"):                               <L 276>
    // elif wp.static(NORMAL_BINNING_POLYHEDRON == "dodecahedron"):                           <L 297>
    // elif wp.static(NORMAL_BINNING_POLYHEDRON == "icosahedron"):                            <L 326>
    // up_dot = normal[1]                                                                     <L 327>
    var_4 = wp::extract(var_normal, var_3);
    // if up_dot > 0.65:                                                                      <L 330>
    var_6 = (var_4 > var_5);
    if (var_6) {
        // best_slot = 0                                                                      <L 331>
        // max_dot = wp.dot(normal, FACE_NORMALS[0])                                          <L 332>
        var_10 = wp::extract(var_8, var_9);
        var_11 = wp::dot(var_normal, var_10);
        // for i in range(1, 5):                                                              <L 333>
        // d = wp.dot(normal, FACE_NORMALS[i])                                                <L 334>
        var_13 = wp::extract(var_8, var_12);
        var_14 = wp::dot(var_normal, var_13);
        // if d > max_dot:                                                                    <L 335>
        var_15 = (var_14 > var_11);
        if (var_15) {
            // max_dot = d                                                                    <L 336>
            var_16 = wp::copy(var_14);
            // best_slot = i                                                                  <L 337>
            var_17 = wp::copy(var_12);
        }
        var_18 = wp::where(var_15, var_17, var_7);
        var_19 = wp::where(var_15, var_16, var_11);
        // d = wp.dot(normal, FACE_NORMALS[i])                                                <L 334>
        var_21 = wp::extract(var_8, var_20);
        var_22 = wp::dot(var_normal, var_21);
        // if d > max_dot:                                                                    <L 335>
        var_23 = (var_22 > var_19);
        if (var_23) {
            // max_dot = d                                                                    <L 336>
            var_24 = wp::copy(var_22);
            // best_slot = i                                                                  <L 337>
            var_25 = wp::copy(var_20);
        }
        var_26 = wp::where(var_23, var_25, var_18);
        var_27 = wp::where(var_23, var_24, var_19);
        // d = wp.dot(normal, FACE_NORMALS[i])                                                <L 334>
        var_29 = wp::extract(var_8, var_28);
        var_30 = wp::dot(var_normal, var_29);
        // if d > max_dot:                                                                    <L 335>
        var_31 = (var_30 > var_27);
        if (var_31) {
            // max_dot = d                                                                    <L 336>
            var_32 = wp::copy(var_30);
            // best_slot = i                                                                  <L 337>
            var_33 = wp::copy(var_28);
        }
        var_34 = wp::where(var_31, var_33, var_26);
        var_35 = wp::where(var_31, var_32, var_27);
        // d = wp.dot(normal, FACE_NORMALS[i])                                                <L 334>
        var_37 = wp::extract(var_8, var_36);
        var_38 = wp::dot(var_normal, var_37);
        // if d > max_dot:                                                                    <L 335>
        var_39 = (var_38 > var_35);
        if (var_39) {
            // max_dot = d                                                                    <L 336>
            var_40 = wp::copy(var_38);
            // best_slot = i                                                                  <L 337>
            var_41 = wp::copy(var_36);
        }
        var_42 = wp::where(var_39, var_41, var_34);
        var_43 = wp::where(var_39, var_40, var_35);
        // return best_slot                                                                   <L 338>
        return var_42;
    }
    if (!var_6) {
        // elif up_dot < -0.65:                                                               <L 339>
        var_45 = (var_4 < var_44);
        if (var_45) {
            // best_slot = 15                                                                 <L 340>
            // max_dot = wp.dot(normal, FACE_NORMALS[15])                                     <L 341>
            var_49 = wp::extract(var_47, var_48);
            var_50 = wp::dot(var_normal, var_49);
            // for i in range(16, 20):                                                        <L 342>
            // d = wp.dot(normal, FACE_NORMALS[i])                                            <L 343>
            var_52 = wp::extract(var_47, var_51);
            var_53 = wp::dot(var_normal, var_52);
            // if d > max_dot:                                                                <L 344>
            var_54 = (var_53 > var_50);
            if (var_54) {
                // max_dot = d                                                                <L 345>
                var_55 = wp::copy(var_53);
                // best_slot = i                                                              <L 346>
                var_56 = wp::copy(var_51);
            }
            var_57 = wp::where(var_54, var_56, var_46);
            var_58 = wp::where(var_54, var_55, var_50);
            // d = wp.dot(normal, FACE_NORMALS[i])                                            <L 343>
            var_60 = wp::extract(var_47, var_59);
            var_61 = wp::dot(var_normal, var_60);
            // if d > max_dot:                                                                <L 344>
            var_62 = (var_61 > var_58);
            if (var_62) {
                // max_dot = d                                                                <L 345>
                var_63 = wp::copy(var_61);
                // best_slot = i                                                              <L 346>
                var_64 = wp::copy(var_59);
            }
            var_65 = wp::where(var_62, var_64, var_57);
            var_66 = wp::where(var_62, var_63, var_58);
            // d = wp.dot(normal, FACE_NORMALS[i])                                            <L 343>
            var_68 = wp::extract(var_47, var_67);
            var_69 = wp::dot(var_normal, var_68);
            // if d > max_dot:                                                                <L 344>
            var_70 = (var_69 > var_66);
            if (var_70) {
                // max_dot = d                                                                <L 345>
                var_71 = wp::copy(var_69);
                // best_slot = i                                                              <L 346>
                var_72 = wp::copy(var_67);
            }
            var_73 = wp::where(var_70, var_72, var_65);
            var_74 = wp::where(var_70, var_71, var_66);
            // d = wp.dot(normal, FACE_NORMALS[i])                                            <L 343>
            var_76 = wp::extract(var_47, var_75);
            var_77 = wp::dot(var_normal, var_76);
            // if d > max_dot:                                                                <L 344>
            var_78 = (var_77 > var_74);
            if (var_78) {
                // max_dot = d                                                                <L 345>
                var_79 = wp::copy(var_77);
                // best_slot = i                                                              <L 346>
                var_80 = wp::copy(var_75);
            }
            var_81 = wp::where(var_78, var_80, var_73);
            var_82 = wp::where(var_78, var_79, var_74);
            // return best_slot                                                               <L 347>
            return var_81;
        }
        if (!var_45) {
            // elif up_dot >= 0.0:                                                            <L 348>
            var_84 = (var_4 >= var_83);
            if (var_84) {
                // best_slot = 0                                                              <L 349>
                // max_dot = wp.dot(normal, FACE_NORMALS[0])                                  <L 350>
                var_88 = wp::extract(var_86, var_87);
                var_89 = wp::dot(var_normal, var_88);
                // for i in range(1, 15):                                                     <L 351>
                // d = wp.dot(normal, FACE_NORMALS[i])                                        <L 352>
                var_91 = wp::extract(var_86, var_90);
                var_92 = wp::dot(var_normal, var_91);
                // if d > max_dot:                                                            <L 353>
                var_93 = (var_92 > var_89);
                if (var_93) {
                    // max_dot = d                                                            <L 354>
                    var_94 = wp::copy(var_92);
                    // best_slot = i                                                          <L 355>
                    var_95 = wp::copy(var_90);
                }
                var_96 = wp::where(var_93, var_95, var_85);
                var_97 = wp::where(var_93, var_94, var_89);
                // d = wp.dot(normal, FACE_NORMALS[i])                                        <L 352>
                var_99 = wp::extract(var_86, var_98);
                var_100 = wp::dot(var_normal, var_99);
                // if d > max_dot:                                                            <L 353>
                var_101 = (var_100 > var_97);
                if (var_101) {
                    // max_dot = d                                                            <L 354>
                    var_102 = wp::copy(var_100);
                    // best_slot = i                                                          <L 355>
                    var_103 = wp::copy(var_98);
                }
                var_104 = wp::where(var_101, var_103, var_96);
                var_105 = wp::where(var_101, var_102, var_97);
                // d = wp.dot(normal, FACE_NORMALS[i])                                        <L 352>
                var_107 = wp::extract(var_86, var_106);
                var_108 = wp::dot(var_normal, var_107);
                // if d > max_dot:                                                            <L 353>
                var_109 = (var_108 > var_105);
                if (var_109) {
                    // max_dot = d                                                            <L 354>
                    var_110 = wp::copy(var_108);
                    // best_slot = i                                                          <L 355>
                    var_111 = wp::copy(var_106);
                }
                var_112 = wp::where(var_109, var_111, var_104);
                var_113 = wp::where(var_109, var_110, var_105);
                // d = wp.dot(normal, FACE_NORMALS[i])                                        <L 352>
                var_115 = wp::extract(var_86, var_114);
                var_116 = wp::dot(var_normal, var_115);
                // if d > max_dot:                                                            <L 353>
                var_117 = (var_116 > var_113);
                if (var_117) {
                    // max_dot = d                                                            <L 354>
                    var_118 = wp::copy(var_116);
                    // best_slot = i                                                          <L 355>
                    var_119 = wp::copy(var_114);
                }
                var_120 = wp::where(var_117, var_119, var_112);
                var_121 = wp::where(var_117, var_118, var_113);
                // d = wp.dot(normal, FACE_NORMALS[i])                                        <L 352>
                var_123 = wp::extract(var_86, var_122);
                var_124 = wp::dot(var_normal, var_123);
                // if d > max_dot:                                                            <L 353>
                var_125 = (var_124 > var_121);
                if (var_125) {
                    // max_dot = d                                                            <L 354>
                    var_126 = wp::copy(var_124);
                    // best_slot = i                                                          <L 355>
                    var_127 = wp::copy(var_122);
                }
                var_128 = wp::where(var_125, var_127, var_120);
                var_129 = wp::where(var_125, var_126, var_121);
                // d = wp.dot(normal, FACE_NORMALS[i])                                        <L 352>
                var_131 = wp::extract(var_86, var_130);
                var_132 = wp::dot(var_normal, var_131);
                // if d > max_dot:                                                            <L 353>
                var_133 = (var_132 > var_129);
                if (var_133) {
                    // max_dot = d                                                            <L 354>
                    var_134 = wp::copy(var_132);
                    // best_slot = i                                                          <L 355>
                    var_135 = wp::copy(var_130);
                }
                var_136 = wp::where(var_133, var_135, var_128);
                var_137 = wp::where(var_133, var_134, var_129);
                // d = wp.dot(normal, FACE_NORMALS[i])                                        <L 352>
                var_139 = wp::extract(var_86, var_138);
                var_140 = wp::dot(var_normal, var_139);
                // if d > max_dot:                                                            <L 353>
                var_141 = (var_140 > var_137);
                if (var_141) {
                    // max_dot = d                                                            <L 354>
                    var_142 = wp::copy(var_140);
                    // best_slot = i                                                          <L 355>
                    var_143 = wp::copy(var_138);
                }
                var_144 = wp::where(var_141, var_143, var_136);
                var_145 = wp::where(var_141, var_142, var_137);
                // d = wp.dot(normal, FACE_NORMALS[i])                                        <L 352>
                var_147 = wp::extract(var_86, var_146);
                var_148 = wp::dot(var_normal, var_147);
                // if d > max_dot:                                                            <L 353>
                var_149 = (var_148 > var_145);
                if (var_149) {
                    // max_dot = d                                                            <L 354>
                    var_150 = wp::copy(var_148);
                    // best_slot = i                                                          <L 355>
                    var_151 = wp::copy(var_146);
                }
                var_152 = wp::where(var_149, var_151, var_144);
                var_153 = wp::where(var_149, var_150, var_145);
                // d = wp.dot(normal, FACE_NORMALS[i])                                        <L 352>
                var_155 = wp::extract(var_86, var_154);
                var_156 = wp::dot(var_normal, var_155);
                // if d > max_dot:                                                            <L 353>
                var_157 = (var_156 > var_153);
                if (var_157) {
                    // max_dot = d                                                            <L 354>
                    var_158 = wp::copy(var_156);
                    // best_slot = i                                                          <L 355>
                    var_159 = wp::copy(var_154);
                }
                var_160 = wp::where(var_157, var_159, var_152);
                var_161 = wp::where(var_157, var_158, var_153);
                // d = wp.dot(normal, FACE_NORMALS[i])                                        <L 352>
                var_163 = wp::extract(var_86, var_162);
                var_164 = wp::dot(var_normal, var_163);
                // if d > max_dot:                                                            <L 353>
                var_165 = (var_164 > var_161);
                if (var_165) {
                    // max_dot = d                                                            <L 354>
                    var_166 = wp::copy(var_164);
                    // best_slot = i                                                          <L 355>
                    var_167 = wp::copy(var_162);
                }
                var_168 = wp::where(var_165, var_167, var_160);
                var_169 = wp::where(var_165, var_166, var_161);
                // d = wp.dot(normal, FACE_NORMALS[i])                                        <L 352>
                var_171 = wp::extract(var_86, var_170);
                var_172 = wp::dot(var_normal, var_171);
                // if d > max_dot:                                                            <L 353>
                var_173 = (var_172 > var_169);
                if (var_173) {
                    // max_dot = d                                                            <L 354>
                    var_174 = wp::copy(var_172);
                    // best_slot = i                                                          <L 355>
                    var_175 = wp::copy(var_170);
                }
                var_176 = wp::where(var_173, var_175, var_168);
                var_177 = wp::where(var_173, var_174, var_169);
                // d = wp.dot(normal, FACE_NORMALS[i])                                        <L 352>
                var_179 = wp::extract(var_86, var_178);
                var_180 = wp::dot(var_normal, var_179);
                // if d > max_dot:                                                            <L 353>
                var_181 = (var_180 > var_177);
                if (var_181) {
                    // max_dot = d                                                            <L 354>
                    var_182 = wp::copy(var_180);
                    // best_slot = i                                                          <L 355>
                    var_183 = wp::copy(var_178);
                }
                var_184 = wp::where(var_181, var_183, var_176);
                var_185 = wp::where(var_181, var_182, var_177);
                // d = wp.dot(normal, FACE_NORMALS[i])                                        <L 352>
                var_187 = wp::extract(var_86, var_186);
                var_188 = wp::dot(var_normal, var_187);
                // if d > max_dot:                                                            <L 353>
                var_189 = (var_188 > var_185);
                if (var_189) {
                    // max_dot = d                                                            <L 354>
                    var_190 = wp::copy(var_188);
                    // best_slot = i                                                          <L 355>
                    var_191 = wp::copy(var_186);
                }
                var_192 = wp::where(var_189, var_191, var_184);
                var_193 = wp::where(var_189, var_190, var_185);
                // d = wp.dot(normal, FACE_NORMALS[i])                                        <L 352>
                var_195 = wp::extract(var_86, var_194);
                var_196 = wp::dot(var_normal, var_195);
                // if d > max_dot:                                                            <L 353>
                var_197 = (var_196 > var_193);
                if (var_197) {
                    // max_dot = d                                                            <L 354>
                    var_198 = wp::copy(var_196);
                    // best_slot = i                                                          <L 355>
                    var_199 = wp::copy(var_194);
                }
                var_200 = wp::where(var_197, var_199, var_192);
                var_201 = wp::where(var_197, var_198, var_193);
                // return best_slot                                                           <L 356>
                return var_200;
            }
            if (!var_84) {
                // best_slot = 5                                                              <L 358>
                // max_dot = wp.dot(normal, FACE_NORMALS[5])                                  <L 359>
                var_205 = wp::extract(var_203, var_204);
                var_206 = wp::dot(var_normal, var_205);
                // for i in range(6, 20):                                                     <L 360>
                // d = wp.dot(normal, FACE_NORMALS[i])                                        <L 361>
                var_208 = wp::extract(var_203, var_207);
                var_209 = wp::dot(var_normal, var_208);
                // if d > max_dot:                                                            <L 362>
                var_210 = (var_209 > var_206);
                if (var_210) {
                    // max_dot = d                                                            <L 363>
                    var_211 = wp::copy(var_209);
                    // best_slot = i                                                          <L 364>
                    var_212 = wp::copy(var_207);
                }
                var_213 = wp::where(var_210, var_212, var_202);
                var_214 = wp::where(var_210, var_211, var_206);
                // d = wp.dot(normal, FACE_NORMALS[i])                                        <L 361>
                var_216 = wp::extract(var_203, var_215);
                var_217 = wp::dot(var_normal, var_216);
                // if d > max_dot:                                                            <L 362>
                var_218 = (var_217 > var_214);
                if (var_218) {
                    // max_dot = d                                                            <L 363>
                    var_219 = wp::copy(var_217);
                    // best_slot = i                                                          <L 364>
                    var_220 = wp::copy(var_215);
                }
                var_221 = wp::where(var_218, var_220, var_213);
                var_222 = wp::where(var_218, var_219, var_214);
                // d = wp.dot(normal, FACE_NORMALS[i])                                        <L 361>
                var_224 = wp::extract(var_203, var_223);
                var_225 = wp::dot(var_normal, var_224);
                // if d > max_dot:                                                            <L 362>
                var_226 = (var_225 > var_222);
                if (var_226) {
                    // max_dot = d                                                            <L 363>
                    var_227 = wp::copy(var_225);
                    // best_slot = i                                                          <L 364>
                    var_228 = wp::copy(var_223);
                }
                var_229 = wp::where(var_226, var_228, var_221);
                var_230 = wp::where(var_226, var_227, var_222);
                // d = wp.dot(normal, FACE_NORMALS[i])                                        <L 361>
                var_232 = wp::extract(var_203, var_231);
                var_233 = wp::dot(var_normal, var_232);
                // if d > max_dot:                                                            <L 362>
                var_234 = (var_233 > var_230);
                if (var_234) {
                    // max_dot = d                                                            <L 363>
                    var_235 = wp::copy(var_233);
                    // best_slot = i                                                          <L 364>
                    var_236 = wp::copy(var_231);
                }
                var_237 = wp::where(var_234, var_236, var_229);
                var_238 = wp::where(var_234, var_235, var_230);
                // d = wp.dot(normal, FACE_NORMALS[i])                                        <L 361>
                var_240 = wp::extract(var_203, var_239);
                var_241 = wp::dot(var_normal, var_240);
                // if d > max_dot:                                                            <L 362>
                var_242 = (var_241 > var_238);
                if (var_242) {
                    // max_dot = d                                                            <L 363>
                    var_243 = wp::copy(var_241);
                    // best_slot = i                                                          <L 364>
                    var_244 = wp::copy(var_239);
                }
                var_245 = wp::where(var_242, var_244, var_237);
                var_246 = wp::where(var_242, var_243, var_238);
                // d = wp.dot(normal, FACE_NORMALS[i])                                        <L 361>
                var_248 = wp::extract(var_203, var_247);
                var_249 = wp::dot(var_normal, var_248);
                // if d > max_dot:                                                            <L 362>
                var_250 = (var_249 > var_246);
                if (var_250) {
                    // max_dot = d                                                            <L 363>
                    var_251 = wp::copy(var_249);
                    // best_slot = i                                                          <L 364>
                    var_252 = wp::copy(var_247);
                }
                var_253 = wp::where(var_250, var_252, var_245);
                var_254 = wp::where(var_250, var_251, var_246);
                // d = wp.dot(normal, FACE_NORMALS[i])                                        <L 361>
                var_256 = wp::extract(var_203, var_255);
                var_257 = wp::dot(var_normal, var_256);
                // if d > max_dot:                                                            <L 362>
                var_258 = (var_257 > var_254);
                if (var_258) {
                    // max_dot = d                                                            <L 363>
                    var_259 = wp::copy(var_257);
                    // best_slot = i                                                          <L 364>
                    var_260 = wp::copy(var_255);
                }
                var_261 = wp::where(var_258, var_260, var_253);
                var_262 = wp::where(var_258, var_259, var_254);
                // d = wp.dot(normal, FACE_NORMALS[i])                                        <L 361>
                var_264 = wp::extract(var_203, var_263);
                var_265 = wp::dot(var_normal, var_264);
                // if d > max_dot:                                                            <L 362>
                var_266 = (var_265 > var_262);
                if (var_266) {
                    // max_dot = d                                                            <L 363>
                    var_267 = wp::copy(var_265);
                    // best_slot = i                                                          <L 364>
                    var_268 = wp::copy(var_263);
                }
                var_269 = wp::where(var_266, var_268, var_261);
                var_270 = wp::where(var_266, var_267, var_262);
                // d = wp.dot(normal, FACE_NORMALS[i])                                        <L 361>
                var_272 = wp::extract(var_203, var_271);
                var_273 = wp::dot(var_normal, var_272);
                // if d > max_dot:                                                            <L 362>
                var_274 = (var_273 > var_270);
                if (var_274) {
                    // max_dot = d                                                            <L 363>
                    var_275 = wp::copy(var_273);
                    // best_slot = i                                                          <L 364>
                    var_276 = wp::copy(var_271);
                }
                var_277 = wp::where(var_274, var_276, var_269);
                var_278 = wp::where(var_274, var_275, var_270);
                // d = wp.dot(normal, FACE_NORMALS[i])                                        <L 361>
                var_280 = wp::extract(var_203, var_279);
                var_281 = wp::dot(var_normal, var_280);
                // if d > max_dot:                                                            <L 362>
                var_282 = (var_281 > var_278);
                if (var_282) {
                    // max_dot = d                                                            <L 363>
                    var_283 = wp::copy(var_281);
                    // best_slot = i                                                          <L 364>
                    var_284 = wp::copy(var_279);
                }
                var_285 = wp::where(var_282, var_284, var_277);
                var_286 = wp::where(var_282, var_283, var_278);
                // d = wp.dot(normal, FACE_NORMALS[i])                                        <L 361>
                var_288 = wp::extract(var_203, var_287);
                var_289 = wp::dot(var_normal, var_288);
                // if d > max_dot:                                                            <L 362>
                var_290 = (var_289 > var_286);
                if (var_290) {
                    // max_dot = d                                                            <L 363>
                    var_291 = wp::copy(var_289);
                    // best_slot = i                                                          <L 364>
                    var_292 = wp::copy(var_287);
                }
                var_293 = wp::where(var_290, var_292, var_285);
                var_294 = wp::where(var_290, var_291, var_286);
                // d = wp.dot(normal, FACE_NORMALS[i])                                        <L 361>
                var_296 = wp::extract(var_203, var_295);
                var_297 = wp::dot(var_normal, var_296);
                // if d > max_dot:                                                            <L 362>
                var_298 = (var_297 > var_294);
                if (var_298) {
                    // max_dot = d                                                            <L 363>
                    var_299 = wp::copy(var_297);
                    // best_slot = i                                                          <L 364>
                    var_300 = wp::copy(var_295);
                }
                var_301 = wp::where(var_298, var_300, var_293);
                var_302 = wp::where(var_298, var_299, var_294);
                // d = wp.dot(normal, FACE_NORMALS[i])                                        <L 361>
                var_304 = wp::extract(var_203, var_303);
                var_305 = wp::dot(var_normal, var_304);
                // if d > max_dot:                                                            <L 362>
                var_306 = (var_305 > var_302);
                if (var_306) {
                    // max_dot = d                                                            <L 363>
                    var_307 = wp::copy(var_305);
                    // best_slot = i                                                          <L 364>
                    var_308 = wp::copy(var_303);
                }
                var_309 = wp::where(var_306, var_308, var_301);
                var_310 = wp::where(var_306, var_307, var_302);
                // d = wp.dot(normal, FACE_NORMALS[i])                                        <L 361>
                var_312 = wp::extract(var_203, var_311);
                var_313 = wp::dot(var_normal, var_312);
                // if d > max_dot:                                                            <L 362>
                var_314 = (var_313 > var_310);
                if (var_314) {
                    // max_dot = d                                                            <L 363>
                    var_315 = wp::copy(var_313);
                    // best_slot = i                                                          <L 364>
                    var_316 = wp::copy(var_311);
                }
                var_317 = wp::where(var_314, var_316, var_309);
                var_318 = wp::where(var_314, var_315, var_310);
                // return best_slot                                                           <L 365>
                return var_317;
            }
            var_319 = wp::where(var_84, var_200, var_317);
            var_320 = wp::where(var_84, var_86, var_203);
            var_321 = wp::where(var_84, var_201, var_318);
            var_322 = wp::where(var_84, var_194, var_311);
            var_323 = wp::where(var_84, var_196, var_313);
        }
        var_324 = wp::where(var_45, var_81, var_319);
        var_325 = wp::where(var_45, var_47, var_320);
        var_326 = wp::where(var_45, var_82, var_321);
        var_327 = wp::where(var_45, var_75, var_322);
        var_328 = wp::where(var_45, var_77, var_323);
    }
    var_329 = wp::where(var_6, var_42, var_324);
    var_330 = wp::where(var_6, var_8, var_325);
    var_331 = wp::where(var_6, var_43, var_326);
    var_332 = wp::where(var_6, var_36, var_327);
    var_333 = wp::where(var_6, var_38, var_328);
    return {};
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction.py:210
static CUDA_CALLABLE wp::vec_t<3, wp::float32> get_face_normal_0(
    wp::int32 var_face_idx)
{
    //---------
    // primal vars
    const bool var_0 = false;
    const wp::int32 var_1 = 0;
    bool var_2;
    const wp::float32 var_3 = 0.49112338;
    const wp::float32 var_4 = 0.79465455;
    const wp::float32 var_5 = 0.35682216;
    wp::vec_t<3, wp::float32> var_6;
    const wp::int32 var_7 = 1;
    bool var_8;
    const wp::float32 var_9 = -0.18759243;
    const wp::float32 var_10 = 0.7946545;
    const wp::float32 var_11 = 0.57735026;
    wp::vec_t<3, wp::float32> var_12;
    const wp::int32 var_13 = 2;
    bool var_14;
    const wp::float32 var_15 = -0.6070619;
    const wp::float32 var_16 = 0.7946545;
    const wp::float32 var_17 = 0.0;
    wp::vec_t<3, wp::float32> var_18;
    const wp::int32 var_19 = 3;
    bool var_20;
    const wp::float32 var_21 = -0.18759237;
    const wp::float32 var_22 = 0.7946545;
    const wp::float32 var_23 = -0.57735026;
    wp::vec_t<3, wp::float32> var_24;
    const wp::int32 var_25 = 4;
    bool var_26;
    const wp::float32 var_27 = 0.4911234;
    const wp::float32 var_28 = 0.79465455;
    const wp::float32 var_29 = -0.3568221;
    wp::vec_t<3, wp::float32> var_30;
    const wp::int32 var_31 = 5;
    bool var_32;
    const wp::float32 var_33 = 0.9822469;
    const wp::float32 var_34 = -0.18759257;
    const wp::float32 var_35 = 0.0;
    wp::vec_t<3, wp::float32> var_36;
    const wp::int32 var_37 = 6;
    bool var_38;
    const wp::float32 var_39 = 0.7946544;
    const wp::float32 var_40 = 0.18759239;
    const wp::float32 var_41 = -0.5773503;
    wp::vec_t<3, wp::float32> var_42;
    const wp::int32 var_43 = 7;
    bool var_44;
    const wp::float32 var_45 = 0.30353096;
    const wp::float32 var_46 = -0.18759252;
    const wp::float32 var_47 = 0.93417233;
    wp::vec_t<3, wp::float32> var_48;
    const wp::int32 var_49 = 8;
    bool var_50;
    const wp::float32 var_51 = 0.7946544;
    const wp::float32 var_52 = 0.18759243;
    const wp::float32 var_53 = 0.5773503;
    wp::vec_t<3, wp::float32> var_54;
    const wp::int32 var_55 = 9;
    bool var_56;
    const wp::float32 var_57 = -0.7946545;
    const wp::float32 var_58 = -0.18759249;
    const wp::float32 var_59 = 0.5773503;
    wp::vec_t<3, wp::float32> var_60;
    const wp::int32 var_61 = 10;
    bool var_62;
    const wp::float32 var_63 = -0.30353105;
    const wp::float32 var_64 = 0.18759243;
    const wp::float32 var_65 = 0.9341724;
    wp::vec_t<3, wp::float32> var_66;
    const wp::int32 var_67 = 11;
    bool var_68;
    const wp::float32 var_69 = -0.7946544;
    const wp::float32 var_70 = -0.1875924;
    const wp::float32 var_71 = -0.5773503;
    wp::vec_t<3, wp::float32> var_72;
    const wp::int32 var_73 = 12;
    bool var_74;
    const wp::float32 var_75 = -0.9822469;
    const wp::float32 var_76 = 0.18759254;
    const wp::float32 var_77 = 0.0;
    wp::vec_t<3, wp::float32> var_78;
    const wp::int32 var_79 = 13;
    bool var_80;
    const wp::float32 var_81 = 0.30353096;
    const wp::float32 var_82 = -0.1875925;
    const wp::float32 var_83 = -0.93417233;
    wp::vec_t<3, wp::float32> var_84;
    const wp::int32 var_85 = 14;
    bool var_86;
    const wp::float32 var_87 = -0.30353084;
    const wp::float32 var_88 = 0.18759246;
    const wp::float32 var_89 = -0.9341724;
    wp::vec_t<3, wp::float32> var_90;
    const wp::int32 var_91 = 15;
    bool var_92;
    const wp::float32 var_93 = 0.18759249;
    const wp::float32 var_94 = -0.7946544;
    const wp::float32 var_95 = 0.57735026;
    wp::vec_t<3, wp::float32> var_96;
    const wp::int32 var_97 = 16;
    bool var_98;
    const wp::float32 var_99 = -0.49112338;
    const wp::float32 var_100 = -0.7946545;
    const wp::float32 var_101 = 0.35682213;
    wp::vec_t<3, wp::float32> var_102;
    const wp::int32 var_103 = 17;
    bool var_104;
    const wp::float32 var_105 = -0.49112338;
    const wp::float32 var_106 = -0.79465455;
    const wp::float32 var_107 = -0.35682213;
    wp::vec_t<3, wp::float32> var_108;
    const wp::int32 var_109 = 18;
    bool var_110;
    const wp::float32 var_111 = 0.18759243;
    const wp::float32 var_112 = -0.7946544;
    const wp::float32 var_113 = -0.57735026;
    wp::vec_t<3, wp::float32> var_114;
    const wp::float32 var_115 = 0.607062;
    const wp::float32 var_116 = -0.7946544;
    const wp::float32 var_117 = 0.0;
    wp::vec_t<3, wp::float32> var_118;
    //---------
    // forward
    // def get_face_normal(face_idx: int) -> wp.vec3:                                         <L 211>
    // if wp.static(NORMAL_BINNING_POLYHEDRON != "icosahedron"):                              <L 213>
    // if face_idx == 0:                                                                      <L 215>
    var_2 = (var_face_idx == var_1);
    if (var_2) {
        // return wp.vec3(0.49112338, 0.79465455, 0.35682216)                                 <L 216>
        var_6 = wp::vec_t<3, wp::float32>(var_3, var_4, var_5);
        return var_6;
    }
    // if face_idx == 1:                                                                      <L 217>
    var_8 = (var_face_idx == var_7);
    if (var_8) {
        // return wp.vec3(-0.18759243, 0.79465450, 0.57735026)                                <L 218>
        var_12 = wp::vec_t<3, wp::float32>(var_9, var_10, var_11);
        return var_12;
    }
    // if face_idx == 2:                                                                      <L 219>
    var_14 = (var_face_idx == var_13);
    if (var_14) {
        // return wp.vec3(-0.60706190, 0.79465450, 0.0)                                       <L 220>
        var_18 = wp::vec_t<3, wp::float32>(var_15, var_16, var_17);
        return var_18;
    }
    // if face_idx == 3:                                                                      <L 221>
    var_20 = (var_face_idx == var_19);
    if (var_20) {
        // return wp.vec3(-0.18759237, 0.79465450, -0.57735026)                               <L 222>
        var_24 = wp::vec_t<3, wp::float32>(var_21, var_22, var_23);
        return var_24;
    }
    // if face_idx == 4:                                                                      <L 223>
    var_26 = (var_face_idx == var_25);
    if (var_26) {
        // return wp.vec3(0.49112340, 0.79465455, -0.35682210)                                <L 224>
        var_30 = wp::vec_t<3, wp::float32>(var_27, var_28, var_29);
        return var_30;
    }
    // if face_idx == 5:                                                                      <L 225>
    var_32 = (var_face_idx == var_31);
    if (var_32) {
        // return wp.vec3(0.98224690, -0.18759257, 0.0)                                       <L 226>
        var_36 = wp::vec_t<3, wp::float32>(var_33, var_34, var_35);
        return var_36;
    }
    // if face_idx == 6:                                                                      <L 227>
    var_38 = (var_face_idx == var_37);
    if (var_38) {
        // return wp.vec3(0.79465440, 0.18759239, -0.57735030)                                <L 228>
        var_42 = wp::vec_t<3, wp::float32>(var_39, var_40, var_41);
        return var_42;
    }
    // if face_idx == 7:                                                                      <L 229>
    var_44 = (var_face_idx == var_43);
    if (var_44) {
        // return wp.vec3(0.30353096, -0.18759252, 0.93417233)                                <L 230>
        var_48 = wp::vec_t<3, wp::float32>(var_45, var_46, var_47);
        return var_48;
    }
    // if face_idx == 8:                                                                      <L 231>
    var_50 = (var_face_idx == var_49);
    if (var_50) {
        // return wp.vec3(0.79465440, 0.18759243, 0.57735030)                                 <L 232>
        var_54 = wp::vec_t<3, wp::float32>(var_51, var_52, var_53);
        return var_54;
    }
    // if face_idx == 9:                                                                      <L 233>
    var_56 = (var_face_idx == var_55);
    if (var_56) {
        // return wp.vec3(-0.79465450, -0.18759249, 0.57735030)                               <L 234>
        var_60 = wp::vec_t<3, wp::float32>(var_57, var_58, var_59);
        return var_60;
    }
    // if face_idx == 10:                                                                     <L 235>
    var_62 = (var_face_idx == var_61);
    if (var_62) {
        // return wp.vec3(-0.30353105, 0.18759243, 0.93417240)                                <L 236>
        var_66 = wp::vec_t<3, wp::float32>(var_63, var_64, var_65);
        return var_66;
    }
    // if face_idx == 11:                                                                     <L 237>
    var_68 = (var_face_idx == var_67);
    if (var_68) {
        // return wp.vec3(-0.79465440, -0.18759240, -0.57735030)                              <L 238>
        var_72 = wp::vec_t<3, wp::float32>(var_69, var_70, var_71);
        return var_72;
    }
    // if face_idx == 12:                                                                     <L 239>
    var_74 = (var_face_idx == var_73);
    if (var_74) {
        // return wp.vec3(-0.98224690, 0.18759254, 0.0)                                       <L 240>
        var_78 = wp::vec_t<3, wp::float32>(var_75, var_76, var_77);
        return var_78;
    }
    // if face_idx == 13:                                                                     <L 241>
    var_80 = (var_face_idx == var_79);
    if (var_80) {
        // return wp.vec3(0.30353096, -0.18759250, -0.93417233)                               <L 242>
        var_84 = wp::vec_t<3, wp::float32>(var_81, var_82, var_83);
        return var_84;
    }
    // if face_idx == 14:                                                                     <L 243>
    var_86 = (var_face_idx == var_85);
    if (var_86) {
        // return wp.vec3(-0.30353084, 0.18759246, -0.93417240)                               <L 244>
        var_90 = wp::vec_t<3, wp::float32>(var_87, var_88, var_89);
        return var_90;
    }
    // if face_idx == 15:                                                                     <L 245>
    var_92 = (var_face_idx == var_91);
    if (var_92) {
        // return wp.vec3(0.18759249, -0.79465440, 0.57735026)                                <L 246>
        var_96 = wp::vec_t<3, wp::float32>(var_93, var_94, var_95);
        return var_96;
    }
    // if face_idx == 16:                                                                     <L 247>
    var_98 = (var_face_idx == var_97);
    if (var_98) {
        // return wp.vec3(-0.49112338, -0.79465450, 0.35682213)                               <L 248>
        var_102 = wp::vec_t<3, wp::float32>(var_99, var_100, var_101);
        return var_102;
    }
    // if face_idx == 17:                                                                     <L 249>
    var_104 = (var_face_idx == var_103);
    if (var_104) {
        // return wp.vec3(-0.49112338, -0.79465455, -0.35682213)                              <L 250>
        var_108 = wp::vec_t<3, wp::float32>(var_105, var_106, var_107);
        return var_108;
    }
    // if face_idx == 18:                                                                     <L 251>
    var_110 = (var_face_idx == var_109);
    if (var_110) {
        // return wp.vec3(0.18759243, -0.79465440, -0.57735026)                               <L 252>
        var_114 = wp::vec_t<3, wp::float32>(var_111, var_112, var_113);
        return var_114;
    }
    // return wp.vec3(0.60706200, -0.79465440, 0.0)                                           <L 253>
    var_118 = wp::vec_t<3, wp::float32>(var_115, var_116, var_117);
    return var_118;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction.py:378
static CUDA_CALLABLE wp::vec_t<2, wp::float32> project_point_to_plane_0(
    wp::int32 var_bin_normal_idx,
    wp::vec_t<3, wp::float32> var_point)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    const wp::int32 var_1 = 1;
    wp::float32 var_2;
    wp::float32 var_3;
    const wp::float32 var_4 = 0.9;
    bool var_5;
    const wp::float32 var_6 = 0.0;
    const wp::float32 var_7 = 1.0;
    const wp::float32 var_8 = 0.0;
    wp::vec_t<3, wp::float32> var_9;
    const wp::float32 var_10 = 1.0;
    const wp::float32 var_11 = 0.0;
    const wp::float32 var_12 = 0.0;
    wp::vec_t<3, wp::float32> var_13;
    wp::vec_t<3, wp::float32> var_14;
    wp::float32 var_15;
    wp::vec_t<3, wp::float32> var_16;
    wp::vec_t<3, wp::float32> var_17;
    wp::vec_t<3, wp::float32> var_18;
    wp::vec_t<3, wp::float32> var_19;
    wp::float32 var_20;
    wp::float32 var_21;
    wp::vec_t<2, wp::float32> var_22;
    //---------
    // forward
    // def project_point_to_plane(bin_normal_idx: wp.int32, point: wp.vec3) -> wp.vec2:       <L 379>
    // face_normal = get_face_normal(bin_normal_idx)                                          <L 392>
    var_0 = get_face_normal_0(var_bin_normal_idx);
    // if wp.abs(face_normal[1]) < 0.9:                                                       <L 394>
    var_2 = wp::extract(var_0, var_1);
    var_3 = wp::abs(var_2);
    var_5 = (var_3 < var_4);
    if (var_5) {
        // ref = wp.vec3(0.0, 1.0, 0.0)                                                       <L 395>
        var_9 = wp::vec_t<3, wp::float32>(var_6, var_7, var_8);
    }
    if (!var_5) {
        // ref = wp.vec3(1.0, 0.0, 0.0)                                                       <L 397>
        var_13 = wp::vec_t<3, wp::float32>(var_10, var_11, var_12);
    }
    var_14 = wp::where(var_5, var_9, var_13);
    // u = wp.normalize(ref - wp.dot(ref, face_normal) * face_normal)                         <L 399>
    var_15 = wp::dot(var_14, var_0);
    var_16 = wp::mul(var_15, var_0);
    var_17 = wp::sub(var_14, var_16);
    var_18 = wp::normalize(var_17);
    // v = wp.cross(face_normal, u)                                                           <L 400>
    var_19 = wp::cross(var_0, var_18);
    // return wp.vec2(wp.dot(point, u), wp.dot(point, v))                                     <L 402>
    var_20 = wp::dot(var_point, var_18);
    var_21 = wp::dot(var_point, var_19);
    var_22 = wp::vec_t<2, wp::float32>(var_20, var_21);
    return var_22;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:328
static CUDA_CALLABLE wp::uint64 make_contact_key_0(
    wp::int32 var_shape_a,
    wp::int32 var_shape_b,
    wp::int32 var_bin_id)
{
    //---------
    // primal vars
    wp::uint64 var_0;
    const wp::uint64 var_1 = 134217727ull;
    wp::uint64 var_2;
    wp::uint64 var_3;
    const wp::uint64 var_4 = 268435455ull;
    wp::uint64 var_5;
    const wp::uint64 var_6 = 27ull;
    wp::uint64 var_7;
    wp::uint64 var_8;
    wp::uint64 var_9;
    const wp::uint64 var_10 = 255ull;
    wp::uint64 var_11;
    wp::uint64 var_12;
    wp::uint64 var_13;
    wp::uint64 var_14;
    //---------
    // forward
    // def make_contact_key(shape_a: int, shape_b: int, bin_id: int) -> wp.uint64:            <L 329>
    // key = wp.uint64(shape_a) & SHAPE_A_MASK                                                <L 340>
    var_0 = wp::uint64(var_shape_a);
    var_2 = wp::bit_and(var_0, var_1);
    // key = key | ((wp.uint64(shape_b) & SHAPE_B_MASK) << SHAPE_A_BITS)                      <L 341>
    var_3 = wp::uint64(var_shape_b);
    var_5 = wp::bit_and(var_3, var_4);
    var_7 = wp::lshift(var_5, var_6);
    var_8 = wp::bit_or(var_2, var_7);
    // key = key | ((wp.uint64(bin_id) & BIN_MASK) << wp.uint64(55))                          <L 343>
    var_9 = wp::uint64(var_bin_id);
    var_11 = wp::bit_and(var_9, var_10);
    var_12 = 55ull;
    var_13 = wp::lshift(var_11, var_12);
    var_14 = wp::bit_or(var_8, var_13);
    // return key                                                                             <L 344>
    return var_14;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/hashtable.py:55
static CUDA_CALLABLE wp::int32 _hashtable_hash_0(
    wp::uint64 var_key,
    wp::int32 var_capacity_mask)
{
    //---------
    // primal vars
    wp::uint64 var_0;
    wp::uint64 var_1;
    wp::uint64 var_2;
    wp::uint64 var_3;
    const wp::uint64 var_4 = 18397679294719823053ull;
    wp::uint64 var_5;
    wp::uint64 var_6;
    wp::uint64 var_7;
    wp::uint64 var_8;
    wp::int32 var_9;
    wp::int32 var_10;
    //---------
    // forward
    // def _hashtable_hash(key: wp.uint64, capacity_mask: int) -> int:                        <L 56>
    // h = key                                                                                <L 58>
    var_0 = wp::copy(var_key);
    // h = h ^ (h >> wp.uint64(33))                                                           <L 59>
    var_1 = 33ull;
    var_2 = wp::rshift(var_0, var_1);
    var_3 = wp::bit_xor(var_0, var_2);
    // h = h * HASH_MIX_MULTIPLIER                                                            <L 60>
    var_5 = wp::mul(var_3, var_4);
    // h = h ^ (h >> wp.uint64(33))                                                           <L 61>
    var_6 = 33ull;
    var_7 = wp::rshift(var_5, var_6);
    var_8 = wp::bit_xor(var_5, var_7);
    // return int(h) & capacity_mask                                                          <L 62>
    var_9 = wp::int(var_8);
    var_10 = wp::bit_and(var_9, var_capacity_mask);
    return var_10;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/hashtable.py:106
static CUDA_CALLABLE wp::int32 hashtable_find_or_insert_0(
    wp::uint64 var_key,
    wp::array_t<wp::uint64> var_keys,
    wp::array_t<wp::int32> var_active_slots)
{
    //---------
    // primal vars
    wp::shape_t* var_0;
    const wp::int32 var_1 = 0;
    wp::int32 var_2;
    wp::shape_t var_3;
    const wp::int32 var_4 = 1;
    wp::int32 var_5;
    wp::int32 var_6;
    wp::range_t var_7;
    wp::int32 var_8;
    wp::uint64* var_9;
    wp::uint64 var_10;
    wp::uint64 var_11;
    bool var_12;
    const wp::uint64 var_13 = 18446744073709551615ull;
    bool var_14;
    wp::uint64 var_15;
    bool var_16;
    const wp::int32 var_17 = 1;
    wp::int32 var_18;
    bool var_19;
    bool var_20;
    const wp::int32 var_21 = 1;
    wp::int32 var_22;
    wp::int32 var_23;
    const wp::int32 var_24 = -1;
    //---------
    // forward
    // def hashtable_find_or_insert(                                                          <L 107>
    // capacity = keys.shape[0]                                                               <L 126>
    var_0 = &(var_keys.shape);
    var_3 = wp::load(var_0);
    var_2 = wp::extract(var_3, var_1);
    // capacity_mask = capacity - 1                                                           <L 127>
    var_5 = wp::sub(var_2, var_4);
    // idx = _hashtable_hash(key, capacity_mask)                                              <L 128>
    var_6 = _hashtable_hash_0(var_key, var_5);
    // for _i in range(capacity):                                                             <L 131>
    var_7 = wp::range(var_2);
    start_for_0:;
        if (iter_cmp(var_7) == 0) goto end_for_0;
        var_8 = wp::iter_next(var_7);
        // stored_key = keys[idx]                                                             <L 133>
        var_9 = wp::address(var_keys, var_6);
        var_11 = wp::load(var_9);
        var_10 = wp::copy(var_11);
        // if stored_key == key:                                                              <L 135>
        var_12 = (var_10 == var_key);
        if (var_12) {
            // return idx                                                                     <L 137>
            return var_6;
        }
        // if stored_key == HASHTABLE_EMPTY_KEY:                                              <L 139>
        var_14 = (var_10 == var_13);
        if (var_14) {
            // old_key = wp.atomic_cas(keys, idx, HASHTABLE_EMPTY_KEY, key)                   <L 141>
            var_15 = wp::atomic_cas(var_keys, var_6, var_13, var_key);
            // if old_key == HASHTABLE_EMPTY_KEY:                                             <L 143>
            var_16 = (var_15 == var_13);
            if (var_16) {
                // active_idx = wp.atomic_add(active_slots, capacity, 1)                      <L 146>
                var_18 = wp::atomic_add(var_active_slots, var_2, var_17);
                // if active_idx < capacity:                                                  <L 147>
                var_19 = (var_18 < var_2);
                if (var_19) {
                    // active_slots[active_idx] = idx                                         <L 148>
                    wp::array_store(var_active_slots, var_18, var_6);
                }
                // return idx                                                                 <L 149>
                return var_6;
            }
            if (!var_16) {
                // elif old_key == key:                                                       <L 150>
                var_20 = (var_15 == var_key);
                if (var_20) {
                    // return idx                                                             <L 152>
                    return var_6;
                }
            }
        }
        // idx = (idx + 1) & capacity_mask                                                    <L 156>
        var_22 = wp::add(var_6, var_21);
        var_23 = wp::bit_and(var_22, var_5);
        wp::assign(var_6, var_23);
        goto start_for_0;
    end_for_0:;
    // return -1                                                                              <L 159>
    return var_24;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction.py:405
static CUDA_CALLABLE wp::vec_t<2, wp::float32> get_spatial_direction_2d_0(
    wp::int32 var_dir_idx)
{
    //---------
    // primal vars
    wp::float32 var_0;
    const wp::float32 var_1 = 2.0;
    const wp::float32 var_2 = 3.141592653589793;
    wp::float32 var_3;
    const wp::int32 var_4 = 6;
    wp::float32 var_5;
    wp::float32 var_6;
    wp::float32 var_7;
    wp::float32 var_8;
    wp::float32 var_9;
    wp::vec_t<2, wp::float32> var_10;
    //---------
    // forward
    // def get_spatial_direction_2d(dir_idx: int) -> wp.vec2:                                 <L 406>
    // angle = float(dir_idx) * (2.0 * wp.pi / float(wp.static(NUM_SPATIAL_DIRECTIONS)))       <L 415>
    var_0 = wp::float(var_dir_idx);
    var_3 = wp::mul(var_1, var_2);
    var_5 = wp::float(var_4);
    var_6 = wp::div(var_3, var_5);
    var_7 = wp::mul(var_0, var_6);
    // return wp.vec2(wp.cos(angle), wp.sin(angle))                                           <L 416>
    var_8 = wp::cos(var_7);
    var_9 = wp::sin(var_7);
    var_10 = wp::vec_t<2, wp::float32>(var_8, var_9);
    return var_10;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction.py:104
static CUDA_CALLABLE wp::uint32 float_flip_0(
    wp::float32 f)
{

uint32_t i = reinterpret_cast<uint32_t&>(f);
uint32_t mask = (uint32_t)(-(int)(i >> 31)) | 0x80000000;
return i ^ mask;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:446
static CUDA_CALLABLE wp::uint64 _make_contact_value_det_0(
    wp::float32 var_score,
    wp::int32 var_fingerprint,
    wp::int32 var_contact_id)
{
    //---------
    // primal vars
    wp::uint32 var_0;
    const wp::int32 var_1 = 10;
    wp::uint32 var_2;
    wp::uint32 var_3;
    wp::uint64 var_4;
    wp::uint64 var_5;
    wp::uint64 var_6;
    wp::uint64 var_7;
    const wp::uint64 var_8 = 4194303ull;
    wp::uint64 var_9;
    const wp::uint64 var_10 = 20ull;
    wp::uint64 var_11;
    wp::uint64 var_12;
    wp::uint64 var_13;
    const wp::uint64 var_14 = 1048575ull;
    wp::uint64 var_15;
    wp::uint64 var_16;
    //---------
    // forward
    // def _make_contact_value_det(score: float, fingerprint: int, contact_id: int) -> wp.uint64:       <L 447>
    // return (                                                                               <L 502>
    // (wp.uint64(float_flip(score) >> wp.uint32(wp.static(SCORE_SHIFT))) << wp.uint64(42))       <L 503>
    var_0 = float_flip_0(var_score);
    var_2 = wp::uint32(var_1);
    var_3 = wp::rshift(var_0, var_2);
    var_4 = wp::uint64(var_3);
    var_5 = 42ull;
    var_6 = wp::lshift(var_4, var_5);
    // | ((wp.uint64(fingerprint) & FINGERPRINT_MASK) << CONTACT_ID_BITS)                     <L 504>
    var_7 = wp::uint64(var_fingerprint);
    var_9 = wp::bit_and(var_7, var_8);
    var_11 = wp::lshift(var_9, var_10);
    var_12 = wp::bit_or(var_6, var_11);
    // | (wp.uint64(contact_id) & CONTACT_ID_MASK)                                            <L 505>
    var_13 = wp::uint64(var_contact_id);
    var_15 = wp::bit_and(var_13, var_14);
    var_16 = wp::bit_or(var_12, var_15);
    return var_16;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:379
static CUDA_CALLABLE wp::uint64 _make_contact_value_fast_0(
    wp::float32 var_score,
    wp::int32 var_fingerprint,
    wp::int32 var_contact_id)
{
    //---------
    // primal vars
    wp::uint32 var_0;
    wp::uint64 var_1;
    wp::uint64 var_2;
    wp::uint64 var_3;
    wp::uint64 var_4;
    wp::uint64 var_5;
    //---------
    // forward
    // def _make_contact_value_fast(score: float, fingerprint: int, contact_id: int) -> wp.uint64:       <L 380>
    // return (wp.uint64(float_flip(score)) << wp.uint64(32)) | wp.uint64(contact_id)         <L 400>
    var_0 = float_flip_0(var_score);
    var_1 = wp::uint64(var_0);
    var_2 = 32ull;
    var_3 = wp::lshift(var_1, var_2);
    var_4 = wp::uint64(var_contact_id);
    var_5 = wp::bit_or(var_3, var_4);
    return var_5;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:573
static CUDA_CALLABLE wp::uint64 make_contact_value_0(
    wp::float32 var_score,
    wp::int32 var_fingerprint,
    wp::int32 var_contact_id,
    wp::int32 var_deterministic)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    bool var_1;
    wp::uint64 var_2;
    wp::uint64 var_3;
    //---------
    // forward
    // def make_contact_value(score: float, fingerprint: int, contact_id: int, deterministic: int) -> wp.uint64:       <L 574>
    // if deterministic != 0:                                                                 <L 587>
    var_1 = (var_deterministic != var_0);
    if (var_1) {
        // return _make_contact_value_det(score, fingerprint, contact_id)                     <L 588>
        var_2 = _make_contact_value_det_0(var_score, var_fingerprint, var_contact_id);
        return var_2;
    }
    // return _make_contact_value_fast(score, fingerprint, contact_id)                        <L 589>
    var_3 = _make_contact_value_fast_0(var_score, var_fingerprint, var_contact_id);
    return var_3;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:204
static CUDA_CALLABLE void reduction_update_slot_0(
    wp::int32 var_entry_idx,
    wp::int32 var_slot_id,
    wp::uint64 var_value,
    wp::array_t<wp::uint64> var_values,
    wp::int32 var_capacity)
{
    //---------
    // primal vars
    wp::int32 var_0;
    wp::int32 var_1;
    wp::uint64* var_2;
    bool var_3;
    wp::uint64 var_4;
    wp::uint64 var_5;
    //---------
    // forward
    // def reduction_update_slot(                                                             <L 205>
    // value_idx = slot_id * capacity + entry_idx                                             <L 224>
    var_0 = wp::mul(var_slot_id, var_capacity);
    var_1 = wp::add(var_0, var_entry_idx);
    // if values[value_idx] < value:                                                          <L 226>
    var_2 = wp::address(var_values, var_1);
    var_4 = wp::load(var_2);
    var_3 = (var_4 < var_value);
    if (var_3) {
        // wp.atomic_max(values, value_idx, value)                                            <L 227>
        var_5 = wp::atomic_max(var_values, var_1, var_value);
    }
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction.py:429
static CUDA_CALLABLE wp::int32 compute_voxel_index_0(
    wp::vec_t<3, wp::float32> var_pos_local,
    wp::vec_t<3, wp::float32> var_aabb_lower,
    wp::vec_t<3, wp::float32> var_aabb_upper,
    wp::vec_t<3, wp::int32> var_resolution)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    const wp::float32 var_1 = 0.0;
    const wp::float32 var_2 = 0.0;
    const wp::float32 var_3 = 0.0;
    wp::vec_t<3, wp::float32> var_4;
    const wp::int32 var_5 = 0;
    wp::float32 var_6;
    const wp::float32 var_7 = 1e-06;
    bool var_8;
    const wp::int32 var_9 = 0;
    wp::float32 var_10;
    const wp::int32 var_11 = 0;
    wp::float32 var_12;
    wp::float32 var_13;
    const wp::int32 var_14 = 0;
    wp::float32 var_15;
    wp::float32 var_16;
    const wp::int32 var_17 = 1;
    wp::float32 var_18;
    const wp::int32 var_19 = 2;
    wp::float32 var_20;
    wp::vec_t<3, wp::float32> var_21;
    wp::vec_t<3, wp::float32> var_22;
    const wp::int32 var_23 = 1;
    wp::float32 var_24;
    const wp::float32 var_25 = 1e-06;
    bool var_26;
    const wp::int32 var_27 = 0;
    wp::float32 var_28;
    const wp::int32 var_29 = 1;
    wp::float32 var_30;
    const wp::int32 var_31 = 1;
    wp::float32 var_32;
    wp::float32 var_33;
    const wp::int32 var_34 = 1;
    wp::float32 var_35;
    wp::float32 var_36;
    const wp::int32 var_37 = 2;
    wp::float32 var_38;
    wp::vec_t<3, wp::float32> var_39;
    wp::vec_t<3, wp::float32> var_40;
    const wp::int32 var_41 = 2;
    wp::float32 var_42;
    const wp::float32 var_43 = 1e-06;
    bool var_44;
    const wp::int32 var_45 = 0;
    wp::float32 var_46;
    const wp::int32 var_47 = 1;
    wp::float32 var_48;
    const wp::int32 var_49 = 2;
    wp::float32 var_50;
    const wp::int32 var_51 = 2;
    wp::float32 var_52;
    wp::float32 var_53;
    const wp::int32 var_54 = 2;
    wp::float32 var_55;
    wp::float32 var_56;
    wp::vec_t<3, wp::float32> var_57;
    wp::vec_t<3, wp::float32> var_58;
    const wp::int32 var_59 = 0;
    wp::int32 var_60;
    const wp::int32 var_61 = 1;
    wp::int32 var_62;
    const wp::int32 var_63 = 2;
    wp::int32 var_64;
    const wp::int32 var_65 = 0;
    wp::float32 var_66;
    wp::float32 var_67;
    wp::float32 var_68;
    wp::int32 var_69;
    const wp::int32 var_70 = 0;
    const wp::int32 var_71 = 1;
    wp::int32 var_72;
    wp::int32 var_73;
    const wp::int32 var_74 = 1;
    wp::float32 var_75;
    wp::float32 var_76;
    wp::float32 var_77;
    wp::int32 var_78;
    const wp::int32 var_79 = 0;
    const wp::int32 var_80 = 1;
    wp::int32 var_81;
    wp::int32 var_82;
    const wp::int32 var_83 = 2;
    wp::float32 var_84;
    wp::float32 var_85;
    wp::float32 var_86;
    wp::int32 var_87;
    const wp::int32 var_88 = 0;
    const wp::int32 var_89 = 1;
    wp::int32 var_90;
    wp::int32 var_91;
    wp::int32 var_92;
    wp::int32 var_93;
    wp::int32 var_94;
    wp::int32 var_95;
    wp::int32 var_96;
    //---------
    // forward
    // def compute_voxel_index(                                                               <L 430>
    // size = aabb_upper - aabb_lower                                                         <L 447>
    var_0 = wp::sub(var_aabb_upper, var_aabb_lower);
    // rel = wp.vec3(0.0, 0.0, 0.0)                                                           <L 449>
    var_4 = wp::vec_t<3, wp::float32>(var_1, var_2, var_3);
    // if size[0] > 1e-6:                                                                     <L 450>
    var_6 = wp::extract(var_0, var_5);
    var_8 = (var_6 > var_7);
    if (var_8) {
        // rel = wp.vec3((pos_local[0] - aabb_lower[0]) / size[0], rel[1], rel[2])            <L 451>
        var_10 = wp::extract(var_pos_local, var_9);
        var_12 = wp::extract(var_aabb_lower, var_11);
        var_13 = wp::sub(var_10, var_12);
        var_15 = wp::extract(var_0, var_14);
        var_16 = wp::div(var_13, var_15);
        var_18 = wp::extract(var_4, var_17);
        var_20 = wp::extract(var_4, var_19);
        var_21 = wp::vec_t<3, wp::float32>(var_16, var_18, var_20);
    }
    var_22 = wp::where(var_8, var_21, var_4);
    // if size[1] > 1e-6:                                                                     <L 452>
    var_24 = wp::extract(var_0, var_23);
    var_26 = (var_24 > var_25);
    if (var_26) {
        // rel = wp.vec3(rel[0], (pos_local[1] - aabb_lower[1]) / size[1], rel[2])            <L 453>
        var_28 = wp::extract(var_22, var_27);
        var_30 = wp::extract(var_pos_local, var_29);
        var_32 = wp::extract(var_aabb_lower, var_31);
        var_33 = wp::sub(var_30, var_32);
        var_35 = wp::extract(var_0, var_34);
        var_36 = wp::div(var_33, var_35);
        var_38 = wp::extract(var_22, var_37);
        var_39 = wp::vec_t<3, wp::float32>(var_28, var_36, var_38);
    }
    var_40 = wp::where(var_26, var_39, var_22);
    // if size[2] > 1e-6:                                                                     <L 454>
    var_42 = wp::extract(var_0, var_41);
    var_44 = (var_42 > var_43);
    if (var_44) {
        // rel = wp.vec3(rel[0], rel[1], (pos_local[2] - aabb_lower[2]) / size[2])            <L 455>
        var_46 = wp::extract(var_40, var_45);
        var_48 = wp::extract(var_40, var_47);
        var_50 = wp::extract(var_pos_local, var_49);
        var_52 = wp::extract(var_aabb_lower, var_51);
        var_53 = wp::sub(var_50, var_52);
        var_55 = wp::extract(var_0, var_54);
        var_56 = wp::div(var_53, var_55);
        var_57 = wp::vec_t<3, wp::float32>(var_46, var_48, var_56);
    }
    var_58 = wp::where(var_44, var_57, var_40);
    // nx = resolution[0]                                                                     <L 458>
    var_60 = wp::extract(var_resolution, var_59);
    // ny = resolution[1]                                                                     <L 459>
    var_62 = wp::extract(var_resolution, var_61);
    // nz = resolution[2]                                                                     <L 460>
    var_64 = wp::extract(var_resolution, var_63);
    // vx = wp.clamp(int(rel[0] * float(nx)), 0, nx - 1)                                      <L 462>
    var_66 = wp::extract(var_58, var_65);
    var_67 = wp::float(var_60);
    var_68 = wp::mul(var_66, var_67);
    var_69 = wp::int(var_68);
    var_72 = wp::sub(var_60, var_71);
    var_73 = wp::clamp(var_69, var_70, var_72);
    // vy = wp.clamp(int(rel[1] * float(ny)), 0, ny - 1)                                      <L 463>
    var_75 = wp::extract(var_58, var_74);
    var_76 = wp::float(var_62);
    var_77 = wp::mul(var_75, var_76);
    var_78 = wp::int(var_77);
    var_81 = wp::sub(var_62, var_80);
    var_82 = wp::clamp(var_78, var_79, var_81);
    // vz = wp.clamp(int(rel[2] * float(nz)), 0, nz - 1)                                      <L 464>
    var_84 = wp::extract(var_58, var_83);
    var_85 = wp::float(var_64);
    var_86 = wp::mul(var_84, var_85);
    var_87 = wp::int(var_86);
    var_90 = wp::sub(var_64, var_89);
    var_91 = wp::clamp(var_87, var_88, var_90);
    // return vx + vy * nx + vz * nx * ny                                                     <L 466>
    var_92 = wp::mul(var_82, var_60);
    var_93 = wp::add(var_73, var_92);
    var_94 = wp::mul(var_91, var_60);
    var_95 = wp::mul(var_94, var_62);
    var_96 = wp::add(var_93, var_95);
    return var_96;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:1235
static CUDA_CALLABLE void reduce_contact_in_hashtable_0(
    wp::int32 var_contact_id,
    GlobalContactReducerData_0c09c456 var_reducer_data,
    wp::float32 var_beta,
    wp::array_t<wp::transform_t<wp::float32>> var_shape_transform,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_collision_aabb_lower,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_collision_aabb_upper,
    wp::array_t<wp::vec_t<3, wp::int32>> var_shape_voxel_resolution)
{
    //---------
    // primal vars
    wp::array_t<wp::vec_t<4, wp::float32>>* var_0;
    wp::vec_t<4, wp::float32>* var_1;
    wp::array_t<wp::vec_t<4, wp::float32>> var_2;
    wp::vec_t<4, wp::float32> var_3;
    wp::vec_t<4, wp::float32> var_4;
    wp::array_t<wp::vec_t<2, wp::float32>>* var_5;
    wp::vec_t<2, wp::float32>* var_6;
    wp::array_t<wp::vec_t<2, wp::float32>> var_7;
    wp::vec_t<3, wp::float32> var_8;
    wp::vec_t<2, wp::float32> var_9;
    wp::array_t<wp::vec_t<2, wp::int32>>* var_10;
    wp::vec_t<2, wp::int32>* var_11;
    wp::array_t<wp::vec_t<2, wp::int32>> var_12;
    wp::vec_t<2, wp::int32> var_13;
    wp::vec_t<2, wp::int32> var_14;
    wp::array_t<wp::int32>* var_15;
    wp::int32* var_16;
    wp::array_t<wp::int32> var_17;
    wp::int32 var_18;
    wp::int32 var_19;
    const wp::int32 var_20 = 0;
    wp::float32 var_21;
    const wp::int32 var_22 = 1;
    wp::float32 var_23;
    const wp::int32 var_24 = 2;
    wp::float32 var_25;
    wp::vec_t<3, wp::float32> var_26;
    const wp::int32 var_27 = 3;
    wp::float32 var_28;
    const wp::int32 var_29 = 0;
    wp::int32 var_30;
    const wp::int32 var_31 = 1;
    wp::int32 var_32;
    wp::vec_t<3, wp::float32>* var_33;
    wp::vec_t<3, wp::float32> var_34;
    wp::vec_t<3, wp::float32> var_35;
    wp::vec_t<3, wp::float32>* var_36;
    wp::vec_t<3, wp::float32> var_37;
    wp::vec_t<3, wp::float32> var_38;
    wp::int32* var_39;
    wp::int32 var_40;
    wp::int32 var_41;
    wp::int32 var_42;
    wp::vec_t<2, wp::float32> var_43;
    wp::uint64 var_44;
    wp::array_t<wp::uint64>* var_45;
    wp::array_t<wp::int32>* var_46;
    wp::int32 var_47;
    wp::array_t<wp::uint64> var_48;
    wp::array_t<wp::int32> var_49;
    const wp::int32 var_50 = 0;
    bool var_51;
    wp::vec_t<3, wp::float32> var_52;
    wp::float32 var_53;
    wp::float32 var_54;
    bool var_55;
    const wp::int32 var_56 = 0;
    wp::vec_t<2, wp::float32> var_57;
    wp::float32 var_58;
    wp::int32* var_59;
    wp::uint64 var_60;
    wp::int32 var_61;
    wp::int32 var_62;
    wp::array_t<wp::uint64>* var_63;
    wp::array_t<wp::uint64> var_64;
    const wp::int32 var_65 = 1;
    wp::vec_t<2, wp::float32> var_66;
    wp::float32 var_67;
    wp::int32* var_68;
    wp::uint64 var_69;
    wp::int32 var_70;
    wp::int32 var_71;
    wp::array_t<wp::uint64>* var_72;
    wp::array_t<wp::uint64> var_73;
    wp::vec_t<2, wp::float32> var_74;
    wp::float32 var_75;
    wp::uint64 var_76;
    wp::int32 var_77;
    const wp::int32 var_78 = 2;
    wp::vec_t<2, wp::float32> var_79;
    wp::float32 var_80;
    wp::int32* var_81;
    wp::uint64 var_82;
    wp::int32 var_83;
    wp::int32 var_84;
    wp::array_t<wp::uint64>* var_85;
    wp::array_t<wp::uint64> var_86;
    wp::vec_t<2, wp::float32> var_87;
    wp::float32 var_88;
    wp::uint64 var_89;
    wp::int32 var_90;
    const wp::int32 var_91 = 3;
    wp::vec_t<2, wp::float32> var_92;
    wp::float32 var_93;
    wp::int32* var_94;
    wp::uint64 var_95;
    wp::int32 var_96;
    wp::int32 var_97;
    wp::array_t<wp::uint64>* var_98;
    wp::array_t<wp::uint64> var_99;
    wp::vec_t<2, wp::float32> var_100;
    wp::float32 var_101;
    wp::uint64 var_102;
    wp::int32 var_103;
    const wp::int32 var_104 = 4;
    wp::vec_t<2, wp::float32> var_105;
    wp::float32 var_106;
    wp::int32* var_107;
    wp::uint64 var_108;
    wp::int32 var_109;
    wp::int32 var_110;
    wp::array_t<wp::uint64>* var_111;
    wp::array_t<wp::uint64> var_112;
    wp::vec_t<2, wp::float32> var_113;
    wp::float32 var_114;
    wp::uint64 var_115;
    wp::int32 var_116;
    const wp::int32 var_117 = 5;
    wp::vec_t<2, wp::float32> var_118;
    wp::float32 var_119;
    wp::int32* var_120;
    wp::uint64 var_121;
    wp::int32 var_122;
    wp::int32 var_123;
    wp::array_t<wp::uint64>* var_124;
    wp::array_t<wp::uint64> var_125;
    wp::vec_t<2, wp::float32> var_126;
    wp::float32 var_127;
    wp::uint64 var_128;
    wp::int32 var_129;
    wp::float32 var_130;
    wp::int32* var_131;
    wp::uint64 var_132;
    wp::int32 var_133;
    const wp::int32 var_134 = 6;
    wp::array_t<wp::uint64>* var_135;
    wp::array_t<wp::uint64> var_136;
    wp::array_t<wp::int32>* var_137;
    const wp::int32 var_138 = 0;
    const wp::int32 var_139 = 1;
    wp::int32 var_140;
    wp::array_t<wp::int32> var_141;
    wp::transform_t<wp::float32>* var_142;
    wp::transform_t<wp::float32> var_143;
    wp::transform_t<wp::float32> var_144;
    wp::transform_t<wp::float32> var_145;
    wp::vec_t<3, wp::float32> var_146;
    wp::vec_t<3, wp::int32>* var_147;
    wp::vec_t<3, wp::int32> var_148;
    wp::vec_t<3, wp::int32> var_149;
    wp::int32 var_150;
    const wp::int32 var_151 = 0;
    const wp::int32 var_152 = 99;
    wp::int32 var_153;
    const wp::int32 var_154 = 7;
    wp::int32 var_155;
    wp::int32 var_156;
    const wp::int32 var_157 = 20;
    wp::int32 var_158;
    wp::uint64 var_159;
    wp::array_t<wp::uint64>* var_160;
    wp::array_t<wp::int32>* var_161;
    wp::int32 var_162;
    wp::array_t<wp::uint64> var_163;
    wp::array_t<wp::int32> var_164;
    const wp::int32 var_165 = 0;
    bool var_166;
    wp::float32 var_167;
    wp::int32* var_168;
    wp::uint64 var_169;
    wp::int32 var_170;
    wp::array_t<wp::uint64>* var_171;
    wp::array_t<wp::uint64> var_172;
    wp::array_t<wp::int32>* var_173;
    const wp::int32 var_174 = 0;
    const wp::int32 var_175 = 1;
    wp::int32 var_176;
    wp::array_t<wp::int32> var_177;
    //---------
    // forward
    // def reduce_contact_in_hashtable(                                                       <L 1236>
    // pd = reducer_data.position_depth[contact_id]                                           <L 1268>
    var_0 = &((var_reducer_data).position_depth);
    var_2 = wp::load(var_0);
    var_1 = wp::address(var_2, var_contact_id);
    var_4 = wp::load(var_1);
    var_3 = wp::copy(var_4);
    // normal = decode_oct(reducer_data.normal[contact_id])                                   <L 1269>
    var_5 = &((var_reducer_data).normal);
    var_7 = wp::load(var_5);
    var_6 = wp::address(var_7, var_contact_id);
    var_9 = wp::load(var_6);
    var_8 = decode_oct_0(var_9);
    // pair = reducer_data.shape_pairs[contact_id]                                            <L 1270>
    var_10 = &((var_reducer_data).shape_pairs);
    var_12 = wp::load(var_10);
    var_11 = wp::address(var_12, var_contact_id);
    var_14 = wp::load(var_11);
    var_13 = wp::copy(var_14);
    // fingerprint = reducer_data.contact_fingerprints[contact_id]                            <L 1271>
    var_15 = &((var_reducer_data).contact_fingerprints);
    var_17 = wp::load(var_15);
    var_16 = wp::address(var_17, var_contact_id);
    var_19 = wp::load(var_16);
    var_18 = wp::copy(var_19);
    // position = wp.vec3(pd[0], pd[1], pd[2])                                                <L 1273>
    var_21 = wp::extract(var_3, var_20);
    var_23 = wp::extract(var_3, var_22);
    var_25 = wp::extract(var_3, var_24);
    var_26 = wp::vec_t<3, wp::float32>(var_21, var_23, var_25);
    // depth = pd[3]                                                                          <L 1274>
    var_28 = wp::extract(var_3, var_27);
    // shape_a = pair[0]  # Mesh shape                                                        <L 1275>
    var_30 = wp::extract(var_13, var_29);
    // shape_b = pair[1]  # Convex shape                                                      <L 1276>
    var_32 = wp::extract(var_13, var_31);
    // aabb_lower = shape_collision_aabb_lower[shape_a]                                       <L 1278>
    var_33 = wp::address(var_shape_collision_aabb_lower, var_30);
    var_35 = wp::load(var_33);
    var_34 = wp::copy(var_35);
    // aabb_upper = shape_collision_aabb_upper[shape_a]                                       <L 1279>
    var_36 = wp::address(var_shape_collision_aabb_upper, var_30);
    var_38 = wp::load(var_36);
    var_37 = wp::copy(var_38);
    // ht_capacity = reducer_data.ht_capacity                                                 <L 1281>
    var_39 = &((var_reducer_data).ht_capacity);
    var_41 = wp::load(var_39);
    var_40 = wp::copy(var_41);
    // bin_id = get_slot(normal)                                                              <L 1285>
    var_42 = get_slot_0(var_8);
    // pos_2d = project_point_to_plane(bin_id, position)                                      <L 1288>
    var_43 = project_point_to_plane_0(var_42, var_26);
    // key = make_contact_key(shape_a, shape_b, bin_id)                                       <L 1291>
    var_44 = make_contact_key_0(var_30, var_32, var_42);
    // entry_idx = hashtable_find_or_insert(key, reducer_data.ht_keys, reducer_data.ht_active_slots)       <L 1294>
    var_45 = &((var_reducer_data).ht_keys);
    var_46 = &((var_reducer_data).ht_active_slots);
    var_48 = wp::load(var_45);
    var_49 = wp::load(var_46);
    var_47 = hashtable_find_or_insert_0(var_44, var_48, var_49);
    // if entry_idx >= 0:                                                                     <L 1295>
    var_51 = (var_47 >= var_50);
    if (var_51) {
        // use_beta = depth < beta * wp.length(aabb_upper - aabb_lower)                       <L 1296>
        var_52 = wp::sub(var_37, var_34);
        var_53 = wp::length(var_52);
        var_54 = wp::mul(var_beta, var_53);
        var_55 = (var_28 < var_54);
        // for dir_i in range(wp.static(NUM_SPATIAL_DIRECTIONS)):                             <L 1297>
        // if use_beta:                                                                       <L 1298>
        if (var_55) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1299>
            var_57 = get_spatial_direction_2d_0(var_56);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1300>
            var_58 = wp::dot(var_43, var_57);
            // value = make_contact_value(score, fingerprint, contact_id, reducer_data.deterministic)       <L 1301>
            var_59 = &((var_reducer_data).deterministic);
            var_61 = wp::load(var_59);
            var_60 = make_contact_value_0(var_58, var_18, var_contact_id, var_61);
            // slot_id = dir_i                                                                <L 1302>
            var_62 = wp::copy(var_56);
            // reduction_update_slot(entry_idx, slot_id, value, reducer_data.ht_values, ht_capacity)       <L 1303>
            var_63 = &((var_reducer_data).ht_values);
            var_64 = wp::load(var_63);
            reduction_update_slot_0(var_47, var_62, var_60, var_64, var_40);
        }
        // if use_beta:                                                                       <L 1298>
        if (var_55) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1299>
            var_66 = get_spatial_direction_2d_0(var_65);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1300>
            var_67 = wp::dot(var_43, var_66);
            // value = make_contact_value(score, fingerprint, contact_id, reducer_data.deterministic)       <L 1301>
            var_68 = &((var_reducer_data).deterministic);
            var_70 = wp::load(var_68);
            var_69 = make_contact_value_0(var_67, var_18, var_contact_id, var_70);
            // slot_id = dir_i                                                                <L 1302>
            var_71 = wp::copy(var_65);
            // reduction_update_slot(entry_idx, slot_id, value, reducer_data.ht_values, ht_capacity)       <L 1303>
            var_72 = &((var_reducer_data).ht_values);
            var_73 = wp::load(var_72);
            reduction_update_slot_0(var_47, var_71, var_69, var_73, var_40);
        }
        var_74 = wp::where(var_55, var_66, var_57);
        var_75 = wp::where(var_55, var_67, var_58);
        var_76 = wp::where(var_55, var_69, var_60);
        var_77 = wp::where(var_55, var_71, var_62);
        // if use_beta:                                                                       <L 1298>
        if (var_55) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1299>
            var_79 = get_spatial_direction_2d_0(var_78);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1300>
            var_80 = wp::dot(var_43, var_79);
            // value = make_contact_value(score, fingerprint, contact_id, reducer_data.deterministic)       <L 1301>
            var_81 = &((var_reducer_data).deterministic);
            var_83 = wp::load(var_81);
            var_82 = make_contact_value_0(var_80, var_18, var_contact_id, var_83);
            // slot_id = dir_i                                                                <L 1302>
            var_84 = wp::copy(var_78);
            // reduction_update_slot(entry_idx, slot_id, value, reducer_data.ht_values, ht_capacity)       <L 1303>
            var_85 = &((var_reducer_data).ht_values);
            var_86 = wp::load(var_85);
            reduction_update_slot_0(var_47, var_84, var_82, var_86, var_40);
        }
        var_87 = wp::where(var_55, var_79, var_74);
        var_88 = wp::where(var_55, var_80, var_75);
        var_89 = wp::where(var_55, var_82, var_76);
        var_90 = wp::where(var_55, var_84, var_77);
        // if use_beta:                                                                       <L 1298>
        if (var_55) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1299>
            var_92 = get_spatial_direction_2d_0(var_91);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1300>
            var_93 = wp::dot(var_43, var_92);
            // value = make_contact_value(score, fingerprint, contact_id, reducer_data.deterministic)       <L 1301>
            var_94 = &((var_reducer_data).deterministic);
            var_96 = wp::load(var_94);
            var_95 = make_contact_value_0(var_93, var_18, var_contact_id, var_96);
            // slot_id = dir_i                                                                <L 1302>
            var_97 = wp::copy(var_91);
            // reduction_update_slot(entry_idx, slot_id, value, reducer_data.ht_values, ht_capacity)       <L 1303>
            var_98 = &((var_reducer_data).ht_values);
            var_99 = wp::load(var_98);
            reduction_update_slot_0(var_47, var_97, var_95, var_99, var_40);
        }
        var_100 = wp::where(var_55, var_92, var_87);
        var_101 = wp::where(var_55, var_93, var_88);
        var_102 = wp::where(var_55, var_95, var_89);
        var_103 = wp::where(var_55, var_97, var_90);
        // if use_beta:                                                                       <L 1298>
        if (var_55) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1299>
            var_105 = get_spatial_direction_2d_0(var_104);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1300>
            var_106 = wp::dot(var_43, var_105);
            // value = make_contact_value(score, fingerprint, contact_id, reducer_data.deterministic)       <L 1301>
            var_107 = &((var_reducer_data).deterministic);
            var_109 = wp::load(var_107);
            var_108 = make_contact_value_0(var_106, var_18, var_contact_id, var_109);
            // slot_id = dir_i                                                                <L 1302>
            var_110 = wp::copy(var_104);
            // reduction_update_slot(entry_idx, slot_id, value, reducer_data.ht_values, ht_capacity)       <L 1303>
            var_111 = &((var_reducer_data).ht_values);
            var_112 = wp::load(var_111);
            reduction_update_slot_0(var_47, var_110, var_108, var_112, var_40);
        }
        var_113 = wp::where(var_55, var_105, var_100);
        var_114 = wp::where(var_55, var_106, var_101);
        var_115 = wp::where(var_55, var_108, var_102);
        var_116 = wp::where(var_55, var_110, var_103);
        // if use_beta:                                                                       <L 1298>
        if (var_55) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1299>
            var_118 = get_spatial_direction_2d_0(var_117);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1300>
            var_119 = wp::dot(var_43, var_118);
            // value = make_contact_value(score, fingerprint, contact_id, reducer_data.deterministic)       <L 1301>
            var_120 = &((var_reducer_data).deterministic);
            var_122 = wp::load(var_120);
            var_121 = make_contact_value_0(var_119, var_18, var_contact_id, var_122);
            // slot_id = dir_i                                                                <L 1302>
            var_123 = wp::copy(var_117);
            // reduction_update_slot(entry_idx, slot_id, value, reducer_data.ht_values, ht_capacity)       <L 1303>
            var_124 = &((var_reducer_data).ht_values);
            var_125 = wp::load(var_124);
            reduction_update_slot_0(var_47, var_123, var_121, var_125, var_40);
        }
        var_126 = wp::where(var_55, var_118, var_113);
        var_127 = wp::where(var_55, var_119, var_114);
        var_128 = wp::where(var_55, var_121, var_115);
        var_129 = wp::where(var_55, var_123, var_116);
        // max_depth_value = make_contact_value(-depth, fingerprint, contact_id, reducer_data.deterministic)       <L 1305>
        var_130 = wp::neg(var_28);
        var_131 = &((var_reducer_data).deterministic);
        var_133 = wp::load(var_131);
        var_132 = make_contact_value_0(var_130, var_18, var_contact_id, var_133);
        // reduction_update_slot(                                                             <L 1306>
        // entry_idx, wp.static(NUM_SPATIAL_DIRECTIONS), max_depth_value, reducer_data.ht_values, ht_capacity       <L 1307>
        var_135 = &((var_reducer_data).ht_values);
        var_136 = wp::load(var_135);
        reduction_update_slot_0(var_47, var_134, var_132, var_136, var_40);
    }
    if (!var_51) {
        // wp.atomic_add(reducer_data.ht_insert_failures, 0, 1)                               <L 1310>
        var_137 = &((var_reducer_data).ht_insert_failures);
        var_141 = wp::load(var_137);
        var_140 = wp::atomic_add(var_141, var_138, var_139);
    }
    // X_shape_ws = shape_transform[shape_a]                                                  <L 1314>
    var_142 = wp::address(var_shape_transform, var_30);
    var_144 = wp::load(var_142);
    var_143 = wp::copy(var_144);
    // X_ws_shape = wp.transform_inverse(X_shape_ws)                                          <L 1315>
    var_145 = wp::transform_inverse(var_143);
    // position_local = wp.transform_point(X_ws_shape, position)                              <L 1316>
    var_146 = wp::transform_point(var_145, var_26);
    // voxel_res = shape_voxel_resolution[shape_a]                                            <L 1319>
    var_147 = wp::address(var_shape_voxel_resolution, var_30);
    var_149 = wp::load(var_147);
    var_148 = wp::copy(var_149);
    // voxel_idx = compute_voxel_index(position_local, aabb_lower, aabb_upper, voxel_res)       <L 1320>
    var_150 = compute_voxel_index_0(var_146, var_34, var_37, var_148);
    // voxel_idx = wp.clamp(voxel_idx, 0, wp.static(NUM_VOXEL_DEPTH_SLOTS - 1))               <L 1323>
    var_153 = wp::clamp(var_150, var_151, var_152);
    // voxels_per_group = wp.static(NUM_SPATIAL_DIRECTIONS + 1)                               <L 1325>
    // voxel_group = voxel_idx // voxels_per_group                                            <L 1326>
    var_155 = wp::floordiv(var_153, var_154);
    // voxel_local_slot = voxel_idx % voxels_per_group                                        <L 1327>
    var_156 = wp::mod(var_153, var_154);
    // voxel_bin_id = wp.static(NUM_NORMAL_BINS) + voxel_group                                <L 1329>
    var_158 = wp::add(var_157, var_155);
    // voxel_key = make_contact_key(shape_a, shape_b, voxel_bin_id)                           <L 1330>
    var_159 = make_contact_key_0(var_30, var_32, var_158);
    // voxel_entry_idx = hashtable_find_or_insert(voxel_key, reducer_data.ht_keys, reducer_data.ht_active_slots)       <L 1332>
    var_160 = &((var_reducer_data).ht_keys);
    var_161 = &((var_reducer_data).ht_active_slots);
    var_163 = wp::load(var_160);
    var_164 = wp::load(var_161);
    var_162 = hashtable_find_or_insert_0(var_159, var_163, var_164);
    // if voxel_entry_idx >= 0:                                                               <L 1333>
    var_166 = (var_162 >= var_165);
    if (var_166) {
        // voxel_value = make_contact_value(-depth, fingerprint, contact_id, reducer_data.deterministic)       <L 1335>
        var_167 = wp::neg(var_28);
        var_168 = &((var_reducer_data).deterministic);
        var_170 = wp::load(var_168);
        var_169 = make_contact_value_0(var_167, var_18, var_contact_id, var_170);
        // reduction_update_slot(voxel_entry_idx, voxel_local_slot, voxel_value, reducer_data.ht_values, ht_capacity)       <L 1336>
        var_171 = &((var_reducer_data).ht_values);
        var_172 = wp::load(var_171);
        reduction_update_slot_0(var_162, var_156, var_169, var_172, var_40);
    }
    if (!var_166) {
        // wp.atomic_add(reducer_data.ht_insert_failures, 0, 1)                               <L 1338>
        var_173 = &((var_reducer_data).ht_insert_failures);
        var_177 = wp::load(var_173);
        var_176 = wp::atomic_add(var_177, var_174, var_175);
    }
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_data.py:90
static CUDA_CALLABLE wp::float32 compute_contact_approach_speed_0(
    wp::int32 var_shape_a,
    wp::int32 var_shape_b,
    wp::vec_t<3, wp::float32> var_point_a,
    wp::vec_t<3, wp::float32> var_point_b,
    wp::vec_t<3, wp::float32> var_normal_a_to_b,
    wp::array_t<wp::transform_t<wp::float32>> var_shape_transform,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_linear_velocity,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_angular_velocity)
{
    //---------
    // primal vars
    wp::transform_t<wp::float32>* var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::transform_t<wp::float32> var_2;
    wp::transform_t<wp::float32>* var_3;
    wp::vec_t<3, wp::float32> var_4;
    wp::transform_t<wp::float32> var_5;
    wp::vec_t<3, wp::float32>* var_6;
    wp::vec_t<3, wp::float32>* var_7;
    wp::vec_t<3, wp::float32> var_8;
    wp::vec_t<3, wp::float32> var_9;
    wp::vec_t<3, wp::float32> var_10;
    wp::vec_t<3, wp::float32> var_11;
    wp::vec_t<3, wp::float32> var_12;
    wp::vec_t<3, wp::float32>* var_13;
    wp::vec_t<3, wp::float32>* var_14;
    wp::vec_t<3, wp::float32> var_15;
    wp::vec_t<3, wp::float32> var_16;
    wp::vec_t<3, wp::float32> var_17;
    wp::vec_t<3, wp::float32> var_18;
    wp::vec_t<3, wp::float32> var_19;
    wp::vec_t<3, wp::float32> var_20;
    wp::float32 var_21;
    wp::float32 var_22;
    const wp::float32 var_23 = 0.0;
    wp::float32 var_24;
    //---------
    // forward
    // def compute_contact_approach_speed(                                                    <L 91>
    // origin_a = wp.transform_get_translation(shape_transform[shape_a])                      <L 102>
    var_0 = wp::address(var_shape_transform, var_shape_a);
    var_2 = wp::load(var_0);
    var_1 = wp::transform_get_translation(var_2);
    // origin_b = wp.transform_get_translation(shape_transform[shape_b])                      <L 103>
    var_3 = wp::address(var_shape_transform, var_shape_b);
    var_5 = wp::load(var_3);
    var_4 = wp::transform_get_translation(var_5);
    // velocity_a = shape_linear_velocity[shape_a] + wp.cross(shape_angular_velocity[shape_a], point_a - origin_a)       <L 104>
    var_6 = wp::address(var_shape_linear_velocity, var_shape_a);
    var_7 = wp::address(var_shape_angular_velocity, var_shape_a);
    var_8 = wp::sub(var_point_a, var_1);
    var_10 = wp::load(var_7);
    var_9 = wp::cross(var_10, var_8);
    var_12 = wp::load(var_6);
    var_11 = wp::add(var_12, var_9);
    // velocity_b = shape_linear_velocity[shape_b] + wp.cross(shape_angular_velocity[shape_b], point_b - origin_b)       <L 105>
    var_13 = wp::address(var_shape_linear_velocity, var_shape_b);
    var_14 = wp::address(var_shape_angular_velocity, var_shape_b);
    var_15 = wp::sub(var_point_b, var_4);
    var_17 = wp::load(var_14);
    var_16 = wp::cross(var_17, var_15);
    var_19 = wp::load(var_13);
    var_18 = wp::add(var_19, var_16);
    // return wp.max(-wp.dot(velocity_b - velocity_a, normal_a_to_b), 0.0)                    <L 106>
    var_20 = wp::sub(var_18, var_11);
    var_21 = wp::dot(var_20, var_normal_a_to_b);
    var_22 = wp::neg(var_21);
    var_24 = wp::max(var_22, var_23);
    return var_24;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:230
static CUDA_CALLABLE wp::uint64 reduction_try_update_slot_0(
    wp::int32 var_entry_idx,
    wp::int32 var_slot_id,
    wp::uint64 var_value,
    wp::array_t<wp::uint64> var_values,
    wp::int32 var_capacity)
{
    //---------
    // primal vars
    wp::int32 var_0;
    wp::int32 var_1;
    wp::uint64* var_2;
    wp::uint64 var_3;
    wp::uint64 var_4;
    bool var_5;
    wp::uint64 var_6;
    //---------
    // forward
    // def reduction_try_update_slot(                                                         <L 231>
    // value_idx = slot_id * capacity + entry_idx                                             <L 239>
    var_0 = wp::mul(var_slot_id, var_capacity);
    var_1 = wp::add(var_0, var_entry_idx);
    // previous_value = values[value_idx]                                                     <L 240>
    var_2 = wp::address(var_values, var_1);
    var_4 = wp::load(var_2);
    var_3 = wp::copy(var_4);
    // if previous_value >= value:                                                            <L 241>
    var_5 = (var_3 >= var_value);
    if (var_5) {
        // return previous_value                                                              <L 242>
        return var_3;
    }
    // return wp.atomic_max(values, value_idx, value)                                         <L 243>
    var_6 = wp::atomic_max(var_values, var_1, var_value);
    return var_6;
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:246
static CUDA_CALLABLE void reduction_rollback_slot_0(
    wp::int32 var_entry_idx,
    wp::int32 var_slot_id,
    wp::uint64 var_provisional_value,
    wp::uint64 var_previous_value,
    wp::array_t<wp::uint64> var_values,
    wp::int32 var_capacity)
{
    //---------
    // primal vars
    wp::int32 var_0;
    wp::int32 var_1;
    wp::uint64 var_2;
    //---------
    // forward
    // def reduction_rollback_slot(                                                           <L 247>
    // value_idx = slot_id * capacity + entry_idx                                             <L 256>
    var_0 = wp::mul(var_slot_id, var_capacity);
    var_1 = wp::add(var_0, var_entry_idx);
    // wp.atomic_cas(values, value_idx, provisional_value, previous_value)                    <L 257>
    var_2 = wp::atomic_cas(var_values, var_1, var_provisional_value, var_previous_value);
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:260
static CUDA_CALLABLE bool reduction_finalize_slot_0(
    wp::int32 var_entry_idx,
    wp::int32 var_slot_id,
    wp::uint64 var_provisional_value,
    wp::uint64 var_final_value,
    wp::array_t<wp::uint64> var_values,
    wp::int32 var_capacity)
{
    //---------
    // primal vars
    wp::int32 var_0;
    wp::int32 var_1;
    wp::uint64 var_2;
    bool var_3;
    //---------
    // forward
    // def reduction_finalize_slot(                                                           <L 261>
    // value_idx = slot_id * capacity + entry_idx                                             <L 270>
    var_0 = wp::mul(var_slot_id, var_capacity);
    var_1 = wp::add(var_0, var_entry_idx);
    // return wp.atomic_cas(values, value_idx, provisional_value, final_value) == provisional_value       <L 271>
    var_2 = wp::atomic_cas(var_values, var_1, var_provisional_value, var_final_value);
    var_3 = (var_2 == var_provisional_value);
    return var_3;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:1148
static CUDA_CALLABLE void reclaim_contact_id_0(
    wp::int32 var_contact_id,
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
    const wp::int32 var_7 = 32;
    wp::int32 var_8;
    const wp::int32 var_9 = 1;
    wp::uint32 var_10;
    const wp::int32 var_11 = 32;
    wp::int32 var_12;
    wp::uint32 var_13;
    wp::uint32 var_14;
    wp::array_t<wp::uint32>* var_15;
    wp::uint32 var_16;
    wp::array_t<wp::uint32> var_17;
    //---------
    // forward
    // def reclaim_contact_id(contact_id: int, reducer_data: GlobalContactReducerData):       <L 1149>
    // if reducer_data.reclaimed_contact_bits.shape[0] == 0:                                  <L 1151>
    var_0 = &((var_reducer_data).reclaimed_contact_bits);
    var_1 = &(var_0->shape);
    var_4 = wp::load(var_1);
    var_3 = wp::extract(var_4, var_2);
    var_6 = (var_3 == var_5);
    if (var_6) {
        // return                                                                             <L 1152>
        return;
    }
    // word = contact_id / 32                                                                 <L 1153>
    var_8 = wp::div(var_contact_id, var_7);
    // mask = wp.uint32(1) << wp.uint32(contact_id % 32)                                      <L 1154>
    var_10 = wp::uint32(var_9);
    var_12 = wp::mod(var_contact_id, var_11);
    var_13 = wp::uint32(var_12);
    var_14 = wp::lshift(var_10, var_13);
    // wp.atomic_or(reducer_data.reclaimed_contact_bits, word, mask)                          <L 1155>
    var_15 = &((var_reducer_data).reclaimed_contact_bits);
    var_17 = wp::load(var_15);
    var_16 = wp::atomic_or(var_17, var_8, var_14);
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:1744
static CUDA_CALLABLE wp::int32 export_and_reduce_predictive_contact_0(
    wp::int32 var_shape_a,
    wp::int32 var_shape_b,
    wp::vec_t<3, wp::float32> var_position,
    wp::vec_t<3, wp::float32> var_normal,
    wp::float32 var_depth,
    wp::float32 var_surface_offset_sum,
    wp::float32 var_radius_eff_a,
    wp::float32 var_radius_eff_b,
    wp::int32 var_fingerprint,
    wp::array_t<wp::transform_t<wp::float32>> var_shape_transform,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_linear_velocity,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_angular_velocity,
    wp::float32 var_collision_update_dt,
    wp::float32 var_max_speculative_extension,
    wp::int32 var_existing_contact_id,
    GlobalContactReducerData_0c09c456 var_reducer_data)
{
    //---------
    // primal vars
    wp::float32 var_0;
    bool var_1;
    const wp::float32 var_2 = 0.0;
    bool var_3;
    bool var_4;
    const wp::int32 var_5 = -1;
    wp::vec_t<3, wp::float32> var_6;
    const wp::float32 var_7 = 0.5;
    wp::float32 var_8;
    wp::float32 var_9;
    wp::vec_t<3, wp::float32> var_10;
    wp::vec_t<3, wp::float32> var_11;
    const wp::float32 var_12 = 0.5;
    wp::float32 var_13;
    wp::float32 var_14;
    wp::vec_t<3, wp::float32> var_15;
    wp::vec_t<3, wp::float32> var_16;
    wp::float32 var_17;
    bool var_18;
    const wp::float32 var_19 = 0.0;
    bool var_20;
    wp::float32 var_21;
    bool var_22;
    const wp::int32 var_23 = -1;
    const wp::int32 var_24 = 35;
    wp::uint64 var_25;
    wp::array_t<wp::uint64>* var_26;
    wp::array_t<wp::int32>* var_27;
    wp::int32 var_28;
    wp::array_t<wp::uint64> var_29;
    wp::array_t<wp::int32> var_30;
    const wp::int32 var_31 = 0;
    bool var_32;
    wp::array_t<wp::int32>* var_33;
    const wp::int32 var_34 = 0;
    const wp::int32 var_35 = 1;
    wp::int32 var_36;
    wp::array_t<wp::int32> var_37;
    const wp::int32 var_38 = -1;
    wp::float32 var_39;
    wp::float32 var_40;
    wp::float32 var_41;
    wp::uint32 var_42;
    const wp::int32 var_43 = 16;
    wp::uint32 var_44;
    wp::uint32 var_45;
    wp::uint32 var_46;
    const wp::int32 var_47 = 2146121005;
    wp::uint32 var_48;
    wp::uint32 var_49;
    const wp::int32 var_50 = 15;
    wp::uint32 var_51;
    wp::uint32 var_52;
    wp::uint32 var_53;
    const wp::int32 var_54 = 33900;
    wp::uint32 var_55;
    const wp::int32 var_56 = 16;
    wp::uint32 var_57;
    wp::uint32 var_58;
    const wp::int32 var_59 = 42635;
    wp::uint32 var_60;
    wp::uint32 var_61;
    wp::uint32 var_62;
    const wp::int32 var_63 = 16;
    wp::uint32 var_64;
    wp::uint32 var_65;
    wp::uint32 var_66;
    const wp::int32 var_67 = 6;
    wp::uint32 var_68;
    wp::uint32 var_69;
    wp::int32 var_70;
    wp::int32* var_71;
    wp::int32 var_72;
    wp::int32 var_73;
    wp::int32 var_74;
    wp::int32 var_75;
    const wp::int32 var_76 = 6;
    wp::int32 var_77;
    wp::int32 var_78;
    wp::int32 var_79;
    const wp::int32 var_80 = 0;
    bool var_81;
    wp::int32* var_82;
    wp::uint64 var_83;
    wp::int32 var_84;
    wp::int32* var_85;
    wp::uint64 var_86;
    wp::int32 var_87;
    wp::array_t<wp::uint64>* var_88;
    wp::array_t<wp::uint64> var_89;
    const wp::int32 var_90 = 6;
    wp::array_t<wp::uint64>* var_91;
    wp::array_t<wp::uint64> var_92;
    bool var_93;
    wp::array_t<wp::uint64>* var_94;
    wp::uint64* var_95;
    wp::array_t<wp::uint64> var_96;
    bool var_97;
    wp::uint64 var_98;
    wp::array_t<wp::uint64>* var_99;
    wp::uint64* var_100;
    wp::array_t<wp::uint64> var_101;
    bool var_102;
    wp::uint64 var_103;
    const wp::int32 var_104 = -1;
    const wp::int32 var_105 = 0;
    wp::int32* var_106;
    wp::uint64 var_107;
    wp::int32 var_108;
    const wp::int32 var_109 = 0;
    wp::int32* var_110;
    wp::uint64 var_111;
    wp::int32 var_112;
    wp::array_t<wp::uint64>* var_113;
    wp::uint64 var_114;
    wp::array_t<wp::uint64> var_115;
    const wp::int32 var_116 = 6;
    wp::array_t<wp::uint64>* var_117;
    wp::uint64 var_118;
    wp::array_t<wp::uint64> var_119;
    bool var_120;
    bool var_121;
    wp::array_t<wp::uint64>* var_122;
    wp::uint64* var_123;
    wp::array_t<wp::uint64> var_124;
    bool var_125;
    wp::uint64 var_126;
    bool var_127;
    wp::array_t<wp::uint64>* var_128;
    wp::uint64* var_129;
    wp::array_t<wp::uint64> var_130;
    bool var_131;
    wp::uint64 var_132;
    bool var_133;
    bool var_134;
    bool var_135;
    bool var_136;
    const wp::int32 var_137 = -1;
    wp::int32 var_138;
    const wp::int32 var_139 = 0;
    bool var_140;
    wp::array_t<wp::uint64>* var_141;
    wp::array_t<wp::uint64> var_142;
    const wp::int32 var_143 = 6;
    wp::array_t<wp::uint64>* var_144;
    wp::array_t<wp::uint64> var_145;
    const wp::int32 var_146 = -1;
    const bool var_147 = false;
    bool var_148;
    wp::int32* var_149;
    wp::uint64 var_150;
    wp::int32 var_151;
    wp::array_t<wp::uint64>* var_152;
    bool var_153;
    wp::array_t<wp::uint64> var_154;
    const bool var_155 = true;
    bool var_156;
    wp::uint64 var_157;
    bool var_158;
    wp::int32* var_159;
    wp::uint64 var_160;
    wp::int32 var_161;
    const wp::int32 var_162 = 6;
    wp::array_t<wp::uint64>* var_163;
    bool var_164;
    wp::array_t<wp::uint64> var_165;
    const bool var_166 = true;
    bool var_167;
    wp::uint64 var_168;
    bool var_169;
    const wp::int32 var_170 = -1;
    //---------
    // forward
    // def export_and_reduce_predictive_contact(                                              <L 1745>
    // clearance = depth - surface_offset_sum                                                 <L 1784>
    var_0 = wp::sub(var_depth, var_surface_offset_sum);
    // if clearance <= 0.0 or clearance > max_speculative_extension:                          <L 1785>
    var_3 = (var_0 <= var_2);
    var_1 = var_3;
    if (!var_1) {
        var_4 = (var_0 > var_max_speculative_extension);
        var_1 = var_1 || var_4;
    }
    if (var_1) {
        // return -1                                                                          <L 1786>
        return var_5;
    }
    // contact_normal = wp.normalize(normal)                                                  <L 1788>
    var_6 = wp::normalize(var_normal);
    // point_a = position - contact_normal * (0.5 * depth + radius_eff_a)                     <L 1789>
    var_8 = wp::mul(var_7, var_depth);
    var_9 = wp::add(var_8, var_radius_eff_a);
    var_10 = wp::mul(var_6, var_9);
    var_11 = wp::sub(var_position, var_10);
    // point_b = position + contact_normal * (0.5 * depth + radius_eff_b)                     <L 1790>
    var_13 = wp::mul(var_12, var_depth);
    var_14 = wp::add(var_13, var_radius_eff_b);
    var_15 = wp::mul(var_6, var_14);
    var_16 = wp::add(var_position, var_15);
    // closing_speed = compute_contact_approach_speed(                                        <L 1791>
    // shape_a,                                                                               <L 1792>
    // shape_b,                                                                               <L 1793>
    // point_a,                                                                               <L 1794>
    // point_b,                                                                               <L 1795>
    // contact_normal,                                                                        <L 1796>
    // shape_transform,                                                                       <L 1797>
    // shape_linear_velocity,                                                                 <L 1798>
    // shape_angular_velocity,                                                                <L 1799>
    var_17 = compute_contact_approach_speed_0(var_shape_a, var_shape_b, var_11, var_16, var_6, var_shape_transform, var_shape_linear_velocity, var_shape_angular_velocity);
    // if closing_speed <= 0.0 or clearance > closing_speed * collision_update_dt:            <L 1801>
    var_20 = (var_17 <= var_19);
    var_18 = var_20;
    if (!var_18) {
        var_21 = wp::mul(var_17, var_collision_update_dt);
        var_22 = (var_0 > var_21);
        var_18 = var_18 || var_22;
    }
    if (var_18) {
        // return -1                                                                          <L 1802>
        return var_23;
    }
    // key = make_contact_key(shape_a, shape_b, wp.static(PREDICTIVE_BIN_ID))                 <L 1804>
    var_25 = make_contact_key_0(var_shape_a, var_shape_b, var_24);
    // entry_idx = hashtable_find_or_insert(key, reducer_data.ht_keys, reducer_data.ht_active_slots)       <L 1805>
    var_26 = &((var_reducer_data).ht_keys);
    var_27 = &((var_reducer_data).ht_active_slots);
    var_29 = wp::load(var_26);
    var_30 = wp::load(var_27);
    var_28 = hashtable_find_or_insert_0(var_25, var_29, var_30);
    // if entry_idx < 0:                                                                      <L 1806>
    var_32 = (var_28 < var_31);
    if (var_32) {
        // wp.atomic_add(reducer_data.ht_insert_failures, 0, 1)                               <L 1807>
        var_33 = &((var_reducer_data).ht_insert_failures);
        var_37 = wp::load(var_33);
        var_36 = wp::atomic_add(var_37, var_34, var_35);
        // return -1                                                                          <L 1808>
        return var_38;
    }
    // clearance_score = -clearance                                                           <L 1810>
    var_39 = wp::neg(var_0);
    // impact_time_score = collision_update_dt - clearance / closing_speed                    <L 1811>
    var_40 = wp::div(var_0, var_17);
    var_41 = wp::sub(var_collision_update_dt, var_40);
    // shard_hash = wp.uint32(fingerprint)                                                    <L 1812>
    var_42 = wp::uint32(var_fingerprint);
    // shard_hash = shard_hash ^ (shard_hash >> wp.uint32(16))                                <L 1813>
    var_44 = wp::uint32(var_43);
    var_45 = wp::rshift(var_42, var_44);
    var_46 = wp::bit_xor(var_42, var_45);
    // shard_hash = shard_hash * wp.uint32(0x7FEB352D)                                        <L 1814>
    var_48 = wp::uint32(var_47);
    var_49 = wp::mul(var_46, var_48);
    // shard_hash = shard_hash ^ (shard_hash >> wp.uint32(15))                                <L 1815>
    var_51 = wp::uint32(var_50);
    var_52 = wp::rshift(var_49, var_51);
    var_53 = wp::bit_xor(var_49, var_52);
    // shard_hash = shard_hash * ((wp.uint32(0x846C) << wp.uint32(16)) | wp.uint32(0xA68B))       <L 1816>
    var_55 = wp::uint32(var_54);
    var_57 = wp::uint32(var_56);
    var_58 = wp::lshift(var_55, var_57);
    var_60 = wp::uint32(var_59);
    var_61 = wp::bit_or(var_58, var_60);
    var_62 = wp::mul(var_53, var_61);
    // shard_hash = shard_hash ^ (shard_hash >> wp.uint32(16))                                <L 1817>
    var_64 = wp::uint32(var_63);
    var_65 = wp::rshift(var_62, var_64);
    var_66 = wp::bit_xor(var_62, var_65);
    // clearance_slot = int(shard_hash % wp.uint32(wp.static(NUM_SPATIAL_DIRECTIONS)))        <L 1818>
    var_68 = wp::uint32(var_67);
    var_69 = wp::mod(var_66, var_68);
    var_70 = wp::int(var_69);
    // ht_capacity = reducer_data.ht_capacity                                                 <L 1819>
    var_71 = &((var_reducer_data).ht_capacity);
    var_73 = wp::load(var_71);
    var_72 = wp::copy(var_73);
    // clearance_idx = clearance_slot * ht_capacity + entry_idx                               <L 1820>
    var_74 = wp::mul(var_70, var_72);
    var_75 = wp::add(var_74, var_28);
    // impact_time_idx = wp.static(NUM_SPATIAL_DIRECTIONS) * ht_capacity + entry_idx          <L 1821>
    var_77 = wp::mul(var_76, var_72);
    var_78 = wp::add(var_77, var_28);
    // contact_id = existing_contact_id                                                       <L 1825>
    var_79 = wp::copy(var_existing_contact_id);
    // if contact_id >= 0:                                                                    <L 1826>
    var_81 = (var_79 >= var_80);
    if (var_81) {
        // clearance_value = make_contact_value(clearance_score, fingerprint, contact_id, reducer_data.deterministic)       <L 1827>
        var_82 = &((var_reducer_data).deterministic);
        var_84 = wp::load(var_82);
        var_83 = make_contact_value_0(var_39, var_fingerprint, var_79, var_84);
        // impact_time_value = make_contact_value(impact_time_score, fingerprint, contact_id, reducer_data.deterministic)       <L 1828>
        var_85 = &((var_reducer_data).deterministic);
        var_87 = wp::load(var_85);
        var_86 = make_contact_value_0(var_41, var_fingerprint, var_79, var_87);
        // reduction_update_slot(entry_idx, clearance_slot, clearance_value, reducer_data.ht_values, ht_capacity)       <L 1829>
        var_88 = &((var_reducer_data).ht_values);
        var_89 = wp::load(var_88);
        reduction_update_slot_0(var_28, var_70, var_83, var_89, var_72);
        // reduction_update_slot(                                                             <L 1830>
        // entry_idx,                                                                         <L 1831>
        // wp.static(NUM_SPATIAL_DIRECTIONS),                                                 <L 1832>
        // impact_time_value,                                                                 <L 1833>
        // reducer_data.ht_values,                                                            <L 1834>
        var_91 = &((var_reducer_data).ht_values);
        // ht_capacity,                                                                       <L 1835>
        var_92 = wp::load(var_91);
        reduction_update_slot_0(var_28, var_90, var_86, var_92, var_72);
        // if (                                                                               <L 1837>
        // reducer_data.ht_values[clearance_idx] == clearance_value                           <L 1838>
        var_94 = &((var_reducer_data).ht_values);
        var_96 = wp::load(var_94);
        var_95 = wp::address(var_96, var_75);
        var_98 = wp::load(var_95);
        var_97 = (var_98 == var_83);
        var_93 = var_97;
        if (!var_93) {
            // or reducer_data.ht_values[impact_time_idx] == impact_time_value                <L 1839>
            var_99 = &((var_reducer_data).ht_values);
            var_101 = wp::load(var_99);
            var_100 = wp::address(var_101, var_78);
            var_103 = wp::load(var_100);
            var_102 = (var_103 == var_86);
            var_93 = var_93 || var_102;
        }
        if (var_93) {
            // return contact_id                                                              <L 1841>
            return var_79;
        }
        // return -1                                                                          <L 1842>
        return var_104;
    }
    // provisional_clearance_value = make_contact_value(clearance_score, fingerprint, 0, reducer_data.deterministic)       <L 1844>
    var_106 = &((var_reducer_data).deterministic);
    var_108 = wp::load(var_106);
    var_107 = make_contact_value_0(var_39, var_fingerprint, var_105, var_108);
    // provisional_impact_time_value = make_contact_value(impact_time_score, fingerprint, 0, reducer_data.deterministic)       <L 1845>
    var_110 = &((var_reducer_data).deterministic);
    var_112 = wp::load(var_110);
    var_111 = make_contact_value_0(var_41, var_fingerprint, var_109, var_112);
    // previous_clearance_value = reduction_try_update_slot(                                  <L 1846>
    // entry_idx, clearance_slot, provisional_clearance_value, reducer_data.ht_values, ht_capacity       <L 1847>
    var_113 = &((var_reducer_data).ht_values);
    var_115 = wp::load(var_113);
    var_114 = reduction_try_update_slot_0(var_28, var_70, var_107, var_115, var_72);
    // previous_impact_time_value = reduction_try_update_slot(                                <L 1849>
    // entry_idx,                                                                             <L 1850>
    // wp.static(NUM_SPATIAL_DIRECTIONS),                                                     <L 1851>
    // provisional_impact_time_value,                                                         <L 1852>
    // reducer_data.ht_values,                                                                <L 1853>
    var_117 = &((var_reducer_data).ht_values);
    // ht_capacity,                                                                           <L 1854>
    var_119 = wp::load(var_117);
    var_118 = reduction_try_update_slot_0(var_28, var_116, var_111, var_119, var_72);
    // clearance_won = previous_clearance_value < provisional_clearance_value                 <L 1856>
    var_120 = (var_114 < var_107);
    // impact_time_won = previous_impact_time_value < provisional_impact_time_value           <L 1857>
    var_121 = (var_118 < var_111);
    // if clearance_won:                                                                      <L 1858>
    if (var_120) {
        // clearance_won = reducer_data.ht_values[clearance_idx] == provisional_clearance_value       <L 1859>
        var_122 = &((var_reducer_data).ht_values);
        var_124 = wp::load(var_122);
        var_123 = wp::address(var_124, var_75);
        var_126 = wp::load(var_123);
        var_125 = (var_126 == var_107);
    }
    var_127 = wp::where(var_120, var_125, var_120);
    // if impact_time_won:                                                                    <L 1860>
    if (var_121) {
        // impact_time_won = reducer_data.ht_values[impact_time_idx] == provisional_impact_time_value       <L 1861>
        var_128 = &((var_reducer_data).ht_values);
        var_130 = wp::load(var_128);
        var_129 = wp::address(var_130, var_78);
        var_132 = wp::load(var_129);
        var_131 = (var_132 == var_111);
    }
    var_133 = wp::where(var_121, var_131, var_121);
    // if not clearance_won and not impact_time_won:                                          <L 1862>
    var_135 = wp::unot(var_127);
    var_134 = var_135;
    if (var_134) {
        var_136 = wp::unot(var_133);
        var_134 = var_134 && var_136;
    }
    if (var_134) {
        // return -1                                                                          <L 1863>
        return var_137;
    }
    // contact_id = export_contact_to_buffer(shape_a, shape_b, position, contact_normal, depth, fingerprint, reducer_data)       <L 1865>
    var_138 = export_contact_to_buffer_0(var_shape_a, var_shape_b, var_position, var_6, var_depth, var_fingerprint, var_reducer_data);
    // if contact_id < 0:                                                                     <L 1866>
    var_140 = (var_138 < var_139);
    if (var_140) {
        // if clearance_won:                                                                  <L 1867>
        if (var_127) {
            // reduction_rollback_slot(                                                       <L 1868>
            // entry_idx,                                                                     <L 1869>
            // clearance_slot,                                                                <L 1870>
            // provisional_clearance_value,                                                   <L 1871>
            // previous_clearance_value,                                                      <L 1872>
            // reducer_data.ht_values,                                                        <L 1873>
            var_141 = &((var_reducer_data).ht_values);
            // ht_capacity,                                                                   <L 1874>
            var_142 = wp::load(var_141);
            reduction_rollback_slot_0(var_28, var_70, var_107, var_114, var_142, var_72);
        }
        // if impact_time_won:                                                                <L 1876>
        if (var_133) {
            // reduction_rollback_slot(                                                       <L 1877>
            // entry_idx,                                                                     <L 1878>
            // wp.static(NUM_SPATIAL_DIRECTIONS),                                             <L 1879>
            // provisional_impact_time_value,                                                 <L 1880>
            // previous_impact_time_value,                                                    <L 1881>
            // reducer_data.ht_values,                                                        <L 1882>
            var_144 = &((var_reducer_data).ht_values);
            // ht_capacity,                                                                   <L 1883>
            var_145 = wp::load(var_144);
            reduction_rollback_slot_0(var_28, var_143, var_111, var_118, var_145, var_72);
        }
        // return -1                                                                          <L 1885>
        return var_146;
    }
    // retained = bool(False)                                                                 <L 1887>
    var_148 = bool(var_147);
    // if clearance_won:                                                                      <L 1888>
    if (var_127) {
        // clearance_value = make_contact_value(clearance_score, fingerprint, contact_id, reducer_data.deterministic)       <L 1889>
        var_149 = &((var_reducer_data).deterministic);
        var_151 = wp::load(var_149);
        var_150 = make_contact_value_0(var_39, var_fingerprint, var_138, var_151);
        // if reduction_finalize_slot(                                                        <L 1890>
        // entry_idx,                                                                         <L 1891>
        // clearance_slot,                                                                    <L 1892>
        // provisional_clearance_value,                                                       <L 1893>
        // clearance_value,                                                                   <L 1894>
        // reducer_data.ht_values,                                                            <L 1895>
        var_152 = &((var_reducer_data).ht_values);
        // ht_capacity,                                                                       <L 1896>
        var_154 = wp::load(var_152);
        var_153 = reduction_finalize_slot_0(var_28, var_70, var_107, var_150, var_154, var_72);
        if (var_153) {
            // retained = True                                                                <L 1898>
        }
        var_156 = wp::where(var_153, var_155, var_148);
    }
    var_157 = wp::where(var_127, var_150, var_83);
    var_158 = wp::where(var_127, var_156, var_148);
    // if impact_time_won:                                                                    <L 1899>
    if (var_133) {
        // impact_time_value = make_contact_value(impact_time_score, fingerprint, contact_id, reducer_data.deterministic)       <L 1900>
        var_159 = &((var_reducer_data).deterministic);
        var_161 = wp::load(var_159);
        var_160 = make_contact_value_0(var_41, var_fingerprint, var_138, var_161);
        // if reduction_finalize_slot(                                                        <L 1901>
        // entry_idx,                                                                         <L 1902>
        // wp.static(NUM_SPATIAL_DIRECTIONS),                                                 <L 1903>
        // provisional_impact_time_value,                                                     <L 1904>
        // impact_time_value,                                                                 <L 1905>
        // reducer_data.ht_values,                                                            <L 1906>
        var_163 = &((var_reducer_data).ht_values);
        // ht_capacity,                                                                       <L 1907>
        var_165 = wp::load(var_163);
        var_164 = reduction_finalize_slot_0(var_28, var_162, var_111, var_160, var_165, var_72);
        if (var_164) {
            // retained = True                                                                <L 1909>
        }
        var_167 = wp::where(var_164, var_166, var_158);
    }
    var_168 = wp::where(var_133, var_160, var_86);
    var_169 = wp::where(var_133, var_167, var_158);
    // if retained:                                                                           <L 1910>
    if (var_169) {
        // return contact_id                                                                  <L 1911>
        return var_138;
    }
    // reclaim_contact_id(contact_id, reducer_data)                                           <L 1912>
    reclaim_contact_id_0(var_138, var_reducer_data);
    // return -1                                                                              <L 1913>
    return var_170;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:660
static CUDA_CALLABLE void adj_decode_oct_0(
    wp::vec_t<2, wp::float32> var_e,
    wp::vec_t<2, wp::float32> & adj_e,
    wp::vec_t<3, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction.py:256
static CUDA_CALLABLE void adj_get_slot_0(
    wp::vec_t<3, wp::float32> var_normal,
    wp::vec_t<3, wp::float32> & adj_normal,
    wp::int32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction.py:210
static CUDA_CALLABLE void adj_get_face_normal_0(
    wp::int32 var_face_idx,
    wp::int32 & adj_face_idx,
    wp::vec_t<3, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction.py:378
static CUDA_CALLABLE void adj_project_point_to_plane_0(
    wp::int32 var_bin_normal_idx,
    wp::vec_t<3, wp::float32> var_point,
    wp::int32 & adj_bin_normal_idx,
    wp::vec_t<3, wp::float32> & adj_point,
    wp::vec_t<2, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:328
static CUDA_CALLABLE void adj_make_contact_key_0(
    wp::int32 var_shape_a,
    wp::int32 var_shape_b,
    wp::int32 var_bin_id,
    wp::int32 & adj_shape_a,
    wp::int32 & adj_shape_b,
    wp::int32 & adj_bin_id,
    wp::uint64 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/hashtable.py:55
static CUDA_CALLABLE void adj__hashtable_hash_0(
    wp::uint64 var_key,
    wp::int32 var_capacity_mask,
    wp::uint64 & adj_key,
    wp::int32 & adj_capacity_mask,
    wp::int32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/hashtable.py:106
static CUDA_CALLABLE void adj_hashtable_find_or_insert_0(
    wp::uint64 var_key,
    wp::array_t<wp::uint64> var_keys,
    wp::array_t<wp::int32> var_active_slots,
    wp::uint64 & adj_key,
    wp::array_t<wp::uint64> & adj_keys,
    wp::array_t<wp::int32> & adj_active_slots,
    wp::int32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction.py:405
static CUDA_CALLABLE void adj_get_spatial_direction_2d_0(
    wp::int32 var_dir_idx,
    wp::int32 & adj_dir_idx,
    wp::vec_t<2, wp::float32> & adj_ret)
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:446
static CUDA_CALLABLE void adj__make_contact_value_det_0(
    wp::float32 var_score,
    wp::int32 var_fingerprint,
    wp::int32 var_contact_id,
    wp::float32 & adj_score,
    wp::int32 & adj_fingerprint,
    wp::int32 & adj_contact_id,
    wp::uint64 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:379
static CUDA_CALLABLE void adj__make_contact_value_fast_0(
    wp::float32 var_score,
    wp::int32 var_fingerprint,
    wp::int32 var_contact_id,
    wp::float32 & adj_score,
    wp::int32 & adj_fingerprint,
    wp::int32 & adj_contact_id,
    wp::uint64 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:573
static CUDA_CALLABLE void adj_make_contact_value_0(
    wp::float32 var_score,
    wp::int32 var_fingerprint,
    wp::int32 var_contact_id,
    wp::int32 var_deterministic,
    wp::float32 & adj_score,
    wp::int32 & adj_fingerprint,
    wp::int32 & adj_contact_id,
    wp::int32 & adj_deterministic,
    wp::uint64 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:204
static CUDA_CALLABLE void adj_reduction_update_slot_0(
    wp::int32 var_entry_idx,
    wp::int32 var_slot_id,
    wp::uint64 var_value,
    wp::array_t<wp::uint64> var_values,
    wp::int32 var_capacity,
    wp::int32 & adj_entry_idx,
    wp::int32 & adj_slot_id,
    wp::uint64 & adj_value,
    wp::array_t<wp::uint64> & adj_values,
    wp::int32 & adj_capacity)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction.py:429
static CUDA_CALLABLE void adj_compute_voxel_index_0(
    wp::vec_t<3, wp::float32> var_pos_local,
    wp::vec_t<3, wp::float32> var_aabb_lower,
    wp::vec_t<3, wp::float32> var_aabb_upper,
    wp::vec_t<3, wp::int32> var_resolution,
    wp::vec_t<3, wp::float32> & adj_pos_local,
    wp::vec_t<3, wp::float32> & adj_aabb_lower,
    wp::vec_t<3, wp::float32> & adj_aabb_upper,
    wp::vec_t<3, wp::int32> & adj_resolution,
    wp::int32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:1235
static CUDA_CALLABLE void adj_reduce_contact_in_hashtable_0(
    wp::int32 var_contact_id,
    GlobalContactReducerData_0c09c456 var_reducer_data,
    wp::float32 var_beta,
    wp::array_t<wp::transform_t<wp::float32>> var_shape_transform,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_collision_aabb_lower,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_collision_aabb_upper,
    wp::array_t<wp::vec_t<3, wp::int32>> var_shape_voxel_resolution,
    wp::int32 & adj_contact_id,
    GlobalContactReducerData_0c09c456 & adj_reducer_data,
    wp::float32 & adj_beta,
    wp::array_t<wp::transform_t<wp::float32>> & adj_shape_transform,
    wp::array_t<wp::vec_t<3, wp::float32>> & adj_shape_collision_aabb_lower,
    wp::array_t<wp::vec_t<3, wp::float32>> & adj_shape_collision_aabb_upper,
    wp::array_t<wp::vec_t<3, wp::int32>> & adj_shape_voxel_resolution)
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_data.py:90
static CUDA_CALLABLE void adj_compute_contact_approach_speed_0(
    wp::int32 var_shape_a,
    wp::int32 var_shape_b,
    wp::vec_t<3, wp::float32> var_point_a,
    wp::vec_t<3, wp::float32> var_point_b,
    wp::vec_t<3, wp::float32> var_normal_a_to_b,
    wp::array_t<wp::transform_t<wp::float32>> var_shape_transform,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_linear_velocity,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_angular_velocity,
    wp::int32 & adj_shape_a,
    wp::int32 & adj_shape_b,
    wp::vec_t<3, wp::float32> & adj_point_a,
    wp::vec_t<3, wp::float32> & adj_point_b,
    wp::vec_t<3, wp::float32> & adj_normal_a_to_b,
    wp::array_t<wp::transform_t<wp::float32>> & adj_shape_transform,
    wp::array_t<wp::vec_t<3, wp::float32>> & adj_shape_linear_velocity,
    wp::array_t<wp::vec_t<3, wp::float32>> & adj_shape_angular_velocity,
    wp::float32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:230
static CUDA_CALLABLE void adj_reduction_try_update_slot_0(
    wp::int32 var_entry_idx,
    wp::int32 var_slot_id,
    wp::uint64 var_value,
    wp::array_t<wp::uint64> var_values,
    wp::int32 var_capacity,
    wp::int32 & adj_entry_idx,
    wp::int32 & adj_slot_id,
    wp::uint64 & adj_value,
    wp::array_t<wp::uint64> & adj_values,
    wp::int32 & adj_capacity,
    wp::uint64 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:246
static CUDA_CALLABLE void adj_reduction_rollback_slot_0(
    wp::int32 var_entry_idx,
    wp::int32 var_slot_id,
    wp::uint64 var_provisional_value,
    wp::uint64 var_previous_value,
    wp::array_t<wp::uint64> var_values,
    wp::int32 var_capacity,
    wp::int32 & adj_entry_idx,
    wp::int32 & adj_slot_id,
    wp::uint64 & adj_provisional_value,
    wp::uint64 & adj_previous_value,
    wp::array_t<wp::uint64> & adj_values,
    wp::int32 & adj_capacity)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:260
static CUDA_CALLABLE void adj_reduction_finalize_slot_0(
    wp::int32 var_entry_idx,
    wp::int32 var_slot_id,
    wp::uint64 var_provisional_value,
    wp::uint64 var_final_value,
    wp::array_t<wp::uint64> var_values,
    wp::int32 var_capacity,
    wp::int32 & adj_entry_idx,
    wp::int32 & adj_slot_id,
    wp::uint64 & adj_provisional_value,
    wp::uint64 & adj_final_value,
    wp::array_t<wp::uint64> & adj_values,
    wp::int32 & adj_capacity,
    bool & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:1148
static CUDA_CALLABLE void adj_reclaim_contact_id_0(
    wp::int32 var_contact_id,
    GlobalContactReducerData_0c09c456 var_reducer_data,
    wp::int32 & adj_contact_id,
    GlobalContactReducerData_0c09c456 & adj_reducer_data)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:1744
static CUDA_CALLABLE void adj_export_and_reduce_predictive_contact_0(
    wp::int32 var_shape_a,
    wp::int32 var_shape_b,
    wp::vec_t<3, wp::float32> var_position,
    wp::vec_t<3, wp::float32> var_normal,
    wp::float32 var_depth,
    wp::float32 var_surface_offset_sum,
    wp::float32 var_radius_eff_a,
    wp::float32 var_radius_eff_b,
    wp::int32 var_fingerprint,
    wp::array_t<wp::transform_t<wp::float32>> var_shape_transform,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_linear_velocity,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_angular_velocity,
    wp::float32 var_collision_update_dt,
    wp::float32 var_max_speculative_extension,
    wp::int32 var_existing_contact_id,
    GlobalContactReducerData_0c09c456 var_reducer_data,
    wp::int32 & adj_shape_a,
    wp::int32 & adj_shape_b,
    wp::vec_t<3, wp::float32> & adj_position,
    wp::vec_t<3, wp::float32> & adj_normal,
    wp::float32 & adj_depth,
    wp::float32 & adj_surface_offset_sum,
    wp::float32 & adj_radius_eff_a,
    wp::float32 & adj_radius_eff_b,
    wp::int32 & adj_fingerprint,
    wp::array_t<wp::transform_t<wp::float32>> & adj_shape_transform,
    wp::array_t<wp::vec_t<3, wp::float32>> & adj_shape_linear_velocity,
    wp::array_t<wp::vec_t<3, wp::float32>> & adj_shape_angular_velocity,
    wp::float32 & adj_collision_update_dt,
    wp::float32 & adj_max_speculative_extension,
    wp::int32 & adj_existing_contact_id,
    GlobalContactReducerData_0c09c456 & adj_reducer_data,
    wp::int32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}



extern "C" __global__ void reduce_buffered_contacts_kernel_4418c8b2_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    GlobalContactReducerData_0c09c456 var_reducer_data,
    wp::array_t<wp::transform_t<wp::float32>> var_shape_transform,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_collision_aabb_lower,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_collision_aabb_upper,
    wp::array_t<wp::vec_t<3, wp::int32>> var_shape_voxel_resolution,
    wp::int32 var_total_num_threads)
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
        wp::array_t<wp::int32>* var_1;
        const wp::int32 var_2 = 0;
        wp::int32* var_3;
        wp::array_t<wp::int32> var_4;
        wp::int32 var_5;
        wp::int32 var_6;
        const wp::int32 var_7 = 0;
        bool var_8;
        wp::int32* var_9;
        wp::int32 var_10;
        wp::int32 var_11;
        wp::range_t var_12;
        wp::int32 var_13;
        const wp::int32 var_14 = 1;
        wp::int32 var_15;
        const wp::float32 var_16 = 0.0001;
        //---------
        // forward
        // def reduce_buffered_contacts_kernel(                                                   <L 1917>
        // tid = wp.tid()                                                                         <L 1930>
        var_0 = builtin_tid1d();
        // num_contacts = reducer_data.contact_count[0]                                           <L 1933>
        var_1 = &((var_reducer_data).contact_count);
        var_4 = wp::load(var_1);
        var_3 = wp::address(var_4, var_2);
        var_6 = wp::load(var_3);
        var_5 = wp::copy(var_6);
        // if num_contacts == 0:                                                                  <L 1936>
        var_8 = (var_5 == var_7);
        if (var_8) {
            // return                                                                             <L 1937>
            continue;
        }
        // num_contacts = wp.min(num_contacts, reducer_data.capacity)                             <L 1940>
        var_9 = &((var_reducer_data).capacity);
        var_11 = wp::load(var_9);
        var_10 = wp::min(var_5, var_11);
        // for i in range(tid, num_contacts, total_num_threads):                                  <L 1943>
        var_12 = wp::range(var_0, var_10, var_total_num_threads);
        start_for_1:;
            if (iter_cmp(var_12) == 0) goto end_for_1;
            var_13 = wp::iter_next(var_12);
            // reduce_contact_in_hashtable(                                                       <L 1944>
            // i + 1,                                                                             <L 1945>
            var_15 = wp::add(var_13, var_14);
            // reducer_data,                                                                      <L 1946>
            // wp.static(BETA_THRESHOLD),                                                         <L 1947>
            // shape_transform,                                                                   <L 1948>
            // shape_collision_aabb_lower,                                                        <L 1949>
            // shape_collision_aabb_upper,                                                        <L 1950>
            // shape_voxel_resolution,                                                            <L 1951>
            reduce_contact_in_hashtable_0(var_15, var_reducer_data, var_16, var_shape_transform, var_shape_collision_aabb_lower, var_shape_collision_aabb_upper, var_shape_voxel_resolution);
            goto start_for_1;
        end_for_1:;
    }
}



extern "C" __global__ void reduce_buffered_contacts_speculative_kernel_1bd0aed8_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    GlobalContactReducerData_0c09c456 var_reducer_data,
    wp::array_t<wp::int32> var_shape_types,
    wp::array_t<wp::vec_t<4, wp::float32>> var_shape_data,
    wp::array_t<wp::float32> var_shape_gap,
    wp::array_t<wp::transform_t<wp::float32>> var_shape_transform,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_linear_velocity,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_angular_velocity,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_collision_aabb_lower,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_collision_aabb_upper,
    wp::array_t<wp::vec_t<3, wp::int32>> var_shape_voxel_resolution,
    wp::float32 var_collision_update_dt,
    wp::float32 var_max_speculative_extension,
    wp::int32 var_total_num_threads)
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
        wp::array_t<wp::int32>* var_1;
        const wp::int32 var_2 = 0;
        wp::int32* var_3;
        wp::array_t<wp::int32> var_4;
        wp::int32* var_5;
        wp::int32 var_6;
        wp::int32 var_7;
        wp::int32 var_8;
        wp::range_t var_9;
        wp::int32 var_10;
        const wp::int32 var_11 = 1;
        wp::int32 var_12;
        wp::array_t<wp::vec_t<2, wp::int32>>* var_13;
        wp::vec_t<2, wp::int32>* var_14;
        wp::array_t<wp::vec_t<2, wp::int32>> var_15;
        wp::vec_t<2, wp::int32> var_16;
        wp::vec_t<2, wp::int32> var_17;
        const wp::int32 var_18 = 0;
        wp::int32 var_19;
        const wp::int32 var_20 = 1;
        wp::int32 var_21;
        wp::array_t<wp::vec_t<4, wp::float32>>* var_22;
        wp::vec_t<4, wp::float32>* var_23;
        wp::array_t<wp::vec_t<4, wp::float32>> var_24;
        wp::vec_t<4, wp::float32> var_25;
        wp::vec_t<4, wp::float32> var_26;
        wp::int32* var_27;
        wp::vec_t<4, wp::float32>* var_28;
        wp::float32 var_29;
        wp::int32 var_30;
        wp::vec_t<4, wp::float32> var_31;
        wp::int32* var_32;
        wp::vec_t<4, wp::float32>* var_33;
        wp::float32 var_34;
        wp::int32 var_35;
        wp::vec_t<4, wp::float32> var_36;
        wp::vec_t<4, wp::float32>* var_37;
        const wp::int32 var_38 = 3;
        wp::float32 var_39;
        wp::vec_t<4, wp::float32> var_40;
        wp::vec_t<4, wp::float32>* var_41;
        const wp::int32 var_42 = 3;
        wp::float32 var_43;
        wp::vec_t<4, wp::float32> var_44;
        wp::float32 var_45;
        const wp::int32 var_46 = 3;
        wp::float32 var_47;
        wp::float32 var_48;
        wp::float32* var_49;
        wp::float32* var_50;
        wp::float32 var_51;
        wp::float32 var_52;
        wp::float32 var_53;
        bool var_54;
        const wp::float32 var_55 = 0.0001;
        const wp::int32 var_56 = 0;
        wp::float32 var_57;
        const wp::int32 var_58 = 1;
        wp::float32 var_59;
        const wp::int32 var_60 = 2;
        wp::float32 var_61;
        wp::vec_t<3, wp::float32> var_62;
        wp::array_t<wp::vec_t<2, wp::float32>>* var_63;
        wp::vec_t<2, wp::float32>* var_64;
        wp::array_t<wp::vec_t<2, wp::float32>> var_65;
        wp::vec_t<3, wp::float32> var_66;
        wp::vec_t<2, wp::float32> var_67;
        const wp::int32 var_68 = 3;
        wp::float32 var_69;
        wp::array_t<wp::int32>* var_70;
        wp::int32* var_71;
        wp::array_t<wp::int32> var_72;
        wp::int32 var_73;
        wp::int32 var_74;
        //---------
        // forward
        // def reduce_buffered_contacts_speculative_kernel(                                       <L 1956>
        // tid = wp.tid()                                                                         <L 1972>
        var_0 = builtin_tid1d();
        // num_contacts = wp.min(reducer_data.contact_count[0], reducer_data.capacity)            <L 1973>
        var_1 = &((var_reducer_data).contact_count);
        var_4 = wp::load(var_1);
        var_3 = wp::address(var_4, var_2);
        var_5 = &((var_reducer_data).capacity);
        var_7 = wp::load(var_3);
        var_8 = wp::load(var_5);
        var_6 = wp::min(var_7, var_8);
        // for i in range(tid, num_contacts, total_num_threads):                                  <L 1974>
        var_9 = wp::range(var_0, var_6, var_total_num_threads);
        start_for_0:;
            if (iter_cmp(var_9) == 0) goto end_for_0;
            var_10 = wp::iter_next(var_9);
            // contact_id = i + 1                                                                 <L 1975>
            var_12 = wp::add(var_10, var_11);
            // pair = reducer_data.shape_pairs[contact_id]                                        <L 1976>
            var_13 = &((var_reducer_data).shape_pairs);
            var_15 = wp::load(var_13);
            var_14 = wp::address(var_15, var_12);
            var_17 = wp::load(var_14);
            var_16 = wp::copy(var_17);
            // shape_a = pair[0]                                                                  <L 1977>
            var_19 = wp::extract(var_16, var_18);
            // shape_b = pair[1]                                                                  <L 1978>
            var_21 = wp::extract(var_16, var_20);
            // pd = reducer_data.position_depth[contact_id]                                       <L 1979>
            var_22 = &((var_reducer_data).position_depth);
            var_24 = wp::load(var_22);
            var_23 = wp::address(var_24, var_12);
            var_26 = wp::load(var_23);
            var_25 = wp::copy(var_26);
            // radius_eff_a = compute_effective_radius(shape_types[shape_a], shape_data[shape_a])       <L 1980>
            var_27 = wp::address(var_shape_types, var_19);
            var_28 = wp::address(var_shape_data, var_19);
            var_30 = wp::load(var_27);
            var_31 = wp::load(var_28);
            var_29 = compute_effective_radius_0(var_30, var_31);
            // radius_eff_b = compute_effective_radius(shape_types[shape_b], shape_data[shape_b])       <L 1981>
            var_32 = wp::address(var_shape_types, var_21);
            var_33 = wp::address(var_shape_data, var_21);
            var_35 = wp::load(var_32);
            var_36 = wp::load(var_33);
            var_34 = compute_effective_radius_0(var_35, var_36);
            // surface_offset_sum = shape_data[shape_a][3] + shape_data[shape_b][3]               <L 1982>
            var_37 = wp::address(var_shape_data, var_19);
            var_40 = wp::load(var_37);
            var_39 = wp::extract(var_40, var_38);
            var_41 = wp::address(var_shape_data, var_21);
            var_44 = wp::load(var_41);
            var_43 = wp::extract(var_44, var_42);
            var_45 = wp::add(var_39, var_43);
            // clearance = pd[3] - surface_offset_sum                                             <L 1983>
            var_47 = wp::extract(var_25, var_46);
            var_48 = wp::sub(var_47, var_45);
            // base_gap_sum = shape_gap[shape_a] + shape_gap[shape_b]                             <L 1984>
            var_49 = wp::address(var_shape_gap, var_19);
            var_50 = wp::address(var_shape_gap, var_21);
            var_52 = wp::load(var_49);
            var_53 = wp::load(var_50);
            var_51 = wp::add(var_52, var_53);
            // if clearance <= base_gap_sum:                                                      <L 1985>
            var_54 = (var_48 <= var_51);
            if (var_54) {
                // reduce_contact_in_hashtable(                                                   <L 1986>
                // contact_id,                                                                    <L 1987>
                // reducer_data,                                                                  <L 1988>
                // wp.static(BETA_THRESHOLD),                                                     <L 1989>
                // shape_transform,                                                               <L 1990>
                // shape_collision_aabb_lower,                                                    <L 1991>
                // shape_collision_aabb_upper,                                                    <L 1992>
                // shape_voxel_resolution,                                                        <L 1993>
                reduce_contact_in_hashtable_0(var_12, var_reducer_data, var_55, var_shape_transform, var_shape_collision_aabb_lower, var_shape_collision_aabb_upper, var_shape_voxel_resolution);
            }
            if (!var_54) {
                // export_and_reduce_predictive_contact(                                          <L 1996>
                // shape_a,                                                                       <L 1997>
                // shape_b,                                                                       <L 1998>
                // wp.vec3(pd[0], pd[1], pd[2]),                                                  <L 1999>
                var_57 = wp::extract(var_25, var_56);
                var_59 = wp::extract(var_25, var_58);
                var_61 = wp::extract(var_25, var_60);
                var_62 = wp::vec_t<3, wp::float32>(var_57, var_59, var_61);
                // decode_oct(reducer_data.normal[contact_id]),                                   <L 2000>
                var_63 = &((var_reducer_data).normal);
                var_65 = wp::load(var_63);
                var_64 = wp::address(var_65, var_12);
                var_67 = wp::load(var_64);
                var_66 = decode_oct_0(var_67);
                // pd[3],                                                                         <L 2001>
                var_69 = wp::extract(var_25, var_68);
                // surface_offset_sum,                                                            <L 2002>
                // radius_eff_a,                                                                  <L 2003>
                // radius_eff_b,                                                                  <L 2004>
                // reducer_data.contact_fingerprints[contact_id],                                 <L 2005>
                var_70 = &((var_reducer_data).contact_fingerprints);
                var_72 = wp::load(var_70);
                var_71 = wp::address(var_72, var_12);
                // shape_transform,                                                               <L 2006>
                // shape_linear_velocity,                                                         <L 2007>
                // shape_angular_velocity,                                                        <L 2008>
                // collision_update_dt,                                                           <L 2009>
                // max_speculative_extension,                                                     <L 2010>
                // contact_id,                                                                    <L 2011>
                // reducer_data,                                                                  <L 2012>
                var_74 = wp::load(var_71);
                var_73 = export_and_reduce_predictive_contact_0(var_19, var_21, var_62, var_66, var_69, var_45, var_29, var_34, var_74, var_shape_transform, var_shape_linear_velocity, var_shape_angular_velocity, var_collision_update_dt, var_max_speculative_extension, var_12, var_reducer_data);
            }
            goto start_for_0;
        end_for_0:;
    }
}



extern "C" __global__ void _clear_active_kernel_ca21d0b7_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::uint64> var_ht_keys,
    wp::array_t<wp::uint64> var_ht_values,
    wp::array_t<wp::int32> var_ht_active_slots,
    wp::array_t<wp::vec_t<3, wp::float32>> var_agg_force,
    wp::array_t<wp::vec_t<3, wp::float32>> var_agg_depth_volume,
    wp::array_t<wp::vec_t<3, wp::float32>> var_weighted_pos_sum,
    wp::array_t<wp::float32> var_weight_sum,
    wp::array_t<wp::float32> var_total_depth_reduced,
    wp::array_t<wp::vec_t<3, wp::float32>> var_total_normal_reduced,
    wp::array_t<wp::float32> var_agg_moment_unreduced,
    wp::array_t<wp::float32> var_agg_moment_reduced,
    wp::array_t<wp::float32> var_agg_moment2_reduced,
    wp::array_t<wp::int32> var_contact_count,
    wp::array_t<wp::uint32> var_reclaimed_contact_bits,
    wp::array_t<wp::int32> var_reclaimed_contact_cursor,
    wp::array_t<wp::int32> var_ht_insert_failures,
    wp::int32 var_ht_capacity,
    wp::int32 var_values_per_key,
    wp::int32 var_num_threads)
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
        const wp::int32 var_1 = 0;
        bool var_2;
        const wp::int32 var_3 = 0;
        const wp::int32 var_4 = 0;
        wp::shape_t* var_5;
        const wp::int32 var_6 = 0;
        wp::int32 var_7;
        wp::shape_t var_8;
        const wp::int32 var_9 = 0;
        bool var_10;
        const wp::int32 var_11 = 0;
        const wp::int32 var_12 = 0;
        const wp::int32 var_13 = 0;
        const wp::int32 var_14 = 0;
        wp::int32* var_15;
        wp::int32 var_16;
        wp::int32 var_17;
        const wp::int32 var_18 = 1024;
        bool var_19;
        wp::int32 var_20;
        wp::int32 var_21;
        bool var_22;
        wp::int32 var_23;
        wp::int32 var_24;
        wp::int32* var_25;
        wp::int32 var_26;
        wp::int32 var_27;
        const wp::int32 var_28 = 0;
        bool var_29;
        const wp::uint64 var_30 = 18446744073709551615ull;
        wp::shape_t* var_31;
        const wp::int32 var_32 = 0;
        wp::int32 var_33;
        wp::shape_t var_34;
        const wp::int32 var_35 = 0;
        bool var_36;
        const wp::float32 var_37 = 0.0;
        const wp::float32 var_38 = 0.0;
        const wp::float32 var_39 = 0.0;
        wp::vec_t<3, wp::float32> var_40;
        const wp::float32 var_41 = 0.0;
        const wp::float32 var_42 = 0.0;
        const wp::float32 var_43 = 0.0;
        wp::vec_t<3, wp::float32> var_44;
        const wp::float32 var_45 = 0.0;
        const wp::float32 var_46 = 0.0;
        const wp::float32 var_47 = 0.0;
        wp::vec_t<3, wp::float32> var_48;
        const wp::float32 var_49 = 0.0;
        const wp::float32 var_50 = 0.0;
        const wp::float32 var_51 = 0.0;
        const wp::float32 var_52 = 0.0;
        const wp::float32 var_53 = 0.0;
        wp::vec_t<3, wp::float32> var_54;
        wp::shape_t* var_55;
        const wp::int32 var_56 = 0;
        wp::int32 var_57;
        wp::shape_t var_58;
        const wp::int32 var_59 = 0;
        bool var_60;
        const wp::float32 var_61 = 0.0;
        const wp::float32 var_62 = 0.0;
        const wp::float32 var_63 = 0.0;
        wp::int32 var_64;
        wp::int32 var_65;
        wp::uint64 var_66;
        wp::int32 var_67;
        wp::int32 var_68;
        bool var_69;
        wp::int32* var_70;
        wp::int32 var_71;
        wp::int32 var_72;
        const wp::uint64 var_73 = 18446744073709551615ull;
        wp::shape_t* var_74;
        const wp::int32 var_75 = 0;
        wp::int32 var_76;
        wp::shape_t var_77;
        const wp::int32 var_78 = 0;
        bool var_79;
        const wp::float32 var_80 = 0.0;
        const wp::float32 var_81 = 0.0;
        const wp::float32 var_82 = 0.0;
        wp::vec_t<3, wp::float32> var_83;
        const wp::float32 var_84 = 0.0;
        const wp::float32 var_85 = 0.0;
        const wp::float32 var_86 = 0.0;
        wp::vec_t<3, wp::float32> var_87;
        const wp::float32 var_88 = 0.0;
        const wp::float32 var_89 = 0.0;
        const wp::float32 var_90 = 0.0;
        wp::vec_t<3, wp::float32> var_91;
        const wp::float32 var_92 = 0.0;
        const wp::float32 var_93 = 0.0;
        const wp::float32 var_94 = 0.0;
        const wp::float32 var_95 = 0.0;
        const wp::float32 var_96 = 0.0;
        wp::vec_t<3, wp::float32> var_97;
        wp::shape_t* var_98;
        const wp::int32 var_99 = 0;
        wp::int32 var_100;
        wp::shape_t var_101;
        const wp::int32 var_102 = 0;
        bool var_103;
        const wp::float32 var_104 = 0.0;
        const wp::float32 var_105 = 0.0;
        const wp::float32 var_106 = 0.0;
        wp::range_t var_107;
        wp::int32 var_108;
        wp::int32 var_109;
        wp::int32 var_110;
        wp::uint64 var_111;
        wp::int32 var_112;
        wp::int32 var_113;
        wp::int32 var_114;
        wp::int32 var_115;
        wp::uint64 var_116;
        wp::int32 var_117;
        wp::int32 var_118;
        wp::shape_t* var_119;
        const wp::int32 var_120 = 0;
        wp::int32 var_121;
        wp::shape_t var_122;
        bool var_123;
        const wp::int32 var_124 = 0;
        wp::uint32 var_125;
        wp::int32 var_126;
        //---------
        // forward
        // def _clear_active_kernel(                                                              <L 757>
        // tid = wp.tid()                                                                         <L 797>
        var_0 = builtin_tid1d();
        // if tid == 0:                                                                           <L 799>
        var_2 = (var_0 == var_1);
        if (var_2) {
            // contact_count[0] = 0                                                               <L 800>
            wp::array_store(var_contact_count, var_4, var_3);
            // if reclaimed_contact_cursor.shape[0] > 0:                                          <L 801>
            var_5 = &(var_reclaimed_contact_cursor.shape);
            var_8 = wp::load(var_5);
            var_7 = wp::extract(var_8, var_6);
            var_10 = (var_7 > var_9);
            if (var_10) {
                // reclaimed_contact_cursor[0] = 0                                                <L 802>
                wp::array_store(var_reclaimed_contact_cursor, var_12, var_11);
            }
            // ht_insert_failures[0] = 0                                                          <L 803>
            wp::array_store(var_ht_insert_failures, var_14, var_13);
        }
        // count = ht_active_slots[ht_capacity]                                                   <L 807>
        var_15 = wp::address(var_ht_active_slots, var_ht_capacity);
        var_17 = wp::load(var_15);
        var_16 = wp::copy(var_17);
        // if count < wp.static(CLEAR_ACTIVE_ENTRY_PARALLEL_THRESHOLD):                           <L 809>
        var_19 = (var_16 < var_18);
        if (var_19) {
            // total_work = count * values_per_key                                                <L 810>
            var_20 = wp::mul(var_16, var_values_per_key);
            // i = tid                                                                            <L 811>
            var_21 = wp::copy(var_0);
            // while i < total_work:                                                              <L 812>
        start_while_0:;
            var_22 = (var_21 < var_20);
        if ((var_22) == false) goto end_while_0;
                // active_idx = i / values_per_key                                                <L 813>
                var_23 = wp::div(var_21, var_values_per_key);
                // local_idx = i % values_per_key                                                 <L 814>
                var_24 = wp::mod(var_21, var_values_per_key);
                // entry_idx = ht_active_slots[active_idx]                                        <L 815>
                var_25 = wp::address(var_ht_active_slots, var_23);
                var_27 = wp::load(var_25);
                var_26 = wp::copy(var_27);
                // if local_idx == 0:                                                             <L 817>
                var_29 = (var_24 == var_28);
                if (var_29) {
                    // ht_keys[entry_idx] = HASHTABLE_EMPTY_KEY                                   <L 818>
                    wp::array_store(var_ht_keys, var_26, var_30);
                    // if agg_force.shape[0] > 0:                                                 <L 819>
                    var_31 = &(var_agg_force.shape);
                    var_34 = wp::load(var_31);
                    var_33 = wp::extract(var_34, var_32);
                    var_36 = (var_33 > var_35);
                    if (var_36) {
                        // agg_force[entry_idx] = wp.vec3(0.0, 0.0, 0.0)                          <L 820>
                        var_40 = wp::vec_t<3, wp::float32>(var_37, var_38, var_39);
                        wp::array_store(var_agg_force, var_26, var_40);
                        // agg_depth_volume[entry_idx] = wp.vec3(0.0, 0.0, 0.0)                   <L 821>
                        var_44 = wp::vec_t<3, wp::float32>(var_41, var_42, var_43);
                        wp::array_store(var_agg_depth_volume, var_26, var_44);
                        // weighted_pos_sum[entry_idx] = wp.vec3(0.0, 0.0, 0.0)                   <L 822>
                        var_48 = wp::vec_t<3, wp::float32>(var_45, var_46, var_47);
                        wp::array_store(var_weighted_pos_sum, var_26, var_48);
                        // weight_sum[entry_idx] = 0.0                                            <L 823>
                        wp::array_store(var_weight_sum, var_26, var_49);
                        // total_depth_reduced[entry_idx] = 0.0                                   <L 824>
                        wp::array_store(var_total_depth_reduced, var_26, var_50);
                        // total_normal_reduced[entry_idx] = wp.vec3(0.0, 0.0, 0.0)               <L 825>
                        var_54 = wp::vec_t<3, wp::float32>(var_51, var_52, var_53);
                        wp::array_store(var_total_normal_reduced, var_26, var_54);
                        // if agg_moment_unreduced.shape[0] > 0:                                  <L 826>
                        var_55 = &(var_agg_moment_unreduced.shape);
                        var_58 = wp::load(var_55);
                        var_57 = wp::extract(var_58, var_56);
                        var_60 = (var_57 > var_59);
                        if (var_60) {
                            // agg_moment_unreduced[entry_idx] = 0.0                              <L 827>
                            wp::array_store(var_agg_moment_unreduced, var_26, var_61);
                            // agg_moment_reduced[entry_idx] = 0.0                                <L 828>
                            wp::array_store(var_agg_moment_reduced, var_26, var_62);
                            // agg_moment2_reduced[entry_idx] = 0.0                               <L 829>
                            wp::array_store(var_agg_moment2_reduced, var_26, var_63);
                        }
                    }
                }
                // value_idx = local_idx * ht_capacity + entry_idx                                <L 831>
                var_64 = wp::mul(var_24, var_ht_capacity);
                var_65 = wp::add(var_64, var_26);
                // ht_values[value_idx] = wp.uint64(0)                                            <L 832>
                var_66 = 0ull;
                wp::array_store(var_ht_values, var_65, var_66);
                // i += num_threads                                                               <L 833>
                var_67 = wp::add(var_21, var_num_threads);
                wp::assign(var_21, var_67);
        goto start_while_0;
        end_while_0:;
        }
        if (!var_19) {
            // active_idx = tid                                                                   <L 835>
            var_68 = wp::copy(var_0);
            // while active_idx < count:                                                          <L 836>
        start_while_2:;
            var_69 = (var_68 < var_16);
        if ((var_69) == false) goto end_while_2;
                // entry_idx = ht_active_slots[active_idx]                                        <L 837>
                var_70 = wp::address(var_ht_active_slots, var_68);
                var_72 = wp::load(var_70);
                var_71 = wp::copy(var_72);
                // ht_keys[entry_idx] = HASHTABLE_EMPTY_KEY                                       <L 839>
                wp::array_store(var_ht_keys, var_71, var_73);
                // if agg_force.shape[0] > 0:                                                     <L 840>
                var_74 = &(var_agg_force.shape);
                var_77 = wp::load(var_74);
                var_76 = wp::extract(var_77, var_75);
                var_79 = (var_76 > var_78);
                if (var_79) {
                    // agg_force[entry_idx] = wp.vec3(0.0, 0.0, 0.0)                              <L 841>
                    var_83 = wp::vec_t<3, wp::float32>(var_80, var_81, var_82);
                    wp::array_store(var_agg_force, var_71, var_83);
                    // agg_depth_volume[entry_idx] = wp.vec3(0.0, 0.0, 0.0)                       <L 842>
                    var_87 = wp::vec_t<3, wp::float32>(var_84, var_85, var_86);
                    wp::array_store(var_agg_depth_volume, var_71, var_87);
                    // weighted_pos_sum[entry_idx] = wp.vec3(0.0, 0.0, 0.0)                       <L 843>
                    var_91 = wp::vec_t<3, wp::float32>(var_88, var_89, var_90);
                    wp::array_store(var_weighted_pos_sum, var_71, var_91);
                    // weight_sum[entry_idx] = 0.0                                                <L 844>
                    wp::array_store(var_weight_sum, var_71, var_92);
                    // total_depth_reduced[entry_idx] = 0.0                                       <L 845>
                    wp::array_store(var_total_depth_reduced, var_71, var_93);
                    // total_normal_reduced[entry_idx] = wp.vec3(0.0, 0.0, 0.0)                   <L 846>
                    var_97 = wp::vec_t<3, wp::float32>(var_94, var_95, var_96);
                    wp::array_store(var_total_normal_reduced, var_71, var_97);
                    // if agg_moment_unreduced.shape[0] > 0:                                      <L 847>
                    var_98 = &(var_agg_moment_unreduced.shape);
                    var_101 = wp::load(var_98);
                    var_100 = wp::extract(var_101, var_99);
                    var_103 = (var_100 > var_102);
                    if (var_103) {
                        // agg_moment_unreduced[entry_idx] = 0.0                                  <L 848>
                        wp::array_store(var_agg_moment_unreduced, var_71, var_104);
                        // agg_moment_reduced[entry_idx] = 0.0                                    <L 849>
                        wp::array_store(var_agg_moment_reduced, var_71, var_105);
                        // agg_moment2_reduced[entry_idx] = 0.0                                   <L 850>
                        wp::array_store(var_agg_moment2_reduced, var_71, var_106);
                    }
                }
                // for local_idx in range(values_per_key):                                        <L 852>
                var_107 = wp::range(var_values_per_key);
                start_for_4:;
                    if (iter_cmp(var_107) == 0) goto end_for_4;
                    var_108 = wp::iter_next(var_107);
                    // value_idx = local_idx * ht_capacity + entry_idx                            <L 853>
                    var_109 = wp::mul(var_108, var_ht_capacity);
                    var_110 = wp::add(var_109, var_71);
                    // ht_values[value_idx] = wp.uint64(0)                                        <L 854>
                    var_111 = 0ull;
                    wp::array_store(var_ht_values, var_110, var_111);
                    goto start_for_4;
                end_for_4:;
                // active_idx += num_threads                                                      <L 856>
                var_112 = wp::add(var_68, var_num_threads);
                wp::assign(var_68, var_112);
        goto start_while_2;
        end_while_2:;
        }
        var_113 = wp::where(var_19, var_23, var_68);
        var_114 = wp::where(var_19, var_24, var_108);
        var_115 = wp::where(var_19, var_26, var_71);
        var_116 = wp::where(var_19, var_30, var_73);
        var_117 = wp::where(var_19, var_65, var_110);
        // i = tid                                                                                <L 859>
        var_118 = wp::copy(var_0);
        // while i < reclaimed_contact_bits.shape[0]:                                             <L 860>
        start_while_6:;
        var_119 = &(var_reclaimed_contact_bits.shape);
        var_122 = wp::load(var_119);
        var_121 = wp::extract(var_122, var_120);
        var_123 = (var_118 < var_121);
        if ((var_123) == false) goto end_while_6;
            // reclaimed_contact_bits[i] = wp.uint32(0)                                           <L 861>
            var_125 = wp::uint32(var_124);
            wp::array_store(var_reclaimed_contact_bits, var_118, var_125);
            // i += num_threads                                                                   <L 862>
            var_126 = wp::add(var_118, var_num_threads);
            wp::assign(var_118, var_126);
        goto start_while_6;
        end_while_6:;
    }
}



extern "C" __global__ void _zero_active_count_kernel_de41732d_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::int32> var_ht_active_slots,
    wp::int32 var_ht_capacity)
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
        //---------
        // forward
        // def _zero_active_count_kernel(                                                         <L 866>
        // ht_active_slots[ht_capacity] = 0                                                       <L 877>
        wp::array_store(var_ht_active_slots, var_ht_capacity, var_0);
    }
}

