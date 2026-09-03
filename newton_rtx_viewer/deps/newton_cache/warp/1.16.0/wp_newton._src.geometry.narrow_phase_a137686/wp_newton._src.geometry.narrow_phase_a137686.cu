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




// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/utils/heightfield.py:365
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
    // def heightfield_vs_convex_midphase(                                                    <L 366>
    // X_hfield_ws = shape_transform[hfield_shape]                                            <L 406>
    var_0 = wp::address(var_shape_transform, var_hfield_shape);
    var_2 = wp::load(var_0);
    var_1 = wp::copy(var_2);
    // X_other_ws = shape_transform[other_shape]                                              <L 407>
    var_3 = wp::address(var_shape_transform, var_other_shape);
    var_5 = wp::load(var_3);
    var_4 = wp::copy(var_5);
    // X_other_in_hfield = wp.transform_multiply(wp.transform_inverse(X_hfield_ws), X_other_ws)       <L 408>
    var_6 = wp::transform_inverse(var_1);
    var_7 = wp::transform_multiply(var_6, var_4);
    // other_pos = wp.transform_get_translation(X_other_in_hfield)                            <L 410>
    var_8 = wp::transform_get_translation(var_7);
    // other_rot = wp.transform_get_rotation(X_other_in_hfield)                               <L 411>
    var_9 = wp::transform_get_rotation(var_7);
    // local_lo = shape_collision_aabb_lower[other_shape]                                     <L 413>
    var_10 = wp::address(var_shape_collision_aabb_lower, var_other_shape);
    var_12 = wp::load(var_10);
    var_11 = wp::copy(var_12);
    // local_hi = shape_collision_aabb_upper[other_shape]                                     <L 414>
    var_13 = wp::address(var_shape_collision_aabb_upper, var_other_shape);
    var_15 = wp::load(var_13);
    var_14 = wp::copy(var_15);
    // local_center = 0.5 * (local_lo + local_hi)                                             <L 415>
    var_17 = wp::add(var_11, var_14);
    var_18 = wp::mul(var_16, var_17);
    // local_half = 0.5 * (local_hi - local_lo)                                               <L 416>
    var_20 = wp::sub(var_14, var_11);
    var_21 = wp::mul(var_19, var_20);
    // center_in_hfield = wp.quat_rotate(other_rot, local_center) + other_pos                 <L 418>
    var_22 = wp::quat_rotate(var_9, var_18);
    var_23 = wp::add(var_22, var_8);
    // r0 = wp.quat_rotate(other_rot, wp.vec3(1.0, 0.0, 0.0))                                 <L 423>
    var_27 = wp::vec_t<3, wp::float32>(var_24, var_25, var_26);
    var_28 = wp::quat_rotate(var_9, var_27);
    // r1 = wp.quat_rotate(other_rot, wp.vec3(0.0, 1.0, 0.0))                                 <L 424>
    var_32 = wp::vec_t<3, wp::float32>(var_29, var_30, var_31);
    var_33 = wp::quat_rotate(var_9, var_32);
    // r2 = wp.quat_rotate(other_rot, wp.vec3(0.0, 0.0, 1.0))                                 <L 425>
    var_37 = wp::vec_t<3, wp::float32>(var_34, var_35, var_36);
    var_38 = wp::quat_rotate(var_9, var_37);
    // half_in_hfield = wp.vec3(                                                              <L 426>
    // wp.abs(r0[0]) * local_half[0] + wp.abs(r1[0]) * local_half[1] + wp.abs(r2[0]) * local_half[2],       <L 427>
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
    // wp.abs(r0[1]) * local_half[0] + wp.abs(r1[1]) * local_half[1] + wp.abs(r2[1]) * local_half[2],       <L 428>
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
    // wp.abs(r0[2]) * local_half[0] + wp.abs(r1[2]) * local_half[1] + wp.abs(r2[2]) * local_half[2],       <L 429>
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
    // gap_sum = shape_gap[hfield_shape] + shape_gap[other_shape]                             <L 432>
    var_100 = wp::address(var_shape_gap, var_hfield_shape);
    var_101 = wp::address(var_shape_gap, var_other_shape);
    var_103 = wp::load(var_100);
    var_104 = wp::load(var_101);
    var_102 = wp::add(var_103, var_104);
    // margin_sum = shape_data[hfield_shape][3] + shape_data[other_shape][3]                  <L 433>
    var_105 = wp::address(var_shape_data, var_hfield_shape);
    var_108 = wp::load(var_105);
    var_107 = wp::extract(var_108, var_106);
    var_109 = wp::address(var_shape_data, var_other_shape);
    var_112 = wp::load(var_109);
    var_111 = wp::extract(var_112, var_110);
    var_113 = wp::add(var_107, var_111);
    // contact_threshold = gap_sum + margin_sum                                               <L 434>
    var_114 = wp::add(var_102, var_113);
    // threshold_vec = wp.vec3(contact_threshold, contact_threshold, contact_threshold)       <L 435>
    var_115 = wp::vec_t<3, wp::float32>(var_114, var_114, var_114);
    // aabb_lower = center_in_hfield - half_in_hfield - threshold_vec                         <L 437>
    var_116 = wp::sub(var_23, var_99);
    var_117 = wp::sub(var_116, var_115);
    // aabb_upper = center_in_hfield + half_in_hfield + threshold_vec                         <L 438>
    var_118 = wp::add(var_23, var_99);
    var_119 = wp::add(var_118, var_115);
    // dx = 2.0 * hfd.hx / wp.float32(hfd.ncol - 1)                                           <L 441>
    var_121 = &((var_hfd).hx);
    var_123 = wp::load(var_121);
    var_122 = wp::mul(var_120, var_123);
    var_124 = &((var_hfd).ncol);
    var_127 = wp::load(var_124);
    var_126 = wp::sub(var_127, var_125);
    var_128 = wp::float32(var_126);
    var_129 = wp::div(var_122, var_128);
    // dy = 2.0 * hfd.hy / wp.float32(hfd.nrow - 1)                                           <L 442>
    var_131 = &((var_hfd).hy);
    var_133 = wp::load(var_131);
    var_132 = wp::mul(var_130, var_133);
    var_134 = &((var_hfd).nrow);
    var_137 = wp::load(var_134);
    var_136 = wp::sub(var_137, var_135);
    var_138 = wp::float32(var_136);
    var_139 = wp::div(var_132, var_138);
    // col_min_f = (aabb_lower[0] + hfd.hx) / dx                                              <L 444>
    var_141 = wp::extract(var_117, var_140);
    var_142 = &((var_hfd).hx);
    var_144 = wp::load(var_142);
    var_143 = wp::add(var_141, var_144);
    var_145 = wp::div(var_143, var_129);
    // col_max_f = (aabb_upper[0] + hfd.hx) / dx                                              <L 445>
    var_147 = wp::extract(var_119, var_146);
    var_148 = &((var_hfd).hx);
    var_150 = wp::load(var_148);
    var_149 = wp::add(var_147, var_150);
    var_151 = wp::div(var_149, var_129);
    // row_min_f = (aabb_lower[1] + hfd.hy) / dy                                              <L 446>
    var_153 = wp::extract(var_117, var_152);
    var_154 = &((var_hfd).hy);
    var_156 = wp::load(var_154);
    var_155 = wp::add(var_153, var_156);
    var_157 = wp::div(var_155, var_139);
    // row_max_f = (aabb_upper[1] + hfd.hy) / dy                                              <L 447>
    var_159 = wp::extract(var_119, var_158);
    var_160 = &((var_hfd).hy);
    var_162 = wp::load(var_160);
    var_161 = wp::add(var_159, var_162);
    var_163 = wp::div(var_161, var_139);
    // col_min = wp.max(wp.int32(wp.floor(col_min_f)), 0)                                     <L 449>
    var_164 = wp::floor(var_145);
    var_165 = wp::int32(var_164);
    var_167 = wp::max(var_165, var_166);
    // col_max = wp.min(wp.int32(wp.floor(col_max_f)), hfd.ncol - 2)                          <L 450>
    var_168 = wp::floor(var_151);
    var_169 = wp::int32(var_168);
    var_170 = &((var_hfd).ncol);
    var_173 = wp::load(var_170);
    var_172 = wp::sub(var_173, var_171);
    var_174 = wp::min(var_169, var_172);
    // row_min = wp.max(wp.int32(wp.floor(row_min_f)), 0)                                     <L 451>
    var_175 = wp::floor(var_157);
    var_176 = wp::int32(var_175);
    var_178 = wp::max(var_176, var_177);
    // row_max = wp.min(wp.int32(wp.floor(row_max_f)), hfd.nrow - 2)                          <L 452>
    var_179 = wp::floor(var_163);
    var_180 = wp::int32(var_179);
    var_181 = &((var_hfd).nrow);
    var_184 = wp::load(var_181);
    var_183 = wp::sub(var_184, var_182);
    var_185 = wp::min(var_180, var_183);
    // cols = hfd.ncol - 1                                                                    <L 454>
    var_186 = &((var_hfd).ncol);
    var_189 = wp::load(var_186);
    var_188 = wp::sub(var_189, var_187);
    // for r in range(row_min, row_max + 1):                                                  <L 455>
    var_191 = wp::add(var_185, var_190);
    var_192 = wp::range(var_178, var_191);
    start_for_0:;
        if (iter_cmp(var_192) == 0) goto end_for_0;
        var_193 = wp::iter_next(var_192);
        // for c in range(col_min, col_max + 1):                                              <L 456>
        var_195 = wp::add(var_174, var_194);
        var_196 = wp::range(var_167, var_195);
        start_for_2:;
            if (iter_cmp(var_196) == 0) goto end_for_2;
            var_197 = wp::iter_next(var_196);
            // for tri_sub in range(2):                                                       <L 457>
            // tri_idx = (r * cols + c) * 2 + tri_sub                                         <L 458>
            var_199 = wp::mul(var_193, var_188);
            var_200 = wp::add(var_199, var_197);
            var_202 = wp::mul(var_200, var_201);
            var_203 = wp::add(var_202, var_198);
            // out_idx = wp.atomic_add(triangle_pairs_count, 0, 1)                            <L 459>
            var_206 = wp::atomic_add(var_triangle_pairs_count, var_204, var_205);
            // if out_idx < triangle_pairs.shape[0]:                                          <L 460>
            var_207 = &(var_triangle_pairs.shape);
            var_210 = wp::load(var_207);
            var_209 = wp::extract(var_210, var_208);
            var_211 = (var_206 < var_209);
            if (var_211) {
                // triangle_pairs[out_idx] = wp.vec3i(hfield_shape, other_shape, tri_idx)       <L 461>
                var_212 = wp::vec_t<3, wp::int32>(var_hfield_shape, var_other_shape, var_203);
                wp::array_store(var_triangle_pairs, var_206, var_212);
            }
            // tri_idx = (r * cols + c) * 2 + tri_sub                                         <L 458>
            var_214 = wp::mul(var_193, var_188);
            var_215 = wp::add(var_214, var_197);
            var_217 = wp::mul(var_215, var_216);
            var_218 = wp::add(var_217, var_213);
            // out_idx = wp.atomic_add(triangle_pairs_count, 0, 1)                            <L 459>
            var_221 = wp::atomic_add(var_triangle_pairs_count, var_219, var_220);
            // if out_idx < triangle_pairs.shape[0]:                                          <L 460>
            var_222 = &(var_triangle_pairs.shape);
            var_225 = wp::load(var_222);
            var_224 = wp::extract(var_225, var_223);
            var_226 = (var_221 < var_224);
            if (var_226) {
                // triangle_pairs[out_idx] = wp.vec3i(hfield_shape, other_shape, tri_idx)       <L 461>
                var_227 = wp::vec_t<3, wp::int32>(var_hfield_shape, var_other_shape, var_218);
                wp::array_store(var_triangle_pairs, var_221, var_227);
            }
            goto start_for_2;
        end_for_2:;
        goto start_for_0;
    end_for_0:;
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/collision_core.py:396
static CUDA_CALLABLE void compute_tight_aabb_from_support_0(
    GenericShapeData_ceaba563 var_shape_data,
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/collision_core.py:857
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/collision_core.py:924
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
    GenericShapeData_ceaba563 var_17;
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
    var_17 = GenericShapeData_ceaba563();
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/utils/heightfield.py:365
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/support_function.py:60
static CUDA_CALLABLE void adj_pack_mesh_ptr_0(
    wp::uint64 var_ptr,
    wp::uint64 & adj_ptr,
    wp::vec_t<3, wp::float32> & adj_ret)
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/collision_core.py:396
static CUDA_CALLABLE void adj_compute_tight_aabb_from_support_0(
    GenericShapeData_ceaba563 var_shape_data,
    wp::quat_t<wp::float32> var_orientation,
    wp::vec_t<3, wp::float32> var_center_pos,
    SupportMapDataProvider_e77f8b9f var_data_provider,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    GenericShapeData_ceaba563 & adj_shape_data,
    wp::quat_t<wp::float32> & adj_orientation,
    wp::vec_t<3, wp::float32> & adj_center_pos,
    SupportMapDataProvider_e77f8b9f & adj_data_provider,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/collision_core.py:857
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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/collision_core.py:924
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



extern "C" __global__ void narrow_phase_find_mesh_triangle_overlaps_kernel_bf80f9ff_cuda_kernel_forward(
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
        // def narrow_phase_find_mesh_triangle_overlaps_kernel(                                   <L 798>
        // tid, j = wp.tid()                                                                      <L 824>
        builtin_tid2d(var_0, var_1);
        // num_mesh_pairs = shape_pairs_mesh_count[0]                                             <L 826>
        var_3 = wp::address(var_shape_pairs_mesh_count, var_2);
        var_5 = wp::load(var_3);
        var_4 = wp::copy(var_5);
        // for i in range(tid, num_mesh_pairs, total_num_threads):                                <L 829>
        var_6 = wp::range(var_0, var_4, var_total_num_threads);
        start_for_0:;
            if (iter_cmp(var_6) == 0) goto end_for_0;
            var_7 = wp::iter_next(var_6);
            // pair = shape_pairs_mesh[i]                                                         <L 830>
            var_8 = wp::address(var_shape_pairs_mesh, var_7);
            var_10 = wp::load(var_8);
            var_9 = wp::copy(var_10);
            // shape_a = pair[0]                                                                  <L 831>
            var_12 = wp::extract(var_9, var_11);
            // shape_b = pair[1]                                                                  <L 832>
            var_14 = wp::extract(var_9, var_13);
            // type_a = shape_types[shape_a]                                                      <L 834>
            var_15 = wp::address(var_shape_types, var_12);
            var_17 = wp::load(var_15);
            var_16 = wp::copy(var_17);
            // type_b = shape_types[shape_b]                                                      <L 835>
            var_18 = wp::address(var_shape_types, var_14);
            var_20 = wp::load(var_18);
            var_19 = wp::copy(var_20);
            // if type_a == GeoType.HFIELD:                                                       <L 841>
            var_22 = (var_16 == var_21);
            if (var_22) {
                // if j != 0:                                                                     <L 843>
                var_24 = (var_1 != var_23);
                if (var_24) {
                    // continue                                                                   <L 844>
                    goto start_for_0;
                }
                // hfd = heightfield_data[shape_heightfield_index[shape_a]]                       <L 845>
                var_25 = wp::address(var_shape_heightfield_index, var_12);
                var_27 = wp::load(var_25);
                var_26 = wp::address(var_heightfield_data, var_27);
                var_29 = wp::load(var_26);
                var_28 = wp::copy(var_29);
                // heightfield_vs_convex_midphase(                                                <L 846>
                // shape_a,                                                                       <L 847>
                // shape_b,                                                                       <L 848>
                // hfd,                                                                           <L 849>
                // shape_transform,                                                               <L 850>
                // shape_collision_aabb_lower,                                                    <L 851>
                // shape_collision_aabb_upper,                                                    <L 852>
                // shape_data,                                                                    <L 853>
                // shape_gap,                                                                     <L 854>
                // triangle_pairs,                                                                <L 855>
                // triangle_pairs_count,                                                          <L 856>
                heightfield_vs_convex_midphase_0(var_12, var_14, var_28, var_shape_transform, var_shape_collision_aabb_lower, var_shape_collision_aabb_upper, var_shape_data, var_shape_gap, var_triangle_pairs, var_triangle_pairs_count);
                // continue                                                                       <L 858>
                goto start_for_0;
            }
            // mesh_shape = -1                                                                    <L 863>
            // non_mesh_shape = -1                                                                <L 864>
            // if type_a == GeoType.MESH and type_b != GeoType.MESH:                              <L 866>
            var_34 = (var_16 == var_33);
            var_32 = var_34;
            if (var_32) {
                var_36 = (var_19 != var_35);
                var_32 = var_32 && var_36;
            }
            if (var_32) {
                // mesh_shape = shape_a                                                           <L 867>
                var_37 = wp::copy(var_12);
                // non_mesh_shape = shape_b                                                       <L 868>
                var_38 = wp::copy(var_14);
            }
            if (!var_32) {
                // elif type_b == GeoType.MESH and type_a != GeoType.MESH:                        <L 869>
                var_41 = (var_19 == var_40);
                var_39 = var_41;
                if (var_39) {
                    var_43 = (var_16 != var_42);
                    var_39 = var_39 && var_43;
                }
                if (var_39) {
                    // mesh_shape = shape_b                                                       <L 870>
                    var_44 = wp::copy(var_14);
                    // non_mesh_shape = shape_a                                                   <L 871>
                    var_45 = wp::copy(var_12);
                }
                if (!var_39) {
                    // continue                                                                   <L 874>
                    goto start_for_0;
                }
                var_46 = wp::where(var_39, var_44, var_30);
                var_47 = wp::where(var_39, var_45, var_31);
            }
            var_48 = wp::where(var_32, var_37, var_46);
            var_49 = wp::where(var_32, var_38, var_47);
            // mesh_id = shape_source[mesh_shape]                                                 <L 877>
            var_50 = wp::address(var_shape_source, var_48);
            var_52 = wp::load(var_50);
            var_51 = wp::copy(var_52);
            // if mesh_id == wp.uint64(0):                                                        <L 878>
            var_53 = 0ull;
            var_54 = (var_51 == var_53);
            if (var_54) {
                // continue                                                                       <L 879>
                goto start_for_0;
            }
            // X_mesh_ws = shape_transform[mesh_shape]                                            <L 882>
            var_55 = wp::address(var_shape_transform, var_48);
            var_57 = wp::load(var_55);
            var_56 = wp::copy(var_57);
            // X_ws = shape_transform[non_mesh_shape]                                             <L 885>
            var_58 = wp::address(var_shape_transform, var_49);
            var_60 = wp::load(var_58);
            var_59 = wp::copy(var_60);
            // gap_non_mesh = shape_gap[non_mesh_shape]                                           <L 889>
            var_61 = wp::address(var_shape_gap, var_49);
            var_63 = wp::load(var_61);
            var_62 = wp::copy(var_63);
            // gap_mesh = shape_gap[mesh_shape]                                                   <L 890>
            var_64 = wp::address(var_shape_gap, var_48);
            var_66 = wp::load(var_64);
            var_65 = wp::copy(var_66);
            // gap_sum = gap_non_mesh + gap_mesh                                                  <L 891>
            var_67 = wp::add(var_62, var_65);
            // margin_non_mesh = shape_data[non_mesh_shape][3]                                    <L 892>
            var_68 = wp::address(var_shape_data, var_49);
            var_71 = wp::load(var_68);
            var_70 = wp::extract(var_71, var_69);
            // margin_mesh = shape_data[mesh_shape][3]                                            <L 893>
            var_72 = wp::address(var_shape_data, var_48);
            var_75 = wp::load(var_72);
            var_74 = wp::extract(var_75, var_73);
            // contact_threshold = gap_sum + margin_non_mesh + margin_mesh                        <L 894>
            var_76 = wp::add(var_67, var_70);
            var_77 = wp::add(var_76, var_74);
            // mesh_vs_convex_midphase(                                                           <L 897>
            // j,                                                                                 <L 898>
            // mesh_shape,                                                                        <L 899>
            // non_mesh_shape,                                                                    <L 900>
            // X_mesh_ws,                                                                         <L 901>
            // X_ws,                                                                              <L 902>
            // mesh_id,                                                                           <L 903>
            // shape_types,                                                                       <L 904>
            // shape_data,                                                                        <L 905>
            // shape_source,                                                                      <L 906>
            // contact_threshold,                                                                 <L 907>
            // triangle_pairs,                                                                    <L 908>
            // triangle_pairs_count,                                                              <L 909>
            mesh_vs_convex_midphase_0(var_1, var_48, var_49, var_56, var_59, var_51, var_shape_types, var_shape_data, var_shape_source, var_77, var_triangle_pairs, var_triangle_pairs_count);
            goto start_for_0;
        end_for_0:;
    }
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
        // def verify_narrow_phase_buffers(                                                       <L 1356>
        // if broad_phase_count[0] > max_broad_phase:                                             <L 1379>
        var_1 = wp::address(var_broad_phase_count, var_0);
        var_3 = wp::load(var_1);
        var_2 = (var_3 > var_max_broad_phase);
        if (var_2) {
            // wp.printf(                                                                         <L 1380>
            // "Warning: Broad phase pair buffer overflowed %d > %d.\n",                          <L 1381>
            // broad_phase_count[0],                                                              <L 1382>
            var_6 = wp::address(var_broad_phase_count, var_5);
            // max_broad_phase,                                                                   <L 1383>
            var_7 = wp::load(var_6);
            printf(var_4, var_7, var_max_broad_phase);
        }
        // if gjk_count[0] > max_gjk:                                                             <L 1385>
        var_9 = wp::address(var_gjk_count, var_8);
        var_11 = wp::load(var_9);
        var_10 = (var_11 > var_max_gjk);
        if (var_10) {
            // wp.printf(                                                                         <L 1386>
            // "Warning: GJK candidate pair buffer overflowed %d > %d.\n",                        <L 1387>
            // gjk_count[0],                                                                      <L 1388>
            var_14 = wp::address(var_gjk_count, var_13);
            // max_gjk,                                                                           <L 1389>
            var_15 = wp::load(var_14);
            printf(var_12, var_15, var_max_gjk);
        }
        // if mesh_count:                                                                         <L 1391>
        if (var_mesh_count) {
            // if mesh_count[0] > max_mesh:                                                       <L 1392>
            var_17 = wp::address(var_mesh_count, var_16);
            var_19 = wp::load(var_17);
            var_18 = (var_19 > var_max_mesh);
            if (var_18) {
                // wp.printf(                                                                     <L 1393>
                // "Warning: Mesh-convex shape pair buffer overflowed %d > %d.\n",                <L 1394>
                // mesh_count[0],                                                                 <L 1395>
                var_22 = wp::address(var_mesh_count, var_21);
                // max_mesh,                                                                      <L 1396>
                var_23 = wp::load(var_22);
                printf(var_20, var_23, var_max_mesh);
            }
        }
        // if triangle_count:                                                                     <L 1398>
        if (var_triangle_count) {
            // if triangle_count[0] > max_triangle:                                               <L 1399>
            var_25 = wp::address(var_triangle_count, var_24);
            var_27 = wp::load(var_25);
            var_26 = (var_27 > var_max_triangle);
            if (var_26) {
                // wp.printf(                                                                     <L 1400>
                // "Warning: Triangle pair buffer overflowed %d > %d.\n",                         <L 1401>
                // triangle_count[0],                                                             <L 1402>
                var_30 = wp::address(var_triangle_count, var_29);
                // max_triangle,                                                                  <L 1403>
                var_31 = wp::load(var_30);
                printf(var_28, var_31, var_max_triangle);
            }
        }
        // if mesh_plane_count:                                                                   <L 1405>
        if (var_mesh_plane_count) {
            // if mesh_plane_count[0] > max_mesh_plane:                                           <L 1406>
            var_33 = wp::address(var_mesh_plane_count, var_32);
            var_35 = wp::load(var_33);
            var_34 = (var_35 > var_max_mesh_plane);
            if (var_34) {
                // wp.printf(                                                                     <L 1407>
                // "Warning: Mesh-plane shape pair buffer overflowed %d > %d.\n",                 <L 1408>
                // mesh_plane_count[0],                                                           <L 1409>
                var_38 = wp::address(var_mesh_plane_count, var_37);
                // max_mesh_plane,                                                                <L 1410>
                var_39 = wp::load(var_38);
                printf(var_36, var_39, var_max_mesh_plane);
            }
        }
        // if mesh_mesh_count:                                                                    <L 1412>
        if (var_mesh_mesh_count) {
            // if mesh_mesh_count[0] > max_mesh_mesh:                                             <L 1413>
            var_41 = wp::address(var_mesh_mesh_count, var_40);
            var_43 = wp::load(var_41);
            var_42 = (var_43 > var_max_mesh_mesh);
            if (var_42) {
                // wp.printf(                                                                     <L 1414>
                // "Warning: Mesh-mesh shape pair buffer overflowed %d > %d.\n",                  <L 1415>
                // mesh_mesh_count[0],                                                            <L 1416>
                var_46 = wp::address(var_mesh_mesh_count, var_45);
                // max_mesh_mesh,                                                                 <L 1417>
                var_47 = wp::load(var_46);
                printf(var_44, var_47, var_max_mesh_mesh);
            }
        }
        // if sdf_sdf_count:                                                                      <L 1419>
        if (var_sdf_sdf_count) {
            // if sdf_sdf_count[0] > max_sdf_sdf:                                                 <L 1420>
            var_49 = wp::address(var_sdf_sdf_count, var_48);
            var_51 = wp::load(var_49);
            var_50 = (var_51 > var_max_sdf_sdf);
            if (var_50) {
                // wp.printf(                                                                     <L 1421>
                // "Warning: SDF-SDF shape pair buffer overflowed %d > %d.\n",                    <L 1422>
                // sdf_sdf_count[0],                                                              <L 1423>
                var_54 = wp::address(var_sdf_sdf_count, var_53);
                // max_sdf_sdf,                                                                   <L 1424>
                var_55 = wp::load(var_54);
                printf(var_52, var_55, var_max_sdf_sdf);
            }
        }
        // if contact_count[0] > max_contacts:                                                    <L 1426>
        var_57 = wp::address(var_contact_count, var_56);
        var_59 = wp::load(var_57);
        var_58 = (var_59 > var_max_contacts);
        if (var_58) {
            // wp.printf(                                                                         <L 1427>
            // "Warning: Contact buffer overflowed %d > %d.\n",                                   <L 1428>
            // contact_count[0],                                                                  <L 1429>
            var_62 = wp::address(var_contact_count, var_61);
            // max_contacts,                                                                      <L 1430>
            var_63 = wp::load(var_62);
            printf(var_60, var_63, var_max_contacts);
        }
        // if reduction_ht_capacity > 0:                                                          <L 1432>
        var_65 = (var_reduction_ht_capacity > var_64);
        if (var_65) {
            // reduction_ht_active_count = reduction_ht_active_slots[reduction_ht_capacity]       <L 1433>
            var_66 = wp::address(var_reduction_ht_active_slots, var_reduction_ht_capacity);
            var_68 = wp::load(var_66);
            var_67 = wp::copy(var_68);
            // if reduction_ht_active_count * 100 >= reduction_ht_capacity * reduction_ht_warn_load_percent:       <L 1434>
            var_70 = wp::mul(var_67, var_69);
            var_71 = wp::mul(var_reduction_ht_capacity, var_reduction_ht_warn_load_percent);
            var_72 = (var_70 >= var_71);
            if (var_72) {
                // wp.printf(                                                                     <L 1435>
                // "Warning: Contact reduction hashtable fill ratio exceeded %d%% (%d / %d). "       <L 1436>
                // reduction_ht_warn_load_percent,                                                <L 1438>
                // reduction_ht_active_count,                                                     <L 1439>
                // reduction_ht_capacity,                                                         <L 1440>
                printf(var_73, var_reduction_ht_warn_load_percent, var_67, var_reduction_ht_capacity);
            }
            // if reduction_ht_insert_failures[0] > 0:                                            <L 1442>
            var_75 = wp::address(var_reduction_ht_insert_failures, var_74);
            var_78 = wp::load(var_75);
            var_77 = (var_78 > var_76);
            if (var_77) {
                // wp.printf(                                                                     <L 1443>
                // "Warning: Contact reduction hashtable insert failures %d. "                    <L 1444>
                // reduction_ht_insert_failures[0],                                               <L 1446>
                var_81 = wp::address(var_reduction_ht_insert_failures, var_80);
                var_82 = wp::load(var_81);
                printf(var_79, var_82);
            }
        }
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
        // def compute_mesh_plane_vert_counts(                                                    <L 1022>
        // i = wp.tid()                                                                           <L 1032>
        var_0 = builtin_tid1d();
        // pair_count = wp.min(shape_pairs_mesh_plane_count[0], shape_pairs_mesh_plane.shape[0])       <L 1033>
        var_2 = wp::address(var_shape_pairs_mesh_plane_count, var_1);
        var_3 = &(var_shape_pairs_mesh_plane.shape);
        var_6 = wp::load(var_3);
        var_5 = wp::extract(var_6, var_4);
        var_8 = wp::load(var_2);
        var_7 = wp::min(var_8, var_5);
        // if i >= pair_count:                                                                    <L 1034>
        var_9 = (var_0 >= var_7);
        if (var_9) {
            // vert_counts[i] = 0                                                                 <L 1035>
            wp::array_store(var_vert_counts, var_0, var_10);
            // return                                                                             <L 1036>
            continue;
        }
        // pair = shape_pairs_mesh_plane[i]                                                       <L 1038>
        var_11 = wp::address(var_shape_pairs_mesh_plane, var_0);
        var_13 = wp::load(var_11);
        var_12 = wp::copy(var_13);
        // mesh_shape = pair[0]                                                                   <L 1039>
        var_15 = wp::extract(var_12, var_14);
        // mesh_id = shape_source[mesh_shape]                                                     <L 1040>
        var_16 = wp::address(var_shape_source, var_15);
        var_18 = wp::load(var_16);
        var_17 = wp::copy(var_18);
        // pair_verts = int(0)                                                                    <L 1041>
        var_20 = wp::int(var_19);
        // if mesh_id != wp.uint64(0):                                                            <L 1042>
        var_21 = 0ull;
        var_22 = (var_17 != var_21);
        if (var_22) {
            // pair_verts = wp.mesh_get(mesh_id).points.shape[0]                                  <L 1043>
            var_23 = wp::mesh_get(var_17);
            var_24 = &(var_23.points);
            var_25 = &(var_24->shape);
            var_28 = wp::load(var_25);
            var_27 = wp::extract(var_28, var_26);
        }
        var_29 = wp::where(var_22, var_27, var_20);
        // vert_counts[i] = wp.int32(pair_verts)                                                  <L 1044>
        var_30 = wp::int32(var_29);
        wp::array_store(var_vert_counts, var_0, var_30);
    }
}

