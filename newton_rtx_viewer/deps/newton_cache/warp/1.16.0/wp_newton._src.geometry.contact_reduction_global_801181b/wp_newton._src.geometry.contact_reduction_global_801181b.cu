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


struct GlobalContactReducerData_98513266
{
    wp::array_t<wp::vec_t<4, wp::float32>> position_depth;
    wp::array_t<wp::vec_t<2, wp::float32>> normal;
    wp::array_t<wp::vec_t<2, wp::int32>> shape_pairs;
    wp::array_t<wp::int32> contact_count;
    wp::int32 capacity;
    wp::array_t<wp::int32> contact_fingerprints;
    wp::array_t<wp::float32> contact_area;
    wp::array_t<wp::int32> contact_nbin_entry;
    wp::array_t<wp::float32> entry_k_eff;
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


    GlobalContactReducerData_98513266() = default;
    CUDA_CALLABLE GlobalContactReducerData_98513266(wp::array_t<wp::vec_t<4, wp::float32>> const& position_depth,
    wp::array_t<wp::vec_t<2, wp::float32>> const& normal = {},
    wp::array_t<wp::vec_t<2, wp::int32>> const& shape_pairs = {},
    wp::array_t<wp::int32> const& contact_count = {},
    wp::int32 const& capacity = {},
    wp::array_t<wp::int32> const& contact_fingerprints = {},
    wp::array_t<wp::float32> const& contact_area = {},
    wp::array_t<wp::int32> const& contact_nbin_entry = {},
    wp::array_t<wp::float32> const& entry_k_eff = {},
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
        , capacity{capacity}
        , contact_fingerprints{contact_fingerprints}
        , contact_area{contact_area}
        , contact_nbin_entry{contact_nbin_entry}
        , entry_k_eff{entry_k_eff}
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

    CUDA_CALLABLE GlobalContactReducerData_98513266& operator += (const GlobalContactReducerData_98513266& rhs)
    {    capacity += rhs.capacity;
    ht_capacity += rhs.ht_capacity;
    ht_values_per_key += rhs.ht_values_per_key;
    deterministic += rhs.deterministic;

        return *this;}

};

static CUDA_CALLABLE void adj_GlobalContactReducerData_98513266(wp::array_t<wp::vec_t<4, wp::float32>> const&,
    wp::array_t<wp::vec_t<2, wp::float32>> const&,
    wp::array_t<wp::vec_t<2, wp::int32>> const&,
    wp::array_t<wp::int32> const&,
    wp::int32 const&,
    wp::array_t<wp::int32> const&,
    wp::array_t<wp::float32> const&,
    wp::array_t<wp::int32> const&,
    wp::array_t<wp::float32> const&,
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
    wp::int32 & adj_capacity,
    wp::array_t<wp::int32> & adj_contact_fingerprints,
    wp::array_t<wp::float32> & adj_contact_area,
    wp::array_t<wp::int32> & adj_contact_nbin_entry,
    wp::array_t<wp::float32> & adj_entry_k_eff,
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
    GlobalContactReducerData_98513266 & adj_ret)
{
    adj_position_depth = adj_ret.position_depth;
    adj_normal = adj_ret.normal;
    adj_shape_pairs = adj_ret.shape_pairs;
    adj_contact_count = adj_ret.contact_count;
    adj_capacity += adj_ret.capacity;
    adj_contact_fingerprints = adj_ret.contact_fingerprints;
    adj_contact_area = adj_ret.contact_area;
    adj_contact_nbin_entry = adj_ret.contact_nbin_entry;
    adj_entry_k_eff = adj_ret.entry_k_eff;
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
CUDA_CALLABLE GlobalContactReducerData_98513266 add(const GlobalContactReducerData_98513266& a, const GlobalContactReducerData_98513266& b)
{
    return GlobalContactReducerData_98513266();
}

CUDA_CALLABLE void adj_atomic_add(GlobalContactReducerData_98513266* p, GlobalContactReducerData_98513266 t)
{
    wp::adj_atomic_add(&p->position_depth, t.position_depth);
    wp::adj_atomic_add(&p->normal, t.normal);
    wp::adj_atomic_add(&p->shape_pairs, t.shape_pairs);
    wp::adj_atomic_add(&p->contact_count, t.contact_count);
    wp::adj_atomic_add(&p->capacity, t.capacity);
    wp::adj_atomic_add(&p->contact_fingerprints, t.contact_fingerprints);
    wp::adj_atomic_add(&p->contact_area, t.contact_area);
    wp::adj_atomic_add(&p->contact_nbin_entry, t.contact_nbin_entry);
    wp::adj_atomic_add(&p->entry_k_eff, t.entry_k_eff);
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction.py:210
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
    const wp::int32 var_8 = 5;
    const wp::float32 var_9 = -0.65;
    bool var_10;
    const wp::int32 var_11 = 15;
    const wp::int32 var_12 = 20;
    const wp::float32 var_13 = 0.0;
    bool var_14;
    const wp::int32 var_15 = 0;
    const wp::int32 var_16 = 15;
    const wp::int32 var_17 = 5;
    const wp::int32 var_18 = 20;
    wp::int32 var_19;
    wp::int32 var_20;
    wp::int32 var_21;
    wp::int32 var_22;
    wp::int32 var_23;
    wp::int32 var_24;
    wp::int32 var_25;
    const wp::mat_t<20, 3, wp::float32> var_26 = wp::initializer_array<60,wp::float32>{0.49112337827682495, 0.7946545481681824, 0.3568221628665924, -0.18759243190288544, 0.7946544885635376, 0.5773502588272095, -0.6070619225502014, 0.7946544885635376, 0.0, -0.18759237229824066, 0.7946544885635376, -0.5773502588272095, 0.49112340807914734, 0.7946545481681824, -0.35682210326194763, 0.9822468757629395, -0.18759256601333618, 0.0, 0.7946544289588928, 0.18759238719940186, -0.5773503184318542, 0.3035309612751007, -0.1875925213098526, 0.9341723322868347, 0.7946544289588928, 0.18759243190288544, 0.5773503184318542, -0.7946544885635376, -0.1875924915075302, 0.5773503184318542, -0.30353105068206787, 0.18759243190288544, 0.9341723918914795, -0.7946544289588928, -0.18759240210056305, -0.5773503184318542, -0.9822468757629395, 0.1875925362110138, 0.0, 0.3035309612751007, -0.1875925064086914, -0.9341723322868347, -0.30353084206581116, 0.18759246170520782, -0.9341723918914795, 0.1875924915075302, -0.7946544289588928, 0.5773502588272095, -0.49112337827682495, -0.7946544885635376, 0.35682213306427, -0.49112337827682495, -0.7946545481681824, -0.35682213306427, 0.18759243190288544, -0.7946544289588928, -0.5773502588272095, 0.6070619821548462, -0.7946544289588928, 0.0};
    wp::vec_t<3, wp::float32> var_27;
    wp::float32 var_28;
    const wp::int32 var_29 = 1;
    wp::int32 var_30;
    wp::range_t var_31;
    wp::int32 var_32;
    wp::vec_t<3, wp::float32> var_33;
    wp::float32 var_34;
    bool var_35;
    wp::float32 var_36;
    wp::int32 var_37;
    wp::int32 var_38;
    wp::float32 var_39;
    //---------
    // forward
    // def get_slot(normal: wp.vec3) -> int:                                                  <L 211>
    // if wp.static(NORMAL_BINNING_POLYHEDRON == "hexahedron"):                               <L 230>
    // elif wp.static(NORMAL_BINNING_POLYHEDRON == "dodecahedron"):                           <L 251>
    // elif wp.static(NORMAL_BINNING_POLYHEDRON == "icosahedron"):                            <L 280>
    // up_dot = normal[1]                                                                     <L 281>
    var_4 = wp::extract(var_normal, var_3);
    // if up_dot > 0.65:                                                                      <L 284>
    var_6 = (var_4 > var_5);
    if (var_6) {
        // start_idx = 0                                                                      <L 285>
        // end_idx = 5                                                                        <L 286>
    }
    if (!var_6) {
        // elif up_dot < -0.65:                                                               <L 287>
        var_10 = (var_4 < var_9);
        if (var_10) {
            // start_idx = 15                                                                 <L 288>
            // end_idx = 20                                                                   <L 289>
        }
        if (!var_10) {
            // elif up_dot >= 0.0:                                                            <L 290>
            var_14 = (var_4 >= var_13);
            if (var_14) {
                // start_idx = 0                                                              <L 291>
                // end_idx = 15                                                               <L 292>
            }
            if (!var_14) {
                // start_idx = 5                                                              <L 294>
                // end_idx = 20                                                               <L 295>
            }
            var_19 = wp::where(var_14, var_15, var_17);
            var_20 = wp::where(var_14, var_16, var_18);
        }
        var_21 = wp::where(var_10, var_11, var_19);
        var_22 = wp::where(var_10, var_12, var_20);
    }
    var_23 = wp::where(var_6, var_7, var_21);
    var_24 = wp::where(var_6, var_8, var_22);
    // best_slot = start_idx                                                                  <L 297>
    var_25 = wp::copy(var_23);
    // max_dot = wp.dot(normal, FACE_NORMALS[start_idx])                                      <L 298>
    var_27 = wp::extract(var_26, var_23);
    var_28 = wp::dot(var_normal, var_27);
    // for i in range(start_idx + 1, end_idx):                                                <L 300>
    var_30 = wp::add(var_23, var_29);
    var_31 = wp::range(var_30, var_24);
    start_for_0:;
        if (iter_cmp(var_31) == 0) goto end_for_0;
        var_32 = wp::iter_next(var_31);
        // d = wp.dot(normal, FACE_NORMALS[i])                                                <L 301>
        var_33 = wp::extract(var_26, var_32);
        var_34 = wp::dot(var_normal, var_33);
        // if d > max_dot:                                                                    <L 302>
        var_35 = (var_34 > var_28);
        if (var_35) {
            // max_dot = d                                                                    <L 303>
            var_36 = wp::copy(var_34);
            // best_slot = i                                                                  <L 304>
            var_37 = wp::copy(var_32);
        }
        var_38 = wp::where(var_35, var_37, var_25);
        var_39 = wp::where(var_35, var_36, var_28);
        wp::assign(var_25, var_38);
        wp::assign(var_28, var_39);
        goto start_for_0;
    end_for_0:;
    // return best_slot                                                                       <L 306>
    return var_25;
    return {};
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction.py:319
static CUDA_CALLABLE wp::vec_t<2, wp::float32> project_point_to_plane_0(
    wp::int32 var_bin_normal_idx,
    wp::vec_t<3, wp::float32> var_point)
{
    //---------
    // primal vars
    const wp::mat_t<20, 3, wp::float32> var_0 = wp::initializer_array<60,wp::float32>{0.49112337827682495, 0.7946545481681824, 0.3568221628665924, -0.18759243190288544, 0.7946544885635376, 0.5773502588272095, -0.6070619225502014, 0.7946544885635376, 0.0, -0.18759237229824066, 0.7946544885635376, -0.5773502588272095, 0.49112340807914734, 0.7946545481681824, -0.35682210326194763, 0.9822468757629395, -0.18759256601333618, 0.0, 0.7946544289588928, 0.18759238719940186, -0.5773503184318542, 0.3035309612751007, -0.1875925213098526, 0.9341723322868347, 0.7946544289588928, 0.18759243190288544, 0.5773503184318542, -0.7946544885635376, -0.1875924915075302, 0.5773503184318542, -0.30353105068206787, 0.18759243190288544, 0.9341723918914795, -0.7946544289588928, -0.18759240210056305, -0.5773503184318542, -0.9822468757629395, 0.1875925362110138, 0.0, 0.3035309612751007, -0.1875925064086914, -0.9341723322868347, -0.30353084206581116, 0.18759246170520782, -0.9341723918914795, 0.1875924915075302, -0.7946544289588928, 0.5773502588272095, -0.49112337827682495, -0.7946544885635376, 0.35682213306427, -0.49112337827682495, -0.7946545481681824, -0.35682213306427, 0.18759243190288544, -0.7946544289588928, -0.5773502588272095, 0.6070619821548462, -0.7946544289588928, 0.0};
    wp::vec_t<3, wp::float32> var_1;
    const wp::int32 var_2 = 1;
    wp::float32 var_3;
    wp::float32 var_4;
    const wp::float32 var_5 = 0.9;
    bool var_6;
    const wp::float32 var_7 = 0.0;
    const wp::float32 var_8 = 1.0;
    const wp::float32 var_9 = 0.0;
    wp::vec_t<3, wp::float32> var_10;
    const wp::float32 var_11 = 1.0;
    const wp::float32 var_12 = 0.0;
    const wp::float32 var_13 = 0.0;
    wp::vec_t<3, wp::float32> var_14;
    wp::vec_t<3, wp::float32> var_15;
    wp::float32 var_16;
    wp::vec_t<3, wp::float32> var_17;
    wp::vec_t<3, wp::float32> var_18;
    wp::vec_t<3, wp::float32> var_19;
    wp::vec_t<3, wp::float32> var_20;
    wp::float32 var_21;
    wp::float32 var_22;
    wp::vec_t<2, wp::float32> var_23;
    //---------
    // forward
    // def project_point_to_plane(bin_normal_idx: wp.int32, point: wp.vec3) -> wp.vec2:       <L 320>
    // face_normal = FACE_NORMALS[bin_normal_idx]                                             <L 333>
    var_1 = wp::extract(var_0, var_bin_normal_idx);
    // if wp.abs(face_normal[1]) < 0.9:                                                       <L 335>
    var_3 = wp::extract(var_1, var_2);
    var_4 = wp::abs(var_3);
    var_6 = (var_4 < var_5);
    if (var_6) {
        // ref = wp.vec3(0.0, 1.0, 0.0)                                                       <L 336>
        var_10 = wp::vec_t<3, wp::float32>(var_7, var_8, var_9);
    }
    if (!var_6) {
        // ref = wp.vec3(1.0, 0.0, 0.0)                                                       <L 338>
        var_14 = wp::vec_t<3, wp::float32>(var_11, var_12, var_13);
    }
    var_15 = wp::where(var_6, var_10, var_14);
    // u = wp.normalize(ref - wp.dot(ref, face_normal) * face_normal)                         <L 340>
    var_16 = wp::dot(var_15, var_1);
    var_17 = wp::mul(var_16, var_1);
    var_18 = wp::sub(var_15, var_17);
    var_19 = wp::normalize(var_18);
    // v = wp.cross(face_normal, u)                                                           <L 341>
    var_20 = wp::cross(var_1, var_19);
    // return wp.vec2(wp.dot(point, u), wp.dot(point, v))                                     <L 343>
    var_21 = wp::dot(var_point, var_19);
    var_22 = wp::dot(var_point, var_20);
    var_23 = wp::vec_t<2, wp::float32>(var_21, var_22);
    return var_23;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:230
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
    // def make_contact_key(shape_a: int, shape_b: int, bin_id: int) -> wp.uint64:            <L 231>
    // key = wp.uint64(shape_a) & SHAPE_A_MASK                                                <L 242>
    var_0 = wp::uint64(var_shape_a);
    var_2 = wp::bit_and(var_0, var_1);
    // key = key | ((wp.uint64(shape_b) & SHAPE_B_MASK) << SHAPE_A_BITS)                      <L 243>
    var_3 = wp::uint64(var_shape_b);
    var_5 = wp::bit_and(var_3, var_4);
    var_7 = wp::lshift(var_5, var_6);
    var_8 = wp::bit_or(var_2, var_7);
    // key = key | ((wp.uint64(bin_id) & BIN_MASK) << wp.uint64(55))                          <L 245>
    var_9 = wp::uint64(var_bin_id);
    var_11 = wp::bit_and(var_9, var_10);
    var_12 = 55ull;
    var_13 = wp::lshift(var_11, var_12);
    var_14 = wp::bit_or(var_8, var_13);
    // return key                                                                             <L 246>
    return var_14;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/hashtable.py:55
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/hashtable.py:106
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction.py:346
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
    // def get_spatial_direction_2d(dir_idx: int) -> wp.vec2:                                 <L 347>
    // angle = float(dir_idx) * (2.0 * wp.pi / float(wp.static(NUM_SPATIAL_DIRECTIONS)))       <L 356>
    var_0 = wp::float(var_dir_idx);
    var_3 = wp::mul(var_1, var_2);
    var_5 = wp::float(var_4);
    var_6 = wp::div(var_3, var_5);
    var_7 = wp::mul(var_0, var_6);
    // return wp.vec2(wp.cos(angle), wp.sin(angle))                                           <L 357>
    var_8 = wp::cos(var_7);
    var_9 = wp::sin(var_7);
    var_10 = wp::vec_t<2, wp::float32>(var_8, var_9);
    return var_10;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction.py:104
static CUDA_CALLABLE wp::uint32 float_flip_0(
    wp::float32 f)
{

uint32_t i = reinterpret_cast<uint32_t&>(f);
uint32_t mask = (uint32_t)(-(int)(i >> 31)) | 0x80000000;
return i ^ mask;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:348
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
    // def _make_contact_value_det(score: float, fingerprint: int, contact_id: int) -> wp.uint64:       <L 349>
    // return (                                                                               <L 404>
    // (wp.uint64(float_flip(score) >> wp.uint32(wp.static(SCORE_SHIFT))) << wp.uint64(42))       <L 405>
    var_0 = float_flip_0(var_score);
    var_2 = wp::uint32(var_1);
    var_3 = wp::rshift(var_0, var_2);
    var_4 = wp::uint64(var_3);
    var_5 = 42ull;
    var_6 = wp::lshift(var_4, var_5);
    // | ((wp.uint64(fingerprint) & FINGERPRINT_MASK) << CONTACT_ID_BITS)                     <L 406>
    var_7 = wp::uint64(var_fingerprint);
    var_9 = wp::bit_and(var_7, var_8);
    var_11 = wp::lshift(var_9, var_10);
    var_12 = wp::bit_or(var_6, var_11);
    // | (wp.uint64(contact_id) & CONTACT_ID_MASK)                                            <L 407>
    var_13 = wp::uint64(var_contact_id);
    var_15 = wp::bit_and(var_13, var_14);
    var_16 = wp::bit_or(var_12, var_15);
    return var_16;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:281
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
    // def _make_contact_value_fast(score: float, fingerprint: int, contact_id: int) -> wp.uint64:       <L 282>
    // return (wp.uint64(float_flip(score)) << wp.uint64(32)) | wp.uint64(contact_id)         <L 302>
    var_0 = float_flip_0(var_score);
    var_1 = wp::uint64(var_0);
    var_2 = 32ull;
    var_3 = wp::lshift(var_1, var_2);
    var_4 = wp::uint64(var_contact_id);
    var_5 = wp::bit_or(var_3, var_4);
    return var_5;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:475
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
    // def make_contact_value(score: float, fingerprint: int, contact_id: int, deterministic: int) -> wp.uint64:       <L 476>
    // if deterministic != 0:                                                                 <L 489>
    var_1 = (var_deterministic != var_0);
    if (var_1) {
        // return _make_contact_value_det(score, fingerprint, contact_id)                     <L 490>
        var_2 = _make_contact_value_det_0(var_score, var_fingerprint, var_contact_id);
        return var_2;
    }
    // return _make_contact_value_fast(score, fingerprint, contact_id)                        <L 491>
    var_3 = _make_contact_value_fast_0(var_score, var_fingerprint, var_contact_id);
    return var_3;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:150
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
    // def reduction_update_slot(                                                             <L 151>
    // value_idx = slot_id * capacity + entry_idx                                             <L 170>
    var_0 = wp::mul(var_slot_id, var_capacity);
    var_1 = wp::add(var_0, var_entry_idx);
    // if values[value_idx] < value:                                                          <L 172>
    var_2 = wp::address(var_values, var_1);
    var_4 = wp::load(var_2);
    var_3 = (var_4 < var_value);
    if (var_3) {
        // wp.atomic_max(values, value_idx, value)                                            <L 173>
        var_5 = wp::atomic_max(var_values, var_1, var_value);
    }
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction.py:370
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
    // def compute_voxel_index(                                                               <L 371>
    // size = aabb_upper - aabb_lower                                                         <L 388>
    var_0 = wp::sub(var_aabb_upper, var_aabb_lower);
    // rel = wp.vec3(0.0, 0.0, 0.0)                                                           <L 390>
    var_4 = wp::vec_t<3, wp::float32>(var_1, var_2, var_3);
    // if size[0] > 1e-6:                                                                     <L 391>
    var_6 = wp::extract(var_0, var_5);
    var_8 = (var_6 > var_7);
    if (var_8) {
        // rel = wp.vec3((pos_local[0] - aabb_lower[0]) / size[0], rel[1], rel[2])            <L 392>
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
    // if size[1] > 1e-6:                                                                     <L 393>
    var_24 = wp::extract(var_0, var_23);
    var_26 = (var_24 > var_25);
    if (var_26) {
        // rel = wp.vec3(rel[0], (pos_local[1] - aabb_lower[1]) / size[1], rel[2])            <L 394>
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
    // if size[2] > 1e-6:                                                                     <L 395>
    var_42 = wp::extract(var_0, var_41);
    var_44 = (var_42 > var_43);
    if (var_44) {
        // rel = wp.vec3(rel[0], rel[1], (pos_local[2] - aabb_lower[2]) / size[2])            <L 396>
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
    // nx = resolution[0]                                                                     <L 399>
    var_60 = wp::extract(var_resolution, var_59);
    // ny = resolution[1]                                                                     <L 400>
    var_62 = wp::extract(var_resolution, var_61);
    // nz = resolution[2]                                                                     <L 401>
    var_64 = wp::extract(var_resolution, var_63);
    // vx = wp.clamp(int(rel[0] * float(nx)), 0, nx - 1)                                      <L 403>
    var_66 = wp::extract(var_58, var_65);
    var_67 = wp::float(var_60);
    var_68 = wp::mul(var_66, var_67);
    var_69 = wp::int(var_68);
    var_72 = wp::sub(var_60, var_71);
    var_73 = wp::clamp(var_69, var_70, var_72);
    // vy = wp.clamp(int(rel[1] * float(ny)), 0, ny - 1)                                      <L 404>
    var_75 = wp::extract(var_58, var_74);
    var_76 = wp::float(var_62);
    var_77 = wp::mul(var_75, var_76);
    var_78 = wp::int(var_77);
    var_81 = wp::sub(var_62, var_80);
    var_82 = wp::clamp(var_78, var_79, var_81);
    // vz = wp.clamp(int(rel[2] * float(nz)), 0, nz - 1)                                      <L 405>
    var_84 = wp::extract(var_58, var_83);
    var_85 = wp::float(var_64);
    var_86 = wp::mul(var_84, var_85);
    var_87 = wp::int(var_86);
    var_90 = wp::sub(var_64, var_89);
    var_91 = wp::clamp(var_87, var_88, var_90);
    // return vx + vy * nx + vz * nx * ny                                                     <L 407>
    var_92 = wp::mul(var_82, var_60);
    var_93 = wp::add(var_73, var_92);
    var_94 = wp::mul(var_91, var_60);
    var_95 = wp::mul(var_94, var_62);
    var_96 = wp::add(var_93, var_95);
    return var_96;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:1046
static CUDA_CALLABLE void reduce_contact_in_hashtable_0(
    wp::int32 var_contact_id,
    GlobalContactReducerData_98513266 var_reducer_data,
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
    // def reduce_contact_in_hashtable(                                                       <L 1047>
    // pd = reducer_data.position_depth[contact_id]                                           <L 1079>
    var_0 = &((var_reducer_data).position_depth);
    var_2 = wp::load(var_0);
    var_1 = wp::address(var_2, var_contact_id);
    var_4 = wp::load(var_1);
    var_3 = wp::copy(var_4);
    // normal = decode_oct(reducer_data.normal[contact_id])                                   <L 1080>
    var_5 = &((var_reducer_data).normal);
    var_7 = wp::load(var_5);
    var_6 = wp::address(var_7, var_contact_id);
    var_9 = wp::load(var_6);
    var_8 = decode_oct_0(var_9);
    // pair = reducer_data.shape_pairs[contact_id]                                            <L 1081>
    var_10 = &((var_reducer_data).shape_pairs);
    var_12 = wp::load(var_10);
    var_11 = wp::address(var_12, var_contact_id);
    var_14 = wp::load(var_11);
    var_13 = wp::copy(var_14);
    // fingerprint = reducer_data.contact_fingerprints[contact_id]                            <L 1082>
    var_15 = &((var_reducer_data).contact_fingerprints);
    var_17 = wp::load(var_15);
    var_16 = wp::address(var_17, var_contact_id);
    var_19 = wp::load(var_16);
    var_18 = wp::copy(var_19);
    // position = wp.vec3(pd[0], pd[1], pd[2])                                                <L 1084>
    var_21 = wp::extract(var_3, var_20);
    var_23 = wp::extract(var_3, var_22);
    var_25 = wp::extract(var_3, var_24);
    var_26 = wp::vec_t<3, wp::float32>(var_21, var_23, var_25);
    // depth = pd[3]                                                                          <L 1085>
    var_28 = wp::extract(var_3, var_27);
    // shape_a = pair[0]  # Mesh shape                                                        <L 1086>
    var_30 = wp::extract(var_13, var_29);
    // shape_b = pair[1]  # Convex shape                                                      <L 1087>
    var_32 = wp::extract(var_13, var_31);
    // aabb_lower = shape_collision_aabb_lower[shape_a]                                       <L 1089>
    var_33 = wp::address(var_shape_collision_aabb_lower, var_30);
    var_35 = wp::load(var_33);
    var_34 = wp::copy(var_35);
    // aabb_upper = shape_collision_aabb_upper[shape_a]                                       <L 1090>
    var_36 = wp::address(var_shape_collision_aabb_upper, var_30);
    var_38 = wp::load(var_36);
    var_37 = wp::copy(var_38);
    // ht_capacity = reducer_data.ht_capacity                                                 <L 1092>
    var_39 = &((var_reducer_data).ht_capacity);
    var_41 = wp::load(var_39);
    var_40 = wp::copy(var_41);
    // bin_id = get_slot(normal)                                                              <L 1096>
    var_42 = get_slot_0(var_8);
    // pos_2d = project_point_to_plane(bin_id, position)                                      <L 1099>
    var_43 = project_point_to_plane_0(var_42, var_26);
    // key = make_contact_key(shape_a, shape_b, bin_id)                                       <L 1102>
    var_44 = make_contact_key_0(var_30, var_32, var_42);
    // entry_idx = hashtable_find_or_insert(key, reducer_data.ht_keys, reducer_data.ht_active_slots)       <L 1105>
    var_45 = &((var_reducer_data).ht_keys);
    var_46 = &((var_reducer_data).ht_active_slots);
    var_48 = wp::load(var_45);
    var_49 = wp::load(var_46);
    var_47 = hashtable_find_or_insert_0(var_44, var_48, var_49);
    // if entry_idx >= 0:                                                                     <L 1106>
    var_51 = (var_47 >= var_50);
    if (var_51) {
        // use_beta = depth < beta * wp.length(aabb_upper - aabb_lower)                       <L 1107>
        var_52 = wp::sub(var_37, var_34);
        var_53 = wp::length(var_52);
        var_54 = wp::mul(var_beta, var_53);
        var_55 = (var_28 < var_54);
        // for dir_i in range(wp.static(NUM_SPATIAL_DIRECTIONS)):                             <L 1108>
        // if use_beta:                                                                       <L 1109>
        if (var_55) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1110>
            var_57 = get_spatial_direction_2d_0(var_56);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1111>
            var_58 = wp::dot(var_43, var_57);
            // value = make_contact_value(score, fingerprint, contact_id, reducer_data.deterministic)       <L 1112>
            var_59 = &((var_reducer_data).deterministic);
            var_61 = wp::load(var_59);
            var_60 = make_contact_value_0(var_58, var_18, var_contact_id, var_61);
            // slot_id = dir_i                                                                <L 1113>
            var_62 = wp::copy(var_56);
            // reduction_update_slot(entry_idx, slot_id, value, reducer_data.ht_values, ht_capacity)       <L 1114>
            var_63 = &((var_reducer_data).ht_values);
            var_64 = wp::load(var_63);
            reduction_update_slot_0(var_47, var_62, var_60, var_64, var_40);
        }
        // if use_beta:                                                                       <L 1109>
        if (var_55) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1110>
            var_66 = get_spatial_direction_2d_0(var_65);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1111>
            var_67 = wp::dot(var_43, var_66);
            // value = make_contact_value(score, fingerprint, contact_id, reducer_data.deterministic)       <L 1112>
            var_68 = &((var_reducer_data).deterministic);
            var_70 = wp::load(var_68);
            var_69 = make_contact_value_0(var_67, var_18, var_contact_id, var_70);
            // slot_id = dir_i                                                                <L 1113>
            var_71 = wp::copy(var_65);
            // reduction_update_slot(entry_idx, slot_id, value, reducer_data.ht_values, ht_capacity)       <L 1114>
            var_72 = &((var_reducer_data).ht_values);
            var_73 = wp::load(var_72);
            reduction_update_slot_0(var_47, var_71, var_69, var_73, var_40);
        }
        var_74 = wp::where(var_55, var_66, var_57);
        var_75 = wp::where(var_55, var_67, var_58);
        var_76 = wp::where(var_55, var_69, var_60);
        var_77 = wp::where(var_55, var_71, var_62);
        // if use_beta:                                                                       <L 1109>
        if (var_55) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1110>
            var_79 = get_spatial_direction_2d_0(var_78);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1111>
            var_80 = wp::dot(var_43, var_79);
            // value = make_contact_value(score, fingerprint, contact_id, reducer_data.deterministic)       <L 1112>
            var_81 = &((var_reducer_data).deterministic);
            var_83 = wp::load(var_81);
            var_82 = make_contact_value_0(var_80, var_18, var_contact_id, var_83);
            // slot_id = dir_i                                                                <L 1113>
            var_84 = wp::copy(var_78);
            // reduction_update_slot(entry_idx, slot_id, value, reducer_data.ht_values, ht_capacity)       <L 1114>
            var_85 = &((var_reducer_data).ht_values);
            var_86 = wp::load(var_85);
            reduction_update_slot_0(var_47, var_84, var_82, var_86, var_40);
        }
        var_87 = wp::where(var_55, var_79, var_74);
        var_88 = wp::where(var_55, var_80, var_75);
        var_89 = wp::where(var_55, var_82, var_76);
        var_90 = wp::where(var_55, var_84, var_77);
        // if use_beta:                                                                       <L 1109>
        if (var_55) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1110>
            var_92 = get_spatial_direction_2d_0(var_91);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1111>
            var_93 = wp::dot(var_43, var_92);
            // value = make_contact_value(score, fingerprint, contact_id, reducer_data.deterministic)       <L 1112>
            var_94 = &((var_reducer_data).deterministic);
            var_96 = wp::load(var_94);
            var_95 = make_contact_value_0(var_93, var_18, var_contact_id, var_96);
            // slot_id = dir_i                                                                <L 1113>
            var_97 = wp::copy(var_91);
            // reduction_update_slot(entry_idx, slot_id, value, reducer_data.ht_values, ht_capacity)       <L 1114>
            var_98 = &((var_reducer_data).ht_values);
            var_99 = wp::load(var_98);
            reduction_update_slot_0(var_47, var_97, var_95, var_99, var_40);
        }
        var_100 = wp::where(var_55, var_92, var_87);
        var_101 = wp::where(var_55, var_93, var_88);
        var_102 = wp::where(var_55, var_95, var_89);
        var_103 = wp::where(var_55, var_97, var_90);
        // if use_beta:                                                                       <L 1109>
        if (var_55) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1110>
            var_105 = get_spatial_direction_2d_0(var_104);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1111>
            var_106 = wp::dot(var_43, var_105);
            // value = make_contact_value(score, fingerprint, contact_id, reducer_data.deterministic)       <L 1112>
            var_107 = &((var_reducer_data).deterministic);
            var_109 = wp::load(var_107);
            var_108 = make_contact_value_0(var_106, var_18, var_contact_id, var_109);
            // slot_id = dir_i                                                                <L 1113>
            var_110 = wp::copy(var_104);
            // reduction_update_slot(entry_idx, slot_id, value, reducer_data.ht_values, ht_capacity)       <L 1114>
            var_111 = &((var_reducer_data).ht_values);
            var_112 = wp::load(var_111);
            reduction_update_slot_0(var_47, var_110, var_108, var_112, var_40);
        }
        var_113 = wp::where(var_55, var_105, var_100);
        var_114 = wp::where(var_55, var_106, var_101);
        var_115 = wp::where(var_55, var_108, var_102);
        var_116 = wp::where(var_55, var_110, var_103);
        // if use_beta:                                                                       <L 1109>
        if (var_55) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1110>
            var_118 = get_spatial_direction_2d_0(var_117);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1111>
            var_119 = wp::dot(var_43, var_118);
            // value = make_contact_value(score, fingerprint, contact_id, reducer_data.deterministic)       <L 1112>
            var_120 = &((var_reducer_data).deterministic);
            var_122 = wp::load(var_120);
            var_121 = make_contact_value_0(var_119, var_18, var_contact_id, var_122);
            // slot_id = dir_i                                                                <L 1113>
            var_123 = wp::copy(var_117);
            // reduction_update_slot(entry_idx, slot_id, value, reducer_data.ht_values, ht_capacity)       <L 1114>
            var_124 = &((var_reducer_data).ht_values);
            var_125 = wp::load(var_124);
            reduction_update_slot_0(var_47, var_123, var_121, var_125, var_40);
        }
        var_126 = wp::where(var_55, var_118, var_113);
        var_127 = wp::where(var_55, var_119, var_114);
        var_128 = wp::where(var_55, var_121, var_115);
        var_129 = wp::where(var_55, var_123, var_116);
        // max_depth_value = make_contact_value(-depth, fingerprint, contact_id, reducer_data.deterministic)       <L 1116>
        var_130 = wp::neg(var_28);
        var_131 = &((var_reducer_data).deterministic);
        var_133 = wp::load(var_131);
        var_132 = make_contact_value_0(var_130, var_18, var_contact_id, var_133);
        // reduction_update_slot(                                                             <L 1117>
        // entry_idx, wp.static(NUM_SPATIAL_DIRECTIONS), max_depth_value, reducer_data.ht_values, ht_capacity       <L 1118>
        var_135 = &((var_reducer_data).ht_values);
        var_136 = wp::load(var_135);
        reduction_update_slot_0(var_47, var_134, var_132, var_136, var_40);
    }
    if (!var_51) {
        // wp.atomic_add(reducer_data.ht_insert_failures, 0, 1)                               <L 1121>
        var_137 = &((var_reducer_data).ht_insert_failures);
        var_141 = wp::load(var_137);
        var_140 = wp::atomic_add(var_141, var_138, var_139);
    }
    // X_shape_ws = shape_transform[shape_a]                                                  <L 1125>
    var_142 = wp::address(var_shape_transform, var_30);
    var_144 = wp::load(var_142);
    var_143 = wp::copy(var_144);
    // X_ws_shape = wp.transform_inverse(X_shape_ws)                                          <L 1126>
    var_145 = wp::transform_inverse(var_143);
    // position_local = wp.transform_point(X_ws_shape, position)                              <L 1127>
    var_146 = wp::transform_point(var_145, var_26);
    // voxel_res = shape_voxel_resolution[shape_a]                                            <L 1130>
    var_147 = wp::address(var_shape_voxel_resolution, var_30);
    var_149 = wp::load(var_147);
    var_148 = wp::copy(var_149);
    // voxel_idx = compute_voxel_index(position_local, aabb_lower, aabb_upper, voxel_res)       <L 1131>
    var_150 = compute_voxel_index_0(var_146, var_34, var_37, var_148);
    // voxel_idx = wp.clamp(voxel_idx, 0, wp.static(NUM_VOXEL_DEPTH_SLOTS - 1))               <L 1134>
    var_153 = wp::clamp(var_150, var_151, var_152);
    // voxels_per_group = wp.static(NUM_SPATIAL_DIRECTIONS + 1)                               <L 1136>
    // voxel_group = voxel_idx // voxels_per_group                                            <L 1137>
    var_155 = wp::floordiv(var_153, var_154);
    // voxel_local_slot = voxel_idx % voxels_per_group                                        <L 1138>
    var_156 = wp::mod(var_153, var_154);
    // voxel_bin_id = wp.static(NUM_NORMAL_BINS) + voxel_group                                <L 1140>
    var_158 = wp::add(var_157, var_155);
    // voxel_key = make_contact_key(shape_a, shape_b, voxel_bin_id)                           <L 1141>
    var_159 = make_contact_key_0(var_30, var_32, var_158);
    // voxel_entry_idx = hashtable_find_or_insert(voxel_key, reducer_data.ht_keys, reducer_data.ht_active_slots)       <L 1143>
    var_160 = &((var_reducer_data).ht_keys);
    var_161 = &((var_reducer_data).ht_active_slots);
    var_163 = wp::load(var_160);
    var_164 = wp::load(var_161);
    var_162 = hashtable_find_or_insert_0(var_159, var_163, var_164);
    // if voxel_entry_idx >= 0:                                                               <L 1144>
    var_166 = (var_162 >= var_165);
    if (var_166) {
        // voxel_value = make_contact_value(-depth, fingerprint, contact_id, reducer_data.deterministic)       <L 1146>
        var_167 = wp::neg(var_28);
        var_168 = &((var_reducer_data).deterministic);
        var_170 = wp::load(var_168);
        var_169 = make_contact_value_0(var_167, var_18, var_contact_id, var_170);
        // reduction_update_slot(voxel_entry_idx, voxel_local_slot, voxel_value, reducer_data.ht_values, ht_capacity)       <L 1147>
        var_171 = &((var_reducer_data).ht_values);
        var_172 = wp::load(var_171);
        reduction_update_slot_0(var_162, var_156, var_169, var_172, var_40);
    }
    if (!var_166) {
        // wp.atomic_add(reducer_data.ht_insert_failures, 0, 1)                               <L 1149>
        var_173 = &((var_reducer_data).ht_insert_failures);
        var_177 = wp::load(var_173);
        var_176 = wp::atomic_add(var_177, var_174, var_175);
    }
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:562
static CUDA_CALLABLE void adj_decode_oct_0(
    wp::vec_t<2, wp::float32> var_e,
    wp::vec_t<2, wp::float32> & adj_e,
    wp::vec_t<3, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction.py:210
static CUDA_CALLABLE void adj_get_slot_0(
    wp::vec_t<3, wp::float32> var_normal,
    wp::vec_t<3, wp::float32> & adj_normal,
    wp::int32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction.py:319
static CUDA_CALLABLE void adj_project_point_to_plane_0(
    wp::int32 var_bin_normal_idx,
    wp::vec_t<3, wp::float32> var_point,
    wp::int32 & adj_bin_normal_idx,
    wp::vec_t<3, wp::float32> & adj_point,
    wp::vec_t<2, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:230
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/hashtable.py:55
static CUDA_CALLABLE void adj__hashtable_hash_0(
    wp::uint64 var_key,
    wp::int32 var_capacity_mask,
    wp::uint64 & adj_key,
    wp::int32 & adj_capacity_mask,
    wp::int32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/hashtable.py:106
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction.py:346
static CUDA_CALLABLE void adj_get_spatial_direction_2d_0(
    wp::int32 var_dir_idx,
    wp::int32 & adj_dir_idx,
    wp::vec_t<2, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction.py:104
static CUDA_CALLABLE void adj_float_flip_0(
    wp::float32 f,
    wp::float32 & adj_f,
    wp::uint32 & adj_ret)
{
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:348
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:281
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:475
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:150
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction.py:370
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:1046
static CUDA_CALLABLE void adj_reduce_contact_in_hashtable_0(
    wp::int32 var_contact_id,
    GlobalContactReducerData_98513266 var_reducer_data,
    wp::float32 var_beta,
    wp::array_t<wp::transform_t<wp::float32>> var_shape_transform,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_collision_aabb_lower,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_collision_aabb_upper,
    wp::array_t<wp::vec_t<3, wp::int32>> var_shape_voxel_resolution,
    wp::int32 & adj_contact_id,
    GlobalContactReducerData_98513266 & adj_reducer_data,
    wp::float32 & adj_beta,
    wp::array_t<wp::transform_t<wp::float32>> & adj_shape_transform,
    wp::array_t<wp::vec_t<3, wp::float32>> & adj_shape_collision_aabb_lower,
    wp::array_t<wp::vec_t<3, wp::float32>> & adj_shape_collision_aabb_upper,
    wp::array_t<wp::vec_t<3, wp::int32>> & adj_shape_voxel_resolution)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
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
        // def _zero_active_count_kernel(                                                         <L 741>
        // ht_active_slots[ht_capacity] = 0                                                       <L 752>
        wp::array_store(var_ht_active_slots, var_ht_capacity, var_0);
    }
}



extern "C" __global__ void reduce_buffered_contacts_kernel_088d1a40_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    GlobalContactReducerData_98513266 var_reducer_data,
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
        const wp::float32 var_14 = 0.0001;
        //---------
        // forward
        // def reduce_buffered_contacts_kernel(                                                   <L 1437>
        // tid = wp.tid()                                                                         <L 1450>
        var_0 = builtin_tid1d();
        // num_contacts = reducer_data.contact_count[0]                                           <L 1453>
        var_1 = &((var_reducer_data).contact_count);
        var_4 = wp::load(var_1);
        var_3 = wp::address(var_4, var_2);
        var_6 = wp::load(var_3);
        var_5 = wp::copy(var_6);
        // if num_contacts == 0:                                                                  <L 1456>
        var_8 = (var_5 == var_7);
        if (var_8) {
            // return                                                                             <L 1457>
            continue;
        }
        // num_contacts = wp.min(num_contacts, reducer_data.capacity)                             <L 1460>
        var_9 = &((var_reducer_data).capacity);
        var_11 = wp::load(var_9);
        var_10 = wp::min(var_5, var_11);
        // for i in range(tid, num_contacts, total_num_threads):                                  <L 1463>
        var_12 = wp::range(var_0, var_10, var_total_num_threads);
        start_for_1:;
            if (iter_cmp(var_12) == 0) goto end_for_1;
            var_13 = wp::iter_next(var_12);
            // reduce_contact_in_hashtable(                                                       <L 1464>
            // i,                                                                                 <L 1465>
            // reducer_data,                                                                      <L 1466>
            // wp.static(BETA_THRESHOLD),                                                         <L 1467>
            // shape_transform,                                                                   <L 1468>
            // shape_collision_aabb_lower,                                                        <L 1469>
            // shape_collision_aabb_upper,                                                        <L 1470>
            // shape_voxel_resolution,                                                            <L 1471>
            reduce_contact_in_hashtable_0(var_13, var_reducer_data, var_14, var_shape_transform, var_shape_collision_aabb_lower, var_shape_collision_aabb_upper, var_shape_voxel_resolution);
            goto start_for_1;
        end_for_1:;
    }
}



extern "C" __global__ void _clear_active_kernel_4660aa1f_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::uint64> var_ht_keys,
    wp::array_t<wp::uint64> var_ht_values,
    wp::array_t<wp::int32> var_ht_active_slots,
    wp::array_t<wp::vec_t<3, wp::float32>> var_agg_force,
    wp::array_t<wp::vec_t<3, wp::float32>> var_agg_depth_volume,
    wp::array_t<wp::vec_t<3, wp::float32>> var_weighted_pos_sum,
    wp::array_t<wp::float32> var_weight_sum,
    wp::array_t<wp::float32> var_entry_k_eff,
    wp::array_t<wp::float32> var_total_depth_reduced,
    wp::array_t<wp::vec_t<3, wp::float32>> var_total_normal_reduced,
    wp::array_t<wp::float32> var_agg_moment_unreduced,
    wp::array_t<wp::float32> var_agg_moment_reduced,
    wp::array_t<wp::float32> var_agg_moment2_reduced,
    wp::array_t<wp::int32> var_contact_count,
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
        const wp::int32 var_5 = 0;
        const wp::int32 var_6 = 0;
        wp::int32* var_7;
        wp::int32 var_8;
        wp::int32 var_9;
        wp::int32 var_10;
        wp::int32 var_11;
        bool var_12;
        wp::int32 var_13;
        wp::int32 var_14;
        wp::int32* var_15;
        wp::int32 var_16;
        wp::int32 var_17;
        const wp::int32 var_18 = 0;
        bool var_19;
        const wp::uint64 var_20 = 18446744073709551615ull;
        wp::shape_t* var_21;
        const wp::int32 var_22 = 0;
        wp::int32 var_23;
        wp::shape_t var_24;
        const wp::int32 var_25 = 0;
        bool var_26;
        const wp::float32 var_27 = 0.0;
        const wp::float32 var_28 = 0.0;
        const wp::float32 var_29 = 0.0;
        wp::vec_t<3, wp::float32> var_30;
        const wp::float32 var_31 = 0.0;
        const wp::float32 var_32 = 0.0;
        const wp::float32 var_33 = 0.0;
        wp::vec_t<3, wp::float32> var_34;
        const wp::float32 var_35 = 0.0;
        const wp::float32 var_36 = 0.0;
        const wp::float32 var_37 = 0.0;
        wp::vec_t<3, wp::float32> var_38;
        const wp::float32 var_39 = 0.0;
        const wp::float32 var_40 = 0.0;
        const wp::float32 var_41 = 0.0;
        const wp::float32 var_42 = 0.0;
        const wp::float32 var_43 = 0.0;
        const wp::float32 var_44 = 0.0;
        wp::vec_t<3, wp::float32> var_45;
        wp::shape_t* var_46;
        const wp::int32 var_47 = 0;
        wp::int32 var_48;
        wp::shape_t var_49;
        const wp::int32 var_50 = 0;
        bool var_51;
        const wp::float32 var_52 = 0.0;
        const wp::float32 var_53 = 0.0;
        const wp::float32 var_54 = 0.0;
        wp::int32 var_55;
        wp::int32 var_56;
        wp::uint64 var_57;
        wp::int32 var_58;
        //---------
        // forward
        // def _clear_active_kernel(                                                              <L 660>
        // tid = wp.tid()                                                                         <L 696>
        var_0 = builtin_tid1d();
        // if tid == 0:                                                                           <L 698>
        var_2 = (var_0 == var_1);
        if (var_2) {
            // contact_count[0] = 0                                                               <L 699>
            wp::array_store(var_contact_count, var_4, var_3);
            // ht_insert_failures[0] = 0                                                          <L 700>
            wp::array_store(var_ht_insert_failures, var_6, var_5);
        }
        // count = ht_active_slots[ht_capacity]                                                   <L 704>
        var_7 = wp::address(var_ht_active_slots, var_ht_capacity);
        var_9 = wp::load(var_7);
        var_8 = wp::copy(var_9);
        // total_work = count * values_per_key                                                    <L 707>
        var_10 = wp::mul(var_8, var_values_per_key);
        // i = tid                                                                                <L 710>
        var_11 = wp::copy(var_0);
        // while i < total_work:                                                                  <L 711>
        start_while_0:;
        var_12 = (var_11 < var_10);
        if ((var_12) == false) goto end_while_0;
            // active_idx = i / values_per_key                                                    <L 713>
            var_13 = wp::div(var_11, var_values_per_key);
            // local_idx = i % values_per_key                                                     <L 714>
            var_14 = wp::mod(var_11, var_values_per_key);
            // entry_idx = ht_active_slots[active_idx]                                            <L 715>
            var_15 = wp::address(var_ht_active_slots, var_13);
            var_17 = wp::load(var_15);
            var_16 = wp::copy(var_17);
            // if local_idx == 0:                                                                 <L 718>
            var_19 = (var_14 == var_18);
            if (var_19) {
                // ht_keys[entry_idx] = HASHTABLE_EMPTY_KEY                                       <L 719>
                wp::array_store(var_ht_keys, var_16, var_20);
                // if agg_force.shape[0] > 0:                                                     <L 721>
                var_21 = &(var_agg_force.shape);
                var_24 = wp::load(var_21);
                var_23 = wp::extract(var_24, var_22);
                var_26 = (var_23 > var_25);
                if (var_26) {
                    // agg_force[entry_idx] = wp.vec3(0.0, 0.0, 0.0)                              <L 722>
                    var_30 = wp::vec_t<3, wp::float32>(var_27, var_28, var_29);
                    wp::array_store(var_agg_force, var_16, var_30);
                    // agg_depth_volume[entry_idx] = wp.vec3(0.0, 0.0, 0.0)                       <L 723>
                    var_34 = wp::vec_t<3, wp::float32>(var_31, var_32, var_33);
                    wp::array_store(var_agg_depth_volume, var_16, var_34);
                    // weighted_pos_sum[entry_idx] = wp.vec3(0.0, 0.0, 0.0)                       <L 724>
                    var_38 = wp::vec_t<3, wp::float32>(var_35, var_36, var_37);
                    wp::array_store(var_weighted_pos_sum, var_16, var_38);
                    // weight_sum[entry_idx] = 0.0                                                <L 725>
                    wp::array_store(var_weight_sum, var_16, var_39);
                    // entry_k_eff[entry_idx] = 0.0                                               <L 726>
                    wp::array_store(var_entry_k_eff, var_16, var_40);
                    // total_depth_reduced[entry_idx] = 0.0                                       <L 727>
                    wp::array_store(var_total_depth_reduced, var_16, var_41);
                    // total_normal_reduced[entry_idx] = wp.vec3(0.0, 0.0, 0.0)                   <L 728>
                    var_45 = wp::vec_t<3, wp::float32>(var_42, var_43, var_44);
                    wp::array_store(var_total_normal_reduced, var_16, var_45);
                    // if agg_moment_unreduced.shape[0] > 0:                                      <L 729>
                    var_46 = &(var_agg_moment_unreduced.shape);
                    var_49 = wp::load(var_46);
                    var_48 = wp::extract(var_49, var_47);
                    var_51 = (var_48 > var_50);
                    if (var_51) {
                        // agg_moment_unreduced[entry_idx] = 0.0                                  <L 730>
                        wp::array_store(var_agg_moment_unreduced, var_16, var_52);
                        // agg_moment_reduced[entry_idx] = 0.0                                    <L 731>
                        wp::array_store(var_agg_moment_reduced, var_16, var_53);
                        // agg_moment2_reduced[entry_idx] = 0.0                                   <L 732>
                        wp::array_store(var_agg_moment2_reduced, var_16, var_54);
                    }
                }
            }
            // value_idx = local_idx * ht_capacity + entry_idx                                    <L 735>
            var_55 = wp::mul(var_14, var_ht_capacity);
            var_56 = wp::add(var_55, var_16);
            // ht_values[value_idx] = wp.uint64(0)                                                <L 736>
            var_57 = 0ull;
            wp::array_store(var_ht_values, var_56, var_57);
            // i += num_threads                                                                   <L 737>
            var_58 = wp::add(var_11, var_num_threads);
            wp::assign(var_11, var_58);
        goto start_while_0;
        end_while_0:;
    }
}

