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




// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:174
static CUDA_CALLABLE wp::vec_t<3, wp::int32> _id_to_xyz_0(
    wp::int32 var_idx,
    wp::int32 var_size_x,
    wp::int32 var_size_y)
{
    //---------
    // primal vars
    wp::int32 var_0;
    wp::int32 var_1;
    wp::int32 var_2;
    wp::int32 var_3;
    wp::int32 var_4;
    wp::int32 var_5;
    wp::int32 var_6;
    wp::int32 var_7;
    wp::vec_t<3, wp::int32> var_8;
    //---------
    // forward
    // def _id_to_xyz(idx: int, size_x: int, size_y: int) -> wp.vec3i:                        <L 175>
    // z = idx // (size_x * size_y)                                                           <L 177>
    var_0 = wp::mul(var_size_x, var_size_y);
    var_1 = wp::floordiv(var_idx, var_0);
    // rem = idx - z * size_x * size_y                                                        <L 178>
    var_2 = wp::mul(var_1, var_size_x);
    var_3 = wp::mul(var_2, var_size_y);
    var_4 = wp::sub(var_idx, var_3);
    // y = rem // size_x                                                                      <L 179>
    var_5 = wp::floordiv(var_4, var_size_x);
    // x = rem - y * size_x                                                                   <L 180>
    var_6 = wp::mul(var_5, var_size_x);
    var_7 = wp::sub(var_4, var_6);
    // return wp.vec3i(x, y, z)                                                               <L 181>
    var_8 = wp::vec_t<3, wp::int32>(var_7, var_5, var_1);
    return var_8;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_utils.py:658
static CUDA_CALLABLE wp::float32 get_distance_to_mesh_0(
    wp::uint64 var_mesh,
    wp::vec_t<3, wp::float32> var_point,
    wp::float32 var_max_dist,
    wp::float32 var_winding_threshold)
{
    //---------
    // primal vars
    const wp::float32 var_0 = 2.0;
    wp::mesh_query_point_t var_1;
    bool* var_2;
    bool var_3;
    wp::int32* var_4;
    wp::float32* var_5;
    wp::float32* var_6;
    wp::vec_t<3, wp::float32> var_7;
    wp::int32 var_8;
    wp::float32 var_9;
    wp::float32 var_10;
    wp::vec_t<3, wp::float32> var_11;
    wp::float32* var_12;
    wp::float32 var_13;
    wp::float32 var_14;
    const wp::float32 var_15 = 0.0;
    bool var_16;
    wp::float32 var_17;
    wp::float32 var_18;
    wp::float32 var_19;
    wp::float32 var_20;
    bool var_21;
    //---------
    // forward
    // def get_distance_to_mesh(mesh: wp.uint64, point: wp.vec3, max_dist: wp.float32, winding_threshold: wp.float32):       <L 659>
    // res = wp.mesh_query_point_sign_winding_number(mesh, point, max_dist, 2.0, winding_threshold)       <L 660>
    var_1 = wp::mesh_query_point_sign_winding_number(var_mesh, var_point, var_max_dist, var_0, var_winding_threshold);
    // if res.result:                                                                         <L 661>
    var_2 = &((var_1).result);
    var_3 = wp::load(var_2);
    if (var_3) {
        // closest = wp.mesh_eval_position(mesh, res.face, res.u, res.v)                      <L 662>
        var_4 = &((var_1).face);
        var_5 = &((var_1).u);
        var_6 = &((var_1).v);
        var_8 = wp::load(var_4);
        var_9 = wp::load(var_5);
        var_10 = wp::load(var_6);
        var_7 = wp::mesh_eval_position(var_mesh, var_8, var_9, var_10);
        // vec_to_surface = closest - point                                                   <L 663>
        var_11 = wp::sub(var_7, var_point);
        // sign = res.sign                                                                    <L 664>
        var_12 = &((var_1).sign);
        var_14 = wp::load(var_12);
        var_13 = wp::copy(var_14);
        // if winding_threshold < 0.0:                                                        <L 667>
        var_16 = (var_winding_threshold < var_15);
        if (var_16) {
            // sign = -sign                                                                   <L 668>
            var_17 = wp::neg(var_13);
        }
        var_18 = wp::where(var_16, var_17, var_13);
        // return sign * wp.length(vec_to_surface)                                            <L 669>
        var_19 = wp::length(var_11);
        var_20 = wp::mul(var_18, var_19);
        return var_20;
    }
    var_21 = wp::load(var_2);
    // return max_dist                                                                        <L 670>
    return var_max_dist;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:332
static CUDA_CALLABLE wp::float32 _create_source_kernels__locals__query_sdf_0(
    wp::uint64 var_mesh,
    wp::int32 var_shape_type,
    wp::vec_t<3, wp::float32> var_shape_scale,
    wp::vec_t<3, wp::float32> var_point,
    wp::float32 var_max_dist,
    wp::float32 var_winding_threshold)
{
    //---------
    // primal vars
    wp::float32 var_0;
    //---------
    // forward
    // def query_sdf(                                                                         <L 333>
    // return get_distance_to_mesh(mesh, point, max_dist, winding_threshold)                  <L 341>
    var_0 = get_distance_to_mesh_0(var_mesh, var_point, var_max_dist, var_winding_threshold);
    return var_0;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:168
static CUDA_CALLABLE wp::int32 _idx3d_0(
    wp::int32 var_x,
    wp::int32 var_y,
    wp::int32 var_z,
    wp::int32 var_size_x,
    wp::int32 var_size_y)
{
    //---------
    // primal vars
    wp::int32 var_0;
    wp::int32 var_1;
    wp::int32 var_2;
    wp::int32 var_3;
    wp::int32 var_4;
    //---------
    // forward
    // def _idx3d(x: int, y: int, z: int, size_x: int, size_y: int) -> int:                   <L 169>
    // return z * size_x * size_y + y * size_x + x                                            <L 171>
    var_0 = wp::mul(var_z, var_size_x);
    var_1 = wp::mul(var_0, var_size_y);
    var_2 = wp::mul(var_y, var_size_x);
    var_3 = wp::add(var_1, var_2);
    var_4 = wp::add(var_3, var_x);
    return var_4;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:203
static CUDA_CALLABLE wp::float32 _interp_coarse_sdf_0(
    wp::array_t<wp::float32> var_background_sdf,
    wp::int32 var_block_x,
    wp::int32 var_block_y,
    wp::int32 var_block_z,
    wp::int32 var_lx,
    wp::int32 var_ly,
    wp::int32 var_lz,
    wp::float32 var_inv_cells_per_subgrid,
    wp::int32 var_bg_size_x,
    wp::int32 var_bg_size_y,
    wp::int32 var_bg_size_z)
{
    //---------
    // primal vars
    wp::float32 var_0;
    wp::float32 var_1;
    wp::float32 var_2;
    wp::float32 var_3;
    wp::float32 var_4;
    wp::float32 var_5;
    wp::float32 var_6;
    wp::float32 var_7;
    wp::float32 var_8;
    wp::float32 var_9;
    wp::float32 var_10;
    wp::float32 var_11;
    wp::float32 var_12;
    wp::int32 var_13;
    const wp::int32 var_14 = 0;
    const wp::int32 var_15 = 2;
    wp::int32 var_16;
    wp::int32 var_17;
    wp::float32 var_18;
    wp::int32 var_19;
    const wp::int32 var_20 = 0;
    const wp::int32 var_21 = 2;
    wp::int32 var_22;
    wp::int32 var_23;
    wp::float32 var_24;
    wp::int32 var_25;
    const wp::int32 var_26 = 0;
    const wp::int32 var_27 = 2;
    wp::int32 var_28;
    wp::int32 var_29;
    wp::float32 var_30;
    wp::float32 var_31;
    const wp::float32 var_32 = 0.0;
    const wp::float32 var_33 = 1.0;
    wp::float32 var_34;
    wp::float32 var_35;
    wp::float32 var_36;
    const wp::float32 var_37 = 0.0;
    const wp::float32 var_38 = 1.0;
    wp::float32 var_39;
    wp::float32 var_40;
    wp::float32 var_41;
    const wp::float32 var_42 = 0.0;
    const wp::float32 var_43 = 1.0;
    wp::float32 var_44;
    wp::int32 var_45;
    wp::float32* var_46;
    wp::float32 var_47;
    wp::float32 var_48;
    const wp::int32 var_49 = 1;
    wp::int32 var_50;
    wp::int32 var_51;
    wp::float32* var_52;
    wp::float32 var_53;
    wp::float32 var_54;
    const wp::int32 var_55 = 1;
    wp::int32 var_56;
    wp::int32 var_57;
    wp::float32* var_58;
    wp::float32 var_59;
    wp::float32 var_60;
    const wp::int32 var_61 = 1;
    wp::int32 var_62;
    const wp::int32 var_63 = 1;
    wp::int32 var_64;
    wp::int32 var_65;
    wp::float32* var_66;
    wp::float32 var_67;
    wp::float32 var_68;
    const wp::int32 var_69 = 1;
    wp::int32 var_70;
    wp::int32 var_71;
    wp::float32* var_72;
    wp::float32 var_73;
    wp::float32 var_74;
    const wp::int32 var_75 = 1;
    wp::int32 var_76;
    const wp::int32 var_77 = 1;
    wp::int32 var_78;
    wp::int32 var_79;
    wp::float32* var_80;
    wp::float32 var_81;
    wp::float32 var_82;
    const wp::int32 var_83 = 1;
    wp::int32 var_84;
    const wp::int32 var_85 = 1;
    wp::int32 var_86;
    wp::int32 var_87;
    wp::float32* var_88;
    wp::float32 var_89;
    wp::float32 var_90;
    const wp::int32 var_91 = 1;
    wp::int32 var_92;
    const wp::int32 var_93 = 1;
    wp::int32 var_94;
    const wp::int32 var_95 = 1;
    wp::int32 var_96;
    wp::int32 var_97;
    wp::float32* var_98;
    wp::float32 var_99;
    wp::float32 var_100;
    const wp::float32 var_101 = 1.0;
    wp::float32 var_102;
    wp::float32 var_103;
    wp::float32 var_104;
    wp::float32 var_105;
    const wp::float32 var_106 = 1.0;
    wp::float32 var_107;
    wp::float32 var_108;
    wp::float32 var_109;
    wp::float32 var_110;
    const wp::float32 var_111 = 1.0;
    wp::float32 var_112;
    wp::float32 var_113;
    wp::float32 var_114;
    wp::float32 var_115;
    const wp::float32 var_116 = 1.0;
    wp::float32 var_117;
    wp::float32 var_118;
    wp::float32 var_119;
    wp::float32 var_120;
    const wp::float32 var_121 = 1.0;
    wp::float32 var_122;
    wp::float32 var_123;
    wp::float32 var_124;
    wp::float32 var_125;
    const wp::float32 var_126 = 1.0;
    wp::float32 var_127;
    wp::float32 var_128;
    wp::float32 var_129;
    wp::float32 var_130;
    const wp::float32 var_131 = 1.0;
    wp::float32 var_132;
    wp::float32 var_133;
    wp::float32 var_134;
    wp::float32 var_135;
    //---------
    // forward
    // def _interp_coarse_sdf(                                                                <L 204>
    // coarse_fx = float(block_x) + float(lx) * inv_cells_per_subgrid                         <L 218>
    var_0 = wp::float(var_block_x);
    var_1 = wp::float(var_lx);
    var_2 = wp::mul(var_1, var_inv_cells_per_subgrid);
    var_3 = wp::add(var_0, var_2);
    // coarse_fy = float(block_y) + float(ly) * inv_cells_per_subgrid                         <L 219>
    var_4 = wp::float(var_block_y);
    var_5 = wp::float(var_ly);
    var_6 = wp::mul(var_5, var_inv_cells_per_subgrid);
    var_7 = wp::add(var_4, var_6);
    // coarse_fz = float(block_z) + float(lz) * inv_cells_per_subgrid                         <L 220>
    var_8 = wp::float(var_block_z);
    var_9 = wp::float(var_lz);
    var_10 = wp::mul(var_9, var_inv_cells_per_subgrid);
    var_11 = wp::add(var_8, var_10);
    // x0 = wp.clamp(int(wp.floor(coarse_fx)), 0, bg_size_x - 2)                              <L 222>
    var_12 = wp::floor(var_3);
    var_13 = wp::int(var_12);
    var_16 = wp::sub(var_bg_size_x, var_15);
    var_17 = wp::clamp(var_13, var_14, var_16);
    // y0 = wp.clamp(int(wp.floor(coarse_fy)), 0, bg_size_y - 2)                              <L 223>
    var_18 = wp::floor(var_7);
    var_19 = wp::int(var_18);
    var_22 = wp::sub(var_bg_size_y, var_21);
    var_23 = wp::clamp(var_19, var_20, var_22);
    // z0 = wp.clamp(int(wp.floor(coarse_fz)), 0, bg_size_z - 2)                              <L 224>
    var_24 = wp::floor(var_11);
    var_25 = wp::int(var_24);
    var_28 = wp::sub(var_bg_size_z, var_27);
    var_29 = wp::clamp(var_25, var_26, var_28);
    // tx = wp.clamp(coarse_fx - float(x0), 0.0, 1.0)                                         <L 226>
    var_30 = wp::float(var_17);
    var_31 = wp::sub(var_3, var_30);
    var_34 = wp::clamp(var_31, var_32, var_33);
    // ty = wp.clamp(coarse_fy - float(y0), 0.0, 1.0)                                         <L 227>
    var_35 = wp::float(var_23);
    var_36 = wp::sub(var_7, var_35);
    var_39 = wp::clamp(var_36, var_37, var_38);
    // tz = wp.clamp(coarse_fz - float(z0), 0.0, 1.0)                                         <L 228>
    var_40 = wp::float(var_29);
    var_41 = wp::sub(var_11, var_40);
    var_44 = wp::clamp(var_41, var_42, var_43);
    // v000 = background_sdf[_idx3d(x0, y0, z0, bg_size_x, bg_size_y)]                        <L 230>
    var_45 = _idx3d_0(var_17, var_23, var_29, var_bg_size_x, var_bg_size_y);
    var_46 = wp::address(var_background_sdf, var_45);
    var_48 = wp::load(var_46);
    var_47 = wp::copy(var_48);
    // v100 = background_sdf[_idx3d(x0 + 1, y0, z0, bg_size_x, bg_size_y)]                    <L 231>
    var_50 = wp::add(var_17, var_49);
    var_51 = _idx3d_0(var_50, var_23, var_29, var_bg_size_x, var_bg_size_y);
    var_52 = wp::address(var_background_sdf, var_51);
    var_54 = wp::load(var_52);
    var_53 = wp::copy(var_54);
    // v010 = background_sdf[_idx3d(x0, y0 + 1, z0, bg_size_x, bg_size_y)]                    <L 232>
    var_56 = wp::add(var_23, var_55);
    var_57 = _idx3d_0(var_17, var_56, var_29, var_bg_size_x, var_bg_size_y);
    var_58 = wp::address(var_background_sdf, var_57);
    var_60 = wp::load(var_58);
    var_59 = wp::copy(var_60);
    // v110 = background_sdf[_idx3d(x0 + 1, y0 + 1, z0, bg_size_x, bg_size_y)]                <L 233>
    var_62 = wp::add(var_17, var_61);
    var_64 = wp::add(var_23, var_63);
    var_65 = _idx3d_0(var_62, var_64, var_29, var_bg_size_x, var_bg_size_y);
    var_66 = wp::address(var_background_sdf, var_65);
    var_68 = wp::load(var_66);
    var_67 = wp::copy(var_68);
    // v001 = background_sdf[_idx3d(x0, y0, z0 + 1, bg_size_x, bg_size_y)]                    <L 234>
    var_70 = wp::add(var_29, var_69);
    var_71 = _idx3d_0(var_17, var_23, var_70, var_bg_size_x, var_bg_size_y);
    var_72 = wp::address(var_background_sdf, var_71);
    var_74 = wp::load(var_72);
    var_73 = wp::copy(var_74);
    // v101 = background_sdf[_idx3d(x0 + 1, y0, z0 + 1, bg_size_x, bg_size_y)]                <L 235>
    var_76 = wp::add(var_17, var_75);
    var_78 = wp::add(var_29, var_77);
    var_79 = _idx3d_0(var_76, var_23, var_78, var_bg_size_x, var_bg_size_y);
    var_80 = wp::address(var_background_sdf, var_79);
    var_82 = wp::load(var_80);
    var_81 = wp::copy(var_82);
    // v011 = background_sdf[_idx3d(x0, y0 + 1, z0 + 1, bg_size_x, bg_size_y)]                <L 236>
    var_84 = wp::add(var_23, var_83);
    var_86 = wp::add(var_29, var_85);
    var_87 = _idx3d_0(var_17, var_84, var_86, var_bg_size_x, var_bg_size_y);
    var_88 = wp::address(var_background_sdf, var_87);
    var_90 = wp::load(var_88);
    var_89 = wp::copy(var_90);
    // v111 = background_sdf[_idx3d(x0 + 1, y0 + 1, z0 + 1, bg_size_x, bg_size_y)]            <L 237>
    var_92 = wp::add(var_17, var_91);
    var_94 = wp::add(var_23, var_93);
    var_96 = wp::add(var_29, var_95);
    var_97 = _idx3d_0(var_92, var_94, var_96, var_bg_size_x, var_bg_size_y);
    var_98 = wp::address(var_background_sdf, var_97);
    var_100 = wp::load(var_98);
    var_99 = wp::copy(var_100);
    // c00 = v000 * (1.0 - tx) + v100 * tx                                                    <L 239>
    var_102 = wp::sub(var_101, var_34);
    var_103 = wp::mul(var_47, var_102);
    var_104 = wp::mul(var_53, var_34);
    var_105 = wp::add(var_103, var_104);
    // c10 = v010 * (1.0 - tx) + v110 * tx                                                    <L 240>
    var_107 = wp::sub(var_106, var_34);
    var_108 = wp::mul(var_59, var_107);
    var_109 = wp::mul(var_67, var_34);
    var_110 = wp::add(var_108, var_109);
    // c01 = v001 * (1.0 - tx) + v101 * tx                                                    <L 241>
    var_112 = wp::sub(var_111, var_34);
    var_113 = wp::mul(var_73, var_112);
    var_114 = wp::mul(var_81, var_34);
    var_115 = wp::add(var_113, var_114);
    // c11 = v011 * (1.0 - tx) + v111 * tx                                                    <L 242>
    var_117 = wp::sub(var_116, var_34);
    var_118 = wp::mul(var_89, var_117);
    var_119 = wp::mul(var_99, var_34);
    var_120 = wp::add(var_118, var_119);
    // c0 = c00 * (1.0 - ty) + c10 * ty                                                       <L 243>
    var_122 = wp::sub(var_121, var_39);
    var_123 = wp::mul(var_105, var_122);
    var_124 = wp::mul(var_110, var_39);
    var_125 = wp::add(var_123, var_124);
    // c1 = c01 * (1.0 - ty) + c11 * ty                                                       <L 244>
    var_127 = wp::sub(var_126, var_39);
    var_128 = wp::mul(var_115, var_127);
    var_129 = wp::mul(var_120, var_39);
    var_130 = wp::add(var_128, var_129);
    // return c0 * (1.0 - tz) + c1 * tz                                                       <L 245>
    var_132 = wp::sub(var_131, var_44);
    var_133 = wp::mul(var_125, var_132);
    var_134 = wp::mul(var_130, var_44);
    var_135 = wp::add(var_133, var_134);
    return var_135;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:256
static CUDA_CALLABLE wp::vec_t<3, wp::int32> _write_subgrid_slot_0(
    wp::array_t<wp::uint32> var_subgrid_start_slots,
    wp::int32 var_address,
    wp::int32 var_tex_blocks_per_dim,
    wp::int32 var_block_x,
    wp::int32 var_block_y,
    wp::int32 var_block_z,
    wp::int32 var_local_sample)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::int32> var_0;
    const wp::int32 var_1 = 0;
    bool var_2;
    const wp::int32 var_3 = 0;
    wp::int32 var_4;
    wp::uint32 var_5;
    const wp::int32 var_6 = 1;
    wp::int32 var_7;
    wp::uint32 var_8;
    const wp::int32 var_9 = 10;
    wp::uint32 var_10;
    wp::uint32 var_11;
    wp::uint32 var_12;
    const wp::int32 var_13 = 2;
    wp::int32 var_14;
    wp::uint32 var_15;
    const wp::int32 var_16 = 20;
    wp::uint32 var_17;
    wp::uint32 var_18;
    wp::uint32 var_19;
    //---------
    // forward
    // def _write_subgrid_slot(                                                               <L 257>
    // addr_coords = _id_to_xyz(address, tex_blocks_per_dim, tex_blocks_per_dim)              <L 271>
    var_0 = _id_to_xyz_0(var_address, var_tex_blocks_per_dim, var_tex_blocks_per_dim);
    // if local_sample == 0:                                                                  <L 272>
    var_2 = (var_local_sample == var_1);
    if (var_2) {
        // start_slot = (                                                                     <L 273>
        // wp.uint32(addr_coords[0])                                                          <L 274>
        var_4 = wp::extract(var_0, var_3);
        var_5 = wp::uint32(var_4);
        // | (wp.uint32(addr_coords[1]) << wp.uint32(10))                                     <L 275>
        var_7 = wp::extract(var_0, var_6);
        var_8 = wp::uint32(var_7);
        var_10 = wp::uint32(var_9);
        var_11 = wp::lshift(var_8, var_10);
        var_12 = wp::bit_or(var_5, var_11);
        // | (wp.uint32(addr_coords[2]) << wp.uint32(20))                                     <L 276>
        var_14 = wp::extract(var_0, var_13);
        var_15 = wp::uint32(var_14);
        var_17 = wp::uint32(var_16);
        var_18 = wp::lshift(var_15, var_17);
        var_19 = wp::bit_or(var_12, var_18);
        // subgrid_start_slots[block_x, block_y, block_z] = start_slot                        <L 278>
        wp::array_store(var_subgrid_start_slots, var_block_x, var_block_y, var_block_z, var_19);
    }
    // return addr_coords                                                                     <L 279>
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:1007
static CUDA_CALLABLE wp::float32 _texture_sample_sdf_variant_0(
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
    const wp::float32 var_45 = 0.0;
    wp::float32 var_46;
    const wp::float32 var_47 = 0.0;
    wp::float32 var_48;
    const wp::float32 var_49 = 0.0;
    wp::float32 var_50;
    const wp::float32 var_51 = 0.0;
    wp::float32 var_52;
    const wp::float32 var_53 = 0.0;
    wp::float32 var_54;
    const wp::float32 var_55 = 0.0;
    wp::float32 var_56;
    const wp::float32 var_57 = 0.0;
    wp::float32 var_58;
    const bool var_59 = false;
    wp::float32* var_60;
    wp::float32 var_61;
    wp::float32 var_62;
    wp::float32* var_63;
    wp::float32 var_64;
    wp::float32 var_65;
    wp::float32* var_66;
    wp::float32 var_67;
    wp::float32 var_68;
    wp::uint32* var_69;
    const wp::uint32 var_70 = 4294967294u;
    bool var_71;
    wp::uint32 var_72;
    wp::int32* var_73;
    wp::float32 var_74;
    wp::int32 var_75;
    wp::int32* var_76;
    wp::float32 var_77;
    wp::int32 var_78;
    wp::int32* var_79;
    wp::float32 var_80;
    wp::int32 var_81;
    wp::int32* var_82;
    wp::float32 var_83;
    wp::int32 var_84;
    wp::float32* var_85;
    wp::float32 var_86;
    wp::float32 var_87;
    wp::int32* var_88;
    wp::float32 var_89;
    wp::int32 var_90;
    wp::float32* var_91;
    wp::float32 var_92;
    wp::float32 var_93;
    wp::int32* var_94;
    wp::float32 var_95;
    wp::int32 var_96;
    wp::float32* var_97;
    wp::float32 var_98;
    wp::float32 var_99;
    wp::vec_t<3, wp::float32> var_100;
    wp::float32* var_101;
    wp::vec_t<3, wp::float32> var_102;
    wp::float32 var_103;
    const wp::int32 var_104 = 0;
    wp::float32 var_105;
    wp::float32 var_106;
    const wp::int32 var_107 = 1;
    wp::float32 var_108;
    wp::float32 var_109;
    const wp::int32 var_110 = 2;
    wp::float32 var_111;
    wp::float32 var_112;
    wp::texture3d_t* var_113;
    const wp::float32 var_114 = 0.5;
    wp::float32 var_115;
    const wp::float32 var_116 = 0.5;
    wp::float32 var_117;
    const wp::float32 var_118 = 0.5;
    wp::float32 var_119;
    wp::vec_t<3, wp::float32> var_120;
    wp::vec_t<2, wp::float32> var_121;
    const wp::float32 var_122 = -1.0;
    wp::texture3d_t var_123;
    wp::texture3d_t* var_124;
    const wp::float32 var_125 = 0.5;
    wp::float32 var_126;
    const wp::float32 var_127 = 1.5;
    wp::float32 var_128;
    const wp::float32 var_129 = 0.5;
    wp::float32 var_130;
    wp::vec_t<3, wp::float32> var_131;
    wp::vec_t<2, wp::float32> var_132;
    const wp::float32 var_133 = -1.0;
    wp::texture3d_t var_134;
    wp::texture3d_t* var_135;
    const wp::float32 var_136 = 0.5;
    wp::float32 var_137;
    const wp::float32 var_138 = 0.5;
    wp::float32 var_139;
    const wp::float32 var_140 = 1.5;
    wp::float32 var_141;
    wp::vec_t<3, wp::float32> var_142;
    wp::vec_t<2, wp::float32> var_143;
    const wp::float32 var_144 = -1.0;
    wp::texture3d_t var_145;
    wp::texture3d_t* var_146;
    const wp::float32 var_147 = 0.5;
    wp::float32 var_148;
    const wp::float32 var_149 = 1.5;
    wp::float32 var_150;
    const wp::float32 var_151 = 1.5;
    wp::float32 var_152;
    wp::vec_t<3, wp::float32> var_153;
    wp::vec_t<2, wp::float32> var_154;
    const wp::float32 var_155 = -1.0;
    wp::texture3d_t var_156;
    const wp::int32 var_157 = 0;
    wp::float32 var_158;
    const wp::int32 var_159 = 1;
    wp::float32 var_160;
    const wp::int32 var_161 = 0;
    wp::float32 var_162;
    const wp::int32 var_163 = 1;
    wp::float32 var_164;
    const wp::int32 var_165 = 0;
    wp::float32 var_166;
    const wp::int32 var_167 = 1;
    wp::float32 var_168;
    const wp::int32 var_169 = 0;
    wp::float32 var_170;
    const wp::int32 var_171 = 1;
    wp::float32 var_172;
    wp::texture3d_t* var_173;
    const wp::float32 var_174 = 0.5;
    wp::float32 var_175;
    const wp::float32 var_176 = 0.5;
    wp::float32 var_177;
    const wp::float32 var_178 = 0.5;
    wp::float32 var_179;
    wp::vec_t<3, wp::float32> var_180;
    wp::float32 var_181;
    const wp::float32 var_182 = -1.0;
    wp::texture3d_t var_183;
    wp::texture3d_t* var_184;
    const wp::float32 var_185 = 1.5;
    wp::float32 var_186;
    const wp::float32 var_187 = 0.5;
    wp::float32 var_188;
    const wp::float32 var_189 = 0.5;
    wp::float32 var_190;
    wp::vec_t<3, wp::float32> var_191;
    wp::float32 var_192;
    const wp::float32 var_193 = -1.0;
    wp::texture3d_t var_194;
    wp::texture3d_t* var_195;
    const wp::float32 var_196 = 0.5;
    wp::float32 var_197;
    const wp::float32 var_198 = 1.5;
    wp::float32 var_199;
    const wp::float32 var_200 = 0.5;
    wp::float32 var_201;
    wp::vec_t<3, wp::float32> var_202;
    wp::float32 var_203;
    const wp::float32 var_204 = -1.0;
    wp::texture3d_t var_205;
    wp::texture3d_t* var_206;
    const wp::float32 var_207 = 1.5;
    wp::float32 var_208;
    const wp::float32 var_209 = 1.5;
    wp::float32 var_210;
    const wp::float32 var_211 = 0.5;
    wp::float32 var_212;
    wp::vec_t<3, wp::float32> var_213;
    wp::float32 var_214;
    const wp::float32 var_215 = -1.0;
    wp::texture3d_t var_216;
    wp::texture3d_t* var_217;
    const wp::float32 var_218 = 0.5;
    wp::float32 var_219;
    const wp::float32 var_220 = 0.5;
    wp::float32 var_221;
    const wp::float32 var_222 = 1.5;
    wp::float32 var_223;
    wp::vec_t<3, wp::float32> var_224;
    wp::float32 var_225;
    const wp::float32 var_226 = -1.0;
    wp::texture3d_t var_227;
    wp::texture3d_t* var_228;
    const wp::float32 var_229 = 1.5;
    wp::float32 var_230;
    const wp::float32 var_231 = 0.5;
    wp::float32 var_232;
    const wp::float32 var_233 = 1.5;
    wp::float32 var_234;
    wp::vec_t<3, wp::float32> var_235;
    wp::float32 var_236;
    const wp::float32 var_237 = -1.0;
    wp::texture3d_t var_238;
    wp::texture3d_t* var_239;
    const wp::float32 var_240 = 0.5;
    wp::float32 var_241;
    const wp::float32 var_242 = 1.5;
    wp::float32 var_243;
    const wp::float32 var_244 = 1.5;
    wp::float32 var_245;
    wp::vec_t<3, wp::float32> var_246;
    wp::float32 var_247;
    const wp::float32 var_248 = -1.0;
    wp::texture3d_t var_249;
    wp::texture3d_t* var_250;
    const wp::float32 var_251 = 1.5;
    wp::float32 var_252;
    const wp::float32 var_253 = 1.5;
    wp::float32 var_254;
    const wp::float32 var_255 = 1.5;
    wp::float32 var_256;
    wp::vec_t<3, wp::float32> var_257;
    wp::float32 var_258;
    const wp::float32 var_259 = -1.0;
    wp::texture3d_t var_260;
    wp::float32 var_261;
    wp::float32 var_262;
    wp::float32 var_263;
    wp::float32 var_264;
    wp::float32 var_265;
    wp::float32 var_266;
    wp::float32 var_267;
    wp::float32 var_268;
    const bool var_269 = true;
    wp::uint32* var_270;
    const wp::int32 var_271 = 1023;
    wp::uint32 var_272;
    wp::uint32 var_273;
    wp::uint32 var_274;
    wp::float32 var_275;
    wp::uint32* var_276;
    const wp::int32 var_277 = 10;
    wp::uint32 var_278;
    wp::uint32 var_279;
    wp::uint32 var_280;
    const wp::int32 var_281 = 1023;
    wp::uint32 var_282;
    wp::uint32 var_283;
    wp::float32 var_284;
    wp::uint32* var_285;
    const wp::int32 var_286 = 20;
    wp::uint32 var_287;
    wp::uint32 var_288;
    wp::uint32 var_289;
    const wp::int32 var_290 = 1023;
    wp::uint32 var_291;
    wp::uint32 var_292;
    wp::float32 var_293;
    wp::int32* var_294;
    wp::float32 var_295;
    wp::int32 var_296;
    wp::int32* var_297;
    wp::float32 var_298;
    wp::int32 var_299;
    wp::float32* var_300;
    wp::float32 var_301;
    wp::float32 var_302;
    wp::float32 var_303;
    wp::int32* var_304;
    wp::float32 var_305;
    wp::int32 var_306;
    wp::int32* var_307;
    wp::float32 var_308;
    wp::int32 var_309;
    wp::float32* var_310;
    wp::float32 var_311;
    wp::float32 var_312;
    wp::float32 var_313;
    wp::int32* var_314;
    wp::float32 var_315;
    wp::int32 var_316;
    wp::int32* var_317;
    wp::float32 var_318;
    wp::int32 var_319;
    wp::float32* var_320;
    wp::float32 var_321;
    wp::float32 var_322;
    wp::float32 var_323;
    wp::float32* var_324;
    wp::float32 var_325;
    wp::float32 var_326;
    wp::float32 var_327;
    const wp::float32 var_328 = 0.5;
    wp::float32 var_329;
    wp::float32* var_330;
    wp::float32 var_331;
    wp::float32 var_332;
    wp::float32 var_333;
    const wp::float32 var_334 = 0.5;
    wp::float32 var_335;
    wp::float32* var_336;
    wp::float32 var_337;
    wp::float32 var_338;
    wp::float32 var_339;
    const wp::float32 var_340 = 0.5;
    wp::float32 var_341;
    wp::texture3d_t* var_342;
    wp::vec_t<3, wp::float32> var_343;
    wp::vec_t<2, wp::float32> var_344;
    const wp::float32 var_345 = -1.0;
    wp::texture3d_t var_346;
    wp::texture3d_t* var_347;
    const wp::float32 var_348 = 1.0;
    wp::float32 var_349;
    wp::vec_t<3, wp::float32> var_350;
    wp::vec_t<2, wp::float32> var_351;
    const wp::float32 var_352 = -1.0;
    wp::texture3d_t var_353;
    wp::texture3d_t* var_354;
    const wp::float32 var_355 = 1.0;
    wp::float32 var_356;
    wp::vec_t<3, wp::float32> var_357;
    wp::vec_t<2, wp::float32> var_358;
    const wp::float32 var_359 = -1.0;
    wp::texture3d_t var_360;
    wp::texture3d_t* var_361;
    const wp::float32 var_362 = 1.0;
    wp::float32 var_363;
    const wp::float32 var_364 = 1.0;
    wp::float32 var_365;
    wp::vec_t<3, wp::float32> var_366;
    wp::vec_t<2, wp::float32> var_367;
    const wp::float32 var_368 = -1.0;
    wp::texture3d_t var_369;
    const wp::int32 var_370 = 0;
    wp::float32 var_371;
    const wp::int32 var_372 = 1;
    wp::float32 var_373;
    const wp::int32 var_374 = 0;
    wp::float32 var_375;
    const wp::int32 var_376 = 1;
    wp::float32 var_377;
    const wp::int32 var_378 = 0;
    wp::float32 var_379;
    const wp::int32 var_380 = 1;
    wp::float32 var_381;
    const wp::int32 var_382 = 0;
    wp::float32 var_383;
    const wp::int32 var_384 = 1;
    wp::float32 var_385;
    wp::texture3d_t* var_386;
    wp::vec_t<3, wp::float32> var_387;
    wp::float32 var_388;
    const wp::float32 var_389 = -1.0;
    wp::texture3d_t var_390;
    wp::texture3d_t* var_391;
    const wp::float32 var_392 = 1.0;
    wp::float32 var_393;
    wp::vec_t<3, wp::float32> var_394;
    wp::float32 var_395;
    const wp::float32 var_396 = -1.0;
    wp::texture3d_t var_397;
    wp::texture3d_t* var_398;
    const wp::float32 var_399 = 1.0;
    wp::float32 var_400;
    wp::vec_t<3, wp::float32> var_401;
    wp::float32 var_402;
    const wp::float32 var_403 = -1.0;
    wp::texture3d_t var_404;
    wp::texture3d_t* var_405;
    const wp::float32 var_406 = 1.0;
    wp::float32 var_407;
    const wp::float32 var_408 = 1.0;
    wp::float32 var_409;
    wp::vec_t<3, wp::float32> var_410;
    wp::float32 var_411;
    const wp::float32 var_412 = -1.0;
    wp::texture3d_t var_413;
    wp::texture3d_t* var_414;
    const wp::float32 var_415 = 1.0;
    wp::float32 var_416;
    wp::vec_t<3, wp::float32> var_417;
    wp::float32 var_418;
    const wp::float32 var_419 = -1.0;
    wp::texture3d_t var_420;
    wp::texture3d_t* var_421;
    const wp::float32 var_422 = 1.0;
    wp::float32 var_423;
    const wp::float32 var_424 = 1.0;
    wp::float32 var_425;
    wp::vec_t<3, wp::float32> var_426;
    wp::float32 var_427;
    const wp::float32 var_428 = -1.0;
    wp::texture3d_t var_429;
    wp::texture3d_t* var_430;
    const wp::float32 var_431 = 1.0;
    wp::float32 var_432;
    const wp::float32 var_433 = 1.0;
    wp::float32 var_434;
    wp::vec_t<3, wp::float32> var_435;
    wp::float32 var_436;
    const wp::float32 var_437 = -1.0;
    wp::texture3d_t var_438;
    wp::texture3d_t* var_439;
    const wp::float32 var_440 = 1.0;
    wp::float32 var_441;
    const wp::float32 var_442 = 1.0;
    wp::float32 var_443;
    const wp::float32 var_444 = 1.0;
    wp::float32 var_445;
    wp::vec_t<3, wp::float32> var_446;
    wp::float32 var_447;
    const wp::float32 var_448 = -1.0;
    wp::texture3d_t var_449;
    wp::float32 var_450;
    wp::float32 var_451;
    wp::float32 var_452;
    wp::float32 var_453;
    wp::float32 var_454;
    wp::float32 var_455;
    wp::float32 var_456;
    wp::float32 var_457;
    wp::float32 var_458;
    wp::float32 var_459;
    wp::float32 var_460;
    wp::float32 var_461;
    wp::float32 var_462;
    wp::float32 var_463;
    wp::float32 var_464;
    wp::float32 var_465;
    bool var_466;
    wp::float32 var_467;
    wp::float32 var_468;
    wp::float32 var_469;
    wp::vec_t<2, wp::float32> var_470;
    wp::vec_t<2, wp::float32> var_471;
    wp::vec_t<2, wp::float32> var_472;
    wp::vec_t<2, wp::float32> var_473;
    wp::float32 var_474;
    wp::float32 var_475;
    wp::float32 var_476;
    wp::float32 var_477;
    wp::float32 var_478;
    wp::float32 var_479;
    wp::float32 var_480;
    wp::float32 var_481;
    wp::float32 var_482;
    wp::float32 var_483;
    wp::float32 var_484;
    wp::float32 var_485;
    wp::float32 var_486;
    wp::float32 var_487;
    wp::float32 var_488;
    wp::float32 var_489;
    wp::float32 var_490;
    wp::float32 var_491;
    wp::float32 var_492;
    wp::float32 var_493;
    wp::float32 var_494;
    wp::float32 var_495;
    wp::float32* var_496;
    wp::float32 var_497;
    wp::float32 var_498;
    wp::float32* var_499;
    wp::float32 var_500;
    wp::float32 var_501;
    wp::float32 var_502;
    wp::float32 var_503;
    //---------
    // forward
    // def _texture_sample_sdf_variant(                                                       <L 1008>
    // clamped = wp.vec3(                                                                     <L 1032>
    // wp.clamp(local_pos[0], sdf.sdf_box_lower[0], sdf.sdf_box_upper[0]),                    <L 1033>
    var_1 = wp::extract(var_local_pos, var_0);
    var_2 = &((var_sdf).sdf_box_lower);
    var_5 = wp::load(var_2);
    var_4 = wp::extract(var_5, var_3);
    var_6 = &((var_sdf).sdf_box_upper);
    var_9 = wp::load(var_6);
    var_8 = wp::extract(var_9, var_7);
    var_10 = wp::clamp(var_1, var_4, var_8);
    // wp.clamp(local_pos[1], sdf.sdf_box_lower[1], sdf.sdf_box_upper[1]),                    <L 1034>
    var_12 = wp::extract(var_local_pos, var_11);
    var_13 = &((var_sdf).sdf_box_lower);
    var_16 = wp::load(var_13);
    var_15 = wp::extract(var_16, var_14);
    var_17 = &((var_sdf).sdf_box_upper);
    var_20 = wp::load(var_17);
    var_19 = wp::extract(var_20, var_18);
    var_21 = wp::clamp(var_12, var_15, var_19);
    // wp.clamp(local_pos[2], sdf.sdf_box_lower[2], sdf.sdf_box_upper[2]),                    <L 1035>
    var_23 = wp::extract(var_local_pos, var_22);
    var_24 = &((var_sdf).sdf_box_lower);
    var_27 = wp::load(var_24);
    var_26 = wp::extract(var_27, var_25);
    var_28 = &((var_sdf).sdf_box_upper);
    var_31 = wp::load(var_28);
    var_30 = wp::extract(var_31, var_29);
    var_32 = wp::clamp(var_23, var_26, var_30);
    var_33 = wp::vec_t<3, wp::float32>(var_10, var_21, var_32);
    // diff = local_pos - clamped                                                             <L 1037>
    var_34 = wp::sub(var_local_pos, var_33);
    // diff_sq = wp.dot(diff, diff)                                                           <L 1038>
    var_35 = wp::dot(var_34, var_34);
    // f = wp.cw_mul(clamped - sdf.sdf_box_lower, sdf.inv_sdf_dx)                             <L 1040>
    var_36 = &((var_sdf).sdf_box_lower);
    var_38 = wp::load(var_36);
    var_37 = wp::sub(var_33, var_38);
    var_39 = &((var_sdf).inv_sdf_dx);
    var_41 = wp::load(var_39);
    var_40 = wp::cw_mul(var_37, var_41);
    // loc = _locate_cell(sdf, f)                                                             <L 1041>
    var_42 = _locate_cell_0(var_sdf, var_40);
    // v000 = float(0.0)                                                                      <L 1043>
    var_44 = wp::float(var_43);
    // v100 = float(0.0)                                                                      <L 1044>
    var_46 = wp::float(var_45);
    // v010 = float(0.0)                                                                      <L 1045>
    var_48 = wp::float(var_47);
    // v110 = float(0.0)                                                                      <L 1046>
    var_50 = wp::float(var_49);
    // v001 = float(0.0)                                                                      <L 1047>
    var_52 = wp::float(var_51);
    // v101 = float(0.0)                                                                      <L 1048>
    var_54 = wp::float(var_53);
    // v011 = float(0.0)                                                                      <L 1049>
    var_56 = wp::float(var_55);
    // v111 = float(0.0)                                                                      <L 1050>
    var_58 = wp::float(var_57);
    // needs_scale = False                                                                    <L 1052>
    // tx = loc.tx                                                                            <L 1053>
    var_60 = &((var_42).tx);
    var_62 = wp::load(var_60);
    var_61 = wp::copy(var_62);
    // ty = loc.ty                                                                            <L 1054>
    var_63 = &((var_42).ty);
    var_65 = wp::load(var_63);
    var_64 = wp::copy(var_65);
    // tz = loc.tz                                                                            <L 1055>
    var_66 = &((var_42).tz);
    var_68 = wp::load(var_66);
    var_67 = wp::copy(var_68);
    // if loc.start_slot >= SLOT_LINEAR:                                                      <L 1057>
    var_69 = &((var_42).start_slot);
    var_72 = wp::load(var_69);
    var_71 = (var_72 >= var_70);
    if (var_71) {
        // cx = float(loc.x_base)                                                             <L 1058>
        var_73 = &((var_42).x_base);
        var_75 = wp::load(var_73);
        var_74 = wp::float(var_75);
        // cy = float(loc.y_base)                                                             <L 1059>
        var_76 = &((var_42).y_base);
        var_78 = wp::load(var_76);
        var_77 = wp::float(var_78);
        // cz = float(loc.z_base)                                                             <L 1060>
        var_79 = &((var_42).z_base);
        var_81 = wp::load(var_79);
        var_80 = wp::float(var_81);
        // coarse_f = wp.vec3(float(loc.ix) + loc.tx, float(loc.iy) + loc.ty, float(loc.iz) + loc.tz) * sdf.fine_to_coarse       <L 1061>
        var_82 = &((var_42).ix);
        var_84 = wp::load(var_82);
        var_83 = wp::float(var_84);
        var_85 = &((var_42).tx);
        var_87 = wp::load(var_85);
        var_86 = wp::add(var_83, var_87);
        var_88 = &((var_42).iy);
        var_90 = wp::load(var_88);
        var_89 = wp::float(var_90);
        var_91 = &((var_42).ty);
        var_93 = wp::load(var_91);
        var_92 = wp::add(var_89, var_93);
        var_94 = &((var_42).iz);
        var_96 = wp::load(var_94);
        var_95 = wp::float(var_96);
        var_97 = &((var_42).tz);
        var_99 = wp::load(var_97);
        var_98 = wp::add(var_95, var_99);
        var_100 = wp::vec_t<3, wp::float32>(var_86, var_92, var_98);
        var_101 = &((var_sdf).fine_to_coarse);
        var_103 = wp::load(var_101);
        var_102 = wp::mul(var_100, var_103);
        // tx = coarse_f[0] - cx                                                              <L 1062>
        var_105 = wp::extract(var_102, var_104);
        var_106 = wp::sub(var_105, var_74);
        // ty = coarse_f[1] - cy                                                              <L 1063>
        var_108 = wp::extract(var_102, var_107);
        var_109 = wp::sub(var_108, var_77);
        // tz = coarse_f[2] - cz                                                              <L 1064>
        var_111 = wp::extract(var_102, var_110);
        var_112 = wp::sub(var_111, var_80);
        // if paired_samples:                                                                 <L 1065>
        if (var_paired_samples) {
            // v00 = wp.texture_sample(sdf.coarse_texture, wp.vec3f(cx + 0.5, cy + 0.5, cz + 0.5), dtype=wp.vec2)       <L 1066>
            var_113 = &((var_sdf).coarse_texture);
            var_115 = wp::add(var_74, var_114);
            var_117 = wp::add(var_77, var_116);
            var_119 = wp::add(var_80, var_118);
            var_120 = wp::vec_t<3, wp::float32>(var_115, var_117, var_119);
            var_123 = wp::load(var_113);
            var_121 = wp::texture_sample<wp::vec_t<2, wp::float32>>(var_123, var_120, var_122);
            // v10 = wp.texture_sample(sdf.coarse_texture, wp.vec3f(cx + 0.5, cy + 1.5, cz + 0.5), dtype=wp.vec2)       <L 1067>
            var_124 = &((var_sdf).coarse_texture);
            var_126 = wp::add(var_74, var_125);
            var_128 = wp::add(var_77, var_127);
            var_130 = wp::add(var_80, var_129);
            var_131 = wp::vec_t<3, wp::float32>(var_126, var_128, var_130);
            var_134 = wp::load(var_124);
            var_132 = wp::texture_sample<wp::vec_t<2, wp::float32>>(var_134, var_131, var_133);
            // v01 = wp.texture_sample(sdf.coarse_texture, wp.vec3f(cx + 0.5, cy + 0.5, cz + 1.5), dtype=wp.vec2)       <L 1068>
            var_135 = &((var_sdf).coarse_texture);
            var_137 = wp::add(var_74, var_136);
            var_139 = wp::add(var_77, var_138);
            var_141 = wp::add(var_80, var_140);
            var_142 = wp::vec_t<3, wp::float32>(var_137, var_139, var_141);
            var_145 = wp::load(var_135);
            var_143 = wp::texture_sample<wp::vec_t<2, wp::float32>>(var_145, var_142, var_144);
            // v11 = wp.texture_sample(sdf.coarse_texture, wp.vec3f(cx + 0.5, cy + 1.5, cz + 1.5), dtype=wp.vec2)       <L 1069>
            var_146 = &((var_sdf).coarse_texture);
            var_148 = wp::add(var_74, var_147);
            var_150 = wp::add(var_77, var_149);
            var_152 = wp::add(var_80, var_151);
            var_153 = wp::vec_t<3, wp::float32>(var_148, var_150, var_152);
            var_156 = wp::load(var_146);
            var_154 = wp::texture_sample<wp::vec_t<2, wp::float32>>(var_156, var_153, var_155);
            // v000, v100 = v00[0], v00[1]                                                    <L 1070>
            var_158 = wp::extract(var_121, var_157);
            var_160 = wp::extract(var_121, var_159);
            // v010, v110 = v10[0], v10[1]                                                    <L 1071>
            var_162 = wp::extract(var_132, var_161);
            var_164 = wp::extract(var_132, var_163);
            // v001, v101 = v01[0], v01[1]                                                    <L 1072>
            var_166 = wp::extract(var_143, var_165);
            var_168 = wp::extract(var_143, var_167);
            // v011, v111 = v11[0], v11[1]                                                    <L 1073>
            var_170 = wp::extract(var_154, var_169);
            var_172 = wp::extract(var_154, var_171);
        }
        if (!var_paired_samples) {
            // v000 = wp.texture_sample(sdf.coarse_texture, wp.vec3f(cx + 0.5, cy + 0.5, cz + 0.5), dtype=float)       <L 1075>
            var_173 = &((var_sdf).coarse_texture);
            var_175 = wp::add(var_74, var_174);
            var_177 = wp::add(var_77, var_176);
            var_179 = wp::add(var_80, var_178);
            var_180 = wp::vec_t<3, wp::float32>(var_175, var_177, var_179);
            var_183 = wp::load(var_173);
            var_181 = wp::texture_sample<float>(var_183, var_180, var_182);
            // v100 = wp.texture_sample(sdf.coarse_texture, wp.vec3f(cx + 1.5, cy + 0.5, cz + 0.5), dtype=float)       <L 1076>
            var_184 = &((var_sdf).coarse_texture);
            var_186 = wp::add(var_74, var_185);
            var_188 = wp::add(var_77, var_187);
            var_190 = wp::add(var_80, var_189);
            var_191 = wp::vec_t<3, wp::float32>(var_186, var_188, var_190);
            var_194 = wp::load(var_184);
            var_192 = wp::texture_sample<float>(var_194, var_191, var_193);
            // v010 = wp.texture_sample(sdf.coarse_texture, wp.vec3f(cx + 0.5, cy + 1.5, cz + 0.5), dtype=float)       <L 1077>
            var_195 = &((var_sdf).coarse_texture);
            var_197 = wp::add(var_74, var_196);
            var_199 = wp::add(var_77, var_198);
            var_201 = wp::add(var_80, var_200);
            var_202 = wp::vec_t<3, wp::float32>(var_197, var_199, var_201);
            var_205 = wp::load(var_195);
            var_203 = wp::texture_sample<float>(var_205, var_202, var_204);
            // v110 = wp.texture_sample(sdf.coarse_texture, wp.vec3f(cx + 1.5, cy + 1.5, cz + 0.5), dtype=float)       <L 1078>
            var_206 = &((var_sdf).coarse_texture);
            var_208 = wp::add(var_74, var_207);
            var_210 = wp::add(var_77, var_209);
            var_212 = wp::add(var_80, var_211);
            var_213 = wp::vec_t<3, wp::float32>(var_208, var_210, var_212);
            var_216 = wp::load(var_206);
            var_214 = wp::texture_sample<float>(var_216, var_213, var_215);
            // v001 = wp.texture_sample(sdf.coarse_texture, wp.vec3f(cx + 0.5, cy + 0.5, cz + 1.5), dtype=float)       <L 1079>
            var_217 = &((var_sdf).coarse_texture);
            var_219 = wp::add(var_74, var_218);
            var_221 = wp::add(var_77, var_220);
            var_223 = wp::add(var_80, var_222);
            var_224 = wp::vec_t<3, wp::float32>(var_219, var_221, var_223);
            var_227 = wp::load(var_217);
            var_225 = wp::texture_sample<float>(var_227, var_224, var_226);
            // v101 = wp.texture_sample(sdf.coarse_texture, wp.vec3f(cx + 1.5, cy + 0.5, cz + 1.5), dtype=float)       <L 1080>
            var_228 = &((var_sdf).coarse_texture);
            var_230 = wp::add(var_74, var_229);
            var_232 = wp::add(var_77, var_231);
            var_234 = wp::add(var_80, var_233);
            var_235 = wp::vec_t<3, wp::float32>(var_230, var_232, var_234);
            var_238 = wp::load(var_228);
            var_236 = wp::texture_sample<float>(var_238, var_235, var_237);
            // v011 = wp.texture_sample(sdf.coarse_texture, wp.vec3f(cx + 0.5, cy + 1.5, cz + 1.5), dtype=float)       <L 1081>
            var_239 = &((var_sdf).coarse_texture);
            var_241 = wp::add(var_74, var_240);
            var_243 = wp::add(var_77, var_242);
            var_245 = wp::add(var_80, var_244);
            var_246 = wp::vec_t<3, wp::float32>(var_241, var_243, var_245);
            var_249 = wp::load(var_239);
            var_247 = wp::texture_sample<float>(var_249, var_246, var_248);
            // v111 = wp.texture_sample(sdf.coarse_texture, wp.vec3f(cx + 1.5, cy + 1.5, cz + 1.5), dtype=float)       <L 1082>
            var_250 = &((var_sdf).coarse_texture);
            var_252 = wp::add(var_74, var_251);
            var_254 = wp::add(var_77, var_253);
            var_256 = wp::add(var_80, var_255);
            var_257 = wp::vec_t<3, wp::float32>(var_252, var_254, var_256);
            var_260 = wp::load(var_250);
            var_258 = wp::texture_sample<float>(var_260, var_257, var_259);
        }
        var_261 = wp::where(var_paired_samples, var_158, var_181);
        var_262 = wp::where(var_paired_samples, var_160, var_192);
        var_263 = wp::where(var_paired_samples, var_162, var_203);
        var_264 = wp::where(var_paired_samples, var_164, var_214);
        var_265 = wp::where(var_paired_samples, var_166, var_225);
        var_266 = wp::where(var_paired_samples, var_168, var_236);
        var_267 = wp::where(var_paired_samples, var_170, var_247);
        var_268 = wp::where(var_paired_samples, var_172, var_258);
    }
    if (!var_71) {
        // needs_scale = True                                                                 <L 1084>
        // block_x = float(loc.start_slot & wp.uint32(0x3FF))                                 <L 1085>
        var_270 = &((var_42).start_slot);
        var_272 = wp::uint32(var_271);
        var_274 = wp::load(var_270);
        var_273 = wp::bit_and(var_274, var_272);
        var_275 = wp::float(var_273);
        // block_y = float((loc.start_slot >> wp.uint32(10)) & wp.uint32(0x3FF))              <L 1086>
        var_276 = &((var_42).start_slot);
        var_278 = wp::uint32(var_277);
        var_280 = wp::load(var_276);
        var_279 = wp::rshift(var_280, var_278);
        var_282 = wp::uint32(var_281);
        var_283 = wp::bit_and(var_279, var_282);
        var_284 = wp::float(var_283);
        // block_z = float((loc.start_slot >> wp.uint32(20)) & wp.uint32(0x3FF))              <L 1087>
        var_285 = &((var_42).start_slot);
        var_287 = wp::uint32(var_286);
        var_289 = wp::load(var_285);
        var_288 = wp::rshift(var_289, var_287);
        var_291 = wp::uint32(var_290);
        var_292 = wp::bit_and(var_288, var_291);
        var_293 = wp::float(var_292);
        // lx = float(loc.ix) - float(loc.x_base) * sdf.subgrid_size_f                        <L 1088>
        var_294 = &((var_42).ix);
        var_296 = wp::load(var_294);
        var_295 = wp::float(var_296);
        var_297 = &((var_42).x_base);
        var_299 = wp::load(var_297);
        var_298 = wp::float(var_299);
        var_300 = &((var_sdf).subgrid_size_f);
        var_302 = wp::load(var_300);
        var_301 = wp::mul(var_298, var_302);
        var_303 = wp::sub(var_295, var_301);
        // ly = float(loc.iy) - float(loc.y_base) * sdf.subgrid_size_f                        <L 1089>
        var_304 = &((var_42).iy);
        var_306 = wp::load(var_304);
        var_305 = wp::float(var_306);
        var_307 = &((var_42).y_base);
        var_309 = wp::load(var_307);
        var_308 = wp::float(var_309);
        var_310 = &((var_sdf).subgrid_size_f);
        var_312 = wp::load(var_310);
        var_311 = wp::mul(var_308, var_312);
        var_313 = wp::sub(var_305, var_311);
        // lz = float(loc.iz) - float(loc.z_base) * sdf.subgrid_size_f                        <L 1090>
        var_314 = &((var_42).iz);
        var_316 = wp::load(var_314);
        var_315 = wp::float(var_316);
        var_317 = &((var_42).z_base);
        var_319 = wp::load(var_317);
        var_318 = wp::float(var_319);
        var_320 = &((var_sdf).subgrid_size_f);
        var_322 = wp::load(var_320);
        var_321 = wp::mul(var_318, var_322);
        var_323 = wp::sub(var_315, var_321);
        // ox = block_x * sdf.subgrid_samples_f + lx + 0.5                                    <L 1091>
        var_324 = &((var_sdf).subgrid_samples_f);
        var_326 = wp::load(var_324);
        var_325 = wp::mul(var_275, var_326);
        var_327 = wp::add(var_325, var_303);
        var_329 = wp::add(var_327, var_328);
        // oy = block_y * sdf.subgrid_samples_f + ly + 0.5                                    <L 1092>
        var_330 = &((var_sdf).subgrid_samples_f);
        var_332 = wp::load(var_330);
        var_331 = wp::mul(var_284, var_332);
        var_333 = wp::add(var_331, var_313);
        var_335 = wp::add(var_333, var_334);
        // oz = block_z * sdf.subgrid_samples_f + lz + 0.5                                    <L 1093>
        var_336 = &((var_sdf).subgrid_samples_f);
        var_338 = wp::load(var_336);
        var_337 = wp::mul(var_293, var_338);
        var_339 = wp::add(var_337, var_323);
        var_341 = wp::add(var_339, var_340);
        // if paired_samples:                                                                 <L 1094>
        if (var_paired_samples) {
            // v00 = wp.texture_sample(sdf.subgrid_texture, wp.vec3f(ox, oy, oz), dtype=wp.vec2)       <L 1095>
            var_342 = &((var_sdf).subgrid_texture);
            var_343 = wp::vec_t<3, wp::float32>(var_329, var_335, var_341);
            var_346 = wp::load(var_342);
            var_344 = wp::texture_sample<wp::vec_t<2, wp::float32>>(var_346, var_343, var_345);
            // v10 = wp.texture_sample(sdf.subgrid_texture, wp.vec3f(ox, oy + 1.0, oz), dtype=wp.vec2)       <L 1096>
            var_347 = &((var_sdf).subgrid_texture);
            var_349 = wp::add(var_335, var_348);
            var_350 = wp::vec_t<3, wp::float32>(var_329, var_349, var_341);
            var_353 = wp::load(var_347);
            var_351 = wp::texture_sample<wp::vec_t<2, wp::float32>>(var_353, var_350, var_352);
            // v01 = wp.texture_sample(sdf.subgrid_texture, wp.vec3f(ox, oy, oz + 1.0), dtype=wp.vec2)       <L 1097>
            var_354 = &((var_sdf).subgrid_texture);
            var_356 = wp::add(var_341, var_355);
            var_357 = wp::vec_t<3, wp::float32>(var_329, var_335, var_356);
            var_360 = wp::load(var_354);
            var_358 = wp::texture_sample<wp::vec_t<2, wp::float32>>(var_360, var_357, var_359);
            // v11 = wp.texture_sample(sdf.subgrid_texture, wp.vec3f(ox, oy + 1.0, oz + 1.0), dtype=wp.vec2)       <L 1098>
            var_361 = &((var_sdf).subgrid_texture);
            var_363 = wp::add(var_335, var_362);
            var_365 = wp::add(var_341, var_364);
            var_366 = wp::vec_t<3, wp::float32>(var_329, var_363, var_365);
            var_369 = wp::load(var_361);
            var_367 = wp::texture_sample<wp::vec_t<2, wp::float32>>(var_369, var_366, var_368);
            // v000, v100 = v00[0], v00[1]                                                    <L 1099>
            var_371 = wp::extract(var_344, var_370);
            var_373 = wp::extract(var_344, var_372);
            // v010, v110 = v10[0], v10[1]                                                    <L 1100>
            var_375 = wp::extract(var_351, var_374);
            var_377 = wp::extract(var_351, var_376);
            // v001, v101 = v01[0], v01[1]                                                    <L 1101>
            var_379 = wp::extract(var_358, var_378);
            var_381 = wp::extract(var_358, var_380);
            // v011, v111 = v11[0], v11[1]                                                    <L 1102>
            var_383 = wp::extract(var_367, var_382);
            var_385 = wp::extract(var_367, var_384);
        }
        if (!var_paired_samples) {
            // v000 = wp.texture_sample(sdf.subgrid_texture, wp.vec3f(ox, oy, oz), dtype=float)       <L 1104>
            var_386 = &((var_sdf).subgrid_texture);
            var_387 = wp::vec_t<3, wp::float32>(var_329, var_335, var_341);
            var_390 = wp::load(var_386);
            var_388 = wp::texture_sample<float>(var_390, var_387, var_389);
            // v100 = wp.texture_sample(sdf.subgrid_texture, wp.vec3f(ox + 1.0, oy, oz), dtype=float)       <L 1105>
            var_391 = &((var_sdf).subgrid_texture);
            var_393 = wp::add(var_329, var_392);
            var_394 = wp::vec_t<3, wp::float32>(var_393, var_335, var_341);
            var_397 = wp::load(var_391);
            var_395 = wp::texture_sample<float>(var_397, var_394, var_396);
            // v010 = wp.texture_sample(sdf.subgrid_texture, wp.vec3f(ox, oy + 1.0, oz), dtype=float)       <L 1106>
            var_398 = &((var_sdf).subgrid_texture);
            var_400 = wp::add(var_335, var_399);
            var_401 = wp::vec_t<3, wp::float32>(var_329, var_400, var_341);
            var_404 = wp::load(var_398);
            var_402 = wp::texture_sample<float>(var_404, var_401, var_403);
            // v110 = wp.texture_sample(sdf.subgrid_texture, wp.vec3f(ox + 1.0, oy + 1.0, oz), dtype=float)       <L 1107>
            var_405 = &((var_sdf).subgrid_texture);
            var_407 = wp::add(var_329, var_406);
            var_409 = wp::add(var_335, var_408);
            var_410 = wp::vec_t<3, wp::float32>(var_407, var_409, var_341);
            var_413 = wp::load(var_405);
            var_411 = wp::texture_sample<float>(var_413, var_410, var_412);
            // v001 = wp.texture_sample(sdf.subgrid_texture, wp.vec3f(ox, oy, oz + 1.0), dtype=float)       <L 1108>
            var_414 = &((var_sdf).subgrid_texture);
            var_416 = wp::add(var_341, var_415);
            var_417 = wp::vec_t<3, wp::float32>(var_329, var_335, var_416);
            var_420 = wp::load(var_414);
            var_418 = wp::texture_sample<float>(var_420, var_417, var_419);
            // v101 = wp.texture_sample(sdf.subgrid_texture, wp.vec3f(ox + 1.0, oy, oz + 1.0), dtype=float)       <L 1109>
            var_421 = &((var_sdf).subgrid_texture);
            var_423 = wp::add(var_329, var_422);
            var_425 = wp::add(var_341, var_424);
            var_426 = wp::vec_t<3, wp::float32>(var_423, var_335, var_425);
            var_429 = wp::load(var_421);
            var_427 = wp::texture_sample<float>(var_429, var_426, var_428);
            // v011 = wp.texture_sample(sdf.subgrid_texture, wp.vec3f(ox, oy + 1.0, oz + 1.0), dtype=float)       <L 1110>
            var_430 = &((var_sdf).subgrid_texture);
            var_432 = wp::add(var_335, var_431);
            var_434 = wp::add(var_341, var_433);
            var_435 = wp::vec_t<3, wp::float32>(var_329, var_432, var_434);
            var_438 = wp::load(var_430);
            var_436 = wp::texture_sample<float>(var_438, var_435, var_437);
            // v111 = wp.texture_sample(sdf.subgrid_texture, wp.vec3f(ox + 1.0, oy + 1.0, oz + 1.0), dtype=float)       <L 1111>
            var_439 = &((var_sdf).subgrid_texture);
            var_441 = wp::add(var_329, var_440);
            var_443 = wp::add(var_335, var_442);
            var_445 = wp::add(var_341, var_444);
            var_446 = wp::vec_t<3, wp::float32>(var_441, var_443, var_445);
            var_449 = wp::load(var_439);
            var_447 = wp::texture_sample<float>(var_449, var_446, var_448);
        }
        var_450 = wp::where(var_paired_samples, var_371, var_388);
        var_451 = wp::where(var_paired_samples, var_373, var_395);
        var_452 = wp::where(var_paired_samples, var_375, var_402);
        var_453 = wp::where(var_paired_samples, var_377, var_411);
        var_454 = wp::where(var_paired_samples, var_379, var_418);
        var_455 = wp::where(var_paired_samples, var_381, var_427);
        var_456 = wp::where(var_paired_samples, var_383, var_436);
        var_457 = wp::where(var_paired_samples, var_385, var_447);
    }
    var_458 = wp::where(var_71, var_261, var_450);
    var_459 = wp::where(var_71, var_262, var_451);
    var_460 = wp::where(var_71, var_263, var_452);
    var_461 = wp::where(var_71, var_264, var_453);
    var_462 = wp::where(var_71, var_265, var_454);
    var_463 = wp::where(var_71, var_266, var_455);
    var_464 = wp::where(var_71, var_267, var_456);
    var_465 = wp::where(var_71, var_268, var_457);
    var_466 = wp::where(var_71, var_59, var_269);
    var_467 = wp::where(var_71, var_106, var_61);
    var_468 = wp::where(var_71, var_109, var_64);
    var_469 = wp::where(var_71, var_112, var_67);
    var_470 = wp::where(var_71, var_121, var_344);
    var_471 = wp::where(var_71, var_132, var_351);
    var_472 = wp::where(var_71, var_143, var_358);
    var_473 = wp::where(var_71, var_154, var_367);
    // diff_mag = wp.sqrt(diff_sq)                                                            <L 1114>
    var_474 = wp::sqrt(var_35);
    // c00 = v000 + (v100 - v000) * tx                                                        <L 1115>
    var_475 = wp::sub(var_459, var_458);
    var_476 = wp::mul(var_475, var_467);
    var_477 = wp::add(var_458, var_476);
    // c10 = v010 + (v110 - v010) * tx                                                        <L 1116>
    var_478 = wp::sub(var_461, var_460);
    var_479 = wp::mul(var_478, var_467);
    var_480 = wp::add(var_460, var_479);
    // c01 = v001 + (v101 - v001) * tx                                                        <L 1117>
    var_481 = wp::sub(var_463, var_462);
    var_482 = wp::mul(var_481, var_467);
    var_483 = wp::add(var_462, var_482);
    // c11 = v011 + (v111 - v011) * tx                                                        <L 1118>
    var_484 = wp::sub(var_465, var_464);
    var_485 = wp::mul(var_484, var_467);
    var_486 = wp::add(var_464, var_485);
    // c0 = c00 + (c10 - c00) * ty                                                            <L 1119>
    var_487 = wp::sub(var_480, var_477);
    var_488 = wp::mul(var_487, var_468);
    var_489 = wp::add(var_477, var_488);
    // c1 = c01 + (c11 - c01) * ty                                                            <L 1120>
    var_490 = wp::sub(var_486, var_483);
    var_491 = wp::mul(var_490, var_468);
    var_492 = wp::add(var_483, var_491);
    // sdf_val = c0 + (c1 - c0) * tz                                                          <L 1121>
    var_493 = wp::sub(var_492, var_489);
    var_494 = wp::mul(var_493, var_469);
    var_495 = wp::add(var_489, var_494);
    // if needs_scale:                                                                        <L 1123>
    if (var_466) {
        // sdf_val = sdf_val * sdf.subgrids_sdf_value_range + sdf.subgrids_min_sdf_value       <L 1124>
        var_496 = &((var_sdf).subgrids_sdf_value_range);
        var_498 = wp::load(var_496);
        var_497 = wp::mul(var_495, var_498);
        var_499 = &((var_sdf).subgrids_min_sdf_value);
        var_501 = wp::load(var_499);
        var_500 = wp::add(var_497, var_501);
    }
    var_502 = wp::where(var_466, var_500, var_495);
    // return sdf_val + diff_mag                                                              <L 1126>
    var_503 = wp::add(var_502, var_474);
    return var_503;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:948
static CUDA_CALLABLE wp::float32 _texture_sample_sdf_at_voxel_variant_0(
    TextureSDFData_93572308 var_sdf,
    wp::int32 var_ix,
    wp::int32 var_iy,
    wp::int32 var_iz,
    bool var_paired_samples)
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
    wp::int32 var_19;
    const wp::int32 var_20 = 0;
    const wp::int32 var_21 = 1;
    wp::int32 var_22;
    wp::int32 var_23;
    wp::float32 var_24;
    wp::float32* var_25;
    wp::float32 var_26;
    wp::float32 var_27;
    wp::int32 var_28;
    const wp::int32 var_29 = 0;
    const wp::int32 var_30 = 1;
    wp::int32 var_31;
    wp::int32 var_32;
    wp::float32 var_33;
    wp::float32* var_34;
    wp::float32 var_35;
    wp::float32 var_36;
    wp::int32 var_37;
    const wp::int32 var_38 = 0;
    const wp::int32 var_39 = 1;
    wp::int32 var_40;
    wp::int32 var_41;
    wp::array_t<wp::uint32>* var_42;
    wp::uint32* var_43;
    wp::array_t<wp::uint32> var_44;
    wp::uint32 var_45;
    wp::uint32 var_46;
    const wp::uint32 var_47 = 4294967294u;
    bool var_48;
    const wp::int32 var_49 = 1023;
    wp::uint32 var_50;
    wp::uint32 var_51;
    wp::float32 var_52;
    const wp::int32 var_53 = 10;
    wp::uint32 var_54;
    wp::uint32 var_55;
    const wp::int32 var_56 = 1023;
    wp::uint32 var_57;
    wp::uint32 var_58;
    wp::float32 var_59;
    const wp::int32 var_60 = 20;
    wp::uint32 var_61;
    wp::uint32 var_62;
    const wp::int32 var_63 = 1023;
    wp::uint32 var_64;
    wp::uint32 var_65;
    wp::float32 var_66;
    wp::float32 var_67;
    wp::float32 var_68;
    wp::float32* var_69;
    wp::float32 var_70;
    wp::float32 var_71;
    wp::float32 var_72;
    wp::float32 var_73;
    wp::float32 var_74;
    wp::float32* var_75;
    wp::float32 var_76;
    wp::float32 var_77;
    wp::float32 var_78;
    wp::float32 var_79;
    wp::float32 var_80;
    wp::float32* var_81;
    wp::float32 var_82;
    wp::float32 var_83;
    wp::float32 var_84;
    wp::float32* var_85;
    wp::float32 var_86;
    wp::float32 var_87;
    wp::float32 var_88;
    const wp::float32 var_89 = 0.5;
    wp::float32 var_90;
    wp::float32* var_91;
    wp::float32 var_92;
    wp::float32 var_93;
    wp::float32 var_94;
    const wp::float32 var_95 = 0.5;
    wp::float32 var_96;
    wp::float32* var_97;
    wp::float32 var_98;
    wp::float32 var_99;
    wp::float32 var_100;
    const wp::float32 var_101 = 0.5;
    wp::float32 var_102;
    wp::texture3d_t* var_103;
    wp::vec_t<3, wp::float32> var_104;
    wp::float32 var_105;
    wp::texture3d_t var_106;
    wp::float32* var_107;
    wp::float32 var_108;
    wp::float32 var_109;
    wp::float32* var_110;
    wp::float32 var_111;
    wp::float32 var_112;
    wp::vec_t<3, wp::float32>* var_113;
    wp::float32 var_114;
    wp::float32 var_115;
    wp::float32 var_116;
    wp::vec_t<3, wp::float32> var_117;
    wp::vec_t<3, wp::float32>* var_118;
    wp::vec_t<3, wp::float32> var_119;
    wp::vec_t<3, wp::float32> var_120;
    wp::vec_t<3, wp::float32> var_121;
    wp::vec_t<3, wp::float32> var_122;
    wp::float32 var_123;
    //---------
    // forward
    // def _texture_sample_sdf_at_voxel_variant(                                              <L 949>
    // coarse_x = sdf.coarse_texture.width - 1                                                <L 975>
    var_0 = &((var_sdf).coarse_texture);
    var_1 = &(((var_sdf).coarse_texture).width);
    var_4 = wp::load(var_1);
    var_3 = wp::sub(var_4, var_2);
    // coarse_y = sdf.coarse_texture.height - 1                                               <L 976>
    var_5 = &((var_sdf).coarse_texture);
    var_6 = &(((var_sdf).coarse_texture).height);
    var_9 = wp::load(var_6);
    var_8 = wp::sub(var_9, var_7);
    // coarse_z = sdf.coarse_texture.depth - 1                                                <L 977>
    var_10 = &((var_sdf).coarse_texture);
    var_11 = &(((var_sdf).coarse_texture).depth);
    var_14 = wp::load(var_11);
    var_13 = wp::sub(var_14, var_12);
    // x_base = wp.clamp(int(float(ix) * sdf.fine_to_coarse), 0, coarse_x - 1)                <L 979>
    var_15 = wp::float(var_ix);
    var_16 = &((var_sdf).fine_to_coarse);
    var_18 = wp::load(var_16);
    var_17 = wp::mul(var_15, var_18);
    var_19 = wp::int(var_17);
    var_22 = wp::sub(var_3, var_21);
    var_23 = wp::clamp(var_19, var_20, var_22);
    // y_base = wp.clamp(int(float(iy) * sdf.fine_to_coarse), 0, coarse_y - 1)                <L 980>
    var_24 = wp::float(var_iy);
    var_25 = &((var_sdf).fine_to_coarse);
    var_27 = wp::load(var_25);
    var_26 = wp::mul(var_24, var_27);
    var_28 = wp::int(var_26);
    var_31 = wp::sub(var_8, var_30);
    var_32 = wp::clamp(var_28, var_29, var_31);
    // z_base = wp.clamp(int(float(iz) * sdf.fine_to_coarse), 0, coarse_z - 1)                <L 981>
    var_33 = wp::float(var_iz);
    var_34 = &((var_sdf).fine_to_coarse);
    var_36 = wp::load(var_34);
    var_35 = wp::mul(var_33, var_36);
    var_37 = wp::int(var_35);
    var_40 = wp::sub(var_13, var_39);
    var_41 = wp::clamp(var_37, var_38, var_40);
    // start_slot = sdf.subgrid_start_slots[x_base, y_base, z_base]                           <L 982>
    var_42 = &((var_sdf).subgrid_start_slots);
    var_44 = wp::load(var_42);
    var_43 = wp::address(var_44, var_23, var_32, var_41);
    var_46 = wp::load(var_43);
    var_45 = wp::copy(var_46);
    // if start_slot < SLOT_LINEAR:                                                           <L 984>
    var_48 = (var_45 < var_47);
    if (var_48) {
        // block_x = float(start_slot & wp.uint32(0x3FF))                                     <L 985>
        var_50 = wp::uint32(var_49);
        var_51 = wp::bit_and(var_45, var_50);
        var_52 = wp::float(var_51);
        // block_y = float((start_slot >> wp.uint32(10)) & wp.uint32(0x3FF))                  <L 986>
        var_54 = wp::uint32(var_53);
        var_55 = wp::rshift(var_45, var_54);
        var_57 = wp::uint32(var_56);
        var_58 = wp::bit_and(var_55, var_57);
        var_59 = wp::float(var_58);
        // block_z = float((start_slot >> wp.uint32(20)) & wp.uint32(0x3FF))                  <L 987>
        var_61 = wp::uint32(var_60);
        var_62 = wp::rshift(var_45, var_61);
        var_64 = wp::uint32(var_63);
        var_65 = wp::bit_and(var_62, var_64);
        var_66 = wp::float(var_65);
        // lx = float(ix) - float(x_base) * sdf.subgrid_size_f                                <L 989>
        var_67 = wp::float(var_ix);
        var_68 = wp::float(var_23);
        var_69 = &((var_sdf).subgrid_size_f);
        var_71 = wp::load(var_69);
        var_70 = wp::mul(var_68, var_71);
        var_72 = wp::sub(var_67, var_70);
        // ly = float(iy) - float(y_base) * sdf.subgrid_size_f                                <L 990>
        var_73 = wp::float(var_iy);
        var_74 = wp::float(var_32);
        var_75 = &((var_sdf).subgrid_size_f);
        var_77 = wp::load(var_75);
        var_76 = wp::mul(var_74, var_77);
        var_78 = wp::sub(var_73, var_76);
        // lz = float(iz) - float(z_base) * sdf.subgrid_size_f                                <L 991>
        var_79 = wp::float(var_iz);
        var_80 = wp::float(var_41);
        var_81 = &((var_sdf).subgrid_size_f);
        var_83 = wp::load(var_81);
        var_82 = wp::mul(var_80, var_83);
        var_84 = wp::sub(var_79, var_82);
        // ox = block_x * sdf.subgrid_samples_f + lx + 0.5                                    <L 993>
        var_85 = &((var_sdf).subgrid_samples_f);
        var_87 = wp::load(var_85);
        var_86 = wp::mul(var_52, var_87);
        var_88 = wp::add(var_86, var_72);
        var_90 = wp::add(var_88, var_89);
        // oy = block_y * sdf.subgrid_samples_f + ly + 0.5                                    <L 994>
        var_91 = &((var_sdf).subgrid_samples_f);
        var_93 = wp::load(var_91);
        var_92 = wp::mul(var_59, var_93);
        var_94 = wp::add(var_92, var_78);
        var_96 = wp::add(var_94, var_95);
        // oz = block_z * sdf.subgrid_samples_f + lz + 0.5                                    <L 995>
        var_97 = &((var_sdf).subgrid_samples_f);
        var_99 = wp::load(var_97);
        var_98 = wp::mul(var_66, var_99);
        var_100 = wp::add(var_98, var_84);
        var_102 = wp::add(var_100, var_101);
        // raw = _texture_sample_sdf_x0(sdf.subgrid_texture, wp.vec3f(ox, oy, oz), paired_samples)       <L 997>
        var_103 = &((var_sdf).subgrid_texture);
        var_104 = wp::vec_t<3, wp::float32>(var_90, var_96, var_102);
        var_106 = wp::load(var_103);
        var_105 = _texture_sample_sdf_x0_0(var_106, var_104, var_paired_samples);
        // return raw * sdf.subgrids_sdf_value_range + sdf.subgrids_min_sdf_value             <L 998>
        var_107 = &((var_sdf).subgrids_sdf_value_range);
        var_109 = wp::load(var_107);
        var_108 = wp::mul(var_105, var_109);
        var_110 = &((var_sdf).subgrids_min_sdf_value);
        var_112 = wp::load(var_110);
        var_111 = wp::add(var_108, var_112);
        return var_111;
    }
    // local_pos = sdf.sdf_box_lower + wp.cw_mul(                                             <L 1000>
    var_113 = &((var_sdf).sdf_box_lower);
    // wp.vec3(float(ix), float(iy), float(iz)),                                              <L 1001>
    var_114 = wp::float(var_ix);
    var_115 = wp::float(var_iy);
    var_116 = wp::float(var_iz);
    var_117 = wp::vec_t<3, wp::float32>(var_114, var_115, var_116);
    // sdf.voxel_size,                                                                        <L 1002>
    var_118 = &((var_sdf).voxel_size);
    var_120 = wp::load(var_118);
    var_119 = wp::cw_mul(var_117, var_120);
    var_122 = wp::load(var_113);
    var_121 = wp::add(var_122, var_119);
    // return _texture_sample_sdf_variant(sdf, local_pos, paired_samples)                     <L 1004>
    var_123 = _texture_sample_sdf_variant_0(var_sdf, var_121, var_paired_samples);
    return var_123;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:1219
static CUDA_CALLABLE wp::float32 texture_sample_sdf_at_voxel_0(
    TextureSDFData_93572308 var_sdf,
    wp::int32 var_ix,
    wp::int32 var_iy,
    wp::int32 var_iz)
{
    //---------
    // primal vars
    bool* var_0;
    wp::float32 var_1;
    bool var_2;
    //---------
    // forward
    // def texture_sample_sdf_at_voxel(                                                       <L 1220>
    // return _texture_sample_sdf_at_voxel_variant(sdf, ix, iy, iz, sdf.paired_samples)       <L 1227>
    var_0 = &((var_sdf).paired_samples);
    var_2 = wp::load(var_0);
    var_1 = _texture_sample_sdf_at_voxel_variant_0(var_sdf, var_ix, var_iy, var_iz, var_2);
    return var_1;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:248
static CUDA_CALLABLE bool _is_in_narrow_band_0(
    wp::float32 var_signed_distance,
    wp::vec_t<2, wp::float32> var_threshold)
{
    //---------
    // primal vars
    wp::float32 var_0;
    const wp::float32 var_1 = 0.0;
    bool var_2;
    const wp::int32 var_3 = 1;
    wp::float32 var_4;
    bool var_5;
    const wp::int32 var_6 = 0;
    wp::float32 var_7;
    bool var_8;
    //---------
    // forward
    // def _is_in_narrow_band(signed_distance: float, threshold: wp.vec2f) -> wp.bool:        <L 249>
    // if wp.sign(signed_distance) > 0.0:                                                     <L 251>
    var_0 = wp::sign(var_signed_distance);
    var_2 = (var_0 > var_1);
    if (var_2) {
        // return signed_distance < threshold[1]                                              <L 252>
        var_4 = wp::extract(var_threshold, var_3);
        var_5 = (var_signed_distance < var_4);
        return var_5;
    }
    // return signed_distance > threshold[0]                                                  <L 253>
    var_7 = wp::extract(var_threshold, var_6);
    var_8 = (var_signed_distance > var_7);
    return var_8;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:174
static CUDA_CALLABLE void adj__id_to_xyz_0(
    wp::int32 var_idx,
    wp::int32 var_size_x,
    wp::int32 var_size_y,
    wp::int32 & adj_idx,
    wp::int32 & adj_size_x,
    wp::int32 & adj_size_y,
    wp::vec_t<3, wp::int32> & adj_ret)
{
    //---------
    // primal vars
    wp::int32 var_0;
    wp::int32 var_1;
    wp::int32 var_2;
    wp::int32 var_3;
    wp::int32 var_4;
    wp::int32 var_5;
    wp::int32 var_6;
    wp::int32 var_7;
    wp::vec_t<3, wp::int32> var_8;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    wp::int32 adj_1 = {};
    wp::int32 adj_2 = {};
    wp::int32 adj_3 = {};
    wp::int32 adj_4 = {};
    wp::int32 adj_5 = {};
    wp::int32 adj_6 = {};
    wp::int32 adj_7 = {};
    wp::vec_t<3, wp::int32> adj_8 = {};
    //---------
    // forward
    // def _id_to_xyz(idx: int, size_x: int, size_y: int) -> wp.vec3i:                        <L 175>
    // z = idx // (size_x * size_y)                                                           <L 177>
    var_0 = wp::mul(var_size_x, var_size_y);
    var_1 = wp::floordiv(var_idx, var_0);
    // rem = idx - z * size_x * size_y                                                        <L 178>
    var_2 = wp::mul(var_1, var_size_x);
    var_3 = wp::mul(var_2, var_size_y);
    var_4 = wp::sub(var_idx, var_3);
    // y = rem // size_x                                                                      <L 179>
    var_5 = wp::floordiv(var_4, var_size_x);
    // x = rem - y * size_x                                                                   <L 180>
    var_6 = wp::mul(var_5, var_size_x);
    var_7 = wp::sub(var_4, var_6);
    // return wp.vec3i(x, y, z)                                                               <L 181>
    var_8 = wp::vec_t<3, wp::int32>(var_7, var_5, var_1);
    goto label0;
    //---------
    // reverse
    label0:;
    adj_8 += adj_ret;
    wp::adj_vec_t(var_7, var_5, var_1, adj_7, adj_5, adj_1, adj_8);
    // adj: return wp.vec3i(x, y, z)                                                          <L 181>
    wp::adj_sub(var_4, var_6, adj_4, adj_6, adj_7);
    wp::adj_mul(var_5, var_size_x, adj_5, adj_size_x, adj_6);
    // adj: x = rem - y * size_x                                                              <L 180>
    // adj: y = rem // size_x                                                                 <L 179>
    wp::adj_sub(var_idx, var_3, adj_idx, adj_3, adj_4);
    wp::adj_mul(var_2, var_size_y, adj_2, adj_size_y, adj_3);
    wp::adj_mul(var_1, var_size_x, adj_1, adj_size_x, adj_2);
    // adj: rem = idx - z * size_x * size_y                                                   <L 178>
    wp::adj_mul(var_size_x, var_size_y, adj_size_x, adj_size_y, adj_0);
    // adj: z = idx // (size_x * size_y)                                                      <L 177>
    // adj: def _id_to_xyz(idx: int, size_x: int, size_y: int) -> wp.vec3i:                   <L 175>
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_utils.py:658
static CUDA_CALLABLE void adj_get_distance_to_mesh_0(
    wp::uint64 var_mesh,
    wp::vec_t<3, wp::float32> var_point,
    wp::float32 var_max_dist,
    wp::float32 var_winding_threshold,
    wp::uint64 & adj_mesh,
    wp::vec_t<3, wp::float32> & adj_point,
    wp::float32 & adj_max_dist,
    wp::float32 & adj_winding_threshold,
    wp::float32 & adj_ret)
{
    //---------
    // primal vars
    const wp::float32 var_0 = 2.0;
    wp::mesh_query_point_t var_1;
    bool* var_2;
    bool var_3;
    wp::int32* var_4;
    wp::float32* var_5;
    wp::float32* var_6;
    wp::vec_t<3, wp::float32> var_7;
    wp::int32 var_8;
    wp::float32 var_9;
    wp::float32 var_10;
    wp::vec_t<3, wp::float32> var_11;
    wp::float32* var_12;
    wp::float32 var_13;
    wp::float32 var_14;
    const wp::float32 var_15 = 0.0;
    bool var_16;
    wp::float32 var_17;
    wp::float32 var_18;
    wp::float32 var_19;
    wp::float32 var_20;
    bool var_21;
    //---------
    // dual vars
    wp::float32 adj_0 = {};
    wp::mesh_query_point_t adj_1 = {};
    bool adj_2 = {};
    bool adj_3 = {};
    wp::int32 adj_4 = {};
    wp::float32 adj_5 = {};
    wp::float32 adj_6 = {};
    wp::vec_t<3, wp::float32> adj_7 = {};
    wp::int32 adj_8 = {};
    wp::float32 adj_9 = {};
    wp::float32 adj_10 = {};
    wp::vec_t<3, wp::float32> adj_11 = {};
    wp::float32 adj_12 = {};
    wp::float32 adj_13 = {};
    wp::float32 adj_14 = {};
    wp::float32 adj_15 = {};
    bool adj_16 = {};
    wp::float32 adj_17 = {};
    wp::float32 adj_18 = {};
    wp::float32 adj_19 = {};
    wp::float32 adj_20 = {};
    bool adj_21 = {};
    //---------
    // forward
    // def get_distance_to_mesh(mesh: wp.uint64, point: wp.vec3, max_dist: wp.float32, winding_threshold: wp.float32):       <L 659>
    // res = wp.mesh_query_point_sign_winding_number(mesh, point, max_dist, 2.0, winding_threshold)       <L 660>
    var_1 = wp::mesh_query_point_sign_winding_number(var_mesh, var_point, var_max_dist, var_0, var_winding_threshold);
    // if res.result:                                                                         <L 661>
    var_2 = &((var_1).result);
    var_3 = wp::load(var_2);
    if (var_3) {
        // closest = wp.mesh_eval_position(mesh, res.face, res.u, res.v)                      <L 662>
        var_4 = &((var_1).face);
        var_5 = &((var_1).u);
        var_6 = &((var_1).v);
        var_8 = wp::load(var_4);
        var_9 = wp::load(var_5);
        var_10 = wp::load(var_6);
        var_7 = wp::mesh_eval_position(var_mesh, var_8, var_9, var_10);
        // vec_to_surface = closest - point                                                   <L 663>
        var_11 = wp::sub(var_7, var_point);
        // sign = res.sign                                                                    <L 664>
        var_12 = &((var_1).sign);
        var_14 = wp::load(var_12);
        var_13 = wp::copy(var_14);
        // if winding_threshold < 0.0:                                                        <L 667>
        var_16 = (var_winding_threshold < var_15);
        if (var_16) {
            // sign = -sign                                                                   <L 668>
            var_17 = wp::neg(var_13);
        }
        var_18 = wp::where(var_16, var_17, var_13);
        // return sign * wp.length(vec_to_surface)                                            <L 669>
        var_19 = wp::length(var_11);
        var_20 = wp::mul(var_18, var_19);
        goto label0;
    }
    var_21 = wp::load(var_2);
    // return max_dist                                                                        <L 670>
    goto label1;
    //---------
    // reverse
    label1:;
    adj_max_dist += adj_ret;
    // adj: return max_dist                                                                   <L 670>
    if (var_21) {
        label0:;
        adj_20 += adj_ret;
        wp::adj_mul(var_18, var_19, adj_18, adj_19, adj_20);
        wp::adj_length(var_11, var_19, adj_11, adj_19);
        // adj: return sign * wp.length(vec_to_surface)                                       <L 669>
        wp::adj_where(var_16, var_17, var_13, adj_16, adj_17, adj_13, adj_18);
        if (var_16) {
            wp::adj_neg(var_13, adj_13, adj_17);
            // adj: sign = -sign                                                              <L 668>
        }
        // adj: if winding_threshold < 0.0:                                                   <L 667>
        wp::adj_copy(var_14, adj_12, adj_13);
        adj_1.sign += adj_12;
        // adj: sign = res.sign                                                               <L 664>
        wp::adj_sub(var_7, var_point, adj_7, adj_point, adj_11);
        // adj: vec_to_surface = closest - point                                              <L 663>
        wp::adj_mesh_eval_position(var_mesh, var_8, var_9, var_10, adj_mesh, adj_4, adj_5, adj_6, adj_7);
        adj_1.v += adj_6;
        adj_1.u += adj_5;
        adj_1.face = adj_4;
        // adj: closest = wp.mesh_eval_position(mesh, res.face, res.u, res.v)                 <L 662>
    }
    adj_1.result = adj_2;
    // adj: if res.result:                                                                    <L 661>
    wp::adj_mesh_query_point_sign_winding_number(var_mesh, var_point, var_max_dist, var_0, var_winding_threshold, var_1, adj_mesh, adj_point, adj_max_dist, adj_0, adj_winding_threshold, adj_1);
    // adj: res = wp.mesh_query_point_sign_winding_number(mesh, point, max_dist, 2.0, winding_threshold)  <L 660>
    // adj: def get_distance_to_mesh(mesh: wp.uint64, point: wp.vec3, max_dist: wp.float32, winding_threshold: wp.float32):  <L 659>
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:332
static CUDA_CALLABLE void adj__create_source_kernels__locals__query_sdf_0(
    wp::uint64 var_mesh,
    wp::int32 var_shape_type,
    wp::vec_t<3, wp::float32> var_shape_scale,
    wp::vec_t<3, wp::float32> var_point,
    wp::float32 var_max_dist,
    wp::float32 var_winding_threshold,
    wp::uint64 & adj_mesh,
    wp::int32 & adj_shape_type,
    wp::vec_t<3, wp::float32> & adj_shape_scale,
    wp::vec_t<3, wp::float32> & adj_point,
    wp::float32 & adj_max_dist,
    wp::float32 & adj_winding_threshold,
    wp::float32 & adj_ret)
{
    //---------
    // primal vars
    wp::float32 var_0;
    //---------
    // dual vars
    wp::float32 adj_0 = {};
    //---------
    // forward
    // def query_sdf(                                                                         <L 333>
    // return get_distance_to_mesh(mesh, point, max_dist, winding_threshold)                  <L 341>
    var_0 = get_distance_to_mesh_0(var_mesh, var_point, var_max_dist, var_winding_threshold);
    goto label0;
    //---------
    // reverse
    label0:;
    adj_0 += adj_ret;
    adj_get_distance_to_mesh_0(var_mesh, var_point, var_max_dist, var_winding_threshold, adj_mesh, adj_point, adj_max_dist, adj_winding_threshold, adj_0);
    // adj: return get_distance_to_mesh(mesh, point, max_dist, winding_threshold)             <L 341>
    // adj: def query_sdf(                                                                    <L 333>
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:168
static CUDA_CALLABLE void adj__idx3d_0(
    wp::int32 var_x,
    wp::int32 var_y,
    wp::int32 var_z,
    wp::int32 var_size_x,
    wp::int32 var_size_y,
    wp::int32 & adj_x,
    wp::int32 & adj_y,
    wp::int32 & adj_z,
    wp::int32 & adj_size_x,
    wp::int32 & adj_size_y,
    wp::int32 & adj_ret)
{
    //---------
    // primal vars
    wp::int32 var_0;
    wp::int32 var_1;
    wp::int32 var_2;
    wp::int32 var_3;
    wp::int32 var_4;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    wp::int32 adj_1 = {};
    wp::int32 adj_2 = {};
    wp::int32 adj_3 = {};
    wp::int32 adj_4 = {};
    //---------
    // forward
    // def _idx3d(x: int, y: int, z: int, size_x: int, size_y: int) -> int:                   <L 169>
    // return z * size_x * size_y + y * size_x + x                                            <L 171>
    var_0 = wp::mul(var_z, var_size_x);
    var_1 = wp::mul(var_0, var_size_y);
    var_2 = wp::mul(var_y, var_size_x);
    var_3 = wp::add(var_1, var_2);
    var_4 = wp::add(var_3, var_x);
    goto label0;
    //---------
    // reverse
    label0:;
    adj_4 += adj_ret;
    wp::adj_add(var_3, var_x, adj_3, adj_x, adj_4);
    wp::adj_add(var_1, var_2, adj_1, adj_2, adj_3);
    wp::adj_mul(var_y, var_size_x, adj_y, adj_size_x, adj_2);
    wp::adj_mul(var_0, var_size_y, adj_0, adj_size_y, adj_1);
    wp::adj_mul(var_z, var_size_x, adj_z, adj_size_x, adj_0);
    // adj: return z * size_x * size_y + y * size_x + x                                       <L 171>
    // adj: def _idx3d(x: int, y: int, z: int, size_x: int, size_y: int) -> int:              <L 169>
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:203
static CUDA_CALLABLE void adj__interp_coarse_sdf_0(
    wp::array_t<wp::float32> var_background_sdf,
    wp::int32 var_block_x,
    wp::int32 var_block_y,
    wp::int32 var_block_z,
    wp::int32 var_lx,
    wp::int32 var_ly,
    wp::int32 var_lz,
    wp::float32 var_inv_cells_per_subgrid,
    wp::int32 var_bg_size_x,
    wp::int32 var_bg_size_y,
    wp::int32 var_bg_size_z,
    wp::array_t<wp::float32> & adj_background_sdf,
    wp::int32 & adj_block_x,
    wp::int32 & adj_block_y,
    wp::int32 & adj_block_z,
    wp::int32 & adj_lx,
    wp::int32 & adj_ly,
    wp::int32 & adj_lz,
    wp::float32 & adj_inv_cells_per_subgrid,
    wp::int32 & adj_bg_size_x,
    wp::int32 & adj_bg_size_y,
    wp::int32 & adj_bg_size_z,
    wp::float32 & adj_ret)
{
    //---------
    // primal vars
    wp::float32 var_0;
    wp::float32 var_1;
    wp::float32 var_2;
    wp::float32 var_3;
    wp::float32 var_4;
    wp::float32 var_5;
    wp::float32 var_6;
    wp::float32 var_7;
    wp::float32 var_8;
    wp::float32 var_9;
    wp::float32 var_10;
    wp::float32 var_11;
    wp::float32 var_12;
    wp::int32 var_13;
    const wp::int32 var_14 = 0;
    const wp::int32 var_15 = 2;
    wp::int32 var_16;
    wp::int32 var_17;
    wp::float32 var_18;
    wp::int32 var_19;
    const wp::int32 var_20 = 0;
    const wp::int32 var_21 = 2;
    wp::int32 var_22;
    wp::int32 var_23;
    wp::float32 var_24;
    wp::int32 var_25;
    const wp::int32 var_26 = 0;
    const wp::int32 var_27 = 2;
    wp::int32 var_28;
    wp::int32 var_29;
    wp::float32 var_30;
    wp::float32 var_31;
    const wp::float32 var_32 = 0.0;
    const wp::float32 var_33 = 1.0;
    wp::float32 var_34;
    wp::float32 var_35;
    wp::float32 var_36;
    const wp::float32 var_37 = 0.0;
    const wp::float32 var_38 = 1.0;
    wp::float32 var_39;
    wp::float32 var_40;
    wp::float32 var_41;
    const wp::float32 var_42 = 0.0;
    const wp::float32 var_43 = 1.0;
    wp::float32 var_44;
    wp::int32 var_45;
    wp::float32* var_46;
    wp::float32 var_47;
    wp::float32 var_48;
    const wp::int32 var_49 = 1;
    wp::int32 var_50;
    wp::int32 var_51;
    wp::float32* var_52;
    wp::float32 var_53;
    wp::float32 var_54;
    const wp::int32 var_55 = 1;
    wp::int32 var_56;
    wp::int32 var_57;
    wp::float32* var_58;
    wp::float32 var_59;
    wp::float32 var_60;
    const wp::int32 var_61 = 1;
    wp::int32 var_62;
    const wp::int32 var_63 = 1;
    wp::int32 var_64;
    wp::int32 var_65;
    wp::float32* var_66;
    wp::float32 var_67;
    wp::float32 var_68;
    const wp::int32 var_69 = 1;
    wp::int32 var_70;
    wp::int32 var_71;
    wp::float32* var_72;
    wp::float32 var_73;
    wp::float32 var_74;
    const wp::int32 var_75 = 1;
    wp::int32 var_76;
    const wp::int32 var_77 = 1;
    wp::int32 var_78;
    wp::int32 var_79;
    wp::float32* var_80;
    wp::float32 var_81;
    wp::float32 var_82;
    const wp::int32 var_83 = 1;
    wp::int32 var_84;
    const wp::int32 var_85 = 1;
    wp::int32 var_86;
    wp::int32 var_87;
    wp::float32* var_88;
    wp::float32 var_89;
    wp::float32 var_90;
    const wp::int32 var_91 = 1;
    wp::int32 var_92;
    const wp::int32 var_93 = 1;
    wp::int32 var_94;
    const wp::int32 var_95 = 1;
    wp::int32 var_96;
    wp::int32 var_97;
    wp::float32* var_98;
    wp::float32 var_99;
    wp::float32 var_100;
    const wp::float32 var_101 = 1.0;
    wp::float32 var_102;
    wp::float32 var_103;
    wp::float32 var_104;
    wp::float32 var_105;
    const wp::float32 var_106 = 1.0;
    wp::float32 var_107;
    wp::float32 var_108;
    wp::float32 var_109;
    wp::float32 var_110;
    const wp::float32 var_111 = 1.0;
    wp::float32 var_112;
    wp::float32 var_113;
    wp::float32 var_114;
    wp::float32 var_115;
    const wp::float32 var_116 = 1.0;
    wp::float32 var_117;
    wp::float32 var_118;
    wp::float32 var_119;
    wp::float32 var_120;
    const wp::float32 var_121 = 1.0;
    wp::float32 var_122;
    wp::float32 var_123;
    wp::float32 var_124;
    wp::float32 var_125;
    const wp::float32 var_126 = 1.0;
    wp::float32 var_127;
    wp::float32 var_128;
    wp::float32 var_129;
    wp::float32 var_130;
    const wp::float32 var_131 = 1.0;
    wp::float32 var_132;
    wp::float32 var_133;
    wp::float32 var_134;
    wp::float32 var_135;
    //---------
    // dual vars
    wp::float32 adj_0 = {};
    wp::float32 adj_1 = {};
    wp::float32 adj_2 = {};
    wp::float32 adj_3 = {};
    wp::float32 adj_4 = {};
    wp::float32 adj_5 = {};
    wp::float32 adj_6 = {};
    wp::float32 adj_7 = {};
    wp::float32 adj_8 = {};
    wp::float32 adj_9 = {};
    wp::float32 adj_10 = {};
    wp::float32 adj_11 = {};
    wp::float32 adj_12 = {};
    wp::int32 adj_13 = {};
    wp::int32 adj_14 = {};
    wp::int32 adj_15 = {};
    wp::int32 adj_16 = {};
    wp::int32 adj_17 = {};
    wp::float32 adj_18 = {};
    wp::int32 adj_19 = {};
    wp::int32 adj_20 = {};
    wp::int32 adj_21 = {};
    wp::int32 adj_22 = {};
    wp::int32 adj_23 = {};
    wp::float32 adj_24 = {};
    wp::int32 adj_25 = {};
    wp::int32 adj_26 = {};
    wp::int32 adj_27 = {};
    wp::int32 adj_28 = {};
    wp::int32 adj_29 = {};
    wp::float32 adj_30 = {};
    wp::float32 adj_31 = {};
    wp::float32 adj_32 = {};
    wp::float32 adj_33 = {};
    wp::float32 adj_34 = {};
    wp::float32 adj_35 = {};
    wp::float32 adj_36 = {};
    wp::float32 adj_37 = {};
    wp::float32 adj_38 = {};
    wp::float32 adj_39 = {};
    wp::float32 adj_40 = {};
    wp::float32 adj_41 = {};
    wp::float32 adj_42 = {};
    wp::float32 adj_43 = {};
    wp::float32 adj_44 = {};
    wp::int32 adj_45 = {};
    wp::float32 adj_46 = {};
    wp::float32 adj_47 = {};
    wp::float32 adj_48 = {};
    wp::int32 adj_49 = {};
    wp::int32 adj_50 = {};
    wp::int32 adj_51 = {};
    wp::float32 adj_52 = {};
    wp::float32 adj_53 = {};
    wp::float32 adj_54 = {};
    wp::int32 adj_55 = {};
    wp::int32 adj_56 = {};
    wp::int32 adj_57 = {};
    wp::float32 adj_58 = {};
    wp::float32 adj_59 = {};
    wp::float32 adj_60 = {};
    wp::int32 adj_61 = {};
    wp::int32 adj_62 = {};
    wp::int32 adj_63 = {};
    wp::int32 adj_64 = {};
    wp::int32 adj_65 = {};
    wp::float32 adj_66 = {};
    wp::float32 adj_67 = {};
    wp::float32 adj_68 = {};
    wp::int32 adj_69 = {};
    wp::int32 adj_70 = {};
    wp::int32 adj_71 = {};
    wp::float32 adj_72 = {};
    wp::float32 adj_73 = {};
    wp::float32 adj_74 = {};
    wp::int32 adj_75 = {};
    wp::int32 adj_76 = {};
    wp::int32 adj_77 = {};
    wp::int32 adj_78 = {};
    wp::int32 adj_79 = {};
    wp::float32 adj_80 = {};
    wp::float32 adj_81 = {};
    wp::float32 adj_82 = {};
    wp::int32 adj_83 = {};
    wp::int32 adj_84 = {};
    wp::int32 adj_85 = {};
    wp::int32 adj_86 = {};
    wp::int32 adj_87 = {};
    wp::float32 adj_88 = {};
    wp::float32 adj_89 = {};
    wp::float32 adj_90 = {};
    wp::int32 adj_91 = {};
    wp::int32 adj_92 = {};
    wp::int32 adj_93 = {};
    wp::int32 adj_94 = {};
    wp::int32 adj_95 = {};
    wp::int32 adj_96 = {};
    wp::int32 adj_97 = {};
    wp::float32 adj_98 = {};
    wp::float32 adj_99 = {};
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
    wp::float32 adj_112 = {};
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
    wp::float32 adj_123 = {};
    wp::float32 adj_124 = {};
    wp::float32 adj_125 = {};
    wp::float32 adj_126 = {};
    wp::float32 adj_127 = {};
    wp::float32 adj_128 = {};
    wp::float32 adj_129 = {};
    wp::float32 adj_130 = {};
    wp::float32 adj_131 = {};
    wp::float32 adj_132 = {};
    wp::float32 adj_133 = {};
    wp::float32 adj_134 = {};
    wp::float32 adj_135 = {};
    //---------
    // forward
    // def _interp_coarse_sdf(                                                                <L 204>
    // coarse_fx = float(block_x) + float(lx) * inv_cells_per_subgrid                         <L 218>
    var_0 = wp::float(var_block_x);
    var_1 = wp::float(var_lx);
    var_2 = wp::mul(var_1, var_inv_cells_per_subgrid);
    var_3 = wp::add(var_0, var_2);
    // coarse_fy = float(block_y) + float(ly) * inv_cells_per_subgrid                         <L 219>
    var_4 = wp::float(var_block_y);
    var_5 = wp::float(var_ly);
    var_6 = wp::mul(var_5, var_inv_cells_per_subgrid);
    var_7 = wp::add(var_4, var_6);
    // coarse_fz = float(block_z) + float(lz) * inv_cells_per_subgrid                         <L 220>
    var_8 = wp::float(var_block_z);
    var_9 = wp::float(var_lz);
    var_10 = wp::mul(var_9, var_inv_cells_per_subgrid);
    var_11 = wp::add(var_8, var_10);
    // x0 = wp.clamp(int(wp.floor(coarse_fx)), 0, bg_size_x - 2)                              <L 222>
    var_12 = wp::floor(var_3);
    var_13 = wp::int(var_12);
    var_16 = wp::sub(var_bg_size_x, var_15);
    var_17 = wp::clamp(var_13, var_14, var_16);
    // y0 = wp.clamp(int(wp.floor(coarse_fy)), 0, bg_size_y - 2)                              <L 223>
    var_18 = wp::floor(var_7);
    var_19 = wp::int(var_18);
    var_22 = wp::sub(var_bg_size_y, var_21);
    var_23 = wp::clamp(var_19, var_20, var_22);
    // z0 = wp.clamp(int(wp.floor(coarse_fz)), 0, bg_size_z - 2)                              <L 224>
    var_24 = wp::floor(var_11);
    var_25 = wp::int(var_24);
    var_28 = wp::sub(var_bg_size_z, var_27);
    var_29 = wp::clamp(var_25, var_26, var_28);
    // tx = wp.clamp(coarse_fx - float(x0), 0.0, 1.0)                                         <L 226>
    var_30 = wp::float(var_17);
    var_31 = wp::sub(var_3, var_30);
    var_34 = wp::clamp(var_31, var_32, var_33);
    // ty = wp.clamp(coarse_fy - float(y0), 0.0, 1.0)                                         <L 227>
    var_35 = wp::float(var_23);
    var_36 = wp::sub(var_7, var_35);
    var_39 = wp::clamp(var_36, var_37, var_38);
    // tz = wp.clamp(coarse_fz - float(z0), 0.0, 1.0)                                         <L 228>
    var_40 = wp::float(var_29);
    var_41 = wp::sub(var_11, var_40);
    var_44 = wp::clamp(var_41, var_42, var_43);
    // v000 = background_sdf[_idx3d(x0, y0, z0, bg_size_x, bg_size_y)]                        <L 230>
    var_45 = _idx3d_0(var_17, var_23, var_29, var_bg_size_x, var_bg_size_y);
    var_46 = wp::address(var_background_sdf, var_45);
    var_48 = wp::load(var_46);
    var_47 = wp::copy(var_48);
    // v100 = background_sdf[_idx3d(x0 + 1, y0, z0, bg_size_x, bg_size_y)]                    <L 231>
    var_50 = wp::add(var_17, var_49);
    var_51 = _idx3d_0(var_50, var_23, var_29, var_bg_size_x, var_bg_size_y);
    var_52 = wp::address(var_background_sdf, var_51);
    var_54 = wp::load(var_52);
    var_53 = wp::copy(var_54);
    // v010 = background_sdf[_idx3d(x0, y0 + 1, z0, bg_size_x, bg_size_y)]                    <L 232>
    var_56 = wp::add(var_23, var_55);
    var_57 = _idx3d_0(var_17, var_56, var_29, var_bg_size_x, var_bg_size_y);
    var_58 = wp::address(var_background_sdf, var_57);
    var_60 = wp::load(var_58);
    var_59 = wp::copy(var_60);
    // v110 = background_sdf[_idx3d(x0 + 1, y0 + 1, z0, bg_size_x, bg_size_y)]                <L 233>
    var_62 = wp::add(var_17, var_61);
    var_64 = wp::add(var_23, var_63);
    var_65 = _idx3d_0(var_62, var_64, var_29, var_bg_size_x, var_bg_size_y);
    var_66 = wp::address(var_background_sdf, var_65);
    var_68 = wp::load(var_66);
    var_67 = wp::copy(var_68);
    // v001 = background_sdf[_idx3d(x0, y0, z0 + 1, bg_size_x, bg_size_y)]                    <L 234>
    var_70 = wp::add(var_29, var_69);
    var_71 = _idx3d_0(var_17, var_23, var_70, var_bg_size_x, var_bg_size_y);
    var_72 = wp::address(var_background_sdf, var_71);
    var_74 = wp::load(var_72);
    var_73 = wp::copy(var_74);
    // v101 = background_sdf[_idx3d(x0 + 1, y0, z0 + 1, bg_size_x, bg_size_y)]                <L 235>
    var_76 = wp::add(var_17, var_75);
    var_78 = wp::add(var_29, var_77);
    var_79 = _idx3d_0(var_76, var_23, var_78, var_bg_size_x, var_bg_size_y);
    var_80 = wp::address(var_background_sdf, var_79);
    var_82 = wp::load(var_80);
    var_81 = wp::copy(var_82);
    // v011 = background_sdf[_idx3d(x0, y0 + 1, z0 + 1, bg_size_x, bg_size_y)]                <L 236>
    var_84 = wp::add(var_23, var_83);
    var_86 = wp::add(var_29, var_85);
    var_87 = _idx3d_0(var_17, var_84, var_86, var_bg_size_x, var_bg_size_y);
    var_88 = wp::address(var_background_sdf, var_87);
    var_90 = wp::load(var_88);
    var_89 = wp::copy(var_90);
    // v111 = background_sdf[_idx3d(x0 + 1, y0 + 1, z0 + 1, bg_size_x, bg_size_y)]            <L 237>
    var_92 = wp::add(var_17, var_91);
    var_94 = wp::add(var_23, var_93);
    var_96 = wp::add(var_29, var_95);
    var_97 = _idx3d_0(var_92, var_94, var_96, var_bg_size_x, var_bg_size_y);
    var_98 = wp::address(var_background_sdf, var_97);
    var_100 = wp::load(var_98);
    var_99 = wp::copy(var_100);
    // c00 = v000 * (1.0 - tx) + v100 * tx                                                    <L 239>
    var_102 = wp::sub(var_101, var_34);
    var_103 = wp::mul(var_47, var_102);
    var_104 = wp::mul(var_53, var_34);
    var_105 = wp::add(var_103, var_104);
    // c10 = v010 * (1.0 - tx) + v110 * tx                                                    <L 240>
    var_107 = wp::sub(var_106, var_34);
    var_108 = wp::mul(var_59, var_107);
    var_109 = wp::mul(var_67, var_34);
    var_110 = wp::add(var_108, var_109);
    // c01 = v001 * (1.0 - tx) + v101 * tx                                                    <L 241>
    var_112 = wp::sub(var_111, var_34);
    var_113 = wp::mul(var_73, var_112);
    var_114 = wp::mul(var_81, var_34);
    var_115 = wp::add(var_113, var_114);
    // c11 = v011 * (1.0 - tx) + v111 * tx                                                    <L 242>
    var_117 = wp::sub(var_116, var_34);
    var_118 = wp::mul(var_89, var_117);
    var_119 = wp::mul(var_99, var_34);
    var_120 = wp::add(var_118, var_119);
    // c0 = c00 * (1.0 - ty) + c10 * ty                                                       <L 243>
    var_122 = wp::sub(var_121, var_39);
    var_123 = wp::mul(var_105, var_122);
    var_124 = wp::mul(var_110, var_39);
    var_125 = wp::add(var_123, var_124);
    // c1 = c01 * (1.0 - ty) + c11 * ty                                                       <L 244>
    var_127 = wp::sub(var_126, var_39);
    var_128 = wp::mul(var_115, var_127);
    var_129 = wp::mul(var_120, var_39);
    var_130 = wp::add(var_128, var_129);
    // return c0 * (1.0 - tz) + c1 * tz                                                       <L 245>
    var_132 = wp::sub(var_131, var_44);
    var_133 = wp::mul(var_125, var_132);
    var_134 = wp::mul(var_130, var_44);
    var_135 = wp::add(var_133, var_134);
    goto label0;
    //---------
    // reverse
    label0:;
    adj_135 += adj_ret;
    wp::adj_add(var_133, var_134, adj_133, adj_134, adj_135);
    wp::adj_mul(var_130, var_44, adj_130, adj_44, adj_134);
    wp::adj_mul(var_125, var_132, adj_125, adj_132, adj_133);
    wp::adj_sub(var_131, var_44, adj_131, adj_44, adj_132);
    // adj: return c0 * (1.0 - tz) + c1 * tz                                                  <L 245>
    wp::adj_add(var_128, var_129, adj_128, adj_129, adj_130);
    wp::adj_mul(var_120, var_39, adj_120, adj_39, adj_129);
    wp::adj_mul(var_115, var_127, adj_115, adj_127, adj_128);
    wp::adj_sub(var_126, var_39, adj_126, adj_39, adj_127);
    // adj: c1 = c01 * (1.0 - ty) + c11 * ty                                                  <L 244>
    wp::adj_add(var_123, var_124, adj_123, adj_124, adj_125);
    wp::adj_mul(var_110, var_39, adj_110, adj_39, adj_124);
    wp::adj_mul(var_105, var_122, adj_105, adj_122, adj_123);
    wp::adj_sub(var_121, var_39, adj_121, adj_39, adj_122);
    // adj: c0 = c00 * (1.0 - ty) + c10 * ty                                                  <L 243>
    wp::adj_add(var_118, var_119, adj_118, adj_119, adj_120);
    wp::adj_mul(var_99, var_34, adj_99, adj_34, adj_119);
    wp::adj_mul(var_89, var_117, adj_89, adj_117, adj_118);
    wp::adj_sub(var_116, var_34, adj_116, adj_34, adj_117);
    // adj: c11 = v011 * (1.0 - tx) + v111 * tx                                               <L 242>
    wp::adj_add(var_113, var_114, adj_113, adj_114, adj_115);
    wp::adj_mul(var_81, var_34, adj_81, adj_34, adj_114);
    wp::adj_mul(var_73, var_112, adj_73, adj_112, adj_113);
    wp::adj_sub(var_111, var_34, adj_111, adj_34, adj_112);
    // adj: c01 = v001 * (1.0 - tx) + v101 * tx                                               <L 241>
    wp::adj_add(var_108, var_109, adj_108, adj_109, adj_110);
    wp::adj_mul(var_67, var_34, adj_67, adj_34, adj_109);
    wp::adj_mul(var_59, var_107, adj_59, adj_107, adj_108);
    wp::adj_sub(var_106, var_34, adj_106, adj_34, adj_107);
    // adj: c10 = v010 * (1.0 - tx) + v110 * tx                                               <L 240>
    wp::adj_add(var_103, var_104, adj_103, adj_104, adj_105);
    wp::adj_mul(var_53, var_34, adj_53, adj_34, adj_104);
    wp::adj_mul(var_47, var_102, adj_47, adj_102, adj_103);
    wp::adj_sub(var_101, var_34, adj_101, adj_34, adj_102);
    // adj: c00 = v000 * (1.0 - tx) + v100 * tx                                               <L 239>
    wp::adj_copy(var_100, adj_98, adj_99);
    wp::adj_address(var_background_sdf, var_97, adj_background_sdf, adj_97, adj_98);
    adj__idx3d_0(var_92, var_94, var_96, var_bg_size_x, var_bg_size_y, adj_92, adj_94, adj_96, adj_bg_size_x, adj_bg_size_y, adj_97);
    wp::adj_add(var_29, var_95, adj_29, adj_95, adj_96);
    wp::adj_add(var_23, var_93, adj_23, adj_93, adj_94);
    wp::adj_add(var_17, var_91, adj_17, adj_91, adj_92);
    // adj: v111 = background_sdf[_idx3d(x0 + 1, y0 + 1, z0 + 1, bg_size_x, bg_size_y)]       <L 237>
    wp::adj_copy(var_90, adj_88, adj_89);
    wp::adj_address(var_background_sdf, var_87, adj_background_sdf, adj_87, adj_88);
    adj__idx3d_0(var_17, var_84, var_86, var_bg_size_x, var_bg_size_y, adj_17, adj_84, adj_86, adj_bg_size_x, adj_bg_size_y, adj_87);
    wp::adj_add(var_29, var_85, adj_29, adj_85, adj_86);
    wp::adj_add(var_23, var_83, adj_23, adj_83, adj_84);
    // adj: v011 = background_sdf[_idx3d(x0, y0 + 1, z0 + 1, bg_size_x, bg_size_y)]           <L 236>
    wp::adj_copy(var_82, adj_80, adj_81);
    wp::adj_address(var_background_sdf, var_79, adj_background_sdf, adj_79, adj_80);
    adj__idx3d_0(var_76, var_23, var_78, var_bg_size_x, var_bg_size_y, adj_76, adj_23, adj_78, adj_bg_size_x, adj_bg_size_y, adj_79);
    wp::adj_add(var_29, var_77, adj_29, adj_77, adj_78);
    wp::adj_add(var_17, var_75, adj_17, adj_75, adj_76);
    // adj: v101 = background_sdf[_idx3d(x0 + 1, y0, z0 + 1, bg_size_x, bg_size_y)]           <L 235>
    wp::adj_copy(var_74, adj_72, adj_73);
    wp::adj_address(var_background_sdf, var_71, adj_background_sdf, adj_71, adj_72);
    adj__idx3d_0(var_17, var_23, var_70, var_bg_size_x, var_bg_size_y, adj_17, adj_23, adj_70, adj_bg_size_x, adj_bg_size_y, adj_71);
    wp::adj_add(var_29, var_69, adj_29, adj_69, adj_70);
    // adj: v001 = background_sdf[_idx3d(x0, y0, z0 + 1, bg_size_x, bg_size_y)]               <L 234>
    wp::adj_copy(var_68, adj_66, adj_67);
    wp::adj_address(var_background_sdf, var_65, adj_background_sdf, adj_65, adj_66);
    adj__idx3d_0(var_62, var_64, var_29, var_bg_size_x, var_bg_size_y, adj_62, adj_64, adj_29, adj_bg_size_x, adj_bg_size_y, adj_65);
    wp::adj_add(var_23, var_63, adj_23, adj_63, adj_64);
    wp::adj_add(var_17, var_61, adj_17, adj_61, adj_62);
    // adj: v110 = background_sdf[_idx3d(x0 + 1, y0 + 1, z0, bg_size_x, bg_size_y)]           <L 233>
    wp::adj_copy(var_60, adj_58, adj_59);
    wp::adj_address(var_background_sdf, var_57, adj_background_sdf, adj_57, adj_58);
    adj__idx3d_0(var_17, var_56, var_29, var_bg_size_x, var_bg_size_y, adj_17, adj_56, adj_29, adj_bg_size_x, adj_bg_size_y, adj_57);
    wp::adj_add(var_23, var_55, adj_23, adj_55, adj_56);
    // adj: v010 = background_sdf[_idx3d(x0, y0 + 1, z0, bg_size_x, bg_size_y)]               <L 232>
    wp::adj_copy(var_54, adj_52, adj_53);
    wp::adj_address(var_background_sdf, var_51, adj_background_sdf, adj_51, adj_52);
    adj__idx3d_0(var_50, var_23, var_29, var_bg_size_x, var_bg_size_y, adj_50, adj_23, adj_29, adj_bg_size_x, adj_bg_size_y, adj_51);
    wp::adj_add(var_17, var_49, adj_17, adj_49, adj_50);
    // adj: v100 = background_sdf[_idx3d(x0 + 1, y0, z0, bg_size_x, bg_size_y)]               <L 231>
    wp::adj_copy(var_48, adj_46, adj_47);
    wp::adj_address(var_background_sdf, var_45, adj_background_sdf, adj_45, adj_46);
    adj__idx3d_0(var_17, var_23, var_29, var_bg_size_x, var_bg_size_y, adj_17, adj_23, adj_29, adj_bg_size_x, adj_bg_size_y, adj_45);
    // adj: v000 = background_sdf[_idx3d(x0, y0, z0, bg_size_x, bg_size_y)]                   <L 230>
    wp::adj_clamp(var_41, var_42, var_43, adj_41, adj_42, adj_43, adj_44);
    wp::adj_sub(var_11, var_40, adj_11, adj_40, adj_41);
    wp::adj_float(var_29, adj_29, adj_40);
    // adj: tz = wp.clamp(coarse_fz - float(z0), 0.0, 1.0)                                    <L 228>
    wp::adj_clamp(var_36, var_37, var_38, adj_36, adj_37, adj_38, adj_39);
    wp::adj_sub(var_7, var_35, adj_7, adj_35, adj_36);
    wp::adj_float(var_23, adj_23, adj_35);
    // adj: ty = wp.clamp(coarse_fy - float(y0), 0.0, 1.0)                                    <L 227>
    wp::adj_clamp(var_31, var_32, var_33, adj_31, adj_32, adj_33, adj_34);
    wp::adj_sub(var_3, var_30, adj_3, adj_30, adj_31);
    wp::adj_float(var_17, adj_17, adj_30);
    // adj: tx = wp.clamp(coarse_fx - float(x0), 0.0, 1.0)                                    <L 226>
    wp::adj_clamp(var_25, var_26, var_28, adj_25, adj_26, adj_28, adj_29);
    wp::adj_sub(var_bg_size_z, var_27, adj_bg_size_z, adj_27, adj_28);
    // adj: z0 = wp.clamp(int(wp.floor(coarse_fz)), 0, bg_size_z - 2)                         <L 224>
    wp::adj_clamp(var_19, var_20, var_22, adj_19, adj_20, adj_22, adj_23);
    wp::adj_sub(var_bg_size_y, var_21, adj_bg_size_y, adj_21, adj_22);
    // adj: y0 = wp.clamp(int(wp.floor(coarse_fy)), 0, bg_size_y - 2)                         <L 223>
    wp::adj_clamp(var_13, var_14, var_16, adj_13, adj_14, adj_16, adj_17);
    wp::adj_sub(var_bg_size_x, var_15, adj_bg_size_x, adj_15, adj_16);
    // adj: x0 = wp.clamp(int(wp.floor(coarse_fx)), 0, bg_size_x - 2)                         <L 222>
    wp::adj_add(var_8, var_10, adj_8, adj_10, adj_11);
    wp::adj_mul(var_9, var_inv_cells_per_subgrid, adj_9, adj_inv_cells_per_subgrid, adj_10);
    wp::adj_float(var_lz, adj_lz, adj_9);
    wp::adj_float(var_block_z, adj_block_z, adj_8);
    // adj: coarse_fz = float(block_z) + float(lz) * inv_cells_per_subgrid                    <L 220>
    wp::adj_add(var_4, var_6, adj_4, adj_6, adj_7);
    wp::adj_mul(var_5, var_inv_cells_per_subgrid, adj_5, adj_inv_cells_per_subgrid, adj_6);
    wp::adj_float(var_ly, adj_ly, adj_5);
    wp::adj_float(var_block_y, adj_block_y, adj_4);
    // adj: coarse_fy = float(block_y) + float(ly) * inv_cells_per_subgrid                    <L 219>
    wp::adj_add(var_0, var_2, adj_0, adj_2, adj_3);
    wp::adj_mul(var_1, var_inv_cells_per_subgrid, adj_1, adj_inv_cells_per_subgrid, adj_2);
    wp::adj_float(var_lx, adj_lx, adj_1);
    wp::adj_float(var_block_x, adj_block_x, adj_0);
    // adj: coarse_fx = float(block_x) + float(lx) * inv_cells_per_subgrid                    <L 218>
    // adj: def _interp_coarse_sdf(                                                           <L 204>
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:256
static CUDA_CALLABLE void adj__write_subgrid_slot_0(
    wp::array_t<wp::uint32> var_subgrid_start_slots,
    wp::int32 var_address,
    wp::int32 var_tex_blocks_per_dim,
    wp::int32 var_block_x,
    wp::int32 var_block_y,
    wp::int32 var_block_z,
    wp::int32 var_local_sample,
    wp::array_t<wp::uint32> & adj_subgrid_start_slots,
    wp::int32 & adj_address,
    wp::int32 & adj_tex_blocks_per_dim,
    wp::int32 & adj_block_x,
    wp::int32 & adj_block_y,
    wp::int32 & adj_block_z,
    wp::int32 & adj_local_sample,
    wp::vec_t<3, wp::int32> & adj_ret)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::int32> var_0;
    const wp::int32 var_1 = 0;
    bool var_2;
    const wp::int32 var_3 = 0;
    wp::int32 var_4;
    wp::uint32 var_5;
    const wp::int32 var_6 = 1;
    wp::int32 var_7;
    wp::uint32 var_8;
    const wp::int32 var_9 = 10;
    wp::uint32 var_10;
    wp::uint32 var_11;
    wp::uint32 var_12;
    const wp::int32 var_13 = 2;
    wp::int32 var_14;
    wp::uint32 var_15;
    const wp::int32 var_16 = 20;
    wp::uint32 var_17;
    wp::uint32 var_18;
    wp::uint32 var_19;
    //---------
    // dual vars
    wp::vec_t<3, wp::int32> adj_0 = {};
    wp::int32 adj_1 = {};
    bool adj_2 = {};
    wp::int32 adj_3 = {};
    wp::int32 adj_4 = {};
    wp::uint32 adj_5 = {};
    wp::int32 adj_6 = {};
    wp::int32 adj_7 = {};
    wp::uint32 adj_8 = {};
    wp::int32 adj_9 = {};
    wp::uint32 adj_10 = {};
    wp::uint32 adj_11 = {};
    wp::uint32 adj_12 = {};
    wp::int32 adj_13 = {};
    wp::int32 adj_14 = {};
    wp::uint32 adj_15 = {};
    wp::int32 adj_16 = {};
    wp::uint32 adj_17 = {};
    wp::uint32 adj_18 = {};
    wp::uint32 adj_19 = {};
    //---------
    // forward
    // def _write_subgrid_slot(                                                               <L 257>
    // addr_coords = _id_to_xyz(address, tex_blocks_per_dim, tex_blocks_per_dim)              <L 271>
    var_0 = _id_to_xyz_0(var_address, var_tex_blocks_per_dim, var_tex_blocks_per_dim);
    // if local_sample == 0:                                                                  <L 272>
    var_2 = (var_local_sample == var_1);
    if (var_2) {
        // start_slot = (                                                                     <L 273>
        // wp.uint32(addr_coords[0])                                                          <L 274>
        var_4 = wp::extract(var_0, var_3);
        var_5 = wp::uint32(var_4);
        // | (wp.uint32(addr_coords[1]) << wp.uint32(10))                                     <L 275>
        var_7 = wp::extract(var_0, var_6);
        var_8 = wp::uint32(var_7);
        var_10 = wp::uint32(var_9);
        var_11 = wp::lshift(var_8, var_10);
        var_12 = wp::bit_or(var_5, var_11);
        // | (wp.uint32(addr_coords[2]) << wp.uint32(20))                                     <L 276>
        var_14 = wp::extract(var_0, var_13);
        var_15 = wp::uint32(var_14);
        var_17 = wp::uint32(var_16);
        var_18 = wp::lshift(var_15, var_17);
        var_19 = wp::bit_or(var_12, var_18);
        // subgrid_start_slots[block_x, block_y, block_z] = start_slot                        <L 278>
        // wp::array_store(var_subgrid_start_slots, var_block_x, var_block_y, var_block_z, var_19);
    }
    // return addr_coords                                                                     <L 279>
    goto label0;
    //---------
    // reverse
    label0:;
    adj_0 += adj_ret;
    // adj: return addr_coords                                                                <L 279>
    if (var_2) {
        wp::adj_array_store(var_subgrid_start_slots, var_block_x, var_block_y, var_block_z, var_19, adj_subgrid_start_slots, adj_block_x, adj_block_y, adj_block_z, adj_19);
        // adj: subgrid_start_slots[block_x, block_y, block_z] = start_slot                   <L 278>
        wp::adj_extract(var_0, var_13, adj_0, adj_13, adj_14);
        // adj: | (wp.uint32(addr_coords[2]) << wp.uint32(20))                                <L 276>
        wp::adj_extract(var_0, var_6, adj_0, adj_6, adj_7);
        // adj: | (wp.uint32(addr_coords[1]) << wp.uint32(10))                                <L 275>
        wp::adj_extract(var_0, var_3, adj_0, adj_3, adj_4);
        // adj: wp.uint32(addr_coords[0])                                                     <L 274>
        // adj: start_slot = (                                                                <L 273>
    }
    // adj: if local_sample == 0:                                                             <L 272>
    adj__id_to_xyz_0(var_address, var_tex_blocks_per_dim, var_tex_blocks_per_dim, adj_address, adj_tex_blocks_per_dim, adj_tex_blocks_per_dim, adj_0);
    // adj: addr_coords = _id_to_xyz(address, tex_blocks_per_dim, tex_blocks_per_dim)         <L 271>
    // adj: def _write_subgrid_slot(                                                          <L 257>
    return;
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:1007
static CUDA_CALLABLE void adj__texture_sample_sdf_variant_0(
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:948
static CUDA_CALLABLE void adj__texture_sample_sdf_at_voxel_variant_0(
    TextureSDFData_93572308 var_sdf,
    wp::int32 var_ix,
    wp::int32 var_iy,
    wp::int32 var_iz,
    bool var_paired_samples,
    TextureSDFData_93572308 & adj_sdf,
    wp::int32 & adj_ix,
    wp::int32 & adj_iy,
    wp::int32 & adj_iz,
    bool & adj_paired_samples,
    wp::float32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:1219
static CUDA_CALLABLE void adj_texture_sample_sdf_at_voxel_0(
    TextureSDFData_93572308 var_sdf,
    wp::int32 var_ix,
    wp::int32 var_iy,
    wp::int32 var_iz,
    TextureSDFData_93572308 & adj_sdf,
    wp::int32 & adj_ix,
    wp::int32 & adj_iy,
    wp::int32 & adj_iz,
    wp::float32 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/sdf_texture.py:248
static CUDA_CALLABLE void adj__is_in_narrow_band_0(
    wp::float32 var_signed_distance,
    wp::vec_t<2, wp::float32> var_threshold,
    wp::float32 & adj_signed_distance,
    wp::vec_t<2, wp::float32> & adj_threshold,
    bool & adj_ret)
{
    //---------
    // primal vars
    wp::float32 var_0;
    const wp::float32 var_1 = 0.0;
    bool var_2;
    const wp::int32 var_3 = 1;
    wp::float32 var_4;
    bool var_5;
    const wp::int32 var_6 = 0;
    wp::float32 var_7;
    bool var_8;
    //---------
    // dual vars
    wp::float32 adj_0 = {};
    wp::float32 adj_1 = {};
    bool adj_2 = {};
    wp::int32 adj_3 = {};
    wp::float32 adj_4 = {};
    bool adj_5 = {};
    wp::int32 adj_6 = {};
    wp::float32 adj_7 = {};
    bool adj_8 = {};
    //---------
    // forward
    // def _is_in_narrow_band(signed_distance: float, threshold: wp.vec2f) -> wp.bool:        <L 249>
    // if wp.sign(signed_distance) > 0.0:                                                     <L 251>
    var_0 = wp::sign(var_signed_distance);
    var_2 = (var_0 > var_1);
    if (var_2) {
        // return signed_distance < threshold[1]                                              <L 252>
        var_4 = wp::extract(var_threshold, var_3);
        var_5 = (var_signed_distance < var_4);
        goto label0;
    }
    // return signed_distance > threshold[0]                                                  <L 253>
    var_7 = wp::extract(var_threshold, var_6);
    var_8 = (var_signed_distance > var_7);
    goto label1;
    //---------
    // reverse
    label1:;
    adj_8 += adj_ret;
    wp::adj_extract(var_threshold, var_6, adj_threshold, adj_6, adj_7);
    // adj: return signed_distance > threshold[0]                                             <L 253>
    if (var_2) {
        label0:;
        adj_5 += adj_ret;
        wp::adj_extract(var_threshold, var_3, adj_threshold, adj_3, adj_4);
        // adj: return signed_distance < threshold[1]                                         <L 252>
    }
    // adj: if wp.sign(signed_distance) > 0.0:                                                <L 251>
    // adj: def _is_in_narrow_band(signed_distance: float, threshold: wp.vec2f) -> wp.bool:   <L 249>
    return;
}



extern "C" __global__ void _create_source_kernels__locals__accumulate_subgrid_linearity_error_kernel_52e5f7d8_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::uint64 var_mesh,
    wp::int32 var_shape_type,
    wp::vec_t<3, wp::float32> var_shape_scale,
    wp::array_t<wp::float32> var_background_sdf,
    wp::array_t<wp::int32> var_subgrid_required,
    wp::array_t<wp::float32> var_linearity_errors,
    wp::int32 var_cells_per_subgrid,
    wp::vec_t<3, wp::float32> var_min_corner,
    wp::vec_t<3, wp::float32> var_cell_size,
    wp::float32 var_winding_threshold,
    wp::int32 var_num_subgrids_x,
    wp::int32 var_num_subgrids_y,
    wp::int32 var_num_subgrids_z,
    wp::int32 var_bg_size_x,
    wp::int32 var_bg_size_y,
    wp::int32 var_bg_size_z)
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
        wp::int32 var_2;
        const wp::int32 var_3 = 1;
        wp::int32 var_4;
        wp::int32 var_5;
        wp::int32 var_6;
        wp::int32 var_7;
        wp::int32 var_8;
        wp::int32 var_9;
        bool var_10;
        wp::int32* var_11;
        const wp::int32 var_12 = 0;
        bool var_13;
        wp::int32 var_14;
        wp::vec_t<3, wp::int32> var_15;
        const wp::int32 var_16 = 0;
        wp::int32 var_17;
        const wp::int32 var_18 = 1;
        wp::int32 var_19;
        const wp::int32 var_20 = 2;
        wp::int32 var_21;
        wp::vec_t<3, wp::int32> var_22;
        const wp::int32 var_23 = 0;
        wp::int32 var_24;
        const wp::int32 var_25 = 1;
        wp::int32 var_26;
        const wp::int32 var_27 = 2;
        wp::int32 var_28;
        wp::int32 var_29;
        wp::int32 var_30;
        wp::int32 var_31;
        wp::int32 var_32;
        wp::int32 var_33;
        wp::int32 var_34;
        wp::float32 var_35;
        const wp::int32 var_36 = 0;
        wp::float32 var_37;
        wp::float32 var_38;
        wp::float32 var_39;
        const wp::int32 var_40 = 1;
        wp::float32 var_41;
        wp::float32 var_42;
        wp::float32 var_43;
        const wp::int32 var_44 = 2;
        wp::float32 var_45;
        wp::float32 var_46;
        wp::vec_t<3, wp::float32> var_47;
        wp::vec_t<3, wp::float32> var_48;
        const wp::float32 var_49 = 10000.0;
        wp::float32 var_50;
        const wp::float32 var_51 = 1.0;
        wp::float32 var_52;
        wp::float32 var_53;
        wp::float32 var_54;
        wp::float32 var_55;
        wp::float32 var_56;
        wp::float32 var_57;
        //---------
        // forward
        // def accumulate_subgrid_linearity_error_kernel(                                         <L 373>
        // tid = wp.tid()                                                                         <L 400>
        var_0 = builtin_tid1d();
        // total_subgrids = num_subgrids_x * num_subgrids_y * num_subgrids_z                      <L 402>
        var_1 = wp::mul(var_num_subgrids_x, var_num_subgrids_y);
        var_2 = wp::mul(var_1, var_num_subgrids_z);
        // samples_per_dim = cells_per_subgrid + 1                                                <L 403>
        var_4 = wp::add(var_cells_per_subgrid, var_3);
        // samples_per_subgrid = samples_per_dim * samples_per_dim * samples_per_dim              <L 404>
        var_5 = wp::mul(var_4, var_4);
        var_6 = wp::mul(var_5, var_4);
        // subgrid_idx = tid // samples_per_subgrid                                               <L 406>
        var_7 = wp::floordiv(var_0, var_6);
        // local_sample = tid - subgrid_idx * samples_per_subgrid                                 <L 407>
        var_8 = wp::mul(var_7, var_6);
        var_9 = wp::sub(var_0, var_8);
        // if subgrid_idx >= total_subgrids:                                                      <L 409>
        var_10 = (var_7 >= var_2);
        if (var_10) {
            // return                                                                             <L 410>
            continue;
        }
        // if subgrid_required[subgrid_idx] == 0:                                                 <L 411>
        var_11 = wp::address(var_subgrid_required, var_7);
        var_14 = wp::load(var_11);
        var_13 = (var_14 == var_12);
        if (var_13) {
            // return                                                                             <L 412>
            continue;
        }
        // subgrid_coords = _id_to_xyz(subgrid_idx, num_subgrids_x, num_subgrids_y)               <L 414>
        var_15 = _id_to_xyz_0(var_7, var_num_subgrids_x, var_num_subgrids_y);
        // block_x = subgrid_coords[0]                                                            <L 415>
        var_17 = wp::extract(var_15, var_16);
        // block_y = subgrid_coords[1]                                                            <L 416>
        var_19 = wp::extract(var_15, var_18);
        // block_z = subgrid_coords[2]                                                            <L 417>
        var_21 = wp::extract(var_15, var_20);
        // local_coords = _id_to_xyz(local_sample, samples_per_dim, samples_per_dim)              <L 419>
        var_22 = _id_to_xyz_0(var_9, var_4, var_4);
        // lx = local_coords[0]                                                                   <L 420>
        var_24 = wp::extract(var_22, var_23);
        // ly = local_coords[1]                                                                   <L 421>
        var_26 = wp::extract(var_22, var_25);
        // lz = local_coords[2]                                                                   <L 422>
        var_28 = wp::extract(var_22, var_27);
        // gx = block_x * cells_per_subgrid + lx                                                  <L 424>
        var_29 = wp::mul(var_17, var_cells_per_subgrid);
        var_30 = wp::add(var_29, var_24);
        // gy = block_y * cells_per_subgrid + ly                                                  <L 425>
        var_31 = wp::mul(var_19, var_cells_per_subgrid);
        var_32 = wp::add(var_31, var_26);
        // gz = block_z * cells_per_subgrid + lz                                                  <L 426>
        var_33 = wp::mul(var_21, var_cells_per_subgrid);
        var_34 = wp::add(var_33, var_28);
        // pos = min_corner + wp.vec3(                                                            <L 428>
        // float(gx) * cell_size[0],                                                              <L 429>
        var_35 = wp::float(var_30);
        var_37 = wp::extract(var_cell_size, var_36);
        var_38 = wp::mul(var_35, var_37);
        // float(gy) * cell_size[1],                                                              <L 430>
        var_39 = wp::float(var_32);
        var_41 = wp::extract(var_cell_size, var_40);
        var_42 = wp::mul(var_39, var_41);
        // float(gz) * cell_size[2],                                                              <L 431>
        var_43 = wp::float(var_34);
        var_45 = wp::extract(var_cell_size, var_44);
        var_46 = wp::mul(var_43, var_45);
        var_47 = wp::vec_t<3, wp::float32>(var_38, var_42, var_46);
        var_48 = wp::add(var_min_corner, var_47);
        // sdf_value = query_sdf(mesh, shape_type, shape_scale, pos, 10000.0, winding_threshold)       <L 433>
        var_50 = _create_source_kernels__locals__query_sdf_0(var_mesh, var_shape_type, var_shape_scale, var_48, var_49, var_winding_threshold);
        // inv_cpsg = 1.0 / float(cells_per_subgrid)                                              <L 435>
        var_52 = wp::float(var_cells_per_subgrid);
        var_53 = wp::div(var_51, var_52);
        // coarse_val = _interp_coarse_sdf(                                                       <L 436>
        // background_sdf,                                                                        <L 437>
        // block_x,                                                                               <L 438>
        // block_y,                                                                               <L 439>
        // block_z,                                                                               <L 440>
        // lx,                                                                                    <L 441>
        // ly,                                                                                    <L 442>
        // lz,                                                                                    <L 443>
        // inv_cpsg,                                                                              <L 444>
        // bg_size_x,                                                                             <L 445>
        // bg_size_y,                                                                             <L 446>
        // bg_size_z,                                                                             <L 447>
        var_54 = _interp_coarse_sdf_0(var_background_sdf, var_17, var_19, var_21, var_24, var_26, var_28, var_53, var_bg_size_x, var_bg_size_y, var_bg_size_z);
        // wp.atomic_max(linearity_errors, subgrid_idx, wp.abs(sdf_value - coarse_val))           <L 450>
        var_55 = wp::sub(var_50, var_54);
        var_56 = wp::abs(var_55);
        var_57 = wp::atomic_max(var_linearity_errors, var_7, var_56);
    }
}



extern "C" __global__ void _create_source_kernels__locals__accumulate_subgrid_linearity_error_kernel_52e5f7d8_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::uint64 var_mesh,
    wp::int32 var_shape_type,
    wp::vec_t<3, wp::float32> var_shape_scale,
    wp::array_t<wp::float32> var_background_sdf,
    wp::array_t<wp::int32> var_subgrid_required,
    wp::array_t<wp::float32> var_linearity_errors,
    wp::int32 var_cells_per_subgrid,
    wp::vec_t<3, wp::float32> var_min_corner,
    wp::vec_t<3, wp::float32> var_cell_size,
    wp::float32 var_winding_threshold,
    wp::int32 var_num_subgrids_x,
    wp::int32 var_num_subgrids_y,
    wp::int32 var_num_subgrids_z,
    wp::int32 var_bg_size_x,
    wp::int32 var_bg_size_y,
    wp::int32 var_bg_size_z,
    wp::uint64 adj_mesh,
    wp::int32 adj_shape_type,
    wp::vec_t<3, wp::float32> adj_shape_scale,
    wp::array_t<wp::float32> adj_background_sdf,
    wp::array_t<wp::int32> adj_subgrid_required,
    wp::array_t<wp::float32> adj_linearity_errors,
    wp::int32 adj_cells_per_subgrid,
    wp::vec_t<3, wp::float32> adj_min_corner,
    wp::vec_t<3, wp::float32> adj_cell_size,
    wp::float32 adj_winding_threshold,
    wp::int32 adj_num_subgrids_x,
    wp::int32 adj_num_subgrids_y,
    wp::int32 adj_num_subgrids_z,
    wp::int32 adj_bg_size_x,
    wp::int32 adj_bg_size_y,
    wp::int32 adj_bg_size_z)
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
        wp::int32 var_2;
        const wp::int32 var_3 = 1;
        wp::int32 var_4;
        wp::int32 var_5;
        wp::int32 var_6;
        wp::int32 var_7;
        wp::int32 var_8;
        wp::int32 var_9;
        bool var_10;
        wp::int32* var_11;
        const wp::int32 var_12 = 0;
        bool var_13;
        wp::int32 var_14;
        wp::vec_t<3, wp::int32> var_15;
        const wp::int32 var_16 = 0;
        wp::int32 var_17;
        const wp::int32 var_18 = 1;
        wp::int32 var_19;
        const wp::int32 var_20 = 2;
        wp::int32 var_21;
        wp::vec_t<3, wp::int32> var_22;
        const wp::int32 var_23 = 0;
        wp::int32 var_24;
        const wp::int32 var_25 = 1;
        wp::int32 var_26;
        const wp::int32 var_27 = 2;
        wp::int32 var_28;
        wp::int32 var_29;
        wp::int32 var_30;
        wp::int32 var_31;
        wp::int32 var_32;
        wp::int32 var_33;
        wp::int32 var_34;
        wp::float32 var_35;
        const wp::int32 var_36 = 0;
        wp::float32 var_37;
        wp::float32 var_38;
        wp::float32 var_39;
        const wp::int32 var_40 = 1;
        wp::float32 var_41;
        wp::float32 var_42;
        wp::float32 var_43;
        const wp::int32 var_44 = 2;
        wp::float32 var_45;
        wp::float32 var_46;
        wp::vec_t<3, wp::float32> var_47;
        wp::vec_t<3, wp::float32> var_48;
        const wp::float32 var_49 = 10000.0;
        wp::float32 var_50;
        const wp::float32 var_51 = 1.0;
        wp::float32 var_52;
        wp::float32 var_53;
        wp::float32 var_54;
        wp::float32 var_55;
        wp::float32 var_56;
        wp::float32 var_57;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::int32 adj_2 = {};
        wp::int32 adj_3 = {};
        wp::int32 adj_4 = {};
        wp::int32 adj_5 = {};
        wp::int32 adj_6 = {};
        wp::int32 adj_7 = {};
        wp::int32 adj_8 = {};
        wp::int32 adj_9 = {};
        bool adj_10 = {};
        wp::int32 adj_11 = {};
        wp::int32 adj_12 = {};
        bool adj_13 = {};
        wp::int32 adj_14 = {};
        wp::vec_t<3, wp::int32> adj_15 = {};
        wp::int32 adj_16 = {};
        wp::int32 adj_17 = {};
        wp::int32 adj_18 = {};
        wp::int32 adj_19 = {};
        wp::int32 adj_20 = {};
        wp::int32 adj_21 = {};
        wp::vec_t<3, wp::int32> adj_22 = {};
        wp::int32 adj_23 = {};
        wp::int32 adj_24 = {};
        wp::int32 adj_25 = {};
        wp::int32 adj_26 = {};
        wp::int32 adj_27 = {};
        wp::int32 adj_28 = {};
        wp::int32 adj_29 = {};
        wp::int32 adj_30 = {};
        wp::int32 adj_31 = {};
        wp::int32 adj_32 = {};
        wp::int32 adj_33 = {};
        wp::int32 adj_34 = {};
        wp::float32 adj_35 = {};
        wp::int32 adj_36 = {};
        wp::float32 adj_37 = {};
        wp::float32 adj_38 = {};
        wp::float32 adj_39 = {};
        wp::int32 adj_40 = {};
        wp::float32 adj_41 = {};
        wp::float32 adj_42 = {};
        wp::float32 adj_43 = {};
        wp::int32 adj_44 = {};
        wp::float32 adj_45 = {};
        wp::float32 adj_46 = {};
        wp::vec_t<3, wp::float32> adj_47 = {};
        wp::vec_t<3, wp::float32> adj_48 = {};
        wp::float32 adj_49 = {};
        wp::float32 adj_50 = {};
        wp::float32 adj_51 = {};
        wp::float32 adj_52 = {};
        wp::float32 adj_53 = {};
        wp::float32 adj_54 = {};
        wp::float32 adj_55 = {};
        wp::float32 adj_56 = {};
        wp::float32 adj_57 = {};
        //---------
        // forward
        // def accumulate_subgrid_linearity_error_kernel(                                         <L 373>
        // tid = wp.tid()                                                                         <L 400>
        var_0 = builtin_tid1d();
        // total_subgrids = num_subgrids_x * num_subgrids_y * num_subgrids_z                      <L 402>
        var_1 = wp::mul(var_num_subgrids_x, var_num_subgrids_y);
        var_2 = wp::mul(var_1, var_num_subgrids_z);
        // samples_per_dim = cells_per_subgrid + 1                                                <L 403>
        var_4 = wp::add(var_cells_per_subgrid, var_3);
        // samples_per_subgrid = samples_per_dim * samples_per_dim * samples_per_dim              <L 404>
        var_5 = wp::mul(var_4, var_4);
        var_6 = wp::mul(var_5, var_4);
        // subgrid_idx = tid // samples_per_subgrid                                               <L 406>
        var_7 = wp::floordiv(var_0, var_6);
        // local_sample = tid - subgrid_idx * samples_per_subgrid                                 <L 407>
        var_8 = wp::mul(var_7, var_6);
        var_9 = wp::sub(var_0, var_8);
        // if subgrid_idx >= total_subgrids:                                                      <L 409>
        var_10 = (var_7 >= var_2);
        if (var_10) {
            // return                                                                             <L 410>
            goto label0;
        }
        // if subgrid_required[subgrid_idx] == 0:                                                 <L 411>
        var_11 = wp::address(var_subgrid_required, var_7);
        var_14 = wp::load(var_11);
        var_13 = (var_14 == var_12);
        if (var_13) {
            // return                                                                             <L 412>
            goto label1;
        }
        // subgrid_coords = _id_to_xyz(subgrid_idx, num_subgrids_x, num_subgrids_y)               <L 414>
        var_15 = _id_to_xyz_0(var_7, var_num_subgrids_x, var_num_subgrids_y);
        // block_x = subgrid_coords[0]                                                            <L 415>
        var_17 = wp::extract(var_15, var_16);
        // block_y = subgrid_coords[1]                                                            <L 416>
        var_19 = wp::extract(var_15, var_18);
        // block_z = subgrid_coords[2]                                                            <L 417>
        var_21 = wp::extract(var_15, var_20);
        // local_coords = _id_to_xyz(local_sample, samples_per_dim, samples_per_dim)              <L 419>
        var_22 = _id_to_xyz_0(var_9, var_4, var_4);
        // lx = local_coords[0]                                                                   <L 420>
        var_24 = wp::extract(var_22, var_23);
        // ly = local_coords[1]                                                                   <L 421>
        var_26 = wp::extract(var_22, var_25);
        // lz = local_coords[2]                                                                   <L 422>
        var_28 = wp::extract(var_22, var_27);
        // gx = block_x * cells_per_subgrid + lx                                                  <L 424>
        var_29 = wp::mul(var_17, var_cells_per_subgrid);
        var_30 = wp::add(var_29, var_24);
        // gy = block_y * cells_per_subgrid + ly                                                  <L 425>
        var_31 = wp::mul(var_19, var_cells_per_subgrid);
        var_32 = wp::add(var_31, var_26);
        // gz = block_z * cells_per_subgrid + lz                                                  <L 426>
        var_33 = wp::mul(var_21, var_cells_per_subgrid);
        var_34 = wp::add(var_33, var_28);
        // pos = min_corner + wp.vec3(                                                            <L 428>
        // float(gx) * cell_size[0],                                                              <L 429>
        var_35 = wp::float(var_30);
        var_37 = wp::extract(var_cell_size, var_36);
        var_38 = wp::mul(var_35, var_37);
        // float(gy) * cell_size[1],                                                              <L 430>
        var_39 = wp::float(var_32);
        var_41 = wp::extract(var_cell_size, var_40);
        var_42 = wp::mul(var_39, var_41);
        // float(gz) * cell_size[2],                                                              <L 431>
        var_43 = wp::float(var_34);
        var_45 = wp::extract(var_cell_size, var_44);
        var_46 = wp::mul(var_43, var_45);
        var_47 = wp::vec_t<3, wp::float32>(var_38, var_42, var_46);
        var_48 = wp::add(var_min_corner, var_47);
        // sdf_value = query_sdf(mesh, shape_type, shape_scale, pos, 10000.0, winding_threshold)       <L 433>
        var_50 = _create_source_kernels__locals__query_sdf_0(var_mesh, var_shape_type, var_shape_scale, var_48, var_49, var_winding_threshold);
        // inv_cpsg = 1.0 / float(cells_per_subgrid)                                              <L 435>
        var_52 = wp::float(var_cells_per_subgrid);
        var_53 = wp::div(var_51, var_52);
        // coarse_val = _interp_coarse_sdf(                                                       <L 436>
        // background_sdf,                                                                        <L 437>
        // block_x,                                                                               <L 438>
        // block_y,                                                                               <L 439>
        // block_z,                                                                               <L 440>
        // lx,                                                                                    <L 441>
        // ly,                                                                                    <L 442>
        // lz,                                                                                    <L 443>
        // inv_cpsg,                                                                              <L 444>
        // bg_size_x,                                                                             <L 445>
        // bg_size_y,                                                                             <L 446>
        // bg_size_z,                                                                             <L 447>
        var_54 = _interp_coarse_sdf_0(var_background_sdf, var_17, var_19, var_21, var_24, var_26, var_28, var_53, var_bg_size_x, var_bg_size_y, var_bg_size_z);
        // wp.atomic_max(linearity_errors, subgrid_idx, wp.abs(sdf_value - coarse_val))           <L 450>
        var_55 = wp::sub(var_50, var_54);
        var_56 = wp::abs(var_55);
        // var_57 = wp::atomic_max(var_linearity_errors, var_7, var_56);
        //---------
        // reverse
        wp::adj_atomic_max(var_linearity_errors, var_7, var_56, adj_linearity_errors, adj_7, adj_56, adj_57);
        wp::adj_abs(var_55, adj_55, adj_56);
        wp::adj_sub(var_50, var_54, adj_50, adj_54, adj_55);
        // adj: wp.atomic_max(linearity_errors, subgrid_idx, wp.abs(sdf_value - coarse_val))      <L 450>
        adj__interp_coarse_sdf_0(var_background_sdf, var_17, var_19, var_21, var_24, var_26, var_28, var_53, var_bg_size_x, var_bg_size_y, var_bg_size_z, adj_background_sdf, adj_17, adj_19, adj_21, adj_24, adj_26, adj_28, adj_53, adj_bg_size_x, adj_bg_size_y, adj_bg_size_z, adj_54);
        // adj: bg_size_z,                                                                        <L 447>
        // adj: bg_size_y,                                                                        <L 446>
        // adj: bg_size_x,                                                                        <L 445>
        // adj: inv_cpsg,                                                                         <L 444>
        // adj: lz,                                                                               <L 443>
        // adj: ly,                                                                               <L 442>
        // adj: lx,                                                                               <L 441>
        // adj: block_z,                                                                          <L 440>
        // adj: block_y,                                                                          <L 439>
        // adj: block_x,                                                                          <L 438>
        // adj: background_sdf,                                                                   <L 437>
        // adj: coarse_val = _interp_coarse_sdf(                                                  <L 436>
        wp::adj_div(var_51, var_52, var_53, adj_51, adj_52, adj_53);
        wp::adj_float(var_cells_per_subgrid, adj_cells_per_subgrid, adj_52);
        // adj: inv_cpsg = 1.0 / float(cells_per_subgrid)                                         <L 435>
        adj__create_source_kernels__locals__query_sdf_0(var_mesh, var_shape_type, var_shape_scale, var_48, var_49, var_winding_threshold, adj_mesh, adj_shape_type, adj_shape_scale, adj_48, adj_49, adj_winding_threshold, adj_50);
        // adj: sdf_value = query_sdf(mesh, shape_type, shape_scale, pos, 10000.0, winding_threshold)  <L 433>
        wp::adj_add(var_min_corner, var_47, adj_min_corner, adj_47, adj_48);
        wp::adj_vec_t(var_38, var_42, var_46, adj_38, adj_42, adj_46, adj_47);
        wp::adj_mul(var_43, var_45, adj_43, adj_45, adj_46);
        wp::adj_extract(var_cell_size, var_44, adj_cell_size, adj_44, adj_45);
        wp::adj_float(var_34, adj_34, adj_43);
        // adj: float(gz) * cell_size[2],                                                         <L 431>
        wp::adj_mul(var_39, var_41, adj_39, adj_41, adj_42);
        wp::adj_extract(var_cell_size, var_40, adj_cell_size, adj_40, adj_41);
        wp::adj_float(var_32, adj_32, adj_39);
        // adj: float(gy) * cell_size[1],                                                         <L 430>
        wp::adj_mul(var_35, var_37, adj_35, adj_37, adj_38);
        wp::adj_extract(var_cell_size, var_36, adj_cell_size, adj_36, adj_37);
        wp::adj_float(var_30, adj_30, adj_35);
        // adj: float(gx) * cell_size[0],                                                         <L 429>
        // adj: pos = min_corner + wp.vec3(                                                       <L 428>
        wp::adj_add(var_33, var_28, adj_33, adj_28, adj_34);
        wp::adj_mul(var_21, var_cells_per_subgrid, adj_21, adj_cells_per_subgrid, adj_33);
        // adj: gz = block_z * cells_per_subgrid + lz                                             <L 426>
        wp::adj_add(var_31, var_26, adj_31, adj_26, adj_32);
        wp::adj_mul(var_19, var_cells_per_subgrid, adj_19, adj_cells_per_subgrid, adj_31);
        // adj: gy = block_y * cells_per_subgrid + ly                                             <L 425>
        wp::adj_add(var_29, var_24, adj_29, adj_24, adj_30);
        wp::adj_mul(var_17, var_cells_per_subgrid, adj_17, adj_cells_per_subgrid, adj_29);
        // adj: gx = block_x * cells_per_subgrid + lx                                             <L 424>
        wp::adj_extract(var_22, var_27, adj_22, adj_27, adj_28);
        // adj: lz = local_coords[2]                                                              <L 422>
        wp::adj_extract(var_22, var_25, adj_22, adj_25, adj_26);
        // adj: ly = local_coords[1]                                                              <L 421>
        wp::adj_extract(var_22, var_23, adj_22, adj_23, adj_24);
        // adj: lx = local_coords[0]                                                              <L 420>
        adj__id_to_xyz_0(var_9, var_4, var_4, adj_9, adj_4, adj_4, adj_22);
        // adj: local_coords = _id_to_xyz(local_sample, samples_per_dim, samples_per_dim)         <L 419>
        wp::adj_extract(var_15, var_20, adj_15, adj_20, adj_21);
        // adj: block_z = subgrid_coords[2]                                                       <L 417>
        wp::adj_extract(var_15, var_18, adj_15, adj_18, adj_19);
        // adj: block_y = subgrid_coords[1]                                                       <L 416>
        wp::adj_extract(var_15, var_16, adj_15, adj_16, adj_17);
        // adj: block_x = subgrid_coords[0]                                                       <L 415>
        adj__id_to_xyz_0(var_7, var_num_subgrids_x, var_num_subgrids_y, adj_7, adj_num_subgrids_x, adj_num_subgrids_y, adj_15);
        // adj: subgrid_coords = _id_to_xyz(subgrid_idx, num_subgrids_x, num_subgrids_y)          <L 414>
        if (var_13) {
            label1:;
            // adj: return                                                                        <L 412>
        }
        wp::adj_address(var_subgrid_required, var_7, adj_subgrid_required, adj_7, adj_11);
        // adj: if subgrid_required[subgrid_idx] == 0:                                            <L 411>
        if (var_10) {
            label0:;
            // adj: return                                                                        <L 410>
        }
        // adj: if subgrid_idx >= total_subgrids:                                                 <L 409>
        wp::adj_sub(var_0, var_8, adj_0, adj_8, adj_9);
        wp::adj_mul(var_7, var_6, adj_7, adj_6, adj_8);
        // adj: local_sample = tid - subgrid_idx * samples_per_subgrid                            <L 407>
        // adj: subgrid_idx = tid // samples_per_subgrid                                          <L 406>
        wp::adj_mul(var_5, var_4, adj_5, adj_4, adj_6);
        wp::adj_mul(var_4, var_4, adj_4, adj_4, adj_5);
        // adj: samples_per_subgrid = samples_per_dim * samples_per_dim * samples_per_dim         <L 404>
        wp::adj_add(var_cells_per_subgrid, var_3, adj_cells_per_subgrid, adj_3, adj_4);
        // adj: samples_per_dim = cells_per_subgrid + 1                                           <L 403>
        wp::adj_mul(var_1, var_num_subgrids_z, adj_1, adj_num_subgrids_z, adj_2);
        wp::adj_mul(var_num_subgrids_x, var_num_subgrids_y, adj_num_subgrids_x, adj_num_subgrids_y, adj_1);
        // adj: total_subgrids = num_subgrids_x * num_subgrids_y * num_subgrids_z                 <L 402>
        // adj: tid = wp.tid()                                                                    <L 400>
        // adj: def accumulate_subgrid_linearity_error_kernel(                                    <L 373>
        continue;
    }
}



extern "C" __global__ void _create_source_kernels__locals__populate_subgrid_texture_uint8_kernel_00531ad4_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::uint64 var_mesh,
    wp::int32 var_shape_type,
    wp::vec_t<3, wp::float32> var_shape_scale,
    wp::array_t<wp::int32> var_subgrid_required,
    wp::array_t<wp::int32> var_subgrid_addresses,
    wp::array_t<wp::uint32> var_subgrid_start_slots,
    wp::array_t<wp::uint8> var_subgrid_texture,
    wp::int32 var_cells_per_subgrid,
    wp::vec_t<3, wp::float32> var_min_corner,
    wp::vec_t<3, wp::float32> var_cell_size,
    wp::float32 var_winding_threshold,
    wp::int32 var_num_subgrids_x,
    wp::int32 var_num_subgrids_y,
    wp::int32 var_num_subgrids_z,
    wp::int32 var_tex_blocks_per_dim,
    wp::int32 var_tex_size,
    wp::float32 var_sdf_min,
    wp::float32 var_sdf_range_inv)
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
        wp::int32 var_2;
        const wp::int32 var_3 = 1;
        wp::int32 var_4;
        wp::int32 var_5;
        wp::int32 var_6;
        wp::int32 var_7;
        wp::int32 var_8;
        wp::int32 var_9;
        bool var_10;
        wp::int32* var_11;
        const wp::int32 var_12 = 0;
        bool var_13;
        wp::int32 var_14;
        wp::vec_t<3, wp::int32> var_15;
        const wp::int32 var_16 = 0;
        wp::int32 var_17;
        const wp::int32 var_18 = 1;
        wp::int32 var_19;
        const wp::int32 var_20 = 2;
        wp::int32 var_21;
        wp::vec_t<3, wp::int32> var_22;
        const wp::int32 var_23 = 0;
        wp::int32 var_24;
        const wp::int32 var_25 = 1;
        wp::int32 var_26;
        const wp::int32 var_27 = 2;
        wp::int32 var_28;
        wp::int32 var_29;
        wp::int32 var_30;
        wp::int32 var_31;
        wp::int32 var_32;
        wp::int32 var_33;
        wp::int32 var_34;
        wp::float32 var_35;
        const wp::int32 var_36 = 0;
        wp::float32 var_37;
        wp::float32 var_38;
        wp::float32 var_39;
        const wp::int32 var_40 = 1;
        wp::float32 var_41;
        wp::float32 var_42;
        wp::float32 var_43;
        const wp::int32 var_44 = 2;
        wp::float32 var_45;
        wp::float32 var_46;
        wp::vec_t<3, wp::float32> var_47;
        wp::vec_t<3, wp::float32> var_48;
        const wp::float32 var_49 = 10000.0;
        wp::float32 var_50;
        wp::int32* var_51;
        wp::int32 var_52;
        wp::int32 var_53;
        const wp::int32 var_54 = 0;
        bool var_55;
        wp::vec_t<3, wp::int32> var_56;
        const wp::int32 var_57 = 0;
        wp::int32 var_58;
        wp::int32 var_59;
        wp::int32 var_60;
        const wp::int32 var_61 = 1;
        wp::int32 var_62;
        wp::int32 var_63;
        wp::int32 var_64;
        const wp::int32 var_65 = 2;
        wp::int32 var_66;
        wp::int32 var_67;
        wp::int32 var_68;
        wp::int32 var_69;
        wp::float32 var_70;
        wp::float32 var_71;
        const wp::float32 var_72 = 0.0;
        const wp::float32 var_73 = 1.0;
        wp::float32 var_74;
        const wp::float32 var_75 = 255.0;
        wp::float32 var_76;
        wp::uint8 var_77;
        //---------
        // forward
        // def populate_subgrid_texture_uint8_kernel(                                             <L 624>
        // tid = wp.tid()                                                                         <L 645>
        var_0 = builtin_tid1d();
        // total_subgrids = num_subgrids_x * num_subgrids_y * num_subgrids_z                      <L 647>
        var_1 = wp::mul(var_num_subgrids_x, var_num_subgrids_y);
        var_2 = wp::mul(var_1, var_num_subgrids_z);
        // samples_per_dim = cells_per_subgrid + 1                                                <L 648>
        var_4 = wp::add(var_cells_per_subgrid, var_3);
        // samples_per_subgrid = samples_per_dim * samples_per_dim * samples_per_dim              <L 649>
        var_5 = wp::mul(var_4, var_4);
        var_6 = wp::mul(var_5, var_4);
        // subgrid_idx = tid // samples_per_subgrid                                               <L 651>
        var_7 = wp::floordiv(var_0, var_6);
        // local_sample = tid - subgrid_idx * samples_per_subgrid                                 <L 652>
        var_8 = wp::mul(var_7, var_6);
        var_9 = wp::sub(var_0, var_8);
        // if subgrid_idx >= total_subgrids:                                                      <L 654>
        var_10 = (var_7 >= var_2);
        if (var_10) {
            // return                                                                             <L 655>
            continue;
        }
        // if subgrid_required[subgrid_idx] == 0:                                                 <L 656>
        var_11 = wp::address(var_subgrid_required, var_7);
        var_14 = wp::load(var_11);
        var_13 = (var_14 == var_12);
        if (var_13) {
            // return                                                                             <L 657>
            continue;
        }
        // subgrid_coords = _id_to_xyz(subgrid_idx, num_subgrids_x, num_subgrids_y)               <L 659>
        var_15 = _id_to_xyz_0(var_7, var_num_subgrids_x, var_num_subgrids_y);
        // block_x = subgrid_coords[0]                                                            <L 660>
        var_17 = wp::extract(var_15, var_16);
        // block_y = subgrid_coords[1]                                                            <L 661>
        var_19 = wp::extract(var_15, var_18);
        // block_z = subgrid_coords[2]                                                            <L 662>
        var_21 = wp::extract(var_15, var_20);
        // local_coords = _id_to_xyz(local_sample, samples_per_dim, samples_per_dim)              <L 664>
        var_22 = _id_to_xyz_0(var_9, var_4, var_4);
        // lx = local_coords[0]                                                                   <L 665>
        var_24 = wp::extract(var_22, var_23);
        // ly = local_coords[1]                                                                   <L 666>
        var_26 = wp::extract(var_22, var_25);
        // lz = local_coords[2]                                                                   <L 667>
        var_28 = wp::extract(var_22, var_27);
        // gx = block_x * cells_per_subgrid + lx                                                  <L 669>
        var_29 = wp::mul(var_17, var_cells_per_subgrid);
        var_30 = wp::add(var_29, var_24);
        // gy = block_y * cells_per_subgrid + ly                                                  <L 670>
        var_31 = wp::mul(var_19, var_cells_per_subgrid);
        var_32 = wp::add(var_31, var_26);
        // gz = block_z * cells_per_subgrid + lz                                                  <L 671>
        var_33 = wp::mul(var_21, var_cells_per_subgrid);
        var_34 = wp::add(var_33, var_28);
        // pos = min_corner + wp.vec3(                                                            <L 673>
        // float(gx) * cell_size[0],                                                              <L 674>
        var_35 = wp::float(var_30);
        var_37 = wp::extract(var_cell_size, var_36);
        var_38 = wp::mul(var_35, var_37);
        // float(gy) * cell_size[1],                                                              <L 675>
        var_39 = wp::float(var_32);
        var_41 = wp::extract(var_cell_size, var_40);
        var_42 = wp::mul(var_39, var_41);
        // float(gz) * cell_size[2],                                                              <L 676>
        var_43 = wp::float(var_34);
        var_45 = wp::extract(var_cell_size, var_44);
        var_46 = wp::mul(var_43, var_45);
        var_47 = wp::vec_t<3, wp::float32>(var_38, var_42, var_46);
        var_48 = wp::add(var_min_corner, var_47);
        // sdf_val = query_sdf(mesh, shape_type, shape_scale, pos, 10000.0, winding_threshold)       <L 678>
        var_50 = _create_source_kernels__locals__query_sdf_0(var_mesh, var_shape_type, var_shape_scale, var_48, var_49, var_winding_threshold);
        // address = subgrid_addresses[subgrid_idx]                                               <L 680>
        var_51 = wp::address(var_subgrid_addresses, var_7);
        var_53 = wp::load(var_51);
        var_52 = wp::copy(var_53);
        // if address < 0:                                                                        <L 681>
        var_55 = (var_52 < var_54);
        if (var_55) {
            // return                                                                             <L 682>
            continue;
        }
        // ac = _write_subgrid_slot(                                                              <L 684>
        // subgrid_start_slots, address, tex_blocks_per_dim, block_x, block_y, block_z, local_sample       <L 685>
        var_56 = _write_subgrid_slot_0(var_subgrid_start_slots, var_52, var_tex_blocks_per_dim, var_17, var_19, var_21, var_9);
        // tex_idx = _idx3d(                                                                      <L 687>
        // ac[0] * samples_per_dim + lx, ac[1] * samples_per_dim + ly, ac[2] * samples_per_dim + lz, tex_size, tex_size       <L 688>
        var_58 = wp::extract(var_56, var_57);
        var_59 = wp::mul(var_58, var_4);
        var_60 = wp::add(var_59, var_24);
        var_62 = wp::extract(var_56, var_61);
        var_63 = wp::mul(var_62, var_4);
        var_64 = wp::add(var_63, var_26);
        var_66 = wp::extract(var_56, var_65);
        var_67 = wp::mul(var_66, var_4);
        var_68 = wp::add(var_67, var_28);
        var_69 = _idx3d_0(var_60, var_64, var_68, var_tex_size, var_tex_size);
        // v_normalized = wp.clamp((sdf_val - sdf_min) * sdf_range_inv, 0.0, 1.0)                 <L 690>
        var_70 = wp::sub(var_50, var_sdf_min);
        var_71 = wp::mul(var_70, var_sdf_range_inv);
        var_74 = wp::clamp(var_71, var_72, var_73);
        // subgrid_texture[tex_idx] = wp.uint8(v_normalized * 255.0)                              <L 691>
        var_76 = wp::mul(var_74, var_75);
        var_77 = wp::uint8(var_76);
        wp::array_store(var_subgrid_texture, var_69, var_77);
    }
}



extern "C" __global__ void _create_source_kernels__locals__populate_subgrid_texture_uint8_kernel_00531ad4_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::uint64 var_mesh,
    wp::int32 var_shape_type,
    wp::vec_t<3, wp::float32> var_shape_scale,
    wp::array_t<wp::int32> var_subgrid_required,
    wp::array_t<wp::int32> var_subgrid_addresses,
    wp::array_t<wp::uint32> var_subgrid_start_slots,
    wp::array_t<wp::uint8> var_subgrid_texture,
    wp::int32 var_cells_per_subgrid,
    wp::vec_t<3, wp::float32> var_min_corner,
    wp::vec_t<3, wp::float32> var_cell_size,
    wp::float32 var_winding_threshold,
    wp::int32 var_num_subgrids_x,
    wp::int32 var_num_subgrids_y,
    wp::int32 var_num_subgrids_z,
    wp::int32 var_tex_blocks_per_dim,
    wp::int32 var_tex_size,
    wp::float32 var_sdf_min,
    wp::float32 var_sdf_range_inv,
    wp::uint64 adj_mesh,
    wp::int32 adj_shape_type,
    wp::vec_t<3, wp::float32> adj_shape_scale,
    wp::array_t<wp::int32> adj_subgrid_required,
    wp::array_t<wp::int32> adj_subgrid_addresses,
    wp::array_t<wp::uint32> adj_subgrid_start_slots,
    wp::array_t<wp::uint8> adj_subgrid_texture,
    wp::int32 adj_cells_per_subgrid,
    wp::vec_t<3, wp::float32> adj_min_corner,
    wp::vec_t<3, wp::float32> adj_cell_size,
    wp::float32 adj_winding_threshold,
    wp::int32 adj_num_subgrids_x,
    wp::int32 adj_num_subgrids_y,
    wp::int32 adj_num_subgrids_z,
    wp::int32 adj_tex_blocks_per_dim,
    wp::int32 adj_tex_size,
    wp::float32 adj_sdf_min,
    wp::float32 adj_sdf_range_inv)
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
        wp::int32 var_2;
        const wp::int32 var_3 = 1;
        wp::int32 var_4;
        wp::int32 var_5;
        wp::int32 var_6;
        wp::int32 var_7;
        wp::int32 var_8;
        wp::int32 var_9;
        bool var_10;
        wp::int32* var_11;
        const wp::int32 var_12 = 0;
        bool var_13;
        wp::int32 var_14;
        wp::vec_t<3, wp::int32> var_15;
        const wp::int32 var_16 = 0;
        wp::int32 var_17;
        const wp::int32 var_18 = 1;
        wp::int32 var_19;
        const wp::int32 var_20 = 2;
        wp::int32 var_21;
        wp::vec_t<3, wp::int32> var_22;
        const wp::int32 var_23 = 0;
        wp::int32 var_24;
        const wp::int32 var_25 = 1;
        wp::int32 var_26;
        const wp::int32 var_27 = 2;
        wp::int32 var_28;
        wp::int32 var_29;
        wp::int32 var_30;
        wp::int32 var_31;
        wp::int32 var_32;
        wp::int32 var_33;
        wp::int32 var_34;
        wp::float32 var_35;
        const wp::int32 var_36 = 0;
        wp::float32 var_37;
        wp::float32 var_38;
        wp::float32 var_39;
        const wp::int32 var_40 = 1;
        wp::float32 var_41;
        wp::float32 var_42;
        wp::float32 var_43;
        const wp::int32 var_44 = 2;
        wp::float32 var_45;
        wp::float32 var_46;
        wp::vec_t<3, wp::float32> var_47;
        wp::vec_t<3, wp::float32> var_48;
        const wp::float32 var_49 = 10000.0;
        wp::float32 var_50;
        wp::int32* var_51;
        wp::int32 var_52;
        wp::int32 var_53;
        const wp::int32 var_54 = 0;
        bool var_55;
        wp::vec_t<3, wp::int32> var_56;
        const wp::int32 var_57 = 0;
        wp::int32 var_58;
        wp::int32 var_59;
        wp::int32 var_60;
        const wp::int32 var_61 = 1;
        wp::int32 var_62;
        wp::int32 var_63;
        wp::int32 var_64;
        const wp::int32 var_65 = 2;
        wp::int32 var_66;
        wp::int32 var_67;
        wp::int32 var_68;
        wp::int32 var_69;
        wp::float32 var_70;
        wp::float32 var_71;
        const wp::float32 var_72 = 0.0;
        const wp::float32 var_73 = 1.0;
        wp::float32 var_74;
        const wp::float32 var_75 = 255.0;
        wp::float32 var_76;
        wp::uint8 var_77;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::int32 adj_2 = {};
        wp::int32 adj_3 = {};
        wp::int32 adj_4 = {};
        wp::int32 adj_5 = {};
        wp::int32 adj_6 = {};
        wp::int32 adj_7 = {};
        wp::int32 adj_8 = {};
        wp::int32 adj_9 = {};
        bool adj_10 = {};
        wp::int32 adj_11 = {};
        wp::int32 adj_12 = {};
        bool adj_13 = {};
        wp::int32 adj_14 = {};
        wp::vec_t<3, wp::int32> adj_15 = {};
        wp::int32 adj_16 = {};
        wp::int32 adj_17 = {};
        wp::int32 adj_18 = {};
        wp::int32 adj_19 = {};
        wp::int32 adj_20 = {};
        wp::int32 adj_21 = {};
        wp::vec_t<3, wp::int32> adj_22 = {};
        wp::int32 adj_23 = {};
        wp::int32 adj_24 = {};
        wp::int32 adj_25 = {};
        wp::int32 adj_26 = {};
        wp::int32 adj_27 = {};
        wp::int32 adj_28 = {};
        wp::int32 adj_29 = {};
        wp::int32 adj_30 = {};
        wp::int32 adj_31 = {};
        wp::int32 adj_32 = {};
        wp::int32 adj_33 = {};
        wp::int32 adj_34 = {};
        wp::float32 adj_35 = {};
        wp::int32 adj_36 = {};
        wp::float32 adj_37 = {};
        wp::float32 adj_38 = {};
        wp::float32 adj_39 = {};
        wp::int32 adj_40 = {};
        wp::float32 adj_41 = {};
        wp::float32 adj_42 = {};
        wp::float32 adj_43 = {};
        wp::int32 adj_44 = {};
        wp::float32 adj_45 = {};
        wp::float32 adj_46 = {};
        wp::vec_t<3, wp::float32> adj_47 = {};
        wp::vec_t<3, wp::float32> adj_48 = {};
        wp::float32 adj_49 = {};
        wp::float32 adj_50 = {};
        wp::int32 adj_51 = {};
        wp::int32 adj_52 = {};
        wp::int32 adj_53 = {};
        wp::int32 adj_54 = {};
        bool adj_55 = {};
        wp::vec_t<3, wp::int32> adj_56 = {};
        wp::int32 adj_57 = {};
        wp::int32 adj_58 = {};
        wp::int32 adj_59 = {};
        wp::int32 adj_60 = {};
        wp::int32 adj_61 = {};
        wp::int32 adj_62 = {};
        wp::int32 adj_63 = {};
        wp::int32 adj_64 = {};
        wp::int32 adj_65 = {};
        wp::int32 adj_66 = {};
        wp::int32 adj_67 = {};
        wp::int32 adj_68 = {};
        wp::int32 adj_69 = {};
        wp::float32 adj_70 = {};
        wp::float32 adj_71 = {};
        wp::float32 adj_72 = {};
        wp::float32 adj_73 = {};
        wp::float32 adj_74 = {};
        wp::float32 adj_75 = {};
        wp::float32 adj_76 = {};
        wp::uint8 adj_77 = {};
        //---------
        // forward
        // def populate_subgrid_texture_uint8_kernel(                                             <L 624>
        // tid = wp.tid()                                                                         <L 645>
        var_0 = builtin_tid1d();
        // total_subgrids = num_subgrids_x * num_subgrids_y * num_subgrids_z                      <L 647>
        var_1 = wp::mul(var_num_subgrids_x, var_num_subgrids_y);
        var_2 = wp::mul(var_1, var_num_subgrids_z);
        // samples_per_dim = cells_per_subgrid + 1                                                <L 648>
        var_4 = wp::add(var_cells_per_subgrid, var_3);
        // samples_per_subgrid = samples_per_dim * samples_per_dim * samples_per_dim              <L 649>
        var_5 = wp::mul(var_4, var_4);
        var_6 = wp::mul(var_5, var_4);
        // subgrid_idx = tid // samples_per_subgrid                                               <L 651>
        var_7 = wp::floordiv(var_0, var_6);
        // local_sample = tid - subgrid_idx * samples_per_subgrid                                 <L 652>
        var_8 = wp::mul(var_7, var_6);
        var_9 = wp::sub(var_0, var_8);
        // if subgrid_idx >= total_subgrids:                                                      <L 654>
        var_10 = (var_7 >= var_2);
        if (var_10) {
            // return                                                                             <L 655>
            goto label0;
        }
        // if subgrid_required[subgrid_idx] == 0:                                                 <L 656>
        var_11 = wp::address(var_subgrid_required, var_7);
        var_14 = wp::load(var_11);
        var_13 = (var_14 == var_12);
        if (var_13) {
            // return                                                                             <L 657>
            goto label1;
        }
        // subgrid_coords = _id_to_xyz(subgrid_idx, num_subgrids_x, num_subgrids_y)               <L 659>
        var_15 = _id_to_xyz_0(var_7, var_num_subgrids_x, var_num_subgrids_y);
        // block_x = subgrid_coords[0]                                                            <L 660>
        var_17 = wp::extract(var_15, var_16);
        // block_y = subgrid_coords[1]                                                            <L 661>
        var_19 = wp::extract(var_15, var_18);
        // block_z = subgrid_coords[2]                                                            <L 662>
        var_21 = wp::extract(var_15, var_20);
        // local_coords = _id_to_xyz(local_sample, samples_per_dim, samples_per_dim)              <L 664>
        var_22 = _id_to_xyz_0(var_9, var_4, var_4);
        // lx = local_coords[0]                                                                   <L 665>
        var_24 = wp::extract(var_22, var_23);
        // ly = local_coords[1]                                                                   <L 666>
        var_26 = wp::extract(var_22, var_25);
        // lz = local_coords[2]                                                                   <L 667>
        var_28 = wp::extract(var_22, var_27);
        // gx = block_x * cells_per_subgrid + lx                                                  <L 669>
        var_29 = wp::mul(var_17, var_cells_per_subgrid);
        var_30 = wp::add(var_29, var_24);
        // gy = block_y * cells_per_subgrid + ly                                                  <L 670>
        var_31 = wp::mul(var_19, var_cells_per_subgrid);
        var_32 = wp::add(var_31, var_26);
        // gz = block_z * cells_per_subgrid + lz                                                  <L 671>
        var_33 = wp::mul(var_21, var_cells_per_subgrid);
        var_34 = wp::add(var_33, var_28);
        // pos = min_corner + wp.vec3(                                                            <L 673>
        // float(gx) * cell_size[0],                                                              <L 674>
        var_35 = wp::float(var_30);
        var_37 = wp::extract(var_cell_size, var_36);
        var_38 = wp::mul(var_35, var_37);
        // float(gy) * cell_size[1],                                                              <L 675>
        var_39 = wp::float(var_32);
        var_41 = wp::extract(var_cell_size, var_40);
        var_42 = wp::mul(var_39, var_41);
        // float(gz) * cell_size[2],                                                              <L 676>
        var_43 = wp::float(var_34);
        var_45 = wp::extract(var_cell_size, var_44);
        var_46 = wp::mul(var_43, var_45);
        var_47 = wp::vec_t<3, wp::float32>(var_38, var_42, var_46);
        var_48 = wp::add(var_min_corner, var_47);
        // sdf_val = query_sdf(mesh, shape_type, shape_scale, pos, 10000.0, winding_threshold)       <L 678>
        var_50 = _create_source_kernels__locals__query_sdf_0(var_mesh, var_shape_type, var_shape_scale, var_48, var_49, var_winding_threshold);
        // address = subgrid_addresses[subgrid_idx]                                               <L 680>
        var_51 = wp::address(var_subgrid_addresses, var_7);
        var_53 = wp::load(var_51);
        var_52 = wp::copy(var_53);
        // if address < 0:                                                                        <L 681>
        var_55 = (var_52 < var_54);
        if (var_55) {
            // return                                                                             <L 682>
            goto label2;
        }
        // ac = _write_subgrid_slot(                                                              <L 684>
        // subgrid_start_slots, address, tex_blocks_per_dim, block_x, block_y, block_z, local_sample       <L 685>
        var_56 = _write_subgrid_slot_0(var_subgrid_start_slots, var_52, var_tex_blocks_per_dim, var_17, var_19, var_21, var_9);
        // tex_idx = _idx3d(                                                                      <L 687>
        // ac[0] * samples_per_dim + lx, ac[1] * samples_per_dim + ly, ac[2] * samples_per_dim + lz, tex_size, tex_size       <L 688>
        var_58 = wp::extract(var_56, var_57);
        var_59 = wp::mul(var_58, var_4);
        var_60 = wp::add(var_59, var_24);
        var_62 = wp::extract(var_56, var_61);
        var_63 = wp::mul(var_62, var_4);
        var_64 = wp::add(var_63, var_26);
        var_66 = wp::extract(var_56, var_65);
        var_67 = wp::mul(var_66, var_4);
        var_68 = wp::add(var_67, var_28);
        var_69 = _idx3d_0(var_60, var_64, var_68, var_tex_size, var_tex_size);
        // v_normalized = wp.clamp((sdf_val - sdf_min) * sdf_range_inv, 0.0, 1.0)                 <L 690>
        var_70 = wp::sub(var_50, var_sdf_min);
        var_71 = wp::mul(var_70, var_sdf_range_inv);
        var_74 = wp::clamp(var_71, var_72, var_73);
        // subgrid_texture[tex_idx] = wp.uint8(v_normalized * 255.0)                              <L 691>
        var_76 = wp::mul(var_74, var_75);
        var_77 = wp::uint8(var_76);
        // wp::array_store(var_subgrid_texture, var_69, var_77);
        //---------
        // reverse
        wp::adj_array_store(var_subgrid_texture, var_69, var_77, adj_subgrid_texture, adj_69, adj_77);
        wp::adj_mul(var_74, var_75, adj_74, adj_75, adj_76);
        // adj: subgrid_texture[tex_idx] = wp.uint8(v_normalized * 255.0)                         <L 691>
        wp::adj_clamp(var_71, var_72, var_73, adj_71, adj_72, adj_73, adj_74);
        wp::adj_mul(var_70, var_sdf_range_inv, adj_70, adj_sdf_range_inv, adj_71);
        wp::adj_sub(var_50, var_sdf_min, adj_50, adj_sdf_min, adj_70);
        // adj: v_normalized = wp.clamp((sdf_val - sdf_min) * sdf_range_inv, 0.0, 1.0)            <L 690>
        adj__idx3d_0(var_60, var_64, var_68, var_tex_size, var_tex_size, adj_60, adj_64, adj_68, adj_tex_size, adj_tex_size, adj_69);
        wp::adj_add(var_67, var_28, adj_67, adj_28, adj_68);
        wp::adj_mul(var_66, var_4, adj_66, adj_4, adj_67);
        wp::adj_extract(var_56, var_65, adj_56, adj_65, adj_66);
        wp::adj_add(var_63, var_26, adj_63, adj_26, adj_64);
        wp::adj_mul(var_62, var_4, adj_62, adj_4, adj_63);
        wp::adj_extract(var_56, var_61, adj_56, adj_61, adj_62);
        wp::adj_add(var_59, var_24, adj_59, adj_24, adj_60);
        wp::adj_mul(var_58, var_4, adj_58, adj_4, adj_59);
        wp::adj_extract(var_56, var_57, adj_56, adj_57, adj_58);
        // adj: ac[0] * samples_per_dim + lx, ac[1] * samples_per_dim + ly, ac[2] * samples_per_dim + lz, tex_size, tex_size  <L 688>
        // adj: tex_idx = _idx3d(                                                                 <L 687>
        adj__write_subgrid_slot_0(var_subgrid_start_slots, var_52, var_tex_blocks_per_dim, var_17, var_19, var_21, var_9, adj_subgrid_start_slots, adj_52, adj_tex_blocks_per_dim, adj_17, adj_19, adj_21, adj_9, adj_56);
        // adj: subgrid_start_slots, address, tex_blocks_per_dim, block_x, block_y, block_z, local_sample  <L 685>
        // adj: ac = _write_subgrid_slot(                                                         <L 684>
        if (var_55) {
            label2:;
            // adj: return                                                                        <L 682>
        }
        // adj: if address < 0:                                                                   <L 681>
        wp::adj_copy(var_53, adj_51, adj_52);
        wp::adj_address(var_subgrid_addresses, var_7, adj_subgrid_addresses, adj_7, adj_51);
        // adj: address = subgrid_addresses[subgrid_idx]                                          <L 680>
        adj__create_source_kernels__locals__query_sdf_0(var_mesh, var_shape_type, var_shape_scale, var_48, var_49, var_winding_threshold, adj_mesh, adj_shape_type, adj_shape_scale, adj_48, adj_49, adj_winding_threshold, adj_50);
        // adj: sdf_val = query_sdf(mesh, shape_type, shape_scale, pos, 10000.0, winding_threshold)  <L 678>
        wp::adj_add(var_min_corner, var_47, adj_min_corner, adj_47, adj_48);
        wp::adj_vec_t(var_38, var_42, var_46, adj_38, adj_42, adj_46, adj_47);
        wp::adj_mul(var_43, var_45, adj_43, adj_45, adj_46);
        wp::adj_extract(var_cell_size, var_44, adj_cell_size, adj_44, adj_45);
        wp::adj_float(var_34, adj_34, adj_43);
        // adj: float(gz) * cell_size[2],                                                         <L 676>
        wp::adj_mul(var_39, var_41, adj_39, adj_41, adj_42);
        wp::adj_extract(var_cell_size, var_40, adj_cell_size, adj_40, adj_41);
        wp::adj_float(var_32, adj_32, adj_39);
        // adj: float(gy) * cell_size[1],                                                         <L 675>
        wp::adj_mul(var_35, var_37, adj_35, adj_37, adj_38);
        wp::adj_extract(var_cell_size, var_36, adj_cell_size, adj_36, adj_37);
        wp::adj_float(var_30, adj_30, adj_35);
        // adj: float(gx) * cell_size[0],                                                         <L 674>
        // adj: pos = min_corner + wp.vec3(                                                       <L 673>
        wp::adj_add(var_33, var_28, adj_33, adj_28, adj_34);
        wp::adj_mul(var_21, var_cells_per_subgrid, adj_21, adj_cells_per_subgrid, adj_33);
        // adj: gz = block_z * cells_per_subgrid + lz                                             <L 671>
        wp::adj_add(var_31, var_26, adj_31, adj_26, adj_32);
        wp::adj_mul(var_19, var_cells_per_subgrid, adj_19, adj_cells_per_subgrid, adj_31);
        // adj: gy = block_y * cells_per_subgrid + ly                                             <L 670>
        wp::adj_add(var_29, var_24, adj_29, adj_24, adj_30);
        wp::adj_mul(var_17, var_cells_per_subgrid, adj_17, adj_cells_per_subgrid, adj_29);
        // adj: gx = block_x * cells_per_subgrid + lx                                             <L 669>
        wp::adj_extract(var_22, var_27, adj_22, adj_27, adj_28);
        // adj: lz = local_coords[2]                                                              <L 667>
        wp::adj_extract(var_22, var_25, adj_22, adj_25, adj_26);
        // adj: ly = local_coords[1]                                                              <L 666>
        wp::adj_extract(var_22, var_23, adj_22, adj_23, adj_24);
        // adj: lx = local_coords[0]                                                              <L 665>
        adj__id_to_xyz_0(var_9, var_4, var_4, adj_9, adj_4, adj_4, adj_22);
        // adj: local_coords = _id_to_xyz(local_sample, samples_per_dim, samples_per_dim)         <L 664>
        wp::adj_extract(var_15, var_20, adj_15, adj_20, adj_21);
        // adj: block_z = subgrid_coords[2]                                                       <L 662>
        wp::adj_extract(var_15, var_18, adj_15, adj_18, adj_19);
        // adj: block_y = subgrid_coords[1]                                                       <L 661>
        wp::adj_extract(var_15, var_16, adj_15, adj_16, adj_17);
        // adj: block_x = subgrid_coords[0]                                                       <L 660>
        adj__id_to_xyz_0(var_7, var_num_subgrids_x, var_num_subgrids_y, adj_7, adj_num_subgrids_x, adj_num_subgrids_y, adj_15);
        // adj: subgrid_coords = _id_to_xyz(subgrid_idx, num_subgrids_x, num_subgrids_y)          <L 659>
        if (var_13) {
            label1:;
            // adj: return                                                                        <L 657>
        }
        wp::adj_address(var_subgrid_required, var_7, adj_subgrid_required, adj_7, adj_11);
        // adj: if subgrid_required[subgrid_idx] == 0:                                            <L 656>
        if (var_10) {
            label0:;
            // adj: return                                                                        <L 655>
        }
        // adj: if subgrid_idx >= total_subgrids:                                                 <L 654>
        wp::adj_sub(var_0, var_8, adj_0, adj_8, adj_9);
        wp::adj_mul(var_7, var_6, adj_7, adj_6, adj_8);
        // adj: local_sample = tid - subgrid_idx * samples_per_subgrid                            <L 652>
        // adj: subgrid_idx = tid // samples_per_subgrid                                          <L 651>
        wp::adj_mul(var_5, var_4, adj_5, adj_4, adj_6);
        wp::adj_mul(var_4, var_4, adj_4, adj_4, adj_5);
        // adj: samples_per_subgrid = samples_per_dim * samples_per_dim * samples_per_dim         <L 649>
        wp::adj_add(var_cells_per_subgrid, var_3, adj_cells_per_subgrid, adj_3, adj_4);
        // adj: samples_per_dim = cells_per_subgrid + 1                                           <L 648>
        wp::adj_mul(var_1, var_num_subgrids_z, adj_1, adj_num_subgrids_z, adj_2);
        wp::adj_mul(var_num_subgrids_x, var_num_subgrids_y, adj_num_subgrids_x, adj_num_subgrids_y, adj_1);
        // adj: total_subgrids = num_subgrids_x * num_subgrids_y * num_subgrids_z                 <L 647>
        // adj: tid = wp.tid()                                                                    <L 645>
        // adj: def populate_subgrid_texture_uint8_kernel(                                        <L 624>
        continue;
    }
}



extern "C" __global__ void _count_isomesh_faces_texture_kernel_d0091643_cuda_kernel_forward(
    wp::launch_bounds_t<4> dim,
    wp::array_t<TextureSDFData_93572308> var_sdf_array,
    wp::array_t<wp::vec_t<3, wp::int32>> var_active_coarse_cells,
    wp::int32 var_subgrid_size,
    wp::array_t<wp::int32> var_tri_range_table,
    wp::array_t<wp::vec_t<3, wp::uint8>> var_corner_offsets_table,
    wp::float32 var_isovalue,
    wp::array_t<wp::int32> var_face_count)
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
        wp::int32 var_2;
        wp::int32 var_3;
        const wp::int32 var_4 = 0;
        TextureSDFData_93572308* var_5;
        TextureSDFData_93572308 var_6;
        TextureSDFData_93572308 var_7;
        wp::vec_t<3, wp::int32>* var_8;
        wp::vec_t<3, wp::int32> var_9;
        wp::vec_t<3, wp::int32> var_10;
        const wp::int32 var_11 = 0;
        wp::int32 var_12;
        wp::int32 var_13;
        wp::int32 var_14;
        const wp::int32 var_15 = 1;
        wp::int32 var_16;
        wp::int32 var_17;
        wp::int32 var_18;
        const wp::int32 var_19 = 2;
        wp::int32 var_20;
        wp::int32 var_21;
        wp::int32 var_22;
        const wp::int32 var_23 = 0;
        wp::int32 var_24;
        const wp::int32 var_25 = 0;
        wp::vec_t<3, wp::uint8>* var_26;
        wp::vec_t<3, wp::int32> var_27;
        wp::vec_t<3, wp::uint8> var_28;
        const wp::int32 var_29 = 0;
        wp::int32 var_30;
        wp::int32 var_31;
        const wp::int32 var_32 = 1;
        wp::int32 var_33;
        wp::int32 var_34;
        const wp::int32 var_35 = 2;
        wp::int32 var_36;
        wp::int32 var_37;
        wp::float32 var_38;
        bool var_39;
        bool var_40;
        const wp::int32 var_41 = 1;
        wp::int32 var_42;
        wp::int32 var_43;
        wp::int32 var_44;
        const wp::int32 var_45 = 1;
        wp::vec_t<3, wp::uint8>* var_46;
        wp::vec_t<3, wp::int32> var_47;
        wp::vec_t<3, wp::uint8> var_48;
        const wp::int32 var_49 = 0;
        wp::int32 var_50;
        wp::int32 var_51;
        const wp::int32 var_52 = 1;
        wp::int32 var_53;
        wp::int32 var_54;
        const wp::int32 var_55 = 2;
        wp::int32 var_56;
        wp::int32 var_57;
        wp::float32 var_58;
        bool var_59;
        bool var_60;
        const wp::int32 var_61 = 1;
        wp::int32 var_62;
        wp::int32 var_63;
        wp::int32 var_64;
        const wp::int32 var_65 = 2;
        wp::vec_t<3, wp::uint8>* var_66;
        wp::vec_t<3, wp::int32> var_67;
        wp::vec_t<3, wp::uint8> var_68;
        const wp::int32 var_69 = 0;
        wp::int32 var_70;
        wp::int32 var_71;
        const wp::int32 var_72 = 1;
        wp::int32 var_73;
        wp::int32 var_74;
        const wp::int32 var_75 = 2;
        wp::int32 var_76;
        wp::int32 var_77;
        wp::float32 var_78;
        bool var_79;
        bool var_80;
        const wp::int32 var_81 = 1;
        wp::int32 var_82;
        wp::int32 var_83;
        wp::int32 var_84;
        const wp::int32 var_85 = 3;
        wp::vec_t<3, wp::uint8>* var_86;
        wp::vec_t<3, wp::int32> var_87;
        wp::vec_t<3, wp::uint8> var_88;
        const wp::int32 var_89 = 0;
        wp::int32 var_90;
        wp::int32 var_91;
        const wp::int32 var_92 = 1;
        wp::int32 var_93;
        wp::int32 var_94;
        const wp::int32 var_95 = 2;
        wp::int32 var_96;
        wp::int32 var_97;
        wp::float32 var_98;
        bool var_99;
        bool var_100;
        const wp::int32 var_101 = 1;
        wp::int32 var_102;
        wp::int32 var_103;
        wp::int32 var_104;
        const wp::int32 var_105 = 4;
        wp::vec_t<3, wp::uint8>* var_106;
        wp::vec_t<3, wp::int32> var_107;
        wp::vec_t<3, wp::uint8> var_108;
        const wp::int32 var_109 = 0;
        wp::int32 var_110;
        wp::int32 var_111;
        const wp::int32 var_112 = 1;
        wp::int32 var_113;
        wp::int32 var_114;
        const wp::int32 var_115 = 2;
        wp::int32 var_116;
        wp::int32 var_117;
        wp::float32 var_118;
        bool var_119;
        bool var_120;
        const wp::int32 var_121 = 1;
        wp::int32 var_122;
        wp::int32 var_123;
        wp::int32 var_124;
        const wp::int32 var_125 = 5;
        wp::vec_t<3, wp::uint8>* var_126;
        wp::vec_t<3, wp::int32> var_127;
        wp::vec_t<3, wp::uint8> var_128;
        const wp::int32 var_129 = 0;
        wp::int32 var_130;
        wp::int32 var_131;
        const wp::int32 var_132 = 1;
        wp::int32 var_133;
        wp::int32 var_134;
        const wp::int32 var_135 = 2;
        wp::int32 var_136;
        wp::int32 var_137;
        wp::float32 var_138;
        bool var_139;
        bool var_140;
        const wp::int32 var_141 = 1;
        wp::int32 var_142;
        wp::int32 var_143;
        wp::int32 var_144;
        const wp::int32 var_145 = 6;
        wp::vec_t<3, wp::uint8>* var_146;
        wp::vec_t<3, wp::int32> var_147;
        wp::vec_t<3, wp::uint8> var_148;
        const wp::int32 var_149 = 0;
        wp::int32 var_150;
        wp::int32 var_151;
        const wp::int32 var_152 = 1;
        wp::int32 var_153;
        wp::int32 var_154;
        const wp::int32 var_155 = 2;
        wp::int32 var_156;
        wp::int32 var_157;
        wp::float32 var_158;
        bool var_159;
        bool var_160;
        const wp::int32 var_161 = 1;
        wp::int32 var_162;
        wp::int32 var_163;
        wp::int32 var_164;
        const wp::int32 var_165 = 7;
        wp::vec_t<3, wp::uint8>* var_166;
        wp::vec_t<3, wp::int32> var_167;
        wp::vec_t<3, wp::uint8> var_168;
        const wp::int32 var_169 = 0;
        wp::int32 var_170;
        wp::int32 var_171;
        const wp::int32 var_172 = 1;
        wp::int32 var_173;
        wp::int32 var_174;
        const wp::int32 var_175 = 2;
        wp::int32 var_176;
        wp::int32 var_177;
        wp::float32 var_178;
        bool var_179;
        bool var_180;
        const wp::int32 var_181 = 1;
        wp::int32 var_182;
        wp::int32 var_183;
        wp::int32 var_184;
        wp::int32* var_185;
        wp::int32 var_186;
        wp::int32 var_187;
        const wp::int32 var_188 = 1;
        wp::int32 var_189;
        wp::int32* var_190;
        wp::int32 var_191;
        wp::int32 var_192;
        wp::int32 var_193;
        const wp::int32 var_194 = 3;
        wp::int32 var_195;
        const wp::int32 var_196 = 0;
        bool var_197;
        const wp::int32 var_198 = 0;
        wp::int32 var_199;
        //---------
        // forward
        // def _count_isomesh_faces_texture_kernel(                                               <L 2939>
        // cell_idx, local_x, local_y, local_z = wp.tid()                                         <L 2948>
        builtin_tid4d(var_0, var_1, var_2, var_3);
        // sdf = sdf_array[0]                                                                     <L 2949>
        var_5 = wp::address(var_sdf_array, var_4);
        var_7 = wp::load(var_5);
        var_6 = wp::copy(var_7);
        // coarse = active_coarse_cells[cell_idx]                                                 <L 2950>
        var_8 = wp::address(var_active_coarse_cells, var_0);
        var_10 = wp::load(var_8);
        var_9 = wp::copy(var_10);
        // x_id = coarse[0] * subgrid_size + local_x                                              <L 2951>
        var_12 = wp::extract(var_9, var_11);
        var_13 = wp::mul(var_12, var_subgrid_size);
        var_14 = wp::add(var_13, var_1);
        // y_id = coarse[1] * subgrid_size + local_y                                              <L 2952>
        var_16 = wp::extract(var_9, var_15);
        var_17 = wp::mul(var_16, var_subgrid_size);
        var_18 = wp::add(var_17, var_2);
        // z_id = coarse[2] * subgrid_size + local_z                                              <L 2953>
        var_20 = wp::extract(var_9, var_19);
        var_21 = wp::mul(var_20, var_subgrid_size);
        var_22 = wp::add(var_21, var_3);
        // cube_idx = wp.int32(0)                                                                 <L 2955>
        var_24 = wp::int32(var_23);
        // for i in range(8):                                                                     <L 2956>
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 2957>
        var_26 = wp::address(var_corner_offsets_table, var_25);
        var_28 = wp::load(var_26);
        var_27 = wp::vec_t<3, wp::int32>(var_28);
        // v = texture_sample_sdf_at_voxel(sdf, x_id + co.x, y_id + co.y, z_id + co.z)            <L 2958>
        var_30 = wp::extract(var_27, var_29);
        var_31 = wp::add(var_14, var_30);
        var_33 = wp::extract(var_27, var_32);
        var_34 = wp::add(var_18, var_33);
        var_36 = wp::extract(var_27, var_35);
        var_37 = wp::add(var_22, var_36);
        var_38 = texture_sample_sdf_at_voxel_0(var_6, var_31, var_34, var_37);
        // if wp.isnan(v):                                                                        <L 2959>
        var_39 = wp::isnan(var_38);
        if (var_39) {
            // return                                                                             <L 2960>
            continue;
        }
        // if v < isovalue:                                                                       <L 2961>
        var_40 = (var_38 < var_isovalue);
        if (var_40) {
            // cube_idx |= 1 << i                                                                 <L 2962>
            var_42 = wp::lshift(var_41, var_25);
            var_43 = wp::bit_or(var_24, var_42);
        }
        var_44 = wp::where(var_40, var_43, var_24);
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 2957>
        var_46 = wp::address(var_corner_offsets_table, var_45);
        var_48 = wp::load(var_46);
        var_47 = wp::vec_t<3, wp::int32>(var_48);
        // v = texture_sample_sdf_at_voxel(sdf, x_id + co.x, y_id + co.y, z_id + co.z)            <L 2958>
        var_50 = wp::extract(var_47, var_49);
        var_51 = wp::add(var_14, var_50);
        var_53 = wp::extract(var_47, var_52);
        var_54 = wp::add(var_18, var_53);
        var_56 = wp::extract(var_47, var_55);
        var_57 = wp::add(var_22, var_56);
        var_58 = texture_sample_sdf_at_voxel_0(var_6, var_51, var_54, var_57);
        // if wp.isnan(v):                                                                        <L 2959>
        var_59 = wp::isnan(var_58);
        if (var_59) {
            // return                                                                             <L 2960>
            continue;
        }
        // if v < isovalue:                                                                       <L 2961>
        var_60 = (var_58 < var_isovalue);
        if (var_60) {
            // cube_idx |= 1 << i                                                                 <L 2962>
            var_62 = wp::lshift(var_61, var_45);
            var_63 = wp::bit_or(var_44, var_62);
        }
        var_64 = wp::where(var_60, var_63, var_44);
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 2957>
        var_66 = wp::address(var_corner_offsets_table, var_65);
        var_68 = wp::load(var_66);
        var_67 = wp::vec_t<3, wp::int32>(var_68);
        // v = texture_sample_sdf_at_voxel(sdf, x_id + co.x, y_id + co.y, z_id + co.z)            <L 2958>
        var_70 = wp::extract(var_67, var_69);
        var_71 = wp::add(var_14, var_70);
        var_73 = wp::extract(var_67, var_72);
        var_74 = wp::add(var_18, var_73);
        var_76 = wp::extract(var_67, var_75);
        var_77 = wp::add(var_22, var_76);
        var_78 = texture_sample_sdf_at_voxel_0(var_6, var_71, var_74, var_77);
        // if wp.isnan(v):                                                                        <L 2959>
        var_79 = wp::isnan(var_78);
        if (var_79) {
            // return                                                                             <L 2960>
            continue;
        }
        // if v < isovalue:                                                                       <L 2961>
        var_80 = (var_78 < var_isovalue);
        if (var_80) {
            // cube_idx |= 1 << i                                                                 <L 2962>
            var_82 = wp::lshift(var_81, var_65);
            var_83 = wp::bit_or(var_64, var_82);
        }
        var_84 = wp::where(var_80, var_83, var_64);
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 2957>
        var_86 = wp::address(var_corner_offsets_table, var_85);
        var_88 = wp::load(var_86);
        var_87 = wp::vec_t<3, wp::int32>(var_88);
        // v = texture_sample_sdf_at_voxel(sdf, x_id + co.x, y_id + co.y, z_id + co.z)            <L 2958>
        var_90 = wp::extract(var_87, var_89);
        var_91 = wp::add(var_14, var_90);
        var_93 = wp::extract(var_87, var_92);
        var_94 = wp::add(var_18, var_93);
        var_96 = wp::extract(var_87, var_95);
        var_97 = wp::add(var_22, var_96);
        var_98 = texture_sample_sdf_at_voxel_0(var_6, var_91, var_94, var_97);
        // if wp.isnan(v):                                                                        <L 2959>
        var_99 = wp::isnan(var_98);
        if (var_99) {
            // return                                                                             <L 2960>
            continue;
        }
        // if v < isovalue:                                                                       <L 2961>
        var_100 = (var_98 < var_isovalue);
        if (var_100) {
            // cube_idx |= 1 << i                                                                 <L 2962>
            var_102 = wp::lshift(var_101, var_85);
            var_103 = wp::bit_or(var_84, var_102);
        }
        var_104 = wp::where(var_100, var_103, var_84);
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 2957>
        var_106 = wp::address(var_corner_offsets_table, var_105);
        var_108 = wp::load(var_106);
        var_107 = wp::vec_t<3, wp::int32>(var_108);
        // v = texture_sample_sdf_at_voxel(sdf, x_id + co.x, y_id + co.y, z_id + co.z)            <L 2958>
        var_110 = wp::extract(var_107, var_109);
        var_111 = wp::add(var_14, var_110);
        var_113 = wp::extract(var_107, var_112);
        var_114 = wp::add(var_18, var_113);
        var_116 = wp::extract(var_107, var_115);
        var_117 = wp::add(var_22, var_116);
        var_118 = texture_sample_sdf_at_voxel_0(var_6, var_111, var_114, var_117);
        // if wp.isnan(v):                                                                        <L 2959>
        var_119 = wp::isnan(var_118);
        if (var_119) {
            // return                                                                             <L 2960>
            continue;
        }
        // if v < isovalue:                                                                       <L 2961>
        var_120 = (var_118 < var_isovalue);
        if (var_120) {
            // cube_idx |= 1 << i                                                                 <L 2962>
            var_122 = wp::lshift(var_121, var_105);
            var_123 = wp::bit_or(var_104, var_122);
        }
        var_124 = wp::where(var_120, var_123, var_104);
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 2957>
        var_126 = wp::address(var_corner_offsets_table, var_125);
        var_128 = wp::load(var_126);
        var_127 = wp::vec_t<3, wp::int32>(var_128);
        // v = texture_sample_sdf_at_voxel(sdf, x_id + co.x, y_id + co.y, z_id + co.z)            <L 2958>
        var_130 = wp::extract(var_127, var_129);
        var_131 = wp::add(var_14, var_130);
        var_133 = wp::extract(var_127, var_132);
        var_134 = wp::add(var_18, var_133);
        var_136 = wp::extract(var_127, var_135);
        var_137 = wp::add(var_22, var_136);
        var_138 = texture_sample_sdf_at_voxel_0(var_6, var_131, var_134, var_137);
        // if wp.isnan(v):                                                                        <L 2959>
        var_139 = wp::isnan(var_138);
        if (var_139) {
            // return                                                                             <L 2960>
            continue;
        }
        // if v < isovalue:                                                                       <L 2961>
        var_140 = (var_138 < var_isovalue);
        if (var_140) {
            // cube_idx |= 1 << i                                                                 <L 2962>
            var_142 = wp::lshift(var_141, var_125);
            var_143 = wp::bit_or(var_124, var_142);
        }
        var_144 = wp::where(var_140, var_143, var_124);
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 2957>
        var_146 = wp::address(var_corner_offsets_table, var_145);
        var_148 = wp::load(var_146);
        var_147 = wp::vec_t<3, wp::int32>(var_148);
        // v = texture_sample_sdf_at_voxel(sdf, x_id + co.x, y_id + co.y, z_id + co.z)            <L 2958>
        var_150 = wp::extract(var_147, var_149);
        var_151 = wp::add(var_14, var_150);
        var_153 = wp::extract(var_147, var_152);
        var_154 = wp::add(var_18, var_153);
        var_156 = wp::extract(var_147, var_155);
        var_157 = wp::add(var_22, var_156);
        var_158 = texture_sample_sdf_at_voxel_0(var_6, var_151, var_154, var_157);
        // if wp.isnan(v):                                                                        <L 2959>
        var_159 = wp::isnan(var_158);
        if (var_159) {
            // return                                                                             <L 2960>
            continue;
        }
        // if v < isovalue:                                                                       <L 2961>
        var_160 = (var_158 < var_isovalue);
        if (var_160) {
            // cube_idx |= 1 << i                                                                 <L 2962>
            var_162 = wp::lshift(var_161, var_145);
            var_163 = wp::bit_or(var_144, var_162);
        }
        var_164 = wp::where(var_160, var_163, var_144);
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 2957>
        var_166 = wp::address(var_corner_offsets_table, var_165);
        var_168 = wp::load(var_166);
        var_167 = wp::vec_t<3, wp::int32>(var_168);
        // v = texture_sample_sdf_at_voxel(sdf, x_id + co.x, y_id + co.y, z_id + co.z)            <L 2958>
        var_170 = wp::extract(var_167, var_169);
        var_171 = wp::add(var_14, var_170);
        var_173 = wp::extract(var_167, var_172);
        var_174 = wp::add(var_18, var_173);
        var_176 = wp::extract(var_167, var_175);
        var_177 = wp::add(var_22, var_176);
        var_178 = texture_sample_sdf_at_voxel_0(var_6, var_171, var_174, var_177);
        // if wp.isnan(v):                                                                        <L 2959>
        var_179 = wp::isnan(var_178);
        if (var_179) {
            // return                                                                             <L 2960>
            continue;
        }
        // if v < isovalue:                                                                       <L 2961>
        var_180 = (var_178 < var_isovalue);
        if (var_180) {
            // cube_idx |= 1 << i                                                                 <L 2962>
            var_182 = wp::lshift(var_181, var_165);
            var_183 = wp::bit_or(var_164, var_182);
        }
        var_184 = wp::where(var_180, var_183, var_164);
        // tri_start = tri_range_table[cube_idx]                                                  <L 2964>
        var_185 = wp::address(var_tri_range_table, var_184);
        var_187 = wp::load(var_185);
        var_186 = wp::copy(var_187);
        // tri_end = tri_range_table[cube_idx + 1]                                                <L 2965>
        var_189 = wp::add(var_184, var_188);
        var_190 = wp::address(var_tri_range_table, var_189);
        var_192 = wp::load(var_190);
        var_191 = wp::copy(var_192);
        // num_faces = (tri_end - tri_start) // 3                                                 <L 2966>
        var_193 = wp::sub(var_191, var_186);
        var_195 = wp::floordiv(var_193, var_194);
        // if num_faces > 0:                                                                      <L 2967>
        var_197 = (var_195 > var_196);
        if (var_197) {
            // wp.atomic_add(face_count, 0, num_faces)                                            <L 2968>
            var_199 = wp::atomic_add(var_face_count, var_198, var_195);
        }
    }
}



extern "C" __global__ void _apply_subgrid_linearity_kernel_2c0ca647_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::int32> var_subgrid_required,
    wp::array_t<wp::float32> var_linearity_errors,
    wp::array_t<wp::int32> var_subgrid_is_linear,
    wp::float32 var_error_threshold)
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
        wp::int32* var_1;
        const wp::int32 var_2 = 0;
        bool var_3;
        wp::int32 var_4;
        wp::float32* var_5;
        bool var_6;
        wp::float32 var_7;
        const wp::int32 var_8 = 1;
        const wp::int32 var_9 = 0;
        //---------
        // forward
        // def _apply_subgrid_linearity_kernel(                                                   <L 708>
        // tid = wp.tid()                                                                         <L 721>
        var_0 = builtin_tid1d();
        // if subgrid_required[tid] == 0:                                                         <L 722>
        var_1 = wp::address(var_subgrid_required, var_0);
        var_4 = wp::load(var_1);
        var_3 = (var_4 == var_2);
        if (var_3) {
            // return                                                                             <L 723>
            continue;
        }
        // if linearity_errors[tid] < error_threshold:                                            <L 724>
        var_5 = wp::address(var_linearity_errors, var_0);
        var_7 = wp::load(var_5);
        var_6 = (var_7 < var_error_threshold);
        if (var_6) {
            // subgrid_is_linear[tid] = 1                                                         <L 725>
            wp::array_store(var_subgrid_is_linear, var_0, var_8);
            // subgrid_required[tid] = 0                                                          <L 726>
            wp::array_store(var_subgrid_required, var_0, var_9);
        }
    }
}



extern "C" __global__ void _apply_subgrid_linearity_kernel_2c0ca647_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::int32> var_subgrid_required,
    wp::array_t<wp::float32> var_linearity_errors,
    wp::array_t<wp::int32> var_subgrid_is_linear,
    wp::float32 var_error_threshold,
    wp::array_t<wp::int32> adj_subgrid_required,
    wp::array_t<wp::float32> adj_linearity_errors,
    wp::array_t<wp::int32> adj_subgrid_is_linear,
    wp::float32 adj_error_threshold)
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
        wp::int32* var_1;
        const wp::int32 var_2 = 0;
        bool var_3;
        wp::int32 var_4;
        wp::float32* var_5;
        bool var_6;
        wp::float32 var_7;
        const wp::int32 var_8 = 1;
        const wp::int32 var_9 = 0;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::int32 adj_2 = {};
        bool adj_3 = {};
        wp::int32 adj_4 = {};
        wp::float32 adj_5 = {};
        bool adj_6 = {};
        wp::float32 adj_7 = {};
        wp::int32 adj_8 = {};
        wp::int32 adj_9 = {};
        //---------
        // forward
        // def _apply_subgrid_linearity_kernel(                                                   <L 708>
        // tid = wp.tid()                                                                         <L 721>
        var_0 = builtin_tid1d();
        // if subgrid_required[tid] == 0:                                                         <L 722>
        var_1 = wp::address(var_subgrid_required, var_0);
        var_4 = wp::load(var_1);
        var_3 = (var_4 == var_2);
        if (var_3) {
            // return                                                                             <L 723>
            goto label0;
        }
        // if linearity_errors[tid] < error_threshold:                                            <L 724>
        var_5 = wp::address(var_linearity_errors, var_0);
        var_7 = wp::load(var_5);
        var_6 = (var_7 < var_error_threshold);
        if (var_6) {
            // subgrid_is_linear[tid] = 1                                                         <L 725>
            // wp::array_store(var_subgrid_is_linear, var_0, var_8);
            // subgrid_required[tid] = 0                                                          <L 726>
            // wp::array_store(var_subgrid_required, var_0, var_9);
        }
        //---------
        // reverse
        if (var_6) {
            wp::adj_array_store(var_subgrid_required, var_0, var_9, adj_subgrid_required, adj_0, adj_9);
            // adj: subgrid_required[tid] = 0                                                     <L 726>
            wp::adj_array_store(var_subgrid_is_linear, var_0, var_8, adj_subgrid_is_linear, adj_0, adj_8);
            // adj: subgrid_is_linear[tid] = 1                                                    <L 725>
        }
        wp::adj_address(var_linearity_errors, var_0, adj_linearity_errors, adj_0, adj_5);
        // adj: if linearity_errors[tid] < error_threshold:                                       <L 724>
        if (var_3) {
            label0:;
            // adj: return                                                                        <L 723>
        }
        wp::adj_address(var_subgrid_required, var_0, adj_subgrid_required, adj_0, adj_1);
        // adj: if subgrid_required[tid] == 0:                                                    <L 722>
        // adj: tid = wp.tid()                                                                    <L 721>
        // adj: def _apply_subgrid_linearity_kernel(                                              <L 708>
        continue;
    }
}



extern "C" __global__ void _create_source_kernels__locals__check_subgrid_occupied_kernel_5eff9848_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::uint64 var_mesh,
    wp::int32 var_shape_type,
    wp::vec_t<3, wp::float32> var_shape_scale,
    wp::vec_t<2, wp::float32> var_threshold,
    wp::float32 var_winding_threshold,
    wp::array_t<wp::int32> var_subgrid_required,
    wp::int32 var_cells_per_subgrid,
    wp::int32 var_num_subgrids_x,
    wp::int32 var_num_subgrids_y,
    wp::vec_t<3, wp::float32> var_min_corner,
    wp::vec_t<3, wp::float32> var_cell_size)
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
        wp::vec_t<3, wp::int32> var_1;
        const wp::int32 var_2 = 0;
        wp::int32 var_3;
        wp::int32 var_4;
        wp::float32 var_5;
        wp::float32 var_6;
        const wp::float32 var_7 = 0.5;
        wp::float32 var_8;
        wp::float32 var_9;
        const wp::int32 var_10 = 0;
        wp::float32 var_11;
        wp::float32 var_12;
        const wp::int32 var_13 = 1;
        wp::int32 var_14;
        wp::int32 var_15;
        wp::float32 var_16;
        wp::float32 var_17;
        const wp::float32 var_18 = 0.5;
        wp::float32 var_19;
        wp::float32 var_20;
        const wp::int32 var_21 = 1;
        wp::float32 var_22;
        wp::float32 var_23;
        const wp::int32 var_24 = 2;
        wp::int32 var_25;
        wp::int32 var_26;
        wp::float32 var_27;
        wp::float32 var_28;
        const wp::float32 var_29 = 0.5;
        wp::float32 var_30;
        wp::float32 var_31;
        const wp::int32 var_32 = 2;
        wp::float32 var_33;
        wp::float32 var_34;
        wp::vec_t<3, wp::float32> var_35;
        wp::vec_t<3, wp::float32> var_36;
        const wp::float32 var_37 = 10000.0;
        wp::float32 var_38;
        bool var_39;
        const wp::int32 var_40 = 1;
        const wp::int32 var_41 = 0;
        //---------
        // forward
        // def check_subgrid_occupied_kernel(                                                     <L 344>
        // tid = wp.tid()                                                                         <L 358>
        var_0 = builtin_tid1d();
        // coords = _id_to_xyz(tid, num_subgrids_x, num_subgrids_y)                               <L 359>
        var_1 = _id_to_xyz_0(var_0, var_num_subgrids_x, var_num_subgrids_y);
        // sample_pos = min_corner + wp.vec3(                                                     <L 360>
        // (float(coords[0] * cells_per_subgrid) + float(cells_per_subgrid) * 0.5) * cell_size[0],       <L 361>
        var_3 = wp::extract(var_1, var_2);
        var_4 = wp::mul(var_3, var_cells_per_subgrid);
        var_5 = wp::float(var_4);
        var_6 = wp::float(var_cells_per_subgrid);
        var_8 = wp::mul(var_6, var_7);
        var_9 = wp::add(var_5, var_8);
        var_11 = wp::extract(var_cell_size, var_10);
        var_12 = wp::mul(var_9, var_11);
        // (float(coords[1] * cells_per_subgrid) + float(cells_per_subgrid) * 0.5) * cell_size[1],       <L 362>
        var_14 = wp::extract(var_1, var_13);
        var_15 = wp::mul(var_14, var_cells_per_subgrid);
        var_16 = wp::float(var_15);
        var_17 = wp::float(var_cells_per_subgrid);
        var_19 = wp::mul(var_17, var_18);
        var_20 = wp::add(var_16, var_19);
        var_22 = wp::extract(var_cell_size, var_21);
        var_23 = wp::mul(var_20, var_22);
        // (float(coords[2] * cells_per_subgrid) + float(cells_per_subgrid) * 0.5) * cell_size[2],       <L 363>
        var_25 = wp::extract(var_1, var_24);
        var_26 = wp::mul(var_25, var_cells_per_subgrid);
        var_27 = wp::float(var_26);
        var_28 = wp::float(var_cells_per_subgrid);
        var_30 = wp::mul(var_28, var_29);
        var_31 = wp::add(var_27, var_30);
        var_33 = wp::extract(var_cell_size, var_32);
        var_34 = wp::mul(var_31, var_33);
        var_35 = wp::vec_t<3, wp::float32>(var_12, var_23, var_34);
        var_36 = wp::add(var_min_corner, var_35);
        // signed_distance = query_sdf(mesh, shape_type, shape_scale, sample_pos, 10000.0, winding_threshold)       <L 366>
        var_38 = _create_source_kernels__locals__query_sdf_0(var_mesh, var_shape_type, var_shape_scale, var_36, var_37, var_winding_threshold);
        // if _is_in_narrow_band(signed_distance, threshold):                                     <L 367>
        var_39 = _is_in_narrow_band_0(var_38, var_threshold);
        if (var_39) {
            // subgrid_required[tid] = 1                                                          <L 368>
            wp::array_store(var_subgrid_required, var_0, var_40);
        }
        if (!var_39) {
            // subgrid_required[tid] = 0                                                          <L 370>
            wp::array_store(var_subgrid_required, var_0, var_41);
        }
    }
}



extern "C" __global__ void _create_source_kernels__locals__check_subgrid_occupied_kernel_5eff9848_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::uint64 var_mesh,
    wp::int32 var_shape_type,
    wp::vec_t<3, wp::float32> var_shape_scale,
    wp::vec_t<2, wp::float32> var_threshold,
    wp::float32 var_winding_threshold,
    wp::array_t<wp::int32> var_subgrid_required,
    wp::int32 var_cells_per_subgrid,
    wp::int32 var_num_subgrids_x,
    wp::int32 var_num_subgrids_y,
    wp::vec_t<3, wp::float32> var_min_corner,
    wp::vec_t<3, wp::float32> var_cell_size,
    wp::uint64 adj_mesh,
    wp::int32 adj_shape_type,
    wp::vec_t<3, wp::float32> adj_shape_scale,
    wp::vec_t<2, wp::float32> adj_threshold,
    wp::float32 adj_winding_threshold,
    wp::array_t<wp::int32> adj_subgrid_required,
    wp::int32 adj_cells_per_subgrid,
    wp::int32 adj_num_subgrids_x,
    wp::int32 adj_num_subgrids_y,
    wp::vec_t<3, wp::float32> adj_min_corner,
    wp::vec_t<3, wp::float32> adj_cell_size)
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
        wp::vec_t<3, wp::int32> var_1;
        const wp::int32 var_2 = 0;
        wp::int32 var_3;
        wp::int32 var_4;
        wp::float32 var_5;
        wp::float32 var_6;
        const wp::float32 var_7 = 0.5;
        wp::float32 var_8;
        wp::float32 var_9;
        const wp::int32 var_10 = 0;
        wp::float32 var_11;
        wp::float32 var_12;
        const wp::int32 var_13 = 1;
        wp::int32 var_14;
        wp::int32 var_15;
        wp::float32 var_16;
        wp::float32 var_17;
        const wp::float32 var_18 = 0.5;
        wp::float32 var_19;
        wp::float32 var_20;
        const wp::int32 var_21 = 1;
        wp::float32 var_22;
        wp::float32 var_23;
        const wp::int32 var_24 = 2;
        wp::int32 var_25;
        wp::int32 var_26;
        wp::float32 var_27;
        wp::float32 var_28;
        const wp::float32 var_29 = 0.5;
        wp::float32 var_30;
        wp::float32 var_31;
        const wp::int32 var_32 = 2;
        wp::float32 var_33;
        wp::float32 var_34;
        wp::vec_t<3, wp::float32> var_35;
        wp::vec_t<3, wp::float32> var_36;
        const wp::float32 var_37 = 10000.0;
        wp::float32 var_38;
        bool var_39;
        const wp::int32 var_40 = 1;
        const wp::int32 var_41 = 0;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::vec_t<3, wp::int32> adj_1 = {};
        wp::int32 adj_2 = {};
        wp::int32 adj_3 = {};
        wp::int32 adj_4 = {};
        wp::float32 adj_5 = {};
        wp::float32 adj_6 = {};
        wp::float32 adj_7 = {};
        wp::float32 adj_8 = {};
        wp::float32 adj_9 = {};
        wp::int32 adj_10 = {};
        wp::float32 adj_11 = {};
        wp::float32 adj_12 = {};
        wp::int32 adj_13 = {};
        wp::int32 adj_14 = {};
        wp::int32 adj_15 = {};
        wp::float32 adj_16 = {};
        wp::float32 adj_17 = {};
        wp::float32 adj_18 = {};
        wp::float32 adj_19 = {};
        wp::float32 adj_20 = {};
        wp::int32 adj_21 = {};
        wp::float32 adj_22 = {};
        wp::float32 adj_23 = {};
        wp::int32 adj_24 = {};
        wp::int32 adj_25 = {};
        wp::int32 adj_26 = {};
        wp::float32 adj_27 = {};
        wp::float32 adj_28 = {};
        wp::float32 adj_29 = {};
        wp::float32 adj_30 = {};
        wp::float32 adj_31 = {};
        wp::int32 adj_32 = {};
        wp::float32 adj_33 = {};
        wp::float32 adj_34 = {};
        wp::vec_t<3, wp::float32> adj_35 = {};
        wp::vec_t<3, wp::float32> adj_36 = {};
        wp::float32 adj_37 = {};
        wp::float32 adj_38 = {};
        bool adj_39 = {};
        wp::int32 adj_40 = {};
        wp::int32 adj_41 = {};
        //---------
        // forward
        // def check_subgrid_occupied_kernel(                                                     <L 344>
        // tid = wp.tid()                                                                         <L 358>
        var_0 = builtin_tid1d();
        // coords = _id_to_xyz(tid, num_subgrids_x, num_subgrids_y)                               <L 359>
        var_1 = _id_to_xyz_0(var_0, var_num_subgrids_x, var_num_subgrids_y);
        // sample_pos = min_corner + wp.vec3(                                                     <L 360>
        // (float(coords[0] * cells_per_subgrid) + float(cells_per_subgrid) * 0.5) * cell_size[0],       <L 361>
        var_3 = wp::extract(var_1, var_2);
        var_4 = wp::mul(var_3, var_cells_per_subgrid);
        var_5 = wp::float(var_4);
        var_6 = wp::float(var_cells_per_subgrid);
        var_8 = wp::mul(var_6, var_7);
        var_9 = wp::add(var_5, var_8);
        var_11 = wp::extract(var_cell_size, var_10);
        var_12 = wp::mul(var_9, var_11);
        // (float(coords[1] * cells_per_subgrid) + float(cells_per_subgrid) * 0.5) * cell_size[1],       <L 362>
        var_14 = wp::extract(var_1, var_13);
        var_15 = wp::mul(var_14, var_cells_per_subgrid);
        var_16 = wp::float(var_15);
        var_17 = wp::float(var_cells_per_subgrid);
        var_19 = wp::mul(var_17, var_18);
        var_20 = wp::add(var_16, var_19);
        var_22 = wp::extract(var_cell_size, var_21);
        var_23 = wp::mul(var_20, var_22);
        // (float(coords[2] * cells_per_subgrid) + float(cells_per_subgrid) * 0.5) * cell_size[2],       <L 363>
        var_25 = wp::extract(var_1, var_24);
        var_26 = wp::mul(var_25, var_cells_per_subgrid);
        var_27 = wp::float(var_26);
        var_28 = wp::float(var_cells_per_subgrid);
        var_30 = wp::mul(var_28, var_29);
        var_31 = wp::add(var_27, var_30);
        var_33 = wp::extract(var_cell_size, var_32);
        var_34 = wp::mul(var_31, var_33);
        var_35 = wp::vec_t<3, wp::float32>(var_12, var_23, var_34);
        var_36 = wp::add(var_min_corner, var_35);
        // signed_distance = query_sdf(mesh, shape_type, shape_scale, sample_pos, 10000.0, winding_threshold)       <L 366>
        var_38 = _create_source_kernels__locals__query_sdf_0(var_mesh, var_shape_type, var_shape_scale, var_36, var_37, var_winding_threshold);
        // if _is_in_narrow_band(signed_distance, threshold):                                     <L 367>
        var_39 = _is_in_narrow_band_0(var_38, var_threshold);
        if (var_39) {
            // subgrid_required[tid] = 1                                                          <L 368>
            // wp::array_store(var_subgrid_required, var_0, var_40);
        }
        if (!var_39) {
            // subgrid_required[tid] = 0                                                          <L 370>
            // wp::array_store(var_subgrid_required, var_0, var_41);
        }
        //---------
        // reverse
        if (!var_39) {
            wp::adj_array_store(var_subgrid_required, var_0, var_41, adj_subgrid_required, adj_0, adj_41);
            // adj: subgrid_required[tid] = 0                                                     <L 370>
        }
        if (var_39) {
            wp::adj_array_store(var_subgrid_required, var_0, var_40, adj_subgrid_required, adj_0, adj_40);
            // adj: subgrid_required[tid] = 1                                                     <L 368>
        }
        adj__is_in_narrow_band_0(var_38, var_threshold, adj_38, adj_threshold, adj_39);
        // adj: if _is_in_narrow_band(signed_distance, threshold):                                <L 367>
        adj__create_source_kernels__locals__query_sdf_0(var_mesh, var_shape_type, var_shape_scale, var_36, var_37, var_winding_threshold, adj_mesh, adj_shape_type, adj_shape_scale, adj_36, adj_37, adj_winding_threshold, adj_38);
        // adj: signed_distance = query_sdf(mesh, shape_type, shape_scale, sample_pos, 10000.0, winding_threshold)  <L 366>
        wp::adj_add(var_min_corner, var_35, adj_min_corner, adj_35, adj_36);
        wp::adj_vec_t(var_12, var_23, var_34, adj_12, adj_23, adj_34, adj_35);
        wp::adj_mul(var_31, var_33, adj_31, adj_33, adj_34);
        wp::adj_extract(var_cell_size, var_32, adj_cell_size, adj_32, adj_33);
        wp::adj_add(var_27, var_30, adj_27, adj_30, adj_31);
        wp::adj_mul(var_28, var_29, adj_28, adj_29, adj_30);
        wp::adj_float(var_cells_per_subgrid, adj_cells_per_subgrid, adj_28);
        wp::adj_float(var_26, adj_26, adj_27);
        wp::adj_mul(var_25, var_cells_per_subgrid, adj_25, adj_cells_per_subgrid, adj_26);
        wp::adj_extract(var_1, var_24, adj_1, adj_24, adj_25);
        // adj: (float(coords[2] * cells_per_subgrid) + float(cells_per_subgrid) * 0.5) * cell_size[2],  <L 363>
        wp::adj_mul(var_20, var_22, adj_20, adj_22, adj_23);
        wp::adj_extract(var_cell_size, var_21, adj_cell_size, adj_21, adj_22);
        wp::adj_add(var_16, var_19, adj_16, adj_19, adj_20);
        wp::adj_mul(var_17, var_18, adj_17, adj_18, adj_19);
        wp::adj_float(var_cells_per_subgrid, adj_cells_per_subgrid, adj_17);
        wp::adj_float(var_15, adj_15, adj_16);
        wp::adj_mul(var_14, var_cells_per_subgrid, adj_14, adj_cells_per_subgrid, adj_15);
        wp::adj_extract(var_1, var_13, adj_1, adj_13, adj_14);
        // adj: (float(coords[1] * cells_per_subgrid) + float(cells_per_subgrid) * 0.5) * cell_size[1],  <L 362>
        wp::adj_mul(var_9, var_11, adj_9, adj_11, adj_12);
        wp::adj_extract(var_cell_size, var_10, adj_cell_size, adj_10, adj_11);
        wp::adj_add(var_5, var_8, adj_5, adj_8, adj_9);
        wp::adj_mul(var_6, var_7, adj_6, adj_7, adj_8);
        wp::adj_float(var_cells_per_subgrid, adj_cells_per_subgrid, adj_6);
        wp::adj_float(var_4, adj_4, adj_5);
        wp::adj_mul(var_3, var_cells_per_subgrid, adj_3, adj_cells_per_subgrid, adj_4);
        wp::adj_extract(var_1, var_2, adj_1, adj_2, adj_3);
        // adj: (float(coords[0] * cells_per_subgrid) + float(cells_per_subgrid) * 0.5) * cell_size[0],  <L 361>
        // adj: sample_pos = min_corner + wp.vec3(                                                <L 360>
        adj__id_to_xyz_0(var_0, var_num_subgrids_x, var_num_subgrids_y, adj_0, adj_num_subgrids_x, adj_num_subgrids_y, adj_1);
        // adj: coords = _id_to_xyz(tid, num_subgrids_x, num_subgrids_y)                          <L 359>
        // adj: tid = wp.tid()                                                                    <L 358>
        // adj: def check_subgrid_occupied_kernel(                                                <L 344>
        continue;
    }
}



extern "C" __global__ void _create_source_kernels__locals__populate_subgrid_texture_float32_kernel_a522598f_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::uint64 var_mesh,
    wp::int32 var_shape_type,
    wp::vec_t<3, wp::float32> var_shape_scale,
    wp::array_t<wp::int32> var_subgrid_required,
    wp::array_t<wp::int32> var_subgrid_addresses,
    wp::array_t<wp::uint32> var_subgrid_start_slots,
    wp::array_t<wp::float32> var_subgrid_texture,
    wp::int32 var_cells_per_subgrid,
    wp::vec_t<3, wp::float32> var_min_corner,
    wp::vec_t<3, wp::float32> var_cell_size,
    wp::float32 var_winding_threshold,
    wp::int32 var_num_subgrids_x,
    wp::int32 var_num_subgrids_y,
    wp::int32 var_num_subgrids_z,
    wp::int32 var_tex_blocks_per_dim,
    wp::int32 var_tex_size)
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
        wp::int32 var_2;
        const wp::int32 var_3 = 1;
        wp::int32 var_4;
        wp::int32 var_5;
        wp::int32 var_6;
        wp::int32 var_7;
        wp::int32 var_8;
        wp::int32 var_9;
        bool var_10;
        wp::int32* var_11;
        const wp::int32 var_12 = 0;
        bool var_13;
        wp::int32 var_14;
        wp::vec_t<3, wp::int32> var_15;
        const wp::int32 var_16 = 0;
        wp::int32 var_17;
        const wp::int32 var_18 = 1;
        wp::int32 var_19;
        const wp::int32 var_20 = 2;
        wp::int32 var_21;
        wp::vec_t<3, wp::int32> var_22;
        const wp::int32 var_23 = 0;
        wp::int32 var_24;
        const wp::int32 var_25 = 1;
        wp::int32 var_26;
        const wp::int32 var_27 = 2;
        wp::int32 var_28;
        wp::int32 var_29;
        wp::int32 var_30;
        wp::int32 var_31;
        wp::int32 var_32;
        wp::int32 var_33;
        wp::int32 var_34;
        wp::float32 var_35;
        const wp::int32 var_36 = 0;
        wp::float32 var_37;
        wp::float32 var_38;
        wp::float32 var_39;
        const wp::int32 var_40 = 1;
        wp::float32 var_41;
        wp::float32 var_42;
        wp::float32 var_43;
        const wp::int32 var_44 = 2;
        wp::float32 var_45;
        wp::float32 var_46;
        wp::vec_t<3, wp::float32> var_47;
        wp::vec_t<3, wp::float32> var_48;
        const wp::float32 var_49 = 10000.0;
        wp::float32 var_50;
        wp::int32* var_51;
        wp::int32 var_52;
        wp::int32 var_53;
        const wp::int32 var_54 = 0;
        bool var_55;
        wp::vec_t<3, wp::int32> var_56;
        const wp::int32 var_57 = 0;
        wp::int32 var_58;
        wp::int32 var_59;
        wp::int32 var_60;
        const wp::int32 var_61 = 1;
        wp::int32 var_62;
        wp::int32 var_63;
        wp::int32 var_64;
        const wp::int32 var_65 = 2;
        wp::int32 var_66;
        wp::int32 var_67;
        wp::int32 var_68;
        wp::int32 var_69;
        //---------
        // forward
        // def populate_subgrid_texture_float32_kernel(                                           <L 487>
        // tid = wp.tid()                                                                         <L 506>
        var_0 = builtin_tid1d();
        // total_subgrids = num_subgrids_x * num_subgrids_y * num_subgrids_z                      <L 508>
        var_1 = wp::mul(var_num_subgrids_x, var_num_subgrids_y);
        var_2 = wp::mul(var_1, var_num_subgrids_z);
        // samples_per_dim = cells_per_subgrid + 1                                                <L 509>
        var_4 = wp::add(var_cells_per_subgrid, var_3);
        // samples_per_subgrid = samples_per_dim * samples_per_dim * samples_per_dim              <L 510>
        var_5 = wp::mul(var_4, var_4);
        var_6 = wp::mul(var_5, var_4);
        // subgrid_idx = tid // samples_per_subgrid                                               <L 512>
        var_7 = wp::floordiv(var_0, var_6);
        // local_sample = tid - subgrid_idx * samples_per_subgrid                                 <L 513>
        var_8 = wp::mul(var_7, var_6);
        var_9 = wp::sub(var_0, var_8);
        // if subgrid_idx >= total_subgrids:                                                      <L 515>
        var_10 = (var_7 >= var_2);
        if (var_10) {
            // return                                                                             <L 516>
            continue;
        }
        // if subgrid_required[subgrid_idx] == 0:                                                 <L 517>
        var_11 = wp::address(var_subgrid_required, var_7);
        var_14 = wp::load(var_11);
        var_13 = (var_14 == var_12);
        if (var_13) {
            // return                                                                             <L 518>
            continue;
        }
        // subgrid_coords = _id_to_xyz(subgrid_idx, num_subgrids_x, num_subgrids_y)               <L 520>
        var_15 = _id_to_xyz_0(var_7, var_num_subgrids_x, var_num_subgrids_y);
        // block_x = subgrid_coords[0]                                                            <L 521>
        var_17 = wp::extract(var_15, var_16);
        // block_y = subgrid_coords[1]                                                            <L 522>
        var_19 = wp::extract(var_15, var_18);
        // block_z = subgrid_coords[2]                                                            <L 523>
        var_21 = wp::extract(var_15, var_20);
        // local_coords = _id_to_xyz(local_sample, samples_per_dim, samples_per_dim)              <L 525>
        var_22 = _id_to_xyz_0(var_9, var_4, var_4);
        // lx = local_coords[0]                                                                   <L 526>
        var_24 = wp::extract(var_22, var_23);
        // ly = local_coords[1]                                                                   <L 527>
        var_26 = wp::extract(var_22, var_25);
        // lz = local_coords[2]                                                                   <L 528>
        var_28 = wp::extract(var_22, var_27);
        // gx = block_x * cells_per_subgrid + lx                                                  <L 530>
        var_29 = wp::mul(var_17, var_cells_per_subgrid);
        var_30 = wp::add(var_29, var_24);
        // gy = block_y * cells_per_subgrid + ly                                                  <L 531>
        var_31 = wp::mul(var_19, var_cells_per_subgrid);
        var_32 = wp::add(var_31, var_26);
        // gz = block_z * cells_per_subgrid + lz                                                  <L 532>
        var_33 = wp::mul(var_21, var_cells_per_subgrid);
        var_34 = wp::add(var_33, var_28);
        // pos = min_corner + wp.vec3(                                                            <L 534>
        // float(gx) * cell_size[0],                                                              <L 535>
        var_35 = wp::float(var_30);
        var_37 = wp::extract(var_cell_size, var_36);
        var_38 = wp::mul(var_35, var_37);
        // float(gy) * cell_size[1],                                                              <L 536>
        var_39 = wp::float(var_32);
        var_41 = wp::extract(var_cell_size, var_40);
        var_42 = wp::mul(var_39, var_41);
        // float(gz) * cell_size[2],                                                              <L 537>
        var_43 = wp::float(var_34);
        var_45 = wp::extract(var_cell_size, var_44);
        var_46 = wp::mul(var_43, var_45);
        var_47 = wp::vec_t<3, wp::float32>(var_38, var_42, var_46);
        var_48 = wp::add(var_min_corner, var_47);
        // sdf_val = query_sdf(mesh, shape_type, shape_scale, pos, 10000.0, winding_threshold)       <L 539>
        var_50 = _create_source_kernels__locals__query_sdf_0(var_mesh, var_shape_type, var_shape_scale, var_48, var_49, var_winding_threshold);
        // address = subgrid_addresses[subgrid_idx]                                               <L 541>
        var_51 = wp::address(var_subgrid_addresses, var_7);
        var_53 = wp::load(var_51);
        var_52 = wp::copy(var_53);
        // if address < 0:                                                                        <L 542>
        var_55 = (var_52 < var_54);
        if (var_55) {
            // return                                                                             <L 543>
            continue;
        }
        // ac = _write_subgrid_slot(                                                              <L 545>
        // subgrid_start_slots, address, tex_blocks_per_dim, block_x, block_y, block_z, local_sample       <L 546>
        var_56 = _write_subgrid_slot_0(var_subgrid_start_slots, var_52, var_tex_blocks_per_dim, var_17, var_19, var_21, var_9);
        // tex_idx = _idx3d(                                                                      <L 548>
        // ac[0] * samples_per_dim + lx, ac[1] * samples_per_dim + ly, ac[2] * samples_per_dim + lz, tex_size, tex_size       <L 549>
        var_58 = wp::extract(var_56, var_57);
        var_59 = wp::mul(var_58, var_4);
        var_60 = wp::add(var_59, var_24);
        var_62 = wp::extract(var_56, var_61);
        var_63 = wp::mul(var_62, var_4);
        var_64 = wp::add(var_63, var_26);
        var_66 = wp::extract(var_56, var_65);
        var_67 = wp::mul(var_66, var_4);
        var_68 = wp::add(var_67, var_28);
        var_69 = _idx3d_0(var_60, var_64, var_68, var_tex_size, var_tex_size);
        // subgrid_texture[tex_idx] = sdf_val                                                     <L 551>
        wp::array_store(var_subgrid_texture, var_69, var_50);
    }
}



extern "C" __global__ void _create_source_kernels__locals__populate_subgrid_texture_float32_kernel_a522598f_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::uint64 var_mesh,
    wp::int32 var_shape_type,
    wp::vec_t<3, wp::float32> var_shape_scale,
    wp::array_t<wp::int32> var_subgrid_required,
    wp::array_t<wp::int32> var_subgrid_addresses,
    wp::array_t<wp::uint32> var_subgrid_start_slots,
    wp::array_t<wp::float32> var_subgrid_texture,
    wp::int32 var_cells_per_subgrid,
    wp::vec_t<3, wp::float32> var_min_corner,
    wp::vec_t<3, wp::float32> var_cell_size,
    wp::float32 var_winding_threshold,
    wp::int32 var_num_subgrids_x,
    wp::int32 var_num_subgrids_y,
    wp::int32 var_num_subgrids_z,
    wp::int32 var_tex_blocks_per_dim,
    wp::int32 var_tex_size,
    wp::uint64 adj_mesh,
    wp::int32 adj_shape_type,
    wp::vec_t<3, wp::float32> adj_shape_scale,
    wp::array_t<wp::int32> adj_subgrid_required,
    wp::array_t<wp::int32> adj_subgrid_addresses,
    wp::array_t<wp::uint32> adj_subgrid_start_slots,
    wp::array_t<wp::float32> adj_subgrid_texture,
    wp::int32 adj_cells_per_subgrid,
    wp::vec_t<3, wp::float32> adj_min_corner,
    wp::vec_t<3, wp::float32> adj_cell_size,
    wp::float32 adj_winding_threshold,
    wp::int32 adj_num_subgrids_x,
    wp::int32 adj_num_subgrids_y,
    wp::int32 adj_num_subgrids_z,
    wp::int32 adj_tex_blocks_per_dim,
    wp::int32 adj_tex_size)
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
        wp::int32 var_2;
        const wp::int32 var_3 = 1;
        wp::int32 var_4;
        wp::int32 var_5;
        wp::int32 var_6;
        wp::int32 var_7;
        wp::int32 var_8;
        wp::int32 var_9;
        bool var_10;
        wp::int32* var_11;
        const wp::int32 var_12 = 0;
        bool var_13;
        wp::int32 var_14;
        wp::vec_t<3, wp::int32> var_15;
        const wp::int32 var_16 = 0;
        wp::int32 var_17;
        const wp::int32 var_18 = 1;
        wp::int32 var_19;
        const wp::int32 var_20 = 2;
        wp::int32 var_21;
        wp::vec_t<3, wp::int32> var_22;
        const wp::int32 var_23 = 0;
        wp::int32 var_24;
        const wp::int32 var_25 = 1;
        wp::int32 var_26;
        const wp::int32 var_27 = 2;
        wp::int32 var_28;
        wp::int32 var_29;
        wp::int32 var_30;
        wp::int32 var_31;
        wp::int32 var_32;
        wp::int32 var_33;
        wp::int32 var_34;
        wp::float32 var_35;
        const wp::int32 var_36 = 0;
        wp::float32 var_37;
        wp::float32 var_38;
        wp::float32 var_39;
        const wp::int32 var_40 = 1;
        wp::float32 var_41;
        wp::float32 var_42;
        wp::float32 var_43;
        const wp::int32 var_44 = 2;
        wp::float32 var_45;
        wp::float32 var_46;
        wp::vec_t<3, wp::float32> var_47;
        wp::vec_t<3, wp::float32> var_48;
        const wp::float32 var_49 = 10000.0;
        wp::float32 var_50;
        wp::int32* var_51;
        wp::int32 var_52;
        wp::int32 var_53;
        const wp::int32 var_54 = 0;
        bool var_55;
        wp::vec_t<3, wp::int32> var_56;
        const wp::int32 var_57 = 0;
        wp::int32 var_58;
        wp::int32 var_59;
        wp::int32 var_60;
        const wp::int32 var_61 = 1;
        wp::int32 var_62;
        wp::int32 var_63;
        wp::int32 var_64;
        const wp::int32 var_65 = 2;
        wp::int32 var_66;
        wp::int32 var_67;
        wp::int32 var_68;
        wp::int32 var_69;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::int32 adj_2 = {};
        wp::int32 adj_3 = {};
        wp::int32 adj_4 = {};
        wp::int32 adj_5 = {};
        wp::int32 adj_6 = {};
        wp::int32 adj_7 = {};
        wp::int32 adj_8 = {};
        wp::int32 adj_9 = {};
        bool adj_10 = {};
        wp::int32 adj_11 = {};
        wp::int32 adj_12 = {};
        bool adj_13 = {};
        wp::int32 adj_14 = {};
        wp::vec_t<3, wp::int32> adj_15 = {};
        wp::int32 adj_16 = {};
        wp::int32 adj_17 = {};
        wp::int32 adj_18 = {};
        wp::int32 adj_19 = {};
        wp::int32 adj_20 = {};
        wp::int32 adj_21 = {};
        wp::vec_t<3, wp::int32> adj_22 = {};
        wp::int32 adj_23 = {};
        wp::int32 adj_24 = {};
        wp::int32 adj_25 = {};
        wp::int32 adj_26 = {};
        wp::int32 adj_27 = {};
        wp::int32 adj_28 = {};
        wp::int32 adj_29 = {};
        wp::int32 adj_30 = {};
        wp::int32 adj_31 = {};
        wp::int32 adj_32 = {};
        wp::int32 adj_33 = {};
        wp::int32 adj_34 = {};
        wp::float32 adj_35 = {};
        wp::int32 adj_36 = {};
        wp::float32 adj_37 = {};
        wp::float32 adj_38 = {};
        wp::float32 adj_39 = {};
        wp::int32 adj_40 = {};
        wp::float32 adj_41 = {};
        wp::float32 adj_42 = {};
        wp::float32 adj_43 = {};
        wp::int32 adj_44 = {};
        wp::float32 adj_45 = {};
        wp::float32 adj_46 = {};
        wp::vec_t<3, wp::float32> adj_47 = {};
        wp::vec_t<3, wp::float32> adj_48 = {};
        wp::float32 adj_49 = {};
        wp::float32 adj_50 = {};
        wp::int32 adj_51 = {};
        wp::int32 adj_52 = {};
        wp::int32 adj_53 = {};
        wp::int32 adj_54 = {};
        bool adj_55 = {};
        wp::vec_t<3, wp::int32> adj_56 = {};
        wp::int32 adj_57 = {};
        wp::int32 adj_58 = {};
        wp::int32 adj_59 = {};
        wp::int32 adj_60 = {};
        wp::int32 adj_61 = {};
        wp::int32 adj_62 = {};
        wp::int32 adj_63 = {};
        wp::int32 adj_64 = {};
        wp::int32 adj_65 = {};
        wp::int32 adj_66 = {};
        wp::int32 adj_67 = {};
        wp::int32 adj_68 = {};
        wp::int32 adj_69 = {};
        //---------
        // forward
        // def populate_subgrid_texture_float32_kernel(                                           <L 487>
        // tid = wp.tid()                                                                         <L 506>
        var_0 = builtin_tid1d();
        // total_subgrids = num_subgrids_x * num_subgrids_y * num_subgrids_z                      <L 508>
        var_1 = wp::mul(var_num_subgrids_x, var_num_subgrids_y);
        var_2 = wp::mul(var_1, var_num_subgrids_z);
        // samples_per_dim = cells_per_subgrid + 1                                                <L 509>
        var_4 = wp::add(var_cells_per_subgrid, var_3);
        // samples_per_subgrid = samples_per_dim * samples_per_dim * samples_per_dim              <L 510>
        var_5 = wp::mul(var_4, var_4);
        var_6 = wp::mul(var_5, var_4);
        // subgrid_idx = tid // samples_per_subgrid                                               <L 512>
        var_7 = wp::floordiv(var_0, var_6);
        // local_sample = tid - subgrid_idx * samples_per_subgrid                                 <L 513>
        var_8 = wp::mul(var_7, var_6);
        var_9 = wp::sub(var_0, var_8);
        // if subgrid_idx >= total_subgrids:                                                      <L 515>
        var_10 = (var_7 >= var_2);
        if (var_10) {
            // return                                                                             <L 516>
            goto label0;
        }
        // if subgrid_required[subgrid_idx] == 0:                                                 <L 517>
        var_11 = wp::address(var_subgrid_required, var_7);
        var_14 = wp::load(var_11);
        var_13 = (var_14 == var_12);
        if (var_13) {
            // return                                                                             <L 518>
            goto label1;
        }
        // subgrid_coords = _id_to_xyz(subgrid_idx, num_subgrids_x, num_subgrids_y)               <L 520>
        var_15 = _id_to_xyz_0(var_7, var_num_subgrids_x, var_num_subgrids_y);
        // block_x = subgrid_coords[0]                                                            <L 521>
        var_17 = wp::extract(var_15, var_16);
        // block_y = subgrid_coords[1]                                                            <L 522>
        var_19 = wp::extract(var_15, var_18);
        // block_z = subgrid_coords[2]                                                            <L 523>
        var_21 = wp::extract(var_15, var_20);
        // local_coords = _id_to_xyz(local_sample, samples_per_dim, samples_per_dim)              <L 525>
        var_22 = _id_to_xyz_0(var_9, var_4, var_4);
        // lx = local_coords[0]                                                                   <L 526>
        var_24 = wp::extract(var_22, var_23);
        // ly = local_coords[1]                                                                   <L 527>
        var_26 = wp::extract(var_22, var_25);
        // lz = local_coords[2]                                                                   <L 528>
        var_28 = wp::extract(var_22, var_27);
        // gx = block_x * cells_per_subgrid + lx                                                  <L 530>
        var_29 = wp::mul(var_17, var_cells_per_subgrid);
        var_30 = wp::add(var_29, var_24);
        // gy = block_y * cells_per_subgrid + ly                                                  <L 531>
        var_31 = wp::mul(var_19, var_cells_per_subgrid);
        var_32 = wp::add(var_31, var_26);
        // gz = block_z * cells_per_subgrid + lz                                                  <L 532>
        var_33 = wp::mul(var_21, var_cells_per_subgrid);
        var_34 = wp::add(var_33, var_28);
        // pos = min_corner + wp.vec3(                                                            <L 534>
        // float(gx) * cell_size[0],                                                              <L 535>
        var_35 = wp::float(var_30);
        var_37 = wp::extract(var_cell_size, var_36);
        var_38 = wp::mul(var_35, var_37);
        // float(gy) * cell_size[1],                                                              <L 536>
        var_39 = wp::float(var_32);
        var_41 = wp::extract(var_cell_size, var_40);
        var_42 = wp::mul(var_39, var_41);
        // float(gz) * cell_size[2],                                                              <L 537>
        var_43 = wp::float(var_34);
        var_45 = wp::extract(var_cell_size, var_44);
        var_46 = wp::mul(var_43, var_45);
        var_47 = wp::vec_t<3, wp::float32>(var_38, var_42, var_46);
        var_48 = wp::add(var_min_corner, var_47);
        // sdf_val = query_sdf(mesh, shape_type, shape_scale, pos, 10000.0, winding_threshold)       <L 539>
        var_50 = _create_source_kernels__locals__query_sdf_0(var_mesh, var_shape_type, var_shape_scale, var_48, var_49, var_winding_threshold);
        // address = subgrid_addresses[subgrid_idx]                                               <L 541>
        var_51 = wp::address(var_subgrid_addresses, var_7);
        var_53 = wp::load(var_51);
        var_52 = wp::copy(var_53);
        // if address < 0:                                                                        <L 542>
        var_55 = (var_52 < var_54);
        if (var_55) {
            // return                                                                             <L 543>
            goto label2;
        }
        // ac = _write_subgrid_slot(                                                              <L 545>
        // subgrid_start_slots, address, tex_blocks_per_dim, block_x, block_y, block_z, local_sample       <L 546>
        var_56 = _write_subgrid_slot_0(var_subgrid_start_slots, var_52, var_tex_blocks_per_dim, var_17, var_19, var_21, var_9);
        // tex_idx = _idx3d(                                                                      <L 548>
        // ac[0] * samples_per_dim + lx, ac[1] * samples_per_dim + ly, ac[2] * samples_per_dim + lz, tex_size, tex_size       <L 549>
        var_58 = wp::extract(var_56, var_57);
        var_59 = wp::mul(var_58, var_4);
        var_60 = wp::add(var_59, var_24);
        var_62 = wp::extract(var_56, var_61);
        var_63 = wp::mul(var_62, var_4);
        var_64 = wp::add(var_63, var_26);
        var_66 = wp::extract(var_56, var_65);
        var_67 = wp::mul(var_66, var_4);
        var_68 = wp::add(var_67, var_28);
        var_69 = _idx3d_0(var_60, var_64, var_68, var_tex_size, var_tex_size);
        // subgrid_texture[tex_idx] = sdf_val                                                     <L 551>
        // wp::array_store(var_subgrid_texture, var_69, var_50);
        //---------
        // reverse
        wp::adj_array_store(var_subgrid_texture, var_69, var_50, adj_subgrid_texture, adj_69, adj_50);
        // adj: subgrid_texture[tex_idx] = sdf_val                                                <L 551>
        adj__idx3d_0(var_60, var_64, var_68, var_tex_size, var_tex_size, adj_60, adj_64, adj_68, adj_tex_size, adj_tex_size, adj_69);
        wp::adj_add(var_67, var_28, adj_67, adj_28, adj_68);
        wp::adj_mul(var_66, var_4, adj_66, adj_4, adj_67);
        wp::adj_extract(var_56, var_65, adj_56, adj_65, adj_66);
        wp::adj_add(var_63, var_26, adj_63, adj_26, adj_64);
        wp::adj_mul(var_62, var_4, adj_62, adj_4, adj_63);
        wp::adj_extract(var_56, var_61, adj_56, adj_61, adj_62);
        wp::adj_add(var_59, var_24, adj_59, adj_24, adj_60);
        wp::adj_mul(var_58, var_4, adj_58, adj_4, adj_59);
        wp::adj_extract(var_56, var_57, adj_56, adj_57, adj_58);
        // adj: ac[0] * samples_per_dim + lx, ac[1] * samples_per_dim + ly, ac[2] * samples_per_dim + lz, tex_size, tex_size  <L 549>
        // adj: tex_idx = _idx3d(                                                                 <L 548>
        adj__write_subgrid_slot_0(var_subgrid_start_slots, var_52, var_tex_blocks_per_dim, var_17, var_19, var_21, var_9, adj_subgrid_start_slots, adj_52, adj_tex_blocks_per_dim, adj_17, adj_19, adj_21, adj_9, adj_56);
        // adj: subgrid_start_slots, address, tex_blocks_per_dim, block_x, block_y, block_z, local_sample  <L 546>
        // adj: ac = _write_subgrid_slot(                                                         <L 545>
        if (var_55) {
            label2:;
            // adj: return                                                                        <L 543>
        }
        // adj: if address < 0:                                                                   <L 542>
        wp::adj_copy(var_53, adj_51, adj_52);
        wp::adj_address(var_subgrid_addresses, var_7, adj_subgrid_addresses, adj_7, adj_51);
        // adj: address = subgrid_addresses[subgrid_idx]                                          <L 541>
        adj__create_source_kernels__locals__query_sdf_0(var_mesh, var_shape_type, var_shape_scale, var_48, var_49, var_winding_threshold, adj_mesh, adj_shape_type, adj_shape_scale, adj_48, adj_49, adj_winding_threshold, adj_50);
        // adj: sdf_val = query_sdf(mesh, shape_type, shape_scale, pos, 10000.0, winding_threshold)  <L 539>
        wp::adj_add(var_min_corner, var_47, adj_min_corner, adj_47, adj_48);
        wp::adj_vec_t(var_38, var_42, var_46, adj_38, adj_42, adj_46, adj_47);
        wp::adj_mul(var_43, var_45, adj_43, adj_45, adj_46);
        wp::adj_extract(var_cell_size, var_44, adj_cell_size, adj_44, adj_45);
        wp::adj_float(var_34, adj_34, adj_43);
        // adj: float(gz) * cell_size[2],                                                         <L 537>
        wp::adj_mul(var_39, var_41, adj_39, adj_41, adj_42);
        wp::adj_extract(var_cell_size, var_40, adj_cell_size, adj_40, adj_41);
        wp::adj_float(var_32, adj_32, adj_39);
        // adj: float(gy) * cell_size[1],                                                         <L 536>
        wp::adj_mul(var_35, var_37, adj_35, adj_37, adj_38);
        wp::adj_extract(var_cell_size, var_36, adj_cell_size, adj_36, adj_37);
        wp::adj_float(var_30, adj_30, adj_35);
        // adj: float(gx) * cell_size[0],                                                         <L 535>
        // adj: pos = min_corner + wp.vec3(                                                       <L 534>
        wp::adj_add(var_33, var_28, adj_33, adj_28, adj_34);
        wp::adj_mul(var_21, var_cells_per_subgrid, adj_21, adj_cells_per_subgrid, adj_33);
        // adj: gz = block_z * cells_per_subgrid + lz                                             <L 532>
        wp::adj_add(var_31, var_26, adj_31, adj_26, adj_32);
        wp::adj_mul(var_19, var_cells_per_subgrid, adj_19, adj_cells_per_subgrid, adj_31);
        // adj: gy = block_y * cells_per_subgrid + ly                                             <L 531>
        wp::adj_add(var_29, var_24, adj_29, adj_24, adj_30);
        wp::adj_mul(var_17, var_cells_per_subgrid, adj_17, adj_cells_per_subgrid, adj_29);
        // adj: gx = block_x * cells_per_subgrid + lx                                             <L 530>
        wp::adj_extract(var_22, var_27, adj_22, adj_27, adj_28);
        // adj: lz = local_coords[2]                                                              <L 528>
        wp::adj_extract(var_22, var_25, adj_22, adj_25, adj_26);
        // adj: ly = local_coords[1]                                                              <L 527>
        wp::adj_extract(var_22, var_23, adj_22, adj_23, adj_24);
        // adj: lx = local_coords[0]                                                              <L 526>
        adj__id_to_xyz_0(var_9, var_4, var_4, adj_9, adj_4, adj_4, adj_22);
        // adj: local_coords = _id_to_xyz(local_sample, samples_per_dim, samples_per_dim)         <L 525>
        wp::adj_extract(var_15, var_20, adj_15, adj_20, adj_21);
        // adj: block_z = subgrid_coords[2]                                                       <L 523>
        wp::adj_extract(var_15, var_18, adj_15, adj_18, adj_19);
        // adj: block_y = subgrid_coords[1]                                                       <L 522>
        wp::adj_extract(var_15, var_16, adj_15, adj_16, adj_17);
        // adj: block_x = subgrid_coords[0]                                                       <L 521>
        adj__id_to_xyz_0(var_7, var_num_subgrids_x, var_num_subgrids_y, adj_7, adj_num_subgrids_x, adj_num_subgrids_y, adj_15);
        // adj: subgrid_coords = _id_to_xyz(subgrid_idx, num_subgrids_x, num_subgrids_y)          <L 520>
        if (var_13) {
            label1:;
            // adj: return                                                                        <L 518>
        }
        wp::adj_address(var_subgrid_required, var_7, adj_subgrid_required, adj_7, adj_11);
        // adj: if subgrid_required[subgrid_idx] == 0:                                            <L 517>
        if (var_10) {
            label0:;
            // adj: return                                                                        <L 516>
        }
        // adj: if subgrid_idx >= total_subgrids:                                                 <L 515>
        wp::adj_sub(var_0, var_8, adj_0, adj_8, adj_9);
        wp::adj_mul(var_7, var_6, adj_7, adj_6, adj_8);
        // adj: local_sample = tid - subgrid_idx * samples_per_subgrid                            <L 513>
        // adj: subgrid_idx = tid // samples_per_subgrid                                          <L 512>
        wp::adj_mul(var_5, var_4, adj_5, adj_4, adj_6);
        wp::adj_mul(var_4, var_4, adj_4, adj_4, adj_5);
        // adj: samples_per_subgrid = samples_per_dim * samples_per_dim * samples_per_dim         <L 510>
        wp::adj_add(var_cells_per_subgrid, var_3, adj_cells_per_subgrid, adj_3, adj_4);
        // adj: samples_per_dim = cells_per_subgrid + 1                                           <L 509>
        wp::adj_mul(var_1, var_num_subgrids_z, adj_1, adj_num_subgrids_z, adj_2);
        wp::adj_mul(var_num_subgrids_x, var_num_subgrids_y, adj_num_subgrids_x, adj_num_subgrids_y, adj_1);
        // adj: total_subgrids = num_subgrids_x * num_subgrids_y * num_subgrids_z                 <L 508>
        // adj: tid = wp.tid()                                                                    <L 506>
        // adj: def populate_subgrid_texture_float32_kernel(                                      <L 487>
        continue;
    }
}



extern "C" __global__ void _sample_volume_at_positions_kernel_707a145a_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::uint64 var_volume,
    wp::array_t<wp::vec_t<3, wp::float32>> var_positions,
    wp::array_t<wp::float32> var_out_values)
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
        wp::vec_t<3, wp::float32>* var_1;
        wp::vec_t<3, wp::float32> var_2;
        wp::vec_t<3, wp::float32> var_3;
        wp::vec_t<3, wp::float32> var_4;
        const wp::int32 var_5 = 1;
        const wp::int32 var_6 = 1;
        wp::float32 var_7;
        //---------
        // forward
        // def _sample_volume_at_positions_kernel(                                                <L 730>
        // tid = wp.tid()                                                                         <L 736>
        var_0 = builtin_tid1d();
        // pos = positions[tid]                                                                   <L 737>
        var_1 = wp::address(var_positions, var_0);
        var_3 = wp::load(var_1);
        var_2 = wp::copy(var_3);
        // idx = wp.volume_world_to_index(volume, pos)                                            <L 738>
        var_4 = wp::volume_world_to_index(var_volume, var_2);
        // out_values[tid] = wp.volume_sample_f(volume, idx, wp.Volume.LINEAR)                    <L 739>
        var_7 = wp::volume_sample_f(var_volume, var_4, var_6);
        wp::array_store(var_out_values, var_0, var_7);
    }
}



extern "C" __global__ void _sample_volume_at_positions_kernel_707a145a_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::uint64 var_volume,
    wp::array_t<wp::vec_t<3, wp::float32>> var_positions,
    wp::array_t<wp::float32> var_out_values,
    wp::uint64 adj_volume,
    wp::array_t<wp::vec_t<3, wp::float32>> adj_positions,
    wp::array_t<wp::float32> adj_out_values)
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
        wp::vec_t<3, wp::float32>* var_1;
        wp::vec_t<3, wp::float32> var_2;
        wp::vec_t<3, wp::float32> var_3;
        wp::vec_t<3, wp::float32> var_4;
        const wp::int32 var_5 = 1;
        const wp::int32 var_6 = 1;
        wp::float32 var_7;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::vec_t<3, wp::float32> adj_1 = {};
        wp::vec_t<3, wp::float32> adj_2 = {};
        wp::vec_t<3, wp::float32> adj_3 = {};
        wp::vec_t<3, wp::float32> adj_4 = {};
        wp::int32 adj_5 = {};
        wp::int32 adj_6 = {};
        wp::float32 adj_7 = {};
        //---------
        // forward
        // def _sample_volume_at_positions_kernel(                                                <L 730>
        // tid = wp.tid()                                                                         <L 736>
        var_0 = builtin_tid1d();
        // pos = positions[tid]                                                                   <L 737>
        var_1 = wp::address(var_positions, var_0);
        var_3 = wp::load(var_1);
        var_2 = wp::copy(var_3);
        // idx = wp.volume_world_to_index(volume, pos)                                            <L 738>
        var_4 = wp::volume_world_to_index(var_volume, var_2);
        // out_values[tid] = wp.volume_sample_f(volume, idx, wp.Volume.LINEAR)                    <L 739>
        var_7 = wp::volume_sample_f(var_volume, var_4, var_6);
        // wp::array_store(var_out_values, var_0, var_7);
        //---------
        // reverse
        wp::adj_array_store(var_out_values, var_0, var_7, adj_out_values, adj_0, adj_7);
        wp::adj_volume_sample_f(var_volume, var_4, var_6, adj_volume, adj_4, adj_6, adj_7);
        // adj: out_values[tid] = wp.volume_sample_f(volume, idx, wp.Volume.LINEAR)               <L 739>
        wp::adj_volume_world_to_index(var_volume, var_2, adj_volume, adj_2, adj_4);
        // adj: idx = wp.volume_world_to_index(volume, pos)                                       <L 738>
        wp::adj_copy(var_3, adj_1, adj_2);
        wp::adj_address(var_positions, var_0, adj_positions, adj_0, adj_1);
        // adj: pos = positions[tid]                                                              <L 737>
        // adj: tid = wp.tid()                                                                    <L 736>
        // adj: def _sample_volume_at_positions_kernel(                                           <L 730>
        continue;
    }
}



extern "C" __global__ void _create_source_kernels__locals__populate_subgrid_texture_uint16_kernel_6d36a60d_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::uint64 var_mesh,
    wp::int32 var_shape_type,
    wp::vec_t<3, wp::float32> var_shape_scale,
    wp::array_t<wp::int32> var_subgrid_required,
    wp::array_t<wp::int32> var_subgrid_addresses,
    wp::array_t<wp::uint32> var_subgrid_start_slots,
    wp::array_t<wp::uint16> var_subgrid_texture,
    wp::int32 var_cells_per_subgrid,
    wp::vec_t<3, wp::float32> var_min_corner,
    wp::vec_t<3, wp::float32> var_cell_size,
    wp::float32 var_winding_threshold,
    wp::int32 var_num_subgrids_x,
    wp::int32 var_num_subgrids_y,
    wp::int32 var_num_subgrids_z,
    wp::int32 var_tex_blocks_per_dim,
    wp::int32 var_tex_size,
    wp::float32 var_sdf_min,
    wp::float32 var_sdf_range_inv)
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
        wp::int32 var_2;
        const wp::int32 var_3 = 1;
        wp::int32 var_4;
        wp::int32 var_5;
        wp::int32 var_6;
        wp::int32 var_7;
        wp::int32 var_8;
        wp::int32 var_9;
        bool var_10;
        wp::int32* var_11;
        const wp::int32 var_12 = 0;
        bool var_13;
        wp::int32 var_14;
        wp::vec_t<3, wp::int32> var_15;
        const wp::int32 var_16 = 0;
        wp::int32 var_17;
        const wp::int32 var_18 = 1;
        wp::int32 var_19;
        const wp::int32 var_20 = 2;
        wp::int32 var_21;
        wp::vec_t<3, wp::int32> var_22;
        const wp::int32 var_23 = 0;
        wp::int32 var_24;
        const wp::int32 var_25 = 1;
        wp::int32 var_26;
        const wp::int32 var_27 = 2;
        wp::int32 var_28;
        wp::int32 var_29;
        wp::int32 var_30;
        wp::int32 var_31;
        wp::int32 var_32;
        wp::int32 var_33;
        wp::int32 var_34;
        wp::float32 var_35;
        const wp::int32 var_36 = 0;
        wp::float32 var_37;
        wp::float32 var_38;
        wp::float32 var_39;
        const wp::int32 var_40 = 1;
        wp::float32 var_41;
        wp::float32 var_42;
        wp::float32 var_43;
        const wp::int32 var_44 = 2;
        wp::float32 var_45;
        wp::float32 var_46;
        wp::vec_t<3, wp::float32> var_47;
        wp::vec_t<3, wp::float32> var_48;
        const wp::float32 var_49 = 10000.0;
        wp::float32 var_50;
        wp::int32* var_51;
        wp::int32 var_52;
        wp::int32 var_53;
        const wp::int32 var_54 = 0;
        bool var_55;
        wp::vec_t<3, wp::int32> var_56;
        const wp::int32 var_57 = 0;
        wp::int32 var_58;
        wp::int32 var_59;
        wp::int32 var_60;
        const wp::int32 var_61 = 1;
        wp::int32 var_62;
        wp::int32 var_63;
        wp::int32 var_64;
        const wp::int32 var_65 = 2;
        wp::int32 var_66;
        wp::int32 var_67;
        wp::int32 var_68;
        wp::int32 var_69;
        wp::float32 var_70;
        wp::float32 var_71;
        const wp::float32 var_72 = 0.0;
        const wp::float32 var_73 = 1.0;
        wp::float32 var_74;
        const wp::float32 var_75 = 65535.0;
        wp::float32 var_76;
        wp::uint16 var_77;
        //---------
        // forward
        // def populate_subgrid_texture_uint16_kernel(                                            <L 554>
        // tid = wp.tid()                                                                         <L 575>
        var_0 = builtin_tid1d();
        // total_subgrids = num_subgrids_x * num_subgrids_y * num_subgrids_z                      <L 577>
        var_1 = wp::mul(var_num_subgrids_x, var_num_subgrids_y);
        var_2 = wp::mul(var_1, var_num_subgrids_z);
        // samples_per_dim = cells_per_subgrid + 1                                                <L 578>
        var_4 = wp::add(var_cells_per_subgrid, var_3);
        // samples_per_subgrid = samples_per_dim * samples_per_dim * samples_per_dim              <L 579>
        var_5 = wp::mul(var_4, var_4);
        var_6 = wp::mul(var_5, var_4);
        // subgrid_idx = tid // samples_per_subgrid                                               <L 581>
        var_7 = wp::floordiv(var_0, var_6);
        // local_sample = tid - subgrid_idx * samples_per_subgrid                                 <L 582>
        var_8 = wp::mul(var_7, var_6);
        var_9 = wp::sub(var_0, var_8);
        // if subgrid_idx >= total_subgrids:                                                      <L 584>
        var_10 = (var_7 >= var_2);
        if (var_10) {
            // return                                                                             <L 585>
            continue;
        }
        // if subgrid_required[subgrid_idx] == 0:                                                 <L 586>
        var_11 = wp::address(var_subgrid_required, var_7);
        var_14 = wp::load(var_11);
        var_13 = (var_14 == var_12);
        if (var_13) {
            // return                                                                             <L 587>
            continue;
        }
        // subgrid_coords = _id_to_xyz(subgrid_idx, num_subgrids_x, num_subgrids_y)               <L 589>
        var_15 = _id_to_xyz_0(var_7, var_num_subgrids_x, var_num_subgrids_y);
        // block_x = subgrid_coords[0]                                                            <L 590>
        var_17 = wp::extract(var_15, var_16);
        // block_y = subgrid_coords[1]                                                            <L 591>
        var_19 = wp::extract(var_15, var_18);
        // block_z = subgrid_coords[2]                                                            <L 592>
        var_21 = wp::extract(var_15, var_20);
        // local_coords = _id_to_xyz(local_sample, samples_per_dim, samples_per_dim)              <L 594>
        var_22 = _id_to_xyz_0(var_9, var_4, var_4);
        // lx = local_coords[0]                                                                   <L 595>
        var_24 = wp::extract(var_22, var_23);
        // ly = local_coords[1]                                                                   <L 596>
        var_26 = wp::extract(var_22, var_25);
        // lz = local_coords[2]                                                                   <L 597>
        var_28 = wp::extract(var_22, var_27);
        // gx = block_x * cells_per_subgrid + lx                                                  <L 599>
        var_29 = wp::mul(var_17, var_cells_per_subgrid);
        var_30 = wp::add(var_29, var_24);
        // gy = block_y * cells_per_subgrid + ly                                                  <L 600>
        var_31 = wp::mul(var_19, var_cells_per_subgrid);
        var_32 = wp::add(var_31, var_26);
        // gz = block_z * cells_per_subgrid + lz                                                  <L 601>
        var_33 = wp::mul(var_21, var_cells_per_subgrid);
        var_34 = wp::add(var_33, var_28);
        // pos = min_corner + wp.vec3(                                                            <L 603>
        // float(gx) * cell_size[0],                                                              <L 604>
        var_35 = wp::float(var_30);
        var_37 = wp::extract(var_cell_size, var_36);
        var_38 = wp::mul(var_35, var_37);
        // float(gy) * cell_size[1],                                                              <L 605>
        var_39 = wp::float(var_32);
        var_41 = wp::extract(var_cell_size, var_40);
        var_42 = wp::mul(var_39, var_41);
        // float(gz) * cell_size[2],                                                              <L 606>
        var_43 = wp::float(var_34);
        var_45 = wp::extract(var_cell_size, var_44);
        var_46 = wp::mul(var_43, var_45);
        var_47 = wp::vec_t<3, wp::float32>(var_38, var_42, var_46);
        var_48 = wp::add(var_min_corner, var_47);
        // sdf_val = query_sdf(mesh, shape_type, shape_scale, pos, 10000.0, winding_threshold)       <L 608>
        var_50 = _create_source_kernels__locals__query_sdf_0(var_mesh, var_shape_type, var_shape_scale, var_48, var_49, var_winding_threshold);
        // address = subgrid_addresses[subgrid_idx]                                               <L 610>
        var_51 = wp::address(var_subgrid_addresses, var_7);
        var_53 = wp::load(var_51);
        var_52 = wp::copy(var_53);
        // if address < 0:                                                                        <L 611>
        var_55 = (var_52 < var_54);
        if (var_55) {
            // return                                                                             <L 612>
            continue;
        }
        // ac = _write_subgrid_slot(                                                              <L 614>
        // subgrid_start_slots, address, tex_blocks_per_dim, block_x, block_y, block_z, local_sample       <L 615>
        var_56 = _write_subgrid_slot_0(var_subgrid_start_slots, var_52, var_tex_blocks_per_dim, var_17, var_19, var_21, var_9);
        // tex_idx = _idx3d(                                                                      <L 617>
        // ac[0] * samples_per_dim + lx, ac[1] * samples_per_dim + ly, ac[2] * samples_per_dim + lz, tex_size, tex_size       <L 618>
        var_58 = wp::extract(var_56, var_57);
        var_59 = wp::mul(var_58, var_4);
        var_60 = wp::add(var_59, var_24);
        var_62 = wp::extract(var_56, var_61);
        var_63 = wp::mul(var_62, var_4);
        var_64 = wp::add(var_63, var_26);
        var_66 = wp::extract(var_56, var_65);
        var_67 = wp::mul(var_66, var_4);
        var_68 = wp::add(var_67, var_28);
        var_69 = _idx3d_0(var_60, var_64, var_68, var_tex_size, var_tex_size);
        // v_normalized = wp.clamp((sdf_val - sdf_min) * sdf_range_inv, 0.0, 1.0)                 <L 620>
        var_70 = wp::sub(var_50, var_sdf_min);
        var_71 = wp::mul(var_70, var_sdf_range_inv);
        var_74 = wp::clamp(var_71, var_72, var_73);
        // subgrid_texture[tex_idx] = wp.uint16(v_normalized * 65535.0)                           <L 621>
        var_76 = wp::mul(var_74, var_75);
        var_77 = wp::uint16(var_76);
        wp::array_store(var_subgrid_texture, var_69, var_77);
    }
}



extern "C" __global__ void _create_source_kernels__locals__populate_subgrid_texture_uint16_kernel_6d36a60d_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::uint64 var_mesh,
    wp::int32 var_shape_type,
    wp::vec_t<3, wp::float32> var_shape_scale,
    wp::array_t<wp::int32> var_subgrid_required,
    wp::array_t<wp::int32> var_subgrid_addresses,
    wp::array_t<wp::uint32> var_subgrid_start_slots,
    wp::array_t<wp::uint16> var_subgrid_texture,
    wp::int32 var_cells_per_subgrid,
    wp::vec_t<3, wp::float32> var_min_corner,
    wp::vec_t<3, wp::float32> var_cell_size,
    wp::float32 var_winding_threshold,
    wp::int32 var_num_subgrids_x,
    wp::int32 var_num_subgrids_y,
    wp::int32 var_num_subgrids_z,
    wp::int32 var_tex_blocks_per_dim,
    wp::int32 var_tex_size,
    wp::float32 var_sdf_min,
    wp::float32 var_sdf_range_inv,
    wp::uint64 adj_mesh,
    wp::int32 adj_shape_type,
    wp::vec_t<3, wp::float32> adj_shape_scale,
    wp::array_t<wp::int32> adj_subgrid_required,
    wp::array_t<wp::int32> adj_subgrid_addresses,
    wp::array_t<wp::uint32> adj_subgrid_start_slots,
    wp::array_t<wp::uint16> adj_subgrid_texture,
    wp::int32 adj_cells_per_subgrid,
    wp::vec_t<3, wp::float32> adj_min_corner,
    wp::vec_t<3, wp::float32> adj_cell_size,
    wp::float32 adj_winding_threshold,
    wp::int32 adj_num_subgrids_x,
    wp::int32 adj_num_subgrids_y,
    wp::int32 adj_num_subgrids_z,
    wp::int32 adj_tex_blocks_per_dim,
    wp::int32 adj_tex_size,
    wp::float32 adj_sdf_min,
    wp::float32 adj_sdf_range_inv)
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
        wp::int32 var_2;
        const wp::int32 var_3 = 1;
        wp::int32 var_4;
        wp::int32 var_5;
        wp::int32 var_6;
        wp::int32 var_7;
        wp::int32 var_8;
        wp::int32 var_9;
        bool var_10;
        wp::int32* var_11;
        const wp::int32 var_12 = 0;
        bool var_13;
        wp::int32 var_14;
        wp::vec_t<3, wp::int32> var_15;
        const wp::int32 var_16 = 0;
        wp::int32 var_17;
        const wp::int32 var_18 = 1;
        wp::int32 var_19;
        const wp::int32 var_20 = 2;
        wp::int32 var_21;
        wp::vec_t<3, wp::int32> var_22;
        const wp::int32 var_23 = 0;
        wp::int32 var_24;
        const wp::int32 var_25 = 1;
        wp::int32 var_26;
        const wp::int32 var_27 = 2;
        wp::int32 var_28;
        wp::int32 var_29;
        wp::int32 var_30;
        wp::int32 var_31;
        wp::int32 var_32;
        wp::int32 var_33;
        wp::int32 var_34;
        wp::float32 var_35;
        const wp::int32 var_36 = 0;
        wp::float32 var_37;
        wp::float32 var_38;
        wp::float32 var_39;
        const wp::int32 var_40 = 1;
        wp::float32 var_41;
        wp::float32 var_42;
        wp::float32 var_43;
        const wp::int32 var_44 = 2;
        wp::float32 var_45;
        wp::float32 var_46;
        wp::vec_t<3, wp::float32> var_47;
        wp::vec_t<3, wp::float32> var_48;
        const wp::float32 var_49 = 10000.0;
        wp::float32 var_50;
        wp::int32* var_51;
        wp::int32 var_52;
        wp::int32 var_53;
        const wp::int32 var_54 = 0;
        bool var_55;
        wp::vec_t<3, wp::int32> var_56;
        const wp::int32 var_57 = 0;
        wp::int32 var_58;
        wp::int32 var_59;
        wp::int32 var_60;
        const wp::int32 var_61 = 1;
        wp::int32 var_62;
        wp::int32 var_63;
        wp::int32 var_64;
        const wp::int32 var_65 = 2;
        wp::int32 var_66;
        wp::int32 var_67;
        wp::int32 var_68;
        wp::int32 var_69;
        wp::float32 var_70;
        wp::float32 var_71;
        const wp::float32 var_72 = 0.0;
        const wp::float32 var_73 = 1.0;
        wp::float32 var_74;
        const wp::float32 var_75 = 65535.0;
        wp::float32 var_76;
        wp::uint16 var_77;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::int32 adj_2 = {};
        wp::int32 adj_3 = {};
        wp::int32 adj_4 = {};
        wp::int32 adj_5 = {};
        wp::int32 adj_6 = {};
        wp::int32 adj_7 = {};
        wp::int32 adj_8 = {};
        wp::int32 adj_9 = {};
        bool adj_10 = {};
        wp::int32 adj_11 = {};
        wp::int32 adj_12 = {};
        bool adj_13 = {};
        wp::int32 adj_14 = {};
        wp::vec_t<3, wp::int32> adj_15 = {};
        wp::int32 adj_16 = {};
        wp::int32 adj_17 = {};
        wp::int32 adj_18 = {};
        wp::int32 adj_19 = {};
        wp::int32 adj_20 = {};
        wp::int32 adj_21 = {};
        wp::vec_t<3, wp::int32> adj_22 = {};
        wp::int32 adj_23 = {};
        wp::int32 adj_24 = {};
        wp::int32 adj_25 = {};
        wp::int32 adj_26 = {};
        wp::int32 adj_27 = {};
        wp::int32 adj_28 = {};
        wp::int32 adj_29 = {};
        wp::int32 adj_30 = {};
        wp::int32 adj_31 = {};
        wp::int32 adj_32 = {};
        wp::int32 adj_33 = {};
        wp::int32 adj_34 = {};
        wp::float32 adj_35 = {};
        wp::int32 adj_36 = {};
        wp::float32 adj_37 = {};
        wp::float32 adj_38 = {};
        wp::float32 adj_39 = {};
        wp::int32 adj_40 = {};
        wp::float32 adj_41 = {};
        wp::float32 adj_42 = {};
        wp::float32 adj_43 = {};
        wp::int32 adj_44 = {};
        wp::float32 adj_45 = {};
        wp::float32 adj_46 = {};
        wp::vec_t<3, wp::float32> adj_47 = {};
        wp::vec_t<3, wp::float32> adj_48 = {};
        wp::float32 adj_49 = {};
        wp::float32 adj_50 = {};
        wp::int32 adj_51 = {};
        wp::int32 adj_52 = {};
        wp::int32 adj_53 = {};
        wp::int32 adj_54 = {};
        bool adj_55 = {};
        wp::vec_t<3, wp::int32> adj_56 = {};
        wp::int32 adj_57 = {};
        wp::int32 adj_58 = {};
        wp::int32 adj_59 = {};
        wp::int32 adj_60 = {};
        wp::int32 adj_61 = {};
        wp::int32 adj_62 = {};
        wp::int32 adj_63 = {};
        wp::int32 adj_64 = {};
        wp::int32 adj_65 = {};
        wp::int32 adj_66 = {};
        wp::int32 adj_67 = {};
        wp::int32 adj_68 = {};
        wp::int32 adj_69 = {};
        wp::float32 adj_70 = {};
        wp::float32 adj_71 = {};
        wp::float32 adj_72 = {};
        wp::float32 adj_73 = {};
        wp::float32 adj_74 = {};
        wp::float32 adj_75 = {};
        wp::float32 adj_76 = {};
        wp::uint16 adj_77 = {};
        //---------
        // forward
        // def populate_subgrid_texture_uint16_kernel(                                            <L 554>
        // tid = wp.tid()                                                                         <L 575>
        var_0 = builtin_tid1d();
        // total_subgrids = num_subgrids_x * num_subgrids_y * num_subgrids_z                      <L 577>
        var_1 = wp::mul(var_num_subgrids_x, var_num_subgrids_y);
        var_2 = wp::mul(var_1, var_num_subgrids_z);
        // samples_per_dim = cells_per_subgrid + 1                                                <L 578>
        var_4 = wp::add(var_cells_per_subgrid, var_3);
        // samples_per_subgrid = samples_per_dim * samples_per_dim * samples_per_dim              <L 579>
        var_5 = wp::mul(var_4, var_4);
        var_6 = wp::mul(var_5, var_4);
        // subgrid_idx = tid // samples_per_subgrid                                               <L 581>
        var_7 = wp::floordiv(var_0, var_6);
        // local_sample = tid - subgrid_idx * samples_per_subgrid                                 <L 582>
        var_8 = wp::mul(var_7, var_6);
        var_9 = wp::sub(var_0, var_8);
        // if subgrid_idx >= total_subgrids:                                                      <L 584>
        var_10 = (var_7 >= var_2);
        if (var_10) {
            // return                                                                             <L 585>
            goto label0;
        }
        // if subgrid_required[subgrid_idx] == 0:                                                 <L 586>
        var_11 = wp::address(var_subgrid_required, var_7);
        var_14 = wp::load(var_11);
        var_13 = (var_14 == var_12);
        if (var_13) {
            // return                                                                             <L 587>
            goto label1;
        }
        // subgrid_coords = _id_to_xyz(subgrid_idx, num_subgrids_x, num_subgrids_y)               <L 589>
        var_15 = _id_to_xyz_0(var_7, var_num_subgrids_x, var_num_subgrids_y);
        // block_x = subgrid_coords[0]                                                            <L 590>
        var_17 = wp::extract(var_15, var_16);
        // block_y = subgrid_coords[1]                                                            <L 591>
        var_19 = wp::extract(var_15, var_18);
        // block_z = subgrid_coords[2]                                                            <L 592>
        var_21 = wp::extract(var_15, var_20);
        // local_coords = _id_to_xyz(local_sample, samples_per_dim, samples_per_dim)              <L 594>
        var_22 = _id_to_xyz_0(var_9, var_4, var_4);
        // lx = local_coords[0]                                                                   <L 595>
        var_24 = wp::extract(var_22, var_23);
        // ly = local_coords[1]                                                                   <L 596>
        var_26 = wp::extract(var_22, var_25);
        // lz = local_coords[2]                                                                   <L 597>
        var_28 = wp::extract(var_22, var_27);
        // gx = block_x * cells_per_subgrid + lx                                                  <L 599>
        var_29 = wp::mul(var_17, var_cells_per_subgrid);
        var_30 = wp::add(var_29, var_24);
        // gy = block_y * cells_per_subgrid + ly                                                  <L 600>
        var_31 = wp::mul(var_19, var_cells_per_subgrid);
        var_32 = wp::add(var_31, var_26);
        // gz = block_z * cells_per_subgrid + lz                                                  <L 601>
        var_33 = wp::mul(var_21, var_cells_per_subgrid);
        var_34 = wp::add(var_33, var_28);
        // pos = min_corner + wp.vec3(                                                            <L 603>
        // float(gx) * cell_size[0],                                                              <L 604>
        var_35 = wp::float(var_30);
        var_37 = wp::extract(var_cell_size, var_36);
        var_38 = wp::mul(var_35, var_37);
        // float(gy) * cell_size[1],                                                              <L 605>
        var_39 = wp::float(var_32);
        var_41 = wp::extract(var_cell_size, var_40);
        var_42 = wp::mul(var_39, var_41);
        // float(gz) * cell_size[2],                                                              <L 606>
        var_43 = wp::float(var_34);
        var_45 = wp::extract(var_cell_size, var_44);
        var_46 = wp::mul(var_43, var_45);
        var_47 = wp::vec_t<3, wp::float32>(var_38, var_42, var_46);
        var_48 = wp::add(var_min_corner, var_47);
        // sdf_val = query_sdf(mesh, shape_type, shape_scale, pos, 10000.0, winding_threshold)       <L 608>
        var_50 = _create_source_kernels__locals__query_sdf_0(var_mesh, var_shape_type, var_shape_scale, var_48, var_49, var_winding_threshold);
        // address = subgrid_addresses[subgrid_idx]                                               <L 610>
        var_51 = wp::address(var_subgrid_addresses, var_7);
        var_53 = wp::load(var_51);
        var_52 = wp::copy(var_53);
        // if address < 0:                                                                        <L 611>
        var_55 = (var_52 < var_54);
        if (var_55) {
            // return                                                                             <L 612>
            goto label2;
        }
        // ac = _write_subgrid_slot(                                                              <L 614>
        // subgrid_start_slots, address, tex_blocks_per_dim, block_x, block_y, block_z, local_sample       <L 615>
        var_56 = _write_subgrid_slot_0(var_subgrid_start_slots, var_52, var_tex_blocks_per_dim, var_17, var_19, var_21, var_9);
        // tex_idx = _idx3d(                                                                      <L 617>
        // ac[0] * samples_per_dim + lx, ac[1] * samples_per_dim + ly, ac[2] * samples_per_dim + lz, tex_size, tex_size       <L 618>
        var_58 = wp::extract(var_56, var_57);
        var_59 = wp::mul(var_58, var_4);
        var_60 = wp::add(var_59, var_24);
        var_62 = wp::extract(var_56, var_61);
        var_63 = wp::mul(var_62, var_4);
        var_64 = wp::add(var_63, var_26);
        var_66 = wp::extract(var_56, var_65);
        var_67 = wp::mul(var_66, var_4);
        var_68 = wp::add(var_67, var_28);
        var_69 = _idx3d_0(var_60, var_64, var_68, var_tex_size, var_tex_size);
        // v_normalized = wp.clamp((sdf_val - sdf_min) * sdf_range_inv, 0.0, 1.0)                 <L 620>
        var_70 = wp::sub(var_50, var_sdf_min);
        var_71 = wp::mul(var_70, var_sdf_range_inv);
        var_74 = wp::clamp(var_71, var_72, var_73);
        // subgrid_texture[tex_idx] = wp.uint16(v_normalized * 65535.0)                           <L 621>
        var_76 = wp::mul(var_74, var_75);
        var_77 = wp::uint16(var_76);
        // wp::array_store(var_subgrid_texture, var_69, var_77);
        //---------
        // reverse
        wp::adj_array_store(var_subgrid_texture, var_69, var_77, adj_subgrid_texture, adj_69, adj_77);
        wp::adj_mul(var_74, var_75, adj_74, adj_75, adj_76);
        // adj: subgrid_texture[tex_idx] = wp.uint16(v_normalized * 65535.0)                      <L 621>
        wp::adj_clamp(var_71, var_72, var_73, adj_71, adj_72, adj_73, adj_74);
        wp::adj_mul(var_70, var_sdf_range_inv, adj_70, adj_sdf_range_inv, adj_71);
        wp::adj_sub(var_50, var_sdf_min, adj_50, adj_sdf_min, adj_70);
        // adj: v_normalized = wp.clamp((sdf_val - sdf_min) * sdf_range_inv, 0.0, 1.0)            <L 620>
        adj__idx3d_0(var_60, var_64, var_68, var_tex_size, var_tex_size, adj_60, adj_64, adj_68, adj_tex_size, adj_tex_size, adj_69);
        wp::adj_add(var_67, var_28, adj_67, adj_28, adj_68);
        wp::adj_mul(var_66, var_4, adj_66, adj_4, adj_67);
        wp::adj_extract(var_56, var_65, adj_56, adj_65, adj_66);
        wp::adj_add(var_63, var_26, adj_63, adj_26, adj_64);
        wp::adj_mul(var_62, var_4, adj_62, adj_4, adj_63);
        wp::adj_extract(var_56, var_61, adj_56, adj_61, adj_62);
        wp::adj_add(var_59, var_24, adj_59, adj_24, adj_60);
        wp::adj_mul(var_58, var_4, adj_58, adj_4, adj_59);
        wp::adj_extract(var_56, var_57, adj_56, adj_57, adj_58);
        // adj: ac[0] * samples_per_dim + lx, ac[1] * samples_per_dim + ly, ac[2] * samples_per_dim + lz, tex_size, tex_size  <L 618>
        // adj: tex_idx = _idx3d(                                                                 <L 617>
        adj__write_subgrid_slot_0(var_subgrid_start_slots, var_52, var_tex_blocks_per_dim, var_17, var_19, var_21, var_9, adj_subgrid_start_slots, adj_52, adj_tex_blocks_per_dim, adj_17, adj_19, adj_21, adj_9, adj_56);
        // adj: subgrid_start_slots, address, tex_blocks_per_dim, block_x, block_y, block_z, local_sample  <L 615>
        // adj: ac = _write_subgrid_slot(                                                         <L 614>
        if (var_55) {
            label2:;
            // adj: return                                                                        <L 612>
        }
        // adj: if address < 0:                                                                   <L 611>
        wp::adj_copy(var_53, adj_51, adj_52);
        wp::adj_address(var_subgrid_addresses, var_7, adj_subgrid_addresses, adj_7, adj_51);
        // adj: address = subgrid_addresses[subgrid_idx]                                          <L 610>
        adj__create_source_kernels__locals__query_sdf_0(var_mesh, var_shape_type, var_shape_scale, var_48, var_49, var_winding_threshold, adj_mesh, adj_shape_type, adj_shape_scale, adj_48, adj_49, adj_winding_threshold, adj_50);
        // adj: sdf_val = query_sdf(mesh, shape_type, shape_scale, pos, 10000.0, winding_threshold)  <L 608>
        wp::adj_add(var_min_corner, var_47, adj_min_corner, adj_47, adj_48);
        wp::adj_vec_t(var_38, var_42, var_46, adj_38, adj_42, adj_46, adj_47);
        wp::adj_mul(var_43, var_45, adj_43, adj_45, adj_46);
        wp::adj_extract(var_cell_size, var_44, adj_cell_size, adj_44, adj_45);
        wp::adj_float(var_34, adj_34, adj_43);
        // adj: float(gz) * cell_size[2],                                                         <L 606>
        wp::adj_mul(var_39, var_41, adj_39, adj_41, adj_42);
        wp::adj_extract(var_cell_size, var_40, adj_cell_size, adj_40, adj_41);
        wp::adj_float(var_32, adj_32, adj_39);
        // adj: float(gy) * cell_size[1],                                                         <L 605>
        wp::adj_mul(var_35, var_37, adj_35, adj_37, adj_38);
        wp::adj_extract(var_cell_size, var_36, adj_cell_size, adj_36, adj_37);
        wp::adj_float(var_30, adj_30, adj_35);
        // adj: float(gx) * cell_size[0],                                                         <L 604>
        // adj: pos = min_corner + wp.vec3(                                                       <L 603>
        wp::adj_add(var_33, var_28, adj_33, adj_28, adj_34);
        wp::adj_mul(var_21, var_cells_per_subgrid, adj_21, adj_cells_per_subgrid, adj_33);
        // adj: gz = block_z * cells_per_subgrid + lz                                             <L 601>
        wp::adj_add(var_31, var_26, adj_31, adj_26, adj_32);
        wp::adj_mul(var_19, var_cells_per_subgrid, adj_19, adj_cells_per_subgrid, adj_31);
        // adj: gy = block_y * cells_per_subgrid + ly                                             <L 600>
        wp::adj_add(var_29, var_24, adj_29, adj_24, adj_30);
        wp::adj_mul(var_17, var_cells_per_subgrid, adj_17, adj_cells_per_subgrid, adj_29);
        // adj: gx = block_x * cells_per_subgrid + lx                                             <L 599>
        wp::adj_extract(var_22, var_27, adj_22, adj_27, adj_28);
        // adj: lz = local_coords[2]                                                              <L 597>
        wp::adj_extract(var_22, var_25, adj_22, adj_25, adj_26);
        // adj: ly = local_coords[1]                                                              <L 596>
        wp::adj_extract(var_22, var_23, adj_22, adj_23, adj_24);
        // adj: lx = local_coords[0]                                                              <L 595>
        adj__id_to_xyz_0(var_9, var_4, var_4, adj_9, adj_4, adj_4, adj_22);
        // adj: local_coords = _id_to_xyz(local_sample, samples_per_dim, samples_per_dim)         <L 594>
        wp::adj_extract(var_15, var_20, adj_15, adj_20, adj_21);
        // adj: block_z = subgrid_coords[2]                                                       <L 592>
        wp::adj_extract(var_15, var_18, adj_15, adj_18, adj_19);
        // adj: block_y = subgrid_coords[1]                                                       <L 591>
        wp::adj_extract(var_15, var_16, adj_15, adj_16, adj_17);
        // adj: block_x = subgrid_coords[0]                                                       <L 590>
        adj__id_to_xyz_0(var_7, var_num_subgrids_x, var_num_subgrids_y, adj_7, adj_num_subgrids_x, adj_num_subgrids_y, adj_15);
        // adj: subgrid_coords = _id_to_xyz(subgrid_idx, num_subgrids_x, num_subgrids_y)          <L 589>
        if (var_13) {
            label1:;
            // adj: return                                                                        <L 587>
        }
        wp::adj_address(var_subgrid_required, var_7, adj_subgrid_required, adj_7, adj_11);
        // adj: if subgrid_required[subgrid_idx] == 0:                                            <L 586>
        if (var_10) {
            label0:;
            // adj: return                                                                        <L 585>
        }
        // adj: if subgrid_idx >= total_subgrids:                                                 <L 584>
        wp::adj_sub(var_0, var_8, adj_0, adj_8, adj_9);
        wp::adj_mul(var_7, var_6, adj_7, adj_6, adj_8);
        // adj: local_sample = tid - subgrid_idx * samples_per_subgrid                            <L 582>
        // adj: subgrid_idx = tid // samples_per_subgrid                                          <L 581>
        wp::adj_mul(var_5, var_4, adj_5, adj_4, adj_6);
        wp::adj_mul(var_4, var_4, adj_4, adj_4, adj_5);
        // adj: samples_per_subgrid = samples_per_dim * samples_per_dim * samples_per_dim         <L 579>
        wp::adj_add(var_cells_per_subgrid, var_3, adj_cells_per_subgrid, adj_3, adj_4);
        // adj: samples_per_dim = cells_per_subgrid + 1                                           <L 578>
        wp::adj_mul(var_1, var_num_subgrids_z, adj_1, adj_num_subgrids_z, adj_2);
        wp::adj_mul(var_num_subgrids_x, var_num_subgrids_y, adj_num_subgrids_x, adj_num_subgrids_y, adj_1);
        // adj: total_subgrids = num_subgrids_x * num_subgrids_y * num_subgrids_z                 <L 577>
        // adj: tid = wp.tid()                                                                    <L 575>
        // adj: def populate_subgrid_texture_uint16_kernel(                                       <L 554>
        continue;
    }
}



extern "C" __global__ void _create_source_kernels__locals__build_coarse_sdf_kernel_9268e38d_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::uint64 var_mesh,
    wp::int32 var_shape_type,
    wp::vec_t<3, wp::float32> var_shape_scale,
    wp::array_t<wp::float32> var_background_sdf,
    wp::vec_t<3, wp::float32> var_min_corner,
    wp::vec_t<3, wp::float32> var_cell_size,
    wp::int32 var_cells_per_subgrid,
    wp::int32 var_bg_size_x,
    wp::int32 var_bg_size_y,
    wp::int32 var_bg_size_z,
    wp::float32 var_winding_threshold)
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
        wp::int32 var_2;
        bool var_3;
        wp::vec_t<3, wp::int32> var_4;
        const wp::int32 var_5 = 0;
        wp::int32 var_6;
        const wp::int32 var_7 = 1;
        wp::int32 var_8;
        const wp::int32 var_9 = 2;
        wp::int32 var_10;
        wp::int32 var_11;
        wp::float32 var_12;
        const wp::int32 var_13 = 0;
        wp::float32 var_14;
        wp::float32 var_15;
        wp::int32 var_16;
        wp::float32 var_17;
        const wp::int32 var_18 = 1;
        wp::float32 var_19;
        wp::float32 var_20;
        wp::int32 var_21;
        wp::float32 var_22;
        const wp::int32 var_23 = 2;
        wp::float32 var_24;
        wp::float32 var_25;
        wp::vec_t<3, wp::float32> var_26;
        wp::vec_t<3, wp::float32> var_27;
        const wp::float32 var_28 = 10000.0;
        wp::float32 var_29;
        //---------
        // forward
        // def build_coarse_sdf_kernel(                                                           <L 453>
        // tid = wp.tid()                                                                         <L 467>
        var_0 = builtin_tid1d();
        // total_bg = bg_size_x * bg_size_y * bg_size_z                                           <L 469>
        var_1 = wp::mul(var_bg_size_x, var_bg_size_y);
        var_2 = wp::mul(var_1, var_bg_size_z);
        // if tid >= total_bg:                                                                    <L 470>
        var_3 = (var_0 >= var_2);
        if (var_3) {
            // return                                                                             <L 471>
            continue;
        }
        // coords = _id_to_xyz(tid, bg_size_x, bg_size_y)                                         <L 473>
        var_4 = _id_to_xyz_0(var_0, var_bg_size_x, var_bg_size_y);
        // x_block = coords[0]                                                                    <L 474>
        var_6 = wp::extract(var_4, var_5);
        // y_block = coords[1]                                                                    <L 475>
        var_8 = wp::extract(var_4, var_7);
        // z_block = coords[2]                                                                    <L 476>
        var_10 = wp::extract(var_4, var_9);
        // pos = min_corner + wp.vec3(                                                            <L 478>
        // float(x_block * cells_per_subgrid) * cell_size[0],                                     <L 479>
        var_11 = wp::mul(var_6, var_cells_per_subgrid);
        var_12 = wp::float(var_11);
        var_14 = wp::extract(var_cell_size, var_13);
        var_15 = wp::mul(var_12, var_14);
        // float(y_block * cells_per_subgrid) * cell_size[1],                                     <L 480>
        var_16 = wp::mul(var_8, var_cells_per_subgrid);
        var_17 = wp::float(var_16);
        var_19 = wp::extract(var_cell_size, var_18);
        var_20 = wp::mul(var_17, var_19);
        // float(z_block * cells_per_subgrid) * cell_size[2],                                     <L 481>
        var_21 = wp::mul(var_10, var_cells_per_subgrid);
        var_22 = wp::float(var_21);
        var_24 = wp::extract(var_cell_size, var_23);
        var_25 = wp::mul(var_22, var_24);
        var_26 = wp::vec_t<3, wp::float32>(var_15, var_20, var_25);
        var_27 = wp::add(var_min_corner, var_26);
        // background_sdf[tid] = query_sdf(mesh, shape_type, shape_scale, pos, 10000.0, winding_threshold)       <L 484>
        var_29 = _create_source_kernels__locals__query_sdf_0(var_mesh, var_shape_type, var_shape_scale, var_27, var_28, var_winding_threshold);
        wp::array_store(var_background_sdf, var_0, var_29);
    }
}



extern "C" __global__ void _create_source_kernels__locals__build_coarse_sdf_kernel_9268e38d_cuda_kernel_backward(
    wp::launch_bounds_t<1> dim,
    wp::uint64 var_mesh,
    wp::int32 var_shape_type,
    wp::vec_t<3, wp::float32> var_shape_scale,
    wp::array_t<wp::float32> var_background_sdf,
    wp::vec_t<3, wp::float32> var_min_corner,
    wp::vec_t<3, wp::float32> var_cell_size,
    wp::int32 var_cells_per_subgrid,
    wp::int32 var_bg_size_x,
    wp::int32 var_bg_size_y,
    wp::int32 var_bg_size_z,
    wp::float32 var_winding_threshold,
    wp::uint64 adj_mesh,
    wp::int32 adj_shape_type,
    wp::vec_t<3, wp::float32> adj_shape_scale,
    wp::array_t<wp::float32> adj_background_sdf,
    wp::vec_t<3, wp::float32> adj_min_corner,
    wp::vec_t<3, wp::float32> adj_cell_size,
    wp::int32 adj_cells_per_subgrid,
    wp::int32 adj_bg_size_x,
    wp::int32 adj_bg_size_y,
    wp::int32 adj_bg_size_z,
    wp::float32 adj_winding_threshold)
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
        wp::int32 var_2;
        bool var_3;
        wp::vec_t<3, wp::int32> var_4;
        const wp::int32 var_5 = 0;
        wp::int32 var_6;
        const wp::int32 var_7 = 1;
        wp::int32 var_8;
        const wp::int32 var_9 = 2;
        wp::int32 var_10;
        wp::int32 var_11;
        wp::float32 var_12;
        const wp::int32 var_13 = 0;
        wp::float32 var_14;
        wp::float32 var_15;
        wp::int32 var_16;
        wp::float32 var_17;
        const wp::int32 var_18 = 1;
        wp::float32 var_19;
        wp::float32 var_20;
        wp::int32 var_21;
        wp::float32 var_22;
        const wp::int32 var_23 = 2;
        wp::float32 var_24;
        wp::float32 var_25;
        wp::vec_t<3, wp::float32> var_26;
        wp::vec_t<3, wp::float32> var_27;
        const wp::float32 var_28 = 10000.0;
        wp::float32 var_29;
        //---------
        // dual vars
        wp::int32 adj_0 = {};
        wp::int32 adj_1 = {};
        wp::int32 adj_2 = {};
        bool adj_3 = {};
        wp::vec_t<3, wp::int32> adj_4 = {};
        wp::int32 adj_5 = {};
        wp::int32 adj_6 = {};
        wp::int32 adj_7 = {};
        wp::int32 adj_8 = {};
        wp::int32 adj_9 = {};
        wp::int32 adj_10 = {};
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
        wp::int32 adj_21 = {};
        wp::float32 adj_22 = {};
        wp::int32 adj_23 = {};
        wp::float32 adj_24 = {};
        wp::float32 adj_25 = {};
        wp::vec_t<3, wp::float32> adj_26 = {};
        wp::vec_t<3, wp::float32> adj_27 = {};
        wp::float32 adj_28 = {};
        wp::float32 adj_29 = {};
        //---------
        // forward
        // def build_coarse_sdf_kernel(                                                           <L 453>
        // tid = wp.tid()                                                                         <L 467>
        var_0 = builtin_tid1d();
        // total_bg = bg_size_x * bg_size_y * bg_size_z                                           <L 469>
        var_1 = wp::mul(var_bg_size_x, var_bg_size_y);
        var_2 = wp::mul(var_1, var_bg_size_z);
        // if tid >= total_bg:                                                                    <L 470>
        var_3 = (var_0 >= var_2);
        if (var_3) {
            // return                                                                             <L 471>
            goto label0;
        }
        // coords = _id_to_xyz(tid, bg_size_x, bg_size_y)                                         <L 473>
        var_4 = _id_to_xyz_0(var_0, var_bg_size_x, var_bg_size_y);
        // x_block = coords[0]                                                                    <L 474>
        var_6 = wp::extract(var_4, var_5);
        // y_block = coords[1]                                                                    <L 475>
        var_8 = wp::extract(var_4, var_7);
        // z_block = coords[2]                                                                    <L 476>
        var_10 = wp::extract(var_4, var_9);
        // pos = min_corner + wp.vec3(                                                            <L 478>
        // float(x_block * cells_per_subgrid) * cell_size[0],                                     <L 479>
        var_11 = wp::mul(var_6, var_cells_per_subgrid);
        var_12 = wp::float(var_11);
        var_14 = wp::extract(var_cell_size, var_13);
        var_15 = wp::mul(var_12, var_14);
        // float(y_block * cells_per_subgrid) * cell_size[1],                                     <L 480>
        var_16 = wp::mul(var_8, var_cells_per_subgrid);
        var_17 = wp::float(var_16);
        var_19 = wp::extract(var_cell_size, var_18);
        var_20 = wp::mul(var_17, var_19);
        // float(z_block * cells_per_subgrid) * cell_size[2],                                     <L 481>
        var_21 = wp::mul(var_10, var_cells_per_subgrid);
        var_22 = wp::float(var_21);
        var_24 = wp::extract(var_cell_size, var_23);
        var_25 = wp::mul(var_22, var_24);
        var_26 = wp::vec_t<3, wp::float32>(var_15, var_20, var_25);
        var_27 = wp::add(var_min_corner, var_26);
        // background_sdf[tid] = query_sdf(mesh, shape_type, shape_scale, pos, 10000.0, winding_threshold)       <L 484>
        var_29 = _create_source_kernels__locals__query_sdf_0(var_mesh, var_shape_type, var_shape_scale, var_27, var_28, var_winding_threshold);
        // wp::array_store(var_background_sdf, var_0, var_29);
        //---------
        // reverse
        wp::adj_array_store(var_background_sdf, var_0, var_29, adj_background_sdf, adj_0, adj_29);
        adj__create_source_kernels__locals__query_sdf_0(var_mesh, var_shape_type, var_shape_scale, var_27, var_28, var_winding_threshold, adj_mesh, adj_shape_type, adj_shape_scale, adj_27, adj_28, adj_winding_threshold, adj_29);
        // adj: background_sdf[tid] = query_sdf(mesh, shape_type, shape_scale, pos, 10000.0, winding_threshold)  <L 484>
        wp::adj_add(var_min_corner, var_26, adj_min_corner, adj_26, adj_27);
        wp::adj_vec_t(var_15, var_20, var_25, adj_15, adj_20, adj_25, adj_26);
        wp::adj_mul(var_22, var_24, adj_22, adj_24, adj_25);
        wp::adj_extract(var_cell_size, var_23, adj_cell_size, adj_23, adj_24);
        wp::adj_float(var_21, adj_21, adj_22);
        wp::adj_mul(var_10, var_cells_per_subgrid, adj_10, adj_cells_per_subgrid, adj_21);
        // adj: float(z_block * cells_per_subgrid) * cell_size[2],                                <L 481>
        wp::adj_mul(var_17, var_19, adj_17, adj_19, adj_20);
        wp::adj_extract(var_cell_size, var_18, adj_cell_size, adj_18, adj_19);
        wp::adj_float(var_16, adj_16, adj_17);
        wp::adj_mul(var_8, var_cells_per_subgrid, adj_8, adj_cells_per_subgrid, adj_16);
        // adj: float(y_block * cells_per_subgrid) * cell_size[1],                                <L 480>
        wp::adj_mul(var_12, var_14, adj_12, adj_14, adj_15);
        wp::adj_extract(var_cell_size, var_13, adj_cell_size, adj_13, adj_14);
        wp::adj_float(var_11, adj_11, adj_12);
        wp::adj_mul(var_6, var_cells_per_subgrid, adj_6, adj_cells_per_subgrid, adj_11);
        // adj: float(x_block * cells_per_subgrid) * cell_size[0],                                <L 479>
        // adj: pos = min_corner + wp.vec3(                                                       <L 478>
        wp::adj_extract(var_4, var_9, adj_4, adj_9, adj_10);
        // adj: z_block = coords[2]                                                               <L 476>
        wp::adj_extract(var_4, var_7, adj_4, adj_7, adj_8);
        // adj: y_block = coords[1]                                                               <L 475>
        wp::adj_extract(var_4, var_5, adj_4, adj_5, adj_6);
        // adj: x_block = coords[0]                                                               <L 474>
        adj__id_to_xyz_0(var_0, var_bg_size_x, var_bg_size_y, adj_0, adj_bg_size_x, adj_bg_size_y, adj_4);
        // adj: coords = _id_to_xyz(tid, bg_size_x, bg_size_y)                                    <L 473>
        if (var_3) {
            label0:;
            // adj: return                                                                        <L 471>
        }
        // adj: if tid >= total_bg:                                                               <L 470>
        wp::adj_mul(var_1, var_bg_size_z, adj_1, adj_bg_size_z, adj_2);
        wp::adj_mul(var_bg_size_x, var_bg_size_y, adj_bg_size_x, adj_bg_size_y, adj_1);
        // adj: total_bg = bg_size_x * bg_size_y * bg_size_z                                      <L 469>
        // adj: tid = wp.tid()                                                                    <L 467>
        // adj: def build_coarse_sdf_kernel(                                                      <L 453>
        continue;
    }
}



extern "C" __global__ void _generate_isomesh_texture_kernel_a32fe0fb_cuda_kernel_forward(
    wp::launch_bounds_t<4> dim,
    wp::array_t<TextureSDFData_93572308> var_sdf_array,
    wp::array_t<wp::vec_t<3, wp::int32>> var_active_coarse_cells,
    wp::int32 var_subgrid_size,
    wp::array_t<wp::int32> var_tri_range_table,
    wp::array_t<wp::vec_t<2, wp::uint8>> var_flat_edge_verts_table,
    wp::array_t<wp::vec_t<3, wp::uint8>> var_corner_offsets_table,
    wp::float32 var_isovalue,
    wp::array_t<wp::int32> var_face_count,
    wp::array_t<wp::vec_t<3, wp::float32>> var_vertices)
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
        wp::int32 var_2;
        wp::int32 var_3;
        const wp::int32 var_4 = 0;
        TextureSDFData_93572308* var_5;
        TextureSDFData_93572308 var_6;
        TextureSDFData_93572308 var_7;
        wp::vec_t<3, wp::int32>* var_8;
        wp::vec_t<3, wp::int32> var_9;
        wp::vec_t<3, wp::int32> var_10;
        const wp::int32 var_11 = 0;
        wp::int32 var_12;
        wp::int32 var_13;
        wp::int32 var_14;
        const wp::int32 var_15 = 1;
        wp::int32 var_16;
        wp::int32 var_17;
        wp::int32 var_18;
        const wp::int32 var_19 = 2;
        wp::int32 var_20;
        wp::int32 var_21;
        wp::int32 var_22;
        const wp::int32 var_23 = 0;
        wp::int32 var_24;
        wp::vec_t<8, wp::float32> var_25;
        const wp::int32 var_26 = 0;
        wp::vec_t<3, wp::uint8>* var_27;
        wp::vec_t<3, wp::int32> var_28;
        wp::vec_t<3, wp::uint8> var_29;
        const wp::int32 var_30 = 0;
        wp::int32 var_31;
        wp::int32 var_32;
        const wp::int32 var_33 = 1;
        wp::int32 var_34;
        wp::int32 var_35;
        const wp::int32 var_36 = 2;
        wp::int32 var_37;
        wp::int32 var_38;
        wp::float32 var_39;
        bool var_40;
        bool var_41;
        const wp::int32 var_42 = 1;
        wp::int32 var_43;
        wp::int32 var_44;
        wp::int32 var_45;
        const wp::int32 var_46 = 1;
        wp::vec_t<3, wp::uint8>* var_47;
        wp::vec_t<3, wp::int32> var_48;
        wp::vec_t<3, wp::uint8> var_49;
        const wp::int32 var_50 = 0;
        wp::int32 var_51;
        wp::int32 var_52;
        const wp::int32 var_53 = 1;
        wp::int32 var_54;
        wp::int32 var_55;
        const wp::int32 var_56 = 2;
        wp::int32 var_57;
        wp::int32 var_58;
        wp::float32 var_59;
        bool var_60;
        bool var_61;
        const wp::int32 var_62 = 1;
        wp::int32 var_63;
        wp::int32 var_64;
        wp::int32 var_65;
        const wp::int32 var_66 = 2;
        wp::vec_t<3, wp::uint8>* var_67;
        wp::vec_t<3, wp::int32> var_68;
        wp::vec_t<3, wp::uint8> var_69;
        const wp::int32 var_70 = 0;
        wp::int32 var_71;
        wp::int32 var_72;
        const wp::int32 var_73 = 1;
        wp::int32 var_74;
        wp::int32 var_75;
        const wp::int32 var_76 = 2;
        wp::int32 var_77;
        wp::int32 var_78;
        wp::float32 var_79;
        bool var_80;
        bool var_81;
        const wp::int32 var_82 = 1;
        wp::int32 var_83;
        wp::int32 var_84;
        wp::int32 var_85;
        const wp::int32 var_86 = 3;
        wp::vec_t<3, wp::uint8>* var_87;
        wp::vec_t<3, wp::int32> var_88;
        wp::vec_t<3, wp::uint8> var_89;
        const wp::int32 var_90 = 0;
        wp::int32 var_91;
        wp::int32 var_92;
        const wp::int32 var_93 = 1;
        wp::int32 var_94;
        wp::int32 var_95;
        const wp::int32 var_96 = 2;
        wp::int32 var_97;
        wp::int32 var_98;
        wp::float32 var_99;
        bool var_100;
        bool var_101;
        const wp::int32 var_102 = 1;
        wp::int32 var_103;
        wp::int32 var_104;
        wp::int32 var_105;
        const wp::int32 var_106 = 4;
        wp::vec_t<3, wp::uint8>* var_107;
        wp::vec_t<3, wp::int32> var_108;
        wp::vec_t<3, wp::uint8> var_109;
        const wp::int32 var_110 = 0;
        wp::int32 var_111;
        wp::int32 var_112;
        const wp::int32 var_113 = 1;
        wp::int32 var_114;
        wp::int32 var_115;
        const wp::int32 var_116 = 2;
        wp::int32 var_117;
        wp::int32 var_118;
        wp::float32 var_119;
        bool var_120;
        bool var_121;
        const wp::int32 var_122 = 1;
        wp::int32 var_123;
        wp::int32 var_124;
        wp::int32 var_125;
        const wp::int32 var_126 = 5;
        wp::vec_t<3, wp::uint8>* var_127;
        wp::vec_t<3, wp::int32> var_128;
        wp::vec_t<3, wp::uint8> var_129;
        const wp::int32 var_130 = 0;
        wp::int32 var_131;
        wp::int32 var_132;
        const wp::int32 var_133 = 1;
        wp::int32 var_134;
        wp::int32 var_135;
        const wp::int32 var_136 = 2;
        wp::int32 var_137;
        wp::int32 var_138;
        wp::float32 var_139;
        bool var_140;
        bool var_141;
        const wp::int32 var_142 = 1;
        wp::int32 var_143;
        wp::int32 var_144;
        wp::int32 var_145;
        const wp::int32 var_146 = 6;
        wp::vec_t<3, wp::uint8>* var_147;
        wp::vec_t<3, wp::int32> var_148;
        wp::vec_t<3, wp::uint8> var_149;
        const wp::int32 var_150 = 0;
        wp::int32 var_151;
        wp::int32 var_152;
        const wp::int32 var_153 = 1;
        wp::int32 var_154;
        wp::int32 var_155;
        const wp::int32 var_156 = 2;
        wp::int32 var_157;
        wp::int32 var_158;
        wp::float32 var_159;
        bool var_160;
        bool var_161;
        const wp::int32 var_162 = 1;
        wp::int32 var_163;
        wp::int32 var_164;
        wp::int32 var_165;
        const wp::int32 var_166 = 7;
        wp::vec_t<3, wp::uint8>* var_167;
        wp::vec_t<3, wp::int32> var_168;
        wp::vec_t<3, wp::uint8> var_169;
        const wp::int32 var_170 = 0;
        wp::int32 var_171;
        wp::int32 var_172;
        const wp::int32 var_173 = 1;
        wp::int32 var_174;
        wp::int32 var_175;
        const wp::int32 var_176 = 2;
        wp::int32 var_177;
        wp::int32 var_178;
        wp::float32 var_179;
        bool var_180;
        bool var_181;
        const wp::int32 var_182 = 1;
        wp::int32 var_183;
        wp::int32 var_184;
        wp::int32 var_185;
        wp::int32* var_186;
        wp::int32 var_187;
        wp::int32 var_188;
        const wp::int32 var_189 = 1;
        wp::int32 var_190;
        wp::int32* var_191;
        wp::int32 var_192;
        wp::int32 var_193;
        wp::int32 var_194;
        const wp::int32 var_195 = 3;
        wp::int32 var_196;
        const wp::int32 var_197 = 0;
        bool var_198;
        const wp::int32 var_199 = 0;
        wp::int32 var_200;
        const wp::int32 var_201 = 0;
        bool var_202;
        const wp::int32 var_203 = 0;
        const wp::int32 var_204 = 3;
        wp::int32 var_205;
        wp::int32 var_206;
        wp::int32 var_207;
        wp::vec_t<2, wp::uint8>* var_208;
        wp::vec_t<2, wp::int32> var_209;
        wp::vec_t<2, wp::uint8> var_210;
        const wp::int32 var_211 = 0;
        wp::int32 var_212;
        const wp::int32 var_213 = 1;
        wp::int32 var_214;
        wp::float32 var_215;
        wp::float32 var_216;
        wp::float32 var_217;
        wp::float32 var_218;
        wp::vec_t<3, wp::uint8>* var_219;
        wp::vec_t<3, wp::float32> var_220;
        wp::vec_t<3, wp::uint8> var_221;
        wp::vec_t<3, wp::uint8>* var_222;
        wp::vec_t<3, wp::float32> var_223;
        wp::vec_t<3, wp::uint8> var_224;
        wp::float32 var_225;
        wp::float32 var_226;
        const wp::float32 var_227 = 1e-10;
        bool var_228;
        const wp::float32 var_229 = 0.5;
        wp::vec_t<3, wp::float32> var_230;
        wp::vec_t<3, wp::float32> var_231;
        wp::float32 var_232;
        wp::float32 var_233;
        const wp::float32 var_234 = 0.02;
        const wp::float32 var_235 = 0.98;
        wp::float32 var_236;
        wp::vec_t<3, wp::float32> var_237;
        wp::vec_t<3, wp::float32> var_238;
        wp::vec_t<3, wp::float32> var_239;
        wp::vec_t<3, wp::float32> var_240;
        wp::float32 var_241;
        wp::float32 var_242;
        wp::float32 var_243;
        wp::vec_t<3, wp::float32> var_244;
        wp::vec_t<3, wp::float32> var_245;
        wp::vec_t<3, wp::float32>* var_246;
        wp::vec_t<3, wp::float32>* var_247;
        wp::vec_t<3, wp::float32> var_248;
        wp::vec_t<3, wp::float32> var_249;
        wp::vec_t<3, wp::float32> var_250;
        wp::vec_t<3, wp::float32> var_251;
        const wp::int32 var_252 = 3;
        wp::int32 var_253;
        const wp::int32 var_254 = 3;
        wp::int32 var_255;
        wp::int32 var_256;
        wp::int32 var_257;
        const wp::int32 var_258 = 1;
        const wp::int32 var_259 = 3;
        wp::int32 var_260;
        wp::int32 var_261;
        wp::int32 var_262;
        wp::vec_t<2, wp::uint8>* var_263;
        wp::vec_t<2, wp::int32> var_264;
        wp::vec_t<2, wp::uint8> var_265;
        const wp::int32 var_266 = 0;
        wp::int32 var_267;
        const wp::int32 var_268 = 1;
        wp::int32 var_269;
        wp::float32 var_270;
        wp::float32 var_271;
        wp::float32 var_272;
        wp::float32 var_273;
        wp::vec_t<3, wp::uint8>* var_274;
        wp::vec_t<3, wp::float32> var_275;
        wp::vec_t<3, wp::uint8> var_276;
        wp::vec_t<3, wp::uint8>* var_277;
        wp::vec_t<3, wp::float32> var_278;
        wp::vec_t<3, wp::uint8> var_279;
        wp::float32 var_280;
        wp::float32 var_281;
        bool var_282;
        const wp::float32 var_283 = 0.5;
        wp::vec_t<3, wp::float32> var_284;
        wp::vec_t<3, wp::float32> var_285;
        wp::float32 var_286;
        wp::float32 var_287;
        wp::float32 var_288;
        wp::vec_t<3, wp::float32> var_289;
        wp::vec_t<3, wp::float32> var_290;
        wp::vec_t<3, wp::float32> var_291;
        wp::vec_t<3, wp::float32> var_292;
        wp::float32 var_293;
        wp::float32 var_294;
        wp::float32 var_295;
        wp::float32 var_296;
        wp::vec_t<3, wp::float32> var_297;
        wp::vec_t<3, wp::float32> var_298;
        wp::vec_t<3, wp::float32>* var_299;
        wp::vec_t<3, wp::float32>* var_300;
        wp::vec_t<3, wp::float32> var_301;
        wp::vec_t<3, wp::float32> var_302;
        wp::vec_t<3, wp::float32> var_303;
        wp::vec_t<3, wp::float32> var_304;
        const wp::int32 var_305 = 3;
        wp::int32 var_306;
        const wp::int32 var_307 = 3;
        wp::int32 var_308;
        wp::int32 var_309;
        wp::int32 var_310;
        const wp::int32 var_311 = 2;
        const wp::int32 var_312 = 3;
        wp::int32 var_313;
        wp::int32 var_314;
        wp::int32 var_315;
        wp::vec_t<2, wp::uint8>* var_316;
        wp::vec_t<2, wp::int32> var_317;
        wp::vec_t<2, wp::uint8> var_318;
        const wp::int32 var_319 = 0;
        wp::int32 var_320;
        const wp::int32 var_321 = 1;
        wp::int32 var_322;
        wp::float32 var_323;
        wp::float32 var_324;
        wp::float32 var_325;
        wp::float32 var_326;
        wp::vec_t<3, wp::uint8>* var_327;
        wp::vec_t<3, wp::float32> var_328;
        wp::vec_t<3, wp::uint8> var_329;
        wp::vec_t<3, wp::uint8>* var_330;
        wp::vec_t<3, wp::float32> var_331;
        wp::vec_t<3, wp::uint8> var_332;
        wp::float32 var_333;
        wp::float32 var_334;
        bool var_335;
        const wp::float32 var_336 = 0.5;
        wp::vec_t<3, wp::float32> var_337;
        wp::vec_t<3, wp::float32> var_338;
        wp::float32 var_339;
        wp::float32 var_340;
        wp::float32 var_341;
        wp::vec_t<3, wp::float32> var_342;
        wp::vec_t<3, wp::float32> var_343;
        wp::vec_t<3, wp::float32> var_344;
        wp::vec_t<3, wp::float32> var_345;
        wp::float32 var_346;
        wp::float32 var_347;
        wp::float32 var_348;
        wp::float32 var_349;
        wp::vec_t<3, wp::float32> var_350;
        wp::vec_t<3, wp::float32> var_351;
        wp::vec_t<3, wp::float32>* var_352;
        wp::vec_t<3, wp::float32>* var_353;
        wp::vec_t<3, wp::float32> var_354;
        wp::vec_t<3, wp::float32> var_355;
        wp::vec_t<3, wp::float32> var_356;
        wp::vec_t<3, wp::float32> var_357;
        const wp::int32 var_358 = 3;
        wp::int32 var_359;
        const wp::int32 var_360 = 3;
        wp::int32 var_361;
        wp::int32 var_362;
        wp::int32 var_363;
        const wp::int32 var_364 = 1;
        bool var_365;
        const wp::int32 var_366 = 0;
        const wp::int32 var_367 = 3;
        wp::int32 var_368;
        wp::int32 var_369;
        wp::int32 var_370;
        wp::vec_t<2, wp::uint8>* var_371;
        wp::vec_t<2, wp::int32> var_372;
        wp::vec_t<2, wp::uint8> var_373;
        const wp::int32 var_374 = 0;
        wp::int32 var_375;
        const wp::int32 var_376 = 1;
        wp::int32 var_377;
        wp::float32 var_378;
        wp::float32 var_379;
        wp::float32 var_380;
        wp::float32 var_381;
        wp::vec_t<3, wp::uint8>* var_382;
        wp::vec_t<3, wp::float32> var_383;
        wp::vec_t<3, wp::uint8> var_384;
        wp::vec_t<3, wp::uint8>* var_385;
        wp::vec_t<3, wp::float32> var_386;
        wp::vec_t<3, wp::uint8> var_387;
        wp::float32 var_388;
        wp::float32 var_389;
        bool var_390;
        const wp::float32 var_391 = 0.5;
        wp::vec_t<3, wp::float32> var_392;
        wp::vec_t<3, wp::float32> var_393;
        wp::float32 var_394;
        wp::float32 var_395;
        wp::float32 var_396;
        wp::vec_t<3, wp::float32> var_397;
        wp::vec_t<3, wp::float32> var_398;
        wp::vec_t<3, wp::float32> var_399;
        wp::vec_t<3, wp::float32> var_400;
        wp::float32 var_401;
        wp::float32 var_402;
        wp::float32 var_403;
        wp::float32 var_404;
        wp::vec_t<3, wp::float32> var_405;
        wp::vec_t<3, wp::float32> var_406;
        wp::vec_t<3, wp::float32>* var_407;
        wp::vec_t<3, wp::float32>* var_408;
        wp::vec_t<3, wp::float32> var_409;
        wp::vec_t<3, wp::float32> var_410;
        wp::vec_t<3, wp::float32> var_411;
        wp::vec_t<3, wp::float32> var_412;
        const wp::int32 var_413 = 3;
        wp::int32 var_414;
        const wp::int32 var_415 = 3;
        wp::int32 var_416;
        wp::int32 var_417;
        wp::int32 var_418;
        const wp::int32 var_419 = 1;
        const wp::int32 var_420 = 3;
        wp::int32 var_421;
        wp::int32 var_422;
        wp::int32 var_423;
        wp::vec_t<2, wp::uint8>* var_424;
        wp::vec_t<2, wp::int32> var_425;
        wp::vec_t<2, wp::uint8> var_426;
        const wp::int32 var_427 = 0;
        wp::int32 var_428;
        const wp::int32 var_429 = 1;
        wp::int32 var_430;
        wp::float32 var_431;
        wp::float32 var_432;
        wp::float32 var_433;
        wp::float32 var_434;
        wp::vec_t<3, wp::uint8>* var_435;
        wp::vec_t<3, wp::float32> var_436;
        wp::vec_t<3, wp::uint8> var_437;
        wp::vec_t<3, wp::uint8>* var_438;
        wp::vec_t<3, wp::float32> var_439;
        wp::vec_t<3, wp::uint8> var_440;
        wp::float32 var_441;
        wp::float32 var_442;
        bool var_443;
        const wp::float32 var_444 = 0.5;
        wp::vec_t<3, wp::float32> var_445;
        wp::vec_t<3, wp::float32> var_446;
        wp::float32 var_447;
        wp::float32 var_448;
        wp::float32 var_449;
        wp::vec_t<3, wp::float32> var_450;
        wp::vec_t<3, wp::float32> var_451;
        wp::vec_t<3, wp::float32> var_452;
        wp::vec_t<3, wp::float32> var_453;
        wp::float32 var_454;
        wp::float32 var_455;
        wp::float32 var_456;
        wp::float32 var_457;
        wp::vec_t<3, wp::float32> var_458;
        wp::vec_t<3, wp::float32> var_459;
        wp::vec_t<3, wp::float32>* var_460;
        wp::vec_t<3, wp::float32>* var_461;
        wp::vec_t<3, wp::float32> var_462;
        wp::vec_t<3, wp::float32> var_463;
        wp::vec_t<3, wp::float32> var_464;
        wp::vec_t<3, wp::float32> var_465;
        const wp::int32 var_466 = 3;
        wp::int32 var_467;
        const wp::int32 var_468 = 3;
        wp::int32 var_469;
        wp::int32 var_470;
        wp::int32 var_471;
        const wp::int32 var_472 = 2;
        const wp::int32 var_473 = 3;
        wp::int32 var_474;
        wp::int32 var_475;
        wp::int32 var_476;
        wp::vec_t<2, wp::uint8>* var_477;
        wp::vec_t<2, wp::int32> var_478;
        wp::vec_t<2, wp::uint8> var_479;
        const wp::int32 var_480 = 0;
        wp::int32 var_481;
        const wp::int32 var_482 = 1;
        wp::int32 var_483;
        wp::float32 var_484;
        wp::float32 var_485;
        wp::float32 var_486;
        wp::float32 var_487;
        wp::vec_t<3, wp::uint8>* var_488;
        wp::vec_t<3, wp::float32> var_489;
        wp::vec_t<3, wp::uint8> var_490;
        wp::vec_t<3, wp::uint8>* var_491;
        wp::vec_t<3, wp::float32> var_492;
        wp::vec_t<3, wp::uint8> var_493;
        wp::float32 var_494;
        wp::float32 var_495;
        bool var_496;
        const wp::float32 var_497 = 0.5;
        wp::vec_t<3, wp::float32> var_498;
        wp::vec_t<3, wp::float32> var_499;
        wp::float32 var_500;
        wp::float32 var_501;
        wp::float32 var_502;
        wp::vec_t<3, wp::float32> var_503;
        wp::vec_t<3, wp::float32> var_504;
        wp::vec_t<3, wp::float32> var_505;
        wp::vec_t<3, wp::float32> var_506;
        wp::float32 var_507;
        wp::float32 var_508;
        wp::float32 var_509;
        wp::float32 var_510;
        wp::vec_t<3, wp::float32> var_511;
        wp::vec_t<3, wp::float32> var_512;
        wp::vec_t<3, wp::float32>* var_513;
        wp::vec_t<3, wp::float32>* var_514;
        wp::vec_t<3, wp::float32> var_515;
        wp::vec_t<3, wp::float32> var_516;
        wp::vec_t<3, wp::float32> var_517;
        wp::vec_t<3, wp::float32> var_518;
        const wp::int32 var_519 = 3;
        wp::int32 var_520;
        const wp::int32 var_521 = 3;
        wp::int32 var_522;
        wp::int32 var_523;
        wp::int32 var_524;
        const wp::int32 var_525 = 2;
        bool var_526;
        const wp::int32 var_527 = 0;
        const wp::int32 var_528 = 3;
        wp::int32 var_529;
        wp::int32 var_530;
        wp::int32 var_531;
        wp::vec_t<2, wp::uint8>* var_532;
        wp::vec_t<2, wp::int32> var_533;
        wp::vec_t<2, wp::uint8> var_534;
        const wp::int32 var_535 = 0;
        wp::int32 var_536;
        const wp::int32 var_537 = 1;
        wp::int32 var_538;
        wp::float32 var_539;
        wp::float32 var_540;
        wp::float32 var_541;
        wp::float32 var_542;
        wp::vec_t<3, wp::uint8>* var_543;
        wp::vec_t<3, wp::float32> var_544;
        wp::vec_t<3, wp::uint8> var_545;
        wp::vec_t<3, wp::uint8>* var_546;
        wp::vec_t<3, wp::float32> var_547;
        wp::vec_t<3, wp::uint8> var_548;
        wp::float32 var_549;
        wp::float32 var_550;
        bool var_551;
        const wp::float32 var_552 = 0.5;
        wp::vec_t<3, wp::float32> var_553;
        wp::vec_t<3, wp::float32> var_554;
        wp::float32 var_555;
        wp::float32 var_556;
        wp::float32 var_557;
        wp::vec_t<3, wp::float32> var_558;
        wp::vec_t<3, wp::float32> var_559;
        wp::vec_t<3, wp::float32> var_560;
        wp::vec_t<3, wp::float32> var_561;
        wp::float32 var_562;
        wp::float32 var_563;
        wp::float32 var_564;
        wp::float32 var_565;
        wp::vec_t<3, wp::float32> var_566;
        wp::vec_t<3, wp::float32> var_567;
        wp::vec_t<3, wp::float32>* var_568;
        wp::vec_t<3, wp::float32>* var_569;
        wp::vec_t<3, wp::float32> var_570;
        wp::vec_t<3, wp::float32> var_571;
        wp::vec_t<3, wp::float32> var_572;
        wp::vec_t<3, wp::float32> var_573;
        const wp::int32 var_574 = 3;
        wp::int32 var_575;
        const wp::int32 var_576 = 3;
        wp::int32 var_577;
        wp::int32 var_578;
        wp::int32 var_579;
        const wp::int32 var_580 = 1;
        const wp::int32 var_581 = 3;
        wp::int32 var_582;
        wp::int32 var_583;
        wp::int32 var_584;
        wp::vec_t<2, wp::uint8>* var_585;
        wp::vec_t<2, wp::int32> var_586;
        wp::vec_t<2, wp::uint8> var_587;
        const wp::int32 var_588 = 0;
        wp::int32 var_589;
        const wp::int32 var_590 = 1;
        wp::int32 var_591;
        wp::float32 var_592;
        wp::float32 var_593;
        wp::float32 var_594;
        wp::float32 var_595;
        wp::vec_t<3, wp::uint8>* var_596;
        wp::vec_t<3, wp::float32> var_597;
        wp::vec_t<3, wp::uint8> var_598;
        wp::vec_t<3, wp::uint8>* var_599;
        wp::vec_t<3, wp::float32> var_600;
        wp::vec_t<3, wp::uint8> var_601;
        wp::float32 var_602;
        wp::float32 var_603;
        bool var_604;
        const wp::float32 var_605 = 0.5;
        wp::vec_t<3, wp::float32> var_606;
        wp::vec_t<3, wp::float32> var_607;
        wp::float32 var_608;
        wp::float32 var_609;
        wp::float32 var_610;
        wp::vec_t<3, wp::float32> var_611;
        wp::vec_t<3, wp::float32> var_612;
        wp::vec_t<3, wp::float32> var_613;
        wp::vec_t<3, wp::float32> var_614;
        wp::float32 var_615;
        wp::float32 var_616;
        wp::float32 var_617;
        wp::float32 var_618;
        wp::vec_t<3, wp::float32> var_619;
        wp::vec_t<3, wp::float32> var_620;
        wp::vec_t<3, wp::float32>* var_621;
        wp::vec_t<3, wp::float32>* var_622;
        wp::vec_t<3, wp::float32> var_623;
        wp::vec_t<3, wp::float32> var_624;
        wp::vec_t<3, wp::float32> var_625;
        wp::vec_t<3, wp::float32> var_626;
        const wp::int32 var_627 = 3;
        wp::int32 var_628;
        const wp::int32 var_629 = 3;
        wp::int32 var_630;
        wp::int32 var_631;
        wp::int32 var_632;
        const wp::int32 var_633 = 2;
        const wp::int32 var_634 = 3;
        wp::int32 var_635;
        wp::int32 var_636;
        wp::int32 var_637;
        wp::vec_t<2, wp::uint8>* var_638;
        wp::vec_t<2, wp::int32> var_639;
        wp::vec_t<2, wp::uint8> var_640;
        const wp::int32 var_641 = 0;
        wp::int32 var_642;
        const wp::int32 var_643 = 1;
        wp::int32 var_644;
        wp::float32 var_645;
        wp::float32 var_646;
        wp::float32 var_647;
        wp::float32 var_648;
        wp::vec_t<3, wp::uint8>* var_649;
        wp::vec_t<3, wp::float32> var_650;
        wp::vec_t<3, wp::uint8> var_651;
        wp::vec_t<3, wp::uint8>* var_652;
        wp::vec_t<3, wp::float32> var_653;
        wp::vec_t<3, wp::uint8> var_654;
        wp::float32 var_655;
        wp::float32 var_656;
        bool var_657;
        const wp::float32 var_658 = 0.5;
        wp::vec_t<3, wp::float32> var_659;
        wp::vec_t<3, wp::float32> var_660;
        wp::float32 var_661;
        wp::float32 var_662;
        wp::float32 var_663;
        wp::vec_t<3, wp::float32> var_664;
        wp::vec_t<3, wp::float32> var_665;
        wp::vec_t<3, wp::float32> var_666;
        wp::vec_t<3, wp::float32> var_667;
        wp::float32 var_668;
        wp::float32 var_669;
        wp::float32 var_670;
        wp::float32 var_671;
        wp::vec_t<3, wp::float32> var_672;
        wp::vec_t<3, wp::float32> var_673;
        wp::vec_t<3, wp::float32>* var_674;
        wp::vec_t<3, wp::float32>* var_675;
        wp::vec_t<3, wp::float32> var_676;
        wp::vec_t<3, wp::float32> var_677;
        wp::vec_t<3, wp::float32> var_678;
        wp::vec_t<3, wp::float32> var_679;
        const wp::int32 var_680 = 3;
        wp::int32 var_681;
        const wp::int32 var_682 = 3;
        wp::int32 var_683;
        wp::int32 var_684;
        wp::int32 var_685;
        const wp::int32 var_686 = 3;
        bool var_687;
        const wp::int32 var_688 = 0;
        const wp::int32 var_689 = 3;
        wp::int32 var_690;
        wp::int32 var_691;
        wp::int32 var_692;
        wp::vec_t<2, wp::uint8>* var_693;
        wp::vec_t<2, wp::int32> var_694;
        wp::vec_t<2, wp::uint8> var_695;
        const wp::int32 var_696 = 0;
        wp::int32 var_697;
        const wp::int32 var_698 = 1;
        wp::int32 var_699;
        wp::float32 var_700;
        wp::float32 var_701;
        wp::float32 var_702;
        wp::float32 var_703;
        wp::vec_t<3, wp::uint8>* var_704;
        wp::vec_t<3, wp::float32> var_705;
        wp::vec_t<3, wp::uint8> var_706;
        wp::vec_t<3, wp::uint8>* var_707;
        wp::vec_t<3, wp::float32> var_708;
        wp::vec_t<3, wp::uint8> var_709;
        wp::float32 var_710;
        wp::float32 var_711;
        bool var_712;
        const wp::float32 var_713 = 0.5;
        wp::vec_t<3, wp::float32> var_714;
        wp::vec_t<3, wp::float32> var_715;
        wp::float32 var_716;
        wp::float32 var_717;
        wp::float32 var_718;
        wp::vec_t<3, wp::float32> var_719;
        wp::vec_t<3, wp::float32> var_720;
        wp::vec_t<3, wp::float32> var_721;
        wp::vec_t<3, wp::float32> var_722;
        wp::float32 var_723;
        wp::float32 var_724;
        wp::float32 var_725;
        wp::float32 var_726;
        wp::vec_t<3, wp::float32> var_727;
        wp::vec_t<3, wp::float32> var_728;
        wp::vec_t<3, wp::float32>* var_729;
        wp::vec_t<3, wp::float32>* var_730;
        wp::vec_t<3, wp::float32> var_731;
        wp::vec_t<3, wp::float32> var_732;
        wp::vec_t<3, wp::float32> var_733;
        wp::vec_t<3, wp::float32> var_734;
        const wp::int32 var_735 = 3;
        wp::int32 var_736;
        const wp::int32 var_737 = 3;
        wp::int32 var_738;
        wp::int32 var_739;
        wp::int32 var_740;
        const wp::int32 var_741 = 1;
        const wp::int32 var_742 = 3;
        wp::int32 var_743;
        wp::int32 var_744;
        wp::int32 var_745;
        wp::vec_t<2, wp::uint8>* var_746;
        wp::vec_t<2, wp::int32> var_747;
        wp::vec_t<2, wp::uint8> var_748;
        const wp::int32 var_749 = 0;
        wp::int32 var_750;
        const wp::int32 var_751 = 1;
        wp::int32 var_752;
        wp::float32 var_753;
        wp::float32 var_754;
        wp::float32 var_755;
        wp::float32 var_756;
        wp::vec_t<3, wp::uint8>* var_757;
        wp::vec_t<3, wp::float32> var_758;
        wp::vec_t<3, wp::uint8> var_759;
        wp::vec_t<3, wp::uint8>* var_760;
        wp::vec_t<3, wp::float32> var_761;
        wp::vec_t<3, wp::uint8> var_762;
        wp::float32 var_763;
        wp::float32 var_764;
        bool var_765;
        const wp::float32 var_766 = 0.5;
        wp::vec_t<3, wp::float32> var_767;
        wp::vec_t<3, wp::float32> var_768;
        wp::float32 var_769;
        wp::float32 var_770;
        wp::float32 var_771;
        wp::vec_t<3, wp::float32> var_772;
        wp::vec_t<3, wp::float32> var_773;
        wp::vec_t<3, wp::float32> var_774;
        wp::vec_t<3, wp::float32> var_775;
        wp::float32 var_776;
        wp::float32 var_777;
        wp::float32 var_778;
        wp::float32 var_779;
        wp::vec_t<3, wp::float32> var_780;
        wp::vec_t<3, wp::float32> var_781;
        wp::vec_t<3, wp::float32>* var_782;
        wp::vec_t<3, wp::float32>* var_783;
        wp::vec_t<3, wp::float32> var_784;
        wp::vec_t<3, wp::float32> var_785;
        wp::vec_t<3, wp::float32> var_786;
        wp::vec_t<3, wp::float32> var_787;
        const wp::int32 var_788 = 3;
        wp::int32 var_789;
        const wp::int32 var_790 = 3;
        wp::int32 var_791;
        wp::int32 var_792;
        wp::int32 var_793;
        const wp::int32 var_794 = 2;
        const wp::int32 var_795 = 3;
        wp::int32 var_796;
        wp::int32 var_797;
        wp::int32 var_798;
        wp::vec_t<2, wp::uint8>* var_799;
        wp::vec_t<2, wp::int32> var_800;
        wp::vec_t<2, wp::uint8> var_801;
        const wp::int32 var_802 = 0;
        wp::int32 var_803;
        const wp::int32 var_804 = 1;
        wp::int32 var_805;
        wp::float32 var_806;
        wp::float32 var_807;
        wp::float32 var_808;
        wp::float32 var_809;
        wp::vec_t<3, wp::uint8>* var_810;
        wp::vec_t<3, wp::float32> var_811;
        wp::vec_t<3, wp::uint8> var_812;
        wp::vec_t<3, wp::uint8>* var_813;
        wp::vec_t<3, wp::float32> var_814;
        wp::vec_t<3, wp::uint8> var_815;
        wp::float32 var_816;
        wp::float32 var_817;
        bool var_818;
        const wp::float32 var_819 = 0.5;
        wp::vec_t<3, wp::float32> var_820;
        wp::vec_t<3, wp::float32> var_821;
        wp::float32 var_822;
        wp::float32 var_823;
        wp::float32 var_824;
        wp::vec_t<3, wp::float32> var_825;
        wp::vec_t<3, wp::float32> var_826;
        wp::vec_t<3, wp::float32> var_827;
        wp::vec_t<3, wp::float32> var_828;
        wp::float32 var_829;
        wp::float32 var_830;
        wp::float32 var_831;
        wp::float32 var_832;
        wp::vec_t<3, wp::float32> var_833;
        wp::vec_t<3, wp::float32> var_834;
        wp::vec_t<3, wp::float32>* var_835;
        wp::vec_t<3, wp::float32>* var_836;
        wp::vec_t<3, wp::float32> var_837;
        wp::vec_t<3, wp::float32> var_838;
        wp::vec_t<3, wp::float32> var_839;
        wp::vec_t<3, wp::float32> var_840;
        const wp::int32 var_841 = 3;
        wp::int32 var_842;
        const wp::int32 var_843 = 3;
        wp::int32 var_844;
        wp::int32 var_845;
        wp::int32 var_846;
        const wp::int32 var_847 = 4;
        bool var_848;
        const wp::int32 var_849 = 0;
        const wp::int32 var_850 = 3;
        wp::int32 var_851;
        wp::int32 var_852;
        wp::int32 var_853;
        wp::vec_t<2, wp::uint8>* var_854;
        wp::vec_t<2, wp::int32> var_855;
        wp::vec_t<2, wp::uint8> var_856;
        const wp::int32 var_857 = 0;
        wp::int32 var_858;
        const wp::int32 var_859 = 1;
        wp::int32 var_860;
        wp::float32 var_861;
        wp::float32 var_862;
        wp::float32 var_863;
        wp::float32 var_864;
        wp::vec_t<3, wp::uint8>* var_865;
        wp::vec_t<3, wp::float32> var_866;
        wp::vec_t<3, wp::uint8> var_867;
        wp::vec_t<3, wp::uint8>* var_868;
        wp::vec_t<3, wp::float32> var_869;
        wp::vec_t<3, wp::uint8> var_870;
        wp::float32 var_871;
        wp::float32 var_872;
        bool var_873;
        const wp::float32 var_874 = 0.5;
        wp::vec_t<3, wp::float32> var_875;
        wp::vec_t<3, wp::float32> var_876;
        wp::float32 var_877;
        wp::float32 var_878;
        wp::float32 var_879;
        wp::vec_t<3, wp::float32> var_880;
        wp::vec_t<3, wp::float32> var_881;
        wp::vec_t<3, wp::float32> var_882;
        wp::vec_t<3, wp::float32> var_883;
        wp::float32 var_884;
        wp::float32 var_885;
        wp::float32 var_886;
        wp::float32 var_887;
        wp::vec_t<3, wp::float32> var_888;
        wp::vec_t<3, wp::float32> var_889;
        wp::vec_t<3, wp::float32>* var_890;
        wp::vec_t<3, wp::float32>* var_891;
        wp::vec_t<3, wp::float32> var_892;
        wp::vec_t<3, wp::float32> var_893;
        wp::vec_t<3, wp::float32> var_894;
        wp::vec_t<3, wp::float32> var_895;
        const wp::int32 var_896 = 3;
        wp::int32 var_897;
        const wp::int32 var_898 = 3;
        wp::int32 var_899;
        wp::int32 var_900;
        wp::int32 var_901;
        const wp::int32 var_902 = 1;
        const wp::int32 var_903 = 3;
        wp::int32 var_904;
        wp::int32 var_905;
        wp::int32 var_906;
        wp::vec_t<2, wp::uint8>* var_907;
        wp::vec_t<2, wp::int32> var_908;
        wp::vec_t<2, wp::uint8> var_909;
        const wp::int32 var_910 = 0;
        wp::int32 var_911;
        const wp::int32 var_912 = 1;
        wp::int32 var_913;
        wp::float32 var_914;
        wp::float32 var_915;
        wp::float32 var_916;
        wp::float32 var_917;
        wp::vec_t<3, wp::uint8>* var_918;
        wp::vec_t<3, wp::float32> var_919;
        wp::vec_t<3, wp::uint8> var_920;
        wp::vec_t<3, wp::uint8>* var_921;
        wp::vec_t<3, wp::float32> var_922;
        wp::vec_t<3, wp::uint8> var_923;
        wp::float32 var_924;
        wp::float32 var_925;
        bool var_926;
        const wp::float32 var_927 = 0.5;
        wp::vec_t<3, wp::float32> var_928;
        wp::vec_t<3, wp::float32> var_929;
        wp::float32 var_930;
        wp::float32 var_931;
        wp::float32 var_932;
        wp::vec_t<3, wp::float32> var_933;
        wp::vec_t<3, wp::float32> var_934;
        wp::vec_t<3, wp::float32> var_935;
        wp::vec_t<3, wp::float32> var_936;
        wp::float32 var_937;
        wp::float32 var_938;
        wp::float32 var_939;
        wp::float32 var_940;
        wp::vec_t<3, wp::float32> var_941;
        wp::vec_t<3, wp::float32> var_942;
        wp::vec_t<3, wp::float32>* var_943;
        wp::vec_t<3, wp::float32>* var_944;
        wp::vec_t<3, wp::float32> var_945;
        wp::vec_t<3, wp::float32> var_946;
        wp::vec_t<3, wp::float32> var_947;
        wp::vec_t<3, wp::float32> var_948;
        const wp::int32 var_949 = 3;
        wp::int32 var_950;
        const wp::int32 var_951 = 3;
        wp::int32 var_952;
        wp::int32 var_953;
        wp::int32 var_954;
        const wp::int32 var_955 = 2;
        const wp::int32 var_956 = 3;
        wp::int32 var_957;
        wp::int32 var_958;
        wp::int32 var_959;
        wp::vec_t<2, wp::uint8>* var_960;
        wp::vec_t<2, wp::int32> var_961;
        wp::vec_t<2, wp::uint8> var_962;
        const wp::int32 var_963 = 0;
        wp::int32 var_964;
        const wp::int32 var_965 = 1;
        wp::int32 var_966;
        wp::float32 var_967;
        wp::float32 var_968;
        wp::float32 var_969;
        wp::float32 var_970;
        wp::vec_t<3, wp::uint8>* var_971;
        wp::vec_t<3, wp::float32> var_972;
        wp::vec_t<3, wp::uint8> var_973;
        wp::vec_t<3, wp::uint8>* var_974;
        wp::vec_t<3, wp::float32> var_975;
        wp::vec_t<3, wp::uint8> var_976;
        wp::float32 var_977;
        wp::float32 var_978;
        bool var_979;
        const wp::float32 var_980 = 0.5;
        wp::vec_t<3, wp::float32> var_981;
        wp::vec_t<3, wp::float32> var_982;
        wp::float32 var_983;
        wp::float32 var_984;
        wp::float32 var_985;
        wp::vec_t<3, wp::float32> var_986;
        wp::vec_t<3, wp::float32> var_987;
        wp::vec_t<3, wp::float32> var_988;
        wp::vec_t<3, wp::float32> var_989;
        wp::float32 var_990;
        wp::float32 var_991;
        wp::float32 var_992;
        wp::float32 var_993;
        wp::vec_t<3, wp::float32> var_994;
        wp::vec_t<3, wp::float32> var_995;
        wp::vec_t<3, wp::float32>* var_996;
        wp::vec_t<3, wp::float32>* var_997;
        wp::vec_t<3, wp::float32> var_998;
        wp::vec_t<3, wp::float32> var_999;
        wp::vec_t<3, wp::float32> var_1000;
        wp::vec_t<3, wp::float32> var_1001;
        const wp::int32 var_1002 = 3;
        wp::int32 var_1003;
        const wp::int32 var_1004 = 3;
        wp::int32 var_1005;
        wp::int32 var_1006;
        wp::int32 var_1007;
        //---------
        // forward
        // def _generate_isomesh_texture_kernel(                                                  <L 2972>
        // cell_idx, local_x, local_y, local_z = wp.tid()                                         <L 2983>
        builtin_tid4d(var_0, var_1, var_2, var_3);
        // sdf = sdf_array[0]                                                                     <L 2984>
        var_5 = wp::address(var_sdf_array, var_4);
        var_7 = wp::load(var_5);
        var_6 = wp::copy(var_7);
        // coarse = active_coarse_cells[cell_idx]                                                 <L 2985>
        var_8 = wp::address(var_active_coarse_cells, var_0);
        var_10 = wp::load(var_8);
        var_9 = wp::copy(var_10);
        // x_id = coarse[0] * subgrid_size + local_x                                              <L 2986>
        var_12 = wp::extract(var_9, var_11);
        var_13 = wp::mul(var_12, var_subgrid_size);
        var_14 = wp::add(var_13, var_1);
        // y_id = coarse[1] * subgrid_size + local_y                                              <L 2987>
        var_16 = wp::extract(var_9, var_15);
        var_17 = wp::mul(var_16, var_subgrid_size);
        var_18 = wp::add(var_17, var_2);
        // z_id = coarse[2] * subgrid_size + local_z                                              <L 2988>
        var_20 = wp::extract(var_9, var_19);
        var_21 = wp::mul(var_20, var_subgrid_size);
        var_22 = wp::add(var_21, var_3);
        // cube_idx = wp.int32(0)                                                                 <L 2990>
        var_24 = wp::int32(var_23);
        // corner_vals = vec8f()                                                                  <L 2991>
        var_25 = wp::vec_t<8, wp::float32>();
        // for i in range(8):                                                                     <L 2992>
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 2993>
        var_27 = wp::address(var_corner_offsets_table, var_26);
        var_29 = wp::load(var_27);
        var_28 = wp::vec_t<3, wp::int32>(var_29);
        // v = texture_sample_sdf_at_voxel(sdf, x_id + co.x, y_id + co.y, z_id + co.z)            <L 2994>
        var_31 = wp::extract(var_28, var_30);
        var_32 = wp::add(var_14, var_31);
        var_34 = wp::extract(var_28, var_33);
        var_35 = wp::add(var_18, var_34);
        var_37 = wp::extract(var_28, var_36);
        var_38 = wp::add(var_22, var_37);
        var_39 = texture_sample_sdf_at_voxel_0(var_6, var_32, var_35, var_38);
        // if wp.isnan(v):                                                                        <L 2995>
        var_40 = wp::isnan(var_39);
        if (var_40) {
            // return                                                                             <L 2996>
            continue;
        }
        // corner_vals[i] = v                                                                     <L 2997>
        wp::assign_inplace(var_25, var_26, var_39);
        // if v < isovalue:                                                                       <L 2998>
        var_41 = (var_39 < var_isovalue);
        if (var_41) {
            // cube_idx |= 1 << i                                                                 <L 2999>
            var_43 = wp::lshift(var_42, var_26);
            var_44 = wp::bit_or(var_24, var_43);
        }
        var_45 = wp::where(var_41, var_44, var_24);
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 2993>
        var_47 = wp::address(var_corner_offsets_table, var_46);
        var_49 = wp::load(var_47);
        var_48 = wp::vec_t<3, wp::int32>(var_49);
        // v = texture_sample_sdf_at_voxel(sdf, x_id + co.x, y_id + co.y, z_id + co.z)            <L 2994>
        var_51 = wp::extract(var_48, var_50);
        var_52 = wp::add(var_14, var_51);
        var_54 = wp::extract(var_48, var_53);
        var_55 = wp::add(var_18, var_54);
        var_57 = wp::extract(var_48, var_56);
        var_58 = wp::add(var_22, var_57);
        var_59 = texture_sample_sdf_at_voxel_0(var_6, var_52, var_55, var_58);
        // if wp.isnan(v):                                                                        <L 2995>
        var_60 = wp::isnan(var_59);
        if (var_60) {
            // return                                                                             <L 2996>
            continue;
        }
        // corner_vals[i] = v                                                                     <L 2997>
        wp::assign_inplace(var_25, var_46, var_59);
        // if v < isovalue:                                                                       <L 2998>
        var_61 = (var_59 < var_isovalue);
        if (var_61) {
            // cube_idx |= 1 << i                                                                 <L 2999>
            var_63 = wp::lshift(var_62, var_46);
            var_64 = wp::bit_or(var_45, var_63);
        }
        var_65 = wp::where(var_61, var_64, var_45);
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 2993>
        var_67 = wp::address(var_corner_offsets_table, var_66);
        var_69 = wp::load(var_67);
        var_68 = wp::vec_t<3, wp::int32>(var_69);
        // v = texture_sample_sdf_at_voxel(sdf, x_id + co.x, y_id + co.y, z_id + co.z)            <L 2994>
        var_71 = wp::extract(var_68, var_70);
        var_72 = wp::add(var_14, var_71);
        var_74 = wp::extract(var_68, var_73);
        var_75 = wp::add(var_18, var_74);
        var_77 = wp::extract(var_68, var_76);
        var_78 = wp::add(var_22, var_77);
        var_79 = texture_sample_sdf_at_voxel_0(var_6, var_72, var_75, var_78);
        // if wp.isnan(v):                                                                        <L 2995>
        var_80 = wp::isnan(var_79);
        if (var_80) {
            // return                                                                             <L 2996>
            continue;
        }
        // corner_vals[i] = v                                                                     <L 2997>
        wp::assign_inplace(var_25, var_66, var_79);
        // if v < isovalue:                                                                       <L 2998>
        var_81 = (var_79 < var_isovalue);
        if (var_81) {
            // cube_idx |= 1 << i                                                                 <L 2999>
            var_83 = wp::lshift(var_82, var_66);
            var_84 = wp::bit_or(var_65, var_83);
        }
        var_85 = wp::where(var_81, var_84, var_65);
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 2993>
        var_87 = wp::address(var_corner_offsets_table, var_86);
        var_89 = wp::load(var_87);
        var_88 = wp::vec_t<3, wp::int32>(var_89);
        // v = texture_sample_sdf_at_voxel(sdf, x_id + co.x, y_id + co.y, z_id + co.z)            <L 2994>
        var_91 = wp::extract(var_88, var_90);
        var_92 = wp::add(var_14, var_91);
        var_94 = wp::extract(var_88, var_93);
        var_95 = wp::add(var_18, var_94);
        var_97 = wp::extract(var_88, var_96);
        var_98 = wp::add(var_22, var_97);
        var_99 = texture_sample_sdf_at_voxel_0(var_6, var_92, var_95, var_98);
        // if wp.isnan(v):                                                                        <L 2995>
        var_100 = wp::isnan(var_99);
        if (var_100) {
            // return                                                                             <L 2996>
            continue;
        }
        // corner_vals[i] = v                                                                     <L 2997>
        wp::assign_inplace(var_25, var_86, var_99);
        // if v < isovalue:                                                                       <L 2998>
        var_101 = (var_99 < var_isovalue);
        if (var_101) {
            // cube_idx |= 1 << i                                                                 <L 2999>
            var_103 = wp::lshift(var_102, var_86);
            var_104 = wp::bit_or(var_85, var_103);
        }
        var_105 = wp::where(var_101, var_104, var_85);
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 2993>
        var_107 = wp::address(var_corner_offsets_table, var_106);
        var_109 = wp::load(var_107);
        var_108 = wp::vec_t<3, wp::int32>(var_109);
        // v = texture_sample_sdf_at_voxel(sdf, x_id + co.x, y_id + co.y, z_id + co.z)            <L 2994>
        var_111 = wp::extract(var_108, var_110);
        var_112 = wp::add(var_14, var_111);
        var_114 = wp::extract(var_108, var_113);
        var_115 = wp::add(var_18, var_114);
        var_117 = wp::extract(var_108, var_116);
        var_118 = wp::add(var_22, var_117);
        var_119 = texture_sample_sdf_at_voxel_0(var_6, var_112, var_115, var_118);
        // if wp.isnan(v):                                                                        <L 2995>
        var_120 = wp::isnan(var_119);
        if (var_120) {
            // return                                                                             <L 2996>
            continue;
        }
        // corner_vals[i] = v                                                                     <L 2997>
        wp::assign_inplace(var_25, var_106, var_119);
        // if v < isovalue:                                                                       <L 2998>
        var_121 = (var_119 < var_isovalue);
        if (var_121) {
            // cube_idx |= 1 << i                                                                 <L 2999>
            var_123 = wp::lshift(var_122, var_106);
            var_124 = wp::bit_or(var_105, var_123);
        }
        var_125 = wp::where(var_121, var_124, var_105);
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 2993>
        var_127 = wp::address(var_corner_offsets_table, var_126);
        var_129 = wp::load(var_127);
        var_128 = wp::vec_t<3, wp::int32>(var_129);
        // v = texture_sample_sdf_at_voxel(sdf, x_id + co.x, y_id + co.y, z_id + co.z)            <L 2994>
        var_131 = wp::extract(var_128, var_130);
        var_132 = wp::add(var_14, var_131);
        var_134 = wp::extract(var_128, var_133);
        var_135 = wp::add(var_18, var_134);
        var_137 = wp::extract(var_128, var_136);
        var_138 = wp::add(var_22, var_137);
        var_139 = texture_sample_sdf_at_voxel_0(var_6, var_132, var_135, var_138);
        // if wp.isnan(v):                                                                        <L 2995>
        var_140 = wp::isnan(var_139);
        if (var_140) {
            // return                                                                             <L 2996>
            continue;
        }
        // corner_vals[i] = v                                                                     <L 2997>
        wp::assign_inplace(var_25, var_126, var_139);
        // if v < isovalue:                                                                       <L 2998>
        var_141 = (var_139 < var_isovalue);
        if (var_141) {
            // cube_idx |= 1 << i                                                                 <L 2999>
            var_143 = wp::lshift(var_142, var_126);
            var_144 = wp::bit_or(var_125, var_143);
        }
        var_145 = wp::where(var_141, var_144, var_125);
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 2993>
        var_147 = wp::address(var_corner_offsets_table, var_146);
        var_149 = wp::load(var_147);
        var_148 = wp::vec_t<3, wp::int32>(var_149);
        // v = texture_sample_sdf_at_voxel(sdf, x_id + co.x, y_id + co.y, z_id + co.z)            <L 2994>
        var_151 = wp::extract(var_148, var_150);
        var_152 = wp::add(var_14, var_151);
        var_154 = wp::extract(var_148, var_153);
        var_155 = wp::add(var_18, var_154);
        var_157 = wp::extract(var_148, var_156);
        var_158 = wp::add(var_22, var_157);
        var_159 = texture_sample_sdf_at_voxel_0(var_6, var_152, var_155, var_158);
        // if wp.isnan(v):                                                                        <L 2995>
        var_160 = wp::isnan(var_159);
        if (var_160) {
            // return                                                                             <L 2996>
            continue;
        }
        // corner_vals[i] = v                                                                     <L 2997>
        wp::assign_inplace(var_25, var_146, var_159);
        // if v < isovalue:                                                                       <L 2998>
        var_161 = (var_159 < var_isovalue);
        if (var_161) {
            // cube_idx |= 1 << i                                                                 <L 2999>
            var_163 = wp::lshift(var_162, var_146);
            var_164 = wp::bit_or(var_145, var_163);
        }
        var_165 = wp::where(var_161, var_164, var_145);
        // co = wp.vec3i(corner_offsets_table[i])                                                 <L 2993>
        var_167 = wp::address(var_corner_offsets_table, var_166);
        var_169 = wp::load(var_167);
        var_168 = wp::vec_t<3, wp::int32>(var_169);
        // v = texture_sample_sdf_at_voxel(sdf, x_id + co.x, y_id + co.y, z_id + co.z)            <L 2994>
        var_171 = wp::extract(var_168, var_170);
        var_172 = wp::add(var_14, var_171);
        var_174 = wp::extract(var_168, var_173);
        var_175 = wp::add(var_18, var_174);
        var_177 = wp::extract(var_168, var_176);
        var_178 = wp::add(var_22, var_177);
        var_179 = texture_sample_sdf_at_voxel_0(var_6, var_172, var_175, var_178);
        // if wp.isnan(v):                                                                        <L 2995>
        var_180 = wp::isnan(var_179);
        if (var_180) {
            // return                                                                             <L 2996>
            continue;
        }
        // corner_vals[i] = v                                                                     <L 2997>
        wp::assign_inplace(var_25, var_166, var_179);
        // if v < isovalue:                                                                       <L 2998>
        var_181 = (var_179 < var_isovalue);
        if (var_181) {
            // cube_idx |= 1 << i                                                                 <L 2999>
            var_183 = wp::lshift(var_182, var_166);
            var_184 = wp::bit_or(var_165, var_183);
        }
        var_185 = wp::where(var_181, var_184, var_165);
        // tri_start = tri_range_table[cube_idx]                                                  <L 3001>
        var_186 = wp::address(var_tri_range_table, var_185);
        var_188 = wp::load(var_186);
        var_187 = wp::copy(var_188);
        // tri_end = tri_range_table[cube_idx + 1]                                                <L 3002>
        var_190 = wp::add(var_185, var_189);
        var_191 = wp::address(var_tri_range_table, var_190);
        var_193 = wp::load(var_191);
        var_192 = wp::copy(var_193);
        // num_verts = tri_end - tri_start                                                        <L 3003>
        var_194 = wp::sub(var_192, var_187);
        // num_faces = num_verts // 3                                                             <L 3004>
        var_196 = wp::floordiv(var_194, var_195);
        // if num_faces == 0:                                                                     <L 3005>
        var_198 = (var_196 == var_197);
        if (var_198) {
            // return                                                                             <L 3006>
            continue;
        }
        // out_idx = wp.atomic_add(face_count, 0, num_faces)                                      <L 3008>
        var_200 = wp::atomic_add(var_face_count, var_199, var_196);
        // for fi in range(5):                                                                    <L 3010>
        // if fi >= num_faces:                                                                    <L 3011>
        var_202 = (var_201 >= var_196);
        if (var_202) {
            // return                                                                             <L 3012>
            continue;
        }
        // for vi in range(3):                                                                    <L 3013>
        // edge_verts = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                  <L 3014>
        var_205 = wp::mul(var_204, var_201);
        var_206 = wp::add(var_187, var_205);
        var_207 = wp::add(var_206, var_203);
        var_208 = wp::address(var_flat_edge_verts_table, var_207);
        var_210 = wp::load(var_208);
        var_209 = wp::vec_t<2, wp::int32>(var_210);
        // v_from = edge_verts[0]                                                                 <L 3015>
        var_212 = wp::extract(var_209, var_211);
        // v_to = edge_verts[1]                                                                   <L 3016>
        var_214 = wp::extract(var_209, var_213);
        // val_0 = wp.float32(corner_vals[v_from])                                                <L 3017>
        var_215 = wp::extract(var_25, var_212);
        var_216 = wp::float32(var_215);
        // val_1 = wp.float32(corner_vals[v_to])                                                  <L 3018>
        var_217 = wp::extract(var_25, var_214);
        var_218 = wp::float32(var_217);
        // p_0 = wp.vec3f(corner_offsets_table[v_from])                                           <L 3019>
        var_219 = wp::address(var_corner_offsets_table, var_212);
        var_221 = wp::load(var_219);
        var_220 = wp::vec_t<3, wp::float32>(var_221);
        // p_1 = wp.vec3f(corner_offsets_table[v_to])                                             <L 3020>
        var_222 = wp::address(var_corner_offsets_table, var_214);
        var_224 = wp::load(var_222);
        var_223 = wp::vec_t<3, wp::float32>(var_224);
        // val_diff = val_1 - val_0                                                               <L 3021>
        var_225 = wp::sub(var_218, var_216);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 3022>
        var_226 = wp::abs(var_225);
        var_228 = (var_226 < var_227);
        if (var_228) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 3023>
            var_230 = wp::add(var_220, var_223);
            var_231 = wp::mul(var_229, var_230);
        }
        if (!var_228) {
            // t = wp.clamp((isovalue - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 3025>
            var_232 = wp::sub(var_isovalue, var_216);
            var_233 = wp::div(var_232, var_225);
            var_236 = wp::clamp(var_233, var_234, var_235);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 3026>
            var_237 = wp::sub(var_223, var_220);
            var_238 = wp::mul(var_236, var_237);
            var_239 = wp::add(var_220, var_238);
        }
        var_240 = wp::where(var_228, var_231, var_239);
        // vol_idx = p + wp.vec3(float(x_id), float(y_id), float(z_id))                           <L 3027>
        var_241 = wp::float(var_14);
        var_242 = wp::float(var_18);
        var_243 = wp::float(var_22);
        var_244 = wp::vec_t<3, wp::float32>(var_241, var_242, var_243);
        var_245 = wp::add(var_240, var_244);
        // local_pos = sdf.sdf_box_lower + wp.cw_mul(vol_idx, sdf.voxel_size)                     <L 3028>
        var_246 = &((var_6).sdf_box_lower);
        var_247 = &((var_6).voxel_size);
        var_249 = wp::load(var_247);
        var_248 = wp::cw_mul(var_245, var_249);
        var_251 = wp::load(var_246);
        var_250 = wp::add(var_251, var_248);
        // vertices[3 * out_idx + 3 * fi + vi] = local_pos                                        <L 3029>
        var_253 = wp::mul(var_252, var_200);
        var_255 = wp::mul(var_254, var_201);
        var_256 = wp::add(var_253, var_255);
        var_257 = wp::add(var_256, var_203);
        wp::array_store(var_vertices, var_257, var_250);
        // edge_verts = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                  <L 3014>
        var_260 = wp::mul(var_259, var_201);
        var_261 = wp::add(var_187, var_260);
        var_262 = wp::add(var_261, var_258);
        var_263 = wp::address(var_flat_edge_verts_table, var_262);
        var_265 = wp::load(var_263);
        var_264 = wp::vec_t<2, wp::int32>(var_265);
        // v_from = edge_verts[0]                                                                 <L 3015>
        var_267 = wp::extract(var_264, var_266);
        // v_to = edge_verts[1]                                                                   <L 3016>
        var_269 = wp::extract(var_264, var_268);
        // val_0 = wp.float32(corner_vals[v_from])                                                <L 3017>
        var_270 = wp::extract(var_25, var_267);
        var_271 = wp::float32(var_270);
        // val_1 = wp.float32(corner_vals[v_to])                                                  <L 3018>
        var_272 = wp::extract(var_25, var_269);
        var_273 = wp::float32(var_272);
        // p_0 = wp.vec3f(corner_offsets_table[v_from])                                           <L 3019>
        var_274 = wp::address(var_corner_offsets_table, var_267);
        var_276 = wp::load(var_274);
        var_275 = wp::vec_t<3, wp::float32>(var_276);
        // p_1 = wp.vec3f(corner_offsets_table[v_to])                                             <L 3020>
        var_277 = wp::address(var_corner_offsets_table, var_269);
        var_279 = wp::load(var_277);
        var_278 = wp::vec_t<3, wp::float32>(var_279);
        // val_diff = val_1 - val_0                                                               <L 3021>
        var_280 = wp::sub(var_273, var_271);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 3022>
        var_281 = wp::abs(var_280);
        var_282 = (var_281 < var_227);
        if (var_282) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 3023>
            var_284 = wp::add(var_275, var_278);
            var_285 = wp::mul(var_283, var_284);
        }
        if (!var_282) {
            // t = wp.clamp((isovalue - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 3025>
            var_286 = wp::sub(var_isovalue, var_271);
            var_287 = wp::div(var_286, var_280);
            var_288 = wp::clamp(var_287, var_234, var_235);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 3026>
            var_289 = wp::sub(var_278, var_275);
            var_290 = wp::mul(var_288, var_289);
            var_291 = wp::add(var_275, var_290);
        }
        var_292 = wp::where(var_282, var_285, var_291);
        var_293 = wp::where(var_282, var_236, var_288);
        // vol_idx = p + wp.vec3(float(x_id), float(y_id), float(z_id))                           <L 3027>
        var_294 = wp::float(var_14);
        var_295 = wp::float(var_18);
        var_296 = wp::float(var_22);
        var_297 = wp::vec_t<3, wp::float32>(var_294, var_295, var_296);
        var_298 = wp::add(var_292, var_297);
        // local_pos = sdf.sdf_box_lower + wp.cw_mul(vol_idx, sdf.voxel_size)                     <L 3028>
        var_299 = &((var_6).sdf_box_lower);
        var_300 = &((var_6).voxel_size);
        var_302 = wp::load(var_300);
        var_301 = wp::cw_mul(var_298, var_302);
        var_304 = wp::load(var_299);
        var_303 = wp::add(var_304, var_301);
        // vertices[3 * out_idx + 3 * fi + vi] = local_pos                                        <L 3029>
        var_306 = wp::mul(var_305, var_200);
        var_308 = wp::mul(var_307, var_201);
        var_309 = wp::add(var_306, var_308);
        var_310 = wp::add(var_309, var_258);
        wp::array_store(var_vertices, var_310, var_303);
        // edge_verts = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                  <L 3014>
        var_313 = wp::mul(var_312, var_201);
        var_314 = wp::add(var_187, var_313);
        var_315 = wp::add(var_314, var_311);
        var_316 = wp::address(var_flat_edge_verts_table, var_315);
        var_318 = wp::load(var_316);
        var_317 = wp::vec_t<2, wp::int32>(var_318);
        // v_from = edge_verts[0]                                                                 <L 3015>
        var_320 = wp::extract(var_317, var_319);
        // v_to = edge_verts[1]                                                                   <L 3016>
        var_322 = wp::extract(var_317, var_321);
        // val_0 = wp.float32(corner_vals[v_from])                                                <L 3017>
        var_323 = wp::extract(var_25, var_320);
        var_324 = wp::float32(var_323);
        // val_1 = wp.float32(corner_vals[v_to])                                                  <L 3018>
        var_325 = wp::extract(var_25, var_322);
        var_326 = wp::float32(var_325);
        // p_0 = wp.vec3f(corner_offsets_table[v_from])                                           <L 3019>
        var_327 = wp::address(var_corner_offsets_table, var_320);
        var_329 = wp::load(var_327);
        var_328 = wp::vec_t<3, wp::float32>(var_329);
        // p_1 = wp.vec3f(corner_offsets_table[v_to])                                             <L 3020>
        var_330 = wp::address(var_corner_offsets_table, var_322);
        var_332 = wp::load(var_330);
        var_331 = wp::vec_t<3, wp::float32>(var_332);
        // val_diff = val_1 - val_0                                                               <L 3021>
        var_333 = wp::sub(var_326, var_324);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 3022>
        var_334 = wp::abs(var_333);
        var_335 = (var_334 < var_227);
        if (var_335) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 3023>
            var_337 = wp::add(var_328, var_331);
            var_338 = wp::mul(var_336, var_337);
        }
        if (!var_335) {
            // t = wp.clamp((isovalue - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 3025>
            var_339 = wp::sub(var_isovalue, var_324);
            var_340 = wp::div(var_339, var_333);
            var_341 = wp::clamp(var_340, var_234, var_235);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 3026>
            var_342 = wp::sub(var_331, var_328);
            var_343 = wp::mul(var_341, var_342);
            var_344 = wp::add(var_328, var_343);
        }
        var_345 = wp::where(var_335, var_338, var_344);
        var_346 = wp::where(var_335, var_293, var_341);
        // vol_idx = p + wp.vec3(float(x_id), float(y_id), float(z_id))                           <L 3027>
        var_347 = wp::float(var_14);
        var_348 = wp::float(var_18);
        var_349 = wp::float(var_22);
        var_350 = wp::vec_t<3, wp::float32>(var_347, var_348, var_349);
        var_351 = wp::add(var_345, var_350);
        // local_pos = sdf.sdf_box_lower + wp.cw_mul(vol_idx, sdf.voxel_size)                     <L 3028>
        var_352 = &((var_6).sdf_box_lower);
        var_353 = &((var_6).voxel_size);
        var_355 = wp::load(var_353);
        var_354 = wp::cw_mul(var_351, var_355);
        var_357 = wp::load(var_352);
        var_356 = wp::add(var_357, var_354);
        // vertices[3 * out_idx + 3 * fi + vi] = local_pos                                        <L 3029>
        var_359 = wp::mul(var_358, var_200);
        var_361 = wp::mul(var_360, var_201);
        var_362 = wp::add(var_359, var_361);
        var_363 = wp::add(var_362, var_311);
        wp::array_store(var_vertices, var_363, var_356);
        // if fi >= num_faces:                                                                    <L 3011>
        var_365 = (var_364 >= var_196);
        if (var_365) {
            // return                                                                             <L 3012>
            continue;
        }
        // for vi in range(3):                                                                    <L 3013>
        // edge_verts = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                  <L 3014>
        var_368 = wp::mul(var_367, var_364);
        var_369 = wp::add(var_187, var_368);
        var_370 = wp::add(var_369, var_366);
        var_371 = wp::address(var_flat_edge_verts_table, var_370);
        var_373 = wp::load(var_371);
        var_372 = wp::vec_t<2, wp::int32>(var_373);
        // v_from = edge_verts[0]                                                                 <L 3015>
        var_375 = wp::extract(var_372, var_374);
        // v_to = edge_verts[1]                                                                   <L 3016>
        var_377 = wp::extract(var_372, var_376);
        // val_0 = wp.float32(corner_vals[v_from])                                                <L 3017>
        var_378 = wp::extract(var_25, var_375);
        var_379 = wp::float32(var_378);
        // val_1 = wp.float32(corner_vals[v_to])                                                  <L 3018>
        var_380 = wp::extract(var_25, var_377);
        var_381 = wp::float32(var_380);
        // p_0 = wp.vec3f(corner_offsets_table[v_from])                                           <L 3019>
        var_382 = wp::address(var_corner_offsets_table, var_375);
        var_384 = wp::load(var_382);
        var_383 = wp::vec_t<3, wp::float32>(var_384);
        // p_1 = wp.vec3f(corner_offsets_table[v_to])                                             <L 3020>
        var_385 = wp::address(var_corner_offsets_table, var_377);
        var_387 = wp::load(var_385);
        var_386 = wp::vec_t<3, wp::float32>(var_387);
        // val_diff = val_1 - val_0                                                               <L 3021>
        var_388 = wp::sub(var_381, var_379);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 3022>
        var_389 = wp::abs(var_388);
        var_390 = (var_389 < var_227);
        if (var_390) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 3023>
            var_392 = wp::add(var_383, var_386);
            var_393 = wp::mul(var_391, var_392);
        }
        if (!var_390) {
            // t = wp.clamp((isovalue - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 3025>
            var_394 = wp::sub(var_isovalue, var_379);
            var_395 = wp::div(var_394, var_388);
            var_396 = wp::clamp(var_395, var_234, var_235);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 3026>
            var_397 = wp::sub(var_386, var_383);
            var_398 = wp::mul(var_396, var_397);
            var_399 = wp::add(var_383, var_398);
        }
        var_400 = wp::where(var_390, var_393, var_399);
        var_401 = wp::where(var_390, var_346, var_396);
        // vol_idx = p + wp.vec3(float(x_id), float(y_id), float(z_id))                           <L 3027>
        var_402 = wp::float(var_14);
        var_403 = wp::float(var_18);
        var_404 = wp::float(var_22);
        var_405 = wp::vec_t<3, wp::float32>(var_402, var_403, var_404);
        var_406 = wp::add(var_400, var_405);
        // local_pos = sdf.sdf_box_lower + wp.cw_mul(vol_idx, sdf.voxel_size)                     <L 3028>
        var_407 = &((var_6).sdf_box_lower);
        var_408 = &((var_6).voxel_size);
        var_410 = wp::load(var_408);
        var_409 = wp::cw_mul(var_406, var_410);
        var_412 = wp::load(var_407);
        var_411 = wp::add(var_412, var_409);
        // vertices[3 * out_idx + 3 * fi + vi] = local_pos                                        <L 3029>
        var_414 = wp::mul(var_413, var_200);
        var_416 = wp::mul(var_415, var_364);
        var_417 = wp::add(var_414, var_416);
        var_418 = wp::add(var_417, var_366);
        wp::array_store(var_vertices, var_418, var_411);
        // edge_verts = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                  <L 3014>
        var_421 = wp::mul(var_420, var_364);
        var_422 = wp::add(var_187, var_421);
        var_423 = wp::add(var_422, var_419);
        var_424 = wp::address(var_flat_edge_verts_table, var_423);
        var_426 = wp::load(var_424);
        var_425 = wp::vec_t<2, wp::int32>(var_426);
        // v_from = edge_verts[0]                                                                 <L 3015>
        var_428 = wp::extract(var_425, var_427);
        // v_to = edge_verts[1]                                                                   <L 3016>
        var_430 = wp::extract(var_425, var_429);
        // val_0 = wp.float32(corner_vals[v_from])                                                <L 3017>
        var_431 = wp::extract(var_25, var_428);
        var_432 = wp::float32(var_431);
        // val_1 = wp.float32(corner_vals[v_to])                                                  <L 3018>
        var_433 = wp::extract(var_25, var_430);
        var_434 = wp::float32(var_433);
        // p_0 = wp.vec3f(corner_offsets_table[v_from])                                           <L 3019>
        var_435 = wp::address(var_corner_offsets_table, var_428);
        var_437 = wp::load(var_435);
        var_436 = wp::vec_t<3, wp::float32>(var_437);
        // p_1 = wp.vec3f(corner_offsets_table[v_to])                                             <L 3020>
        var_438 = wp::address(var_corner_offsets_table, var_430);
        var_440 = wp::load(var_438);
        var_439 = wp::vec_t<3, wp::float32>(var_440);
        // val_diff = val_1 - val_0                                                               <L 3021>
        var_441 = wp::sub(var_434, var_432);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 3022>
        var_442 = wp::abs(var_441);
        var_443 = (var_442 < var_227);
        if (var_443) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 3023>
            var_445 = wp::add(var_436, var_439);
            var_446 = wp::mul(var_444, var_445);
        }
        if (!var_443) {
            // t = wp.clamp((isovalue - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 3025>
            var_447 = wp::sub(var_isovalue, var_432);
            var_448 = wp::div(var_447, var_441);
            var_449 = wp::clamp(var_448, var_234, var_235);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 3026>
            var_450 = wp::sub(var_439, var_436);
            var_451 = wp::mul(var_449, var_450);
            var_452 = wp::add(var_436, var_451);
        }
        var_453 = wp::where(var_443, var_446, var_452);
        var_454 = wp::where(var_443, var_401, var_449);
        // vol_idx = p + wp.vec3(float(x_id), float(y_id), float(z_id))                           <L 3027>
        var_455 = wp::float(var_14);
        var_456 = wp::float(var_18);
        var_457 = wp::float(var_22);
        var_458 = wp::vec_t<3, wp::float32>(var_455, var_456, var_457);
        var_459 = wp::add(var_453, var_458);
        // local_pos = sdf.sdf_box_lower + wp.cw_mul(vol_idx, sdf.voxel_size)                     <L 3028>
        var_460 = &((var_6).sdf_box_lower);
        var_461 = &((var_6).voxel_size);
        var_463 = wp::load(var_461);
        var_462 = wp::cw_mul(var_459, var_463);
        var_465 = wp::load(var_460);
        var_464 = wp::add(var_465, var_462);
        // vertices[3 * out_idx + 3 * fi + vi] = local_pos                                        <L 3029>
        var_467 = wp::mul(var_466, var_200);
        var_469 = wp::mul(var_468, var_364);
        var_470 = wp::add(var_467, var_469);
        var_471 = wp::add(var_470, var_419);
        wp::array_store(var_vertices, var_471, var_464);
        // edge_verts = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                  <L 3014>
        var_474 = wp::mul(var_473, var_364);
        var_475 = wp::add(var_187, var_474);
        var_476 = wp::add(var_475, var_472);
        var_477 = wp::address(var_flat_edge_verts_table, var_476);
        var_479 = wp::load(var_477);
        var_478 = wp::vec_t<2, wp::int32>(var_479);
        // v_from = edge_verts[0]                                                                 <L 3015>
        var_481 = wp::extract(var_478, var_480);
        // v_to = edge_verts[1]                                                                   <L 3016>
        var_483 = wp::extract(var_478, var_482);
        // val_0 = wp.float32(corner_vals[v_from])                                                <L 3017>
        var_484 = wp::extract(var_25, var_481);
        var_485 = wp::float32(var_484);
        // val_1 = wp.float32(corner_vals[v_to])                                                  <L 3018>
        var_486 = wp::extract(var_25, var_483);
        var_487 = wp::float32(var_486);
        // p_0 = wp.vec3f(corner_offsets_table[v_from])                                           <L 3019>
        var_488 = wp::address(var_corner_offsets_table, var_481);
        var_490 = wp::load(var_488);
        var_489 = wp::vec_t<3, wp::float32>(var_490);
        // p_1 = wp.vec3f(corner_offsets_table[v_to])                                             <L 3020>
        var_491 = wp::address(var_corner_offsets_table, var_483);
        var_493 = wp::load(var_491);
        var_492 = wp::vec_t<3, wp::float32>(var_493);
        // val_diff = val_1 - val_0                                                               <L 3021>
        var_494 = wp::sub(var_487, var_485);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 3022>
        var_495 = wp::abs(var_494);
        var_496 = (var_495 < var_227);
        if (var_496) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 3023>
            var_498 = wp::add(var_489, var_492);
            var_499 = wp::mul(var_497, var_498);
        }
        if (!var_496) {
            // t = wp.clamp((isovalue - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 3025>
            var_500 = wp::sub(var_isovalue, var_485);
            var_501 = wp::div(var_500, var_494);
            var_502 = wp::clamp(var_501, var_234, var_235);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 3026>
            var_503 = wp::sub(var_492, var_489);
            var_504 = wp::mul(var_502, var_503);
            var_505 = wp::add(var_489, var_504);
        }
        var_506 = wp::where(var_496, var_499, var_505);
        var_507 = wp::where(var_496, var_454, var_502);
        // vol_idx = p + wp.vec3(float(x_id), float(y_id), float(z_id))                           <L 3027>
        var_508 = wp::float(var_14);
        var_509 = wp::float(var_18);
        var_510 = wp::float(var_22);
        var_511 = wp::vec_t<3, wp::float32>(var_508, var_509, var_510);
        var_512 = wp::add(var_506, var_511);
        // local_pos = sdf.sdf_box_lower + wp.cw_mul(vol_idx, sdf.voxel_size)                     <L 3028>
        var_513 = &((var_6).sdf_box_lower);
        var_514 = &((var_6).voxel_size);
        var_516 = wp::load(var_514);
        var_515 = wp::cw_mul(var_512, var_516);
        var_518 = wp::load(var_513);
        var_517 = wp::add(var_518, var_515);
        // vertices[3 * out_idx + 3 * fi + vi] = local_pos                                        <L 3029>
        var_520 = wp::mul(var_519, var_200);
        var_522 = wp::mul(var_521, var_364);
        var_523 = wp::add(var_520, var_522);
        var_524 = wp::add(var_523, var_472);
        wp::array_store(var_vertices, var_524, var_517);
        // if fi >= num_faces:                                                                    <L 3011>
        var_526 = (var_525 >= var_196);
        if (var_526) {
            // return                                                                             <L 3012>
            continue;
        }
        // for vi in range(3):                                                                    <L 3013>
        // edge_verts = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                  <L 3014>
        var_529 = wp::mul(var_528, var_525);
        var_530 = wp::add(var_187, var_529);
        var_531 = wp::add(var_530, var_527);
        var_532 = wp::address(var_flat_edge_verts_table, var_531);
        var_534 = wp::load(var_532);
        var_533 = wp::vec_t<2, wp::int32>(var_534);
        // v_from = edge_verts[0]                                                                 <L 3015>
        var_536 = wp::extract(var_533, var_535);
        // v_to = edge_verts[1]                                                                   <L 3016>
        var_538 = wp::extract(var_533, var_537);
        // val_0 = wp.float32(corner_vals[v_from])                                                <L 3017>
        var_539 = wp::extract(var_25, var_536);
        var_540 = wp::float32(var_539);
        // val_1 = wp.float32(corner_vals[v_to])                                                  <L 3018>
        var_541 = wp::extract(var_25, var_538);
        var_542 = wp::float32(var_541);
        // p_0 = wp.vec3f(corner_offsets_table[v_from])                                           <L 3019>
        var_543 = wp::address(var_corner_offsets_table, var_536);
        var_545 = wp::load(var_543);
        var_544 = wp::vec_t<3, wp::float32>(var_545);
        // p_1 = wp.vec3f(corner_offsets_table[v_to])                                             <L 3020>
        var_546 = wp::address(var_corner_offsets_table, var_538);
        var_548 = wp::load(var_546);
        var_547 = wp::vec_t<3, wp::float32>(var_548);
        // val_diff = val_1 - val_0                                                               <L 3021>
        var_549 = wp::sub(var_542, var_540);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 3022>
        var_550 = wp::abs(var_549);
        var_551 = (var_550 < var_227);
        if (var_551) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 3023>
            var_553 = wp::add(var_544, var_547);
            var_554 = wp::mul(var_552, var_553);
        }
        if (!var_551) {
            // t = wp.clamp((isovalue - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 3025>
            var_555 = wp::sub(var_isovalue, var_540);
            var_556 = wp::div(var_555, var_549);
            var_557 = wp::clamp(var_556, var_234, var_235);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 3026>
            var_558 = wp::sub(var_547, var_544);
            var_559 = wp::mul(var_557, var_558);
            var_560 = wp::add(var_544, var_559);
        }
        var_561 = wp::where(var_551, var_554, var_560);
        var_562 = wp::where(var_551, var_507, var_557);
        // vol_idx = p + wp.vec3(float(x_id), float(y_id), float(z_id))                           <L 3027>
        var_563 = wp::float(var_14);
        var_564 = wp::float(var_18);
        var_565 = wp::float(var_22);
        var_566 = wp::vec_t<3, wp::float32>(var_563, var_564, var_565);
        var_567 = wp::add(var_561, var_566);
        // local_pos = sdf.sdf_box_lower + wp.cw_mul(vol_idx, sdf.voxel_size)                     <L 3028>
        var_568 = &((var_6).sdf_box_lower);
        var_569 = &((var_6).voxel_size);
        var_571 = wp::load(var_569);
        var_570 = wp::cw_mul(var_567, var_571);
        var_573 = wp::load(var_568);
        var_572 = wp::add(var_573, var_570);
        // vertices[3 * out_idx + 3 * fi + vi] = local_pos                                        <L 3029>
        var_575 = wp::mul(var_574, var_200);
        var_577 = wp::mul(var_576, var_525);
        var_578 = wp::add(var_575, var_577);
        var_579 = wp::add(var_578, var_527);
        wp::array_store(var_vertices, var_579, var_572);
        // edge_verts = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                  <L 3014>
        var_582 = wp::mul(var_581, var_525);
        var_583 = wp::add(var_187, var_582);
        var_584 = wp::add(var_583, var_580);
        var_585 = wp::address(var_flat_edge_verts_table, var_584);
        var_587 = wp::load(var_585);
        var_586 = wp::vec_t<2, wp::int32>(var_587);
        // v_from = edge_verts[0]                                                                 <L 3015>
        var_589 = wp::extract(var_586, var_588);
        // v_to = edge_verts[1]                                                                   <L 3016>
        var_591 = wp::extract(var_586, var_590);
        // val_0 = wp.float32(corner_vals[v_from])                                                <L 3017>
        var_592 = wp::extract(var_25, var_589);
        var_593 = wp::float32(var_592);
        // val_1 = wp.float32(corner_vals[v_to])                                                  <L 3018>
        var_594 = wp::extract(var_25, var_591);
        var_595 = wp::float32(var_594);
        // p_0 = wp.vec3f(corner_offsets_table[v_from])                                           <L 3019>
        var_596 = wp::address(var_corner_offsets_table, var_589);
        var_598 = wp::load(var_596);
        var_597 = wp::vec_t<3, wp::float32>(var_598);
        // p_1 = wp.vec3f(corner_offsets_table[v_to])                                             <L 3020>
        var_599 = wp::address(var_corner_offsets_table, var_591);
        var_601 = wp::load(var_599);
        var_600 = wp::vec_t<3, wp::float32>(var_601);
        // val_diff = val_1 - val_0                                                               <L 3021>
        var_602 = wp::sub(var_595, var_593);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 3022>
        var_603 = wp::abs(var_602);
        var_604 = (var_603 < var_227);
        if (var_604) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 3023>
            var_606 = wp::add(var_597, var_600);
            var_607 = wp::mul(var_605, var_606);
        }
        if (!var_604) {
            // t = wp.clamp((isovalue - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 3025>
            var_608 = wp::sub(var_isovalue, var_593);
            var_609 = wp::div(var_608, var_602);
            var_610 = wp::clamp(var_609, var_234, var_235);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 3026>
            var_611 = wp::sub(var_600, var_597);
            var_612 = wp::mul(var_610, var_611);
            var_613 = wp::add(var_597, var_612);
        }
        var_614 = wp::where(var_604, var_607, var_613);
        var_615 = wp::where(var_604, var_562, var_610);
        // vol_idx = p + wp.vec3(float(x_id), float(y_id), float(z_id))                           <L 3027>
        var_616 = wp::float(var_14);
        var_617 = wp::float(var_18);
        var_618 = wp::float(var_22);
        var_619 = wp::vec_t<3, wp::float32>(var_616, var_617, var_618);
        var_620 = wp::add(var_614, var_619);
        // local_pos = sdf.sdf_box_lower + wp.cw_mul(vol_idx, sdf.voxel_size)                     <L 3028>
        var_621 = &((var_6).sdf_box_lower);
        var_622 = &((var_6).voxel_size);
        var_624 = wp::load(var_622);
        var_623 = wp::cw_mul(var_620, var_624);
        var_626 = wp::load(var_621);
        var_625 = wp::add(var_626, var_623);
        // vertices[3 * out_idx + 3 * fi + vi] = local_pos                                        <L 3029>
        var_628 = wp::mul(var_627, var_200);
        var_630 = wp::mul(var_629, var_525);
        var_631 = wp::add(var_628, var_630);
        var_632 = wp::add(var_631, var_580);
        wp::array_store(var_vertices, var_632, var_625);
        // edge_verts = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                  <L 3014>
        var_635 = wp::mul(var_634, var_525);
        var_636 = wp::add(var_187, var_635);
        var_637 = wp::add(var_636, var_633);
        var_638 = wp::address(var_flat_edge_verts_table, var_637);
        var_640 = wp::load(var_638);
        var_639 = wp::vec_t<2, wp::int32>(var_640);
        // v_from = edge_verts[0]                                                                 <L 3015>
        var_642 = wp::extract(var_639, var_641);
        // v_to = edge_verts[1]                                                                   <L 3016>
        var_644 = wp::extract(var_639, var_643);
        // val_0 = wp.float32(corner_vals[v_from])                                                <L 3017>
        var_645 = wp::extract(var_25, var_642);
        var_646 = wp::float32(var_645);
        // val_1 = wp.float32(corner_vals[v_to])                                                  <L 3018>
        var_647 = wp::extract(var_25, var_644);
        var_648 = wp::float32(var_647);
        // p_0 = wp.vec3f(corner_offsets_table[v_from])                                           <L 3019>
        var_649 = wp::address(var_corner_offsets_table, var_642);
        var_651 = wp::load(var_649);
        var_650 = wp::vec_t<3, wp::float32>(var_651);
        // p_1 = wp.vec3f(corner_offsets_table[v_to])                                             <L 3020>
        var_652 = wp::address(var_corner_offsets_table, var_644);
        var_654 = wp::load(var_652);
        var_653 = wp::vec_t<3, wp::float32>(var_654);
        // val_diff = val_1 - val_0                                                               <L 3021>
        var_655 = wp::sub(var_648, var_646);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 3022>
        var_656 = wp::abs(var_655);
        var_657 = (var_656 < var_227);
        if (var_657) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 3023>
            var_659 = wp::add(var_650, var_653);
            var_660 = wp::mul(var_658, var_659);
        }
        if (!var_657) {
            // t = wp.clamp((isovalue - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 3025>
            var_661 = wp::sub(var_isovalue, var_646);
            var_662 = wp::div(var_661, var_655);
            var_663 = wp::clamp(var_662, var_234, var_235);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 3026>
            var_664 = wp::sub(var_653, var_650);
            var_665 = wp::mul(var_663, var_664);
            var_666 = wp::add(var_650, var_665);
        }
        var_667 = wp::where(var_657, var_660, var_666);
        var_668 = wp::where(var_657, var_615, var_663);
        // vol_idx = p + wp.vec3(float(x_id), float(y_id), float(z_id))                           <L 3027>
        var_669 = wp::float(var_14);
        var_670 = wp::float(var_18);
        var_671 = wp::float(var_22);
        var_672 = wp::vec_t<3, wp::float32>(var_669, var_670, var_671);
        var_673 = wp::add(var_667, var_672);
        // local_pos = sdf.sdf_box_lower + wp.cw_mul(vol_idx, sdf.voxel_size)                     <L 3028>
        var_674 = &((var_6).sdf_box_lower);
        var_675 = &((var_6).voxel_size);
        var_677 = wp::load(var_675);
        var_676 = wp::cw_mul(var_673, var_677);
        var_679 = wp::load(var_674);
        var_678 = wp::add(var_679, var_676);
        // vertices[3 * out_idx + 3 * fi + vi] = local_pos                                        <L 3029>
        var_681 = wp::mul(var_680, var_200);
        var_683 = wp::mul(var_682, var_525);
        var_684 = wp::add(var_681, var_683);
        var_685 = wp::add(var_684, var_633);
        wp::array_store(var_vertices, var_685, var_678);
        // if fi >= num_faces:                                                                    <L 3011>
        var_687 = (var_686 >= var_196);
        if (var_687) {
            // return                                                                             <L 3012>
            continue;
        }
        // for vi in range(3):                                                                    <L 3013>
        // edge_verts = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                  <L 3014>
        var_690 = wp::mul(var_689, var_686);
        var_691 = wp::add(var_187, var_690);
        var_692 = wp::add(var_691, var_688);
        var_693 = wp::address(var_flat_edge_verts_table, var_692);
        var_695 = wp::load(var_693);
        var_694 = wp::vec_t<2, wp::int32>(var_695);
        // v_from = edge_verts[0]                                                                 <L 3015>
        var_697 = wp::extract(var_694, var_696);
        // v_to = edge_verts[1]                                                                   <L 3016>
        var_699 = wp::extract(var_694, var_698);
        // val_0 = wp.float32(corner_vals[v_from])                                                <L 3017>
        var_700 = wp::extract(var_25, var_697);
        var_701 = wp::float32(var_700);
        // val_1 = wp.float32(corner_vals[v_to])                                                  <L 3018>
        var_702 = wp::extract(var_25, var_699);
        var_703 = wp::float32(var_702);
        // p_0 = wp.vec3f(corner_offsets_table[v_from])                                           <L 3019>
        var_704 = wp::address(var_corner_offsets_table, var_697);
        var_706 = wp::load(var_704);
        var_705 = wp::vec_t<3, wp::float32>(var_706);
        // p_1 = wp.vec3f(corner_offsets_table[v_to])                                             <L 3020>
        var_707 = wp::address(var_corner_offsets_table, var_699);
        var_709 = wp::load(var_707);
        var_708 = wp::vec_t<3, wp::float32>(var_709);
        // val_diff = val_1 - val_0                                                               <L 3021>
        var_710 = wp::sub(var_703, var_701);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 3022>
        var_711 = wp::abs(var_710);
        var_712 = (var_711 < var_227);
        if (var_712) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 3023>
            var_714 = wp::add(var_705, var_708);
            var_715 = wp::mul(var_713, var_714);
        }
        if (!var_712) {
            // t = wp.clamp((isovalue - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 3025>
            var_716 = wp::sub(var_isovalue, var_701);
            var_717 = wp::div(var_716, var_710);
            var_718 = wp::clamp(var_717, var_234, var_235);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 3026>
            var_719 = wp::sub(var_708, var_705);
            var_720 = wp::mul(var_718, var_719);
            var_721 = wp::add(var_705, var_720);
        }
        var_722 = wp::where(var_712, var_715, var_721);
        var_723 = wp::where(var_712, var_668, var_718);
        // vol_idx = p + wp.vec3(float(x_id), float(y_id), float(z_id))                           <L 3027>
        var_724 = wp::float(var_14);
        var_725 = wp::float(var_18);
        var_726 = wp::float(var_22);
        var_727 = wp::vec_t<3, wp::float32>(var_724, var_725, var_726);
        var_728 = wp::add(var_722, var_727);
        // local_pos = sdf.sdf_box_lower + wp.cw_mul(vol_idx, sdf.voxel_size)                     <L 3028>
        var_729 = &((var_6).sdf_box_lower);
        var_730 = &((var_6).voxel_size);
        var_732 = wp::load(var_730);
        var_731 = wp::cw_mul(var_728, var_732);
        var_734 = wp::load(var_729);
        var_733 = wp::add(var_734, var_731);
        // vertices[3 * out_idx + 3 * fi + vi] = local_pos                                        <L 3029>
        var_736 = wp::mul(var_735, var_200);
        var_738 = wp::mul(var_737, var_686);
        var_739 = wp::add(var_736, var_738);
        var_740 = wp::add(var_739, var_688);
        wp::array_store(var_vertices, var_740, var_733);
        // edge_verts = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                  <L 3014>
        var_743 = wp::mul(var_742, var_686);
        var_744 = wp::add(var_187, var_743);
        var_745 = wp::add(var_744, var_741);
        var_746 = wp::address(var_flat_edge_verts_table, var_745);
        var_748 = wp::load(var_746);
        var_747 = wp::vec_t<2, wp::int32>(var_748);
        // v_from = edge_verts[0]                                                                 <L 3015>
        var_750 = wp::extract(var_747, var_749);
        // v_to = edge_verts[1]                                                                   <L 3016>
        var_752 = wp::extract(var_747, var_751);
        // val_0 = wp.float32(corner_vals[v_from])                                                <L 3017>
        var_753 = wp::extract(var_25, var_750);
        var_754 = wp::float32(var_753);
        // val_1 = wp.float32(corner_vals[v_to])                                                  <L 3018>
        var_755 = wp::extract(var_25, var_752);
        var_756 = wp::float32(var_755);
        // p_0 = wp.vec3f(corner_offsets_table[v_from])                                           <L 3019>
        var_757 = wp::address(var_corner_offsets_table, var_750);
        var_759 = wp::load(var_757);
        var_758 = wp::vec_t<3, wp::float32>(var_759);
        // p_1 = wp.vec3f(corner_offsets_table[v_to])                                             <L 3020>
        var_760 = wp::address(var_corner_offsets_table, var_752);
        var_762 = wp::load(var_760);
        var_761 = wp::vec_t<3, wp::float32>(var_762);
        // val_diff = val_1 - val_0                                                               <L 3021>
        var_763 = wp::sub(var_756, var_754);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 3022>
        var_764 = wp::abs(var_763);
        var_765 = (var_764 < var_227);
        if (var_765) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 3023>
            var_767 = wp::add(var_758, var_761);
            var_768 = wp::mul(var_766, var_767);
        }
        if (!var_765) {
            // t = wp.clamp((isovalue - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 3025>
            var_769 = wp::sub(var_isovalue, var_754);
            var_770 = wp::div(var_769, var_763);
            var_771 = wp::clamp(var_770, var_234, var_235);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 3026>
            var_772 = wp::sub(var_761, var_758);
            var_773 = wp::mul(var_771, var_772);
            var_774 = wp::add(var_758, var_773);
        }
        var_775 = wp::where(var_765, var_768, var_774);
        var_776 = wp::where(var_765, var_723, var_771);
        // vol_idx = p + wp.vec3(float(x_id), float(y_id), float(z_id))                           <L 3027>
        var_777 = wp::float(var_14);
        var_778 = wp::float(var_18);
        var_779 = wp::float(var_22);
        var_780 = wp::vec_t<3, wp::float32>(var_777, var_778, var_779);
        var_781 = wp::add(var_775, var_780);
        // local_pos = sdf.sdf_box_lower + wp.cw_mul(vol_idx, sdf.voxel_size)                     <L 3028>
        var_782 = &((var_6).sdf_box_lower);
        var_783 = &((var_6).voxel_size);
        var_785 = wp::load(var_783);
        var_784 = wp::cw_mul(var_781, var_785);
        var_787 = wp::load(var_782);
        var_786 = wp::add(var_787, var_784);
        // vertices[3 * out_idx + 3 * fi + vi] = local_pos                                        <L 3029>
        var_789 = wp::mul(var_788, var_200);
        var_791 = wp::mul(var_790, var_686);
        var_792 = wp::add(var_789, var_791);
        var_793 = wp::add(var_792, var_741);
        wp::array_store(var_vertices, var_793, var_786);
        // edge_verts = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                  <L 3014>
        var_796 = wp::mul(var_795, var_686);
        var_797 = wp::add(var_187, var_796);
        var_798 = wp::add(var_797, var_794);
        var_799 = wp::address(var_flat_edge_verts_table, var_798);
        var_801 = wp::load(var_799);
        var_800 = wp::vec_t<2, wp::int32>(var_801);
        // v_from = edge_verts[0]                                                                 <L 3015>
        var_803 = wp::extract(var_800, var_802);
        // v_to = edge_verts[1]                                                                   <L 3016>
        var_805 = wp::extract(var_800, var_804);
        // val_0 = wp.float32(corner_vals[v_from])                                                <L 3017>
        var_806 = wp::extract(var_25, var_803);
        var_807 = wp::float32(var_806);
        // val_1 = wp.float32(corner_vals[v_to])                                                  <L 3018>
        var_808 = wp::extract(var_25, var_805);
        var_809 = wp::float32(var_808);
        // p_0 = wp.vec3f(corner_offsets_table[v_from])                                           <L 3019>
        var_810 = wp::address(var_corner_offsets_table, var_803);
        var_812 = wp::load(var_810);
        var_811 = wp::vec_t<3, wp::float32>(var_812);
        // p_1 = wp.vec3f(corner_offsets_table[v_to])                                             <L 3020>
        var_813 = wp::address(var_corner_offsets_table, var_805);
        var_815 = wp::load(var_813);
        var_814 = wp::vec_t<3, wp::float32>(var_815);
        // val_diff = val_1 - val_0                                                               <L 3021>
        var_816 = wp::sub(var_809, var_807);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 3022>
        var_817 = wp::abs(var_816);
        var_818 = (var_817 < var_227);
        if (var_818) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 3023>
            var_820 = wp::add(var_811, var_814);
            var_821 = wp::mul(var_819, var_820);
        }
        if (!var_818) {
            // t = wp.clamp((isovalue - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 3025>
            var_822 = wp::sub(var_isovalue, var_807);
            var_823 = wp::div(var_822, var_816);
            var_824 = wp::clamp(var_823, var_234, var_235);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 3026>
            var_825 = wp::sub(var_814, var_811);
            var_826 = wp::mul(var_824, var_825);
            var_827 = wp::add(var_811, var_826);
        }
        var_828 = wp::where(var_818, var_821, var_827);
        var_829 = wp::where(var_818, var_776, var_824);
        // vol_idx = p + wp.vec3(float(x_id), float(y_id), float(z_id))                           <L 3027>
        var_830 = wp::float(var_14);
        var_831 = wp::float(var_18);
        var_832 = wp::float(var_22);
        var_833 = wp::vec_t<3, wp::float32>(var_830, var_831, var_832);
        var_834 = wp::add(var_828, var_833);
        // local_pos = sdf.sdf_box_lower + wp.cw_mul(vol_idx, sdf.voxel_size)                     <L 3028>
        var_835 = &((var_6).sdf_box_lower);
        var_836 = &((var_6).voxel_size);
        var_838 = wp::load(var_836);
        var_837 = wp::cw_mul(var_834, var_838);
        var_840 = wp::load(var_835);
        var_839 = wp::add(var_840, var_837);
        // vertices[3 * out_idx + 3 * fi + vi] = local_pos                                        <L 3029>
        var_842 = wp::mul(var_841, var_200);
        var_844 = wp::mul(var_843, var_686);
        var_845 = wp::add(var_842, var_844);
        var_846 = wp::add(var_845, var_794);
        wp::array_store(var_vertices, var_846, var_839);
        // if fi >= num_faces:                                                                    <L 3011>
        var_848 = (var_847 >= var_196);
        if (var_848) {
            // return                                                                             <L 3012>
            continue;
        }
        // for vi in range(3):                                                                    <L 3013>
        // edge_verts = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                  <L 3014>
        var_851 = wp::mul(var_850, var_847);
        var_852 = wp::add(var_187, var_851);
        var_853 = wp::add(var_852, var_849);
        var_854 = wp::address(var_flat_edge_verts_table, var_853);
        var_856 = wp::load(var_854);
        var_855 = wp::vec_t<2, wp::int32>(var_856);
        // v_from = edge_verts[0]                                                                 <L 3015>
        var_858 = wp::extract(var_855, var_857);
        // v_to = edge_verts[1]                                                                   <L 3016>
        var_860 = wp::extract(var_855, var_859);
        // val_0 = wp.float32(corner_vals[v_from])                                                <L 3017>
        var_861 = wp::extract(var_25, var_858);
        var_862 = wp::float32(var_861);
        // val_1 = wp.float32(corner_vals[v_to])                                                  <L 3018>
        var_863 = wp::extract(var_25, var_860);
        var_864 = wp::float32(var_863);
        // p_0 = wp.vec3f(corner_offsets_table[v_from])                                           <L 3019>
        var_865 = wp::address(var_corner_offsets_table, var_858);
        var_867 = wp::load(var_865);
        var_866 = wp::vec_t<3, wp::float32>(var_867);
        // p_1 = wp.vec3f(corner_offsets_table[v_to])                                             <L 3020>
        var_868 = wp::address(var_corner_offsets_table, var_860);
        var_870 = wp::load(var_868);
        var_869 = wp::vec_t<3, wp::float32>(var_870);
        // val_diff = val_1 - val_0                                                               <L 3021>
        var_871 = wp::sub(var_864, var_862);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 3022>
        var_872 = wp::abs(var_871);
        var_873 = (var_872 < var_227);
        if (var_873) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 3023>
            var_875 = wp::add(var_866, var_869);
            var_876 = wp::mul(var_874, var_875);
        }
        if (!var_873) {
            // t = wp.clamp((isovalue - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 3025>
            var_877 = wp::sub(var_isovalue, var_862);
            var_878 = wp::div(var_877, var_871);
            var_879 = wp::clamp(var_878, var_234, var_235);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 3026>
            var_880 = wp::sub(var_869, var_866);
            var_881 = wp::mul(var_879, var_880);
            var_882 = wp::add(var_866, var_881);
        }
        var_883 = wp::where(var_873, var_876, var_882);
        var_884 = wp::where(var_873, var_829, var_879);
        // vol_idx = p + wp.vec3(float(x_id), float(y_id), float(z_id))                           <L 3027>
        var_885 = wp::float(var_14);
        var_886 = wp::float(var_18);
        var_887 = wp::float(var_22);
        var_888 = wp::vec_t<3, wp::float32>(var_885, var_886, var_887);
        var_889 = wp::add(var_883, var_888);
        // local_pos = sdf.sdf_box_lower + wp.cw_mul(vol_idx, sdf.voxel_size)                     <L 3028>
        var_890 = &((var_6).sdf_box_lower);
        var_891 = &((var_6).voxel_size);
        var_893 = wp::load(var_891);
        var_892 = wp::cw_mul(var_889, var_893);
        var_895 = wp::load(var_890);
        var_894 = wp::add(var_895, var_892);
        // vertices[3 * out_idx + 3 * fi + vi] = local_pos                                        <L 3029>
        var_897 = wp::mul(var_896, var_200);
        var_899 = wp::mul(var_898, var_847);
        var_900 = wp::add(var_897, var_899);
        var_901 = wp::add(var_900, var_849);
        wp::array_store(var_vertices, var_901, var_894);
        // edge_verts = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                  <L 3014>
        var_904 = wp::mul(var_903, var_847);
        var_905 = wp::add(var_187, var_904);
        var_906 = wp::add(var_905, var_902);
        var_907 = wp::address(var_flat_edge_verts_table, var_906);
        var_909 = wp::load(var_907);
        var_908 = wp::vec_t<2, wp::int32>(var_909);
        // v_from = edge_verts[0]                                                                 <L 3015>
        var_911 = wp::extract(var_908, var_910);
        // v_to = edge_verts[1]                                                                   <L 3016>
        var_913 = wp::extract(var_908, var_912);
        // val_0 = wp.float32(corner_vals[v_from])                                                <L 3017>
        var_914 = wp::extract(var_25, var_911);
        var_915 = wp::float32(var_914);
        // val_1 = wp.float32(corner_vals[v_to])                                                  <L 3018>
        var_916 = wp::extract(var_25, var_913);
        var_917 = wp::float32(var_916);
        // p_0 = wp.vec3f(corner_offsets_table[v_from])                                           <L 3019>
        var_918 = wp::address(var_corner_offsets_table, var_911);
        var_920 = wp::load(var_918);
        var_919 = wp::vec_t<3, wp::float32>(var_920);
        // p_1 = wp.vec3f(corner_offsets_table[v_to])                                             <L 3020>
        var_921 = wp::address(var_corner_offsets_table, var_913);
        var_923 = wp::load(var_921);
        var_922 = wp::vec_t<3, wp::float32>(var_923);
        // val_diff = val_1 - val_0                                                               <L 3021>
        var_924 = wp::sub(var_917, var_915);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 3022>
        var_925 = wp::abs(var_924);
        var_926 = (var_925 < var_227);
        if (var_926) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 3023>
            var_928 = wp::add(var_919, var_922);
            var_929 = wp::mul(var_927, var_928);
        }
        if (!var_926) {
            // t = wp.clamp((isovalue - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 3025>
            var_930 = wp::sub(var_isovalue, var_915);
            var_931 = wp::div(var_930, var_924);
            var_932 = wp::clamp(var_931, var_234, var_235);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 3026>
            var_933 = wp::sub(var_922, var_919);
            var_934 = wp::mul(var_932, var_933);
            var_935 = wp::add(var_919, var_934);
        }
        var_936 = wp::where(var_926, var_929, var_935);
        var_937 = wp::where(var_926, var_884, var_932);
        // vol_idx = p + wp.vec3(float(x_id), float(y_id), float(z_id))                           <L 3027>
        var_938 = wp::float(var_14);
        var_939 = wp::float(var_18);
        var_940 = wp::float(var_22);
        var_941 = wp::vec_t<3, wp::float32>(var_938, var_939, var_940);
        var_942 = wp::add(var_936, var_941);
        // local_pos = sdf.sdf_box_lower + wp.cw_mul(vol_idx, sdf.voxel_size)                     <L 3028>
        var_943 = &((var_6).sdf_box_lower);
        var_944 = &((var_6).voxel_size);
        var_946 = wp::load(var_944);
        var_945 = wp::cw_mul(var_942, var_946);
        var_948 = wp::load(var_943);
        var_947 = wp::add(var_948, var_945);
        // vertices[3 * out_idx + 3 * fi + vi] = local_pos                                        <L 3029>
        var_950 = wp::mul(var_949, var_200);
        var_952 = wp::mul(var_951, var_847);
        var_953 = wp::add(var_950, var_952);
        var_954 = wp::add(var_953, var_902);
        wp::array_store(var_vertices, var_954, var_947);
        // edge_verts = wp.vec2i(flat_edge_verts_table[tri_start + 3 * fi + vi])                  <L 3014>
        var_957 = wp::mul(var_956, var_847);
        var_958 = wp::add(var_187, var_957);
        var_959 = wp::add(var_958, var_955);
        var_960 = wp::address(var_flat_edge_verts_table, var_959);
        var_962 = wp::load(var_960);
        var_961 = wp::vec_t<2, wp::int32>(var_962);
        // v_from = edge_verts[0]                                                                 <L 3015>
        var_964 = wp::extract(var_961, var_963);
        // v_to = edge_verts[1]                                                                   <L 3016>
        var_966 = wp::extract(var_961, var_965);
        // val_0 = wp.float32(corner_vals[v_from])                                                <L 3017>
        var_967 = wp::extract(var_25, var_964);
        var_968 = wp::float32(var_967);
        // val_1 = wp.float32(corner_vals[v_to])                                                  <L 3018>
        var_969 = wp::extract(var_25, var_966);
        var_970 = wp::float32(var_969);
        // p_0 = wp.vec3f(corner_offsets_table[v_from])                                           <L 3019>
        var_971 = wp::address(var_corner_offsets_table, var_964);
        var_973 = wp::load(var_971);
        var_972 = wp::vec_t<3, wp::float32>(var_973);
        // p_1 = wp.vec3f(corner_offsets_table[v_to])                                             <L 3020>
        var_974 = wp::address(var_corner_offsets_table, var_966);
        var_976 = wp::load(var_974);
        var_975 = wp::vec_t<3, wp::float32>(var_976);
        // val_diff = val_1 - val_0                                                               <L 3021>
        var_977 = wp::sub(var_970, var_968);
        // if wp.abs(val_diff) < MC_EDGE_VAL_DIFF_EPS:                                            <L 3022>
        var_978 = wp::abs(var_977);
        var_979 = (var_978 < var_227);
        if (var_979) {
            // p = 0.5 * (p_0 + p_1)                                                              <L 3023>
            var_981 = wp::add(var_972, var_975);
            var_982 = wp::mul(var_980, var_981);
        }
        if (!var_979) {
            // t = wp.clamp((isovalue - val_0) / val_diff, MC_EDGE_CLAMP_MIN, MC_EDGE_CLAMP_MAX)       <L 3025>
            var_983 = wp::sub(var_isovalue, var_968);
            var_984 = wp::div(var_983, var_977);
            var_985 = wp::clamp(var_984, var_234, var_235);
            // p = p_0 + t * (p_1 - p_0)                                                          <L 3026>
            var_986 = wp::sub(var_975, var_972);
            var_987 = wp::mul(var_985, var_986);
            var_988 = wp::add(var_972, var_987);
        }
        var_989 = wp::where(var_979, var_982, var_988);
        var_990 = wp::where(var_979, var_937, var_985);
        // vol_idx = p + wp.vec3(float(x_id), float(y_id), float(z_id))                           <L 3027>
        var_991 = wp::float(var_14);
        var_992 = wp::float(var_18);
        var_993 = wp::float(var_22);
        var_994 = wp::vec_t<3, wp::float32>(var_991, var_992, var_993);
        var_995 = wp::add(var_989, var_994);
        // local_pos = sdf.sdf_box_lower + wp.cw_mul(vol_idx, sdf.voxel_size)                     <L 3028>
        var_996 = &((var_6).sdf_box_lower);
        var_997 = &((var_6).voxel_size);
        var_999 = wp::load(var_997);
        var_998 = wp::cw_mul(var_995, var_999);
        var_1001 = wp::load(var_996);
        var_1000 = wp::add(var_1001, var_998);
        // vertices[3 * out_idx + 3 * fi + vi] = local_pos                                        <L 3029>
        var_1003 = wp::mul(var_1002, var_200);
        var_1005 = wp::mul(var_1004, var_847);
        var_1006 = wp::add(var_1003, var_1005);
        var_1007 = wp::add(var_1006, var_955);
        wp::array_store(var_vertices, var_1007, var_1000);
    }
}

