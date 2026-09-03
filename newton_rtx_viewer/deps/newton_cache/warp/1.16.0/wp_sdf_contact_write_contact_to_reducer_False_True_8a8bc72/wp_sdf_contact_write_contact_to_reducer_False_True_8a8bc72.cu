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




struct TextureSDFData_9ae3a59e
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
    bool scale_baked;


    TextureSDFData_9ae3a59e() = default;
    CUDA_CALLABLE TextureSDFData_9ae3a59e(wp::texture3d_t const& coarse_texture,
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
        , scale_baked{scale_baked}

    {
    }

    CUDA_CALLABLE TextureSDFData_9ae3a59e& operator += (const TextureSDFData_9ae3a59e& rhs)
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

static CUDA_CALLABLE void adj_TextureSDFData_9ae3a59e(wp::texture3d_t const&,
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
    bool & adj_scale_baked,
    TextureSDFData_9ae3a59e & adj_ret)
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
    adj_scale_baked += adj_ret.scale_baked;
}

// Required when compiling adjoints.
CUDA_CALLABLE TextureSDFData_9ae3a59e add(const TextureSDFData_9ae3a59e& a, const TextureSDFData_9ae3a59e& b)
{
    return TextureSDFData_9ae3a59e();
}

CUDA_CALLABLE void adj_atomic_add(TextureSDFData_9ae3a59e* p, TextureSDFData_9ae3a59e t)
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




// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/kernels.py:15
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_contact.py:107
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
    // def safe_sdf_scale_inverse(sdf_scale: wp.vec3) -> tuple[wp.vec3, float]:               <L 108>
    // eps = float(1.0e-10)                                                                   <L 117>
    var_1 = wp::float(var_0);
    // sx = wp.where(wp.abs(sdf_scale[0]) > eps, sdf_scale[0], wp.where(sdf_scale[0] >= 0.0, eps, -eps))       <L 118>
    var_3 = wp::extract(var_sdf_scale, var_2);
    var_4 = wp::abs(var_3);
    var_5 = (var_4 > var_1);
    var_7 = wp::extract(var_sdf_scale, var_6);
    var_9 = wp::extract(var_sdf_scale, var_8);
    var_11 = (var_9 >= var_10);
    var_12 = wp::neg(var_1);
    var_13 = wp::where(var_11, var_1, var_12);
    var_14 = wp::where(var_5, var_7, var_13);
    // sy = wp.where(wp.abs(sdf_scale[1]) > eps, sdf_scale[1], wp.where(sdf_scale[1] >= 0.0, eps, -eps))       <L 119>
    var_16 = wp::extract(var_sdf_scale, var_15);
    var_17 = wp::abs(var_16);
    var_18 = (var_17 > var_1);
    var_20 = wp::extract(var_sdf_scale, var_19);
    var_22 = wp::extract(var_sdf_scale, var_21);
    var_24 = (var_22 >= var_23);
    var_25 = wp::neg(var_1);
    var_26 = wp::where(var_24, var_1, var_25);
    var_27 = wp::where(var_18, var_20, var_26);
    // sz = wp.where(wp.abs(sdf_scale[2]) > eps, sdf_scale[2], wp.where(sdf_scale[2] >= 0.0, eps, -eps))       <L 120>
    var_29 = wp::extract(var_sdf_scale, var_28);
    var_30 = wp::abs(var_29);
    var_31 = (var_30 > var_1);
    var_33 = wp::extract(var_sdf_scale, var_32);
    var_35 = wp::extract(var_sdf_scale, var_34);
    var_37 = (var_35 >= var_36);
    var_38 = wp::neg(var_1);
    var_39 = wp::where(var_37, var_1, var_38);
    var_40 = wp::where(var_31, var_33, var_39);
    // inv = wp.vec3(1.0 / sx, 1.0 / sy, 1.0 / sz)                                            <L 121>
    var_42 = wp::div(var_41, var_14);
    var_44 = wp::div(var_43, var_27);
    var_46 = wp::div(var_45, var_40);
    var_47 = wp::vec_t<3, wp::float32>(var_42, var_44, var_46);
    // min_abs = wp.min(wp.min(wp.abs(sx), wp.abs(sy)), wp.abs(sz))                           <L 122>
    var_48 = wp::abs(var_14);
    var_49 = wp::abs(var_27);
    var_50 = wp::min(var_48, var_49);
    var_51 = wp::abs(var_40);
    var_52 = wp::min(var_50, var_51);
    // return inv, min_abs                                                                    <L 123>
    ret_0 = var_47;
    ret_1 = var_52;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_contact.py:67
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
    // def mesh_sdf_contact_search_precision(                                                 <L 68>
    // search_precision = inner_contact_threshold / min_sdf_scale                             <L 75>
    var_0 = wp::div(var_inner_contact_threshold, var_min_sdf_scale);
    // if use_texture_sdf:                                                                    <L 76>
    if (var_use_texture_sdf) {
        // search_precision = wp.min(search_precision, voxel_radius)                          <L 77>
        var_1 = wp::min(var_0, var_voxel_radius);
    }
    var_2 = wp::where(var_use_texture_sdf, var_1, var_0);
    // return search_precision                                                                <L 78>
    return var_2;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_contact.py:558
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
    // def get_edge_count(shape_type: int, edge_range: wp.vec2i, hfd: HeightfieldData) -> int:       <L 559>
    // if shape_type == GeoType.HFIELD:                                                       <L 561>
    var_1 = (var_shape_type == var_0);
    if (var_1) {
        // if hfd.nrow <= 1 or hfd.ncol <= 1:                                                 <L 562>
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
            // return 0                                                                       <L 563>
            return var_11;
        }
        // return hfd.nrow * (hfd.ncol - 1) + (hfd.nrow - 1) * hfd.ncol + (hfd.nrow - 1) * (hfd.ncol - 1)       <L 564>
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
    // return edge_range[1]                                                                   <L 565>
    var_38 = wp::extract(var_edge_range, var_37);
    return var_38;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_contact.py:410
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
    // def get_edge_from_mesh(                                                                <L 411>
    // mesh = wp.mesh_get(mesh_id)                                                            <L 436>
    var_0 = wp::mesh_get(var_mesh_id);
    // edge = mesh_edge_indices[edge_range[0] + edge_idx]                                     <L 437>
    var_2 = wp::extract(var_edge_range, var_1);
    var_3 = wp::add(var_2, var_edge_idx);
    var_4 = wp::address(var_mesh_edge_indices, var_3);
    var_6 = wp::load(var_4);
    var_5 = wp::copy(var_6);
    // idx0 = edge[0]                                                                         <L 439>
    var_8 = wp::extract(var_5, var_7);
    // idx1 = edge[1]                                                                         <L 440>
    var_10 = wp::extract(var_5, var_9);
    // v0_local = wp.cw_mul(mesh.points[idx0], mesh_scale)                                    <L 442>
    var_11 = &((var_0).points);
    var_13 = wp::load(var_11);
    var_12 = wp::address(var_13, var_8);
    var_15 = wp::load(var_12);
    var_14 = wp::cw_mul(var_15, var_mesh_scale);
    // v1_local = wp.cw_mul(mesh.points[idx1], mesh_scale)                                    <L 443>
    var_16 = &((var_0).points);
    var_18 = wp::load(var_16);
    var_17 = wp::address(var_18, var_10);
    var_20 = wp::load(var_17);
    var_19 = wp::cw_mul(var_20, var_mesh_scale);
    // v0_world = wp.transform_point(X_mesh_ws, v0_local)                                     <L 445>
    var_21 = wp::transform_point(var_X_mesh_ws, var_14);
    // v1_world = wp.transform_point(X_mesh_ws, v1_local)                                     <L 446>
    var_22 = wp::transform_point(var_X_mesh_ws, var_19);
    // return v0_world, v1_world                                                              <L 448>
    ret_0 = var_21;
    ret_1 = var_22;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_contact.py:532
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
    // def get_edge_bounding_sphere(v0: wp.vec3, v1: wp.vec3) -> tuple[wp.vec3, float]:       <L 533>
    // midpoint = (v0 + v1) * 0.5                                                             <L 543>
    var_0 = wp::add(var_v0, var_v1);
    var_2 = wp::mul(var_0, var_1);
    // half_length = wp.length(v1 - v0) * 0.5                                                 <L 544>
    var_3 = wp::sub(var_v1, var_v0);
    var_4 = wp::length(var_3);
    var_6 = wp::mul(var_4, var_5);
    // return midpoint, half_length                                                           <L 545>
    ret_0 = var_2;
    ret_1 = var_6;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/utils/heightfield.py:171
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/utils/heightfield.py:230
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/kernels.py:884
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
    // def mesh_query_point_sign(mesh: wp.uint64, point: wp.vec3, max_dist: float, sign_method: int):       <L 885>
    // if sign_method == MeshSignMethod.PARITY:                                               <L 887>
    var_1 = (var_sign_method == var_0);
    if (var_1) {
        // return wp.mesh_query_point_sign_parity(mesh, point, max_dist)                      <L 888>
        var_2 = wp::mesh_query_point_sign_parity(var_mesh, var_point, var_max_dist, var_3, var_4);
        return var_2;
    }
    // return wp.mesh_query_point_sign_normal(mesh, point, max_dist)                          <L 889>
    var_5 = wp::mesh_query_point_sign_normal(var_mesh, var_point, var_max_dist, var_6);
    return var_5;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_contact.py:176
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
    // def sample_sdf_using_mesh(                                                             <L 177>
    // res = mesh_query_point_sign(mesh_id, world_pos, max_dist, sign_method)                 <L 199>
    var_0 = mesh_query_point_sign_0(var_mesh_id, var_world_pos, var_max_dist, var_sign_method);
    // if res.result:                                                                         <L 201>
    var_1 = &((var_0).result);
    var_2 = wp::load(var_1);
    if (var_2) {
        // closest = wp.mesh_eval_position(mesh_id, res.face, res.u, res.v)                   <L 202>
        var_3 = &((var_0).face);
        var_4 = &((var_0).u);
        var_5 = &((var_0).v);
        var_7 = wp::load(var_3);
        var_8 = wp::load(var_4);
        var_9 = wp::load(var_5);
        var_6 = wp::mesh_eval_position(var_mesh_id, var_7, var_8, var_9);
        // return wp.length(world_pos - closest) * res.sign                                   <L 203>
        var_10 = wp::sub(var_world_pos, var_6);
        var_11 = wp::length(var_10);
        var_12 = &((var_0).sign);
        var_14 = wp::load(var_12);
        var_13 = wp::mul(var_11, var_14);
        return var_13;
    }
    var_15 = wp::load(var_1);
    // return max_dist                                                                        <L 205>
    return var_max_dist;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_texture.py:775
static CUDA_CALLABLE _CellLookup_6716dbae _locate_cell_0(
    TextureSDFData_9ae3a59e var_sdf,
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
    wp::array_t<wp::uint32>* var_93;
    wp::uint32* var_94;
    wp::array_t<wp::uint32> var_95;
    wp::uint32 var_96;
    wp::uint32 var_97;
    _CellLookup_6716dbae var_98;
    //---------
    // forward
    // def _locate_cell(sdf: TextureSDFData, f: wp.vec3) -> _CellLookup:                      <L 776>
    // coarse_x = sdf.coarse_texture.width - 1                                                <L 781>
    var_0 = &((var_sdf).coarse_texture);
    var_1 = &(((var_sdf).coarse_texture).width);
    var_4 = wp::load(var_1);
    var_3 = wp::sub(var_4, var_2);
    // coarse_y = sdf.coarse_texture.height - 1                                               <L 782>
    var_5 = &((var_sdf).coarse_texture);
    var_6 = &(((var_sdf).coarse_texture).height);
    var_9 = wp::load(var_6);
    var_8 = wp::sub(var_9, var_7);
    // coarse_z = sdf.coarse_texture.depth - 1                                                <L 783>
    var_10 = &((var_sdf).coarse_texture);
    var_11 = &(((var_sdf).coarse_texture).depth);
    var_14 = wp::load(var_11);
    var_13 = wp::sub(var_14, var_12);
    // fine_verts_x = float(coarse_x) * sdf.subgrid_size_f                                    <L 785>
    var_15 = wp::float(var_3);
    var_16 = &((var_sdf).subgrid_size_f);
    var_18 = wp::load(var_16);
    var_17 = wp::mul(var_15, var_18);
    // fine_verts_y = float(coarse_y) * sdf.subgrid_size_f                                    <L 786>
    var_19 = wp::float(var_8);
    var_20 = &((var_sdf).subgrid_size_f);
    var_22 = wp::load(var_20);
    var_21 = wp::mul(var_19, var_22);
    // fine_verts_z = float(coarse_z) * sdf.subgrid_size_f                                    <L 787>
    var_23 = wp::float(var_13);
    var_24 = &((var_sdf).subgrid_size_f);
    var_26 = wp::load(var_24);
    var_25 = wp::mul(var_23, var_26);
    // fx = wp.clamp(f[0], 0.0, fine_verts_x)                                                 <L 789>
    var_28 = wp::extract(var_f, var_27);
    var_30 = wp::clamp(var_28, var_29, var_17);
    // fy = wp.clamp(f[1], 0.0, fine_verts_y)                                                 <L 790>
    var_32 = wp::extract(var_f, var_31);
    var_34 = wp::clamp(var_32, var_33, var_21);
    // fz = wp.clamp(f[2], 0.0, fine_verts_z)                                                 <L 791>
    var_36 = wp::extract(var_f, var_35);
    var_38 = wp::clamp(var_36, var_37, var_25);
    // num_fine_cells_x = int(fine_verts_x)                                                   <L 793>
    var_39 = wp::int(var_17);
    // num_fine_cells_y = int(fine_verts_y)                                                   <L 794>
    var_40 = wp::int(var_21);
    // num_fine_cells_z = int(fine_verts_z)                                                   <L 795>
    var_41 = wp::int(var_25);
    // ix = wp.clamp(int(wp.floor(fx)), 0, num_fine_cells_x - 1)                              <L 796>
    var_42 = wp::floor(var_30);
    var_43 = wp::int(var_42);
    var_46 = wp::sub(var_39, var_45);
    var_47 = wp::clamp(var_43, var_44, var_46);
    // iy = wp.clamp(int(wp.floor(fy)), 0, num_fine_cells_y - 1)                              <L 797>
    var_48 = wp::floor(var_34);
    var_49 = wp::int(var_48);
    var_52 = wp::sub(var_40, var_51);
    var_53 = wp::clamp(var_49, var_50, var_52);
    // iz = wp.clamp(int(wp.floor(fz)), 0, num_fine_cells_z - 1)                              <L 798>
    var_54 = wp::floor(var_38);
    var_55 = wp::int(var_54);
    var_58 = wp::sub(var_41, var_57);
    var_59 = wp::clamp(var_55, var_56, var_58);
    // tx = fx - float(ix)                                                                    <L 799>
    var_60 = wp::float(var_47);
    var_61 = wp::sub(var_30, var_60);
    // ty = fy - float(iy)                                                                    <L 800>
    var_62 = wp::float(var_53);
    var_63 = wp::sub(var_34, var_62);
    // tz = fz - float(iz)                                                                    <L 801>
    var_64 = wp::float(var_59);
    var_65 = wp::sub(var_38, var_64);
    // x_base = wp.clamp(int(float(ix) * sdf.fine_to_coarse), 0, coarse_x - 1)                <L 803>
    var_66 = wp::float(var_47);
    var_67 = &((var_sdf).fine_to_coarse);
    var_69 = wp::load(var_67);
    var_68 = wp::mul(var_66, var_69);
    var_70 = wp::int(var_68);
    var_73 = wp::sub(var_3, var_72);
    var_74 = wp::clamp(var_70, var_71, var_73);
    // y_base = wp.clamp(int(float(iy) * sdf.fine_to_coarse), 0, coarse_y - 1)                <L 804>
    var_75 = wp::float(var_53);
    var_76 = &((var_sdf).fine_to_coarse);
    var_78 = wp::load(var_76);
    var_77 = wp::mul(var_75, var_78);
    var_79 = wp::int(var_77);
    var_82 = wp::sub(var_8, var_81);
    var_83 = wp::clamp(var_79, var_80, var_82);
    // z_base = wp.clamp(int(float(iz) * sdf.fine_to_coarse), 0, coarse_z - 1)                <L 805>
    var_84 = wp::float(var_59);
    var_85 = &((var_sdf).fine_to_coarse);
    var_87 = wp::load(var_85);
    var_86 = wp::mul(var_84, var_87);
    var_88 = wp::int(var_86);
    var_91 = wp::sub(var_13, var_90);
    var_92 = wp::clamp(var_88, var_89, var_91);
    // start_slot = sdf.subgrid_start_slots[x_base, y_base, z_base]                           <L 807>
    var_93 = &((var_sdf).subgrid_start_slots);
    var_95 = wp::load(var_93);
    var_94 = wp::address(var_95, var_74, var_83, var_92);
    var_97 = wp::load(var_94);
    var_96 = wp::copy(var_97);
    // loc = _CellLookup()                                                                    <L 809>
    var_98 = _CellLookup_6716dbae();
    // loc.ix = ix                                                                            <L 810>
    var_98.ix = var_47;
    // loc.iy = iy                                                                            <L 811>
    var_98.iy = var_53;
    // loc.iz = iz                                                                            <L 812>
    var_98.iz = var_59;
    // loc.tx = tx                                                                            <L 813>
    var_98.tx = var_61;
    // loc.ty = ty                                                                            <L 814>
    var_98.ty = var_63;
    // loc.tz = tz                                                                            <L 815>
    var_98.tz = var_65;
    // loc.x_base = x_base                                                                    <L 816>
    var_98.x_base = var_74;
    // loc.y_base = y_base                                                                    <L 817>
    var_98.y_base = var_83;
    // loc.z_base = z_base                                                                    <L 818>
    var_98.z_base = var_92;
    // loc.start_slot = start_slot                                                            <L 819>
    var_98.start_slot = var_96;
    // return loc                                                                             <L 820>
    return var_98;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_texture.py:1076
static CUDA_CALLABLE wp::float32 texture_sample_sdf_hw_0(
    TextureSDFData_9ae3a59e var_sdf,
    wp::vec_t<3, wp::float32> var_local_pos)
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
    wp::float32 var_35;
    wp::vec_t<3, wp::float32>* var_36;
    wp::vec_t<3, wp::float32> var_37;
    wp::vec_t<3, wp::float32> var_38;
    wp::vec_t<3, wp::float32>* var_39;
    wp::vec_t<3, wp::float32> var_40;
    wp::vec_t<3, wp::float32> var_41;
    _CellLookup_6716dbae var_42;
    const wp::float32 var_43 = 0.0;
    wp::float32 var_44;
    wp::uint32* var_45;
    const wp::uint32 var_46 = 4294967294u;
    bool var_47;
    wp::uint32 var_48;
    wp::int32* var_49;
    wp::float32 var_50;
    wp::int32 var_51;
    wp::int32* var_52;
    wp::float32 var_53;
    wp::int32 var_54;
    wp::int32* var_55;
    wp::float32 var_56;
    wp::int32 var_57;
    wp::int32* var_58;
    wp::float32 var_59;
    wp::int32 var_60;
    wp::float32* var_61;
    wp::float32 var_62;
    wp::float32 var_63;
    wp::int32* var_64;
    wp::float32 var_65;
    wp::int32 var_66;
    wp::float32* var_67;
    wp::float32 var_68;
    wp::float32 var_69;
    wp::int32* var_70;
    wp::float32 var_71;
    wp::int32 var_72;
    wp::float32* var_73;
    wp::float32 var_74;
    wp::float32 var_75;
    wp::vec_t<3, wp::float32> var_76;
    wp::float32* var_77;
    wp::vec_t<3, wp::float32> var_78;
    wp::float32 var_79;
    wp::texture3d_t* var_80;
    const wp::int32 var_81 = 0;
    wp::float32 var_82;
    wp::float32 var_83;
    wp::float32 var_84;
    const wp::float32 var_85 = 0.5;
    wp::float32 var_86;
    const wp::int32 var_87 = 1;
    wp::float32 var_88;
    wp::float32 var_89;
    wp::float32 var_90;
    const wp::float32 var_91 = 0.5;
    wp::float32 var_92;
    const wp::int32 var_93 = 2;
    wp::float32 var_94;
    wp::float32 var_95;
    wp::float32 var_96;
    const wp::float32 var_97 = 0.5;
    wp::float32 var_98;
    wp::vec_t<3, wp::float32> var_99;
    wp::float32 var_100;
    const wp::float32 var_101 = -1.0;
    wp::texture3d_t var_102;
    wp::uint32* var_103;
    const wp::int32 var_104 = 1023;
    wp::uint32 var_105;
    wp::uint32 var_106;
    wp::uint32 var_107;
    wp::float32 var_108;
    wp::uint32* var_109;
    const wp::int32 var_110 = 10;
    wp::uint32 var_111;
    wp::uint32 var_112;
    wp::uint32 var_113;
    const wp::int32 var_114 = 1023;
    wp::uint32 var_115;
    wp::uint32 var_116;
    wp::float32 var_117;
    wp::uint32* var_118;
    const wp::int32 var_119 = 20;
    wp::uint32 var_120;
    wp::uint32 var_121;
    wp::uint32 var_122;
    const wp::int32 var_123 = 1023;
    wp::uint32 var_124;
    wp::uint32 var_125;
    wp::float32 var_126;
    wp::int32* var_127;
    wp::float32 var_128;
    wp::int32 var_129;
    wp::int32* var_130;
    wp::float32 var_131;
    wp::int32 var_132;
    wp::float32* var_133;
    wp::float32 var_134;
    wp::float32 var_135;
    wp::float32 var_136;
    wp::int32* var_137;
    wp::float32 var_138;
    wp::int32 var_139;
    wp::int32* var_140;
    wp::float32 var_141;
    wp::int32 var_142;
    wp::float32* var_143;
    wp::float32 var_144;
    wp::float32 var_145;
    wp::float32 var_146;
    wp::int32* var_147;
    wp::float32 var_148;
    wp::int32 var_149;
    wp::int32* var_150;
    wp::float32 var_151;
    wp::int32 var_152;
    wp::float32* var_153;
    wp::float32 var_154;
    wp::float32 var_155;
    wp::float32 var_156;
    wp::float32* var_157;
    wp::float32 var_158;
    wp::float32 var_159;
    wp::float32 var_160;
    const wp::float32 var_161 = 0.5;
    wp::float32 var_162;
    wp::float32* var_163;
    wp::float32 var_164;
    wp::float32 var_165;
    wp::float32 var_166;
    const wp::float32 var_167 = 0.5;
    wp::float32 var_168;
    wp::float32* var_169;
    wp::float32 var_170;
    wp::float32 var_171;
    wp::float32 var_172;
    const wp::float32 var_173 = 0.5;
    wp::float32 var_174;
    wp::texture3d_t* var_175;
    wp::float32* var_176;
    wp::float32 var_177;
    wp::float32 var_178;
    wp::float32* var_179;
    wp::float32 var_180;
    wp::float32 var_181;
    wp::float32* var_182;
    wp::float32 var_183;
    wp::float32 var_184;
    wp::vec_t<3, wp::float32> var_185;
    wp::float32 var_186;
    const wp::float32 var_187 = -1.0;
    wp::texture3d_t var_188;
    wp::float32* var_189;
    wp::float32 var_190;
    wp::float32 var_191;
    wp::float32* var_192;
    wp::float32 var_193;
    wp::float32 var_194;
    wp::float32 var_195;
    wp::float32 var_196;
    //---------
    // forward
    // def texture_sample_sdf_hw(                                                             <L 1077>
    // clamped = wp.vec3(                                                                     <L 1098>
    // wp.clamp(local_pos[0], sdf.sdf_box_lower[0], sdf.sdf_box_upper[0]),                    <L 1099>
    var_1 = wp::extract(var_local_pos, var_0);
    var_2 = &((var_sdf).sdf_box_lower);
    var_5 = wp::load(var_2);
    var_4 = wp::extract(var_5, var_3);
    var_6 = &((var_sdf).sdf_box_upper);
    var_9 = wp::load(var_6);
    var_8 = wp::extract(var_9, var_7);
    var_10 = wp::clamp(var_1, var_4, var_8);
    // wp.clamp(local_pos[1], sdf.sdf_box_lower[1], sdf.sdf_box_upper[1]),                    <L 1100>
    var_12 = wp::extract(var_local_pos, var_11);
    var_13 = &((var_sdf).sdf_box_lower);
    var_16 = wp::load(var_13);
    var_15 = wp::extract(var_16, var_14);
    var_17 = &((var_sdf).sdf_box_upper);
    var_20 = wp::load(var_17);
    var_19 = wp::extract(var_20, var_18);
    var_21 = wp::clamp(var_12, var_15, var_19);
    // wp.clamp(local_pos[2], sdf.sdf_box_lower[2], sdf.sdf_box_upper[2]),                    <L 1101>
    var_23 = wp::extract(var_local_pos, var_22);
    var_24 = &((var_sdf).sdf_box_lower);
    var_27 = wp::load(var_24);
    var_26 = wp::extract(var_27, var_25);
    var_28 = &((var_sdf).sdf_box_upper);
    var_31 = wp::load(var_28);
    var_30 = wp::extract(var_31, var_29);
    var_32 = wp::clamp(var_23, var_26, var_30);
    var_33 = wp::vec_t<3, wp::float32>(var_10, var_21, var_32);
    // diff_mag = wp.length(local_pos - clamped)                                              <L 1103>
    var_34 = wp::sub(var_local_pos, var_33);
    var_35 = wp::length(var_34);
    // f = wp.cw_mul(clamped - sdf.sdf_box_lower, sdf.inv_sdf_dx)                             <L 1105>
    var_36 = &((var_sdf).sdf_box_lower);
    var_38 = wp::load(var_36);
    var_37 = wp::sub(var_33, var_38);
    var_39 = &((var_sdf).inv_sdf_dx);
    var_41 = wp::load(var_39);
    var_40 = wp::cw_mul(var_37, var_41);
    // loc = _locate_cell(sdf, f)                                                             <L 1106>
    var_42 = _locate_cell_0(var_sdf, var_40);
    // sdf_val = float(0.0)                                                                   <L 1108>
    var_44 = wp::float(var_43);
    // if loc.start_slot >= SLOT_LINEAR:                                                      <L 1110>
    var_45 = &((var_42).start_slot);
    var_48 = wp::load(var_45);
    var_47 = (var_48 >= var_46);
    if (var_47) {
        // cx = float(loc.x_base)                                                             <L 1114>
        var_49 = &((var_42).x_base);
        var_51 = wp::load(var_49);
        var_50 = wp::float(var_51);
        // cy = float(loc.y_base)                                                             <L 1115>
        var_52 = &((var_42).y_base);
        var_54 = wp::load(var_52);
        var_53 = wp::float(var_54);
        // cz = float(loc.z_base)                                                             <L 1116>
        var_55 = &((var_42).z_base);
        var_57 = wp::load(var_55);
        var_56 = wp::float(var_57);
        // coarse_f = wp.vec3(float(loc.ix) + loc.tx, float(loc.iy) + loc.ty, float(loc.iz) + loc.tz) * sdf.fine_to_coarse       <L 1117>
        var_58 = &((var_42).ix);
        var_60 = wp::load(var_58);
        var_59 = wp::float(var_60);
        var_61 = &((var_42).tx);
        var_63 = wp::load(var_61);
        var_62 = wp::add(var_59, var_63);
        var_64 = &((var_42).iy);
        var_66 = wp::load(var_64);
        var_65 = wp::float(var_66);
        var_67 = &((var_42).ty);
        var_69 = wp::load(var_67);
        var_68 = wp::add(var_65, var_69);
        var_70 = &((var_42).iz);
        var_72 = wp::load(var_70);
        var_71 = wp::float(var_72);
        var_73 = &((var_42).tz);
        var_75 = wp::load(var_73);
        var_74 = wp::add(var_71, var_75);
        var_76 = wp::vec_t<3, wp::float32>(var_62, var_68, var_74);
        var_77 = &((var_sdf).fine_to_coarse);
        var_79 = wp::load(var_77);
        var_78 = wp::mul(var_76, var_79);
        // sdf_val = wp.texture_sample(                                                       <L 1118>
        // sdf.coarse_texture,                                                                <L 1119>
        var_80 = &((var_sdf).coarse_texture);
        // wp.vec3f(                                                                          <L 1120>
        // cx + (coarse_f[0] - cx) + 0.5,                                                     <L 1121>
        var_82 = wp::extract(var_78, var_81);
        var_83 = wp::sub(var_82, var_50);
        var_84 = wp::add(var_50, var_83);
        var_86 = wp::add(var_84, var_85);
        // cy + (coarse_f[1] - cy) + 0.5,                                                     <L 1122>
        var_88 = wp::extract(var_78, var_87);
        var_89 = wp::sub(var_88, var_53);
        var_90 = wp::add(var_53, var_89);
        var_92 = wp::add(var_90, var_91);
        // cz + (coarse_f[2] - cz) + 0.5,                                                     <L 1123>
        var_94 = wp::extract(var_78, var_93);
        var_95 = wp::sub(var_94, var_56);
        var_96 = wp::add(var_56, var_95);
        var_98 = wp::add(var_96, var_97);
        var_99 = wp::vec_t<3, wp::float32>(var_86, var_92, var_98);
        // dtype=float,                                                                       <L 1125>
        var_102 = wp::load(var_80);
        var_100 = wp::texture_sample<float>(var_102, var_99, var_101);
    }
    if (!var_47) {
        // block_x = float(loc.start_slot & wp.uint32(0x3FF))                                 <L 1128>
        var_103 = &((var_42).start_slot);
        var_105 = wp::uint32(var_104);
        var_107 = wp::load(var_103);
        var_106 = wp::bit_and(var_107, var_105);
        var_108 = wp::float(var_106);
        // block_y = float((loc.start_slot >> wp.uint32(10)) & wp.uint32(0x3FF))              <L 1129>
        var_109 = &((var_42).start_slot);
        var_111 = wp::uint32(var_110);
        var_113 = wp::load(var_109);
        var_112 = wp::rshift(var_113, var_111);
        var_115 = wp::uint32(var_114);
        var_116 = wp::bit_and(var_112, var_115);
        var_117 = wp::float(var_116);
        // block_z = float((loc.start_slot >> wp.uint32(20)) & wp.uint32(0x3FF))              <L 1130>
        var_118 = &((var_42).start_slot);
        var_120 = wp::uint32(var_119);
        var_122 = wp::load(var_118);
        var_121 = wp::rshift(var_122, var_120);
        var_124 = wp::uint32(var_123);
        var_125 = wp::bit_and(var_121, var_124);
        var_126 = wp::float(var_125);
        // lx = float(loc.ix) - float(loc.x_base) * sdf.subgrid_size_f                        <L 1131>
        var_127 = &((var_42).ix);
        var_129 = wp::load(var_127);
        var_128 = wp::float(var_129);
        var_130 = &((var_42).x_base);
        var_132 = wp::load(var_130);
        var_131 = wp::float(var_132);
        var_133 = &((var_sdf).subgrid_size_f);
        var_135 = wp::load(var_133);
        var_134 = wp::mul(var_131, var_135);
        var_136 = wp::sub(var_128, var_134);
        // ly = float(loc.iy) - float(loc.y_base) * sdf.subgrid_size_f                        <L 1132>
        var_137 = &((var_42).iy);
        var_139 = wp::load(var_137);
        var_138 = wp::float(var_139);
        var_140 = &((var_42).y_base);
        var_142 = wp::load(var_140);
        var_141 = wp::float(var_142);
        var_143 = &((var_sdf).subgrid_size_f);
        var_145 = wp::load(var_143);
        var_144 = wp::mul(var_141, var_145);
        var_146 = wp::sub(var_138, var_144);
        // lz = float(loc.iz) - float(loc.z_base) * sdf.subgrid_size_f                        <L 1133>
        var_147 = &((var_42).iz);
        var_149 = wp::load(var_147);
        var_148 = wp::float(var_149);
        var_150 = &((var_42).z_base);
        var_152 = wp::load(var_150);
        var_151 = wp::float(var_152);
        var_153 = &((var_sdf).subgrid_size_f);
        var_155 = wp::load(var_153);
        var_154 = wp::mul(var_151, var_155);
        var_156 = wp::sub(var_148, var_154);
        // ox = block_x * sdf.subgrid_samples_f + lx + 0.5                                    <L 1134>
        var_157 = &((var_sdf).subgrid_samples_f);
        var_159 = wp::load(var_157);
        var_158 = wp::mul(var_108, var_159);
        var_160 = wp::add(var_158, var_136);
        var_162 = wp::add(var_160, var_161);
        // oy = block_y * sdf.subgrid_samples_f + ly + 0.5                                    <L 1135>
        var_163 = &((var_sdf).subgrid_samples_f);
        var_165 = wp::load(var_163);
        var_164 = wp::mul(var_117, var_165);
        var_166 = wp::add(var_164, var_146);
        var_168 = wp::add(var_166, var_167);
        // oz = block_z * sdf.subgrid_samples_f + lz + 0.5                                    <L 1136>
        var_169 = &((var_sdf).subgrid_samples_f);
        var_171 = wp::load(var_169);
        var_170 = wp::mul(var_126, var_171);
        var_172 = wp::add(var_170, var_156);
        var_174 = wp::add(var_172, var_173);
        // raw = wp.texture_sample(                                                           <L 1137>
        // sdf.subgrid_texture,                                                               <L 1138>
        var_175 = &((var_sdf).subgrid_texture);
        // wp.vec3f(ox + loc.tx, oy + loc.ty, oz + loc.tz),                                   <L 1139>
        var_176 = &((var_42).tx);
        var_178 = wp::load(var_176);
        var_177 = wp::add(var_162, var_178);
        var_179 = &((var_42).ty);
        var_181 = wp::load(var_179);
        var_180 = wp::add(var_168, var_181);
        var_182 = &((var_42).tz);
        var_184 = wp::load(var_182);
        var_183 = wp::add(var_174, var_184);
        var_185 = wp::vec_t<3, wp::float32>(var_177, var_180, var_183);
        // dtype=float,                                                                       <L 1140>
        var_188 = wp::load(var_175);
        var_186 = wp::texture_sample<float>(var_188, var_185, var_187);
        // sdf_val = raw * sdf.subgrids_sdf_value_range + sdf.subgrids_min_sdf_value          <L 1142>
        var_189 = &((var_sdf).subgrids_sdf_value_range);
        var_191 = wp::load(var_189);
        var_190 = wp::mul(var_186, var_191);
        var_192 = &((var_sdf).subgrids_min_sdf_value);
        var_194 = wp::load(var_192);
        var_193 = wp::add(var_190, var_194);
    }
    var_195 = wp::where(var_47, var_100, var_193);
    // return sdf_val + diff_mag                                                              <L 1144>
    var_196 = wp::add(var_195, var_35);
    return var_196;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_contact.py:583
static CUDA_CALLABLE wp::float32 _create_sdf_contact_funcs__locals___sample_sdf_at_t_0(
    TextureSDFData_9ae3a59e var_texture_sdf,
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
    const wp::float32 var_3 = 100000000000.0;
    wp::float32 var_4;
    wp::float32 var_5;
    //---------
    // forward
    // def _sample_sdf_at_t(                                                                  <L 584>
    // pp = v0 + edge_dir * tt                                                                <L 597>
    var_0 = wp::mul(var_edge_dir, var_tt);
    var_1 = wp::add(var_v0, var_0);
    // if wp.static(enable_heightfields):                                                     <L 598>
    // if use_bvh_for_sdf:                                                                    <L 606>
    if (var_use_bvh_for_sdf) {
        // return sample_sdf_using_mesh(sdf_mesh_id, pp, _MESH_QUERY_MAX_DIST, sdf_mesh_query_type)       <L 607>
        var_4 = sample_sdf_using_mesh_0(var_sdf_mesh_id, var_1, var_3, var_sdf_mesh_query_type);
        return var_4;
    }
    if (!var_use_bvh_for_sdf) {
        // return texture_sample_sdf(texture_sdf, pp)                                         <L 609>
        var_5 = texture_sample_sdf_hw_0(var_texture_sdf, var_1);
        return var_5;
    }
    return {};
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_contact.py:611
static CUDA_CALLABLE void _create_sdf_contact_funcs__locals__do_edge_sdf_collision_func_0(
    TextureSDFData_9ae3a59e var_texture_sdf,
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
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    const wp::float32 var_0 = 0.3819660112501051;
    wp::vec_t<3, wp::float32> var_1;
    wp::float32 var_2;
    const wp::float32 var_3 = 0.5;
    wp::float32 var_4;
    const wp::float32 var_5 = 1e-12;
    wp::float32 var_6;
    wp::float32 var_7;
    const wp::float32 var_8 = 0.0;
    wp::float32 var_9;
    const wp::float32 var_10 = 1.0;
    wp::float32 var_11;
    const wp::float32 var_12 = 0.5;
    wp::float32 var_13;
    const wp::float32 var_14 = 0.5;
    wp::float32 var_15;
    const wp::float32 var_16 = 0.5;
    wp::float32 var_17;
    wp::float32 var_18;
    wp::float32 var_19;
    wp::float32 var_20;
    const wp::float32 var_21 = 0.0;
    wp::float32 var_22;
    const wp::float32 var_23 = 0.0;
    wp::float32 var_24;
    const wp::int32 var_25 = 5;
    wp::range_t var_26;
    wp::int32 var_27;
    const wp::float32 var_28 = 0.5;
    wp::float32 var_29;
    wp::float32 var_30;
    const wp::float32 var_31 = 0.01;
    wp::float32 var_32;
    wp::float32 var_33;
    const wp::float32 var_34 = 1e-08;
    wp::float32 var_35;
    wp::float32 var_36;
    const wp::float32 var_37 = 2.0;
    wp::float32 var_38;
    wp::float32 var_39;
    wp::float32 var_40;
    const wp::float32 var_41 = 0.5;
    wp::float32 var_42;
    wp::float32 var_43;
    wp::float32 var_44;
    bool var_45;
    const bool var_46 = false;
    const wp::float32 var_47 = 0.0;
    wp::float32 var_48;
    const wp::float32 var_49 = 0.0;
    wp::float32 var_50;
    wp::float32 var_51;
    bool var_52;
    wp::float32 var_53;
    wp::float32 var_54;
    wp::float32 var_55;
    wp::float32 var_56;
    wp::float32 var_57;
    wp::float32 var_58;
    wp::float32 var_59;
    wp::float32 var_60;
    wp::float32 var_61;
    wp::float32 var_62;
    wp::float32 var_63;
    const wp::float32 var_64 = 2.0;
    wp::float32 var_65;
    wp::float32 var_66;
    const wp::float32 var_67 = 0.0;
    bool var_68;
    wp::float32 var_69;
    wp::float32 var_70;
    wp::float32 var_71;
    wp::float32 var_72;
    wp::float32 var_73;
    const wp::float32 var_74 = 0.5;
    wp::float32 var_75;
    wp::float32 var_76;
    wp::float32 var_77;
    bool var_78;
    wp::float32 var_79;
    wp::float32 var_80;
    bool var_81;
    wp::float32 var_82;
    bool var_83;
    wp::float32 var_84;
    bool var_85;
    const bool var_86 = true;
    bool var_87;
    bool var_88;
    bool var_89;
    wp::float32 var_90;
    wp::float32 var_91;
    wp::float32 var_92;
    wp::float32 var_93;
    bool var_94;
    wp::float32 var_95;
    wp::float32 var_96;
    wp::float32 var_97;
    wp::float32 var_98;
    wp::float32 var_99;
    wp::float32 var_100;
    wp::float32 var_101;
    bool var_102;
    wp::float32 var_103;
    const wp::float32 var_104 = 0.0;
    bool var_105;
    wp::float32 var_106;
    wp::float32 var_107;
    wp::float32 var_108;
    wp::float32 var_109;
    wp::float32 var_110;
    bool var_111;
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
    bool var_123;
    wp::float32 var_124;
    wp::float32 var_125;
    wp::float32 var_126;
    wp::float32 var_127;
    bool var_128;
    bool var_129;
    bool var_130;
    wp::float32 var_131;
    wp::float32 var_132;
    wp::float32 var_133;
    wp::float32 var_134;
    bool var_135;
    bool var_136;
    bool var_137;
    bool var_138;
    wp::float32 var_139;
    wp::float32 var_140;
    wp::float32 var_141;
    wp::float32 var_142;
    wp::float32 var_143;
    wp::float32 var_144;
    wp::float32 var_145;
    wp::float32 var_146;
    wp::float32 var_147;
    wp::float32 var_148;
    wp::float32 var_149;
    wp::float32 var_150;
    wp::float32 var_151;
    wp::float32 var_152;
    wp::float32 var_153;
    wp::float32 var_154;
    wp::float32 var_155;
    wp::float32 var_156;
    const wp::float32 var_157 = 0.0;
    bool var_158;
    const wp::float32 var_159 = 0.0;
    wp::float32 var_160;
    bool var_161;
    const wp::float32 var_162 = 0.0;
    wp::float32 var_163;
    wp::float32 var_164;
    wp::float32 var_165;
    wp::float32 var_166;
    wp::float32 var_167;
    const wp::float32 var_168 = 1.0;
    bool var_169;
    const wp::float32 var_170 = 1.0;
    wp::float32 var_171;
    bool var_172;
    const wp::float32 var_173 = 1.0;
    wp::float32 var_174;
    wp::float32 var_175;
    wp::float32 var_176;
    wp::float32 var_177;
    wp::float32 var_178;
    wp::float32 var_179;
    wp::vec_t<3, wp::float32> var_180;
    wp::vec_t<3, wp::float32> var_181;
    //---------
    // forward
    // def do_edge_sdf_collision_func(                                                        <L 612>
    // golden = 0.3819660112501051  # (3 - sqrt(5)) / 2                                       <L 646>
    // edge_dir = v1 - v0                                                                     <L 647>
    var_1 = wp::sub(var_v1, var_v0);
    // edge_length = wp.length(edge_dir)                                                      <L 648>
    var_2 = wp::length(var_1);
    // tol_floor = 0.5 * precision_target / (edge_length + 1.0e-12)                           <L 654>
    var_4 = wp::mul(var_3, var_precision_target);
    var_6 = wp::add(var_2, var_5);
    var_7 = wp::div(var_4, var_6);
    // a = float(0.0)                                                                         <L 657>
    var_9 = wp::float(var_8);
    // b = float(1.0)                                                                         <L 658>
    var_11 = wp::float(var_10);
    // x = float(0.5)                                                                         <L 659>
    var_13 = wp::float(var_12);
    // w = float(0.5)                                                                         <L 660>
    var_15 = wp::float(var_14);
    // v_brent = float(0.5)                                                                   <L 661>
    var_17 = wp::float(var_16);
    // fx = midpoint_sdf                                                                      <L 662>
    var_18 = wp::copy(var_midpoint_sdf);
    // fw = fx                                                                                <L 663>
    var_19 = wp::copy(var_18);
    // fv = fx                                                                                <L 664>
    var_20 = wp::copy(var_18);
    // d_step = float(0.0)                                                                    <L 665>
    var_22 = wp::float(var_21);
    // e_step = float(0.0)                                                                    <L 666>
    var_24 = wp::float(var_23);
    // for _iter in range(5):                                                                 <L 668>
    var_26 = wp::range(var_25);
    start_for_0:;
        if (iter_cmp(var_26) == 0) goto end_for_0;
        var_27 = wp::iter_next(var_26);
        // m = 0.5 * (a + b)                                                                  <L 669>
        var_29 = wp::add(var_9, var_11);
        var_30 = wp::mul(var_28, var_29);
        // tol = wp.max(1.0e-2 * wp.abs(x) + 1.0e-8, tol_floor)                               <L 670>
        var_32 = wp::abs(var_13);
        var_33 = wp::mul(var_31, var_32);
        var_35 = wp::add(var_33, var_34);
        var_36 = wp::max(var_35, var_7);
        // tol2 = 2.0 * tol                                                                   <L 671>
        var_38 = wp::mul(var_37, var_36);
        // if wp.abs(x - m) <= tol2 - 0.5 * (b - a):                                          <L 673>
        var_39 = wp::sub(var_13, var_30);
        var_40 = wp::abs(var_39);
        var_42 = wp::sub(var_11, var_9);
        var_43 = wp::mul(var_41, var_42);
        var_44 = wp::sub(var_38, var_43);
        var_45 = (var_40 <= var_44);
        if (var_45) {
            // break                                                                          <L 674>
            goto end_for_0;
        }
        // use_parabolic = False                                                              <L 677>
        // p_num = float(0.0)                                                                 <L 678>
        var_48 = wp::float(var_47);
        // q_denom = float(0.0)                                                               <L 679>
        var_50 = wp::float(var_49);
        // if wp.abs(e_step) > tol:                                                           <L 681>
        var_51 = wp::abs(var_24);
        var_52 = (var_51 > var_36);
        if (var_52) {
            // r = (x - w) * (fx - fv)                                                        <L 682>
            var_53 = wp::sub(var_13, var_15);
            var_54 = wp::sub(var_18, var_20);
            var_55 = wp::mul(var_53, var_54);
            // q_denom = (x - v_brent) * (fx - fw)                                            <L 683>
            var_56 = wp::sub(var_13, var_17);
            var_57 = wp::sub(var_18, var_19);
            var_58 = wp::mul(var_56, var_57);
            // p_num = (x - v_brent) * q_denom - (x - w) * r                                  <L 684>
            var_59 = wp::sub(var_13, var_17);
            var_60 = wp::mul(var_59, var_58);
            var_61 = wp::sub(var_13, var_15);
            var_62 = wp::mul(var_61, var_55);
            var_63 = wp::sub(var_60, var_62);
            // q_denom = 2.0 * (q_denom - r)                                                  <L 685>
            var_65 = wp::sub(var_58, var_55);
            var_66 = wp::mul(var_64, var_65);
            // if q_denom > 0.0:                                                              <L 686>
            var_68 = (var_66 > var_67);
            if (var_68) {
                // p_num = -p_num                                                             <L 687>
                var_69 = wp::neg(var_63);
            }
            if (!var_68) {
                // q_denom = -q_denom                                                         <L 689>
                var_70 = wp::neg(var_66);
            }
            var_71 = wp::where(var_68, var_69, var_63);
            var_72 = wp::where(var_68, var_66, var_70);
            // if wp.abs(p_num) < 0.5 * wp.abs(q_denom * e_step):                             <L 692>
            var_73 = wp::abs(var_71);
            var_75 = wp::mul(var_72, var_24);
            var_76 = wp::abs(var_75);
            var_77 = wp::mul(var_74, var_76);
            var_78 = (var_73 < var_77);
            if (var_78) {
                // trial = p_num / q_denom                                                    <L 693>
                var_79 = wp::div(var_71, var_72);
                // u_trial = x + trial                                                        <L 694>
                var_80 = wp::add(var_13, var_79);
                // if u_trial - a >= tol2 and b - u_trial >= tol2:                            <L 695>
                var_82 = wp::sub(var_80, var_9);
                var_83 = (var_82 >= var_38);
                var_81 = var_83;
                if (var_81) {
                    var_84 = wp::sub(var_11, var_80);
                    var_85 = (var_84 >= var_38);
                    var_81 = var_81 && var_85;
                }
                if (var_81) {
                    // use_parabolic = True                                                   <L 696>
                }
                var_87 = wp::where(var_81, var_86, var_46);
            }
            var_88 = wp::where(var_78, var_87, var_46);
        }
        var_89 = wp::where(var_52, var_88, var_46);
        var_90 = wp::where(var_52, var_71, var_48);
        var_91 = wp::where(var_52, var_72, var_50);
        // if use_parabolic:                                                                  <L 698>
        if (var_89) {
            // e_step = d_step                                                                <L 699>
            var_92 = wp::copy(var_22);
            // d_step = p_num / q_denom                                                       <L 700>
            var_93 = wp::div(var_90, var_91);
        }
        if (!var_89) {
            // if x >= m:                                                                     <L 703>
            var_94 = (var_13 >= var_30);
            if (var_94) {
                // e_step = a - x                                                             <L 704>
                var_95 = wp::sub(var_9, var_13);
            }
            if (!var_94) {
                // e_step = b - x                                                             <L 706>
                var_96 = wp::sub(var_11, var_13);
            }
            var_97 = wp::where(var_94, var_95, var_96);
            // d_step = golden * e_step                                                       <L 707>
            var_98 = wp::mul(var_0, var_97);
        }
        var_99 = wp::where(var_89, var_93, var_98);
        var_100 = wp::where(var_89, var_92, var_97);
        // if wp.abs(d_step) >= tol:                                                          <L 710>
        var_101 = wp::abs(var_99);
        var_102 = (var_101 >= var_36);
        if (var_102) {
            // u = x + d_step                                                                 <L 711>
            var_103 = wp::add(var_13, var_99);
        }
        if (!var_102) {
            // if d_step > 0.0:                                                               <L 713>
            var_105 = (var_99 > var_104);
            if (var_105) {
                // u = x + tol                                                                <L 714>
                var_106 = wp::add(var_13, var_36);
            }
            if (!var_105) {
                // u = x - tol                                                                <L 716>
                var_107 = wp::sub(var_13, var_36);
            }
            var_108 = wp::where(var_105, var_106, var_107);
        }
        var_109 = wp::where(var_102, var_103, var_108);
        // fu = _sample_sdf_at_t(                                                             <L 718>
        // texture_sdf,                                                                       <L 719>
        // sdf_mesh_id,                                                                       <L 720>
        // v0,                                                                                <L 721>
        // edge_dir,                                                                          <L 722>
        // u,                                                                                 <L 723>
        // use_bvh_for_sdf,                                                                   <L 724>
        // sdf_mesh_query_type,                                                               <L 725>
        // sdf_is_heightfield,                                                                <L 726>
        // hfd_sdf,                                                                           <L 727>
        // elevation_data,                                                                    <L 728>
        var_110 = _create_sdf_contact_funcs__locals___sample_sdf_at_t_0(var_texture_sdf, var_sdf_mesh_id, var_v0, var_1, var_109, var_use_bvh_for_sdf, var_sdf_mesh_query_type, var_sdf_is_heightfield, var_hfd_sdf, var_elevation_data);
        // if fu <= fx:                                                                       <L 732>
        var_111 = (var_110 <= var_18);
        if (var_111) {
            // if u < x:                                                                      <L 733>
            var_112 = (var_109 < var_13);
            if (var_112) {
                // b = x                                                                      <L 734>
                var_113 = wp::copy(var_13);
            }
            if (!var_112) {
                // a = x                                                                      <L 736>
                var_114 = wp::copy(var_13);
            }
            var_115 = wp::where(var_112, var_9, var_114);
            var_116 = wp::where(var_112, var_113, var_11);
            // v_brent = w                                                                    <L 737>
            var_117 = wp::copy(var_15);
            // fv = fw                                                                        <L 738>
            var_118 = wp::copy(var_19);
            // w = x                                                                          <L 739>
            var_119 = wp::copy(var_13);
            // fw = fx                                                                        <L 740>
            var_120 = wp::copy(var_18);
            // x = u                                                                          <L 741>
            var_121 = wp::copy(var_109);
            // fx = fu                                                                        <L 742>
            var_122 = wp::copy(var_110);
        }
        if (!var_111) {
            // if u < x:                                                                      <L 744>
            var_123 = (var_109 < var_13);
            if (var_123) {
                // a = u                                                                      <L 745>
                var_124 = wp::copy(var_109);
            }
            if (!var_123) {
                // b = u                                                                      <L 747>
                var_125 = wp::copy(var_109);
            }
            var_126 = wp::where(var_123, var_124, var_9);
            var_127 = wp::where(var_123, var_11, var_125);
            // if fu <= fw or w == x:                                                         <L 748>
            var_129 = (var_110 <= var_19);
            var_128 = var_129;
            if (!var_128) {
                var_130 = (var_15 == var_13);
                var_128 = var_128 || var_130;
            }
            if (var_128) {
                // v_brent = w                                                                <L 749>
                var_131 = wp::copy(var_15);
                // fv = fw                                                                    <L 750>
                var_132 = wp::copy(var_19);
                // w = u                                                                      <L 751>
                var_133 = wp::copy(var_109);
                // fw = fu                                                                    <L 752>
                var_134 = wp::copy(var_110);
            }
            if (!var_128) {
                // elif fu <= fv or v_brent == x or v_brent == w:                             <L 753>
                var_136 = (var_110 <= var_20);
                var_135 = var_136;
                if (!var_135) {
                    var_137 = (var_17 == var_13);
                    var_135 = var_135 || var_137;
                }
                if (!var_135) {
                    var_138 = (var_17 == var_15);
                    var_135 = var_135 || var_138;
                }
                if (var_135) {
                    // v_brent = u                                                            <L 754>
                    var_139 = wp::copy(var_109);
                    // fv = fu                                                                <L 755>
                    var_140 = wp::copy(var_110);
                }
                var_141 = wp::where(var_135, var_139, var_17);
                var_142 = wp::where(var_135, var_140, var_20);
            }
            var_143 = wp::where(var_128, var_133, var_15);
            var_144 = wp::where(var_128, var_131, var_141);
            var_145 = wp::where(var_128, var_134, var_19);
            var_146 = wp::where(var_128, var_132, var_142);
        }
        var_147 = wp::where(var_111, var_115, var_126);
        var_148 = wp::where(var_111, var_116, var_127);
        var_149 = wp::where(var_111, var_121, var_13);
        var_150 = wp::where(var_111, var_119, var_143);
        var_151 = wp::where(var_111, var_117, var_144);
        var_152 = wp::where(var_111, var_122, var_18);
        var_153 = wp::where(var_111, var_120, var_145);
        var_154 = wp::where(var_111, var_118, var_146);
        wp::assign(var_9, var_147);
        wp::assign(var_11, var_148);
        wp::assign(var_13, var_149);
        wp::assign(var_15, var_150);
        wp::assign(var_17, var_151);
        wp::assign(var_18, var_152);
        wp::assign(var_19, var_153);
        wp::assign(var_20, var_154);
        wp::assign(var_22, var_99);
        wp::assign(var_24, var_100);
        goto start_for_0;
    end_for_0:;
    // best_t = x                                                                             <L 760>
    var_155 = wp::copy(var_13);
    // best_f = fx                                                                            <L 761>
    var_156 = wp::copy(var_18);
    // if a == 0.0:                                                                           <L 762>
    var_158 = (var_9 == var_157);
    if (var_158) {
        // f_end = _sample_sdf_at_t(                                                          <L 763>
        // texture_sdf,                                                                       <L 764>
        // sdf_mesh_id,                                                                       <L 765>
        // v0,                                                                                <L 766>
        // edge_dir,                                                                          <L 767>
        // 0.0,                                                                               <L 768>
        // use_bvh_for_sdf,                                                                   <L 769>
        // sdf_mesh_query_type,                                                               <L 770>
        // sdf_is_heightfield,                                                                <L 771>
        // hfd_sdf,                                                                           <L 772>
        // elevation_data,                                                                    <L 773>
        var_160 = _create_sdf_contact_funcs__locals___sample_sdf_at_t_0(var_texture_sdf, var_sdf_mesh_id, var_v0, var_1, var_159, var_use_bvh_for_sdf, var_sdf_mesh_query_type, var_sdf_is_heightfield, var_hfd_sdf, var_elevation_data);
        // if f_end < best_f:                                                                 <L 775>
        var_161 = (var_160 < var_156);
        if (var_161) {
            // best_t = 0.0                                                                   <L 776>
            // best_f = f_end                                                                 <L 777>
            var_163 = wp::copy(var_160);
        }
        var_164 = wp::where(var_161, var_162, var_155);
        var_165 = wp::where(var_161, var_163, var_156);
    }
    var_166 = wp::where(var_158, var_164, var_155);
    var_167 = wp::where(var_158, var_165, var_156);
    // if b == 1.0:                                                                           <L 778>
    var_169 = (var_11 == var_168);
    if (var_169) {
        // f_end = _sample_sdf_at_t(                                                          <L 779>
        // texture_sdf,                                                                       <L 780>
        // sdf_mesh_id,                                                                       <L 781>
        // v0,                                                                                <L 782>
        // edge_dir,                                                                          <L 783>
        // 1.0,                                                                               <L 784>
        // use_bvh_for_sdf,                                                                   <L 785>
        // sdf_mesh_query_type,                                                               <L 786>
        // sdf_is_heightfield,                                                                <L 787>
        // hfd_sdf,                                                                           <L 788>
        // elevation_data,                                                                    <L 789>
        var_171 = _create_sdf_contact_funcs__locals___sample_sdf_at_t_0(var_texture_sdf, var_sdf_mesh_id, var_v0, var_1, var_170, var_use_bvh_for_sdf, var_sdf_mesh_query_type, var_sdf_is_heightfield, var_hfd_sdf, var_elevation_data);
        // if f_end < best_f:                                                                 <L 791>
        var_172 = (var_171 < var_167);
        if (var_172) {
            // best_t = 1.0                                                                   <L 792>
            // best_f = f_end                                                                 <L 793>
            var_174 = wp::copy(var_171);
        }
        var_175 = wp::where(var_172, var_173, var_166);
        var_176 = wp::where(var_172, var_174, var_167);
    }
    var_177 = wp::where(var_169, var_175, var_166);
    var_178 = wp::where(var_169, var_176, var_167);
    var_179 = wp::where(var_169, var_171, var_160);
    // p = v0 + edge_dir * best_t                                                             <L 795>
    var_180 = wp::mul(var_1, var_177);
    var_181 = wp::add(var_v0, var_180);
    // return best_f, p                                                                       <L 797>
    ret_0 = var_178;
    ret_1 = var_181;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_contact.py:81
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
    // def mesh_sdf_contact_passes_inner_cull_consistency(                                    <L 82>
    // if distance_world >= inner_contact_threshold:                                          <L 94>
    var_0 = (var_distance_world >= var_inner_contact_threshold);
    if (var_0) {
        // return True                                                                        <L 95>
        return var_1;
    }
    // inner_threshold_unscaled = inner_contact_threshold / min_sdf_scale                     <L 97>
    var_2 = wp::div(var_inner_contact_threshold, var_min_sdf_scale);
    // culling_radius = bsphere_radius + inner_threshold_unscaled                             <L 98>
    var_3 = wp::add(var_bsphere_radius, var_2);
    // if use_texture_bounds:                                                                 <L 99>
    if (var_use_texture_bounds) {
        // clamped = wp.min(wp.max(bsphere_center, sdf_aabb_lower), sdf_aabb_upper)           <L 100>
        var_4 = wp::max(var_bsphere_center, var_sdf_aabb_lower);
        var_5 = wp::min(var_4, var_sdf_aabb_upper);
        // if wp.length_sq(bsphere_center - clamped) > culling_radius * culling_radius:       <L 101>
        var_6 = wp::sub(var_bsphere_center, var_5);
        var_7 = wp::length_sq(var_6);
        var_8 = wp::mul(var_3, var_3);
        var_9 = (var_7 > var_8);
        if (var_9) {
            // return False                                                                   <L 102>
            return var_10;
        }
    }
    // return midpoint_sdf <= culling_radius                                                  <L 104>
    var_11 = (var_midpoint_sdf <= var_3);
    return var_11;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_contact.py:208
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
    // def sample_sdf_grad_using_mesh(                                                        <L 209>
    // gradient = wp.vec3(0.0, 0.0, 0.0)                                                      <L 236>
    var_3 = wp::vec_t<3, wp::float32>(var_0, var_1, var_2);
    // res = mesh_query_point_sign(mesh_id, world_pos, max_dist, sign_method)                 <L 238>
    var_4 = mesh_query_point_sign_0(var_mesh_id, var_world_pos, var_max_dist, var_sign_method);
    // if res.result:                                                                         <L 240>
    var_5 = &((var_4).result);
    var_6 = wp::load(var_5);
    if (var_6) {
        // closest = wp.mesh_eval_position(mesh_id, res.face, res.u, res.v)                   <L 241>
        var_7 = &((var_4).face);
        var_8 = &((var_4).u);
        var_9 = &((var_4).v);
        var_11 = wp::load(var_7);
        var_12 = wp::load(var_8);
        var_13 = wp::load(var_9);
        var_10 = wp::mesh_eval_position(var_mesh_id, var_11, var_12, var_13);
        // diff = world_pos - closest                                                         <L 242>
        var_14 = wp::sub(var_world_pos, var_10);
        // dist = wp.length(diff)                                                             <L 243>
        var_15 = wp::length(var_14);
        // if dist > 0.0:                                                                     <L 245>
        var_17 = (var_15 > var_16);
        if (var_17) {
            // gradient = (diff / dist) * res.sign                                            <L 249>
            var_18 = wp::div(var_14, var_15);
            var_19 = &((var_4).sign);
            var_21 = wp::load(var_19);
            var_20 = wp::mul(var_18, var_21);
        }
        if (!var_17) {
            // mesh = wp.mesh_get(mesh_id)                                                    <L 252>
            var_22 = wp::mesh_get(var_mesh_id);
            // i0 = mesh.indices[res.face * 3 + 0]                                            <L 253>
            var_23 = &((var_22).indices);
            var_24 = &((var_4).face);
            var_27 = wp::load(var_24);
            var_26 = wp::mul(var_27, var_25);
            var_29 = wp::add(var_26, var_28);
            var_31 = wp::load(var_23);
            var_30 = wp::address(var_31, var_29);
            var_33 = wp::load(var_30);
            var_32 = wp::copy(var_33);
            // i1 = mesh.indices[res.face * 3 + 1]                                            <L 254>
            var_34 = &((var_22).indices);
            var_35 = &((var_4).face);
            var_38 = wp::load(var_35);
            var_37 = wp::mul(var_38, var_36);
            var_40 = wp::add(var_37, var_39);
            var_42 = wp::load(var_34);
            var_41 = wp::address(var_42, var_40);
            var_44 = wp::load(var_41);
            var_43 = wp::copy(var_44);
            // i2 = mesh.indices[res.face * 3 + 2]                                            <L 255>
            var_45 = &((var_22).indices);
            var_46 = &((var_4).face);
            var_49 = wp::load(var_46);
            var_48 = wp::mul(var_49, var_47);
            var_51 = wp::add(var_48, var_50);
            var_53 = wp::load(var_45);
            var_52 = wp::address(var_53, var_51);
            var_55 = wp::load(var_52);
            var_54 = wp::copy(var_55);
            // v0 = mesh.points[i0]                                                           <L 256>
            var_56 = &((var_22).points);
            var_58 = wp::load(var_56);
            var_57 = wp::address(var_58, var_32);
            var_60 = wp::load(var_57);
            var_59 = wp::copy(var_60);
            // v1 = mesh.points[i1]                                                           <L 257>
            var_61 = &((var_22).points);
            var_63 = wp::load(var_61);
            var_62 = wp::address(var_63, var_43);
            var_65 = wp::load(var_62);
            var_64 = wp::copy(var_65);
            // v2 = mesh.points[i2]                                                           <L 258>
            var_66 = &((var_22).points);
            var_68 = wp::load(var_66);
            var_67 = wp::address(var_68, var_54);
            var_70 = wp::load(var_67);
            var_69 = wp::copy(var_70);
            // face_normal = wp.normalize(wp.cross(v1 - v0, v2 - v0))                         <L 259>
            var_71 = wp::sub(var_64, var_59);
            var_72 = wp::sub(var_69, var_59);
            var_73 = wp::cross(var_71, var_72);
            var_74 = wp::normalize(var_73);
            // gradient = face_normal * res.sign                                              <L 260>
            var_75 = &((var_4).sign);
            var_77 = wp::load(var_75);
            var_76 = wp::mul(var_74, var_77);
        }
        var_78 = wp::where(var_17, var_20, var_76);
        // return dist * res.sign, gradient                                                   <L 262>
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
    // return max_dist, wp.vec3(0.0, 0.0, 1.0)                                                <L 265>
    var_88 = wp::vec_t<3, wp::float32>(var_85, var_86, var_87);
    ret_0 = var_max_dist;
    ret_1 = var_88;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_texture.py:1206
static CUDA_CALLABLE wp::vec_t<3, wp::float32> _texture_sample_sdf_grad_hw_impl_0(
    TextureSDFData_9ae3a59e var_sdf,
    wp::vec_t<3, wp::float32> var_local_pos)
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
    wp::float32 var_35;
    const wp::float32 var_36 = 0.0;
    bool var_37;
    wp::vec_t<3, wp::float32> var_38;
    const wp::float32 var_39 = 0.5;
    wp::vec_t<3, wp::float32>* var_40;
    const wp::int32 var_41 = 0;
    wp::float32 var_42;
    wp::vec_t<3, wp::float32> var_43;
    wp::float32 var_44;
    const wp::float32 var_45 = 0.5;
    wp::vec_t<3, wp::float32>* var_46;
    const wp::int32 var_47 = 1;
    wp::float32 var_48;
    wp::vec_t<3, wp::float32> var_49;
    wp::float32 var_50;
    const wp::float32 var_51 = 0.5;
    wp::vec_t<3, wp::float32>* var_52;
    const wp::int32 var_53 = 2;
    wp::float32 var_54;
    wp::vec_t<3, wp::float32> var_55;
    wp::float32 var_56;
    const wp::float32 var_57 = 0.0;
    const wp::float32 var_58 = 0.0;
    wp::vec_t<3, wp::float32> var_59;
    wp::vec_t<3, wp::float32> var_60;
    wp::float32 var_61;
    const wp::float32 var_62 = 0.0;
    const wp::float32 var_63 = 0.0;
    wp::vec_t<3, wp::float32> var_64;
    wp::vec_t<3, wp::float32> var_65;
    wp::float32 var_66;
    wp::float32 var_67;
    const wp::float32 var_68 = 2.0;
    wp::float32 var_69;
    wp::float32 var_70;
    const wp::float32 var_71 = 0.0;
    const wp::float32 var_72 = 0.0;
    wp::vec_t<3, wp::float32> var_73;
    wp::vec_t<3, wp::float32> var_74;
    wp::float32 var_75;
    const wp::float32 var_76 = 0.0;
    const wp::float32 var_77 = 0.0;
    wp::vec_t<3, wp::float32> var_78;
    wp::vec_t<3, wp::float32> var_79;
    wp::float32 var_80;
    wp::float32 var_81;
    const wp::float32 var_82 = 2.0;
    wp::float32 var_83;
    wp::float32 var_84;
    const wp::float32 var_85 = 0.0;
    const wp::float32 var_86 = 0.0;
    wp::vec_t<3, wp::float32> var_87;
    wp::vec_t<3, wp::float32> var_88;
    wp::float32 var_89;
    const wp::float32 var_90 = 0.0;
    const wp::float32 var_91 = 0.0;
    wp::vec_t<3, wp::float32> var_92;
    wp::vec_t<3, wp::float32> var_93;
    wp::float32 var_94;
    wp::float32 var_95;
    const wp::float32 var_96 = 2.0;
    wp::float32 var_97;
    wp::float32 var_98;
    wp::vec_t<3, wp::float32> var_99;
    //---------
    // forward
    // def _texture_sample_sdf_grad_hw_impl(                                                  <L 1207>
    // clamped = wp.vec3(                                                                     <L 1221>
    // wp.clamp(local_pos[0], sdf.sdf_box_lower[0], sdf.sdf_box_upper[0]),                    <L 1222>
    var_1 = wp::extract(var_local_pos, var_0);
    var_2 = &((var_sdf).sdf_box_lower);
    var_5 = wp::load(var_2);
    var_4 = wp::extract(var_5, var_3);
    var_6 = &((var_sdf).sdf_box_upper);
    var_9 = wp::load(var_6);
    var_8 = wp::extract(var_9, var_7);
    var_10 = wp::clamp(var_1, var_4, var_8);
    // wp.clamp(local_pos[1], sdf.sdf_box_lower[1], sdf.sdf_box_upper[1]),                    <L 1223>
    var_12 = wp::extract(var_local_pos, var_11);
    var_13 = &((var_sdf).sdf_box_lower);
    var_16 = wp::load(var_13);
    var_15 = wp::extract(var_16, var_14);
    var_17 = &((var_sdf).sdf_box_upper);
    var_20 = wp::load(var_17);
    var_19 = wp::extract(var_20, var_18);
    var_21 = wp::clamp(var_12, var_15, var_19);
    // wp.clamp(local_pos[2], sdf.sdf_box_lower[2], sdf.sdf_box_upper[2]),                    <L 1224>
    var_23 = wp::extract(var_local_pos, var_22);
    var_24 = &((var_sdf).sdf_box_lower);
    var_27 = wp::load(var_24);
    var_26 = wp::extract(var_27, var_25);
    var_28 = &((var_sdf).sdf_box_upper);
    var_31 = wp::load(var_28);
    var_30 = wp::extract(var_31, var_29);
    var_32 = wp::clamp(var_23, var_26, var_30);
    var_33 = wp::vec_t<3, wp::float32>(var_10, var_21, var_32);
    // diff = local_pos - clamped                                                             <L 1226>
    var_34 = wp::sub(var_local_pos, var_33);
    // diff_mag = wp.length(diff)                                                             <L 1227>
    var_35 = wp::length(var_34);
    // if diff_mag > 0.0:                                                                     <L 1231>
    var_37 = (var_35 > var_36);
    if (var_37) {
        // return diff / diff_mag                                                             <L 1232>
        var_38 = wp::div(var_34, var_35);
        return var_38;
    }
    // h_x = 0.5 / sdf.inv_sdf_dx[0]                                                          <L 1234>
    var_40 = &((var_sdf).inv_sdf_dx);
    var_43 = wp::load(var_40);
    var_42 = wp::extract(var_43, var_41);
    var_44 = wp::div(var_39, var_42);
    // h_y = 0.5 / sdf.inv_sdf_dx[1]                                                          <L 1235>
    var_46 = &((var_sdf).inv_sdf_dx);
    var_49 = wp::load(var_46);
    var_48 = wp::extract(var_49, var_47);
    var_50 = wp::div(var_45, var_48);
    // h_z = 0.5 / sdf.inv_sdf_dx[2]                                                          <L 1236>
    var_52 = &((var_sdf).inv_sdf_dx);
    var_55 = wp::load(var_52);
    var_54 = wp::extract(var_55, var_53);
    var_56 = wp::div(var_51, var_54);
    // gx = (                                                                                 <L 1237>
    // texture_sample_sdf_hw(sdf, local_pos + wp.vec3(h_x, 0.0, 0.0))                         <L 1238>
    var_59 = wp::vec_t<3, wp::float32>(var_44, var_57, var_58);
    var_60 = wp::add(var_local_pos, var_59);
    var_61 = texture_sample_sdf_hw_0(var_sdf, var_60);
    // - texture_sample_sdf_hw(sdf, local_pos - wp.vec3(h_x, 0.0, 0.0))                       <L 1239>
    var_64 = wp::vec_t<3, wp::float32>(var_44, var_62, var_63);
    var_65 = wp::sub(var_local_pos, var_64);
    var_66 = texture_sample_sdf_hw_0(var_sdf, var_65);
    var_67 = wp::sub(var_61, var_66);
    // ) / (2.0 * h_x)                                                                        <L 1240>
    var_69 = wp::mul(var_68, var_44);
    var_70 = wp::div(var_67, var_69);
    // gy = (                                                                                 <L 1241>
    // texture_sample_sdf_hw(sdf, local_pos + wp.vec3(0.0, h_y, 0.0))                         <L 1242>
    var_73 = wp::vec_t<3, wp::float32>(var_71, var_50, var_72);
    var_74 = wp::add(var_local_pos, var_73);
    var_75 = texture_sample_sdf_hw_0(var_sdf, var_74);
    // - texture_sample_sdf_hw(sdf, local_pos - wp.vec3(0.0, h_y, 0.0))                       <L 1243>
    var_78 = wp::vec_t<3, wp::float32>(var_76, var_50, var_77);
    var_79 = wp::sub(var_local_pos, var_78);
    var_80 = texture_sample_sdf_hw_0(var_sdf, var_79);
    var_81 = wp::sub(var_75, var_80);
    // ) / (2.0 * h_y)                                                                        <L 1244>
    var_83 = wp::mul(var_82, var_50);
    var_84 = wp::div(var_81, var_83);
    // gz = (                                                                                 <L 1245>
    // texture_sample_sdf_hw(sdf, local_pos + wp.vec3(0.0, 0.0, h_z))                         <L 1246>
    var_87 = wp::vec_t<3, wp::float32>(var_85, var_86, var_56);
    var_88 = wp::add(var_local_pos, var_87);
    var_89 = texture_sample_sdf_hw_0(var_sdf, var_88);
    // - texture_sample_sdf_hw(sdf, local_pos - wp.vec3(0.0, 0.0, h_z))                       <L 1247>
    var_92 = wp::vec_t<3, wp::float32>(var_90, var_91, var_56);
    var_93 = wp::sub(var_local_pos, var_92);
    var_94 = texture_sample_sdf_hw_0(var_sdf, var_93);
    var_95 = wp::sub(var_89, var_94);
    // ) / (2.0 * h_z)                                                                        <L 1248>
    var_97 = wp::mul(var_96, var_56);
    var_98 = wp::div(var_95, var_97);
    // return wp.vec3(gx, gy, gz)                                                             <L 1249>
    var_99 = wp::vec_t<3, wp::float32>(var_70, var_84, var_98);
    return var_99;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_texture.py:1279
static CUDA_CALLABLE wp::vec_t<3, wp::float32> texture_sample_sdf_grad_only_hw_0(
    TextureSDFData_9ae3a59e var_sdf,
    wp::vec_t<3, wp::float32> var_local_pos)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    //---------
    // forward
    // def texture_sample_sdf_grad_only_hw(                                                   <L 1280>
    // return _texture_sample_sdf_grad_hw_impl(sdf, local_pos)                                <L 1303>
    var_0 = _texture_sample_sdf_grad_hw_impl_0(var_sdf, var_local_pos);
    return var_0;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_contact.py:141
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
    wp::float32 var_2;
    const wp::float32 var_3 = 0.0;
    bool var_4;
    wp::vec_t<3, wp::float32> var_5;
    wp::vec_t<3, wp::float32> var_6;
    wp::vec_t<3, wp::float32> var_7;
    //---------
    // forward
    // def scale_sdf_result_to_world(                                                         <L 142>
    // scaled_distance = distance * min_sdf_scale                                             <L 163>
    var_0 = wp::mul(var_distance, var_min_sdf_scale);
    // scaled_grad = wp.cw_mul(gradient, inv_sdf_scale)                                       <L 166>
    var_1 = wp::cw_mul(var_gradient, var_inv_sdf_scale);
    // grad_len = wp.length(scaled_grad)                                                      <L 167>
    var_2 = wp::length(var_1);
    // if grad_len > 0.0:                                                                     <L 168>
    var_4 = (var_2 > var_3);
    if (var_4) {
        // scaled_grad = scaled_grad / grad_len                                               <L 169>
        var_5 = wp::div(var_1, var_2);
    }
    if (!var_4) {
        // scaled_grad = gradient                                                             <L 171>
        var_6 = wp::copy(var_gradient);
    }
    var_7 = wp::where(var_4, var_5, var_6);
    // return scaled_distance, scaled_grad                                                    <L 173>
    ret_0 = var_0;
    ret_1 = var_7;
    return;
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction.py:104
static CUDA_CALLABLE wp::uint32 float_flip_0(
    wp::float32 f)
{

uint32_t i = reinterpret_cast<uint32_t&>(f);
uint32_t mask = (uint32_t)(-(int)(i >> 31)) | 0x80000000;
return i ^ mask;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:411
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
    // def _make_preprune_probe_det(score: float, fingerprint: int) -> wp.uint64:             <L 412>
    // return (                                                                               <L 424>
    // (wp.uint64(float_flip(score) >> wp.uint32(wp.static(SCORE_SHIFT))) << wp.uint64(42))       <L 425>
    var_0 = float_flip_0(var_score);
    var_2 = wp::uint32(var_1);
    var_3 = wp::rshift(var_0, var_2);
    var_4 = wp::uint64(var_3);
    var_5 = 42ull;
    var_6 = wp::lshift(var_4, var_5);
    // | ((wp.uint64(fingerprint) & FINGERPRINT_MASK) << CONTACT_ID_BITS)                     <L 426>
    var_7 = wp::uint64(var_fingerprint);
    var_9 = wp::bit_and(var_7, var_8);
    var_11 = wp::lshift(var_9, var_10);
    var_12 = wp::bit_or(var_6, var_11);
    // | CONTACT_ID_MASK                                                                      <L 427>
    var_14 = wp::bit_or(var_12, var_13);
    return var_14;
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:446
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
    // def _make_spatial_preprune_probe_det(score: float, is_inner: bool, fingerprint: int) -> wp.uint64:       <L 447>
    // priority = wp.uint64(0)                                                                <L 449>
    var_0 = 0ull;
    // if is_inner:                                                                           <L 450>
    if (var_is_inner) {
        // priority = wp.uint64(1)                                                            <L 451>
        var_1 = 1ull;
    }
    var_2 = wp::where(var_is_inner, var_1, var_0);
    // score_bits = wp.uint64(float_flip(score) >> wp.uint32(wp.static(SCORE_SHIFT + 1)))       <L 452>
    var_3 = float_flip_0(var_score);
    var_5 = wp::uint32(var_4);
    var_6 = wp::rshift(var_3, var_5);
    var_7 = wp::uint64(var_6);
    // return (                                                                               <L 453>
    // (priority << wp.uint64(63))                                                            <L 454>
    var_8 = 63ull;
    var_9 = wp::lshift(var_2, var_8);
    // | (score_bits << wp.uint64(42))                                                        <L 455>
    var_10 = 42ull;
    var_11 = wp::lshift(var_7, var_10);
    var_12 = wp::bit_or(var_9, var_11);
    // | ((wp.uint64(fingerprint) & FINGERPRINT_MASK) << CONTACT_ID_BITS)                     <L 456>
    var_13 = wp::uint64(var_fingerprint);
    var_15 = wp::bit_and(var_13, var_14);
    var_17 = wp::lshift(var_15, var_16);
    var_18 = wp::bit_or(var_12, var_17);
    // | CONTACT_ID_MASK                                                                      <L 457>
    var_20 = wp::bit_or(var_18, var_19);
    return var_20;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:327
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
    // def _make_spatial_preprune_probe_fast(score: float, is_inner: bool, fingerprint: int) -> wp.uint64:       <L 328>
    // priority = wp.uint64(0)                                                                <L 330>
    var_0 = 0ull;
    // if is_inner:                                                                           <L 331>
    if (var_is_inner) {
        // priority = wp.uint64(1)                                                            <L 332>
        var_1 = 1ull;
    }
    var_2 = wp::where(var_is_inner, var_1, var_0);
    // score_bits = wp.uint64(float_flip(score) >> wp.uint32(1))                              <L 333>
    var_3 = float_flip_0(var_score);
    var_5 = wp::uint32(var_4);
    var_6 = wp::rshift(var_3, var_5);
    var_7 = wp::uint64(var_6);
    // return (priority << wp.uint64(63)) | (score_bits << wp.uint64(32)) | wp.uint64(0xFFFFFFFF)       <L 334>
    var_8 = 63ull;
    var_9 = wp::lshift(var_2, var_8);
    var_10 = 32ull;
    var_11 = wp::lshift(var_7, var_10);
    var_12 = wp::bit_or(var_9, var_11);
    var_13 = 4294967295ull;
    var_14 = wp::bit_or(var_12, var_13);
    return var_14;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:508
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
    // def make_spatial_preprune_probe(score: float, is_inner: bool, fingerprint: int, deterministic: int) -> wp.uint64:       <L 509>
    // if deterministic != 0:                                                                 <L 511>
    var_1 = (var_deterministic != var_0);
    if (var_1) {
        // return _make_spatial_preprune_probe_det(score, is_inner, fingerprint)              <L 512>
        var_2 = _make_spatial_preprune_probe_det_0(var_score, var_is_inner, var_fingerprint);
        return var_2;
    }
    // return _make_spatial_preprune_probe_fast(score, is_inner, fingerprint)                 <L 513>
    var_3 = _make_spatial_preprune_probe_fast_0(var_score, var_is_inner, var_fingerprint);
    return var_3;
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:431
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
    // def _make_spatial_contact_value_det(score: float, is_inner: bool, fingerprint: int, contact_id: int) -> wp.uint64:       <L 432>
    // priority = wp.uint64(0)                                                                <L 434>
    var_0 = 0ull;
    // if is_inner:                                                                           <L 435>
    if (var_is_inner) {
        // priority = wp.uint64(1)                                                            <L 436>
        var_1 = 1ull;
    }
    var_2 = wp::where(var_is_inner, var_1, var_0);
    // score_bits = wp.uint64(float_flip(score) >> wp.uint32(wp.static(SCORE_SHIFT + 1)))       <L 437>
    var_3 = float_flip_0(var_score);
    var_5 = wp::uint32(var_4);
    var_6 = wp::rshift(var_3, var_5);
    var_7 = wp::uint64(var_6);
    // return (                                                                               <L 438>
    // (priority << wp.uint64(63))                                                            <L 439>
    var_8 = 63ull;
    var_9 = wp::lshift(var_2, var_8);
    // | (score_bits << wp.uint64(42))                                                        <L 440>
    var_10 = 42ull;
    var_11 = wp::lshift(var_7, var_10);
    var_12 = wp::bit_or(var_9, var_11);
    // | ((wp.uint64(fingerprint) & FINGERPRINT_MASK) << CONTACT_ID_BITS)                     <L 441>
    var_13 = wp::uint64(var_fingerprint);
    var_15 = wp::bit_and(var_13, var_14);
    var_17 = wp::lshift(var_15, var_16);
    var_18 = wp::bit_or(var_12, var_17);
    // | (wp.uint64(contact_id) & CONTACT_ID_MASK)                                            <L 442>
    var_19 = wp::uint64(var_contact_id);
    var_21 = wp::bit_and(var_19, var_20);
    var_22 = wp::bit_or(var_18, var_21);
    return var_22;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:317
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
    // def _make_spatial_contact_value_fast(score: float, is_inner: bool, fingerprint: int, contact_id: int) -> wp.uint64:       <L 318>
    // priority = wp.uint64(0)                                                                <L 320>
    var_0 = 0ull;
    // if is_inner:                                                                           <L 321>
    if (var_is_inner) {
        // priority = wp.uint64(1)                                                            <L 322>
        var_1 = 1ull;
    }
    var_2 = wp::where(var_is_inner, var_1, var_0);
    // score_bits = wp.uint64(float_flip(score) >> wp.uint32(1))                              <L 323>
    var_3 = float_flip_0(var_score);
    var_5 = wp::uint32(var_4);
    var_6 = wp::rshift(var_3, var_5);
    var_7 = wp::uint64(var_6);
    // return (priority << wp.uint64(63)) | (score_bits << wp.uint64(32)) | wp.uint64(contact_id)       <L 324>
    var_8 = 63ull;
    var_9 = wp::lshift(var_2, var_8);
    var_10 = 32ull;
    var_11 = wp::lshift(var_7, var_10);
    var_12 = wp::bit_or(var_9, var_11);
    var_13 = wp::uint64(var_contact_id);
    var_14 = wp::bit_or(var_12, var_13);
    return var_14;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:494
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
    // def make_spatial_contact_value(                                                        <L 495>
    // if deterministic != 0:                                                                 <L 503>
    var_1 = (var_deterministic != var_0);
    if (var_1) {
        // return _make_spatial_contact_value_det(score, is_inner, fingerprint, contact_id)       <L 504>
        var_2 = _make_spatial_contact_value_det_0(var_score, var_is_inner, var_fingerprint, var_contact_id);
        return var_2;
    }
    // return _make_spatial_contact_value_fast(score, is_inner, fingerprint, contact_id)       <L 505>
    var_3 = _make_spatial_contact_value_fast_0(var_score, var_is_inner, var_fingerprint, var_contact_id);
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:1320
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
    wp::transform_t<wp::float32> var_X_ws_voxel_shape,
    wp::vec_t<3, wp::float32> var_aabb_lower_voxel,
    wp::vec_t<3, wp::float32> var_aabb_upper_voxel,
    wp::vec_t<3, wp::int32> var_voxel_res,
    GlobalContactReducerData_98513266 var_reducer_data)
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
    wp::vec_t<3, wp::float32> var_163;
    wp::int32 var_164;
    const wp::int32 var_165 = 0;
    const wp::int32 var_166 = 99;
    wp::int32 var_167;
    const wp::int32 var_168 = 7;
    wp::int32 var_169;
    wp::int32 var_170;
    const wp::int32 var_171 = 20;
    wp::int32 var_172;
    wp::uint64 var_173;
    const wp::int32 var_174 = -1;
    bool var_175;
    bool var_176;
    wp::array_t<wp::uint64>* var_177;
    wp::array_t<wp::int32>* var_178;
    wp::int32 var_179;
    wp::array_t<wp::uint64> var_180;
    wp::array_t<wp::int32> var_181;
    const wp::int32 var_182 = 0;
    bool var_183;
    wp::int32* var_184;
    const wp::int32 var_185 = 0;
    bool var_186;
    wp::int32 var_187;
    wp::float32 var_188;
    wp::uint64 var_189;
    wp::float32 var_190;
    const wp::int32 var_191 = 0;
    const wp::int32 var_192 = 0;
    wp::uint64 var_193;
    wp::uint64 var_194;
    wp::array_t<wp::uint64>* var_195;
    wp::int32 var_196;
    wp::int32 var_197;
    wp::uint64* var_198;
    wp::array_t<wp::uint64> var_199;
    bool var_200;
    wp::uint64 var_201;
    const bool var_202 = true;
    bool var_203;
    bool var_204;
    bool var_205;
    wp::int32 var_206;
    bool var_207;
    const wp::int32 var_208 = -1;
    wp::int32 var_209;
    const wp::int32 var_210 = 0;
    bool var_211;
    const wp::int32 var_212 = -1;
    bool var_213;
    const wp::int32 var_214 = 0;
    bool var_215;
    const wp::int32 var_216 = 0;
    wp::vec_t<2, wp::float32> var_217;
    wp::float32 var_218;
    const bool var_219 = true;
    wp::int32* var_220;
    wp::uint64 var_221;
    wp::int32 var_222;
    wp::array_t<wp::uint64>* var_223;
    wp::array_t<wp::uint64> var_224;
    const wp::int32 var_225 = 1;
    wp::vec_t<2, wp::float32> var_226;
    wp::float32 var_227;
    const bool var_228 = true;
    wp::int32* var_229;
    wp::uint64 var_230;
    wp::int32 var_231;
    wp::array_t<wp::uint64>* var_232;
    wp::array_t<wp::uint64> var_233;
    const wp::int32 var_234 = 2;
    wp::vec_t<2, wp::float32> var_235;
    wp::float32 var_236;
    const bool var_237 = true;
    wp::int32* var_238;
    wp::uint64 var_239;
    wp::int32 var_240;
    wp::array_t<wp::uint64>* var_241;
    wp::array_t<wp::uint64> var_242;
    const wp::int32 var_243 = 3;
    wp::vec_t<2, wp::float32> var_244;
    wp::float32 var_245;
    const bool var_246 = true;
    wp::int32* var_247;
    wp::uint64 var_248;
    wp::int32 var_249;
    wp::array_t<wp::uint64>* var_250;
    wp::array_t<wp::uint64> var_251;
    const wp::int32 var_252 = 4;
    wp::vec_t<2, wp::float32> var_253;
    wp::float32 var_254;
    const bool var_255 = true;
    wp::int32* var_256;
    wp::uint64 var_257;
    wp::int32 var_258;
    wp::array_t<wp::uint64>* var_259;
    wp::array_t<wp::uint64> var_260;
    const wp::int32 var_261 = 5;
    wp::vec_t<2, wp::float32> var_262;
    wp::float32 var_263;
    const bool var_264 = true;
    wp::int32* var_265;
    wp::uint64 var_266;
    wp::int32 var_267;
    wp::array_t<wp::uint64>* var_268;
    wp::array_t<wp::uint64> var_269;
    wp::float32 var_270;
    wp::int32* var_271;
    wp::uint64 var_272;
    wp::int32 var_273;
    const wp::int32 var_274 = 6;
    wp::array_t<wp::uint64>* var_275;
    wp::array_t<wp::uint64> var_276;
    const wp::int32 var_277 = 0;
    bool var_278;
    const wp::int32 var_279 = 0;
    wp::vec_t<2, wp::float32> var_280;
    wp::float32 var_281;
    const bool var_282 = false;
    wp::int32* var_283;
    wp::uint64 var_284;
    wp::int32 var_285;
    wp::array_t<wp::uint64>* var_286;
    wp::array_t<wp::uint64> var_287;
    const wp::int32 var_288 = 1;
    wp::vec_t<2, wp::float32> var_289;
    wp::float32 var_290;
    const bool var_291 = false;
    wp::int32* var_292;
    wp::uint64 var_293;
    wp::int32 var_294;
    wp::array_t<wp::uint64>* var_295;
    wp::array_t<wp::uint64> var_296;
    const wp::int32 var_297 = 2;
    wp::vec_t<2, wp::float32> var_298;
    wp::float32 var_299;
    const bool var_300 = false;
    wp::int32* var_301;
    wp::uint64 var_302;
    wp::int32 var_303;
    wp::array_t<wp::uint64>* var_304;
    wp::array_t<wp::uint64> var_305;
    const wp::int32 var_306 = 3;
    wp::vec_t<2, wp::float32> var_307;
    wp::float32 var_308;
    const bool var_309 = false;
    wp::int32* var_310;
    wp::uint64 var_311;
    wp::int32 var_312;
    wp::array_t<wp::uint64>* var_313;
    wp::array_t<wp::uint64> var_314;
    const wp::int32 var_315 = 4;
    wp::vec_t<2, wp::float32> var_316;
    wp::float32 var_317;
    const bool var_318 = false;
    wp::int32* var_319;
    wp::uint64 var_320;
    wp::int32 var_321;
    wp::array_t<wp::uint64>* var_322;
    wp::array_t<wp::uint64> var_323;
    const wp::int32 var_324 = 5;
    wp::vec_t<2, wp::float32> var_325;
    wp::float32 var_326;
    const bool var_327 = false;
    wp::int32* var_328;
    wp::uint64 var_329;
    wp::int32 var_330;
    wp::array_t<wp::uint64>* var_331;
    wp::array_t<wp::uint64> var_332;
    wp::int32 var_333;
    wp::vec_t<2, wp::float32> var_334;
    wp::float32 var_335;
    wp::int32 var_336;
    wp::vec_t<2, wp::float32> var_337;
    wp::float32 var_338;
    wp::uint64 var_339;
    const wp::int32 var_340 = 0;
    bool var_341;
    wp::array_t<wp::uint64>* var_342;
    wp::array_t<wp::int32>* var_343;
    wp::int32 var_344;
    wp::array_t<wp::uint64> var_345;
    wp::array_t<wp::int32> var_346;
    wp::int32 var_347;
    const wp::int32 var_348 = 0;
    bool var_349;
    wp::float32 var_350;
    wp::int32* var_351;
    wp::uint64 var_352;
    wp::int32 var_353;
    wp::array_t<wp::uint64>* var_354;
    wp::array_t<wp::uint64> var_355;
    wp::array_t<wp::int32>* var_356;
    const wp::int32 var_357 = 0;
    const wp::int32 var_358 = 1;
    wp::int32 var_359;
    wp::array_t<wp::int32> var_360;
    wp::int32 var_361;
    //---------
    // forward
    // def export_and_reduce_contact_centered_two_spatial_depths(                             <L 1321>
    // ht_capacity = reducer_data.ht_capacity                                                 <L 1343>
    var_0 = &((var_reducer_data).ht_capacity);
    var_2 = wp::load(var_0);
    var_1 = wp::copy(var_2);
    // use_inner = depth < inner_spatial_depth                                                <L 1344>
    var_3 = (var_depth < var_inner_spatial_depth);
    // use_outer = depth < outer_spatial_depth                                                <L 1345>
    var_4 = (var_depth < var_outer_spatial_depth);
    // if not use_outer:                                                                      <L 1347>
    var_5 = wp::unot(var_4);
    if (var_5) {
        // return -1                                                                          <L 1348>
        return var_6;
    }
    // bin_id = get_slot(normal)                                                              <L 1351>
    var_7 = get_slot_0(var_normal);
    // pos_2d = project_point_to_plane(bin_id, centered_position)                             <L 1352>
    var_8 = project_point_to_plane_0(var_7, var_centered_position);
    // key = make_contact_key(shape_a, shape_b, bin_id)                                       <L 1353>
    var_9 = make_contact_key_0(var_shape_a, var_shape_b, var_7);
    // entry_idx = hashtable_find_or_insert(key, reducer_data.ht_keys, reducer_data.ht_active_slots)       <L 1355>
    var_10 = &((var_reducer_data).ht_keys);
    var_11 = &((var_reducer_data).ht_active_slots);
    var_13 = wp::load(var_10);
    var_14 = wp::load(var_11);
    var_12 = hashtable_find_or_insert_0(var_9, var_13, var_14);
    // might_win = False                                                                      <L 1356>
    // if entry_idx >= 0:                                                                     <L 1358>
    var_17 = (var_12 >= var_16);
    if (var_17) {
        // if use_inner:                                                                      <L 1359>
        if (var_3) {
            // if reducer_data.deterministic != 0:                                            <L 1360>
            var_18 = &((var_reducer_data).deterministic);
            var_21 = wp::load(var_18);
            var_20 = (var_21 != var_19);
            if (var_20) {
                // max_depth_probe = _make_preprune_probe_det(-depth, fingerprint)            <L 1361>
                var_22 = wp::neg(var_depth);
                var_23 = _make_preprune_probe_det_0(var_22, var_fingerprint);
            }
            if (!var_20) {
                // max_depth_probe = _make_contact_value_fast(-depth, 0, 0)                   <L 1363>
                var_24 = wp::neg(var_depth);
                var_27 = _make_contact_value_fast_0(var_24, var_25, var_26);
            }
            var_28 = wp::where(var_20, var_23, var_27);
            // if reducer_data.ht_values[wp.static(NUM_SPATIAL_DIRECTIONS) * ht_capacity + entry_idx] < max_depth_probe:       <L 1364>
            var_29 = &((var_reducer_data).ht_values);
            var_31 = wp::mul(var_30, var_1);
            var_32 = wp::add(var_31, var_12);
            var_34 = wp::load(var_29);
            var_33 = wp::address(var_34, var_32);
            var_36 = wp::load(var_33);
            var_35 = (var_36 < var_28);
            if (var_35) {
                // might_win = True                                                           <L 1365>
            }
            var_38 = wp::where(var_35, var_37, var_15);
        }
        var_39 = wp::where(var_3, var_38, var_15);
        // for dir_i in range(wp.static(NUM_SPATIAL_DIRECTIONS)):                             <L 1367>
        // if not might_win:                                                                  <L 1368>
        var_41 = wp::unot(var_39);
        if (var_41) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1369>
            var_42 = get_spatial_direction_2d_0(var_40);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1370>
            var_43 = wp::dot(var_8, var_42);
            // probe = make_spatial_preprune_probe(score, use_inner, fingerprint, reducer_data.deterministic)       <L 1371>
            var_44 = &((var_reducer_data).deterministic);
            var_46 = wp::load(var_44);
            var_45 = make_spatial_preprune_probe_0(var_43, var_3, var_fingerprint, var_46);
            // if reducer_data.ht_values[dir_i * ht_capacity + entry_idx] < probe:            <L 1372>
            var_47 = &((var_reducer_data).ht_values);
            var_48 = wp::mul(var_40, var_1);
            var_49 = wp::add(var_48, var_12);
            var_51 = wp::load(var_47);
            var_50 = wp::address(var_51, var_49);
            var_53 = wp::load(var_50);
            var_52 = (var_53 < var_45);
            if (var_52) {
                // might_win = True                                                           <L 1373>
            }
            var_55 = wp::where(var_52, var_54, var_39);
        }
        var_56 = wp::where(var_41, var_55, var_39);
        // if not might_win:                                                                  <L 1368>
        var_58 = wp::unot(var_56);
        if (var_58) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1369>
            var_59 = get_spatial_direction_2d_0(var_57);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1370>
            var_60 = wp::dot(var_8, var_59);
            // probe = make_spatial_preprune_probe(score, use_inner, fingerprint, reducer_data.deterministic)       <L 1371>
            var_61 = &((var_reducer_data).deterministic);
            var_63 = wp::load(var_61);
            var_62 = make_spatial_preprune_probe_0(var_60, var_3, var_fingerprint, var_63);
            // if reducer_data.ht_values[dir_i * ht_capacity + entry_idx] < probe:            <L 1372>
            var_64 = &((var_reducer_data).ht_values);
            var_65 = wp::mul(var_57, var_1);
            var_66 = wp::add(var_65, var_12);
            var_68 = wp::load(var_64);
            var_67 = wp::address(var_68, var_66);
            var_70 = wp::load(var_67);
            var_69 = (var_70 < var_62);
            if (var_69) {
                // might_win = True                                                           <L 1373>
            }
            var_72 = wp::where(var_69, var_71, var_56);
        }
        var_73 = wp::where(var_58, var_72, var_56);
        var_74 = wp::where(var_58, var_59, var_42);
        var_75 = wp::where(var_58, var_60, var_43);
        var_76 = wp::where(var_58, var_62, var_45);
        // if not might_win:                                                                  <L 1368>
        var_78 = wp::unot(var_73);
        if (var_78) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1369>
            var_79 = get_spatial_direction_2d_0(var_77);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1370>
            var_80 = wp::dot(var_8, var_79);
            // probe = make_spatial_preprune_probe(score, use_inner, fingerprint, reducer_data.deterministic)       <L 1371>
            var_81 = &((var_reducer_data).deterministic);
            var_83 = wp::load(var_81);
            var_82 = make_spatial_preprune_probe_0(var_80, var_3, var_fingerprint, var_83);
            // if reducer_data.ht_values[dir_i * ht_capacity + entry_idx] < probe:            <L 1372>
            var_84 = &((var_reducer_data).ht_values);
            var_85 = wp::mul(var_77, var_1);
            var_86 = wp::add(var_85, var_12);
            var_88 = wp::load(var_84);
            var_87 = wp::address(var_88, var_86);
            var_90 = wp::load(var_87);
            var_89 = (var_90 < var_82);
            if (var_89) {
                // might_win = True                                                           <L 1373>
            }
            var_92 = wp::where(var_89, var_91, var_73);
        }
        var_93 = wp::where(var_78, var_92, var_73);
        var_94 = wp::where(var_78, var_79, var_74);
        var_95 = wp::where(var_78, var_80, var_75);
        var_96 = wp::where(var_78, var_82, var_76);
        // if not might_win:                                                                  <L 1368>
        var_98 = wp::unot(var_93);
        if (var_98) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1369>
            var_99 = get_spatial_direction_2d_0(var_97);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1370>
            var_100 = wp::dot(var_8, var_99);
            // probe = make_spatial_preprune_probe(score, use_inner, fingerprint, reducer_data.deterministic)       <L 1371>
            var_101 = &((var_reducer_data).deterministic);
            var_103 = wp::load(var_101);
            var_102 = make_spatial_preprune_probe_0(var_100, var_3, var_fingerprint, var_103);
            // if reducer_data.ht_values[dir_i * ht_capacity + entry_idx] < probe:            <L 1372>
            var_104 = &((var_reducer_data).ht_values);
            var_105 = wp::mul(var_97, var_1);
            var_106 = wp::add(var_105, var_12);
            var_108 = wp::load(var_104);
            var_107 = wp::address(var_108, var_106);
            var_110 = wp::load(var_107);
            var_109 = (var_110 < var_102);
            if (var_109) {
                // might_win = True                                                           <L 1373>
            }
            var_112 = wp::where(var_109, var_111, var_93);
        }
        var_113 = wp::where(var_98, var_112, var_93);
        var_114 = wp::where(var_98, var_99, var_94);
        var_115 = wp::where(var_98, var_100, var_95);
        var_116 = wp::where(var_98, var_102, var_96);
        // if not might_win:                                                                  <L 1368>
        var_118 = wp::unot(var_113);
        if (var_118) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1369>
            var_119 = get_spatial_direction_2d_0(var_117);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1370>
            var_120 = wp::dot(var_8, var_119);
            // probe = make_spatial_preprune_probe(score, use_inner, fingerprint, reducer_data.deterministic)       <L 1371>
            var_121 = &((var_reducer_data).deterministic);
            var_123 = wp::load(var_121);
            var_122 = make_spatial_preprune_probe_0(var_120, var_3, var_fingerprint, var_123);
            // if reducer_data.ht_values[dir_i * ht_capacity + entry_idx] < probe:            <L 1372>
            var_124 = &((var_reducer_data).ht_values);
            var_125 = wp::mul(var_117, var_1);
            var_126 = wp::add(var_125, var_12);
            var_128 = wp::load(var_124);
            var_127 = wp::address(var_128, var_126);
            var_130 = wp::load(var_127);
            var_129 = (var_130 < var_122);
            if (var_129) {
                // might_win = True                                                           <L 1373>
            }
            var_132 = wp::where(var_129, var_131, var_113);
        }
        var_133 = wp::where(var_118, var_132, var_113);
        var_134 = wp::where(var_118, var_119, var_114);
        var_135 = wp::where(var_118, var_120, var_115);
        var_136 = wp::where(var_118, var_122, var_116);
        // if not might_win:                                                                  <L 1368>
        var_138 = wp::unot(var_133);
        if (var_138) {
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1369>
            var_139 = get_spatial_direction_2d_0(var_137);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1370>
            var_140 = wp::dot(var_8, var_139);
            // probe = make_spatial_preprune_probe(score, use_inner, fingerprint, reducer_data.deterministic)       <L 1371>
            var_141 = &((var_reducer_data).deterministic);
            var_143 = wp::load(var_141);
            var_142 = make_spatial_preprune_probe_0(var_140, var_3, var_fingerprint, var_143);
            // if reducer_data.ht_values[dir_i * ht_capacity + entry_idx] < probe:            <L 1372>
            var_144 = &((var_reducer_data).ht_values);
            var_145 = wp::mul(var_137, var_1);
            var_146 = wp::add(var_145, var_12);
            var_148 = wp::load(var_144);
            var_147 = wp::address(var_148, var_146);
            var_150 = wp::load(var_147);
            var_149 = (var_150 < var_142);
            if (var_149) {
                // might_win = True                                                           <L 1373>
            }
            var_152 = wp::where(var_149, var_151, var_133);
        }
        var_153 = wp::where(var_138, var_152, var_133);
        var_154 = wp::where(var_138, var_139, var_134);
        var_155 = wp::where(var_138, var_140, var_135);
        var_156 = wp::where(var_138, var_142, var_136);
    }
    if (!var_17) {
        // wp.atomic_add(reducer_data.ht_insert_failures, 0, 1)                               <L 1375>
        var_157 = &((var_reducer_data).ht_insert_failures);
        var_161 = wp::load(var_157);
        var_160 = wp::atomic_add(var_161, var_158, var_159);
    }
    var_162 = wp::where(var_17, var_153, var_15);
    // position_local = wp.transform_point(X_ws_voxel_shape, position)                        <L 1378>
    var_163 = wp::transform_point(var_X_ws_voxel_shape, var_position);
    // voxel_idx = compute_voxel_index(position_local, aabb_lower_voxel, aabb_upper_voxel, voxel_res)       <L 1379>
    var_164 = compute_voxel_index_0(var_163, var_aabb_lower_voxel, var_aabb_upper_voxel, var_voxel_res);
    // voxel_idx = wp.clamp(voxel_idx, 0, wp.static(NUM_VOXEL_DEPTH_SLOTS - 1))               <L 1380>
    var_167 = wp::clamp(var_164, var_165, var_166);
    // voxels_per_group = wp.static(NUM_SPATIAL_DIRECTIONS + 1)                               <L 1382>
    // voxel_group = voxel_idx // voxels_per_group                                            <L 1383>
    var_169 = wp::floordiv(var_167, var_168);
    // voxel_local_slot = voxel_idx % voxels_per_group                                        <L 1384>
    var_170 = wp::mod(var_167, var_168);
    // voxel_bin_id = wp.static(NUM_NORMAL_BINS) + voxel_group                                <L 1385>
    var_172 = wp::add(var_171, var_169);
    // voxel_key = make_contact_key(shape_a, shape_b, voxel_bin_id)                           <L 1386>
    var_173 = make_contact_key_0(var_shape_a, var_shape_b, var_172);
    // voxel_entry_idx = -1                                                                   <L 1388>
    // if use_inner and not might_win:                                                        <L 1389>
    var_175 = var_3;
    if (var_175) {
        var_176 = wp::unot(var_162);
        var_175 = var_175 && var_176;
    }
    if (var_175) {
        // voxel_entry_idx = hashtable_find_or_insert(voxel_key, reducer_data.ht_keys, reducer_data.ht_active_slots)       <L 1390>
        var_177 = &((var_reducer_data).ht_keys);
        var_178 = &((var_reducer_data).ht_active_slots);
        var_180 = wp::load(var_177);
        var_181 = wp::load(var_178);
        var_179 = hashtable_find_or_insert_0(var_173, var_180, var_181);
        // if voxel_entry_idx >= 0:                                                           <L 1391>
        var_183 = (var_179 >= var_182);
        if (var_183) {
            // if reducer_data.deterministic != 0:                                            <L 1392>
            var_184 = &((var_reducer_data).deterministic);
            var_187 = wp::load(var_184);
            var_186 = (var_187 != var_185);
            if (var_186) {
                // voxel_probe = _make_preprune_probe_det(-depth, fingerprint)                <L 1393>
                var_188 = wp::neg(var_depth);
                var_189 = _make_preprune_probe_det_0(var_188, var_fingerprint);
            }
            if (!var_186) {
                // voxel_probe = _make_contact_value_fast(-depth, 0, 0)                       <L 1395>
                var_190 = wp::neg(var_depth);
                var_193 = _make_contact_value_fast_0(var_190, var_191, var_192);
            }
            var_194 = wp::where(var_186, var_189, var_193);
            // if reducer_data.ht_values[voxel_local_slot * ht_capacity + voxel_entry_idx] < voxel_probe:       <L 1396>
            var_195 = &((var_reducer_data).ht_values);
            var_196 = wp::mul(var_170, var_1);
            var_197 = wp::add(var_196, var_179);
            var_199 = wp::load(var_195);
            var_198 = wp::address(var_199, var_197);
            var_201 = wp::load(var_198);
            var_200 = (var_201 < var_194);
            if (var_200) {
                // might_win = True                                                           <L 1397>
            }
            var_203 = wp::where(var_200, var_202, var_162);
        }
        var_204 = wp::where(var_183, var_203, var_162);
    }
    var_205 = wp::where(var_175, var_204, var_162);
    var_206 = wp::where(var_175, var_179, var_174);
    // if not might_win:                                                                      <L 1399>
    var_207 = wp::unot(var_205);
    if (var_207) {
        // return -1                                                                          <L 1400>
        return var_208;
    }
    // contact_id = export_contact_to_buffer(shape_a, shape_b, position, normal, depth, fingerprint, reducer_data)       <L 1402>
    var_209 = export_contact_to_buffer_0(var_shape_a, var_shape_b, var_position, var_normal, var_depth, var_fingerprint, var_reducer_data);
    // if contact_id < 0:                                                                     <L 1403>
    var_211 = (var_209 < var_210);
    if (var_211) {
        // return -1                                                                          <L 1404>
        return var_212;
    }
    // if use_inner and entry_idx >= 0:                                                       <L 1406>
    var_213 = var_3;
    if (var_213) {
        var_215 = (var_12 >= var_214);
        var_213 = var_213 && var_215;
    }
    if (var_213) {
        // for dir_i in range(wp.static(NUM_SPATIAL_DIRECTIONS)):                             <L 1407>
        // dir_2d = get_spatial_direction_2d(dir_i)                                           <L 1408>
        var_217 = get_spatial_direction_2d_0(var_216);
        // score = wp.dot(pos_2d, dir_2d)                                                     <L 1409>
        var_218 = wp::dot(var_8, var_217);
        // value = make_spatial_contact_value(score, True, fingerprint, contact_id, reducer_data.deterministic)       <L 1410>
        var_220 = &((var_reducer_data).deterministic);
        var_222 = wp::load(var_220);
        var_221 = make_spatial_contact_value_0(var_218, var_219, var_fingerprint, var_209, var_222);
        // reduction_update_slot(entry_idx, dir_i, value, reducer_data.ht_values, ht_capacity)       <L 1411>
        var_223 = &((var_reducer_data).ht_values);
        var_224 = wp::load(var_223);
        reduction_update_slot_0(var_12, var_216, var_221, var_224, var_1);
        // dir_2d = get_spatial_direction_2d(dir_i)                                           <L 1408>
        var_226 = get_spatial_direction_2d_0(var_225);
        // score = wp.dot(pos_2d, dir_2d)                                                     <L 1409>
        var_227 = wp::dot(var_8, var_226);
        // value = make_spatial_contact_value(score, True, fingerprint, contact_id, reducer_data.deterministic)       <L 1410>
        var_229 = &((var_reducer_data).deterministic);
        var_231 = wp::load(var_229);
        var_230 = make_spatial_contact_value_0(var_227, var_228, var_fingerprint, var_209, var_231);
        // reduction_update_slot(entry_idx, dir_i, value, reducer_data.ht_values, ht_capacity)       <L 1411>
        var_232 = &((var_reducer_data).ht_values);
        var_233 = wp::load(var_232);
        reduction_update_slot_0(var_12, var_225, var_230, var_233, var_1);
        // dir_2d = get_spatial_direction_2d(dir_i)                                           <L 1408>
        var_235 = get_spatial_direction_2d_0(var_234);
        // score = wp.dot(pos_2d, dir_2d)                                                     <L 1409>
        var_236 = wp::dot(var_8, var_235);
        // value = make_spatial_contact_value(score, True, fingerprint, contact_id, reducer_data.deterministic)       <L 1410>
        var_238 = &((var_reducer_data).deterministic);
        var_240 = wp::load(var_238);
        var_239 = make_spatial_contact_value_0(var_236, var_237, var_fingerprint, var_209, var_240);
        // reduction_update_slot(entry_idx, dir_i, value, reducer_data.ht_values, ht_capacity)       <L 1411>
        var_241 = &((var_reducer_data).ht_values);
        var_242 = wp::load(var_241);
        reduction_update_slot_0(var_12, var_234, var_239, var_242, var_1);
        // dir_2d = get_spatial_direction_2d(dir_i)                                           <L 1408>
        var_244 = get_spatial_direction_2d_0(var_243);
        // score = wp.dot(pos_2d, dir_2d)                                                     <L 1409>
        var_245 = wp::dot(var_8, var_244);
        // value = make_spatial_contact_value(score, True, fingerprint, contact_id, reducer_data.deterministic)       <L 1410>
        var_247 = &((var_reducer_data).deterministic);
        var_249 = wp::load(var_247);
        var_248 = make_spatial_contact_value_0(var_245, var_246, var_fingerprint, var_209, var_249);
        // reduction_update_slot(entry_idx, dir_i, value, reducer_data.ht_values, ht_capacity)       <L 1411>
        var_250 = &((var_reducer_data).ht_values);
        var_251 = wp::load(var_250);
        reduction_update_slot_0(var_12, var_243, var_248, var_251, var_1);
        // dir_2d = get_spatial_direction_2d(dir_i)                                           <L 1408>
        var_253 = get_spatial_direction_2d_0(var_252);
        // score = wp.dot(pos_2d, dir_2d)                                                     <L 1409>
        var_254 = wp::dot(var_8, var_253);
        // value = make_spatial_contact_value(score, True, fingerprint, contact_id, reducer_data.deterministic)       <L 1410>
        var_256 = &((var_reducer_data).deterministic);
        var_258 = wp::load(var_256);
        var_257 = make_spatial_contact_value_0(var_254, var_255, var_fingerprint, var_209, var_258);
        // reduction_update_slot(entry_idx, dir_i, value, reducer_data.ht_values, ht_capacity)       <L 1411>
        var_259 = &((var_reducer_data).ht_values);
        var_260 = wp::load(var_259);
        reduction_update_slot_0(var_12, var_252, var_257, var_260, var_1);
        // dir_2d = get_spatial_direction_2d(dir_i)                                           <L 1408>
        var_262 = get_spatial_direction_2d_0(var_261);
        // score = wp.dot(pos_2d, dir_2d)                                                     <L 1409>
        var_263 = wp::dot(var_8, var_262);
        // value = make_spatial_contact_value(score, True, fingerprint, contact_id, reducer_data.deterministic)       <L 1410>
        var_265 = &((var_reducer_data).deterministic);
        var_267 = wp::load(var_265);
        var_266 = make_spatial_contact_value_0(var_263, var_264, var_fingerprint, var_209, var_267);
        // reduction_update_slot(entry_idx, dir_i, value, reducer_data.ht_values, ht_capacity)       <L 1411>
        var_268 = &((var_reducer_data).ht_values);
        var_269 = wp::load(var_268);
        reduction_update_slot_0(var_12, var_261, var_266, var_269, var_1);
        // max_depth_value = make_contact_value(-depth, fingerprint, contact_id, reducer_data.deterministic)       <L 1413>
        var_270 = wp::neg(var_depth);
        var_271 = &((var_reducer_data).deterministic);
        var_273 = wp::load(var_271);
        var_272 = make_contact_value_0(var_270, var_fingerprint, var_209, var_273);
        // reduction_update_slot(                                                             <L 1414>
        // entry_idx, wp.static(NUM_SPATIAL_DIRECTIONS), max_depth_value, reducer_data.ht_values, ht_capacity       <L 1415>
        var_275 = &((var_reducer_data).ht_values);
        var_276 = wp::load(var_275);
        reduction_update_slot_0(var_12, var_274, var_272, var_276, var_1);
    }
    if (!var_213) {
        // elif entry_idx >= 0:                                                               <L 1417>
        var_278 = (var_12 >= var_277);
        if (var_278) {
            // for dir_i in range(wp.static(NUM_SPATIAL_DIRECTIONS)):                         <L 1418>
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1419>
            var_280 = get_spatial_direction_2d_0(var_279);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1420>
            var_281 = wp::dot(var_8, var_280);
            // value = make_spatial_contact_value(score, False, fingerprint, contact_id, reducer_data.deterministic)       <L 1421>
            var_283 = &((var_reducer_data).deterministic);
            var_285 = wp::load(var_283);
            var_284 = make_spatial_contact_value_0(var_281, var_282, var_fingerprint, var_209, var_285);
            // reduction_update_slot(entry_idx, dir_i, value, reducer_data.ht_values, ht_capacity)       <L 1422>
            var_286 = &((var_reducer_data).ht_values);
            var_287 = wp::load(var_286);
            reduction_update_slot_0(var_12, var_279, var_284, var_287, var_1);
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1419>
            var_289 = get_spatial_direction_2d_0(var_288);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1420>
            var_290 = wp::dot(var_8, var_289);
            // value = make_spatial_contact_value(score, False, fingerprint, contact_id, reducer_data.deterministic)       <L 1421>
            var_292 = &((var_reducer_data).deterministic);
            var_294 = wp::load(var_292);
            var_293 = make_spatial_contact_value_0(var_290, var_291, var_fingerprint, var_209, var_294);
            // reduction_update_slot(entry_idx, dir_i, value, reducer_data.ht_values, ht_capacity)       <L 1422>
            var_295 = &((var_reducer_data).ht_values);
            var_296 = wp::load(var_295);
            reduction_update_slot_0(var_12, var_288, var_293, var_296, var_1);
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1419>
            var_298 = get_spatial_direction_2d_0(var_297);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1420>
            var_299 = wp::dot(var_8, var_298);
            // value = make_spatial_contact_value(score, False, fingerprint, contact_id, reducer_data.deterministic)       <L 1421>
            var_301 = &((var_reducer_data).deterministic);
            var_303 = wp::load(var_301);
            var_302 = make_spatial_contact_value_0(var_299, var_300, var_fingerprint, var_209, var_303);
            // reduction_update_slot(entry_idx, dir_i, value, reducer_data.ht_values, ht_capacity)       <L 1422>
            var_304 = &((var_reducer_data).ht_values);
            var_305 = wp::load(var_304);
            reduction_update_slot_0(var_12, var_297, var_302, var_305, var_1);
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1419>
            var_307 = get_spatial_direction_2d_0(var_306);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1420>
            var_308 = wp::dot(var_8, var_307);
            // value = make_spatial_contact_value(score, False, fingerprint, contact_id, reducer_data.deterministic)       <L 1421>
            var_310 = &((var_reducer_data).deterministic);
            var_312 = wp::load(var_310);
            var_311 = make_spatial_contact_value_0(var_308, var_309, var_fingerprint, var_209, var_312);
            // reduction_update_slot(entry_idx, dir_i, value, reducer_data.ht_values, ht_capacity)       <L 1422>
            var_313 = &((var_reducer_data).ht_values);
            var_314 = wp::load(var_313);
            reduction_update_slot_0(var_12, var_306, var_311, var_314, var_1);
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1419>
            var_316 = get_spatial_direction_2d_0(var_315);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1420>
            var_317 = wp::dot(var_8, var_316);
            // value = make_spatial_contact_value(score, False, fingerprint, contact_id, reducer_data.deterministic)       <L 1421>
            var_319 = &((var_reducer_data).deterministic);
            var_321 = wp::load(var_319);
            var_320 = make_spatial_contact_value_0(var_317, var_318, var_fingerprint, var_209, var_321);
            // reduction_update_slot(entry_idx, dir_i, value, reducer_data.ht_values, ht_capacity)       <L 1422>
            var_322 = &((var_reducer_data).ht_values);
            var_323 = wp::load(var_322);
            reduction_update_slot_0(var_12, var_315, var_320, var_323, var_1);
            // dir_2d = get_spatial_direction_2d(dir_i)                                       <L 1419>
            var_325 = get_spatial_direction_2d_0(var_324);
            // score = wp.dot(pos_2d, dir_2d)                                                 <L 1420>
            var_326 = wp::dot(var_8, var_325);
            // value = make_spatial_contact_value(score, False, fingerprint, contact_id, reducer_data.deterministic)       <L 1421>
            var_328 = &((var_reducer_data).deterministic);
            var_330 = wp::load(var_328);
            var_329 = make_spatial_contact_value_0(var_326, var_327, var_fingerprint, var_209, var_330);
            // reduction_update_slot(entry_idx, dir_i, value, reducer_data.ht_values, ht_capacity)       <L 1422>
            var_331 = &((var_reducer_data).ht_values);
            var_332 = wp::load(var_331);
            reduction_update_slot_0(var_12, var_324, var_329, var_332, var_1);
        }
        var_333 = wp::where(var_278, var_324, var_137);
        var_334 = wp::where(var_278, var_325, var_154);
        var_335 = wp::where(var_278, var_326, var_155);
    }
    var_336 = wp::where(var_213, var_261, var_333);
    var_337 = wp::where(var_213, var_262, var_334);
    var_338 = wp::where(var_213, var_263, var_335);
    var_339 = wp::where(var_213, var_266, var_329);
    // if use_inner:                                                                          <L 1424>
    if (var_3) {
        // if voxel_entry_idx < 0:                                                            <L 1425>
        var_341 = (var_206 < var_340);
        if (var_341) {
            // voxel_entry_idx = hashtable_find_or_insert(voxel_key, reducer_data.ht_keys, reducer_data.ht_active_slots)       <L 1426>
            var_342 = &((var_reducer_data).ht_keys);
            var_343 = &((var_reducer_data).ht_active_slots);
            var_345 = wp::load(var_342);
            var_346 = wp::load(var_343);
            var_344 = hashtable_find_or_insert_0(var_173, var_345, var_346);
        }
        var_347 = wp::where(var_341, var_344, var_206);
        // if voxel_entry_idx >= 0:                                                           <L 1427>
        var_349 = (var_347 >= var_348);
        if (var_349) {
            // voxel_value = make_contact_value(-depth, fingerprint, contact_id, reducer_data.deterministic)       <L 1428>
            var_350 = wp::neg(var_depth);
            var_351 = &((var_reducer_data).deterministic);
            var_353 = wp::load(var_351);
            var_352 = make_contact_value_0(var_350, var_fingerprint, var_209, var_353);
            // reduction_update_slot(voxel_entry_idx, voxel_local_slot, voxel_value, reducer_data.ht_values, ht_capacity)       <L 1429>
            var_354 = &((var_reducer_data).ht_values);
            var_355 = wp::load(var_354);
            reduction_update_slot_0(var_347, var_170, var_352, var_355, var_1);
        }
        if (!var_349) {
            // wp.atomic_add(reducer_data.ht_insert_failures, 0, 1)                           <L 1431>
            var_356 = &((var_reducer_data).ht_insert_failures);
            var_360 = wp::load(var_356);
            var_359 = wp::atomic_add(var_360, var_357, var_358);
        }
    }
    var_361 = wp::where(var_3, var_347, var_206);
    // return contact_id                                                                      <L 1433>
    return var_209;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/kernels.py:15
static CUDA_CALLABLE void adj_resolve_mesh_sign_method_0(
    wp::int32 var_mesh_properties,
    wp::int32 & adj_mesh_properties,
    wp::int32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_contact.py:107
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_contact.py:67
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_contact.py:558
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_contact.py:410
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_contact.py:532
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/utils/heightfield.py:171
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/utils/heightfield.py:230
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/kernels.py:884
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_contact.py:176
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_texture.py:775
static CUDA_CALLABLE void adj__locate_cell_0(
    TextureSDFData_9ae3a59e var_sdf,
    wp::vec_t<3, wp::float32> var_f,
    TextureSDFData_9ae3a59e & adj_sdf,
    wp::vec_t<3, wp::float32> & adj_f,
    _CellLookup_6716dbae & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_texture.py:1076
static CUDA_CALLABLE void adj_texture_sample_sdf_hw_0(
    TextureSDFData_9ae3a59e var_sdf,
    wp::vec_t<3, wp::float32> var_local_pos,
    TextureSDFData_9ae3a59e & adj_sdf,
    wp::vec_t<3, wp::float32> & adj_local_pos,
    wp::float32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_contact.py:583
static CUDA_CALLABLE void adj__create_sdf_contact_funcs__locals___sample_sdf_at_t_0(
    TextureSDFData_9ae3a59e var_texture_sdf,
    wp::uint64 var_sdf_mesh_id,
    wp::vec_t<3, wp::float32> var_v0,
    wp::vec_t<3, wp::float32> var_edge_dir,
    wp::float32 var_tt,
    bool var_use_bvh_for_sdf,
    wp::int32 var_sdf_mesh_query_type,
    bool var_sdf_is_heightfield,
    HeightfieldData_f2b8d59a var_hfd_sdf,
    wp::array_t<wp::float32> var_elevation_data,
    TextureSDFData_9ae3a59e & adj_texture_sdf,
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_contact.py:611
static CUDA_CALLABLE void adj__create_sdf_contact_funcs__locals__do_edge_sdf_collision_func_0(
    TextureSDFData_9ae3a59e var_texture_sdf,
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
    TextureSDFData_9ae3a59e & adj_texture_sdf,
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
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_contact.py:81
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_contact.py:208
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_texture.py:1206
static CUDA_CALLABLE void adj__texture_sample_sdf_grad_hw_impl_0(
    TextureSDFData_9ae3a59e var_sdf,
    wp::vec_t<3, wp::float32> var_local_pos,
    TextureSDFData_9ae3a59e & adj_sdf,
    wp::vec_t<3, wp::float32> & adj_local_pos,
    wp::vec_t<3, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_texture.py:1279
static CUDA_CALLABLE void adj_texture_sample_sdf_grad_only_hw_0(
    TextureSDFData_9ae3a59e var_sdf,
    wp::vec_t<3, wp::float32> var_local_pos,
    TextureSDFData_9ae3a59e & adj_sdf,
    wp::vec_t<3, wp::float32> & adj_local_pos,
    wp::vec_t<3, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/sdf_contact.py:141
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction.py:104
static CUDA_CALLABLE void adj_float_flip_0(
    wp::float32 f,
    wp::float32 & adj_f,
    wp::uint32 & adj_ret)
{
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:411
static CUDA_CALLABLE void adj__make_preprune_probe_det_0(
    wp::float32 var_score,
    wp::int32 var_fingerprint,
    wp::float32 & adj_score,
    wp::int32 & adj_fingerprint,
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction.py:346
static CUDA_CALLABLE void adj_get_spatial_direction_2d_0(
    wp::int32 var_dir_idx,
    wp::int32 & adj_dir_idx,
    wp::vec_t<2, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:446
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:327
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:508
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:431
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:317
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:494
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/contact_reduction_global.py:1320
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
    wp::transform_t<wp::float32> var_X_ws_voxel_shape,
    wp::vec_t<3, wp::float32> var_aabb_lower_voxel,
    wp::vec_t<3, wp::float32> var_aabb_upper_voxel,
    wp::vec_t<3, wp::int32> var_voxel_res,
    GlobalContactReducerData_98513266 var_reducer_data,
    wp::int32 & adj_shape_a,
    wp::int32 & adj_shape_b,
    wp::vec_t<3, wp::float32> & adj_position,
    wp::vec_t<3, wp::float32> & adj_normal,
    wp::float32 & adj_depth,
    wp::int32 & adj_fingerprint,
    wp::vec_t<3, wp::float32> & adj_centered_position,
    wp::float32 & adj_inner_spatial_depth,
    wp::float32 & adj_outer_spatial_depth,
    wp::transform_t<wp::float32> & adj_X_ws_voxel_shape,
    wp::vec_t<3, wp::float32> & adj_aabb_lower_voxel,
    wp::vec_t<3, wp::float32> & adj_aabb_upper_voxel,
    wp::vec_t<3, wp::int32> & adj_voxel_res,
    GlobalContactReducerData_98513266 & adj_reducer_data,
    wp::int32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}



extern "C" __global__ void create_narrow_phase_process_mesh_mesh_contacts_kernel__locals__mesh_sdf_collision_global_reduce_kernel_bbbe9a99_cuda_kernel_forward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::vec_t<4, wp::float32>> var_shape_data,
    wp::array_t<wp::transform_t<wp::float32>> var_shape_transform,
    wp::array_t<wp::uint64> var_shape_source,
    wp::array_t<TextureSDFData_9ae3a59e> var_texture_sdf_table,
    wp::array_t<wp::int32> var_shape_sdf_index,
    wp::array_t<wp::int32> var_shape_mesh_properties,
    wp::array_t<wp::float32> var_shape_gap,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_collision_aabb_lower,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_collision_aabb_upper,
    wp::array_t<wp::vec_t<3, wp::int32>> var_shape_voxel_resolution,
    wp::array_t<wp::vec_t<2, wp::int32>> var_shape_pairs_mesh_mesh,
    wp::array_t<wp::int32> var_shape_pairs_mesh_mesh_count,
    wp::array_t<wp::int32> var_shape_heightfield_index,
    wp::array_t<HeightfieldData_f2b8d59a> var_heightfield_data,
    wp::array_t<wp::float32> var_heightfield_elevations,
    wp::array_t<wp::vec_t<2, wp::int32>> var_mesh_edge_indices,
    wp::array_t<wp::vec_t<2, wp::int32>> var_shape_edge_range,
    wp::array_t<wp::int32> var_block_offsets,
    GlobalContactReducerData_98513266 var_reducer_data,
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
        const wp::int32 var_62 = 2;
        wp::range_t var_63;
        wp::int32 var_64;
        wp::int32 var_65;
        const wp::int32 var_66 = 1;
        wp::int32 var_67;
        wp::int32 var_68;
        const bool var_69 = false;
        const bool var_70 = false;
        const bool var_71 = false;
        const wp::int32 var_72 = 8;
        wp::uint64* var_73;
        wp::uint64 var_74;
        wp::uint64 var_75;
        wp::uint64* var_76;
        wp::uint64 var_77;
        wp::uint64 var_78;
        bool var_79;
        bool var_80;
        wp::uint64 var_81;
        bool var_82;
        HeightfieldData_f2b8d59a var_83;
        HeightfieldData_f2b8d59a var_84;
        const bool var_85 = false;
        wp::int32* var_86;
        wp::int32 var_87;
        wp::int32 var_88;
        const bool var_89 = false;
        bool var_90;
        wp::int32* var_91;
        wp::int32 var_92;
        wp::int32 var_93;
        bool var_94;
        const wp::int32 var_95 = 0;
        bool var_96;
        wp::shape_t* var_97;
        const wp::int32 var_98 = 0;
        wp::int32 var_99;
        wp::shape_t var_100;
        bool var_101;
        bool var_102;
        TextureSDFData_9ae3a59e* var_103;
        wp::texture3d_t* var_104;
        wp::int32* var_105;
        const wp::int32 var_106 = 0;
        bool var_107;
        wp::int32 var_108;
        bool var_109;
        bool var_110;
        wp::uint64 var_111;
        bool var_112;
        bool var_113;
        wp::vec_t<4, wp::float32>* var_114;
        wp::vec_t<4, wp::float32> var_115;
        wp::vec_t<4, wp::float32> var_116;
        wp::vec_t<4, wp::float32>* var_117;
        wp::vec_t<4, wp::float32> var_118;
        wp::vec_t<4, wp::float32> var_119;
        const wp::int32 var_120 = 0;
        wp::float32 var_121;
        const wp::int32 var_122 = 1;
        wp::float32 var_123;
        const wp::int32 var_124 = 2;
        wp::float32 var_125;
        wp::vec_t<3, wp::float32> var_126;
        const wp::int32 var_127 = 0;
        wp::float32 var_128;
        const wp::int32 var_129 = 1;
        wp::float32 var_130;
        const wp::int32 var_131 = 2;
        wp::float32 var_132;
        wp::vec_t<3, wp::float32> var_133;
        wp::transform_t<wp::float32>* var_134;
        wp::transform_t<wp::float32> var_135;
        wp::transform_t<wp::float32> var_136;
        wp::transform_t<wp::float32>* var_137;
        wp::transform_t<wp::float32> var_138;
        wp::transform_t<wp::float32> var_139;
        wp::transform_t<wp::float32> var_140;
        wp::vec_t<3, wp::float32>* var_141;
        wp::vec_t<3, wp::float32> var_142;
        wp::vec_t<3, wp::float32> var_143;
        wp::vec_t<3, wp::float32>* var_144;
        wp::vec_t<3, wp::float32> var_145;
        wp::vec_t<3, wp::float32> var_146;
        wp::vec_t<3, wp::int32>* var_147;
        wp::vec_t<3, wp::int32> var_148;
        wp::vec_t<3, wp::int32> var_149;
        TextureSDFData_9ae3a59e var_150;
        wp::vec_t<3, wp::float32> var_151;
        bool var_152;
        TextureSDFData_9ae3a59e* var_153;
        TextureSDFData_9ae3a59e var_154;
        TextureSDFData_9ae3a59e var_155;
        bool* var_156;
        bool var_157;
        const wp::float32 var_158 = 1.0;
        const wp::float32 var_159 = 1.0;
        const wp::float32 var_160 = 1.0;
        wp::vec_t<3, wp::float32> var_161;
        bool var_162;
        wp::vec_t<3, wp::float32> var_163;
        bool var_164;
        TextureSDFData_9ae3a59e var_165;
        wp::vec_t<3, wp::float32> var_166;
        wp::transform_t<wp::float32> var_167;
        wp::transform_t<wp::float32> var_168;
        const wp::int32 var_169 = 3;
        wp::float32 var_170;
        const wp::int32 var_171 = 3;
        wp::float32 var_172;
        wp::vec_t<3, wp::float32> var_173;
        wp::vec_t<3, wp::float32> var_174;
        wp::vec_t<3, wp::float32> var_175;
        const wp::float32 var_176 = 0.5;
        wp::vec_t<3, wp::float32> var_177;
        wp::vec_t<3, wp::float32> var_178;
        wp::float32 var_179;
        wp::float32 var_180;
        wp::float32 var_181;
        wp::float32 var_182;
        const bool var_183 = false;
        const wp::float32 var_184 = 0.0;
        wp::float32 var_185;
        const bool var_186 = false;
        bool var_187;
        const bool var_188 = true;
        wp::float32* var_189;
        wp::float32 var_190;
        wp::float32 var_191;
        bool var_192;
        wp::float32 var_193;
        wp::float32 var_194;
        wp::float32 var_195;
        wp::vec_t<2, wp::int32>* var_196;
        wp::vec_t<2, wp::int32> var_197;
        wp::vec_t<2, wp::int32> var_198;
        wp::int32 var_199;
        wp::int32 var_200;
        const wp::int32 var_201 = 1;
        wp::int32 var_202;
        wp::int32 var_203;
        wp::int32 var_204;
        wp::int32 var_205;
        wp::int32 var_206;
        const wp::int32 var_207 = 0;
        const wp::int32 var_208 = 0;
        bool var_209;
        bool var_210;
        wp::vec_t<3, wp::float32>* var_211;
        wp::vec_t<3, wp::float32> var_212;
        wp::vec_t<3, wp::float32> var_213;
        wp::vec_t<3, wp::float32>* var_214;
        wp::vec_t<3, wp::float32> var_215;
        wp::vec_t<3, wp::float32> var_216;
        const wp::int32 var_217 = 0;
        wp::int32 var_218;
        bool var_219;
        wp::int32 var_220;
        bool var_221;
        const wp::int32 var_222 = 0;
        wp::int32 var_223;
        bool var_224;
        wp::int32 var_225;
        bool var_226;
        const wp::int32 var_227 = 0;
        wp::int32 var_228;
        wp::int32 var_229;
        const bool var_230 = false;
        const wp::float32 var_231 = 0.0;
        wp::float32 var_232;
        bool var_233;
        const bool var_234 = false;
        wp::vec_t<3, wp::float32> var_235;
        wp::vec_t<3, wp::float32> var_236;
        wp::vec_t<3, wp::float32> var_237;
        wp::vec_t<3, wp::float32> var_238;
        wp::vec_t<3, wp::float32> var_239;
        wp::float32 var_240;
        wp::float32 var_241;
        wp::float32 var_242;
        bool var_243;
        const wp::float32 var_244 = 1.01;
        wp::float32 var_245;
        wp::float32 var_246;
        bool var_247;
        wp::float32 var_248;
        wp::vec_t<3, wp::float32> var_249;
        wp::vec_t<3, wp::float32> var_250;
        wp::vec_t<3, wp::float32> var_251;
        wp::float32 var_252;
        wp::float32 var_253;
        bool var_254;
        const bool var_255 = false;
        wp::float32 var_256;
        bool var_257;
        bool var_258;
        wp::float32 var_259;
        bool var_260;
        wp::float32 var_261;
        bool var_262;
        wp::float32 var_263;
        bool var_264;
        wp::float32 var_265;
        EdgeCullResult_d4aae4ab var_266;
        wp::int32 var_267;
        const wp::int32 var_268 = 0;
        wp::int32 var_269;
        const wp::int32 var_270 = 0;
        wp::int32 var_271;
        const wp::int32 var_272 = 0;
        bool var_273;
        wp::int32 var_274;
        const wp::int32 var_275 = 0;
        bool var_276;
        EdgeCullResult_d4aae4ab var_277;
        wp::int32 var_278;
        wp::int32* var_279;
        wp::int32 var_280;
        wp::int32 var_281;
        wp::float32* var_282;
        wp::float32 var_283;
        wp::float32 var_284;
        const wp::int32 var_285 = 0;
        bool var_286;
        const bool var_287 = false;
        wp::vec_t<3, wp::float32> var_288;
        wp::vec_t<3, wp::float32> var_289;
        wp::vec_t<3, wp::float32> var_290;
        wp::vec_t<3, wp::float32> var_291;
        wp::float32 var_292;
        wp::vec_t<3, wp::float32> var_293;
        wp::float32 var_294;
        wp::vec_t<3, wp::float32> var_295;
        wp::float32 var_296;
        wp::float32 var_297;
        bool var_298;
        bool var_299;
        bool var_300;
        const bool var_301 = false;
        const wp::float32 var_302 = 100000000000.0;
        wp::float32 var_303;
        wp::vec_t<3, wp::float32> var_304;
        wp::vec_t<3, wp::float32> var_305;
        wp::float32 var_306;
        wp::vec_t<3, wp::float32> var_307;
        wp::float32 var_308;
        wp::vec_t<3, wp::float32> var_309;
        wp::vec_t<3, wp::float32> var_310;
        wp::vec_t<3, wp::float32> var_311;
        wp::vec_t<3, wp::float32> var_312;
        wp::float32 var_313;
        const wp::float32 var_314 = 0.0;
        bool var_315;
        wp::vec_t<3, wp::float32> var_316;
        wp::vec_t<3, wp::float32> var_317;
        wp::vec_t<3, wp::float32> var_318;
        wp::float32 var_319;
        const wp::float32 var_320 = 0.0;
        bool var_321;
        wp::vec_t<3, wp::float32> var_322;
        const wp::float32 var_323 = 0.0;
        const wp::float32 var_324 = 1.0;
        const wp::float32 var_325 = 0.0;
        wp::vec_t<3, wp::float32> var_326;
        wp::vec_t<3, wp::float32> var_327;
        wp::vec_t<3, wp::float32> var_328;
        const wp::int32 var_329 = 0;
        bool var_330;
        wp::vec_t<3, wp::float32> var_331;
        wp::vec_t<3, wp::float32> var_332;
        wp::float32 var_333;
        wp::float32 var_334;
        wp::float32 var_335;
        wp::float32 var_336;
        wp::float32 var_337;
        wp::float32 var_338;
        const wp::int32 var_339 = 0;
        wp::int32 var_340;
        const wp::int32 var_341 = 1;
        wp::int32 var_342;
        const wp::int32 var_343 = 2;
        wp::int32 var_344;
        const wp::int32 var_345 = 1;
        wp::int32 var_346;
        wp::int32 var_347;
        wp::vec_t<3, wp::float32> var_348;
        wp::float32 var_349;
        wp::int32 var_350;
        wp::float32 var_351;
        //---------
        // forward
        // def mesh_sdf_collision_global_reduce_kernel(                                           <L 1344>
        // block_id, t = wp.tid()                                                                 <L 1376>
        builtin_tid2d(var_0, var_1);
        // pair_count = wp.min(shape_pairs_mesh_mesh_count[0], shape_pairs_mesh_mesh.shape[0])       <L 1377>
        var_3 = wp::address(var_shape_pairs_mesh_mesh_count, var_2);
        var_4 = &(var_shape_pairs_mesh_mesh.shape);
        var_7 = wp::load(var_4);
        var_6 = wp::extract(var_7, var_5);
        var_9 = wp::load(var_3);
        var_8 = wp::min(var_9, var_6);
        // total_combos = block_offsets[pair_count]                                               <L 1378>
        var_10 = wp::address(var_block_offsets, var_8);
        var_12 = wp::load(var_10);
        var_11 = wp::copy(var_12);
        // edge_stack = wp.tile_stack(capacity=STACK_CAPACITY, dtype=EdgeCullResult)              <L 1380>
        var_14 = wp::tile_stack_init<EdgeCullResult_d4aae4ab, 512>();
        // progress = wp.tile_zeros(shape=1, dtype=int, storage="shared")                         <L 1385>
        var_17 = wp::tile_zeros<int, 1>();
        // for combo_idx in range(block_id, total_combos, total_num_blocks):                      <L 1387>
        var_18 = wp::range(var_0, var_11, var_total_num_blocks);
        start_for_0:;
            if (iter_cmp(var_18) == 0) goto end_for_0;
            var_19 = wp::iter_next(var_18);
            // lo = int(0)                                                                        <L 1388>
            var_21 = wp::int(var_20);
            // hi = int(pair_count)                                                               <L 1389>
            var_22 = wp::int(var_8);
            // while lo < hi:                                                                     <L 1390>
        start_while_2:;
            var_23 = (var_21 < var_22);
        if ((var_23) == false) goto end_while_2;
                // mid = (lo + hi) // 2                                                           <L 1391>
                var_24 = wp::add(var_21, var_22);
                var_26 = wp::floordiv(var_24, var_25);
                // if block_offsets[mid + 1] <= combo_idx:                                        <L 1392>
                var_28 = wp::add(var_26, var_27);
                var_29 = wp::address(var_block_offsets, var_28);
                var_31 = wp::load(var_29);
                var_30 = (var_31 <= var_19);
                if (var_30) {
                    // lo = mid + 1                                                               <L 1393>
                    var_33 = wp::add(var_26, var_32);
                }
                if (!var_30) {
                    // hi = mid                                                                   <L 1395>
                    var_34 = wp::copy(var_26);
                }
                var_35 = wp::where(var_30, var_33, var_21);
                var_36 = wp::where(var_30, var_22, var_34);
                wp::assign(var_21, var_35);
                wp::assign(var_22, var_36);
        goto start_while_2;
        end_while_2:;
            // pair_idx = int(lo)                                                                 <L 1396>
            var_37 = wp::int(var_21);
            // pair_block_start = block_offsets[pair_idx]                                         <L 1397>
            var_38 = wp::address(var_block_offsets, var_37);
            var_40 = wp::load(var_38);
            var_39 = wp::copy(var_40);
            // block_in_pair = combo_idx - pair_block_start                                       <L 1398>
            var_41 = wp::sub(var_19, var_39);
            // blocks_for_pair = block_offsets[pair_idx + 1] - pair_block_start                   <L 1399>
            var_43 = wp::add(var_37, var_42);
            var_44 = wp::address(var_block_offsets, var_43);
            var_46 = wp::load(var_44);
            var_45 = wp::sub(var_46, var_39);
            // pair_encoded = shape_pairs_mesh_mesh[pair_idx]                                     <L 1400>
            var_47 = wp::address(var_shape_pairs_mesh_mesh, var_37);
            var_49 = wp::load(var_47);
            var_48 = wp::copy(var_49);
            // if wp.static(enable_heightfields):                                                 <L 1401>
            // has_hfield = False                                                                 <L 1405>
            // pair = pair_encoded                                                                <L 1406>
            var_52 = wp::copy(var_48);
            // gap_sum = shape_gap[pair[0]] + shape_gap[pair[1]]                                  <L 1408>
            var_54 = wp::extract(var_52, var_53);
            var_55 = wp::address(var_shape_gap, var_54);
            var_57 = wp::extract(var_52, var_56);
            var_58 = wp::address(var_shape_gap, var_57);
            var_60 = wp::load(var_55);
            var_61 = wp::load(var_58);
            var_59 = wp::add(var_60, var_61);
            // for mode in range(2):                                                              <L 1410>
            var_63 = wp::range(var_62);
            start_for_4:;
                if (iter_cmp(var_63) == 0) goto end_for_4;
                var_64 = wp::iter_next(var_63);
                // tri_shape = pair[mode]                                                         <L 1411>
                var_65 = wp::extract(var_52, var_64);
                // sdf_shape = pair[1 - mode]                                                     <L 1412>
                var_67 = wp::sub(var_66, var_64);
                var_68 = wp::extract(var_52, var_67);
                // if wp.static(enable_heightfields):                                             <L 1414>
                // tri_is_hfield = False                                                          <L 1418>
                // sdf_is_hfield = False                                                          <L 1419>
                // tri_type = GeoType.HFIELD if tri_is_hfield else GeoType.MESH                   <L 1420>
                // mesh_id_tri = shape_source[tri_shape]                                          <L 1422>
                var_73 = wp::address(var_shape_source, var_65);
                var_75 = wp::load(var_73);
                var_74 = wp::copy(var_75);
                // mesh_id_sdf = shape_source[sdf_shape]                                          <L 1423>
                var_76 = wp::address(var_shape_source, var_68);
                var_78 = wp::load(var_76);
                var_77 = wp::copy(var_78);
                // if not tri_is_hfield and mesh_id_tri == wp.uint64(0):                          <L 1425>
                var_80 = wp::unot(var_70);
                var_79 = var_80;
                if (var_79) {
                    var_81 = 0ull;
                    var_82 = (var_74 == var_81);
                    var_79 = var_79 && var_82;
                }
                if (var_79) {
                    // continue                                                                   <L 1426>
                    goto start_for_4;
                }
                // hfd_tri = HeightfieldData()                                                    <L 1428>
                var_83 = HeightfieldData_f2b8d59a();
                // hfd_sdf = HeightfieldData()                                                    <L 1429>
                var_84 = HeightfieldData_f2b8d59a();
                // if wp.static(enable_heightfields):                                             <L 1430>
                // sdf_mesh_query_type = resolve_mesh_sign_method(shape_mesh_properties[sdf_shape])       <L 1435>
                var_86 = wp::address(var_shape_mesh_properties, var_68);
                var_88 = wp::load(var_86);
                var_87 = resolve_mesh_sign_method_0(var_88);
                // use_bvh_for_sdf = False                                                        <L 1437>
                // if not sdf_is_hfield:                                                          <L 1438>
                var_90 = wp::unot(var_71);
                if (var_90) {
                    // sdf_idx = shape_sdf_index[sdf_shape]                                       <L 1439>
                    var_91 = wp::address(var_shape_sdf_index, var_68);
                    var_93 = wp::load(var_91);
                    var_92 = wp::copy(var_93);
                    // use_bvh_for_sdf = sdf_idx < 0 or sdf_idx >= texture_sdf_table.shape[0]       <L 1440>
                    var_96 = (var_92 < var_95);
                    var_94 = var_96;
                    if (!var_94) {
                        var_97 = &(var_texture_sdf_table.shape);
                        var_100 = wp::load(var_97);
                        var_99 = wp::extract(var_100, var_98);
                        var_101 = (var_92 >= var_99);
                        var_94 = var_94 || var_101;
                    }
                    // if not use_bvh_for_sdf:                                                    <L 1441>
                    var_102 = wp::unot(var_94);
                    if (var_102) {
                        // use_bvh_for_sdf = texture_sdf_table[sdf_idx].coarse_texture.width == 0       <L 1442>
                        var_103 = wp::address(var_texture_sdf_table, var_92);
                        var_104 = &(((*wp::address(var_texture_sdf_table, var_92))).coarse_texture);
                        var_105 = &((((*wp::address(var_texture_sdf_table, var_92))).coarse_texture).width);
                        var_108 = wp::load(var_105);
                        var_107 = (var_108 == var_106);
                    }
                    var_109 = wp::where(var_102, var_107, var_94);
                    // if use_bvh_for_sdf and mesh_id_sdf == wp.uint64(0):                        <L 1443>
                    var_110 = var_109;
                    if (var_110) {
                        var_111 = 0ull;
                        var_112 = (var_77 == var_111);
                        var_110 = var_110 && var_112;
                    }
                    if (var_110) {
                        // continue                                                               <L 1444>
                        goto start_for_4;
                    }
                }
                var_113 = wp::where(var_90, var_109, var_89);
                // scale_data_tri = shape_data[tri_shape]                                         <L 1446>
                var_114 = wp::address(var_shape_data, var_65);
                var_116 = wp::load(var_114);
                var_115 = wp::copy(var_116);
                // scale_data_sdf = shape_data[sdf_shape]                                         <L 1447>
                var_117 = wp::address(var_shape_data, var_68);
                var_119 = wp::load(var_117);
                var_118 = wp::copy(var_119);
                // mesh_scale_tri = wp.vec3(scale_data_tri[0], scale_data_tri[1], scale_data_tri[2])       <L 1448>
                var_121 = wp::extract(var_115, var_120);
                var_123 = wp::extract(var_115, var_122);
                var_125 = wp::extract(var_115, var_124);
                var_126 = wp::vec_t<3, wp::float32>(var_121, var_123, var_125);
                // mesh_scale_sdf = wp.vec3(scale_data_sdf[0], scale_data_sdf[1], scale_data_sdf[2])       <L 1449>
                var_128 = wp::extract(var_118, var_127);
                var_130 = wp::extract(var_118, var_129);
                var_132 = wp::extract(var_118, var_131);
                var_133 = wp::vec_t<3, wp::float32>(var_128, var_130, var_132);
                // X_tri_ws = shape_transform[tri_shape]                                          <L 1451>
                var_134 = wp::address(var_shape_transform, var_65);
                var_136 = wp::load(var_134);
                var_135 = wp::copy(var_136);
                // X_sdf_ws = shape_transform[sdf_shape]                                          <L 1452>
                var_137 = wp::address(var_shape_transform, var_68);
                var_139 = wp::load(var_137);
                var_138 = wp::copy(var_139);
                // X_ws_tri = wp.transform_inverse(X_tri_ws)                                      <L 1453>
                var_140 = wp::transform_inverse(var_135);
                // aabb_lower_tri = shape_collision_aabb_lower[tri_shape]                         <L 1455>
                var_141 = wp::address(var_shape_collision_aabb_lower, var_65);
                var_143 = wp::load(var_141);
                var_142 = wp::copy(var_143);
                // aabb_upper_tri = shape_collision_aabb_upper[tri_shape]                         <L 1456>
                var_144 = wp::address(var_shape_collision_aabb_upper, var_65);
                var_146 = wp::load(var_144);
                var_145 = wp::copy(var_146);
                // voxel_res_tri = shape_voxel_resolution[tri_shape]                              <L 1457>
                var_147 = wp::address(var_shape_voxel_resolution, var_65);
                var_149 = wp::load(var_147);
                var_148 = wp::copy(var_149);
                // texture_sdf = TextureSDFData()                                                 <L 1459>
                var_150 = TextureSDFData_9ae3a59e();
                // if sdf_is_hfield:                                                              <L 1460>
                // sdf_scale = mesh_scale_sdf                                                     <L 1463>
                var_151 = wp::copy(var_133);
                // if not use_bvh_for_sdf:                                                        <L 1464>
                var_152 = wp::unot(var_113);
                if (var_152) {
                    // texture_sdf = texture_sdf_table[sdf_idx]                                   <L 1465>
                    var_153 = wp::address(var_texture_sdf_table, var_92);
                    var_155 = wp::load(var_153);
                    var_154 = wp::copy(var_155);
                    // if texture_sdf.scale_baked:                                                <L 1466>
                    var_156 = &((var_154).scale_baked);
                    var_157 = wp::load(var_156);
                    if (var_157) {
                        // sdf_scale = wp.vec3(1.0, 1.0, 1.0)                                     <L 1467>
                        var_161 = wp::vec_t<3, wp::float32>(var_158, var_159, var_160);
                    }
                    var_162 = wp::load(var_156);
                    var_164 = wp::load(var_156);
                    var_163 = wp::where(var_164, var_161, var_151);
                }
                var_165 = wp::where(var_152, var_154, var_150);
                var_166 = wp::where(var_152, var_163, var_151);
                // X_mesh_to_sdf = wp.transform_multiply(wp.transform_inverse(X_sdf_ws), X_tri_ws)       <L 1469>
                var_167 = wp::transform_inverse(var_138);
                var_168 = wp::transform_multiply(var_167, var_135);
                // triangle_mesh_margin = scale_data_tri[3]                                       <L 1471>
                var_170 = wp::extract(var_115, var_169);
                // sdf_mesh_margin = scale_data_sdf[3]                                            <L 1472>
                var_172 = wp::extract(var_118, var_171);
                // midpoint = (wp.transform_get_translation(X_tri_ws) + wp.transform_get_translation(X_sdf_ws)) * 0.5       <L 1474>
                var_173 = wp::transform_get_translation(var_135);
                var_174 = wp::transform_get_translation(var_138);
                var_175 = wp::add(var_173, var_174);
                var_177 = wp::mul(var_175, var_176);
                // inv_sdf_scale, min_sdf_scale = safe_sdf_scale_inverse(sdf_scale)               <L 1476>
                safe_sdf_scale_inverse_0(var_166, var_178, var_179);
                // contact_threshold = gap_sum + triangle_mesh_margin + sdf_mesh_margin           <L 1478>
                var_180 = wp::add(var_59, var_170);
                var_181 = wp::add(var_180, var_172);
                // contact_threshold_unscaled = contact_threshold / min_sdf_scale                 <L 1479>
                var_182 = wp::div(var_181, var_179);
                // use_texture_sdf_for_search = False                                             <L 1480>
                // texture_voxel_radius = float(0.0)                                              <L 1481>
                var_185 = wp::float(var_184);
                // if wp.static(enable_heightfields):                                             <L 1482>
                // elif not use_bvh_for_sdf:                                                      <L 1486>
                var_187 = wp::unot(var_113);
                if (var_187) {
                    // use_texture_sdf_for_search = True                                          <L 1487>
                    // texture_voxel_radius = texture_sdf.voxel_radius                            <L 1488>
                    var_189 = &((var_165).voxel_radius);
                    var_191 = wp::load(var_189);
                    var_190 = wp::copy(var_191);
                }
                var_192 = wp::where(var_187, var_188, var_183);
                var_193 = wp::where(var_187, var_190, var_185);
                // search_precision_unscaled = mesh_sdf_contact_search_precision(                 <L 1489>
                // triangle_mesh_margin + sdf_mesh_margin,                                        <L 1490>
                var_194 = wp::add(var_170, var_172);
                // min_sdf_scale,                                                                 <L 1491>
                // texture_voxel_radius,                                                          <L 1492>
                // use_texture_sdf_for_search,                                                    <L 1493>
                var_195 = mesh_sdf_contact_search_precision_0(var_194, var_179, var_193, var_192);
                // edge_range_tri = shape_edge_range[tri_shape]                                   <L 1496>
                var_196 = wp::address(var_shape_edge_range, var_65);
                var_198 = wp::load(var_196);
                var_197 = wp::copy(var_198);
                // num_edges = get_edge_count(tri_type, edge_range_tri, hfd_tri)                  <L 1497>
                var_199 = get_edge_count_0(var_72, var_197, var_83);
                // chunk_size = (num_edges + blocks_for_pair - 1) // blocks_for_pair              <L 1498>
                var_200 = wp::add(var_199, var_45);
                var_202 = wp::sub(var_200, var_201);
                var_203 = wp::floordiv(var_202, var_45);
                // edge_start = block_in_pair * chunk_size                                        <L 1499>
                var_204 = wp::mul(var_41, var_203);
                // edge_end = wp.min(edge_start + chunk_size, num_edges)                          <L 1500>
                var_205 = wp::add(var_204, var_203);
                var_206 = wp::min(var_205, var_199);
                // wp.tile_scatter_masked(progress, 0, edge_start, t == 0)                        <L 1502>
                var_209 = (var_1 == var_208);
                wp::tile_scatter_masked(var_17, var_207, var_204, var_209);
                // sdf_is_heightfield = sdf_is_hfield                                             <L 1504>
                var_210 = wp::copy(var_71);
                // sdf_aabb_lower = texture_sdf.sdf_box_lower                                     <L 1505>
                var_211 = &((var_165).sdf_box_lower);
                var_213 = wp::load(var_211);
                var_212 = wp::copy(var_213);
                // sdf_aabb_upper = texture_sdf.sdf_box_upper                                     <L 1506>
                var_214 = &((var_165).sdf_box_upper);
                var_216 = wp::load(var_214);
                var_215 = wp::copy(var_216);
                // while wp.tile_extract(progress, 0) < edge_end:                                 <L 1513>
        start_while_6:;
                var_218 = wp::tile_extract(var_17, var_217);
                var_219 = (var_218 < var_206);
        if ((var_219) == false) goto end_while_6;
                    // capacity = wp.block_dim()                                                  <L 1514>
                    var_220 = builtin_block_dim();
                    // while wp.tile_extract(progress, 0) < edge_end and wp.tile_stack_count(edge_stack) < capacity:       <L 1515>
        start_while_8:;
                    var_223 = wp::tile_extract(var_17, var_222);
                    var_224 = (var_223 < var_206);
                    var_221 = var_224;
                    if (var_221) {
                        var_225 = wp::tile_stack_count(var_14);
                        var_226 = (var_225 < var_220);
                        var_221 = var_221 && var_226;
                    }
        if ((var_221) == false) goto end_while_8;
                        // base_edge_idx = wp.tile_extract(progress, 0)                           <L 1516>
                        var_228 = wp::tile_extract(var_17, var_227);
                        // edge_idx = base_edge_idx + t                                           <L 1517>
                        var_229 = wp::add(var_228, var_1);
                        // add_edge = False                                                       <L 1518>
                        // midpoint_sdf = float(0.0)                                              <L 1519>
                        var_232 = wp::float(var_231);
                        // if edge_idx < edge_end:                                                <L 1521>
                        var_233 = (var_229 < var_206);
                        if (var_233) {
                            // if wp.static(enable_heightfields):                                 <L 1522>
                            // v0_scaled, v1_scaled = get_edge_from_mesh(                         <L 1537>
                            // mesh_id_tri,                                                       <L 1538>
                            // mesh_edge_indices,                                                 <L 1539>
                            // edge_range_tri,                                                    <L 1540>
                            // mesh_scale_tri,                                                    <L 1541>
                            // X_mesh_to_sdf,                                                     <L 1542>
                            // edge_idx,                                                          <L 1543>
                            get_edge_from_mesh_0(var_74, var_mesh_edge_indices, var_197, var_126, var_168, var_229, var_235, var_236);
                            // v0_cull = wp.cw_mul(v0_scaled, inv_sdf_scale)                      <L 1545>
                            var_237 = wp::cw_mul(var_235, var_178);
                            // v1_cull = wp.cw_mul(v1_scaled, inv_sdf_scale)                      <L 1546>
                            var_238 = wp::cw_mul(var_236, var_178);
                            // bsphere_center, bsphere_radius = get_edge_bounding_sphere(v0_cull, v1_cull)       <L 1547>
                            get_edge_bounding_sphere_0(var_237, var_238, var_239, var_240);
                            // threshold = bsphere_radius + contact_threshold_unscaled            <L 1549>
                            var_241 = wp::add(var_240, var_182);
                            // if sdf_is_heightfield:                                             <L 1551>
                            if (var_210) {
                                // midpoint_sdf = sample_sdf_heightfield(hfd_sdf, heightfield_elevations, bsphere_center)       <L 1552>
                                var_242 = sample_sdf_heightfield_0(var_84, var_heightfield_elevations, var_239);
                                // add_edge = midpoint_sdf <= threshold                           <L 1553>
                                var_243 = (var_242 <= var_241);
                            }
                            if (!var_210) {
                                // elif use_bvh_for_sdf:                                          <L 1554>
                                if (var_113) {
                                    // midpoint_sdf = sample_sdf_using_mesh(                      <L 1555>
                                    // mesh_id_sdf,                                               <L 1556>
                                    // bsphere_center,                                            <L 1557>
                                    // _SDF_QUERY_RADIUS_SLACK * threshold,                       <L 1558>
                                    var_245 = wp::mul(var_244, var_241);
                                    // sdf_mesh_query_type,                                       <L 1559>
                                    var_246 = sample_sdf_using_mesh_0(var_77, var_239, var_245, var_87);
                                    // add_edge = midpoint_sdf <= threshold                       <L 1561>
                                    var_247 = (var_246 <= var_241);
                                }
                                if (!var_113) {
                                    // culling_radius = threshold                                 <L 1563>
                                    var_248 = wp::copy(var_241);
                                    // clamped = wp.min(wp.max(bsphere_center, sdf_aabb_lower), sdf_aabb_upper)       <L 1564>
                                    var_249 = wp::max(var_239, var_212);
                                    var_250 = wp::min(var_249, var_215);
                                    // aabb_dist_sq = wp.length_sq(bsphere_center - clamped)       <L 1565>
                                    var_251 = wp::sub(var_239, var_250);
                                    var_252 = wp::length_sq(var_251);
                                    // if aabb_dist_sq > culling_radius * culling_radius:         <L 1566>
                                    var_253 = wp::mul(var_248, var_248);
                                    var_254 = (var_252 > var_253);
                                    if (var_254) {
                                        // add_edge = False                                       <L 1567>
                                    }
                                    if (!var_254) {
                                        // midpoint_sdf = texture_sample_sdf(texture_sdf, bsphere_center)       <L 1569>
                                        var_256 = texture_sample_sdf_hw_0(var_165, var_239);
                                        // add_edge = midpoint_sdf <= culling_radius              <L 1570>
                                        var_257 = (var_256 <= var_248);
                                    }
                                    var_258 = wp::where(var_254, var_255, var_257);
                                    var_259 = wp::where(var_254, var_232, var_256);
                                }
                                var_260 = wp::where(var_113, var_247, var_258);
                                var_261 = wp::where(var_113, var_246, var_259);
                            }
                            var_262 = wp::where(var_210, var_243, var_260);
                            var_263 = wp::where(var_210, var_242, var_261);
                        }
                        var_264 = wp::where(var_233, var_262, var_230);
                        var_265 = wp::where(var_233, var_263, var_232);
                        // cull_result = EdgeCullResult()                                         <L 1572>
                        var_266 = EdgeCullResult_d4aae4ab();
                        // cull_result.edge_idx = edge_idx                                        <L 1573>
                        var_266.edge_idx = var_229;
                        // cull_result.midpoint_sdf = midpoint_sdf                                <L 1574>
                        var_266.midpoint_sdf = var_265;
                        // wp.tile_stack_push(edge_stack, cull_result, add_edge)                  <L 1575>
                        var_267 = wp::tile_stack_push(var_14, var_266, var_264);
                        // old_progress = wp.tile_extract(progress, 0)                            <L 1576>
                        var_269 = wp::tile_extract(var_17, var_268);
                        // wp.tile_scatter_masked(progress, 0, old_progress + capacity, t == 0)       <L 1577>
                        var_271 = wp::add(var_269, var_220);
                        var_273 = (var_1 == var_272);
                        wp::tile_scatter_masked(var_17, var_270, var_271, var_273);
        goto start_while_8;
        end_while_8:;
                    // while wp.tile_stack_count(edge_stack) > 0:                                 <L 1584>
        start_while_10:;
                    var_274 = wp::tile_stack_count(var_14);
                    var_276 = (var_274 > var_275);
        if ((var_276) == false) goto end_while_10;
                        // popped, edge_slot = wp.tile_stack_pop(edge_stack)                      <L 1585>
                        wp::tile_stack_pop(var_14, var_277, var_278);
                        // my_edge_idx = popped.edge_idx                                          <L 1586>
                        var_279 = &((var_277).edge_idx);
                        var_281 = wp::load(var_279);
                        var_280 = wp::copy(var_281);
                        // cached_sdf_val = popped.midpoint_sdf                                   <L 1587>
                        var_282 = &((var_277).midpoint_sdf);
                        var_284 = wp::load(var_282);
                        var_283 = wp::copy(var_284);
                        // has_edge = edge_slot >= 0                                              <L 1588>
                        var_286 = (var_278 >= var_285);
                        // if has_edge:                                                           <L 1590>
                        if (var_286) {
                            // if wp.static(enable_heightfields):                                 <L 1591>
                            // v0s, v1s = get_edge_from_mesh(                                     <L 1609>
                            // mesh_id_tri,                                                       <L 1610>
                            // mesh_edge_indices,                                                 <L 1611>
                            // edge_range_tri,                                                    <L 1612>
                            // mesh_scale_tri,                                                    <L 1613>
                            // X_mesh_to_sdf,                                                     <L 1614>
                            // my_edge_idx,                                                       <L 1615>
                            get_edge_from_mesh_0(var_74, var_mesh_edge_indices, var_197, var_126, var_168, var_280, var_288, var_289);
                            // v0 = wp.cw_mul(v0s, inv_sdf_scale)                                 <L 1617>
                            var_290 = wp::cw_mul(var_288, var_178);
                            // v1 = wp.cw_mul(v1s, inv_sdf_scale)                                 <L 1618>
                            var_291 = wp::cw_mul(var_289, var_178);
                            // dist_unscaled, point_unscaled = do_edge_sdf_collision(             <L 1620>
                            // texture_sdf,                                                       <L 1621>
                            // mesh_id_sdf,                                                       <L 1622>
                            // v0,                                                                <L 1623>
                            // v1,                                                                <L 1624>
                            // cached_sdf_val,                                                    <L 1625>
                            // use_bvh_for_sdf,                                                   <L 1626>
                            // sdf_mesh_query_type,                                               <L 1627>
                            // sdf_is_hfield,                                                     <L 1628>
                            // hfd_sdf,                                                           <L 1629>
                            // heightfield_elevations,                                            <L 1630>
                            // search_precision_unscaled,                                         <L 1631>
                            _create_sdf_contact_funcs__locals__do_edge_sdf_collision_func_0(var_165, var_77, var_290, var_291, var_283, var_113, var_87, var_71, var_84, var_heightfield_elevations, var_195, var_292, var_293);
                            // dist_approx = dist_unscaled * min_sdf_scale                        <L 1640>
                            var_294 = wp::mul(var_292, var_179);
                            // bsphere_center_inner, bsphere_radius_inner = get_edge_bounding_sphere(v0, v1)       <L 1641>
                            get_edge_bounding_sphere_0(var_290, var_291, var_295, var_296);
                            // inner_cull_consistent = mesh_sdf_contact_passes_inner_cull_consistency(       <L 1642>
                            // dist_approx,                                                       <L 1643>
                            // triangle_mesh_margin + sdf_mesh_margin,                            <L 1644>
                            var_297 = wp::add(var_170, var_172);
                            // cached_sdf_val,                                                    <L 1645>
                            // bsphere_center_inner,                                              <L 1646>
                            // bsphere_radius_inner,                                              <L 1647>
                            // sdf_aabb_lower,                                                    <L 1648>
                            // sdf_aabb_upper,                                                    <L 1649>
                            // min_sdf_scale,                                                     <L 1650>
                            // use_texture_sdf_for_search,                                        <L 1651>
                            var_298 = mesh_sdf_contact_passes_inner_cull_consistency_0(var_294, var_297, var_283, var_295, var_296, var_212, var_215, var_179, var_192);
                            // if dist_approx < contact_threshold and inner_cull_consistent:       <L 1653>
                            var_300 = (var_294 < var_181);
                            var_299 = var_300;
                            if (var_299) {
                                var_299 = var_299 && var_298;
                            }
                            if (var_299) {
                                // if wp.static(enable_heightfields):                             <L 1654>
                                // if use_bvh_for_sdf:                                            <L 1675>
                                if (var_113) {
                                    // dist_unscaled, direction_unscaled = sample_sdf_grad_using_mesh(       <L 1676>
                                    // mesh_id_sdf,                                               <L 1677>
                                    // point_unscaled,                                            <L 1678>
                                    // _MESH_QUERY_MAX_DIST,                                      <L 1679>
                                    // sdf_mesh_query_type,                                       <L 1680>
                                    sample_sdf_grad_using_mesh_0(var_77, var_293, var_302, var_87, var_303, var_304);
                                }
                                if (!var_113) {
                                    // direction_unscaled = texture_sample_sdf_grad_only_hw(       <L 1687>
                                    // texture_sdf, point_unscaled                                <L 1688>
                                    var_305 = texture_sample_sdf_grad_only_hw_0(var_165, var_293);
                                }
                                var_306 = wp::where(var_113, var_303, var_292);
                                var_307 = wp::where(var_113, var_304, var_305);
                                // dist, direction = scale_sdf_result_to_world(                   <L 1691>
                                // dist_unscaled, direction_unscaled, sdf_scale, inv_sdf_scale, min_sdf_scale       <L 1692>
                                scale_sdf_result_to_world_0(var_306, var_307, var_166, var_178, var_179, var_308, var_309);
                                // point = wp.cw_mul(point_unscaled, sdf_scale)                   <L 1694>
                                var_310 = wp::cw_mul(var_293, var_166);
                                // point_world = wp.transform_point(X_sdf_ws, point)              <L 1695>
                                var_311 = wp::transform_point(var_138, var_310);
                                // direction_world = wp.transform_vector(X_sdf_ws, direction)       <L 1697>
                                var_312 = wp::transform_vector(var_138, var_309);
                                // direction_len = wp.length(direction_world)                     <L 1698>
                                var_313 = wp::length(var_312);
                                // if direction_len > 0.0:                                        <L 1699>
                                var_315 = (var_313 > var_314);
                                if (var_315) {
                                    // direction_world = direction_world / direction_len          <L 1700>
                                    var_316 = wp::div(var_312, var_313);
                                }
                                if (!var_315) {
                                    // fallback_dir = point_world - wp.transform_get_translation(X_sdf_ws)       <L 1702>
                                    var_317 = wp::transform_get_translation(var_138);
                                    var_318 = wp::sub(var_311, var_317);
                                    // fallback_len = wp.length(fallback_dir)                     <L 1703>
                                    var_319 = wp::length(var_318);
                                    // if fallback_len > 0.0:                                     <L 1704>
                                    var_321 = (var_319 > var_320);
                                    if (var_321) {
                                        // direction_world = fallback_dir / fallback_len          <L 1705>
                                        var_322 = wp::div(var_318, var_319);
                                    }
                                    if (!var_321) {
                                        // direction_world = wp.vec3(0.0, 1.0, 0.0)               <L 1707>
                                        var_326 = wp::vec_t<3, wp::float32>(var_323, var_324, var_325);
                                    }
                                    var_327 = wp::where(var_321, var_322, var_326);
                                }
                                var_328 = wp::where(var_315, var_316, var_327);
                                // contact_normal = -direction_world if mode == 0 else direction_world       <L 1709>
                                var_330 = (var_64 == var_329);
                                if (var_330) {
                                    var_331 = wp::neg(var_328);
                                }
                                if (!var_330) {
                                }
                                var_332 = wp::where(var_330, var_331, var_328);
                                // margin_sum = triangle_mesh_margin + sdf_mesh_margin            <L 1710>
                                var_333 = wp::add(var_170, var_172);
                                // inner_spatial_depth = margin_sum                               <L 1711>
                                var_334 = wp::copy(var_333);
                                // if use_texture_sdf_for_search:                                 <L 1712>
                                if (var_192) {
                                    // inner_spatial_depth += wp.min(texture_voxel_radius * min_sdf_scale, gap_sum)       <L 1713>
                                    var_335 = wp::mul(var_193, var_179);
                                    var_336 = wp::min(var_335, var_59);
                                    var_337 = wp::add(var_334, var_336);
                                }
                                var_338 = wp::where(var_192, var_337, var_334);
                                // export_and_reduce_contact_centered_two_spatial_depths(         <L 1714>
                                // pair[0],                                                       <L 1715>
                                var_340 = wp::extract(var_52, var_339);
                                // pair[1],                                                       <L 1716>
                                var_342 = wp::extract(var_52, var_341);
                                // point_world,                                                   <L 1717>
                                // contact_normal,                                                <L 1718>
                                // dist,                                                          <L 1719>
                                // (my_edge_idx << 2) | (mode << 1),                              <L 1720>
                                var_344 = wp::lshift(var_280, var_343);
                                var_346 = wp::lshift(var_64, var_345);
                                var_347 = wp::bit_or(var_344, var_346);
                                // point_world - midpoint,                                        <L 1721>
                                var_348 = wp::sub(var_311, var_177);
                                // inner_spatial_depth,                                           <L 1722>
                                // margin_sum + gap_sum,                                          <L 1723>
                                var_349 = wp::add(var_333, var_59);
                                // X_ws_tri,                                                      <L 1724>
                                // aabb_lower_tri,                                                <L 1725>
                                // aabb_upper_tri,                                                <L 1726>
                                // voxel_res_tri,                                                 <L 1727>
                                // reducer_data,                                                  <L 1728>
                                var_350 = export_and_reduce_contact_centered_two_spatial_depths_0(var_340, var_342, var_311, var_332, var_308, var_347, var_348, var_338, var_349, var_140, var_142, var_145, var_148, var_reducer_data);
                            }
                            var_351 = wp::where(var_299, var_306, var_292);
                        }
        goto start_while_10;
        end_while_10:;
                    // wp.tile_stack_clear(edge_stack)                                            <L 1735>
                    wp::tile_stack_clear(var_14);
        goto start_while_6;
        end_while_6:;
                goto start_for_4;
            end_for_4:;
            goto start_for_0;
        end_for_0:;
    }
}

