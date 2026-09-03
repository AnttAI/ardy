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


struct GenericShapeData_ceaba563
{
    wp::int32 shape_type;
    wp::vec_t<3, wp::float32> scale;
    wp::vec_t<3, wp::float32> auxiliary;


    GenericShapeData_ceaba563() = default;
    CUDA_CALLABLE GenericShapeData_ceaba563(wp::int32 const& shape_type,
    wp::vec_t<3, wp::float32> const& scale = {},
    wp::vec_t<3, wp::float32> const& auxiliary = {})
        : shape_type{shape_type}
        , scale{scale}
        , auxiliary{auxiliary}

    {
    }

    CUDA_CALLABLE GenericShapeData_ceaba563& operator += (const GenericShapeData_ceaba563& rhs)
    {    shape_type += rhs.shape_type;
    scale += rhs.scale;
    auxiliary += rhs.auxiliary;

        return *this;}

};

static CUDA_CALLABLE void adj_GenericShapeData_ceaba563(wp::int32 const&,
    wp::vec_t<3, wp::float32> const&,
    wp::vec_t<3, wp::float32> const&,
    wp::int32 & adj_shape_type,
    wp::vec_t<3, wp::float32> & adj_scale,
    wp::vec_t<3, wp::float32> & adj_auxiliary,
    GenericShapeData_ceaba563 & adj_ret)
{
    adj_shape_type += adj_ret.shape_type;
    adj_scale += adj_ret.scale;
    adj_auxiliary += adj_ret.auxiliary;
}

// Required when compiling adjoints.
CUDA_CALLABLE GenericShapeData_ceaba563 add(const GenericShapeData_ceaba563& a, const GenericShapeData_ceaba563& b)
{
    return GenericShapeData_ceaba563();
}

CUDA_CALLABLE void adj_atomic_add(GenericShapeData_ceaba563* p, GenericShapeData_ceaba563 t)
{
    wp::adj_atomic_add(&p->shape_type, t.shape_type);
    wp::adj_atomic_add(&p->scale, t.scale);
    wp::adj_atomic_add(&p->auxiliary, t.auxiliary);
}




struct HeightfieldData_f2b8d59a
{
    wp::int32 data_offset;
    wp::int32 nrow;
    wp::int32 ncol;
    wp::float32 hx;
    wp::float32 hy;
    wp::float32 min_z;
    wp::float32 max_z;


    HeightfieldData_f2b8d59a() = default;
    CUDA_CALLABLE HeightfieldData_f2b8d59a(wp::int32 const& data_offset,
    wp::int32 const& nrow = {},
    wp::int32 const& ncol = {},
    wp::float32 const& hx = {},
    wp::float32 const& hy = {},
    wp::float32 const& min_z = {},
    wp::float32 const& max_z = {})
        : data_offset{data_offset}
        , nrow{nrow}
        , ncol{ncol}
        , hx{hx}
        , hy{hy}
        , min_z{min_z}
        , max_z{max_z}

    {
    }

    CUDA_CALLABLE HeightfieldData_f2b8d59a& operator += (const HeightfieldData_f2b8d59a& rhs)
    {    data_offset += rhs.data_offset;
    nrow += rhs.nrow;
    ncol += rhs.ncol;
    hx += rhs.hx;
    hy += rhs.hy;
    min_z += rhs.min_z;
    max_z += rhs.max_z;

        return *this;}

};

static CUDA_CALLABLE void adj_HeightfieldData_f2b8d59a(wp::int32 const&,
    wp::int32 const&,
    wp::int32 const&,
    wp::float32 const&,
    wp::float32 const&,
    wp::float32 const&,
    wp::float32 const&,
    wp::int32 & adj_data_offset,
    wp::int32 & adj_nrow,
    wp::int32 & adj_ncol,
    wp::float32 & adj_hx,
    wp::float32 & adj_hy,
    wp::float32 & adj_min_z,
    wp::float32 & adj_max_z,
    HeightfieldData_f2b8d59a & adj_ret)
{
    adj_data_offset += adj_ret.data_offset;
    adj_nrow += adj_ret.nrow;
    adj_ncol += adj_ret.ncol;
    adj_hx += adj_ret.hx;
    adj_hy += adj_ret.hy;
    adj_min_z += adj_ret.min_z;
    adj_max_z += adj_ret.max_z;
}

// Required when compiling adjoints.
CUDA_CALLABLE HeightfieldData_f2b8d59a add(const HeightfieldData_f2b8d59a& a, const HeightfieldData_f2b8d59a& b)
{
    return HeightfieldData_f2b8d59a();
}

CUDA_CALLABLE void adj_atomic_add(HeightfieldData_f2b8d59a* p, HeightfieldData_f2b8d59a t)
{
    wp::adj_atomic_add(&p->data_offset, t.data_offset);
    wp::adj_atomic_add(&p->nrow, t.nrow);
    wp::adj_atomic_add(&p->ncol, t.ncol);
    wp::adj_atomic_add(&p->hx, t.hx);
    wp::adj_atomic_add(&p->hy, t.hy);
    wp::adj_atomic_add(&p->min_z, t.min_z);
    wp::adj_atomic_add(&p->max_z, t.max_z);
}




struct SupportMapDataProvider_e77f8b9f
{
    char _dummy_;


    
    CUDA_CALLABLE SupportMapDataProvider_e77f8b9f()
    
    {
    }

    CUDA_CALLABLE SupportMapDataProvider_e77f8b9f& operator += (const SupportMapDataProvider_e77f8b9f& rhs)
    {
        return *this;}

};

static CUDA_CALLABLE void adj_SupportMapDataProvider_e77f8b9f(SupportMapDataProvider_e77f8b9f & adj_ret)
{
}

// Required when compiling adjoints.
CUDA_CALLABLE SupportMapDataProvider_e77f8b9f add(const SupportMapDataProvider_e77f8b9f& a, const SupportMapDataProvider_e77f8b9f& b)
{
    return SupportMapDataProvider_e77f8b9f();
}

CUDA_CALLABLE void adj_atomic_add(SupportMapDataProvider_e77f8b9f* p, SupportMapDataProvider_e77f8b9f t)
{
}




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




struct Vert_99873389
{
    wp::vec_t<3, wp::float32> B;
    wp::vec_t<3, wp::float32> BtoA;


    Vert_99873389() = default;
    CUDA_CALLABLE Vert_99873389(wp::vec_t<3, wp::float32> const& B,
    wp::vec_t<3, wp::float32> const& BtoA = {})
        : B{B}
        , BtoA{BtoA}

    {
    }

    CUDA_CALLABLE Vert_99873389& operator += (const Vert_99873389& rhs)
    {    B += rhs.B;
    BtoA += rhs.BtoA;

        return *this;}

};

static CUDA_CALLABLE void adj_Vert_99873389(wp::vec_t<3, wp::float32> const&,
    wp::vec_t<3, wp::float32> const&,
    wp::vec_t<3, wp::float32> & adj_B,
    wp::vec_t<3, wp::float32> & adj_BtoA,
    Vert_99873389 & adj_ret)
{
    adj_B += adj_ret.B;
    adj_BtoA += adj_ret.BtoA;
}

// Required when compiling adjoints.
CUDA_CALLABLE Vert_99873389 add(const Vert_99873389& a, const Vert_99873389& b)
{
    return Vert_99873389();
}

CUDA_CALLABLE void adj_atomic_add(Vert_99873389* p, Vert_99873389 t)
{
    wp::adj_atomic_add(&p->B, t.B);
    wp::adj_atomic_add(&p->BtoA, t.BtoA);
}




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




struct IncrementalPlaneTracker_8af6ef33
{
    wp::vec_t<3, wp::float32> reference_point;
    wp::vec_t<3, wp::float32> previous_point;
    wp::vec_t<3, wp::float32> normal;
    wp::float32 largest_area_sq;


    IncrementalPlaneTracker_8af6ef33() = default;
    CUDA_CALLABLE IncrementalPlaneTracker_8af6ef33(wp::vec_t<3, wp::float32> const& reference_point,
    wp::vec_t<3, wp::float32> const& previous_point = {},
    wp::vec_t<3, wp::float32> const& normal = {},
    wp::float32 const& largest_area_sq = {})
        : reference_point{reference_point}
        , previous_point{previous_point}
        , normal{normal}
        , largest_area_sq{largest_area_sq}

    {
    }

    CUDA_CALLABLE IncrementalPlaneTracker_8af6ef33& operator += (const IncrementalPlaneTracker_8af6ef33& rhs)
    {    reference_point += rhs.reference_point;
    previous_point += rhs.previous_point;
    normal += rhs.normal;
    largest_area_sq += rhs.largest_area_sq;

        return *this;}

};

static CUDA_CALLABLE void adj_IncrementalPlaneTracker_8af6ef33(wp::vec_t<3, wp::float32> const&,
    wp::vec_t<3, wp::float32> const&,
    wp::vec_t<3, wp::float32> const&,
    wp::float32 const&,
    wp::vec_t<3, wp::float32> & adj_reference_point,
    wp::vec_t<3, wp::float32> & adj_previous_point,
    wp::vec_t<3, wp::float32> & adj_normal,
    wp::float32 & adj_largest_area_sq,
    IncrementalPlaneTracker_8af6ef33 & adj_ret)
{
    adj_reference_point += adj_ret.reference_point;
    adj_previous_point += adj_ret.previous_point;
    adj_normal += adj_ret.normal;
    adj_largest_area_sq += adj_ret.largest_area_sq;
}

// Required when compiling adjoints.
CUDA_CALLABLE IncrementalPlaneTracker_8af6ef33 add(const IncrementalPlaneTracker_8af6ef33& a, const IncrementalPlaneTracker_8af6ef33& b)
{
    return IncrementalPlaneTracker_8af6ef33();
}

CUDA_CALLABLE void adj_atomic_add(IncrementalPlaneTracker_8af6ef33* p, IncrementalPlaneTracker_8af6ef33 t)
{
    wp::adj_atomic_add(&p->reference_point, t.reference_point);
    wp::adj_atomic_add(&p->previous_point, t.previous_point);
    wp::adj_atomic_add(&p->normal, t.normal);
    wp::adj_atomic_add(&p->largest_area_sq, t.largest_area_sq);
}




struct BodyProjector_d067bb7a
{
    wp::float32 plane_d;
    wp::vec_t<3, wp::float32> normal;


    BodyProjector_d067bb7a() = default;
    CUDA_CALLABLE BodyProjector_d067bb7a(wp::float32 const& plane_d,
    wp::vec_t<3, wp::float32> const& normal = {})
        : plane_d{plane_d}
        , normal{normal}

    {
    }

    CUDA_CALLABLE BodyProjector_d067bb7a& operator += (const BodyProjector_d067bb7a& rhs)
    {    plane_d += rhs.plane_d;
    normal += rhs.normal;

        return *this;}

};

static CUDA_CALLABLE void adj_BodyProjector_d067bb7a(wp::float32 const&,
    wp::vec_t<3, wp::float32> const&,
    wp::float32 & adj_plane_d,
    wp::vec_t<3, wp::float32> & adj_normal,
    BodyProjector_d067bb7a & adj_ret)
{
    adj_plane_d += adj_ret.plane_d;
    adj_normal += adj_ret.normal;
}

// Required when compiling adjoints.
CUDA_CALLABLE BodyProjector_d067bb7a add(const BodyProjector_d067bb7a& a, const BodyProjector_d067bb7a& b)
{
    return BodyProjector_d067bb7a();
}

CUDA_CALLABLE void adj_atomic_add(BodyProjector_d067bb7a* p, BodyProjector_d067bb7a t)
{
    wp::adj_atomic_add(&p->plane_d, t.plane_d);
    wp::adj_atomic_add(&p->normal, t.normal);
}




// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/utils/heightfield.py:280
static CUDA_CALLABLE void get_triangle_shape_from_heightfield_0(
    HeightfieldData_f2b8d59a var_hfd,
    wp::array_t<wp::float32> var_elevation_data,
    wp::transform_t<wp::float32> var_X_ws,
    wp::int32 var_tri_idx,
    GenericShapeData_ceaba563 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 2;
    wp::int32 var_1;
    const wp::int32 var_2 = 2;
    wp::int32 var_3;
    wp::int32 var_4;
    wp::int32* var_5;
    const wp::int32 var_6 = 1;
    wp::int32 var_7;
    wp::int32 var_8;
    wp::int32 var_9;
    wp::int32 var_10;
    wp::int32 var_11;
    const wp::float32 var_12 = 2.0;
    wp::float32* var_13;
    wp::float32 var_14;
    wp::float32 var_15;
    wp::int32* var_16;
    const wp::int32 var_17 = 1;
    wp::int32 var_18;
    wp::int32 var_19;
    wp::float32 var_20;
    wp::float32 var_21;
    const wp::float32 var_22 = 2.0;
    wp::float32* var_23;
    wp::float32 var_24;
    wp::float32 var_25;
    wp::int32* var_26;
    const wp::int32 var_27 = 1;
    wp::int32 var_28;
    wp::int32 var_29;
    wp::float32 var_30;
    wp::float32 var_31;
    wp::float32* var_32;
    wp::float32* var_33;
    wp::float32 var_34;
    wp::float32 var_35;
    wp::float32 var_36;
    wp::float32* var_37;
    wp::float32 var_38;
    wp::float32 var_39;
    wp::float32 var_40;
    wp::float32 var_41;
    wp::float32 var_42;
    wp::float32 var_43;
    wp::float32* var_44;
    wp::float32 var_45;
    wp::float32 var_46;
    wp::float32 var_47;
    wp::float32 var_48;
    wp::float32 var_49;
    wp::float32 var_50;
    wp::int32* var_51;
    wp::int32 var_52;
    wp::int32 var_53;
    wp::int32* var_54;
    wp::int32 var_55;
    wp::int32 var_56;
    wp::int32 var_57;
    wp::int32 var_58;
    wp::float32* var_59;
    wp::float32 var_60;
    wp::float32 var_61;
    wp::int32* var_62;
    wp::int32 var_63;
    wp::int32 var_64;
    wp::int32 var_65;
    const wp::int32 var_66 = 1;
    wp::int32 var_67;
    wp::int32 var_68;
    wp::float32* var_69;
    wp::float32 var_70;
    wp::float32 var_71;
    const wp::int32 var_72 = 1;
    wp::int32 var_73;
    wp::int32* var_74;
    wp::int32 var_75;
    wp::int32 var_76;
    wp::int32 var_77;
    wp::int32 var_78;
    wp::float32* var_79;
    wp::float32 var_80;
    wp::float32 var_81;
    const wp::int32 var_82 = 1;
    wp::int32 var_83;
    wp::int32* var_84;
    wp::int32 var_85;
    wp::int32 var_86;
    wp::int32 var_87;
    const wp::int32 var_88 = 1;
    wp::int32 var_89;
    wp::int32 var_90;
    wp::float32* var_91;
    wp::float32 var_92;
    wp::float32 var_93;
    wp::float32* var_94;
    wp::float32 var_95;
    wp::float32 var_96;
    wp::float32 var_97;
    wp::float32* var_98;
    wp::float32 var_99;
    wp::float32 var_100;
    wp::float32 var_101;
    wp::float32* var_102;
    wp::float32 var_103;
    wp::float32 var_104;
    wp::float32 var_105;
    wp::float32* var_106;
    wp::float32 var_107;
    wp::float32 var_108;
    wp::float32 var_109;
    wp::vec_t<3, wp::float32> var_110;
    wp::vec_t<3, wp::float32> var_111;
    wp::vec_t<3, wp::float32> var_112;
    wp::vec_t<3, wp::float32> var_113;
    const wp::int32 var_114 = 0;
    bool var_115;
    wp::vec_t<3, wp::float32> var_116;
    wp::vec_t<3, wp::float32> var_117;
    wp::vec_t<3, wp::float32> var_118;
    wp::vec_t<3, wp::float32> var_119;
    wp::vec_t<3, wp::float32> var_120;
    wp::vec_t<3, wp::float32> var_121;
    wp::vec_t<3, wp::float32> var_122;
    wp::vec_t<3, wp::float32> var_123;
    wp::vec_t<3, wp::float32> var_124;
    wp::vec_t<3, wp::float32> var_125;
    GenericShapeData_ceaba563 var_126;
    const wp::int32 var_127 = 1001;
    const wp::int32 var_128 = 1001;
    wp::int32 var_129;
    wp::vec_t<3, wp::float32> var_130;
    wp::vec_t<3, wp::float32> var_131;
    //---------
    // forward
    // def get_triangle_shape_from_heightfield(                                               <L 281>
    // cell_idx = tri_idx // 2                                                                <L 304>
    var_1 = wp::floordiv(var_tri_idx, var_0);
    // tri_sub = tri_idx - cell_idx * 2                                                       <L 305>
    var_3 = wp::mul(var_1, var_2);
    var_4 = wp::sub(var_tri_idx, var_3);
    // cols = hfd.ncol - 1                                                                    <L 306>
    var_5 = &((var_hfd).ncol);
    var_8 = wp::load(var_5);
    var_7 = wp::sub(var_8, var_6);
    // row = cell_idx // cols                                                                 <L 307>
    var_9 = wp::floordiv(var_1, var_7);
    // col = cell_idx - row * cols                                                            <L 308>
    var_10 = wp::mul(var_9, var_7);
    var_11 = wp::sub(var_1, var_10);
    // dx = 2.0 * hfd.hx / wp.float32(hfd.ncol - 1)                                           <L 311>
    var_13 = &((var_hfd).hx);
    var_15 = wp::load(var_13);
    var_14 = wp::mul(var_12, var_15);
    var_16 = &((var_hfd).ncol);
    var_19 = wp::load(var_16);
    var_18 = wp::sub(var_19, var_17);
    var_20 = wp::float32(var_18);
    var_21 = wp::div(var_14, var_20);
    // dy = 2.0 * hfd.hy / wp.float32(hfd.nrow - 1)                                           <L 312>
    var_23 = &((var_hfd).hy);
    var_25 = wp::load(var_23);
    var_24 = wp::mul(var_22, var_25);
    var_26 = &((var_hfd).nrow);
    var_29 = wp::load(var_26);
    var_28 = wp::sub(var_29, var_27);
    var_30 = wp::float32(var_28);
    var_31 = wp::div(var_24, var_30);
    // z_range = hfd.max_z - hfd.min_z                                                        <L 313>
    var_32 = &((var_hfd).max_z);
    var_33 = &((var_hfd).min_z);
    var_35 = wp::load(var_32);
    var_36 = wp::load(var_33);
    var_34 = wp::sub(var_35, var_36);
    // x0 = -hfd.hx + wp.float32(col) * dx                                                    <L 316>
    var_37 = &((var_hfd).hx);
    var_39 = wp::load(var_37);
    var_38 = wp::neg(var_39);
    var_40 = wp::float32(var_11);
    var_41 = wp::mul(var_40, var_21);
    var_42 = wp::add(var_38, var_41);
    // x1 = x0 + dx                                                                           <L 317>
    var_43 = wp::add(var_42, var_21);
    // y0 = -hfd.hy + wp.float32(row) * dy                                                    <L 318>
    var_44 = &((var_hfd).hy);
    var_46 = wp::load(var_44);
    var_45 = wp::neg(var_46);
    var_47 = wp::float32(var_9);
    var_48 = wp::mul(var_47, var_31);
    var_49 = wp::add(var_45, var_48);
    // y1 = y0 + dy                                                                           <L 319>
    var_50 = wp::add(var_49, var_31);
    // base = hfd.data_offset                                                                 <L 322>
    var_51 = &((var_hfd).data_offset);
    var_53 = wp::load(var_51);
    var_52 = wp::copy(var_53);
    // h00 = elevation_data[base + row * hfd.ncol + col]                                      <L 323>
    var_54 = &((var_hfd).ncol);
    var_56 = wp::load(var_54);
    var_55 = wp::mul(var_9, var_56);
    var_57 = wp::add(var_52, var_55);
    var_58 = wp::add(var_57, var_11);
    var_59 = wp::address(var_elevation_data, var_58);
    var_61 = wp::load(var_59);
    var_60 = wp::copy(var_61);
    // h10 = elevation_data[base + row * hfd.ncol + (col + 1)]                                <L 324>
    var_62 = &((var_hfd).ncol);
    var_64 = wp::load(var_62);
    var_63 = wp::mul(var_9, var_64);
    var_65 = wp::add(var_52, var_63);
    var_67 = wp::add(var_11, var_66);
    var_68 = wp::add(var_65, var_67);
    var_69 = wp::address(var_elevation_data, var_68);
    var_71 = wp::load(var_69);
    var_70 = wp::copy(var_71);
    // h01 = elevation_data[base + (row + 1) * hfd.ncol + col]                                <L 325>
    var_73 = wp::add(var_9, var_72);
    var_74 = &((var_hfd).ncol);
    var_76 = wp::load(var_74);
    var_75 = wp::mul(var_73, var_76);
    var_77 = wp::add(var_52, var_75);
    var_78 = wp::add(var_77, var_11);
    var_79 = wp::address(var_elevation_data, var_78);
    var_81 = wp::load(var_79);
    var_80 = wp::copy(var_81);
    // h11 = elevation_data[base + (row + 1) * hfd.ncol + (col + 1)]                          <L 326>
    var_83 = wp::add(var_9, var_82);
    var_84 = &((var_hfd).ncol);
    var_86 = wp::load(var_84);
    var_85 = wp::mul(var_83, var_86);
    var_87 = wp::add(var_52, var_85);
    var_89 = wp::add(var_11, var_88);
    var_90 = wp::add(var_87, var_89);
    var_91 = wp::address(var_elevation_data, var_90);
    var_93 = wp::load(var_91);
    var_92 = wp::copy(var_93);
    // z00 = hfd.min_z + h00 * z_range                                                        <L 329>
    var_94 = &((var_hfd).min_z);
    var_95 = wp::mul(var_60, var_34);
    var_97 = wp::load(var_94);
    var_96 = wp::add(var_97, var_95);
    // z10 = hfd.min_z + h10 * z_range                                                        <L 330>
    var_98 = &((var_hfd).min_z);
    var_99 = wp::mul(var_70, var_34);
    var_101 = wp::load(var_98);
    var_100 = wp::add(var_101, var_99);
    // z01 = hfd.min_z + h01 * z_range                                                        <L 331>
    var_102 = &((var_hfd).min_z);
    var_103 = wp::mul(var_80, var_34);
    var_105 = wp::load(var_102);
    var_104 = wp::add(var_105, var_103);
    // z11 = hfd.min_z + h11 * z_range                                                        <L 332>
    var_106 = &((var_hfd).min_z);
    var_107 = wp::mul(var_92, var_34);
    var_109 = wp::load(var_106);
    var_108 = wp::add(var_109, var_107);
    // p00 = wp.vec3(x0, y0, z00)                                                             <L 335>
    var_110 = wp::vec_t<3, wp::float32>(var_42, var_49, var_96);
    // p10 = wp.vec3(x1, y0, z10)                                                             <L 336>
    var_111 = wp::vec_t<3, wp::float32>(var_43, var_49, var_100);
    // p01 = wp.vec3(x0, y1, z01)                                                             <L 337>
    var_112 = wp::vec_t<3, wp::float32>(var_42, var_50, var_104);
    // p11 = wp.vec3(x1, y1, z11)                                                             <L 338>
    var_113 = wp::vec_t<3, wp::float32>(var_43, var_50, var_108);
    // if tri_sub == 0:                                                                       <L 341>
    var_115 = (var_4 == var_114);
    if (var_115) {
        // v0_local = p00                                                                     <L 342>
        var_116 = wp::copy(var_110);
        // v1_local = p10                                                                     <L 343>
        var_117 = wp::copy(var_111);
        // v2_local = p11                                                                     <L 344>
        var_118 = wp::copy(var_113);
    }
    if (!var_115) {
        // v0_local = p00                                                                     <L 346>
        var_119 = wp::copy(var_110);
        // v1_local = p11                                                                     <L 347>
        var_120 = wp::copy(var_113);
        // v2_local = p01                                                                     <L 348>
        var_121 = wp::copy(var_112);
    }
    var_122 = wp::where(var_115, var_116, var_119);
    var_123 = wp::where(var_115, var_117, var_120);
    var_124 = wp::where(var_115, var_118, var_121);
    // v0_world = wp.transform_point(X_ws, v0_local)                                          <L 351>
    var_125 = wp::transform_point(var_X_ws, var_122);
    // shape_data = GenericShapeData()                                                        <L 357>
    var_126 = GenericShapeData_ceaba563();
    // shape_data.shape_type = int(GeoTypeEx.TRIANGLE_PRISM)                                  <L 358>
    var_129 = wp::int(var_128);
    var_126.shape_type = var_129;
    // shape_data.scale = v1_local - v0_local  # B - A in local space                         <L 359>
    var_130 = wp::sub(var_123, var_122);
    var_126.scale = var_130;
    // shape_data.auxiliary = v2_local - v0_local  # C - A in local space                     <L 360>
    var_131 = wp::sub(var_124, var_122);
    var_126.auxiliary = var_131;
    // return shape_data, v0_world                                                            <L 362>
    ret_0 = var_126;
    ret_1 = var_125;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/collision_core.py:1083
static CUDA_CALLABLE void get_triangle_shape_from_mesh_0(
    wp::uint64 var_mesh_id,
    wp::vec_t<3, wp::float32> var_mesh_scale,
    wp::transform_t<wp::float32> var_X_mesh_ws,
    wp::int32 var_tri_idx,
    GenericShapeData_ceaba563 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    wp::Mesh var_0;
    wp::array_t<wp::int32>* var_1;
    const wp::int32 var_2 = 3;
    wp::int32 var_3;
    const wp::int32 var_4 = 0;
    wp::int32 var_5;
    wp::int32* var_6;
    wp::array_t<wp::int32> var_7;
    wp::int32 var_8;
    wp::int32 var_9;
    wp::array_t<wp::int32>* var_10;
    const wp::int32 var_11 = 3;
    wp::int32 var_12;
    const wp::int32 var_13 = 1;
    wp::int32 var_14;
    wp::int32* var_15;
    wp::array_t<wp::int32> var_16;
    wp::int32 var_17;
    wp::int32 var_18;
    wp::array_t<wp::int32>* var_19;
    const wp::int32 var_20 = 3;
    wp::int32 var_21;
    const wp::int32 var_22 = 2;
    wp::int32 var_23;
    wp::int32* var_24;
    wp::array_t<wp::int32> var_25;
    wp::int32 var_26;
    wp::int32 var_27;
    const wp::int32 var_28 = 0;
    wp::float32 var_29;
    const wp::int32 var_30 = 1;
    wp::float32 var_31;
    wp::float32 var_32;
    const wp::int32 var_33 = 2;
    wp::float32 var_34;
    wp::float32 var_35;
    const wp::float32 var_36 = 0.0;
    bool var_37;
    wp::int32 var_38;
    wp::int32 var_39;
    wp::int32 var_40;
    wp::int32 var_41;
    wp::int32 var_42;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_43;
    wp::vec_t<3, wp::float32>* var_44;
    wp::array_t<wp::vec_t<3, wp::float32>> var_45;
    wp::vec_t<3, wp::float32> var_46;
    wp::vec_t<3, wp::float32> var_47;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_48;
    wp::vec_t<3, wp::float32>* var_49;
    wp::array_t<wp::vec_t<3, wp::float32>> var_50;
    wp::vec_t<3, wp::float32> var_51;
    wp::vec_t<3, wp::float32> var_52;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_53;
    wp::vec_t<3, wp::float32>* var_54;
    wp::array_t<wp::vec_t<3, wp::float32>> var_55;
    wp::vec_t<3, wp::float32> var_56;
    wp::vec_t<3, wp::float32> var_57;
    wp::vec_t<3, wp::float32> var_58;
    wp::vec_t<3, wp::float32> var_59;
    wp::vec_t<3, wp::float32> var_60;
    GenericShapeData_ceaba563 var_61;
    const wp::int32 var_62 = 1000;
    const wp::int32 var_63 = 1000;
    wp::int32 var_64;
    wp::vec_t<3, wp::float32> var_65;
    wp::vec_t<3, wp::float32> var_66;
    //---------
    // forward
    // def get_triangle_shape_from_mesh(                                                      <L 1084>
    // mesh = wp.mesh_get(mesh_id)                                                            <L 1109>
    var_0 = wp::mesh_get(var_mesh_id);
    // idx0 = mesh.indices[tri_idx * 3 + 0]                                                   <L 1112>
    var_1 = &((var_0).indices);
    var_3 = wp::mul(var_tri_idx, var_2);
    var_5 = wp::add(var_3, var_4);
    var_7 = wp::load(var_1);
    var_6 = wp::address(var_7, var_5);
    var_9 = wp::load(var_6);
    var_8 = wp::copy(var_9);
    // idx1 = mesh.indices[tri_idx * 3 + 1]                                                   <L 1113>
    var_10 = &((var_0).indices);
    var_12 = wp::mul(var_tri_idx, var_11);
    var_14 = wp::add(var_12, var_13);
    var_16 = wp::load(var_10);
    var_15 = wp::address(var_16, var_14);
    var_18 = wp::load(var_15);
    var_17 = wp::copy(var_18);
    // idx2 = mesh.indices[tri_idx * 3 + 2]                                                   <L 1114>
    var_19 = &((var_0).indices);
    var_21 = wp::mul(var_tri_idx, var_20);
    var_23 = wp::add(var_21, var_22);
    var_25 = wp::load(var_19);
    var_24 = wp::address(var_25, var_23);
    var_27 = wp::load(var_24);
    var_26 = wp::copy(var_27);
    // if mesh_scale[0] * mesh_scale[1] * mesh_scale[2] < 0.0:                                <L 1120>
    var_29 = wp::extract(var_mesh_scale, var_28);
    var_31 = wp::extract(var_mesh_scale, var_30);
    var_32 = wp::mul(var_29, var_31);
    var_34 = wp::extract(var_mesh_scale, var_33);
    var_35 = wp::mul(var_32, var_34);
    var_37 = (var_35 < var_36);
    if (var_37) {
        // tmp = idx1                                                                         <L 1121>
        var_38 = wp::copy(var_17);
        // idx1 = idx2                                                                        <L 1122>
        var_39 = wp::copy(var_26);
        // idx2 = tmp                                                                         <L 1123>
        var_40 = wp::copy(var_38);
    }
    var_41 = wp::where(var_37, var_39, var_17);
    var_42 = wp::where(var_37, var_40, var_26);
    // v0_local = wp.cw_mul(mesh.points[idx0], mesh_scale)                                    <L 1126>
    var_43 = &((var_0).points);
    var_45 = wp::load(var_43);
    var_44 = wp::address(var_45, var_8);
    var_47 = wp::load(var_44);
    var_46 = wp::cw_mul(var_47, var_mesh_scale);
    // v1_local = wp.cw_mul(mesh.points[idx1], mesh_scale)                                    <L 1127>
    var_48 = &((var_0).points);
    var_50 = wp::load(var_48);
    var_49 = wp::address(var_50, var_41);
    var_52 = wp::load(var_49);
    var_51 = wp::cw_mul(var_52, var_mesh_scale);
    // v2_local = wp.cw_mul(mesh.points[idx2], mesh_scale)                                    <L 1128>
    var_53 = &((var_0).points);
    var_55 = wp::load(var_53);
    var_54 = wp::address(var_55, var_42);
    var_57 = wp::load(var_54);
    var_56 = wp::cw_mul(var_57, var_mesh_scale);
    // v0_world = wp.transform_point(X_mesh_ws, v0_local)                                     <L 1131>
    var_58 = wp::transform_point(var_X_mesh_ws, var_46);
    // v1_world = wp.transform_point(X_mesh_ws, v1_local)                                     <L 1132>
    var_59 = wp::transform_point(var_X_mesh_ws, var_51);
    // v2_world = wp.transform_point(X_mesh_ws, v2_local)                                     <L 1133>
    var_60 = wp::transform_point(var_X_mesh_ws, var_56);
    // shape_data = GenericShapeData()                                                        <L 1136>
    var_61 = GenericShapeData_ceaba563();
    // shape_data.shape_type = int(GeoTypeEx.TRIANGLE)                                        <L 1137>
    var_64 = wp::int(var_63);
    var_61.shape_type = var_64;
    // shape_data.scale = v1_world - v0_world  # B - A                                        <L 1138>
    var_65 = wp::sub(var_59, var_58);
    var_61.scale = var_65;
    // shape_data.auxiliary = v2_world - v0_world  # C - A                                    <L 1139>
    var_66 = wp::sub(var_60, var_58);
    var_61.auxiliary = var_66;
    // return shape_data, v0_world                                                            <L 1141>
    ret_0 = var_61;
    ret_1 = var_58;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/support_function.py:60
static CUDA_CALLABLE wp::vec_t<3, wp::float32> pack_mesh_ptr_0(
    wp::uint64 var_ptr)
{
    //---------
    // primal vars
    wp::uint64 var_0;
    wp::uint64 var_1;
    wp::float32 var_2;
    wp::uint64 var_3;
    wp::uint64 var_4;
    wp::uint64 var_5;
    wp::uint64 var_6;
    wp::float32 var_7;
    wp::uint64 var_8;
    wp::uint64 var_9;
    wp::uint64 var_10;
    wp::uint64 var_11;
    wp::float32 var_12;
    wp::vec_t<3, wp::float32> var_13;
    //---------
    // forward
    // def pack_mesh_ptr(ptr: wp.uint64) -> wp.vec3:                                          <L 61>
    // chunk1 = float(ptr & wp.uint64(0x3FFFFF))  # bits 0-21                                 <L 64>
    var_0 = 4194303ull;
    var_1 = wp::bit_and(var_ptr, var_0);
    var_2 = wp::float(var_1);
    // chunk2 = float((ptr >> wp.uint64(22)) & wp.uint64(0x3FFFFF))  # bits 22-43             <L 65>
    var_3 = 22ull;
    var_4 = wp::rshift(var_ptr, var_3);
    var_5 = 4194303ull;
    var_6 = wp::bit_and(var_4, var_5);
    var_7 = wp::float(var_6);
    // chunk3 = float((ptr >> wp.uint64(44)) & wp.uint64(0xFFFFF))  # bits 44-63 (20 bits)       <L 66>
    var_8 = 44ull;
    var_9 = wp::rshift(var_ptr, var_8);
    var_10 = 1048575ull;
    var_11 = wp::bit_and(var_9, var_10);
    var_12 = wp::float(var_11);
    // return wp.vec3(chunk1, chunk2, chunk3)                                                 <L 68>
    var_13 = wp::vec_t<3, wp::float32>(var_2, var_7, var_12);
    return var_13;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/support_function.py:350
static CUDA_CALLABLE void extract_shape_data_0(
    wp::int32 var_shape_idx,
    wp::array_t<wp::transform_t<wp::float32>> var_shape_transform,
    wp::array_t<wp::int32> var_shape_types,
    wp::array_t<wp::vec_t<4, wp::float32>> var_shape_data,
    wp::array_t<wp::uint64> var_shape_source,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::quat_t<wp::float32> & ret_1,
    GenericShapeData_ceaba563 & ret_2,
    wp::vec_t<3, wp::float32> & ret_3,
    wp::float32 & ret_4)
{
    //---------
    // primal vars
    wp::transform_t<wp::float32>* var_0;
    wp::transform_t<wp::float32> var_1;
    wp::transform_t<wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    wp::quat_t<wp::float32> var_4;
    wp::vec_t<4, wp::float32>* var_5;
    wp::vec_t<4, wp::float32> var_6;
    wp::vec_t<4, wp::float32> var_7;
    const wp::int32 var_8 = 0;
    wp::float32 var_9;
    const wp::int32 var_10 = 1;
    wp::float32 var_11;
    const wp::int32 var_12 = 2;
    wp::float32 var_13;
    wp::vec_t<3, wp::float32> var_14;
    const wp::int32 var_15 = 3;
    wp::float32 var_16;
    GenericShapeData_ceaba563 var_17;
    wp::int32* var_18;
    wp::int32 var_19;
    wp::int32 var_20;
    const wp::float32 var_21 = 0.0;
    const wp::float32 var_22 = 0.0;
    const wp::float32 var_23 = 0.0;
    wp::vec_t<3, wp::float32> var_24;
    wp::int32* var_25;
    const wp::int32 var_26 = 10;
    bool var_27;
    wp::int32 var_28;
    wp::uint64* var_29;
    wp::vec_t<3, wp::float32> var_30;
    wp::uint64 var_31;
    //---------
    // forward
    // def extract_shape_data(                                                                <L 351>
    // X_ws = shape_transform[shape_idx]                                                      <L 372>
    var_0 = wp::address(var_shape_transform, var_shape_idx);
    var_2 = wp::load(var_0);
    var_1 = wp::copy(var_2);
    // position = wp.transform_get_translation(X_ws)                                          <L 374>
    var_3 = wp::transform_get_translation(var_1);
    // orientation = wp.transform_get_rotation(X_ws)                                          <L 375>
    var_4 = wp::transform_get_rotation(var_1);
    // data = shape_data[shape_idx]                                                           <L 379>
    var_5 = wp::address(var_shape_data, var_shape_idx);
    var_7 = wp::load(var_5);
    var_6 = wp::copy(var_7);
    // scale = wp.vec3(data[0], data[1], data[2])                                             <L 380>
    var_9 = wp::extract(var_6, var_8);
    var_11 = wp::extract(var_6, var_10);
    var_13 = wp::extract(var_6, var_12);
    var_14 = wp::vec_t<3, wp::float32>(var_9, var_11, var_13);
    // margin_offset = data[3]                                                                <L 381>
    var_16 = wp::extract(var_6, var_15);
    // result = GenericShapeData()                                                            <L 384>
    var_17 = GenericShapeData_ceaba563();
    // result.shape_type = shape_types[shape_idx]                                             <L 385>
    var_18 = wp::address(var_shape_types, var_shape_idx);
    var_20 = wp::load(var_18);
    var_19 = wp::copy(var_20);
    var_17.shape_type = var_19;
    // result.scale = scale                                                                   <L 386>
    var_17.scale = var_14;
    // result.auxiliary = wp.vec3(0.0, 0.0, 0.0)                                              <L 387>
    var_24 = wp::vec_t<3, wp::float32>(var_21, var_22, var_23);
    var_17.auxiliary = var_24;
    // if shape_types[shape_idx] == GeoType.CONVEX_MESH:                                      <L 390>
    var_25 = wp::address(var_shape_types, var_shape_idx);
    var_28 = wp::load(var_25);
    var_27 = (var_28 == var_26);
    if (var_27) {
        // result.auxiliary = pack_mesh_ptr(shape_source[shape_idx])                          <L 391>
        var_29 = wp::address(var_shape_source, var_shape_idx);
        var_31 = wp::load(var_29);
        var_30 = pack_mesh_ptr_0(var_31);
        var_17.auxiliary = var_30;
    }
    // return position, orientation, result, scale, margin_offset                             <L 393>
    ret_0 = var_3;
    ret_1 = var_4;
    ret_2 = var_17;
    ret_3 = var_14;
    ret_4 = var_16;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/support_function.py:71
static CUDA_CALLABLE wp::uint64 unpack_mesh_ptr_0(
    wp::vec_t<3, wp::float32> var_arr)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    wp::float32 var_1;
    wp::uint64 var_2;
    wp::uint64 var_3;
    wp::uint64 var_4;
    const wp::int32 var_5 = 1;
    wp::float32 var_6;
    wp::uint64 var_7;
    wp::uint64 var_8;
    wp::uint64 var_9;
    wp::uint64 var_10;
    wp::uint64 var_11;
    const wp::int32 var_12 = 2;
    wp::float32 var_13;
    wp::uint64 var_14;
    wp::uint64 var_15;
    wp::uint64 var_16;
    wp::uint64 var_17;
    wp::uint64 var_18;
    wp::uint64 var_19;
    wp::uint64 var_20;
    //---------
    // forward
    // def unpack_mesh_ptr(arr: wp.vec3) -> wp.uint64:                                        <L 72>
    // chunk1 = wp.uint64(arr[0]) & wp.uint64(0x3FFFFF)                                       <L 75>
    var_1 = wp::extract(var_arr, var_0);
    var_2 = wp::uint64(var_1);
    var_3 = 4194303ull;
    var_4 = wp::bit_and(var_2, var_3);
    // chunk2 = (wp.uint64(arr[1]) & wp.uint64(0x3FFFFF)) << wp.uint64(22)                    <L 76>
    var_6 = wp::extract(var_arr, var_5);
    var_7 = wp::uint64(var_6);
    var_8 = 4194303ull;
    var_9 = wp::bit_and(var_7, var_8);
    var_10 = 22ull;
    var_11 = wp::lshift(var_9, var_10);
    // chunk3 = (wp.uint64(arr[2]) & wp.uint64(0xFFFFF)) << wp.uint64(44)                     <L 77>
    var_13 = wp::extract(var_arr, var_12);
    var_14 = wp::uint64(var_13);
    var_15 = 1048575ull;
    var_16 = wp::bit_and(var_14, var_15);
    var_17 = 44ull;
    var_18 = wp::lshift(var_16, var_17);
    // return chunk1 | chunk2 | chunk3                                                        <L 79>
    var_19 = wp::bit_or(var_4, var_11);
    var_20 = wp::bit_or(var_19, var_18);
    return var_20;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/support_function.py:396
static CUDA_CALLABLE wp::vec_t<3, wp::float32> closest_point_on_triangle_0(
    wp::vec_t<3, wp::float32> var_p,
    wp::vec_t<3, wp::float32> var_tri_a,
    wp::vec_t<3, wp::float32> var_tri_b,
    wp::vec_t<3, wp::float32> var_tri_c)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::float32 var_2;
    wp::float32 var_3;
    const wp::float32 var_4 = 1e-20;
    wp::vec_t<3, wp::float32> var_5;
    wp::vec_t<3, wp::float32> var_6;
    wp::float32 var_7;
    bool var_8;
    wp::vec_t<3, wp::float32> var_9;
    wp::float32 var_10;
    bool var_11;
    bool var_12;
    bool var_13;
    bool var_14;
    wp::vec_t<3, wp::float32> var_15;
    wp::float32 var_16;
    wp::float32 var_17;
    const wp::float32 var_18 = 0.0;
    const wp::float32 var_19 = 1.0;
    wp::float32 var_20;
    wp::vec_t<3, wp::float32> var_21;
    wp::vec_t<3, wp::float32> var_22;
    bool var_23;
    wp::vec_t<3, wp::float32> var_24;
    wp::float32 var_25;
    wp::float32 var_26;
    const wp::float32 var_27 = 0.0;
    const wp::float32 var_28 = 1.0;
    wp::float32 var_29;
    wp::vec_t<3, wp::float32> var_30;
    wp::vec_t<3, wp::float32> var_31;
    wp::vec_t<3, wp::float32> var_32;
    wp::float32 var_33;
    wp::float32 var_34;
    const wp::float32 var_35 = 0.0;
    const wp::float32 var_36 = 1.0;
    wp::float32 var_37;
    wp::vec_t<3, wp::float32> var_38;
    wp::vec_t<3, wp::float32> var_39;
    wp::float32 var_40;
    wp::float32 var_41;
    wp::vec_t<3, wp::float32> var_42;
    wp::float32 var_43;
    wp::float32 var_44;
    bool var_45;
    const wp::float32 var_46 = 0.0;
    bool var_47;
    const wp::float32 var_48 = 0.0;
    bool var_49;
    wp::vec_t<3, wp::float32> var_50;
    wp::float32 var_51;
    wp::float32 var_52;
    bool var_53;
    const wp::float32 var_54 = 0.0;
    bool var_55;
    bool var_56;
    wp::vec_t<3, wp::float32> var_57;
    wp::float32 var_58;
    wp::float32 var_59;
    bool var_60;
    const wp::float32 var_61 = 0.0;
    bool var_62;
    bool var_63;
    wp::float32 var_64;
    wp::float32 var_65;
    wp::float32 var_66;
    bool var_67;
    const wp::float32 var_68 = 0.0;
    bool var_69;
    const wp::float32 var_70 = 0.0;
    bool var_71;
    const wp::float32 var_72 = 0.0;
    bool var_73;
    wp::float32 var_74;
    wp::float32 var_75;
    wp::vec_t<3, wp::float32> var_76;
    wp::vec_t<3, wp::float32> var_77;
    wp::float32 var_78;
    wp::float32 var_79;
    wp::float32 var_80;
    bool var_81;
    const wp::float32 var_82 = 0.0;
    bool var_83;
    const wp::float32 var_84 = 0.0;
    bool var_85;
    const wp::float32 var_86 = 0.0;
    bool var_87;
    wp::float32 var_88;
    wp::float32 var_89;
    wp::vec_t<3, wp::float32> var_90;
    wp::vec_t<3, wp::float32> var_91;
    wp::float32 var_92;
    wp::float32 var_93;
    wp::float32 var_94;
    bool var_95;
    const wp::float32 var_96 = 0.0;
    bool var_97;
    wp::float32 var_98;
    const wp::float32 var_99 = 0.0;
    bool var_100;
    wp::float32 var_101;
    const wp::float32 var_102 = 0.0;
    bool var_103;
    wp::float32 var_104;
    wp::float32 var_105;
    wp::float32 var_106;
    wp::float32 var_107;
    wp::float32 var_108;
    wp::vec_t<3, wp::float32> var_109;
    wp::vec_t<3, wp::float32> var_110;
    wp::vec_t<3, wp::float32> var_111;
    wp::float32 var_112;
    const wp::float32 var_113 = 1.0;
    wp::float32 var_114;
    wp::float32 var_115;
    wp::float32 var_116;
    wp::float32 var_117;
    wp::float32 var_118;
    wp::vec_t<3, wp::float32> var_119;
    wp::vec_t<3, wp::float32> var_120;
    wp::vec_t<3, wp::float32> var_121;
    wp::vec_t<3, wp::float32> var_122;
    //---------
    // forward
    // def closest_point_on_triangle(                                                         <L 397>
    // ab = tri_b - tri_a                                                                     <L 418>
    var_0 = wp::sub(var_tri_b, var_tri_a);
    // ac = tri_c - tri_a                                                                     <L 419>
    var_1 = wp::sub(var_tri_c, var_tri_a);
    // ab_sq = wp.dot(ab, ab)                                                                 <L 424>
    var_2 = wp::dot(var_0, var_0);
    // ac_sq = wp.dot(ac, ac)                                                                 <L 425>
    var_3 = wp::dot(var_1, var_1);
    // EPS2 = 1.0e-20                                                                         <L 426>
    // if wp.dot(wp.cross(ab, ac), wp.cross(ab, ac)) < EPS2:                                  <L 427>
    var_5 = wp::cross(var_0, var_1);
    var_6 = wp::cross(var_0, var_1);
    var_7 = wp::dot(var_5, var_6);
    var_8 = (var_7 < var_4);
    if (var_8) {
        // bc = tri_c - tri_b                                                                 <L 428>
        var_9 = wp::sub(var_tri_c, var_tri_b);
        // bc_sq = wp.dot(bc, bc)                                                             <L 429>
        var_10 = wp::dot(var_9, var_9);
        // if ab_sq >= ac_sq and ab_sq >= bc_sq:                                              <L 430>
        var_12 = (var_2 >= var_3);
        var_11 = var_12;
        if (var_11) {
            var_13 = (var_2 >= var_10);
            var_11 = var_11 && var_13;
        }
        if (var_11) {
            // if ab_sq < EPS2:                                                               <L 431>
            var_14 = (var_2 < var_4);
            if (var_14) {
                // return tri_a                                                               <L 432>
                return var_tri_a;
            }
            // t = wp.clamp(wp.dot(p - tri_a, ab) / ab_sq, 0.0, 1.0)                          <L 433>
            var_15 = wp::sub(var_p, var_tri_a);
            var_16 = wp::dot(var_15, var_0);
            var_17 = wp::div(var_16, var_2);
            var_20 = wp::clamp(var_17, var_18, var_19);
            // return tri_a + t * ab                                                          <L 434>
            var_21 = wp::mul(var_20, var_0);
            var_22 = wp::add(var_tri_a, var_21);
            return var_22;
        }
        if (!var_11) {
            // elif ac_sq >= bc_sq:                                                           <L 435>
            var_23 = (var_3 >= var_10);
            if (var_23) {
                // t = wp.clamp(wp.dot(p - tri_a, ac) / ac_sq, 0.0, 1.0)                      <L 436>
                var_24 = wp::sub(var_p, var_tri_a);
                var_25 = wp::dot(var_24, var_1);
                var_26 = wp::div(var_25, var_3);
                var_29 = wp::clamp(var_26, var_27, var_28);
                // return tri_a + t * ac                                                      <L 437>
                var_30 = wp::mul(var_29, var_1);
                var_31 = wp::add(var_tri_a, var_30);
                return var_31;
            }
            if (!var_23) {
                // t = wp.clamp(wp.dot(p - tri_b, bc) / bc_sq, 0.0, 1.0)                      <L 439>
                var_32 = wp::sub(var_p, var_tri_b);
                var_33 = wp::dot(var_32, var_9);
                var_34 = wp::div(var_33, var_10);
                var_37 = wp::clamp(var_34, var_35, var_36);
                // return tri_b + t * bc                                                      <L 440>
                var_38 = wp::mul(var_37, var_9);
                var_39 = wp::add(var_tri_b, var_38);
                return var_39;
            }
            var_40 = wp::where(var_23, var_29, var_37);
        }
        var_41 = wp::where(var_11, var_20, var_40);
    }
    // ap = p - tri_a                                                                         <L 442>
    var_42 = wp::sub(var_p, var_tri_a);
    // d1 = wp.dot(ab, ap)                                                                    <L 444>
    var_43 = wp::dot(var_0, var_42);
    // d2 = wp.dot(ac, ap)                                                                    <L 445>
    var_44 = wp::dot(var_1, var_42);
    // if d1 <= 0.0 and d2 <= 0.0:                                                            <L 446>
    var_47 = (var_43 <= var_46);
    var_45 = var_47;
    if (var_45) {
        var_49 = (var_44 <= var_48);
        var_45 = var_45 && var_49;
    }
    if (var_45) {
        // return tri_a                                                                       <L 447>
        return var_tri_a;
    }
    // bp = p - tri_b                                                                         <L 449>
    var_50 = wp::sub(var_p, var_tri_b);
    // d3 = wp.dot(ab, bp)                                                                    <L 450>
    var_51 = wp::dot(var_0, var_50);
    // d4 = wp.dot(ac, bp)                                                                    <L 451>
    var_52 = wp::dot(var_1, var_50);
    // if d3 >= 0.0 and d4 <= d3:                                                             <L 452>
    var_55 = (var_51 >= var_54);
    var_53 = var_55;
    if (var_53) {
        var_56 = (var_52 <= var_51);
        var_53 = var_53 && var_56;
    }
    if (var_53) {
        // return tri_b                                                                       <L 453>
        return var_tri_b;
    }
    // cp = p - tri_c                                                                         <L 455>
    var_57 = wp::sub(var_p, var_tri_c);
    // d5 = wp.dot(ab, cp)                                                                    <L 456>
    var_58 = wp::dot(var_0, var_57);
    // d6 = wp.dot(ac, cp)                                                                    <L 457>
    var_59 = wp::dot(var_1, var_57);
    // if d6 >= 0.0 and d5 <= d6:                                                             <L 458>
    var_62 = (var_59 >= var_61);
    var_60 = var_62;
    if (var_60) {
        var_63 = (var_58 <= var_59);
        var_60 = var_60 && var_63;
    }
    if (var_60) {
        // return tri_c                                                                       <L 459>
        return var_tri_c;
    }
    // vc = d1 * d4 - d3 * d2                                                                 <L 461>
    var_64 = wp::mul(var_43, var_52);
    var_65 = wp::mul(var_51, var_44);
    var_66 = wp::sub(var_64, var_65);
    // if vc <= 0.0 and d1 >= 0.0 and d3 <= 0.0:                                              <L 462>
    var_69 = (var_66 <= var_68);
    var_67 = var_69;
    if (var_67) {
        var_71 = (var_43 >= var_70);
        var_67 = var_67 && var_71;
    }
    if (var_67) {
        var_73 = (var_51 <= var_72);
        var_67 = var_67 && var_73;
    }
    if (var_67) {
        // v = d1 / (d1 - d3)                                                                 <L 463>
        var_74 = wp::sub(var_43, var_51);
        var_75 = wp::div(var_43, var_74);
        // return tri_a + v * ab                                                              <L 464>
        var_76 = wp::mul(var_75, var_0);
        var_77 = wp::add(var_tri_a, var_76);
        return var_77;
    }
    // vb = d5 * d2 - d1 * d6                                                                 <L 466>
    var_78 = wp::mul(var_58, var_44);
    var_79 = wp::mul(var_43, var_59);
    var_80 = wp::sub(var_78, var_79);
    // if vb <= 0.0 and d2 >= 0.0 and d6 <= 0.0:                                              <L 467>
    var_83 = (var_80 <= var_82);
    var_81 = var_83;
    if (var_81) {
        var_85 = (var_44 >= var_84);
        var_81 = var_81 && var_85;
    }
    if (var_81) {
        var_87 = (var_59 <= var_86);
        var_81 = var_81 && var_87;
    }
    if (var_81) {
        // w = d2 / (d2 - d6)                                                                 <L 468>
        var_88 = wp::sub(var_44, var_59);
        var_89 = wp::div(var_44, var_88);
        // return tri_a + w * ac                                                              <L 469>
        var_90 = wp::mul(var_89, var_1);
        var_91 = wp::add(var_tri_a, var_90);
        return var_91;
    }
    // va = d3 * d6 - d5 * d4                                                                 <L 471>
    var_92 = wp::mul(var_51, var_59);
    var_93 = wp::mul(var_58, var_52);
    var_94 = wp::sub(var_92, var_93);
    // if va <= 0.0 and (d4 - d3) >= 0.0 and (d5 - d6) >= 0.0:                                <L 472>
    var_97 = (var_94 <= var_96);
    var_95 = var_97;
    if (var_95) {
        var_98 = wp::sub(var_52, var_51);
        var_100 = (var_98 >= var_99);
        var_95 = var_95 && var_100;
    }
    if (var_95) {
        var_101 = wp::sub(var_58, var_59);
        var_103 = (var_101 >= var_102);
        var_95 = var_95 && var_103;
    }
    if (var_95) {
        // w = (d4 - d3) / ((d4 - d3) + (d5 - d6))                                            <L 473>
        var_104 = wp::sub(var_52, var_51);
        var_105 = wp::sub(var_52, var_51);
        var_106 = wp::sub(var_58, var_59);
        var_107 = wp::add(var_105, var_106);
        var_108 = wp::div(var_104, var_107);
        // return tri_b + w * (tri_c - tri_b)                                                 <L 474>
        var_109 = wp::sub(var_tri_c, var_tri_b);
        var_110 = wp::mul(var_108, var_109);
        var_111 = wp::add(var_tri_b, var_110);
        return var_111;
    }
    var_112 = wp::where(var_95, var_108, var_89);
    // denom = 1.0 / (va + vb + vc)                                                           <L 476>
    var_114 = wp::add(var_94, var_80);
    var_115 = wp::add(var_114, var_66);
    var_116 = wp::div(var_113, var_115);
    // v = vb * denom                                                                         <L 477>
    var_117 = wp::mul(var_80, var_116);
    // w = vc * denom                                                                         <L 478>
    var_118 = wp::mul(var_66, var_116);
    // return tri_a + v * ab + w * ac                                                         <L 479>
    var_119 = wp::mul(var_117, var_0);
    var_120 = wp::add(var_tri_a, var_119);
    var_121 = wp::mul(var_118, var_1);
    var_122 = wp::add(var_120, var_121);
    return var_122;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/mpr.py:0
static CUDA_CALLABLE Vert_99873389 create_support_map_function__locals__geometric_center_24(
    GenericShapeData_ceaba563 var_geom_a,
    GenericShapeData_ceaba563 var_geom_b,
    wp::quat_t<wp::float32> var_orientation_b,
    wp::vec_t<3, wp::float32> var_position_b,
    SupportMapDataProvider_e77f8b9f var_data_provider)
{
    //---------
    // primal vars
    Vert_99873389 var_0;
    const wp::float32 var_1 = 0.0;
    const wp::float32 var_2 = 0.0;
    const wp::float32 var_3 = 0.0;
    wp::vec_t<3, wp::float32> var_4;
    const wp::float32 var_5 = 0.0;
    const wp::float32 var_6 = 0.0;
    const wp::float32 var_7 = 0.0;
    wp::vec_t<3, wp::float32> var_8;
    wp::int32* var_9;
    const wp::int32 var_10 = 10;
    const wp::int32 var_11 = 10;
    wp::int32 var_12;
    bool var_13;
    wp::int32 var_14;
    wp::vec_t<3, wp::float32>* var_15;
    wp::uint64 var_16;
    wp::vec_t<3, wp::float32> var_17;
    wp::Mesh var_18;
    wp::vec_t<3, wp::float32>* var_19;
    wp::vec_t<3, wp::float32> var_20;
    wp::vec_t<3, wp::float32> var_21;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_22;
    wp::shape_t* var_23;
    const wp::int32 var_24 = 0;
    wp::int32 var_25;
    wp::shape_t var_26;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_27;
    const wp::int32 var_28 = 0;
    wp::vec_t<3, wp::float32>* var_29;
    wp::array_t<wp::vec_t<3, wp::float32>> var_30;
    wp::vec_t<3, wp::float32> var_31;
    wp::vec_t<3, wp::float32> var_32;
    wp::vec_t<3, wp::float32> var_33;
    wp::vec_t<3, wp::float32> var_34;
    const wp::int32 var_35 = 1;
    wp::range_t var_36;
    wp::int32 var_37;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_38;
    wp::vec_t<3, wp::float32>* var_39;
    wp::array_t<wp::vec_t<3, wp::float32>> var_40;
    wp::vec_t<3, wp::float32> var_41;
    wp::vec_t<3, wp::float32> var_42;
    wp::vec_t<3, wp::float32> var_43;
    wp::vec_t<3, wp::float32> var_44;
    const wp::float32 var_45 = 0.5;
    wp::vec_t<3, wp::float32> var_46;
    wp::vec_t<3, wp::float32> var_47;
    wp::vec_t<3, wp::float32> var_48;
    wp::int32* var_49;
    const wp::int32 var_50 = 10;
    const wp::int32 var_51 = 10;
    wp::int32 var_52;
    bool var_53;
    wp::int32 var_54;
    wp::vec_t<3, wp::float32>* var_55;
    wp::uint64 var_56;
    wp::vec_t<3, wp::float32> var_57;
    wp::Mesh var_58;
    wp::vec_t<3, wp::float32>* var_59;
    wp::vec_t<3, wp::float32> var_60;
    wp::vec_t<3, wp::float32> var_61;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_62;
    wp::shape_t* var_63;
    const wp::int32 var_64 = 0;
    wp::int32 var_65;
    wp::shape_t var_66;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_67;
    const wp::int32 var_68 = 0;
    wp::vec_t<3, wp::float32>* var_69;
    wp::array_t<wp::vec_t<3, wp::float32>> var_70;
    wp::vec_t<3, wp::float32> var_71;
    wp::vec_t<3, wp::float32> var_72;
    wp::vec_t<3, wp::float32> var_73;
    wp::vec_t<3, wp::float32> var_74;
    const wp::int32 var_75 = 1;
    wp::range_t var_76;
    wp::int32 var_77;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_78;
    wp::vec_t<3, wp::float32>* var_79;
    wp::array_t<wp::vec_t<3, wp::float32>> var_80;
    wp::vec_t<3, wp::float32> var_81;
    wp::vec_t<3, wp::float32> var_82;
    wp::vec_t<3, wp::float32> var_83;
    wp::vec_t<3, wp::float32> var_84;
    const wp::float32 var_85 = 0.5;
    wp::vec_t<3, wp::float32> var_86;
    wp::vec_t<3, wp::float32> var_87;
    wp::vec_t<3, wp::float32> var_88;
    wp::int32 var_89;
    wp::vec_t<3, wp::float32> var_90;
    wp::vec_t<3, wp::float32> var_91;
    wp::vec_t<3, wp::float32> var_92;
    bool var_93;
    wp::int32* var_94;
    const wp::int32 var_95 = 1000;
    const wp::int32 var_96 = 1000;
    wp::int32 var_97;
    bool var_98;
    wp::int32 var_99;
    wp::int32* var_100;
    const wp::int32 var_101 = 1001;
    const wp::int32 var_102 = 1001;
    wp::int32 var_103;
    bool var_104;
    wp::int32 var_105;
    const wp::float32 var_106 = 0.0;
    const wp::float32 var_107 = 0.0;
    const wp::float32 var_108 = 0.0;
    wp::vec_t<3, wp::float32> var_109;
    wp::vec_t<3, wp::float32>* var_110;
    wp::vec_t<3, wp::float32> var_111;
    wp::vec_t<3, wp::float32> var_112;
    wp::vec_t<3, wp::float32>* var_113;
    wp::vec_t<3, wp::float32> var_114;
    wp::vec_t<3, wp::float32> var_115;
    wp::vec_t<3, wp::float32> var_116;
    wp::vec_t<3, wp::float32> var_117;
    wp::vec_t<3, wp::float32> var_118;
    wp::float32 var_119;
    wp::vec_t<3, wp::float32> var_120;
    const wp::float32 var_121 = 1e-20;
    bool var_122;
    wp::float32 var_123;
    wp::vec_t<3, wp::float32> var_124;
    wp::vec_t<3, wp::float32> var_125;
    wp::float32 var_126;
    wp::vec_t<3, wp::float32> var_127;
    wp::vec_t<3, wp::float32> var_128;
    bool var_129;
    wp::vec_t<3, wp::float32> var_130;
    wp::vec_t<3, wp::float32> var_131;
    wp::vec_t<3, wp::float32> var_132;
    wp::float32 var_133;
    const wp::float32 var_134 = 0.0;
    bool var_135;
    wp::vec_t<3, wp::float32> var_136;
    wp::vec_t<3, wp::float32> var_137;
    wp::vec_t<3, wp::float32> var_138;
    wp::float32 var_139;
    const wp::float32 var_140 = 0.0;
    bool var_141;
    wp::vec_t<3, wp::float32> var_142;
    wp::vec_t<3, wp::float32> var_143;
    wp::vec_t<3, wp::float32> var_144;
    wp::float32 var_145;
    const wp::float32 var_146 = 0.0;
    bool var_147;
    wp::vec_t<3, wp::float32> var_148;
    wp::float32 var_149;
    wp::vec_t<3, wp::float32> var_150;
    wp::vec_t<3, wp::float32> var_151;
    wp::vec_t<3, wp::float32> var_152;
    wp::vec_t<3, wp::float32> var_153;
    wp::vec_t<3, wp::float32> var_154;
    wp::vec_t<3, wp::float32> var_155;
    const wp::float32 var_156 = 3.0;
    wp::vec_t<3, wp::float32> var_157;
    wp::vec_t<3, wp::float32> var_158;
    wp::float32 var_159;
    wp::vec_t<3, wp::float32> var_160;
    wp::vec_t<3, wp::float32> var_161;
    wp::float32 var_162;
    const wp::float32 var_163 = 1e-12;
    bool var_164;
    const wp::float32 var_165 = 0.01;
    wp::float32 var_166;
    wp::float32 var_167;
    wp::float32 var_168;
    wp::float32 var_169;
    wp::vec_t<3, wp::float32> var_170;
    wp::vec_t<3, wp::float32> var_171;
    wp::vec_t<3, wp::float32> var_172;
    wp::vec_t<3, wp::float32> var_173;
    wp::vec_t<3, wp::float32> var_174;
    wp::vec_t<3, wp::float32> var_175;
    wp::vec_t<3, wp::float32> var_176;
    //---------
    // forward
    // def geometric_center(                                                                  <L 1>
    // center = Vert()                                                                        <L 46>
    var_0 = Vert_99873389();
    // center_a = wp.vec3(0.0, 0.0, 0.0)                                                      <L 48>
    var_4 = wp::vec_t<3, wp::float32>(var_1, var_2, var_3);
    // center_b_local = wp.vec3(0.0, 0.0, 0.0)                                                <L 49>
    var_8 = wp::vec_t<3, wp::float32>(var_5, var_6, var_7);
    // if geom_a.shape_type == int(GeoType.CONVEX_MESH):                                      <L 51>
    var_9 = &((var_geom_a).shape_type);
    var_12 = wp::int(var_11);
    var_14 = wp::load(var_9);
    var_13 = (var_14 == var_12);
    if (var_13) {
        // mesh_ptr_a = unpack_mesh_ptr(geom_a.auxiliary)                                     <L 52>
        var_15 = &((var_geom_a).auxiliary);
        var_17 = wp::load(var_15);
        var_16 = unpack_mesh_ptr_0(var_17);
        // mesh_a = wp.mesh_get(mesh_ptr_a)                                                   <L 53>
        var_18 = wp::mesh_get(var_16);
        // scale_a = geom_a.scale                                                             <L 54>
        var_19 = &((var_geom_a).scale);
        var_21 = wp::load(var_19);
        var_20 = wp::copy(var_21);
        // num_verts_a = mesh_a.points.shape[0]                                               <L 55>
        var_22 = &((var_18).points);
        var_23 = &(var_22->shape);
        var_26 = wp::load(var_23);
        var_25 = wp::extract(var_26, var_24);
        // v0_a = wp.cw_mul(mesh_a.points[0], scale_a)                                        <L 56>
        var_27 = &((var_18).points);
        var_30 = wp::load(var_27);
        var_29 = wp::address(var_30, var_28);
        var_32 = wp::load(var_29);
        var_31 = wp::cw_mul(var_32, var_20);
        // min_a = v0_a                                                                       <L 57>
        var_33 = wp::copy(var_31);
        // max_a = v0_a                                                                       <L 58>
        var_34 = wp::copy(var_31);
        // for i in range(1, num_verts_a):                                                    <L 59>
        var_36 = wp::range(var_35, var_25);
        start_for_0:;
            if (iter_cmp(var_36) == 0) goto end_for_0;
            var_37 = wp::iter_next(var_36);
            // v_a = wp.cw_mul(mesh_a.points[i], scale_a)                                     <L 60>
            var_38 = &((var_18).points);
            var_40 = wp::load(var_38);
            var_39 = wp::address(var_40, var_37);
            var_42 = wp::load(var_39);
            var_41 = wp::cw_mul(var_42, var_20);
            // min_a = wp.min(min_a, v_a)                                                     <L 61>
            var_43 = wp::min(var_33, var_41);
            // max_a = wp.max(max_a, v_a)                                                     <L 62>
            var_44 = wp::max(var_34, var_41);
            wp::assign(var_33, var_43);
            wp::assign(var_34, var_44);
            goto start_for_0;
        end_for_0:;
        // center_a = 0.5 * (min_a + max_a)                                                   <L 63>
        var_46 = wp::add(var_33, var_34);
        var_47 = wp::mul(var_45, var_46);
    }
    var_48 = wp::where(var_13, var_47, var_4);
    // if geom_b.shape_type == int(GeoType.CONVEX_MESH):                                      <L 65>
    var_49 = &((var_geom_b).shape_type);
    var_52 = wp::int(var_51);
    var_54 = wp::load(var_49);
    var_53 = (var_54 == var_52);
    if (var_53) {
        // mesh_ptr_b = unpack_mesh_ptr(geom_b.auxiliary)                                     <L 66>
        var_55 = &((var_geom_b).auxiliary);
        var_57 = wp::load(var_55);
        var_56 = unpack_mesh_ptr_0(var_57);
        // mesh_b = wp.mesh_get(mesh_ptr_b)                                                   <L 67>
        var_58 = wp::mesh_get(var_56);
        // scale_b = geom_b.scale                                                             <L 68>
        var_59 = &((var_geom_b).scale);
        var_61 = wp::load(var_59);
        var_60 = wp::copy(var_61);
        // num_verts_b = mesh_b.points.shape[0]                                               <L 69>
        var_62 = &((var_58).points);
        var_63 = &(var_62->shape);
        var_66 = wp::load(var_63);
        var_65 = wp::extract(var_66, var_64);
        // v0_b = wp.cw_mul(mesh_b.points[0], scale_b)                                        <L 70>
        var_67 = &((var_58).points);
        var_70 = wp::load(var_67);
        var_69 = wp::address(var_70, var_68);
        var_72 = wp::load(var_69);
        var_71 = wp::cw_mul(var_72, var_60);
        // min_b = v0_b                                                                       <L 71>
        var_73 = wp::copy(var_71);
        // max_b = v0_b                                                                       <L 72>
        var_74 = wp::copy(var_71);
        // for i in range(1, num_verts_b):                                                    <L 73>
        var_76 = wp::range(var_75, var_65);
        start_for_2:;
            if (iter_cmp(var_76) == 0) goto end_for_2;
            var_77 = wp::iter_next(var_76);
            // v_b = wp.cw_mul(mesh_b.points[i], scale_b)                                     <L 74>
            var_78 = &((var_58).points);
            var_80 = wp::load(var_78);
            var_79 = wp::address(var_80, var_77);
            var_82 = wp::load(var_79);
            var_81 = wp::cw_mul(var_82, var_60);
            // min_b = wp.min(min_b, v_b)                                                     <L 75>
            var_83 = wp::min(var_73, var_81);
            // max_b = wp.max(max_b, v_b)                                                     <L 76>
            var_84 = wp::max(var_74, var_81);
            wp::assign(var_73, var_83);
            wp::assign(var_74, var_84);
            goto start_for_2;
        end_for_2:;
        // center_b_local = 0.5 * (min_b + max_b)                                             <L 77>
        var_86 = wp::add(var_73, var_74);
        var_87 = wp::mul(var_85, var_86);
    }
    var_88 = wp::where(var_53, var_87, var_8);
    var_89 = wp::where(var_53, var_77, var_37);
    // center_b_world = position_b + wp.quat_rotate(orientation_b, center_b_local)            <L 79>
    var_90 = wp::quat_rotate(var_orientation_b, var_88);
    var_91 = wp::add(var_position_b, var_90);
    // center_b_to_a = center_a - center_b_world                                              <L 80>
    var_92 = wp::sub(var_48, var_91);
    // if geom_a.shape_type == int(GeoTypeEx.TRIANGLE) or geom_a.shape_type == int(GeoTypeEx.TRIANGLE_PRISM):       <L 82>
    var_94 = &((var_geom_a).shape_type);
    var_97 = wp::int(var_96);
    var_99 = wp::load(var_94);
    var_98 = (var_99 == var_97);
    var_93 = var_98;
    if (!var_93) {
        var_100 = &((var_geom_a).shape_type);
        var_103 = wp::int(var_102);
        var_105 = wp::load(var_100);
        var_104 = (var_105 == var_103);
        var_93 = var_93 || var_104;
    }
    if (var_93) {
        // tri_a = wp.vec3(0.0, 0.0, 0.0)                                                     <L 87>
        var_109 = wp::vec_t<3, wp::float32>(var_106, var_107, var_108);
        // tri_b = geom_a.scale                                                               <L 88>
        var_110 = &((var_geom_a).scale);
        var_112 = wp::load(var_110);
        var_111 = wp::copy(var_112);
        // tri_c = geom_a.auxiliary                                                           <L 89>
        var_113 = &((var_geom_a).auxiliary);
        var_115 = wp::load(var_113);
        var_114 = wp::copy(var_115);
        // face_normal = wp.cross(tri_b - tri_a, tri_c - tri_a)                               <L 90>
        var_116 = wp::sub(var_111, var_109);
        var_117 = wp::sub(var_114, var_109);
        var_118 = wp::cross(var_116, var_117);
        // face_normal_length_sq = wp.length_sq(face_normal)                                  <L 91>
        var_119 = wp::length_sq(var_118);
        // proj = closest_point_on_triangle(center_b_world, tri_a, tri_b, tri_c)              <L 92>
        var_120 = closest_point_on_triangle_0(var_91, var_109, var_111, var_114);
        // if face_normal_length_sq >= 1.0e-20:                                               <L 94>
        var_122 = (var_119 >= var_121);
        if (var_122) {
            // face_normal_length = wp.sqrt(face_normal_length_sq)                            <L 95>
            var_123 = wp::sqrt(var_119);
            // face_normal_unit = face_normal / face_normal_length                            <L 96>
            var_124 = wp::div(var_118, var_123);
            // signed_plane_distance = wp.dot(center_b_world - tri_a, face_normal_unit)       <L 97>
            var_125 = wp::sub(var_91, var_109);
            var_126 = wp::dot(var_125, var_124);
            // plane_proj = center_b_world - signed_plane_distance * face_normal_unit         <L 98>
            var_127 = wp::mul(var_126, var_124);
            var_128 = wp::sub(var_91, var_127);
            // inside_face = (                                                                <L 103>
            // wp.dot(wp.cross(tri_b - tri_a, plane_proj - tri_a), face_normal) >= 0.0        <L 104>
            var_130 = wp::sub(var_111, var_109);
            var_131 = wp::sub(var_128, var_109);
            var_132 = wp::cross(var_130, var_131);
            var_133 = wp::dot(var_132, var_118);
            var_135 = (var_133 >= var_134);
            var_129 = var_135;
            if (var_129) {
                // and wp.dot(wp.cross(tri_c - tri_b, plane_proj - tri_b), face_normal) >= 0.0       <L 105>
                var_136 = wp::sub(var_114, var_111);
                var_137 = wp::sub(var_128, var_111);
                var_138 = wp::cross(var_136, var_137);
                var_139 = wp::dot(var_138, var_118);
                var_141 = (var_139 >= var_140);
                var_129 = var_129 && var_141;
            }
            if (var_129) {
                // and wp.dot(wp.cross(tri_a - tri_c, plane_proj - tri_c), face_normal) >= 0.0       <L 106>
                var_142 = wp::sub(var_109, var_114);
                var_143 = wp::sub(var_128, var_114);
                var_144 = wp::cross(var_142, var_143);
                var_145 = wp::dot(var_144, var_118);
                var_147 = (var_145 >= var_146);
                var_129 = var_129 && var_147;
            }
            // if inside_face:                                                                <L 108>
            if (var_129) {
                // proj = plane_proj                                                          <L 109>
                var_148 = wp::copy(var_128);
                // center_b_to_a = -signed_plane_distance * face_normal_unit                  <L 110>
                var_149 = wp::neg(var_126);
                var_150 = wp::mul(var_149, var_124);
            }
            if (!var_129) {
                // center_b_to_a = proj - center_b_world                                      <L 112>
                var_151 = wp::sub(var_120, var_91);
            }
            var_152 = wp::where(var_129, var_150, var_151);
            var_153 = wp::where(var_129, var_148, var_120);
            // centroid = (tri_a + tri_b + tri_c) / 3.0                                       <L 114>
            var_154 = wp::add(var_109, var_111);
            var_155 = wp::add(var_154, var_114);
            var_157 = wp::div(var_155, var_156);
            // to_centroid = centroid - proj                                                  <L 115>
            var_158 = wp::sub(var_157, var_153);
            // to_centroid -= wp.dot(to_centroid, face_normal_unit) * face_normal_unit        <L 116>
            var_159 = wp::dot(var_158, var_124);
            var_160 = wp::mul(var_159, var_124);
            var_161 = wp::sub(var_158, var_160);
            // distance_to_centroid = wp.length(to_centroid)                                  <L 117>
            var_162 = wp::length(var_161);
            // if distance_to_centroid > 1.0e-12:                                             <L 118>
            var_164 = (var_162 > var_163);
            if (var_164) {
                // nudge_distance = 0.01 * wp.min(distance_to_centroid, wp.abs(signed_plane_distance))       <L 119>
                var_166 = wp::abs(var_126);
                var_167 = wp::min(var_162, var_166);
                var_168 = wp::mul(var_165, var_167);
                // center_b_to_a += to_centroid * (nudge_distance / distance_to_centroid)       <L 120>
                var_169 = wp::div(var_168, var_162);
                var_170 = wp::mul(var_161, var_169);
                var_171 = wp::add(var_152, var_170);
            }
            var_172 = wp::where(var_164, var_171, var_152);
        }
        if (!var_122) {
            // center_b_to_a = proj - center_b_world                                          <L 123>
            var_173 = wp::sub(var_120, var_91);
        }
        var_174 = wp::where(var_122, var_172, var_173);
        var_175 = wp::where(var_122, var_153, var_120);
    }
    var_176 = wp::where(var_93, var_174, var_92);
    // center.B = center_b_world                                                              <L 125>
    var_0.B = var_91;
    // center.BtoA = center_b_to_a                                                            <L 126>
    var_0.BtoA = var_176;
    // return center                                                                          <L 128>
    return var_0;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/support_function.py:106
static CUDA_CALLABLE wp::vec_t<3, wp::float32> support_map_0(
    GenericShapeData_ceaba563 var_geom,
    wp::vec_t<3, wp::float32> var_direction,
    SupportMapDataProvider_e77f8b9f var_data_provider)
{
    //---------
    // primal vars
    const wp::float32 var_0 = 1e-12;
    const wp::float32 var_1 = 0.0;
    const wp::float32 var_2 = 0.0;
    const wp::float32 var_3 = 0.0;
    wp::vec_t<3, wp::float32> var_4;
    wp::int32* var_5;
    const wp::int32 var_6 = 10;
    bool var_7;
    wp::int32 var_8;
    wp::vec_t<3, wp::float32>* var_9;
    wp::uint64 var_10;
    wp::vec_t<3, wp::float32> var_11;
    wp::Mesh var_12;
    wp::vec_t<3, wp::float32>* var_13;
    wp::vec_t<3, wp::float32> var_14;
    wp::vec_t<3, wp::float32> var_15;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_16;
    wp::shape_t* var_17;
    const wp::int32 var_18 = 0;
    wp::int32 var_19;
    wp::shape_t var_20;
    wp::vec_t<3, wp::float32> var_21;
    const wp::float32 var_22 = -10000000000.0;
    wp::float32 var_23;
    const wp::int32 var_24 = 0;
    wp::int32 var_25;
    wp::range_t var_26;
    wp::int32 var_27;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_28;
    wp::vec_t<3, wp::float32>* var_29;
    wp::array_t<wp::vec_t<3, wp::float32>> var_30;
    wp::float32 var_31;
    wp::vec_t<3, wp::float32> var_32;
    bool var_33;
    wp::float32 var_34;
    wp::int32 var_35;
    wp::float32 var_36;
    wp::int32 var_37;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_38;
    wp::vec_t<3, wp::float32>* var_39;
    wp::array_t<wp::vec_t<3, wp::float32>> var_40;
    wp::vec_t<3, wp::float32> var_41;
    wp::vec_t<3, wp::float32> var_42;
    bool var_43;
    wp::int32* var_44;
    const wp::int32 var_45 = 1000;
    bool var_46;
    wp::int32 var_47;
    wp::int32* var_48;
    const wp::int32 var_49 = 1001;
    bool var_50;
    wp::int32 var_51;
    const wp::float32 var_52 = 0.0;
    const wp::float32 var_53 = 0.0;
    const wp::float32 var_54 = 0.0;
    wp::vec_t<3, wp::float32> var_55;
    wp::vec_t<3, wp::float32>* var_56;
    wp::vec_t<3, wp::float32> var_57;
    wp::vec_t<3, wp::float32> var_58;
    wp::vec_t<3, wp::float32>* var_59;
    wp::vec_t<3, wp::float32> var_60;
    wp::vec_t<3, wp::float32> var_61;
    wp::float32 var_62;
    wp::float32 var_63;
    wp::float32 var_64;
    bool var_65;
    bool var_66;
    bool var_67;
    wp::vec_t<3, wp::float32> var_68;
    bool var_69;
    wp::vec_t<3, wp::float32> var_70;
    wp::vec_t<3, wp::float32> var_71;
    wp::vec_t<3, wp::float32> var_72;
    wp::vec_t<3, wp::float32> var_73;
    wp::int32* var_74;
    const wp::int32 var_75 = 1001;
    bool var_76;
    wp::int32 var_77;
    const wp::int32 var_78 = 2;
    wp::float32 var_79;
    const wp::float32 var_80 = 0.0;
    bool var_81;
    const wp::float32 var_82 = 0.0;
    const wp::float32 var_83 = 0.0;
    const wp::float32 var_84 = -1.0;
    wp::vec_t<3, wp::float32> var_85;
    wp::vec_t<3, wp::float32> var_86;
    wp::vec_t<3, wp::float32> var_87;
    wp::vec_t<3, wp::float32> var_88;
    wp::int32* var_89;
    const wp::int32 var_90 = 7;
    bool var_91;
    wp::int32 var_92;
    const wp::float32 var_93 = 1e-10;
    wp::float32 var_94;
    wp::float32 var_95;
    const wp::int32 var_96 = 0;
    wp::float32 var_97;
    wp::float32 var_98;
    bool var_99;
    const wp::float32 var_100 = 1.0;
    const wp::float32 var_101 = -1.0;
    wp::float32 var_102;
    const wp::int32 var_103 = 1;
    wp::float32 var_104;
    wp::float32 var_105;
    bool var_106;
    const wp::float32 var_107 = 1.0;
    const wp::float32 var_108 = -1.0;
    wp::float32 var_109;
    const wp::int32 var_110 = 2;
    wp::float32 var_111;
    wp::float32 var_112;
    bool var_113;
    const wp::float32 var_114 = 1.0;
    const wp::float32 var_115 = -1.0;
    wp::float32 var_116;
    wp::vec_t<3, wp::float32>* var_117;
    const wp::int32 var_118 = 0;
    wp::float32 var_119;
    wp::vec_t<3, wp::float32> var_120;
    wp::float32 var_121;
    wp::vec_t<3, wp::float32>* var_122;
    const wp::int32 var_123 = 1;
    wp::float32 var_124;
    wp::vec_t<3, wp::float32> var_125;
    wp::float32 var_126;
    wp::vec_t<3, wp::float32>* var_127;
    const wp::int32 var_128 = 2;
    wp::float32 var_129;
    wp::vec_t<3, wp::float32> var_130;
    wp::float32 var_131;
    wp::vec_t<3, wp::float32> var_132;
    wp::int32* var_133;
    const wp::int32 var_134 = 3;
    bool var_135;
    wp::int32 var_136;
    wp::vec_t<3, wp::float32>* var_137;
    const wp::int32 var_138 = 0;
    wp::float32 var_139;
    wp::vec_t<3, wp::float32> var_140;
    wp::float32 var_141;
    bool var_142;
    wp::vec_t<3, wp::float32> var_143;
    const wp::float32 var_144 = 1.0;
    const wp::float32 var_145 = 0.0;
    const wp::float32 var_146 = 0.0;
    wp::vec_t<3, wp::float32> var_147;
    wp::vec_t<3, wp::float32> var_148;
    wp::vec_t<3, wp::float32> var_149;
    wp::int32* var_150;
    const wp::int32 var_151 = 4;
    bool var_152;
    wp::int32 var_153;
    wp::vec_t<3, wp::float32>* var_154;
    const wp::int32 var_155 = 0;
    wp::float32 var_156;
    wp::vec_t<3, wp::float32> var_157;
    wp::vec_t<3, wp::float32>* var_158;
    const wp::int32 var_159 = 1;
    wp::float32 var_160;
    wp::vec_t<3, wp::float32> var_161;
    wp::float32 var_162;
    bool var_163;
    wp::vec_t<3, wp::float32> var_164;
    const wp::float32 var_165 = 1.0;
    const wp::float32 var_166 = 0.0;
    const wp::float32 var_167 = 0.0;
    wp::vec_t<3, wp::float32> var_168;
    wp::vec_t<3, wp::float32> var_169;
    wp::vec_t<3, wp::float32> var_170;
    const wp::int32 var_171 = 2;
    wp::float32 var_172;
    const wp::float32 var_173 = 0.0;
    bool var_174;
    const wp::float32 var_175 = 0.0;
    const wp::float32 var_176 = 0.0;
    wp::vec_t<3, wp::float32> var_177;
    wp::vec_t<3, wp::float32> var_178;
    const wp::float32 var_179 = 0.0;
    const wp::float32 var_180 = 0.0;
    wp::float32 var_181;
    wp::vec_t<3, wp::float32> var_182;
    wp::vec_t<3, wp::float32> var_183;
    wp::vec_t<3, wp::float32> var_184;
    wp::int32* var_185;
    const wp::int32 var_186 = 5;
    bool var_187;
    wp::int32 var_188;
    wp::vec_t<3, wp::float32>* var_189;
    const wp::int32 var_190 = 0;
    wp::float32 var_191;
    wp::vec_t<3, wp::float32> var_192;
    wp::vec_t<3, wp::float32>* var_193;
    const wp::int32 var_194 = 1;
    wp::float32 var_195;
    wp::vec_t<3, wp::float32> var_196;
    wp::vec_t<3, wp::float32>* var_197;
    const wp::int32 var_198 = 2;
    wp::float32 var_199;
    wp::vec_t<3, wp::float32> var_200;
    wp::float32 var_201;
    bool var_202;
    const wp::int32 var_203 = 0;
    wp::float32 var_204;
    wp::float32 var_205;
    const wp::int32 var_206 = 1;
    wp::float32 var_207;
    wp::float32 var_208;
    const wp::int32 var_209 = 2;
    wp::float32 var_210;
    wp::float32 var_211;
    wp::float32 var_212;
    wp::float32 var_213;
    wp::float32 var_214;
    wp::float32 var_215;
    wp::float32 var_216;
    bool var_217;
    wp::float32 var_218;
    wp::float32 var_219;
    const wp::int32 var_220 = 0;
    wp::float32 var_221;
    wp::float32 var_222;
    wp::float32 var_223;
    wp::float32 var_224;
    const wp::int32 var_225 = 1;
    wp::float32 var_226;
    wp::float32 var_227;
    wp::float32 var_228;
    wp::float32 var_229;
    const wp::int32 var_230 = 2;
    wp::float32 var_231;
    wp::float32 var_232;
    wp::float32 var_233;
    wp::vec_t<3, wp::float32> var_234;
    const wp::float32 var_235 = 0.0;
    const wp::float32 var_236 = 0.0;
    wp::vec_t<3, wp::float32> var_237;
    wp::vec_t<3, wp::float32> var_238;
    const wp::float32 var_239 = 0.0;
    const wp::float32 var_240 = 0.0;
    wp::vec_t<3, wp::float32> var_241;
    wp::vec_t<3, wp::float32> var_242;
    wp::int32* var_243;
    const wp::int32 var_244 = 6;
    bool var_245;
    wp::int32 var_246;
    wp::vec_t<3, wp::float32>* var_247;
    const wp::int32 var_248 = 0;
    wp::float32 var_249;
    wp::vec_t<3, wp::float32> var_250;
    wp::vec_t<3, wp::float32>* var_251;
    const wp::int32 var_252 = 1;
    wp::float32 var_253;
    wp::vec_t<3, wp::float32> var_254;
    const wp::int32 var_255 = 0;
    wp::float32 var_256;
    const wp::int32 var_257 = 1;
    wp::float32 var_258;
    const wp::float32 var_259 = 0.0;
    wp::vec_t<3, wp::float32> var_260;
    wp::float32 var_261;
    bool var_262;
    wp::vec_t<3, wp::float32> var_263;
    const wp::int32 var_264 = 0;
    wp::float32 var_265;
    wp::float32 var_266;
    const wp::int32 var_267 = 1;
    wp::float32 var_268;
    wp::float32 var_269;
    const wp::float32 var_270 = 0.0;
    wp::vec_t<3, wp::float32> var_271;
    const wp::float32 var_272 = 0.0;
    const wp::float32 var_273 = 0.0;
    wp::vec_t<3, wp::float32> var_274;
    wp::vec_t<3, wp::float32> var_275;
    const wp::int32 var_276 = 2;
    wp::float32 var_277;
    const wp::float32 var_278 = 0.0;
    bool var_279;
    const wp::int32 var_280 = 0;
    wp::float32 var_281;
    const wp::int32 var_282 = 1;
    wp::float32 var_283;
    wp::vec_t<3, wp::float32> var_284;
    const wp::int32 var_285 = 2;
    wp::float32 var_286;
    const wp::float32 var_287 = 0.0;
    bool var_288;
    const wp::int32 var_289 = 0;
    wp::float32 var_290;
    const wp::int32 var_291 = 1;
    wp::float32 var_292;
    wp::float32 var_293;
    wp::vec_t<3, wp::float32> var_294;
    wp::vec_t<3, wp::float32> var_295;
    wp::vec_t<3, wp::float32> var_296;
    wp::vec_t<3, wp::float32> var_297;
    wp::int32* var_298;
    const wp::int32 var_299 = 9;
    bool var_300;
    wp::int32 var_301;
    wp::vec_t<3, wp::float32>* var_302;
    const wp::int32 var_303 = 0;
    wp::float32 var_304;
    wp::vec_t<3, wp::float32> var_305;
    wp::vec_t<3, wp::float32>* var_306;
    const wp::int32 var_307 = 1;
    wp::float32 var_308;
    wp::vec_t<3, wp::float32> var_309;
    const wp::float32 var_310 = 0.0;
    const wp::float32 var_311 = 0.0;
    wp::vec_t<3, wp::float32> var_312;
    const wp::int32 var_313 = 0;
    wp::float32 var_314;
    const wp::int32 var_315 = 1;
    wp::float32 var_316;
    const wp::float32 var_317 = 0.0;
    wp::vec_t<3, wp::float32> var_318;
    wp::float32 var_319;
    bool var_320;
    const wp::float32 var_321 = 2.0;
    wp::float32 var_322;
    wp::float32 var_323;
    const wp::float32 var_324 = 0.0;
    wp::float32 var_325;
    bool var_326;
    const wp::int32 var_327 = 2;
    wp::float32 var_328;
    const wp::float32 var_329 = 0.0;
    bool var_330;
    wp::vec_t<3, wp::float32> var_331;
    const wp::float32 var_332 = 0.0;
    wp::float32 var_333;
    wp::vec_t<3, wp::float32> var_334;
    wp::vec_t<3, wp::float32> var_335;
    const wp::int32 var_336 = 2;
    wp::float32 var_337;
    wp::float32 var_338;
    bool var_339;
    wp::vec_t<3, wp::float32> var_340;
    wp::vec_t<3, wp::float32> var_341;
    const wp::int32 var_342 = 0;
    wp::float32 var_343;
    wp::float32 var_344;
    const wp::int32 var_345 = 1;
    wp::float32 var_346;
    wp::float32 var_347;
    wp::float32 var_348;
    wp::vec_t<3, wp::float32> var_349;
    wp::vec_t<3, wp::float32> var_350;
    wp::vec_t<3, wp::float32> var_351;
    wp::int32* var_352;
    const wp::int32 var_353 = 1;
    bool var_354;
    wp::int32 var_355;
    wp::vec_t<3, wp::float32>* var_356;
    const wp::int32 var_357 = 0;
    wp::float32 var_358;
    wp::vec_t<3, wp::float32> var_359;
    wp::vec_t<3, wp::float32>* var_360;
    const wp::int32 var_361 = 1;
    wp::float32 var_362;
    wp::vec_t<3, wp::float32> var_363;
    const wp::int32 var_364 = 0;
    wp::float32 var_365;
    const wp::float32 var_366 = 0.0;
    bool var_367;
    const wp::float32 var_368 = 1.0;
    const wp::float32 var_369 = -1.0;
    wp::float32 var_370;
    const wp::int32 var_371 = 1;
    wp::float32 var_372;
    const wp::float32 var_373 = 0.0;
    bool var_374;
    const wp::float32 var_375 = 1.0;
    const wp::float32 var_376 = -1.0;
    wp::float32 var_377;
    wp::float32 var_378;
    wp::float32 var_379;
    const wp::float32 var_380 = 0.0;
    wp::vec_t<3, wp::float32> var_381;
    const wp::float32 var_382 = 0.0;
    const wp::float32 var_383 = 0.0;
    const wp::float32 var_384 = 0.0;
    wp::vec_t<3, wp::float32> var_385;
    wp::vec_t<3, wp::float32> var_386;
    wp::vec_t<3, wp::float32> var_387;
    wp::vec_t<3, wp::float32> var_388;
    wp::float32 var_389;
    wp::float32 var_390;
    wp::vec_t<3, wp::float32> var_391;
    wp::vec_t<3, wp::float32> var_392;
    wp::vec_t<3, wp::float32> var_393;
    wp::vec_t<3, wp::float32> var_394;
    wp::float32 var_395;
    wp::float32 var_396;
    wp::float32 var_397;
    wp::vec_t<3, wp::float32> var_398;
    wp::float32 var_399;
    wp::float32 var_400;
    wp::vec_t<3, wp::float32> var_401;
    wp::vec_t<3, wp::float32> var_402;
    wp::float32 var_403;
    wp::float32 var_404;
    wp::vec_t<3, wp::float32> var_405;
    wp::vec_t<3, wp::float32> var_406;
    //---------
    // forward
    // def support_map(geom: GenericShapeData, direction: wp.vec3, data_provider: SupportMapDataProvider) -> wp.vec3:       <L 107>
    // eps = 1.0e-12                                                                          <L 123>
    // result = wp.vec3(0.0, 0.0, 0.0)                                                        <L 125>
    var_4 = wp::vec_t<3, wp::float32>(var_1, var_2, var_3);
    // if geom.shape_type == GeoType.CONVEX_MESH:                                             <L 127>
    var_5 = &((var_geom).shape_type);
    var_8 = wp::load(var_5);
    var_7 = (var_8 == var_6);
    if (var_7) {
        // mesh_ptr = unpack_mesh_ptr(geom.auxiliary)                                         <L 129>
        var_9 = &((var_geom).auxiliary);
        var_11 = wp::load(var_9);
        var_10 = unpack_mesh_ptr_0(var_11);
        // mesh = wp.mesh_get(mesh_ptr)                                                       <L 130>
        var_12 = wp::mesh_get(var_10);
        // mesh_scale = geom.scale                                                            <L 132>
        var_13 = &((var_geom).scale);
        var_15 = wp::load(var_13);
        var_14 = wp::copy(var_15);
        // num_verts = mesh.points.shape[0]                                                   <L 133>
        var_16 = &((var_12).points);
        var_17 = &(var_16->shape);
        var_20 = wp::load(var_17);
        var_19 = wp::extract(var_20, var_18);
        // scaled_dir = wp.cw_mul(direction, mesh_scale)                                      <L 137>
        var_21 = wp::cw_mul(var_direction, var_14);
        // max_dot = float(-1.0e10)                                                           <L 139>
        var_23 = wp::float(var_22);
        // best_idx = int(0)                                                                  <L 140>
        var_25 = wp::int(var_24);
        // for i in range(num_verts):                                                         <L 141>
        var_26 = wp::range(var_19);
        start_for_0:;
            if (iter_cmp(var_26) == 0) goto end_for_0;
            var_27 = wp::iter_next(var_26);
            // dot_val = wp.dot(mesh.points[i], scaled_dir)                                   <L 142>
            var_28 = &((var_12).points);
            var_30 = wp::load(var_28);
            var_29 = wp::address(var_30, var_27);
            var_32 = wp::load(var_29);
            var_31 = wp::dot(var_32, var_21);
            // if dot_val > max_dot:                                                          <L 143>
            var_33 = (var_31 > var_23);
            if (var_33) {
                // max_dot = dot_val                                                          <L 144>
                var_34 = wp::copy(var_31);
                // best_idx = i                                                               <L 145>
                var_35 = wp::copy(var_27);
            }
            var_36 = wp::where(var_33, var_34, var_23);
            var_37 = wp::where(var_33, var_35, var_25);
            wp::assign(var_23, var_36);
            wp::assign(var_25, var_37);
            goto start_for_0;
        end_for_0:;
        // result = wp.cw_mul(mesh.points[best_idx], mesh_scale)                              <L 146>
        var_38 = &((var_12).points);
        var_40 = wp::load(var_38);
        var_39 = wp::address(var_40, var_25);
        var_42 = wp::load(var_39);
        var_41 = wp::cw_mul(var_42, var_14);
    }
    if (!var_7) {
        // elif geom.shape_type == GeoTypeEx.TRIANGLE or geom.shape_type == GeoTypeEx.TRIANGLE_PRISM:       <L 148>
        var_44 = &((var_geom).shape_type);
        var_47 = wp::load(var_44);
        var_46 = (var_47 == var_45);
        var_43 = var_46;
        if (!var_43) {
            var_48 = &((var_geom).shape_type);
            var_51 = wp::load(var_48);
            var_50 = (var_51 == var_49);
            var_43 = var_43 || var_50;
        }
        if (var_43) {
            // tri_a = wp.vec3(0.0, 0.0, 0.0)                                                 <L 150>
            var_55 = wp::vec_t<3, wp::float32>(var_52, var_53, var_54);
            // tri_b = geom.scale                                                             <L 151>
            var_56 = &((var_geom).scale);
            var_58 = wp::load(var_56);
            var_57 = wp::copy(var_58);
            // tri_c = geom.auxiliary                                                         <L 152>
            var_59 = &((var_geom).auxiliary);
            var_61 = wp::load(var_59);
            var_60 = wp::copy(var_61);
            // dot_a = wp.dot(tri_a, direction)                                               <L 155>
            var_62 = wp::dot(var_55, var_direction);
            // dot_b = wp.dot(tri_b, direction)                                               <L 156>
            var_63 = wp::dot(var_57, var_direction);
            // dot_c = wp.dot(tri_c, direction)                                               <L 157>
            var_64 = wp::dot(var_60, var_direction);
            // if dot_a >= dot_b and dot_a >= dot_c:                                          <L 160>
            var_66 = (var_62 >= var_63);
            var_65 = var_66;
            if (var_65) {
                var_67 = (var_62 >= var_64);
                var_65 = var_65 && var_67;
            }
            if (var_65) {
                // result = tri_a                                                             <L 161>
                var_68 = wp::copy(var_55);
            }
            if (!var_65) {
                // elif dot_b >= dot_c:                                                       <L 162>
                var_69 = (var_63 >= var_64);
                if (var_69) {
                    // result = tri_b                                                         <L 163>
                    var_70 = wp::copy(var_57);
                }
                if (!var_69) {
                    // result = tri_c                                                         <L 165>
                    var_71 = wp::copy(var_60);
                }
                var_72 = wp::where(var_69, var_70, var_71);
            }
            var_73 = wp::where(var_65, var_68, var_72);
            // if geom.shape_type == GeoTypeEx.TRIANGLE_PRISM:                                <L 172>
            var_74 = &((var_geom).shape_type);
            var_77 = wp::load(var_74);
            var_76 = (var_77 == var_75);
            if (var_76) {
                // if direction[2] < 0.0:                                                     <L 173>
                var_79 = wp::extract(var_direction, var_78);
                var_81 = (var_79 < var_80);
                if (var_81) {
                    // result = result + wp.vec3(0.0, 0.0, -1.0)                              <L 174>
                    var_85 = wp::vec_t<3, wp::float32>(var_82, var_83, var_84);
                    var_86 = wp::add(var_73, var_85);
                }
                var_87 = wp::where(var_81, var_86, var_73);
            }
            var_88 = wp::where(var_76, var_87, var_73);
        }
        if (!var_43) {
            // elif geom.shape_type == GeoType.BOX:                                           <L 175>
            var_89 = &((var_geom).shape_type);
            var_92 = wp::load(var_89);
            var_91 = (var_92 == var_90);
            if (var_91) {
                // threshold = BOX_SUPPORT_DEADBAND * wp.length(direction)                    <L 182>
                var_94 = wp::length(var_direction);
                var_95 = wp::mul(var_93, var_94);
                // sx = 1.0 if direction[0] >= -threshold else -1.0                           <L 183>
                var_97 = wp::extract(var_direction, var_96);
                var_98 = wp::neg(var_95);
                var_99 = (var_97 >= var_98);
                if (var_99) {
                }
                if (!var_99) {
                }
                var_102 = wp::where(var_99, var_100, var_101);
                // sy = 1.0 if direction[1] >= -threshold else -1.0                           <L 184>
                var_104 = wp::extract(var_direction, var_103);
                var_105 = wp::neg(var_95);
                var_106 = (var_104 >= var_105);
                if (var_106) {
                }
                if (!var_106) {
                }
                var_109 = wp::where(var_106, var_107, var_108);
                // sz = 1.0 if direction[2] >= -threshold else -1.0                           <L 185>
                var_111 = wp::extract(var_direction, var_110);
                var_112 = wp::neg(var_95);
                var_113 = (var_111 >= var_112);
                if (var_113) {
                }
                if (!var_113) {
                }
                var_116 = wp::where(var_113, var_114, var_115);
                // result = wp.vec3(sx * geom.scale[0], sy * geom.scale[1], sz * geom.scale[2])       <L 187>
                var_117 = &((var_geom).scale);
                var_120 = wp::load(var_117);
                var_119 = wp::extract(var_120, var_118);
                var_121 = wp::mul(var_102, var_119);
                var_122 = &((var_geom).scale);
                var_125 = wp::load(var_122);
                var_124 = wp::extract(var_125, var_123);
                var_126 = wp::mul(var_109, var_124);
                var_127 = &((var_geom).scale);
                var_130 = wp::load(var_127);
                var_129 = wp::extract(var_130, var_128);
                var_131 = wp::mul(var_116, var_129);
                var_132 = wp::vec_t<3, wp::float32>(var_121, var_126, var_131);
            }
            if (!var_91) {
                // elif geom.shape_type == GeoType.SPHERE:                                    <L 189>
                var_133 = &((var_geom).shape_type);
                var_136 = wp::load(var_133);
                var_135 = (var_136 == var_134);
                if (var_135) {
                    // radius = geom.scale[0]                                                 <L 190>
                    var_137 = &((var_geom).scale);
                    var_140 = wp::load(var_137);
                    var_139 = wp::extract(var_140, var_138);
                    // dir_len_sq = wp.length_sq(direction)                                   <L 191>
                    var_141 = wp::length_sq(var_direction);
                    // if dir_len_sq > eps:                                                   <L 192>
                    var_142 = (var_141 > var_0);
                    if (var_142) {
                        // n = wp.normalize(direction)                                        <L 193>
                        var_143 = wp::normalize(var_direction);
                    }
                    if (!var_142) {
                        // n = wp.vec3(1.0, 0.0, 0.0)                                         <L 195>
                        var_147 = wp::vec_t<3, wp::float32>(var_144, var_145, var_146);
                    }
                    var_148 = wp::where(var_142, var_143, var_147);
                    // result = n * radius                                                    <L 196>
                    var_149 = wp::mul(var_148, var_139);
                }
                if (!var_135) {
                    // elif geom.shape_type == GeoType.CAPSULE:                               <L 198>
                    var_150 = &((var_geom).shape_type);
                    var_153 = wp::load(var_150);
                    var_152 = (var_153 == var_151);
                    if (var_152) {
                        // radius = geom.scale[0]                                             <L 199>
                        var_154 = &((var_geom).scale);
                        var_157 = wp::load(var_154);
                        var_156 = wp::extract(var_157, var_155);
                        // half_height = geom.scale[1]                                        <L 200>
                        var_158 = &((var_geom).scale);
                        var_161 = wp::load(var_158);
                        var_160 = wp::extract(var_161, var_159);
                        // dir_len_sq = wp.length_sq(direction)                               <L 204>
                        var_162 = wp::length_sq(var_direction);
                        // if dir_len_sq > eps:                                               <L 205>
                        var_163 = (var_162 > var_0);
                        if (var_163) {
                            // n = wp.normalize(direction)                                    <L 206>
                            var_164 = wp::normalize(var_direction);
                        }
                        if (!var_163) {
                            // n = wp.vec3(1.0, 0.0, 0.0)                                     <L 208>
                            var_168 = wp::vec_t<3, wp::float32>(var_165, var_166, var_167);
                        }
                        var_169 = wp::where(var_163, var_164, var_168);
                        // result = n * radius                                                <L 209>
                        var_170 = wp::mul(var_169, var_156);
                        // if direction[2] >= 0.0:                                            <L 213>
                        var_172 = wp::extract(var_direction, var_171);
                        var_174 = (var_172 >= var_173);
                        if (var_174) {
                            // result = result + wp.vec3(0.0, 0.0, half_height)               <L 214>
                            var_177 = wp::vec_t<3, wp::float32>(var_175, var_176, var_160);
                            var_178 = wp::add(var_170, var_177);
                        }
                        if (!var_174) {
                            // result = result + wp.vec3(0.0, 0.0, -half_height)              <L 216>
                            var_181 = wp::neg(var_160);
                            var_182 = wp::vec_t<3, wp::float32>(var_179, var_180, var_181);
                            var_183 = wp::add(var_170, var_182);
                        }
                        var_184 = wp::where(var_174, var_178, var_183);
                    }
                    if (!var_152) {
                        // elif geom.shape_type == GeoType.ELLIPSOID:                         <L 218>
                        var_185 = &((var_geom).shape_type);
                        var_188 = wp::load(var_185);
                        var_187 = (var_188 == var_186);
                        if (var_187) {
                            // a = geom.scale[0]                                              <L 221>
                            var_189 = &((var_geom).scale);
                            var_192 = wp::load(var_189);
                            var_191 = wp::extract(var_192, var_190);
                            // b = geom.scale[1]                                              <L 222>
                            var_193 = &((var_geom).scale);
                            var_196 = wp::load(var_193);
                            var_195 = wp::extract(var_196, var_194);
                            // c = geom.scale[2]                                              <L 223>
                            var_197 = &((var_geom).scale);
                            var_200 = wp::load(var_197);
                            var_199 = wp::extract(var_200, var_198);
                            // dir_len_sq = wp.length_sq(direction)                           <L 224>
                            var_201 = wp::length_sq(var_direction);
                            // if dir_len_sq > eps:                                           <L 225>
                            var_202 = (var_201 > var_0);
                            if (var_202) {
                                // adx = a * direction[0]                                     <L 226>
                                var_204 = wp::extract(var_direction, var_203);
                                var_205 = wp::mul(var_191, var_204);
                                // bdy = b * direction[1]                                     <L 227>
                                var_207 = wp::extract(var_direction, var_206);
                                var_208 = wp::mul(var_195, var_207);
                                // cdz = c * direction[2]                                     <L 228>
                                var_210 = wp::extract(var_direction, var_209);
                                var_211 = wp::mul(var_199, var_210);
                                // denom_sq = adx * adx + bdy * bdy + cdz * cdz               <L 229>
                                var_212 = wp::mul(var_205, var_205);
                                var_213 = wp::mul(var_208, var_208);
                                var_214 = wp::add(var_212, var_213);
                                var_215 = wp::mul(var_211, var_211);
                                var_216 = wp::add(var_214, var_215);
                                // if denom_sq > eps:                                         <L 230>
                                var_217 = (var_216 > var_0);
                                if (var_217) {
                                    // denom = wp.sqrt(denom_sq)                              <L 231>
                                    var_218 = wp::sqrt(var_216);
                                    // result = wp.vec3(                                      <L 232>
                                    // (a * a) * direction[0] / denom, (b * b) * direction[1] / denom, (c * c) * direction[2] / denom       <L 233>
                                    var_219 = wp::mul(var_191, var_191);
                                    var_221 = wp::extract(var_direction, var_220);
                                    var_222 = wp::mul(var_219, var_221);
                                    var_223 = wp::div(var_222, var_218);
                                    var_224 = wp::mul(var_195, var_195);
                                    var_226 = wp::extract(var_direction, var_225);
                                    var_227 = wp::mul(var_224, var_226);
                                    var_228 = wp::div(var_227, var_218);
                                    var_229 = wp::mul(var_199, var_199);
                                    var_231 = wp::extract(var_direction, var_230);
                                    var_232 = wp::mul(var_229, var_231);
                                    var_233 = wp::div(var_232, var_218);
                                    var_234 = wp::vec_t<3, wp::float32>(var_223, var_228, var_233);
                                }
                                if (!var_217) {
                                    // result = wp.vec3(a, 0.0, 0.0)                          <L 236>
                                    var_237 = wp::vec_t<3, wp::float32>(var_191, var_235, var_236);
                                }
                                var_238 = wp::where(var_217, var_234, var_237);
                            }
                            if (!var_202) {
                                // result = wp.vec3(a, 0.0, 0.0)                              <L 238>
                                var_241 = wp::vec_t<3, wp::float32>(var_191, var_239, var_240);
                            }
                            var_242 = wp::where(var_202, var_238, var_241);
                        }
                        if (!var_187) {
                            // elif geom.shape_type == GeoType.CYLINDER:                      <L 240>
                            var_243 = &((var_geom).shape_type);
                            var_246 = wp::load(var_243);
                            var_245 = (var_246 == var_244);
                            if (var_245) {
                                // radius = geom.scale[0]                                     <L 241>
                                var_247 = &((var_geom).scale);
                                var_250 = wp::load(var_247);
                                var_249 = wp::extract(var_250, var_248);
                                // half_height = geom.scale[1]                                <L 242>
                                var_251 = &((var_geom).scale);
                                var_254 = wp::load(var_251);
                                var_253 = wp::extract(var_254, var_252);
                                // dir_xy = wp.vec3(direction[0], direction[1], 0.0)          <L 245>
                                var_256 = wp::extract(var_direction, var_255);
                                var_258 = wp::extract(var_direction, var_257);
                                var_260 = wp::vec_t<3, wp::float32>(var_256, var_258, var_259);
                                // dir_xy_len_sq = wp.length_sq(dir_xy)                       <L 246>
                                var_261 = wp::length_sq(var_260);
                                // if dir_xy_len_sq > eps:                                    <L 248>
                                var_262 = (var_261 > var_0);
                                if (var_262) {
                                    // n_xy = wp.normalize(dir_xy)                            <L 249>
                                    var_263 = wp::normalize(var_260);
                                    // lateral_point = wp.vec3(n_xy[0] * radius, n_xy[1] * radius, 0.0)       <L 250>
                                    var_265 = wp::extract(var_263, var_264);
                                    var_266 = wp::mul(var_265, var_249);
                                    var_268 = wp::extract(var_263, var_267);
                                    var_269 = wp::mul(var_268, var_249);
                                    var_271 = wp::vec_t<3, wp::float32>(var_266, var_269, var_270);
                                }
                                if (!var_262) {
                                    // lateral_point = wp.vec3(radius, 0.0, 0.0)              <L 252>
                                    var_274 = wp::vec_t<3, wp::float32>(var_249, var_272, var_273);
                                }
                                var_275 = wp::where(var_262, var_271, var_274);
                                // if direction[2] > 0.0:                                     <L 255>
                                var_277 = wp::extract(var_direction, var_276);
                                var_279 = (var_277 > var_278);
                                if (var_279) {
                                    // result = wp.vec3(lateral_point[0], lateral_point[1], half_height)       <L 256>
                                    var_281 = wp::extract(var_275, var_280);
                                    var_283 = wp::extract(var_275, var_282);
                                    var_284 = wp::vec_t<3, wp::float32>(var_281, var_283, var_253);
                                }
                                if (!var_279) {
                                    // elif direction[2] < 0.0:                               <L 257>
                                    var_286 = wp::extract(var_direction, var_285);
                                    var_288 = (var_286 < var_287);
                                    if (var_288) {
                                        // result = wp.vec3(lateral_point[0], lateral_point[1], -half_height)       <L 258>
                                        var_290 = wp::extract(var_275, var_289);
                                        var_292 = wp::extract(var_275, var_291);
                                        var_293 = wp::neg(var_253);
                                        var_294 = wp::vec_t<3, wp::float32>(var_290, var_292, var_293);
                                    }
                                    if (!var_288) {
                                        // result = lateral_point                             <L 260>
                                        var_295 = wp::copy(var_275);
                                    }
                                    var_296 = wp::where(var_288, var_294, var_295);
                                }
                                var_297 = wp::where(var_279, var_284, var_296);
                            }
                            if (!var_245) {
                                // elif geom.shape_type == GeoType.CONE:                      <L 262>
                                var_298 = &((var_geom).shape_type);
                                var_301 = wp::load(var_298);
                                var_300 = (var_301 == var_299);
                                if (var_300) {
                                    // radius = geom.scale[0]                                 <L 263>
                                    var_302 = &((var_geom).scale);
                                    var_305 = wp::load(var_302);
                                    var_304 = wp::extract(var_305, var_303);
                                    // half_height = geom.scale[1]                            <L 264>
                                    var_306 = &((var_geom).scale);
                                    var_309 = wp::load(var_306);
                                    var_308 = wp::extract(var_309, var_307);
                                    // apex = wp.vec3(0.0, 0.0, half_height)                  <L 269>
                                    var_312 = wp::vec_t<3, wp::float32>(var_310, var_311, var_308);
                                    // dir_xy = wp.vec3(direction[0], direction[1], 0.0)       <L 270>
                                    var_314 = wp::extract(var_direction, var_313);
                                    var_316 = wp::extract(var_direction, var_315);
                                    var_318 = wp::vec_t<3, wp::float32>(var_314, var_316, var_317);
                                    // dir_xy_len = wp.length(dir_xy)                         <L 271>
                                    var_319 = wp::length(var_318);
                                    // k = radius / (2.0 * half_height) if half_height > eps else 0.0       <L 272>
                                    var_320 = (var_308 > var_0);
                                    if (var_320) {
                                        var_322 = wp::mul(var_321, var_308);
                                        var_323 = wp::div(var_304, var_322);
                                    }
                                    if (!var_320) {
                                    }
                                    var_325 = wp::where(var_320, var_323, var_324);
                                    // if dir_xy_len <= eps:                                  <L 274>
                                    var_326 = (var_319 <= var_0);
                                    if (var_326) {
                                        // if direction[2] >= 0.0:                            <L 276>
                                        var_328 = wp::extract(var_direction, var_327);
                                        var_330 = (var_328 >= var_329);
                                        if (var_330) {
                                            // result = apex                                  <L 277>
                                            var_331 = wp::copy(var_312);
                                        }
                                        if (!var_330) {
                                            // result = wp.vec3(radius, 0.0, -half_height)       <L 279>
                                            var_333 = wp::neg(var_308);
                                            var_334 = wp::vec_t<3, wp::float32>(var_304, var_332, var_333);
                                        }
                                        var_335 = wp::where(var_330, var_331, var_334);
                                    }
                                    if (!var_326) {
                                        // if direction[2] >= k * dir_xy_len:                 <L 281>
                                        var_337 = wp::extract(var_direction, var_336);
                                        var_338 = wp::mul(var_325, var_319);
                                        var_339 = (var_337 >= var_338);
                                        if (var_339) {
                                            // result = apex                                  <L 282>
                                            var_340 = wp::copy(var_312);
                                        }
                                        if (!var_339) {
                                            // n_xy = dir_xy / dir_xy_len                     <L 284>
                                            var_341 = wp::div(var_318, var_319);
                                            // result = wp.vec3(n_xy[0] * radius, n_xy[1] * radius, -half_height)       <L 285>
                                            var_343 = wp::extract(var_341, var_342);
                                            var_344 = wp::mul(var_343, var_304);
                                            var_346 = wp::extract(var_341, var_345);
                                            var_347 = wp::mul(var_346, var_304);
                                            var_348 = wp::neg(var_308);
                                            var_349 = wp::vec_t<3, wp::float32>(var_344, var_347, var_348);
                                        }
                                        var_350 = wp::where(var_339, var_340, var_349);
                                    }
                                    var_351 = wp::where(var_326, var_335, var_350);
                                }
                                if (!var_300) {
                                    // elif geom.shape_type == GeoType.PLANE:                 <L 287>
                                    var_352 = &((var_geom).shape_type);
                                    var_355 = wp::load(var_352);
                                    var_354 = (var_355 == var_353);
                                    if (var_354) {
                                        // half_width = geom.scale[0]                         <L 290>
                                        var_356 = &((var_geom).scale);
                                        var_359 = wp::load(var_356);
                                        var_358 = wp::extract(var_359, var_357);
                                        // half_length = geom.scale[1]                        <L 291>
                                        var_360 = &((var_geom).scale);
                                        var_363 = wp::load(var_360);
                                        var_362 = wp::extract(var_363, var_361);
                                        // sx = 1.0 if direction[0] >= 0.0 else -1.0          <L 294>
                                        var_365 = wp::extract(var_direction, var_364);
                                        var_367 = (var_365 >= var_366);
                                        if (var_367) {
                                        }
                                        if (!var_367) {
                                        }
                                        var_370 = wp::where(var_367, var_368, var_369);
                                        // sy = 1.0 if direction[1] >= 0.0 else -1.0          <L 295>
                                        var_372 = wp::extract(var_direction, var_371);
                                        var_374 = (var_372 >= var_373);
                                        if (var_374) {
                                        }
                                        if (!var_374) {
                                        }
                                        var_377 = wp::where(var_374, var_375, var_376);
                                        // result = wp.vec3(sx * half_width, sy * half_length, 0.0)       <L 298>
                                        var_378 = wp::mul(var_370, var_358);
                                        var_379 = wp::mul(var_377, var_362);
                                        var_381 = wp::vec_t<3, wp::float32>(var_378, var_379, var_380);
                                    }
                                    if (!var_354) {
                                        // result = wp.vec3(0.0, 0.0, 0.0)                    <L 302>
                                        var_385 = wp::vec_t<3, wp::float32>(var_382, var_383, var_384);
                                    }
                                    var_386 = wp::where(var_354, var_381, var_385);
                                }
                                var_387 = wp::where(var_300, var_351, var_386);
                            }
                            var_388 = wp::where(var_245, var_297, var_387);
                            var_389 = wp::where(var_245, var_249, var_304);
                            var_390 = wp::where(var_245, var_253, var_308);
                            var_391 = wp::where(var_245, var_260, var_318);
                            var_392 = wp::where(var_245, var_263, var_341);
                        }
                        var_393 = wp::where(var_187, var_242, var_388);
                    }
                    var_394 = wp::where(var_152, var_184, var_393);
                    var_395 = wp::where(var_152, var_156, var_389);
                    var_396 = wp::where(var_152, var_160, var_390);
                    var_397 = wp::where(var_152, var_162, var_201);
                }
                var_398 = wp::where(var_135, var_149, var_394);
                var_399 = wp::where(var_135, var_139, var_395);
                var_400 = wp::where(var_135, var_141, var_397);
                var_401 = wp::where(var_135, var_148, var_169);
            }
            var_402 = wp::where(var_91, var_132, var_398);
            var_403 = wp::where(var_91, var_102, var_370);
            var_404 = wp::where(var_91, var_109, var_377);
        }
        var_405 = wp::where(var_43, var_88, var_402);
    }
    var_406 = wp::where(var_7, var_41, var_405);
    // return result                                                                          <L 304>
    return var_406;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/mpr.py:0
static CUDA_CALLABLE wp::vec_t<3, wp::float32> create_solve_mpr__locals__centered_box_support_12(
    GenericShapeData_ceaba563 var_geom,
    wp::vec_t<3, wp::float32> var_direction,
    SupportMapDataProvider_e77f8b9f var_data_provider)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::int32* var_1;
    const wp::int32 var_2 = 7;
    bool var_3;
    wp::int32 var_4;
    wp::vec_t<3, wp::float32> var_5;
    wp::vec_t<3, wp::float32>* var_6;
    wp::vec_t<3, wp::float32> var_7;
    wp::vec_t<3, wp::float32> var_8;
    const wp::float32 var_9 = 1e-06;
    const wp::int32 var_10 = 0;
    wp::float32 var_11;
    const wp::int32 var_12 = 1;
    wp::float32 var_13;
    wp::float32 var_14;
    const wp::int32 var_15 = 2;
    wp::float32 var_16;
    wp::float32 var_17;
    wp::float32 var_18;
    const wp::int32 var_19 = 0;
    wp::float32 var_20;
    bool var_21;
    const wp::float32 var_22 = 0.0;
    const wp::int32 var_23 = 0;
    const wp::int32 var_24 = 1;
    wp::float32 var_25;
    bool var_26;
    const wp::float32 var_27 = 0.0;
    const wp::int32 var_28 = 1;
    const wp::int32 var_29 = 2;
    wp::float32 var_30;
    bool var_31;
    const wp::float32 var_32 = 0.0;
    const wp::int32 var_33 = 2;
    //---------
    // forward
    // def centered_box_support(geom: Any, direction: wp.vec3, data_provider: Any) -> wp.vec3:       <L 1>
    // result = support_func(geom, direction, data_provider)                                  <L 2>
    var_0 = support_map_0(var_geom, var_direction, var_data_provider);
    // if geom.shape_type == GeoType.BOX:                                                     <L 3>
    var_1 = &((var_geom).shape_type);
    var_4 = wp::load(var_1);
    var_3 = (var_4 == var_2);
    if (var_3) {
        // contribution = wp.cw_mul(wp.abs(direction), geom.scale)                            <L 6>
        var_5 = wp::abs(var_direction);
        var_6 = &((var_geom).scale);
        var_8 = wp::load(var_6);
        var_7 = wp::cw_mul(var_5, var_8);
        // threshold = MPR_BOX_SUPPORT_TIE_EPSILON * (contribution[0] + contribution[1] + contribution[2])       <L 7>
        var_11 = wp::extract(var_7, var_10);
        var_13 = wp::extract(var_7, var_12);
        var_14 = wp::add(var_11, var_13);
        var_16 = wp::extract(var_7, var_15);
        var_17 = wp::add(var_14, var_16);
        var_18 = wp::mul(var_9, var_17);
        // if contribution[0] <= threshold:                                                   <L 8>
        var_20 = wp::extract(var_7, var_19);
        var_21 = (var_20 <= var_18);
        if (var_21) {
            // result[0] = 0.0                                                                <L 9>
            wp::assign_inplace(var_0, var_23, var_22);
        }
        // if contribution[1] <= threshold:                                                   <L 10>
        var_25 = wp::extract(var_7, var_24);
        var_26 = (var_25 <= var_18);
        if (var_26) {
            // result[1] = 0.0                                                                <L 11>
            wp::assign_inplace(var_0, var_28, var_27);
        }
        // if contribution[2] <= threshold:                                                   <L 12>
        var_30 = wp::extract(var_7, var_29);
        var_31 = (var_30 <= var_18);
        if (var_31) {
            // result[2] = 0.0                                                                <L 13>
            wp::assign_inplace(var_0, var_33, var_32);
        }
    }
    // return result                                                                          <L 14>
    return var_0;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/mpr.py:0
static CUDA_CALLABLE wp::vec_t<3, wp::float32> create_support_map_function__locals__support_map_b_25(
    GenericShapeData_ceaba563 var_geom_b,
    wp::vec_t<3, wp::float32> var_direction,
    wp::quat_t<wp::float32> var_orientation_b,
    wp::vec_t<3, wp::float32> var_position_b,
    SupportMapDataProvider_e77f8b9f var_data_provider)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    //---------
    // forward
    // def support_map_b(                                                                     <L 1>
    // tmp = wp.quat_rotate_inv(orientation_b, direction)                                     <L 22>
    var_0 = wp::quat_rotate_inv(var_orientation_b, var_direction);
    // result = support_func(geom_b, tmp, data_provider)                                      <L 25>
    var_1 = create_solve_mpr__locals__centered_box_support_12(var_geom_b, var_0, var_data_provider);
    // result = wp.quat_rotate(orientation_b, result)                                         <L 28>
    var_2 = wp::quat_rotate(var_orientation_b, var_1);
    // result = result + position_b                                                           <L 29>
    var_3 = wp::add(var_2, var_position_b);
    // return result                                                                          <L 31>
    return var_3;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/mpr.py:0
static CUDA_CALLABLE Vert_99873389 create_support_map_function__locals__minkowski_support_25(
    GenericShapeData_ceaba563 var_geom_a,
    GenericShapeData_ceaba563 var_geom_b,
    wp::vec_t<3, wp::float32> var_direction,
    wp::quat_t<wp::float32> var_orientation_b,
    wp::vec_t<3, wp::float32> var_position_b,
    wp::float32 var_extend,
    SupportMapDataProvider_e77f8b9f var_data_provider)
{
    //---------
    // primal vars
    Vert_99873389 var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    const wp::float32 var_4 = 0.0;
    bool var_5;
    wp::vec_t<3, wp::float32> var_6;
    wp::vec_t<3, wp::float32> var_7;
    const wp::float32 var_8 = 0.5;
    wp::vec_t<3, wp::float32> var_9;
    wp::vec_t<3, wp::float32> var_10;
    wp::vec_t<3, wp::float32>* var_11;
    wp::vec_t<3, wp::float32> var_12;
    wp::vec_t<3, wp::float32> var_13;
    wp::vec_t<3, wp::float32> var_14;
    wp::vec_t<3, wp::float32>* var_15;
    wp::vec_t<3, wp::float32> var_16;
    wp::vec_t<3, wp::float32> var_17;
    //---------
    // forward
    // def minkowski_support(                                                                 <L 1>
    // v = Vert()                                                                             <L 25>
    var_0 = Vert_99873389();
    // point_a = support_func(geom_a, direction, data_provider)                               <L 28>
    var_1 = create_solve_mpr__locals__centered_box_support_12(var_geom_a, var_direction, var_data_provider);
    // tmp_direction = -direction                                                             <L 31>
    var_2 = wp::neg(var_direction);
    // v.B = support_map_b(geom_b, tmp_direction, orientation_b, position_b, data_provider)       <L 32>
    var_3 = create_support_map_function__locals__support_map_b_25(var_geom_b, var_2, var_orientation_b, var_position_b, var_data_provider);
    var_0.B = var_3;
    // if extend != 0.0:                                                                      <L 35>
    var_5 = (var_extend != var_4);
    if (var_5) {
        // d = wp.normalize(direction) * extend * 0.5                                         <L 36>
        var_6 = wp::normalize(var_direction);
        var_7 = wp::mul(var_6, var_extend);
        var_9 = wp::mul(var_7, var_8);
        // point_a = point_a + d                                                              <L 37>
        var_10 = wp::add(var_1, var_9);
        // v.B = v.B - d                                                                      <L 38>
        var_11 = &((var_0).B);
        var_13 = wp::load(var_11);
        var_12 = wp::sub(var_13, var_9);
        var_0.B = var_12;
    }
    var_14 = wp::where(var_5, var_10, var_1);
    // v.BtoA = point_a - v.B                                                                 <L 41>
    var_15 = &((var_0).B);
    var_17 = wp::load(var_15);
    var_16 = wp::sub(var_14, var_17);
    var_0.BtoA = var_16;
    // return v                                                                               <L 43>
    return var_0;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/mpr.py:52
static CUDA_CALLABLE wp::vec_t<3, wp::float32> vert_a_0(
    Vert_99873389 var_vert)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32>* var_0;
    wp::vec_t<3, wp::float32>* var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    wp::vec_t<3, wp::float32> var_4;
    //---------
    // forward
    // def vert_a(vert: Vert) -> wp.vec3:                                                     <L 53>
    // return vert.B + vert.BtoA                                                              <L 55>
    var_0 = &((var_vert).B);
    var_1 = &((var_vert).BtoA);
    var_3 = wp::load(var_0);
    var_4 = wp::load(var_1);
    var_2 = wp::add(var_3, var_4);
    return var_2;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/mpr.py:0
static CUDA_CALLABLE void create_solve_mpr__locals__solve_mpr_core_12(
    GenericShapeData_ceaba563 var_geom_a,
    GenericShapeData_ceaba563 var_geom_b,
    wp::quat_t<wp::float32> var_orientation_b,
    wp::vec_t<3, wp::float32> var_position_b,
    wp::float32 var_extend,
    SupportMapDataProvider_e77f8b9f var_data_provider,
    wp::int32 var_MAX_ITER,
    wp::float32 var_COLLIDE_EPSILON,
    bool & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & ret_2,
    wp::vec_t<3, wp::float32> & ret_3,
    wp::float32 & ret_4)
{
    //---------
    // primal vars
    const wp::float32 var_0 = 1e-16;
    const wp::float32 var_1 = 0.0;
    wp::float32 var_2;
    const wp::float32 var_3 = 0.0;
    const wp::float32 var_4 = 0.0;
    const wp::float32 var_5 = 0.0;
    wp::vec_t<3, wp::float32> var_6;
    const wp::float32 var_7 = 0.0;
    const wp::float32 var_8 = 0.0;
    const wp::float32 var_9 = 0.0;
    wp::vec_t<3, wp::float32> var_10;
    const wp::float32 var_11 = 0.0;
    const wp::float32 var_12 = 0.0;
    const wp::float32 var_13 = 0.0;
    wp::vec_t<3, wp::float32> var_14;
    Vert_99873389 var_15;
    wp::vec_t<3, wp::float32>* var_16;
    wp::vec_t<3, wp::float32> var_17;
    wp::vec_t<3, wp::float32> var_18;
    wp::float32 var_19;
    bool var_20;
    const bool var_21 = false;
    bool var_22;
    bool var_23;
    wp::int32* var_24;
    const wp::int32 var_25 = 1000;
    const wp::int32 var_26 = 1000;
    wp::int32 var_27;
    bool var_28;
    wp::int32 var_29;
    wp::int32* var_30;
    const wp::int32 var_31 = 1001;
    const wp::int32 var_32 = 1001;
    wp::int32 var_33;
    bool var_34;
    wp::int32 var_35;
    const wp::float32 var_36 = 0.0;
    const wp::float32 var_37 = 0.0;
    const wp::float32 var_38 = 0.0;
    wp::vec_t<3, wp::float32> var_39;
    wp::vec_t<3, wp::float32>* var_40;
    wp::vec_t<3, wp::float32> var_41;
    wp::vec_t<3, wp::float32> var_42;
    wp::vec_t<3, wp::float32>* var_43;
    wp::vec_t<3, wp::float32> var_44;
    wp::vec_t<3, wp::float32> var_45;
    wp::vec_t<3, wp::float32> var_46;
    wp::vec_t<3, wp::float32> var_47;
    wp::vec_t<3, wp::float32> var_48;
    wp::float32 var_49;
    const wp::float32 var_50 = 1e-20;
    bool var_51;
    wp::float32 var_52;
    wp::vec_t<3, wp::float32> var_53;
    wp::vec_t<3, wp::float32>* var_54;
    wp::vec_t<3, wp::float32> var_55;
    wp::vec_t<3, wp::float32> var_56;
    wp::vec_t<3, wp::float32> var_57;
    wp::vec_t<3, wp::float32> var_58;
    const wp::float32 var_59 = 3.0;
    wp::vec_t<3, wp::float32> var_60;
    wp::vec_t<3, wp::float32> var_61;
    wp::float32 var_62;
    wp::vec_t<3, wp::float32> var_63;
    wp::vec_t<3, wp::float32> var_64;
    wp::float32 var_65;
    wp::vec_t<3, wp::float32> var_66;
    wp::vec_t<3, wp::float32>* var_67;
    wp::vec_t<3, wp::float32> var_68;
    wp::vec_t<3, wp::float32> var_69;
    wp::float32 var_70;
    const wp::float32 var_71 = 0.0;
    bool var_72;
    wp::vec_t<3, wp::float32> var_73;
    wp::vec_t<3, wp::float32> var_74;
    const wp::float32 var_75 = 1e-20;
    bool var_76;
    const wp::float32 var_77 = 0.01;
    wp::vec_t<3, wp::float32> var_78;
    wp::float32 var_79;
    wp::vec_t<3, wp::float32> var_80;
    wp::vec_t<3, wp::float32> var_81;
    wp::vec_t<3, wp::float32> var_82;
    wp::vec_t<3, wp::float32> var_83;
    const wp::float32 var_84 = 1e-05;
    wp::vec_t<3, wp::float32> var_85;
    const bool var_86 = true;
    bool var_87;
    wp::vec_t<3, wp::float32> var_88;
    bool var_89;
    bool var_90;
    const wp::float32 var_91 = -1e+30;
    wp::float32 var_92;
    const wp::float32 var_93 = 1.0;
    const wp::float32 var_94 = 0.0;
    const wp::float32 var_95 = 0.0;
    wp::vec_t<3, wp::float32> var_96;
    const wp::int32 var_97 = 0;
    const wp::float32 var_98 = 0.0;
    const wp::float32 var_99 = 0.0;
    const wp::float32 var_100 = 0.0;
    wp::vec_t<3, wp::float32> var_101;
    const wp::float32 var_102 = 1.0;
    Vert_99873389 var_103;
    wp::vec_t<3, wp::float32>* var_104;
    wp::float32 var_105;
    wp::vec_t<3, wp::float32> var_106;
    bool var_107;
    wp::float32 var_108;
    wp::vec_t<3, wp::float32> var_109;
    wp::float32 var_110;
    wp::vec_t<3, wp::float32> var_111;
    const wp::int32 var_112 = 1;
    const wp::float32 var_113 = 0.0;
    const wp::float32 var_114 = 0.0;
    const wp::float32 var_115 = 0.0;
    wp::vec_t<3, wp::float32> var_116;
    const wp::float32 var_117 = 1.0;
    Vert_99873389 var_118;
    wp::vec_t<3, wp::float32>* var_119;
    wp::float32 var_120;
    wp::vec_t<3, wp::float32> var_121;
    bool var_122;
    wp::float32 var_123;
    wp::vec_t<3, wp::float32> var_124;
    wp::float32 var_125;
    wp::vec_t<3, wp::float32> var_126;
    const wp::int32 var_127 = 2;
    const wp::float32 var_128 = 0.0;
    const wp::float32 var_129 = 0.0;
    const wp::float32 var_130 = 0.0;
    wp::vec_t<3, wp::float32> var_131;
    const wp::float32 var_132 = 1.0;
    Vert_99873389 var_133;
    wp::vec_t<3, wp::float32>* var_134;
    wp::float32 var_135;
    wp::vec_t<3, wp::float32> var_136;
    bool var_137;
    wp::float32 var_138;
    wp::vec_t<3, wp::float32> var_139;
    wp::float32 var_140;
    wp::vec_t<3, wp::float32> var_141;
    const wp::float32 var_142 = 1e-05;
    wp::vec_t<3, wp::float32> var_143;
    wp::vec_t<3, wp::float32>* var_144;
    wp::vec_t<3, wp::float32> var_145;
    wp::vec_t<3, wp::float32> var_146;
    Vert_99873389 var_147;
    wp::vec_t<3, wp::float32> var_148;
    wp::vec_t<3, wp::float32>* var_149;
    wp::vec_t<3, wp::float32> var_150;
    wp::vec_t<3, wp::float32> var_151;
    wp::vec_t<3, wp::float32>* var_152;
    wp::float32 var_153;
    wp::vec_t<3, wp::float32> var_154;
    const wp::float32 var_155 = 0.0;
    bool var_156;
    const bool var_157 = false;
    wp::vec_t<3, wp::float32>* var_158;
    wp::vec_t<3, wp::float32>* var_159;
    wp::vec_t<3, wp::float32> var_160;
    wp::vec_t<3, wp::float32> var_161;
    wp::vec_t<3, wp::float32> var_162;
    wp::float32 var_163;
    wp::float32 var_164;
    bool var_165;
    wp::vec_t<3, wp::float32>* var_166;
    wp::vec_t<3, wp::float32>* var_167;
    wp::vec_t<3, wp::float32> var_168;
    wp::vec_t<3, wp::float32> var_169;
    wp::vec_t<3, wp::float32> var_170;
    wp::vec_t<3, wp::float32> var_171;
    wp::vec_t<3, wp::float32>* var_172;
    wp::vec_t<3, wp::float32> var_173;
    wp::vec_t<3, wp::float32> var_174;
    wp::float32 var_175;
    const bool var_176 = true;
    wp::float32 var_177;
    wp::vec_t<3, wp::float32> var_178;
    Vert_99873389 var_179;
    wp::vec_t<3, wp::float32>* var_180;
    wp::float32 var_181;
    wp::vec_t<3, wp::float32> var_182;
    const wp::float32 var_183 = 0.0;
    bool var_184;
    const bool var_185 = false;
    wp::vec_t<3, wp::float32>* var_186;
    wp::vec_t<3, wp::float32>* var_187;
    wp::vec_t<3, wp::float32> var_188;
    wp::vec_t<3, wp::float32> var_189;
    wp::vec_t<3, wp::float32> var_190;
    wp::vec_t<3, wp::float32>* var_191;
    wp::vec_t<3, wp::float32>* var_192;
    wp::vec_t<3, wp::float32> var_193;
    wp::vec_t<3, wp::float32> var_194;
    wp::vec_t<3, wp::float32> var_195;
    wp::vec_t<3, wp::float32> var_196;
    wp::vec_t<3, wp::float32>* var_197;
    wp::float32 var_198;
    wp::vec_t<3, wp::float32> var_199;
    const wp::float32 var_200 = 0.0;
    bool var_201;
    wp::vec_t<3, wp::float32>* var_202;
    wp::vec_t<3, wp::float32> var_203;
    wp::vec_t<3, wp::float32> var_204;
    wp::vec_t<3, wp::float32>* var_205;
    wp::vec_t<3, wp::float32> var_206;
    wp::vec_t<3, wp::float32> var_207;
    wp::vec_t<3, wp::float32>* var_208;
    wp::vec_t<3, wp::float32> var_209;
    wp::vec_t<3, wp::float32> var_210;
    wp::vec_t<3, wp::float32>* var_211;
    wp::vec_t<3, wp::float32> var_212;
    wp::vec_t<3, wp::float32> var_213;
    wp::vec_t<3, wp::float32> var_214;
    wp::vec_t<3, wp::float32> var_215;
    const wp::int32 var_216 = 0;
    wp::int32 var_217;
    const wp::int32 var_218 = 0;
    wp::int32 var_219;
    const bool var_220 = false;
    bool var_221;
    Vert_99873389 var_222;
    const bool var_223 = true;
    bool var_224;
    const bool var_225 = false;
    const wp::int32 var_226 = 1;
    wp::int32 var_227;
    Vert_99873389 var_228;
    wp::vec_t<3, wp::float32>* var_229;
    wp::float32 var_230;
    wp::vec_t<3, wp::float32> var_231;
    const wp::float32 var_232 = 0.0;
    bool var_233;
    const bool var_234 = false;
    wp::vec_t<3, wp::float32>* var_235;
    wp::vec_t<3, wp::float32>* var_236;
    wp::vec_t<3, wp::float32> var_237;
    wp::vec_t<3, wp::float32> var_238;
    wp::vec_t<3, wp::float32> var_239;
    wp::vec_t<3, wp::float32>* var_240;
    wp::float32 var_241;
    wp::vec_t<3, wp::float32> var_242;
    const wp::float32 var_243 = 0.0;
    bool var_244;
    Vert_99873389 var_245;
    wp::vec_t<3, wp::float32>* var_246;
    wp::vec_t<3, wp::float32>* var_247;
    wp::vec_t<3, wp::float32> var_248;
    wp::vec_t<3, wp::float32> var_249;
    wp::vec_t<3, wp::float32> var_250;
    wp::vec_t<3, wp::float32>* var_251;
    wp::vec_t<3, wp::float32>* var_252;
    wp::vec_t<3, wp::float32> var_253;
    wp::vec_t<3, wp::float32> var_254;
    wp::vec_t<3, wp::float32> var_255;
    wp::vec_t<3, wp::float32> var_256;
    wp::vec_t<3, wp::float32> var_257;
    wp::int32 var_258;
    Vert_99873389 var_259;
    wp::vec_t<3, wp::float32>* var_260;
    wp::vec_t<3, wp::float32>* var_261;
    wp::vec_t<3, wp::float32> var_262;
    wp::vec_t<3, wp::float32> var_263;
    wp::vec_t<3, wp::float32> var_264;
    wp::vec_t<3, wp::float32>* var_265;
    wp::float32 var_266;
    wp::vec_t<3, wp::float32> var_267;
    const wp::float32 var_268 = 0.0;
    bool var_269;
    Vert_99873389 var_270;
    wp::vec_t<3, wp::float32>* var_271;
    wp::vec_t<3, wp::float32>* var_272;
    wp::vec_t<3, wp::float32> var_273;
    wp::vec_t<3, wp::float32> var_274;
    wp::vec_t<3, wp::float32> var_275;
    wp::vec_t<3, wp::float32>* var_276;
    wp::vec_t<3, wp::float32>* var_277;
    wp::vec_t<3, wp::float32> var_278;
    wp::vec_t<3, wp::float32> var_279;
    wp::vec_t<3, wp::float32> var_280;
    wp::vec_t<3, wp::float32> var_281;
    wp::vec_t<3, wp::float32> var_282;
    wp::int32 var_283;
    Vert_99873389 var_284;
    Vert_99873389 var_285;
    const bool var_286 = true;
    const wp::int32 var_287 = 1;
    wp::int32 var_288;
    wp::vec_t<3, wp::float32>* var_289;
    wp::vec_t<3, wp::float32>* var_290;
    wp::vec_t<3, wp::float32> var_291;
    wp::vec_t<3, wp::float32> var_292;
    wp::vec_t<3, wp::float32> var_293;
    wp::vec_t<3, wp::float32>* var_294;
    wp::vec_t<3, wp::float32>* var_295;
    wp::vec_t<3, wp::float32> var_296;
    wp::vec_t<3, wp::float32> var_297;
    wp::vec_t<3, wp::float32> var_298;
    wp::vec_t<3, wp::float32> var_299;
    wp::float32 var_300;
    wp::float32 var_301;
    bool var_302;
    const bool var_303 = false;
    bool var_304;
    wp::vec_t<3, wp::float32>* var_305;
    wp::float32 var_306;
    wp::vec_t<3, wp::float32> var_307;
    const wp::float32 var_308 = 0.0;
    bool var_309;
    wp::float32 var_310;
    bool var_311;
    Vert_99873389 var_312;
    wp::vec_t<3, wp::float32>* var_313;
    wp::vec_t<3, wp::float32>* var_314;
    wp::vec_t<3, wp::float32> var_315;
    wp::vec_t<3, wp::float32> var_316;
    wp::vec_t<3, wp::float32> var_317;
    wp::float32 var_318;
    wp::vec_t<3, wp::float32>* var_319;
    wp::float32 var_320;
    wp::vec_t<3, wp::float32> var_321;
    bool var_322;
    wp::float32 var_323;
    wp::float32 var_324;
    wp::float32 var_325;
    bool var_326;
    const wp::float32 var_327 = 0.0;
    bool var_328;
    bool var_329;
    const wp::float32 var_330 = 1.0;
    wp::float32 var_331;
    wp::float32 var_332;
    wp::float32 var_333;
    wp::vec_t<3, wp::float32> var_334;
    wp::vec_t<3, wp::float32>* var_335;
    wp::vec_t<3, wp::float32> var_336;
    wp::vec_t<3, wp::float32> var_337;
    wp::float32 var_338;
    wp::float32 var_339;
    wp::vec_t<3, wp::float32>* var_340;
    wp::vec_t<3, wp::float32> var_341;
    wp::vec_t<3, wp::float32> var_342;
    wp::float32 var_343;
    wp::float32 var_344;
    const wp::float32 var_345 = 1.0;
    wp::float32 var_346;
    wp::float32 var_347;
    wp::vec_t<3, wp::float32> var_348;
    wp::vec_t<3, wp::float32> var_349;
    wp::vec_t<3, wp::float32> var_350;
    wp::vec_t<3, wp::float32> var_351;
    wp::vec_t<3, wp::float32> var_352;
    wp::vec_t<3, wp::float32> var_353;
    wp::vec_t<3, wp::float32> var_354;
    wp::vec_t<3, wp::float32> var_355;
    wp::vec_t<3, wp::float32>* var_356;
    wp::vec_t<3, wp::float32> var_357;
    wp::vec_t<3, wp::float32> var_358;
    wp::vec_t<3, wp::float32>* var_359;
    wp::vec_t<3, wp::float32> var_360;
    wp::vec_t<3, wp::float32> var_361;
    wp::vec_t<3, wp::float32> var_362;
    wp::vec_t<3, wp::float32>* var_363;
    wp::vec_t<3, wp::float32> var_364;
    wp::vec_t<3, wp::float32> var_365;
    wp::vec_t<3, wp::float32> var_366;
    wp::float32 var_367;
    wp::vec_t<3, wp::float32> var_368;
    wp::vec_t<3, wp::float32> var_369;
    wp::vec_t<3, wp::float32> var_370;
    wp::vec_t<3, wp::float32> var_371;
    wp::float32 var_372;
    wp::vec_t<3, wp::float32> var_373;
    wp::vec_t<3, wp::float32> var_374;
    wp::vec_t<3, wp::float32> var_375;
    wp::vec_t<3, wp::float32> var_376;
    wp::vec_t<3, wp::float32>* var_377;
    wp::vec_t<3, wp::float32>* var_378;
    wp::vec_t<3, wp::float32> var_379;
    wp::vec_t<3, wp::float32> var_380;
    wp::vec_t<3, wp::float32> var_381;
    wp::vec_t<3, wp::float32>* var_382;
    wp::float32 var_383;
    wp::vec_t<3, wp::float32> var_384;
    const wp::float32 var_385 = 0.0;
    bool var_386;
    wp::vec_t<3, wp::float32>* var_387;
    wp::float32 var_388;
    wp::vec_t<3, wp::float32> var_389;
    const wp::float32 var_390 = 0.0;
    bool var_391;
    Vert_99873389 var_392;
    Vert_99873389 var_393;
    Vert_99873389 var_394;
    Vert_99873389 var_395;
    wp::vec_t<3, wp::float32>* var_396;
    wp::float32 var_397;
    wp::vec_t<3, wp::float32> var_398;
    const wp::float32 var_399 = 0.0;
    bool var_400;
    Vert_99873389 var_401;
    Vert_99873389 var_402;
    Vert_99873389 var_403;
    Vert_99873389 var_404;
    Vert_99873389 var_405;
    Vert_99873389 var_406;
    Vert_99873389 var_407;
    wp::float32 var_408;
    //---------
    // forward
    // def solve_mpr_core(                                                                    <L 1>
    // NUMERIC_EPSILON = 1e-16                                                                <L 37>
    // penetration = float(0.0)                                                               <L 40>
    var_2 = wp::float(var_1);
    // point_a = wp.vec3(0.0, 0.0, 0.0)                                                       <L 41>
    var_6 = wp::vec_t<3, wp::float32>(var_3, var_4, var_5);
    // point_b = wp.vec3(0.0, 0.0, 0.0)                                                       <L 42>
    var_10 = wp::vec_t<3, wp::float32>(var_7, var_8, var_9);
    // normal = wp.vec3(0.0, 0.0, 0.0)                                                        <L 43>
    var_14 = wp::vec_t<3, wp::float32>(var_11, var_12, var_13);
    // v0 = geometric_center(geom_a, geom_b, orientation_b, position_b, data_provider)        <L 46>
    var_15 = create_support_map_function__locals__geometric_center_24(var_geom_a, var_geom_b, var_orientation_b, var_position_b, var_data_provider);
    // normal = v0.BtoA                                                                       <L 48>
    var_16 = &((var_15).BtoA);
    var_18 = wp::load(var_16);
    var_17 = wp::copy(var_18);
    // if wp.length_sq(normal) < NUMERIC_EPSILON:                                             <L 49>
    var_19 = wp::length_sq(var_17);
    var_20 = (var_19 < var_0);
    if (var_20) {
        // used_triangle_fallback = bool(False)                                               <L 50>
        var_22 = bool(var_21);
        // if geom_a.shape_type == int(GeoTypeEx.TRIANGLE) or geom_a.shape_type == int(GeoTypeEx.TRIANGLE_PRISM):       <L 51>
        var_24 = &((var_geom_a).shape_type);
        var_27 = wp::int(var_26);
        var_29 = wp::load(var_24);
        var_28 = (var_29 == var_27);
        var_23 = var_28;
        if (!var_23) {
            var_30 = &((var_geom_a).shape_type);
            var_33 = wp::int(var_32);
            var_35 = wp::load(var_30);
            var_34 = (var_35 == var_33);
            var_23 = var_23 || var_34;
        }
        if (var_23) {
            // tri_a = wp.vec3(0.0, 0.0, 0.0)                                                 <L 52>
            var_39 = wp::vec_t<3, wp::float32>(var_36, var_37, var_38);
            // tri_b = geom_a.scale                                                           <L 53>
            var_40 = &((var_geom_a).scale);
            var_42 = wp::load(var_40);
            var_41 = wp::copy(var_42);
            // tri_c = geom_a.auxiliary                                                       <L 54>
            var_43 = &((var_geom_a).auxiliary);
            var_45 = wp::load(var_43);
            var_44 = wp::copy(var_45);
            // face_normal = wp.cross(tri_b - tri_a, tri_c - tri_a)                           <L 55>
            var_46 = wp::sub(var_41, var_39);
            var_47 = wp::sub(var_44, var_39);
            var_48 = wp::cross(var_46, var_47);
            // face_normal_length_sq = wp.length_sq(face_normal)                              <L 56>
            var_49 = wp::length_sq(var_48);
            // if face_normal_length_sq >= 1.0e-20:                                           <L 57>
            var_51 = (var_49 >= var_50);
            if (var_51) {
                // face_normal = face_normal / wp.sqrt(face_normal_length_sq)                 <L 58>
                var_52 = wp::sqrt(var_49);
                var_53 = wp::div(var_48, var_52);
                // proj = closest_point_on_triangle(v0.B, tri_a, tri_b, tri_c)                <L 59>
                var_54 = &((var_15).B);
                var_56 = wp::load(var_54);
                var_55 = closest_point_on_triangle_0(var_56, var_39, var_41, var_44);
                // centroid = (tri_a + tri_b + tri_c) / 3.0                                   <L 60>
                var_57 = wp::add(var_39, var_41);
                var_58 = wp::add(var_57, var_44);
                var_60 = wp::div(var_58, var_59);
                // to_centroid = centroid - proj                                              <L 61>
                var_61 = wp::sub(var_60, var_55);
                // to_centroid -= wp.dot(to_centroid, face_normal) * face_normal              <L 62>
                var_62 = wp::dot(var_61, var_53);
                var_63 = wp::mul(var_62, var_53);
                var_64 = wp::sub(var_61, var_63);
                // to_centroid_length_sq = wp.length_sq(to_centroid)                          <L 63>
                var_65 = wp::length_sq(var_64);
                // fallback_dir = -face_normal                                                <L 67>
                var_66 = wp::neg(var_53);
                // if wp.dot(v0.B - proj, face_normal) < 0.0:                                 <L 68>
                var_67 = &((var_15).B);
                var_69 = wp::load(var_67);
                var_68 = wp::sub(var_69, var_55);
                var_70 = wp::dot(var_68, var_53);
                var_72 = (var_70 < var_71);
                if (var_72) {
                    // fallback_dir = face_normal                                             <L 69>
                    var_73 = wp::copy(var_53);
                }
                var_74 = wp::where(var_72, var_73, var_66);
                // if to_centroid_length_sq > 1.0e-20:                                        <L 70>
                var_76 = (var_65 > var_75);
                if (var_76) {
                    // fallback_dir += 0.01 * to_centroid / wp.sqrt(to_centroid_length_sq)       <L 71>
                    var_78 = wp::mul(var_77, var_64);
                    var_79 = wp::sqrt(var_65);
                    var_80 = wp::div(var_78, var_79);
                    var_81 = wp::add(var_74, var_80);
                }
                var_82 = wp::where(var_76, var_81, var_74);
                // v0.BtoA = wp.normalize(fallback_dir) * 1.0e-5                              <L 72>
                var_83 = wp::normalize(var_82);
                var_85 = wp::mul(var_83, var_84);
                var_15.BtoA = var_85;
                // used_triangle_fallback = True                                              <L 73>
            }
            var_87 = wp::where(var_51, var_86, var_22);
            var_88 = wp::where(var_51, var_53, var_48);
        }
        var_89 = wp::where(var_23, var_87, var_22);
        // if not used_triangle_fallback:                                                     <L 75>
        var_90 = wp::unot(var_89);
        if (var_90) {
            // best_dot = float(-1.0e30)                                                      <L 77>
            var_92 = wp::float(var_91);
            // best_dir = wp.vec3(1.0, 0.0, 0.0)                                              <L 78>
            var_96 = wp::vec_t<3, wp::float32>(var_93, var_94, var_95);
            // for axis_idx in range(3):                                                      <L 79>
            // probe = wp.vec3(0.0, 0.0, 0.0)                                                 <L 80>
            var_101 = wp::vec_t<3, wp::float32>(var_98, var_99, var_100);
            // probe[axis_idx] = 1.0                                                          <L 81>
            wp::assign_inplace(var_101, var_97, var_102);
            // sv = mpr_support(geom_a, geom_b, probe, orientation_b, position_b, extend, data_provider)       <L 82>
            var_103 = create_support_map_function__locals__minkowski_support_25(var_geom_a, var_geom_b, var_101, var_orientation_b, var_position_b, var_extend, var_data_provider);
            // d = wp.dot(sv.BtoA, probe)                                                     <L 83>
            var_104 = &((var_103).BtoA);
            var_106 = wp::load(var_104);
            var_105 = wp::dot(var_106, var_101);
            // if d > best_dot:                                                               <L 84>
            var_107 = (var_105 > var_92);
            if (var_107) {
                // best_dot = d                                                               <L 85>
                var_108 = wp::copy(var_105);
                // best_dir = probe                                                           <L 86>
                var_109 = wp::copy(var_101);
            }
            var_110 = wp::where(var_107, var_108, var_92);
            var_111 = wp::where(var_107, var_109, var_96);
            // probe = wp.vec3(0.0, 0.0, 0.0)                                                 <L 80>
            var_116 = wp::vec_t<3, wp::float32>(var_113, var_114, var_115);
            // probe[axis_idx] = 1.0                                                          <L 81>
            wp::assign_inplace(var_116, var_112, var_117);
            // sv = mpr_support(geom_a, geom_b, probe, orientation_b, position_b, extend, data_provider)       <L 82>
            var_118 = create_support_map_function__locals__minkowski_support_25(var_geom_a, var_geom_b, var_116, var_orientation_b, var_position_b, var_extend, var_data_provider);
            // d = wp.dot(sv.BtoA, probe)                                                     <L 83>
            var_119 = &((var_118).BtoA);
            var_121 = wp::load(var_119);
            var_120 = wp::dot(var_121, var_116);
            // if d > best_dot:                                                               <L 84>
            var_122 = (var_120 > var_110);
            if (var_122) {
                // best_dot = d                                                               <L 85>
                var_123 = wp::copy(var_120);
                // best_dir = probe                                                           <L 86>
                var_124 = wp::copy(var_116);
            }
            var_125 = wp::where(var_122, var_123, var_110);
            var_126 = wp::where(var_122, var_124, var_111);
            // probe = wp.vec3(0.0, 0.0, 0.0)                                                 <L 80>
            var_131 = wp::vec_t<3, wp::float32>(var_128, var_129, var_130);
            // probe[axis_idx] = 1.0                                                          <L 81>
            wp::assign_inplace(var_131, var_127, var_132);
            // sv = mpr_support(geom_a, geom_b, probe, orientation_b, position_b, extend, data_provider)       <L 82>
            var_133 = create_support_map_function__locals__minkowski_support_25(var_geom_a, var_geom_b, var_131, var_orientation_b, var_position_b, var_extend, var_data_provider);
            // d = wp.dot(sv.BtoA, probe)                                                     <L 83>
            var_134 = &((var_133).BtoA);
            var_136 = wp::load(var_134);
            var_135 = wp::dot(var_136, var_131);
            // if d > best_dot:                                                               <L 84>
            var_137 = (var_135 > var_125);
            if (var_137) {
                // best_dot = d                                                               <L 85>
                var_138 = wp::copy(var_135);
                // best_dir = probe                                                           <L 86>
                var_139 = wp::copy(var_131);
            }
            var_140 = wp::where(var_137, var_138, var_125);
            var_141 = wp::where(var_137, var_139, var_126);
            // v0.BtoA = best_dir * 1e-05                                                     <L 87>
            var_143 = wp::mul(var_141, var_142);
            var_15.BtoA = var_143;
        }
    }
    // normal = -v0.BtoA                                                                      <L 89>
    var_144 = &((var_15).BtoA);
    var_146 = wp::load(var_144);
    var_145 = wp::neg(var_146);
    // v1 = mpr_support(geom_a, geom_b, normal, orientation_b, position_b, extend, data_provider)       <L 92>
    var_147 = create_support_map_function__locals__minkowski_support_25(var_geom_a, var_geom_b, var_145, var_orientation_b, var_position_b, var_extend, var_data_provider);
    // point_a = vert_a(v1)                                                                   <L 94>
    var_148 = vert_a_0(var_147);
    // point_b = v1.B                                                                         <L 95>
    var_149 = &((var_147).B);
    var_151 = wp::load(var_149);
    var_150 = wp::copy(var_151);
    // if wp.dot(v1.BtoA, normal) <= 0.0:                                                     <L 97>
    var_152 = &((var_147).BtoA);
    var_154 = wp::load(var_152);
    var_153 = wp::dot(var_154, var_145);
    var_156 = (var_153 <= var_155);
    if (var_156) {
        // return False, point_a, point_b, normal, penetration                                <L 98>
        ret_0 = var_157;
        ret_1 = var_148;
        ret_2 = var_150;
        ret_3 = var_145;
        ret_4 = var_2;
        return;
    }
    // normal = wp.cross(v1.BtoA, v0.BtoA)                                                    <L 100>
    var_158 = &((var_147).BtoA);
    var_159 = &((var_15).BtoA);
    var_161 = wp::load(var_158);
    var_162 = wp::load(var_159);
    var_160 = wp::cross(var_161, var_162);
    // if wp.length_sq(normal) < NUMERIC_EPSILON * NUMERIC_EPSILON:                           <L 102>
    var_163 = wp::length_sq(var_160);
    var_164 = wp::mul(var_0, var_0);
    var_165 = (var_163 < var_164);
    if (var_165) {
        // normal = v1.BtoA - v0.BtoA                                                         <L 103>
        var_166 = &((var_147).BtoA);
        var_167 = &((var_15).BtoA);
        var_169 = wp::load(var_166);
        var_170 = wp::load(var_167);
        var_168 = wp::sub(var_169, var_170);
        // normal = wp.normalize(normal)                                                      <L 104>
        var_171 = wp::normalize(var_168);
        // temp1 = v1.BtoA                                                                    <L 106>
        var_172 = &((var_147).BtoA);
        var_174 = wp::load(var_172);
        var_173 = wp::copy(var_174);
        // penetration = wp.dot(temp1, normal)                                                <L 107>
        var_175 = wp::dot(var_173, var_171);
        // return True, point_a, point_b, normal, penetration                                 <L 109>
        ret_0 = var_176;
        ret_1 = var_148;
        ret_2 = var_150;
        ret_3 = var_171;
        ret_4 = var_175;
        return;
    }
    var_177 = wp::where(var_165, var_175, var_2);
    var_178 = wp::where(var_165, var_171, var_160);
    // v2 = mpr_support(geom_a, geom_b, normal, orientation_b, position_b, extend, data_provider)       <L 112>
    var_179 = create_support_map_function__locals__minkowski_support_25(var_geom_a, var_geom_b, var_178, var_orientation_b, var_position_b, var_extend, var_data_provider);
    // if wp.dot(v2.BtoA, normal) <= 0.0:                                                     <L 114>
    var_180 = &((var_179).BtoA);
    var_182 = wp::load(var_180);
    var_181 = wp::dot(var_182, var_178);
    var_184 = (var_181 <= var_183);
    if (var_184) {
        // return False, point_a, point_b, normal, penetration                                <L 115>
        ret_0 = var_185;
        ret_1 = var_148;
        ret_2 = var_150;
        ret_3 = var_178;
        ret_4 = var_177;
        return;
    }
    // temp1 = v1.BtoA - v0.BtoA                                                              <L 118>
    var_186 = &((var_147).BtoA);
    var_187 = &((var_15).BtoA);
    var_189 = wp::load(var_186);
    var_190 = wp::load(var_187);
    var_188 = wp::sub(var_189, var_190);
    // temp2 = v2.BtoA - v0.BtoA                                                              <L 119>
    var_191 = &((var_179).BtoA);
    var_192 = &((var_15).BtoA);
    var_194 = wp::load(var_191);
    var_195 = wp::load(var_192);
    var_193 = wp::sub(var_194, var_195);
    // normal = wp.cross(temp1, temp2)                                                        <L 120>
    var_196 = wp::cross(var_188, var_193);
    // dist = wp.dot(normal, v0.BtoA)                                                         <L 122>
    var_197 = &((var_15).BtoA);
    var_199 = wp::load(var_197);
    var_198 = wp::dot(var_196, var_199);
    // if dist > 0.0:                                                                         <L 125>
    var_201 = (var_198 > var_200);
    if (var_201) {
        // tmp_b = v1.B                                                                       <L 127>
        var_202 = &((var_147).B);
        var_204 = wp::load(var_202);
        var_203 = wp::copy(var_204);
        // tmp_btoa = v1.BtoA                                                                 <L 128>
        var_205 = &((var_147).BtoA);
        var_207 = wp::load(var_205);
        var_206 = wp::copy(var_207);
        // v1.B = v2.B                                                                        <L 129>
        var_208 = &((var_179).B);
        var_210 = wp::load(var_208);
        var_209 = wp::copy(var_210);
        var_147.B = var_209;
        // v1.BtoA = v2.BtoA                                                                  <L 130>
        var_211 = &((var_179).BtoA);
        var_213 = wp::load(var_211);
        var_212 = wp::copy(var_213);
        var_147.BtoA = var_212;
        // v2.B = tmp_b                                                                       <L 131>
        var_179.B = var_203;
        // v2.BtoA = tmp_btoa                                                                 <L 132>
        var_179.BtoA = var_206;
        // normal = -normal                                                                   <L 133>
        var_214 = wp::neg(var_196);
    }
    var_215 = wp::where(var_201, var_214, var_196);
    // phase1 = int(0)                                                                        <L 135>
    var_217 = wp::int(var_216);
    // phase2 = int(0)                                                                        <L 136>
    var_219 = wp::int(var_218);
    // hit = bool(False)                                                                      <L 137>
    var_221 = bool(var_220);
    // v3 = Vert()                                                                            <L 140>
    var_222 = Vert_99873389();
    // while True:                                                                            <L 141>
    start_while_3:;
    if ((var_223) == false) goto end_while_3;
        // if phase1 > MAX_ITER:                                                              <L 142>
        var_224 = (var_217 > var_MAX_ITER);
        if (var_224) {
            // return False, point_a, point_b, normal, penetration                            <L 143>
            ret_0 = var_225;
            ret_1 = var_148;
            ret_2 = var_150;
            ret_3 = var_215;
            ret_4 = var_177;
            return;
        }
        // phase1 += 1                                                                        <L 145>
        var_227 = wp::add(var_217, var_226);
        // v3 = mpr_support(geom_a, geom_b, normal, orientation_b, position_b, extend, data_provider)       <L 147>
        var_228 = create_support_map_function__locals__minkowski_support_25(var_geom_a, var_geom_b, var_215, var_orientation_b, var_position_b, var_extend, var_data_provider);
        // if wp.dot(v3.BtoA, normal) <= 0.0:                                                 <L 149>
        var_229 = &((var_228).BtoA);
        var_231 = wp::load(var_229);
        var_230 = wp::dot(var_231, var_215);
        var_233 = (var_230 <= var_232);
        if (var_233) {
            // return False, point_a, point_b, normal, penetration                            <L 150>
            ret_0 = var_234;
            ret_1 = var_148;
            ret_2 = var_150;
            ret_3 = var_215;
            ret_4 = var_177;
            return;
        }
        // temp1 = wp.cross(v1.BtoA, v3.BtoA)                                                 <L 153>
        var_235 = &((var_147).BtoA);
        var_236 = &((var_228).BtoA);
        var_238 = wp::load(var_235);
        var_239 = wp::load(var_236);
        var_237 = wp::cross(var_238, var_239);
        // if wp.dot(temp1, v0.BtoA) < 0.0:                                                   <L 154>
        var_240 = &((var_15).BtoA);
        var_242 = wp::load(var_240);
        var_241 = wp::dot(var_237, var_242);
        var_244 = (var_241 < var_243);
        if (var_244) {
            // v2 = v3                                                                        <L 155>
            var_245 = wp::copy(var_228);
            // temp1 = v1.BtoA - v0.BtoA                                                      <L 156>
            var_246 = &((var_147).BtoA);
            var_247 = &((var_15).BtoA);
            var_249 = wp::load(var_246);
            var_250 = wp::load(var_247);
            var_248 = wp::sub(var_249, var_250);
            // temp2 = v3.BtoA - v0.BtoA                                                      <L 157>
            var_251 = &((var_228).BtoA);
            var_252 = &((var_15).BtoA);
            var_254 = wp::load(var_251);
            var_255 = wp::load(var_252);
            var_253 = wp::sub(var_254, var_255);
            // normal = wp.cross(temp1, temp2)                                                <L 158>
            var_256 = wp::cross(var_248, var_253);
            // continue                                                                       <L 159>
            wp::assign(var_215, var_256);
            wp::assign(var_188, var_248);
            wp::assign(var_179, var_245);
            wp::assign(var_193, var_253);
            wp::assign(var_217, var_227);
            wp::assign(var_222, var_228);
            goto start_while_3;
        }
        var_257 = wp::where(var_244, var_188, var_237);
        var_258 = wp::where(var_244, var_217, var_227);
        var_259 = wp::where(var_244, var_222, var_228);
        // temp1 = wp.cross(v3.BtoA, v2.BtoA)                                                 <L 162>
        var_260 = &((var_259).BtoA);
        var_261 = &((var_179).BtoA);
        var_263 = wp::load(var_260);
        var_264 = wp::load(var_261);
        var_262 = wp::cross(var_263, var_264);
        // if wp.dot(temp1, v0.BtoA) < 0.0:                                                   <L 163>
        var_265 = &((var_15).BtoA);
        var_267 = wp::load(var_265);
        var_266 = wp::dot(var_262, var_267);
        var_269 = (var_266 < var_268);
        if (var_269) {
            // v1 = v3                                                                        <L 164>
            var_270 = wp::copy(var_259);
            // temp1 = v3.BtoA - v0.BtoA                                                      <L 165>
            var_271 = &((var_259).BtoA);
            var_272 = &((var_15).BtoA);
            var_274 = wp::load(var_271);
            var_275 = wp::load(var_272);
            var_273 = wp::sub(var_274, var_275);
            // temp2 = v2.BtoA - v0.BtoA                                                      <L 166>
            var_276 = &((var_179).BtoA);
            var_277 = &((var_15).BtoA);
            var_279 = wp::load(var_276);
            var_280 = wp::load(var_277);
            var_278 = wp::sub(var_279, var_280);
            // normal = wp.cross(temp1, temp2)                                                <L 167>
            var_281 = wp::cross(var_273, var_278);
            // continue                                                                       <L 168>
            wp::assign(var_215, var_281);
            wp::assign(var_147, var_270);
            wp::assign(var_188, var_273);
            wp::assign(var_193, var_278);
            wp::assign(var_217, var_258);
            wp::assign(var_222, var_259);
            goto start_while_3;
        }
        var_282 = wp::where(var_269, var_188, var_262);
        var_283 = wp::where(var_269, var_217, var_258);
        var_284 = wp::where(var_269, var_222, var_259);
        // break                                                                              <L 170>
        wp::assign(var_188, var_282);
        wp::assign(var_217, var_283);
        wp::assign(var_222, var_284);
        goto end_while_3;
    goto start_while_3;
    end_while_3:;
    // v4 = Vert()                                                                            <L 173>
    var_285 = Vert_99873389();
    // while True:                                                                            <L 174>
    start_while_7:;
    if ((var_286) == false) goto end_while_7;
        // phase2 += 1                                                                        <L 175>
        var_288 = wp::add(var_219, var_287);
        // temp1 = v2.BtoA - v1.BtoA                                                          <L 178>
        var_289 = &((var_179).BtoA);
        var_290 = &((var_147).BtoA);
        var_292 = wp::load(var_289);
        var_293 = wp::load(var_290);
        var_291 = wp::sub(var_292, var_293);
        // temp2 = v3.BtoA - v1.BtoA                                                          <L 179>
        var_294 = &((var_222).BtoA);
        var_295 = &((var_147).BtoA);
        var_297 = wp::load(var_294);
        var_298 = wp::load(var_295);
        var_296 = wp::sub(var_297, var_298);
        // normal = wp.cross(temp1, temp2)                                                    <L 180>
        var_299 = wp::cross(var_291, var_296);
        // normal_sq = wp.length_sq(normal)                                                   <L 182>
        var_300 = wp::length_sq(var_299);
        // if normal_sq < NUMERIC_EPSILON * NUMERIC_EPSILON:                                  <L 185>
        var_301 = wp::mul(var_0, var_0);
        var_302 = (var_300 < var_301);
        if (var_302) {
            // return False, point_a, point_b, normal, penetration                            <L 186>
            ret_0 = var_303;
            ret_1 = var_148;
            ret_2 = var_150;
            ret_3 = var_299;
            ret_4 = var_177;
            return;
        }
        // if not hit:                                                                        <L 188>
        var_304 = wp::unot(var_221);
        if (var_304) {
            // d = wp.dot(normal, v1.BtoA)                                                    <L 190>
            var_305 = &((var_147).BtoA);
            var_307 = wp::load(var_305);
            var_306 = wp::dot(var_299, var_307);
            // hit = d >= 0.0                                                                 <L 192>
            var_309 = (var_306 >= var_308);
        }
        var_310 = wp::where(var_304, var_306, var_135);
        var_311 = wp::where(var_304, var_309, var_221);
        // v4 = mpr_support(geom_a, geom_b, normal, orientation_b, position_b, extend, data_provider)       <L 194>
        var_312 = create_support_map_function__locals__minkowski_support_25(var_geom_a, var_geom_b, var_299, var_orientation_b, var_position_b, var_extend, var_data_provider);
        // temp3 = v4.BtoA - v3.BtoA                                                          <L 196>
        var_313 = &((var_312).BtoA);
        var_314 = &((var_222).BtoA);
        var_316 = wp::load(var_313);
        var_317 = wp::load(var_314);
        var_315 = wp::sub(var_316, var_317);
        // delta = wp.dot(temp3, normal)                                                      <L 197>
        var_318 = wp::dot(var_315, var_299);
        // penetration = wp.dot(v4.BtoA, normal)                                              <L 198>
        var_319 = &((var_312).BtoA);
        var_321 = wp::load(var_319);
        var_320 = wp::dot(var_321, var_299);
        // if (                                                                               <L 201>
        // delta * delta <= COLLIDE_EPSILON * COLLIDE_EPSILON * normal_sq                     <L 202>
        var_323 = wp::mul(var_318, var_318);
        var_324 = wp::mul(var_COLLIDE_EPSILON, var_COLLIDE_EPSILON);
        var_325 = wp::mul(var_324, var_300);
        var_326 = (var_323 <= var_325);
        var_322 = var_326;
        if (!var_322) {
            // or penetration <= 0.0                                                          <L 203>
            var_328 = (var_320 <= var_327);
            var_322 = var_322 || var_328;
        }
        if (!var_322) {
            // or phase2 > MAX_ITER                                                           <L 204>
            var_329 = (var_288 > var_MAX_ITER);
            var_322 = var_322 || var_329;
        }
        if (var_322) {
            // if hit:                                                                        <L 206>
            if (var_311) {
                // inv_normal = 1.0 / wp.sqrt(normal_sq)                                      <L 207>
                var_331 = wp::sqrt(var_300);
                var_332 = wp::div(var_330, var_331);
                // penetration *= inv_normal                                                  <L 208>
                var_333 = wp::mul(var_320, var_332);
                // normal = normal * inv_normal                                               <L 209>
                var_334 = wp::mul(var_299, var_332);
                // temp3 = wp.cross(v1.BtoA, temp1)                                           <L 212>
                var_335 = &((var_147).BtoA);
                var_337 = wp::load(var_335);
                var_336 = wp::cross(var_337, var_291);
                // gamma = wp.dot(temp3, normal) * inv_normal                                 <L 213>
                var_338 = wp::dot(var_336, var_334);
                var_339 = wp::mul(var_338, var_332);
                // temp3 = wp.cross(temp2, v1.BtoA)                                           <L 214>
                var_340 = &((var_147).BtoA);
                var_342 = wp::load(var_340);
                var_341 = wp::cross(var_296, var_342);
                // beta = wp.dot(temp3, normal) * inv_normal                                  <L 215>
                var_343 = wp::dot(var_341, var_334);
                var_344 = wp::mul(var_343, var_332);
                // alpha = 1.0 - gamma - beta                                                 <L 216>
                var_346 = wp::sub(var_345, var_339);
                var_347 = wp::sub(var_346, var_344);
                // point_a = alpha * vert_a(v1) + beta * vert_a(v2) + gamma * vert_a(v3)       <L 218>
                var_348 = vert_a_0(var_147);
                var_349 = wp::mul(var_347, var_348);
                var_350 = vert_a_0(var_179);
                var_351 = wp::mul(var_344, var_350);
                var_352 = wp::add(var_349, var_351);
                var_353 = vert_a_0(var_222);
                var_354 = wp::mul(var_339, var_353);
                var_355 = wp::add(var_352, var_354);
                // point_b = alpha * v1.B + beta * v2.B + gamma * v3.B                        <L 219>
                var_356 = &((var_147).B);
                var_358 = wp::load(var_356);
                var_357 = wp::mul(var_347, var_358);
                var_359 = &((var_179).B);
                var_361 = wp::load(var_359);
                var_360 = wp::mul(var_344, var_361);
                var_362 = wp::add(var_357, var_360);
                var_363 = &((var_222).B);
                var_365 = wp::load(var_363);
                var_364 = wp::mul(var_339, var_365);
                var_366 = wp::add(var_362, var_364);
            }
            var_367 = wp::where(var_311, var_333, var_320);
            var_368 = wp::where(var_311, var_355, var_148);
            var_369 = wp::where(var_311, var_366, var_150);
            var_370 = wp::where(var_311, var_334, var_299);
            var_371 = wp::where(var_311, var_341, var_315);
            // return hit, point_a, point_b, normal, penetration                              <L 221>
            ret_0 = var_311;
            ret_1 = var_368;
            ret_2 = var_369;
            ret_3 = var_370;
            ret_4 = var_367;
            return;
        }
        var_372 = wp::where(var_322, var_367, var_320);
        var_373 = wp::where(var_322, var_368, var_148);
        var_374 = wp::where(var_322, var_369, var_150);
        var_375 = wp::where(var_322, var_370, var_299);
        var_376 = wp::where(var_322, var_371, var_315);
        // temp1 = wp.cross(v4.BtoA, v0.BtoA)                                                 <L 224>
        var_377 = &((var_312).BtoA);
        var_378 = &((var_15).BtoA);
        var_380 = wp::load(var_377);
        var_381 = wp::load(var_378);
        var_379 = wp::cross(var_380, var_381);
        // dot = wp.dot(temp1, v1.BtoA)                                                       <L 225>
        var_382 = &((var_147).BtoA);
        var_384 = wp::load(var_382);
        var_383 = wp::dot(var_379, var_384);
        // if dot >= 0.0:                                                                     <L 227>
        var_386 = (var_383 >= var_385);
        if (var_386) {
            // dot = wp.dot(temp1, v2.BtoA)                                                   <L 229>
            var_387 = &((var_179).BtoA);
            var_389 = wp::load(var_387);
            var_388 = wp::dot(var_379, var_389);
            // if dot >= 0.0:                                                                 <L 230>
            var_391 = (var_388 >= var_390);
            if (var_391) {
                // v1 = v4                                                                    <L 231>
                var_392 = wp::copy(var_312);
            }
            if (!var_391) {
                // v3 = v4                                                                    <L 233>
                var_393 = wp::copy(var_312);
            }
            var_394 = wp::where(var_391, var_392, var_147);
            var_395 = wp::where(var_391, var_222, var_393);
        }
        if (!var_386) {
            // dot = wp.dot(temp1, v3.BtoA)                                                   <L 236>
            var_396 = &((var_222).BtoA);
            var_398 = wp::load(var_396);
            var_397 = wp::dot(var_379, var_398);
            // if dot >= 0.0:                                                                 <L 237>
            var_400 = (var_397 >= var_399);
            if (var_400) {
                // v2 = v4                                                                    <L 238>
                var_401 = wp::copy(var_312);
            }
            if (!var_400) {
                // v1 = v4                                                                    <L 240>
                var_402 = wp::copy(var_312);
            }
            var_403 = wp::where(var_400, var_147, var_402);
            var_404 = wp::where(var_400, var_401, var_179);
        }
        var_405 = wp::where(var_386, var_394, var_403);
        var_406 = wp::where(var_386, var_179, var_404);
        var_407 = wp::where(var_386, var_395, var_222);
        var_408 = wp::where(var_386, var_388, var_397);
        wp::assign(var_177, var_372);
        wp::assign(var_148, var_373);
        wp::assign(var_150, var_374);
        wp::assign(var_215, var_375);
        wp::assign(var_135, var_310);
        wp::assign(var_147, var_405);
        wp::assign(var_188, var_379);
        wp::assign(var_179, var_406);
        wp::assign(var_193, var_296);
        wp::assign(var_219, var_288);
        wp::assign(var_221, var_311);
        wp::assign(var_222, var_407);
        wp::assign(var_285, var_312);
    goto start_while_7;
    end_while_7:;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/simplex_solver.py:77
static CUDA_CALLABLE Vert_99873389 create_solve_closest_distance__locals__simplex_get_vertex_12(
    wp::mat_t<8, 3, wp::float32> var_v,
    wp::int32 var_i)
{
    //---------
    // primal vars
    Vert_99873389 var_0;
    const wp::int32 var_1 = 2;
    wp::int32 var_2;
    wp::vec_t<3, wp::float32> var_3;
    const wp::int32 var_4 = 2;
    wp::int32 var_5;
    const wp::int32 var_6 = 1;
    wp::int32 var_7;
    wp::vec_t<3, wp::float32> var_8;
    //---------
    // forward
    // def simplex_get_vertex(v: Mat83f, i: int) -> Vert:                                     <L 78>
    // result = Vert()                                                                        <L 86>
    var_0 = Vert_99873389();
    // result.B = v[2 * i]                                                                    <L 87>
    var_2 = wp::mul(var_1, var_i);
    var_3 = wp::extract(var_v, var_2);
    var_0.B = var_3;
    // result.BtoA = v[2 * i + 1]                                                             <L 88>
    var_5 = wp::mul(var_4, var_i);
    var_7 = wp::add(var_5, var_6);
    var_8 = wp::extract(var_v, var_7);
    var_0.BtoA = var_8;
    // return result                                                                          <L 89>
    return var_0;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/simplex_solver.py:293
static CUDA_CALLABLE void create_solve_closest_distance__locals__simplex_get_closest_12(
    wp::mat_t<8, 3, wp::float32> var_v,
    wp::vec_t<4, wp::float32> var_barycentric,
    wp::uint32 var_usage_mask,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    const wp::float32 var_0 = 0.0;
    const wp::float32 var_1 = 0.0;
    const wp::float32 var_2 = 0.0;
    wp::vec_t<3, wp::float32> var_3;
    const wp::float32 var_4 = 0.0;
    const wp::float32 var_5 = 0.0;
    const wp::float32 var_6 = 0.0;
    wp::vec_t<3, wp::float32> var_7;
    const wp::int32 var_8 = 4;
    wp::range_t var_9;
    wp::int32 var_10;
    const wp::int32 var_11 = 1;
    wp::uint32 var_12;
    wp::uint32 var_13;
    wp::uint32 var_14;
    wp::uint32 var_15;
    const wp::int32 var_16 = 0;
    wp::uint32 var_17;
    bool var_18;
    Vert_99873389 var_19;
    wp::float32 var_20;
    wp::vec_t<3, wp::float32>* var_21;
    wp::vec_t<3, wp::float32>* var_22;
    wp::vec_t<3, wp::float32> var_23;
    wp::vec_t<3, wp::float32> var_24;
    wp::vec_t<3, wp::float32> var_25;
    wp::vec_t<3, wp::float32> var_26;
    wp::vec_t<3, wp::float32> var_27;
    wp::vec_t<3, wp::float32>* var_28;
    wp::vec_t<3, wp::float32> var_29;
    wp::vec_t<3, wp::float32> var_30;
    wp::vec_t<3, wp::float32> var_31;
    //---------
    // forward
    // def simplex_get_closest(v: Mat83f, barycentric: wp.vec4, usage_mask: wp.uint32) -> tuple[wp.vec3, wp.vec3]:       <L 294>
    // point_a = wp.vec3(0.0, 0.0, 0.0)                                                       <L 296>
    var_3 = wp::vec_t<3, wp::float32>(var_0, var_1, var_2);
    // point_b = wp.vec3(0.0, 0.0, 0.0)                                                       <L 297>
    var_7 = wp::vec_t<3, wp::float32>(var_4, var_5, var_6);
    // for i in range(4):                                                                     <L 299>
    var_9 = wp::range(var_8);
    start_for_0:;
        if (iter_cmp(var_9) == 0) goto end_for_0;
        var_10 = wp::iter_next(var_9);
        // if (usage_mask & (wp.uint32(1) << wp.uint32(i))) == wp.uint32(0):                  <L 300>
        var_12 = wp::uint32(var_11);
        var_13 = wp::uint32(var_10);
        var_14 = wp::lshift(var_12, var_13);
        var_15 = wp::bit_and(var_usage_mask, var_14);
        var_17 = wp::uint32(var_16);
        var_18 = (var_15 == var_17);
        if (var_18) {
            // continue                                                                       <L 301>
            goto start_for_0;
        }
        // vertex = simplex_get_vertex(v, i)                                                  <L 303>
        var_19 = create_solve_closest_distance__locals__simplex_get_vertex_12(var_v, var_10);
        // bc_val = barycentric[i]                                                            <L 304>
        var_20 = wp::extract(var_barycentric, var_10);
        // point_a = point_a + bc_val * (vertex.B + vertex.BtoA)                              <L 306>
        var_21 = &((var_19).B);
        var_22 = &((var_19).BtoA);
        var_24 = wp::load(var_21);
        var_25 = wp::load(var_22);
        var_23 = wp::add(var_24, var_25);
        var_26 = wp::mul(var_20, var_23);
        var_27 = wp::add(var_3, var_26);
        // point_b = point_b + bc_val * vertex.B                                              <L 307>
        var_28 = &((var_19).B);
        var_30 = wp::load(var_28);
        var_29 = wp::mul(var_20, var_30);
        var_31 = wp::add(var_7, var_29);
        wp::assign(var_3, var_27);
        wp::assign(var_7, var_31);
        goto start_for_0;
    end_for_0:;
    // return point_a, point_b                                                                <L 309>
    ret_0 = var_3;
    ret_1 = var_7;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/mpr.py:0
static CUDA_CALLABLE wp::vec_t<3, wp::float32> create_support_map_function__locals__support_map_b_24(
    GenericShapeData_ceaba563 var_geom_b,
    wp::vec_t<3, wp::float32> var_direction,
    wp::quat_t<wp::float32> var_orientation_b,
    wp::vec_t<3, wp::float32> var_position_b,
    SupportMapDataProvider_e77f8b9f var_data_provider)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    //---------
    // forward
    // def support_map_b(                                                                     <L 1>
    // tmp = wp.quat_rotate_inv(orientation_b, direction)                                     <L 22>
    var_0 = wp::quat_rotate_inv(var_orientation_b, var_direction);
    // result = support_func(geom_b, tmp, data_provider)                                      <L 25>
    var_1 = support_map_0(var_geom_b, var_0, var_data_provider);
    // result = wp.quat_rotate(orientation_b, result)                                         <L 28>
    var_2 = wp::quat_rotate(var_orientation_b, var_1);
    // result = result + position_b                                                           <L 29>
    var_3 = wp::add(var_2, var_position_b);
    // return result                                                                          <L 31>
    return var_3;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/mpr.py:0
static CUDA_CALLABLE Vert_99873389 create_support_map_function__locals__minkowski_support_24(
    GenericShapeData_ceaba563 var_geom_a,
    GenericShapeData_ceaba563 var_geom_b,
    wp::vec_t<3, wp::float32> var_direction,
    wp::quat_t<wp::float32> var_orientation_b,
    wp::vec_t<3, wp::float32> var_position_b,
    wp::float32 var_extend,
    SupportMapDataProvider_e77f8b9f var_data_provider)
{
    //---------
    // primal vars
    Vert_99873389 var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    const wp::float32 var_4 = 0.0;
    bool var_5;
    wp::vec_t<3, wp::float32> var_6;
    wp::vec_t<3, wp::float32> var_7;
    const wp::float32 var_8 = 0.5;
    wp::vec_t<3, wp::float32> var_9;
    wp::vec_t<3, wp::float32> var_10;
    wp::vec_t<3, wp::float32>* var_11;
    wp::vec_t<3, wp::float32> var_12;
    wp::vec_t<3, wp::float32> var_13;
    wp::vec_t<3, wp::float32> var_14;
    wp::vec_t<3, wp::float32>* var_15;
    wp::vec_t<3, wp::float32> var_16;
    wp::vec_t<3, wp::float32> var_17;
    //---------
    // forward
    // def minkowski_support(                                                                 <L 1>
    // v = Vert()                                                                             <L 25>
    var_0 = Vert_99873389();
    // point_a = support_func(geom_a, direction, data_provider)                               <L 28>
    var_1 = support_map_0(var_geom_a, var_direction, var_data_provider);
    // tmp_direction = -direction                                                             <L 31>
    var_2 = wp::neg(var_direction);
    // v.B = support_map_b(geom_b, tmp_direction, orientation_b, position_b, data_provider)       <L 32>
    var_3 = create_support_map_function__locals__support_map_b_24(var_geom_b, var_2, var_orientation_b, var_position_b, var_data_provider);
    var_0.B = var_3;
    // if extend != 0.0:                                                                      <L 35>
    var_5 = (var_extend != var_4);
    if (var_5) {
        // d = wp.normalize(direction) * extend * 0.5                                         <L 36>
        var_6 = wp::normalize(var_direction);
        var_7 = wp::mul(var_6, var_extend);
        var_9 = wp::mul(var_7, var_8);
        // point_a = point_a + d                                                              <L 37>
        var_10 = wp::add(var_1, var_9);
        // v.B = v.B - d                                                                      <L 38>
        var_11 = &((var_0).B);
        var_13 = wp::load(var_11);
        var_12 = wp::sub(var_13, var_9);
        var_0.B = var_12;
    }
    var_14 = wp::where(var_5, var_10, var_1);
    // v.BtoA = point_a - v.B                                                                 <L 41>
    var_15 = &((var_0).B);
    var_17 = wp::load(var_15);
    var_16 = wp::sub(var_14, var_17);
    var_0.BtoA = var_16;
    // return v                                                                               <L 43>
    return var_0;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/simplex_solver.py:91
static CUDA_CALLABLE void create_solve_closest_distance__locals__closest_segment_12(
    wp::mat_t<8, 3, wp::float32> var_v,
    wp::int32 var_i0,
    wp::int32 var_i1,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<4, wp::float32> & ret_1,
    wp::uint32 & ret_2)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 2;
    wp::int32 var_1;
    const wp::int32 var_2 = 1;
    wp::int32 var_3;
    wp::vec_t<3, wp::float32> var_4;
    const wp::int32 var_5 = 2;
    wp::int32 var_6;
    const wp::int32 var_7 = 1;
    wp::int32 var_8;
    wp::vec_t<3, wp::float32> var_9;
    wp::vec_t<3, wp::float32> var_10;
    wp::float32 var_11;
    const wp::float32 var_12 = 1e-08;
    bool var_13;
    wp::float32 var_14;
    wp::float32 var_15;
    wp::float32 var_16;
    wp::float32 var_17;
    wp::float32 var_18;
    wp::float32 var_19;
    const wp::float32 var_20 = 1.0;
    wp::float32 var_21;
    wp::float32 var_22;
    const wp::int32 var_23 = 1;
    wp::uint32 var_24;
    wp::uint32 var_25;
    wp::uint32 var_26;
    const wp::int32 var_27 = 1;
    wp::uint32 var_28;
    wp::uint32 var_29;
    wp::uint32 var_30;
    wp::uint32 var_31;
    const wp::float32 var_32 = 0.0;
    const wp::float32 var_33 = 0.0;
    const wp::float32 var_34 = 0.0;
    const wp::float32 var_35 = 0.0;
    wp::vec_t<4, wp::float32> var_36;
    bool var_37;
    const wp::float32 var_38 = 0.0;
    bool var_39;
    const wp::int32 var_40 = 1;
    wp::uint32 var_41;
    wp::uint32 var_42;
    wp::uint32 var_43;
    const wp::float32 var_44 = 0.0;
    const wp::float32 var_45 = 1.0;
    const wp::float32 var_46 = 0.0;
    bool var_47;
    const wp::int32 var_48 = 1;
    wp::uint32 var_49;
    wp::uint32 var_50;
    wp::uint32 var_51;
    const wp::float32 var_52 = 1.0;
    const wp::float32 var_53 = 0.0;
    wp::float32 var_54;
    wp::float32 var_55;
    wp::uint32 var_56;
    wp::float32 var_57;
    wp::float32 var_58;
    wp::uint32 var_59;
    wp::vec_t<3, wp::float32> var_60;
    wp::vec_t<3, wp::float32> var_61;
    wp::vec_t<3, wp::float32> var_62;
    //---------
    // forward
    // def closest_segment(                                                                   <L 92>
    // a = v[2 * i0 + 1]                                                                      <L 100>
    var_1 = wp::mul(var_0, var_i0);
    var_3 = wp::add(var_1, var_2);
    var_4 = wp::extract(var_v, var_3);
    // b = v[2 * i1 + 1]                                                                      <L 101>
    var_6 = wp::mul(var_5, var_i1);
    var_8 = wp::add(var_6, var_7);
    var_9 = wp::extract(var_v, var_8);
    // edge = b - a                                                                           <L 103>
    var_10 = wp::sub(var_9, var_4);
    // vsq = wp.length_sq(edge)                                                               <L 104>
    var_11 = wp::length_sq(var_10);
    // degenerate = vsq < EPSILON                                                             <L 106>
    var_13 = (var_11 < var_12);
    // denom = vsq                                                                            <L 109>
    var_14 = wp::copy(var_11);
    // if degenerate:                                                                         <L 110>
    if (var_13) {
        // denom = EPSILON                                                                    <L 111>
        var_15 = wp::copy(var_12);
    }
    var_16 = wp::where(var_13, var_15, var_14);
    // t = -wp.dot(a, edge) / denom                                                           <L 112>
    var_17 = wp::dot(var_4, var_10);
    var_18 = wp::neg(var_17);
    var_19 = wp::div(var_18, var_16);
    // lambda0 = 1.0 - t                                                                      <L 113>
    var_21 = wp::sub(var_20, var_19);
    // lambda1 = t                                                                            <L 114>
    var_22 = wp::copy(var_19);
    // mask = (wp.uint32(1) << wp.uint32(i0)) | (wp.uint32(1) << wp.uint32(i1))               <L 116>
    var_24 = wp::uint32(var_23);
    var_25 = wp::uint32(var_i0);
    var_26 = wp::lshift(var_24, var_25);
    var_28 = wp::uint32(var_27);
    var_29 = wp::uint32(var_i1);
    var_30 = wp::lshift(var_28, var_29);
    var_31 = wp::bit_or(var_26, var_30);
    // bc = wp.vec4(0.0, 0.0, 0.0, 0.0)                                                       <L 118>
    var_36 = wp::vec_t<4, wp::float32>(var_32, var_33, var_34, var_35);
    // if lambda0 < 0.0 or degenerate:                                                        <L 120>
    var_39 = (var_21 < var_38);
    var_37 = var_39;
    if (!var_37) {
        var_37 = var_37 || var_13;
    }
    if (var_37) {
        // mask = wp.uint32(1) << wp.uint32(i1)                                               <L 121>
        var_41 = wp::uint32(var_40);
        var_42 = wp::uint32(var_i1);
        var_43 = wp::lshift(var_41, var_42);
        // lambda0 = 0.0                                                                      <L 122>
        // lambda1 = 1.0                                                                      <L 123>
    }
    if (!var_37) {
        // elif lambda1 < 0.0:                                                                <L 124>
        var_47 = (var_22 < var_46);
        if (var_47) {
            // mask = wp.uint32(1) << wp.uint32(i0)                                           <L 125>
            var_49 = wp::uint32(var_48);
            var_50 = wp::uint32(var_i0);
            var_51 = wp::lshift(var_49, var_50);
            // lambda0 = 1.0                                                                  <L 126>
            // lambda1 = 0.0                                                                  <L 127>
        }
        var_54 = wp::where(var_47, var_52, var_21);
        var_55 = wp::where(var_47, var_53, var_22);
        var_56 = wp::where(var_47, var_51, var_31);
    }
    var_57 = wp::where(var_37, var_44, var_54);
    var_58 = wp::where(var_37, var_45, var_55);
    var_59 = wp::where(var_37, var_43, var_56);
    // bc[i0] = lambda0                                                                       <L 129>
    wp::assign_inplace(var_36, var_i0, var_57);
    // bc[i1] = lambda1                                                                       <L 130>
    wp::assign_inplace(var_36, var_i1, var_58);
    // return lambda0 * a + lambda1 * b, bc, mask                                             <L 132>
    var_60 = wp::mul(var_57, var_4);
    var_61 = wp::mul(var_58, var_9);
    var_62 = wp::add(var_60, var_61);
    ret_0 = var_62;
    ret_1 = var_36;
    ret_2 = var_59;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/simplex_solver.py:134
static CUDA_CALLABLE void create_solve_closest_distance__locals__closest_triangle_12(
    wp::mat_t<8, 3, wp::float32> var_v,
    wp::int32 var_i0,
    wp::int32 var_i1,
    wp::int32 var_i2,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<4, wp::float32> & ret_1,
    wp::uint32 & ret_2)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 2;
    wp::int32 var_1;
    const wp::int32 var_2 = 1;
    wp::int32 var_3;
    wp::vec_t<3, wp::float32> var_4;
    const wp::int32 var_5 = 2;
    wp::int32 var_6;
    const wp::int32 var_7 = 1;
    wp::int32 var_8;
    wp::vec_t<3, wp::float32> var_9;
    const wp::int32 var_10 = 2;
    wp::int32 var_11;
    const wp::int32 var_12 = 1;
    wp::int32 var_13;
    wp::vec_t<3, wp::float32> var_14;
    wp::vec_t<3, wp::float32> var_15;
    wp::vec_t<3, wp::float32> var_16;
    wp::vec_t<3, wp::float32> var_17;
    wp::float32 var_18;
    const wp::float32 var_19 = 1e-08;
    bool var_20;
    wp::float32 var_21;
    wp::float32 var_22;
    wp::float32 var_23;
    const wp::float32 var_24 = 1.0;
    wp::float32 var_25;
    wp::vec_t<3, wp::float32> var_26;
    wp::vec_t<3, wp::float32> var_27;
    wp::float32 var_28;
    wp::float32 var_29;
    wp::float32 var_30;
    wp::float32 var_31;
    const wp::float32 var_32 = 1.0;
    wp::float32 var_33;
    wp::float32 var_34;
    const wp::float32 var_35 = 1e+30;
    const wp::float32 var_36 = 0.0;
    const wp::float32 var_37 = 0.0;
    const wp::float32 var_38 = 0.0;
    wp::vec_t<3, wp::float32> var_39;
    const wp::float32 var_40 = 0.0;
    const wp::float32 var_41 = 0.0;
    const wp::float32 var_42 = 0.0;
    const wp::float32 var_43 = 0.0;
    wp::vec_t<4, wp::float32> var_44;
    const wp::int32 var_45 = 0;
    wp::uint32 var_46;
    bool var_47;
    const wp::float32 var_48 = 0.0;
    bool var_49;
    wp::vec_t<3, wp::float32> var_50;
    wp::vec_t<4, wp::float32> var_51;
    wp::uint32 var_52;
    wp::float32 var_53;
    bool var_54;
    wp::vec_t<4, wp::float32> var_55;
    wp::uint32 var_56;
    wp::float32 var_57;
    wp::vec_t<3, wp::float32> var_58;
    wp::float32 var_59;
    wp::vec_t<3, wp::float32> var_60;
    wp::vec_t<4, wp::float32> var_61;
    wp::uint32 var_62;
    wp::float32 var_63;
    wp::vec_t<3, wp::float32> var_64;
    wp::vec_t<4, wp::float32> var_65;
    wp::uint32 var_66;
    bool var_67;
    const wp::float32 var_68 = 0.0;
    bool var_69;
    wp::vec_t<3, wp::float32> var_70;
    wp::vec_t<4, wp::float32> var_71;
    wp::uint32 var_72;
    wp::float32 var_73;
    bool var_74;
    wp::vec_t<4, wp::float32> var_75;
    wp::uint32 var_76;
    wp::float32 var_77;
    wp::vec_t<3, wp::float32> var_78;
    wp::float32 var_79;
    wp::vec_t<3, wp::float32> var_80;
    wp::vec_t<4, wp::float32> var_81;
    wp::uint32 var_82;
    wp::float32 var_83;
    wp::vec_t<3, wp::float32> var_84;
    wp::vec_t<4, wp::float32> var_85;
    wp::uint32 var_86;
    wp::vec_t<3, wp::float32> var_87;
    wp::vec_t<4, wp::float32> var_88;
    wp::uint32 var_89;
    wp::float32 var_90;
    bool var_91;
    const wp::float32 var_92 = 0.0;
    bool var_93;
    wp::vec_t<3, wp::float32> var_94;
    wp::vec_t<4, wp::float32> var_95;
    wp::uint32 var_96;
    wp::float32 var_97;
    bool var_98;
    wp::vec_t<4, wp::float32> var_99;
    wp::uint32 var_100;
    wp::vec_t<3, wp::float32> var_101;
    wp::vec_t<3, wp::float32> var_102;
    wp::vec_t<4, wp::float32> var_103;
    wp::uint32 var_104;
    wp::vec_t<3, wp::float32> var_105;
    wp::vec_t<4, wp::float32> var_106;
    wp::uint32 var_107;
    wp::vec_t<3, wp::float32> var_108;
    wp::vec_t<4, wp::float32> var_109;
    wp::uint32 var_110;
    wp::float32 var_111;
    const wp::int32 var_112 = 0;
    wp::uint32 var_113;
    bool var_114;
    const wp::int32 var_115 = 1;
    wp::uint32 var_116;
    wp::uint32 var_117;
    wp::uint32 var_118;
    const wp::int32 var_119 = 1;
    wp::uint32 var_120;
    wp::uint32 var_121;
    wp::uint32 var_122;
    wp::uint32 var_123;
    const wp::int32 var_124 = 1;
    wp::uint32 var_125;
    wp::uint32 var_126;
    wp::uint32 var_127;
    wp::uint32 var_128;
    wp::vec_t<3, wp::float32> var_129;
    wp::vec_t<3, wp::float32> var_130;
    wp::vec_t<3, wp::float32> var_131;
    wp::vec_t<3, wp::float32> var_132;
    wp::vec_t<3, wp::float32> var_133;
    //---------
    // forward
    // def closest_triangle(                                                                  <L 135>
    // a = v[2 * i0 + 1]                                                                      <L 144>
    var_1 = wp::mul(var_0, var_i0);
    var_3 = wp::add(var_1, var_2);
    var_4 = wp::extract(var_v, var_3);
    // b = v[2 * i1 + 1]                                                                      <L 145>
    var_6 = wp::mul(var_5, var_i1);
    var_8 = wp::add(var_6, var_7);
    var_9 = wp::extract(var_v, var_8);
    // c = v[2 * i2 + 1]                                                                      <L 146>
    var_11 = wp::mul(var_10, var_i2);
    var_13 = wp::add(var_11, var_12);
    var_14 = wp::extract(var_v, var_13);
    // u = a - b                                                                              <L 148>
    var_15 = wp::sub(var_4, var_9);
    // w = a - c                                                                              <L 149>
    var_16 = wp::sub(var_4, var_14);
    // normal = wp.cross(u, w)                                                                <L 151>
    var_17 = wp::cross(var_15, var_16);
    // t = wp.length_sq(normal)                                                               <L 153>
    var_18 = wp::length_sq(var_17);
    // degenerate = t < EPSILON                                                               <L 154>
    var_20 = (var_18 < var_19);
    // denom = t                                                                              <L 156>
    var_21 = wp::copy(var_18);
    // if degenerate:                                                                         <L 157>
    if (var_20) {
        // denom = EPSILON                                                                    <L 158>
        var_22 = wp::copy(var_19);
    }
    var_23 = wp::where(var_20, var_22, var_21);
    // it = 1.0 / denom                                                                       <L 159>
    var_25 = wp::div(var_24, var_23);
    // c1 = wp.cross(u, a)                                                                    <L 161>
    var_26 = wp::cross(var_15, var_4);
    // c2 = wp.cross(a, w)                                                                    <L 162>
    var_27 = wp::cross(var_4, var_16);
    // lambda2 = wp.dot(c1, normal) * it                                                      <L 164>
    var_28 = wp::dot(var_26, var_17);
    var_29 = wp::mul(var_28, var_25);
    // lambda1 = wp.dot(c2, normal) * it                                                      <L 165>
    var_30 = wp::dot(var_27, var_17);
    var_31 = wp::mul(var_30, var_25);
    // lambda0 = 1.0 - lambda2 - lambda1                                                      <L 166>
    var_33 = wp::sub(var_32, var_29);
    var_34 = wp::sub(var_33, var_31);
    // best_distance = 1e30  # Large value                                                    <L 168>
    // closest_pt = wp.vec3(0.0, 0.0, 0.0)                                                    <L 169>
    var_39 = wp::vec_t<3, wp::float32>(var_36, var_37, var_38);
    // bc = wp.vec4(0.0, 0.0, 0.0, 0.0)                                                       <L 170>
    var_44 = wp::vec_t<4, wp::float32>(var_40, var_41, var_42, var_43);
    // mask = wp.uint32(0)                                                                    <L 171>
    var_46 = wp::uint32(var_45);
    // if lambda0 < 0.0 or degenerate:                                                        <L 174>
    var_49 = (var_34 < var_48);
    var_47 = var_49;
    if (!var_47) {
        var_47 = var_47 || var_20;
    }
    if (var_47) {
        // closest, bc_tmp, m = closest_segment(v, i1, i2)                                    <L 175>
        create_solve_closest_distance__locals__closest_segment_12(var_v, var_i1, var_i2, var_50, var_51, var_52);
        // dist = wp.length_sq(closest)                                                       <L 176>
        var_53 = wp::length_sq(var_50);
        // if dist < best_distance:                                                           <L 177>
        var_54 = (var_53 < var_35);
        if (var_54) {
            // bc = bc_tmp                                                                    <L 178>
            var_55 = wp::copy(var_51);
            // mask = m                                                                       <L 179>
            var_56 = wp::copy(var_52);
            // best_distance = dist                                                           <L 180>
            var_57 = wp::copy(var_53);
            // closest_pt = closest                                                           <L 181>
            var_58 = wp::copy(var_50);
        }
        var_59 = wp::where(var_54, var_57, var_35);
        var_60 = wp::where(var_54, var_58, var_39);
        var_61 = wp::where(var_54, var_55, var_44);
        var_62 = wp::where(var_54, var_56, var_46);
    }
    var_63 = wp::where(var_47, var_59, var_35);
    var_64 = wp::where(var_47, var_60, var_39);
    var_65 = wp::where(var_47, var_61, var_44);
    var_66 = wp::where(var_47, var_62, var_46);
    // if lambda1 < 0.0 or degenerate:                                                        <L 183>
    var_69 = (var_31 < var_68);
    var_67 = var_69;
    if (!var_67) {
        var_67 = var_67 || var_20;
    }
    if (var_67) {
        // closest, bc_tmp, m = closest_segment(v, i0, i2)                                    <L 184>
        create_solve_closest_distance__locals__closest_segment_12(var_v, var_i0, var_i2, var_70, var_71, var_72);
        // dist = wp.length_sq(closest)                                                       <L 185>
        var_73 = wp::length_sq(var_70);
        // if dist < best_distance:                                                           <L 186>
        var_74 = (var_73 < var_63);
        if (var_74) {
            // bc = bc_tmp                                                                    <L 187>
            var_75 = wp::copy(var_71);
            // mask = m                                                                       <L 188>
            var_76 = wp::copy(var_72);
            // best_distance = dist                                                           <L 189>
            var_77 = wp::copy(var_73);
            // closest_pt = closest                                                           <L 190>
            var_78 = wp::copy(var_70);
        }
        var_79 = wp::where(var_74, var_77, var_63);
        var_80 = wp::where(var_74, var_78, var_64);
        var_81 = wp::where(var_74, var_75, var_65);
        var_82 = wp::where(var_74, var_76, var_66);
    }
    var_83 = wp::where(var_67, var_79, var_63);
    var_84 = wp::where(var_67, var_80, var_64);
    var_85 = wp::where(var_67, var_81, var_65);
    var_86 = wp::where(var_67, var_82, var_66);
    var_87 = wp::where(var_67, var_70, var_50);
    var_88 = wp::where(var_67, var_71, var_51);
    var_89 = wp::where(var_67, var_72, var_52);
    var_90 = wp::where(var_67, var_73, var_53);
    // if lambda2 < 0.0 or degenerate:                                                        <L 192>
    var_93 = (var_29 < var_92);
    var_91 = var_93;
    if (!var_91) {
        var_91 = var_91 || var_20;
    }
    if (var_91) {
        // closest, bc_tmp, m = closest_segment(v, i0, i1)                                    <L 193>
        create_solve_closest_distance__locals__closest_segment_12(var_v, var_i0, var_i1, var_94, var_95, var_96);
        // dist = wp.length_sq(closest)                                                       <L 194>
        var_97 = wp::length_sq(var_94);
        // if dist < best_distance:                                                           <L 195>
        var_98 = (var_97 < var_83);
        if (var_98) {
            // bc = bc_tmp                                                                    <L 196>
            var_99 = wp::copy(var_95);
            // mask = m                                                                       <L 197>
            var_100 = wp::copy(var_96);
            // closest_pt = closest                                                           <L 198>
            var_101 = wp::copy(var_94);
        }
        var_102 = wp::where(var_98, var_101, var_84);
        var_103 = wp::where(var_98, var_99, var_85);
        var_104 = wp::where(var_98, var_100, var_86);
    }
    var_105 = wp::where(var_91, var_102, var_84);
    var_106 = wp::where(var_91, var_103, var_85);
    var_107 = wp::where(var_91, var_104, var_86);
    var_108 = wp::where(var_91, var_94, var_87);
    var_109 = wp::where(var_91, var_95, var_88);
    var_110 = wp::where(var_91, var_96, var_89);
    var_111 = wp::where(var_91, var_97, var_90);
    // if mask != wp.uint32(0):                                                               <L 200>
    var_113 = wp::uint32(var_112);
    var_114 = (var_107 != var_113);
    if (var_114) {
        // return closest_pt, bc, mask                                                        <L 201>
        ret_0 = var_105;
        ret_1 = var_106;
        ret_2 = var_107;
        return;
    }
    // bc[i0] = lambda0                                                                       <L 203>
    wp::assign_inplace(var_106, var_i0, var_34);
    // bc[i1] = lambda1                                                                       <L 204>
    wp::assign_inplace(var_106, var_i1, var_31);
    // bc[i2] = lambda2                                                                       <L 205>
    wp::assign_inplace(var_106, var_i2, var_29);
    // mask = (wp.uint32(1) << wp.uint32(i0)) | (wp.uint32(1) << wp.uint32(i1)) | (wp.uint32(1) << wp.uint32(i2))       <L 207>
    var_116 = wp::uint32(var_115);
    var_117 = wp::uint32(var_i0);
    var_118 = wp::lshift(var_116, var_117);
    var_120 = wp::uint32(var_119);
    var_121 = wp::uint32(var_i1);
    var_122 = wp::lshift(var_120, var_121);
    var_123 = wp::bit_or(var_118, var_122);
    var_125 = wp::uint32(var_124);
    var_126 = wp::uint32(var_i2);
    var_127 = wp::lshift(var_125, var_126);
    var_128 = wp::bit_or(var_123, var_127);
    // return lambda0 * a + lambda1 * b + lambda2 * c, bc, mask                               <L 208>
    var_129 = wp::mul(var_34, var_4);
    var_130 = wp::mul(var_31, var_9);
    var_131 = wp::add(var_129, var_130);
    var_132 = wp::mul(var_29, var_14);
    var_133 = wp::add(var_131, var_132);
    ret_0 = var_133;
    ret_1 = var_106;
    ret_2 = var_128;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/simplex_solver.py:210
static CUDA_CALLABLE wp::float32 create_solve_closest_distance__locals__determinant_12(
    wp::vec_t<3, wp::float32> var_a,
    wp::vec_t<3, wp::float32> var_b,
    wp::vec_t<3, wp::float32> var_c,
    wp::vec_t<3, wp::float32> var_d)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    wp::float32 var_4;
    //---------
    // forward
    // def determinant(a: wp.vec3, b: wp.vec3, c: wp.vec3, d: wp.vec3) -> float:              <L 211>
    // return wp.dot(b - a, wp.cross(c - a, d - a))                                           <L 213>
    var_0 = wp::sub(var_b, var_a);
    var_1 = wp::sub(var_c, var_a);
    var_2 = wp::sub(var_d, var_a);
    var_3 = wp::cross(var_1, var_2);
    var_4 = wp::dot(var_0, var_3);
    return var_4;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/simplex_solver.py:215
static CUDA_CALLABLE void create_solve_closest_distance__locals__closest_tetrahedron_12(
    wp::mat_t<8, 3, wp::float32> var_v,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<4, wp::float32> & ret_1,
    wp::uint32 & ret_2)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 2;
    const wp::int32 var_1 = 0;
    wp::int32 var_2;
    const wp::int32 var_3 = 1;
    wp::int32 var_4;
    wp::vec_t<3, wp::float32> var_5;
    const wp::int32 var_6 = 2;
    const wp::int32 var_7 = 1;
    wp::int32 var_8;
    const wp::int32 var_9 = 1;
    wp::int32 var_10;
    wp::vec_t<3, wp::float32> var_11;
    const wp::int32 var_12 = 2;
    const wp::int32 var_13 = 2;
    wp::int32 var_14;
    const wp::int32 var_15 = 1;
    wp::int32 var_16;
    wp::vec_t<3, wp::float32> var_17;
    const wp::int32 var_18 = 2;
    const wp::int32 var_19 = 3;
    wp::int32 var_20;
    const wp::int32 var_21 = 1;
    wp::int32 var_22;
    wp::vec_t<3, wp::float32> var_23;
    wp::float32 var_24;
    wp::float32 var_25;
    const wp::float32 var_26 = 1e-08;
    bool var_27;
    wp::float32 var_28;
    wp::float32 var_29;
    wp::float32 var_30;
    const wp::float32 var_31 = 1.0;
    wp::float32 var_32;
    const wp::float32 var_33 = 0.0;
    const wp::float32 var_34 = 0.0;
    const wp::float32 var_35 = 0.0;
    wp::vec_t<3, wp::float32> var_36;
    wp::float32 var_37;
    wp::float32 var_38;
    wp::float32 var_39;
    wp::float32 var_40;
    wp::float32 var_41;
    wp::float32 var_42;
    const wp::float32 var_43 = 1.0;
    wp::float32 var_44;
    wp::float32 var_45;
    wp::float32 var_46;
    const wp::float32 var_47 = 1e+30;
    const wp::float32 var_48 = 0.0;
    const wp::float32 var_49 = 0.0;
    const wp::float32 var_50 = 0.0;
    wp::vec_t<3, wp::float32> var_51;
    const wp::float32 var_52 = 0.0;
    const wp::float32 var_53 = 0.0;
    const wp::float32 var_54 = 0.0;
    const wp::float32 var_55 = 0.0;
    wp::vec_t<4, wp::float32> var_56;
    const wp::int32 var_57 = 0;
    wp::uint32 var_58;
    bool var_59;
    const wp::float32 var_60 = 0.0;
    bool var_61;
    const wp::int32 var_62 = 1;
    const wp::int32 var_63 = 2;
    const wp::int32 var_64 = 3;
    wp::vec_t<3, wp::float32> var_65;
    wp::vec_t<4, wp::float32> var_66;
    wp::uint32 var_67;
    wp::float32 var_68;
    bool var_69;
    wp::vec_t<4, wp::float32> var_70;
    wp::uint32 var_71;
    wp::float32 var_72;
    wp::vec_t<3, wp::float32> var_73;
    wp::float32 var_74;
    wp::vec_t<3, wp::float32> var_75;
    wp::vec_t<4, wp::float32> var_76;
    wp::uint32 var_77;
    wp::float32 var_78;
    wp::vec_t<3, wp::float32> var_79;
    wp::vec_t<4, wp::float32> var_80;
    wp::uint32 var_81;
    bool var_82;
    const wp::float32 var_83 = 0.0;
    bool var_84;
    const wp::int32 var_85 = 0;
    const wp::int32 var_86 = 2;
    const wp::int32 var_87 = 3;
    wp::vec_t<3, wp::float32> var_88;
    wp::vec_t<4, wp::float32> var_89;
    wp::uint32 var_90;
    wp::float32 var_91;
    bool var_92;
    wp::vec_t<4, wp::float32> var_93;
    wp::uint32 var_94;
    wp::float32 var_95;
    wp::vec_t<3, wp::float32> var_96;
    wp::float32 var_97;
    wp::vec_t<3, wp::float32> var_98;
    wp::vec_t<4, wp::float32> var_99;
    wp::uint32 var_100;
    wp::float32 var_101;
    wp::vec_t<3, wp::float32> var_102;
    wp::vec_t<4, wp::float32> var_103;
    wp::uint32 var_104;
    wp::vec_t<3, wp::float32> var_105;
    wp::vec_t<4, wp::float32> var_106;
    wp::uint32 var_107;
    wp::float32 var_108;
    bool var_109;
    const wp::float32 var_110 = 0.0;
    bool var_111;
    const wp::int32 var_112 = 0;
    const wp::int32 var_113 = 1;
    const wp::int32 var_114 = 3;
    wp::vec_t<3, wp::float32> var_115;
    wp::vec_t<4, wp::float32> var_116;
    wp::uint32 var_117;
    wp::float32 var_118;
    bool var_119;
    wp::vec_t<4, wp::float32> var_120;
    wp::uint32 var_121;
    wp::float32 var_122;
    wp::vec_t<3, wp::float32> var_123;
    wp::float32 var_124;
    wp::vec_t<3, wp::float32> var_125;
    wp::vec_t<4, wp::float32> var_126;
    wp::uint32 var_127;
    wp::float32 var_128;
    wp::vec_t<3, wp::float32> var_129;
    wp::vec_t<4, wp::float32> var_130;
    wp::uint32 var_131;
    wp::vec_t<3, wp::float32> var_132;
    wp::vec_t<4, wp::float32> var_133;
    wp::uint32 var_134;
    wp::float32 var_135;
    bool var_136;
    const wp::float32 var_137 = 0.0;
    bool var_138;
    const wp::int32 var_139 = 0;
    const wp::int32 var_140 = 1;
    const wp::int32 var_141 = 2;
    wp::vec_t<3, wp::float32> var_142;
    wp::vec_t<4, wp::float32> var_143;
    wp::uint32 var_144;
    wp::float32 var_145;
    bool var_146;
    wp::vec_t<4, wp::float32> var_147;
    wp::uint32 var_148;
    wp::vec_t<3, wp::float32> var_149;
    wp::vec_t<3, wp::float32> var_150;
    wp::vec_t<4, wp::float32> var_151;
    wp::uint32 var_152;
    wp::vec_t<3, wp::float32> var_153;
    wp::vec_t<4, wp::float32> var_154;
    wp::uint32 var_155;
    wp::vec_t<3, wp::float32> var_156;
    wp::vec_t<4, wp::float32> var_157;
    wp::uint32 var_158;
    wp::float32 var_159;
    const wp::int32 var_160 = 0;
    wp::uint32 var_161;
    bool var_162;
    const wp::int32 var_163 = 0;
    const wp::int32 var_164 = 1;
    const wp::int32 var_165 = 2;
    const wp::int32 var_166 = 3;
    const wp::int32 var_167 = 15;
    wp::uint32 var_168;
    //---------
    // forward
    // def closest_tetrahedron(                                                               <L 216>
    // v0 = v[2 * 0 + 1]                                                                      <L 222>
    var_2 = wp::mul(var_0, var_1);
    var_4 = wp::add(var_2, var_3);
    var_5 = wp::extract(var_v, var_4);
    // v1 = v[2 * 1 + 1]                                                                      <L 223>
    var_8 = wp::mul(var_6, var_7);
    var_10 = wp::add(var_8, var_9);
    var_11 = wp::extract(var_v, var_10);
    // v2 = v[2 * 2 + 1]                                                                      <L 224>
    var_14 = wp::mul(var_12, var_13);
    var_16 = wp::add(var_14, var_15);
    var_17 = wp::extract(var_v, var_16);
    // v3 = v[2 * 3 + 1]                                                                      <L 225>
    var_20 = wp::mul(var_18, var_19);
    var_22 = wp::add(var_20, var_21);
    var_23 = wp::extract(var_v, var_22);
    // det_t = determinant(v0, v1, v2, v3)                                                    <L 227>
    var_24 = create_solve_closest_distance__locals__determinant_12(var_5, var_11, var_17, var_23);
    // degenerate = wp.abs(det_t) < EPSILON                                                   <L 228>
    var_25 = wp::abs(var_24);
    var_27 = (var_25 < var_26);
    // denom = det_t                                                                          <L 230>
    var_28 = wp::copy(var_24);
    // if degenerate:                                                                         <L 231>
    if (var_27) {
        // denom = EPSILON                                                                    <L 232>
        var_29 = wp::copy(var_26);
    }
    var_30 = wp::where(var_27, var_29, var_28);
    // inverse_det_t = 1.0 / denom                                                            <L 233>
    var_32 = wp::div(var_31, var_30);
    // zero = wp.vec3(0.0, 0.0, 0.0)                                                          <L 235>
    var_36 = wp::vec_t<3, wp::float32>(var_33, var_34, var_35);
    // lambda0 = determinant(zero, v1, v2, v3) * inverse_det_t                                <L 236>
    var_37 = create_solve_closest_distance__locals__determinant_12(var_36, var_11, var_17, var_23);
    var_38 = wp::mul(var_37, var_32);
    // lambda1 = determinant(v0, zero, v2, v3) * inverse_det_t                                <L 237>
    var_39 = create_solve_closest_distance__locals__determinant_12(var_5, var_36, var_17, var_23);
    var_40 = wp::mul(var_39, var_32);
    // lambda2 = determinant(v0, v1, zero, v3) * inverse_det_t                                <L 238>
    var_41 = create_solve_closest_distance__locals__determinant_12(var_5, var_11, var_36, var_23);
    var_42 = wp::mul(var_41, var_32);
    // lambda3 = 1.0 - lambda0 - lambda1 - lambda2                                            <L 239>
    var_44 = wp::sub(var_43, var_38);
    var_45 = wp::sub(var_44, var_40);
    var_46 = wp::sub(var_45, var_42);
    // best_distance = 1e30  # Large value                                                    <L 241>
    // closest_pt = wp.vec3(0.0, 0.0, 0.0)                                                    <L 242>
    var_51 = wp::vec_t<3, wp::float32>(var_48, var_49, var_50);
    // bc = wp.vec4(0.0, 0.0, 0.0, 0.0)                                                       <L 243>
    var_56 = wp::vec_t<4, wp::float32>(var_52, var_53, var_54, var_55);
    // mask = wp.uint32(0)                                                                    <L 244>
    var_58 = wp::uint32(var_57);
    // if lambda0 < 0.0 or degenerate:                                                        <L 247>
    var_61 = (var_38 < var_60);
    var_59 = var_61;
    if (!var_59) {
        var_59 = var_59 || var_27;
    }
    if (var_59) {
        // closest, bc_tmp, m = closest_triangle(v, 1, 2, 3)                                  <L 248>
        create_solve_closest_distance__locals__closest_triangle_12(var_v, var_62, var_63, var_64, var_65, var_66, var_67);
        // dist = wp.length_sq(closest)                                                       <L 249>
        var_68 = wp::length_sq(var_65);
        // if dist < best_distance:                                                           <L 250>
        var_69 = (var_68 < var_47);
        if (var_69) {
            // bc = bc_tmp                                                                    <L 251>
            var_70 = wp::copy(var_66);
            // mask = m                                                                       <L 252>
            var_71 = wp::copy(var_67);
            // best_distance = dist                                                           <L 253>
            var_72 = wp::copy(var_68);
            // closest_pt = closest                                                           <L 254>
            var_73 = wp::copy(var_65);
        }
        var_74 = wp::where(var_69, var_72, var_47);
        var_75 = wp::where(var_69, var_73, var_51);
        var_76 = wp::where(var_69, var_70, var_56);
        var_77 = wp::where(var_69, var_71, var_58);
    }
    var_78 = wp::where(var_59, var_74, var_47);
    var_79 = wp::where(var_59, var_75, var_51);
    var_80 = wp::where(var_59, var_76, var_56);
    var_81 = wp::where(var_59, var_77, var_58);
    // if lambda1 < 0.0 or degenerate:                                                        <L 256>
    var_84 = (var_40 < var_83);
    var_82 = var_84;
    if (!var_82) {
        var_82 = var_82 || var_27;
    }
    if (var_82) {
        // closest, bc_tmp, m = closest_triangle(v, 0, 2, 3)                                  <L 257>
        create_solve_closest_distance__locals__closest_triangle_12(var_v, var_85, var_86, var_87, var_88, var_89, var_90);
        // dist = wp.length_sq(closest)                                                       <L 258>
        var_91 = wp::length_sq(var_88);
        // if dist < best_distance:                                                           <L 259>
        var_92 = (var_91 < var_78);
        if (var_92) {
            // bc = bc_tmp                                                                    <L 260>
            var_93 = wp::copy(var_89);
            // mask = m                                                                       <L 261>
            var_94 = wp::copy(var_90);
            // best_distance = dist                                                           <L 262>
            var_95 = wp::copy(var_91);
            // closest_pt = closest                                                           <L 263>
            var_96 = wp::copy(var_88);
        }
        var_97 = wp::where(var_92, var_95, var_78);
        var_98 = wp::where(var_92, var_96, var_79);
        var_99 = wp::where(var_92, var_93, var_80);
        var_100 = wp::where(var_92, var_94, var_81);
    }
    var_101 = wp::where(var_82, var_97, var_78);
    var_102 = wp::where(var_82, var_98, var_79);
    var_103 = wp::where(var_82, var_99, var_80);
    var_104 = wp::where(var_82, var_100, var_81);
    var_105 = wp::where(var_82, var_88, var_65);
    var_106 = wp::where(var_82, var_89, var_66);
    var_107 = wp::where(var_82, var_90, var_67);
    var_108 = wp::where(var_82, var_91, var_68);
    // if lambda2 < 0.0 or degenerate:                                                        <L 265>
    var_111 = (var_42 < var_110);
    var_109 = var_111;
    if (!var_109) {
        var_109 = var_109 || var_27;
    }
    if (var_109) {
        // closest, bc_tmp, m = closest_triangle(v, 0, 1, 3)                                  <L 266>
        create_solve_closest_distance__locals__closest_triangle_12(var_v, var_112, var_113, var_114, var_115, var_116, var_117);
        // dist = wp.length_sq(closest)                                                       <L 267>
        var_118 = wp::length_sq(var_115);
        // if dist < best_distance:                                                           <L 268>
        var_119 = (var_118 < var_101);
        if (var_119) {
            // bc = bc_tmp                                                                    <L 269>
            var_120 = wp::copy(var_116);
            // mask = m                                                                       <L 270>
            var_121 = wp::copy(var_117);
            // best_distance = dist                                                           <L 271>
            var_122 = wp::copy(var_118);
            // closest_pt = closest                                                           <L 272>
            var_123 = wp::copy(var_115);
        }
        var_124 = wp::where(var_119, var_122, var_101);
        var_125 = wp::where(var_119, var_123, var_102);
        var_126 = wp::where(var_119, var_120, var_103);
        var_127 = wp::where(var_119, var_121, var_104);
    }
    var_128 = wp::where(var_109, var_124, var_101);
    var_129 = wp::where(var_109, var_125, var_102);
    var_130 = wp::where(var_109, var_126, var_103);
    var_131 = wp::where(var_109, var_127, var_104);
    var_132 = wp::where(var_109, var_115, var_105);
    var_133 = wp::where(var_109, var_116, var_106);
    var_134 = wp::where(var_109, var_117, var_107);
    var_135 = wp::where(var_109, var_118, var_108);
    // if lambda3 < 0.0 or degenerate:                                                        <L 274>
    var_138 = (var_46 < var_137);
    var_136 = var_138;
    if (!var_136) {
        var_136 = var_136 || var_27;
    }
    if (var_136) {
        // closest, bc_tmp, m = closest_triangle(v, 0, 1, 2)                                  <L 275>
        create_solve_closest_distance__locals__closest_triangle_12(var_v, var_139, var_140, var_141, var_142, var_143, var_144);
        // dist = wp.length_sq(closest)                                                       <L 276>
        var_145 = wp::length_sq(var_142);
        // if dist < best_distance:                                                           <L 277>
        var_146 = (var_145 < var_128);
        if (var_146) {
            // bc = bc_tmp                                                                    <L 278>
            var_147 = wp::copy(var_143);
            // mask = m                                                                       <L 279>
            var_148 = wp::copy(var_144);
            // closest_pt = closest                                                           <L 280>
            var_149 = wp::copy(var_142);
        }
        var_150 = wp::where(var_146, var_149, var_129);
        var_151 = wp::where(var_146, var_147, var_130);
        var_152 = wp::where(var_146, var_148, var_131);
    }
    var_153 = wp::where(var_136, var_150, var_129);
    var_154 = wp::where(var_136, var_151, var_130);
    var_155 = wp::where(var_136, var_152, var_131);
    var_156 = wp::where(var_136, var_142, var_132);
    var_157 = wp::where(var_136, var_143, var_133);
    var_158 = wp::where(var_136, var_144, var_134);
    var_159 = wp::where(var_136, var_145, var_135);
    // if mask != wp.uint32(0):                                                               <L 282>
    var_161 = wp::uint32(var_160);
    var_162 = (var_155 != var_161);
    if (var_162) {
        // return closest_pt, bc, mask                                                        <L 283>
        ret_0 = var_153;
        ret_1 = var_154;
        ret_2 = var_155;
        return;
    }
    // bc[0] = lambda0                                                                        <L 285>
    wp::assign_inplace(var_154, var_163, var_38);
    // bc[1] = lambda1                                                                        <L 286>
    wp::assign_inplace(var_154, var_164, var_40);
    // bc[2] = lambda2                                                                        <L 287>
    wp::assign_inplace(var_154, var_165, var_42);
    // bc[3] = lambda3                                                                        <L 288>
    wp::assign_inplace(var_154, var_166, var_46);
    // mask = wp.uint32(15)  # 0b1111                                                         <L 290>
    var_168 = wp::uint32(var_167);
    // return zero, bc, mask                                                                  <L 291>
    ret_0 = var_36;
    ret_1 = var_154;
    ret_2 = var_168;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/simplex_solver.py:0
static CUDA_CALLABLE void create_solve_closest_distance__locals__solve_closest_distance_core_12(
    GenericShapeData_ceaba563 var_geom_a,
    GenericShapeData_ceaba563 var_geom_b,
    wp::quat_t<wp::float32> var_orientation_b,
    wp::vec_t<3, wp::float32> var_position_b,
    wp::float32 var_extend,
    SupportMapDataProvider_e77f8b9f var_data_provider,
    wp::int32 var_MAX_ITER,
    wp::float32 var_COLLIDE_EPSILON,
    bool & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & ret_2,
    wp::vec_t<3, wp::float32> & ret_3,
    wp::float32 & ret_4)
{
    //---------
    // primal vars
    const wp::float32 var_0 = 0.0;
    wp::float32 var_1;
    const wp::float32 var_2 = 0.0;
    const wp::float32 var_3 = 0.0;
    const wp::float32 var_4 = 0.0;
    wp::vec_t<3, wp::float32> var_5;
    const wp::float32 var_6 = 0.0;
    const wp::float32 var_7 = 0.0;
    const wp::float32 var_8 = 0.0;
    wp::vec_t<3, wp::float32> var_9;
    const wp::float32 var_10 = 0.0;
    const wp::float32 var_11 = 0.0;
    const wp::float32 var_12 = 0.0;
    wp::vec_t<3, wp::float32> var_13;
    wp::mat_t<8, 3, wp::float32> var_14;
    const wp::float32 var_15 = 0.0;
    const wp::float32 var_16 = 0.0;
    const wp::float32 var_17 = 0.0;
    const wp::float32 var_18 = 0.0;
    wp::vec_t<4, wp::float32> var_19;
    const wp::int32 var_20 = 0;
    wp::uint32 var_21;
    wp::int32 var_22;
    Vert_99873389 var_23;
    wp::vec_t<3, wp::float32>* var_24;
    wp::vec_t<3, wp::float32> var_25;
    wp::vec_t<3, wp::float32> var_26;
    wp::float32 var_27;
    const wp::float32 var_28 = 1.0;
    const wp::float32 var_29 = 0.0;
    const wp::float32 var_30 = 0.0;
    wp::vec_t<3, wp::float32> var_31;
    const wp::int32 var_32 = 0;
    bool var_33;
    const wp::int32 var_34 = 1;
    wp::int32 var_35;
    wp::float32 var_36;
    bool var_37;
    const wp::float32 var_38 = 0.0;
    const wp::float32 var_39 = 0.0;
    const wp::float32 var_40 = 0.0;
    const wp::float32 var_41 = 0.0;
    wp::vec_t<3, wp::float32> var_42;
    wp::vec_t<3, wp::float32> var_43;
    wp::vec_t<3, wp::float32> var_44;
    const bool var_45 = false;
    wp::float32 var_46;
    wp::vec_t<3, wp::float32> var_47;
    wp::vec_t<3, wp::float32> var_48;
    wp::vec_t<3, wp::float32> var_49;
    wp::vec_t<3, wp::float32> var_50;
    wp::vec_t<3, wp::float32> var_51;
    Vert_99873389 var_52;
    wp::vec_t<3, wp::float32>* var_53;
    wp::vec_t<3, wp::float32> var_54;
    wp::vec_t<3, wp::float32> var_55;
    wp::vec_t<3, wp::float32> var_56;
    wp::float32 var_57;
    wp::float32 var_58;
    wp::float32 var_59;
    bool var_60;
    wp::float32 var_61;
    wp::vec_t<3, wp::float32> var_62;
    wp::vec_t<3, wp::float32> var_63;
    wp::vec_t<3, wp::float32> var_64;
    wp::int32 var_65;
    wp::vec_t<3, wp::float32> var_66;
    const bool var_67 = false;
    bool var_68;
    const wp::int32 var_69 = 4;
    wp::range_t var_70;
    wp::int32 var_71;
    const wp::int32 var_72 = 1;
    wp::uint32 var_73;
    wp::uint32 var_74;
    wp::uint32 var_75;
    wp::uint32 var_76;
    const wp::int32 var_77 = 0;
    wp::uint32 var_78;
    bool var_79;
    const wp::int32 var_80 = 2;
    wp::int32 var_81;
    const wp::int32 var_82 = 1;
    wp::int32 var_83;
    wp::vec_t<3, wp::float32> var_84;
    wp::vec_t<3, wp::float32> var_85;
    wp::float32 var_86;
    wp::float32 var_87;
    bool var_88;
    const bool var_89 = true;
    bool var_90;
    wp::float32 var_91;
    wp::vec_t<3, wp::float32> var_92;
    wp::vec_t<3, wp::float32> var_93;
    wp::vec_t<3, wp::float32> var_94;
    wp::int32 var_95;
    wp::vec_t<3, wp::float32> var_96;
    const wp::int32 var_97 = 0;
    const wp::int32 var_98 = 0;
    const wp::int32 var_99 = 0;
    wp::vec_t<4, wp::int32> var_100;
    const wp::int32 var_101 = 0;
    const wp::int32 var_102 = 1;
    wp::uint32 var_103;
    wp::uint32 var_104;
    wp::uint32 var_105;
    wp::uint32 var_106;
    const wp::int32 var_107 = 0;
    wp::uint32 var_108;
    bool var_109;
    const wp::int32 var_110 = 1;
    wp::int32 var_111;
    wp::int32 var_112;
    wp::int32 var_113;
    wp::int32 var_114;
    const wp::int32 var_115 = 1;
    const wp::int32 var_116 = 1;
    wp::uint32 var_117;
    wp::uint32 var_118;
    wp::uint32 var_119;
    wp::uint32 var_120;
    const wp::int32 var_121 = 0;
    wp::uint32 var_122;
    bool var_123;
    const wp::int32 var_124 = 1;
    wp::int32 var_125;
    wp::int32 var_126;
    wp::int32 var_127;
    wp::int32 var_128;
    const wp::int32 var_129 = 2;
    const wp::int32 var_130 = 1;
    wp::uint32 var_131;
    wp::uint32 var_132;
    wp::uint32 var_133;
    wp::uint32 var_134;
    const wp::int32 var_135 = 0;
    wp::uint32 var_136;
    bool var_137;
    const wp::int32 var_138 = 1;
    wp::int32 var_139;
    wp::int32 var_140;
    wp::int32 var_141;
    wp::int32 var_142;
    const wp::int32 var_143 = 3;
    const wp::int32 var_144 = 1;
    wp::uint32 var_145;
    wp::uint32 var_146;
    wp::uint32 var_147;
    wp::uint32 var_148;
    const wp::int32 var_149 = 0;
    wp::uint32 var_150;
    bool var_151;
    const wp::int32 var_152 = 1;
    wp::int32 var_153;
    wp::int32 var_154;
    wp::int32 var_155;
    wp::int32 var_156;
    const wp::int32 var_157 = 1;
    wp::int32 var_158;
    wp::vec_t<3, wp::float32>* var_159;
    const wp::int32 var_160 = 2;
    wp::int32 var_161;
    wp::vec_t<3, wp::float32> var_162;
    wp::vec_t<3, wp::float32>* var_163;
    const wp::int32 var_164 = 2;
    wp::int32 var_165;
    const wp::int32 var_166 = 1;
    wp::int32 var_167;
    wp::vec_t<3, wp::float32> var_168;
    const wp::float32 var_169 = 0.0;
    const wp::float32 var_170 = 0.0;
    const wp::float32 var_171 = 0.0;
    wp::vec_t<3, wp::float32> var_172;
    const bool var_173 = true;
    const wp::int32 var_174 = 1;
    bool var_175;
    const wp::int32 var_176 = 0;
    wp::int32 var_177;
    const wp::int32 var_178 = 2;
    wp::int32 var_179;
    const wp::int32 var_180 = 1;
    wp::int32 var_181;
    wp::vec_t<3, wp::float32> var_182;
    const wp::int32 var_183 = 1;
    wp::uint32 var_184;
    wp::uint32 var_185;
    wp::uint32 var_186;
    const wp::float32 var_187 = 1.0;
    const wp::int32 var_188 = 2;
    bool var_189;
    const wp::int32 var_190 = 0;
    wp::int32 var_191;
    const wp::int32 var_192 = 1;
    wp::int32 var_193;
    wp::vec_t<3, wp::float32> var_194;
    wp::vec_t<4, wp::float32> var_195;
    wp::uint32 var_196;
    wp::vec_t<4, wp::float32> var_197;
    wp::uint32 var_198;
    const wp::int32 var_199 = 3;
    bool var_200;
    const wp::int32 var_201 = 0;
    wp::int32 var_202;
    const wp::int32 var_203 = 1;
    wp::int32 var_204;
    const wp::int32 var_205 = 2;
    wp::int32 var_206;
    wp::vec_t<3, wp::float32> var_207;
    wp::vec_t<4, wp::float32> var_208;
    wp::uint32 var_209;
    wp::vec_t<4, wp::float32> var_210;
    wp::uint32 var_211;
    const wp::int32 var_212 = 4;
    bool var_213;
    wp::vec_t<3, wp::float32> var_214;
    wp::vec_t<4, wp::float32> var_215;
    wp::uint32 var_216;
    wp::vec_t<4, wp::float32> var_217;
    wp::uint32 var_218;
    const wp::int32 var_219 = 15;
    wp::uint32 var_220;
    bool var_221;
    bool var_222;
    const bool var_223 = false;
    wp::vec_t<4, wp::float32> var_224;
    wp::uint32 var_225;
    wp::vec_t<3, wp::float32> var_226;
    bool var_227;
    wp::vec_t<4, wp::float32> var_228;
    wp::uint32 var_229;
    wp::vec_t<3, wp::float32> var_230;
    bool var_231;
    wp::vec_t<4, wp::float32> var_232;
    wp::uint32 var_233;
    wp::vec_t<4, wp::float32> var_234;
    wp::uint32 var_235;
    wp::vec_t<3, wp::float32> var_236;
    bool var_237;
    wp::int32 var_238;
    wp::int32 var_239;
    wp::vec_t<4, wp::float32> var_240;
    wp::uint32 var_241;
    wp::vec_t<4, wp::float32> var_242;
    wp::uint32 var_243;
    wp::vec_t<3, wp::float32> var_244;
    bool var_245;
    wp::int32 var_246;
    wp::vec_t<3, wp::float32> var_247;
    bool var_248;
    const wp::float32 var_249 = 0.0;
    const wp::float32 var_250 = 0.0;
    const wp::float32 var_251 = 0.0;
    const wp::float32 var_252 = 0.0;
    wp::vec_t<3, wp::float32> var_253;
    wp::vec_t<3, wp::float32> var_254;
    wp::vec_t<3, wp::float32> var_255;
    const bool var_256 = false;
    wp::float32 var_257;
    wp::vec_t<3, wp::float32> var_258;
    wp::vec_t<3, wp::float32> var_259;
    wp::vec_t<3, wp::float32> var_260;
    wp::vec_t<3, wp::float32> var_261;
    wp::float32 var_262;
    wp::float32 var_263;
    wp::vec_t<3, wp::float32> var_264;
    wp::vec_t<3, wp::float32> var_265;
    wp::vec_t<3, wp::float32> var_266;
    wp::float32 var_267;
    const wp::float32 var_268 = 1e-08;
    wp::float32 var_269;
    bool var_270;
    const wp::float32 var_271 = 1.0;
    wp::float32 var_272;
    wp::float32 var_273;
    wp::vec_t<3, wp::float32> var_274;
    bool var_275;
    const wp::float32 var_276 = -1.0;
    wp::float32 var_277;
    wp::vec_t<3, wp::float32> var_278;
    wp::float32 var_279;
    const wp::float32 var_280 = 0.0;
    bool var_281;
    const wp::float32 var_282 = 1.0;
    wp::float32 var_283;
    wp::float32 var_284;
    wp::vec_t<3, wp::float32> var_285;
    const wp::float32 var_286 = 1.0;
    const wp::float32 var_287 = 0.0;
    const wp::float32 var_288 = 0.0;
    wp::vec_t<3, wp::float32> var_289;
    wp::vec_t<3, wp::float32> var_290;
    wp::vec_t<3, wp::float32> var_291;
    wp::vec_t<3, wp::float32> var_292;
    const bool var_293 = true;
    //---------
    // forward
    // def solve_closest_distance_core(                                                       <L 1>
    // distance = float(0.0)                                                                  <L 40>
    var_1 = wp::float(var_0);
    // point_a = wp.vec3(0.0, 0.0, 0.0)                                                       <L 41>
    var_5 = wp::vec_t<3, wp::float32>(var_2, var_3, var_4);
    // point_b = wp.vec3(0.0, 0.0, 0.0)                                                       <L 42>
    var_9 = wp::vec_t<3, wp::float32>(var_6, var_7, var_8);
    // normal = wp.vec3(0.0, 0.0, 0.0)                                                        <L 43>
    var_13 = wp::vec_t<3, wp::float32>(var_10, var_11, var_12);
    // simplex_v = Mat83f()                                                                   <L 46>
    var_14 = wp::mat_t<8, 3, wp::float32>();
    // simplex_barycentric = wp.vec4(0.0, 0.0, 0.0, 0.0)                                      <L 47>
    var_19 = wp::vec_t<4, wp::float32>(var_15, var_16, var_17, var_18);
    // simplex_usage_mask = wp.uint32(0)                                                      <L 48>
    var_21 = wp::uint32(var_20);
    // iter_count = int(MAX_ITER)                                                             <L 50>
    var_22 = wp::int(var_MAX_ITER);
    // center = geometric_center(geom_a, geom_b, orientation_b, position_b, data_provider)       <L 53>
    var_23 = create_support_map_function__locals__geometric_center_24(var_geom_a, var_geom_b, var_orientation_b, var_position_b, var_data_provider);
    // v = center.BtoA                                                                        <L 56>
    var_24 = &((var_23).BtoA);
    var_26 = wp::load(var_24);
    var_25 = wp::copy(var_26);
    // dist_sq = wp.length_sq(v)                                                              <L 57>
    var_27 = wp::length_sq(var_25);
    // last_search_dir = wp.vec3(1.0, 0.0, 0.0)                                               <L 59>
    var_31 = wp::vec_t<3, wp::float32>(var_28, var_29, var_30);
    // while iter_count > 0:                                                                  <L 61>
    start_while_0:;
    var_33 = (var_22 > var_32);
    if ((var_33) == false) goto end_while_0;
        // iter_count -= 1                                                                    <L 62>
        var_35 = wp::sub(var_22, var_34);
        // if dist_sq < COLLIDE_EPSILON * COLLIDE_EPSILON:                                    <L 64>
        var_36 = wp::mul(var_COLLIDE_EPSILON, var_COLLIDE_EPSILON);
        var_37 = (var_27 < var_36);
        if (var_37) {
            // distance = 0.0                                                                 <L 66>
            // normal = wp.vec3(0.0, 0.0, 0.0)                                                <L 67>
            var_42 = wp::vec_t<3, wp::float32>(var_39, var_40, var_41);
            // point_a, point_b = simplex_get_closest(simplex_v, simplex_barycentric, simplex_usage_mask)       <L 68>
            create_solve_closest_distance__locals__simplex_get_closest_12(var_14, var_19, var_21, var_43, var_44);
            // return False, point_a, point_b, normal, distance                               <L 69>
            ret_0 = var_45;
            ret_1 = var_43;
            ret_2 = var_44;
            ret_3 = var_42;
            ret_4 = var_38;
            return;
        }
        var_46 = wp::where(var_37, var_38, var_1);
        var_47 = wp::where(var_37, var_43, var_5);
        var_48 = wp::where(var_37, var_44, var_9);
        var_49 = wp::where(var_37, var_42, var_13);
        // search_dir = -v                                                                    <L 71>
        var_50 = wp::neg(var_25);
        // last_search_dir = search_dir                                                       <L 73>
        var_51 = wp::copy(var_50);
        // w = minkowski_support(geom_a, geom_b, search_dir, orientation_b, position_b, extend, data_provider)       <L 76>
        var_52 = create_support_map_function__locals__minkowski_support_24(var_geom_a, var_geom_b, var_50, var_orientation_b, var_position_b, var_extend, var_data_provider);
        // w_v = w.BtoA                                                                       <L 80>
        var_53 = &((var_52).BtoA);
        var_55 = wp::load(var_53);
        var_54 = wp::copy(var_55);
        // delta_dist = wp.dot(v, v - w_v)                                                    <L 81>
        var_56 = wp::sub(var_25, var_54);
        var_57 = wp::dot(var_25, var_56);
        // if delta_dist < COLLIDE_EPSILON * wp.sqrt(dist_sq):                                <L 82>
        var_58 = wp::sqrt(var_27);
        var_59 = wp::mul(var_COLLIDE_EPSILON, var_58);
        var_60 = (var_57 < var_59);
        if (var_60) {
            // break                                                                          <L 83>
            wp::assign(var_1, var_46);
            wp::assign(var_5, var_47);
            wp::assign(var_9, var_48);
            wp::assign(var_13, var_49);
            wp::assign(var_22, var_35);
            wp::assign(var_31, var_51);
            goto end_while_0;
        }
        var_61 = wp::where(var_60, var_1, var_46);
        var_62 = wp::where(var_60, var_5, var_47);
        var_63 = wp::where(var_60, var_9, var_48);
        var_64 = wp::where(var_60, var_13, var_49);
        var_65 = wp::where(var_60, var_22, var_35);
        var_66 = wp::where(var_60, var_31, var_51);
        // is_duplicate = bool(False)                                                         <L 86>
        var_68 = bool(var_67);
        // for i in range(4):                                                                 <L 87>
        var_70 = wp::range(var_69);
        start_for_3:;
            if (iter_cmp(var_70) == 0) goto end_for_3;
            var_71 = wp::iter_next(var_70);
            // if (simplex_usage_mask & (wp.uint32(1) << wp.uint32(i))) != wp.uint32(0):       <L 88>
            var_73 = wp::uint32(var_72);
            var_74 = wp::uint32(var_71);
            var_75 = wp::lshift(var_73, var_74);
            var_76 = wp::bit_and(var_21, var_75);
            var_78 = wp::uint32(var_77);
            var_79 = (var_76 != var_78);
            if (var_79) {
                // if wp.length_sq(simplex_v[2 * i + 1] - w_v) < COLLIDE_EPSILON * COLLIDE_EPSILON:       <L 90>
                var_81 = wp::mul(var_80, var_71);
                var_83 = wp::add(var_81, var_82);
                var_84 = wp::extract(var_14, var_83);
                var_85 = wp::sub(var_84, var_54);
                var_86 = wp::length_sq(var_85);
                var_87 = wp::mul(var_COLLIDE_EPSILON, var_COLLIDE_EPSILON);
                var_88 = (var_86 < var_87);
                if (var_88) {
                    // is_duplicate = bool(True)                                              <L 91>
                    var_90 = bool(var_89);
                    // break                                                                  <L 92>
                    wp::assign(var_68, var_90);
                    goto end_for_3;
                }
            }
            goto start_for_3;
        end_for_3:;
        // if is_duplicate:                                                                   <L 93>
        if (var_68) {
            // break                                                                          <L 94>
            wp::assign(var_1, var_61);
            wp::assign(var_5, var_62);
            wp::assign(var_9, var_63);
            wp::assign(var_13, var_64);
            wp::assign(var_22, var_65);
            wp::assign(var_31, var_66);
            goto end_while_0;
        }
        var_91 = wp::where(var_68, var_1, var_61);
        var_92 = wp::where(var_68, var_5, var_62);
        var_93 = wp::where(var_68, var_9, var_63);
        var_94 = wp::where(var_68, var_13, var_64);
        var_95 = wp::where(var_68, var_22, var_65);
        var_96 = wp::where(var_68, var_31, var_66);
        // use_count = 0                                                                      <L 98>
        // free_slot = 0                                                                      <L 99>
        // indices = wp.vec4i(0)                                                              <L 100>
        var_100 = wp::vec_t<4, wp::int32>(var_99);
        // for i in range(4):                                                                 <L 102>
        // if (simplex_usage_mask & (wp.uint32(1) << wp.uint32(i))) != wp.uint32(0):          <L 103>
        var_103 = wp::uint32(var_102);
        var_104 = wp::uint32(var_101);
        var_105 = wp::lshift(var_103, var_104);
        var_106 = wp::bit_and(var_21, var_105);
        var_108 = wp::uint32(var_107);
        var_109 = (var_106 != var_108);
        if (var_109) {
            // indices[use_count] = i                                                         <L 104>
            wp::assign_inplace(var_100, var_97, var_101);
            // use_count += 1                                                                 <L 105>
            var_111 = wp::add(var_97, var_110);
        }
        if (!var_109) {
            // free_slot = i                                                                  <L 107>
            var_112 = wp::copy(var_101);
        }
        var_113 = wp::where(var_109, var_111, var_97);
        var_114 = wp::where(var_109, var_98, var_112);
        // if (simplex_usage_mask & (wp.uint32(1) << wp.uint32(i))) != wp.uint32(0):          <L 103>
        var_117 = wp::uint32(var_116);
        var_118 = wp::uint32(var_115);
        var_119 = wp::lshift(var_117, var_118);
        var_120 = wp::bit_and(var_21, var_119);
        var_122 = wp::uint32(var_121);
        var_123 = (var_120 != var_122);
        if (var_123) {
            // indices[use_count] = i                                                         <L 104>
            wp::assign_inplace(var_100, var_113, var_115);
            // use_count += 1                                                                 <L 105>
            var_125 = wp::add(var_113, var_124);
        }
        if (!var_123) {
            // free_slot = i                                                                  <L 107>
            var_126 = wp::copy(var_115);
        }
        var_127 = wp::where(var_123, var_125, var_113);
        var_128 = wp::where(var_123, var_114, var_126);
        // if (simplex_usage_mask & (wp.uint32(1) << wp.uint32(i))) != wp.uint32(0):          <L 103>
        var_131 = wp::uint32(var_130);
        var_132 = wp::uint32(var_129);
        var_133 = wp::lshift(var_131, var_132);
        var_134 = wp::bit_and(var_21, var_133);
        var_136 = wp::uint32(var_135);
        var_137 = (var_134 != var_136);
        if (var_137) {
            // indices[use_count] = i                                                         <L 104>
            wp::assign_inplace(var_100, var_127, var_129);
            // use_count += 1                                                                 <L 105>
            var_139 = wp::add(var_127, var_138);
        }
        if (!var_137) {
            // free_slot = i                                                                  <L 107>
            var_140 = wp::copy(var_129);
        }
        var_141 = wp::where(var_137, var_139, var_127);
        var_142 = wp::where(var_137, var_128, var_140);
        // if (simplex_usage_mask & (wp.uint32(1) << wp.uint32(i))) != wp.uint32(0):          <L 103>
        var_145 = wp::uint32(var_144);
        var_146 = wp::uint32(var_143);
        var_147 = wp::lshift(var_145, var_146);
        var_148 = wp::bit_and(var_21, var_147);
        var_150 = wp::uint32(var_149);
        var_151 = (var_148 != var_150);
        if (var_151) {
            // indices[use_count] = i                                                         <L 104>
            wp::assign_inplace(var_100, var_141, var_143);
            // use_count += 1                                                                 <L 105>
            var_153 = wp::add(var_141, var_152);
        }
        if (!var_151) {
            // free_slot = i                                                                  <L 107>
            var_154 = wp::copy(var_143);
        }
        var_155 = wp::where(var_151, var_153, var_141);
        var_156 = wp::where(var_151, var_142, var_154);
        // indices[use_count] = free_slot                                                     <L 109>
        wp::assign_inplace(var_100, var_155, var_156);
        // use_count += 1                                                                     <L 110>
        var_158 = wp::add(var_155, var_157);
        // simplex_v[2 * free_slot] = w.B                                                     <L 112>
        var_159 = &((var_52).B);
        var_161 = wp::mul(var_160, var_156);
        var_162 = wp::load(var_159);
        wp::assign_inplace(var_14, var_161, var_162);
        // simplex_v[2 * free_slot + 1] = w.BtoA                                              <L 113>
        var_163 = &((var_52).BtoA);
        var_165 = wp::mul(var_164, var_156);
        var_167 = wp::add(var_165, var_166);
        var_168 = wp::load(var_163);
        wp::assign_inplace(var_14, var_167, var_168);
        // closest = wp.vec3(0.0, 0.0, 0.0)                                                   <L 115>
        var_172 = wp::vec_t<3, wp::float32>(var_169, var_170, var_171);
        // success = True                                                                     <L 116>
        // if use_count == 1:                                                                 <L 118>
        var_175 = (var_158 == var_174);
        if (var_175) {
            // i0 = indices[0]                                                                <L 119>
            var_177 = wp::extract(var_100, var_176);
            // closest = simplex_v[2 * i0 + 1]                                                <L 121>
            var_179 = wp::mul(var_178, var_177);
            var_181 = wp::add(var_179, var_180);
            var_182 = wp::extract(var_14, var_181);
            // simplex_usage_mask = wp.uint32(1) << wp.uint32(i0)                             <L 122>
            var_184 = wp::uint32(var_183);
            var_185 = wp::uint32(var_177);
            var_186 = wp::lshift(var_184, var_185);
            // simplex_barycentric[i0] = 1.0                                                  <L 123>
            wp::assign_inplace(var_19, var_177, var_187);
        }
        if (!var_175) {
            // elif use_count == 2:                                                           <L 124>
            var_189 = (var_158 == var_188);
            if (var_189) {
                // i0 = indices[0]                                                            <L 125>
                var_191 = wp::extract(var_100, var_190);
                // i1 = indices[1]                                                            <L 126>
                var_193 = wp::extract(var_100, var_192);
                // closest, bc, mask = closest_segment(simplex_v, i0, i1)                     <L 127>
                create_solve_closest_distance__locals__closest_segment_12(var_14, var_191, var_193, var_194, var_195, var_196);
                // simplex_barycentric = bc                                                   <L 128>
                var_197 = wp::copy(var_195);
                // simplex_usage_mask = mask                                                  <L 129>
                var_198 = wp::copy(var_196);
            }
            if (!var_189) {
                // elif use_count == 3:                                                       <L 130>
                var_200 = (var_158 == var_199);
                if (var_200) {
                    // i0 = indices[0]                                                        <L 131>
                    var_202 = wp::extract(var_100, var_201);
                    // i1 = indices[1]                                                        <L 132>
                    var_204 = wp::extract(var_100, var_203);
                    // i2 = indices[2]                                                        <L 133>
                    var_206 = wp::extract(var_100, var_205);
                    // closest, bc, mask = closest_triangle(simplex_v, i0, i1, i2)            <L 134>
                    create_solve_closest_distance__locals__closest_triangle_12(var_14, var_202, var_204, var_206, var_207, var_208, var_209);
                    // simplex_barycentric = bc                                               <L 135>
                    var_210 = wp::copy(var_208);
                    // simplex_usage_mask = mask                                              <L 136>
                    var_211 = wp::copy(var_209);
                }
                if (!var_200) {
                    // elif use_count == 4:                                                   <L 137>
                    var_213 = (var_158 == var_212);
                    if (var_213) {
                        // closest, bc, mask = closest_tetrahedron(simplex_v)                 <L 138>
                        create_solve_closest_distance__locals__closest_tetrahedron_12(var_14, var_214, var_215, var_216);
                        // simplex_barycentric = bc                                           <L 139>
                        var_217 = wp::copy(var_215);
                        // simplex_usage_mask = mask                                          <L 140>
                        var_218 = wp::copy(var_216);
                        // inside_tetrahedron = mask == wp.uint32(15)                         <L 143>
                        var_220 = wp::uint32(var_219);
                        var_221 = (var_216 == var_220);
                        // success = not inside_tetrahedron                                   <L 144>
                        var_222 = wp::unot(var_221);
                    }
                    if (!var_213) {
                        // success = False                                                    <L 146>
                    }
                    var_224 = wp::where(var_213, var_217, var_19);
                    var_225 = wp::where(var_213, var_218, var_21);
                    var_226 = wp::where(var_213, var_214, var_172);
                    var_227 = wp::where(var_213, var_222, var_223);
                }
                var_228 = wp::where(var_200, var_210, var_224);
                var_229 = wp::where(var_200, var_211, var_225);
                var_230 = wp::where(var_200, var_207, var_226);
                var_231 = wp::where(var_200, var_173, var_227);
                var_232 = wp::where(var_200, var_208, var_215);
                var_233 = wp::where(var_200, var_209, var_216);
            }
            var_234 = wp::where(var_189, var_197, var_228);
            var_235 = wp::where(var_189, var_198, var_229);
            var_236 = wp::where(var_189, var_194, var_230);
            var_237 = wp::where(var_189, var_173, var_231);
            var_238 = wp::where(var_189, var_191, var_202);
            var_239 = wp::where(var_189, var_193, var_204);
            var_240 = wp::where(var_189, var_195, var_232);
            var_241 = wp::where(var_189, var_196, var_233);
        }
        var_242 = wp::where(var_175, var_19, var_234);
        var_243 = wp::where(var_175, var_186, var_235);
        var_244 = wp::where(var_175, var_182, var_236);
        var_245 = wp::where(var_175, var_173, var_237);
        var_246 = wp::where(var_175, var_177, var_238);
        // new_v = closest                                                                    <L 148>
        var_247 = wp::copy(var_244);
        // if not success:                                                                    <L 150>
        var_248 = wp::unot(var_245);
        if (var_248) {
            // distance = 0.0                                                                 <L 152>
            // normal = wp.vec3(0.0, 0.0, 0.0)                                                <L 153>
            var_253 = wp::vec_t<3, wp::float32>(var_250, var_251, var_252);
            // point_a, point_b = simplex_get_closest(simplex_v, simplex_barycentric, simplex_usage_mask)       <L 154>
            create_solve_closest_distance__locals__simplex_get_closest_12(var_14, var_242, var_243, var_254, var_255);
            // return False, point_a, point_b, normal, distance                               <L 155>
            ret_0 = var_256;
            ret_1 = var_254;
            ret_2 = var_255;
            ret_3 = var_253;
            ret_4 = var_249;
            return;
        }
        var_257 = wp::where(var_248, var_249, var_91);
        var_258 = wp::where(var_248, var_254, var_92);
        var_259 = wp::where(var_248, var_255, var_93);
        var_260 = wp::where(var_248, var_253, var_94);
        // v = new_v                                                                          <L 157>
        var_261 = wp::copy(var_247);
        // dist_sq = wp.length_sq(v)                                                          <L 158>
        var_262 = wp::length_sq(var_261);
        wp::assign(var_1, var_257);
        wp::assign(var_5, var_258);
        wp::assign(var_9, var_259);
        wp::assign(var_13, var_260);
        wp::assign(var_19, var_242);
        wp::assign(var_21, var_243);
        wp::assign(var_22, var_95);
        wp::assign(var_25, var_261);
        wp::assign(var_27, var_262);
        wp::assign(var_31, var_96);
    goto start_while_0;
    end_while_0:;
    // distance = wp.sqrt(dist_sq)                                                            <L 160>
    var_263 = wp::sqrt(var_27);
    // point_a, point_b = simplex_get_closest(simplex_v, simplex_barycentric, simplex_usage_mask)       <L 162>
    create_solve_closest_distance__locals__simplex_get_closest_12(var_14, var_19, var_21, var_264, var_265);
    // delta = point_b - point_a                                                              <L 165>
    var_266 = wp::sub(var_265, var_264);
    // delta_len_sq = wp.length_sq(delta)                                                     <L 166>
    var_267 = wp::length_sq(var_266);
    // if delta_len_sq > EPSILON * EPSILON:                                                   <L 167>
    var_269 = wp::mul(var_268, var_268);
    var_270 = (var_267 > var_269);
    if (var_270) {
        // normal = delta * (1.0 / wp.sqrt(delta_len_sq))                                     <L 168>
        var_272 = wp::sqrt(var_267);
        var_273 = wp::div(var_271, var_272);
        var_274 = wp::mul(var_266, var_273);
    }
    if (!var_270) {
        // elif distance > COLLIDE_EPSILON:                                                   <L 169>
        var_275 = (var_263 > var_COLLIDE_EPSILON);
        if (var_275) {
            // normal = v * (-1.0 / distance)                                                 <L 171>
            var_277 = wp::div(var_276, var_263);
            var_278 = wp::mul(var_25, var_277);
        }
        if (!var_275) {
            // nsq = wp.length_sq(last_search_dir)                                            <L 174>
            var_279 = wp::length_sq(var_31);
            // if nsq > 0.0:                                                                  <L 175>
            var_281 = (var_279 > var_280);
            if (var_281) {
                // normal = last_search_dir * (1.0 / wp.sqrt(nsq))                            <L 176>
                var_283 = wp::sqrt(var_279);
                var_284 = wp::div(var_282, var_283);
                var_285 = wp::mul(var_31, var_284);
            }
            if (!var_281) {
                // normal = wp.vec3(1.0, 0.0, 0.0)                                            <L 178>
                var_289 = wp::vec_t<3, wp::float32>(var_286, var_287, var_288);
            }
            var_290 = wp::where(var_281, var_285, var_289);
        }
        var_291 = wp::where(var_275, var_278, var_290);
    }
    var_292 = wp::where(var_270, var_274, var_291);
    // return True, point_a, point_b, normal, distance                                        <L 180>
    ret_0 = var_293;
    ret_1 = var_264;
    ret_2 = var_265;
    ret_3 = var_292;
    ret_4 = var_263;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/collision_core.py:38
static CUDA_CALLABLE bool is_discrete_shape_0(
    wp::int32 var_shape_type)
{
    //---------
    // primal vars
    bool var_0;
    const wp::int32 var_1 = 7;
    bool var_2;
    const wp::int32 var_3 = 10;
    bool var_4;
    const wp::int32 var_5 = 1000;
    bool var_6;
    const wp::int32 var_7 = 1001;
    bool var_8;
    const wp::int32 var_9 = 1;
    bool var_10;
    //---------
    // forward
    // def is_discrete_shape(shape_type: int) -> bool:                                        <L 39>
    // return (                                                                               <L 41>
    // shape_type == GeoType.BOX                                                              <L 42>
    var_2 = (var_shape_type == var_1);
    var_0 = var_2;
    if (!var_0) {
        // or shape_type == GeoType.CONVEX_MESH                                               <L 43>
        var_4 = (var_shape_type == var_3);
        var_0 = var_0 || var_4;
    }
    if (!var_0) {
        // or shape_type == GeoTypeEx.TRIANGLE                                                <L 44>
        var_6 = (var_shape_type == var_5);
        var_0 = var_0 || var_6;
    }
    if (!var_0) {
        // or shape_type == GeoTypeEx.TRIANGLE_PRISM                                          <L 45>
        var_8 = (var_shape_type == var_7);
        var_0 = var_0 || var_8;
    }
    if (!var_0) {
        // or shape_type == GeoType.PLANE                                                     <L 46>
        var_10 = (var_shape_type == var_9);
        var_0 = var_0 || var_10;
    }
    return var_0;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/collision_core.py:50
static CUDA_CALLABLE wp::vec_t<3, wp::float32> project_point_onto_plane_0(
    wp::vec_t<3, wp::float32> var_point,
    wp::vec_t<3, wp::float32> var_plane_point,
    wp::vec_t<3, wp::float32> var_plane_normal)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::float32 var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    //---------
    // forward
    // def project_point_onto_plane(point: wp.vec3, plane_point: wp.vec3, plane_normal: wp.vec3) -> wp.vec3:       <L 51>
    // to_point = point - plane_point                                                         <L 63>
    var_0 = wp::sub(var_point, var_plane_point);
    // distance_to_plane = wp.dot(to_point, plane_normal)                                     <L 64>
    var_1 = wp::dot(var_0, var_plane_normal);
    // projected_point = point - plane_normal * distance_to_plane                             <L 65>
    var_2 = wp::mul(var_plane_normal, var_1);
    var_3 = wp::sub(var_point, var_2);
    // return projected_point                                                                 <L 66>
    return var_3;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/collision_core.py:172
static CUDA_CALLABLE ContactData_40360d7c post_process_axial_on_discrete_contact_0(
    ContactData_40360d7c var_contact_data,
    GenericShapeData_ceaba563 var_shape_a,
    wp::vec_t<3, wp::float32> var_pos_a_adjusted,
    wp::quat_t<wp::float32> var_rot_a,
    GenericShapeData_ceaba563 var_shape_b,
    wp::vec_t<3, wp::float32> var_pos_b_adjusted,
    wp::quat_t<wp::float32> var_rot_b)
{
    //---------
    // primal vars
    wp::int32* var_0;
    wp::int32 var_1;
    wp::int32 var_2;
    wp::int32* var_3;
    wp::int32 var_4;
    wp::int32 var_5;
    wp::vec_t<3, wp::float32>* var_6;
    wp::vec_t<3, wp::float32> var_7;
    wp::vec_t<3, wp::float32> var_8;
    wp::float32* var_9;
    wp::float32 var_10;
    wp::float32 var_11;
    wp::float32* var_12;
    wp::float32 var_13;
    wp::float32 var_14;
    bool var_15;
    const wp::int32 var_16 = 3;
    bool var_17;
    const wp::int32 var_18 = 4;
    bool var_19;
    wp::vec_t<3, wp::float32>* var_20;
    const wp::float32 var_21 = 0.5;
    wp::float32 var_22;
    wp::vec_t<3, wp::float32> var_23;
    wp::vec_t<3, wp::float32> var_24;
    wp::vec_t<3, wp::float32> var_25;
    wp::float32* var_26;
    wp::float32 var_27;
    wp::float32 var_28;
    bool var_29;
    const wp::int32 var_30 = 3;
    bool var_31;
    const wp::int32 var_32 = 4;
    bool var_33;
    wp::vec_t<3, wp::float32>* var_34;
    const wp::float32 var_35 = 0.5;
    wp::float32 var_36;
    wp::vec_t<3, wp::float32> var_37;
    wp::vec_t<3, wp::float32> var_38;
    wp::vec_t<3, wp::float32> var_39;
    wp::float32* var_40;
    wp::float32 var_41;
    wp::float32 var_42;
    bool var_43;
    bool var_44;
    bool var_45;
    const wp::int32 var_46 = 6;
    bool var_47;
    const wp::int32 var_48 = 9;
    bool var_49;
    bool var_50;
    const wp::int32 var_51 = 6;
    bool var_52;
    const wp::int32 var_53 = 9;
    bool var_54;
    bool var_55;
    bool var_56;
    bool var_57;
    bool var_58;
    const wp::float32 var_59 = 0.0;
    const wp::float32 var_60 = 0.0;
    const wp::float32 var_61 = 1.0;
    wp::vec_t<3, wp::float32> var_62;
    wp::vec_t<3, wp::float32> var_63;
    wp::vec_t<3, wp::float32>* var_64;
    const wp::int32 var_65 = 0;
    wp::float32 var_66;
    wp::vec_t<3, wp::float32> var_67;
    wp::vec_t<3, wp::float32>* var_68;
    const wp::int32 var_69 = 1;
    wp::float32 var_70;
    wp::vec_t<3, wp::float32> var_71;
    const wp::int32 var_72 = 9;
    bool var_73;
    wp::vec_t<3, wp::float32> var_74;
    wp::vec_t<3, wp::float32> var_75;
    const wp::float32 var_76 = 0.0;
    const wp::float32 var_77 = 0.0;
    const wp::float32 var_78 = 1.0;
    wp::vec_t<3, wp::float32> var_79;
    wp::vec_t<3, wp::float32> var_80;
    wp::vec_t<3, wp::float32>* var_81;
    const wp::int32 var_82 = 0;
    wp::float32 var_83;
    wp::vec_t<3, wp::float32> var_84;
    wp::vec_t<3, wp::float32>* var_85;
    const wp::int32 var_86 = 1;
    wp::float32 var_87;
    wp::vec_t<3, wp::float32> var_88;
    const wp::int32 var_89 = 9;
    bool var_90;
    wp::vec_t<3, wp::float32> var_91;
    wp::vec_t<3, wp::float32> var_92;
    wp::vec_t<3, wp::float32> var_93;
    wp::float32 var_94;
    wp::float32 var_95;
    bool var_96;
    wp::vec_t<3, wp::float32> var_97;
    wp::vec_t<3, wp::float32> var_98;
    wp::float32 var_99;
    wp::float32 var_100;
    const bool var_101 = false;
    const wp::float32 var_102 = 2.0;
    wp::float32 var_103;
    wp::float32 var_104;
    const wp::float32 var_105 = 0.03490658503988659;
    wp::float32 var_106;
    wp::float32 var_107;
    wp::float32 var_108;
    wp::float32 var_109;
    bool var_110;
    bool var_111;
    bool var_112;
    const bool var_113 = true;
    bool var_114;
    const wp::float32 var_115 = 0.03489949670250097;
    bool var_116;
    const bool var_117 = true;
    bool var_118;
    bool var_119;
    wp::vec_t<3, wp::float32> var_120;
    wp::vec_t<3, wp::float32> var_121;
    wp::vec_t<3, wp::float32> var_122;
    wp::vec_t<3, wp::float32>* var_123;
    wp::vec_t<3, wp::float32> var_124;
    wp::vec_t<3, wp::float32> var_125;
    //---------
    // forward
    // def post_process_axial_on_discrete_contact(                                            <L 173>
    // type_a = shape_a.shape_type                                                            <L 201>
    var_0 = &((var_shape_a).shape_type);
    var_2 = wp::load(var_0);
    var_1 = wp::copy(var_2);
    // type_b = shape_b.shape_type                                                            <L 202>
    var_3 = &((var_shape_b).shape_type);
    var_5 = wp::load(var_3);
    var_4 = wp::copy(var_5);
    // normal = contact_data.contact_normal_a_to_b                                            <L 203>
    var_6 = &((var_contact_data).contact_normal_a_to_b);
    var_8 = wp::load(var_6);
    var_7 = wp::copy(var_8);
    // radius_eff_a = contact_data.radius_eff_a                                               <L 204>
    var_9 = &((var_contact_data).radius_eff_a);
    var_11 = wp::load(var_9);
    var_10 = wp::copy(var_11);
    // radius_eff_b = contact_data.radius_eff_b                                               <L 205>
    var_12 = &((var_contact_data).radius_eff_b);
    var_14 = wp::load(var_12);
    var_13 = wp::copy(var_14);
    // if type_a == GeoType.SPHERE or type_a == GeoType.CAPSULE:                              <L 209>
    var_17 = (var_1 == var_16);
    var_15 = var_17;
    if (!var_15) {
        var_19 = (var_1 == var_18);
        var_15 = var_15 || var_19;
    }
    if (var_15) {
        // contact_data.contact_point_center = contact_data.contact_point_center + normal * (radius_eff_a * 0.5)       <L 210>
        var_20 = &((var_contact_data).contact_point_center);
        var_22 = wp::mul(var_10, var_21);
        var_23 = wp::mul(var_7, var_22);
        var_25 = wp::load(var_20);
        var_24 = wp::add(var_25, var_23);
        var_contact_data.contact_point_center = var_24;
        // contact_data.contact_distance = contact_data.contact_distance - radius_eff_a       <L 211>
        var_26 = &((var_contact_data).contact_distance);
        var_28 = wp::load(var_26);
        var_27 = wp::sub(var_28, var_10);
        var_contact_data.contact_distance = var_27;
    }
    // if type_b == GeoType.SPHERE or type_b == GeoType.CAPSULE:                              <L 214>
    var_31 = (var_4 == var_30);
    var_29 = var_31;
    if (!var_29) {
        var_33 = (var_4 == var_32);
        var_29 = var_29 || var_33;
    }
    if (var_29) {
        // contact_data.contact_point_center = contact_data.contact_point_center - normal * (radius_eff_b * 0.5)       <L 215>
        var_34 = &((var_contact_data).contact_point_center);
        var_36 = wp::mul(var_13, var_35);
        var_37 = wp::mul(var_7, var_36);
        var_39 = wp::load(var_34);
        var_38 = wp::sub(var_39, var_37);
        var_contact_data.contact_point_center = var_38;
        // contact_data.contact_distance = contact_data.contact_distance - radius_eff_b       <L 216>
        var_40 = &((var_contact_data).contact_distance);
        var_42 = wp::load(var_40);
        var_41 = wp::sub(var_42, var_13);
        var_contact_data.contact_distance = var_41;
    }
    // is_discrete_a = is_discrete_shape(type_a)                                              <L 219>
    var_43 = is_discrete_shape_0(var_1);
    // is_discrete_b = is_discrete_shape(type_b)                                              <L 220>
    var_44 = is_discrete_shape_0(var_4);
    // is_axial_a = type_a == GeoType.CYLINDER or type_a == GeoType.CONE                      <L 221>
    var_47 = (var_1 == var_46);
    var_45 = var_47;
    if (!var_45) {
        var_49 = (var_1 == var_48);
        var_45 = var_45 || var_49;
    }
    // is_axial_b = type_b == GeoType.CYLINDER or type_b == GeoType.CONE                      <L 222>
    var_52 = (var_4 == var_51);
    var_50 = var_52;
    if (!var_50) {
        var_54 = (var_4 == var_53);
        var_50 = var_50 || var_54;
    }
    // if (is_discrete_a and is_axial_b) or (is_discrete_b and is_axial_a):                   <L 225>
    var_56 = var_43;
    if (var_56) {
        var_56 = var_56 && var_50;
    }
    var_55 = var_56;
    if (!var_55) {
        var_57 = var_44;
        if (var_57) {
            var_57 = var_57 && var_45;
        }
        var_55 = var_55 || var_57;
    }
    if (var_55) {
        // if is_discrete_a and is_axial_b:                                                   <L 227>
        var_58 = var_43;
        if (var_58) {
            var_58 = var_58 && var_50;
        }
        if (var_58) {
            // shape_axis = wp.quat_rotate(rot_b, wp.vec3(0.0, 0.0, 1.0))                     <L 228>
            var_62 = wp::vec_t<3, wp::float32>(var_59, var_60, var_61);
            var_63 = wp::quat_rotate(var_rot_b, var_62);
            // shape_radius = shape_b.scale[0]                                                <L 229>
            var_64 = &((var_shape_b).scale);
            var_67 = wp::load(var_64);
            var_66 = wp::extract(var_67, var_65);
            // shape_half_height = shape_b.scale[1]                                           <L 230>
            var_68 = &((var_shape_b).scale);
            var_71 = wp::load(var_68);
            var_70 = wp::extract(var_71, var_69);
            // is_cone = type_b == GeoType.CONE                                               <L 231>
            var_73 = (var_4 == var_72);
            // shape_pos = pos_b_adjusted                                                     <L 232>
            var_74 = wp::copy(var_pos_b_adjusted);
            // axial_normal = normal                                                          <L 233>
            var_75 = wp::copy(var_7);
        }
        if (!var_58) {
            // shape_axis = wp.quat_rotate(rot_a, wp.vec3(0.0, 0.0, 1.0))                     <L 235>
            var_79 = wp::vec_t<3, wp::float32>(var_76, var_77, var_78);
            var_80 = wp::quat_rotate(var_rot_a, var_79);
            // shape_radius = shape_a.scale[0]                                                <L 236>
            var_81 = &((var_shape_a).scale);
            var_84 = wp::load(var_81);
            var_83 = wp::extract(var_84, var_82);
            // shape_half_height = shape_a.scale[1]                                           <L 237>
            var_85 = &((var_shape_a).scale);
            var_88 = wp::load(var_85);
            var_87 = wp::extract(var_88, var_86);
            // is_cone = type_a == GeoType.CONE                                               <L 238>
            var_90 = (var_1 == var_89);
            // shape_pos = pos_a_adjusted                                                     <L 239>
            var_91 = wp::copy(var_pos_a_adjusted);
            // axial_normal = -normal  # Flip normal for shape A                              <L 240>
            var_92 = wp::neg(var_7);
        }
        var_93 = wp::where(var_58, var_63, var_80);
        var_94 = wp::where(var_58, var_66, var_83);
        var_95 = wp::where(var_58, var_70, var_87);
        var_96 = wp::where(var_58, var_73, var_90);
        var_97 = wp::where(var_58, var_74, var_91);
        var_98 = wp::where(var_58, var_75, var_92);
        // axis_normal_dot = wp.abs(wp.dot(shape_axis, axial_normal))                         <L 243>
        var_99 = wp::dot(var_93, var_98);
        var_100 = wp::abs(var_99);
        // is_rolling = False                                                                 <L 246>
        // if is_cone:                                                                        <L 247>
        if (var_96) {
            // cone_half_angle = wp.atan2(shape_radius, 2.0 * shape_half_height)              <L 249>
            var_103 = wp::mul(var_102, var_95);
            var_104 = wp::atan2(var_94, var_103);
            // tolerance_angle = wp.static(2.0 * wp.pi / 180.0)  # 2 degrees                  <L 250>
            // lower_threshold = wp.sin(cone_half_angle - tolerance_angle)                    <L 251>
            var_106 = wp::sub(var_104, var_105);
            var_107 = wp::sin(var_106);
            // upper_threshold = wp.sin(cone_half_angle + tolerance_angle)                    <L 252>
            var_108 = wp::add(var_104, var_105);
            var_109 = wp::sin(var_108);
            // if axis_normal_dot >= lower_threshold and axis_normal_dot <= upper_threshold:       <L 254>
            var_111 = (var_100 >= var_107);
            var_110 = var_111;
            if (var_110) {
                var_112 = (var_100 <= var_109);
                var_110 = var_110 && var_112;
            }
            if (var_110) {
                // is_rolling = True                                                          <L 255>
            }
            var_114 = wp::where(var_110, var_113, var_101);
        }
        if (!var_96) {
            // perpendicular_threshold = wp.static(math.sin(2.0 * math.pi / 180.0))           <L 258>
            // if axis_normal_dot <= perpendicular_threshold:                                 <L 259>
            var_116 = (var_100 <= var_115);
            if (var_116) {
                // is_rolling = True                                                          <L 260>
            }
            var_118 = wp::where(var_116, var_117, var_101);
        }
        var_119 = wp::where(var_96, var_114, var_118);
        // if is_rolling:                                                                     <L 263>
        if (var_119) {
            // projection_plane_normal = wp.normalize(wp.cross(shape_axis, axial_normal))       <L 264>
            var_120 = wp::cross(var_93, var_98);
            var_121 = wp::normalize(var_120);
            // point_on_projection_plane = shape_pos                                          <L 265>
            var_122 = wp::copy(var_97);
            // projected_point = project_point_onto_plane(                                    <L 268>
            // contact_data.contact_point_center, point_on_projection_plane, projection_plane_normal       <L 269>
            var_123 = &((var_contact_data).contact_point_center);
            var_125 = wp::load(var_123);
            var_124 = project_point_onto_plane_0(var_125, var_122, var_121);
            // contact_data.contact_point_center = projected_point                            <L 273>
            var_contact_data.contact_point_center = var_124;
        }
    }
    // return contact_data                                                                    <L 275>
    return var_contact_data;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:532
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
    // def encode_oct(n: wp.vec3) -> wp.vec2:                                                 <L 533>
    // l1 = wp.abs(n[0]) + wp.abs(n[1]) + wp.abs(n[2])                                        <L 539>
    var_1 = wp::extract(var_n, var_0);
    var_2 = wp::abs(var_1);
    var_4 = wp::extract(var_n, var_3);
    var_5 = wp::abs(var_4);
    var_6 = wp::add(var_2, var_5);
    var_8 = wp::extract(var_n, var_7);
    var_9 = wp::abs(var_8);
    var_10 = wp::add(var_6, var_9);
    // if l1 < 1.0e-20:                                                                       <L 540>
    var_12 = (var_10 < var_11);
    if (var_12) {
        // return wp.vec2(0.0, 0.0)                                                           <L 541>
        var_15 = wp::vec_t<2, wp::float32>(var_13, var_14);
        return var_15;
    }
    // inv_l1 = 1.0 / l1                                                                      <L 542>
    var_17 = wp::div(var_16, var_10);
    // ox = n[0] * inv_l1                                                                     <L 543>
    var_19 = wp::extract(var_n, var_18);
    var_20 = wp::mul(var_19, var_17);
    // oy = n[1] * inv_l1                                                                     <L 544>
    var_22 = wp::extract(var_n, var_21);
    var_23 = wp::mul(var_22, var_17);
    // oz = n[2] * inv_l1                                                                     <L 545>
    var_25 = wp::extract(var_n, var_24);
    var_26 = wp::mul(var_25, var_17);
    // if oz < 0.0:                                                                           <L 547>
    var_28 = (var_26 < var_27);
    if (var_28) {
        // sign_x = 1.0                                                                       <L 548>
        // if ox < 0.0:                                                                       <L 549>
        var_31 = (var_20 < var_30);
        if (var_31) {
            // sign_x = -1.0                                                                  <L 550>
        }
        var_33 = wp::where(var_31, var_32, var_29);
        // sign_y = 1.0                                                                       <L 551>
        // if oy < 0.0:                                                                       <L 552>
        var_36 = (var_23 < var_35);
        if (var_36) {
            // sign_y = -1.0                                                                  <L 553>
        }
        var_38 = wp::where(var_36, var_37, var_34);
        // new_x = (1.0 - wp.abs(oy)) * sign_x                                                <L 554>
        var_40 = wp::abs(var_23);
        var_41 = wp::sub(var_39, var_40);
        var_42 = wp::mul(var_41, var_33);
        // new_y = (1.0 - wp.abs(ox)) * sign_y                                                <L 555>
        var_44 = wp::abs(var_20);
        var_45 = wp::sub(var_43, var_44);
        var_46 = wp::mul(var_45, var_38);
        // ox = new_x                                                                         <L 556>
        var_47 = wp::copy(var_42);
        // oy = new_y                                                                         <L 557>
        var_48 = wp::copy(var_46);
    }
    var_49 = wp::where(var_28, var_47, var_20);
    var_50 = wp::where(var_28, var_48, var_23);
    // return wp.vec2(ox, oy)                                                                 <L 559>
    var_51 = wp::vec_t<2, wp::float32>(var_49, var_50);
    return var_51;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:1007
static CUDA_CALLABLE wp::int32 export_contact_to_buffer_0(
    wp::int32 var_shape_a,
    wp::int32 var_shape_b,
    wp::vec_t<3, wp::float32> var_position,
    wp::vec_t<3, wp::float32> var_normal,
    wp::float32 var_depth,
    wp::int32 var_fingerprint,
    GlobalContactReducerData_98513266 var_reducer_data)
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
    const wp::int32 var_8 = -1;
    const wp::int32 var_9 = 0;
    wp::float32 var_10;
    const wp::int32 var_11 = 1;
    wp::float32 var_12;
    const wp::int32 var_13 = 2;
    wp::float32 var_14;
    wp::vec_t<4, wp::float32> var_15;
    wp::array_t<wp::vec_t<4, wp::float32>>* var_16;
    wp::array_t<wp::vec_t<4, wp::float32>> var_17;
    wp::vec_t<2, wp::float32> var_18;
    wp::array_t<wp::vec_t<2, wp::float32>>* var_19;
    wp::array_t<wp::vec_t<2, wp::float32>> var_20;
    wp::vec_t<2, wp::int32> var_21;
    wp::array_t<wp::vec_t<2, wp::int32>>* var_22;
    wp::array_t<wp::vec_t<2, wp::int32>> var_23;
    wp::array_t<wp::int32>* var_24;
    wp::array_t<wp::int32> var_25;
    //---------
    // forward
    // def export_contact_to_buffer(                                                          <L 1008>
    // contact_id = wp.atomic_add(reducer_data.contact_count, 0, 1)                           <L 1033>
    var_0 = &((var_reducer_data).contact_count);
    var_4 = wp::load(var_0);
    var_3 = wp::atomic_add(var_4, var_1, var_2);
    // if contact_id >= reducer_data.capacity:                                                <L 1034>
    var_5 = &((var_reducer_data).capacity);
    var_7 = wp::load(var_5);
    var_6 = (var_3 >= var_7);
    if (var_6) {
        // return -1                                                                          <L 1035>
        return var_8;
    }
    // reducer_data.position_depth[contact_id] = wp.vec4(position[0], position[1], position[2], depth)       <L 1038>
    var_10 = wp::extract(var_position, var_9);
    var_12 = wp::extract(var_position, var_11);
    var_14 = wp::extract(var_position, var_13);
    var_15 = wp::vec_t<4, wp::float32>(var_10, var_12, var_14, var_depth);
    var_16 = &((var_reducer_data).position_depth);
    var_17 = wp::load(var_16);
    wp::array_store(var_17, var_3, var_15);
    // reducer_data.normal[contact_id] = encode_oct(normal)                                   <L 1039>
    var_18 = encode_oct_0(var_normal);
    var_19 = &((var_reducer_data).normal);
    var_20 = wp::load(var_19);
    wp::array_store(var_20, var_3, var_18);
    // reducer_data.shape_pairs[contact_id] = wp.vec2i(shape_a, shape_b)                      <L 1040>
    var_21 = wp::vec_t<2, wp::int32>(var_shape_a, var_shape_b);
    var_22 = &((var_reducer_data).shape_pairs);
    var_23 = wp::load(var_22);
    wp::array_store(var_23, var_3, var_21);
    // reducer_data.contact_fingerprints[contact_id] = fingerprint                            <L 1041>
    var_24 = &((var_reducer_data).contact_fingerprints);
    var_25 = wp::load(var_24);
    wp::array_store(var_25, var_3, var_fingerprint);
    // return contact_id                                                                      <L 1043>
    return var_3;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:0
static CUDA_CALLABLE void write_contact_to_reducer_0(
    ContactData_40360d7c var_contact_data,
    GlobalContactReducerData_98513266 var_reducer_data,
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/math/__init__.py:235
static CUDA_CALLABLE void orthonormal_basis_0(
    wp::vec_t<3, wp::float32> var_n,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    const wp::int32 var_2 = 2;
    wp::float32 var_3;
    const wp::float32 var_4 = 0.0;
    bool var_5;
    const wp::float32 var_6 = 1.0;
    const wp::float32 var_7 = 1.0;
    const wp::int32 var_8 = 2;
    wp::float32 var_9;
    wp::float32 var_10;
    wp::float32 var_11;
    const wp::int32 var_12 = 0;
    wp::float32 var_13;
    const wp::int32 var_14 = 1;
    wp::float32 var_15;
    wp::float32 var_16;
    wp::float32 var_17;
    const wp::float32 var_18 = 1.0;
    const wp::int32 var_19 = 0;
    wp::float32 var_20;
    const wp::int32 var_21 = 0;
    wp::float32 var_22;
    wp::float32 var_23;
    wp::float32 var_24;
    wp::float32 var_25;
    const wp::int32 var_26 = 0;
    wp::float32 var_27;
    const wp::int32 var_28 = 1;
    const wp::int32 var_29 = 0;
    wp::float32 var_30;
    const wp::int32 var_31 = 2;
    const wp::int32 var_32 = 0;
    const wp::int32 var_33 = 1;
    wp::float32 var_34;
    const wp::int32 var_35 = 1;
    wp::float32 var_36;
    wp::float32 var_37;
    wp::float32 var_38;
    const wp::float32 var_39 = 1.0;
    wp::float32 var_40;
    const wp::int32 var_41 = 1;
    const wp::int32 var_42 = 1;
    wp::float32 var_43;
    wp::float32 var_44;
    const wp::int32 var_45 = 2;
    const wp::float32 var_46 = 1.0;
    const wp::float32 var_47 = 1.0;
    const wp::int32 var_48 = 2;
    wp::float32 var_49;
    wp::float32 var_50;
    wp::float32 var_51;
    const wp::int32 var_52 = 0;
    wp::float32 var_53;
    wp::float32 var_54;
    const wp::int32 var_55 = 1;
    wp::float32 var_56;
    wp::float32 var_57;
    wp::float32 var_58;
    const wp::float32 var_59 = 1.0;
    const wp::int32 var_60 = 0;
    wp::float32 var_61;
    const wp::int32 var_62 = 0;
    wp::float32 var_63;
    wp::float32 var_64;
    wp::float32 var_65;
    wp::float32 var_66;
    const wp::int32 var_67 = 0;
    const wp::int32 var_68 = 1;
    const wp::int32 var_69 = 0;
    wp::float32 var_70;
    wp::float32 var_71;
    const wp::int32 var_72 = 2;
    const wp::int32 var_73 = 0;
    const wp::float32 var_74 = 1.0;
    const wp::int32 var_75 = 1;
    wp::float32 var_76;
    const wp::int32 var_77 = 1;
    wp::float32 var_78;
    wp::float32 var_79;
    wp::float32 var_80;
    wp::float32 var_81;
    const wp::int32 var_82 = 1;
    const wp::int32 var_83 = 1;
    wp::float32 var_84;
    wp::float32 var_85;
    const wp::int32 var_86 = 2;
    wp::float32 var_87;
    wp::float32 var_88;
    //---------
    // forward
    // def orthonormal_basis(n: wp.vec3):                                                     <L 236>
    // b1 = wp.vec3()                                                                         <L 252>
    var_0 = wp::vec_t<3, wp::float32>();
    // b2 = wp.vec3()                                                                         <L 253>
    var_1 = wp::vec_t<3, wp::float32>();
    // if n[2] < 0.0:                                                                         <L 254>
    var_3 = wp::extract(var_n, var_2);
    var_5 = (var_3 < var_4);
    if (var_5) {
        // a = 1.0 / (1.0 - n[2])                                                             <L 255>
        var_9 = wp::extract(var_n, var_8);
        var_10 = wp::sub(var_7, var_9);
        var_11 = wp::div(var_6, var_10);
        // b = n[0] * n[1] * a                                                                <L 256>
        var_13 = wp::extract(var_n, var_12);
        var_15 = wp::extract(var_n, var_14);
        var_16 = wp::mul(var_13, var_15);
        var_17 = wp::mul(var_16, var_11);
        // b1[0] = 1.0 - n[0] * n[0] * a                                                      <L 257>
        var_20 = wp::extract(var_n, var_19);
        var_22 = wp::extract(var_n, var_21);
        var_23 = wp::mul(var_20, var_22);
        var_24 = wp::mul(var_23, var_11);
        var_25 = wp::sub(var_18, var_24);
        wp::assign_inplace(var_0, var_26, var_25);
        // b1[1] = -b                                                                         <L 258>
        var_27 = wp::neg(var_17);
        wp::assign_inplace(var_0, var_28, var_27);
        // b1[2] = n[0]                                                                       <L 259>
        var_30 = wp::extract(var_n, var_29);
        wp::assign_inplace(var_0, var_31, var_30);
        // b2[0] = b                                                                          <L 261>
        wp::assign_inplace(var_1, var_32, var_17);
        // b2[1] = n[1] * n[1] * a - 1.0                                                      <L 262>
        var_34 = wp::extract(var_n, var_33);
        var_36 = wp::extract(var_n, var_35);
        var_37 = wp::mul(var_34, var_36);
        var_38 = wp::mul(var_37, var_11);
        var_40 = wp::sub(var_38, var_39);
        wp::assign_inplace(var_1, var_41, var_40);
        // b2[2] = -n[1]                                                                      <L 263>
        var_43 = wp::extract(var_n, var_42);
        var_44 = wp::neg(var_43);
        wp::assign_inplace(var_1, var_45, var_44);
    }
    if (!var_5) {
        // a = 1.0 / (1.0 + n[2])                                                             <L 265>
        var_49 = wp::extract(var_n, var_48);
        var_50 = wp::add(var_47, var_49);
        var_51 = wp::div(var_46, var_50);
        // b = -n[0] * n[1] * a                                                               <L 266>
        var_53 = wp::extract(var_n, var_52);
        var_54 = wp::neg(var_53);
        var_56 = wp::extract(var_n, var_55);
        var_57 = wp::mul(var_54, var_56);
        var_58 = wp::mul(var_57, var_51);
        // b1[0] = 1.0 - n[0] * n[0] * a                                                      <L 267>
        var_61 = wp::extract(var_n, var_60);
        var_63 = wp::extract(var_n, var_62);
        var_64 = wp::mul(var_61, var_63);
        var_65 = wp::mul(var_64, var_51);
        var_66 = wp::sub(var_59, var_65);
        wp::assign_inplace(var_0, var_67, var_66);
        // b1[1] = b                                                                          <L 268>
        wp::assign_inplace(var_0, var_68, var_58);
        // b1[2] = -n[0]                                                                      <L 269>
        var_70 = wp::extract(var_n, var_69);
        var_71 = wp::neg(var_70);
        wp::assign_inplace(var_0, var_72, var_71);
        // b2[0] = b                                                                          <L 271>
        wp::assign_inplace(var_1, var_73, var_58);
        // b2[1] = 1.0 - n[1] * n[1] * a                                                      <L 272>
        var_76 = wp::extract(var_n, var_75);
        var_78 = wp::extract(var_n, var_77);
        var_79 = wp::mul(var_76, var_78);
        var_80 = wp::mul(var_79, var_51);
        var_81 = wp::sub(var_74, var_80);
        wp::assign_inplace(var_1, var_82, var_81);
        // b2[2] = -n[1]                                                                      <L 273>
        var_84 = wp::extract(var_n, var_83);
        var_85 = wp::neg(var_84);
        wp::assign_inplace(var_1, var_86, var_85);
    }
    var_87 = wp::where(var_5, var_11, var_51);
    var_88 = wp::where(var_5, var_17, var_58);
    // return b1, b2                                                                          <L 275>
    ret_0 = var_0;
    ret_1 = var_1;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:621
static CUDA_CALLABLE void add_avoid_duplicates_vec2_0(
    wp::array_t<wp::vec_t<2, wp::float32>> var_arr,
    wp::int32 var_arr_count,
    wp::vec_t<2, wp::float32> var_vec,
    wp::float32 var_eps,
    wp::int32 & ret_0,
    bool & ret_1)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    bool var_1;
    const wp::int32 var_2 = 0;
    wp::vec_t<2, wp::float32>* var_3;
    wp::vec_t<2, wp::float32> var_4;
    wp::vec_t<2, wp::float32> var_5;
    wp::float32 var_6;
    bool var_7;
    const bool var_8 = false;
    const wp::int32 var_9 = 1;
    bool var_10;
    const wp::int32 var_11 = 1;
    wp::int32 var_12;
    wp::vec_t<2, wp::float32>* var_13;
    wp::vec_t<2, wp::float32> var_14;
    wp::vec_t<2, wp::float32> var_15;
    wp::float32 var_16;
    bool var_17;
    const bool var_18 = false;
    const wp::int32 var_19 = 1;
    wp::int32 var_20;
    const bool var_21 = true;
    //---------
    // forward
    // def add_avoid_duplicates_vec2(arr: wp.array[wp.vec2], arr_count: int, vec: wp.vec2, eps: float) -> tuple[int, bool]:       <L 622>
    // if arr_count > 0:                                                                      <L 637>
    var_1 = (var_arr_count > var_0);
    if (var_1) {
        // if wp.length_sq(arr[0] - vec) < eps:                                               <L 638>
        var_3 = wp::address(var_arr, var_2);
        var_5 = wp::load(var_3);
        var_4 = wp::sub(var_5, var_vec);
        var_6 = wp::length_sq(var_4);
        var_7 = (var_6 < var_eps);
        if (var_7) {
            // return arr_count, False                                                        <L 639>
            ret_0 = var_arr_count;
            ret_1 = var_8;
            return;
        }
    }
    // if arr_count > 1:                                                                      <L 641>
    var_10 = (var_arr_count > var_9);
    if (var_10) {
        // if wp.length_sq(arr[arr_count - 1] - vec) < eps:                                   <L 642>
        var_12 = wp::sub(var_arr_count, var_11);
        var_13 = wp::address(var_arr, var_12);
        var_15 = wp::load(var_13);
        var_14 = wp::sub(var_15, var_vec);
        var_16 = wp::length_sq(var_14);
        var_17 = (var_16 < var_eps);
        if (var_17) {
            // return arr_count, False                                                        <L 643>
            ret_0 = var_arr_count;
            ret_1 = var_18;
            return;
        }
    }
    // arr[arr_count] = vec                                                                   <L 645>
    wp::array_store(var_arr, var_arr_count, var_vec);
    // return arr_count + 1, True                                                             <L 646>
    var_20 = wp::add(var_arr_count, var_19);
    ret_0 = var_20;
    ret_1 = var_21;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:141
static CUDA_CALLABLE IncrementalPlaneTracker_8af6ef33 update_incremental_plane_tracker_0(
    IncrementalPlaneTracker_8af6ef33 var_tracker,
    wp::vec_t<3, wp::float32> var_current_point,
    wp::int32 var_current_point_id)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    bool var_1;
    const wp::float32 var_2 = 0.0;
    const wp::int32 var_3 = 1;
    bool var_4;
    wp::vec_t<3, wp::float32>* var_5;
    wp::vec_t<3, wp::float32>* var_6;
    wp::vec_t<3, wp::float32> var_7;
    wp::vec_t<3, wp::float32> var_8;
    wp::vec_t<3, wp::float32> var_9;
    wp::vec_t<3, wp::float32>* var_10;
    wp::vec_t<3, wp::float32> var_11;
    wp::vec_t<3, wp::float32> var_12;
    wp::vec_t<3, wp::float32> var_13;
    wp::float32 var_14;
    wp::float32* var_15;
    bool var_16;
    wp::float32 var_17;
    //---------
    // forward
    // def update_incremental_plane_tracker(                                                  <L 142>
    // if current_point_id == 0:                                                              <L 150>
    var_1 = (var_current_point_id == var_0);
    if (var_1) {
        // tracker.reference_point = current_point                                            <L 151>
        var_tracker.reference_point = var_current_point;
        // tracker.largest_area_sq = 0.0                                                      <L 152>
        var_tracker.largest_area_sq = var_2;
    }
    if (!var_1) {
        // elif current_point_id == 1:                                                        <L 153>
        var_4 = (var_current_point_id == var_3);
        if (var_4) {
            // tracker.previous_point = current_point                                         <L 154>
            var_tracker.previous_point = var_current_point;
        }
        if (!var_4) {
            // edge1 = tracker.previous_point - tracker.reference_point                       <L 156>
            var_5 = &((var_tracker).previous_point);
            var_6 = &((var_tracker).reference_point);
            var_8 = wp::load(var_5);
            var_9 = wp::load(var_6);
            var_7 = wp::sub(var_8, var_9);
            // edge2 = current_point - tracker.reference_point                                <L 157>
            var_10 = &((var_tracker).reference_point);
            var_12 = wp::load(var_10);
            var_11 = wp::sub(var_current_point, var_12);
            // cross = wp.cross(edge1, edge2)                                                 <L 158>
            var_13 = wp::cross(var_7, var_11);
            // area_sq = wp.dot(cross, cross)                                                 <L 159>
            var_14 = wp::dot(var_13, var_13);
            // if area_sq > tracker.largest_area_sq:                                          <L 160>
            var_15 = &((var_tracker).largest_area_sq);
            var_17 = wp::load(var_15);
            var_16 = (var_14 > var_17);
            if (var_16) {
                // tracker.largest_area_sq = area_sq                                          <L 161>
                var_tracker.largest_area_sq = var_14;
                // tracker.normal = cross                                                     <L 162>
                var_tracker.normal = var_13;
            }
            // tracker.previous_point = current_point                                         <L 163>
            var_tracker.previous_point = var_current_point;
        }
    }
    // return tracker                                                                         <L 164>
    return var_tracker;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:167
static CUDA_CALLABLE wp::vec_t<3, wp::float32> compute_line_segment_projector_normal_0(
    wp::vec_t<3, wp::float32> var_segment_dir,
    wp::vec_t<3, wp::float32> var_reference_normal)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::float32 var_2;
    const wp::float32 var_3 = 1e-12;
    bool var_4;
    wp::vec_t<3, wp::float32> var_5;
    wp::vec_t<3, wp::float32> var_6;
    //---------
    // forward
    // def compute_line_segment_projector_normal(                                             <L 168>
    // right = wp.cross(segment_dir, reference_normal)                                        <L 183>
    var_0 = wp::cross(var_segment_dir, var_reference_normal);
    // normal = wp.cross(right, segment_dir)                                                  <L 184>
    var_1 = wp::cross(var_0, var_segment_dir);
    // length = wp.length(normal)                                                             <L 185>
    var_2 = wp::length(var_1);
    // return normal / length if length > 1.0e-12 else reference_normal                       <L 186>
    var_4 = (var_2 > var_3);
    if (var_4) {
        var_5 = wp::div(var_1, var_2);
    }
    if (!var_4) {
    }
    var_6 = wp::where(var_4, var_5, var_reference_normal);
    return var_6;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:189
static CUDA_CALLABLE void create_body_projectors_0(
    IncrementalPlaneTracker_8af6ef33 var_plane_tracker_a,
    wp::vec_t<3, wp::float32> var_anchor_point_a,
    IncrementalPlaneTracker_8af6ef33 var_plane_tracker_b,
    wp::vec_t<3, wp::float32> var_anchor_point_b,
    wp::vec_t<3, wp::float32> var_contact_normal,
    BodyProjector_d067bb7a & ret_0,
    BodyProjector_d067bb7a & ret_1)
{
    //---------
    // primal vars
    BodyProjector_d067bb7a var_0;
    BodyProjector_d067bb7a var_1;
    bool var_2;
    wp::float32* var_3;
    const wp::float32 var_4 = 0.0;
    bool var_5;
    wp::float32 var_6;
    wp::float32* var_7;
    const wp::float32 var_8 = 0.0;
    bool var_9;
    wp::float32 var_10;
    wp::vec_t<3, wp::float32>* var_11;
    wp::vec_t<3, wp::float32>* var_12;
    wp::vec_t<3, wp::float32> var_13;
    wp::vec_t<3, wp::float32> var_14;
    wp::vec_t<3, wp::float32> var_15;
    wp::vec_t<3, wp::float32>* var_16;
    wp::vec_t<3, wp::float32>* var_17;
    wp::vec_t<3, wp::float32> var_18;
    wp::vec_t<3, wp::float32> var_19;
    wp::vec_t<3, wp::float32> var_20;
    const wp::float32 var_21 = 0.5;
    wp::vec_t<3, wp::float32>* var_22;
    wp::vec_t<3, wp::float32>* var_23;
    wp::vec_t<3, wp::float32> var_24;
    wp::vec_t<3, wp::float32> var_25;
    wp::vec_t<3, wp::float32> var_26;
    wp::vec_t<3, wp::float32> var_27;
    wp::vec_t<3, wp::float32> var_28;
    wp::vec_t<3, wp::float32>* var_29;
    wp::float32 var_30;
    wp::vec_t<3, wp::float32> var_31;
    wp::float32 var_32;
    const wp::float32 var_33 = 0.5;
    wp::vec_t<3, wp::float32>* var_34;
    wp::vec_t<3, wp::float32>* var_35;
    wp::vec_t<3, wp::float32> var_36;
    wp::vec_t<3, wp::float32> var_37;
    wp::vec_t<3, wp::float32> var_38;
    wp::vec_t<3, wp::float32> var_39;
    wp::vec_t<3, wp::float32> var_40;
    wp::vec_t<3, wp::float32>* var_41;
    wp::float32 var_42;
    wp::vec_t<3, wp::float32> var_43;
    wp::float32 var_44;
    wp::float32* var_45;
    const wp::float32 var_46 = 0.0;
    bool var_47;
    wp::float32 var_48;
    const wp::float32 var_49 = 1e-12;
    wp::float32* var_50;
    wp::float32 var_51;
    wp::float32 var_52;
    wp::float32 var_53;
    wp::vec_t<3, wp::float32>* var_54;
    wp::vec_t<3, wp::float32> var_55;
    wp::vec_t<3, wp::float32> var_56;
    wp::vec_t<3, wp::float32>* var_57;
    wp::float32 var_58;
    wp::vec_t<3, wp::float32> var_59;
    wp::float32 var_60;
    wp::float32* var_61;
    const wp::float32 var_62 = 0.0;
    bool var_63;
    wp::float32 var_64;
    const wp::float32 var_65 = 1e-12;
    wp::float32* var_66;
    wp::float32 var_67;
    wp::float32 var_68;
    wp::float32 var_69;
    wp::vec_t<3, wp::float32>* var_70;
    wp::vec_t<3, wp::float32> var_71;
    wp::vec_t<3, wp::float32> var_72;
    wp::vec_t<3, wp::float32>* var_73;
    wp::float32 var_74;
    wp::vec_t<3, wp::float32> var_75;
    wp::float32 var_76;
    wp::float32 var_77;
    wp::float32* var_78;
    const wp::float32 var_79 = 0.0;
    bool var_80;
    wp::float32 var_81;
    wp::vec_t<3, wp::float32>* var_82;
    wp::vec_t<3, wp::float32>* var_83;
    wp::vec_t<3, wp::float32> var_84;
    wp::vec_t<3, wp::float32> var_85;
    wp::vec_t<3, wp::float32> var_86;
    const wp::float32 var_87 = 0.5;
    wp::vec_t<3, wp::float32>* var_88;
    wp::vec_t<3, wp::float32>* var_89;
    wp::vec_t<3, wp::float32> var_90;
    wp::vec_t<3, wp::float32> var_91;
    wp::vec_t<3, wp::float32> var_92;
    wp::vec_t<3, wp::float32> var_93;
    wp::vec_t<3, wp::float32>* var_94;
    wp::vec_t<3, wp::float32> var_95;
    wp::vec_t<3, wp::float32> var_96;
    wp::vec_t<3, wp::float32>* var_97;
    wp::float32 var_98;
    wp::vec_t<3, wp::float32> var_99;
    wp::float32 var_100;
    wp::vec_t<3, wp::float32> var_101;
    wp::float32* var_102;
    const wp::float32 var_103 = 0.0;
    bool var_104;
    wp::float32 var_105;
    wp::vec_t<3, wp::float32>* var_106;
    wp::vec_t<3, wp::float32>* var_107;
    wp::vec_t<3, wp::float32> var_108;
    wp::vec_t<3, wp::float32> var_109;
    wp::vec_t<3, wp::float32> var_110;
    const wp::float32 var_111 = 0.5;
    wp::vec_t<3, wp::float32>* var_112;
    wp::vec_t<3, wp::float32>* var_113;
    wp::vec_t<3, wp::float32> var_114;
    wp::vec_t<3, wp::float32> var_115;
    wp::vec_t<3, wp::float32> var_116;
    wp::vec_t<3, wp::float32> var_117;
    wp::vec_t<3, wp::float32>* var_118;
    wp::vec_t<3, wp::float32> var_119;
    wp::vec_t<3, wp::float32> var_120;
    wp::vec_t<3, wp::float32>* var_121;
    wp::float32 var_122;
    wp::vec_t<3, wp::float32> var_123;
    wp::float32 var_124;
    wp::vec_t<3, wp::float32> var_125;
    wp::vec_t<3, wp::float32> var_126;
    //---------
    // forward
    // def create_body_projectors(                                                            <L 190>
    // projector_a = BodyProjector()                                                          <L 197>
    var_0 = BodyProjector_d067bb7a();
    // projector_b = BodyProjector()                                                          <L 198>
    var_1 = BodyProjector_d067bb7a();
    // if plane_tracker_a.largest_area_sq == 0.0 and plane_tracker_b.largest_area_sq == 0.0:       <L 200>
    var_3 = &((var_plane_tracker_a).largest_area_sq);
    var_6 = wp::load(var_3);
    var_5 = (var_6 == var_4);
    var_2 = var_5;
    if (var_2) {
        var_7 = &((var_plane_tracker_b).largest_area_sq);
        var_10 = wp::load(var_7);
        var_9 = (var_10 == var_8);
        var_2 = var_2 && var_9;
    }
    if (var_2) {
        // dir_a = plane_tracker_a.previous_point - plane_tracker_a.reference_point           <L 202>
        var_11 = &((var_plane_tracker_a).previous_point);
        var_12 = &((var_plane_tracker_a).reference_point);
        var_14 = wp::load(var_11);
        var_15 = wp::load(var_12);
        var_13 = wp::sub(var_14, var_15);
        // dir_b = plane_tracker_b.previous_point - plane_tracker_b.reference_point           <L 203>
        var_16 = &((var_plane_tracker_b).previous_point);
        var_17 = &((var_plane_tracker_b).reference_point);
        var_19 = wp::load(var_16);
        var_20 = wp::load(var_17);
        var_18 = wp::sub(var_19, var_20);
        // point_on_plane_a = 0.5 * (plane_tracker_a.reference_point + plane_tracker_a.previous_point)       <L 205>
        var_22 = &((var_plane_tracker_a).reference_point);
        var_23 = &((var_plane_tracker_a).previous_point);
        var_25 = wp::load(var_22);
        var_26 = wp::load(var_23);
        var_24 = wp::add(var_25, var_26);
        var_27 = wp::mul(var_21, var_24);
        // projector_a.normal = compute_line_segment_projector_normal(dir_a, contact_normal)       <L 206>
        var_28 = compute_line_segment_projector_normal_0(var_13, var_contact_normal);
        var_0.normal = var_28;
        // projector_a.plane_d = -wp.dot(point_on_plane_a, projector_a.normal)                <L 207>
        var_29 = &((var_0).normal);
        var_31 = wp::load(var_29);
        var_30 = wp::dot(var_27, var_31);
        var_32 = wp::neg(var_30);
        var_0.plane_d = var_32;
        // point_on_plane_b = 0.5 * (plane_tracker_b.reference_point + plane_tracker_b.previous_point)       <L 209>
        var_34 = &((var_plane_tracker_b).reference_point);
        var_35 = &((var_plane_tracker_b).previous_point);
        var_37 = wp::load(var_34);
        var_38 = wp::load(var_35);
        var_36 = wp::add(var_37, var_38);
        var_39 = wp::mul(var_33, var_36);
        // projector_b.normal = compute_line_segment_projector_normal(dir_b, contact_normal)       <L 210>
        var_40 = compute_line_segment_projector_normal_0(var_18, var_contact_normal);
        var_1.normal = var_40;
        // projector_b.plane_d = -wp.dot(point_on_plane_b, projector_b.normal)                <L 211>
        var_41 = &((var_1).normal);
        var_43 = wp::load(var_41);
        var_42 = wp::dot(var_39, var_43);
        var_44 = wp::neg(var_42);
        var_1.plane_d = var_44;
        // return projector_a, projector_b                                                    <L 213>
        ret_0 = var_0;
        ret_1 = var_1;
        return;
    }
    // if plane_tracker_a.largest_area_sq > 0.0:                                              <L 215>
    var_45 = &((var_plane_tracker_a).largest_area_sq);
    var_48 = wp::load(var_45);
    var_47 = (var_48 > var_46);
    if (var_47) {
        // len_n = wp.sqrt(wp.max(1.0e-12, plane_tracker_a.largest_area_sq))                  <L 216>
        var_50 = &((var_plane_tracker_a).largest_area_sq);
        var_52 = wp::load(var_50);
        var_51 = wp::max(var_49, var_52);
        var_53 = wp::sqrt(var_51);
        // projector_a.normal = plane_tracker_a.normal / len_n                                <L 217>
        var_54 = &((var_plane_tracker_a).normal);
        var_56 = wp::load(var_54);
        var_55 = wp::div(var_56, var_53);
        var_0.normal = var_55;
        // projector_a.plane_d = -wp.dot(anchor_point_a, projector_a.normal)                  <L 218>
        var_57 = &((var_0).normal);
        var_59 = wp::load(var_57);
        var_58 = wp::dot(var_anchor_point_a, var_59);
        var_60 = wp::neg(var_58);
        var_0.plane_d = var_60;
    }
    // if plane_tracker_b.largest_area_sq > 0.0:                                              <L 219>
    var_61 = &((var_plane_tracker_b).largest_area_sq);
    var_64 = wp::load(var_61);
    var_63 = (var_64 > var_62);
    if (var_63) {
        // len_n = wp.sqrt(wp.max(1.0e-12, plane_tracker_b.largest_area_sq))                  <L 220>
        var_66 = &((var_plane_tracker_b).largest_area_sq);
        var_68 = wp::load(var_66);
        var_67 = wp::max(var_65, var_68);
        var_69 = wp::sqrt(var_67);
        // projector_b.normal = plane_tracker_b.normal / len_n                                <L 221>
        var_70 = &((var_plane_tracker_b).normal);
        var_72 = wp::load(var_70);
        var_71 = wp::div(var_72, var_69);
        var_1.normal = var_71;
        // projector_b.plane_d = -wp.dot(anchor_point_b, projector_b.normal)                  <L 222>
        var_73 = &((var_1).normal);
        var_75 = wp::load(var_73);
        var_74 = wp::dot(var_anchor_point_b, var_75);
        var_76 = wp::neg(var_74);
        var_1.plane_d = var_76;
    }
    var_77 = wp::where(var_63, var_69, var_53);
    // if plane_tracker_a.largest_area_sq == 0.0:                                             <L 224>
    var_78 = &((var_plane_tracker_a).largest_area_sq);
    var_81 = wp::load(var_78);
    var_80 = (var_81 == var_79);
    if (var_80) {
        // dir = plane_tracker_a.previous_point - plane_tracker_a.reference_point             <L 225>
        var_82 = &((var_plane_tracker_a).previous_point);
        var_83 = &((var_plane_tracker_a).reference_point);
        var_85 = wp::load(var_82);
        var_86 = wp::load(var_83);
        var_84 = wp::sub(var_85, var_86);
        // point_on_plane_a = 0.5 * (plane_tracker_a.reference_point + plane_tracker_a.previous_point)       <L 226>
        var_88 = &((var_plane_tracker_a).reference_point);
        var_89 = &((var_plane_tracker_a).previous_point);
        var_91 = wp::load(var_88);
        var_92 = wp::load(var_89);
        var_90 = wp::add(var_91, var_92);
        var_93 = wp::mul(var_87, var_90);
        // projector_a.normal = compute_line_segment_projector_normal(dir, projector_b.normal)       <L 227>
        var_94 = &((var_1).normal);
        var_96 = wp::load(var_94);
        var_95 = compute_line_segment_projector_normal_0(var_84, var_96);
        var_0.normal = var_95;
        // projector_a.plane_d = -wp.dot(point_on_plane_a, projector_a.normal)                <L 228>
        var_97 = &((var_0).normal);
        var_99 = wp::load(var_97);
        var_98 = wp::dot(var_93, var_99);
        var_100 = wp::neg(var_98);
        var_0.plane_d = var_100;
    }
    var_101 = wp::where(var_80, var_93, var_27);
    // if plane_tracker_b.largest_area_sq == 0.0:                                             <L 230>
    var_102 = &((var_plane_tracker_b).largest_area_sq);
    var_105 = wp::load(var_102);
    var_104 = (var_105 == var_103);
    if (var_104) {
        // dir = plane_tracker_b.previous_point - plane_tracker_b.reference_point             <L 231>
        var_106 = &((var_plane_tracker_b).previous_point);
        var_107 = &((var_plane_tracker_b).reference_point);
        var_109 = wp::load(var_106);
        var_110 = wp::load(var_107);
        var_108 = wp::sub(var_109, var_110);
        // point_on_plane_b = 0.5 * (plane_tracker_b.reference_point + plane_tracker_b.previous_point)       <L 232>
        var_112 = &((var_plane_tracker_b).reference_point);
        var_113 = &((var_plane_tracker_b).previous_point);
        var_115 = wp::load(var_112);
        var_116 = wp::load(var_113);
        var_114 = wp::add(var_115, var_116);
        var_117 = wp::mul(var_111, var_114);
        // projector_b.normal = compute_line_segment_projector_normal(dir, projector_a.normal)       <L 233>
        var_118 = &((var_0).normal);
        var_120 = wp::load(var_118);
        var_119 = compute_line_segment_projector_normal_0(var_108, var_120);
        var_1.normal = var_119;
        // projector_b.plane_d = -wp.dot(point_on_plane_b, projector_b.normal)                <L 234>
        var_121 = &((var_1).normal);
        var_123 = wp::load(var_121);
        var_122 = wp::dot(var_117, var_123);
        var_124 = wp::neg(var_122);
        var_1.plane_d = var_124;
    }
    var_125 = wp::where(var_104, var_117, var_39);
    var_126 = wp::where(var_104, var_108, var_84);
    // return projector_a, projector_b                                                        <L 236>
    ret_0 = var_0;
    ret_1 = var_1;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:43
static CUDA_CALLABLE bool excess_normal_deviation_0(
    wp::vec_t<3, wp::float32> var_dir_a,
    wp::vec_t<3, wp::float32> var_dir_b)
{
    //---------
    // primal vars
    wp::float32 var_0;
    wp::float32 var_1;
    const wp::float32 var_2 = 0.9993908270190958;
    bool var_3;
    //---------
    // forward
    // def excess_normal_deviation(dir_a: wp.vec3, dir_b: wp.vec3) -> bool:                   <L 44>
    // dot = wp.abs(wp.dot(dir_a, dir_b))                                                     <L 58>
    var_0 = wp::dot(var_dir_a, var_dir_b);
    var_1 = wp::abs(var_0);
    // return dot < COS_TILT_ANGLE                                                            <L 59>
    var_3 = (var_1 < var_2);
    return var_3;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:62
static CUDA_CALLABLE wp::float32 signed_area_0(
    wp::vec_t<2, wp::float32> var_a,
    wp::vec_t<2, wp::float32> var_b,
    wp::vec_t<2, wp::float32> var_query_point)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    wp::float32 var_1;
    const wp::int32 var_2 = 0;
    wp::float32 var_3;
    wp::float32 var_4;
    const wp::int32 var_5 = 1;
    wp::float32 var_6;
    const wp::int32 var_7 = 1;
    wp::float32 var_8;
    wp::float32 var_9;
    wp::float32 var_10;
    const wp::int32 var_11 = 1;
    wp::float32 var_12;
    const wp::int32 var_13 = 1;
    wp::float32 var_14;
    wp::float32 var_15;
    const wp::int32 var_16 = 0;
    wp::float32 var_17;
    const wp::int32 var_18 = 0;
    wp::float32 var_19;
    wp::float32 var_20;
    wp::float32 var_21;
    wp::float32 var_22;
    //---------
    // forward
    // def signed_area(a: wp.vec2, b: wp.vec2, query_point: wp.vec2) -> float:                <L 63>
    // return (b[0] - a[0]) * (query_point[1] - a[1]) - (b[1] - a[1]) * (query_point[0] - a[0])       <L 84>
    var_1 = wp::extract(var_b, var_0);
    var_3 = wp::extract(var_a, var_2);
    var_4 = wp::sub(var_1, var_3);
    var_6 = wp::extract(var_query_point, var_5);
    var_8 = wp::extract(var_a, var_7);
    var_9 = wp::sub(var_6, var_8);
    var_10 = wp::mul(var_4, var_9);
    var_12 = wp::extract(var_b, var_11);
    var_14 = wp::extract(var_a, var_13);
    var_15 = wp::sub(var_12, var_14);
    var_17 = wp::extract(var_query_point, var_16);
    var_19 = wp::extract(var_a, var_18);
    var_20 = wp::sub(var_17, var_19);
    var_21 = wp::mul(var_15, var_20);
    var_22 = wp::sub(var_10, var_21);
    return var_22;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:263
static CUDA_CALLABLE wp::vec_t<2, wp::float32> intersection_point_0(
    wp::vec_t<2, wp::float32> var_trim_seg_start,
    wp::vec_t<2, wp::float32> var_trim_seg_end,
    wp::vec_t<2, wp::float32> var_a,
    wp::vec_t<2, wp::float32> var_b)
{
    //---------
    // primal vars
    wp::float32 var_0;
    wp::float32 var_1;
    wp::float32 var_2;
    wp::float32 var_3;
    wp::float32 var_4;
    wp::float32 var_5;
    const wp::float32 var_6 = 1.0;
    wp::float32 var_7;
    wp::vec_t<2, wp::float32> var_8;
    wp::vec_t<2, wp::float32> var_9;
    wp::vec_t<2, wp::float32> var_10;
    //---------
    // forward
    // def intersection_point(trim_seg_start: wp.vec2, trim_seg_end: wp.vec2, a: wp.vec2, b: wp.vec2) -> wp.vec2:       <L 264>
    // signed_a = signed_area(trim_seg_start, trim_seg_end, a)                                <L 281>
    var_0 = signed_area_0(var_trim_seg_start, var_trim_seg_end, var_a);
    // signed_b = signed_area(trim_seg_start, trim_seg_end, b)                                <L 282>
    var_1 = signed_area_0(var_trim_seg_start, var_trim_seg_end, var_b);
    // interp_ab = wp.abs(signed_a) / wp.abs(signed_a - signed_b)                             <L 283>
    var_2 = wp::abs(var_0);
    var_3 = wp::sub(var_0, var_1);
    var_4 = wp::abs(var_3);
    var_5 = wp::div(var_2, var_4);
    // return (1.0 - interp_ab) * a + interp_ab * b                                           <L 286>
    var_7 = wp::sub(var_6, var_5);
    var_8 = wp::mul(var_7, var_a);
    var_9 = wp::mul(var_5, var_b);
    var_10 = wp::add(var_8, var_9);
    return var_10;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:289
static CUDA_CALLABLE void insert_vec2_0(
    wp::array_t<wp::vec_t<2, wp::float32>> var_arr,
    wp::int32 var_arr_count,
    wp::int32 var_index,
    wp::vec_t<2, wp::float32> var_element)
{
    //---------
    // primal vars
    wp::int32 var_0;
    bool var_1;
    const wp::int32 var_2 = 1;
    wp::int32 var_3;
    wp::vec_t<2, wp::float32>* var_4;
    wp::vec_t<2, wp::float32> var_5;
    const wp::int32 var_6 = 1;
    wp::int32 var_7;
    //---------
    // forward
    // def insert_vec2(arr: wp.array[wp.vec2], arr_count: int, index: int, element: wp.vec2):       <L 290>
    // i = arr_count                                                                          <L 300>
    var_0 = wp::copy(var_arr_count);
    // while i > index:                                                                       <L 301>
    start_while_0:;
    var_1 = (var_0 > var_index);
    if ((var_1) == false) goto end_while_0;
        // arr[i] = arr[i - 1]                                                                <L 302>
        var_3 = wp::sub(var_0, var_2);
        var_4 = wp::address(var_arr, var_3);
        var_5 = wp::load(var_4);
        wp::array_store(var_arr, var_0, var_5);
        // i -= 1                                                                             <L 303>
        var_7 = wp::sub(var_0, var_6);
        wp::assign(var_0, var_7);
    goto start_while_0;
    end_while_0:;
    // arr[index] = element                                                                   <L 304>
    wp::array_store(var_arr, var_index, var_element);
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:307
static CUDA_CALLABLE wp::int32 trim_in_place_0(
    wp::vec_t<2, wp::float32> var_trim_seg_start,
    wp::vec_t<2, wp::float32> var_trim_seg_end,
    wp::array_t<wp::vec_t<2, wp::float32>> var_loop,
    wp::int32 var_loop_count)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 3;
    bool var_1;
    const wp::float32 var_2 = 0.0;
    const wp::float32 var_3 = 0.0;
    wp::vec_t<2, wp::float32> var_4;
    const wp::int32 var_5 = -1;
    wp::int32 var_6;
    const wp::float32 var_7 = 0.0;
    const wp::float32 var_8 = 0.0;
    wp::vec_t<2, wp::float32> var_9;
    const wp::int32 var_10 = -1;
    wp::int32 var_11;
    const bool var_12 = false;
    bool var_13;
    const wp::int32 var_14 = 0;
    wp::vec_t<2, wp::float32>* var_15;
    wp::float32 var_16;
    wp::vec_t<2, wp::float32> var_17;
    const wp::float32 var_18 = 0.0;
    bool var_19;
    bool var_20;
    wp::range_t var_21;
    wp::int32 var_22;
    const wp::int32 var_23 = 1;
    wp::int32 var_24;
    wp::int32 var_25;
    wp::vec_t<2, wp::float32>* var_26;
    wp::float32 var_27;
    wp::vec_t<2, wp::float32> var_28;
    const wp::float32 var_29 = 0.0;
    bool var_30;
    bool var_31;
    wp::vec_t<2, wp::float32>* var_32;
    wp::vec_t<2, wp::float32>* var_33;
    wp::vec_t<2, wp::float32> var_34;
    wp::vec_t<2, wp::float32> var_35;
    wp::vec_t<2, wp::float32> var_36;
    const wp::int32 var_37 = 0;
    bool var_38;
    wp::int32 var_39;
    bool var_40;
    wp::vec_t<2, wp::float32> var_41;
    wp::int32 var_42;
    wp::vec_t<2, wp::float32> var_43;
    wp::vec_t<2, wp::float32> var_44;
    wp::int32 var_45;
    wp::vec_t<2, wp::float32> var_46;
    wp::int32 var_47;
    bool var_48;
    wp::vec_t<2, wp::float32> var_49;
    wp::int32 var_50;
    wp::vec_t<2, wp::float32> var_51;
    wp::int32 var_52;
    bool var_53;
    bool var_54;
    bool var_55;
    const wp::int32 var_56 = 0;
    bool var_57;
    const wp::int32 var_58 = 0;
    bool var_59;
    const wp::int32 var_60 = -1;
    wp::int32 var_61;
    wp::int32 var_62;
    const wp::int32 var_63 = 0;
    wp::int32 var_64;
    bool var_65;
    const wp::int32 var_66 = 1;
    wp::int32 var_67;
    wp::vec_t<2, wp::float32>* var_68;
    wp::vec_t<2, wp::float32> var_69;
    wp::int32 var_70;
    bool var_71;
    bool var_72;
    bool var_73;
    bool var_74;
    wp::vec_t<2, wp::float32> var_75;
    bool var_76;
    bool var_77;
    bool var_78;
    const wp::int32 var_79 = 1;
    wp::int32 var_80;
    const wp::int32 var_81 = 1;
    wp::int32 var_82;
    const wp::int32 var_83 = 1;
    wp::int32 var_84;
    const wp::int32 var_85 = 1;
    wp::int32 var_86;
    const wp::int32 var_87 = 1;
    wp::int32 var_88;
    const wp::int32 var_89 = 1;
    wp::int32 var_90;
    wp::int32 var_91;
    wp::int32 var_92;
    wp::int32 var_93;
    wp::int32 var_94;
    wp::int32 var_95;
    bool var_96;
    wp::int32 var_97;
    wp::int32 var_98;
    bool var_99;
    wp::int32 var_100;
    wp::int32 var_101;
    wp::int32 var_102;
    const wp::int32 var_103 = 1;
    wp::int32 var_104;
    const wp::int32 var_105 = 1;
    wp::int32 var_106;
    const wp::int32 var_107 = 0;
    wp::int32 var_108;
    wp::int32 var_109;
    wp::int32 var_110;
    wp::int32 var_111;
    //---------
    // forward
    // def trim_in_place(                                                                     <L 308>
    // if loop_count < 3:                                                                     <L 328>
    var_1 = (var_loop_count < var_0);
    if (var_1) {
        // return loop_count                                                                  <L 329>
        return var_loop_count;
    }
    // intersection_a = wp.vec2(0.0, 0.0)                                                     <L 331>
    var_4 = wp::vec_t<2, wp::float32>(var_2, var_3);
    // change_a = int(-1)                                                                     <L 332>
    var_6 = wp::int(var_5);
    // intersection_b = wp.vec2(0.0, 0.0)                                                     <L 333>
    var_9 = wp::vec_t<2, wp::float32>(var_7, var_8);
    // change_b = int(-1)                                                                     <L 334>
    var_11 = wp::int(var_10);
    // keep = bool(False)                                                                     <L 336>
    var_13 = bool(var_12);
    // prev_outside = bool(signed_area(trim_seg_start, trim_seg_end, loop[0]) <= 0.0)         <L 339>
    var_15 = wp::address(var_loop, var_14);
    var_17 = wp::load(var_15);
    var_16 = signed_area_0(var_trim_seg_start, var_trim_seg_end, var_17);
    var_19 = (var_16 <= var_18);
    var_20 = bool(var_19);
    // for i in range(loop_count):                                                            <L 341>
    var_21 = wp::range(var_loop_count);
    start_for_1:;
        if (iter_cmp(var_21) == 0) goto end_for_1;
        var_22 = wp::iter_next(var_21);
        // next_idx = (i + 1) % loop_count                                                    <L 342>
        var_24 = wp::add(var_22, var_23);
        var_25 = wp::mod(var_24, var_loop_count);
        // outside = signed_area(trim_seg_start, trim_seg_end, loop[next_idx]) <= 0.0         <L 343>
        var_26 = wp::address(var_loop, var_25);
        var_28 = wp::load(var_26);
        var_27 = signed_area_0(var_trim_seg_start, var_trim_seg_end, var_28);
        var_30 = (var_27 <= var_29);
        // if outside != prev_outside:                                                        <L 345>
        var_31 = (var_30 != var_20);
        if (var_31) {
            // intersection = intersection_point(trim_seg_start, trim_seg_end, loop[i], loop[next_idx])       <L 346>
            var_32 = wp::address(var_loop, var_22);
            var_33 = wp::address(var_loop, var_25);
            var_35 = wp::load(var_32);
            var_36 = wp::load(var_33);
            var_34 = intersection_point_0(var_trim_seg_start, var_trim_seg_end, var_35, var_36);
            // if change_a < 0:                                                               <L 347>
            var_38 = (var_6 < var_37);
            if (var_38) {
                // change_a = i                                                               <L 348>
                var_39 = wp::copy(var_22);
                // keep = not prev_outside                                                    <L 349>
                var_40 = wp::unot(var_20);
                // intersection_a = intersection                                              <L 350>
                var_41 = wp::copy(var_34);
            }
            if (!var_38) {
                // change_b = i                                                               <L 352>
                var_42 = wp::copy(var_22);
                // intersection_b = intersection                                              <L 353>
                var_43 = wp::copy(var_34);
            }
            var_44 = wp::where(var_38, var_41, var_4);
            var_45 = wp::where(var_38, var_39, var_6);
            var_46 = wp::where(var_38, var_9, var_43);
            var_47 = wp::where(var_38, var_11, var_42);
            var_48 = wp::where(var_38, var_40, var_13);
        }
        var_49 = wp::where(var_31, var_44, var_4);
        var_50 = wp::where(var_31, var_45, var_6);
        var_51 = wp::where(var_31, var_46, var_9);
        var_52 = wp::where(var_31, var_47, var_11);
        var_53 = wp::where(var_31, var_48, var_13);
        // prev_outside = outside                                                             <L 355>
        var_54 = wp::copy(var_30);
        wp::assign(var_4, var_49);
        wp::assign(var_6, var_50);
        wp::assign(var_9, var_51);
        wp::assign(var_11, var_52);
        wp::assign(var_13, var_53);
        wp::assign(var_20, var_54);
        goto start_for_1;
    end_for_1:;
    // if change_a >= 0 and change_b >= 0:                                                    <L 357>
    var_57 = (var_6 >= var_56);
    var_55 = var_57;
    if (var_55) {
        var_59 = (var_11 >= var_58);
        var_55 = var_55 && var_59;
    }
    if (var_55) {
        // loop_indexer = int(-1)                                                             <L 358>
        var_61 = wp::int(var_60);
        // new_loop_count = int(loop_count)                                                   <L 359>
        var_62 = wp::int(var_loop_count);
        // i = int(0)                                                                         <L 361>
        var_64 = wp::int(var_63);
        // while i < loop_count:                                                              <L 362>
    start_while_3:;
        var_65 = (var_64 < var_loop_count);
    if ((var_65) == false) goto end_while_3;
            // if keep:                                                                       <L 364>
            if (var_13) {
                // loop_indexer += 1                                                          <L 365>
                var_67 = wp::add(var_61, var_66);
                // loop[loop_indexer] = loop[i]                                               <L 366>
                var_68 = wp::address(var_loop, var_64);
                var_69 = wp::load(var_68);
                wp::array_store(var_loop, var_67, var_69);
            }
            var_70 = wp::where(var_13, var_67, var_61);
            // if i == change_a or i == change_b:                                             <L 369>
            var_72 = (var_64 == var_6);
            var_71 = var_72;
            if (!var_71) {
                var_73 = (var_64 == var_11);
                var_71 = var_71 || var_73;
            }
            if (var_71) {
                // pt = intersection_a if i == change_a else intersection_b                   <L 370>
                var_74 = (var_64 == var_6);
                if (var_74) {
                }
                if (!var_74) {
                }
                var_75 = wp::where(var_74, var_4, var_9);
                // if loop_indexer == i and not keep:                                         <L 373>
                var_77 = (var_70 == var_64);
                var_76 = var_77;
                if (var_76) {
                    var_78 = wp::unot(var_13);
                    var_76 = var_76 && var_78;
                }
                if (var_76) {
                    // loop_indexer += 1                                                      <L 374>
                    var_80 = wp::add(var_70, var_79);
                    // insert_vec2(loop, new_loop_count, loop_indexer, pt)                    <L 375>
                    insert_vec2_0(var_loop, var_62, var_80, var_75);
                    // new_loop_count += 1                                                    <L 377>
                    var_82 = wp::add(var_62, var_81);
                    // i += 1                                                                 <L 378>
                    var_84 = wp::add(var_64, var_83);
                    // change_b += 1                                                          <L 379>
                    var_86 = wp::add(var_11, var_85);
                    // loop_count += 1                                                        <L 380>
                    var_88 = wp::add(var_loop_count, var_87);
                }
                if (!var_76) {
                    // loop_indexer += 1                                                      <L 382>
                    var_90 = wp::add(var_70, var_89);
                    // loop[loop_indexer] = pt                                                <L 383>
                    wp::array_store(var_loop, var_90, var_75);
                }
                var_91 = wp::where(var_76, var_88, var_loop_count);
                var_92 = wp::where(var_76, var_86, var_11);
                var_93 = wp::where(var_76, var_84, var_64);
                var_94 = wp::where(var_76, var_80, var_90);
                var_95 = wp::where(var_76, var_82, var_62);
                // keep = not keep                                                            <L 385>
                var_96 = wp::unot(var_13);
            }
            var_97 = wp::where(var_71, var_91, var_loop_count);
            var_98 = wp::where(var_71, var_92, var_11);
            var_99 = wp::where(var_71, var_96, var_13);
            var_100 = wp::where(var_71, var_93, var_64);
            var_101 = wp::where(var_71, var_94, var_70);
            var_102 = wp::where(var_71, var_95, var_62);
            // i += 1                                                                         <L 387>
            var_104 = wp::add(var_100, var_103);
            wp::assign(var_loop_count, var_97);
            wp::assign(var_11, var_98);
            wp::assign(var_13, var_99);
            wp::assign(var_64, var_104);
            wp::assign(var_61, var_101);
            wp::assign(var_62, var_102);
    goto start_while_3;
    end_while_3:;
        // new_loop_count = loop_indexer + 1                                                  <L 389>
        var_106 = wp::add(var_61, var_105);
    }
    if (!var_55) {
        // elif prev_outside:                                                                 <L 390>
        if (var_20) {
            // new_loop_count = 0                                                             <L 391>
        }
        if (!var_20) {
            // new_loop_count = loop_count                                                    <L 393>
            var_108 = wp::copy(var_loop_count);
        }
        var_109 = wp::where(var_20, var_107, var_108);
    }
    var_110 = wp::where(var_55, var_64, var_22);
    var_111 = wp::where(var_55, var_106, var_109);
    // return new_loop_count                                                                  <L 395>
    return var_111;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:398
static CUDA_CALLABLE wp::int32 trim_all_in_place_0(
    wp::array_t<wp::vec_t<2, wp::float32>> var_trim_poly,
    wp::int32 var_trim_poly_count,
    wp::array_t<wp::vec_t<2, wp::float32>> var_loop,
    wp::int32 var_loop_count)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 1;
    bool var_1;
    const wp::int32 var_2 = 1;
    wp::int32 var_3;
    const wp::float32 var_4 = 1e-05;
    wp::float32 var_5;
    const wp::int32 var_6 = 2;
    bool var_7;
    const wp::int32 var_8 = 0;
    wp::vec_t<2, wp::float32>* var_9;
    wp::vec_t<2, wp::float32> var_10;
    wp::vec_t<2, wp::float32> var_11;
    const wp::int32 var_12 = 1;
    wp::vec_t<2, wp::float32>* var_13;
    wp::vec_t<2, wp::float32> var_14;
    wp::vec_t<2, wp::float32> var_15;
    const wp::int32 var_16 = 0;
    wp::float32 var_17;
    const wp::int32 var_18 = 0;
    wp::float32 var_19;
    wp::float32 var_20;
    const wp::int32 var_21 = 1;
    wp::float32 var_22;
    const wp::int32 var_23 = 1;
    wp::float32 var_24;
    wp::float32 var_25;
    wp::float32 var_26;
    wp::float32 var_27;
    wp::float32 var_28;
    wp::float32 var_29;
    const wp::float32 var_30 = 1e-10;
    bool var_31;
    wp::float32 var_32;
    wp::float32 var_33;
    wp::float32 var_34;
    wp::float32 var_35;
    wp::float32 var_36;
    const wp::int32 var_37 = 0;
    wp::float32 var_38;
    wp::float32 var_39;
    const wp::int32 var_40 = 1;
    wp::float32 var_41;
    wp::float32 var_42;
    wp::vec_t<2, wp::float32> var_43;
    const wp::int32 var_44 = 0;
    const wp::int32 var_45 = 0;
    wp::float32 var_46;
    wp::float32 var_47;
    const wp::int32 var_48 = 1;
    wp::float32 var_49;
    wp::float32 var_50;
    wp::vec_t<2, wp::float32> var_51;
    const wp::int32 var_52 = 1;
    const wp::int32 var_53 = 0;
    wp::float32 var_54;
    wp::float32 var_55;
    const wp::int32 var_56 = 1;
    wp::float32 var_57;
    wp::float32 var_58;
    wp::vec_t<2, wp::float32> var_59;
    const wp::int32 var_60 = 2;
    const wp::int32 var_61 = 0;
    wp::float32 var_62;
    wp::float32 var_63;
    const wp::int32 var_64 = 1;
    wp::float32 var_65;
    wp::float32 var_66;
    wp::vec_t<2, wp::float32> var_67;
    const wp::int32 var_68 = 3;
    const wp::int32 var_69 = 4;
    const wp::int32 var_70 = 1;
    wp::int32 var_71;
    wp::int32 var_72;
    wp::int32 var_73;
    const wp::int32 var_74 = 2;
    bool var_75;
    const wp::int32 var_76 = 0;
    wp::vec_t<2, wp::float32>* var_77;
    wp::vec_t<2, wp::float32> var_78;
    wp::vec_t<2, wp::float32> var_79;
    const wp::int32 var_80 = 1;
    wp::vec_t<2, wp::float32>* var_81;
    wp::vec_t<2, wp::float32> var_82;
    wp::vec_t<2, wp::float32> var_83;
    const wp::int32 var_84 = 0;
    wp::float32 var_85;
    const wp::int32 var_86 = 0;
    wp::float32 var_87;
    wp::float32 var_88;
    const wp::int32 var_89 = 1;
    wp::float32 var_90;
    const wp::int32 var_91 = 1;
    wp::float32 var_92;
    wp::float32 var_93;
    wp::float32 var_94;
    wp::float32 var_95;
    wp::float32 var_96;
    wp::float32 var_97;
    const wp::float32 var_98 = 1e-10;
    bool var_99;
    wp::float32 var_100;
    wp::float32 var_101;
    wp::float32 var_102;
    wp::float32 var_103;
    wp::float32 var_104;
    const wp::int32 var_105 = 0;
    wp::float32 var_106;
    wp::float32 var_107;
    const wp::int32 var_108 = 1;
    wp::float32 var_109;
    wp::float32 var_110;
    wp::vec_t<2, wp::float32> var_111;
    const wp::int32 var_112 = 0;
    const wp::int32 var_113 = 0;
    wp::float32 var_114;
    wp::float32 var_115;
    const wp::int32 var_116 = 1;
    wp::float32 var_117;
    wp::float32 var_118;
    wp::vec_t<2, wp::float32> var_119;
    const wp::int32 var_120 = 1;
    const wp::int32 var_121 = 0;
    wp::float32 var_122;
    wp::float32 var_123;
    const wp::int32 var_124 = 1;
    wp::float32 var_125;
    wp::float32 var_126;
    wp::vec_t<2, wp::float32> var_127;
    const wp::int32 var_128 = 2;
    const wp::int32 var_129 = 0;
    wp::float32 var_130;
    wp::float32 var_131;
    const wp::int32 var_132 = 1;
    wp::float32 var_133;
    wp::float32 var_134;
    wp::vec_t<2, wp::float32> var_135;
    const wp::int32 var_136 = 3;
    const wp::int32 var_137 = 4;
    const wp::int32 var_138 = 1;
    wp::int32 var_139;
    wp::int32 var_140;
    wp::float32 var_141;
    wp::float32 var_142;
    wp::float32 var_143;
    wp::float32 var_144;
    wp::int32 var_145;
    wp::vec_t<2, wp::float32> var_146;
    wp::vec_t<2, wp::float32> var_147;
    wp::float32 var_148;
    wp::float32 var_149;
    wp::float32 var_150;
    wp::float32 var_151;
    wp::float32 var_152;
    wp::float32 var_153;
    wp::float32 var_154;
    wp::int32 var_155;
    const wp::int32 var_156 = 0;
    wp::vec_t<2, wp::float32>* var_157;
    wp::vec_t<2, wp::float32> var_158;
    wp::vec_t<2, wp::float32> var_159;
    wp::range_t var_160;
    wp::int32 var_161;
    wp::vec_t<2, wp::float32>* var_162;
    wp::vec_t<2, wp::float32> var_163;
    wp::vec_t<2, wp::float32> var_164;
    const wp::int32 var_165 = 1;
    wp::int32 var_166;
    bool var_167;
    const wp::int32 var_168 = 1;
    wp::int32 var_169;
    wp::vec_t<2, wp::float32>* var_170;
    wp::vec_t<2, wp::float32> var_171;
    wp::vec_t<2, wp::float32> var_172;
    wp::int32 var_173;
    //---------
    // forward
    // def trim_all_in_place(                                                                 <L 399>
    // if trim_poly_count <= 1:                                                               <L 420>
    var_1 = (var_trim_poly_count <= var_0);
    if (var_1) {
        // return wp.min(1, loop_count)  # There is no trim polygon                           <L 421>
        var_3 = wp::min(var_2, var_loop_count);
        return var_3;
    }
    // move_distance = float(1e-5)                                                            <L 423>
    var_5 = wp::float(var_4);
    // if trim_poly_count == 2:                                                               <L 425>
    var_7 = (var_trim_poly_count == var_6);
    if (var_7) {
        // p0 = trim_poly[0]                                                                  <L 427>
        var_9 = wp::address(var_trim_poly, var_8);
        var_11 = wp::load(var_9);
        var_10 = wp::copy(var_11);
        // p1 = trim_poly[1]                                                                  <L 428>
        var_13 = wp::address(var_trim_poly, var_12);
        var_15 = wp::load(var_13);
        var_14 = wp::copy(var_15);
        // dir_x = p1[0] - p0[0]                                                              <L 430>
        var_17 = wp::extract(var_14, var_16);
        var_19 = wp::extract(var_10, var_18);
        var_20 = wp::sub(var_17, var_19);
        // dir_y = p1[1] - p0[1]                                                              <L 431>
        var_22 = wp::extract(var_14, var_21);
        var_24 = wp::extract(var_10, var_23);
        var_25 = wp::sub(var_22, var_24);
        // dir_len = wp.sqrt(dir_x * dir_x + dir_y * dir_y)                                   <L 432>
        var_26 = wp::mul(var_20, var_20);
        var_27 = wp::mul(var_25, var_25);
        var_28 = wp::add(var_26, var_27);
        var_29 = wp::sqrt(var_28);
        // if dir_len > 1e-10:                                                                <L 434>
        var_31 = (var_29 > var_30);
        if (var_31) {
            // perp_x = -dir_y / dir_len                                                      <L 435>
            var_32 = wp::neg(var_25);
            var_33 = wp::div(var_32, var_29);
            // perp_y = dir_x / dir_len                                                       <L 436>
            var_34 = wp::div(var_20, var_29);
            // offset_x = perp_x * move_distance                                              <L 438>
            var_35 = wp::mul(var_33, var_5);
            // offset_y = perp_y * move_distance                                              <L 439>
            var_36 = wp::mul(var_34, var_5);
            // trim_poly[0] = wp.vec2(p0[0] - offset_x, p0[1] - offset_y)                     <L 441>
            var_38 = wp::extract(var_10, var_37);
            var_39 = wp::sub(var_38, var_35);
            var_41 = wp::extract(var_10, var_40);
            var_42 = wp::sub(var_41, var_36);
            var_43 = wp::vec_t<2, wp::float32>(var_39, var_42);
            wp::array_store(var_trim_poly, var_44, var_43);
            // trim_poly[1] = wp.vec2(p1[0] - offset_x, p1[1] - offset_y)                     <L 442>
            var_46 = wp::extract(var_14, var_45);
            var_47 = wp::sub(var_46, var_35);
            var_49 = wp::extract(var_14, var_48);
            var_50 = wp::sub(var_49, var_36);
            var_51 = wp::vec_t<2, wp::float32>(var_47, var_50);
            wp::array_store(var_trim_poly, var_52, var_51);
            // trim_poly[2] = wp.vec2(p1[0] + offset_x, p1[1] + offset_y)                     <L 443>
            var_54 = wp::extract(var_14, var_53);
            var_55 = wp::add(var_54, var_35);
            var_57 = wp::extract(var_14, var_56);
            var_58 = wp::add(var_57, var_36);
            var_59 = wp::vec_t<2, wp::float32>(var_55, var_58);
            wp::array_store(var_trim_poly, var_60, var_59);
            // trim_poly[3] = wp.vec2(p0[0] + offset_x, p0[1] + offset_y)                     <L 444>
            var_62 = wp::extract(var_10, var_61);
            var_63 = wp::add(var_62, var_35);
            var_65 = wp::extract(var_10, var_64);
            var_66 = wp::add(var_65, var_36);
            var_67 = wp::vec_t<2, wp::float32>(var_63, var_66);
            wp::array_store(var_trim_poly, var_68, var_67);
            // trim_poly_count = 4                                                            <L 445>
        }
        if (!var_31) {
            // return wp.min(1, loop_count)                                                   <L 447>
            var_71 = wp::min(var_70, var_loop_count);
            return var_71;
        }
        var_72 = wp::where(var_31, var_69, var_trim_poly_count);
    }
    var_73 = wp::where(var_7, var_72, var_trim_poly_count);
    // if loop_count == 2:                                                                    <L 449>
    var_75 = (var_loop_count == var_74);
    if (var_75) {
        // p0 = loop[0]                                                                       <L 451>
        var_77 = wp::address(var_loop, var_76);
        var_79 = wp::load(var_77);
        var_78 = wp::copy(var_79);
        // p1 = loop[1]                                                                       <L 452>
        var_81 = wp::address(var_loop, var_80);
        var_83 = wp::load(var_81);
        var_82 = wp::copy(var_83);
        // dir_x = p1[0] - p0[0]                                                              <L 454>
        var_85 = wp::extract(var_82, var_84);
        var_87 = wp::extract(var_78, var_86);
        var_88 = wp::sub(var_85, var_87);
        // dir_y = p1[1] - p0[1]                                                              <L 455>
        var_90 = wp::extract(var_82, var_89);
        var_92 = wp::extract(var_78, var_91);
        var_93 = wp::sub(var_90, var_92);
        // dir_len = wp.sqrt(dir_x * dir_x + dir_y * dir_y)                                   <L 456>
        var_94 = wp::mul(var_88, var_88);
        var_95 = wp::mul(var_93, var_93);
        var_96 = wp::add(var_94, var_95);
        var_97 = wp::sqrt(var_96);
        // if dir_len > 1e-10:                                                                <L 458>
        var_99 = (var_97 > var_98);
        if (var_99) {
            // perp_x = -dir_y / dir_len                                                      <L 459>
            var_100 = wp::neg(var_93);
            var_101 = wp::div(var_100, var_97);
            // perp_y = dir_x / dir_len                                                       <L 460>
            var_102 = wp::div(var_88, var_97);
            // offset_x = perp_x * move_distance                                              <L 462>
            var_103 = wp::mul(var_101, var_5);
            // offset_y = perp_y * move_distance                                              <L 463>
            var_104 = wp::mul(var_102, var_5);
            // loop[0] = wp.vec2(p0[0] - offset_x, p0[1] - offset_y)                          <L 465>
            var_106 = wp::extract(var_78, var_105);
            var_107 = wp::sub(var_106, var_103);
            var_109 = wp::extract(var_78, var_108);
            var_110 = wp::sub(var_109, var_104);
            var_111 = wp::vec_t<2, wp::float32>(var_107, var_110);
            wp::array_store(var_loop, var_112, var_111);
            // loop[1] = wp.vec2(p1[0] - offset_x, p1[1] - offset_y)                          <L 466>
            var_114 = wp::extract(var_82, var_113);
            var_115 = wp::sub(var_114, var_103);
            var_117 = wp::extract(var_82, var_116);
            var_118 = wp::sub(var_117, var_104);
            var_119 = wp::vec_t<2, wp::float32>(var_115, var_118);
            wp::array_store(var_loop, var_120, var_119);
            // loop[2] = wp.vec2(p1[0] + offset_x, p1[1] + offset_y)                          <L 467>
            var_122 = wp::extract(var_82, var_121);
            var_123 = wp::add(var_122, var_103);
            var_125 = wp::extract(var_82, var_124);
            var_126 = wp::add(var_125, var_104);
            var_127 = wp::vec_t<2, wp::float32>(var_123, var_126);
            wp::array_store(var_loop, var_128, var_127);
            // loop[3] = wp.vec2(p0[0] + offset_x, p0[1] + offset_y)                          <L 468>
            var_130 = wp::extract(var_78, var_129);
            var_131 = wp::add(var_130, var_103);
            var_133 = wp::extract(var_78, var_132);
            var_134 = wp::add(var_133, var_104);
            var_135 = wp::vec_t<2, wp::float32>(var_131, var_134);
            wp::array_store(var_loop, var_136, var_135);
            // loop_count = 4                                                                 <L 470>
        }
        if (!var_99) {
            // return wp.min(1, loop_count)                                                   <L 472>
            var_139 = wp::min(var_138, var_loop_count);
            return var_139;
        }
        var_140 = wp::where(var_99, var_137, var_loop_count);
        var_141 = wp::where(var_99, var_101, var_33);
        var_142 = wp::where(var_99, var_102, var_34);
        var_143 = wp::where(var_99, var_103, var_35);
        var_144 = wp::where(var_99, var_104, var_36);
    }
    var_145 = wp::where(var_75, var_140, var_loop_count);
    var_146 = wp::where(var_75, var_78, var_10);
    var_147 = wp::where(var_75, var_82, var_14);
    var_148 = wp::where(var_75, var_88, var_20);
    var_149 = wp::where(var_75, var_93, var_25);
    var_150 = wp::where(var_75, var_97, var_29);
    var_151 = wp::where(var_75, var_141, var_33);
    var_152 = wp::where(var_75, var_142, var_34);
    var_153 = wp::where(var_75, var_143, var_35);
    var_154 = wp::where(var_75, var_144, var_36);
    // current_loop_count = loop_count                                                        <L 474>
    var_155 = wp::copy(var_145);
    // trim_poly_0 = trim_poly[0]  # This allows to do more memory aliasing                   <L 476>
    var_157 = wp::address(var_trim_poly, var_156);
    var_159 = wp::load(var_157);
    var_158 = wp::copy(var_159);
    // for i in range(trim_poly_count):                                                       <L 477>
    var_160 = wp::range(var_73);
    start_for_3:;
        if (iter_cmp(var_160) == 0) goto end_for_3;
        var_161 = wp::iter_next(var_160);
        // trim_seg_start = trim_poly[i]                                                      <L 478>
        var_162 = wp::address(var_trim_poly, var_161);
        var_164 = wp::load(var_162);
        var_163 = wp::copy(var_164);
        // trim_seg_end = trim_poly_0 if i == trim_poly_count - 1 else trim_poly[i + 1]       <L 479>
        var_166 = wp::sub(var_73, var_165);
        var_167 = (var_161 == var_166);
        if (var_167) {
        }
        if (!var_167) {
            var_169 = wp::add(var_161, var_168);
            var_170 = wp::address(var_trim_poly, var_169);
            var_171 = wp::load(var_170);
        }
        var_172 = wp::where(var_167, var_158, var_171);
        // current_loop_count = trim_in_place(trim_seg_start, trim_seg_end, loop, current_loop_count)       <L 480>
        var_173 = trim_in_place_0(var_163, var_172, var_loop, var_155);
        wp::assign(var_155, var_173);
        goto start_for_3;
    end_for_3:;
    // return current_loop_count                                                              <L 482>
    return var_155;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:581
static CUDA_CALLABLE wp::int32 remove_zero_length_edges_0(
    wp::array_t<wp::vec_t<2, wp::float32>> var_loop,
    wp::int32 var_loop_count,
    wp::float32 var_eps)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 2;
    bool var_1;
    const wp::int32 var_2 = 0;
    const wp::int32 var_3 = 0;
    wp::int32 var_4;
    const wp::int32 var_5 = 1;
    wp::range_t var_6;
    wp::int32 var_7;
    wp::vec_t<2, wp::float32>* var_8;
    wp::vec_t<2, wp::float32>* var_9;
    wp::vec_t<2, wp::float32> var_10;
    wp::vec_t<2, wp::float32> var_11;
    wp::vec_t<2, wp::float32> var_12;
    wp::float32 var_13;
    bool var_14;
    const wp::int32 var_15 = 1;
    wp::int32 var_16;
    wp::vec_t<2, wp::float32>* var_17;
    wp::vec_t<2, wp::float32> var_18;
    wp::int32 var_19;
    const wp::int32 var_20 = 0;
    bool var_21;
    wp::vec_t<2, wp::float32>* var_22;
    const wp::int32 var_23 = 0;
    wp::vec_t<2, wp::float32>* var_24;
    wp::vec_t<2, wp::float32> var_25;
    wp::vec_t<2, wp::float32> var_26;
    wp::vec_t<2, wp::float32> var_27;
    wp::float32 var_28;
    bool var_29;
    wp::int32 var_30;
    const wp::int32 var_31 = 1;
    wp::int32 var_32;
    wp::int32 var_33;
    const wp::int32 var_34 = 1;
    wp::int32 var_35;
    wp::vec_t<2, wp::float32> var_36;
    wp::int32 var_37;
    const wp::int32 var_38 = 2;
    bool var_39;
    const wp::int32 var_40 = 0;
    wp::int32 var_41;
    //---------
    // forward
    // def remove_zero_length_edges(loop: wp.array[wp.vec2], loop_count: int, eps: float) -> int:       <L 582>
    // if loop_count < 2:                                                                     <L 594>
    var_1 = (var_loop_count < var_0);
    if (var_1) {
        // return 0                                                                           <L 595>
        return var_2;
    }
    // write_idx = int(0)                                                                     <L 597>
    var_4 = wp::int(var_3);
    // for read_idx in range(1, loop_count):                                                  <L 599>
    var_6 = wp::range(var_5, var_loop_count);
    start_for_1:;
        if (iter_cmp(var_6) == 0) goto end_for_1;
        var_7 = wp::iter_next(var_6);
        // diff = loop[read_idx] - loop[write_idx]                                            <L 600>
        var_8 = wp::address(var_loop, var_7);
        var_9 = wp::address(var_loop, var_4);
        var_11 = wp::load(var_8);
        var_12 = wp::load(var_9);
        var_10 = wp::sub(var_11, var_12);
        // if wp.length_sq(diff) > eps:                                                       <L 601>
        var_13 = wp::length_sq(var_10);
        var_14 = (var_13 > var_eps);
        if (var_14) {
            // write_idx += 1                                                                 <L 602>
            var_16 = wp::add(var_4, var_15);
            // loop[write_idx] = loop[read_idx]                                               <L 603>
            var_17 = wp::address(var_loop, var_7);
            var_18 = wp::load(var_17);
            wp::array_store(var_loop, var_16, var_18);
        }
        var_19 = wp::where(var_14, var_16, var_4);
        wp::assign(var_4, var_19);
        goto start_for_1;
    end_for_1:;
    // if write_idx > 0:                                                                      <L 606>
    var_21 = (var_4 > var_20);
    if (var_21) {
        // diff = loop[write_idx] - loop[0]                                                   <L 607>
        var_22 = wp::address(var_loop, var_4);
        var_24 = wp::address(var_loop, var_23);
        var_26 = wp::load(var_22);
        var_27 = wp::load(var_24);
        var_25 = wp::sub(var_26, var_27);
        // if wp.length_sq(diff) < eps:                                                       <L 608>
        var_28 = wp::length_sq(var_25);
        var_29 = (var_28 < var_eps);
        if (var_29) {
            // new_loop_count = write_idx                                                     <L 609>
            var_30 = wp::copy(var_4);
        }
        if (!var_29) {
            // new_loop_count = write_idx + 1                                                 <L 611>
            var_32 = wp::add(var_4, var_31);
        }
        var_33 = wp::where(var_29, var_30, var_32);
    }
    if (!var_21) {
        // new_loop_count = write_idx + 1                                                     <L 613>
        var_35 = wp::add(var_4, var_34);
    }
    var_36 = wp::where(var_21, var_25, var_10);
    var_37 = wp::where(var_21, var_33, var_35);
    // if new_loop_count < 2:                                                                 <L 615>
    var_39 = (var_37 < var_38);
    if (var_39) {
        // new_loop_count = 0                                                                 <L 616>
    }
    var_41 = wp::where(var_39, var_40, var_37);
    // return new_loop_count                                                                  <L 618>
    return var_41;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:485
static CUDA_CALLABLE wp::vec_t<4, wp::int32> approx_max_quadrilateral_area_with_calipers_0(
    wp::array_t<wp::vec_t<2, wp::float32>> var_hull,
    wp::int32 var_hull_count)
{
    //---------
    // primal vars
    wp::int32 var_0;
    const wp::int32 var_1 = 0;
    wp::int32 var_2;
    const wp::int32 var_3 = 1;
    wp::int32 var_4;
    wp::vec_t<2, wp::float32>* var_5;
    wp::vec_t<2, wp::float32> var_6;
    wp::vec_t<2, wp::float32> var_7;
    wp::vec_t<2, wp::float32>* var_8;
    wp::vec_t<2, wp::float32> var_9;
    wp::vec_t<2, wp::float32> var_10;
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
    wp::vec_t<2, wp::float32> var_21;
    const wp::int32 var_22 = 0;
    wp::float32 var_23;
    const wp::int32 var_24 = 0;
    wp::float32 var_25;
    wp::float32 var_26;
    const wp::int32 var_27 = 1;
    wp::float32 var_28;
    const wp::int32 var_29 = 1;
    wp::float32 var_30;
    wp::float32 var_31;
    wp::float32 var_32;
    const wp::float32 var_33 = 0.001;
    const wp::int32 var_34 = 1;
    wp::int32 var_35;
    wp::range_t var_36;
    wp::int32 var_37;
    wp::vec_t<2, wp::float32>* var_38;
    wp::vec_t<2, wp::float32> var_39;
    wp::vec_t<2, wp::float32> var_40;
    const wp::int32 var_41 = 1;
    wp::int32 var_42;
    wp::int32 var_43;
    wp::vec_t<2, wp::float32>* var_44;
    wp::vec_t<2, wp::float32> var_45;
    wp::vec_t<2, wp::float32> var_46;
    const bool var_47 = true;
    wp::vec_t<2, wp::float32>* var_48;
    wp::vec_t<2, wp::float32> var_49;
    wp::vec_t<2, wp::float32> var_50;
    const wp::int32 var_51 = 1;
    wp::int32 var_52;
    wp::int32 var_53;
    wp::vec_t<2, wp::float32>* var_54;
    wp::vec_t<2, wp::float32> var_55;
    wp::vec_t<2, wp::float32> var_56;
    wp::float32 var_57;
    wp::float32 var_58;
    bool var_59;
    const wp::int32 var_60 = 1;
    wp::int32 var_61;
    wp::int32 var_62;
    wp::int32 var_63;
    wp::vec_t<2, wp::float32>* var_64;
    wp::vec_t<2, wp::float32> var_65;
    wp::vec_t<2, wp::float32> var_66;
    wp::vec_t<2, wp::float32>* var_67;
    wp::vec_t<2, wp::float32> var_68;
    wp::vec_t<2, wp::float32> var_69;
    const wp::int32 var_70 = 0;
    wp::float32 var_71;
    const wp::int32 var_72 = 0;
    wp::float32 var_73;
    wp::float32 var_74;
    const wp::int32 var_75 = 1;
    wp::float32 var_76;
    const wp::int32 var_77 = 1;
    wp::float32 var_78;
    wp::float32 var_79;
    wp::vec_t<2, wp::float32> var_80;
    const wp::int32 var_81 = 0;
    wp::float32 var_82;
    const wp::int32 var_83 = 0;
    wp::float32 var_84;
    wp::float32 var_85;
    const wp::int32 var_86 = 1;
    wp::float32 var_87;
    const wp::int32 var_88 = 1;
    wp::float32 var_89;
    wp::float32 var_90;
    wp::float32 var_91;
    const wp::float32 var_92 = 1.0;
    wp::float32 var_93;
    wp::float32 var_94;
    bool var_95;
    wp::float32 var_96;
    wp::int32 var_97;
    wp::int32 var_98;
    wp::int32 var_99;
    wp::int32 var_100;
    wp::float32 var_101;
    const wp::int32 var_102 = 1;
    wp::int32 var_103;
    wp::int32 var_104;
    wp::vec_t<2, wp::float32>* var_105;
    wp::vec_t<2, wp::float32> var_106;
    wp::vec_t<2, wp::float32> var_107;
    const wp::int32 var_108 = 0;
    wp::float32 var_109;
    const wp::int32 var_110 = 0;
    wp::float32 var_111;
    wp::float32 var_112;
    const wp::int32 var_113 = 1;
    wp::float32 var_114;
    const wp::int32 var_115 = 1;
    wp::float32 var_116;
    wp::float32 var_117;
    wp::vec_t<2, wp::float32> var_118;
    const wp::int32 var_119 = 0;
    wp::float32 var_120;
    const wp::int32 var_121 = 0;
    wp::float32 var_122;
    wp::float32 var_123;
    const wp::int32 var_124 = 1;
    wp::float32 var_125;
    const wp::int32 var_126 = 1;
    wp::float32 var_127;
    wp::float32 var_128;
    wp::float32 var_129;
    const wp::float32 var_130 = 1.0;
    wp::float32 var_131;
    wp::float32 var_132;
    bool var_133;
    wp::float32 var_134;
    const wp::int32 var_135 = 1;
    wp::int32 var_136;
    wp::int32 var_137;
    wp::int32 var_138;
    wp::int32 var_139;
    wp::int32 var_140;
    wp::float32 var_141;
    const wp::int32 var_142 = 0;
    wp::int32 var_143;
    const wp::int32 var_144 = 0;
    wp::int32 var_145;
    const wp::float32 var_146 = 0.0;
    wp::float32 var_147;
    const wp::float32 var_148 = 0.0;
    wp::float32 var_149;
    wp::vec_t<2, wp::float32>* var_150;
    wp::vec_t<2, wp::float32> var_151;
    wp::vec_t<2, wp::float32> var_152;
    wp::vec_t<2, wp::float32>* var_153;
    wp::vec_t<2, wp::float32> var_154;
    wp::vec_t<2, wp::float32> var_155;
    wp::range_t var_156;
    wp::int32 var_157;
    wp::vec_t<2, wp::float32>* var_158;
    wp::vec_t<2, wp::float32> var_159;
    wp::vec_t<2, wp::float32> var_160;
    wp::float32 var_161;
    const wp::float32 var_162 = 1.0;
    wp::float32 var_163;
    wp::float32 var_164;
    bool var_165;
    wp::float32 var_166;
    wp::int32 var_167;
    wp::float32 var_168;
    const wp::float32 var_169 = 1.0;
    wp::float32 var_170;
    wp::float32 var_171;
    bool var_172;
    wp::float32 var_173;
    wp::int32 var_174;
    wp::int32 var_175;
    wp::float32 var_176;
    wp::int32 var_177;
    wp::int32 var_178;
    wp::float32 var_179;
    wp::float32 var_180;
    wp::vec_t<4, wp::int32> var_181;
    //---------
    // forward
    // def approx_max_quadrilateral_area_with_calipers(hull: wp.array[wp.vec2], hull_count: int) -> wp.vec4i:       <L 486>
    // n = hull_count                                                                         <L 499>
    var_0 = wp::copy(var_hull_count);
    // p1 = int(0)                                                                            <L 502>
    var_2 = wp::int(var_1);
    // p3 = int(1)                                                                            <L 503>
    var_4 = wp::int(var_3);
    // hp1 = hull[p1]                                                                         <L 504>
    var_5 = wp::address(var_hull, var_2);
    var_7 = wp::load(var_5);
    var_6 = wp::copy(var_7);
    // hp3 = hull[p3]                                                                         <L 505>
    var_8 = wp::address(var_hull, var_4);
    var_10 = wp::load(var_8);
    var_9 = wp::copy(var_10);
    // diff = wp.vec2(hp1[0] - hp3[0], hp1[1] - hp3[1])                                       <L 506>
    var_12 = wp::extract(var_6, var_11);
    var_14 = wp::extract(var_9, var_13);
    var_15 = wp::sub(var_12, var_14);
    var_17 = wp::extract(var_6, var_16);
    var_19 = wp::extract(var_9, var_18);
    var_20 = wp::sub(var_17, var_19);
    var_21 = wp::vec_t<2, wp::float32>(var_15, var_20);
    // max_dist_sq = diff[0] * diff[0] + diff[1] * diff[1]                                    <L 507>
    var_23 = wp::extract(var_21, var_22);
    var_25 = wp::extract(var_21, var_24);
    var_26 = wp::mul(var_23, var_25);
    var_28 = wp::extract(var_21, var_27);
    var_30 = wp::extract(var_21, var_29);
    var_31 = wp::mul(var_28, var_30);
    var_32 = wp::add(var_26, var_31);
    // tie_epsilon_rel = 1.0e-3                                                               <L 512>
    // j = int(1)                                                                             <L 515>
    var_35 = wp::int(var_34);
    // for i in range(n):                                                                     <L 516>
    var_36 = wp::range(var_0);
    start_for_0:;
        if (iter_cmp(var_36) == 0) goto end_for_0;
        var_37 = wp::iter_next(var_36);
        // hull_i = hull[i]                                                                   <L 520>
        var_38 = wp::address(var_hull, var_37);
        var_40 = wp::load(var_38);
        var_39 = wp::copy(var_40);
        // hull_i_plus_1 = hull[(i + 1) % n]                                                  <L 521>
        var_42 = wp::add(var_37, var_41);
        var_43 = wp::mod(var_42, var_0);
        var_44 = wp::address(var_hull, var_43);
        var_46 = wp::load(var_44);
        var_45 = wp::copy(var_46);
        // while True:                                                                        <L 523>
    start_while_2:;
    if ((var_47) == false) goto end_while_2;
            // hull_j = hull[j]                                                               <L 524>
            var_48 = wp::address(var_hull, var_35);
            var_50 = wp::load(var_48);
            var_49 = wp::copy(var_50);
            // hull_j_plus_1 = hull[(j + 1) % n]                                              <L 525>
            var_52 = wp::add(var_35, var_51);
            var_53 = wp::mod(var_52, var_0);
            var_54 = wp::address(var_hull, var_53);
            var_56 = wp::load(var_54);
            var_55 = wp::copy(var_56);
            // area_j_plus_1 = signed_area(hull_i, hull_i_plus_1, hull_j_plus_1)              <L 527>
            var_57 = signed_area_0(var_39, var_45, var_55);
            // area_j = signed_area(hull_i, hull_i_plus_1, hull_j)                            <L 528>
            var_58 = signed_area_0(var_39, var_45, var_49);
            // if area_j_plus_1 > area_j:                                                     <L 530>
            var_59 = (var_57 > var_58);
            if (var_59) {
                // j = (j + 1) % n                                                            <L 531>
                var_61 = wp::add(var_35, var_60);
                var_62 = wp::mod(var_61, var_0);
            }
            if (!var_59) {
                // break                                                                      <L 533>
                goto end_while_2;
            }
            var_63 = wp::where(var_59, var_62, var_35);
            wp::assign(var_35, var_63);
    goto start_while_2;
    end_while_2:;
        // hi = hull[i]                                                                       <L 536>
        var_64 = wp::address(var_hull, var_37);
        var_66 = wp::load(var_64);
        var_65 = wp::copy(var_66);
        // hj = hull[j]                                                                       <L 537>
        var_67 = wp::address(var_hull, var_35);
        var_69 = wp::load(var_67);
        var_68 = wp::copy(var_69);
        // d1 = wp.vec2(hi[0] - hj[0], hi[1] - hj[1])                                         <L 538>
        var_71 = wp::extract(var_65, var_70);
        var_73 = wp::extract(var_68, var_72);
        var_74 = wp::sub(var_71, var_73);
        var_76 = wp::extract(var_65, var_75);
        var_78 = wp::extract(var_68, var_77);
        var_79 = wp::sub(var_76, var_78);
        var_80 = wp::vec_t<2, wp::float32>(var_74, var_79);
        // dist_sq_1 = d1[0] * d1[0] + d1[1] * d1[1]                                          <L 539>
        var_82 = wp::extract(var_80, var_81);
        var_84 = wp::extract(var_80, var_83);
        var_85 = wp::mul(var_82, var_84);
        var_87 = wp::extract(var_80, var_86);
        var_89 = wp::extract(var_80, var_88);
        var_90 = wp::mul(var_87, var_89);
        var_91 = wp::add(var_85, var_90);
        // if dist_sq_1 > max_dist_sq * (1.0 + tie_epsilon_rel):                              <L 541>
        var_93 = wp::add(var_92, var_33);
        var_94 = wp::mul(var_32, var_93);
        var_95 = (var_91 > var_94);
        if (var_95) {
            // max_dist_sq = dist_sq_1                                                        <L 542>
            var_96 = wp::copy(var_91);
            // p1 = i                                                                         <L 543>
            var_97 = wp::copy(var_37);
            // p3 = j                                                                         <L 544>
            var_98 = wp::copy(var_35);
        }
        var_99 = wp::where(var_95, var_97, var_2);
        var_100 = wp::where(var_95, var_98, var_4);
        var_101 = wp::where(var_95, var_96, var_32);
        // hip1 = hull[(i + 1) % n]                                                           <L 547>
        var_103 = wp::add(var_37, var_102);
        var_104 = wp::mod(var_103, var_0);
        var_105 = wp::address(var_hull, var_104);
        var_107 = wp::load(var_105);
        var_106 = wp::copy(var_107);
        // d2 = wp.vec2(hip1[0] - hj[0], hip1[1] - hj[1])                                     <L 548>
        var_109 = wp::extract(var_106, var_108);
        var_111 = wp::extract(var_68, var_110);
        var_112 = wp::sub(var_109, var_111);
        var_114 = wp::extract(var_106, var_113);
        var_116 = wp::extract(var_68, var_115);
        var_117 = wp::sub(var_114, var_116);
        var_118 = wp::vec_t<2, wp::float32>(var_112, var_117);
        // dist_sq_2 = d2[0] * d2[0] + d2[1] * d2[1]                                          <L 549>
        var_120 = wp::extract(var_118, var_119);
        var_122 = wp::extract(var_118, var_121);
        var_123 = wp::mul(var_120, var_122);
        var_125 = wp::extract(var_118, var_124);
        var_127 = wp::extract(var_118, var_126);
        var_128 = wp::mul(var_125, var_127);
        var_129 = wp::add(var_123, var_128);
        // if dist_sq_2 > max_dist_sq * (1.0 + tie_epsilon_rel):                              <L 551>
        var_131 = wp::add(var_130, var_33);
        var_132 = wp::mul(var_101, var_131);
        var_133 = (var_129 > var_132);
        if (var_133) {
            // max_dist_sq = dist_sq_2                                                        <L 552>
            var_134 = wp::copy(var_129);
            // p1 = (i + 1) % n                                                               <L 553>
            var_136 = wp::add(var_37, var_135);
            var_137 = wp::mod(var_136, var_0);
            // p3 = j                                                                         <L 554>
            var_138 = wp::copy(var_35);
        }
        var_139 = wp::where(var_133, var_137, var_99);
        var_140 = wp::where(var_133, var_138, var_100);
        var_141 = wp::where(var_133, var_134, var_101);
        wp::assign(var_2, var_139);
        wp::assign(var_4, var_140);
        wp::assign(var_32, var_141);
        goto start_for_0;
    end_for_0:;
    // p2 = int(0)                                                                            <L 557>
    var_143 = wp::int(var_142);
    // p4 = int(0)                                                                            <L 558>
    var_145 = wp::int(var_144);
    // max_area_1 = float(0.0)                                                                <L 559>
    var_147 = wp::float(var_146);
    // max_area_2 = float(0.0)                                                                <L 560>
    var_149 = wp::float(var_148);
    // hull_p1 = hull[p1]                                                                     <L 562>
    var_150 = wp::address(var_hull, var_2);
    var_152 = wp::load(var_150);
    var_151 = wp::copy(var_152);
    // hull_p3 = hull[p3]                                                                     <L 563>
    var_153 = wp::address(var_hull, var_4);
    var_155 = wp::load(var_153);
    var_154 = wp::copy(var_155);
    // for i in range(n):                                                                     <L 565>
    var_156 = wp::range(var_0);
    start_for_4:;
        if (iter_cmp(var_156) == 0) goto end_for_4;
        var_157 = wp::iter_next(var_156);
        // hull_i = hull[i]                                                                   <L 567>
        var_158 = wp::address(var_hull, var_157);
        var_160 = wp::load(var_158);
        var_159 = wp::copy(var_160);
        // area = signed_area(hull_p1, hull_p3, hull_i)                                       <L 568>
        var_161 = signed_area_0(var_151, var_154, var_159);
        // if area > max_area_1 * (1.0 + tie_epsilon_rel):                                    <L 571>
        var_163 = wp::add(var_162, var_33);
        var_164 = wp::mul(var_147, var_163);
        var_165 = (var_161 > var_164);
        if (var_165) {
            // max_area_1 = area                                                              <L 572>
            var_166 = wp::copy(var_161);
            // p2 = i                                                                         <L 573>
            var_167 = wp::copy(var_157);
        }
        if (!var_165) {
            // elif -area > max_area_2 * (1.0 + tie_epsilon_rel):  # Check the other side       <L 574>
            var_168 = wp::neg(var_161);
            var_170 = wp::add(var_169, var_33);
            var_171 = wp::mul(var_149, var_170);
            var_172 = (var_168 > var_171);
            if (var_172) {
                // max_area_2 = -area                                                         <L 575>
                var_173 = wp::neg(var_161);
                // p4 = i                                                                     <L 576>
                var_174 = wp::copy(var_157);
            }
            var_175 = wp::where(var_172, var_174, var_145);
            var_176 = wp::where(var_172, var_173, var_149);
        }
        var_177 = wp::where(var_165, var_167, var_143);
        var_178 = wp::where(var_165, var_145, var_175);
        var_179 = wp::where(var_165, var_166, var_147);
        var_180 = wp::where(var_165, var_149, var_176);
        wp::assign(var_39, var_159);
        wp::assign(var_143, var_177);
        wp::assign(var_145, var_178);
        wp::assign(var_147, var_179);
        wp::assign(var_149, var_180);
        goto start_for_4;
    end_for_4:;
    // return wp.vec4i(p1, p2, p3, p4)                                                        <L 578>
    var_181 = wp::vec_t<4, wp::int32>(var_2, var_143, var_4, var_145);
    return var_181;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:87
static CUDA_CALLABLE wp::vec_t<3, wp::float32> ray_plane_intersection_0(
    wp::vec_t<3, wp::float32> var_ray_origin,
    wp::vec_t<3, wp::float32> var_ray_direction,
    wp::float32 var_plane_d,
    wp::vec_t<3, wp::float32> var_plane_normal)
{
    //---------
    // primal vars
    wp::float32 var_0;
    wp::float32 var_1;
    const wp::float32 var_2 = 1e-12;
    bool var_3;
    wp::float32 var_4;
    wp::float32 var_5;
    wp::float32 var_6;
    wp::float32 var_7;
    wp::vec_t<3, wp::float32> var_8;
    wp::vec_t<3, wp::float32> var_9;
    //---------
    // forward
    // def ray_plane_intersection(                                                            <L 88>
    // denom = wp.dot(ray_direction, plane_normal)                                            <L 106>
    var_0 = wp::dot(var_ray_direction, var_plane_normal);
    // if wp.abs(denom) < 1.0e-12:                                                            <L 108>
    var_1 = wp::abs(var_0);
    var_3 = (var_1 < var_2);
    if (var_3) {
        // return ray_origin                                                                  <L 109>
        return var_ray_origin;
    }
    // t = -(wp.dot(ray_origin, plane_normal) + plane_d) / denom                              <L 113>
    var_4 = wp::dot(var_ray_origin, var_plane_normal);
    var_5 = wp::add(var_4, var_plane_d);
    var_6 = wp::neg(var_5);
    var_7 = wp::div(var_6, var_0);
    // return ray_origin + ray_direction * t                                                  <L 114>
    var_8 = wp::mul(var_ray_direction, var_7);
    var_9 = wp::add(var_ray_origin, var_8);
    return var_9;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:239
static CUDA_CALLABLE wp::vec_t<3, wp::float32> body_projector_project_0(
    BodyProjector_d067bb7a var_proj,
    wp::vec_t<3, wp::float32> var_input,
    wp::vec_t<3, wp::float32> var_contact_normal)
{
    //---------
    // primal vars
    wp::float32* var_0;
    wp::vec_t<3, wp::float32>* var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::float32 var_3;
    wp::vec_t<3, wp::float32> var_4;
    //---------
    // forward
    // def body_projector_project(                                                            <L 240>
    // return ray_plane_intersection(input, contact_normal, proj.plane_d, proj.normal)        <L 260>
    var_0 = &((var_proj).plane_d);
    var_1 = &((var_proj).normal);
    var_3 = wp::load(var_0);
    var_4 = wp::load(var_1);
    var_2 = ray_plane_intersection_0(var_input, var_contact_normal, var_3, var_4);
    return var_2;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:0
static CUDA_CALLABLE void create_build_manifold__locals__extract_4_point_contact_manifolds_8(
    wp::array_t<wp::vec_t<2, wp::float32>> var_m_a,
    wp::int32 var_m_a_count,
    wp::fixedarray_t<10, wp::vec_t<2, wp::float32>> var_m_b,
    wp::int32 var_m_b_count,
    wp::vec_t<3, wp::float32> var_normal_local,
    wp::vec_t<3, wp::float32> var_cross_vector_1,
    wp::vec_t<3, wp::float32> var_cross_vector_2,
    wp::vec_t<3, wp::float32> var_center_local,
    BodyProjector_d067bb7a var_projector_a,
    BodyProjector_d067bb7a var_projector_b,
    wp::quat_t<wp::float32> var_orientation_a,
    wp::vec_t<3, wp::float32> var_position_a_world,
    wp::vec_t<3, wp::float32> var_normal_world,
    GlobalContactReducerData_98513266 var_writer_data,
    ContactData_40360d7c var_contact_template,
    GenericShapeData_ceaba563 var_geom_a,
    GenericShapeData_ceaba563 var_geom_b,
    wp::vec_t<3, wp::float32> var_position_a,
    wp::vec_t<3, wp::float32> var_position_b,
    wp::quat_t<wp::float32> var_quaternion_a,
    wp::quat_t<wp::float32> var_quaternion_b,
    wp::int32 & ret_0,
    wp::float32 & ret_1)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32>* var_0;
    wp::vec_t<3, wp::float32>* var_1;
    wp::float32 var_2;
    wp::vec_t<3, wp::float32> var_3;
    wp::vec_t<3, wp::float32> var_4;
    wp::float32 var_5;
    wp::int32 var_6;
    const wp::float32 var_7 = 1e-05;
    wp::int32 var_8;
    const wp::int32 var_9 = 1;
    bool var_10;
    wp::vec_t<4, wp::int32> var_11;
    const wp::int32 var_12 = 4;
    bool var_13;
    wp::vec_t<4, wp::int32> var_14;
    const wp::int32 var_15 = 4;
    const wp::int32 var_16 = 0;
    const wp::int32 var_17 = 1;
    const wp::int32 var_18 = 2;
    const wp::int32 var_19 = 3;
    wp::vec_t<4, wp::int32> var_20;
    wp::int32 var_21;
    wp::vec_t<4, wp::int32> var_22;
    wp::range_t var_23;
    wp::int32 var_24;
    wp::int32 var_25;
    wp::int32 var_26;
    wp::vec_t<2, wp::float32>* var_27;
    const wp::int32 var_28 = 0;
    wp::float32 var_29;
    wp::vec_t<2, wp::float32> var_30;
    wp::vec_t<3, wp::float32> var_31;
    wp::vec_t<2, wp::float32>* var_32;
    const wp::int32 var_33 = 1;
    wp::float32 var_34;
    wp::vec_t<2, wp::float32> var_35;
    wp::vec_t<3, wp::float32> var_36;
    wp::vec_t<3, wp::float32> var_37;
    wp::vec_t<3, wp::float32> var_38;
    wp::vec_t<3, wp::float32> var_39;
    wp::vec_t<3, wp::float32> var_40;
    const wp::float32 var_41 = 0.5;
    wp::vec_t<3, wp::float32> var_42;
    wp::vec_t<3, wp::float32> var_43;
    wp::vec_t<3, wp::float32> var_44;
    wp::float32 var_45;
    wp::vec_t<3, wp::float32> var_46;
    wp::vec_t<3, wp::float32> var_47;
    ContactData_40360d7c var_48;
    wp::int32* var_49;
    const wp::int32 var_50 = 3;
    wp::int32 var_51;
    wp::int32 var_52;
    wp::int32 var_53;
    ContactData_40360d7c var_54;
    const wp::int32 var_55 = -1;
    const wp::float32 var_56 = 0.0;
    const wp::int32 var_57 = 0;
    wp::float32 var_58;
    wp::int32 var_59;
    //---------
    // forward
    // def extract_4_point_contact_manifolds(                                                 <L 1>
    // normal_dot = wp.abs(wp.dot(projector_a.normal, projector_b.normal))                    <L 59>
    var_0 = &((var_projector_a).normal);
    var_1 = &((var_projector_b).normal);
    var_3 = wp::load(var_0);
    var_4 = wp::load(var_1);
    var_2 = wp::dot(var_3, var_4);
    var_5 = wp::abs(var_2);
    // loop_count = trim_all_in_place(m_a, m_a_count, m_b, m_b_count)                         <L 61>
    var_6 = trim_all_in_place_0(var_m_a, var_m_a_count, var_m_b, var_m_b_count);
    // loop_count = remove_zero_length_edges(m_b, loop_count, EPS)                            <L 63>
    var_8 = remove_zero_length_edges_0(var_m_b, var_6, var_7);
    // if loop_count > 1:                                                                     <L 65>
    var_10 = (var_8 > var_9);
    if (var_10) {
        // result = wp.vec4i()                                                                <L 66>
        var_11 = wp::vec_t<4, wp::int32>();
        // if loop_count > 4:                                                                 <L 67>
        var_13 = (var_8 > var_12);
        if (var_13) {
            // result = approx_max_quadrilateral_area_with_calipers(m_b, loop_count)          <L 68>
            var_14 = approx_max_quadrilateral_area_with_calipers_0(var_m_b, var_8);
            // loop_count = 4                                                                 <L 69>
        }
        if (!var_13) {
            // result = wp.vec4i(0, 1, 2, 3)                                                  <L 71>
            var_20 = wp::vec_t<4, wp::int32>(var_16, var_17, var_18, var_19);
        }
        var_21 = wp::where(var_13, var_15, var_8);
        var_22 = wp::where(var_13, var_14, var_20);
        // for i in range(loop_count):                                                        <L 73>
        var_23 = wp::range(var_21);
        start_for_0:;
            if (iter_cmp(var_23) == 0) goto end_for_0;
            var_24 = wp::iter_next(var_23);
            // ia = int(result[i])                                                            <L 74>
            var_25 = wp::extract(var_22, var_24);
            var_26 = wp::int(var_25);
            // p_local = m_b[ia].x * cross_vector_1 + m_b[ia].y * cross_vector_2 + center_local       <L 77>
            var_27 = wp::address(var_m_b, var_26);
            var_30 = wp::load(var_27);
            var_29 = wp::extract(var_30, var_28);
            var_31 = wp::mul(var_29, var_cross_vector_1);
            var_32 = wp::address(var_m_b, var_26);
            var_35 = wp::load(var_32);
            var_34 = wp::extract(var_35, var_33);
            var_36 = wp::mul(var_34, var_cross_vector_2);
            var_37 = wp::add(var_31, var_36);
            var_38 = wp::add(var_37, var_center_local);
            // a = body_projector_project(projector_a, p_local, normal_local)                 <L 79>
            var_39 = body_projector_project_0(var_projector_a, var_38, var_normal_local);
            // b = body_projector_project(projector_b, p_local, normal_local)                 <L 80>
            var_40 = body_projector_project_0(var_projector_b, var_38, var_normal_local);
            // contact_point_local = 0.5 * (a + b)                                            <L 81>
            var_42 = wp::add(var_39, var_40);
            var_43 = wp::mul(var_41, var_42);
            // signed_distance = wp.dot(b - a, normal_local)                                  <L 82>
            var_44 = wp::sub(var_40, var_39);
            var_45 = wp::dot(var_44, var_normal_local);
            // contact_point_world = wp.quat_rotate(orientation_a, contact_point_local) + position_a_world       <L 85>
            var_46 = wp::quat_rotate(var_orientation_a, var_43);
            var_47 = wp::add(var_46, var_position_a_world);
            // contact_data = contact_template                                                <L 87>
            var_48 = wp::copy(var_contact_template);
            // contact_data.contact_point_center = contact_point_world                        <L 88>
            var_48.contact_point_center = var_47;
            // contact_data.contact_normal_a_to_b = normal_world                              <L 89>
            var_48.contact_normal_a_to_b = var_normal_world;
            // contact_data.contact_distance = signed_distance                                <L 90>
            var_48.contact_distance = var_45;
            // contact_data.sort_sub_key = (contact_template.sort_sub_key << 3) | i           <L 91>
            var_49 = &((var_contact_template).sort_sub_key);
            var_52 = wp::load(var_49);
            var_51 = wp::lshift(var_52, var_50);
            var_53 = wp::bit_or(var_51, var_24);
            var_48.sort_sub_key = var_53;
            // contact_data = post_process_contact(                                           <L 93>
            // contact_data, geom_a, position_a, quaternion_a, geom_b, position_b, quaternion_b       <L 94>
            var_54 = post_process_axial_on_discrete_contact_0(var_48, var_geom_a, var_position_a, var_quaternion_a, var_geom_b, var_position_b, var_quaternion_b);
            // writer_func(contact_data, writer_data, -1)                                     <L 96>
            write_contact_to_reducer_0(var_54, var_writer_data, var_55);
            goto start_for_0;
        end_for_0:;
    }
    if (!var_10) {
        // normal_dot = 0.0                                                                   <L 98>
        // loop_count = 0                                                                     <L 99>
    }
    var_58 = wp::where(var_10, var_5, var_56);
    var_59 = wp::where(var_10, var_21, var_57);
    // return loop_count, normal_dot                                                          <L 101>
    ret_0 = var_59;
    ret_1 = var_58;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:38
static CUDA_CALLABLE bool should_include_deepest_contact_0(
    wp::float32 var_normal_dot)
{
    //---------
    // primal vars
    const wp::float32 var_0 = 0.9999984769132877;
    bool var_1;
    //---------
    // forward
    // def should_include_deepest_contact(normal_dot: float) -> bool:                         <L 39>
    // return normal_dot < COS_DEEPEST_CONTACT_THRESHOLD_ANGLE                                <L 40>
    var_1 = (var_normal_dot < var_0);
    return var_1;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:0
static CUDA_CALLABLE wp::int32 create_build_manifold__locals__build_manifold_8(
    GenericShapeData_ceaba563 var_geom_a,
    GenericShapeData_ceaba563 var_geom_b,
    wp::quat_t<wp::float32> var_orientation_a,
    wp::vec_t<3, wp::float32> var_position_a_world,
    wp::quat_t<wp::float32> var_relative_orientation_b,
    wp::vec_t<3, wp::float32> var_relative_position_b,
    wp::vec_t<3, wp::float32> var_p_a,
    wp::vec_t<3, wp::float32> var_p_b,
    wp::vec_t<3, wp::float32> var_normal,
    SupportMapDataProvider_e77f8b9f var_data_provider,
    GlobalContactReducerData_98513266 var_writer_data,
    ContactData_40360d7c var_contact_template)
{
    //---------
    // primal vars
    const wp::float32 var_0 = 1.0;
    wp::float32 var_1;
    const wp::float32 var_2 = 0.0;
    wp::float32 var_3;
    const wp::float32 var_4 = 0.30901699437494745;
    const wp::float32 var_5 = 0.9510565162951535;
    const wp::float32 var_6 = -0.8090169943749473;
    const wp::float32 var_7 = 0.5877852522924732;
    const wp::float32 var_8 = -0.8090169943749476;
    const wp::float32 var_9 = -0.587785252292473;
    const wp::float32 var_10 = 0.30901699437494723;
    const wp::float32 var_11 = -0.9510565162951536;
    const wp::int32 var_12 = 0;
    wp::int32 var_13;
    const wp::int32 var_14 = 0;
    wp::int32 var_15;
    wp::vec_t<3, wp::float32> var_16;
    wp::vec_t<3, wp::float32> var_17;
    IncrementalPlaneTracker_8af6ef33 var_18;
    IncrementalPlaneTracker_8af6ef33 var_19;
    const wp::float32 var_20 = 0.5;
    wp::vec_t<3, wp::float32> var_21;
    wp::vec_t<3, wp::float32> var_22;
    const wp::int32 var_23 = 10;
    wp::tuple_t<wp::int32> var_24;
    wp::fixedarray_t<10, wp::vec_t<2, wp::float32>> var_25;
    const wp::int32 var_26 = 10;
    wp::uint64* var_27;
    const wp::int32 var_28 = 5;
    const wp::int32 var_29 = 8;
    wp::int32 var_30;
    wp::uint64 var_31;
    wp::uint64 var_32;
    wp::uint64 var_33;
    const wp::int32 var_34 = 5;
    wp::tuple_t<wp::int32> var_35;
    wp::array_t<wp::vec_t<2, wp::float32>> var_36;
    const wp::int32 var_37 = 5;
    wp::vec_t<3, wp::float32> var_38;
    wp::vec_t<3, wp::float32> var_39;
    wp::vec_t<3, wp::float32> var_40;
    wp::vec_t<3, wp::float32> var_41;
    wp::vec_t<3, wp::float32> var_42;
    wp::vec_t<3, wp::float32> var_43;
    const wp::int32 var_44 = 0;
    wp::float32 var_45;
    wp::float32 var_46;
    const wp::int32 var_47 = 1;
    bool var_48;
    wp::float32 var_49;
    wp::float32 var_50;
    const wp::int32 var_51 = 2;
    bool var_52;
    wp::float32 var_53;
    wp::float32 var_54;
    const wp::int32 var_55 = 3;
    bool var_56;
    wp::float32 var_57;
    wp::float32 var_58;
    const wp::int32 var_59 = 4;
    bool var_60;
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
    const wp::float32 var_71 = 0.9993908270190958;
    wp::float32 var_72;
    const wp::float32 var_73 = 0.03489949670250097;
    wp::float32 var_74;
    wp::float32 var_75;
    wp::vec_t<3, wp::float32> var_76;
    wp::vec_t<3, wp::float32> var_77;
    wp::vec_t<3, wp::float32> var_78;
    wp::vec_t<3, wp::float32> var_79;
    wp::vec_t<3, wp::float32> var_80;
    wp::vec_t<3, wp::float32> var_81;
    wp::vec_t<3, wp::float32> var_82;
    wp::float32 var_83;
    wp::float32 var_84;
    wp::vec_t<2, wp::float32> var_85;
    const wp::float32 var_86 = 1e-05;
    wp::int32 var_87;
    bool var_88;
    const wp::int32 var_89 = 1;
    wp::int32 var_90;
    IncrementalPlaneTracker_8af6ef33 var_91;
    IncrementalPlaneTracker_8af6ef33 var_92;
    wp::vec_t<3, wp::float32> var_93;
    wp::vec_t<3, wp::float32> var_94;
    wp::vec_t<3, wp::float32> var_95;
    wp::vec_t<3, wp::float32> var_96;
    wp::vec_t<3, wp::float32> var_97;
    wp::vec_t<3, wp::float32> var_98;
    wp::vec_t<3, wp::float32> var_99;
    wp::vec_t<3, wp::float32> var_100;
    wp::vec_t<3, wp::float32> var_101;
    wp::float32 var_102;
    wp::float32 var_103;
    wp::vec_t<2, wp::float32> var_104;
    wp::int32 var_105;
    bool var_106;
    const wp::int32 var_107 = 1;
    wp::int32 var_108;
    IncrementalPlaneTracker_8af6ef33 var_109;
    IncrementalPlaneTracker_8af6ef33 var_110;
    const wp::int32 var_111 = 1;
    wp::float32 var_112;
    wp::float32 var_113;
    const wp::int32 var_114 = 1;
    bool var_115;
    wp::float32 var_116;
    wp::float32 var_117;
    const wp::int32 var_118 = 2;
    bool var_119;
    wp::float32 var_120;
    wp::float32 var_121;
    const wp::int32 var_122 = 3;
    bool var_123;
    wp::float32 var_124;
    wp::float32 var_125;
    const wp::int32 var_126 = 4;
    bool var_127;
    wp::float32 var_128;
    wp::float32 var_129;
    wp::float32 var_130;
    wp::float32 var_131;
    wp::float32 var_132;
    wp::float32 var_133;
    wp::float32 var_134;
    wp::float32 var_135;
    wp::float32 var_136;
    wp::float32 var_137;
    wp::float32 var_138;
    wp::float32 var_139;
    wp::float32 var_140;
    wp::vec_t<3, wp::float32> var_141;
    wp::vec_t<3, wp::float32> var_142;
    wp::vec_t<3, wp::float32> var_143;
    wp::vec_t<3, wp::float32> var_144;
    wp::vec_t<3, wp::float32> var_145;
    wp::vec_t<3, wp::float32> var_146;
    wp::vec_t<3, wp::float32> var_147;
    wp::float32 var_148;
    wp::float32 var_149;
    wp::vec_t<2, wp::float32> var_150;
    wp::int32 var_151;
    bool var_152;
    const wp::int32 var_153 = 1;
    wp::int32 var_154;
    IncrementalPlaneTracker_8af6ef33 var_155;
    IncrementalPlaneTracker_8af6ef33 var_156;
    wp::vec_t<3, wp::float32> var_157;
    wp::vec_t<3, wp::float32> var_158;
    wp::vec_t<3, wp::float32> var_159;
    wp::vec_t<3, wp::float32> var_160;
    wp::vec_t<3, wp::float32> var_161;
    wp::vec_t<3, wp::float32> var_162;
    wp::vec_t<3, wp::float32> var_163;
    wp::vec_t<3, wp::float32> var_164;
    wp::vec_t<3, wp::float32> var_165;
    wp::float32 var_166;
    wp::float32 var_167;
    wp::vec_t<2, wp::float32> var_168;
    wp::int32 var_169;
    bool var_170;
    const wp::int32 var_171 = 1;
    wp::int32 var_172;
    IncrementalPlaneTracker_8af6ef33 var_173;
    IncrementalPlaneTracker_8af6ef33 var_174;
    const wp::int32 var_175 = 2;
    wp::float32 var_176;
    wp::float32 var_177;
    const wp::int32 var_178 = 1;
    bool var_179;
    wp::float32 var_180;
    wp::float32 var_181;
    const wp::int32 var_182 = 2;
    bool var_183;
    wp::float32 var_184;
    wp::float32 var_185;
    const wp::int32 var_186 = 3;
    bool var_187;
    wp::float32 var_188;
    wp::float32 var_189;
    const wp::int32 var_190 = 4;
    bool var_191;
    wp::float32 var_192;
    wp::float32 var_193;
    wp::float32 var_194;
    wp::float32 var_195;
    wp::float32 var_196;
    wp::float32 var_197;
    wp::float32 var_198;
    wp::float32 var_199;
    wp::float32 var_200;
    wp::float32 var_201;
    wp::float32 var_202;
    wp::float32 var_203;
    wp::float32 var_204;
    wp::vec_t<3, wp::float32> var_205;
    wp::vec_t<3, wp::float32> var_206;
    wp::vec_t<3, wp::float32> var_207;
    wp::vec_t<3, wp::float32> var_208;
    wp::vec_t<3, wp::float32> var_209;
    wp::vec_t<3, wp::float32> var_210;
    wp::vec_t<3, wp::float32> var_211;
    wp::float32 var_212;
    wp::float32 var_213;
    wp::vec_t<2, wp::float32> var_214;
    wp::int32 var_215;
    bool var_216;
    const wp::int32 var_217 = 1;
    wp::int32 var_218;
    IncrementalPlaneTracker_8af6ef33 var_219;
    IncrementalPlaneTracker_8af6ef33 var_220;
    wp::vec_t<3, wp::float32> var_221;
    wp::vec_t<3, wp::float32> var_222;
    wp::vec_t<3, wp::float32> var_223;
    wp::vec_t<3, wp::float32> var_224;
    wp::vec_t<3, wp::float32> var_225;
    wp::vec_t<3, wp::float32> var_226;
    wp::vec_t<3, wp::float32> var_227;
    wp::vec_t<3, wp::float32> var_228;
    wp::vec_t<3, wp::float32> var_229;
    wp::float32 var_230;
    wp::float32 var_231;
    wp::vec_t<2, wp::float32> var_232;
    wp::int32 var_233;
    bool var_234;
    const wp::int32 var_235 = 1;
    wp::int32 var_236;
    IncrementalPlaneTracker_8af6ef33 var_237;
    IncrementalPlaneTracker_8af6ef33 var_238;
    const wp::int32 var_239 = 3;
    wp::float32 var_240;
    wp::float32 var_241;
    const wp::int32 var_242 = 1;
    bool var_243;
    wp::float32 var_244;
    wp::float32 var_245;
    const wp::int32 var_246 = 2;
    bool var_247;
    wp::float32 var_248;
    wp::float32 var_249;
    const wp::int32 var_250 = 3;
    bool var_251;
    wp::float32 var_252;
    wp::float32 var_253;
    const wp::int32 var_254 = 4;
    bool var_255;
    wp::float32 var_256;
    wp::float32 var_257;
    wp::float32 var_258;
    wp::float32 var_259;
    wp::float32 var_260;
    wp::float32 var_261;
    wp::float32 var_262;
    wp::float32 var_263;
    wp::float32 var_264;
    wp::float32 var_265;
    wp::float32 var_266;
    wp::float32 var_267;
    wp::float32 var_268;
    wp::vec_t<3, wp::float32> var_269;
    wp::vec_t<3, wp::float32> var_270;
    wp::vec_t<3, wp::float32> var_271;
    wp::vec_t<3, wp::float32> var_272;
    wp::vec_t<3, wp::float32> var_273;
    wp::vec_t<3, wp::float32> var_274;
    wp::vec_t<3, wp::float32> var_275;
    wp::float32 var_276;
    wp::float32 var_277;
    wp::vec_t<2, wp::float32> var_278;
    wp::int32 var_279;
    bool var_280;
    const wp::int32 var_281 = 1;
    wp::int32 var_282;
    IncrementalPlaneTracker_8af6ef33 var_283;
    IncrementalPlaneTracker_8af6ef33 var_284;
    wp::vec_t<3, wp::float32> var_285;
    wp::vec_t<3, wp::float32> var_286;
    wp::vec_t<3, wp::float32> var_287;
    wp::vec_t<3, wp::float32> var_288;
    wp::vec_t<3, wp::float32> var_289;
    wp::vec_t<3, wp::float32> var_290;
    wp::vec_t<3, wp::float32> var_291;
    wp::vec_t<3, wp::float32> var_292;
    wp::vec_t<3, wp::float32> var_293;
    wp::float32 var_294;
    wp::float32 var_295;
    wp::vec_t<2, wp::float32> var_296;
    wp::int32 var_297;
    bool var_298;
    const wp::int32 var_299 = 1;
    wp::int32 var_300;
    IncrementalPlaneTracker_8af6ef33 var_301;
    IncrementalPlaneTracker_8af6ef33 var_302;
    const wp::int32 var_303 = 4;
    wp::float32 var_304;
    wp::float32 var_305;
    const wp::int32 var_306 = 1;
    bool var_307;
    wp::float32 var_308;
    wp::float32 var_309;
    const wp::int32 var_310 = 2;
    bool var_311;
    wp::float32 var_312;
    wp::float32 var_313;
    const wp::int32 var_314 = 3;
    bool var_315;
    wp::float32 var_316;
    wp::float32 var_317;
    const wp::int32 var_318 = 4;
    bool var_319;
    wp::float32 var_320;
    wp::float32 var_321;
    wp::float32 var_322;
    wp::float32 var_323;
    wp::float32 var_324;
    wp::float32 var_325;
    wp::float32 var_326;
    wp::float32 var_327;
    wp::float32 var_328;
    wp::float32 var_329;
    wp::float32 var_330;
    wp::float32 var_331;
    wp::float32 var_332;
    wp::vec_t<3, wp::float32> var_333;
    wp::vec_t<3, wp::float32> var_334;
    wp::vec_t<3, wp::float32> var_335;
    wp::vec_t<3, wp::float32> var_336;
    wp::vec_t<3, wp::float32> var_337;
    wp::vec_t<3, wp::float32> var_338;
    wp::vec_t<3, wp::float32> var_339;
    wp::float32 var_340;
    wp::float32 var_341;
    wp::vec_t<2, wp::float32> var_342;
    wp::int32 var_343;
    bool var_344;
    const wp::int32 var_345 = 1;
    wp::int32 var_346;
    IncrementalPlaneTracker_8af6ef33 var_347;
    IncrementalPlaneTracker_8af6ef33 var_348;
    wp::vec_t<3, wp::float32> var_349;
    wp::vec_t<3, wp::float32> var_350;
    wp::vec_t<3, wp::float32> var_351;
    wp::vec_t<3, wp::float32> var_352;
    wp::vec_t<3, wp::float32> var_353;
    wp::vec_t<3, wp::float32> var_354;
    wp::vec_t<3, wp::float32> var_355;
    wp::vec_t<3, wp::float32> var_356;
    wp::vec_t<3, wp::float32> var_357;
    wp::float32 var_358;
    wp::float32 var_359;
    wp::vec_t<2, wp::float32> var_360;
    wp::int32 var_361;
    bool var_362;
    const wp::int32 var_363 = 1;
    wp::int32 var_364;
    IncrementalPlaneTracker_8af6ef33 var_365;
    IncrementalPlaneTracker_8af6ef33 var_366;
    wp::vec_t<3, wp::float32> var_367;
    wp::vec_t<3, wp::float32> var_368;
    wp::vec_t<3, wp::float32> var_369;
    wp::vec_t<3, wp::float32> var_370;
    wp::quat_t<wp::float32> var_371;
    wp::quat_t<wp::float32> var_372;
    bool var_373;
    const wp::int32 var_374 = 2;
    bool var_375;
    const wp::int32 var_376 = 2;
    bool var_377;
    const wp::int32 var_378 = 0;
    const wp::float32 var_379 = 0.0;
    BodyProjector_d067bb7a var_380;
    BodyProjector_d067bb7a var_381;
    bool var_382;
    wp::vec_t<3, wp::float32>* var_383;
    bool var_384;
    wp::vec_t<3, wp::float32> var_385;
    wp::vec_t<3, wp::float32>* var_386;
    bool var_387;
    wp::vec_t<3, wp::float32> var_388;
    const wp::int32 var_389 = 0;
    const wp::float32 var_390 = 0.0;
    wp::int32 var_391;
    wp::float32 var_392;
    const wp::int32 var_393 = 4;
    wp::int32 var_394;
    wp::int32 var_395;
    wp::float32 var_396;
    wp::int32 var_397;
    wp::float32 var_398;
    bool var_399;
    bool var_400;
    const wp::int32 var_401 = 0;
    bool var_402;
    const wp::float32 var_403 = 0.5;
    wp::vec_t<3, wp::float32> var_404;
    wp::vec_t<3, wp::float32> var_405;
    wp::vec_t<3, wp::float32> var_406;
    wp::float32 var_407;
    wp::vec_t<3, wp::float32> var_408;
    wp::vec_t<3, wp::float32> var_409;
    ContactData_40360d7c var_410;
    wp::int32* var_411;
    const wp::int32 var_412 = 3;
    wp::int32 var_413;
    wp::int32 var_414;
    wp::int32 var_415;
    ContactData_40360d7c var_416;
    const wp::int32 var_417 = -1;
    const wp::int32 var_418 = 1;
    wp::int32 var_419;
    wp::int32 var_420;
    //---------
    // forward
    // def build_manifold(                                                                    <L 1>
    // PENT_COS_0 = float(1.0)                                                                <L 41>
    var_1 = wp::float(var_0);
    // PENT_SIN_0 = float(0.0)                                                                <L 42>
    var_3 = wp::float(var_2);
    // PENT_COS_1 = wp.static(math.cos(2.0 * math.pi / 5.0))                                  <L 43>
    // PENT_SIN_1 = wp.static(math.sin(2.0 * math.pi / 5.0))                                  <L 44>
    // PENT_COS_2 = wp.static(math.cos(4.0 * math.pi / 5.0))                                  <L 45>
    // PENT_SIN_2 = wp.static(math.sin(4.0 * math.pi / 5.0))                                  <L 46>
    // PENT_COS_3 = wp.static(math.cos(6.0 * math.pi / 5.0))                                  <L 47>
    // PENT_SIN_3 = wp.static(math.sin(6.0 * math.pi / 5.0))                                  <L 48>
    // PENT_COS_4 = wp.static(math.cos(8.0 * math.pi / 5.0))                                  <L 49>
    // PENT_SIN_4 = wp.static(math.sin(8.0 * math.pi / 5.0))                                  <L 50>
    // a_count = int(0)                                                                       <L 52>
    var_13 = wp::int(var_12);
    // b_count = int(0)                                                                       <L 53>
    var_15 = wp::int(var_14);
    // tangent_a, tangent_b = orthonormal_basis(normal)                                       <L 56>
    orthonormal_basis_0(var_normal, var_16, var_17);
    // plane_tracker_a = IncrementalPlaneTracker()                                            <L 58>
    var_18 = IncrementalPlaneTracker_8af6ef33();
    // plane_tracker_b = IncrementalPlaneTracker()                                            <L 59>
    var_19 = IncrementalPlaneTracker_8af6ef33();
    // center = 0.5 * (p_a + p_b)                                                             <L 61>
    var_21 = wp::add(var_p_a, var_p_b);
    var_22 = wp::mul(var_20, var_21);
    // b_buffer = wp.zeros(shape=(10,), dtype=wp.vec2f)                                       <L 64>
    var_24 = wp::tuple(var_23);
    var_25 = wp::fixedarray_t<10, wp::vec_t<2, wp::float32>>(var_26);
    // a_buffer = wp.array(ptr=b_buffer.ptr + wp.uint64(5 * 8), shape=(5,), dtype=wp.vec2f)       <L 65>
    var_27 = (wp::uint64*)&(var_25.data);
    var_30 = wp::mul(var_28, var_29);
    var_31 = wp::uint64(var_30);
    var_33 = wp::load(var_27);
    var_32 = wp::add(var_33, var_31);
    var_35 = wp::tuple(var_34);
    var_36 = wp::array_t<wp::vec_t<2, wp::float32>>(var_32, var_37);
    // local_normal_b = wp.quat_rotate_inv(relative_orientation_b, -normal)                   <L 70>
    var_38 = wp::neg(var_normal);
    var_39 = wp::quat_rotate_inv(var_relative_orientation_b, var_38);
    // local_ta_b = wp.quat_rotate_inv(relative_orientation_b, -tangent_a)                    <L 71>
    var_40 = wp::neg(var_16);
    var_41 = wp::quat_rotate_inv(var_relative_orientation_b, var_40);
    // local_tb_b = wp.quat_rotate_inv(relative_orientation_b, -tangent_b)                    <L 72>
    var_42 = wp::neg(var_17);
    var_43 = wp::quat_rotate_inv(var_relative_orientation_b, var_42);
    // for e in range(5):                                                                     <L 74>
    // c = PENT_COS_0                                                                         <L 75>
    var_45 = wp::copy(var_1);
    // s = PENT_SIN_0                                                                         <L 76>
    var_46 = wp::copy(var_3);
    // if e == 1:                                                                             <L 77>
    var_48 = (var_44 == var_47);
    if (var_48) {
        // c = PENT_COS_1                                                                     <L 78>
        var_49 = wp::copy(var_4);
        // s = PENT_SIN_1                                                                     <L 79>
        var_50 = wp::copy(var_5);
    }
    if (!var_48) {
        // elif e == 2:                                                                       <L 80>
        var_52 = (var_44 == var_51);
        if (var_52) {
            // c = PENT_COS_2                                                                 <L 81>
            var_53 = wp::copy(var_6);
            // s = PENT_SIN_2                                                                 <L 82>
            var_54 = wp::copy(var_7);
        }
        if (!var_52) {
            // elif e == 3:                                                                   <L 83>
            var_56 = (var_44 == var_55);
            if (var_56) {
                // c = PENT_COS_3                                                             <L 84>
                var_57 = wp::copy(var_8);
                // s = PENT_SIN_3                                                             <L 85>
                var_58 = wp::copy(var_9);
            }
            if (!var_56) {
                // elif e == 4:                                                               <L 86>
                var_60 = (var_44 == var_59);
                if (var_60) {
                    // c = PENT_COS_4                                                         <L 87>
                    var_61 = wp::copy(var_10);
                    // s = PENT_SIN_4                                                         <L 88>
                    var_62 = wp::copy(var_11);
                }
                var_63 = wp::where(var_60, var_61, var_45);
                var_64 = wp::where(var_60, var_62, var_46);
            }
            var_65 = wp::where(var_56, var_57, var_63);
            var_66 = wp::where(var_56, var_58, var_64);
        }
        var_67 = wp::where(var_52, var_53, var_65);
        var_68 = wp::where(var_52, var_54, var_66);
    }
    var_69 = wp::where(var_48, var_49, var_67);
    var_70 = wp::where(var_48, var_50, var_68);
    // cos_tilt = COS_TILT_ANGLE                                                              <L 90>
    var_72 = wp::copy(var_71);
    // c_sin = c * SIN_TILT_ANGLE                                                             <L 91>
    var_74 = wp::mul(var_69, var_73);
    // s_sin = s * SIN_TILT_ANGLE                                                             <L 92>
    var_75 = wp::mul(var_70, var_73);
    // dir_a = normal * cos_tilt + c_sin * tangent_a + s_sin * tangent_b                      <L 95>
    var_76 = wp::mul(var_normal, var_72);
    var_77 = wp::mul(var_74, var_16);
    var_78 = wp::add(var_76, var_77);
    var_79 = wp::mul(var_75, var_17);
    var_80 = wp::add(var_78, var_79);
    // pt_a_3d = support_func(geom_a, dir_a, data_provider)                                   <L 96>
    var_81 = support_map_0(var_geom_a, var_80, var_data_provider);
    // projected_a = pt_a_3d - center                                                         <L 97>
    var_82 = wp::sub(var_81, var_22);
    // pt_a_2d = wp.vec2(wp.dot(tangent_a, projected_a), wp.dot(tangent_b, projected_a))       <L 98>
    var_83 = wp::dot(var_16, var_82);
    var_84 = wp::dot(var_17, var_82);
    var_85 = wp::vec_t<2, wp::float32>(var_83, var_84);
    // a_count, was_added_a = add_avoid_duplicates_vec2(a_buffer, a_count, pt_a_2d, EPS)       <L 99>
    add_avoid_duplicates_vec2_0(var_36, var_13, var_85, var_86, var_87, var_88);
    // if was_added_a:                                                                        <L 100>
    if (var_88) {
        // plane_tracker_a = update_incremental_plane_tracker(plane_tracker_a, pt_a_3d, a_count - 1)       <L 101>
        var_90 = wp::sub(var_87, var_89);
        var_91 = update_incremental_plane_tracker_0(var_18, var_81, var_90);
    }
    var_92 = wp::where(var_88, var_91, var_18);
    // local_dir_b = local_normal_b * cos_tilt + c_sin * local_ta_b + s_sin * local_tb_b       <L 104>
    var_93 = wp::mul(var_39, var_72);
    var_94 = wp::mul(var_74, var_41);
    var_95 = wp::add(var_93, var_94);
    var_96 = wp::mul(var_75, var_43);
    var_97 = wp::add(var_95, var_96);
    // pt_b_local = support_func(geom_b, local_dir_b, data_provider)                          <L 105>
    var_98 = support_map_0(var_geom_b, var_97, var_data_provider);
    // pt_b_3d = wp.quat_rotate(relative_orientation_b, pt_b_local) + relative_position_b       <L 106>
    var_99 = wp::quat_rotate(var_relative_orientation_b, var_98);
    var_100 = wp::add(var_99, var_relative_position_b);
    // projected_b = pt_b_3d - center                                                         <L 107>
    var_101 = wp::sub(var_100, var_22);
    // pt_b_2d = wp.vec2(wp.dot(tangent_a, projected_b), wp.dot(tangent_b, projected_b))       <L 108>
    var_102 = wp::dot(var_16, var_101);
    var_103 = wp::dot(var_17, var_101);
    var_104 = wp::vec_t<2, wp::float32>(var_102, var_103);
    // b_count, was_added_b = add_avoid_duplicates_vec2(b_buffer, b_count, pt_b_2d, EPS)       <L 109>
    add_avoid_duplicates_vec2_0(var_25, var_15, var_104, var_86, var_105, var_106);
    // if was_added_b:                                                                        <L 110>
    if (var_106) {
        // plane_tracker_b = update_incremental_plane_tracker(plane_tracker_b, pt_b_3d, b_count - 1)       <L 111>
        var_108 = wp::sub(var_105, var_107);
        var_109 = update_incremental_plane_tracker_0(var_19, var_100, var_108);
    }
    var_110 = wp::where(var_106, var_109, var_19);
    // c = PENT_COS_0                                                                         <L 75>
    var_112 = wp::copy(var_1);
    // s = PENT_SIN_0                                                                         <L 76>
    var_113 = wp::copy(var_3);
    // if e == 1:                                                                             <L 77>
    var_115 = (var_111 == var_114);
    if (var_115) {
        // c = PENT_COS_1                                                                     <L 78>
        var_116 = wp::copy(var_4);
        // s = PENT_SIN_1                                                                     <L 79>
        var_117 = wp::copy(var_5);
    }
    if (!var_115) {
        // elif e == 2:                                                                       <L 80>
        var_119 = (var_111 == var_118);
        if (var_119) {
            // c = PENT_COS_2                                                                 <L 81>
            var_120 = wp::copy(var_6);
            // s = PENT_SIN_2                                                                 <L 82>
            var_121 = wp::copy(var_7);
        }
        if (!var_119) {
            // elif e == 3:                                                                   <L 83>
            var_123 = (var_111 == var_122);
            if (var_123) {
                // c = PENT_COS_3                                                             <L 84>
                var_124 = wp::copy(var_8);
                // s = PENT_SIN_3                                                             <L 85>
                var_125 = wp::copy(var_9);
            }
            if (!var_123) {
                // elif e == 4:                                                               <L 86>
                var_127 = (var_111 == var_126);
                if (var_127) {
                    // c = PENT_COS_4                                                         <L 87>
                    var_128 = wp::copy(var_10);
                    // s = PENT_SIN_4                                                         <L 88>
                    var_129 = wp::copy(var_11);
                }
                var_130 = wp::where(var_127, var_128, var_112);
                var_131 = wp::where(var_127, var_129, var_113);
            }
            var_132 = wp::where(var_123, var_124, var_130);
            var_133 = wp::where(var_123, var_125, var_131);
        }
        var_134 = wp::where(var_119, var_120, var_132);
        var_135 = wp::where(var_119, var_121, var_133);
    }
    var_136 = wp::where(var_115, var_116, var_134);
    var_137 = wp::where(var_115, var_117, var_135);
    // cos_tilt = COS_TILT_ANGLE                                                              <L 90>
    var_138 = wp::copy(var_71);
    // c_sin = c * SIN_TILT_ANGLE                                                             <L 91>
    var_139 = wp::mul(var_136, var_73);
    // s_sin = s * SIN_TILT_ANGLE                                                             <L 92>
    var_140 = wp::mul(var_137, var_73);
    // dir_a = normal * cos_tilt + c_sin * tangent_a + s_sin * tangent_b                      <L 95>
    var_141 = wp::mul(var_normal, var_138);
    var_142 = wp::mul(var_139, var_16);
    var_143 = wp::add(var_141, var_142);
    var_144 = wp::mul(var_140, var_17);
    var_145 = wp::add(var_143, var_144);
    // pt_a_3d = support_func(geom_a, dir_a, data_provider)                                   <L 96>
    var_146 = support_map_0(var_geom_a, var_145, var_data_provider);
    // projected_a = pt_a_3d - center                                                         <L 97>
    var_147 = wp::sub(var_146, var_22);
    // pt_a_2d = wp.vec2(wp.dot(tangent_a, projected_a), wp.dot(tangent_b, projected_a))       <L 98>
    var_148 = wp::dot(var_16, var_147);
    var_149 = wp::dot(var_17, var_147);
    var_150 = wp::vec_t<2, wp::float32>(var_148, var_149);
    // a_count, was_added_a = add_avoid_duplicates_vec2(a_buffer, a_count, pt_a_2d, EPS)       <L 99>
    add_avoid_duplicates_vec2_0(var_36, var_87, var_150, var_86, var_151, var_152);
    // if was_added_a:                                                                        <L 100>
    if (var_152) {
        // plane_tracker_a = update_incremental_plane_tracker(plane_tracker_a, pt_a_3d, a_count - 1)       <L 101>
        var_154 = wp::sub(var_151, var_153);
        var_155 = update_incremental_plane_tracker_0(var_92, var_146, var_154);
    }
    var_156 = wp::where(var_152, var_155, var_92);
    // local_dir_b = local_normal_b * cos_tilt + c_sin * local_ta_b + s_sin * local_tb_b       <L 104>
    var_157 = wp::mul(var_39, var_138);
    var_158 = wp::mul(var_139, var_41);
    var_159 = wp::add(var_157, var_158);
    var_160 = wp::mul(var_140, var_43);
    var_161 = wp::add(var_159, var_160);
    // pt_b_local = support_func(geom_b, local_dir_b, data_provider)                          <L 105>
    var_162 = support_map_0(var_geom_b, var_161, var_data_provider);
    // pt_b_3d = wp.quat_rotate(relative_orientation_b, pt_b_local) + relative_position_b       <L 106>
    var_163 = wp::quat_rotate(var_relative_orientation_b, var_162);
    var_164 = wp::add(var_163, var_relative_position_b);
    // projected_b = pt_b_3d - center                                                         <L 107>
    var_165 = wp::sub(var_164, var_22);
    // pt_b_2d = wp.vec2(wp.dot(tangent_a, projected_b), wp.dot(tangent_b, projected_b))       <L 108>
    var_166 = wp::dot(var_16, var_165);
    var_167 = wp::dot(var_17, var_165);
    var_168 = wp::vec_t<2, wp::float32>(var_166, var_167);
    // b_count, was_added_b = add_avoid_duplicates_vec2(b_buffer, b_count, pt_b_2d, EPS)       <L 109>
    add_avoid_duplicates_vec2_0(var_25, var_105, var_168, var_86, var_169, var_170);
    // if was_added_b:                                                                        <L 110>
    if (var_170) {
        // plane_tracker_b = update_incremental_plane_tracker(plane_tracker_b, pt_b_3d, b_count - 1)       <L 111>
        var_172 = wp::sub(var_169, var_171);
        var_173 = update_incremental_plane_tracker_0(var_110, var_164, var_172);
    }
    var_174 = wp::where(var_170, var_173, var_110);
    // c = PENT_COS_0                                                                         <L 75>
    var_176 = wp::copy(var_1);
    // s = PENT_SIN_0                                                                         <L 76>
    var_177 = wp::copy(var_3);
    // if e == 1:                                                                             <L 77>
    var_179 = (var_175 == var_178);
    if (var_179) {
        // c = PENT_COS_1                                                                     <L 78>
        var_180 = wp::copy(var_4);
        // s = PENT_SIN_1                                                                     <L 79>
        var_181 = wp::copy(var_5);
    }
    if (!var_179) {
        // elif e == 2:                                                                       <L 80>
        var_183 = (var_175 == var_182);
        if (var_183) {
            // c = PENT_COS_2                                                                 <L 81>
            var_184 = wp::copy(var_6);
            // s = PENT_SIN_2                                                                 <L 82>
            var_185 = wp::copy(var_7);
        }
        if (!var_183) {
            // elif e == 3:                                                                   <L 83>
            var_187 = (var_175 == var_186);
            if (var_187) {
                // c = PENT_COS_3                                                             <L 84>
                var_188 = wp::copy(var_8);
                // s = PENT_SIN_3                                                             <L 85>
                var_189 = wp::copy(var_9);
            }
            if (!var_187) {
                // elif e == 4:                                                               <L 86>
                var_191 = (var_175 == var_190);
                if (var_191) {
                    // c = PENT_COS_4                                                         <L 87>
                    var_192 = wp::copy(var_10);
                    // s = PENT_SIN_4                                                         <L 88>
                    var_193 = wp::copy(var_11);
                }
                var_194 = wp::where(var_191, var_192, var_176);
                var_195 = wp::where(var_191, var_193, var_177);
            }
            var_196 = wp::where(var_187, var_188, var_194);
            var_197 = wp::where(var_187, var_189, var_195);
        }
        var_198 = wp::where(var_183, var_184, var_196);
        var_199 = wp::where(var_183, var_185, var_197);
    }
    var_200 = wp::where(var_179, var_180, var_198);
    var_201 = wp::where(var_179, var_181, var_199);
    // cos_tilt = COS_TILT_ANGLE                                                              <L 90>
    var_202 = wp::copy(var_71);
    // c_sin = c * SIN_TILT_ANGLE                                                             <L 91>
    var_203 = wp::mul(var_200, var_73);
    // s_sin = s * SIN_TILT_ANGLE                                                             <L 92>
    var_204 = wp::mul(var_201, var_73);
    // dir_a = normal * cos_tilt + c_sin * tangent_a + s_sin * tangent_b                      <L 95>
    var_205 = wp::mul(var_normal, var_202);
    var_206 = wp::mul(var_203, var_16);
    var_207 = wp::add(var_205, var_206);
    var_208 = wp::mul(var_204, var_17);
    var_209 = wp::add(var_207, var_208);
    // pt_a_3d = support_func(geom_a, dir_a, data_provider)                                   <L 96>
    var_210 = support_map_0(var_geom_a, var_209, var_data_provider);
    // projected_a = pt_a_3d - center                                                         <L 97>
    var_211 = wp::sub(var_210, var_22);
    // pt_a_2d = wp.vec2(wp.dot(tangent_a, projected_a), wp.dot(tangent_b, projected_a))       <L 98>
    var_212 = wp::dot(var_16, var_211);
    var_213 = wp::dot(var_17, var_211);
    var_214 = wp::vec_t<2, wp::float32>(var_212, var_213);
    // a_count, was_added_a = add_avoid_duplicates_vec2(a_buffer, a_count, pt_a_2d, EPS)       <L 99>
    add_avoid_duplicates_vec2_0(var_36, var_151, var_214, var_86, var_215, var_216);
    // if was_added_a:                                                                        <L 100>
    if (var_216) {
        // plane_tracker_a = update_incremental_plane_tracker(plane_tracker_a, pt_a_3d, a_count - 1)       <L 101>
        var_218 = wp::sub(var_215, var_217);
        var_219 = update_incremental_plane_tracker_0(var_156, var_210, var_218);
    }
    var_220 = wp::where(var_216, var_219, var_156);
    // local_dir_b = local_normal_b * cos_tilt + c_sin * local_ta_b + s_sin * local_tb_b       <L 104>
    var_221 = wp::mul(var_39, var_202);
    var_222 = wp::mul(var_203, var_41);
    var_223 = wp::add(var_221, var_222);
    var_224 = wp::mul(var_204, var_43);
    var_225 = wp::add(var_223, var_224);
    // pt_b_local = support_func(geom_b, local_dir_b, data_provider)                          <L 105>
    var_226 = support_map_0(var_geom_b, var_225, var_data_provider);
    // pt_b_3d = wp.quat_rotate(relative_orientation_b, pt_b_local) + relative_position_b       <L 106>
    var_227 = wp::quat_rotate(var_relative_orientation_b, var_226);
    var_228 = wp::add(var_227, var_relative_position_b);
    // projected_b = pt_b_3d - center                                                         <L 107>
    var_229 = wp::sub(var_228, var_22);
    // pt_b_2d = wp.vec2(wp.dot(tangent_a, projected_b), wp.dot(tangent_b, projected_b))       <L 108>
    var_230 = wp::dot(var_16, var_229);
    var_231 = wp::dot(var_17, var_229);
    var_232 = wp::vec_t<2, wp::float32>(var_230, var_231);
    // b_count, was_added_b = add_avoid_duplicates_vec2(b_buffer, b_count, pt_b_2d, EPS)       <L 109>
    add_avoid_duplicates_vec2_0(var_25, var_169, var_232, var_86, var_233, var_234);
    // if was_added_b:                                                                        <L 110>
    if (var_234) {
        // plane_tracker_b = update_incremental_plane_tracker(plane_tracker_b, pt_b_3d, b_count - 1)       <L 111>
        var_236 = wp::sub(var_233, var_235);
        var_237 = update_incremental_plane_tracker_0(var_174, var_228, var_236);
    }
    var_238 = wp::where(var_234, var_237, var_174);
    // c = PENT_COS_0                                                                         <L 75>
    var_240 = wp::copy(var_1);
    // s = PENT_SIN_0                                                                         <L 76>
    var_241 = wp::copy(var_3);
    // if e == 1:                                                                             <L 77>
    var_243 = (var_239 == var_242);
    if (var_243) {
        // c = PENT_COS_1                                                                     <L 78>
        var_244 = wp::copy(var_4);
        // s = PENT_SIN_1                                                                     <L 79>
        var_245 = wp::copy(var_5);
    }
    if (!var_243) {
        // elif e == 2:                                                                       <L 80>
        var_247 = (var_239 == var_246);
        if (var_247) {
            // c = PENT_COS_2                                                                 <L 81>
            var_248 = wp::copy(var_6);
            // s = PENT_SIN_2                                                                 <L 82>
            var_249 = wp::copy(var_7);
        }
        if (!var_247) {
            // elif e == 3:                                                                   <L 83>
            var_251 = (var_239 == var_250);
            if (var_251) {
                // c = PENT_COS_3                                                             <L 84>
                var_252 = wp::copy(var_8);
                // s = PENT_SIN_3                                                             <L 85>
                var_253 = wp::copy(var_9);
            }
            if (!var_251) {
                // elif e == 4:                                                               <L 86>
                var_255 = (var_239 == var_254);
                if (var_255) {
                    // c = PENT_COS_4                                                         <L 87>
                    var_256 = wp::copy(var_10);
                    // s = PENT_SIN_4                                                         <L 88>
                    var_257 = wp::copy(var_11);
                }
                var_258 = wp::where(var_255, var_256, var_240);
                var_259 = wp::where(var_255, var_257, var_241);
            }
            var_260 = wp::where(var_251, var_252, var_258);
            var_261 = wp::where(var_251, var_253, var_259);
        }
        var_262 = wp::where(var_247, var_248, var_260);
        var_263 = wp::where(var_247, var_249, var_261);
    }
    var_264 = wp::where(var_243, var_244, var_262);
    var_265 = wp::where(var_243, var_245, var_263);
    // cos_tilt = COS_TILT_ANGLE                                                              <L 90>
    var_266 = wp::copy(var_71);
    // c_sin = c * SIN_TILT_ANGLE                                                             <L 91>
    var_267 = wp::mul(var_264, var_73);
    // s_sin = s * SIN_TILT_ANGLE                                                             <L 92>
    var_268 = wp::mul(var_265, var_73);
    // dir_a = normal * cos_tilt + c_sin * tangent_a + s_sin * tangent_b                      <L 95>
    var_269 = wp::mul(var_normal, var_266);
    var_270 = wp::mul(var_267, var_16);
    var_271 = wp::add(var_269, var_270);
    var_272 = wp::mul(var_268, var_17);
    var_273 = wp::add(var_271, var_272);
    // pt_a_3d = support_func(geom_a, dir_a, data_provider)                                   <L 96>
    var_274 = support_map_0(var_geom_a, var_273, var_data_provider);
    // projected_a = pt_a_3d - center                                                         <L 97>
    var_275 = wp::sub(var_274, var_22);
    // pt_a_2d = wp.vec2(wp.dot(tangent_a, projected_a), wp.dot(tangent_b, projected_a))       <L 98>
    var_276 = wp::dot(var_16, var_275);
    var_277 = wp::dot(var_17, var_275);
    var_278 = wp::vec_t<2, wp::float32>(var_276, var_277);
    // a_count, was_added_a = add_avoid_duplicates_vec2(a_buffer, a_count, pt_a_2d, EPS)       <L 99>
    add_avoid_duplicates_vec2_0(var_36, var_215, var_278, var_86, var_279, var_280);
    // if was_added_a:                                                                        <L 100>
    if (var_280) {
        // plane_tracker_a = update_incremental_plane_tracker(plane_tracker_a, pt_a_3d, a_count - 1)       <L 101>
        var_282 = wp::sub(var_279, var_281);
        var_283 = update_incremental_plane_tracker_0(var_220, var_274, var_282);
    }
    var_284 = wp::where(var_280, var_283, var_220);
    // local_dir_b = local_normal_b * cos_tilt + c_sin * local_ta_b + s_sin * local_tb_b       <L 104>
    var_285 = wp::mul(var_39, var_266);
    var_286 = wp::mul(var_267, var_41);
    var_287 = wp::add(var_285, var_286);
    var_288 = wp::mul(var_268, var_43);
    var_289 = wp::add(var_287, var_288);
    // pt_b_local = support_func(geom_b, local_dir_b, data_provider)                          <L 105>
    var_290 = support_map_0(var_geom_b, var_289, var_data_provider);
    // pt_b_3d = wp.quat_rotate(relative_orientation_b, pt_b_local) + relative_position_b       <L 106>
    var_291 = wp::quat_rotate(var_relative_orientation_b, var_290);
    var_292 = wp::add(var_291, var_relative_position_b);
    // projected_b = pt_b_3d - center                                                         <L 107>
    var_293 = wp::sub(var_292, var_22);
    // pt_b_2d = wp.vec2(wp.dot(tangent_a, projected_b), wp.dot(tangent_b, projected_b))       <L 108>
    var_294 = wp::dot(var_16, var_293);
    var_295 = wp::dot(var_17, var_293);
    var_296 = wp::vec_t<2, wp::float32>(var_294, var_295);
    // b_count, was_added_b = add_avoid_duplicates_vec2(b_buffer, b_count, pt_b_2d, EPS)       <L 109>
    add_avoid_duplicates_vec2_0(var_25, var_233, var_296, var_86, var_297, var_298);
    // if was_added_b:                                                                        <L 110>
    if (var_298) {
        // plane_tracker_b = update_incremental_plane_tracker(plane_tracker_b, pt_b_3d, b_count - 1)       <L 111>
        var_300 = wp::sub(var_297, var_299);
        var_301 = update_incremental_plane_tracker_0(var_238, var_292, var_300);
    }
    var_302 = wp::where(var_298, var_301, var_238);
    // c = PENT_COS_0                                                                         <L 75>
    var_304 = wp::copy(var_1);
    // s = PENT_SIN_0                                                                         <L 76>
    var_305 = wp::copy(var_3);
    // if e == 1:                                                                             <L 77>
    var_307 = (var_303 == var_306);
    if (var_307) {
        // c = PENT_COS_1                                                                     <L 78>
        var_308 = wp::copy(var_4);
        // s = PENT_SIN_1                                                                     <L 79>
        var_309 = wp::copy(var_5);
    }
    if (!var_307) {
        // elif e == 2:                                                                       <L 80>
        var_311 = (var_303 == var_310);
        if (var_311) {
            // c = PENT_COS_2                                                                 <L 81>
            var_312 = wp::copy(var_6);
            // s = PENT_SIN_2                                                                 <L 82>
            var_313 = wp::copy(var_7);
        }
        if (!var_311) {
            // elif e == 3:                                                                   <L 83>
            var_315 = (var_303 == var_314);
            if (var_315) {
                // c = PENT_COS_3                                                             <L 84>
                var_316 = wp::copy(var_8);
                // s = PENT_SIN_3                                                             <L 85>
                var_317 = wp::copy(var_9);
            }
            if (!var_315) {
                // elif e == 4:                                                               <L 86>
                var_319 = (var_303 == var_318);
                if (var_319) {
                    // c = PENT_COS_4                                                         <L 87>
                    var_320 = wp::copy(var_10);
                    // s = PENT_SIN_4                                                         <L 88>
                    var_321 = wp::copy(var_11);
                }
                var_322 = wp::where(var_319, var_320, var_304);
                var_323 = wp::where(var_319, var_321, var_305);
            }
            var_324 = wp::where(var_315, var_316, var_322);
            var_325 = wp::where(var_315, var_317, var_323);
        }
        var_326 = wp::where(var_311, var_312, var_324);
        var_327 = wp::where(var_311, var_313, var_325);
    }
    var_328 = wp::where(var_307, var_308, var_326);
    var_329 = wp::where(var_307, var_309, var_327);
    // cos_tilt = COS_TILT_ANGLE                                                              <L 90>
    var_330 = wp::copy(var_71);
    // c_sin = c * SIN_TILT_ANGLE                                                             <L 91>
    var_331 = wp::mul(var_328, var_73);
    // s_sin = s * SIN_TILT_ANGLE                                                             <L 92>
    var_332 = wp::mul(var_329, var_73);
    // dir_a = normal * cos_tilt + c_sin * tangent_a + s_sin * tangent_b                      <L 95>
    var_333 = wp::mul(var_normal, var_330);
    var_334 = wp::mul(var_331, var_16);
    var_335 = wp::add(var_333, var_334);
    var_336 = wp::mul(var_332, var_17);
    var_337 = wp::add(var_335, var_336);
    // pt_a_3d = support_func(geom_a, dir_a, data_provider)                                   <L 96>
    var_338 = support_map_0(var_geom_a, var_337, var_data_provider);
    // projected_a = pt_a_3d - center                                                         <L 97>
    var_339 = wp::sub(var_338, var_22);
    // pt_a_2d = wp.vec2(wp.dot(tangent_a, projected_a), wp.dot(tangent_b, projected_a))       <L 98>
    var_340 = wp::dot(var_16, var_339);
    var_341 = wp::dot(var_17, var_339);
    var_342 = wp::vec_t<2, wp::float32>(var_340, var_341);
    // a_count, was_added_a = add_avoid_duplicates_vec2(a_buffer, a_count, pt_a_2d, EPS)       <L 99>
    add_avoid_duplicates_vec2_0(var_36, var_279, var_342, var_86, var_343, var_344);
    // if was_added_a:                                                                        <L 100>
    if (var_344) {
        // plane_tracker_a = update_incremental_plane_tracker(plane_tracker_a, pt_a_3d, a_count - 1)       <L 101>
        var_346 = wp::sub(var_343, var_345);
        var_347 = update_incremental_plane_tracker_0(var_284, var_338, var_346);
    }
    var_348 = wp::where(var_344, var_347, var_284);
    // local_dir_b = local_normal_b * cos_tilt + c_sin * local_ta_b + s_sin * local_tb_b       <L 104>
    var_349 = wp::mul(var_39, var_330);
    var_350 = wp::mul(var_331, var_41);
    var_351 = wp::add(var_349, var_350);
    var_352 = wp::mul(var_332, var_43);
    var_353 = wp::add(var_351, var_352);
    // pt_b_local = support_func(geom_b, local_dir_b, data_provider)                          <L 105>
    var_354 = support_map_0(var_geom_b, var_353, var_data_provider);
    // pt_b_3d = wp.quat_rotate(relative_orientation_b, pt_b_local) + relative_position_b       <L 106>
    var_355 = wp::quat_rotate(var_relative_orientation_b, var_354);
    var_356 = wp::add(var_355, var_relative_position_b);
    // projected_b = pt_b_3d - center                                                         <L 107>
    var_357 = wp::sub(var_356, var_22);
    // pt_b_2d = wp.vec2(wp.dot(tangent_a, projected_b), wp.dot(tangent_b, projected_b))       <L 108>
    var_358 = wp::dot(var_16, var_357);
    var_359 = wp::dot(var_17, var_357);
    var_360 = wp::vec_t<2, wp::float32>(var_358, var_359);
    // b_count, was_added_b = add_avoid_duplicates_vec2(b_buffer, b_count, pt_b_2d, EPS)       <L 109>
    add_avoid_duplicates_vec2_0(var_25, var_297, var_360, var_86, var_361, var_362);
    // if was_added_b:                                                                        <L 110>
    if (var_362) {
        // plane_tracker_b = update_incremental_plane_tracker(plane_tracker_b, pt_b_3d, b_count - 1)       <L 111>
        var_364 = wp::sub(var_361, var_363);
        var_365 = update_incremental_plane_tracker_0(var_302, var_356, var_364);
    }
    var_366 = wp::where(var_362, var_365, var_302);
    // normal_world = wp.quat_rotate(orientation_a, normal)                                   <L 114>
    var_367 = wp::quat_rotate(var_orientation_a, var_normal);
    // position_a_ws = position_a_world                                                       <L 117>
    var_368 = wp::copy(var_position_a_world);
    // position_b_ws = wp.quat_rotate(orientation_a, relative_position_b) + position_a_world       <L 118>
    var_369 = wp::quat_rotate(var_orientation_a, var_relative_position_b);
    var_370 = wp::add(var_369, var_position_a_world);
    // quaternion_a_ws = orientation_a                                                        <L 119>
    var_371 = wp::copy(var_orientation_a);
    // quaternion_b_ws = orientation_a * relative_orientation_b                               <L 120>
    var_372 = wp::mul(var_orientation_a, var_relative_orientation_b);
    // if a_count < 2 or b_count < 2:                                                         <L 122>
    var_375 = (var_343 < var_374);
    var_373 = var_375;
    if (!var_373) {
        var_377 = (var_361 < var_376);
        var_373 = var_373 || var_377;
    }
    if (var_373) {
        // count_out = 0                                                                      <L 123>
        // normal_dot = 0.0                                                                   <L 124>
    }
    if (!var_373) {
        // projector_a, projector_b = create_body_projectors(plane_tracker_a, p_a, plane_tracker_b, p_b, normal)       <L 126>
        create_body_projectors_0(var_348, var_p_a, var_366, var_p_b, var_normal, var_380, var_381);
        // if excess_normal_deviation(normal, projector_a.normal) or excess_normal_deviation(       <L 128>
        var_383 = &((var_380).normal);
        var_385 = wp::load(var_383);
        var_384 = excess_normal_deviation_0(var_normal, var_385);
        var_382 = var_384;
        if (!var_382) {
            // normal, projector_b.normal                                                     <L 129>
            var_386 = &((var_381).normal);
            var_388 = wp::load(var_386);
            var_387 = excess_normal_deviation_0(var_normal, var_388);
            var_382 = var_382 || var_387;
        }
        if (var_382) {
            // count_out = 0                                                                  <L 131>
            // normal_dot = 0.0                                                               <L 132>
        }
        if (!var_382) {
            // num_manifold_points, normal_dot = extract_4_point_contact_manifolds(           <L 134>
            // a_buffer,                                                                      <L 135>
            // a_count,                                                                       <L 136>
            // b_buffer,                                                                      <L 137>
            // b_count,                                                                       <L 138>
            // normal,                                                                        <L 139>
            // tangent_a,                                                                     <L 140>
            // tangent_b,                                                                     <L 141>
            // center,                                                                        <L 142>
            // projector_a,                                                                   <L 143>
            // projector_b,                                                                   <L 144>
            // orientation_a,                                                                 <L 145>
            // position_a_world,                                                              <L 146>
            // normal_world,                                                                  <L 147>
            // writer_data,                                                                   <L 148>
            // contact_template,                                                              <L 149>
            // geom_a,                                                                        <L 150>
            // geom_b,                                                                        <L 151>
            // position_a_ws,                                                                 <L 152>
            // position_b_ws,                                                                 <L 153>
            // quaternion_a_ws,                                                               <L 154>
            // quaternion_b_ws,                                                               <L 155>
            create_build_manifold__locals__extract_4_point_contact_manifolds_8(var_36, var_343, var_25, var_361, var_normal, var_16, var_17, var_22, var_380, var_381, var_orientation_a, var_position_a_world, var_367, var_writer_data, var_contact_template, var_geom_a, var_geom_b, var_368, var_370, var_371, var_372, var_391, var_392);
            // count_out = wp.min(num_manifold_points, 4)                                     <L 157>
            var_394 = wp::min(var_391, var_393);
        }
        var_395 = wp::where(var_382, var_389, var_394);
        var_396 = wp::where(var_382, var_390, var_392);
    }
    var_397 = wp::where(var_373, var_378, var_395);
    var_398 = wp::where(var_373, var_379, var_396);
    // if should_include_deepest_contact(normal_dot) or count_out == 0:                       <L 159>
    var_400 = should_include_deepest_contact_0(var_398);
    var_399 = var_400;
    if (!var_399) {
        var_402 = (var_397 == var_401);
        var_399 = var_399 || var_402;
    }
    if (var_399) {
        // deepest_center_local = 0.5 * (p_a + p_b)                                           <L 160>
        var_404 = wp::add(var_p_a, var_p_b);
        var_405 = wp::mul(var_403, var_404);
        // deepest_signed_distance = wp.dot(p_b - p_a, normal)                                <L 161>
        var_406 = wp::sub(var_p_b, var_p_a);
        var_407 = wp::dot(var_406, var_normal);
        // deepest_center_world = wp.quat_rotate(orientation_a, deepest_center_local) + position_a_world       <L 163>
        var_408 = wp::quat_rotate(var_orientation_a, var_405);
        var_409 = wp::add(var_408, var_position_a_world);
        // contact_data = contact_template                                                    <L 165>
        var_410 = wp::copy(var_contact_template);
        // contact_data.contact_point_center = deepest_center_world                           <L 166>
        var_410.contact_point_center = var_409;
        // contact_data.contact_normal_a_to_b = normal_world                                  <L 167>
        var_410.contact_normal_a_to_b = var_367;
        // contact_data.contact_distance = deepest_signed_distance                            <L 168>
        var_410.contact_distance = var_407;
        // contact_data.sort_sub_key = (contact_template.sort_sub_key << 3) | count_out       <L 169>
        var_411 = &((var_contact_template).sort_sub_key);
        var_414 = wp::load(var_411);
        var_413 = wp::lshift(var_414, var_412);
        var_415 = wp::bit_or(var_413, var_397);
        var_410.sort_sub_key = var_415;
        // contact_data = post_process_contact(                                               <L 171>
        // contact_data, geom_a, position_a_ws, quaternion_a_ws, geom_b, position_b_ws, quaternion_b_ws       <L 172>
        var_416 = post_process_axial_on_discrete_contact_0(var_410, var_geom_a, var_368, var_371, var_geom_b, var_370, var_372);
        // writer_func(contact_data, writer_data, -1)                                         <L 174>
        write_contact_to_reducer_0(var_416, var_writer_data, var_417);
        // count_out += 1                                                                     <L 176>
        var_419 = wp::add(var_397, var_418);
    }
    var_420 = wp::where(var_399, var_419, var_397);
    // return count_out                                                                       <L 178>
    return var_420;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/collision_convex.py:0
static CUDA_CALLABLE wp::int32 create_solve_convex_multi_contact__locals__solve_convex_multi_contact_6(
    GenericShapeData_ceaba563 var_geom_a,
    GenericShapeData_ceaba563 var_geom_b,
    wp::quat_t<wp::float32> var_orientation_a,
    wp::quat_t<wp::float32> var_orientation_b,
    wp::vec_t<3, wp::float32> var_position_a,
    wp::vec_t<3, wp::float32> var_position_b,
    SupportMapDataProvider_e77f8b9f var_data_provider,
    wp::float32 var_contact_threshold,
    bool var_skip_multi_contact,
    GlobalContactReducerData_98513266 var_writer_data,
    ContactData_40360d7c var_contact_template)
{
    //---------
    // primal vars
    wp::quat_t<wp::float32> var_0;
    wp::quat_t<wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    wp::float32* var_4;
    wp::float32* var_5;
    wp::float32 var_6;
    wp::float32 var_7;
    wp::float32 var_8;
    const wp::float32 var_9 = 0.0001;
    const wp::float32 var_10 = 0.0;
    bool var_11;
    wp::float32 var_12;
    bool var_13;
    const wp::float32 var_14 = 2.0;
    wp::float32 var_15;
    const wp::float32 var_16 = 0.0;
    wp::float32 var_17;
    wp::float32 var_18;
    bool var_19;
    wp::vec_t<3, wp::float32> var_20;
    wp::vec_t<3, wp::float32> var_21;
    wp::vec_t<3, wp::float32> var_22;
    wp::float32 var_23;
    const wp::int32 var_24 = 30;
    const wp::float32 var_25 = 1e-05;
    wp::float32 var_26;
    wp::float32 var_27;
    const wp::float32 var_28 = 0.5;
    wp::float32 var_29;
    wp::vec_t<3, wp::float32> var_30;
    wp::vec_t<3, wp::float32> var_31;
    wp::vec_t<3, wp::float32> var_32;
    wp::vec_t<3, wp::float32> var_33;
    const wp::float32 var_34 = 0.0;
    bool var_35;
    wp::vec_t<3, wp::float32> var_36;
    wp::vec_t<3, wp::float32> var_37;
    wp::vec_t<3, wp::float32> var_38;
    wp::float32 var_39;
    const wp::int32 var_40 = 30;
    const wp::float32 var_41 = 0.0001;
    wp::vec_t<3, wp::float32> var_42;
    wp::vec_t<3, wp::float32> var_43;
    wp::vec_t<3, wp::float32> var_44;
    wp::float32 var_45;
    bool var_46;
    bool var_47;
    const wp::float32 var_48 = 0.5;
    wp::vec_t<3, wp::float32> var_49;
    wp::vec_t<3, wp::float32> var_50;
    wp::vec_t<3, wp::float32> var_51;
    wp::vec_t<3, wp::float32> var_52;
    wp::vec_t<3, wp::float32> var_53;
    ContactData_40360d7c var_54;
    wp::int32* var_55;
    const wp::int32 var_56 = 3;
    wp::int32 var_57;
    wp::int32 var_58;
    ContactData_40360d7c var_59;
    const wp::int32 var_60 = -1;
    const wp::int32 var_61 = 1;
    wp::int32 var_62;
    //---------
    // forward
    // def solve_convex_multi_contact(                                                        <L 1>
    // relative_orientation_b = wp.quat_inverse(orientation_a) * orientation_b                <L 15>
    var_0 = wp::quat_inverse(var_orientation_a);
    var_1 = wp::mul(var_0, var_orientation_b);
    // relative_position_b = wp.quat_rotate_inv(orientation_a, position_b - position_a)       <L 16>
    var_2 = wp::sub(var_position_b, var_position_a);
    var_3 = wp::quat_rotate_inv(var_orientation_a, var_2);
    // margin_sum = contact_template.margin_a + contact_template.margin_b                     <L 24>
    var_4 = &((var_contact_template).margin_a);
    var_5 = &((var_contact_template).margin_b);
    var_7 = wp::load(var_4);
    var_8 = wp::load(var_5);
    var_6 = wp::add(var_7, var_8);
    // eps = 1.0e-4                                                                           <L 25>
    // if margin_sum <= 0.0:                                                                  <L 26>
    var_11 = (var_6 <= var_10);
    if (var_11) {
        // enlarge = eps                                                                      <L 27>
        var_12 = wp::copy(var_9);
    }
    if (!var_11) {
        // elif margin_sum < eps:                                                             <L 28>
        var_13 = (var_6 < var_9);
        if (var_13) {
            // enlarge = 2.0 * eps                                                            <L 29>
            var_15 = wp::mul(var_14, var_9);
        }
        if (!var_13) {
            // enlarge = 0.0                                                                  <L 31>
        }
        var_17 = wp::where(var_13, var_15, var_16);
    }
    var_18 = wp::where(var_11, var_12, var_17);
    // collision, point_a, point_b, normal, penetration = wp.static(solve_mpr.core)(          <L 35>
    // geom_a,                                                                                <L 36>
    // geom_b,                                                                                <L 37>
    // relative_orientation_b,                                                                <L 38>
    // relative_position_b,                                                                   <L 39>
    // enlarge,                                                                               <L 40>
    // data_provider,                                                                         <L 41>
    create_solve_mpr__locals__solve_mpr_core_12(var_geom_a, var_geom_b, var_1, var_3, var_18, var_data_provider, var_24, var_25, var_19, var_20, var_21, var_22, var_23);
    // if collision:                                                                          <L 44>
    if (var_19) {
        // signed_distance = -penetration + enlarge                                           <L 45>
        var_26 = wp::neg(var_23);
        var_27 = wp::add(var_26, var_18);
        // half_enlarge = enlarge * 0.5                                                       <L 49>
        var_29 = wp::mul(var_18, var_28);
        // point_a = point_a - normal * half_enlarge                                          <L 50>
        var_30 = wp::mul(var_22, var_29);
        var_31 = wp::sub(var_20, var_30);
        // point_b = point_b + normal * half_enlarge                                          <L 51>
        var_32 = wp::mul(var_22, var_29);
        var_33 = wp::add(var_21, var_32);
    }
    if (!var_19) {
        // _separated, point_a, point_b, normal, signed_distance = wp.static(solve_gjk.core)(       <L 54>
        // geom_a,                                                                            <L 55>
        // geom_b,                                                                            <L 56>
        // relative_orientation_b,                                                            <L 57>
        // relative_position_b,                                                               <L 58>
        // 0.0,                                                                               <L 59>
        // data_provider,                                                                     <L 60>
        create_solve_closest_distance__locals__solve_closest_distance_core_12(var_geom_a, var_geom_b, var_1, var_3, var_34, var_data_provider, var_40, var_41, var_35, var_36, var_37, var_38, var_39);
    }
    var_42 = wp::where(var_19, var_31, var_36);
    var_43 = wp::where(var_19, var_33, var_37);
    var_44 = wp::where(var_19, var_22, var_38);
    var_45 = wp::where(var_19, var_27, var_39);
    // if skip_multi_contact or signed_distance > contact_threshold:                          <L 63>
    var_46 = var_skip_multi_contact;
    if (!var_46) {
        var_47 = (var_45 > var_contact_threshold);
        var_46 = var_46 || var_47;
    }
    if (var_46) {
        // point = 0.5 * (point_a + point_b)                                                  <L 65>
        var_49 = wp::add(var_42, var_43);
        var_50 = wp::mul(var_48, var_49);
        // point = wp.quat_rotate(orientation_a, point) + position_a                          <L 66>
        var_51 = wp::quat_rotate(var_orientation_a, var_50);
        var_52 = wp::add(var_51, var_position_a);
        // normal_ws = wp.quat_rotate(orientation_a, normal)                                  <L 67>
        var_53 = wp::quat_rotate(var_orientation_a, var_44);
        // contact_data = contact_template                                                    <L 69>
        var_54 = wp::copy(var_contact_template);
        // contact_data.contact_point_center = point                                          <L 70>
        var_54.contact_point_center = var_52;
        // contact_data.contact_normal_a_to_b = normal_ws                                     <L 71>
        var_54.contact_normal_a_to_b = var_53;
        // contact_data.contact_distance = signed_distance                                    <L 72>
        var_54.contact_distance = var_45;
        // contact_data.sort_sub_key = contact_template.sort_sub_key << 3                     <L 73>
        var_55 = &((var_contact_template).sort_sub_key);
        var_58 = wp::load(var_55);
        var_57 = wp::lshift(var_58, var_56);
        var_54.sort_sub_key = var_57;
        // contact_data = post_process_contact(                                               <L 74>
        // contact_data, geom_a, position_a, orientation_a, geom_b, position_b, orientation_b       <L 75>
        var_59 = post_process_axial_on_discrete_contact_0(var_54, var_geom_a, var_position_a, var_orientation_a, var_geom_b, var_position_b, var_orientation_b);
        // writer_func(contact_data, writer_data, -1)                                         <L 77>
        write_contact_to_reducer_0(var_59, var_writer_data, var_60);
        // return 1                                                                           <L 78>
        return var_61;
    }
    // count = wp.static(                                                                     <L 82>
    // geom_a,                                                                                <L 85>
    // geom_b,                                                                                <L 86>
    // orientation_a,                                                                         <L 87>
    // position_a,                                                                            <L 88>
    // relative_orientation_b,                                                                <L 89>
    // relative_position_b,                                                                   <L 90>
    // point_a,                                                                               <L 91>
    // point_b,                                                                               <L 92>
    // normal,                                                                                <L 93>
    // data_provider,                                                                         <L 94>
    // writer_data,                                                                           <L 95>
    // contact_template,                                                                      <L 96>
    var_62 = create_build_manifold__locals__build_manifold_8(var_geom_a, var_geom_b, var_orientation_a, var_position_a, var_1, var_3, var_42, var_43, var_44, var_data_provider, var_writer_data, var_contact_template);
    // return count                                                                           <L 99>
    return var_62;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/collision_core.py:0
static CUDA_CALLABLE void create_compute_gjk_mpr_contacts__locals__compute_gjk_mpr_contacts_0(
    GenericShapeData_ceaba563 var_shape_a_data,
    GenericShapeData_ceaba563 var_shape_b_data,
    wp::quat_t<wp::float32> var_rot_a,
    wp::quat_t<wp::float32> var_rot_b,
    wp::vec_t<3, wp::float32> var_pos_a_adjusted,
    wp::vec_t<3, wp::float32> var_pos_b_adjusted,
    wp::float32 var_rigid_gap,
    wp::int32 var_shape_a,
    wp::int32 var_shape_b,
    wp::float32 var_margin_a,
    wp::float32 var_margin_b,
    GlobalContactReducerData_98513266 var_writer_data,
    wp::int32 var_sort_sub_key)
{
    //---------
    // primal vars
    SupportMapDataProvider_e77f8b9f var_0;
    const wp::float32 var_1 = 0.0;
    wp::float32 var_2;
    const wp::float32 var_3 = 0.0;
    wp::float32 var_4;
    const wp::float32 var_5 = 0.0001;
    wp::int32* var_6;
    wp::int32 var_7;
    wp::int32 var_8;
    wp::int32* var_9;
    wp::int32 var_10;
    wp::int32 var_11;
    bool var_12;
    const wp::int32 var_13 = 3;
    bool var_14;
    const wp::int32 var_15 = 4;
    bool var_16;
    wp::vec_t<3, wp::float32>* var_17;
    const wp::int32 var_18 = 0;
    wp::float32 var_19;
    wp::vec_t<3, wp::float32> var_20;
    wp::vec_t<3, wp::float32>* var_21;
    const wp::int32 var_22 = 0;
    wp::float32* var_23;
    wp::float32 var_24;
    bool var_25;
    const wp::int32 var_26 = 3;
    bool var_27;
    const wp::int32 var_28 = 4;
    bool var_29;
    wp::vec_t<3, wp::float32>* var_30;
    const wp::int32 var_31 = 0;
    wp::float32 var_32;
    wp::vec_t<3, wp::float32> var_33;
    wp::vec_t<3, wp::float32>* var_34;
    const wp::int32 var_35 = 0;
    wp::float32* var_36;
    wp::float32 var_37;
    ContactData_40360d7c var_38;
    const bool var_39 = true;
    wp::float32 var_40;
    wp::float32 var_41;
    wp::float32 var_42;
    wp::float32 var_43;
    bool var_44;
    const wp::int32 var_45 = 3;
    bool var_46;
    const wp::int32 var_47 = 3;
    bool var_48;
    const wp::int32 var_49 = 5;
    bool var_50;
    const wp::int32 var_51 = 5;
    bool var_52;
    wp::int32 var_53;
    //---------
    // forward
    // def compute_gjk_mpr_contacts(                                                          <L 1>
    // data_provider = SupportMapDataProvider()                                               <L 34>
    var_0 = SupportMapDataProvider_e77f8b9f();
    // radius_eff_a = float(0.0)                                                              <L 36>
    var_2 = wp::float(var_1);
    // radius_eff_b = float(0.0)                                                              <L 37>
    var_4 = wp::float(var_3);
    // small_radius = 0.0001                                                                  <L 39>
    // type_a = shape_a_data.shape_type                                                       <L 42>
    var_6 = &((var_shape_a_data).shape_type);
    var_8 = wp::load(var_6);
    var_7 = wp::copy(var_8);
    // type_b = shape_b_data.shape_type                                                       <L 43>
    var_9 = &((var_shape_b_data).shape_type);
    var_11 = wp::load(var_9);
    var_10 = wp::copy(var_11);
    // if type_a == GeoType.SPHERE or type_a == GeoType.CAPSULE:                              <L 46>
    var_14 = (var_7 == var_13);
    var_12 = var_14;
    if (!var_12) {
        var_16 = (var_7 == var_15);
        var_12 = var_12 || var_16;
    }
    if (var_12) {
        // radius_eff_a = shape_a_data.scale[0]                                               <L 47>
        var_17 = &((var_shape_a_data).scale);
        var_20 = wp::load(var_17);
        var_19 = wp::extract(var_20, var_18);
        // shape_a_data.scale[0] = small_radius                                               <L 48>
        var_21 = &((var_shape_a_data).scale);
        var_23 = wp::indexref(var_21, var_22);
        wp::store(var_23, var_5);
    }
    var_24 = wp::where(var_12, var_19, var_2);
    // if type_b == GeoType.SPHERE or type_b == GeoType.CAPSULE:                              <L 50>
    var_27 = (var_10 == var_26);
    var_25 = var_27;
    if (!var_25) {
        var_29 = (var_10 == var_28);
        var_25 = var_25 || var_29;
    }
    if (var_25) {
        // radius_eff_b = shape_b_data.scale[0]                                               <L 51>
        var_30 = &((var_shape_b_data).scale);
        var_33 = wp::load(var_30);
        var_32 = wp::extract(var_33, var_31);
        // shape_b_data.scale[0] = small_radius                                               <L 52>
        var_34 = &((var_shape_b_data).scale);
        var_36 = wp::indexref(var_34, var_35);
        wp::store(var_36, var_5);
    }
    var_37 = wp::where(var_25, var_32, var_4);
    // contact_template = ContactData()                                                       <L 55>
    var_38 = ContactData_40360d7c();
    // contact_template.radius_eff_a = radius_eff_a                                           <L 56>
    var_38.radius_eff_a = var_24;
    // contact_template.radius_eff_b = radius_eff_b                                           <L 57>
    var_38.radius_eff_b = var_37;
    // contact_template.margin_a = margin_a                                                   <L 58>
    var_38.margin_a = var_margin_a;
    // contact_template.margin_b = margin_b                                                   <L 59>
    var_38.margin_b = var_margin_b;
    // contact_template.shape_a = shape_a                                                     <L 60>
    var_38.shape_a = var_shape_a;
    // contact_template.shape_b = shape_b                                                     <L 61>
    var_38.shape_b = var_shape_b;
    // contact_template.gap_sum = rigid_gap                                                   <L 62>
    var_38.gap_sum = var_rigid_gap;
    // contact_template.sort_sub_key = sort_sub_key                                           <L 63>
    var_38.sort_sub_key = var_sort_sub_key;
    // if wp.static(ENABLE_MULTI_CONTACT):                                                    <L 65>
    // wp.static(create_solve_convex_multi_contact(support_func, writer_func, post_process_contact))(       <L 66>
    // shape_a_data,                                                                          <L 67>
    // shape_b_data,                                                                          <L 68>
    // rot_a,                                                                                 <L 69>
    // rot_b,                                                                                 <L 70>
    // pos_a_adjusted,                                                                        <L 71>
    // pos_b_adjusted,                                                                        <L 72>
    // data_provider,                                                                         <L 73>
    // rigid_gap + radius_eff_a + radius_eff_b + margin_a + margin_b,                         <L 74>
    var_40 = wp::add(var_rigid_gap, var_24);
    var_41 = wp::add(var_40, var_37);
    var_42 = wp::add(var_41, var_margin_a);
    var_43 = wp::add(var_42, var_margin_b);
    // type_a == GeoType.SPHERE                                                               <L 75>
    var_46 = (var_7 == var_45);
    var_44 = var_46;
    if (!var_44) {
        // or type_b == GeoType.SPHERE                                                        <L 76>
        var_48 = (var_10 == var_47);
        var_44 = var_44 || var_48;
    }
    if (!var_44) {
        // or type_a == GeoType.ELLIPSOID                                                     <L 77>
        var_50 = (var_7 == var_49);
        var_44 = var_44 || var_50;
    }
    if (!var_44) {
        // or type_b == GeoType.ELLIPSOID,                                                    <L 78>
        var_52 = (var_10 == var_51);
        var_44 = var_44 || var_52;
    }
    // writer_data,                                                                           <L 79>
    // contact_template,                                                                      <L 80>
    var_53 = create_solve_convex_multi_contact__locals__solve_convex_multi_contact_6(var_shape_a_data, var_shape_b_data, var_rot_a, var_rot_b, var_pos_a_adjusted, var_pos_b_adjusted, var_0, var_43, var_44, var_writer_data, var_38);
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/utils/heightfield.py:280
static CUDA_CALLABLE void adj_get_triangle_shape_from_heightfield_0(
    HeightfieldData_f2b8d59a var_hfd,
    wp::array_t<wp::float32> var_elevation_data,
    wp::transform_t<wp::float32> var_X_ws,
    wp::int32 var_tri_idx,
    GenericShapeData_ceaba563 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    HeightfieldData_f2b8d59a & adj_hfd,
    wp::array_t<wp::float32> & adj_elevation_data,
    wp::transform_t<wp::float32> & adj_X_ws,
    wp::int32 & adj_tri_idx,
    GenericShapeData_ceaba563 & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/collision_core.py:1083
static CUDA_CALLABLE void adj_get_triangle_shape_from_mesh_0(
    wp::uint64 var_mesh_id,
    wp::vec_t<3, wp::float32> var_mesh_scale,
    wp::transform_t<wp::float32> var_X_mesh_ws,
    wp::int32 var_tri_idx,
    GenericShapeData_ceaba563 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::uint64 & adj_mesh_id,
    wp::vec_t<3, wp::float32> & adj_mesh_scale,
    wp::transform_t<wp::float32> & adj_X_mesh_ws,
    wp::int32 & adj_tri_idx,
    GenericShapeData_ceaba563 & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/support_function.py:60
static CUDA_CALLABLE void adj_pack_mesh_ptr_0(
    wp::uint64 var_ptr,
    wp::uint64 & adj_ptr,
    wp::vec_t<3, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/support_function.py:350
static CUDA_CALLABLE void adj_extract_shape_data_0(
    wp::int32 var_shape_idx,
    wp::array_t<wp::transform_t<wp::float32>> var_shape_transform,
    wp::array_t<wp::int32> var_shape_types,
    wp::array_t<wp::vec_t<4, wp::float32>> var_shape_data,
    wp::array_t<wp::uint64> var_shape_source,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::quat_t<wp::float32> & ret_1,
    GenericShapeData_ceaba563 & ret_2,
    wp::vec_t<3, wp::float32> & ret_3,
    wp::float32 & ret_4,
    wp::int32 & adj_shape_idx,
    wp::array_t<wp::transform_t<wp::float32>> & adj_shape_transform,
    wp::array_t<wp::int32> & adj_shape_types,
    wp::array_t<wp::vec_t<4, wp::float32>> & adj_shape_data,
    wp::array_t<wp::uint64> & adj_shape_source,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::quat_t<wp::float32> & adj_ret_1,
    GenericShapeData_ceaba563 & adj_ret_2,
    wp::vec_t<3, wp::float32> & adj_ret_3,
    wp::float32 & adj_ret_4)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/support_function.py:71
static CUDA_CALLABLE void adj_unpack_mesh_ptr_0(
    wp::vec_t<3, wp::float32> var_arr,
    wp::vec_t<3, wp::float32> & adj_arr,
    wp::uint64 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/support_function.py:396
static CUDA_CALLABLE void adj_closest_point_on_triangle_0(
    wp::vec_t<3, wp::float32> var_p,
    wp::vec_t<3, wp::float32> var_tri_a,
    wp::vec_t<3, wp::float32> var_tri_b,
    wp::vec_t<3, wp::float32> var_tri_c,
    wp::vec_t<3, wp::float32> & adj_p,
    wp::vec_t<3, wp::float32> & adj_tri_a,
    wp::vec_t<3, wp::float32> & adj_tri_b,
    wp::vec_t<3, wp::float32> & adj_tri_c,
    wp::vec_t<3, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/mpr.py:0
static CUDA_CALLABLE void adj_create_support_map_function__locals__geometric_center_24(
    GenericShapeData_ceaba563 var_geom_a,
    GenericShapeData_ceaba563 var_geom_b,
    wp::quat_t<wp::float32> var_orientation_b,
    wp::vec_t<3, wp::float32> var_position_b,
    SupportMapDataProvider_e77f8b9f var_data_provider,
    GenericShapeData_ceaba563 & adj_geom_a,
    GenericShapeData_ceaba563 & adj_geom_b,
    wp::quat_t<wp::float32> & adj_orientation_b,
    wp::vec_t<3, wp::float32> & adj_position_b,
    SupportMapDataProvider_e77f8b9f & adj_data_provider,
    Vert_99873389 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/support_function.py:106
static CUDA_CALLABLE void adj_support_map_0(
    GenericShapeData_ceaba563 var_geom,
    wp::vec_t<3, wp::float32> var_direction,
    SupportMapDataProvider_e77f8b9f var_data_provider,
    GenericShapeData_ceaba563 & adj_geom,
    wp::vec_t<3, wp::float32> & adj_direction,
    SupportMapDataProvider_e77f8b9f & adj_data_provider,
    wp::vec_t<3, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/mpr.py:0
static CUDA_CALLABLE void adj_create_solve_mpr__locals__centered_box_support_12(
    GenericShapeData_ceaba563 var_geom,
    wp::vec_t<3, wp::float32> var_direction,
    SupportMapDataProvider_e77f8b9f var_data_provider,
    GenericShapeData_ceaba563 & adj_geom,
    wp::vec_t<3, wp::float32> & adj_direction,
    SupportMapDataProvider_e77f8b9f & adj_data_provider,
    wp::vec_t<3, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/mpr.py:0
static CUDA_CALLABLE void adj_create_support_map_function__locals__support_map_b_25(
    GenericShapeData_ceaba563 var_geom_b,
    wp::vec_t<3, wp::float32> var_direction,
    wp::quat_t<wp::float32> var_orientation_b,
    wp::vec_t<3, wp::float32> var_position_b,
    SupportMapDataProvider_e77f8b9f var_data_provider,
    GenericShapeData_ceaba563 & adj_geom_b,
    wp::vec_t<3, wp::float32> & adj_direction,
    wp::quat_t<wp::float32> & adj_orientation_b,
    wp::vec_t<3, wp::float32> & adj_position_b,
    SupportMapDataProvider_e77f8b9f & adj_data_provider,
    wp::vec_t<3, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/mpr.py:0
static CUDA_CALLABLE void adj_create_support_map_function__locals__minkowski_support_25(
    GenericShapeData_ceaba563 var_geom_a,
    GenericShapeData_ceaba563 var_geom_b,
    wp::vec_t<3, wp::float32> var_direction,
    wp::quat_t<wp::float32> var_orientation_b,
    wp::vec_t<3, wp::float32> var_position_b,
    wp::float32 var_extend,
    SupportMapDataProvider_e77f8b9f var_data_provider,
    GenericShapeData_ceaba563 & adj_geom_a,
    GenericShapeData_ceaba563 & adj_geom_b,
    wp::vec_t<3, wp::float32> & adj_direction,
    wp::quat_t<wp::float32> & adj_orientation_b,
    wp::vec_t<3, wp::float32> & adj_position_b,
    wp::float32 & adj_extend,
    SupportMapDataProvider_e77f8b9f & adj_data_provider,
    Vert_99873389 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/mpr.py:52
static CUDA_CALLABLE void adj_vert_a_0(
    Vert_99873389 var_vert,
    Vert_99873389 & adj_vert,
    wp::vec_t<3, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/mpr.py:0
static CUDA_CALLABLE void adj_create_solve_mpr__locals__solve_mpr_core_12(
    GenericShapeData_ceaba563 var_geom_a,
    GenericShapeData_ceaba563 var_geom_b,
    wp::quat_t<wp::float32> var_orientation_b,
    wp::vec_t<3, wp::float32> var_position_b,
    wp::float32 var_extend,
    SupportMapDataProvider_e77f8b9f var_data_provider,
    wp::int32 var_MAX_ITER,
    wp::float32 var_COLLIDE_EPSILON,
    bool & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & ret_2,
    wp::vec_t<3, wp::float32> & ret_3,
    wp::float32 & ret_4,
    GenericShapeData_ceaba563 & adj_geom_a,
    GenericShapeData_ceaba563 & adj_geom_b,
    wp::quat_t<wp::float32> & adj_orientation_b,
    wp::vec_t<3, wp::float32> & adj_position_b,
    wp::float32 & adj_extend,
    SupportMapDataProvider_e77f8b9f & adj_data_provider,
    wp::int32 & adj_MAX_ITER,
    wp::float32 & adj_COLLIDE_EPSILON,
    bool & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1,
    wp::vec_t<3, wp::float32> & adj_ret_2,
    wp::vec_t<3, wp::float32> & adj_ret_3,
    wp::float32 & adj_ret_4)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/simplex_solver.py:77
static CUDA_CALLABLE void adj_create_solve_closest_distance__locals__simplex_get_vertex_12(
    wp::mat_t<8, 3, wp::float32> var_v,
    wp::int32 var_i,
    wp::mat_t<8, 3, wp::float32> & adj_v,
    wp::int32 & adj_i,
    Vert_99873389 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/simplex_solver.py:293
static CUDA_CALLABLE void adj_create_solve_closest_distance__locals__simplex_get_closest_12(
    wp::mat_t<8, 3, wp::float32> var_v,
    wp::vec_t<4, wp::float32> var_barycentric,
    wp::uint32 var_usage_mask,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::mat_t<8, 3, wp::float32> & adj_v,
    wp::vec_t<4, wp::float32> & adj_barycentric,
    wp::uint32 & adj_usage_mask,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/mpr.py:0
static CUDA_CALLABLE void adj_create_support_map_function__locals__support_map_b_24(
    GenericShapeData_ceaba563 var_geom_b,
    wp::vec_t<3, wp::float32> var_direction,
    wp::quat_t<wp::float32> var_orientation_b,
    wp::vec_t<3, wp::float32> var_position_b,
    SupportMapDataProvider_e77f8b9f var_data_provider,
    GenericShapeData_ceaba563 & adj_geom_b,
    wp::vec_t<3, wp::float32> & adj_direction,
    wp::quat_t<wp::float32> & adj_orientation_b,
    wp::vec_t<3, wp::float32> & adj_position_b,
    SupportMapDataProvider_e77f8b9f & adj_data_provider,
    wp::vec_t<3, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/mpr.py:0
static CUDA_CALLABLE void adj_create_support_map_function__locals__minkowski_support_24(
    GenericShapeData_ceaba563 var_geom_a,
    GenericShapeData_ceaba563 var_geom_b,
    wp::vec_t<3, wp::float32> var_direction,
    wp::quat_t<wp::float32> var_orientation_b,
    wp::vec_t<3, wp::float32> var_position_b,
    wp::float32 var_extend,
    SupportMapDataProvider_e77f8b9f var_data_provider,
    GenericShapeData_ceaba563 & adj_geom_a,
    GenericShapeData_ceaba563 & adj_geom_b,
    wp::vec_t<3, wp::float32> & adj_direction,
    wp::quat_t<wp::float32> & adj_orientation_b,
    wp::vec_t<3, wp::float32> & adj_position_b,
    wp::float32 & adj_extend,
    SupportMapDataProvider_e77f8b9f & adj_data_provider,
    Vert_99873389 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/simplex_solver.py:91
static CUDA_CALLABLE void adj_create_solve_closest_distance__locals__closest_segment_12(
    wp::mat_t<8, 3, wp::float32> var_v,
    wp::int32 var_i0,
    wp::int32 var_i1,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<4, wp::float32> & ret_1,
    wp::uint32 & ret_2,
    wp::mat_t<8, 3, wp::float32> & adj_v,
    wp::int32 & adj_i0,
    wp::int32 & adj_i1,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::vec_t<4, wp::float32> & adj_ret_1,
    wp::uint32 & adj_ret_2)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/simplex_solver.py:134
static CUDA_CALLABLE void adj_create_solve_closest_distance__locals__closest_triangle_12(
    wp::mat_t<8, 3, wp::float32> var_v,
    wp::int32 var_i0,
    wp::int32 var_i1,
    wp::int32 var_i2,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<4, wp::float32> & ret_1,
    wp::uint32 & ret_2,
    wp::mat_t<8, 3, wp::float32> & adj_v,
    wp::int32 & adj_i0,
    wp::int32 & adj_i1,
    wp::int32 & adj_i2,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::vec_t<4, wp::float32> & adj_ret_1,
    wp::uint32 & adj_ret_2)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/simplex_solver.py:210
static CUDA_CALLABLE void adj_create_solve_closest_distance__locals__determinant_12(
    wp::vec_t<3, wp::float32> var_a,
    wp::vec_t<3, wp::float32> var_b,
    wp::vec_t<3, wp::float32> var_c,
    wp::vec_t<3, wp::float32> var_d,
    wp::vec_t<3, wp::float32> & adj_a,
    wp::vec_t<3, wp::float32> & adj_b,
    wp::vec_t<3, wp::float32> & adj_c,
    wp::vec_t<3, wp::float32> & adj_d,
    wp::float32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/simplex_solver.py:215
static CUDA_CALLABLE void adj_create_solve_closest_distance__locals__closest_tetrahedron_12(
    wp::mat_t<8, 3, wp::float32> var_v,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<4, wp::float32> & ret_1,
    wp::uint32 & ret_2,
    wp::mat_t<8, 3, wp::float32> & adj_v,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::vec_t<4, wp::float32> & adj_ret_1,
    wp::uint32 & adj_ret_2)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/simplex_solver.py:0
static CUDA_CALLABLE void adj_create_solve_closest_distance__locals__solve_closest_distance_core_12(
    GenericShapeData_ceaba563 var_geom_a,
    GenericShapeData_ceaba563 var_geom_b,
    wp::quat_t<wp::float32> var_orientation_b,
    wp::vec_t<3, wp::float32> var_position_b,
    wp::float32 var_extend,
    SupportMapDataProvider_e77f8b9f var_data_provider,
    wp::int32 var_MAX_ITER,
    wp::float32 var_COLLIDE_EPSILON,
    bool & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & ret_2,
    wp::vec_t<3, wp::float32> & ret_3,
    wp::float32 & ret_4,
    GenericShapeData_ceaba563 & adj_geom_a,
    GenericShapeData_ceaba563 & adj_geom_b,
    wp::quat_t<wp::float32> & adj_orientation_b,
    wp::vec_t<3, wp::float32> & adj_position_b,
    wp::float32 & adj_extend,
    SupportMapDataProvider_e77f8b9f & adj_data_provider,
    wp::int32 & adj_MAX_ITER,
    wp::float32 & adj_COLLIDE_EPSILON,
    bool & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1,
    wp::vec_t<3, wp::float32> & adj_ret_2,
    wp::vec_t<3, wp::float32> & adj_ret_3,
    wp::float32 & adj_ret_4)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/collision_core.py:38
static CUDA_CALLABLE void adj_is_discrete_shape_0(
    wp::int32 var_shape_type,
    wp::int32 & adj_shape_type,
    bool & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/collision_core.py:50
static CUDA_CALLABLE void adj_project_point_onto_plane_0(
    wp::vec_t<3, wp::float32> var_point,
    wp::vec_t<3, wp::float32> var_plane_point,
    wp::vec_t<3, wp::float32> var_plane_normal,
    wp::vec_t<3, wp::float32> & adj_point,
    wp::vec_t<3, wp::float32> & adj_plane_point,
    wp::vec_t<3, wp::float32> & adj_plane_normal,
    wp::vec_t<3, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/collision_core.py:172
static CUDA_CALLABLE void adj_post_process_axial_on_discrete_contact_0(
    ContactData_40360d7c var_contact_data,
    GenericShapeData_ceaba563 var_shape_a,
    wp::vec_t<3, wp::float32> var_pos_a_adjusted,
    wp::quat_t<wp::float32> var_rot_a,
    GenericShapeData_ceaba563 var_shape_b,
    wp::vec_t<3, wp::float32> var_pos_b_adjusted,
    wp::quat_t<wp::float32> var_rot_b,
    ContactData_40360d7c & adj_contact_data,
    GenericShapeData_ceaba563 & adj_shape_a,
    wp::vec_t<3, wp::float32> & adj_pos_a_adjusted,
    wp::quat_t<wp::float32> & adj_rot_a,
    GenericShapeData_ceaba563 & adj_shape_b,
    wp::vec_t<3, wp::float32> & adj_pos_b_adjusted,
    wp::quat_t<wp::float32> & adj_rot_b,
    ContactData_40360d7c & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:532
static CUDA_CALLABLE void adj_encode_oct_0(
    wp::vec_t<3, wp::float32> var_n,
    wp::vec_t<3, wp::float32> & adj_n,
    wp::vec_t<2, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:1007
static CUDA_CALLABLE void adj_export_contact_to_buffer_0(
    wp::int32 var_shape_a,
    wp::int32 var_shape_b,
    wp::vec_t<3, wp::float32> var_position,
    wp::vec_t<3, wp::float32> var_normal,
    wp::float32 var_depth,
    wp::int32 var_fingerprint,
    GlobalContactReducerData_98513266 var_reducer_data,
    wp::int32 & adj_shape_a,
    wp::int32 & adj_shape_b,
    wp::vec_t<3, wp::float32> & adj_position,
    wp::vec_t<3, wp::float32> & adj_normal,
    wp::float32 & adj_depth,
    wp::int32 & adj_fingerprint,
    GlobalContactReducerData_98513266 & adj_reducer_data,
    wp::int32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:0
static CUDA_CALLABLE void adj_write_contact_to_reducer_0(
    ContactData_40360d7c var_contact_data,
    GlobalContactReducerData_98513266 var_reducer_data,
    wp::int32 var_output_index,
    ContactData_40360d7c & adj_contact_data,
    GlobalContactReducerData_98513266 & adj_reducer_data,
    wp::int32 & adj_output_index)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/math/__init__.py:235
static CUDA_CALLABLE void adj_orthonormal_basis_0(
    wp::vec_t<3, wp::float32> var_n,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & adj_n,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    const wp::int32 var_2 = 2;
    wp::float32 var_3;
    const wp::float32 var_4 = 0.0;
    bool var_5;
    const wp::float32 var_6 = 1.0;
    const wp::float32 var_7 = 1.0;
    const wp::int32 var_8 = 2;
    wp::float32 var_9;
    wp::float32 var_10;
    wp::float32 var_11;
    const wp::int32 var_12 = 0;
    wp::float32 var_13;
    const wp::int32 var_14 = 1;
    wp::float32 var_15;
    wp::float32 var_16;
    wp::float32 var_17;
    const wp::float32 var_18 = 1.0;
    const wp::int32 var_19 = 0;
    wp::float32 var_20;
    const wp::int32 var_21 = 0;
    wp::float32 var_22;
    wp::float32 var_23;
    wp::float32 var_24;
    wp::float32 var_25;
    const wp::int32 var_26 = 0;
    wp::float32 var_27;
    const wp::int32 var_28 = 1;
    const wp::int32 var_29 = 0;
    wp::float32 var_30;
    const wp::int32 var_31 = 2;
    const wp::int32 var_32 = 0;
    const wp::int32 var_33 = 1;
    wp::float32 var_34;
    const wp::int32 var_35 = 1;
    wp::float32 var_36;
    wp::float32 var_37;
    wp::float32 var_38;
    const wp::float32 var_39 = 1.0;
    wp::float32 var_40;
    const wp::int32 var_41 = 1;
    const wp::int32 var_42 = 1;
    wp::float32 var_43;
    wp::float32 var_44;
    const wp::int32 var_45 = 2;
    const wp::float32 var_46 = 1.0;
    const wp::float32 var_47 = 1.0;
    const wp::int32 var_48 = 2;
    wp::float32 var_49;
    wp::float32 var_50;
    wp::float32 var_51;
    const wp::int32 var_52 = 0;
    wp::float32 var_53;
    wp::float32 var_54;
    const wp::int32 var_55 = 1;
    wp::float32 var_56;
    wp::float32 var_57;
    wp::float32 var_58;
    const wp::float32 var_59 = 1.0;
    const wp::int32 var_60 = 0;
    wp::float32 var_61;
    const wp::int32 var_62 = 0;
    wp::float32 var_63;
    wp::float32 var_64;
    wp::float32 var_65;
    wp::float32 var_66;
    const wp::int32 var_67 = 0;
    const wp::int32 var_68 = 1;
    const wp::int32 var_69 = 0;
    wp::float32 var_70;
    wp::float32 var_71;
    const wp::int32 var_72 = 2;
    const wp::int32 var_73 = 0;
    const wp::float32 var_74 = 1.0;
    const wp::int32 var_75 = 1;
    wp::float32 var_76;
    const wp::int32 var_77 = 1;
    wp::float32 var_78;
    wp::float32 var_79;
    wp::float32 var_80;
    wp::float32 var_81;
    const wp::int32 var_82 = 1;
    const wp::int32 var_83 = 1;
    wp::float32 var_84;
    wp::float32 var_85;
    const wp::int32 var_86 = 2;
    wp::float32 var_87;
    wp::float32 var_88;
    //---------
    // dual vars
    wp::vec_t<3, wp::float32> adj_0 = {};
    wp::vec_t<3, wp::float32> adj_1 = {};
    wp::int32 adj_2 = {};
    wp::float32 adj_3 = {};
    wp::float32 adj_4 = {};
    bool adj_5 = {};
    wp::float32 adj_6 = {};
    wp::float32 adj_7 = {};
    wp::int32 adj_8 = {};
    wp::float32 adj_9 = {};
    wp::float32 adj_10 = {};
    wp::float32 adj_11 = {};
    wp::int32 adj_12 = {};
    wp::float32 adj_13 = {};
    wp::int32 adj_14 = {};
    wp::float32 adj_15 = {};
    wp::float32 adj_16 = {};
    wp::float32 adj_17 = {};
    wp::float32 adj_18 = {};
    wp::int32 adj_19 = {};
    wp::float32 adj_20 = {};
    wp::int32 adj_21 = {};
    wp::float32 adj_22 = {};
    wp::float32 adj_23 = {};
    wp::float32 adj_24 = {};
    wp::float32 adj_25 = {};
    wp::int32 adj_26 = {};
    wp::float32 adj_27 = {};
    wp::int32 adj_28 = {};
    wp::int32 adj_29 = {};
    wp::float32 adj_30 = {};
    wp::int32 adj_31 = {};
    wp::int32 adj_32 = {};
    wp::int32 adj_33 = {};
    wp::float32 adj_34 = {};
    wp::int32 adj_35 = {};
    wp::float32 adj_36 = {};
    wp::float32 adj_37 = {};
    wp::float32 adj_38 = {};
    wp::float32 adj_39 = {};
    wp::float32 adj_40 = {};
    wp::int32 adj_41 = {};
    wp::int32 adj_42 = {};
    wp::float32 adj_43 = {};
    wp::float32 adj_44 = {};
    wp::int32 adj_45 = {};
    wp::float32 adj_46 = {};
    wp::float32 adj_47 = {};
    wp::int32 adj_48 = {};
    wp::float32 adj_49 = {};
    wp::float32 adj_50 = {};
    wp::float32 adj_51 = {};
    wp::int32 adj_52 = {};
    wp::float32 adj_53 = {};
    wp::float32 adj_54 = {};
    wp::int32 adj_55 = {};
    wp::float32 adj_56 = {};
    wp::float32 adj_57 = {};
    wp::float32 adj_58 = {};
    wp::float32 adj_59 = {};
    wp::int32 adj_60 = {};
    wp::float32 adj_61 = {};
    wp::int32 adj_62 = {};
    wp::float32 adj_63 = {};
    wp::float32 adj_64 = {};
    wp::float32 adj_65 = {};
    wp::float32 adj_66 = {};
    wp::int32 adj_67 = {};
    wp::int32 adj_68 = {};
    wp::int32 adj_69 = {};
    wp::float32 adj_70 = {};
    wp::float32 adj_71 = {};
    wp::int32 adj_72 = {};
    wp::int32 adj_73 = {};
    wp::float32 adj_74 = {};
    wp::int32 adj_75 = {};
    wp::float32 adj_76 = {};
    wp::int32 adj_77 = {};
    wp::float32 adj_78 = {};
    wp::float32 adj_79 = {};
    wp::float32 adj_80 = {};
    wp::float32 adj_81 = {};
    wp::int32 adj_82 = {};
    wp::int32 adj_83 = {};
    wp::float32 adj_84 = {};
    wp::float32 adj_85 = {};
    wp::int32 adj_86 = {};
    wp::float32 adj_87 = {};
    wp::float32 adj_88 = {};
    //---------
    // forward
    // def orthonormal_basis(n: wp.vec3):                                                     <L 236>
    // b1 = wp.vec3()                                                                         <L 252>
    var_0 = wp::vec_t<3, wp::float32>();
    // b2 = wp.vec3()                                                                         <L 253>
    var_1 = wp::vec_t<3, wp::float32>();
    // if n[2] < 0.0:                                                                         <L 254>
    var_3 = wp::extract(var_n, var_2);
    var_5 = (var_3 < var_4);
    if (var_5) {
        // a = 1.0 / (1.0 - n[2])                                                             <L 255>
        var_9 = wp::extract(var_n, var_8);
        var_10 = wp::sub(var_7, var_9);
        var_11 = wp::div(var_6, var_10);
        // b = n[0] * n[1] * a                                                                <L 256>
        var_13 = wp::extract(var_n, var_12);
        var_15 = wp::extract(var_n, var_14);
        var_16 = wp::mul(var_13, var_15);
        var_17 = wp::mul(var_16, var_11);
        // b1[0] = 1.0 - n[0] * n[0] * a                                                      <L 257>
        var_20 = wp::extract(var_n, var_19);
        var_22 = wp::extract(var_n, var_21);
        var_23 = wp::mul(var_20, var_22);
        var_24 = wp::mul(var_23, var_11);
        var_25 = wp::sub(var_18, var_24);
        wp::assign_inplace(var_0, var_26, var_25);
        // b1[1] = -b                                                                         <L 258>
        var_27 = wp::neg(var_17);
        wp::assign_inplace(var_0, var_28, var_27);
        // b1[2] = n[0]                                                                       <L 259>
        var_30 = wp::extract(var_n, var_29);
        wp::assign_inplace(var_0, var_31, var_30);
        // b2[0] = b                                                                          <L 261>
        wp::assign_inplace(var_1, var_32, var_17);
        // b2[1] = n[1] * n[1] * a - 1.0                                                      <L 262>
        var_34 = wp::extract(var_n, var_33);
        var_36 = wp::extract(var_n, var_35);
        var_37 = wp::mul(var_34, var_36);
        var_38 = wp::mul(var_37, var_11);
        var_40 = wp::sub(var_38, var_39);
        wp::assign_inplace(var_1, var_41, var_40);
        // b2[2] = -n[1]                                                                      <L 263>
        var_43 = wp::extract(var_n, var_42);
        var_44 = wp::neg(var_43);
        wp::assign_inplace(var_1, var_45, var_44);
    }
    if (!var_5) {
        // a = 1.0 / (1.0 + n[2])                                                             <L 265>
        var_49 = wp::extract(var_n, var_48);
        var_50 = wp::add(var_47, var_49);
        var_51 = wp::div(var_46, var_50);
        // b = -n[0] * n[1] * a                                                               <L 266>
        var_53 = wp::extract(var_n, var_52);
        var_54 = wp::neg(var_53);
        var_56 = wp::extract(var_n, var_55);
        var_57 = wp::mul(var_54, var_56);
        var_58 = wp::mul(var_57, var_51);
        // b1[0] = 1.0 - n[0] * n[0] * a                                                      <L 267>
        var_61 = wp::extract(var_n, var_60);
        var_63 = wp::extract(var_n, var_62);
        var_64 = wp::mul(var_61, var_63);
        var_65 = wp::mul(var_64, var_51);
        var_66 = wp::sub(var_59, var_65);
        wp::assign_inplace(var_0, var_67, var_66);
        // b1[1] = b                                                                          <L 268>
        wp::assign_inplace(var_0, var_68, var_58);
        // b1[2] = -n[0]                                                                      <L 269>
        var_70 = wp::extract(var_n, var_69);
        var_71 = wp::neg(var_70);
        wp::assign_inplace(var_0, var_72, var_71);
        // b2[0] = b                                                                          <L 271>
        wp::assign_inplace(var_1, var_73, var_58);
        // b2[1] = 1.0 - n[1] * n[1] * a                                                      <L 272>
        var_76 = wp::extract(var_n, var_75);
        var_78 = wp::extract(var_n, var_77);
        var_79 = wp::mul(var_76, var_78);
        var_80 = wp::mul(var_79, var_51);
        var_81 = wp::sub(var_74, var_80);
        wp::assign_inplace(var_1, var_82, var_81);
        // b2[2] = -n[1]                                                                      <L 273>
        var_84 = wp::extract(var_n, var_83);
        var_85 = wp::neg(var_84);
        wp::assign_inplace(var_1, var_86, var_85);
    }
    var_87 = wp::where(var_5, var_11, var_51);
    var_88 = wp::where(var_5, var_17, var_58);
    // return b1, b2                                                                          <L 275>
    ret_0 = var_0;
    ret_1 = var_1;
    goto label0;
    //---------
    // reverse
    label0:;
    adj_1 += adj_ret_1;
    adj_0 += adj_ret_0;
    // adj: return b1, b2                                                                     <L 275>
    wp::adj_where(var_5, var_17, var_58, adj_5, adj_17, adj_58, adj_88);
    wp::adj_where(var_5, var_11, var_51, adj_5, adj_11, adj_51, adj_87);
    if (!var_5) {
        wp::adj_assign_inplace(var_1, var_86, var_85, adj_1, adj_86, adj_85);
        wp::adj_neg(var_84, adj_84, adj_85);
        wp::adj_extract(var_n, var_83, adj_n, adj_83, adj_84);
        // adj: b2[2] = -n[1]                                                                 <L 273>
        wp::adj_assign_inplace(var_1, var_82, var_81, adj_1, adj_82, adj_81);
        wp::adj_sub(var_74, var_80, adj_74, adj_80, adj_81);
        wp::adj_mul(var_79, var_51, adj_79, adj_51, adj_80);
        wp::adj_mul(var_76, var_78, adj_76, adj_78, adj_79);
        wp::adj_extract(var_n, var_77, adj_n, adj_77, adj_78);
        wp::adj_extract(var_n, var_75, adj_n, adj_75, adj_76);
        // adj: b2[1] = 1.0 - n[1] * n[1] * a                                                 <L 272>
        wp::adj_assign_inplace(var_1, var_73, var_58, adj_1, adj_73, adj_58);
        // adj: b2[0] = b                                                                     <L 271>
        wp::adj_assign_inplace(var_0, var_72, var_71, adj_0, adj_72, adj_71);
        wp::adj_neg(var_70, adj_70, adj_71);
        wp::adj_extract(var_n, var_69, adj_n, adj_69, adj_70);
        // adj: b1[2] = -n[0]                                                                 <L 269>
        wp::adj_assign_inplace(var_0, var_68, var_58, adj_0, adj_68, adj_58);
        // adj: b1[1] = b                                                                     <L 268>
        wp::adj_assign_inplace(var_0, var_67, var_66, adj_0, adj_67, adj_66);
        wp::adj_sub(var_59, var_65, adj_59, adj_65, adj_66);
        wp::adj_mul(var_64, var_51, adj_64, adj_51, adj_65);
        wp::adj_mul(var_61, var_63, adj_61, adj_63, adj_64);
        wp::adj_extract(var_n, var_62, adj_n, adj_62, adj_63);
        wp::adj_extract(var_n, var_60, adj_n, adj_60, adj_61);
        // adj: b1[0] = 1.0 - n[0] * n[0] * a                                                 <L 267>
        wp::adj_mul(var_57, var_51, adj_57, adj_51, adj_58);
        wp::adj_mul(var_54, var_56, adj_54, adj_56, adj_57);
        wp::adj_extract(var_n, var_55, adj_n, adj_55, adj_56);
        wp::adj_neg(var_53, adj_53, adj_54);
        wp::adj_extract(var_n, var_52, adj_n, adj_52, adj_53);
        // adj: b = -n[0] * n[1] * a                                                          <L 266>
        wp::adj_div(var_46, var_50, var_51, adj_46, adj_50, adj_51);
        wp::adj_add(var_47, var_49, adj_47, adj_49, adj_50);
        wp::adj_extract(var_n, var_48, adj_n, adj_48, adj_49);
        // adj: a = 1.0 / (1.0 + n[2])                                                        <L 265>
    }
    if (var_5) {
        wp::adj_assign_inplace(var_1, var_45, var_44, adj_1, adj_45, adj_44);
        wp::adj_neg(var_43, adj_43, adj_44);
        wp::adj_extract(var_n, var_42, adj_n, adj_42, adj_43);
        // adj: b2[2] = -n[1]                                                                 <L 263>
        wp::adj_assign_inplace(var_1, var_41, var_40, adj_1, adj_41, adj_40);
        wp::adj_sub(var_38, var_39, adj_38, adj_39, adj_40);
        wp::adj_mul(var_37, var_11, adj_37, adj_11, adj_38);
        wp::adj_mul(var_34, var_36, adj_34, adj_36, adj_37);
        wp::adj_extract(var_n, var_35, adj_n, adj_35, adj_36);
        wp::adj_extract(var_n, var_33, adj_n, adj_33, adj_34);
        // adj: b2[1] = n[1] * n[1] * a - 1.0                                                 <L 262>
        wp::adj_assign_inplace(var_1, var_32, var_17, adj_1, adj_32, adj_17);
        // adj: b2[0] = b                                                                     <L 261>
        wp::adj_assign_inplace(var_0, var_31, var_30, adj_0, adj_31, adj_30);
        wp::adj_extract(var_n, var_29, adj_n, adj_29, adj_30);
        // adj: b1[2] = n[0]                                                                  <L 259>
        wp::adj_assign_inplace(var_0, var_28, var_27, adj_0, adj_28, adj_27);
        wp::adj_neg(var_17, adj_17, adj_27);
        // adj: b1[1] = -b                                                                    <L 258>
        wp::adj_assign_inplace(var_0, var_26, var_25, adj_0, adj_26, adj_25);
        wp::adj_sub(var_18, var_24, adj_18, adj_24, adj_25);
        wp::adj_mul(var_23, var_11, adj_23, adj_11, adj_24);
        wp::adj_mul(var_20, var_22, adj_20, adj_22, adj_23);
        wp::adj_extract(var_n, var_21, adj_n, adj_21, adj_22);
        wp::adj_extract(var_n, var_19, adj_n, adj_19, adj_20);
        // adj: b1[0] = 1.0 - n[0] * n[0] * a                                                 <L 257>
        wp::adj_mul(var_16, var_11, adj_16, adj_11, adj_17);
        wp::adj_mul(var_13, var_15, adj_13, adj_15, adj_16);
        wp::adj_extract(var_n, var_14, adj_n, adj_14, adj_15);
        wp::adj_extract(var_n, var_12, adj_n, adj_12, adj_13);
        // adj: b = n[0] * n[1] * a                                                           <L 256>
        wp::adj_div(var_6, var_10, var_11, adj_6, adj_10, adj_11);
        wp::adj_sub(var_7, var_9, adj_7, adj_9, adj_10);
        wp::adj_extract(var_n, var_8, adj_n, adj_8, adj_9);
        // adj: a = 1.0 / (1.0 - n[2])                                                        <L 255>
    }
    wp::adj_extract(var_n, var_2, adj_n, adj_2, adj_3);
    // adj: if n[2] < 0.0:                                                                    <L 254>
    // adj: b2 = wp.vec3()                                                                    <L 253>
    // adj: b1 = wp.vec3()                                                                    <L 252>
    // adj: def orthonormal_basis(n: wp.vec3):                                                <L 236>
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:621
static CUDA_CALLABLE void adj_add_avoid_duplicates_vec2_0(
    wp::array_t<wp::vec_t<2, wp::float32>> var_arr,
    wp::int32 var_arr_count,
    wp::vec_t<2, wp::float32> var_vec,
    wp::float32 var_eps,
    wp::int32 & ret_0,
    bool & ret_1,
    wp::array_t<wp::vec_t<2, wp::float32>> & adj_arr,
    wp::int32 & adj_arr_count,
    wp::vec_t<2, wp::float32> & adj_vec,
    wp::float32 & adj_eps,
    wp::int32 & adj_ret_0,
    bool & adj_ret_1)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:141
static CUDA_CALLABLE void adj_update_incremental_plane_tracker_0(
    IncrementalPlaneTracker_8af6ef33 var_tracker,
    wp::vec_t<3, wp::float32> var_current_point,
    wp::int32 var_current_point_id,
    IncrementalPlaneTracker_8af6ef33 & adj_tracker,
    wp::vec_t<3, wp::float32> & adj_current_point,
    wp::int32 & adj_current_point_id,
    IncrementalPlaneTracker_8af6ef33 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:167
static CUDA_CALLABLE void adj_compute_line_segment_projector_normal_0(
    wp::vec_t<3, wp::float32> var_segment_dir,
    wp::vec_t<3, wp::float32> var_reference_normal,
    wp::vec_t<3, wp::float32> & adj_segment_dir,
    wp::vec_t<3, wp::float32> & adj_reference_normal,
    wp::vec_t<3, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:189
static CUDA_CALLABLE void adj_create_body_projectors_0(
    IncrementalPlaneTracker_8af6ef33 var_plane_tracker_a,
    wp::vec_t<3, wp::float32> var_anchor_point_a,
    IncrementalPlaneTracker_8af6ef33 var_plane_tracker_b,
    wp::vec_t<3, wp::float32> var_anchor_point_b,
    wp::vec_t<3, wp::float32> var_contact_normal,
    BodyProjector_d067bb7a & ret_0,
    BodyProjector_d067bb7a & ret_1,
    IncrementalPlaneTracker_8af6ef33 & adj_plane_tracker_a,
    wp::vec_t<3, wp::float32> & adj_anchor_point_a,
    IncrementalPlaneTracker_8af6ef33 & adj_plane_tracker_b,
    wp::vec_t<3, wp::float32> & adj_anchor_point_b,
    wp::vec_t<3, wp::float32> & adj_contact_normal,
    BodyProjector_d067bb7a & adj_ret_0,
    BodyProjector_d067bb7a & adj_ret_1)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:43
static CUDA_CALLABLE void adj_excess_normal_deviation_0(
    wp::vec_t<3, wp::float32> var_dir_a,
    wp::vec_t<3, wp::float32> var_dir_b,
    wp::vec_t<3, wp::float32> & adj_dir_a,
    wp::vec_t<3, wp::float32> & adj_dir_b,
    bool & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:62
static CUDA_CALLABLE void adj_signed_area_0(
    wp::vec_t<2, wp::float32> var_a,
    wp::vec_t<2, wp::float32> var_b,
    wp::vec_t<2, wp::float32> var_query_point,
    wp::vec_t<2, wp::float32> & adj_a,
    wp::vec_t<2, wp::float32> & adj_b,
    wp::vec_t<2, wp::float32> & adj_query_point,
    wp::float32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:263
static CUDA_CALLABLE void adj_intersection_point_0(
    wp::vec_t<2, wp::float32> var_trim_seg_start,
    wp::vec_t<2, wp::float32> var_trim_seg_end,
    wp::vec_t<2, wp::float32> var_a,
    wp::vec_t<2, wp::float32> var_b,
    wp::vec_t<2, wp::float32> & adj_trim_seg_start,
    wp::vec_t<2, wp::float32> & adj_trim_seg_end,
    wp::vec_t<2, wp::float32> & adj_a,
    wp::vec_t<2, wp::float32> & adj_b,
    wp::vec_t<2, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:289
static CUDA_CALLABLE void adj_insert_vec2_0(
    wp::array_t<wp::vec_t<2, wp::float32>> var_arr,
    wp::int32 var_arr_count,
    wp::int32 var_index,
    wp::vec_t<2, wp::float32> var_element,
    wp::array_t<wp::vec_t<2, wp::float32>> & adj_arr,
    wp::int32 & adj_arr_count,
    wp::int32 & adj_index,
    wp::vec_t<2, wp::float32> & adj_element)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:307
static CUDA_CALLABLE void adj_trim_in_place_0(
    wp::vec_t<2, wp::float32> var_trim_seg_start,
    wp::vec_t<2, wp::float32> var_trim_seg_end,
    wp::array_t<wp::vec_t<2, wp::float32>> var_loop,
    wp::int32 var_loop_count,
    wp::vec_t<2, wp::float32> & adj_trim_seg_start,
    wp::vec_t<2, wp::float32> & adj_trim_seg_end,
    wp::array_t<wp::vec_t<2, wp::float32>> & adj_loop,
    wp::int32 & adj_loop_count,
    wp::int32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:398
static CUDA_CALLABLE void adj_trim_all_in_place_0(
    wp::array_t<wp::vec_t<2, wp::float32>> var_trim_poly,
    wp::int32 var_trim_poly_count,
    wp::array_t<wp::vec_t<2, wp::float32>> var_loop,
    wp::int32 var_loop_count,
    wp::array_t<wp::vec_t<2, wp::float32>> & adj_trim_poly,
    wp::int32 & adj_trim_poly_count,
    wp::array_t<wp::vec_t<2, wp::float32>> & adj_loop,
    wp::int32 & adj_loop_count,
    wp::int32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:581
static CUDA_CALLABLE void adj_remove_zero_length_edges_0(
    wp::array_t<wp::vec_t<2, wp::float32>> var_loop,
    wp::int32 var_loop_count,
    wp::float32 var_eps,
    wp::array_t<wp::vec_t<2, wp::float32>> & adj_loop,
    wp::int32 & adj_loop_count,
    wp::float32 & adj_eps,
    wp::int32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:485
static CUDA_CALLABLE void adj_approx_max_quadrilateral_area_with_calipers_0(
    wp::array_t<wp::vec_t<2, wp::float32>> var_hull,
    wp::int32 var_hull_count,
    wp::array_t<wp::vec_t<2, wp::float32>> & adj_hull,
    wp::int32 & adj_hull_count,
    wp::vec_t<4, wp::int32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:87
static CUDA_CALLABLE void adj_ray_plane_intersection_0(
    wp::vec_t<3, wp::float32> var_ray_origin,
    wp::vec_t<3, wp::float32> var_ray_direction,
    wp::float32 var_plane_d,
    wp::vec_t<3, wp::float32> var_plane_normal,
    wp::vec_t<3, wp::float32> & adj_ray_origin,
    wp::vec_t<3, wp::float32> & adj_ray_direction,
    wp::float32 & adj_plane_d,
    wp::vec_t<3, wp::float32> & adj_plane_normal,
    wp::vec_t<3, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:239
static CUDA_CALLABLE void adj_body_projector_project_0(
    BodyProjector_d067bb7a var_proj,
    wp::vec_t<3, wp::float32> var_input,
    wp::vec_t<3, wp::float32> var_contact_normal,
    BodyProjector_d067bb7a & adj_proj,
    wp::vec_t<3, wp::float32> & adj_input,
    wp::vec_t<3, wp::float32> & adj_contact_normal,
    wp::vec_t<3, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:0
static CUDA_CALLABLE void adj_create_build_manifold__locals__extract_4_point_contact_manifolds_8(
    wp::array_t<wp::vec_t<2, wp::float32>> var_m_a,
    wp::int32 var_m_a_count,
    wp::fixedarray_t<10, wp::vec_t<2, wp::float32>> var_m_b,
    wp::int32 var_m_b_count,
    wp::vec_t<3, wp::float32> var_normal_local,
    wp::vec_t<3, wp::float32> var_cross_vector_1,
    wp::vec_t<3, wp::float32> var_cross_vector_2,
    wp::vec_t<3, wp::float32> var_center_local,
    BodyProjector_d067bb7a var_projector_a,
    BodyProjector_d067bb7a var_projector_b,
    wp::quat_t<wp::float32> var_orientation_a,
    wp::vec_t<3, wp::float32> var_position_a_world,
    wp::vec_t<3, wp::float32> var_normal_world,
    GlobalContactReducerData_98513266 var_writer_data,
    ContactData_40360d7c var_contact_template,
    GenericShapeData_ceaba563 var_geom_a,
    GenericShapeData_ceaba563 var_geom_b,
    wp::vec_t<3, wp::float32> var_position_a,
    wp::vec_t<3, wp::float32> var_position_b,
    wp::quat_t<wp::float32> var_quaternion_a,
    wp::quat_t<wp::float32> var_quaternion_b,
    wp::int32 & ret_0,
    wp::float32 & ret_1,
    wp::array_t<wp::vec_t<2, wp::float32>> & adj_m_a,
    wp::int32 & adj_m_a_count,
    wp::fixedarray_t<10, wp::vec_t<2, wp::float32>> & adj_m_b,
    wp::int32 & adj_m_b_count,
    wp::vec_t<3, wp::float32> & adj_normal_local,
    wp::vec_t<3, wp::float32> & adj_cross_vector_1,
    wp::vec_t<3, wp::float32> & adj_cross_vector_2,
    wp::vec_t<3, wp::float32> & adj_center_local,
    BodyProjector_d067bb7a & adj_projector_a,
    BodyProjector_d067bb7a & adj_projector_b,
    wp::quat_t<wp::float32> & adj_orientation_a,
    wp::vec_t<3, wp::float32> & adj_position_a_world,
    wp::vec_t<3, wp::float32> & adj_normal_world,
    GlobalContactReducerData_98513266 & adj_writer_data,
    ContactData_40360d7c & adj_contact_template,
    GenericShapeData_ceaba563 & adj_geom_a,
    GenericShapeData_ceaba563 & adj_geom_b,
    wp::vec_t<3, wp::float32> & adj_position_a,
    wp::vec_t<3, wp::float32> & adj_position_b,
    wp::quat_t<wp::float32> & adj_quaternion_a,
    wp::quat_t<wp::float32> & adj_quaternion_b,
    wp::int32 & adj_ret_0,
    wp::float32 & adj_ret_1)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:38
static CUDA_CALLABLE void adj_should_include_deepest_contact_0(
    wp::float32 var_normal_dot,
    wp::float32 & adj_normal_dot,
    bool & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/multicontact.py:0
static CUDA_CALLABLE void adj_create_build_manifold__locals__build_manifold_8(
    GenericShapeData_ceaba563 var_geom_a,
    GenericShapeData_ceaba563 var_geom_b,
    wp::quat_t<wp::float32> var_orientation_a,
    wp::vec_t<3, wp::float32> var_position_a_world,
    wp::quat_t<wp::float32> var_relative_orientation_b,
    wp::vec_t<3, wp::float32> var_relative_position_b,
    wp::vec_t<3, wp::float32> var_p_a,
    wp::vec_t<3, wp::float32> var_p_b,
    wp::vec_t<3, wp::float32> var_normal,
    SupportMapDataProvider_e77f8b9f var_data_provider,
    GlobalContactReducerData_98513266 var_writer_data,
    ContactData_40360d7c var_contact_template,
    GenericShapeData_ceaba563 & adj_geom_a,
    GenericShapeData_ceaba563 & adj_geom_b,
    wp::quat_t<wp::float32> & adj_orientation_a,
    wp::vec_t<3, wp::float32> & adj_position_a_world,
    wp::quat_t<wp::float32> & adj_relative_orientation_b,
    wp::vec_t<3, wp::float32> & adj_relative_position_b,
    wp::vec_t<3, wp::float32> & adj_p_a,
    wp::vec_t<3, wp::float32> & adj_p_b,
    wp::vec_t<3, wp::float32> & adj_normal,
    SupportMapDataProvider_e77f8b9f & adj_data_provider,
    GlobalContactReducerData_98513266 & adj_writer_data,
    ContactData_40360d7c & adj_contact_template,
    wp::int32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/collision_convex.py:0
static CUDA_CALLABLE void adj_create_solve_convex_multi_contact__locals__solve_convex_multi_contact_6(
    GenericShapeData_ceaba563 var_geom_a,
    GenericShapeData_ceaba563 var_geom_b,
    wp::quat_t<wp::float32> var_orientation_a,
    wp::quat_t<wp::float32> var_orientation_b,
    wp::vec_t<3, wp::float32> var_position_a,
    wp::vec_t<3, wp::float32> var_position_b,
    SupportMapDataProvider_e77f8b9f var_data_provider,
    wp::float32 var_contact_threshold,
    bool var_skip_multi_contact,
    GlobalContactReducerData_98513266 var_writer_data,
    ContactData_40360d7c var_contact_template,
    GenericShapeData_ceaba563 & adj_geom_a,
    GenericShapeData_ceaba563 & adj_geom_b,
    wp::quat_t<wp::float32> & adj_orientation_a,
    wp::quat_t<wp::float32> & adj_orientation_b,
    wp::vec_t<3, wp::float32> & adj_position_a,
    wp::vec_t<3, wp::float32> & adj_position_b,
    SupportMapDataProvider_e77f8b9f & adj_data_provider,
    wp::float32 & adj_contact_threshold,
    bool & adj_skip_multi_contact,
    GlobalContactReducerData_98513266 & adj_writer_data,
    ContactData_40360d7c & adj_contact_template,
    wp::int32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/collision_core.py:0
static CUDA_CALLABLE void adj_create_compute_gjk_mpr_contacts__locals__compute_gjk_mpr_contacts_0(
    GenericShapeData_ceaba563 var_shape_a_data,
    GenericShapeData_ceaba563 var_shape_b_data,
    wp::quat_t<wp::float32> var_rot_a,
    wp::quat_t<wp::float32> var_rot_b,
    wp::vec_t<3, wp::float32> var_pos_a_adjusted,
    wp::vec_t<3, wp::float32> var_pos_b_adjusted,
    wp::float32 var_rigid_gap,
    wp::int32 var_shape_a,
    wp::int32 var_shape_b,
    wp::float32 var_margin_a,
    wp::float32 var_margin_b,
    GlobalContactReducerData_98513266 var_writer_data,
    wp::int32 var_sort_sub_key,
    GenericShapeData_ceaba563 & adj_shape_a_data,
    GenericShapeData_ceaba563 & adj_shape_b_data,
    wp::quat_t<wp::float32> & adj_rot_a,
    wp::quat_t<wp::float32> & adj_rot_b,
    wp::vec_t<3, wp::float32> & adj_pos_a_adjusted,
    wp::vec_t<3, wp::float32> & adj_pos_b_adjusted,
    wp::float32 & adj_rigid_gap,
    wp::int32 & adj_shape_a,
    wp::int32 & adj_shape_b,
    wp::float32 & adj_margin_a,
    wp::float32 & adj_margin_b,
    GlobalContactReducerData_98513266 & adj_writer_data,
    wp::int32 & adj_sort_sub_key)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}



extern "C" __global__ void mesh_triangle_contacts_to_reducer_kernel_1e0d6dd7_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::int32> var_shape_types,
    wp::array_t<wp::vec_t<4, wp::float32>> var_shape_data,
    wp::array_t<wp::transform_t<wp::float32>> var_shape_transform,
    wp::array_t<wp::uint64> var_shape_source,
    wp::array_t<wp::float32> var_shape_gap,
    wp::array_t<wp::int32> var_shape_heightfield_index,
    wp::array_t<HeightfieldData_f2b8d59a> var_heightfield_data,
    wp::array_t<wp::float32> var_heightfield_elevations,
    wp::array_t<wp::vec_t<3, wp::int32>> var_triangle_pairs,
    wp::array_t<wp::int32> var_triangle_pairs_count,
    GlobalContactReducerData_98513266 var_reducer_data,
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
        const wp::int32 var_1 = 0;
        wp::int32* var_2;
        wp::int32 var_3;
        wp::int32 var_4;
        wp::range_t var_5;
        wp::int32 var_6;
        wp::shape_t* var_7;
        const wp::int32 var_8 = 0;
        wp::int32 var_9;
        wp::shape_t var_10;
        bool var_11;
        wp::vec_t<3, wp::int32>* var_12;
        wp::vec_t<3, wp::int32> var_13;
        wp::vec_t<3, wp::int32> var_14;
        const wp::int32 var_15 = 0;
        wp::int32 var_16;
        const wp::int32 var_17 = 1;
        wp::int32 var_18;
        const wp::int32 var_19 = 2;
        wp::int32 var_20;
        wp::int32* var_21;
        wp::int32 var_22;
        wp::int32 var_23;
        const wp::int32 var_24 = 2;
        bool var_25;
        wp::int32* var_26;
        HeightfieldData_f2b8d59a* var_27;
        wp::int32 var_28;
        HeightfieldData_f2b8d59a var_29;
        HeightfieldData_f2b8d59a var_30;
        wp::transform_t<wp::float32>* var_31;
        wp::transform_t<wp::float32> var_32;
        wp::transform_t<wp::float32> var_33;
        GenericShapeData_ceaba563 var_34;
        wp::vec_t<3, wp::float32> var_35;
        wp::uint64* var_36;
        wp::uint64 var_37;
        wp::uint64 var_38;
        wp::vec_t<4, wp::float32>* var_39;
        wp::vec_t<4, wp::float32> var_40;
        wp::vec_t<4, wp::float32> var_41;
        const wp::int32 var_42 = 0;
        wp::float32 var_43;
        const wp::int32 var_44 = 1;
        wp::float32 var_45;
        const wp::int32 var_46 = 2;
        wp::float32 var_47;
        wp::vec_t<3, wp::float32> var_48;
        wp::transform_t<wp::float32>* var_49;
        wp::transform_t<wp::float32> var_50;
        wp::transform_t<wp::float32> var_51;
        GenericShapeData_ceaba563 var_52;
        wp::vec_t<3, wp::float32> var_53;
        wp::transform_t<wp::float32> var_54;
        GenericShapeData_ceaba563 var_55;
        wp::vec_t<3, wp::float32> var_56;
        wp::vec_t<3, wp::float32> var_57;
        wp::quat_t<wp::float32> var_58;
        GenericShapeData_ceaba563 var_59;
        wp::vec_t<3, wp::float32> var_60;
        wp::float32 var_61;
        wp::vec_t<3, wp::float32> var_62;
        const wp::int32 var_63 = 2;
        bool var_64;
        wp::transform_t<wp::float32>* var_65;
        wp::quat_t<wp::float32> var_66;
        wp::transform_t<wp::float32> var_67;
        wp::quat_t<wp::float32> var_68;
        wp::quat_t<wp::float32> var_69;
        wp::int32* var_70;
        const wp::int32 var_71 = 1000;
        const wp::int32 var_72 = 1000;
        wp::int32 var_73;
        bool var_74;
        wp::int32 var_75;
        wp::vec_t<3, wp::float32>* var_76;
        wp::vec_t<3, wp::float32>* var_77;
        wp::vec_t<3, wp::float32> var_78;
        wp::vec_t<3, wp::float32> var_79;
        wp::vec_t<3, wp::float32> var_80;
        wp::vec_t<3, wp::float32> var_81;
        wp::float32 var_82;
        const wp::float32 var_83 = 0.0;
        bool var_84;
        wp::vec_t<4, wp::float32>* var_85;
        const wp::int32 var_86 = 3;
        wp::float32 var_87;
        wp::vec_t<4, wp::float32> var_88;
        wp::float32* var_89;
        wp::float32 var_90;
        wp::float32 var_91;
        wp::float32* var_92;
        wp::float32 var_93;
        wp::float32 var_94;
        wp::float32 var_95;
        const wp::int32 var_96 = 1;
        wp::int32 var_97;
        const wp::int32 var_98 = 1;
        wp::int32 var_99;
        //---------
        // forward
        // def mesh_triangle_contacts_to_reducer_kernel(                                          <L 1689>
        // tid = wp.tid()                                                                         <L 1711>
        var_0 = builtin_tid1d();
        // num_triangle_pairs = triangle_pairs_count[0]                                           <L 1713>
        var_2 = wp::address(var_triangle_pairs_count, var_1);
        var_4 = wp::load(var_2);
        var_3 = wp::copy(var_4);
        // for i in range(tid, num_triangle_pairs, total_num_threads):                            <L 1715>
        var_5 = wp::range(var_0, var_3, var_total_num_threads);
        start_for_0:;
            if (iter_cmp(var_5) == 0) goto end_for_0;
            var_6 = wp::iter_next(var_5);
            // if i >= triangle_pairs.shape[0]:                                                   <L 1716>
            var_7 = &(var_triangle_pairs.shape);
            var_10 = wp::load(var_7);
            var_9 = wp::extract(var_10, var_8);
            var_11 = (var_6 >= var_9);
            if (var_11) {
                // break                                                                          <L 1717>
                goto end_for_0;
            }
            // triple = triangle_pairs[i]                                                         <L 1719>
            var_12 = wp::address(var_triangle_pairs, var_6);
            var_14 = wp::load(var_12);
            var_13 = wp::copy(var_14);
            // shape_a = triple[0]  # Mesh or heightfield shape                                   <L 1720>
            var_16 = wp::extract(var_13, var_15);
            // shape_b = triple[1]  # Convex shape                                                <L 1721>
            var_18 = wp::extract(var_13, var_17);
            // tri_idx = triple[2]                                                                <L 1722>
            var_20 = wp::extract(var_13, var_19);
            // type_a = shape_types[shape_a]                                                      <L 1724>
            var_21 = wp::address(var_shape_types, var_16);
            var_23 = wp::load(var_21);
            var_22 = wp::copy(var_23);
            // if type_a == GeoType.HFIELD:                                                       <L 1726>
            var_25 = (var_22 == var_24);
            if (var_25) {
                // hfd = heightfield_data[shape_heightfield_index[shape_a]]                       <L 1728>
                var_26 = wp::address(var_shape_heightfield_index, var_16);
                var_28 = wp::load(var_26);
                var_27 = wp::address(var_heightfield_data, var_28);
                var_30 = wp::load(var_27);
                var_29 = wp::copy(var_30);
                // X_ws_a = shape_transform[shape_a]                                              <L 1729>
                var_31 = wp::address(var_shape_transform, var_16);
                var_33 = wp::load(var_31);
                var_32 = wp::copy(var_33);
                // shape_data_a, v0_world = get_triangle_shape_from_heightfield(hfd, heightfield_elevations, X_ws_a, tri_idx)       <L 1730>
                get_triangle_shape_from_heightfield_0(var_29, var_heightfield_elevations, var_32, var_20, var_34, var_35);
            }
            if (!var_25) {
                // mesh_id_a = shape_source[shape_a]                                              <L 1733>
                var_36 = wp::address(var_shape_source, var_16);
                var_38 = wp::load(var_36);
                var_37 = wp::copy(var_38);
                // scale_data_a = shape_data[shape_a]                                             <L 1734>
                var_39 = wp::address(var_shape_data, var_16);
                var_41 = wp::load(var_39);
                var_40 = wp::copy(var_41);
                // mesh_scale_a = wp.vec3(scale_data_a[0], scale_data_a[1], scale_data_a[2])       <L 1735>
                var_43 = wp::extract(var_40, var_42);
                var_45 = wp::extract(var_40, var_44);
                var_47 = wp::extract(var_40, var_46);
                var_48 = wp::vec_t<3, wp::float32>(var_43, var_45, var_47);
                // X_ws_a = shape_transform[shape_a]                                              <L 1736>
                var_49 = wp::address(var_shape_transform, var_16);
                var_51 = wp::load(var_49);
                var_50 = wp::copy(var_51);
                // shape_data_a, v0_world = get_triangle_shape_from_mesh(mesh_id_a, mesh_scale_a, X_ws_a, tri_idx)       <L 1737>
                get_triangle_shape_from_mesh_0(var_37, var_48, var_50, var_20, var_52, var_53);
            }
            var_54 = wp::where(var_25, var_32, var_50);
            var_55 = wp::where(var_25, var_34, var_52);
            var_56 = wp::where(var_25, var_35, var_53);
            // pos_b, quat_b, shape_data_b, _scale_b, margin_offset_b = extract_shape_data(       <L 1740>
            // shape_b,                                                                           <L 1741>
            // shape_transform,                                                                   <L 1742>
            // shape_types,                                                                       <L 1743>
            // shape_data,                                                                        <L 1744>
            // shape_source,                                                                      <L 1745>
            extract_shape_data_0(var_18, var_shape_transform, var_shape_types, var_shape_data, var_shape_source, var_57, var_58, var_59, var_60, var_61);
            // pos_a = v0_world                                                                   <L 1752>
            var_62 = wp::copy(var_56);
            // if type_a == GeoType.HFIELD:                                                       <L 1753>
            var_64 = (var_22 == var_63);
            if (var_64) {
                // quat_a = wp.transform_get_rotation(shape_transform[shape_a])                   <L 1754>
                var_65 = wp::address(var_shape_transform, var_16);
                var_67 = wp::load(var_65);
                var_66 = wp::transform_get_rotation(var_67);
            }
            if (!var_64) {
                // quat_a = wp.quat_identity()                                                    <L 1756>
                var_68 = wp::quat_identity<wp::float32>();
            }
            var_69 = wp::where(var_64, var_66, var_68);
            // if shape_data_a.shape_type == int(GeoTypeEx.TRIANGLE):                             <L 1761>
            var_70 = &((var_55).shape_type);
            var_73 = wp::int(var_72);
            var_75 = wp::load(var_70);
            var_74 = (var_75 == var_73);
            if (var_74) {
                // face_normal = wp.cross(shape_data_a.scale, shape_data_a.auxiliary)             <L 1762>
                var_76 = &((var_55).scale);
                var_77 = &((var_55).auxiliary);
                var_79 = wp::load(var_76);
                var_80 = wp::load(var_77);
                var_78 = wp::cross(var_79, var_80);
                // center_dist = wp.dot(face_normal, pos_b - pos_a)                               <L 1763>
                var_81 = wp::sub(var_57, var_62);
                var_82 = wp::dot(var_78, var_81);
                // if center_dist < 0.0:                                                          <L 1764>
                var_84 = (var_82 < var_83);
                if (var_84) {
                    // continue                                                                   <L 1765>
                    goto start_for_0;
                }
            }
            // margin_offset_a = shape_data[shape_a][3]                                           <L 1768>
            var_85 = wp::address(var_shape_data, var_16);
            var_88 = wp::load(var_85);
            var_87 = wp::extract(var_88, var_86);
            // gap_a = shape_gap[shape_a]                                                         <L 1771>
            var_89 = wp::address(var_shape_gap, var_16);
            var_91 = wp::load(var_89);
            var_90 = wp::copy(var_91);
            // gap_b = shape_gap[shape_b]                                                         <L 1772>
            var_92 = wp::address(var_shape_gap, var_18);
            var_94 = wp::load(var_92);
            var_93 = wp::copy(var_94);
            // gap_sum = gap_a + gap_b                                                            <L 1773>
            var_95 = wp::add(var_90, var_93);
            // wp.static(create_compute_gjk_mpr_contacts(write_contact_to_reducer))(              <L 1776>
            // shape_data_a,                                                                      <L 1777>
            // shape_data_b,                                                                      <L 1778>
            // quat_a,                                                                            <L 1779>
            // quat_b,                                                                            <L 1780>
            // pos_a,                                                                             <L 1781>
            // pos_b,                                                                             <L 1782>
            // gap_sum,                                                                           <L 1783>
            // shape_a,                                                                           <L 1784>
            // shape_b,                                                                           <L 1785>
            // margin_offset_a,                                                                   <L 1786>
            // margin_offset_b,                                                                   <L 1787>
            // reducer_data,                                                                      <L 1788>
            // (tri_idx << 1) | 1,                                                                <L 1789>
            var_97 = wp::lshift(var_20, var_96);
            var_99 = wp::bit_or(var_97, var_98);
            create_compute_gjk_mpr_contacts__locals__compute_gjk_mpr_contacts_0(var_55, var_59, var_69, var_58, var_62, var_57, var_95, var_16, var_18, var_87, var_61, var_reducer_data, var_99);
            goto start_for_0;
        end_for_0:;
    }
}

