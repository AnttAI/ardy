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


struct EdgeCullResult_d4aae4ab
{
    wp::int32 edge_idx;
    wp::float32 midpoint_sdf;


    EdgeCullResult_d4aae4ab() = default;
    CUDA_CALLABLE EdgeCullResult_d4aae4ab(wp::int32 const& edge_idx,
    wp::float32 const& midpoint_sdf = {})
        : edge_idx{edge_idx}
        , midpoint_sdf{midpoint_sdf}

    {
    }

    CUDA_CALLABLE EdgeCullResult_d4aae4ab& operator += (const EdgeCullResult_d4aae4ab& rhs)
    {    edge_idx += rhs.edge_idx;
    midpoint_sdf += rhs.midpoint_sdf;

        return *this;}


    CUDA_CALLABLE EdgeCullResult_d4aae4ab& operator -= (const EdgeCullResult_d4aae4ab& rhs)
    {    edge_idx -= rhs.edge_idx;
    midpoint_sdf -= rhs.midpoint_sdf;

        return *this;}

    CUDA_CALLABLE EdgeCullResult_d4aae4ab operator - () const
    {
        EdgeCullResult_d4aae4ab ret = *this;
    ret.edge_idx = -ret.edge_idx;
    ret.midpoint_sdf = -ret.midpoint_sdf;

        return ret;
    }

};

static CUDA_CALLABLE void adj_EdgeCullResult_d4aae4ab(wp::int32 const&,
    wp::float32 const&,
    wp::int32 & adj_edge_idx,
    wp::float32 & adj_midpoint_sdf,
    EdgeCullResult_d4aae4ab & adj_ret)
{
    adj_edge_idx += adj_ret.edge_idx;
    adj_midpoint_sdf += adj_ret.midpoint_sdf;
}

// Required when compiling adjoints.
CUDA_CALLABLE EdgeCullResult_d4aae4ab add(const EdgeCullResult_d4aae4ab& a, const EdgeCullResult_d4aae4ab& b)
{
    EdgeCullResult_d4aae4ab ret = a;
    ret += b;
    return ret;
}

CUDA_CALLABLE void adj_atomic_add(EdgeCullResult_d4aae4ab* p, EdgeCullResult_d4aae4ab t)
{
    wp::adj_atomic_add(&p->edge_idx, t.edge_idx);
    wp::adj_atomic_add(&p->midpoint_sdf, t.midpoint_sdf);
}


// Required by tile templates. The overloads are found by ADL when tile.h is
// instantiated with a generated struct type.
CUDA_CALLABLE void adj_add(const EdgeCullResult_d4aae4ab& a, const EdgeCullResult_d4aae4ab& b, EdgeCullResult_d4aae4ab& adj_a, EdgeCullResult_d4aae4ab& adj_b, const EdgeCullResult_d4aae4ab& adj_ret)
{
    adj_a += adj_ret;
    adj_b += adj_ret;
}

CUDA_CALLABLE EdgeCullResult_d4aae4ab sub(const EdgeCullResult_d4aae4ab& a, const EdgeCullResult_d4aae4ab& b)
{
    EdgeCullResult_d4aae4ab ret = a;
    ret -= b;
    return ret;
}

CUDA_CALLABLE void adj_sub(const EdgeCullResult_d4aae4ab& a, const EdgeCullResult_d4aae4ab& b, EdgeCullResult_d4aae4ab& adj_a, EdgeCullResult_d4aae4ab& adj_b, const EdgeCullResult_d4aae4ab& adj_ret)
{
    adj_a += adj_ret;
    adj_b -= adj_ret;
}

CUDA_CALLABLE EdgeCullResult_d4aae4ab atomic_add(EdgeCullResult_d4aae4ab* p, EdgeCullResult_d4aae4ab t)
{
    EdgeCullResult_d4aae4ab old {};
    old.edge_idx = wp::atomic_add(&p->edge_idx, t.edge_idx);
    old.midpoint_sdf = wp::atomic_add(&p->midpoint_sdf, t.midpoint_sdf);

    return old;
}

CUDA_CALLABLE EdgeCullResult_d4aae4ab tile_atomic_add_value(EdgeCullResult_d4aae4ab* p, EdgeCullResult_d4aae4ab t)
{
    return atomic_add(p, t);
}

CUDA_CALLABLE EdgeCullResult_d4aae4ab tile_adj_atomic_add_value(EdgeCullResult_d4aae4ab* p, EdgeCullResult_d4aae4ab t)
{
    // Tile adjoint struct atomics accumulate only for side effects; callers
    // currently ignore the returned old value, so avoid a second atomic here.
    EdgeCullResult_d4aae4ab old {};
    adj_atomic_add(p, t);
    return old;
}

#if defined(__CUDA_ARCH__)
CUDA_CALLABLE EdgeCullResult_d4aae4ab warp_shuffle_down(EdgeCullResult_d4aae4ab val, int offset, int mask)
{
    EdgeCullResult_d4aae4ab ret {};
    ret.edge_idx = wp::warp_shuffle_down(val.edge_idx, offset, mask);
    ret.midpoint_sdf = wp::warp_shuffle_down(val.midpoint_sdf, offset, mask);

    return ret;
}

CUDA_CALLABLE EdgeCullResult_d4aae4ab warp_shuffle_xor(EdgeCullResult_d4aae4ab val, int lane_mask)
{
    EdgeCullResult_d4aae4ab ret {};
    ret.edge_idx = wp::warp_shuffle_xor(val.edge_idx, lane_mask);
    ret.midpoint_sdf = wp::warp_shuffle_xor(val.midpoint_sdf, lane_mask);

    return ret;
}
#endif



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




struct TextureSDFData_93572308
{
    wp::texture3d_t coarse_texture;
    wp::texture3d_t subgrid_texture;
    wp::array_t<wp::uint32> subgrid_start_slots;
    wp::vec_t<3, wp::float32> sdf_box_lower;
    wp::vec_t<3, wp::float32> sdf_box_upper;
    wp::vec_t<3, wp::float32> inv_sdf_dx;
    wp::int32 subgrid_size;
    wp::float32 subgrid_size_f;
    wp::float32 subgrid_samples_f;
    wp::float32 fine_to_coarse;
    wp::vec_t<3, wp::float32> voxel_size;
    wp::float32 voxel_radius;
    wp::float32 subgrids_min_sdf_value;
    wp::float32 subgrids_sdf_value_range;
    bool paired_samples;
    bool scale_baked;


    TextureSDFData_93572308() = default;
    CUDA_CALLABLE TextureSDFData_93572308(wp::texture3d_t const& coarse_texture,
    wp::texture3d_t const& subgrid_texture = {},
    wp::array_t<wp::uint32> const& subgrid_start_slots = {},
    wp::vec_t<3, wp::float32> const& sdf_box_lower = {},
    wp::vec_t<3, wp::float32> const& sdf_box_upper = {},
    wp::vec_t<3, wp::float32> const& inv_sdf_dx = {},
    wp::int32 const& subgrid_size = {},
    wp::float32 const& subgrid_size_f = {},
    wp::float32 const& subgrid_samples_f = {},
    wp::float32 const& fine_to_coarse = {},
    wp::vec_t<3, wp::float32> const& voxel_size = {},
    wp::float32 const& voxel_radius = {},
    wp::float32 const& subgrids_min_sdf_value = {},
    wp::float32 const& subgrids_sdf_value_range = {},
    bool const& paired_samples = {},
    bool const& scale_baked = {})
        : coarse_texture{coarse_texture}
        , subgrid_texture{subgrid_texture}
        , subgrid_start_slots{subgrid_start_slots}
        , sdf_box_lower{sdf_box_lower}
        , sdf_box_upper{sdf_box_upper}
        , inv_sdf_dx{inv_sdf_dx}
        , subgrid_size{subgrid_size}
        , subgrid_size_f{subgrid_size_f}
        , subgrid_samples_f{subgrid_samples_f}
        , fine_to_coarse{fine_to_coarse}
        , voxel_size{voxel_size}
        , voxel_radius{voxel_radius}
        , subgrids_min_sdf_value{subgrids_min_sdf_value}
        , subgrids_sdf_value_range{subgrids_sdf_value_range}
        , paired_samples{paired_samples}
        , scale_baked{scale_baked}

    {
    }

    CUDA_CALLABLE TextureSDFData_93572308& operator += (const TextureSDFData_93572308& rhs)
    {    sdf_box_lower += rhs.sdf_box_lower;
    sdf_box_upper += rhs.sdf_box_upper;
    inv_sdf_dx += rhs.inv_sdf_dx;
    subgrid_size += rhs.subgrid_size;
    subgrid_size_f += rhs.subgrid_size_f;
    subgrid_samples_f += rhs.subgrid_samples_f;
    fine_to_coarse += rhs.fine_to_coarse;
    voxel_size += rhs.voxel_size;
    voxel_radius += rhs.voxel_radius;
    subgrids_min_sdf_value += rhs.subgrids_min_sdf_value;
    subgrids_sdf_value_range += rhs.subgrids_sdf_value_range;

        return *this;}

};

static CUDA_CALLABLE void adj_TextureSDFData_93572308(wp::texture3d_t const&,
    wp::texture3d_t const&,
    wp::array_t<wp::uint32> const&,
    wp::vec_t<3, wp::float32> const&,
    wp::vec_t<3, wp::float32> const&,
    wp::vec_t<3, wp::float32> const&,
    wp::int32 const&,
    wp::float32 const&,
    wp::float32 const&,
    wp::float32 const&,
    wp::vec_t<3, wp::float32> const&,
    wp::float32 const&,
    wp::float32 const&,
    wp::float32 const&,
    bool const&,
    bool const&,
    wp::texture3d_t & adj_coarse_texture,
    wp::texture3d_t & adj_subgrid_texture,
    wp::array_t<wp::uint32> & adj_subgrid_start_slots,
    wp::vec_t<3, wp::float32> & adj_sdf_box_lower,
    wp::vec_t<3, wp::float32> & adj_sdf_box_upper,
    wp::vec_t<3, wp::float32> & adj_inv_sdf_dx,
    wp::int32 & adj_subgrid_size,
    wp::float32 & adj_subgrid_size_f,
    wp::float32 & adj_subgrid_samples_f,
    wp::float32 & adj_fine_to_coarse,
    wp::vec_t<3, wp::float32> & adj_voxel_size,
    wp::float32 & adj_voxel_radius,
    wp::float32 & adj_subgrids_min_sdf_value,
    wp::float32 & adj_subgrids_sdf_value_range,
    bool & adj_paired_samples,
    bool & adj_scale_baked,
    TextureSDFData_93572308 & adj_ret)
{
    adj_coarse_texture += adj_ret.coarse_texture;
    adj_subgrid_texture += adj_ret.subgrid_texture;
    adj_subgrid_start_slots = adj_ret.subgrid_start_slots;
    adj_sdf_box_lower += adj_ret.sdf_box_lower;
    adj_sdf_box_upper += adj_ret.sdf_box_upper;
    adj_inv_sdf_dx += adj_ret.inv_sdf_dx;
    adj_subgrid_size += adj_ret.subgrid_size;
    adj_subgrid_size_f += adj_ret.subgrid_size_f;
    adj_subgrid_samples_f += adj_ret.subgrid_samples_f;
    adj_fine_to_coarse += adj_ret.fine_to_coarse;
    adj_voxel_size += adj_ret.voxel_size;
    adj_voxel_radius += adj_ret.voxel_radius;
    adj_subgrids_min_sdf_value += adj_ret.subgrids_min_sdf_value;
    adj_subgrids_sdf_value_range += adj_ret.subgrids_sdf_value_range;
    adj_paired_samples += adj_ret.paired_samples;
    adj_scale_baked += adj_ret.scale_baked;
}

// Required when compiling adjoints.
CUDA_CALLABLE TextureSDFData_93572308 add(const TextureSDFData_93572308& a, const TextureSDFData_93572308& b)
{
    return TextureSDFData_93572308();
}

CUDA_CALLABLE void adj_atomic_add(TextureSDFData_93572308* p, TextureSDFData_93572308 t)
{
    wp::adj_atomic_add(&p->coarse_texture, t.coarse_texture);
    wp::adj_atomic_add(&p->subgrid_texture, t.subgrid_texture);
    wp::adj_atomic_add(&p->subgrid_start_slots, t.subgrid_start_slots);
    wp::adj_atomic_add(&p->sdf_box_lower, t.sdf_box_lower);
    wp::adj_atomic_add(&p->sdf_box_upper, t.sdf_box_upper);
    wp::adj_atomic_add(&p->inv_sdf_dx, t.inv_sdf_dx);
    wp::adj_atomic_add(&p->subgrid_size, t.subgrid_size);
    wp::adj_atomic_add(&p->subgrid_size_f, t.subgrid_size_f);
    wp::adj_atomic_add(&p->subgrid_samples_f, t.subgrid_samples_f);
    wp::adj_atomic_add(&p->fine_to_coarse, t.fine_to_coarse);
    wp::adj_atomic_add(&p->voxel_size, t.voxel_size);
    wp::adj_atomic_add(&p->voxel_radius, t.voxel_radius);
    wp::adj_atomic_add(&p->subgrids_min_sdf_value, t.subgrids_min_sdf_value);
    wp::adj_atomic_add(&p->subgrids_sdf_value_range, t.subgrids_sdf_value_range);
    wp::adj_atomic_add(&p->paired_samples, t.paired_samples);
    wp::adj_atomic_add(&p->scale_baked, t.scale_baked);
}




struct _CellLookup_6716dbae
{
    wp::int32 ix;
    wp::int32 iy;
    wp::int32 iz;
    wp::float32 tx;
    wp::float32 ty;
    wp::float32 tz;
    wp::int32 x_base;
    wp::int32 y_base;
    wp::int32 z_base;
    wp::uint32 start_slot;


    _CellLookup_6716dbae() = default;
    CUDA_CALLABLE _CellLookup_6716dbae(wp::int32 const& ix,
    wp::int32 const& iy = {},
    wp::int32 const& iz = {},
    wp::float32 const& tx = {},
    wp::float32 const& ty = {},
    wp::float32 const& tz = {},
    wp::int32 const& x_base = {},
    wp::int32 const& y_base = {},
    wp::int32 const& z_base = {},
    wp::uint32 const& start_slot = {})
        : ix{ix}
        , iy{iy}
        , iz{iz}
        , tx{tx}
        , ty{ty}
        , tz{tz}
        , x_base{x_base}
        , y_base{y_base}
        , z_base{z_base}
        , start_slot{start_slot}

    {
    }

    CUDA_CALLABLE _CellLookup_6716dbae& operator += (const _CellLookup_6716dbae& rhs)
    {    ix += rhs.ix;
    iy += rhs.iy;
    iz += rhs.iz;
    tx += rhs.tx;
    ty += rhs.ty;
    tz += rhs.tz;
    x_base += rhs.x_base;
    y_base += rhs.y_base;
    z_base += rhs.z_base;
    start_slot += rhs.start_slot;

        return *this;}

};

static CUDA_CALLABLE void adj__CellLookup_6716dbae(wp::int32 const&,
    wp::int32 const&,
    wp::int32 const&,
    wp::float32 const&,
    wp::float32 const&,
    wp::float32 const&,
    wp::int32 const&,
    wp::int32 const&,
    wp::int32 const&,
    wp::uint32 const&,
    wp::int32 & adj_ix,
    wp::int32 & adj_iy,
    wp::int32 & adj_iz,
    wp::float32 & adj_tx,
    wp::float32 & adj_ty,
    wp::float32 & adj_tz,
    wp::int32 & adj_x_base,
    wp::int32 & adj_y_base,
    wp::int32 & adj_z_base,
    wp::uint32 & adj_start_slot,
    _CellLookup_6716dbae & adj_ret)
{
    adj_ix += adj_ret.ix;
    adj_iy += adj_ret.iy;
    adj_iz += adj_ret.iz;
    adj_tx += adj_ret.tx;
    adj_ty += adj_ret.ty;
    adj_tz += adj_ret.tz;
    adj_x_base += adj_ret.x_base;
    adj_y_base += adj_ret.y_base;
    adj_z_base += adj_ret.z_base;
    adj_start_slot += adj_ret.start_slot;
}

// Required when compiling adjoints.
CUDA_CALLABLE _CellLookup_6716dbae add(const _CellLookup_6716dbae& a, const _CellLookup_6716dbae& b)
{
    return _CellLookup_6716dbae();
}

CUDA_CALLABLE void adj_atomic_add(_CellLookup_6716dbae* p, _CellLookup_6716dbae t)
{
    wp::adj_atomic_add(&p->ix, t.ix);
    wp::adj_atomic_add(&p->iy, t.iy);
    wp::adj_atomic_add(&p->iz, t.iz);
    wp::adj_atomic_add(&p->tx, t.tx);
    wp::adj_atomic_add(&p->ty, t.ty);
    wp::adj_atomic_add(&p->tz, t.tz);
    wp::adj_atomic_add(&p->x_base, t.x_base);
    wp::adj_atomic_add(&p->y_base, t.y_base);
    wp::adj_atomic_add(&p->z_base, t.z_base);
    wp::adj_atomic_add(&p->start_slot, t.start_slot);
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




// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/kernels.py:15
static CUDA_CALLABLE wp::int32 resolve_mesh_sign_method_0(
    wp::int32 var_mesh_properties)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 1;
    wp::int32 var_1;
    const wp::int32 var_2 = 1;
    const wp::int32 var_3 = 1;
    wp::int32 var_4;
    const wp::int32 var_5 = 0;
    const wp::int32 var_6 = 0;
    wp::int32 var_7;
    //---------
    // forward
    // def resolve_mesh_sign_method(mesh_properties: int):                                    <L 16>
    // if mesh_properties & MeshProperties.WATERTIGHT:                                        <L 26>
    var_1 = wp::bit_and(var_mesh_properties, var_0);
    if (var_1) {
        // return int(MeshSignMethod.PARITY)                                                  <L 27>
        var_4 = wp::int(var_3);
        return var_4;
    }
    // return int(MeshSignMethod.NORMAL)                                                      <L 28>
    var_7 = wp::int(var_6);
    return var_7;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:120
static CUDA_CALLABLE void safe_sdf_scale_inverse_0(
    wp::vec_t<3, wp::float32> var_sdf_scale,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::float32 & ret_1)
{
    //---------
    // primal vars
    const wp::float32 var_0 = 1e-10;
    wp::float32 var_1;
    const wp::int32 var_2 = 0;
    wp::float32 var_3;
    wp::float32 var_4;
    bool var_5;
    const wp::int32 var_6 = 0;
    wp::float32 var_7;
    const wp::int32 var_8 = 0;
    wp::float32 var_9;
    const wp::float32 var_10 = 0.0;
    bool var_11;
    wp::float32 var_12;
    wp::float32 var_13;
    wp::float32 var_14;
    const wp::int32 var_15 = 1;
    wp::float32 var_16;
    wp::float32 var_17;
    bool var_18;
    const wp::int32 var_19 = 1;
    wp::float32 var_20;
    const wp::int32 var_21 = 1;
    wp::float32 var_22;
    const wp::float32 var_23 = 0.0;
    bool var_24;
    wp::float32 var_25;
    wp::float32 var_26;
    wp::float32 var_27;
    const wp::int32 var_28 = 2;
    wp::float32 var_29;
    wp::float32 var_30;
    bool var_31;
    const wp::int32 var_32 = 2;
    wp::float32 var_33;
    const wp::int32 var_34 = 2;
    wp::float32 var_35;
    const wp::float32 var_36 = 0.0;
    bool var_37;
    wp::float32 var_38;
    wp::float32 var_39;
    wp::float32 var_40;
    const wp::float32 var_41 = 1.0;
    wp::float32 var_42;
    const wp::float32 var_43 = 1.0;
    wp::float32 var_44;
    const wp::float32 var_45 = 1.0;
    wp::float32 var_46;
    wp::vec_t<3, wp::float32> var_47;
    wp::float32 var_48;
    wp::float32 var_49;
    wp::float32 var_50;
    wp::float32 var_51;
    wp::float32 var_52;
    //---------
    // forward
    // def safe_sdf_scale_inverse(sdf_scale: wp.vec3) -> tuple[wp.vec3, float]:               <L 121>
    // eps = float(1.0e-10)                                                                   <L 130>
    var_1 = wp::float(var_0);
    // sx = wp.where(wp.abs(sdf_scale[0]) > eps, sdf_scale[0], wp.where(sdf_scale[0] >= 0.0, eps, -eps))       <L 131>
    var_3 = wp::extract(var_sdf_scale, var_2);
    var_4 = wp::abs(var_3);
    var_5 = (var_4 > var_1);
    var_7 = wp::extract(var_sdf_scale, var_6);
    var_9 = wp::extract(var_sdf_scale, var_8);
    var_11 = (var_9 >= var_10);
    var_12 = wp::neg(var_1);
    var_13 = wp::where(var_11, var_1, var_12);
    var_14 = wp::where(var_5, var_7, var_13);
    // sy = wp.where(wp.abs(sdf_scale[1]) > eps, sdf_scale[1], wp.where(sdf_scale[1] >= 0.0, eps, -eps))       <L 132>
    var_16 = wp::extract(var_sdf_scale, var_15);
    var_17 = wp::abs(var_16);
    var_18 = (var_17 > var_1);
    var_20 = wp::extract(var_sdf_scale, var_19);
    var_22 = wp::extract(var_sdf_scale, var_21);
    var_24 = (var_22 >= var_23);
    var_25 = wp::neg(var_1);
    var_26 = wp::where(var_24, var_1, var_25);
    var_27 = wp::where(var_18, var_20, var_26);
    // sz = wp.where(wp.abs(sdf_scale[2]) > eps, sdf_scale[2], wp.where(sdf_scale[2] >= 0.0, eps, -eps))       <L 133>
    var_29 = wp::extract(var_sdf_scale, var_28);
    var_30 = wp::abs(var_29);
    var_31 = (var_30 > var_1);
    var_33 = wp::extract(var_sdf_scale, var_32);
    var_35 = wp::extract(var_sdf_scale, var_34);
    var_37 = (var_35 >= var_36);
    var_38 = wp::neg(var_1);
    var_39 = wp::where(var_37, var_1, var_38);
    var_40 = wp::where(var_31, var_33, var_39);
    // inv = wp.vec3(1.0 / sx, 1.0 / sy, 1.0 / sz)                                            <L 134>
    var_42 = wp::div(var_41, var_14);
    var_44 = wp::div(var_43, var_27);
    var_46 = wp::div(var_45, var_40);
    var_47 = wp::vec_t<3, wp::float32>(var_42, var_44, var_46);
    // min_abs = wp.min(wp.min(wp.abs(sx), wp.abs(sy)), wp.abs(sz))                           <L 135>
    var_48 = wp::abs(var_14);
    var_49 = wp::abs(var_27);
    var_50 = wp::min(var_48, var_49);
    var_51 = wp::abs(var_40);
    var_52 = wp::min(var_50, var_51);
    // return inv, min_abs                                                                    <L 136>
    ret_0 = var_47;
    ret_1 = var_52;
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:80
static CUDA_CALLABLE wp::float32 mesh_sdf_contact_search_precision_0(
    wp::float32 var_inner_contact_threshold,
    wp::float32 var_min_sdf_scale,
    wp::float32 var_voxel_radius,
    bool var_use_texture_sdf)
{
    //---------
    // primal vars
    wp::float32 var_0;
    wp::float32 var_1;
    wp::float32 var_2;
    //---------
    // forward
    // def mesh_sdf_contact_search_precision(                                                 <L 81>
    // search_precision = inner_contact_threshold / min_sdf_scale                             <L 88>
    var_0 = wp::div(var_inner_contact_threshold, var_min_sdf_scale);
    // if use_texture_sdf:                                                                    <L 89>
    if (var_use_texture_sdf) {
        // search_precision = wp.min(search_precision, voxel_radius)                          <L 90>
        var_1 = wp::min(var_0, var_voxel_radius);
    }
    var_2 = wp::where(var_use_texture_sdf, var_1, var_0);
    // return search_precision                                                                <L 91>
    return var_2;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:641
static CUDA_CALLABLE wp::int32 get_edge_count_0(
    wp::int32 var_shape_type,
    wp::vec_t<2, wp::int32> var_edge_range,
    HeightfieldData_f2b8d59a var_hfd)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 2;
    bool var_1;
    bool var_2;
    wp::int32* var_3;
    const wp::int32 var_4 = 1;
    bool var_5;
    wp::int32 var_6;
    wp::int32* var_7;
    const wp::int32 var_8 = 1;
    bool var_9;
    wp::int32 var_10;
    const wp::int32 var_11 = 0;
    wp::int32* var_12;
    wp::int32* var_13;
    const wp::int32 var_14 = 1;
    wp::int32 var_15;
    wp::int32 var_16;
    wp::int32 var_17;
    wp::int32 var_18;
    wp::int32* var_19;
    const wp::int32 var_20 = 1;
    wp::int32 var_21;
    wp::int32 var_22;
    wp::int32* var_23;
    wp::int32 var_24;
    wp::int32 var_25;
    wp::int32 var_26;
    wp::int32* var_27;
    const wp::int32 var_28 = 1;
    wp::int32 var_29;
    wp::int32 var_30;
    wp::int32* var_31;
    const wp::int32 var_32 = 1;
    wp::int32 var_33;
    wp::int32 var_34;
    wp::int32 var_35;
    wp::int32 var_36;
    const wp::int32 var_37 = 1;
    wp::int32 var_38;
    //---------
    // forward
    // def get_edge_count(shape_type: int, edge_range: wp.vec2i, hfd: HeightfieldData) -> int:       <L 642>
    // if shape_type == GeoType.HFIELD:                                                       <L 644>
    var_1 = (var_shape_type == var_0);
    if (var_1) {
        // if hfd.nrow <= 1 or hfd.ncol <= 1:                                                 <L 645>
        var_3 = &((var_hfd).nrow);
        var_6 = wp::load(var_3);
        var_5 = (var_6 <= var_4);
        var_2 = var_5;
        if (!var_2) {
            var_7 = &((var_hfd).ncol);
            var_10 = wp::load(var_7);
            var_9 = (var_10 <= var_8);
            var_2 = var_2 || var_9;
        }
        if (var_2) {
            // return 0                                                                       <L 646>
            return var_11;
        }
        // return hfd.nrow * (hfd.ncol - 1) + (hfd.nrow - 1) * hfd.ncol + (hfd.nrow - 1) * (hfd.ncol - 1)       <L 647>
        var_12 = &((var_hfd).nrow);
        var_13 = &((var_hfd).ncol);
        var_16 = wp::load(var_13);
        var_15 = wp::sub(var_16, var_14);
        var_18 = wp::load(var_12);
        var_17 = wp::mul(var_18, var_15);
        var_19 = &((var_hfd).nrow);
        var_22 = wp::load(var_19);
        var_21 = wp::sub(var_22, var_20);
        var_23 = &((var_hfd).ncol);
        var_25 = wp::load(var_23);
        var_24 = wp::mul(var_21, var_25);
        var_26 = wp::add(var_17, var_24);
        var_27 = &((var_hfd).nrow);
        var_30 = wp::load(var_27);
        var_29 = wp::sub(var_30, var_28);
        var_31 = &((var_hfd).ncol);
        var_34 = wp::load(var_31);
        var_33 = wp::sub(var_34, var_32);
        var_35 = wp::mul(var_29, var_33);
        var_36 = wp::add(var_26, var_35);
        return var_36;
    }
    // return edge_range[1]                                                                   <L 648>
    var_38 = wp::extract(var_edge_range, var_37);
    return var_38;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:419
static CUDA_CALLABLE void get_edge_from_mesh_0(
    wp::uint64 var_mesh_id,
    wp::array_t<wp::vec_t<2, wp::int32>> var_mesh_edge_indices,
    wp::vec_t<2, wp::int32> var_edge_range,
    wp::vec_t<3, wp::float32> var_mesh_scale,
    wp::transform_t<wp::float32> var_X_mesh_ws,
    wp::int32 var_edge_idx,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    wp::Mesh var_0;
    const wp::int32 var_1 = 0;
    wp::int32 var_2;
    wp::int32 var_3;
    wp::vec_t<2, wp::int32>* var_4;
    wp::vec_t<2, wp::int32> var_5;
    wp::vec_t<2, wp::int32> var_6;
    const wp::int32 var_7 = 0;
    wp::int32 var_8;
    const wp::int32 var_9 = 1;
    wp::int32 var_10;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_11;
    wp::vec_t<3, wp::float32>* var_12;
    wp::array_t<wp::vec_t<3, wp::float32>> var_13;
    wp::vec_t<3, wp::float32> var_14;
    wp::vec_t<3, wp::float32> var_15;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_16;
    wp::vec_t<3, wp::float32>* var_17;
    wp::array_t<wp::vec_t<3, wp::float32>> var_18;
    wp::vec_t<3, wp::float32> var_19;
    wp::vec_t<3, wp::float32> var_20;
    wp::vec_t<3, wp::float32> var_21;
    wp::vec_t<3, wp::float32> var_22;
    //---------
    // forward
    // def get_edge_from_mesh(                                                                <L 420>
    // mesh = wp.mesh_get(mesh_id)                                                            <L 445>
    var_0 = wp::mesh_get(var_mesh_id);
    // edge = mesh_edge_indices[edge_range[0] + edge_idx]                                     <L 446>
    var_2 = wp::extract(var_edge_range, var_1);
    var_3 = wp::add(var_2, var_edge_idx);
    var_4 = wp::address(var_mesh_edge_indices, var_3);
    var_6 = wp::load(var_4);
    var_5 = wp::copy(var_6);
    // idx0 = edge[0]                                                                         <L 448>
    var_8 = wp::extract(var_5, var_7);
    // idx1 = edge[1]                                                                         <L 449>
    var_10 = wp::extract(var_5, var_9);
    // v0_local = wp.cw_mul(mesh.points[idx0], mesh_scale)                                    <L 451>
    var_11 = &((var_0).points);
    var_13 = wp::load(var_11);
    var_12 = wp::address(var_13, var_8);
    var_15 = wp::load(var_12);
    var_14 = wp::cw_mul(var_15, var_mesh_scale);
    // v1_local = wp.cw_mul(mesh.points[idx1], mesh_scale)                                    <L 452>
    var_16 = &((var_0).points);
    var_18 = wp::load(var_16);
    var_17 = wp::address(var_18, var_10);
    var_20 = wp::load(var_17);
    var_19 = wp::cw_mul(var_20, var_mesh_scale);
    // v0_world = wp.transform_point(X_mesh_ws, v0_local)                                     <L 454>
    var_21 = wp::transform_point(var_X_mesh_ws, var_14);
    // v1_world = wp.transform_point(X_mesh_ws, v1_local)                                     <L 455>
    var_22 = wp::transform_point(var_X_mesh_ws, var_19);
    // return v0_world, v1_world                                                              <L 457>
    ret_0 = var_21;
    ret_1 = var_22;
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:586
static CUDA_CALLABLE void get_edge_bounding_sphere_0(
    wp::vec_t<3, wp::float32> var_v0,
    wp::vec_t<3, wp::float32> var_v1,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::float32 & ret_1)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    const wp::float32 var_1 = 0.5;
    wp::vec_t<3, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    wp::float32 var_4;
    const wp::float32 var_5 = 0.5;
    wp::float32 var_6;
    //---------
    // forward
    // def get_edge_bounding_sphere(v0: wp.vec3, v1: wp.vec3) -> tuple[wp.vec3, float]:       <L 587>
    // midpoint = (v0 + v1) * 0.5                                                             <L 597>
    var_0 = wp::add(var_v0, var_v1);
    var_2 = wp::mul(var_0, var_1);
    // half_length = wp.length(v1 - v0) * 0.5                                                 <L 598>
    var_3 = wp::sub(var_v1, var_v0);
    var_4 = wp::length(var_3);
    var_6 = wp::mul(var_4, var_5);
    // return midpoint, half_length                                                           <L 599>
    ret_0 = var_2;
    ret_1 = var_6;
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:605
static CUDA_CALLABLE void _create_get_mesh_edge_bounding_sphere_func__locals__get_mesh_edge_bounding_sphere_func_1(
    wp::uint64 var_mesh_id,
    wp::array_t<wp::vec_t<2, wp::int32>> var_mesh_edge_indices,
    wp::array_t<wp::vec_t<4, wp::float32>> var_mesh_edge_centers,
    wp::vec_t<2, wp::int32> var_edge_range,
    wp::vec_t<3, wp::float32> var_mesh_scale,
    wp::transform_t<wp::float32> var_X_mesh_ws,
    wp::vec_t<3, wp::float32> var_inv_sdf_scale,
    wp::float32 var_radius_scale,
    wp::int32 var_edge_idx,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::float32 & ret_1)
{
    //---------
    // primal vars
    const bool var_0 = true;
    const wp::int32 var_1 = 0;
    wp::int32 var_2;
    wp::int32 var_3;
    wp::vec_t<4, wp::float32>* var_4;
    wp::vec_t<4, wp::float32> var_5;
    wp::vec_t<4, wp::float32> var_6;
    const wp::int32 var_7 = 0;
    wp::float32 var_8;
    const wp::int32 var_9 = 1;
    wp::float32 var_10;
    const wp::int32 var_11 = 2;
    wp::float32 var_12;
    wp::vec_t<3, wp::float32> var_13;
    wp::vec_t<3, wp::float32> var_14;
    wp::vec_t<3, wp::float32> var_15;
    const wp::int32 var_16 = 3;
    wp::float32 var_17;
    wp::float32 var_18;
    wp::vec_t<3, wp::float32> var_19;
    wp::vec_t<3, wp::float32> var_20;
    wp::vec_t<3, wp::float32> var_21;
    wp::vec_t<3, wp::float32> var_22;
    wp::vec_t<3, wp::float32> var_23;
    wp::float32 var_24;
    //---------
    // forward
    // def get_mesh_edge_bounding_sphere_func(                                                <L 606>
    // if wp.static(use_precomputed_edge_data):                                               <L 617>
    // center_radius = mesh_edge_centers[edge_range[0] + edge_idx]                            <L 618>
    var_2 = wp::extract(var_edge_range, var_1);
    var_3 = wp::add(var_2, var_edge_idx);
    var_4 = wp::address(var_mesh_edge_centers, var_3);
    var_6 = wp::load(var_4);
    var_5 = wp::copy(var_6);
    // center_local = wp.vec3(center_radius[0], center_radius[1], center_radius[2])           <L 619>
    var_8 = wp::extract(var_5, var_7);
    var_10 = wp::extract(var_5, var_9);
    var_12 = wp::extract(var_5, var_11);
    var_13 = wp::vec_t<3, wp::float32>(var_8, var_10, var_12);
    // center_scaled = wp.transform_point(X_mesh_ws, center_local)                            <L 620>
    var_14 = wp::transform_point(var_X_mesh_ws, var_13);
    // center = wp.cw_mul(center_scaled, inv_sdf_scale)                                       <L 621>
    var_15 = wp::cw_mul(var_14, var_inv_sdf_scale);
    // return center, center_radius[3] * radius_scale                                         <L 622>
    var_17 = wp::extract(var_5, var_16);
    var_18 = wp::mul(var_17, var_radius_scale);
    ret_0 = var_15;
    ret_1 = var_18;
    return;
    // v0, v1 = get_edge_from_mesh(mesh_id, mesh_edge_indices, edge_range, mesh_scale, X_mesh_ws, edge_idx)       <L 624>
    get_edge_from_mesh_0(var_mesh_id, var_mesh_edge_indices, var_edge_range, var_mesh_scale, var_X_mesh_ws, var_edge_idx, var_19, var_20);
    // center, radius = get_edge_bounding_sphere(wp.cw_mul(v0, inv_sdf_scale), wp.cw_mul(v1, inv_sdf_scale))       <L 625>
    var_21 = wp::cw_mul(var_19, var_inv_sdf_scale);
    var_22 = wp::cw_mul(var_20, var_inv_sdf_scale);
    get_edge_bounding_sphere_0(var_21, var_22, var_23, var_24);
    // return center, radius                                                                  <L 626>
    ret_0 = var_23;
    ret_1 = var_24;
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/utils/heightfield.py:171
static CUDA_CALLABLE void _heightfield_surface_query_0(
    HeightfieldData_f2b8d59a var_hfd,
    wp::array_t<wp::float32> var_elevation_data,
    wp::vec_t<3, wp::float32> var_pos,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::float32 & ret_2)
{
    //---------
    // primal vars
    bool var_0;
    wp::int32* var_1;
    const wp::int32 var_2 = 1;
    bool var_3;
    wp::int32 var_4;
    wp::int32* var_5;
    const wp::int32 var_6 = 1;
    bool var_7;
    wp::int32 var_8;
    const wp::float32 var_9 = 10000000000.0;
    const wp::float32 var_10 = 0.0;
    const wp::float32 var_11 = 0.0;
    const wp::float32 var_12 = 1.0;
    wp::vec_t<3, wp::float32> var_13;
    const wp::float32 var_14 = 0.0;
    const wp::float32 var_15 = 2.0;
    wp::float32* var_16;
    wp::float32 var_17;
    wp::float32 var_18;
    wp::int32* var_19;
    const wp::int32 var_20 = 1;
    wp::int32 var_21;
    wp::int32 var_22;
    wp::float32 var_23;
    wp::float32 var_24;
    const wp::float32 var_25 = 2.0;
    wp::float32* var_26;
    wp::float32 var_27;
    wp::float32 var_28;
    wp::int32* var_29;
    const wp::int32 var_30 = 1;
    wp::int32 var_31;
    wp::int32 var_32;
    wp::float32 var_33;
    wp::float32 var_34;
    wp::float32* var_35;
    wp::float32* var_36;
    wp::float32 var_37;
    wp::float32 var_38;
    wp::float32 var_39;
    const wp::int32 var_40 = 0;
    wp::float32 var_41;
    wp::float32* var_42;
    wp::float32 var_43;
    wp::float32 var_44;
    wp::float32* var_45;
    wp::float32 var_46;
    wp::float32 var_47;
    const wp::int32 var_48 = 1;
    wp::float32 var_49;
    wp::float32* var_50;
    wp::float32 var_51;
    wp::float32 var_52;
    wp::float32* var_53;
    wp::float32 var_54;
    wp::float32 var_55;
    const wp::int32 var_56 = 0;
    wp::float32 var_57;
    wp::float32 var_58;
    const wp::int32 var_59 = 1;
    wp::float32 var_60;
    wp::float32 var_61;
    wp::float32 var_62;
    wp::float32 var_63;
    wp::float32 var_64;
    wp::float32* var_65;
    wp::float32 var_66;
    wp::float32 var_67;
    wp::float32 var_68;
    wp::float32* var_69;
    wp::float32 var_70;
    wp::float32 var_71;
    wp::float32 var_72;
    const wp::float32 var_73 = 0.0;
    wp::int32* var_74;
    const wp::int32 var_75 = 1;
    wp::int32 var_76;
    wp::int32 var_77;
    wp::float32 var_78;
    wp::float32 var_79;
    const wp::float32 var_80 = 0.0;
    wp::int32* var_81;
    const wp::int32 var_82 = 1;
    wp::int32 var_83;
    wp::int32 var_84;
    wp::float32 var_85;
    wp::float32 var_86;
    wp::int32 var_87;
    wp::int32* var_88;
    const wp::int32 var_89 = 2;
    wp::int32 var_90;
    wp::int32 var_91;
    wp::int32 var_92;
    wp::int32 var_93;
    wp::int32* var_94;
    const wp::int32 var_95 = 2;
    wp::int32 var_96;
    wp::int32 var_97;
    wp::int32 var_98;
    wp::float32 var_99;
    wp::float32 var_100;
    wp::float32 var_101;
    wp::float32 var_102;
    wp::int32* var_103;
    wp::int32 var_104;
    wp::int32 var_105;
    wp::float32* var_106;
    wp::int32* var_107;
    wp::int32 var_108;
    wp::int32 var_109;
    wp::int32 var_110;
    wp::int32 var_111;
    wp::float32* var_112;
    wp::float32 var_113;
    wp::float32 var_114;
    wp::float32 var_115;
    wp::float32 var_116;
    wp::float32* var_117;
    wp::int32* var_118;
    wp::int32 var_119;
    wp::int32 var_120;
    wp::int32 var_121;
    wp::int32 var_122;
    const wp::int32 var_123 = 1;
    wp::int32 var_124;
    wp::float32* var_125;
    wp::float32 var_126;
    wp::float32 var_127;
    wp::float32 var_128;
    wp::float32 var_129;
    wp::float32* var_130;
    const wp::int32 var_131 = 1;
    wp::int32 var_132;
    wp::int32* var_133;
    wp::int32 var_134;
    wp::int32 var_135;
    wp::int32 var_136;
    wp::int32 var_137;
    wp::float32* var_138;
    wp::float32 var_139;
    wp::float32 var_140;
    wp::float32 var_141;
    wp::float32 var_142;
    wp::float32* var_143;
    const wp::int32 var_144 = 1;
    wp::int32 var_145;
    wp::int32* var_146;
    wp::int32 var_147;
    wp::int32 var_148;
    wp::int32 var_149;
    wp::int32 var_150;
    const wp::int32 var_151 = 1;
    wp::int32 var_152;
    wp::float32* var_153;
    wp::float32 var_154;
    wp::float32 var_155;
    wp::float32 var_156;
    wp::float32 var_157;
    wp::float32* var_158;
    wp::float32 var_159;
    wp::float32 var_160;
    wp::float32 var_161;
    wp::float32 var_162;
    wp::float32 var_163;
    wp::float32* var_164;
    wp::float32 var_165;
    wp::float32 var_166;
    wp::float32 var_167;
    wp::float32 var_168;
    wp::float32 var_169;
    bool var_170;
    wp::vec_t<3, wp::float32> var_171;
    const wp::float32 var_172 = 0.0;
    wp::float32 var_173;
    wp::vec_t<3, wp::float32> var_174;
    wp::float32 var_175;
    wp::vec_t<3, wp::float32> var_176;
    wp::vec_t<3, wp::float32> var_177;
    wp::float32 var_178;
    wp::vec_t<3, wp::float32> var_179;
    const wp::float32 var_180 = 0.0;
    wp::float32 var_181;
    wp::vec_t<3, wp::float32> var_182;
    wp::vec_t<3, wp::float32> var_183;
    wp::vec_t<3, wp::float32> var_184;
    wp::vec_t<3, wp::float32> var_185;
    wp::vec_t<3, wp::float32> var_186;
    wp::vec_t<3, wp::float32> var_187;
    wp::vec_t<3, wp::float32> var_188;
    wp::float32 var_189;
    //---------
    // forward
    // def _heightfield_surface_query(                                                        <L 172>
    // if hfd.nrow <= 1 or hfd.ncol <= 1:                                                     <L 183>
    var_1 = &((var_hfd).nrow);
    var_4 = wp::load(var_1);
    var_3 = (var_4 <= var_2);
    var_0 = var_3;
    if (!var_0) {
        var_5 = &((var_hfd).ncol);
        var_8 = wp::load(var_5);
        var_7 = (var_8 <= var_6);
        var_0 = var_0 || var_7;
    }
    if (var_0) {
        // return 1.0e10, wp.vec3(0.0, 0.0, 1.0), 0.0                                         <L 184>
        var_13 = wp::vec_t<3, wp::float32>(var_10, var_11, var_12);
        ret_0 = var_9;
        ret_1 = var_13;
        ret_2 = var_14;
        return;
    }
    // dx = 2.0 * hfd.hx / wp.float32(hfd.ncol - 1)                                           <L 186>
    var_16 = &((var_hfd).hx);
    var_18 = wp::load(var_16);
    var_17 = wp::mul(var_15, var_18);
    var_19 = &((var_hfd).ncol);
    var_22 = wp::load(var_19);
    var_21 = wp::sub(var_22, var_20);
    var_23 = wp::float32(var_21);
    var_24 = wp::div(var_17, var_23);
    // dy = 2.0 * hfd.hy / wp.float32(hfd.nrow - 1)                                           <L 187>
    var_26 = &((var_hfd).hy);
    var_28 = wp::load(var_26);
    var_27 = wp::mul(var_25, var_28);
    var_29 = &((var_hfd).nrow);
    var_32 = wp::load(var_29);
    var_31 = wp::sub(var_32, var_30);
    var_33 = wp::float32(var_31);
    var_34 = wp::div(var_27, var_33);
    // z_range = hfd.max_z - hfd.min_z                                                        <L 188>
    var_35 = &((var_hfd).max_z);
    var_36 = &((var_hfd).min_z);
    var_38 = wp::load(var_35);
    var_39 = wp::load(var_36);
    var_37 = wp::sub(var_38, var_39);
    // cx = wp.clamp(pos[0], -hfd.hx, hfd.hx)                                                 <L 191>
    var_41 = wp::extract(var_pos, var_40);
    var_42 = &((var_hfd).hx);
    var_44 = wp::load(var_42);
    var_43 = wp::neg(var_44);
    var_45 = &((var_hfd).hx);
    var_47 = wp::load(var_45);
    var_46 = wp::clamp(var_41, var_43, var_47);
    // cy = wp.clamp(pos[1], -hfd.hy, hfd.hy)                                                 <L 192>
    var_49 = wp::extract(var_pos, var_48);
    var_50 = &((var_hfd).hy);
    var_52 = wp::load(var_50);
    var_51 = wp::neg(var_52);
    var_53 = &((var_hfd).hy);
    var_55 = wp::load(var_53);
    var_54 = wp::clamp(var_49, var_51, var_55);
    // out_x = pos[0] - cx                                                                    <L 193>
    var_57 = wp::extract(var_pos, var_56);
    var_58 = wp::sub(var_57, var_46);
    // out_y = pos[1] - cy                                                                    <L 194>
    var_60 = wp::extract(var_pos, var_59);
    var_61 = wp::sub(var_60, var_54);
    // lateral_dist_sq = out_x * out_x + out_y * out_y                                        <L 195>
    var_62 = wp::mul(var_58, var_58);
    var_63 = wp::mul(var_61, var_61);
    var_64 = wp::add(var_62, var_63);
    // col_f = (cx + hfd.hx) / dx                                                             <L 197>
    var_65 = &((var_hfd).hx);
    var_67 = wp::load(var_65);
    var_66 = wp::add(var_46, var_67);
    var_68 = wp::div(var_66, var_24);
    // row_f = (cy + hfd.hy) / dy                                                             <L 198>
    var_69 = &((var_hfd).hy);
    var_71 = wp::load(var_69);
    var_70 = wp::add(var_54, var_71);
    var_72 = wp::div(var_70, var_34);
    // col_f = wp.clamp(col_f, 0.0, wp.float32(hfd.ncol - 1))                                 <L 199>
    var_74 = &((var_hfd).ncol);
    var_77 = wp::load(var_74);
    var_76 = wp::sub(var_77, var_75);
    var_78 = wp::float32(var_76);
    var_79 = wp::clamp(var_68, var_73, var_78);
    // row_f = wp.clamp(row_f, 0.0, wp.float32(hfd.nrow - 1))                                 <L 200>
    var_81 = &((var_hfd).nrow);
    var_84 = wp::load(var_81);
    var_83 = wp::sub(var_84, var_82);
    var_85 = wp::float32(var_83);
    var_86 = wp::clamp(var_72, var_80, var_85);
    // col = wp.min(wp.int32(col_f), hfd.ncol - 2)                                            <L 202>
    var_87 = wp::int32(var_79);
    var_88 = &((var_hfd).ncol);
    var_91 = wp::load(var_88);
    var_90 = wp::sub(var_91, var_89);
    var_92 = wp::min(var_87, var_90);
    // row = wp.min(wp.int32(row_f), hfd.nrow - 2)                                            <L 203>
    var_93 = wp::int32(var_86);
    var_94 = &((var_hfd).nrow);
    var_97 = wp::load(var_94);
    var_96 = wp::sub(var_97, var_95);
    var_98 = wp::min(var_93, var_96);
    // fx = col_f - wp.float32(col)                                                           <L 204>
    var_99 = wp::float32(var_92);
    var_100 = wp::sub(var_79, var_99);
    // fy = row_f - wp.float32(row)                                                           <L 205>
    var_101 = wp::float32(var_98);
    var_102 = wp::sub(var_86, var_101);
    // base = hfd.data_offset                                                                 <L 207>
    var_103 = &((var_hfd).data_offset);
    var_105 = wp::load(var_103);
    var_104 = wp::copy(var_105);
    // h00 = hfd.min_z + elevation_data[base + row * hfd.ncol + col] * z_range                <L 208>
    var_106 = &((var_hfd).min_z);
    var_107 = &((var_hfd).ncol);
    var_109 = wp::load(var_107);
    var_108 = wp::mul(var_98, var_109);
    var_110 = wp::add(var_104, var_108);
    var_111 = wp::add(var_110, var_92);
    var_112 = wp::address(var_elevation_data, var_111);
    var_114 = wp::load(var_112);
    var_113 = wp::mul(var_114, var_37);
    var_116 = wp::load(var_106);
    var_115 = wp::add(var_116, var_113);
    // h10 = hfd.min_z + elevation_data[base + row * hfd.ncol + col + 1] * z_range            <L 209>
    var_117 = &((var_hfd).min_z);
    var_118 = &((var_hfd).ncol);
    var_120 = wp::load(var_118);
    var_119 = wp::mul(var_98, var_120);
    var_121 = wp::add(var_104, var_119);
    var_122 = wp::add(var_121, var_92);
    var_124 = wp::add(var_122, var_123);
    var_125 = wp::address(var_elevation_data, var_124);
    var_127 = wp::load(var_125);
    var_126 = wp::mul(var_127, var_37);
    var_129 = wp::load(var_117);
    var_128 = wp::add(var_129, var_126);
    // h01 = hfd.min_z + elevation_data[base + (row + 1) * hfd.ncol + col] * z_range          <L 210>
    var_130 = &((var_hfd).min_z);
    var_132 = wp::add(var_98, var_131);
    var_133 = &((var_hfd).ncol);
    var_135 = wp::load(var_133);
    var_134 = wp::mul(var_132, var_135);
    var_136 = wp::add(var_104, var_134);
    var_137 = wp::add(var_136, var_92);
    var_138 = wp::address(var_elevation_data, var_137);
    var_140 = wp::load(var_138);
    var_139 = wp::mul(var_140, var_37);
    var_142 = wp::load(var_130);
    var_141 = wp::add(var_142, var_139);
    // h11 = hfd.min_z + elevation_data[base + (row + 1) * hfd.ncol + col + 1] * z_range       <L 211>
    var_143 = &((var_hfd).min_z);
    var_145 = wp::add(var_98, var_144);
    var_146 = &((var_hfd).ncol);
    var_148 = wp::load(var_146);
    var_147 = wp::mul(var_145, var_148);
    var_149 = wp::add(var_104, var_147);
    var_150 = wp::add(var_149, var_92);
    var_152 = wp::add(var_150, var_151);
    var_153 = wp::address(var_elevation_data, var_152);
    var_155 = wp::load(var_153);
    var_154 = wp::mul(var_155, var_37);
    var_157 = wp::load(var_143);
    var_156 = wp::add(var_157, var_154);
    // x0 = -hfd.hx + wp.float32(col) * dx                                                    <L 213>
    var_158 = &((var_hfd).hx);
    var_160 = wp::load(var_158);
    var_159 = wp::neg(var_160);
    var_161 = wp::float32(var_92);
    var_162 = wp::mul(var_161, var_24);
    var_163 = wp::add(var_159, var_162);
    // y0 = -hfd.hy + wp.float32(row) * dy                                                    <L 214>
    var_164 = &((var_hfd).hy);
    var_166 = wp::load(var_164);
    var_165 = wp::neg(var_166);
    var_167 = wp::float32(var_98);
    var_168 = wp::mul(var_167, var_34);
    var_169 = wp::add(var_165, var_168);
    // if fx >= fy:                                                                           <L 216>
    var_170 = (var_100 >= var_102);
    if (var_170) {
        // v0 = wp.vec3(x0, y0, h00)                                                          <L 217>
        var_171 = wp::vec_t<3, wp::float32>(var_163, var_169, var_115);
        // e1 = wp.vec3(dx, 0.0, h10 - h00)                                                   <L 218>
        var_173 = wp::sub(var_128, var_115);
        var_174 = wp::vec_t<3, wp::float32>(var_24, var_172, var_173);
        // e2 = wp.vec3(dx, dy, h11 - h00)                                                    <L 219>
        var_175 = wp::sub(var_156, var_115);
        var_176 = wp::vec_t<3, wp::float32>(var_24, var_34, var_175);
    }
    if (!var_170) {
        // v0 = wp.vec3(x0, y0, h00)                                                          <L 221>
        var_177 = wp::vec_t<3, wp::float32>(var_163, var_169, var_115);
        // e1 = wp.vec3(dx, dy, h11 - h00)                                                    <L 222>
        var_178 = wp::sub(var_156, var_115);
        var_179 = wp::vec_t<3, wp::float32>(var_24, var_34, var_178);
        // e2 = wp.vec3(0.0, dy, h01 - h00)                                                   <L 223>
        var_181 = wp::sub(var_141, var_115);
        var_182 = wp::vec_t<3, wp::float32>(var_180, var_34, var_181);
    }
    var_183 = wp::where(var_170, var_171, var_177);
    var_184 = wp::where(var_170, var_174, var_179);
    var_185 = wp::where(var_170, var_176, var_182);
    // normal = wp.normalize(wp.cross(e1, e2))                                                <L 225>
    var_186 = wp::cross(var_184, var_185);
    var_187 = wp::normalize(var_186);
    // d_plane = wp.dot(pos - v0, normal)                                                     <L 226>
    var_188 = wp::sub(var_pos, var_183);
    var_189 = wp::dot(var_188, var_187);
    // return d_plane, normal, lateral_dist_sq                                                <L 227>
    ret_0 = var_189;
    ret_1 = var_187;
    ret_2 = var_64;
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/utils/heightfield.py:230
static CUDA_CALLABLE wp::float32 sample_sdf_heightfield_0(
    HeightfieldData_f2b8d59a var_hfd,
    wp::array_t<wp::float32> var_elevation_data,
    wp::vec_t<3, wp::float32> var_pos)
{
    //---------
    // primal vars
    wp::float32 var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::float32 var_2;
    const wp::float32 var_3 = 0.0;
    bool var_4;
    wp::float32 var_5;
    wp::float32 var_6;
    wp::float32 var_7;
    //---------
    // forward
    // def sample_sdf_heightfield(                                                            <L 231>
    // d_plane, _normal, lateral_dist_sq = _heightfield_surface_query(hfd, elevation_data, pos)       <L 248>
    _heightfield_surface_query_0(var_hfd, var_elevation_data, var_pos, var_0, var_1, var_2);
    // if lateral_dist_sq > 0.0:                                                              <L 249>
    var_4 = (var_2 > var_3);
    if (var_4) {
        // return wp.sqrt(lateral_dist_sq + d_plane * d_plane)                                <L 250>
        var_5 = wp::mul(var_0, var_0);
        var_6 = wp::add(var_2, var_5);
        var_7 = wp::sqrt(var_6);
        return var_7;
    }
    // return d_plane                                                                         <L 251>
    return var_0;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/kernels.py:966
static CUDA_CALLABLE wp::mesh_query_point_t mesh_query_point_sign_0(
    wp::uint64 var_mesh,
    wp::vec_t<3, wp::float32> var_point,
    wp::float32 var_max_dist,
    wp::int32 var_sign_method)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 1;
    bool var_1;
    wp::mesh_query_point_t var_2;
    const wp::int32 var_3 = 1;
    const wp::float32 var_4 = 0.1;
    wp::mesh_query_point_t var_5;
    const wp::float32 var_6 = 0.001;
    //---------
    // forward
    // def mesh_query_point_sign(mesh: wp.uint64, point: wp.vec3, max_dist: float, sign_method: int):       <L 967>
    // if sign_method == MeshSignMethod.PARITY:                                               <L 969>
    var_1 = (var_sign_method == var_0);
    if (var_1) {
        // return wp.mesh_query_point_sign_parity(mesh, point, max_dist)                      <L 970>
        var_2 = wp::mesh_query_point_sign_parity(var_mesh, var_point, var_max_dist, var_3, var_4);
        return var_2;
    }
    // return wp.mesh_query_point_sign_normal(mesh, point, max_dist)                          <L 971>
    var_5 = wp::mesh_query_point_sign_normal(var_mesh, var_point, var_max_dist, var_6);
    return var_5;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:185
static CUDA_CALLABLE wp::float32 sample_sdf_using_mesh_0(
    wp::uint64 var_mesh_id,
    wp::vec_t<3, wp::float32> var_world_pos,
    wp::float32 var_max_dist,
    wp::int32 var_sign_method)
{
    //---------
    // primal vars
    wp::mesh_query_point_t var_0;
    bool* var_1;
    bool var_2;
    wp::int32* var_3;
    wp::float32* var_4;
    wp::float32* var_5;
    wp::vec_t<3, wp::float32> var_6;
    wp::int32 var_7;
    wp::float32 var_8;
    wp::float32 var_9;
    wp::vec_t<3, wp::float32> var_10;
    wp::float32 var_11;
    wp::float32* var_12;
    wp::float32 var_13;
    wp::float32 var_14;
    bool var_15;
    //---------
    // forward
    // def sample_sdf_using_mesh(                                                             <L 186>
    // res = mesh_query_point_sign(mesh_id, world_pos, max_dist, sign_method)                 <L 208>
    var_0 = mesh_query_point_sign_0(var_mesh_id, var_world_pos, var_max_dist, var_sign_method);
    // if res.result:                                                                         <L 210>
    var_1 = &((var_0).result);
    var_2 = wp::load(var_1);
    if (var_2) {
        // closest = wp.mesh_eval_position(mesh_id, res.face, res.u, res.v)                   <L 211>
        var_3 = &((var_0).face);
        var_4 = &((var_0).u);
        var_5 = &((var_0).v);
        var_7 = wp::load(var_3);
        var_8 = wp::load(var_4);
        var_9 = wp::load(var_5);
        var_6 = wp::mesh_eval_position(var_mesh_id, var_7, var_8, var_9);
        // return wp.length(world_pos - closest) * res.sign                                   <L 212>
        var_10 = wp::sub(var_world_pos, var_6);
        var_11 = wp::length(var_10);
        var_12 = &((var_0).sign);
        var_14 = wp::load(var_12);
        var_13 = wp::mul(var_11, var_14);
        return var_13;
    }
    var_15 = wp::load(var_1);
    // return max_dist                                                                        <L 214>
    return var_max_dist;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:785
static CUDA_CALLABLE _CellLookup_6716dbae _locate_cell_coords_0(
    TextureSDFData_93572308 var_sdf,
    wp::vec_t<3, wp::float32> var_f)
{
    //---------
    // primal vars
    wp::texture3d_t* var_0;
    wp::int32* var_1;
    const wp::int32 var_2 = 1;
    wp::int32 var_3;
    wp::int32 var_4;
    wp::texture3d_t* var_5;
    wp::int32* var_6;
    const wp::int32 var_7 = 1;
    wp::int32 var_8;
    wp::int32 var_9;
    wp::texture3d_t* var_10;
    wp::int32* var_11;
    const wp::int32 var_12 = 1;
    wp::int32 var_13;
    wp::int32 var_14;
    wp::float32 var_15;
    wp::float32* var_16;
    wp::float32 var_17;
    wp::float32 var_18;
    wp::float32 var_19;
    wp::float32* var_20;
    wp::float32 var_21;
    wp::float32 var_22;
    wp::float32 var_23;
    wp::float32* var_24;
    wp::float32 var_25;
    wp::float32 var_26;
    const wp::int32 var_27 = 0;
    wp::float32 var_28;
    const wp::float32 var_29 = 0.0;
    wp::float32 var_30;
    const wp::int32 var_31 = 1;
    wp::float32 var_32;
    const wp::float32 var_33 = 0.0;
    wp::float32 var_34;
    const wp::int32 var_35 = 2;
    wp::float32 var_36;
    const wp::float32 var_37 = 0.0;
    wp::float32 var_38;
    wp::int32 var_39;
    wp::int32 var_40;
    wp::int32 var_41;
    wp::float32 var_42;
    wp::int32 var_43;
    const wp::int32 var_44 = 0;
    const wp::int32 var_45 = 1;
    wp::int32 var_46;
    wp::int32 var_47;
    wp::float32 var_48;
    wp::int32 var_49;
    const wp::int32 var_50 = 0;
    const wp::int32 var_51 = 1;
    wp::int32 var_52;
    wp::int32 var_53;
    wp::float32 var_54;
    wp::int32 var_55;
    const wp::int32 var_56 = 0;
    const wp::int32 var_57 = 1;
    wp::int32 var_58;
    wp::int32 var_59;
    wp::float32 var_60;
    wp::float32 var_61;
    wp::float32 var_62;
    wp::float32 var_63;
    wp::float32 var_64;
    wp::float32 var_65;
    wp::float32 var_66;
    wp::float32* var_67;
    wp::float32 var_68;
    wp::float32 var_69;
    wp::int32 var_70;
    const wp::int32 var_71 = 0;
    const wp::int32 var_72 = 1;
    wp::int32 var_73;
    wp::int32 var_74;
    wp::float32 var_75;
    wp::float32* var_76;
    wp::float32 var_77;
    wp::float32 var_78;
    wp::int32 var_79;
    const wp::int32 var_80 = 0;
    const wp::int32 var_81 = 1;
    wp::int32 var_82;
    wp::int32 var_83;
    wp::float32 var_84;
    wp::float32* var_85;
    wp::float32 var_86;
    wp::float32 var_87;
    wp::int32 var_88;
    const wp::int32 var_89 = 0;
    const wp::int32 var_90 = 1;
    wp::int32 var_91;
    wp::int32 var_92;
    _CellLookup_6716dbae var_93;
    const wp::uint32 var_94 = 4294967295u;
    //---------
    // forward
    // def _locate_cell_coords(sdf: TextureSDFData, f: wp.vec3) -> _CellLookup:               <L 786>
    // coarse_x = sdf.coarse_texture.width - 1                                                <L 791>
    var_0 = &((var_sdf).coarse_texture);
    var_1 = &(((var_sdf).coarse_texture).width);
    var_4 = wp::load(var_1);
    var_3 = wp::sub(var_4, var_2);
    // coarse_y = sdf.coarse_texture.height - 1                                               <L 792>
    var_5 = &((var_sdf).coarse_texture);
    var_6 = &(((var_sdf).coarse_texture).height);
    var_9 = wp::load(var_6);
    var_8 = wp::sub(var_9, var_7);
    // coarse_z = sdf.coarse_texture.depth - 1                                                <L 793>
    var_10 = &((var_sdf).coarse_texture);
    var_11 = &(((var_sdf).coarse_texture).depth);
    var_14 = wp::load(var_11);
    var_13 = wp::sub(var_14, var_12);
    // fine_verts_x = float(coarse_x) * sdf.subgrid_size_f                                    <L 795>
    var_15 = wp::float(var_3);
    var_16 = &((var_sdf).subgrid_size_f);
    var_18 = wp::load(var_16);
    var_17 = wp::mul(var_15, var_18);
    // fine_verts_y = float(coarse_y) * sdf.subgrid_size_f                                    <L 796>
    var_19 = wp::float(var_8);
    var_20 = &((var_sdf).subgrid_size_f);
    var_22 = wp::load(var_20);
    var_21 = wp::mul(var_19, var_22);
    // fine_verts_z = float(coarse_z) * sdf.subgrid_size_f                                    <L 797>
    var_23 = wp::float(var_13);
    var_24 = &((var_sdf).subgrid_size_f);
    var_26 = wp::load(var_24);
    var_25 = wp::mul(var_23, var_26);
    // fx = wp.clamp(f[0], 0.0, fine_verts_x)                                                 <L 799>
    var_28 = wp::extract(var_f, var_27);
    var_30 = wp::clamp(var_28, var_29, var_17);
    // fy = wp.clamp(f[1], 0.0, fine_verts_y)                                                 <L 800>
    var_32 = wp::extract(var_f, var_31);
    var_34 = wp::clamp(var_32, var_33, var_21);
    // fz = wp.clamp(f[2], 0.0, fine_verts_z)                                                 <L 801>
    var_36 = wp::extract(var_f, var_35);
    var_38 = wp::clamp(var_36, var_37, var_25);
    // num_fine_cells_x = int(fine_verts_x)                                                   <L 803>
    var_39 = wp::int(var_17);
    // num_fine_cells_y = int(fine_verts_y)                                                   <L 804>
    var_40 = wp::int(var_21);
    // num_fine_cells_z = int(fine_verts_z)                                                   <L 805>
    var_41 = wp::int(var_25);
    // ix = wp.clamp(int(wp.floor(fx)), 0, num_fine_cells_x - 1)                              <L 806>
    var_42 = wp::floor(var_30);
    var_43 = wp::int(var_42);
    var_46 = wp::sub(var_39, var_45);
    var_47 = wp::clamp(var_43, var_44, var_46);
    // iy = wp.clamp(int(wp.floor(fy)), 0, num_fine_cells_y - 1)                              <L 807>
    var_48 = wp::floor(var_34);
    var_49 = wp::int(var_48);
    var_52 = wp::sub(var_40, var_51);
    var_53 = wp::clamp(var_49, var_50, var_52);
    // iz = wp.clamp(int(wp.floor(fz)), 0, num_fine_cells_z - 1)                              <L 808>
    var_54 = wp::floor(var_38);
    var_55 = wp::int(var_54);
    var_58 = wp::sub(var_41, var_57);
    var_59 = wp::clamp(var_55, var_56, var_58);
    // tx = fx - float(ix)                                                                    <L 809>
    var_60 = wp::float(var_47);
    var_61 = wp::sub(var_30, var_60);
    // ty = fy - float(iy)                                                                    <L 810>
    var_62 = wp::float(var_53);
    var_63 = wp::sub(var_34, var_62);
    // tz = fz - float(iz)                                                                    <L 811>
    var_64 = wp::float(var_59);
    var_65 = wp::sub(var_38, var_64);
    // x_base = wp.clamp(int(float(ix) * sdf.fine_to_coarse), 0, coarse_x - 1)                <L 813>
    var_66 = wp::float(var_47);
    var_67 = &((var_sdf).fine_to_coarse);
    var_69 = wp::load(var_67);
    var_68 = wp::mul(var_66, var_69);
    var_70 = wp::int(var_68);
    var_73 = wp::sub(var_3, var_72);
    var_74 = wp::clamp(var_70, var_71, var_73);
    // y_base = wp.clamp(int(float(iy) * sdf.fine_to_coarse), 0, coarse_y - 1)                <L 814>
    var_75 = wp::float(var_53);
    var_76 = &((var_sdf).fine_to_coarse);
    var_78 = wp::load(var_76);
    var_77 = wp::mul(var_75, var_78);
    var_79 = wp::int(var_77);
    var_82 = wp::sub(var_8, var_81);
    var_83 = wp::clamp(var_79, var_80, var_82);
    // z_base = wp.clamp(int(float(iz) * sdf.fine_to_coarse), 0, coarse_z - 1)                <L 815>
    var_84 = wp::float(var_59);
    var_85 = &((var_sdf).fine_to_coarse);
    var_87 = wp::load(var_85);
    var_86 = wp::mul(var_84, var_87);
    var_88 = wp::int(var_86);
    var_91 = wp::sub(var_13, var_90);
    var_92 = wp::clamp(var_88, var_89, var_91);
    // loc = _CellLookup()                                                                    <L 817>
    var_93 = _CellLookup_6716dbae();
    // loc.ix = ix                                                                            <L 818>
    var_93.ix = var_47;
    // loc.iy = iy                                                                            <L 819>
    var_93.iy = var_53;
    // loc.iz = iz                                                                            <L 820>
    var_93.iz = var_59;
    // loc.tx = tx                                                                            <L 821>
    var_93.tx = var_61;
    // loc.ty = ty                                                                            <L 822>
    var_93.ty = var_63;
    // loc.tz = tz                                                                            <L 823>
    var_93.tz = var_65;
    // loc.x_base = x_base                                                                    <L 824>
    var_93.x_base = var_74;
    // loc.y_base = y_base                                                                    <L 825>
    var_93.y_base = var_83;
    // loc.z_base = z_base                                                                    <L 826>
    var_93.z_base = var_92;
    // loc.start_slot = SLOT_EMPTY                                                            <L 827>
    var_93.start_slot = var_94;
    // return loc                                                                             <L 828>
    return var_93;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:831
static CUDA_CALLABLE _CellLookup_6716dbae _locate_cell_0(
    TextureSDFData_93572308 var_sdf,
    wp::vec_t<3, wp::float32> var_f)
{
    //---------
    // primal vars
    _CellLookup_6716dbae var_0;
    wp::array_t<wp::uint32>* var_1;
    wp::int32* var_2;
    wp::int32* var_3;
    wp::int32* var_4;
    wp::uint32* var_5;
    wp::array_t<wp::uint32> var_6;
    wp::int32 var_7;
    wp::int32 var_8;
    wp::int32 var_9;
    wp::uint32 var_10;
    wp::uint32 var_11;
    //---------
    // forward
    // def _locate_cell(sdf: TextureSDFData, f: wp.vec3) -> _CellLookup:                      <L 832>
    // loc = _locate_cell_coords(sdf, f)                                                      <L 834>
    var_0 = _locate_cell_coords_0(var_sdf, var_f);
    // loc.start_slot = sdf.subgrid_start_slots[loc.x_base, loc.y_base, loc.z_base]           <L 835>
    var_1 = &((var_sdf).subgrid_start_slots);
    var_2 = &((var_0).x_base);
    var_3 = &((var_0).y_base);
    var_4 = &((var_0).z_base);
    var_6 = wp::load(var_1);
    var_7 = wp::load(var_2);
    var_8 = wp::load(var_3);
    var_9 = wp::load(var_4);
    var_5 = wp::address(var_6, var_7, var_8, var_9);
    var_11 = wp::load(var_5);
    var_10 = wp::copy(var_11);
    var_0.start_slot = var_10;
    // return loc                                                                             <L 836>
    return var_0;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:753
static CUDA_CALLABLE wp::float32 _texture_sample_sdf_x0_0(
    wp::texture3d_t var_texture,
    wp::vec_t<3, wp::float32> var_uvw,
    bool var_paired_samples)
{
    //---------
    // primal vars
    wp::vec_t<2, wp::float32> var_0;
    const wp::float32 var_1 = -1.0;
    const wp::int32 var_2 = 0;
    wp::float32 var_3;
    wp::float32 var_4;
    const wp::float32 var_5 = -1.0;
    //---------
    // forward
    // def _texture_sample_sdf_x0(texture: wp.Texture3D, uvw: wp.vec3f, paired_samples: bool) -> float:       <L 754>
    // if paired_samples:                                                                     <L 756>
    if (var_paired_samples) {
        // return wp.texture_sample(texture, uvw, dtype=wp.vec2)[0]                           <L 757>
        var_0 = wp::texture_sample<wp::vec_t<2, wp::float32>>(var_texture, var_uvw, var_1);
        var_3 = wp::extract(var_0, var_2);
        return var_3;
    }
    // return wp.texture_sample(texture, uvw, dtype=float)                                    <L 758>
    var_4 = wp::texture_sample<float>(var_texture, var_uvw, var_5);
    return var_4;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:1414
static CUDA_CALLABLE wp::float32 _texture_sample_sdf_hw_clamped_variant_0(
    TextureSDFData_93572308 var_sdf,
    wp::vec_t<3, wp::float32> var_clamped,
    wp::float32 var_diff_mag,
    bool var_paired_samples)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32>* var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::vec_t<3, wp::float32>* var_3;
    wp::vec_t<3, wp::float32> var_4;
    wp::vec_t<3, wp::float32> var_5;
    _CellLookup_6716dbae var_6;
    const wp::float32 var_7 = 0.0;
    wp::float32 var_8;
    wp::uint32* var_9;
    const wp::uint32 var_10 = 4294967294u;
    bool var_11;
    wp::uint32 var_12;
    wp::int32* var_13;
    wp::float32 var_14;
    wp::int32 var_15;
    wp::int32* var_16;
    wp::float32 var_17;
    wp::int32 var_18;
    wp::int32* var_19;
    wp::float32 var_20;
    wp::int32 var_21;
    wp::int32* var_22;
    wp::float32 var_23;
    wp::int32 var_24;
    wp::float32* var_25;
    wp::float32 var_26;
    wp::float32 var_27;
    wp::int32* var_28;
    wp::float32 var_29;
    wp::int32 var_30;
    wp::float32* var_31;
    wp::float32 var_32;
    wp::float32 var_33;
    wp::int32* var_34;
    wp::float32 var_35;
    wp::int32 var_36;
    wp::float32* var_37;
    wp::float32 var_38;
    wp::float32 var_39;
    wp::vec_t<3, wp::float32> var_40;
    wp::float32* var_41;
    wp::vec_t<3, wp::float32> var_42;
    wp::float32 var_43;
    wp::texture3d_t* var_44;
    const wp::int32 var_45 = 0;
    wp::float32 var_46;
    wp::float32 var_47;
    wp::float32 var_48;
    const wp::float32 var_49 = 0.5;
    wp::float32 var_50;
    const wp::int32 var_51 = 1;
    wp::float32 var_52;
    wp::float32 var_53;
    wp::float32 var_54;
    const wp::float32 var_55 = 0.5;
    wp::float32 var_56;
    const wp::int32 var_57 = 2;
    wp::float32 var_58;
    wp::float32 var_59;
    wp::float32 var_60;
    const wp::float32 var_61 = 0.5;
    wp::float32 var_62;
    wp::vec_t<3, wp::float32> var_63;
    wp::float32 var_64;
    wp::texture3d_t var_65;
    wp::uint32* var_66;
    const wp::int32 var_67 = 1023;
    wp::uint32 var_68;
    wp::uint32 var_69;
    wp::uint32 var_70;
    wp::float32 var_71;
    wp::uint32* var_72;
    const wp::int32 var_73 = 10;
    wp::uint32 var_74;
    wp::uint32 var_75;
    wp::uint32 var_76;
    const wp::int32 var_77 = 1023;
    wp::uint32 var_78;
    wp::uint32 var_79;
    wp::float32 var_80;
    wp::uint32* var_81;
    const wp::int32 var_82 = 20;
    wp::uint32 var_83;
    wp::uint32 var_84;
    wp::uint32 var_85;
    const wp::int32 var_86 = 1023;
    wp::uint32 var_87;
    wp::uint32 var_88;
    wp::float32 var_89;
    wp::int32* var_90;
    wp::float32 var_91;
    wp::int32 var_92;
    wp::int32* var_93;
    wp::float32 var_94;
    wp::int32 var_95;
    wp::float32* var_96;
    wp::float32 var_97;
    wp::float32 var_98;
    wp::float32 var_99;
    wp::int32* var_100;
    wp::float32 var_101;
    wp::int32 var_102;
    wp::int32* var_103;
    wp::float32 var_104;
    wp::int32 var_105;
    wp::float32* var_106;
    wp::float32 var_107;
    wp::float32 var_108;
    wp::float32 var_109;
    wp::int32* var_110;
    wp::float32 var_111;
    wp::int32 var_112;
    wp::int32* var_113;
    wp::float32 var_114;
    wp::int32 var_115;
    wp::float32* var_116;
    wp::float32 var_117;
    wp::float32 var_118;
    wp::float32 var_119;
    wp::float32* var_120;
    wp::float32 var_121;
    wp::float32 var_122;
    wp::float32 var_123;
    const wp::float32 var_124 = 0.5;
    wp::float32 var_125;
    wp::float32* var_126;
    wp::float32 var_127;
    wp::float32 var_128;
    wp::float32 var_129;
    const wp::float32 var_130 = 0.5;
    wp::float32 var_131;
    wp::float32* var_132;
    wp::float32 var_133;
    wp::float32 var_134;
    wp::float32 var_135;
    const wp::float32 var_136 = 0.5;
    wp::float32 var_137;
    wp::texture3d_t* var_138;
    wp::float32* var_139;
    wp::float32 var_140;
    wp::float32 var_141;
    wp::float32* var_142;
    wp::float32 var_143;
    wp::float32 var_144;
    wp::float32* var_145;
    wp::float32 var_146;
    wp::float32 var_147;
    wp::vec_t<3, wp::float32> var_148;
    wp::float32 var_149;
    wp::texture3d_t var_150;
    wp::float32* var_151;
    wp::float32 var_152;
    wp::float32 var_153;
    wp::float32* var_154;
    wp::float32 var_155;
    wp::float32 var_156;
    wp::float32 var_157;
    wp::float32 var_158;
    //---------
    // forward
    // def _texture_sample_sdf_hw_clamped_variant(                                            <L 1415>
    // f = wp.cw_mul(clamped - sdf.sdf_box_lower, sdf.inv_sdf_dx)                             <L 1422>
    var_0 = &((var_sdf).sdf_box_lower);
    var_2 = wp::load(var_0);
    var_1 = wp::sub(var_clamped, var_2);
    var_3 = &((var_sdf).inv_sdf_dx);
    var_5 = wp::load(var_3);
    var_4 = wp::cw_mul(var_1, var_5);
    // loc = _locate_cell(sdf, f)                                                             <L 1423>
    var_6 = _locate_cell_0(var_sdf, var_4);
    // sdf_val = float(0.0)                                                                   <L 1425>
    var_8 = wp::float(var_7);
    // if loc.start_slot >= SLOT_LINEAR:                                                      <L 1427>
    var_9 = &((var_6).start_slot);
    var_12 = wp::load(var_9);
    var_11 = (var_12 >= var_10);
    if (var_11) {
        // cx = float(loc.x_base)                                                             <L 1431>
        var_13 = &((var_6).x_base);
        var_15 = wp::load(var_13);
        var_14 = wp::float(var_15);
        // cy = float(loc.y_base)                                                             <L 1432>
        var_16 = &((var_6).y_base);
        var_18 = wp::load(var_16);
        var_17 = wp::float(var_18);
        // cz = float(loc.z_base)                                                             <L 1433>
        var_19 = &((var_6).z_base);
        var_21 = wp::load(var_19);
        var_20 = wp::float(var_21);
        // coarse_f = wp.vec3(float(loc.ix) + loc.tx, float(loc.iy) + loc.ty, float(loc.iz) + loc.tz) * sdf.fine_to_coarse       <L 1434>
        var_22 = &((var_6).ix);
        var_24 = wp::load(var_22);
        var_23 = wp::float(var_24);
        var_25 = &((var_6).tx);
        var_27 = wp::load(var_25);
        var_26 = wp::add(var_23, var_27);
        var_28 = &((var_6).iy);
        var_30 = wp::load(var_28);
        var_29 = wp::float(var_30);
        var_31 = &((var_6).ty);
        var_33 = wp::load(var_31);
        var_32 = wp::add(var_29, var_33);
        var_34 = &((var_6).iz);
        var_36 = wp::load(var_34);
        var_35 = wp::float(var_36);
        var_37 = &((var_6).tz);
        var_39 = wp::load(var_37);
        var_38 = wp::add(var_35, var_39);
        var_40 = wp::vec_t<3, wp::float32>(var_26, var_32, var_38);
        var_41 = &((var_sdf).fine_to_coarse);
        var_43 = wp::load(var_41);
        var_42 = wp::mul(var_40, var_43);
        // sdf_val = _texture_sample_sdf_x0(                                                  <L 1435>
        // sdf.coarse_texture,                                                                <L 1436>
        var_44 = &((var_sdf).coarse_texture);
        // wp.vec3f(                                                                          <L 1437>
        // cx + (coarse_f[0] - cx) + 0.5,                                                     <L 1438>
        var_46 = wp::extract(var_42, var_45);
        var_47 = wp::sub(var_46, var_14);
        var_48 = wp::add(var_14, var_47);
        var_50 = wp::add(var_48, var_49);
        // cy + (coarse_f[1] - cy) + 0.5,                                                     <L 1439>
        var_52 = wp::extract(var_42, var_51);
        var_53 = wp::sub(var_52, var_17);
        var_54 = wp::add(var_17, var_53);
        var_56 = wp::add(var_54, var_55);
        // cz + (coarse_f[2] - cz) + 0.5,                                                     <L 1440>
        var_58 = wp::extract(var_42, var_57);
        var_59 = wp::sub(var_58, var_20);
        var_60 = wp::add(var_20, var_59);
        var_62 = wp::add(var_60, var_61);
        var_63 = wp::vec_t<3, wp::float32>(var_50, var_56, var_62);
        // paired_samples,                                                                    <L 1442>
        var_65 = wp::load(var_44);
        var_64 = _texture_sample_sdf_x0_0(var_65, var_63, var_paired_samples);
    }
    if (!var_11) {
        // block_x = float(loc.start_slot & wp.uint32(0x3FF))                                 <L 1445>
        var_66 = &((var_6).start_slot);
        var_68 = wp::uint32(var_67);
        var_70 = wp::load(var_66);
        var_69 = wp::bit_and(var_70, var_68);
        var_71 = wp::float(var_69);
        // block_y = float((loc.start_slot >> wp.uint32(10)) & wp.uint32(0x3FF))              <L 1446>
        var_72 = &((var_6).start_slot);
        var_74 = wp::uint32(var_73);
        var_76 = wp::load(var_72);
        var_75 = wp::rshift(var_76, var_74);
        var_78 = wp::uint32(var_77);
        var_79 = wp::bit_and(var_75, var_78);
        var_80 = wp::float(var_79);
        // block_z = float((loc.start_slot >> wp.uint32(20)) & wp.uint32(0x3FF))              <L 1447>
        var_81 = &((var_6).start_slot);
        var_83 = wp::uint32(var_82);
        var_85 = wp::load(var_81);
        var_84 = wp::rshift(var_85, var_83);
        var_87 = wp::uint32(var_86);
        var_88 = wp::bit_and(var_84, var_87);
        var_89 = wp::float(var_88);
        // lx = float(loc.ix) - float(loc.x_base) * sdf.subgrid_size_f                        <L 1448>
        var_90 = &((var_6).ix);
        var_92 = wp::load(var_90);
        var_91 = wp::float(var_92);
        var_93 = &((var_6).x_base);
        var_95 = wp::load(var_93);
        var_94 = wp::float(var_95);
        var_96 = &((var_sdf).subgrid_size_f);
        var_98 = wp::load(var_96);
        var_97 = wp::mul(var_94, var_98);
        var_99 = wp::sub(var_91, var_97);
        // ly = float(loc.iy) - float(loc.y_base) * sdf.subgrid_size_f                        <L 1449>
        var_100 = &((var_6).iy);
        var_102 = wp::load(var_100);
        var_101 = wp::float(var_102);
        var_103 = &((var_6).y_base);
        var_105 = wp::load(var_103);
        var_104 = wp::float(var_105);
        var_106 = &((var_sdf).subgrid_size_f);
        var_108 = wp::load(var_106);
        var_107 = wp::mul(var_104, var_108);
        var_109 = wp::sub(var_101, var_107);
        // lz = float(loc.iz) - float(loc.z_base) * sdf.subgrid_size_f                        <L 1450>
        var_110 = &((var_6).iz);
        var_112 = wp::load(var_110);
        var_111 = wp::float(var_112);
        var_113 = &((var_6).z_base);
        var_115 = wp::load(var_113);
        var_114 = wp::float(var_115);
        var_116 = &((var_sdf).subgrid_size_f);
        var_118 = wp::load(var_116);
        var_117 = wp::mul(var_114, var_118);
        var_119 = wp::sub(var_111, var_117);
        // ox = block_x * sdf.subgrid_samples_f + lx + 0.5                                    <L 1451>
        var_120 = &((var_sdf).subgrid_samples_f);
        var_122 = wp::load(var_120);
        var_121 = wp::mul(var_71, var_122);
        var_123 = wp::add(var_121, var_99);
        var_125 = wp::add(var_123, var_124);
        // oy = block_y * sdf.subgrid_samples_f + ly + 0.5                                    <L 1452>
        var_126 = &((var_sdf).subgrid_samples_f);
        var_128 = wp::load(var_126);
        var_127 = wp::mul(var_80, var_128);
        var_129 = wp::add(var_127, var_109);
        var_131 = wp::add(var_129, var_130);
        // oz = block_z * sdf.subgrid_samples_f + lz + 0.5                                    <L 1453>
        var_132 = &((var_sdf).subgrid_samples_f);
        var_134 = wp::load(var_132);
        var_133 = wp::mul(var_89, var_134);
        var_135 = wp::add(var_133, var_119);
        var_137 = wp::add(var_135, var_136);
        // raw = _texture_sample_sdf_x0(                                                      <L 1454>
        // sdf.subgrid_texture,                                                               <L 1455>
        var_138 = &((var_sdf).subgrid_texture);
        // wp.vec3f(ox + loc.tx, oy + loc.ty, oz + loc.tz),                                   <L 1456>
        var_139 = &((var_6).tx);
        var_141 = wp::load(var_139);
        var_140 = wp::add(var_125, var_141);
        var_142 = &((var_6).ty);
        var_144 = wp::load(var_142);
        var_143 = wp::add(var_131, var_144);
        var_145 = &((var_6).tz);
        var_147 = wp::load(var_145);
        var_146 = wp::add(var_137, var_147);
        var_148 = wp::vec_t<3, wp::float32>(var_140, var_143, var_146);
        // paired_samples,                                                                    <L 1457>
        var_150 = wp::load(var_138);
        var_149 = _texture_sample_sdf_x0_0(var_150, var_148, var_paired_samples);
        // sdf_val = raw * sdf.subgrids_sdf_value_range + sdf.subgrids_min_sdf_value          <L 1459>
        var_151 = &((var_sdf).subgrids_sdf_value_range);
        var_153 = wp::load(var_151);
        var_152 = wp::mul(var_149, var_153);
        var_154 = &((var_sdf).subgrids_min_sdf_value);
        var_156 = wp::load(var_154);
        var_155 = wp::add(var_152, var_156);
    }
    var_157 = wp::where(var_11, var_64, var_155);
    // return sdf_val + diff_mag                                                              <L 1461>
    var_158 = wp::add(var_157, var_diff_mag);
    return var_158;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:1464
static CUDA_CALLABLE wp::float32 _texture_sample_sdf_hw_clamped_0(
    TextureSDFData_93572308 var_sdf,
    wp::vec_t<3, wp::float32> var_clamped,
    wp::float32 var_diff_mag)
{
    //---------
    // primal vars
    bool* var_0;
    wp::float32 var_1;
    bool var_2;
    //---------
    // forward
    // def _texture_sample_sdf_hw_clamped(                                                    <L 1465>
    // return _texture_sample_sdf_hw_clamped_variant(sdf, clamped, diff_mag, sdf.paired_samples)       <L 1471>
    var_0 = &((var_sdf).paired_samples);
    var_2 = wp::load(var_0);
    var_1 = _texture_sample_sdf_hw_clamped_variant_0(var_sdf, var_clamped, var_diff_mag, var_2);
    return var_1;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:460
static CUDA_CALLABLE void get_mesh_edge_precomputed_0(
    wp::array_t<wp::vec_t<4, wp::float32>> var_mesh_edge_centers,
    wp::array_t<wp::vec_t<4, wp::float32>> var_mesh_edge_halves,
    wp::vec_t<2, wp::int32> var_edge_range,
    wp::transform_t<wp::float32> var_X_mesh_ws,
    wp::int32 var_edge_idx,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::int32 & ret_2)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    wp::int32 var_1;
    wp::int32 var_2;
    wp::vec_t<4, wp::float32>* var_3;
    wp::vec_t<4, wp::float32> var_4;
    wp::vec_t<4, wp::float32> var_5;
    const wp::int32 var_6 = 0;
    wp::float32 var_7;
    const wp::int32 var_8 = 1;
    wp::float32 var_9;
    const wp::int32 var_10 = 2;
    wp::float32 var_11;
    wp::vec_t<3, wp::float32> var_12;
    wp::vec_t<3, wp::float32> var_13;
    const wp::int32 var_14 = 0;
    wp::int32 var_15;
    wp::int32 var_16;
    wp::vec_t<4, wp::float32>* var_17;
    wp::vec_t<4, wp::float32> var_18;
    wp::vec_t<4, wp::float32> var_19;
    const wp::int32 var_20 = 0;
    wp::float32 var_21;
    const wp::int32 var_22 = 1;
    wp::float32 var_23;
    const wp::int32 var_24 = 2;
    wp::float32 var_25;
    wp::vec_t<3, wp::float32> var_26;
    wp::vec_t<3, wp::float32> var_27;
    wp::vec_t<3, wp::float32> var_28;
    wp::vec_t<3, wp::float32> var_29;
    const wp::int32 var_30 = 3;
    wp::float32 var_31;
    wp::int32 var_32;
    //---------
    // forward
    // def get_mesh_edge_precomputed(                                                         <L 461>
    // packed_center = mesh_edge_centers[edge_range[0] + edge_idx]                            <L 474>
    var_1 = wp::extract(var_edge_range, var_0);
    var_2 = wp::add(var_1, var_edge_idx);
    var_3 = wp::address(var_mesh_edge_centers, var_2);
    var_5 = wp::load(var_3);
    var_4 = wp::copy(var_5);
    // center_local = wp.vec3(packed_center[0], packed_center[1], packed_center[2])           <L 475>
    var_7 = wp::extract(var_4, var_6);
    var_9 = wp::extract(var_4, var_8);
    var_11 = wp::extract(var_4, var_10);
    var_12 = wp::vec_t<3, wp::float32>(var_7, var_9, var_11);
    // center = wp.transform_point(X_mesh_ws, center_local)                                   <L 476>
    var_13 = wp::transform_point(var_X_mesh_ws, var_12);
    // packed_half = mesh_edge_halves[edge_range[0] + edge_idx]                               <L 477>
    var_15 = wp::extract(var_edge_range, var_14);
    var_16 = wp::add(var_15, var_edge_idx);
    var_17 = wp::address(var_mesh_edge_halves, var_16);
    var_19 = wp::load(var_17);
    var_18 = wp::copy(var_19);
    // half_local = wp.vec3(packed_half[0], packed_half[1], packed_half[2])                   <L 478>
    var_21 = wp::extract(var_18, var_20);
    var_23 = wp::extract(var_18, var_22);
    var_25 = wp::extract(var_18, var_24);
    var_26 = wp::vec_t<3, wp::float32>(var_21, var_23, var_25);
    // half = wp.transform_vector(X_mesh_ws, half_local)                                      <L 479>
    var_27 = wp::transform_vector(var_X_mesh_ws, var_26);
    // return center - half, center + half, int(packed_half[3])                               <L 480>
    var_28 = wp::sub(var_13, var_27);
    var_29 = wp::add(var_13, var_27);
    var_31 = wp::extract(var_18, var_30);
    var_32 = wp::int(var_31);
    ret_0 = var_28;
    ret_1 = var_29;
    ret_2 = var_32;
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:486
static CUDA_CALLABLE void _create_mesh_edge_accessor_func__locals__get_edge_from_mesh_func_1(
    wp::uint64 var_mesh_id,
    wp::array_t<wp::vec_t<2, wp::int32>> var_mesh_edge_indices,
    wp::array_t<wp::vec_t<4, wp::float32>> var_mesh_edge_centers,
    wp::array_t<wp::vec_t<4, wp::float32>> var_mesh_edge_halves,
    wp::vec_t<2, wp::int32> var_edge_range,
    wp::vec_t<3, wp::float32> var_mesh_scale,
    wp::transform_t<wp::float32> var_X_mesh_ws,
    wp::int32 var_edge_idx,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::int32 & ret_2)
{
    //---------
    // primal vars
    const bool var_0 = true;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::int32 var_3;
    wp::vec_t<3, wp::float32> var_4;
    wp::vec_t<3, wp::float32> var_5;
    const wp::int32 var_6 = 0;
    //---------
    // forward
    // def get_edge_from_mesh_func(                                                           <L 487>
    // if wp.static(use_precomputed_edge_data):                                               <L 497>
    // return get_mesh_edge_precomputed(mesh_edge_centers, mesh_edge_halves, edge_range, X_mesh_ws, edge_idx)       <L 498>
    get_mesh_edge_precomputed_0(var_mesh_edge_centers, var_mesh_edge_halves, var_edge_range, var_X_mesh_ws, var_edge_idx, var_1, var_2, var_3);
    ret_0 = var_1;
    ret_1 = var_2;
    ret_2 = var_3;
    return;
    // v0, v1 = get_edge_from_mesh(mesh_id, mesh_edge_indices, edge_range, mesh_scale, X_mesh_ws, edge_idx)       <L 499>
    get_edge_from_mesh_0(var_mesh_id, var_mesh_edge_indices, var_edge_range, var_mesh_scale, var_X_mesh_ws, var_edge_idx, var_4, var_5);
    // return v0, v1, 0                                                                       <L 500>
    ret_0 = var_4;
    ret_1 = var_5;
    ret_2 = var_6;
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:68
static CUDA_CALLABLE wp::float32 _sdf_rsqrt_rn_0(
    wp::float32 value)
{

#if defined(__CUDA_ARCH__)
return __frsqrt_rn(value);
#else
return 1.0f / sqrtf(value);
#endif
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:839
static CUDA_CALLABLE void _locate_cell_pair_0(
    TextureSDFData_93572308 var_sdf,
    wp::vec_t<3, wp::float32> var_f0,
    wp::vec_t<3, wp::float32> var_f1,
    _CellLookup_6716dbae & ret_0,
    _CellLookup_6716dbae & ret_1)
{
    //---------
    // primal vars
    _CellLookup_6716dbae var_0;
    _CellLookup_6716dbae var_1;
    wp::array_t<wp::uint32>* var_2;
    wp::int32* var_3;
    wp::int32* var_4;
    wp::int32* var_5;
    wp::uint32* var_6;
    wp::array_t<wp::uint32> var_7;
    wp::int32 var_8;
    wp::int32 var_9;
    wp::int32 var_10;
    wp::uint32 var_11;
    wp::uint32 var_12;
    wp::uint32 var_13;
    bool var_14;
    wp::int32* var_15;
    wp::int32* var_16;
    bool var_17;
    wp::int32 var_18;
    wp::int32 var_19;
    wp::int32* var_20;
    wp::int32* var_21;
    bool var_22;
    wp::int32 var_23;
    wp::int32 var_24;
    wp::int32* var_25;
    wp::int32* var_26;
    bool var_27;
    wp::int32 var_28;
    wp::int32 var_29;
    wp::array_t<wp::uint32>* var_30;
    wp::int32* var_31;
    wp::int32* var_32;
    wp::int32* var_33;
    wp::uint32* var_34;
    wp::array_t<wp::uint32> var_35;
    wp::int32 var_36;
    wp::int32 var_37;
    wp::int32 var_38;
    wp::uint32 var_39;
    wp::uint32 var_40;
    wp::uint32 var_41;
    //---------
    // forward
    // def _locate_cell_pair(sdf: TextureSDFData, f0: wp.vec3, f1: wp.vec3) -> tuple[_CellLookup, _CellLookup]:       <L 840>
    // loc0 = _locate_cell_coords(sdf, f0)                                                    <L 842>
    var_0 = _locate_cell_coords_0(var_sdf, var_f0);
    // loc1 = _locate_cell_coords(sdf, f1)                                                    <L 843>
    var_1 = _locate_cell_coords_0(var_sdf, var_f1);
    // start_slot0 = sdf.subgrid_start_slots[loc0.x_base, loc0.y_base, loc0.z_base]           <L 844>
    var_2 = &((var_sdf).subgrid_start_slots);
    var_3 = &((var_0).x_base);
    var_4 = &((var_0).y_base);
    var_5 = &((var_0).z_base);
    var_7 = wp::load(var_2);
    var_8 = wp::load(var_3);
    var_9 = wp::load(var_4);
    var_10 = wp::load(var_5);
    var_6 = wp::address(var_7, var_8, var_9, var_10);
    var_12 = wp::load(var_6);
    var_11 = wp::copy(var_12);
    // start_slot1 = start_slot0                                                              <L 845>
    var_13 = wp::copy(var_11);
    // if loc0.x_base != loc1.x_base or loc0.y_base != loc1.y_base or loc0.z_base != loc1.z_base:       <L 846>
    var_15 = &((var_0).x_base);
    var_16 = &((var_1).x_base);
    var_18 = wp::load(var_15);
    var_19 = wp::load(var_16);
    var_17 = (var_18 != var_19);
    var_14 = var_17;
    if (!var_14) {
        var_20 = &((var_0).y_base);
        var_21 = &((var_1).y_base);
        var_23 = wp::load(var_20);
        var_24 = wp::load(var_21);
        var_22 = (var_23 != var_24);
        var_14 = var_14 || var_22;
    }
    if (!var_14) {
        var_25 = &((var_0).z_base);
        var_26 = &((var_1).z_base);
        var_28 = wp::load(var_25);
        var_29 = wp::load(var_26);
        var_27 = (var_28 != var_29);
        var_14 = var_14 || var_27;
    }
    if (var_14) {
        // start_slot1 = sdf.subgrid_start_slots[loc1.x_base, loc1.y_base, loc1.z_base]       <L 847>
        var_30 = &((var_sdf).subgrid_start_slots);
        var_31 = &((var_1).x_base);
        var_32 = &((var_1).y_base);
        var_33 = &((var_1).z_base);
        var_35 = wp::load(var_30);
        var_36 = wp::load(var_31);
        var_37 = wp::load(var_32);
        var_38 = wp::load(var_33);
        var_34 = wp::address(var_35, var_36, var_37, var_38);
        var_40 = wp::load(var_34);
        var_39 = wp::copy(var_40);
    }
    var_41 = wp::where(var_14, var_39, var_13);
    // loc0.start_slot = start_slot0                                                          <L 848>
    var_0.start_slot = var_11;
    // loc1.start_slot = start_slot1                                                          <L 849>
    var_1.start_slot = var_41;
    // return loc0, loc1                                                                      <L 850>
    ret_0 = var_0;
    ret_1 = var_1;
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:1252
static CUDA_CALLABLE wp::vec_t<2, wp::float32> _texture_sample_pair_0(
    wp::texture3d_t var_texture0,
    wp::vec_t<3, wp::float32> var_uvw0,
    wp::texture3d_t var_texture1,
    wp::vec_t<3, wp::float32> var_uvw1,
    bool var_paired_samples)
{
    //---------
    // primal vars
    wp::float32 var_0;
    wp::float32 var_1;
    wp::vec_t<2, wp::float32> var_2;
    //---------
    // forward
    // def _texture_sample_pair(                                                              <L 1253>
    // value0 = _texture_sample_sdf_x0(texture0, uvw0, paired_samples)                        <L 1261>
    var_0 = _texture_sample_sdf_x0_0(var_texture0, var_uvw0, var_paired_samples);
    // value1 = _texture_sample_sdf_x0(texture1, uvw1, paired_samples)                        <L 1262>
    var_1 = _texture_sample_sdf_x0_0(var_texture1, var_uvw1, var_paired_samples);
    // return wp.vec2f(value0, value1)                                                        <L 1263>
    var_2 = wp::vec_t<2, wp::float32>(var_0, var_1);
    return var_2;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:1266
static CUDA_CALLABLE wp::vec_t<2, wp::float32> _texture_sample_sdf_hw_clamped_pair_variant_0(
    TextureSDFData_93572308 var_sdf,
    wp::vec_t<3, wp::float32> var_clamped0,
    wp::vec_t<3, wp::float32> var_clamped1,
    wp::float32 var_diff_sq0,
    wp::float32 var_diff_sq1,
    bool var_paired_samples)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32>* var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::vec_t<3, wp::float32>* var_3;
    wp::vec_t<3, wp::float32> var_4;
    wp::vec_t<3, wp::float32> var_5;
    wp::vec_t<3, wp::float32>* var_6;
    wp::vec_t<3, wp::float32> var_7;
    wp::vec_t<3, wp::float32> var_8;
    wp::vec_t<3, wp::float32>* var_9;
    wp::vec_t<3, wp::float32> var_10;
    wp::vec_t<3, wp::float32> var_11;
    _CellLookup_6716dbae var_12;
    _CellLookup_6716dbae var_13;
    wp::texture3d_t* var_14;
    wp::texture3d_t var_15;
    wp::texture3d_t var_16;
    wp::texture3d_t* var_17;
    wp::texture3d_t var_18;
    wp::texture3d_t var_19;
    const wp::float32 var_20 = 0.0;
    wp::vec_t<3, wp::float32> var_21;
    const wp::float32 var_22 = 0.0;
    wp::vec_t<3, wp::float32> var_23;
    wp::uint32* var_24;
    const wp::uint32 var_25 = 4294967294u;
    bool var_26;
    wp::uint32 var_27;
    wp::int32* var_28;
    wp::float32 var_29;
    wp::int32 var_30;
    wp::int32* var_31;
    wp::float32 var_32;
    wp::int32 var_33;
    wp::int32* var_34;
    wp::float32 var_35;
    wp::int32 var_36;
    wp::int32* var_37;
    wp::float32 var_38;
    wp::int32 var_39;
    wp::float32* var_40;
    wp::float32 var_41;
    wp::float32 var_42;
    wp::int32* var_43;
    wp::float32 var_44;
    wp::int32 var_45;
    wp::float32* var_46;
    wp::float32 var_47;
    wp::float32 var_48;
    wp::int32* var_49;
    wp::float32 var_50;
    wp::int32 var_51;
    wp::float32* var_52;
    wp::float32 var_53;
    wp::float32 var_54;
    wp::vec_t<3, wp::float32> var_55;
    wp::float32* var_56;
    wp::vec_t<3, wp::float32> var_57;
    wp::float32 var_58;
    const wp::int32 var_59 = 0;
    wp::float32 var_60;
    wp::float32 var_61;
    wp::float32 var_62;
    const wp::float32 var_63 = 0.5;
    wp::float32 var_64;
    const wp::int32 var_65 = 1;
    wp::float32 var_66;
    wp::float32 var_67;
    wp::float32 var_68;
    const wp::float32 var_69 = 0.5;
    wp::float32 var_70;
    const wp::int32 var_71 = 2;
    wp::float32 var_72;
    wp::float32 var_73;
    wp::float32 var_74;
    const wp::float32 var_75 = 0.5;
    wp::float32 var_76;
    wp::vec_t<3, wp::float32> var_77;
    wp::texture3d_t* var_78;
    wp::texture3d_t var_79;
    wp::texture3d_t var_80;
    wp::uint32* var_81;
    const wp::int32 var_82 = 1023;
    wp::uint32 var_83;
    wp::uint32 var_84;
    wp::uint32 var_85;
    wp::float32 var_86;
    wp::uint32* var_87;
    const wp::int32 var_88 = 10;
    wp::uint32 var_89;
    wp::uint32 var_90;
    wp::uint32 var_91;
    const wp::int32 var_92 = 1023;
    wp::uint32 var_93;
    wp::uint32 var_94;
    wp::float32 var_95;
    wp::uint32* var_96;
    const wp::int32 var_97 = 20;
    wp::uint32 var_98;
    wp::uint32 var_99;
    wp::uint32 var_100;
    const wp::int32 var_101 = 1023;
    wp::uint32 var_102;
    wp::uint32 var_103;
    wp::float32 var_104;
    wp::int32* var_105;
    wp::float32 var_106;
    wp::int32 var_107;
    wp::int32* var_108;
    wp::float32 var_109;
    wp::int32 var_110;
    wp::float32* var_111;
    wp::float32 var_112;
    wp::float32 var_113;
    wp::float32 var_114;
    wp::int32* var_115;
    wp::float32 var_116;
    wp::int32 var_117;
    wp::int32* var_118;
    wp::float32 var_119;
    wp::int32 var_120;
    wp::float32* var_121;
    wp::float32 var_122;
    wp::float32 var_123;
    wp::float32 var_124;
    wp::int32* var_125;
    wp::float32 var_126;
    wp::int32 var_127;
    wp::int32* var_128;
    wp::float32 var_129;
    wp::int32 var_130;
    wp::float32* var_131;
    wp::float32 var_132;
    wp::float32 var_133;
    wp::float32 var_134;
    wp::float32* var_135;
    wp::float32 var_136;
    wp::float32 var_137;
    wp::float32 var_138;
    const wp::float32 var_139 = 0.5;
    wp::float32 var_140;
    wp::float32* var_141;
    wp::float32 var_142;
    wp::float32 var_143;
    wp::float32* var_144;
    wp::float32 var_145;
    wp::float32 var_146;
    wp::float32 var_147;
    const wp::float32 var_148 = 0.5;
    wp::float32 var_149;
    wp::float32* var_150;
    wp::float32 var_151;
    wp::float32 var_152;
    wp::float32* var_153;
    wp::float32 var_154;
    wp::float32 var_155;
    wp::float32 var_156;
    const wp::float32 var_157 = 0.5;
    wp::float32 var_158;
    wp::float32* var_159;
    wp::float32 var_160;
    wp::float32 var_161;
    wp::vec_t<3, wp::float32> var_162;
    wp::texture3d_t var_163;
    wp::vec_t<3, wp::float32> var_164;
    wp::uint32* var_165;
    bool var_166;
    wp::uint32 var_167;
    wp::int32* var_168;
    wp::float32 var_169;
    wp::int32 var_170;
    wp::int32* var_171;
    wp::float32 var_172;
    wp::int32 var_173;
    wp::int32* var_174;
    wp::float32 var_175;
    wp::int32 var_176;
    wp::int32* var_177;
    wp::float32 var_178;
    wp::int32 var_179;
    wp::float32* var_180;
    wp::float32 var_181;
    wp::float32 var_182;
    wp::int32* var_183;
    wp::float32 var_184;
    wp::int32 var_185;
    wp::float32* var_186;
    wp::float32 var_187;
    wp::float32 var_188;
    wp::int32* var_189;
    wp::float32 var_190;
    wp::int32 var_191;
    wp::float32* var_192;
    wp::float32 var_193;
    wp::float32 var_194;
    wp::vec_t<3, wp::float32> var_195;
    wp::float32* var_196;
    wp::vec_t<3, wp::float32> var_197;
    wp::float32 var_198;
    const wp::int32 var_199 = 0;
    wp::float32 var_200;
    wp::float32 var_201;
    wp::float32 var_202;
    const wp::float32 var_203 = 0.5;
    wp::float32 var_204;
    const wp::int32 var_205 = 1;
    wp::float32 var_206;
    wp::float32 var_207;
    wp::float32 var_208;
    const wp::float32 var_209 = 0.5;
    wp::float32 var_210;
    const wp::int32 var_211 = 2;
    wp::float32 var_212;
    wp::float32 var_213;
    wp::float32 var_214;
    const wp::float32 var_215 = 0.5;
    wp::float32 var_216;
    wp::vec_t<3, wp::float32> var_217;
    wp::texture3d_t* var_218;
    wp::texture3d_t var_219;
    wp::texture3d_t var_220;
    wp::uint32* var_221;
    const wp::int32 var_222 = 1023;
    wp::uint32 var_223;
    wp::uint32 var_224;
    wp::uint32 var_225;
    wp::float32 var_226;
    wp::uint32* var_227;
    const wp::int32 var_228 = 10;
    wp::uint32 var_229;
    wp::uint32 var_230;
    wp::uint32 var_231;
    const wp::int32 var_232 = 1023;
    wp::uint32 var_233;
    wp::uint32 var_234;
    wp::float32 var_235;
    wp::uint32* var_236;
    const wp::int32 var_237 = 20;
    wp::uint32 var_238;
    wp::uint32 var_239;
    wp::uint32 var_240;
    const wp::int32 var_241 = 1023;
    wp::uint32 var_242;
    wp::uint32 var_243;
    wp::float32 var_244;
    wp::int32* var_245;
    wp::float32 var_246;
    wp::int32 var_247;
    wp::int32* var_248;
    wp::float32 var_249;
    wp::int32 var_250;
    wp::float32* var_251;
    wp::float32 var_252;
    wp::float32 var_253;
    wp::float32 var_254;
    wp::int32* var_255;
    wp::float32 var_256;
    wp::int32 var_257;
    wp::int32* var_258;
    wp::float32 var_259;
    wp::int32 var_260;
    wp::float32* var_261;
    wp::float32 var_262;
    wp::float32 var_263;
    wp::float32 var_264;
    wp::int32* var_265;
    wp::float32 var_266;
    wp::int32 var_267;
    wp::int32* var_268;
    wp::float32 var_269;
    wp::int32 var_270;
    wp::float32* var_271;
    wp::float32 var_272;
    wp::float32 var_273;
    wp::float32 var_274;
    wp::float32* var_275;
    wp::float32 var_276;
    wp::float32 var_277;
    wp::float32 var_278;
    const wp::float32 var_279 = 0.5;
    wp::float32 var_280;
    wp::float32* var_281;
    wp::float32 var_282;
    wp::float32 var_283;
    wp::float32* var_284;
    wp::float32 var_285;
    wp::float32 var_286;
    wp::float32 var_287;
    const wp::float32 var_288 = 0.5;
    wp::float32 var_289;
    wp::float32* var_290;
    wp::float32 var_291;
    wp::float32 var_292;
    wp::float32* var_293;
    wp::float32 var_294;
    wp::float32 var_295;
    wp::float32 var_296;
    const wp::float32 var_297 = 0.5;
    wp::float32 var_298;
    wp::float32* var_299;
    wp::float32 var_300;
    wp::float32 var_301;
    wp::vec_t<3, wp::float32> var_302;
    wp::texture3d_t var_303;
    wp::vec_t<3, wp::float32> var_304;
    wp::vec_t<2, wp::float32> var_305;
    const wp::float32 var_306 = 0.0;
    wp::float32 var_307;
    const wp::float32 var_308 = 0.0;
    wp::float32 var_309;
    const wp::float32 var_310 = 0.0;
    bool var_311;
    wp::float32 var_312;
    wp::float32 var_313;
    const wp::float32 var_314 = 0.0;
    bool var_315;
    wp::float32 var_316;
    wp::float32 var_317;
    const wp::int32 var_318 = 0;
    wp::float32 var_319;
    const wp::int32 var_320 = 1;
    wp::float32 var_321;
    wp::uint32* var_322;
    bool var_323;
    wp::uint32 var_324;
    wp::float32* var_325;
    wp::float32 var_326;
    wp::float32 var_327;
    wp::float32* var_328;
    wp::float32 var_329;
    wp::float32 var_330;
    wp::float32 var_331;
    wp::uint32* var_332;
    bool var_333;
    wp::uint32 var_334;
    wp::float32* var_335;
    wp::float32 var_336;
    wp::float32 var_337;
    wp::float32* var_338;
    wp::float32 var_339;
    wp::float32 var_340;
    wp::float32 var_341;
    wp::float32 var_342;
    wp::float32 var_343;
    wp::vec_t<2, wp::float32> var_344;
    //---------
    // forward
    // def _texture_sample_sdf_hw_clamped_pair_variant(                                       <L 1267>
    // f0 = wp.cw_mul(clamped0 - sdf.sdf_box_lower, sdf.inv_sdf_dx)                           <L 1277>
    var_0 = &((var_sdf).sdf_box_lower);
    var_2 = wp::load(var_0);
    var_1 = wp::sub(var_clamped0, var_2);
    var_3 = &((var_sdf).inv_sdf_dx);
    var_5 = wp::load(var_3);
    var_4 = wp::cw_mul(var_1, var_5);
    // f1 = wp.cw_mul(clamped1 - sdf.sdf_box_lower, sdf.inv_sdf_dx)                           <L 1278>
    var_6 = &((var_sdf).sdf_box_lower);
    var_8 = wp::load(var_6);
    var_7 = wp::sub(var_clamped1, var_8);
    var_9 = &((var_sdf).inv_sdf_dx);
    var_11 = wp::load(var_9);
    var_10 = wp::cw_mul(var_7, var_11);
    // loc0, loc1 = _locate_cell_pair(sdf, f0, f1)                                            <L 1279>
    _locate_cell_pair_0(var_sdf, var_4, var_10, var_12, var_13);
    // texture0 = sdf.coarse_texture                                                          <L 1281>
    var_14 = &((var_sdf).coarse_texture);
    var_16 = wp::load(var_14);
    var_15 = wp::copy(var_16);
    // texture1 = sdf.coarse_texture                                                          <L 1282>
    var_17 = &((var_sdf).coarse_texture);
    var_19 = wp::load(var_17);
    var_18 = wp::copy(var_19);
    // uvw0 = wp.vec3f(0.0)                                                                   <L 1283>
    var_21 = wp::vec_t<3, wp::float32>(var_20);
    // uvw1 = wp.vec3f(0.0)                                                                   <L 1284>
    var_23 = wp::vec_t<3, wp::float32>(var_22);
    // if loc0.start_slot >= SLOT_LINEAR:                                                     <L 1286>
    var_24 = &((var_12).start_slot);
    var_27 = wp::load(var_24);
    var_26 = (var_27 >= var_25);
    if (var_26) {
        // cx0 = float(loc0.x_base)                                                           <L 1287>
        var_28 = &((var_12).x_base);
        var_30 = wp::load(var_28);
        var_29 = wp::float(var_30);
        // cy0 = float(loc0.y_base)                                                           <L 1288>
        var_31 = &((var_12).y_base);
        var_33 = wp::load(var_31);
        var_32 = wp::float(var_33);
        // cz0 = float(loc0.z_base)                                                           <L 1289>
        var_34 = &((var_12).z_base);
        var_36 = wp::load(var_34);
        var_35 = wp::float(var_36);
        // coarse_f0 = (                                                                      <L 1290>
        // wp.vec3(float(loc0.ix) + loc0.tx, float(loc0.iy) + loc0.ty, float(loc0.iz) + loc0.tz) * sdf.fine_to_coarse       <L 1291>
        var_37 = &((var_12).ix);
        var_39 = wp::load(var_37);
        var_38 = wp::float(var_39);
        var_40 = &((var_12).tx);
        var_42 = wp::load(var_40);
        var_41 = wp::add(var_38, var_42);
        var_43 = &((var_12).iy);
        var_45 = wp::load(var_43);
        var_44 = wp::float(var_45);
        var_46 = &((var_12).ty);
        var_48 = wp::load(var_46);
        var_47 = wp::add(var_44, var_48);
        var_49 = &((var_12).iz);
        var_51 = wp::load(var_49);
        var_50 = wp::float(var_51);
        var_52 = &((var_12).tz);
        var_54 = wp::load(var_52);
        var_53 = wp::add(var_50, var_54);
        var_55 = wp::vec_t<3, wp::float32>(var_41, var_47, var_53);
        var_56 = &((var_sdf).fine_to_coarse);
        var_58 = wp::load(var_56);
        var_57 = wp::mul(var_55, var_58);
        // uvw0 = wp.vec3f(                                                                   <L 1293>
        // cx0 + (coarse_f0[0] - cx0) + 0.5,                                                  <L 1294>
        var_60 = wp::extract(var_57, var_59);
        var_61 = wp::sub(var_60, var_29);
        var_62 = wp::add(var_29, var_61);
        var_64 = wp::add(var_62, var_63);
        // cy0 + (coarse_f0[1] - cy0) + 0.5,                                                  <L 1295>
        var_66 = wp::extract(var_57, var_65);
        var_67 = wp::sub(var_66, var_32);
        var_68 = wp::add(var_32, var_67);
        var_70 = wp::add(var_68, var_69);
        // cz0 + (coarse_f0[2] - cz0) + 0.5,                                                  <L 1296>
        var_72 = wp::extract(var_57, var_71);
        var_73 = wp::sub(var_72, var_35);
        var_74 = wp::add(var_35, var_73);
        var_76 = wp::add(var_74, var_75);
        var_77 = wp::vec_t<3, wp::float32>(var_64, var_70, var_76);
    }
    if (!var_26) {
        // texture0 = sdf.subgrid_texture                                                     <L 1299>
        var_78 = &((var_sdf).subgrid_texture);
        var_80 = wp::load(var_78);
        var_79 = wp::copy(var_80);
        // block_x0 = float(loc0.start_slot & wp.uint32(0x3FF))                               <L 1300>
        var_81 = &((var_12).start_slot);
        var_83 = wp::uint32(var_82);
        var_85 = wp::load(var_81);
        var_84 = wp::bit_and(var_85, var_83);
        var_86 = wp::float(var_84);
        // block_y0 = float((loc0.start_slot >> wp.uint32(10)) & wp.uint32(0x3FF))            <L 1301>
        var_87 = &((var_12).start_slot);
        var_89 = wp::uint32(var_88);
        var_91 = wp::load(var_87);
        var_90 = wp::rshift(var_91, var_89);
        var_93 = wp::uint32(var_92);
        var_94 = wp::bit_and(var_90, var_93);
        var_95 = wp::float(var_94);
        // block_z0 = float((loc0.start_slot >> wp.uint32(20)) & wp.uint32(0x3FF))            <L 1302>
        var_96 = &((var_12).start_slot);
        var_98 = wp::uint32(var_97);
        var_100 = wp::load(var_96);
        var_99 = wp::rshift(var_100, var_98);
        var_102 = wp::uint32(var_101);
        var_103 = wp::bit_and(var_99, var_102);
        var_104 = wp::float(var_103);
        // lx0 = float(loc0.ix) - float(loc0.x_base) * sdf.subgrid_size_f                     <L 1303>
        var_105 = &((var_12).ix);
        var_107 = wp::load(var_105);
        var_106 = wp::float(var_107);
        var_108 = &((var_12).x_base);
        var_110 = wp::load(var_108);
        var_109 = wp::float(var_110);
        var_111 = &((var_sdf).subgrid_size_f);
        var_113 = wp::load(var_111);
        var_112 = wp::mul(var_109, var_113);
        var_114 = wp::sub(var_106, var_112);
        // ly0 = float(loc0.iy) - float(loc0.y_base) * sdf.subgrid_size_f                     <L 1304>
        var_115 = &((var_12).iy);
        var_117 = wp::load(var_115);
        var_116 = wp::float(var_117);
        var_118 = &((var_12).y_base);
        var_120 = wp::load(var_118);
        var_119 = wp::float(var_120);
        var_121 = &((var_sdf).subgrid_size_f);
        var_123 = wp::load(var_121);
        var_122 = wp::mul(var_119, var_123);
        var_124 = wp::sub(var_116, var_122);
        // lz0 = float(loc0.iz) - float(loc0.z_base) * sdf.subgrid_size_f                     <L 1305>
        var_125 = &((var_12).iz);
        var_127 = wp::load(var_125);
        var_126 = wp::float(var_127);
        var_128 = &((var_12).z_base);
        var_130 = wp::load(var_128);
        var_129 = wp::float(var_130);
        var_131 = &((var_sdf).subgrid_size_f);
        var_133 = wp::load(var_131);
        var_132 = wp::mul(var_129, var_133);
        var_134 = wp::sub(var_126, var_132);
        // uvw0 = wp.vec3f(                                                                   <L 1306>
        // block_x0 * sdf.subgrid_samples_f + lx0 + 0.5 + loc0.tx,                            <L 1307>
        var_135 = &((var_sdf).subgrid_samples_f);
        var_137 = wp::load(var_135);
        var_136 = wp::mul(var_86, var_137);
        var_138 = wp::add(var_136, var_114);
        var_140 = wp::add(var_138, var_139);
        var_141 = &((var_12).tx);
        var_143 = wp::load(var_141);
        var_142 = wp::add(var_140, var_143);
        // block_y0 * sdf.subgrid_samples_f + ly0 + 0.5 + loc0.ty,                            <L 1308>
        var_144 = &((var_sdf).subgrid_samples_f);
        var_146 = wp::load(var_144);
        var_145 = wp::mul(var_95, var_146);
        var_147 = wp::add(var_145, var_124);
        var_149 = wp::add(var_147, var_148);
        var_150 = &((var_12).ty);
        var_152 = wp::load(var_150);
        var_151 = wp::add(var_149, var_152);
        // block_z0 * sdf.subgrid_samples_f + lz0 + 0.5 + loc0.tz,                            <L 1309>
        var_153 = &((var_sdf).subgrid_samples_f);
        var_155 = wp::load(var_153);
        var_154 = wp::mul(var_104, var_155);
        var_156 = wp::add(var_154, var_134);
        var_158 = wp::add(var_156, var_157);
        var_159 = &((var_12).tz);
        var_161 = wp::load(var_159);
        var_160 = wp::add(var_158, var_161);
        var_162 = wp::vec_t<3, wp::float32>(var_142, var_151, var_160);
    }
    var_163 = wp::where(var_26, var_15, var_79);
    var_164 = wp::where(var_26, var_77, var_162);
    // if loc1.start_slot >= SLOT_LINEAR:                                                     <L 1312>
    var_165 = &((var_13).start_slot);
    var_167 = wp::load(var_165);
    var_166 = (var_167 >= var_25);
    if (var_166) {
        // cx1 = float(loc1.x_base)                                                           <L 1313>
        var_168 = &((var_13).x_base);
        var_170 = wp::load(var_168);
        var_169 = wp::float(var_170);
        // cy1 = float(loc1.y_base)                                                           <L 1314>
        var_171 = &((var_13).y_base);
        var_173 = wp::load(var_171);
        var_172 = wp::float(var_173);
        // cz1 = float(loc1.z_base)                                                           <L 1315>
        var_174 = &((var_13).z_base);
        var_176 = wp::load(var_174);
        var_175 = wp::float(var_176);
        // coarse_f1 = (                                                                      <L 1316>
        // wp.vec3(float(loc1.ix) + loc1.tx, float(loc1.iy) + loc1.ty, float(loc1.iz) + loc1.tz) * sdf.fine_to_coarse       <L 1317>
        var_177 = &((var_13).ix);
        var_179 = wp::load(var_177);
        var_178 = wp::float(var_179);
        var_180 = &((var_13).tx);
        var_182 = wp::load(var_180);
        var_181 = wp::add(var_178, var_182);
        var_183 = &((var_13).iy);
        var_185 = wp::load(var_183);
        var_184 = wp::float(var_185);
        var_186 = &((var_13).ty);
        var_188 = wp::load(var_186);
        var_187 = wp::add(var_184, var_188);
        var_189 = &((var_13).iz);
        var_191 = wp::load(var_189);
        var_190 = wp::float(var_191);
        var_192 = &((var_13).tz);
        var_194 = wp::load(var_192);
        var_193 = wp::add(var_190, var_194);
        var_195 = wp::vec_t<3, wp::float32>(var_181, var_187, var_193);
        var_196 = &((var_sdf).fine_to_coarse);
        var_198 = wp::load(var_196);
        var_197 = wp::mul(var_195, var_198);
        // uvw1 = wp.vec3f(                                                                   <L 1319>
        // cx1 + (coarse_f1[0] - cx1) + 0.5,                                                  <L 1320>
        var_200 = wp::extract(var_197, var_199);
        var_201 = wp::sub(var_200, var_169);
        var_202 = wp::add(var_169, var_201);
        var_204 = wp::add(var_202, var_203);
        // cy1 + (coarse_f1[1] - cy1) + 0.5,                                                  <L 1321>
        var_206 = wp::extract(var_197, var_205);
        var_207 = wp::sub(var_206, var_172);
        var_208 = wp::add(var_172, var_207);
        var_210 = wp::add(var_208, var_209);
        // cz1 + (coarse_f1[2] - cz1) + 0.5,                                                  <L 1322>
        var_212 = wp::extract(var_197, var_211);
        var_213 = wp::sub(var_212, var_175);
        var_214 = wp::add(var_175, var_213);
        var_216 = wp::add(var_214, var_215);
        var_217 = wp::vec_t<3, wp::float32>(var_204, var_210, var_216);
    }
    if (!var_166) {
        // texture1 = sdf.subgrid_texture                                                     <L 1325>
        var_218 = &((var_sdf).subgrid_texture);
        var_220 = wp::load(var_218);
        var_219 = wp::copy(var_220);
        // block_x1 = float(loc1.start_slot & wp.uint32(0x3FF))                               <L 1326>
        var_221 = &((var_13).start_slot);
        var_223 = wp::uint32(var_222);
        var_225 = wp::load(var_221);
        var_224 = wp::bit_and(var_225, var_223);
        var_226 = wp::float(var_224);
        // block_y1 = float((loc1.start_slot >> wp.uint32(10)) & wp.uint32(0x3FF))            <L 1327>
        var_227 = &((var_13).start_slot);
        var_229 = wp::uint32(var_228);
        var_231 = wp::load(var_227);
        var_230 = wp::rshift(var_231, var_229);
        var_233 = wp::uint32(var_232);
        var_234 = wp::bit_and(var_230, var_233);
        var_235 = wp::float(var_234);
        // block_z1 = float((loc1.start_slot >> wp.uint32(20)) & wp.uint32(0x3FF))            <L 1328>
        var_236 = &((var_13).start_slot);
        var_238 = wp::uint32(var_237);
        var_240 = wp::load(var_236);
        var_239 = wp::rshift(var_240, var_238);
        var_242 = wp::uint32(var_241);
        var_243 = wp::bit_and(var_239, var_242);
        var_244 = wp::float(var_243);
        // lx1 = float(loc1.ix) - float(loc1.x_base) * sdf.subgrid_size_f                     <L 1329>
        var_245 = &((var_13).ix);
        var_247 = wp::load(var_245);
        var_246 = wp::float(var_247);
        var_248 = &((var_13).x_base);
        var_250 = wp::load(var_248);
        var_249 = wp::float(var_250);
        var_251 = &((var_sdf).subgrid_size_f);
        var_253 = wp::load(var_251);
        var_252 = wp::mul(var_249, var_253);
        var_254 = wp::sub(var_246, var_252);
        // ly1 = float(loc1.iy) - float(loc1.y_base) * sdf.subgrid_size_f                     <L 1330>
        var_255 = &((var_13).iy);
        var_257 = wp::load(var_255);
        var_256 = wp::float(var_257);
        var_258 = &((var_13).y_base);
        var_260 = wp::load(var_258);
        var_259 = wp::float(var_260);
        var_261 = &((var_sdf).subgrid_size_f);
        var_263 = wp::load(var_261);
        var_262 = wp::mul(var_259, var_263);
        var_264 = wp::sub(var_256, var_262);
        // lz1 = float(loc1.iz) - float(loc1.z_base) * sdf.subgrid_size_f                     <L 1331>
        var_265 = &((var_13).iz);
        var_267 = wp::load(var_265);
        var_266 = wp::float(var_267);
        var_268 = &((var_13).z_base);
        var_270 = wp::load(var_268);
        var_269 = wp::float(var_270);
        var_271 = &((var_sdf).subgrid_size_f);
        var_273 = wp::load(var_271);
        var_272 = wp::mul(var_269, var_273);
        var_274 = wp::sub(var_266, var_272);
        // uvw1 = wp.vec3f(                                                                   <L 1332>
        // block_x1 * sdf.subgrid_samples_f + lx1 + 0.5 + loc1.tx,                            <L 1333>
        var_275 = &((var_sdf).subgrid_samples_f);
        var_277 = wp::load(var_275);
        var_276 = wp::mul(var_226, var_277);
        var_278 = wp::add(var_276, var_254);
        var_280 = wp::add(var_278, var_279);
        var_281 = &((var_13).tx);
        var_283 = wp::load(var_281);
        var_282 = wp::add(var_280, var_283);
        // block_y1 * sdf.subgrid_samples_f + ly1 + 0.5 + loc1.ty,                            <L 1334>
        var_284 = &((var_sdf).subgrid_samples_f);
        var_286 = wp::load(var_284);
        var_285 = wp::mul(var_235, var_286);
        var_287 = wp::add(var_285, var_264);
        var_289 = wp::add(var_287, var_288);
        var_290 = &((var_13).ty);
        var_292 = wp::load(var_290);
        var_291 = wp::add(var_289, var_292);
        // block_z1 * sdf.subgrid_samples_f + lz1 + 0.5 + loc1.tz,                            <L 1335>
        var_293 = &((var_sdf).subgrid_samples_f);
        var_295 = wp::load(var_293);
        var_294 = wp::mul(var_244, var_295);
        var_296 = wp::add(var_294, var_274);
        var_298 = wp::add(var_296, var_297);
        var_299 = &((var_13).tz);
        var_301 = wp::load(var_299);
        var_300 = wp::add(var_298, var_301);
        var_302 = wp::vec_t<3, wp::float32>(var_282, var_291, var_300);
    }
    var_303 = wp::where(var_166, var_18, var_219);
    var_304 = wp::where(var_166, var_217, var_302);
    // values = _texture_sample_pair(texture0, uvw0, texture1, uvw1, paired_samples)          <L 1338>
    var_305 = _texture_sample_pair_0(var_163, var_164, var_303, var_304, var_paired_samples);
    // diff_mag0 = float(0.0)                                                                 <L 1340>
    var_307 = wp::float(var_306);
    // diff_mag1 = float(0.0)                                                                 <L 1341>
    var_309 = wp::float(var_308);
    // if diff_sq0 != 0.0:                                                                    <L 1342>
    var_311 = (var_diff_sq0 != var_310);
    if (var_311) {
        // diff_mag0 = wp.sqrt(diff_sq0)                                                      <L 1343>
        var_312 = wp::sqrt(var_diff_sq0);
    }
    var_313 = wp::where(var_311, var_312, var_307);
    // if diff_sq1 != 0.0:                                                                    <L 1344>
    var_315 = (var_diff_sq1 != var_314);
    if (var_315) {
        // diff_mag1 = wp.sqrt(diff_sq1)                                                      <L 1345>
        var_316 = wp::sqrt(var_diff_sq1);
    }
    var_317 = wp::where(var_315, var_316, var_309);
    // value0 = values[0]                                                                     <L 1346>
    var_319 = wp::extract(var_305, var_318);
    // value1 = values[1]                                                                     <L 1347>
    var_321 = wp::extract(var_305, var_320);
    // if loc0.start_slot < SLOT_LINEAR:                                                      <L 1348>
    var_322 = &((var_12).start_slot);
    var_324 = wp::load(var_322);
    var_323 = (var_324 < var_25);
    if (var_323) {
        // value0 = value0 * sdf.subgrids_sdf_value_range + sdf.subgrids_min_sdf_value        <L 1349>
        var_325 = &((var_sdf).subgrids_sdf_value_range);
        var_327 = wp::load(var_325);
        var_326 = wp::mul(var_319, var_327);
        var_328 = &((var_sdf).subgrids_min_sdf_value);
        var_330 = wp::load(var_328);
        var_329 = wp::add(var_326, var_330);
    }
    var_331 = wp::where(var_323, var_329, var_319);
    // if loc1.start_slot < SLOT_LINEAR:                                                      <L 1350>
    var_332 = &((var_13).start_slot);
    var_334 = wp::load(var_332);
    var_333 = (var_334 < var_25);
    if (var_333) {
        // value1 = value1 * sdf.subgrids_sdf_value_range + sdf.subgrids_min_sdf_value        <L 1351>
        var_335 = &((var_sdf).subgrids_sdf_value_range);
        var_337 = wp::load(var_335);
        var_336 = wp::mul(var_321, var_337);
        var_338 = &((var_sdf).subgrids_min_sdf_value);
        var_340 = wp::load(var_338);
        var_339 = wp::add(var_336, var_340);
    }
    var_341 = wp::where(var_333, var_339, var_321);
    // return wp.vec2f(value0 + diff_mag0, value1 + diff_mag1)                                <L 1352>
    var_342 = wp::add(var_331, var_313);
    var_343 = wp::add(var_341, var_317);
    var_344 = wp::vec_t<2, wp::float32>(var_342, var_343);
    return var_344;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:1355
static CUDA_CALLABLE wp::vec_t<2, wp::float32> _texture_sample_sdf_hw_pair_variant_0(
    TextureSDFData_93572308 var_sdf,
    wp::vec_t<3, wp::float32> var_local_pos0,
    wp::vec_t<3, wp::float32> var_local_pos1,
    bool var_paired_samples)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    wp::float32 var_1;
    wp::vec_t<3, wp::float32>* var_2;
    const wp::int32 var_3 = 0;
    wp::float32 var_4;
    wp::vec_t<3, wp::float32> var_5;
    wp::vec_t<3, wp::float32>* var_6;
    const wp::int32 var_7 = 0;
    wp::float32 var_8;
    wp::vec_t<3, wp::float32> var_9;
    wp::float32 var_10;
    const wp::int32 var_11 = 1;
    wp::float32 var_12;
    wp::vec_t<3, wp::float32>* var_13;
    const wp::int32 var_14 = 1;
    wp::float32 var_15;
    wp::vec_t<3, wp::float32> var_16;
    wp::vec_t<3, wp::float32>* var_17;
    const wp::int32 var_18 = 1;
    wp::float32 var_19;
    wp::vec_t<3, wp::float32> var_20;
    wp::float32 var_21;
    const wp::int32 var_22 = 2;
    wp::float32 var_23;
    wp::vec_t<3, wp::float32>* var_24;
    const wp::int32 var_25 = 2;
    wp::float32 var_26;
    wp::vec_t<3, wp::float32> var_27;
    wp::vec_t<3, wp::float32>* var_28;
    const wp::int32 var_29 = 2;
    wp::float32 var_30;
    wp::vec_t<3, wp::float32> var_31;
    wp::float32 var_32;
    wp::vec_t<3, wp::float32> var_33;
    const wp::int32 var_34 = 0;
    wp::float32 var_35;
    wp::vec_t<3, wp::float32>* var_36;
    const wp::int32 var_37 = 0;
    wp::float32 var_38;
    wp::vec_t<3, wp::float32> var_39;
    wp::vec_t<3, wp::float32>* var_40;
    const wp::int32 var_41 = 0;
    wp::float32 var_42;
    wp::vec_t<3, wp::float32> var_43;
    wp::float32 var_44;
    const wp::int32 var_45 = 1;
    wp::float32 var_46;
    wp::vec_t<3, wp::float32>* var_47;
    const wp::int32 var_48 = 1;
    wp::float32 var_49;
    wp::vec_t<3, wp::float32> var_50;
    wp::vec_t<3, wp::float32>* var_51;
    const wp::int32 var_52 = 1;
    wp::float32 var_53;
    wp::vec_t<3, wp::float32> var_54;
    wp::float32 var_55;
    const wp::int32 var_56 = 2;
    wp::float32 var_57;
    wp::vec_t<3, wp::float32>* var_58;
    const wp::int32 var_59 = 2;
    wp::float32 var_60;
    wp::vec_t<3, wp::float32> var_61;
    wp::vec_t<3, wp::float32>* var_62;
    const wp::int32 var_63 = 2;
    wp::float32 var_64;
    wp::vec_t<3, wp::float32> var_65;
    wp::float32 var_66;
    wp::vec_t<3, wp::float32> var_67;
    wp::vec_t<3, wp::float32> var_68;
    wp::vec_t<3, wp::float32> var_69;
    const wp::float32 var_70 = 0.0;
    wp::float32 var_71;
    const wp::float32 var_72 = 0.0;
    wp::float32 var_73;
    bool var_74;
    const wp::int32 var_75 = 0;
    wp::float32 var_76;
    const wp::float32 var_77 = 0.0;
    bool var_78;
    const wp::int32 var_79 = 1;
    wp::float32 var_80;
    const wp::float32 var_81 = 0.0;
    bool var_82;
    const wp::int32 var_83 = 2;
    wp::float32 var_84;
    const wp::float32 var_85 = 0.0;
    bool var_86;
    wp::float32 var_87;
    wp::float32 var_88;
    bool var_89;
    const wp::int32 var_90 = 0;
    wp::float32 var_91;
    const wp::float32 var_92 = 0.0;
    bool var_93;
    const wp::int32 var_94 = 1;
    wp::float32 var_95;
    const wp::float32 var_96 = 0.0;
    bool var_97;
    const wp::int32 var_98 = 2;
    wp::float32 var_99;
    const wp::float32 var_100 = 0.0;
    bool var_101;
    wp::float32 var_102;
    wp::float32 var_103;
    wp::vec_t<2, wp::float32> var_104;
    //---------
    // forward
    // def _texture_sample_sdf_hw_pair_variant(                                               <L 1356>
    // clamped0 = wp.vec3(                                                                    <L 1363>
    // wp.clamp(local_pos0[0], sdf.sdf_box_lower[0], sdf.sdf_box_upper[0]),                   <L 1364>
    var_1 = wp::extract(var_local_pos0, var_0);
    var_2 = &((var_sdf).sdf_box_lower);
    var_5 = wp::load(var_2);
    var_4 = wp::extract(var_5, var_3);
    var_6 = &((var_sdf).sdf_box_upper);
    var_9 = wp::load(var_6);
    var_8 = wp::extract(var_9, var_7);
    var_10 = wp::clamp(var_1, var_4, var_8);
    // wp.clamp(local_pos0[1], sdf.sdf_box_lower[1], sdf.sdf_box_upper[1]),                   <L 1365>
    var_12 = wp::extract(var_local_pos0, var_11);
    var_13 = &((var_sdf).sdf_box_lower);
    var_16 = wp::load(var_13);
    var_15 = wp::extract(var_16, var_14);
    var_17 = &((var_sdf).sdf_box_upper);
    var_20 = wp::load(var_17);
    var_19 = wp::extract(var_20, var_18);
    var_21 = wp::clamp(var_12, var_15, var_19);
    // wp.clamp(local_pos0[2], sdf.sdf_box_lower[2], sdf.sdf_box_upper[2]),                   <L 1366>
    var_23 = wp::extract(var_local_pos0, var_22);
    var_24 = &((var_sdf).sdf_box_lower);
    var_27 = wp::load(var_24);
    var_26 = wp::extract(var_27, var_25);
    var_28 = &((var_sdf).sdf_box_upper);
    var_31 = wp::load(var_28);
    var_30 = wp::extract(var_31, var_29);
    var_32 = wp::clamp(var_23, var_26, var_30);
    var_33 = wp::vec_t<3, wp::float32>(var_10, var_21, var_32);
    // clamped1 = wp.vec3(                                                                    <L 1368>
    // wp.clamp(local_pos1[0], sdf.sdf_box_lower[0], sdf.sdf_box_upper[0]),                   <L 1369>
    var_35 = wp::extract(var_local_pos1, var_34);
    var_36 = &((var_sdf).sdf_box_lower);
    var_39 = wp::load(var_36);
    var_38 = wp::extract(var_39, var_37);
    var_40 = &((var_sdf).sdf_box_upper);
    var_43 = wp::load(var_40);
    var_42 = wp::extract(var_43, var_41);
    var_44 = wp::clamp(var_35, var_38, var_42);
    // wp.clamp(local_pos1[1], sdf.sdf_box_lower[1], sdf.sdf_box_upper[1]),                   <L 1370>
    var_46 = wp::extract(var_local_pos1, var_45);
    var_47 = &((var_sdf).sdf_box_lower);
    var_50 = wp::load(var_47);
    var_49 = wp::extract(var_50, var_48);
    var_51 = &((var_sdf).sdf_box_upper);
    var_54 = wp::load(var_51);
    var_53 = wp::extract(var_54, var_52);
    var_55 = wp::clamp(var_46, var_49, var_53);
    // wp.clamp(local_pos1[2], sdf.sdf_box_lower[2], sdf.sdf_box_upper[2]),                   <L 1371>
    var_57 = wp::extract(var_local_pos1, var_56);
    var_58 = &((var_sdf).sdf_box_lower);
    var_61 = wp::load(var_58);
    var_60 = wp::extract(var_61, var_59);
    var_62 = &((var_sdf).sdf_box_upper);
    var_65 = wp::load(var_62);
    var_64 = wp::extract(var_65, var_63);
    var_66 = wp::clamp(var_57, var_60, var_64);
    var_67 = wp::vec_t<3, wp::float32>(var_44, var_55, var_66);
    // diff0 = local_pos0 - clamped0                                                          <L 1373>
    var_68 = wp::sub(var_local_pos0, var_33);
    // diff1 = local_pos1 - clamped1                                                          <L 1374>
    var_69 = wp::sub(var_local_pos1, var_67);
    // diff_sq0 = float(0.0)                                                                  <L 1375>
    var_71 = wp::float(var_70);
    // diff_sq1 = float(0.0)                                                                  <L 1376>
    var_73 = wp::float(var_72);
    // if diff0[0] != 0.0 or diff0[1] != 0.0 or diff0[2] != 0.0:                              <L 1377>
    var_76 = wp::extract(var_68, var_75);
    var_78 = (var_76 != var_77);
    var_74 = var_78;
    if (!var_74) {
        var_80 = wp::extract(var_68, var_79);
        var_82 = (var_80 != var_81);
        var_74 = var_74 || var_82;
    }
    if (!var_74) {
        var_84 = wp::extract(var_68, var_83);
        var_86 = (var_84 != var_85);
        var_74 = var_74 || var_86;
    }
    if (var_74) {
        // diff_sq0 = wp.dot(diff0, diff0)                                                    <L 1378>
        var_87 = wp::dot(var_68, var_68);
    }
    var_88 = wp::where(var_74, var_87, var_71);
    // if diff1[0] != 0.0 or diff1[1] != 0.0 or diff1[2] != 0.0:                              <L 1379>
    var_91 = wp::extract(var_69, var_90);
    var_93 = (var_91 != var_92);
    var_89 = var_93;
    if (!var_89) {
        var_95 = wp::extract(var_69, var_94);
        var_97 = (var_95 != var_96);
        var_89 = var_89 || var_97;
    }
    if (!var_89) {
        var_99 = wp::extract(var_69, var_98);
        var_101 = (var_99 != var_100);
        var_89 = var_89 || var_101;
    }
    if (var_89) {
        // diff_sq1 = wp.dot(diff1, diff1)                                                    <L 1380>
        var_102 = wp::dot(var_69, var_69);
    }
    var_103 = wp::where(var_89, var_102, var_73);
    // return _texture_sample_sdf_hw_clamped_pair_variant(sdf, clamped0, clamped1, diff_sq0, diff_sq1, paired_samples)       <L 1381>
    var_104 = _texture_sample_sdf_hw_clamped_pair_variant_0(var_sdf, var_33, var_67, var_88, var_103, var_paired_samples);
    return var_104;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:1384
static CUDA_CALLABLE wp::vec_t<2, wp::float32> _texture_sample_sdf_hw_pair_0(
    TextureSDFData_93572308 var_sdf,
    wp::vec_t<3, wp::float32> var_local_pos0,
    wp::vec_t<3, wp::float32> var_local_pos1)
{
    //---------
    // primal vars
    bool* var_0;
    wp::vec_t<2, wp::float32> var_1;
    bool var_2;
    //---------
    // forward
    // def _texture_sample_sdf_hw_pair(                                                       <L 1385>
    // return _texture_sample_sdf_hw_pair_variant(sdf, local_pos0, local_pos1, sdf.paired_samples)       <L 1391>
    var_0 = &((var_sdf).paired_samples);
    var_2 = wp::load(var_0);
    var_1 = _texture_sample_sdf_hw_pair_variant_0(var_sdf, var_local_pos0, var_local_pos1, var_2);
    return var_1;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:1494
static CUDA_CALLABLE wp::float32 _texture_sample_sdf_hw_variant_0(
    TextureSDFData_93572308 var_sdf,
    wp::vec_t<3, wp::float32> var_local_pos,
    bool var_paired_samples)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    wp::float32 var_1;
    wp::vec_t<3, wp::float32>* var_2;
    const wp::int32 var_3 = 0;
    wp::float32 var_4;
    wp::vec_t<3, wp::float32> var_5;
    wp::vec_t<3, wp::float32>* var_6;
    const wp::int32 var_7 = 0;
    wp::float32 var_8;
    wp::vec_t<3, wp::float32> var_9;
    wp::float32 var_10;
    const wp::int32 var_11 = 1;
    wp::float32 var_12;
    wp::vec_t<3, wp::float32>* var_13;
    const wp::int32 var_14 = 1;
    wp::float32 var_15;
    wp::vec_t<3, wp::float32> var_16;
    wp::vec_t<3, wp::float32>* var_17;
    const wp::int32 var_18 = 1;
    wp::float32 var_19;
    wp::vec_t<3, wp::float32> var_20;
    wp::float32 var_21;
    const wp::int32 var_22 = 2;
    wp::float32 var_23;
    wp::vec_t<3, wp::float32>* var_24;
    const wp::int32 var_25 = 2;
    wp::float32 var_26;
    wp::vec_t<3, wp::float32> var_27;
    wp::vec_t<3, wp::float32>* var_28;
    const wp::int32 var_29 = 2;
    wp::float32 var_30;
    wp::vec_t<3, wp::float32> var_31;
    wp::float32 var_32;
    wp::vec_t<3, wp::float32> var_33;
    wp::vec_t<3, wp::float32> var_34;
    const wp::float32 var_35 = 0.0;
    wp::float32 var_36;
    bool var_37;
    const wp::int32 var_38 = 0;
    wp::float32 var_39;
    const wp::float32 var_40 = 0.0;
    bool var_41;
    const wp::int32 var_42 = 1;
    wp::float32 var_43;
    const wp::float32 var_44 = 0.0;
    bool var_45;
    const wp::int32 var_46 = 2;
    wp::float32 var_47;
    const wp::float32 var_48 = 0.0;
    bool var_49;
    wp::float32 var_50;
    wp::float32 var_51;
    wp::float32 var_52;
    //---------
    // forward
    // def _texture_sample_sdf_hw_variant(                                                    <L 1495>
    // clamped = wp.vec3(                                                                     <L 1518>
    // wp.clamp(local_pos[0], sdf.sdf_box_lower[0], sdf.sdf_box_upper[0]),                    <L 1519>
    var_1 = wp::extract(var_local_pos, var_0);
    var_2 = &((var_sdf).sdf_box_lower);
    var_5 = wp::load(var_2);
    var_4 = wp::extract(var_5, var_3);
    var_6 = &((var_sdf).sdf_box_upper);
    var_9 = wp::load(var_6);
    var_8 = wp::extract(var_9, var_7);
    var_10 = wp::clamp(var_1, var_4, var_8);
    // wp.clamp(local_pos[1], sdf.sdf_box_lower[1], sdf.sdf_box_upper[1]),                    <L 1520>
    var_12 = wp::extract(var_local_pos, var_11);
    var_13 = &((var_sdf).sdf_box_lower);
    var_16 = wp::load(var_13);
    var_15 = wp::extract(var_16, var_14);
    var_17 = &((var_sdf).sdf_box_upper);
    var_20 = wp::load(var_17);
    var_19 = wp::extract(var_20, var_18);
    var_21 = wp::clamp(var_12, var_15, var_19);
    // wp.clamp(local_pos[2], sdf.sdf_box_lower[2], sdf.sdf_box_upper[2]),                    <L 1521>
    var_23 = wp::extract(var_local_pos, var_22);
    var_24 = &((var_sdf).sdf_box_lower);
    var_27 = wp::load(var_24);
    var_26 = wp::extract(var_27, var_25);
    var_28 = &((var_sdf).sdf_box_upper);
    var_31 = wp::load(var_28);
    var_30 = wp::extract(var_31, var_29);
    var_32 = wp::clamp(var_23, var_26, var_30);
    var_33 = wp::vec_t<3, wp::float32>(var_10, var_21, var_32);
    // diff = local_pos - clamped                                                             <L 1523>
    var_34 = wp::sub(var_local_pos, var_33);
    // diff_mag = float(0.0)                                                                  <L 1524>
    var_36 = wp::float(var_35);
    // if diff[0] != 0.0 or diff[1] != 0.0 or diff[2] != 0.0:                                 <L 1526>
    var_39 = wp::extract(var_34, var_38);
    var_41 = (var_39 != var_40);
    var_37 = var_41;
    if (!var_37) {
        var_43 = wp::extract(var_34, var_42);
        var_45 = (var_43 != var_44);
        var_37 = var_37 || var_45;
    }
    if (!var_37) {
        var_47 = wp::extract(var_34, var_46);
        var_49 = (var_47 != var_48);
        var_37 = var_37 || var_49;
    }
    if (var_37) {
        // diff_mag = wp.length(diff)                                                         <L 1527>
        var_50 = wp::length(var_34);
    }
    var_51 = wp::where(var_37, var_50, var_36);
    // return _texture_sample_sdf_hw_clamped_variant(sdf, clamped, diff_mag, paired_samples)       <L 1529>
    var_52 = _texture_sample_sdf_hw_clamped_variant_0(var_sdf, var_33, var_51, var_paired_samples);
    return var_52;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:1532
static CUDA_CALLABLE wp::float32 texture_sample_sdf_hw_0(
    TextureSDFData_93572308 var_sdf,
    wp::vec_t<3, wp::float32> var_local_pos)
{
    //---------
    // primal vars
    bool* var_0;
    wp::float32 var_1;
    bool var_2;
    //---------
    // forward
    // def texture_sample_sdf_hw(                                                             <L 1533>
    // return _texture_sample_sdf_hw_variant(sdf, local_pos, sdf.paired_samples)              <L 1538>
    var_0 = &((var_sdf).paired_samples);
    var_2 = wp::load(var_0);
    var_1 = _texture_sample_sdf_hw_variant_0(var_sdf, var_local_pos, var_2);
    return var_1;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:671
static CUDA_CALLABLE wp::float32 _create_sdf_contact_funcs__locals___sample_sdf_at_t_1(
    TextureSDFData_93572308 var_texture_sdf,
    wp::uint64 var_sdf_mesh_id,
    wp::vec_t<3, wp::float32> var_v0,
    wp::vec_t<3, wp::float32> var_edge_dir,
    wp::float32 var_tt,
    bool var_use_bvh_for_sdf,
    wp::int32 var_sdf_mesh_query_type,
    bool var_sdf_is_heightfield,
    HeightfieldData_f2b8d59a var_hfd_sdf,
    wp::array_t<wp::float32> var_elevation_data)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    const bool var_2 = false;
    const bool var_3 = false;
    const wp::float32 var_4 = 100000000000.0;
    wp::float32 var_5;
    wp::float32 var_6;
    //---------
    // forward
    // def _sample_sdf_at_t(                                                                  <L 672>
    // pp = v0 + edge_dir * tt                                                                <L 685>
    var_0 = wp::mul(var_edge_dir, var_tt);
    var_1 = wp::add(var_v0, var_0);
    // if wp.static(enable_heightfields):                                                     <L 686>
    // if wp.static(use_texture_sdf_only):                                                    <L 696>
    // elif use_bvh_for_sdf:                                                                  <L 698>
    if (var_use_bvh_for_sdf) {
        // return sample_sdf_using_mesh(sdf_mesh_id, pp, _MESH_QUERY_MAX_DIST, sdf_mesh_query_type)       <L 699>
        var_5 = sample_sdf_using_mesh_0(var_sdf_mesh_id, var_1, var_4, var_sdf_mesh_query_type);
        return var_5;
    }
    if (!var_use_bvh_for_sdf) {
        // return wp.static(sample_sdf)(texture_sdf, pp)                                      <L 701>
        var_6 = texture_sample_sdf_hw_0(var_texture_sdf, var_1);
        return var_6;
    }
    return {};
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:703
static CUDA_CALLABLE void _create_sdf_contact_funcs__locals__do_edge_sdf_collision_func_1(
    TextureSDFData_93572308 var_texture_sdf,
    wp::uint64 var_sdf_mesh_id,
    wp::vec_t<3, wp::float32> var_v0,
    wp::vec_t<3, wp::float32> var_v1,
    wp::float32 var_midpoint_sdf,
    bool var_use_bvh_for_sdf,
    wp::int32 var_sdf_mesh_query_type,
    bool var_sdf_is_heightfield,
    HeightfieldData_f2b8d59a var_hfd_sdf,
    wp::array_t<wp::float32> var_elevation_data,
    wp::float32 var_precision_target,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::int32 & ret_2)
{
    //---------
    // primal vars
    const wp::float32 var_0 = 0.3819660112501051;
    wp::vec_t<3, wp::float32> var_1;
    wp::float32 var_2;
    const wp::float32 var_3 = 1000000000000.0;
    wp::float32 var_4;
    const wp::float32 var_5 = 0.0;
    bool var_6;
    wp::float32 var_7;
    wp::float32 var_8;
    const wp::float32 var_9 = 0.5;
    wp::float32 var_10;
    wp::float32 var_11;
    const wp::float32 var_12 = 0.0;
    wp::float32 var_13;
    const wp::float32 var_14 = 1.0;
    wp::float32 var_15;
    const wp::float32 var_16 = 0.5;
    wp::float32 var_17;
    const wp::float32 var_18 = 0.5;
    wp::float32 var_19;
    const wp::float32 var_20 = 0.5;
    wp::float32 var_21;
    wp::float32 var_22;
    wp::float32 var_23;
    wp::float32 var_24;
    const wp::float32 var_25 = 0.0;
    wp::float32 var_26;
    const wp::float32 var_27 = 0.0;
    wp::float32 var_28;
    bool var_29;
    const bool var_30 = false;
    const wp::float32 var_31 = 0.25;
    bool var_32;
    const wp::float32 var_33 = 0.5;
    wp::float32 var_34;
    const wp::float32 var_35 = 0.5;
    wp::float32 var_36;
    const wp::float32 var_37 = 0.5;
    wp::float32 var_38;
    wp::vec_t<3, wp::float32> var_39;
    wp::vec_t<3, wp::float32> var_40;
    wp::vec_t<3, wp::float32> var_41;
    wp::vec_t<3, wp::float32> var_42;
    wp::vec_t<2, wp::float32> var_43;
    const wp::int32 var_44 = 0;
    wp::float32 var_45;
    const wp::int32 var_46 = 1;
    wp::float32 var_47;
    bool var_48;
    bool var_49;
    bool var_50;
    const wp::float32 var_51 = 0.5;
    wp::float32 var_52;
    wp::float32 var_53;
    const wp::float32 var_54 = 0.5;
    wp::float32 var_55;
    wp::float32 var_56;
    wp::float32 var_57;
    bool var_58;
    const wp::float32 var_59 = 0.5;
    wp::float32 var_60;
    wp::float32 var_61;
    const wp::float32 var_62 = 0.5;
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
    wp::float32 var_74;
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
    wp::float32 var_85;
    wp::float32 var_86;
    wp::float32 var_87;
    wp::float32 var_88;
    wp::float32 var_89;
    wp::float32 var_90;
    wp::float32 var_91;
    wp::float32 var_92;
    wp::float32 var_93;
    wp::float32 var_94;
    wp::float32 var_95;
    const wp::int32 var_96 = 5;
    wp::range_t var_97;
    wp::int32 var_98;
    const wp::float32 var_99 = 0.5;
    wp::float32 var_100;
    wp::float32 var_101;
    const wp::float32 var_102 = 0.01;
    wp::float32 var_103;
    wp::float32 var_104;
    const wp::float32 var_105 = 1e-08;
    wp::float32 var_106;
    wp::float32 var_107;
    const wp::float32 var_108 = 2.0;
    wp::float32 var_109;
    wp::float32 var_110;
    wp::float32 var_111;
    const wp::float32 var_112 = 0.5;
    wp::float32 var_113;
    wp::float32 var_114;
    wp::float32 var_115;
    bool var_116;
    const bool var_117 = false;
    const wp::float32 var_118 = 0.0;
    wp::float32 var_119;
    const wp::float32 var_120 = 0.0;
    wp::float32 var_121;
    const wp::float32 var_122 = 0.0;
    wp::float32 var_123;
    wp::float32 var_124;
    bool var_125;
    wp::float32 var_126;
    wp::float32 var_127;
    wp::float32 var_128;
    wp::float32 var_129;
    wp::float32 var_130;
    wp::float32 var_131;
    wp::float32 var_132;
    wp::float32 var_133;
    wp::float32 var_134;
    wp::float32 var_135;
    wp::float32 var_136;
    const wp::float32 var_137 = 2.0;
    wp::float32 var_138;
    wp::float32 var_139;
    const wp::float32 var_140 = 0.0;
    bool var_141;
    wp::float32 var_142;
    wp::float32 var_143;
    wp::float32 var_144;
    wp::float32 var_145;
    wp::float32 var_146;
    const wp::float32 var_147 = 0.5;
    wp::float32 var_148;
    wp::float32 var_149;
    wp::float32 var_150;
    bool var_151;
    wp::float32 var_152;
    wp::float32 var_153;
    bool var_154;
    wp::float32 var_155;
    bool var_156;
    wp::float32 var_157;
    bool var_158;
    const bool var_159 = true;
    bool var_160;
    bool var_161;
    wp::float32 var_162;
    bool var_163;
    wp::float32 var_164;
    wp::float32 var_165;
    wp::float32 var_166;
    wp::float32 var_167;
    wp::float32 var_168;
    bool var_169;
    wp::float32 var_170;
    wp::float32 var_171;
    wp::float32 var_172;
    wp::float32 var_173;
    wp::float32 var_174;
    wp::float32 var_175;
    wp::float32 var_176;
    bool var_177;
    wp::float32 var_178;
    const wp::float32 var_179 = 0.0;
    bool var_180;
    wp::float32 var_181;
    wp::float32 var_182;
    wp::float32 var_183;
    wp::float32 var_184;
    wp::float32 var_185;
    bool var_186;
    bool var_187;
    wp::float32 var_188;
    wp::float32 var_189;
    wp::float32 var_190;
    wp::float32 var_191;
    wp::float32 var_192;
    wp::float32 var_193;
    wp::float32 var_194;
    wp::float32 var_195;
    wp::float32 var_196;
    wp::float32 var_197;
    bool var_198;
    wp::float32 var_199;
    wp::float32 var_200;
    wp::float32 var_201;
    wp::float32 var_202;
    bool var_203;
    bool var_204;
    bool var_205;
    wp::float32 var_206;
    wp::float32 var_207;
    wp::float32 var_208;
    wp::float32 var_209;
    bool var_210;
    bool var_211;
    bool var_212;
    bool var_213;
    wp::float32 var_214;
    wp::float32 var_215;
    wp::float32 var_216;
    wp::float32 var_217;
    wp::float32 var_218;
    wp::float32 var_219;
    wp::float32 var_220;
    wp::float32 var_221;
    wp::float32 var_222;
    wp::float32 var_223;
    wp::float32 var_224;
    wp::float32 var_225;
    wp::float32 var_226;
    wp::float32 var_227;
    wp::float32 var_228;
    wp::float32 var_229;
    const wp::int32 var_230 = 0;
    wp::int32 var_231;
    wp::float32 var_232;
    wp::float32 var_233;
    const wp::float32 var_234 = 0.0;
    bool var_235;
    const wp::float32 var_236 = 0.0;
    wp::float32 var_237;
    bool var_238;
    const wp::float32 var_239 = 0.0;
    wp::float32 var_240;
    const wp::int32 var_241 = 1;
    wp::int32 var_242;
    wp::float32 var_243;
    wp::float32 var_244;
    wp::int32 var_245;
    wp::float32 var_246;
    wp::float32 var_247;
    const wp::float32 var_248 = 1.0;
    bool var_249;
    const wp::float32 var_250 = 1.0;
    wp::float32 var_251;
    bool var_252;
    const wp::float32 var_253 = 1.0;
    wp::float32 var_254;
    const wp::int32 var_255 = 2;
    wp::int32 var_256;
    wp::float32 var_257;
    wp::float32 var_258;
    wp::int32 var_259;
    wp::float32 var_260;
    wp::float32 var_261;
    wp::float32 var_262;
    wp::vec_t<3, wp::float32> var_263;
    wp::vec_t<3, wp::float32> var_264;
    //---------
    // forward
    // def do_edge_sdf_collision_func(                                                        <L 704>
    // golden = 0.3819660112501051  # (3 - sqrt(5)) / 2                                       <L 744>
    // edge_dir = v1 - v0                                                                     <L 745>
    var_1 = wp::sub(var_v1, var_v0);
    // edge_length_sq = wp.length_sq(edge_dir)                                                <L 746>
    var_2 = wp::length_sq(var_1);
    // inv_edge_length = float(1.0e12)                                                        <L 747>
    var_4 = wp::float(var_3);
    // if edge_length_sq > 0.0:                                                               <L 748>
    var_6 = (var_2 > var_5);
    if (var_6) {
        // inv_edge_length = _sdf_rsqrt_rn(edge_length_sq)                                    <L 749>
        var_7 = _sdf_rsqrt_rn_0(var_2);
    }
    var_8 = wp::where(var_6, var_7, var_4);
    // tol_floor = 0.5 * precision_target * inv_edge_length                                   <L 754>
    var_10 = wp::mul(var_9, var_precision_target);
    var_11 = wp::mul(var_10, var_8);
    // a = float(0.0)                                                                         <L 757>
    var_13 = wp::float(var_12);
    // b = float(1.0)                                                                         <L 758>
    var_15 = wp::float(var_14);
    // x = float(0.5)                                                                         <L 759>
    var_17 = wp::float(var_16);
    // w = float(0.5)                                                                         <L 760>
    var_19 = wp::float(var_18);
    // v_brent = float(0.5)                                                                   <L 761>
    var_21 = wp::float(var_20);
    // fx = midpoint_sdf                                                                      <L 762>
    var_22 = wp::copy(var_midpoint_sdf);
    // fw = fx                                                                                <L 763>
    var_23 = wp::copy(var_22);
    // fv = fx                                                                                <L 764>
    var_24 = wp::copy(var_22);
    // d_step = float(0.0)                                                                    <L 765>
    var_26 = wp::float(var_25);
    // e_step = float(0.0)                                                                    <L 766>
    var_28 = wp::float(var_27);
    // if wp.static(use_texture_sdf_only and not enable_heightfields) and tol_floor < 0.25:       <L 768>
    var_29 = var_30;
    if (var_29) {
        var_32 = (var_11 < var_31);
        var_29 = var_29 && var_32;
    }
    if (var_29) {
        // offset = 0.5 * golden                                                              <L 769>
        var_34 = wp::mul(var_33, var_0);
        // left = 0.5 - offset                                                                <L 770>
        var_36 = wp::sub(var_35, var_34);
        // right = 0.5 + offset                                                               <L 771>
        var_38 = wp::add(var_37, var_34);
        // pair_values = wp.static(sample_pair)(                                              <L 772>
        // texture_sdf,                                                                       <L 773>
        // v0 + edge_dir * left,                                                              <L 774>
        var_39 = wp::mul(var_1, var_36);
        var_40 = wp::add(var_v0, var_39);
        // v0 + edge_dir * right,                                                             <L 775>
        var_41 = wp::mul(var_1, var_38);
        var_42 = wp::add(var_v0, var_41);
        var_43 = _texture_sample_sdf_hw_pair_0(var_texture_sdf, var_40, var_42);
        // f_left = pair_values[0]                                                            <L 777>
        var_45 = wp::extract(var_43, var_44);
        // f_right = pair_values[1]                                                           <L 778>
        var_47 = wp::extract(var_43, var_46);
        // if f_left < fx and f_left <= f_right:                                              <L 780>
        var_49 = (var_45 < var_22);
        var_48 = var_49;
        if (var_48) {
            var_50 = (var_45 <= var_47);
            var_48 = var_48 && var_50;
        }
        if (var_48) {
            // b = 0.5                                                                        <L 781>
            // x = left                                                                       <L 782>
            var_52 = wp::copy(var_36);
            // fx = f_left                                                                    <L 783>
            var_53 = wp::copy(var_45);
            // w = 0.5                                                                        <L 784>
            // fw = midpoint_sdf                                                              <L 785>
            var_55 = wp::copy(var_midpoint_sdf);
            // v_brent = right                                                                <L 786>
            var_56 = wp::copy(var_38);
            // fv = f_right                                                                   <L 787>
            var_57 = wp::copy(var_47);
        }
        if (!var_48) {
            // elif f_right < fx:                                                             <L 788>
            var_58 = (var_47 < var_22);
            if (var_58) {
                // a = 0.5                                                                    <L 789>
                // x = right                                                                  <L 790>
                var_60 = wp::copy(var_38);
                // fx = f_right                                                               <L 791>
                var_61 = wp::copy(var_47);
                // w = 0.5                                                                    <L 792>
                // fw = midpoint_sdf                                                          <L 793>
                var_63 = wp::copy(var_midpoint_sdf);
                // v_brent = left                                                             <L 794>
                var_64 = wp::copy(var_36);
                // fv = f_left                                                                <L 795>
                var_65 = wp::copy(var_45);
            }
            if (!var_58) {
                // a = left                                                                   <L 797>
                var_66 = wp::copy(var_36);
                // b = right                                                                  <L 798>
                var_67 = wp::copy(var_38);
                // w = left                                                                   <L 799>
                var_68 = wp::copy(var_36);
                // fw = f_left                                                                <L 800>
                var_69 = wp::copy(var_45);
                // v_brent = right                                                            <L 801>
                var_70 = wp::copy(var_38);
                // fv = f_right                                                               <L 802>
                var_71 = wp::copy(var_47);
            }
            var_72 = wp::where(var_58, var_59, var_66);
            var_73 = wp::where(var_58, var_15, var_67);
            var_74 = wp::where(var_58, var_60, var_17);
            var_75 = wp::where(var_58, var_62, var_68);
            var_76 = wp::where(var_58, var_64, var_70);
            var_77 = wp::where(var_58, var_61, var_22);
            var_78 = wp::where(var_58, var_63, var_69);
            var_79 = wp::where(var_58, var_65, var_71);
        }
        var_80 = wp::where(var_48, var_13, var_72);
        var_81 = wp::where(var_48, var_51, var_73);
        var_82 = wp::where(var_48, var_52, var_74);
        var_83 = wp::where(var_48, var_54, var_75);
        var_84 = wp::where(var_48, var_56, var_76);
        var_85 = wp::where(var_48, var_53, var_77);
        var_86 = wp::where(var_48, var_55, var_78);
        var_87 = wp::where(var_48, var_57, var_79);
    }
    var_88 = wp::where(var_29, var_80, var_13);
    var_89 = wp::where(var_29, var_81, var_15);
    var_90 = wp::where(var_29, var_82, var_17);
    var_91 = wp::where(var_29, var_83, var_19);
    var_92 = wp::where(var_29, var_84, var_21);
    var_93 = wp::where(var_29, var_85, var_22);
    var_94 = wp::where(var_29, var_86, var_23);
    var_95 = wp::where(var_29, var_87, var_24);
    // for _iter in range(wp.static(3 if use_texture_sdf_only and not enable_heightfields else 5)):       <L 803>
    var_97 = wp::range(var_96);
    start_for_0:;
        if (iter_cmp(var_97) == 0) goto end_for_0;
        var_98 = wp::iter_next(var_97);
        // m = 0.5 * (a + b)                                                                  <L 804>
        var_100 = wp::add(var_88, var_89);
        var_101 = wp::mul(var_99, var_100);
        // tol = wp.max(1.0e-2 * wp.abs(x) + 1.0e-8, tol_floor)                               <L 805>
        var_103 = wp::abs(var_90);
        var_104 = wp::mul(var_102, var_103);
        var_106 = wp::add(var_104, var_105);
        var_107 = wp::max(var_106, var_11);
        // tol2 = 2.0 * tol                                                                   <L 806>
        var_109 = wp::mul(var_108, var_107);
        // if wp.abs(x - m) <= tol2 - 0.5 * (b - a):                                          <L 808>
        var_110 = wp::sub(var_90, var_101);
        var_111 = wp::abs(var_110);
        var_113 = wp::sub(var_89, var_88);
        var_114 = wp::mul(var_112, var_113);
        var_115 = wp::sub(var_109, var_114);
        var_116 = (var_111 <= var_115);
        if (var_116) {
            // break                                                                          <L 809>
            goto end_for_0;
        }
        // use_parabolic = False                                                              <L 812>
        // p_num = float(0.0)                                                                 <L 813>
        var_119 = wp::float(var_118);
        // q_denom = float(0.0)                                                               <L 814>
        var_121 = wp::float(var_120);
        // trial = float(0.0)                                                                 <L 815>
        var_123 = wp::float(var_122);
        // if wp.abs(e_step) > tol:                                                           <L 817>
        var_124 = wp::abs(var_28);
        var_125 = (var_124 > var_107);
        if (var_125) {
            // r = (x - w) * (fx - fv)                                                        <L 818>
            var_126 = wp::sub(var_90, var_91);
            var_127 = wp::sub(var_93, var_95);
            var_128 = wp::mul(var_126, var_127);
            // q_denom = (x - v_brent) * (fx - fw)                                            <L 819>
            var_129 = wp::sub(var_90, var_92);
            var_130 = wp::sub(var_93, var_94);
            var_131 = wp::mul(var_129, var_130);
            // p_num = (x - v_brent) * q_denom - (x - w) * r                                  <L 820>
            var_132 = wp::sub(var_90, var_92);
            var_133 = wp::mul(var_132, var_131);
            var_134 = wp::sub(var_90, var_91);
            var_135 = wp::mul(var_134, var_128);
            var_136 = wp::sub(var_133, var_135);
            // q_denom = 2.0 * (q_denom - r)                                                  <L 821>
            var_138 = wp::sub(var_131, var_128);
            var_139 = wp::mul(var_137, var_138);
            // if q_denom > 0.0:                                                              <L 822>
            var_141 = (var_139 > var_140);
            if (var_141) {
                // p_num = -p_num                                                             <L 823>
                var_142 = wp::neg(var_136);
            }
            if (!var_141) {
                // q_denom = -q_denom                                                         <L 825>
                var_143 = wp::neg(var_139);
            }
            var_144 = wp::where(var_141, var_142, var_136);
            var_145 = wp::where(var_141, var_139, var_143);
            // if wp.abs(p_num) < 0.5 * wp.abs(q_denom * e_step):                             <L 828>
            var_146 = wp::abs(var_144);
            var_148 = wp::mul(var_145, var_28);
            var_149 = wp::abs(var_148);
            var_150 = wp::mul(var_147, var_149);
            var_151 = (var_146 < var_150);
            if (var_151) {
                // trial = p_num / q_denom                                                    <L 829>
                var_152 = wp::div(var_144, var_145);
                // u_trial = x + trial                                                        <L 830>
                var_153 = wp::add(var_90, var_152);
                // if u_trial - a >= tol2 and b - u_trial >= tol2:                            <L 831>
                var_155 = wp::sub(var_153, var_88);
                var_156 = (var_155 >= var_109);
                var_154 = var_156;
                if (var_154) {
                    var_157 = wp::sub(var_89, var_153);
                    var_158 = (var_157 >= var_109);
                    var_154 = var_154 && var_158;
                }
                if (var_154) {
                    // use_parabolic = True                                                   <L 832>
                }
                var_160 = wp::where(var_154, var_159, var_117);
            }
            var_161 = wp::where(var_151, var_160, var_117);
            var_162 = wp::where(var_151, var_152, var_123);
        }
        var_163 = wp::where(var_125, var_161, var_117);
        var_164 = wp::where(var_125, var_144, var_119);
        var_165 = wp::where(var_125, var_145, var_121);
        var_166 = wp::where(var_125, var_162, var_123);
        // if use_parabolic:                                                                  <L 834>
        if (var_163) {
            // e_step = d_step                                                                <L 835>
            var_167 = wp::copy(var_26);
            // d_step = trial                                                                 <L 836>
            var_168 = wp::copy(var_166);
        }
        if (!var_163) {
            // if x >= m:                                                                     <L 839>
            var_169 = (var_90 >= var_101);
            if (var_169) {
                // e_step = a - x                                                             <L 840>
                var_170 = wp::sub(var_88, var_90);
            }
            if (!var_169) {
                // e_step = b - x                                                             <L 842>
                var_171 = wp::sub(var_89, var_90);
            }
            var_172 = wp::where(var_169, var_170, var_171);
            // d_step = golden * e_step                                                       <L 843>
            var_173 = wp::mul(var_0, var_172);
        }
        var_174 = wp::where(var_163, var_168, var_173);
        var_175 = wp::where(var_163, var_167, var_172);
        // if wp.abs(d_step) >= tol:                                                          <L 846>
        var_176 = wp::abs(var_174);
        var_177 = (var_176 >= var_107);
        if (var_177) {
            // u = x + d_step                                                                 <L 847>
            var_178 = wp::add(var_90, var_174);
        }
        if (!var_177) {
            // if d_step > 0.0:                                                               <L 849>
            var_180 = (var_174 > var_179);
            if (var_180) {
                // u = x + tol                                                                <L 850>
                var_181 = wp::add(var_90, var_107);
            }
            if (!var_180) {
                // u = x - tol                                                                <L 852>
                var_182 = wp::sub(var_90, var_107);
            }
            var_183 = wp::where(var_180, var_181, var_182);
        }
        var_184 = wp::where(var_177, var_178, var_183);
        // fu = _sample_sdf_at_t(                                                             <L 854>
        // texture_sdf,                                                                       <L 855>
        // sdf_mesh_id,                                                                       <L 856>
        // v0,                                                                                <L 857>
        // edge_dir,                                                                          <L 858>
        // u,                                                                                 <L 859>
        // use_bvh_for_sdf,                                                                   <L 860>
        // sdf_mesh_query_type,                                                               <L 861>
        // sdf_is_heightfield,                                                                <L 862>
        // hfd_sdf,                                                                           <L 863>
        // elevation_data,                                                                    <L 864>
        var_185 = _create_sdf_contact_funcs__locals___sample_sdf_at_t_1(var_texture_sdf, var_sdf_mesh_id, var_v0, var_1, var_184, var_use_bvh_for_sdf, var_sdf_mesh_query_type, var_sdf_is_heightfield, var_hfd_sdf, var_elevation_data);
        // if fu <= fx:                                                                       <L 868>
        var_186 = (var_185 <= var_93);
        if (var_186) {
            // if u < x:                                                                      <L 869>
            var_187 = (var_184 < var_90);
            if (var_187) {
                // b = x                                                                      <L 870>
                var_188 = wp::copy(var_90);
            }
            if (!var_187) {
                // a = x                                                                      <L 872>
                var_189 = wp::copy(var_90);
            }
            var_190 = wp::where(var_187, var_88, var_189);
            var_191 = wp::where(var_187, var_188, var_89);
            // v_brent = w                                                                    <L 873>
            var_192 = wp::copy(var_91);
            // fv = fw                                                                        <L 874>
            var_193 = wp::copy(var_94);
            // w = x                                                                          <L 875>
            var_194 = wp::copy(var_90);
            // fw = fx                                                                        <L 876>
            var_195 = wp::copy(var_93);
            // x = u                                                                          <L 877>
            var_196 = wp::copy(var_184);
            // fx = fu                                                                        <L 878>
            var_197 = wp::copy(var_185);
        }
        if (!var_186) {
            // if u < x:                                                                      <L 880>
            var_198 = (var_184 < var_90);
            if (var_198) {
                // a = u                                                                      <L 881>
                var_199 = wp::copy(var_184);
            }
            if (!var_198) {
                // b = u                                                                      <L 883>
                var_200 = wp::copy(var_184);
            }
            var_201 = wp::where(var_198, var_199, var_88);
            var_202 = wp::where(var_198, var_89, var_200);
            // if fu <= fw or w == x:                                                         <L 884>
            var_204 = (var_185 <= var_94);
            var_203 = var_204;
            if (!var_203) {
                var_205 = (var_91 == var_90);
                var_203 = var_203 || var_205;
            }
            if (var_203) {
                // v_brent = w                                                                <L 885>
                var_206 = wp::copy(var_91);
                // fv = fw                                                                    <L 886>
                var_207 = wp::copy(var_94);
                // w = u                                                                      <L 887>
                var_208 = wp::copy(var_184);
                // fw = fu                                                                    <L 888>
                var_209 = wp::copy(var_185);
            }
            if (!var_203) {
                // elif fu <= fv or v_brent == x or v_brent == w:                             <L 889>
                var_211 = (var_185 <= var_95);
                var_210 = var_211;
                if (!var_210) {
                    var_212 = (var_92 == var_90);
                    var_210 = var_210 || var_212;
                }
                if (!var_210) {
                    var_213 = (var_92 == var_91);
                    var_210 = var_210 || var_213;
                }
                if (var_210) {
                    // v_brent = u                                                            <L 890>
                    var_214 = wp::copy(var_184);
                    // fv = fu                                                                <L 891>
                    var_215 = wp::copy(var_185);
                }
                var_216 = wp::where(var_210, var_214, var_92);
                var_217 = wp::where(var_210, var_215, var_95);
            }
            var_218 = wp::where(var_203, var_208, var_91);
            var_219 = wp::where(var_203, var_206, var_216);
            var_220 = wp::where(var_203, var_209, var_94);
            var_221 = wp::where(var_203, var_207, var_217);
        }
        var_222 = wp::where(var_186, var_190, var_201);
        var_223 = wp::where(var_186, var_191, var_202);
        var_224 = wp::where(var_186, var_196, var_90);
        var_225 = wp::where(var_186, var_194, var_218);
        var_226 = wp::where(var_186, var_192, var_219);
        var_227 = wp::where(var_186, var_197, var_93);
        var_228 = wp::where(var_186, var_195, var_220);
        var_229 = wp::where(var_186, var_193, var_221);
        wp::assign(var_88, var_222);
        wp::assign(var_89, var_223);
        wp::assign(var_90, var_224);
        wp::assign(var_91, var_225);
        wp::assign(var_92, var_226);
        wp::assign(var_93, var_227);
        wp::assign(var_94, var_228);
        wp::assign(var_95, var_229);
        wp::assign(var_26, var_174);
        wp::assign(var_28, var_175);
        goto start_for_0;
    end_for_0:;
    // best_endpoint = int(0)                                                                 <L 896>
    var_231 = wp::int(var_230);
    // best_t = x                                                                             <L 897>
    var_232 = wp::copy(var_90);
    // best_f = fx                                                                            <L 898>
    var_233 = wp::copy(var_93);
    // if a == 0.0:                                                                           <L 899>
    var_235 = (var_88 == var_234);
    if (var_235) {
        // f_end = _sample_sdf_at_t(                                                          <L 900>
        // texture_sdf,                                                                       <L 901>
        // sdf_mesh_id,                                                                       <L 902>
        // v0,                                                                                <L 903>
        // edge_dir,                                                                          <L 904>
        // 0.0,                                                                               <L 905>
        // use_bvh_for_sdf,                                                                   <L 906>
        // sdf_mesh_query_type,                                                               <L 907>
        // sdf_is_heightfield,                                                                <L 908>
        // hfd_sdf,                                                                           <L 909>
        // elevation_data,                                                                    <L 910>
        var_237 = _create_sdf_contact_funcs__locals___sample_sdf_at_t_1(var_texture_sdf, var_sdf_mesh_id, var_v0, var_1, var_236, var_use_bvh_for_sdf, var_sdf_mesh_query_type, var_sdf_is_heightfield, var_hfd_sdf, var_elevation_data);
        // if f_end < best_f:                                                                 <L 912>
        var_238 = (var_237 < var_233);
        if (var_238) {
            // best_t = 0.0                                                                   <L 913>
            // best_f = f_end                                                                 <L 914>
            var_240 = wp::copy(var_237);
            // best_endpoint = 1                                                              <L 915>
        }
        var_242 = wp::where(var_238, var_241, var_231);
        var_243 = wp::where(var_238, var_239, var_232);
        var_244 = wp::where(var_238, var_240, var_233);
    }
    var_245 = wp::where(var_235, var_242, var_231);
    var_246 = wp::where(var_235, var_243, var_232);
    var_247 = wp::where(var_235, var_244, var_233);
    // if b == 1.0:                                                                           <L 916>
    var_249 = (var_89 == var_248);
    if (var_249) {
        // f_end = _sample_sdf_at_t(                                                          <L 917>
        // texture_sdf,                                                                       <L 918>
        // sdf_mesh_id,                                                                       <L 919>
        // v0,                                                                                <L 920>
        // edge_dir,                                                                          <L 921>
        // 1.0,                                                                               <L 922>
        // use_bvh_for_sdf,                                                                   <L 923>
        // sdf_mesh_query_type,                                                               <L 924>
        // sdf_is_heightfield,                                                                <L 925>
        // hfd_sdf,                                                                           <L 926>
        // elevation_data,                                                                    <L 927>
        var_251 = _create_sdf_contact_funcs__locals___sample_sdf_at_t_1(var_texture_sdf, var_sdf_mesh_id, var_v0, var_1, var_250, var_use_bvh_for_sdf, var_sdf_mesh_query_type, var_sdf_is_heightfield, var_hfd_sdf, var_elevation_data);
        // if f_end < best_f:                                                                 <L 929>
        var_252 = (var_251 < var_247);
        if (var_252) {
            // best_t = 1.0                                                                   <L 930>
            // best_f = f_end                                                                 <L 931>
            var_254 = wp::copy(var_251);
            // best_endpoint = 2                                                              <L 932>
        }
        var_256 = wp::where(var_252, var_255, var_245);
        var_257 = wp::where(var_252, var_253, var_246);
        var_258 = wp::where(var_252, var_254, var_247);
    }
    var_259 = wp::where(var_249, var_256, var_245);
    var_260 = wp::where(var_249, var_257, var_246);
    var_261 = wp::where(var_249, var_258, var_247);
    var_262 = wp::where(var_249, var_251, var_237);
    // p = v0 + edge_dir * best_t                                                             <L 934>
    var_263 = wp::mul(var_1, var_260);
    var_264 = wp::add(var_v0, var_263);
    // return best_f, p, best_endpoint                                                        <L 936>
    ret_0 = var_261;
    ret_1 = var_264;
    ret_2 = var_259;
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:94
static CUDA_CALLABLE bool mesh_sdf_contact_passes_inner_cull_consistency_0(
    wp::float32 var_distance_world,
    wp::float32 var_inner_contact_threshold,
    wp::float32 var_midpoint_sdf,
    wp::vec_t<3, wp::float32> var_bsphere_center,
    wp::float32 var_bsphere_radius,
    wp::vec_t<3, wp::float32> var_sdf_aabb_lower,
    wp::vec_t<3, wp::float32> var_sdf_aabb_upper,
    wp::float32 var_min_sdf_scale,
    bool var_use_texture_bounds)
{
    //---------
    // primal vars
    bool var_0;
    const bool var_1 = true;
    wp::float32 var_2;
    wp::float32 var_3;
    wp::vec_t<3, wp::float32> var_4;
    wp::vec_t<3, wp::float32> var_5;
    wp::vec_t<3, wp::float32> var_6;
    wp::float32 var_7;
    wp::float32 var_8;
    bool var_9;
    const bool var_10 = false;
    bool var_11;
    //---------
    // forward
    // def mesh_sdf_contact_passes_inner_cull_consistency(                                    <L 95>
    // if distance_world >= inner_contact_threshold:                                          <L 107>
    var_0 = (var_distance_world >= var_inner_contact_threshold);
    if (var_0) {
        // return True                                                                        <L 108>
        return var_1;
    }
    // inner_threshold_unscaled = inner_contact_threshold / min_sdf_scale                     <L 110>
    var_2 = wp::div(var_inner_contact_threshold, var_min_sdf_scale);
    // culling_radius = bsphere_radius + inner_threshold_unscaled                             <L 111>
    var_3 = wp::add(var_bsphere_radius, var_2);
    // if use_texture_bounds:                                                                 <L 112>
    if (var_use_texture_bounds) {
        // clamped = wp.min(wp.max(bsphere_center, sdf_aabb_lower), sdf_aabb_upper)           <L 113>
        var_4 = wp::max(var_bsphere_center, var_sdf_aabb_lower);
        var_5 = wp::min(var_4, var_sdf_aabb_upper);
        // if wp.length_sq(bsphere_center - clamped) > culling_radius * culling_radius:       <L 114>
        var_6 = wp::sub(var_bsphere_center, var_5);
        var_7 = wp::length_sq(var_6);
        var_8 = wp::mul(var_3, var_3);
        var_9 = (var_7 > var_8);
        if (var_9) {
            // return False                                                                   <L 115>
            return var_10;
        }
    }
    // return midpoint_sdf <= culling_radius                                                  <L 117>
    var_11 = (var_midpoint_sdf <= var_3);
    return var_11;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:217
static CUDA_CALLABLE void sample_sdf_grad_using_mesh_0(
    wp::uint64 var_mesh_id,
    wp::vec_t<3, wp::float32> var_world_pos,
    wp::float32 var_max_dist,
    wp::int32 var_sign_method,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    const wp::float32 var_0 = 0.0;
    const wp::float32 var_1 = 0.0;
    const wp::float32 var_2 = 0.0;
    wp::vec_t<3, wp::float32> var_3;
    wp::mesh_query_point_t var_4;
    bool* var_5;
    bool var_6;
    wp::int32* var_7;
    wp::float32* var_8;
    wp::float32* var_9;
    wp::vec_t<3, wp::float32> var_10;
    wp::int32 var_11;
    wp::float32 var_12;
    wp::float32 var_13;
    wp::vec_t<3, wp::float32> var_14;
    wp::float32 var_15;
    const wp::float32 var_16 = 0.0;
    bool var_17;
    wp::vec_t<3, wp::float32> var_18;
    wp::float32* var_19;
    wp::vec_t<3, wp::float32> var_20;
    wp::float32 var_21;
    wp::Mesh var_22;
    wp::array_t<wp::int32>* var_23;
    wp::int32* var_24;
    const wp::int32 var_25 = 3;
    wp::int32 var_26;
    wp::int32 var_27;
    const wp::int32 var_28 = 0;
    wp::int32 var_29;
    wp::int32* var_30;
    wp::array_t<wp::int32> var_31;
    wp::int32 var_32;
    wp::int32 var_33;
    wp::array_t<wp::int32>* var_34;
    wp::int32* var_35;
    const wp::int32 var_36 = 3;
    wp::int32 var_37;
    wp::int32 var_38;
    const wp::int32 var_39 = 1;
    wp::int32 var_40;
    wp::int32* var_41;
    wp::array_t<wp::int32> var_42;
    wp::int32 var_43;
    wp::int32 var_44;
    wp::array_t<wp::int32>* var_45;
    wp::int32* var_46;
    const wp::int32 var_47 = 3;
    wp::int32 var_48;
    wp::int32 var_49;
    const wp::int32 var_50 = 2;
    wp::int32 var_51;
    wp::int32* var_52;
    wp::array_t<wp::int32> var_53;
    wp::int32 var_54;
    wp::int32 var_55;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_56;
    wp::vec_t<3, wp::float32>* var_57;
    wp::array_t<wp::vec_t<3, wp::float32>> var_58;
    wp::vec_t<3, wp::float32> var_59;
    wp::vec_t<3, wp::float32> var_60;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_61;
    wp::vec_t<3, wp::float32>* var_62;
    wp::array_t<wp::vec_t<3, wp::float32>> var_63;
    wp::vec_t<3, wp::float32> var_64;
    wp::vec_t<3, wp::float32> var_65;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_66;
    wp::vec_t<3, wp::float32>* var_67;
    wp::array_t<wp::vec_t<3, wp::float32>> var_68;
    wp::vec_t<3, wp::float32> var_69;
    wp::vec_t<3, wp::float32> var_70;
    wp::vec_t<3, wp::float32> var_71;
    wp::vec_t<3, wp::float32> var_72;
    wp::vec_t<3, wp::float32> var_73;
    wp::vec_t<3, wp::float32> var_74;
    wp::float32* var_75;
    wp::vec_t<3, wp::float32> var_76;
    wp::float32 var_77;
    wp::vec_t<3, wp::float32> var_78;
    wp::float32* var_79;
    wp::float32 var_80;
    wp::float32 var_81;
    bool var_82;
    wp::vec_t<3, wp::float32> var_83;
    bool var_84;
    const wp::float32 var_85 = 0.0;
    const wp::float32 var_86 = 0.0;
    const wp::float32 var_87 = 1.0;
    wp::vec_t<3, wp::float32> var_88;
    //---------
    // forward
    // def sample_sdf_grad_using_mesh(                                                        <L 218>
    // gradient = wp.vec3(0.0, 0.0, 0.0)                                                      <L 245>
    var_3 = wp::vec_t<3, wp::float32>(var_0, var_1, var_2);
    // res = mesh_query_point_sign(mesh_id, world_pos, max_dist, sign_method)                 <L 247>
    var_4 = mesh_query_point_sign_0(var_mesh_id, var_world_pos, var_max_dist, var_sign_method);
    // if res.result:                                                                         <L 249>
    var_5 = &((var_4).result);
    var_6 = wp::load(var_5);
    if (var_6) {
        // closest = wp.mesh_eval_position(mesh_id, res.face, res.u, res.v)                   <L 250>
        var_7 = &((var_4).face);
        var_8 = &((var_4).u);
        var_9 = &((var_4).v);
        var_11 = wp::load(var_7);
        var_12 = wp::load(var_8);
        var_13 = wp::load(var_9);
        var_10 = wp::mesh_eval_position(var_mesh_id, var_11, var_12, var_13);
        // diff = world_pos - closest                                                         <L 251>
        var_14 = wp::sub(var_world_pos, var_10);
        // dist = wp.length(diff)                                                             <L 252>
        var_15 = wp::length(var_14);
        // if dist > 0.0:                                                                     <L 254>
        var_17 = (var_15 > var_16);
        if (var_17) {
            // gradient = (diff / dist) * res.sign                                            <L 258>
            var_18 = wp::div(var_14, var_15);
            var_19 = &((var_4).sign);
            var_21 = wp::load(var_19);
            var_20 = wp::mul(var_18, var_21);
        }
        if (!var_17) {
            // mesh = wp.mesh_get(mesh_id)                                                    <L 261>
            var_22 = wp::mesh_get(var_mesh_id);
            // i0 = mesh.indices[res.face * 3 + 0]                                            <L 262>
            var_23 = &((var_22).indices);
            var_24 = &((var_4).face);
            var_27 = wp::load(var_24);
            var_26 = wp::mul(var_27, var_25);
            var_29 = wp::add(var_26, var_28);
            var_31 = wp::load(var_23);
            var_30 = wp::address(var_31, var_29);
            var_33 = wp::load(var_30);
            var_32 = wp::copy(var_33);
            // i1 = mesh.indices[res.face * 3 + 1]                                            <L 263>
            var_34 = &((var_22).indices);
            var_35 = &((var_4).face);
            var_38 = wp::load(var_35);
            var_37 = wp::mul(var_38, var_36);
            var_40 = wp::add(var_37, var_39);
            var_42 = wp::load(var_34);
            var_41 = wp::address(var_42, var_40);
            var_44 = wp::load(var_41);
            var_43 = wp::copy(var_44);
            // i2 = mesh.indices[res.face * 3 + 2]                                            <L 264>
            var_45 = &((var_22).indices);
            var_46 = &((var_4).face);
            var_49 = wp::load(var_46);
            var_48 = wp::mul(var_49, var_47);
            var_51 = wp::add(var_48, var_50);
            var_53 = wp::load(var_45);
            var_52 = wp::address(var_53, var_51);
            var_55 = wp::load(var_52);
            var_54 = wp::copy(var_55);
            // v0 = mesh.points[i0]                                                           <L 265>
            var_56 = &((var_22).points);
            var_58 = wp::load(var_56);
            var_57 = wp::address(var_58, var_32);
            var_60 = wp::load(var_57);
            var_59 = wp::copy(var_60);
            // v1 = mesh.points[i1]                                                           <L 266>
            var_61 = &((var_22).points);
            var_63 = wp::load(var_61);
            var_62 = wp::address(var_63, var_43);
            var_65 = wp::load(var_62);
            var_64 = wp::copy(var_65);
            // v2 = mesh.points[i2]                                                           <L 267>
            var_66 = &((var_22).points);
            var_68 = wp::load(var_66);
            var_67 = wp::address(var_68, var_54);
            var_70 = wp::load(var_67);
            var_69 = wp::copy(var_70);
            // face_normal = wp.normalize(wp.cross(v1 - v0, v2 - v0))                         <L 268>
            var_71 = wp::sub(var_64, var_59);
            var_72 = wp::sub(var_69, var_59);
            var_73 = wp::cross(var_71, var_72);
            var_74 = wp::normalize(var_73);
            // gradient = face_normal * res.sign                                              <L 269>
            var_75 = &((var_4).sign);
            var_77 = wp::load(var_75);
            var_76 = wp::mul(var_74, var_77);
        }
        var_78 = wp::where(var_17, var_20, var_76);
        // return dist * res.sign, gradient                                                   <L 271>
        var_79 = &((var_4).sign);
        var_81 = wp::load(var_79);
        var_80 = wp::mul(var_15, var_81);
        ret_0 = var_80;
        ret_1 = var_78;
        return;
    }
    var_82 = wp::load(var_5);
    var_84 = wp::load(var_5);
    var_83 = wp::where(var_84, var_78, var_3);
    // return max_dist, wp.vec3(0.0, 0.0, 1.0)                                                <L 274>
    var_88 = wp::vec_t<3, wp::float32>(var_85, var_86, var_87);
    ret_0 = var_max_dist;
    ret_1 = var_88;
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:1618
static CUDA_CALLABLE wp::vec_t<3, wp::float32> _texture_sample_sdf_grad_hw_impl_variant_0(
    TextureSDFData_93572308 var_sdf,
    wp::vec_t<3, wp::float32> var_local_pos,
    bool var_paired_samples)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    wp::float32 var_1;
    wp::vec_t<3, wp::float32>* var_2;
    const wp::int32 var_3 = 0;
    wp::float32 var_4;
    wp::vec_t<3, wp::float32> var_5;
    wp::vec_t<3, wp::float32>* var_6;
    const wp::int32 var_7 = 0;
    wp::float32 var_8;
    wp::vec_t<3, wp::float32> var_9;
    wp::float32 var_10;
    const wp::int32 var_11 = 1;
    wp::float32 var_12;
    wp::vec_t<3, wp::float32>* var_13;
    const wp::int32 var_14 = 1;
    wp::float32 var_15;
    wp::vec_t<3, wp::float32> var_16;
    wp::vec_t<3, wp::float32>* var_17;
    const wp::int32 var_18 = 1;
    wp::float32 var_19;
    wp::vec_t<3, wp::float32> var_20;
    wp::float32 var_21;
    const wp::int32 var_22 = 2;
    wp::float32 var_23;
    wp::vec_t<3, wp::float32>* var_24;
    const wp::int32 var_25 = 2;
    wp::float32 var_26;
    wp::vec_t<3, wp::float32> var_27;
    wp::vec_t<3, wp::float32>* var_28;
    const wp::int32 var_29 = 2;
    wp::float32 var_30;
    wp::vec_t<3, wp::float32> var_31;
    wp::float32 var_32;
    wp::vec_t<3, wp::float32> var_33;
    wp::vec_t<3, wp::float32> var_34;
    bool var_35;
    const wp::int32 var_36 = 0;
    wp::float32 var_37;
    const wp::float32 var_38 = 0.0;
    bool var_39;
    const wp::int32 var_40 = 1;
    wp::float32 var_41;
    const wp::float32 var_42 = 0.0;
    bool var_43;
    const wp::int32 var_44 = 2;
    wp::float32 var_45;
    const wp::float32 var_46 = 0.0;
    bool var_47;
    wp::float32 var_48;
    const wp::float32 var_49 = 0.0;
    bool var_50;
    wp::vec_t<3, wp::float32> var_51;
    const wp::float32 var_52 = 0.5;
    wp::vec_t<3, wp::float32>* var_53;
    const wp::int32 var_54 = 0;
    wp::float32 var_55;
    wp::vec_t<3, wp::float32> var_56;
    wp::float32 var_57;
    const wp::float32 var_58 = 0.0;
    const wp::float32 var_59 = 0.0;
    wp::vec_t<3, wp::float32> var_60;
    wp::vec_t<3, wp::float32> var_61;
    const wp::float32 var_62 = 0.0;
    const wp::float32 var_63 = 0.0;
    wp::vec_t<3, wp::float32> var_64;
    wp::vec_t<3, wp::float32> var_65;
    const wp::int32 var_66 = 0;
    wp::float32 var_67;
    wp::vec_t<3, wp::float32>* var_68;
    const wp::int32 var_69 = 0;
    wp::float32 var_70;
    wp::vec_t<3, wp::float32> var_71;
    wp::vec_t<3, wp::float32>* var_72;
    const wp::int32 var_73 = 0;
    wp::float32 var_74;
    wp::vec_t<3, wp::float32> var_75;
    wp::float32 var_76;
    const wp::int32 var_77 = 0;
    wp::float32 var_78;
    wp::vec_t<3, wp::float32>* var_79;
    const wp::int32 var_80 = 0;
    wp::float32 var_81;
    wp::vec_t<3, wp::float32> var_82;
    wp::vec_t<3, wp::float32>* var_83;
    const wp::int32 var_84 = 0;
    wp::float32 var_85;
    wp::vec_t<3, wp::float32> var_86;
    wp::float32 var_87;
    const wp::int32 var_88 = 0;
    wp::float32 var_89;
    wp::float32 var_90;
    const wp::int32 var_91 = 0;
    wp::float32 var_92;
    wp::float32 var_93;
    const wp::int32 var_94 = 1;
    wp::float32 var_95;
    const wp::int32 var_96 = 2;
    wp::float32 var_97;
    wp::vec_t<3, wp::float32> var_98;
    const wp::int32 var_99 = 1;
    wp::float32 var_100;
    const wp::int32 var_101 = 2;
    wp::float32 var_102;
    wp::vec_t<3, wp::float32> var_103;
    wp::float32 var_104;
    wp::float32 var_105;
    wp::vec_t<2, wp::float32> var_106;
    const wp::int32 var_107 = 0;
    wp::float32 var_108;
    const wp::int32 var_109 = 1;
    wp::float32 var_110;
    wp::float32 var_111;
    wp::vec_t<3, wp::float32>* var_112;
    const wp::int32 var_113 = 0;
    wp::float32 var_114;
    wp::vec_t<3, wp::float32> var_115;
    wp::float32 var_116;
    const wp::float32 var_117 = 0.5;
    wp::vec_t<3, wp::float32>* var_118;
    const wp::int32 var_119 = 1;
    wp::float32 var_120;
    wp::vec_t<3, wp::float32> var_121;
    wp::float32 var_122;
    const wp::float32 var_123 = 0.0;
    const wp::float32 var_124 = 0.0;
    wp::vec_t<3, wp::float32> var_125;
    wp::vec_t<3, wp::float32> var_126;
    const wp::float32 var_127 = 0.0;
    const wp::float32 var_128 = 0.0;
    wp::vec_t<3, wp::float32> var_129;
    wp::vec_t<3, wp::float32> var_130;
    const wp::int32 var_131 = 1;
    wp::float32 var_132;
    wp::vec_t<3, wp::float32>* var_133;
    const wp::int32 var_134 = 1;
    wp::float32 var_135;
    wp::vec_t<3, wp::float32> var_136;
    wp::vec_t<3, wp::float32>* var_137;
    const wp::int32 var_138 = 1;
    wp::float32 var_139;
    wp::vec_t<3, wp::float32> var_140;
    wp::float32 var_141;
    const wp::int32 var_142 = 1;
    wp::float32 var_143;
    wp::vec_t<3, wp::float32>* var_144;
    const wp::int32 var_145 = 1;
    wp::float32 var_146;
    wp::vec_t<3, wp::float32> var_147;
    wp::vec_t<3, wp::float32>* var_148;
    const wp::int32 var_149 = 1;
    wp::float32 var_150;
    wp::vec_t<3, wp::float32> var_151;
    wp::float32 var_152;
    const wp::int32 var_153 = 1;
    wp::float32 var_154;
    wp::float32 var_155;
    const wp::int32 var_156 = 1;
    wp::float32 var_157;
    wp::float32 var_158;
    const wp::int32 var_159 = 0;
    wp::float32 var_160;
    const wp::int32 var_161 = 2;
    wp::float32 var_162;
    wp::vec_t<3, wp::float32> var_163;
    const wp::int32 var_164 = 0;
    wp::float32 var_165;
    const wp::int32 var_166 = 2;
    wp::float32 var_167;
    wp::vec_t<3, wp::float32> var_168;
    wp::float32 var_169;
    wp::float32 var_170;
    wp::vec_t<2, wp::float32> var_171;
    const wp::int32 var_172 = 0;
    wp::float32 var_173;
    const wp::int32 var_174 = 1;
    wp::float32 var_175;
    wp::float32 var_176;
    wp::vec_t<3, wp::float32>* var_177;
    const wp::int32 var_178 = 1;
    wp::float32 var_179;
    wp::vec_t<3, wp::float32> var_180;
    wp::float32 var_181;
    const wp::float32 var_182 = 0.5;
    wp::vec_t<3, wp::float32>* var_183;
    const wp::int32 var_184 = 2;
    wp::float32 var_185;
    wp::vec_t<3, wp::float32> var_186;
    wp::float32 var_187;
    const wp::float32 var_188 = 0.0;
    const wp::float32 var_189 = 0.0;
    wp::vec_t<3, wp::float32> var_190;
    wp::vec_t<3, wp::float32> var_191;
    const wp::float32 var_192 = 0.0;
    const wp::float32 var_193 = 0.0;
    wp::vec_t<3, wp::float32> var_194;
    wp::vec_t<3, wp::float32> var_195;
    const wp::int32 var_196 = 2;
    wp::float32 var_197;
    wp::vec_t<3, wp::float32>* var_198;
    const wp::int32 var_199 = 2;
    wp::float32 var_200;
    wp::vec_t<3, wp::float32> var_201;
    wp::vec_t<3, wp::float32>* var_202;
    const wp::int32 var_203 = 2;
    wp::float32 var_204;
    wp::vec_t<3, wp::float32> var_205;
    wp::float32 var_206;
    const wp::int32 var_207 = 2;
    wp::float32 var_208;
    wp::vec_t<3, wp::float32>* var_209;
    const wp::int32 var_210 = 2;
    wp::float32 var_211;
    wp::vec_t<3, wp::float32> var_212;
    wp::vec_t<3, wp::float32>* var_213;
    const wp::int32 var_214 = 2;
    wp::float32 var_215;
    wp::vec_t<3, wp::float32> var_216;
    wp::float32 var_217;
    const wp::int32 var_218 = 2;
    wp::float32 var_219;
    wp::float32 var_220;
    const wp::int32 var_221 = 2;
    wp::float32 var_222;
    wp::float32 var_223;
    const wp::int32 var_224 = 0;
    wp::float32 var_225;
    const wp::int32 var_226 = 1;
    wp::float32 var_227;
    wp::vec_t<3, wp::float32> var_228;
    const wp::int32 var_229 = 0;
    wp::float32 var_230;
    const wp::int32 var_231 = 1;
    wp::float32 var_232;
    wp::vec_t<3, wp::float32> var_233;
    wp::float32 var_234;
    wp::float32 var_235;
    wp::vec_t<2, wp::float32> var_236;
    const wp::int32 var_237 = 0;
    wp::float32 var_238;
    const wp::int32 var_239 = 1;
    wp::float32 var_240;
    wp::float32 var_241;
    wp::vec_t<3, wp::float32>* var_242;
    const wp::int32 var_243 = 2;
    wp::float32 var_244;
    wp::vec_t<3, wp::float32> var_245;
    wp::float32 var_246;
    wp::vec_t<3, wp::float32> var_247;
    //---------
    // forward
    // def _texture_sample_sdf_grad_hw_impl_variant(                                          <L 1619>
    // clamped = wp.vec3(                                                                     <L 1634>
    // wp.clamp(local_pos[0], sdf.sdf_box_lower[0], sdf.sdf_box_upper[0]),                    <L 1635>
    var_1 = wp::extract(var_local_pos, var_0);
    var_2 = &((var_sdf).sdf_box_lower);
    var_5 = wp::load(var_2);
    var_4 = wp::extract(var_5, var_3);
    var_6 = &((var_sdf).sdf_box_upper);
    var_9 = wp::load(var_6);
    var_8 = wp::extract(var_9, var_7);
    var_10 = wp::clamp(var_1, var_4, var_8);
    // wp.clamp(local_pos[1], sdf.sdf_box_lower[1], sdf.sdf_box_upper[1]),                    <L 1636>
    var_12 = wp::extract(var_local_pos, var_11);
    var_13 = &((var_sdf).sdf_box_lower);
    var_16 = wp::load(var_13);
    var_15 = wp::extract(var_16, var_14);
    var_17 = &((var_sdf).sdf_box_upper);
    var_20 = wp::load(var_17);
    var_19 = wp::extract(var_20, var_18);
    var_21 = wp::clamp(var_12, var_15, var_19);
    // wp.clamp(local_pos[2], sdf.sdf_box_lower[2], sdf.sdf_box_upper[2]),                    <L 1637>
    var_23 = wp::extract(var_local_pos, var_22);
    var_24 = &((var_sdf).sdf_box_lower);
    var_27 = wp::load(var_24);
    var_26 = wp::extract(var_27, var_25);
    var_28 = &((var_sdf).sdf_box_upper);
    var_31 = wp::load(var_28);
    var_30 = wp::extract(var_31, var_29);
    var_32 = wp::clamp(var_23, var_26, var_30);
    var_33 = wp::vec_t<3, wp::float32>(var_10, var_21, var_32);
    // diff = local_pos - clamped                                                             <L 1639>
    var_34 = wp::sub(var_local_pos, var_33);
    // if diff[0] != 0.0 or diff[1] != 0.0 or diff[2] != 0.0:                                 <L 1643>
    var_37 = wp::extract(var_34, var_36);
    var_39 = (var_37 != var_38);
    var_35 = var_39;
    if (!var_35) {
        var_41 = wp::extract(var_34, var_40);
        var_43 = (var_41 != var_42);
        var_35 = var_35 || var_43;
    }
    if (!var_35) {
        var_45 = wp::extract(var_34, var_44);
        var_47 = (var_45 != var_46);
        var_35 = var_35 || var_47;
    }
    if (var_35) {
        // diff_mag = wp.length(diff)                                                         <L 1644>
        var_48 = wp::length(var_34);
        // if diff_mag > 0.0:                                                                 <L 1645>
        var_50 = (var_48 > var_49);
        if (var_50) {
            // return diff / diff_mag                                                         <L 1646>
            var_51 = wp::div(var_34, var_48);
            return var_51;
        }
    }
    // h_x = 0.5 / sdf.inv_sdf_dx[0]                                                          <L 1648>
    var_53 = &((var_sdf).inv_sdf_dx);
    var_56 = wp::load(var_53);
    var_55 = wp::extract(var_56, var_54);
    var_57 = wp::div(var_52, var_55);
    // x_pos0 = local_pos + wp.vec3(h_x, 0.0, 0.0)                                            <L 1649>
    var_60 = wp::vec_t<3, wp::float32>(var_57, var_58, var_59);
    var_61 = wp::add(var_local_pos, var_60);
    // x_pos1 = local_pos - wp.vec3(h_x, 0.0, 0.0)                                            <L 1650>
    var_64 = wp::vec_t<3, wp::float32>(var_57, var_62, var_63);
    var_65 = wp::sub(var_local_pos, var_64);
    // x_coord0 = wp.clamp(x_pos0[0], sdf.sdf_box_lower[0], sdf.sdf_box_upper[0])             <L 1651>
    var_67 = wp::extract(var_61, var_66);
    var_68 = &((var_sdf).sdf_box_lower);
    var_71 = wp::load(var_68);
    var_70 = wp::extract(var_71, var_69);
    var_72 = &((var_sdf).sdf_box_upper);
    var_75 = wp::load(var_72);
    var_74 = wp::extract(var_75, var_73);
    var_76 = wp::clamp(var_67, var_70, var_74);
    // x_coord1 = wp.clamp(x_pos1[0], sdf.sdf_box_lower[0], sdf.sdf_box_upper[0])             <L 1652>
    var_78 = wp::extract(var_65, var_77);
    var_79 = &((var_sdf).sdf_box_lower);
    var_82 = wp::load(var_79);
    var_81 = wp::extract(var_82, var_80);
    var_83 = &((var_sdf).sdf_box_upper);
    var_86 = wp::load(var_83);
    var_85 = wp::extract(var_86, var_84);
    var_87 = wp::clamp(var_78, var_81, var_85);
    // x_delta0 = x_pos0[0] - x_coord0                                                        <L 1653>
    var_89 = wp::extract(var_61, var_88);
    var_90 = wp::sub(var_89, var_76);
    // x_delta1 = x_pos1[0] - x_coord1                                                        <L 1654>
    var_92 = wp::extract(var_65, var_91);
    var_93 = wp::sub(var_92, var_87);
    // x_values = _texture_sample_sdf_hw_clamped_pair_variant(                                <L 1655>
    // sdf,                                                                                   <L 1656>
    // wp.vec3(x_coord0, x_pos0[1], x_pos0[2]),                                               <L 1657>
    var_95 = wp::extract(var_61, var_94);
    var_97 = wp::extract(var_61, var_96);
    var_98 = wp::vec_t<3, wp::float32>(var_76, var_95, var_97);
    // wp.vec3(x_coord1, x_pos1[1], x_pos1[2]),                                               <L 1658>
    var_100 = wp::extract(var_65, var_99);
    var_102 = wp::extract(var_65, var_101);
    var_103 = wp::vec_t<3, wp::float32>(var_87, var_100, var_102);
    // x_delta0 * x_delta0,                                                                   <L 1659>
    var_104 = wp::mul(var_90, var_90);
    // x_delta1 * x_delta1,                                                                   <L 1660>
    var_105 = wp::mul(var_93, var_93);
    // paired_samples,                                                                        <L 1661>
    var_106 = _texture_sample_sdf_hw_clamped_pair_variant_0(var_sdf, var_98, var_103, var_104, var_105, var_paired_samples);
    // gx = (x_values[0] - x_values[1]) * sdf.inv_sdf_dx[0]                                   <L 1663>
    var_108 = wp::extract(var_106, var_107);
    var_110 = wp::extract(var_106, var_109);
    var_111 = wp::sub(var_108, var_110);
    var_112 = &((var_sdf).inv_sdf_dx);
    var_115 = wp::load(var_112);
    var_114 = wp::extract(var_115, var_113);
    var_116 = wp::mul(var_111, var_114);
    // h_y = 0.5 / sdf.inv_sdf_dx[1]                                                          <L 1664>
    var_118 = &((var_sdf).inv_sdf_dx);
    var_121 = wp::load(var_118);
    var_120 = wp::extract(var_121, var_119);
    var_122 = wp::div(var_117, var_120);
    // y_pos0 = local_pos + wp.vec3(0.0, h_y, 0.0)                                            <L 1665>
    var_125 = wp::vec_t<3, wp::float32>(var_123, var_122, var_124);
    var_126 = wp::add(var_local_pos, var_125);
    // y_pos1 = local_pos - wp.vec3(0.0, h_y, 0.0)                                            <L 1666>
    var_129 = wp::vec_t<3, wp::float32>(var_127, var_122, var_128);
    var_130 = wp::sub(var_local_pos, var_129);
    // y_coord0 = wp.clamp(y_pos0[1], sdf.sdf_box_lower[1], sdf.sdf_box_upper[1])             <L 1667>
    var_132 = wp::extract(var_126, var_131);
    var_133 = &((var_sdf).sdf_box_lower);
    var_136 = wp::load(var_133);
    var_135 = wp::extract(var_136, var_134);
    var_137 = &((var_sdf).sdf_box_upper);
    var_140 = wp::load(var_137);
    var_139 = wp::extract(var_140, var_138);
    var_141 = wp::clamp(var_132, var_135, var_139);
    // y_coord1 = wp.clamp(y_pos1[1], sdf.sdf_box_lower[1], sdf.sdf_box_upper[1])             <L 1668>
    var_143 = wp::extract(var_130, var_142);
    var_144 = &((var_sdf).sdf_box_lower);
    var_147 = wp::load(var_144);
    var_146 = wp::extract(var_147, var_145);
    var_148 = &((var_sdf).sdf_box_upper);
    var_151 = wp::load(var_148);
    var_150 = wp::extract(var_151, var_149);
    var_152 = wp::clamp(var_143, var_146, var_150);
    // y_delta0 = y_pos0[1] - y_coord0                                                        <L 1669>
    var_154 = wp::extract(var_126, var_153);
    var_155 = wp::sub(var_154, var_141);
    // y_delta1 = y_pos1[1] - y_coord1                                                        <L 1670>
    var_157 = wp::extract(var_130, var_156);
    var_158 = wp::sub(var_157, var_152);
    // y_values = _texture_sample_sdf_hw_clamped_pair_variant(                                <L 1671>
    // sdf,                                                                                   <L 1672>
    // wp.vec3(y_pos0[0], y_coord0, y_pos0[2]),                                               <L 1673>
    var_160 = wp::extract(var_126, var_159);
    var_162 = wp::extract(var_126, var_161);
    var_163 = wp::vec_t<3, wp::float32>(var_160, var_141, var_162);
    // wp.vec3(y_pos1[0], y_coord1, y_pos1[2]),                                               <L 1674>
    var_165 = wp::extract(var_130, var_164);
    var_167 = wp::extract(var_130, var_166);
    var_168 = wp::vec_t<3, wp::float32>(var_165, var_152, var_167);
    // y_delta0 * y_delta0,                                                                   <L 1675>
    var_169 = wp::mul(var_155, var_155);
    // y_delta1 * y_delta1,                                                                   <L 1676>
    var_170 = wp::mul(var_158, var_158);
    // paired_samples,                                                                        <L 1677>
    var_171 = _texture_sample_sdf_hw_clamped_pair_variant_0(var_sdf, var_163, var_168, var_169, var_170, var_paired_samples);
    // gy = (y_values[0] - y_values[1]) * sdf.inv_sdf_dx[1]                                   <L 1679>
    var_173 = wp::extract(var_171, var_172);
    var_175 = wp::extract(var_171, var_174);
    var_176 = wp::sub(var_173, var_175);
    var_177 = &((var_sdf).inv_sdf_dx);
    var_180 = wp::load(var_177);
    var_179 = wp::extract(var_180, var_178);
    var_181 = wp::mul(var_176, var_179);
    // h_z = 0.5 / sdf.inv_sdf_dx[2]                                                          <L 1680>
    var_183 = &((var_sdf).inv_sdf_dx);
    var_186 = wp::load(var_183);
    var_185 = wp::extract(var_186, var_184);
    var_187 = wp::div(var_182, var_185);
    // z_pos0 = local_pos + wp.vec3(0.0, 0.0, h_z)                                            <L 1681>
    var_190 = wp::vec_t<3, wp::float32>(var_188, var_189, var_187);
    var_191 = wp::add(var_local_pos, var_190);
    // z_pos1 = local_pos - wp.vec3(0.0, 0.0, h_z)                                            <L 1682>
    var_194 = wp::vec_t<3, wp::float32>(var_192, var_193, var_187);
    var_195 = wp::sub(var_local_pos, var_194);
    // z_coord0 = wp.clamp(z_pos0[2], sdf.sdf_box_lower[2], sdf.sdf_box_upper[2])             <L 1683>
    var_197 = wp::extract(var_191, var_196);
    var_198 = &((var_sdf).sdf_box_lower);
    var_201 = wp::load(var_198);
    var_200 = wp::extract(var_201, var_199);
    var_202 = &((var_sdf).sdf_box_upper);
    var_205 = wp::load(var_202);
    var_204 = wp::extract(var_205, var_203);
    var_206 = wp::clamp(var_197, var_200, var_204);
    // z_coord1 = wp.clamp(z_pos1[2], sdf.sdf_box_lower[2], sdf.sdf_box_upper[2])             <L 1684>
    var_208 = wp::extract(var_195, var_207);
    var_209 = &((var_sdf).sdf_box_lower);
    var_212 = wp::load(var_209);
    var_211 = wp::extract(var_212, var_210);
    var_213 = &((var_sdf).sdf_box_upper);
    var_216 = wp::load(var_213);
    var_215 = wp::extract(var_216, var_214);
    var_217 = wp::clamp(var_208, var_211, var_215);
    // z_delta0 = z_pos0[2] - z_coord0                                                        <L 1685>
    var_219 = wp::extract(var_191, var_218);
    var_220 = wp::sub(var_219, var_206);
    // z_delta1 = z_pos1[2] - z_coord1                                                        <L 1686>
    var_222 = wp::extract(var_195, var_221);
    var_223 = wp::sub(var_222, var_217);
    // z_values = _texture_sample_sdf_hw_clamped_pair_variant(                                <L 1687>
    // sdf,                                                                                   <L 1688>
    // wp.vec3(z_pos0[0], z_pos0[1], z_coord0),                                               <L 1689>
    var_225 = wp::extract(var_191, var_224);
    var_227 = wp::extract(var_191, var_226);
    var_228 = wp::vec_t<3, wp::float32>(var_225, var_227, var_206);
    // wp.vec3(z_pos1[0], z_pos1[1], z_coord1),                                               <L 1690>
    var_230 = wp::extract(var_195, var_229);
    var_232 = wp::extract(var_195, var_231);
    var_233 = wp::vec_t<3, wp::float32>(var_230, var_232, var_217);
    // z_delta0 * z_delta0,                                                                   <L 1691>
    var_234 = wp::mul(var_220, var_220);
    // z_delta1 * z_delta1,                                                                   <L 1692>
    var_235 = wp::mul(var_223, var_223);
    // paired_samples,                                                                        <L 1693>
    var_236 = _texture_sample_sdf_hw_clamped_pair_variant_0(var_sdf, var_228, var_233, var_234, var_235, var_paired_samples);
    // gz = (z_values[0] - z_values[1]) * sdf.inv_sdf_dx[2]                                   <L 1695>
    var_238 = wp::extract(var_236, var_237);
    var_240 = wp::extract(var_236, var_239);
    var_241 = wp::sub(var_238, var_240);
    var_242 = &((var_sdf).inv_sdf_dx);
    var_245 = wp::load(var_242);
    var_244 = wp::extract(var_245, var_243);
    var_246 = wp::mul(var_241, var_244);
    // return wp.vec3(gx, gy, gz)                                                             <L 1696>
    var_247 = wp::vec_t<3, wp::float32>(var_116, var_181, var_246);
    return var_247;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:1699
static CUDA_CALLABLE wp::vec_t<3, wp::float32> _texture_sample_sdf_grad_hw_impl_0(
    TextureSDFData_93572308 var_sdf,
    wp::vec_t<3, wp::float32> var_local_pos)
{
    //---------
    // primal vars
    bool* var_0;
    wp::vec_t<3, wp::float32> var_1;
    bool var_2;
    //---------
    // forward
    // def _texture_sample_sdf_grad_hw_impl(                                                  <L 1700>
    // return _texture_sample_sdf_grad_hw_impl_variant(sdf, local_pos, sdf.paired_samples)       <L 1705>
    var_0 = &((var_sdf).paired_samples);
    var_2 = wp::load(var_0);
    var_1 = _texture_sample_sdf_grad_hw_impl_variant_0(var_sdf, var_local_pos, var_2);
    return var_1;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:1735
static CUDA_CALLABLE wp::vec_t<3, wp::float32> texture_sample_sdf_grad_only_hw_0(
    TextureSDFData_93572308 var_sdf,
    wp::vec_t<3, wp::float32> var_local_pos)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    //---------
    // forward
    // def texture_sample_sdf_grad_only_hw(                                                   <L 1736>
    // return _texture_sample_sdf_grad_hw_impl(sdf, local_pos)                                <L 1759>
    var_0 = _texture_sample_sdf_grad_hw_impl_0(var_sdf, var_local_pos);
    return var_0;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:154
static CUDA_CALLABLE void scale_sdf_result_to_world_0(
    wp::float32 var_distance,
    wp::vec_t<3, wp::float32> var_gradient,
    wp::vec_t<3, wp::float32> var_sdf_scale,
    wp::vec_t<3, wp::float32> var_inv_sdf_scale,
    wp::float32 var_min_sdf_scale,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    wp::float32 var_0;
    wp::vec_t<3, wp::float32> var_1;
    //---------
    // forward
    // def scale_sdf_result_to_world(                                                         <L 155>
    // scaled_distance = distance * min_sdf_scale                                             <L 176>
    var_0 = wp::mul(var_distance, var_min_sdf_scale);
    // scaled_grad = wp.cw_mul(gradient, inv_sdf_scale)                                       <L 180>
    var_1 = wp::cw_mul(var_gradient, var_inv_sdf_scale);
    // return scaled_distance, scaled_grad                                                    <L 182>
    ret_0 = var_0;
    ret_1 = var_1;
    return;
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction.py:104
static CUDA_CALLABLE wp::uint32 float_flip_0(
    wp::float32 f)
{

uint32_t i = reinterpret_cast<uint32_t&>(f);
uint32_t mask = (uint32_t)(-(int)(i >> 31)) | 0x80000000;
return i ^ mask;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:509
static CUDA_CALLABLE wp::uint64 _make_preprune_probe_det_0(
    wp::float32 var_score,
    wp::int32 var_fingerprint)
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
    const wp::uint64 var_13 = 1048575ull;
    wp::uint64 var_14;
    //---------
    // forward
    // def _make_preprune_probe_det(score: float, fingerprint: int) -> wp.uint64:             <L 510>
    // return (                                                                               <L 522>
    // (wp.uint64(float_flip(score) >> wp.uint32(wp.static(SCORE_SHIFT))) << wp.uint64(42))       <L 523>
    var_0 = float_flip_0(var_score);
    var_2 = wp::uint32(var_1);
    var_3 = wp::rshift(var_0, var_2);
    var_4 = wp::uint64(var_3);
    var_5 = 42ull;
    var_6 = wp::lshift(var_4, var_5);
    // | ((wp.uint64(fingerprint) & FINGERPRINT_MASK) << CONTACT_ID_BITS)                     <L 524>
    var_7 = wp::uint64(var_fingerprint);
    var_9 = wp::bit_and(var_7, var_8);
    var_11 = wp::lshift(var_9, var_10);
    var_12 = wp::bit_or(var_6, var_11);
    // | CONTACT_ID_MASK                                                                      <L 525>
    var_14 = wp::bit_or(var_12, var_13);
    return var_14;
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:544
static CUDA_CALLABLE wp::uint64 _make_spatial_preprune_probe_det_0(
    wp::float32 var_score,
    bool var_is_inner,
    wp::int32 var_fingerprint)
{
    //---------
    // primal vars
    wp::uint64 var_0;
    wp::uint64 var_1;
    wp::uint64 var_2;
    wp::uint32 var_3;
    const wp::int32 var_4 = 11;
    wp::uint32 var_5;
    wp::uint32 var_6;
    wp::uint64 var_7;
    wp::uint64 var_8;
    wp::uint64 var_9;
    wp::uint64 var_10;
    wp::uint64 var_11;
    wp::uint64 var_12;
    wp::uint64 var_13;
    const wp::uint64 var_14 = 4194303ull;
    wp::uint64 var_15;
    const wp::uint64 var_16 = 20ull;
    wp::uint64 var_17;
    wp::uint64 var_18;
    const wp::uint64 var_19 = 1048575ull;
    wp::uint64 var_20;
    //---------
    // forward
    // def _make_spatial_preprune_probe_det(score: float, is_inner: bool, fingerprint: int) -> wp.uint64:       <L 545>
    // priority = wp.uint64(0)                                                                <L 547>
    var_0 = 0ull;
    // if is_inner:                                                                           <L 548>
    if (var_is_inner) {
        // priority = wp.uint64(1)                                                            <L 549>
        var_1 = 1ull;
    }
    var_2 = wp::where(var_is_inner, var_1, var_0);
    // score_bits = wp.uint64(float_flip(score) >> wp.uint32(wp.static(SCORE_SHIFT + 1)))       <L 550>
    var_3 = float_flip_0(var_score);
    var_5 = wp::uint32(var_4);
    var_6 = wp::rshift(var_3, var_5);
    var_7 = wp::uint64(var_6);
    // return (                                                                               <L 551>
    // (priority << wp.uint64(63))                                                            <L 552>
    var_8 = 63ull;
    var_9 = wp::lshift(var_2, var_8);
    // | (score_bits << wp.uint64(42))                                                        <L 553>
    var_10 = 42ull;
    var_11 = wp::lshift(var_7, var_10);
    var_12 = wp::bit_or(var_9, var_11);
    // | ((wp.uint64(fingerprint) & FINGERPRINT_MASK) << CONTACT_ID_BITS)                     <L 554>
    var_13 = wp::uint64(var_fingerprint);
    var_15 = wp::bit_and(var_13, var_14);
    var_17 = wp::lshift(var_15, var_16);
    var_18 = wp::bit_or(var_12, var_17);
    // | CONTACT_ID_MASK                                                                      <L 555>
    var_20 = wp::bit_or(var_18, var_19);
    return var_20;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:425
static CUDA_CALLABLE wp::uint64 _make_spatial_preprune_probe_fast_0(
    wp::float32 var_score,
    bool var_is_inner,
    wp::int32 var_fingerprint)
{
    //---------
    // primal vars
    wp::uint64 var_0;
    wp::uint64 var_1;
    wp::uint64 var_2;
    wp::uint32 var_3;
    const wp::int32 var_4 = 1;
    wp::uint32 var_5;
    wp::uint32 var_6;
    wp::uint64 var_7;
    wp::uint64 var_8;
    wp::uint64 var_9;
    wp::uint64 var_10;
    wp::uint64 var_11;
    wp::uint64 var_12;
    wp::uint64 var_13;
    wp::uint64 var_14;
    //---------
    // forward
    // def _make_spatial_preprune_probe_fast(score: float, is_inner: bool, fingerprint: int) -> wp.uint64:       <L 426>
    // priority = wp.uint64(0)                                                                <L 428>
    var_0 = 0ull;
    // if is_inner:                                                                           <L 429>
    if (var_is_inner) {
        // priority = wp.uint64(1)                                                            <L 430>
        var_1 = 1ull;
    }
    var_2 = wp::where(var_is_inner, var_1, var_0);
    // score_bits = wp.uint64(float_flip(score) >> wp.uint32(1))                              <L 431>
    var_3 = float_flip_0(var_score);
    var_5 = wp::uint32(var_4);
    var_6 = wp::rshift(var_3, var_5);
    var_7 = wp::uint64(var_6);
    // return (priority << wp.uint64(63)) | (score_bits << wp.uint64(32)) | wp.uint64(0xFFFFFFFF)       <L 432>
    var_8 = 63ull;
    var_9 = wp::lshift(var_2, var_8);
    var_10 = 32ull;
    var_11 = wp::lshift(var_7, var_10);
    var_12 = wp::bit_or(var_9, var_11);
    var_13 = 4294967295ull;
    var_14 = wp::bit_or(var_12, var_13);
    return var_14;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:606
static CUDA_CALLABLE wp::uint64 make_spatial_preprune_probe_0(
    wp::float32 var_score,
    bool var_is_inner,
    wp::int32 var_fingerprint,
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
    // def make_spatial_preprune_probe(score: float, is_inner: bool, fingerprint: int, deterministic: int) -> wp.uint64:       <L 607>
    // if deterministic != 0:                                                                 <L 609>
    var_1 = (var_deterministic != var_0);
    if (var_1) {
        // return _make_spatial_preprune_probe_det(score, is_inner, fingerprint)              <L 610>
        var_2 = _make_spatial_preprune_probe_det_0(var_score, var_is_inner, var_fingerprint);
        return var_2;
    }
    // return _make_spatial_preprune_probe_fast(score, is_inner, fingerprint)                 <L 611>
    var_3 = _make_spatial_preprune_probe_fast_0(var_score, var_is_inner, var_fingerprint);
    return var_3;
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:529
static CUDA_CALLABLE wp::uint64 _make_spatial_contact_value_det_0(
    wp::float32 var_score,
    bool var_is_inner,
    wp::int32 var_fingerprint,
    wp::int32 var_contact_id)
{
    //---------
    // primal vars
    wp::uint64 var_0;
    wp::uint64 var_1;
    wp::uint64 var_2;
    wp::uint32 var_3;
    const wp::int32 var_4 = 11;
    wp::uint32 var_5;
    wp::uint32 var_6;
    wp::uint64 var_7;
    wp::uint64 var_8;
    wp::uint64 var_9;
    wp::uint64 var_10;
    wp::uint64 var_11;
    wp::uint64 var_12;
    wp::uint64 var_13;
    const wp::uint64 var_14 = 4194303ull;
    wp::uint64 var_15;
    const wp::uint64 var_16 = 20ull;
    wp::uint64 var_17;
    wp::uint64 var_18;
    wp::uint64 var_19;
    const wp::uint64 var_20 = 1048575ull;
    wp::uint64 var_21;
    wp::uint64 var_22;
    //---------
    // forward
    // def _make_spatial_contact_value_det(score: float, is_inner: bool, fingerprint: int, contact_id: int) -> wp.uint64:       <L 530>
    // priority = wp.uint64(0)                                                                <L 532>
    var_0 = 0ull;
    // if is_inner:                                                                           <L 533>
    if (var_is_inner) {
        // priority = wp.uint64(1)                                                            <L 534>
        var_1 = 1ull;
    }
    var_2 = wp::where(var_is_inner, var_1, var_0);
    // score_bits = wp.uint64(float_flip(score) >> wp.uint32(wp.static(SCORE_SHIFT + 1)))       <L 535>
    var_3 = float_flip_0(var_score);
    var_5 = wp::uint32(var_4);
    var_6 = wp::rshift(var_3, var_5);
    var_7 = wp::uint64(var_6);
    // return (                                                                               <L 536>
    // (priority << wp.uint64(63))                                                            <L 537>
    var_8 = 63ull;
    var_9 = wp::lshift(var_2, var_8);
    // | (score_bits << wp.uint64(42))                                                        <L 538>
    var_10 = 42ull;
    var_11 = wp::lshift(var_7, var_10);
    var_12 = wp::bit_or(var_9, var_11);
    // | ((wp.uint64(fingerprint) & FINGERPRINT_MASK) << CONTACT_ID_BITS)                     <L 539>
    var_13 = wp::uint64(var_fingerprint);
    var_15 = wp::bit_and(var_13, var_14);
    var_17 = wp::lshift(var_15, var_16);
    var_18 = wp::bit_or(var_12, var_17);
    // | (wp.uint64(contact_id) & CONTACT_ID_MASK)                                            <L 540>
    var_19 = wp::uint64(var_contact_id);
    var_21 = wp::bit_and(var_19, var_20);
    var_22 = wp::bit_or(var_18, var_21);
    return var_22;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:415
static CUDA_CALLABLE wp::uint64 _make_spatial_contact_value_fast_0(
    wp::float32 var_score,
    bool var_is_inner,
    wp::int32 var_fingerprint,
    wp::int32 var_contact_id)
{
    //---------
    // primal vars
    wp::uint64 var_0;
    wp::uint64 var_1;
    wp::uint64 var_2;
    wp::uint32 var_3;
    const wp::int32 var_4 = 1;
    wp::uint32 var_5;
    wp::uint32 var_6;
    wp::uint64 var_7;
    wp::uint64 var_8;
    wp::uint64 var_9;
    wp::uint64 var_10;
    wp::uint64 var_11;
    wp::uint64 var_12;
    wp::uint64 var_13;
    wp::uint64 var_14;
    //---------
    // forward
    // def _make_spatial_contact_value_fast(score: float, is_inner: bool, fingerprint: int, contact_id: int) -> wp.uint64:       <L 416>
    // priority = wp.uint64(0)                                                                <L 418>
    var_0 = 0ull;
    // if is_inner:                                                                           <L 419>
    if (var_is_inner) {
        // priority = wp.uint64(1)                                                            <L 420>
        var_1 = 1ull;
    }
    var_2 = wp::where(var_is_inner, var_1, var_0);
    // score_bits = wp.uint64(float_flip(score) >> wp.uint32(1))                              <L 421>
    var_3 = float_flip_0(var_score);
    var_5 = wp::uint32(var_4);
    var_6 = wp::rshift(var_3, var_5);
    var_7 = wp::uint64(var_6);
    // return (priority << wp.uint64(63)) | (score_bits << wp.uint64(32)) | wp.uint64(contact_id)       <L 422>
    var_8 = 63ull;
    var_9 = wp::lshift(var_2, var_8);
    var_10 = 32ull;
    var_11 = wp::lshift(var_7, var_10);
    var_12 = wp::bit_or(var_9, var_11);
    var_13 = wp::uint64(var_contact_id);
    var_14 = wp::bit_or(var_12, var_13);
    return var_14;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:592
static CUDA_CALLABLE wp::uint64 make_spatial_contact_value_0(
    wp::float32 var_score,
    bool var_is_inner,
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
    // def make_spatial_contact_value(                                                        <L 593>
    // if deterministic != 0:                                                                 <L 601>
    var_1 = (var_deterministic != var_0);
    if (var_1) {
        // return _make_spatial_contact_value_det(score, is_inner, fingerprint, contact_id)       <L 602>
        var_2 = _make_spatial_contact_value_det_0(var_score, var_is_inner, var_fingerprint, var_contact_id);
        return var_2;
    }
    // return _make_spatial_contact_value_fast(score, is_inner, fingerprint, contact_id)       <L 603>
    var_3 = _make_spatial_contact_value_fast_0(var_score, var_is_inner, var_fingerprint, var_contact_id);
    return var_3;
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:1509
static CUDA_CALLABLE wp::int32 export_and_reduce_contact_centered_two_spatial_depths_0(
    wp::int32 var_shape_a,
    wp::int32 var_shape_b,
    wp::vec_t<3, wp::float32> var_position,
    wp::vec_t<3, wp::float32> var_normal,
    wp::float32 var_depth,
    wp::int32 var_fingerprint,
    wp::vec_t<3, wp::float32> var_centered_position,
    wp::float32 var_inner_spatial_depth,
    wp::float32 var_outer_spatial_depth,
    wp::vec_t<3, wp::float32> var_position_local,
    wp::vec_t<3, wp::float32> var_aabb_lower_voxel,
    wp::vec_t<3, wp::float32> var_aabb_upper_voxel,
    wp::vec_t<3, wp::int32> var_voxel_res,
    GlobalContactReducerData_0c09c456 var_reducer_data)
{
    //---------
    // primal vars
    wp::int32* var_0;
    wp::int32 var_1;
    wp::int32 var_2;
    bool var_3;
    bool var_4;
    bool var_5;
    const wp::int32 var_6 = -1;
    wp::int32 var_7;
    wp::vec_t<2, wp::float32> var_8;
    wp::uint64 var_9;
    wp::array_t<wp::uint64>* var_10;
    wp::array_t<wp::int32>* var_11;
    wp::int32 var_12;
    wp::array_t<wp::uint64> var_13;
    wp::array_t<wp::int32> var_14;
    const bool var_15 = false;
    const wp::int32 var_16 = 0;
    bool var_17;
    wp::int32* var_18;
    const wp::int32 var_19 = 0;
    bool var_20;
    wp::int32 var_21;
    wp::float32 var_22;
    wp::uint64 var_23;
    wp::float32 var_24;
    const wp::int32 var_25 = 0;
    const wp::int32 var_26 = 0;
    wp::uint64 var_27;
    wp::uint64 var_28;
    wp::array_t<wp::uint64>* var_29;
    const wp::int32 var_30 = 6;
    wp::int32 var_31;
    wp::int32 var_32;
    wp::uint64* var_33;
    wp::array_t<wp::uint64> var_34;
    bool var_35;
    wp::uint64 var_36;
    const bool var_37 = true;
    bool var_38;
    bool var_39;
    const wp::int32 var_40 = 0;
    bool var_41;
    wp::vec_t<2, wp::float32> var_42;
    wp::float32 var_43;
    wp::int32* var_44;
    wp::uint64 var_45;
    wp::int32 var_46;
    wp::array_t<wp::uint64>* var_47;
    wp::int32 var_48;
    wp::int32 var_49;
    wp::uint64* var_50;
    wp::array_t<wp::uint64> var_51;
    bool var_52;
    wp::uint64 var_53;
    const bool var_54 = true;
    bool var_55;
    bool var_56;
    const wp::int32 var_57 = 1;
    bool var_58;
    wp::vec_t<2, wp::float32> var_59;
    wp::float32 var_60;
    wp::int32* var_61;
    wp::uint64 var_62;
    wp::int32 var_63;
    wp::array_t<wp::uint64>* var_64;
    wp::int32 var_65;
    wp::int32 var_66;
    wp::uint64* var_67;
    wp::array_t<wp::uint64> var_68;
    bool var_69;
    wp::uint64 var_70;
    const bool var_71 = true;
    bool var_72;
    bool var_73;
    wp::vec_t<2, wp::float32> var_74;
    wp::float32 var_75;
    wp::uint64 var_76;
    const wp::int32 var_77 = 2;
    bool var_78;
    wp::vec_t<2, wp::float32> var_79;
    wp::float32 var_80;
    wp::int32* var_81;
    wp::uint64 var_82;
    wp::int32 var_83;
    wp::array_t<wp::uint64>* var_84;
    wp::int32 var_85;
    wp::int32 var_86;
    wp::uint64* var_87;
    wp::array_t<wp::uint64> var_88;
    bool var_89;
    wp::uint64 var_90;
    const bool var_91 = true;
    bool var_92;
    bool var_93;
    wp::vec_t<2, wp::float32> var_94;
    wp::float32 var_95;
    wp::uint64 var_96;
    const wp::int32 var_97 = 3;
    bool var_98;
    wp::vec_t<2, wp::float32> var_99;
    wp::float32 var_100;
    wp::int32* var_101;
    wp::uint64 var_102;
    wp::int32 var_103;
    wp::array_t<wp::uint64>* var_104;
    wp::int32 var_105;
    wp::int32 var_106;
    wp::uint64* var_107;
    wp::array_t<wp::uint64> var_108;
    bool var_109;
    wp::uint64 var_110;
    const bool var_111 = true;
    bool var_112;
    bool var_113;
    wp::vec_t<2, wp::float32> var_114;
    wp::float32 var_115;
    wp::uint64 var_116;
    const wp::int32 var_117 = 4;
    bool var_118;
    wp::vec_t<2, wp::float32> var_119;
    wp::float32 var_120;
    wp::int32* var_121;
    wp::uint64 var_122;
    wp::int32 var_123;
    wp::array_t<wp::uint64>* var_124;
    wp::int32 var_125;
    wp::int32 var_126;
    wp::uint64* var_127;
    wp::array_t<wp::uint64> var_128;
    bool var_129;
    wp::uint64 var_130;
    const bool var_131 = true;
    bool var_132;
    bool var_133;
    wp::vec_t<2, wp::float32> var_134;
    wp::float32 var_135;
    wp::uint64 var_136;
    const wp::int32 var_137 = 5;
    bool var_138;
    wp::vec_t<2, wp::float32> var_139;
    wp::float32 var_140;
    wp::int32* var_141;
    wp::uint64 var_142;
    wp::int32 var_143;
    wp::array_t<wp::uint64>* var_144;
    wp::int32 var_145;
    wp::int32 var_146;
    wp::uint64* var_147;
    wp::array_t<wp::uint64> var_148;
    bool var_149;
    wp::uint64 var_150;
    const bool var_151 = true;
    bool var_152;
    bool var_153;
    wp::vec_t<2, wp::float32> var_154;
    wp::float32 var_155;
    wp::uint64 var_156;
    wp::array_t<wp::int32>* var_157;
    const wp::int32 var_158 = 0;
    const wp::int32 var_159 = 1;
    wp::int32 var_160;
    wp::array_t<wp::int32> var_161;
    bool var_162;
    wp::int32 var_163;
    const wp::int32 var_164 = 0;
    const wp::int32 var_165 = 99;
    wp::int32 var_166;
    const wp::int32 var_167 = 7;
    wp::int32 var_168;
    wp::int32 var_169;
    const wp::int32 var_170 = 20;
    wp::int32 var_171;
    wp::uint64 var_172;
    const wp::int32 var_173 = -1;
    bool var_174;
    bool var_175;
    wp::array_t<wp::uint64>* var_176;
    wp::array_t<wp::int32>* var_177;
    wp::int32 var_178;
    wp::array_t<wp::uint64> var_179;
    wp::array_t<wp::int32> var_180;
    const wp::int32 var_181 = 0;
    bool var_182;
    wp::int32* var_183;
    const wp::int32 var_184 = 0;
    bool var_185;
    wp::int32 var_186;
    wp::float32 var_187;
    wp::uint64 var_188;
    wp::float32 var_189;
    const wp::int32 var_190 = 0;
    const wp::int32 var_191 = 0;
    wp::uint64 var_192;
    wp::uint64 var_193;
    wp::array_t<wp::uint64>* var_194;
    wp::int32 var_195;
    wp::int32 var_196;
    wp::uint64* var_197;
    wp::array_t<wp::uint64> var_198;
    bool var_199;
    wp::uint64 var_200;
    const bool var_201 = true;
    bool var_202;
    bool var_203;
    bool var_204;
    wp::int32 var_205;
    bool var_206;
    const wp::int32 var_207 = -1;
    bool var_208;
    const wp::int32 var_209 = 0;
    bool var_210;
    wp::array_t<wp::uint64>* var_211;
    wp::array_t<wp::int32>* var_212;
    wp::int32 var_213;
    wp::array_t<wp::uint64> var_214;
    wp::array_t<wp::int32> var_215;
    wp::int32 var_216;
    const wp::int32 var_217 = 0;
    wp::int32 var_218;
    wp::vec_t<8, wp::uint64> var_219;
    bool var_220;
    const wp::int32 var_221 = 0;
    bool var_222;
    const wp::int32 var_223 = 0;
    wp::vec_t<2, wp::float32> var_224;
    wp::float32 var_225;
    const bool var_226 = true;
    const wp::int32 var_227 = 0;
    wp::int32* var_228;
    wp::uint64 var_229;
    wp::int32 var_230;
    wp::array_t<wp::uint64>* var_231;
    wp::uint64 var_232;
    wp::array_t<wp::uint64> var_233;
    bool var_234;
    const wp::int32 var_235 = 1;
    wp::int32 var_236;
    wp::int32 var_237;
    wp::int32 var_238;
    const wp::int32 var_239 = 1;
    wp::vec_t<2, wp::float32> var_240;
    wp::float32 var_241;
    const bool var_242 = true;
    const wp::int32 var_243 = 0;
    wp::int32* var_244;
    wp::uint64 var_245;
    wp::int32 var_246;
    wp::array_t<wp::uint64>* var_247;
    wp::uint64 var_248;
    wp::array_t<wp::uint64> var_249;
    bool var_250;
    const wp::int32 var_251 = 1;
    wp::int32 var_252;
    wp::int32 var_253;
    wp::int32 var_254;
    const wp::int32 var_255 = 2;
    wp::vec_t<2, wp::float32> var_256;
    wp::float32 var_257;
    const bool var_258 = true;
    const wp::int32 var_259 = 0;
    wp::int32* var_260;
    wp::uint64 var_261;
    wp::int32 var_262;
    wp::array_t<wp::uint64>* var_263;
    wp::uint64 var_264;
    wp::array_t<wp::uint64> var_265;
    bool var_266;
    const wp::int32 var_267 = 1;
    wp::int32 var_268;
    wp::int32 var_269;
    wp::int32 var_270;
    const wp::int32 var_271 = 3;
    wp::vec_t<2, wp::float32> var_272;
    wp::float32 var_273;
    const bool var_274 = true;
    const wp::int32 var_275 = 0;
    wp::int32* var_276;
    wp::uint64 var_277;
    wp::int32 var_278;
    wp::array_t<wp::uint64>* var_279;
    wp::uint64 var_280;
    wp::array_t<wp::uint64> var_281;
    bool var_282;
    const wp::int32 var_283 = 1;
    wp::int32 var_284;
    wp::int32 var_285;
    wp::int32 var_286;
    const wp::int32 var_287 = 4;
    wp::vec_t<2, wp::float32> var_288;
    wp::float32 var_289;
    const bool var_290 = true;
    const wp::int32 var_291 = 0;
    wp::int32* var_292;
    wp::uint64 var_293;
    wp::int32 var_294;
    wp::array_t<wp::uint64>* var_295;
    wp::uint64 var_296;
    wp::array_t<wp::uint64> var_297;
    bool var_298;
    const wp::int32 var_299 = 1;
    wp::int32 var_300;
    wp::int32 var_301;
    wp::int32 var_302;
    const wp::int32 var_303 = 5;
    wp::vec_t<2, wp::float32> var_304;
    wp::float32 var_305;
    const bool var_306 = true;
    const wp::int32 var_307 = 0;
    wp::int32* var_308;
    wp::uint64 var_309;
    wp::int32 var_310;
    wp::array_t<wp::uint64>* var_311;
    wp::uint64 var_312;
    wp::array_t<wp::uint64> var_313;
    bool var_314;
    const wp::int32 var_315 = 1;
    wp::int32 var_316;
    wp::int32 var_317;
    wp::int32 var_318;
    wp::float32 var_319;
    const wp::int32 var_320 = 0;
    wp::int32* var_321;
    wp::uint64 var_322;
    wp::int32 var_323;
    const wp::int32 var_324 = 6;
    wp::array_t<wp::uint64>* var_325;
    wp::uint64 var_326;
    wp::array_t<wp::uint64> var_327;
    bool var_328;
    const wp::int32 var_329 = 1;
    const wp::int32 var_330 = 6;
    wp::int32 var_331;
    wp::int32 var_332;
    const wp::int32 var_333 = 6;
    wp::int32 var_334;
    const wp::int32 var_335 = 0;
    bool var_336;
    const wp::int32 var_337 = 0;
    wp::vec_t<2, wp::float32> var_338;
    wp::float32 var_339;
    const bool var_340 = false;
    const wp::int32 var_341 = 0;
    wp::int32* var_342;
    wp::uint64 var_343;
    wp::int32 var_344;
    wp::array_t<wp::uint64>* var_345;
    wp::uint64 var_346;
    wp::array_t<wp::uint64> var_347;
    bool var_348;
    const wp::int32 var_349 = 1;
    wp::int32 var_350;
    wp::int32 var_351;
    wp::int32 var_352;
    const wp::int32 var_353 = 1;
    wp::vec_t<2, wp::float32> var_354;
    wp::float32 var_355;
    const bool var_356 = false;
    const wp::int32 var_357 = 0;
    wp::int32* var_358;
    wp::uint64 var_359;
    wp::int32 var_360;
    wp::array_t<wp::uint64>* var_361;
    wp::uint64 var_362;
    wp::array_t<wp::uint64> var_363;
    bool var_364;
    const wp::int32 var_365 = 1;
    wp::int32 var_366;
    wp::int32 var_367;
    wp::int32 var_368;
    const wp::int32 var_369 = 2;
    wp::vec_t<2, wp::float32> var_370;
    wp::float32 var_371;
    const bool var_372 = false;
    const wp::int32 var_373 = 0;
    wp::int32* var_374;
    wp::uint64 var_375;
    wp::int32 var_376;
    wp::array_t<wp::uint64>* var_377;
    wp::uint64 var_378;
    wp::array_t<wp::uint64> var_379;
    bool var_380;
    const wp::int32 var_381 = 1;
    wp::int32 var_382;
    wp::int32 var_383;
    wp::int32 var_384;
    const wp::int32 var_385 = 3;
    wp::vec_t<2, wp::float32> var_386;
    wp::float32 var_387;
    const bool var_388 = false;
    const wp::int32 var_389 = 0;
    wp::int32* var_390;
    wp::uint64 var_391;
    wp::int32 var_392;
    wp::array_t<wp::uint64>* var_393;
    wp::uint64 var_394;
    wp::array_t<wp::uint64> var_395;
    bool var_396;
    const wp::int32 var_397 = 1;
    wp::int32 var_398;
    wp::int32 var_399;
    wp::int32 var_400;
    const wp::int32 var_401 = 4;
    wp::vec_t<2, wp::float32> var_402;
    wp::float32 var_403;
    const bool var_404 = false;
    const wp::int32 var_405 = 0;
    wp::int32* var_406;
    wp::uint64 var_407;
    wp::int32 var_408;
    wp::array_t<wp::uint64>* var_409;
    wp::uint64 var_410;
    wp::array_t<wp::uint64> var_411;
    bool var_412;
    const wp::int32 var_413 = 1;
    wp::int32 var_414;
    wp::int32 var_415;
    wp::int32 var_416;
    const wp::int32 var_417 = 5;
    wp::vec_t<2, wp::float32> var_418;
    wp::float32 var_419;
    const bool var_420 = false;
    const wp::int32 var_421 = 0;
    wp::int32* var_422;
    wp::uint64 var_423;
    wp::int32 var_424;
    wp::array_t<wp::uint64>* var_425;
    wp::uint64 var_426;
    wp::array_t<wp::uint64> var_427;
    bool var_428;
    const wp::int32 var_429 = 1;
    wp::int32 var_430;
    wp::int32 var_431;
    wp::int32 var_432;
    wp::int32 var_433;
    wp::vec_t<2, wp::float32> var_434;
    wp::float32 var_435;
    wp::int32 var_436;
    wp::int32 var_437;
    wp::vec_t<2, wp::float32> var_438;
    wp::float32 var_439;
    wp::int32 var_440;
    wp::uint64 var_441;
    wp::uint64 var_442;
    bool var_443;
    const wp::int32 var_444 = 0;
    bool var_445;
    wp::float32 var_446;
    const wp::int32 var_447 = 0;
    wp::int32* var_448;
    wp::uint64 var_449;
    wp::int32 var_450;
    wp::array_t<wp::uint64>* var_451;
    wp::uint64 var_452;
    wp::array_t<wp::uint64> var_453;
    bool var_454;
    const wp::int32 var_455 = 1;
    const wp::int32 var_456 = 7;
    wp::int32 var_457;
    wp::int32 var_458;
    const wp::int32 var_459 = 7;
    wp::int32 var_460;
    wp::int32 var_461;
    wp::uint64 var_462;
    wp::uint64 var_463;
    const wp::int32 var_464 = 0;
    bool var_465;
    const wp::int32 var_466 = -1;
    const bool var_467 = false;
    const wp::int32 var_468 = 0;
    bool var_469;
    const wp::int32 var_470 = 0;
    bool var_471;
    bool var_472;
    const wp::int32 var_473 = 1;
    wp::int32 var_474;
    wp::int32 var_475;
    const wp::int32 var_476 = 0;
    bool var_477;
    wp::vec_t<2, wp::float32> var_478;
    wp::float32 var_479;
    const wp::int32 var_480 = 0;
    wp::int32* var_481;
    wp::uint64 var_482;
    wp::int32 var_483;
    wp::array_t<wp::uint64>* var_484;
    wp::int32 var_485;
    wp::int32 var_486;
    wp::uint64* var_487;
    wp::array_t<wp::uint64> var_488;
    bool var_489;
    wp::uint64 var_490;
    const bool var_491 = true;
    bool var_492;
    wp::vec_t<2, wp::float32> var_493;
    wp::float32 var_494;
    wp::uint64 var_495;
    bool var_496;
    const wp::int32 var_497 = 1;
    bool var_498;
    bool var_499;
    const wp::int32 var_500 = 1;
    wp::int32 var_501;
    wp::int32 var_502;
    const wp::int32 var_503 = 0;
    bool var_504;
    wp::vec_t<2, wp::float32> var_505;
    wp::float32 var_506;
    const wp::int32 var_507 = 0;
    wp::int32* var_508;
    wp::uint64 var_509;
    wp::int32 var_510;
    wp::array_t<wp::uint64>* var_511;
    wp::int32 var_512;
    wp::int32 var_513;
    wp::uint64* var_514;
    wp::array_t<wp::uint64> var_515;
    bool var_516;
    wp::uint64 var_517;
    const bool var_518 = true;
    bool var_519;
    wp::vec_t<2, wp::float32> var_520;
    wp::float32 var_521;
    wp::uint64 var_522;
    bool var_523;
    const wp::int32 var_524 = 2;
    bool var_525;
    bool var_526;
    const wp::int32 var_527 = 1;
    wp::int32 var_528;
    wp::int32 var_529;
    const wp::int32 var_530 = 0;
    bool var_531;
    wp::vec_t<2, wp::float32> var_532;
    wp::float32 var_533;
    const wp::int32 var_534 = 0;
    wp::int32* var_535;
    wp::uint64 var_536;
    wp::int32 var_537;
    wp::array_t<wp::uint64>* var_538;
    wp::int32 var_539;
    wp::int32 var_540;
    wp::uint64* var_541;
    wp::array_t<wp::uint64> var_542;
    bool var_543;
    wp::uint64 var_544;
    const bool var_545 = true;
    bool var_546;
    wp::vec_t<2, wp::float32> var_547;
    wp::float32 var_548;
    wp::uint64 var_549;
    bool var_550;
    const wp::int32 var_551 = 3;
    bool var_552;
    bool var_553;
    const wp::int32 var_554 = 1;
    wp::int32 var_555;
    wp::int32 var_556;
    const wp::int32 var_557 = 0;
    bool var_558;
    wp::vec_t<2, wp::float32> var_559;
    wp::float32 var_560;
    const wp::int32 var_561 = 0;
    wp::int32* var_562;
    wp::uint64 var_563;
    wp::int32 var_564;
    wp::array_t<wp::uint64>* var_565;
    wp::int32 var_566;
    wp::int32 var_567;
    wp::uint64* var_568;
    wp::array_t<wp::uint64> var_569;
    bool var_570;
    wp::uint64 var_571;
    const bool var_572 = true;
    bool var_573;
    wp::vec_t<2, wp::float32> var_574;
    wp::float32 var_575;
    wp::uint64 var_576;
    bool var_577;
    const wp::int32 var_578 = 4;
    bool var_579;
    bool var_580;
    const wp::int32 var_581 = 1;
    wp::int32 var_582;
    wp::int32 var_583;
    const wp::int32 var_584 = 0;
    bool var_585;
    wp::vec_t<2, wp::float32> var_586;
    wp::float32 var_587;
    const wp::int32 var_588 = 0;
    wp::int32* var_589;
    wp::uint64 var_590;
    wp::int32 var_591;
    wp::array_t<wp::uint64>* var_592;
    wp::int32 var_593;
    wp::int32 var_594;
    wp::uint64* var_595;
    wp::array_t<wp::uint64> var_596;
    bool var_597;
    wp::uint64 var_598;
    const bool var_599 = true;
    bool var_600;
    wp::vec_t<2, wp::float32> var_601;
    wp::float32 var_602;
    wp::uint64 var_603;
    bool var_604;
    const wp::int32 var_605 = 5;
    bool var_606;
    bool var_607;
    const wp::int32 var_608 = 1;
    wp::int32 var_609;
    wp::int32 var_610;
    const wp::int32 var_611 = 0;
    bool var_612;
    wp::vec_t<2, wp::float32> var_613;
    wp::float32 var_614;
    const wp::int32 var_615 = 0;
    wp::int32* var_616;
    wp::uint64 var_617;
    wp::int32 var_618;
    wp::array_t<wp::uint64>* var_619;
    wp::int32 var_620;
    wp::int32 var_621;
    wp::uint64* var_622;
    wp::array_t<wp::uint64> var_623;
    bool var_624;
    wp::uint64 var_625;
    const bool var_626 = true;
    bool var_627;
    wp::vec_t<2, wp::float32> var_628;
    wp::float32 var_629;
    wp::uint64 var_630;
    bool var_631;
    bool var_632;
    bool var_633;
    const wp::int32 var_634 = 1;
    const wp::int32 var_635 = 6;
    wp::int32 var_636;
    wp::int32 var_637;
    const wp::int32 var_638 = 0;
    bool var_639;
    wp::float32 var_640;
    const wp::int32 var_641 = 0;
    wp::int32* var_642;
    wp::uint64 var_643;
    wp::int32 var_644;
    wp::array_t<wp::uint64>* var_645;
    const wp::int32 var_646 = 6;
    wp::int32 var_647;
    wp::int32 var_648;
    wp::uint64* var_649;
    wp::array_t<wp::uint64> var_650;
    bool var_651;
    wp::uint64 var_652;
    const bool var_653 = true;
    bool var_654;
    wp::uint64 var_655;
    bool var_656;
    wp::int32 var_657;
    wp::vec_t<2, wp::float32> var_658;
    wp::float32 var_659;
    wp::uint64 var_660;
    bool var_661;
    bool var_662;
    bool var_663;
    const wp::int32 var_664 = 0;
    bool var_665;
    const wp::int32 var_666 = 1;
    const wp::int32 var_667 = 7;
    wp::int32 var_668;
    wp::int32 var_669;
    const wp::int32 var_670 = 0;
    bool var_671;
    wp::float32 var_672;
    const wp::int32 var_673 = 0;
    wp::int32* var_674;
    wp::uint64 var_675;
    wp::int32 var_676;
    wp::array_t<wp::uint64>* var_677;
    wp::int32 var_678;
    wp::int32 var_679;
    wp::uint64* var_680;
    wp::array_t<wp::uint64> var_681;
    bool var_682;
    wp::uint64 var_683;
    const bool var_684 = true;
    bool var_685;
    wp::uint64 var_686;
    bool var_687;
    bool var_688;
    const wp::int32 var_689 = -1;
    wp::int32 var_690;
    const wp::int32 var_691 = 0;
    bool var_692;
    const wp::int32 var_693 = 0;
    bool var_694;
    const wp::int32 var_695 = 0;
    const wp::int32 var_696 = 1;
    wp::int32 var_697;
    wp::int32 var_698;
    const wp::int32 var_699 = 0;
    bool var_700;
    wp::vec_t<2, wp::float32> var_701;
    wp::float32 var_702;
    const wp::int32 var_703 = 0;
    wp::int32* var_704;
    wp::uint64 var_705;
    wp::int32 var_706;
    wp::uint64 var_707;
    wp::array_t<wp::uint64>* var_708;
    wp::array_t<wp::uint64> var_709;
    wp::vec_t<2, wp::float32> var_710;
    wp::float32 var_711;
    wp::uint64 var_712;
    const wp::int32 var_713 = 1;
    const wp::int32 var_714 = 1;
    wp::int32 var_715;
    wp::int32 var_716;
    const wp::int32 var_717 = 0;
    bool var_718;
    wp::vec_t<2, wp::float32> var_719;
    wp::float32 var_720;
    const wp::int32 var_721 = 0;
    wp::int32* var_722;
    wp::uint64 var_723;
    wp::int32 var_724;
    wp::uint64 var_725;
    wp::array_t<wp::uint64>* var_726;
    wp::array_t<wp::uint64> var_727;
    wp::vec_t<2, wp::float32> var_728;
    wp::float32 var_729;
    wp::uint64 var_730;
    const wp::int32 var_731 = 2;
    const wp::int32 var_732 = 1;
    wp::int32 var_733;
    wp::int32 var_734;
    const wp::int32 var_735 = 0;
    bool var_736;
    wp::vec_t<2, wp::float32> var_737;
    wp::float32 var_738;
    const wp::int32 var_739 = 0;
    wp::int32* var_740;
    wp::uint64 var_741;
    wp::int32 var_742;
    wp::uint64 var_743;
    wp::array_t<wp::uint64>* var_744;
    wp::array_t<wp::uint64> var_745;
    wp::vec_t<2, wp::float32> var_746;
    wp::float32 var_747;
    wp::uint64 var_748;
    const wp::int32 var_749 = 3;
    const wp::int32 var_750 = 1;
    wp::int32 var_751;
    wp::int32 var_752;
    const wp::int32 var_753 = 0;
    bool var_754;
    wp::vec_t<2, wp::float32> var_755;
    wp::float32 var_756;
    const wp::int32 var_757 = 0;
    wp::int32* var_758;
    wp::uint64 var_759;
    wp::int32 var_760;
    wp::uint64 var_761;
    wp::array_t<wp::uint64>* var_762;
    wp::array_t<wp::uint64> var_763;
    wp::vec_t<2, wp::float32> var_764;
    wp::float32 var_765;
    wp::uint64 var_766;
    const wp::int32 var_767 = 4;
    const wp::int32 var_768 = 1;
    wp::int32 var_769;
    wp::int32 var_770;
    const wp::int32 var_771 = 0;
    bool var_772;
    wp::vec_t<2, wp::float32> var_773;
    wp::float32 var_774;
    const wp::int32 var_775 = 0;
    wp::int32* var_776;
    wp::uint64 var_777;
    wp::int32 var_778;
    wp::uint64 var_779;
    wp::array_t<wp::uint64>* var_780;
    wp::array_t<wp::uint64> var_781;
    wp::vec_t<2, wp::float32> var_782;
    wp::float32 var_783;
    wp::uint64 var_784;
    const wp::int32 var_785 = 5;
    const wp::int32 var_786 = 1;
    wp::int32 var_787;
    wp::int32 var_788;
    const wp::int32 var_789 = 0;
    bool var_790;
    wp::vec_t<2, wp::float32> var_791;
    wp::float32 var_792;
    const wp::int32 var_793 = 0;
    wp::int32* var_794;
    wp::uint64 var_795;
    wp::int32 var_796;
    wp::uint64 var_797;
    wp::array_t<wp::uint64>* var_798;
    wp::array_t<wp::uint64> var_799;
    wp::vec_t<2, wp::float32> var_800;
    wp::float32 var_801;
    wp::uint64 var_802;
    bool var_803;
    const wp::int32 var_804 = 1;
    const wp::int32 var_805 = 6;
    wp::int32 var_806;
    wp::int32 var_807;
    const wp::int32 var_808 = 0;
    bool var_809;
    wp::float32 var_810;
    const wp::int32 var_811 = 0;
    wp::int32* var_812;
    wp::uint64 var_813;
    wp::int32 var_814;
    const wp::int32 var_815 = 6;
    const wp::int32 var_816 = 6;
    wp::uint64 var_817;
    wp::array_t<wp::uint64>* var_818;
    wp::array_t<wp::uint64> var_819;
    wp::uint64 var_820;
    wp::int32 var_821;
    wp::vec_t<2, wp::float32> var_822;
    wp::float32 var_823;
    wp::uint64 var_824;
    bool var_825;
    const wp::int32 var_826 = 0;
    bool var_827;
    const wp::int32 var_828 = 1;
    const wp::int32 var_829 = 7;
    wp::int32 var_830;
    wp::int32 var_831;
    const wp::int32 var_832 = 0;
    bool var_833;
    wp::float32 var_834;
    const wp::int32 var_835 = 0;
    wp::int32* var_836;
    wp::uint64 var_837;
    wp::int32 var_838;
    const wp::int32 var_839 = 7;
    wp::uint64 var_840;
    wp::array_t<wp::uint64>* var_841;
    wp::array_t<wp::uint64> var_842;
    wp::uint64 var_843;
    const wp::int32 var_844 = -1;
    wp::int32 var_845;
    wp::vec_t<2, wp::float32> var_846;
    wp::float32 var_847;
    wp::uint64 var_848;
    bool var_849;
    const wp::int32 var_850 = 0;
    bool var_851;
    const wp::int32 var_852 = 0;
    wp::vec_t<2, wp::float32> var_853;
    wp::float32 var_854;
    const bool var_855 = true;
    wp::int32* var_856;
    wp::uint64 var_857;
    wp::int32 var_858;
    wp::array_t<wp::uint64>* var_859;
    wp::array_t<wp::uint64> var_860;
    const wp::int32 var_861 = 1;
    wp::vec_t<2, wp::float32> var_862;
    wp::float32 var_863;
    const bool var_864 = true;
    wp::int32* var_865;
    wp::uint64 var_866;
    wp::int32 var_867;
    wp::array_t<wp::uint64>* var_868;
    wp::array_t<wp::uint64> var_869;
    const wp::int32 var_870 = 2;
    wp::vec_t<2, wp::float32> var_871;
    wp::float32 var_872;
    const bool var_873 = true;
    wp::int32* var_874;
    wp::uint64 var_875;
    wp::int32 var_876;
    wp::array_t<wp::uint64>* var_877;
    wp::array_t<wp::uint64> var_878;
    const wp::int32 var_879 = 3;
    wp::vec_t<2, wp::float32> var_880;
    wp::float32 var_881;
    const bool var_882 = true;
    wp::int32* var_883;
    wp::uint64 var_884;
    wp::int32 var_885;
    wp::array_t<wp::uint64>* var_886;
    wp::array_t<wp::uint64> var_887;
    const wp::int32 var_888 = 4;
    wp::vec_t<2, wp::float32> var_889;
    wp::float32 var_890;
    const bool var_891 = true;
    wp::int32* var_892;
    wp::uint64 var_893;
    wp::int32 var_894;
    wp::array_t<wp::uint64>* var_895;
    wp::array_t<wp::uint64> var_896;
    const wp::int32 var_897 = 5;
    wp::vec_t<2, wp::float32> var_898;
    wp::float32 var_899;
    const bool var_900 = true;
    wp::int32* var_901;
    wp::uint64 var_902;
    wp::int32 var_903;
    wp::array_t<wp::uint64>* var_904;
    wp::array_t<wp::uint64> var_905;
    wp::float32 var_906;
    wp::int32* var_907;
    wp::uint64 var_908;
    wp::int32 var_909;
    const wp::int32 var_910 = 6;
    wp::array_t<wp::uint64>* var_911;
    wp::array_t<wp::uint64> var_912;
    const wp::int32 var_913 = 0;
    bool var_914;
    const wp::int32 var_915 = 0;
    wp::vec_t<2, wp::float32> var_916;
    wp::float32 var_917;
    const bool var_918 = false;
    wp::int32* var_919;
    wp::uint64 var_920;
    wp::int32 var_921;
    wp::array_t<wp::uint64>* var_922;
    wp::array_t<wp::uint64> var_923;
    const wp::int32 var_924 = 1;
    wp::vec_t<2, wp::float32> var_925;
    wp::float32 var_926;
    const bool var_927 = false;
    wp::int32* var_928;
    wp::uint64 var_929;
    wp::int32 var_930;
    wp::array_t<wp::uint64>* var_931;
    wp::array_t<wp::uint64> var_932;
    const wp::int32 var_933 = 2;
    wp::vec_t<2, wp::float32> var_934;
    wp::float32 var_935;
    const bool var_936 = false;
    wp::int32* var_937;
    wp::uint64 var_938;
    wp::int32 var_939;
    wp::array_t<wp::uint64>* var_940;
    wp::array_t<wp::uint64> var_941;
    const wp::int32 var_942 = 3;
    wp::vec_t<2, wp::float32> var_943;
    wp::float32 var_944;
    const bool var_945 = false;
    wp::int32* var_946;
    wp::uint64 var_947;
    wp::int32 var_948;
    wp::array_t<wp::uint64>* var_949;
    wp::array_t<wp::uint64> var_950;
    const wp::int32 var_951 = 4;
    wp::vec_t<2, wp::float32> var_952;
    wp::float32 var_953;
    const bool var_954 = false;
    wp::int32* var_955;
    wp::uint64 var_956;
    wp::int32 var_957;
    wp::array_t<wp::uint64>* var_958;
    wp::array_t<wp::uint64> var_959;
    const wp::int32 var_960 = 5;
    wp::vec_t<2, wp::float32> var_961;
    wp::float32 var_962;
    const bool var_963 = false;
    wp::int32* var_964;
    wp::uint64 var_965;
    wp::int32 var_966;
    wp::array_t<wp::uint64>* var_967;
    wp::array_t<wp::uint64> var_968;
    wp::int32 var_969;
    wp::vec_t<2, wp::float32> var_970;
    wp::float32 var_971;
    wp::int32 var_972;
    wp::vec_t<2, wp::float32> var_973;
    wp::float32 var_974;
    wp::uint64 var_975;
    const wp::int32 var_976 = 0;
    bool var_977;
    wp::array_t<wp::uint64>* var_978;
    wp::array_t<wp::int32>* var_979;
    wp::int32 var_980;
    wp::array_t<wp::uint64> var_981;
    wp::array_t<wp::int32> var_982;
    wp::int32 var_983;
    const wp::int32 var_984 = 0;
    bool var_985;
    wp::float32 var_986;
    wp::int32* var_987;
    wp::uint64 var_988;
    wp::int32 var_989;
    wp::array_t<wp::uint64>* var_990;
    wp::array_t<wp::uint64> var_991;
    wp::array_t<wp::int32>* var_992;
    const wp::int32 var_993 = 0;
    const wp::int32 var_994 = 1;
    wp::int32 var_995;
    wp::array_t<wp::int32> var_996;
    wp::int32 var_997;
    //---------
    // forward
    // def export_and_reduce_contact_centered_two_spatial_depths(                             <L 1510>
    // ht_capacity = reducer_data.ht_capacity                                                 <L 1532>
    var_0 = &((var_reducer_data).ht_capacity);
    var_2 = wp::load(var_0);
    var_1 = wp::copy(var_2);
    // use_inner = depth < inner_spatial_depth                                                <L 1533>
    var_3 = (var_depth < var_inner_spatial_depth);
    // use_outer = depth < outer_spatial_depth                                                <L 1534>
    var_4 = (var_depth < var_outer_spatial_depth);
    // if not use_outer:                                                                      <L 1536>
    var_5 = wp::unot(var_4);
    if (var_5) {
        // return -1                                                                          <L 1537>
        return var_6;
    }
    // bin_id = get_slot(normal)                                                              <L 1540>
    var_7 = get_slot_0(var_normal);
    // pos_2d = project_point_to_plane(bin_id, centered_position)                             <L 1541>
    var_8 = project_point_to_plane_0(var_7, var_centered_position);
    // key = make_contact_key(shape_a, shape_b, bin_id)                                       <L 1542>
    var_9 = make_contact_key_0(var_shape_a, var_shape_b, var_7);
    // entry_idx = hashtable_find_or_insert(key, reducer_data.ht_keys, reducer_data.ht_active_slots)       <L 1544>
    var_10 = &((var_reducer_data).ht_keys);
    var_11 = &((var_reducer_data).ht_active_slots);
    var_13 = wp::load(var_10);
    var_14 = wp::load(var_11);
    var_12 = hashtable_find_or_insert_0(var_9, var_13, var_14);
    // might_win = False                                                                      <L 1545>
    // if entry_idx >= 0:                                                                     <L 1547>
    var_17 = (var_12 >= var_16);
    if (var_17) {
        // if use_inner:                                                                      <L 1548>
        if (var_3) {
            // if reducer_data.deterministic != 0:                                            <L 1549>
            var_18 = &((var_reducer_data).deterministic);
            var_21 = wp::load(var_18);
            var_20 = (var_21 != var_19);
            if (var_20) {
                // max_depth_probe = _make_preprune_probe_det(-depth, fingerprint)            <L 1550>
                var_22 = wp::neg(var_depth);
                var_23 = _make_preprune_probe_det_0(var_22, var_fingerprint);
            }
            if (!var_20) {
                // max_depth_probe = _make_contact_value_fast(-depth, 0, 0)                   <L 1552>
                var_24 = wp::neg(var_depth);
                var_27 = _make_contact_value_fast_0(var_24, var_25, var_26);
            }
            var_28 = wp::where(var_20, var_23, var_27);
            // if reducer_data.ht_values[wp.static(NUM_SPATIAL_DIRECTIONS) * ht_capacity + entry_idx] < max_depth_probe:       <L 1553>
            var_29 = &((var_reducer_data).ht_values);
            var_31 = wp::mul(var_30, var_1);
            var_32 = wp::add(var_31, var_12);
            var_34 = wp::load(var_29);
            var_33 = wp::address(var_34, var_32);
            var_36 = wp::load(var_33);
            var_35 = (var_36 < var_28);
            if (var_35) {
                // might_win = True                                                           <L 1554>
            }
            var_38 = wp::where(var_35, var_37, var_15);
        }
        var_39 = wp::where(var_3, var_38, var_15);
        // for dir_i in range(wp.static(NUM_SPATIAL_DIRECTIONS)):                             <L 1556>
        // if not might_win:                                                                  <L 1557>
        var_41 = wp::unot(var_39);
        if (var_41) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1558>
            var_42 = get_spatial_direction_2d_0(var_40);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1559>
            var_43 = wp::dot(var_8, var_42);
            // probe = make_spatial_preprune_probe(score, use_inner, fingerprint, reducer_data.deterministic)       <L 1560>
            var_44 = &((var_reducer_data).deterministic);
            var_46 = wp::load(var_44);
            var_45 = make_spatial_preprune_probe_0(var_43, var_3, var_fingerprint, var_46);
            // if reducer_data.ht_values[dir_i * ht_capacity + entry_idx] < probe:            <L 1561>
            var_47 = &((var_reducer_data).ht_values);
            var_48 = wp::mul(var_40, var_1);
            var_49 = wp::add(var_48, var_12);
            var_51 = wp::load(var_47);
            var_50 = wp::address(var_51, var_49);
            var_53 = wp::load(var_50);
            var_52 = (var_53 < var_45);
            if (var_52) {
                // might_win = True                                                           <L 1562>
            }
            var_55 = wp::where(var_52, var_54, var_39);
        }
        var_56 = wp::where(var_41, var_55, var_39);
        // if not might_win:                                                                  <L 1557>
        var_58 = wp::unot(var_56);
        if (var_58) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1558>
            var_59 = get_spatial_direction_2d_0(var_57);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1559>
            var_60 = wp::dot(var_8, var_59);
            // probe = make_spatial_preprune_probe(score, use_inner, fingerprint, reducer_data.deterministic)       <L 1560>
            var_61 = &((var_reducer_data).deterministic);
            var_63 = wp::load(var_61);
            var_62 = make_spatial_preprune_probe_0(var_60, var_3, var_fingerprint, var_63);
            // if reducer_data.ht_values[dir_i * ht_capacity + entry_idx] < probe:            <L 1561>
            var_64 = &((var_reducer_data).ht_values);
            var_65 = wp::mul(var_57, var_1);
            var_66 = wp::add(var_65, var_12);
            var_68 = wp::load(var_64);
            var_67 = wp::address(var_68, var_66);
            var_70 = wp::load(var_67);
            var_69 = (var_70 < var_62);
            if (var_69) {
                // might_win = True                                                           <L 1562>
            }
            var_72 = wp::where(var_69, var_71, var_56);
        }
        var_73 = wp::where(var_58, var_72, var_56);
        var_74 = wp::where(var_58, var_59, var_42);
        var_75 = wp::where(var_58, var_60, var_43);
        var_76 = wp::where(var_58, var_62, var_45);
        // if not might_win:                                                                  <L 1557>
        var_78 = wp::unot(var_73);
        if (var_78) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1558>
            var_79 = get_spatial_direction_2d_0(var_77);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1559>
            var_80 = wp::dot(var_8, var_79);
            // probe = make_spatial_preprune_probe(score, use_inner, fingerprint, reducer_data.deterministic)       <L 1560>
            var_81 = &((var_reducer_data).deterministic);
            var_83 = wp::load(var_81);
            var_82 = make_spatial_preprune_probe_0(var_80, var_3, var_fingerprint, var_83);
            // if reducer_data.ht_values[dir_i * ht_capacity + entry_idx] < probe:            <L 1561>
            var_84 = &((var_reducer_data).ht_values);
            var_85 = wp::mul(var_77, var_1);
            var_86 = wp::add(var_85, var_12);
            var_88 = wp::load(var_84);
            var_87 = wp::address(var_88, var_86);
            var_90 = wp::load(var_87);
            var_89 = (var_90 < var_82);
            if (var_89) {
                // might_win = True                                                           <L 1562>
            }
            var_92 = wp::where(var_89, var_91, var_73);
        }
        var_93 = wp::where(var_78, var_92, var_73);
        var_94 = wp::where(var_78, var_79, var_74);
        var_95 = wp::where(var_78, var_80, var_75);
        var_96 = wp::where(var_78, var_82, var_76);
        // if not might_win:                                                                  <L 1557>
        var_98 = wp::unot(var_93);
        if (var_98) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1558>
            var_99 = get_spatial_direction_2d_0(var_97);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1559>
            var_100 = wp::dot(var_8, var_99);
            // probe = make_spatial_preprune_probe(score, use_inner, fingerprint, reducer_data.deterministic)       <L 1560>
            var_101 = &((var_reducer_data).deterministic);
            var_103 = wp::load(var_101);
            var_102 = make_spatial_preprune_probe_0(var_100, var_3, var_fingerprint, var_103);
            // if reducer_data.ht_values[dir_i * ht_capacity + entry_idx] < probe:            <L 1561>
            var_104 = &((var_reducer_data).ht_values);
            var_105 = wp::mul(var_97, var_1);
            var_106 = wp::add(var_105, var_12);
            var_108 = wp::load(var_104);
            var_107 = wp::address(var_108, var_106);
            var_110 = wp::load(var_107);
            var_109 = (var_110 < var_102);
            if (var_109) {
                // might_win = True                                                           <L 1562>
            }
            var_112 = wp::where(var_109, var_111, var_93);
        }
        var_113 = wp::where(var_98, var_112, var_93);
        var_114 = wp::where(var_98, var_99, var_94);
        var_115 = wp::where(var_98, var_100, var_95);
        var_116 = wp::where(var_98, var_102, var_96);
        // if not might_win:                                                                  <L 1557>
        var_118 = wp::unot(var_113);
        if (var_118) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1558>
            var_119 = get_spatial_direction_2d_0(var_117);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1559>
            var_120 = wp::dot(var_8, var_119);
            // probe = make_spatial_preprune_probe(score, use_inner, fingerprint, reducer_data.deterministic)       <L 1560>
            var_121 = &((var_reducer_data).deterministic);
            var_123 = wp::load(var_121);
            var_122 = make_spatial_preprune_probe_0(var_120, var_3, var_fingerprint, var_123);
            // if reducer_data.ht_values[dir_i * ht_capacity + entry_idx] < probe:            <L 1561>
            var_124 = &((var_reducer_data).ht_values);
            var_125 = wp::mul(var_117, var_1);
            var_126 = wp::add(var_125, var_12);
            var_128 = wp::load(var_124);
            var_127 = wp::address(var_128, var_126);
            var_130 = wp::load(var_127);
            var_129 = (var_130 < var_122);
            if (var_129) {
                // might_win = True                                                           <L 1562>
            }
            var_132 = wp::where(var_129, var_131, var_113);
        }
        var_133 = wp::where(var_118, var_132, var_113);
        var_134 = wp::where(var_118, var_119, var_114);
        var_135 = wp::where(var_118, var_120, var_115);
        var_136 = wp::where(var_118, var_122, var_116);
        // if not might_win:                                                                  <L 1557>
        var_138 = wp::unot(var_133);
        if (var_138) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1558>
            var_139 = get_spatial_direction_2d_0(var_137);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1559>
            var_140 = wp::dot(var_8, var_139);
            // probe = make_spatial_preprune_probe(score, use_inner, fingerprint, reducer_data.deterministic)       <L 1560>
            var_141 = &((var_reducer_data).deterministic);
            var_143 = wp::load(var_141);
            var_142 = make_spatial_preprune_probe_0(var_140, var_3, var_fingerprint, var_143);
            // if reducer_data.ht_values[dir_i * ht_capacity + entry_idx] < probe:            <L 1561>
            var_144 = &((var_reducer_data).ht_values);
            var_145 = wp::mul(var_137, var_1);
            var_146 = wp::add(var_145, var_12);
            var_148 = wp::load(var_144);
            var_147 = wp::address(var_148, var_146);
            var_150 = wp::load(var_147);
            var_149 = (var_150 < var_142);
            if (var_149) {
                // might_win = True                                                           <L 1562>
            }
            var_152 = wp::where(var_149, var_151, var_133);
        }
        var_153 = wp::where(var_138, var_152, var_133);
        var_154 = wp::where(var_138, var_139, var_134);
        var_155 = wp::where(var_138, var_140, var_135);
        var_156 = wp::where(var_138, var_142, var_136);
    }
    if (!var_17) {
        // wp.atomic_add(reducer_data.ht_insert_failures, 0, 1)                               <L 1564>
        var_157 = &((var_reducer_data).ht_insert_failures);
        var_161 = wp::load(var_157);
        var_160 = wp::atomic_add(var_161, var_158, var_159);
    }
    var_162 = wp::where(var_17, var_153, var_15);
    // voxel_idx = compute_voxel_index(position_local, aabb_lower_voxel, aabb_upper_voxel, voxel_res)       <L 1567>
    var_163 = compute_voxel_index_0(var_position_local, var_aabb_lower_voxel, var_aabb_upper_voxel, var_voxel_res);
    // voxel_idx = wp.clamp(voxel_idx, 0, wp.static(NUM_VOXEL_DEPTH_SLOTS - 1))               <L 1568>
    var_166 = wp::clamp(var_163, var_164, var_165);
    // voxels_per_group = wp.static(NUM_SPATIAL_DIRECTIONS + 1)                               <L 1570>
    // voxel_group = voxel_idx // voxels_per_group                                            <L 1571>
    var_168 = wp::floordiv(var_166, var_167);
    // voxel_local_slot = voxel_idx % voxels_per_group                                        <L 1572>
    var_169 = wp::mod(var_166, var_167);
    // voxel_bin_id = wp.static(NUM_NORMAL_BINS) + voxel_group                                <L 1573>
    var_171 = wp::add(var_170, var_168);
    // voxel_key = make_contact_key(shape_a, shape_b, voxel_bin_id)                           <L 1574>
    var_172 = make_contact_key_0(var_shape_a, var_shape_b, var_171);
    // voxel_entry_idx = -1                                                                   <L 1576>
    // if use_inner and not might_win:                                                        <L 1577>
    var_174 = var_3;
    if (var_174) {
        var_175 = wp::unot(var_162);
        var_174 = var_174 && var_175;
    }
    if (var_174) {
        // voxel_entry_idx = hashtable_find_or_insert(voxel_key, reducer_data.ht_keys, reducer_data.ht_active_slots)       <L 1578>
        var_176 = &((var_reducer_data).ht_keys);
        var_177 = &((var_reducer_data).ht_active_slots);
        var_179 = wp::load(var_176);
        var_180 = wp::load(var_177);
        var_178 = hashtable_find_or_insert_0(var_172, var_179, var_180);
        // if voxel_entry_idx >= 0:                                                           <L 1579>
        var_182 = (var_178 >= var_181);
        if (var_182) {
            // if reducer_data.deterministic != 0:                                            <L 1580>
            var_183 = &((var_reducer_data).deterministic);
            var_186 = wp::load(var_183);
            var_185 = (var_186 != var_184);
            if (var_185) {
                // voxel_probe = _make_preprune_probe_det(-depth, fingerprint)                <L 1581>
                var_187 = wp::neg(var_depth);
                var_188 = _make_preprune_probe_det_0(var_187, var_fingerprint);
            }
            if (!var_185) {
                // voxel_probe = _make_contact_value_fast(-depth, 0, 0)                       <L 1583>
                var_189 = wp::neg(var_depth);
                var_192 = _make_contact_value_fast_0(var_189, var_190, var_191);
            }
            var_193 = wp::where(var_185, var_188, var_192);
            // if reducer_data.ht_values[voxel_local_slot * ht_capacity + voxel_entry_idx] < voxel_probe:       <L 1584>
            var_194 = &((var_reducer_data).ht_values);
            var_195 = wp::mul(var_169, var_1);
            var_196 = wp::add(var_195, var_178);
            var_198 = wp::load(var_194);
            var_197 = wp::address(var_198, var_196);
            var_200 = wp::load(var_197);
            var_199 = (var_200 < var_193);
            if (var_199) {
                // might_win = True                                                           <L 1585>
            }
            var_202 = wp::where(var_199, var_201, var_162);
        }
        var_203 = wp::where(var_182, var_202, var_162);
    }
    var_204 = wp::where(var_174, var_203, var_162);
    var_205 = wp::where(var_174, var_178, var_173);
    // if not might_win:                                                                      <L 1587>
    var_206 = wp::unot(var_204);
    if (var_206) {
        // return -1                                                                          <L 1588>
        return var_207;
    }
    // if use_inner and voxel_entry_idx < 0:                                                  <L 1592>
    var_208 = var_3;
    if (var_208) {
        var_210 = (var_205 < var_209);
        var_208 = var_208 && var_210;
    }
    if (var_208) {
        // voxel_entry_idx = hashtable_find_or_insert(voxel_key, reducer_data.ht_keys, reducer_data.ht_active_slots)       <L 1593>
        var_211 = &((var_reducer_data).ht_keys);
        var_212 = &((var_reducer_data).ht_active_slots);
        var_214 = wp::load(var_211);
        var_215 = wp::load(var_212);
        var_213 = hashtable_find_or_insert_0(var_172, var_214, var_215);
    }
    var_216 = wp::where(var_208, var_213, var_205);
    // won_mask = int(0)                                                                      <L 1595>
    var_218 = wp::int(var_217);
    // replaced_values = replaced_values_vec_type()                                           <L 1596>
    var_219 = wp::vec_t<8, wp::uint64>();
    // if use_inner and entry_idx >= 0:                                                       <L 1597>
    var_220 = var_3;
    if (var_220) {
        var_222 = (var_12 >= var_221);
        var_220 = var_220 && var_222;
    }
    if (var_220) {
        // for dir_i in range(wp.static(NUM_SPATIAL_DIRECTIONS)):                             <L 1598>
        // dir_2d = get_spatial_direction_2d(dir_i)                                           <L 1599>
        var_224 = get_spatial_direction_2d_0(var_223);
        // score = wp.dot(pos_2d, dir_2d)                                                     <L 1600>
        var_225 = wp::dot(var_8, var_224);
        // provisional_value = make_spatial_contact_value(score, True, fingerprint, 0, reducer_data.deterministic)       <L 1601>
        var_228 = &((var_reducer_data).deterministic);
        var_230 = wp::load(var_228);
        var_229 = make_spatial_contact_value_0(var_225, var_226, var_fingerprint, var_227, var_230);
        // previous_value = reduction_try_update_slot(                                        <L 1602>
        // entry_idx, dir_i, provisional_value, reducer_data.ht_values, ht_capacity           <L 1603>
        var_231 = &((var_reducer_data).ht_values);
        var_233 = wp::load(var_231);
        var_232 = reduction_try_update_slot_0(var_12, var_223, var_229, var_233, var_1);
        // if previous_value < provisional_value:                                             <L 1605>
        var_234 = (var_232 < var_229);
        if (var_234) {
            // won_mask |= 1 << dir_i                                                         <L 1606>
            var_236 = wp::lshift(var_235, var_223);
            var_237 = wp::bit_or(var_218, var_236);
            // replaced_values[dir_i] = previous_value                                        <L 1607>
            wp::assign_inplace(var_219, var_223, var_232);
        }
        var_238 = wp::where(var_234, var_237, var_218);
        // dir_2d = get_spatial_direction_2d(dir_i)                                           <L 1599>
        var_240 = get_spatial_direction_2d_0(var_239);
        // score = wp.dot(pos_2d, dir_2d)                                                     <L 1600>
        var_241 = wp::dot(var_8, var_240);
        // provisional_value = make_spatial_contact_value(score, True, fingerprint, 0, reducer_data.deterministic)       <L 1601>
        var_244 = &((var_reducer_data).deterministic);
        var_246 = wp::load(var_244);
        var_245 = make_spatial_contact_value_0(var_241, var_242, var_fingerprint, var_243, var_246);
        // previous_value = reduction_try_update_slot(                                        <L 1602>
        // entry_idx, dir_i, provisional_value, reducer_data.ht_values, ht_capacity           <L 1603>
        var_247 = &((var_reducer_data).ht_values);
        var_249 = wp::load(var_247);
        var_248 = reduction_try_update_slot_0(var_12, var_239, var_245, var_249, var_1);
        // if previous_value < provisional_value:                                             <L 1605>
        var_250 = (var_248 < var_245);
        if (var_250) {
            // won_mask |= 1 << dir_i                                                         <L 1606>
            var_252 = wp::lshift(var_251, var_239);
            var_253 = wp::bit_or(var_238, var_252);
            // replaced_values[dir_i] = previous_value                                        <L 1607>
            wp::assign_inplace(var_219, var_239, var_248);
        }
        var_254 = wp::where(var_250, var_253, var_238);
        // dir_2d = get_spatial_direction_2d(dir_i)                                           <L 1599>
        var_256 = get_spatial_direction_2d_0(var_255);
        // score = wp.dot(pos_2d, dir_2d)                                                     <L 1600>
        var_257 = wp::dot(var_8, var_256);
        // provisional_value = make_spatial_contact_value(score, True, fingerprint, 0, reducer_data.deterministic)       <L 1601>
        var_260 = &((var_reducer_data).deterministic);
        var_262 = wp::load(var_260);
        var_261 = make_spatial_contact_value_0(var_257, var_258, var_fingerprint, var_259, var_262);
        // previous_value = reduction_try_update_slot(                                        <L 1602>
        // entry_idx, dir_i, provisional_value, reducer_data.ht_values, ht_capacity           <L 1603>
        var_263 = &((var_reducer_data).ht_values);
        var_265 = wp::load(var_263);
        var_264 = reduction_try_update_slot_0(var_12, var_255, var_261, var_265, var_1);
        // if previous_value < provisional_value:                                             <L 1605>
        var_266 = (var_264 < var_261);
        if (var_266) {
            // won_mask |= 1 << dir_i                                                         <L 1606>
            var_268 = wp::lshift(var_267, var_255);
            var_269 = wp::bit_or(var_254, var_268);
            // replaced_values[dir_i] = previous_value                                        <L 1607>
            wp::assign_inplace(var_219, var_255, var_264);
        }
        var_270 = wp::where(var_266, var_269, var_254);
        // dir_2d = get_spatial_direction_2d(dir_i)                                           <L 1599>
        var_272 = get_spatial_direction_2d_0(var_271);
        // score = wp.dot(pos_2d, dir_2d)                                                     <L 1600>
        var_273 = wp::dot(var_8, var_272);
        // provisional_value = make_spatial_contact_value(score, True, fingerprint, 0, reducer_data.deterministic)       <L 1601>
        var_276 = &((var_reducer_data).deterministic);
        var_278 = wp::load(var_276);
        var_277 = make_spatial_contact_value_0(var_273, var_274, var_fingerprint, var_275, var_278);
        // previous_value = reduction_try_update_slot(                                        <L 1602>
        // entry_idx, dir_i, provisional_value, reducer_data.ht_values, ht_capacity           <L 1603>
        var_279 = &((var_reducer_data).ht_values);
        var_281 = wp::load(var_279);
        var_280 = reduction_try_update_slot_0(var_12, var_271, var_277, var_281, var_1);
        // if previous_value < provisional_value:                                             <L 1605>
        var_282 = (var_280 < var_277);
        if (var_282) {
            // won_mask |= 1 << dir_i                                                         <L 1606>
            var_284 = wp::lshift(var_283, var_271);
            var_285 = wp::bit_or(var_270, var_284);
            // replaced_values[dir_i] = previous_value                                        <L 1607>
            wp::assign_inplace(var_219, var_271, var_280);
        }
        var_286 = wp::where(var_282, var_285, var_270);
        // dir_2d = get_spatial_direction_2d(dir_i)                                           <L 1599>
        var_288 = get_spatial_direction_2d_0(var_287);
        // score = wp.dot(pos_2d, dir_2d)                                                     <L 1600>
        var_289 = wp::dot(var_8, var_288);
        // provisional_value = make_spatial_contact_value(score, True, fingerprint, 0, reducer_data.deterministic)       <L 1601>
        var_292 = &((var_reducer_data).deterministic);
        var_294 = wp::load(var_292);
        var_293 = make_spatial_contact_value_0(var_289, var_290, var_fingerprint, var_291, var_294);
        // previous_value = reduction_try_update_slot(                                        <L 1602>
        // entry_idx, dir_i, provisional_value, reducer_data.ht_values, ht_capacity           <L 1603>
        var_295 = &((var_reducer_data).ht_values);
        var_297 = wp::load(var_295);
        var_296 = reduction_try_update_slot_0(var_12, var_287, var_293, var_297, var_1);
        // if previous_value < provisional_value:                                             <L 1605>
        var_298 = (var_296 < var_293);
        if (var_298) {
            // won_mask |= 1 << dir_i                                                         <L 1606>
            var_300 = wp::lshift(var_299, var_287);
            var_301 = wp::bit_or(var_286, var_300);
            // replaced_values[dir_i] = previous_value                                        <L 1607>
            wp::assign_inplace(var_219, var_287, var_296);
        }
        var_302 = wp::where(var_298, var_301, var_286);
        // dir_2d = get_spatial_direction_2d(dir_i)                                           <L 1599>
        var_304 = get_spatial_direction_2d_0(var_303);
        // score = wp.dot(pos_2d, dir_2d)                                                     <L 1600>
        var_305 = wp::dot(var_8, var_304);
        // provisional_value = make_spatial_contact_value(score, True, fingerprint, 0, reducer_data.deterministic)       <L 1601>
        var_308 = &((var_reducer_data).deterministic);
        var_310 = wp::load(var_308);
        var_309 = make_spatial_contact_value_0(var_305, var_306, var_fingerprint, var_307, var_310);
        // previous_value = reduction_try_update_slot(                                        <L 1602>
        // entry_idx, dir_i, provisional_value, reducer_data.ht_values, ht_capacity           <L 1603>
        var_311 = &((var_reducer_data).ht_values);
        var_313 = wp::load(var_311);
        var_312 = reduction_try_update_slot_0(var_12, var_303, var_309, var_313, var_1);
        // if previous_value < provisional_value:                                             <L 1605>
        var_314 = (var_312 < var_309);
        if (var_314) {
            // won_mask |= 1 << dir_i                                                         <L 1606>
            var_316 = wp::lshift(var_315, var_303);
            var_317 = wp::bit_or(var_302, var_316);
            // replaced_values[dir_i] = previous_value                                        <L 1607>
            wp::assign_inplace(var_219, var_303, var_312);
        }
        var_318 = wp::where(var_314, var_317, var_302);
        // provisional_value = make_contact_value(-depth, fingerprint, 0, reducer_data.deterministic)       <L 1609>
        var_319 = wp::neg(var_depth);
        var_321 = &((var_reducer_data).deterministic);
        var_323 = wp::load(var_321);
        var_322 = make_contact_value_0(var_319, var_fingerprint, var_320, var_323);
        // previous_value = reduction_try_update_slot(                                        <L 1610>
        // entry_idx,                                                                         <L 1611>
        // wp.static(NUM_SPATIAL_DIRECTIONS),                                                 <L 1612>
        // provisional_value,                                                                 <L 1613>
        // reducer_data.ht_values,                                                            <L 1614>
        var_325 = &((var_reducer_data).ht_values);
        // ht_capacity,                                                                       <L 1615>
        var_327 = wp::load(var_325);
        var_326 = reduction_try_update_slot_0(var_12, var_324, var_322, var_327, var_1);
        // if previous_value < provisional_value:                                             <L 1617>
        var_328 = (var_326 < var_322);
        if (var_328) {
            // won_mask |= 1 << wp.static(NUM_SPATIAL_DIRECTIONS)                             <L 1618>
            var_331 = wp::lshift(var_329, var_330);
            var_332 = wp::bit_or(var_318, var_331);
            // replaced_values[wp.static(NUM_SPATIAL_DIRECTIONS)] = previous_value            <L 1619>
            wp::assign_inplace(var_219, var_333, var_326);
        }
        var_334 = wp::where(var_328, var_332, var_318);
    }
    if (!var_220) {
        // elif entry_idx >= 0:                                                               <L 1620>
        var_336 = (var_12 >= var_335);
        if (var_336) {
            // for dir_i in range(wp.static(NUM_SPATIAL_DIRECTIONS)):                         <L 1621>
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1622>
            var_338 = get_spatial_direction_2d_0(var_337);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1623>
            var_339 = wp::dot(var_8, var_338);
            // provisional_value = make_spatial_contact_value(score, False, fingerprint, 0, reducer_data.deterministic)       <L 1624>
            var_342 = &((var_reducer_data).deterministic);
            var_344 = wp::load(var_342);
            var_343 = make_spatial_contact_value_0(var_339, var_340, var_fingerprint, var_341, var_344);
            // previous_value = reduction_try_update_slot(                                    <L 1625>
            // entry_idx, dir_i, provisional_value, reducer_data.ht_values, ht_capacity       <L 1626>
            var_345 = &((var_reducer_data).ht_values);
            var_347 = wp::load(var_345);
            var_346 = reduction_try_update_slot_0(var_12, var_337, var_343, var_347, var_1);
            // if previous_value < provisional_value:                                         <L 1628>
            var_348 = (var_346 < var_343);
            if (var_348) {
                // won_mask |= 1 << dir_i                                                     <L 1629>
                var_350 = wp::lshift(var_349, var_337);
                var_351 = wp::bit_or(var_218, var_350);
                // replaced_values[dir_i] = previous_value                                    <L 1630>
                wp::assign_inplace(var_219, var_337, var_346);
            }
            var_352 = wp::where(var_348, var_351, var_218);
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1622>
            var_354 = get_spatial_direction_2d_0(var_353);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1623>
            var_355 = wp::dot(var_8, var_354);
            // provisional_value = make_spatial_contact_value(score, False, fingerprint, 0, reducer_data.deterministic)       <L 1624>
            var_358 = &((var_reducer_data).deterministic);
            var_360 = wp::load(var_358);
            var_359 = make_spatial_contact_value_0(var_355, var_356, var_fingerprint, var_357, var_360);
            // previous_value = reduction_try_update_slot(                                    <L 1625>
            // entry_idx, dir_i, provisional_value, reducer_data.ht_values, ht_capacity       <L 1626>
            var_361 = &((var_reducer_data).ht_values);
            var_363 = wp::load(var_361);
            var_362 = reduction_try_update_slot_0(var_12, var_353, var_359, var_363, var_1);
            // if previous_value < provisional_value:                                         <L 1628>
            var_364 = (var_362 < var_359);
            if (var_364) {
                // won_mask |= 1 << dir_i                                                     <L 1629>
                var_366 = wp::lshift(var_365, var_353);
                var_367 = wp::bit_or(var_352, var_366);
                // replaced_values[dir_i] = previous_value                                    <L 1630>
                wp::assign_inplace(var_219, var_353, var_362);
            }
            var_368 = wp::where(var_364, var_367, var_352);
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1622>
            var_370 = get_spatial_direction_2d_0(var_369);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1623>
            var_371 = wp::dot(var_8, var_370);
            // provisional_value = make_spatial_contact_value(score, False, fingerprint, 0, reducer_data.deterministic)       <L 1624>
            var_374 = &((var_reducer_data).deterministic);
            var_376 = wp::load(var_374);
            var_375 = make_spatial_contact_value_0(var_371, var_372, var_fingerprint, var_373, var_376);
            // previous_value = reduction_try_update_slot(                                    <L 1625>
            // entry_idx, dir_i, provisional_value, reducer_data.ht_values, ht_capacity       <L 1626>
            var_377 = &((var_reducer_data).ht_values);
            var_379 = wp::load(var_377);
            var_378 = reduction_try_update_slot_0(var_12, var_369, var_375, var_379, var_1);
            // if previous_value < provisional_value:                                         <L 1628>
            var_380 = (var_378 < var_375);
            if (var_380) {
                // won_mask |= 1 << dir_i                                                     <L 1629>
                var_382 = wp::lshift(var_381, var_369);
                var_383 = wp::bit_or(var_368, var_382);
                // replaced_values[dir_i] = previous_value                                    <L 1630>
                wp::assign_inplace(var_219, var_369, var_378);
            }
            var_384 = wp::where(var_380, var_383, var_368);
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1622>
            var_386 = get_spatial_direction_2d_0(var_385);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1623>
            var_387 = wp::dot(var_8, var_386);
            // provisional_value = make_spatial_contact_value(score, False, fingerprint, 0, reducer_data.deterministic)       <L 1624>
            var_390 = &((var_reducer_data).deterministic);
            var_392 = wp::load(var_390);
            var_391 = make_spatial_contact_value_0(var_387, var_388, var_fingerprint, var_389, var_392);
            // previous_value = reduction_try_update_slot(                                    <L 1625>
            // entry_idx, dir_i, provisional_value, reducer_data.ht_values, ht_capacity       <L 1626>
            var_393 = &((var_reducer_data).ht_values);
            var_395 = wp::load(var_393);
            var_394 = reduction_try_update_slot_0(var_12, var_385, var_391, var_395, var_1);
            // if previous_value < provisional_value:                                         <L 1628>
            var_396 = (var_394 < var_391);
            if (var_396) {
                // won_mask |= 1 << dir_i                                                     <L 1629>
                var_398 = wp::lshift(var_397, var_385);
                var_399 = wp::bit_or(var_384, var_398);
                // replaced_values[dir_i] = previous_value                                    <L 1630>
                wp::assign_inplace(var_219, var_385, var_394);
            }
            var_400 = wp::where(var_396, var_399, var_384);
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1622>
            var_402 = get_spatial_direction_2d_0(var_401);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1623>
            var_403 = wp::dot(var_8, var_402);
            // provisional_value = make_spatial_contact_value(score, False, fingerprint, 0, reducer_data.deterministic)       <L 1624>
            var_406 = &((var_reducer_data).deterministic);
            var_408 = wp::load(var_406);
            var_407 = make_spatial_contact_value_0(var_403, var_404, var_fingerprint, var_405, var_408);
            // previous_value = reduction_try_update_slot(                                    <L 1625>
            // entry_idx, dir_i, provisional_value, reducer_data.ht_values, ht_capacity       <L 1626>
            var_409 = &((var_reducer_data).ht_values);
            var_411 = wp::load(var_409);
            var_410 = reduction_try_update_slot_0(var_12, var_401, var_407, var_411, var_1);
            // if previous_value < provisional_value:                                         <L 1628>
            var_412 = (var_410 < var_407);
            if (var_412) {
                // won_mask |= 1 << dir_i                                                     <L 1629>
                var_414 = wp::lshift(var_413, var_401);
                var_415 = wp::bit_or(var_400, var_414);
                // replaced_values[dir_i] = previous_value                                    <L 1630>
                wp::assign_inplace(var_219, var_401, var_410);
            }
            var_416 = wp::where(var_412, var_415, var_400);
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1622>
            var_418 = get_spatial_direction_2d_0(var_417);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1623>
            var_419 = wp::dot(var_8, var_418);
            // provisional_value = make_spatial_contact_value(score, False, fingerprint, 0, reducer_data.deterministic)       <L 1624>
            var_422 = &((var_reducer_data).deterministic);
            var_424 = wp::load(var_422);
            var_423 = make_spatial_contact_value_0(var_419, var_420, var_fingerprint, var_421, var_424);
            // previous_value = reduction_try_update_slot(                                    <L 1625>
            // entry_idx, dir_i, provisional_value, reducer_data.ht_values, ht_capacity       <L 1626>
            var_425 = &((var_reducer_data).ht_values);
            var_427 = wp::load(var_425);
            var_426 = reduction_try_update_slot_0(var_12, var_417, var_423, var_427, var_1);
            // if previous_value < provisional_value:                                         <L 1628>
            var_428 = (var_426 < var_423);
            if (var_428) {
                // won_mask |= 1 << dir_i                                                     <L 1629>
                var_430 = wp::lshift(var_429, var_417);
                var_431 = wp::bit_or(var_416, var_430);
                // replaced_values[dir_i] = previous_value                                    <L 1630>
                wp::assign_inplace(var_219, var_417, var_426);
            }
            var_432 = wp::where(var_428, var_431, var_416);
        }
        var_433 = wp::where(var_336, var_417, var_137);
        var_434 = wp::where(var_336, var_418, var_154);
        var_435 = wp::where(var_336, var_419, var_155);
        var_436 = wp::where(var_336, var_432, var_218);
    }
    var_437 = wp::where(var_220, var_303, var_433);
    var_438 = wp::where(var_220, var_304, var_434);
    var_439 = wp::where(var_220, var_305, var_435);
    var_440 = wp::where(var_220, var_334, var_436);
    var_441 = wp::where(var_220, var_322, var_423);
    var_442 = wp::where(var_220, var_326, var_426);
    // if use_inner and voxel_entry_idx >= 0:                                                 <L 1632>
    var_443 = var_3;
    if (var_443) {
        var_445 = (var_216 >= var_444);
        var_443 = var_443 && var_445;
    }
    if (var_443) {
        // provisional_value = make_contact_value(-depth, fingerprint, 0, reducer_data.deterministic)       <L 1633>
        var_446 = wp::neg(var_depth);
        var_448 = &((var_reducer_data).deterministic);
        var_450 = wp::load(var_448);
        var_449 = make_contact_value_0(var_446, var_fingerprint, var_447, var_450);
        // previous_value = reduction_try_update_slot(                                        <L 1634>
        // voxel_entry_idx, voxel_local_slot, provisional_value, reducer_data.ht_values, ht_capacity       <L 1635>
        var_451 = &((var_reducer_data).ht_values);
        var_453 = wp::load(var_451);
        var_452 = reduction_try_update_slot_0(var_216, var_169, var_449, var_453, var_1);
        // if previous_value < provisional_value:                                             <L 1637>
        var_454 = (var_452 < var_449);
        if (var_454) {
            // won_mask |= 1 << wp.static(NUM_SPATIAL_DIRECTIONS + 1)                         <L 1638>
            var_457 = wp::lshift(var_455, var_456);
            var_458 = wp::bit_or(var_440, var_457);
            // replaced_values[wp.static(NUM_SPATIAL_DIRECTIONS + 1)] = previous_value        <L 1639>
            wp::assign_inplace(var_219, var_459, var_452);
        }
        var_460 = wp::where(var_454, var_458, var_440);
    }
    var_461 = wp::where(var_443, var_460, var_440);
    var_462 = wp::where(var_443, var_449, var_441);
    var_463 = wp::where(var_443, var_452, var_442);
    // if won_mask == 0:                                                                      <L 1641>
    var_465 = (var_461 == var_464);
    if (var_465) {
        // return -1                                                                          <L 1642>
        return var_466;
    }
    // still_wins = False                                                                     <L 1645>
    // if entry_idx >= 0:                                                                     <L 1646>
    var_469 = (var_12 >= var_468);
    if (var_469) {
        // for dir_i in range(wp.static(NUM_SPATIAL_DIRECTIONS)):                             <L 1647>
        // if not still_wins and (won_mask & (1 << dir_i)) != 0:                              <L 1648>
        var_472 = wp::unot(var_467);
        var_471 = var_472;
        if (var_471) {
            var_474 = wp::lshift(var_473, var_470);
            var_475 = wp::bit_and(var_461, var_474);
            var_477 = (var_475 != var_476);
            var_471 = var_471 && var_477;
        }
        if (var_471) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1649>
            var_478 = get_spatial_direction_2d_0(var_470);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1650>
            var_479 = wp::dot(var_8, var_478);
            // provisional_value = make_spatial_contact_value(                                <L 1651>
            // score, use_inner, fingerprint, 0, reducer_data.deterministic                   <L 1652>
            var_481 = &((var_reducer_data).deterministic);
            var_483 = wp::load(var_481);
            var_482 = make_spatial_contact_value_0(var_479, var_3, var_fingerprint, var_480, var_483);
            // if reducer_data.ht_values[dir_i * ht_capacity + entry_idx] == provisional_value:       <L 1654>
            var_484 = &((var_reducer_data).ht_values);
            var_485 = wp::mul(var_470, var_1);
            var_486 = wp::add(var_485, var_12);
            var_488 = wp::load(var_484);
            var_487 = wp::address(var_488, var_486);
            var_490 = wp::load(var_487);
            var_489 = (var_490 == var_482);
            if (var_489) {
                // still_wins = True                                                          <L 1655>
            }
            var_492 = wp::where(var_489, var_491, var_467);
        }
        var_493 = wp::where(var_471, var_478, var_438);
        var_494 = wp::where(var_471, var_479, var_439);
        var_495 = wp::where(var_471, var_482, var_462);
        var_496 = wp::where(var_471, var_492, var_467);
        // if not still_wins and (won_mask & (1 << dir_i)) != 0:                              <L 1648>
        var_499 = wp::unot(var_496);
        var_498 = var_499;
        if (var_498) {
            var_501 = wp::lshift(var_500, var_497);
            var_502 = wp::bit_and(var_461, var_501);
            var_504 = (var_502 != var_503);
            var_498 = var_498 && var_504;
        }
        if (var_498) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1649>
            var_505 = get_spatial_direction_2d_0(var_497);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1650>
            var_506 = wp::dot(var_8, var_505);
            // provisional_value = make_spatial_contact_value(                                <L 1651>
            // score, use_inner, fingerprint, 0, reducer_data.deterministic                   <L 1652>
            var_508 = &((var_reducer_data).deterministic);
            var_510 = wp::load(var_508);
            var_509 = make_spatial_contact_value_0(var_506, var_3, var_fingerprint, var_507, var_510);
            // if reducer_data.ht_values[dir_i * ht_capacity + entry_idx] == provisional_value:       <L 1654>
            var_511 = &((var_reducer_data).ht_values);
            var_512 = wp::mul(var_497, var_1);
            var_513 = wp::add(var_512, var_12);
            var_515 = wp::load(var_511);
            var_514 = wp::address(var_515, var_513);
            var_517 = wp::load(var_514);
            var_516 = (var_517 == var_509);
            if (var_516) {
                // still_wins = True                                                          <L 1655>
            }
            var_519 = wp::where(var_516, var_518, var_496);
        }
        var_520 = wp::where(var_498, var_505, var_493);
        var_521 = wp::where(var_498, var_506, var_494);
        var_522 = wp::where(var_498, var_509, var_495);
        var_523 = wp::where(var_498, var_519, var_496);
        // if not still_wins and (won_mask & (1 << dir_i)) != 0:                              <L 1648>
        var_526 = wp::unot(var_523);
        var_525 = var_526;
        if (var_525) {
            var_528 = wp::lshift(var_527, var_524);
            var_529 = wp::bit_and(var_461, var_528);
            var_531 = (var_529 != var_530);
            var_525 = var_525 && var_531;
        }
        if (var_525) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1649>
            var_532 = get_spatial_direction_2d_0(var_524);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1650>
            var_533 = wp::dot(var_8, var_532);
            // provisional_value = make_spatial_contact_value(                                <L 1651>
            // score, use_inner, fingerprint, 0, reducer_data.deterministic                   <L 1652>
            var_535 = &((var_reducer_data).deterministic);
            var_537 = wp::load(var_535);
            var_536 = make_spatial_contact_value_0(var_533, var_3, var_fingerprint, var_534, var_537);
            // if reducer_data.ht_values[dir_i * ht_capacity + entry_idx] == provisional_value:       <L 1654>
            var_538 = &((var_reducer_data).ht_values);
            var_539 = wp::mul(var_524, var_1);
            var_540 = wp::add(var_539, var_12);
            var_542 = wp::load(var_538);
            var_541 = wp::address(var_542, var_540);
            var_544 = wp::load(var_541);
            var_543 = (var_544 == var_536);
            if (var_543) {
                // still_wins = True                                                          <L 1655>
            }
            var_546 = wp::where(var_543, var_545, var_523);
        }
        var_547 = wp::where(var_525, var_532, var_520);
        var_548 = wp::where(var_525, var_533, var_521);
        var_549 = wp::where(var_525, var_536, var_522);
        var_550 = wp::where(var_525, var_546, var_523);
        // if not still_wins and (won_mask & (1 << dir_i)) != 0:                              <L 1648>
        var_553 = wp::unot(var_550);
        var_552 = var_553;
        if (var_552) {
            var_555 = wp::lshift(var_554, var_551);
            var_556 = wp::bit_and(var_461, var_555);
            var_558 = (var_556 != var_557);
            var_552 = var_552 && var_558;
        }
        if (var_552) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1649>
            var_559 = get_spatial_direction_2d_0(var_551);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1650>
            var_560 = wp::dot(var_8, var_559);
            // provisional_value = make_spatial_contact_value(                                <L 1651>
            // score, use_inner, fingerprint, 0, reducer_data.deterministic                   <L 1652>
            var_562 = &((var_reducer_data).deterministic);
            var_564 = wp::load(var_562);
            var_563 = make_spatial_contact_value_0(var_560, var_3, var_fingerprint, var_561, var_564);
            // if reducer_data.ht_values[dir_i * ht_capacity + entry_idx] == provisional_value:       <L 1654>
            var_565 = &((var_reducer_data).ht_values);
            var_566 = wp::mul(var_551, var_1);
            var_567 = wp::add(var_566, var_12);
            var_569 = wp::load(var_565);
            var_568 = wp::address(var_569, var_567);
            var_571 = wp::load(var_568);
            var_570 = (var_571 == var_563);
            if (var_570) {
                // still_wins = True                                                          <L 1655>
            }
            var_573 = wp::where(var_570, var_572, var_550);
        }
        var_574 = wp::where(var_552, var_559, var_547);
        var_575 = wp::where(var_552, var_560, var_548);
        var_576 = wp::where(var_552, var_563, var_549);
        var_577 = wp::where(var_552, var_573, var_550);
        // if not still_wins and (won_mask & (1 << dir_i)) != 0:                              <L 1648>
        var_580 = wp::unot(var_577);
        var_579 = var_580;
        if (var_579) {
            var_582 = wp::lshift(var_581, var_578);
            var_583 = wp::bit_and(var_461, var_582);
            var_585 = (var_583 != var_584);
            var_579 = var_579 && var_585;
        }
        if (var_579) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1649>
            var_586 = get_spatial_direction_2d_0(var_578);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1650>
            var_587 = wp::dot(var_8, var_586);
            // provisional_value = make_spatial_contact_value(                                <L 1651>
            // score, use_inner, fingerprint, 0, reducer_data.deterministic                   <L 1652>
            var_589 = &((var_reducer_data).deterministic);
            var_591 = wp::load(var_589);
            var_590 = make_spatial_contact_value_0(var_587, var_3, var_fingerprint, var_588, var_591);
            // if reducer_data.ht_values[dir_i * ht_capacity + entry_idx] == provisional_value:       <L 1654>
            var_592 = &((var_reducer_data).ht_values);
            var_593 = wp::mul(var_578, var_1);
            var_594 = wp::add(var_593, var_12);
            var_596 = wp::load(var_592);
            var_595 = wp::address(var_596, var_594);
            var_598 = wp::load(var_595);
            var_597 = (var_598 == var_590);
            if (var_597) {
                // still_wins = True                                                          <L 1655>
            }
            var_600 = wp::where(var_597, var_599, var_577);
        }
        var_601 = wp::where(var_579, var_586, var_574);
        var_602 = wp::where(var_579, var_587, var_575);
        var_603 = wp::where(var_579, var_590, var_576);
        var_604 = wp::where(var_579, var_600, var_577);
        // if not still_wins and (won_mask & (1 << dir_i)) != 0:                              <L 1648>
        var_607 = wp::unot(var_604);
        var_606 = var_607;
        if (var_606) {
            var_609 = wp::lshift(var_608, var_605);
            var_610 = wp::bit_and(var_461, var_609);
            var_612 = (var_610 != var_611);
            var_606 = var_606 && var_612;
        }
        if (var_606) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1649>
            var_613 = get_spatial_direction_2d_0(var_605);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1650>
            var_614 = wp::dot(var_8, var_613);
            // provisional_value = make_spatial_contact_value(                                <L 1651>
            // score, use_inner, fingerprint, 0, reducer_data.deterministic                   <L 1652>
            var_616 = &((var_reducer_data).deterministic);
            var_618 = wp::load(var_616);
            var_617 = make_spatial_contact_value_0(var_614, var_3, var_fingerprint, var_615, var_618);
            // if reducer_data.ht_values[dir_i * ht_capacity + entry_idx] == provisional_value:       <L 1654>
            var_619 = &((var_reducer_data).ht_values);
            var_620 = wp::mul(var_605, var_1);
            var_621 = wp::add(var_620, var_12);
            var_623 = wp::load(var_619);
            var_622 = wp::address(var_623, var_621);
            var_625 = wp::load(var_622);
            var_624 = (var_625 == var_617);
            if (var_624) {
                // still_wins = True                                                          <L 1655>
            }
            var_627 = wp::where(var_624, var_626, var_604);
        }
        var_628 = wp::where(var_606, var_613, var_601);
        var_629 = wp::where(var_606, var_614, var_602);
        var_630 = wp::where(var_606, var_617, var_603);
        var_631 = wp::where(var_606, var_627, var_604);
        // if not still_wins and use_inner and (won_mask & (1 << wp.static(NUM_SPATIAL_DIRECTIONS))) != 0:       <L 1657>
        var_633 = wp::unot(var_631);
        var_632 = var_633;
        if (var_632) {
            var_632 = var_632 && var_3;
        }
        if (var_632) {
            var_636 = wp::lshift(var_634, var_635);
            var_637 = wp::bit_and(var_461, var_636);
            var_639 = (var_637 != var_638);
            var_632 = var_632 && var_639;
        }
        if (var_632) {
            // provisional_value = make_contact_value(-depth, fingerprint, 0, reducer_data.deterministic)       <L 1658>
            var_640 = wp::neg(var_depth);
            var_642 = &((var_reducer_data).deterministic);
            var_644 = wp::load(var_642);
            var_643 = make_contact_value_0(var_640, var_fingerprint, var_641, var_644);
            // if reducer_data.ht_values[wp.static(NUM_SPATIAL_DIRECTIONS) * ht_capacity + entry_idx] == provisional_value:       <L 1659>
            var_645 = &((var_reducer_data).ht_values);
            var_647 = wp::mul(var_646, var_1);
            var_648 = wp::add(var_647, var_12);
            var_650 = wp::load(var_645);
            var_649 = wp::address(var_650, var_648);
            var_652 = wp::load(var_649);
            var_651 = (var_652 == var_643);
            if (var_651) {
                // still_wins = True                                                          <L 1660>
            }
            var_654 = wp::where(var_651, var_653, var_631);
        }
        var_655 = wp::where(var_632, var_643, var_630);
        var_656 = wp::where(var_632, var_654, var_631);
    }
    var_657 = wp::where(var_469, var_605, var_437);
    var_658 = wp::where(var_469, var_628, var_438);
    var_659 = wp::where(var_469, var_629, var_439);
    var_660 = wp::where(var_469, var_655, var_462);
    var_661 = wp::where(var_469, var_656, var_467);
    // if (                                                                                   <L 1662>
    // not still_wins                                                                         <L 1663>
    var_663 = wp::unot(var_661);
    var_662 = var_663;
    if (var_662) {
        // and use_inner                                                                      <L 1664>
        var_662 = var_662 && var_3;
    }
    if (var_662) {
        // and voxel_entry_idx >= 0                                                           <L 1665>
        var_665 = (var_216 >= var_664);
        var_662 = var_662 && var_665;
    }
    if (var_662) {
        // and (won_mask & (1 << wp.static(NUM_SPATIAL_DIRECTIONS + 1))) != 0                 <L 1666>
        var_668 = wp::lshift(var_666, var_667);
        var_669 = wp::bit_and(var_461, var_668);
        var_671 = (var_669 != var_670);
        var_662 = var_662 && var_671;
    }
    if (var_662) {
        // provisional_value = make_contact_value(-depth, fingerprint, 0, reducer_data.deterministic)       <L 1668>
        var_672 = wp::neg(var_depth);
        var_674 = &((var_reducer_data).deterministic);
        var_676 = wp::load(var_674);
        var_675 = make_contact_value_0(var_672, var_fingerprint, var_673, var_676);
        // if reducer_data.ht_values[voxel_local_slot * ht_capacity + voxel_entry_idx] == provisional_value:       <L 1669>
        var_677 = &((var_reducer_data).ht_values);
        var_678 = wp::mul(var_169, var_1);
        var_679 = wp::add(var_678, var_216);
        var_681 = wp::load(var_677);
        var_680 = wp::address(var_681, var_679);
        var_683 = wp::load(var_680);
        var_682 = (var_683 == var_675);
        if (var_682) {
            // still_wins = True                                                              <L 1670>
        }
        var_685 = wp::where(var_682, var_684, var_661);
    }
    var_686 = wp::where(var_662, var_675, var_660);
    var_687 = wp::where(var_662, var_685, var_661);
    // if not still_wins:                                                                     <L 1672>
    var_688 = wp::unot(var_687);
    if (var_688) {
        // return -1                                                                          <L 1673>
        return var_689;
    }
    // contact_id = export_contact_to_buffer(shape_a, shape_b, position, normal, depth, fingerprint, reducer_data)       <L 1674>
    var_690 = export_contact_to_buffer_0(var_shape_a, var_shape_b, var_position, var_normal, var_depth, var_fingerprint, var_reducer_data);
    // if contact_id < 0:                                                                     <L 1675>
    var_692 = (var_690 < var_691);
    if (var_692) {
        // if entry_idx >= 0:                                                                 <L 1676>
        var_694 = (var_12 >= var_693);
        if (var_694) {
            // for dir_i in range(wp.static(NUM_SPATIAL_DIRECTIONS)):                         <L 1677>
            // if (won_mask & (1 << dir_i)) != 0:                                             <L 1678>
            var_697 = wp::lshift(var_696, var_695);
            var_698 = wp::bit_and(var_461, var_697);
            var_700 = (var_698 != var_699);
            if (var_700) {
                // dir_2d = get_spatial_direction_2d(dir_i)                                   <L 1679>
                var_701 = get_spatial_direction_2d_0(var_695);
                // score = wp.dot(pos_2d, dir_2d)                                             <L 1680>
                var_702 = wp::dot(var_8, var_701);
                // provisional_value = make_spatial_contact_value(                            <L 1681>
                // score, use_inner, fingerprint, 0, reducer_data.deterministic               <L 1682>
                var_704 = &((var_reducer_data).deterministic);
                var_706 = wp::load(var_704);
                var_705 = make_spatial_contact_value_0(var_702, var_3, var_fingerprint, var_703, var_706);
                // reduction_rollback_slot(                                                   <L 1684>
                // entry_idx,                                                                 <L 1685>
                // dir_i,                                                                     <L 1686>
                // provisional_value,                                                         <L 1687>
                // replaced_values[dir_i],                                                    <L 1688>
                var_707 = wp::extract(var_219, var_695);
                // reducer_data.ht_values,                                                    <L 1689>
                var_708 = &((var_reducer_data).ht_values);
                // ht_capacity,                                                               <L 1690>
                var_709 = wp::load(var_708);
                reduction_rollback_slot_0(var_12, var_695, var_705, var_707, var_709, var_1);
            }
            var_710 = wp::where(var_700, var_701, var_658);
            var_711 = wp::where(var_700, var_702, var_659);
            var_712 = wp::where(var_700, var_705, var_686);
            // if (won_mask & (1 << dir_i)) != 0:                                             <L 1678>
            var_715 = wp::lshift(var_714, var_713);
            var_716 = wp::bit_and(var_461, var_715);
            var_718 = (var_716 != var_717);
            if (var_718) {
                // dir_2d = get_spatial_direction_2d(dir_i)                                   <L 1679>
                var_719 = get_spatial_direction_2d_0(var_713);
                // score = wp.dot(pos_2d, dir_2d)                                             <L 1680>
                var_720 = wp::dot(var_8, var_719);
                // provisional_value = make_spatial_contact_value(                            <L 1681>
                // score, use_inner, fingerprint, 0, reducer_data.deterministic               <L 1682>
                var_722 = &((var_reducer_data).deterministic);
                var_724 = wp::load(var_722);
                var_723 = make_spatial_contact_value_0(var_720, var_3, var_fingerprint, var_721, var_724);
                // reduction_rollback_slot(                                                   <L 1684>
                // entry_idx,                                                                 <L 1685>
                // dir_i,                                                                     <L 1686>
                // provisional_value,                                                         <L 1687>
                // replaced_values[dir_i],                                                    <L 1688>
                var_725 = wp::extract(var_219, var_713);
                // reducer_data.ht_values,                                                    <L 1689>
                var_726 = &((var_reducer_data).ht_values);
                // ht_capacity,                                                               <L 1690>
                var_727 = wp::load(var_726);
                reduction_rollback_slot_0(var_12, var_713, var_723, var_725, var_727, var_1);
            }
            var_728 = wp::where(var_718, var_719, var_710);
            var_729 = wp::where(var_718, var_720, var_711);
            var_730 = wp::where(var_718, var_723, var_712);
            // if (won_mask & (1 << dir_i)) != 0:                                             <L 1678>
            var_733 = wp::lshift(var_732, var_731);
            var_734 = wp::bit_and(var_461, var_733);
            var_736 = (var_734 != var_735);
            if (var_736) {
                // dir_2d = get_spatial_direction_2d(dir_i)                                   <L 1679>
                var_737 = get_spatial_direction_2d_0(var_731);
                // score = wp.dot(pos_2d, dir_2d)                                             <L 1680>
                var_738 = wp::dot(var_8, var_737);
                // provisional_value = make_spatial_contact_value(                            <L 1681>
                // score, use_inner, fingerprint, 0, reducer_data.deterministic               <L 1682>
                var_740 = &((var_reducer_data).deterministic);
                var_742 = wp::load(var_740);
                var_741 = make_spatial_contact_value_0(var_738, var_3, var_fingerprint, var_739, var_742);
                // reduction_rollback_slot(                                                   <L 1684>
                // entry_idx,                                                                 <L 1685>
                // dir_i,                                                                     <L 1686>
                // provisional_value,                                                         <L 1687>
                // replaced_values[dir_i],                                                    <L 1688>
                var_743 = wp::extract(var_219, var_731);
                // reducer_data.ht_values,                                                    <L 1689>
                var_744 = &((var_reducer_data).ht_values);
                // ht_capacity,                                                               <L 1690>
                var_745 = wp::load(var_744);
                reduction_rollback_slot_0(var_12, var_731, var_741, var_743, var_745, var_1);
            }
            var_746 = wp::where(var_736, var_737, var_728);
            var_747 = wp::where(var_736, var_738, var_729);
            var_748 = wp::where(var_736, var_741, var_730);
            // if (won_mask & (1 << dir_i)) != 0:                                             <L 1678>
            var_751 = wp::lshift(var_750, var_749);
            var_752 = wp::bit_and(var_461, var_751);
            var_754 = (var_752 != var_753);
            if (var_754) {
                // dir_2d = get_spatial_direction_2d(dir_i)                                   <L 1679>
                var_755 = get_spatial_direction_2d_0(var_749);
                // score = wp.dot(pos_2d, dir_2d)                                             <L 1680>
                var_756 = wp::dot(var_8, var_755);
                // provisional_value = make_spatial_contact_value(                            <L 1681>
                // score, use_inner, fingerprint, 0, reducer_data.deterministic               <L 1682>
                var_758 = &((var_reducer_data).deterministic);
                var_760 = wp::load(var_758);
                var_759 = make_spatial_contact_value_0(var_756, var_3, var_fingerprint, var_757, var_760);
                // reduction_rollback_slot(                                                   <L 1684>
                // entry_idx,                                                                 <L 1685>
                // dir_i,                                                                     <L 1686>
                // provisional_value,                                                         <L 1687>
                // replaced_values[dir_i],                                                    <L 1688>
                var_761 = wp::extract(var_219, var_749);
                // reducer_data.ht_values,                                                    <L 1689>
                var_762 = &((var_reducer_data).ht_values);
                // ht_capacity,                                                               <L 1690>
                var_763 = wp::load(var_762);
                reduction_rollback_slot_0(var_12, var_749, var_759, var_761, var_763, var_1);
            }
            var_764 = wp::where(var_754, var_755, var_746);
            var_765 = wp::where(var_754, var_756, var_747);
            var_766 = wp::where(var_754, var_759, var_748);
            // if (won_mask & (1 << dir_i)) != 0:                                             <L 1678>
            var_769 = wp::lshift(var_768, var_767);
            var_770 = wp::bit_and(var_461, var_769);
            var_772 = (var_770 != var_771);
            if (var_772) {
                // dir_2d = get_spatial_direction_2d(dir_i)                                   <L 1679>
                var_773 = get_spatial_direction_2d_0(var_767);
                // score = wp.dot(pos_2d, dir_2d)                                             <L 1680>
                var_774 = wp::dot(var_8, var_773);
                // provisional_value = make_spatial_contact_value(                            <L 1681>
                // score, use_inner, fingerprint, 0, reducer_data.deterministic               <L 1682>
                var_776 = &((var_reducer_data).deterministic);
                var_778 = wp::load(var_776);
                var_777 = make_spatial_contact_value_0(var_774, var_3, var_fingerprint, var_775, var_778);
                // reduction_rollback_slot(                                                   <L 1684>
                // entry_idx,                                                                 <L 1685>
                // dir_i,                                                                     <L 1686>
                // provisional_value,                                                         <L 1687>
                // replaced_values[dir_i],                                                    <L 1688>
                var_779 = wp::extract(var_219, var_767);
                // reducer_data.ht_values,                                                    <L 1689>
                var_780 = &((var_reducer_data).ht_values);
                // ht_capacity,                                                               <L 1690>
                var_781 = wp::load(var_780);
                reduction_rollback_slot_0(var_12, var_767, var_777, var_779, var_781, var_1);
            }
            var_782 = wp::where(var_772, var_773, var_764);
            var_783 = wp::where(var_772, var_774, var_765);
            var_784 = wp::where(var_772, var_777, var_766);
            // if (won_mask & (1 << dir_i)) != 0:                                             <L 1678>
            var_787 = wp::lshift(var_786, var_785);
            var_788 = wp::bit_and(var_461, var_787);
            var_790 = (var_788 != var_789);
            if (var_790) {
                // dir_2d = get_spatial_direction_2d(dir_i)                                   <L 1679>
                var_791 = get_spatial_direction_2d_0(var_785);
                // score = wp.dot(pos_2d, dir_2d)                                             <L 1680>
                var_792 = wp::dot(var_8, var_791);
                // provisional_value = make_spatial_contact_value(                            <L 1681>
                // score, use_inner, fingerprint, 0, reducer_data.deterministic               <L 1682>
                var_794 = &((var_reducer_data).deterministic);
                var_796 = wp::load(var_794);
                var_795 = make_spatial_contact_value_0(var_792, var_3, var_fingerprint, var_793, var_796);
                // reduction_rollback_slot(                                                   <L 1684>
                // entry_idx,                                                                 <L 1685>
                // dir_i,                                                                     <L 1686>
                // provisional_value,                                                         <L 1687>
                // replaced_values[dir_i],                                                    <L 1688>
                var_797 = wp::extract(var_219, var_785);
                // reducer_data.ht_values,                                                    <L 1689>
                var_798 = &((var_reducer_data).ht_values);
                // ht_capacity,                                                               <L 1690>
                var_799 = wp::load(var_798);
                reduction_rollback_slot_0(var_12, var_785, var_795, var_797, var_799, var_1);
            }
            var_800 = wp::where(var_790, var_791, var_782);
            var_801 = wp::where(var_790, var_792, var_783);
            var_802 = wp::where(var_790, var_795, var_784);
            // if use_inner and (won_mask & (1 << wp.static(NUM_SPATIAL_DIRECTIONS))) != 0:       <L 1692>
            var_803 = var_3;
            if (var_803) {
                var_806 = wp::lshift(var_804, var_805);
                var_807 = wp::bit_and(var_461, var_806);
                var_809 = (var_807 != var_808);
                var_803 = var_803 && var_809;
            }
            if (var_803) {
                // provisional_value = make_contact_value(-depth, fingerprint, 0, reducer_data.deterministic)       <L 1693>
                var_810 = wp::neg(var_depth);
                var_812 = &((var_reducer_data).deterministic);
                var_814 = wp::load(var_812);
                var_813 = make_contact_value_0(var_810, var_fingerprint, var_811, var_814);
                // reduction_rollback_slot(                                                   <L 1694>
                // entry_idx,                                                                 <L 1695>
                // wp.static(NUM_SPATIAL_DIRECTIONS),                                         <L 1696>
                // provisional_value,                                                         <L 1697>
                // replaced_values[wp.static(NUM_SPATIAL_DIRECTIONS)],                        <L 1698>
                var_817 = wp::extract(var_219, var_816);
                // reducer_data.ht_values,                                                    <L 1699>
                var_818 = &((var_reducer_data).ht_values);
                // ht_capacity,                                                               <L 1700>
                var_819 = wp::load(var_818);
                reduction_rollback_slot_0(var_12, var_815, var_813, var_817, var_819, var_1);
            }
            var_820 = wp::where(var_803, var_813, var_802);
        }
        var_821 = wp::where(var_694, var_785, var_657);
        var_822 = wp::where(var_694, var_800, var_658);
        var_823 = wp::where(var_694, var_801, var_659);
        var_824 = wp::where(var_694, var_820, var_686);
        // if use_inner and voxel_entry_idx >= 0 and (won_mask & (1 << wp.static(NUM_SPATIAL_DIRECTIONS + 1))) != 0:       <L 1702>
        var_825 = var_3;
        if (var_825) {
            var_827 = (var_216 >= var_826);
            var_825 = var_825 && var_827;
        }
        if (var_825) {
            var_830 = wp::lshift(var_828, var_829);
            var_831 = wp::bit_and(var_461, var_830);
            var_833 = (var_831 != var_832);
            var_825 = var_825 && var_833;
        }
        if (var_825) {
            // provisional_value = make_contact_value(-depth, fingerprint, 0, reducer_data.deterministic)       <L 1703>
            var_834 = wp::neg(var_depth);
            var_836 = &((var_reducer_data).deterministic);
            var_838 = wp::load(var_836);
            var_837 = make_contact_value_0(var_834, var_fingerprint, var_835, var_838);
            // reduction_rollback_slot(                                                       <L 1704>
            // voxel_entry_idx,                                                               <L 1705>
            // voxel_local_slot,                                                              <L 1706>
            // provisional_value,                                                             <L 1707>
            // replaced_values[wp.static(NUM_SPATIAL_DIRECTIONS + 1)],                        <L 1708>
            var_840 = wp::extract(var_219, var_839);
            // reducer_data.ht_values,                                                        <L 1709>
            var_841 = &((var_reducer_data).ht_values);
            // ht_capacity,                                                                   <L 1710>
            var_842 = wp::load(var_841);
            reduction_rollback_slot_0(var_216, var_169, var_837, var_840, var_842, var_1);
        }
        var_843 = wp::where(var_825, var_837, var_824);
        // return -1                                                                          <L 1712>
        return var_844;
    }
    var_845 = wp::where(var_692, var_821, var_657);
    var_846 = wp::where(var_692, var_822, var_658);
    var_847 = wp::where(var_692, var_823, var_659);
    var_848 = wp::where(var_692, var_843, var_686);
    // if use_inner and entry_idx >= 0:                                                       <L 1714>
    var_849 = var_3;
    if (var_849) {
        var_851 = (var_12 >= var_850);
        var_849 = var_849 && var_851;
    }
    if (var_849) {
        // for dir_i in range(wp.static(NUM_SPATIAL_DIRECTIONS)):                             <L 1715>
        // dir_2d = get_spatial_direction_2d(dir_i)                                           <L 1716>
        var_853 = get_spatial_direction_2d_0(var_852);
        // score = wp.dot(pos_2d, dir_2d)                                                     <L 1717>
        var_854 = wp::dot(var_8, var_853);
        // value = make_spatial_contact_value(score, True, fingerprint, contact_id, reducer_data.deterministic)       <L 1718>
        var_856 = &((var_reducer_data).deterministic);
        var_858 = wp::load(var_856);
        var_857 = make_spatial_contact_value_0(var_854, var_855, var_fingerprint, var_690, var_858);
        // reduction_update_slot(entry_idx, dir_i, value, reducer_data.ht_values, ht_capacity)       <L 1719>
        var_859 = &((var_reducer_data).ht_values);
        var_860 = wp::load(var_859);
        reduction_update_slot_0(var_12, var_852, var_857, var_860, var_1);
        // dir_2d = get_spatial_direction_2d(dir_i)                                           <L 1716>
        var_862 = get_spatial_direction_2d_0(var_861);
        // score = wp.dot(pos_2d, dir_2d)                                                     <L 1717>
        var_863 = wp::dot(var_8, var_862);
        // value = make_spatial_contact_value(score, True, fingerprint, contact_id, reducer_data.deterministic)       <L 1718>
        var_865 = &((var_reducer_data).deterministic);
        var_867 = wp::load(var_865);
        var_866 = make_spatial_contact_value_0(var_863, var_864, var_fingerprint, var_690, var_867);
        // reduction_update_slot(entry_idx, dir_i, value, reducer_data.ht_values, ht_capacity)       <L 1719>
        var_868 = &((var_reducer_data).ht_values);
        var_869 = wp::load(var_868);
        reduction_update_slot_0(var_12, var_861, var_866, var_869, var_1);
        // dir_2d = get_spatial_direction_2d(dir_i)                                           <L 1716>
        var_871 = get_spatial_direction_2d_0(var_870);
        // score = wp.dot(pos_2d, dir_2d)                                                     <L 1717>
        var_872 = wp::dot(var_8, var_871);
        // value = make_spatial_contact_value(score, True, fingerprint, contact_id, reducer_data.deterministic)       <L 1718>
        var_874 = &((var_reducer_data).deterministic);
        var_876 = wp::load(var_874);
        var_875 = make_spatial_contact_value_0(var_872, var_873, var_fingerprint, var_690, var_876);
        // reduction_update_slot(entry_idx, dir_i, value, reducer_data.ht_values, ht_capacity)       <L 1719>
        var_877 = &((var_reducer_data).ht_values);
        var_878 = wp::load(var_877);
        reduction_update_slot_0(var_12, var_870, var_875, var_878, var_1);
        // dir_2d = get_spatial_direction_2d(dir_i)                                           <L 1716>
        var_880 = get_spatial_direction_2d_0(var_879);
        // score = wp.dot(pos_2d, dir_2d)                                                     <L 1717>
        var_881 = wp::dot(var_8, var_880);
        // value = make_spatial_contact_value(score, True, fingerprint, contact_id, reducer_data.deterministic)       <L 1718>
        var_883 = &((var_reducer_data).deterministic);
        var_885 = wp::load(var_883);
        var_884 = make_spatial_contact_value_0(var_881, var_882, var_fingerprint, var_690, var_885);
        // reduction_update_slot(entry_idx, dir_i, value, reducer_data.ht_values, ht_capacity)       <L 1719>
        var_886 = &((var_reducer_data).ht_values);
        var_887 = wp::load(var_886);
        reduction_update_slot_0(var_12, var_879, var_884, var_887, var_1);
        // dir_2d = get_spatial_direction_2d(dir_i)                                           <L 1716>
        var_889 = get_spatial_direction_2d_0(var_888);
        // score = wp.dot(pos_2d, dir_2d)                                                     <L 1717>
        var_890 = wp::dot(var_8, var_889);
        // value = make_spatial_contact_value(score, True, fingerprint, contact_id, reducer_data.deterministic)       <L 1718>
        var_892 = &((var_reducer_data).deterministic);
        var_894 = wp::load(var_892);
        var_893 = make_spatial_contact_value_0(var_890, var_891, var_fingerprint, var_690, var_894);
        // reduction_update_slot(entry_idx, dir_i, value, reducer_data.ht_values, ht_capacity)       <L 1719>
        var_895 = &((var_reducer_data).ht_values);
        var_896 = wp::load(var_895);
        reduction_update_slot_0(var_12, var_888, var_893, var_896, var_1);
        // dir_2d = get_spatial_direction_2d(dir_i)                                           <L 1716>
        var_898 = get_spatial_direction_2d_0(var_897);
        // score = wp.dot(pos_2d, dir_2d)                                                     <L 1717>
        var_899 = wp::dot(var_8, var_898);
        // value = make_spatial_contact_value(score, True, fingerprint, contact_id, reducer_data.deterministic)       <L 1718>
        var_901 = &((var_reducer_data).deterministic);
        var_903 = wp::load(var_901);
        var_902 = make_spatial_contact_value_0(var_899, var_900, var_fingerprint, var_690, var_903);
        // reduction_update_slot(entry_idx, dir_i, value, reducer_data.ht_values, ht_capacity)       <L 1719>
        var_904 = &((var_reducer_data).ht_values);
        var_905 = wp::load(var_904);
        reduction_update_slot_0(var_12, var_897, var_902, var_905, var_1);
        // max_depth_value = make_contact_value(-depth, fingerprint, contact_id, reducer_data.deterministic)       <L 1721>
        var_906 = wp::neg(var_depth);
        var_907 = &((var_reducer_data).deterministic);
        var_909 = wp::load(var_907);
        var_908 = make_contact_value_0(var_906, var_fingerprint, var_690, var_909);
        // reduction_update_slot(                                                             <L 1722>
        // entry_idx, wp.static(NUM_SPATIAL_DIRECTIONS), max_depth_value, reducer_data.ht_values, ht_capacity       <L 1723>
        var_911 = &((var_reducer_data).ht_values);
        var_912 = wp::load(var_911);
        reduction_update_slot_0(var_12, var_910, var_908, var_912, var_1);
    }
    if (!var_849) {
        // elif entry_idx >= 0:                                                               <L 1725>
        var_914 = (var_12 >= var_913);
        if (var_914) {
            // for dir_i in range(wp.static(NUM_SPATIAL_DIRECTIONS)):                         <L 1726>
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1727>
            var_916 = get_spatial_direction_2d_0(var_915);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1728>
            var_917 = wp::dot(var_8, var_916);
            // value = make_spatial_contact_value(score, False, fingerprint, contact_id, reducer_data.deterministic)       <L 1729>
            var_919 = &((var_reducer_data).deterministic);
            var_921 = wp::load(var_919);
            var_920 = make_spatial_contact_value_0(var_917, var_918, var_fingerprint, var_690, var_921);
            // reduction_update_slot(entry_idx, dir_i, value, reducer_data.ht_values, ht_capacity)       <L 1730>
            var_922 = &((var_reducer_data).ht_values);
            var_923 = wp::load(var_922);
            reduction_update_slot_0(var_12, var_915, var_920, var_923, var_1);
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1727>
            var_925 = get_spatial_direction_2d_0(var_924);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1728>
            var_926 = wp::dot(var_8, var_925);
            // value = make_spatial_contact_value(score, False, fingerprint, contact_id, reducer_data.deterministic)       <L 1729>
            var_928 = &((var_reducer_data).deterministic);
            var_930 = wp::load(var_928);
            var_929 = make_spatial_contact_value_0(var_926, var_927, var_fingerprint, var_690, var_930);
            // reduction_update_slot(entry_idx, dir_i, value, reducer_data.ht_values, ht_capacity)       <L 1730>
            var_931 = &((var_reducer_data).ht_values);
            var_932 = wp::load(var_931);
            reduction_update_slot_0(var_12, var_924, var_929, var_932, var_1);
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1727>
            var_934 = get_spatial_direction_2d_0(var_933);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1728>
            var_935 = wp::dot(var_8, var_934);
            // value = make_spatial_contact_value(score, False, fingerprint, contact_id, reducer_data.deterministic)       <L 1729>
            var_937 = &((var_reducer_data).deterministic);
            var_939 = wp::load(var_937);
            var_938 = make_spatial_contact_value_0(var_935, var_936, var_fingerprint, var_690, var_939);
            // reduction_update_slot(entry_idx, dir_i, value, reducer_data.ht_values, ht_capacity)       <L 1730>
            var_940 = &((var_reducer_data).ht_values);
            var_941 = wp::load(var_940);
            reduction_update_slot_0(var_12, var_933, var_938, var_941, var_1);
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1727>
            var_943 = get_spatial_direction_2d_0(var_942);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1728>
            var_944 = wp::dot(var_8, var_943);
            // value = make_spatial_contact_value(score, False, fingerprint, contact_id, reducer_data.deterministic)       <L 1729>
            var_946 = &((var_reducer_data).deterministic);
            var_948 = wp::load(var_946);
            var_947 = make_spatial_contact_value_0(var_944, var_945, var_fingerprint, var_690, var_948);
            // reduction_update_slot(entry_idx, dir_i, value, reducer_data.ht_values, ht_capacity)       <L 1730>
            var_949 = &((var_reducer_data).ht_values);
            var_950 = wp::load(var_949);
            reduction_update_slot_0(var_12, var_942, var_947, var_950, var_1);
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1727>
            var_952 = get_spatial_direction_2d_0(var_951);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1728>
            var_953 = wp::dot(var_8, var_952);
            // value = make_spatial_contact_value(score, False, fingerprint, contact_id, reducer_data.deterministic)       <L 1729>
            var_955 = &((var_reducer_data).deterministic);
            var_957 = wp::load(var_955);
            var_956 = make_spatial_contact_value_0(var_953, var_954, var_fingerprint, var_690, var_957);
            // reduction_update_slot(entry_idx, dir_i, value, reducer_data.ht_values, ht_capacity)       <L 1730>
            var_958 = &((var_reducer_data).ht_values);
            var_959 = wp::load(var_958);
            reduction_update_slot_0(var_12, var_951, var_956, var_959, var_1);
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1727>
            var_961 = get_spatial_direction_2d_0(var_960);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1728>
            var_962 = wp::dot(var_8, var_961);
            // value = make_spatial_contact_value(score, False, fingerprint, contact_id, reducer_data.deterministic)       <L 1729>
            var_964 = &((var_reducer_data).deterministic);
            var_966 = wp::load(var_964);
            var_965 = make_spatial_contact_value_0(var_962, var_963, var_fingerprint, var_690, var_966);
            // reduction_update_slot(entry_idx, dir_i, value, reducer_data.ht_values, ht_capacity)       <L 1730>
            var_967 = &((var_reducer_data).ht_values);
            var_968 = wp::load(var_967);
            reduction_update_slot_0(var_12, var_960, var_965, var_968, var_1);
        }
        var_969 = wp::where(var_914, var_960, var_845);
        var_970 = wp::where(var_914, var_961, var_846);
        var_971 = wp::where(var_914, var_962, var_847);
    }
    var_972 = wp::where(var_849, var_897, var_969);
    var_973 = wp::where(var_849, var_898, var_970);
    var_974 = wp::where(var_849, var_899, var_971);
    var_975 = wp::where(var_849, var_902, var_965);
    // if use_inner:                                                                          <L 1732>
    if (var_3) {
        // if voxel_entry_idx < 0:                                                            <L 1733>
        var_977 = (var_216 < var_976);
        if (var_977) {
            // voxel_entry_idx = hashtable_find_or_insert(voxel_key, reducer_data.ht_keys, reducer_data.ht_active_slots)       <L 1734>
            var_978 = &((var_reducer_data).ht_keys);
            var_979 = &((var_reducer_data).ht_active_slots);
            var_981 = wp::load(var_978);
            var_982 = wp::load(var_979);
            var_980 = hashtable_find_or_insert_0(var_172, var_981, var_982);
        }
        var_983 = wp::where(var_977, var_980, var_216);
        // if voxel_entry_idx >= 0:                                                           <L 1735>
        var_985 = (var_983 >= var_984);
        if (var_985) {
            // voxel_value = make_contact_value(-depth, fingerprint, contact_id, reducer_data.deterministic)       <L 1736>
            var_986 = wp::neg(var_depth);
            var_987 = &((var_reducer_data).deterministic);
            var_989 = wp::load(var_987);
            var_988 = make_contact_value_0(var_986, var_fingerprint, var_690, var_989);
            // reduction_update_slot(voxel_entry_idx, voxel_local_slot, voxel_value, reducer_data.ht_values, ht_capacity)       <L 1737>
            var_990 = &((var_reducer_data).ht_values);
            var_991 = wp::load(var_990);
            reduction_update_slot_0(var_983, var_169, var_988, var_991, var_1);
        }
        if (!var_985) {
            // wp.atomic_add(reducer_data.ht_insert_failures, 0, 1)                           <L 1739>
            var_992 = &((var_reducer_data).ht_insert_failures);
            var_996 = wp::load(var_992);
            var_995 = wp::atomic_add(var_996, var_993, var_994);
        }
    }
    var_997 = wp::where(var_3, var_983, var_216);
    // return contact_id                                                                      <L 1741>
    return var_690;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/kernels.py:15
static CUDA_CALLABLE void adj_resolve_mesh_sign_method_0(
    wp::int32 var_mesh_properties,
    wp::int32 & adj_mesh_properties,
    wp::int32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:120
static CUDA_CALLABLE void adj_safe_sdf_scale_inverse_0(
    wp::vec_t<3, wp::float32> var_sdf_scale,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::float32 & ret_1,
    wp::vec_t<3, wp::float32> & adj_sdf_scale,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::float32 & adj_ret_1)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:80
static CUDA_CALLABLE void adj_mesh_sdf_contact_search_precision_0(
    wp::float32 var_inner_contact_threshold,
    wp::float32 var_min_sdf_scale,
    wp::float32 var_voxel_radius,
    bool var_use_texture_sdf,
    wp::float32 & adj_inner_contact_threshold,
    wp::float32 & adj_min_sdf_scale,
    wp::float32 & adj_voxel_radius,
    bool & adj_use_texture_sdf,
    wp::float32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:641
static CUDA_CALLABLE void adj_get_edge_count_0(
    wp::int32 var_shape_type,
    wp::vec_t<2, wp::int32> var_edge_range,
    HeightfieldData_f2b8d59a var_hfd,
    wp::int32 & adj_shape_type,
    wp::vec_t<2, wp::int32> & adj_edge_range,
    HeightfieldData_f2b8d59a & adj_hfd,
    wp::int32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:419
static CUDA_CALLABLE void adj_get_edge_from_mesh_0(
    wp::uint64 var_mesh_id,
    wp::array_t<wp::vec_t<2, wp::int32>> var_mesh_edge_indices,
    wp::vec_t<2, wp::int32> var_edge_range,
    wp::vec_t<3, wp::float32> var_mesh_scale,
    wp::transform_t<wp::float32> var_X_mesh_ws,
    wp::int32 var_edge_idx,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::uint64 & adj_mesh_id,
    wp::array_t<wp::vec_t<2, wp::int32>> & adj_mesh_edge_indices,
    wp::vec_t<2, wp::int32> & adj_edge_range,
    wp::vec_t<3, wp::float32> & adj_mesh_scale,
    wp::transform_t<wp::float32> & adj_X_mesh_ws,
    wp::int32 & adj_edge_idx,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:586
static CUDA_CALLABLE void adj_get_edge_bounding_sphere_0(
    wp::vec_t<3, wp::float32> var_v0,
    wp::vec_t<3, wp::float32> var_v1,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::float32 & ret_1,
    wp::vec_t<3, wp::float32> & adj_v0,
    wp::vec_t<3, wp::float32> & adj_v1,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::float32 & adj_ret_1)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:605
static CUDA_CALLABLE void adj__create_get_mesh_edge_bounding_sphere_func__locals__get_mesh_edge_bounding_sphere_func_1(
    wp::uint64 var_mesh_id,
    wp::array_t<wp::vec_t<2, wp::int32>> var_mesh_edge_indices,
    wp::array_t<wp::vec_t<4, wp::float32>> var_mesh_edge_centers,
    wp::vec_t<2, wp::int32> var_edge_range,
    wp::vec_t<3, wp::float32> var_mesh_scale,
    wp::transform_t<wp::float32> var_X_mesh_ws,
    wp::vec_t<3, wp::float32> var_inv_sdf_scale,
    wp::float32 var_radius_scale,
    wp::int32 var_edge_idx,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::float32 & ret_1,
    wp::uint64 & adj_mesh_id,
    wp::array_t<wp::vec_t<2, wp::int32>> & adj_mesh_edge_indices,
    wp::array_t<wp::vec_t<4, wp::float32>> & adj_mesh_edge_centers,
    wp::vec_t<2, wp::int32> & adj_edge_range,
    wp::vec_t<3, wp::float32> & adj_mesh_scale,
    wp::transform_t<wp::float32> & adj_X_mesh_ws,
    wp::vec_t<3, wp::float32> & adj_inv_sdf_scale,
    wp::float32 & adj_radius_scale,
    wp::int32 & adj_edge_idx,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::float32 & adj_ret_1)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/utils/heightfield.py:171
static CUDA_CALLABLE void adj__heightfield_surface_query_0(
    HeightfieldData_f2b8d59a var_hfd,
    wp::array_t<wp::float32> var_elevation_data,
    wp::vec_t<3, wp::float32> var_pos,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::float32 & ret_2,
    HeightfieldData_f2b8d59a & adj_hfd,
    wp::array_t<wp::float32> & adj_elevation_data,
    wp::vec_t<3, wp::float32> & adj_pos,
    wp::float32 & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1,
    wp::float32 & adj_ret_2)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/utils/heightfield.py:230
static CUDA_CALLABLE void adj_sample_sdf_heightfield_0(
    HeightfieldData_f2b8d59a var_hfd,
    wp::array_t<wp::float32> var_elevation_data,
    wp::vec_t<3, wp::float32> var_pos,
    HeightfieldData_f2b8d59a & adj_hfd,
    wp::array_t<wp::float32> & adj_elevation_data,
    wp::vec_t<3, wp::float32> & adj_pos,
    wp::float32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/kernels.py:966
static CUDA_CALLABLE void adj_mesh_query_point_sign_0(
    wp::uint64 var_mesh,
    wp::vec_t<3, wp::float32> var_point,
    wp::float32 var_max_dist,
    wp::int32 var_sign_method,
    wp::uint64 & adj_mesh,
    wp::vec_t<3, wp::float32> & adj_point,
    wp::float32 & adj_max_dist,
    wp::int32 & adj_sign_method,
    wp::mesh_query_point_t & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:185
static CUDA_CALLABLE void adj_sample_sdf_using_mesh_0(
    wp::uint64 var_mesh_id,
    wp::vec_t<3, wp::float32> var_world_pos,
    wp::float32 var_max_dist,
    wp::int32 var_sign_method,
    wp::uint64 & adj_mesh_id,
    wp::vec_t<3, wp::float32> & adj_world_pos,
    wp::float32 & adj_max_dist,
    wp::int32 & adj_sign_method,
    wp::float32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:785
static CUDA_CALLABLE void adj__locate_cell_coords_0(
    TextureSDFData_93572308 var_sdf,
    wp::vec_t<3, wp::float32> var_f,
    TextureSDFData_93572308 & adj_sdf,
    wp::vec_t<3, wp::float32> & adj_f,
    _CellLookup_6716dbae & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:831
static CUDA_CALLABLE void adj__locate_cell_0(
    TextureSDFData_93572308 var_sdf,
    wp::vec_t<3, wp::float32> var_f,
    TextureSDFData_93572308 & adj_sdf,
    wp::vec_t<3, wp::float32> & adj_f,
    _CellLookup_6716dbae & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:753
static CUDA_CALLABLE void adj__texture_sample_sdf_x0_0(
    wp::texture3d_t var_texture,
    wp::vec_t<3, wp::float32> var_uvw,
    bool var_paired_samples,
    wp::texture3d_t & adj_texture,
    wp::vec_t<3, wp::float32> & adj_uvw,
    bool & adj_paired_samples,
    wp::float32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:1414
static CUDA_CALLABLE void adj__texture_sample_sdf_hw_clamped_variant_0(
    TextureSDFData_93572308 var_sdf,
    wp::vec_t<3, wp::float32> var_clamped,
    wp::float32 var_diff_mag,
    bool var_paired_samples,
    TextureSDFData_93572308 & adj_sdf,
    wp::vec_t<3, wp::float32> & adj_clamped,
    wp::float32 & adj_diff_mag,
    bool & adj_paired_samples,
    wp::float32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:1464
static CUDA_CALLABLE void adj__texture_sample_sdf_hw_clamped_0(
    TextureSDFData_93572308 var_sdf,
    wp::vec_t<3, wp::float32> var_clamped,
    wp::float32 var_diff_mag,
    TextureSDFData_93572308 & adj_sdf,
    wp::vec_t<3, wp::float32> & adj_clamped,
    wp::float32 & adj_diff_mag,
    wp::float32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:460
static CUDA_CALLABLE void adj_get_mesh_edge_precomputed_0(
    wp::array_t<wp::vec_t<4, wp::float32>> var_mesh_edge_centers,
    wp::array_t<wp::vec_t<4, wp::float32>> var_mesh_edge_halves,
    wp::vec_t<2, wp::int32> var_edge_range,
    wp::transform_t<wp::float32> var_X_mesh_ws,
    wp::int32 var_edge_idx,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::int32 & ret_2,
    wp::array_t<wp::vec_t<4, wp::float32>> & adj_mesh_edge_centers,
    wp::array_t<wp::vec_t<4, wp::float32>> & adj_mesh_edge_halves,
    wp::vec_t<2, wp::int32> & adj_edge_range,
    wp::transform_t<wp::float32> & adj_X_mesh_ws,
    wp::int32 & adj_edge_idx,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1,
    wp::int32 & adj_ret_2)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:486
static CUDA_CALLABLE void adj__create_mesh_edge_accessor_func__locals__get_edge_from_mesh_func_1(
    wp::uint64 var_mesh_id,
    wp::array_t<wp::vec_t<2, wp::int32>> var_mesh_edge_indices,
    wp::array_t<wp::vec_t<4, wp::float32>> var_mesh_edge_centers,
    wp::array_t<wp::vec_t<4, wp::float32>> var_mesh_edge_halves,
    wp::vec_t<2, wp::int32> var_edge_range,
    wp::vec_t<3, wp::float32> var_mesh_scale,
    wp::transform_t<wp::float32> var_X_mesh_ws,
    wp::int32 var_edge_idx,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::int32 & ret_2,
    wp::uint64 & adj_mesh_id,
    wp::array_t<wp::vec_t<2, wp::int32>> & adj_mesh_edge_indices,
    wp::array_t<wp::vec_t<4, wp::float32>> & adj_mesh_edge_centers,
    wp::array_t<wp::vec_t<4, wp::float32>> & adj_mesh_edge_halves,
    wp::vec_t<2, wp::int32> & adj_edge_range,
    wp::vec_t<3, wp::float32> & adj_mesh_scale,
    wp::transform_t<wp::float32> & adj_X_mesh_ws,
    wp::int32 & adj_edge_idx,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1,
    wp::int32 & adj_ret_2)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:68
static CUDA_CALLABLE void adj__sdf_rsqrt_rn_0(
    wp::float32 value,
    wp::float32 & adj_value,
    wp::float32 & adj_ret)
{
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:839
static CUDA_CALLABLE void adj__locate_cell_pair_0(
    TextureSDFData_93572308 var_sdf,
    wp::vec_t<3, wp::float32> var_f0,
    wp::vec_t<3, wp::float32> var_f1,
    _CellLookup_6716dbae & ret_0,
    _CellLookup_6716dbae & ret_1,
    TextureSDFData_93572308 & adj_sdf,
    wp::vec_t<3, wp::float32> & adj_f0,
    wp::vec_t<3, wp::float32> & adj_f1,
    _CellLookup_6716dbae & adj_ret_0,
    _CellLookup_6716dbae & adj_ret_1)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:1252
static CUDA_CALLABLE void adj__texture_sample_pair_0(
    wp::texture3d_t var_texture0,
    wp::vec_t<3, wp::float32> var_uvw0,
    wp::texture3d_t var_texture1,
    wp::vec_t<3, wp::float32> var_uvw1,
    bool var_paired_samples,
    wp::texture3d_t & adj_texture0,
    wp::vec_t<3, wp::float32> & adj_uvw0,
    wp::texture3d_t & adj_texture1,
    wp::vec_t<3, wp::float32> & adj_uvw1,
    bool & adj_paired_samples,
    wp::vec_t<2, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:1266
static CUDA_CALLABLE void adj__texture_sample_sdf_hw_clamped_pair_variant_0(
    TextureSDFData_93572308 var_sdf,
    wp::vec_t<3, wp::float32> var_clamped0,
    wp::vec_t<3, wp::float32> var_clamped1,
    wp::float32 var_diff_sq0,
    wp::float32 var_diff_sq1,
    bool var_paired_samples,
    TextureSDFData_93572308 & adj_sdf,
    wp::vec_t<3, wp::float32> & adj_clamped0,
    wp::vec_t<3, wp::float32> & adj_clamped1,
    wp::float32 & adj_diff_sq0,
    wp::float32 & adj_diff_sq1,
    bool & adj_paired_samples,
    wp::vec_t<2, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:1355
static CUDA_CALLABLE void adj__texture_sample_sdf_hw_pair_variant_0(
    TextureSDFData_93572308 var_sdf,
    wp::vec_t<3, wp::float32> var_local_pos0,
    wp::vec_t<3, wp::float32> var_local_pos1,
    bool var_paired_samples,
    TextureSDFData_93572308 & adj_sdf,
    wp::vec_t<3, wp::float32> & adj_local_pos0,
    wp::vec_t<3, wp::float32> & adj_local_pos1,
    bool & adj_paired_samples,
    wp::vec_t<2, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:1384
static CUDA_CALLABLE void adj__texture_sample_sdf_hw_pair_0(
    TextureSDFData_93572308 var_sdf,
    wp::vec_t<3, wp::float32> var_local_pos0,
    wp::vec_t<3, wp::float32> var_local_pos1,
    TextureSDFData_93572308 & adj_sdf,
    wp::vec_t<3, wp::float32> & adj_local_pos0,
    wp::vec_t<3, wp::float32> & adj_local_pos1,
    wp::vec_t<2, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:1494
static CUDA_CALLABLE void adj__texture_sample_sdf_hw_variant_0(
    TextureSDFData_93572308 var_sdf,
    wp::vec_t<3, wp::float32> var_local_pos,
    bool var_paired_samples,
    TextureSDFData_93572308 & adj_sdf,
    wp::vec_t<3, wp::float32> & adj_local_pos,
    bool & adj_paired_samples,
    wp::float32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:1532
static CUDA_CALLABLE void adj_texture_sample_sdf_hw_0(
    TextureSDFData_93572308 var_sdf,
    wp::vec_t<3, wp::float32> var_local_pos,
    TextureSDFData_93572308 & adj_sdf,
    wp::vec_t<3, wp::float32> & adj_local_pos,
    wp::float32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:671
static CUDA_CALLABLE void adj__create_sdf_contact_funcs__locals___sample_sdf_at_t_1(
    TextureSDFData_93572308 var_texture_sdf,
    wp::uint64 var_sdf_mesh_id,
    wp::vec_t<3, wp::float32> var_v0,
    wp::vec_t<3, wp::float32> var_edge_dir,
    wp::float32 var_tt,
    bool var_use_bvh_for_sdf,
    wp::int32 var_sdf_mesh_query_type,
    bool var_sdf_is_heightfield,
    HeightfieldData_f2b8d59a var_hfd_sdf,
    wp::array_t<wp::float32> var_elevation_data,
    TextureSDFData_93572308 & adj_texture_sdf,
    wp::uint64 & adj_sdf_mesh_id,
    wp::vec_t<3, wp::float32> & adj_v0,
    wp::vec_t<3, wp::float32> & adj_edge_dir,
    wp::float32 & adj_tt,
    bool & adj_use_bvh_for_sdf,
    wp::int32 & adj_sdf_mesh_query_type,
    bool & adj_sdf_is_heightfield,
    HeightfieldData_f2b8d59a & adj_hfd_sdf,
    wp::array_t<wp::float32> & adj_elevation_data,
    wp::float32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:703
static CUDA_CALLABLE void adj__create_sdf_contact_funcs__locals__do_edge_sdf_collision_func_1(
    TextureSDFData_93572308 var_texture_sdf,
    wp::uint64 var_sdf_mesh_id,
    wp::vec_t<3, wp::float32> var_v0,
    wp::vec_t<3, wp::float32> var_v1,
    wp::float32 var_midpoint_sdf,
    bool var_use_bvh_for_sdf,
    wp::int32 var_sdf_mesh_query_type,
    bool var_sdf_is_heightfield,
    HeightfieldData_f2b8d59a var_hfd_sdf,
    wp::array_t<wp::float32> var_elevation_data,
    wp::float32 var_precision_target,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::int32 & ret_2,
    TextureSDFData_93572308 & adj_texture_sdf,
    wp::uint64 & adj_sdf_mesh_id,
    wp::vec_t<3, wp::float32> & adj_v0,
    wp::vec_t<3, wp::float32> & adj_v1,
    wp::float32 & adj_midpoint_sdf,
    bool & adj_use_bvh_for_sdf,
    wp::int32 & adj_sdf_mesh_query_type,
    bool & adj_sdf_is_heightfield,
    HeightfieldData_f2b8d59a & adj_hfd_sdf,
    wp::array_t<wp::float32> & adj_elevation_data,
    wp::float32 & adj_precision_target,
    wp::float32 & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1,
    wp::int32 & adj_ret_2)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:94
static CUDA_CALLABLE void adj_mesh_sdf_contact_passes_inner_cull_consistency_0(
    wp::float32 var_distance_world,
    wp::float32 var_inner_contact_threshold,
    wp::float32 var_midpoint_sdf,
    wp::vec_t<3, wp::float32> var_bsphere_center,
    wp::float32 var_bsphere_radius,
    wp::vec_t<3, wp::float32> var_sdf_aabb_lower,
    wp::vec_t<3, wp::float32> var_sdf_aabb_upper,
    wp::float32 var_min_sdf_scale,
    bool var_use_texture_bounds,
    wp::float32 & adj_distance_world,
    wp::float32 & adj_inner_contact_threshold,
    wp::float32 & adj_midpoint_sdf,
    wp::vec_t<3, wp::float32> & adj_bsphere_center,
    wp::float32 & adj_bsphere_radius,
    wp::vec_t<3, wp::float32> & adj_sdf_aabb_lower,
    wp::vec_t<3, wp::float32> & adj_sdf_aabb_upper,
    wp::float32 & adj_min_sdf_scale,
    bool & adj_use_texture_bounds,
    bool & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:217
static CUDA_CALLABLE void adj_sample_sdf_grad_using_mesh_0(
    wp::uint64 var_mesh_id,
    wp::vec_t<3, wp::float32> var_world_pos,
    wp::float32 var_max_dist,
    wp::int32 var_sign_method,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::uint64 & adj_mesh_id,
    wp::vec_t<3, wp::float32> & adj_world_pos,
    wp::float32 & adj_max_dist,
    wp::int32 & adj_sign_method,
    wp::float32 & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:1618
static CUDA_CALLABLE void adj__texture_sample_sdf_grad_hw_impl_variant_0(
    TextureSDFData_93572308 var_sdf,
    wp::vec_t<3, wp::float32> var_local_pos,
    bool var_paired_samples,
    TextureSDFData_93572308 & adj_sdf,
    wp::vec_t<3, wp::float32> & adj_local_pos,
    bool & adj_paired_samples,
    wp::vec_t<3, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:1699
static CUDA_CALLABLE void adj__texture_sample_sdf_grad_hw_impl_0(
    TextureSDFData_93572308 var_sdf,
    wp::vec_t<3, wp::float32> var_local_pos,
    TextureSDFData_93572308 & adj_sdf,
    wp::vec_t<3, wp::float32> & adj_local_pos,
    wp::vec_t<3, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:1735
static CUDA_CALLABLE void adj_texture_sample_sdf_grad_only_hw_0(
    TextureSDFData_93572308 var_sdf,
    wp::vec_t<3, wp::float32> var_local_pos,
    TextureSDFData_93572308 & adj_sdf,
    wp::vec_t<3, wp::float32> & adj_local_pos,
    wp::vec_t<3, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_contact.py:154
static CUDA_CALLABLE void adj_scale_sdf_result_to_world_0(
    wp::float32 var_distance,
    wp::vec_t<3, wp::float32> var_gradient,
    wp::vec_t<3, wp::float32> var_sdf_scale,
    wp::vec_t<3, wp::float32> var_inv_sdf_scale,
    wp::float32 var_min_sdf_scale,
    wp::float32 & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::float32 & adj_distance,
    wp::vec_t<3, wp::float32> & adj_gradient,
    wp::vec_t<3, wp::float32> & adj_sdf_scale,
    wp::vec_t<3, wp::float32> & adj_inv_sdf_scale,
    wp::float32 & adj_min_sdf_scale,
    wp::float32 & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction.py:104
static CUDA_CALLABLE void adj_float_flip_0(
    wp::float32 f,
    wp::float32 & adj_f,
    wp::uint32 & adj_ret)
{
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:509
static CUDA_CALLABLE void adj__make_preprune_probe_det_0(
    wp::float32 var_score,
    wp::int32 var_fingerprint,
    wp::float32 & adj_score,
    wp::int32 & adj_fingerprint,
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction.py:405
static CUDA_CALLABLE void adj_get_spatial_direction_2d_0(
    wp::int32 var_dir_idx,
    wp::int32 & adj_dir_idx,
    wp::vec_t<2, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:544
static CUDA_CALLABLE void adj__make_spatial_preprune_probe_det_0(
    wp::float32 var_score,
    bool var_is_inner,
    wp::int32 var_fingerprint,
    wp::float32 & adj_score,
    bool & adj_is_inner,
    wp::int32 & adj_fingerprint,
    wp::uint64 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:425
static CUDA_CALLABLE void adj__make_spatial_preprune_probe_fast_0(
    wp::float32 var_score,
    bool var_is_inner,
    wp::int32 var_fingerprint,
    wp::float32 & adj_score,
    bool & adj_is_inner,
    wp::int32 & adj_fingerprint,
    wp::uint64 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:606
static CUDA_CALLABLE void adj_make_spatial_preprune_probe_0(
    wp::float32 var_score,
    bool var_is_inner,
    wp::int32 var_fingerprint,
    wp::int32 var_deterministic,
    wp::float32 & adj_score,
    bool & adj_is_inner,
    wp::int32 & adj_fingerprint,
    wp::int32 & adj_deterministic,
    wp::uint64 & adj_ret)
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:529
static CUDA_CALLABLE void adj__make_spatial_contact_value_det_0(
    wp::float32 var_score,
    bool var_is_inner,
    wp::int32 var_fingerprint,
    wp::int32 var_contact_id,
    wp::float32 & adj_score,
    bool & adj_is_inner,
    wp::int32 & adj_fingerprint,
    wp::int32 & adj_contact_id,
    wp::uint64 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:415
static CUDA_CALLABLE void adj__make_spatial_contact_value_fast_0(
    wp::float32 var_score,
    bool var_is_inner,
    wp::int32 var_fingerprint,
    wp::int32 var_contact_id,
    wp::float32 & adj_score,
    bool & adj_is_inner,
    wp::int32 & adj_fingerprint,
    wp::int32 & adj_contact_id,
    wp::uint64 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:592
static CUDA_CALLABLE void adj_make_spatial_contact_value_0(
    wp::float32 var_score,
    bool var_is_inner,
    wp::int32 var_fingerprint,
    wp::int32 var_contact_id,
    wp::int32 var_deterministic,
    wp::float32 & adj_score,
    bool & adj_is_inner,
    wp::int32 & adj_fingerprint,
    wp::int32 & adj_contact_id,
    wp::int32 & adj_deterministic,
    wp::uint64 & adj_ret)
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/contact_reduction_global.py:1509
static CUDA_CALLABLE void adj_export_and_reduce_contact_centered_two_spatial_depths_0(
    wp::int32 var_shape_a,
    wp::int32 var_shape_b,
    wp::vec_t<3, wp::float32> var_position,
    wp::vec_t<3, wp::float32> var_normal,
    wp::float32 var_depth,
    wp::int32 var_fingerprint,
    wp::vec_t<3, wp::float32> var_centered_position,
    wp::float32 var_inner_spatial_depth,
    wp::float32 var_outer_spatial_depth,
    wp::vec_t<3, wp::float32> var_position_local,
    wp::vec_t<3, wp::float32> var_aabb_lower_voxel,
    wp::vec_t<3, wp::float32> var_aabb_upper_voxel,
    wp::vec_t<3, wp::int32> var_voxel_res,
    GlobalContactReducerData_0c09c456 var_reducer_data,
    wp::int32 & adj_shape_a,
    wp::int32 & adj_shape_b,
    wp::vec_t<3, wp::float32> & adj_position,
    wp::vec_t<3, wp::float32> & adj_normal,
    wp::float32 & adj_depth,
    wp::int32 & adj_fingerprint,
    wp::vec_t<3, wp::float32> & adj_centered_position,
    wp::float32 & adj_inner_spatial_depth,
    wp::float32 & adj_outer_spatial_depth,
    wp::vec_t<3, wp::float32> & adj_position_local,
    wp::vec_t<3, wp::float32> & adj_aabb_lower_voxel,
    wp::vec_t<3, wp::float32> & adj_aabb_upper_voxel,
    wp::vec_t<3, wp::int32> & adj_voxel_res,
    GlobalContactReducerData_0c09c456 & adj_reducer_data,
    wp::int32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}



extern "C" __launch_bounds__(256, 2) __global__ void create_narrow_phase_process_mesh_mesh_contacts_kernel__locals__mesh_sdf_collision_global_reduce_kernel_b69ac63c_cuda_kernel_forward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::vec_t<4, wp::float32>> var_shape_data,
    wp::array_t<wp::transform_t<wp::float32>> var_shape_transform,
    wp::array_t<wp::uint64> var_shape_source,
    wp::array_t<TextureSDFData_93572308> var_texture_sdf_table,
    wp::array_t<wp::int32> var_shape_sdf_index,
    wp::array_t<wp::int32> var_shape_mesh_properties,
    wp::array_t<wp::float32> var_shape_gap,
    wp::array_t<wp::float32> var_shape_base_gap,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_linear_velocity,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_angular_velocity,
    wp::float32 var_collision_update_dt,
    wp::float32 var_max_speculative_extension,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_collision_aabb_lower,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_collision_aabb_upper,
    wp::array_t<wp::vec_t<3, wp::int32>> var_shape_voxel_resolution,
    wp::array_t<wp::vec_t<2, wp::int32>> var_shape_pairs_mesh_mesh,
    wp::array_t<wp::int32> var_shape_pairs_mesh_mesh_count,
    wp::array_t<wp::int32> var_shape_heightfield_index,
    wp::array_t<HeightfieldData_f2b8d59a> var_heightfield_data,
    wp::array_t<wp::float32> var_heightfield_elevations,
    wp::array_t<wp::vec_t<2, wp::int32>> var_mesh_edge_indices,
    wp::array_t<wp::vec_t<4, wp::float32>> var_mesh_edge_centers,
    wp::array_t<wp::vec_t<4, wp::float32>> var_mesh_edge_halves,
    wp::array_t<wp::vec_t<2, wp::int32>> var_shape_edge_range,
    wp::array_t<wp::int32> var_block_offsets,
    GlobalContactReducerData_0c09c456 var_reducer_data,
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
        const wp::int32 var_13 = 512;
        wp::tile_stack_t<EdgeCullResult_d4aae4ab, 512> var_14 = wp::tile_stack_alloc<EdgeCullResult_d4aae4ab, 512>();
        const wp::int32 var_15 = 1;
        const wp::str var_16 = "shared";
        wp::tile_shared_t<wp::int32,wp::tile_layout_strided_t<wp::tile_shape_t<1>, wp::tile_stride_t<1>>, true> var_17 = wp::tile_alloc_empty<wp::int32,wp::tile_shape_t<1>,wp::tile_stride_t<1>,false>();
        wp::range_t var_18;
        wp::int32 var_19;
        const wp::int32 var_20 = 0;
        wp::int32 var_21;
        wp::int32 var_22;
        bool var_23;
        wp::int32 var_24;
        const wp::int32 var_25 = 2;
        wp::int32 var_26;
        const wp::int32 var_27 = 1;
        wp::int32 var_28;
        wp::int32* var_29;
        bool var_30;
        wp::int32 var_31;
        const wp::int32 var_32 = 1;
        wp::int32 var_33;
        wp::int32 var_34;
        wp::int32 var_35;
        wp::int32 var_36;
        wp::int32 var_37;
        wp::int32* var_38;
        wp::int32 var_39;
        wp::int32 var_40;
        wp::int32 var_41;
        const wp::int32 var_42 = 1;
        wp::int32 var_43;
        wp::int32* var_44;
        wp::int32 var_45;
        wp::int32 var_46;
        wp::vec_t<2, wp::int32>* var_47;
        wp::vec_t<2, wp::int32> var_48;
        wp::vec_t<2, wp::int32> var_49;
        const bool var_50 = false;
        const bool var_51 = false;
        wp::vec_t<2, wp::int32> var_52;
        const wp::int32 var_53 = 0;
        wp::int32 var_54;
        wp::float32* var_55;
        const wp::int32 var_56 = 1;
        wp::int32 var_57;
        wp::float32* var_58;
        wp::float32 var_59;
        wp::float32 var_60;
        wp::float32 var_61;
        const wp::int32 var_62 = 0;
        wp::int32 var_63;
        wp::float32* var_64;
        const wp::int32 var_65 = 1;
        wp::int32 var_66;
        wp::float32* var_67;
        wp::float32 var_68;
        wp::float32 var_69;
        wp::float32 var_70;
        const wp::int32 var_71 = 2;
        wp::range_t var_72;
        wp::int32 var_73;
        wp::int32 var_74;
        const wp::int32 var_75 = 1;
        wp::int32 var_76;
        wp::int32 var_77;
        const bool var_78 = false;
        const bool var_79 = false;
        const bool var_80 = false;
        const wp::int32 var_81 = 8;
        wp::uint64* var_82;
        wp::uint64 var_83;
        wp::uint64 var_84;
        wp::uint64* var_85;
        wp::uint64 var_86;
        wp::uint64 var_87;
        bool var_88;
        bool var_89;
        wp::uint64 var_90;
        bool var_91;
        HeightfieldData_f2b8d59a var_92;
        HeightfieldData_f2b8d59a var_93;
        const bool var_94 = false;
        wp::int32* var_95;
        wp::int32 var_96;
        wp::int32 var_97;
        const bool var_98 = false;
        bool var_99;
        wp::int32* var_100;
        wp::int32 var_101;
        wp::int32 var_102;
        const bool var_103 = true;
        bool var_104;
        const wp::int32 var_105 = 0;
        bool var_106;
        wp::shape_t* var_107;
        const wp::int32 var_108 = 0;
        wp::int32 var_109;
        wp::shape_t var_110;
        bool var_111;
        bool var_112;
        TextureSDFData_93572308* var_113;
        wp::texture3d_t* var_114;
        wp::int32* var_115;
        const wp::int32 var_116 = 0;
        bool var_117;
        wp::int32 var_118;
        bool var_119;
        bool var_120;
        wp::uint64 var_121;
        bool var_122;
        bool var_123;
        wp::vec_t<4, wp::float32>* var_124;
        wp::vec_t<4, wp::float32> var_125;
        wp::vec_t<4, wp::float32> var_126;
        wp::vec_t<4, wp::float32>* var_127;
        wp::vec_t<4, wp::float32> var_128;
        wp::vec_t<4, wp::float32> var_129;
        const wp::int32 var_130 = 0;
        wp::float32 var_131;
        const wp::int32 var_132 = 1;
        wp::float32 var_133;
        const wp::int32 var_134 = 2;
        wp::float32 var_135;
        wp::vec_t<3, wp::float32> var_136;
        const wp::int32 var_137 = 0;
        wp::float32 var_138;
        const wp::int32 var_139 = 1;
        wp::float32 var_140;
        const wp::int32 var_141 = 2;
        wp::float32 var_142;
        wp::vec_t<3, wp::float32> var_143;
        wp::transform_t<wp::float32>* var_144;
        wp::transform_t<wp::float32> var_145;
        wp::transform_t<wp::float32> var_146;
        wp::transform_t<wp::float32>* var_147;
        wp::transform_t<wp::float32> var_148;
        wp::transform_t<wp::float32> var_149;
        TextureSDFData_93572308 var_150;
        bool var_151;
        TextureSDFData_93572308* var_152;
        TextureSDFData_93572308 var_153;
        TextureSDFData_93572308 var_154;
        TextureSDFData_93572308 var_155;
        const bool var_156 = false;
        wp::vec_t<3, wp::float32> var_157;
        bool var_158;
        bool var_159;
        bool* var_160;
        bool var_161;
        const wp::float32 var_162 = 1.0;
        const wp::float32 var_163 = 1.0;
        const wp::float32 var_164 = 1.0;
        wp::vec_t<3, wp::float32> var_165;
        wp::vec_t<3, wp::float32> var_166;
        wp::transform_t<wp::float32> var_167;
        wp::transform_t<wp::float32> var_168;
        const wp::int32 var_169 = 3;
        wp::float32 var_170;
        const wp::int32 var_171 = 3;
        wp::float32 var_172;
        const bool var_173 = false;
        wp::vec_t<3, wp::float32> var_174;
        wp::float32 var_175;
        const wp::int32 var_176 = 0;
        wp::float32 var_177;
        wp::float32 var_178;
        const wp::int32 var_179 = 1;
        wp::float32 var_180;
        wp::float32 var_181;
        wp::float32 var_182;
        const wp::int32 var_183 = 2;
        wp::float32 var_184;
        wp::float32 var_185;
        wp::float32 var_186;
        wp::float32 var_187;
        wp::float32 var_188;
        wp::float32 var_189;
        const bool var_190 = false;
        const wp::float32 var_191 = 0.0;
        wp::float32 var_192;
        const bool var_193 = false;
        bool var_194;
        const bool var_195 = true;
        wp::float32* var_196;
        wp::float32 var_197;
        wp::float32 var_198;
        bool var_199;
        wp::float32 var_200;
        wp::float32 var_201;
        wp::float32 var_202;
        wp::vec_t<2, wp::int32>* var_203;
        wp::vec_t<2, wp::int32> var_204;
        wp::vec_t<2, wp::int32> var_205;
        wp::int32 var_206;
        wp::int32 var_207;
        const wp::int32 var_208 = 1;
        wp::int32 var_209;
        wp::int32 var_210;
        wp::int32 var_211;
        wp::int32 var_212;
        wp::int32 var_213;
        const wp::int32 var_214 = 0;
        const wp::int32 var_215 = 0;
        bool var_216;
        bool var_217;
        wp::vec_t<3, wp::float32>* var_218;
        wp::vec_t<3, wp::float32> var_219;
        wp::vec_t<3, wp::float32> var_220;
        wp::vec_t<3, wp::float32>* var_221;
        wp::vec_t<3, wp::float32> var_222;
        wp::vec_t<3, wp::float32> var_223;
        const wp::int32 var_224 = 0;
        wp::int32 var_225;
        bool var_226;
        wp::int32 var_227;
        bool var_228;
        const wp::int32 var_229 = 0;
        wp::int32 var_230;
        bool var_231;
        wp::int32 var_232;
        bool var_233;
        const wp::int32 var_234 = 0;
        wp::int32 var_235;
        wp::int32 var_236;
        const bool var_237 = false;
        const wp::float32 var_238 = 0.0;
        wp::float32 var_239;
        bool var_240;
        const bool var_241 = false;
        wp::vec_t<3, wp::float32> var_242;
        wp::float32 var_243;
        wp::float32 var_244;
        bool var_245;
        const bool var_246 = false;
        wp::float32 var_247;
        bool var_248;
        bool var_249;
        const bool var_250 = true;
        const wp::float32 var_251 = 1.01;
        wp::float32 var_252;
        wp::float32 var_253;
        bool var_254;
        wp::float32 var_255;
        wp::vec_t<3, wp::float32> var_256;
        wp::vec_t<3, wp::float32> var_257;
        wp::vec_t<3, wp::float32> var_258;
        wp::float32 var_259;
        wp::float32 var_260;
        bool var_261;
        const bool var_262 = false;
        const wp::float32 var_263 = 0.0;
        wp::float32 var_264;
        const wp::float32 var_265 = 0.0;
        bool var_266;
        wp::float32 var_267;
        wp::float32 var_268;
        wp::float32 var_269;
        bool var_270;
        bool var_271;
        wp::float32 var_272;
        bool var_273;
        wp::float32 var_274;
        bool var_275;
        wp::float32 var_276;
        bool var_277;
        wp::float32 var_278;
        EdgeCullResult_d4aae4ab var_279;
        wp::int32 var_280;
        const wp::int32 var_281 = 0;
        wp::int32 var_282;
        const wp::int32 var_283 = 0;
        bool var_284;
        wp::int32 var_285;
        const wp::int32 var_286 = 0;
        bool var_287;
        EdgeCullResult_d4aae4ab var_288;
        wp::int32 var_289;
        wp::int32* var_290;
        wp::int32 var_291;
        wp::int32 var_292;
        wp::float32* var_293;
        wp::float32 var_294;
        wp::float32 var_295;
        const wp::int32 var_296 = 0;
        bool var_297;
        const wp::int32 var_298 = 0;
        wp::int32 var_299;
        const bool var_300 = false;
        wp::vec_t<3, wp::float32> var_301;
        wp::vec_t<3, wp::float32> var_302;
        wp::int32 var_303;
        wp::vec_t<3, wp::float32> var_304;
        wp::vec_t<3, wp::float32> var_305;
        wp::float32 var_306;
        wp::vec_t<3, wp::float32> var_307;
        wp::int32 var_308;
        wp::float32 var_309;
        wp::vec_t<3, wp::float32> var_310;
        wp::float32 var_311;
        wp::float32 var_312;
        bool var_313;
        bool var_314;
        const wp::int32 var_315 = 0;
        bool var_316;
        const wp::int32 var_317 = 0;
        bool var_318;
        wp::int32 var_319;
        const wp::int32 var_320 = 0;
        bool var_321;
        bool var_322;
        bool var_323;
        const bool var_324 = false;
        bool var_325;
        const bool var_326 = true;
        const wp::float32 var_327 = 100000000000.0;
        wp::float32 var_328;
        wp::vec_t<3, wp::float32> var_329;
        wp::vec_t<3, wp::float32> var_330;
        wp::float32 var_331;
        wp::vec_t<3, wp::float32> var_332;
        const bool var_333 = false;
        wp::float32 var_334;
        wp::vec_t<3, wp::float32> var_335;
        wp::vec_t<3, wp::float32> var_336;
        wp::vec_t<3, wp::float32> var_337;
        wp::vec_t<3, wp::float32> var_338;
        wp::float32 var_339;
        const wp::float32 var_340 = 0.0;
        bool var_341;
        wp::float32 var_342;
        wp::vec_t<3, wp::float32> var_343;
        wp::vec_t<3, wp::float32> var_344;
        wp::vec_t<3, wp::float32> var_345;
        wp::float32 var_346;
        const wp::float32 var_347 = 0.0;
        bool var_348;
        wp::float32 var_349;
        wp::vec_t<3, wp::float32> var_350;
        const wp::float32 var_351 = 0.0;
        const wp::float32 var_352 = 1.0;
        const wp::float32 var_353 = 0.0;
        wp::vec_t<3, wp::float32> var_354;
        wp::vec_t<3, wp::float32> var_355;
        wp::vec_t<3, wp::float32> var_356;
        const wp::int32 var_357 = 0;
        bool var_358;
        wp::vec_t<3, wp::float32> var_359;
        wp::vec_t<3, wp::float32> var_360;
        wp::quat_t<wp::float32> var_361;
        wp::vec_t<3, wp::float32> var_362;
        wp::vec_t<3, wp::float32> var_363;
        wp::vec_t<3, wp::float32> var_364;
        wp::vec_t<3, wp::float32>* var_365;
        wp::vec_t<3, wp::float32> var_366;
        wp::vec_t<3, wp::float32> var_367;
        wp::vec_t<3, wp::float32>* var_368;
        wp::vec_t<3, wp::float32> var_369;
        wp::vec_t<3, wp::float32> var_370;
        wp::vec_t<3, wp::int32>* var_371;
        wp::vec_t<3, wp::int32> var_372;
        wp::vec_t<3, wp::int32> var_373;
        wp::float32 var_374;
        wp::vec_t<3, wp::float32> var_375;
        wp::vec_t<3, wp::float32> var_376;
        wp::vec_t<3, wp::float32> var_377;
        const wp::float32 var_378 = 0.5;
        wp::vec_t<3, wp::float32> var_379;
        wp::float32 var_380;
        wp::float32 var_381;
        wp::float32 var_382;
        wp::float32 var_383;
        wp::float32 var_384;
        wp::float32 var_385;
        const bool var_386 = false;
        const wp::int32 var_387 = 0;
        wp::int32 var_388;
        const wp::int32 var_389 = 1;
        wp::int32 var_390;
        const wp::int32 var_391 = 2;
        wp::int32 var_392;
        const wp::int32 var_393 = 1;
        wp::int32 var_394;
        wp::int32 var_395;
        wp::vec_t<3, wp::float32> var_396;
        wp::int32 var_397;
        const bool var_398 = false;
        wp::float32 var_399;
        //---------
        // forward
        // def mesh_sdf_collision_global_reduce_kernel(                                           <L 1537>
        // block_id, t = wp.tid()                                                                 <L 1576>
        builtin_tid2d(var_0, var_1);
        // pair_count = wp.min(shape_pairs_mesh_mesh_count[0], shape_pairs_mesh_mesh.shape[0])       <L 1577>
        var_3 = wp::address(var_shape_pairs_mesh_mesh_count, var_2);
        var_4 = &(var_shape_pairs_mesh_mesh.shape);
        var_7 = wp::load(var_4);
        var_6 = wp::extract(var_7, var_5);
        var_9 = wp::load(var_3);
        var_8 = wp::min(var_9, var_6);
        // total_combos = block_offsets[pair_count]                                               <L 1578>
        var_10 = wp::address(var_block_offsets, var_8);
        var_12 = wp::load(var_10);
        var_11 = wp::copy(var_12);
        // edge_stack = wp.tile_stack(capacity=STACK_CAPACITY, dtype=EdgeCullResult)              <L 1580>
        var_14 = wp::tile_stack_init<EdgeCullResult_d4aae4ab, 512>();
        // progress = wp.tile_zeros(shape=1, dtype=int, storage="shared")                         <L 1585>
        var_17 = wp::tile_zeros<int, 1>();
        // for combo_idx in range(block_id, total_combos, total_num_blocks):                      <L 1587>
        var_18 = wp::range(var_0, var_11, var_total_num_blocks);
        start_for_0:;
            if (iter_cmp(var_18) == 0) goto end_for_0;
            var_19 = wp::iter_next(var_18);
            // lo = int(0)                                                                        <L 1588>
            var_21 = wp::int(var_20);
            // hi = int(pair_count)                                                               <L 1589>
            var_22 = wp::int(var_8);
            // while lo < hi:                                                                     <L 1590>
        start_while_2:;
            var_23 = (var_21 < var_22);
        if ((var_23) == false) goto end_while_2;
                // mid = (lo + hi) // 2                                                           <L 1591>
                var_24 = wp::add(var_21, var_22);
                var_26 = wp::floordiv(var_24, var_25);
                // if block_offsets[mid + 1] <= combo_idx:                                        <L 1592>
                var_28 = wp::add(var_26, var_27);
                var_29 = wp::address(var_block_offsets, var_28);
                var_31 = wp::load(var_29);
                var_30 = (var_31 <= var_19);
                if (var_30) {
                    // lo = mid + 1                                                               <L 1593>
                    var_33 = wp::add(var_26, var_32);
                }
                if (!var_30) {
                    // hi = mid                                                                   <L 1595>
                    var_34 = wp::copy(var_26);
                }
                var_35 = wp::where(var_30, var_33, var_21);
                var_36 = wp::where(var_30, var_22, var_34);
                wp::assign(var_21, var_35);
                wp::assign(var_22, var_36);
        goto start_while_2;
        end_while_2:;
            // pair_idx = int(lo)                                                                 <L 1596>
            var_37 = wp::int(var_21);
            // pair_block_start = block_offsets[pair_idx]                                         <L 1597>
            var_38 = wp::address(var_block_offsets, var_37);
            var_40 = wp::load(var_38);
            var_39 = wp::copy(var_40);
            // block_in_pair = combo_idx - pair_block_start                                       <L 1598>
            var_41 = wp::sub(var_19, var_39);
            // blocks_for_pair = block_offsets[pair_idx + 1] - pair_block_start                   <L 1599>
            var_43 = wp::add(var_37, var_42);
            var_44 = wp::address(var_block_offsets, var_43);
            var_46 = wp::load(var_44);
            var_45 = wp::sub(var_46, var_39);
            // pair_encoded = shape_pairs_mesh_mesh[pair_idx]                                     <L 1600>
            var_47 = wp::address(var_shape_pairs_mesh_mesh, var_37);
            var_49 = wp::load(var_47);
            var_48 = wp::copy(var_49);
            // if wp.static(enable_heightfields):                                                 <L 1601>
            // has_hfield = False                                                                 <L 1605>
            // pair = pair_encoded                                                                <L 1606>
            var_52 = wp::copy(var_48);
            // gap_sum = shape_gap[pair[0]] + shape_gap[pair[1]]                                  <L 1608>
            var_54 = wp::extract(var_52, var_53);
            var_55 = wp::address(var_shape_gap, var_54);
            var_57 = wp::extract(var_52, var_56);
            var_58 = wp::address(var_shape_gap, var_57);
            var_60 = wp::load(var_55);
            var_61 = wp::load(var_58);
            var_59 = wp::add(var_60, var_61);
            // base_gap_sum = shape_base_gap[pair[0]] + shape_base_gap[pair[1]]                   <L 1609>
            var_63 = wp::extract(var_52, var_62);
            var_64 = wp::address(var_shape_base_gap, var_63);
            var_66 = wp::extract(var_52, var_65);
            var_67 = wp::address(var_shape_base_gap, var_66);
            var_69 = wp::load(var_64);
            var_70 = wp::load(var_67);
            var_68 = wp::add(var_69, var_70);
            // for mode in range(2):                                                              <L 1611>
            var_72 = wp::range(var_71);
            start_for_4:;
                if (iter_cmp(var_72) == 0) goto end_for_4;
                var_73 = wp::iter_next(var_72);
                // tri_shape = pair[mode]                                                         <L 1612>
                var_74 = wp::extract(var_52, var_73);
                // sdf_shape = pair[1 - mode]                                                     <L 1613>
                var_76 = wp::sub(var_75, var_73);
                var_77 = wp::extract(var_52, var_76);
                // if wp.static(enable_heightfields):                                             <L 1615>
                // tri_is_hfield = False                                                          <L 1619>
                // sdf_is_hfield = False                                                          <L 1620>
                // tri_type = GeoType.HFIELD if tri_is_hfield else GeoType.MESH                   <L 1621>
                // mesh_id_tri = shape_source[tri_shape]                                          <L 1623>
                var_82 = wp::address(var_shape_source, var_74);
                var_84 = wp::load(var_82);
                var_83 = wp::copy(var_84);
                // mesh_id_sdf = shape_source[sdf_shape]                                          <L 1624>
                var_85 = wp::address(var_shape_source, var_77);
                var_87 = wp::load(var_85);
                var_86 = wp::copy(var_87);
                // if not tri_is_hfield and mesh_id_tri == wp.uint64(0):                          <L 1626>
                var_89 = wp::unot(var_79);
                var_88 = var_89;
                if (var_88) {
                    var_90 = 0ull;
                    var_91 = (var_83 == var_90);
                    var_88 = var_88 && var_91;
                }
                if (var_88) {
                    // continue                                                                   <L 1627>
                    goto start_for_4;
                }
                // hfd_tri = HeightfieldData()                                                    <L 1629>
                var_92 = HeightfieldData_f2b8d59a();
                // hfd_sdf = HeightfieldData()                                                    <L 1630>
                var_93 = HeightfieldData_f2b8d59a();
                // if wp.static(enable_heightfields):                                             <L 1631>
                // sdf_mesh_query_type = resolve_mesh_sign_method(shape_mesh_properties[sdf_shape])       <L 1636>
                var_95 = wp::address(var_shape_mesh_properties, var_77);
                var_97 = wp::load(var_95);
                var_96 = resolve_mesh_sign_method_0(var_97);
                // use_bvh_for_sdf = False                                                        <L 1638>
                // if not sdf_is_hfield:                                                          <L 1639>
                var_99 = wp::unot(var_80);
                if (var_99) {
                    // sdf_idx = shape_sdf_index[sdf_shape]                                       <L 1640>
                    var_100 = wp::address(var_shape_sdf_index, var_77);
                    var_102 = wp::load(var_100);
                    var_101 = wp::copy(var_102);
                    // if wp.static(not use_texture_sdf_only):                                    <L 1641>
                    // use_bvh_for_sdf = sdf_idx < 0 or sdf_idx >= texture_sdf_table.shape[0]       <L 1642>
                    var_106 = (var_101 < var_105);
                    var_104 = var_106;
                    if (!var_104) {
                        var_107 = &(var_texture_sdf_table.shape);
                        var_110 = wp::load(var_107);
                        var_109 = wp::extract(var_110, var_108);
                        var_111 = (var_101 >= var_109);
                        var_104 = var_104 || var_111;
                    }
                    // if not use_bvh_for_sdf:                                                    <L 1643>
                    var_112 = wp::unot(var_104);
                    if (var_112) {
                        // use_bvh_for_sdf = texture_sdf_table[sdf_idx].coarse_texture.width == 0       <L 1644>
                        var_113 = wp::address(var_texture_sdf_table, var_101);
                        var_114 = &(((*wp::address(var_texture_sdf_table, var_101))).coarse_texture);
                        var_115 = &((((*wp::address(var_texture_sdf_table, var_101))).coarse_texture).width);
                        var_118 = wp::load(var_115);
                        var_117 = (var_118 == var_116);
                    }
                    var_119 = wp::where(var_112, var_117, var_104);
                    // if use_bvh_for_sdf and mesh_id_sdf == wp.uint64(0):                        <L 1645>
                    var_120 = var_119;
                    if (var_120) {
                        var_121 = 0ull;
                        var_122 = (var_86 == var_121);
                        var_120 = var_120 && var_122;
                    }
                    if (var_120) {
                        // continue                                                               <L 1646>
                        goto start_for_4;
                    }
                }
                var_123 = wp::where(var_99, var_119, var_98);
                // scale_data_tri = shape_data[tri_shape]                                         <L 1648>
                var_124 = wp::address(var_shape_data, var_74);
                var_126 = wp::load(var_124);
                var_125 = wp::copy(var_126);
                // scale_data_sdf = shape_data[sdf_shape]                                         <L 1649>
                var_127 = wp::address(var_shape_data, var_77);
                var_129 = wp::load(var_127);
                var_128 = wp::copy(var_129);
                // mesh_scale_tri = wp.vec3(scale_data_tri[0], scale_data_tri[1], scale_data_tri[2])       <L 1650>
                var_131 = wp::extract(var_125, var_130);
                var_133 = wp::extract(var_125, var_132);
                var_135 = wp::extract(var_125, var_134);
                var_136 = wp::vec_t<3, wp::float32>(var_131, var_133, var_135);
                // mesh_scale_sdf = wp.vec3(scale_data_sdf[0], scale_data_sdf[1], scale_data_sdf[2])       <L 1651>
                var_138 = wp::extract(var_128, var_137);
                var_140 = wp::extract(var_128, var_139);
                var_142 = wp::extract(var_128, var_141);
                var_143 = wp::vec_t<3, wp::float32>(var_138, var_140, var_142);
                // X_tri_ws = shape_transform[tri_shape]                                          <L 1653>
                var_144 = wp::address(var_shape_transform, var_74);
                var_146 = wp::load(var_144);
                var_145 = wp::copy(var_146);
                // X_sdf_ws = shape_transform[sdf_shape]                                          <L 1654>
                var_147 = wp::address(var_shape_transform, var_77);
                var_149 = wp::load(var_147);
                var_148 = wp::copy(var_149);
                // texture_sdf = TextureSDFData()                                                 <L 1656>
                var_150 = TextureSDFData_93572308();
                // if sdf_is_hfield:                                                              <L 1657>
                // if not use_bvh_for_sdf:                                                        <L 1660>
                var_151 = wp::unot(var_123);
                if (var_151) {
                    // texture_sdf = texture_sdf_table[sdf_idx]                                   <L 1661>
                    var_152 = wp::address(var_texture_sdf_table, var_101);
                    var_154 = wp::load(var_152);
                    var_153 = wp::copy(var_154);
                }
                var_155 = wp::where(var_151, var_153, var_150);
                // if wp.static(use_identity_sdf_scale):                                          <L 1662>
                // sdf_scale = mesh_scale_sdf                                                     <L 1665>
                var_157 = wp::copy(var_143);
                // if not use_bvh_for_sdf and texture_sdf.scale_baked:                            <L 1666>
                var_159 = wp::unot(var_123);
                var_158 = var_159;
                if (var_158) {
                    var_160 = &((var_155).scale_baked);
                    var_161 = wp::load(var_160);
                    var_158 = var_158 && var_161;
                }
                if (var_158) {
                    // sdf_scale = wp.vec3(1.0, 1.0, 1.0)                                         <L 1667>
                    var_165 = wp::vec_t<3, wp::float32>(var_162, var_163, var_164);
                }
                var_166 = wp::where(var_158, var_165, var_157);
                // X_mesh_to_sdf = wp.transform_multiply(wp.transform_inverse(X_sdf_ws), X_tri_ws)       <L 1669>
                var_167 = wp::transform_inverse(var_148);
                var_168 = wp::transform_multiply(var_167, var_145);
                // triangle_mesh_margin = scale_data_tri[3]                                       <L 1671>
                var_170 = wp::extract(var_125, var_169);
                // sdf_mesh_margin = scale_data_sdf[3]                                            <L 1672>
                var_172 = wp::extract(var_128, var_171);
                // if wp.static(use_identity_sdf_scale):                                          <L 1674>
                // inv_sdf_scale, min_sdf_scale = safe_sdf_scale_inverse(sdf_scale)               <L 1679>
                safe_sdf_scale_inverse_0(var_166, var_174, var_175);
                // edge_radius_scale = wp.max(                                                    <L 1680>
                // wp.max(wp.abs(inv_sdf_scale[0]), wp.abs(inv_sdf_scale[1])), wp.abs(inv_sdf_scale[2])       <L 1681>
                var_177 = wp::extract(var_174, var_176);
                var_178 = wp::abs(var_177);
                var_180 = wp::extract(var_174, var_179);
                var_181 = wp::abs(var_180);
                var_182 = wp::max(var_178, var_181);
                var_184 = wp::extract(var_174, var_183);
                var_185 = wp::abs(var_184);
                var_186 = wp::max(var_182, var_185);
                // contact_threshold = gap_sum + triangle_mesh_margin + sdf_mesh_margin           <L 1684>
                var_187 = wp::add(var_59, var_170);
                var_188 = wp::add(var_187, var_172);
                // contact_threshold_unscaled = contact_threshold / min_sdf_scale                 <L 1685>
                var_189 = wp::div(var_188, var_175);
                // use_texture_sdf_for_search = False                                             <L 1686>
                // texture_voxel_radius = float(0.0)                                              <L 1687>
                var_192 = wp::float(var_191);
                // if wp.static(enable_heightfields):                                             <L 1688>
                // elif not use_bvh_for_sdf:                                                      <L 1692>
                var_194 = wp::unot(var_123);
                if (var_194) {
                    // use_texture_sdf_for_search = True                                          <L 1693>
                    // texture_voxel_radius = texture_sdf.voxel_radius                            <L 1694>
                    var_196 = &((var_155).voxel_radius);
                    var_198 = wp::load(var_196);
                    var_197 = wp::copy(var_198);
                }
                var_199 = wp::where(var_194, var_195, var_190);
                var_200 = wp::where(var_194, var_197, var_192);
                // search_precision_unscaled = mesh_sdf_contact_search_precision(                 <L 1695>
                // triangle_mesh_margin + sdf_mesh_margin,                                        <L 1696>
                var_201 = wp::add(var_170, var_172);
                // min_sdf_scale,                                                                 <L 1697>
                // texture_voxel_radius,                                                          <L 1698>
                // use_texture_sdf_for_search,                                                    <L 1699>
                var_202 = mesh_sdf_contact_search_precision_0(var_201, var_175, var_200, var_199);
                // edge_range_tri = shape_edge_range[tri_shape]                                   <L 1702>
                var_203 = wp::address(var_shape_edge_range, var_74);
                var_205 = wp::load(var_203);
                var_204 = wp::copy(var_205);
                // num_edges = get_edge_count(tri_type, edge_range_tri, hfd_tri)                  <L 1703>
                var_206 = get_edge_count_0(var_81, var_204, var_92);
                // chunk_size = (num_edges + blocks_for_pair - 1) // blocks_for_pair              <L 1704>
                var_207 = wp::add(var_206, var_45);
                var_209 = wp::sub(var_207, var_208);
                var_210 = wp::floordiv(var_209, var_45);
                // edge_start = block_in_pair * chunk_size                                        <L 1705>
                var_211 = wp::mul(var_41, var_210);
                // edge_end = wp.min(edge_start + chunk_size, num_edges)                          <L 1706>
                var_212 = wp::add(var_211, var_210);
                var_213 = wp::min(var_212, var_206);
                // wp.tile_scatter_masked(progress, 0, edge_start, t == 0)                        <L 1708>
                var_216 = (var_1 == var_215);
                wp::tile_scatter_masked(var_17, var_214, var_211, var_216);
                // sdf_is_heightfield = sdf_is_hfield                                             <L 1710>
                var_217 = wp::copy(var_80);
                // sdf_aabb_lower = texture_sdf.sdf_box_lower                                     <L 1711>
                var_218 = &((var_155).sdf_box_lower);
                var_220 = wp::load(var_218);
                var_219 = wp::copy(var_220);
                // sdf_aabb_upper = texture_sdf.sdf_box_upper                                     <L 1712>
                var_221 = &((var_155).sdf_box_upper);
                var_223 = wp::load(var_221);
                var_222 = wp::copy(var_223);
                // while wp.tile_extract(progress, 0) < edge_end:                                 <L 1719>
        start_while_6:;
                var_225 = wp::tile_extract(var_17, var_224);
                var_226 = (var_225 < var_213);
        if ((var_226) == false) goto end_while_6;
                    // capacity = wp.block_dim()                                                  <L 1720>
                    var_227 = builtin_block_dim();
                    // while wp.tile_extract(progress, 0) < edge_end and wp.tile_stack_count(edge_stack) < capacity:       <L 1721>
        start_while_8:;
                    var_230 = wp::tile_extract(var_17, var_229);
                    var_231 = (var_230 < var_213);
                    var_228 = var_231;
                    if (var_228) {
                        var_232 = wp::tile_stack_count(var_14);
                        var_233 = (var_232 < var_227);
                        var_228 = var_228 && var_233;
                    }
        if ((var_228) == false) goto end_while_8;
                        // base_edge_idx = wp.tile_extract(progress, 0)                           <L 1722>
                        var_235 = wp::tile_extract(var_17, var_234);
                        // edge_idx = base_edge_idx + t                                           <L 1723>
                        var_236 = wp::add(var_235, var_1);
                        // add_edge = False                                                       <L 1724>
                        // midpoint_sdf = float(0.0)                                              <L 1725>
                        var_239 = wp::float(var_238);
                        // if edge_idx < edge_end:                                                <L 1727>
                        var_240 = (var_236 < var_213);
                        if (var_240) {
                            // if wp.static(enable_heightfields):                                 <L 1728>
                            // bsphere_center, bsphere_radius = get_mesh_edge_bounding_sphere_specialized(       <L 1749>
                            // mesh_id_tri,                                                       <L 1750>
                            // mesh_edge_indices,                                                 <L 1751>
                            // mesh_edge_centers,                                                 <L 1752>
                            // edge_range_tri,                                                    <L 1753>
                            // mesh_scale_tri,                                                    <L 1754>
                            // X_mesh_to_sdf,                                                     <L 1755>
                            // inv_sdf_scale,                                                     <L 1756>
                            // edge_radius_scale,                                                 <L 1757>
                            // edge_idx,                                                          <L 1758>
                            _create_get_mesh_edge_bounding_sphere_func__locals__get_mesh_edge_bounding_sphere_func_1(var_83, var_mesh_edge_indices, var_mesh_edge_centers, var_204, var_136, var_168, var_174, var_186, var_236, var_242, var_243);
                            // threshold = bsphere_radius + contact_threshold_unscaled            <L 1761>
                            var_244 = wp::add(var_243, var_189);
                            // if wp.static(enable_heightfields) and sdf_is_heightfield:          <L 1763>
                            var_245 = var_246;
                            if (var_245) {
                                var_245 = var_245 && var_217;
                            }
                            if (var_245) {
                                // midpoint_sdf = sample_sdf_heightfield(hfd_sdf, heightfield_elevations, bsphere_center)       <L 1764>
                                var_247 = sample_sdf_heightfield_0(var_93, var_heightfield_elevations, var_242);
                                // add_edge = midpoint_sdf <= threshold                           <L 1765>
                                var_248 = (var_247 <= var_244);
                            }
                            if (!var_245) {
                                // elif wp.static(not use_texture_sdf_only) and use_bvh_for_sdf:       <L 1766>
                                var_249 = var_250;
                                if (var_249) {
                                    var_249 = var_249 && var_123;
                                }
                                if (var_249) {
                                    // midpoint_sdf = sample_sdf_using_mesh(                      <L 1767>
                                    // mesh_id_sdf,                                               <L 1768>
                                    // bsphere_center,                                            <L 1769>
                                    // _SDF_QUERY_RADIUS_SLACK * threshold,                       <L 1770>
                                    var_252 = wp::mul(var_251, var_244);
                                    // sdf_mesh_query_type,                                       <L 1771>
                                    var_253 = sample_sdf_using_mesh_0(var_86, var_242, var_252, var_96);
                                    // add_edge = midpoint_sdf <= threshold                       <L 1773>
                                    var_254 = (var_253 <= var_244);
                                }
                                if (!var_249) {
                                    // culling_radius = threshold                                 <L 1775>
                                    var_255 = wp::copy(var_244);
                                    // clamped = wp.min(wp.max(bsphere_center, sdf_aabb_lower), sdf_aabb_upper)       <L 1776>
                                    var_256 = wp::max(var_242, var_219);
                                    var_257 = wp::min(var_256, var_222);
                                    // aabb_dist_sq = wp.length_sq(bsphere_center - clamped)       <L 1777>
                                    var_258 = wp::sub(var_242, var_257);
                                    var_259 = wp::length_sq(var_258);
                                    // if aabb_dist_sq > culling_radius * culling_radius:         <L 1778>
                                    var_260 = wp::mul(var_255, var_255);
                                    var_261 = (var_259 > var_260);
                                    if (var_261) {
                                        // add_edge = False                                       <L 1779>
                                    }
                                    if (!var_261) {
                                        // diff_mag = float(0.0)                                  <L 1781>
                                        var_264 = wp::float(var_263);
                                        // if aabb_dist_sq > 0.0:                                 <L 1782>
                                        var_266 = (var_259 > var_265);
                                        if (var_266) {
                                            // diff_mag = wp.sqrt(aabb_dist_sq)                   <L 1783>
                                            var_267 = wp::sqrt(var_259);
                                        }
                                        var_268 = wp::where(var_266, var_267, var_264);
                                        // midpoint_sdf = wp.static(sample_clamped)(texture_sdf, clamped, diff_mag)       <L 1784>
                                        var_269 = _texture_sample_sdf_hw_clamped_0(var_155, var_257, var_268);
                                        // add_edge = midpoint_sdf <= culling_radius              <L 1785>
                                        var_270 = (var_269 <= var_255);
                                    }
                                    var_271 = wp::where(var_261, var_262, var_270);
                                    var_272 = wp::where(var_261, var_239, var_269);
                                }
                                var_273 = wp::where(var_249, var_254, var_271);
                                var_274 = wp::where(var_249, var_253, var_272);
                            }
                            var_275 = wp::where(var_245, var_248, var_273);
                            var_276 = wp::where(var_245, var_247, var_274);
                        }
                        var_277 = wp::where(var_240, var_275, var_237);
                        var_278 = wp::where(var_240, var_276, var_239);
                        // cull_result = EdgeCullResult()                                         <L 1787>
                        var_279 = EdgeCullResult_d4aae4ab();
                        // cull_result.edge_idx = edge_idx                                        <L 1788>
                        var_279.edge_idx = var_236;
                        // cull_result.midpoint_sdf = midpoint_sdf                                <L 1789>
                        var_279.midpoint_sdf = var_278;
                        // wp.tile_stack_push(edge_stack, cull_result, add_edge)                  <L 1790>
                        var_280 = wp::tile_stack_push(var_14, var_279, var_277);
                        // wp.tile_scatter_masked(progress, 0, base_edge_idx + capacity, t == 0)       <L 1791>
                        var_282 = wp::add(var_235, var_227);
                        var_284 = (var_1 == var_283);
                        wp::tile_scatter_masked(var_17, var_281, var_282, var_284);
        goto start_while_8;
        end_while_8:;
                    // while wp.tile_stack_count(edge_stack) > 0:                                 <L 1798>
        start_while_10:;
                    var_285 = wp::tile_stack_count(var_14);
                    var_287 = (var_285 > var_286);
        if ((var_287) == false) goto end_while_10;
                        // popped, edge_slot = wp.tile_stack_pop(edge_stack)                      <L 1799>
                        wp::tile_stack_pop(var_14, var_288, var_289);
                        // my_edge_idx = popped.edge_idx                                          <L 1800>
                        var_290 = &((var_288).edge_idx);
                        var_292 = wp::load(var_290);
                        var_291 = wp::copy(var_292);
                        // cached_sdf_val = popped.midpoint_sdf                                   <L 1801>
                        var_293 = &((var_288).midpoint_sdf);
                        var_295 = wp::load(var_293);
                        var_294 = wp::copy(var_295);
                        // has_edge = edge_slot >= 0                                              <L 1802>
                        var_297 = (var_289 >= var_296);
                        // if has_edge:                                                           <L 1804>
                        if (var_297) {
                            // corner_ownership = int(0)                                          <L 1805>
                            var_299 = wp::int(var_298);
                            // if wp.static(enable_heightfields):                                 <L 1806>
                            // v0s, v1s, corner_ownership = get_mesh_edge_specialized(            <L 1826>
                            // mesh_id_tri,                                                       <L 1827>
                            // mesh_edge_indices,                                                 <L 1828>
                            // mesh_edge_centers,                                                 <L 1829>
                            // mesh_edge_halves,                                                  <L 1830>
                            // edge_range_tri,                                                    <L 1831>
                            // mesh_scale_tri,                                                    <L 1832>
                            // X_mesh_to_sdf,                                                     <L 1833>
                            // my_edge_idx,                                                       <L 1834>
                            _create_mesh_edge_accessor_func__locals__get_edge_from_mesh_func_1(var_83, var_mesh_edge_indices, var_mesh_edge_centers, var_mesh_edge_halves, var_204, var_136, var_168, var_291, var_301, var_302, var_303);
                            // v0 = wp.cw_mul(v0s, inv_sdf_scale)                                 <L 1836>
                            var_304 = wp::cw_mul(var_301, var_174);
                            // v1 = wp.cw_mul(v1s, inv_sdf_scale)                                 <L 1837>
                            var_305 = wp::cw_mul(var_302, var_174);
                            // dist_unscaled, point_unscaled, best_endpoint = do_edge_sdf_collision(       <L 1839>
                            // texture_sdf,                                                       <L 1840>
                            // mesh_id_sdf,                                                       <L 1841>
                            // v0,                                                                <L 1842>
                            // v1,                                                                <L 1843>
                            // cached_sdf_val,                                                    <L 1844>
                            // use_bvh_for_sdf,                                                   <L 1845>
                            // sdf_mesh_query_type,                                               <L 1846>
                            // sdf_is_hfield,                                                     <L 1847>
                            // hfd_sdf,                                                           <L 1848>
                            // heightfield_elevations,                                            <L 1849>
                            // search_precision_unscaled,                                         <L 1850>
                            _create_sdf_contact_funcs__locals__do_edge_sdf_collision_func_1(var_155, var_86, var_304, var_305, var_294, var_123, var_96, var_80, var_93, var_heightfield_elevations, var_202, var_306, var_307, var_308);
                            // dist_approx = dist_unscaled * min_sdf_scale                        <L 1859>
                            var_309 = wp::mul(var_306, var_175);
                            // bsphere_center_inner, bsphere_radius_inner = get_edge_bounding_sphere(v0, v1)       <L 1860>
                            get_edge_bounding_sphere_0(var_304, var_305, var_310, var_311);
                            // inner_cull_consistent = mesh_sdf_contact_passes_inner_cull_consistency(       <L 1861>
                            // dist_approx,                                                       <L 1862>
                            // triangle_mesh_margin + sdf_mesh_margin,                            <L 1863>
                            var_312 = wp::add(var_170, var_172);
                            // cached_sdf_val,                                                    <L 1864>
                            // bsphere_center_inner,                                              <L 1865>
                            // bsphere_radius_inner,                                              <L 1866>
                            // sdf_aabb_lower,                                                    <L 1867>
                            // sdf_aabb_upper,                                                    <L 1868>
                            // min_sdf_scale,                                                     <L 1869>
                            // use_texture_sdf_for_search,                                        <L 1870>
                            var_313 = mesh_sdf_contact_passes_inner_cull_consistency_0(var_309, var_312, var_294, var_310, var_311, var_219, var_222, var_175, var_199);
                            // owns_endpoint = (                                                  <L 1872>
                            // best_endpoint == 0 or corner_ownership == 0 or (corner_ownership & best_endpoint) != 0       <L 1873>
                            var_316 = (var_308 == var_315);
                            var_314 = var_316;
                            if (!var_314) {
                                var_318 = (var_303 == var_317);
                                var_314 = var_314 || var_318;
                            }
                            if (!var_314) {
                                var_319 = wp::bit_and(var_303, var_308);
                                var_321 = (var_319 != var_320);
                                var_314 = var_314 || var_321;
                            }
                            // if dist_approx < contact_threshold and inner_cull_consistent and owns_endpoint:       <L 1875>
                            var_323 = (var_309 < var_188);
                            var_322 = var_323;
                            if (var_322) {
                                var_322 = var_322 && var_313;
                            }
                            if (var_322) {
                                var_322 = var_322 && var_314;
                            }
                            if (var_322) {
                                // if wp.static(enable_heightfields):                             <L 1876>
                                // if wp.static(not use_texture_sdf_only) and use_bvh_for_sdf:       <L 1895>
                                var_325 = var_326;
                                if (var_325) {
                                    var_325 = var_325 && var_123;
                                }
                                if (var_325) {
                                    // dist_unscaled, direction_unscaled = sample_sdf_grad_using_mesh(       <L 1896>
                                    // mesh_id_sdf,                                               <L 1897>
                                    // point_unscaled,                                            <L 1898>
                                    // _MESH_QUERY_MAX_DIST,                                      <L 1899>
                                    // sdf_mesh_query_type,                                       <L 1900>
                                    sample_sdf_grad_using_mesh_0(var_86, var_307, var_327, var_96, var_328, var_329);
                                }
                                if (!var_325) {
                                    // direction_unscaled = wp.static(sample_grad)(texture_sdf, point_unscaled)       <L 1907>
                                    var_330 = texture_sample_sdf_grad_only_hw_0(var_155, var_307);
                                }
                                var_331 = wp::where(var_325, var_328, var_306);
                                var_332 = wp::where(var_325, var_329, var_330);
                                // if wp.static(use_identity_sdf_scale):                          <L 1909>
                                // dist, direction = scale_sdf_result_to_world(                   <L 1914>
                                // dist_unscaled, direction_unscaled, sdf_scale, inv_sdf_scale, min_sdf_scale       <L 1915>
                                scale_sdf_result_to_world_0(var_331, var_332, var_166, var_174, var_175, var_334, var_335);
                                // point = wp.cw_mul(point_unscaled, sdf_scale)                   <L 1917>
                                var_336 = wp::cw_mul(var_307, var_166);
                                // point_world = wp.transform_point(X_sdf_ws, point)              <L 1918>
                                var_337 = wp::transform_point(var_148, var_336);
                                // direction_world = wp.transform_vector(X_sdf_ws, direction)       <L 1920>
                                var_338 = wp::transform_vector(var_148, var_335);
                                // direction_len_sq = wp.length_sq(direction_world)               <L 1921>
                                var_339 = wp::length_sq(var_338);
                                // if direction_len_sq > 0.0:                                     <L 1922>
                                var_341 = (var_339 > var_340);
                                if (var_341) {
                                    // direction_world = direction_world * _sdf_rsqrt_rn(direction_len_sq)       <L 1923>
                                    var_342 = _sdf_rsqrt_rn_0(var_339);
                                    var_343 = wp::mul(var_338, var_342);
                                }
                                if (!var_341) {
                                    // fallback_dir = point_world - wp.transform_get_translation(X_sdf_ws)       <L 1925>
                                    var_344 = wp::transform_get_translation(var_148);
                                    var_345 = wp::sub(var_337, var_344);
                                    // fallback_len_sq = wp.length_sq(fallback_dir)               <L 1926>
                                    var_346 = wp::length_sq(var_345);
                                    // if fallback_len_sq > 0.0:                                  <L 1927>
                                    var_348 = (var_346 > var_347);
                                    if (var_348) {
                                        // direction_world = fallback_dir * _sdf_rsqrt_rn(fallback_len_sq)       <L 1928>
                                        var_349 = _sdf_rsqrt_rn_0(var_346);
                                        var_350 = wp::mul(var_345, var_349);
                                    }
                                    if (!var_348) {
                                        // direction_world = wp.vec3(0.0, 1.0, 0.0)               <L 1930>
                                        var_354 = wp::vec_t<3, wp::float32>(var_351, var_352, var_353);
                                    }
                                    var_355 = wp::where(var_348, var_350, var_354);
                                }
                                var_356 = wp::where(var_341, var_343, var_355);
                                // contact_normal = -direction_world if mode == 0 else direction_world       <L 1932>
                                var_358 = (var_73 == var_357);
                                if (var_358) {
                                    var_359 = wp::neg(var_356);
                                }
                                if (!var_358) {
                                }
                                var_360 = wp::where(var_358, var_359, var_356);
                                // position_local_tri = wp.quat_rotate_inv(                       <L 1933>
                                // wp.transform_get_rotation(X_tri_ws),                           <L 1934>
                                var_361 = wp::transform_get_rotation(var_145);
                                // point_world - wp.transform_get_translation(X_tri_ws),          <L 1935>
                                var_362 = wp::transform_get_translation(var_145);
                                var_363 = wp::sub(var_337, var_362);
                                var_364 = wp::quat_rotate_inv(var_361, var_363);
                                // aabb_lower_tri = shape_collision_aabb_lower[tri_shape]         <L 1937>
                                var_365 = wp::address(var_shape_collision_aabb_lower, var_74);
                                var_367 = wp::load(var_365);
                                var_366 = wp::copy(var_367);
                                // aabb_upper_tri = shape_collision_aabb_upper[tri_shape]         <L 1938>
                                var_368 = wp::address(var_shape_collision_aabb_upper, var_74);
                                var_370 = wp::load(var_368);
                                var_369 = wp::copy(var_370);
                                // voxel_res_tri = shape_voxel_resolution[tri_shape]              <L 1939>
                                var_371 = wp::address(var_shape_voxel_resolution, var_74);
                                var_373 = wp::load(var_371);
                                var_372 = wp::copy(var_373);
                                // margin_sum = triangle_mesh_margin + sdf_mesh_margin            <L 1940>
                                var_374 = wp::add(var_170, var_172);
                                // midpoint = (                                                   <L 1941>
                                // wp.transform_get_translation(X_tri_ws) + wp.transform_get_translation(X_sdf_ws)       <L 1942>
                                var_375 = wp::transform_get_translation(var_145);
                                var_376 = wp::transform_get_translation(var_148);
                                var_377 = wp::add(var_375, var_376);
                                // ) * 0.5                                                        <L 1943>
                                var_379 = wp::mul(var_377, var_378);
                                // inner_spatial_depth = margin_sum                               <L 1944>
                                var_380 = wp::copy(var_374);
                                // if use_texture_sdf_for_search:                                 <L 1945>
                                if (var_199) {
                                    // inner_spatial_depth += wp.min(texture_voxel_radius * min_sdf_scale, base_gap_sum)       <L 1946>
                                    var_381 = wp::mul(var_200, var_175);
                                    var_382 = wp::min(var_381, var_68);
                                    var_383 = wp::add(var_380, var_382);
                                }
                                var_384 = wp::where(var_199, var_383, var_380);
                                // outer_spatial_depth = margin_sum + gap_sum                     <L 1947>
                                var_385 = wp::add(var_374, var_59);
                                // if wp.static(speculative):                                     <L 1948>
                                // contact_id = export_and_reduce_contact_centered_two_spatial_depths(       <L 1952>
                                // pair[0],                                                       <L 1953>
                                var_388 = wp::extract(var_52, var_387);
                                // pair[1],                                                       <L 1954>
                                var_390 = wp::extract(var_52, var_389);
                                // point_world,                                                   <L 1955>
                                // contact_normal,                                                <L 1956>
                                // dist,                                                          <L 1957>
                                // (my_edge_idx << 2) | (mode << 1),                              <L 1958>
                                var_392 = wp::lshift(var_291, var_391);
                                var_394 = wp::lshift(var_73, var_393);
                                var_395 = wp::bit_or(var_392, var_394);
                                // point_world - midpoint,                                        <L 1959>
                                var_396 = wp::sub(var_337, var_379);
                                // inner_spatial_depth,                                           <L 1960>
                                // outer_spatial_depth,                                           <L 1961>
                                // position_local_tri,                                            <L 1962>
                                // aabb_lower_tri,                                                <L 1963>
                                // aabb_upper_tri,                                                <L 1964>
                                // voxel_res_tri,                                                 <L 1965>
                                // reducer_data,                                                  <L 1966>
                                var_397 = export_and_reduce_contact_centered_two_spatial_depths_0(var_388, var_390, var_337, var_360, var_334, var_395, var_396, var_384, var_385, var_364, var_366, var_369, var_372, var_reducer_data);
                                // if wp.static(speculative):                                     <L 1968>
                            }
                            var_399 = wp::where(var_322, var_331, var_306);
                        }
        goto start_while_10;
        end_while_10:;
                    // wp.tile_stack_clear(edge_stack)                                            <L 1993>
                    wp::tile_stack_clear(var_14);
        goto start_while_6;
        end_while_6:;
                goto start_for_4;
            end_for_4:;
            goto start_for_0;
        end_for_0:;
    }
}

