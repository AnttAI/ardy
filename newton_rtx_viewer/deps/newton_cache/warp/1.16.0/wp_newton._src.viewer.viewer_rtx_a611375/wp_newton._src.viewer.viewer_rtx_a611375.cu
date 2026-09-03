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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/warp/_src/math.py:618
static CUDA_CALLABLE wp::mat_t<4, 4, wp::float64> transform_compose_2(
    wp::vec_t<3, wp::float64> var_position,
    wp::quat_t<wp::float64> var_rotation,
    wp::vec_t<3, wp::float64> var_scale)
{
    //---------
    // primal vars
    wp::mat_t<3, 3, wp::float64> var_0;
    const wp::int32 var_1 = 0;
    wp::float64 var_2;
    const wp::int32 var_3 = 0;
    const wp::int32 var_4 = 0;
    wp::float64 var_5;
    wp::float64 var_6;
    const wp::int32 var_7 = 1;
    wp::float64 var_8;
    const wp::int32 var_9 = 0;
    const wp::int32 var_10 = 1;
    wp::float64 var_11;
    wp::float64 var_12;
    const wp::int32 var_13 = 2;
    wp::float64 var_14;
    const wp::int32 var_15 = 0;
    const wp::int32 var_16 = 2;
    wp::float64 var_17;
    wp::float64 var_18;
    const wp::int32 var_19 = 0;
    wp::float64 var_20;
    const wp::int32 var_21 = 0;
    wp::float64 var_22;
    const wp::int32 var_23 = 1;
    const wp::int32 var_24 = 0;
    wp::float64 var_25;
    wp::float64 var_26;
    const wp::int32 var_27 = 1;
    wp::float64 var_28;
    const wp::int32 var_29 = 1;
    const wp::int32 var_30 = 1;
    wp::float64 var_31;
    wp::float64 var_32;
    const wp::int32 var_33 = 2;
    wp::float64 var_34;
    const wp::int32 var_35 = 1;
    const wp::int32 var_36 = 2;
    wp::float64 var_37;
    wp::float64 var_38;
    const wp::int32 var_39 = 1;
    wp::float64 var_40;
    const wp::int32 var_41 = 0;
    wp::float64 var_42;
    const wp::int32 var_43 = 2;
    const wp::int32 var_44 = 0;
    wp::float64 var_45;
    wp::float64 var_46;
    const wp::int32 var_47 = 1;
    wp::float64 var_48;
    const wp::int32 var_49 = 2;
    const wp::int32 var_50 = 1;
    wp::float64 var_51;
    wp::float64 var_52;
    const wp::int32 var_53 = 2;
    wp::float64 var_54;
    const wp::int32 var_55 = 2;
    const wp::int32 var_56 = 2;
    wp::float64 var_57;
    wp::float64 var_58;
    const wp::int32 var_59 = 2;
    wp::float64 var_60;
    wp::float64 var_61;
    wp::float64 var_62;
    wp::float64 var_63;
    wp::float64 var_64;
    wp::mat_t<4, 4, wp::float64> var_65;
    //---------
    // forward
    // def transform_compose(position: vec3, rotation: quat, scale: vec3):                    <L 618>
    // R = wp.quat_to_matrix(rotation)                                                        <L 643>
    var_0 = wp::quat_to_matrix(var_rotation);
    // return mat44(                                                                          <L 645>
    // scale[0] * R[0,0], scale[1] * R[0,1], scale[2] * R[0,2], position[0],                  <L 646>
    var_2 = wp::extract(var_scale, var_1);
    var_5 = wp::extract(var_0, var_3, var_4);
    var_6 = wp::mul(var_2, var_5);
    var_8 = wp::extract(var_scale, var_7);
    var_11 = wp::extract(var_0, var_9, var_10);
    var_12 = wp::mul(var_8, var_11);
    var_14 = wp::extract(var_scale, var_13);
    var_17 = wp::extract(var_0, var_15, var_16);
    var_18 = wp::mul(var_14, var_17);
    var_20 = wp::extract(var_position, var_19);
    // scale[0] * R[1,0], scale[1] * R[1,1], scale[2] * R[1,2], position[1],                  <L 647>
    var_22 = wp::extract(var_scale, var_21);
    var_25 = wp::extract(var_0, var_23, var_24);
    var_26 = wp::mul(var_22, var_25);
    var_28 = wp::extract(var_scale, var_27);
    var_31 = wp::extract(var_0, var_29, var_30);
    var_32 = wp::mul(var_28, var_31);
    var_34 = wp::extract(var_scale, var_33);
    var_37 = wp::extract(var_0, var_35, var_36);
    var_38 = wp::mul(var_34, var_37);
    var_40 = wp::extract(var_position, var_39);
    // scale[0] * R[2,0], scale[1] * R[2,1], scale[2] * R[2,2], position[2],                  <L 648>
    var_42 = wp::extract(var_scale, var_41);
    var_45 = wp::extract(var_0, var_43, var_44);
    var_46 = wp::mul(var_42, var_45);
    var_48 = wp::extract(var_scale, var_47);
    var_51 = wp::extract(var_0, var_49, var_50);
    var_52 = wp::mul(var_48, var_51);
    var_54 = wp::extract(var_scale, var_53);
    var_57 = wp::extract(var_0, var_55, var_56);
    var_58 = wp::mul(var_54, var_57);
    var_60 = wp::extract(var_position, var_59);
    // dtype(0.0), dtype(0.0), dtype(0.0), dtype(1.0),                                        <L 649>
    var_61 = 0.0;
    var_62 = 0.0;
    var_63 = 0.0;
    var_64 = 1.0;
    var_65 = wp::mat_t<4, 4, wp::float64>(var_6, var_12, var_18, var_20, var_26, var_32, var_38, var_40, var_46, var_52, var_58, var_60, var_61, var_62, var_63, var_64);
    return var_65;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/warp/_src/math.py:618
static CUDA_CALLABLE void adj_transform_compose_2(
    wp::vec_t<3, wp::float64> var_position,
    wp::quat_t<wp::float64> var_rotation,
    wp::vec_t<3, wp::float64> var_scale,
    wp::vec_t<3, wp::float64> & adj_position,
    wp::quat_t<wp::float64> & adj_rotation,
    wp::vec_t<3, wp::float64> & adj_scale,
    wp::mat_t<4, 4, wp::float64> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}



extern "C" __global__ void write_transforms_4d12eff0_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::transform_t<wp::float32>> var_xform,
    wp::array_t<wp::vec_t<3, wp::float32>> var_scale,
    wp::int32 var_offset,
    wp::array_t<wp::mat_t<4, 4, wp::float64>> var_m_out)
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
        wp::transform_t<wp::float32>* var_1;
        wp::transform_t<wp::float32> var_2;
        wp::transform_t<wp::float32> var_3;
        wp::vec_t<3, wp::float32>* var_4;
        wp::vec_t<3, wp::float32> var_5;
        wp::vec_t<3, wp::float32> var_6;
        const wp::int32 var_7 = 0;
        wp::float32 var_8;
        wp::float64 var_9;
        const wp::int32 var_10 = 1;
        wp::float32 var_11;
        wp::float64 var_12;
        const wp::int32 var_13 = 2;
        wp::float32 var_14;
        wp::float64 var_15;
        wp::vec_t<3, wp::float64> var_16;
        const wp::int32 var_17 = 3;
        wp::float32 var_18;
        wp::float64 var_19;
        const wp::int32 var_20 = 4;
        wp::float32 var_21;
        wp::float64 var_22;
        const wp::int32 var_23 = 5;
        wp::float32 var_24;
        wp::float64 var_25;
        const wp::int32 var_26 = 6;
        wp::float32 var_27;
        wp::float64 var_28;
        wp::quat_t<wp::float64> var_29;
        const wp::int32 var_30 = 0;
        wp::float32 var_31;
        wp::float64 var_32;
        const wp::int32 var_33 = 1;
        wp::float32 var_34;
        wp::float64 var_35;
        const wp::int32 var_36 = 2;
        wp::float32 var_37;
        wp::float64 var_38;
        wp::vec_t<3, wp::float64> var_39;
        wp::mat_t<4, 4, wp::float64> var_40;
        wp::mat_t<4, 4, wp::float64> var_41;
        wp::int32 var_42;
        //---------
        // forward
        // def write_transforms(xform: wp.array[wp.transform], scale: wp.array[wp.vec3], offset: int, m_out: wp.array[wp.mat44d]):       <L 50>
        // tid = wp.tid()                                                                         <L 51>
        var_0 = builtin_tid1d();
        // xf32 = xform[tid]                                                                      <L 52>
        var_1 = wp::address(var_xform, var_0);
        var_3 = wp::load(var_1);
        var_2 = wp::copy(var_3);
        // sc32 = scale[tid]                                                                      <L 53>
        var_4 = wp::address(var_scale, var_0);
        var_6 = wp::load(var_4);
        var_5 = wp::copy(var_6);
        // p64 = wp.vec3d(wp.float64(xf32[0]), wp.float64(xf32[1]), wp.float64(xf32[2]))          <L 55>
        var_8 = wp::extract(var_2, var_7);
        var_9 = wp::float64(var_8);
        var_11 = wp::extract(var_2, var_10);
        var_12 = wp::float64(var_11);
        var_14 = wp::extract(var_2, var_13);
        var_15 = wp::float64(var_14);
        var_16 = wp::vec_t<3, wp::float64>(var_9, var_12, var_15);
        // q64 = wp.quatd(wp.float64(xf32[3]), wp.float64(xf32[4]), wp.float64(xf32[5]), wp.float64(xf32[6]))       <L 56>
        var_18 = wp::extract(var_2, var_17);
        var_19 = wp::float64(var_18);
        var_21 = wp::extract(var_2, var_20);
        var_22 = wp::float64(var_21);
        var_24 = wp::extract(var_2, var_23);
        var_25 = wp::float64(var_24);
        var_27 = wp::extract(var_2, var_26);
        var_28 = wp::float64(var_27);
        var_29 = wp::quat_t<wp::float64>(var_19, var_22, var_25, var_28);
        // s64 = wp.vec3d(wp.float64(sc32[0]), wp.float64(sc32[1]), wp.float64(sc32[2]))          <L 57>
        var_31 = wp::extract(var_5, var_30);
        var_32 = wp::float64(var_31);
        var_34 = wp::extract(var_5, var_33);
        var_35 = wp::float64(var_34);
        var_37 = wp::extract(var_5, var_36);
        var_38 = wp::float64(var_37);
        var_39 = wp::vec_t<3, wp::float64>(var_32, var_35, var_38);
        // m_out[offset + tid] = wp.transpose(wp.transform_compose(p64, q64, s64))                <L 59>
        var_40 = transform_compose_2(var_16, var_29, var_39);
        var_41 = wp::transpose(var_40);
        var_42 = wp::add(var_offset, var_0);
        wp::array_store(var_m_out, var_42, var_41);
    }
}



extern "C" __global__ void update_and_write_shape_transforms_773f72e7_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::transform_t<wp::float32>> var_shape_xforms,
    wp::array_t<wp::int32> var_shape_parents,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::int32> var_shape_worlds,
    wp::array_t<wp::vec_t<3, wp::float32>> var_world_offsets,
    wp::transform_t<wp::float32> var_layer_xform,
    wp::array_t<wp::vec_t<3, wp::float32>> var_scales,
    wp::int32 var_mat44_offset,
    wp::array_t<wp::mat_t<4, 4, wp::float64>> var_m_out)
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
        wp::transform_t<wp::float32>* var_1;
        wp::transform_t<wp::float32> var_2;
        wp::transform_t<wp::float32> var_3;
        wp::int32* var_4;
        wp::int32 var_5;
        wp::int32 var_6;
        const wp::int32 var_7 = 0;
        bool var_8;
        wp::transform_t<wp::float32>* var_9;
        wp::transform_t<wp::float32> var_10;
        wp::transform_t<wp::float32> var_11;
        wp::transform_t<wp::float32> var_12;
        wp::transform_t<wp::float32> var_13;
        wp::int32* var_14;
        wp::int32 var_15;
        wp::int32 var_16;
        bool var_17;
        const wp::int32 var_18 = 0;
        bool var_19;
        wp::shape_t* var_20;
        const wp::int32 var_21 = 0;
        wp::int32 var_22;
        wp::shape_t var_23;
        bool var_24;
        wp::vec_t<3, wp::float32> var_25;
        wp::vec_t<3, wp::float32>* var_26;
        wp::vec_t<3, wp::float32> var_27;
        wp::vec_t<3, wp::float32> var_28;
        wp::quat_t<wp::float32> var_29;
        wp::transform_t<wp::float32> var_30;
        wp::transform_t<wp::float32> var_31;
        wp::transform_t<wp::float32> var_32;
        wp::transform_t<wp::float32> var_33;
        wp::vec_t<3, wp::float32> var_34;
        wp::quat_t<wp::float32> var_35;
        wp::vec_t<3, wp::float32>* var_36;
        wp::vec_t<3, wp::float32> var_37;
        wp::vec_t<3, wp::float32> var_38;
        const wp::int32 var_39 = 0;
        wp::float32 var_40;
        wp::float64 var_41;
        const wp::int32 var_42 = 1;
        wp::float32 var_43;
        wp::float64 var_44;
        const wp::int32 var_45 = 2;
        wp::float32 var_46;
        wp::float64 var_47;
        wp::vec_t<3, wp::float64> var_48;
        const wp::int32 var_49 = 0;
        wp::float32 var_50;
        wp::float64 var_51;
        const wp::int32 var_52 = 1;
        wp::float32 var_53;
        wp::float64 var_54;
        const wp::int32 var_55 = 2;
        wp::float32 var_56;
        wp::float64 var_57;
        const wp::int32 var_58 = 3;
        wp::float32 var_59;
        wp::float64 var_60;
        wp::quat_t<wp::float64> var_61;
        const wp::int32 var_62 = 0;
        wp::float32 var_63;
        wp::float64 var_64;
        const wp::int32 var_65 = 1;
        wp::float32 var_66;
        wp::float64 var_67;
        const wp::int32 var_68 = 2;
        wp::float32 var_69;
        wp::float64 var_70;
        wp::vec_t<3, wp::float64> var_71;
        wp::mat_t<4, 4, wp::float64> var_72;
        wp::mat_t<4, 4, wp::float64> var_73;
        wp::int32 var_74;
        //---------
        // forward
        // def update_and_write_shape_transforms(                                                 <L 63>
        // tid = wp.tid()                                                                         <L 79>
        var_0 = builtin_tid1d();
        // xf = shape_xforms[tid]                                                                 <L 80>
        var_1 = wp::address(var_shape_xforms, var_0);
        var_3 = wp::load(var_1);
        var_2 = wp::copy(var_3);
        // parent = shape_parents[tid]                                                            <L 81>
        var_4 = wp::address(var_shape_parents, var_0);
        var_6 = wp::load(var_4);
        var_5 = wp::copy(var_6);
        // if parent >= 0:                                                                        <L 82>
        var_8 = (var_5 >= var_7);
        if (var_8) {
            // world_xf = wp.transform_multiply(body_q[parent], xf)                               <L 83>
            var_9 = wp::address(var_body_q, var_5);
            var_11 = wp::load(var_9);
            var_10 = wp::transform_multiply(var_11, var_2);
        }
        if (!var_8) {
            // world_xf = xf                                                                      <L 85>
            var_12 = wp::copy(var_2);
        }
        var_13 = wp::where(var_8, var_10, var_12);
        // if world_offsets:                                                                      <L 86>
        if (var_world_offsets) {
            // w = shape_worlds[tid]                                                              <L 87>
            var_14 = wp::address(var_shape_worlds, var_0);
            var_16 = wp::load(var_14);
            var_15 = wp::copy(var_16);
            // if w >= 0 and w < world_offsets.shape[0]:                                          <L 88>
            var_19 = (var_15 >= var_18);
            var_17 = var_19;
            if (var_17) {
                var_20 = &(var_world_offsets.shape);
                var_23 = wp::load(var_20);
                var_22 = wp::extract(var_23, var_21);
                var_24 = (var_15 < var_22);
                var_17 = var_17 && var_24;
            }
            if (var_17) {
                // world_xf = wp.transform(world_xf.p + world_offsets[w], world_xf.q)             <L 89>
                var_25 = wp::transform_get_translation(var_13);
                var_26 = wp::address(var_world_offsets, var_15);
                var_28 = wp::load(var_26);
                var_27 = wp::add(var_25, var_28);
                var_29 = wp::transform_get_rotation(var_13);
                var_30 = wp::transform_t<wp::float32>(var_27, var_29);
            }
            var_31 = wp::where(var_17, var_30, var_13);
        }
        var_32 = wp::where(var_world_offsets, var_31, var_13);
        // world_xf = wp.transform_multiply(layer_xform, world_xf)                                <L 90>
        var_33 = wp::transform_multiply(var_layer_xform, var_32);
        // p = world_xf.p                                                                         <L 92>
        var_34 = wp::transform_get_translation(var_33);
        // q = world_xf.q                                                                         <L 93>
        var_35 = wp::transform_get_rotation(var_33);
        // sc = scales[tid]                                                                       <L 94>
        var_36 = wp::address(var_scales, var_0);
        var_38 = wp::load(var_36);
        var_37 = wp::copy(var_38);
        // p64 = wp.vec3d(wp.float64(p[0]), wp.float64(p[1]), wp.float64(p[2]))                   <L 95>
        var_40 = wp::extract(var_34, var_39);
        var_41 = wp::float64(var_40);
        var_43 = wp::extract(var_34, var_42);
        var_44 = wp::float64(var_43);
        var_46 = wp::extract(var_34, var_45);
        var_47 = wp::float64(var_46);
        var_48 = wp::vec_t<3, wp::float64>(var_41, var_44, var_47);
        // q64 = wp.quatd(wp.float64(q[0]), wp.float64(q[1]), wp.float64(q[2]), wp.float64(q[3]))       <L 96>
        var_50 = wp::extract(var_35, var_49);
        var_51 = wp::float64(var_50);
        var_53 = wp::extract(var_35, var_52);
        var_54 = wp::float64(var_53);
        var_56 = wp::extract(var_35, var_55);
        var_57 = wp::float64(var_56);
        var_59 = wp::extract(var_35, var_58);
        var_60 = wp::float64(var_59);
        var_61 = wp::quat_t<wp::float64>(var_51, var_54, var_57, var_60);
        // s64 = wp.vec3d(wp.float64(sc[0]), wp.float64(sc[1]), wp.float64(sc[2]))                <L 97>
        var_63 = wp::extract(var_37, var_62);
        var_64 = wp::float64(var_63);
        var_66 = wp::extract(var_37, var_65);
        var_67 = wp::float64(var_66);
        var_69 = wp::extract(var_37, var_68);
        var_70 = wp::float64(var_69);
        var_71 = wp::vec_t<3, wp::float64>(var_64, var_67, var_70);
        // m_out[mat44_offset + tid] = wp.transpose(wp.transform_compose(p64, q64, s64))          <L 99>
        var_72 = transform_compose_2(var_48, var_61, var_71);
        var_73 = wp::transpose(var_72);
        var_74 = wp::add(var_mat44_offset, var_0);
        wp::array_store(var_m_out, var_74, var_73);
    }
}

