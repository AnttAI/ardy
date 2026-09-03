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


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/broad_phase_common.py:118
static CUDA_CALLABLE bool is_shape_pair_immovable_filtered_0(
    wp::int32 var_shape_a,
    wp::int32 var_shape_b,
    wp::array_t<wp::int32> var_shape_body,
    wp::array_t<wp::int32> var_body_flags,
    bool var_include_static_kinematic_pairs)
{
    //---------
    // primal vars
    bool var_0;
    wp::shape_t* var_1;
    const wp::int32 var_2 = 0;
    wp::int32 var_3;
    wp::shape_t var_4;
    const wp::int32 var_5 = 0;
    bool var_6;
    const bool var_7 = false;
    wp::int32* var_8;
    wp::int32 var_9;
    wp::int32 var_10;
    wp::int32* var_11;
    wp::int32 var_12;
    wp::int32 var_13;
    const wp::int32 var_14 = 0;
    bool var_15;
    const wp::int32 var_16 = 0;
    bool var_17;
    bool var_18;
    const bool var_19 = true;
    wp::shape_t* var_20;
    const wp::int32 var_21 = 0;
    wp::int32 var_22;
    wp::shape_t var_23;
    const wp::int32 var_24 = 0;
    bool var_25;
    const bool var_26 = false;
    const bool var_27 = false;
    const bool var_28 = false;
    bool var_29;
    wp::int32* var_30;
    const wp::int32 var_31 = 2;
    wp::int32 var_32;
    wp::int32 var_33;
    const wp::int32 var_34 = 0;
    bool var_35;
    bool var_36;
    bool var_37;
    wp::int32* var_38;
    wp::int32 var_39;
    wp::int32 var_40;
    const wp::int32 var_41 = 0;
    bool var_42;
    bool var_43;
    bool var_44;
    bool var_45;
    bool var_46;
    //---------
    // forward
    // def is_shape_pair_immovable_filtered(                                                  <L 119>
    // if include_static_kinematic_pairs or shape_body.shape[0] == 0:                         <L 129>
    var_0 = var_include_static_kinematic_pairs;
    if (!var_0) {
        var_1 = &(var_shape_body.shape);
        var_4 = wp::load(var_1);
        var_3 = wp::extract(var_4, var_2);
        var_6 = (var_3 == var_5);
        var_0 = var_0 || var_6;
    }
    if (var_0) {
        // return False                                                                       <L 130>
        return var_7;
    }
    // body_a = shape_body[shape_a]                                                           <L 132>
    var_8 = wp::address(var_shape_body, var_shape_a);
    var_10 = wp::load(var_8);
    var_9 = wp::copy(var_10);
    // body_b = shape_body[shape_b]                                                           <L 133>
    var_11 = wp::address(var_shape_body, var_shape_b);
    var_13 = wp::load(var_11);
    var_12 = wp::copy(var_13);
    // static_a = body_a < 0                                                                  <L 135>
    var_15 = (var_9 < var_14);
    // static_b = body_b < 0                                                                  <L 136>
    var_17 = (var_12 < var_16);
    // if static_a and static_b:                                                              <L 138>
    var_18 = var_15;
    if (var_18) {
        var_18 = var_18 && var_17;
    }
    if (var_18) {
        // return True                                                                        <L 139>
        return var_19;
    }
    // if body_flags.shape[0] == 0:                                                           <L 142>
    var_20 = &(var_body_flags.shape);
    var_23 = wp::load(var_20);
    var_22 = wp::extract(var_23, var_21);
    var_25 = (var_22 == var_24);
    if (var_25) {
        // return False                                                                       <L 143>
        return var_26;
    }
    // kinematic_a = False                                                                    <L 145>
    // kinematic_b = False                                                                    <L 146>
    // if not static_a:                                                                       <L 147>
    var_29 = wp::unot(var_15);
    if (var_29) {
        // kinematic_a = (body_flags[body_a] & BODY_FLAG_KINEMATIC) != 0                      <L 148>
        var_30 = wp::address(var_body_flags, var_9);
        var_33 = wp::load(var_30);
        var_32 = wp::bit_and(var_33, var_31);
        var_35 = (var_32 != var_34);
    }
    var_36 = wp::where(var_29, var_35, var_27);
    // if not static_b:                                                                       <L 149>
    var_37 = wp::unot(var_17);
    if (var_37) {
        // kinematic_b = (body_flags[body_b] & BODY_FLAG_KINEMATIC) != 0                      <L 150>
        var_38 = wp::address(var_body_flags, var_12);
        var_40 = wp::load(var_38);
        var_39 = wp::bit_and(var_40, var_31);
        var_42 = (var_39 != var_41);
    }
    var_43 = wp::where(var_37, var_42, var_28);
    // immovable_a = static_a or kinematic_a                                                  <L 152>
    var_44 = var_15;
    if (!var_44) {
        var_44 = var_44 || var_36;
    }
    // immovable_b = static_b or kinematic_b                                                  <L 153>
    var_45 = var_17;
    if (!var_45) {
        var_45 = var_45 || var_43;
    }
    // return immovable_a and immovable_b                                                     <L 154>
    var_46 = var_44;
    if (var_46) {
        var_46 = var_46 && var_45;
    }
    return var_46;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/broad_phase_common.py:20
static CUDA_CALLABLE bool check_aabb_overlap_0(
    wp::vec_t<3, wp::float32> var_box1_lower,
    wp::vec_t<3, wp::float32> var_box1_upper,
    wp::float32 var_box1_cutoff,
    wp::vec_t<3, wp::float32> var_box2_lower,
    wp::vec_t<3, wp::float32> var_box2_upper,
    wp::float32 var_box2_cutoff)
{
    //---------
    // primal vars
    wp::float32 var_0;
    bool var_1;
    const wp::int32 var_2 = 0;
    wp::float32 var_3;
    const wp::int32 var_4 = 0;
    wp::float32 var_5;
    wp::float32 var_6;
    bool var_7;
    const wp::int32 var_8 = 0;
    wp::float32 var_9;
    const wp::int32 var_10 = 0;
    wp::float32 var_11;
    wp::float32 var_12;
    bool var_13;
    const wp::int32 var_14 = 1;
    wp::float32 var_15;
    const wp::int32 var_16 = 1;
    wp::float32 var_17;
    wp::float32 var_18;
    bool var_19;
    const wp::int32 var_20 = 1;
    wp::float32 var_21;
    const wp::int32 var_22 = 1;
    wp::float32 var_23;
    wp::float32 var_24;
    bool var_25;
    const wp::int32 var_26 = 2;
    wp::float32 var_27;
    const wp::int32 var_28 = 2;
    wp::float32 var_29;
    wp::float32 var_30;
    bool var_31;
    const wp::int32 var_32 = 2;
    wp::float32 var_33;
    const wp::int32 var_34 = 2;
    wp::float32 var_35;
    wp::float32 var_36;
    bool var_37;
    //---------
    // forward
    // def check_aabb_overlap(                                                                <L 21>
    // cutoff_combined = box1_cutoff + box2_cutoff                                            <L 29>
    var_0 = wp::add(var_box1_cutoff, var_box2_cutoff);
    // return (                                                                               <L 30>
    // box1_lower[0] <= box2_upper[0] + cutoff_combined                                       <L 31>
    var_3 = wp::extract(var_box1_lower, var_2);
    var_5 = wp::extract(var_box2_upper, var_4);
    var_6 = wp::add(var_5, var_0);
    var_7 = (var_3 <= var_6);
    var_1 = var_7;
    if (var_1) {
        // and box1_upper[0] >= box2_lower[0] - cutoff_combined                               <L 32>
        var_9 = wp::extract(var_box1_upper, var_8);
        var_11 = wp::extract(var_box2_lower, var_10);
        var_12 = wp::sub(var_11, var_0);
        var_13 = (var_9 >= var_12);
        var_1 = var_1 && var_13;
    }
    if (var_1) {
        // and box1_lower[1] <= box2_upper[1] + cutoff_combined                               <L 33>
        var_15 = wp::extract(var_box1_lower, var_14);
        var_17 = wp::extract(var_box2_upper, var_16);
        var_18 = wp::add(var_17, var_0);
        var_19 = (var_15 <= var_18);
        var_1 = var_1 && var_19;
    }
    if (var_1) {
        // and box1_upper[1] >= box2_lower[1] - cutoff_combined                               <L 34>
        var_21 = wp::extract(var_box1_upper, var_20);
        var_23 = wp::extract(var_box2_lower, var_22);
        var_24 = wp::sub(var_23, var_0);
        var_25 = (var_21 >= var_24);
        var_1 = var_1 && var_25;
    }
    if (var_1) {
        // and box1_lower[2] <= box2_upper[2] + cutoff_combined                               <L 35>
        var_27 = wp::extract(var_box1_lower, var_26);
        var_29 = wp::extract(var_box2_upper, var_28);
        var_30 = wp::add(var_29, var_0);
        var_31 = (var_27 <= var_30);
        var_1 = var_1 && var_31;
    }
    if (var_1) {
        // and box1_upper[2] >= box2_lower[2] - cutoff_combined                               <L 36>
        var_33 = wp::extract(var_box1_upper, var_32);
        var_35 = wp::extract(var_box2_lower, var_34);
        var_36 = wp::sub(var_35, var_0);
        var_37 = (var_33 >= var_36);
        var_1 = var_1 && var_37;
    }
    return var_1;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/broad_phase_common.py:157
static CUDA_CALLABLE void write_pair_0(
    wp::vec_t<2, wp::int32> var_pair,
    wp::array_t<wp::vec_t<2, wp::int32>> var_candidate_pair,
    wp::array_t<wp::int32> var_candidate_pair_count,
    wp::int32 var_max_candidate_pair)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    const wp::int32 var_1 = 1;
    wp::int32 var_2;
    bool var_3;
    //---------
    // forward
    // def write_pair(                                                                        <L 158>
    // pairid = wp.atomic_add(candidate_pair_count, 0, 1)                                     <L 164>
    var_2 = wp::atomic_add(var_candidate_pair_count, var_0, var_1);
    // if pairid >= max_candidate_pair:                                                       <L 166>
    var_3 = (var_2 >= var_max_candidate_pair);
    if (var_3) {
        // return                                                                             <L 167>
        return;
    }
    // candidate_pair[pairid] = pair                                                          <L 169>
    wp::array_store(var_candidate_pair, var_2, var_pair);
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/broad_phase_nxn.py:98
static CUDA_CALLABLE void _find_world_and_local_id_0(
    wp::int32 var_tid,
    wp::array_t<wp::int32> var_world_cumsum_lower_tri,
    wp::int32 & ret_0,
    wp::int32 & ret_1)
{
    //---------
    // primal vars
    wp::shape_t* var_0;
    const wp::int32 var_1 = 0;
    wp::int32 var_2;
    wp::shape_t var_3;
    const wp::int32 var_4 = 0;
    wp::int32 var_5;
    const wp::int32 var_6 = 1;
    wp::int32 var_7;
    wp::int32 var_8;
    const wp::int32 var_9 = 0;
    wp::int32 var_10;
    bool var_11;
    wp::int32 var_12;
    const wp::int32 var_13 = 1;
    wp::int32 var_14;
    wp::int32* var_15;
    bool var_16;
    wp::int32 var_17;
    const wp::int32 var_18 = 1;
    wp::int32 var_19;
    wp::int32 var_20;
    const wp::int32 var_21 = 1;
    wp::int32 var_22;
    wp::int32 var_23;
    wp::int32 var_24;
    wp::int32 var_25;
    wp::int32 var_26;
    const wp::int32 var_27 = 0;
    bool var_28;
    const wp::int32 var_29 = 1;
    wp::int32 var_30;
    wp::int32* var_31;
    wp::int32 var_32;
    wp::int32 var_33;
    wp::int32 var_34;
    //---------
    // forward
    // def _find_world_and_local_id(                                                          <L 99>
    // world_count = world_cumsum_lower_tri.shape[0]                                          <L 112>
    var_0 = &(var_world_cumsum_lower_tri.shape);
    var_3 = wp::load(var_0);
    var_2 = wp::extract(var_3, var_1);
    // low = int(0)                                                                           <L 116>
    var_5 = wp::int(var_4);
    // high = int(world_count - 1)                                                            <L 117>
    var_7 = wp::sub(var_2, var_6);
    var_8 = wp::int(var_7);
    // world_id = int(0)                                                                      <L 118>
    var_10 = wp::int(var_9);
    // while low <= high:                                                                     <L 120>
    start_while_0:;
    var_11 = (var_5 <= var_8);
    if ((var_11) == false) goto end_while_0;
        // mid = (low + high) >> 1                                                            <L 121>
        var_12 = wp::add(var_5, var_8);
        var_14 = wp::rshift(var_12, var_13);
        // if tid < world_cumsum_lower_tri[mid]:                                              <L 122>
        var_15 = wp::address(var_world_cumsum_lower_tri, var_14);
        var_17 = wp::load(var_15);
        var_16 = (var_tid < var_17);
        if (var_16) {
            // high = mid - 1                                                                 <L 123>
            var_19 = wp::sub(var_14, var_18);
            // world_id = mid                                                                 <L 124>
            var_20 = wp::copy(var_14);
        }
        if (!var_16) {
            // low = mid + 1                                                                  <L 126>
            var_22 = wp::add(var_14, var_21);
        }
        var_23 = wp::where(var_16, var_5, var_22);
        var_24 = wp::where(var_16, var_19, var_8);
        var_25 = wp::where(var_16, var_20, var_10);
        wp::assign(var_5, var_23);
        wp::assign(var_8, var_24);
        wp::assign(var_10, var_25);
    goto start_while_0;
    end_while_0:;
    // local_id = tid                                                                         <L 129>
    var_26 = wp::copy(var_tid);
    // if world_id > 0:                                                                       <L 130>
    var_28 = (var_10 > var_27);
    if (var_28) {
        // local_id = tid - world_cumsum_lower_tri[world_id - 1]                              <L 131>
        var_30 = wp::sub(var_10, var_29);
        var_31 = wp::address(var_world_cumsum_lower_tri, var_30);
        var_33 = wp::load(var_31);
        var_32 = wp::sub(var_tid, var_33);
    }
    var_34 = wp::where(var_28, var_32, var_26);
    // return world_id, local_id                                                              <L 133>
    ret_0 = var_10;
    ret_1 = var_34;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/broad_phase_nxn.py:76
static CUDA_CALLABLE void _get_lower_triangular_indices_0(
    wp::int32 var_index,
    wp::int32 var_matrix_size,
    wp::int32 & ret_0,
    wp::int32 & ret_1)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 1;
    wp::int32 var_1;
    wp::int32 var_2;
    const wp::int32 var_3 = 1;
    wp::int32 var_4;
    bool var_5;
    const wp::int32 var_6 = -1;
    const wp::int32 var_7 = -1;
    const wp::int32 var_8 = 0;
    wp::int32 var_9;
    const wp::int32 var_10 = 1;
    wp::int32 var_11;
    bool var_12;
    wp::int32 var_13;
    const wp::int32 var_14 = 1;
    wp::int32 var_15;
    const wp::int32 var_16 = 2;
    wp::int32 var_17;
    wp::int32 var_18;
    const wp::int32 var_19 = 1;
    wp::int32 var_20;
    wp::int32 var_21;
    const wp::int32 var_22 = 1;
    wp::int32 var_23;
    bool var_24;
    const wp::int32 var_25 = 1;
    wp::int32 var_26;
    wp::int32 var_27;
    wp::int32 var_28;
    wp::int32 var_29;
    const wp::int32 var_30 = 1;
    wp::int32 var_31;
    const wp::int32 var_32 = 2;
    wp::int32 var_33;
    wp::int32 var_34;
    const wp::int32 var_35 = 1;
    wp::int32 var_36;
    wp::int32 var_37;
    const wp::int32 var_38 = 1;
    wp::int32 var_39;
    wp::int32 var_40;
    wp::int32 var_41;
    const wp::int32 var_42 = 1;
    wp::int32 var_43;
    //---------
    // forward
    // def _get_lower_triangular_indices(index: int, matrix_size: int) -> tuple[int, int]:       <L 77>
    // total = (matrix_size * (matrix_size - 1)) >> 1                                         <L 78>
    var_1 = wp::sub(var_matrix_size, var_0);
    var_2 = wp::mul(var_matrix_size, var_1);
    var_4 = wp::rshift(var_2, var_3);
    // if index >= total:                                                                     <L 79>
    var_5 = (var_index >= var_4);
    if (var_5) {
        // return -1, -1                                                                      <L 81>
        ret_0 = var_6;
        ret_1 = var_7;
        return;
    }
    // low = int(0)                                                                           <L 83>
    var_9 = wp::int(var_8);
    // high = matrix_size - 1                                                                 <L 84>
    var_11 = wp::sub(var_matrix_size, var_10);
    // while low < high:                                                                      <L 85>
    start_while_1:;
    var_12 = (var_9 < var_11);
    if ((var_12) == false) goto end_while_1;
        // mid = (low + high) >> 1                                                            <L 86>
        var_13 = wp::add(var_9, var_11);
        var_15 = wp::rshift(var_13, var_14);
        // count = (mid * (2 * matrix_size - mid - 1)) >> 1                                   <L 87>
        var_17 = wp::mul(var_16, var_matrix_size);
        var_18 = wp::sub(var_17, var_15);
        var_20 = wp::sub(var_18, var_19);
        var_21 = wp::mul(var_15, var_20);
        var_23 = wp::rshift(var_21, var_22);
        // if count <= index:                                                                 <L 88>
        var_24 = (var_23 <= var_index);
        if (var_24) {
            // low = mid + 1                                                                  <L 89>
            var_26 = wp::add(var_15, var_25);
        }
        if (!var_24) {
            // high = mid                                                                     <L 91>
            var_27 = wp::copy(var_15);
        }
        var_28 = wp::where(var_24, var_26, var_9);
        var_29 = wp::where(var_24, var_11, var_27);
        wp::assign(var_9, var_28);
        wp::assign(var_11, var_29);
    goto start_while_1;
    end_while_1:;
    // r = low - 1                                                                            <L 92>
    var_31 = wp::sub(var_9, var_30);
    // f = (r * (2 * matrix_size - r - 1)) >> 1                                               <L 93>
    var_33 = wp::mul(var_32, var_matrix_size);
    var_34 = wp::sub(var_33, var_31);
    var_36 = wp::sub(var_34, var_35);
    var_37 = wp::mul(var_31, var_36);
    var_39 = wp::rshift(var_37, var_38);
    // c = (index - f) + r + 1                                                                <L 94>
    var_40 = wp::sub(var_index, var_39);
    var_41 = wp::add(var_40, var_31);
    var_43 = wp::add(var_41, var_42);
    // return r, c                                                                            <L 95>
    ret_0 = var_31;
    ret_1 = var_43;
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/broad_phase_common.py:173
static CUDA_CALLABLE bool test_group_pair_0(
    wp::int32 var_group_a,
    wp::int32 var_group_b)
{
    //---------
    // primal vars
    bool var_0;
    const wp::int32 var_1 = 0;
    bool var_2;
    const wp::int32 var_3 = 0;
    bool var_4;
    const bool var_5 = false;
    const wp::int32 var_6 = 0;
    bool var_7;
    bool var_8;
    bool var_9;
    const wp::int32 var_10 = 0;
    bool var_11;
    const wp::int32 var_12 = 0;
    bool var_13;
    bool var_14;
    //---------
    // forward
    // def test_group_pair(group_a: int, group_b: int) -> bool:                               <L 174>
    // if group_a == 0 or group_b == 0:                                                       <L 186>
    var_2 = (var_group_a == var_1);
    var_0 = var_2;
    if (!var_0) {
        var_4 = (var_group_b == var_3);
        var_0 = var_0 || var_4;
    }
    if (var_0) {
        // return False                                                                       <L 187>
        return var_5;
    }
    // if group_a > 0:                                                                        <L 188>
    var_7 = (var_group_a > var_6);
    if (var_7) {
        // return group_a == group_b or group_b < 0                                           <L 189>
        var_9 = (var_group_a == var_group_b);
        var_8 = var_9;
        if (!var_8) {
            var_11 = (var_group_b < var_10);
            var_8 = var_8 || var_11;
        }
        return var_8;
    }
    // if group_a < 0:                                                                        <L 190>
    var_13 = (var_group_a < var_12);
    if (var_13) {
        // return group_a != group_b                                                          <L 191>
        var_14 = (var_group_a != var_group_b);
        return var_14;
    }
    return {};
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/broad_phase_common.py:194
static CUDA_CALLABLE bool test_world_and_group_pair_0(
    wp::int32 var_world_a,
    wp::int32 var_world_b,
    wp::int32 var_collision_group_a,
    wp::int32 var_collision_group_b)
{
    //---------
    // primal vars
    bool var_0;
    const wp::int32 var_1 = -1;
    bool var_2;
    const wp::int32 var_3 = -1;
    bool var_4;
    bool var_5;
    const bool var_6 = false;
    bool var_7;
    //---------
    // forward
    // def test_world_and_group_pair(world_a: int, world_b: int, collision_group_a: int, collision_group_b: int) -> bool:       <L 195>
    // if world_a != -1 and world_b != -1 and world_a != world_b:                             <L 217>
    var_2 = (var_world_a != var_1);
    var_0 = var_2;
    if (var_0) {
        var_4 = (var_world_b != var_3);
        var_0 = var_0 && var_4;
    }
    if (var_0) {
        var_5 = (var_world_a != var_world_b);
        var_0 = var_0 && var_5;
    }
    if (var_0) {
        // return False                                                                       <L 218>
        return var_6;
    }
    // return test_group_pair(collision_group_a, collision_group_b)                           <L 221>
    var_7 = test_group_pair_0(var_collision_group_a, var_collision_group_b);
    return var_7;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/broad_phase_common.py:70
static CUDA_CALLABLE bool _vec2i_equal_0(
    wp::vec_t<2, wp::int32> var_p,
    wp::vec_t<2, wp::int32> var_q)
{
    //---------
    // primal vars
    bool var_0;
    const wp::int32 var_1 = 0;
    wp::int32 var_2;
    const wp::int32 var_3 = 0;
    wp::int32 var_4;
    bool var_5;
    const wp::int32 var_6 = 1;
    wp::int32 var_7;
    const wp::int32 var_8 = 1;
    wp::int32 var_9;
    bool var_10;
    //---------
    // forward
    // def _vec2i_equal(p: wp.vec2i, q: wp.vec2i) -> bool:                                    <L 71>
    // return p[0] == q[0] and p[1] == q[1]                                                   <L 81>
    var_2 = wp::extract(var_p, var_1);
    var_4 = wp::extract(var_q, var_3);
    var_5 = (var_2 == var_4);
    var_0 = var_5;
    if (var_0) {
        var_7 = wp::extract(var_p, var_6);
        var_9 = wp::extract(var_q, var_8);
        var_10 = (var_7 == var_9);
        var_0 = var_0 && var_10;
    }
    return var_0;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/broad_phase_common.py:52
static CUDA_CALLABLE bool _vec2i_less_0(
    wp::vec_t<2, wp::int32> var_p,
    wp::vec_t<2, wp::int32> var_q)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    wp::int32 var_1;
    const wp::int32 var_2 = 0;
    wp::int32 var_3;
    bool var_4;
    const bool var_5 = true;
    const wp::int32 var_6 = 0;
    wp::int32 var_7;
    const wp::int32 var_8 = 0;
    wp::int32 var_9;
    bool var_10;
    const bool var_11 = false;
    const wp::int32 var_12 = 1;
    wp::int32 var_13;
    const wp::int32 var_14 = 1;
    wp::int32 var_15;
    bool var_16;
    //---------
    // forward
    // def _vec2i_less(p: wp.vec2i, q: wp.vec2i) -> bool:                                     <L 53>
    // if p[0] < q[0]:                                                                        <L 63>
    var_1 = wp::extract(var_p, var_0);
    var_3 = wp::extract(var_q, var_2);
    var_4 = (var_1 < var_3);
    if (var_4) {
        // return True                                                                        <L 64>
        return var_5;
    }
    // if p[0] > q[0]:                                                                        <L 65>
    var_7 = wp::extract(var_p, var_6);
    var_9 = wp::extract(var_q, var_8);
    var_10 = (var_7 > var_9);
    if (var_10) {
        // return False                                                                       <L 66>
        return var_11;
    }
    // return p[1] < q[1]                                                                     <L 67>
    var_13 = wp::extract(var_p, var_12);
    var_15 = wp::extract(var_q, var_14);
    var_16 = (var_13 < var_15);
    return var_16;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/broad_phase_common.py:84
static CUDA_CALLABLE bool is_pair_excluded_0(
    wp::vec_t<2, wp::int32> var_pair,
    wp::array_t<wp::vec_t<2, wp::int32>> var_filter_pairs,
    wp::int32 var_num_filter_pairs)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    bool var_1;
    const bool var_2 = false;
    const wp::int32 var_3 = 0;
    wp::int32 var_4;
    const wp::int32 var_5 = 1;
    wp::int32 var_6;
    bool var_7;
    wp::int32 var_8;
    const wp::int32 var_9 = 1;
    wp::int32 var_10;
    wp::vec_t<2, wp::int32>* var_11;
    wp::vec_t<2, wp::int32> var_12;
    wp::vec_t<2, wp::int32> var_13;
    bool var_14;
    const bool var_15 = true;
    bool var_16;
    const wp::int32 var_17 = 1;
    wp::int32 var_18;
    const wp::int32 var_19 = 1;
    wp::int32 var_20;
    wp::int32 var_21;
    wp::int32 var_22;
    const bool var_23 = false;
    //---------
    // forward
    // def is_pair_excluded(                                                                  <L 85>
    // if num_filter_pairs <= 0:                                                              <L 102>
    var_1 = (var_num_filter_pairs <= var_0);
    if (var_1) {
        // return False                                                                       <L 103>
        return var_2;
    }
    // low = int(0)                                                                           <L 104>
    var_4 = wp::int(var_3);
    // high = num_filter_pairs - 1                                                            <L 105>
    var_6 = wp::sub(var_num_filter_pairs, var_5);
    // while low <= high:                                                                     <L 106>
    start_while_1:;
    var_7 = (var_4 <= var_6);
    if ((var_7) == false) goto end_while_1;
        // mid = (low + high) >> 1                                                            <L 107>
        var_8 = wp::add(var_4, var_6);
        var_10 = wp::rshift(var_8, var_9);
        // m = filter_pairs[mid]                                                              <L 108>
        var_11 = wp::address(var_filter_pairs, var_10);
        var_13 = wp::load(var_11);
        var_12 = wp::copy(var_13);
        // if _vec2i_equal(pair, m):                                                          <L 109>
        var_14 = _vec2i_equal_0(var_pair, var_12);
        if (var_14) {
            // return True                                                                    <L 110>
            return var_15;
        }
        // if _vec2i_less(pair, m):                                                           <L 111>
        var_16 = _vec2i_less_0(var_pair, var_12);
        if (var_16) {
            // high = mid - 1                                                                 <L 112>
            var_18 = wp::sub(var_10, var_17);
        }
        if (!var_16) {
            // low = mid + 1                                                                  <L 114>
            var_20 = wp::add(var_10, var_19);
        }
        var_21 = wp::where(var_16, var_4, var_20);
        var_22 = wp::where(var_16, var_18, var_6);
        wp::assign(var_4, var_21);
        wp::assign(var_6, var_22);
    goto start_while_1;
    end_while_1:;
    // return False                                                                           <L 115>
    return var_23;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/broad_phase_common.py:118
static CUDA_CALLABLE void adj_is_shape_pair_immovable_filtered_0(
    wp::int32 var_shape_a,
    wp::int32 var_shape_b,
    wp::array_t<wp::int32> var_shape_body,
    wp::array_t<wp::int32> var_body_flags,
    bool var_include_static_kinematic_pairs,
    wp::int32 & adj_shape_a,
    wp::int32 & adj_shape_b,
    wp::array_t<wp::int32> & adj_shape_body,
    wp::array_t<wp::int32> & adj_body_flags,
    bool & adj_include_static_kinematic_pairs,
    bool & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/broad_phase_common.py:20
static CUDA_CALLABLE void adj_check_aabb_overlap_0(
    wp::vec_t<3, wp::float32> var_box1_lower,
    wp::vec_t<3, wp::float32> var_box1_upper,
    wp::float32 var_box1_cutoff,
    wp::vec_t<3, wp::float32> var_box2_lower,
    wp::vec_t<3, wp::float32> var_box2_upper,
    wp::float32 var_box2_cutoff,
    wp::vec_t<3, wp::float32> & adj_box1_lower,
    wp::vec_t<3, wp::float32> & adj_box1_upper,
    wp::float32 & adj_box1_cutoff,
    wp::vec_t<3, wp::float32> & adj_box2_lower,
    wp::vec_t<3, wp::float32> & adj_box2_upper,
    wp::float32 & adj_box2_cutoff,
    bool & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/broad_phase_common.py:157
static CUDA_CALLABLE void adj_write_pair_0(
    wp::vec_t<2, wp::int32> var_pair,
    wp::array_t<wp::vec_t<2, wp::int32>> var_candidate_pair,
    wp::array_t<wp::int32> var_candidate_pair_count,
    wp::int32 var_max_candidate_pair,
    wp::vec_t<2, wp::int32> & adj_pair,
    wp::array_t<wp::vec_t<2, wp::int32>> & adj_candidate_pair,
    wp::array_t<wp::int32> & adj_candidate_pair_count,
    wp::int32 & adj_max_candidate_pair)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/broad_phase_nxn.py:98
static CUDA_CALLABLE void adj__find_world_and_local_id_0(
    wp::int32 var_tid,
    wp::array_t<wp::int32> var_world_cumsum_lower_tri,
    wp::int32 & ret_0,
    wp::int32 & ret_1,
    wp::int32 & adj_tid,
    wp::array_t<wp::int32> & adj_world_cumsum_lower_tri,
    wp::int32 & adj_ret_0,
    wp::int32 & adj_ret_1)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/broad_phase_nxn.py:76
static CUDA_CALLABLE void adj__get_lower_triangular_indices_0(
    wp::int32 var_index,
    wp::int32 var_matrix_size,
    wp::int32 & ret_0,
    wp::int32 & ret_1,
    wp::int32 & adj_index,
    wp::int32 & adj_matrix_size,
    wp::int32 & adj_ret_0,
    wp::int32 & adj_ret_1)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/broad_phase_common.py:173
static CUDA_CALLABLE void adj_test_group_pair_0(
    wp::int32 var_group_a,
    wp::int32 var_group_b,
    wp::int32 & adj_group_a,
    wp::int32 & adj_group_b,
    bool & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/broad_phase_common.py:194
static CUDA_CALLABLE void adj_test_world_and_group_pair_0(
    wp::int32 var_world_a,
    wp::int32 var_world_b,
    wp::int32 var_collision_group_a,
    wp::int32 var_collision_group_b,
    wp::int32 & adj_world_a,
    wp::int32 & adj_world_b,
    wp::int32 & adj_collision_group_a,
    wp::int32 & adj_collision_group_b,
    bool & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/broad_phase_common.py:70
static CUDA_CALLABLE void adj__vec2i_equal_0(
    wp::vec_t<2, wp::int32> var_p,
    wp::vec_t<2, wp::int32> var_q,
    wp::vec_t<2, wp::int32> & adj_p,
    wp::vec_t<2, wp::int32> & adj_q,
    bool & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/broad_phase_common.py:52
static CUDA_CALLABLE void adj__vec2i_less_0(
    wp::vec_t<2, wp::int32> var_p,
    wp::vec_t<2, wp::int32> var_q,
    wp::vec_t<2, wp::int32> & adj_p,
    wp::vec_t<2, wp::int32> & adj_q,
    bool & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/newton/_src/geometry/broad_phase_common.py:84
static CUDA_CALLABLE void adj_is_pair_excluded_0(
    wp::vec_t<2, wp::int32> var_pair,
    wp::array_t<wp::vec_t<2, wp::int32>> var_filter_pairs,
    wp::int32 var_num_filter_pairs,
    wp::vec_t<2, wp::int32> & adj_pair,
    wp::array_t<wp::vec_t<2, wp::int32>> & adj_filter_pairs,
    wp::int32 & adj_num_filter_pairs,
    bool & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}



extern "C" __global__ void _nxn_broadphase_precomputed_pairs_8be4a3a3_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_bounding_box_lower,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_bounding_box_upper,
    wp::array_t<wp::float32> var_shape_gap,
    wp::array_t<wp::vec_t<2, wp::int32>> var_nxn_shape_pair,
    wp::array_t<wp::int32> var_shape_body,
    wp::array_t<wp::int32> var_body_flags,
    bool var_include_static_kinematic_pairs,
    wp::array_t<wp::vec_t<2, wp::int32>> var_candidate_pair,
    wp::array_t<wp::int32> var_candidate_pair_count,
    wp::int32 var_max_candidate_pair)
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
        wp::vec_t<2, wp::int32>* var_1;
        wp::vec_t<2, wp::int32> var_2;
        wp::vec_t<2, wp::int32> var_3;
        const wp::int32 var_4 = 0;
        wp::int32 var_5;
        const wp::int32 var_6 = 1;
        wp::int32 var_7;
        bool var_8;
        const wp::float32 var_9 = 0.0;
        const wp::float32 var_10 = 0.0;
        wp::shape_t* var_11;
        const wp::int32 var_12 = 0;
        wp::int32 var_13;
        wp::shape_t var_14;
        const wp::int32 var_15 = 0;
        bool var_16;
        wp::float32* var_17;
        wp::float32 var_18;
        wp::float32 var_19;
        wp::float32* var_20;
        wp::float32 var_21;
        wp::float32 var_22;
        wp::float32 var_23;
        wp::float32 var_24;
        wp::vec_t<3, wp::float32>* var_25;
        wp::vec_t<3, wp::float32>* var_26;
        wp::vec_t<3, wp::float32>* var_27;
        wp::vec_t<3, wp::float32>* var_28;
        bool var_29;
        wp::vec_t<3, wp::float32> var_30;
        wp::vec_t<3, wp::float32> var_31;
        wp::vec_t<3, wp::float32> var_32;
        wp::vec_t<3, wp::float32> var_33;
        //---------
        // forward
        // def _nxn_broadphase_precomputed_pairs(                                                 <L 30>
        // elementid = wp.tid()                                                                   <L 44>
        var_0 = builtin_tid1d();
        // pair = nxn_shape_pair[elementid]                                                       <L 46>
        var_1 = wp::address(var_nxn_shape_pair, var_0);
        var_3 = wp::load(var_1);
        var_2 = wp::copy(var_3);
        // shape1 = pair[0]                                                                       <L 47>
        var_5 = wp::extract(var_2, var_4);
        // shape2 = pair[1]                                                                       <L 48>
        var_7 = wp::extract(var_2, var_6);
        // if is_shape_pair_immovable_filtered(shape1, shape2, shape_body, body_flags, include_static_kinematic_pairs):       <L 50>
        var_8 = is_shape_pair_immovable_filtered_0(var_5, var_7, var_shape_body, var_body_flags, var_include_static_kinematic_pairs);
        if (var_8) {
            // return                                                                             <L 51>
            continue;
        }
        // gap1 = 0.0                                                                             <L 54>
        // gap2 = 0.0                                                                             <L 55>
        // if shape_gap.shape[0] > 0:                                                             <L 56>
        var_11 = &(var_shape_gap.shape);
        var_14 = wp::load(var_11);
        var_13 = wp::extract(var_14, var_12);
        var_16 = (var_13 > var_15);
        if (var_16) {
            // gap1 = shape_gap[shape1]                                                           <L 57>
            var_17 = wp::address(var_shape_gap, var_5);
            var_19 = wp::load(var_17);
            var_18 = wp::copy(var_19);
            // gap2 = shape_gap[shape2]                                                           <L 58>
            var_20 = wp::address(var_shape_gap, var_7);
            var_22 = wp::load(var_20);
            var_21 = wp::copy(var_22);
        }
        var_23 = wp::where(var_16, var_18, var_9);
        var_24 = wp::where(var_16, var_21, var_10);
        // if check_aabb_overlap(                                                                 <L 60>
        // shape_bounding_box_lower[shape1],                                                      <L 61>
        var_25 = wp::address(var_shape_bounding_box_lower, var_5);
        // shape_bounding_box_upper[shape1],                                                      <L 62>
        var_26 = wp::address(var_shape_bounding_box_upper, var_5);
        // gap1,                                                                                  <L 63>
        // shape_bounding_box_lower[shape2],                                                      <L 64>
        var_27 = wp::address(var_shape_bounding_box_lower, var_7);
        // shape_bounding_box_upper[shape2],                                                      <L 65>
        var_28 = wp::address(var_shape_bounding_box_upper, var_7);
        // gap2,                                                                                  <L 66>
        var_30 = wp::load(var_25);
        var_31 = wp::load(var_26);
        var_32 = wp::load(var_27);
        var_33 = wp::load(var_28);
        var_29 = check_aabb_overlap_0(var_30, var_31, var_23, var_32, var_33, var_24);
        if (var_29) {
            // write_pair(                                                                        <L 68>
            // pair,                                                                              <L 69>
            // candidate_pair,                                                                    <L 70>
            // candidate_pair_count,                                                              <L 71>
            // max_candidate_pair,                                                                <L 72>
            write_pair_0(var_2, var_candidate_pair, var_candidate_pair_count, var_max_candidate_pair);
        }
    }
}



extern "C" __global__ void _nxn_broadphase_kernel_0c34076c_cuda_kernel_forward(
    wp::launch_bounds_t<1> dim,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_bounding_box_lower,
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_bounding_box_upper,
    wp::array_t<wp::float32> var_shape_gap,
    wp::array_t<wp::int32> var_collision_group,
    wp::array_t<wp::int32> var_shape_world,
    wp::array_t<wp::int32> var_shape_body,
    wp::array_t<wp::int32> var_body_flags,
    bool var_include_static_kinematic_pairs,
    wp::array_t<wp::int32> var_world_cumsum_lower_tri,
    wp::array_t<wp::int32> var_world_slice_ends,
    wp::array_t<wp::int32> var_world_index_map,
    wp::int32 var_num_regular_worlds,
    wp::array_t<wp::vec_t<2, wp::int32>> var_filter_pairs,
    wp::int32 var_num_filter_pairs,
    wp::array_t<wp::vec_t<2, wp::int32>> var_candidate_pair,
    wp::array_t<wp::int32> var_candidate_pair_count,
    wp::int32 var_max_candidate_pair)
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
        const wp::int32 var_3 = 0;
        const wp::int32 var_4 = 0;
        bool var_5;
        const wp::int32 var_6 = 1;
        wp::int32 var_7;
        wp::int32* var_8;
        wp::int32 var_9;
        wp::int32 var_10;
        wp::int32 var_11;
        wp::int32* var_12;
        wp::int32 var_13;
        wp::int32 var_14;
        wp::int32 var_15;
        wp::int32 var_16;
        wp::int32 var_17;
        wp::int32 var_18;
        wp::int32* var_19;
        wp::int32 var_20;
        wp::int32 var_21;
        wp::int32 var_22;
        wp::int32* var_23;
        wp::int32 var_24;
        wp::int32 var_25;
        wp::int32 var_26;
        wp::int32 var_27;
        wp::int32* var_28;
        wp::int32 var_29;
        wp::int32 var_30;
        wp::int32* var_31;
        wp::int32 var_32;
        wp::int32 var_33;
        wp::int32* var_34;
        wp::int32 var_35;
        wp::int32 var_36;
        wp::int32* var_37;
        wp::int32 var_38;
        wp::int32 var_39;
        bool var_40;
        bool var_41;
        const wp::int32 var_42 = -1;
        bool var_43;
        const wp::int32 var_44 = -1;
        bool var_45;
        bool var_46;
        bool var_47;
        bool var_48;
        bool var_49;
        const wp::float32 var_50 = 0.0;
        const wp::float32 var_51 = 0.0;
        wp::shape_t* var_52;
        const wp::int32 var_53 = 0;
        wp::int32 var_54;
        wp::shape_t var_55;
        const wp::int32 var_56 = 0;
        bool var_57;
        wp::float32* var_58;
        wp::float32 var_59;
        wp::float32 var_60;
        wp::float32* var_61;
        wp::float32 var_62;
        wp::float32 var_63;
        wp::float32 var_64;
        wp::float32 var_65;
        wp::vec_t<3, wp::float32>* var_66;
        wp::vec_t<3, wp::float32>* var_67;
        wp::vec_t<3, wp::float32>* var_68;
        wp::vec_t<3, wp::float32>* var_69;
        bool var_70;
        wp::vec_t<3, wp::float32> var_71;
        wp::vec_t<3, wp::float32> var_72;
        wp::vec_t<3, wp::float32> var_73;
        wp::vec_t<3, wp::float32> var_74;
        bool var_75;
        const wp::int32 var_76 = 0;
        bool var_77;
        wp::vec_t<2, wp::int32> var_78;
        bool var_79;
        wp::vec_t<2, wp::int32> var_80;
        //---------
        // forward
        // def _nxn_broadphase_kernel(                                                            <L 137>
        // tid = wp.tid()                                                                         <L 158>
        var_0 = builtin_tid1d();
        // world_id, local_id = _find_world_and_local_id(tid, world_cumsum_lower_tri)             <L 161>
        _find_world_and_local_id_0(var_0, var_world_cumsum_lower_tri, var_1, var_2);
        // world_slice_start = 0                                                                  <L 164>
        // if world_id > 0:                                                                       <L 165>
        var_5 = (var_1 > var_4);
        if (var_5) {
            // world_slice_start = world_slice_ends[world_id - 1]                                 <L 166>
            var_7 = wp::sub(var_1, var_6);
            var_8 = wp::address(var_world_slice_ends, var_7);
            var_10 = wp::load(var_8);
            var_9 = wp::copy(var_10);
        }
        var_11 = wp::where(var_5, var_9, var_3);
        // world_slice_end = world_slice_ends[world_id]                                           <L 167>
        var_12 = wp::address(var_world_slice_ends, var_1);
        var_14 = wp::load(var_12);
        var_13 = wp::copy(var_14);
        // num_shapes_in_world = world_slice_end - world_slice_start                              <L 170>
        var_15 = wp::sub(var_13, var_11);
        // local_shape1, local_shape2 = _get_lower_triangular_indices(local_id, num_shapes_in_world)       <L 173>
        _get_lower_triangular_indices_0(var_2, var_15, var_16, var_17);
        // shape1_tmp = world_index_map[world_slice_start + local_shape1]                         <L 176>
        var_18 = wp::add(var_11, var_16);
        var_19 = wp::address(var_world_index_map, var_18);
        var_21 = wp::load(var_19);
        var_20 = wp::copy(var_21);
        // shape2_tmp = world_index_map[world_slice_start + local_shape2]                         <L 177>
        var_22 = wp::add(var_11, var_17);
        var_23 = wp::address(var_world_index_map, var_22);
        var_25 = wp::load(var_23);
        var_24 = wp::copy(var_25);
        // shape1 = wp.min(shape1_tmp, shape2_tmp)                                                <L 181>
        var_26 = wp::min(var_20, var_24);
        // shape2 = wp.max(shape1_tmp, shape2_tmp)                                                <L 182>
        var_27 = wp::max(var_20, var_24);
        // world1 = shape_world[shape1]                                                           <L 185>
        var_28 = wp::address(var_shape_world, var_26);
        var_30 = wp::load(var_28);
        var_29 = wp::copy(var_30);
        // world2 = shape_world[shape2]                                                           <L 186>
        var_31 = wp::address(var_shape_world, var_27);
        var_33 = wp::load(var_31);
        var_32 = wp::copy(var_33);
        // collision_group1 = collision_group[shape1]                                             <L 187>
        var_34 = wp::address(var_collision_group, var_26);
        var_36 = wp::load(var_34);
        var_35 = wp::copy(var_36);
        // collision_group2 = collision_group[shape2]                                             <L 188>
        var_37 = wp::address(var_collision_group, var_27);
        var_39 = wp::load(var_37);
        var_38 = wp::copy(var_39);
        // is_dedicated_minus_one_segment = world_id >= num_regular_worlds                        <L 192>
        var_40 = (var_1 >= var_num_regular_worlds);
        // if world1 == -1 and world2 == -1 and not is_dedicated_minus_one_segment:               <L 193>
        var_43 = (var_29 == var_42);
        var_41 = var_43;
        if (var_41) {
            var_45 = (var_32 == var_44);
            var_41 = var_41 && var_45;
        }
        if (var_41) {
            var_46 = wp::unot(var_40);
            var_41 = var_41 && var_46;
        }
        if (var_41) {
            // return                                                                             <L 194>
            continue;
        }
        // if not test_world_and_group_pair(world1, world2, collision_group1, collision_group2):       <L 197>
        var_47 = test_world_and_group_pair_0(var_29, var_32, var_35, var_38);
        var_48 = wp::unot(var_47);
        if (var_48) {
            // return                                                                             <L 198>
            continue;
        }
        // if is_shape_pair_immovable_filtered(shape1, shape2, shape_body, body_flags, include_static_kinematic_pairs):       <L 200>
        var_49 = is_shape_pair_immovable_filtered_0(var_26, var_27, var_shape_body, var_body_flags, var_include_static_kinematic_pairs);
        if (var_49) {
            // return                                                                             <L 201>
            continue;
        }
        // gap1 = 0.0                                                                             <L 204>
        // gap2 = 0.0                                                                             <L 205>
        // if shape_gap.shape[0] > 0:                                                             <L 206>
        var_52 = &(var_shape_gap.shape);
        var_55 = wp::load(var_52);
        var_54 = wp::extract(var_55, var_53);
        var_57 = (var_54 > var_56);
        if (var_57) {
            // gap1 = shape_gap[shape1]                                                           <L 207>
            var_58 = wp::address(var_shape_gap, var_26);
            var_60 = wp::load(var_58);
            var_59 = wp::copy(var_60);
            // gap2 = shape_gap[shape2]                                                           <L 208>
            var_61 = wp::address(var_shape_gap, var_27);
            var_63 = wp::load(var_61);
            var_62 = wp::copy(var_63);
        }
        var_64 = wp::where(var_57, var_59, var_50);
        var_65 = wp::where(var_57, var_62, var_51);
        // if check_aabb_overlap(                                                                 <L 211>
        // shape_bounding_box_lower[shape1],                                                      <L 212>
        var_66 = wp::address(var_shape_bounding_box_lower, var_26);
        // shape_bounding_box_upper[shape1],                                                      <L 213>
        var_67 = wp::address(var_shape_bounding_box_upper, var_26);
        // gap1,                                                                                  <L 214>
        // shape_bounding_box_lower[shape2],                                                      <L 215>
        var_68 = wp::address(var_shape_bounding_box_lower, var_27);
        // shape_bounding_box_upper[shape2],                                                      <L 216>
        var_69 = wp::address(var_shape_bounding_box_upper, var_27);
        // gap2,                                                                                  <L 217>
        var_71 = wp::load(var_66);
        var_72 = wp::load(var_67);
        var_73 = wp::load(var_68);
        var_74 = wp::load(var_69);
        var_70 = check_aabb_overlap_0(var_71, var_72, var_64, var_73, var_74, var_65);
        if (var_70) {
            // if num_filter_pairs > 0 and is_pair_excluded(wp.vec2i(shape1, shape2), filter_pairs, num_filter_pairs):       <L 220>
            var_77 = (var_num_filter_pairs > var_76);
            var_75 = var_77;
            if (var_75) {
                var_78 = wp::vec_t<2, wp::int32>(var_26, var_27);
                var_79 = is_pair_excluded_0(var_78, var_filter_pairs, var_num_filter_pairs);
                var_75 = var_75 && var_79;
            }
            if (var_75) {
                // return                                                                         <L 221>
                continue;
            }
            // write_pair(                                                                        <L 222>
            // wp.vec2i(shape1, shape2),                                                          <L 223>
            var_80 = wp::vec_t<2, wp::int32>(var_26, var_27);
            // candidate_pair,                                                                    <L 224>
            // candidate_pair_count,                                                              <L 225>
            // max_candidate_pair,                                                                <L 226>
            write_pair_0(var_80, var_candidate_pair, var_candidate_pair_count, var_max_candidate_pair);
        }
    }
}

