//
//  Constants.case swift
//  case eveSwiftData
//
//  Created by case erik case hatfield on 8/30/25.
//

// https://github.com/pyfa-org/eos/blob/master/eos/const/eve.py

public enum attrId: Int64 {
  case cpu = 50
  case cpu_output = 48
  case drone_bandwidth = 1271
  case drone_bandwidth_used = 1272
  case power = 30
  case power_output = 11
  case upgrade_capacity = 1132
  case upgrade_cost = 1153
  // slots
  case boosterness = 1087
  case drone_capacity = 283
  case hi_slot_modifier = 1374
  case hi_slots = 14
  case implantness = 331
  case launcher_hardpoint_modifier = 1369
  case launcher_slots_left = 101
  case low_slot_modifier = 1376
  case low_slots = 12
  case max_active_drones = 352
  case max_subsystems = 1367
  case med_slot_modifier = 1375
  case med_slots = 13
  case rig_slots = 1137
  case subsystem_slot = 1366
  case turret_hardpoint_modifier = 1368
  case turret_slots_left = 102
  // damage
  case em_dmg = 114
  case expl_dmg = 116
  case kin_dmg = 117
  case therm_dmg = 118
  // resistances
  case armor_em_dmg_resonance = 267
  case armor_expl_dmg_resonance = 268
  case armor_kin_dmg_resonance = 269
  case armor_therm_dmg_resonance = 270
  case em_dmg_resonance = 113
  case expl_dmg_resonance = 111
  case kin_dmg_resonance = 109
  case resist_shift_amount = 1849
  case therm_dmg_resonance = 110
  case shield_em_dmg_resonance = 271
  case shield_expl_dmg_resonance = 272
  case shield_kin_dmg_resonance = 273
  case shield_therm_dmg_resonance = 274
  // tanking
  case armor_hp = 265
  case hp = 9
  case shield_capacity = 263
  // repairing
  case armor_dmg_amount = 84
  case charged_armor_dmg_mult = 1886
  // charge-case related
  case ammo_loaded = 127
  case charge_group_1 = 604
  case charge_group_2 = 605
  case charge_group_3 = 606
  case charge_group_4 = 609
  case charge_group_5 = 610
  case charge_rate = 56
  case charge_size = 128
  case crystal_volatility_chance = 783
  case crystal_volatility_dmg = 784
  case crystals_get_damaged = 786
  case reload_time = 1795
  // skills
  case required_skill_1 = 182
  case required_skill_1_level = 277
  case required_skill_2 = 183
  case required_skill_2_level = 278
  case required_skill_3 = 184
  case required_skill_3_level = 279
  case required_skill_4 = 1285
  case required_skill_4_level = 1286
  case required_skill_5 = 1289
  case required_skill_5_level = 1287
  case required_skill_6 = 1290
  case required_skill_6_level = 1288
  case skill_level = 280
  // fitting case restriction
  case allowed_drone_group_1 = 1782
  case allowed_drone_group_2 = 1783
  case can_fit_ship_group_1 = 1298
  case can_fit_ship_group_2 = 1299
  case can_fit_ship_group_3 = 1300
  case can_fit_ship_group_4 = 1301
  case can_fit_ship_group_5 = 1872
  case can_fit_ship_group_6 = 1879
  case can_fit_ship_group_7 = 1880
  case can_fit_ship_group_8 = 1881
  case can_fit_ship_group_9 = 2065
  case can_fit_ship_group_10 = 2396
  case can_fit_ship_group_11 = 2476
  case can_fit_ship_group_12 = 2477
  case can_fit_ship_group_13 = 2478
  case can_fit_ship_group_14 = 2479
  case can_fit_ship_group_15 = 2480
  case can_fit_ship_group_16 = 2481
  case can_fit_ship_group_17 = 2482
  case can_fit_ship_group_18 = 2483
  case can_fit_ship_group_19 = 2484
  case can_fit_ship_group_20 = 2485
  case can_fit_ship_type_1 = 1302
  case can_fit_ship_type_2 = 1303
  case can_fit_ship_type_3 = 1304
  case can_fit_ship_type_4 = 1305
  case can_fit_ship_type_5 = 1944
  case can_fit_ship_type_6 = 2103
  case can_fit_ship_type_7 = 2463
  case can_fit_ship_type_8 = 2486
  case can_fit_ship_type_9 = 2487
  case can_fit_ship_type_10 = 2488
  case fits_to_shiptype = 1380
  case max_group_active = 763
  case max_group_fitted = 1544
  case max_group_online = 978
  case rig_size = 1547
  // fighters
  case fighter_tubes = 2216
  case fighter_support_slots = 2218
  case fighter_light_slots = 2217
  case fighter_heavy_slots = 2219
  case fighter_squadron_is_heavy = 2214
  case fighter_squadron_is_light = 2212
  case fighter_squadron_is_support = 2213
  case fighter_squadron_max_size = 2215
  case fighter_ability_attack_missile_dmg_em = 2227
  case fighter_ability_attack_missile_dmg_therm = 2228
  case fighter_ability_attack_missile_dmg_kin = 2229
  case fighter_ability_attack_missile_dmg_expl = 2230
  case fighter_ability_attack_missile_dmg_mult = 2226
  case fighter_ability_missiles_dmg_em = 2131
  case fighter_ability_missiles_dmg_therm = 2132
  case fighter_ability_missiles_dmg_kin = 2133
  case fighter_ability_missiles_dmg_expl = 2134
  case fighter_ability_missiles_dmg_mult = 2130
  case fighter_ability_launch_bomb_type = 2324
  case fighter_ability_kamikaze_dmg_em = 2325
  case fighter_ability_kamikaze_dmg_therm = 2326
  case fighter_ability_kamikaze_dmg_kin = 2327
  case fighter_ability_kamikaze_dmg_expl = 2328
  // warfare buffs
  case warfare_buff_1_id = 2468
  case warfare_buff_1_value = 2469
  case warfare_buff_2_id = 2470
  case warfare_buff_2_value = 2471
  case warfare_buff_3_id = 2472
  case warfare_buff_3_value = 2473
  case warfare_buff_4_id = 2536
  case warfare_buff_4_value = 2537
  // misc
  case agility = 70
  case aoe_cloud_size = 654
  case aoe_cloud_size_bonus = 848
  case aoe_velocity = 653
  case aoe_velocity_bonus = 847
  case capacity = 38
  case dmg_mult = 64
  case dmg_mult_bonus = 292
  case dmg_mult_bonus_max = 2734
  case energy_neutralizer_amount = 97
  case explosion_delay = 281
  case explosion_delay_bonus = 596
  case falloff = 158
  case falloff_bonus = 349
  case is_capital_size = 1785
  case mass = 4
  case mass_addition = 796
  case max_range = 54
  case max_range_bonus = 351
  case max_target_range = 76
  case max_target_range_bonus = 309
  case max_velocity = 37
  case missile_dmg_mult = 212
  case missile_velocity_bonus = 547
  case module_reactivation_delay = 669
  case nos_override = 1945
  case power_transfer_amount = 90
  case radius = 162
  case repair_mult_bonus_max = 2797
  case rof_bonus = 293
  case sensor_dampener_resist = 2112
  case shield_bonus = 68
  case signature_radius = 552
  case signature_radius_bonus = 554
  case speed = 51
  case speed_boost_factor = 567
  case speed_factor = 20
  case stasis_webifier_resist = 2115
  case tracking_speed = 160
  case tracking_speed_bonus = 767
  case volume = 161
}


// MARK: - TypeId
enum TypeId: Int64, CaseIterable {
    case characterStatic = 1381
    case missileLauncherOperation = 3319 // Skill
    case gunnery = 3300 // Skill
    case naniteRepairPaste = 28668
    case sentryDroneInterfacing = 23594 // Skill
}

// MARK: - TypeGroupId
enum TypeGroupId: Int64, CaseIterable {
    case character = 1
    case effectBeacon = 920
    case energyWeapon = 53
    case hydridWeapon = 74
    case miningLaser = 54
    case projectileWeapon = 55
    case shipModifier = 1306
}

// MARK: - TypeCategoryId
enum TypeCategoryId: Int64, CaseIterable {
    case charge = 8
    case drone = 18
    case fighter = 87
    case implant = 20
    case module = 7
    case ship = 6
    case skill = 16
    case subsystem = 32
}
