#define WP_NO_BFLOAT16

#define WP_TILE_BLOCK_DIM 1
#define WP_NO_CRT
#include "builtin.h"
#include "deterministic.h"

// avoid namespacing of float type for casting to float type, this is to avoid wp::float(x), which is not valid in C++
#define float(x) cast_float(x)
#define adj_float(x, adj_x, adj_ret) adj_cast_float(x, adj_x, adj_ret)

#define int(x) cast_int(x)
#define adj_int(x, adj_x, adj_ret) adj_cast_int(x, adj_x, adj_ret)

#define builtin_tid1d() wp::tid(task_index, dim)
#define builtin_tid2d(x, y) wp::tid(x, y, task_index, dim)
#define builtin_tid3d(x, y, z) wp::tid(x, y, z, task_index, dim)
#define builtin_tid4d(x, y, z, w) wp::tid(x, y, z, w, task_index, dim)

#define builtin_block_dim() wp::block_dim()

struct wp_args_count_color_group_sizes_f50b6bb1 {
    wp::array_t<wp::int32> node_colors;
    wp::array_t<wp::int32> group_sizes;
};


void count_color_group_sizes_f50b6bb1_cpu_kernel_forward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_count_color_group_sizes_f50b6bb1 *_wp_args)
{
    //---------
    // argument vars
    wp::array_t<wp::int32> var_node_colors = _wp_args->node_colors;
    wp::array_t<wp::int32> var_group_sizes = _wp_args->group_sizes;
    //---------
    // primal vars
    wp::shape_t* var_0;
    const wp::int32 var_1 = 0;
    wp::int32 var_2;
    wp::shape_t var_3;
    wp::range_t var_4;
    wp::int32 var_5;
    wp::int32* var_6;
    wp::int32 var_7;
    wp::int32 var_8;
    wp::int32* var_9;
    const wp::int32 var_10 = 1;
    wp::int32 var_11;
    wp::int32 var_12;
    //---------
    // forward
    // def count_color_group_sizes(                                                           <L 166>
    // for node_idx in range(node_colors.shape[0]):                                           <L 176>
    var_0 = &(var_node_colors.shape);
    var_3 = wp::load(var_0);
    var_2 = wp::extract(var_3, var_1);
    var_4 = wp::range(var_2);
    start_for_0:;
        if (iter_cmp(var_4) == 0) goto end_for_0;
        var_5 = wp::iter_next(var_4);
        // node_color = node_colors[node_idx]                                                 <L 177>
        var_6 = wp::address(var_node_colors, var_5);
        var_8 = wp::load(var_6);
        var_7 = wp::copy(var_8);
        // group_sizes[node_color] = group_sizes[node_color] + 1                              <L 178>
        var_9 = wp::address(var_group_sizes, var_7);
        var_12 = wp::load(var_9);
        var_11 = wp::add(var_12, var_10);
        wp::array_store(var_group_sizes, var_7, var_11);
        goto start_for_0;
    end_for_0:;
}



void count_color_group_sizes_f50b6bb1_cpu_kernel_backward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_count_color_group_sizes_f50b6bb1 *_wp_args,
    wp_args_count_color_group_sizes_f50b6bb1 *_wp_adj_args)
{
    //---------
    // argument vars
    wp::array_t<wp::int32> var_node_colors = _wp_args->node_colors;
    wp::array_t<wp::int32> var_group_sizes = _wp_args->group_sizes;
    wp::array_t<wp::int32> adj_node_colors = _wp_adj_args->node_colors;
    wp::array_t<wp::int32> adj_group_sizes = _wp_adj_args->group_sizes;
    //---------
    // primal vars
    wp::shape_t* var_0;
    const wp::int32 var_1 = 0;
    wp::int32 var_2;
    wp::shape_t var_3;
    wp::range_t var_4;
    wp::int32 var_5;
    wp::int32* var_6;
    wp::int32 var_7;
    wp::int32 var_8;
    wp::int32* var_9;
    const wp::int32 var_10 = 1;
    wp::int32 var_11;
    wp::int32 var_12;
    //---------
    // dual vars
    wp::shape_t adj_0 = {};
    wp::int32 adj_1 = {};
    wp::int32 adj_2 = {};
    wp::shape_t adj_3 = {};
    wp::range_t adj_4 = {};
    wp::int32 adj_5 = {};
    wp::int32 adj_6 = {};
    wp::int32 adj_7 = {};
    wp::int32 adj_8 = {};
    wp::int32 adj_9 = {};
    wp::int32 adj_10 = {};
    wp::int32 adj_11 = {};
    wp::int32 adj_12 = {};
    //---------
    // forward
    // def count_color_group_sizes(                                                           <L 166>
    // for node_idx in range(node_colors.shape[0]):                                           <L 176>
    var_0 = &(var_node_colors.shape);
    var_3 = wp::load(var_0);
    var_2 = wp::extract(var_3, var_1);
    var_4 = wp::range(var_2);
    //---------
    // reverse
    var_4 = wp::iter_reverse(var_4);
    start_for_0:;
        if (iter_cmp(var_4) == 0) goto end_for_0;
        var_5 = wp::iter_next(var_4);
    	adj_6 = {};
    	adj_7 = {};
    	adj_8 = {};
    	adj_9 = {};
    	adj_10 = {};
    	adj_11 = {};
    	adj_12 = {};
        // node_color = node_colors[node_idx]                                                 <L 177>
        var_6 = wp::address(var_node_colors, var_5);
        var_8 = wp::load(var_6);
        var_7 = wp::copy(var_8);
        // group_sizes[node_color] = group_sizes[node_color] + 1                              <L 178>
        var_9 = wp::address(var_group_sizes, var_7);
        var_12 = wp::load(var_9);
        var_11 = wp::add(var_12, var_10);
        // wp::array_store(var_group_sizes, var_7, var_11);
        wp::adj_array_store(var_group_sizes, var_7, var_11, adj_group_sizes, adj_7, adj_11);
        wp::adj_add(var_12, var_10, adj_9, adj_10, adj_11);
        wp::adj_address(var_group_sizes, var_7, adj_group_sizes, adj_7, adj_9);
        // adj: group_sizes[node_color] = group_sizes[node_color] + 1                         <L 178>
        wp::adj_copy(var_8, adj_6, adj_7);
        wp::adj_address(var_node_colors, var_5, adj_node_colors, adj_5, adj_6);
        // adj: node_color = node_colors[node_idx]                                            <L 177>
    	goto start_for_0;
    end_for_0:;
    adj_node_colors.shape = adj_0;
    // adj: for node_idx in range(node_colors.shape[0]):                                      <L 176>
    // adj: def count_color_group_sizes(                                                      <L 166>
    return;
}



extern "C" {

// Python CPU entry points
WP_API void count_color_group_sizes_f50b6bb1_cpu_forward(
    wp::launch_bounds_t<1> *dim,
    wp_args_count_color_group_sizes_f50b6bb1 *_wp_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        count_color_group_sizes_f50b6bb1_cpu_kernel_forward(*dim, task_index, _wp_args);
    }
}

} // extern C



extern "C" {

WP_API void count_color_group_sizes_f50b6bb1_cpu_backward(
    wp::launch_bounds_t<1> *dim,
    wp_args_count_color_group_sizes_f50b6bb1 *_wp_args,
    wp_args_count_color_group_sizes_f50b6bb1 *_wp_adj_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        count_color_group_sizes_f50b6bb1_cpu_kernel_backward(*dim, task_index, _wp_args, _wp_adj_args);
    }
}

} // extern C

struct wp_args_fill_color_groups_8e16694b {
    wp::array_t<wp::int32> node_colors;
    wp::array_t<wp::int32> group_offsets;
    wp::array_t<wp::int32> group_fill_count;
    wp::array_t<wp::int32> color_groups_flatten;
};


void fill_color_groups_8e16694b_cpu_kernel_forward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_fill_color_groups_8e16694b *_wp_args)
{
    //---------
    // argument vars
    wp::array_t<wp::int32> var_node_colors = _wp_args->node_colors;
    wp::array_t<wp::int32> var_group_offsets = _wp_args->group_offsets;
    wp::array_t<wp::int32> var_group_fill_count = _wp_args->group_fill_count;
    wp::array_t<wp::int32> var_color_groups_flatten = _wp_args->color_groups_flatten;
    //---------
    // primal vars
    wp::shape_t* var_0;
    const wp::int32 var_1 = 0;
    wp::int32 var_2;
    wp::shape_t var_3;
    wp::range_t var_4;
    wp::int32 var_5;
    wp::int32* var_6;
    wp::int32 var_7;
    wp::int32 var_8;
    wp::int32* var_9;
    wp::int32 var_10;
    wp::int32 var_11;
    wp::int32* var_12;
    wp::int32 var_13;
    wp::int32 var_14;
    wp::int32 var_15;
    wp::int32 var_16;
    const wp::int32 var_17 = 1;
    wp::int32 var_18;
    //---------
    // forward
    // def fill_color_groups(                                                                 <L 182>
    // for node_idx in range(node_colors.shape[0]):                                           <L 194>
    var_0 = &(var_node_colors.shape);
    var_3 = wp::load(var_0);
    var_2 = wp::extract(var_3, var_1);
    var_4 = wp::range(var_2);
    start_for_0:;
        if (iter_cmp(var_4) == 0) goto end_for_0;
        var_5 = wp::iter_next(var_4);
        // node_color = node_colors[node_idx]                                                 <L 195>
        var_6 = wp::address(var_node_colors, var_5);
        var_8 = wp::load(var_6);
        var_7 = wp::copy(var_8);
        // group_offset = group_offsets[node_color]                                           <L 196>
        var_9 = wp::address(var_group_offsets, var_7);
        var_11 = wp::load(var_9);
        var_10 = wp::copy(var_11);
        // group_idx = group_fill_count[node_color]                                           <L 197>
        var_12 = wp::address(var_group_fill_count, var_7);
        var_14 = wp::load(var_12);
        var_13 = wp::copy(var_14);
        // color_groups_flatten[group_idx + group_offset] = wp.int32(node_idx)                <L 198>
        var_15 = wp::int32(var_5);
        var_16 = wp::add(var_13, var_10);
        wp::array_store(var_color_groups_flatten, var_16, var_15);
        // group_fill_count[node_color] = group_idx + 1                                       <L 200>
        var_18 = wp::add(var_13, var_17);
        wp::array_store(var_group_fill_count, var_7, var_18);
        goto start_for_0;
    end_for_0:;
}



void fill_color_groups_8e16694b_cpu_kernel_backward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_fill_color_groups_8e16694b *_wp_args,
    wp_args_fill_color_groups_8e16694b *_wp_adj_args)
{
    //---------
    // argument vars
    wp::array_t<wp::int32> var_node_colors = _wp_args->node_colors;
    wp::array_t<wp::int32> var_group_offsets = _wp_args->group_offsets;
    wp::array_t<wp::int32> var_group_fill_count = _wp_args->group_fill_count;
    wp::array_t<wp::int32> var_color_groups_flatten = _wp_args->color_groups_flatten;
    wp::array_t<wp::int32> adj_node_colors = _wp_adj_args->node_colors;
    wp::array_t<wp::int32> adj_group_offsets = _wp_adj_args->group_offsets;
    wp::array_t<wp::int32> adj_group_fill_count = _wp_adj_args->group_fill_count;
    wp::array_t<wp::int32> adj_color_groups_flatten = _wp_adj_args->color_groups_flatten;
    //---------
    // primal vars
    wp::shape_t* var_0;
    const wp::int32 var_1 = 0;
    wp::int32 var_2;
    wp::shape_t var_3;
    wp::range_t var_4;
    wp::int32 var_5;
    wp::int32* var_6;
    wp::int32 var_7;
    wp::int32 var_8;
    wp::int32* var_9;
    wp::int32 var_10;
    wp::int32 var_11;
    wp::int32* var_12;
    wp::int32 var_13;
    wp::int32 var_14;
    wp::int32 var_15;
    wp::int32 var_16;
    const wp::int32 var_17 = 1;
    wp::int32 var_18;
    //---------
    // dual vars
    wp::shape_t adj_0 = {};
    wp::int32 adj_1 = {};
    wp::int32 adj_2 = {};
    wp::shape_t adj_3 = {};
    wp::range_t adj_4 = {};
    wp::int32 adj_5 = {};
    wp::int32 adj_6 = {};
    wp::int32 adj_7 = {};
    wp::int32 adj_8 = {};
    wp::int32 adj_9 = {};
    wp::int32 adj_10 = {};
    wp::int32 adj_11 = {};
    wp::int32 adj_12 = {};
    wp::int32 adj_13 = {};
    wp::int32 adj_14 = {};
    wp::int32 adj_15 = {};
    wp::int32 adj_16 = {};
    wp::int32 adj_17 = {};
    wp::int32 adj_18 = {};
    //---------
    // forward
    // def fill_color_groups(                                                                 <L 182>
    // for node_idx in range(node_colors.shape[0]):                                           <L 194>
    var_0 = &(var_node_colors.shape);
    var_3 = wp::load(var_0);
    var_2 = wp::extract(var_3, var_1);
    var_4 = wp::range(var_2);
    //---------
    // reverse
    var_4 = wp::iter_reverse(var_4);
    start_for_0:;
        if (iter_cmp(var_4) == 0) goto end_for_0;
        var_5 = wp::iter_next(var_4);
    	adj_6 = {};
    	adj_7 = {};
    	adj_8 = {};
    	adj_9 = {};
    	adj_10 = {};
    	adj_11 = {};
    	adj_12 = {};
    	adj_13 = {};
    	adj_14 = {};
    	adj_15 = {};
    	adj_16 = {};
    	adj_17 = {};
    	adj_18 = {};
        // node_color = node_colors[node_idx]                                                 <L 195>
        var_6 = wp::address(var_node_colors, var_5);
        var_8 = wp::load(var_6);
        var_7 = wp::copy(var_8);
        // group_offset = group_offsets[node_color]                                           <L 196>
        var_9 = wp::address(var_group_offsets, var_7);
        var_11 = wp::load(var_9);
        var_10 = wp::copy(var_11);
        // group_idx = group_fill_count[node_color]                                           <L 197>
        var_12 = wp::address(var_group_fill_count, var_7);
        var_14 = wp::load(var_12);
        var_13 = wp::copy(var_14);
        // color_groups_flatten[group_idx + group_offset] = wp.int32(node_idx)                <L 198>
        var_15 = wp::int32(var_5);
        var_16 = wp::add(var_13, var_10);
        // wp::array_store(var_color_groups_flatten, var_16, var_15);
        // group_fill_count[node_color] = group_idx + 1                                       <L 200>
        var_18 = wp::add(var_13, var_17);
        // wp::array_store(var_group_fill_count, var_7, var_18);
        wp::adj_array_store(var_group_fill_count, var_7, var_18, adj_group_fill_count, adj_7, adj_18);
        wp::adj_add(var_13, var_17, adj_13, adj_17, adj_18);
        // adj: group_fill_count[node_color] = group_idx + 1                                  <L 200>
        wp::adj_array_store(var_color_groups_flatten, var_16, var_15, adj_color_groups_flatten, adj_16, adj_15);
        wp::adj_add(var_13, var_10, adj_13, adj_10, adj_16);
        // adj: color_groups_flatten[group_idx + group_offset] = wp.int32(node_idx)           <L 198>
        wp::adj_copy(var_14, adj_12, adj_13);
        wp::adj_address(var_group_fill_count, var_7, adj_group_fill_count, adj_7, adj_12);
        // adj: group_idx = group_fill_count[node_color]                                      <L 197>
        wp::adj_copy(var_11, adj_9, adj_10);
        wp::adj_address(var_group_offsets, var_7, adj_group_offsets, adj_7, adj_9);
        // adj: group_offset = group_offsets[node_color]                                      <L 196>
        wp::adj_copy(var_8, adj_6, adj_7);
        wp::adj_address(var_node_colors, var_5, adj_node_colors, adj_5, adj_6);
        // adj: node_color = node_colors[node_idx]                                            <L 195>
    	goto start_for_0;
    end_for_0:;
    adj_node_colors.shape = adj_0;
    // adj: for node_idx in range(node_colors.shape[0]):                                      <L 194>
    // adj: def fill_color_groups(                                                            <L 182>
    return;
}



extern "C" {

// Python CPU entry points
WP_API void fill_color_groups_8e16694b_cpu_forward(
    wp::launch_bounds_t<1> *dim,
    wp_args_fill_color_groups_8e16694b *_wp_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        fill_color_groups_8e16694b_cpu_kernel_forward(*dim, task_index, _wp_args);
    }
}

} // extern C



extern "C" {

WP_API void fill_color_groups_8e16694b_cpu_backward(
    wp::launch_bounds_t<1> *dim,
    wp_args_fill_color_groups_8e16694b *_wp_args,
    wp_args_fill_color_groups_8e16694b *_wp_adj_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        fill_color_groups_8e16694b_cpu_kernel_backward(*dim, task_index, _wp_args, _wp_adj_args);
    }
}

} // extern C

