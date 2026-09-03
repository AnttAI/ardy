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


struct PickingState_096ac041
{
    wp::vec_t<3, wp::float32> picked_point_local;
    wp::vec_t<3, wp::float32> picked_point_world;
    wp::vec_t<3, wp::float32> picking_target_world;
    wp::float32 pick_stiffness;
    wp::float32 pick_damping;
    wp::float32 pick_max_acceleration;


    PickingState_096ac041() = default;
    CUDA_CALLABLE PickingState_096ac041(wp::vec_t<3, wp::float32> const& picked_point_local,
    wp::vec_t<3, wp::float32> const& picked_point_world = {},
    wp::vec_t<3, wp::float32> const& picking_target_world = {},
    wp::float32 const& pick_stiffness = {},
    wp::float32 const& pick_damping = {},
    wp::float32 const& pick_max_acceleration = {})
        : picked_point_local{picked_point_local}
        , picked_point_world{picked_point_world}
        , picking_target_world{picking_target_world}
        , pick_stiffness{pick_stiffness}
        , pick_damping{pick_damping}
        , pick_max_acceleration{pick_max_acceleration}

    {
    }

    CUDA_CALLABLE PickingState_096ac041& operator += (const PickingState_096ac041& rhs)
    {    picked_point_local += rhs.picked_point_local;
    picked_point_world += rhs.picked_point_world;
    picking_target_world += rhs.picking_target_world;
    pick_stiffness += rhs.pick_stiffness;
    pick_damping += rhs.pick_damping;
    pick_max_acceleration += rhs.pick_max_acceleration;

        return *this;}

};

static CUDA_CALLABLE void adj_PickingState_096ac041(wp::vec_t<3, wp::float32> const&,
    wp::vec_t<3, wp::float32> const&,
    wp::vec_t<3, wp::float32> const&,
    wp::float32 const&,
    wp::float32 const&,
    wp::float32 const&,
    wp::vec_t<3, wp::float32> & adj_picked_point_local,
    wp::vec_t<3, wp::float32> & adj_picked_point_world,
    wp::vec_t<3, wp::float32> & adj_picking_target_world,
    wp::float32 & adj_pick_stiffness,
    wp::float32 & adj_pick_damping,
    wp::float32 & adj_pick_max_acceleration,
    PickingState_096ac041 & adj_ret)
{
    adj_picked_point_local += adj_ret.picked_point_local;
    adj_picked_point_world += adj_ret.picked_point_world;
    adj_picking_target_world += adj_ret.picking_target_world;
    adj_pick_stiffness += adj_ret.pick_stiffness;
    adj_pick_damping += adj_ret.pick_damping;
    adj_pick_max_acceleration += adj_ret.pick_max_acceleration;
}

// Required when compiling adjoints.
CUDA_CALLABLE PickingState_096ac041 add(const PickingState_096ac041& a, const PickingState_096ac041& b)
{
    return PickingState_096ac041();
}

CUDA_CALLABLE void adj_atomic_add(PickingState_096ac041* p, PickingState_096ac041 t)
{
    wp::adj_atomic_add(&p->picked_point_local, t.picked_point_local);
    wp::adj_atomic_add(&p->picked_point_world, t.picked_point_world);
    wp::adj_atomic_add(&p->picking_target_world, t.picking_target_world);
    wp::adj_atomic_add(&p->pick_stiffness, t.pick_stiffness);
    wp::adj_atomic_add(&p->pick_damping, t.pick_damping);
    wp::adj_atomic_add(&p->pick_max_acceleration, t.pick_max_acceleration);
}




// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/math/__init__.py:235
static void orthonormal_basis_0(
    wp::vec_t<3, wp::float32> var_n,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    const wp::int32 var_2 = 2;
    wp::float32 var_3;
    const wp::float32 var_4 = 0.0;
    bool var_5;
    const wp::float32 var_6 = 1.0;
    const wp::float32 var_7 = 1.0;
    const wp::int32 var_8 = 2;
    wp::float32 var_9;
    wp::float32 var_10;
    wp::float32 var_11;
    const wp::int32 var_12 = 0;
    wp::float32 var_13;
    const wp::int32 var_14 = 1;
    wp::float32 var_15;
    wp::float32 var_16;
    wp::float32 var_17;
    const wp::float32 var_18 = 1.0;
    const wp::int32 var_19 = 0;
    wp::float32 var_20;
    const wp::int32 var_21 = 0;
    wp::float32 var_22;
    wp::float32 var_23;
    wp::float32 var_24;
    wp::float32 var_25;
    const wp::int32 var_26 = 0;
    wp::float32 var_27;
    const wp::int32 var_28 = 1;
    const wp::int32 var_29 = 0;
    wp::float32 var_30;
    const wp::int32 var_31 = 2;
    const wp::int32 var_32 = 0;
    const wp::int32 var_33 = 1;
    wp::float32 var_34;
    const wp::int32 var_35 = 1;
    wp::float32 var_36;
    wp::float32 var_37;
    wp::float32 var_38;
    const wp::float32 var_39 = 1.0;
    wp::float32 var_40;
    const wp::int32 var_41 = 1;
    const wp::int32 var_42 = 1;
    wp::float32 var_43;
    wp::float32 var_44;
    const wp::int32 var_45 = 2;
    const wp::float32 var_46 = 1.0;
    const wp::float32 var_47 = 1.0;
    const wp::int32 var_48 = 2;
    wp::float32 var_49;
    wp::float32 var_50;
    wp::float32 var_51;
    const wp::int32 var_52 = 0;
    wp::float32 var_53;
    wp::float32 var_54;
    const wp::int32 var_55 = 1;
    wp::float32 var_56;
    wp::float32 var_57;
    wp::float32 var_58;
    const wp::float32 var_59 = 1.0;
    const wp::int32 var_60 = 0;
    wp::float32 var_61;
    const wp::int32 var_62 = 0;
    wp::float32 var_63;
    wp::float32 var_64;
    wp::float32 var_65;
    wp::float32 var_66;
    const wp::int32 var_67 = 0;
    const wp::int32 var_68 = 1;
    const wp::int32 var_69 = 0;
    wp::float32 var_70;
    wp::float32 var_71;
    const wp::int32 var_72 = 2;
    const wp::int32 var_73 = 0;
    const wp::float32 var_74 = 1.0;
    const wp::int32 var_75 = 1;
    wp::float32 var_76;
    const wp::int32 var_77 = 1;
    wp::float32 var_78;
    wp::float32 var_79;
    wp::float32 var_80;
    wp::float32 var_81;
    const wp::int32 var_82 = 1;
    const wp::int32 var_83 = 1;
    wp::float32 var_84;
    wp::float32 var_85;
    const wp::int32 var_86 = 2;
    wp::float32 var_87;
    wp::float32 var_88;
    //---------
    // forward
    // def orthonormal_basis(n: wp.vec3):                                                     <L 236>
    // b1 = wp.vec3()                                                                         <L 252>
    var_0 = wp::vec_t<3, wp::float32>();
    // b2 = wp.vec3()                                                                         <L 253>
    var_1 = wp::vec_t<3, wp::float32>();
    // if n[2] < 0.0:                                                                         <L 254>
    var_3 = wp::extract(var_n, var_2);
    var_5 = (var_3 < var_4);
    if (var_5) {
        // a = 1.0 / (1.0 - n[2])                                                             <L 255>
        var_9 = wp::extract(var_n, var_8);
        var_10 = wp::sub(var_7, var_9);
        var_11 = wp::div(var_6, var_10);
        // b = n[0] * n[1] * a                                                                <L 256>
        var_13 = wp::extract(var_n, var_12);
        var_15 = wp::extract(var_n, var_14);
        var_16 = wp::mul(var_13, var_15);
        var_17 = wp::mul(var_16, var_11);
        // b1[0] = 1.0 - n[0] * n[0] * a                                                      <L 257>
        var_20 = wp::extract(var_n, var_19);
        var_22 = wp::extract(var_n, var_21);
        var_23 = wp::mul(var_20, var_22);
        var_24 = wp::mul(var_23, var_11);
        var_25 = wp::sub(var_18, var_24);
        wp::assign_inplace(var_0, var_26, var_25);
        // b1[1] = -b                                                                         <L 258>
        var_27 = wp::neg(var_17);
        wp::assign_inplace(var_0, var_28, var_27);
        // b1[2] = n[0]                                                                       <L 259>
        var_30 = wp::extract(var_n, var_29);
        wp::assign_inplace(var_0, var_31, var_30);
        // b2[0] = b                                                                          <L 261>
        wp::assign_inplace(var_1, var_32, var_17);
        // b2[1] = n[1] * n[1] * a - 1.0                                                      <L 262>
        var_34 = wp::extract(var_n, var_33);
        var_36 = wp::extract(var_n, var_35);
        var_37 = wp::mul(var_34, var_36);
        var_38 = wp::mul(var_37, var_11);
        var_40 = wp::sub(var_38, var_39);
        wp::assign_inplace(var_1, var_41, var_40);
        // b2[2] = -n[1]                                                                      <L 263>
        var_43 = wp::extract(var_n, var_42);
        var_44 = wp::neg(var_43);
        wp::assign_inplace(var_1, var_45, var_44);
    }
    if (!var_5) {
        // a = 1.0 / (1.0 + n[2])                                                             <L 265>
        var_49 = wp::extract(var_n, var_48);
        var_50 = wp::add(var_47, var_49);
        var_51 = wp::div(var_46, var_50);
        // b = -n[0] * n[1] * a                                                               <L 266>
        var_53 = wp::extract(var_n, var_52);
        var_54 = wp::neg(var_53);
        var_56 = wp::extract(var_n, var_55);
        var_57 = wp::mul(var_54, var_56);
        var_58 = wp::mul(var_57, var_51);
        // b1[0] = 1.0 - n[0] * n[0] * a                                                      <L 267>
        var_61 = wp::extract(var_n, var_60);
        var_63 = wp::extract(var_n, var_62);
        var_64 = wp::mul(var_61, var_63);
        var_65 = wp::mul(var_64, var_51);
        var_66 = wp::sub(var_59, var_65);
        wp::assign_inplace(var_0, var_67, var_66);
        // b1[1] = b                                                                          <L 268>
        wp::assign_inplace(var_0, var_68, var_58);
        // b1[2] = -n[0]                                                                      <L 269>
        var_70 = wp::extract(var_n, var_69);
        var_71 = wp::neg(var_70);
        wp::assign_inplace(var_0, var_72, var_71);
        // b2[0] = b                                                                          <L 271>
        wp::assign_inplace(var_1, var_73, var_58);
        // b2[1] = 1.0 - n[1] * n[1] * a                                                      <L 272>
        var_76 = wp::extract(var_n, var_75);
        var_78 = wp::extract(var_n, var_77);
        var_79 = wp::mul(var_76, var_78);
        var_80 = wp::mul(var_79, var_51);
        var_81 = wp::sub(var_74, var_80);
        wp::assign_inplace(var_1, var_82, var_81);
        // b2[2] = -n[1]                                                                      <L 273>
        var_84 = wp::extract(var_n, var_83);
        var_85 = wp::neg(var_84);
        wp::assign_inplace(var_1, var_86, var_85);
    }
    var_87 = wp::where(var_5, var_11, var_51);
    var_88 = wp::where(var_5, var_17, var_58);
    // return b1, b2                                                                          <L 275>
    ret_0 = var_0;
    ret_1 = var_1;
    return;
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/viewer/kernels.py:896
static wp::vec_t<3, wp::float32> depth_to_color_0(
    wp::float32 var_depth,
    wp::float32 var_min_depth,
    wp::float32 var_max_depth)
{
    //---------
    // primal vars
    wp::float32 var_0;
    wp::float32 var_1;
    const wp::float32 var_2 = 1e-08;
    wp::float32 var_3;
    wp::float32 var_4;
    const wp::float32 var_5 = 0.0;
    const wp::float32 var_6 = 1.0;
    wp::float32 var_7;
    const wp::float32 var_8 = 0.25;
    bool var_9;
    const wp::float32 var_10 = 0.25;
    wp::float32 var_11;
    const wp::float32 var_12 = 0.0;
    const wp::float32 var_13 = 1.0;
    wp::vec_t<3, wp::float32> var_14;
    const wp::float32 var_15 = 0.5;
    bool var_16;
    const wp::float32 var_17 = 0.25;
    wp::float32 var_18;
    const wp::float32 var_19 = 0.25;
    wp::float32 var_20;
    const wp::float32 var_21 = 0.0;
    const wp::float32 var_22 = 1.0;
    const wp::float32 var_23 = 1.0;
    wp::float32 var_24;
    wp::vec_t<3, wp::float32> var_25;
    const wp::float32 var_26 = 0.75;
    bool var_27;
    const wp::float32 var_28 = 0.5;
    wp::float32 var_29;
    const wp::float32 var_30 = 0.25;
    wp::float32 var_31;
    const wp::float32 var_32 = 1.0;
    const wp::float32 var_33 = 0.0;
    wp::vec_t<3, wp::float32> var_34;
    const wp::float32 var_35 = 0.75;
    wp::float32 var_36;
    const wp::float32 var_37 = 0.25;
    wp::float32 var_38;
    const wp::float32 var_39 = 1.0;
    const wp::float32 var_40 = 1.0;
    wp::float32 var_41;
    const wp::float32 var_42 = 0.0;
    wp::vec_t<3, wp::float32> var_43;
    wp::float32 var_44;
    wp::float32 var_45;
    wp::float32 var_46;
    //---------
    // forward
    // def depth_to_color(depth: float, min_depth: float, max_depth: float) -> wp.vec3:       <L 897>
    // t = wp.clamp((depth - min_depth) / (max_depth - min_depth + 1e-8), 0.0, 1.0)           <L 900>
    var_0 = wp::sub(var_depth, var_min_depth);
    var_1 = wp::sub(var_max_depth, var_min_depth);
    var_3 = wp::add(var_1, var_2);
    var_4 = wp::div(var_0, var_3);
    var_7 = wp::clamp(var_4, var_5, var_6);
    // if t < 0.25:                                                                           <L 902>
    var_9 = (var_7 < var_8);
    if (var_9) {
        // s = t / 0.25                                                                       <L 903>
        var_11 = wp::div(var_7, var_10);
        // return wp.vec3(0.0, s, 1.0)                                                        <L 904>
        var_14 = wp::vec_t<3, wp::float32>(var_12, var_11, var_13);
        return var_14;
    }
    if (!var_9) {
        // elif t < 0.5:                                                                      <L 905>
        var_16 = (var_7 < var_15);
        if (var_16) {
            // s = (t - 0.25) / 0.25                                                          <L 906>
            var_18 = wp::sub(var_7, var_17);
            var_20 = wp::div(var_18, var_19);
            // return wp.vec3(0.0, 1.0, 1.0 - s)                                              <L 907>
            var_24 = wp::sub(var_23, var_20);
            var_25 = wp::vec_t<3, wp::float32>(var_21, var_22, var_24);
            return var_25;
        }
        if (!var_16) {
            // elif t < 0.75:                                                                 <L 908>
            var_27 = (var_7 < var_26);
            if (var_27) {
                // s = (t - 0.5) / 0.25                                                       <L 909>
                var_29 = wp::sub(var_7, var_28);
                var_31 = wp::div(var_29, var_30);
                // return wp.vec3(s, 1.0, 0.0)                                                <L 910>
                var_34 = wp::vec_t<3, wp::float32>(var_31, var_32, var_33);
                return var_34;
            }
            if (!var_27) {
                // s = (t - 0.75) / 0.25                                                      <L 912>
                var_36 = wp::sub(var_7, var_35);
                var_38 = wp::div(var_36, var_37);
                // return wp.vec3(1.0, 1.0 - s, 0.0)                                          <L 913>
                var_41 = wp::sub(var_40, var_38);
                var_43 = wp::vec_t<3, wp::float32>(var_39, var_41, var_42);
                return var_43;
            }
            var_44 = wp::where(var_27, var_31, var_38);
        }
        var_45 = wp::where(var_16, var_20, var_44);
    }
    var_46 = wp::where(var_9, var_11, var_45);
    return {};
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/viewer/kernels.py:327
static wp::quat_t<wp::float32> _quat_from_normal_z_0(
    wp::vec_t<3, wp::float32> var_normal)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::mat_t<3, 3, wp::float32> var_3;
    wp::quat_t<wp::float32> var_4;
    //---------
    // forward
    // def _quat_from_normal_z(normal: wp.vec3) -> wp.quat:                                   <L 328>
    // n = wp.normalize(normal)                                                               <L 334>
    var_0 = wp::normalize(var_normal);
    // t1, t2 = orthonormal_basis(n)                                                          <L 335>
    orthonormal_basis_0(var_0, var_1, var_2);
    // R = wp.matrix_from_cols(t1, t2, n)                                                     <L 336>
    var_3 = wp::matrix_from_cols<wp::float32>(var_1, var_2, var_0);
    // return wp.quat_from_matrix(R)                                                          <L 337>
    var_4 = wp::quat_from_matrix(var_3);
    return var_4;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/warp/_src/math.py:131
static wp::vec_t<3, wp::float32> velocity_at_point_0(
    wp::vec_t<6, wp::float32> var_qd,
    wp::vec_t<3, wp::float32> var_r)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    //---------
    // forward
    // def velocity_at_point(qd: wp.spatial_vector, r: wp.vec3) -> wp.vec3:                   <L 132>
    // return wp.spatial_bottom(qd) + wp.cross(wp.spatial_top(qd), r)                         <L 148>
    var_0 = wp::spatial_bottom(var_qd);
    var_1 = wp::spatial_top(var_qd);
    var_2 = wp::cross(var_1, var_r);
    var_3 = wp::add(var_0, var_2);
    return var_3;
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/math/spatial.py:53
static wp::vec_t<3, wp::float32> velocity_at_point_1(
    wp::vec_t<6, wp::float32> var_qd,
    wp::vec_t<3, wp::float32> var_r)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<6, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    //---------
    // forward
    // def velocity_at_point(qd: wp.spatial_vector, r: wp.vec3) -> wp.vec3:                   <L 54>
    // qd_wp = wp.spatial_vector(wp.spatial_bottom(qd), wp.spatial_top(qd))                   <L 77>
    var_0 = wp::spatial_bottom(var_qd);
    var_1 = wp::spatial_top(var_qd);
    var_2 = wp::vec_t<6, wp::float32>(var_0, var_1);
    // return wp.velocity_at_point(qd_wp, r)                                                  <L 78>
    var_3 = velocity_at_point_0(var_2, var_r);
    return var_3;
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/math/__init__.py:235
static void adj_orthonormal_basis_0(
    wp::vec_t<3, wp::float32> var_n,
    wp::vec_t<3, wp::float32> & ret_0,
    wp::vec_t<3, wp::float32> & ret_1,
    wp::vec_t<3, wp::float32> & adj_n,
    wp::vec_t<3, wp::float32> & adj_ret_0,
    wp::vec_t<3, wp::float32> & adj_ret_1)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    const wp::int32 var_2 = 2;
    wp::float32 var_3;
    const wp::float32 var_4 = 0.0;
    bool var_5;
    const wp::float32 var_6 = 1.0;
    const wp::float32 var_7 = 1.0;
    const wp::int32 var_8 = 2;
    wp::float32 var_9;
    wp::float32 var_10;
    wp::float32 var_11;
    const wp::int32 var_12 = 0;
    wp::float32 var_13;
    const wp::int32 var_14 = 1;
    wp::float32 var_15;
    wp::float32 var_16;
    wp::float32 var_17;
    const wp::float32 var_18 = 1.0;
    const wp::int32 var_19 = 0;
    wp::float32 var_20;
    const wp::int32 var_21 = 0;
    wp::float32 var_22;
    wp::float32 var_23;
    wp::float32 var_24;
    wp::float32 var_25;
    const wp::int32 var_26 = 0;
    wp::float32 var_27;
    const wp::int32 var_28 = 1;
    const wp::int32 var_29 = 0;
    wp::float32 var_30;
    const wp::int32 var_31 = 2;
    const wp::int32 var_32 = 0;
    const wp::int32 var_33 = 1;
    wp::float32 var_34;
    const wp::int32 var_35 = 1;
    wp::float32 var_36;
    wp::float32 var_37;
    wp::float32 var_38;
    const wp::float32 var_39 = 1.0;
    wp::float32 var_40;
    const wp::int32 var_41 = 1;
    const wp::int32 var_42 = 1;
    wp::float32 var_43;
    wp::float32 var_44;
    const wp::int32 var_45 = 2;
    const wp::float32 var_46 = 1.0;
    const wp::float32 var_47 = 1.0;
    const wp::int32 var_48 = 2;
    wp::float32 var_49;
    wp::float32 var_50;
    wp::float32 var_51;
    const wp::int32 var_52 = 0;
    wp::float32 var_53;
    wp::float32 var_54;
    const wp::int32 var_55 = 1;
    wp::float32 var_56;
    wp::float32 var_57;
    wp::float32 var_58;
    const wp::float32 var_59 = 1.0;
    const wp::int32 var_60 = 0;
    wp::float32 var_61;
    const wp::int32 var_62 = 0;
    wp::float32 var_63;
    wp::float32 var_64;
    wp::float32 var_65;
    wp::float32 var_66;
    const wp::int32 var_67 = 0;
    const wp::int32 var_68 = 1;
    const wp::int32 var_69 = 0;
    wp::float32 var_70;
    wp::float32 var_71;
    const wp::int32 var_72 = 2;
    const wp::int32 var_73 = 0;
    const wp::float32 var_74 = 1.0;
    const wp::int32 var_75 = 1;
    wp::float32 var_76;
    const wp::int32 var_77 = 1;
    wp::float32 var_78;
    wp::float32 var_79;
    wp::float32 var_80;
    wp::float32 var_81;
    const wp::int32 var_82 = 1;
    const wp::int32 var_83 = 1;
    wp::float32 var_84;
    wp::float32 var_85;
    const wp::int32 var_86 = 2;
    wp::float32 var_87;
    wp::float32 var_88;
    //---------
    // dual vars
    wp::vec_t<3, wp::float32> adj_0 = {};
    wp::vec_t<3, wp::float32> adj_1 = {};
    wp::int32 adj_2 = {};
    wp::float32 adj_3 = {};
    wp::float32 adj_4 = {};
    bool adj_5 = {};
    wp::float32 adj_6 = {};
    wp::float32 adj_7 = {};
    wp::int32 adj_8 = {};
    wp::float32 adj_9 = {};
    wp::float32 adj_10 = {};
    wp::float32 adj_11 = {};
    wp::int32 adj_12 = {};
    wp::float32 adj_13 = {};
    wp::int32 adj_14 = {};
    wp::float32 adj_15 = {};
    wp::float32 adj_16 = {};
    wp::float32 adj_17 = {};
    wp::float32 adj_18 = {};
    wp::int32 adj_19 = {};
    wp::float32 adj_20 = {};
    wp::int32 adj_21 = {};
    wp::float32 adj_22 = {};
    wp::float32 adj_23 = {};
    wp::float32 adj_24 = {};
    wp::float32 adj_25 = {};
    wp::int32 adj_26 = {};
    wp::float32 adj_27 = {};
    wp::int32 adj_28 = {};
    wp::int32 adj_29 = {};
    wp::float32 adj_30 = {};
    wp::int32 adj_31 = {};
    wp::int32 adj_32 = {};
    wp::int32 adj_33 = {};
    wp::float32 adj_34 = {};
    wp::int32 adj_35 = {};
    wp::float32 adj_36 = {};
    wp::float32 adj_37 = {};
    wp::float32 adj_38 = {};
    wp::float32 adj_39 = {};
    wp::float32 adj_40 = {};
    wp::int32 adj_41 = {};
    wp::int32 adj_42 = {};
    wp::float32 adj_43 = {};
    wp::float32 adj_44 = {};
    wp::int32 adj_45 = {};
    wp::float32 adj_46 = {};
    wp::float32 adj_47 = {};
    wp::int32 adj_48 = {};
    wp::float32 adj_49 = {};
    wp::float32 adj_50 = {};
    wp::float32 adj_51 = {};
    wp::int32 adj_52 = {};
    wp::float32 adj_53 = {};
    wp::float32 adj_54 = {};
    wp::int32 adj_55 = {};
    wp::float32 adj_56 = {};
    wp::float32 adj_57 = {};
    wp::float32 adj_58 = {};
    wp::float32 adj_59 = {};
    wp::int32 adj_60 = {};
    wp::float32 adj_61 = {};
    wp::int32 adj_62 = {};
    wp::float32 adj_63 = {};
    wp::float32 adj_64 = {};
    wp::float32 adj_65 = {};
    wp::float32 adj_66 = {};
    wp::int32 adj_67 = {};
    wp::int32 adj_68 = {};
    wp::int32 adj_69 = {};
    wp::float32 adj_70 = {};
    wp::float32 adj_71 = {};
    wp::int32 adj_72 = {};
    wp::int32 adj_73 = {};
    wp::float32 adj_74 = {};
    wp::int32 adj_75 = {};
    wp::float32 adj_76 = {};
    wp::int32 adj_77 = {};
    wp::float32 adj_78 = {};
    wp::float32 adj_79 = {};
    wp::float32 adj_80 = {};
    wp::float32 adj_81 = {};
    wp::int32 adj_82 = {};
    wp::int32 adj_83 = {};
    wp::float32 adj_84 = {};
    wp::float32 adj_85 = {};
    wp::int32 adj_86 = {};
    wp::float32 adj_87 = {};
    wp::float32 adj_88 = {};
    //---------
    // forward
    // def orthonormal_basis(n: wp.vec3):                                                     <L 236>
    // b1 = wp.vec3()                                                                         <L 252>
    var_0 = wp::vec_t<3, wp::float32>();
    // b2 = wp.vec3()                                                                         <L 253>
    var_1 = wp::vec_t<3, wp::float32>();
    // if n[2] < 0.0:                                                                         <L 254>
    var_3 = wp::extract(var_n, var_2);
    var_5 = (var_3 < var_4);
    if (var_5) {
        // a = 1.0 / (1.0 - n[2])                                                             <L 255>
        var_9 = wp::extract(var_n, var_8);
        var_10 = wp::sub(var_7, var_9);
        var_11 = wp::div(var_6, var_10);
        // b = n[0] * n[1] * a                                                                <L 256>
        var_13 = wp::extract(var_n, var_12);
        var_15 = wp::extract(var_n, var_14);
        var_16 = wp::mul(var_13, var_15);
        var_17 = wp::mul(var_16, var_11);
        // b1[0] = 1.0 - n[0] * n[0] * a                                                      <L 257>
        var_20 = wp::extract(var_n, var_19);
        var_22 = wp::extract(var_n, var_21);
        var_23 = wp::mul(var_20, var_22);
        var_24 = wp::mul(var_23, var_11);
        var_25 = wp::sub(var_18, var_24);
        wp::assign_inplace(var_0, var_26, var_25);
        // b1[1] = -b                                                                         <L 258>
        var_27 = wp::neg(var_17);
        wp::assign_inplace(var_0, var_28, var_27);
        // b1[2] = n[0]                                                                       <L 259>
        var_30 = wp::extract(var_n, var_29);
        wp::assign_inplace(var_0, var_31, var_30);
        // b2[0] = b                                                                          <L 261>
        wp::assign_inplace(var_1, var_32, var_17);
        // b2[1] = n[1] * n[1] * a - 1.0                                                      <L 262>
        var_34 = wp::extract(var_n, var_33);
        var_36 = wp::extract(var_n, var_35);
        var_37 = wp::mul(var_34, var_36);
        var_38 = wp::mul(var_37, var_11);
        var_40 = wp::sub(var_38, var_39);
        wp::assign_inplace(var_1, var_41, var_40);
        // b2[2] = -n[1]                                                                      <L 263>
        var_43 = wp::extract(var_n, var_42);
        var_44 = wp::neg(var_43);
        wp::assign_inplace(var_1, var_45, var_44);
    }
    if (!var_5) {
        // a = 1.0 / (1.0 + n[2])                                                             <L 265>
        var_49 = wp::extract(var_n, var_48);
        var_50 = wp::add(var_47, var_49);
        var_51 = wp::div(var_46, var_50);
        // b = -n[0] * n[1] * a                                                               <L 266>
        var_53 = wp::extract(var_n, var_52);
        var_54 = wp::neg(var_53);
        var_56 = wp::extract(var_n, var_55);
        var_57 = wp::mul(var_54, var_56);
        var_58 = wp::mul(var_57, var_51);
        // b1[0] = 1.0 - n[0] * n[0] * a                                                      <L 267>
        var_61 = wp::extract(var_n, var_60);
        var_63 = wp::extract(var_n, var_62);
        var_64 = wp::mul(var_61, var_63);
        var_65 = wp::mul(var_64, var_51);
        var_66 = wp::sub(var_59, var_65);
        wp::assign_inplace(var_0, var_67, var_66);
        // b1[1] = b                                                                          <L 268>
        wp::assign_inplace(var_0, var_68, var_58);
        // b1[2] = -n[0]                                                                      <L 269>
        var_70 = wp::extract(var_n, var_69);
        var_71 = wp::neg(var_70);
        wp::assign_inplace(var_0, var_72, var_71);
        // b2[0] = b                                                                          <L 271>
        wp::assign_inplace(var_1, var_73, var_58);
        // b2[1] = 1.0 - n[1] * n[1] * a                                                      <L 272>
        var_76 = wp::extract(var_n, var_75);
        var_78 = wp::extract(var_n, var_77);
        var_79 = wp::mul(var_76, var_78);
        var_80 = wp::mul(var_79, var_51);
        var_81 = wp::sub(var_74, var_80);
        wp::assign_inplace(var_1, var_82, var_81);
        // b2[2] = -n[1]                                                                      <L 273>
        var_84 = wp::extract(var_n, var_83);
        var_85 = wp::neg(var_84);
        wp::assign_inplace(var_1, var_86, var_85);
    }
    var_87 = wp::where(var_5, var_11, var_51);
    var_88 = wp::where(var_5, var_17, var_58);
    // return b1, b2                                                                          <L 275>
    ret_0 = var_0;
    ret_1 = var_1;
    goto label0;
    //---------
    // reverse
    label0:;
    adj_1 += adj_ret_1;
    adj_0 += adj_ret_0;
    // adj: return b1, b2                                                                     <L 275>
    wp::adj_where(var_5, var_17, var_58, adj_5, adj_17, adj_58, adj_88);
    wp::adj_where(var_5, var_11, var_51, adj_5, adj_11, adj_51, adj_87);
    if (!var_5) {
        wp::adj_assign_inplace(var_1, var_86, var_85, adj_1, adj_86, adj_85);
        wp::adj_neg(var_84, adj_84, adj_85);
        wp::adj_extract(var_n, var_83, adj_n, adj_83, adj_84);
        // adj: b2[2] = -n[1]                                                                 <L 273>
        wp::adj_assign_inplace(var_1, var_82, var_81, adj_1, adj_82, adj_81);
        wp::adj_sub(var_74, var_80, adj_74, adj_80, adj_81);
        wp::adj_mul(var_79, var_51, adj_79, adj_51, adj_80);
        wp::adj_mul(var_76, var_78, adj_76, adj_78, adj_79);
        wp::adj_extract(var_n, var_77, adj_n, adj_77, adj_78);
        wp::adj_extract(var_n, var_75, adj_n, adj_75, adj_76);
        // adj: b2[1] = 1.0 - n[1] * n[1] * a                                                 <L 272>
        wp::adj_assign_inplace(var_1, var_73, var_58, adj_1, adj_73, adj_58);
        // adj: b2[0] = b                                                                     <L 271>
        wp::adj_assign_inplace(var_0, var_72, var_71, adj_0, adj_72, adj_71);
        wp::adj_neg(var_70, adj_70, adj_71);
        wp::adj_extract(var_n, var_69, adj_n, adj_69, adj_70);
        // adj: b1[2] = -n[0]                                                                 <L 269>
        wp::adj_assign_inplace(var_0, var_68, var_58, adj_0, adj_68, adj_58);
        // adj: b1[1] = b                                                                     <L 268>
        wp::adj_assign_inplace(var_0, var_67, var_66, adj_0, adj_67, adj_66);
        wp::adj_sub(var_59, var_65, adj_59, adj_65, adj_66);
        wp::adj_mul(var_64, var_51, adj_64, adj_51, adj_65);
        wp::adj_mul(var_61, var_63, adj_61, adj_63, adj_64);
        wp::adj_extract(var_n, var_62, adj_n, adj_62, adj_63);
        wp::adj_extract(var_n, var_60, adj_n, adj_60, adj_61);
        // adj: b1[0] = 1.0 - n[0] * n[0] * a                                                 <L 267>
        wp::adj_mul(var_57, var_51, adj_57, adj_51, adj_58);
        wp::adj_mul(var_54, var_56, adj_54, adj_56, adj_57);
        wp::adj_extract(var_n, var_55, adj_n, adj_55, adj_56);
        wp::adj_neg(var_53, adj_53, adj_54);
        wp::adj_extract(var_n, var_52, adj_n, adj_52, adj_53);
        // adj: b = -n[0] * n[1] * a                                                          <L 266>
        wp::adj_div(var_46, var_50, var_51, adj_46, adj_50, adj_51);
        wp::adj_add(var_47, var_49, adj_47, adj_49, adj_50);
        wp::adj_extract(var_n, var_48, adj_n, adj_48, adj_49);
        // adj: a = 1.0 / (1.0 + n[2])                                                        <L 265>
    }
    if (var_5) {
        wp::adj_assign_inplace(var_1, var_45, var_44, adj_1, adj_45, adj_44);
        wp::adj_neg(var_43, adj_43, adj_44);
        wp::adj_extract(var_n, var_42, adj_n, adj_42, adj_43);
        // adj: b2[2] = -n[1]                                                                 <L 263>
        wp::adj_assign_inplace(var_1, var_41, var_40, adj_1, adj_41, adj_40);
        wp::adj_sub(var_38, var_39, adj_38, adj_39, adj_40);
        wp::adj_mul(var_37, var_11, adj_37, adj_11, adj_38);
        wp::adj_mul(var_34, var_36, adj_34, adj_36, adj_37);
        wp::adj_extract(var_n, var_35, adj_n, adj_35, adj_36);
        wp::adj_extract(var_n, var_33, adj_n, adj_33, adj_34);
        // adj: b2[1] = n[1] * n[1] * a - 1.0                                                 <L 262>
        wp::adj_assign_inplace(var_1, var_32, var_17, adj_1, adj_32, adj_17);
        // adj: b2[0] = b                                                                     <L 261>
        wp::adj_assign_inplace(var_0, var_31, var_30, adj_0, adj_31, adj_30);
        wp::adj_extract(var_n, var_29, adj_n, adj_29, adj_30);
        // adj: b1[2] = n[0]                                                                  <L 259>
        wp::adj_assign_inplace(var_0, var_28, var_27, adj_0, adj_28, adj_27);
        wp::adj_neg(var_17, adj_17, adj_27);
        // adj: b1[1] = -b                                                                    <L 258>
        wp::adj_assign_inplace(var_0, var_26, var_25, adj_0, adj_26, adj_25);
        wp::adj_sub(var_18, var_24, adj_18, adj_24, adj_25);
        wp::adj_mul(var_23, var_11, adj_23, adj_11, adj_24);
        wp::adj_mul(var_20, var_22, adj_20, adj_22, adj_23);
        wp::adj_extract(var_n, var_21, adj_n, adj_21, adj_22);
        wp::adj_extract(var_n, var_19, adj_n, adj_19, adj_20);
        // adj: b1[0] = 1.0 - n[0] * n[0] * a                                                 <L 257>
        wp::adj_mul(var_16, var_11, adj_16, adj_11, adj_17);
        wp::adj_mul(var_13, var_15, adj_13, adj_15, adj_16);
        wp::adj_extract(var_n, var_14, adj_n, adj_14, adj_15);
        wp::adj_extract(var_n, var_12, adj_n, adj_12, adj_13);
        // adj: b = n[0] * n[1] * a                                                           <L 256>
        wp::adj_div(var_6, var_10, var_11, adj_6, adj_10, adj_11);
        wp::adj_sub(var_7, var_9, adj_7, adj_9, adj_10);
        wp::adj_extract(var_n, var_8, adj_n, adj_8, adj_9);
        // adj: a = 1.0 / (1.0 - n[2])                                                        <L 255>
    }
    wp::adj_extract(var_n, var_2, adj_n, adj_2, adj_3);
    // adj: if n[2] < 0.0:                                                                    <L 254>
    // adj: b2 = wp.vec3()                                                                    <L 253>
    // adj: b1 = wp.vec3()                                                                    <L 252>
    // adj: def orthonormal_basis(n: wp.vec3):                                                <L 236>
    return;
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/viewer/kernels.py:896
static void adj_depth_to_color_0(
    wp::float32 var_depth,
    wp::float32 var_min_depth,
    wp::float32 var_max_depth,
    wp::float32 & adj_depth,
    wp::float32 & adj_min_depth,
    wp::float32 & adj_max_depth,
    wp::vec_t<3, wp::float32> & adj_ret)
{
	// reverse mode disabled (module option "enable_backward" is False or no dependent kernel found with "enable_backward")
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/viewer/kernels.py:327
static void adj__quat_from_normal_z_0(
    wp::vec_t<3, wp::float32> var_normal,
    wp::vec_t<3, wp::float32> & adj_normal,
    wp::quat_t<wp::float32> & adj_ret)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::mat_t<3, 3, wp::float32> var_3;
    wp::quat_t<wp::float32> var_4;
    //---------
    // dual vars
    wp::vec_t<3, wp::float32> adj_0 = {};
    wp::vec_t<3, wp::float32> adj_1 = {};
    wp::vec_t<3, wp::float32> adj_2 = {};
    wp::mat_t<3, 3, wp::float32> adj_3 = {};
    wp::quat_t<wp::float32> adj_4 = {};
    //---------
    // forward
    // def _quat_from_normal_z(normal: wp.vec3) -> wp.quat:                                   <L 328>
    // n = wp.normalize(normal)                                                               <L 334>
    var_0 = wp::normalize(var_normal);
    // t1, t2 = orthonormal_basis(n)                                                          <L 335>
    orthonormal_basis_0(var_0, var_1, var_2);
    // R = wp.matrix_from_cols(t1, t2, n)                                                     <L 336>
    var_3 = wp::matrix_from_cols<wp::float32>(var_1, var_2, var_0);
    // return wp.quat_from_matrix(R)                                                          <L 337>
    var_4 = wp::quat_from_matrix(var_3);
    goto label0;
    //---------
    // reverse
    label0:;
    adj_4 += adj_ret;
    wp::adj_quat_from_matrix(var_3, adj_3, adj_4);
    // adj: return wp.quat_from_matrix(R)                                                     <L 337>
    wp::adj_matrix_from_cols(var_1, var_2, var_0, adj_1, adj_2, adj_0, adj_3);
    // adj: R = wp.matrix_from_cols(t1, t2, n)                                                <L 336>
    adj_orthonormal_basis_0(var_0, var_1, var_2, adj_0, adj_1, adj_2);
    // adj: t1, t2 = orthonormal_basis(n)                                                     <L 335>
    wp::adj_normalize(var_normal, var_0, adj_normal, adj_0);
    // adj: n = wp.normalize(normal)                                                          <L 334>
    // adj: def _quat_from_normal_z(normal: wp.vec3) -> wp.quat:                              <L 328>
    return;
}


// /home/jony/miniconda3/envs/soma-retargeter/lib/python3.12/site-packages/warp/_src/math.py:131
static void adj_velocity_at_point_0(
    wp::vec_t<6, wp::float32> var_qd,
    wp::vec_t<3, wp::float32> var_r,
    wp::vec_t<6, wp::float32> & adj_qd,
    wp::vec_t<3, wp::float32> & adj_r,
    wp::vec_t<3, wp::float32> & adj_ret)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    //---------
    // dual vars
    wp::vec_t<3, wp::float32> adj_0 = {};
    wp::vec_t<3, wp::float32> adj_1 = {};
    wp::vec_t<3, wp::float32> adj_2 = {};
    wp::vec_t<3, wp::float32> adj_3 = {};
    //---------
    // forward
    // def velocity_at_point(qd: wp.spatial_vector, r: wp.vec3) -> wp.vec3:                   <L 132>
    // return wp.spatial_bottom(qd) + wp.cross(wp.spatial_top(qd), r)                         <L 148>
    var_0 = wp::spatial_bottom(var_qd);
    var_1 = wp::spatial_top(var_qd);
    var_2 = wp::cross(var_1, var_r);
    var_3 = wp::add(var_0, var_2);
    goto label0;
    //---------
    // reverse
    label0:;
    adj_3 += adj_ret;
    wp::adj_add(var_0, var_2, adj_0, adj_2, adj_3);
    wp::adj_cross(var_1, var_r, adj_1, adj_r, adj_2);
    wp::adj_spatial_top(var_qd, adj_qd, adj_1);
    wp::adj_spatial_bottom(var_qd, adj_qd, adj_0);
    // adj: return wp.spatial_bottom(qd) + wp.cross(wp.spatial_top(qd), r)                    <L 148>
    // adj: def velocity_at_point(qd: wp.spatial_vector, r: wp.vec3) -> wp.vec3:              <L 132>
    return;
}


// /home/jony/Downloads/ardy/newton_rtx_viewer/deps/newton/newton/_src/math/spatial.py:53
static void adj_velocity_at_point_1(
    wp::vec_t<6, wp::float32> var_qd,
    wp::vec_t<3, wp::float32> var_r,
    wp::vec_t<6, wp::float32> & adj_qd,
    wp::vec_t<3, wp::float32> & adj_r,
    wp::vec_t<3, wp::float32> & adj_ret)
{
    //---------
    // primal vars
    wp::vec_t<3, wp::float32> var_0;
    wp::vec_t<3, wp::float32> var_1;
    wp::vec_t<6, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    //---------
    // dual vars
    wp::vec_t<3, wp::float32> adj_0 = {};
    wp::vec_t<3, wp::float32> adj_1 = {};
    wp::vec_t<6, wp::float32> adj_2 = {};
    wp::vec_t<3, wp::float32> adj_3 = {};
    //---------
    // forward
    // def velocity_at_point(qd: wp.spatial_vector, r: wp.vec3) -> wp.vec3:                   <L 54>
    // qd_wp = wp.spatial_vector(wp.spatial_bottom(qd), wp.spatial_top(qd))                   <L 77>
    var_0 = wp::spatial_bottom(var_qd);
    var_1 = wp::spatial_top(var_qd);
    var_2 = wp::vec_t<6, wp::float32>(var_0, var_1);
    // return wp.velocity_at_point(qd_wp, r)                                                  <L 78>
    var_3 = velocity_at_point_0(var_2, var_r);
    goto label0;
    //---------
    // reverse
    label0:;
    adj_3 += adj_ret;
    adj_velocity_at_point_0(var_2, var_r, adj_2, adj_r, adj_3);
    // adj: return wp.velocity_at_point(qd_wp, r)                                             <L 78>
    wp::adj_vec_t(var_0, var_1, adj_0, adj_1, adj_2);
    wp::adj_spatial_top(var_qd, adj_qd, adj_1);
    wp::adj_spatial_bottom(var_qd, adj_qd, adj_0);
    // adj: qd_wp = wp.spatial_vector(wp.spatial_bottom(qd), wp.spatial_top(qd))              <L 77>
    // adj: def velocity_at_point(qd: wp.spatial_vector, r: wp.vec3) -> wp.vec3:              <L 54>
    return;
}

struct wp_args_update_pick_target_kernel_e4fa491f {
    wp::vec_t<3, wp::float32> p;
    wp::vec_t<3, wp::float32> d;
    wp::vec_t<3, wp::float32> world_offset;
    wp::array_t<PickingState_096ac041> pick_state;
};


void update_pick_target_kernel_e4fa491f_cpu_kernel_forward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_update_pick_target_kernel_e4fa491f *_wp_args)
{
    //---------
    // argument vars
    wp::vec_t<3, wp::float32> var_p = _wp_args->p;
    wp::vec_t<3, wp::float32> var_d = _wp_args->d;
    wp::vec_t<3, wp::float32> var_world_offset = _wp_args->world_offset;
    wp::array_t<PickingState_096ac041> var_pick_state = _wp_args->pick_state;
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    PickingState_096ac041* var_1;
    wp::vec_t<3, wp::float32>* var_2;
    wp::vec_t<3, wp::float32> var_3;
    wp::vec_t<3, wp::float32> var_4;
    wp::vec_t<3, wp::float32> var_5;
    wp::vec_t<3, wp::float32> var_6;
    wp::float32 var_7;
    wp::vec_t<3, wp::float32> var_8;
    wp::vec_t<3, wp::float32> var_9;
    wp::vec_t<3, wp::float32> var_10;
    const wp::int32 var_11 = 0;
    //---------
    // forward
    // def update_pick_target_kernel(                                                         <L 131>
    // original_target = pick_state[0].picking_target_world                                   <L 139>
    var_1 = wp::address(var_pick_state, var_0);
    var_2 = &(((*wp::address(var_pick_state, var_0))).picking_target_world);
    var_4 = wp::load(var_2);
    var_3 = wp::copy(var_4);
    // original_target_offset = original_target + world_offset                                <L 142>
    var_5 = wp::add(var_3, var_world_offset);
    // dist = wp.length(original_target_offset - p)                                           <L 145>
    var_6 = wp::sub(var_5, var_p);
    var_7 = wp::length(var_6);
    // new_mouse_target_offset = p + d * dist                                                 <L 148>
    var_8 = wp::mul(var_d, var_7);
    var_9 = wp::add(var_p, var_8);
    // new_mouse_target = new_mouse_target_offset - world_offset                              <L 151>
    var_10 = wp::sub(var_9, var_world_offset);
    // pick_state[0].picking_target_world = new_mouse_target                                  <L 154>
    wp::index(var_pick_state, var_11).picking_target_world = var_10;
}



void update_pick_target_kernel_e4fa491f_cpu_kernel_backward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_update_pick_target_kernel_e4fa491f *_wp_args,
    wp_args_update_pick_target_kernel_e4fa491f *_wp_adj_args)
{
    //---------
    // argument vars
    wp::vec_t<3, wp::float32> var_p = _wp_args->p;
    wp::vec_t<3, wp::float32> var_d = _wp_args->d;
    wp::vec_t<3, wp::float32> var_world_offset = _wp_args->world_offset;
    wp::array_t<PickingState_096ac041> var_pick_state = _wp_args->pick_state;
    wp::vec_t<3, wp::float32> adj_p = _wp_adj_args->p;
    wp::vec_t<3, wp::float32> adj_d = _wp_adj_args->d;
    wp::vec_t<3, wp::float32> adj_world_offset = _wp_adj_args->world_offset;
    wp::array_t<PickingState_096ac041> adj_pick_state = _wp_adj_args->pick_state;
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    PickingState_096ac041* var_1;
    wp::vec_t<3, wp::float32>* var_2;
    wp::vec_t<3, wp::float32> var_3;
    wp::vec_t<3, wp::float32> var_4;
    wp::vec_t<3, wp::float32> var_5;
    wp::vec_t<3, wp::float32> var_6;
    wp::float32 var_7;
    wp::vec_t<3, wp::float32> var_8;
    wp::vec_t<3, wp::float32> var_9;
    wp::vec_t<3, wp::float32> var_10;
    const wp::int32 var_11 = 0;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    PickingState_096ac041 adj_1 = {};
    wp::vec_t<3, wp::float32> adj_2 = {};
    wp::vec_t<3, wp::float32> adj_3 = {};
    wp::vec_t<3, wp::float32> adj_4 = {};
    wp::vec_t<3, wp::float32> adj_5 = {};
    wp::vec_t<3, wp::float32> adj_6 = {};
    wp::float32 adj_7 = {};
    wp::vec_t<3, wp::float32> adj_8 = {};
    wp::vec_t<3, wp::float32> adj_9 = {};
    wp::vec_t<3, wp::float32> adj_10 = {};
    wp::int32 adj_11 = {};
    //---------
    // forward
    // def update_pick_target_kernel(                                                         <L 131>
    // original_target = pick_state[0].picking_target_world                                   <L 139>
    var_1 = wp::address(var_pick_state, var_0);
    var_2 = &(((*wp::address(var_pick_state, var_0))).picking_target_world);
    var_4 = wp::load(var_2);
    var_3 = wp::copy(var_4);
    // original_target_offset = original_target + world_offset                                <L 142>
    var_5 = wp::add(var_3, var_world_offset);
    // dist = wp.length(original_target_offset - p)                                           <L 145>
    var_6 = wp::sub(var_5, var_p);
    var_7 = wp::length(var_6);
    // new_mouse_target_offset = p + d * dist                                                 <L 148>
    var_8 = wp::mul(var_d, var_7);
    var_9 = wp::add(var_p, var_8);
    // new_mouse_target = new_mouse_target_offset - world_offset                              <L 151>
    var_10 = wp::sub(var_9, var_world_offset);
    // pick_state[0].picking_target_world = new_mouse_target                                  <L 154>
    wp::index(var_pick_state, var_11).picking_target_world = var_10;
    //---------
    // reverse
    wp::adj_array_store_slot(var_pick_state, adj_pick_state, adj_10, [&](auto& _e) -> auto& { return _e.picking_target_world; }, var_11);
    // adj: pick_state[0].picking_target_world = new_mouse_target                             <L 154>
    wp::adj_sub(var_9, var_world_offset, adj_9, adj_world_offset, adj_10);
    // adj: new_mouse_target = new_mouse_target_offset - world_offset                         <L 151>
    wp::adj_add(var_p, var_8, adj_p, adj_8, adj_9);
    wp::adj_mul(var_d, var_7, adj_d, adj_7, adj_8);
    // adj: new_mouse_target_offset = p + d * dist                                            <L 148>
    wp::adj_length(var_6, var_7, adj_6, adj_7);
    wp::adj_sub(var_5, var_p, adj_5, adj_p, adj_6);
    // adj: dist = wp.length(original_target_offset - p)                                      <L 145>
    wp::adj_add(var_3, var_world_offset, adj_3, adj_world_offset, adj_5);
    // adj: original_target_offset = original_target + world_offset                           <L 142>
    wp::adj_copy(var_4, adj_2, adj_3);
    adj_1.picking_target_world += adj_2;
    wp::adj_address(var_pick_state, var_0, adj_pick_state, adj_0, adj_1);
    // adj: original_target = pick_state[0].picking_target_world                              <L 139>
    // adj: def update_pick_target_kernel(                                                    <L 131>
    return;
}



extern "C" {

// Python CPU entry points
WP_API void update_pick_target_kernel_e4fa491f_cpu_forward(
    wp::launch_bounds_t<1> *dim,
    wp_args_update_pick_target_kernel_e4fa491f *_wp_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        update_pick_target_kernel_e4fa491f_cpu_kernel_forward(*dim, task_index, _wp_args);
    }
}

} // extern C



extern "C" {

WP_API void update_pick_target_kernel_e4fa491f_cpu_backward(
    wp::launch_bounds_t<1> *dim,
    wp_args_update_pick_target_kernel_e4fa491f *_wp_args,
    wp_args_update_pick_target_kernel_e4fa491f *_wp_adj_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        update_pick_target_kernel_e4fa491f_cpu_kernel_backward(*dim, task_index, _wp_args, _wp_adj_args);
    }
}

} // extern C

struct wp_args_update_shape_xforms_6019217d {
    wp::array_t<wp::transform_t<wp::float32>> shape_xforms;
    wp::array_t<wp::int32> shape_parents;
    wp::array_t<wp::transform_t<wp::float32>> body_q;
    wp::array_t<wp::int32> shape_worlds;
    wp::array_t<wp::vec_t<3, wp::float32>> world_offsets;
    wp::transform_t<wp::float32> layer_xform;
    wp::array_t<wp::transform_t<wp::float32>> world_xforms;
};


void update_shape_xforms_6019217d_cpu_kernel_forward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_update_shape_xforms_6019217d *_wp_args)
{
    //---------
    // argument vars
    wp::array_t<wp::transform_t<wp::float32>> var_shape_xforms = _wp_args->shape_xforms;
    wp::array_t<wp::int32> var_shape_parents = _wp_args->shape_parents;
    wp::array_t<wp::transform_t<wp::float32>> var_body_q = _wp_args->body_q;
    wp::array_t<wp::int32> var_shape_worlds = _wp_args->shape_worlds;
    wp::array_t<wp::vec_t<3, wp::float32>> var_world_offsets = _wp_args->world_offsets;
    wp::transform_t<wp::float32> var_layer_xform = _wp_args->layer_xform;
    wp::array_t<wp::transform_t<wp::float32>> var_world_xforms = _wp_args->world_xforms;
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
    wp::vec_t<3, wp::float32>* var_25;
    wp::vec_t<3, wp::float32> var_26;
    wp::vec_t<3, wp::float32> var_27;
    wp::vec_t<3, wp::float32> var_28;
    wp::vec_t<3, wp::float32> var_29;
    wp::quat_t<wp::float32> var_30;
    wp::transform_t<wp::float32> var_31;
    wp::transform_t<wp::float32> var_32;
    wp::transform_t<wp::float32> var_33;
    wp::transform_t<wp::float32> var_34;
    //---------
    // forward
    // def update_shape_xforms(                                                               <L 158>
    // tid = wp.tid()                                                                         <L 167>
    var_0 = builtin_tid1d();
    // shape_xform = shape_xforms[tid]                                                        <L 169>
    var_1 = wp::address(var_shape_xforms, var_0);
    var_3 = wp::load(var_1);
    var_2 = wp::copy(var_3);
    // shape_parent = shape_parents[tid]                                                      <L 170>
    var_4 = wp::address(var_shape_parents, var_0);
    var_6 = wp::load(var_4);
    var_5 = wp::copy(var_6);
    // if shape_parent >= 0:                                                                  <L 172>
    var_8 = (var_5 >= var_7);
    if (var_8) {
        // world_xform = wp.transform_multiply(body_q[shape_parent], shape_xform)             <L 173>
        var_9 = wp::address(var_body_q, var_5);
        var_11 = wp::load(var_9);
        var_10 = wp::transform_multiply(var_11, var_2);
    }
    if (!var_8) {
        // world_xform = shape_xform                                                          <L 175>
        var_12 = wp::copy(var_2);
    }
    var_13 = wp::where(var_8, var_10, var_12);
    // if world_offsets:                                                                      <L 177>
    if (var_world_offsets) {
        // shape_world = shape_worlds[tid]                                                    <L 178>
        var_14 = wp::address(var_shape_worlds, var_0);
        var_16 = wp::load(var_14);
        var_15 = wp::copy(var_16);
        // if shape_world >= 0 and shape_world < world_offsets.shape[0]:                      <L 179>
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
            // offset = world_offsets[shape_world]                                            <L 180>
            var_25 = wp::address(var_world_offsets, var_15);
            var_27 = wp::load(var_25);
            var_26 = wp::copy(var_27);
            // world_xform = wp.transform(world_xform.p + offset, world_xform.q)              <L 181>
            var_28 = wp::transform_get_translation(var_13);
            var_29 = wp::add(var_28, var_26);
            var_30 = wp::transform_get_rotation(var_13);
            var_31 = wp::transform_t<wp::float32>(var_29, var_30);
        }
        var_32 = wp::where(var_17, var_31, var_13);
    }
    var_33 = wp::where(var_world_offsets, var_32, var_13);
    // world_xforms[tid] = wp.transform_multiply(layer_xform, world_xform)                    <L 183>
    var_34 = wp::transform_multiply(var_layer_xform, var_33);
    wp::array_store(var_world_xforms, var_0, var_34);
}



void update_shape_xforms_6019217d_cpu_kernel_backward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_update_shape_xforms_6019217d *_wp_args,
    wp_args_update_shape_xforms_6019217d *_wp_adj_args)
{
    //---------
    // argument vars
    wp::array_t<wp::transform_t<wp::float32>> var_shape_xforms = _wp_args->shape_xforms;
    wp::array_t<wp::int32> var_shape_parents = _wp_args->shape_parents;
    wp::array_t<wp::transform_t<wp::float32>> var_body_q = _wp_args->body_q;
    wp::array_t<wp::int32> var_shape_worlds = _wp_args->shape_worlds;
    wp::array_t<wp::vec_t<3, wp::float32>> var_world_offsets = _wp_args->world_offsets;
    wp::transform_t<wp::float32> var_layer_xform = _wp_args->layer_xform;
    wp::array_t<wp::transform_t<wp::float32>> var_world_xforms = _wp_args->world_xforms;
    wp::array_t<wp::transform_t<wp::float32>> adj_shape_xforms = _wp_adj_args->shape_xforms;
    wp::array_t<wp::int32> adj_shape_parents = _wp_adj_args->shape_parents;
    wp::array_t<wp::transform_t<wp::float32>> adj_body_q = _wp_adj_args->body_q;
    wp::array_t<wp::int32> adj_shape_worlds = _wp_adj_args->shape_worlds;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_world_offsets = _wp_adj_args->world_offsets;
    wp::transform_t<wp::float32> adj_layer_xform = _wp_adj_args->layer_xform;
    wp::array_t<wp::transform_t<wp::float32>> adj_world_xforms = _wp_adj_args->world_xforms;
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
    wp::vec_t<3, wp::float32>* var_25;
    wp::vec_t<3, wp::float32> var_26;
    wp::vec_t<3, wp::float32> var_27;
    wp::vec_t<3, wp::float32> var_28;
    wp::vec_t<3, wp::float32> var_29;
    wp::quat_t<wp::float32> var_30;
    wp::transform_t<wp::float32> var_31;
    wp::transform_t<wp::float32> var_32;
    wp::transform_t<wp::float32> var_33;
    wp::transform_t<wp::float32> var_34;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    wp::transform_t<wp::float32> adj_1 = {};
    wp::transform_t<wp::float32> adj_2 = {};
    wp::transform_t<wp::float32> adj_3 = {};
    wp::int32 adj_4 = {};
    wp::int32 adj_5 = {};
    wp::int32 adj_6 = {};
    wp::int32 adj_7 = {};
    bool adj_8 = {};
    wp::transform_t<wp::float32> adj_9 = {};
    wp::transform_t<wp::float32> adj_10 = {};
    wp::transform_t<wp::float32> adj_11 = {};
    wp::transform_t<wp::float32> adj_12 = {};
    wp::transform_t<wp::float32> adj_13 = {};
    wp::int32 adj_14 = {};
    wp::int32 adj_15 = {};
    wp::int32 adj_16 = {};
    bool adj_17 = {};
    wp::int32 adj_18 = {};
    bool adj_19 = {};
    wp::shape_t adj_20 = {};
    wp::int32 adj_21 = {};
    wp::int32 adj_22 = {};
    wp::shape_t adj_23 = {};
    bool adj_24 = {};
    wp::vec_t<3, wp::float32> adj_25 = {};
    wp::vec_t<3, wp::float32> adj_26 = {};
    wp::vec_t<3, wp::float32> adj_27 = {};
    wp::vec_t<3, wp::float32> adj_28 = {};
    wp::vec_t<3, wp::float32> adj_29 = {};
    wp::quat_t<wp::float32> adj_30 = {};
    wp::transform_t<wp::float32> adj_31 = {};
    wp::transform_t<wp::float32> adj_32 = {};
    wp::transform_t<wp::float32> adj_33 = {};
    wp::transform_t<wp::float32> adj_34 = {};
    //---------
    // forward
    // def update_shape_xforms(                                                               <L 158>
    // tid = wp.tid()                                                                         <L 167>
    var_0 = builtin_tid1d();
    // shape_xform = shape_xforms[tid]                                                        <L 169>
    var_1 = wp::address(var_shape_xforms, var_0);
    var_3 = wp::load(var_1);
    var_2 = wp::copy(var_3);
    // shape_parent = shape_parents[tid]                                                      <L 170>
    var_4 = wp::address(var_shape_parents, var_0);
    var_6 = wp::load(var_4);
    var_5 = wp::copy(var_6);
    // if shape_parent >= 0:                                                                  <L 172>
    var_8 = (var_5 >= var_7);
    if (var_8) {
        // world_xform = wp.transform_multiply(body_q[shape_parent], shape_xform)             <L 173>
        var_9 = wp::address(var_body_q, var_5);
        var_11 = wp::load(var_9);
        var_10 = wp::transform_multiply(var_11, var_2);
    }
    if (!var_8) {
        // world_xform = shape_xform                                                          <L 175>
        var_12 = wp::copy(var_2);
    }
    var_13 = wp::where(var_8, var_10, var_12);
    // if world_offsets:                                                                      <L 177>
    if (var_world_offsets) {
        // shape_world = shape_worlds[tid]                                                    <L 178>
        var_14 = wp::address(var_shape_worlds, var_0);
        var_16 = wp::load(var_14);
        var_15 = wp::copy(var_16);
        // if shape_world >= 0 and shape_world < world_offsets.shape[0]:                      <L 179>
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
            // offset = world_offsets[shape_world]                                            <L 180>
            var_25 = wp::address(var_world_offsets, var_15);
            var_27 = wp::load(var_25);
            var_26 = wp::copy(var_27);
            // world_xform = wp.transform(world_xform.p + offset, world_xform.q)              <L 181>
            var_28 = wp::transform_get_translation(var_13);
            var_29 = wp::add(var_28, var_26);
            var_30 = wp::transform_get_rotation(var_13);
            var_31 = wp::transform_t<wp::float32>(var_29, var_30);
        }
        var_32 = wp::where(var_17, var_31, var_13);
    }
    var_33 = wp::where(var_world_offsets, var_32, var_13);
    // world_xforms[tid] = wp.transform_multiply(layer_xform, world_xform)                    <L 183>
    var_34 = wp::transform_multiply(var_layer_xform, var_33);
    // wp::array_store(var_world_xforms, var_0, var_34);
    //---------
    // reverse
    wp::adj_array_store(var_world_xforms, var_0, var_34, adj_world_xforms, adj_0, adj_34);
    wp::adj_transform_multiply(var_layer_xform, var_33, adj_layer_xform, adj_33, adj_34);
    // adj: world_xforms[tid] = wp.transform_multiply(layer_xform, world_xform)               <L 183>
    wp::adj_where(var_world_offsets, var_32, var_13, adj_world_offsets, adj_32, adj_13, adj_33);
    if (var_world_offsets) {
        wp::adj_where(var_17, var_31, var_13, adj_17, adj_31, adj_13, adj_32);
        if (var_17) {
            wp::adj_transform_t(var_29, var_30, adj_29, adj_30, adj_31);
            wp::adj_transform_get_rotation(var_13, adj_13, adj_30);
            wp::adj_add(var_28, var_26, adj_28, adj_26, adj_29);
            wp::adj_transform_get_translation(var_13, adj_13, adj_28);
            // adj: world_xform = wp.transform(world_xform.p + offset, world_xform.q)         <L 181>
            wp::adj_copy(var_27, adj_25, adj_26);
            wp::adj_address(var_world_offsets, var_15, adj_world_offsets, adj_15, adj_25);
            // adj: offset = world_offsets[shape_world]                                       <L 180>
        }
        if (var_17) {
            adj_world_offsets.shape = adj_20;
        }
        // adj: if shape_world >= 0 and shape_world < world_offsets.shape[0]:                 <L 179>
        wp::adj_copy(var_16, adj_14, adj_15);
        wp::adj_address(var_shape_worlds, var_0, adj_shape_worlds, adj_0, adj_14);
        // adj: shape_world = shape_worlds[tid]                                               <L 178>
    }
    // adj: if world_offsets:                                                                 <L 177>
    wp::adj_where(var_8, var_10, var_12, adj_8, adj_10, adj_12, adj_13);
    if (!var_8) {
        wp::adj_copy(var_2, adj_2, adj_12);
        // adj: world_xform = shape_xform                                                     <L 175>
    }
    if (var_8) {
        wp::adj_transform_multiply(var_11, var_2, adj_9, adj_2, adj_10);
        wp::adj_address(var_body_q, var_5, adj_body_q, adj_5, adj_9);
        // adj: world_xform = wp.transform_multiply(body_q[shape_parent], shape_xform)        <L 173>
    }
    // adj: if shape_parent >= 0:                                                             <L 172>
    wp::adj_copy(var_6, adj_4, adj_5);
    wp::adj_address(var_shape_parents, var_0, adj_shape_parents, adj_0, adj_4);
    // adj: shape_parent = shape_parents[tid]                                                 <L 170>
    wp::adj_copy(var_3, adj_1, adj_2);
    wp::adj_address(var_shape_xforms, var_0, adj_shape_xforms, adj_0, adj_1);
    // adj: shape_xform = shape_xforms[tid]                                                   <L 169>
    // adj: tid = wp.tid()                                                                    <L 167>
    // adj: def update_shape_xforms(                                                          <L 158>
    return;
}



extern "C" {

// Python CPU entry points
WP_API void update_shape_xforms_6019217d_cpu_forward(
    wp::launch_bounds_t<1> *dim,
    wp_args_update_shape_xforms_6019217d *_wp_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        update_shape_xforms_6019217d_cpu_kernel_forward(*dim, task_index, _wp_args);
    }
}

} // extern C



extern "C" {

WP_API void update_shape_xforms_6019217d_cpu_backward(
    wp::launch_bounds_t<1> *dim,
    wp_args_update_shape_xforms_6019217d *_wp_args,
    wp_args_update_shape_xforms_6019217d *_wp_adj_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        update_shape_xforms_6019217d_cpu_kernel_backward(*dim, task_index, _wp_args, _wp_adj_args);
    }
}

} // extern C

struct wp_args_build_active_particle_mask_9cc5cd19 {
    wp::array_t<wp::int32> flags;
    wp::array_t<wp::int32> mask;
};


void build_active_particle_mask_9cc5cd19_cpu_kernel_forward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_build_active_particle_mask_9cc5cd19 *_wp_args)
{
    //---------
    // argument vars
    wp::array_t<wp::int32> var_flags = _wp_args->flags;
    wp::array_t<wp::int32> var_mask = _wp_args->mask;
    //---------
    // primal vars
    wp::int32 var_0;
    wp::int32* var_1;
    const wp::int32 var_2 = 1;
    wp::int32 var_3;
    wp::int32 var_4;
    const wp::int32 var_5 = 0;
    wp::int32 var_6;
    bool var_7;
    const wp::int32 var_8 = 1;
    wp::int32 var_9;
    const wp::int32 var_10 = 0;
    wp::int32 var_11;
    //---------
    // forward
    // def build_active_particle_mask(                                                        <L 1017>
    // i = wp.tid()                                                                           <L 1021>
    var_0 = builtin_tid1d();
    // if (flags[i] & newton.ParticleFlags.ACTIVE) != wp.int32(0):                            <L 1022>
    var_1 = wp::address(var_flags, var_0);
    var_4 = wp::load(var_1);
    var_3 = wp::bit_and(var_4, var_2);
    var_6 = wp::int32(var_5);
    var_7 = (var_3 != var_6);
    if (var_7) {
        // mask[i] = wp.int32(1)                                                              <L 1023>
        var_9 = wp::int32(var_8);
        wp::array_store(var_mask, var_0, var_9);
    }
    if (!var_7) {
        // mask[i] = wp.int32(0)                                                              <L 1025>
        var_11 = wp::int32(var_10);
        wp::array_store(var_mask, var_0, var_11);
    }
}



void build_active_particle_mask_9cc5cd19_cpu_kernel_backward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_build_active_particle_mask_9cc5cd19 *_wp_args,
    wp_args_build_active_particle_mask_9cc5cd19 *_wp_adj_args)
{
    //---------
    // argument vars
    wp::array_t<wp::int32> var_flags = _wp_args->flags;
    wp::array_t<wp::int32> var_mask = _wp_args->mask;
    wp::array_t<wp::int32> adj_flags = _wp_adj_args->flags;
    wp::array_t<wp::int32> adj_mask = _wp_adj_args->mask;
    //---------
    // primal vars
    wp::int32 var_0;
    wp::int32* var_1;
    const wp::int32 var_2 = 1;
    wp::int32 var_3;
    wp::int32 var_4;
    const wp::int32 var_5 = 0;
    wp::int32 var_6;
    bool var_7;
    const wp::int32 var_8 = 1;
    wp::int32 var_9;
    const wp::int32 var_10 = 0;
    wp::int32 var_11;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    wp::int32 adj_1 = {};
    wp::int32 adj_2 = {};
    wp::int32 adj_3 = {};
    wp::int32 adj_4 = {};
    wp::int32 adj_5 = {};
    wp::int32 adj_6 = {};
    bool adj_7 = {};
    wp::int32 adj_8 = {};
    wp::int32 adj_9 = {};
    wp::int32 adj_10 = {};
    wp::int32 adj_11 = {};
    //---------
    // forward
    // def build_active_particle_mask(                                                        <L 1017>
    // i = wp.tid()                                                                           <L 1021>
    var_0 = builtin_tid1d();
    // if (flags[i] & newton.ParticleFlags.ACTIVE) != wp.int32(0):                            <L 1022>
    var_1 = wp::address(var_flags, var_0);
    var_4 = wp::load(var_1);
    var_3 = wp::bit_and(var_4, var_2);
    var_6 = wp::int32(var_5);
    var_7 = (var_3 != var_6);
    if (var_7) {
        // mask[i] = wp.int32(1)                                                              <L 1023>
        var_9 = wp::int32(var_8);
        // wp::array_store(var_mask, var_0, var_9);
    }
    if (!var_7) {
        // mask[i] = wp.int32(0)                                                              <L 1025>
        var_11 = wp::int32(var_10);
        // wp::array_store(var_mask, var_0, var_11);
    }
    //---------
    // reverse
    if (!var_7) {
        wp::adj_array_store(var_mask, var_0, var_11, adj_mask, adj_0, adj_11);
        // adj: mask[i] = wp.int32(0)                                                         <L 1025>
    }
    if (var_7) {
        wp::adj_array_store(var_mask, var_0, var_9, adj_mask, adj_0, adj_9);
        // adj: mask[i] = wp.int32(1)                                                         <L 1023>
    }
    wp::adj_address(var_flags, var_0, adj_flags, adj_0, adj_1);
    // adj: if (flags[i] & newton.ParticleFlags.ACTIVE) != wp.int32(0):                       <L 1022>
    // adj: i = wp.tid()                                                                      <L 1021>
    // adj: def build_active_particle_mask(                                                   <L 1017>
    return;
}



extern "C" {

// Python CPU entry points
WP_API void build_active_particle_mask_9cc5cd19_cpu_forward(
    wp::launch_bounds_t<1> *dim,
    wp_args_build_active_particle_mask_9cc5cd19 *_wp_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        build_active_particle_mask_9cc5cd19_cpu_kernel_forward(*dim, task_index, _wp_args);
    }
}

} // extern C



extern "C" {

WP_API void build_active_particle_mask_9cc5cd19_cpu_backward(
    wp::launch_bounds_t<1> *dim,
    wp_args_build_active_particle_mask_9cc5cd19 *_wp_args,
    wp_args_build_active_particle_mask_9cc5cd19 *_wp_adj_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        build_active_particle_mask_9cc5cd19_cpu_kernel_backward(*dim, task_index, _wp_args, _wp_adj_args);
    }
}

} // extern C

struct wp_args_compute_inertia_box_lines_56517d50 {
    wp::array_t<wp::transform_t<wp::float32>> body_q;
    wp::array_t<wp::vec_t<3, wp::float32>> body_com;
    wp::array_t<wp::mat_t<3, 3, wp::float32>> body_inertia;
    wp::array_t<wp::float32> body_inv_mass;
    wp::array_t<wp::int32> body_world;
    wp::array_t<wp::vec_t<3, wp::float32>> world_offsets;
    wp::transform_t<wp::float32> layer_xform;
    wp::array_t<wp::int32> visible_worlds_mask;
    wp::vec_t<3, wp::float32> color;
    wp::array_t<wp::vec_t<3, wp::float32>> line_starts;
    wp::array_t<wp::vec_t<3, wp::float32>> line_ends;
    wp::array_t<wp::vec_t<3, wp::float32>> line_colors;
};


void compute_inertia_box_lines_56517d50_cpu_kernel_forward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_compute_inertia_box_lines_56517d50 *_wp_args)
{
    //---------
    // argument vars
    wp::array_t<wp::transform_t<wp::float32>> var_body_q = _wp_args->body_q;
    wp::array_t<wp::vec_t<3, wp::float32>> var_body_com = _wp_args->body_com;
    wp::array_t<wp::mat_t<3, 3, wp::float32>> var_body_inertia = _wp_args->body_inertia;
    wp::array_t<wp::float32> var_body_inv_mass = _wp_args->body_inv_mass;
    wp::array_t<wp::int32> var_body_world = _wp_args->body_world;
    wp::array_t<wp::vec_t<3, wp::float32>> var_world_offsets = _wp_args->world_offsets;
    wp::transform_t<wp::float32> var_layer_xform = _wp_args->layer_xform;
    wp::array_t<wp::int32> var_visible_worlds_mask = _wp_args->visible_worlds_mask;
    wp::vec_t<3, wp::float32> var_color = _wp_args->color;
    wp::array_t<wp::vec_t<3, wp::float32>> var_line_starts = _wp_args->line_starts;
    wp::array_t<wp::vec_t<3, wp::float32>> var_line_ends = _wp_args->line_ends;
    wp::array_t<wp::vec_t<3, wp::float32>> var_line_colors = _wp_args->line_colors;
    //---------
    // primal vars
    wp::int32 var_0;
    const wp::int32 var_1 = 12;
    wp::int32 var_2;
    const wp::int32 var_3 = 12;
    wp::int32 var_4;
    const wp::float32 var_5 = NAN;
    const wp::float32 var_6 = NAN;
    const wp::float32 var_7 = NAN;
    const wp::float32 var_8 = NAN;
    const wp::float32 var_9 = NAN;
    const wp::float32 var_10 = NAN;
    wp::vec_t<3, wp::float32> var_11;
    const wp::float32 var_12 = 0.0;
    const wp::float32 var_13 = 0.0;
    const wp::float32 var_14 = 0.0;
    wp::vec_t<3, wp::float32> var_15;
    wp::int32* var_16;
    wp::int32 var_17;
    wp::int32 var_18;
    const wp::int32 var_19 = 0;
    bool var_20;
    wp::int32* var_21;
    const wp::int32 var_22 = 0;
    bool var_23;
    wp::int32 var_24;
    wp::float32* var_25;
    wp::float32 var_26;
    wp::float32 var_27;
    const wp::float32 var_28 = 0.0;
    bool var_29;
    wp::mat_t<3, 3, wp::float32>* var_30;
    wp::mat_t<3, 3, wp::float32> var_31;
    wp::vec_t<3, wp::float32> var_32;
    wp::mat_t<3, 3, wp::float32> var_33;
    wp::float32 var_34;
    wp::float32 var_35;
    bool var_36;
    const wp::float32 var_37 = 0.0;
    bool var_38;
    const wp::float32 var_39 = 1.01;
    wp::float32 var_40;
    bool var_41;
    const wp::int32 var_42 = 3;
    wp::mat_t<3, 3, wp::float32> var_43;
    const wp::float32 var_44 = 0.0;
    bool var_45;
    const wp::int32 var_46 = 0;
    wp::float32 var_47;
    const wp::int32 var_48 = 1;
    wp::float32 var_49;
    wp::float32 var_50;
    wp::float32 var_51;
    const wp::int32 var_52 = 0;
    wp::float32 var_53;
    const wp::int32 var_54 = 2;
    wp::float32 var_55;
    wp::float32 var_56;
    wp::float32 var_57;
    const wp::int32 var_58 = 1;
    wp::float32 var_59;
    const wp::int32 var_60 = 2;
    wp::float32 var_61;
    wp::float32 var_62;
    wp::float32 var_63;
    wp::float32 var_64;
    wp::float32 var_65;
    const wp::float32 var_66 = 0.01;
    wp::float32 var_67;
    bool var_68;
    bool var_69;
    bool var_70;
    bool var_71;
    const wp::int32 var_72 = 0;
    const wp::int32 var_73 = 0;
    wp::float32 var_74;
    const wp::int32 var_75 = 1;
    const wp::int32 var_76 = 0;
    wp::float32 var_77;
    const wp::int32 var_78 = 2;
    const wp::int32 var_79 = 0;
    wp::float32 var_80;
    wp::vec_t<3, wp::float32> var_81;
    bool var_82;
    const wp::int32 var_83 = 0;
    const wp::int32 var_84 = 1;
    wp::float32 var_85;
    const wp::int32 var_86 = 1;
    const wp::int32 var_87 = 1;
    wp::float32 var_88;
    const wp::int32 var_89 = 2;
    const wp::int32 var_90 = 1;
    wp::float32 var_91;
    wp::vec_t<3, wp::float32> var_92;
    const wp::int32 var_93 = 0;
    const wp::int32 var_94 = 2;
    wp::float32 var_95;
    const wp::int32 var_96 = 1;
    const wp::int32 var_97 = 2;
    wp::float32 var_98;
    const wp::int32 var_99 = 2;
    const wp::int32 var_100 = 2;
    wp::float32 var_101;
    wp::vec_t<3, wp::float32> var_102;
    wp::vec_t<3, wp::float32> var_103;
    wp::vec_t<3, wp::float32> var_104;
    wp::vec_t<3, wp::float32> var_105;
    wp::vec_t<3, wp::float32> var_106;
    wp::vec_t<3, wp::float32> var_107;
    wp::vec_t<3, wp::float32> var_108;
    wp::vec_t<3, wp::float32> var_109;
    wp::vec_t<3, wp::float32> var_110;
    bool var_111;
    bool var_112;
    bool var_113;
    wp::vec_t<3, wp::float32> var_114;
    wp::vec_t<3, wp::float32> var_115;
    wp::vec_t<3, wp::float32> var_116;
    bool var_117;
    wp::vec_t<3, wp::float32> var_118;
    wp::vec_t<3, wp::float32> var_119;
    wp::vec_t<3, wp::float32> var_120;
    wp::vec_t<3, wp::float32> var_121;
    wp::vec_t<3, wp::float32> var_122;
    wp::vec_t<3, wp::float32> var_123;
    wp::vec_t<3, wp::float32> var_124;
    wp::vec_t<3, wp::float32> var_125;
    wp::vec_t<3, wp::float32> var_126;
    const wp::int32 var_127 = 0;
    wp::float32 var_128;
    const wp::int32 var_129 = 1;
    wp::float32 var_130;
    const wp::int32 var_131 = 2;
    wp::float32 var_132;
    const wp::int32 var_133 = 0;
    wp::float32 var_134;
    const wp::int32 var_135 = 1;
    wp::float32 var_136;
    const wp::int32 var_137 = 2;
    wp::float32 var_138;
    const wp::int32 var_139 = 0;
    wp::float32 var_140;
    const wp::int32 var_141 = 1;
    wp::float32 var_142;
    const wp::int32 var_143 = 2;
    wp::float32 var_144;
    wp::mat_t<3, 3, wp::float32> var_145;
    wp::mat_t<3, 3, wp::float32> var_146;
    wp::mat_t<3, 3, wp::float32> var_147;
    wp::mat_t<3, 3, wp::float32> var_148;
    wp::mat_t<3, 3, wp::float32> var_149;
    wp::vec_t<3, wp::float32> var_150;
    const wp::float32 var_151 = 12.0;
    const wp::float32 var_152 = 8.0;
    wp::float32 var_153;
    wp::vec_t<3, wp::float32> var_154;
    const wp::int32 var_155 = 2;
    wp::float32 var_156;
    const wp::int32 var_157 = 1;
    wp::float32 var_158;
    wp::float32 var_159;
    const wp::int32 var_160 = 0;
    wp::float32 var_161;
    wp::float32 var_162;
    wp::float32 var_163;
    wp::float32 var_164;
    const wp::int32 var_165 = 0;
    wp::float32 var_166;
    const wp::int32 var_167 = 2;
    wp::float32 var_168;
    wp::float32 var_169;
    const wp::int32 var_170 = 1;
    wp::float32 var_171;
    wp::float32 var_172;
    wp::float32 var_173;
    wp::float32 var_174;
    const wp::int32 var_175 = 1;
    wp::float32 var_176;
    const wp::int32 var_177 = 0;
    wp::float32 var_178;
    wp::float32 var_179;
    const wp::int32 var_180 = 2;
    wp::float32 var_181;
    wp::float32 var_182;
    wp::float32 var_183;
    wp::float32 var_184;
    const wp::float32 var_185 = 0.0;
    wp::float32 var_186;
    const wp::float32 var_187 = 0.0;
    wp::float32 var_188;
    const wp::float32 var_189 = 0.0;
    wp::float32 var_190;
    const wp::float32 var_191 = 0.0;
    wp::float32 var_192;
    const wp::float32 var_193 = 0.0;
    wp::float32 var_194;
    const wp::float32 var_195 = 0.0;
    wp::float32 var_196;
    const wp::int32 var_197 = 0;
    bool var_198;
    wp::float32 var_199;
    wp::float32 var_200;
    wp::float32 var_201;
    wp::float32 var_202;
    wp::float32 var_203;
    wp::float32 var_204;
    const wp::int32 var_205 = 1;
    bool var_206;
    wp::float32 var_207;
    wp::float32 var_208;
    wp::float32 var_209;
    wp::float32 var_210;
    wp::float32 var_211;
    wp::float32 var_212;
    const wp::int32 var_213 = 2;
    bool var_214;
    wp::float32 var_215;
    wp::float32 var_216;
    wp::float32 var_217;
    wp::float32 var_218;
    wp::float32 var_219;
    wp::float32 var_220;
    const wp::int32 var_221 = 3;
    bool var_222;
    wp::float32 var_223;
    wp::float32 var_224;
    wp::float32 var_225;
    wp::float32 var_226;
    wp::float32 var_227;
    wp::float32 var_228;
    const wp::int32 var_229 = 4;
    bool var_230;
    wp::float32 var_231;
    wp::float32 var_232;
    wp::float32 var_233;
    wp::float32 var_234;
    wp::float32 var_235;
    wp::float32 var_236;
    const wp::int32 var_237 = 5;
    bool var_238;
    wp::float32 var_239;
    wp::float32 var_240;
    wp::float32 var_241;
    wp::float32 var_242;
    wp::float32 var_243;
    wp::float32 var_244;
    const wp::int32 var_245 = 6;
    bool var_246;
    wp::float32 var_247;
    wp::float32 var_248;
    wp::float32 var_249;
    wp::float32 var_250;
    wp::float32 var_251;
    wp::float32 var_252;
    const wp::int32 var_253 = 7;
    bool var_254;
    wp::float32 var_255;
    wp::float32 var_256;
    wp::float32 var_257;
    wp::float32 var_258;
    wp::float32 var_259;
    wp::float32 var_260;
    const wp::int32 var_261 = 8;
    bool var_262;
    wp::float32 var_263;
    wp::float32 var_264;
    wp::float32 var_265;
    wp::float32 var_266;
    wp::float32 var_267;
    wp::float32 var_268;
    const wp::int32 var_269 = 9;
    bool var_270;
    wp::float32 var_271;
    wp::float32 var_272;
    wp::float32 var_273;
    wp::float32 var_274;
    wp::float32 var_275;
    wp::float32 var_276;
    const wp::int32 var_277 = 10;
    bool var_278;
    wp::float32 var_279;
    wp::float32 var_280;
    wp::float32 var_281;
    wp::float32 var_282;
    wp::float32 var_283;
    wp::float32 var_284;
    const wp::int32 var_285 = 11;
    bool var_286;
    wp::float32 var_287;
    wp::float32 var_288;
    wp::float32 var_289;
    wp::float32 var_290;
    wp::float32 var_291;
    wp::float32 var_292;
    wp::float32 var_293;
    wp::float32 var_294;
    wp::float32 var_295;
    wp::float32 var_296;
    wp::float32 var_297;
    wp::float32 var_298;
    wp::float32 var_299;
    wp::float32 var_300;
    wp::float32 var_301;
    wp::float32 var_302;
    wp::float32 var_303;
    wp::float32 var_304;
    wp::float32 var_305;
    wp::float32 var_306;
    wp::float32 var_307;
    wp::float32 var_308;
    wp::float32 var_309;
    wp::float32 var_310;
    wp::float32 var_311;
    wp::float32 var_312;
    wp::float32 var_313;
    wp::float32 var_314;
    wp::float32 var_315;
    wp::float32 var_316;
    wp::float32 var_317;
    wp::float32 var_318;
    wp::float32 var_319;
    wp::float32 var_320;
    wp::float32 var_321;
    wp::float32 var_322;
    wp::float32 var_323;
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
    wp::float32 var_336;
    wp::float32 var_337;
    wp::float32 var_338;
    wp::float32 var_339;
    wp::float32 var_340;
    wp::float32 var_341;
    wp::float32 var_342;
    wp::float32 var_343;
    wp::float32 var_344;
    wp::float32 var_345;
    wp::float32 var_346;
    wp::float32 var_347;
    wp::float32 var_348;
    wp::float32 var_349;
    wp::float32 var_350;
    wp::float32 var_351;
    wp::float32 var_352;
    wp::float32 var_353;
    wp::float32 var_354;
    wp::float32 var_355;
    wp::float32 var_356;
    wp::float32 var_357;
    wp::float32 var_358;
    wp::float32 var_359;
    wp::float32 var_360;
    wp::float32 var_361;
    wp::float32 var_362;
    wp::float32 var_363;
    wp::float32 var_364;
    wp::vec_t<3, wp::float32> var_365;
    wp::vec_t<3, wp::float32> var_366;
    wp::quat_t<wp::float32> var_367;
    wp::vec_t<3, wp::float32> var_368;
    wp::vec_t<3, wp::float32> var_369;
    wp::transform_t<wp::float32>* var_370;
    wp::transform_t<wp::float32> var_371;
    wp::transform_t<wp::float32> var_372;
    wp::quat_t<wp::float32> var_373;
    wp::vec_t<3, wp::float32> var_374;
    wp::vec_t<3, wp::float32>* var_375;
    wp::vec_t<3, wp::float32> var_376;
    wp::vec_t<3, wp::float32> var_377;
    wp::vec_t<3, wp::float32> var_378;
    wp::vec_t<3, wp::float32> var_379;
    wp::vec_t<3, wp::float32> var_380;
    wp::vec_t<3, wp::float32> var_381;
    wp::vec_t<3, wp::float32> var_382;
    wp::vec_t<3, wp::float32> var_383;
    bool var_384;
    const wp::int32 var_385 = 0;
    bool var_386;
    wp::shape_t* var_387;
    const wp::int32 var_388 = 0;
    wp::int32 var_389;
    wp::shape_t var_390;
    bool var_391;
    wp::vec_t<3, wp::float32>* var_392;
    wp::vec_t<3, wp::float32> var_393;
    wp::vec_t<3, wp::float32> var_394;
    wp::vec_t<3, wp::float32> var_395;
    wp::vec_t<3, wp::float32> var_396;
    wp::vec_t<3, wp::float32> var_397;
    wp::vec_t<3, wp::float32> var_398;
    wp::vec_t<3, wp::float32> var_399;
    wp::vec_t<3, wp::float32> var_400;
    //---------
    // forward
    // def compute_inertia_box_lines(                                                         <L 674>
    // tid = wp.tid()                                                                         <L 690>
    var_0 = builtin_tid1d();
    // body_id = tid // 12                                                                    <L 691>
    var_2 = wp::floordiv(var_0, var_1);
    // edge_id = tid % 12                                                                     <L 692>
    var_4 = wp::mod(var_0, var_3);
    // nan_line = wp.vec3(wp.nan, wp.nan, wp.nan)                                             <L 694>
    var_11 = wp::vec_t<3, wp::float32>(var_6, var_8, var_10);
    // zero_color = wp.vec3(0.0, 0.0, 0.0)                                                    <L 695>
    var_15 = wp::vec_t<3, wp::float32>(var_12, var_13, var_14);
    // world_idx = body_world[body_id]                                                        <L 698>
    var_16 = wp::address(var_body_world, var_2);
    var_18 = wp::load(var_16);
    var_17 = wp::copy(var_18);
    // if visible_worlds_mask:                                                                <L 699>
    if (var_visible_worlds_mask) {
        // if world_idx >= 0:                                                                 <L 700>
        var_20 = (var_17 >= var_19);
        if (var_20) {
            // if visible_worlds_mask[world_idx] == 0:                                        <L 701>
            var_21 = wp::address(var_visible_worlds_mask, var_17);
            var_24 = wp::load(var_21);
            var_23 = (var_24 == var_22);
            if (var_23) {
                // line_starts[tid] = nan_line                                                <L 702>
                wp::array_store(var_line_starts, var_0, var_11);
                // line_ends[tid] = nan_line                                                  <L 703>
                wp::array_store(var_line_ends, var_0, var_11);
                // line_colors[tid] = zero_color                                              <L 704>
                wp::array_store(var_line_colors, var_0, var_15);
                // return                                                                     <L 705>
                return;
            }
        }
    }
    // inv_m = body_inv_mass[body_id]                                                         <L 707>
    var_25 = wp::address(var_body_inv_mass, var_2);
    var_27 = wp::load(var_25);
    var_26 = wp::copy(var_27);
    // if inv_m == 0.0:                                                                       <L 708>
    var_29 = (var_26 == var_28);
    if (var_29) {
        // line_starts[tid] = nan_line                                                        <L 709>
        wp::array_store(var_line_starts, var_0, var_11);
        // line_ends[tid] = nan_line                                                          <L 710>
        wp::array_store(var_line_ends, var_0, var_11);
        // line_colors[tid] = zero_color                                                      <L 711>
        wp::array_store(var_line_colors, var_0, var_15);
        // return                                                                             <L 712>
        return;
    }
    // rot, principal_inertia = wp.eig3(body_inertia[body_id])                                <L 715>
    var_30 = wp::address(var_body_inertia, var_2);
    var_33 = wp::load(var_30);
    wp::eig3(var_33, var_31, var_32);
    // max_eig = wp.max(principal_inertia)                                                    <L 720>
    var_34 = wp::max(var_32);
    // min_eig = wp.min(principal_inertia)                                                    <L 721>
    var_35 = wp::min(var_32);
    // if min_eig > 0.0 and max_eig < 1.01 * min_eig:  # within 1% -> isotropic               <L 722>
    var_38 = (var_35 > var_37);
    var_36 = var_38;
    if (var_36) {
        var_40 = wp::mul(var_39, var_35);
        var_41 = (var_34 < var_40);
        var_36 = var_36 && var_41;
    }
    if (var_36) {
        // rot = wp.identity(3, float)                                                        <L 723>
        var_43 = wp::identity<3, wp::float32>();
    }
    if (!var_36) {
        // elif min_eig > 0.0:                                                                <L 724>
        var_45 = (var_35 > var_44);
        if (var_45) {
            // d01 = wp.abs(principal_inertia[0] - principal_inertia[1])                      <L 728>
            var_47 = wp::extract(var_32, var_46);
            var_49 = wp::extract(var_32, var_48);
            var_50 = wp::sub(var_47, var_49);
            var_51 = wp::abs(var_50);
            // d02 = wp.abs(principal_inertia[0] - principal_inertia[2])                      <L 729>
            var_53 = wp::extract(var_32, var_52);
            var_55 = wp::extract(var_32, var_54);
            var_56 = wp::sub(var_53, var_55);
            var_57 = wp::abs(var_56);
            // d12 = wp.abs(principal_inertia[1] - principal_inertia[2])                      <L 730>
            var_59 = wp::extract(var_32, var_58);
            var_61 = wp::extract(var_32, var_60);
            var_62 = wp::sub(var_59, var_61);
            var_63 = wp::abs(var_62);
            // min_diff = wp.min(d01, wp.min(d02, d12))                                       <L 731>
            var_64 = wp::min(var_57, var_63);
            var_65 = wp::min(var_51, var_64);
            // if min_diff < 0.01 * max_eig:  # within 1% -> axisymmetric                     <L 732>
            var_67 = wp::mul(var_66, var_34);
            var_68 = (var_65 < var_67);
            if (var_68) {
                // if d12 <= d01 and d12 <= d02:  # e1 approx eq e2, unique = col 0           <L 734>
                var_70 = (var_63 <= var_51);
                var_69 = var_70;
                if (var_69) {
                    var_71 = (var_63 <= var_57);
                    var_69 = var_69 && var_71;
                }
                if (var_69) {
                    // u = wp.vec3(rot[0, 0], rot[1, 0], rot[2, 0])                           <L 735>
                    var_74 = wp::extract(var_31, var_72, var_73);
                    var_77 = wp::extract(var_31, var_75, var_76);
                    var_80 = wp::extract(var_31, var_78, var_79);
                    var_81 = wp::vec_t<3, wp::float32>(var_74, var_77, var_80);
                }
                if (!var_69) {
                    // elif d02 <= d01:  # e0 approx eq e2, unique = col 1                    <L 736>
                    var_82 = (var_57 <= var_51);
                    if (var_82) {
                        // u = wp.vec3(rot[0, 1], rot[1, 1], rot[2, 1])                       <L 737>
                        var_85 = wp::extract(var_31, var_83, var_84);
                        var_88 = wp::extract(var_31, var_86, var_87);
                        var_91 = wp::extract(var_31, var_89, var_90);
                        var_92 = wp::vec_t<3, wp::float32>(var_85, var_88, var_91);
                    }
                    if (!var_82) {
                        // u = wp.vec3(rot[0, 2], rot[1, 2], rot[2, 2])                       <L 739>
                        var_95 = wp::extract(var_31, var_93, var_94);
                        var_98 = wp::extract(var_31, var_96, var_97);
                        var_101 = wp::extract(var_31, var_99, var_100);
                        var_102 = wp::vec_t<3, wp::float32>(var_95, var_98, var_101);
                    }
                    var_103 = wp::where(var_82, var_92, var_102);
                }
                var_104 = wp::where(var_69, var_81, var_103);
                // u = wp.normalize(u)                                                        <L 740>
                var_105 = wp::normalize(var_104);
                // v1, v2 = orthonormal_basis(u)                                              <L 743>
                orthonormal_basis_0(var_105, var_106, var_107);
                // c0 = v1                                                                    <L 746>
                var_108 = wp::copy(var_106);
                // c1 = v2                                                                    <L 747>
                var_109 = wp::copy(var_107);
                // c2 = u                                                                     <L 748>
                var_110 = wp::copy(var_105);
                // if d12 <= d01 and d12 <= d02:  # unique col 0                              <L 749>
                var_112 = (var_63 <= var_51);
                var_111 = var_112;
                if (var_111) {
                    var_113 = (var_63 <= var_57);
                    var_111 = var_111 && var_113;
                }
                if (var_111) {
                    // c0 = u                                                                 <L 750>
                    var_114 = wp::copy(var_105);
                    // c1 = v1                                                                <L 751>
                    var_115 = wp::copy(var_106);
                    // c2 = v2                                                                <L 752>
                    var_116 = wp::copy(var_107);
                }
                if (!var_111) {
                    // elif d02 <= d01:  # unique col 1                                       <L 753>
                    var_117 = (var_57 <= var_51);
                    if (var_117) {
                        // c0 = v2                                                            <L 754>
                        var_118 = wp::copy(var_107);
                        // c1 = u                                                             <L 755>
                        var_119 = wp::copy(var_105);
                        // c2 = v1                                                            <L 756>
                        var_120 = wp::copy(var_106);
                    }
                    var_121 = wp::where(var_117, var_118, var_108);
                    var_122 = wp::where(var_117, var_119, var_109);
                    var_123 = wp::where(var_117, var_120, var_110);
                }
                var_124 = wp::where(var_111, var_114, var_121);
                var_125 = wp::where(var_111, var_115, var_122);
                var_126 = wp::where(var_111, var_116, var_123);
                // rot = wp.transpose(wp.mat33(*c0, *c1, *c2))                                <L 758>
                var_128 = wp::extract(var_124, var_127);
                var_130 = wp::extract(var_124, var_129);
                var_132 = wp::extract(var_124, var_131);
                var_134 = wp::extract(var_125, var_133);
                var_136 = wp::extract(var_125, var_135);
                var_138 = wp::extract(var_125, var_137);
                var_140 = wp::extract(var_126, var_139);
                var_142 = wp::extract(var_126, var_141);
                var_144 = wp::extract(var_126, var_143);
                var_145 = wp::mat_t<3, 3, wp::float32>(var_128, var_130, var_132, var_134, var_136, var_138, var_140, var_142, var_144);
                var_146 = wp::transpose(var_145);
            }
            var_147 = wp::where(var_68, var_146, var_31);
        }
        var_148 = wp::where(var_45, var_147, var_31);
    }
    var_149 = wp::where(var_36, var_43, var_148);
    // box_inertia = principal_inertia * inv_m * (12.0 / 8.0)                                 <L 760>
    var_150 = wp::mul(var_32, var_26);
    var_153 = wp::div(var_151, var_152);
    var_154 = wp::mul(var_150, var_153);
    // sx = wp.sqrt(wp.abs(box_inertia[2] + box_inertia[1] - box_inertia[0]))                 <L 761>
    var_156 = wp::extract(var_154, var_155);
    var_158 = wp::extract(var_154, var_157);
    var_159 = wp::add(var_156, var_158);
    var_161 = wp::extract(var_154, var_160);
    var_162 = wp::sub(var_159, var_161);
    var_163 = wp::abs(var_162);
    var_164 = wp::sqrt(var_163);
    // sy = wp.sqrt(wp.abs(box_inertia[0] + box_inertia[2] - box_inertia[1]))                 <L 762>
    var_166 = wp::extract(var_154, var_165);
    var_168 = wp::extract(var_154, var_167);
    var_169 = wp::add(var_166, var_168);
    var_171 = wp::extract(var_154, var_170);
    var_172 = wp::sub(var_169, var_171);
    var_173 = wp::abs(var_172);
    var_174 = wp::sqrt(var_173);
    // sz = wp.sqrt(wp.abs(box_inertia[1] + box_inertia[0] - box_inertia[2]))                 <L 763>
    var_176 = wp::extract(var_154, var_175);
    var_178 = wp::extract(var_154, var_177);
    var_179 = wp::add(var_176, var_178);
    var_181 = wp::extract(var_154, var_180);
    var_182 = wp::sub(var_179, var_181);
    var_183 = wp::abs(var_182);
    var_184 = wp::sqrt(var_183);
    // c0x = float(0.0)                                                                       <L 769>
    var_186 = wp::float(var_185);
    // c0y = float(0.0)                                                                       <L 770>
    var_188 = wp::float(var_187);
    // c0z = float(0.0)                                                                       <L 771>
    var_190 = wp::float(var_189);
    // c1x = float(0.0)                                                                       <L 772>
    var_192 = wp::float(var_191);
    // c1y = float(0.0)                                                                       <L 773>
    var_194 = wp::float(var_193);
    // c1z = float(0.0)                                                                       <L 774>
    var_196 = wp::float(var_195);
    // if edge_id == 0:  # 0-1                                                                <L 776>
    var_198 = (var_4 == var_197);
    if (var_198) {
        // c0x = -sx                                                                          <L 777>
        var_199 = wp::neg(var_164);
        // c0y = -sy                                                                          <L 778>
        var_200 = wp::neg(var_174);
        // c0z = -sz                                                                          <L 779>
        var_201 = wp::neg(var_184);
        // c1x = sx                                                                           <L 780>
        var_202 = wp::copy(var_164);
        // c1y = -sy                                                                          <L 781>
        var_203 = wp::neg(var_174);
        // c1z = -sz                                                                          <L 782>
        var_204 = wp::neg(var_184);
    }
    if (!var_198) {
        // elif edge_id == 1:  # 1-2                                                          <L 783>
        var_206 = (var_4 == var_205);
        if (var_206) {
            // c0x = sx                                                                       <L 784>
            var_207 = wp::copy(var_164);
            // c0y = -sy                                                                      <L 785>
            var_208 = wp::neg(var_174);
            // c0z = -sz                                                                      <L 786>
            var_209 = wp::neg(var_184);
            // c1x = sx                                                                       <L 787>
            var_210 = wp::copy(var_164);
            // c1y = sy                                                                       <L 788>
            var_211 = wp::copy(var_174);
            // c1z = -sz                                                                      <L 789>
            var_212 = wp::neg(var_184);
        }
        if (!var_206) {
            // elif edge_id == 2:  # 2-3                                                      <L 790>
            var_214 = (var_4 == var_213);
            if (var_214) {
                // c0x = sx                                                                   <L 791>
                var_215 = wp::copy(var_164);
                // c0y = sy                                                                   <L 792>
                var_216 = wp::copy(var_174);
                // c0z = -sz                                                                  <L 793>
                var_217 = wp::neg(var_184);
                // c1x = -sx                                                                  <L 794>
                var_218 = wp::neg(var_164);
                // c1y = sy                                                                   <L 795>
                var_219 = wp::copy(var_174);
                // c1z = -sz                                                                  <L 796>
                var_220 = wp::neg(var_184);
            }
            if (!var_214) {
                // elif edge_id == 3:  # 3-0                                                  <L 797>
                var_222 = (var_4 == var_221);
                if (var_222) {
                    // c0x = -sx                                                              <L 798>
                    var_223 = wp::neg(var_164);
                    // c0y = sy                                                               <L 799>
                    var_224 = wp::copy(var_174);
                    // c0z = -sz                                                              <L 800>
                    var_225 = wp::neg(var_184);
                    // c1x = -sx                                                              <L 801>
                    var_226 = wp::neg(var_164);
                    // c1y = -sy                                                              <L 802>
                    var_227 = wp::neg(var_174);
                    // c1z = -sz                                                              <L 803>
                    var_228 = wp::neg(var_184);
                }
                if (!var_222) {
                    // elif edge_id == 4:  # 4-5                                              <L 804>
                    var_230 = (var_4 == var_229);
                    if (var_230) {
                        // c0x = -sx                                                          <L 805>
                        var_231 = wp::neg(var_164);
                        // c0y = -sy                                                          <L 806>
                        var_232 = wp::neg(var_174);
                        // c0z = sz                                                           <L 807>
                        var_233 = wp::copy(var_184);
                        // c1x = sx                                                           <L 808>
                        var_234 = wp::copy(var_164);
                        // c1y = -sy                                                          <L 809>
                        var_235 = wp::neg(var_174);
                        // c1z = sz                                                           <L 810>
                        var_236 = wp::copy(var_184);
                    }
                    if (!var_230) {
                        // elif edge_id == 5:  # 5-6                                          <L 811>
                        var_238 = (var_4 == var_237);
                        if (var_238) {
                            // c0x = sx                                                       <L 812>
                            var_239 = wp::copy(var_164);
                            // c0y = -sy                                                      <L 813>
                            var_240 = wp::neg(var_174);
                            // c0z = sz                                                       <L 814>
                            var_241 = wp::copy(var_184);
                            // c1x = sx                                                       <L 815>
                            var_242 = wp::copy(var_164);
                            // c1y = sy                                                       <L 816>
                            var_243 = wp::copy(var_174);
                            // c1z = sz                                                       <L 817>
                            var_244 = wp::copy(var_184);
                        }
                        if (!var_238) {
                            // elif edge_id == 6:  # 6-7                                      <L 818>
                            var_246 = (var_4 == var_245);
                            if (var_246) {
                                // c0x = sx                                                   <L 819>
                                var_247 = wp::copy(var_164);
                                // c0y = sy                                                   <L 820>
                                var_248 = wp::copy(var_174);
                                // c0z = sz                                                   <L 821>
                                var_249 = wp::copy(var_184);
                                // c1x = -sx                                                  <L 822>
                                var_250 = wp::neg(var_164);
                                // c1y = sy                                                   <L 823>
                                var_251 = wp::copy(var_174);
                                // c1z = sz                                                   <L 824>
                                var_252 = wp::copy(var_184);
                            }
                            if (!var_246) {
                                // elif edge_id == 7:  # 7-4                                  <L 825>
                                var_254 = (var_4 == var_253);
                                if (var_254) {
                                    // c0x = -sx                                              <L 826>
                                    var_255 = wp::neg(var_164);
                                    // c0y = sy                                               <L 827>
                                    var_256 = wp::copy(var_174);
                                    // c0z = sz                                               <L 828>
                                    var_257 = wp::copy(var_184);
                                    // c1x = -sx                                              <L 829>
                                    var_258 = wp::neg(var_164);
                                    // c1y = -sy                                              <L 830>
                                    var_259 = wp::neg(var_174);
                                    // c1z = sz                                               <L 831>
                                    var_260 = wp::copy(var_184);
                                }
                                if (!var_254) {
                                    // elif edge_id == 8:  # 0-4                              <L 832>
                                    var_262 = (var_4 == var_261);
                                    if (var_262) {
                                        // c0x = -sx                                          <L 833>
                                        var_263 = wp::neg(var_164);
                                        // c0y = -sy                                          <L 834>
                                        var_264 = wp::neg(var_174);
                                        // c0z = -sz                                          <L 835>
                                        var_265 = wp::neg(var_184);
                                        // c1x = -sx                                          <L 836>
                                        var_266 = wp::neg(var_164);
                                        // c1y = -sy                                          <L 837>
                                        var_267 = wp::neg(var_174);
                                        // c1z = sz                                           <L 838>
                                        var_268 = wp::copy(var_184);
                                    }
                                    if (!var_262) {
                                        // elif edge_id == 9:  # 1-5                          <L 839>
                                        var_270 = (var_4 == var_269);
                                        if (var_270) {
                                            // c0x = sx                                       <L 840>
                                            var_271 = wp::copy(var_164);
                                            // c0y = -sy                                      <L 841>
                                            var_272 = wp::neg(var_174);
                                            // c0z = -sz                                      <L 842>
                                            var_273 = wp::neg(var_184);
                                            // c1x = sx                                       <L 843>
                                            var_274 = wp::copy(var_164);
                                            // c1y = -sy                                      <L 844>
                                            var_275 = wp::neg(var_174);
                                            // c1z = sz                                       <L 845>
                                            var_276 = wp::copy(var_184);
                                        }
                                        if (!var_270) {
                                            // elif edge_id == 10:  # 2-6                     <L 846>
                                            var_278 = (var_4 == var_277);
                                            if (var_278) {
                                                // c0x = sx                                   <L 847>
                                                var_279 = wp::copy(var_164);
                                                // c0y = sy                                   <L 848>
                                                var_280 = wp::copy(var_174);
                                                // c0z = -sz                                  <L 849>
                                                var_281 = wp::neg(var_184);
                                                // c1x = sx                                   <L 850>
                                                var_282 = wp::copy(var_164);
                                                // c1y = sy                                   <L 851>
                                                var_283 = wp::copy(var_174);
                                                // c1z = sz                                   <L 852>
                                                var_284 = wp::copy(var_184);
                                            }
                                            if (!var_278) {
                                                // elif edge_id == 11:  # 3-7                 <L 853>
                                                var_286 = (var_4 == var_285);
                                                if (var_286) {
                                                    // c0x = -sx                              <L 854>
                                                    var_287 = wp::neg(var_164);
                                                    // c0y = sy                               <L 855>
                                                    var_288 = wp::copy(var_174);
                                                    // c0z = -sz                              <L 856>
                                                    var_289 = wp::neg(var_184);
                                                    // c1x = -sx                              <L 857>
                                                    var_290 = wp::neg(var_164);
                                                    // c1y = sy                               <L 858>
                                                    var_291 = wp::copy(var_174);
                                                    // c1z = sz                               <L 859>
                                                    var_292 = wp::copy(var_184);
                                                }
                                                var_293 = wp::where(var_286, var_287, var_186);
                                                var_294 = wp::where(var_286, var_288, var_188);
                                                var_295 = wp::where(var_286, var_289, var_190);
                                                var_296 = wp::where(var_286, var_290, var_192);
                                                var_297 = wp::where(var_286, var_291, var_194);
                                                var_298 = wp::where(var_286, var_292, var_196);
                                            }
                                            var_299 = wp::where(var_278, var_279, var_293);
                                            var_300 = wp::where(var_278, var_280, var_294);
                                            var_301 = wp::where(var_278, var_281, var_295);
                                            var_302 = wp::where(var_278, var_282, var_296);
                                            var_303 = wp::where(var_278, var_283, var_297);
                                            var_304 = wp::where(var_278, var_284, var_298);
                                        }
                                        var_305 = wp::where(var_270, var_271, var_299);
                                        var_306 = wp::where(var_270, var_272, var_300);
                                        var_307 = wp::where(var_270, var_273, var_301);
                                        var_308 = wp::where(var_270, var_274, var_302);
                                        var_309 = wp::where(var_270, var_275, var_303);
                                        var_310 = wp::where(var_270, var_276, var_304);
                                    }
                                    var_311 = wp::where(var_262, var_263, var_305);
                                    var_312 = wp::where(var_262, var_264, var_306);
                                    var_313 = wp::where(var_262, var_265, var_307);
                                    var_314 = wp::where(var_262, var_266, var_308);
                                    var_315 = wp::where(var_262, var_267, var_309);
                                    var_316 = wp::where(var_262, var_268, var_310);
                                }
                                var_317 = wp::where(var_254, var_255, var_311);
                                var_318 = wp::where(var_254, var_256, var_312);
                                var_319 = wp::where(var_254, var_257, var_313);
                                var_320 = wp::where(var_254, var_258, var_314);
                                var_321 = wp::where(var_254, var_259, var_315);
                                var_322 = wp::where(var_254, var_260, var_316);
                            }
                            var_323 = wp::where(var_246, var_247, var_317);
                            var_324 = wp::where(var_246, var_248, var_318);
                            var_325 = wp::where(var_246, var_249, var_319);
                            var_326 = wp::where(var_246, var_250, var_320);
                            var_327 = wp::where(var_246, var_251, var_321);
                            var_328 = wp::where(var_246, var_252, var_322);
                        }
                        var_329 = wp::where(var_238, var_239, var_323);
                        var_330 = wp::where(var_238, var_240, var_324);
                        var_331 = wp::where(var_238, var_241, var_325);
                        var_332 = wp::where(var_238, var_242, var_326);
                        var_333 = wp::where(var_238, var_243, var_327);
                        var_334 = wp::where(var_238, var_244, var_328);
                    }
                    var_335 = wp::where(var_230, var_231, var_329);
                    var_336 = wp::where(var_230, var_232, var_330);
                    var_337 = wp::where(var_230, var_233, var_331);
                    var_338 = wp::where(var_230, var_234, var_332);
                    var_339 = wp::where(var_230, var_235, var_333);
                    var_340 = wp::where(var_230, var_236, var_334);
                }
                var_341 = wp::where(var_222, var_223, var_335);
                var_342 = wp::where(var_222, var_224, var_336);
                var_343 = wp::where(var_222, var_225, var_337);
                var_344 = wp::where(var_222, var_226, var_338);
                var_345 = wp::where(var_222, var_227, var_339);
                var_346 = wp::where(var_222, var_228, var_340);
            }
            var_347 = wp::where(var_214, var_215, var_341);
            var_348 = wp::where(var_214, var_216, var_342);
            var_349 = wp::where(var_214, var_217, var_343);
            var_350 = wp::where(var_214, var_218, var_344);
            var_351 = wp::where(var_214, var_219, var_345);
            var_352 = wp::where(var_214, var_220, var_346);
        }
        var_353 = wp::where(var_206, var_207, var_347);
        var_354 = wp::where(var_206, var_208, var_348);
        var_355 = wp::where(var_206, var_209, var_349);
        var_356 = wp::where(var_206, var_210, var_350);
        var_357 = wp::where(var_206, var_211, var_351);
        var_358 = wp::where(var_206, var_212, var_352);
    }
    var_359 = wp::where(var_198, var_199, var_353);
    var_360 = wp::where(var_198, var_200, var_354);
    var_361 = wp::where(var_198, var_201, var_355);
    var_362 = wp::where(var_198, var_202, var_356);
    var_363 = wp::where(var_198, var_203, var_357);
    var_364 = wp::where(var_198, var_204, var_358);
    // local0 = wp.vec3(c0x, c0y, c0z)                                                        <L 861>
    var_365 = wp::vec_t<3, wp::float32>(var_359, var_360, var_361);
    // local1 = wp.vec3(c1x, c1y, c1z)                                                        <L 862>
    var_366 = wp::vec_t<3, wp::float32>(var_362, var_363, var_364);
    // inertia_rot = wp.quat_from_matrix(rot)                                                 <L 865>
    var_367 = wp::quat_from_matrix(var_149);
    // local0 = wp.quat_rotate(inertia_rot, local0)                                           <L 866>
    var_368 = wp::quat_rotate(var_367, var_365);
    // local1 = wp.quat_rotate(inertia_rot, local1)                                           <L 867>
    var_369 = wp::quat_rotate(var_367, var_366);
    // body_tf = body_q[body_id]                                                              <L 870>
    var_370 = wp::address(var_body_q, var_2);
    var_372 = wp::load(var_370);
    var_371 = wp::copy(var_372);
    // body_rot = wp.transform_get_rotation(body_tf)                                          <L 871>
    var_373 = wp::transform_get_rotation(var_371);
    // body_pos = wp.transform_get_translation(body_tf)                                       <L 872>
    var_374 = wp::transform_get_translation(var_371);
    // com = body_com[body_id]                                                                <L 873>
    var_375 = wp::address(var_body_com, var_2);
    var_377 = wp::load(var_375);
    var_376 = wp::copy(var_377);
    // world_com = body_pos + wp.quat_rotate(body_rot, com)                                   <L 876>
    var_378 = wp::quat_rotate(var_373, var_376);
    var_379 = wp::add(var_374, var_378);
    // world0 = world_com + wp.quat_rotate(body_rot, local0)                                  <L 878>
    var_380 = wp::quat_rotate(var_373, var_368);
    var_381 = wp::add(var_379, var_380);
    // world1 = world_com + wp.quat_rotate(body_rot, local1)                                  <L 879>
    var_382 = wp::quat_rotate(var_373, var_369);
    var_383 = wp::add(var_379, var_382);
    // if world_offsets and world_idx >= 0 and world_idx < world_offsets.shape[0]:            <L 882>
    var_384 = var_world_offsets;
    if (var_384) {
        var_386 = (var_17 >= var_385);
        var_384 = var_384 && var_386;
    }
    if (var_384) {
        var_387 = &(var_world_offsets.shape);
        var_390 = wp::load(var_387);
        var_389 = wp::extract(var_390, var_388);
        var_391 = (var_17 < var_389);
        var_384 = var_384 && var_391;
    }
    if (var_384) {
        // offset = world_offsets[world_idx]                                                  <L 883>
        var_392 = wp::address(var_world_offsets, var_17);
        var_394 = wp::load(var_392);
        var_393 = wp::copy(var_394);
        // world0 = world0 + offset                                                           <L 884>
        var_395 = wp::add(var_381, var_393);
        // world1 = world1 + offset                                                           <L 885>
        var_396 = wp::add(var_383, var_393);
    }
    var_397 = wp::where(var_384, var_395, var_381);
    var_398 = wp::where(var_384, var_396, var_383);
    // world0 = wp.transform_point(layer_xform, world0)                                       <L 888>
    var_399 = wp::transform_point(var_layer_xform, var_397);
    // world1 = wp.transform_point(layer_xform, world1)                                       <L 889>
    var_400 = wp::transform_point(var_layer_xform, var_398);
    // line_starts[tid] = world0                                                              <L 891>
    wp::array_store(var_line_starts, var_0, var_399);
    // line_ends[tid] = world1                                                                <L 892>
    wp::array_store(var_line_ends, var_0, var_400);
    // line_colors[tid] = color                                                               <L 893>
    wp::array_store(var_line_colors, var_0, var_color);
}



void compute_inertia_box_lines_56517d50_cpu_kernel_backward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_compute_inertia_box_lines_56517d50 *_wp_args,
    wp_args_compute_inertia_box_lines_56517d50 *_wp_adj_args)
{
    //---------
    // argument vars
    wp::array_t<wp::transform_t<wp::float32>> var_body_q = _wp_args->body_q;
    wp::array_t<wp::vec_t<3, wp::float32>> var_body_com = _wp_args->body_com;
    wp::array_t<wp::mat_t<3, 3, wp::float32>> var_body_inertia = _wp_args->body_inertia;
    wp::array_t<wp::float32> var_body_inv_mass = _wp_args->body_inv_mass;
    wp::array_t<wp::int32> var_body_world = _wp_args->body_world;
    wp::array_t<wp::vec_t<3, wp::float32>> var_world_offsets = _wp_args->world_offsets;
    wp::transform_t<wp::float32> var_layer_xform = _wp_args->layer_xform;
    wp::array_t<wp::int32> var_visible_worlds_mask = _wp_args->visible_worlds_mask;
    wp::vec_t<3, wp::float32> var_color = _wp_args->color;
    wp::array_t<wp::vec_t<3, wp::float32>> var_line_starts = _wp_args->line_starts;
    wp::array_t<wp::vec_t<3, wp::float32>> var_line_ends = _wp_args->line_ends;
    wp::array_t<wp::vec_t<3, wp::float32>> var_line_colors = _wp_args->line_colors;
    wp::array_t<wp::transform_t<wp::float32>> adj_body_q = _wp_adj_args->body_q;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_body_com = _wp_adj_args->body_com;
    wp::array_t<wp::mat_t<3, 3, wp::float32>> adj_body_inertia = _wp_adj_args->body_inertia;
    wp::array_t<wp::float32> adj_body_inv_mass = _wp_adj_args->body_inv_mass;
    wp::array_t<wp::int32> adj_body_world = _wp_adj_args->body_world;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_world_offsets = _wp_adj_args->world_offsets;
    wp::transform_t<wp::float32> adj_layer_xform = _wp_adj_args->layer_xform;
    wp::array_t<wp::int32> adj_visible_worlds_mask = _wp_adj_args->visible_worlds_mask;
    wp::vec_t<3, wp::float32> adj_color = _wp_adj_args->color;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_line_starts = _wp_adj_args->line_starts;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_line_ends = _wp_adj_args->line_ends;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_line_colors = _wp_adj_args->line_colors;
    //---------
    // primal vars
    wp::int32 var_0;
    const wp::int32 var_1 = 12;
    wp::int32 var_2;
    const wp::int32 var_3 = 12;
    wp::int32 var_4;
    const wp::float32 var_5 = NAN;
    const wp::float32 var_6 = NAN;
    const wp::float32 var_7 = NAN;
    const wp::float32 var_8 = NAN;
    const wp::float32 var_9 = NAN;
    const wp::float32 var_10 = NAN;
    wp::vec_t<3, wp::float32> var_11;
    const wp::float32 var_12 = 0.0;
    const wp::float32 var_13 = 0.0;
    const wp::float32 var_14 = 0.0;
    wp::vec_t<3, wp::float32> var_15;
    wp::int32* var_16;
    wp::int32 var_17;
    wp::int32 var_18;
    const wp::int32 var_19 = 0;
    bool var_20;
    wp::int32* var_21;
    const wp::int32 var_22 = 0;
    bool var_23;
    wp::int32 var_24;
    wp::float32* var_25;
    wp::float32 var_26;
    wp::float32 var_27;
    const wp::float32 var_28 = 0.0;
    bool var_29;
    wp::mat_t<3, 3, wp::float32>* var_30;
    wp::mat_t<3, 3, wp::float32> var_31;
    wp::vec_t<3, wp::float32> var_32;
    wp::mat_t<3, 3, wp::float32> var_33;
    wp::float32 var_34;
    wp::float32 var_35;
    bool var_36;
    const wp::float32 var_37 = 0.0;
    bool var_38;
    const wp::float32 var_39 = 1.01;
    wp::float32 var_40;
    bool var_41;
    const wp::int32 var_42 = 3;
    wp::mat_t<3, 3, wp::float32> var_43;
    const wp::float32 var_44 = 0.0;
    bool var_45;
    const wp::int32 var_46 = 0;
    wp::float32 var_47;
    const wp::int32 var_48 = 1;
    wp::float32 var_49;
    wp::float32 var_50;
    wp::float32 var_51;
    const wp::int32 var_52 = 0;
    wp::float32 var_53;
    const wp::int32 var_54 = 2;
    wp::float32 var_55;
    wp::float32 var_56;
    wp::float32 var_57;
    const wp::int32 var_58 = 1;
    wp::float32 var_59;
    const wp::int32 var_60 = 2;
    wp::float32 var_61;
    wp::float32 var_62;
    wp::float32 var_63;
    wp::float32 var_64;
    wp::float32 var_65;
    const wp::float32 var_66 = 0.01;
    wp::float32 var_67;
    bool var_68;
    bool var_69;
    bool var_70;
    bool var_71;
    const wp::int32 var_72 = 0;
    const wp::int32 var_73 = 0;
    wp::float32 var_74;
    const wp::int32 var_75 = 1;
    const wp::int32 var_76 = 0;
    wp::float32 var_77;
    const wp::int32 var_78 = 2;
    const wp::int32 var_79 = 0;
    wp::float32 var_80;
    wp::vec_t<3, wp::float32> var_81;
    bool var_82;
    const wp::int32 var_83 = 0;
    const wp::int32 var_84 = 1;
    wp::float32 var_85;
    const wp::int32 var_86 = 1;
    const wp::int32 var_87 = 1;
    wp::float32 var_88;
    const wp::int32 var_89 = 2;
    const wp::int32 var_90 = 1;
    wp::float32 var_91;
    wp::vec_t<3, wp::float32> var_92;
    const wp::int32 var_93 = 0;
    const wp::int32 var_94 = 2;
    wp::float32 var_95;
    const wp::int32 var_96 = 1;
    const wp::int32 var_97 = 2;
    wp::float32 var_98;
    const wp::int32 var_99 = 2;
    const wp::int32 var_100 = 2;
    wp::float32 var_101;
    wp::vec_t<3, wp::float32> var_102;
    wp::vec_t<3, wp::float32> var_103;
    wp::vec_t<3, wp::float32> var_104;
    wp::vec_t<3, wp::float32> var_105;
    wp::vec_t<3, wp::float32> var_106;
    wp::vec_t<3, wp::float32> var_107;
    wp::vec_t<3, wp::float32> var_108;
    wp::vec_t<3, wp::float32> var_109;
    wp::vec_t<3, wp::float32> var_110;
    bool var_111;
    bool var_112;
    bool var_113;
    wp::vec_t<3, wp::float32> var_114;
    wp::vec_t<3, wp::float32> var_115;
    wp::vec_t<3, wp::float32> var_116;
    bool var_117;
    wp::vec_t<3, wp::float32> var_118;
    wp::vec_t<3, wp::float32> var_119;
    wp::vec_t<3, wp::float32> var_120;
    wp::vec_t<3, wp::float32> var_121;
    wp::vec_t<3, wp::float32> var_122;
    wp::vec_t<3, wp::float32> var_123;
    wp::vec_t<3, wp::float32> var_124;
    wp::vec_t<3, wp::float32> var_125;
    wp::vec_t<3, wp::float32> var_126;
    const wp::int32 var_127 = 0;
    wp::float32 var_128;
    const wp::int32 var_129 = 1;
    wp::float32 var_130;
    const wp::int32 var_131 = 2;
    wp::float32 var_132;
    const wp::int32 var_133 = 0;
    wp::float32 var_134;
    const wp::int32 var_135 = 1;
    wp::float32 var_136;
    const wp::int32 var_137 = 2;
    wp::float32 var_138;
    const wp::int32 var_139 = 0;
    wp::float32 var_140;
    const wp::int32 var_141 = 1;
    wp::float32 var_142;
    const wp::int32 var_143 = 2;
    wp::float32 var_144;
    wp::mat_t<3, 3, wp::float32> var_145;
    wp::mat_t<3, 3, wp::float32> var_146;
    wp::mat_t<3, 3, wp::float32> var_147;
    wp::mat_t<3, 3, wp::float32> var_148;
    wp::mat_t<3, 3, wp::float32> var_149;
    wp::vec_t<3, wp::float32> var_150;
    const wp::float32 var_151 = 12.0;
    const wp::float32 var_152 = 8.0;
    wp::float32 var_153;
    wp::vec_t<3, wp::float32> var_154;
    const wp::int32 var_155 = 2;
    wp::float32 var_156;
    const wp::int32 var_157 = 1;
    wp::float32 var_158;
    wp::float32 var_159;
    const wp::int32 var_160 = 0;
    wp::float32 var_161;
    wp::float32 var_162;
    wp::float32 var_163;
    wp::float32 var_164;
    const wp::int32 var_165 = 0;
    wp::float32 var_166;
    const wp::int32 var_167 = 2;
    wp::float32 var_168;
    wp::float32 var_169;
    const wp::int32 var_170 = 1;
    wp::float32 var_171;
    wp::float32 var_172;
    wp::float32 var_173;
    wp::float32 var_174;
    const wp::int32 var_175 = 1;
    wp::float32 var_176;
    const wp::int32 var_177 = 0;
    wp::float32 var_178;
    wp::float32 var_179;
    const wp::int32 var_180 = 2;
    wp::float32 var_181;
    wp::float32 var_182;
    wp::float32 var_183;
    wp::float32 var_184;
    const wp::float32 var_185 = 0.0;
    wp::float32 var_186;
    const wp::float32 var_187 = 0.0;
    wp::float32 var_188;
    const wp::float32 var_189 = 0.0;
    wp::float32 var_190;
    const wp::float32 var_191 = 0.0;
    wp::float32 var_192;
    const wp::float32 var_193 = 0.0;
    wp::float32 var_194;
    const wp::float32 var_195 = 0.0;
    wp::float32 var_196;
    const wp::int32 var_197 = 0;
    bool var_198;
    wp::float32 var_199;
    wp::float32 var_200;
    wp::float32 var_201;
    wp::float32 var_202;
    wp::float32 var_203;
    wp::float32 var_204;
    const wp::int32 var_205 = 1;
    bool var_206;
    wp::float32 var_207;
    wp::float32 var_208;
    wp::float32 var_209;
    wp::float32 var_210;
    wp::float32 var_211;
    wp::float32 var_212;
    const wp::int32 var_213 = 2;
    bool var_214;
    wp::float32 var_215;
    wp::float32 var_216;
    wp::float32 var_217;
    wp::float32 var_218;
    wp::float32 var_219;
    wp::float32 var_220;
    const wp::int32 var_221 = 3;
    bool var_222;
    wp::float32 var_223;
    wp::float32 var_224;
    wp::float32 var_225;
    wp::float32 var_226;
    wp::float32 var_227;
    wp::float32 var_228;
    const wp::int32 var_229 = 4;
    bool var_230;
    wp::float32 var_231;
    wp::float32 var_232;
    wp::float32 var_233;
    wp::float32 var_234;
    wp::float32 var_235;
    wp::float32 var_236;
    const wp::int32 var_237 = 5;
    bool var_238;
    wp::float32 var_239;
    wp::float32 var_240;
    wp::float32 var_241;
    wp::float32 var_242;
    wp::float32 var_243;
    wp::float32 var_244;
    const wp::int32 var_245 = 6;
    bool var_246;
    wp::float32 var_247;
    wp::float32 var_248;
    wp::float32 var_249;
    wp::float32 var_250;
    wp::float32 var_251;
    wp::float32 var_252;
    const wp::int32 var_253 = 7;
    bool var_254;
    wp::float32 var_255;
    wp::float32 var_256;
    wp::float32 var_257;
    wp::float32 var_258;
    wp::float32 var_259;
    wp::float32 var_260;
    const wp::int32 var_261 = 8;
    bool var_262;
    wp::float32 var_263;
    wp::float32 var_264;
    wp::float32 var_265;
    wp::float32 var_266;
    wp::float32 var_267;
    wp::float32 var_268;
    const wp::int32 var_269 = 9;
    bool var_270;
    wp::float32 var_271;
    wp::float32 var_272;
    wp::float32 var_273;
    wp::float32 var_274;
    wp::float32 var_275;
    wp::float32 var_276;
    const wp::int32 var_277 = 10;
    bool var_278;
    wp::float32 var_279;
    wp::float32 var_280;
    wp::float32 var_281;
    wp::float32 var_282;
    wp::float32 var_283;
    wp::float32 var_284;
    const wp::int32 var_285 = 11;
    bool var_286;
    wp::float32 var_287;
    wp::float32 var_288;
    wp::float32 var_289;
    wp::float32 var_290;
    wp::float32 var_291;
    wp::float32 var_292;
    wp::float32 var_293;
    wp::float32 var_294;
    wp::float32 var_295;
    wp::float32 var_296;
    wp::float32 var_297;
    wp::float32 var_298;
    wp::float32 var_299;
    wp::float32 var_300;
    wp::float32 var_301;
    wp::float32 var_302;
    wp::float32 var_303;
    wp::float32 var_304;
    wp::float32 var_305;
    wp::float32 var_306;
    wp::float32 var_307;
    wp::float32 var_308;
    wp::float32 var_309;
    wp::float32 var_310;
    wp::float32 var_311;
    wp::float32 var_312;
    wp::float32 var_313;
    wp::float32 var_314;
    wp::float32 var_315;
    wp::float32 var_316;
    wp::float32 var_317;
    wp::float32 var_318;
    wp::float32 var_319;
    wp::float32 var_320;
    wp::float32 var_321;
    wp::float32 var_322;
    wp::float32 var_323;
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
    wp::float32 var_336;
    wp::float32 var_337;
    wp::float32 var_338;
    wp::float32 var_339;
    wp::float32 var_340;
    wp::float32 var_341;
    wp::float32 var_342;
    wp::float32 var_343;
    wp::float32 var_344;
    wp::float32 var_345;
    wp::float32 var_346;
    wp::float32 var_347;
    wp::float32 var_348;
    wp::float32 var_349;
    wp::float32 var_350;
    wp::float32 var_351;
    wp::float32 var_352;
    wp::float32 var_353;
    wp::float32 var_354;
    wp::float32 var_355;
    wp::float32 var_356;
    wp::float32 var_357;
    wp::float32 var_358;
    wp::float32 var_359;
    wp::float32 var_360;
    wp::float32 var_361;
    wp::float32 var_362;
    wp::float32 var_363;
    wp::float32 var_364;
    wp::vec_t<3, wp::float32> var_365;
    wp::vec_t<3, wp::float32> var_366;
    wp::quat_t<wp::float32> var_367;
    wp::vec_t<3, wp::float32> var_368;
    wp::vec_t<3, wp::float32> var_369;
    wp::transform_t<wp::float32>* var_370;
    wp::transform_t<wp::float32> var_371;
    wp::transform_t<wp::float32> var_372;
    wp::quat_t<wp::float32> var_373;
    wp::vec_t<3, wp::float32> var_374;
    wp::vec_t<3, wp::float32>* var_375;
    wp::vec_t<3, wp::float32> var_376;
    wp::vec_t<3, wp::float32> var_377;
    wp::vec_t<3, wp::float32> var_378;
    wp::vec_t<3, wp::float32> var_379;
    wp::vec_t<3, wp::float32> var_380;
    wp::vec_t<3, wp::float32> var_381;
    wp::vec_t<3, wp::float32> var_382;
    wp::vec_t<3, wp::float32> var_383;
    bool var_384;
    const wp::int32 var_385 = 0;
    bool var_386;
    wp::shape_t* var_387;
    const wp::int32 var_388 = 0;
    wp::int32 var_389;
    wp::shape_t var_390;
    bool var_391;
    wp::vec_t<3, wp::float32>* var_392;
    wp::vec_t<3, wp::float32> var_393;
    wp::vec_t<3, wp::float32> var_394;
    wp::vec_t<3, wp::float32> var_395;
    wp::vec_t<3, wp::float32> var_396;
    wp::vec_t<3, wp::float32> var_397;
    wp::vec_t<3, wp::float32> var_398;
    wp::vec_t<3, wp::float32> var_399;
    wp::vec_t<3, wp::float32> var_400;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    wp::int32 adj_1 = {};
    wp::int32 adj_2 = {};
    wp::int32 adj_3 = {};
    wp::int32 adj_4 = {};
    wp::float32 adj_5 = {};
    wp::float32 adj_6 = {};
    wp::float32 adj_7 = {};
    wp::float32 adj_8 = {};
    wp::float32 adj_9 = {};
    wp::float32 adj_10 = {};
    wp::vec_t<3, wp::float32> adj_11 = {};
    wp::float32 adj_12 = {};
    wp::float32 adj_13 = {};
    wp::float32 adj_14 = {};
    wp::vec_t<3, wp::float32> adj_15 = {};
    wp::int32 adj_16 = {};
    wp::int32 adj_17 = {};
    wp::int32 adj_18 = {};
    wp::int32 adj_19 = {};
    bool adj_20 = {};
    wp::int32 adj_21 = {};
    wp::int32 adj_22 = {};
    bool adj_23 = {};
    wp::int32 adj_24 = {};
    wp::float32 adj_25 = {};
    wp::float32 adj_26 = {};
    wp::float32 adj_27 = {};
    wp::float32 adj_28 = {};
    bool adj_29 = {};
    wp::mat_t<3, 3, wp::float32> adj_30 = {};
    wp::mat_t<3, 3, wp::float32> adj_31 = {};
    wp::vec_t<3, wp::float32> adj_32 = {};
    wp::mat_t<3, 3, wp::float32> adj_33 = {};
    wp::float32 adj_34 = {};
    wp::float32 adj_35 = {};
    bool adj_36 = {};
    wp::float32 adj_37 = {};
    bool adj_38 = {};
    wp::float32 adj_39 = {};
    wp::float32 adj_40 = {};
    bool adj_41 = {};
    wp::int32 adj_42 = {};
    wp::mat_t<3, 3, wp::float32> adj_43 = {};
    wp::float32 adj_44 = {};
    bool adj_45 = {};
    wp::int32 adj_46 = {};
    wp::float32 adj_47 = {};
    wp::int32 adj_48 = {};
    wp::float32 adj_49 = {};
    wp::float32 adj_50 = {};
    wp::float32 adj_51 = {};
    wp::int32 adj_52 = {};
    wp::float32 adj_53 = {};
    wp::int32 adj_54 = {};
    wp::float32 adj_55 = {};
    wp::float32 adj_56 = {};
    wp::float32 adj_57 = {};
    wp::int32 adj_58 = {};
    wp::float32 adj_59 = {};
    wp::int32 adj_60 = {};
    wp::float32 adj_61 = {};
    wp::float32 adj_62 = {};
    wp::float32 adj_63 = {};
    wp::float32 adj_64 = {};
    wp::float32 adj_65 = {};
    wp::float32 adj_66 = {};
    wp::float32 adj_67 = {};
    bool adj_68 = {};
    bool adj_69 = {};
    bool adj_70 = {};
    bool adj_71 = {};
    wp::int32 adj_72 = {};
    wp::int32 adj_73 = {};
    wp::float32 adj_74 = {};
    wp::int32 adj_75 = {};
    wp::int32 adj_76 = {};
    wp::float32 adj_77 = {};
    wp::int32 adj_78 = {};
    wp::int32 adj_79 = {};
    wp::float32 adj_80 = {};
    wp::vec_t<3, wp::float32> adj_81 = {};
    bool adj_82 = {};
    wp::int32 adj_83 = {};
    wp::int32 adj_84 = {};
    wp::float32 adj_85 = {};
    wp::int32 adj_86 = {};
    wp::int32 adj_87 = {};
    wp::float32 adj_88 = {};
    wp::int32 adj_89 = {};
    wp::int32 adj_90 = {};
    wp::float32 adj_91 = {};
    wp::vec_t<3, wp::float32> adj_92 = {};
    wp::int32 adj_93 = {};
    wp::int32 adj_94 = {};
    wp::float32 adj_95 = {};
    wp::int32 adj_96 = {};
    wp::int32 adj_97 = {};
    wp::float32 adj_98 = {};
    wp::int32 adj_99 = {};
    wp::int32 adj_100 = {};
    wp::float32 adj_101 = {};
    wp::vec_t<3, wp::float32> adj_102 = {};
    wp::vec_t<3, wp::float32> adj_103 = {};
    wp::vec_t<3, wp::float32> adj_104 = {};
    wp::vec_t<3, wp::float32> adj_105 = {};
    wp::vec_t<3, wp::float32> adj_106 = {};
    wp::vec_t<3, wp::float32> adj_107 = {};
    wp::vec_t<3, wp::float32> adj_108 = {};
    wp::vec_t<3, wp::float32> adj_109 = {};
    wp::vec_t<3, wp::float32> adj_110 = {};
    bool adj_111 = {};
    bool adj_112 = {};
    bool adj_113 = {};
    wp::vec_t<3, wp::float32> adj_114 = {};
    wp::vec_t<3, wp::float32> adj_115 = {};
    wp::vec_t<3, wp::float32> adj_116 = {};
    bool adj_117 = {};
    wp::vec_t<3, wp::float32> adj_118 = {};
    wp::vec_t<3, wp::float32> adj_119 = {};
    wp::vec_t<3, wp::float32> adj_120 = {};
    wp::vec_t<3, wp::float32> adj_121 = {};
    wp::vec_t<3, wp::float32> adj_122 = {};
    wp::vec_t<3, wp::float32> adj_123 = {};
    wp::vec_t<3, wp::float32> adj_124 = {};
    wp::vec_t<3, wp::float32> adj_125 = {};
    wp::vec_t<3, wp::float32> adj_126 = {};
    wp::int32 adj_127 = {};
    wp::float32 adj_128 = {};
    wp::int32 adj_129 = {};
    wp::float32 adj_130 = {};
    wp::int32 adj_131 = {};
    wp::float32 adj_132 = {};
    wp::int32 adj_133 = {};
    wp::float32 adj_134 = {};
    wp::int32 adj_135 = {};
    wp::float32 adj_136 = {};
    wp::int32 adj_137 = {};
    wp::float32 adj_138 = {};
    wp::int32 adj_139 = {};
    wp::float32 adj_140 = {};
    wp::int32 adj_141 = {};
    wp::float32 adj_142 = {};
    wp::int32 adj_143 = {};
    wp::float32 adj_144 = {};
    wp::mat_t<3, 3, wp::float32> adj_145 = {};
    wp::mat_t<3, 3, wp::float32> adj_146 = {};
    wp::mat_t<3, 3, wp::float32> adj_147 = {};
    wp::mat_t<3, 3, wp::float32> adj_148 = {};
    wp::mat_t<3, 3, wp::float32> adj_149 = {};
    wp::vec_t<3, wp::float32> adj_150 = {};
    wp::float32 adj_151 = {};
    wp::float32 adj_152 = {};
    wp::float32 adj_153 = {};
    wp::vec_t<3, wp::float32> adj_154 = {};
    wp::int32 adj_155 = {};
    wp::float32 adj_156 = {};
    wp::int32 adj_157 = {};
    wp::float32 adj_158 = {};
    wp::float32 adj_159 = {};
    wp::int32 adj_160 = {};
    wp::float32 adj_161 = {};
    wp::float32 adj_162 = {};
    wp::float32 adj_163 = {};
    wp::float32 adj_164 = {};
    wp::int32 adj_165 = {};
    wp::float32 adj_166 = {};
    wp::int32 adj_167 = {};
    wp::float32 adj_168 = {};
    wp::float32 adj_169 = {};
    wp::int32 adj_170 = {};
    wp::float32 adj_171 = {};
    wp::float32 adj_172 = {};
    wp::float32 adj_173 = {};
    wp::float32 adj_174 = {};
    wp::int32 adj_175 = {};
    wp::float32 adj_176 = {};
    wp::int32 adj_177 = {};
    wp::float32 adj_178 = {};
    wp::float32 adj_179 = {};
    wp::int32 adj_180 = {};
    wp::float32 adj_181 = {};
    wp::float32 adj_182 = {};
    wp::float32 adj_183 = {};
    wp::float32 adj_184 = {};
    wp::float32 adj_185 = {};
    wp::float32 adj_186 = {};
    wp::float32 adj_187 = {};
    wp::float32 adj_188 = {};
    wp::float32 adj_189 = {};
    wp::float32 adj_190 = {};
    wp::float32 adj_191 = {};
    wp::float32 adj_192 = {};
    wp::float32 adj_193 = {};
    wp::float32 adj_194 = {};
    wp::float32 adj_195 = {};
    wp::float32 adj_196 = {};
    wp::int32 adj_197 = {};
    bool adj_198 = {};
    wp::float32 adj_199 = {};
    wp::float32 adj_200 = {};
    wp::float32 adj_201 = {};
    wp::float32 adj_202 = {};
    wp::float32 adj_203 = {};
    wp::float32 adj_204 = {};
    wp::int32 adj_205 = {};
    bool adj_206 = {};
    wp::float32 adj_207 = {};
    wp::float32 adj_208 = {};
    wp::float32 adj_209 = {};
    wp::float32 adj_210 = {};
    wp::float32 adj_211 = {};
    wp::float32 adj_212 = {};
    wp::int32 adj_213 = {};
    bool adj_214 = {};
    wp::float32 adj_215 = {};
    wp::float32 adj_216 = {};
    wp::float32 adj_217 = {};
    wp::float32 adj_218 = {};
    wp::float32 adj_219 = {};
    wp::float32 adj_220 = {};
    wp::int32 adj_221 = {};
    bool adj_222 = {};
    wp::float32 adj_223 = {};
    wp::float32 adj_224 = {};
    wp::float32 adj_225 = {};
    wp::float32 adj_226 = {};
    wp::float32 adj_227 = {};
    wp::float32 adj_228 = {};
    wp::int32 adj_229 = {};
    bool adj_230 = {};
    wp::float32 adj_231 = {};
    wp::float32 adj_232 = {};
    wp::float32 adj_233 = {};
    wp::float32 adj_234 = {};
    wp::float32 adj_235 = {};
    wp::float32 adj_236 = {};
    wp::int32 adj_237 = {};
    bool adj_238 = {};
    wp::float32 adj_239 = {};
    wp::float32 adj_240 = {};
    wp::float32 adj_241 = {};
    wp::float32 adj_242 = {};
    wp::float32 adj_243 = {};
    wp::float32 adj_244 = {};
    wp::int32 adj_245 = {};
    bool adj_246 = {};
    wp::float32 adj_247 = {};
    wp::float32 adj_248 = {};
    wp::float32 adj_249 = {};
    wp::float32 adj_250 = {};
    wp::float32 adj_251 = {};
    wp::float32 adj_252 = {};
    wp::int32 adj_253 = {};
    bool adj_254 = {};
    wp::float32 adj_255 = {};
    wp::float32 adj_256 = {};
    wp::float32 adj_257 = {};
    wp::float32 adj_258 = {};
    wp::float32 adj_259 = {};
    wp::float32 adj_260 = {};
    wp::int32 adj_261 = {};
    bool adj_262 = {};
    wp::float32 adj_263 = {};
    wp::float32 adj_264 = {};
    wp::float32 adj_265 = {};
    wp::float32 adj_266 = {};
    wp::float32 adj_267 = {};
    wp::float32 adj_268 = {};
    wp::int32 adj_269 = {};
    bool adj_270 = {};
    wp::float32 adj_271 = {};
    wp::float32 adj_272 = {};
    wp::float32 adj_273 = {};
    wp::float32 adj_274 = {};
    wp::float32 adj_275 = {};
    wp::float32 adj_276 = {};
    wp::int32 adj_277 = {};
    bool adj_278 = {};
    wp::float32 adj_279 = {};
    wp::float32 adj_280 = {};
    wp::float32 adj_281 = {};
    wp::float32 adj_282 = {};
    wp::float32 adj_283 = {};
    wp::float32 adj_284 = {};
    wp::int32 adj_285 = {};
    bool adj_286 = {};
    wp::float32 adj_287 = {};
    wp::float32 adj_288 = {};
    wp::float32 adj_289 = {};
    wp::float32 adj_290 = {};
    wp::float32 adj_291 = {};
    wp::float32 adj_292 = {};
    wp::float32 adj_293 = {};
    wp::float32 adj_294 = {};
    wp::float32 adj_295 = {};
    wp::float32 adj_296 = {};
    wp::float32 adj_297 = {};
    wp::float32 adj_298 = {};
    wp::float32 adj_299 = {};
    wp::float32 adj_300 = {};
    wp::float32 adj_301 = {};
    wp::float32 adj_302 = {};
    wp::float32 adj_303 = {};
    wp::float32 adj_304 = {};
    wp::float32 adj_305 = {};
    wp::float32 adj_306 = {};
    wp::float32 adj_307 = {};
    wp::float32 adj_308 = {};
    wp::float32 adj_309 = {};
    wp::float32 adj_310 = {};
    wp::float32 adj_311 = {};
    wp::float32 adj_312 = {};
    wp::float32 adj_313 = {};
    wp::float32 adj_314 = {};
    wp::float32 adj_315 = {};
    wp::float32 adj_316 = {};
    wp::float32 adj_317 = {};
    wp::float32 adj_318 = {};
    wp::float32 adj_319 = {};
    wp::float32 adj_320 = {};
    wp::float32 adj_321 = {};
    wp::float32 adj_322 = {};
    wp::float32 adj_323 = {};
    wp::float32 adj_324 = {};
    wp::float32 adj_325 = {};
    wp::float32 adj_326 = {};
    wp::float32 adj_327 = {};
    wp::float32 adj_328 = {};
    wp::float32 adj_329 = {};
    wp::float32 adj_330 = {};
    wp::float32 adj_331 = {};
    wp::float32 adj_332 = {};
    wp::float32 adj_333 = {};
    wp::float32 adj_334 = {};
    wp::float32 adj_335 = {};
    wp::float32 adj_336 = {};
    wp::float32 adj_337 = {};
    wp::float32 adj_338 = {};
    wp::float32 adj_339 = {};
    wp::float32 adj_340 = {};
    wp::float32 adj_341 = {};
    wp::float32 adj_342 = {};
    wp::float32 adj_343 = {};
    wp::float32 adj_344 = {};
    wp::float32 adj_345 = {};
    wp::float32 adj_346 = {};
    wp::float32 adj_347 = {};
    wp::float32 adj_348 = {};
    wp::float32 adj_349 = {};
    wp::float32 adj_350 = {};
    wp::float32 adj_351 = {};
    wp::float32 adj_352 = {};
    wp::float32 adj_353 = {};
    wp::float32 adj_354 = {};
    wp::float32 adj_355 = {};
    wp::float32 adj_356 = {};
    wp::float32 adj_357 = {};
    wp::float32 adj_358 = {};
    wp::float32 adj_359 = {};
    wp::float32 adj_360 = {};
    wp::float32 adj_361 = {};
    wp::float32 adj_362 = {};
    wp::float32 adj_363 = {};
    wp::float32 adj_364 = {};
    wp::vec_t<3, wp::float32> adj_365 = {};
    wp::vec_t<3, wp::float32> adj_366 = {};
    wp::quat_t<wp::float32> adj_367 = {};
    wp::vec_t<3, wp::float32> adj_368 = {};
    wp::vec_t<3, wp::float32> adj_369 = {};
    wp::transform_t<wp::float32> adj_370 = {};
    wp::transform_t<wp::float32> adj_371 = {};
    wp::transform_t<wp::float32> adj_372 = {};
    wp::quat_t<wp::float32> adj_373 = {};
    wp::vec_t<3, wp::float32> adj_374 = {};
    wp::vec_t<3, wp::float32> adj_375 = {};
    wp::vec_t<3, wp::float32> adj_376 = {};
    wp::vec_t<3, wp::float32> adj_377 = {};
    wp::vec_t<3, wp::float32> adj_378 = {};
    wp::vec_t<3, wp::float32> adj_379 = {};
    wp::vec_t<3, wp::float32> adj_380 = {};
    wp::vec_t<3, wp::float32> adj_381 = {};
    wp::vec_t<3, wp::float32> adj_382 = {};
    wp::vec_t<3, wp::float32> adj_383 = {};
    bool adj_384 = {};
    wp::int32 adj_385 = {};
    bool adj_386 = {};
    wp::shape_t adj_387 = {};
    wp::int32 adj_388 = {};
    wp::int32 adj_389 = {};
    wp::shape_t adj_390 = {};
    bool adj_391 = {};
    wp::vec_t<3, wp::float32> adj_392 = {};
    wp::vec_t<3, wp::float32> adj_393 = {};
    wp::vec_t<3, wp::float32> adj_394 = {};
    wp::vec_t<3, wp::float32> adj_395 = {};
    wp::vec_t<3, wp::float32> adj_396 = {};
    wp::vec_t<3, wp::float32> adj_397 = {};
    wp::vec_t<3, wp::float32> adj_398 = {};
    wp::vec_t<3, wp::float32> adj_399 = {};
    wp::vec_t<3, wp::float32> adj_400 = {};
    //---------
    // forward
    // def compute_inertia_box_lines(                                                         <L 674>
    // tid = wp.tid()                                                                         <L 690>
    var_0 = builtin_tid1d();
    // body_id = tid // 12                                                                    <L 691>
    var_2 = wp::floordiv(var_0, var_1);
    // edge_id = tid % 12                                                                     <L 692>
    var_4 = wp::mod(var_0, var_3);
    // nan_line = wp.vec3(wp.nan, wp.nan, wp.nan)                                             <L 694>
    var_11 = wp::vec_t<3, wp::float32>(var_6, var_8, var_10);
    // zero_color = wp.vec3(0.0, 0.0, 0.0)                                                    <L 695>
    var_15 = wp::vec_t<3, wp::float32>(var_12, var_13, var_14);
    // world_idx = body_world[body_id]                                                        <L 698>
    var_16 = wp::address(var_body_world, var_2);
    var_18 = wp::load(var_16);
    var_17 = wp::copy(var_18);
    // if visible_worlds_mask:                                                                <L 699>
    if (var_visible_worlds_mask) {
        // if world_idx >= 0:                                                                 <L 700>
        var_20 = (var_17 >= var_19);
        if (var_20) {
            // if visible_worlds_mask[world_idx] == 0:                                        <L 701>
            var_21 = wp::address(var_visible_worlds_mask, var_17);
            var_24 = wp::load(var_21);
            var_23 = (var_24 == var_22);
            if (var_23) {
                // line_starts[tid] = nan_line                                                <L 702>
                // wp::array_store(var_line_starts, var_0, var_11);
                // line_ends[tid] = nan_line                                                  <L 703>
                // wp::array_store(var_line_ends, var_0, var_11);
                // line_colors[tid] = zero_color                                              <L 704>
                // wp::array_store(var_line_colors, var_0, var_15);
                // return                                                                     <L 705>
                goto label0;
            }
        }
    }
    // inv_m = body_inv_mass[body_id]                                                         <L 707>
    var_25 = wp::address(var_body_inv_mass, var_2);
    var_27 = wp::load(var_25);
    var_26 = wp::copy(var_27);
    // if inv_m == 0.0:                                                                       <L 708>
    var_29 = (var_26 == var_28);
    if (var_29) {
        // line_starts[tid] = nan_line                                                        <L 709>
        // wp::array_store(var_line_starts, var_0, var_11);
        // line_ends[tid] = nan_line                                                          <L 710>
        // wp::array_store(var_line_ends, var_0, var_11);
        // line_colors[tid] = zero_color                                                      <L 711>
        // wp::array_store(var_line_colors, var_0, var_15);
        // return                                                                             <L 712>
        goto label1;
    }
    // rot, principal_inertia = wp.eig3(body_inertia[body_id])                                <L 715>
    var_30 = wp::address(var_body_inertia, var_2);
    var_33 = wp::load(var_30);
    wp::eig3(var_33, var_31, var_32);
    // max_eig = wp.max(principal_inertia)                                                    <L 720>
    var_34 = wp::max(var_32);
    // min_eig = wp.min(principal_inertia)                                                    <L 721>
    var_35 = wp::min(var_32);
    // if min_eig > 0.0 and max_eig < 1.01 * min_eig:  # within 1% -> isotropic               <L 722>
    var_38 = (var_35 > var_37);
    var_36 = var_38;
    if (var_36) {
        var_40 = wp::mul(var_39, var_35);
        var_41 = (var_34 < var_40);
        var_36 = var_36 && var_41;
    }
    if (var_36) {
        // rot = wp.identity(3, float)                                                        <L 723>
        var_43 = wp::identity<3, wp::float32>();
    }
    if (!var_36) {
        // elif min_eig > 0.0:                                                                <L 724>
        var_45 = (var_35 > var_44);
        if (var_45) {
            // d01 = wp.abs(principal_inertia[0] - principal_inertia[1])                      <L 728>
            var_47 = wp::extract(var_32, var_46);
            var_49 = wp::extract(var_32, var_48);
            var_50 = wp::sub(var_47, var_49);
            var_51 = wp::abs(var_50);
            // d02 = wp.abs(principal_inertia[0] - principal_inertia[2])                      <L 729>
            var_53 = wp::extract(var_32, var_52);
            var_55 = wp::extract(var_32, var_54);
            var_56 = wp::sub(var_53, var_55);
            var_57 = wp::abs(var_56);
            // d12 = wp.abs(principal_inertia[1] - principal_inertia[2])                      <L 730>
            var_59 = wp::extract(var_32, var_58);
            var_61 = wp::extract(var_32, var_60);
            var_62 = wp::sub(var_59, var_61);
            var_63 = wp::abs(var_62);
            // min_diff = wp.min(d01, wp.min(d02, d12))                                       <L 731>
            var_64 = wp::min(var_57, var_63);
            var_65 = wp::min(var_51, var_64);
            // if min_diff < 0.01 * max_eig:  # within 1% -> axisymmetric                     <L 732>
            var_67 = wp::mul(var_66, var_34);
            var_68 = (var_65 < var_67);
            if (var_68) {
                // if d12 <= d01 and d12 <= d02:  # e1 approx eq e2, unique = col 0           <L 734>
                var_70 = (var_63 <= var_51);
                var_69 = var_70;
                if (var_69) {
                    var_71 = (var_63 <= var_57);
                    var_69 = var_69 && var_71;
                }
                if (var_69) {
                    // u = wp.vec3(rot[0, 0], rot[1, 0], rot[2, 0])                           <L 735>
                    var_74 = wp::extract(var_31, var_72, var_73);
                    var_77 = wp::extract(var_31, var_75, var_76);
                    var_80 = wp::extract(var_31, var_78, var_79);
                    var_81 = wp::vec_t<3, wp::float32>(var_74, var_77, var_80);
                }
                if (!var_69) {
                    // elif d02 <= d01:  # e0 approx eq e2, unique = col 1                    <L 736>
                    var_82 = (var_57 <= var_51);
                    if (var_82) {
                        // u = wp.vec3(rot[0, 1], rot[1, 1], rot[2, 1])                       <L 737>
                        var_85 = wp::extract(var_31, var_83, var_84);
                        var_88 = wp::extract(var_31, var_86, var_87);
                        var_91 = wp::extract(var_31, var_89, var_90);
                        var_92 = wp::vec_t<3, wp::float32>(var_85, var_88, var_91);
                    }
                    if (!var_82) {
                        // u = wp.vec3(rot[0, 2], rot[1, 2], rot[2, 2])                       <L 739>
                        var_95 = wp::extract(var_31, var_93, var_94);
                        var_98 = wp::extract(var_31, var_96, var_97);
                        var_101 = wp::extract(var_31, var_99, var_100);
                        var_102 = wp::vec_t<3, wp::float32>(var_95, var_98, var_101);
                    }
                    var_103 = wp::where(var_82, var_92, var_102);
                }
                var_104 = wp::where(var_69, var_81, var_103);
                // u = wp.normalize(u)                                                        <L 740>
                var_105 = wp::normalize(var_104);
                // v1, v2 = orthonormal_basis(u)                                              <L 743>
                orthonormal_basis_0(var_105, var_106, var_107);
                // c0 = v1                                                                    <L 746>
                var_108 = wp::copy(var_106);
                // c1 = v2                                                                    <L 747>
                var_109 = wp::copy(var_107);
                // c2 = u                                                                     <L 748>
                var_110 = wp::copy(var_105);
                // if d12 <= d01 and d12 <= d02:  # unique col 0                              <L 749>
                var_112 = (var_63 <= var_51);
                var_111 = var_112;
                if (var_111) {
                    var_113 = (var_63 <= var_57);
                    var_111 = var_111 && var_113;
                }
                if (var_111) {
                    // c0 = u                                                                 <L 750>
                    var_114 = wp::copy(var_105);
                    // c1 = v1                                                                <L 751>
                    var_115 = wp::copy(var_106);
                    // c2 = v2                                                                <L 752>
                    var_116 = wp::copy(var_107);
                }
                if (!var_111) {
                    // elif d02 <= d01:  # unique col 1                                       <L 753>
                    var_117 = (var_57 <= var_51);
                    if (var_117) {
                        // c0 = v2                                                            <L 754>
                        var_118 = wp::copy(var_107);
                        // c1 = u                                                             <L 755>
                        var_119 = wp::copy(var_105);
                        // c2 = v1                                                            <L 756>
                        var_120 = wp::copy(var_106);
                    }
                    var_121 = wp::where(var_117, var_118, var_108);
                    var_122 = wp::where(var_117, var_119, var_109);
                    var_123 = wp::where(var_117, var_120, var_110);
                }
                var_124 = wp::where(var_111, var_114, var_121);
                var_125 = wp::where(var_111, var_115, var_122);
                var_126 = wp::where(var_111, var_116, var_123);
                // rot = wp.transpose(wp.mat33(*c0, *c1, *c2))                                <L 758>
                var_128 = wp::extract(var_124, var_127);
                var_130 = wp::extract(var_124, var_129);
                var_132 = wp::extract(var_124, var_131);
                var_134 = wp::extract(var_125, var_133);
                var_136 = wp::extract(var_125, var_135);
                var_138 = wp::extract(var_125, var_137);
                var_140 = wp::extract(var_126, var_139);
                var_142 = wp::extract(var_126, var_141);
                var_144 = wp::extract(var_126, var_143);
                var_145 = wp::mat_t<3, 3, wp::float32>(var_128, var_130, var_132, var_134, var_136, var_138, var_140, var_142, var_144);
                var_146 = wp::transpose(var_145);
            }
            var_147 = wp::where(var_68, var_146, var_31);
        }
        var_148 = wp::where(var_45, var_147, var_31);
    }
    var_149 = wp::where(var_36, var_43, var_148);
    // box_inertia = principal_inertia * inv_m * (12.0 / 8.0)                                 <L 760>
    var_150 = wp::mul(var_32, var_26);
    var_153 = wp::div(var_151, var_152);
    var_154 = wp::mul(var_150, var_153);
    // sx = wp.sqrt(wp.abs(box_inertia[2] + box_inertia[1] - box_inertia[0]))                 <L 761>
    var_156 = wp::extract(var_154, var_155);
    var_158 = wp::extract(var_154, var_157);
    var_159 = wp::add(var_156, var_158);
    var_161 = wp::extract(var_154, var_160);
    var_162 = wp::sub(var_159, var_161);
    var_163 = wp::abs(var_162);
    var_164 = wp::sqrt(var_163);
    // sy = wp.sqrt(wp.abs(box_inertia[0] + box_inertia[2] - box_inertia[1]))                 <L 762>
    var_166 = wp::extract(var_154, var_165);
    var_168 = wp::extract(var_154, var_167);
    var_169 = wp::add(var_166, var_168);
    var_171 = wp::extract(var_154, var_170);
    var_172 = wp::sub(var_169, var_171);
    var_173 = wp::abs(var_172);
    var_174 = wp::sqrt(var_173);
    // sz = wp.sqrt(wp.abs(box_inertia[1] + box_inertia[0] - box_inertia[2]))                 <L 763>
    var_176 = wp::extract(var_154, var_175);
    var_178 = wp::extract(var_154, var_177);
    var_179 = wp::add(var_176, var_178);
    var_181 = wp::extract(var_154, var_180);
    var_182 = wp::sub(var_179, var_181);
    var_183 = wp::abs(var_182);
    var_184 = wp::sqrt(var_183);
    // c0x = float(0.0)                                                                       <L 769>
    var_186 = wp::float(var_185);
    // c0y = float(0.0)                                                                       <L 770>
    var_188 = wp::float(var_187);
    // c0z = float(0.0)                                                                       <L 771>
    var_190 = wp::float(var_189);
    // c1x = float(0.0)                                                                       <L 772>
    var_192 = wp::float(var_191);
    // c1y = float(0.0)                                                                       <L 773>
    var_194 = wp::float(var_193);
    // c1z = float(0.0)                                                                       <L 774>
    var_196 = wp::float(var_195);
    // if edge_id == 0:  # 0-1                                                                <L 776>
    var_198 = (var_4 == var_197);
    if (var_198) {
        // c0x = -sx                                                                          <L 777>
        var_199 = wp::neg(var_164);
        // c0y = -sy                                                                          <L 778>
        var_200 = wp::neg(var_174);
        // c0z = -sz                                                                          <L 779>
        var_201 = wp::neg(var_184);
        // c1x = sx                                                                           <L 780>
        var_202 = wp::copy(var_164);
        // c1y = -sy                                                                          <L 781>
        var_203 = wp::neg(var_174);
        // c1z = -sz                                                                          <L 782>
        var_204 = wp::neg(var_184);
    }
    if (!var_198) {
        // elif edge_id == 1:  # 1-2                                                          <L 783>
        var_206 = (var_4 == var_205);
        if (var_206) {
            // c0x = sx                                                                       <L 784>
            var_207 = wp::copy(var_164);
            // c0y = -sy                                                                      <L 785>
            var_208 = wp::neg(var_174);
            // c0z = -sz                                                                      <L 786>
            var_209 = wp::neg(var_184);
            // c1x = sx                                                                       <L 787>
            var_210 = wp::copy(var_164);
            // c1y = sy                                                                       <L 788>
            var_211 = wp::copy(var_174);
            // c1z = -sz                                                                      <L 789>
            var_212 = wp::neg(var_184);
        }
        if (!var_206) {
            // elif edge_id == 2:  # 2-3                                                      <L 790>
            var_214 = (var_4 == var_213);
            if (var_214) {
                // c0x = sx                                                                   <L 791>
                var_215 = wp::copy(var_164);
                // c0y = sy                                                                   <L 792>
                var_216 = wp::copy(var_174);
                // c0z = -sz                                                                  <L 793>
                var_217 = wp::neg(var_184);
                // c1x = -sx                                                                  <L 794>
                var_218 = wp::neg(var_164);
                // c1y = sy                                                                   <L 795>
                var_219 = wp::copy(var_174);
                // c1z = -sz                                                                  <L 796>
                var_220 = wp::neg(var_184);
            }
            if (!var_214) {
                // elif edge_id == 3:  # 3-0                                                  <L 797>
                var_222 = (var_4 == var_221);
                if (var_222) {
                    // c0x = -sx                                                              <L 798>
                    var_223 = wp::neg(var_164);
                    // c0y = sy                                                               <L 799>
                    var_224 = wp::copy(var_174);
                    // c0z = -sz                                                              <L 800>
                    var_225 = wp::neg(var_184);
                    // c1x = -sx                                                              <L 801>
                    var_226 = wp::neg(var_164);
                    // c1y = -sy                                                              <L 802>
                    var_227 = wp::neg(var_174);
                    // c1z = -sz                                                              <L 803>
                    var_228 = wp::neg(var_184);
                }
                if (!var_222) {
                    // elif edge_id == 4:  # 4-5                                              <L 804>
                    var_230 = (var_4 == var_229);
                    if (var_230) {
                        // c0x = -sx                                                          <L 805>
                        var_231 = wp::neg(var_164);
                        // c0y = -sy                                                          <L 806>
                        var_232 = wp::neg(var_174);
                        // c0z = sz                                                           <L 807>
                        var_233 = wp::copy(var_184);
                        // c1x = sx                                                           <L 808>
                        var_234 = wp::copy(var_164);
                        // c1y = -sy                                                          <L 809>
                        var_235 = wp::neg(var_174);
                        // c1z = sz                                                           <L 810>
                        var_236 = wp::copy(var_184);
                    }
                    if (!var_230) {
                        // elif edge_id == 5:  # 5-6                                          <L 811>
                        var_238 = (var_4 == var_237);
                        if (var_238) {
                            // c0x = sx                                                       <L 812>
                            var_239 = wp::copy(var_164);
                            // c0y = -sy                                                      <L 813>
                            var_240 = wp::neg(var_174);
                            // c0z = sz                                                       <L 814>
                            var_241 = wp::copy(var_184);
                            // c1x = sx                                                       <L 815>
                            var_242 = wp::copy(var_164);
                            // c1y = sy                                                       <L 816>
                            var_243 = wp::copy(var_174);
                            // c1z = sz                                                       <L 817>
                            var_244 = wp::copy(var_184);
                        }
                        if (!var_238) {
                            // elif edge_id == 6:  # 6-7                                      <L 818>
                            var_246 = (var_4 == var_245);
                            if (var_246) {
                                // c0x = sx                                                   <L 819>
                                var_247 = wp::copy(var_164);
                                // c0y = sy                                                   <L 820>
                                var_248 = wp::copy(var_174);
                                // c0z = sz                                                   <L 821>
                                var_249 = wp::copy(var_184);
                                // c1x = -sx                                                  <L 822>
                                var_250 = wp::neg(var_164);
                                // c1y = sy                                                   <L 823>
                                var_251 = wp::copy(var_174);
                                // c1z = sz                                                   <L 824>
                                var_252 = wp::copy(var_184);
                            }
                            if (!var_246) {
                                // elif edge_id == 7:  # 7-4                                  <L 825>
                                var_254 = (var_4 == var_253);
                                if (var_254) {
                                    // c0x = -sx                                              <L 826>
                                    var_255 = wp::neg(var_164);
                                    // c0y = sy                                               <L 827>
                                    var_256 = wp::copy(var_174);
                                    // c0z = sz                                               <L 828>
                                    var_257 = wp::copy(var_184);
                                    // c1x = -sx                                              <L 829>
                                    var_258 = wp::neg(var_164);
                                    // c1y = -sy                                              <L 830>
                                    var_259 = wp::neg(var_174);
                                    // c1z = sz                                               <L 831>
                                    var_260 = wp::copy(var_184);
                                }
                                if (!var_254) {
                                    // elif edge_id == 8:  # 0-4                              <L 832>
                                    var_262 = (var_4 == var_261);
                                    if (var_262) {
                                        // c0x = -sx                                          <L 833>
                                        var_263 = wp::neg(var_164);
                                        // c0y = -sy                                          <L 834>
                                        var_264 = wp::neg(var_174);
                                        // c0z = -sz                                          <L 835>
                                        var_265 = wp::neg(var_184);
                                        // c1x = -sx                                          <L 836>
                                        var_266 = wp::neg(var_164);
                                        // c1y = -sy                                          <L 837>
                                        var_267 = wp::neg(var_174);
                                        // c1z = sz                                           <L 838>
                                        var_268 = wp::copy(var_184);
                                    }
                                    if (!var_262) {
                                        // elif edge_id == 9:  # 1-5                          <L 839>
                                        var_270 = (var_4 == var_269);
                                        if (var_270) {
                                            // c0x = sx                                       <L 840>
                                            var_271 = wp::copy(var_164);
                                            // c0y = -sy                                      <L 841>
                                            var_272 = wp::neg(var_174);
                                            // c0z = -sz                                      <L 842>
                                            var_273 = wp::neg(var_184);
                                            // c1x = sx                                       <L 843>
                                            var_274 = wp::copy(var_164);
                                            // c1y = -sy                                      <L 844>
                                            var_275 = wp::neg(var_174);
                                            // c1z = sz                                       <L 845>
                                            var_276 = wp::copy(var_184);
                                        }
                                        if (!var_270) {
                                            // elif edge_id == 10:  # 2-6                     <L 846>
                                            var_278 = (var_4 == var_277);
                                            if (var_278) {
                                                // c0x = sx                                   <L 847>
                                                var_279 = wp::copy(var_164);
                                                // c0y = sy                                   <L 848>
                                                var_280 = wp::copy(var_174);
                                                // c0z = -sz                                  <L 849>
                                                var_281 = wp::neg(var_184);
                                                // c1x = sx                                   <L 850>
                                                var_282 = wp::copy(var_164);
                                                // c1y = sy                                   <L 851>
                                                var_283 = wp::copy(var_174);
                                                // c1z = sz                                   <L 852>
                                                var_284 = wp::copy(var_184);
                                            }
                                            if (!var_278) {
                                                // elif edge_id == 11:  # 3-7                 <L 853>
                                                var_286 = (var_4 == var_285);
                                                if (var_286) {
                                                    // c0x = -sx                              <L 854>
                                                    var_287 = wp::neg(var_164);
                                                    // c0y = sy                               <L 855>
                                                    var_288 = wp::copy(var_174);
                                                    // c0z = -sz                              <L 856>
                                                    var_289 = wp::neg(var_184);
                                                    // c1x = -sx                              <L 857>
                                                    var_290 = wp::neg(var_164);
                                                    // c1y = sy                               <L 858>
                                                    var_291 = wp::copy(var_174);
                                                    // c1z = sz                               <L 859>
                                                    var_292 = wp::copy(var_184);
                                                }
                                                var_293 = wp::where(var_286, var_287, var_186);
                                                var_294 = wp::where(var_286, var_288, var_188);
                                                var_295 = wp::where(var_286, var_289, var_190);
                                                var_296 = wp::where(var_286, var_290, var_192);
                                                var_297 = wp::where(var_286, var_291, var_194);
                                                var_298 = wp::where(var_286, var_292, var_196);
                                            }
                                            var_299 = wp::where(var_278, var_279, var_293);
                                            var_300 = wp::where(var_278, var_280, var_294);
                                            var_301 = wp::where(var_278, var_281, var_295);
                                            var_302 = wp::where(var_278, var_282, var_296);
                                            var_303 = wp::where(var_278, var_283, var_297);
                                            var_304 = wp::where(var_278, var_284, var_298);
                                        }
                                        var_305 = wp::where(var_270, var_271, var_299);
                                        var_306 = wp::where(var_270, var_272, var_300);
                                        var_307 = wp::where(var_270, var_273, var_301);
                                        var_308 = wp::where(var_270, var_274, var_302);
                                        var_309 = wp::where(var_270, var_275, var_303);
                                        var_310 = wp::where(var_270, var_276, var_304);
                                    }
                                    var_311 = wp::where(var_262, var_263, var_305);
                                    var_312 = wp::where(var_262, var_264, var_306);
                                    var_313 = wp::where(var_262, var_265, var_307);
                                    var_314 = wp::where(var_262, var_266, var_308);
                                    var_315 = wp::where(var_262, var_267, var_309);
                                    var_316 = wp::where(var_262, var_268, var_310);
                                }
                                var_317 = wp::where(var_254, var_255, var_311);
                                var_318 = wp::where(var_254, var_256, var_312);
                                var_319 = wp::where(var_254, var_257, var_313);
                                var_320 = wp::where(var_254, var_258, var_314);
                                var_321 = wp::where(var_254, var_259, var_315);
                                var_322 = wp::where(var_254, var_260, var_316);
                            }
                            var_323 = wp::where(var_246, var_247, var_317);
                            var_324 = wp::where(var_246, var_248, var_318);
                            var_325 = wp::where(var_246, var_249, var_319);
                            var_326 = wp::where(var_246, var_250, var_320);
                            var_327 = wp::where(var_246, var_251, var_321);
                            var_328 = wp::where(var_246, var_252, var_322);
                        }
                        var_329 = wp::where(var_238, var_239, var_323);
                        var_330 = wp::where(var_238, var_240, var_324);
                        var_331 = wp::where(var_238, var_241, var_325);
                        var_332 = wp::where(var_238, var_242, var_326);
                        var_333 = wp::where(var_238, var_243, var_327);
                        var_334 = wp::where(var_238, var_244, var_328);
                    }
                    var_335 = wp::where(var_230, var_231, var_329);
                    var_336 = wp::where(var_230, var_232, var_330);
                    var_337 = wp::where(var_230, var_233, var_331);
                    var_338 = wp::where(var_230, var_234, var_332);
                    var_339 = wp::where(var_230, var_235, var_333);
                    var_340 = wp::where(var_230, var_236, var_334);
                }
                var_341 = wp::where(var_222, var_223, var_335);
                var_342 = wp::where(var_222, var_224, var_336);
                var_343 = wp::where(var_222, var_225, var_337);
                var_344 = wp::where(var_222, var_226, var_338);
                var_345 = wp::where(var_222, var_227, var_339);
                var_346 = wp::where(var_222, var_228, var_340);
            }
            var_347 = wp::where(var_214, var_215, var_341);
            var_348 = wp::where(var_214, var_216, var_342);
            var_349 = wp::where(var_214, var_217, var_343);
            var_350 = wp::where(var_214, var_218, var_344);
            var_351 = wp::where(var_214, var_219, var_345);
            var_352 = wp::where(var_214, var_220, var_346);
        }
        var_353 = wp::where(var_206, var_207, var_347);
        var_354 = wp::where(var_206, var_208, var_348);
        var_355 = wp::where(var_206, var_209, var_349);
        var_356 = wp::where(var_206, var_210, var_350);
        var_357 = wp::where(var_206, var_211, var_351);
        var_358 = wp::where(var_206, var_212, var_352);
    }
    var_359 = wp::where(var_198, var_199, var_353);
    var_360 = wp::where(var_198, var_200, var_354);
    var_361 = wp::where(var_198, var_201, var_355);
    var_362 = wp::where(var_198, var_202, var_356);
    var_363 = wp::where(var_198, var_203, var_357);
    var_364 = wp::where(var_198, var_204, var_358);
    // local0 = wp.vec3(c0x, c0y, c0z)                                                        <L 861>
    var_365 = wp::vec_t<3, wp::float32>(var_359, var_360, var_361);
    // local1 = wp.vec3(c1x, c1y, c1z)                                                        <L 862>
    var_366 = wp::vec_t<3, wp::float32>(var_362, var_363, var_364);
    // inertia_rot = wp.quat_from_matrix(rot)                                                 <L 865>
    var_367 = wp::quat_from_matrix(var_149);
    // local0 = wp.quat_rotate(inertia_rot, local0)                                           <L 866>
    var_368 = wp::quat_rotate(var_367, var_365);
    // local1 = wp.quat_rotate(inertia_rot, local1)                                           <L 867>
    var_369 = wp::quat_rotate(var_367, var_366);
    // body_tf = body_q[body_id]                                                              <L 870>
    var_370 = wp::address(var_body_q, var_2);
    var_372 = wp::load(var_370);
    var_371 = wp::copy(var_372);
    // body_rot = wp.transform_get_rotation(body_tf)                                          <L 871>
    var_373 = wp::transform_get_rotation(var_371);
    // body_pos = wp.transform_get_translation(body_tf)                                       <L 872>
    var_374 = wp::transform_get_translation(var_371);
    // com = body_com[body_id]                                                                <L 873>
    var_375 = wp::address(var_body_com, var_2);
    var_377 = wp::load(var_375);
    var_376 = wp::copy(var_377);
    // world_com = body_pos + wp.quat_rotate(body_rot, com)                                   <L 876>
    var_378 = wp::quat_rotate(var_373, var_376);
    var_379 = wp::add(var_374, var_378);
    // world0 = world_com + wp.quat_rotate(body_rot, local0)                                  <L 878>
    var_380 = wp::quat_rotate(var_373, var_368);
    var_381 = wp::add(var_379, var_380);
    // world1 = world_com + wp.quat_rotate(body_rot, local1)                                  <L 879>
    var_382 = wp::quat_rotate(var_373, var_369);
    var_383 = wp::add(var_379, var_382);
    // if world_offsets and world_idx >= 0 and world_idx < world_offsets.shape[0]:            <L 882>
    var_384 = var_world_offsets;
    if (var_384) {
        var_386 = (var_17 >= var_385);
        var_384 = var_384 && var_386;
    }
    if (var_384) {
        var_387 = &(var_world_offsets.shape);
        var_390 = wp::load(var_387);
        var_389 = wp::extract(var_390, var_388);
        var_391 = (var_17 < var_389);
        var_384 = var_384 && var_391;
    }
    if (var_384) {
        // offset = world_offsets[world_idx]                                                  <L 883>
        var_392 = wp::address(var_world_offsets, var_17);
        var_394 = wp::load(var_392);
        var_393 = wp::copy(var_394);
        // world0 = world0 + offset                                                           <L 884>
        var_395 = wp::add(var_381, var_393);
        // world1 = world1 + offset                                                           <L 885>
        var_396 = wp::add(var_383, var_393);
    }
    var_397 = wp::where(var_384, var_395, var_381);
    var_398 = wp::where(var_384, var_396, var_383);
    // world0 = wp.transform_point(layer_xform, world0)                                       <L 888>
    var_399 = wp::transform_point(var_layer_xform, var_397);
    // world1 = wp.transform_point(layer_xform, world1)                                       <L 889>
    var_400 = wp::transform_point(var_layer_xform, var_398);
    // line_starts[tid] = world0                                                              <L 891>
    // wp::array_store(var_line_starts, var_0, var_399);
    // line_ends[tid] = world1                                                                <L 892>
    // wp::array_store(var_line_ends, var_0, var_400);
    // line_colors[tid] = color                                                               <L 893>
    // wp::array_store(var_line_colors, var_0, var_color);
    //---------
    // reverse
    wp::adj_array_store(var_line_colors, var_0, var_color, adj_line_colors, adj_0, adj_color);
    // adj: line_colors[tid] = color                                                          <L 893>
    wp::adj_array_store(var_line_ends, var_0, var_400, adj_line_ends, adj_0, adj_400);
    // adj: line_ends[tid] = world1                                                           <L 892>
    wp::adj_array_store(var_line_starts, var_0, var_399, adj_line_starts, adj_0, adj_399);
    // adj: line_starts[tid] = world0                                                         <L 891>
    wp::adj_transform_point(var_layer_xform, var_398, adj_layer_xform, adj_398, adj_400);
    // adj: world1 = wp.transform_point(layer_xform, world1)                                  <L 889>
    wp::adj_transform_point(var_layer_xform, var_397, adj_layer_xform, adj_397, adj_399);
    // adj: world0 = wp.transform_point(layer_xform, world0)                                  <L 888>
    wp::adj_where(var_384, var_396, var_383, adj_384, adj_396, adj_383, adj_398);
    wp::adj_where(var_384, var_395, var_381, adj_384, adj_395, adj_381, adj_397);
    if (var_384) {
        wp::adj_add(var_383, var_393, adj_383, adj_393, adj_396);
        // adj: world1 = world1 + offset                                                      <L 885>
        wp::adj_add(var_381, var_393, adj_381, adj_393, adj_395);
        // adj: world0 = world0 + offset                                                      <L 884>
        wp::adj_copy(var_394, adj_392, adj_393);
        wp::adj_address(var_world_offsets, var_17, adj_world_offsets, adj_17, adj_392);
        // adj: offset = world_offsets[world_idx]                                             <L 883>
    }
    if (var_384) {
        adj_world_offsets.shape = adj_387;
    }
    if (var_384) {
    }
    // adj: if world_offsets and world_idx >= 0 and world_idx < world_offsets.shape[0]:       <L 882>
    wp::adj_add(var_379, var_382, adj_379, adj_382, adj_383);
    wp::adj_quat_rotate(var_373, var_369, adj_373, adj_369, adj_382);
    // adj: world1 = world_com + wp.quat_rotate(body_rot, local1)                             <L 879>
    wp::adj_add(var_379, var_380, adj_379, adj_380, adj_381);
    wp::adj_quat_rotate(var_373, var_368, adj_373, adj_368, adj_380);
    // adj: world0 = world_com + wp.quat_rotate(body_rot, local0)                             <L 878>
    wp::adj_add(var_374, var_378, adj_374, adj_378, adj_379);
    wp::adj_quat_rotate(var_373, var_376, adj_373, adj_376, adj_378);
    // adj: world_com = body_pos + wp.quat_rotate(body_rot, com)                              <L 876>
    wp::adj_copy(var_377, adj_375, adj_376);
    wp::adj_address(var_body_com, var_2, adj_body_com, adj_2, adj_375);
    // adj: com = body_com[body_id]                                                           <L 873>
    wp::adj_transform_get_translation(var_371, adj_371, adj_374);
    // adj: body_pos = wp.transform_get_translation(body_tf)                                  <L 872>
    wp::adj_transform_get_rotation(var_371, adj_371, adj_373);
    // adj: body_rot = wp.transform_get_rotation(body_tf)                                     <L 871>
    wp::adj_copy(var_372, adj_370, adj_371);
    wp::adj_address(var_body_q, var_2, adj_body_q, adj_2, adj_370);
    // adj: body_tf = body_q[body_id]                                                         <L 870>
    wp::adj_quat_rotate(var_367, var_366, adj_367, adj_366, adj_369);
    // adj: local1 = wp.quat_rotate(inertia_rot, local1)                                      <L 867>
    wp::adj_quat_rotate(var_367, var_365, adj_367, adj_365, adj_368);
    // adj: local0 = wp.quat_rotate(inertia_rot, local0)                                      <L 866>
    wp::adj_quat_from_matrix(var_149, adj_149, adj_367);
    // adj: inertia_rot = wp.quat_from_matrix(rot)                                            <L 865>
    wp::adj_vec_t(var_362, var_363, var_364, adj_362, adj_363, adj_364, adj_366);
    // adj: local1 = wp.vec3(c1x, c1y, c1z)                                                   <L 862>
    wp::adj_vec_t(var_359, var_360, var_361, adj_359, adj_360, adj_361, adj_365);
    // adj: local0 = wp.vec3(c0x, c0y, c0z)                                                   <L 861>
    wp::adj_where(var_198, var_204, var_358, adj_198, adj_204, adj_358, adj_364);
    wp::adj_where(var_198, var_203, var_357, adj_198, adj_203, adj_357, adj_363);
    wp::adj_where(var_198, var_202, var_356, adj_198, adj_202, adj_356, adj_362);
    wp::adj_where(var_198, var_201, var_355, adj_198, adj_201, adj_355, adj_361);
    wp::adj_where(var_198, var_200, var_354, adj_198, adj_200, adj_354, adj_360);
    wp::adj_where(var_198, var_199, var_353, adj_198, adj_199, adj_353, adj_359);
    if (!var_198) {
        wp::adj_where(var_206, var_212, var_352, adj_206, adj_212, adj_352, adj_358);
        wp::adj_where(var_206, var_211, var_351, adj_206, adj_211, adj_351, adj_357);
        wp::adj_where(var_206, var_210, var_350, adj_206, adj_210, adj_350, adj_356);
        wp::adj_where(var_206, var_209, var_349, adj_206, adj_209, adj_349, adj_355);
        wp::adj_where(var_206, var_208, var_348, adj_206, adj_208, adj_348, adj_354);
        wp::adj_where(var_206, var_207, var_347, adj_206, adj_207, adj_347, adj_353);
        if (!var_206) {
            wp::adj_where(var_214, var_220, var_346, adj_214, adj_220, adj_346, adj_352);
            wp::adj_where(var_214, var_219, var_345, adj_214, adj_219, adj_345, adj_351);
            wp::adj_where(var_214, var_218, var_344, adj_214, adj_218, adj_344, adj_350);
            wp::adj_where(var_214, var_217, var_343, adj_214, adj_217, adj_343, adj_349);
            wp::adj_where(var_214, var_216, var_342, adj_214, adj_216, adj_342, adj_348);
            wp::adj_where(var_214, var_215, var_341, adj_214, adj_215, adj_341, adj_347);
            if (!var_214) {
                wp::adj_where(var_222, var_228, var_340, adj_222, adj_228, adj_340, adj_346);
                wp::adj_where(var_222, var_227, var_339, adj_222, adj_227, adj_339, adj_345);
                wp::adj_where(var_222, var_226, var_338, adj_222, adj_226, adj_338, adj_344);
                wp::adj_where(var_222, var_225, var_337, adj_222, adj_225, adj_337, adj_343);
                wp::adj_where(var_222, var_224, var_336, adj_222, adj_224, adj_336, adj_342);
                wp::adj_where(var_222, var_223, var_335, adj_222, adj_223, adj_335, adj_341);
                if (!var_222) {
                    wp::adj_where(var_230, var_236, var_334, adj_230, adj_236, adj_334, adj_340);
                    wp::adj_where(var_230, var_235, var_333, adj_230, adj_235, adj_333, adj_339);
                    wp::adj_where(var_230, var_234, var_332, adj_230, adj_234, adj_332, adj_338);
                    wp::adj_where(var_230, var_233, var_331, adj_230, adj_233, adj_331, adj_337);
                    wp::adj_where(var_230, var_232, var_330, adj_230, adj_232, adj_330, adj_336);
                    wp::adj_where(var_230, var_231, var_329, adj_230, adj_231, adj_329, adj_335);
                    if (!var_230) {
                        wp::adj_where(var_238, var_244, var_328, adj_238, adj_244, adj_328, adj_334);
                        wp::adj_where(var_238, var_243, var_327, adj_238, adj_243, adj_327, adj_333);
                        wp::adj_where(var_238, var_242, var_326, adj_238, adj_242, adj_326, adj_332);
                        wp::adj_where(var_238, var_241, var_325, adj_238, adj_241, adj_325, adj_331);
                        wp::adj_where(var_238, var_240, var_324, adj_238, adj_240, adj_324, adj_330);
                        wp::adj_where(var_238, var_239, var_323, adj_238, adj_239, adj_323, adj_329);
                        if (!var_238) {
                            wp::adj_where(var_246, var_252, var_322, adj_246, adj_252, adj_322, adj_328);
                            wp::adj_where(var_246, var_251, var_321, adj_246, adj_251, adj_321, adj_327);
                            wp::adj_where(var_246, var_250, var_320, adj_246, adj_250, adj_320, adj_326);
                            wp::adj_where(var_246, var_249, var_319, adj_246, adj_249, adj_319, adj_325);
                            wp::adj_where(var_246, var_248, var_318, adj_246, adj_248, adj_318, adj_324);
                            wp::adj_where(var_246, var_247, var_317, adj_246, adj_247, adj_317, adj_323);
                            if (!var_246) {
                                wp::adj_where(var_254, var_260, var_316, adj_254, adj_260, adj_316, adj_322);
                                wp::adj_where(var_254, var_259, var_315, adj_254, adj_259, adj_315, adj_321);
                                wp::adj_where(var_254, var_258, var_314, adj_254, adj_258, adj_314, adj_320);
                                wp::adj_where(var_254, var_257, var_313, adj_254, adj_257, adj_313, adj_319);
                                wp::adj_where(var_254, var_256, var_312, adj_254, adj_256, adj_312, adj_318);
                                wp::adj_where(var_254, var_255, var_311, adj_254, adj_255, adj_311, adj_317);
                                if (!var_254) {
                                    wp::adj_where(var_262, var_268, var_310, adj_262, adj_268, adj_310, adj_316);
                                    wp::adj_where(var_262, var_267, var_309, adj_262, adj_267, adj_309, adj_315);
                                    wp::adj_where(var_262, var_266, var_308, adj_262, adj_266, adj_308, adj_314);
                                    wp::adj_where(var_262, var_265, var_307, adj_262, adj_265, adj_307, adj_313);
                                    wp::adj_where(var_262, var_264, var_306, adj_262, adj_264, adj_306, adj_312);
                                    wp::adj_where(var_262, var_263, var_305, adj_262, adj_263, adj_305, adj_311);
                                    if (!var_262) {
                                        wp::adj_where(var_270, var_276, var_304, adj_270, adj_276, adj_304, adj_310);
                                        wp::adj_where(var_270, var_275, var_303, adj_270, adj_275, adj_303, adj_309);
                                        wp::adj_where(var_270, var_274, var_302, adj_270, adj_274, adj_302, adj_308);
                                        wp::adj_where(var_270, var_273, var_301, adj_270, adj_273, adj_301, adj_307);
                                        wp::adj_where(var_270, var_272, var_300, adj_270, adj_272, adj_300, adj_306);
                                        wp::adj_where(var_270, var_271, var_299, adj_270, adj_271, adj_299, adj_305);
                                        if (!var_270) {
                                            wp::adj_where(var_278, var_284, var_298, adj_278, adj_284, adj_298, adj_304);
                                            wp::adj_where(var_278, var_283, var_297, adj_278, adj_283, adj_297, adj_303);
                                            wp::adj_where(var_278, var_282, var_296, adj_278, adj_282, adj_296, adj_302);
                                            wp::adj_where(var_278, var_281, var_295, adj_278, adj_281, adj_295, adj_301);
                                            wp::adj_where(var_278, var_280, var_294, adj_278, adj_280, adj_294, adj_300);
                                            wp::adj_where(var_278, var_279, var_293, adj_278, adj_279, adj_293, adj_299);
                                            if (!var_278) {
                                                wp::adj_where(var_286, var_292, var_196, adj_286, adj_292, adj_196, adj_298);
                                                wp::adj_where(var_286, var_291, var_194, adj_286, adj_291, adj_194, adj_297);
                                                wp::adj_where(var_286, var_290, var_192, adj_286, adj_290, adj_192, adj_296);
                                                wp::adj_where(var_286, var_289, var_190, adj_286, adj_289, adj_190, adj_295);
                                                wp::adj_where(var_286, var_288, var_188, adj_286, adj_288, adj_188, adj_294);
                                                wp::adj_where(var_286, var_287, var_186, adj_286, adj_287, adj_186, adj_293);
                                                if (var_286) {
                                                    wp::adj_copy(var_184, adj_184, adj_292);
                                                    // adj: c1z = sz                          <L 859>
                                                    wp::adj_copy(var_174, adj_174, adj_291);
                                                    // adj: c1y = sy                          <L 858>
                                                    wp::adj_neg(var_164, adj_164, adj_290);
                                                    // adj: c1x = -sx                         <L 857>
                                                    wp::adj_neg(var_184, adj_184, adj_289);
                                                    // adj: c0z = -sz                         <L 856>
                                                    wp::adj_copy(var_174, adj_174, adj_288);
                                                    // adj: c0y = sy                          <L 855>
                                                    wp::adj_neg(var_164, adj_164, adj_287);
                                                    // adj: c0x = -sx                         <L 854>
                                                }
                                                // adj: elif edge_id == 11:  # 3-7            <L 853>
                                            }
                                            if (var_278) {
                                                wp::adj_copy(var_184, adj_184, adj_284);
                                                // adj: c1z = sz                              <L 852>
                                                wp::adj_copy(var_174, adj_174, adj_283);
                                                // adj: c1y = sy                              <L 851>
                                                wp::adj_copy(var_164, adj_164, adj_282);
                                                // adj: c1x = sx                              <L 850>
                                                wp::adj_neg(var_184, adj_184, adj_281);
                                                // adj: c0z = -sz                             <L 849>
                                                wp::adj_copy(var_174, adj_174, adj_280);
                                                // adj: c0y = sy                              <L 848>
                                                wp::adj_copy(var_164, adj_164, adj_279);
                                                // adj: c0x = sx                              <L 847>
                                            }
                                            // adj: elif edge_id == 10:  # 2-6                <L 846>
                                        }
                                        if (var_270) {
                                            wp::adj_copy(var_184, adj_184, adj_276);
                                            // adj: c1z = sz                                  <L 845>
                                            wp::adj_neg(var_174, adj_174, adj_275);
                                            // adj: c1y = -sy                                 <L 844>
                                            wp::adj_copy(var_164, adj_164, adj_274);
                                            // adj: c1x = sx                                  <L 843>
                                            wp::adj_neg(var_184, adj_184, adj_273);
                                            // adj: c0z = -sz                                 <L 842>
                                            wp::adj_neg(var_174, adj_174, adj_272);
                                            // adj: c0y = -sy                                 <L 841>
                                            wp::adj_copy(var_164, adj_164, adj_271);
                                            // adj: c0x = sx                                  <L 840>
                                        }
                                        // adj: elif edge_id == 9:  # 1-5                     <L 839>
                                    }
                                    if (var_262) {
                                        wp::adj_copy(var_184, adj_184, adj_268);
                                        // adj: c1z = sz                                      <L 838>
                                        wp::adj_neg(var_174, adj_174, adj_267);
                                        // adj: c1y = -sy                                     <L 837>
                                        wp::adj_neg(var_164, adj_164, adj_266);
                                        // adj: c1x = -sx                                     <L 836>
                                        wp::adj_neg(var_184, adj_184, adj_265);
                                        // adj: c0z = -sz                                     <L 835>
                                        wp::adj_neg(var_174, adj_174, adj_264);
                                        // adj: c0y = -sy                                     <L 834>
                                        wp::adj_neg(var_164, adj_164, adj_263);
                                        // adj: c0x = -sx                                     <L 833>
                                    }
                                    // adj: elif edge_id == 8:  # 0-4                         <L 832>
                                }
                                if (var_254) {
                                    wp::adj_copy(var_184, adj_184, adj_260);
                                    // adj: c1z = sz                                          <L 831>
                                    wp::adj_neg(var_174, adj_174, adj_259);
                                    // adj: c1y = -sy                                         <L 830>
                                    wp::adj_neg(var_164, adj_164, adj_258);
                                    // adj: c1x = -sx                                         <L 829>
                                    wp::adj_copy(var_184, adj_184, adj_257);
                                    // adj: c0z = sz                                          <L 828>
                                    wp::adj_copy(var_174, adj_174, adj_256);
                                    // adj: c0y = sy                                          <L 827>
                                    wp::adj_neg(var_164, adj_164, adj_255);
                                    // adj: c0x = -sx                                         <L 826>
                                }
                                // adj: elif edge_id == 7:  # 7-4                             <L 825>
                            }
                            if (var_246) {
                                wp::adj_copy(var_184, adj_184, adj_252);
                                // adj: c1z = sz                                              <L 824>
                                wp::adj_copy(var_174, adj_174, adj_251);
                                // adj: c1y = sy                                              <L 823>
                                wp::adj_neg(var_164, adj_164, adj_250);
                                // adj: c1x = -sx                                             <L 822>
                                wp::adj_copy(var_184, adj_184, adj_249);
                                // adj: c0z = sz                                              <L 821>
                                wp::adj_copy(var_174, adj_174, adj_248);
                                // adj: c0y = sy                                              <L 820>
                                wp::adj_copy(var_164, adj_164, adj_247);
                                // adj: c0x = sx                                              <L 819>
                            }
                            // adj: elif edge_id == 6:  # 6-7                                 <L 818>
                        }
                        if (var_238) {
                            wp::adj_copy(var_184, adj_184, adj_244);
                            // adj: c1z = sz                                                  <L 817>
                            wp::adj_copy(var_174, adj_174, adj_243);
                            // adj: c1y = sy                                                  <L 816>
                            wp::adj_copy(var_164, adj_164, adj_242);
                            // adj: c1x = sx                                                  <L 815>
                            wp::adj_copy(var_184, adj_184, adj_241);
                            // adj: c0z = sz                                                  <L 814>
                            wp::adj_neg(var_174, adj_174, adj_240);
                            // adj: c0y = -sy                                                 <L 813>
                            wp::adj_copy(var_164, adj_164, adj_239);
                            // adj: c0x = sx                                                  <L 812>
                        }
                        // adj: elif edge_id == 5:  # 5-6                                     <L 811>
                    }
                    if (var_230) {
                        wp::adj_copy(var_184, adj_184, adj_236);
                        // adj: c1z = sz                                                      <L 810>
                        wp::adj_neg(var_174, adj_174, adj_235);
                        // adj: c1y = -sy                                                     <L 809>
                        wp::adj_copy(var_164, adj_164, adj_234);
                        // adj: c1x = sx                                                      <L 808>
                        wp::adj_copy(var_184, adj_184, adj_233);
                        // adj: c0z = sz                                                      <L 807>
                        wp::adj_neg(var_174, adj_174, adj_232);
                        // adj: c0y = -sy                                                     <L 806>
                        wp::adj_neg(var_164, adj_164, adj_231);
                        // adj: c0x = -sx                                                     <L 805>
                    }
                    // adj: elif edge_id == 4:  # 4-5                                         <L 804>
                }
                if (var_222) {
                    wp::adj_neg(var_184, adj_184, adj_228);
                    // adj: c1z = -sz                                                         <L 803>
                    wp::adj_neg(var_174, adj_174, adj_227);
                    // adj: c1y = -sy                                                         <L 802>
                    wp::adj_neg(var_164, adj_164, adj_226);
                    // adj: c1x = -sx                                                         <L 801>
                    wp::adj_neg(var_184, adj_184, adj_225);
                    // adj: c0z = -sz                                                         <L 800>
                    wp::adj_copy(var_174, adj_174, adj_224);
                    // adj: c0y = sy                                                          <L 799>
                    wp::adj_neg(var_164, adj_164, adj_223);
                    // adj: c0x = -sx                                                         <L 798>
                }
                // adj: elif edge_id == 3:  # 3-0                                             <L 797>
            }
            if (var_214) {
                wp::adj_neg(var_184, adj_184, adj_220);
                // adj: c1z = -sz                                                             <L 796>
                wp::adj_copy(var_174, adj_174, adj_219);
                // adj: c1y = sy                                                              <L 795>
                wp::adj_neg(var_164, adj_164, adj_218);
                // adj: c1x = -sx                                                             <L 794>
                wp::adj_neg(var_184, adj_184, adj_217);
                // adj: c0z = -sz                                                             <L 793>
                wp::adj_copy(var_174, adj_174, adj_216);
                // adj: c0y = sy                                                              <L 792>
                wp::adj_copy(var_164, adj_164, adj_215);
                // adj: c0x = sx                                                              <L 791>
            }
            // adj: elif edge_id == 2:  # 2-3                                                 <L 790>
        }
        if (var_206) {
            wp::adj_neg(var_184, adj_184, adj_212);
            // adj: c1z = -sz                                                                 <L 789>
            wp::adj_copy(var_174, adj_174, adj_211);
            // adj: c1y = sy                                                                  <L 788>
            wp::adj_copy(var_164, adj_164, adj_210);
            // adj: c1x = sx                                                                  <L 787>
            wp::adj_neg(var_184, adj_184, adj_209);
            // adj: c0z = -sz                                                                 <L 786>
            wp::adj_neg(var_174, adj_174, adj_208);
            // adj: c0y = -sy                                                                 <L 785>
            wp::adj_copy(var_164, adj_164, adj_207);
            // adj: c0x = sx                                                                  <L 784>
        }
        // adj: elif edge_id == 1:  # 1-2                                                     <L 783>
    }
    if (var_198) {
        wp::adj_neg(var_184, adj_184, adj_204);
        // adj: c1z = -sz                                                                     <L 782>
        wp::adj_neg(var_174, adj_174, adj_203);
        // adj: c1y = -sy                                                                     <L 781>
        wp::adj_copy(var_164, adj_164, adj_202);
        // adj: c1x = sx                                                                      <L 780>
        wp::adj_neg(var_184, adj_184, adj_201);
        // adj: c0z = -sz                                                                     <L 779>
        wp::adj_neg(var_174, adj_174, adj_200);
        // adj: c0y = -sy                                                                     <L 778>
        wp::adj_neg(var_164, adj_164, adj_199);
        // adj: c0x = -sx                                                                     <L 777>
    }
    // adj: if edge_id == 0:  # 0-1                                                           <L 776>
    wp::adj_float(var_195, adj_195, adj_196);
    // adj: c1z = float(0.0)                                                                  <L 774>
    wp::adj_float(var_193, adj_193, adj_194);
    // adj: c1y = float(0.0)                                                                  <L 773>
    wp::adj_float(var_191, adj_191, adj_192);
    // adj: c1x = float(0.0)                                                                  <L 772>
    wp::adj_float(var_189, adj_189, adj_190);
    // adj: c0z = float(0.0)                                                                  <L 771>
    wp::adj_float(var_187, adj_187, adj_188);
    // adj: c0y = float(0.0)                                                                  <L 770>
    wp::adj_float(var_185, adj_185, adj_186);
    // adj: c0x = float(0.0)                                                                  <L 769>
    wp::adj_sqrt(var_183, var_184, adj_183, adj_184);
    wp::adj_abs(var_182, adj_182, adj_183);
    wp::adj_sub(var_179, var_181, adj_179, adj_181, adj_182);
    wp::adj_extract(var_154, var_180, adj_154, adj_180, adj_181);
    wp::adj_add(var_176, var_178, adj_176, adj_178, adj_179);
    wp::adj_extract(var_154, var_177, adj_154, adj_177, adj_178);
    wp::adj_extract(var_154, var_175, adj_154, adj_175, adj_176);
    // adj: sz = wp.sqrt(wp.abs(box_inertia[1] + box_inertia[0] - box_inertia[2]))            <L 763>
    wp::adj_sqrt(var_173, var_174, adj_173, adj_174);
    wp::adj_abs(var_172, adj_172, adj_173);
    wp::adj_sub(var_169, var_171, adj_169, adj_171, adj_172);
    wp::adj_extract(var_154, var_170, adj_154, adj_170, adj_171);
    wp::adj_add(var_166, var_168, adj_166, adj_168, adj_169);
    wp::adj_extract(var_154, var_167, adj_154, adj_167, adj_168);
    wp::adj_extract(var_154, var_165, adj_154, adj_165, adj_166);
    // adj: sy = wp.sqrt(wp.abs(box_inertia[0] + box_inertia[2] - box_inertia[1]))            <L 762>
    wp::adj_sqrt(var_163, var_164, adj_163, adj_164);
    wp::adj_abs(var_162, adj_162, adj_163);
    wp::adj_sub(var_159, var_161, adj_159, adj_161, adj_162);
    wp::adj_extract(var_154, var_160, adj_154, adj_160, adj_161);
    wp::adj_add(var_156, var_158, adj_156, adj_158, adj_159);
    wp::adj_extract(var_154, var_157, adj_154, adj_157, adj_158);
    wp::adj_extract(var_154, var_155, adj_154, adj_155, adj_156);
    // adj: sx = wp.sqrt(wp.abs(box_inertia[2] + box_inertia[1] - box_inertia[0]))            <L 761>
    wp::adj_mul(var_150, var_153, adj_150, adj_153, adj_154);
    wp::adj_div(var_151, var_152, var_153, adj_151, adj_152, adj_153);
    wp::adj_mul(var_32, var_26, adj_32, adj_26, adj_150);
    // adj: box_inertia = principal_inertia * inv_m * (12.0 / 8.0)                            <L 760>
    wp::adj_where(var_36, var_43, var_148, adj_36, adj_43, adj_148, adj_149);
    if (!var_36) {
        wp::adj_where(var_45, var_147, var_31, adj_45, adj_147, adj_31, adj_148);
        if (var_45) {
            wp::adj_where(var_68, var_146, var_31, adj_68, adj_146, adj_31, adj_147);
            if (var_68) {
                wp::adj_transpose(var_145, adj_145, adj_146);
                wp::adj_mat_t(var_128, var_130, var_132, var_134, var_136, var_138, var_140, var_142, var_144, adj_128, adj_130, adj_132, adj_134, adj_136, adj_138, adj_140, adj_142, adj_144, adj_145);
                wp::adj_extract(var_126, var_143, adj_126, adj_143, adj_144);
                wp::adj_extract(var_126, var_141, adj_126, adj_141, adj_142);
                wp::adj_extract(var_126, var_139, adj_126, adj_139, adj_140);
                wp::adj_extract(var_125, var_137, adj_125, adj_137, adj_138);
                wp::adj_extract(var_125, var_135, adj_125, adj_135, adj_136);
                wp::adj_extract(var_125, var_133, adj_125, adj_133, adj_134);
                wp::adj_extract(var_124, var_131, adj_124, adj_131, adj_132);
                wp::adj_extract(var_124, var_129, adj_124, adj_129, adj_130);
                wp::adj_extract(var_124, var_127, adj_124, adj_127, adj_128);
                // adj: rot = wp.transpose(wp.mat33(*c0, *c1, *c2))                           <L 758>
                wp::adj_where(var_111, var_116, var_123, adj_111, adj_116, adj_123, adj_126);
                wp::adj_where(var_111, var_115, var_122, adj_111, adj_115, adj_122, adj_125);
                wp::adj_where(var_111, var_114, var_121, adj_111, adj_114, adj_121, adj_124);
                if (!var_111) {
                    wp::adj_where(var_117, var_120, var_110, adj_117, adj_120, adj_110, adj_123);
                    wp::adj_where(var_117, var_119, var_109, adj_117, adj_119, adj_109, adj_122);
                    wp::adj_where(var_117, var_118, var_108, adj_117, adj_118, adj_108, adj_121);
                    if (var_117) {
                        wp::adj_copy(var_106, adj_106, adj_120);
                        // adj: c2 = v1                                                       <L 756>
                        wp::adj_copy(var_105, adj_105, adj_119);
                        // adj: c1 = u                                                        <L 755>
                        wp::adj_copy(var_107, adj_107, adj_118);
                        // adj: c0 = v2                                                       <L 754>
                    }
                    // adj: elif d02 <= d01:  # unique col 1                                  <L 753>
                }
                if (var_111) {
                    wp::adj_copy(var_107, adj_107, adj_116);
                    // adj: c2 = v2                                                           <L 752>
                    wp::adj_copy(var_106, adj_106, adj_115);
                    // adj: c1 = v1                                                           <L 751>
                    wp::adj_copy(var_105, adj_105, adj_114);
                    // adj: c0 = u                                                            <L 750>
                }
                if (var_111) {
                }
                // adj: if d12 <= d01 and d12 <= d02:  # unique col 0                         <L 749>
                wp::adj_copy(var_105, adj_105, adj_110);
                // adj: c2 = u                                                                <L 748>
                wp::adj_copy(var_107, adj_107, adj_109);
                // adj: c1 = v2                                                               <L 747>
                wp::adj_copy(var_106, adj_106, adj_108);
                // adj: c0 = v1                                                               <L 746>
                adj_orthonormal_basis_0(var_105, var_106, var_107, adj_105, adj_106, adj_107);
                // adj: v1, v2 = orthonormal_basis(u)                                         <L 743>
                wp::adj_normalize(var_104, var_105, adj_104, adj_105);
                // adj: u = wp.normalize(u)                                                   <L 740>
                wp::adj_where(var_69, var_81, var_103, adj_69, adj_81, adj_103, adj_104);
                if (!var_69) {
                    wp::adj_where(var_82, var_92, var_102, adj_82, adj_92, adj_102, adj_103);
                    if (!var_82) {
                        wp::adj_vec_t(var_95, var_98, var_101, adj_95, adj_98, adj_101, adj_102);
                        wp::adj_extract(var_31, var_99, var_100, adj_31, adj_99, adj_100, adj_101);
                        wp::adj_extract(var_31, var_96, var_97, adj_31, adj_96, adj_97, adj_98);
                        wp::adj_extract(var_31, var_93, var_94, adj_31, adj_93, adj_94, adj_95);
                        // adj: u = wp.vec3(rot[0, 2], rot[1, 2], rot[2, 2])                  <L 739>
                    }
                    if (var_82) {
                        wp::adj_vec_t(var_85, var_88, var_91, adj_85, adj_88, adj_91, adj_92);
                        wp::adj_extract(var_31, var_89, var_90, adj_31, adj_89, adj_90, adj_91);
                        wp::adj_extract(var_31, var_86, var_87, adj_31, adj_86, adj_87, adj_88);
                        wp::adj_extract(var_31, var_83, var_84, adj_31, adj_83, adj_84, adj_85);
                        // adj: u = wp.vec3(rot[0, 1], rot[1, 1], rot[2, 1])                  <L 737>
                    }
                    // adj: elif d02 <= d01:  # e0 approx eq e2, unique = col 1               <L 736>
                }
                if (var_69) {
                    wp::adj_vec_t(var_74, var_77, var_80, adj_74, adj_77, adj_80, adj_81);
                    wp::adj_extract(var_31, var_78, var_79, adj_31, adj_78, adj_79, adj_80);
                    wp::adj_extract(var_31, var_75, var_76, adj_31, adj_75, adj_76, adj_77);
                    wp::adj_extract(var_31, var_72, var_73, adj_31, adj_72, adj_73, adj_74);
                    // adj: u = wp.vec3(rot[0, 0], rot[1, 0], rot[2, 0])                      <L 735>
                }
                if (var_69) {
                }
                // adj: if d12 <= d01 and d12 <= d02:  # e1 approx eq e2, unique = col 0      <L 734>
            }
            wp::adj_mul(var_66, var_34, adj_66, adj_34, adj_67);
            // adj: if min_diff < 0.01 * max_eig:  # within 1% -> axisymmetric                <L 732>
            wp::adj_min(var_51, var_64, adj_51, adj_64, adj_65);
            wp::adj_min(var_57, var_63, adj_57, adj_63, adj_64);
            // adj: min_diff = wp.min(d01, wp.min(d02, d12))                                  <L 731>
            wp::adj_abs(var_62, adj_62, adj_63);
            wp::adj_sub(var_59, var_61, adj_59, adj_61, adj_62);
            wp::adj_extract(var_32, var_60, adj_32, adj_60, adj_61);
            wp::adj_extract(var_32, var_58, adj_32, adj_58, adj_59);
            // adj: d12 = wp.abs(principal_inertia[1] - principal_inertia[2])                 <L 730>
            wp::adj_abs(var_56, adj_56, adj_57);
            wp::adj_sub(var_53, var_55, adj_53, adj_55, adj_56);
            wp::adj_extract(var_32, var_54, adj_32, adj_54, adj_55);
            wp::adj_extract(var_32, var_52, adj_32, adj_52, adj_53);
            // adj: d02 = wp.abs(principal_inertia[0] - principal_inertia[2])                 <L 729>
            wp::adj_abs(var_50, adj_50, adj_51);
            wp::adj_sub(var_47, var_49, adj_47, adj_49, adj_50);
            wp::adj_extract(var_32, var_48, adj_32, adj_48, adj_49);
            wp::adj_extract(var_32, var_46, adj_32, adj_46, adj_47);
            // adj: d01 = wp.abs(principal_inertia[0] - principal_inertia[1])                 <L 728>
        }
        // adj: elif min_eig > 0.0:                                                           <L 724>
    }
    if (var_36) {
        // adj: rot = wp.identity(3, float)                                                   <L 723>
    }
    if (var_36) {
        wp::adj_mul(var_39, var_35, adj_39, adj_35, adj_40);
    }
    // adj: if min_eig > 0.0 and max_eig < 1.01 * min_eig:  # within 1% -> isotropic          <L 722>
    wp::adj_min(var_32, adj_32, adj_35);
    // adj: min_eig = wp.min(principal_inertia)                                               <L 721>
    wp::adj_max(var_32, adj_32, adj_34);
    // adj: max_eig = wp.max(principal_inertia)                                               <L 720>
    wp::adj_eig3(var_33, var_31, var_32, adj_30, adj_31, adj_32);
    wp::adj_address(var_body_inertia, var_2, adj_body_inertia, adj_2, adj_30);
    // adj: rot, principal_inertia = wp.eig3(body_inertia[body_id])                           <L 715>
    if (var_29) {
        label1:;
        // adj: return                                                                        <L 712>
        wp::adj_array_store(var_line_colors, var_0, var_15, adj_line_colors, adj_0, adj_15);
        // adj: line_colors[tid] = zero_color                                                 <L 711>
        wp::adj_array_store(var_line_ends, var_0, var_11, adj_line_ends, adj_0, adj_11);
        // adj: line_ends[tid] = nan_line                                                     <L 710>
        wp::adj_array_store(var_line_starts, var_0, var_11, adj_line_starts, adj_0, adj_11);
        // adj: line_starts[tid] = nan_line                                                   <L 709>
    }
    // adj: if inv_m == 0.0:                                                                  <L 708>
    wp::adj_copy(var_27, adj_25, adj_26);
    wp::adj_address(var_body_inv_mass, var_2, adj_body_inv_mass, adj_2, adj_25);
    // adj: inv_m = body_inv_mass[body_id]                                                    <L 707>
    if (var_visible_worlds_mask) {
        if (var_20) {
            if (var_23) {
                label0:;
                // adj: return                                                                <L 705>
                wp::adj_array_store(var_line_colors, var_0, var_15, adj_line_colors, adj_0, adj_15);
                // adj: line_colors[tid] = zero_color                                         <L 704>
                wp::adj_array_store(var_line_ends, var_0, var_11, adj_line_ends, adj_0, adj_11);
                // adj: line_ends[tid] = nan_line                                             <L 703>
                wp::adj_array_store(var_line_starts, var_0, var_11, adj_line_starts, adj_0, adj_11);
                // adj: line_starts[tid] = nan_line                                           <L 702>
            }
            wp::adj_address(var_visible_worlds_mask, var_17, adj_visible_worlds_mask, adj_17, adj_21);
            // adj: if visible_worlds_mask[world_idx] == 0:                                   <L 701>
        }
        // adj: if world_idx >= 0:                                                            <L 700>
    }
    // adj: if visible_worlds_mask:                                                           <L 699>
    wp::adj_copy(var_18, adj_16, adj_17);
    wp::adj_address(var_body_world, var_2, adj_body_world, adj_2, adj_16);
    // adj: world_idx = body_world[body_id]                                                   <L 698>
    wp::adj_vec_t(var_12, var_13, var_14, adj_12, adj_13, adj_14, adj_15);
    // adj: zero_color = wp.vec3(0.0, 0.0, 0.0)                                               <L 695>
    wp::adj_vec_t(var_6, var_8, var_10, adj_6, adj_8, adj_10, adj_11);
    // adj: nan_line = wp.vec3(wp.nan, wp.nan, wp.nan)                                        <L 694>
    wp::adj_mod(var_0, var_3, adj_0, adj_3, adj_4);
    // adj: edge_id = tid % 12                                                                <L 692>
    // adj: body_id = tid // 12                                                               <L 691>
    // adj: tid = wp.tid()                                                                    <L 690>
    // adj: def compute_inertia_box_lines(                                                    <L 674>
    return;
}



extern "C" {

// Python CPU entry points
WP_API void compute_inertia_box_lines_56517d50_cpu_forward(
    wp::launch_bounds_t<1> *dim,
    wp_args_compute_inertia_box_lines_56517d50 *_wp_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        compute_inertia_box_lines_56517d50_cpu_kernel_forward(*dim, task_index, _wp_args);
    }
}

} // extern C



extern "C" {

WP_API void compute_inertia_box_lines_56517d50_cpu_backward(
    wp::launch_bounds_t<1> *dim,
    wp_args_compute_inertia_box_lines_56517d50 *_wp_args,
    wp_args_compute_inertia_box_lines_56517d50 *_wp_adj_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        compute_inertia_box_lines_56517d50_cpu_kernel_backward(*dim, task_index, _wp_args, _wp_adj_args);
    }
}

} // extern C

struct wp_args_compute_hydro_contact_surface_lines_a3ccf060 {
    wp::array_t<wp::vec_t<3, wp::float32>> triangle_vertices;
    wp::array_t<wp::float32> face_depths;
    wp::array_t<wp::vec_t<2, wp::int32>> face_shape_pairs;
    wp::array_t<wp::int32> shape_world;
    wp::array_t<wp::vec_t<3, wp::float32>> world_offsets;
    wp::transform_t<wp::float32> layer_xform;
    wp::array_t<wp::int32> visible_worlds_mask;
    wp::int32 num_faces;
    wp::float32 min_depth;
    wp::float32 max_depth;
    bool penetrating_only;
    wp::array_t<wp::vec_t<3, wp::float32>> line_starts;
    wp::array_t<wp::vec_t<3, wp::float32>> line_ends;
    wp::array_t<wp::vec_t<3, wp::float32>> line_colors;
};


void compute_hydro_contact_surface_lines_a3ccf060_cpu_kernel_forward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_compute_hydro_contact_surface_lines_a3ccf060 *_wp_args)
{
    //---------
    // argument vars
    wp::array_t<wp::vec_t<3, wp::float32>> var_triangle_vertices = _wp_args->triangle_vertices;
    wp::array_t<wp::float32> var_face_depths = _wp_args->face_depths;
    wp::array_t<wp::vec_t<2, wp::int32>> var_face_shape_pairs = _wp_args->face_shape_pairs;
    wp::array_t<wp::int32> var_shape_world = _wp_args->shape_world;
    wp::array_t<wp::vec_t<3, wp::float32>> var_world_offsets = _wp_args->world_offsets;
    wp::transform_t<wp::float32> var_layer_xform = _wp_args->layer_xform;
    wp::array_t<wp::int32> var_visible_worlds_mask = _wp_args->visible_worlds_mask;
    wp::int32 var_num_faces = _wp_args->num_faces;
    wp::float32 var_min_depth = _wp_args->min_depth;
    wp::float32 var_max_depth = _wp_args->max_depth;
    bool var_penetrating_only = _wp_args->penetrating_only;
    wp::array_t<wp::vec_t<3, wp::float32>> var_line_starts = _wp_args->line_starts;
    wp::array_t<wp::vec_t<3, wp::float32>> var_line_ends = _wp_args->line_ends;
    wp::array_t<wp::vec_t<3, wp::float32>> var_line_colors = _wp_args->line_colors;
    //---------
    // primal vars
    wp::int32 var_0;
    bool var_1;
    const wp::float32 var_2 = 0.0;
    const wp::float32 var_3 = 0.0;
    const wp::float32 var_4 = 0.0;
    wp::vec_t<3, wp::float32> var_5;
    bool var_6;
    wp::vec_t<2, wp::int32>* var_7;
    wp::vec_t<2, wp::int32> var_8;
    wp::vec_t<2, wp::int32> var_9;
    const wp::int32 var_10 = 0;
    wp::int32 var_11;
    wp::int32* var_12;
    wp::int32 var_13;
    wp::int32 var_14;
    const wp::int32 var_15 = 1;
    wp::int32 var_16;
    wp::int32* var_17;
    wp::int32 var_18;
    wp::int32 var_19;
    const wp::int32 var_20 = 0;
    bool var_21;
    wp::int32 var_22;
    const wp::int32 var_23 = 0;
    bool var_24;
    wp::int32* var_25;
    const wp::int32 var_26 = 0;
    bool var_27;
    wp::int32 var_28;
    const wp::int32 var_29 = 3;
    wp::int32 var_30;
    const wp::int32 var_31 = 0;
    wp::int32 var_32;
    const wp::int32 var_33 = 3;
    wp::int32 var_34;
    const wp::int32 var_35 = 0;
    wp::int32 var_36;
    const wp::int32 var_37 = 3;
    wp::int32 var_38;
    const wp::int32 var_39 = 0;
    wp::int32 var_40;
    const wp::int32 var_41 = 3;
    wp::int32 var_42;
    const wp::int32 var_43 = 1;
    wp::int32 var_44;
    const wp::int32 var_45 = 3;
    wp::int32 var_46;
    const wp::int32 var_47 = 1;
    wp::int32 var_48;
    const wp::int32 var_49 = 3;
    wp::int32 var_50;
    const wp::int32 var_51 = 1;
    wp::int32 var_52;
    const wp::int32 var_53 = 3;
    wp::int32 var_54;
    const wp::int32 var_55 = 2;
    wp::int32 var_56;
    const wp::int32 var_57 = 3;
    wp::int32 var_58;
    const wp::int32 var_59 = 2;
    wp::int32 var_60;
    const wp::int32 var_61 = 3;
    wp::int32 var_62;
    const wp::int32 var_63 = 2;
    wp::int32 var_64;
    const wp::int32 var_65 = 3;
    wp::int32 var_66;
    const wp::int32 var_67 = 0;
    wp::int32 var_68;
    wp::vec_t<3, wp::float32>* var_69;
    wp::vec_t<3, wp::float32> var_70;
    wp::vec_t<3, wp::float32> var_71;
    const wp::int32 var_72 = 3;
    wp::int32 var_73;
    const wp::int32 var_74 = 1;
    wp::int32 var_75;
    wp::vec_t<3, wp::float32>* var_76;
    wp::vec_t<3, wp::float32> var_77;
    wp::vec_t<3, wp::float32> var_78;
    const wp::int32 var_79 = 3;
    wp::int32 var_80;
    const wp::int32 var_81 = 2;
    wp::int32 var_82;
    wp::vec_t<3, wp::float32>* var_83;
    wp::vec_t<3, wp::float32> var_84;
    wp::vec_t<3, wp::float32> var_85;
    wp::float32* var_86;
    wp::float32 var_87;
    wp::float32 var_88;
    bool var_89;
    const wp::float32 var_90 = 0.0;
    bool var_91;
    const wp::int32 var_92 = 3;
    wp::int32 var_93;
    const wp::int32 var_94 = 0;
    wp::int32 var_95;
    const wp::int32 var_96 = 3;
    wp::int32 var_97;
    const wp::int32 var_98 = 0;
    wp::int32 var_99;
    const wp::int32 var_100 = 3;
    wp::int32 var_101;
    const wp::int32 var_102 = 0;
    wp::int32 var_103;
    const wp::int32 var_104 = 3;
    wp::int32 var_105;
    const wp::int32 var_106 = 1;
    wp::int32 var_107;
    const wp::int32 var_108 = 3;
    wp::int32 var_109;
    const wp::int32 var_110 = 1;
    wp::int32 var_111;
    const wp::int32 var_112 = 3;
    wp::int32 var_113;
    const wp::int32 var_114 = 1;
    wp::int32 var_115;
    const wp::int32 var_116 = 3;
    wp::int32 var_117;
    const wp::int32 var_118 = 2;
    wp::int32 var_119;
    const wp::int32 var_120 = 3;
    wp::int32 var_121;
    const wp::int32 var_122 = 2;
    wp::int32 var_123;
    const wp::int32 var_124 = 3;
    wp::int32 var_125;
    const wp::int32 var_126 = 2;
    wp::int32 var_127;
    const wp::float32 var_128 = 0.0;
    const wp::float32 var_129 = 0.0;
    const wp::float32 var_130 = 0.0;
    wp::vec_t<3, wp::float32> var_131;
    bool var_132;
    wp::vec_t<2, wp::int32>* var_133;
    wp::vec_t<2, wp::int32> var_134;
    wp::vec_t<2, wp::int32> var_135;
    const wp::int32 var_136 = 0;
    wp::int32 var_137;
    wp::int32* var_138;
    wp::int32 var_139;
    wp::int32 var_140;
    const wp::int32 var_141 = 1;
    wp::int32 var_142;
    wp::int32* var_143;
    wp::int32 var_144;
    wp::int32 var_145;
    bool var_146;
    const wp::int32 var_147 = 0;
    bool var_148;
    const wp::int32 var_149 = 0;
    bool var_150;
    const wp::int32 var_151 = 0;
    bool var_152;
    wp::int32 var_153;
    wp::vec_t<3, wp::float32>* var_154;
    wp::vec_t<3, wp::float32> var_155;
    wp::vec_t<3, wp::float32> var_156;
    wp::vec_t<3, wp::float32> var_157;
    wp::vec_t<2, wp::int32> var_158;
    wp::int32 var_159;
    wp::int32 var_160;
    wp::vec_t<3, wp::float32> var_161;
    wp::vec_t<3, wp::float32> var_162;
    wp::vec_t<3, wp::float32> var_163;
    wp::vec_t<3, wp::float32> var_164;
    wp::vec_t<3, wp::float32> var_165;
    wp::vec_t<3, wp::float32> var_166;
    wp::vec_t<3, wp::float32> var_167;
    const wp::float32 var_168 = 0.0;
    bool var_169;
    wp::float32 var_170;
    wp::vec_t<3, wp::float32> var_171;
    const wp::float32 var_172 = 0.0;
    const wp::float32 var_173 = 0.0;
    const wp::float32 var_174 = 0.0;
    wp::vec_t<3, wp::float32> var_175;
    wp::vec_t<3, wp::float32> var_176;
    const wp::int32 var_177 = 3;
    wp::int32 var_178;
    const wp::int32 var_179 = 0;
    wp::int32 var_180;
    const wp::int32 var_181 = 3;
    wp::int32 var_182;
    const wp::int32 var_183 = 0;
    wp::int32 var_184;
    const wp::int32 var_185 = 3;
    wp::int32 var_186;
    const wp::int32 var_187 = 0;
    wp::int32 var_188;
    const wp::int32 var_189 = 3;
    wp::int32 var_190;
    const wp::int32 var_191 = 1;
    wp::int32 var_192;
    const wp::int32 var_193 = 3;
    wp::int32 var_194;
    const wp::int32 var_195 = 1;
    wp::int32 var_196;
    const wp::int32 var_197 = 3;
    wp::int32 var_198;
    const wp::int32 var_199 = 1;
    wp::int32 var_200;
    const wp::int32 var_201 = 3;
    wp::int32 var_202;
    const wp::int32 var_203 = 2;
    wp::int32 var_204;
    const wp::int32 var_205 = 3;
    wp::int32 var_206;
    const wp::int32 var_207 = 2;
    wp::int32 var_208;
    const wp::int32 var_209 = 3;
    wp::int32 var_210;
    const wp::int32 var_211 = 2;
    wp::int32 var_212;
    //---------
    // forward
    // def compute_hydro_contact_surface_lines(                                               <L 917>
    // tid = wp.tid()                                                                         <L 934>
    var_0 = builtin_tid1d();
    // if tid >= num_faces:                                                                   <L 935>
    var_1 = (var_0 >= var_num_faces);
    if (var_1) {
        // return                                                                             <L 936>
        return;
    }
    // zero = wp.vec3(0.0, 0.0, 0.0)                                                          <L 938>
    var_5 = wp::vec_t<3, wp::float32>(var_2, var_3, var_4);
    // if visible_worlds_mask and shape_world:                                                <L 941>
    var_6 = var_visible_worlds_mask;
    if (var_6) {
        var_6 = var_6 && var_shape_world;
    }
    if (var_6) {
        // shape_pair = face_shape_pairs[tid]                                                 <L 942>
        var_7 = wp::address(var_face_shape_pairs, var_0);
        var_9 = wp::load(var_7);
        var_8 = wp::copy(var_9);
        // world_a = shape_world[shape_pair[0]]                                               <L 943>
        var_11 = wp::extract(var_8, var_10);
        var_12 = wp::address(var_shape_world, var_11);
        var_14 = wp::load(var_12);
        var_13 = wp::copy(var_14);
        // world_b = shape_world[shape_pair[1]]                                               <L 944>
        var_16 = wp::extract(var_8, var_15);
        var_17 = wp::address(var_shape_world, var_16);
        var_19 = wp::load(var_17);
        var_18 = wp::copy(var_19);
        // w = world_a if world_a >= 0 else world_b                                           <L 945>
        var_21 = (var_13 >= var_20);
        if (var_21) {
        }
        if (!var_21) {
        }
        var_22 = wp::where(var_21, var_13, var_18);
        // if w >= 0:                                                                         <L 946>
        var_24 = (var_22 >= var_23);
        if (var_24) {
            // if visible_worlds_mask[w] == 0:                                                <L 947>
            var_25 = wp::address(var_visible_worlds_mask, var_22);
            var_28 = wp::load(var_25);
            var_27 = (var_28 == var_26);
            if (var_27) {
                // line_starts[tid * 3 + 0] = zero                                            <L 948>
                var_30 = wp::mul(var_0, var_29);
                var_32 = wp::add(var_30, var_31);
                wp::array_store(var_line_starts, var_32, var_5);
                // line_ends[tid * 3 + 0] = zero                                              <L 949>
                var_34 = wp::mul(var_0, var_33);
                var_36 = wp::add(var_34, var_35);
                wp::array_store(var_line_ends, var_36, var_5);
                // line_colors[tid * 3 + 0] = zero                                            <L 950>
                var_38 = wp::mul(var_0, var_37);
                var_40 = wp::add(var_38, var_39);
                wp::array_store(var_line_colors, var_40, var_5);
                // line_starts[tid * 3 + 1] = zero                                            <L 951>
                var_42 = wp::mul(var_0, var_41);
                var_44 = wp::add(var_42, var_43);
                wp::array_store(var_line_starts, var_44, var_5);
                // line_ends[tid * 3 + 1] = zero                                              <L 952>
                var_46 = wp::mul(var_0, var_45);
                var_48 = wp::add(var_46, var_47);
                wp::array_store(var_line_ends, var_48, var_5);
                // line_colors[tid * 3 + 1] = zero                                            <L 953>
                var_50 = wp::mul(var_0, var_49);
                var_52 = wp::add(var_50, var_51);
                wp::array_store(var_line_colors, var_52, var_5);
                // line_starts[tid * 3 + 2] = zero                                            <L 954>
                var_54 = wp::mul(var_0, var_53);
                var_56 = wp::add(var_54, var_55);
                wp::array_store(var_line_starts, var_56, var_5);
                // line_ends[tid * 3 + 2] = zero                                              <L 955>
                var_58 = wp::mul(var_0, var_57);
                var_60 = wp::add(var_58, var_59);
                wp::array_store(var_line_ends, var_60, var_5);
                // line_colors[tid * 3 + 2] = zero                                            <L 956>
                var_62 = wp::mul(var_0, var_61);
                var_64 = wp::add(var_62, var_63);
                wp::array_store(var_line_colors, var_64, var_5);
                // return                                                                     <L 957>
                return;
            }
        }
    }
    // v0 = triangle_vertices[tid * 3 + 0]                                                    <L 960>
    var_66 = wp::mul(var_0, var_65);
    var_68 = wp::add(var_66, var_67);
    var_69 = wp::address(var_triangle_vertices, var_68);
    var_71 = wp::load(var_69);
    var_70 = wp::copy(var_71);
    // v1 = triangle_vertices[tid * 3 + 1]                                                    <L 961>
    var_73 = wp::mul(var_0, var_72);
    var_75 = wp::add(var_73, var_74);
    var_76 = wp::address(var_triangle_vertices, var_75);
    var_78 = wp::load(var_76);
    var_77 = wp::copy(var_78);
    // v2 = triangle_vertices[tid * 3 + 2]                                                    <L 962>
    var_80 = wp::mul(var_0, var_79);
    var_82 = wp::add(var_80, var_81);
    var_83 = wp::address(var_triangle_vertices, var_82);
    var_85 = wp::load(var_83);
    var_84 = wp::copy(var_85);
    // depth = face_depths[tid]                                                               <L 965>
    var_86 = wp::address(var_face_depths, var_0);
    var_88 = wp::load(var_86);
    var_87 = wp::copy(var_88);
    // if penetrating_only and depth >= 0.0:                                                  <L 968>
    var_89 = var_penetrating_only;
    if (var_89) {
        var_91 = (var_87 >= var_90);
        var_89 = var_89 && var_91;
    }
    if (var_89) {
        // line_starts[tid * 3 + 0] = zero                                                    <L 969>
        var_93 = wp::mul(var_0, var_92);
        var_95 = wp::add(var_93, var_94);
        wp::array_store(var_line_starts, var_95, var_5);
        // line_ends[tid * 3 + 0] = zero                                                      <L 970>
        var_97 = wp::mul(var_0, var_96);
        var_99 = wp::add(var_97, var_98);
        wp::array_store(var_line_ends, var_99, var_5);
        // line_colors[tid * 3 + 0] = zero                                                    <L 971>
        var_101 = wp::mul(var_0, var_100);
        var_103 = wp::add(var_101, var_102);
        wp::array_store(var_line_colors, var_103, var_5);
        // line_starts[tid * 3 + 1] = zero                                                    <L 972>
        var_105 = wp::mul(var_0, var_104);
        var_107 = wp::add(var_105, var_106);
        wp::array_store(var_line_starts, var_107, var_5);
        // line_ends[tid * 3 + 1] = zero                                                      <L 973>
        var_109 = wp::mul(var_0, var_108);
        var_111 = wp::add(var_109, var_110);
        wp::array_store(var_line_ends, var_111, var_5);
        // line_colors[tid * 3 + 1] = zero                                                    <L 974>
        var_113 = wp::mul(var_0, var_112);
        var_115 = wp::add(var_113, var_114);
        wp::array_store(var_line_colors, var_115, var_5);
        // line_starts[tid * 3 + 2] = zero                                                    <L 975>
        var_117 = wp::mul(var_0, var_116);
        var_119 = wp::add(var_117, var_118);
        wp::array_store(var_line_starts, var_119, var_5);
        // line_ends[tid * 3 + 2] = zero                                                      <L 976>
        var_121 = wp::mul(var_0, var_120);
        var_123 = wp::add(var_121, var_122);
        wp::array_store(var_line_ends, var_123, var_5);
        // line_colors[tid * 3 + 2] = zero                                                    <L 977>
        var_125 = wp::mul(var_0, var_124);
        var_127 = wp::add(var_125, var_126);
        wp::array_store(var_line_colors, var_127, var_5);
        // return                                                                             <L 978>
        return;
    }
    // offset = wp.vec3(0.0, 0.0, 0.0)                                                        <L 981>
    var_131 = wp::vec_t<3, wp::float32>(var_128, var_129, var_130);
    // if shape_world and world_offsets:                                                      <L 982>
    var_132 = var_shape_world;
    if (var_132) {
        var_132 = var_132 && var_world_offsets;
    }
    if (var_132) {
        // shape_pair = face_shape_pairs[tid]                                                 <L 983>
        var_133 = wp::address(var_face_shape_pairs, var_0);
        var_135 = wp::load(var_133);
        var_134 = wp::copy(var_135);
        // world_a = shape_world[shape_pair[0]]                                               <L 984>
        var_137 = wp::extract(var_134, var_136);
        var_138 = wp::address(var_shape_world, var_137);
        var_140 = wp::load(var_138);
        var_139 = wp::copy(var_140);
        // world_b = shape_world[shape_pair[1]]                                               <L 985>
        var_142 = wp::extract(var_134, var_141);
        var_143 = wp::address(var_shape_world, var_142);
        var_145 = wp::load(var_143);
        var_144 = wp::copy(var_145);
        // if world_a >= 0 or world_b >= 0:                                                   <L 986>
        var_148 = (var_139 >= var_147);
        var_146 = var_148;
        if (!var_146) {
            var_150 = (var_144 >= var_149);
            var_146 = var_146 || var_150;
        }
        if (var_146) {
            // offset = world_offsets[world_a if world_a >= 0 else world_b]                   <L 987>
            var_152 = (var_139 >= var_151);
            if (var_152) {
            }
            if (!var_152) {
            }
            var_153 = wp::where(var_152, var_139, var_144);
            var_154 = wp::address(var_world_offsets, var_153);
            var_156 = wp::load(var_154);
            var_155 = wp::copy(var_156);
        }
        var_157 = wp::where(var_146, var_155, var_131);
    }
    var_158 = wp::where(var_132, var_134, var_8);
    var_159 = wp::where(var_132, var_139, var_13);
    var_160 = wp::where(var_132, var_144, var_18);
    var_161 = wp::where(var_132, var_157, var_131);
    // v0 = wp.transform_point(layer_xform, v0 + offset)                                      <L 989>
    var_162 = wp::add(var_70, var_161);
    var_163 = wp::transform_point(var_layer_xform, var_162);
    // v1 = wp.transform_point(layer_xform, v1 + offset)                                      <L 990>
    var_164 = wp::add(var_77, var_161);
    var_165 = wp::transform_point(var_layer_xform, var_164);
    // v2 = wp.transform_point(layer_xform, v2 + offset)                                      <L 991>
    var_166 = wp::add(var_84, var_161);
    var_167 = wp::transform_point(var_layer_xform, var_166);
    // if depth < 0.0:                                                                        <L 994>
    var_169 = (var_87 < var_168);
    if (var_169) {
        // color = depth_to_color(-depth, min_depth, max_depth)                               <L 995>
        var_170 = wp::neg(var_87);
        var_171 = depth_to_color_0(var_170, var_min_depth, var_max_depth);
    }
    if (!var_169) {
        // color = wp.vec3(0.0, 0.0, 0.0)                                                     <L 997>
        var_175 = wp::vec_t<3, wp::float32>(var_172, var_173, var_174);
    }
    var_176 = wp::where(var_169, var_171, var_175);
    // line_starts[tid * 3 + 0] = v0                                                          <L 1001>
    var_178 = wp::mul(var_0, var_177);
    var_180 = wp::add(var_178, var_179);
    wp::array_store(var_line_starts, var_180, var_163);
    // line_ends[tid * 3 + 0] = v1                                                            <L 1002>
    var_182 = wp::mul(var_0, var_181);
    var_184 = wp::add(var_182, var_183);
    wp::array_store(var_line_ends, var_184, var_165);
    // line_colors[tid * 3 + 0] = color                                                       <L 1003>
    var_186 = wp::mul(var_0, var_185);
    var_188 = wp::add(var_186, var_187);
    wp::array_store(var_line_colors, var_188, var_176);
    // line_starts[tid * 3 + 1] = v1                                                          <L 1006>
    var_190 = wp::mul(var_0, var_189);
    var_192 = wp::add(var_190, var_191);
    wp::array_store(var_line_starts, var_192, var_165);
    // line_ends[tid * 3 + 1] = v2                                                            <L 1007>
    var_194 = wp::mul(var_0, var_193);
    var_196 = wp::add(var_194, var_195);
    wp::array_store(var_line_ends, var_196, var_167);
    // line_colors[tid * 3 + 1] = color                                                       <L 1008>
    var_198 = wp::mul(var_0, var_197);
    var_200 = wp::add(var_198, var_199);
    wp::array_store(var_line_colors, var_200, var_176);
    // line_starts[tid * 3 + 2] = v2                                                          <L 1011>
    var_202 = wp::mul(var_0, var_201);
    var_204 = wp::add(var_202, var_203);
    wp::array_store(var_line_starts, var_204, var_167);
    // line_ends[tid * 3 + 2] = v0                                                            <L 1012>
    var_206 = wp::mul(var_0, var_205);
    var_208 = wp::add(var_206, var_207);
    wp::array_store(var_line_ends, var_208, var_163);
    // line_colors[tid * 3 + 2] = color                                                       <L 1013>
    var_210 = wp::mul(var_0, var_209);
    var_212 = wp::add(var_210, var_211);
    wp::array_store(var_line_colors, var_212, var_176);
}



extern "C" {

// Python CPU entry points
WP_API void compute_hydro_contact_surface_lines_a3ccf060_cpu_forward(
    wp::launch_bounds_t<1> *dim,
    wp_args_compute_hydro_contact_surface_lines_a3ccf060 *_wp_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        compute_hydro_contact_surface_lines_a3ccf060_cpu_kernel_forward(*dim, task_index, _wp_args);
    }
}

} // extern C

struct wp_args_compute_contact_lines_fa0a8efe {
    wp::array_t<wp::transform_t<wp::float32>> body_q;
    wp::array_t<wp::int32> shape_body;
    wp::array_t<wp::int32> shape_world;
    wp::array_t<wp::vec_t<3, wp::float32>> world_offsets;
    wp::transform_t<wp::float32> layer_xform;
    wp::array_t<wp::int32> visible_worlds_mask;
    wp::array_t<wp::int32> contact_count;
    wp::array_t<wp::int32> contact_shape0;
    wp::array_t<wp::int32> contact_shape1;
    wp::array_t<wp::vec_t<3, wp::float32>> contact_point0;
    wp::array_t<wp::vec_t<3, wp::float32>> contact_offset0;
    wp::array_t<wp::vec_t<3, wp::float32>> contact_normal;
    wp::float32 line_scale;
    wp::array_t<wp::vec_t<3, wp::float32>> line_start;
    wp::array_t<wp::vec_t<3, wp::float32>> line_end;
};


void compute_contact_lines_fa0a8efe_cpu_kernel_forward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_compute_contact_lines_fa0a8efe *_wp_args)
{
    //---------
    // argument vars
    wp::array_t<wp::transform_t<wp::float32>> var_body_q = _wp_args->body_q;
    wp::array_t<wp::int32> var_shape_body = _wp_args->shape_body;
    wp::array_t<wp::int32> var_shape_world = _wp_args->shape_world;
    wp::array_t<wp::vec_t<3, wp::float32>> var_world_offsets = _wp_args->world_offsets;
    wp::transform_t<wp::float32> var_layer_xform = _wp_args->layer_xform;
    wp::array_t<wp::int32> var_visible_worlds_mask = _wp_args->visible_worlds_mask;
    wp::array_t<wp::int32> var_contact_count = _wp_args->contact_count;
    wp::array_t<wp::int32> var_contact_shape0 = _wp_args->contact_shape0;
    wp::array_t<wp::int32> var_contact_shape1 = _wp_args->contact_shape1;
    wp::array_t<wp::vec_t<3, wp::float32>> var_contact_point0 = _wp_args->contact_point0;
    wp::array_t<wp::vec_t<3, wp::float32>> var_contact_offset0 = _wp_args->contact_offset0;
    wp::array_t<wp::vec_t<3, wp::float32>> var_contact_normal = _wp_args->contact_normal;
    wp::float32 var_line_scale = _wp_args->line_scale;
    wp::array_t<wp::vec_t<3, wp::float32>> var_line_start = _wp_args->line_start;
    wp::array_t<wp::vec_t<3, wp::float32>> var_line_end = _wp_args->line_end;
    //---------
    // primal vars
    wp::int32 var_0;
    const wp::float32 var_1 = NAN;
    const wp::float32 var_2 = NAN;
    const wp::float32 var_3 = NAN;
    const wp::float32 var_4 = NAN;
    const wp::float32 var_5 = NAN;
    const wp::float32 var_6 = NAN;
    wp::vec_t<3, wp::float32> var_7;
    const wp::int32 var_8 = 0;
    wp::int32* var_9;
    wp::int32 var_10;
    wp::int32 var_11;
    bool var_12;
    wp::int32* var_13;
    wp::int32 var_14;
    wp::int32 var_15;
    wp::int32* var_16;
    wp::int32 var_17;
    wp::int32 var_18;
    bool var_19;
    wp::int32* var_20;
    wp::int32 var_21;
    wp::int32 var_22;
    wp::int32* var_23;
    wp::int32 var_24;
    wp::int32 var_25;
    const wp::int32 var_26 = 0;
    bool var_27;
    wp::int32 var_28;
    const wp::int32 var_29 = 0;
    bool var_30;
    wp::int32* var_31;
    const wp::int32 var_32 = 0;
    bool var_33;
    wp::int32 var_34;
    wp::int32* var_35;
    wp::int32 var_36;
    wp::int32 var_37;
    wp::transform_t<wp::float32> var_38;
    const wp::int32 var_39 = 0;
    bool var_40;
    wp::transform_t<wp::float32>* var_41;
    wp::transform_t<wp::float32> var_42;
    wp::transform_t<wp::float32> var_43;
    wp::transform_t<wp::float32> var_44;
    wp::vec_t<3, wp::float32>* var_45;
    wp::vec_t<3, wp::float32>* var_46;
    wp::vec_t<3, wp::float32> var_47;
    wp::vec_t<3, wp::float32> var_48;
    wp::vec_t<3, wp::float32> var_49;
    wp::vec_t<3, wp::float32> var_50;
    wp::vec_t<3, wp::float32> var_51;
    bool var_52;
    const wp::int32 var_53 = 0;
    bool var_54;
    const wp::int32 var_55 = 0;
    bool var_56;
    const wp::int32 var_57 = 0;
    bool var_58;
    wp::int32 var_59;
    wp::vec_t<3, wp::float32>* var_60;
    wp::vec_t<3, wp::float32> var_61;
    wp::vec_t<3, wp::float32> var_62;
    wp::vec_t<3, wp::float32> var_63;
    wp::vec_t<3, wp::float32> var_64;
    wp::quat_t<wp::float32> var_65;
    wp::vec_t<3, wp::float32>* var_66;
    wp::vec_t<3, wp::float32> var_67;
    wp::vec_t<3, wp::float32> var_68;
    wp::vec_t<3, wp::float32> var_69;
    wp::vec_t<3, wp::float32> var_70;
    //---------
    // forward
    // def compute_contact_lines(                                                             <L 256>
    // tid = wp.tid()                                                                         <L 275>
    var_0 = builtin_tid1d();
    // nan_line = wp.vec3(wp.nan, wp.nan, wp.nan)                                             <L 276>
    var_7 = wp::vec_t<3, wp::float32>(var_2, var_4, var_6);
    // count = contact_count[0]                                                               <L 277>
    var_9 = wp::address(var_contact_count, var_8);
    var_11 = wp::load(var_9);
    var_10 = wp::copy(var_11);
    // if tid >= count:                                                                       <L 278>
    var_12 = (var_0 >= var_10);
    if (var_12) {
        // line_start[tid] = nan_line                                                         <L 279>
        wp::array_store(var_line_start, var_0, var_7);
        // line_end[tid] = nan_line                                                           <L 280>
        wp::array_store(var_line_end, var_0, var_7);
        // return                                                                             <L 281>
        return;
    }
    // shape_a = contact_shape0[tid]                                                          <L 282>
    var_13 = wp::address(var_contact_shape0, var_0);
    var_15 = wp::load(var_13);
    var_14 = wp::copy(var_15);
    // shape_b = contact_shape1[tid]                                                          <L 283>
    var_16 = wp::address(var_contact_shape1, var_0);
    var_18 = wp::load(var_16);
    var_17 = wp::copy(var_18);
    // if shape_a == shape_b:                                                                 <L 284>
    var_19 = (var_14 == var_17);
    if (var_19) {
        // line_start[tid] = nan_line                                                         <L 285>
        wp::array_store(var_line_start, var_0, var_7);
        // line_end[tid] = nan_line                                                           <L 286>
        wp::array_store(var_line_end, var_0, var_7);
        // return                                                                             <L 287>
        return;
    }
    // world_a = shape_world[shape_a]                                                         <L 290>
    var_20 = wp::address(var_shape_world, var_14);
    var_22 = wp::load(var_20);
    var_21 = wp::copy(var_22);
    // world_b = shape_world[shape_b]                                                         <L 291>
    var_23 = wp::address(var_shape_world, var_17);
    var_25 = wp::load(var_23);
    var_24 = wp::copy(var_25);
    // if visible_worlds_mask:                                                                <L 292>
    if (var_visible_worlds_mask) {
        // w = world_a if world_a >= 0 else world_b                                           <L 293>
        var_27 = (var_21 >= var_26);
        if (var_27) {
        }
        if (!var_27) {
        }
        var_28 = wp::where(var_27, var_21, var_24);
        // if w >= 0:                                                                         <L 294>
        var_30 = (var_28 >= var_29);
        if (var_30) {
            // if visible_worlds_mask[w] == 0:                                                <L 295>
            var_31 = wp::address(var_visible_worlds_mask, var_28);
            var_34 = wp::load(var_31);
            var_33 = (var_34 == var_32);
            if (var_33) {
                // line_start[tid] = nan_line                                                 <L 296>
                wp::array_store(var_line_start, var_0, var_7);
                // line_end[tid] = nan_line                                                   <L 297>
                wp::array_store(var_line_end, var_0, var_7);
                // return                                                                     <L 298>
                return;
            }
        }
    }
    // body_a = shape_body[shape_a]                                                           <L 301>
    var_35 = wp::address(var_shape_body, var_14);
    var_37 = wp::load(var_35);
    var_36 = wp::copy(var_37);
    // X_wb_a = wp.transform_identity()                                                       <L 302>
    var_38 = wp::transform_identity<wp::float32>();
    // if body_a >= 0:                                                                        <L 303>
    var_40 = (var_36 >= var_39);
    if (var_40) {
        // X_wb_a = body_q[body_a]                                                            <L 304>
        var_41 = wp::address(var_body_q, var_36);
        var_43 = wp::load(var_41);
        var_42 = wp::copy(var_43);
    }
    var_44 = wp::where(var_40, var_42, var_38);
    // world_pos0 = wp.transform_point(X_wb_a, contact_point0[tid] + contact_offset0[tid])       <L 307>
    var_45 = wp::address(var_contact_point0, var_0);
    var_46 = wp::address(var_contact_offset0, var_0);
    var_48 = wp::load(var_45);
    var_49 = wp::load(var_46);
    var_47 = wp::add(var_48, var_49);
    var_50 = wp::transform_point(var_44, var_47);
    // contact_center = world_pos0                                                            <L 309>
    var_51 = wp::copy(var_50);
    // if world_a >= 0 or world_b >= 0:                                                       <L 312>
    var_54 = (var_21 >= var_53);
    var_52 = var_54;
    if (!var_52) {
        var_56 = (var_24 >= var_55);
        var_52 = var_52 || var_56;
    }
    if (var_52) {
        // contact_center += world_offsets[world_a if world_a >= 0 else world_b]              <L 313>
        var_58 = (var_21 >= var_57);
        if (var_58) {
        }
        if (!var_58) {
        }
        var_59 = wp::where(var_58, var_21, var_24);
        var_60 = wp::address(var_world_offsets, var_59);
        var_62 = wp::load(var_60);
        var_61 = wp::add(var_51, var_62);
    }
    var_63 = wp::where(var_52, var_61, var_51);
    // contact_center = wp.transform_point(layer_xform, contact_center)                       <L 316>
    var_64 = wp::transform_point(var_layer_xform, var_63);
    // normal = wp.quat_rotate(wp.transform_get_rotation(layer_xform), contact_normal[tid])       <L 317>
    var_65 = wp::transform_get_rotation(var_layer_xform);
    var_66 = wp::address(var_contact_normal, var_0);
    var_68 = wp::load(var_66);
    var_67 = wp::quat_rotate(var_65, var_68);
    // line_vector = normal * line_scale                                                      <L 321>
    var_69 = wp::mul(var_67, var_line_scale);
    // line_start[tid] = contact_center                                                       <L 323>
    wp::array_store(var_line_start, var_0, var_64);
    // line_end[tid] = contact_center + line_vector                                           <L 324>
    var_70 = wp::add(var_64, var_69);
    wp::array_store(var_line_end, var_0, var_70);
}



void compute_contact_lines_fa0a8efe_cpu_kernel_backward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_compute_contact_lines_fa0a8efe *_wp_args,
    wp_args_compute_contact_lines_fa0a8efe *_wp_adj_args)
{
    //---------
    // argument vars
    wp::array_t<wp::transform_t<wp::float32>> var_body_q = _wp_args->body_q;
    wp::array_t<wp::int32> var_shape_body = _wp_args->shape_body;
    wp::array_t<wp::int32> var_shape_world = _wp_args->shape_world;
    wp::array_t<wp::vec_t<3, wp::float32>> var_world_offsets = _wp_args->world_offsets;
    wp::transform_t<wp::float32> var_layer_xform = _wp_args->layer_xform;
    wp::array_t<wp::int32> var_visible_worlds_mask = _wp_args->visible_worlds_mask;
    wp::array_t<wp::int32> var_contact_count = _wp_args->contact_count;
    wp::array_t<wp::int32> var_contact_shape0 = _wp_args->contact_shape0;
    wp::array_t<wp::int32> var_contact_shape1 = _wp_args->contact_shape1;
    wp::array_t<wp::vec_t<3, wp::float32>> var_contact_point0 = _wp_args->contact_point0;
    wp::array_t<wp::vec_t<3, wp::float32>> var_contact_offset0 = _wp_args->contact_offset0;
    wp::array_t<wp::vec_t<3, wp::float32>> var_contact_normal = _wp_args->contact_normal;
    wp::float32 var_line_scale = _wp_args->line_scale;
    wp::array_t<wp::vec_t<3, wp::float32>> var_line_start = _wp_args->line_start;
    wp::array_t<wp::vec_t<3, wp::float32>> var_line_end = _wp_args->line_end;
    wp::array_t<wp::transform_t<wp::float32>> adj_body_q = _wp_adj_args->body_q;
    wp::array_t<wp::int32> adj_shape_body = _wp_adj_args->shape_body;
    wp::array_t<wp::int32> adj_shape_world = _wp_adj_args->shape_world;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_world_offsets = _wp_adj_args->world_offsets;
    wp::transform_t<wp::float32> adj_layer_xform = _wp_adj_args->layer_xform;
    wp::array_t<wp::int32> adj_visible_worlds_mask = _wp_adj_args->visible_worlds_mask;
    wp::array_t<wp::int32> adj_contact_count = _wp_adj_args->contact_count;
    wp::array_t<wp::int32> adj_contact_shape0 = _wp_adj_args->contact_shape0;
    wp::array_t<wp::int32> adj_contact_shape1 = _wp_adj_args->contact_shape1;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_contact_point0 = _wp_adj_args->contact_point0;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_contact_offset0 = _wp_adj_args->contact_offset0;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_contact_normal = _wp_adj_args->contact_normal;
    wp::float32 adj_line_scale = _wp_adj_args->line_scale;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_line_start = _wp_adj_args->line_start;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_line_end = _wp_adj_args->line_end;
    //---------
    // primal vars
    wp::int32 var_0;
    const wp::float32 var_1 = NAN;
    const wp::float32 var_2 = NAN;
    const wp::float32 var_3 = NAN;
    const wp::float32 var_4 = NAN;
    const wp::float32 var_5 = NAN;
    const wp::float32 var_6 = NAN;
    wp::vec_t<3, wp::float32> var_7;
    const wp::int32 var_8 = 0;
    wp::int32* var_9;
    wp::int32 var_10;
    wp::int32 var_11;
    bool var_12;
    wp::int32* var_13;
    wp::int32 var_14;
    wp::int32 var_15;
    wp::int32* var_16;
    wp::int32 var_17;
    wp::int32 var_18;
    bool var_19;
    wp::int32* var_20;
    wp::int32 var_21;
    wp::int32 var_22;
    wp::int32* var_23;
    wp::int32 var_24;
    wp::int32 var_25;
    const wp::int32 var_26 = 0;
    bool var_27;
    wp::int32 var_28;
    const wp::int32 var_29 = 0;
    bool var_30;
    wp::int32* var_31;
    const wp::int32 var_32 = 0;
    bool var_33;
    wp::int32 var_34;
    wp::int32* var_35;
    wp::int32 var_36;
    wp::int32 var_37;
    wp::transform_t<wp::float32> var_38;
    const wp::int32 var_39 = 0;
    bool var_40;
    wp::transform_t<wp::float32>* var_41;
    wp::transform_t<wp::float32> var_42;
    wp::transform_t<wp::float32> var_43;
    wp::transform_t<wp::float32> var_44;
    wp::vec_t<3, wp::float32>* var_45;
    wp::vec_t<3, wp::float32>* var_46;
    wp::vec_t<3, wp::float32> var_47;
    wp::vec_t<3, wp::float32> var_48;
    wp::vec_t<3, wp::float32> var_49;
    wp::vec_t<3, wp::float32> var_50;
    wp::vec_t<3, wp::float32> var_51;
    bool var_52;
    const wp::int32 var_53 = 0;
    bool var_54;
    const wp::int32 var_55 = 0;
    bool var_56;
    const wp::int32 var_57 = 0;
    bool var_58;
    wp::int32 var_59;
    wp::vec_t<3, wp::float32>* var_60;
    wp::vec_t<3, wp::float32> var_61;
    wp::vec_t<3, wp::float32> var_62;
    wp::vec_t<3, wp::float32> var_63;
    wp::vec_t<3, wp::float32> var_64;
    wp::quat_t<wp::float32> var_65;
    wp::vec_t<3, wp::float32>* var_66;
    wp::vec_t<3, wp::float32> var_67;
    wp::vec_t<3, wp::float32> var_68;
    wp::vec_t<3, wp::float32> var_69;
    wp::vec_t<3, wp::float32> var_70;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    wp::float32 adj_1 = {};
    wp::float32 adj_2 = {};
    wp::float32 adj_3 = {};
    wp::float32 adj_4 = {};
    wp::float32 adj_5 = {};
    wp::float32 adj_6 = {};
    wp::vec_t<3, wp::float32> adj_7 = {};
    wp::int32 adj_8 = {};
    wp::int32 adj_9 = {};
    wp::int32 adj_10 = {};
    wp::int32 adj_11 = {};
    bool adj_12 = {};
    wp::int32 adj_13 = {};
    wp::int32 adj_14 = {};
    wp::int32 adj_15 = {};
    wp::int32 adj_16 = {};
    wp::int32 adj_17 = {};
    wp::int32 adj_18 = {};
    bool adj_19 = {};
    wp::int32 adj_20 = {};
    wp::int32 adj_21 = {};
    wp::int32 adj_22 = {};
    wp::int32 adj_23 = {};
    wp::int32 adj_24 = {};
    wp::int32 adj_25 = {};
    wp::int32 adj_26 = {};
    bool adj_27 = {};
    wp::int32 adj_28 = {};
    wp::int32 adj_29 = {};
    bool adj_30 = {};
    wp::int32 adj_31 = {};
    wp::int32 adj_32 = {};
    bool adj_33 = {};
    wp::int32 adj_34 = {};
    wp::int32 adj_35 = {};
    wp::int32 adj_36 = {};
    wp::int32 adj_37 = {};
    wp::transform_t<wp::float32> adj_38 = {};
    wp::int32 adj_39 = {};
    bool adj_40 = {};
    wp::transform_t<wp::float32> adj_41 = {};
    wp::transform_t<wp::float32> adj_42 = {};
    wp::transform_t<wp::float32> adj_43 = {};
    wp::transform_t<wp::float32> adj_44 = {};
    wp::vec_t<3, wp::float32> adj_45 = {};
    wp::vec_t<3, wp::float32> adj_46 = {};
    wp::vec_t<3, wp::float32> adj_47 = {};
    wp::vec_t<3, wp::float32> adj_48 = {};
    wp::vec_t<3, wp::float32> adj_49 = {};
    wp::vec_t<3, wp::float32> adj_50 = {};
    wp::vec_t<3, wp::float32> adj_51 = {};
    bool adj_52 = {};
    wp::int32 adj_53 = {};
    bool adj_54 = {};
    wp::int32 adj_55 = {};
    bool adj_56 = {};
    wp::int32 adj_57 = {};
    bool adj_58 = {};
    wp::int32 adj_59 = {};
    wp::vec_t<3, wp::float32> adj_60 = {};
    wp::vec_t<3, wp::float32> adj_61 = {};
    wp::vec_t<3, wp::float32> adj_62 = {};
    wp::vec_t<3, wp::float32> adj_63 = {};
    wp::vec_t<3, wp::float32> adj_64 = {};
    wp::quat_t<wp::float32> adj_65 = {};
    wp::vec_t<3, wp::float32> adj_66 = {};
    wp::vec_t<3, wp::float32> adj_67 = {};
    wp::vec_t<3, wp::float32> adj_68 = {};
    wp::vec_t<3, wp::float32> adj_69 = {};
    wp::vec_t<3, wp::float32> adj_70 = {};
    //---------
    // forward
    // def compute_contact_lines(                                                             <L 256>
    // tid = wp.tid()                                                                         <L 275>
    var_0 = builtin_tid1d();
    // nan_line = wp.vec3(wp.nan, wp.nan, wp.nan)                                             <L 276>
    var_7 = wp::vec_t<3, wp::float32>(var_2, var_4, var_6);
    // count = contact_count[0]                                                               <L 277>
    var_9 = wp::address(var_contact_count, var_8);
    var_11 = wp::load(var_9);
    var_10 = wp::copy(var_11);
    // if tid >= count:                                                                       <L 278>
    var_12 = (var_0 >= var_10);
    if (var_12) {
        // line_start[tid] = nan_line                                                         <L 279>
        // wp::array_store(var_line_start, var_0, var_7);
        // line_end[tid] = nan_line                                                           <L 280>
        // wp::array_store(var_line_end, var_0, var_7);
        // return                                                                             <L 281>
        goto label0;
    }
    // shape_a = contact_shape0[tid]                                                          <L 282>
    var_13 = wp::address(var_contact_shape0, var_0);
    var_15 = wp::load(var_13);
    var_14 = wp::copy(var_15);
    // shape_b = contact_shape1[tid]                                                          <L 283>
    var_16 = wp::address(var_contact_shape1, var_0);
    var_18 = wp::load(var_16);
    var_17 = wp::copy(var_18);
    // if shape_a == shape_b:                                                                 <L 284>
    var_19 = (var_14 == var_17);
    if (var_19) {
        // line_start[tid] = nan_line                                                         <L 285>
        // wp::array_store(var_line_start, var_0, var_7);
        // line_end[tid] = nan_line                                                           <L 286>
        // wp::array_store(var_line_end, var_0, var_7);
        // return                                                                             <L 287>
        goto label1;
    }
    // world_a = shape_world[shape_a]                                                         <L 290>
    var_20 = wp::address(var_shape_world, var_14);
    var_22 = wp::load(var_20);
    var_21 = wp::copy(var_22);
    // world_b = shape_world[shape_b]                                                         <L 291>
    var_23 = wp::address(var_shape_world, var_17);
    var_25 = wp::load(var_23);
    var_24 = wp::copy(var_25);
    // if visible_worlds_mask:                                                                <L 292>
    if (var_visible_worlds_mask) {
        // w = world_a if world_a >= 0 else world_b                                           <L 293>
        var_27 = (var_21 >= var_26);
        if (var_27) {
        }
        if (!var_27) {
        }
        var_28 = wp::where(var_27, var_21, var_24);
        // if w >= 0:                                                                         <L 294>
        var_30 = (var_28 >= var_29);
        if (var_30) {
            // if visible_worlds_mask[w] == 0:                                                <L 295>
            var_31 = wp::address(var_visible_worlds_mask, var_28);
            var_34 = wp::load(var_31);
            var_33 = (var_34 == var_32);
            if (var_33) {
                // line_start[tid] = nan_line                                                 <L 296>
                // wp::array_store(var_line_start, var_0, var_7);
                // line_end[tid] = nan_line                                                   <L 297>
                // wp::array_store(var_line_end, var_0, var_7);
                // return                                                                     <L 298>
                goto label2;
            }
        }
    }
    // body_a = shape_body[shape_a]                                                           <L 301>
    var_35 = wp::address(var_shape_body, var_14);
    var_37 = wp::load(var_35);
    var_36 = wp::copy(var_37);
    // X_wb_a = wp.transform_identity()                                                       <L 302>
    var_38 = wp::transform_identity<wp::float32>();
    // if body_a >= 0:                                                                        <L 303>
    var_40 = (var_36 >= var_39);
    if (var_40) {
        // X_wb_a = body_q[body_a]                                                            <L 304>
        var_41 = wp::address(var_body_q, var_36);
        var_43 = wp::load(var_41);
        var_42 = wp::copy(var_43);
    }
    var_44 = wp::where(var_40, var_42, var_38);
    // world_pos0 = wp.transform_point(X_wb_a, contact_point0[tid] + contact_offset0[tid])       <L 307>
    var_45 = wp::address(var_contact_point0, var_0);
    var_46 = wp::address(var_contact_offset0, var_0);
    var_48 = wp::load(var_45);
    var_49 = wp::load(var_46);
    var_47 = wp::add(var_48, var_49);
    var_50 = wp::transform_point(var_44, var_47);
    // contact_center = world_pos0                                                            <L 309>
    var_51 = wp::copy(var_50);
    // if world_a >= 0 or world_b >= 0:                                                       <L 312>
    var_54 = (var_21 >= var_53);
    var_52 = var_54;
    if (!var_52) {
        var_56 = (var_24 >= var_55);
        var_52 = var_52 || var_56;
    }
    if (var_52) {
        // contact_center += world_offsets[world_a if world_a >= 0 else world_b]              <L 313>
        var_58 = (var_21 >= var_57);
        if (var_58) {
        }
        if (!var_58) {
        }
        var_59 = wp::where(var_58, var_21, var_24);
        var_60 = wp::address(var_world_offsets, var_59);
        var_62 = wp::load(var_60);
        var_61 = wp::add(var_51, var_62);
    }
    var_63 = wp::where(var_52, var_61, var_51);
    // contact_center = wp.transform_point(layer_xform, contact_center)                       <L 316>
    var_64 = wp::transform_point(var_layer_xform, var_63);
    // normal = wp.quat_rotate(wp.transform_get_rotation(layer_xform), contact_normal[tid])       <L 317>
    var_65 = wp::transform_get_rotation(var_layer_xform);
    var_66 = wp::address(var_contact_normal, var_0);
    var_68 = wp::load(var_66);
    var_67 = wp::quat_rotate(var_65, var_68);
    // line_vector = normal * line_scale                                                      <L 321>
    var_69 = wp::mul(var_67, var_line_scale);
    // line_start[tid] = contact_center                                                       <L 323>
    // wp::array_store(var_line_start, var_0, var_64);
    // line_end[tid] = contact_center + line_vector                                           <L 324>
    var_70 = wp::add(var_64, var_69);
    // wp::array_store(var_line_end, var_0, var_70);
    //---------
    // reverse
    wp::adj_array_store(var_line_end, var_0, var_70, adj_line_end, adj_0, adj_70);
    wp::adj_add(var_64, var_69, adj_64, adj_69, adj_70);
    // adj: line_end[tid] = contact_center + line_vector                                      <L 324>
    wp::adj_array_store(var_line_start, var_0, var_64, adj_line_start, adj_0, adj_64);
    // adj: line_start[tid] = contact_center                                                  <L 323>
    wp::adj_mul(var_67, var_line_scale, adj_67, adj_line_scale, adj_69);
    // adj: line_vector = normal * line_scale                                                 <L 321>
    wp::adj_quat_rotate(var_65, var_68, adj_65, adj_66, adj_67);
    wp::adj_address(var_contact_normal, var_0, adj_contact_normal, adj_0, adj_66);
    wp::adj_transform_get_rotation(var_layer_xform, adj_layer_xform, adj_65);
    // adj: normal = wp.quat_rotate(wp.transform_get_rotation(layer_xform), contact_normal[tid])  <L 317>
    wp::adj_transform_point(var_layer_xform, var_63, adj_layer_xform, adj_63, adj_64);
    // adj: contact_center = wp.transform_point(layer_xform, contact_center)                  <L 316>
    wp::adj_where(var_52, var_61, var_51, adj_52, adj_61, adj_51, adj_63);
    if (var_52) {
        wp::adj_add(var_51, var_62, adj_51, adj_60, adj_61);
        wp::adj_address(var_world_offsets, var_59, adj_world_offsets, adj_59, adj_60);
        wp::adj_where(var_58, var_21, var_24, adj_58, adj_21, adj_24, adj_59);
        if (!var_58) {
        }
        if (var_58) {
        }
        // adj: contact_center += world_offsets[world_a if world_a >= 0 else world_b]         <L 313>
    }
    if (!var_52) {
    }
    // adj: if world_a >= 0 or world_b >= 0:                                                  <L 312>
    wp::adj_copy(var_50, adj_50, adj_51);
    // adj: contact_center = world_pos0                                                       <L 309>
    wp::adj_transform_point(var_44, var_47, adj_44, adj_47, adj_50);
    wp::adj_add(var_48, var_49, adj_45, adj_46, adj_47);
    wp::adj_address(var_contact_offset0, var_0, adj_contact_offset0, adj_0, adj_46);
    wp::adj_address(var_contact_point0, var_0, adj_contact_point0, adj_0, adj_45);
    // adj: world_pos0 = wp.transform_point(X_wb_a, contact_point0[tid] + contact_offset0[tid])  <L 307>
    wp::adj_where(var_40, var_42, var_38, adj_40, adj_42, adj_38, adj_44);
    if (var_40) {
        wp::adj_copy(var_43, adj_41, adj_42);
        wp::adj_address(var_body_q, var_36, adj_body_q, adj_36, adj_41);
        // adj: X_wb_a = body_q[body_a]                                                       <L 304>
    }
    // adj: if body_a >= 0:                                                                   <L 303>
    // adj: X_wb_a = wp.transform_identity()                                                  <L 302>
    wp::adj_copy(var_37, adj_35, adj_36);
    wp::adj_address(var_shape_body, var_14, adj_shape_body, adj_14, adj_35);
    // adj: body_a = shape_body[shape_a]                                                      <L 301>
    if (var_visible_worlds_mask) {
        if (var_30) {
            if (var_33) {
                label2:;
                // adj: return                                                                <L 298>
                wp::adj_array_store(var_line_end, var_0, var_7, adj_line_end, adj_0, adj_7);
                // adj: line_end[tid] = nan_line                                              <L 297>
                wp::adj_array_store(var_line_start, var_0, var_7, adj_line_start, adj_0, adj_7);
                // adj: line_start[tid] = nan_line                                            <L 296>
            }
            wp::adj_address(var_visible_worlds_mask, var_28, adj_visible_worlds_mask, adj_28, adj_31);
            // adj: if visible_worlds_mask[w] == 0:                                           <L 295>
        }
        // adj: if w >= 0:                                                                    <L 294>
        wp::adj_where(var_27, var_21, var_24, adj_27, adj_21, adj_24, adj_28);
        if (!var_27) {
        }
        if (var_27) {
        }
        // adj: w = world_a if world_a >= 0 else world_b                                      <L 293>
    }
    // adj: if visible_worlds_mask:                                                           <L 292>
    wp::adj_copy(var_25, adj_23, adj_24);
    wp::adj_address(var_shape_world, var_17, adj_shape_world, adj_17, adj_23);
    // adj: world_b = shape_world[shape_b]                                                    <L 291>
    wp::adj_copy(var_22, adj_20, adj_21);
    wp::adj_address(var_shape_world, var_14, adj_shape_world, adj_14, adj_20);
    // adj: world_a = shape_world[shape_a]                                                    <L 290>
    if (var_19) {
        label1:;
        // adj: return                                                                        <L 287>
        wp::adj_array_store(var_line_end, var_0, var_7, adj_line_end, adj_0, adj_7);
        // adj: line_end[tid] = nan_line                                                      <L 286>
        wp::adj_array_store(var_line_start, var_0, var_7, adj_line_start, adj_0, adj_7);
        // adj: line_start[tid] = nan_line                                                    <L 285>
    }
    // adj: if shape_a == shape_b:                                                            <L 284>
    wp::adj_copy(var_18, adj_16, adj_17);
    wp::adj_address(var_contact_shape1, var_0, adj_contact_shape1, adj_0, adj_16);
    // adj: shape_b = contact_shape1[tid]                                                     <L 283>
    wp::adj_copy(var_15, adj_13, adj_14);
    wp::adj_address(var_contact_shape0, var_0, adj_contact_shape0, adj_0, adj_13);
    // adj: shape_a = contact_shape0[tid]                                                     <L 282>
    if (var_12) {
        label0:;
        // adj: return                                                                        <L 281>
        wp::adj_array_store(var_line_end, var_0, var_7, adj_line_end, adj_0, adj_7);
        // adj: line_end[tid] = nan_line                                                      <L 280>
        wp::adj_array_store(var_line_start, var_0, var_7, adj_line_start, adj_0, adj_7);
        // adj: line_start[tid] = nan_line                                                    <L 279>
    }
    // adj: if tid >= count:                                                                  <L 278>
    wp::adj_copy(var_11, adj_9, adj_10);
    wp::adj_address(var_contact_count, var_8, adj_contact_count, adj_8, adj_9);
    // adj: count = contact_count[0]                                                          <L 277>
    wp::adj_vec_t(var_2, var_4, var_6, adj_2, adj_4, adj_6, adj_7);
    // adj: nan_line = wp.vec3(wp.nan, wp.nan, wp.nan)                                        <L 276>
    // adj: tid = wp.tid()                                                                    <L 275>
    // adj: def compute_contact_lines(                                                        <L 256>
    return;
}



extern "C" {

// Python CPU entry points
WP_API void compute_contact_lines_fa0a8efe_cpu_forward(
    wp::launch_bounds_t<1> *dim,
    wp_args_compute_contact_lines_fa0a8efe *_wp_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        compute_contact_lines_fa0a8efe_cpu_kernel_forward(*dim, task_index, _wp_args);
    }
}

} // extern C



extern "C" {

WP_API void compute_contact_lines_fa0a8efe_cpu_backward(
    wp::launch_bounds_t<1> *dim,
    wp_args_compute_contact_lines_fa0a8efe *_wp_args,
    wp_args_compute_contact_lines_fa0a8efe *_wp_adj_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        compute_contact_lines_fa0a8efe_cpu_kernel_backward(*dim, task_index, _wp_args, _wp_adj_args);
    }
}

} // extern C

struct wp_args_compute_contact_disk_transforms_c8b979e1 {
    wp::array_t<wp::transform_t<wp::float32>> body_q;
    wp::array_t<wp::vec_t<6, wp::float32>> body_qd;
    wp::array_t<wp::vec_t<3, wp::float32>> body_com;
    wp::array_t<wp::int32> shape_body;
    wp::array_t<wp::int32> shape_world;
    wp::array_t<wp::vec_t<3, wp::float32>> world_offsets;
    wp::array_t<wp::int32> visible_worlds_mask;
    wp::array_t<wp::int32> contact_count;
    wp::array_t<wp::int32> contact_shape0;
    wp::array_t<wp::int32> contact_shape1;
    wp::array_t<wp::vec_t<3, wp::float32>> contact_point0;
    wp::array_t<wp::vec_t<3, wp::float32>> contact_point1;
    wp::array_t<wp::vec_t<3, wp::float32>> contact_offset0;
    wp::array_t<wp::vec_t<3, wp::float32>> contact_normal;
    wp::array_t<wp::vec_t<6, wp::float32>> contact_force;
    wp::float32 disk_radius;
    wp::float32 disk_thickness;
    wp::float32 eps_force;
    wp::float32 eps_velocity;
    wp::vec_t<3, wp::float32> color_open;
    wp::vec_t<3, wp::float32> color_stick;
    wp::vec_t<3, wp::float32> color_slip;
    wp::array_t<wp::transform_t<wp::float32>> transforms;
    wp::array_t<wp::vec_t<3, wp::float32>> scales;
    wp::array_t<wp::vec_t<3, wp::float32>> colors;
};


void compute_contact_disk_transforms_c8b979e1_cpu_kernel_forward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_compute_contact_disk_transforms_c8b979e1 *_wp_args)
{
    //---------
    // argument vars
    wp::array_t<wp::transform_t<wp::float32>> var_body_q = _wp_args->body_q;
    wp::array_t<wp::vec_t<6, wp::float32>> var_body_qd = _wp_args->body_qd;
    wp::array_t<wp::vec_t<3, wp::float32>> var_body_com = _wp_args->body_com;
    wp::array_t<wp::int32> var_shape_body = _wp_args->shape_body;
    wp::array_t<wp::int32> var_shape_world = _wp_args->shape_world;
    wp::array_t<wp::vec_t<3, wp::float32>> var_world_offsets = _wp_args->world_offsets;
    wp::array_t<wp::int32> var_visible_worlds_mask = _wp_args->visible_worlds_mask;
    wp::array_t<wp::int32> var_contact_count = _wp_args->contact_count;
    wp::array_t<wp::int32> var_contact_shape0 = _wp_args->contact_shape0;
    wp::array_t<wp::int32> var_contact_shape1 = _wp_args->contact_shape1;
    wp::array_t<wp::vec_t<3, wp::float32>> var_contact_point0 = _wp_args->contact_point0;
    wp::array_t<wp::vec_t<3, wp::float32>> var_contact_point1 = _wp_args->contact_point1;
    wp::array_t<wp::vec_t<3, wp::float32>> var_contact_offset0 = _wp_args->contact_offset0;
    wp::array_t<wp::vec_t<3, wp::float32>> var_contact_normal = _wp_args->contact_normal;
    wp::array_t<wp::vec_t<6, wp::float32>> var_contact_force = _wp_args->contact_force;
    wp::float32 var_disk_radius = _wp_args->disk_radius;
    wp::float32 var_disk_thickness = _wp_args->disk_thickness;
    wp::float32 var_eps_force = _wp_args->eps_force;
    wp::float32 var_eps_velocity = _wp_args->eps_velocity;
    wp::vec_t<3, wp::float32> var_color_open = _wp_args->color_open;
    wp::vec_t<3, wp::float32> var_color_stick = _wp_args->color_stick;
    wp::vec_t<3, wp::float32> var_color_slip = _wp_args->color_slip;
    wp::array_t<wp::transform_t<wp::float32>> var_transforms = _wp_args->transforms;
    wp::array_t<wp::vec_t<3, wp::float32>> var_scales = _wp_args->scales;
    wp::array_t<wp::vec_t<3, wp::float32>> var_colors = _wp_args->colors;
    //---------
    // primal vars
    wp::int32 var_0;
    const wp::float32 var_1 = 0.0;
    const wp::float32 var_2 = 0.0;
    const wp::float32 var_3 = 0.0;
    wp::vec_t<3, wp::float32> var_4;
    wp::quat_t<wp::float32> var_5;
    wp::transform_t<wp::float32> var_6;
    const wp::float32 var_7 = 0.0;
    const wp::float32 var_8 = 0.0;
    const wp::float32 var_9 = 0.0;
    wp::vec_t<3, wp::float32> var_10;
    const wp::int32 var_11 = 0;
    wp::int32* var_12;
    wp::int32 var_13;
    wp::int32 var_14;
    bool var_15;
    wp::int32* var_16;
    wp::int32 var_17;
    wp::int32 var_18;
    wp::int32* var_19;
    wp::int32 var_20;
    wp::int32 var_21;
    bool var_22;
    wp::int32* var_23;
    wp::int32 var_24;
    wp::int32 var_25;
    wp::int32* var_26;
    wp::int32 var_27;
    wp::int32 var_28;
    const wp::int32 var_29 = 0;
    bool var_30;
    wp::int32 var_31;
    const wp::int32 var_32 = 0;
    bool var_33;
    wp::int32* var_34;
    const wp::int32 var_35 = 0;
    bool var_36;
    wp::int32 var_37;
    wp::int32* var_38;
    wp::int32 var_39;
    wp::int32 var_40;
    wp::int32* var_41;
    wp::int32 var_42;
    wp::int32 var_43;
    wp::transform_t<wp::float32> var_44;
    const wp::int32 var_45 = 0;
    bool var_46;
    wp::transform_t<wp::float32>* var_47;
    wp::transform_t<wp::float32> var_48;
    wp::transform_t<wp::float32> var_49;
    wp::transform_t<wp::float32> var_50;
    wp::vec_t<3, wp::float32>* var_51;
    wp::vec_t<3, wp::float32>* var_52;
    wp::vec_t<3, wp::float32> var_53;
    wp::vec_t<3, wp::float32> var_54;
    wp::vec_t<3, wp::float32> var_55;
    wp::vec_t<3, wp::float32> var_56;
    wp::vec_t<3, wp::float32> var_57;
    bool var_58;
    const wp::int32 var_59 = 0;
    bool var_60;
    const wp::int32 var_61 = 0;
    bool var_62;
    const wp::int32 var_63 = 0;
    bool var_64;
    wp::int32 var_65;
    wp::vec_t<3, wp::float32>* var_66;
    wp::vec_t<3, wp::float32> var_67;
    wp::vec_t<3, wp::float32> var_68;
    wp::vec_t<3, wp::float32> var_69;
    wp::vec_t<3, wp::float32>* var_70;
    wp::vec_t<3, wp::float32> var_71;
    wp::vec_t<3, wp::float32> var_72;
    wp::quat_t<wp::float32> var_73;
    wp::vec_t<3, wp::float32> var_74;
    const wp::float32 var_75 = 1.0;
    wp::vec_t<6, wp::float32>* var_76;
    wp::vec_t<3, wp::float32> var_77;
    wp::vec_t<6, wp::float32> var_78;
    wp::float32 var_79;
    bool var_80;
    wp::vec_t<3, wp::float32> var_81;
    const wp::float32 var_82 = 0.0;
    const wp::float32 var_83 = 0.0;
    const wp::float32 var_84 = 0.0;
    wp::vec_t<3, wp::float32> var_85;
    const wp::int32 var_86 = 0;
    bool var_87;
    wp::transform_t<wp::float32>* var_88;
    wp::vec_t<3, wp::float32>* var_89;
    wp::vec_t<3, wp::float32> var_90;
    wp::transform_t<wp::float32> var_91;
    wp::vec_t<3, wp::float32> var_92;
    wp::vec_t<3, wp::float32> var_93;
    wp::vec_t<6, wp::float32>* var_94;
    wp::vec_t<3, wp::float32> var_95;
    wp::vec_t<6, wp::float32> var_96;
    wp::vec_t<3, wp::float32> var_97;
    const wp::float32 var_98 = 0.0;
    const wp::float32 var_99 = 0.0;
    const wp::float32 var_100 = 0.0;
    wp::vec_t<3, wp::float32> var_101;
    const wp::int32 var_102 = 0;
    bool var_103;
    wp::transform_t<wp::float32>* var_104;
    wp::transform_t<wp::float32> var_105;
    wp::transform_t<wp::float32> var_106;
    wp::vec_t<3, wp::float32>* var_107;
    wp::vec_t<3, wp::float32> var_108;
    wp::vec_t<3, wp::float32> var_109;
    wp::vec_t<3, wp::float32>* var_110;
    wp::vec_t<3, wp::float32> var_111;
    wp::vec_t<3, wp::float32> var_112;
    wp::vec_t<3, wp::float32> var_113;
    wp::vec_t<6, wp::float32>* var_114;
    wp::vec_t<3, wp::float32> var_115;
    wp::vec_t<6, wp::float32> var_116;
    wp::vec_t<3, wp::float32> var_117;
    wp::vec_t<3, wp::float32> var_118;
    wp::float32 var_119;
    wp::vec_t<3, wp::float32> var_120;
    wp::vec_t<3, wp::float32> var_121;
    wp::float32 var_122;
    bool var_123;
    wp::vec_t<3, wp::float32> var_124;
    const wp::float32 var_125 = 1.02;
    wp::vec_t<3, wp::float32> var_126;
    const wp::float32 var_127 = 1.01;
    wp::vec_t<3, wp::float32> var_128;
    wp::float32 var_129;
    wp::vec_t<3, wp::float32> var_130;
    wp::float32 var_131;
    wp::vec_t<3, wp::float32> var_132;
    wp::float32 var_133;
    wp::transform_t<wp::float32> var_134;
    wp::float32 var_135;
    wp::vec_t<3, wp::float32> var_136;
    //---------
    // forward
    // def compute_contact_disk_transforms(                                                   <L 341>
    // tid = wp.tid()                                                                         <L 388>
    var_0 = builtin_tid1d();
    // zero_xform = wp.transform(wp.vec3(0.0, 0.0, 0.0), wp.quat_identity())                  <L 390>
    var_4 = wp::vec_t<3, wp::float32>(var_1, var_2, var_3);
    var_5 = wp::quat_identity<wp::float32>();
    var_6 = wp::transform_t<wp::float32>(var_4, var_5);
    // zero_vec = wp.vec3(0.0, 0.0, 0.0)                                                      <L 391>
    var_10 = wp::vec_t<3, wp::float32>(var_7, var_8, var_9);
    // count = contact_count[0]                                                               <L 393>
    var_12 = wp::address(var_contact_count, var_11);
    var_14 = wp::load(var_12);
    var_13 = wp::copy(var_14);
    // if tid >= count:                                                                       <L 394>
    var_15 = (var_0 >= var_13);
    if (var_15) {
        // transforms[tid] = zero_xform                                                       <L 395>
        wp::array_store(var_transforms, var_0, var_6);
        // scales[tid] = zero_vec                                                             <L 396>
        wp::array_store(var_scales, var_0, var_10);
        // colors[tid] = zero_vec                                                             <L 397>
        wp::array_store(var_colors, var_0, var_10);
        // return                                                                             <L 398>
        return;
    }
    // shape_a = contact_shape0[tid]                                                          <L 400>
    var_16 = wp::address(var_contact_shape0, var_0);
    var_18 = wp::load(var_16);
    var_17 = wp::copy(var_18);
    // shape_b = contact_shape1[tid]                                                          <L 401>
    var_19 = wp::address(var_contact_shape1, var_0);
    var_21 = wp::load(var_19);
    var_20 = wp::copy(var_21);
    // if shape_a == shape_b:                                                                 <L 402>
    var_22 = (var_17 == var_20);
    if (var_22) {
        // transforms[tid] = zero_xform                                                       <L 403>
        wp::array_store(var_transforms, var_0, var_6);
        // scales[tid] = zero_vec                                                             <L 404>
        wp::array_store(var_scales, var_0, var_10);
        // colors[tid] = zero_vec                                                             <L 405>
        wp::array_store(var_colors, var_0, var_10);
        // return                                                                             <L 406>
        return;
    }
    // world_a = shape_world[shape_a]                                                         <L 408>
    var_23 = wp::address(var_shape_world, var_17);
    var_25 = wp::load(var_23);
    var_24 = wp::copy(var_25);
    // world_b = shape_world[shape_b]                                                         <L 409>
    var_26 = wp::address(var_shape_world, var_20);
    var_28 = wp::load(var_26);
    var_27 = wp::copy(var_28);
    // if visible_worlds_mask:                                                                <L 410>
    if (var_visible_worlds_mask) {
        // w = world_a if world_a >= 0 else world_b                                           <L 411>
        var_30 = (var_24 >= var_29);
        if (var_30) {
        }
        if (!var_30) {
        }
        var_31 = wp::where(var_30, var_24, var_27);
        // if w >= 0:                                                                         <L 412>
        var_33 = (var_31 >= var_32);
        if (var_33) {
            // if visible_worlds_mask[w] == 0:                                                <L 413>
            var_34 = wp::address(var_visible_worlds_mask, var_31);
            var_37 = wp::load(var_34);
            var_36 = (var_37 == var_35);
            if (var_36) {
                // transforms[tid] = zero_xform                                               <L 414>
                wp::array_store(var_transforms, var_0, var_6);
                // scales[tid] = zero_vec                                                     <L 415>
                wp::array_store(var_scales, var_0, var_10);
                // colors[tid] = zero_vec                                                     <L 416>
                wp::array_store(var_colors, var_0, var_10);
                // return                                                                     <L 417>
                return;
            }
        }
    }
    // body_a = shape_body[shape_a]                                                           <L 419>
    var_38 = wp::address(var_shape_body, var_17);
    var_40 = wp::load(var_38);
    var_39 = wp::copy(var_40);
    // body_b = shape_body[shape_b]                                                           <L 420>
    var_41 = wp::address(var_shape_body, var_20);
    var_43 = wp::load(var_41);
    var_42 = wp::copy(var_43);
    // X_wb_a = wp.transform_identity()                                                       <L 422>
    var_44 = wp::transform_identity<wp::float32>();
    // if body_a >= 0:                                                                        <L 423>
    var_46 = (var_39 >= var_45);
    if (var_46) {
        // X_wb_a = body_q[body_a]                                                            <L 424>
        var_47 = wp::address(var_body_q, var_39);
        var_49 = wp::load(var_47);
        var_48 = wp::copy(var_49);
    }
    var_50 = wp::where(var_46, var_48, var_44);
    // world_pos0 = wp.transform_point(X_wb_a, contact_point0[tid] + contact_offset0[tid])       <L 426>
    var_51 = wp::address(var_contact_point0, var_0);
    var_52 = wp::address(var_contact_offset0, var_0);
    var_54 = wp::load(var_51);
    var_55 = wp::load(var_52);
    var_53 = wp::add(var_54, var_55);
    var_56 = wp::transform_point(var_50, var_53);
    // contact_center = world_pos0                                                            <L 428>
    var_57 = wp::copy(var_56);
    // if world_a >= 0 or world_b >= 0:                                                       <L 429>
    var_60 = (var_24 >= var_59);
    var_58 = var_60;
    if (!var_58) {
        var_62 = (var_27 >= var_61);
        var_58 = var_58 || var_62;
    }
    if (var_58) {
        // contact_center += world_offsets[world_a if world_a >= 0 else world_b]              <L 430>
        var_64 = (var_24 >= var_63);
        if (var_64) {
        }
        if (!var_64) {
        }
        var_65 = wp::where(var_64, var_24, var_27);
        var_66 = wp::address(var_world_offsets, var_65);
        var_68 = wp::load(var_66);
        var_67 = wp::add(var_57, var_68);
    }
    var_69 = wp::where(var_58, var_67, var_57);
    // n = contact_normal[tid]                                                                <L 432>
    var_70 = wp::address(var_contact_normal, var_0);
    var_72 = wp::load(var_70);
    var_71 = wp::copy(var_72);
    // q = _quat_from_normal_z(n)                                                             <L 433>
    var_73 = _quat_from_normal_z_0(var_71);
    // color = color_open                                                                     <L 436>
    var_74 = wp::copy(var_color_open);
    // thickness_scaling = 1.0  # Apply slightly different thickness based on color to avoid visible z-fighting       <L 437>
    // if contact_force:                                                                      <L 438>
    if (var_contact_force) {
        // f_lin = wp.spatial_top(contact_force[tid])                                         <L 439>
        var_76 = wp::address(var_contact_force, var_0);
        var_78 = wp::load(var_76);
        var_77 = wp::spatial_top(var_78);
        // f_mag = wp.length(f_lin)                                                           <L 440>
        var_79 = wp::length(var_77);
        // if f_mag < eps_force:                                                              <L 441>
        var_80 = (var_79 < var_eps_force);
        if (var_80) {
            // color = color_open                                                             <L 442>
            var_81 = wp::copy(var_color_open);
        }
        if (!var_80) {
            // v_a = wp.vec3(0.0, 0.0, 0.0)                                                   <L 445>
            var_85 = wp::vec_t<3, wp::float32>(var_82, var_83, var_84);
            // if body_a >= 0:                                                                <L 446>
            var_87 = (var_39 >= var_86);
            if (var_87) {
                // world_com_a = wp.transform_point(body_q[body_a], body_com[body_a])         <L 447>
                var_88 = wp::address(var_body_q, var_39);
                var_89 = wp::address(var_body_com, var_39);
                var_91 = wp::load(var_88);
                var_92 = wp::load(var_89);
                var_90 = wp::transform_point(var_91, var_92);
                // r_a = world_pos0 - world_com_a                                             <L 448>
                var_93 = wp::sub(var_56, var_90);
                // v_a = velocity_at_point(body_qd[body_a], r_a)                              <L 449>
                var_94 = wp::address(var_body_qd, var_39);
                var_96 = wp::load(var_94);
                var_95 = velocity_at_point_1(var_96, var_93);
            }
            var_97 = wp::where(var_87, var_95, var_85);
            // v_b = wp.vec3(0.0, 0.0, 0.0)                                                   <L 450>
            var_101 = wp::vec_t<3, wp::float32>(var_98, var_99, var_100);
            // if body_b >= 0:                                                                <L 451>
            var_103 = (var_42 >= var_102);
            if (var_103) {
                // X_wb_b = body_q[body_b]                                                    <L 452>
                var_104 = wp::address(var_body_q, var_42);
                var_106 = wp::load(var_104);
                var_105 = wp::copy(var_106);
                // world_pos1 = wp.transform_point(X_wb_b, contact_point1[tid])               <L 453>
                var_107 = wp::address(var_contact_point1, var_0);
                var_109 = wp::load(var_107);
                var_108 = wp::transform_point(var_105, var_109);
                // world_com_b = wp.transform_point(X_wb_b, body_com[body_b])                 <L 454>
                var_110 = wp::address(var_body_com, var_42);
                var_112 = wp::load(var_110);
                var_111 = wp::transform_point(var_105, var_112);
                // r_b = world_pos1 - world_com_b                                             <L 455>
                var_113 = wp::sub(var_108, var_111);
                // v_b = velocity_at_point(body_qd[body_b], r_b)                              <L 456>
                var_114 = wp::address(var_body_qd, var_42);
                var_116 = wp::load(var_114);
                var_115 = velocity_at_point_1(var_116, var_113);
            }
            var_117 = wp::where(var_103, var_115, var_101);
            // v_rel = v_a - v_b                                                              <L 457>
            var_118 = wp::sub(var_97, var_117);
            // v_t = v_rel - wp.dot(v_rel, n) * n                                             <L 458>
            var_119 = wp::dot(var_118, var_71);
            var_120 = wp::mul(var_119, var_71);
            var_121 = wp::sub(var_118, var_120);
            // if wp.length(v_t) < eps_velocity:                                              <L 459>
            var_122 = wp::length(var_121);
            var_123 = (var_122 < var_eps_velocity);
            if (var_123) {
                // color = color_stick                                                        <L 460>
                var_124 = wp::copy(var_color_stick);
                // thickness_scaling = 1.02                                                   <L 461>
            }
            if (!var_123) {
                // color = color_slip                                                         <L 463>
                var_126 = wp::copy(var_color_slip);
                // thickness_scaling = 1.01                                                   <L 464>
            }
            var_128 = wp::where(var_123, var_124, var_126);
            var_129 = wp::where(var_123, var_125, var_127);
        }
        var_130 = wp::where(var_80, var_81, var_128);
        var_131 = wp::where(var_80, var_75, var_129);
    }
    var_132 = wp::where(var_contact_force, var_130, var_74);
    var_133 = wp::where(var_contact_force, var_131, var_75);
    // transforms[tid] = wp.transform(contact_center, q)                                      <L 466>
    var_134 = wp::transform_t<wp::float32>(var_69, var_73);
    wp::array_store(var_transforms, var_0, var_134);
    // scales[tid] = wp.vec3(disk_radius, disk_radius, disk_thickness * thickness_scaling)       <L 467>
    var_135 = wp::mul(var_disk_thickness, var_133);
    var_136 = wp::vec_t<3, wp::float32>(var_disk_radius, var_disk_radius, var_135);
    wp::array_store(var_scales, var_0, var_136);
    // colors[tid] = color                                                                    <L 468>
    wp::array_store(var_colors, var_0, var_132);
}



void compute_contact_disk_transforms_c8b979e1_cpu_kernel_backward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_compute_contact_disk_transforms_c8b979e1 *_wp_args,
    wp_args_compute_contact_disk_transforms_c8b979e1 *_wp_adj_args)
{
    //---------
    // argument vars
    wp::array_t<wp::transform_t<wp::float32>> var_body_q = _wp_args->body_q;
    wp::array_t<wp::vec_t<6, wp::float32>> var_body_qd = _wp_args->body_qd;
    wp::array_t<wp::vec_t<3, wp::float32>> var_body_com = _wp_args->body_com;
    wp::array_t<wp::int32> var_shape_body = _wp_args->shape_body;
    wp::array_t<wp::int32> var_shape_world = _wp_args->shape_world;
    wp::array_t<wp::vec_t<3, wp::float32>> var_world_offsets = _wp_args->world_offsets;
    wp::array_t<wp::int32> var_visible_worlds_mask = _wp_args->visible_worlds_mask;
    wp::array_t<wp::int32> var_contact_count = _wp_args->contact_count;
    wp::array_t<wp::int32> var_contact_shape0 = _wp_args->contact_shape0;
    wp::array_t<wp::int32> var_contact_shape1 = _wp_args->contact_shape1;
    wp::array_t<wp::vec_t<3, wp::float32>> var_contact_point0 = _wp_args->contact_point0;
    wp::array_t<wp::vec_t<3, wp::float32>> var_contact_point1 = _wp_args->contact_point1;
    wp::array_t<wp::vec_t<3, wp::float32>> var_contact_offset0 = _wp_args->contact_offset0;
    wp::array_t<wp::vec_t<3, wp::float32>> var_contact_normal = _wp_args->contact_normal;
    wp::array_t<wp::vec_t<6, wp::float32>> var_contact_force = _wp_args->contact_force;
    wp::float32 var_disk_radius = _wp_args->disk_radius;
    wp::float32 var_disk_thickness = _wp_args->disk_thickness;
    wp::float32 var_eps_force = _wp_args->eps_force;
    wp::float32 var_eps_velocity = _wp_args->eps_velocity;
    wp::vec_t<3, wp::float32> var_color_open = _wp_args->color_open;
    wp::vec_t<3, wp::float32> var_color_stick = _wp_args->color_stick;
    wp::vec_t<3, wp::float32> var_color_slip = _wp_args->color_slip;
    wp::array_t<wp::transform_t<wp::float32>> var_transforms = _wp_args->transforms;
    wp::array_t<wp::vec_t<3, wp::float32>> var_scales = _wp_args->scales;
    wp::array_t<wp::vec_t<3, wp::float32>> var_colors = _wp_args->colors;
    wp::array_t<wp::transform_t<wp::float32>> adj_body_q = _wp_adj_args->body_q;
    wp::array_t<wp::vec_t<6, wp::float32>> adj_body_qd = _wp_adj_args->body_qd;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_body_com = _wp_adj_args->body_com;
    wp::array_t<wp::int32> adj_shape_body = _wp_adj_args->shape_body;
    wp::array_t<wp::int32> adj_shape_world = _wp_adj_args->shape_world;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_world_offsets = _wp_adj_args->world_offsets;
    wp::array_t<wp::int32> adj_visible_worlds_mask = _wp_adj_args->visible_worlds_mask;
    wp::array_t<wp::int32> adj_contact_count = _wp_adj_args->contact_count;
    wp::array_t<wp::int32> adj_contact_shape0 = _wp_adj_args->contact_shape0;
    wp::array_t<wp::int32> adj_contact_shape1 = _wp_adj_args->contact_shape1;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_contact_point0 = _wp_adj_args->contact_point0;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_contact_point1 = _wp_adj_args->contact_point1;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_contact_offset0 = _wp_adj_args->contact_offset0;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_contact_normal = _wp_adj_args->contact_normal;
    wp::array_t<wp::vec_t<6, wp::float32>> adj_contact_force = _wp_adj_args->contact_force;
    wp::float32 adj_disk_radius = _wp_adj_args->disk_radius;
    wp::float32 adj_disk_thickness = _wp_adj_args->disk_thickness;
    wp::float32 adj_eps_force = _wp_adj_args->eps_force;
    wp::float32 adj_eps_velocity = _wp_adj_args->eps_velocity;
    wp::vec_t<3, wp::float32> adj_color_open = _wp_adj_args->color_open;
    wp::vec_t<3, wp::float32> adj_color_stick = _wp_adj_args->color_stick;
    wp::vec_t<3, wp::float32> adj_color_slip = _wp_adj_args->color_slip;
    wp::array_t<wp::transform_t<wp::float32>> adj_transforms = _wp_adj_args->transforms;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_scales = _wp_adj_args->scales;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_colors = _wp_adj_args->colors;
    //---------
    // primal vars
    wp::int32 var_0;
    const wp::float32 var_1 = 0.0;
    const wp::float32 var_2 = 0.0;
    const wp::float32 var_3 = 0.0;
    wp::vec_t<3, wp::float32> var_4;
    wp::quat_t<wp::float32> var_5;
    wp::transform_t<wp::float32> var_6;
    const wp::float32 var_7 = 0.0;
    const wp::float32 var_8 = 0.0;
    const wp::float32 var_9 = 0.0;
    wp::vec_t<3, wp::float32> var_10;
    const wp::int32 var_11 = 0;
    wp::int32* var_12;
    wp::int32 var_13;
    wp::int32 var_14;
    bool var_15;
    wp::int32* var_16;
    wp::int32 var_17;
    wp::int32 var_18;
    wp::int32* var_19;
    wp::int32 var_20;
    wp::int32 var_21;
    bool var_22;
    wp::int32* var_23;
    wp::int32 var_24;
    wp::int32 var_25;
    wp::int32* var_26;
    wp::int32 var_27;
    wp::int32 var_28;
    const wp::int32 var_29 = 0;
    bool var_30;
    wp::int32 var_31;
    const wp::int32 var_32 = 0;
    bool var_33;
    wp::int32* var_34;
    const wp::int32 var_35 = 0;
    bool var_36;
    wp::int32 var_37;
    wp::int32* var_38;
    wp::int32 var_39;
    wp::int32 var_40;
    wp::int32* var_41;
    wp::int32 var_42;
    wp::int32 var_43;
    wp::transform_t<wp::float32> var_44;
    const wp::int32 var_45 = 0;
    bool var_46;
    wp::transform_t<wp::float32>* var_47;
    wp::transform_t<wp::float32> var_48;
    wp::transform_t<wp::float32> var_49;
    wp::transform_t<wp::float32> var_50;
    wp::vec_t<3, wp::float32>* var_51;
    wp::vec_t<3, wp::float32>* var_52;
    wp::vec_t<3, wp::float32> var_53;
    wp::vec_t<3, wp::float32> var_54;
    wp::vec_t<3, wp::float32> var_55;
    wp::vec_t<3, wp::float32> var_56;
    wp::vec_t<3, wp::float32> var_57;
    bool var_58;
    const wp::int32 var_59 = 0;
    bool var_60;
    const wp::int32 var_61 = 0;
    bool var_62;
    const wp::int32 var_63 = 0;
    bool var_64;
    wp::int32 var_65;
    wp::vec_t<3, wp::float32>* var_66;
    wp::vec_t<3, wp::float32> var_67;
    wp::vec_t<3, wp::float32> var_68;
    wp::vec_t<3, wp::float32> var_69;
    wp::vec_t<3, wp::float32>* var_70;
    wp::vec_t<3, wp::float32> var_71;
    wp::vec_t<3, wp::float32> var_72;
    wp::quat_t<wp::float32> var_73;
    wp::vec_t<3, wp::float32> var_74;
    const wp::float32 var_75 = 1.0;
    wp::vec_t<6, wp::float32>* var_76;
    wp::vec_t<3, wp::float32> var_77;
    wp::vec_t<6, wp::float32> var_78;
    wp::float32 var_79;
    bool var_80;
    wp::vec_t<3, wp::float32> var_81;
    const wp::float32 var_82 = 0.0;
    const wp::float32 var_83 = 0.0;
    const wp::float32 var_84 = 0.0;
    wp::vec_t<3, wp::float32> var_85;
    const wp::int32 var_86 = 0;
    bool var_87;
    wp::transform_t<wp::float32>* var_88;
    wp::vec_t<3, wp::float32>* var_89;
    wp::vec_t<3, wp::float32> var_90;
    wp::transform_t<wp::float32> var_91;
    wp::vec_t<3, wp::float32> var_92;
    wp::vec_t<3, wp::float32> var_93;
    wp::vec_t<6, wp::float32>* var_94;
    wp::vec_t<3, wp::float32> var_95;
    wp::vec_t<6, wp::float32> var_96;
    wp::vec_t<3, wp::float32> var_97;
    const wp::float32 var_98 = 0.0;
    const wp::float32 var_99 = 0.0;
    const wp::float32 var_100 = 0.0;
    wp::vec_t<3, wp::float32> var_101;
    const wp::int32 var_102 = 0;
    bool var_103;
    wp::transform_t<wp::float32>* var_104;
    wp::transform_t<wp::float32> var_105;
    wp::transform_t<wp::float32> var_106;
    wp::vec_t<3, wp::float32>* var_107;
    wp::vec_t<3, wp::float32> var_108;
    wp::vec_t<3, wp::float32> var_109;
    wp::vec_t<3, wp::float32>* var_110;
    wp::vec_t<3, wp::float32> var_111;
    wp::vec_t<3, wp::float32> var_112;
    wp::vec_t<3, wp::float32> var_113;
    wp::vec_t<6, wp::float32>* var_114;
    wp::vec_t<3, wp::float32> var_115;
    wp::vec_t<6, wp::float32> var_116;
    wp::vec_t<3, wp::float32> var_117;
    wp::vec_t<3, wp::float32> var_118;
    wp::float32 var_119;
    wp::vec_t<3, wp::float32> var_120;
    wp::vec_t<3, wp::float32> var_121;
    wp::float32 var_122;
    bool var_123;
    wp::vec_t<3, wp::float32> var_124;
    const wp::float32 var_125 = 1.02;
    wp::vec_t<3, wp::float32> var_126;
    const wp::float32 var_127 = 1.01;
    wp::vec_t<3, wp::float32> var_128;
    wp::float32 var_129;
    wp::vec_t<3, wp::float32> var_130;
    wp::float32 var_131;
    wp::vec_t<3, wp::float32> var_132;
    wp::float32 var_133;
    wp::transform_t<wp::float32> var_134;
    wp::float32 var_135;
    wp::vec_t<3, wp::float32> var_136;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    wp::float32 adj_1 = {};
    wp::float32 adj_2 = {};
    wp::float32 adj_3 = {};
    wp::vec_t<3, wp::float32> adj_4 = {};
    wp::quat_t<wp::float32> adj_5 = {};
    wp::transform_t<wp::float32> adj_6 = {};
    wp::float32 adj_7 = {};
    wp::float32 adj_8 = {};
    wp::float32 adj_9 = {};
    wp::vec_t<3, wp::float32> adj_10 = {};
    wp::int32 adj_11 = {};
    wp::int32 adj_12 = {};
    wp::int32 adj_13 = {};
    wp::int32 adj_14 = {};
    bool adj_15 = {};
    wp::int32 adj_16 = {};
    wp::int32 adj_17 = {};
    wp::int32 adj_18 = {};
    wp::int32 adj_19 = {};
    wp::int32 adj_20 = {};
    wp::int32 adj_21 = {};
    bool adj_22 = {};
    wp::int32 adj_23 = {};
    wp::int32 adj_24 = {};
    wp::int32 adj_25 = {};
    wp::int32 adj_26 = {};
    wp::int32 adj_27 = {};
    wp::int32 adj_28 = {};
    wp::int32 adj_29 = {};
    bool adj_30 = {};
    wp::int32 adj_31 = {};
    wp::int32 adj_32 = {};
    bool adj_33 = {};
    wp::int32 adj_34 = {};
    wp::int32 adj_35 = {};
    bool adj_36 = {};
    wp::int32 adj_37 = {};
    wp::int32 adj_38 = {};
    wp::int32 adj_39 = {};
    wp::int32 adj_40 = {};
    wp::int32 adj_41 = {};
    wp::int32 adj_42 = {};
    wp::int32 adj_43 = {};
    wp::transform_t<wp::float32> adj_44 = {};
    wp::int32 adj_45 = {};
    bool adj_46 = {};
    wp::transform_t<wp::float32> adj_47 = {};
    wp::transform_t<wp::float32> adj_48 = {};
    wp::transform_t<wp::float32> adj_49 = {};
    wp::transform_t<wp::float32> adj_50 = {};
    wp::vec_t<3, wp::float32> adj_51 = {};
    wp::vec_t<3, wp::float32> adj_52 = {};
    wp::vec_t<3, wp::float32> adj_53 = {};
    wp::vec_t<3, wp::float32> adj_54 = {};
    wp::vec_t<3, wp::float32> adj_55 = {};
    wp::vec_t<3, wp::float32> adj_56 = {};
    wp::vec_t<3, wp::float32> adj_57 = {};
    bool adj_58 = {};
    wp::int32 adj_59 = {};
    bool adj_60 = {};
    wp::int32 adj_61 = {};
    bool adj_62 = {};
    wp::int32 adj_63 = {};
    bool adj_64 = {};
    wp::int32 adj_65 = {};
    wp::vec_t<3, wp::float32> adj_66 = {};
    wp::vec_t<3, wp::float32> adj_67 = {};
    wp::vec_t<3, wp::float32> adj_68 = {};
    wp::vec_t<3, wp::float32> adj_69 = {};
    wp::vec_t<3, wp::float32> adj_70 = {};
    wp::vec_t<3, wp::float32> adj_71 = {};
    wp::vec_t<3, wp::float32> adj_72 = {};
    wp::quat_t<wp::float32> adj_73 = {};
    wp::vec_t<3, wp::float32> adj_74 = {};
    wp::float32 adj_75 = {};
    wp::vec_t<6, wp::float32> adj_76 = {};
    wp::vec_t<3, wp::float32> adj_77 = {};
    wp::vec_t<6, wp::float32> adj_78 = {};
    wp::float32 adj_79 = {};
    bool adj_80 = {};
    wp::vec_t<3, wp::float32> adj_81 = {};
    wp::float32 adj_82 = {};
    wp::float32 adj_83 = {};
    wp::float32 adj_84 = {};
    wp::vec_t<3, wp::float32> adj_85 = {};
    wp::int32 adj_86 = {};
    bool adj_87 = {};
    wp::transform_t<wp::float32> adj_88 = {};
    wp::vec_t<3, wp::float32> adj_89 = {};
    wp::vec_t<3, wp::float32> adj_90 = {};
    wp::transform_t<wp::float32> adj_91 = {};
    wp::vec_t<3, wp::float32> adj_92 = {};
    wp::vec_t<3, wp::float32> adj_93 = {};
    wp::vec_t<6, wp::float32> adj_94 = {};
    wp::vec_t<3, wp::float32> adj_95 = {};
    wp::vec_t<6, wp::float32> adj_96 = {};
    wp::vec_t<3, wp::float32> adj_97 = {};
    wp::float32 adj_98 = {};
    wp::float32 adj_99 = {};
    wp::float32 adj_100 = {};
    wp::vec_t<3, wp::float32> adj_101 = {};
    wp::int32 adj_102 = {};
    bool adj_103 = {};
    wp::transform_t<wp::float32> adj_104 = {};
    wp::transform_t<wp::float32> adj_105 = {};
    wp::transform_t<wp::float32> adj_106 = {};
    wp::vec_t<3, wp::float32> adj_107 = {};
    wp::vec_t<3, wp::float32> adj_108 = {};
    wp::vec_t<3, wp::float32> adj_109 = {};
    wp::vec_t<3, wp::float32> adj_110 = {};
    wp::vec_t<3, wp::float32> adj_111 = {};
    wp::vec_t<3, wp::float32> adj_112 = {};
    wp::vec_t<3, wp::float32> adj_113 = {};
    wp::vec_t<6, wp::float32> adj_114 = {};
    wp::vec_t<3, wp::float32> adj_115 = {};
    wp::vec_t<6, wp::float32> adj_116 = {};
    wp::vec_t<3, wp::float32> adj_117 = {};
    wp::vec_t<3, wp::float32> adj_118 = {};
    wp::float32 adj_119 = {};
    wp::vec_t<3, wp::float32> adj_120 = {};
    wp::vec_t<3, wp::float32> adj_121 = {};
    wp::float32 adj_122 = {};
    bool adj_123 = {};
    wp::vec_t<3, wp::float32> adj_124 = {};
    wp::float32 adj_125 = {};
    wp::vec_t<3, wp::float32> adj_126 = {};
    wp::float32 adj_127 = {};
    wp::vec_t<3, wp::float32> adj_128 = {};
    wp::float32 adj_129 = {};
    wp::vec_t<3, wp::float32> adj_130 = {};
    wp::float32 adj_131 = {};
    wp::vec_t<3, wp::float32> adj_132 = {};
    wp::float32 adj_133 = {};
    wp::transform_t<wp::float32> adj_134 = {};
    wp::float32 adj_135 = {};
    wp::vec_t<3, wp::float32> adj_136 = {};
    //---------
    // forward
    // def compute_contact_disk_transforms(                                                   <L 341>
    // tid = wp.tid()                                                                         <L 388>
    var_0 = builtin_tid1d();
    // zero_xform = wp.transform(wp.vec3(0.0, 0.0, 0.0), wp.quat_identity())                  <L 390>
    var_4 = wp::vec_t<3, wp::float32>(var_1, var_2, var_3);
    var_5 = wp::quat_identity<wp::float32>();
    var_6 = wp::transform_t<wp::float32>(var_4, var_5);
    // zero_vec = wp.vec3(0.0, 0.0, 0.0)                                                      <L 391>
    var_10 = wp::vec_t<3, wp::float32>(var_7, var_8, var_9);
    // count = contact_count[0]                                                               <L 393>
    var_12 = wp::address(var_contact_count, var_11);
    var_14 = wp::load(var_12);
    var_13 = wp::copy(var_14);
    // if tid >= count:                                                                       <L 394>
    var_15 = (var_0 >= var_13);
    if (var_15) {
        // transforms[tid] = zero_xform                                                       <L 395>
        // wp::array_store(var_transforms, var_0, var_6);
        // scales[tid] = zero_vec                                                             <L 396>
        // wp::array_store(var_scales, var_0, var_10);
        // colors[tid] = zero_vec                                                             <L 397>
        // wp::array_store(var_colors, var_0, var_10);
        // return                                                                             <L 398>
        goto label0;
    }
    // shape_a = contact_shape0[tid]                                                          <L 400>
    var_16 = wp::address(var_contact_shape0, var_0);
    var_18 = wp::load(var_16);
    var_17 = wp::copy(var_18);
    // shape_b = contact_shape1[tid]                                                          <L 401>
    var_19 = wp::address(var_contact_shape1, var_0);
    var_21 = wp::load(var_19);
    var_20 = wp::copy(var_21);
    // if shape_a == shape_b:                                                                 <L 402>
    var_22 = (var_17 == var_20);
    if (var_22) {
        // transforms[tid] = zero_xform                                                       <L 403>
        // wp::array_store(var_transforms, var_0, var_6);
        // scales[tid] = zero_vec                                                             <L 404>
        // wp::array_store(var_scales, var_0, var_10);
        // colors[tid] = zero_vec                                                             <L 405>
        // wp::array_store(var_colors, var_0, var_10);
        // return                                                                             <L 406>
        goto label1;
    }
    // world_a = shape_world[shape_a]                                                         <L 408>
    var_23 = wp::address(var_shape_world, var_17);
    var_25 = wp::load(var_23);
    var_24 = wp::copy(var_25);
    // world_b = shape_world[shape_b]                                                         <L 409>
    var_26 = wp::address(var_shape_world, var_20);
    var_28 = wp::load(var_26);
    var_27 = wp::copy(var_28);
    // if visible_worlds_mask:                                                                <L 410>
    if (var_visible_worlds_mask) {
        // w = world_a if world_a >= 0 else world_b                                           <L 411>
        var_30 = (var_24 >= var_29);
        if (var_30) {
        }
        if (!var_30) {
        }
        var_31 = wp::where(var_30, var_24, var_27);
        // if w >= 0:                                                                         <L 412>
        var_33 = (var_31 >= var_32);
        if (var_33) {
            // if visible_worlds_mask[w] == 0:                                                <L 413>
            var_34 = wp::address(var_visible_worlds_mask, var_31);
            var_37 = wp::load(var_34);
            var_36 = (var_37 == var_35);
            if (var_36) {
                // transforms[tid] = zero_xform                                               <L 414>
                // wp::array_store(var_transforms, var_0, var_6);
                // scales[tid] = zero_vec                                                     <L 415>
                // wp::array_store(var_scales, var_0, var_10);
                // colors[tid] = zero_vec                                                     <L 416>
                // wp::array_store(var_colors, var_0, var_10);
                // return                                                                     <L 417>
                goto label2;
            }
        }
    }
    // body_a = shape_body[shape_a]                                                           <L 419>
    var_38 = wp::address(var_shape_body, var_17);
    var_40 = wp::load(var_38);
    var_39 = wp::copy(var_40);
    // body_b = shape_body[shape_b]                                                           <L 420>
    var_41 = wp::address(var_shape_body, var_20);
    var_43 = wp::load(var_41);
    var_42 = wp::copy(var_43);
    // X_wb_a = wp.transform_identity()                                                       <L 422>
    var_44 = wp::transform_identity<wp::float32>();
    // if body_a >= 0:                                                                        <L 423>
    var_46 = (var_39 >= var_45);
    if (var_46) {
        // X_wb_a = body_q[body_a]                                                            <L 424>
        var_47 = wp::address(var_body_q, var_39);
        var_49 = wp::load(var_47);
        var_48 = wp::copy(var_49);
    }
    var_50 = wp::where(var_46, var_48, var_44);
    // world_pos0 = wp.transform_point(X_wb_a, contact_point0[tid] + contact_offset0[tid])       <L 426>
    var_51 = wp::address(var_contact_point0, var_0);
    var_52 = wp::address(var_contact_offset0, var_0);
    var_54 = wp::load(var_51);
    var_55 = wp::load(var_52);
    var_53 = wp::add(var_54, var_55);
    var_56 = wp::transform_point(var_50, var_53);
    // contact_center = world_pos0                                                            <L 428>
    var_57 = wp::copy(var_56);
    // if world_a >= 0 or world_b >= 0:                                                       <L 429>
    var_60 = (var_24 >= var_59);
    var_58 = var_60;
    if (!var_58) {
        var_62 = (var_27 >= var_61);
        var_58 = var_58 || var_62;
    }
    if (var_58) {
        // contact_center += world_offsets[world_a if world_a >= 0 else world_b]              <L 430>
        var_64 = (var_24 >= var_63);
        if (var_64) {
        }
        if (!var_64) {
        }
        var_65 = wp::where(var_64, var_24, var_27);
        var_66 = wp::address(var_world_offsets, var_65);
        var_68 = wp::load(var_66);
        var_67 = wp::add(var_57, var_68);
    }
    var_69 = wp::where(var_58, var_67, var_57);
    // n = contact_normal[tid]                                                                <L 432>
    var_70 = wp::address(var_contact_normal, var_0);
    var_72 = wp::load(var_70);
    var_71 = wp::copy(var_72);
    // q = _quat_from_normal_z(n)                                                             <L 433>
    var_73 = _quat_from_normal_z_0(var_71);
    // color = color_open                                                                     <L 436>
    var_74 = wp::copy(var_color_open);
    // thickness_scaling = 1.0  # Apply slightly different thickness based on color to avoid visible z-fighting       <L 437>
    // if contact_force:                                                                      <L 438>
    if (var_contact_force) {
        // f_lin = wp.spatial_top(contact_force[tid])                                         <L 439>
        var_76 = wp::address(var_contact_force, var_0);
        var_78 = wp::load(var_76);
        var_77 = wp::spatial_top(var_78);
        // f_mag = wp.length(f_lin)                                                           <L 440>
        var_79 = wp::length(var_77);
        // if f_mag < eps_force:                                                              <L 441>
        var_80 = (var_79 < var_eps_force);
        if (var_80) {
            // color = color_open                                                             <L 442>
            var_81 = wp::copy(var_color_open);
        }
        if (!var_80) {
            // v_a = wp.vec3(0.0, 0.0, 0.0)                                                   <L 445>
            var_85 = wp::vec_t<3, wp::float32>(var_82, var_83, var_84);
            // if body_a >= 0:                                                                <L 446>
            var_87 = (var_39 >= var_86);
            if (var_87) {
                // world_com_a = wp.transform_point(body_q[body_a], body_com[body_a])         <L 447>
                var_88 = wp::address(var_body_q, var_39);
                var_89 = wp::address(var_body_com, var_39);
                var_91 = wp::load(var_88);
                var_92 = wp::load(var_89);
                var_90 = wp::transform_point(var_91, var_92);
                // r_a = world_pos0 - world_com_a                                             <L 448>
                var_93 = wp::sub(var_56, var_90);
                // v_a = velocity_at_point(body_qd[body_a], r_a)                              <L 449>
                var_94 = wp::address(var_body_qd, var_39);
                var_96 = wp::load(var_94);
                var_95 = velocity_at_point_1(var_96, var_93);
            }
            var_97 = wp::where(var_87, var_95, var_85);
            // v_b = wp.vec3(0.0, 0.0, 0.0)                                                   <L 450>
            var_101 = wp::vec_t<3, wp::float32>(var_98, var_99, var_100);
            // if body_b >= 0:                                                                <L 451>
            var_103 = (var_42 >= var_102);
            if (var_103) {
                // X_wb_b = body_q[body_b]                                                    <L 452>
                var_104 = wp::address(var_body_q, var_42);
                var_106 = wp::load(var_104);
                var_105 = wp::copy(var_106);
                // world_pos1 = wp.transform_point(X_wb_b, contact_point1[tid])               <L 453>
                var_107 = wp::address(var_contact_point1, var_0);
                var_109 = wp::load(var_107);
                var_108 = wp::transform_point(var_105, var_109);
                // world_com_b = wp.transform_point(X_wb_b, body_com[body_b])                 <L 454>
                var_110 = wp::address(var_body_com, var_42);
                var_112 = wp::load(var_110);
                var_111 = wp::transform_point(var_105, var_112);
                // r_b = world_pos1 - world_com_b                                             <L 455>
                var_113 = wp::sub(var_108, var_111);
                // v_b = velocity_at_point(body_qd[body_b], r_b)                              <L 456>
                var_114 = wp::address(var_body_qd, var_42);
                var_116 = wp::load(var_114);
                var_115 = velocity_at_point_1(var_116, var_113);
            }
            var_117 = wp::where(var_103, var_115, var_101);
            // v_rel = v_a - v_b                                                              <L 457>
            var_118 = wp::sub(var_97, var_117);
            // v_t = v_rel - wp.dot(v_rel, n) * n                                             <L 458>
            var_119 = wp::dot(var_118, var_71);
            var_120 = wp::mul(var_119, var_71);
            var_121 = wp::sub(var_118, var_120);
            // if wp.length(v_t) < eps_velocity:                                              <L 459>
            var_122 = wp::length(var_121);
            var_123 = (var_122 < var_eps_velocity);
            if (var_123) {
                // color = color_stick                                                        <L 460>
                var_124 = wp::copy(var_color_stick);
                // thickness_scaling = 1.02                                                   <L 461>
            }
            if (!var_123) {
                // color = color_slip                                                         <L 463>
                var_126 = wp::copy(var_color_slip);
                // thickness_scaling = 1.01                                                   <L 464>
            }
            var_128 = wp::where(var_123, var_124, var_126);
            var_129 = wp::where(var_123, var_125, var_127);
        }
        var_130 = wp::where(var_80, var_81, var_128);
        var_131 = wp::where(var_80, var_75, var_129);
    }
    var_132 = wp::where(var_contact_force, var_130, var_74);
    var_133 = wp::where(var_contact_force, var_131, var_75);
    // transforms[tid] = wp.transform(contact_center, q)                                      <L 466>
    var_134 = wp::transform_t<wp::float32>(var_69, var_73);
    // wp::array_store(var_transforms, var_0, var_134);
    // scales[tid] = wp.vec3(disk_radius, disk_radius, disk_thickness * thickness_scaling)       <L 467>
    var_135 = wp::mul(var_disk_thickness, var_133);
    var_136 = wp::vec_t<3, wp::float32>(var_disk_radius, var_disk_radius, var_135);
    // wp::array_store(var_scales, var_0, var_136);
    // colors[tid] = color                                                                    <L 468>
    // wp::array_store(var_colors, var_0, var_132);
    //---------
    // reverse
    wp::adj_array_store(var_colors, var_0, var_132, adj_colors, adj_0, adj_132);
    // adj: colors[tid] = color                                                               <L 468>
    wp::adj_array_store(var_scales, var_0, var_136, adj_scales, adj_0, adj_136);
    wp::adj_vec_t(var_disk_radius, var_disk_radius, var_135, adj_disk_radius, adj_disk_radius, adj_135, adj_136);
    wp::adj_mul(var_disk_thickness, var_133, adj_disk_thickness, adj_133, adj_135);
    // adj: scales[tid] = wp.vec3(disk_radius, disk_radius, disk_thickness * thickness_scaling)  <L 467>
    wp::adj_array_store(var_transforms, var_0, var_134, adj_transforms, adj_0, adj_134);
    wp::adj_transform_t(var_69, var_73, adj_69, adj_73, adj_134);
    // adj: transforms[tid] = wp.transform(contact_center, q)                                 <L 466>
    wp::adj_where(var_contact_force, var_131, var_75, adj_contact_force, adj_131, adj_75, adj_133);
    wp::adj_where(var_contact_force, var_130, var_74, adj_contact_force, adj_130, adj_74, adj_132);
    if (var_contact_force) {
        wp::adj_where(var_80, var_75, var_129, adj_80, adj_75, adj_129, adj_131);
        wp::adj_where(var_80, var_81, var_128, adj_80, adj_81, adj_128, adj_130);
        if (!var_80) {
            wp::adj_where(var_123, var_125, var_127, adj_123, adj_125, adj_127, adj_129);
            wp::adj_where(var_123, var_124, var_126, adj_123, adj_124, adj_126, adj_128);
            if (!var_123) {
                // adj: thickness_scaling = 1.01                                              <L 464>
                wp::adj_copy(var_color_slip, adj_color_slip, adj_126);
                // adj: color = color_slip                                                    <L 463>
            }
            if (var_123) {
                // adj: thickness_scaling = 1.02                                              <L 461>
                wp::adj_copy(var_color_stick, adj_color_stick, adj_124);
                // adj: color = color_stick                                                   <L 460>
            }
            wp::adj_length(var_121, var_122, adj_121, adj_122);
            // adj: if wp.length(v_t) < eps_velocity:                                         <L 459>
            wp::adj_sub(var_118, var_120, adj_118, adj_120, adj_121);
            wp::adj_mul(var_119, var_71, adj_119, adj_71, adj_120);
            wp::adj_dot(var_118, var_71, adj_118, adj_71, adj_119);
            // adj: v_t = v_rel - wp.dot(v_rel, n) * n                                        <L 458>
            wp::adj_sub(var_97, var_117, adj_97, adj_117, adj_118);
            // adj: v_rel = v_a - v_b                                                         <L 457>
            wp::adj_where(var_103, var_115, var_101, adj_103, adj_115, adj_101, adj_117);
            if (var_103) {
                adj_velocity_at_point_1(var_116, var_113, adj_114, adj_113, adj_115);
                wp::adj_address(var_body_qd, var_42, adj_body_qd, adj_42, adj_114);
                // adj: v_b = velocity_at_point(body_qd[body_b], r_b)                         <L 456>
                wp::adj_sub(var_108, var_111, adj_108, adj_111, adj_113);
                // adj: r_b = world_pos1 - world_com_b                                        <L 455>
                wp::adj_transform_point(var_105, var_112, adj_105, adj_110, adj_111);
                wp::adj_address(var_body_com, var_42, adj_body_com, adj_42, adj_110);
                // adj: world_com_b = wp.transform_point(X_wb_b, body_com[body_b])            <L 454>
                wp::adj_transform_point(var_105, var_109, adj_105, adj_107, adj_108);
                wp::adj_address(var_contact_point1, var_0, adj_contact_point1, adj_0, adj_107);
                // adj: world_pos1 = wp.transform_point(X_wb_b, contact_point1[tid])          <L 453>
                wp::adj_copy(var_106, adj_104, adj_105);
                wp::adj_address(var_body_q, var_42, adj_body_q, adj_42, adj_104);
                // adj: X_wb_b = body_q[body_b]                                               <L 452>
            }
            // adj: if body_b >= 0:                                                           <L 451>
            wp::adj_vec_t(var_98, var_99, var_100, adj_98, adj_99, adj_100, adj_101);
            // adj: v_b = wp.vec3(0.0, 0.0, 0.0)                                              <L 450>
            wp::adj_where(var_87, var_95, var_85, adj_87, adj_95, adj_85, adj_97);
            if (var_87) {
                adj_velocity_at_point_1(var_96, var_93, adj_94, adj_93, adj_95);
                wp::adj_address(var_body_qd, var_39, adj_body_qd, adj_39, adj_94);
                // adj: v_a = velocity_at_point(body_qd[body_a], r_a)                         <L 449>
                wp::adj_sub(var_56, var_90, adj_56, adj_90, adj_93);
                // adj: r_a = world_pos0 - world_com_a                                        <L 448>
                wp::adj_transform_point(var_91, var_92, adj_88, adj_89, adj_90);
                wp::adj_address(var_body_com, var_39, adj_body_com, adj_39, adj_89);
                wp::adj_address(var_body_q, var_39, adj_body_q, adj_39, adj_88);
                // adj: world_com_a = wp.transform_point(body_q[body_a], body_com[body_a])    <L 447>
            }
            // adj: if body_a >= 0:                                                           <L 446>
            wp::adj_vec_t(var_82, var_83, var_84, adj_82, adj_83, adj_84, adj_85);
            // adj: v_a = wp.vec3(0.0, 0.0, 0.0)                                              <L 445>
        }
        if (var_80) {
            wp::adj_copy(var_color_open, adj_color_open, adj_81);
            // adj: color = color_open                                                        <L 442>
        }
        // adj: if f_mag < eps_force:                                                         <L 441>
        wp::adj_length(var_77, var_79, adj_77, adj_79);
        // adj: f_mag = wp.length(f_lin)                                                      <L 440>
        wp::adj_spatial_top(var_78, adj_76, adj_77);
        wp::adj_address(var_contact_force, var_0, adj_contact_force, adj_0, adj_76);
        // adj: f_lin = wp.spatial_top(contact_force[tid])                                    <L 439>
    }
    // adj: if contact_force:                                                                 <L 438>
    // adj: thickness_scaling = 1.0  # Apply slightly different thickness based on color to avoid visible z-fighting  <L 437>
    wp::adj_copy(var_color_open, adj_color_open, adj_74);
    // adj: color = color_open                                                                <L 436>
    adj__quat_from_normal_z_0(var_71, adj_71, adj_73);
    // adj: q = _quat_from_normal_z(n)                                                        <L 433>
    wp::adj_copy(var_72, adj_70, adj_71);
    wp::adj_address(var_contact_normal, var_0, adj_contact_normal, adj_0, adj_70);
    // adj: n = contact_normal[tid]                                                           <L 432>
    wp::adj_where(var_58, var_67, var_57, adj_58, adj_67, adj_57, adj_69);
    if (var_58) {
        wp::adj_add(var_57, var_68, adj_57, adj_66, adj_67);
        wp::adj_address(var_world_offsets, var_65, adj_world_offsets, adj_65, adj_66);
        wp::adj_where(var_64, var_24, var_27, adj_64, adj_24, adj_27, adj_65);
        if (!var_64) {
        }
        if (var_64) {
        }
        // adj: contact_center += world_offsets[world_a if world_a >= 0 else world_b]         <L 430>
    }
    if (!var_58) {
    }
    // adj: if world_a >= 0 or world_b >= 0:                                                  <L 429>
    wp::adj_copy(var_56, adj_56, adj_57);
    // adj: contact_center = world_pos0                                                       <L 428>
    wp::adj_transform_point(var_50, var_53, adj_50, adj_53, adj_56);
    wp::adj_add(var_54, var_55, adj_51, adj_52, adj_53);
    wp::adj_address(var_contact_offset0, var_0, adj_contact_offset0, adj_0, adj_52);
    wp::adj_address(var_contact_point0, var_0, adj_contact_point0, adj_0, adj_51);
    // adj: world_pos0 = wp.transform_point(X_wb_a, contact_point0[tid] + contact_offset0[tid])  <L 426>
    wp::adj_where(var_46, var_48, var_44, adj_46, adj_48, adj_44, adj_50);
    if (var_46) {
        wp::adj_copy(var_49, adj_47, adj_48);
        wp::adj_address(var_body_q, var_39, adj_body_q, adj_39, adj_47);
        // adj: X_wb_a = body_q[body_a]                                                       <L 424>
    }
    // adj: if body_a >= 0:                                                                   <L 423>
    // adj: X_wb_a = wp.transform_identity()                                                  <L 422>
    wp::adj_copy(var_43, adj_41, adj_42);
    wp::adj_address(var_shape_body, var_20, adj_shape_body, adj_20, adj_41);
    // adj: body_b = shape_body[shape_b]                                                      <L 420>
    wp::adj_copy(var_40, adj_38, adj_39);
    wp::adj_address(var_shape_body, var_17, adj_shape_body, adj_17, adj_38);
    // adj: body_a = shape_body[shape_a]                                                      <L 419>
    if (var_visible_worlds_mask) {
        if (var_33) {
            if (var_36) {
                label2:;
                // adj: return                                                                <L 417>
                wp::adj_array_store(var_colors, var_0, var_10, adj_colors, adj_0, adj_10);
                // adj: colors[tid] = zero_vec                                                <L 416>
                wp::adj_array_store(var_scales, var_0, var_10, adj_scales, adj_0, adj_10);
                // adj: scales[tid] = zero_vec                                                <L 415>
                wp::adj_array_store(var_transforms, var_0, var_6, adj_transforms, adj_0, adj_6);
                // adj: transforms[tid] = zero_xform                                          <L 414>
            }
            wp::adj_address(var_visible_worlds_mask, var_31, adj_visible_worlds_mask, adj_31, adj_34);
            // adj: if visible_worlds_mask[w] == 0:                                           <L 413>
        }
        // adj: if w >= 0:                                                                    <L 412>
        wp::adj_where(var_30, var_24, var_27, adj_30, adj_24, adj_27, adj_31);
        if (!var_30) {
        }
        if (var_30) {
        }
        // adj: w = world_a if world_a >= 0 else world_b                                      <L 411>
    }
    // adj: if visible_worlds_mask:                                                           <L 410>
    wp::adj_copy(var_28, adj_26, adj_27);
    wp::adj_address(var_shape_world, var_20, adj_shape_world, adj_20, adj_26);
    // adj: world_b = shape_world[shape_b]                                                    <L 409>
    wp::adj_copy(var_25, adj_23, adj_24);
    wp::adj_address(var_shape_world, var_17, adj_shape_world, adj_17, adj_23);
    // adj: world_a = shape_world[shape_a]                                                    <L 408>
    if (var_22) {
        label1:;
        // adj: return                                                                        <L 406>
        wp::adj_array_store(var_colors, var_0, var_10, adj_colors, adj_0, adj_10);
        // adj: colors[tid] = zero_vec                                                        <L 405>
        wp::adj_array_store(var_scales, var_0, var_10, adj_scales, adj_0, adj_10);
        // adj: scales[tid] = zero_vec                                                        <L 404>
        wp::adj_array_store(var_transforms, var_0, var_6, adj_transforms, adj_0, adj_6);
        // adj: transforms[tid] = zero_xform                                                  <L 403>
    }
    // adj: if shape_a == shape_b:                                                            <L 402>
    wp::adj_copy(var_21, adj_19, adj_20);
    wp::adj_address(var_contact_shape1, var_0, adj_contact_shape1, adj_0, adj_19);
    // adj: shape_b = contact_shape1[tid]                                                     <L 401>
    wp::adj_copy(var_18, adj_16, adj_17);
    wp::adj_address(var_contact_shape0, var_0, adj_contact_shape0, adj_0, adj_16);
    // adj: shape_a = contact_shape0[tid]                                                     <L 400>
    if (var_15) {
        label0:;
        // adj: return                                                                        <L 398>
        wp::adj_array_store(var_colors, var_0, var_10, adj_colors, adj_0, adj_10);
        // adj: colors[tid] = zero_vec                                                        <L 397>
        wp::adj_array_store(var_scales, var_0, var_10, adj_scales, adj_0, adj_10);
        // adj: scales[tid] = zero_vec                                                        <L 396>
        wp::adj_array_store(var_transforms, var_0, var_6, adj_transforms, adj_0, adj_6);
        // adj: transforms[tid] = zero_xform                                                  <L 395>
    }
    // adj: if tid >= count:                                                                  <L 394>
    wp::adj_copy(var_14, adj_12, adj_13);
    wp::adj_address(var_contact_count, var_11, adj_contact_count, adj_11, adj_12);
    // adj: count = contact_count[0]                                                          <L 393>
    wp::adj_vec_t(var_7, var_8, var_9, adj_7, adj_8, adj_9, adj_10);
    // adj: zero_vec = wp.vec3(0.0, 0.0, 0.0)                                                 <L 391>
    wp::adj_transform_t(var_4, var_5, adj_4, adj_5, adj_6);
    wp::adj_vec_t(var_1, var_2, var_3, adj_1, adj_2, adj_3, adj_4);
    // adj: zero_xform = wp.transform(wp.vec3(0.0, 0.0, 0.0), wp.quat_identity())             <L 390>
    // adj: tid = wp.tid()                                                                    <L 388>
    // adj: def compute_contact_disk_transforms(                                              <L 341>
    return;
}



extern "C" {

// Python CPU entry points
WP_API void compute_contact_disk_transforms_c8b979e1_cpu_forward(
    wp::launch_bounds_t<1> *dim,
    wp_args_compute_contact_disk_transforms_c8b979e1 *_wp_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        compute_contact_disk_transforms_c8b979e1_cpu_kernel_forward(*dim, task_index, _wp_args);
    }
}

} // extern C



extern "C" {

WP_API void compute_contact_disk_transforms_c8b979e1_cpu_backward(
    wp::launch_bounds_t<1> *dim,
    wp_args_compute_contact_disk_transforms_c8b979e1 *_wp_args,
    wp_args_compute_contact_disk_transforms_c8b979e1 *_wp_adj_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        compute_contact_disk_transforms_c8b979e1_cpu_kernel_backward(*dim, task_index, _wp_args, _wp_adj_args);
    }
}

} // extern C

struct wp_args_compute_contact_force_arrows_d24d1bba {
    wp::array_t<wp::transform_t<wp::float32>> body_q;
    wp::array_t<wp::int32> shape_body;
    wp::array_t<wp::int32> shape_world;
    wp::array_t<wp::vec_t<3, wp::float32>> world_offsets;
    wp::array_t<wp::int32> visible_worlds_mask;
    wp::array_t<wp::int32> contact_count;
    wp::array_t<wp::int32> contact_shape0;
    wp::array_t<wp::int32> contact_shape1;
    wp::array_t<wp::vec_t<3, wp::float32>> contact_point0;
    wp::array_t<wp::vec_t<3, wp::float32>> contact_offset0;
    wp::array_t<wp::vec_t<6, wp::float32>> contact_force;
    wp::float32 force_scale;
    wp::array_t<wp::vec_t<3, wp::float32>> line_start;
    wp::array_t<wp::vec_t<3, wp::float32>> line_end;
};


void compute_contact_force_arrows_d24d1bba_cpu_kernel_forward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_compute_contact_force_arrows_d24d1bba *_wp_args)
{
    //---------
    // argument vars
    wp::array_t<wp::transform_t<wp::float32>> var_body_q = _wp_args->body_q;
    wp::array_t<wp::int32> var_shape_body = _wp_args->shape_body;
    wp::array_t<wp::int32> var_shape_world = _wp_args->shape_world;
    wp::array_t<wp::vec_t<3, wp::float32>> var_world_offsets = _wp_args->world_offsets;
    wp::array_t<wp::int32> var_visible_worlds_mask = _wp_args->visible_worlds_mask;
    wp::array_t<wp::int32> var_contact_count = _wp_args->contact_count;
    wp::array_t<wp::int32> var_contact_shape0 = _wp_args->contact_shape0;
    wp::array_t<wp::int32> var_contact_shape1 = _wp_args->contact_shape1;
    wp::array_t<wp::vec_t<3, wp::float32>> var_contact_point0 = _wp_args->contact_point0;
    wp::array_t<wp::vec_t<3, wp::float32>> var_contact_offset0 = _wp_args->contact_offset0;
    wp::array_t<wp::vec_t<6, wp::float32>> var_contact_force = _wp_args->contact_force;
    wp::float32 var_force_scale = _wp_args->force_scale;
    wp::array_t<wp::vec_t<3, wp::float32>> var_line_start = _wp_args->line_start;
    wp::array_t<wp::vec_t<3, wp::float32>> var_line_end = _wp_args->line_end;
    //---------
    // primal vars
    wp::int32 var_0;
    const wp::float32 var_1 = NAN;
    const wp::float32 var_2 = NAN;
    const wp::float32 var_3 = NAN;
    const wp::float32 var_4 = NAN;
    const wp::float32 var_5 = NAN;
    const wp::float32 var_6 = NAN;
    wp::vec_t<3, wp::float32> var_7;
    const wp::int32 var_8 = 0;
    wp::int32* var_9;
    wp::int32 var_10;
    wp::int32 var_11;
    bool var_12;
    wp::int32* var_13;
    wp::int32 var_14;
    wp::int32 var_15;
    wp::int32* var_16;
    wp::int32 var_17;
    wp::int32 var_18;
    bool var_19;
    wp::int32* var_20;
    wp::int32 var_21;
    wp::int32 var_22;
    wp::int32* var_23;
    wp::int32 var_24;
    wp::int32 var_25;
    const wp::int32 var_26 = 0;
    bool var_27;
    wp::int32 var_28;
    const wp::int32 var_29 = 0;
    bool var_30;
    wp::int32* var_31;
    const wp::int32 var_32 = 0;
    bool var_33;
    wp::int32 var_34;
    wp::int32* var_35;
    wp::int32 var_36;
    wp::int32 var_37;
    wp::transform_t<wp::float32> var_38;
    const wp::int32 var_39 = 0;
    bool var_40;
    wp::transform_t<wp::float32>* var_41;
    wp::transform_t<wp::float32> var_42;
    wp::transform_t<wp::float32> var_43;
    wp::transform_t<wp::float32> var_44;
    wp::vec_t<3, wp::float32>* var_45;
    wp::vec_t<3, wp::float32>* var_46;
    wp::vec_t<3, wp::float32> var_47;
    wp::vec_t<3, wp::float32> var_48;
    wp::vec_t<3, wp::float32> var_49;
    wp::vec_t<3, wp::float32> var_50;
    wp::vec_t<3, wp::float32> var_51;
    bool var_52;
    const wp::int32 var_53 = 0;
    bool var_54;
    const wp::int32 var_55 = 0;
    bool var_56;
    const wp::int32 var_57 = 0;
    bool var_58;
    wp::int32 var_59;
    wp::vec_t<3, wp::float32>* var_60;
    wp::vec_t<3, wp::float32> var_61;
    wp::vec_t<3, wp::float32> var_62;
    wp::vec_t<3, wp::float32> var_63;
    wp::vec_t<6, wp::float32>* var_64;
    wp::vec_t<3, wp::float32> var_65;
    wp::vec_t<6, wp::float32> var_66;
    wp::vec_t<3, wp::float32> var_67;
    wp::vec_t<3, wp::float32> var_68;
    wp::vec_t<3, wp::float32> var_69;
    //---------
    // forward
    // def compute_contact_force_arrows(                                                      <L 472>
    // tid = wp.tid()                                                                         <L 496>
    var_0 = builtin_tid1d();
    // nan_line = wp.vec3(wp.nan, wp.nan, wp.nan)                                             <L 497>
    var_7 = wp::vec_t<3, wp::float32>(var_2, var_4, var_6);
    // count = contact_count[0]                                                               <L 499>
    var_9 = wp::address(var_contact_count, var_8);
    var_11 = wp::load(var_9);
    var_10 = wp::copy(var_11);
    // if tid >= count:                                                                       <L 500>
    var_12 = (var_0 >= var_10);
    if (var_12) {
        // line_start[tid] = nan_line                                                         <L 501>
        wp::array_store(var_line_start, var_0, var_7);
        // line_end[tid] = nan_line                                                           <L 502>
        wp::array_store(var_line_end, var_0, var_7);
        // return                                                                             <L 503>
        return;
    }
    // shape_a = contact_shape0[tid]                                                          <L 505>
    var_13 = wp::address(var_contact_shape0, var_0);
    var_15 = wp::load(var_13);
    var_14 = wp::copy(var_15);
    // shape_b = contact_shape1[tid]                                                          <L 506>
    var_16 = wp::address(var_contact_shape1, var_0);
    var_18 = wp::load(var_16);
    var_17 = wp::copy(var_18);
    // if shape_a == shape_b:                                                                 <L 507>
    var_19 = (var_14 == var_17);
    if (var_19) {
        // line_start[tid] = nan_line                                                         <L 508>
        wp::array_store(var_line_start, var_0, var_7);
        // line_end[tid] = nan_line                                                           <L 509>
        wp::array_store(var_line_end, var_0, var_7);
        // return                                                                             <L 510>
        return;
    }
    // world_a = shape_world[shape_a]                                                         <L 512>
    var_20 = wp::address(var_shape_world, var_14);
    var_22 = wp::load(var_20);
    var_21 = wp::copy(var_22);
    // world_b = shape_world[shape_b]                                                         <L 513>
    var_23 = wp::address(var_shape_world, var_17);
    var_25 = wp::load(var_23);
    var_24 = wp::copy(var_25);
    // if visible_worlds_mask:                                                                <L 514>
    if (var_visible_worlds_mask) {
        // w = world_a if world_a >= 0 else world_b                                           <L 515>
        var_27 = (var_21 >= var_26);
        if (var_27) {
        }
        if (!var_27) {
        }
        var_28 = wp::where(var_27, var_21, var_24);
        // if w >= 0:                                                                         <L 516>
        var_30 = (var_28 >= var_29);
        if (var_30) {
            // if visible_worlds_mask[w] == 0:                                                <L 517>
            var_31 = wp::address(var_visible_worlds_mask, var_28);
            var_34 = wp::load(var_31);
            var_33 = (var_34 == var_32);
            if (var_33) {
                // line_start[tid] = nan_line                                                 <L 518>
                wp::array_store(var_line_start, var_0, var_7);
                // line_end[tid] = nan_line                                                   <L 519>
                wp::array_store(var_line_end, var_0, var_7);
                // return                                                                     <L 520>
                return;
            }
        }
    }
    // body_a = shape_body[shape_a]                                                           <L 522>
    var_35 = wp::address(var_shape_body, var_14);
    var_37 = wp::load(var_35);
    var_36 = wp::copy(var_37);
    // X_wb_a = wp.transform_identity()                                                       <L 523>
    var_38 = wp::transform_identity<wp::float32>();
    // if body_a >= 0:                                                                        <L 524>
    var_40 = (var_36 >= var_39);
    if (var_40) {
        // X_wb_a = body_q[body_a]                                                            <L 525>
        var_41 = wp::address(var_body_q, var_36);
        var_43 = wp::load(var_41);
        var_42 = wp::copy(var_43);
    }
    var_44 = wp::where(var_40, var_42, var_38);
    // world_pos0 = wp.transform_point(X_wb_a, contact_point0[tid] + contact_offset0[tid])       <L 527>
    var_45 = wp::address(var_contact_point0, var_0);
    var_46 = wp::address(var_contact_offset0, var_0);
    var_48 = wp::load(var_45);
    var_49 = wp::load(var_46);
    var_47 = wp::add(var_48, var_49);
    var_50 = wp::transform_point(var_44, var_47);
    // contact_center = world_pos0                                                            <L 528>
    var_51 = wp::copy(var_50);
    // if world_a >= 0 or world_b >= 0:                                                       <L 529>
    var_54 = (var_21 >= var_53);
    var_52 = var_54;
    if (!var_52) {
        var_56 = (var_24 >= var_55);
        var_52 = var_52 || var_56;
    }
    if (var_52) {
        // contact_center += world_offsets[world_a if world_a >= 0 else world_b]              <L 530>
        var_58 = (var_21 >= var_57);
        if (var_58) {
        }
        if (!var_58) {
        }
        var_59 = wp::where(var_58, var_21, var_24);
        var_60 = wp::address(var_world_offsets, var_59);
        var_62 = wp::load(var_60);
        var_61 = wp::add(var_51, var_62);
    }
    var_63 = wp::where(var_52, var_61, var_51);
    // f_lin = -wp.spatial_top(contact_force[tid])  # Flip sign so positive force is along normal       <L 532>
    var_64 = wp::address(var_contact_force, var_0);
    var_66 = wp::load(var_64);
    var_65 = wp::spatial_top(var_66);
    var_67 = wp::neg(var_65);
    // line_start[tid] = contact_center                                                       <L 533>
    wp::array_store(var_line_start, var_0, var_63);
    // line_end[tid] = contact_center + force_scale * f_lin                                   <L 534>
    var_68 = wp::mul(var_force_scale, var_67);
    var_69 = wp::add(var_63, var_68);
    wp::array_store(var_line_end, var_0, var_69);
}



void compute_contact_force_arrows_d24d1bba_cpu_kernel_backward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_compute_contact_force_arrows_d24d1bba *_wp_args,
    wp_args_compute_contact_force_arrows_d24d1bba *_wp_adj_args)
{
    //---------
    // argument vars
    wp::array_t<wp::transform_t<wp::float32>> var_body_q = _wp_args->body_q;
    wp::array_t<wp::int32> var_shape_body = _wp_args->shape_body;
    wp::array_t<wp::int32> var_shape_world = _wp_args->shape_world;
    wp::array_t<wp::vec_t<3, wp::float32>> var_world_offsets = _wp_args->world_offsets;
    wp::array_t<wp::int32> var_visible_worlds_mask = _wp_args->visible_worlds_mask;
    wp::array_t<wp::int32> var_contact_count = _wp_args->contact_count;
    wp::array_t<wp::int32> var_contact_shape0 = _wp_args->contact_shape0;
    wp::array_t<wp::int32> var_contact_shape1 = _wp_args->contact_shape1;
    wp::array_t<wp::vec_t<3, wp::float32>> var_contact_point0 = _wp_args->contact_point0;
    wp::array_t<wp::vec_t<3, wp::float32>> var_contact_offset0 = _wp_args->contact_offset0;
    wp::array_t<wp::vec_t<6, wp::float32>> var_contact_force = _wp_args->contact_force;
    wp::float32 var_force_scale = _wp_args->force_scale;
    wp::array_t<wp::vec_t<3, wp::float32>> var_line_start = _wp_args->line_start;
    wp::array_t<wp::vec_t<3, wp::float32>> var_line_end = _wp_args->line_end;
    wp::array_t<wp::transform_t<wp::float32>> adj_body_q = _wp_adj_args->body_q;
    wp::array_t<wp::int32> adj_shape_body = _wp_adj_args->shape_body;
    wp::array_t<wp::int32> adj_shape_world = _wp_adj_args->shape_world;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_world_offsets = _wp_adj_args->world_offsets;
    wp::array_t<wp::int32> adj_visible_worlds_mask = _wp_adj_args->visible_worlds_mask;
    wp::array_t<wp::int32> adj_contact_count = _wp_adj_args->contact_count;
    wp::array_t<wp::int32> adj_contact_shape0 = _wp_adj_args->contact_shape0;
    wp::array_t<wp::int32> adj_contact_shape1 = _wp_adj_args->contact_shape1;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_contact_point0 = _wp_adj_args->contact_point0;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_contact_offset0 = _wp_adj_args->contact_offset0;
    wp::array_t<wp::vec_t<6, wp::float32>> adj_contact_force = _wp_adj_args->contact_force;
    wp::float32 adj_force_scale = _wp_adj_args->force_scale;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_line_start = _wp_adj_args->line_start;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_line_end = _wp_adj_args->line_end;
    //---------
    // primal vars
    wp::int32 var_0;
    const wp::float32 var_1 = NAN;
    const wp::float32 var_2 = NAN;
    const wp::float32 var_3 = NAN;
    const wp::float32 var_4 = NAN;
    const wp::float32 var_5 = NAN;
    const wp::float32 var_6 = NAN;
    wp::vec_t<3, wp::float32> var_7;
    const wp::int32 var_8 = 0;
    wp::int32* var_9;
    wp::int32 var_10;
    wp::int32 var_11;
    bool var_12;
    wp::int32* var_13;
    wp::int32 var_14;
    wp::int32 var_15;
    wp::int32* var_16;
    wp::int32 var_17;
    wp::int32 var_18;
    bool var_19;
    wp::int32* var_20;
    wp::int32 var_21;
    wp::int32 var_22;
    wp::int32* var_23;
    wp::int32 var_24;
    wp::int32 var_25;
    const wp::int32 var_26 = 0;
    bool var_27;
    wp::int32 var_28;
    const wp::int32 var_29 = 0;
    bool var_30;
    wp::int32* var_31;
    const wp::int32 var_32 = 0;
    bool var_33;
    wp::int32 var_34;
    wp::int32* var_35;
    wp::int32 var_36;
    wp::int32 var_37;
    wp::transform_t<wp::float32> var_38;
    const wp::int32 var_39 = 0;
    bool var_40;
    wp::transform_t<wp::float32>* var_41;
    wp::transform_t<wp::float32> var_42;
    wp::transform_t<wp::float32> var_43;
    wp::transform_t<wp::float32> var_44;
    wp::vec_t<3, wp::float32>* var_45;
    wp::vec_t<3, wp::float32>* var_46;
    wp::vec_t<3, wp::float32> var_47;
    wp::vec_t<3, wp::float32> var_48;
    wp::vec_t<3, wp::float32> var_49;
    wp::vec_t<3, wp::float32> var_50;
    wp::vec_t<3, wp::float32> var_51;
    bool var_52;
    const wp::int32 var_53 = 0;
    bool var_54;
    const wp::int32 var_55 = 0;
    bool var_56;
    const wp::int32 var_57 = 0;
    bool var_58;
    wp::int32 var_59;
    wp::vec_t<3, wp::float32>* var_60;
    wp::vec_t<3, wp::float32> var_61;
    wp::vec_t<3, wp::float32> var_62;
    wp::vec_t<3, wp::float32> var_63;
    wp::vec_t<6, wp::float32>* var_64;
    wp::vec_t<3, wp::float32> var_65;
    wp::vec_t<6, wp::float32> var_66;
    wp::vec_t<3, wp::float32> var_67;
    wp::vec_t<3, wp::float32> var_68;
    wp::vec_t<3, wp::float32> var_69;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    wp::float32 adj_1 = {};
    wp::float32 adj_2 = {};
    wp::float32 adj_3 = {};
    wp::float32 adj_4 = {};
    wp::float32 adj_5 = {};
    wp::float32 adj_6 = {};
    wp::vec_t<3, wp::float32> adj_7 = {};
    wp::int32 adj_8 = {};
    wp::int32 adj_9 = {};
    wp::int32 adj_10 = {};
    wp::int32 adj_11 = {};
    bool adj_12 = {};
    wp::int32 adj_13 = {};
    wp::int32 adj_14 = {};
    wp::int32 adj_15 = {};
    wp::int32 adj_16 = {};
    wp::int32 adj_17 = {};
    wp::int32 adj_18 = {};
    bool adj_19 = {};
    wp::int32 adj_20 = {};
    wp::int32 adj_21 = {};
    wp::int32 adj_22 = {};
    wp::int32 adj_23 = {};
    wp::int32 adj_24 = {};
    wp::int32 adj_25 = {};
    wp::int32 adj_26 = {};
    bool adj_27 = {};
    wp::int32 adj_28 = {};
    wp::int32 adj_29 = {};
    bool adj_30 = {};
    wp::int32 adj_31 = {};
    wp::int32 adj_32 = {};
    bool adj_33 = {};
    wp::int32 adj_34 = {};
    wp::int32 adj_35 = {};
    wp::int32 adj_36 = {};
    wp::int32 adj_37 = {};
    wp::transform_t<wp::float32> adj_38 = {};
    wp::int32 adj_39 = {};
    bool adj_40 = {};
    wp::transform_t<wp::float32> adj_41 = {};
    wp::transform_t<wp::float32> adj_42 = {};
    wp::transform_t<wp::float32> adj_43 = {};
    wp::transform_t<wp::float32> adj_44 = {};
    wp::vec_t<3, wp::float32> adj_45 = {};
    wp::vec_t<3, wp::float32> adj_46 = {};
    wp::vec_t<3, wp::float32> adj_47 = {};
    wp::vec_t<3, wp::float32> adj_48 = {};
    wp::vec_t<3, wp::float32> adj_49 = {};
    wp::vec_t<3, wp::float32> adj_50 = {};
    wp::vec_t<3, wp::float32> adj_51 = {};
    bool adj_52 = {};
    wp::int32 adj_53 = {};
    bool adj_54 = {};
    wp::int32 adj_55 = {};
    bool adj_56 = {};
    wp::int32 adj_57 = {};
    bool adj_58 = {};
    wp::int32 adj_59 = {};
    wp::vec_t<3, wp::float32> adj_60 = {};
    wp::vec_t<3, wp::float32> adj_61 = {};
    wp::vec_t<3, wp::float32> adj_62 = {};
    wp::vec_t<3, wp::float32> adj_63 = {};
    wp::vec_t<6, wp::float32> adj_64 = {};
    wp::vec_t<3, wp::float32> adj_65 = {};
    wp::vec_t<6, wp::float32> adj_66 = {};
    wp::vec_t<3, wp::float32> adj_67 = {};
    wp::vec_t<3, wp::float32> adj_68 = {};
    wp::vec_t<3, wp::float32> adj_69 = {};
    //---------
    // forward
    // def compute_contact_force_arrows(                                                      <L 472>
    // tid = wp.tid()                                                                         <L 496>
    var_0 = builtin_tid1d();
    // nan_line = wp.vec3(wp.nan, wp.nan, wp.nan)                                             <L 497>
    var_7 = wp::vec_t<3, wp::float32>(var_2, var_4, var_6);
    // count = contact_count[0]                                                               <L 499>
    var_9 = wp::address(var_contact_count, var_8);
    var_11 = wp::load(var_9);
    var_10 = wp::copy(var_11);
    // if tid >= count:                                                                       <L 500>
    var_12 = (var_0 >= var_10);
    if (var_12) {
        // line_start[tid] = nan_line                                                         <L 501>
        // wp::array_store(var_line_start, var_0, var_7);
        // line_end[tid] = nan_line                                                           <L 502>
        // wp::array_store(var_line_end, var_0, var_7);
        // return                                                                             <L 503>
        goto label0;
    }
    // shape_a = contact_shape0[tid]                                                          <L 505>
    var_13 = wp::address(var_contact_shape0, var_0);
    var_15 = wp::load(var_13);
    var_14 = wp::copy(var_15);
    // shape_b = contact_shape1[tid]                                                          <L 506>
    var_16 = wp::address(var_contact_shape1, var_0);
    var_18 = wp::load(var_16);
    var_17 = wp::copy(var_18);
    // if shape_a == shape_b:                                                                 <L 507>
    var_19 = (var_14 == var_17);
    if (var_19) {
        // line_start[tid] = nan_line                                                         <L 508>
        // wp::array_store(var_line_start, var_0, var_7);
        // line_end[tid] = nan_line                                                           <L 509>
        // wp::array_store(var_line_end, var_0, var_7);
        // return                                                                             <L 510>
        goto label1;
    }
    // world_a = shape_world[shape_a]                                                         <L 512>
    var_20 = wp::address(var_shape_world, var_14);
    var_22 = wp::load(var_20);
    var_21 = wp::copy(var_22);
    // world_b = shape_world[shape_b]                                                         <L 513>
    var_23 = wp::address(var_shape_world, var_17);
    var_25 = wp::load(var_23);
    var_24 = wp::copy(var_25);
    // if visible_worlds_mask:                                                                <L 514>
    if (var_visible_worlds_mask) {
        // w = world_a if world_a >= 0 else world_b                                           <L 515>
        var_27 = (var_21 >= var_26);
        if (var_27) {
        }
        if (!var_27) {
        }
        var_28 = wp::where(var_27, var_21, var_24);
        // if w >= 0:                                                                         <L 516>
        var_30 = (var_28 >= var_29);
        if (var_30) {
            // if visible_worlds_mask[w] == 0:                                                <L 517>
            var_31 = wp::address(var_visible_worlds_mask, var_28);
            var_34 = wp::load(var_31);
            var_33 = (var_34 == var_32);
            if (var_33) {
                // line_start[tid] = nan_line                                                 <L 518>
                // wp::array_store(var_line_start, var_0, var_7);
                // line_end[tid] = nan_line                                                   <L 519>
                // wp::array_store(var_line_end, var_0, var_7);
                // return                                                                     <L 520>
                goto label2;
            }
        }
    }
    // body_a = shape_body[shape_a]                                                           <L 522>
    var_35 = wp::address(var_shape_body, var_14);
    var_37 = wp::load(var_35);
    var_36 = wp::copy(var_37);
    // X_wb_a = wp.transform_identity()                                                       <L 523>
    var_38 = wp::transform_identity<wp::float32>();
    // if body_a >= 0:                                                                        <L 524>
    var_40 = (var_36 >= var_39);
    if (var_40) {
        // X_wb_a = body_q[body_a]                                                            <L 525>
        var_41 = wp::address(var_body_q, var_36);
        var_43 = wp::load(var_41);
        var_42 = wp::copy(var_43);
    }
    var_44 = wp::where(var_40, var_42, var_38);
    // world_pos0 = wp.transform_point(X_wb_a, contact_point0[tid] + contact_offset0[tid])       <L 527>
    var_45 = wp::address(var_contact_point0, var_0);
    var_46 = wp::address(var_contact_offset0, var_0);
    var_48 = wp::load(var_45);
    var_49 = wp::load(var_46);
    var_47 = wp::add(var_48, var_49);
    var_50 = wp::transform_point(var_44, var_47);
    // contact_center = world_pos0                                                            <L 528>
    var_51 = wp::copy(var_50);
    // if world_a >= 0 or world_b >= 0:                                                       <L 529>
    var_54 = (var_21 >= var_53);
    var_52 = var_54;
    if (!var_52) {
        var_56 = (var_24 >= var_55);
        var_52 = var_52 || var_56;
    }
    if (var_52) {
        // contact_center += world_offsets[world_a if world_a >= 0 else world_b]              <L 530>
        var_58 = (var_21 >= var_57);
        if (var_58) {
        }
        if (!var_58) {
        }
        var_59 = wp::where(var_58, var_21, var_24);
        var_60 = wp::address(var_world_offsets, var_59);
        var_62 = wp::load(var_60);
        var_61 = wp::add(var_51, var_62);
    }
    var_63 = wp::where(var_52, var_61, var_51);
    // f_lin = -wp.spatial_top(contact_force[tid])  # Flip sign so positive force is along normal       <L 532>
    var_64 = wp::address(var_contact_force, var_0);
    var_66 = wp::load(var_64);
    var_65 = wp::spatial_top(var_66);
    var_67 = wp::neg(var_65);
    // line_start[tid] = contact_center                                                       <L 533>
    // wp::array_store(var_line_start, var_0, var_63);
    // line_end[tid] = contact_center + force_scale * f_lin                                   <L 534>
    var_68 = wp::mul(var_force_scale, var_67);
    var_69 = wp::add(var_63, var_68);
    // wp::array_store(var_line_end, var_0, var_69);
    //---------
    // reverse
    wp::adj_array_store(var_line_end, var_0, var_69, adj_line_end, adj_0, adj_69);
    wp::adj_add(var_63, var_68, adj_63, adj_68, adj_69);
    wp::adj_mul(var_force_scale, var_67, adj_force_scale, adj_67, adj_68);
    // adj: line_end[tid] = contact_center + force_scale * f_lin                              <L 534>
    wp::adj_array_store(var_line_start, var_0, var_63, adj_line_start, adj_0, adj_63);
    // adj: line_start[tid] = contact_center                                                  <L 533>
    wp::adj_neg(var_65, adj_65, adj_67);
    wp::adj_spatial_top(var_66, adj_64, adj_65);
    wp::adj_address(var_contact_force, var_0, adj_contact_force, adj_0, adj_64);
    // adj: f_lin = -wp.spatial_top(contact_force[tid])  # Flip sign so positive force is along normal  <L 532>
    wp::adj_where(var_52, var_61, var_51, adj_52, adj_61, adj_51, adj_63);
    if (var_52) {
        wp::adj_add(var_51, var_62, adj_51, adj_60, adj_61);
        wp::adj_address(var_world_offsets, var_59, adj_world_offsets, adj_59, adj_60);
        wp::adj_where(var_58, var_21, var_24, adj_58, adj_21, adj_24, adj_59);
        if (!var_58) {
        }
        if (var_58) {
        }
        // adj: contact_center += world_offsets[world_a if world_a >= 0 else world_b]         <L 530>
    }
    if (!var_52) {
    }
    // adj: if world_a >= 0 or world_b >= 0:                                                  <L 529>
    wp::adj_copy(var_50, adj_50, adj_51);
    // adj: contact_center = world_pos0                                                       <L 528>
    wp::adj_transform_point(var_44, var_47, adj_44, adj_47, adj_50);
    wp::adj_add(var_48, var_49, adj_45, adj_46, adj_47);
    wp::adj_address(var_contact_offset0, var_0, adj_contact_offset0, adj_0, adj_46);
    wp::adj_address(var_contact_point0, var_0, adj_contact_point0, adj_0, adj_45);
    // adj: world_pos0 = wp.transform_point(X_wb_a, contact_point0[tid] + contact_offset0[tid])  <L 527>
    wp::adj_where(var_40, var_42, var_38, adj_40, adj_42, adj_38, adj_44);
    if (var_40) {
        wp::adj_copy(var_43, adj_41, adj_42);
        wp::adj_address(var_body_q, var_36, adj_body_q, adj_36, adj_41);
        // adj: X_wb_a = body_q[body_a]                                                       <L 525>
    }
    // adj: if body_a >= 0:                                                                   <L 524>
    // adj: X_wb_a = wp.transform_identity()                                                  <L 523>
    wp::adj_copy(var_37, adj_35, adj_36);
    wp::adj_address(var_shape_body, var_14, adj_shape_body, adj_14, adj_35);
    // adj: body_a = shape_body[shape_a]                                                      <L 522>
    if (var_visible_worlds_mask) {
        if (var_30) {
            if (var_33) {
                label2:;
                // adj: return                                                                <L 520>
                wp::adj_array_store(var_line_end, var_0, var_7, adj_line_end, adj_0, adj_7);
                // adj: line_end[tid] = nan_line                                              <L 519>
                wp::adj_array_store(var_line_start, var_0, var_7, adj_line_start, adj_0, adj_7);
                // adj: line_start[tid] = nan_line                                            <L 518>
            }
            wp::adj_address(var_visible_worlds_mask, var_28, adj_visible_worlds_mask, adj_28, adj_31);
            // adj: if visible_worlds_mask[w] == 0:                                           <L 517>
        }
        // adj: if w >= 0:                                                                    <L 516>
        wp::adj_where(var_27, var_21, var_24, adj_27, adj_21, adj_24, adj_28);
        if (!var_27) {
        }
        if (var_27) {
        }
        // adj: w = world_a if world_a >= 0 else world_b                                      <L 515>
    }
    // adj: if visible_worlds_mask:                                                           <L 514>
    wp::adj_copy(var_25, adj_23, adj_24);
    wp::adj_address(var_shape_world, var_17, adj_shape_world, adj_17, adj_23);
    // adj: world_b = shape_world[shape_b]                                                    <L 513>
    wp::adj_copy(var_22, adj_20, adj_21);
    wp::adj_address(var_shape_world, var_14, adj_shape_world, adj_14, adj_20);
    // adj: world_a = shape_world[shape_a]                                                    <L 512>
    if (var_19) {
        label1:;
        // adj: return                                                                        <L 510>
        wp::adj_array_store(var_line_end, var_0, var_7, adj_line_end, adj_0, adj_7);
        // adj: line_end[tid] = nan_line                                                      <L 509>
        wp::adj_array_store(var_line_start, var_0, var_7, adj_line_start, adj_0, adj_7);
        // adj: line_start[tid] = nan_line                                                    <L 508>
    }
    // adj: if shape_a == shape_b:                                                            <L 507>
    wp::adj_copy(var_18, adj_16, adj_17);
    wp::adj_address(var_contact_shape1, var_0, adj_contact_shape1, adj_0, adj_16);
    // adj: shape_b = contact_shape1[tid]                                                     <L 506>
    wp::adj_copy(var_15, adj_13, adj_14);
    wp::adj_address(var_contact_shape0, var_0, adj_contact_shape0, adj_0, adj_13);
    // adj: shape_a = contact_shape0[tid]                                                     <L 505>
    if (var_12) {
        label0:;
        // adj: return                                                                        <L 503>
        wp::adj_array_store(var_line_end, var_0, var_7, adj_line_end, adj_0, adj_7);
        // adj: line_end[tid] = nan_line                                                      <L 502>
        wp::adj_array_store(var_line_start, var_0, var_7, adj_line_start, adj_0, adj_7);
        // adj: line_start[tid] = nan_line                                                    <L 501>
    }
    // adj: if tid >= count:                                                                  <L 500>
    wp::adj_copy(var_11, adj_9, adj_10);
    wp::adj_address(var_contact_count, var_8, adj_contact_count, adj_8, adj_9);
    // adj: count = contact_count[0]                                                          <L 499>
    wp::adj_vec_t(var_2, var_4, var_6, adj_2, adj_4, adj_6, adj_7);
    // adj: nan_line = wp.vec3(wp.nan, wp.nan, wp.nan)                                        <L 497>
    // adj: tid = wp.tid()                                                                    <L 496>
    // adj: def compute_contact_force_arrows(                                                 <L 472>
    return;
}



extern "C" {

// Python CPU entry points
WP_API void compute_contact_force_arrows_d24d1bba_cpu_forward(
    wp::launch_bounds_t<1> *dim,
    wp_args_compute_contact_force_arrows_d24d1bba *_wp_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        compute_contact_force_arrows_d24d1bba_cpu_kernel_forward(*dim, task_index, _wp_args);
    }
}

} // extern C



extern "C" {

WP_API void compute_contact_force_arrows_d24d1bba_cpu_backward(
    wp::launch_bounds_t<1> *dim,
    wp_args_compute_contact_force_arrows_d24d1bba *_wp_args,
    wp_args_compute_contact_force_arrows_d24d1bba *_wp_adj_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        compute_contact_force_arrows_d24d1bba_cpu_kernel_backward(*dim, task_index, _wp_args, _wp_adj_args);
    }
}

} // extern C

struct wp_args_compute_com_positions_f0147af8 {
    wp::array_t<wp::transform_t<wp::float32>> body_q;
    wp::array_t<wp::vec_t<3, wp::float32>> body_com;
    wp::array_t<wp::int32> body_world;
    wp::array_t<wp::vec_t<3, wp::float32>> world_offsets;
    wp::transform_t<wp::float32> layer_xform;
    wp::array_t<wp::int32> visible_worlds_mask;
    wp::array_t<wp::vec_t<3, wp::float32>> com_positions;
};


void compute_com_positions_f0147af8_cpu_kernel_forward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_compute_com_positions_f0147af8 *_wp_args)
{
    //---------
    // argument vars
    wp::array_t<wp::transform_t<wp::float32>> var_body_q = _wp_args->body_q;
    wp::array_t<wp::vec_t<3, wp::float32>> var_body_com = _wp_args->body_com;
    wp::array_t<wp::int32> var_body_world = _wp_args->body_world;
    wp::array_t<wp::vec_t<3, wp::float32>> var_world_offsets = _wp_args->world_offsets;
    wp::transform_t<wp::float32> var_layer_xform = _wp_args->layer_xform;
    wp::array_t<wp::int32> var_visible_worlds_mask = _wp_args->visible_worlds_mask;
    wp::array_t<wp::vec_t<3, wp::float32>> var_com_positions = _wp_args->com_positions;
    //---------
    // primal vars
    wp::int32 var_0;
    wp::int32* var_1;
    wp::int32 var_2;
    wp::int32 var_3;
    const wp::int32 var_4 = 0;
    bool var_5;
    wp::int32* var_6;
    const wp::int32 var_7 = 0;
    bool var_8;
    wp::int32 var_9;
    const wp::float32 var_10 = NAN;
    const wp::float32 var_11 = NAN;
    const wp::float32 var_12 = NAN;
    const wp::float32 var_13 = NAN;
    const wp::float32 var_14 = NAN;
    const wp::float32 var_15 = NAN;
    wp::vec_t<3, wp::float32> var_16;
    wp::transform_t<wp::float32>* var_17;
    wp::transform_t<wp::float32> var_18;
    wp::transform_t<wp::float32> var_19;
    wp::vec_t<3, wp::float32>* var_20;
    wp::vec_t<3, wp::float32> var_21;
    wp::vec_t<3, wp::float32> var_22;
    bool var_23;
    const wp::int32 var_24 = 0;
    bool var_25;
    wp::shape_t* var_26;
    const wp::int32 var_27 = 0;
    wp::int32 var_28;
    wp::shape_t var_29;
    bool var_30;
    wp::vec_t<3, wp::float32>* var_31;
    wp::vec_t<3, wp::float32> var_32;
    wp::vec_t<3, wp::float32> var_33;
    wp::vec_t<3, wp::float32> var_34;
    wp::vec_t<3, wp::float32> var_35;
    //---------
    // forward
    // def compute_com_positions(                                                             <L 647>
    // tid = wp.tid()                                                                         <L 656>
    var_0 = builtin_tid1d();
    // world_idx = body_world[tid]                                                            <L 659>
    var_1 = wp::address(var_body_world, var_0);
    var_3 = wp::load(var_1);
    var_2 = wp::copy(var_3);
    // if visible_worlds_mask:                                                                <L 660>
    if (var_visible_worlds_mask) {
        // if world_idx >= 0:                                                                 <L 661>
        var_5 = (var_2 >= var_4);
        if (var_5) {
            // if visible_worlds_mask[world_idx] == 0:                                        <L 662>
            var_6 = wp::address(var_visible_worlds_mask, var_2);
            var_9 = wp::load(var_6);
            var_8 = (var_9 == var_7);
            if (var_8) {
                // com_positions[tid] = wp.vec3(wp.nan, wp.nan, wp.nan)                       <L 663>
                var_16 = wp::vec_t<3, wp::float32>(var_11, var_13, var_15);
                wp::array_store(var_com_positions, var_0, var_16);
                // return                                                                     <L 664>
                return;
            }
        }
    }
    // body_tf = body_q[tid]                                                                  <L 666>
    var_17 = wp::address(var_body_q, var_0);
    var_19 = wp::load(var_17);
    var_18 = wp::copy(var_19);
    // world_com = wp.transform_point(body_tf, body_com[tid])                                 <L 667>
    var_20 = wp::address(var_body_com, var_0);
    var_22 = wp::load(var_20);
    var_21 = wp::transform_point(var_18, var_22);
    // if world_offsets and world_idx >= 0 and world_idx < world_offsets.shape[0]:            <L 668>
    var_23 = var_world_offsets;
    if (var_23) {
        var_25 = (var_2 >= var_24);
        var_23 = var_23 && var_25;
    }
    if (var_23) {
        var_26 = &(var_world_offsets.shape);
        var_29 = wp::load(var_26);
        var_28 = wp::extract(var_29, var_27);
        var_30 = (var_2 < var_28);
        var_23 = var_23 && var_30;
    }
    if (var_23) {
        // world_com = world_com + world_offsets[world_idx]                                   <L 669>
        var_31 = wp::address(var_world_offsets, var_2);
        var_33 = wp::load(var_31);
        var_32 = wp::add(var_21, var_33);
    }
    var_34 = wp::where(var_23, var_32, var_21);
    // com_positions[tid] = wp.transform_point(layer_xform, world_com)                        <L 670>
    var_35 = wp::transform_point(var_layer_xform, var_34);
    wp::array_store(var_com_positions, var_0, var_35);
}



void compute_com_positions_f0147af8_cpu_kernel_backward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_compute_com_positions_f0147af8 *_wp_args,
    wp_args_compute_com_positions_f0147af8 *_wp_adj_args)
{
    //---------
    // argument vars
    wp::array_t<wp::transform_t<wp::float32>> var_body_q = _wp_args->body_q;
    wp::array_t<wp::vec_t<3, wp::float32>> var_body_com = _wp_args->body_com;
    wp::array_t<wp::int32> var_body_world = _wp_args->body_world;
    wp::array_t<wp::vec_t<3, wp::float32>> var_world_offsets = _wp_args->world_offsets;
    wp::transform_t<wp::float32> var_layer_xform = _wp_args->layer_xform;
    wp::array_t<wp::int32> var_visible_worlds_mask = _wp_args->visible_worlds_mask;
    wp::array_t<wp::vec_t<3, wp::float32>> var_com_positions = _wp_args->com_positions;
    wp::array_t<wp::transform_t<wp::float32>> adj_body_q = _wp_adj_args->body_q;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_body_com = _wp_adj_args->body_com;
    wp::array_t<wp::int32> adj_body_world = _wp_adj_args->body_world;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_world_offsets = _wp_adj_args->world_offsets;
    wp::transform_t<wp::float32> adj_layer_xform = _wp_adj_args->layer_xform;
    wp::array_t<wp::int32> adj_visible_worlds_mask = _wp_adj_args->visible_worlds_mask;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_com_positions = _wp_adj_args->com_positions;
    //---------
    // primal vars
    wp::int32 var_0;
    wp::int32* var_1;
    wp::int32 var_2;
    wp::int32 var_3;
    const wp::int32 var_4 = 0;
    bool var_5;
    wp::int32* var_6;
    const wp::int32 var_7 = 0;
    bool var_8;
    wp::int32 var_9;
    const wp::float32 var_10 = NAN;
    const wp::float32 var_11 = NAN;
    const wp::float32 var_12 = NAN;
    const wp::float32 var_13 = NAN;
    const wp::float32 var_14 = NAN;
    const wp::float32 var_15 = NAN;
    wp::vec_t<3, wp::float32> var_16;
    wp::transform_t<wp::float32>* var_17;
    wp::transform_t<wp::float32> var_18;
    wp::transform_t<wp::float32> var_19;
    wp::vec_t<3, wp::float32>* var_20;
    wp::vec_t<3, wp::float32> var_21;
    wp::vec_t<3, wp::float32> var_22;
    bool var_23;
    const wp::int32 var_24 = 0;
    bool var_25;
    wp::shape_t* var_26;
    const wp::int32 var_27 = 0;
    wp::int32 var_28;
    wp::shape_t var_29;
    bool var_30;
    wp::vec_t<3, wp::float32>* var_31;
    wp::vec_t<3, wp::float32> var_32;
    wp::vec_t<3, wp::float32> var_33;
    wp::vec_t<3, wp::float32> var_34;
    wp::vec_t<3, wp::float32> var_35;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    wp::int32 adj_1 = {};
    wp::int32 adj_2 = {};
    wp::int32 adj_3 = {};
    wp::int32 adj_4 = {};
    bool adj_5 = {};
    wp::int32 adj_6 = {};
    wp::int32 adj_7 = {};
    bool adj_8 = {};
    wp::int32 adj_9 = {};
    wp::float32 adj_10 = {};
    wp::float32 adj_11 = {};
    wp::float32 adj_12 = {};
    wp::float32 adj_13 = {};
    wp::float32 adj_14 = {};
    wp::float32 adj_15 = {};
    wp::vec_t<3, wp::float32> adj_16 = {};
    wp::transform_t<wp::float32> adj_17 = {};
    wp::transform_t<wp::float32> adj_18 = {};
    wp::transform_t<wp::float32> adj_19 = {};
    wp::vec_t<3, wp::float32> adj_20 = {};
    wp::vec_t<3, wp::float32> adj_21 = {};
    wp::vec_t<3, wp::float32> adj_22 = {};
    bool adj_23 = {};
    wp::int32 adj_24 = {};
    bool adj_25 = {};
    wp::shape_t adj_26 = {};
    wp::int32 adj_27 = {};
    wp::int32 adj_28 = {};
    wp::shape_t adj_29 = {};
    bool adj_30 = {};
    wp::vec_t<3, wp::float32> adj_31 = {};
    wp::vec_t<3, wp::float32> adj_32 = {};
    wp::vec_t<3, wp::float32> adj_33 = {};
    wp::vec_t<3, wp::float32> adj_34 = {};
    wp::vec_t<3, wp::float32> adj_35 = {};
    //---------
    // forward
    // def compute_com_positions(                                                             <L 647>
    // tid = wp.tid()                                                                         <L 656>
    var_0 = builtin_tid1d();
    // world_idx = body_world[tid]                                                            <L 659>
    var_1 = wp::address(var_body_world, var_0);
    var_3 = wp::load(var_1);
    var_2 = wp::copy(var_3);
    // if visible_worlds_mask:                                                                <L 660>
    if (var_visible_worlds_mask) {
        // if world_idx >= 0:                                                                 <L 661>
        var_5 = (var_2 >= var_4);
        if (var_5) {
            // if visible_worlds_mask[world_idx] == 0:                                        <L 662>
            var_6 = wp::address(var_visible_worlds_mask, var_2);
            var_9 = wp::load(var_6);
            var_8 = (var_9 == var_7);
            if (var_8) {
                // com_positions[tid] = wp.vec3(wp.nan, wp.nan, wp.nan)                       <L 663>
                var_16 = wp::vec_t<3, wp::float32>(var_11, var_13, var_15);
                // wp::array_store(var_com_positions, var_0, var_16);
                // return                                                                     <L 664>
                goto label0;
            }
        }
    }
    // body_tf = body_q[tid]                                                                  <L 666>
    var_17 = wp::address(var_body_q, var_0);
    var_19 = wp::load(var_17);
    var_18 = wp::copy(var_19);
    // world_com = wp.transform_point(body_tf, body_com[tid])                                 <L 667>
    var_20 = wp::address(var_body_com, var_0);
    var_22 = wp::load(var_20);
    var_21 = wp::transform_point(var_18, var_22);
    // if world_offsets and world_idx >= 0 and world_idx < world_offsets.shape[0]:            <L 668>
    var_23 = var_world_offsets;
    if (var_23) {
        var_25 = (var_2 >= var_24);
        var_23 = var_23 && var_25;
    }
    if (var_23) {
        var_26 = &(var_world_offsets.shape);
        var_29 = wp::load(var_26);
        var_28 = wp::extract(var_29, var_27);
        var_30 = (var_2 < var_28);
        var_23 = var_23 && var_30;
    }
    if (var_23) {
        // world_com = world_com + world_offsets[world_idx]                                   <L 669>
        var_31 = wp::address(var_world_offsets, var_2);
        var_33 = wp::load(var_31);
        var_32 = wp::add(var_21, var_33);
    }
    var_34 = wp::where(var_23, var_32, var_21);
    // com_positions[tid] = wp.transform_point(layer_xform, world_com)                        <L 670>
    var_35 = wp::transform_point(var_layer_xform, var_34);
    // wp::array_store(var_com_positions, var_0, var_35);
    //---------
    // reverse
    wp::adj_array_store(var_com_positions, var_0, var_35, adj_com_positions, adj_0, adj_35);
    wp::adj_transform_point(var_layer_xform, var_34, adj_layer_xform, adj_34, adj_35);
    // adj: com_positions[tid] = wp.transform_point(layer_xform, world_com)                   <L 670>
    wp::adj_where(var_23, var_32, var_21, adj_23, adj_32, adj_21, adj_34);
    if (var_23) {
        wp::adj_add(var_21, var_33, adj_21, adj_31, adj_32);
        wp::adj_address(var_world_offsets, var_2, adj_world_offsets, adj_2, adj_31);
        // adj: world_com = world_com + world_offsets[world_idx]                              <L 669>
    }
    if (var_23) {
        adj_world_offsets.shape = adj_26;
    }
    if (var_23) {
    }
    // adj: if world_offsets and world_idx >= 0 and world_idx < world_offsets.shape[0]:       <L 668>
    wp::adj_transform_point(var_18, var_22, adj_18, adj_20, adj_21);
    wp::adj_address(var_body_com, var_0, adj_body_com, adj_0, adj_20);
    // adj: world_com = wp.transform_point(body_tf, body_com[tid])                            <L 667>
    wp::adj_copy(var_19, adj_17, adj_18);
    wp::adj_address(var_body_q, var_0, adj_body_q, adj_0, adj_17);
    // adj: body_tf = body_q[tid]                                                             <L 666>
    if (var_visible_worlds_mask) {
        if (var_5) {
            if (var_8) {
                label0:;
                // adj: return                                                                <L 664>
                wp::adj_array_store(var_com_positions, var_0, var_16, adj_com_positions, adj_0, adj_16);
                wp::adj_vec_t(var_11, var_13, var_15, adj_11, adj_13, adj_15, adj_16);
                // adj: com_positions[tid] = wp.vec3(wp.nan, wp.nan, wp.nan)                  <L 663>
            }
            wp::adj_address(var_visible_worlds_mask, var_2, adj_visible_worlds_mask, adj_2, adj_6);
            // adj: if visible_worlds_mask[world_idx] == 0:                                   <L 662>
        }
        // adj: if world_idx >= 0:                                                            <L 661>
    }
    // adj: if visible_worlds_mask:                                                           <L 660>
    wp::adj_copy(var_3, adj_1, adj_2);
    wp::adj_address(var_body_world, var_0, adj_body_world, adj_0, adj_1);
    // adj: world_idx = body_world[tid]                                                       <L 659>
    // adj: tid = wp.tid()                                                                    <L 656>
    // adj: def compute_com_positions(                                                        <L 647>
    return;
}



extern "C" {

// Python CPU entry points
WP_API void compute_com_positions_f0147af8_cpu_forward(
    wp::launch_bounds_t<1> *dim,
    wp_args_compute_com_positions_f0147af8 *_wp_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        compute_com_positions_f0147af8_cpu_kernel_forward(*dim, task_index, _wp_args);
    }
}

} // extern C



extern "C" {

WP_API void compute_com_positions_f0147af8_cpu_backward(
    wp::launch_bounds_t<1> *dim,
    wp_args_compute_com_positions_f0147af8 *_wp_args,
    wp_args_compute_com_positions_f0147af8 *_wp_adj_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        compute_com_positions_f0147af8_cpu_kernel_backward(*dim, task_index, _wp_args, _wp_adj_args);
    }
}

} // extern C

struct wp_args_repack_shape_colors_12818fdd {
    wp::array_t<wp::vec_t<3, wp::float32>> shape_colors;
    wp::array_t<wp::int32> slot_to_shape;
    wp::array_t<wp::vec_t<3, wp::float32>> packed_shape_colors;
};


void repack_shape_colors_12818fdd_cpu_kernel_forward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_repack_shape_colors_12818fdd *_wp_args)
{
    //---------
    // argument vars
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_colors = _wp_args->shape_colors;
    wp::array_t<wp::int32> var_slot_to_shape = _wp_args->slot_to_shape;
    wp::array_t<wp::vec_t<3, wp::float32>> var_packed_shape_colors = _wp_args->packed_shape_colors;
    //---------
    // primal vars
    wp::int32 var_0;
    wp::int32* var_1;
    wp::vec_t<3, wp::float32>* var_2;
    wp::int32 var_3;
    wp::vec_t<3, wp::float32> var_4;
    //---------
    // forward
    // def repack_shape_colors(                                                               <L 187>
    // tid = wp.tid()                                                                         <L 193>
    var_0 = builtin_tid1d();
    // packed_shape_colors[tid] = shape_colors[slot_to_shape[tid]]                            <L 194>
    var_1 = wp::address(var_slot_to_shape, var_0);
    var_3 = wp::load(var_1);
    var_2 = wp::address(var_shape_colors, var_3);
    var_4 = wp::load(var_2);
    wp::array_store(var_packed_shape_colors, var_0, var_4);
}



void repack_shape_colors_12818fdd_cpu_kernel_backward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_repack_shape_colors_12818fdd *_wp_args,
    wp_args_repack_shape_colors_12818fdd *_wp_adj_args)
{
    //---------
    // argument vars
    wp::array_t<wp::vec_t<3, wp::float32>> var_shape_colors = _wp_args->shape_colors;
    wp::array_t<wp::int32> var_slot_to_shape = _wp_args->slot_to_shape;
    wp::array_t<wp::vec_t<3, wp::float32>> var_packed_shape_colors = _wp_args->packed_shape_colors;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_shape_colors = _wp_adj_args->shape_colors;
    wp::array_t<wp::int32> adj_slot_to_shape = _wp_adj_args->slot_to_shape;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_packed_shape_colors = _wp_adj_args->packed_shape_colors;
    //---------
    // primal vars
    wp::int32 var_0;
    wp::int32* var_1;
    wp::vec_t<3, wp::float32>* var_2;
    wp::int32 var_3;
    wp::vec_t<3, wp::float32> var_4;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    wp::int32 adj_1 = {};
    wp::vec_t<3, wp::float32> adj_2 = {};
    wp::int32 adj_3 = {};
    wp::vec_t<3, wp::float32> adj_4 = {};
    //---------
    // forward
    // def repack_shape_colors(                                                               <L 187>
    // tid = wp.tid()                                                                         <L 193>
    var_0 = builtin_tid1d();
    // packed_shape_colors[tid] = shape_colors[slot_to_shape[tid]]                            <L 194>
    var_1 = wp::address(var_slot_to_shape, var_0);
    var_3 = wp::load(var_1);
    var_2 = wp::address(var_shape_colors, var_3);
    var_4 = wp::load(var_2);
    // wp::array_store(var_packed_shape_colors, var_0, var_4);
    //---------
    // reverse
    wp::adj_array_store(var_packed_shape_colors, var_0, var_4, adj_packed_shape_colors, adj_0, adj_2);
    wp::adj_address(var_shape_colors, var_3, adj_shape_colors, adj_1, adj_2);
    wp::adj_address(var_slot_to_shape, var_0, adj_slot_to_shape, adj_0, adj_1);
    // adj: packed_shape_colors[tid] = shape_colors[slot_to_shape[tid]]                       <L 194>
    // adj: tid = wp.tid()                                                                    <L 193>
    // adj: def repack_shape_colors(                                                          <L 187>
    return;
}



extern "C" {

// Python CPU entry points
WP_API void repack_shape_colors_12818fdd_cpu_forward(
    wp::launch_bounds_t<1> *dim,
    wp_args_repack_shape_colors_12818fdd *_wp_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        repack_shape_colors_12818fdd_cpu_kernel_forward(*dim, task_index, _wp_args);
    }
}

} // extern C



extern "C" {

WP_API void repack_shape_colors_12818fdd_cpu_backward(
    wp::launch_bounds_t<1> *dim,
    wp_args_repack_shape_colors_12818fdd *_wp_args,
    wp_args_repack_shape_colors_12818fdd *_wp_adj_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        repack_shape_colors_12818fdd_cpu_kernel_backward(*dim, task_index, _wp_args, _wp_adj_args);
    }
}

} // extern C

struct wp_args_transform_points_8f8dfd7e {
    wp::array_t<wp::vec_t<3, wp::float32>> points;
    wp::transform_t<wp::float32> xform;
    wp::array_t<wp::vec_t<3, wp::float32>> transformed_points;
};


void transform_points_8f8dfd7e_cpu_kernel_forward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_transform_points_8f8dfd7e *_wp_args)
{
    //---------
    // argument vars
    wp::array_t<wp::vec_t<3, wp::float32>> var_points = _wp_args->points;
    wp::transform_t<wp::float32> var_xform = _wp_args->xform;
    wp::array_t<wp::vec_t<3, wp::float32>> var_transformed_points = _wp_args->transformed_points;
    //---------
    // primal vars
    wp::int32 var_0;
    wp::vec_t<3, wp::float32>* var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    //---------
    // forward
    // def transform_points(                                                                  <L 1041>
    // i = wp.tid()                                                                           <L 1046>
    var_0 = builtin_tid1d();
    // transformed_points[i] = wp.transform_point(xform, points[i])                           <L 1047>
    var_1 = wp::address(var_points, var_0);
    var_3 = wp::load(var_1);
    var_2 = wp::transform_point(var_xform, var_3);
    wp::array_store(var_transformed_points, var_0, var_2);
}



void transform_points_8f8dfd7e_cpu_kernel_backward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_transform_points_8f8dfd7e *_wp_args,
    wp_args_transform_points_8f8dfd7e *_wp_adj_args)
{
    //---------
    // argument vars
    wp::array_t<wp::vec_t<3, wp::float32>> var_points = _wp_args->points;
    wp::transform_t<wp::float32> var_xform = _wp_args->xform;
    wp::array_t<wp::vec_t<3, wp::float32>> var_transformed_points = _wp_args->transformed_points;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_points = _wp_adj_args->points;
    wp::transform_t<wp::float32> adj_xform = _wp_adj_args->xform;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_transformed_points = _wp_adj_args->transformed_points;
    //---------
    // primal vars
    wp::int32 var_0;
    wp::vec_t<3, wp::float32>* var_1;
    wp::vec_t<3, wp::float32> var_2;
    wp::vec_t<3, wp::float32> var_3;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    wp::vec_t<3, wp::float32> adj_1 = {};
    wp::vec_t<3, wp::float32> adj_2 = {};
    wp::vec_t<3, wp::float32> adj_3 = {};
    //---------
    // forward
    // def transform_points(                                                                  <L 1041>
    // i = wp.tid()                                                                           <L 1046>
    var_0 = builtin_tid1d();
    // transformed_points[i] = wp.transform_point(xform, points[i])                           <L 1047>
    var_1 = wp::address(var_points, var_0);
    var_3 = wp::load(var_1);
    var_2 = wp::transform_point(var_xform, var_3);
    // wp::array_store(var_transformed_points, var_0, var_2);
    //---------
    // reverse
    wp::adj_array_store(var_transformed_points, var_0, var_2, adj_transformed_points, adj_0, adj_2);
    wp::adj_transform_point(var_xform, var_3, adj_xform, adj_1, adj_2);
    wp::adj_address(var_points, var_0, adj_points, adj_0, adj_1);
    // adj: transformed_points[i] = wp.transform_point(xform, points[i])                      <L 1047>
    // adj: i = wp.tid()                                                                      <L 1046>
    // adj: def transform_points(                                                             <L 1041>
    return;
}



extern "C" {

// Python CPU entry points
WP_API void transform_points_8f8dfd7e_cpu_forward(
    wp::launch_bounds_t<1> *dim,
    wp_args_transform_points_8f8dfd7e *_wp_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        transform_points_8f8dfd7e_cpu_kernel_forward(*dim, task_index, _wp_args);
    }
}

} // extern C



extern "C" {

WP_API void transform_points_8f8dfd7e_cpu_backward(
    wp::launch_bounds_t<1> *dim,
    wp_args_transform_points_8f8dfd7e *_wp_args,
    wp_args_transform_points_8f8dfd7e *_wp_adj_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        transform_points_8f8dfd7e_cpu_kernel_backward(*dim, task_index, _wp_args, _wp_adj_args);
    }
}

} // extern C

struct wp_args_compute_pick_state_kernel_5fed07dc {
    wp::array_t<wp::transform_t<wp::float32>> body_q;
    wp::array_t<wp::int32> body_flags;
    wp::int32 body_index;
    wp::vec_t<3, wp::float32> hit_point_world;
    wp::array_t<wp::int32> pick_body;
    wp::array_t<PickingState_096ac041> pick_state;
};


void compute_pick_state_kernel_5fed07dc_cpu_kernel_forward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_compute_pick_state_kernel_5fed07dc *_wp_args)
{
    //---------
    // argument vars
    wp::array_t<wp::transform_t<wp::float32>> var_body_q = _wp_args->body_q;
    wp::array_t<wp::int32> var_body_flags = _wp_args->body_flags;
    wp::int32 var_body_index = _wp_args->body_index;
    wp::vec_t<3, wp::float32> var_hit_point_world = _wp_args->hit_point_world;
    wp::array_t<wp::int32> var_pick_body = _wp_args->pick_body;
    wp::array_t<PickingState_096ac041> var_pick_state = _wp_args->pick_state;
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    bool var_1;
    wp::int32* var_2;
    const wp::int32 var_3 = 2;
    wp::int32 var_4;
    wp::int32 var_5;
    const wp::int32 var_6 = -1;
    const wp::int32 var_7 = 0;
    const wp::int32 var_8 = 0;
    wp::transform_t<wp::float32>* var_9;
    wp::transform_t<wp::float32> var_10;
    wp::transform_t<wp::float32> var_11;
    wp::transform_t<wp::float32> var_12;
    wp::vec_t<3, wp::float32> var_13;
    const wp::int32 var_14 = 0;
    const wp::int32 var_15 = 0;
    const wp::int32 var_16 = 0;
    //---------
    // forward
    // def compute_pick_state_kernel(                                                         <L 28>
    // if body_index < 0:                                                                     <L 40>
    var_1 = (var_body_index < var_0);
    if (var_1) {
        // return                                                                             <L 41>
        return;
    }
    // if body_flags[body_index] & newton.BodyFlags.KINEMATIC:                                <L 42>
    var_2 = wp::address(var_body_flags, var_body_index);
    var_5 = wp::load(var_2);
    var_4 = wp::bit_and(var_5, var_3);
    if (var_4) {
        // pick_body[0] = -1                                                                  <L 43>
        wp::array_store(var_pick_body, var_7, var_6);
        // return                                                                             <L 44>
        return;
    }
    // pick_body[0] = body_index                                                              <L 47>
    wp::array_store(var_pick_body, var_8, var_body_index);
    // X_wb = body_q[body_index]                                                              <L 50>
    var_9 = wp::address(var_body_q, var_body_index);
    var_11 = wp::load(var_9);
    var_10 = wp::copy(var_11);
    // X_bw = wp.transform_inverse(X_wb)                                                      <L 51>
    var_12 = wp::transform_inverse(var_10);
    // pick_state[0].picked_point_local = wp.transform_point(X_bw, hit_point_world)           <L 53>
    var_13 = wp::transform_point(var_12, var_hit_point_world);
    wp::index(var_pick_state, var_14).picked_point_local = var_13;
    // pick_state[0].picking_target_world = hit_point_world                                   <L 56>
    wp::index(var_pick_state, var_15).picking_target_world = var_hit_point_world;
    // pick_state[0].picked_point_world = hit_point_world                                     <L 59>
    wp::index(var_pick_state, var_16).picked_point_world = var_hit_point_world;
}



void compute_pick_state_kernel_5fed07dc_cpu_kernel_backward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_compute_pick_state_kernel_5fed07dc *_wp_args,
    wp_args_compute_pick_state_kernel_5fed07dc *_wp_adj_args)
{
    //---------
    // argument vars
    wp::array_t<wp::transform_t<wp::float32>> var_body_q = _wp_args->body_q;
    wp::array_t<wp::int32> var_body_flags = _wp_args->body_flags;
    wp::int32 var_body_index = _wp_args->body_index;
    wp::vec_t<3, wp::float32> var_hit_point_world = _wp_args->hit_point_world;
    wp::array_t<wp::int32> var_pick_body = _wp_args->pick_body;
    wp::array_t<PickingState_096ac041> var_pick_state = _wp_args->pick_state;
    wp::array_t<wp::transform_t<wp::float32>> adj_body_q = _wp_adj_args->body_q;
    wp::array_t<wp::int32> adj_body_flags = _wp_adj_args->body_flags;
    wp::int32 adj_body_index = _wp_adj_args->body_index;
    wp::vec_t<3, wp::float32> adj_hit_point_world = _wp_adj_args->hit_point_world;
    wp::array_t<wp::int32> adj_pick_body = _wp_adj_args->pick_body;
    wp::array_t<PickingState_096ac041> adj_pick_state = _wp_adj_args->pick_state;
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    bool var_1;
    wp::int32* var_2;
    const wp::int32 var_3 = 2;
    wp::int32 var_4;
    wp::int32 var_5;
    const wp::int32 var_6 = -1;
    const wp::int32 var_7 = 0;
    const wp::int32 var_8 = 0;
    wp::transform_t<wp::float32>* var_9;
    wp::transform_t<wp::float32> var_10;
    wp::transform_t<wp::float32> var_11;
    wp::transform_t<wp::float32> var_12;
    wp::vec_t<3, wp::float32> var_13;
    const wp::int32 var_14 = 0;
    const wp::int32 var_15 = 0;
    const wp::int32 var_16 = 0;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    bool adj_1 = {};
    wp::int32 adj_2 = {};
    wp::int32 adj_3 = {};
    wp::int32 adj_4 = {};
    wp::int32 adj_5 = {};
    wp::int32 adj_6 = {};
    wp::int32 adj_7 = {};
    wp::int32 adj_8 = {};
    wp::transform_t<wp::float32> adj_9 = {};
    wp::transform_t<wp::float32> adj_10 = {};
    wp::transform_t<wp::float32> adj_11 = {};
    wp::transform_t<wp::float32> adj_12 = {};
    wp::vec_t<3, wp::float32> adj_13 = {};
    wp::int32 adj_14 = {};
    wp::int32 adj_15 = {};
    wp::int32 adj_16 = {};
    //---------
    // forward
    // def compute_pick_state_kernel(                                                         <L 28>
    // if body_index < 0:                                                                     <L 40>
    var_1 = (var_body_index < var_0);
    if (var_1) {
        // return                                                                             <L 41>
        goto label0;
    }
    // if body_flags[body_index] & newton.BodyFlags.KINEMATIC:                                <L 42>
    var_2 = wp::address(var_body_flags, var_body_index);
    var_5 = wp::load(var_2);
    var_4 = wp::bit_and(var_5, var_3);
    if (var_4) {
        // pick_body[0] = -1                                                                  <L 43>
        // wp::array_store(var_pick_body, var_7, var_6);
        // return                                                                             <L 44>
        goto label1;
    }
    // pick_body[0] = body_index                                                              <L 47>
    // wp::array_store(var_pick_body, var_8, var_body_index);
    // X_wb = body_q[body_index]                                                              <L 50>
    var_9 = wp::address(var_body_q, var_body_index);
    var_11 = wp::load(var_9);
    var_10 = wp::copy(var_11);
    // X_bw = wp.transform_inverse(X_wb)                                                      <L 51>
    var_12 = wp::transform_inverse(var_10);
    // pick_state[0].picked_point_local = wp.transform_point(X_bw, hit_point_world)           <L 53>
    var_13 = wp::transform_point(var_12, var_hit_point_world);
    wp::index(var_pick_state, var_14).picked_point_local = var_13;
    // pick_state[0].picking_target_world = hit_point_world                                   <L 56>
    wp::index(var_pick_state, var_15).picking_target_world = var_hit_point_world;
    // pick_state[0].picked_point_world = hit_point_world                                     <L 59>
    wp::index(var_pick_state, var_16).picked_point_world = var_hit_point_world;
    //---------
    // reverse
    wp::adj_array_store_slot(var_pick_state, adj_pick_state, adj_hit_point_world, [&](auto& _e) -> auto& { return _e.picked_point_world; }, var_16);
    // adj: pick_state[0].picked_point_world = hit_point_world                                <L 59>
    wp::adj_array_store_slot(var_pick_state, adj_pick_state, adj_hit_point_world, [&](auto& _e) -> auto& { return _e.picking_target_world; }, var_15);
    // adj: pick_state[0].picking_target_world = hit_point_world                              <L 56>
    wp::adj_array_store_slot(var_pick_state, adj_pick_state, adj_13, [&](auto& _e) -> auto& { return _e.picked_point_local; }, var_14);
    wp::adj_transform_point(var_12, var_hit_point_world, adj_12, adj_hit_point_world, adj_13);
    // adj: pick_state[0].picked_point_local = wp.transform_point(X_bw, hit_point_world)      <L 53>
    wp::adj_transform_inverse(var_10, adj_10, adj_12);
    // adj: X_bw = wp.transform_inverse(X_wb)                                                 <L 51>
    wp::adj_copy(var_11, adj_9, adj_10);
    wp::adj_address(var_body_q, var_body_index, adj_body_q, adj_body_index, adj_9);
    // adj: X_wb = body_q[body_index]                                                         <L 50>
    wp::adj_array_store(var_pick_body, var_8, var_body_index, adj_pick_body, adj_8, adj_body_index);
    // adj: pick_body[0] = body_index                                                         <L 47>
    if (var_4) {
        label1:;
        // adj: return                                                                        <L 44>
        wp::adj_array_store(var_pick_body, var_7, var_6, adj_pick_body, adj_7, adj_6);
        // adj: pick_body[0] = -1                                                             <L 43>
    }
    wp::adj_address(var_body_flags, var_body_index, adj_body_flags, adj_body_index, adj_2);
    // adj: if body_flags[body_index] & newton.BodyFlags.KINEMATIC:                           <L 42>
    if (var_1) {
        label0:;
        // adj: return                                                                        <L 41>
    }
    // adj: if body_index < 0:                                                                <L 40>
    // adj: def compute_pick_state_kernel(                                                    <L 28>
    return;
}



extern "C" {

// Python CPU entry points
WP_API void compute_pick_state_kernel_5fed07dc_cpu_forward(
    wp::launch_bounds_t<1> *dim,
    wp_args_compute_pick_state_kernel_5fed07dc *_wp_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        compute_pick_state_kernel_5fed07dc_cpu_kernel_forward(*dim, task_index, _wp_args);
    }
}

} // extern C



extern "C" {

WP_API void compute_pick_state_kernel_5fed07dc_cpu_backward(
    wp::launch_bounds_t<1> *dim,
    wp_args_compute_pick_state_kernel_5fed07dc *_wp_args,
    wp_args_compute_pick_state_kernel_5fed07dc *_wp_adj_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        compute_pick_state_kernel_5fed07dc_cpu_kernel_backward(*dim, task_index, _wp_args, _wp_adj_args);
    }
}

} // extern C

struct wp_args_compute_joint_basis_lines_7ba0414f {
    wp::array_t<wp::int32> joint_type;
    wp::array_t<wp::int32> joint_parent;
    wp::array_t<wp::int32> joint_child;
    wp::array_t<wp::transform_t<wp::float32>> joint_transform;
    wp::array_t<wp::transform_t<wp::float32>> body_q;
    wp::array_t<wp::int32> body_world;
    wp::array_t<wp::vec_t<3, wp::float32>> world_offsets;
    wp::transform_t<wp::float32> layer_xform;
    wp::array_t<wp::int32> visible_worlds_mask;
    wp::array_t<wp::float32> shape_collision_radius;
    wp::array_t<wp::int32> shape_body;
    wp::float32 line_scale;
    wp::array_t<wp::vec_t<3, wp::float32>> line_starts;
    wp::array_t<wp::vec_t<3, wp::float32>> line_ends;
    wp::array_t<wp::vec_t<3, wp::float32>> line_colors;
};


void compute_joint_basis_lines_7ba0414f_cpu_kernel_forward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_compute_joint_basis_lines_7ba0414f *_wp_args)
{
    //---------
    // argument vars
    wp::array_t<wp::int32> var_joint_type = _wp_args->joint_type;
    wp::array_t<wp::int32> var_joint_parent = _wp_args->joint_parent;
    wp::array_t<wp::int32> var_joint_child = _wp_args->joint_child;
    wp::array_t<wp::transform_t<wp::float32>> var_joint_transform = _wp_args->joint_transform;
    wp::array_t<wp::transform_t<wp::float32>> var_body_q = _wp_args->body_q;
    wp::array_t<wp::int32> var_body_world = _wp_args->body_world;
    wp::array_t<wp::vec_t<3, wp::float32>> var_world_offsets = _wp_args->world_offsets;
    wp::transform_t<wp::float32> var_layer_xform = _wp_args->layer_xform;
    wp::array_t<wp::int32> var_visible_worlds_mask = _wp_args->visible_worlds_mask;
    wp::array_t<wp::float32> var_shape_collision_radius = _wp_args->shape_collision_radius;
    wp::array_t<wp::int32> var_shape_body = _wp_args->shape_body;
    wp::float32 var_line_scale = _wp_args->line_scale;
    wp::array_t<wp::vec_t<3, wp::float32>> var_line_starts = _wp_args->line_starts;
    wp::array_t<wp::vec_t<3, wp::float32>> var_line_ends = _wp_args->line_ends;
    wp::array_t<wp::vec_t<3, wp::float32>> var_line_colors = _wp_args->line_colors;
    //---------
    // primal vars
    wp::int32 var_0;
    const wp::float32 var_1 = NAN;
    const wp::float32 var_2 = NAN;
    const wp::float32 var_3 = NAN;
    const wp::float32 var_4 = NAN;
    const wp::float32 var_5 = NAN;
    const wp::float32 var_6 = NAN;
    wp::vec_t<3, wp::float32> var_7;
    const wp::float32 var_8 = 0.0;
    const wp::float32 var_9 = 0.0;
    const wp::float32 var_10 = 0.0;
    wp::vec_t<3, wp::float32> var_11;
    const wp::int32 var_12 = 3;
    wp::int32 var_13;
    const wp::int32 var_14 = 3;
    wp::int32 var_15;
    wp::int32 var_16;
    bool var_17;
    wp::int32* var_18;
    wp::int32 var_19;
    wp::int32 var_20;
    bool var_21;
    const wp::int32 var_22 = 0;
    const wp::int32 var_23 = 0;
    wp::int32 var_24;
    bool var_25;
    const wp::int32 var_26 = 1;
    const wp::int32 var_27 = 1;
    wp::int32 var_28;
    bool var_29;
    const wp::int32 var_30 = 6;
    const wp::int32 var_31 = 6;
    wp::int32 var_32;
    bool var_33;
    const wp::int32 var_34 = 7;
    const wp::int32 var_35 = 7;
    wp::int32 var_36;
    bool var_37;
    const wp::int32 var_38 = 2;
    const wp::int32 var_39 = 2;
    wp::int32 var_40;
    bool var_41;
    wp::int32* var_42;
    wp::int32 var_43;
    wp::int32 var_44;
    wp::int32* var_45;
    wp::int32 var_46;
    wp::int32 var_47;
    const wp::int32 var_48 = 0;
    bool var_49;
    wp::int32 var_50;
    const wp::int32 var_51 = 0;
    bool var_52;
    wp::int32* var_53;
    wp::int32 var_54;
    wp::int32 var_55;
    const wp::int32 var_56 = 0;
    bool var_57;
    wp::int32* var_58;
    const wp::int32 var_59 = 0;
    bool var_60;
    wp::int32 var_61;
    wp::transform_t<wp::float32>* var_62;
    wp::transform_t<wp::float32> var_63;
    wp::transform_t<wp::float32> var_64;
    wp::vec_t<3, wp::float32> var_65;
    wp::quat_t<wp::float32> var_66;
    const wp::int32 var_67 = 0;
    bool var_68;
    wp::transform_t<wp::float32>* var_69;
    wp::transform_t<wp::float32> var_70;
    wp::transform_t<wp::float32> var_71;
    wp::vec_t<3, wp::float32> var_72;
    wp::quat_t<wp::float32> var_73;
    wp::quat_t<wp::float32> var_74;
    wp::int32* var_75;
    wp::int32 var_76;
    wp::int32 var_77;
    bool var_78;
    const wp::int32 var_79 = 0;
    bool var_80;
    wp::vec_t<3, wp::float32>* var_81;
    wp::vec_t<3, wp::float32> var_82;
    wp::vec_t<3, wp::float32> var_83;
    wp::vec_t<3, wp::float32> var_84;
    wp::vec_t<3, wp::float32> var_85;
    wp::quat_t<wp::float32> var_86;
    wp::vec_t<3, wp::float32> var_87;
    wp::quat_t<wp::float32> var_88;
    wp::vec_t<3, wp::float32> var_89;
    wp::quat_t<wp::float32> var_90;
    wp::quat_t<wp::float32> var_91;
    wp::float32 var_92;
    const wp::int32 var_93 = 0;
    bool var_94;
    const wp::float32 var_95 = 1.0;
    const wp::float32 var_96 = 0.0;
    const wp::float32 var_97 = 0.0;
    wp::vec_t<3, wp::float32> var_98;
    wp::vec_t<3, wp::float32> var_99;
    const wp::float32 var_100 = 1.0;
    const wp::float32 var_101 = 0.0;
    const wp::float32 var_102 = 0.0;
    wp::vec_t<3, wp::float32> var_103;
    const wp::int32 var_104 = 1;
    bool var_105;
    const wp::float32 var_106 = 0.0;
    const wp::float32 var_107 = 1.0;
    const wp::float32 var_108 = 0.0;
    wp::vec_t<3, wp::float32> var_109;
    wp::vec_t<3, wp::float32> var_110;
    const wp::float32 var_111 = 0.0;
    const wp::float32 var_112 = 1.0;
    const wp::float32 var_113 = 0.0;
    wp::vec_t<3, wp::float32> var_114;
    const wp::float32 var_115 = 0.0;
    const wp::float32 var_116 = 0.0;
    const wp::float32 var_117 = 1.0;
    wp::vec_t<3, wp::float32> var_118;
    wp::vec_t<3, wp::float32> var_119;
    const wp::float32 var_120 = 0.0;
    const wp::float32 var_121 = 0.0;
    const wp::float32 var_122 = 1.0;
    wp::vec_t<3, wp::float32> var_123;
    wp::vec_t<3, wp::float32> var_124;
    wp::vec_t<3, wp::float32> var_125;
    wp::vec_t<3, wp::float32> var_126;
    wp::vec_t<3, wp::float32> var_127;
    wp::vec_t<3, wp::float32> var_128;
    wp::vec_t<3, wp::float32> var_129;
    //---------
    // forward
    // def compute_joint_basis_lines(                                                         <L 538>
    // tid = wp.tid()                                                                         <L 560>
    var_0 = builtin_tid1d();
    // nan_line = wp.vec3(wp.nan, wp.nan, wp.nan)                                             <L 561>
    var_7 = wp::vec_t<3, wp::float32>(var_2, var_4, var_6);
    // zero_color = wp.vec3(0.0, 0.0, 0.0)                                                    <L 562>
    var_11 = wp::vec_t<3, wp::float32>(var_8, var_9, var_10);
    // joint_id = tid // 3                                                                    <L 565>
    var_13 = wp::floordiv(var_0, var_12);
    // axis_id = tid % 3                                                                      <L 566>
    var_15 = wp::mod(var_0, var_14);
    // if joint_id >= len(joint_type):                                                        <L 569>
    var_16 = wp::len(var_joint_type);
    var_17 = (var_13 >= var_16);
    if (var_17) {
        // line_starts[tid] = nan_line                                                        <L 570>
        wp::array_store(var_line_starts, var_0, var_7);
        // line_ends[tid] = nan_line                                                          <L 571>
        wp::array_store(var_line_ends, var_0, var_7);
        // line_colors[tid] = zero_color                                                      <L 572>
        wp::array_store(var_line_colors, var_0, var_11);
        // return                                                                             <L 573>
        return;
    }
    // joint_t = joint_type[joint_id]                                                         <L 575>
    var_18 = wp::address(var_joint_type, var_13);
    var_20 = wp::load(var_18);
    var_19 = wp::copy(var_20);
    // if (                                                                                   <L 576>
    // joint_t != int(newton.JointType.PRISMATIC)                                             <L 577>
    var_24 = wp::int(var_23);
    var_25 = (var_19 != var_24);
    var_21 = var_25;
    if (var_21) {
        // and joint_t != int(newton.JointType.REVOLUTE)                                      <L 578>
        var_28 = wp::int(var_27);
        var_29 = (var_19 != var_28);
        var_21 = var_21 && var_29;
    }
    if (var_21) {
        // and joint_t != int(newton.JointType.D6)                                            <L 579>
        var_32 = wp::int(var_31);
        var_33 = (var_19 != var_32);
        var_21 = var_21 && var_33;
    }
    if (var_21) {
        // and joint_t != int(newton.JointType.CABLE)                                         <L 580>
        var_36 = wp::int(var_35);
        var_37 = (var_19 != var_36);
        var_21 = var_21 && var_37;
    }
    if (var_21) {
        // and joint_t != int(newton.JointType.BALL)                                          <L 581>
        var_40 = wp::int(var_39);
        var_41 = (var_19 != var_40);
        var_21 = var_21 && var_41;
    }
    if (var_21) {
        // line_starts[tid] = nan_line                                                        <L 584>
        wp::array_store(var_line_starts, var_0, var_7);
        // line_ends[tid] = nan_line                                                          <L 585>
        wp::array_store(var_line_ends, var_0, var_7);
        // line_colors[tid] = zero_color                                                      <L 586>
        wp::array_store(var_line_colors, var_0, var_11);
        // return                                                                             <L 587>
        return;
    }
    // parent_body = joint_parent[joint_id]                                                   <L 590>
    var_42 = wp::address(var_joint_parent, var_13);
    var_44 = wp::load(var_42);
    var_43 = wp::copy(var_44);
    // child_body = joint_child[joint_id]                                                     <L 591>
    var_45 = wp::address(var_joint_child, var_13);
    var_47 = wp::load(var_45);
    var_46 = wp::copy(var_47);
    // filter_body = parent_body if parent_body >= 0 else child_body                          <L 592>
    var_49 = (var_43 >= var_48);
    if (var_49) {
    }
    if (!var_49) {
    }
    var_50 = wp::where(var_49, var_43, var_46);
    // if visible_worlds_mask:                                                                <L 593>
    if (var_visible_worlds_mask) {
        // if filter_body >= 0:                                                               <L 594>
        var_52 = (var_50 >= var_51);
        if (var_52) {
            // world_idx = body_world[filter_body]                                            <L 595>
            var_53 = wp::address(var_body_world, var_50);
            var_55 = wp::load(var_53);
            var_54 = wp::copy(var_55);
            // if world_idx >= 0:                                                             <L 596>
            var_57 = (var_54 >= var_56);
            if (var_57) {
                // if visible_worlds_mask[world_idx] == 0:                                    <L 597>
                var_58 = wp::address(var_visible_worlds_mask, var_54);
                var_61 = wp::load(var_58);
                var_60 = (var_61 == var_59);
                if (var_60) {
                    // line_starts[tid] = nan_line                                            <L 598>
                    wp::array_store(var_line_starts, var_0, var_7);
                    // line_ends[tid] = nan_line                                              <L 599>
                    wp::array_store(var_line_ends, var_0, var_7);
                    // line_colors[tid] = zero_color                                          <L 600>
                    wp::array_store(var_line_colors, var_0, var_11);
                    // return                                                                 <L 601>
                    return;
                }
            }
        }
    }
    // joint_tf = joint_transform[joint_id]                                                   <L 604>
    var_62 = wp::address(var_joint_transform, var_13);
    var_64 = wp::load(var_62);
    var_63 = wp::copy(var_64);
    // joint_pos = wp.transform_get_translation(joint_tf)                                     <L 605>
    var_65 = wp::transform_get_translation(var_63);
    // joint_rot = wp.transform_get_rotation(joint_tf)                                        <L 606>
    var_66 = wp::transform_get_rotation(var_63);
    // if parent_body >= 0:                                                                   <L 609>
    var_68 = (var_43 >= var_67);
    if (var_68) {
        // parent_tf = body_q[parent_body]                                                    <L 610>
        var_69 = wp::address(var_body_q, var_43);
        var_71 = wp::load(var_69);
        var_70 = wp::copy(var_71);
        // world_pos = wp.transform_point(parent_tf, joint_pos)                               <L 612>
        var_72 = wp::transform_point(var_70, var_65);
        // world_rot = wp.mul(wp.transform_get_rotation(parent_tf), joint_rot)                <L 613>
        var_73 = wp::transform_get_rotation(var_70);
        var_74 = wp::mul(var_73, var_66);
        // parent_body_world = body_world[parent_body]                                        <L 615>
        var_75 = wp::address(var_body_world, var_43);
        var_77 = wp::load(var_75);
        var_76 = wp::copy(var_77);
        // if world_offsets and parent_body_world >= 0:                                       <L 616>
        var_78 = var_world_offsets;
        if (var_78) {
            var_80 = (var_76 >= var_79);
            var_78 = var_78 && var_80;
        }
        if (var_78) {
            // world_pos += world_offsets[parent_body_world]                                  <L 617>
            var_81 = wp::address(var_world_offsets, var_76);
            var_83 = wp::load(var_81);
            var_82 = wp::add(var_72, var_83);
        }
        var_84 = wp::where(var_78, var_82, var_72);
    }
    if (!var_68) {
        // world_pos = joint_pos                                                              <L 619>
        var_85 = wp::copy(var_65);
        // world_rot = joint_rot                                                              <L 620>
        var_86 = wp::copy(var_66);
    }
    var_87 = wp::where(var_68, var_84, var_85);
    var_88 = wp::where(var_68, var_74, var_86);
    // world_pos = wp.transform_point(layer_xform, world_pos)                                 <L 623>
    var_89 = wp::transform_point(var_layer_xform, var_87);
    // world_rot = wp.mul(wp.transform_get_rotation(layer_xform), world_rot)                  <L 624>
    var_90 = wp::transform_get_rotation(var_layer_xform);
    var_91 = wp::mul(var_90, var_88);
    // scale_factor = line_scale                                                              <L 627>
    var_92 = wp::copy(var_line_scale);
    // if axis_id == 0:  # X-axis (red)                                                       <L 630>
    var_94 = (var_15 == var_93);
    if (var_94) {
        // axis_vec = wp.quat_rotate(world_rot, wp.vec3(1.0, 0.0, 0.0))                       <L 631>
        var_98 = wp::vec_t<3, wp::float32>(var_95, var_96, var_97);
        var_99 = wp::quat_rotate(var_91, var_98);
        // color = wp.vec3(1.0, 0.0, 0.0)                                                     <L 632>
        var_103 = wp::vec_t<3, wp::float32>(var_100, var_101, var_102);
    }
    if (!var_94) {
        // elif axis_id == 1:  # Y-axis (green)                                               <L 633>
        var_105 = (var_15 == var_104);
        if (var_105) {
            // axis_vec = wp.quat_rotate(world_rot, wp.vec3(0.0, 1.0, 0.0))                   <L 634>
            var_109 = wp::vec_t<3, wp::float32>(var_106, var_107, var_108);
            var_110 = wp::quat_rotate(var_91, var_109);
            // color = wp.vec3(0.0, 1.0, 0.0)                                                 <L 635>
            var_114 = wp::vec_t<3, wp::float32>(var_111, var_112, var_113);
        }
        if (!var_105) {
            // axis_vec = wp.quat_rotate(world_rot, wp.vec3(0.0, 0.0, 1.0))                   <L 637>
            var_118 = wp::vec_t<3, wp::float32>(var_115, var_116, var_117);
            var_119 = wp::quat_rotate(var_91, var_118);
            // color = wp.vec3(0.0, 0.0, 1.0)                                                 <L 638>
            var_123 = wp::vec_t<3, wp::float32>(var_120, var_121, var_122);
        }
        var_124 = wp::where(var_105, var_110, var_119);
        var_125 = wp::where(var_105, var_114, var_123);
    }
    var_126 = wp::where(var_94, var_99, var_124);
    var_127 = wp::where(var_94, var_103, var_125);
    // line_starts[tid] = world_pos                                                           <L 641>
    wp::array_store(var_line_starts, var_0, var_89);
    // line_ends[tid] = world_pos + axis_vec * scale_factor                                   <L 642>
    var_128 = wp::mul(var_126, var_92);
    var_129 = wp::add(var_89, var_128);
    wp::array_store(var_line_ends, var_0, var_129);
    // line_colors[tid] = color                                                               <L 643>
    wp::array_store(var_line_colors, var_0, var_127);
}



void compute_joint_basis_lines_7ba0414f_cpu_kernel_backward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_compute_joint_basis_lines_7ba0414f *_wp_args,
    wp_args_compute_joint_basis_lines_7ba0414f *_wp_adj_args)
{
    //---------
    // argument vars
    wp::array_t<wp::int32> var_joint_type = _wp_args->joint_type;
    wp::array_t<wp::int32> var_joint_parent = _wp_args->joint_parent;
    wp::array_t<wp::int32> var_joint_child = _wp_args->joint_child;
    wp::array_t<wp::transform_t<wp::float32>> var_joint_transform = _wp_args->joint_transform;
    wp::array_t<wp::transform_t<wp::float32>> var_body_q = _wp_args->body_q;
    wp::array_t<wp::int32> var_body_world = _wp_args->body_world;
    wp::array_t<wp::vec_t<3, wp::float32>> var_world_offsets = _wp_args->world_offsets;
    wp::transform_t<wp::float32> var_layer_xform = _wp_args->layer_xform;
    wp::array_t<wp::int32> var_visible_worlds_mask = _wp_args->visible_worlds_mask;
    wp::array_t<wp::float32> var_shape_collision_radius = _wp_args->shape_collision_radius;
    wp::array_t<wp::int32> var_shape_body = _wp_args->shape_body;
    wp::float32 var_line_scale = _wp_args->line_scale;
    wp::array_t<wp::vec_t<3, wp::float32>> var_line_starts = _wp_args->line_starts;
    wp::array_t<wp::vec_t<3, wp::float32>> var_line_ends = _wp_args->line_ends;
    wp::array_t<wp::vec_t<3, wp::float32>> var_line_colors = _wp_args->line_colors;
    wp::array_t<wp::int32> adj_joint_type = _wp_adj_args->joint_type;
    wp::array_t<wp::int32> adj_joint_parent = _wp_adj_args->joint_parent;
    wp::array_t<wp::int32> adj_joint_child = _wp_adj_args->joint_child;
    wp::array_t<wp::transform_t<wp::float32>> adj_joint_transform = _wp_adj_args->joint_transform;
    wp::array_t<wp::transform_t<wp::float32>> adj_body_q = _wp_adj_args->body_q;
    wp::array_t<wp::int32> adj_body_world = _wp_adj_args->body_world;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_world_offsets = _wp_adj_args->world_offsets;
    wp::transform_t<wp::float32> adj_layer_xform = _wp_adj_args->layer_xform;
    wp::array_t<wp::int32> adj_visible_worlds_mask = _wp_adj_args->visible_worlds_mask;
    wp::array_t<wp::float32> adj_shape_collision_radius = _wp_adj_args->shape_collision_radius;
    wp::array_t<wp::int32> adj_shape_body = _wp_adj_args->shape_body;
    wp::float32 adj_line_scale = _wp_adj_args->line_scale;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_line_starts = _wp_adj_args->line_starts;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_line_ends = _wp_adj_args->line_ends;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_line_colors = _wp_adj_args->line_colors;
    //---------
    // primal vars
    wp::int32 var_0;
    const wp::float32 var_1 = NAN;
    const wp::float32 var_2 = NAN;
    const wp::float32 var_3 = NAN;
    const wp::float32 var_4 = NAN;
    const wp::float32 var_5 = NAN;
    const wp::float32 var_6 = NAN;
    wp::vec_t<3, wp::float32> var_7;
    const wp::float32 var_8 = 0.0;
    const wp::float32 var_9 = 0.0;
    const wp::float32 var_10 = 0.0;
    wp::vec_t<3, wp::float32> var_11;
    const wp::int32 var_12 = 3;
    wp::int32 var_13;
    const wp::int32 var_14 = 3;
    wp::int32 var_15;
    wp::int32 var_16;
    bool var_17;
    wp::int32* var_18;
    wp::int32 var_19;
    wp::int32 var_20;
    bool var_21;
    const wp::int32 var_22 = 0;
    const wp::int32 var_23 = 0;
    wp::int32 var_24;
    bool var_25;
    const wp::int32 var_26 = 1;
    const wp::int32 var_27 = 1;
    wp::int32 var_28;
    bool var_29;
    const wp::int32 var_30 = 6;
    const wp::int32 var_31 = 6;
    wp::int32 var_32;
    bool var_33;
    const wp::int32 var_34 = 7;
    const wp::int32 var_35 = 7;
    wp::int32 var_36;
    bool var_37;
    const wp::int32 var_38 = 2;
    const wp::int32 var_39 = 2;
    wp::int32 var_40;
    bool var_41;
    wp::int32* var_42;
    wp::int32 var_43;
    wp::int32 var_44;
    wp::int32* var_45;
    wp::int32 var_46;
    wp::int32 var_47;
    const wp::int32 var_48 = 0;
    bool var_49;
    wp::int32 var_50;
    const wp::int32 var_51 = 0;
    bool var_52;
    wp::int32* var_53;
    wp::int32 var_54;
    wp::int32 var_55;
    const wp::int32 var_56 = 0;
    bool var_57;
    wp::int32* var_58;
    const wp::int32 var_59 = 0;
    bool var_60;
    wp::int32 var_61;
    wp::transform_t<wp::float32>* var_62;
    wp::transform_t<wp::float32> var_63;
    wp::transform_t<wp::float32> var_64;
    wp::vec_t<3, wp::float32> var_65;
    wp::quat_t<wp::float32> var_66;
    const wp::int32 var_67 = 0;
    bool var_68;
    wp::transform_t<wp::float32>* var_69;
    wp::transform_t<wp::float32> var_70;
    wp::transform_t<wp::float32> var_71;
    wp::vec_t<3, wp::float32> var_72;
    wp::quat_t<wp::float32> var_73;
    wp::quat_t<wp::float32> var_74;
    wp::int32* var_75;
    wp::int32 var_76;
    wp::int32 var_77;
    bool var_78;
    const wp::int32 var_79 = 0;
    bool var_80;
    wp::vec_t<3, wp::float32>* var_81;
    wp::vec_t<3, wp::float32> var_82;
    wp::vec_t<3, wp::float32> var_83;
    wp::vec_t<3, wp::float32> var_84;
    wp::vec_t<3, wp::float32> var_85;
    wp::quat_t<wp::float32> var_86;
    wp::vec_t<3, wp::float32> var_87;
    wp::quat_t<wp::float32> var_88;
    wp::vec_t<3, wp::float32> var_89;
    wp::quat_t<wp::float32> var_90;
    wp::quat_t<wp::float32> var_91;
    wp::float32 var_92;
    const wp::int32 var_93 = 0;
    bool var_94;
    const wp::float32 var_95 = 1.0;
    const wp::float32 var_96 = 0.0;
    const wp::float32 var_97 = 0.0;
    wp::vec_t<3, wp::float32> var_98;
    wp::vec_t<3, wp::float32> var_99;
    const wp::float32 var_100 = 1.0;
    const wp::float32 var_101 = 0.0;
    const wp::float32 var_102 = 0.0;
    wp::vec_t<3, wp::float32> var_103;
    const wp::int32 var_104 = 1;
    bool var_105;
    const wp::float32 var_106 = 0.0;
    const wp::float32 var_107 = 1.0;
    const wp::float32 var_108 = 0.0;
    wp::vec_t<3, wp::float32> var_109;
    wp::vec_t<3, wp::float32> var_110;
    const wp::float32 var_111 = 0.0;
    const wp::float32 var_112 = 1.0;
    const wp::float32 var_113 = 0.0;
    wp::vec_t<3, wp::float32> var_114;
    const wp::float32 var_115 = 0.0;
    const wp::float32 var_116 = 0.0;
    const wp::float32 var_117 = 1.0;
    wp::vec_t<3, wp::float32> var_118;
    wp::vec_t<3, wp::float32> var_119;
    const wp::float32 var_120 = 0.0;
    const wp::float32 var_121 = 0.0;
    const wp::float32 var_122 = 1.0;
    wp::vec_t<3, wp::float32> var_123;
    wp::vec_t<3, wp::float32> var_124;
    wp::vec_t<3, wp::float32> var_125;
    wp::vec_t<3, wp::float32> var_126;
    wp::vec_t<3, wp::float32> var_127;
    wp::vec_t<3, wp::float32> var_128;
    wp::vec_t<3, wp::float32> var_129;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    wp::float32 adj_1 = {};
    wp::float32 adj_2 = {};
    wp::float32 adj_3 = {};
    wp::float32 adj_4 = {};
    wp::float32 adj_5 = {};
    wp::float32 adj_6 = {};
    wp::vec_t<3, wp::float32> adj_7 = {};
    wp::float32 adj_8 = {};
    wp::float32 adj_9 = {};
    wp::float32 adj_10 = {};
    wp::vec_t<3, wp::float32> adj_11 = {};
    wp::int32 adj_12 = {};
    wp::int32 adj_13 = {};
    wp::int32 adj_14 = {};
    wp::int32 adj_15 = {};
    wp::int32 adj_16 = {};
    bool adj_17 = {};
    wp::int32 adj_18 = {};
    wp::int32 adj_19 = {};
    wp::int32 adj_20 = {};
    bool adj_21 = {};
    wp::int32 adj_22 = {};
    wp::int32 adj_23 = {};
    wp::int32 adj_24 = {};
    bool adj_25 = {};
    wp::int32 adj_26 = {};
    wp::int32 adj_27 = {};
    wp::int32 adj_28 = {};
    bool adj_29 = {};
    wp::int32 adj_30 = {};
    wp::int32 adj_31 = {};
    wp::int32 adj_32 = {};
    bool adj_33 = {};
    wp::int32 adj_34 = {};
    wp::int32 adj_35 = {};
    wp::int32 adj_36 = {};
    bool adj_37 = {};
    wp::int32 adj_38 = {};
    wp::int32 adj_39 = {};
    wp::int32 adj_40 = {};
    bool adj_41 = {};
    wp::int32 adj_42 = {};
    wp::int32 adj_43 = {};
    wp::int32 adj_44 = {};
    wp::int32 adj_45 = {};
    wp::int32 adj_46 = {};
    wp::int32 adj_47 = {};
    wp::int32 adj_48 = {};
    bool adj_49 = {};
    wp::int32 adj_50 = {};
    wp::int32 adj_51 = {};
    bool adj_52 = {};
    wp::int32 adj_53 = {};
    wp::int32 adj_54 = {};
    wp::int32 adj_55 = {};
    wp::int32 adj_56 = {};
    bool adj_57 = {};
    wp::int32 adj_58 = {};
    wp::int32 adj_59 = {};
    bool adj_60 = {};
    wp::int32 adj_61 = {};
    wp::transform_t<wp::float32> adj_62 = {};
    wp::transform_t<wp::float32> adj_63 = {};
    wp::transform_t<wp::float32> adj_64 = {};
    wp::vec_t<3, wp::float32> adj_65 = {};
    wp::quat_t<wp::float32> adj_66 = {};
    wp::int32 adj_67 = {};
    bool adj_68 = {};
    wp::transform_t<wp::float32> adj_69 = {};
    wp::transform_t<wp::float32> adj_70 = {};
    wp::transform_t<wp::float32> adj_71 = {};
    wp::vec_t<3, wp::float32> adj_72 = {};
    wp::quat_t<wp::float32> adj_73 = {};
    wp::quat_t<wp::float32> adj_74 = {};
    wp::int32 adj_75 = {};
    wp::int32 adj_76 = {};
    wp::int32 adj_77 = {};
    bool adj_78 = {};
    wp::int32 adj_79 = {};
    bool adj_80 = {};
    wp::vec_t<3, wp::float32> adj_81 = {};
    wp::vec_t<3, wp::float32> adj_82 = {};
    wp::vec_t<3, wp::float32> adj_83 = {};
    wp::vec_t<3, wp::float32> adj_84 = {};
    wp::vec_t<3, wp::float32> adj_85 = {};
    wp::quat_t<wp::float32> adj_86 = {};
    wp::vec_t<3, wp::float32> adj_87 = {};
    wp::quat_t<wp::float32> adj_88 = {};
    wp::vec_t<3, wp::float32> adj_89 = {};
    wp::quat_t<wp::float32> adj_90 = {};
    wp::quat_t<wp::float32> adj_91 = {};
    wp::float32 adj_92 = {};
    wp::int32 adj_93 = {};
    bool adj_94 = {};
    wp::float32 adj_95 = {};
    wp::float32 adj_96 = {};
    wp::float32 adj_97 = {};
    wp::vec_t<3, wp::float32> adj_98 = {};
    wp::vec_t<3, wp::float32> adj_99 = {};
    wp::float32 adj_100 = {};
    wp::float32 adj_101 = {};
    wp::float32 adj_102 = {};
    wp::vec_t<3, wp::float32> adj_103 = {};
    wp::int32 adj_104 = {};
    bool adj_105 = {};
    wp::float32 adj_106 = {};
    wp::float32 adj_107 = {};
    wp::float32 adj_108 = {};
    wp::vec_t<3, wp::float32> adj_109 = {};
    wp::vec_t<3, wp::float32> adj_110 = {};
    wp::float32 adj_111 = {};
    wp::float32 adj_112 = {};
    wp::float32 adj_113 = {};
    wp::vec_t<3, wp::float32> adj_114 = {};
    wp::float32 adj_115 = {};
    wp::float32 adj_116 = {};
    wp::float32 adj_117 = {};
    wp::vec_t<3, wp::float32> adj_118 = {};
    wp::vec_t<3, wp::float32> adj_119 = {};
    wp::float32 adj_120 = {};
    wp::float32 adj_121 = {};
    wp::float32 adj_122 = {};
    wp::vec_t<3, wp::float32> adj_123 = {};
    wp::vec_t<3, wp::float32> adj_124 = {};
    wp::vec_t<3, wp::float32> adj_125 = {};
    wp::vec_t<3, wp::float32> adj_126 = {};
    wp::vec_t<3, wp::float32> adj_127 = {};
    wp::vec_t<3, wp::float32> adj_128 = {};
    wp::vec_t<3, wp::float32> adj_129 = {};
    //---------
    // forward
    // def compute_joint_basis_lines(                                                         <L 538>
    // tid = wp.tid()                                                                         <L 560>
    var_0 = builtin_tid1d();
    // nan_line = wp.vec3(wp.nan, wp.nan, wp.nan)                                             <L 561>
    var_7 = wp::vec_t<3, wp::float32>(var_2, var_4, var_6);
    // zero_color = wp.vec3(0.0, 0.0, 0.0)                                                    <L 562>
    var_11 = wp::vec_t<3, wp::float32>(var_8, var_9, var_10);
    // joint_id = tid // 3                                                                    <L 565>
    var_13 = wp::floordiv(var_0, var_12);
    // axis_id = tid % 3                                                                      <L 566>
    var_15 = wp::mod(var_0, var_14);
    // if joint_id >= len(joint_type):                                                        <L 569>
    var_16 = wp::len(var_joint_type);
    var_17 = (var_13 >= var_16);
    if (var_17) {
        // line_starts[tid] = nan_line                                                        <L 570>
        // wp::array_store(var_line_starts, var_0, var_7);
        // line_ends[tid] = nan_line                                                          <L 571>
        // wp::array_store(var_line_ends, var_0, var_7);
        // line_colors[tid] = zero_color                                                      <L 572>
        // wp::array_store(var_line_colors, var_0, var_11);
        // return                                                                             <L 573>
        goto label0;
    }
    // joint_t = joint_type[joint_id]                                                         <L 575>
    var_18 = wp::address(var_joint_type, var_13);
    var_20 = wp::load(var_18);
    var_19 = wp::copy(var_20);
    // if (                                                                                   <L 576>
    // joint_t != int(newton.JointType.PRISMATIC)                                             <L 577>
    var_24 = wp::int(var_23);
    var_25 = (var_19 != var_24);
    var_21 = var_25;
    if (var_21) {
        // and joint_t != int(newton.JointType.REVOLUTE)                                      <L 578>
        var_28 = wp::int(var_27);
        var_29 = (var_19 != var_28);
        var_21 = var_21 && var_29;
    }
    if (var_21) {
        // and joint_t != int(newton.JointType.D6)                                            <L 579>
        var_32 = wp::int(var_31);
        var_33 = (var_19 != var_32);
        var_21 = var_21 && var_33;
    }
    if (var_21) {
        // and joint_t != int(newton.JointType.CABLE)                                         <L 580>
        var_36 = wp::int(var_35);
        var_37 = (var_19 != var_36);
        var_21 = var_21 && var_37;
    }
    if (var_21) {
        // and joint_t != int(newton.JointType.BALL)                                          <L 581>
        var_40 = wp::int(var_39);
        var_41 = (var_19 != var_40);
        var_21 = var_21 && var_41;
    }
    if (var_21) {
        // line_starts[tid] = nan_line                                                        <L 584>
        // wp::array_store(var_line_starts, var_0, var_7);
        // line_ends[tid] = nan_line                                                          <L 585>
        // wp::array_store(var_line_ends, var_0, var_7);
        // line_colors[tid] = zero_color                                                      <L 586>
        // wp::array_store(var_line_colors, var_0, var_11);
        // return                                                                             <L 587>
        goto label1;
    }
    // parent_body = joint_parent[joint_id]                                                   <L 590>
    var_42 = wp::address(var_joint_parent, var_13);
    var_44 = wp::load(var_42);
    var_43 = wp::copy(var_44);
    // child_body = joint_child[joint_id]                                                     <L 591>
    var_45 = wp::address(var_joint_child, var_13);
    var_47 = wp::load(var_45);
    var_46 = wp::copy(var_47);
    // filter_body = parent_body if parent_body >= 0 else child_body                          <L 592>
    var_49 = (var_43 >= var_48);
    if (var_49) {
    }
    if (!var_49) {
    }
    var_50 = wp::where(var_49, var_43, var_46);
    // if visible_worlds_mask:                                                                <L 593>
    if (var_visible_worlds_mask) {
        // if filter_body >= 0:                                                               <L 594>
        var_52 = (var_50 >= var_51);
        if (var_52) {
            // world_idx = body_world[filter_body]                                            <L 595>
            var_53 = wp::address(var_body_world, var_50);
            var_55 = wp::load(var_53);
            var_54 = wp::copy(var_55);
            // if world_idx >= 0:                                                             <L 596>
            var_57 = (var_54 >= var_56);
            if (var_57) {
                // if visible_worlds_mask[world_idx] == 0:                                    <L 597>
                var_58 = wp::address(var_visible_worlds_mask, var_54);
                var_61 = wp::load(var_58);
                var_60 = (var_61 == var_59);
                if (var_60) {
                    // line_starts[tid] = nan_line                                            <L 598>
                    // wp::array_store(var_line_starts, var_0, var_7);
                    // line_ends[tid] = nan_line                                              <L 599>
                    // wp::array_store(var_line_ends, var_0, var_7);
                    // line_colors[tid] = zero_color                                          <L 600>
                    // wp::array_store(var_line_colors, var_0, var_11);
                    // return                                                                 <L 601>
                    goto label2;
                }
            }
        }
    }
    // joint_tf = joint_transform[joint_id]                                                   <L 604>
    var_62 = wp::address(var_joint_transform, var_13);
    var_64 = wp::load(var_62);
    var_63 = wp::copy(var_64);
    // joint_pos = wp.transform_get_translation(joint_tf)                                     <L 605>
    var_65 = wp::transform_get_translation(var_63);
    // joint_rot = wp.transform_get_rotation(joint_tf)                                        <L 606>
    var_66 = wp::transform_get_rotation(var_63);
    // if parent_body >= 0:                                                                   <L 609>
    var_68 = (var_43 >= var_67);
    if (var_68) {
        // parent_tf = body_q[parent_body]                                                    <L 610>
        var_69 = wp::address(var_body_q, var_43);
        var_71 = wp::load(var_69);
        var_70 = wp::copy(var_71);
        // world_pos = wp.transform_point(parent_tf, joint_pos)                               <L 612>
        var_72 = wp::transform_point(var_70, var_65);
        // world_rot = wp.mul(wp.transform_get_rotation(parent_tf), joint_rot)                <L 613>
        var_73 = wp::transform_get_rotation(var_70);
        var_74 = wp::mul(var_73, var_66);
        // parent_body_world = body_world[parent_body]                                        <L 615>
        var_75 = wp::address(var_body_world, var_43);
        var_77 = wp::load(var_75);
        var_76 = wp::copy(var_77);
        // if world_offsets and parent_body_world >= 0:                                       <L 616>
        var_78 = var_world_offsets;
        if (var_78) {
            var_80 = (var_76 >= var_79);
            var_78 = var_78 && var_80;
        }
        if (var_78) {
            // world_pos += world_offsets[parent_body_world]                                  <L 617>
            var_81 = wp::address(var_world_offsets, var_76);
            var_83 = wp::load(var_81);
            var_82 = wp::add(var_72, var_83);
        }
        var_84 = wp::where(var_78, var_82, var_72);
    }
    if (!var_68) {
        // world_pos = joint_pos                                                              <L 619>
        var_85 = wp::copy(var_65);
        // world_rot = joint_rot                                                              <L 620>
        var_86 = wp::copy(var_66);
    }
    var_87 = wp::where(var_68, var_84, var_85);
    var_88 = wp::where(var_68, var_74, var_86);
    // world_pos = wp.transform_point(layer_xform, world_pos)                                 <L 623>
    var_89 = wp::transform_point(var_layer_xform, var_87);
    // world_rot = wp.mul(wp.transform_get_rotation(layer_xform), world_rot)                  <L 624>
    var_90 = wp::transform_get_rotation(var_layer_xform);
    var_91 = wp::mul(var_90, var_88);
    // scale_factor = line_scale                                                              <L 627>
    var_92 = wp::copy(var_line_scale);
    // if axis_id == 0:  # X-axis (red)                                                       <L 630>
    var_94 = (var_15 == var_93);
    if (var_94) {
        // axis_vec = wp.quat_rotate(world_rot, wp.vec3(1.0, 0.0, 0.0))                       <L 631>
        var_98 = wp::vec_t<3, wp::float32>(var_95, var_96, var_97);
        var_99 = wp::quat_rotate(var_91, var_98);
        // color = wp.vec3(1.0, 0.0, 0.0)                                                     <L 632>
        var_103 = wp::vec_t<3, wp::float32>(var_100, var_101, var_102);
    }
    if (!var_94) {
        // elif axis_id == 1:  # Y-axis (green)                                               <L 633>
        var_105 = (var_15 == var_104);
        if (var_105) {
            // axis_vec = wp.quat_rotate(world_rot, wp.vec3(0.0, 1.0, 0.0))                   <L 634>
            var_109 = wp::vec_t<3, wp::float32>(var_106, var_107, var_108);
            var_110 = wp::quat_rotate(var_91, var_109);
            // color = wp.vec3(0.0, 1.0, 0.0)                                                 <L 635>
            var_114 = wp::vec_t<3, wp::float32>(var_111, var_112, var_113);
        }
        if (!var_105) {
            // axis_vec = wp.quat_rotate(world_rot, wp.vec3(0.0, 0.0, 1.0))                   <L 637>
            var_118 = wp::vec_t<3, wp::float32>(var_115, var_116, var_117);
            var_119 = wp::quat_rotate(var_91, var_118);
            // color = wp.vec3(0.0, 0.0, 1.0)                                                 <L 638>
            var_123 = wp::vec_t<3, wp::float32>(var_120, var_121, var_122);
        }
        var_124 = wp::where(var_105, var_110, var_119);
        var_125 = wp::where(var_105, var_114, var_123);
    }
    var_126 = wp::where(var_94, var_99, var_124);
    var_127 = wp::where(var_94, var_103, var_125);
    // line_starts[tid] = world_pos                                                           <L 641>
    // wp::array_store(var_line_starts, var_0, var_89);
    // line_ends[tid] = world_pos + axis_vec * scale_factor                                   <L 642>
    var_128 = wp::mul(var_126, var_92);
    var_129 = wp::add(var_89, var_128);
    // wp::array_store(var_line_ends, var_0, var_129);
    // line_colors[tid] = color                                                               <L 643>
    // wp::array_store(var_line_colors, var_0, var_127);
    //---------
    // reverse
    wp::adj_array_store(var_line_colors, var_0, var_127, adj_line_colors, adj_0, adj_127);
    // adj: line_colors[tid] = color                                                          <L 643>
    wp::adj_array_store(var_line_ends, var_0, var_129, adj_line_ends, adj_0, adj_129);
    wp::adj_add(var_89, var_128, adj_89, adj_128, adj_129);
    wp::adj_mul(var_126, var_92, adj_126, adj_92, adj_128);
    // adj: line_ends[tid] = world_pos + axis_vec * scale_factor                              <L 642>
    wp::adj_array_store(var_line_starts, var_0, var_89, adj_line_starts, adj_0, adj_89);
    // adj: line_starts[tid] = world_pos                                                      <L 641>
    wp::adj_where(var_94, var_103, var_125, adj_94, adj_103, adj_125, adj_127);
    wp::adj_where(var_94, var_99, var_124, adj_94, adj_99, adj_124, adj_126);
    if (!var_94) {
        wp::adj_where(var_105, var_114, var_123, adj_105, adj_114, adj_123, adj_125);
        wp::adj_where(var_105, var_110, var_119, adj_105, adj_110, adj_119, adj_124);
        if (!var_105) {
            wp::adj_vec_t(var_120, var_121, var_122, adj_120, adj_121, adj_122, adj_123);
            // adj: color = wp.vec3(0.0, 0.0, 1.0)                                            <L 638>
            wp::adj_quat_rotate(var_91, var_118, adj_91, adj_118, adj_119);
            wp::adj_vec_t(var_115, var_116, var_117, adj_115, adj_116, adj_117, adj_118);
            // adj: axis_vec = wp.quat_rotate(world_rot, wp.vec3(0.0, 0.0, 1.0))              <L 637>
        }
        if (var_105) {
            wp::adj_vec_t(var_111, var_112, var_113, adj_111, adj_112, adj_113, adj_114);
            // adj: color = wp.vec3(0.0, 1.0, 0.0)                                            <L 635>
            wp::adj_quat_rotate(var_91, var_109, adj_91, adj_109, adj_110);
            wp::adj_vec_t(var_106, var_107, var_108, adj_106, adj_107, adj_108, adj_109);
            // adj: axis_vec = wp.quat_rotate(world_rot, wp.vec3(0.0, 1.0, 0.0))              <L 634>
        }
        // adj: elif axis_id == 1:  # Y-axis (green)                                          <L 633>
    }
    if (var_94) {
        wp::adj_vec_t(var_100, var_101, var_102, adj_100, adj_101, adj_102, adj_103);
        // adj: color = wp.vec3(1.0, 0.0, 0.0)                                                <L 632>
        wp::adj_quat_rotate(var_91, var_98, adj_91, adj_98, adj_99);
        wp::adj_vec_t(var_95, var_96, var_97, adj_95, adj_96, adj_97, adj_98);
        // adj: axis_vec = wp.quat_rotate(world_rot, wp.vec3(1.0, 0.0, 0.0))                  <L 631>
    }
    // adj: if axis_id == 0:  # X-axis (red)                                                  <L 630>
    wp::adj_copy(var_line_scale, adj_line_scale, adj_92);
    // adj: scale_factor = line_scale                                                         <L 627>
    wp::adj_mul(var_90, var_88, adj_90, adj_88, adj_91);
    wp::adj_transform_get_rotation(var_layer_xform, adj_layer_xform, adj_90);
    // adj: world_rot = wp.mul(wp.transform_get_rotation(layer_xform), world_rot)             <L 624>
    wp::adj_transform_point(var_layer_xform, var_87, adj_layer_xform, adj_87, adj_89);
    // adj: world_pos = wp.transform_point(layer_xform, world_pos)                            <L 623>
    wp::adj_where(var_68, var_74, var_86, adj_68, adj_74, adj_86, adj_88);
    wp::adj_where(var_68, var_84, var_85, adj_68, adj_84, adj_85, adj_87);
    if (!var_68) {
        wp::adj_copy(var_66, adj_66, adj_86);
        // adj: world_rot = joint_rot                                                         <L 620>
        wp::adj_copy(var_65, adj_65, adj_85);
        // adj: world_pos = joint_pos                                                         <L 619>
    }
    if (var_68) {
        wp::adj_where(var_78, var_82, var_72, adj_78, adj_82, adj_72, adj_84);
        if (var_78) {
            wp::adj_add(var_72, var_83, adj_72, adj_81, adj_82);
            wp::adj_address(var_world_offsets, var_76, adj_world_offsets, adj_76, adj_81);
            // adj: world_pos += world_offsets[parent_body_world]                             <L 617>
        }
        if (var_78) {
        }
        // adj: if world_offsets and parent_body_world >= 0:                                  <L 616>
        wp::adj_copy(var_77, adj_75, adj_76);
        wp::adj_address(var_body_world, var_43, adj_body_world, adj_43, adj_75);
        // adj: parent_body_world = body_world[parent_body]                                   <L 615>
        wp::adj_mul(var_73, var_66, adj_73, adj_66, adj_74);
        wp::adj_transform_get_rotation(var_70, adj_70, adj_73);
        // adj: world_rot = wp.mul(wp.transform_get_rotation(parent_tf), joint_rot)           <L 613>
        wp::adj_transform_point(var_70, var_65, adj_70, adj_65, adj_72);
        // adj: world_pos = wp.transform_point(parent_tf, joint_pos)                          <L 612>
        wp::adj_copy(var_71, adj_69, adj_70);
        wp::adj_address(var_body_q, var_43, adj_body_q, adj_43, adj_69);
        // adj: parent_tf = body_q[parent_body]                                               <L 610>
    }
    // adj: if parent_body >= 0:                                                              <L 609>
    wp::adj_transform_get_rotation(var_63, adj_63, adj_66);
    // adj: joint_rot = wp.transform_get_rotation(joint_tf)                                   <L 606>
    wp::adj_transform_get_translation(var_63, adj_63, adj_65);
    // adj: joint_pos = wp.transform_get_translation(joint_tf)                                <L 605>
    wp::adj_copy(var_64, adj_62, adj_63);
    wp::adj_address(var_joint_transform, var_13, adj_joint_transform, adj_13, adj_62);
    // adj: joint_tf = joint_transform[joint_id]                                              <L 604>
    if (var_visible_worlds_mask) {
        if (var_52) {
            if (var_57) {
                if (var_60) {
                    label2:;
                    // adj: return                                                            <L 601>
                    wp::adj_array_store(var_line_colors, var_0, var_11, adj_line_colors, adj_0, adj_11);
                    // adj: line_colors[tid] = zero_color                                     <L 600>
                    wp::adj_array_store(var_line_ends, var_0, var_7, adj_line_ends, adj_0, adj_7);
                    // adj: line_ends[tid] = nan_line                                         <L 599>
                    wp::adj_array_store(var_line_starts, var_0, var_7, adj_line_starts, adj_0, adj_7);
                    // adj: line_starts[tid] = nan_line                                       <L 598>
                }
                wp::adj_address(var_visible_worlds_mask, var_54, adj_visible_worlds_mask, adj_54, adj_58);
                // adj: if visible_worlds_mask[world_idx] == 0:                               <L 597>
            }
            // adj: if world_idx >= 0:                                                        <L 596>
            wp::adj_copy(var_55, adj_53, adj_54);
            wp::adj_address(var_body_world, var_50, adj_body_world, adj_50, adj_53);
            // adj: world_idx = body_world[filter_body]                                       <L 595>
        }
        // adj: if filter_body >= 0:                                                          <L 594>
    }
    // adj: if visible_worlds_mask:                                                           <L 593>
    wp::adj_where(var_49, var_43, var_46, adj_49, adj_43, adj_46, adj_50);
    if (!var_49) {
    }
    if (var_49) {
    }
    // adj: filter_body = parent_body if parent_body >= 0 else child_body                     <L 592>
    wp::adj_copy(var_47, adj_45, adj_46);
    wp::adj_address(var_joint_child, var_13, adj_joint_child, adj_13, adj_45);
    // adj: child_body = joint_child[joint_id]                                                <L 591>
    wp::adj_copy(var_44, adj_42, adj_43);
    wp::adj_address(var_joint_parent, var_13, adj_joint_parent, adj_13, adj_42);
    // adj: parent_body = joint_parent[joint_id]                                              <L 590>
    if (var_21) {
        label1:;
        // adj: return                                                                        <L 587>
        wp::adj_array_store(var_line_colors, var_0, var_11, adj_line_colors, adj_0, adj_11);
        // adj: line_colors[tid] = zero_color                                                 <L 586>
        wp::adj_array_store(var_line_ends, var_0, var_7, adj_line_ends, adj_0, adj_7);
        // adj: line_ends[tid] = nan_line                                                     <L 585>
        wp::adj_array_store(var_line_starts, var_0, var_7, adj_line_starts, adj_0, adj_7);
        // adj: line_starts[tid] = nan_line                                                   <L 584>
    }
    if (var_21) {
        // adj: and joint_t != int(newton.JointType.BALL)                                     <L 581>
    }
    if (var_21) {
        // adj: and joint_t != int(newton.JointType.CABLE)                                    <L 580>
    }
    if (var_21) {
        // adj: and joint_t != int(newton.JointType.D6)                                       <L 579>
    }
    if (var_21) {
        // adj: and joint_t != int(newton.JointType.REVOLUTE)                                 <L 578>
    }
    // adj: joint_t != int(newton.JointType.PRISMATIC)                                        <L 577>
    // adj: if (                                                                              <L 576>
    wp::adj_copy(var_20, adj_18, adj_19);
    wp::adj_address(var_joint_type, var_13, adj_joint_type, adj_13, adj_18);
    // adj: joint_t = joint_type[joint_id]                                                    <L 575>
    if (var_17) {
        label0:;
        // adj: return                                                                        <L 573>
        wp::adj_array_store(var_line_colors, var_0, var_11, adj_line_colors, adj_0, adj_11);
        // adj: line_colors[tid] = zero_color                                                 <L 572>
        wp::adj_array_store(var_line_ends, var_0, var_7, adj_line_ends, adj_0, adj_7);
        // adj: line_ends[tid] = nan_line                                                     <L 571>
        wp::adj_array_store(var_line_starts, var_0, var_7, adj_line_starts, adj_0, adj_7);
        // adj: line_starts[tid] = nan_line                                                   <L 570>
    }
    // adj: if joint_id >= len(joint_type):                                                   <L 569>
    wp::adj_mod(var_0, var_14, adj_0, adj_14, adj_15);
    // adj: axis_id = tid % 3                                                                 <L 566>
    // adj: joint_id = tid // 3                                                               <L 565>
    wp::adj_vec_t(var_8, var_9, var_10, adj_8, adj_9, adj_10, adj_11);
    // adj: zero_color = wp.vec3(0.0, 0.0, 0.0)                                               <L 562>
    wp::adj_vec_t(var_2, var_4, var_6, adj_2, adj_4, adj_6, adj_7);
    // adj: nan_line = wp.vec3(wp.nan, wp.nan, wp.nan)                                        <L 561>
    // adj: tid = wp.tid()                                                                    <L 560>
    // adj: def compute_joint_basis_lines(                                                    <L 538>
    return;
}



extern "C" {

// Python CPU entry points
WP_API void compute_joint_basis_lines_7ba0414f_cpu_forward(
    wp::launch_bounds_t<1> *dim,
    wp_args_compute_joint_basis_lines_7ba0414f *_wp_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        compute_joint_basis_lines_7ba0414f_cpu_kernel_forward(*dim, task_index, _wp_args);
    }
}

} // extern C



extern "C" {

WP_API void compute_joint_basis_lines_7ba0414f_cpu_backward(
    wp::launch_bounds_t<1> *dim,
    wp_args_compute_joint_basis_lines_7ba0414f *_wp_args,
    wp_args_compute_joint_basis_lines_7ba0414f *_wp_adj_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        compute_joint_basis_lines_7ba0414f_cpu_kernel_backward(*dim, task_index, _wp_args, _wp_adj_args);
    }
}

} // extern C

struct wp_args_apply_picking_force_kernel_bf43a933 {
    wp::array_t<wp::transform_t<wp::float32>> body_q;
    wp::array_t<wp::vec_t<6, wp::float32>> body_qd;
    wp::array_t<wp::vec_t<6, wp::float32>> body_f;
    wp::array_t<wp::int32> pick_body_arr;
    wp::array_t<PickingState_096ac041> pick_state;
    wp::array_t<wp::int32> body_flags;
    wp::array_t<wp::vec_t<3, wp::float32>> body_com;
    wp::array_t<wp::float32> body_mass;
    wp::array_t<wp::mat_t<3, 3, wp::float32>> body_inv_inertia;
    wp::array_t<wp::float32> pick_effective_mass;
};


void apply_picking_force_kernel_bf43a933_cpu_kernel_forward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_apply_picking_force_kernel_bf43a933 *_wp_args)
{
    //---------
    // argument vars
    wp::array_t<wp::transform_t<wp::float32>> var_body_q = _wp_args->body_q;
    wp::array_t<wp::vec_t<6, wp::float32>> var_body_qd = _wp_args->body_qd;
    wp::array_t<wp::vec_t<6, wp::float32>> var_body_f = _wp_args->body_f;
    wp::array_t<wp::int32> var_pick_body_arr = _wp_args->pick_body_arr;
    wp::array_t<PickingState_096ac041> var_pick_state = _wp_args->pick_state;
    wp::array_t<wp::int32> var_body_flags = _wp_args->body_flags;
    wp::array_t<wp::vec_t<3, wp::float32>> var_body_com = _wp_args->body_com;
    wp::array_t<wp::float32> var_body_mass = _wp_args->body_mass;
    wp::array_t<wp::mat_t<3, 3, wp::float32>> var_body_inv_inertia = _wp_args->body_inv_inertia;
    wp::array_t<wp::float32> var_pick_effective_mass = _wp_args->pick_effective_mass;
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    wp::int32* var_1;
    wp::int32 var_2;
    wp::int32 var_3;
    const wp::int32 var_4 = 0;
    bool var_5;
    wp::int32* var_6;
    const wp::int32 var_7 = 2;
    wp::int32 var_8;
    wp::int32 var_9;
    const wp::int32 var_10 = 0;
    PickingState_096ac041* var_11;
    wp::vec_t<3, wp::float32>* var_12;
    wp::vec_t<3, wp::float32> var_13;
    wp::vec_t<3, wp::float32> var_14;
    const wp::int32 var_15 = 0;
    PickingState_096ac041* var_16;
    wp::vec_t<3, wp::float32>* var_17;
    wp::vec_t<3, wp::float32> var_18;
    wp::vec_t<3, wp::float32> var_19;
    wp::transform_t<wp::float32>* var_20;
    wp::transform_t<wp::float32> var_21;
    wp::transform_t<wp::float32> var_22;
    wp::vec_t<3, wp::float32> var_23;
    wp::vec_t<3, wp::float32>* var_24;
    wp::vec_t<3, wp::float32> var_25;
    wp::vec_t<3, wp::float32> var_26;
    const wp::int32 var_27 = 0;
    wp::vec_t<3, wp::float32> var_28;
    wp::vec_t<6, wp::float32>* var_29;
    wp::vec_t<3, wp::float32> var_30;
    wp::vec_t<6, wp::float32> var_31;
    const wp::float32 var_32 = 10.0;
    wp::float32* var_33;
    wp::float32 var_34;
    wp::float32 var_35;
    const wp::int32 var_36 = 0;
    PickingState_096ac041* var_37;
    wp::float32* var_38;
    wp::vec_t<3, wp::float32> var_39;
    wp::vec_t<3, wp::float32> var_40;
    wp::float32 var_41;
    const wp::int32 var_42 = 0;
    PickingState_096ac041* var_43;
    wp::float32* var_44;
    wp::vec_t<3, wp::float32> var_45;
    wp::float32 var_46;
    wp::vec_t<3, wp::float32> var_47;
    wp::vec_t<3, wp::float32> var_48;
    const wp::int32 var_49 = 0;
    PickingState_096ac041* var_50;
    wp::float32* var_51;
    const wp::float32 var_52 = 9.81;
    wp::float32 var_53;
    wp::float32 var_54;
    wp::float32* var_55;
    wp::float32 var_56;
    wp::float32 var_57;
    wp::float32 var_58;
    bool var_59;
    wp::float32 var_60;
    wp::vec_t<3, wp::float32> var_61;
    wp::vec_t<3, wp::float32> var_62;
    wp::vec_t<3, wp::float32> var_63;
    wp::float32* var_64;
    wp::float32 var_65;
    wp::float32 var_66;
    const wp::float32 var_67 = 0.0;
    bool var_68;
    wp::quat_t<wp::float32> var_69;
    wp::vec_t<3, wp::float32> var_70;
    wp::mat_t<3, 3, wp::float32>* var_71;
    wp::vec_t<3, wp::float32> var_72;
    wp::mat_t<3, 3, wp::float32> var_73;
    wp::float32 var_74;
    wp::float32 var_75;
    bool var_76;
    bool var_77;
    const wp::float32 var_78 = 0.0;
    wp::vec_t<3, wp::float32> var_79;
    wp::float32 var_80;
    bool var_81;
    wp::float32 var_82;
    wp::float32 var_83;
    wp::vec_t<3, wp::float32> var_84;
    wp::vec_t<3, wp::float32> var_85;
    wp::vec_t<3, wp::float32> var_86;
    wp::vec_t<3, wp::float32> var_87;
    wp::vec_t<6, wp::float32> var_88;
    wp::vec_t<6, wp::float32> var_89;
    //---------
    // forward
    // def apply_picking_force_kernel(                                                        <L 63>
    // pick_body = pick_body_arr[0]                                                           <L 75>
    var_1 = wp::address(var_pick_body_arr, var_0);
    var_3 = wp::load(var_1);
    var_2 = wp::copy(var_3);
    // if pick_body < 0:                                                                      <L 76>
    var_5 = (var_2 < var_4);
    if (var_5) {
        // return                                                                             <L 77>
        return;
    }
    // if body_flags[pick_body] & newton.BodyFlags.KINEMATIC:                                 <L 78>
    var_6 = wp::address(var_body_flags, var_2);
    var_9 = wp::load(var_6);
    var_8 = wp::bit_and(var_9, var_7);
    if (var_8) {
        // return                                                                             <L 79>
        return;
    }
    // pick_pos_local = pick_state[0].picked_point_local                                      <L 81>
    var_11 = wp::address(var_pick_state, var_10);
    var_12 = &(((*wp::address(var_pick_state, var_10))).picked_point_local);
    var_14 = wp::load(var_12);
    var_13 = wp::copy(var_14);
    // pick_target_world = pick_state[0].picking_target_world                                 <L 82>
    var_16 = wp::address(var_pick_state, var_15);
    var_17 = &(((*wp::address(var_pick_state, var_15))).picking_target_world);
    var_19 = wp::load(var_17);
    var_18 = wp::copy(var_19);
    // X_wb = body_q[pick_body]                                                               <L 85>
    var_20 = wp::address(var_body_q, var_2);
    var_22 = wp::load(var_20);
    var_21 = wp::copy(var_22);
    // pick_pos_world = wp.transform_point(X_wb, pick_pos_local)                              <L 86>
    var_23 = wp::transform_point(var_21, var_13);
    // com_world = wp.transform_point(X_wb, body_com[pick_body])                              <L 87>
    var_24 = wp::address(var_body_com, var_2);
    var_26 = wp::load(var_24);
    var_25 = wp::transform_point(var_21, var_26);
    // pick_state[0].picked_point_world = pick_pos_world                                      <L 90>
    wp::index(var_pick_state, var_27).picked_point_world = var_23;
    // offset = pick_pos_world - com_world                                                    <L 92>
    var_28 = wp::sub(var_23, var_25);
    // pick_vel = velocity_at_point(body_qd[pick_body], offset)                               <L 93>
    var_29 = wp::address(var_body_qd, var_2);
    var_31 = wp::load(var_29);
    var_30 = velocity_at_point_1(var_31, var_28);
    // force_multiplier = 10.0 + body_mass[pick_body]                                         <L 96>
    var_33 = wp::address(var_body_mass, var_2);
    var_35 = wp::load(var_33);
    var_34 = wp::add(var_32, var_35);
    // pick_force = force_multiplier * (                                                      <L 98>
    // pick_state[0].pick_stiffness * (pick_target_world - pick_pos_world) - (pick_state[0].pick_damping * pick_vel)       <L 99>
    var_37 = wp::address(var_pick_state, var_36);
    var_38 = &(((*wp::address(var_pick_state, var_36))).pick_stiffness);
    var_39 = wp::sub(var_18, var_23);
    var_41 = wp::load(var_38);
    var_40 = wp::mul(var_41, var_39);
    var_43 = wp::address(var_pick_state, var_42);
    var_44 = &(((*wp::address(var_pick_state, var_42))).pick_damping);
    var_46 = wp::load(var_44);
    var_45 = wp::mul(var_46, var_30);
    var_47 = wp::sub(var_40, var_45);
    var_48 = wp::mul(var_34, var_47);
    // max_acceleration = pick_state[0].pick_max_acceleration * 9.81                          <L 106>
    var_50 = wp::address(var_pick_state, var_49);
    var_51 = &(((*wp::address(var_pick_state, var_49))).pick_max_acceleration);
    var_54 = wp::load(var_51);
    var_53 = wp::mul(var_54, var_52);
    // max_force = max_acceleration * pick_effective_mass[pick_body]                          <L 107>
    var_55 = wp::address(var_pick_effective_mass, var_2);
    var_57 = wp::load(var_55);
    var_56 = wp::mul(var_53, var_57);
    // force_mag = wp.length(pick_force)                                                      <L 108>
    var_58 = wp::length(var_48);
    // if force_mag > max_force:                                                              <L 109>
    var_59 = (var_58 > var_56);
    if (var_59) {
        // pick_force = pick_force * (max_force / force_mag)                                  <L 110>
        var_60 = wp::div(var_56, var_58);
        var_61 = wp::mul(var_48, var_60);
    }
    var_62 = wp::where(var_59, var_61, var_48);
    // pick_torque = wp.cross(offset, pick_force)                                             <L 112>
    var_63 = wp::cross(var_28, var_62);
    // mass = body_mass[pick_body]                                                            <L 116>
    var_64 = wp::address(var_body_mass, var_2);
    var_66 = wp::load(var_64);
    var_65 = wp::copy(var_66);
    // if mass > 0.0:                                                                         <L 117>
    var_68 = (var_65 > var_67);
    if (var_68) {
        // body_rotation = wp.transform_get_rotation(X_wb)                                    <L 118>
        var_69 = wp::transform_get_rotation(var_21);
        // torque_body = wp.quat_rotate_inv(body_rotation, pick_torque)                       <L 119>
        var_70 = wp::quat_rotate_inv(var_69, var_63);
        // angular_acceleration_body = body_inv_inertia[pick_body] * torque_body              <L 120>
        var_71 = wp::address(var_body_inv_inertia, var_2);
        var_73 = wp::load(var_71);
        var_72 = wp::mul(var_73, var_70);
        // rotational_acceleration_sq = wp.dot(torque_body, angular_acceleration_body) / mass       <L 121>
        var_74 = wp::dot(var_70, var_72);
        var_75 = wp::div(var_74, var_65);
        // if not wp.isfinite(rotational_acceleration_sq):                                    <L 122>
        var_76 = wp::isfinite(var_75);
        var_77 = wp::unot(var_76);
        if (var_77) {
            // pick_torque = wp.vec3(0.0)                                                     <L 123>
            var_79 = wp::vec_t<3, wp::float32>(var_78);
        }
        if (!var_77) {
            // elif rotational_acceleration_sq > max_acceleration * max_acceleration:         <L 124>
            var_80 = wp::mul(var_53, var_53);
            var_81 = (var_75 > var_80);
            if (var_81) {
                // pick_torque = pick_torque * (max_acceleration / wp.sqrt(rotational_acceleration_sq))       <L 125>
                var_82 = wp::sqrt(var_75);
                var_83 = wp::div(var_53, var_82);
                var_84 = wp::mul(var_63, var_83);
            }
            var_85 = wp::where(var_81, var_84, var_63);
        }
        var_86 = wp::where(var_77, var_79, var_85);
    }
    var_87 = wp::where(var_68, var_86, var_63);
    // wp.atomic_add(body_f, pick_body, wp.spatial_vector(pick_force, pick_torque))           <L 127>
    var_88 = wp::vec_t<6, wp::float32>(var_62, var_87);
    var_89 = wp::atomic_add(var_body_f, var_2, var_88);
}



void apply_picking_force_kernel_bf43a933_cpu_kernel_backward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_apply_picking_force_kernel_bf43a933 *_wp_args,
    wp_args_apply_picking_force_kernel_bf43a933 *_wp_adj_args)
{
    //---------
    // argument vars
    wp::array_t<wp::transform_t<wp::float32>> var_body_q = _wp_args->body_q;
    wp::array_t<wp::vec_t<6, wp::float32>> var_body_qd = _wp_args->body_qd;
    wp::array_t<wp::vec_t<6, wp::float32>> var_body_f = _wp_args->body_f;
    wp::array_t<wp::int32> var_pick_body_arr = _wp_args->pick_body_arr;
    wp::array_t<PickingState_096ac041> var_pick_state = _wp_args->pick_state;
    wp::array_t<wp::int32> var_body_flags = _wp_args->body_flags;
    wp::array_t<wp::vec_t<3, wp::float32>> var_body_com = _wp_args->body_com;
    wp::array_t<wp::float32> var_body_mass = _wp_args->body_mass;
    wp::array_t<wp::mat_t<3, 3, wp::float32>> var_body_inv_inertia = _wp_args->body_inv_inertia;
    wp::array_t<wp::float32> var_pick_effective_mass = _wp_args->pick_effective_mass;
    wp::array_t<wp::transform_t<wp::float32>> adj_body_q = _wp_adj_args->body_q;
    wp::array_t<wp::vec_t<6, wp::float32>> adj_body_qd = _wp_adj_args->body_qd;
    wp::array_t<wp::vec_t<6, wp::float32>> adj_body_f = _wp_adj_args->body_f;
    wp::array_t<wp::int32> adj_pick_body_arr = _wp_adj_args->pick_body_arr;
    wp::array_t<PickingState_096ac041> adj_pick_state = _wp_adj_args->pick_state;
    wp::array_t<wp::int32> adj_body_flags = _wp_adj_args->body_flags;
    wp::array_t<wp::vec_t<3, wp::float32>> adj_body_com = _wp_adj_args->body_com;
    wp::array_t<wp::float32> adj_body_mass = _wp_adj_args->body_mass;
    wp::array_t<wp::mat_t<3, 3, wp::float32>> adj_body_inv_inertia = _wp_adj_args->body_inv_inertia;
    wp::array_t<wp::float32> adj_pick_effective_mass = _wp_adj_args->pick_effective_mass;
    //---------
    // primal vars
    const wp::int32 var_0 = 0;
    wp::int32* var_1;
    wp::int32 var_2;
    wp::int32 var_3;
    const wp::int32 var_4 = 0;
    bool var_5;
    wp::int32* var_6;
    const wp::int32 var_7 = 2;
    wp::int32 var_8;
    wp::int32 var_9;
    const wp::int32 var_10 = 0;
    PickingState_096ac041* var_11;
    wp::vec_t<3, wp::float32>* var_12;
    wp::vec_t<3, wp::float32> var_13;
    wp::vec_t<3, wp::float32> var_14;
    const wp::int32 var_15 = 0;
    PickingState_096ac041* var_16;
    wp::vec_t<3, wp::float32>* var_17;
    wp::vec_t<3, wp::float32> var_18;
    wp::vec_t<3, wp::float32> var_19;
    wp::transform_t<wp::float32>* var_20;
    wp::transform_t<wp::float32> var_21;
    wp::transform_t<wp::float32> var_22;
    wp::vec_t<3, wp::float32> var_23;
    wp::vec_t<3, wp::float32>* var_24;
    wp::vec_t<3, wp::float32> var_25;
    wp::vec_t<3, wp::float32> var_26;
    const wp::int32 var_27 = 0;
    wp::vec_t<3, wp::float32> var_28;
    wp::vec_t<6, wp::float32>* var_29;
    wp::vec_t<3, wp::float32> var_30;
    wp::vec_t<6, wp::float32> var_31;
    const wp::float32 var_32 = 10.0;
    wp::float32* var_33;
    wp::float32 var_34;
    wp::float32 var_35;
    const wp::int32 var_36 = 0;
    PickingState_096ac041* var_37;
    wp::float32* var_38;
    wp::vec_t<3, wp::float32> var_39;
    wp::vec_t<3, wp::float32> var_40;
    wp::float32 var_41;
    const wp::int32 var_42 = 0;
    PickingState_096ac041* var_43;
    wp::float32* var_44;
    wp::vec_t<3, wp::float32> var_45;
    wp::float32 var_46;
    wp::vec_t<3, wp::float32> var_47;
    wp::vec_t<3, wp::float32> var_48;
    const wp::int32 var_49 = 0;
    PickingState_096ac041* var_50;
    wp::float32* var_51;
    const wp::float32 var_52 = 9.81;
    wp::float32 var_53;
    wp::float32 var_54;
    wp::float32* var_55;
    wp::float32 var_56;
    wp::float32 var_57;
    wp::float32 var_58;
    bool var_59;
    wp::float32 var_60;
    wp::vec_t<3, wp::float32> var_61;
    wp::vec_t<3, wp::float32> var_62;
    wp::vec_t<3, wp::float32> var_63;
    wp::float32* var_64;
    wp::float32 var_65;
    wp::float32 var_66;
    const wp::float32 var_67 = 0.0;
    bool var_68;
    wp::quat_t<wp::float32> var_69;
    wp::vec_t<3, wp::float32> var_70;
    wp::mat_t<3, 3, wp::float32>* var_71;
    wp::vec_t<3, wp::float32> var_72;
    wp::mat_t<3, 3, wp::float32> var_73;
    wp::float32 var_74;
    wp::float32 var_75;
    bool var_76;
    bool var_77;
    const wp::float32 var_78 = 0.0;
    wp::vec_t<3, wp::float32> var_79;
    wp::float32 var_80;
    bool var_81;
    wp::float32 var_82;
    wp::float32 var_83;
    wp::vec_t<3, wp::float32> var_84;
    wp::vec_t<3, wp::float32> var_85;
    wp::vec_t<3, wp::float32> var_86;
    wp::vec_t<3, wp::float32> var_87;
    wp::vec_t<6, wp::float32> var_88;
    wp::vec_t<6, wp::float32> var_89;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    wp::int32 adj_1 = {};
    wp::int32 adj_2 = {};
    wp::int32 adj_3 = {};
    wp::int32 adj_4 = {};
    bool adj_5 = {};
    wp::int32 adj_6 = {};
    wp::int32 adj_7 = {};
    wp::int32 adj_8 = {};
    wp::int32 adj_9 = {};
    wp::int32 adj_10 = {};
    PickingState_096ac041 adj_11 = {};
    wp::vec_t<3, wp::float32> adj_12 = {};
    wp::vec_t<3, wp::float32> adj_13 = {};
    wp::vec_t<3, wp::float32> adj_14 = {};
    wp::int32 adj_15 = {};
    PickingState_096ac041 adj_16 = {};
    wp::vec_t<3, wp::float32> adj_17 = {};
    wp::vec_t<3, wp::float32> adj_18 = {};
    wp::vec_t<3, wp::float32> adj_19 = {};
    wp::transform_t<wp::float32> adj_20 = {};
    wp::transform_t<wp::float32> adj_21 = {};
    wp::transform_t<wp::float32> adj_22 = {};
    wp::vec_t<3, wp::float32> adj_23 = {};
    wp::vec_t<3, wp::float32> adj_24 = {};
    wp::vec_t<3, wp::float32> adj_25 = {};
    wp::vec_t<3, wp::float32> adj_26 = {};
    wp::int32 adj_27 = {};
    wp::vec_t<3, wp::float32> adj_28 = {};
    wp::vec_t<6, wp::float32> adj_29 = {};
    wp::vec_t<3, wp::float32> adj_30 = {};
    wp::vec_t<6, wp::float32> adj_31 = {};
    wp::float32 adj_32 = {};
    wp::float32 adj_33 = {};
    wp::float32 adj_34 = {};
    wp::float32 adj_35 = {};
    wp::int32 adj_36 = {};
    PickingState_096ac041 adj_37 = {};
    wp::float32 adj_38 = {};
    wp::vec_t<3, wp::float32> adj_39 = {};
    wp::vec_t<3, wp::float32> adj_40 = {};
    wp::float32 adj_41 = {};
    wp::int32 adj_42 = {};
    PickingState_096ac041 adj_43 = {};
    wp::float32 adj_44 = {};
    wp::vec_t<3, wp::float32> adj_45 = {};
    wp::float32 adj_46 = {};
    wp::vec_t<3, wp::float32> adj_47 = {};
    wp::vec_t<3, wp::float32> adj_48 = {};
    wp::int32 adj_49 = {};
    PickingState_096ac041 adj_50 = {};
    wp::float32 adj_51 = {};
    wp::float32 adj_52 = {};
    wp::float32 adj_53 = {};
    wp::float32 adj_54 = {};
    wp::float32 adj_55 = {};
    wp::float32 adj_56 = {};
    wp::float32 adj_57 = {};
    wp::float32 adj_58 = {};
    bool adj_59 = {};
    wp::float32 adj_60 = {};
    wp::vec_t<3, wp::float32> adj_61 = {};
    wp::vec_t<3, wp::float32> adj_62 = {};
    wp::vec_t<3, wp::float32> adj_63 = {};
    wp::float32 adj_64 = {};
    wp::float32 adj_65 = {};
    wp::float32 adj_66 = {};
    wp::float32 adj_67 = {};
    bool adj_68 = {};
    wp::quat_t<wp::float32> adj_69 = {};
    wp::vec_t<3, wp::float32> adj_70 = {};
    wp::mat_t<3, 3, wp::float32> adj_71 = {};
    wp::vec_t<3, wp::float32> adj_72 = {};
    wp::mat_t<3, 3, wp::float32> adj_73 = {};
    wp::float32 adj_74 = {};
    wp::float32 adj_75 = {};
    bool adj_76 = {};
    bool adj_77 = {};
    wp::float32 adj_78 = {};
    wp::vec_t<3, wp::float32> adj_79 = {};
    wp::float32 adj_80 = {};
    bool adj_81 = {};
    wp::float32 adj_82 = {};
    wp::float32 adj_83 = {};
    wp::vec_t<3, wp::float32> adj_84 = {};
    wp::vec_t<3, wp::float32> adj_85 = {};
    wp::vec_t<3, wp::float32> adj_86 = {};
    wp::vec_t<3, wp::float32> adj_87 = {};
    wp::vec_t<6, wp::float32> adj_88 = {};
    wp::vec_t<6, wp::float32> adj_89 = {};
    //---------
    // forward
    // def apply_picking_force_kernel(                                                        <L 63>
    // pick_body = pick_body_arr[0]                                                           <L 75>
    var_1 = wp::address(var_pick_body_arr, var_0);
    var_3 = wp::load(var_1);
    var_2 = wp::copy(var_3);
    // if pick_body < 0:                                                                      <L 76>
    var_5 = (var_2 < var_4);
    if (var_5) {
        // return                                                                             <L 77>
        goto label0;
    }
    // if body_flags[pick_body] & newton.BodyFlags.KINEMATIC:                                 <L 78>
    var_6 = wp::address(var_body_flags, var_2);
    var_9 = wp::load(var_6);
    var_8 = wp::bit_and(var_9, var_7);
    if (var_8) {
        // return                                                                             <L 79>
        goto label1;
    }
    // pick_pos_local = pick_state[0].picked_point_local                                      <L 81>
    var_11 = wp::address(var_pick_state, var_10);
    var_12 = &(((*wp::address(var_pick_state, var_10))).picked_point_local);
    var_14 = wp::load(var_12);
    var_13 = wp::copy(var_14);
    // pick_target_world = pick_state[0].picking_target_world                                 <L 82>
    var_16 = wp::address(var_pick_state, var_15);
    var_17 = &(((*wp::address(var_pick_state, var_15))).picking_target_world);
    var_19 = wp::load(var_17);
    var_18 = wp::copy(var_19);
    // X_wb = body_q[pick_body]                                                               <L 85>
    var_20 = wp::address(var_body_q, var_2);
    var_22 = wp::load(var_20);
    var_21 = wp::copy(var_22);
    // pick_pos_world = wp.transform_point(X_wb, pick_pos_local)                              <L 86>
    var_23 = wp::transform_point(var_21, var_13);
    // com_world = wp.transform_point(X_wb, body_com[pick_body])                              <L 87>
    var_24 = wp::address(var_body_com, var_2);
    var_26 = wp::load(var_24);
    var_25 = wp::transform_point(var_21, var_26);
    // pick_state[0].picked_point_world = pick_pos_world                                      <L 90>
    wp::index(var_pick_state, var_27).picked_point_world = var_23;
    // offset = pick_pos_world - com_world                                                    <L 92>
    var_28 = wp::sub(var_23, var_25);
    // pick_vel = velocity_at_point(body_qd[pick_body], offset)                               <L 93>
    var_29 = wp::address(var_body_qd, var_2);
    var_31 = wp::load(var_29);
    var_30 = velocity_at_point_1(var_31, var_28);
    // force_multiplier = 10.0 + body_mass[pick_body]                                         <L 96>
    var_33 = wp::address(var_body_mass, var_2);
    var_35 = wp::load(var_33);
    var_34 = wp::add(var_32, var_35);
    // pick_force = force_multiplier * (                                                      <L 98>
    // pick_state[0].pick_stiffness * (pick_target_world - pick_pos_world) - (pick_state[0].pick_damping * pick_vel)       <L 99>
    var_37 = wp::address(var_pick_state, var_36);
    var_38 = &(((*wp::address(var_pick_state, var_36))).pick_stiffness);
    var_39 = wp::sub(var_18, var_23);
    var_41 = wp::load(var_38);
    var_40 = wp::mul(var_41, var_39);
    var_43 = wp::address(var_pick_state, var_42);
    var_44 = &(((*wp::address(var_pick_state, var_42))).pick_damping);
    var_46 = wp::load(var_44);
    var_45 = wp::mul(var_46, var_30);
    var_47 = wp::sub(var_40, var_45);
    var_48 = wp::mul(var_34, var_47);
    // max_acceleration = pick_state[0].pick_max_acceleration * 9.81                          <L 106>
    var_50 = wp::address(var_pick_state, var_49);
    var_51 = &(((*wp::address(var_pick_state, var_49))).pick_max_acceleration);
    var_54 = wp::load(var_51);
    var_53 = wp::mul(var_54, var_52);
    // max_force = max_acceleration * pick_effective_mass[pick_body]                          <L 107>
    var_55 = wp::address(var_pick_effective_mass, var_2);
    var_57 = wp::load(var_55);
    var_56 = wp::mul(var_53, var_57);
    // force_mag = wp.length(pick_force)                                                      <L 108>
    var_58 = wp::length(var_48);
    // if force_mag > max_force:                                                              <L 109>
    var_59 = (var_58 > var_56);
    if (var_59) {
        // pick_force = pick_force * (max_force / force_mag)                                  <L 110>
        var_60 = wp::div(var_56, var_58);
        var_61 = wp::mul(var_48, var_60);
    }
    var_62 = wp::where(var_59, var_61, var_48);
    // pick_torque = wp.cross(offset, pick_force)                                             <L 112>
    var_63 = wp::cross(var_28, var_62);
    // mass = body_mass[pick_body]                                                            <L 116>
    var_64 = wp::address(var_body_mass, var_2);
    var_66 = wp::load(var_64);
    var_65 = wp::copy(var_66);
    // if mass > 0.0:                                                                         <L 117>
    var_68 = (var_65 > var_67);
    if (var_68) {
        // body_rotation = wp.transform_get_rotation(X_wb)                                    <L 118>
        var_69 = wp::transform_get_rotation(var_21);
        // torque_body = wp.quat_rotate_inv(body_rotation, pick_torque)                       <L 119>
        var_70 = wp::quat_rotate_inv(var_69, var_63);
        // angular_acceleration_body = body_inv_inertia[pick_body] * torque_body              <L 120>
        var_71 = wp::address(var_body_inv_inertia, var_2);
        var_73 = wp::load(var_71);
        var_72 = wp::mul(var_73, var_70);
        // rotational_acceleration_sq = wp.dot(torque_body, angular_acceleration_body) / mass       <L 121>
        var_74 = wp::dot(var_70, var_72);
        var_75 = wp::div(var_74, var_65);
        // if not wp.isfinite(rotational_acceleration_sq):                                    <L 122>
        var_76 = wp::isfinite(var_75);
        var_77 = wp::unot(var_76);
        if (var_77) {
            // pick_torque = wp.vec3(0.0)                                                     <L 123>
            var_79 = wp::vec_t<3, wp::float32>(var_78);
        }
        if (!var_77) {
            // elif rotational_acceleration_sq > max_acceleration * max_acceleration:         <L 124>
            var_80 = wp::mul(var_53, var_53);
            var_81 = (var_75 > var_80);
            if (var_81) {
                // pick_torque = pick_torque * (max_acceleration / wp.sqrt(rotational_acceleration_sq))       <L 125>
                var_82 = wp::sqrt(var_75);
                var_83 = wp::div(var_53, var_82);
                var_84 = wp::mul(var_63, var_83);
            }
            var_85 = wp::where(var_81, var_84, var_63);
        }
        var_86 = wp::where(var_77, var_79, var_85);
    }
    var_87 = wp::where(var_68, var_86, var_63);
    // wp.atomic_add(body_f, pick_body, wp.spatial_vector(pick_force, pick_torque))           <L 127>
    var_88 = wp::vec_t<6, wp::float32>(var_62, var_87);
    // var_89 = wp::atomic_add(var_body_f, var_2, var_88);
    //---------
    // reverse
    wp::adj_atomic_add(var_body_f, var_2, var_88, adj_body_f, adj_2, adj_88, adj_89);
    wp::adj_vec_t(var_62, var_87, adj_62, adj_87, adj_88);
    // adj: wp.atomic_add(body_f, pick_body, wp.spatial_vector(pick_force, pick_torque))      <L 127>
    wp::adj_where(var_68, var_86, var_63, adj_68, adj_86, adj_63, adj_87);
    if (var_68) {
        wp::adj_where(var_77, var_79, var_85, adj_77, adj_79, adj_85, adj_86);
        if (!var_77) {
            wp::adj_where(var_81, var_84, var_63, adj_81, adj_84, adj_63, adj_85);
            if (var_81) {
                wp::adj_mul(var_63, var_83, adj_63, adj_83, adj_84);
                wp::adj_div(var_53, var_82, var_83, adj_53, adj_82, adj_83);
                wp::adj_sqrt(var_75, var_82, adj_75, adj_82);
                // adj: pick_torque = pick_torque * (max_acceleration / wp.sqrt(rotational_acceleration_sq))  <L 125>
            }
            wp::adj_mul(var_53, var_53, adj_53, adj_53, adj_80);
            // adj: elif rotational_acceleration_sq > max_acceleration * max_acceleration:    <L 124>
        }
        if (var_77) {
            wp::adj_vec_t(var_78, adj_78, adj_79);
            // adj: pick_torque = wp.vec3(0.0)                                                <L 123>
        }
        // adj: if not wp.isfinite(rotational_acceleration_sq):                               <L 122>
        wp::adj_div(var_74, var_65, var_75, adj_74, adj_65, adj_75);
        wp::adj_dot(var_70, var_72, adj_70, adj_72, adj_74);
        // adj: rotational_acceleration_sq = wp.dot(torque_body, angular_acceleration_body) / mass  <L 121>
        wp::adj_mul(var_73, var_70, adj_71, adj_70, adj_72);
        wp::adj_address(var_body_inv_inertia, var_2, adj_body_inv_inertia, adj_2, adj_71);
        // adj: angular_acceleration_body = body_inv_inertia[pick_body] * torque_body         <L 120>
        wp::adj_quat_rotate_inv(var_69, var_63, adj_69, adj_63, adj_70);
        // adj: torque_body = wp.quat_rotate_inv(body_rotation, pick_torque)                  <L 119>
        wp::adj_transform_get_rotation(var_21, adj_21, adj_69);
        // adj: body_rotation = wp.transform_get_rotation(X_wb)                               <L 118>
    }
    // adj: if mass > 0.0:                                                                    <L 117>
    wp::adj_copy(var_66, adj_64, adj_65);
    wp::adj_address(var_body_mass, var_2, adj_body_mass, adj_2, adj_64);
    // adj: mass = body_mass[pick_body]                                                       <L 116>
    wp::adj_cross(var_28, var_62, adj_28, adj_62, adj_63);
    // adj: pick_torque = wp.cross(offset, pick_force)                                        <L 112>
    wp::adj_where(var_59, var_61, var_48, adj_59, adj_61, adj_48, adj_62);
    if (var_59) {
        wp::adj_mul(var_48, var_60, adj_48, adj_60, adj_61);
        wp::adj_div(var_56, var_58, var_60, adj_56, adj_58, adj_60);
        // adj: pick_force = pick_force * (max_force / force_mag)                             <L 110>
    }
    // adj: if force_mag > max_force:                                                         <L 109>
    wp::adj_length(var_48, var_58, adj_48, adj_58);
    // adj: force_mag = wp.length(pick_force)                                                 <L 108>
    wp::adj_mul(var_53, var_57, adj_53, adj_55, adj_56);
    wp::adj_address(var_pick_effective_mass, var_2, adj_pick_effective_mass, adj_2, adj_55);
    // adj: max_force = max_acceleration * pick_effective_mass[pick_body]                     <L 107>
    wp::adj_mul(var_54, var_52, adj_51, adj_52, adj_53);
    adj_50.pick_max_acceleration += adj_51;
    wp::adj_address(var_pick_state, var_49, adj_pick_state, adj_49, adj_50);
    // adj: max_acceleration = pick_state[0].pick_max_acceleration * 9.81                     <L 106>
    wp::adj_mul(var_34, var_47, adj_34, adj_47, adj_48);
    wp::adj_sub(var_40, var_45, adj_40, adj_45, adj_47);
    wp::adj_mul(var_46, var_30, adj_44, adj_30, adj_45);
    adj_43.pick_damping += adj_44;
    wp::adj_address(var_pick_state, var_42, adj_pick_state, adj_42, adj_43);
    wp::adj_mul(var_41, var_39, adj_38, adj_39, adj_40);
    wp::adj_sub(var_18, var_23, adj_18, adj_23, adj_39);
    adj_37.pick_stiffness += adj_38;
    wp::adj_address(var_pick_state, var_36, adj_pick_state, adj_36, adj_37);
    // adj: pick_state[0].pick_stiffness * (pick_target_world - pick_pos_world) - (pick_state[0].pick_damping * pick_vel)  <L 99>
    // adj: pick_force = force_multiplier * (                                                 <L 98>
    wp::adj_add(var_32, var_35, adj_32, adj_33, adj_34);
    wp::adj_address(var_body_mass, var_2, adj_body_mass, adj_2, adj_33);
    // adj: force_multiplier = 10.0 + body_mass[pick_body]                                    <L 96>
    adj_velocity_at_point_1(var_31, var_28, adj_29, adj_28, adj_30);
    wp::adj_address(var_body_qd, var_2, adj_body_qd, adj_2, adj_29);
    // adj: pick_vel = velocity_at_point(body_qd[pick_body], offset)                          <L 93>
    wp::adj_sub(var_23, var_25, adj_23, adj_25, adj_28);
    // adj: offset = pick_pos_world - com_world                                               <L 92>
    wp::adj_array_store_slot(var_pick_state, adj_pick_state, adj_23, [&](auto& _e) -> auto& { return _e.picked_point_world; }, var_27);
    // adj: pick_state[0].picked_point_world = pick_pos_world                                 <L 90>
    wp::adj_transform_point(var_21, var_26, adj_21, adj_24, adj_25);
    wp::adj_address(var_body_com, var_2, adj_body_com, adj_2, adj_24);
    // adj: com_world = wp.transform_point(X_wb, body_com[pick_body])                         <L 87>
    wp::adj_transform_point(var_21, var_13, adj_21, adj_13, adj_23);
    // adj: pick_pos_world = wp.transform_point(X_wb, pick_pos_local)                         <L 86>
    wp::adj_copy(var_22, adj_20, adj_21);
    wp::adj_address(var_body_q, var_2, adj_body_q, adj_2, adj_20);
    // adj: X_wb = body_q[pick_body]                                                          <L 85>
    wp::adj_copy(var_19, adj_17, adj_18);
    adj_16.picking_target_world += adj_17;
    wp::adj_address(var_pick_state, var_15, adj_pick_state, adj_15, adj_16);
    // adj: pick_target_world = pick_state[0].picking_target_world                            <L 82>
    wp::adj_copy(var_14, adj_12, adj_13);
    adj_11.picked_point_local += adj_12;
    wp::adj_address(var_pick_state, var_10, adj_pick_state, adj_10, adj_11);
    // adj: pick_pos_local = pick_state[0].picked_point_local                                 <L 81>
    if (var_8) {
        label1:;
        // adj: return                                                                        <L 79>
    }
    wp::adj_address(var_body_flags, var_2, adj_body_flags, adj_2, adj_6);
    // adj: if body_flags[pick_body] & newton.BodyFlags.KINEMATIC:                            <L 78>
    if (var_5) {
        label0:;
        // adj: return                                                                        <L 77>
    }
    // adj: if pick_body < 0:                                                                 <L 76>
    wp::adj_copy(var_3, adj_1, adj_2);
    wp::adj_address(var_pick_body_arr, var_0, adj_pick_body_arr, adj_0, adj_1);
    // adj: pick_body = pick_body_arr[0]                                                      <L 75>
    // adj: def apply_picking_force_kernel(                                                   <L 63>
    return;
}



extern "C" {

// Python CPU entry points
WP_API void apply_picking_force_kernel_bf43a933_cpu_forward(
    wp::launch_bounds_t<1> *dim,
    wp_args_apply_picking_force_kernel_bf43a933 *_wp_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        apply_picking_force_kernel_bf43a933_cpu_kernel_forward(*dim, task_index, _wp_args);
    }
}

} // extern C



extern "C" {

WP_API void apply_picking_force_kernel_bf43a933_cpu_backward(
    wp::launch_bounds_t<1> *dim,
    wp_args_apply_picking_force_kernel_bf43a933 *_wp_args,
    wp_args_apply_picking_force_kernel_bf43a933 *_wp_adj_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        apply_picking_force_kernel_bf43a933_cpu_kernel_backward(*dim, task_index, _wp_args, _wp_adj_args);
    }
}

} // extern C

struct wp_args_estimate_world_extents_46771af7 {
    wp::array_t<wp::transform_t<wp::float32>> shape_transform;
    wp::array_t<wp::int32> shape_body;
    wp::array_t<wp::float32> shape_collision_radius;
    wp::array_t<wp::int32> shape_world;
    wp::array_t<wp::transform_t<wp::float32>> body_q;
    wp::int32 world_count;
    wp::array_t<wp::float32> world_bounds_min;
    wp::array_t<wp::float32> world_bounds_max;
};


void estimate_world_extents_46771af7_cpu_kernel_forward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_estimate_world_extents_46771af7 *_wp_args)
{
    //---------
    // argument vars
    wp::array_t<wp::transform_t<wp::float32>> var_shape_transform = _wp_args->shape_transform;
    wp::array_t<wp::int32> var_shape_body = _wp_args->shape_body;
    wp::array_t<wp::float32> var_shape_collision_radius = _wp_args->shape_collision_radius;
    wp::array_t<wp::int32> var_shape_world = _wp_args->shape_world;
    wp::array_t<wp::transform_t<wp::float32>> var_body_q = _wp_args->body_q;
    wp::int32 var_world_count = _wp_args->world_count;
    wp::array_t<wp::float32> var_world_bounds_min = _wp_args->world_bounds_min;
    wp::array_t<wp::float32> var_world_bounds_max = _wp_args->world_bounds_max;
    //---------
    // primal vars
    wp::int32 var_0;
    wp::int32* var_1;
    wp::int32 var_2;
    wp::int32 var_3;
    bool var_4;
    const wp::int32 var_5 = 0;
    bool var_6;
    bool var_7;
    wp::float32* var_8;
    wp::float32 var_9;
    wp::float32 var_10;
    const wp::float32 var_11 = 100000.0;
    bool var_12;
    wp::transform_t<wp::float32>* var_13;
    wp::transform_t<wp::float32> var_14;
    wp::transform_t<wp::float32> var_15;
    wp::int32* var_16;
    wp::int32 var_17;
    wp::int32 var_18;
    const wp::int32 var_19 = 0;
    bool var_20;
    wp::transform_t<wp::float32>* var_21;
    wp::transform_t<wp::float32> var_22;
    wp::transform_t<wp::float32> var_23;
    wp::transform_t<wp::float32> var_24;
    wp::transform_t<wp::float32> var_25;
    wp::transform_t<wp::float32> var_26;
    wp::vec_t<3, wp::float32> var_27;
    wp::float32* var_28;
    wp::float32 var_29;
    wp::float32 var_30;
    wp::vec_t<3, wp::float32> var_31;
    wp::vec_t<3, wp::float32> var_32;
    wp::vec_t<3, wp::float32> var_33;
    wp::vec_t<3, wp::float32> var_34;
    const wp::int32 var_35 = 0;
    const wp::int32 var_36 = 0;
    wp::float32 var_37;
    wp::float32 var_38;
    const wp::int32 var_39 = 1;
    const wp::int32 var_40 = 1;
    wp::float32 var_41;
    wp::float32 var_42;
    const wp::int32 var_43 = 2;
    const wp::int32 var_44 = 2;
    wp::float32 var_45;
    wp::float32 var_46;
    const wp::int32 var_47 = 0;
    const wp::int32 var_48 = 0;
    wp::float32 var_49;
    wp::float32 var_50;
    const wp::int32 var_51 = 1;
    const wp::int32 var_52 = 1;
    wp::float32 var_53;
    wp::float32 var_54;
    const wp::int32 var_55 = 2;
    const wp::int32 var_56 = 2;
    wp::float32 var_57;
    wp::float32 var_58;
    //---------
    // forward
    // def estimate_world_extents(                                                            <L 198>
    // tid = wp.tid()                                                                         <L 209>
    var_0 = builtin_tid1d();
    // world_idx = shape_world[tid]                                                           <L 212>
    var_1 = wp::address(var_shape_world, var_0);
    var_3 = wp::load(var_1);
    var_2 = wp::copy(var_3);
    // if world_idx < 0 or world_idx >= world_count:                                          <L 215>
    var_6 = (var_2 < var_5);
    var_4 = var_6;
    if (!var_4) {
        var_7 = (var_2 >= var_world_count);
        var_4 = var_4 || var_7;
    }
    if (var_4) {
        // return                                                                             <L 216>
        return;
    }
    // radius = shape_collision_radius[tid]                                                   <L 219>
    var_8 = wp::address(var_shape_collision_radius, var_0);
    var_10 = wp::load(var_8);
    var_9 = wp::copy(var_10);
    // if radius > 1.0e5:  # Skip outliers like infinite planes                               <L 220>
    var_12 = (var_9 > var_11);
    if (var_12) {
        // return                                                                             <L 221>
        return;
    }
    // shape_xform = shape_transform[tid]                                                     <L 224>
    var_13 = wp::address(var_shape_transform, var_0);
    var_15 = wp::load(var_13);
    var_14 = wp::copy(var_15);
    // shape_parent = shape_body[tid]                                                         <L 225>
    var_16 = wp::address(var_shape_body, var_0);
    var_18 = wp::load(var_16);
    var_17 = wp::copy(var_18);
    // if shape_parent >= 0:                                                                  <L 228>
    var_20 = (var_17 >= var_19);
    if (var_20) {
        // body_xform = body_q[shape_parent]                                                  <L 230>
        var_21 = wp::address(var_body_q, var_17);
        var_23 = wp::load(var_21);
        var_22 = wp::copy(var_23);
        // world_xform = wp.transform_multiply(body_xform, shape_xform)                       <L 231>
        var_24 = wp::transform_multiply(var_22, var_14);
    }
    if (!var_20) {
        // world_xform = shape_xform                                                          <L 234>
        var_25 = wp::copy(var_14);
    }
    var_26 = wp::where(var_20, var_24, var_25);
    // pos = wp.transform_get_translation(world_xform)                                        <L 237>
    var_27 = wp::transform_get_translation(var_26);
    // radius = shape_collision_radius[tid]                                                   <L 238>
    var_28 = wp::address(var_shape_collision_radius, var_0);
    var_30 = wp::load(var_28);
    var_29 = wp::copy(var_30);
    // min_pos = pos - wp.vec3(radius, radius, radius)                                        <L 241>
    var_31 = wp::vec_t<3, wp::float32>(var_29, var_29, var_29);
    var_32 = wp::sub(var_27, var_31);
    // max_pos = pos + wp.vec3(radius, radius, radius)                                        <L 242>
    var_33 = wp::vec_t<3, wp::float32>(var_29, var_29, var_29);
    var_34 = wp::add(var_27, var_33);
    // wp.atomic_min(world_bounds_min, world_idx, 0, min_pos[0])                              <L 245>
    var_37 = wp::extract(var_32, var_36);
    var_38 = wp::atomic_min(var_world_bounds_min, var_2, var_35, var_37);
    // wp.atomic_min(world_bounds_min, world_idx, 1, min_pos[1])                              <L 246>
    var_41 = wp::extract(var_32, var_40);
    var_42 = wp::atomic_min(var_world_bounds_min, var_2, var_39, var_41);
    // wp.atomic_min(world_bounds_min, world_idx, 2, min_pos[2])                              <L 247>
    var_45 = wp::extract(var_32, var_44);
    var_46 = wp::atomic_min(var_world_bounds_min, var_2, var_43, var_45);
    // wp.atomic_max(world_bounds_max, world_idx, 0, max_pos[0])                              <L 250>
    var_49 = wp::extract(var_34, var_48);
    var_50 = wp::atomic_max(var_world_bounds_max, var_2, var_47, var_49);
    // wp.atomic_max(world_bounds_max, world_idx, 1, max_pos[1])                              <L 251>
    var_53 = wp::extract(var_34, var_52);
    var_54 = wp::atomic_max(var_world_bounds_max, var_2, var_51, var_53);
    // wp.atomic_max(world_bounds_max, world_idx, 2, max_pos[2])                              <L 252>
    var_57 = wp::extract(var_34, var_56);
    var_58 = wp::atomic_max(var_world_bounds_max, var_2, var_55, var_57);
}



void estimate_world_extents_46771af7_cpu_kernel_backward(
    wp::launch_bounds_t<1> dim,
    size_t task_index,
    wp_args_estimate_world_extents_46771af7 *_wp_args,
    wp_args_estimate_world_extents_46771af7 *_wp_adj_args)
{
    //---------
    // argument vars
    wp::array_t<wp::transform_t<wp::float32>> var_shape_transform = _wp_args->shape_transform;
    wp::array_t<wp::int32> var_shape_body = _wp_args->shape_body;
    wp::array_t<wp::float32> var_shape_collision_radius = _wp_args->shape_collision_radius;
    wp::array_t<wp::int32> var_shape_world = _wp_args->shape_world;
    wp::array_t<wp::transform_t<wp::float32>> var_body_q = _wp_args->body_q;
    wp::int32 var_world_count = _wp_args->world_count;
    wp::array_t<wp::float32> var_world_bounds_min = _wp_args->world_bounds_min;
    wp::array_t<wp::float32> var_world_bounds_max = _wp_args->world_bounds_max;
    wp::array_t<wp::transform_t<wp::float32>> adj_shape_transform = _wp_adj_args->shape_transform;
    wp::array_t<wp::int32> adj_shape_body = _wp_adj_args->shape_body;
    wp::array_t<wp::float32> adj_shape_collision_radius = _wp_adj_args->shape_collision_radius;
    wp::array_t<wp::int32> adj_shape_world = _wp_adj_args->shape_world;
    wp::array_t<wp::transform_t<wp::float32>> adj_body_q = _wp_adj_args->body_q;
    wp::int32 adj_world_count = _wp_adj_args->world_count;
    wp::array_t<wp::float32> adj_world_bounds_min = _wp_adj_args->world_bounds_min;
    wp::array_t<wp::float32> adj_world_bounds_max = _wp_adj_args->world_bounds_max;
    //---------
    // primal vars
    wp::int32 var_0;
    wp::int32* var_1;
    wp::int32 var_2;
    wp::int32 var_3;
    bool var_4;
    const wp::int32 var_5 = 0;
    bool var_6;
    bool var_7;
    wp::float32* var_8;
    wp::float32 var_9;
    wp::float32 var_10;
    const wp::float32 var_11 = 100000.0;
    bool var_12;
    wp::transform_t<wp::float32>* var_13;
    wp::transform_t<wp::float32> var_14;
    wp::transform_t<wp::float32> var_15;
    wp::int32* var_16;
    wp::int32 var_17;
    wp::int32 var_18;
    const wp::int32 var_19 = 0;
    bool var_20;
    wp::transform_t<wp::float32>* var_21;
    wp::transform_t<wp::float32> var_22;
    wp::transform_t<wp::float32> var_23;
    wp::transform_t<wp::float32> var_24;
    wp::transform_t<wp::float32> var_25;
    wp::transform_t<wp::float32> var_26;
    wp::vec_t<3, wp::float32> var_27;
    wp::float32* var_28;
    wp::float32 var_29;
    wp::float32 var_30;
    wp::vec_t<3, wp::float32> var_31;
    wp::vec_t<3, wp::float32> var_32;
    wp::vec_t<3, wp::float32> var_33;
    wp::vec_t<3, wp::float32> var_34;
    const wp::int32 var_35 = 0;
    const wp::int32 var_36 = 0;
    wp::float32 var_37;
    wp::float32 var_38;
    const wp::int32 var_39 = 1;
    const wp::int32 var_40 = 1;
    wp::float32 var_41;
    wp::float32 var_42;
    const wp::int32 var_43 = 2;
    const wp::int32 var_44 = 2;
    wp::float32 var_45;
    wp::float32 var_46;
    const wp::int32 var_47 = 0;
    const wp::int32 var_48 = 0;
    wp::float32 var_49;
    wp::float32 var_50;
    const wp::int32 var_51 = 1;
    const wp::int32 var_52 = 1;
    wp::float32 var_53;
    wp::float32 var_54;
    const wp::int32 var_55 = 2;
    const wp::int32 var_56 = 2;
    wp::float32 var_57;
    wp::float32 var_58;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    wp::int32 adj_1 = {};
    wp::int32 adj_2 = {};
    wp::int32 adj_3 = {};
    bool adj_4 = {};
    wp::int32 adj_5 = {};
    bool adj_6 = {};
    bool adj_7 = {};
    wp::float32 adj_8 = {};
    wp::float32 adj_9 = {};
    wp::float32 adj_10 = {};
    wp::float32 adj_11 = {};
    bool adj_12 = {};
    wp::transform_t<wp::float32> adj_13 = {};
    wp::transform_t<wp::float32> adj_14 = {};
    wp::transform_t<wp::float32> adj_15 = {};
    wp::int32 adj_16 = {};
    wp::int32 adj_17 = {};
    wp::int32 adj_18 = {};
    wp::int32 adj_19 = {};
    bool adj_20 = {};
    wp::transform_t<wp::float32> adj_21 = {};
    wp::transform_t<wp::float32> adj_22 = {};
    wp::transform_t<wp::float32> adj_23 = {};
    wp::transform_t<wp::float32> adj_24 = {};
    wp::transform_t<wp::float32> adj_25 = {};
    wp::transform_t<wp::float32> adj_26 = {};
    wp::vec_t<3, wp::float32> adj_27 = {};
    wp::float32 adj_28 = {};
    wp::float32 adj_29 = {};
    wp::float32 adj_30 = {};
    wp::vec_t<3, wp::float32> adj_31 = {};
    wp::vec_t<3, wp::float32> adj_32 = {};
    wp::vec_t<3, wp::float32> adj_33 = {};
    wp::vec_t<3, wp::float32> adj_34 = {};
    wp::int32 adj_35 = {};
    wp::int32 adj_36 = {};
    wp::float32 adj_37 = {};
    wp::float32 adj_38 = {};
    wp::int32 adj_39 = {};
    wp::int32 adj_40 = {};
    wp::float32 adj_41 = {};
    wp::float32 adj_42 = {};
    wp::int32 adj_43 = {};
    wp::int32 adj_44 = {};
    wp::float32 adj_45 = {};
    wp::float32 adj_46 = {};
    wp::int32 adj_47 = {};
    wp::int32 adj_48 = {};
    wp::float32 adj_49 = {};
    wp::float32 adj_50 = {};
    wp::int32 adj_51 = {};
    wp::int32 adj_52 = {};
    wp::float32 adj_53 = {};
    wp::float32 adj_54 = {};
    wp::int32 adj_55 = {};
    wp::int32 adj_56 = {};
    wp::float32 adj_57 = {};
    wp::float32 adj_58 = {};
    //---------
    // forward
    // def estimate_world_extents(                                                            <L 198>
    // tid = wp.tid()                                                                         <L 209>
    var_0 = builtin_tid1d();
    // world_idx = shape_world[tid]                                                           <L 212>
    var_1 = wp::address(var_shape_world, var_0);
    var_3 = wp::load(var_1);
    var_2 = wp::copy(var_3);
    // if world_idx < 0 or world_idx >= world_count:                                          <L 215>
    var_6 = (var_2 < var_5);
    var_4 = var_6;
    if (!var_4) {
        var_7 = (var_2 >= var_world_count);
        var_4 = var_4 || var_7;
    }
    if (var_4) {
        // return                                                                             <L 216>
        goto label0;
    }
    // radius = shape_collision_radius[tid]                                                   <L 219>
    var_8 = wp::address(var_shape_collision_radius, var_0);
    var_10 = wp::load(var_8);
    var_9 = wp::copy(var_10);
    // if radius > 1.0e5:  # Skip outliers like infinite planes                               <L 220>
    var_12 = (var_9 > var_11);
    if (var_12) {
        // return                                                                             <L 221>
        goto label1;
    }
    // shape_xform = shape_transform[tid]                                                     <L 224>
    var_13 = wp::address(var_shape_transform, var_0);
    var_15 = wp::load(var_13);
    var_14 = wp::copy(var_15);
    // shape_parent = shape_body[tid]                                                         <L 225>
    var_16 = wp::address(var_shape_body, var_0);
    var_18 = wp::load(var_16);
    var_17 = wp::copy(var_18);
    // if shape_parent >= 0:                                                                  <L 228>
    var_20 = (var_17 >= var_19);
    if (var_20) {
        // body_xform = body_q[shape_parent]                                                  <L 230>
        var_21 = wp::address(var_body_q, var_17);
        var_23 = wp::load(var_21);
        var_22 = wp::copy(var_23);
        // world_xform = wp.transform_multiply(body_xform, shape_xform)                       <L 231>
        var_24 = wp::transform_multiply(var_22, var_14);
    }
    if (!var_20) {
        // world_xform = shape_xform                                                          <L 234>
        var_25 = wp::copy(var_14);
    }
    var_26 = wp::where(var_20, var_24, var_25);
    // pos = wp.transform_get_translation(world_xform)                                        <L 237>
    var_27 = wp::transform_get_translation(var_26);
    // radius = shape_collision_radius[tid]                                                   <L 238>
    var_28 = wp::address(var_shape_collision_radius, var_0);
    var_30 = wp::load(var_28);
    var_29 = wp::copy(var_30);
    // min_pos = pos - wp.vec3(radius, radius, radius)                                        <L 241>
    var_31 = wp::vec_t<3, wp::float32>(var_29, var_29, var_29);
    var_32 = wp::sub(var_27, var_31);
    // max_pos = pos + wp.vec3(radius, radius, radius)                                        <L 242>
    var_33 = wp::vec_t<3, wp::float32>(var_29, var_29, var_29);
    var_34 = wp::add(var_27, var_33);
    // wp.atomic_min(world_bounds_min, world_idx, 0, min_pos[0])                              <L 245>
    var_37 = wp::extract(var_32, var_36);
    // var_38 = wp::atomic_min(var_world_bounds_min, var_2, var_35, var_37);
    // wp.atomic_min(world_bounds_min, world_idx, 1, min_pos[1])                              <L 246>
    var_41 = wp::extract(var_32, var_40);
    // var_42 = wp::atomic_min(var_world_bounds_min, var_2, var_39, var_41);
    // wp.atomic_min(world_bounds_min, world_idx, 2, min_pos[2])                              <L 247>
    var_45 = wp::extract(var_32, var_44);
    // var_46 = wp::atomic_min(var_world_bounds_min, var_2, var_43, var_45);
    // wp.atomic_max(world_bounds_max, world_idx, 0, max_pos[0])                              <L 250>
    var_49 = wp::extract(var_34, var_48);
    // var_50 = wp::atomic_max(var_world_bounds_max, var_2, var_47, var_49);
    // wp.atomic_max(world_bounds_max, world_idx, 1, max_pos[1])                              <L 251>
    var_53 = wp::extract(var_34, var_52);
    // var_54 = wp::atomic_max(var_world_bounds_max, var_2, var_51, var_53);
    // wp.atomic_max(world_bounds_max, world_idx, 2, max_pos[2])                              <L 252>
    var_57 = wp::extract(var_34, var_56);
    // var_58 = wp::atomic_max(var_world_bounds_max, var_2, var_55, var_57);
    //---------
    // reverse
    wp::adj_atomic_max(var_world_bounds_max, var_2, var_55, var_57, adj_world_bounds_max, adj_2, adj_55, adj_57, adj_58);
    wp::adj_extract(var_34, var_56, adj_34, adj_56, adj_57);
    // adj: wp.atomic_max(world_bounds_max, world_idx, 2, max_pos[2])                         <L 252>
    wp::adj_atomic_max(var_world_bounds_max, var_2, var_51, var_53, adj_world_bounds_max, adj_2, adj_51, adj_53, adj_54);
    wp::adj_extract(var_34, var_52, adj_34, adj_52, adj_53);
    // adj: wp.atomic_max(world_bounds_max, world_idx, 1, max_pos[1])                         <L 251>
    wp::adj_atomic_max(var_world_bounds_max, var_2, var_47, var_49, adj_world_bounds_max, adj_2, adj_47, adj_49, adj_50);
    wp::adj_extract(var_34, var_48, adj_34, adj_48, adj_49);
    // adj: wp.atomic_max(world_bounds_max, world_idx, 0, max_pos[0])                         <L 250>
    wp::adj_atomic_min(var_world_bounds_min, var_2, var_43, var_45, adj_world_bounds_min, adj_2, adj_43, adj_45, adj_46);
    wp::adj_extract(var_32, var_44, adj_32, adj_44, adj_45);
    // adj: wp.atomic_min(world_bounds_min, world_idx, 2, min_pos[2])                         <L 247>
    wp::adj_atomic_min(var_world_bounds_min, var_2, var_39, var_41, adj_world_bounds_min, adj_2, adj_39, adj_41, adj_42);
    wp::adj_extract(var_32, var_40, adj_32, adj_40, adj_41);
    // adj: wp.atomic_min(world_bounds_min, world_idx, 1, min_pos[1])                         <L 246>
    wp::adj_atomic_min(var_world_bounds_min, var_2, var_35, var_37, adj_world_bounds_min, adj_2, adj_35, adj_37, adj_38);
    wp::adj_extract(var_32, var_36, adj_32, adj_36, adj_37);
    // adj: wp.atomic_min(world_bounds_min, world_idx, 0, min_pos[0])                         <L 245>
    wp::adj_add(var_27, var_33, adj_27, adj_33, adj_34);
    wp::adj_vec_t(var_29, var_29, var_29, adj_29, adj_29, adj_29, adj_33);
    // adj: max_pos = pos + wp.vec3(radius, radius, radius)                                   <L 242>
    wp::adj_sub(var_27, var_31, adj_27, adj_31, adj_32);
    wp::adj_vec_t(var_29, var_29, var_29, adj_29, adj_29, adj_29, adj_31);
    // adj: min_pos = pos - wp.vec3(radius, radius, radius)                                   <L 241>
    wp::adj_copy(var_30, adj_28, adj_29);
    wp::adj_address(var_shape_collision_radius, var_0, adj_shape_collision_radius, adj_0, adj_28);
    // adj: radius = shape_collision_radius[tid]                                              <L 238>
    wp::adj_transform_get_translation(var_26, adj_26, adj_27);
    // adj: pos = wp.transform_get_translation(world_xform)                                   <L 237>
    wp::adj_where(var_20, var_24, var_25, adj_20, adj_24, adj_25, adj_26);
    if (!var_20) {
        wp::adj_copy(var_14, adj_14, adj_25);
        // adj: world_xform = shape_xform                                                     <L 234>
    }
    if (var_20) {
        wp::adj_transform_multiply(var_22, var_14, adj_22, adj_14, adj_24);
        // adj: world_xform = wp.transform_multiply(body_xform, shape_xform)                  <L 231>
        wp::adj_copy(var_23, adj_21, adj_22);
        wp::adj_address(var_body_q, var_17, adj_body_q, adj_17, adj_21);
        // adj: body_xform = body_q[shape_parent]                                             <L 230>
    }
    // adj: if shape_parent >= 0:                                                             <L 228>
    wp::adj_copy(var_18, adj_16, adj_17);
    wp::adj_address(var_shape_body, var_0, adj_shape_body, adj_0, adj_16);
    // adj: shape_parent = shape_body[tid]                                                    <L 225>
    wp::adj_copy(var_15, adj_13, adj_14);
    wp::adj_address(var_shape_transform, var_0, adj_shape_transform, adj_0, adj_13);
    // adj: shape_xform = shape_transform[tid]                                                <L 224>
    if (var_12) {
        label1:;
        // adj: return                                                                        <L 221>
    }
    // adj: if radius > 1.0e5:  # Skip outliers like infinite planes                          <L 220>
    wp::adj_copy(var_10, adj_8, adj_9);
    wp::adj_address(var_shape_collision_radius, var_0, adj_shape_collision_radius, adj_0, adj_8);
    // adj: radius = shape_collision_radius[tid]                                              <L 219>
    if (var_4) {
        label0:;
        // adj: return                                                                        <L 216>
    }
    if (!var_4) {
    }
    // adj: if world_idx < 0 or world_idx >= world_count:                                     <L 215>
    wp::adj_copy(var_3, adj_1, adj_2);
    wp::adj_address(var_shape_world, var_0, adj_shape_world, adj_0, adj_1);
    // adj: world_idx = shape_world[tid]                                                      <L 212>
    // adj: tid = wp.tid()                                                                    <L 209>
    // adj: def estimate_world_extents(                                                       <L 198>
    return;
}



extern "C" {

// Python CPU entry points
WP_API void estimate_world_extents_46771af7_cpu_forward(
    wp::launch_bounds_t<1> *dim,
    wp_args_estimate_world_extents_46771af7 *_wp_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        estimate_world_extents_46771af7_cpu_kernel_forward(*dim, task_index, _wp_args);
    }
}

} // extern C



extern "C" {

WP_API void estimate_world_extents_46771af7_cpu_backward(
    wp::launch_bounds_t<1> *dim,
    wp_args_estimate_world_extents_46771af7 *_wp_args,
    wp_args_estimate_world_extents_46771af7 *_wp_adj_args)
{
    wp::tile_shared_storage_t tile_mem;
#if defined(WP_ENABLE_TILES_IN_STACK_MEMORY)
    wp::shared_tile_storage = &tile_mem;
#endif

    for (size_t task_index = 0; task_index < dim->size; ++task_index)
    {
        estimate_world_extents_46771af7_cpu_kernel_backward(*dim, task_index, _wp_args, _wp_adj_args);
    }
}

} // extern C

