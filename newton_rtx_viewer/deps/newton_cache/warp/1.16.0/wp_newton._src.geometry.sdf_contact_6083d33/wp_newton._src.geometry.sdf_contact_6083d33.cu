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



extern "C" __global__ void compute_block_counts_from_weights_cf3b4d4f_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::int32> var_weight_prefix_sums,
    wp::array_t<wp::int32> var_weights,
    wp::array_t<wp::int32> var_pair_count_arr,
    wp::int32 var_max_pairs,
    wp::int32 var_target_blocks,
    wp::array_t<wp::int32> var_block_counts)
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
        bool var_5;
        const wp::int32 var_6 = 0;
        const wp::int32 var_7 = 1;
        wp::int32 var_8;
        wp::int32* var_9;
        wp::int32 var_10;
        wp::int32 var_11;
        wp::int32 var_12;
        bool var_13;
        const wp::int32 var_14 = 0;
        bool var_15;
        const wp::int32 var_16 = 0;
        bool var_17;
        const wp::int32 var_18 = 256;
        wp::int32 var_19;
        wp::int32 var_20;
        wp::int32 var_21;
        wp::int32* var_22;
        wp::int32 var_23;
        wp::int32 var_24;
        const wp::int32 var_25 = 0;
        bool var_26;
        const wp::int32 var_27 = 1;
        wp::int32 var_28;
        const wp::int32 var_29 = 1;
        wp::int32 var_30;
        wp::int32 var_31;
        wp::int32 var_32;
        const wp::int32 var_33 = 1;
        wp::int32 var_34;
        wp::int32 var_35;
        //---------
        // forward
        // def compute_block_counts_from_weights(                                                 <L 979>
        // i = wp.tid()                                                                           <L 994>
        var_0 = builtin_tid1d();
        // pair_count = wp.min(pair_count_arr[0], max_pairs)                                      <L 995>
        var_2 = wp::address(var_pair_count_arr, var_1);
        var_4 = wp::load(var_2);
        var_3 = wp::min(var_4, var_max_pairs);
        // if i >= pair_count:                                                                    <L 996>
        var_5 = (var_0 >= var_3);
        if (var_5) {
            // block_counts[i] = 0                                                                <L 997>
            wp::array_store(var_block_counts, var_0, var_6);
            // return                                                                             <L 998>
            continue;
        }
        // total_weight = weight_prefix_sums[pair_count - 1]                                      <L 1000>
        var_8 = wp::sub(var_3, var_7);
        var_9 = wp::address(var_weight_prefix_sums, var_8);
        var_11 = wp::load(var_9);
        var_10 = wp::copy(var_11);
        // weight_per_block = int(total_weight)                                                   <L 1001>
        var_12 = wp::int(var_10);
        // if target_blocks > 0 and total_weight > 0:                                             <L 1002>
        var_15 = (var_target_blocks > var_14);
        var_13 = var_15;
        if (var_13) {
            var_17 = (var_10 > var_16);
            var_13 = var_13 && var_17;
        }
        if (var_13) {
            // weight_per_block = wp.max(256, total_weight // target_blocks)                      <L 1003>
            var_19 = wp::floordiv(var_10, var_target_blocks);
            var_20 = wp::max(var_18, var_19);
        }
        var_21 = wp::where(var_13, var_20, var_12);
        // w = int(weights[i])                                                                    <L 1005>
        var_22 = wp::address(var_weights, var_0);
        var_24 = wp::load(var_22);
        var_23 = wp::int(var_24);
        // if weight_per_block > 0:                                                               <L 1006>
        var_26 = (var_21 > var_25);
        if (var_26) {
            // blocks = wp.max(1, (w + weight_per_block - 1) // weight_per_block)                 <L 1007>
            var_28 = wp::add(var_23, var_21);
            var_30 = wp::sub(var_28, var_29);
            var_31 = wp::floordiv(var_30, var_21);
            var_32 = wp::max(var_27, var_31);
        }
        if (!var_26) {
            // blocks = 1                                                                         <L 1009>
        }
        var_34 = wp::where(var_26, var_32, var_33);
        // block_counts[i] = wp.int32(blocks)                                                     <L 1010>
        var_35 = wp::int32(var_34);
        wp::array_store(var_block_counts, var_0, var_35);
    }
}



extern "C" __global__ void compute_mesh_mesh_edge_counts_b8fdb390_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::vec_t<2, wp::int32>> var_shape_pairs_mesh_mesh,
    wp::array_t<wp::int32> var_shape_pairs_mesh_mesh_count,
    wp::array_t<wp::vec_t<2, wp::int32>> var_shape_edge_range,
    wp::array_t<wp::int32> var_shape_heightfield_index,
    wp::array_t<HeightfieldData_f2b8d59a> var_heightfield_data,
    wp::array_t<wp::int32> var_edge_counts)
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
        wp::shape_t* var_3;
        const wp::int32 var_4 = 0;
        wp::int32 var_5;
        wp::shape_t var_6;
        wp::int32 var_7;
        wp::int32 var_8;
        bool var_9;
        const wp::int32 var_10 = 0;
        wp::vec_t<2, wp::int32>* var_11;
        wp::vec_t<2, wp::int32> var_12;
        wp::vec_t<2, wp::int32> var_13;
        const wp::int32 var_14 = 0;
        wp::int32 var_15;
        const wp::int32 var_16 = 1073741824;
        wp::int32 var_17;
        const wp::int32 var_18 = 0;
        bool var_19;
        const wp::int32 var_20 = 0;
        wp::int32 var_21;
        const wp::int32 var_22 = 1073741823;
        wp::int32 var_23;
        const wp::int32 var_24 = 1;
        wp::int32 var_25;
        wp::vec_t<2, wp::int32> var_26;
        const wp::int32 var_27 = 0;
        wp::int32 var_28;
        const wp::int32 var_29 = 0;
        bool var_30;
        const wp::int32 var_31 = 0;
        bool var_32;
        wp::int32 var_33;
        wp::int32* var_34;
        HeightfieldData_f2b8d59a* var_35;
        wp::int32 var_36;
        HeightfieldData_f2b8d59a var_37;
        HeightfieldData_f2b8d59a var_38;
        const wp::int32 var_39 = 2;
        const wp::int32 var_40 = 2;
        const wp::int32 var_41 = -1;
        const wp::int32 var_42 = 0;
        wp::vec_t<2, wp::int32> var_43;
        wp::int32 var_44;
        wp::int32 var_45;
        wp::vec_t<2, wp::int32>* var_46;
        const wp::int32 var_47 = 1;
        wp::int32 var_48;
        wp::vec_t<2, wp::int32> var_49;
        wp::int32 var_50;
        wp::int32 var_51;
        const wp::int32 var_52 = 1;
        bool var_53;
        const wp::int32 var_54 = 0;
        bool var_55;
        wp::int32 var_56;
        wp::int32* var_57;
        HeightfieldData_f2b8d59a* var_58;
        wp::int32 var_59;
        HeightfieldData_f2b8d59a var_60;
        HeightfieldData_f2b8d59a var_61;
        const wp::int32 var_62 = 2;
        const wp::int32 var_63 = 2;
        const wp::int32 var_64 = -1;
        const wp::int32 var_65 = 0;
        wp::vec_t<2, wp::int32> var_66;
        wp::int32 var_67;
        wp::int32 var_68;
        wp::vec_t<2, wp::int32>* var_69;
        const wp::int32 var_70 = 1;
        wp::int32 var_71;
        wp::vec_t<2, wp::int32> var_72;
        wp::int32 var_73;
        wp::int32 var_74;
        HeightfieldData_f2b8d59a var_75;
        wp::int32 var_76;
        //---------
        // forward
        // def compute_mesh_mesh_edge_counts(                                                     <L 942>
        // i = wp.tid()                                                                           <L 957>
        var_0 = builtin_tid1d();
        // pair_count = wp.min(shape_pairs_mesh_mesh_count[0], shape_pairs_mesh_mesh.shape[0])       <L 958>
        var_2 = wp::address(var_shape_pairs_mesh_mesh_count, var_1);
        var_3 = &(var_shape_pairs_mesh_mesh.shape);
        var_6 = wp::load(var_3);
        var_5 = wp::extract(var_6, var_4);
        var_8 = wp::load(var_2);
        var_7 = wp::min(var_8, var_5);
        // if i >= pair_count:                                                                    <L 959>
        var_9 = (var_0 >= var_7);
        if (var_9) {
            // edge_counts[i] = 0                                                                 <L 960>
            wp::array_store(var_edge_counts, var_0, var_10);
            // return                                                                             <L 961>
            continue;
        }
        // pair_encoded = shape_pairs_mesh_mesh[i]                                                <L 963>
        var_11 = wp::address(var_shape_pairs_mesh_mesh, var_0);
        var_13 = wp::load(var_11);
        var_12 = wp::copy(var_13);
        // has_hfield = (pair_encoded[0] & SHAPE_PAIR_HFIELD_BIT) != 0                            <L 964>
        var_15 = wp::extract(var_12, var_14);
        var_17 = wp::bit_and(var_15, var_16);
        var_19 = (var_17 != var_18);
        // pair = wp.vec2i(pair_encoded[0] & SHAPE_PAIR_INDEX_MASK, pair_encoded[1])              <L 965>
        var_21 = wp::extract(var_12, var_20);
        var_23 = wp::bit_and(var_21, var_22);
        var_25 = wp::extract(var_12, var_24);
        var_26 = wp::vec_t<2, wp::int32>(var_23, var_25);
        // pair_edges = int(0)                                                                    <L 966>
        var_28 = wp::int(var_27);
        // for mode in range(2):                                                                  <L 967>
        // is_hfield = has_hfield and mode == 0                                                   <L 968>
        var_30 = var_19;
        if (var_30) {
            var_32 = (var_29 == var_31);
            var_30 = var_30 && var_32;
        }
        // shape_idx = pair[mode]                                                                 <L 969>
        var_33 = wp::extract(var_26, var_29);
        // if is_hfield:                                                                          <L 970>
        if (var_30) {
            // hfd = heightfield_data[shape_heightfield_index[shape_idx]]                         <L 971>
            var_34 = wp::address(var_shape_heightfield_index, var_33);
            var_36 = wp::load(var_34);
            var_35 = wp::address(var_heightfield_data, var_36);
            var_38 = wp::load(var_35);
            var_37 = wp::copy(var_38);
            // pair_edges += get_edge_count(GeoType.HFIELD, wp.vec2i(-1, 0), hfd)                 <L 972>
            var_43 = wp::vec_t<2, wp::int32>(var_41, var_42);
            var_44 = get_edge_count_0(var_40, var_43, var_37);
            var_45 = wp::add(var_28, var_44);
        }
        if (!var_30) {
            // pair_edges += shape_edge_range[shape_idx][1]                                       <L 974>
            var_46 = wp::address(var_shape_edge_range, var_33);
            var_49 = wp::load(var_46);
            var_48 = wp::extract(var_49, var_47);
            var_50 = wp::add(var_28, var_48);
        }
        var_51 = wp::where(var_30, var_45, var_50);
        // is_hfield = has_hfield and mode == 0                                                   <L 968>
        var_53 = var_19;
        if (var_53) {
            var_55 = (var_52 == var_54);
            var_53 = var_53 && var_55;
        }
        // shape_idx = pair[mode]                                                                 <L 969>
        var_56 = wp::extract(var_26, var_52);
        // if is_hfield:                                                                          <L 970>
        if (var_53) {
            // hfd = heightfield_data[shape_heightfield_index[shape_idx]]                         <L 971>
            var_57 = wp::address(var_shape_heightfield_index, var_56);
            var_59 = wp::load(var_57);
            var_58 = wp::address(var_heightfield_data, var_59);
            var_61 = wp::load(var_58);
            var_60 = wp::copy(var_61);
            // pair_edges += get_edge_count(GeoType.HFIELD, wp.vec2i(-1, 0), hfd)                 <L 972>
            var_66 = wp::vec_t<2, wp::int32>(var_64, var_65);
            var_67 = get_edge_count_0(var_63, var_66, var_60);
            var_68 = wp::add(var_51, var_67);
        }
        if (!var_53) {
            // pair_edges += shape_edge_range[shape_idx][1]                                       <L 974>
            var_69 = wp::address(var_shape_edge_range, var_56);
            var_72 = wp::load(var_69);
            var_71 = wp::extract(var_72, var_70);
            var_73 = wp::add(var_51, var_71);
        }
        var_74 = wp::where(var_53, var_68, var_73);
        var_75 = wp::where(var_53, var_60, var_37);
        // edge_counts[i] = wp.int32(pair_edges)                                                  <L 975>
        var_76 = wp::int32(var_74);
        wp::array_store(var_edge_counts, var_0, var_76);
    }
}

