#define WP_NO_BFLOAT16

#define WP_TILE_BLOCK_DIM 32
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

extern "C" {
void dot_41_41_209_89_32_0_1_1_5_5_5_0(wp::float32*, wp::float32*, wp::float32*, wp::float32*, wp::float32*);
void dot_41_209_41_89_32_1_0_0_5_5_5_0(wp::float32*, wp::float32*, wp::float32*, wp::float32*, wp::float32*);
void dot_209_41_41_89_32_1_1_1_5_5_5_0(wp::float32*, wp::float32*, wp::float32*, wp::float32*, wp::float32*);
void dot_41_1_209_89_32_0_1_1_5_5_5_0(wp::float32*, wp::float32*, wp::float32*, wp::float32*, wp::float32*);
void dot_41_209_1_89_32_1_0_0_5_5_5_0(wp::float32*, wp::float32*, wp::float32*, wp::float32*, wp::float32*);
void dot_209_1_41_89_32_1_1_1_5_5_5_0(wp::float32*, wp::float32*, wp::float32*, wp::float32*, wp::float32*);
void potrf_41_41_1_89_32_1_1_5_x_x_1(wp::float32*, int*);
void dot_41_41_41_89_32_0_1_1_5_5_5_0(wp::float32*, wp::float32*, wp::float32*, wp::float32*, wp::float32*);
void trsm_41_41_1_89_32_0_1_5_0_1_0(wp::float32*, wp::float32*);
void potrs_41_41_1_89_32_1_1_5_x_x_1(wp::float32*, wp::float32*);
}


extern "C" __global__ void _lm_solve_tiled_41_209_606e6a58_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::float32> var_jacobians,
    wp::array_t<wp::float32> var_residuals,
    wp::array_t<wp::float32> var_lambda_values,
    wp::array_t<wp::float32> var_dq_dof,
    wp::array_t<wp::float32> var_pred_reduction_out)
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
        const wp::int32 var_1 = 209;
        const wp::int32 var_2 = 41;
        wp::slice_t var_3;
        const wp::int32 var_4 = 0;
        wp::array_t<wp::float32> var_5;
        wp::tuple_t<wp::int32, wp::int32> var_6;
        wp::tile_shared_t<wp::float32,wp::tile_layout_strided_t<wp::tile_shape_t<209,41>, wp::tile_stride_t<41,1>>, true> var_7 = wp::tile_alloc_empty<wp::float32,wp::tile_shape_t<209,41>,wp::tile_stride_t<41,1>,false>();
        const wp::int32 var_8 = 0;
        const wp::int32 var_9 = 0;
        wp::slice_t var_10;
        const wp::int32 var_11 = 0;
        wp::array_t<wp::float32> var_12;
        const wp::int32 var_13 = 1;
        wp::tuple_t<wp::int32, wp::int32> var_14;
        wp::tile_shared_t<wp::float32,wp::tile_layout_strided_t<wp::tile_shape_t<209,1>, wp::tile_stride_t<1,1>>, true> var_15 = wp::tile_alloc_empty<wp::float32,wp::tile_shape_t<209,1>,wp::tile_stride_t<1,1>,false>();
        const wp::int32 var_16 = 0;
        const wp::int32 var_17 = 0;
        wp::float32* var_18;
        wp::float32 var_19;
        wp::float32 var_20;
        wp::tile_shared_t<wp::float32,wp::tile_layout_strided_t<wp::tile_shape_t<41,209>, wp::tile_stride_t<1,41>>, false> var_21 = nullptr;
        wp::tuple_t<wp::int32, wp::int32> var_22;
        wp::tile_shared_t<wp::float32,wp::tile_layout_strided_t<wp::tile_shape_t<41,41>, wp::tile_stride_t<41,1>>, true> var_23 = wp::tile_alloc_empty<wp::float32,wp::tile_shape_t<41,41>,wp::tile_stride_t<41,1>,false>();
        const wp::float32 var_24 = 1.0;
        const wp::float32 var_25 = 1.0;
        wp::tuple_t<wp::int32> var_26;
        wp::tile_shared_t<wp::float32,wp::tile_layout_strided_t<wp::tile_shape_t<41>, wp::tile_stride_t<1>>, true> var_27 = wp::tile_alloc_empty<wp::float32,wp::tile_shape_t<41>,wp::tile_stride_t<1>,false>();
        const wp::int32 var_28 = 41;
        wp::range_t var_29;
        wp::int32 var_30;
        const wp::int32 var_31 = 0;
        const wp::int32 var_32 = 41;
        bool var_33;
        wp::int32 var_34;
        wp::int32 var_35;
        wp::tile_shared_t<wp::float32,wp::tile_layout_strided_t<wp::tile_shape_t<41,41>, wp::tile_stride_t<41,1>>, true> var_36 = wp::tile_alloc_empty<wp::float32,wp::tile_shape_t<41,41>,wp::tile_stride_t<41,1>,false>();
        wp::tuple_t<wp::int32> var_37;
        wp::tile_shared_t<wp::float32,wp::tile_layout_strided_t<wp::tile_shape_t<41>, wp::tile_stride_t<1>>, true> var_38 = wp::tile_alloc_empty<wp::float32,wp::tile_shape_t<41>,wp::tile_stride_t<1>,false>();
        const wp::int32 var_39 = 1;
        wp::tuple_t<wp::int32, wp::int32> var_40;
        wp::tile_shared_t<wp::float32,wp::tile_layout_strided_t<wp::tile_shape_t<41,1>, wp::tile_stride_t<1,1>>, true> var_41 = wp::tile_alloc_empty<wp::float32,wp::tile_shape_t<41,1>,wp::tile_stride_t<1,1>,false>();
        const wp::float32 var_42 = 1.0;
        const wp::float32 var_43 = 1.0;
        const wp::int32 var_44 = 41;
        wp::range_t var_45;
        wp::int32 var_46;
        const wp::int32 var_47 = 0;
        const wp::int32 var_48 = 41;
        bool var_49;
        wp::int32 var_50;
        wp::int32 var_51;
        const wp::int32 var_52 = 0;
        wp::float32 var_53;
        const wp::int32 var_54 = 0;
        const wp::int32 var_55 = 41;
        bool var_56;
        wp::int32 var_57;
        wp::int32 var_58;
        wp::tile_shared_t<wp::float32,wp::tile_layout_strided_t<wp::tile_shape_t<41>, wp::tile_stride_t<1>>, true> var_59 = wp::tile_alloc_empty<wp::float32,wp::tile_shape_t<41>,wp::tile_stride_t<1>,false>();
        wp::tile_shared_t<wp::float32,wp::tile_layout_strided_t<wp::tile_shape_t<41,41>, wp::tile_stride_t<41,1>>, true> var_60 = wp::tile_alloc_empty<wp::float32,wp::tile_shape_t<41,41>,wp::tile_stride_t<41,1>,false>();
        wp::tile_shared_t<wp::float32,wp::tile_layout_strided_t<wp::tile_shape_t<41>, wp::tile_stride_t<1>>, true> var_61 = wp::tile_alloc_empty<wp::float32,wp::tile_shape_t<41>,wp::tile_stride_t<1>,false>();
        wp::slice_t var_62;
        const wp::int32 var_63 = 0;
        wp::array_t<wp::float32> var_64;
        const wp::int32 var_65 = 0;
        wp::tuple_t<wp::int32> var_66;
        wp::tile_shared_t<wp::float32,wp::tile_layout_strided_t<wp::tile_shape_t<41>, wp::tile_stride_t<1>>, true> var_67 = wp::tile_alloc_empty<wp::float32,wp::tile_shape_t<41>,wp::tile_stride_t<1>,false>();
        const wp::int32 var_68 = 41;
        wp::range_t var_69;
        wp::int32 var_70;
        const wp::int32 var_71 = 0;
        const wp::int32 var_72 = 41;
        bool var_73;
        wp::int32 var_74;
        wp::int32 var_75;
        wp::float32 var_76;
        wp::float32 var_77;
        const wp::int32 var_78 = 0;
        const wp::int32 var_79 = 41;
        bool var_80;
        wp::int32 var_81;
        wp::int32 var_82;
        wp::tile_register_t<wp::float32,wp::tile_layout_register_t<wp::tile_shape_t<41>>> var_83 = wp::tile_register_t<wp::float32,wp::tile_layout_register_t<wp::tile_shape_t<41>>>{};
        wp::tile_register_t<wp::float32,wp::tile_layout_register_t<wp::tile_shape_t<41>>> var_84 = wp::tile_register_t<wp::float32,wp::tile_layout_register_t<wp::tile_shape_t<41>>>{};
        wp::tile_shared_t<wp::float32,wp::tile_layout_strided_t<wp::tile_shape_t<1>, wp::tile_stride_t<1>>, true> var_85 = wp::tile_alloc_empty<wp::float32,wp::tile_shape_t<1>,wp::tile_stride_t<1>,false>();
        const wp::int32 var_86 = 0;
        wp::float32 var_87;
        const wp::float32 var_88 = 0.5;
        wp::float32 var_89;
        //---------
        // forward
        // def _template(                                                                         <L 745>
        // row = wp.tid()                                                                         <L 753>
        var_0 = builtin_tid1d();
        // RES = _Specialized.TILE_N_RESIDUALS                                                    <L 755>
        // DOF = _Specialized.TILE_N_DOFS                                                         <L 756>
        // J = wp.tile_load(jacobians[row], shape=(RES, DOF))                                     <L 757>
        var_3 = wp::slice_t(var_0, var_0, var_4);
        var_5 = wp::view(var_jacobians, var_3);
        var_6 = wp::tuple(var_1, var_2);
        var_7 = wp::tile_load<wp::float32, true, false, 209, 41>(var_5, var_8, var_9);
        // r = wp.tile_load(residuals[row], shape=(RES, 1))                                       <L 758>
        var_10 = wp::slice_t(var_0, var_0, var_11);
        var_12 = wp::view(var_residuals, var_10);
        var_14 = wp::tuple(var_1, var_13);
        var_15 = wp::tile_load<wp::float32, true, false, 209, 1>(var_12, var_16, var_17);
        // lam = lambda_values[row]                                                               <L 759>
        var_18 = wp::address(var_lambda_values, var_0);
        var_20 = wp::load(var_18);
        var_19 = wp::copy(var_20);
        // Jt = wp.tile_transpose(J)                                                              <L 761>
        var_21 = wp::tile_transpose(var_7);
        // JtJ = wp.tile_zeros(shape=(DOF, DOF), dtype=wp.float32)                                <L 762>
        var_22 = wp::tuple(var_2, var_2);
        var_23 = wp::tile_zeros<wp::float32, 41, 41>();
        // wp.tile_matmul(Jt, J, JtJ)                                                             <L 763>
        wp::tile_matmul_acc(dot_41_41_209_89_32_0_1_1_5_5_5_0, dot_41_209_41_89_32_1_0_0_5_5_5_0, dot_209_41_41_89_32_1_1_1_5_5_5_0, var_21, var_7, var_23, var_24, var_25);
        // diag = wp.tile_zeros(shape=(DOF,), dtype=wp.float32)                                   <L 765>
        var_26 = wp::tuple(var_2);
        var_27 = wp::tile_zeros<wp::float32, 41>();
        // for i in range(DOF):                                                                   <L 766>
        var_29 = wp::range(var_28);
        start_for_0:;
            if (iter_cmp(var_29) == 0) goto end_for_0;
            var_30 = wp::iter_next(var_29);
            // diag[i] = lam                                                                      <L 767>
            var_33 = (var_30 < var_31);
            var_34 = wp::add(var_30, var_32);
            var_35 = wp::where(var_33, var_34, var_30);
            wp::assign(var_27, var_35, var_19);
            goto start_for_0;
        end_for_0:;
        // A = wp.tile_diag_add(JtJ, diag)                                                        <L 768>
        var_36 = wp::tile_diag_add(var_23, var_27, var_36);
        // g = wp.tile_zeros(shape=(DOF,), dtype=wp.float32)                                      <L 769>
        var_37 = wp::tuple(var_2);
        var_38 = wp::tile_zeros<wp::float32, 41>();
        // tmp2d = wp.tile_zeros(shape=(DOF, 1), dtype=wp.float32)                                <L 770>
        var_40 = wp::tuple(var_2, var_39);
        var_41 = wp::tile_zeros<wp::float32, 41, 1>();
        // wp.tile_matmul(Jt, r, tmp2d)                                                           <L 771>
        wp::tile_matmul_acc(dot_41_1_209_89_32_0_1_1_5_5_5_0, dot_41_209_1_89_32_1_0_0_5_5_5_0, dot_209_1_41_89_32_1_1_1_5_5_5_0, var_21, var_15, var_41, var_42, var_43);
        // for i in range(DOF):                                                                   <L 772>
        var_45 = wp::range(var_44);
        start_for_2:;
            if (iter_cmp(var_45) == 0) goto end_for_2;
            var_46 = wp::iter_next(var_45);
            // g[i] = tmp2d[i, 0]                                                                 <L 773>
            var_49 = (var_46 < var_47);
            var_50 = wp::add(var_46, var_48);
            var_51 = wp::where(var_49, var_50, var_46);
            var_53 = wp::tile_extract(var_41, var_51, var_52);
            var_56 = (var_46 < var_54);
            var_57 = wp::add(var_46, var_55);
            var_58 = wp::where(var_56, var_57, var_46);
            wp::assign(var_38, var_58, var_53);
            goto start_for_2;
        end_for_2:;
        // rhs = wp.tile_map(wp.neg, g)                                                           <L 775>
        var_59 = wp::tile_unary_map(wp::neg, var_38);
        // L = wp.tile_cholesky(A)                                                                <L 776>
        var_60 = wp::tile_cholesky<false>(potrf_41_41_1_89_32_1_1_5_x_x_1, dot_41_41_41_89_32_0_1_1_5_5_5_0, trsm_41_41_1_89_32_0_1_5_0_1_0, var_36, var_60);
        // delta = wp.tile_cholesky_solve(L, rhs)                                                 <L 777>
        var_61 = wp::tile_cholesky_solve<false>(potrs_41_41_1_89_32_1_1_5_x_x_1, var_60, var_59, var_61);
        // wp.tile_store(dq_dof[row], delta)                                                      <L 778>
        var_62 = wp::slice_t(var_0, var_0, var_63);
        var_64 = wp::view(var_dq_dof, var_62);
        wp::tile_store<wp::float32, true, false>(var_64, var_65, var_61);
        // lambda_delta = wp.tile_zeros(shape=(DOF,), dtype=wp.float32)                           <L 779>
        var_66 = wp::tuple(var_2);
        var_67 = wp::tile_zeros<wp::float32, 41>();
        // for i in range(DOF):                                                                   <L 780>
        var_69 = wp::range(var_68);
        start_for_4:;
            if (iter_cmp(var_69) == 0) goto end_for_4;
            var_70 = wp::iter_next(var_69);
            // lambda_delta[i] = lam * delta[i]                                                   <L 781>
            var_73 = (var_70 < var_71);
            var_74 = wp::add(var_70, var_72);
            var_75 = wp::where(var_73, var_74, var_70);
            var_76 = wp::tile_extract(var_61, var_75);
            var_77 = wp::mul(var_19, var_76);
            var_80 = (var_70 < var_78);
            var_81 = wp::add(var_70, var_79);
            var_82 = wp::where(var_80, var_81, var_70);
            wp::assign(var_67, var_82, var_77);
            goto start_for_4;
        end_for_4:;
        // diff = wp.tile_map(wp.sub, lambda_delta, g)                                            <L 783>
        var_83 = wp::tile_binary_map(wp::sub, var_67, var_38);
        // prod = wp.tile_map(wp.mul, delta, diff)                                                <L 784>
        var_84 = wp::tile_binary_map(wp::mul, var_61, var_83);
        // red = wp.tile_sum(prod)[0]                                                             <L 785>
        var_85 = wp::tile_sum(var_84);
        var_87 = wp::tile_extract(var_85, var_86);
        // pred_reduction_out[row] = 0.5 * red                                                    <L 786>
        var_89 = wp::mul(var_88, var_87);
        wp::array_store(var_pred_reduction_out, var_0, var_89);
    }
}

