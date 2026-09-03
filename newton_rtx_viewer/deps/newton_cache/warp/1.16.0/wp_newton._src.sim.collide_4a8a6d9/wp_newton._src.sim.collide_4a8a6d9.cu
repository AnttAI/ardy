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



extern "C" __global__ void compute_shape_aabbs_3132aed6_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::transform_t<wp::float32>> var_body_q,
    wp::array_t<wp::transform_t<wp::float32>> var_shape_transform,
    wp::array_t<wp::int32> var_shape_body,
    wp::array_t<wp::int32> var_shape_type,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_scale,
    wp::array_t<wp::float32> var_shape_collision_radius,
    wp::array_t<wp::uint64> var_shape_source_ptr,
    wp::array_t<wp::float32> var_shape_margin,
    wp::array_t<wp::float32> var_shape_gap,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_collision_aabb_lower,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_collision_aabb_upper,
    wp::array_t<wp::int32> var_contact_counters,
    wp::array_t<wp::int32> var_contact_generation,
    wp::array_t<wp::int32> var_broad_phase_pair_count,
    wp::int32 var_num_contact_counters,
    wp::array_t<wp::vec_t<3, wp::float32>> var_aabb_lower,
    wp::array_t<wp::vec_t<3, wp::float32>> var_aabb_upper,
    wp::array_t<wp::vec_t<4, wp::float32>> var_geom_data,
    wp::array_t<wp::transform_t<wp::float32>> var_geom_xform)
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
        bool var_2;
        wp::range_t var_3;
        wp::int32 var_4;
        const wp::int32 var_5 = 0;
        const wp::int32 var_6 = 0;
        wp::int32* var_7;
        wp::int32 var_8;
        wp::int32 var_9;
        const wp::int32 var_10 = 2147483647;
        bool var_11;
        const wp::int32 var_12 = 0;
        const wp::int32 var_13 = 1;
        wp::int32 var_14;
        wp::int32 var_15;
        const wp::int32 var_16 = 0;
        const wp::int32 var_17 = 0;
        const wp::int32 var_18 = 0;
        wp::int32* var_19;
        wp::int32 var_20;
        wp::int32 var_21;
        wp::int32* var_22;
        wp::int32 var_23;
        wp::int32 var_24;
        const wp::int32 var_25 = -1;
        bool var_26;
        wp::transform_t<wp::float32>* var_27;
        wp::transform_t<wp::float32> var_28;
        wp::transform_t<wp::float32> var_29;
        wp::transform_t<wp::float32>* var_30;
        wp::transform_t<wp::float32>* var_31;
        wp::transform_t<wp::float32> var_32;
        wp::transform_t<wp::float32> var_33;
        wp::transform_t<wp::float32> var_34;
        wp::transform_t<wp::float32> var_35;
        wp::vec_t<3, wp::float32> var_36;
        wp::quat_t<wp::float32> var_37;
        wp::float32* var_38;
        wp::float32 var_39;
        wp::float32 var_40;
        wp::float32* var_41;
        wp::float32 var_42;
        wp::float32 var_43;
        wp::vec_t<3, wp::float32> var_44;
        wp::vec_t<3, wp::float32>* var_45;
        wp::vec_t<3, wp::float32> var_46;
        wp::vec_t<3, wp::float32> var_47;
        bool var_48;
        const wp::int32 var_49 = 1;
        bool var_50;
        bool var_51;
        const wp::int32 var_52 = 0;
        wp::float32 var_53;
        const wp::float32 var_54 = 0.0;
        bool var_55;
        const wp::int32 var_56 = 1;
        wp::float32 var_57;
        const wp::float32 var_58 = 0.0;
        bool var_59;
        bool var_60;
        const wp::int32 var_61 = 8;
        bool var_62;
        const wp::int32 var_63 = 2;
        bool var_64;
        const wp::int32 var_65 = 10;
        bool var_66;
        wp::vec_t<3, wp::float32> var_67;
        wp::float32* var_68;
        wp::float32 var_69;
        wp::float32 var_70;
        wp::vec_t<3, wp::float32> var_71;
        wp::vec_t<3, wp::float32> var_72;
        wp::vec_t<3, wp::float32> var_73;
        wp::vec_t<3, wp::float32> var_74;
        wp::vec_t<3, wp::float32> var_75;
        wp::vec_t<3, wp::float32>* var_76;
        wp::vec_t<3, wp::float32> var_77;
        wp::vec_t<3, wp::float32> var_78;
        wp::vec_t<3, wp::float32>* var_79;
        wp::vec_t<3, wp::float32> var_80;
        wp::vec_t<3, wp::float32> var_81;
        wp::vec_t<3, wp::float32> var_82;
        const wp::float32 var_83 = 0.5;
        wp::vec_t<3, wp::float32> var_84;
        wp::vec_t<3, wp::float32> var_85;
        const wp::float32 var_86 = 0.5;
        wp::vec_t<3, wp::float32> var_87;
        wp::vec_t<3, wp::float32> var_88;
        wp::vec_t<3, wp::float32> var_89;
        const wp::float32 var_90 = 1.0;
        const wp::float32 var_91 = 0.0;
        const wp::float32 var_92 = 0.0;
        wp::vec_t<3, wp::float32> var_93;
        wp::vec_t<3, wp::float32> var_94;
        const wp::float32 var_95 = 0.0;
        const wp::float32 var_96 = 1.0;
        const wp::float32 var_97 = 0.0;
        wp::vec_t<3, wp::float32> var_98;
        wp::vec_t<3, wp::float32> var_99;
        const wp::float32 var_100 = 0.0;
        const wp::float32 var_101 = 0.0;
        const wp::float32 var_102 = 1.0;
        wp::vec_t<3, wp::float32> var_103;
        wp::vec_t<3, wp::float32> var_104;
        const wp::int32 var_105 = 0;
        wp::float32 var_106;
        wp::float32 var_107;
        const wp::int32 var_108 = 0;
        wp::float32 var_109;
        wp::float32 var_110;
        const wp::int32 var_111 = 0;
        wp::float32 var_112;
        wp::float32 var_113;
        const wp::int32 var_114 = 1;
        wp::float32 var_115;
        wp::float32 var_116;
        wp::float32 var_117;
        const wp::int32 var_118 = 0;
        wp::float32 var_119;
        wp::float32 var_120;
        const wp::int32 var_121 = 2;
        wp::float32 var_122;
        wp::float32 var_123;
        wp::float32 var_124;
        const wp::int32 var_125 = 1;
        wp::float32 var_126;
        wp::float32 var_127;
        const wp::int32 var_128 = 0;
        wp::float32 var_129;
        wp::float32 var_130;
        const wp::int32 var_131 = 1;
        wp::float32 var_132;
        wp::float32 var_133;
        const wp::int32 var_134 = 1;
        wp::float32 var_135;
        wp::float32 var_136;
        wp::float32 var_137;
        const wp::int32 var_138 = 1;
        wp::float32 var_139;
        wp::float32 var_140;
        const wp::int32 var_141 = 2;
        wp::float32 var_142;
        wp::float32 var_143;
        wp::float32 var_144;
        const wp::int32 var_145 = 2;
        wp::float32 var_146;
        wp::float32 var_147;
        const wp::int32 var_148 = 0;
        wp::float32 var_149;
        wp::float32 var_150;
        const wp::int32 var_151 = 2;
        wp::float32 var_152;
        wp::float32 var_153;
        const wp::int32 var_154 = 1;
        wp::float32 var_155;
        wp::float32 var_156;
        wp::float32 var_157;
        const wp::int32 var_158 = 2;
        wp::float32 var_159;
        wp::float32 var_160;
        const wp::int32 var_161 = 2;
        wp::float32 var_162;
        wp::float32 var_163;
        wp::float32 var_164;
        wp::vec_t<3, wp::float32> var_165;
        wp::vec_t<3, wp::float32> var_166;
        wp::vec_t<3, wp::float32> var_167;
        wp::vec_t<3, wp::float32> var_168;
        wp::vec_t<3, wp::float32> var_169;
        GenericShapeData_ceaba563 var_170;
        const wp::int32 var_171 = 1;
        bool var_172;
        const wp::int32 var_173 = 0;
        wp::float32 var_174;
        const wp::float32 var_175 = 0.5;
        wp::float32 var_176;
        const wp::int32 var_177 = 1;
        wp::float32 var_178;
        const wp::float32 var_179 = 0.5;
        wp::float32 var_180;
        const wp::float32 var_181 = 0.0;
        wp::vec_t<3, wp::float32> var_182;
        wp::vec_t<3, wp::float32> var_183;
        const wp::float32 var_184 = 0.0;
        const wp::float32 var_185 = 0.0;
        const wp::float32 var_186 = 0.0;
        wp::vec_t<3, wp::float32> var_187;
        const wp::int32 var_188 = 10;
        bool var_189;
        wp::uint64* var_190;
        wp::vec_t<3, wp::float32> var_191;
        wp::uint64 var_192;
        SupportMapDataProvider_e77f8b9f var_193;
        wp::vec_t<3, wp::float32> var_194;
        wp::vec_t<3, wp::float32> var_195;
        wp::vec_t<3, wp::float32> var_196;
        wp::vec_t<3, wp::float32> var_197;
        wp::vec_t<3, wp::float32> var_198;
        wp::vec_t<3, wp::float32> var_199;
        const wp::int32 var_200 = 0;
        wp::float32 var_201;
        const wp::int32 var_202 = 1;
        wp::float32 var_203;
        const wp::int32 var_204 = 2;
        wp::float32 var_205;
        wp::vec_t<4, wp::float32> var_206;
        //---------
        // forward
        // def compute_shape_aabbs(                                                               <L 167>
        // shape_id = wp.tid()                                                                    <L 195>
        var_0 = builtin_tid1d();
        // if shape_id == 0:                                                                      <L 199>
        var_2 = (var_0 == var_1);
        if (var_2) {
            // for c in range(num_contact_counters):                                              <L 200>
            var_3 = wp::range(var_num_contact_counters);
            start_for_0:;
                if (iter_cmp(var_3) == 0) goto end_for_0;
                var_4 = wp::iter_next(var_3);
                // contact_counters[c] = 0                                                        <L 201>
                wp::array_store(var_contact_counters, var_4, var_5);
                goto start_for_0;
            end_for_0:;
            // g = contact_generation[0]                                                          <L 202>
            var_7 = wp::address(var_contact_generation, var_6);
            var_9 = wp::load(var_7);
            var_8 = wp::copy(var_9);
            // if g == 2147483647:                                                                <L 203>
            var_11 = (var_8 == var_10);
            if (var_11) {
                // g = 0                                                                          <L 204>
            }
            if (!var_11) {
                // g = g + 1                                                                      <L 206>
                var_14 = wp::add(var_8, var_13);
            }
            var_15 = wp::where(var_11, var_12, var_14);
            // contact_generation[0] = g                                                          <L 207>
            wp::array_store(var_contact_generation, var_16, var_15);
            // broad_phase_pair_count[0] = 0                                                      <L 208>
            wp::array_store(var_broad_phase_pair_count, var_18, var_17);
        }
        // rigid_id = shape_body[shape_id]                                                        <L 210>
        var_19 = wp::address(var_shape_body, var_0);
        var_21 = wp::load(var_19);
        var_20 = wp::copy(var_21);
        // geo_type = shape_type[shape_id]                                                        <L 211>
        var_22 = wp::address(var_shape_type, var_0);
        var_24 = wp::load(var_22);
        var_23 = wp::copy(var_24);
        // if rigid_id == -1:                                                                     <L 214>
        var_26 = (var_20 == var_25);
        if (var_26) {
            // X_ws = shape_transform[shape_id]                                                   <L 215>
            var_27 = wp::address(var_shape_transform, var_0);
            var_29 = wp::load(var_27);
            var_28 = wp::copy(var_29);
        }
        if (!var_26) {
            // X_ws = wp.transform_multiply(body_q[rigid_id], shape_transform[shape_id])          <L 217>
            var_30 = wp::address(var_body_q, var_20);
            var_31 = wp::address(var_shape_transform, var_0);
            var_33 = wp::load(var_30);
            var_34 = wp::load(var_31);
            var_32 = wp::transform_multiply(var_33, var_34);
        }
        var_35 = wp::where(var_26, var_28, var_32);
        // pos = wp.transform_get_translation(X_ws)                                               <L 219>
        var_36 = wp::transform_get_translation(var_35);
        // orientation = wp.transform_get_rotation(X_ws)                                          <L 220>
        var_37 = wp::transform_get_rotation(var_35);
        // margin = shape_margin[shape_id]                                                        <L 222>
        var_38 = wp::address(var_shape_margin, var_0);
        var_40 = wp::load(var_38);
        var_39 = wp::copy(var_40);
        // effective_gap = margin + shape_gap[shape_id]                                           <L 225>
        var_41 = wp::address(var_shape_gap, var_0);
        var_43 = wp::load(var_41);
        var_42 = wp::add(var_39, var_43);
        // margin_vec = wp.vec3(effective_gap, effective_gap, effective_gap)                      <L 226>
        var_44 = wp::vec_t<3, wp::float32>(var_42, var_42, var_42);
        // scale = shape_scale[shape_id]                                                          <L 229>
        var_45 = wp::address(var_shape_scale, var_0);
        var_47 = wp::load(var_45);
        var_46 = wp::copy(var_47);
        // is_infinite_plane = (geo_type == GeoType.PLANE) and (scale[0] == 0.0 and scale[1] == 0.0)       <L 230>
        var_50 = (var_23 == var_49);
        var_48 = var_50;
        if (var_48) {
            var_53 = wp::extract(var_46, var_52);
            var_55 = (var_53 == var_54);
            var_51 = var_55;
            if (var_51) {
                var_57 = wp::extract(var_46, var_56);
                var_59 = (var_57 == var_58);
                var_51 = var_51 && var_59;
            }
            var_48 = var_48 && var_51;
        }
        // has_local_aabb = geo_type == GeoType.MESH or geo_type == GeoType.HFIELD or geo_type == GeoType.CONVEX_MESH       <L 231>
        var_62 = (var_23 == var_61);
        var_60 = var_62;
        if (!var_60) {
            var_64 = (var_23 == var_63);
            var_60 = var_60 || var_64;
        }
        if (!var_60) {
            var_66 = (var_23 == var_65);
            var_60 = var_60 || var_66;
        }
        // geom_scale = scale                                                                     <L 233>
        var_67 = wp::copy(var_46);
        // if is_infinite_plane:                                                                  <L 235>
        if (var_48) {
            // radius = shape_collision_radius[shape_id]                                          <L 237>
            var_68 = wp::address(var_shape_collision_radius, var_0);
            var_70 = wp::load(var_68);
            var_69 = wp::copy(var_70);
            // half_extents = wp.vec3(radius, radius, radius)                                     <L 238>
            var_71 = wp::vec_t<3, wp::float32>(var_69, var_69, var_69);
            // aabb_lower[shape_id] = pos - half_extents - margin_vec                             <L 239>
            var_72 = wp::sub(var_36, var_71);
            var_73 = wp::sub(var_72, var_44);
            wp::array_store(var_aabb_lower, var_0, var_73);
            // aabb_upper[shape_id] = pos + half_extents + margin_vec                             <L 240>
            var_74 = wp::add(var_36, var_71);
            var_75 = wp::add(var_74, var_44);
            wp::array_store(var_aabb_upper, var_0, var_75);
        }
        if (!var_48) {
            // elif has_local_aabb:                                                               <L 241>
            if (var_60) {
                // local_lo = shape_collision_aabb_lower[shape_id]                                <L 245>
                var_76 = wp::address(var_shape_collision_aabb_lower, var_0);
                var_78 = wp::load(var_76);
                var_77 = wp::copy(var_78);
                // local_hi = shape_collision_aabb_upper[shape_id]                                <L 246>
                var_79 = wp::address(var_shape_collision_aabb_upper, var_0);
                var_81 = wp::load(var_79);
                var_80 = wp::copy(var_81);
                // center = (local_lo + local_hi) * 0.5                                           <L 248>
                var_82 = wp::add(var_77, var_80);
                var_84 = wp::mul(var_82, var_83);
                // half = (local_hi - local_lo) * 0.5                                             <L 249>
                var_85 = wp::sub(var_80, var_77);
                var_87 = wp::mul(var_85, var_86);
                // world_center = wp.quat_rotate(orientation, center) + pos                       <L 252>
                var_88 = wp::quat_rotate(var_37, var_84);
                var_89 = wp::add(var_88, var_36);
                // r0 = wp.quat_rotate(orientation, wp.vec3(1.0, 0.0, 0.0))                       <L 255>
                var_93 = wp::vec_t<3, wp::float32>(var_90, var_91, var_92);
                var_94 = wp::quat_rotate(var_37, var_93);
                // r1 = wp.quat_rotate(orientation, wp.vec3(0.0, 1.0, 0.0))                       <L 256>
                var_98 = wp::vec_t<3, wp::float32>(var_95, var_96, var_97);
                var_99 = wp::quat_rotate(var_37, var_98);
                // r2 = wp.quat_rotate(orientation, wp.vec3(0.0, 0.0, 1.0))                       <L 257>
                var_103 = wp::vec_t<3, wp::float32>(var_100, var_101, var_102);
                var_104 = wp::quat_rotate(var_37, var_103);
                // world_half = wp.vec3(                                                          <L 259>
                // wp.abs(r0[0]) * half[0] + wp.abs(r1[0]) * half[1] + wp.abs(r2[0]) * half[2],       <L 260>
                var_106 = wp::extract(var_94, var_105);
                var_107 = wp::abs(var_106);
                var_109 = wp::extract(var_87, var_108);
                var_110 = wp::mul(var_107, var_109);
                var_112 = wp::extract(var_99, var_111);
                var_113 = wp::abs(var_112);
                var_115 = wp::extract(var_87, var_114);
                var_116 = wp::mul(var_113, var_115);
                var_117 = wp::add(var_110, var_116);
                var_119 = wp::extract(var_104, var_118);
                var_120 = wp::abs(var_119);
                var_122 = wp::extract(var_87, var_121);
                var_123 = wp::mul(var_120, var_122);
                var_124 = wp::add(var_117, var_123);
                // wp.abs(r0[1]) * half[0] + wp.abs(r1[1]) * half[1] + wp.abs(r2[1]) * half[2],       <L 261>
                var_126 = wp::extract(var_94, var_125);
                var_127 = wp::abs(var_126);
                var_129 = wp::extract(var_87, var_128);
                var_130 = wp::mul(var_127, var_129);
                var_132 = wp::extract(var_99, var_131);
                var_133 = wp::abs(var_132);
                var_135 = wp::extract(var_87, var_134);
                var_136 = wp::mul(var_133, var_135);
                var_137 = wp::add(var_130, var_136);
                var_139 = wp::extract(var_104, var_138);
                var_140 = wp::abs(var_139);
                var_142 = wp::extract(var_87, var_141);
                var_143 = wp::mul(var_140, var_142);
                var_144 = wp::add(var_137, var_143);
                // wp.abs(r0[2]) * half[0] + wp.abs(r1[2]) * half[1] + wp.abs(r2[2]) * half[2],       <L 262>
                var_146 = wp::extract(var_94, var_145);
                var_147 = wp::abs(var_146);
                var_149 = wp::extract(var_87, var_148);
                var_150 = wp::mul(var_147, var_149);
                var_152 = wp::extract(var_99, var_151);
                var_153 = wp::abs(var_152);
                var_155 = wp::extract(var_87, var_154);
                var_156 = wp::mul(var_153, var_155);
                var_157 = wp::add(var_150, var_156);
                var_159 = wp::extract(var_104, var_158);
                var_160 = wp::abs(var_159);
                var_162 = wp::extract(var_87, var_161);
                var_163 = wp::mul(var_160, var_162);
                var_164 = wp::add(var_157, var_163);
                var_165 = wp::vec_t<3, wp::float32>(var_124, var_144, var_164);
                // aabb_lower[shape_id] = world_center - world_half - margin_vec                  <L 265>
                var_166 = wp::sub(var_89, var_165);
                var_167 = wp::sub(var_166, var_44);
                wp::array_store(var_aabb_lower, var_0, var_167);
                // aabb_upper[shape_id] = world_center + world_half + margin_vec                  <L 266>
                var_168 = wp::add(var_89, var_165);
                var_169 = wp::add(var_168, var_44);
                wp::array_store(var_aabb_upper, var_0, var_169);
            }
            if (!var_60) {
                // shape_data = GenericShapeData()                                                <L 270>
                var_170 = GenericShapeData_ceaba563();
                // shape_data.shape_type = geo_type                                               <L 271>
                var_170.shape_type = var_23;
                // if geo_type == GeoType.PLANE:                                                  <L 272>
                var_172 = (var_23 == var_171);
                if (var_172) {
                    // geom_scale = wp.vec3(scale[0] * 0.5, scale[1] * 0.5, 0.0)                  <L 273>
                    var_174 = wp::extract(var_46, var_173);
                    var_176 = wp::mul(var_174, var_175);
                    var_178 = wp::extract(var_46, var_177);
                    var_180 = wp::mul(var_178, var_179);
                    var_182 = wp::vec_t<3, wp::float32>(var_176, var_180, var_181);
                }
                var_183 = wp::where(var_172, var_182, var_67);
                // shape_data.scale = geom_scale                                                  <L 274>
                var_170.scale = var_183;
                // shape_data.auxiliary = wp.vec3(0.0, 0.0, 0.0)                                  <L 275>
                var_187 = wp::vec_t<3, wp::float32>(var_184, var_185, var_186);
                var_170.auxiliary = var_187;
                // if geo_type == GeoType.CONVEX_MESH:                                            <L 278>
                var_189 = (var_23 == var_188);
                if (var_189) {
                    // shape_data.auxiliary = pack_mesh_ptr(shape_source_ptr[shape_id])           <L 279>
                    var_190 = wp::address(var_shape_source_ptr, var_0);
                    var_192 = wp::load(var_190);
                    var_191 = pack_mesh_ptr_0(var_192);
                    var_170.auxiliary = var_191;
                }
                // data_provider = SupportMapDataProvider()                                       <L 281>
                var_193 = SupportMapDataProvider_e77f8b9f();
                // aabb_min_world, aabb_max_world = compute_tight_aabb_from_support(shape_data, orientation, pos, data_provider)       <L 284>
                compute_tight_aabb_from_support_0(var_170, var_37, var_36, var_193, var_194, var_195);
                // aabb_lower[shape_id] = aabb_min_world - margin_vec                             <L 286>
                var_196 = wp::sub(var_194, var_44);
                wp::array_store(var_aabb_lower, var_0, var_196);
                // aabb_upper[shape_id] = aabb_max_world + margin_vec                             <L 287>
                var_197 = wp::add(var_195, var_44);
                wp::array_store(var_aabb_upper, var_0, var_197);
            }
            var_198 = wp::where(var_60, var_67, var_183);
        }
        var_199 = wp::where(var_48, var_67, var_198);
        // geom_data[shape_id] = wp.vec4(geom_scale[0], geom_scale[1], geom_scale[2], margin)       <L 290>
        var_201 = wp::extract(var_199, var_200);
        var_203 = wp::extract(var_199, var_202);
        var_205 = wp::extract(var_199, var_204);
        var_206 = wp::vec_t<4, wp::float32>(var_201, var_203, var_205, var_39);
        wp::array_store(var_geom_data, var_0, var_206);
        // geom_xform[shape_id] = X_ws                                                            <L 291>
        wp::array_store(var_geom_xform, var_0, var_35);
    }
}

