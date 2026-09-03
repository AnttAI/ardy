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




struct GenericShapeData_f25f19f5
{
    wp::int32 shape_type;
    wp::vec_t<3, wp::float32> scale;
    wp::vec_t<3, wp::float32> auxiliary;
    wp::vec_t<3, wp::float32> center;


    GenericShapeData_f25f19f5() = default;
    CUDA_CALLABLE GenericShapeData_f25f19f5(wp::int32 const& shape_type,
    wp::vec_t<3, wp::float32> const& scale = {},
    wp::vec_t<3, wp::float32> const& auxiliary = {},
    wp::vec_t<3, wp::float32> const& center = {})
        : shape_type{shape_type}
        , scale{scale}
        , auxiliary{auxiliary}
        , center{center}

    {
    }

    CUDA_CALLABLE GenericShapeData_f25f19f5& operator += (const GenericShapeData_f25f19f5& rhs)
    {    shape_type += rhs.shape_type;
    scale += rhs.scale;
    auxiliary += rhs.auxiliary;
    center += rhs.center;

        return *this;}

};

static CUDA_CALLABLE void adj_GenericShapeData_f25f19f5(wp::int32 const&,
    wp::vec_t<3, wp::float32> const&,
    wp::vec_t<3, wp::float32> const&,
    wp::vec_t<3, wp::float32> const&,
    wp::int32 & adj_shape_type,
    wp::vec_t<3, wp::float32> & adj_scale,
    wp::vec_t<3, wp::float32> & adj_auxiliary,
    wp::vec_t<3, wp::float32> & adj_center,
    GenericShapeData_f25f19f5 & adj_ret)
{
    adj_shape_type += adj_ret.shape_type;
    adj_scale += adj_ret.scale;
    adj_auxiliary += adj_ret.auxiliary;
    adj_center += adj_ret.center;
}

// Required when compiling adjoints.
CUDA_CALLABLE GenericShapeData_f25f19f5 add(const GenericShapeData_f25f19f5& a, const GenericShapeData_f25f19f5& b)
{
    return GenericShapeData_f25f19f5();
}

CUDA_CALLABLE void adj_atomic_add(GenericShapeData_f25f19f5* p, GenericShapeData_f25f19f5 t)
{
    wp::adj_atomic_add(&p->shape_type, t.shape_type);
    wp::adj_atomic_add(&p->scale, t.scale);
    wp::adj_atomic_add(&p->auxiliary, t.auxiliary);
    wp::adj_atomic_add(&p->center, t.center);
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




// /home/jony/Downloads/newton/repos/newton/newton/_src/utils/heightfield.py:366
static CUDA_CALLABLE void heightfield_vs_convex_midphase_0(
    wp::int32 var_hfield_shape,
    wp::int32 var_other_shape,
    HeightfieldData_f2b8d59a var_hfd,
    wp::array_t<wp::transform_t<wp::float32>> var_shape_transform,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_collision_aabb_lower,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_collision_aabb_upper,
    wp::array_t<wp::vec_t<4, wp::float32>> var_shape_data,
    wp::array_t<wp::float32> var_shape_gap,
    wp::array_t<wp::vec_t<3, wp::int32>> var_triangle_pairs,
    wp::array_t<wp::int32> var_triangle_pairs_count)
{
    //---------
    // primal vars
    wp::transform_t<wp::float32>* var_0;
    wp::transform_t<wp::float32> var_1;
    wp::transform_t<wp::float32> var_2;
    wp::transform_t<wp::float32>* var_3;
    wp::transform_t<wp::float32> var_4;
    wp::transform_t<wp::float32> var_5;
    wp::transform_t<wp::float32> var_6;
    wp::transform_t<wp::float32> var_7;
    wp::vec_t<3, wp::float32> var_8;
    wp::quat_t<wp::float32> var_9;
    wp::vec_t<3, wp::float32>* var_10;
    wp::vec_t<3, wp::float32> var_11;
    wp::vec_t<3, wp::float32> var_12;
    wp::vec_t<3, wp::float32>* var_13;
    wp::vec_t<3, wp::float32> var_14;
    wp::vec_t<3, wp::float32> var_15;
    const wp::float32 var_16 = 0.5;
    wp::vec_t<3, wp::float32> var_17;
    wp::vec_t<3, wp::float32> var_18;
    const wp::float32 var_19 = 0.5;
    wp::vec_t<3, wp::float32> var_20;
    wp::vec_t<3, wp::float32> var_21;
    wp::vec_t<3, wp::float32> var_22;
    wp::vec_t<3, wp::float32> var_23;
    const wp::float32 var_24 = 1.0;
    const wp::float32 var_25 = 0.0;
    const wp::float32 var_26 = 0.0;
    wp::vec_t<3, wp::float32> var_27;
    wp::vec_t<3, wp::float32> var_28;
    const wp::float32 var_29 = 0.0;
    const wp::float32 var_30 = 1.0;
    const wp::float32 var_31 = 0.0;
    wp::vec_t<3, wp::float32> var_32;
    wp::vec_t<3, wp::float32> var_33;
    const wp::float32 var_34 = 0.0;
    const wp::float32 var_35 = 0.0;
    const wp::float32 var_36 = 1.0;
    wp::vec_t<3, wp::float32> var_37;
    wp::vec_t<3, wp::float32> var_38;
    const wp::int32 var_39 = 0;
    wp::float32 var_40;
    wp::float32 var_41;
    const wp::int32 var_42 = 0;
    wp::float32 var_43;
    wp::float32 var_44;
    const wp::int32 var_45 = 0;
    wp::float32 var_46;
    wp::float32 var_47;
    const wp::int32 var_48 = 1;
    wp::float32 var_49;
    wp::float32 var_50;
    wp::float32 var_51;
    const wp::int32 var_52 = 0;
    wp::float32 var_53;
    wp::float32 var_54;
    const wp::int32 var_55 = 2;
    wp::float32 var_56;
    wp::float32 var_57;
    wp::float32 var_58;
    const wp::int32 var_59 = 1;
    wp::float32 var_60;
    wp::float32 var_61;
    const wp::int32 var_62 = 0;
    wp::float32 var_63;
    wp::float32 var_64;
    const wp::int32 var_65 = 1;
    wp::float32 var_66;
    wp::float32 var_67;
    const wp::int32 var_68 = 1;
    wp::float32 var_69;
    wp::float32 var_70;
    wp::float32 var_71;
    const wp::int32 var_72 = 1;
    wp::float32 var_73;
    wp::float32 var_74;
    const wp::int32 var_75 = 2;
    wp::float32 var_76;
    wp::float32 var_77;
    wp::float32 var_78;
    const wp::int32 var_79 = 2;
    wp::float32 var_80;
    wp::float32 var_81;
    const wp::int32 var_82 = 0;
    wp::float32 var_83;
    wp::float32 var_84;
    const wp::int32 var_85 = 2;
    wp::float32 var_86;
    wp::float32 var_87;
    const wp::int32 var_88 = 1;
    wp::float32 var_89;
    wp::float32 var_90;
    wp::float32 var_91;
    const wp::int32 var_92 = 2;
    wp::float32 var_93;
    wp::float32 var_94;
    const wp::int32 var_95 = 2;
    wp::float32 var_96;
    wp::float32 var_97;
    wp::float32 var_98;
    wp::vec_t<3, wp::float32> var_99;
    wp::float32* var_100;
    wp::float32* var_101;
    wp::float32 var_102;
    wp::float32 var_103;
    wp::float32 var_104;
    wp::vec_t<4, wp::float32>* var_105;
    const wp::int32 var_106 = 3;
    wp::float32 var_107;
    wp::vec_t<4, wp::float32> var_108;
    wp::vec_t<4, wp::float32>* var_109;
    const wp::int32 var_110 = 3;
    wp::float32 var_111;
    wp::vec_t<4, wp::float32> var_112;
    wp::float32 var_113;
    wp::float32 var_114;
    wp::vec_t<3, wp::float32> var_115;
    wp::vec_t<3, wp::float32> var_116;
    wp::vec_t<3, wp::float32> var_117;
    wp::vec_t<3, wp::float32> var_118;
    wp::vec_t<3, wp::float32> var_119;
    const wp::float32 var_120 = 2.0;
    wp::float32* var_121;
    wp::float32 var_122;
    wp::float32 var_123;
    wp::int32* var_124;
    const wp::int32 var_125 = 1;
    wp::int32 var_126;
    wp::int32 var_127;
    wp::float32 var_128;
    wp::float32 var_129;
    const wp::float32 var_130 = 2.0;
    wp::float32* var_131;
    wp::float32 var_132;
    wp::float32 var_133;
    wp::int32* var_134;
    const wp::int32 var_135 = 1;
    wp::int32 var_136;
    wp::int32 var_137;
    wp::float32 var_138;
    wp::float32 var_139;
    const wp::int32 var_140 = 0;
    wp::float32 var_141;
    wp::float32* var_142;
    wp::float32 var_143;
    wp::float32 var_144;
    wp::float32 var_145;
    const wp::int32 var_146 = 0;
    wp::float32 var_147;
    wp::float32* var_148;
    wp::float32 var_149;
    wp::float32 var_150;
    wp::float32 var_151;
    const wp::int32 var_152 = 1;
    wp::float32 var_153;
    wp::float32* var_154;
    wp::float32 var_155;
    wp::float32 var_156;
    wp::float32 var_157;
    const wp::int32 var_158 = 1;
    wp::float32 var_159;
    wp::float32* var_160;
    wp::float32 var_161;
    wp::float32 var_162;
    wp::float32 var_163;
    wp::float32 var_164;
    wp::int32 var_165;
    const wp::int32 var_166 = 0;
    wp::int32 var_167;
    wp::float32 var_168;
    wp::int32 var_169;
    wp::int32* var_170;
    const wp::int32 var_171 = 2;
    wp::int32 var_172;
    wp::int32 var_173;
    wp::int32 var_174;
    wp::float32 var_175;
    wp::int32 var_176;
    const wp::int32 var_177 = 0;
    wp::int32 var_178;
    wp::float32 var_179;
    wp::int32 var_180;
    wp::int32* var_181;
    const wp::int32 var_182 = 2;
    wp::int32 var_183;
    wp::int32 var_184;
    wp::int32 var_185;
    wp::int32* var_186;
    const wp::int32 var_187 = 1;
    wp::int32 var_188;
    wp::int32 var_189;
    const wp::int32 var_190 = 1;
    wp::int32 var_191;
    wp::range_t var_192;
    wp::int32 var_193;
    const wp::int32 var_194 = 1;
    wp::int32 var_195;
    wp::range_t var_196;
    wp::int32 var_197;
    const wp::int32 var_198 = 0;
    wp::int32 var_199;
    wp::int32 var_200;
    const wp::int32 var_201 = 2;
    wp::int32 var_202;
    wp::int32 var_203;
    const wp::int32 var_204 = 0;
    const wp::int32 var_205 = 1;
    wp::int32 var_206;
    wp::shape_t* var_207;
    const wp::int32 var_208 = 0;
    wp::int32 var_209;
    wp::shape_t var_210;
    bool var_211;
    wp::vec_t<3, wp::int32> var_212;
    const wp::int32 var_213 = 1;
    wp::int32 var_214;
    wp::int32 var_215;
    const wp::int32 var_216 = 2;
    wp::int32 var_217;
    wp::int32 var_218;
    const wp::int32 var_219 = 0;
    const wp::int32 var_220 = 1;
    wp::int32 var_221;
    wp::shape_t* var_222;
    const wp::int32 var_223 = 0;
    wp::int32 var_224;
    wp::shape_t var_225;
    bool var_226;
    wp::vec_t<3, wp::int32> var_227;
    //---------
    // forward
    // def heightfield_vs_convex_midphase(                                                    <L 367>
    // X_hfield_ws = shape_transform[hfield_shape]                                            <L 407>
    var_0 = wp::address(var_shape_transform, var_hfield_shape);
    var_2 = wp::load(var_0);
    var_1 = wp::copy(var_2);
    // X_other_ws = shape_transform[other_shape]                                              <L 408>
    var_3 = wp::address(var_shape_transform, var_other_shape);
    var_5 = wp::load(var_3);
    var_4 = wp::copy(var_5);
    // X_other_in_hfield = wp.transform_multiply(wp.transform_inverse(X_hfield_ws), X_other_ws)       <L 409>
    var_6 = wp::transform_inverse(var_1);
    var_7 = wp::transform_multiply(var_6, var_4);
    // other_pos = wp.transform_get_translation(X_other_in_hfield)                            <L 411>
    var_8 = wp::transform_get_translation(var_7);
    // other_rot = wp.transform_get_rotation(X_other_in_hfield)                               <L 412>
    var_9 = wp::transform_get_rotation(var_7);
    // local_lo = shape_collision_aabb_lower[other_shape]                                     <L 414>
    var_10 = wp::address(var_shape_collision_aabb_lower, var_other_shape);
    var_12 = wp::load(var_10);
    var_11 = wp::copy(var_12);
    // local_hi = shape_collision_aabb_upper[other_shape]                                     <L 415>
    var_13 = wp::address(var_shape_collision_aabb_upper, var_other_shape);
    var_15 = wp::load(var_13);
    var_14 = wp::copy(var_15);
    // local_center = 0.5 * (local_lo + local_hi)                                             <L 416>
    var_17 = wp::add(var_11, var_14);
    var_18 = wp::mul(var_16, var_17);
    // local_half = 0.5 * (local_hi - local_lo)                                               <L 417>
    var_20 = wp::sub(var_14, var_11);
    var_21 = wp::mul(var_19, var_20);
    // center_in_hfield = wp.quat_rotate(other_rot, local_center) + other_pos                 <L 419>
    var_22 = wp::quat_rotate(var_9, var_18);
    var_23 = wp::add(var_22, var_8);
    // r0 = wp.quat_rotate(other_rot, wp.vec3(1.0, 0.0, 0.0))                                 <L 424>
    var_27 = wp::vec_t<3, wp::float32>(var_24, var_25, var_26);
    var_28 = wp::quat_rotate(var_9, var_27);
    // r1 = wp.quat_rotate(other_rot, wp.vec3(0.0, 1.0, 0.0))                                 <L 425>
    var_32 = wp::vec_t<3, wp::float32>(var_29, var_30, var_31);
    var_33 = wp::quat_rotate(var_9, var_32);
    // r2 = wp.quat_rotate(other_rot, wp.vec3(0.0, 0.0, 1.0))                                 <L 426>
    var_37 = wp::vec_t<3, wp::float32>(var_34, var_35, var_36);
    var_38 = wp::quat_rotate(var_9, var_37);
    // half_in_hfield = wp.vec3(                                                              <L 427>
    // wp.abs(r0[0]) * local_half[0] + wp.abs(r1[0]) * local_half[1] + wp.abs(r2[0]) * local_half[2],       <L 428>
    var_40 = wp::extract(var_28, var_39);
    var_41 = wp::abs(var_40);
    var_43 = wp::extract(var_21, var_42);
    var_44 = wp::mul(var_41, var_43);
    var_46 = wp::extract(var_33, var_45);
    var_47 = wp::abs(var_46);
    var_49 = wp::extract(var_21, var_48);
    var_50 = wp::mul(var_47, var_49);
    var_51 = wp::add(var_44, var_50);
    var_53 = wp::extract(var_38, var_52);
    var_54 = wp::abs(var_53);
    var_56 = wp::extract(var_21, var_55);
    var_57 = wp::mul(var_54, var_56);
    var_58 = wp::add(var_51, var_57);
    // wp.abs(r0[1]) * local_half[0] + wp.abs(r1[1]) * local_half[1] + wp.abs(r2[1]) * local_half[2],       <L 429>
    var_60 = wp::extract(var_28, var_59);
    var_61 = wp::abs(var_60);
    var_63 = wp::extract(var_21, var_62);
    var_64 = wp::mul(var_61, var_63);
    var_66 = wp::extract(var_33, var_65);
    var_67 = wp::abs(var_66);
    var_69 = wp::extract(var_21, var_68);
    var_70 = wp::mul(var_67, var_69);
    var_71 = wp::add(var_64, var_70);
    var_73 = wp::extract(var_38, var_72);
    var_74 = wp::abs(var_73);
    var_76 = wp::extract(var_21, var_75);
    var_77 = wp::mul(var_74, var_76);
    var_78 = wp::add(var_71, var_77);
    // wp.abs(r0[2]) * local_half[0] + wp.abs(r1[2]) * local_half[1] + wp.abs(r2[2]) * local_half[2],       <L 430>
    var_80 = wp::extract(var_28, var_79);
    var_81 = wp::abs(var_80);
    var_83 = wp::extract(var_21, var_82);
    var_84 = wp::mul(var_81, var_83);
    var_86 = wp::extract(var_33, var_85);
    var_87 = wp::abs(var_86);
    var_89 = wp::extract(var_21, var_88);
    var_90 = wp::mul(var_87, var_89);
    var_91 = wp::add(var_84, var_90);
    var_93 = wp::extract(var_38, var_92);
    var_94 = wp::abs(var_93);
    var_96 = wp::extract(var_21, var_95);
    var_97 = wp::mul(var_94, var_96);
    var_98 = wp::add(var_91, var_97);
    var_99 = wp::vec_t<3, wp::float32>(var_58, var_78, var_98);
    // gap_sum = shape_gap[hfield_shape] + shape_gap[other_shape]                             <L 433>
    var_100 = wp::address(var_shape_gap, var_hfield_shape);
    var_101 = wp::address(var_shape_gap, var_other_shape);
    var_103 = wp::load(var_100);
    var_104 = wp::load(var_101);
    var_102 = wp::add(var_103, var_104);
    // margin_sum = shape_data[hfield_shape][3] + shape_data[other_shape][3]                  <L 434>
    var_105 = wp::address(var_shape_data, var_hfield_shape);
    var_108 = wp::load(var_105);
    var_107 = wp::extract(var_108, var_106);
    var_109 = wp::address(var_shape_data, var_other_shape);
    var_112 = wp::load(var_109);
    var_111 = wp::extract(var_112, var_110);
    var_113 = wp::add(var_107, var_111);
    // contact_threshold = gap_sum + margin_sum                                               <L 435>
    var_114 = wp::add(var_102, var_113);
    // threshold_vec = wp.vec3(contact_threshold, contact_threshold, contact_threshold)       <L 436>
    var_115 = wp::vec_t<3, wp::float32>(var_114, var_114, var_114);
    // aabb_lower = center_in_hfield - half_in_hfield - threshold_vec                         <L 438>
    var_116 = wp::sub(var_23, var_99);
    var_117 = wp::sub(var_116, var_115);
    // aabb_upper = center_in_hfield + half_in_hfield + threshold_vec                         <L 439>
    var_118 = wp::add(var_23, var_99);
    var_119 = wp::add(var_118, var_115);
    // dx = 2.0 * hfd.hx / wp.float32(hfd.ncol - 1)                                           <L 442>
    var_121 = &((var_hfd).hx);
    var_123 = wp::load(var_121);
    var_122 = wp::mul(var_120, var_123);
    var_124 = &((var_hfd).ncol);
    var_127 = wp::load(var_124);
    var_126 = wp::sub(var_127, var_125);
    var_128 = wp::float32(var_126);
    var_129 = wp::div(var_122, var_128);
    // dy = 2.0 * hfd.hy / wp.float32(hfd.nrow - 1)                                           <L 443>
    var_131 = &((var_hfd).hy);
    var_133 = wp::load(var_131);
    var_132 = wp::mul(var_130, var_133);
    var_134 = &((var_hfd).nrow);
    var_137 = wp::load(var_134);
    var_136 = wp::sub(var_137, var_135);
    var_138 = wp::float32(var_136);
    var_139 = wp::div(var_132, var_138);
    // col_min_f = (aabb_lower[0] + hfd.hx) / dx                                              <L 445>
    var_141 = wp::extract(var_117, var_140);
    var_142 = &((var_hfd).hx);
    var_144 = wp::load(var_142);
    var_143 = wp::add(var_141, var_144);
    var_145 = wp::div(var_143, var_129);
    // col_max_f = (aabb_upper[0] + hfd.hx) / dx                                              <L 446>
    var_147 = wp::extract(var_119, var_146);
    var_148 = &((var_hfd).hx);
    var_150 = wp::load(var_148);
    var_149 = wp::add(var_147, var_150);
    var_151 = wp::div(var_149, var_129);
    // row_min_f = (aabb_lower[1] + hfd.hy) / dy                                              <L 447>
    var_153 = wp::extract(var_117, var_152);
    var_154 = &((var_hfd).hy);
    var_156 = wp::load(var_154);
    var_155 = wp::add(var_153, var_156);
    var_157 = wp::div(var_155, var_139);
    // row_max_f = (aabb_upper[1] + hfd.hy) / dy                                              <L 448>
    var_159 = wp::extract(var_119, var_158);
    var_160 = &((var_hfd).hy);
    var_162 = wp::load(var_160);
    var_161 = wp::add(var_159, var_162);
    var_163 = wp::div(var_161, var_139);
    // col_min = wp.max(wp.int32(wp.floor(col_min_f)), 0)                                     <L 450>
    var_164 = wp::floor(var_145);
    var_165 = wp::int32(var_164);
    var_167 = wp::max(var_165, var_166);
    // col_max = wp.min(wp.int32(wp.floor(col_max_f)), hfd.ncol - 2)                          <L 451>
    var_168 = wp::floor(var_151);
    var_169 = wp::int32(var_168);
    var_170 = &((var_hfd).ncol);
    var_173 = wp::load(var_170);
    var_172 = wp::sub(var_173, var_171);
    var_174 = wp::min(var_169, var_172);
    // row_min = wp.max(wp.int32(wp.floor(row_min_f)), 0)                                     <L 452>
    var_175 = wp::floor(var_157);
    var_176 = wp::int32(var_175);
    var_178 = wp::max(var_176, var_177);
    // row_max = wp.min(wp.int32(wp.floor(row_max_f)), hfd.nrow - 2)                          <L 453>
    var_179 = wp::floor(var_163);
    var_180 = wp::int32(var_179);
    var_181 = &((var_hfd).nrow);
    var_184 = wp::load(var_181);
    var_183 = wp::sub(var_184, var_182);
    var_185 = wp::min(var_180, var_183);
    // cols = hfd.ncol - 1                                                                    <L 455>
    var_186 = &((var_hfd).ncol);
    var_189 = wp::load(var_186);
    var_188 = wp::sub(var_189, var_187);
    // for r in range(row_min, row_max + 1):                                                  <L 456>
    var_191 = wp::add(var_185, var_190);
    var_192 = wp::range(var_178, var_191);
    start_for_0:;
        if (iter_cmp(var_192) == 0) goto end_for_0;
        var_193 = wp::iter_next(var_192);
        // for c in range(col_min, col_max + 1):                                              <L 457>
        var_195 = wp::add(var_174, var_194);
        var_196 = wp::range(var_167, var_195);
        start_for_2:;
            if (iter_cmp(var_196) == 0) goto end_for_2;
            var_197 = wp::iter_next(var_196);
            // for tri_sub in range(2):                                                       <L 458>
            // tri_idx = (r * cols + c) * 2 + tri_sub                                         <L 459>
            var_199 = wp::mul(var_193, var_188);
            var_200 = wp::add(var_199, var_197);
            var_202 = wp::mul(var_200, var_201);
            var_203 = wp::add(var_202, var_198);
            // out_idx = wp.atomic_add(triangle_pairs_count, 0, 1)                            <L 460>
            var_206 = wp::atomic_add(var_triangle_pairs_count, var_204, var_205);
            // if out_idx < triangle_pairs.shape[0]:                                          <L 461>
            var_207 = &(var_triangle_pairs.shape);
            var_210 = wp::load(var_207);
            var_209 = wp::extract(var_210, var_208);
            var_211 = (var_206 < var_209);
            if (var_211) {
                // triangle_pairs[out_idx] = wp.vec3i(hfield_shape, other_shape, tri_idx)       <L 462>
                var_212 = wp::vec_t<3, wp::int32>(var_hfield_shape, var_other_shape, var_203);
                wp::array_store(var_triangle_pairs, var_206, var_212);
            }
            // tri_idx = (r * cols + c) * 2 + tri_sub                                         <L 459>
            var_214 = wp::mul(var_193, var_188);
            var_215 = wp::add(var_214, var_197);
            var_217 = wp::mul(var_215, var_216);
            var_218 = wp::add(var_217, var_213);
            // out_idx = wp.atomic_add(triangle_pairs_count, 0, 1)                            <L 460>
            var_221 = wp::atomic_add(var_triangle_pairs_count, var_219, var_220);
            // if out_idx < triangle_pairs.shape[0]:                                          <L 461>
            var_222 = &(var_triangle_pairs.shape);
            var_225 = wp::load(var_222);
            var_224 = wp::extract(var_225, var_223);
            var_226 = (var_221 < var_224);
            if (var_226) {
                // triangle_pairs[out_idx] = wp.vec3i(hfield_shape, other_shape, tri_idx)       <L 462>
                var_227 = wp::vec_t<3, wp::int32>(var_hfield_shape, var_other_shape, var_218);
                wp::array_store(var_triangle_pairs, var_221, var_227);
            }
            goto start_for_2;
        end_for_2:;
        goto start_for_0;
    end_for_0:;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/support_function.py:60
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/support_function.py:71
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


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/support_function.py:107
static CUDA_CALLABLE wp::vec_t<3, wp::float32> support_map_0(
    GenericShapeData_f25f19f5 var_geom,
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
    wp::vec_t<3, wp::float32>* var_255;
    const wp::int32 var_256 = 2;
    wp::float32 var_257;
    wp::vec_t<3, wp::float32> var_258;
    const wp::int32 var_259 = 0;
    wp::float32 var_260;
    const wp::int32 var_261 = 1;
    wp::float32 var_262;
    const wp::float32 var_263 = 0.0;
    wp::vec_t<3, wp::float32> var_264;
    wp::float32 var_265;
    const wp::float32 var_266 = 0.0;
    bool var_267;
    bool var_268;
    wp::vec_t<3, wp::float32> var_269;
    const wp::int32 var_270 = 0;
    wp::float32 var_271;
    wp::float32 var_272;
    const wp::int32 var_273 = 1;
    wp::float32 var_274;
    wp::float32 var_275;
    const wp::float32 var_276 = 0.0;
    wp::vec_t<3, wp::float32> var_277;
    const wp::float32 var_278 = 0.0;
    const wp::float32 var_279 = 0.0;
    wp::vec_t<3, wp::float32> var_280;
    wp::vec_t<3, wp::float32> var_281;
    const wp::int32 var_282 = 2;
    wp::float32 var_283;
    const wp::float32 var_284 = 0.0;
    bool var_285;
    const wp::int32 var_286 = 0;
    wp::float32 var_287;
    const wp::int32 var_288 = 1;
    wp::float32 var_289;
    wp::vec_t<3, wp::float32> var_290;
    const wp::int32 var_291 = 2;
    wp::float32 var_292;
    const wp::float32 var_293 = 0.0;
    bool var_294;
    const wp::int32 var_295 = 0;
    wp::float32 var_296;
    const wp::int32 var_297 = 1;
    wp::float32 var_298;
    wp::float32 var_299;
    wp::vec_t<3, wp::float32> var_300;
    wp::vec_t<3, wp::float32> var_301;
    wp::vec_t<3, wp::float32> var_302;
    wp::vec_t<3, wp::float32> var_303;
    bool var_304;
    wp::float32 var_305;
    wp::vec_t<3, wp::float32> var_306;
    const wp::float32 var_307 = 0.0;
    const wp::float32 var_308 = 1.0;
    const wp::float32 var_309 = 0.0;
    const wp::float32 var_310 = 0.0;
    wp::vec_t<3, wp::float32> var_311;
    wp::float32 var_312;
    wp::vec_t<3, wp::float32> var_313;
    const wp::int32 var_314 = 2;
    wp::float32 var_315;
    const wp::int32 var_316 = 2;
    wp::float32 var_317;
    wp::float32 var_318;
    wp::float32 var_319;
    wp::float32 var_320;
    const wp::float32 var_321 = 0.0;
    bool var_322;
    const wp::int32 var_323 = 2;
    wp::float32 var_324;
    wp::float32 var_325;
    wp::float32 var_326;
    wp::float32 var_327;
    wp::float32 var_328;
    wp::float32 var_329;
    wp::float32 var_330;
    wp::float32 var_331;
    wp::float32 var_332;
    wp::float32 var_333;
    wp::float32 var_334;
    wp::float32 var_335;
    const wp::float32 var_336 = 0.0;
    wp::float32 var_337;
    wp::float32 var_338;
    wp::float32 var_339;
    wp::float32 var_340;
    bool var_341;
    wp::float32 var_342;
    wp::float32 var_343;
    wp::float32 var_344;
    wp::float32 var_345;
    const wp::int32 var_346 = 0;
    wp::float32 var_347;
    wp::float32 var_348;
    const wp::int32 var_349 = 1;
    wp::float32 var_350;
    wp::float32 var_351;
    wp::vec_t<3, wp::float32> var_352;
    wp::vec_t<3, wp::float32> var_353;
    wp::vec_t<3, wp::float32> var_354;
    wp::int32* var_355;
    const wp::int32 var_356 = 9;
    bool var_357;
    wp::int32 var_358;
    wp::vec_t<3, wp::float32>* var_359;
    const wp::int32 var_360 = 0;
    wp::float32 var_361;
    wp::vec_t<3, wp::float32> var_362;
    wp::vec_t<3, wp::float32>* var_363;
    const wp::int32 var_364 = 1;
    wp::float32 var_365;
    wp::vec_t<3, wp::float32> var_366;
    const wp::float32 var_367 = 0.0;
    const wp::float32 var_368 = 0.0;
    wp::vec_t<3, wp::float32> var_369;
    const wp::int32 var_370 = 0;
    wp::float32 var_371;
    const wp::int32 var_372 = 1;
    wp::float32 var_373;
    const wp::float32 var_374 = 0.0;
    wp::vec_t<3, wp::float32> var_375;
    wp::float32 var_376;
    bool var_377;
    const wp::float32 var_378 = 2.0;
    wp::float32 var_379;
    wp::float32 var_380;
    const wp::float32 var_381 = 0.0;
    wp::float32 var_382;
    bool var_383;
    const wp::int32 var_384 = 2;
    wp::float32 var_385;
    const wp::float32 var_386 = 0.0;
    bool var_387;
    wp::vec_t<3, wp::float32> var_388;
    const wp::float32 var_389 = 0.0;
    wp::float32 var_390;
    wp::vec_t<3, wp::float32> var_391;
    wp::vec_t<3, wp::float32> var_392;
    const wp::int32 var_393 = 2;
    wp::float32 var_394;
    wp::float32 var_395;
    bool var_396;
    wp::vec_t<3, wp::float32> var_397;
    wp::vec_t<3, wp::float32> var_398;
    const wp::int32 var_399 = 0;
    wp::float32 var_400;
    wp::float32 var_401;
    const wp::int32 var_402 = 1;
    wp::float32 var_403;
    wp::float32 var_404;
    wp::float32 var_405;
    wp::vec_t<3, wp::float32> var_406;
    wp::vec_t<3, wp::float32> var_407;
    wp::vec_t<3, wp::float32> var_408;
    wp::int32* var_409;
    const wp::int32 var_410 = 1;
    bool var_411;
    wp::int32 var_412;
    wp::vec_t<3, wp::float32>* var_413;
    const wp::int32 var_414 = 0;
    wp::float32 var_415;
    wp::vec_t<3, wp::float32> var_416;
    wp::vec_t<3, wp::float32>* var_417;
    const wp::int32 var_418 = 1;
    wp::float32 var_419;
    wp::vec_t<3, wp::float32> var_420;
    const wp::int32 var_421 = 0;
    wp::float32 var_422;
    const wp::float32 var_423 = 0.0;
    bool var_424;
    const wp::float32 var_425 = 1.0;
    const wp::float32 var_426 = -1.0;
    wp::float32 var_427;
    const wp::int32 var_428 = 1;
    wp::float32 var_429;
    const wp::float32 var_430 = 0.0;
    bool var_431;
    const wp::float32 var_432 = 1.0;
    const wp::float32 var_433 = -1.0;
    wp::float32 var_434;
    wp::float32 var_435;
    wp::float32 var_436;
    const wp::float32 var_437 = 0.0;
    wp::vec_t<3, wp::float32> var_438;
    const wp::float32 var_439 = 0.0;
    const wp::float32 var_440 = 0.0;
    const wp::float32 var_441 = 0.0;
    wp::vec_t<3, wp::float32> var_442;
    wp::vec_t<3, wp::float32> var_443;
    wp::vec_t<3, wp::float32> var_444;
    wp::vec_t<3, wp::float32> var_445;
    wp::float32 var_446;
    wp::float32 var_447;
    wp::vec_t<3, wp::float32> var_448;
    wp::vec_t<3, wp::float32> var_449;
    wp::float32 var_450;
    wp::vec_t<3, wp::float32> var_451;
    wp::vec_t<3, wp::float32> var_452;
    wp::float32 var_453;
    wp::float32 var_454;
    wp::float32 var_455;
    wp::vec_t<3, wp::float32> var_456;
    wp::float32 var_457;
    wp::float32 var_458;
    wp::vec_t<3, wp::float32> var_459;
    wp::vec_t<3, wp::float32> var_460;
    wp::float32 var_461;
    wp::float32 var_462;
    wp::vec_t<3, wp::float32> var_463;
    wp::vec_t<3, wp::float32> var_464;
    //---------
    // forward
    // def support_map(geom: GenericShapeData, direction: wp.vec3, data_provider: SupportMapDataProvider) -> wp.vec3:       <L 108>
    // eps = 1.0e-12                                                                          <L 124>
    // result = wp.vec3(0.0, 0.0, 0.0)                                                        <L 126>
    var_4 = wp::vec_t<3, wp::float32>(var_1, var_2, var_3);
    // if geom.shape_type == GeoType.CONVEX_MESH:                                             <L 128>
    var_5 = &((var_geom).shape_type);
    var_8 = wp::load(var_5);
    var_7 = (var_8 == var_6);
    if (var_7) {
        // mesh_ptr = unpack_mesh_ptr(geom.auxiliary)                                         <L 130>
        var_9 = &((var_geom).auxiliary);
        var_11 = wp::load(var_9);
        var_10 = unpack_mesh_ptr_0(var_11);
        // mesh = wp.mesh_get(mesh_ptr)                                                       <L 131>
        var_12 = wp::mesh_get(var_10);
        // mesh_scale = geom.scale                                                            <L 133>
        var_13 = &((var_geom).scale);
        var_15 = wp::load(var_13);
        var_14 = wp::copy(var_15);
        // num_verts = mesh.points.shape[0]                                                   <L 134>
        var_16 = &((var_12).points);
        var_17 = &(var_16->shape);
        var_20 = wp::load(var_17);
        var_19 = wp::extract(var_20, var_18);
        // scaled_dir = wp.cw_mul(direction, mesh_scale)                                      <L 138>
        var_21 = wp::cw_mul(var_direction, var_14);
        // max_dot = float(-1.0e10)                                                           <L 140>
        var_23 = wp::float(var_22);
        // best_idx = int(0)                                                                  <L 141>
        var_25 = wp::int(var_24);
        // for i in range(num_verts):                                                         <L 142>
        var_26 = wp::range(var_19);
        start_for_0:;
            if (iter_cmp(var_26) == 0) goto end_for_0;
            var_27 = wp::iter_next(var_26);
            // dot_val = wp.dot(mesh.points[i], scaled_dir)                                   <L 143>
            var_28 = &((var_12).points);
            var_30 = wp::load(var_28);
            var_29 = wp::address(var_30, var_27);
            var_32 = wp::load(var_29);
            var_31 = wp::dot(var_32, var_21);
            // if dot_val > max_dot:                                                          <L 144>
            var_33 = (var_31 > var_23);
            if (var_33) {
                // max_dot = dot_val                                                          <L 145>
                var_34 = wp::copy(var_31);
                // best_idx = i                                                               <L 146>
                var_35 = wp::copy(var_27);
            }
            var_36 = wp::where(var_33, var_34, var_23);
            var_37 = wp::where(var_33, var_35, var_25);
            wp::assign(var_23, var_36);
            wp::assign(var_25, var_37);
            goto start_for_0;
        end_for_0:;
        // result = wp.cw_mul(mesh.points[best_idx], mesh_scale)                              <L 147>
        var_38 = &((var_12).points);
        var_40 = wp::load(var_38);
        var_39 = wp::address(var_40, var_25);
        var_42 = wp::load(var_39);
        var_41 = wp::cw_mul(var_42, var_14);
    }
    if (!var_7) {
        // elif geom.shape_type == GeoTypeEx.TRIANGLE or geom.shape_type == GeoTypeEx.TRIANGLE_PRISM:       <L 149>
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
            // tri_a = wp.vec3(0.0, 0.0, 0.0)                                                 <L 151>
            var_55 = wp::vec_t<3, wp::float32>(var_52, var_53, var_54);
            // tri_b = geom.scale                                                             <L 152>
            var_56 = &((var_geom).scale);
            var_58 = wp::load(var_56);
            var_57 = wp::copy(var_58);
            // tri_c = geom.auxiliary                                                         <L 153>
            var_59 = &((var_geom).auxiliary);
            var_61 = wp::load(var_59);
            var_60 = wp::copy(var_61);
            // dot_a = wp.dot(tri_a, direction)                                               <L 156>
            var_62 = wp::dot(var_55, var_direction);
            // dot_b = wp.dot(tri_b, direction)                                               <L 157>
            var_63 = wp::dot(var_57, var_direction);
            // dot_c = wp.dot(tri_c, direction)                                               <L 158>
            var_64 = wp::dot(var_60, var_direction);
            // if dot_a >= dot_b and dot_a >= dot_c:                                          <L 161>
            var_66 = (var_62 >= var_63);
            var_65 = var_66;
            if (var_65) {
                var_67 = (var_62 >= var_64);
                var_65 = var_65 && var_67;
            }
            if (var_65) {
                // result = tri_a                                                             <L 162>
                var_68 = wp::copy(var_55);
            }
            if (!var_65) {
                // elif dot_b >= dot_c:                                                       <L 163>
                var_69 = (var_63 >= var_64);
                if (var_69) {
                    // result = tri_b                                                         <L 164>
                    var_70 = wp::copy(var_57);
                }
                if (!var_69) {
                    // result = tri_c                                                         <L 166>
                    var_71 = wp::copy(var_60);
                }
                var_72 = wp::where(var_69, var_70, var_71);
            }
            var_73 = wp::where(var_65, var_68, var_72);
            // if geom.shape_type == GeoTypeEx.TRIANGLE_PRISM:                                <L 173>
            var_74 = &((var_geom).shape_type);
            var_77 = wp::load(var_74);
            var_76 = (var_77 == var_75);
            if (var_76) {
                // if direction[2] < 0.0:                                                     <L 174>
                var_79 = wp::extract(var_direction, var_78);
                var_81 = (var_79 < var_80);
                if (var_81) {
                    // result = result + wp.vec3(0.0, 0.0, -1.0)                              <L 175>
                    var_85 = wp::vec_t<3, wp::float32>(var_82, var_83, var_84);
                    var_86 = wp::add(var_73, var_85);
                }
                var_87 = wp::where(var_81, var_86, var_73);
            }
            var_88 = wp::where(var_76, var_87, var_73);
        }
        if (!var_43) {
            // elif geom.shape_type == GeoType.BOX:                                           <L 176>
            var_89 = &((var_geom).shape_type);
            var_92 = wp::load(var_89);
            var_91 = (var_92 == var_90);
            if (var_91) {
                // threshold = BOX_SUPPORT_DEADBAND * wp.length(direction)                    <L 183>
                var_94 = wp::length(var_direction);
                var_95 = wp::mul(var_93, var_94);
                // sx = 1.0 if direction[0] >= -threshold else -1.0                           <L 184>
                var_97 = wp::extract(var_direction, var_96);
                var_98 = wp::neg(var_95);
                var_99 = (var_97 >= var_98);
                if (var_99) {
                }
                if (!var_99) {
                }
                var_102 = wp::where(var_99, var_100, var_101);
                // sy = 1.0 if direction[1] >= -threshold else -1.0                           <L 185>
                var_104 = wp::extract(var_direction, var_103);
                var_105 = wp::neg(var_95);
                var_106 = (var_104 >= var_105);
                if (var_106) {
                }
                if (!var_106) {
                }
                var_109 = wp::where(var_106, var_107, var_108);
                // sz = 1.0 if direction[2] >= -threshold else -1.0                           <L 186>
                var_111 = wp::extract(var_direction, var_110);
                var_112 = wp::neg(var_95);
                var_113 = (var_111 >= var_112);
                if (var_113) {
                }
                if (!var_113) {
                }
                var_116 = wp::where(var_113, var_114, var_115);
                // result = wp.vec3(sx * geom.scale[0], sy * geom.scale[1], sz * geom.scale[2])       <L 188>
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
                // elif geom.shape_type == GeoType.SPHERE:                                    <L 190>
                var_133 = &((var_geom).shape_type);
                var_136 = wp::load(var_133);
                var_135 = (var_136 == var_134);
                if (var_135) {
                    // radius = geom.scale[0]                                                 <L 191>
                    var_137 = &((var_geom).scale);
                    var_140 = wp::load(var_137);
                    var_139 = wp::extract(var_140, var_138);
                    // dir_len_sq = wp.length_sq(direction)                                   <L 192>
                    var_141 = wp::length_sq(var_direction);
                    // if dir_len_sq > eps:                                                   <L 193>
                    var_142 = (var_141 > var_0);
                    if (var_142) {
                        // n = wp.normalize(direction)                                        <L 194>
                        var_143 = wp::normalize(var_direction);
                    }
                    if (!var_142) {
                        // n = wp.vec3(1.0, 0.0, 0.0)                                         <L 196>
                        var_147 = wp::vec_t<3, wp::float32>(var_144, var_145, var_146);
                    }
                    var_148 = wp::where(var_142, var_143, var_147);
                    // result = n * radius                                                    <L 197>
                    var_149 = wp::mul(var_148, var_139);
                }
                if (!var_135) {
                    // elif geom.shape_type == GeoType.CAPSULE:                               <L 199>
                    var_150 = &((var_geom).shape_type);
                    var_153 = wp::load(var_150);
                    var_152 = (var_153 == var_151);
                    if (var_152) {
                        // radius = geom.scale[0]                                             <L 200>
                        var_154 = &((var_geom).scale);
                        var_157 = wp::load(var_154);
                        var_156 = wp::extract(var_157, var_155);
                        // half_height = geom.scale[1]                                        <L 201>
                        var_158 = &((var_geom).scale);
                        var_161 = wp::load(var_158);
                        var_160 = wp::extract(var_161, var_159);
                        // dir_len_sq = wp.length_sq(direction)                               <L 205>
                        var_162 = wp::length_sq(var_direction);
                        // if dir_len_sq > eps:                                               <L 206>
                        var_163 = (var_162 > var_0);
                        if (var_163) {
                            // n = wp.normalize(direction)                                    <L 207>
                            var_164 = wp::normalize(var_direction);
                        }
                        if (!var_163) {
                            // n = wp.vec3(1.0, 0.0, 0.0)                                     <L 209>
                            var_168 = wp::vec_t<3, wp::float32>(var_165, var_166, var_167);
                        }
                        var_169 = wp::where(var_163, var_164, var_168);
                        // result = n * radius                                                <L 210>
                        var_170 = wp::mul(var_169, var_156);
                        // if direction[2] >= 0.0:                                            <L 214>
                        var_172 = wp::extract(var_direction, var_171);
                        var_174 = (var_172 >= var_173);
                        if (var_174) {
                            // result = result + wp.vec3(0.0, 0.0, half_height)               <L 215>
                            var_177 = wp::vec_t<3, wp::float32>(var_175, var_176, var_160);
                            var_178 = wp::add(var_170, var_177);
                        }
                        if (!var_174) {
                            // result = result + wp.vec3(0.0, 0.0, -half_height)              <L 217>
                            var_181 = wp::neg(var_160);
                            var_182 = wp::vec_t<3, wp::float32>(var_179, var_180, var_181);
                            var_183 = wp::add(var_170, var_182);
                        }
                        var_184 = wp::where(var_174, var_178, var_183);
                    }
                    if (!var_152) {
                        // elif geom.shape_type == GeoType.ELLIPSOID:                         <L 219>
                        var_185 = &((var_geom).shape_type);
                        var_188 = wp::load(var_185);
                        var_187 = (var_188 == var_186);
                        if (var_187) {
                            // a = geom.scale[0]                                              <L 222>
                            var_189 = &((var_geom).scale);
                            var_192 = wp::load(var_189);
                            var_191 = wp::extract(var_192, var_190);
                            // b = geom.scale[1]                                              <L 223>
                            var_193 = &((var_geom).scale);
                            var_196 = wp::load(var_193);
                            var_195 = wp::extract(var_196, var_194);
                            // c = geom.scale[2]                                              <L 224>
                            var_197 = &((var_geom).scale);
                            var_200 = wp::load(var_197);
                            var_199 = wp::extract(var_200, var_198);
                            // dir_len_sq = wp.length_sq(direction)                           <L 225>
                            var_201 = wp::length_sq(var_direction);
                            // if dir_len_sq > eps:                                           <L 226>
                            var_202 = (var_201 > var_0);
                            if (var_202) {
                                // adx = a * direction[0]                                     <L 227>
                                var_204 = wp::extract(var_direction, var_203);
                                var_205 = wp::mul(var_191, var_204);
                                // bdy = b * direction[1]                                     <L 228>
                                var_207 = wp::extract(var_direction, var_206);
                                var_208 = wp::mul(var_195, var_207);
                                // cdz = c * direction[2]                                     <L 229>
                                var_210 = wp::extract(var_direction, var_209);
                                var_211 = wp::mul(var_199, var_210);
                                // denom_sq = adx * adx + bdy * bdy + cdz * cdz               <L 230>
                                var_212 = wp::mul(var_205, var_205);
                                var_213 = wp::mul(var_208, var_208);
                                var_214 = wp::add(var_212, var_213);
                                var_215 = wp::mul(var_211, var_211);
                                var_216 = wp::add(var_214, var_215);
                                // if denom_sq > eps:                                         <L 231>
                                var_217 = (var_216 > var_0);
                                if (var_217) {
                                    // denom = wp.sqrt(denom_sq)                              <L 232>
                                    var_218 = wp::sqrt(var_216);
                                    // result = wp.vec3(                                      <L 233>
                                    // (a * a) * direction[0] / denom, (b * b) * direction[1] / denom, (c * c) * direction[2] / denom       <L 234>
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
                                    // result = wp.vec3(a, 0.0, 0.0)                          <L 237>
                                    var_237 = wp::vec_t<3, wp::float32>(var_191, var_235, var_236);
                                }
                                var_238 = wp::where(var_217, var_234, var_237);
                            }
                            if (!var_202) {
                                // result = wp.vec3(a, 0.0, 0.0)                              <L 239>
                                var_241 = wp::vec_t<3, wp::float32>(var_191, var_239, var_240);
                            }
                            var_242 = wp::where(var_202, var_238, var_241);
                        }
                        if (!var_187) {
                            // elif geom.shape_type == GeoType.CYLINDER:                      <L 241>
                            var_243 = &((var_geom).shape_type);
                            var_246 = wp::load(var_243);
                            var_245 = (var_246 == var_244);
                            if (var_245) {
                                // radius = geom.scale[0]                                     <L 242>
                                var_247 = &((var_geom).scale);
                                var_250 = wp::load(var_247);
                                var_249 = wp::extract(var_250, var_248);
                                // half_height = geom.scale[1]                                <L 243>
                                var_251 = &((var_geom).scale);
                                var_254 = wp::load(var_251);
                                var_253 = wp::extract(var_254, var_252);
                                // barrel_radius = geom.scale[2]                              <L 244>
                                var_255 = &((var_geom).scale);
                                var_258 = wp::load(var_255);
                                var_257 = wp::extract(var_258, var_256);
                                // dir_xy = wp.vec3(direction[0], direction[1], 0.0)          <L 246>
                                var_260 = wp::extract(var_direction, var_259);
                                var_262 = wp::extract(var_direction, var_261);
                                var_264 = wp::vec_t<3, wp::float32>(var_260, var_262, var_263);
                                // dir_xy_len_sq = wp.length_sq(dir_xy)                       <L 247>
                                var_265 = wp::length_sq(var_264);
                                // if barrel_radius == 0.0:                                   <L 249>
                                var_267 = (var_257 == var_266);
                                if (var_267) {
                                    // if dir_xy_len_sq > eps:                                <L 251>
                                    var_268 = (var_265 > var_0);
                                    if (var_268) {
                                        // n_xy = wp.normalize(dir_xy)                        <L 252>
                                        var_269 = wp::normalize(var_264);
                                        // lateral_point = wp.vec3(n_xy[0] * radius, n_xy[1] * radius, 0.0)       <L 253>
                                        var_271 = wp::extract(var_269, var_270);
                                        var_272 = wp::mul(var_271, var_249);
                                        var_274 = wp::extract(var_269, var_273);
                                        var_275 = wp::mul(var_274, var_249);
                                        var_277 = wp::vec_t<3, wp::float32>(var_272, var_275, var_276);
                                    }
                                    if (!var_268) {
                                        // lateral_point = wp.vec3(radius, 0.0, 0.0)          <L 255>
                                        var_280 = wp::vec_t<3, wp::float32>(var_249, var_278, var_279);
                                    }
                                    var_281 = wp::where(var_268, var_277, var_280);
                                    // if direction[2] > 0.0:                                 <L 257>
                                    var_283 = wp::extract(var_direction, var_282);
                                    var_285 = (var_283 > var_284);
                                    if (var_285) {
                                        // result = wp.vec3(lateral_point[0], lateral_point[1], half_height)       <L 258>
                                        var_287 = wp::extract(var_281, var_286);
                                        var_289 = wp::extract(var_281, var_288);
                                        var_290 = wp::vec_t<3, wp::float32>(var_287, var_289, var_253);
                                    }
                                    if (!var_285) {
                                        // elif direction[2] < 0.0:                           <L 259>
                                        var_292 = wp::extract(var_direction, var_291);
                                        var_294 = (var_292 < var_293);
                                        if (var_294) {
                                            // result = wp.vec3(lateral_point[0], lateral_point[1], -half_height)       <L 260>
                                            var_296 = wp::extract(var_281, var_295);
                                            var_298 = wp::extract(var_281, var_297);
                                            var_299 = wp::neg(var_253);
                                            var_300 = wp::vec_t<3, wp::float32>(var_296, var_298, var_299);
                                        }
                                        if (!var_294) {
                                            // result = lateral_point                         <L 262>
                                            var_301 = wp::copy(var_281);
                                        }
                                        var_302 = wp::where(var_294, var_300, var_301);
                                    }
                                    var_303 = wp::where(var_285, var_290, var_302);
                                }
                                if (!var_267) {
                                    // if dir_xy_len_sq > eps:                                <L 264>
                                    var_304 = (var_265 > var_0);
                                    if (var_304) {
                                        // dir_xy_len = wp.sqrt(dir_xy_len_sq)                <L 265>
                                        var_305 = wp::sqrt(var_265);
                                        // n_xy = dir_xy / dir_xy_len                         <L 266>
                                        var_306 = wp::div(var_264, var_305);
                                    }
                                    if (!var_304) {
                                        // dir_xy_len = 0.0                                   <L 268>
                                        // n_xy = wp.vec3(1.0, 0.0, 0.0)                      <L 269>
                                        var_311 = wp::vec_t<3, wp::float32>(var_308, var_309, var_310);
                                    }
                                    var_312 = wp::where(var_304, var_305, var_307);
                                    var_313 = wp::where(var_304, var_306, var_311);
                                    // direction_len = wp.sqrt(dir_xy_len_sq + direction[2] * direction[2])       <L 271>
                                    var_315 = wp::extract(var_direction, var_314);
                                    var_317 = wp::extract(var_direction, var_316);
                                    var_318 = wp::mul(var_315, var_317);
                                    var_319 = wp::add(var_265, var_318);
                                    var_320 = wp::sqrt(var_319);
                                    // support_z = 0.0                                        <L 272>
                                    // if direction_len > eps:                                <L 273>
                                    var_322 = (var_320 > var_0);
                                    if (var_322) {
                                        // support_z = wp.clamp(barrel_radius * direction[2] / direction_len, -half_height, half_height)       <L 274>
                                        var_324 = wp::extract(var_direction, var_323);
                                        var_325 = wp::mul(var_257, var_324);
                                        var_326 = wp::div(var_325, var_320);
                                        var_327 = wp::neg(var_253);
                                        var_328 = wp::clamp(var_326, var_327, var_253);
                                    }
                                    var_329 = wp::where(var_322, var_328, var_321);
                                    // barrel_radius_sq = barrel_radius * barrel_radius       <L 276>
                                    var_330 = wp::mul(var_257, var_257);
                                    // half_height_sq = half_height * half_height             <L 277>
                                    var_331 = wp::mul(var_253, var_253);
                                    // support_z_sq = support_z * support_z                   <L 278>
                                    var_332 = wp::mul(var_329, var_329);
                                    // end_offset = wp.sqrt(barrel_radius_sq - half_height_sq)       <L 279>
                                    var_333 = wp::sub(var_330, var_331);
                                    var_334 = wp::sqrt(var_333);
                                    // support_offset = wp.sqrt(wp.max(barrel_radius_sq - support_z_sq, 0.0))       <L 280>
                                    var_335 = wp::sub(var_330, var_332);
                                    var_337 = wp::max(var_335, var_336);
                                    var_338 = wp::sqrt(var_337);
                                    // offset_sum = support_offset + end_offset               <L 281>
                                    var_339 = wp::add(var_338, var_334);
                                    // support_radius = radius                                <L 282>
                                    var_340 = wp::copy(var_249);
                                    // if offset_sum > eps:                                   <L 283>
                                    var_341 = (var_339 > var_0);
                                    if (var_341) {
                                        // support_radius += (half_height_sq - support_z_sq) / offset_sum       <L 284>
                                        var_342 = wp::sub(var_331, var_332);
                                        var_343 = wp::div(var_342, var_339);
                                        var_344 = wp::add(var_340, var_343);
                                    }
                                    var_345 = wp::where(var_341, var_344, var_340);
                                    // result = wp.vec3(n_xy[0] * support_radius, n_xy[1] * support_radius, support_z)       <L 285>
                                    var_347 = wp::extract(var_313, var_346);
                                    var_348 = wp::mul(var_347, var_345);
                                    var_350 = wp::extract(var_313, var_349);
                                    var_351 = wp::mul(var_350, var_345);
                                    var_352 = wp::vec_t<3, wp::float32>(var_348, var_351, var_329);
                                }
                                var_353 = wp::where(var_267, var_303, var_352);
                                var_354 = wp::where(var_267, var_269, var_313);
                            }
                            if (!var_245) {
                                // elif geom.shape_type == GeoType.CONE:                      <L 287>
                                var_355 = &((var_geom).shape_type);
                                var_358 = wp::load(var_355);
                                var_357 = (var_358 == var_356);
                                if (var_357) {
                                    // radius = geom.scale[0]                                 <L 288>
                                    var_359 = &((var_geom).scale);
                                    var_362 = wp::load(var_359);
                                    var_361 = wp::extract(var_362, var_360);
                                    // half_height = geom.scale[1]                            <L 289>
                                    var_363 = &((var_geom).scale);
                                    var_366 = wp::load(var_363);
                                    var_365 = wp::extract(var_366, var_364);
                                    // apex = wp.vec3(0.0, 0.0, half_height)                  <L 294>
                                    var_369 = wp::vec_t<3, wp::float32>(var_367, var_368, var_365);
                                    // dir_xy = wp.vec3(direction[0], direction[1], 0.0)       <L 295>
                                    var_371 = wp::extract(var_direction, var_370);
                                    var_373 = wp::extract(var_direction, var_372);
                                    var_375 = wp::vec_t<3, wp::float32>(var_371, var_373, var_374);
                                    // dir_xy_len = wp.length(dir_xy)                         <L 296>
                                    var_376 = wp::length(var_375);
                                    // k = radius / (2.0 * half_height) if half_height > eps else 0.0       <L 297>
                                    var_377 = (var_365 > var_0);
                                    if (var_377) {
                                        var_379 = wp::mul(var_378, var_365);
                                        var_380 = wp::div(var_361, var_379);
                                    }
                                    if (!var_377) {
                                    }
                                    var_382 = wp::where(var_377, var_380, var_381);
                                    // if dir_xy_len <= eps:                                  <L 299>
                                    var_383 = (var_376 <= var_0);
                                    if (var_383) {
                                        // if direction[2] >= 0.0:                            <L 301>
                                        var_385 = wp::extract(var_direction, var_384);
                                        var_387 = (var_385 >= var_386);
                                        if (var_387) {
                                            // result = apex                                  <L 302>
                                            var_388 = wp::copy(var_369);
                                        }
                                        if (!var_387) {
                                            // result = wp.vec3(radius, 0.0, -half_height)       <L 304>
                                            var_390 = wp::neg(var_365);
                                            var_391 = wp::vec_t<3, wp::float32>(var_361, var_389, var_390);
                                        }
                                        var_392 = wp::where(var_387, var_388, var_391);
                                    }
                                    if (!var_383) {
                                        // if direction[2] >= k * dir_xy_len:                 <L 306>
                                        var_394 = wp::extract(var_direction, var_393);
                                        var_395 = wp::mul(var_382, var_376);
                                        var_396 = (var_394 >= var_395);
                                        if (var_396) {
                                            // result = apex                                  <L 307>
                                            var_397 = wp::copy(var_369);
                                        }
                                        if (!var_396) {
                                            // n_xy = dir_xy / dir_xy_len                     <L 309>
                                            var_398 = wp::div(var_375, var_376);
                                            // result = wp.vec3(n_xy[0] * radius, n_xy[1] * radius, -half_height)       <L 310>
                                            var_400 = wp::extract(var_398, var_399);
                                            var_401 = wp::mul(var_400, var_361);
                                            var_403 = wp::extract(var_398, var_402);
                                            var_404 = wp::mul(var_403, var_361);
                                            var_405 = wp::neg(var_365);
                                            var_406 = wp::vec_t<3, wp::float32>(var_401, var_404, var_405);
                                        }
                                        var_407 = wp::where(var_396, var_397, var_406);
                                    }
                                    var_408 = wp::where(var_383, var_392, var_407);
                                }
                                if (!var_357) {
                                    // elif geom.shape_type == GeoType.PLANE:                 <L 312>
                                    var_409 = &((var_geom).shape_type);
                                    var_412 = wp::load(var_409);
                                    var_411 = (var_412 == var_410);
                                    if (var_411) {
                                        // half_width = geom.scale[0]                         <L 315>
                                        var_413 = &((var_geom).scale);
                                        var_416 = wp::load(var_413);
                                        var_415 = wp::extract(var_416, var_414);
                                        // half_length = geom.scale[1]                        <L 316>
                                        var_417 = &((var_geom).scale);
                                        var_420 = wp::load(var_417);
                                        var_419 = wp::extract(var_420, var_418);
                                        // sx = 1.0 if direction[0] >= 0.0 else -1.0          <L 319>
                                        var_422 = wp::extract(var_direction, var_421);
                                        var_424 = (var_422 >= var_423);
                                        if (var_424) {
                                        }
                                        if (!var_424) {
                                        }
                                        var_427 = wp::where(var_424, var_425, var_426);
                                        // sy = 1.0 if direction[1] >= 0.0 else -1.0          <L 320>
                                        var_429 = wp::extract(var_direction, var_428);
                                        var_431 = (var_429 >= var_430);
                                        if (var_431) {
                                        }
                                        if (!var_431) {
                                        }
                                        var_434 = wp::where(var_431, var_432, var_433);
                                        // result = wp.vec3(sx * half_width, sy * half_length, 0.0)       <L 323>
                                        var_435 = wp::mul(var_427, var_415);
                                        var_436 = wp::mul(var_434, var_419);
                                        var_438 = wp::vec_t<3, wp::float32>(var_435, var_436, var_437);
                                    }
                                    if (!var_411) {
                                        // result = wp.vec3(0.0, 0.0, 0.0)                    <L 327>
                                        var_442 = wp::vec_t<3, wp::float32>(var_439, var_440, var_441);
                                    }
                                    var_443 = wp::where(var_411, var_438, var_442);
                                }
                                var_444 = wp::where(var_357, var_408, var_443);
                            }
                            var_445 = wp::where(var_245, var_353, var_444);
                            var_446 = wp::where(var_245, var_249, var_361);
                            var_447 = wp::where(var_245, var_253, var_365);
                            var_448 = wp::where(var_245, var_264, var_375);
                            var_449 = wp::where(var_245, var_354, var_398);
                            var_450 = wp::where(var_245, var_312, var_376);
                        }
                        var_451 = wp::where(var_187, var_242, var_445);
                    }
                    var_452 = wp::where(var_152, var_184, var_451);
                    var_453 = wp::where(var_152, var_156, var_446);
                    var_454 = wp::where(var_152, var_160, var_447);
                    var_455 = wp::where(var_152, var_162, var_201);
                }
                var_456 = wp::where(var_135, var_149, var_452);
                var_457 = wp::where(var_135, var_139, var_453);
                var_458 = wp::where(var_135, var_141, var_455);
                var_459 = wp::where(var_135, var_148, var_169);
            }
            var_460 = wp::where(var_91, var_132, var_456);
            var_461 = wp::where(var_91, var_102, var_427);
            var_462 = wp::where(var_91, var_109, var_434);
        }
        var_463 = wp::where(var_43, var_88, var_460);
    }
    var_464 = wp::where(var_7, var_41, var_463);
    // return result                                                                          <L 329>
    return var_464;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/collision_core.py:396
static CUDA_CALLABLE void compute_tight_aabb_from_support_0(
    GenericShapeData_f25f19f5 var_shape_data,
    wp::quat_t<wp::float32> var_orientation,
    wp::vec_t<3, wp::float32> var_center_pos,
    SupportMapDataProvider_e77f8b9f var_data_provider,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    wp::mat_t<3, 3, wp::float32> var_0;
    wp::mat_t<3, 3, wp::float32> var_1;
    const wp::int32 var_2 = 0;
    const wp::int32 var_3 = 0;
    wp::float32 var_4;
    const wp::int32 var_5 = 1;
    const wp::int32 var_6 = 0;
    wp::float32 var_7;
    const wp::int32 var_8 = 2;
    const wp::int32 var_9 = 0;
    wp::float32 var_10;
    wp::vec_t<3, wp::float32> var_11;
    const wp::int32 var_12 = 0;
    const wp::int32 var_13 = 1;
    wp::float32 var_14;
    const wp::int32 var_15 = 1;
    const wp::int32 var_16 = 1;
    wp::float32 var_17;
    const wp::int32 var_18 = 2;
    const wp::int32 var_19 = 1;
    wp::float32 var_20;
    wp::vec_t<3, wp::float32> var_21;
    const wp::int32 var_22 = 0;
    const wp::int32 var_23 = 2;
    wp::float32 var_24;
    const wp::int32 var_25 = 1;
    const wp::int32 var_26 = 2;
    wp::float32 var_27;
    const wp::int32 var_28 = 2;
    const wp::int32 var_29 = 2;
    wp::float32 var_30;
    wp::vec_t<3, wp::float32> var_31;
    const wp::float32 var_32 = 0.0;
    wp::float32 var_33;
    const wp::float32 var_34 = 0.0;
    wp::float32 var_35;
    const wp::float32 var_36 = 0.0;
    wp::float32 var_37;
    const wp::float32 var_38 = 0.0;
    wp::float32 var_39;
    const wp::float32 var_40 = 0.0;
    wp::float32 var_41;
    const wp::float32 var_42 = 0.0;
    wp::float32 var_43;
    wp::int32* var_44;
    const wp::int32 var_45 = 10;
    bool var_46;
    wp::int32 var_47;
    wp::vec_t<3, wp::float32>* var_48;
    wp::uint64 var_49;
    wp::vec_t<3, wp::float32> var_50;
    wp::Mesh var_51;
    wp::vec_t<3, wp::float32>* var_52;
    wp::vec_t<3, wp::float32> var_53;
    wp::vec_t<3, wp::float32> var_54;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_55;
    wp::shape_t* var_56;
    const wp::int32 var_57 = 0;
    wp::int32 var_58;
    wp::shape_t var_59;
    wp::vec_t<3, wp::float32> var_60;
    wp::vec_t<3, wp::float32> var_61;
    wp::vec_t<3, wp::float32> var_62;
    const wp::float32 var_63 = 10000000000.0;
    wp::float32 var_64;
    const wp::float32 var_65 = -10000000000.0;
    wp::float32 var_66;
    const wp::float32 var_67 = 10000000000.0;
    wp::float32 var_68;
    const wp::float32 var_69 = -10000000000.0;
    wp::float32 var_70;
    const wp::float32 var_71 = 10000000000.0;
    wp::float32 var_72;
    const wp::float32 var_73 = -10000000000.0;
    wp::float32 var_74;
    wp::range_t var_75;
    wp::int32 var_76;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_77;
    wp::vec_t<3, wp::float32>* var_78;
    wp::array_t<wp::vec_t<3, wp::float32>> var_79;
    wp::vec_t<3, wp::float32> var_80;
    wp::vec_t<3, wp::float32> var_81;
    wp::float32 var_82;
    wp::float32 var_83;
    wp::float32 var_84;
    wp::float32 var_85;
    wp::float32 var_86;
    wp::float32 var_87;
    wp::float32 var_88;
    wp::float32 var_89;
    wp::float32 var_90;
    wp::vec_t<3, wp::float32> var_91;
    wp::float32 var_92;
    wp::vec_t<3, wp::float32> var_93;
    wp::float32 var_94;
    wp::vec_t<3, wp::float32> var_95;
    wp::float32 var_96;
    wp::vec_t<3, wp::float32> var_97;
    wp::vec_t<3, wp::float32> var_98;
    wp::float32 var_99;
    wp::vec_t<3, wp::float32> var_100;
    wp::vec_t<3, wp::float32> var_101;
    wp::float32 var_102;
    wp::vec_t<3, wp::float32> var_103;
    wp::vec_t<3, wp::float32> var_104;
    wp::float32 var_105;
    wp::float32 var_106;
    wp::float32 var_107;
    wp::float32 var_108;
    wp::float32 var_109;
    wp::float32 var_110;
    wp::float32 var_111;
    wp::vec_t<3, wp::float32> var_112;
    wp::vec_t<3, wp::float32> var_113;
    wp::vec_t<3, wp::float32> var_114;
    wp::vec_t<3, wp::float32> var_115;
    //---------
    // forward
    // def compute_tight_aabb_from_support(                                                   <L 397>
    // rot_mat = wp.quat_to_matrix(orientation)                                               <L 417>
    var_0 = wp::quat_to_matrix(var_orientation);
    // rot_mat_t = wp.transpose(rot_mat)                                                      <L 418>
    var_1 = wp::transpose(var_0);
    // local_x = wp.vec3(rot_mat_t[0, 0], rot_mat_t[1, 0], rot_mat_t[2, 0])                   <L 421>
    var_4 = wp::extract(var_1, var_2, var_3);
    var_7 = wp::extract(var_1, var_5, var_6);
    var_10 = wp::extract(var_1, var_8, var_9);
    var_11 = wp::vec_t<3, wp::float32>(var_4, var_7, var_10);
    // local_y = wp.vec3(rot_mat_t[0, 1], rot_mat_t[1, 1], rot_mat_t[2, 1])                   <L 422>
    var_14 = wp::extract(var_1, var_12, var_13);
    var_17 = wp::extract(var_1, var_15, var_16);
    var_20 = wp::extract(var_1, var_18, var_19);
    var_21 = wp::vec_t<3, wp::float32>(var_14, var_17, var_20);
    // local_z = wp.vec3(rot_mat_t[0, 2], rot_mat_t[1, 2], rot_mat_t[2, 2])                   <L 423>
    var_24 = wp::extract(var_1, var_22, var_23);
    var_27 = wp::extract(var_1, var_25, var_26);
    var_30 = wp::extract(var_1, var_28, var_29);
    var_31 = wp::vec_t<3, wp::float32>(var_24, var_27, var_30);
    // min_x = float(0.0)                                                                     <L 428>
    var_33 = wp::float(var_32);
    // max_x = float(0.0)                                                                     <L 429>
    var_35 = wp::float(var_34);
    // min_y = float(0.0)                                                                     <L 430>
    var_37 = wp::float(var_36);
    // max_y = float(0.0)                                                                     <L 431>
    var_39 = wp::float(var_38);
    // min_z = float(0.0)                                                                     <L 432>
    var_41 = wp::float(var_40);
    // max_z = float(0.0)                                                                     <L 433>
    var_43 = wp::float(var_42);
    // if shape_data.shape_type == GeoType.CONVEX_MESH:                                       <L 435>
    var_44 = &((var_shape_data).shape_type);
    var_47 = wp::load(var_44);
    var_46 = (var_47 == var_45);
    if (var_46) {
        // mesh_ptr = unpack_mesh_ptr(shape_data.auxiliary)                                   <L 439>
        var_48 = &((var_shape_data).auxiliary);
        var_50 = wp::load(var_48);
        var_49 = unpack_mesh_ptr_0(var_50);
        // mesh = wp.mesh_get(mesh_ptr)                                                       <L 440>
        var_51 = wp::mesh_get(var_49);
        // mesh_scale = shape_data.scale                                                      <L 441>
        var_52 = &((var_shape_data).scale);
        var_54 = wp::load(var_52);
        var_53 = wp::copy(var_54);
        // num_verts = mesh.points.shape[0]                                                   <L 442>
        var_55 = &((var_51).points);
        var_56 = &(var_55->shape);
        var_59 = wp::load(var_56);
        var_58 = wp::extract(var_59, var_57);
        // scaled_x = wp.cw_mul(local_x, mesh_scale)                                          <L 445>
        var_60 = wp::cw_mul(var_11, var_53);
        // scaled_y = wp.cw_mul(local_y, mesh_scale)                                          <L 446>
        var_61 = wp::cw_mul(var_21, var_53);
        // scaled_z = wp.cw_mul(local_z, mesh_scale)                                          <L 447>
        var_62 = wp::cw_mul(var_31, var_53);
        // min_x = float(1.0e10)                                                              <L 449>
        var_64 = wp::float(var_63);
        // max_x = float(-1.0e10)                                                             <L 450>
        var_66 = wp::float(var_65);
        // min_y = float(1.0e10)                                                              <L 451>
        var_68 = wp::float(var_67);
        // max_y = float(-1.0e10)                                                             <L 452>
        var_70 = wp::float(var_69);
        // min_z = float(1.0e10)                                                              <L 453>
        var_72 = wp::float(var_71);
        // max_z = float(-1.0e10)                                                             <L 454>
        var_74 = wp::float(var_73);
        // for i in range(num_verts):                                                         <L 456>
        var_75 = wp::range(var_58);
        start_for_0:;
            if (iter_cmp(var_75) == 0) goto end_for_0;
            var_76 = wp::iter_next(var_75);
            // p = mesh.points[i]                                                             <L 457>
            var_77 = &((var_51).points);
            var_79 = wp::load(var_77);
            var_78 = wp::address(var_79, var_76);
            var_81 = wp::load(var_78);
            var_80 = wp::copy(var_81);
            // vx = wp.dot(p, scaled_x)                                                       <L 458>
            var_82 = wp::dot(var_80, var_60);
            // vy = wp.dot(p, scaled_y)                                                       <L 459>
            var_83 = wp::dot(var_80, var_61);
            // vz = wp.dot(p, scaled_z)                                                       <L 460>
            var_84 = wp::dot(var_80, var_62);
            // min_x = wp.min(min_x, vx)                                                      <L 461>
            var_85 = wp::min(var_64, var_82);
            // max_x = wp.max(max_x, vx)                                                      <L 462>
            var_86 = wp::max(var_66, var_82);
            // min_y = wp.min(min_y, vy)                                                      <L 463>
            var_87 = wp::min(var_68, var_83);
            // max_y = wp.max(max_y, vy)                                                      <L 464>
            var_88 = wp::max(var_70, var_83);
            // min_z = wp.min(min_z, vz)                                                      <L 465>
            var_89 = wp::min(var_72, var_84);
            // max_z = wp.max(max_z, vz)                                                      <L 466>
            var_90 = wp::max(var_74, var_84);
            wp::assign(var_64, var_85);
            wp::assign(var_66, var_86);
            wp::assign(var_68, var_87);
            wp::assign(var_70, var_88);
            wp::assign(var_72, var_89);
            wp::assign(var_74, var_90);
            goto start_for_0;
        end_for_0:;
    }
    if (!var_46) {
        // support_point = support_map(shape_data, local_x, data_provider)                    <L 469>
        var_91 = support_map_0(var_shape_data, var_11, var_data_provider);
        // max_x = wp.dot(local_x, support_point)                                             <L 470>
        var_92 = wp::dot(var_11, var_91);
        // support_point = support_map(shape_data, local_y, data_provider)                    <L 472>
        var_93 = support_map_0(var_shape_data, var_21, var_data_provider);
        // max_y = wp.dot(local_y, support_point)                                             <L 473>
        var_94 = wp::dot(var_21, var_93);
        // support_point = support_map(shape_data, local_z, data_provider)                    <L 475>
        var_95 = support_map_0(var_shape_data, var_31, var_data_provider);
        // max_z = wp.dot(local_z, support_point)                                             <L 476>
        var_96 = wp::dot(var_31, var_95);
        // support_point = support_map(shape_data, -local_x, data_provider)                   <L 478>
        var_97 = wp::neg(var_11);
        var_98 = support_map_0(var_shape_data, var_97, var_data_provider);
        // min_x = wp.dot(local_x, support_point)                                             <L 479>
        var_99 = wp::dot(var_11, var_98);
        // support_point = support_map(shape_data, -local_y, data_provider)                   <L 481>
        var_100 = wp::neg(var_21);
        var_101 = support_map_0(var_shape_data, var_100, var_data_provider);
        // min_y = wp.dot(local_y, support_point)                                             <L 482>
        var_102 = wp::dot(var_21, var_101);
        // support_point = support_map(shape_data, -local_z, data_provider)                   <L 484>
        var_103 = wp::neg(var_31);
        var_104 = support_map_0(var_shape_data, var_103, var_data_provider);
        // min_z = wp.dot(local_z, support_point)                                             <L 485>
        var_105 = wp::dot(var_31, var_104);
    }
    var_106 = wp::where(var_46, var_64, var_99);
    var_107 = wp::where(var_46, var_66, var_92);
    var_108 = wp::where(var_46, var_68, var_102);
    var_109 = wp::where(var_46, var_70, var_94);
    var_110 = wp::where(var_46, var_72, var_105);
    var_111 = wp::where(var_46, var_74, var_96);
    // aabb_min = wp.vec3(min_x, min_y, min_z) + center_pos                                   <L 488>
    var_112 = wp::vec_t<3, wp::float32>(var_106, var_108, var_110);
    var_113 = wp::add(var_112, var_center_pos);
    // aabb_max = wp.vec3(max_x, max_y, max_z) + center_pos                                   <L 489>
    var_114 = wp::vec_t<3, wp::float32>(var_107, var_109, var_111);
    var_115 = wp::add(var_114, var_center_pos);
    // return aabb_min, aabb_max                                                              <L 491>
    ret_0 = var_113;
    ret_1 = var_115;
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/collision_core.py:857
static CUDA_CALLABLE void aabb_to_unscaled_0(
    wp::vec_t<3, wp::float32> var_aabb_lower,
    wp::vec_t<3, wp::float32> var_aabb_upper,
    wp::vec_t<3, wp::float32> var_scale,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    const wp::float32 var_0 = 1e-12;
    wp::float32 var_1;
    const wp::float32 var_2 = 1.0;
    const wp::int32 var_3 = 0;
    wp::float32 var_4;
    wp::float32 var_5;
    bool var_6;
    const wp::int32 var_7 = 0;
    wp::float32 var_8;
    const wp::int32 var_9 = 0;
    wp::float32 var_10;
    const wp::float32 var_11 = 0.0;
    bool var_12;
    wp::float32 var_13;
    wp::float32 var_14;
    wp::float32 var_15;
    wp::float32 var_16;
    const wp::float32 var_17 = 1.0;
    const wp::int32 var_18 = 1;
    wp::float32 var_19;
    wp::float32 var_20;
    bool var_21;
    const wp::int32 var_22 = 1;
    wp::float32 var_23;
    const wp::int32 var_24 = 1;
    wp::float32 var_25;
    const wp::float32 var_26 = 0.0;
    bool var_27;
    wp::float32 var_28;
    wp::float32 var_29;
    wp::float32 var_30;
    wp::float32 var_31;
    const wp::float32 var_32 = 1.0;
    const wp::int32 var_33 = 2;
    wp::float32 var_34;
    wp::float32 var_35;
    bool var_36;
    const wp::int32 var_37 = 2;
    wp::float32 var_38;
    const wp::int32 var_39 = 2;
    wp::float32 var_40;
    const wp::float32 var_41 = 0.0;
    bool var_42;
    wp::float32 var_43;
    wp::float32 var_44;
    wp::float32 var_45;
    wp::float32 var_46;
    const wp::int32 var_47 = 0;
    wp::float32 var_48;
    wp::float32 var_49;
    const wp::int32 var_50 = 0;
    wp::float32 var_51;
    wp::float32 var_52;
    const wp::int32 var_53 = 1;
    wp::float32 var_54;
    wp::float32 var_55;
    const wp::int32 var_56 = 1;
    wp::float32 var_57;
    wp::float32 var_58;
    const wp::int32 var_59 = 2;
    wp::float32 var_60;
    wp::float32 var_61;
    const wp::int32 var_62 = 2;
    wp::float32 var_63;
    wp::float32 var_64;
    wp::float32 var_65;
    wp::float32 var_66;
    wp::float32 var_67;
    wp::vec_t<3, wp::float32> var_68;
    wp::float32 var_69;
    wp::float32 var_70;
    wp::float32 var_71;
    wp::vec_t<3, wp::float32> var_72;
    //---------
    // forward
    // def aabb_to_unscaled(                                                                  <L 858>
    // eps = float(1.0e-12)                                                                   <L 871>
    var_1 = wp::float(var_0);
    // inv_x = 1.0 / wp.where(wp.abs(scale[0]) > eps, scale[0], wp.where(scale[0] >= 0.0, eps, -eps))       <L 872>
    var_4 = wp::extract(var_scale, var_3);
    var_5 = wp::abs(var_4);
    var_6 = (var_5 > var_1);
    var_8 = wp::extract(var_scale, var_7);
    var_10 = wp::extract(var_scale, var_9);
    var_12 = (var_10 >= var_11);
    var_13 = wp::neg(var_1);
    var_14 = wp::where(var_12, var_1, var_13);
    var_15 = wp::where(var_6, var_8, var_14);
    var_16 = wp::div(var_2, var_15);
    // inv_y = 1.0 / wp.where(wp.abs(scale[1]) > eps, scale[1], wp.where(scale[1] >= 0.0, eps, -eps))       <L 873>
    var_19 = wp::extract(var_scale, var_18);
    var_20 = wp::abs(var_19);
    var_21 = (var_20 > var_1);
    var_23 = wp::extract(var_scale, var_22);
    var_25 = wp::extract(var_scale, var_24);
    var_27 = (var_25 >= var_26);
    var_28 = wp::neg(var_1);
    var_29 = wp::where(var_27, var_1, var_28);
    var_30 = wp::where(var_21, var_23, var_29);
    var_31 = wp::div(var_17, var_30);
    // inv_z = 1.0 / wp.where(wp.abs(scale[2]) > eps, scale[2], wp.where(scale[2] >= 0.0, eps, -eps))       <L 874>
    var_34 = wp::extract(var_scale, var_33);
    var_35 = wp::abs(var_34);
    var_36 = (var_35 > var_1);
    var_38 = wp::extract(var_scale, var_37);
    var_40 = wp::extract(var_scale, var_39);
    var_42 = (var_40 >= var_41);
    var_43 = wp::neg(var_1);
    var_44 = wp::where(var_42, var_1, var_43);
    var_45 = wp::where(var_36, var_38, var_44);
    var_46 = wp::div(var_32, var_45);
    // lx0 = aabb_lower[0] * inv_x                                                            <L 876>
    var_48 = wp::extract(var_aabb_lower, var_47);
    var_49 = wp::mul(var_48, var_16);
    // lx1 = aabb_upper[0] * inv_x                                                            <L 877>
    var_51 = wp::extract(var_aabb_upper, var_50);
    var_52 = wp::mul(var_51, var_16);
    // ly0 = aabb_lower[1] * inv_y                                                            <L 878>
    var_54 = wp::extract(var_aabb_lower, var_53);
    var_55 = wp::mul(var_54, var_31);
    // ly1 = aabb_upper[1] * inv_y                                                            <L 879>
    var_57 = wp::extract(var_aabb_upper, var_56);
    var_58 = wp::mul(var_57, var_31);
    // lz0 = aabb_lower[2] * inv_z                                                            <L 880>
    var_60 = wp::extract(var_aabb_lower, var_59);
    var_61 = wp::mul(var_60, var_46);
    // lz1 = aabb_upper[2] * inv_z                                                            <L 881>
    var_63 = wp::extract(var_aabb_upper, var_62);
    var_64 = wp::mul(var_63, var_46);
    // out_lower = wp.vec3(wp.min(lx0, lx1), wp.min(ly0, ly1), wp.min(lz0, lz1))              <L 883>
    var_65 = wp::min(var_49, var_52);
    var_66 = wp::min(var_55, var_58);
    var_67 = wp::min(var_61, var_64);
    var_68 = wp::vec_t<3, wp::float32>(var_65, var_66, var_67);
    // out_upper = wp.vec3(wp.max(lx0, lx1), wp.max(ly0, ly1), wp.max(lz0, lz1))              <L 884>
    var_69 = wp::max(var_49, var_52);
    var_70 = wp::max(var_55, var_58);
    var_71 = wp::max(var_61, var_64);
    var_72 = wp::vec_t<3, wp::float32>(var_69, var_70, var_71);
    // return out_lower, out_upper                                                            <L 885>
    ret_0 = var_68;
    ret_1 = var_72;
    return;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/collision_core.py:924
static CUDA_CALLABLE void mesh_vs_convex_midphase_0(
    wp::int32 var_idx_in_thread_block,
    wp::int32 var_mesh_shape,
    wp::int32 var_non_mesh_shape,
    wp::transform_t<wp::float32> var_X_mesh_ws,
    wp::transform_t<wp::float32> var_X_ws,
    wp::uint64 var_mesh_id,
    wp::array_t<wp::int32> var_shape_type,
    wp::array_t<wp::vec_t<4, wp::float32>> var_shape_data,
    wp::array_t<wp::uint64> var_shape_source_ptr,
    wp::float32 var_contact_threshold,
    wp::array_t<wp::vec_t<3, wp::int32>> var_triangle_pairs,
    wp::array_t<wp::int32> var_triangle_pairs_count)
{
    //---------
    // primal vars
    wp::transform_t<wp::float32> var_0;
    wp::transform_t<wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::quat_t<wp::float32> var_3;
    wp::int32* var_4;
    wp::int32 var_5;
    wp::int32 var_6;
    wp::vec_t<4, wp::float32>* var_7;
    wp::vec_t<4, wp::float32> var_8;
    wp::vec_t<4, wp::float32> var_9;
    const wp::int32 var_10 = 0;
    wp::float32 var_11;
    const wp::int32 var_12 = 1;
    wp::float32 var_13;
    const wp::int32 var_14 = 2;
    wp::float32 var_15;
    wp::vec_t<3, wp::float32> var_16;
    GenericShapeData_f25f19f5 var_17;
    const wp::float32 var_18 = 0.0;
    const wp::float32 var_19 = 0.0;
    const wp::float32 var_20 = 0.0;
    wp::vec_t<3, wp::float32> var_21;
    const wp::int32 var_22 = 10;
    bool var_23;
    wp::uint64* var_24;
    wp::vec_t<3, wp::float32> var_25;
    wp::uint64 var_26;
    SupportMapDataProvider_e77f8b9f var_27;
    wp::vec_t<3, wp::float32> var_28;
    wp::vec_t<3, wp::float32> var_29;
    wp::vec_t<4, wp::float32>* var_30;
    wp::vec_t<4, wp::float32> var_31;
    wp::vec_t<4, wp::float32> var_32;
    const wp::int32 var_33 = 0;
    wp::float32 var_34;
    const wp::int32 var_35 = 1;
    wp::float32 var_36;
    const wp::int32 var_37 = 2;
    wp::float32 var_38;
    wp::vec_t<3, wp::float32> var_39;
    wp::vec_t<3, wp::float32> var_40;
    wp::vec_t<3, wp::float32> var_41;
    const wp::int32 var_42 = 0;
    wp::float32 var_43;
    wp::float32 var_44;
    const wp::float32 var_45 = 1e-12;
    wp::float32 var_46;
    wp::float32 var_47;
    const wp::int32 var_48 = 1;
    wp::float32 var_49;
    wp::float32 var_50;
    const wp::float32 var_51 = 1e-12;
    wp::float32 var_52;
    wp::float32 var_53;
    const wp::int32 var_54 = 2;
    wp::float32 var_55;
    wp::float32 var_56;
    const wp::float32 var_57 = 1e-12;
    wp::float32 var_58;
    wp::float32 var_59;
    wp::vec_t<3, wp::float32> var_60;
    wp::vec_t<3, wp::float32> var_61;
    wp::vec_t<3, wp::float32> var_62;
    const bool var_63 = true;
    wp::mesh_query_aabb_thread_block_t var_64;
    bool var_65;
    wp::tile_register_t<wp::int32,wp::tile_layout_register_t<wp::tile_shape_t<256>>> var_66 = wp::tile_register_t<wp::int32,wp::tile_layout_register_t<wp::tile_shape_t<256>>>{};
    wp::int32 var_67;
    const wp::int32 var_68 = 0;
    const wp::int32 var_69 = 0;
    bool var_70;
    const wp::int32 var_71 = 1;
    wp::int32 var_72;
    wp::tile_register_t<wp::int32,wp::tile_layout_register_t<wp::tile_shape_t<256>>> var_73 = wp::tile_register_t<wp::int32,wp::tile_layout_register_t<wp::tile_shape_t<256>>>{};
    wp::tile_shared_t<wp::int32,wp::tile_layout_strided_t<wp::tile_shape_t<256>, wp::tile_stride_t<1>>, true> var_74 = wp::tile_alloc_empty<wp::int32,wp::tile_shape_t<256>,wp::tile_stride_t<1>,false>();
    const wp::int32 var_75 = 0;
    wp::int32 var_76;
    const wp::int32 var_77 = 1;
    wp::int32 var_78;
    bool var_79;
    const wp::int32 var_80 = 0;
    wp::int32 var_81;
    const wp::int32 var_82 = 1;
    wp::int32 var_83;
    const wp::int32 var_84 = 0;
    const wp::int32 var_85 = 256;
    bool var_86;
    wp::int32 var_87;
    wp::int32 var_88;
    wp::int32 var_89;
    wp::int32 var_90;
    wp::int32 var_91;
    wp::tile_shared_t<wp::int32,wp::tile_layout_strided_t<wp::tile_shape_t<256>, wp::tile_stride_t<1>>, true> var_92 = wp::tile_alloc_empty<wp::int32,wp::tile_shape_t<256>,wp::tile_stride_t<1>,false>();
    wp::int32 var_93;
    const wp::int32 var_94 = 1;
    wp::int32 var_95;
    const wp::int32 var_96 = 0;
    const wp::int32 var_97 = 256;
    bool var_98;
    wp::int32 var_99;
    wp::int32 var_100;
    wp::int32 var_101;
    const wp::int32 var_102 = 0;
    bool var_103;
    const wp::int32 var_104 = 0;
    const wp::int32 var_105 = 256;
    bool var_106;
    wp::int32 var_107;
    wp::int32 var_108;
    wp::int32 var_109;
    wp::int32 var_110;
    wp::int32 var_111;
    wp::shape_t* var_112;
    const wp::int32 var_113 = 0;
    wp::int32 var_114;
    wp::shape_t var_115;
    bool var_116;
    wp::vec_t<3, wp::int32> var_117;
    //---------
    // forward
    // def mesh_vs_convex_midphase(                                                           <L 925>
    // X_mesh_sw = wp.transform_inverse(X_mesh_ws)                                            <L 960>
    var_0 = wp::transform_inverse(var_X_mesh_ws);
    // X_mesh_shape = wp.transform_multiply(X_mesh_sw, X_ws)                                  <L 964>
    var_1 = wp::transform_multiply(var_0, var_X_ws);
    // pos_in_mesh = wp.transform_get_translation(X_mesh_shape)                               <L 965>
    var_2 = wp::transform_get_translation(var_1);
    // orientation_in_mesh = wp.transform_get_rotation(X_mesh_shape)                          <L 966>
    var_3 = wp::transform_get_rotation(var_1);
    // geo_type = shape_type[non_mesh_shape]                                                  <L 969>
    var_4 = wp::address(var_shape_type, var_non_mesh_shape);
    var_6 = wp::load(var_4);
    var_5 = wp::copy(var_6);
    // data_vec4 = shape_data[non_mesh_shape]                                                 <L 970>
    var_7 = wp::address(var_shape_data, var_non_mesh_shape);
    var_9 = wp::load(var_7);
    var_8 = wp::copy(var_9);
    // scale = wp.vec3(data_vec4[0], data_vec4[1], data_vec4[2])                              <L 971>
    var_11 = wp::extract(var_8, var_10);
    var_13 = wp::extract(var_8, var_12);
    var_15 = wp::extract(var_8, var_14);
    var_16 = wp::vec_t<3, wp::float32>(var_11, var_13, var_15);
    // generic_shape_data = GenericShapeData()                                                <L 973>
    var_17 = GenericShapeData_f25f19f5();
    // generic_shape_data.shape_type = geo_type                                               <L 974>
    var_17.shape_type = var_5;
    // generic_shape_data.scale = scale                                                       <L 975>
    var_17.scale = var_16;
    // generic_shape_data.auxiliary = wp.vec3(0.0, 0.0, 0.0)                                  <L 976>
    var_21 = wp::vec_t<3, wp::float32>(var_18, var_19, var_20);
    var_17.auxiliary = var_21;
    // if geo_type == GeoType.CONVEX_MESH:                                                    <L 979>
    var_23 = (var_5 == var_22);
    if (var_23) {
        // generic_shape_data.auxiliary = pack_mesh_ptr(shape_source_ptr[non_mesh_shape])       <L 980>
        var_24 = wp::address(var_shape_source_ptr, var_non_mesh_shape);
        var_26 = wp::load(var_24);
        var_25 = pack_mesh_ptr_0(var_26);
        var_17.auxiliary = var_25;
    }
    // data_provider = SupportMapDataProvider()                                               <L 982>
    var_27 = SupportMapDataProvider_e77f8b9f();
    // aabb_lower, aabb_upper = compute_tight_aabb_from_support(                              <L 987>
    // generic_shape_data, orientation_in_mesh, pos_in_mesh, data_provider                    <L 988>
    compute_tight_aabb_from_support_0(var_17, var_3, var_2, var_27, var_28, var_29);
    // mesh_scale_vec4 = shape_data[mesh_shape]                                               <L 997>
    var_30 = wp::address(var_shape_data, var_mesh_shape);
    var_32 = wp::load(var_30);
    var_31 = wp::copy(var_32);
    // mesh_scale = wp.vec3(mesh_scale_vec4[0], mesh_scale_vec4[1], mesh_scale_vec4[2])       <L 998>
    var_34 = wp::extract(var_31, var_33);
    var_36 = wp::extract(var_31, var_35);
    var_38 = wp::extract(var_31, var_37);
    var_39 = wp::vec_t<3, wp::float32>(var_34, var_36, var_38);
    // aabb_lower_bvh, aabb_upper_bvh = aabb_to_unscaled(aabb_lower, aabb_upper, mesh_scale)       <L 999>
    aabb_to_unscaled_0(var_28, var_29, var_39, var_40, var_41);
    // margin_vec = wp.vec3(                                                                  <L 1004>
    // contact_threshold / wp.max(wp.abs(mesh_scale[0]), 1.0e-12),                            <L 1005>
    var_43 = wp::extract(var_39, var_42);
    var_44 = wp::abs(var_43);
    var_46 = wp::max(var_44, var_45);
    var_47 = wp::div(var_contact_threshold, var_46);
    // contact_threshold / wp.max(wp.abs(mesh_scale[1]), 1.0e-12),                            <L 1006>
    var_49 = wp::extract(var_39, var_48);
    var_50 = wp::abs(var_49);
    var_52 = wp::max(var_50, var_51);
    var_53 = wp::div(var_contact_threshold, var_52);
    // contact_threshold / wp.max(wp.abs(mesh_scale[2]), 1.0e-12),                            <L 1007>
    var_55 = wp::extract(var_39, var_54);
    var_56 = wp::abs(var_55);
    var_58 = wp::max(var_56, var_57);
    var_59 = wp::div(var_contact_threshold, var_58);
    var_60 = wp::vec_t<3, wp::float32>(var_47, var_53, var_59);
    // aabb_lower = aabb_lower_bvh - margin_vec                                               <L 1009>
    var_61 = wp::sub(var_40, var_60);
    // aabb_upper = aabb_upper_bvh + margin_vec                                               <L 1010>
    var_62 = wp::add(var_41, var_60);
    // if wp.static(ENABLE_TILE_BVH_QUERY):                                                   <L 1012>
    // query = wp.tile_mesh_query_aabb(mesh_id, aabb_lower, aabb_upper)                       <L 1014>
    var_64 = wp::tile_mesh_query_aabb(var_mesh_id, var_61, var_62);
    // while wp.tile_query_valid(query):                                                      <L 1016>
    start_while_0:;
    var_65 = wp::tile_query_valid(var_64);
    if ((var_65) == false) goto end_while_0;
        // result_tile = wp.tile_mesh_query_aabb_next(query)                                  <L 1017>
        var_66 = wp::tile_mesh_query_aabb_next(var_64);
        // tri_index = wp.untile(result_tile)                                                 <L 1018>
        var_67 = wp::untile(var_66);
        // has_tri = 0                                                                        <L 1022>
        // if tri_index >= 0:                                                                 <L 1023>
        var_70 = (var_67 >= var_69);
        if (var_70) {
            // has_tri = 1                                                                    <L 1024>
        }
        var_72 = wp::where(var_70, var_71, var_68);
        // count_tile = wp.tile(has_tri)                                                      <L 1025>
        var_73 = wp::tile<wp::int32>(var_72);
        // inclusive_scan = wp.tile_scan_inclusive(count_tile)                                <L 1026>
        var_74 = wp::tile_scan_inclusive(var_73);
        // offset = 0                                                                         <L 1027>
        // if idx_in_thread_block == wp.block_dim() - 1:                                      <L 1028>
        var_76 = builtin_block_dim();
        var_78 = wp::sub(var_76, var_77);
        var_79 = (var_idx_in_thread_block == var_78);
        if (var_79) {
            // offset = wp.atomic_add(triangle_pairs_count, 0, inclusive_scan[wp.block_dim() - 1])       <L 1029>
            var_81 = builtin_block_dim();
            var_83 = wp::sub(var_81, var_82);
            var_86 = (var_83 < var_84);
            var_87 = wp::add(var_83, var_85);
            var_88 = wp::where(var_86, var_87, var_83);
            var_89 = wp::tile_extract(var_74, var_88);
            var_90 = wp::atomic_add(var_triangle_pairs_count, var_80, var_89);
        }
        var_91 = wp::where(var_79, var_90, var_75);
        // offset_broadcast_tile = wp.tile(offset)                                            <L 1030>
        var_92 = wp::tile<wp::int32>(var_91);
        // offset_broadcast = offset_broadcast_tile[wp.block_dim() - 1]                       <L 1031>
        var_93 = builtin_block_dim();
        var_95 = wp::sub(var_93, var_94);
        var_98 = (var_95 < var_96);
        var_99 = wp::add(var_95, var_97);
        var_100 = wp::where(var_98, var_99, var_95);
        var_101 = wp::tile_extract(var_92, var_100);
        // if tri_index >= 0:                                                                 <L 1033>
        var_103 = (var_67 >= var_102);
        if (var_103) {
            // out_idx = offset_broadcast + inclusive_scan[idx_in_thread_block] - has_tri       <L 1034>
            var_106 = (var_idx_in_thread_block < var_104);
            var_107 = wp::add(var_idx_in_thread_block, var_105);
            var_108 = wp::where(var_106, var_107, var_idx_in_thread_block);
            var_109 = wp::tile_extract(var_74, var_108);
            var_110 = wp::add(var_101, var_109);
            var_111 = wp::sub(var_110, var_72);
            // if out_idx < triangle_pairs.shape[0]:                                          <L 1035>
            var_112 = &(var_triangle_pairs.shape);
            var_115 = wp::load(var_112);
            var_114 = wp::extract(var_115, var_113);
            var_116 = (var_111 < var_114);
            if (var_116) {
                // triangle_pairs[out_idx] = wp.vec3i(mesh_shape, non_mesh_shape, tri_index)       <L 1036>
                var_117 = wp::vec_t<3, wp::int32>(var_mesh_shape, var_non_mesh_shape, var_67);
                wp::array_store(var_triangle_pairs, var_111, var_117);
            }
        }
    goto start_while_0;
    end_while_0:;
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/utils/heightfield.py:366
static CUDA_CALLABLE void adj_heightfield_vs_convex_midphase_0(
    wp::int32 var_hfield_shape,
    wp::int32 var_other_shape,
    HeightfieldData_f2b8d59a var_hfd,
    wp::array_t<wp::transform_t<wp::float32>> var_shape_transform,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_collision_aabb_lower,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_collision_aabb_upper,
    wp::array_t<wp::vec_t<4, wp::float32>> var_shape_data,
    wp::array_t<wp::float32> var_shape_gap,
    wp::array_t<wp::vec_t<3, wp::int32>> var_triangle_pairs,
    wp::array_t<wp::int32> var_triangle_pairs_count,
    wp::int32 & adj_hfield_shape,
    wp::int32 & adj_other_shape,
    HeightfieldData_f2b8d59a & adj_hfd,
    wp::array_t<wp::transform_t<wp::float32>> & adj_shape_transform,
    wp::array_t<wp::vec_t<3, wp::float32>> & adj_shape_collision_aabb_lower,
    wp::array_t<wp::vec_t<3, wp::float32>> & adj_shape_collision_aabb_upper,
    wp::array_t<wp::vec_t<4, wp::float32>> & adj_shape_data,
    wp::array_t<wp::float32> & adj_shape_gap,
    wp::array_t<wp::vec_t<3, wp::int32>> & adj_triangle_pairs,
    wp::array_t<wp::int32> & adj_triangle_pairs_count)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/support_function.py:60
static CUDA_CALLABLE void adj_pack_mesh_ptr_0(
    wp::uint64 var_ptr,
    wp::uint64 & adj_ptr,
    wp::vec_t<3, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/support_function.py:71
static CUDA_CALLABLE void adj_unpack_mesh_ptr_0(
    wp::vec_t<3, wp::float32> var_arr,
    wp::vec_t<3, wp::float32> & adj_arr,
    wp::uint64 & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/support_function.py:107
static CUDA_CALLABLE void adj_support_map_0(
    GenericShapeData_f25f19f5 var_geom,
    wp::vec_t<3, wp::float32> var_direction,
    SupportMapDataProvider_e77f8b9f var_data_provider,
    GenericShapeData_f25f19f5 & adj_geom,
    wp::vec_t<3, wp::float32> & adj_direction,
    SupportMapDataProvider_e77f8b9f & adj_data_provider,
    wp::vec_t<3, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/collision_core.py:396
static CUDA_CALLABLE void adj_compute_tight_aabb_from_support_0(
    GenericShapeData_f25f19f5 var_shape_data,
    wp::quat_t<wp::float32> var_orientation,
    wp::vec_t<3, wp::float32> var_center_pos,
    SupportMapDataProvider_e77f8b9f var_data_provider,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    GenericShapeData_f25f19f5 & adj_shape_data,
    wp::quat_t<wp::float32> & adj_orientation,
    wp::vec_t<3, wp::float32> & adj_center_pos,
    SupportMapDataProvider_e77f8b9f & adj_data_provider,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/collision_core.py:857
static CUDA_CALLABLE void adj_aabb_to_unscaled_0(
    wp::vec_t<3, wp::float32> var_aabb_lower,
    wp::vec_t<3, wp::float32> var_aabb_upper,
    wp::vec_t<3, wp::float32> var_scale,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & adj_aabb_lower,
    wp::vec_t<3, wp::float32> & adj_aabb_upper,
    wp::vec_t<3, wp::float32> & adj_scale,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/newton/repos/newton/newton/_src/geometry/collision_core.py:924
static CUDA_CALLABLE void adj_mesh_vs_convex_midphase_0(
    wp::int32 var_idx_in_thread_block,
    wp::int32 var_mesh_shape,
    wp::int32 var_non_mesh_shape,
    wp::transform_t<wp::float32> var_X_mesh_ws,
    wp::transform_t<wp::float32> var_X_ws,
    wp::uint64 var_mesh_id,
    wp::array_t<wp::int32> var_shape_type,
    wp::array_t<wp::vec_t<4, wp::float32>> var_shape_data,
    wp::array_t<wp::uint64> var_shape_source_ptr,
    wp::float32 var_contact_threshold,
    wp::array_t<wp::vec_t<3, wp::int32>> var_triangle_pairs,
    wp::array_t<wp::int32> var_triangle_pairs_count,
    wp::int32 & adj_idx_in_thread_block,
    wp::int32 & adj_mesh_shape,
    wp::int32 & adj_non_mesh_shape,
    wp::transform_t<wp::float32> & adj_X_mesh_ws,
    wp::transform_t<wp::float32> & adj_X_ws,
    wp::uint64 & adj_mesh_id,
    wp::array_t<wp::int32> & adj_shape_type,
    wp::array_t<wp::vec_t<4, wp::float32>> & adj_shape_data,
    wp::array_t<wp::uint64> & adj_shape_source_ptr,
    wp::float32 & adj_contact_threshold,
    wp::array_t<wp::vec_t<3, wp::int32>> & adj_triangle_pairs,
    wp::array_t<wp::int32> & adj_triangle_pairs_count)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}



extern "C" __global__ void verify_narrow_phase_buffers_c234c2df_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::int32> var_broad_phase_count,
    wp::int32 var_max_broad_phase,
    wp::array_t<wp::int32> var_gjk_count,
    wp::int32 var_max_gjk,
    wp::array_t<wp::int32> var_mesh_count,
    wp::int32 var_max_mesh,
    wp::array_t<wp::int32> var_triangle_count,
    wp::int32 var_max_triangle,
    wp::array_t<wp::int32> var_mesh_plane_count,
    wp::int32 var_max_mesh_plane,
    wp::array_t<wp::int32> var_mesh_mesh_count,
    wp::int32 var_max_mesh_mesh,
    wp::array_t<wp::int32> var_sdf_sdf_count,
    wp::int32 var_max_sdf_sdf,
    wp::array_t<wp::int32> var_contact_count,
    wp::int32 var_max_contacts,
    wp::array_t<wp::int32> var_reduction_ht_active_slots,
    wp::int32 var_reduction_ht_capacity,
    wp::array_t<wp::int32> var_reduction_ht_insert_failures,
    wp::int32 var_reduction_ht_warn_load_percent)
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
        wp::int32* var_1;
        bool var_2;
        wp::int32 var_3;
        const wp::str var_4 = "Warning: Broad phase pair buffer overflowed %d > %d.\n";
        const wp::int32 var_5 = 0;
        wp::int32* var_6;
        wp::int32 var_7;
        const wp::int32 var_8 = 0;
        wp::int32* var_9;
        bool var_10;
        wp::int32 var_11;
        const wp::str var_12 = "Warning: GJK candidate pair buffer overflowed %d > %d.\n";
        const wp::int32 var_13 = 0;
        wp::int32* var_14;
        wp::int32 var_15;
        const wp::int32 var_16 = 0;
        wp::int32* var_17;
        bool var_18;
        wp::int32 var_19;
        const wp::str var_20 = "Warning: Mesh-convex shape pair buffer overflowed %d > %d.\n";
        const wp::int32 var_21 = 0;
        wp::int32* var_22;
        wp::int32 var_23;
        const wp::int32 var_24 = 0;
        wp::int32* var_25;
        bool var_26;
        wp::int32 var_27;
        const wp::str var_28 = "Warning: Triangle pair buffer overflowed %d > %d.\n";
        const wp::int32 var_29 = 0;
        wp::int32* var_30;
        wp::int32 var_31;
        const wp::int32 var_32 = 0;
        wp::int32* var_33;
        bool var_34;
        wp::int32 var_35;
        const wp::str var_36 = "Warning: Mesh-plane shape pair buffer overflowed %d > %d.\n";
        const wp::int32 var_37 = 0;
        wp::int32* var_38;
        wp::int32 var_39;
        const wp::int32 var_40 = 0;
        wp::int32* var_41;
        bool var_42;
        wp::int32 var_43;
        const wp::str var_44 = "Warning: Mesh-mesh shape pair buffer overflowed %d > %d.\n";
        const wp::int32 var_45 = 0;
        wp::int32* var_46;
        wp::int32 var_47;
        const wp::int32 var_48 = 0;
        wp::int32* var_49;
        bool var_50;
        wp::int32 var_51;
        const wp::str var_52 = "Warning: SDF-SDF shape pair buffer overflowed %d > %d.\n";
        const wp::int32 var_53 = 0;
        wp::int32* var_54;
        wp::int32 var_55;
        const wp::int32 var_56 = 0;
        wp::int32* var_57;
        bool var_58;
        wp::int32 var_59;
        const wp::str var_60 = "Warning: Contact buffer overflowed %d > %d.\n";
        const wp::int32 var_61 = 0;
        wp::int32* var_62;
        wp::int32 var_63;
        const wp::int32 var_64 = 0;
        bool var_65;
        wp::int32* var_66;
        wp::int32 var_67;
        wp::int32 var_68;
        const wp::int32 var_69 = 100;
        wp::int32 var_70;
        wp::int32 var_71;
        bool var_72;
        const wp::str var_73 = "Warning: Contact reduction hashtable fill ratio exceeded %d%% (%d / %d). Increase contact_reduction_hashtable_size_factor or max_triangle_pairs.\n";
        const wp::int32 var_74 = 0;
        wp::int32* var_75;
        const wp::int32 var_76 = 0;
        bool var_77;
        wp::int32 var_78;
        const wp::str var_79 = "Warning: Contact reduction hashtable insert failures %d. Increase contact_reduction_hashtable_size_factor or max_triangle_pairs.\n";
        const wp::int32 var_80 = 0;
        wp::int32* var_81;
        wp::int32 var_82;
        //---------
        // forward
        // def verify_narrow_phase_buffers(                                                       <L 1488>
        // if broad_phase_count[0] > max_broad_phase:                                             <L 1511>
        var_1 = wp::address(var_broad_phase_count, var_0);
        var_3 = wp::load(var_1);
        var_2 = (var_3 > var_max_broad_phase);
        if (var_2) {
            // wp.printf(                                                                         <L 1512>
            // "Warning: Broad phase pair buffer overflowed %d > %d.\n",                          <L 1513>
            // broad_phase_count[0],                                                              <L 1514>
            var_6 = wp::address(var_broad_phase_count, var_5);
            // max_broad_phase,                                                                   <L 1515>
            var_7 = wp::load(var_6);
            printf(var_4, var_7, var_max_broad_phase);
        }
        // if gjk_count[0] > max_gjk:                                                             <L 1517>
        var_9 = wp::address(var_gjk_count, var_8);
        var_11 = wp::load(var_9);
        var_10 = (var_11 > var_max_gjk);
        if (var_10) {
            // wp.printf(                                                                         <L 1518>
            // "Warning: GJK candidate pair buffer overflowed %d > %d.\n",                        <L 1519>
            // gjk_count[0],                                                                      <L 1520>
            var_14 = wp::address(var_gjk_count, var_13);
            // max_gjk,                                                                           <L 1521>
            var_15 = wp::load(var_14);
            printf(var_12, var_15, var_max_gjk);
        }
        // if mesh_count:                                                                         <L 1523>
        if (var_mesh_count) {
            // if mesh_count[0] > max_mesh:                                                       <L 1524>
            var_17 = wp::address(var_mesh_count, var_16);
            var_19 = wp::load(var_17);
            var_18 = (var_19 > var_max_mesh);
            if (var_18) {
                // wp.printf(                                                                     <L 1525>
                // "Warning: Mesh-convex shape pair buffer overflowed %d > %d.\n",                <L 1526>
                // mesh_count[0],                                                                 <L 1527>
                var_22 = wp::address(var_mesh_count, var_21);
                // max_mesh,                                                                      <L 1528>
                var_23 = wp::load(var_22);
                printf(var_20, var_23, var_max_mesh);
            }
        }
        // if triangle_count:                                                                     <L 1530>
        if (var_triangle_count) {
            // if triangle_count[0] > max_triangle:                                               <L 1531>
            var_25 = wp::address(var_triangle_count, var_24);
            var_27 = wp::load(var_25);
            var_26 = (var_27 > var_max_triangle);
            if (var_26) {
                // wp.printf(                                                                     <L 1532>
                // "Warning: Triangle pair buffer overflowed %d > %d.\n",                         <L 1533>
                // triangle_count[0],                                                             <L 1534>
                var_30 = wp::address(var_triangle_count, var_29);
                // max_triangle,                                                                  <L 1535>
                var_31 = wp::load(var_30);
                printf(var_28, var_31, var_max_triangle);
            }
        }
        // if mesh_plane_count:                                                                   <L 1537>
        if (var_mesh_plane_count) {
            // if mesh_plane_count[0] > max_mesh_plane:                                           <L 1538>
            var_33 = wp::address(var_mesh_plane_count, var_32);
            var_35 = wp::load(var_33);
            var_34 = (var_35 > var_max_mesh_plane);
            if (var_34) {
                // wp.printf(                                                                     <L 1539>
                // "Warning: Mesh-plane shape pair buffer overflowed %d > %d.\n",                 <L 1540>
                // mesh_plane_count[0],                                                           <L 1541>
                var_38 = wp::address(var_mesh_plane_count, var_37);
                // max_mesh_plane,                                                                <L 1542>
                var_39 = wp::load(var_38);
                printf(var_36, var_39, var_max_mesh_plane);
            }
        }
        // if mesh_mesh_count:                                                                    <L 1544>
        if (var_mesh_mesh_count) {
            // if mesh_mesh_count[0] > max_mesh_mesh:                                             <L 1545>
            var_41 = wp::address(var_mesh_mesh_count, var_40);
            var_43 = wp::load(var_41);
            var_42 = (var_43 > var_max_mesh_mesh);
            if (var_42) {
                // wp.printf(                                                                     <L 1546>
                // "Warning: Mesh-mesh shape pair buffer overflowed %d > %d.\n",                  <L 1547>
                // mesh_mesh_count[0],                                                            <L 1548>
                var_46 = wp::address(var_mesh_mesh_count, var_45);
                // max_mesh_mesh,                                                                 <L 1549>
                var_47 = wp::load(var_46);
                printf(var_44, var_47, var_max_mesh_mesh);
            }
        }
        // if sdf_sdf_count:                                                                      <L 1551>
        if (var_sdf_sdf_count) {
            // if sdf_sdf_count[0] > max_sdf_sdf:                                                 <L 1552>
            var_49 = wp::address(var_sdf_sdf_count, var_48);
            var_51 = wp::load(var_49);
            var_50 = (var_51 > var_max_sdf_sdf);
            if (var_50) {
                // wp.printf(                                                                     <L 1553>
                // "Warning: SDF-SDF shape pair buffer overflowed %d > %d.\n",                    <L 1554>
                // sdf_sdf_count[0],                                                              <L 1555>
                var_54 = wp::address(var_sdf_sdf_count, var_53);
                // max_sdf_sdf,                                                                   <L 1556>
                var_55 = wp::load(var_54);
                printf(var_52, var_55, var_max_sdf_sdf);
            }
        }
        // if contact_count[0] > max_contacts:                                                    <L 1558>
        var_57 = wp::address(var_contact_count, var_56);
        var_59 = wp::load(var_57);
        var_58 = (var_59 > var_max_contacts);
        if (var_58) {
            // wp.printf(                                                                         <L 1559>
            // "Warning: Contact buffer overflowed %d > %d.\n",                                   <L 1560>
            // contact_count[0],                                                                  <L 1561>
            var_62 = wp::address(var_contact_count, var_61);
            // max_contacts,                                                                      <L 1562>
            var_63 = wp::load(var_62);
            printf(var_60, var_63, var_max_contacts);
        }
        // if reduction_ht_capacity > 0:                                                          <L 1564>
        var_65 = (var_reduction_ht_capacity > var_64);
        if (var_65) {
            // reduction_ht_active_count = reduction_ht_active_slots[reduction_ht_capacity]       <L 1565>
            var_66 = wp::address(var_reduction_ht_active_slots, var_reduction_ht_capacity);
            var_68 = wp::load(var_66);
            var_67 = wp::copy(var_68);
            // if reduction_ht_active_count * 100 >= reduction_ht_capacity * reduction_ht_warn_load_percent:       <L 1566>
            var_70 = wp::mul(var_67, var_69);
            var_71 = wp::mul(var_reduction_ht_capacity, var_reduction_ht_warn_load_percent);
            var_72 = (var_70 >= var_71);
            if (var_72) {
                // wp.printf(                                                                     <L 1567>
                // "Warning: Contact reduction hashtable fill ratio exceeded %d%% (%d / %d). "       <L 1568>
                // reduction_ht_warn_load_percent,                                                <L 1570>
                // reduction_ht_active_count,                                                     <L 1571>
                // reduction_ht_capacity,                                                         <L 1572>
                printf(var_73, var_reduction_ht_warn_load_percent, var_67, var_reduction_ht_capacity);
            }
            // if reduction_ht_insert_failures[0] > 0:                                            <L 1574>
            var_75 = wp::address(var_reduction_ht_insert_failures, var_74);
            var_78 = wp::load(var_75);
            var_77 = (var_78 > var_76);
            if (var_77) {
                // wp.printf(                                                                     <L 1575>
                // "Warning: Contact reduction hashtable insert failures %d. "                    <L 1576>
                // reduction_ht_insert_failures[0],                                               <L 1578>
                var_81 = wp::address(var_reduction_ht_insert_failures, var_80);
                var_82 = wp::load(var_81);
                printf(var_79, var_82);
            }
        }
    }
}



extern "C" __global__ void narrow_phase_find_mesh_triangle_overlaps_kernel_83f8c47a_cuda_kernel_forward(
    wp::launch_bounds_t<2> dim,
    wp::array_t<wp::int32> var_shape_types,
    wp::array_t<wp::transform_t<wp::float32>> var_shape_transform,
    wp::array_t<wp::uint64> var_shape_source,
    wp::array_t<wp::float32> var_shape_gap,
    wp::array_t<wp::vec_t<4, wp::float32>> var_shape_data,
    wp::array_t<wp::float32> var_shape_collision_radius,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_collision_aabb_lower,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_collision_aabb_upper,
    wp::array_t<wp::int32> var_shape_heightfield_index,
    wp::array_t<HeightfieldData_f2b8d59a> var_heightfield_data,
    wp::array_t<wp::vec_t<2, wp::int32>> var_shape_pairs_mesh,
    wp::array_t<wp::int32> var_shape_pairs_mesh_count,
    wp::int32 var_total_num_threads,
    wp::array_t<wp::vec_t<3, wp::int32>> var_triangle_pairs,
    wp::array_t<wp::int32> var_triangle_pairs_count)
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
        wp::int32 var_4;
        wp::int32 var_5;
        wp::range_t var_6;
        wp::int32 var_7;
        wp::vec_t<2, wp::int32>* var_8;
        wp::vec_t<2, wp::int32> var_9;
        wp::vec_t<2, wp::int32> var_10;
        const wp::int32 var_11 = 0;
        wp::int32 var_12;
        const wp::int32 var_13 = 1;
        wp::int32 var_14;
        wp::int32* var_15;
        wp::int32 var_16;
        wp::int32 var_17;
        wp::int32* var_18;
        wp::int32 var_19;
        wp::int32 var_20;
        const wp::int32 var_21 = 2;
        bool var_22;
        const wp::int32 var_23 = 0;
        bool var_24;
        wp::int32* var_25;
        HeightfieldData_f2b8d59a* var_26;
        wp::int32 var_27;
        HeightfieldData_f2b8d59a var_28;
        HeightfieldData_f2b8d59a var_29;
        const wp::int32 var_30 = -1;
        const wp::int32 var_31 = -1;
        bool var_32;
        const wp::int32 var_33 = 8;
        bool var_34;
        const wp::int32 var_35 = 8;
        bool var_36;
        wp::int32 var_37;
        wp::int32 var_38;
        bool var_39;
        const wp::int32 var_40 = 8;
        bool var_41;
        const wp::int32 var_42 = 8;
        bool var_43;
        wp::int32 var_44;
        wp::int32 var_45;
        wp::int32 var_46;
        wp::int32 var_47;
        wp::int32 var_48;
        wp::int32 var_49;
        wp::uint64* var_50;
        wp::uint64 var_51;
        wp::uint64 var_52;
        wp::uint64 var_53;
        bool var_54;
        wp::transform_t<wp::float32>* var_55;
        wp::transform_t<wp::float32> var_56;
        wp::transform_t<wp::float32> var_57;
        wp::transform_t<wp::float32>* var_58;
        wp::transform_t<wp::float32> var_59;
        wp::transform_t<wp::float32> var_60;
        wp::float32* var_61;
        wp::float32 var_62;
        wp::float32 var_63;
        wp::float32* var_64;
        wp::float32 var_65;
        wp::float32 var_66;
        wp::float32 var_67;
        wp::vec_t<4, wp::float32>* var_68;
        const wp::int32 var_69 = 3;
        wp::float32 var_70;
        wp::vec_t<4, wp::float32> var_71;
        wp::vec_t<4, wp::float32>* var_72;
        const wp::int32 var_73 = 3;
        wp::float32 var_74;
        wp::vec_t<4, wp::float32> var_75;
        wp::float32 var_76;
        wp::float32 var_77;
        //---------
        // forward
        // def narrow_phase_find_mesh_triangle_overlaps_kernel(                                   <L 930>
        // tid, j = wp.tid()                                                                      <L 956>
        builtin_tid2d(var_0, var_1);
        // num_mesh_pairs = shape_pairs_mesh_count[0]                                             <L 958>
        var_3 = wp::address(var_shape_pairs_mesh_count, var_2);
        var_5 = wp::load(var_3);
        var_4 = wp::copy(var_5);
        // for i in range(tid, num_mesh_pairs, total_num_threads):                                <L 961>
        var_6 = wp::range(var_0, var_4, var_total_num_threads);
        start_for_0:;
            if (iter_cmp(var_6) == 0) goto end_for_0;
            var_7 = wp::iter_next(var_6);
            // pair = shape_pairs_mesh[i]                                                         <L 962>
            var_8 = wp::address(var_shape_pairs_mesh, var_7);
            var_10 = wp::load(var_8);
            var_9 = wp::copy(var_10);
            // shape_a = pair[0]                                                                  <L 963>
            var_12 = wp::extract(var_9, var_11);
            // shape_b = pair[1]                                                                  <L 964>
            var_14 = wp::extract(var_9, var_13);
            // type_a = shape_types[shape_a]                                                      <L 966>
            var_15 = wp::address(var_shape_types, var_12);
            var_17 = wp::load(var_15);
            var_16 = wp::copy(var_17);
            // type_b = shape_types[shape_b]                                                      <L 967>
            var_18 = wp::address(var_shape_types, var_14);
            var_20 = wp::load(var_18);
            var_19 = wp::copy(var_20);
            // if type_a == GeoType.HFIELD:                                                       <L 973>
            var_22 = (var_16 == var_21);
            if (var_22) {
                // if j != 0:                                                                     <L 975>
                var_24 = (var_1 != var_23);
                if (var_24) {
                    // continue                                                                   <L 976>
                    goto start_for_0;
                }
                // hfd = heightfield_data[shape_heightfield_index[shape_a]]                       <L 977>
                var_25 = wp::address(var_shape_heightfield_index, var_12);
                var_27 = wp::load(var_25);
                var_26 = wp::address(var_heightfield_data, var_27);
                var_29 = wp::load(var_26);
                var_28 = wp::copy(var_29);
                // heightfield_vs_convex_midphase(                                                <L 978>
                // shape_a,                                                                       <L 979>
                // shape_b,                                                                       <L 980>
                // hfd,                                                                           <L 981>
                // shape_transform,                                                               <L 982>
                // shape_collision_aabb_lower,                                                    <L 983>
                // shape_collision_aabb_upper,                                                    <L 984>
                // shape_data,                                                                    <L 985>
                // shape_gap,                                                                     <L 986>
                // triangle_pairs,                                                                <L 987>
                // triangle_pairs_count,                                                          <L 988>
                heightfield_vs_convex_midphase_0(var_12, var_14, var_28, var_shape_transform, var_shape_collision_aabb_lower, var_shape_collision_aabb_upper, var_shape_data, var_shape_gap, var_triangle_pairs, var_triangle_pairs_count);
                // continue                                                                       <L 990>
                goto start_for_0;
            }
            // mesh_shape = -1                                                                    <L 995>
            // non_mesh_shape = -1                                                                <L 996>
            // if type_a == GeoType.MESH and type_b != GeoType.MESH:                              <L 998>
            var_34 = (var_16 == var_33);
            var_32 = var_34;
            if (var_32) {
                var_36 = (var_19 != var_35);
                var_32 = var_32 && var_36;
            }
            if (var_32) {
                // mesh_shape = shape_a                                                           <L 999>
                var_37 = wp::copy(var_12);
                // non_mesh_shape = shape_b                                                       <L 1000>
                var_38 = wp::copy(var_14);
            }
            if (!var_32) {
                // elif type_b == GeoType.MESH and type_a != GeoType.MESH:                        <L 1001>
                var_41 = (var_19 == var_40);
                var_39 = var_41;
                if (var_39) {
                    var_43 = (var_16 != var_42);
                    var_39 = var_39 && var_43;
                }
                if (var_39) {
                    // mesh_shape = shape_b                                                       <L 1002>
                    var_44 = wp::copy(var_14);
                    // non_mesh_shape = shape_a                                                   <L 1003>
                    var_45 = wp::copy(var_12);
                }
                if (!var_39) {
                    // continue                                                                   <L 1006>
                    goto start_for_0;
                }
                var_46 = wp::where(var_39, var_44, var_30);
                var_47 = wp::where(var_39, var_45, var_31);
            }
            var_48 = wp::where(var_32, var_37, var_46);
            var_49 = wp::where(var_32, var_38, var_47);
            // mesh_id = shape_source[mesh_shape]                                                 <L 1009>
            var_50 = wp::address(var_shape_source, var_48);
            var_52 = wp::load(var_50);
            var_51 = wp::copy(var_52);
            // if mesh_id == wp.uint64(0):                                                        <L 1010>
            var_53 = 0ull;
            var_54 = (var_51 == var_53);
            if (var_54) {
                // continue                                                                       <L 1011>
                goto start_for_0;
            }
            // X_mesh_ws = shape_transform[mesh_shape]                                            <L 1014>
            var_55 = wp::address(var_shape_transform, var_48);
            var_57 = wp::load(var_55);
            var_56 = wp::copy(var_57);
            // X_ws = shape_transform[non_mesh_shape]                                             <L 1017>
            var_58 = wp::address(var_shape_transform, var_49);
            var_60 = wp::load(var_58);
            var_59 = wp::copy(var_60);
            // gap_non_mesh = shape_gap[non_mesh_shape]                                           <L 1021>
            var_61 = wp::address(var_shape_gap, var_49);
            var_63 = wp::load(var_61);
            var_62 = wp::copy(var_63);
            // gap_mesh = shape_gap[mesh_shape]                                                   <L 1022>
            var_64 = wp::address(var_shape_gap, var_48);
            var_66 = wp::load(var_64);
            var_65 = wp::copy(var_66);
            // gap_sum = gap_non_mesh + gap_mesh                                                  <L 1023>
            var_67 = wp::add(var_62, var_65);
            // margin_non_mesh = shape_data[non_mesh_shape][3]                                    <L 1024>
            var_68 = wp::address(var_shape_data, var_49);
            var_71 = wp::load(var_68);
            var_70 = wp::extract(var_71, var_69);
            // margin_mesh = shape_data[mesh_shape][3]                                            <L 1025>
            var_72 = wp::address(var_shape_data, var_48);
            var_75 = wp::load(var_72);
            var_74 = wp::extract(var_75, var_73);
            // contact_threshold = gap_sum + margin_non_mesh + margin_mesh                        <L 1026>
            var_76 = wp::add(var_67, var_70);
            var_77 = wp::add(var_76, var_74);
            // mesh_vs_convex_midphase(                                                           <L 1029>
            // j,                                                                                 <L 1030>
            // mesh_shape,                                                                        <L 1031>
            // non_mesh_shape,                                                                    <L 1032>
            // X_mesh_ws,                                                                         <L 1033>
            // X_ws,                                                                              <L 1034>
            // mesh_id,                                                                           <L 1035>
            // shape_types,                                                                       <L 1036>
            // shape_data,                                                                        <L 1037>
            // shape_source,                                                                      <L 1038>
            // contact_threshold,                                                                 <L 1039>
            // triangle_pairs,                                                                    <L 1040>
            // triangle_pairs_count,                                                              <L 1041>
            mesh_vs_convex_midphase_0(var_1, var_48, var_49, var_56, var_59, var_51, var_shape_types, var_shape_data, var_shape_source, var_77, var_triangle_pairs, var_triangle_pairs_count);
            goto start_for_0;
        end_for_0:;
    }
}



extern "C" __global__ void compute_mesh_plane_vert_counts_1af7aff4_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::vec_t<2, wp::int32>> var_shape_pairs_mesh_plane,
    wp::array_t<wp::int32> var_shape_pairs_mesh_plane_count,
    wp::array_t<wp::uint64> var_shape_source,
    wp::array_t<wp::int32> var_vert_counts)
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
        wp::uint64* var_16;
        wp::uint64 var_17;
        wp::uint64 var_18;
        const wp::int32 var_19 = 0;
        wp::int32 var_20;
        wp::uint64 var_21;
        bool var_22;
        wp::Mesh var_23;
        wp::array_t<wp::vec_t<3, wp::float32>>* var_24;
        wp::shape_t* var_25;
        const wp::int32 var_26 = 0;
        wp::int32 var_27;
        wp::shape_t var_28;
        wp::int32 var_29;
        wp::int32 var_30;
        //---------
        // forward
        // def compute_mesh_plane_vert_counts(                                                    <L 1154>
        // i = wp.tid()                                                                           <L 1164>
        var_0 = builtin_tid1d();
        // pair_count = wp.min(shape_pairs_mesh_plane_count[0], shape_pairs_mesh_plane.shape[0])       <L 1165>
        var_2 = wp::address(var_shape_pairs_mesh_plane_count, var_1);
        var_3 = &(var_shape_pairs_mesh_plane.shape);
        var_6 = wp::load(var_3);
        var_5 = wp::extract(var_6, var_4);
        var_8 = wp::load(var_2);
        var_7 = wp::min(var_8, var_5);
        // if i >= pair_count:                                                                    <L 1166>
        var_9 = (var_0 >= var_7);
        if (var_9) {
            // vert_counts[i] = 0                                                                 <L 1167>
            wp::array_store(var_vert_counts, var_0, var_10);
            // return                                                                             <L 1168>
            continue;
        }
        // pair = shape_pairs_mesh_plane[i]                                                       <L 1170>
        var_11 = wp::address(var_shape_pairs_mesh_plane, var_0);
        var_13 = wp::load(var_11);
        var_12 = wp::copy(var_13);
        // mesh_shape = pair[0]                                                                   <L 1171>
        var_15 = wp::extract(var_12, var_14);
        // mesh_id = shape_source[mesh_shape]                                                     <L 1172>
        var_16 = wp::address(var_shape_source, var_15);
        var_18 = wp::load(var_16);
        var_17 = wp::copy(var_18);
        // pair_verts = int(0)                                                                    <L 1173>
        var_20 = wp::int(var_19);
        // if mesh_id != wp.uint64(0):                                                            <L 1174>
        var_21 = 0ull;
        var_22 = (var_17 != var_21);
        if (var_22) {
            // pair_verts = wp.mesh_get(mesh_id).points.shape[0]                                  <L 1175>
            var_23 = wp::mesh_get(var_17);
            var_24 = &(var_23.points);
            var_25 = &(var_24->shape);
            var_28 = wp::load(var_25);
            var_27 = wp::extract(var_28, var_26);
        }
        var_29 = wp::where(var_22, var_27, var_20);
        // vert_counts[i] = wp.int32(pair_verts)                                                  <L 1176>
        var_30 = wp::int32(var_29);
        wp::array_store(var_vert_counts, var_0, var_30);
    }
}

