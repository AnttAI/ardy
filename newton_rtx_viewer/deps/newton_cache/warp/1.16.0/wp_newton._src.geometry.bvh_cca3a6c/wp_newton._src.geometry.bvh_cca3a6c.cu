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


struct Gaussian__Data_f03ae6a1
{
    wp::int32 num_points;
    wp::array_t<wp::transform_t<wp::float32>> transforms;
    wp::array_t<wp::vec_t<3, wp::float32>> scales;
    wp::array_t<wp::float32> opacities;
    wp::array_t<wp::float32> sh_coeffs;
    wp::uint64 bvh_id;
    wp::float32 min_response;
    wp::int32 sorting_mode;


    Gaussian__Data_f03ae6a1() = default;
    CUDA_CALLABLE Gaussian__Data_f03ae6a1(wp::int32 const& num_points,
    wp::array_t<wp::transform_t<wp::float32>> const& transforms = {},
    wp::array_t<wp::vec_t<3, wp::float32>> const& scales = {},
    wp::array_t<wp::float32> const& opacities = {},
    wp::array_t<wp::float32> const& sh_coeffs = {},
    wp::uint64 const& bvh_id = {},
    wp::float32 const& min_response = {},
    wp::int32 const& sorting_mode = {})
        : num_points{num_points}
        , transforms{transforms}
        , scales{scales}
        , opacities{opacities}
        , sh_coeffs{sh_coeffs}
        , bvh_id{bvh_id}
        , min_response{min_response}
        , sorting_mode{sorting_mode}

    {
    }

    CUDA_CALLABLE Gaussian__Data_f03ae6a1& operator += (const Gaussian__Data_f03ae6a1& rhs)
    {    num_points += rhs.num_points;
    bvh_id += rhs.bvh_id;
    min_response += rhs.min_response;
    sorting_mode += rhs.sorting_mode;

        return *this;}

};

static CUDA_CALLABLE void adj_Gaussian__Data_f03ae6a1(wp::int32 const&,
    wp::array_t<wp::transform_t<wp::float32>> const&,
    wp::array_t<wp::vec_t<3, wp::float32>> const&,
    wp::array_t<wp::float32> const&,
    wp::array_t<wp::float32> const&,
    wp::uint64 const&,
    wp::float32 const&,
    wp::int32 const&,
    wp::int32 & adj_num_points,
    wp::array_t<wp::transform_t<wp::float32>> & adj_transforms,
    wp::array_t<wp::vec_t<3, wp::float32>> & adj_scales,
    wp::array_t<wp::float32> & adj_opacities,
    wp::array_t<wp::float32> & adj_sh_coeffs,
    wp::uint64 & adj_bvh_id,
    wp::float32 & adj_min_response,
    wp::int32 & adj_sorting_mode,
    Gaussian__Data_f03ae6a1 & adj_ret)
{
    adj_num_points += adj_ret.num_points;
    adj_transforms = adj_ret.transforms;
    adj_scales = adj_ret.scales;
    adj_opacities = adj_ret.opacities;
    adj_sh_coeffs = adj_ret.sh_coeffs;
    adj_bvh_id += adj_ret.bvh_id;
    adj_min_response += adj_ret.min_response;
    adj_sorting_mode += adj_ret.sorting_mode;
}

// Required when compiling adjoints.
CUDA_CALLABLE Gaussian__Data_f03ae6a1 add(const Gaussian__Data_f03ae6a1& a, const Gaussian__Data_f03ae6a1& b)
{
    return Gaussian__Data_f03ae6a1();
}

CUDA_CALLABLE void adj_atomic_add(Gaussian__Data_f03ae6a1* p, Gaussian__Data_f03ae6a1 t)
{
    wp::adj_atomic_add(&p->num_points, t.num_points);
    wp::adj_atomic_add(&p->transforms, t.transforms);
    wp::adj_atomic_add(&p->scales, t.scales);
    wp::adj_atomic_add(&p->opacities, t.opacities);
    wp::adj_atomic_add(&p->sh_coeffs, t.sh_coeffs);
    wp::adj_atomic_add(&p->bvh_id, t.bvh_id);
    wp::adj_atomic_add(&p->min_response, t.min_response);
    wp::adj_atomic_add(&p->sorting_mode, t.sorting_mode);
}




// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/bvh.py:82
static CUDA_CALLABLE void compute_sphere_bounds_0(
    wp::vec_t<3, wp::float32> var_pos,
    wp::float32 var_radius,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    //---------
    // forward
    // def compute_sphere_bounds(pos: wp.vec3f, radius: wp.float32) -> tuple[wp.vec3f, wp.vec3f]:       <L 83>
    // return pos - wp.vec3f(radius), pos + wp.vec3f(radius)                                  <L 84>
    var_0 = wp::vec_t<3, wp::float32>(var_radius);
    var_1 = wp::sub(var_pos, var_0);
    var_2 = wp::vec_t<3, wp::float32>(var_radius);
    var_3 = wp::add(var_pos, var_2);
    ret_0 = var_1;
    ret_1 = var_3;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/bvh.py:62
static CUDA_CALLABLE void compute_box_bounds_0(
    wp::transform_t<wp::float32> var_transform,
    wp::vec_t<3, wp::float32> var_size,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    const wp::float32 var_0 = 10000000000.0;
    wp::vec_t<3, wp::float32> var_1;
    const wp::float32 var_2 = -10000000000.0;
    wp::vec_t<3, wp::float32> var_3;
    const wp::int32 var_4 = 0;
    const wp::int32 var_5 = 0;
    const wp::int32 var_6 = 0;
    const wp::int32 var_7 = 0;
    wp::float32 var_8;
    const wp::float32 var_9 = 2.0;
    wp::float32 var_10;
    wp::float32 var_11;
    const wp::float32 var_12 = 1.0;
    wp::float32 var_13;
    wp::float32 var_14;
    const wp::int32 var_15 = 1;
    wp::float32 var_16;
    const wp::float32 var_17 = 2.0;
    wp::float32 var_18;
    wp::float32 var_19;
    const wp::float32 var_20 = 1.0;
    wp::float32 var_21;
    wp::float32 var_22;
    const wp::int32 var_23 = 2;
    wp::float32 var_24;
    const wp::float32 var_25 = 2.0;
    wp::float32 var_26;
    wp::float32 var_27;
    const wp::float32 var_28 = 1.0;
    wp::float32 var_29;
    wp::float32 var_30;
    wp::vec_t<3, wp::float32> var_31;
    wp::vec_t<3, wp::float32> var_32;
    wp::vec_t<3, wp::float32> var_33;
    wp::vec_t<3, wp::float32> var_34;
    const wp::int32 var_35 = 1;
    const wp::int32 var_36 = 0;
    wp::float32 var_37;
    const wp::float32 var_38 = 2.0;
    wp::float32 var_39;
    wp::float32 var_40;
    const wp::float32 var_41 = 1.0;
    wp::float32 var_42;
    wp::float32 var_43;
    const wp::int32 var_44 = 1;
    wp::float32 var_45;
    const wp::float32 var_46 = 2.0;
    wp::float32 var_47;
    wp::float32 var_48;
    const wp::float32 var_49 = 1.0;
    wp::float32 var_50;
    wp::float32 var_51;
    const wp::int32 var_52 = 2;
    wp::float32 var_53;
    const wp::float32 var_54 = 2.0;
    wp::float32 var_55;
    wp::float32 var_56;
    const wp::float32 var_57 = 1.0;
    wp::float32 var_58;
    wp::float32 var_59;
    wp::vec_t<3, wp::float32> var_60;
    wp::vec_t<3, wp::float32> var_61;
    wp::vec_t<3, wp::float32> var_62;
    wp::vec_t<3, wp::float32> var_63;
    const wp::int32 var_64 = 1;
    const wp::int32 var_65 = 0;
    const wp::int32 var_66 = 0;
    wp::float32 var_67;
    const wp::float32 var_68 = 2.0;
    wp::float32 var_69;
    wp::float32 var_70;
    const wp::float32 var_71 = 1.0;
    wp::float32 var_72;
    wp::float32 var_73;
    const wp::int32 var_74 = 1;
    wp::float32 var_75;
    const wp::float32 var_76 = 2.0;
    wp::float32 var_77;
    wp::float32 var_78;
    const wp::float32 var_79 = 1.0;
    wp::float32 var_80;
    wp::float32 var_81;
    const wp::int32 var_82 = 2;
    wp::float32 var_83;
    const wp::float32 var_84 = 2.0;
    wp::float32 var_85;
    wp::float32 var_86;
    const wp::float32 var_87 = 1.0;
    wp::float32 var_88;
    wp::float32 var_89;
    wp::vec_t<3, wp::float32> var_90;
    wp::vec_t<3, wp::float32> var_91;
    wp::vec_t<3, wp::float32> var_92;
    wp::vec_t<3, wp::float32> var_93;
    const wp::int32 var_94 = 1;
    const wp::int32 var_95 = 0;
    wp::float32 var_96;
    const wp::float32 var_97 = 2.0;
    wp::float32 var_98;
    wp::float32 var_99;
    const wp::float32 var_100 = 1.0;
    wp::float32 var_101;
    wp::float32 var_102;
    const wp::int32 var_103 = 1;
    wp::float32 var_104;
    const wp::float32 var_105 = 2.0;
    wp::float32 var_106;
    wp::float32 var_107;
    const wp::float32 var_108 = 1.0;
    wp::float32 var_109;
    wp::float32 var_110;
    const wp::int32 var_111 = 2;
    wp::float32 var_112;
    const wp::float32 var_113 = 2.0;
    wp::float32 var_114;
    wp::float32 var_115;
    const wp::float32 var_116 = 1.0;
    wp::float32 var_117;
    wp::float32 var_118;
    wp::vec_t<3, wp::float32> var_119;
    wp::vec_t<3, wp::float32> var_120;
    wp::vec_t<3, wp::float32> var_121;
    wp::vec_t<3, wp::float32> var_122;
    const wp::int32 var_123 = 1;
    const wp::int32 var_124 = 0;
    const wp::int32 var_125 = 0;
    const wp::int32 var_126 = 0;
    wp::float32 var_127;
    const wp::float32 var_128 = 2.0;
    wp::float32 var_129;
    wp::float32 var_130;
    const wp::float32 var_131 = 1.0;
    wp::float32 var_132;
    wp::float32 var_133;
    const wp::int32 var_134 = 1;
    wp::float32 var_135;
    const wp::float32 var_136 = 2.0;
    wp::float32 var_137;
    wp::float32 var_138;
    const wp::float32 var_139 = 1.0;
    wp::float32 var_140;
    wp::float32 var_141;
    const wp::int32 var_142 = 2;
    wp::float32 var_143;
    const wp::float32 var_144 = 2.0;
    wp::float32 var_145;
    wp::float32 var_146;
    const wp::float32 var_147 = 1.0;
    wp::float32 var_148;
    wp::float32 var_149;
    wp::vec_t<3, wp::float32> var_150;
    wp::vec_t<3, wp::float32> var_151;
    wp::vec_t<3, wp::float32> var_152;
    wp::vec_t<3, wp::float32> var_153;
    const wp::int32 var_154 = 1;
    const wp::int32 var_155 = 0;
    wp::float32 var_156;
    const wp::float32 var_157 = 2.0;
    wp::float32 var_158;
    wp::float32 var_159;
    const wp::float32 var_160 = 1.0;
    wp::float32 var_161;
    wp::float32 var_162;
    const wp::int32 var_163 = 1;
    wp::float32 var_164;
    const wp::float32 var_165 = 2.0;
    wp::float32 var_166;
    wp::float32 var_167;
    const wp::float32 var_168 = 1.0;
    wp::float32 var_169;
    wp::float32 var_170;
    const wp::int32 var_171 = 2;
    wp::float32 var_172;
    const wp::float32 var_173 = 2.0;
    wp::float32 var_174;
    wp::float32 var_175;
    const wp::float32 var_176 = 1.0;
    wp::float32 var_177;
    wp::float32 var_178;
    wp::vec_t<3, wp::float32> var_179;
    wp::vec_t<3, wp::float32> var_180;
    wp::vec_t<3, wp::float32> var_181;
    wp::vec_t<3, wp::float32> var_182;
    const wp::int32 var_183 = 1;
    const wp::int32 var_184 = 0;
    const wp::int32 var_185 = 0;
    wp::float32 var_186;
    const wp::float32 var_187 = 2.0;
    wp::float32 var_188;
    wp::float32 var_189;
    const wp::float32 var_190 = 1.0;
    wp::float32 var_191;
    wp::float32 var_192;
    const wp::int32 var_193 = 1;
    wp::float32 var_194;
    const wp::float32 var_195 = 2.0;
    wp::float32 var_196;
    wp::float32 var_197;
    const wp::float32 var_198 = 1.0;
    wp::float32 var_199;
    wp::float32 var_200;
    const wp::int32 var_201 = 2;
    wp::float32 var_202;
    const wp::float32 var_203 = 2.0;
    wp::float32 var_204;
    wp::float32 var_205;
    const wp::float32 var_206 = 1.0;
    wp::float32 var_207;
    wp::float32 var_208;
    wp::vec_t<3, wp::float32> var_209;
    wp::vec_t<3, wp::float32> var_210;
    wp::vec_t<3, wp::float32> var_211;
    wp::vec_t<3, wp::float32> var_212;
    const wp::int32 var_213 = 1;
    const wp::int32 var_214 = 0;
    wp::float32 var_215;
    const wp::float32 var_216 = 2.0;
    wp::float32 var_217;
    wp::float32 var_218;
    const wp::float32 var_219 = 1.0;
    wp::float32 var_220;
    wp::float32 var_221;
    const wp::int32 var_222 = 1;
    wp::float32 var_223;
    const wp::float32 var_224 = 2.0;
    wp::float32 var_225;
    wp::float32 var_226;
    const wp::float32 var_227 = 1.0;
    wp::float32 var_228;
    wp::float32 var_229;
    const wp::int32 var_230 = 2;
    wp::float32 var_231;
    const wp::float32 var_232 = 2.0;
    wp::float32 var_233;
    wp::float32 var_234;
    const wp::float32 var_235 = 1.0;
    wp::float32 var_236;
    wp::float32 var_237;
    wp::vec_t<3, wp::float32> var_238;
    wp::vec_t<3, wp::float32> var_239;
    wp::vec_t<3, wp::float32> var_240;
    wp::vec_t<3, wp::float32> var_241;
    //---------
    // forward
    // def compute_box_bounds(transform: wp.transformf, size: wp.vec3f) -> tuple[wp.vec3f, wp.vec3f]:       <L 63>
    // min_bound = wp.vec3f(MAXVAL)                                                           <L 64>
    var_1 = wp::vec_t<3, wp::float32>(var_0);
    // max_bound = wp.vec3f(-MAXVAL)                                                          <L 65>
    var_3 = wp::vec_t<3, wp::float32>(var_2);
    // for x in range(2):                                                                     <L 67>
    // for y in range(2):                                                                     <L 68>
    // for z in range(2):                                                                     <L 69>
    // local_corner = wp.vec3f(                                                               <L 70>
    // size[0] * (2.0 * wp.float32(x) - 1.0),                                                 <L 71>
    var_8 = wp::extract(var_size, var_7);
    var_10 = wp::float32(var_4);
    var_11 = wp::mul(var_9, var_10);
    var_13 = wp::sub(var_11, var_12);
    var_14 = wp::mul(var_8, var_13);
    // size[1] * (2.0 * wp.float32(y) - 1.0),                                                 <L 72>
    var_16 = wp::extract(var_size, var_15);
    var_18 = wp::float32(var_5);
    var_19 = wp::mul(var_17, var_18);
    var_21 = wp::sub(var_19, var_20);
    var_22 = wp::mul(var_16, var_21);
    // size[2] * (2.0 * wp.float32(z) - 1.0),                                                 <L 73>
    var_24 = wp::extract(var_size, var_23);
    var_26 = wp::float32(var_6);
    var_27 = wp::mul(var_25, var_26);
    var_29 = wp::sub(var_27, var_28);
    var_30 = wp::mul(var_24, var_29);
    var_31 = wp::vec_t<3, wp::float32>(var_14, var_22, var_30);
    // world_corner = wp.transform_point(transform, local_corner)                             <L 75>
    var_32 = wp::transform_point(var_transform, var_31);
    // min_bound = wp.min(min_bound, world_corner)                                            <L 76>
    var_33 = wp::min(var_1, var_32);
    // max_bound = wp.max(max_bound, world_corner)                                            <L 77>
    var_34 = wp::max(var_3, var_32);
    // local_corner = wp.vec3f(                                                               <L 70>
    // size[0] * (2.0 * wp.float32(x) - 1.0),                                                 <L 71>
    var_37 = wp::extract(var_size, var_36);
    var_39 = wp::float32(var_4);
    var_40 = wp::mul(var_38, var_39);
    var_42 = wp::sub(var_40, var_41);
    var_43 = wp::mul(var_37, var_42);
    // size[1] * (2.0 * wp.float32(y) - 1.0),                                                 <L 72>
    var_45 = wp::extract(var_size, var_44);
    var_47 = wp::float32(var_5);
    var_48 = wp::mul(var_46, var_47);
    var_50 = wp::sub(var_48, var_49);
    var_51 = wp::mul(var_45, var_50);
    // size[2] * (2.0 * wp.float32(z) - 1.0),                                                 <L 73>
    var_53 = wp::extract(var_size, var_52);
    var_55 = wp::float32(var_35);
    var_56 = wp::mul(var_54, var_55);
    var_58 = wp::sub(var_56, var_57);
    var_59 = wp::mul(var_53, var_58);
    var_60 = wp::vec_t<3, wp::float32>(var_43, var_51, var_59);
    // world_corner = wp.transform_point(transform, local_corner)                             <L 75>
    var_61 = wp::transform_point(var_transform, var_60);
    // min_bound = wp.min(min_bound, world_corner)                                            <L 76>
    var_62 = wp::min(var_33, var_61);
    // max_bound = wp.max(max_bound, world_corner)                                            <L 77>
    var_63 = wp::max(var_34, var_61);
    // for z in range(2):                                                                     <L 69>
    // local_corner = wp.vec3f(                                                               <L 70>
    // size[0] * (2.0 * wp.float32(x) - 1.0),                                                 <L 71>
    var_67 = wp::extract(var_size, var_66);
    var_69 = wp::float32(var_4);
    var_70 = wp::mul(var_68, var_69);
    var_72 = wp::sub(var_70, var_71);
    var_73 = wp::mul(var_67, var_72);
    // size[1] * (2.0 * wp.float32(y) - 1.0),                                                 <L 72>
    var_75 = wp::extract(var_size, var_74);
    var_77 = wp::float32(var_64);
    var_78 = wp::mul(var_76, var_77);
    var_80 = wp::sub(var_78, var_79);
    var_81 = wp::mul(var_75, var_80);
    // size[2] * (2.0 * wp.float32(z) - 1.0),                                                 <L 73>
    var_83 = wp::extract(var_size, var_82);
    var_85 = wp::float32(var_65);
    var_86 = wp::mul(var_84, var_85);
    var_88 = wp::sub(var_86, var_87);
    var_89 = wp::mul(var_83, var_88);
    var_90 = wp::vec_t<3, wp::float32>(var_73, var_81, var_89);
    // world_corner = wp.transform_point(transform, local_corner)                             <L 75>
    var_91 = wp::transform_point(var_transform, var_90);
    // min_bound = wp.min(min_bound, world_corner)                                            <L 76>
    var_92 = wp::min(var_62, var_91);
    // max_bound = wp.max(max_bound, world_corner)                                            <L 77>
    var_93 = wp::max(var_63, var_91);
    // local_corner = wp.vec3f(                                                               <L 70>
    // size[0] * (2.0 * wp.float32(x) - 1.0),                                                 <L 71>
    var_96 = wp::extract(var_size, var_95);
    var_98 = wp::float32(var_4);
    var_99 = wp::mul(var_97, var_98);
    var_101 = wp::sub(var_99, var_100);
    var_102 = wp::mul(var_96, var_101);
    // size[1] * (2.0 * wp.float32(y) - 1.0),                                                 <L 72>
    var_104 = wp::extract(var_size, var_103);
    var_106 = wp::float32(var_64);
    var_107 = wp::mul(var_105, var_106);
    var_109 = wp::sub(var_107, var_108);
    var_110 = wp::mul(var_104, var_109);
    // size[2] * (2.0 * wp.float32(z) - 1.0),                                                 <L 73>
    var_112 = wp::extract(var_size, var_111);
    var_114 = wp::float32(var_94);
    var_115 = wp::mul(var_113, var_114);
    var_117 = wp::sub(var_115, var_116);
    var_118 = wp::mul(var_112, var_117);
    var_119 = wp::vec_t<3, wp::float32>(var_102, var_110, var_118);
    // world_corner = wp.transform_point(transform, local_corner)                             <L 75>
    var_120 = wp::transform_point(var_transform, var_119);
    // min_bound = wp.min(min_bound, world_corner)                                            <L 76>
    var_121 = wp::min(var_92, var_120);
    // max_bound = wp.max(max_bound, world_corner)                                            <L 77>
    var_122 = wp::max(var_93, var_120);
    // for y in range(2):                                                                     <L 68>
    // for z in range(2):                                                                     <L 69>
    // local_corner = wp.vec3f(                                                               <L 70>
    // size[0] * (2.0 * wp.float32(x) - 1.0),                                                 <L 71>
    var_127 = wp::extract(var_size, var_126);
    var_129 = wp::float32(var_123);
    var_130 = wp::mul(var_128, var_129);
    var_132 = wp::sub(var_130, var_131);
    var_133 = wp::mul(var_127, var_132);
    // size[1] * (2.0 * wp.float32(y) - 1.0),                                                 <L 72>
    var_135 = wp::extract(var_size, var_134);
    var_137 = wp::float32(var_124);
    var_138 = wp::mul(var_136, var_137);
    var_140 = wp::sub(var_138, var_139);
    var_141 = wp::mul(var_135, var_140);
    // size[2] * (2.0 * wp.float32(z) - 1.0),                                                 <L 73>
    var_143 = wp::extract(var_size, var_142);
    var_145 = wp::float32(var_125);
    var_146 = wp::mul(var_144, var_145);
    var_148 = wp::sub(var_146, var_147);
    var_149 = wp::mul(var_143, var_148);
    var_150 = wp::vec_t<3, wp::float32>(var_133, var_141, var_149);
    // world_corner = wp.transform_point(transform, local_corner)                             <L 75>
    var_151 = wp::transform_point(var_transform, var_150);
    // min_bound = wp.min(min_bound, world_corner)                                            <L 76>
    var_152 = wp::min(var_121, var_151);
    // max_bound = wp.max(max_bound, world_corner)                                            <L 77>
    var_153 = wp::max(var_122, var_151);
    // local_corner = wp.vec3f(                                                               <L 70>
    // size[0] * (2.0 * wp.float32(x) - 1.0),                                                 <L 71>
    var_156 = wp::extract(var_size, var_155);
    var_158 = wp::float32(var_123);
    var_159 = wp::mul(var_157, var_158);
    var_161 = wp::sub(var_159, var_160);
    var_162 = wp::mul(var_156, var_161);
    // size[1] * (2.0 * wp.float32(y) - 1.0),                                                 <L 72>
    var_164 = wp::extract(var_size, var_163);
    var_166 = wp::float32(var_124);
    var_167 = wp::mul(var_165, var_166);
    var_169 = wp::sub(var_167, var_168);
    var_170 = wp::mul(var_164, var_169);
    // size[2] * (2.0 * wp.float32(z) - 1.0),                                                 <L 73>
    var_172 = wp::extract(var_size, var_171);
    var_174 = wp::float32(var_154);
    var_175 = wp::mul(var_173, var_174);
    var_177 = wp::sub(var_175, var_176);
    var_178 = wp::mul(var_172, var_177);
    var_179 = wp::vec_t<3, wp::float32>(var_162, var_170, var_178);
    // world_corner = wp.transform_point(transform, local_corner)                             <L 75>
    var_180 = wp::transform_point(var_transform, var_179);
    // min_bound = wp.min(min_bound, world_corner)                                            <L 76>
    var_181 = wp::min(var_152, var_180);
    // max_bound = wp.max(max_bound, world_corner)                                            <L 77>
    var_182 = wp::max(var_153, var_180);
    // for z in range(2):                                                                     <L 69>
    // local_corner = wp.vec3f(                                                               <L 70>
    // size[0] * (2.0 * wp.float32(x) - 1.0),                                                 <L 71>
    var_186 = wp::extract(var_size, var_185);
    var_188 = wp::float32(var_123);
    var_189 = wp::mul(var_187, var_188);
    var_191 = wp::sub(var_189, var_190);
    var_192 = wp::mul(var_186, var_191);
    // size[1] * (2.0 * wp.float32(y) - 1.0),                                                 <L 72>
    var_194 = wp::extract(var_size, var_193);
    var_196 = wp::float32(var_183);
    var_197 = wp::mul(var_195, var_196);
    var_199 = wp::sub(var_197, var_198);
    var_200 = wp::mul(var_194, var_199);
    // size[2] * (2.0 * wp.float32(z) - 1.0),                                                 <L 73>
    var_202 = wp::extract(var_size, var_201);
    var_204 = wp::float32(var_184);
    var_205 = wp::mul(var_203, var_204);
    var_207 = wp::sub(var_205, var_206);
    var_208 = wp::mul(var_202, var_207);
    var_209 = wp::vec_t<3, wp::float32>(var_192, var_200, var_208);
    // world_corner = wp.transform_point(transform, local_corner)                             <L 75>
    var_210 = wp::transform_point(var_transform, var_209);
    // min_bound = wp.min(min_bound, world_corner)                                            <L 76>
    var_211 = wp::min(var_181, var_210);
    // max_bound = wp.max(max_bound, world_corner)                                            <L 77>
    var_212 = wp::max(var_182, var_210);
    // local_corner = wp.vec3f(                                                               <L 70>
    // size[0] * (2.0 * wp.float32(x) - 1.0),                                                 <L 71>
    var_215 = wp::extract(var_size, var_214);
    var_217 = wp::float32(var_123);
    var_218 = wp::mul(var_216, var_217);
    var_220 = wp::sub(var_218, var_219);
    var_221 = wp::mul(var_215, var_220);
    // size[1] * (2.0 * wp.float32(y) - 1.0),                                                 <L 72>
    var_223 = wp::extract(var_size, var_222);
    var_225 = wp::float32(var_183);
    var_226 = wp::mul(var_224, var_225);
    var_228 = wp::sub(var_226, var_227);
    var_229 = wp::mul(var_223, var_228);
    // size[2] * (2.0 * wp.float32(z) - 1.0),                                                 <L 73>
    var_231 = wp::extract(var_size, var_230);
    var_233 = wp::float32(var_213);
    var_234 = wp::mul(var_232, var_233);
    var_236 = wp::sub(var_234, var_235);
    var_237 = wp::mul(var_231, var_236);
    var_238 = wp::vec_t<3, wp::float32>(var_221, var_229, var_237);
    // world_corner = wp.transform_point(transform, local_corner)                             <L 75>
    var_239 = wp::transform_point(var_transform, var_238);
    // min_bound = wp.min(min_bound, world_corner)                                            <L 76>
    var_240 = wp::min(var_211, var_239);
    // max_bound = wp.max(max_bound, world_corner)                                            <L 77>
    var_241 = wp::max(var_212, var_239);
    // return min_bound, max_bound                                                            <L 79>
    ret_0 = var_240;
    ret_1 = var_241;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/bvh.py:87
static CUDA_CALLABLE void compute_capsule_bounds_0(
    wp::transform_t<wp::float32> var_transform,
    wp::vec_t<3, wp::float32> var_size,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    wp::float32 var_1;
    const wp::int32 var_2 = 1;
    wp::float32 var_3;
    wp::float32 var_4;
    wp::vec_t<3, wp::float32> var_5;
    wp::vec_t<3, wp::float32> var_6;
    wp::vec_t<3, wp::float32> var_7;
    //---------
    // forward
    // def compute_capsule_bounds(transform: wp.transformf, size: wp.vec3f) -> tuple[wp.vec3f, wp.vec3f]:       <L 88>
    // radius = size[0]                                                                       <L 89>
    var_1 = wp::extract(var_size, var_0);
    // half_length = size[1]                                                                  <L 90>
    var_3 = wp::extract(var_size, var_2);
    // extent = wp.vec3f(radius, radius, half_length + radius)                                <L 91>
    var_4 = wp::add(var_3, var_1);
    var_5 = wp::vec_t<3, wp::float32>(var_1, var_1, var_4);
    // return compute_box_bounds(transform, extent)                                           <L 92>
    compute_box_bounds_0(var_transform, var_5, var_6, var_7);
    ret_0 = var_6;
    ret_1 = var_7;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/bvh.py:95
static CUDA_CALLABLE void compute_cylinder_bounds_0(
    wp::transform_t<wp::float32> var_transform,
    wp::vec_t<3, wp::float32> var_size,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    wp::float32 var_1;
    const wp::int32 var_2 = 1;
    wp::float32 var_3;
    wp::vec_t<3, wp::float32> var_4;
    wp::vec_t<3, wp::float32> var_5;
    wp::vec_t<3, wp::float32> var_6;
    //---------
    // forward
    // def compute_cylinder_bounds(transform: wp.transformf, size: wp.vec3f) -> tuple[wp.vec3f, wp.vec3f]:       <L 96>
    // radius = size[0]                                                                       <L 97>
    var_1 = wp::extract(var_size, var_0);
    // half_length = size[1]                                                                  <L 98>
    var_3 = wp::extract(var_size, var_2);
    // extent = wp.vec3f(radius, radius, half_length)                                         <L 99>
    var_4 = wp::vec_t<3, wp::float32>(var_1, var_1, var_3);
    // return compute_box_bounds(transform, extent)                                           <L 100>
    compute_box_bounds_0(var_transform, var_4, var_5, var_6);
    ret_0 = var_5;
    ret_1 = var_6;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/bvh.py:103
static CUDA_CALLABLE void compute_cone_bounds_0(
    wp::transform_t<wp::float32> var_transform,
    wp::vec_t<3, wp::float32> var_size,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    wp::float32 var_1;
    const wp::int32 var_2 = 0;
    wp::float32 var_3;
    const wp::int32 var_4 = 1;
    wp::float32 var_5;
    wp::vec_t<3, wp::float32> var_6;
    wp::vec_t<3, wp::float32> var_7;
    wp::vec_t<3, wp::float32> var_8;
    //---------
    // forward
    // def compute_cone_bounds(transform: wp.transformf, size: wp.vec3f) -> tuple[wp.vec3f, wp.vec3f]:       <L 104>
    // extent = wp.vec3f(size[0], size[0], size[1])                                           <L 105>
    var_1 = wp::extract(var_size, var_0);
    var_3 = wp::extract(var_size, var_2);
    var_5 = wp::extract(var_size, var_4);
    var_6 = wp::vec_t<3, wp::float32>(var_1, var_3, var_5);
    // return compute_box_bounds(transform, extent)                                           <L 106>
    compute_box_bounds_0(var_transform, var_6, var_7, var_8);
    ret_0 = var_7;
    ret_1 = var_8;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/bvh.py:109
static CUDA_CALLABLE void compute_plane_bounds_0(
    wp::transform_t<wp::float32> var_transform,
    wp::vec_t<3, wp::float32> var_size,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    wp::float32 var_1;
    const wp::int32 var_2 = 1;
    wp::float32 var_3;
    wp::float32 var_4;
    const wp::float32 var_5 = 2.0;
    wp::float32 var_6;
    bool var_7;
    const wp::int32 var_8 = 0;
    wp::float32 var_9;
    const wp::float32 var_10 = 0.0;
    bool var_11;
    const wp::int32 var_12 = 1;
    wp::float32 var_13;
    const wp::float32 var_14 = 0.0;
    bool var_15;
    const wp::float32 var_16 = 1000.0;
    wp::float32 var_17;
    const wp::float32 var_18 = 10000000000.0;
    wp::vec_t<3, wp::float32> var_19;
    const wp::float32 var_20 = -10000000000.0;
    wp::vec_t<3, wp::float32> var_21;
    const wp::int32 var_22 = 0;
    const wp::int32 var_23 = 0;
    const wp::float32 var_24 = 2.0;
    wp::float32 var_25;
    wp::float32 var_26;
    const wp::float32 var_27 = 1.0;
    wp::float32 var_28;
    wp::float32 var_29;
    const wp::float32 var_30 = 2.0;
    wp::float32 var_31;
    wp::float32 var_32;
    const wp::float32 var_33 = 1.0;
    wp::float32 var_34;
    wp::float32 var_35;
    const wp::float32 var_36 = 0.0;
    wp::vec_t<3, wp::float32> var_37;
    wp::vec_t<3, wp::float32> var_38;
    wp::vec_t<3, wp::float32> var_39;
    wp::vec_t<3, wp::float32> var_40;
    const wp::int32 var_41 = 1;
    const wp::float32 var_42 = 2.0;
    wp::float32 var_43;
    wp::float32 var_44;
    const wp::float32 var_45 = 1.0;
    wp::float32 var_46;
    wp::float32 var_47;
    const wp::float32 var_48 = 2.0;
    wp::float32 var_49;
    wp::float32 var_50;
    const wp::float32 var_51 = 1.0;
    wp::float32 var_52;
    wp::float32 var_53;
    const wp::float32 var_54 = 0.0;
    wp::vec_t<3, wp::float32> var_55;
    wp::vec_t<3, wp::float32> var_56;
    wp::vec_t<3, wp::float32> var_57;
    wp::vec_t<3, wp::float32> var_58;
    const wp::int32 var_59 = 1;
    const wp::int32 var_60 = 0;
    const wp::float32 var_61 = 2.0;
    wp::float32 var_62;
    wp::float32 var_63;
    const wp::float32 var_64 = 1.0;
    wp::float32 var_65;
    wp::float32 var_66;
    const wp::float32 var_67 = 2.0;
    wp::float32 var_68;
    wp::float32 var_69;
    const wp::float32 var_70 = 1.0;
    wp::float32 var_71;
    wp::float32 var_72;
    const wp::float32 var_73 = 0.0;
    wp::vec_t<3, wp::float32> var_74;
    wp::vec_t<3, wp::float32> var_75;
    wp::vec_t<3, wp::float32> var_76;
    wp::vec_t<3, wp::float32> var_77;
    const wp::int32 var_78 = 1;
    const wp::float32 var_79 = 2.0;
    wp::float32 var_80;
    wp::float32 var_81;
    const wp::float32 var_82 = 1.0;
    wp::float32 var_83;
    wp::float32 var_84;
    const wp::float32 var_85 = 2.0;
    wp::float32 var_86;
    wp::float32 var_87;
    const wp::float32 var_88 = 1.0;
    wp::float32 var_89;
    wp::float32 var_90;
    const wp::float32 var_91 = 0.0;
    wp::vec_t<3, wp::float32> var_92;
    wp::vec_t<3, wp::float32> var_93;
    wp::vec_t<3, wp::float32> var_94;
    wp::vec_t<3, wp::float32> var_95;
    const wp::float32 var_96 = 0.1;
    wp::vec_t<3, wp::float32> var_97;
    wp::vec_t<3, wp::float32> var_98;
    wp::vec_t<3, wp::float32> var_99;
    //---------
    // forward
    // def compute_plane_bounds(transform: wp.transformf, size: wp.vec3f) -> tuple[wp.vec3f, wp.vec3f]:       <L 110>
    // size_scale = wp.max(size[0], size[1]) * 2.0                                            <L 112>
    var_1 = wp::extract(var_size, var_0);
    var_3 = wp::extract(var_size, var_2);
    var_4 = wp::max(var_1, var_3);
    var_6 = wp::mul(var_4, var_5);
    // if size[0] <= 0.0 or size[1] <= 0.0:                                                   <L 113>
    var_9 = wp::extract(var_size, var_8);
    var_11 = (var_9 <= var_10);
    var_7 = var_11;
    if (!var_7) {
        var_13 = wp::extract(var_size, var_12);
        var_15 = (var_13 <= var_14);
        var_7 = var_7 || var_15;
    }
    if (var_7) {
        // size_scale = 1000.0                                                                <L 114>
    }
    var_17 = wp::where(var_7, var_16, var_6);
    // min_bound = wp.vec3f(MAXVAL)                                                           <L 116>
    var_19 = wp::vec_t<3, wp::float32>(var_18);
    // max_bound = wp.vec3f(-MAXVAL)                                                          <L 117>
    var_21 = wp::vec_t<3, wp::float32>(var_20);
    // for x in range(2):                                                                     <L 119>
    // for y in range(2):                                                                     <L 120>
    // local_corner = wp.vec3f(                                                               <L 121>
    // size_scale * (2.0 * wp.float32(x) - 1.0),                                              <L 122>
    var_25 = wp::float32(var_22);
    var_26 = wp::mul(var_24, var_25);
    var_28 = wp::sub(var_26, var_27);
    var_29 = wp::mul(var_17, var_28);
    // size_scale * (2.0 * wp.float32(y) - 1.0),                                              <L 123>
    var_31 = wp::float32(var_23);
    var_32 = wp::mul(var_30, var_31);
    var_34 = wp::sub(var_32, var_33);
    var_35 = wp::mul(var_17, var_34);
    // 0.0,                                                                                   <L 124>
    var_37 = wp::vec_t<3, wp::float32>(var_29, var_35, var_36);
    // world_corner = wp.transform_point(transform, local_corner)                             <L 126>
    var_38 = wp::transform_point(var_transform, var_37);
    // min_bound = wp.min(min_bound, world_corner)                                            <L 127>
    var_39 = wp::min(var_19, var_38);
    // max_bound = wp.max(max_bound, world_corner)                                            <L 128>
    var_40 = wp::max(var_21, var_38);
    // local_corner = wp.vec3f(                                                               <L 121>
    // size_scale * (2.0 * wp.float32(x) - 1.0),                                              <L 122>
    var_43 = wp::float32(var_22);
    var_44 = wp::mul(var_42, var_43);
    var_46 = wp::sub(var_44, var_45);
    var_47 = wp::mul(var_17, var_46);
    // size_scale * (2.0 * wp.float32(y) - 1.0),                                              <L 123>
    var_49 = wp::float32(var_41);
    var_50 = wp::mul(var_48, var_49);
    var_52 = wp::sub(var_50, var_51);
    var_53 = wp::mul(var_17, var_52);
    // 0.0,                                                                                   <L 124>
    var_55 = wp::vec_t<3, wp::float32>(var_47, var_53, var_54);
    // world_corner = wp.transform_point(transform, local_corner)                             <L 126>
    var_56 = wp::transform_point(var_transform, var_55);
    // min_bound = wp.min(min_bound, world_corner)                                            <L 127>
    var_57 = wp::min(var_39, var_56);
    // max_bound = wp.max(max_bound, world_corner)                                            <L 128>
    var_58 = wp::max(var_40, var_56);
    // for y in range(2):                                                                     <L 120>
    // local_corner = wp.vec3f(                                                               <L 121>
    // size_scale * (2.0 * wp.float32(x) - 1.0),                                              <L 122>
    var_62 = wp::float32(var_59);
    var_63 = wp::mul(var_61, var_62);
    var_65 = wp::sub(var_63, var_64);
    var_66 = wp::mul(var_17, var_65);
    // size_scale * (2.0 * wp.float32(y) - 1.0),                                              <L 123>
    var_68 = wp::float32(var_60);
    var_69 = wp::mul(var_67, var_68);
    var_71 = wp::sub(var_69, var_70);
    var_72 = wp::mul(var_17, var_71);
    // 0.0,                                                                                   <L 124>
    var_74 = wp::vec_t<3, wp::float32>(var_66, var_72, var_73);
    // world_corner = wp.transform_point(transform, local_corner)                             <L 126>
    var_75 = wp::transform_point(var_transform, var_74);
    // min_bound = wp.min(min_bound, world_corner)                                            <L 127>
    var_76 = wp::min(var_57, var_75);
    // max_bound = wp.max(max_bound, world_corner)                                            <L 128>
    var_77 = wp::max(var_58, var_75);
    // local_corner = wp.vec3f(                                                               <L 121>
    // size_scale * (2.0 * wp.float32(x) - 1.0),                                              <L 122>
    var_80 = wp::float32(var_59);
    var_81 = wp::mul(var_79, var_80);
    var_83 = wp::sub(var_81, var_82);
    var_84 = wp::mul(var_17, var_83);
    // size_scale * (2.0 * wp.float32(y) - 1.0),                                              <L 123>
    var_86 = wp::float32(var_78);
    var_87 = wp::mul(var_85, var_86);
    var_89 = wp::sub(var_87, var_88);
    var_90 = wp::mul(var_17, var_89);
    // 0.0,                                                                                   <L 124>
    var_92 = wp::vec_t<3, wp::float32>(var_84, var_90, var_91);
    // world_corner = wp.transform_point(transform, local_corner)                             <L 126>
    var_93 = wp::transform_point(var_transform, var_92);
    // min_bound = wp.min(min_bound, world_corner)                                            <L 127>
    var_94 = wp::min(var_76, var_93);
    // max_bound = wp.max(max_bound, world_corner)                                            <L 128>
    var_95 = wp::max(var_77, var_93);
    // extent = wp.vec3f(0.1)                                                                 <L 130>
    var_97 = wp::vec_t<3, wp::float32>(var_96);
    // return min_bound - extent, max_bound + extent                                          <L 131>
    var_98 = wp::sub(var_94, var_97);
    var_99 = wp::add(var_95, var_97);
    ret_0 = var_98;
    ret_1 = var_99;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/bvh.py:134
static CUDA_CALLABLE void compute_ellipsoid_bounds_0(
    wp::transform_t<wp::float32> var_transform,
    wp::vec_t<3, wp::float32> var_size,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    wp::float32 var_1;
    wp::float32 var_2;
    const wp::int32 var_3 = 1;
    wp::float32 var_4;
    wp::float32 var_5;
    const wp::int32 var_6 = 2;
    wp::float32 var_7;
    wp::float32 var_8;
    wp::vec_t<3, wp::float32> var_9;
    wp::vec_t<3, wp::float32> var_10;
    wp::vec_t<3, wp::float32> var_11;
    //---------
    // forward
    // def compute_ellipsoid_bounds(transform: wp.transformf, size: wp.vec3f) -> tuple[wp.vec3f, wp.vec3f]:       <L 135>
    // extent = wp.vec3f(wp.abs(size[0]), wp.abs(size[1]), wp.abs(size[2]))                   <L 136>
    var_1 = wp::extract(var_size, var_0);
    var_2 = wp::abs(var_1);
    var_4 = wp::extract(var_size, var_3);
    var_5 = wp::abs(var_4);
    var_7 = wp::extract(var_size, var_6);
    var_8 = wp::abs(var_7);
    var_9 = wp::vec_t<3, wp::float32>(var_2, var_5, var_8);
    // return compute_box_bounds(transform, extent)                                           <L 137>
    compute_box_bounds_0(var_transform, var_9, var_10, var_11);
    ret_0 = var_10;
    ret_1 = var_11;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/bvh.py:17
static CUDA_CALLABLE void compute_shape_bounds_0(
    wp::transform_t<wp::float32> var_transform,
    wp::vec_t<3, wp::float32> var_scale,
    wp::vec_t<3, wp::float32> var_shape_min_bounds,
    wp::vec_t<3, wp::float32> var_shape_max_bounds,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    const wp::float32 var_2 = 10000000000.0;
    wp::vec_t<3, wp::float32> var_3;
    const wp::float32 var_4 = -10000000000.0;
    wp::vec_t<3, wp::float32> var_5;
    const wp::int32 var_6 = 0;
    wp::float32 var_7;
    const wp::int32 var_8 = 1;
    wp::float32 var_9;
    const wp::int32 var_10 = 2;
    wp::float32 var_11;
    wp::vec_t<3, wp::float32> var_12;
    wp::vec_t<3, wp::float32> var_13;
    wp::vec_t<3, wp::float32> var_14;
    wp::vec_t<3, wp::float32> var_15;
    const wp::int32 var_16 = 0;
    wp::float32 var_17;
    const wp::int32 var_18 = 1;
    wp::float32 var_19;
    const wp::int32 var_20 = 2;
    wp::float32 var_21;
    wp::vec_t<3, wp::float32> var_22;
    wp::vec_t<3, wp::float32> var_23;
    wp::vec_t<3, wp::float32> var_24;
    wp::vec_t<3, wp::float32> var_25;
    const wp::int32 var_26 = 0;
    wp::float32 var_27;
    const wp::int32 var_28 = 1;
    wp::float32 var_29;
    const wp::int32 var_30 = 2;
    wp::float32 var_31;
    wp::vec_t<3, wp::float32> var_32;
    wp::vec_t<3, wp::float32> var_33;
    wp::vec_t<3, wp::float32> var_34;
    wp::vec_t<3, wp::float32> var_35;
    const wp::int32 var_36 = 0;
    wp::float32 var_37;
    const wp::int32 var_38 = 1;
    wp::float32 var_39;
    const wp::int32 var_40 = 2;
    wp::float32 var_41;
    wp::vec_t<3, wp::float32> var_42;
    wp::vec_t<3, wp::float32> var_43;
    wp::vec_t<3, wp::float32> var_44;
    wp::vec_t<3, wp::float32> var_45;
    const wp::int32 var_46 = 0;
    wp::float32 var_47;
    const wp::int32 var_48 = 1;
    wp::float32 var_49;
    const wp::int32 var_50 = 2;
    wp::float32 var_51;
    wp::vec_t<3, wp::float32> var_52;
    wp::vec_t<3, wp::float32> var_53;
    wp::vec_t<3, wp::float32> var_54;
    wp::vec_t<3, wp::float32> var_55;
    const wp::int32 var_56 = 0;
    wp::float32 var_57;
    const wp::int32 var_58 = 1;
    wp::float32 var_59;
    const wp::int32 var_60 = 2;
    wp::float32 var_61;
    wp::vec_t<3, wp::float32> var_62;
    wp::vec_t<3, wp::float32> var_63;
    wp::vec_t<3, wp::float32> var_64;
    wp::vec_t<3, wp::float32> var_65;
    const wp::int32 var_66 = 0;
    wp::float32 var_67;
    const wp::int32 var_68 = 1;
    wp::float32 var_69;
    const wp::int32 var_70 = 2;
    wp::float32 var_71;
    wp::vec_t<3, wp::float32> var_72;
    wp::vec_t<3, wp::float32> var_73;
    wp::vec_t<3, wp::float32> var_74;
    wp::vec_t<3, wp::float32> var_75;
    const wp::int32 var_76 = 0;
    wp::float32 var_77;
    const wp::int32 var_78 = 1;
    wp::float32 var_79;
    const wp::int32 var_80 = 2;
    wp::float32 var_81;
    wp::vec_t<3, wp::float32> var_82;
    wp::vec_t<3, wp::float32> var_83;
    wp::vec_t<3, wp::float32> var_84;
    wp::vec_t<3, wp::float32> var_85;
    //---------
    // forward
    // def compute_shape_bounds(                                                              <L 18>
    // shape_min_bounds = wp.cw_mul(shape_min_bounds, scale)                                  <L 21>
    var_0 = wp::cw_mul(var_shape_min_bounds, var_scale);
    // shape_max_bounds = wp.cw_mul(shape_max_bounds, scale)                                  <L 22>
    var_1 = wp::cw_mul(var_shape_max_bounds, var_scale);
    // min_bound = wp.vec3f(MAXVAL)                                                           <L 24>
    var_3 = wp::vec_t<3, wp::float32>(var_2);
    // max_bound = wp.vec3f(-MAXVAL)                                                          <L 25>
    var_5 = wp::vec_t<3, wp::float32>(var_4);
    // corner_1 = wp.transform_point(transform, wp.vec3f(shape_min_bounds[0], shape_min_bounds[1], shape_min_bounds[2]))       <L 27>
    var_7 = wp::extract(var_0, var_6);
    var_9 = wp::extract(var_0, var_8);
    var_11 = wp::extract(var_0, var_10);
    var_12 = wp::vec_t<3, wp::float32>(var_7, var_9, var_11);
    var_13 = wp::transform_point(var_transform, var_12);
    // min_bound = wp.min(min_bound, corner_1)                                                <L 28>
    var_14 = wp::min(var_3, var_13);
    // max_bound = wp.max(max_bound, corner_1)                                                <L 29>
    var_15 = wp::max(var_5, var_13);
    // corner_2 = wp.transform_point(transform, wp.vec3f(shape_max_bounds[0], shape_min_bounds[1], shape_min_bounds[2]))       <L 31>
    var_17 = wp::extract(var_1, var_16);
    var_19 = wp::extract(var_0, var_18);
    var_21 = wp::extract(var_0, var_20);
    var_22 = wp::vec_t<3, wp::float32>(var_17, var_19, var_21);
    var_23 = wp::transform_point(var_transform, var_22);
    // min_bound = wp.min(min_bound, corner_2)                                                <L 32>
    var_24 = wp::min(var_14, var_23);
    // max_bound = wp.max(max_bound, corner_2)                                                <L 33>
    var_25 = wp::max(var_15, var_23);
    // corner_3 = wp.transform_point(transform, wp.vec3f(shape_max_bounds[0], shape_max_bounds[1], shape_min_bounds[2]))       <L 35>
    var_27 = wp::extract(var_1, var_26);
    var_29 = wp::extract(var_1, var_28);
    var_31 = wp::extract(var_0, var_30);
    var_32 = wp::vec_t<3, wp::float32>(var_27, var_29, var_31);
    var_33 = wp::transform_point(var_transform, var_32);
    // min_bound = wp.min(min_bound, corner_3)                                                <L 36>
    var_34 = wp::min(var_24, var_33);
    // max_bound = wp.max(max_bound, corner_3)                                                <L 37>
    var_35 = wp::max(var_25, var_33);
    // corner_4 = wp.transform_point(transform, wp.vec3f(shape_min_bounds[0], shape_max_bounds[1], shape_min_bounds[2]))       <L 39>
    var_37 = wp::extract(var_0, var_36);
    var_39 = wp::extract(var_1, var_38);
    var_41 = wp::extract(var_0, var_40);
    var_42 = wp::vec_t<3, wp::float32>(var_37, var_39, var_41);
    var_43 = wp::transform_point(var_transform, var_42);
    // min_bound = wp.min(min_bound, corner_4)                                                <L 40>
    var_44 = wp::min(var_34, var_43);
    // max_bound = wp.max(max_bound, corner_4)                                                <L 41>
    var_45 = wp::max(var_35, var_43);
    // corner_5 = wp.transform_point(transform, wp.vec3f(shape_min_bounds[0], shape_min_bounds[1], shape_max_bounds[2]))       <L 43>
    var_47 = wp::extract(var_0, var_46);
    var_49 = wp::extract(var_0, var_48);
    var_51 = wp::extract(var_1, var_50);
    var_52 = wp::vec_t<3, wp::float32>(var_47, var_49, var_51);
    var_53 = wp::transform_point(var_transform, var_52);
    // min_bound = wp.min(min_bound, corner_5)                                                <L 44>
    var_54 = wp::min(var_44, var_53);
    // max_bound = wp.max(max_bound, corner_5)                                                <L 45>
    var_55 = wp::max(var_45, var_53);
    // corner_6 = wp.transform_point(transform, wp.vec3f(shape_max_bounds[0], shape_min_bounds[1], shape_max_bounds[2]))       <L 47>
    var_57 = wp::extract(var_1, var_56);
    var_59 = wp::extract(var_0, var_58);
    var_61 = wp::extract(var_1, var_60);
    var_62 = wp::vec_t<3, wp::float32>(var_57, var_59, var_61);
    var_63 = wp::transform_point(var_transform, var_62);
    // min_bound = wp.min(min_bound, corner_6)                                                <L 48>
    var_64 = wp::min(var_54, var_63);
    // max_bound = wp.max(max_bound, corner_6)                                                <L 49>
    var_65 = wp::max(var_55, var_63);
    // corner_7 = wp.transform_point(transform, wp.vec3f(shape_min_bounds[0], shape_max_bounds[1], shape_max_bounds[2]))       <L 51>
    var_67 = wp::extract(var_0, var_66);
    var_69 = wp::extract(var_1, var_68);
    var_71 = wp::extract(var_1, var_70);
    var_72 = wp::vec_t<3, wp::float32>(var_67, var_69, var_71);
    var_73 = wp::transform_point(var_transform, var_72);
    // min_bound = wp.min(min_bound, corner_7)                                                <L 52>
    var_74 = wp::min(var_64, var_73);
    // max_bound = wp.max(max_bound, corner_7)                                                <L 53>
    var_75 = wp::max(var_65, var_73);
    // corner_8 = wp.transform_point(transform, wp.vec3f(shape_max_bounds[0], shape_max_bounds[1], shape_max_bounds[2]))       <L 55>
    var_77 = wp::extract(var_1, var_76);
    var_79 = wp::extract(var_1, var_78);
    var_81 = wp::extract(var_1, var_80);
    var_82 = wp::vec_t<3, wp::float32>(var_77, var_79, var_81);
    var_83 = wp::transform_point(var_transform, var_82);
    // min_bound = wp.min(min_bound, corner_8)                                                <L 56>
    var_84 = wp::min(var_74, var_83);
    // max_bound = wp.max(max_bound, corner_8)                                                <L 57>
    var_85 = wp::max(var_75, var_83);
    // return min_bound, max_bound                                                            <L 59>
    ret_0 = var_84;
    ret_1 = var_85;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/bvh.py:187
static CUDA_CALLABLE void compute_gaussian_bounds_0(
    Gaussian__Data_f03ae6a1 var_gaussians_data,
    wp::int32 var_tid,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    wp::array_t<wp::transform_t<wp::float32>>* var_0;
    wp::transform_t<wp::float32>* var_1;
    wp::array_t<wp::transform_t<wp::float32>> var_2;
    wp::transform_t<wp::float32> var_3;
    wp::transform_t<wp::float32> var_4;
    wp::array_t<wp::vec_t<3, wp::float32>>* var_5;
    wp::vec_t<3, wp::float32>* var_6;
    wp::array_t<wp::vec_t<3, wp::float32>> var_7;
    wp::vec_t<3, wp::float32> var_8;
    wp::vec_t<3, wp::float32> var_9;
    wp::float32* var_10;
    wp::array_t<wp::float32>* var_11;
    wp::float32* var_12;
    wp::array_t<wp::float32> var_13;
    const wp::float32 var_14 = 1e-06;
    wp::float32 var_15;
    wp::float32 var_16;
    wp::float32 var_17;
    wp::float32 var_18;
    wp::float32 var_19;
    const wp::float32 var_20 = 1e-06;
    wp::float32 var_21;
    const wp::float32 var_22 = 0.97;
    wp::float32 var_23;
    wp::float32 var_24;
    wp::float32 var_25;
    const wp::float32 var_26 = -0.5;
    wp::float32 var_27;
    wp::float32 var_28;
    wp::float32 var_29;
    const wp::int32 var_30 = 0;
    wp::float32 var_31;
    wp::float32 var_32;
    const wp::int32 var_33 = 1;
    wp::float32 var_34;
    wp::float32 var_35;
    const wp::int32 var_36 = 2;
    wp::float32 var_37;
    wp::float32 var_38;
    wp::vec_t<3, wp::float32> var_39;
    wp::vec_t<3, wp::float32> var_40;
    wp::vec_t<3, wp::float32> var_41;
    //---------
    // forward
    // def compute_gaussian_bounds(gaussians_data: Gaussian.Data, tid: wp.int32) -> tuple[wp.vec3f, wp.vec3f]:       <L 188>
    // transform = gaussians_data.transforms[tid]                                             <L 189>
    var_0 = &((var_gaussians_data).transforms);
    var_2 = wp::load(var_0);
    var_1 = wp::address(var_2, var_tid);
    var_4 = wp::load(var_1);
    var_3 = wp::copy(var_4);
    // scale = gaussians_data.scales[tid]                                                     <L 190>
    var_5 = &((var_gaussians_data).scales);
    var_7 = wp::load(var_5);
    var_6 = wp::address(var_7, var_tid);
    var_9 = wp::load(var_6);
    var_8 = wp::copy(var_9);
    // mod = gaussians_data.min_response / wp.max(gaussians_data.opacities[tid], wp.float32(1e-6))       <L 192>
    var_10 = &((var_gaussians_data).min_response);
    var_11 = &((var_gaussians_data).opacities);
    var_13 = wp::load(var_11);
    var_12 = wp::address(var_13, var_tid);
    var_15 = wp::float32(var_14);
    var_17 = wp::load(var_12);
    var_16 = wp::max(var_17, var_15);
    var_19 = wp::load(var_10);
    var_18 = wp::div(var_19, var_16);
    // min_response = wp.clamp(mod, wp.float32(1e-6), wp.float32(0.97))                       <L 193>
    var_21 = wp::float32(var_20);
    var_23 = wp::float32(var_22);
    var_24 = wp::clamp(var_18, var_21, var_23);
    // ks = wp.sqrt(wp.log(min_response) / wp.float32(-0.5))                                  <L 194>
    var_25 = wp::log(var_24);
    var_27 = wp::float32(var_26);
    var_28 = wp::div(var_25, var_27);
    var_29 = wp::sqrt(var_28);
    // scale = wp.vec3f(scale[0] * ks, scale[1] * ks, scale[2] * ks)                          <L 195>
    var_31 = wp::extract(var_8, var_30);
    var_32 = wp::mul(var_31, var_29);
    var_34 = wp::extract(var_8, var_33);
    var_35 = wp::mul(var_34, var_29);
    var_37 = wp::extract(var_8, var_36);
    var_38 = wp::mul(var_37, var_29);
    var_39 = wp::vec_t<3, wp::float32>(var_32, var_35, var_38);
    // return compute_ellipsoid_bounds(transform, scale)                                      <L 197>
    compute_ellipsoid_bounds_0(var_3, var_39, var_40, var_41);
    ret_0 = var_40;
    ret_1 = var_41;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/bvh.py:140
static CUDA_CALLABLE bool is_supported_shape_type_0(
    wp::int32 var_shape_type)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 7;
    bool var_1;
    const bool var_2 = true;
    const wp::int32 var_3 = 4;
    bool var_4;
    const bool var_5 = true;
    const wp::int32 var_6 = 6;
    bool var_7;
    const bool var_8 = true;
    const wp::int32 var_9 = 5;
    bool var_10;
    const bool var_11 = true;
    const wp::int32 var_12 = 1;
    bool var_13;
    const bool var_14 = true;
    const wp::int32 var_15 = 3;
    bool var_16;
    const bool var_17 = true;
    const wp::int32 var_18 = 9;
    bool var_19;
    const bool var_20 = true;
    const wp::int32 var_21 = 8;
    bool var_22;
    const bool var_23 = true;
    const wp::int32 var_24 = 10;
    bool var_25;
    const bool var_26 = true;
    const wp::int32 var_27 = 2;
    bool var_28;
    const bool var_29 = true;
    const wp::int32 var_30 = 11;
    bool var_31;
    const bool var_32 = true;
    const bool var_33 = false;
    //---------
    // forward
    // def is_supported_shape_type(shape_type: wp.int32) -> wp.bool:                          <L 141>
    // if shape_type == GeoType.BOX:                                                          <L 142>
    var_1 = (var_shape_type == var_0);
    if (var_1) {
        // return True                                                                        <L 143>
        return var_2;
    }
    // if shape_type == GeoType.CAPSULE:                                                      <L 144>
    var_4 = (var_shape_type == var_3);
    if (var_4) {
        // return True                                                                        <L 145>
        return var_5;
    }
    // if shape_type == GeoType.CYLINDER:                                                     <L 146>
    var_7 = (var_shape_type == var_6);
    if (var_7) {
        // return True                                                                        <L 147>
        return var_8;
    }
    // if shape_type == GeoType.ELLIPSOID:                                                    <L 148>
    var_10 = (var_shape_type == var_9);
    if (var_10) {
        // return True                                                                        <L 149>
        return var_11;
    }
    // if shape_type == GeoType.PLANE:                                                        <L 150>
    var_13 = (var_shape_type == var_12);
    if (var_13) {
        // return True                                                                        <L 151>
        return var_14;
    }
    // if shape_type == GeoType.SPHERE:                                                       <L 152>
    var_16 = (var_shape_type == var_15);
    if (var_16) {
        // return True                                                                        <L 153>
        return var_17;
    }
    // if shape_type == GeoType.CONE:                                                         <L 154>
    var_19 = (var_shape_type == var_18);
    if (var_19) {
        // return True                                                                        <L 155>
        return var_20;
    }
    // if shape_type == GeoType.MESH:                                                         <L 156>
    var_22 = (var_shape_type == var_21);
    if (var_22) {
        // return True                                                                        <L 157>
        return var_23;
    }
    // if shape_type == GeoType.CONVEX_MESH:                                                  <L 158>
    var_25 = (var_shape_type == var_24);
    if (var_25) {
        // return True                                                                        <L 159>
        return var_26;
    }
    // if shape_type == GeoType.HFIELD:                                                       <L 160>
    var_28 = (var_shape_type == var_27);
    if (var_28) {
        // return True                                                                        <L 161>
        return var_29;
    }
    // if shape_type == GeoType.GAUSSIAN:                                                     <L 162>
    var_31 = (var_shape_type == var_30);
    if (var_31) {
        // return True                                                                        <L 163>
        return var_32;
    }
    // return False                                                                           <L 164>
    return var_33;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/bvh.py:82
static CUDA_CALLABLE void adj_compute_sphere_bounds_0(
    wp::vec_t<3, wp::float32> var_pos,
    wp::float32 var_radius,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & adj_pos,
    wp::float32 & adj_radius,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/bvh.py:62
static CUDA_CALLABLE void adj_compute_box_bounds_0(
    wp::transform_t<wp::float32> var_transform,
    wp::vec_t<3, wp::float32> var_size,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::transform_t<wp::float32> & adj_transform,
    wp::vec_t<3, wp::float32> & adj_size,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/bvh.py:87
static CUDA_CALLABLE void adj_compute_capsule_bounds_0(
    wp::transform_t<wp::float32> var_transform,
    wp::vec_t<3, wp::float32> var_size,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::transform_t<wp::float32> & adj_transform,
    wp::vec_t<3, wp::float32> & adj_size,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/bvh.py:95
static CUDA_CALLABLE void adj_compute_cylinder_bounds_0(
    wp::transform_t<wp::float32> var_transform,
    wp::vec_t<3, wp::float32> var_size,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::transform_t<wp::float32> & adj_transform,
    wp::vec_t<3, wp::float32> & adj_size,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/bvh.py:103
static CUDA_CALLABLE void adj_compute_cone_bounds_0(
    wp::transform_t<wp::float32> var_transform,
    wp::vec_t<3, wp::float32> var_size,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::transform_t<wp::float32> & adj_transform,
    wp::vec_t<3, wp::float32> & adj_size,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/bvh.py:109
static CUDA_CALLABLE void adj_compute_plane_bounds_0(
    wp::transform_t<wp::float32> var_transform,
    wp::vec_t<3, wp::float32> var_size,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::transform_t<wp::float32> & adj_transform,
    wp::vec_t<3, wp::float32> & adj_size,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/bvh.py:134
static CUDA_CALLABLE void adj_compute_ellipsoid_bounds_0(
    wp::transform_t<wp::float32> var_transform,
    wp::vec_t<3, wp::float32> var_size,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::transform_t<wp::float32> & adj_transform,
    wp::vec_t<3, wp::float32> & adj_size,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/bvh.py:17
static CUDA_CALLABLE void adj_compute_shape_bounds_0(
    wp::transform_t<wp::float32> var_transform,
    wp::vec_t<3, wp::float32> var_scale,
    wp::vec_t<3, wp::float32> var_shape_min_bounds,
    wp::vec_t<3, wp::float32> var_shape_max_bounds,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::transform_t<wp::float32> & adj_transform,
    wp::vec_t<3, wp::float32> & adj_scale,
    wp::vec_t<3, wp::float32> & adj_shape_min_bounds,
    wp::vec_t<3, wp::float32> & adj_shape_max_bounds,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/bvh.py:187
static CUDA_CALLABLE void adj_compute_gaussian_bounds_0(
    Gaussian__Data_f03ae6a1 var_gaussians_data,
    wp::int32 var_tid,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    Gaussian__Data_f03ae6a1 & adj_gaussians_data,
    wp::int32 & adj_tid,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/bvh.py:140
static CUDA_CALLABLE void adj_is_supported_shape_type_0(
    wp::int32 var_shape_type,
    wp::int32 & adj_shape_type,
    bool & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}



extern "C" __global__ void compute_particle_bvh_bounds_af1b7974_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::int32 var_num_particles,
    wp::int32 var_world_count,
    wp::array_t<wp::int32> var_particle_world_index,
    wp::array_t<wp::vec_t<3, wp::float32>> var_particle_position,
    wp::array_t<wp::float32> var_particle_radius,
    wp::array_t<wp::vec_t<3, wp::float32>> var_out_bvh_lowers,
    wp::array_t<wp::vec_t<3, wp::float32>> var_out_bvh_uppers,
    wp::array_t<wp::int32> var_out_bvh_groups)
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
        bool var_2;
        wp::int32 var_3;
        wp::int32* var_4;
        wp::int32 var_5;
        wp::int32 var_6;
        const wp::int32 var_7 = 0;
        bool var_8;
        wp::int32 var_9;
        wp::int32 var_10;
        bool var_11;
        wp::vec_t<3, wp::float32>* var_12;
        wp::float32* var_13;
        wp::vec_t<3, wp::float32> var_14;
        wp::vec_t<3, wp::float32> var_15;
        wp::vec_t<3, wp::float32> var_16;
        wp::float32 var_17;
        //---------
        // forward
        // def compute_particle_bvh_bounds(                                                       <L 316>
        // tid = wp.tid()                                                                         <L 326>
        var_0 = builtin_tid1d();
        // bvh_index_local = tid % num_particles                                                  <L 327>
        var_1 = wp::mod(var_0, var_num_particles);
        // if bvh_index_local >= num_particles:                                                   <L 328>
        var_2 = (var_1 >= var_num_particles);
        if (var_2) {
            // return                                                                             <L 329>
            continue;
        }
        // particle_index = bvh_index_local                                                       <L 331>
        var_3 = wp::copy(var_1);
        // world_index = particle_world_index[particle_index]                                     <L 333>
        var_4 = wp::address(var_particle_world_index, var_3);
        var_6 = wp::load(var_4);
        var_5 = wp::copy(var_6);
        // if world_index < 0:                                                                    <L 334>
        var_8 = (var_5 < var_7);
        if (var_8) {
            // world_index = world_count + world_index                                            <L 335>
            var_9 = wp::add(var_world_count, var_5);
        }
        var_10 = wp::where(var_8, var_9, var_5);
        // if world_index >= world_count:                                                         <L 337>
        var_11 = (var_10 >= var_world_count);
        if (var_11) {
            // return                                                                             <L 338>
            continue;
        }
        // lower, upper = compute_sphere_bounds(particle_position[particle_index], particle_radius[particle_index])       <L 340>
        var_12 = wp::address(var_particle_position, var_3);
        var_13 = wp::address(var_particle_radius, var_3);
        var_16 = wp::load(var_12);
        var_17 = wp::load(var_13);
        compute_sphere_bounds_0(var_16, var_17, var_14, var_15);
        // out_bvh_lowers[bvh_index_local] = lower                                                <L 342>
        wp::array_store(var_out_bvh_lowers, var_1, var_14);
        // out_bvh_uppers[bvh_index_local] = upper                                                <L 343>
        wp::array_store(var_out_bvh_uppers, var_1, var_15);
        // out_bvh_groups[bvh_index_local] = world_index                                          <L 344>
        wp::array_store(var_out_bvh_groups, var_1, var_10);
    }
}



extern "C" __global__ void compute_bvh_group_roots_a4d4455c_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::uint64 var_bvh_id,
    wp::array_t<wp::int32> var_out_bvh_group_roots)
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
        //---------
        // forward
        // def compute_bvh_group_roots(bvh_id: wp.uint64, out_bvh_group_roots: wp.array[wp.int32]):       <L 348>
        // tid = wp.tid()                                                                         <L 349>
        var_0 = builtin_tid1d();
        // out_bvh_group_roots[tid] = wp.bvh_get_group_root(bvh_id, tid)                          <L 350>
        var_1 = wp::bvh_get_group_root(var_bvh_id, var_0);
        wp::array_store(var_out_bvh_group_roots, var_0, var_1);
    }
}



extern "C" __global__ void compute_shape_world_transforms_47e17149_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::transform_t<wp::float32>> var_in_body_transforms,
    wp::array_t<wp::int32> var_in_shape_body,
    wp::array_t<wp::transform_t<wp::float32>> var_in_shape_transform,
    wp::array_t<wp::transform_t<wp::float32>> var_out_transforms)
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
        wp::int32 var_2;
        wp::int32 var_3;
        wp::transform_t<wp::float32> var_4;
        const wp::int32 var_5 = 0;
        bool var_6;
        wp::transform_t<wp::float32>* var_7;
        wp::transform_t<wp::float32> var_8;
        wp::transform_t<wp::float32> var_9;
        wp::transform_t<wp::float32> var_10;
        wp::transform_t<wp::float32>* var_11;
        wp::transform_t<wp::float32> var_12;
        wp::transform_t<wp::float32> var_13;
        //---------
        // forward
        // def compute_shape_world_transforms(                                                    <L 235>
        // tid = wp.tid()                                                                         <L 241>
        var_0 = builtin_tid1d();
        // body = in_shape_body[tid]                                                              <L 243>
        var_1 = wp::address(var_in_shape_body, var_0);
        var_3 = wp::load(var_1);
        var_2 = wp::copy(var_3);
        // body_transform = wp.transform_identity()                                               <L 244>
        var_4 = wp::transform_identity<wp::float32>();
        // if body >= 0:                                                                          <L 245>
        var_6 = (var_2 >= var_5);
        if (var_6) {
            // body_transform = in_body_transforms[body]                                          <L 246>
            var_7 = wp::address(var_in_body_transforms, var_2);
            var_9 = wp::load(var_7);
            var_8 = wp::copy(var_9);
        }
        var_10 = wp::where(var_6, var_8, var_4);
        // out_transforms[tid] = wp.mul(body_transform, in_shape_transform[tid])                  <L 248>
        var_11 = wp::address(var_in_shape_transform, var_0);
        var_13 = wp::load(var_11);
        var_12 = wp::mul(var_10, var_13);
        wp::array_store(var_out_transforms, var_0, var_12);
    }
}



extern "C" __global__ void compute_shape_bvh_bounds_14f038b0_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::int32 var_shape_count_enabled,
    wp::int32 var_world_count,
    wp::array_t<wp::int32> var_shape_world_index,
    wp::array_t<wp::uint32> var_shape_enabled,
    wp::array_t<wp::int32> var_shape_types,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_sizes,
    wp::array_t<wp::transform_t<wp::float32>> var_shape_transforms,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_bounds,
    wp::array_t<wp::vec_t<3, wp::float32>> var_out_bvh_lowers,
    wp::array_t<wp::vec_t<3, wp::float32>> var_out_bvh_uppers,
    wp::array_t<wp::int32> var_out_bvh_groups)
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
        bool var_2;
        wp::uint32* var_3;
        wp::uint32 var_4;
        wp::uint32 var_5;
        wp::int32* var_6;
        wp::int32 var_7;
        wp::int32 var_8;
        const wp::int32 var_9 = 0;
        bool var_10;
        wp::int32 var_11;
        wp::int32 var_12;
        bool var_13;
        wp::transform_t<wp::float32>* var_14;
        wp::transform_t<wp::float32> var_15;
        wp::transform_t<wp::float32> var_16;
        wp::vec_t<3, wp::float32>* var_17;
        wp::vec_t<3, wp::float32> var_18;
        wp::vec_t<3, wp::float32> var_19;
        wp::int32* var_20;
        wp::int32 var_21;
        wp::int32 var_22;
        wp::vec_t<3, wp::float32> var_23;
        wp::vec_t<3, wp::float32> var_24;
        const wp::int32 var_25 = 3;
        bool var_26;
        wp::vec_t<3, wp::float32> var_27;
        const wp::int32 var_28 = 0;
        wp::float32 var_29;
        wp::vec_t<3, wp::float32> var_30;
        wp::vec_t<3, wp::float32> var_31;
        const wp::int32 var_32 = 4;
        bool var_33;
        wp::vec_t<3, wp::float32> var_34;
        wp::vec_t<3, wp::float32> var_35;
        const wp::int32 var_36 = 6;
        bool var_37;
        wp::vec_t<3, wp::float32> var_38;
        wp::vec_t<3, wp::float32> var_39;
        const wp::int32 var_40 = 9;
        bool var_41;
        wp::vec_t<3, wp::float32> var_42;
        wp::vec_t<3, wp::float32> var_43;
        const wp::int32 var_44 = 1;
        bool var_45;
        wp::vec_t<3, wp::float32> var_46;
        wp::vec_t<3, wp::float32> var_47;
        const wp::int32 var_48 = 5;
        bool var_49;
        wp::vec_t<3, wp::float32> var_50;
        wp::vec_t<3, wp::float32> var_51;
        const wp::int32 var_52 = 7;
        bool var_53;
        wp::vec_t<3, wp::float32> var_54;
        wp::vec_t<3, wp::float32> var_55;
        bool var_56;
        const wp::int32 var_57 = 8;
        bool var_58;
        const wp::int32 var_59 = 10;
        bool var_60;
        const wp::int32 var_61 = 2;
        bool var_62;
        const wp::int32 var_63 = 11;
        bool var_64;
        const wp::int32 var_65 = 0;
        wp::vec_t<3, wp::float32>* var_66;
        wp::vec_t<3, wp::float32> var_67;
        wp::vec_t<3, wp::float32> var_68;
        const wp::int32 var_69 = 1;
        wp::vec_t<3, wp::float32>* var_70;
        wp::vec_t<3, wp::float32> var_71;
        wp::vec_t<3, wp::float32> var_72;
        wp::vec_t<3, wp::float32> var_73;
        wp::vec_t<3, wp::float32> var_74;
        wp::vec_t<3, wp::float32> var_75;
        wp::vec_t<3, wp::float32> var_76;
        wp::vec_t<3, wp::float32> var_77;
        wp::vec_t<3, wp::float32> var_78;
        wp::vec_t<3, wp::float32> var_79;
        wp::vec_t<3, wp::float32> var_80;
        wp::vec_t<3, wp::float32> var_81;
        wp::vec_t<3, wp::float32> var_82;
        wp::vec_t<3, wp::float32> var_83;
        wp::vec_t<3, wp::float32> var_84;
        wp::vec_t<3, wp::float32> var_85;
        wp::vec_t<3, wp::float32> var_86;
        wp::vec_t<3, wp::float32> var_87;
        wp::vec_t<3, wp::float32> var_88;
        wp::vec_t<3, wp::float32> var_89;
        wp::vec_t<3, wp::float32> var_90;
        //---------
        // forward
        // def compute_shape_bvh_bounds(                                                          <L 252>
        // tid = wp.tid()                                                                         <L 265>
        var_0 = builtin_tid1d();
        // bvh_index_local = tid % shape_count_enabled                                            <L 266>
        var_1 = wp::mod(var_0, var_shape_count_enabled);
        // if bvh_index_local >= shape_count_enabled:                                             <L 267>
        var_2 = (var_1 >= var_shape_count_enabled);
        if (var_2) {
            // return                                                                             <L 268>
            continue;
        }
        // shape_index = shape_enabled[bvh_index_local]                                           <L 270>
        var_3 = wp::address(var_shape_enabled, var_1);
        var_5 = wp::load(var_3);
        var_4 = wp::copy(var_5);
        // world_index = shape_world_index[shape_index]                                           <L 272>
        var_6 = wp::address(var_shape_world_index, var_4);
        var_8 = wp::load(var_6);
        var_7 = wp::copy(var_8);
        // if world_index < 0:                                                                    <L 273>
        var_10 = (var_7 < var_9);
        if (var_10) {
            // world_index = world_count + world_index                                            <L 274>
            var_11 = wp::add(var_world_count, var_7);
        }
        var_12 = wp::where(var_10, var_11, var_7);
        // if world_index >= world_count:                                                         <L 276>
        var_13 = (var_12 >= var_world_count);
        if (var_13) {
            // return                                                                             <L 277>
            continue;
        }
        // transform = shape_transforms[shape_index]                                              <L 279>
        var_14 = wp::address(var_shape_transforms, var_4);
        var_16 = wp::load(var_14);
        var_15 = wp::copy(var_16);
        // size = shape_sizes[shape_index]                                                        <L 280>
        var_17 = wp::address(var_shape_sizes, var_4);
        var_19 = wp::load(var_17);
        var_18 = wp::copy(var_19);
        // geom_type = shape_types[shape_index]                                                   <L 281>
        var_20 = wp::address(var_shape_types, var_4);
        var_22 = wp::load(var_20);
        var_21 = wp::copy(var_22);
        // lower = wp.vec3f()                                                                     <L 283>
        var_23 = wp::vec_t<3, wp::float32>();
        // upper = wp.vec3f()                                                                     <L 284>
        var_24 = wp::vec_t<3, wp::float32>();
        // if geom_type == GeoType.SPHERE:                                                        <L 286>
        var_26 = (var_21 == var_25);
        if (var_26) {
            // lower, upper = compute_sphere_bounds(wp.transform_get_translation(transform), size[0])       <L 287>
            var_27 = wp::transform_get_translation(var_15);
            var_29 = wp::extract(var_18, var_28);
            compute_sphere_bounds_0(var_27, var_29, var_30, var_31);
        }
        if (!var_26) {
            // elif geom_type == GeoType.CAPSULE:                                                 <L 288>
            var_33 = (var_21 == var_32);
            if (var_33) {
                // lower, upper = compute_capsule_bounds(transform, size)                         <L 289>
                compute_capsule_bounds_0(var_15, var_18, var_34, var_35);
            }
            if (!var_33) {
                // elif geom_type == GeoType.CYLINDER:                                            <L 290>
                var_37 = (var_21 == var_36);
                if (var_37) {
                    // lower, upper = compute_cylinder_bounds(transform, size)                    <L 291>
                    compute_cylinder_bounds_0(var_15, var_18, var_38, var_39);
                }
                if (!var_37) {
                    // elif geom_type == GeoType.CONE:                                            <L 292>
                    var_41 = (var_21 == var_40);
                    if (var_41) {
                        // lower, upper = compute_cone_bounds(transform, size)                    <L 293>
                        compute_cone_bounds_0(var_15, var_18, var_42, var_43);
                    }
                    if (!var_41) {
                        // elif geom_type == GeoType.PLANE:                                       <L 294>
                        var_45 = (var_21 == var_44);
                        if (var_45) {
                            // lower, upper = compute_plane_bounds(transform, size)               <L 295>
                            compute_plane_bounds_0(var_15, var_18, var_46, var_47);
                        }
                        if (!var_45) {
                            // elif geom_type == GeoType.ELLIPSOID:                               <L 296>
                            var_49 = (var_21 == var_48);
                            if (var_49) {
                                // lower, upper = compute_ellipsoid_bounds(transform, size)       <L 297>
                                compute_ellipsoid_bounds_0(var_15, var_18, var_50, var_51);
                            }
                            if (!var_49) {
                                // elif geom_type == GeoType.BOX:                                 <L 298>
                                var_53 = (var_21 == var_52);
                                if (var_53) {
                                    // lower, upper = compute_box_bounds(transform, size)         <L 299>
                                    compute_box_bounds_0(var_15, var_18, var_54, var_55);
                                }
                                if (!var_53) {
                                    // elif (                                                     <L 300>
                                    // geom_type == GeoType.MESH                                  <L 301>
                                    var_58 = (var_21 == var_57);
                                    var_56 = var_58;
                                    if (!var_56) {
                                        // or geom_type == GeoType.CONVEX_MESH                    <L 302>
                                        var_60 = (var_21 == var_59);
                                        var_56 = var_56 || var_60;
                                    }
                                    if (!var_56) {
                                        // or geom_type == GeoType.HFIELD                         <L 303>
                                        var_62 = (var_21 == var_61);
                                        var_56 = var_56 || var_62;
                                    }
                                    if (!var_56) {
                                        // or geom_type == GeoType.GAUSSIAN                       <L 304>
                                        var_64 = (var_21 == var_63);
                                        var_56 = var_56 || var_64;
                                    }
                                    if (var_56) {
                                        // min_bounds = shape_bounds[shape_index, 0]              <L 306>
                                        var_66 = wp::address(var_shape_bounds, var_4, var_65);
                                        var_68 = wp::load(var_66);
                                        var_67 = wp::copy(var_68);
                                        // max_bounds = shape_bounds[shape_index, 1]              <L 307>
                                        var_70 = wp::address(var_shape_bounds, var_4, var_69);
                                        var_72 = wp::load(var_70);
                                        var_71 = wp::copy(var_72);
                                        // lower, upper = compute_shape_bounds(transform, size, min_bounds, max_bounds)       <L 308>
                                        compute_shape_bounds_0(var_15, var_18, var_67, var_71, var_73, var_74);
                                    }
                                    var_75 = wp::where(var_56, var_73, var_23);
                                    var_76 = wp::where(var_56, var_74, var_24);
                                }
                                var_77 = wp::where(var_53, var_54, var_75);
                                var_78 = wp::where(var_53, var_55, var_76);
                            }
                            var_79 = wp::where(var_49, var_50, var_77);
                            var_80 = wp::where(var_49, var_51, var_78);
                        }
                        var_81 = wp::where(var_45, var_46, var_79);
                        var_82 = wp::where(var_45, var_47, var_80);
                    }
                    var_83 = wp::where(var_41, var_42, var_81);
                    var_84 = wp::where(var_41, var_43, var_82);
                }
                var_85 = wp::where(var_37, var_38, var_83);
                var_86 = wp::where(var_37, var_39, var_84);
            }
            var_87 = wp::where(var_33, var_34, var_85);
            var_88 = wp::where(var_33, var_35, var_86);
        }
        var_89 = wp::where(var_26, var_30, var_87);
        var_90 = wp::where(var_26, var_31, var_88);
        // out_bvh_lowers[bvh_index_local] = lower                                                <L 310>
        wp::array_store(var_out_bvh_lowers, var_1, var_89);
        // out_bvh_uppers[bvh_index_local] = upper                                                <L 311>
        wp::array_store(var_out_bvh_uppers, var_1, var_90);
        // out_bvh_groups[bvh_index_local] = world_index                                          <L 312>
        wp::array_store(var_out_bvh_groups, var_1, var_12);
    }
}



extern "C" __global__ void compute_shape_local_bounds_5bec0069_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::int32> var_in_shape_type,
    wp::array_t<wp::uint64> var_in_shape_ptr,
    wp::array_t<Gaussian__Data_f03ae6a1> var_in_gaussians,
    wp::array_t<wp::vec_t<3, wp::float32>> var_out_bounds)
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
        const wp::float32 var_1 = 10000000000.0;
        wp::vec_t<3, wp::float32> var_2;
        const wp::float32 var_3 = -10000000000.0;
        wp::vec_t<3, wp::float32> var_4;
        bool var_5;
        wp::int32* var_6;
        const wp::int32 var_7 = 8;
        bool var_8;
        wp::int32 var_9;
        wp::int32* var_10;
        const wp::int32 var_11 = 10;
        bool var_12;
        wp::int32 var_13;
        wp::int32* var_14;
        const wp::int32 var_15 = 2;
        bool var_16;
        wp::int32 var_17;
        wp::uint64* var_18;
        wp::Mesh var_19;
        wp::uint64 var_20;
        wp::array_t<wp::vec_t<3, wp::float32>>* var_21;
        wp::shape_t* var_22;
        const wp::int32 var_23 = 0;
        wp::int32 var_24;
        wp::shape_t var_25;
        wp::range_t var_26;
        wp::int32 var_27;
        wp::array_t<wp::vec_t<3, wp::float32>>* var_28;
        wp::vec_t<3, wp::float32>* var_29;
        wp::array_t<wp::vec_t<3, wp::float32>> var_30;
        wp::vec_t<3, wp::float32> var_31;
        wp::vec_t<3, wp::float32> var_32;
        wp::array_t<wp::vec_t<3, wp::float32>>* var_33;
        wp::vec_t<3, wp::float32>* var_34;
        wp::array_t<wp::vec_t<3, wp::float32>> var_35;
        wp::vec_t<3, wp::float32> var_36;
        wp::vec_t<3, wp::float32> var_37;
        wp::int32* var_38;
        const wp::int32 var_39 = 11;
        bool var_40;
        wp::int32 var_41;
        wp::uint64* var_42;
        wp::uint64 var_43;
        wp::uint64 var_44;
        Gaussian__Data_f03ae6a1* var_45;
        wp::int32* var_46;
        wp::range_t var_47;
        wp::int32 var_48;
        wp::int32 var_49;
        Gaussian__Data_f03ae6a1* var_50;
        wp::vec_t<3, wp::float32> var_51;
        wp::vec_t<3, wp::float32> var_52;
        Gaussian__Data_f03ae6a1 var_53;
        wp::vec_t<3, wp::float32> var_54;
        wp::vec_t<3, wp::float32> var_55;
        wp::int32 var_56;
        const wp::int32 var_57 = 0;
        const wp::int32 var_58 = 1;
        //---------
        // forward
        // def compute_shape_local_bounds(                                                        <L 201>
        // tid = wp.tid()                                                                         <L 207>
        var_0 = builtin_tid1d();
        // min_point = wp.vec3(MAXVAL)                                                            <L 209>
        var_2 = wp::vec_t<3, wp::float32>(var_1);
        // max_point = wp.vec3(-MAXVAL)                                                           <L 210>
        var_4 = wp::vec_t<3, wp::float32>(var_3);
        // if (                                                                                   <L 212>
        // in_shape_type[tid] == GeoType.MESH                                                     <L 213>
        var_6 = wp::address(var_in_shape_type, var_0);
        var_9 = wp::load(var_6);
        var_8 = (var_9 == var_7);
        var_5 = var_8;
        if (!var_5) {
            // or in_shape_type[tid] == GeoType.CONVEX_MESH                                       <L 214>
            var_10 = wp::address(var_in_shape_type, var_0);
            var_13 = wp::load(var_10);
            var_12 = (var_13 == var_11);
            var_5 = var_5 || var_12;
        }
        if (!var_5) {
            // or in_shape_type[tid] == GeoType.HFIELD                                            <L 215>
            var_14 = wp::address(var_in_shape_type, var_0);
            var_17 = wp::load(var_14);
            var_16 = (var_17 == var_15);
            var_5 = var_5 || var_16;
        }
        if (var_5) {
            // mesh = wp.mesh_get(in_shape_ptr[tid])                                              <L 218>
            var_18 = wp::address(var_in_shape_ptr, var_0);
            var_20 = wp::load(var_18);
            var_19 = wp::mesh_get(var_20);
            // for i in range(mesh.points.shape[0]):                                              <L 219>
            var_21 = &((var_19).points);
            var_22 = &(var_21->shape);
            var_25 = wp::load(var_22);
            var_24 = wp::extract(var_25, var_23);
            var_26 = wp::range(var_24);
            start_for_0:;
                if (iter_cmp(var_26) == 0) goto end_for_0;
                var_27 = wp::iter_next(var_26);
                // min_point = wp.min(min_point, mesh.points[i])                                  <L 220>
                var_28 = &((var_19).points);
                var_30 = wp::load(var_28);
                var_29 = wp::address(var_30, var_27);
                var_32 = wp::load(var_29);
                var_31 = wp::min(var_2, var_32);
                // max_point = wp.max(max_point, mesh.points[i])                                  <L 221>
                var_33 = &((var_19).points);
                var_35 = wp::load(var_33);
                var_34 = wp::address(var_35, var_27);
                var_37 = wp::load(var_34);
                var_36 = wp::max(var_4, var_37);
                wp::assign(var_2, var_31);
                wp::assign(var_4, var_36);
                goto start_for_0;
            end_for_0:;
        }
        if (!var_5) {
            // elif in_shape_type[tid] == GeoType.GAUSSIAN:                                       <L 223>
            var_38 = wp::address(var_in_shape_type, var_0);
            var_41 = wp::load(var_38);
            var_40 = (var_41 == var_39);
            if (var_40) {
                // gaussian_id = in_shape_ptr[tid]                                                <L 224>
                var_42 = wp::address(var_in_shape_ptr, var_0);
                var_44 = wp::load(var_42);
                var_43 = wp::copy(var_44);
                // for i in range(in_gaussians[gaussian_id].num_points):                          <L 225>
                var_45 = wp::address(var_in_gaussians, var_43);
                var_46 = &(((*wp::address(var_in_gaussians, var_43))).num_points);
                var_48 = wp::load(var_46);
                var_47 = wp::range(var_48);
                start_for_2:;
                    if (iter_cmp(var_47) == 0) goto end_for_2;
                    var_49 = wp::iter_next(var_47);
                    // lower, upper = compute_gaussian_bounds(in_gaussians[gaussian_id], i)       <L 226>
                    var_50 = wp::address(var_in_gaussians, var_43);
                    var_53 = wp::load(var_50);
                    compute_gaussian_bounds_0(var_53, var_49, var_51, var_52);
                    // min_point = wp.min(min_point, lower)                                       <L 227>
                    var_54 = wp::min(var_2, var_51);
                    // max_point = wp.max(max_point, upper)                                       <L 228>
                    var_55 = wp::max(var_4, var_52);
                    wp::assign(var_2, var_54);
                    wp::assign(var_4, var_55);
                    goto start_for_2;
                end_for_2:;
            }
        }
        var_56 = wp::where(var_5, var_27, var_49);
        // out_bounds[tid, 0] = min_point                                                         <L 230>
        wp::array_store(var_out_bounds, var_0, var_57, var_2);
        // out_bounds[tid, 1] = max_point                                                         <L 231>
        wp::array_store(var_out_bounds, var_0, var_58, var_4);
    }
}



extern "C" __global__ void compute_enabled_shapes_70ba08e9_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::int32> var_shape_type,
    wp::array_t<wp::int32> var_shape_flags,
    wp::int32 var_shape_flags_mask,
    wp::array_t<wp::uint32> var_out_shape_enabled,
    wp::array_t<wp::int32> var_out_shape_enabled_count)
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
        wp::int32 var_2;
        wp::int32 var_3;
        bool var_4;
        bool var_5;
        wp::int32* var_6;
        bool var_7;
        wp::int32 var_8;
        bool var_9;
        const wp::int32 var_10 = 0;
        const wp::int32 var_11 = 1;
        wp::int32 var_12;
        wp::uint32 var_13;
        //---------
        // forward
        // def compute_enabled_shapes(                                                            <L 168>
        // tid = wp.tid()                                                                         <L 175>
        var_0 = builtin_tid1d();
        // if not bool(shape_flags[tid] & shape_flags_mask):                                      <L 177>
        var_1 = wp::address(var_shape_flags, var_0);
        var_3 = wp::load(var_1);
        var_2 = wp::bit_and(var_3, var_shape_flags_mask);
        var_4 = bool(var_2);
        var_5 = wp::unot(var_4);
        if (var_5) {
            // return                                                                             <L 178>
            continue;
        }
        // if not is_supported_shape_type(shape_type[tid]):                                       <L 180>
        var_6 = wp::address(var_shape_type, var_0);
        var_8 = wp::load(var_6);
        var_7 = is_supported_shape_type_0(var_8);
        var_9 = wp::unot(var_7);
        if (var_9) {
            // return                                                                             <L 181>
            continue;
        }
        // index = wp.atomic_add(out_shape_enabled_count, 0, 1)                                   <L 183>
        var_12 = wp::atomic_add(var_out_shape_enabled_count, var_10, var_11);
        // out_shape_enabled[index] = wp.uint32(tid)                                              <L 184>
        var_13 = wp::uint32(var_0);
        wp::array_store(var_out_shape_enabled, var_12, var_13);
    }
}

