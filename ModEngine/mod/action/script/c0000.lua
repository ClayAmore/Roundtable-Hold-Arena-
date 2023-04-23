﻿------------------------------------------
-- Fixed decompiled c0000.hks for ELDEN RING
-- Refined from decompiles by Vawser
-- Curated at: https://github.com/ividyon/EldenRingHKS
------------------------------------------
-- Version 7 for ER version 1.08.1
------------------------------------------
-- Changelog:
-- 2022-12-15 - AshenOne: ExecMagic (line 2090), moving an if block so left-hand casting works as intended
-- 2022-12-16 - ivi: Updated for 1.08.1
-- 2022-12-28 - Kirnifr: fixed Torrent dash
-- 2023-01-27 - Massive overhaul and improvements by Vawser from Vigil
--              Properly fixes Torrent dash as well as flick animation issues
--              proper act/env naming instead of IDs, proper spacing, useful comments
-- 2023-01-27 - Minor oversight fixes
-- 2023-01-27 - Put on GitHub via philiquaz' initiative
-- 2023-02-14 - Minor comment changes
-- 2023-03-19 - Support for custom Ashes of War
------------------------------------------
-- Known issues:
-- Torrent will retain his "gallop" state even if you come to a standstill, fall, or
-- perform any other action which would normally cancel the gallop and return to
-- default speed. This makes him janky for precision parkour things.
------------------------------------------
-- Core: Functions
------------------------------------------
function ExecEvent(state)
    ResetRequest()
    hkbFireEvent(state)
end

function ExecEventSync(state)
    ResetRequest()
    act(PlayEventSync, state)
end

function ExecEventNoReset(state)
    hkbFireEvent(state)
end

function ExecEventSyncNoReset(state)
    act(PlayEventSync, state)
end

function ExecEvents(...)
    local buff = { ... }

    for i = 1, #buff, 1 do
        ExecEvent(buff[i])
    end
end

function GetVariable(variable)
    return hkbGetVariable(variable)
end

function ExecEventHalfBlend(event_table, blend_type)
    if blend_type == ALLBODY then
        SetVariable("MoveSpeedLevelReal", 0)
        local lower_event = event_table[1]
        local upper_event = lower_event .. "_Upper"

        ExecEvents(lower_event, upper_event)

        for i = 2, #event_table, 1 do
            SetVariable("LowerDefaultState0" .. i - 2, event_table[i])
            SetVariable("UpperDefaultState0" .. i - 2, event_table[i])
        end
    elseif blend_type == LOWER then
        ExecEvent(event_table[1])

        for i = 2, #event_table, 1 do
            SetVariable("LowerDefaultState0" .. i - 2, event_table[i])
        end
    elseif blend_type == UPPER then
        ExecEvent(event_table[1] .. "_Upper")

        for i = 2, #event_table, 1 do
            SetVariable("UpperDefaultState0" .. i - 2, event_table[i])
        end
    end
end

function ExecEventHalfBlendNoReset(event_table, blend_type)
    if blend_type == ALLBODY then
        local lower_event = event_table[1]
        local upper_event = lower_event .. "_Upper"

        ExecEventNoReset(lower_event)
        ExecEventNoReset(upper_event)

        for i = 2, #event_table, 1 do
            SetVariable("LowerDefaultState0" .. i - 2, event_table[i])
            SetVariable("UpperDefaultState0" .. i - 2, event_table[i])
        end
    elseif blend_type == LOWER then
        ExecEventNoReset(event_table[1])

        for i = 2, #event_table, 1 do
            SetVariable("LowerDefaultState0" .. i - 2, event_table[i])
        end
    elseif blend_type == UPPER then
        ExecEventNoReset(event_table[1] .. "_Upper")

        for i = 2, #event_table, 1 do
            SetVariable("UpperDefaultState0" .. i - 2, event_table[i])
        end
    end
    return
end

function ExecEventAllBody(event)
    SetVariable("MoveSpeedLevelReal", 0)

    ExecEvent(event)
end

function IsNodeActive(...)
    local buff = { ... }

    for i = 1, #buff, 1 do
        if hkbIsNodeActive(buff[i]) then
            return TRUE
        end
    end

    return FALSE
end

function ResetEventState()
    SetVariable("MoveSpeedLevelReal", 0)
    ResetRequest()

    return
end

function ResetMimicry()
    act(AddSpEffect, 503041)

    return
end

function SetEnableMimicry()
    g_EnableMimicry = TRUE

    return
end

function SetWeightIndex()
    local weight = math.mod(env(GetMoveAnimParamID), 20)

    if weight == WEIGHT_LIGHT then
        SetVariable("MoveWeightIndex", MOVE_WEIGHT_LIGHT)
        SetVariable("EvasionWeightIndex", EVASION_WEIGHT_INDEX_LIGHT)
    elseif weight == WEIGHT_NORMAL then
        SetVariable("MoveWeightIndex", MOVE_WEIGHT_NORMAL)
        SetVariable("EvasionWeightIndex", EVASION_WEIGHT_INDEX_MEDIUM)
    elseif weight == WEIGHT_HEAVY then
        SetVariable("MoveWeightIndex", MOVE_WEIGHT_HEAVY)
        SetVariable("EvasionWeightIndex", EVASION_WEIGHT_INDEX_HEAVY)
    elseif weight == WEIGHT_OVERWEIGHT then
        SetVariable("MoveWeightIndex", MOVE_WEIGHT_HEAVY)
        SetVariable("EvasionWeightIndex", EVASION_WEIGHT_INDEX_OVERWEIGHT)
    elseif weight == WEIGHT_SUPERLIGHT then
        SetVariable("MoveWeightIndex", MOVE_WEIGHT_SUPERLIGHT)
        SetVariable("EvasionWeightIndex", EVASION_WEIGHT_INDEX_SUPERLIGHT)
    else
        SetVariable("MoveWeightIndex", 0)
    end

    if env(GetSpEffectID, 503520) == TRUE and weight ~= WEIGHT_OVERWEIGHT then
        SetVariable("MoveWeightIndex", MOVE_WEIGHT_HEAVY)
        SetVariable("EvasionWeightIndex", EVASION_WEIGHT_INDEX_HEAVY)
    elseif env(GetSpEffectID, 5520) == TRUE and weight ~= WEIGHT_OVERWEIGHT then
        SetVariable("MoveWeightIndex", MOVE_WEIGHT_HEAVY)
        SetVariable("EvasionWeightIndex", EVASION_WEIGHT_INDEX_HEAVY)
    elseif env(GetSpEffectID, 425) == TRUE and weight ~= WEIGHT_OVERWEIGHT then
        SetVariable("MoveWeightIndex", MOVE_WEIGHT_HEAVY)
        SetVariable("EvasionWeightIndex", EVASION_WEIGHT_INDEX_HEAVY)
    elseif env(GetSpEffectID, 4101) == TRUE and weight ~= WEIGHT_OVERWEIGHT then
        SetVariable("MoveWeightIndex", MOVE_WEIGHT_HEAVY)
        SetVariable("EvasionWeightIndex", EVASION_WEIGHT_INDEX_HEAVY)
    elseif env(GetSpEffectID, 4100) == TRUE and weight ~= WEIGHT_OVERWEIGHT then
        SetVariable("MoveWeightIndex", MOVE_WEIGHT_HEAVY)
    end

    return
end

function SetAIActionState()
    act(SetAIAttackState, env(Unknown405))

    return
end

function SetAttackHand(hand)
    act(WeaponParameterReference, hand)

    return
end

function SetGuardHand(hand)
    act(SetThrowPossibilityState_Attacker, hand)

    return
end

function SetEnableAimMode()
    if env(ActionDuration, ACTION_ARM_ACTION) > 0 then
        return
    end

    local style = c_Style
    local isRide = env(IsOnMount)

    if isRide == TRUE then
        if style == HAND_LEFT_BOTH then
            if TRUE == GetEquipType(HAND_LEFT, WEAPON_CATEGORY_SMALL_ARROW, WEAPON_CATEGORY_ARROW, WEAPON_CATEGORY_CROSSBOW) then
                act(SetIsPreciseShootingPossible)
            end
        elseif TRUE == GetEquipType(HAND_RIGHT, WEAPON_CATEGORY_SMALL_ARROW, WEAPON_CATEGORY_ARROW, WEAPON_CATEGORY_CROSSBOW) then
            act(SetIsPreciseShootingPossible)
        end
    elseif style == HAND_LEFT_BOTH then
        if TRUE == GetEquipType(HAND_LEFT, WEAPON_CATEGORY_SMALL_ARROW, WEAPON_CATEGORY_ARROW, WEAPON_CATEGORY_LARGE_ARROW, WEAPON_CATEGORY_CROSSBOW, WEAPON_CATEGORY_BALLISTA) then
            act(SetIsPreciseShootingPossible)
        end
    elseif style == HAND_RIGHT_BOTH and TRUE == GetEquipType(HAND_RIGHT, WEAPON_CATEGORY_SMALL_ARROW, WEAPON_CATEGORY_ARROW, WEAPON_CATEGORY_LARGE_ARROW, WEAPON_CATEGORY_CROSSBOW, WEAPON_CATEGORY_BALLISTA) then
        act(SetIsPreciseShootingPossible)
    end

    return
end

function Replanning()
    act(DoAIReplanningAtCancelTiming)

    return
end

function AddStamina(num)
    act(SetStaminaRecoveryDisabled)
    act(ChangeStamina, num)

    return
end

function GetLocomotionState()
    local state = GetVariable("LowerDefaultState00")

    if state == MOVE_DEF0 or state == STEALTHMOVE_DEF0 then
        if env(GetSpEffectID, 100000) == TRUE then
            return PLAYER_STATE_MOVE
        elseif env(GetSpEffectID, 100001) == TRUE then
            return PLAYER_STATE_MOVE
        elseif env(GetSpEffectID, 100002) == TRUE then
            return PLAYER_STATE_MOVE
        end
    end

    return PLAYER_STATE_IDLE
end

function SetInterruptType(num)
    act(AINotifyAttackType, num)

    return
end

function SetTurnSpeed(turn_speed)
    act(SetTurnSpeed, turn_speed)

    return
end

function SetRollingTurnCondition(is_selftrans)
    local rolling_angle = "RollingAngleReal"

    if is_selftrans == TRUE then
        rolling_angle = "RollingAngleRealSelftrans"
    end

    if GetVariable("IsLockon") == true then
        local angle = GetVariable("TurnAngleReal")
        if angle > 180 then
            SetTurnSpeed(0)
        elseif angle > 90 then
            SetTurnSpeed(360)
        end
    elseif TRUE == env(IsPrecisionShoot) then
        SetTurnSpeed(0)
        SetVariable("TurnAngleReal", 300)
    elseif math.abs(GetVariable(rolling_angle)) > 0.0010000000474974513 then
        SetTurnSpeed(0)
    elseif GetVariable("TurnAngleReal") > 200 then
        SetTurnSpeed(0)
    end

    return
end

function IsLowerQuickTurn()
    if GetVariable("LowerDefaultState00") == QUICKTURN_DEF0 and env(GetSpEffectID, 100010) == TRUE then
        return TRUE
    else
        return FALSE
    end
end

function IsLowerBackStep()
    if GetVariable("LowerDefaultState00") == BACKSTEP_DEF0 then
        return TRUE
    else
        return FALSE
    end
end

function IsDualBladeSpecific(hand)
    if hand == HAND_LEFT then
        return env(IsTwinSwords, 0)
    else
        return env(IsTwinSwords, 1)
    end
end

function GetEquipType(hand, ...)
    local buff = { ... }
    local kind = {}
    local num = 1

    if hand == HAND_BOTH then
        kind[1] = env(GetEquipWeaponCategory, HAND_LEFT)
        kind[2] = env(GetEquipWeaponCategory, HAND_RIGHT)
        num = 2
    else
        kind[1] = env(GetEquipWeaponCategory, hand)
    end

    for i = 1, num, 1 do
        for j = 1, #buff, 1 do
            if kind[i] == buff[j] then
                return TRUE
            end
        end
    end

    return FALSE
end

function GetEquipTypeHandStyle()
    if c_Style == HAND_LEFT_BOTH then
        local kind = env(GetEquipWeaponCategory, HAND_LEFT)
        return kind
    else
        local kind = env(GetEquipWeaponCategory, HAND_RIGHT)
        return kind
    end
end

function IsHandStyleBoth()
    if c_Style == HAND_RIGHT_BOTH or c_Style == HAND_LEFT_BOTH then
        return TRUE
    else
        return FALSE
    end
end

function SetVariable(name, value)
    act(SetHavokVariable, name, value)

    return
end

function IsWeaponCanGuard()
    local style = c_Style
    local equip_category = nil
    local index = nil

    if style == HAND_RIGHT then
        equip_category = env(GetEquipWeaponCategory, HAND_LEFT)
        index = 2
    elseif style == HAND_LEFT_BOTH then
        equip_category = env(GetEquipWeaponCategory, HAND_LEFT)
        index = 3
    else
        equip_category = env(GetEquipWeaponCategory, HAND_RIGHT)
        index = 3
    end

    for i = 1, #WeaponCategoryID, 1 do
        if WeaponCategoryID[i][1] == equip_category then
            local canguard = WeaponCategoryID[i][index]
            return canguard
        end
    end

end

function IsEnableGuard()
    local style = c_Style
    local hand = HAND_LEFT

    if style == HAND_RIGHT_BOTH then
        hand = HAND_RIGHT
    end

    env(GetEquipWeaponSpecialCategoryNumber, hand)

    if style == HAND_RIGHT and GetEquipType(hand, WEAPON_CATEGORY_STAFF) == TRUE then
        return FALSE
    elseif FALSE == IsWeaponCanGuard() then
        return FALSE
    elseif IsEnableDualWielding() ~= -1 then
        return FALSE
    else
        return TRUE
    end
end

function ExecGuard(event, blend_type)
    if env(ActionDuration, ACTION_ARM_ACTION) > 0 then
        return FALSE
    elseif c_IsStealth == TRUE then
        blend_type = ALLBODY
    end

    if env(ActionRequest, ACTION_ARM_L1) == TRUE or env(ActionDuration, ACTION_ARM_L1) > 0 then
        if env(GetStamina) <= 0 then
            return FALSE
        elseif TRUE == IsEnableGuard() then
            local style = c_Style
            local hand = HAND_LEFT

            if style == HAND_RIGHT_BOTH then
                hand = HAND_RIGHT
            end

            local kind = env(GetEquipWeaponCategory, hand)
            local sp_kind = env(GetEquipWeaponSpecialCategoryNumber, hand)
            local guardindex = env(GetGuardMotionCategory, hand)

            -- Set Torch Color
            if kind == WEAPON_CATEGORY_TORCH and style == HAND_RIGHT then
                guardindex = GUARD_STYLE_TORCH

                if sp_kind == 250 then
                    SetVariable("IndexTorchColor", 1) -- Ghostflame Torch
                elseif sp_kind == 251 then
                    SetVariable("IndexTorchColor", 2) -- St. Trina's Torch
                else
                    SetVariable("IndexTorchColor", 0) -- Torch
                end
            elseif sp_kind == 240 and style == HAND_RIGHT then
                guardindex = GUARD_STYLE_TORCH
            elseif (style == HAND_RIGHT_BOTH or style == HAND_LEFT_BOTH) and env(GetStayAnimCategory) ~= 15 and env(GetStayAnimCategory) ~= 0 and env(GetStayAnimCategory) ~= 2 and env(GetStayAnimCategory) ~= 3 then
                guardindex = GUARD_STYLE_DEFAULT
            end

            if env(GetSpEffectID, 172) == TRUE then
                SetVariable("GuardStartType", 1)
            else
                SetVariable("GuardStartType", 0)
            end

            SetVariable("IndexGuardStyle", guardindex)

            if blend_type == ALLBODY and MoveStart(LOWER, Event_MoveLong, FALSE) == TRUE then
                blend_type = UPPER
            end

            ExecEventHalfBlend(event, blend_type)

            return TRUE
        end
    end

    return FALSE
end

function ResetRequest()
    act(ResetInputQueue)
end

function CheckActionRequest()
    return env(HasActionRequest)
end

function ExecStop()
    -- 100200 "[HKS] Gesture Anim"

    if GetVariable("MoveSpeedLevel") > 0 and env(GetSpEffectID, 100200) == FALSE then
        return FALSE
    end

    local stop_speed = GetVariable("MoveSpeedLevelReal")
    local movedirection = GetVariable("MoveDirection")
    local stop_speed_threshold = 0.3499999940395355

    SetVariable("ToggleDash", 0)
    SetWeightIndex()

    if GetVariable("EvasionWeightIndex") == EVASION_WEIGHT_INDEX_OVERWEIGHT and stop_speed > stop_speed_threshold then
        stop_speed = stop_speed_threshold
    end

    if stop_speed >= 0 and stop_speed <= 1 then
        if stop_speed <= stop_speed_threshold then
            if c_IsStealth == TRUE then
                ExecEventAllBody("W_Stealth_Idle")
            else
                ExecEventAllBody("W_Idle")
            end
        elseif c_IsStealth == TRUE then
            if movedirection == 0 then
                ExecEventAllBody("W_StealthRunStopFront")
            elseif movedirection == 1 then
                ExecEventAllBody("W_StealthRunStopBack")
            elseif movedirection == 2 then
                ExecEventAllBody("W_StealthRunStopLeft")
            elseif movedirection == 3 then
                ExecEventAllBody("W_StealthRunStopRight")
            end
        elseif movedirection == 0 then
            ExecEventAllBody("W_RunStopFront")
        elseif movedirection == 1 then
            ExecEventAllBody("W_RunStopBack")
        elseif movedirection == 2 then
            ExecEventAllBody("W_RunStopLeft")
        elseif movedirection == 3 then
            ExecEventAllBody("W_RunStopRight")
        end
    elseif stop_speed > 1 then
        if c_IsStealth == TRUE then
            ExecEventAllBody("W_StealthDashStop")
        else
            ExecEventAllBody("W_DashStop")
        end
    elseif c_IsStealth == TRUE then
        ExecEventAllBody("W_Stealth_Idle")
    else
        ExecEventAllBody("W_Idle")
    end

    return TRUE
end

function ExecStopHalfBlend(event, to_idle)
    -- 100200 "[HKS] Gesture Anim"

    if GetVariable("MoveSpeedLevel") > 0 and env(GetSpEffectID, 100200) == FALSE then
        return FALSE
    else
        SetVariable("LocomotionState", 0)
        if to_idle == TRUE then
            ExecEventNoReset("W_Idle")
            return TRUE
        else
            ExecEventHalfBlendNoReset(event, LOWER)
            return TRUE
        end
    end
end

function MoveStart(blend_type, event, gen_hand)
    -- 100200 "[HKS] Gesture Anim"

    if GetVariable("MoveSpeedLevel") <= 0 then
        return FALSE
    elseif env(GetSpEffectID, 100200) == TRUE then
        return FALSE
    elseif blend_type ~= LOWER then
        if gen_hand == FALSE then
            SetVariable("ArtsTransition", 0)
        else
            SetArtsGeneratorTransitionIndex()
        end
    end

    SetBonfireIndex()

    local stealth_state = GetVariable("StealthState")

    if (stealth_state == STEALTH_TO_STEALTHIDLE or stealth_state == STEALTH_TO_IDLE) and GetVariable("StealthTransitionIndex") > 0 then
        ExecEventHalfBlendNoReset(event, blend_type)
        return TRUE
    elseif GetLocomotionState() ~= PLAYER_STATE_MOVE then
        SetVariable("MoveSpeedLevelReal", 0)
        SpeedUpdate()
    end

    ExecEventHalfBlend(event, blend_type)

    return TRUE
end

function MoveStartonCancelTiming(event, gen_hand)
    if env(IsMoveCancelPossible) == TRUE then
        if GetLocomotionState() == PLAYER_STATE_MOVE then
            if MoveStart(UPPER, event, gen_hand) == TRUE then
                return TRUE
            end
        elseif MoveStart(ALLBODY, event, gen_hand) == TRUE then
            return TRUE
        end
    end

    return FALSE
end

function SetBaseCategory()
    SetVariable("IndexBaseCategory", GetBaseCategory())
end

function GetBaseCategory()
    -- Stay Anim is Weapon Motion Position ID
    local index = 0
    local stay_category = env(GetStayAnimCategory)

    if stay_category == 0 then
        index = 0
    elseif stay_category == 2 or stay_category == 12 then
        index = 1
    elseif stay_category == 3 or stay_category == 13 then
        index = 2
    end

    return index
end

function SetArtCancelType()
    if IsEnableSwordArts() == TRUE then
        act(SetWeaponCancelType, env(GetWeaponCancelType, c_SwordArtsHand))
    else
        act(SetWeaponCancelType, 0)
    end
end

function GetSwordArtInfo()
    local style = c_Style
    local is_both = FALSE

    if style >= HAND_LEFT_BOTH then
        is_both = TRUE
    end

    local art_hand = 0
    local weapon_id = nil

    if is_both == TRUE then
        if style == HAND_RIGHT_BOTH then
            art_hand = HAND_RIGHT
        elseif style == HAND_LEFT_BOTH then
            art_hand = HAND_LEFT
        end

        weapon_id = env(GetWeaponID, art_hand)
    else
        local arts_id = env(GetWeaponID, HAND_LEFT)

        if IsShieldArts(arts_id) == FALSE and IsArrowStanceArts(arts_id) == FALSE then
            art_hand = HAND_RIGHT
            weapon_id = env(GetWeaponID, HAND_RIGHT)
        else
            art_hand = HAND_LEFT
            weapon_id = arts_id
        end
    end

    return weapon_id, art_hand
end

function IsEnableSwordArts()
    -- 17 is Torch Attack

    local style = c_Style
    local arts_id = c_SwordArtsID

    env(GetEquipWeaponSpecialCategoryNumber, HAND_LEFT)

    if env(IsOnMount) == TRUE then
        return FALSE
    elseif style ~= HAND_LEFT_BOTH and c_SwordArtsHand == 0 then
        if IsShieldArts(arts_id) == TRUE then
            return TRUE
        else
            return FALSE
        end
    elseif arts_id ~= 17 and arts_id ~= SWORDARTS_INVALID then
        return TRUE
    else
        return FALSE
    end
end

function GreyOutSwordArtFE()
    if c_IsEnableSwordArts == FALSE then
        act(SetArtsPointFEDisplayState, 1)
        return
    elseif c_SwordArtsID == SWORDARTS_PARRY then
        act(SetArtsPointFEDisplayState, 1)
    else
        act(SetArtsPointFEDisplayState, 0)
    end
end

function IsAttackSwordArts(arts_id)
    local aow_list = {
        157, -- Raptor of the Mists
        160     -- White Shadow's Lure
    }

    if IsShieldArts(arts_id) == TRUE or IsRollingArts(arts_id) == TRUE or IsEnchantArts(arts_id) == TRUE or Contains(aow_list, arts_id) == TRUE then
        return FALSE
    else
        return TRUE
    end
end

function IsHalfBlendArts(arts_id)
    local aow_list = {
        20, -- Spinning Weapon
        58, -- Gravitas
        168, -- Zamor Ice Storm
        182, -- Knowledge Above All
        183, -- Devourer of Worlds
        184, -- Familal Rancor
        199, -- Spinning Weapon
        202, -- Tongues of Fire
        203, -- Oracular Bubble
        206, -- Sea of Magma
        213, -- Soul Stifler
        217     -- Glintstone Dart
    }

    if Contains(aow_list, arts_id) == TRUE then
        return TRUE
    else
        return FALSE
    end
end

function IsEnchantArts(arts_id)
    if 130 <= arts_id and arts_id <= 140 then
        return TRUE
    else
        return FALSE
    end
end

function IsShieldArts(arts_id)
    local aow_list = {
        17, -- Torch Attack
        71, -- Firebreather
        90, -- Shield Bash
        91, -- Barricade Shield
        92, -- Parry
        93, -- Buckler Parry
        95, -- Carian Retaliation
        96, -- Storm Wall
        97, -- Golden Parry
        98, -- Shield Crash
        99, -- Thops's Barrier
        151, -- Vow of the Indomitable
        152, -- Holy Ground
        195, -- Fires of Slumber
        196, -- Golden Retaliation
        197, -- Contagious Fury
        201, -- Flame Spit
        202, -- Tongues of Fire
        207, -- Viper Bite
        211     -- Bear Witness!
    }

    if Contains(aow_list, arts_id) == TRUE then
        return TRUE
    else
        return FALSE
    end
end

function IsStanceArts(arts_id)
    local aow_list = {
        10, -- Wild Strikes
        11, -- Spinning Strikes
        14, -- Unsheathe
        15, -- Square Off
        21, -- UNUSED
        25, -- Spinning Chain
        100, -- Through and Through
        101, -- Barrage
        102, -- Mighty Shot
        103, -- Enchanted Shot
        104, -- UNUSED
        105, -- Rain of Arrows
        106, -- UNUSED
        107, -- UNUSED
        108, -- Sky Shot
        169, -- Radahn's Rain
        178, -- Transient Moonlight
        219, -- Night-and-Flame Stance
        239     -- Spinning Wheel
    }

    if Contains(aow_list, arts_id) == TRUE then
        return TRUE
    else
        return FALSE
    end
end

function IsArrowStanceArts(arts_id)
    local aow_list = {
        100, -- Through and Through
        101, -- Barrage
        102, -- Mighty Shot
        103, -- Enchanted Shot
        104, -- UNUSED
        105, -- Rain of Arrows
        106, -- UNUSED
        107, -- UNUSED
        108, -- Sky Shot
        169     -- Radahn's Rain
    }

    if Contains(aow_list, arts_id) == TRUE then
        return TRUE
    else
        return FALSE
    end
end

function IsAttackStanceArts(arts_id)
    local aow_list = {
        10, -- Wild Strikes
        11, -- Spinning Strikes
        25, -- Spinning Chain
        239     -- Spinning Wheel
    }

    if Contains(aow_list, arts_id) == TRUE then
        return TRUE
    else
        return FALSE
    end
end

function IsRollingArts(arts_id)
    local aow_list = {
        155, -- Quickstep
        156     -- Bloodhound's Step
    }

    if Contains(aow_list, arts_id) == TRUE then
        return TRUE
    else
        return FALSE
    end
end

function GetSwordArtsRequestNew()
    local style = c_Style
    local arts_hand = c_SwordArtsHand
    local arts_id = c_SwordArtsID
    local arts_category = arts_id + 600
    local arts_request = nil
    local arts_anim = nil

    if IsStanceArts(arts_id) == TRUE then
        arts_request = SWORDARTS_REQUEST_RIGHT_STANCE
        arts_anim = SWORDARTS_ANIM_ID_RIGHT_STANCE_START
    elseif IsRollingArts(arts_id) == TRUE then
        arts_request = SWORDARTS_REQUEST_RIGHT_STEP
        arts_anim = SWORDARTS_ANIM_ID_RIGHT_STEP_FRONT
    elseif TRUE == env(GetSpEffectID, 100052) then
        arts_request = SWORDARTS_REQUEST_RIGHT_COMBO_1
        arts_anim = SWORDARTS_ANIM_ID_RIGHT_COMBO_1
    elseif TRUE == env(GetSpEffectID, 100053) then
        arts_request = SWORDARTS_REQUEST_RIGHT_COMBO_2
        arts_anim = SWORDARTS_ANIM_ID_RIGHT_COMBO_2
    elseif (style == HAND_LEFT_BOTH or style == HAND_RIGHT_BOTH) and IsShieldArts(arts_id) == TRUE then
        arts_request = SWORDARTS_REQUEST_BOTH_NORMAL
        arts_anim = SWORDARTS_ANIM_ID_BOTH_NORMAL
    elseif arts_hand == HAND_LEFT and IsShieldArts(arts_id) == TRUE then
        arts_request = SWORDARTS_REQUEST_LEFT_NORMAL
        arts_anim = SWORDARTS_ANIM_ID_LEFT_NORMAL
    else
        arts_request = SWORDARTS_REQUEST_RIGHT_NORMAL
        arts_anim = SWORDARTS_ANIM_ID_RIGHT_NORMAL
    end

    act(DebugLogOutput, "SwordArtRequest " .. arts_request .. " artsId=" .. arts_id .. "animID=a" .. arts_category .. "_" .. arts_anim)

    return arts_request
end

function HasSwordArtPoint(button, hand)
    return env(HasEnoughArtsPoints, button, hand)
end

function SetSwordArtsPointInfo(button, is_point_consume, to_state_event)
    local hand = c_SwordArtsHand

    local aow_list_noFPUse = {
        17, -- Torch Attack
        92, -- Parry
        93, -- Buckler Parry
        94, -- UNUSED
        112     -- Kick
    }

    if is_point_consume == TRUE then
        act(ReserveArtsPointsUse, button, hand)
    end

    local isLackFP = 0
    local noFPUse = FALSE
    local arts_id = env(GetWeaponID, hand)

    if Contains(aow_list_noFPUse, arts_id) == TRUE then
        noFPUse = TRUE
    end

    if env(HasEnoughArtsPoints, button, hand) == FALSE and noFPUse == FALSE then
        isLackFP = 1
        act(DebugLogOutput, "no artspoint , hand=" .. hand)
    elseif env(IsAbilityInsufficient, hand) == TRUE and noFPUse == FALSE then
        isLackFP = 1
        act(DebugLogOutput, "no ability , hand=" .. hand)
    end

    local val = "IsEnoughArtPointsL2"

    if button == ACTION_ARM_R1 then
        val = "IsEnoughArtPointsR1"
    elseif button == ACTION_ARM_R2 then
        val = "IsEnoughArtPointsR2"
    elseif button == ACTION_ARM_L2 then
        val = "IsEnoughArtPointsL2"
    end

    if to_state_event ~= nil then
        if to_state_event == "W_SwordArtsOneShotComboEnd_2" then
            val = "IsEnoughArtPointsR2_2"
        elseif to_state_event == "W_SwordArtsOneShotComboEnd" then
            val = "IsEnoughArtPointsR2"
        end
    end

    SetVariable(val, isLackFP)
end

function RequestArtPointConsumption(button, hand)
    act(ReserveArtsPointsUse, button, hand)
end

function CheckIfNonGeneratorTransition()
    env(GetEquipWeaponCategory, HAND_RIGHT)

    local kind_left = env(GetEquipWeaponCategory, HAND_LEFT)

    if kind_left == WEAPON_CATEGORY_FIST then
        return TRUE
    else
        return FALSE
    end
end

function SetArtsGeneratorTransitionIndex()
    if GetSwordArtsPutOppositeWeapon() == FALSE then
        SetVariable("ArtsTransition", 0)
        return
    end

    local style = c_Style

    if style == HAND_RIGHT then
        if CheckIfNonGeneratorTransition() == TRUE then
            SetVariable("ArtsTransition", 0)
            return
        end

        local hand = HAND_LEFT

        if HAND_LEFT == c_SwordArtsHand then
            hand = HAND_RIGHT
        end

        local changetype = GetHandChangeType(hand)

        if changetype == WEAPON_CHANGE_REQUEST_LEFT_WAIST then
            SetVariable("ArtsTransition", 1)
        elseif changetype == WEAPON_CHANGE_REQUEST_LEFT_BACK then
            SetVariable("ArtsTransition", 2)
        elseif changetype == WEAPON_CHANGE_REQUEST_LEFT_SHOULDER then
            SetVariable("ArtsTransition", 3)
        elseif changetype == WEAPON_CHANGE_REQUEST_LEFT_SPEAR then
            SetVariable("ArtsTransition", 4)
        elseif changetype == WEAPON_CHANGE_REQUEST_RIGHT_WAIST then
            SetVariable("ArtsTransition", 5)
        elseif changetype == WEAPON_CHANGE_REQUEST_RIGHT_BACK then
            SetVariable("ArtsTransition", 6)
        elseif changetype == WEAPON_CHANGE_REQUEST_RIGHT_SHOULDER then
            SetVariable("ArtsTransition", 7)
        elseif changetype == WEAPON_CHANGE_REQUEST_RIGHT_SPEAR then
            SetVariable("ArtsTransition", 8)
        else
            SetVariable("ArtsTransition", 0)
        end
    else
        local idle_cat = env(GetStayAnimCategory)

        if idle_cat < 10 then
            SetVariable("ArtsTransition", 0)
            return
        end

        SetVariable("ArtsTransition", 9)
    end
end

function SetMagicGeneratorTransitionIndex()
    if GetMagicPutOppositeWeapon() == FALSE then
        SetVariable("ArtsTransition", 0)
        return
    end

    local style = c_Style

    if style == HAND_RIGHT then
        local hand = HAND_LEFT

        if HAND_LEFT == g_Magichand then
            hand = HAND_RIGHT
        end

        local changetype = GetHandChangeType(hand)

        if changetype == WEAPON_CHANGE_REQUEST_LEFT_WAIST then
            SetVariable("ArtsTransition", 1)
        elseif changetype == WEAPON_CHANGE_REQUEST_LEFT_BACK then
            SetVariable("ArtsTransition", 2)
        elseif changetype == WEAPON_CHANGE_REQUEST_LEFT_SHOULDER then
            SetVariable("ArtsTransition", 3)
        elseif changetype == WEAPON_CHANGE_REQUEST_LEFT_SPEAR then
            SetVariable("ArtsTransition", 4)
        elseif changetype == WEAPON_CHANGE_REQUEST_RIGHT_WAIST then
            SetVariable("ArtsTransition", 5)
        elseif changetype == WEAPON_CHANGE_REQUEST_RIGHT_BACK then
            SetVariable("ArtsTransition", 6)
        elseif changetype == WEAPON_CHANGE_REQUEST_RIGHT_SHOULDER then
            SetVariable("ArtsTransition", 7)
        elseif changetype == WEAPON_CHANGE_REQUEST_RIGHT_SPEAR then
            SetVariable("ArtsTransition", 8)
        else
            SetVariable("ArtsTransition", 0)
        end
    else
        SetVariable("ArtsTransition", 9)
    end
end

function SetRightSpecialHeavyAttackGeneratorTransitionIndex()
    -- NOT Ornamental Straight Sword
    if env(GetEquipWeaponSpecialCategoryNumber, HAND_RIGHT) ~= 852 then
        SetVariable("ArtsTransition", 0)
        return
    end

    local style = c_Style

    if style == HAND_RIGHT then
        local hand = HAND_LEFT

        if HAND_LEFT == g_Magichand then
            hand = HAND_RIGHT
        end

        local changetype = GetHandChangeType(hand)

        if changetype == WEAPON_CHANGE_REQUEST_LEFT_WAIST then
            SetVariable("ArtsTransition", 1)
        elseif changetype == WEAPON_CHANGE_REQUEST_LEFT_BACK then
            SetVariable("ArtsTransition", 2)
        elseif changetype == WEAPON_CHANGE_REQUEST_LEFT_SHOULDER then
            SetVariable("ArtsTransition", 3)
        elseif changetype == WEAPON_CHANGE_REQUEST_LEFT_SPEAR then
            SetVariable("ArtsTransition", 4)
        elseif changetype == WEAPON_CHANGE_REQUEST_RIGHT_WAIST then
            SetVariable("ArtsTransition", 5)
        elseif changetype == WEAPON_CHANGE_REQUEST_RIGHT_BACK then
            SetVariable("ArtsTransition", 6)
        elseif changetype == WEAPON_CHANGE_REQUEST_RIGHT_SHOULDER then
            SetVariable("ArtsTransition", 7)
        elseif changetype == WEAPON_CHANGE_REQUEST_RIGHT_SPEAR then
            SetVariable("ArtsTransition", 8)
        else
            SetVariable("ArtsTransition", 0)
        end
    else
        SetVariable("ArtsTransition", 9)
    end
end

function IsMagicAnimExists(magic_type, anim_id)
    return env(DoesAnimExist, magic_type + 400, anim_id)
end

function IsQuickMagic()
    local magic_type = env(GetMagicAnimType)

    local magic_type_list = {
        MAGIC_REQUEST_STONE_SHOTGUN,
        MAGIC_REQUEST_QUICKENBULLET,
        MAGIC_REQUEST_QUICKSLASH,
        MAGIC_REQUEST_QUICK_FLAME
    }

    if not (magic_type ~= MAGIC_REQUEST_WEAPON_ENCHANT2 or c_Style ~= HAND_RIGHT) or Contains(magic_type_list, magic_type) == TRUE then
        return TRUE
    else
        return FALSE
    end
end

function IsWeaponEnchantMagic()
    local magic_type = env(GetMagicAnimType)

    local magic_type_list = {
        MAGIC_REQUEST_WEAPON_ENCHANT,
        MAGIC_REQUEST_WEAPON_ENCHANT2,
        MAGIC_REQUEST_WEAPON_ENCHANT_B,
        MAGIC_REQUEST_THUNDER_ENCHANT,
        MAGIC_REQUEST_HOLY_ENCHANT
    }

    if Contains(magic_type_list, magic_type) == TRUE then
        return TRUE
    else
        return FALSE
    end
end

function IsJumpMagic()
    local magic_type = env(GetMagicAnimType)

    local magic_type_list = {
        MAGIC_REQUEST_FLYING_BREATH,
        MAGIC_REQUEST_ELDER_DRAGON_BREATH
    }

    if Contains(magic_type_list, magic_type) == TRUE then
        return TRUE
    else
        return FALSE
    end
end

function IsComboMagic()
    local magic_type = env(GetMagicAnimType)

    return IsMagicAnimExists(magic_type, 45020)
end

function IsChargeMagic()
    local magic_type = env(GetMagicAnimType)

    return IsMagicAnimExists(magic_type, 45011)
end

function CheckIfHoldMagic()
    local magic_type = env(GetMagicAnimType)

    -- Original, saved in case of future issues
    -- local f69_local0 = IsMagicAnimExists(magic_type, 45012)
    -- if not f69_local0 then
    -- f69_local0 = magic_type == 35
    -- end
    -- return f69_local0

    return IsMagicAnimExists(magic_type, 45012)
end

function IsStealthMagic(magic_type)
    local magic_type_list = {
        26,
        114
    }

    if Contains(magic_type_list, magic_type) == TRUE then
        return TRUE
    else
        return FALSE
    end
end

function SetMoveType()
    -- 100130 "[HKS] Stance - SetMoveType 1"
    -- 100140 "[HKS] Stance - SetMoveType 2"
    -- 100150 "[HKS] Stance - SetMoveType 0"
    -- 100160 "[HKS] Stance - SetMoveType 3"

    if env(GetSpEffectID, 100130) == TRUE then
        SetVariable("MoveType", ConvergeValue(1, hkbGetVariable("MoveType"), 5, 5))
        SetVariable("StanceMoveType", 1)
    elseif env(GetSpEffectID, 100140) == TRUE then
        SetVariable("MoveType", ConvergeValue(1, hkbGetVariable("MoveType"), 5, 5))
        SetVariable("StanceMoveType", 2)
    elseif env(GetSpEffectID, 100150) == TRUE then
        SetVariable("MoveType", ConvergeValue(1, hkbGetVariable("MoveType"), 5, 5))
        SetVariable("StanceMoveType", 0)
    elseif env(GetSpEffectID, 100160) == TRUE then
        SetVariable("MoveType", ConvergeValue(1, hkbGetVariable("MoveType"), 5, 5))
        SetVariable("StanceMoveType", 3)
    else
        SetVariable("MoveType", ConvergeValue(0, hkbGetVariable("MoveType"), 5, 5))
    end
end

function SetStyleSpEffect()
    -- 100620 "[HKS] Right Hand Style"
    -- 100621 "[HKS] Left Hand Style"

    if c_Style == HAND_LEFT_BOTH then
        if env(GetSpEffectID, 100621) == FALSE then
            act(AddSpEffect, 100621)
        end
    elseif env(GetSpEffectID, 100620) == FALSE then
        act(AddSpEffect, 100620)
    end
end

function GetAttackRequest(is_guard)
    local style = c_Style
    local is_both = FALSE
    local is_both_right = FALSE

    if style >= HAND_LEFT_BOTH then
        is_both = TRUE
    end

    if style == HAND_RIGHT_BOTH then
        is_both_right = TRUE
    end

    local hand = HAND_RIGHT
    if style == HAND_LEFT_BOTH then
        hand = HAND_LEFT
    end

    local is_arrow = GetEquipType(hand, WEAPON_CATEGORY_SMALL_ARROW, WEAPON_CATEGORY_ARROW, WEAPON_CATEGORY_LARGE_ARROW)
    local is_crossbow = GetEquipType(hand, WEAPON_CATEGORY_CROSSBOW)
    local is_ballista = GetEquipType(hand, WEAPON_CATEGORY_BALLISTA)
    local is_staff = GetEquipType(hand, WEAPON_CATEGORY_STAFF)
    local request_r1 = env(ActionRequest, ACTION_ARM_R1)
    local request_r2 = env(ActionRequest, ACTION_ARM_R2)
    local request_l1 = env(ActionRequest, ACTION_ARM_L1)
    local request_l2 = env(ActionRequest, ACTION_ARM_L2)

    if env(ActionDuration, ACTION_ARM_ACTION) > 0 then
        request_r1 = FALSE
        request_r2 = FALSE
        request_l1 = FALSE
        request_l2 = FALSE
    end

    -- R2
    if not (request_r1 ~= TRUE or is_staff ~= FALSE) or request_r2 == TRUE and is_staff == TRUE then
        if is_both == TRUE then
            if is_arrow == TRUE then
                g_ArrowSlot = 0
                act(ChooseBowAndArrowSlot, 0)

                if style == HAND_LEFT_BOTH then
                    return ATTACK_REQUEST_ARROW_FIRE_LEFT
                else
                    return ATTACK_REQUEST_ARROW_FIRE_RIGHT
                end
            elseif is_crossbow == TRUE or is_ballista == TRUE then
                g_ArrowSlot = 0
                act(ChooseBowAndArrowSlot, 0)

                return ATTACK_REQUEST_BOTHRIGHT_CROSSBOW
            else
                return ATTACK_REQUEST_BOTH_LIGHT
            end
        elseif is_guard == TRUE then
            local is_spear = GetEquipType(HAND_RIGHT, WEAPON_CATEGORY_SPEAR)
            local is_rapier = GetEquipType(HAND_RIGHT, WEAPON_CATEGORY_RAPIER)
            local is_large_spear = GetEquipType(HAND_RIGHT, WEAPON_CATEGORY_LARGE_SPEAR)
            local is_large_rapier = GetEquipType(HAND_RIGHT, WEAPON_CATEGORY_LARGE_RAPIER)

            -- Shield Poke
            if is_spear == TRUE or is_rapier == TRUE or is_large_spear == TRUE or is_large_rapier == TRUE then
                if env(ActionDuration, ACTION_ARM_L1) > 0 then
                    return ATTACK_REQUEST_ATTACK_WHILE_GUARD
                else
                    return ATTACK_REQUEST_RIGHT_LIGHT
                end
            elseif is_arrow == TRUE or is_ballista == TRUE then
                return ATTACK_REQUEST_ARROW_BOTH_RIGHT
            elseif is_crossbow == TRUE then
                g_ArrowSlot = 0
                act(ChooseBowAndArrowSlot, 0)
                return ATTACK_REQUEST_RIGHT_CROSSBOW
            else
                return ATTACK_REQUEST_RIGHT_LIGHT
            end
        elseif is_arrow == TRUE or is_ballista == TRUE then
            return ATTACK_REQUEST_ARROW_BOTH_RIGHT
        elseif is_crossbow == TRUE then
            g_ArrowSlot = 0
            act(ChooseBowAndArrowSlot, 0)

            return ATTACK_REQUEST_RIGHT_CROSSBOW
        else
            return ATTACK_REQUEST_RIGHT_LIGHT
        end
        -- R2
    elseif request_r2 == TRUE then
        -- Bow/Greatbow
        if is_arrow == TRUE then
            if is_both == TRUE then
                g_ArrowSlot = 1
                act(ChooseBowAndArrowSlot, 1)
                if style == HAND_LEFT_BOTH then
                    return ATTACK_REQUEST_ARROW_FIRE_LEFT2
                else
                    return ATTACK_REQUEST_ARROW_FIRE_RIGHT2
                end
            else
                return ATTACK_REQUEST_ARROW_BOTH_RIGHT
            end
            -- Crossbow
        elseif is_crossbow == TRUE then
            if is_both == TRUE then
                g_ArrowSlot = 1
                act(ChooseBowAndArrowSlot, 1)
                return ATTACK_REQUEST_BOTHRIGHT_CROSSBOW2
            else
                g_ArrowSlot = 1
                act(ChooseBowAndArrowSlot, 1)
                return ATTACK_REQUEST_RIGHT_CROSSBOW2
            end
            -- Ballista
        elseif is_ballista == TRUE then
            if is_both == TRUE then
                g_ArrowSlot = 1
                act(ChooseBowAndArrowSlot, 1)
                return ATTACK_REQUEST_BOTHRIGHT_CROSSBOW2
            else
                return ATTACK_REQUEST_ARROW_BOTH_RIGHT
            end
            -- 2H Heavy
        elseif is_both == TRUE then
            return ATTACK_REQUEST_BOTH_HEAVY
            -- 1H Heavy
        else
            return ATTACK_REQUEST_RIGHT_HEAVY
        end
        -- L1
    elseif request_l1 == TRUE then
        if TRUE == env(IsPrecisionShoot) then
            return ATTACK_REQUEST_INVALID
        else
            local is_shield_left = GetEquipType(HAND_LEFT, WEAPON_CATEGORY_SMALL_SHIELD, WEAPON_CATEGORY_MIDDLE_SHIELD, WEAPON_CATEGORY_LARGE_SHIELD, WEAPON_CATEGORY_TORCH)
            local is_shield_right = GetEquipType(HAND_RIGHT, WEAPON_CATEGORY_SMALL_SHIELD, WEAPON_CATEGORY_MIDDLE_SHIELD, WEAPON_CATEGORY_LARGE_SHIELD, WEAPON_CATEGORY_TORCH)
            if is_shield_left == TRUE then
                return ATTACK_REQUEST_INVALID
            elseif is_shield_right == TRUE and is_both_right == TRUE then
                return ATTACK_REQUEST_INVALID
            else
                is_crossbow = GetEquipType(HAND_LEFT, WEAPON_CATEGORY_CROSSBOW)
                if TRUE == GetEquipType(HAND_LEFT, WEAPON_CATEGORY_SMALL_ARROW, WEAPON_CATEGORY_ARROW, WEAPON_CATEGORY_LARGE_ARROW, WEAPON_CATEGORY_BALLISTA) then
                    if is_both == FALSE then
                        return ATTACK_REQUEST_ARROW_BOTH_LEFT
                    else
                        return ATTACK_REQUEST_INVALID
                    end
                elseif is_crossbow == TRUE then
                    if is_both == FALSE then
                        g_ArrowSlot = 0
                        act(ChooseBowAndArrowSlot, 0)
                        return ATTACK_REQUEST_LEFT_CROSSBOW
                    else
                        return ATTACK_REQUEST_INVALID
                    end
                elseif TRUE == GetEquipType(HAND_LEFT, WEAPON_CATEGORY_STAFF) then
                    return ATTACK_REQUEST_INVALID
                elseif TRUE == GetEquipType(HAND_RIGHT, WEAPON_CATEGORY_SMALL_ARROW, WEAPON_CATEGORY_ARROW, WEAPON_CATEGORY_LARGE_ARROW, WEAPON_CATEGORY_CROSSBOW, WEAPON_CATEGORY_BALLISTA) and is_both == TRUE then
                    return ATTACK_REQUEST_INVALID
                elseif TRUE == GetEquipType(HAND_RIGHT, WEAPON_CATEGORY_CROSSBOW) and is_both == TRUE then
                    return ATTACK_REQUEST_INVALID
                else
                    local isEnableDualWielding = IsEnableDualWielding()
                    if isEnableDualWielding == HAND_RIGHT then
                        return ATTACK_REQUEST_DUAL_RIGHT
                    elseif isEnableDualWielding == HAND_LEFT then
                        return ATTACK_REQUEST_DUAL_LEFT
                    elseif TRUE == IsWeaponCanGuard() then
                        return ATTACK_REQUEST_INVALID
                    else
                        return ATTACK_REQUEST_LEFT_HEAVY
                    end
                end
            end
        end
        -- L2
    elseif request_l2 == TRUE then
        act(DebugLogOutput, "action request ACTION_ARM_L2")
        if is_both == FALSE then
            is_crossbow = GetEquipType(HAND_LEFT, WEAPON_CATEGORY_CROSSBOW)
            if TRUE == GetEquipType(HAND_LEFT, WEAPON_CATEGORY_SMALL_ARROW, WEAPON_CATEGORY_ARROW, WEAPON_CATEGORY_LARGE_ARROW, WEAPON_CATEGORY_BALLISTA) then
                return ATTACK_REQUEST_ARROW_BOTH_LEFT
            elseif is_crossbow == TRUE then
                g_ArrowSlot = 1
                act(ChooseBowAndArrowSlot, 1)
                return ATTACK_REQUEST_LEFT_CROSSBOW2
            end
        end
        if TRUE == c_IsEnableSwordArts then
            local swordartrequest = GetSwordArtsRequestNew()
            local is_arrowright = GetEquipType(HAND_RIGHT, WEAPON_CATEGORY_SMALL_ARROW, WEAPON_CATEGORY_ARROW, WEAPON_CATEGORY_LARGE_ARROW, WEAPON_CATEGORY_BALLISTA)
            if swordartrequest == SWORDARTS_REQUEST_RIGHT_STANCE and is_arrowright == TRUE then
                if style ~= HAND_RIGHT_BOTH then
                    return ATTACK_REQUEST_ARROW_BOTH_RIGHT
                else
                    return swordartrequest
                end
            else
                return swordartrequest
            end
        elseif is_both == TRUE then
            if GetEquipType(hand, WEAPON_CATEGORY_STAFF) == TRUE then
                return ATTACK_REQUEST_BOTH_LIGHT
            else
                return ATTACK_REQUEST_BOTH_HEAVY
            end
        else
            return ATTACK_REQUEST_LEFT_HEAVY
        end
    else
        return ATTACK_REQUEST_INVALID
    end
end

function ExecAttack(r1, r2, l1, l2, b1, b2, is_guard, blend_type, artsr1, artsr2, is_stealth_rolling)
    local cur_stamina = env(GetStamina)

    if cur_stamina <= 0 and GetVariable("StaminaComboResetTest") == 1 then
        g_ComboReset = TRUE
    end

    local request = GetAttackRequest(is_guard)

    if request == ATTACK_REQUEST_INVALID then
        return FALSE
    end

    act(DebugLogOutput, "ExecAttack request=" .. request)

    local style = c_Style
    local atk_hand = HAND_RIGHT
    local guard_hand = HAND_RIGHT
    local is_find_atk = TRUE

    if cur_stamina <= 0 then
        ResetRequest()
        return FALSE
    end

    local is_Dual = FALSE
    g_ComboReset = FALSE

    if c_Style == HAND_LEFT_BOTH then

    end

    act(SetDamageMotionBlendRatio, 0)

    if env(IsSpecialTransitionPossible) == TRUE then
        r1 = "W_AttackRightLight1"
        l1 = "W_AttackLeftLight1"
        b1 = "W_AttackBothLight1"

        -- 132 "[HKS] Recovery Window: Heavy Attack"
        -- Applied in TAE
        if env(GetSpEffectID, 132) == FALSE then
            r2 = "W_AttackRightHeavy1Start"
            l2 = "W_AttackLeftHeavy1"
            b2 = "W_AttackBothHeavy1Start"
        end
    end

    -- 133 "[HKS] Switch Heavy to Heavy Sub"
    -- Applied in TAE
    if env(GetSpEffectID, 133) == TRUE then
        if r2 == "W_AttackRightHeavy1Start" then
            r2 = "W_AttackRightHeavy1SubStart"
        end

        if b2 == "W_AttackBothHeavy1Start" then
            b2 = "W_AttackBothHeavy1SubStart"
        end
        -- 134 "[HKS] Switch Heavy Sub to Heavy"
        -- Applied in TAE
    elseif env(GetSpEffectID, 134) == TRUE then
        if r2 == "W_AttackRightHeavy1SubStart" then
            r2 = "W_AttackRightHeavy1Start"
        end

        if b2 == "W_AttackBothHeavy1SubStart" then
            b2 = "W_AttackBothHeavy1Start"
        end
    end

    -- 173 "[HKS] Guard Counter: End"
    -- 174 "[HKS] Guard Counter: Window"
    if env(GetSpEffectID, 173) == TRUE or env(GetSpEffectID, 174) == TRUE then
        if c_Style == HAND_RIGHT_BOTH then
            atk_hand = HAND_RIGHT
            guard_hand = HAND_RIGHT
        elseif c_Style == HAND_LEFT_BOTH then
            atk_hand = HAND_LEFT
            guard_hand = HAND_LEFT
        end

        -- Guard Counter Window
        -- If the player is holding a valid weapon, and has pressed R2, play Guard Counter anim
        if GetEquipType(atk_hand, WEAPON_CATEGORY_STAFF, WEAPON_CATEGORY_SMALL_ARROW, WEAPON_CATEGORY_ARROW, WEAPON_CATEGORY_LARGE_ARROW, WEAPON_CATEGORY_CROSSBOW, WEAPON_CATEGORY_BALLISTA) == FALSE and env(ActionRequest, ACTION_ARM_R2) == TRUE then
            if c_Style == HAND_RIGHT_BOTH or c_Style == HAND_LEFT_BOTH then
                ExecEventAllBody("W_AttackBothHeavyCounter")
            else
                ExecEventAllBody("W_AttackRightHeavyCounter")
            end

            return TRUE
            -- Otherwise, if in Guard Counter Window, mulch the request
        elseif env(GetSpEffectID, 174) == TRUE then
            return FALSE
        end
    end

    -- 100630 "[HKS] Throw related"
    if env(GetSpEffectID, 100630) == TRUE and ExecFallAttack() == TRUE then
        return TRUE
    elseif request == ATTACK_REQUEST_RIGHT_LIGHT then
        if artsr1 == TRUE then
            SetSwordArtsPointInfo(ACTION_ARM_R1, TRUE, r1)

            if r1 == "W_DrawStanceRightAttackLight" then
                SetSwordArtsWepCategory_DrawStanceRightAttackLight()
            end
        end

        --- 135 "[HKS] Light Sub Start Type 0"
        --- 136 "[HKS] Light Sub Start Type 1"
        --- 137 "[HKS] Light Sub Start Type 2"
        --- 138 "[HKS] Light Sub Start Type 3"
        if r1 == "W_AttackRightLightSubStart" then
            if env(GetSpEffectID, 135) == TRUE then
                SetVariable("AttackLightSubStartType", 0)
            elseif env(GetSpEffectID, 136) == TRUE then
                SetVariable("AttackLightSubStartType", 1)
            elseif env(GetSpEffectID, 137) == TRUE then
                SetVariable("AttackLightSubStartType", 2)
            elseif env(GetSpEffectID, 138) == TRUE then
                SetVariable("AttackLightSubStartType", 3)
            else
                r1 = "W_AttackRightLight2"
            end
        end

        if r1 == "W_AttackRightLightStealth" and IsUseStealthAttack(FALSE) == FALSE then
            r1 = "W_AttackRightLightStep"
        end

        if GetEquipType(HAND_RIGHT, WEAPON_CATEGORY_STAFF) == TRUE and r1 ~= "W_AttackRightLight2" and r1 ~= "W_AttackRightLight3" then
            r1 = "W_AttackRightLight1"
        end
        ExecEventAllBody(r1)
    elseif request == ATTACK_REQUEST_RIGHT_HEAVY then
        if artsr2 == TRUE then
            SetSwordArtsPointInfo(ACTION_ARM_R2, TRUE, r2)
        end

        local IsEnableSpecialAttack = FALSE

        -- Barbaric Roar: Heavy Special
        if env(GetSpEffectID, 1681) == TRUE or env(GetSpEffectID, 1686) == TRUE then
            IsEnableSpecialAttack = TRUE
            SetVariable("AttackRightHeavySpecialType", 0)
        end

        -- War Cry: Heavy Special
        if env(GetSpEffectID, 1811) == TRUE or env(GetSpEffectID, 1816) == TRUE then
            IsEnableSpecialAttack = TRUE
            SetVariable("AttackRightHeavySpecialType", 1)
        end

        -- Unknown: Heavy Special
        if env(GetSpEffectID, 1716) == TRUE then
            IsEnableSpecialAttack = TRUE
            SetVariable("AttackRightHeavySpecialType", 0)
        end

        -- Unknown: Heavy Special
        if env(GetSpEffectID, 1721) == TRUE then
            IsEnableSpecialAttack = TRUE
            SetVariable("AttackRightHeavySpecialType", 0)
        end

        if IsEnableSpecialAttack == TRUE then
            if r2 == "W_AttackRightHeavy1Start" then
                r2 = "W_AttackRightHeavySpecial1Start"
            elseif r2 == "W_AttackRightHeavy1SubStart" then
                r2 = "W_AttackRightHeavySpecial1SubStart"
            elseif r2 == "W_AttackRightHeavy2Start" then
                r2 = "W_AttackRightHeavySpecial2Start"
            end
        end

        ExecEventAllBody(r2)
    elseif request == ATTACK_REQUEST_LEFT_LIGHT then
        atk_hand = HAND_LEFT
        guard_hand = HAND_LEFT
        ExecEventAllBody(l1)
    elseif request == ATTACK_REQUEST_LEFT_HEAVY then
        atk_hand = HAND_LEFT
        guard_hand = HAND_LEFT
        ExecEventAllBody(l2)
    elseif request == ATTACK_REQUEST_BOTH_LIGHT then
        if artsr1 == TRUE then
            SetSwordArtsPointInfo(ACTION_ARM_R1, TRUE, b1)
            if b1 == "W_DrawStanceRightAttackLight" then
                SetSwordArtsWepCategory_DrawStanceRightAttackLight()
            end
        end

        --- 135 "[HKS] Light Sub Start Type 0"
        --- 136 "[HKS] Light Sub Start Type 1"
        --- 137 "[HKS] Light Sub Start Type 2"
        --- 138 "[HKS] Light Sub Start Type 3"
        if b1 == "W_AttackBothLightSubStart" then
            if env(GetSpEffectID, 135) == TRUE then
                SetVariable("AttackLightSubStartType", 0)
            elseif env(GetSpEffectID, 136) == TRUE then
                SetVariable("AttackLightSubStartType", 1)
            elseif env(GetSpEffectID, 137) == TRUE then
                SetVariable("AttackLightSubStartType", 2)
            elseif env(GetSpEffectID, 138) == TRUE then
                SetVariable("AttackLightSubStartType", 3)
            else
                b1 = "W_AttackBothLight2"
            end
        end

        if b1 == "W_AttackBothLightStealth" and IsUseStealthAttack(FALSE) == FALSE then
            b1 = "W_AttackBothLightStep"
        end

        local staff_hand = HAND_RIGHT

        if c_Style == HAND_LEFT_BOTH then
            staff_hand = HAND_LEFT
        end

        if GetEquipType(staff_hand, WEAPON_CATEGORY_STAFF) == TRUE and b1 ~= "W_AttackBothLight2" and b1 ~= "W_AttackBothLight3" then
            b1 = "W_AttackBothLight1"
        end

        ExecEventAllBody(b1)
    elseif request == ATTACK_REQUEST_BOTH_LEFT then
        if r1 == "W_AttackRightLightDash" then
            l1 = "W_AttackBothLeftDash"
        elseif r1 == "W_AttackRightLightStep" then
            l1 = "W_AttackBothLeftStep"
        elseif l1 == "W_AttackLeftLight1" then
            l1 = "W_AttackBothLeft1"
        elseif l1 == "W_AttackLeftLight2" then
            l1 = "W_AttackBothLeft2"
        end

        ExecEventAllBody(l1)
    elseif request == ATTACK_REQUEST_BOTH_HEAVY then
        if artsr2 == TRUE then
            SetSwordArtsPointInfo(ACTION_ARM_R2, TRUE, b2)
        end

        local IsEnableSpecialAttack = FALSE

        -- Barbaric Roar: Heavy Special
        if c_Style == HAND_RIGHT_BOTH then
            if env(GetSpEffectID, 1681) == TRUE or env(GetSpEffectID, 1686) == TRUE then
                IsEnableSpecialAttack = TRUE
                SetVariable("AttackRightHeavySpecialType", 0)
            end
        elseif c_Style == HAND_LEFT_BOTH and (env(GetSpEffectID, 1683) == TRUE or env(GetSpEffectID, 1688) == TRUE) then
            IsEnableSpecialAttack = TRUE
            SetVariable("AttackRightHeavySpecialType", 0)
        end

        -- War Cry: Heavy Special
        if c_Style == HAND_RIGHT_BOTH then
            if env(GetSpEffectID, 1811) == TRUE or env(GetSpEffectID, 1816) == TRUE or env(GetSpEffectID, 1861) == TRUE then
                IsEnableSpecialAttack = TRUE
                SetVariable("AttackRightHeavySpecialType", 1)
            end
        elseif c_Style == HAND_LEFT_BOTH and (env(GetSpEffectID, 1813) == TRUE or env(GetSpEffectID, 1818) == TRUE or env(GetSpEffectID, 1863) == TRUE) then
            IsEnableSpecialAttack = TRUE
            SetVariable("AttackRightHeavySpecialType", 1)
        end

        -- Unknown: Heavy Special
        if c_Style == HAND_RIGHT_BOTH then
            if env(GetSpEffectID, 1716) == TRUE then
                IsEnableSpecialAttack = TRUE
                SetVariable("AttackRightHeavySpecialType", 0)
            end
        elseif c_Style == HAND_LEFT_BOTH and env(GetSpEffectID, 1718) == TRUE then
            IsEnableSpecialAttack = TRUE
            SetVariable("AttackRightHeavySpecialType", 0)
        end

        -- Unknown: Heavy Special
        if c_Style == HAND_RIGHT_BOTH then
            if env(GetSpEffectID, 1721) == TRUE then
                IsEnableSpecialAttack = TRUE
                SetVariable("AttackRightHeavySpecialType", 0)
            end
        elseif c_Style == HAND_LEFT_BOTH and env(GetSpEffectID, 1723) == TRUE then
            IsEnableSpecialAttack = TRUE
            SetVariable("AttackRightHeavySpecialType", 0)
        end

        if IsEnableSpecialAttack == TRUE then
            if b2 == "W_AttackBothHeavy1Start" then
                b2 = "W_AttackBothHeavySpecial1Start"
            elseif b2 == "W_AttackBothHeavy1SubStart" then
                b2 = "W_AttackBothHeavySpecial1SubStart"
            elseif b2 == "W_AttackBothHeavy2Start" then
                b2 = "W_AttackBothHeavySpecial2Start"
            end
        end
        ExecEventAllBody(b2)
    elseif request == ATTACK_REQUEST_DUAL_RIGHT then
        if r1 == "W_AttackRightLightDash" then
            l1 = "W_AttackDualDash"
        elseif r1 == "W_AttackRightLightStep" then
            l1 = "W_AttackDualRolling"
        elseif r1 == "W_AttackRightBackstep" then
            l1 = "W_AttackDualBackStep"
        elseif r1 == "W_AttackRightLightStealth" then
            if IsUseStealthAttack(TRUE) == FALSE then
                l1 = "W_AttackDualRolling"
            else
                l1 = "W_AttackDualStealth"
            end
        elseif l1 == "W_AttackLeftLight1" then
            l1 = "W_AttackDualLight1"
        elseif l1 == "W_AttackLeftLight2" then
            l1 = "W_AttackDualLight2"
        elseif l1 == "W_AttackLeftLight3" then
            l1 = "W_AttackDualLight3"
        elseif l1 == "W_AttackLeftLight4" then
            l1 = "W_AttackDualLight4"
        elseif l1 == "W_AttackLeftLight5" then
            l1 = "W_AttackDualLight5"
        elseif l1 == "W_AttackLeftLight6" then
            l1 = "W_AttackDualLight6"
        else
            l1 = "W_AttackDualLight1"
        end

        is_Dual = TRUE
        ExecEventAllBody(l1)
    elseif request == ATTACK_REQUEST_ARROW_BOTH_RIGHT then
        if c_Style ~= HAND_RIGHT_BOTH and c_Style ~= HAND_LEFT_BOTH and ExecHandChange(HAND_RIGHT, TRUE, blend_type) == TRUE then
            return TRUE
        else
            return FALSE
        end
    elseif request == ATTACK_REQUEST_ARROW_BOTH_LEFT then
        if c_Style ~= HAND_RIGHT_BOTH and c_Style ~= HAND_LEFT_BOTH and ExecHandChange(HAND_LEFT, TRUE, blend_type) == TRUE then
            return TRUE
        else
            return FALSE
        end
    elseif request == ATTACK_REQUEST_LEFT_REVERSAL then
        ExecEventAllBody("W_AttackLeftReversal")
    elseif request == SWORDARTS_REQUEST_LEFT_NORMAL then
        SetSwordArtsPointInfo(ACTION_ARM_L2, TRUE)
        atk_hand = HAND_LEFT
        guard_hand = HAND_LEFT

        if IsAttackSwordArts(c_SwordArtsID) == FALSE then
            is_find_atk = FALSE
        end

        local idle_cat = env(GetStayAnimCategory)
        local wep_cat = env(GetEquipWeaponCategory, c_SwordArtsHand)
        local arts_diff_cat = GetSwordArtsDiffCategory(c_SwordArtsID, idle_cat, wep_cat)
        local arts_idx = 0

        if arts_diff_cat == SWORD_ART_DIFF_CAT_LARGE_WEAPON then
            arts_idx = 1
        elseif arts_diff_cat == SWORD_ART_DIFF_CAT_POLEARM then
            arts_idx = 2
        elseif arts_diff_cat == SWORD_ART_DIFF_CAT_LARGE_WEAPON_SMALL_SHIELD then
            arts_idx = 3
        elseif arts_diff_cat == SWORD_ART_DIFF_CAT_POLEARM_SMALL_SHIELD then
            arts_idx = 4
        elseif arts_diff_cat == SWORD_ART_DIFF_CAT_LARGE_WEAPON_LARGE_SHIELD then
            arts_idx = 5
        elseif arts_diff_cat == SWORD_ART_DIFF_CAT_LARGE_WEAPON_SMALL_SHIELD then
            arts_idx = 6
        elseif arts_diff_cat == WEAPON_CATEGORY_SHORT_SWORD then
            arts_idx = 7
        elseif arts_diff_cat == WEAPON_CATEGORY_CURVEDSWORD then
            arts_idx = 8
        elseif arts_diff_cat == WEAPON_CATEGORY_LARGE_SHIELD then
            arts_idx = 9
        elseif arts_diff_cat == WEAPON_CATEGORY_SMALL_SHIELD then
            arts_idx = 10
        end

        SetVariable("SwordArtsOneShotShieldCategory", arts_idx)

        -- Torch Attack
        if c_SwordArtsID == 17 then
            SetVariable("SwordArtsOneShotComboCategory", 0)
        end

        if IsHalfBlendArts(c_SwordArtsID) == TRUE then
            ExecEventHalfBlend(Event_SwordArtsHalfOneShotShieldLeft, blend_type)
        else
            ExecEventAllBody("W_SwordArtsOneShotShieldLeft")
        end
    elseif request == SWORDARTS_REQUEST_BOTH_NORMAL then
        SetSwordArtsPointInfo(ACTION_ARM_L2, TRUE)

        if IsAttackSwordArts(c_SwordArtsID) == FALSE then
            is_find_atk = FALSE
        end

        local idle_cat = env(GetStayAnimCategory)
        local wep_cat = env(GetEquipWeaponCategory, c_SwordArtsHand)
        local arts_diff_cat = GetSwordArtsDiffCategory(c_SwordArtsID, idle_cat, wep_cat)

        if IsHalfBlendArts(c_SwordArtsID) == TRUE then
            if HAND_LEFT == c_SwordArtsHand then
                local arts_idx = 0

                if arts_diff_cat == SWORD_ART_DIFF_CAT_LARGE_WEAPON then
                    arts_idx = 1
                elseif arts_diff_cat == SWORD_ART_DIFF_CAT_POLEARM then
                    arts_idx = 2
                elseif arts_diff_cat == SWORD_ART_DIFF_CAT_LARGE_WEAPON_SMALL_SHIELD then
                    arts_idx = 3
                elseif arts_diff_cat == SWORD_ART_DIFF_CAT_POLEARM_SMALL_SHIELD then
                    arts_idx = 4
                elseif arts_diff_cat == SWORD_ART_DIFF_CAT_LARGE_WEAPON_LARGE_SHIELD then
                    arts_idx = 5
                elseif arts_diff_cat == SWORD_ART_DIFF_CAT_LARGE_WEAPON_SMALL_SHIELD then
                    arts_idx = 6
                elseif arts_diff_cat == WEAPON_CATEGORY_SHORT_SWORD then
                    arts_idx = 7
                elseif arts_diff_cat == WEAPON_CATEGORY_CURVEDSWORD then
                    arts_idx = 8
                elseif arts_diff_cat == WEAPON_CATEGORY_LARGE_SHIELD then
                    arts_idx = 9
                elseif arts_diff_cat == WEAPON_CATEGORY_SMALL_SHIELD then
                    arts_idx = 10
                end

                SetVariable("SwordArtsOneShotShieldCategory", arts_idx)
                ExecEventHalfBlend(Event_SwordArtsHalfOneShotShieldLeft, blend_type)
            else
                local arts_idx = 0

                if arts_diff_cat == SWORD_ART_DIFF_CAT_LARGE_WEAPON then
                    arts_idx = 1
                elseif arts_diff_cat == SWORD_ART_DIFF_CAT_POLEARM then
                    arts_idx = 2
                elseif arts_diff_cat == WEAPON_CATEGORY_SHORT_SWORD then
                    arts_idx = 3
                elseif arts_diff_cat == WEAPON_CATEGORY_TWINBLADE then
                    arts_idx = 4
                elseif arts_diff_cat == WEAPON_CATEGORY_CURVEDSWORD then
                    arts_idx = 5
                elseif arts_diff_cat == WEAPON_CATEGORY_FIST then
                    arts_idx = 6
                elseif arts_diff_cat == WEAPON_CATEGORY_LARGE_SHIELD then
                    arts_idx = 7
                elseif arts_diff_cat == WEAPON_CATEGORY_SMALL_SHIELD then
                    arts_idx = 8
                end

                SetVariable("SwordArtsOneShotCategory", arts_idx)
                ExecEventHalfBlend(Event_SwordArtsHalfOneShot, blend_type)
            end
        else
            local arts_idx = 0

            if arts_diff_cat == WEAPON_CATEGORY_SHORT_SWORD then
                arts_idx = 1
            elseif arts_diff_cat == WEAPON_CATEGORY_CURVEDSWORD then
                arts_idx = 2
            elseif arts_diff_cat == WEAPON_CATEGORY_LARGE_SHIELD then
                arts_idx = 3
            elseif arts_diff_cat == WEAPON_CATEGORY_SMALL_SHIELD then
                arts_idx = 4
            end

            SetVariable("SwordArtsOneShotShieldCategory", arts_idx)
            ExecEventAllBody("W_SwordArtsOneShotShieldBoth")
        end
    elseif request == SWORDARTS_REQUEST_RIGHT_NORMAL then
        SetSwordArtsPointInfo(ACTION_ARM_L2, TRUE)

        if IsAttackSwordArts(c_SwordArtsID) == FALSE then
            is_find_atk = FALSE
        end

        local idle_cat = env(GetStayAnimCategory)
        local wep_cat = env(GetEquipWeaponCategory, c_SwordArtsHand)
        local arts_diff_cat = GetSwordArtsDiffCategory(c_SwordArtsID, idle_cat, wep_cat)
        local arts_idx = 0

        if arts_diff_cat == SWORD_ART_DIFF_CAT_LARGE_WEAPON then
            arts_idx = 1
        elseif arts_diff_cat == SWORD_ART_DIFF_CAT_POLEARM then
            arts_idx = 2
        elseif arts_diff_cat == WEAPON_CATEGORY_SHORT_SWORD then
            arts_idx = 3
        elseif arts_diff_cat == WEAPON_CATEGORY_TWINBLADE then
            arts_idx = 4
        elseif arts_diff_cat == WEAPON_CATEGORY_CURVEDSWORD then
            arts_idx = 5
        elseif arts_diff_cat == WEAPON_CATEGORY_FIST then
            arts_idx = 6
        elseif arts_diff_cat == WEAPON_CATEGORY_LARGE_SHIELD then
            arts_idx = 7
        elseif arts_diff_cat == WEAPON_CATEGORY_SMALL_SHIELD then
            arts_idx = 8
        end

        SetVariable("SwordArtsOneShotCategory", arts_idx)

        local combo_idx = 0
        if arts_diff_cat == SWORD_ART_DIFF_CAT_LARGE_WEAPON then
            combo_idx = 1
        elseif arts_diff_cat == SWORD_ART_DIFF_CAT_POLEARM then
            combo_idx = 2
        elseif arts_diff_cat == WEAPON_CATEGORY_TWINBLADE then
            combo_idx = 3
        elseif arts_diff_cat == WEAPON_CATEGORY_CURVEDSWORD then
            combo_idx = 4
        end

        SetVariable("SwordArtsOneShotComboCategory", combo_idx)

        if IsHalfBlendArts(c_SwordArtsID) == TRUE then
            ExecEventHalfBlend(Event_SwordArtsHalfOneShot, blend_type)
        else
            ExecEventAllBody("W_SwordArtsOneShot")
        end
    elseif request == SWORDARTS_REQUEST_RIGHT_STEP then
        act(DebugLogOutput, "SwordArtsRolling request" .. request)

        if IsAttackSwordArts(c_SwordArtsID) == FALSE then
            is_find_atk = FALSE
        end

        local rollingAngle = c_ArtsRollingAngle

        if GetVariable("MoveSpeedLevel") > 0.20000000298023224 then
            rollingAngle = GetVariable("MoveAngle")
        end

        local turn_angle_real = 200
        local is_self_trans = FALSE
        local is_self_trans_2 = FALSE
        if TRUE == IsNodeActive("SwordArtsRolling Selector MP") or TRUE == IsNodeActive("SwordArtsRolling Selector MP_SelfTrans2") then
            is_self_trans = TRUE
        elseif TRUE == IsNodeActive("SwordArtsRolling Selector MP_SelfTrans") or env(GetSpEffectID, 100710) == TRUE then
            is_self_trans_2 = TRUE
        end

        local f74_local1 = nil

        if not (GetVariable("IsLockon") ~= false or env(IsPrecisionShoot) ~= FALSE or env(IsCOMPlayer) ~= FALSE) or env(GetSpEffectID, 100002) == TRUE then
            f74_local1 = 0
        else
            f74_local1 = nil
            local adjusted_roll_angle = nil

            if rollingAngle <= GetVariable("RollingAngleThresholdRightFrontTest") and rollingAngle >= GetVariable("RollingAngleThresholdLeftFrontTest") then
                f74_local1 = 0
                adjusted_roll_angle = rollingAngle
            elseif rollingAngle > GetVariable("RollingAngleThresholdRightFrontTest") and rollingAngle < GetVariable("RollingAngleThresholdRightBackTest") then
                f74_local1 = 3
                adjusted_roll_angle = rollingAngle - 90
            elseif rollingAngle < GetVariable("RollingAngleThresholdLeftFrontTest") and rollingAngle > GetVariable("RollingAngleThresholdLeftBackTest") then
                f74_local1 = 2
                adjusted_roll_angle = rollingAngle + 90
            else
                f74_local1 = 1
                adjusted_roll_angle = rollingAngle - 180
            end

            turn_angle_real = math.abs(GetVariable("TurnAngle") - rollingAngle)

            if turn_angle_real > 180 then
                turn_angle_real = 360 - turn_angle_real
            end

            if GetVariable("IsLockon") == true then
                act(TurnToLockonTargetImmediately, adjusted_roll_angle)
            else
                act(Unknown2029, adjusted_roll_angle)
            end
        end

        if is_self_trans == TRUE then
            SetVariable("SwordArtsRollingDirection_SelfTrans", f74_local1)
            SetVariable("RollingAngleRealSelftrans", rollingAngle)
        elseif is_self_trans_2 == TRUE then
            SetVariable("SwordArtsRollingDirection_SelfTrans2", f74_local1)
            SetVariable("RollingAngleReal", rollingAngle)
        else
            SetVariable("SwordArtsRollingDirection", f74_local1)
            SetVariable("RollingAngleReal", rollingAngle)
        end

        SetVariable("TurnAngleReal", turn_angle_real)
        SetSwordArtsPointInfo(ACTION_ARM_L2, TRUE)

        if GetVariable("IsEnoughArtPointsL2") == 1 then
            AddStamina(STAMINA_REDUCE_ARTS_QUICKSTEP * STAMINA_CONSUMERATE_LOWSTATUS)
        else
            AddStamina(STAMINA_REDUCE_ARTS_QUICKSTEP)
        end
        local arts_idx = 0
        SetWeightIndex()
        if GetVariable("EvasionWeightIndex") == MOVE_WEIGHT_LIGHT then
            arts_idx = 1
        end
        SetVariable("SwordArtsRollingWeightCategory", arts_idx)
        act(AddSpEffect, 100710)
        if is_self_trans == TRUE then
            ExecEventAllBody("W_SwordArtsRolling_SelfTrans")
        elseif is_self_trans_2 == TRUE then
            ExecEventAllBody("W_SwordArtsRolling_SelfTrans2")
        else
            ExecEventAllBody("W_SwordArtsRolling")
        end
    elseif request == SWORDARTS_REQUEST_RIGHT_COMBO_1 then
        if FALSE == IsAttackSwordArts(c_SwordArtsID) then
            is_find_atk = FALSE
        end

        SetSwordArtsPointInfo(ACTION_ARM_R2, TRUE)

        if IsHalfBlendArts(c_SwordArtsID) == TRUE then
            ExecEventHalfBlend(Event_SwordArtsHalfOneShotCombo1, blend_type)
        else
            ExecEventAllBody("W_SwordArtsOneShotComboEnd")
        end
    elseif request == SWORDARTS_REQUEST_RIGHT_COMBO_2 then
        if FALSE == IsAttackSwordArts(c_SwordArtsID) then
            is_find_atk = FALSE
        end

        SetSwordArtsPointInfo(ACTION_ARM_R2, TRUE, "W_SwordArtsOneShotComboEnd_2")

        if IsHalfBlendArts(c_SwordArtsID) == TRUE then
            ExecEventHalfBlend(Event_SwordArtsHalfOneShotCombo2, blend_type)
        else
            ExecEventAllBody("W_SwordArtsOneShotComboEnd_2")
        end
    elseif request == ATTACK_REQUEST_ARROW_FIRE_RIGHT or request == ATTACK_REQUEST_ARROW_FIRE_RIGHT2 then
        is_find_atk = FALSE

        if env(IsOutOfAmmo, 1) == TRUE then
            ExecEventAllBody("W_NoArrow")
        elseif env(GetEquipWeaponCategory, HAND_RIGHT) == WEAPON_CATEGORY_LARGE_ARROW then
            ExecEventHalfBlend(Event_AttackArrowRightStart, ALLBODY)
        elseif TRUE == GetEquipType(HAND_RIGHT, WEAPON_CATEGORY_SMALL_ARROW) and (not (FALSE ~= c_IsStealth or r1 ~= "W_AttackRightLightStep") or is_stealth_rolling == TRUE or r1 == "W_AttackRightLightDash" or r1 == "W_AttackRightBackstep") then
            ExecEventAllBody("W_AttackArrowRightFireStep")
        elseif c_IsStealth == TRUE then
            ExecEventHalfBlend(Event_StealthAttackArrowStart, ALLBODY)
        else
            ExecEventHalfBlend(Event_AttackArrowRightStart, blend_type)
        end
    elseif request == ATTACK_REQUEST_ARROW_FIRE_LEFT or request == ATTACK_REQUEST_ARROW_FIRE_LEFT2 then
        is_find_atk = FALSE

        if env(IsOutOfAmmo, 0) == TRUE then
            ExecEventAllBody("W_NoArrow")
        elseif env(GetEquipWeaponCategory, HAND_LEFT) == WEAPON_CATEGORY_LARGE_ARROW then
            ExecEventHalfBlend(Event_AttackArrowLeftStart, ALLBODY)
        elseif TRUE == GetEquipType(HAND_LEFT, WEAPON_CATEGORY_SMALL_ARROW) and (not (FALSE ~= c_IsStealth or r1 ~= "W_AttackRightLightStep") or is_stealth_rolling == TRUE or r1 == "W_AttackRightLightDash" or r1 == "W_AttackRightBackstep") then
            ExecEventAllBody("W_AttackArrowLeftFireStep")
        elseif c_IsStealth == TRUE then
            ExecEventHalfBlend(Event_StealthAttackArrowStart, ALLBODY)
        else
            ExecEventHalfBlend(Event_AttackArrowLeftStart, blend_type)
        end
    elseif request == ATTACK_REQUEST_RIGHT_CROSSBOW or request == ATTACK_REQUEST_RIGHT_CROSSBOW2 then
        is_find_atk = FALSE

        if blend_type == ALLBODY then
            local move_event = Event_Move

            if c_IsStealth == TRUE then
                move_event = Event_Stealth_Move
            end

            if MoveStart(LOWER, move_event, FALSE) == TRUE then
                blend_type = UPPER
            end
        end

        local crossbowHand = HAND_RIGHT

        if c_Style == HAND_LEFT_BOTH then
            crossbowHand = HAND_LEFT
        end

        if env(IsOutOfAmmo, 1) == TRUE then
            if c_IsStealth == TRUE and GetEquipType(crossbowHand, WEAPON_CATEGORY_BALLISTA) == FALSE then
                ExecEventHalfBlend(Event_StealthAttackCrossbowRightEmpty, blend_type)
            else
                ExecEventHalfBlend(Event_AttackCrossbowRightEmpty, blend_type)
            end
        elseif env(GetBoltLoadingState, 1) == FALSE and GetEquipType(crossbowHand, WEAPON_CATEGORY_BALLISTA) == FALSE then
            if c_IsStealth == TRUE then
                ExecEventHalfBlend(Event_StealthAttackCrossbowRightReload, blend_type)
            else
                ExecEventHalfBlend(Event_AttackCrossbowRightReload, blend_type)
            end
        elseif c_IsStealth == TRUE and GetEquipType(crossbowHand, WEAPON_CATEGORY_BALLISTA) == FALSE then
            ExecEventHalfBlend(Event_StealthAttackCrossbowRightStart, blend_type)
        else
            ExecEventHalfBlend(Event_AttackCrossbowRightStart, blend_type)
        end
    elseif request == ATTACK_REQUEST_LEFT_CROSSBOW or request == ATTACK_REQUEST_LEFT_CROSSBOW2 then
        is_find_atk = FALSE
        atk_hand = HAND_LEFT
        guard_hand = HAND_LEFT

        if blend_type == ALLBODY then
            local move_event = Event_Move

            if c_IsStealth == TRUE and FALSE == GetEquipType(HAND_LEFT, WEAPON_CATEGORY_BALLISTA) then
                move_event = Event_Stealth_Move
            end

            if MoveStart(LOWER, move_event, FALSE) == TRUE then
                blend_type = UPPER
            end
        end

        if env(IsOutOfAmmo, 0) == TRUE then
            if c_IsStealth == TRUE and FALSE == GetEquipType(HAND_LEFT, WEAPON_CATEGORY_BALLISTA) then
                ExecEventHalfBlend(Event_StealthAttackCrossbowLeftEmpty, blend_type)
            else
                ExecEventHalfBlend(Event_AttackCrossbowLeftEmpty, blend_type)
            end
        elseif env(GetBoltLoadingState, 0) == FALSE and FALSE == GetEquipType(HAND_LEFT, WEAPON_CATEGORY_BALLISTA) then
            if c_IsStealth == TRUE then
                ExecEventHalfBlend(Event_StealthAttackCrossbowLeftReload, blend_type)
            else
                ExecEventHalfBlend(Event_AttackCrossbowLeftReload, blend_type)
            end
        elseif c_IsStealth == TRUE and FALSE == GetEquipType(HAND_LEFT, WEAPON_CATEGORY_BALLISTA) then
            ExecEventHalfBlend(Event_StealthAttackCrossbowLeftStart, blend_type)
        else
            ExecEventHalfBlend(Event_AttackCrossbowLeftStart, blend_type)
        end
    elseif request == ATTACK_REQUEST_BOTHRIGHT_CROSSBOW or request == ATTACK_REQUEST_BOTHRIGHT_CROSSBOW2 then
        is_find_atk = FALSE

        if blend_type == ALLBODY then
            local move_event = Event_Move

            if c_IsStealth == TRUE then
                move_event = Event_Stealth_Move
            end

            if MoveStart(LOWER, move_event, FALSE) == TRUE then
                blend_type = UPPER
            end
        end

        local arrowHand = 0

        if c_Style == HAND_RIGHT_BOTH then
            arrowHand = 1
        end

        if env(IsOutOfAmmo, arrowHand) == TRUE then
            if c_IsStealth == TRUE and GetEquipType(arrowHand, WEAPON_CATEGORY_BALLISTA) == FALSE then
                ExecEventHalfBlend(Event_StealthAttackCrossbowBothRightEmpty, blend_type)
            else
                ExecEventHalfBlend(Event_AttackCrossbowBothRightEmpty, blend_type)
            end
        elseif env(GetBoltLoadingState, arrowHand) == FALSE and GetEquipType(arrowHand, WEAPON_CATEGORY_BALLISTA) == FALSE then
            local crossbow_event = nil

            if c_IsStealth == TRUE then
                if c_Style == HAND_LEFT_BOTH then
                    crossbow_event = Event_StealthAttackCrossbowBothLeftReload
                else
                    crossbow_event = Event_StealthAttackCrossbowBothRightReload
                end
            elseif c_Style == HAND_LEFT_BOTH then
                crossbow_event = Event_AttackCrossbowBothLeftReload
            else
                crossbow_event = Event_AttackCrossbowBothRightReload
            end
            ExecEventHalfBlend(crossbow_event, blend_type)
        elseif c_IsStealth == TRUE and GetEquipType(arrowHand, WEAPON_CATEGORY_BALLISTA) == FALSE then
            ExecEventHalfBlend(Event_StealthAttackCrossbowBothRightStart, blend_type)
        else
            ExecEventHalfBlend(Event_AttackCrossbowBothRightStart, blend_type)
        end
    elseif request == ATTACK_REQUEST_BOTHLEFT_CROSSBOW or request == ATTACK_REQUEST_BOTHLEFT_CROSSBOW2 then
        is_find_atk = FALSE

        if blend_type == ALLBODY then
            local move_event = Event_Move

            if c_IsStealth == TRUE then
                move_event = Event_Stealth_Move
            end

            if MoveStart(LOWER, move_event, FALSE) == TRUE then
                blend_type = UPPER
            end
        end

        if env(IsOutOfAmmo, 0) == TRUE then
            if c_IsStealth == TRUE and FALSE == GetEquipType(HAND_LEFT, WEAPON_CATEGORY_BALLISTA) then
                ExecEventHalfBlend(Event_StealthAttackCrossbowBothLeftEmpty, blend_type)
            else
                ExecEventHalfBlend(Event_AttackCrossbowBothLeftEmpty, blend_type)
            end
        elseif env(GetBoltLoadingState, 0) == FALSE and FALSE == GetEquipType(HAND_LEFT, WEAPON_CATEGORY_BALLISTA) then
            if c_IsStealth == TRUE then
                ExecEventHalfBlend(Event_AttackCrossbowBothLeftReload, blend_type)
            else
                ExecEventHalfBlend(Event_AttackCrossbowBothLeftReload, blend_type)
            end
        elseif c_IsStealth == TRUE and FALSE == GetEquipType(HAND_LEFT, WEAPON_CATEGORY_BALLISTA) then
            ExecEventHalfBlend(Event_StealthAttackCrossbowBothLeftStart, blend_type)
        else
            ExecEventHalfBlend(Event_AttackCrossbowBothLeftStart, blend_type)
        end
    elseif request == ATTACK_REQUEST_ATTACK_WHILE_GUARD then
        guard_hand = HAND_LEFT
        local index = env(GetGuardMotionCategory, HAND_LEFT)

        if GetEquipType(HAND_LEFT, WEAPON_CATEGORY_TORCH) == TRUE then
            index = 2
            SetVariable("IsAttackWhileTorchGuard", TRUE)
        else
            SetVariable("IsAttackWhileTorchGuard", FALSE)
        end

        SetVariable("IndexAttackWhileGuard", index)
        ExecEventAllBody("W_AttackRightWhileGuard")
    else
        return FALSE
    end

    if is_find_atk == TRUE then
        SetInterruptType(INTERRUPT_FINDATTACK)
    end

    if style == HAND_RIGHT_BOTH then
        atk_hand = HAND_RIGHT
    elseif style == HAND_LEFT_BOTH then
        atk_hand = HAND_LEFT
    end

    SetAttackHand(atk_hand)
    SetGuardHand(guard_hand)

    if is_Dual == TRUE then
        act(SetThrowPossibilityState_Defender, 400000)
    end

    act(Unknown2025, env(Unknown404))
    SetAIActionState()

    return TRUE
end

-- Checks the max combo length
function IsEnableNextAttack(cur_attack_num, hand)
    local style = c_Style

    if style == HAND_LEFT_BOTH then
        hand = HAND_LEFT
    end

    local max_num = GetAttackMaxNumber(hand)

    DebugPrint(3, env(GetEquipWeaponCategory, hand))
    DebugPrint(4, max_num)
    DebugPrint(5, cur_attack_num)

    if cur_attack_num < max_num then
        return TRUE
    else
        return FALSE
    end
end

-- Get the maximum supported combo length for each type
function GetAttackMaxNumber(hand)
    local kind = env(GetEquipWeaponCategory, hand)
    local max_num = 1

    if kind == WEAPON_CATEGORY_ARROW or kind == WEAPON_CATEGORY_LARGE_ARROW or kind == WEAPON_CATEGORY_CROSSBOW or kind == WEAPON_CATEGORY_SMALL_ARROW then
        max_num = 1
    elseif kind == WEAPON_CATEGORY_EXTRALARGE_SWORD or kind == WEAPON_CATEGORY_EXTRALARGE_AXHAMMER or kind == WEAPON_CATEGORY_LARGE_SPEAR or kind == WEAPON_CATEGORY_LARGE_SHIELD or kind == WEAPON_CATEGORY_STAFF then
        max_num = 3
    elseif kind == WEAPON_CATEGORY_TORCH or kind == WEAPON_CATEGORY_LARGE_SWORD or kind == WEAPON_CATEGORY_FLAIL or kind == WEAPON_CATEGORY_LARGE_AX or kind == WEAPON_CATEGORY_LARGE_HAMMER or kind == WEAPON_CATEGORY_SPEAR or kind == WEAPON_CATEGORY_HALBERD or kind == WEAPON_CATEGORY_LARGE_CURVEDSWORD or kind == WEAPON_CATEGORY_SMALL_SHIELD or kind == WEAPON_CATEGORY_MIDDLE_SHIELD or kind == WEAPON_CATEGORY_LARGE_SCYTHE or kind == WEAPON_CATEGORY_WHIP or kind == 56 or kind == 57 then
        max_num = 4
    elseif kind == WEAPON_CATEGORY_STRAIGHT_SWORD or kind == WEAPON_CATEGORY_TWINBLADE or kind == WEAPON_CATEGORY_KATANA or kind == WEAPON_CATEGORY_AX or kind == WEAPON_CATEGORY_HAMMER or kind == WEAPON_CATEGORY_LARGE_RAPIER then
        max_num = 5
    elseif kind == WEAPON_CATEGORY_SHORT_SWORD or kind == WEAPON_CATEGORY_CLAW or kind == WEAPON_CATEGORY_RAPIER or kind == WEAPON_CATEGORY_CURVEDSWORD or kind == WEAPON_CATEGORY_FIST or kind == 55 or kind == 53 or kind == 58 or kind == 56 then
        max_num = 6
    end

    return max_num
end

-- Get the maximum supported combo length for each dual type
function GetDualAttackMaxNumber(hand)
    local kind = env(GetEquipWeaponCategory, hand)
    local max_num = 1

    if kind == WEAPON_CATEGORY_EXTRALARGE_SWORD or kind == WEAPON_CATEGORY_EXTRALARGE_AXHAMMER or kind == WEAPON_CATEGORY_LARGE_SPEAR or kind == WEAPON_CATEGORY_LARGE_SWORD or kind == WEAPON_CATEGORY_LARGE_AX or kind == WEAPON_CATEGORY_LARGE_HAMMER or kind == WEAPON_CATEGORY_SPEAR or kind == WEAPON_CATEGORY_HALBERD or kind == WEAPON_CATEGORY_LARGE_CURVEDSWORD or kind == WEAPON_CATEGORY_LARGE_SCYTHE or kind == WEAPON_CATEGORY_WHIP then
        max_num = 3
    elseif kind == WEAPON_CATEGORY_STRAIGHT_SWORD or kind == WEAPON_CATEGORY_TWINBLADE or kind == WEAPON_CATEGORY_KATANA or kind == WEAPON_CATEGORY_AX or kind == WEAPON_CATEGORY_HAMMER or kind == WEAPON_CATEGORY_FLAIL or kind == WEAPON_CATEGORY_LARGE_RAPIER or kind == WEAPON_CATEGORY_SHORT_SWORD or kind == WEAPON_CATEGORY_RAPIER or kind == WEAPON_CATEGORY_CURVEDSWORD or kind == WEAPON_CATEGORY_CAT56 or kind == WEAPON_CATEGORY_CAT57 then
        max_num = 4
    elseif kind == WEAPON_CATEGORY_CLAW or kind == WEAPON_CATEGORY_FIST or kind == WEAPON_CATEGORY_CAT53 or kind == WEAPON_CATEGORY_CAT55 or kind == WEAPON_CATEGORY_CAT58 or kind == WEAPON_CATEGORY_CAT59 then
        max_num = 6
    end

    return max_num
end

function IsEnableSpecialAttack(hand)
    local style = c_Style

    if style == HAND_LEFT_BOTH then
        hand = HAND_LEFT
    end

    env(GetEquipWeaponCategory, hand)

    if GetEquipType(hand, WEAPON_CATEGORY_RAPIER, WEAPON_CATEGORY_CURVEDSWORD, WEAPON_CATEGORY_LARGE_RAPIER) == TRUE then
        return TRUE
    else
        return FALSE
    end
end

function IsEnableDualWielding()
    if c_Style == HAND_RIGHT_BOTH or c_Style == HAND_LEFT_BOTH then
        return -1
    end

    local rightKind = env(GetEquipWeaponCategory, HAND_RIGHT)
    local leftKind = env(GetEquipWeaponCategory, HAND_LEFT)
    local rightSpecialKind = env(GetEquipWeaponSpecialCategoryNumber, HAND_RIGHT)
    local leftSpecialKind = env(GetEquipWeaponSpecialCategoryNumber, HAND_LEFT)

    if rightKind == WEAPON_CATEGORY_SHORT_SWORD then
        if rightSpecialKind == 104 then
            if leftSpecialKind == 104 then
                return HAND_RIGHT
            end
        elseif leftKind == WEAPON_CATEGORY_SHORT_SWORD and leftSpecialKind ~= 104 then
            return HAND_RIGHT
        end
    elseif rightKind == WEAPON_CATEGORY_CLAW then
        if leftKind == WEAPON_CATEGORY_CLAW then
            return HAND_RIGHT
        end
    elseif rightKind == WEAPON_CATEGORY_STRAIGHT_SWORD then
        if leftKind == WEAPON_CATEGORY_STRAIGHT_SWORD then
            return HAND_RIGHT
        end
    elseif rightKind == WEAPON_CATEGORY_TWINBLADE then
        if leftKind == WEAPON_CATEGORY_TWINBLADE then
            return HAND_RIGHT
        end
    elseif rightKind == WEAPON_CATEGORY_LARGE_SWORD then
        if leftKind == WEAPON_CATEGORY_LARGE_SWORD then
            return HAND_RIGHT
        end
    elseif rightKind == WEAPON_CATEGORY_EXTRALARGE_SWORD then
        if leftKind == WEAPON_CATEGORY_EXTRALARGE_SWORD then
            return HAND_RIGHT
        end
    elseif rightKind == WEAPON_CATEGORY_RAPIER then
        if leftKind == WEAPON_CATEGORY_RAPIER then
            return HAND_RIGHT
        end
    elseif rightKind == WEAPON_CATEGORY_CURVEDSWORD then
        if leftKind == WEAPON_CATEGORY_CURVEDSWORD then
            return HAND_RIGHT
        end
    elseif rightKind == WEAPON_CATEGORY_KATANA then
        if leftKind == WEAPON_CATEGORY_KATANA or leftSpecialKind == 104 then
            return HAND_RIGHT
        end
    elseif rightKind == WEAPON_CATEGORY_HAMMER then
        if leftKind == WEAPON_CATEGORY_HAMMER then
            return HAND_RIGHT
        end
    elseif rightKind == WEAPON_CATEGORY_AX then
        if leftKind == WEAPON_CATEGORY_AX then
            return HAND_RIGHT
        end
    elseif rightKind == WEAPON_CATEGORY_EXTRALARGE_AXHAMMER then
        if leftKind == WEAPON_CATEGORY_EXTRALARGE_AXHAMMER then
            return HAND_RIGHT
        end
    elseif rightKind == WEAPON_CATEGORY_LARGE_AX then
        if leftKind == WEAPON_CATEGORY_LARGE_AX then
            return HAND_RIGHT
        end
    elseif rightKind == WEAPON_CATEGORY_LARGE_HAMMER then
        if leftKind == WEAPON_CATEGORY_LARGE_HAMMER then
            return HAND_RIGHT
        end
    elseif rightKind == WEAPON_CATEGORY_FLAIL then
        if leftKind == WEAPON_CATEGORY_FLAIL then
            return HAND_RIGHT
        end
    elseif rightKind == WEAPON_CATEGORY_SPEAR then
        if leftKind == WEAPON_CATEGORY_SPEAR then
            return HAND_RIGHT
        end
    elseif rightKind == WEAPON_CATEGORY_LARGE_SPEAR then
        if leftKind == WEAPON_CATEGORY_LARGE_SPEAR then
            return HAND_RIGHT
        end
    elseif rightKind == WEAPON_CATEGORY_LARGE_RAPIER then
        if leftKind == WEAPON_CATEGORY_LARGE_RAPIER then
            return HAND_RIGHT
        end
    elseif rightKind == WEAPON_CATEGORY_HALBERD then
        if leftKind == WEAPON_CATEGORY_HALBERD then
            return HAND_RIGHT
        end
    elseif rightKind == WEAPON_CATEGORY_LARGE_CURVEDSWORD then
        if leftKind == WEAPON_CATEGORY_LARGE_CURVEDSWORD then
            return HAND_RIGHT
        end
    elseif rightKind == WEAPON_CATEGORY_FIST then
        if leftKind == WEAPON_CATEGORY_FIST then
            return HAND_RIGHT
        end
    elseif rightKind == WEAPON_CATEGORY_WHIP then
        if leftKind == WEAPON_CATEGORY_WHIP then
            return HAND_RIGHT
        end
    elseif rightKind == WEAPON_CATEGORY_LARGE_SCYTHE then
        if leftKind == WEAPON_CATEGORY_LARGE_SCYTHE then
            return HAND_RIGHT
        end
    elseif rightKind == WEAPON_CATEGORY_CAT53 then
        if leftKind == WEAPON_CATEGORY_CAT53 then
            return HAND_RIGHT
        end
    elseif rightKind == WEAPON_CATEGORY_CAT55 then
        if leftKind == WEAPON_CATEGORY_CAT55 then
            return HAND_RIGHT
        end
    elseif rightKind == WEAPON_CATEGORY_CAT56 then
        if leftKind == WEAPON_CATEGORY_CAT56 then
            return HAND_RIGHT
        end
    elseif rightKind == WEAPON_CATEGORY_CAT57 then
        if leftKind == WEAPON_CATEGORY_CAT57 then
            return HAND_RIGHT
        end
    elseif rightKind == WEAPON_CATEGORY_CAT58 then
        if leftKind == WEAPON_CATEGORY_CAT58 then
            return HAND_RIGHT
        end
    elseif rightKind == WEAPON_CATEGORY_CAT59 and leftKind == WEAPON_CATEGORY_CAT59 then
        return HAND_RIGHT
    end

    return -1
end

function IsUseStealthAttack(is_dual)
    -- 110 Broadsword
    -- 182 Morning Star
    -- 207 Serpent-Hunter
    -- 832 Starscourge Greatsword
    -- 852 Ornamental Straight Sword

    if is_dual == TRUE then
        if TRUE == GetEquipType(HAND_RIGHT, WEAPON_CATEGORY_STRAIGHT_SWORD, WEAPON_CATEGORY_TWINBLADE, WEAPON_CATEGORY_RAPIER, WEAPON_CATEGORY_CURVEDSWORD, WEAPON_CATEGORY_SPEAR, WEAPON_CATEGORY_LARGE_SPEAR) then
            return TRUE
        end
    else
        if c_Style == HAND_RIGHT_BOTH or c_Style == HAND_LEFT_BOTH then
            local hand = HAND_RIGHT

            if c_Style == HAND_LEFT_BOTH then
                hand = HAND_LEFT
            end

            local specialcategory = env(GetEquipWeaponSpecialCategoryNumber, hand)

            if specialcategory == 110 or specialcategory == 832 or specialcategory == 852 then
                return FALSE
            elseif specialcategory == 182 or specialcategory == 207 then
                return TRUE
            elseif GetEquipType(hand, WEAPON_CATEGORY_TORCH, WEAPON_CATEGORY_STRAIGHT_SWORD, WEAPON_CATEGORY_TWINBLADE, WEAPON_CATEGORY_EXTRALARGE_SWORD, WEAPON_CATEGORY_RAPIER, WEAPON_CATEGORY_LARGE_RAPIER, WEAPON_CATEGORY_CURVEDSWORD) == TRUE then
                return TRUE
            end
        end

        local hand = HAND_RIGHT
        local specialcategory = env(GetEquipWeaponSpecialCategoryNumber, HAND_RIGHT)

        if specialcategory == 110 then
            return FALSE
        elseif specialcategory == 182 or specialcategory == 207 then
            return TRUE
        elseif GetEquipType(hand, WEAPON_CATEGORY_TORCH, WEAPON_CATEGORY_STRAIGHT_SWORD, WEAPON_CATEGORY_TWINBLADE, WEAPON_CATEGORY_EXTRALARGE_SWORD, WEAPON_CATEGORY_RAPIER, WEAPON_CATEGORY_LARGE_RAPIER, WEAPON_CATEGORY_CURVEDSWORD) == TRUE then
            return TRUE
        end
    end

    return FALSE
end

function ExecArtsStance(blend_type)
    if c_IsEnableSwordArts == FALSE then
        return FALSE
    end
    local arts_id = c_SwordArtsID
    local is_arrow = GetEquipType(c_SwordArtsHand, WEAPON_CATEGORY_ARROW, WEAPON_CATEGORY_SMALL_ARROW, WEAPON_CATEGORY_LARGE_ARROW, WEAPON_CATEGORY_BALISTA)
    local is_crossbow = GetEquipType(HAND_LEFT, WEAPON_CATEGORY_CROSSBOW)

    if c_Style == HAND_RIGHT and (is_arrow == TRUE or is_crossbow == TRUE) then
        return FALSE
    elseif IsAttackStanceArts(arts_id) == TRUE then
        if env(GetStamina) <= 0 then
            return FALSE
        elseif FALSE == env(ActionRequest, ACTION_ARM_L2) then
            return FALSE
        end
    elseif GetEquipType(c_SwordArtsHand, WEAPON_CATEGORY_LARGE_ARROW) == TRUE then
        if FALSE == env(ActionRequest, ACTION_ARM_L2) or env(ActionDuration, ACTION_ARM_L2) <= 0 then
            return FALSE
        end
    elseif IsStanceArts(arts_id) == TRUE then
        if env(ActionDuration, ACTION_ARM_L2) <= 0 then
            return FALSE
        end
    else
        return FALSE
    end

    if c_IsStealth == TRUE then
        blend_type = ALLBODY
    end

    if blend_type == ALLBODY and MoveStart(LOWER, Event_Move, FALSE) == TRUE then
        blend_type = UPPER
    end

    SetSwordArtsPointInfo(ACTION_ARM_L2, TRUE)
    ExecEventHalfBlend(Event_DrawStanceRightStart, blend_type)

    act(Unknown2025, env(Unknown404))
    SetAIActionState()

    return TRUE
end

function ExecArtsStanceOnCancelTiming(blend_type)
    if env(IsWeaponCancelPossible) == TRUE and ExecArtsStance(blend_type) == TRUE then
        return TRUE
    else
        return FALSE
    end
end

function ExecMagic(quick_type, blend_type, is_ride)
    if c_HasActionRequest == FALSE then
        return FALSE
    elseif env(GetStamina) <= 0 then
        return FALSE
    elseif env(ActionDuration, ACTION_ARM_ACTION) > 0 then
        return FALSE
    elseif env(IsMagicUseMenuOpened) == TRUE then
        return FALSE
    elseif c_IsStealth == TRUE then
        blend_type = ALLBODY
    end

    local style = c_Style
    local magic_hand = HAND_RIGHT

    local action_arm = nil
    local action_arm_menu = nil

    -- Normal Catalysts
    -- R1/L1 (while riding)
    if env(ActionRequest, ACTION_ARM_MAGIC_R) == TRUE or env(ActionRequest, ACTION_ARM_MAGIC_L) == TRUE and is_ride == TRUE then
        action_arm = ACTION_ARM_MAGIC_R

        if style == HAND_LEFT_BOTH then
            if GetEquipType(HAND_LEFT, WEAPON_CATEGORY_STAFF) == FALSE then
                return FALSE
            end

            action_arm_menu = HAND_LEFT
        else
            if GetEquipType(HAND_RIGHT, WEAPON_CATEGORY_STAFF) == FALSE then
                return FALSE
            end

            action_arm_menu = HAND_RIGHT
        end
        -- L1
    elseif env(ActionRequest, ACTION_ARM_MAGIC_L) == TRUE then
        action_arm = ACTION_ARM_MAGIC_L

        if style == HAND_RIGHT_BOTH or style == HAND_LEFT_BOTH then
            return FALSE
        elseif FALSE == GetEquipType(HAND_LEFT, WEAPON_CATEGORY_STAFF) then
            return FALSE
        end

        action_arm_menu = HAND_LEFT
        magic_hand = HAND_LEFT

        act(DebugLogOutput, "MagicLeft")
    else
        return FALSE
    end

    -- Check if Player on Horse And Catalyst in Left Hand
    if env(ActionRequest, ACTION_ARM_MAGIC_L) == TRUE and FALSE == env(ActionRequest, ACTION_ARM_MAGIC_R) and is_ride == TRUE then
        ResetRequest()
        return FALSE
    end

    -- If Player using a Magic Menu with Hand that Catalyst is on, reset Event(?)
    if env(IsMagicUseMenuOpening, action_arm_menu) == TRUE then
        ResetRequest()
        act(OpenMenuWhenUsingMagic, action_arm)
        return TRUE
    end

    act(Unknown2026)
    act(MarkOfGreedyPersonSlipDamageDisable)

    local magic_index = env(GetMagicAnimType)

    g_MagicIndex = magic_index
    g_Magichand = action_arm_menu

    local lastMagicMem = lastUsedMagicAnim
    lastUsedMagicAnim = magic_index

    if blend_type == ALLBODY and is_ride == FALSE then
        local move_event = Event_Move

        if IsStealthMagic(magic_index) == TRUE and c_IsStealth == TRUE then
            move_event = Event_Stealth_Move
        end

        if MoveStart(LOWER, move_event, FALSE) == TRUE then
            blend_type = UPPER
        end
    end

    -- Check if Magic is not Usable on current Magic Hand
    if env(IsMagicUseable, action_arm_menu, 0) == FALSE then

        act(DebugLogOutput, "Event_MagicInvalid_Cannot_Use_Magic")
        SetVariable("IndexMagicHand", magic_hand)

        if is_ride == TRUE then
            ExecEventAllBody("W_RideMagicInvalid")
        else
            ExecEventHalfBlend(Event_MagicInvalid, blend_type)
        end

        act(SetIsMagicInUse, TRUE)
        act(Unknown2025, env(Unknown404))
        SetAIActionState()

        return TRUE

        -- Check if the Animation Type of the Magic is 254 or 255
    elseif magic_index == 254 or magic_index == 255 then
        SetVariable("IndexMagicHand", magic_hand)

        if is_ride == TRUE then
            ExecEventAllBody("W_RideMagicInvalid")
        else
            act(DebugLogOutput, "Event_MagicInvalid_InvalidMagic")
            ExecEventHalfBlend(Event_MagicInvalid, blend_type)
        end

        act(SetIsMagicInUse, TRUE)
        act(Unknown2025, env(Unknown404))
        SetAIActionState()

        return TRUE

        -- Else, check if Player is Enchanting a Weapon in the Left Hand
    elseif IsWeaponEnchantMagic() == TRUE and c_Style == HAND_LEFT_BOTH then
        SetVariable("IndexMagicHand", magic_hand)

        act(DebugLogOutput, "Event_MagicInvalid_Left")

        ExecEventHalfBlend(Event_MagicInvalid, blend_type)
        act(SetIsMagicInUse, TRUE)
        act(Unknown2025, env(Unknown404))
        SetAIActionState()

        return TRUE

        -- Else, check if the Animation Type of the Magic is something related to Magic for Shields
    elseif magic_index == MAGIC_REQUEST_ORDER_SHIELD then
        if TRUE == GetEquipType(HAND_LEFT, WEAPON_CATEGORY_LARGE_SHIELD) then
            SetVariable("MagicRight_ShieldCategory", 1)
        end
    else
        SetVariable("MagicRight_ShieldCategory", 0)
    end

    if magic_index == MAGIC_REQUEST_WHIP or magic_index == MAGIC_REQUEST_SLASH or magic_index == MAGIC_REQUEST_QUICKSLASH or magic_index == MAGIC_REQUEST_FLAME_GRAB or magic_index == MAGIC_REQUEST_CRUSH or magic_index == MAGIC_REQUEST_CHOP or magic_index == MAGIC_REQUEST_SCYTHE then
    end

    if ExecComboMagic(magic_hand, blend_type, lastMagicMem, magic_index) == TRUE then
    elseif ExecQuickMagic(magic_hand, quick_type, blend_type) == TRUE then
    elseif ExecStealthMagic(magic_hand, magic_index, blend_type) == TRUE then
    elseif is_ride == TRUE then
        ExecEventAllBody("W_RideMagicLaunch")
    elseif magic_hand == HAND_RIGHT and (magic_index ~= MAGIC_REQUEST_MAD_THROW or c_Style ~= HAND_LEFT_BOTH) then
        ExecEventHalfBlend(Event_MagicLaunchRight, blend_type)
    else
        ExecEventHalfBlend(Event_MagicLaunchLeft, blend_type)
    end

    act(SetIsMagicInUse, TRUE)
    act(Unknown2025, env(Unknown404))
    SetAIActionState()

    return TRUE
end

function ExecQuickMagic(magic_hand, quick_type, blend_type)
    if env(IsOnMount) == TRUE or IsQuickMagic() == FALSE then
        return FALSE
    elseif quick_type == QUICKTYPE_NORMAL or quick_type == QUICKTYPE_RUN then
        return FALSE
    elseif quick_type == QUICKTYPE_DASH then
        if magic_hand == HAND_RIGHT then
            ExecEventHalfBlend(Event_QuickMagicFireRightDash, blend_type)
            return TRUE
        else
            ExecEventHalfBlend(Event_QuickMagicFireLeftDash, blend_type)
            return TRUE
        end
    elseif quick_type == QUICKTYPE_ROLLING then
        if magic_hand == HAND_RIGHT then
            ExecEventHalfBlend(Event_QuickMagicFireRightStep, blend_type)
            return TRUE
        else
            ExecEventHalfBlend(Event_QuickMagicFireLeftStep, blend_type)
            return TRUE
        end
    elseif quick_type == QUICKTYPE_BACKSTEP then
        if magic_hand == HAND_RIGHT then
            ExecEventHalfBlend(Event_QuickMagicFireRightBackStep, blend_type)
            return TRUE
        else
            ExecEventHalfBlend(Event_QuickMagicFireLeftBackStep, blend_type)
            return TRUE
        end
    elseif quick_type == QUICKTYPE_ATTACK or quick_type == QUICKTYPE_COMBO then
        if ForwardLeg() == 1 then
            if magic_hand == HAND_RIGHT then
                ExecEventHalfBlend(Event_QuickMagicFireRightAttackRight, blend_type)
                return TRUE
            else
                ExecEventHalfBlend(Event_QuickMagicFireLeftAttackRight, blend_type)
                return TRUE
            end
        elseif magic_hand == HAND_RIGHT then
            ExecEventHalfBlend(Event_QuickMagicFireRightAttackLeft, blend_type)
            return TRUE
        else
            ExecEventHalfBlend(Event_QuickMagicFireLeftAttackLeft, blend_type)
            return TRUE
        end
    else
        return FALSE
    end
end

function ExecComboMagic(magic_hand, blend_type)
    -- 100600 "[HKS] Right Combo Magic 1: Window"
    -- 100601 "[HKS] Right Combo Magic 2: Window"
    -- 100605 "[HKS] Left Combo Magic 1: Window"
    -- 100606 "[HKS] Left Combo Magic 2: Window"

    if IsComboMagic() == FALSE then
        return FALSE
    elseif env(IsOnMount) == TRUE then
        if env(GetSpEffectID, 100600) == TRUE then
            ExecEventAllBody("W_RideMagicFireCombo1")
            return TRUE
        elseif env(GetSpEffectID, 100601) == TRUE then
            ExecEventAllBody("W_RideMagicFireCombo2")
            return TRUE
        else
            return FALSE
        end
    elseif magic_hand == HAND_RIGHT then
        if env(GetSpEffectID, 100600) == TRUE then
            ExecEventHalfBlend(Event_MagicFireRight2, blend_type)
            return TRUE
        elseif env(GetSpEffectID, 100601) == TRUE then
            ExecEventHalfBlend(Event_MagicFireRight3, blend_type)
            return TRUE
        else
            return FALSE
        end
    elseif env(GetSpEffectID, 100605) == TRUE then
        ExecEventHalfBlend(Event_MagicFireLeft2, blend_type)
        return TRUE
    elseif env(GetSpEffectID, 100606) == TRUE then
        ExecEventHalfBlend(Event_MagicFireLeft3, blend_type)
        return TRUE
    else
        return FALSE
    end
end

function ExecStealthMagic(magic_hand, magic_type, blend_type)
    if c_IsStealth == FALSE then
        return FALSE
    elseif IsStealthMagic(magic_type) == FALSE then
        return FALSE
    elseif magic_hand == HAND_RIGHT then
        ExecEventHalfBlend(Event_StealthMagicRightLaunch, blend_type)
        return TRUE
    else
        ExecEventHalfBlend(Event_StealthMagicLeftLaunch, blend_type)
        return TRUE
    end
end

function ExecGesture()
    if c_HasActionRequest == FALSE then
        return FALSE
    elseif FALSE == env(ActionRequest, ACTION_ARM_GESTURE) then
        return FALSE
    end

    local request = env(GetGestureRequestNumber)

    if request == 109 then
        request = 108
    end

    local animID = 80000 + request * 10

    SetVariable("GestureID", request)

    if request == INVALID then
        return FALSE
    end

    local isloop = FALSE

    if env(DoesAnimExist, animID + 1) == TRUE then
        isloop = TRUE
    end

    if isloop == TRUE then
        if GetLocomotionState() == PLAYER_STATE_MOVE then
            ExecEventHalfBlend(Event_GestureLoopStart, UPPER)
            return TRUE
        else
            ExecEventHalfBlend(Event_GestureLoopStart, ALLBODY)
            return TRUE
        end
    elseif GetLocomotionState() == PLAYER_STATE_MOVE then
        ExecEventHalfBlend(Event_GestureStart, UPPER)
        return TRUE
    else
        ExecEventHalfBlend(Event_GestureStart, ALLBODY)
        return TRUE
    end
end

function ExecStealthItem(blend_type, item_type)
    if item_type ~= ITEM_RECOVER and item_type ~= ITEM_SOUL and item_type ~= ITEM_DRINK and item_type ~= ITEM_DRINK_MP and item_type ~= ITEM_NO_DRINK and item_type ~= ITEM_EATJERKY and item_type ~= ITEM_ELIXIR and item_type ~= ITEM_SUMMONBUDDY and item_type ~= ITEM_RETURNBUDDY and item_type ~= ITEM_INVALID then
        return FALSE
    elseif blend_type == ALLBODY and MoveStart(LOWER, Event_Stealth_Move, FALSE) == TRUE then
        blend_type = UPPER
    end

    -- Flasks
    if item_type == ITEM_DRINK or item_type == ITEM_DRINK_MP then
        if TRUE == env(GetStateChangeType, CONDITION_TYPE_NO_EST) then
            ExecEventHalfBlend(Event_StealthItemDrinkNothing, blend_type)
        elseif TRUE == IsNodeActive("StealthItemDrinking_Upper_CMSG") then
            SetInterruptType(INTERRUPT_USEITEM)
            ExecEventHalfBlend(Event_StealthItemDrinking, blend_type)
        else
            SetInterruptType(INTERRUPT_USEITEM)
            ExecEventHalfBlend(Event_StealthItemDrinkStart, blend_type)
        end
    elseif item_type == ITEM_NO_DRINK then
        if TRUE == IsNodeActive("StealthItemDrinkingMP_Upper_CMSG") or TRUE == IsNodeActive("StealthItemDrinking_Upper_CMSG") then
            ExecEventHalfBlend(Event_StealthItemDrinkEmpty, blend_type)
        else
            ExecEventHalfBlend(Event_StealthItemDrinkStart, blend_type)
        end
    elseif TRUE == IsNodeActive("StealthItemOneShot_Blend") then
        SetVariable("IndexItemUseAnim_SelfTrans", item_type)
        ExecEventHalfBlend(Event_StealthItemOneShot_SelfTrans, blend_type)
    else
        SetVariable("IndexItemUseAnim", item_type)
        ExecEventHalfBlend(Event_StealthItemOneShot, blend_type)
    end

    act(SetIsItemAnimationPlaying)
    act(Unknown2025, env(Unknown404))
    SetAIActionState()

    return TRUE
end

function IsUseStaminaItem(item_type)
    if item_type == ITEM_THROW_KNIFE or item_type == ITEM_THROW_BOTTLE or item_type == ITEM_QUICK_THROW_KNIFE or item_type == ITEM_THROW_SPEAR then
        return TRUE
    else
        return FALSE
    end
end

function ExecItem(quick_type, blend_type)
    if c_HasActionRequest == FALSE then
        return FALSE
    elseif FALSE == env(ActionRequest, ACTION_ARM_USE_ITEM) then
        return FALSE
    elseif env(IsItemUseMenuOpened) == TRUE then
        return FALSE
    elseif env(IsItemUseMenuOpening) == TRUE then
        ResetRequest()
        act(OpenMenuWhenUsingItem)
        return TRUE
    end

    act(UseItemDecision)

    local item_type = env(GetItemAnimType)

    if IsUseStaminaItem(item_type) == TRUE and env(GetStamina) <= 0 then
        return FALSE
    elseif blend_type == ALLBODY then
        if c_IsStealth == TRUE then
            if MoveStart(LOWER, Event_Stealth_Move, FALSE) == TRUE then
                blend_type = UPPER
            end
        elseif MoveStart(LOWER, Event_Move, FALSE) == TRUE then
            blend_type = UPPER
        end
    end

    if c_IsStealth == TRUE then
        if ExecStealthItem(blend_type, item_type) == TRUE then
            return TRUE
        end
        blend_type = ALLBODY
    end

    if item_type == ITEM_RECOVER then
        ExecEventHalfBlend(Event_ItemRecover, blend_type)
    elseif item_type == ITEM_WEAPON_ENCHANT then
        ExecEventHalfBlend(Event_ItemWeaponEnchant, blend_type)
    elseif item_type == ITEM_THROW_KNIFE then
        ExecEventHalfBlend(Event_ItemThrowKnife, blend_type)
    elseif item_type == ITEM_THROW_BOTTLE then
        ExecEventHalfBlend(Event_ItemThrowBottle, blend_type)
    elseif item_type == ITEM_MEGANE then
        if env(GetStateChangeType, 15) == TRUE then
            ExecEventHalfBlend(Event_ItemMeganeEnd, ALLBODY)
        else
            ExecEventHalfBlend(Event_ItemMeganeStart, ALLBODY)
        end
    elseif item_type == ITEM_REPAIR then
        ExecEventHalfBlend(Event_ItemWeaponRepair, ALLBODY)
    elseif item_type == ITEM_PRAY then
        ExecEventHalfBlend(Event_ItemPrayMulti, blend_type)
    elseif item_type == ITEM_TRAP then
        ExecEventHalfBlend(Event_ItemTrap, blend_type)
    elseif item_type == ITEM_MESSAGE then
        ExecEventHalfBlend(Event_ItemMessage, ALLBODY)
    elseif item_type == ITEM_SOUL then
        ExecEventHalfBlend(Event_ItemSoul, blend_type)
    elseif item_type == ITEM_DRINK then
        if env(GetStateChangeType, CONDITION_TYPE_NO_EST) == TRUE then
            ExecEventHalfBlend(Event_ItemDrinkNothing, blend_type)
        elseif TRUE == IsNodeActive("ItemDrinking_Upper_CMSG") then
            SetInterruptType(INTERRUPT_USEITEM)
            ExecEventHalfBlend(Event_ItemDrinking, blend_type)
        else
            SetInterruptType(INTERRUPT_USEITEM)
            ExecEventHalfBlend(Event_ItemDrinkStart, blend_type)
        end
    elseif item_type == ITEM_SHOCK_WAVE then
        ExecEventHalfBlend(Event_ItemShockWeaveStart, blend_type)
    elseif item_type == ITEM_QUICK_WEAPON_ENCHANT then
        if quick_type == QUICKTYPE_NORMAL or quick_type == QUICKTYPE_RUN then
            ExecEventHalfBlend(Event_QuickItemEnchantNormal, blend_type)
        elseif quick_type == QUICKTYPE_DASH then
            ExecEventHalfBlend(Event_QuickItemEnchantDash, blend_type)
        elseif quick_type == QUICKTYPE_ROLLING or quick_type == QUICKTYPE_BACKSTEP then
            ExecEventHalfBlend(Event_QuickItemEnchantStep, blend_type)
        elseif quick_type == QUICKTYPE_ATTACK then
            if ForwardLeg() == 1 then
                ExecEventHalfBlend(Event_QuickItemEnchantAttackRight, blend_type)
            else
                ExecEventHalfBlend(Event_QuickItemEnchantAttackLeft, blend_type)
            end
        else
            return FALSE
        end
    elseif item_type == ITEM_QUICK_THROW_KNIFE then
        if quick_type == QUICKTYPE_NORMAL or quick_type == QUICKTYPE_RUN then
            ExecEventHalfBlend(Event_QuickItemThrowKnifeNormal, ALLBODY)
        elseif quick_type == QUICKTYPE_DASH then
            ExecEventHalfBlend(Event_QuickItemThrowKnifeDash, ALLBODY)
        elseif quick_type == QUICKTYPE_ROLLING or quick_type == QUICKTYPE_BACKSTEP then
            ExecEventHalfBlend(Event_QuickItemThrowKnifeStep, ALLBODY)
        elseif quick_type == QUICKTYPE_ATTACK then
            if ForwardLeg() == 1 then
                ExecEventHalfBlend(Event_QuickItemThrowKnifeAttackRight, ALLBODY)
            else
                ExecEventHalfBlend(Event_QuickItemThrowKnifeAttackLeft, ALLBODY)
            end
        elseif quick_type == QUICKTYPE_COMBO then
            if ForwardLeg() == 1 then
                ExecEventHalfBlend(Event_QuickItemThrowKnifeAttackRight2, ALLBODY)
            else
                ExecEventHalfBlend(Event_QuickItemThrowKnifeAttackLeft2, ALLBODY)
            end
        else
            return FALSE
        end
    elseif item_type == ITEM_QUICK_THROW_BOTTLE then
        return FALSE
    elseif item_type == ITEM_DRINK_MP then
        if env(GetStateChangeType, CONDITION_TYPE_NO_EST) == TRUE then
            ExecEventHalfBlend(Event_ItemDrinkNothing, blend_type)
        elseif TRUE == IsNodeActive("ItemDrinkingMP_Upper_CMSG") then
            SetInterruptType(INTERRUPT_USEITEM)
            ExecEventHalfBlend(Event_ItemDrinkingMP, blend_type)
        else
            SetInterruptType(INTERRUPT_USEITEM)
            ExecEventHalfBlend(Event_ItemDrinkStartMP, blend_type)
        end
    elseif item_type == ITEM_STRING_BOTTLE then
        ExecEventHalfBlend(Event_ItemThrowBackBottle, blend_type)
    elseif item_type == ITEM_THROW_SPEAR then
        ExecEventHalfBlend(Event_ItemThrowSpear, blend_type)
    elseif item_type == 25 then
        ExecEventHalfBlend(Event_ItemDragonFullStartAfter, blend_type)
    elseif item_type == 26 then
        ExecEventHalfBlend(Event_ItemEatJerky, blend_type)
    elseif item_type == 27 then
        if env(GetSpEffectID, 3245) == TRUE then
            ExecEventHalfBlend(Event_ItemLanternOff, blend_type)
        else
            ExecEventHalfBlend(Event_ItemLanternOn, blend_type)
        end
    elseif item_type == ITEM_ELIXIR then
        SetInterruptType(INTERRUPT_USEITEM)
        ExecEventHalfBlend(Event_ItemElixir, blend_type)
    elseif item_type == ITEM_HORN then
        ExecEventHalfBlend(Event_ItemHorn, blend_type)
    elseif item_type == ITEM_COPY_SLEEP then
        ExecEventHalfBlend(Event_ItemCopySleep, blend_type)
    elseif item_type == ITEM_VOICE then
        ExecEventHalfBlend(Event_ItemVoice, blend_type)
    elseif item_type == ITEM_SUMMONHORSE then
        SetVariable("RideOnSummonTest", 0)
        SetVariable("IndexItemUseAnim", item_type)
        SetVariable("ItemDashSpeedIndex", 0)

        if 1 <= GetVariable("MoveSpeedIndex") then
            SetVariable("ItemDashSpeedIndex", 1)
        end
        if GetVariable("MoveSpeedLevel") >= 0.8999999761581421 then
            IsSummonDash = TRUE
        else
            IsSummonDash = FALSE
        end

        ExecEventHalfBlend(Event_ItemDash, blend_type)
    elseif item_type == ITEM_VOICE then
        ExecEventHalfBlend(Event_ItemReturnBuddy, blend_type)
    elseif item_type == ITEM_SUMMONBUDDY then
        ExecEventHalfBlend(Event_ItemSummonBuddy, blend_type)
    elseif item_type == ITEM_HOST then
        ExecEventHalfBlend(Event_ItemHost, blend_type)
    elseif item_type == ITEM_MULTIKICK then
        ExecEventHalfBlend(Event_ItemMultKick, blend_type)
    elseif item_type == ITEM_TONGUE then
        ExecEventHalfBlend(Event_ItemTongue, blend_type)
    elseif item_type == ITEM_HOLYSYMBOL then
        ExecEventHalfBlend(Event_ItemHolySymbol, blend_type)
    elseif item_type == ITEM_NIGHT_BELL then
        -- 100800 "[HKS] Item Combo Window"
        local is_combo = env(GetSpEffectID, 100800)

        if is_combo == TRUE then
            ExecEventHalfBlend(Event_ItemCombo, blend_type)
        elseif TRUE == IsNodeActive("ItemOneshot_Upper") then
            SetVariable("IndexItemUseAnim_SelfTrans", item_type)
            ExecEventHalfBlend(Event_ItemOneShot_SelfTrans, blend_type)
        else
            SetVariable("IndexItemUseAnim", item_type)
            ExecEventHalfBlend(Event_ItemOneShot, blend_type)
        end
    elseif item_type == 52 then
        ResetMimicry()
        if TRUE == IsNodeActive("ItemOneshot_Upper") then
            SetVariable("IndexItemUseAnim_SelfTrans", item_type)
            ExecEventHalfBlend(Event_ItemOneShot_SelfTrans, blend_type)
        else
            SetVariable("IndexItemUseAnim", item_type)
            ExecEventHalfBlend(Event_ItemOneShot, blend_type)
        end
    elseif item_type == ITEM_AROMAWIDE then
        ExecEventHalfBlend(Event_ItemAromaWide, blend_type)
    elseif item_type == ITEM_AROMAUP then
        ExecEventHalfBlend(Event_ItemAromaUp, blend_type)
    elseif item_type == ITEM_AROMAFRONT then
        ExecEventHalfBlend(Event_ItemAromaFront, blend_type)
    elseif item_type == ITEM_AROMADRINK then
        ExecEventHalfBlend(Event_ItemAromaDrink, blend_type)
    elseif item_type == ITEM_AROMABREATH then
        ExecEventHalfBlend(Event_ItemAromaBreath, blend_type)
    elseif item_type == ITEM_NO_DRINK then
        if TRUE == IsNodeActive("ItemDrinkingMP_Upper_CMSG") or TRUE == IsNodeActive("ItemDrinking_Upper_CMSG") then
            if blend_type == ALLBODY and MoveStart(LOWER, Event_MoveLong, FALSE) == TRUE then
                blend_type = UPPER
            end
            ExecEventHalfBlend(Event_ItemDrinkEmpty, blend_type)
        else
            ExecEventHalfBlend(Event_ItemDrinkStart, blend_type)
        end
    elseif item_type == ITEM_INVALID then
        ExecEventHalfBlend(Event_ItemInvalid, blend_type)
    elseif TRUE == IsNodeActive("ItemOneshot_Upper") then
        SetVariable("IndexItemUseAnim_SelfTrans", item_type)
        ExecEventHalfBlend(Event_ItemOneShot_SelfTrans, blend_type)
    else
        SetVariable("IndexItemUseAnim", item_type)
        ExecEventHalfBlend(Event_ItemOneShot, blend_type)
    end

    act(SetIsItemAnimationPlaying)
    act(Unknown2025, env(Unknown404))
    SetAIActionState()

    return TRUE
end

function ExecLadderItem(hand)
    if c_HasActionRequest == FALSE then
        return FALSE
    elseif FALSE == env(ActionRequest, ACTION_ARM_USE_ITEM) then
        return FALSE
    elseif env(IsItemUseMenuOpened) == TRUE then
        return FALSE
    elseif env(IsItemUseMenuOpening) == TRUE then
        ResetRequest()
        act(OpenMenuWhenUsingItem)
        return TRUE
    end

    act(UseItemDecision)

    local item_type = env(GetItemAnimType)
    local event = "W_ItemLadderInvalid"
    local event_hand = "Left"

    if hand == HAND_STATE_RIGHT then
        event_hand = "Right"
    end

    if item_type == ITEM_RECOVER then
        event = "W_ItemLadderRecover"
    elseif item_type == ITEM_SOUL then
        event = "W_ItemLadderSoul"
    elseif item_type == ITEM_EATJERKY then
        event = "W_ItemLadderEatJerky"
    elseif item_type == ITEM_ELIXIR then
        event = "W_ItemLadderElixir"
    elseif item_type == ITEM_DRINK then
        if env(GetStateChangeType, CONDITION_TYPE_NO_EST) == TRUE then
            event = "W_ItemLadderDrinkNothing"
        elseif TRUE == IsNodeActive("ItemLadderDrinkingRight_CMSG") then
            event = "W_ItemLadderDrinking"
            event_hand = "Right"
        elseif TRUE == IsNodeActive("ItemLadderDrinkingLeft_CMSG") then
            event = "W_ItemLadderDrinking"
            event_hand = "Left"
        else
            event = "W_ItemLadderDrinkStart"
        end
    elseif item_type == ITEM_DRINK_MP then
        if env(GetStateChangeType, CONDITION_TYPE_NO_EST) == TRUE then
            event = "W_ItemLadderDrinkNothing"
        elseif TRUE == IsNodeActive("ItemLadderDrinkingRight_CMSG00") then
            event = "W_ItemLadderDrinkingMP"
            event_hand = "Right"
        elseif TRUE == IsNodeActive("ItemLadderDrinkingLeft_CMSG00") then
            event = "W_ItemLadderDrinkingMP"
            event_hand = "Left"
        else
            event = "W_ItemLadderDrinkMPStart"
        end
    elseif item_type == ITEM_NO_DRINK then
        if TRUE == IsNodeActive("ItemLadderDrinkingMPRight_CMSG") or TRUE == IsNodeActive("ItemLadderDrinkingRight_CMSG") then
            event = "W_ItemLadderDrinkEmpty"
            event_hand = "Right"
        elseif TRUE == IsNodeActive("ItemLadderDrinkingLeft_CMSG") or TRUE == IsNodeActive("ItemLadderDrinkingMPLeft_CMSG") then
            event = "W_ItemLadderDrinkEmpty"
            event_hand = "Left"
        else
            event = "W_ItemLadderDrinkStart"
        end
    end

    act(SetIsItemAnimationPlaying)
    ExecEvent(event .. event_hand)

    return TRUE
end

function GetWeaponChangeType(hand)
    local left_offset = 0
    local pos = env(GetWeaponStorageSpotType, hand)

    if hand == HAND_LEFT then
        left_offset = 4
    end

    if pos == 0 then
        return WEAPON_CHANGE_REQUEST_RIGHT_WAIST + left_offset
    elseif pos == 1 then
        return WEAPON_CHANGE_REQUEST_RIGHT_BACK + left_offset
    elseif pos == 2 then
        return WEAPON_CHANGE_REQUEST_RIGHT_SHOULDER + left_offset
    elseif pos == 3 then
        return WEAPON_CHANGE_REQUEST_RIGHT_SPEAR + left_offset
    else
        return WEAPON_CHANGE_REQUEST_INVALID
    end
end

function ExecWeaponChange(blend_type)
    if c_HasActionRequest == FALSE then
        return FALSE
    elseif FALSE == env(IsGeneralAnimCancelPossible) and FALSE == env(IsStayState) then
        return FALSE
    elseif env(GetSpEffectID, 100730) == TRUE then
        return FALSE
    elseif env(ActionRequest, ACTION_ARM_R1) == TRUE or env(ActionRequest, ACTION_ARM_R2) == TRUE then
        if env(ActionDuration, ACTION_ARM_ACTION) > 0 then
            HandChangeTest_ToR1 = FALSE
            HandChangeTest_ToR2 = FALSE
            HandChangeTest_ToL1 = FALSE
            HandChangeTest_ToL2 = FALSE

            if env(ActionRequest, ACTION_ARM_R1) == TRUE then
                HandChangeTest_ToR1 = TRUE
            else
                HandChangeTest_ToR2 = TRUE
            end

            return ExecHandChange(HAND_RIGHT, TRUE, blend_type)
        end
    elseif (env(ActionRequest, ACTION_ARM_L1) == TRUE or env(ActionRequest, ACTION_ARM_L2) == TRUE) and env(ActionDuration, ACTION_ARM_ACTION) > 0 then
        HandChangeTest_ToR1 = FALSE
        HandChangeTest_ToR2 = FALSE
        HandChangeTest_ToL1 = FALSE
        HandChangeTest_ToL2 = FALSE

        if env(ActionRequest, ACTION_ARM_L1) == TRUE then
            HandChangeTest_ToL1 = TRUE
        else
            HandChangeTest_ToL2 = TRUE
        end

        return ExecHandChange(HAND_LEFT, TRUE, blend_type)
    end

    local weapon_change_type = nil

    if env(ActionRequest, ACTION_ARM_CHANGE_WEAPON_R) == TRUE then
        weapon_change_type = GetWeaponChangeType(HAND_RIGHT)
    elseif env(ActionRequest, ACTION_ARM_CHANGE_WEAPON_L) == TRUE then
        weapon_change_type = GetWeaponChangeType(HAND_LEFT)
    else
        return FALSE
    end

    if weapon_change_type == WEAPON_CHANGE_REQUEST_INVALID then
        return FALSE
    end

    SetVariable("WeaponChangeType", weapon_change_type)

    if blend_type == ALLBODY and MoveStart(LOWER, Event_Move, FALSE) == TRUE then
        blend_type = UPPER
    end

    local event = Event_WeaponChangeStart

    if c_IsStealth == TRUE then
        event = Event_StealthWeaponChangeStart
    end

    ExecEventHalfBlend(event, blend_type)
    act(Unknown2025, env(Unknown404))
    SetAIActionState()

    return TRUE
end

function SetHandChangeStyle(s, e)
    SetVariable("HandChangeStartIndex", s)
    SetVariable("HandChangeEndIndex", e)
end

function GetHandChangeType(hand)
    local left_offset = 0
    local pos = env(GetWeaponStorageSpotType, hand)

    if hand == HAND_LEFT then
        left_offset = 4
    end

    if pos == 0 then
        return WEAPON_CHANGE_REQUEST_RIGHT_WAIST + left_offset
    elseif pos == 1 then
        return WEAPON_CHANGE_REQUEST_RIGHT_BACK + left_offset
    elseif pos == 2 then
        return WEAPON_CHANGE_REQUEST_RIGHT_SHOULDER + left_offset
    elseif pos == 3 then
        return WEAPON_CHANGE_REQUEST_RIGHT_SPEAR + left_offset
    else
        return WEAPON_CHANGE_REQUEST_INVALID
    end
end

function ExecJump()
    if env(ActionRequest, ACTION_ARM_JUMP) == FALSE and env(700) == FALSE then
        return FALSE
    elseif env(GetStamina) <= 0 and env(Unknown700) == FALSE then
        ResetRequest()
        return FALSE
    end

    AddStamina(STAMINA_REDUCE_JUMP)
    SetWeightIndex()

    -- Jump: Overweight
    if GetVariable("EvasionWeightIndex") == EVASION_WEIGHT_INDEX_OVERWEIGHT and env(Unknown700) == FALSE then
        local jumpangle = env(GetJumpAngle) * 0.009999999776482582

        if jumpangle > -45 and jumpangle < 45 then
            SetVariable("JumpOverweightIndex", 0)
        elseif jumpangle >= 0 and jumpangle <= 100 then
            SetVariable("JumpOverweightIndex", 3)
        elseif jumpangle >= -100 and jumpangle <= 0 then
            SetVariable("JumpOverweightIndex", 2)
        else
            SetVariable("JumpOverweightIndex", 1)
        end

        act(Unknown2025, env(Unknown404))
        SetAIActionState()
        ExecEventAllBody("W_Jump_Overweight")

        return TRUE
    end

    local style = c_Style

    if style == HAND_RIGHT then
        SetVariable("JumpAttack_HandCondition", 0)
    elseif style == HAND_RIGHT_BOTH then
        SetVariable("JumpAttack_HandCondition", 1)
    elseif style == HAND_LEFT_BOTH then
        if TRUE == GetEquipType(HAND_LEFT, WEAPON_CATEGORY_CROSSBOW) then
            SetVariable("JumpAttack_HandCondition", 4)
        else
            SetVariable("JumpAttack_HandCondition", 1)
        end
    end

    SetVariable("JumpAttackForm", 0)
    SetVariable("JumpUseMotion_Bool", false)
    SetVariable("JumpMotion_Override", 0.009999999776482582)
    SetVariable("JumpAttack_Land", 0)
    SetVariable("SwingPose", 0)

    if GetVariable("IsEnableToggleDashTest") == 2 then
        SetVariable("ToggleDash", 0)
    end

    local JumpMoveLevel = 0

    if GetVariable("LocomotionState") == 1 and GetVariable("MoveSpeedIndex") == 2 then
        JumpMoveLevel = 2
    elseif GetVariable("MoveSpeedLevel") >= 0.6000000238418579 then
        JumpMoveLevel = 1
    end

    -- Ironjar Aromatic
    if env(GetSpEffectID, 503520) == TRUE then
        JumpMoveLevel = 0
        -- Unknown
    elseif env(GetSpEffectID, 5520) == TRUE then
        JumpMoveLevel = 0
        -- Slug: Slow
    elseif env(GetSpEffectID, 425) == TRUE then
        JumpMoveLevel = 0
        -- Sanguine Noble: Slow
    elseif env(GetSpEffectID, 4101) == TRUE then
        JumpMoveLevel = 0
        -- Sanguine Noble: Slow
    elseif env(GetSpEffectID, 4100) == TRUE then
        JumpMoveLevel = 0
    end

    if JumpMoveLevel == 2 then
        if env(Unknown700) == TRUE then
            act(Unknown4001)
        end

        act(Unknown2025, env(Unknown404))
        SetAIActionState()
        ExecEvent("W_Jump_D")

        return TRUE
    elseif JumpMoveLevel == 1 then
        if GetVariable("IsLockon") == FALSE and env(IsPrecisionShoot) == FALSE and env(IsCOMPlayer) == FALSE then
            SetVariable("JumpDirection", 0)
            SetVariable("JumpAngle", 0)
        else
            local jumpangle = env(GetJumpAngle) * 0.009999999776482582
            local adjusted_jump_angle = nil

            if jumpangle > -45 and jumpangle < 45 then
                adjusted_jump_angle = jumpangle
                SetVariable("JumpDirection", 0)
                SetVariable("JumpAngle", 0)
            elseif jumpangle >= 0 and jumpangle <= 100 then
                adjusted_jump_angle = jumpangle - 90
                SetVariable("JumpDirection", 3)
                SetVariable("JumpAngle", 90)
            elseif jumpangle >= -100 and jumpangle <= 0 then
                adjusted_jump_angle = jumpangle + 90
                SetVariable("JumpDirection", 2)
                SetVariable("JumpAngle", -90)
            else
                adjusted_jump_angle = jumpangle - 180
                SetVariable("JumpDirection", 1)
                SetVariable("JumpAngle", 180)
            end

            if GetVariable("IsLockon") == true then
                act(TurnToLockonTargetImmediately, adjusted_jump_angle)
            else
                act(Unknown2029, adjusted_jump_angle)
            end
        end

        SetVariable("IsEnableDirectionJumpTAE", true)

        if env(Unknown700) == TRUE then
            act(Unknown4001)
        end

        act(Unknown2025, env(Unknown404))
        SetAIActionState()
        ExecEvent("W_Jump_F")

        return TRUE
    end

    SetVariable("JumpReachSelector", 0)

    if env(Unknown700) == TRUE then
        act(Unknown4001)
    end

    act(Unknown2025, env(Unknown404))
    SetAIActionState()
    ExecEvent("W_Jump_N")

    return TRUE
end

function ExecJumpLoopDirect(jump_type)
    local style = c_Style

    if style == HAND_RIGHT then
        SetVariable("JumpAttack_HandCondition", 0)
    elseif style == HAND_RIGHT_BOTH then
        SetVariable("JumpAttack_HandCondition", 1)
    elseif style == HAND_LEFT_BOTH then
        if GetEquipType(HAND_LEFT, WEAPON_CATEGORY_CROSSBOW) == TRUE then
            SetVariable("JumpAttack_HandCondition", 4)
        else
            SetVariable("JumpAttack_HandCondition", 1)
        end
    end

    SetVariable("JumpAttackForm", 0)
    SetVariable("JumpUseMotion_Bool", false)
    SetVariable("JumpMotion_Override", 0.009999999776482582)
    SetVariable("JumpAttack_Land", 0)
    SetVariable("SwingPose", 0)

    if GetVariable("IsEnableToggleDashTest") == 2 then
        SetVariable("ToggleDash", 0)
    end

    if jump_type == 2 then
        ExecEvent("W_Jump_Loop")
        return TRUE
    elseif GetVariable("MoveSpeedLevel") >= 0.6000000238418579 then
        SetVariable("IsEnableDirectionJumpTAE", true)
        ExecEvent("W_Jump_Loop")
        return TRUE
    else
        SetVariable("JumpReachSelector", 0)
        ExecEvent("W_Jump_Loop")
        return TRUE
    end
end

function ExecHandChange(hand, is_force, blend_type, no_reset)
    if is_force == FALSE then
        if env(IsCOMPlayer) ~= TRUE then
            return FALSE
        elseif FALSE == c_HasActionRequest or env(IsPrecisionShoot) == TRUE then
            return FALSE
        elseif env(ActionRequest, ACTION_ARM_CHANGE_STYLE_R) == TRUE and env(ActionDuration, ACTION_ARM_R1) < 100 then
        elseif env(ActionRequest, ACTION_ARM_CHANGE_STYLE_L) == TRUE and env(ActionDuration, ACTION_ARM_L1) < 100 then
            hand = HAND_LEFT
        else
            return FALSE
        end
    end
    local style = c_Style
    if style == HAND_RIGHT then
        if hand == HAND_RIGHT then
            if FALSE == env(IsTwoHandPossible, HAND_RIGHT) then
                return FALSE
            end
            local f98_local0 = GetHandChangeType(HAND_LEFT)
            if f98_local0 == WEAPON_CHANGE_REQUEST_LEFT_WAIST then
                if TRUE == IsDualBladeSpecific(HAND_RIGHT) then
                    SetHandChangeStyle(LEFT_TO_WAIST, LEFT_FROM_WAIST)
                else
                    SetHandChangeStyle(LEFT_TO_WAIST, BOTH_FROM_ALL)
                end
            elseif f98_local0 == WEAPON_CHANGE_REQUEST_LEFT_BACK then
                if TRUE == IsDualBladeSpecific(HAND_RIGHT) then
                    SetHandChangeStyle(LEFT_TO_BACK, LEFT_FROM_BACK)
                else
                    SetHandChangeStyle(LEFT_TO_BACK, BOTH_FROM_ALL)
                end
            elseif f98_local0 == WEAPON_CHANGE_REQUEST_LEFT_SHOULDER then
                if TRUE == IsDualBladeSpecific(HAND_RIGHT) then
                    SetHandChangeStyle(LEFT_TO_SHOULDER, LEFT_FROM_SHOULDER)
                else
                    SetHandChangeStyle(LEFT_TO_SHOULDER, BOTH_FROM_ALL)
                end
            elseif f98_local0 == WEAPON_CHANGE_REQUEST_LEFT_SPEAR then
                if TRUE == IsDualBladeSpecific(HAND_RIGHT) then
                    SetHandChangeStyle(LEFT_TO_SPEAR, LEFT_FROM_SPEAR)
                else
                    SetHandChangeStyle(LEFT_TO_SPEAR, BOTH_FROM_ALL)
                end
            elseif TRUE == IsDualBladeSpecific(HAND_RIGHT) then
                SetHandChangeStyle(LEFT_TO_SPEAR, LEFT_FROM_SPEAR)
            else
                SetHandChangeStyle(LEFT_TO_SPEAR, BOTH_FROM_ALL)
            end
            act(Unknown9999, 1)
        else
            if FALSE == env(IsTwoHandPossible, HAND_LEFT) then
                return FALSE
            end
            local f98_local0 = GetHandChangeType(HAND_RIGHT)
            if f98_local0 == WEAPON_CHANGE_REQUEST_RIGHT_WAIST then
                if TRUE == IsDualBladeSpecific(HAND_LEFT) then
                    SetHandChangeStyle(RIGHT_TO_WAIST, RIGHT_FROM_WAIST)
                else
                    SetHandChangeStyle(RIGHT_TO_WAIST, BOTHLEFT_FROM_ALL)
                end
            elseif f98_local0 == WEAPON_CHANGE_REQUEST_RIGHT_BACK then
                if TRUE == IsDualBladeSpecific(HAND_LEFT) then
                    SetHandChangeStyle(RIGHT_TO_BACK, RIGHT_FROM_BACK)
                else
                    SetHandChangeStyle(RIGHT_TO_BACK, BOTHLEFT_FROM_ALL)
                end
            elseif f98_local0 == WEAPON_CHANGE_REQUEST_RIGHT_SHOULDER then
                if TRUE == IsDualBladeSpecific(HAND_LEFT) then
                    SetHandChangeStyle(RIGHT_TO_SHOULDER, RIGHT_FROM_SHOULDER)
                else
                    SetHandChangeStyle(RIGHT_TO_SHOULDER, BOTHLEFT_FROM_ALL)
                end
            elseif f98_local0 == WEAPON_CHANGE_REQUEST_RIGHT_SPEAR then
                if TRUE == IsDualBladeSpecific(HAND_LEFT) then
                    SetHandChangeStyle(RIGHT_TO_SPEAR, RIGHT_FROM_SPEAR)
                else
                    SetHandChangeStyle(RIGHT_TO_SPEAR, BOTHLEFT_FROM_ALL)
                end
            elseif TRUE == IsDualBladeSpecific(HAND_RIGHT) then
                SetHandChangeStyle(RIGHT_TO_BACK, RIGHT_FROM_BACK)
            else
                SetHandChangeStyle(RIGHT_TO_BACK, BOTHLEFT_FROM_ALL)
            end
            act(Unknown9999, 2)
        end
    elseif style == HAND_RIGHT_BOTH then
        local f98_local0 = GetHandChangeType(HAND_LEFT)
        if f98_local0 == WEAPON_CHANGE_REQUEST_LEFT_WAIST then
            SetHandChangeStyle(BOTH_TO_WAIST, LEFT_FROM_WAIST)
        elseif f98_local0 == WEAPON_CHANGE_REQUEST_LEFT_BACK then
            SetHandChangeStyle(BOTH_TO_BACK, LEFT_FROM_BACK)
        elseif f98_local0 == WEAPON_CHANGE_REQUEST_LEFT_SHOULDER then
            SetHandChangeStyle(BOTH_TO_SHOULDER, LEFT_FROM_SHOULDER)
        else
            SetHandChangeStyle(BOTH_TO_BACK, LEFT_FROM_BACK)
        end
        act(Unknown9999, 3)
    elseif style == HAND_LEFT_BOTH then
        local f98_local0 = GetHandChangeType(HAND_RIGHT)
        if f98_local0 == WEAPON_CHANGE_REQUEST_RIGHT_WAIST then
            SetHandChangeStyle(BOTHRIGHT_TO_WAIST, RIGHT_FROM_WAIST)
        elseif f98_local0 == WEAPON_CHANGE_REQUEST_RIGHT_BACK then
            SetHandChangeStyle(BOTHRIGHT_TO_BACK, RIGHT_FROM_BACK)
        elseif f98_local0 == WEAPON_CHANGE_REQUEST_RIGHT_SHOULDER then
            SetHandChangeStyle(BOTHRIGHT_TO_SHOULDER, RIGHT_FROM_SHOULDER)
        else
            SetHandChangeStyle(BOTHRIGHT_TO_BACK, RIGHT_FROM_SPEAR)
        end
        act(Unknown9999, 1)
    end
    if blend_type == ALLBODY then
        local move_event = Event_Move
        if c_IsStealth == TRUE then
            move_event = Event_Stealth_Move
        end
        if MoveStart(LOWER, move_event, FALSE) == TRUE then
            blend_type = UPPER
        end
    end
    local event = Event_HandChangeStart
    if c_IsStealth == TRUE then
        event = Event_StealthHandChangeStart
    end
    if no_reset == TRUE then
        ExecEventHalfBlendNoReset(event, blend_type)
    else
        ExecEventHalfBlend(event, blend_type)
    end
    act(Unknown2025, env(Unknown404))
    SetAIActionState()
    return TRUE
end

function GetEvasionRequest()
    if env(GetStamina) < STAMINA_MINIMUM then
        return ATTACK_REQUEST_INVALID
    elseif env(ActionRequest, ACTION_ARM_ROLLING) == TRUE then
        return ATTACK_REQUEST_ROLLING
    elseif env(ActionDuration, ACTION_ARM_L1) > 0 then
        if env(ActionRequest, ACTION_ARM_EMERGENCYSTEP) == TRUE then
            if env(IsEmergencyEvasionPossible, 0) == TRUE or env(IsEmergencyEvasionPossible, 1) == TRUE then
                return ATTACK_REQUEST_EMERGENCYSTEP
            end
        elseif env(ActionRequest, ACTION_ARM_BACKSTEP) == TRUE then
            return ATTACK_REQUEST_BACKSTEP
        else
            return ATTACK_REQUEST_INVALID
        end
    elseif env(ActionRequest, ACTION_ARM_BACKSTEP) == TRUE then
        return ATTACK_REQUEST_BACKSTEP
    end
    return ATTACK_REQUEST_INVALID
end

HandChangeControlTest8_RelaeseA = TRUE
c_RollingAngle = 0
c_ArtsRollingAngle = 0

function ExecEvasion(backstep_limit, estep, is_usechainrecover)
    if c_HasActionRequest == FALSE then
        return FALSE
    end

    local request = GetEvasionRequest()

    if env(ActionRequest, ACTION_ARM_L3) == TRUE and FALSE == c_IsStealth then
        StealthTransitionIndexUpdate()
        ExecEvent("W_Stealth_to_Stealth_Idle")
        return TRUE
    elseif env(ActionRequest, ACTION_ARM_L3) == TRUE and c_IsStealth == TRUE then
        StealthTransitionIndexUpdate()
        ExecEvent("W_Stealth_to_Idle")
        return TRUE
    elseif request == ATTACK_REQUEST_INVALID then
        return FALSE
    elseif backstep_limit == TRUE and request == ATTACK_REQUEST_BACKSTEP and env(GetEventEzStateFlag, 0) == TRUE then
        return FALSE
    end

    SetWeightIndex()

    -----------------------
    -- Roll
    -----------------------
    if request == ATTACK_REQUEST_ROLLING then
        if is_usechainrecover == TRUE then
            local damagecount = GetVariable("DamageCount")
            if damagecount >= 4 then
                if FALSE == env(GetEventEzStateFlag, 5) then
                    return FALSE
                end
            elseif damagecount == 3 then
                if FALSE == env(GetEventEzStateFlag, 4) then
                    return FALSE
                end
            elseif damagecount == 2 then
                if FALSE == env(GetEventEzStateFlag, 3) then
                    return FALSE
                end
            elseif damagecount <= 1 and FALSE == env(GetEventEzStateFlag, 2) then
                if env(GetSpEffectID, 100720) == TRUE then
                    ResetRequest()
                end
                return FALSE
            end
        end

        if env(GetStamina) <= 0 then
            ResetRequest()
            return FALSE
        elseif env(GetFallHeight) > 150 then
            return FALSE
        end

        local rollingEvent = "W_Rolling"
        local is_selfTrans = FALSE

        if TRUE == IsNodeActive("Rolling_CMSG") then
            is_selfTrans = TRUE
        end

        if estep == ESTEP_DOWN then
            rollingEvent = "W_EStepDown"
        elseif c_IsStealth == TRUE and GetVariable("EvasionWeightIndex") ~= EVASION_WEIGHT_INDEX_OVERWEIGHT then
            rollingEvent = "W_Stealth_Rolling"
        elseif is_selfTrans == TRUE then
            rollingEvent = rollingEvent .. "_Selftrans"
        end

        AddStamina(STAMINA_REDUCE_ROLLING)

        if GetVariable("IsEnableToggleDashTest") == 2 then
            SetVariable("ToggleDash", 0)
        end

        local turn_angle_real = 200

        if not (GetVariable("IsLockon") ~= false or FALSE ~= env(IsPrecisionShoot) or FALSE ~= env(IsCOMPlayer)) or env(GetSpEffectID, 100002) == TRUE then
            SetVariable("RollingOverweightIndex", 0)

            if is_selfTrans == TRUE then
                SetVariable("RollingDirectionIndex_SelfTrans", 0)
            else
                SetVariable("RollingDirectionIndex", 0)
            end
        elseif GetVariable("EvasionWeightIndex") == EVASION_WEIGHT_INDEX_OVERWEIGHT then
            if c_RollingAngle <= 45 and c_RollingAngle >= -45 then
                SetVariable("RollingOverweightIndex", 0)
            elseif c_RollingAngle > 45 and c_RollingAngle < 135 then
                SetVariable("RollingOverweightIndex", 3)
            elseif c_RollingAngle >= 135 then
                SetVariable("RollingOverweightIndex", 1)
            elseif c_RollingAngle < -45 and c_RollingAngle > -135 then
                SetVariable("RollingOverweightIndex", 2)
            else
                SetVariable("RollingOverweightIndex", 1)
            end

            act(TurnToLockonTargetImmediately)

            turn_angle_real = math.abs(GetVariable("TurnAngle") - c_RollingAngle)

            if turn_angle_real > 180 then
                turn_angle_real = 360 - turn_angle_real
            end
        else
            local f100_local0 = nil
            local f100_local1 = nil

            if GetVariable("RollingAngleThresholdRightFrontTest") >= c_RollingAngle and GetVariable("RollingAngleThresholdLeftFrontTest") <= c_RollingAngle then
                f100_local0 = 0
                f100_local1 = c_RollingAngle
            elseif GetVariable("RollingAngleThresholdRightFrontTest") < c_RollingAngle and GetVariable("RollingAngleThresholdRightBackTest") > c_RollingAngle then
                f100_local0 = 3
                f100_local1 = c_RollingAngle - 90
            elseif GetVariable("RollingAngleThresholdLeftFrontTest") > c_RollingAngle and GetVariable("RollingAngleThresholdLeftBackTest") < c_RollingAngle then
                f100_local0 = 2
                f100_local1 = c_RollingAngle + 90
            else
                f100_local0 = 1
                f100_local1 = c_RollingAngle - 180
            end

            if is_selfTrans == TRUE then
                SetVariable("RollingDirectionIndex_SelfTrans", f100_local0)
            else
                SetVariable("RollingDirectionIndex", f100_local0)
            end

            if GetVariable("IsLockon") == true then
                act(TurnToLockonTargetImmediately, f100_local1)
            else
                act(Unknown2029, f100_local1)
            end

            turn_angle_real = math.abs(GetVariable("TurnAngle") - c_RollingAngle)

            if turn_angle_real > 180 then
                turn_angle_real = 360 - turn_angle_real
            end
        end

        SetVariable("TurnAngleReal", turn_angle_real)

        if is_selfTrans == TRUE then
            SetVariable("RollingAngleRealSelftrans", c_RollingAngle)
        else
            SetVariable("RollingAngleReal", c_RollingAngle)
        end

        ExecEventAllBody(rollingEvent)
    elseif request == ATTACK_REQUEST_EMERGENCYSTEP then
        if MoveStart(ALLBODY, Event_ChainRecover, FALSE) then
        else
            return FALSE
        end
    elseif request == ATTACK_REQUEST_BACKSTEP then
        ResetDamageCount()

        if env(GetStamina) <= 0 then
            ResetRequest()
            return FALSE
        end

        AddStamina(STAMINA_REDUCE_BACKSTEP)

        if TRUE == IsEnableGuard() and TRUE == IsGuard() and GetVariable("EvasionWeightIndex") ~= EVASION_WEIGHT_INDEX_OVERWEIGHT then
            SetVariable("BackStepGuardLayer", 1)
            SetVariable("EnableTAE_BackStep", false)
            ExecEvent("W_DefaultBackStep")
            ExecEvent("W_BackStepGuardOn_UpperLayer")
        else
            SetVariable("BackStepGuardLayer", 0)
            SetVariable("EnableTAE_BackStep", true)
            ExecEventAllBody("W_DefaultBackStep")
        end
    else
        return FALSE
    end

    if GetVariable("IsEnableToggleDashTest") == 2 then
        SetVariable("ToggleDash", 0)
    end

    act(Unknown2025, env(Unknown404))
    SetAIActionState()

    return TRUE
end

function IsGuard()
    if env(ActionRequest, ACTION_ARM_L1) == TRUE or env(ActionDuration, ACTION_ARM_L1) > 0 then
        return TRUE
    else
        return FALSE
    end
end

function ExecQuickTurn(blend_type, turn_type)
    if blend_type == LOWER and IsLowerQuickTurn() == TRUE then
        return FALSE
    elseif GetVariable("IsLockon") == false then
        return FALSE
    end
    local turn_angle = GetVariable("TurnAngle")
    if math.abs(turn_angle) < 45 then
        return FALSE
    end
    SetVariable("TurnType", turn_type)
    if turn_angle >= 45 then
        ExecEventHalfBlend(Event_QuickTurnRight180, blend_type)
    else
        ExecEventHalfBlend(Event_QuickTurnLeft180, blend_type)
    end
    return TRUE
end

function ExecDashTurn()
    if GetVariable("MoveSpeedLevel") <= 0 then
        return FALSE
    else
        local angle = math.abs(hkbGetVariable("TurnAngle"))
        if angle > 90 then
            ExecEventAllBody("W_Dash180")
            return TRUE
        else
            return FALSE
        end
    end
end

function ExitQuickTurnLower()
    if env(IsAnimEnd, 2) == TRUE or env(GetEventEzStateFlag, 1) == TRUE then
        return TRUE
    elseif GetVariable("IsLockon") == false then
        return TRUE
    else
        return FALSE
    end
end

function ExecQuickTurnOnCancelTiming()
    if env(IsMoveCancelPossible) == FALSE then
        return FALSE
    elseif ExecQuickTurn(ALLBODY, TURN_TYPE_DEFAULT) == TRUE then
        return TRUE
    else
        return FALSE
    end
end

function ExecFallStart(fall_type)
    if env(IsFalling) == FALSE then
        return FALSE
    elseif fall_type == FALL_TYPE_DEFAULT then
        ExecEventAllBody("W_FallStart")
    elseif fall_type == FALL_TYPE_JUMP then
        if env(GetGeneralTAEFlag, 0) == TRUE then
            ExecEventAllBody("W_FallJumpStart")
        else
            ExecEventNoReset("W_FallStart")
        end
    elseif fall_type == FALL_TYPE_FACEDOWN_LOOP then
        ExecEventAllBody("W_FallLoopFaceDown")
    elseif fall_type == FALL_TYPE_FACEDOWN then
        ExecEventAllBody("W_FallStartFaceDown")
    elseif fall_type == FALL_TYPE_FACEUP_LOOP then
        ExecEventAllBody("W_FallLoopFaceUp")
    elseif fall_type == FALL_TYPE_FACEUP then
        ExecEventAllBody("W_FallStartFaceUp")
    else
        local damage_angle = env(GetReceivedDamageDirection)
        if damage_angle == DAMAGE_DIR_BACK then
            if fall_type == FALL_TYPE_FORCE_LOOP then
                ExecEventAllBody("W_FallLoopFaceDown")
            else
                ExecEventAllBody("W_FallStartFaceDown")
            end
        elseif fall_type == FALL_TYPE_FORCE_LOOP then
            ExecEventAllBody("W_FallLoopFaceUp")
        else
            ExecEventAllBody("W_FallStartFaceUp")
        end
    end
    return TRUE
end

function ExecAddDamage(damage_dir, attack_dir, damage_level, is_guard, is_damaged)
    if is_damaged == FALSE then
        return
    elseif env(GetBehaviorID, 2) == TRUE then
        return
    elseif IsNodeActive("Attack_SM") == TRUE then -- aimpunch fix
        return
    elseif is_guard == TRUE then
        SetVariable("AddDamageGuardBlend", 1)
    else
        SetVariable("AddDamageLv0_Blend", 1)
        local pre_index = GetVariable("IndexDamageLv0_Random")
        local index = (pre_index + math.random(1, 2)) % 3
        SetVariable("IndexDamageLv0_Random", index)
    end
    if damage_dir == DAMAGE_DIR_LEFT then
        if attack_dir == ATTACK_DIR_FRONT then
            if is_guard == TRUE then
                ExecEventNoReset("W_AddDamageGuardStartLeft")
                return
            else
                ExecEventNoReset("W_AddDamageLv0")
                return
            end
        elseif attack_dir == ATTACK_DIR_UP then
            if is_guard == TRUE then
                ExecEventNoReset("W_AddDamageGuardStartLeft")
                return
            else
                ExecEventNoReset("W_AddDamageLv0")
                return
            end
        elseif attack_dir == ATTACK_DIR_DOWN then
            if is_guard == TRUE then
                ExecEventNoReset("W_AddDamageGuardStartLeft")
                return
            else
                ExecEventNoReset("W_AddDamageLv0")
                return
            end
        elseif attack_dir == ATTACK_DIR_LEFT then
            if is_guard == TRUE then
                ExecEventNoReset("W_AddDamageGuardStartFront")
                return
            else
                ExecEventNoReset("W_AddDamageLv0")
                return
            end
        elseif attack_dir == ATTACK_DIR_RIGHT then
            if is_guard == TRUE then
                ExecEventNoReset("W_AddDamageGuardStartBack")
                return
            else
                ExecEventNoReset("W_AddDamageLv0")
                return
            end
        end
    elseif damage_dir == DAMAGE_DIR_RIGHT then
        if attack_dir == ATTACK_DIR_FRONT then
            if is_guard == TRUE then
                ExecEventNoReset("W_AddDamageGuardStartRight")
                return
            else
                ExecEventNoReset("W_AddDamageLv0")
                return
            end
        elseif attack_dir == ATTACK_DIR_UP then
            if is_guard == TRUE then
                ExecEventNoReset("W_AddDamageGuardStartRight")
                return
            else
                ExecEventNoReset("W_AddDamageLv0")
                return
            end
        elseif attack_dir == ATTACK_DIR_DOWN then
            if is_guard == TRUE then
                ExecEventNoReset("W_AddDamageGuardStartRight")
                return
            else
                ExecEventNoReset("W_AddDamageLv0")
                return
            end
        elseif attack_dir == ATTACK_DIR_LEFT then
            if is_guard == TRUE then
                ExecEventNoReset("W_AddDamageGuardStartBack")
                return
            else
                ExecEventNoReset("W_AddDamageLv0")
                return
            end
        elseif attack_dir == ATTACK_DIR_RIGHT then
            if is_guard == TRUE then
                ExecEventNoReset("W_AddDamageGuardStartFront")
                return
            else
                ExecEventNoReset("W_AddDamageLv0")
                return
            end
        end
    elseif damage_dir == DAMAGE_DIR_FRONT then
        if attack_dir == ATTACK_DIR_FRONT then
            if is_guard == TRUE then
                ExecEventNoReset("W_AddDamageGuardStartFront")
                return
            else
                ExecEventNoReset("W_AddDamageLv0")
                return
            end
        elseif attack_dir == ATTACK_DIR_UP then
            if is_guard == TRUE then
                ExecEventNoReset("W_AddDamageGuardStartFront")
                return
            else
                ExecEventNoReset("W_AddDamageLv0")
                return
            end
        elseif attack_dir == ATTACK_DIR_DOWN then
            if is_guard == TRUE then
                ExecEventNoReset("W_AddDamageGuardStartFront")
                return
            else
                ExecEventNoReset("W_AddDamageLv0")
                return
            end
        elseif attack_dir == ATTACK_DIR_LEFT then
            if is_guard == TRUE then
                ExecEventNoReset("W_AddDamageGuardStartRight")
                return
            else
                ExecEventNoReset("W_AddDamageLv0")
                return
            end
        elseif attack_dir == ATTACK_DIR_RIGHT then
            if is_guard == TRUE then
                ExecEventNoReset("W_AddDamageGuardStartLeft")
                return
            else
                ExecEventNoReset("W_AddDamageLv0")
                return
            end
        end
    elseif damage_dir == DAMAGE_DIR_BACK then
        ExecEventNoReset("W_AddDamageLv0")
    end
end

function ExecPassiveAction(is_parry, fall_type, is_attackwhileguard)
    if env(HasThrowRequest) == TRUE then
        ResetDamageCount()
        return TRUE
    elseif TRUE == ExecDeath() then
        return TRUE
    elseif env(ActionRequest, ACTION_ARM_BUDDY_DISAPPEAR) == TRUE then
        ExecEventAllBody("W_Event60505")
        return TRUE
    elseif TRUE == ExecTalk() then
        ResetDamageCount()
        return TRUE
    elseif TRUE == ExecMovableEventAnim() then
        ResetDamageCount()
        return TRUE
    elseif env(CheckForEventAnimPlaybackRequest) == TRUE then
        ResetDamageCount()
        return TRUE
    elseif ExecDamage(is_parry, is_attackwhileguard) == TRUE then
        return TRUE
    elseif ExecFallStart(fall_type) == TRUE then
        ResetDamageCount()
        return TRUE
    else
        return FALSE
    end
end

function ExecMovableEventAnim()
    local eventID = env(GetEventID)
    local commandID = env(GetCommandIDFromEvent, 0)
    if eventID <= -1 and (commandID < 60070 or commandID > 60071) then
        return FALSE
    end
    local f109_local0 = nil
    if eventID == 60071 or commandID == 60071 then
        f109_local0 = Event_EventHalfBlend60071
    elseif eventID == 60070 or commandID == 60070 then
        if c_IsStealth == TRUE then
            f109_local0 = Event_EventHalfBlend360070
        else
            f109_local0 = Event_EventHalfBlend60071
        end
    else
        ExecEventAllBody("W_Event" .. eventID)
        return TRUE
    end
    local lower_state = ALLBODY
    local locomotion = GetVariable("LocomotionState")
    if locomotion == PLAYER_STATE_MOVE then
        lower_state = UPPER
    end
    ExecEventHalfBlend(f109_local0, lower_state)
    return TRUE
end

function ExecRideEventAnim()
    local eventID = env(GetEventID)
    if eventID <= -1 then
        return FALSE
    elseif eventID == 60070 then
        ExecEventAllBody("W_Event160070")
    elseif eventID == 50250 then
        ExecEventAllBody("W_Event150250")
    else
        return FALSE
    end
    return TRUE
end

function IsLandDead(height)
    if env(GetHP) <= 0 then
        return TRUE
    elseif height > 20 and env(IsInvincibleDebugMode) == FALSE and env(GetStateChangeType, 266) == FALSE then
        return TRUE
    else
        return FALSE
    end
end

function ExecDeath()
    end
    if env(GetReceivedDamageType) == DAMAGE_TYPE_DEATH or env(GetHP) <= 0 then
        if env(GetSpEffectID, 560) == TRUE then
            return FALSE
        end

        if env(GetSpEffectID, 9999995) == TRUE then
            return FALSE
        end

        local damage_angle = env(GetReceivedDamageDirection)

        SetVariable("DamageDirection", damage_angle)

        if env(GetKnockbackDistance) < 0 then
            if damage_angle == DAMAGE_DIR_LEFT then
                damage_angle = DAMAGE_DIR_RIGHT
            elseif damage_angle == DAMAGE_DIR_RIGHT then
                damage_angle = DAMAGE_DIR_LEFT
            elseif damage_angle == DAMAGE_DIR_FRONT then
                damage_angle = DAMAGE_DIR_BACK
            elseif damage_angle == DAMAGE_DIR_BACK then
                damage_angle = DAMAGE_DIR_FRONT
            end
        end

        local damage_level = env(GetDamageLevel)

        if env(GetDamageSpecialAttribute, 3) == TRUE then
            SetVariable("IndexDeath", DEATH_TYPE_STONE)
        elseif env(GetSpecialAttribute) == 25 then
            act(DebugLogOutput, "DEATY_TYPE_MAD")
            SetVariable("IndexDeath", DEATH_TYPE_MAD)
        elseif env(IsOnLadder) == TRUE then
            SetVariable("IndexDeath", DEATH_TYPE_LADDER)
        elseif env(GetIsWeakPoint) == TRUE then
            SetVariable("IndexDeath", DEATH_TYPE_WEAK)
        elseif damage_level == DAMAGE_LEVEL_EXLARGE or damage_level == DAMAGE_LEVEL_SMALL_BLOW then
            SetVariable("IndexDeath", DEATH_TYPE_BLAST)
        elseif damage_level == DAMAGE_LEVEL_UPPER then
            SetVariable("IndexDeath", DEATH_TYPE_UPPER)
        elseif damage_level == DAMAGE_LEVEL_FLING then
            SetVariable("IndexDeath", DEATH_TYPE_FLING)
        elseif env(GetSpecialAttribute) == DAMAGE_ELEMENT_POISON or env(GetSpecialAttribute) == DAMAGE_ELEMENT_BLIGHT then
            SetVariable("IndexDeath", DEATH_TYPE_POISON)
        else
            local damageState = 0
            local physicalType = env(GetPhysicalAttribute)
            local elementType = env(GetSpecialAttribute)
            local random_roll = math.random(0, 100)

            if elementType == DAMAGE_ELEMENT_FIRE then
                damageState = 4
            elseif physicalType == DAMAGE_PHYSICAL_SLASH and random_roll < 70 then
                damageState = 1
            elseif physicalType == DAMAGE_PHYSICAL_THRUST and random_roll < 70 then
                damageState = 2
            elseif physicalType == DAMAGE_PHYSICAL_BLUNT and random_roll < 70 then
                damageState = 3
            end

            SetVariable("DamageState", damageState)

            act(DebugLogOutput, "DeathStart DamageState=" .. damageState .. " rand=" .. random_roll)

            local isMad = env(GetDamageSpecialAttribute, 6)

            act(DebugLogOutput, "elementType=" .. elementType .. " IsMad=" .. isMad)

            if damage_angle == DAMAGE_DIR_BACK then
                SetVariable("IndexDeath", DEATH_TYPE_COMMON_BACK)
            else
                SetVariable("IndexDeath", DEATH_TYPE_COMMON)
            end
        end

        ExecEventAllBody("W_DeathStart")
        return TRUE
    elseif env(IsInvincibleDebugMode) == FALSE and (env(GetStateChangeType, CONDITION_TYPE_STONE) == TRUE or env(GetStateChangeType, CONDITION_TYPE_CRYSTAL) == TRUE or env(GetDamageSpecialAttribute, 3) == TRUE) then
        SetVariable("IndexDeath", DEATH_TYPE_STONE)
        ExecEventAllBody("W_DeathStart")
        return TRUE
    else
    end
end

function CalcDamageCount()
    act(DebugLogOutput, "Calc DamageCount")

    if env(GetBehaviorID, 9) == TRUE then
        SetVariable("UseChainRecover", 1)
        return
    else
        local damagecount = GetVariable("DamageCount")

        SetVariable("DamageCount", damagecount + 1)
        SetVariable("UseChainRecover", 1)
    end
end

function ResetDamageCount()
    SetVariable("DamageCount", 0)
    SetVariable("UseChainRecover", 0)
end

function ExecDamage(is_parry, is_attackwhileguard)
    local damage_level = env(GetDamageLevel)
    local damage_type = env(GetReceivedDamageType)
    local is_damaged = env(HasReceivedAnyDamage)
    if env(Unknown362, 32) == TRUE then
        act(SetDamageAnimType, DAMAGE_FLAG_SMALL)
        ResetRequest()
        ExecEventAllBody("W_DamageBind")
        Replanning()

        return TRUE
    elseif env(GetDamageSpecialAttribute, 5) == TRUE then
        ExecEventAllBody("W_DamageSleepResist")

        return TRUE
    elseif env(GetDamageSpecialAttribute, 6) == TRUE then
        ExecEventAllBody("W_DamageMad")

        return TRUE
    elseif env(GetDamageSpecialAttribute, 2) == TRUE or env(GetDamageSpecialAttribute, 4) == TRUE then
        if damage_level == DAMAGE_LEVEL_NONE then
            if TRUE == IsNodeActive("SwordArtsOneShot Selector") and c_SwordArtsID == 136 then
            elseif env(GetSpEffectID, 6340) ~= TRUE and env(GetSpEffectID, 1650) ~= TRUE then
                if env(GetSpEffectID, 1851) == TRUE then
                else
                    damage_level = DAMAGE_LEVEL_SMALL
                end
            end
        elseif damage_level ~= DAMAGE_LEVEL_SMALL and damage_level ~= DAMAGE_LEVEL_MIDDLE and damage_level == DAMAGE_LEVEL_MINIMUM then

        else

        end
    end

    if damage_level <= DAMAGE_LEVEL_NONE and (is_damaged == FALSE or env(IsPartDamageAdditiveBlendInvalid) == TRUE) and (damage_type == DAMAGE_TYPE_INVALID or damage_type == DAMAGE_TYPE_WEAK_POINT or damage_type == DAMAGE_LEVEL_MINIMUM) then
        return FALSE
    elseif env(GetBehaviorID, 1) == TRUE then
        return FALSE
        -- Raptors of the Mist Dodge
    elseif env(GetSpEffectID, 100500) == TRUE then
        ExecEventAllBody("W_SwordArtsStandDodge")
        act(AddSpEffect, 5635)
        ResetDamageCount()

        return TRUE
    end

    local attack_dir = env(GetAtkDirection)
    local damage_angle = env(GetReceivedDamageDirection)
    local style = c_Style

    if damage_type == DAMAGE_TYPE_PARRY then
        ExecEventAllBody("W_DamageParry")

        return TRUE
    elseif damage_type >= DAMAGE_TYPE_GUARDED and damage_type <= DAMAGE_TYPE_WALL_LEFT then
        DebugPrint(1, damage_type)
        Replanning()

        if damage_type == DAMAGE_TYPE_GUARDED or damage_type == DAMAGE_TYPE_GUARDED_LEFT then
            if damage_type == DAMAGE_TYPE_GUARDED_LEFT then
                SetVariable("GuardDamageIndex", 2)
            elseif style == HAND_RIGHT then
                SetVariable("GuardDamageIndex", 0)
            elseif style == HAND_LEFT or style == HAND_RIGHT_BOTH then
                SetVariable("GuardDamageIndex", 1)
            else
                SetVariable("GuardDamageIndex", 0)
            end

            if damage_level == DAMAGE_LEVEL_NONE or damage_level == DAMAGE_LEVEL_MINIMUM then
                act(SetDamageAnimType, DAMAGE_FLAG_SMALL)
                ExecEventAllBody("W_Repelled_Small")
            elseif damage_level == DAMAGE_LEVEL_SMALL then
                act(SetDamageAnimType, DAMAGE_FLAG_SMALL)
                ExecEventAllBody("W_Repelled_Small")
            elseif damage_level == DAMAGE_LEVEL_MIDDLE or damage_level == DAMAGE_LEVEL_LARGE or damage_level == DAMAGE_LEVEL_EXLARGE or damage_level == DAMAGE_LEVEL_PUSH or damage_level == DAMAGE_LEVEL_FLING or damage_level == DAMAGE_LEVEL_SMALL_BLOW or damage_level == DAMAGE_LEVEL_UPPER or damage_level == DAMAGE_LEVEL_EX_BLAST or damage_level == DAMAGE_LEVEL_BREATH then
                act(SetDamageAnimType, DAMAGE_FLAG_LARGE)
                ExecEventAllBody("W_Repelled_Large")
            else
                act(SetDamageAnimType, DAMAGE_FLAG_SMALL)
                ExecEventAllBody("W_Repelled_Small")
            end

            return TRUE
        elseif damage_type == DAMAGE_TYPE_GUARDBREAK then
            if is_parry == TRUE then
                return FALSE
            elseif env(GetSpEffectID, 175) == TRUE then
                return FALSE
            end

            local guardindex = GUARD_STYLE_DEFAULT

            if style == HAND_RIGHT then
                guardindex = env(GetGuardMotionCategory, HAND_LEFT)

                if TRUE == GetEquipType(HAND_LEFT, WEAPON_CATEGORY_TORCH) then
                    SetVariable("IsTorchGuard", TRUE)
                else
                    SetVariable("IsTorchGuard", FALSE)
                end
            elseif style == HAND_LEFT_BOTH then
                SetVariable("IsTorchGuard", FALSE)

                if env(GetStayAnimCategory) == 15 then
                    guardindex = env(GetGuardMotionCategory, HAND_LEFT)
                end
            elseif style == HAND_RIGHT_BOTH then
                SetVariable("IsTorchGuard", FALSE)

                if env(GetStayAnimCategory) == 15 then
                    guardindex = env(GetGuardMotionCategory, HAND_RIGHT)
                end
            end

            SetVariable("IndexGuard", guardindex)
            act(SetDamageAnimType, DAMAGE_FLAG_GUARD_BREAK)

            if 202 == c_SwordArtsID and style == HAND_RIGHT and HAND_RIGHT == c_SwordArtsHand then
                ExecEventAllBody("W_GuardBreakRight")
            else
                ExecEventAllBody("W_GuardBreak")
            end

            return TRUE
        elseif damage_type == DAMAGE_TYPE_WALL_RIGHT then
            if style == HAND_RIGHT_BOTH or style == HAND_LEFT_BOTH then
                SetVariable("GuardDamageIndex", 1)
            else
                SetVariable("GuardDamageIndex", 0)
            end

            act(SetDamageAnimType, DAMAGE_FLAG_GUARD_BREAK)
            ExecEventAllBody("W_Repelled_Wall")

            return TRUE
        elseif damage_type == DAMAGE_TYPE_WALL_LEFT then
            if style == HAND_LEFT_BOTH then
                SetVariable("GuardDamageIndex", 1)
            else
                SetVariable("GuardDamageIndex", 2)
            end

            act(SetDamageAnimType, DAMAGE_FLAG_GUARD_BREAK)
            ExecEventAllBody("W_Repelled_Wall")

            return TRUE
        elseif damage_type == DAMAGE_TYPE_GUARDBREAK_BLAST then
            act(SetDamageAnimType, DAMAGE_FLAG_SMALL_BLOW)
            ExecEventAllBody("W_DamageLv7_SmallBlow")

            return TRUE
        elseif damage_type == DAMAGE_TYPE_GUARDBREAK_FLING then
            act(SetDamageAnimType, DAMAGE_FLAG_FLING)
            ExecEventAllBody("W_DamageLv6_Fling")

            return TRUE
        end
    elseif damage_type == DAMAGE_TYPE_GUARD then
        if is_parry == TRUE or is_attackwhileguard == TRUE then
            return FALSE
        elseif env(GetSpEffectID, 175) == TRUE then
            return FALSE
        elseif env(GetSpEffectID, 176) == TRUE then
            return FALSE
        end

        local guardindex = GUARD_STYLE_DEFAULT

        if style == HAND_RIGHT then
            guardindex = env(GetGuardMotionCategory, HAND_LEFT)
            if TRUE == GetEquipType(HAND_LEFT, WEAPON_CATEGORY_TORCH) then
                SetVariable("IsTorchGuard", TRUE)
            else
                SetVariable("IsTorchGuard", FALSE)
            end
        elseif style == HAND_LEFT_BOTH then
            SetVariable("IsTorchGuard", FALSE)
            if env(GetStayAnimCategory) == 15 then
                guardindex = env(GetGuardMotionCategory, HAND_LEFT)
            end
        elseif style == HAND_RIGHT_BOTH then
            SetVariable("IsTorchGuard", FALSE)
            if env(GetStayAnimCategory) == 15 then
                guardindex = env(GetGuardMotionCategory, HAND_RIGHT)
            end
        end

        SetVariable("IndexGuard", guardindex)

        local guard_damage_level = env(GetGuardLevelAction)

        if env(GetSpEffectID, 171) == TRUE and guard_damage_level < 3 then
            guard_damage_level = 3
        end

        if guard_damage_level > 0 then
            if guard_damage_level == 1 then
                act(SetDamageAnimType, DAMAGE_FLAG_GUARD_SMALL)
                ExecEventAllBody("W_GuardDamageSmall")
            elseif guard_damage_level == 3 then
                act(SetDamageAnimType, DAMAGE_FLAG_GUARD_LARGE)
                ExecEventAllBody("W_GuardDamageMiddle")
            elseif guard_damage_level == 4 then
                act(SetDamageAnimType, DAMAGE_FLAG_GUARD_EXLARGE)
                ExecEventAllBody("W_GuardDamageLarge")
            else
                act(SetDamageAnimType, DAMAGE_FLAG_GUARD_LARGE)
                ExecEventAllBody("W_GuardDamageMiddle")
            end

            return TRUE
        else
            ExecAddDamage(damage_angle, attack_dir, damage_level, TRUE, is_damaged)

            return FALSE
        end
    end

    if env(GetKnockbackDistance) < 0 then
        if damage_angle == DAMAGE_DIR_LEFT then
            damage_angle = DAMAGE_DIR_RIGHT
        elseif damage_angle == DAMAGE_DIR_RIGHT then
            damage_angle = DAMAGE_DIR_LEFT
        elseif damage_angle == DAMAGE_DIR_FRONT then
            damage_angle = DAMAGE_DIR_BACK
        elseif damage_angle == DAMAGE_DIR_BACK then
            damage_angle = DAMAGE_DIR_FRONT
        end
    end

    if env(GetSpEffectID, 89) == TRUE or env(GetSpEffectID, 100640) == TRUE then
        if damage_level == DAMAGE_LEVEL_EXLARGE then
            act(Unknown4000)
        elseif damage_level == DAMAGE_LEVEL_LARGE or damage_level == DAMAGE_LEVEL_PUSH or damage_level == DAMAGE_LEVEL_FLING or damage_level == DAMAGE_LEVEL_SMALL_BLOW or damage_level == DAMAGE_LEVEL_UPPER or damage_level == DAMAGE_LEVEL_EX_BLAST or damage_level == DAMAGE_LEVEL_BREATH or env(GetIsWeakPoint) == TRUE then
            act(Unknown4000)
            damage_level = DAMAGE_LEVEL_SMALL_BLOW
        else
            if damage_level == DAMAGE_LEVEL_MIDDLE or damage_level == DAMAGE_LEVEL_SMALL then
                CalcDamageCount()
                act(Unknown4000)
                hkbFireEvent("W_JumpDamage_Start")
                SetVariable("Int16Variable04", 0)
                act(SetDamageAnimType, 3)
                ResetRequest()
                return TRUE
            end

            damage_level = DAMAGE_LEVEL_NONE
        end
    end
    local height = env(GetFallHeight) / 100
    if env(IsFalling) == TRUE and env(GetBehaviorID, 10) == TRUE and height >= 10 then
        damage_level = DAMAGE_LEVEL_NONE
    end
    if env(GetIsWeakPoint) == TRUE then
        CalcDamageCount()
        SetVariable("DamageDirection", damage_angle)
        act(SetDamageAnimType, DAMAGE_FLAG_WEAK)
        ExecEventAllBody("W_DamageWeak")
        Replanning()

        return TRUE
    elseif damage_level == DAMAGE_LEVEL_NONE then
        ExecAddDamage(damage_angle, attack_dir, damage_level, FALSE, is_damaged)

        return FALSE
    elseif damage_level == DAMAGE_LEVEL_SMALL then
        CalcDamageCount()
        SetVariable("DamageDirection", damage_angle)
        SetVariable("IndexDamageLv1_Small_AttackDirection", attack_dir)
        act(SetDamageAnimType, DAMAGE_FLAG_SMALL)
        ExecEventAllBody("W_DamageLv1_Small")
        Replanning()

        return TRUE
    elseif damage_level == DAMAGE_LEVEL_MIDDLE then
        CalcDamageCount()
        SetVariable("DamageDirection", damage_angle)
        SetVariable("IndexDamageLv2_Middle_AttackDirection", attack_dir)
        act(SetDamageAnimType, DAMAGE_FLAG_MEDIUM)
        ExecEventAllBody("W_DamageLv2_Middle")
        Replanning()

        return TRUE
    elseif damage_level == DAMAGE_LEVEL_LARGE then
        CalcDamageCount()
        SetVariable("DamageDirection", damage_angle)
        SetVariable("IndexDamageLv3_Large_AttackDirection", attack_dir)
        act(SetDamageAnimType, DAMAGE_FLAG_LARGE)
        Replanning()

        if env(GetBehaviorID, 3) == TRUE then
            ExecEventAllBody("W_DamageLarge2")
            return TRUE
        else
            ExecEventAllBody("W_DamageLv3_Large")
            return TRUE
        end
    elseif damage_level == DAMAGE_LEVEL_EXLARGE then
        ResetDamageCount()
        SetVariable("DamageDirection", damage_angle)
        act(SetDamageAnimType, DAMAGE_FLAG_LARGE_BLOW)
        ExecEventAllBody("W_DamageLv4_ExLarge")
        Replanning()

        return TRUE
    elseif damage_level == DAMAGE_LEVEL_EX_BLAST then
        ResetDamageCount()
        SetVariable("DamageDirection", damage_angle)
        act(SetDamageAnimType, DAMAGE_FLAG_LARGE_BLOW)
        ExecEventAllBody("W_DamageLV10_ExBlast")
        Replanning()

        return TRUE
    elseif damage_level == DAMAGE_LEVEL_PUSH then
        CalcDamageCount()
        SetVariable("DamageDirection", damage_angle)
        act(SetDamageAnimType, DAMAGE_FLAG_PUSH)
        ExecEventAllBody("W_DamageLv5_Push")
        Replanning()

        return TRUE
    elseif damage_level == DAMAGE_LEVEL_SMALL_BLOW then
        ResetDamageCount()
        SetVariable("DamageDirection", damage_angle)
        act(SetDamageAnimType, DAMAGE_FLAG_SMALL_BLOW)
        ExecEventAllBody("W_DamageLv7_SmallBlow")
        Replanning()

        return TRUE
    elseif damage_level == DAMAGE_LEVEL_UPPER then
        ResetDamageCount()
        SetVariable("DamageDirection", damage_angle)
        act(SetDamageAnimType, DAMAGE_FLAG_LARGE_BLOW)
        ExecEventAllBody("W_DamageLv9_Upper")
        Replanning()

        return TRUE
    elseif damage_level == DAMAGE_LEVEL_MINIMUM then
        CalcDamageCount()

        local pre_index = GetVariable("IndexDamageLv8_Minimum_Random")
        local index = (pre_index + math.random(1, 2)) % 3

        SetVariable("IndexDamageLv8_Minimum_Random", index)
        act(SetDamageAnimType, DAMAGE_FLAG_MINIMUM)
        ExecEventAllBody("W_DamageLv8_Minimum")
        Replanning()

        return TRUE
    elseif damage_level == DAMAGE_LEVEL_FLING then
        ResetDamageCount()
        SetVariable("DamageDirection", damage_angle)
        act(SetDamageAnimType, DAMAGE_FLAG_FLING)
        ExecEventAllBody("W_DamageLv6_Fling")
        Replanning()

        return TRUE
    elseif damage_level == DAMAGE_LEVEL_BREATH then
        ResetDamageCount()
        SetVariable("DamageDirection", damage_angle)
        act(SetDamageAnimType, DAMAGE_FLAG_BREATH)
        ExecEventAllBody("W_DamageLv11_Breath")
        Replanning()

        return TRUE
    else
        return FALSE
    end
end

function GetLandIndex(height, is_jump)
    if 8 < height then
        return LAND_HEAVY
    elseif height > 4 then
        return LAND_MIDDLE
    elseif is_jump == TRUE and height > 0 then
        return LAND_JUMP
    else
        return LAND_DEFAULT
    end
end

function FallCommonFunction(is_enable_falling_death, is_jump, fall_style)
    local height = env(GetFallHeight) / 100
    local damage_type = env(GetReceivedDamageType)
    local style = c_Style

    if damage_type == DAMAGE_TYPE_DEATH_FALLING then
        if fall_style == FALL_FACEUP then
            ExecEventAllBody("W_FallDeathFaceUp")
        elseif fall_style == FALL_FACEDOWN then
            ExecEventAllBody("W_FallDeathFaceDown")
        else
            ExecEventAllBody("W_FallDeath")
        end
        return TRUE
    elseif is_enable_falling_death == TRUE and height >= 60 then
        if env(GetStateChangeType, 266) == TRUE then
        else
            if fall_style == FALL_FACEUP then
                ExecEventAllBody("W_FallDeathFaceUp")
            elseif fall_style == FALL_FACEDOWN then
                ExecEventAllBody("W_FallDeathFaceDown")
            else
                ExecEventAllBody("W_FallDeath")
            end
            return TRUE
        end
    end

    act(SetIsEquipmentChangeableFromMenu)

    if env(IsLanding) == TRUE then
        IS_ATTACKED_JUMPMAGIC = FALSE

        if env(GetStateChangeType, 266) == TRUE then
            Replanning()
            SetVariable("LandIndex", LAND_MIDDLE)
            ExecEventAllBody("W_Land")
            return TRUE
        elseif fall_style == FALL_DEFAULT then
            if IsLandDead(height) == TRUE then
                if height > 8 then
                    SetVariable("IndexDeath", DEATH_TYPE_LAND)
                else
                    SetVariable("IndexDeath", DEATH_TYPE_LAND_LOW)
                end

                ExecEventAllBody("W_DeathStart")

                return TRUE
            elseif height > 1.2999999523162842 then
                local landIndex = GetLandIndex(height, is_jump)

                SetVariable("LandIndex", landIndex)
                Replanning()
                local JumpMoveLevel = 0

                if landIndex ~= LAND_HEAVY then
                    if GetVariable("MoveSpeedLevel") > 1.100000023841858 then
                        JumpMoveLevel = 2
                    elseif GetVariable("MoveSpeedLevel") > 0.6000000238418579 then
                        JumpMoveLevel = 1
                    end
                end

                if env(GetSpEffectID, 503520) == TRUE then
                    JumpMoveLevel = 0
                elseif env(GetSpEffectID, 5520) == TRUE then
                    JumpMoveLevel = 0
                elseif env(GetSpEffectID, 425) == TRUE then
                    JumpMoveLevel = 0
                elseif env(GetSpEffectID, 4101) == TRUE then
                    JumpMoveLevel = 0
                elseif env(GetSpEffectID, 4100) == TRUE then
                    JumpMoveLevel = 0
                end

                if JumpMoveLevel == 2 then
                    ExecEventNoReset("W_Jump_Land_To_Dash")
                    return TRUE
                elseif JumpMoveLevel == 1 then
                    SetVariable("JumpLandMoveDirection", GetVariable("MoveDirection"))
                    ExecEventNoReset("W_Jump_Land_To_Run")
                    return TRUE
                end

                ExecEventAllBody("W_Land")
            else
                act(Unknown9999)

                if height > 0.30000001192092896 then
                    ExecEventAllBody("W_LandLow")
                else
                    ExecEventAllBody("W_Idle")
                end
            end
            return TRUE
        elseif fall_style == FALL_FACEUP then
            if IsLandDead(height) == TRUE then
                SetVariable("IndexDeath", DEATH_TYPE_LAND_FACEUP)
                ExecEventAllBody("W_DeathStart")
            else
                Replanning()
                ExecEventAllBody("W_LandFaceUp")
            end

            return TRUE
        elseif fall_style == FALL_FACEDOWN then
            if IsLandDead(height) == TRUE then
                SetVariable("IndexDeath", DEATH_TYPE_LAND_FACEDOWN)
                ExecEventAllBody("W_DeathStart")
            else
                Replanning()
                ExecEventAllBody("W_LandFaceDown")
            end

            return TRUE
        elseif fall_style == FALL_LADDER then
            if IsLandDead(height) == TRUE then
                SetVariable("IndexDeath", DEATH_TYPE_LAND)
                ExecEventAllBody("W_DeathStart")
            else
                Replanning()
                ExecEventAllBody("W_LadderFallLanding")
            end

            return TRUE
        end
    end

    local arrowHand = HAND_RIGHT

    if style == HAND_LEFT_BOTH then
        arrowHand = HAND_LEFT
    end

    local is_arrow = GetEquipType(arrowHand, WEAPON_CATEGORY_SMALL_ARROW, WEAPON_CATEGORY_ARROW, WEAPON_CATEGORY_LARGE_ARROW, WEAPON_CATEGORY_CROSSBOW, WEAPON_CATEGORY_BALLISTA)

    if is_arrow == TRUE then
        if env(ActionRequest, 0) == TRUE then
            act(ChooseBowAndArrowSlot, 0)
            g_ArrowSlot = 0
        elseif env(ActionRequest, 1) == TRUE then
            act(ChooseBowAndArrowSlot, 1)
            g_ArrowSlot = 1
        end
    end

    if fall_style == FALL_DEFAULT and height >= 0.20000000298023224 then
        if TRUE == ExecFallMagic() then
            return TRUE
        elseif TRUE == ExecFallAttack() then
            return TRUE
        end
    end

    return FALSE
end

function ExecFallAttack()
    if env(ActionRequest, ACTION_ARM_R1) == TRUE or env(ActionRequest, ACTION_ARM_R2) == TRUE or env(ActionRequest, ACTION_ARM_L1) == TRUE and IsEnableDualWielding() == HAND_RIGHT then
        local style = c_Style
        local hand = HAND_RIGHT

        if style == HAND_LEFT_BOTH then
            hand = HAND_LEFT
        end

        local is_arrow = GetEquipType(hand, WEAPON_CATEGORY_SMALL_ARROW, WEAPON_CATEGORY_ARROW, WEAPON_CATEGORY_LARGE_ARROW, WEAPON_CATEGORY_CROSSBOW, WEAPON_CATEGORY_BALLISTA)
        local is_staff = GetEquipType(hand, WEAPON_CATEGORY_STAFF)

        if env(ActionRequest, ACTION_ARM_R1) == TRUE or is_arrow == TRUE then
            if is_staff == TRUE then
                return FALSE
            end

            SetVariable("JumpAttackForm", 1)
            SetVariable("JumpAttackFormRequest", 0)
        elseif env(ActionRequest, ACTION_ARM_R2) == TRUE then
            SetVariable("JumpAttackForm", 2)
            SetVariable("JumpAttackFormRequest", 1)
        elseif env(ActionRequest, ACTION_ARM_L1) == TRUE then
            if IsEnableDualWielding() ~= HAND_RIGHT then
                return FALSE
            end

            SetVariable("JumpAttackForm", 3)
            SetVariable("JumpAttackFormRequest", 2)
        end

        if is_arrow == TRUE and (style == HAND_LEFT_BOTH or style == HAND_RIGHT_BOTH) and env(IsOutOfAmmo, hand) == TRUE then
            return FALSE
        elseif GetEquipType(hand, WEAPON_CATEGORY_CROSSBOW) == TRUE and env(GetBoltLoadingState, hand) == FALSE then
            return FALSE
        elseif style == HAND_RIGHT then
            SetVariable("JumpAttack_HandCondition", 0)
        elseif style == HAND_RIGHT_BOTH then
            SetVariable("JumpAttack_HandCondition", 1)
        elseif style == HAND_LEFT_BOTH then
            if TRUE == GetEquipType(HAND_LEFT, WEAPON_CATEGORY_CROSSBOW) then
                SetVariable("JumpAttack_HandCondition", 4)
            else
                SetVariable("JumpAttack_HandCondition", 1)
            end
        end

        SetVariable("JumpAttack_Land", 0)
        ExecEventAllBody("W_JumpAttack_Start_Falling")

        return TRUE
    else
        return FALSE
    end
end

function ExecGuardOnCancelTiming(guardcondition, blend_type)
    if env(IsGuardFromAtkCancel) == FALSE then
        return FALSE
    end

    act(DebugLogOutput, "ExecGuardOnCancelTiming " .. guardcondition)

    if guardcondition == TO_GUARDON then
        if ExecGuard(Event_GuardOn, blend_type) == TRUE then
            return TRUE
        end
    elseif ExecGuard(Event_GuardStart, blend_type) == TRUE then
        return TRUE
    end

    return FALSE
end

function LadderIdleCommonFunction(hand)
    act(SetIsEquipmentChangeableFromMenu)

    if ExecLadderDeath() == TRUE then
        return TRUE
    elseif ExecLadderDamageIdle(hand) == TRUE then
        return TRUE
    elseif ExecLadderAttack(hand) == TRUE then
        return TRUE
    elseif ExecLadderItem(hand) == TRUE then
        return TRUE
    elseif ExecLadderMove(hand) == TRUE then
        return TRUE
    else
        return FALSE
    end
end

function LadderMoveCommonFunction(hand, is_no_damage)
    act(SetIsEquipmentChangeableFromMenu)

    if ExecLadderDeath() == TRUE then
        return TRUE
    elseif is_no_damage == FALSE and TRUE == ExecLadderDamageMove() then

    else

    end

    if TRUE == env(IsAnimEnd, 1) then
        if CheckLadderDamage(hand) == TRUE then
            return TRUE
        elseif ExecLadderAttack(hand) == TRUE then
            return TRUE
        elseif ExecLadderItem(hand) == TRUE then
            return TRUE
        elseif ExecLadderMove(hand) == TRUE then
            return TRUE
        elseif hand == HAND_STATE_LEFT then
            ExecEvent("W_LadderIdleLeft")
        else
            ExecEvent("W_LadderIdleRight")
        end

        return TRUE
    else
        return FALSE
    end
end

function LadderAttackCommonFunction(hand)
    act(SetIsEquipmentChangeableFromMenu)

    if ExecLadderDeath() == TRUE then
        return TRUE
    elseif ExecLadderDamageIdle(hand) == TRUE then
        return TRUE
    elseif TRUE == env(IsAnimEnd, 1) then
        if ExecLadderAttack(hand) == TRUE then
            return TRUE
        elseif ExecLadderItem(hand) == TRUE then
            return TRUE
        elseif ExecLadderMove(hand) == TRUE then
            return TRUE
        elseif hand == HAND_STATE_LEFT then
            ExecEvent("W_LadderIdleLeft")
        else
            ExecEvent("W_LadderIdleRight")
        end

        return TRUE
    else
        return FALSE
    end
end

function LadderDamageCommonFunction(hand)
    act(SetIsEquipmentChangeableFromMenu)

    if ExecLadderDeath() == TRUE then
        return TRUE
    elseif ExecLadderDamageIdle(hand) == TRUE then
        return TRUE
    elseif TRUE == env(IsAnimEnd, 1) then
        if ExecLadderAttack(hand) == TRUE then
            return TRUE
        elseif ExecLadderItem(hand) == TRUE then
            return TRUE
        elseif ExecLadderMove(hand) == TRUE then
            return TRUE
        elseif hand == HAND_STATE_RIGHT then
            ExecEvent("W_LadderIdleRight")
        else
            ExecEvent("W_LadderIdleLeft")
        end

        return TRUE
    else
        return FALSE
    end
end

function LadderEndCommonFunction()
    act(SetIsEquipmentChangeableFromMenu)

    if ExecLadderDeath() == TRUE then
        LadderSetActionState(LADDER_ACTION_INVALID)

        return TRUE
    elseif TRUE == ExecFallStart(FALL_TYPE_DEFAULT) then
        LadderSetActionState(LADDER_ACTION_INVALID)

        return TRUE
    elseif TRUE == ExecJump() then
        LadderSetActionState(LADDER_ACTION_INVALID)

        return TRUE
    elseif TRUE == ExecHandChange(HAND_RIGHT, FALSE, ALLBODY) then
        LadderSetActionState(LADDER_ACTION_INVALID)

        return TRUE
    elseif TRUE == ExecGuardOnCancelTiming(FALSE, ALLBODY) then
        LadderSetActionState(LADDER_ACTION_INVALID)

        return TRUE
    elseif TRUE == ExecWeaponChange(ALLBODY) then
        LadderSetActionState(LADDER_ACTION_INVALID)

        return TRUE
    elseif TRUE == ExecEvasion(FALSE, ESTEP_NONE, FALSE) then
        LadderSetActionState(LADDER_ACTION_INVALID)

        return TRUE
    elseif TRUE == ExecItem(QUICKTYPE_NORMAL, ALLBODY) then
        LadderSetActionState(LADDER_ACTION_INVALID)

        return TRUE
    elseif TRUE == ExecMagic(QUICKTYPE_NORMAL, ALLBODY, FALSE) then
        LadderSetActionState(LADDER_ACTION_INVALID)
    end

    if TRUE == ExecArtsStanceOnCancelTiming(ALLBODY) then
        LadderSetActionState(LADDER_ACTION_INVALID)

        return TRUE
    elseif TRUE == ExecAttack("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, ALLBODY, FALSE, FALSE, FALSE) then
        LadderSetActionState(LADDER_ACTION_INVALID)

        return TRUE
    elseif TRUE == MoveStartonCancelTiming(Event_Move, FALSE) then
        LadderSetActionState(LADDER_ACTION_INVALID)

        return TRUE
    else
        return FALSE
    end
end

function LadderItemCommonFunction(hand, tonext)
    act(SetIsItemAnimationPlaying)
    act(SetIsEquipmentChangeableFromMenu)

    if ExecLadderDeath() == TRUE then
        return TRUE
    elseif ExecLadderDamageIdle(hand) == TRUE then
        return TRUE
    elseif TRUE == env(IsAnimEnd, 1) then
        if ExecLadderItem(hand) == TRUE then
            return TRUE
        elseif tonext == FALSE then
            if ExecLadderAttack(hand) == TRUE then
                return TRUE
            elseif ExecLadderMove(hand) == TRUE then
                return TRUE
            elseif hand == HAND_STATE_RIGHT then
                ExecEvent("W_LadderIdleRight")
            else
                ExecEvent("W_LadderIdleLeft")
            end
            return TRUE
        else
            return FALSE
        end
    else
        return FALSE
    end
end

function CheckLadderDamage(hand)
    local damage_flag = Flag_LadderDamage

    if damage_flag == LADDER_DAMAGE_SMALL then
        act(ChangeStamina, -30)

        if ExecLadderFall() == TRUE then
            return TRUE
        elseif hand == HAND_STATE_LEFT then
            ExecEvent("W_LadderDamageSmallLeft")
        else
            ExecEvent("W_LadderDamageSmallRight")
        end
    elseif damage_flag == LADDER_DAMAGE_LARGE then
        act(ChangeStamina, -40)

        if ExecLadderFall() == TRUE then
            return TRUE
        elseif hand == HAND_STATE_LEFT then
            ExecEvent("W_LadderDamageLargeLeft")
        else
            ExecEvent("W_LadderDamageLargeRight")
        end
    else
        Flag_LadderDamage = LADDER_DAMAGE_NONE
        return FALSE
    end

    Flag_LadderDamage = LADDER_DAMAGE_NONE

    return TRUE
end

function ExecLadderDeath()
    local hp = env(GetHP)

    if hp <= 0 or env(GetStateChangeType, CONDITION_TYPE_STONE) == TRUE or env(GetStateChangeType, CONDITION_TYPE_CRYSTAL) == TRUE or env(GetDamageSpecialAttribute, 3) == TRUE then
        ExecEvent("W_LadderDeathStart")
        return TRUE
    else
        return FALSE
    end
end

function ExecLadderDamageIdle(hand)
    if env(HasReceivedAnyDamage) == FALSE then
        return FALSE
    elseif env(GetStamina) <= 80 then
        act(ChangeStamina, -40)

        if ExecLadderFall() == TRUE then
            return TRUE
        elseif hand == HAND_STATE_LEFT then
            ExecEvent("W_LadderDamageLargeLeft")
        else
            ExecEvent("W_LadderDamageLargeRight")
        end
    else
        act(ChangeStamina, -30)
        if ExecLadderFall() == TRUE then
            return TRUE
        elseif hand == HAND_STATE_LEFT then
            ExecEvent("W_LadderDamageSmallLeft")
        else
            ExecEvent("W_LadderDamageSmallRight")
        end
    end
    return TRUE
end

function ExecLadderDamageMove()
    if env(HasReceivedAnyDamage) == FALSE then
        return FALSE
    elseif env(GetStamina) <= 80 then
        Flag_LadderDamage = LADDER_DAMAGE_LARGE
    else
        Flag_LadderDamage = LADDER_DAMAGE_SMALL
    end
    return TRUE
end

function ExecLadderFall()
    if env(GetStamina) > 0 and env(GetDamageSpecialAttribute, 5) == FALSE then
        return FALSE
    else
        ExecEvent("W_LadderFallStart")
        return TRUE
    end
end

function GetLadderEventCommand(is_start)
    if env(IsCOMPlayer) == FALSE then
        return env(GetCommandIDFromEvent, 0)
    end

    local req_up = env(ActionRequest, ACTION_ARM_LADDERUP)
    local req_down = env(ActionRequest, ACTION_ARM_LADDERDOWN)

    if is_start == TRUE then
        if req_up == TRUE then
            return LADDER_ACTION_START_BOTTOM
        elseif req_down == TRUE then
            return LADDER_ACTION_START_TOP
        end
    elseif req_up == TRUE then
        if env(IsReachTopOfLadder) == TRUE then
            return LADDER_EVENT_COMMAND_END_TOP
        else
            return LADDER_EVENT_COMMAND_UP
        end
    elseif req_down == TRUE then
        if env(IsReachBottomOfLadder) == TRUE then
            return LADDER_EVENT_COMMAND_END_BOTTOM
        else
            return LADDER_EVENT_COMMAND_DOWN
        end
    end

    return INVALID
end

function ExecLadderMove(hand)
    local sp_action = env(ActionDuration, ACTION_ARM_SP_MOVE)

    if sp_action == 0 then
        if Flag_LadderJump == LADDER_JUMP_WHEN_RELEASE and env(ActionRequest, ACTION_ARM_BACKSTEP) == TRUE and env(IsOnLastRungOfLadder) == FALSE then
            LadderSendCommand(LADDER_EVENT_COMMAND_EXIT)
            LadderSetActionState(LADDER_ACTION_INVALID)
            ExecEvent("W_LadderDrop")
            return TRUE
        end

        Flag_LadderJump = LADDER_JUMP_SP_RELEASED
    elseif sp_action < 150 then
        if Flag_LadderJump == LADDER_JUMP_SP_RELEASED then
            Flag_LadderJump = LADDER_JUMP_WHEN_RELEASE
        end
    else
        Flag_LadderJump = LADDER_JUMP_INVALID
    end

    local event_command = GetLadderEventCommand(FALSE)

    if event_command <= 0 then
        return FALSE
    elseif event_command == LADDER_EVENT_COMMAND_UP then
        if env(IsCOMPlayer) == TRUE and env(DoesLadderHaveCharacters, LADDER_UP_CHECK_DIST, 1, 1) == TRUE then
            if hand == HAND_STATE_RIGHT then
                ExecEvent("W_LadderAttackUpRight")
            else
                ExecEvent("W_LadderAttackUpLeft")
            end
            return TRUE
        elseif env(IsSomeoneOnLadder, LADDER_UP_CHECK_DIST, 0) == TRUE then
            return FALSE
        elseif env(ActionDuration, ACTION_ARM_SP_MOVE) > 0 then
            SetVariable("IsFastUp", TRUE)
        else
            SetVariable("IsFastUp", FALSE)
        end

        if hand == HAND_STATE_LEFT then
            ExecEvent("W_LadderUpLeft")
        else
            ExecEvent("W_LadderUpRight")
        end

        return TRUE
    elseif event_command == LADDER_EVENT_COMMAND_DOWN then
        if env(IsCOMPlayer) == TRUE and env(DoesLadderHaveCharacters, LADDER_DOWN_CHECK_DIST, 0, 1) == TRUE then
            if hand == HAND_STATE_RIGHT then
                ExecEvent("W_LadderAttackDownRight")
            else
                ExecEvent("W_LadderAttackDownLeft")
            end
            return TRUE
        elseif env(IsSomeoneUnderLadder, LADDER_DOWN_CHECK_DIST, 0) == TRUE then
            return FALSE
        elseif env(ActionDuration, ACTION_ARM_SP_MOVE) > 0 then
            ExecEvent("W_LadderCoastStart")
            return TRUE
        elseif hand == HAND_STATE_LEFT then
            ExecEvent("W_LadderDownLeft")
        else
            ExecEvent("W_LadderDownRight")
        end

        return TRUE
    elseif event_command == LADDER_EVENT_COMMAND_END_TOP then
        if hand == HAND_STATE_LEFT then
            ExecEvent("W_LadderEndTopLeft")
        else
            ExecEvent("W_LadderEndTopRight")
        end

        return TRUE
    elseif event_command == LADDER_EVENT_COMMAND_END_BOTTOM then
        if hand == HAND_STATE_LEFT then
            ExecEvent("W_LadderEndBottomLeft")
        else
            ExecEvent("W_LadderEndBottomRight")
        end

        return TRUE
    else
        return FALSE
    end
end

function LadderStart()
    local event_command = GetLadderEventCommand(TRUE)

    if event_command == LADDER_ACTION_START_BOTTOM then
        ExecEvent("W_LadderAttachBottom")
        return TRUE
    elseif event_command == LADDER_ACTION_START_TOP then
        ExecEvent("W_LadderAttachTop")
        return TRUE
    else
        return FALSE
    end
end

function LadderSetActionState(state)
    act(SetLadderActionState, state)
end

function LadderSendCommand(event_call)
    act(SendMessageIDToEvents, event_call)
end

function ExecLadderAttack(hand)
    if env(GetStamina) <= 0 then
        return FALSE
    elseif env(ActionRequest, ACTION_ARM_R1) == TRUE then
        if hand == HAND_STATE_RIGHT then
            ExecEvent("W_LadderAttackUpRight")
        else
            ExecEvent("W_LadderAttackUpLeft")
        end

        return TRUE
    elseif env(ActionRequest, ACTION_ARM_R2) == TRUE then
        if hand == HAND_STATE_RIGHT then
            ExecEvent("W_LadderAttackDownRight")
        else
            ExecEvent("W_LadderAttackDownLeft")
        end

        return TRUE
    else
        return FALSE
    end
end

function LadderCoastCommonFunction(hand, is_start)
    act(SetIsEquipmentChangeableFromMenu)

    if ExecLadderDeath() == TRUE then
        return TRUE
    elseif TRUE == ExecLadderDamageMove() then

    else

    end

    if is_start == FALSE then
        if TRUE == env(IsOnLastRungOfLadder) then
            ExecEvent("W_LadderCoastLanding")
            return TRUE
        end

        local event_command = GetLadderEventCommand(FALSE)

        if not (env(ActionDuration, ACTION_ARM_SP_MOVE) > 0 and env(MovementRequestDuration) > 0 and (event_command <= 0 or event_command == LADDER_EVENT_COMMAND_DOWN)) or TRUE == env(IsSomeoneUnderLadder, LADDER_DOWN_CHECK_DIST, 0) then
            act(LadderSlideDownCancel)
            if env(GetNumberOfRungsBelowOnLadder) % 2 == 0 then
                ExecEvent("W_LadderCoastStopRight")
            else
                ExecEvent("W_LadderCoastStopLeft")
            end
            return TRUE
        end
    elseif TRUE == env(IsAnimEnd, 1) then
        if CheckLadderDamage(hand) == TRUE then
            return TRUE
        else
            ExecEvent("W_LadderCoastLeft")
            return TRUE
        end
    end

    return FALSE
end

function IdleCommonFunction()
    if env(IsCOMPlayer) == TRUE then
        act(LockonSystemUnableToTurnAngle, 15, 15)
    else
        act(LockonSystemUnableToTurnAngle, 45, 45)
    end

    act(Wait)
    act(Unknown2040)
    SetEnableAimMode()

    if TRUE == ExecPassiveAction(FALSE, FALL_TYPE_DEFAULT, FALSE) then
        return TRUE
    elseif TRUE == LadderStart() then
        return TRUE
    elseif FALSE == c_IsStealth and TRUE == ExecQuickTurn(ALLBODY, TURN_TYPE_DEFAULT) then
        return TRUE
    elseif TRUE == ExecJump() then
        return TRUE
    elseif TRUE == ExecHandChange(HAND_RIGHT, FALSE, ALLBODY) then
        return TRUE
    elseif TRUE == ExecGuard(Event_GuardStart, ALLBODY) then
        return TRUE
    elseif TRUE == ExecWeaponChange(ALLBODY) then
        return TRUE
    elseif TRUE == ExecEvasion(FALSE, ESTEP_NONE, FALSE) then
        return TRUE
    elseif TRUE == ExecItem(QUICKTYPE_NORMAL, ALLBODY) then
        return TRUE
    elseif TRUE == ExecMagic(QUICKTYPE_NORMAL, ALLBODY, FALSE) then
        return TRUE
    elseif TRUE == ExecArtsStance(ALLBODY) then
        return TRUE
    elseif TRUE == ExecRide() then
        return TRUE
    end

    local r1 = "W_AttackRightLight1"
    local b1 = "W_AttackBothLight1"

    if c_IsStealth == TRUE then
        r1 = "W_AttackRightLightStealth"
        b1 = "W_AttackBothLightStealth"
    end

    if ExecAttack(r1, "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, "W_AttackBothHeavy1Start", FALSE, ALLBODY, FALSE, FALSE, FALSE) == TRUE then
        return TRUE
    elseif c_IsStealth == TRUE then
        if TRUE == MoveStart(ALLBODY, Event_Stealth_Move, FALSE) then
            return TRUE
        end
    elseif TRUE == MoveStart(ALLBODY, Event_Move, FALSE) then
        return TRUE
    end

    if TRUE == ExecGesture() then
        return TRUE
    else
        return FALSE
    end
end

function SetAttackQueue(r1, r2, l1, l2, b1, b2)
    g_r1 = r1
    g_r2 = r2
    g_l1 = l1
    g_l2 = l2
    g_b1 = b1
    g_b2 = b2
end

function ClearAttackQueue()
    g_r1 = "W_AttackRightLight1"
    g_r2 = "W_AttackRightHeavy1Start"
    g_l1 = "W_AttackLeftLight1"
    g_l2 = "W_AttackLeftHeavy1"
    g_b1 = "W_AttackBothLight1"
    g_b2 = "W_AttackBothHeavy1Start"
end

function AttackCommonFunction(r1, r2, l1, l2, b1, b2, guardcondition, use_atk_queue, comboCount, gen_hand)
    if gen_hand == nil then
        gen_hand = FALSE
    end

    SetVariable("ToggleDash", 0)

    act(Unknown2027)
    SetThrowAtkInvalid()
    SetAIActionState()

    local bool = FALSE

    if guardcondition == TO_GUARDON then
        bool = TRUE
    end

    if ExecPassiveAction(FALSE, FALL_TYPE_DEFAULT, bool) == TRUE then
        return TRUE
    elseif TRUE == ExecWeaponChange(ALLBODY) then
        return TRUE
    elseif ExecEvasion(FALSE, ESTEP_NONE, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecItem(QUICKTYPE_ATTACK, ALLBODY) then
        if use_atk_queue == TRUE then
            SetAttackQueue(r1, r2, l1, l2, b1, b2)
        end

        return TRUE
    elseif ExecMagic(QUICKTYPE_ATTACK, ALLBODY, FALSE) == TRUE then
        return TRUE
    elseif ExecAttack(r1, r2, l1, l2, b1, b2, guardcondition, ALLBODY, FALSE, FALSE, FALSE) == TRUE then
        if use_atk_queue == TRUE then
            SetAttackQueue(r1, r2, l1, l2, b1, b2)
        end

        return TRUE
    elseif TRUE == ExecQuickTurnOnCancelTiming() then
        return TRUE
    elseif TRUE == ExecJump() then
        return TRUE
    elseif ExecHandChange(HAND_RIGHT, FALSE, ALLBODY) == TRUE then
        return TRUE
    elseif ExecGuardOnCancelTiming(guardcondition, ALLBODY) == TRUE then
        return TRUE
    elseif TRUE == ExecArtsStanceOnCancelTiming(ALLBODY) then
        return TRUE
    elseif MoveStartonCancelTiming(Event_Move, gen_hand) == TRUE then
        return TRUE
    elseif TRUE == ExecGesture() then
        return TRUE
    else
        return FALSE
    end
end

function BackStabCommonFunction()
    SetAIActionState()

    if ExecPassiveAction(FALSE, FALL_TYPE_DEFAULT, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecWeaponChange(ALLBODY) then
        return TRUE
    elseif ExecEvasion(FALSE, ESTEP_NONE, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecItem(QUICKTYPE_ATTACK, ALLBODY) then
        return TRUE
    elseif ExecMagic(QUICKTYPE_ATTACK, ALLBODY, FALSE) == TRUE then
        return TRUE
    elseif ExecAttack("W_AttackRightLight2", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight2", "W_AttackBothHeavy1Start", FALSE, ALLBODY, FALSE, FALSE, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecQuickTurnOnCancelTiming() then
        return TRUE
    elseif TRUE == ExecJump() then
        return TRUE
    elseif ExecHandChange(HAND_RIGHT, FALSE, ALLBODY) == TRUE then
        return TRUE
    elseif ExecGuardOnCancelTiming(FALSE, ALLBODY) == TRUE then
        return TRUE
    elseif TRUE == ExecArtsStanceOnCancelTiming(ALLBODY) then
        return TRUE
    elseif MoveStartonCancelTiming(Event_Move, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecGesture() then
        return TRUE
    else
        return FALSE
    end
end

function ThrowCommonFunction(estep)
    if env(IsThrowing) == FALSE then
        if ExecDeath() == TRUE then
            return TRUE
        elseif env(CheckForEventAnimPlaybackRequest) == TRUE then
            return TRUE
        elseif ExecDamage(FALSE) == TRUE then
            return TRUE
        end
    end

    if TRUE == ExecFallStart(FALL_TYPE_DEFAULT) then
        return TRUE
    elseif TRUE == ExecQuickTurnOnCancelTiming() then
        return TRUE
    elseif TRUE == ExecJump() then
        return TRUE
    elseif ExecHandChange(HAND_RIGHT, FALSE, ALLBODY) == TRUE then
        return TRUE
    elseif ExecGuardOnCancelTiming(FALSE, ALLBODY) == TRUE then
        return TRUE
    elseif TRUE == ExecWeaponChange(ALLBODY) then
        return TRUE
    elseif ExecEvasion(FALSE, estep, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecItem(QUICKTYPE_NORMAL, ALLBODY) then
        return TRUE
    elseif ExecMagic(QUICKTYPE_NORMAL, ALLBODY, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecArtsStanceOnCancelTiming(ALLBODY) then
        return TRUE
    elseif ExecAttack("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, ALLBODY, FALSE, FALSE, FALSE) == TRUE then
        return TRUE
    elseif MoveStartonCancelTiming(Event_MoveQuick, FALSE) == TRUE then
        return TRUE
    else
        return FALSE
    end
end

function GestureCommonFunction(blend_type)
    if ExecPassiveAction(FALSE, FALL_TYPE_DEFAULT, FALSE) == TRUE then
        return TRUE
    elseif blend_type ~= UPPER and TRUE == ExecQuickTurn(LOWER, TURN_TYPE_DEFAULT) then
        return TRUE
    elseif TRUE == ExecJump() then
        return TRUE
    elseif ExecHandChange(HAND_RIGHT, FALSE, ALLBODY) == TRUE then
        return TRUE
    elseif TRUE == ExecWeaponChange(ALLBODY) then
        return TRUE
    elseif ExecEvasion(FALSE, ESTEP_NONE, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecItem(QUICKTYPE_NORMAL, ALLBODY) then
        return TRUE
    elseif ExecMagic(QUICKTYPE_NORMAL, ALLBODY, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecArtsStanceOnCancelTiming(ALLBODY) then
        return TRUE
    elseif ExecAttack("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, ALLBODY, FALSE, FALSE, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecGesture() then
        return TRUE
    else
        return FALSE
    end
end

function GestureLoopCommonFunction(blend_type, lower_state, is_start)
    if ExecPassiveAction(FALSE, FALL_TYPE_DEFAULT, FALSE) == TRUE then
        return TRUE
    elseif blend_type ~= UPPER and TRUE == ExecQuickTurn(LOWER, TURN_TYPE_DEFAULT) then
        return TRUE
    elseif is_start == TRUE and FALSE == env(GetEventEzStateFlag, 0) then
        return FALSE
    elseif ExecEvasion(FALSE, ESTEP_NONE, FALSE) == TRUE then
        return TRUE
    end

    local canmove = TRUE

    if 0 == GetVariable("IndexGestureLoop") then
        canmove = FALSE
    end

    if TRUE == env(GetEventEzStateFlag, 0) and TRUE == env(HasActionRequest) then
        ExecEventHalfBlend(Event_GestureEnd, lower_state)

        return TRUE
    elseif canmove == FALSE and 0 < GetVariable("MoveSpeedLevel") then
        ExecEventHalfBlend(Event_GestureEnd, lower_state)

        return TRUE
    else
        return FALSE
    end
end

function MagicCommonFunction(blend_type, quick_type, is_throw)
    if GetVariable("IsEnableToggleDashTest") == 2 then
        SetVariable("ToggleDash", 0)
    end

    if GetVariable("MoveSpeedLevel") <= 0 then
        act(Unknown2027)
    end

    if is_throw ~= TRUE then
        SetThrowAtkInvalid()
    end

    SetAIActionState()
    act(SetIsMagicInUse, TRUE)

    if TRUE == ExecPassiveAction(FALSE, FALL_TYPE_DEFAULT, FALSE) then
        return TRUE
    elseif TRUE == ExecJump() then
        return TRUE
    elseif ExecHandChange(HAND_RIGHT, FALSE, blend_type) == TRUE then
        return TRUE
    elseif ExecGuardOnCancelTiming(FALSE, blend_type) == TRUE then
        return TRUE
    elseif ExecWeaponChange(blend_type) == TRUE then
        return TRUE
    elseif TRUE == ExecEvasion(FALSE, ESTEP_NONE, FALSE) then
        return TRUE
    elseif ExecItem(QUICKTYPE_NORMAL, blend_type) == TRUE then
        return TRUE
    elseif ExecMagic(QUICKTYPE_NORMAL, blend_type, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecArtsStanceOnCancelTiming(ALLBODY) then
        return TRUE
    elseif ExecAttack("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, blend_type, FALSE, FALSE, FALSE) == TRUE then
        return TRUE
    else
        return FALSE
    end
end

function ArrowCommonFunction(blend_type, is_allbody_turn, turn_type, is_stance_end)
    SetAIActionState()

    if ExecPassiveAction(FALSE, FALL_TYPE_DEFAULT, FALSE) == TRUE then
        return TRUE
    elseif FALSE == c_IsStealth then
        if is_allbody_turn == TRUE then
            if TRUE == ExecQuickTurnOnCancelTiming() then
                return TRUE
            end
        elseif blend_type ~= UPPER and ExecQuickTurn(LOWER, turn_type) == TRUE then
            return FALSE
        end
    end

    if TRUE == ExecJump() then
        return TRUE
    elseif ExecHandChange(HAND_RIGHT, FALSE, blend_type) == TRUE then
        return TRUE
    elseif ExecWeaponChange(blend_type) == TRUE then
        return TRUE
    elseif ExecEvasion(FALSE, ESTEP_NONE, FALSE) == TRUE then
        return TRUE
    elseif ExecItem(QUICKTYPE_NORMAL, blend_type) == TRUE then
        return TRUE
    elseif is_stance_end == TRUE and ExecArtsStanceOnCancelTiming(blend_type) == TRUE then
        return TRUE
    else
        return FALSE
    end
end

function CrossbowCommonFunction(blend_type, is_nonturn)
    SetAIActionState()

    if ExecPassiveAction(FALSE, FALL_TYPE_DEFAULT, FALSE) == TRUE then
        return TRUE
    elseif is_nonturn == FALSE and blend_type ~= UPPER and TRUE == ExecQuickTurn(LOWER, TURN_TYPE_DEFAULT) then
        return FALSE
    elseif TRUE == ExecJump() then
        return TRUE
    elseif ExecHandChange(HAND_RIGHT, FALSE, blend_type) == TRUE then
        return TRUE
    elseif ExecGuardOnCancelTiming(FALSE, blend_type) == TRUE then
        return TRUE
    elseif ExecWeaponChange(blend_type) == TRUE then
        return TRUE
    elseif ExecEvasion(FALSE, ESTEP_NONE, FALSE) == TRUE then
        return TRUE
    elseif ExecItem(QUICKTYPE_NORMAL, blend_type) == TRUE then
        return TRUE
    elseif ExecMagic(QUICKTYPE_NORMAL, blend_type, FALSE) == TRUE then
        return TRUE
    elseif ExecArtsStanceOnCancelTiming(blend_type) == TRUE then
        return TRUE
    elseif ExecAttack("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, blend_type, FALSE, FALSE, FALSE) == TRUE then
        return TRUE
    else
        local blend_type, lower_state = GetHalfBlendInfo()

        if lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
            ExecEventHalfBlendNoReset(Event_Move, UPPER)
            return
        else
            return FALSE
        end
    end
end

function Evasion_Activate()
    ActivateRightArmAdd(START_FRAME_A02)
end

function Evasion_Update()
    UpdateRightArmAdd()
end

function Evasion_Deactivate()
end

function EvasionCommonFunction(fall_type, r1, r2, l1, l2, b1, b2, quick_type)
    SetAIActionState()
    SetEnableAimMode()

    if ExecPassiveAction(FALSE, fall_type, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecJump() then
        return TRUE
    elseif ExecHandChange(HAND_RIGHT, FALSE, ALLBODY) == TRUE then
        return TRUE
    elseif TRUE == IsNodeActive("BackStepGuardOn_UpperLayer Selector") then
        act(DebugLogOutput, "BackStepGuardOn")
        if TRUE == ExecGuardOnCancelTiming(TO_GUARDON, ALLBODY) then
            return TRUE
        elseif TRUE == env(ActionRequest, ACTION_ARM_L1) or env(ActionDuration, ACTION_ARM_L1) > 0 then
            act(DebugLogOutput, "BackStepGuard_ToGuardOn")
        end
    elseif ExecGuardOnCancelTiming(FALSE, ALLBODY) == TRUE then
        return TRUE
    end

    if TRUE == ExecWeaponChange(ALLBODY) then
        return TRUE
    elseif ExecEvasion(FALSE, ESTEP_NONE, FALSE) == TRUE then
        return TRUE
    elseif ExecItem(quick_type, ALLBODY) == TRUE then
        return TRUE
    elseif ExecMagic(quick_type, ALLBODY, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecArtsStanceOnCancelTiming(ALLBODY) then
        return TRUE
    elseif ExecAttack(r1, r2, l1, l2, b1, b2, FALSE, ALLBODY, FALSE, FALSE, TRUE) == TRUE then
        return TRUE
    elseif MoveStartonCancelTiming(Event_MoveLong, FALSE) == TRUE then
        return TRUE
    else
        return FALSE
    end
end

function DamageCommonFunction(guardcondition, estep, fall_type)
    if ExecPassiveAction(FALSE, fall_type, FALSE) == TRUE then
        return TRUE
    end

    SetVariable("ToggleDash", 0)
    SetEnableAimMode()

    if TRUE == ExecJump() then
        return TRUE
    elseif ExecHandChange(HAND_RIGHT, FALSE, ALLBODY) == TRUE then
        ResetDamageCount()
        return TRUE
    elseif TRUE == ExecWeaponChange(ALLBODY) then
        ResetDamageCount()
        return TRUE
    end

    local is_usechainrecover = GetVariable("UseChainRecover")

    if ExecEvasion(TRUE, estep, is_usechainrecover) == TRUE then
        return TRUE
    elseif TRUE == ExecItem(QUICKTYPE_NORMAL, ALLBODY) then
        ResetDamageCount()
        return TRUE
    elseif ExecMagic(QUICKTYPE_NORMAL, ALLBODY, FALSE) == TRUE then
        ResetDamageCount()
        return TRUE
    elseif TRUE == ExecArtsStanceOnCancelTiming(ALLBODY) then
        ResetDamageCount()
        return TRUE
    elseif ExecAttack("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", guardcondition, ALLBODY, FALSE, FALSE, FALSE) == TRUE then
        ResetDamageCount()
        return TRUE
    elseif TRUE == env(IsMoveCancelPossible) then
        ResetDamageCount()
    end
    if TRUE == ExecQuickTurnOnCancelTiming() then
        return TRUE
    elseif ExecGuardOnCancelTiming(guardcondition, ALLBODY) == TRUE then
        ResetDamageCount()
        return TRUE
    elseif MoveStartonCancelTiming(Event_Move, FALSE) == TRUE then
        ResetDamageCount()
        return TRUE
    else
        return FALSE
    end
end

function QuickTurnCommonFunction()
    act(Unknown163)
    act(Unknown2040)

    if ExecPassiveAction(FALSE, FALL_TYPE_DEFAULT, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecJump() then
        return TRUE
    elseif ExecHandChange(HAND_RIGHT, FALSE, UPPER) == TRUE then
        return TRUE
    elseif ExecGuardOnCancelTiming(FALSE, UPPER) == TRUE then
        return TRUE
    elseif TRUE == ExecWeaponChange(UPPER) then
        return TRUE
    elseif ExecEvasion(FALSE, ESTEP_NONE, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecItem(QUICKTYPE_NORMAL, UPPER) then
        return TRUE
    elseif ExecMagic(QUICKTYPE_NORMAL, UPPER, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecArtsStanceOnCancelTiming(UPPER) then
        return TRUE
    elseif ExecAttack("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, UPPER, FALSE, FALSE, FALSE) == TRUE then
        return TRUE
    elseif MoveStartonCancelTiming(Event_Move, FALSE) == TRUE then
        return TRUE
    else
        return FALSE
    end
end

function LandCommonFunction()
    act(SetIsEquipmentChangeableFromMenu)

    if ExecPassiveAction(FALSE, FALL_TYPE_DEFAULT, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecQuickTurnOnCancelTiming() then
        return TRUE
    elseif TRUE == ExecJump() then
        return TRUE
    elseif ExecHandChange(HAND_RIGHT, FALSE, ALLBODY) == TRUE then
        return TRUE
    elseif ExecGuardOnCancelTiming(FALSE, ALLBODY) == TRUE then
        return TRUE
    elseif TRUE == ExecWeaponChange(ALLBODY) then
        return TRUE
    elseif ExecEvasion(FALSE, ESTEP_NONE, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecItem(QUICKTYPE_NORMAL, ALLBODY) then
        return TRUE
    elseif TRUE == ExecArtsStanceOnCancelTiming(ALLBODY) then
        return TRUE
    elseif ExecAttack("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, ALLBODY, FALSE, FALSE, FALSE) == TRUE then
        return TRUE
    elseif MoveStartonCancelTiming(Event_Move, FALSE) == TRUE then
        return TRUE
    else
        return FALSE
    end
end

function ItemCommonFunction(blend_type)
    if env(GetStateChangeType, 15) == FALSE then
        act(SetIsItemAnimationPlaying)
    end

    if GetVariable("IsEnableToggleDashTest") == 2 then
        SetVariable("ToggleDash", 0)
    end

    if GetVariable("MoveSpeedLevel") <= 0 then
        act(Unknown2027)
    end

    SetAIActionState()

    if ExecPassiveAction(FALSE, FALL_TYPE_DEFAULT, FALSE) == TRUE then
        return TRUE
    elseif blend_type ~= UPPER and TRUE == ExecQuickTurn(LOWER, TURN_TYPE_DEFAULT) then
        return TRUE
    elseif TRUE == ExecJump() then
        return TRUE
    elseif ExecHandChange(HAND_RIGHT, FALSE, blend_type) == TRUE then
        return TRUE
    elseif ExecGuardOnCancelTiming(FALSE, blend_type) == TRUE then
        return TRUE
    elseif ExecWeaponChange(blend_type) == TRUE then
        return TRUE
    elseif ExecEvasion(FALSE, ESTEP_NONE, FALSE) == TRUE then
        return TRUE
    elseif ExecArtsStanceOnCancelTiming(blend_type) == TRUE then
        return TRUE
    elseif ExecAttack("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, blend_type, FALSE, FALSE, FALSE) == TRUE then
        return TRUE
    elseif ExecItem(QUICKTYPE_NORMAL, blend_type) == TRUE then
        return TRUE
    elseif ExecMagic(QUICKTYPE_NORMAL, blend_type, FALSE) == TRUE then
        return TRUE
    elseif MoveStartonCancelTiming(Event_Move, FALSE) == TRUE then
        return TRUE
    else
        return FALSE
    end
end

function StealthItemCommonFunction(blend_type)
    act(SetIsItemAnimationPlaying)

    if GetVariable("IsEnableToggleDashTest") == 2 then
        SetVariable("ToggleDash", 0)
    end

    if GetVariable("MoveSpeedLevel") <= 0 then
        act(Unknown2027)
    end

    SetAIActionState()

    if ExecPassiveAction(FALSE, FALL_TYPE_DEFAULT, FALSE) == TRUE then
        return TRUE
    elseif blend_type ~= UPPER and TRUE == ExecQuickTurn(LOWER, TURN_TYPE_DEFAULT) then
        return TRUE
    elseif TRUE == ExecJump() then
        return TRUE
    elseif ExecHandChange(HAND_RIGHT, FALSE, blend_type) == TRUE then
        return TRUE
    elseif ExecGuardOnCancelTiming(FALSE, blend_type) == TRUE then
        return TRUE
    elseif ExecWeaponChange(blend_type) == TRUE then
        return TRUE
    elseif ExecEvasion(FALSE, ESTEP_NONE, FALSE) == TRUE then
        return TRUE
    elseif ExecArtsStanceOnCancelTiming(blend_type) == TRUE then
        return TRUE
    elseif ExecAttack("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, blend_type, FALSE, FALSE, FALSE) == TRUE then
        return TRUE
    elseif ExecItem(QUICKTYPE_NORMAL, blend_type) == TRUE then
        return TRUE
    elseif ExecMagic(QUICKTYPE_NORMAL, blend_type, FALSE) == TRUE then
        return TRUE
    elseif MoveStartonCancelTiming(Event_Stealth_Move, FALSE) == TRUE then
        act(DebugLogOutput, "StealthItemCommonFunction MoveStartonCancelTiming")
        return TRUE
    else
        return FALSE
    end
end

function QuickItemCommonFunction(g_r1, g_r2, g_l1, g_l2, g_b1, g_b2, blend_type, quick_type)
    act(SetIsItemAnimationPlaying)

    if GetVariable("MoveSpeedLevel") <= 0 then
        act(Unknown2027)
    end

    SetAIActionState()

    if ExecPassiveAction(FALSE, FALL_TYPE_DEFAULT, FALSE) == TRUE then
        ClearAttackQueue()

        return TRUE
    elseif TRUE == ExecJump() then
        return TRUE
    elseif ExecHandChange(HAND_RIGHT, FALSE, blend_type) == TRUE then
        ClearAttackQueue()

        return TRUE
    elseif ExecGuardOnCancelTiming(FALSE, blend_type) == TRUE then
        ClearAttackQueue()

        return TRUE
    elseif ExecWeaponChange(blend_type) == TRUE then
        ClearAttackQueue()

        return TRUE
    elseif ExecEvasion(FALSE, ESTEP_NONE, FALSE) == TRUE then
        ClearAttackQueue()

        return TRUE
    elseif ExecArtsStanceOnCancelTiming(blend_type) == TRUE then
        ClearAttackQueue()

        return TRUE
    elseif ExecAttack(g_r1, g_r2, g_l1, g_l2, g_b1, g_b2, FALSE, blend_type, FALSE, FALSE, FALSE) == TRUE then
        ClearAttackQueue()

        return TRUE
    elseif ExecItem(quick_type, blend_type) == TRUE then
        ClearAttackQueue()

        return TRUE
    elseif ExecMagic(QUICKTYPE_ATTACK, ALLBODY, FALSE) == TRUE then
        ClearAttackQueue()

        return TRUE
    elseif MoveStartonCancelTiming(Event_Move, FALSE) == TRUE then
        ClearAttackQueue()

        return TRUE
    else
        return FALSE
    end
end

function StopCommonFunction(is_dash_stop)
    act(Wait)

    if is_dash_stop == TRUE then
        if c_IsStealth == TRUE then
            act(LockonSystemUnableToTurnAngle, 0, 0)
        else
            act(LockonSystemUnableToTurnAngle, 180, 180)
        end
    elseif TRUE == env(IsCOMPlayer) then
        act(LockonSystemUnableToTurnAngle, 15, 15)
    else
        act(LockonSystemUnableToTurnAngle, 45, 45)
    end

    SetEnableAimMode()

    if TRUE == ExecPassiveAction(FALSE, FALL_TYPE_DEFAULT, FALSE) then
        return TRUE
    elseif TRUE == LadderStart() then
        return TRUE
    elseif is_dash_stop == FALSE and c_IsStealth == FALSE and TRUE == ExecQuickTurn(ALLBODY, TURN_TYPE_DEFAULT) then
        return TRUE
    elseif TRUE == ExecJump() then
        return TRUE
    elseif TRUE == ExecHandChange(HAND_RIGHT, FALSE, ALLBODY) then
        return TRUE
    elseif TRUE == ExecGuard(Event_GuardStart, ALLBODY) then
        return TRUE
    elseif TRUE == ExecWeaponChange(ALLBODY) then
        return TRUE
    elseif TRUE == ExecEvasion(FALSE, ESTEP_NONE, FALSE) then
        return TRUE
    elseif TRUE == ExecItem(QUICKTYPE_NORMAL, ALLBODY) then
        return TRUE
    elseif TRUE == ExecMagic(QUICKTYPE_NORMAL, ALLBODY, FALSE) then
        return TRUE
    elseif TRUE == ExecArtsStance(ALLBODY) then
        return TRUE
    elseif TRUE == ExecRide() then
        return TRUE
    end

    local r1 = "W_AttackRightLight1"
    local b1 = "W_AttackBothLight1"

    if c_IsStealth == TRUE then
        r1 = "W_AttackRightLightStealth"
        b1 = "W_AttackBothLightStealth"
    end

    if ExecAttack(r1, "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, "W_AttackBothHeavy1Start", FALSE, ALLBODY, FALSE, FALSE, FALSE) == TRUE then
        return TRUE
    elseif TRUE == env(GetSpEffectID, 100170) then
        act(LockonFixedAngleCancel)
        if TRUE == ExecDashTurn() then
            return TRUE
        end
    end

    if c_IsStealth == TRUE then
        if TRUE == MoveStart(ALLBODY, Event_Stealth_Move, FALSE) then
            return TRUE
        end
    elseif TRUE == MoveStart(ALLBODY, Event_Move, FALSE) then
        return TRUE
    end

    if TRUE == ExecGesture() then
        return TRUE
    else
        return FALSE
    end
end

function MoveCommonFunction(blend_type)
    act(Wait)
    act(Unknown2040)
    SetEnableAimMode()

    if ExecPassiveAction(FALSE, FALL_TYPE_DEFAULT, FALSE) == TRUE then
        return TRUE
    elseif TRUE == LadderStart() then
        return TRUE
    elseif TRUE == ExecJump() then
        return TRUE
    elseif ExecHandChange(HAND_RIGHT, FALSE, blend_type) == TRUE then
        return TRUE
    elseif ExecWeaponChange(blend_type) == TRUE then
        return TRUE
    elseif ExecEvasion(FALSE, ESTEP_NONE, FALSE) == TRUE then
        return TRUE
    elseif ExecGuard(Event_GuardStart, blend_type) == TRUE then
        return TRUE
    end

    local speed = GetVariable("MoveSpeedIndex")

    if speed == 2 then
        if ExecItem(QUICKTYPE_DASH, blend_type) == TRUE then
            return TRUE
        end
    elseif speed == 1 then
        if ExecItem(QUICKTYPE_RUN, blend_type) == TRUE then
            return TRUE
        end
    elseif ExecItem(QUICKTYPE_NORMAL, blend_type) == TRUE then
        return TRUE
    end

    if speed == 2 then
        if ExecMagic(QUICKTYPE_DASH, blend_type, FALSE) == TRUE then
            return TRUE
        end
    elseif ExecMagic(QUICKTYPE_NORMAL, blend_type, FALSE) == TRUE then
        return TRUE
    end

    if ExecArtsStance(blend_type) == TRUE then
        return TRUE
    elseif TRUE == ExecRide() then
        return TRUE
    end

    local r1 = "W_AttackRightLight1"
    local r2 = "W_AttackRightHeavy1Start"
    local b1 = "W_AttackBothLight1"
    local b2 = "W_AttackBothHeavy1Start"

    if speed == 2 then
        r1 = "W_AttackRightLightDash"
        r2 = "W_AttackRightHeavyDash"
        b1 = "W_AttackBothDash"
        b2 = "W_AttackBothHeavyDash"
    elseif c_IsStealth == TRUE then
        r1 = "W_AttackRightLightStealth"
        b1 = "W_AttackBothLightStealth"
    end

    if ExecAttack(r1, r2, "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, b2, FALSE, UPPER, FALSE, FALSE, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecGesture() then
        return TRUE
    elseif TRUE == ExecStop() then
        return TRUE
    else
        return FALSE
    end
end

function GuardCommonFunction(is_guard_end, blend_type)
    act(Wait)

    if ExecPassiveAction(FALSE, FALL_TYPE_DEFAULT, FALSE) == TRUE then
        return TRUE
    elseif TRUE == env(GetSpEffectID, 170) then
        return FALSE
    elseif TRUE == LadderStart() then
        return TRUE
    elseif blend_type ~= UPPER and TRUE == ExecQuickTurn(LOWER, TURN_TYPE_DEFAULT) then
        return TRUE
    elseif TRUE == ExecJump() then
        return TRUE
    elseif ExecHandChange(HAND_RIGHT, FALSE, blend_type) == TRUE then
        return TRUE
    elseif ExecWeaponChange(blend_type) == TRUE then
        return TRUE
    elseif ExecEvasion(FALSE, ESTEP_NONE, FALSE) == TRUE then
        return TRUE
    elseif is_guard_end == TRUE then
        if ExecArtsStanceOnCancelTiming(blend_type) == TRUE then
            return TRUE
        end
    elseif TRUE == env(ActionRequest, ACTION_ARM_L2) and ExecArtsStance(blend_type) == TRUE then
        return TRUE
    end

    if GetVariable("MoveSpeedIndex") == 2 then
        if ExecItem(QUICKTYPE_DASH, blend_type) == TRUE then
            return TRUE
        end
    elseif GetVariable("MoveSpeedIndex") == 1 then
        if ExecItem(QUICKTYPE_RUN, blend_type) == TRUE then
            return TRUE
        end
    elseif ExecItem(QUICKTYPE_NORMAL, blend_type) == TRUE then
        return TRUE
    end
    if GetVariable("MoveSpeedIndex") == 2 then
        if ExecMagic(QUICKTYPE_DASH, blend_type, FALSE) == TRUE then
            return TRUE
        end
    elseif GetVariable("MoveSpeedIndex") == 1 then
        if ExecMagic(QUICKTYPE_RUN, blend_type, FALSE) == TRUE then
            return TRUE
        end
    elseif ExecMagic(QUICKTYPE_NORMAL, blend_type, FALSE) == TRUE then
        return TRUE
    end

    if GetVariable("MoveSpeedLevelReal") > 1.100000023841858 then
        if ExecAttack("W_AttackRightLightDash", "W_AttackRightHeavyDash", nil, "W_AttackLeftHeavy1", "W_AttackBothDash", "W_AttackBothHeavyDash", FALSE, UPPER, FALSE, FALSE, FALSE) == TRUE then
            return TRUE
        end
    else
        local guard_attack = TRUE

        if is_guard_end == TRUE then
            guard_attack = FALSE
        end

        if ExecAttack("W_AttackRightLight1", "W_AttackRightHeavy1Start", nil, "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", guard_attack, blend_type, FALSE, FALSE, FALSE) == TRUE then
            return TRUE
        end
    end

    if is_guard_end == FALSE then
        if TRUE == env(ActionCancelRequest, ACTION_ARM_L1) or env(ActionDuration, ACTION_ARM_L1) <= 0 then
            ExecEventHalfBlendNoReset(Event_GuardEnd, blend_type)

            return TRUE
        end
    elseif (TRUE == env(ActionRequest, ACTION_ARM_L1) or env(ActionDuration, ACTION_ARM_L1) > 0) and ExecGuard(Event_GuardStart, blend_type) == TRUE then
        return TRUE
    end

    return FALSE
end

function ArtsCommonFunction(r1, r2, l1, l2, b1, b2, guardcondition, artsr1, artsr2, gen_trans, can_throw, blend_type)
    if can_throw == FALSE then
        SetThrowAtkInvalid()
    end

    SetAIActionState()
    act(Unknown163)
    if ExecPassiveAction(FALSE, FALL_TYPE_DEFAULT, FALSE) == TRUE then
        ClearAttackQueue()

        return TRUE
    elseif ExecWeaponChange(blend_type) == TRUE then
        ClearAttackQueue()

        return TRUE
    elseif ExecEvasion(FALSE, ESTEP_NONE, FALSE) == TRUE then
        ClearAttackQueue()

        return TRUE
    elseif ExecItem(QUICKTYPE_ATTACK, blend_type) == TRUE then
        ClearAttackQueue()

        return TRUE
    elseif ExecMagic(QUICKTYPE_ATTACK, blend_type, FALSE) == TRUE then
        ClearAttackQueue()

        return TRUE
    elseif ExecArtsStanceOnCancelTiming(blend_type) == TRUE then
        ClearAttackQueue()

        return TRUE
    elseif ExecAttack(r1, r2, l1, l2, b1, b2, guardcondition, blend_type, artsr1, artsr2, FALSE) == TRUE then
        ClearAttackQueue()

        return TRUE
    elseif TRUE == ExecQuickTurnOnCancelTiming() then
        ClearAttackQueue()

        return TRUE
    elseif TRUE == ExecJump() then
        ClearAttackQueue()

        return TRUE
    elseif ExecHandChange(HAND_RIGHT, FALSE, blend_type) == TRUE then
        ClearAttackQueue()

        return TRUE
    end

    local guardcondition = FALSE

    if TRUE == env(GetSpEffectID, 100410) then
        guardcondition = TO_GUARDON
    end

    if ExecGuardOnCancelTiming(guardcondition, blend_type) == TRUE then
        ClearAttackQueue()

        return TRUE
    elseif MoveStartonCancelTiming(Event_Move, gen_trans) == TRUE then
        ClearAttackQueue()

        return TRUE
    elseif TRUE == ExecGesture() then
        ClearAttackQueue()

        return TRUE
    else
        return FALSE
    end
end

function ArtsParryCommonFunction()
    SetAIActionState()

    if ExecPassiveAction(TRUE, FALL_TYPE_DEFAULT, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecWeaponChange(ALLBODY) then
        return TRUE
    elseif TRUE == ExecEvasion(FALSE, ESTEP_NONE, FALSE) then
        return TRUE
    elseif TRUE == ExecItem(QUICKTYPE_ATTACK, ALLBODY) then
        return TRUE
    elseif TRUE == ExecMagic(QUICKTYPE_ATTACK, ALLBODY, FALSE) then
        return TRUE
    elseif TRUE == ExecArtsStanceOnCancelTiming(ALLBODY) then
        return TRUE
    elseif TRUE == ExecAttack("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, ALLBODY, FALSE, FALSE, FALSE) then
        return TRUE
    elseif TRUE == ExecQuickTurnOnCancelTiming() then
        return TRUE
    elseif TRUE == ExecJump() then
        return TRUE
    elseif TRUE == ExecHandChange(HAND_RIGHT, FALSE, ALLBODY) then
        return TRUE
    elseif TRUE == ExecGuardOnCancelTiming(FALSE, ALLBODY) then
        return TRUE
    elseif TRUE == MoveStartonCancelTiming(Event_Move, FALSE) then
        return TRUE
    elseif TRUE == ExecGesture() then
        return TRUE
    else
        return FALSE
    end
end

function ArtsStanceCommonFunction(r1, r2, l1, l2, b1, b2, blend_type, turn_type, artsr1, artsr2, is_stance_end)
    if is_stance_end == FALSE then
        SetThrowAtkInvalid()
    end

    SetAIActionState()
    act(Unknown163)
    if ExecPassiveAction(FALSE, FALL_TYPE_DEFAULT, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecJump() then
        return TRUE
    elseif ExecHandChange(HAND_RIGHT, FALSE, blend_type) == TRUE then
        return TRUE
    elseif env(ActionDuration, ACTION_ARM_L1) < 440 and ExecGuardOnCancelTiming(FALSE, blend_type) == TRUE then
        return TRUE
    elseif ExecWeaponChange(blend_type) == TRUE then
        return TRUE
    elseif ExecEvasion(FALSE, ESTEP_NONE, FALSE) == TRUE then
        return TRUE
    elseif ExecItem(QUICKTYPE_NORMAL, blend_type) == TRUE then
        return TRUE
    elseif ExecMagic(QUICKTYPE_NORMAL, ALLBODY, FALSE) == TRUE then
        return TRUE
    elseif is_stance_end == TRUE and ExecArtsStanceOnCancelTiming(blend_type) == TRUE then
        return TRUE
    elseif ExecAttack(r1, r2, l1, l2, b1, b2, FALSE, blend_type, artsr1, artsr2, FALSE) == TRUE then
        return TRUE
    elseif blend_type ~= UPPER and ExecQuickTurn(LOWER, turn_type) == TRUE then
        return TRUE
    elseif MoveStartonCancelTiming(Event_Move, FALSE) == TRUE then
        if is_stance_end == TRUE then
            SetArtsGeneratorTransitionIndex()
        end

        ClearAttackQueue()

        return TRUE
    else
        return FALSE
    end
end

function ArtsChargeShotCommonFunction()
    SetAIActionState()

    if env(GetEventEzStateFlag, 1) == FALSE then
        act(SetTurnSpeed, 0)
    end

    if ExecPassiveAction(FALSE, FALL_TYPE_DEFAULT, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecJump() then
        return TRUE
    elseif ExecHandChange(HAND_RIGHT, FALSE, blend_type) == TRUE then
        return TRUE
    elseif TRUE == ExecWeaponChange(blend_type) then
        return TRUE
    elseif ExecEvasion(FALSE, ESTEP_NONE, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecItem(QUICKTYPE_NORMAL, blend_type) then
        return TRUE
    elseif ExecMagic(QUICKTYPE_NORMAL, ALLBODY, FALSE) == TRUE then
        return TRUE
    elseif MoveStartonCancelTiming(Event_Move, FALSE) == TRUE then
        return TRUE
    else
        return FALSE
    end
end

function WeaponChangeCommonFunction(blend_type)
    SetAIActionState()

    if ExecPassiveAction(FALSE, FALL_TYPE_DEFAULT, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecJump() then
        return TRUE
    elseif ExecHandChange(HAND_RIGHT, FALSE, blend_type) == TRUE then
        return TRUE
    elseif ExecGuardOnCancelTiming(FALSE, blend_type) == TRUE then
        return TRUE
    elseif ExecWeaponChange(blend_type) == TRUE then
        return TRUE
    elseif ExecEvasion(FALSE, ESTEP_NONE, FALSE) == TRUE then
        return TRUE
    elseif ExecItem(QUICKTYPE_NORMAL, blend_type) == TRUE then
        return TRUE
    elseif ExecMagic(QUICKTYPE_NORMAL, blend_type, FALSE) == TRUE then
        return TRUE
    elseif ExecArtsStanceOnCancelTiming(blend_type) == TRUE then
        return TRUE
    end
    local r1 = "W_AttackRightLight1"
    local r2 = "W_AttackRightHeavy1Start"
    local b1 = "W_AttackBothLight1"
    local b2 = "W_AttackBothHeavy1Start"
    if TRUE == env(GetSpEffectID, 100002) and env(ActionDuration, ACTION_ARM_SP_MOVE) > 0 then
        r1 = "W_AttackRightLightDash"
        r2 = "W_AttackRightHeavyDash"
        b1 = "W_AttackBothDash"
        b2 = "W_AttackBothHeavyDash"
    end
    if ExecAttack(r1, r2, "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, b2, FALSE, blend_type, FALSE, FALSE, FALSE) == TRUE then
        return TRUE
    elseif blend_type ~= UPPER and TRUE == ExecQuickTurn(LOWER, TURN_TYPE_DEFAULT) then
        return TRUE
    else
        return FALSE
    end
end

function HandChangeCommonFunction(blend_type)
    SetAIActionState()

    if ExecPassiveAction(FALSE, FALL_TYPE_DEFAULT, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecJump() then
        return TRUE
    elseif ExecHandChange(HAND_RIGHT, FALSE, blend_type) == TRUE then
        return TRUE
    elseif ExecGuardOnCancelTiming(FALSE, blend_type) == TRUE then
        return TRUE
    elseif ExecWeaponChange(blend_type) == TRUE then
        return TRUE
    elseif ExecEvasion(FALSE, ESTEP_NONE, FALSE) == TRUE then
        return TRUE
    elseif ExecGuardOnCancelTiming(FALSE, blend_type) == TRUE then
        return TRUE
    elseif ExecItem(QUICKTYPE_NORMAL, blend_type) == TRUE then
        return TRUE
    elseif ExecMagic(QUICKTYPE_NORMAL, blend_type, FALSE) == TRUE then
        return TRUE
    elseif ExecArtsStanceOnCancelTiming(blend_type) == TRUE then
        return TRUE
    end
    local r1 = "W_AttackRightLight1"
    local r2 = "W_AttackRightHeavy1Start"
    local b1 = "W_AttackBothLight1"
    local b2 = "W_AttackBothHeavy1Start"
    if TRUE == env(GetSpEffectID, 100002) and env(ActionDuration, ACTION_ARM_SP_MOVE) > 0 then
        r1 = "W_AttackRightLightDash"
        r2 = "W_AttackRightHeavyDash"
        b1 = "W_AttackBothDash"
        b2 = "W_AttackBothHeavyDash"
    end
    if ExecAttack(r1, r2, "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, b2, FALSE, blend_type, FALSE, FALSE, FALSE) == TRUE then
        return TRUE
    elseif blend_type ~= UPPER and TRUE == ExecQuickTurn(LOWER, TURN_TYPE_DEFAULT) then
        return TRUE
    else
        return FALSE
    end
end

function ChainRecoverCommonFunction()
    SetAIActionState()

    if ExecPassiveAction(FALSE, FALL_TYPE_DEFAULT, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecJump() then
        return TRUE
    elseif ExecHandChange(HAND_RIGHT, FALSE, blend_type) == TRUE then
        return TRUE
    elseif TRUE == ExecWeaponChange(blend_type) then
        return TRUE
    elseif ExecEvasion(FALSE, ESTEP_NONE, FALSE) == TRUE then
        return TRUE
    elseif ExecGuardOnCancelTiming(FALSE, blend_type) == TRUE then
        return TRUE
    elseif TRUE == ExecItem(QUICKTYPE_NORMAL, blend_type) then
        return TRUE
    elseif ExecMagic(QUICKTYPE_NORMAL, ALLBODY, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecArtsStanceOnCancelTiming(blend_type) then
        return TRUE
    elseif ExecAttack("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, blend_type, FALSE, FALSE, FALSE) == TRUE then
        return TRUE
    elseif blend_type ~= UPPER and TRUE == ExecQuickTurn(LOWER, TURN_TYPE_DEFAULT) then
        return TRUE
    else
        return FALSE
    end
end

function Event_Activate()
    ActivateRightArmAdd(START_FRAME_NONE)
    SetVariable("IsEventActivate", true)
end

function Event_Update()
    if GetVariable("IsEventActivate") == false then
        UpdateRightArmAdd()
    end

    SetVariable("IsEventActivate", false)
end

function EventCommonFunction()
    if env(GetEventEzStateFlag, 0) == FALSE then
        act(SetIsEventAnim)
    end

    act(SetIsEquipmentChangeableFromMenu)

    if env(HasThrowRequest) == TRUE then
        return TRUE
    elseif TRUE == ExecTalkDeath() then
        return TRUE
    elseif TRUE == ExecDeath() then
        return TRUE
    elseif TRUE == ExecTalkDamage() then
        return TRUE
    elseif ExecDamage(FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecFallStart(FALL_TYPE_DEFAULT) then
        return TRUE
    elseif TRUE == ExecTalk() then
        return TRUE
    elseif TRUE == ExecQuickTurnOnCancelTiming() then
        return TRUE
    elseif TRUE == ExecJump() then
        return TRUE
    elseif ExecHandChange(HAND_RIGHT, FALSE, ALLBODY) == TRUE then
        return TRUE
    elseif ExecGuardOnCancelTiming(FALSE, ALLBODY) == TRUE then
        return TRUE
    elseif TRUE == ExecWeaponChange(ALLBODY) then
        return TRUE
    elseif ExecEvasion(FALSE, ESTEP_NONE, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecItem(QUICKTYPE_NORMAL, ALLBODY) then
        return TRUE
    elseif ExecMagic(QUICKTYPE_NORMAL, ALLBODY, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecArtsStanceOnCancelTiming(ALLBODY) then
        return TRUE
    elseif ExecAttack("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, ALLBODY, FALSE, FALSE, FALSE) == TRUE then
        return TRUE
    end

    local moveEvent = Event_MoveQuick

    if c_IsStealth == TRUE then
        moveEvent = Event_Stealth_Move
    end

    if MoveStartonCancelTiming(moveEvent, FALSE) == TRUE then
        return TRUE
    else
        return FALSE
    end
end

function HalfBlendLowerCommonFunction(event, lower_state, to_idle_on_cancel, disable_stealth_move)
    if disable_stealth_move == nil then
        disable_stealth_move = FALSE
    end

    if lower_state == LOWER_MOVE then
        if ExecStopHalfBlend(event, to_idle_on_cancel) == TRUE then
            return TRUE
        end
    else
        local blend_type = LOWER

        if TRUE == env(IsMoveCancelPossible) then
            blend_type = ALLBODY
        end

        local move_event = Event_Move

        if c_IsStealth == TRUE and disable_stealth_move == FALSE then
            move_event = Event_Stealth_Move
        end

        if MoveStart(blend_type, move_event, FALSE) == TRUE then
            return TRUE
        elseif lower_state == LOWER_END_TURN then
            ExecEventHalfBlendNoReset(event, LOWER)
            return TRUE
        end
    end

    return FALSE
end

function HalfBlendLowerCommonFunctionNoSync(event, lower_state, to_idle_on_cancel, is_fire_upper_on_move)
    if lower_state == LOWER_MOVE then
        if ExecStopHalfBlend(event, to_idle_on_cancel) == TRUE then
            return TRUE
        end
    else
        local blend_type = LOWER

        if TRUE == env(IsMoveCancelPossible) then
            blend_type = ALLBODY
        end

        if MoveStart(blend_type, Event_MoveNoSync, FALSE) == TRUE then
            if is_fire_upper_on_move == TRUE and blend_type == LOWER then
                ExecEventHalfBlend(event, UPPER)
            end

            return TRUE
        elseif lower_state == LOWER_END_TURN then
            ExecEventHalfBlendNoReset(event, LOWER)

            return TRUE
        end
    end

    return FALSE
end

function HalfBlendUpperCommonFunction(lower_state)
    local exit_flag = FALSE

    if env(IsAnimEnd, 1) == TRUE then
        exit_flag = TRUE
    end

    if lower_state ~= LOWER_IDLE and env(GetEventEzStateFlag, 0) == TRUE then
        exit_flag = TRUE
    end

    if exit_flag == FALSE then
        return FALSE
    elseif lower_state == LOWER_TURN then
        local turn_state = GetVariable("UpperDefaultState01")
        local event = Event_QuickTurnRight180Mirror

        if turn_state == QUICKTURN_LEFT180_DEF1 then
            event = Event_QuickTurnLeft180Mirror
        end

        ExecEventHalfBlendNoReset(event)
    elseif lower_state == LOWER_MOVE then
        if c_IsStealth == TRUE then
            ExecEventHalfBlendNoReset(Event_Stealth_Move, UPPER)
        else
            ExecEventHalfBlendNoReset(Event_Move, UPPER)
        end
    elseif c_IsStealth == TRUE then
        ExecEventNoReset("W_Stealth_Idle")
    else
        ExecEventNoReset("W_Idle")
    end

    return TRUE
end

function ArrowLowerCommonFunction(event, lower_state, to_idle_on_cancel)
    if lower_state == LOWER_MOVE then
        if ExecStopHalfBlend(event, to_idle_on_cancel) == TRUE then
            return
        end
    else
        if lower_state ~= LOWER_TURN then
            local style = c_Style
            local hand = HAND_RIGHT

            if style == HAND_LEFT_BOTH then
                hand = HAND_LEFT
            end

            if env(GetEquipWeaponCategory, hand) ~= WEAPON_CATEGORY_LARGE_ARROW then
                local move_event = Event_Move

                if c_IsStealth == TRUE then
                    move_event = Event_Stealth_Move
                end

                if MoveStart(LOWER, move_event, FALSE) == TRUE then
                    return
                end
            elseif env(IsPrecisionShoot) == FALSE and TRUE == MoveStartonCancelTiming(Event_Move, FALSE) then
                return
            end
        end

        if lower_state == LOWER_END_TURN then
            ExecEventHalfBlendNoReset(event, LOWER)
        end
    end
end

function Idle_onActivate()
    SetVariable("MoveSpeedLevelReal", 0)
    ClearAttackQueue()
    act(Wait)
    act(RequestThrowAnimInterrupt)
    act(DisallowAdditiveTurning, TRUE)
end

function Idle_onUpdate()
    SetEnableMimicry()

    if IdleCommonFunction() == TRUE then
        SetVariable("ArtsTransition", 0)
    end
end

function Idle_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function DashStop_onActivate()
    act(Wait)
end

function DashStop_onUpdate()
    if StopCommonFunction(TRUE) == TRUE then
    end
end

function RunStopFront_onActivate()
    act(Wait)
end

function RunStopFront_onUpdate()
    SetEnableMimicry()

    if StopCommonFunction(FALSE) == TRUE then
    end
end

function RunStopBack_onActivate()
    act(Wait)
end

function RunStopBack_onUpdate()
    SetEnableMimicry()
    if StopCommonFunction(FALSE) == TRUE then
    end
end

function RunStopLeft_onActivate()
    act(Wait)
end

function RunStopLeft_onUpdate()
    SetEnableMimicry()
    if StopCommonFunction(FALSE) == TRUE then
    end
end

function RunStopRight_onActivate()
    act(Wait)
end

function RunStopRight_onUpdate()
    SetEnableMimicry()

    if StopCommonFunction(FALSE) == TRUE then
    end
end

function WalkStopFront_onActivate()
    act(Wait)
end

function WalkStopFront_onUpdate()
    SetEnableMimicry()

    if StopCommonFunction(FALSE) == TRUE then
    end
end

function WalkStopBack_onActivate()
    act(Wait)
end

function WalkStopBack_onUpdate()
    SetEnableMimicry()

    if StopCommonFunction(FALSE) == TRUE then
    end
end

function WalkStopLeft_onActivate()
    act(Wait)
end

function WalkStopLeft_onUpdate()
    SetEnableMimicry()

    if StopCommonFunction(FALSE) == TRUE then
    end
end

function WalkStopRight_onActivate()
    act(Wait)
end

function WalkStopRight_onUpdate()
    SetEnableMimicry()

    if StopCommonFunction(FALSE) == TRUE then
    end
end

function Dash180_onActivate()
    act(SetIsTurnAnimInProgress)
end

function Dash180_onUpdate()
    act(SetIsTurnAnimInProgress)

    if QuickTurnCommonFunction() == TRUE then
    end
end

function Rolling_onUpdate()
    act(DisallowAdditiveTurning, TRUE)
    SetThrowAtkInvalid()

    if TRUE == env(GetSpEffectID, 100390) then
        ResetDamageCount()
    end

    SetEnableAimMode()
    if TRUE == EvasionCommonFunction(FALL_TYPE_DEFAULT, "W_AttackRightLightStep", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLightStep", "W_AttackBothHeavy1Start", QUICKTYPE_ROLLING) then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventAllBody("W_Idle")
        return
    else
        SetRollingTurnCondition(FALSE)
    end
end

function Rolling_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function Rolling_Selftrans_onUpdate()
    act(DisallowAdditiveTurning, TRUE)
    SetThrowAtkInvalid()

    if TRUE == env(GetSpEffectID, 100390) then
        ResetDamageCount()
    end

    SetEnableAimMode()
    if TRUE == EvasionCommonFunction(FALL_TYPE_DEFAULT, "W_AttackRightLightStep", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLightStep", "W_AttackBothHeavy1Start", QUICKTYPE_ROLLING) then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventAllBody("W_Idle")
        return
    else
        SetRollingTurnCondition(TRUE)
    end
end

function Rolling_Selftrans_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function DefaultBackStep_onActivate()
    ResetDamageCount()
end

function DefaultBackStep_onUpdate()
    act(DisallowAdditiveTurning, TRUE)
    if TRUE == EvasionCommonFunction(FALL_TYPE_DEFAULT, "W_AttackRightBackstep", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothBackstep", "W_AttackBothHeavy1Start", QUICKTYPE_BACKSTEP) then
    end
end

function DefaultBackStep_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function BackStepGuardOn_UpperLayer_onUpdate()
    if ExecGuardOnCancelTiming(TO_GUARDON, ALLBODY) == TRUE then
        return
    elseif IsGuard() == FALSE then
        SetVariable("EnableTAE_BackStep", true)
        ExecEventNoReset("W_BackStepGuardEnd_UpperLayer")
    end
end

function BackStepGuardEnd_UpperLayer_onUpdate()
    if env(IsAnimEnd, 1) == TRUE or env(GetEventEzStateFlag, 0) == TRUE then
        ExecEventSyncNoReset("Event_BackStepGuardOut")
    end
end

function EStepDown_onUpdate()
    SetThrowAtkInvalid()
    SetEnableAimMode()

    if EvasionCommonFunction(FALL_TYPE_DEFAULT, "W_AttackRightLightStep", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLightStep", "W_AttackBothHeavy1Start", QUICKTYPE_ROLLING) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventAllBody("W_Idle")

        return
    else
        SetRollingTurnCondition(FALSE)
    end
end

function ChainRecover_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()

    if ChainRecoverCommonFunction() == TRUE then
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsAnimEnd, 1) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendLowerCommonFunction(Event_ChainRecoverMirror, lower_state, FALSE) == TRUE then

    end
end

function Move_Activate()
    SetWeightIndex()
end

function Move_Update()
    SetWeightIndex()
end

function Move_onActivate()
    act(SwitchMotion, TRUE)
end

function Move_onUpdate()
    act(SwitchMotion, TRUE)

    local move_speed = GetVariable("MoveSpeedIndex")

    if move_speed == 2 then
        SetThrowAtkInvalid()
    end

    if g_TimeActEditor_08 >= 1 then
        act(Set4DirectionMovementThreshold, GetVariable("MagicRightWalkAngle_FrontLeft"), GetVariable("MagicRightWalkAngle_FrontRight"), GetVariable("MagicRightWalkAngle_BackLeft"), GetVariable("MagicRightWalkAngle_BackRight"))
    elseif 1 <= g_TimeActEditor_09 then
        act(Set4DirectionMovementThreshold, GetVariable("MagicLeftWalkAngle_FrontLeft"), GetVariable("MagicLeftWalkAngle_FrontRight"), GetVariable("MagicLeftWalkAngle_BackLeft"), GetVariable("MagicLeftWalkAngle_BackRight"))
    elseif hkbGetVariable("MoveType") < 0.5 then
        act(Set4DirectionMovementThreshold, 60, 45, 60, 60)
    elseif hkbGetVariable("StanceMoveType") == 0 then
        act(Set4DirectionMovementThreshold, 70, 40, 60, 20)
    else
        act(Set4DirectionMovementThreshold, 40, 70, 60, 20)
    end

    SpeedUpdate()

    if TRUE == env(IsCOMPlayer) then
        local npc_turn_speed = 240

        if move_speed == 2 then
            npc_turn_speed = 180
        else
            local dir = GetVariable("MoveDirection")
            if dir == 0 then
                npc_turn_speed = 90
            end
        end

        SetTurnSpeed(npc_turn_speed)
    end

    local base_speed = 1
    local base_speed_percent = base_speed / 100

    if hkbGetVariable("MoveDirection") == 3 or 2 == hkbGetVariable("MoveDirection") then
        act(SetMovementScaleMult, (base_speed_percent * 95))
    elseif 1 == hkbGetVariable("MoveDirection") then
        act(SetMovementScaleMult, (base_speed_percent * 95))
    elseif hkbGetVariable("MoveDirection") == 0 then
        act(SetMovementScaleMult, (base_speed_percent * 98))
    end
end

function MoveNoSync_onActivate()
    act(SwitchMotion, TRUE)
end

function MoveNoSync_onUpdate()
    Move_onUpdate()
end

function Move_Upper_onActivate()
    act(Wait)
end

function Move_Upper_onUpdate()
    SetEnableMimicry()

    if MoveCommonFunction(UPPER) == TRUE then
        SetVariable("ArtsTransition", 0)
    end
end

function Guard_Activate()
    local hand = HAND_LEFT

    if c_Style == HAND_RIGHT_BOTH then
        hand = HAND_RIGHT
    end

    act(DebugLogOutput, "Guard_Activate ( ) ")
    SetGuardHand(hand)
end

function GuardStart_Upper_onActivate()
    act(Wait)
end

function GuardStart_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()

    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
        act(DisallowAdditiveTurning, TRUE)
    else
        act(DisallowAdditiveTurning, FALSE)
    end

    if GuardCommonFunction(FALSE, blend_type) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) or TRUE == env(GetEventEzStateFlag, 0) then
        ExecEventHalfBlend(Event_GuardOn, blend_type)
        return
    elseif HalfBlendLowerCommonFunction(Event_GuardStart, lower_state, FALSE) == TRUE then

    end
end

function GuardStart_Upper_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function GuardOn_Upper_onActivate()
    act(Wait)
end

function GuardOn_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()

    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
        act(DisallowAdditiveTurning, TRUE)
    else
        act(DisallowAdditiveTurning, FALSE)
    end

    if GuardCommonFunction(FALSE, blend_type) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_GuardOn, lower_state, FALSE) == TRUE then

    end
end

function GuardOn_Upper_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function GuardEnd_Upper_onActivate()
    act(Wait)
end

function GuardEnd_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()

    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
        act(DisallowAdditiveTurning, TRUE)
    else
        act(DisallowAdditiveTurning, FALSE)
    end

    if GuardCommonFunction(TRUE, blend_type) == TRUE then
        return
    elseif lower_state == LOWER_MOVE and (TRUE == env(IsAnimEnd, 1) or TRUE == env(GetEventEzStateFlag, 0)) then
        ExecEventHalfBlendNoReset(Event_MoveQuick, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_GuardEnd, lower_state, FALSE) == TRUE then

    end
end

function FallStart_onUpdate()
    if FallCommonFunction(TRUE, FALSE, FALL_DEFAULT) == TRUE then

    end
end

function FallJumpStart_onUpdate()
    if FallCommonFunction(TRUE, TRUE, FALL_DEFAULT) == TRUE then

    end
end

function FallLoop_onUpdate()
    if env(IsHamariFallDeath, 12) == TRUE then
        ExecEvent("W_FallDeath")
        return
    elseif FallCommonFunction(TRUE, FALSE, FALL_DEFAULT) == TRUE then

    end
end

function Land_onUpdate()
    if LandCommonFunction() == TRUE then

    end
end

function LandLow_onActivate()
    act(Wait)
end

function LandLow_onUpdate()
    if IdleCommonFunction() == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventAllBody("W_Idle")
    end
end

function FallStartFaceUp_onUpdate()
    if FallCommonFunction(TRUE, FALSE, FALL_FACEUP) == TRUE then

    end
end

function FallStartFaceDown_onUpdate()
    if FallCommonFunction(TRUE, FALSE, FALL_FACEDOWN) == TRUE then

    end
end

function FallLoopFaceUp_onUpdate()
    if env(IsHamariFallDeath, 12) == TRUE then
        ExecEvent("W_FallDeathFaceUp")
        return
    elseif FallCommonFunction(TRUE, FALSE, FALL_FACEUP) == TRUE then

    end
end

function FallLoopFaceDown_onUpdate()
    if env(IsHamariFallDeath, 12) == TRUE then
        ExecEvent("W_FallDeathFaceDown")
        return
    elseif FallCommonFunction(TRUE, FALSE, FALL_FACEDOWN) == TRUE then

    end
end

function LandFaceUp_onUpdate()
    if LandCommonFunction() == TRUE then

    end
end

function LandFaceDown_onUpdate()
    if LandCommonFunction() == TRUE then

    end
end

function Damage_Activate()
    ActivateRightArmAdd(START_FRAME_NONE)
end

function Damage_Update()
    UpdateRightArmAdd()
end

function Damage_NoThrowDef_Update()
    if env(GetSpEffectID, 30) == FALSE then
        SetThrowDefInvalid()
    end
end

function DamageSABreak_onUpdate()
    if DamageCommonFunction(FALSE, ESTEP_NONE, FALL_TYPE_FORCE) == TRUE then

    end
end

function DamageSleepResist_onUpdate()
    if DamageCommonFunction(FALSE, ESTEP_NONE, FALL_TYPE_FORCE) == TRUE then

    end
end

function DamageMad_onUpdate()
    if DamageCommonFunction(FALSE, ESTEP_NONE, FALL_TYPE_FORCE) == TRUE then

    end
end

function DamageBind_onActivate()
    ResetRequest()
end

function DamageBind_onUpdate()
    act(109, -1)
    act(SetIsMagicInUse, 0)
    act(SetAllowedThrowDefenseType, 0)
    act(SetAllowedThrowAttackType, 0)

    if DamageCommonFunction(FALSE, ESTEP_NONE, FALL_TYPE_FORCE) == TRUE then
        return
    elseif FALSE == env(Unknown362, 32) then
        ExecEventAllBody("W_Idle")
    end
end

function DamageLv1_Small_onUpdate()
    act(SetMovementScaleMult, 0)

    if DamageCommonFunction(FALSE, ESTEP_NONE, FALL_TYPE_FORCE) == TRUE then

    end
end

function DamageLv2_Middle_onUpdate()
    act(SetMovementScaleMult, 0)
    if DamageCommonFunction(FALSE, ESTEP_NONE, FALL_TYPE_FORCE) == TRUE then
    end
end

function DamageLv3_Large_onUpdate()
    act(SetMovementScaleMult, 0)

    if DamageCommonFunction(FALSE, ESTEP_NONE, FALL_TYPE_FORCE) == TRUE then

    end
end

function DamageLarge2_onUpdate()
    act(SetMovementScaleMult, 0)

    if DamageCommonFunction(FALSE, ESTEP_NONE, FALL_TYPE_FORCE) == TRUE then

    end
end

function DamageWeak_onUpdate()
    if DamageCommonFunction(FALSE, ESTEP_NONE, FALL_TYPE_FORCE) == TRUE then

    end
end

function DamageLv8_Minimum_onUpdate()
    if DamageCommonFunction(FALSE, ESTEP_NONE, FALL_TYPE_FORCE) == TRUE then

    end
end

function DamageLv6_Fling_onUpdate()
    if DamageCommonFunction(FALSE, ESTEP_DOWN, FALL_TYPE_FACEDOWN_LOOP) == TRUE then

    end
end

function DamageLv4_ExLarge_onUpdate()
    if DamageCommonFunction(FALSE, ESTEP_DOWN, FALL_TYPE_FORCE_LOOP) == TRUE then

    end
end

function DamageLv5_Push_onUpdate()
    act(SetMovementScaleMult, 0)

    if DamageCommonFunction(FALSE, ESTEP_NONE, FALL_TYPE_FORCE) == TRUE then

    end
end

function DamageLv7_SmallBlow_onUpdate()
    if DamageCommonFunction(FALSE, ESTEP_DOWN, FALL_TYPE_FORCE_LOOP) == TRUE then

    end
end

function DamageLv9_Upper_onUpdate()
    if DamageCommonFunction(FALSE, ESTEP_DOWN, FALL_TYPE_FACEDOWN_LOOP) == TRUE then

    end
end

function DamageLV10_ExBlast_onUpdate()
    if DamageCommonFunction(FALSE, ESTEP_DOWN, FALL_TYPE_FORCE_LOOP) == TRUE then

    end
end

function DamageLv11_Breath_onUpdate()
    if DamageCommonFunction(FALSE, ESTEP_DOWN, FALL_TYPE_FORCE_LOOP) == TRUE then

    end
end

function DamageParry_onUpdate()
    if DamageCommonFunction(FALSE, ESTEP_NONE, FALL_TYPE_DEFAULT) == TRUE then

    end
end

function GuardDamageSmall_onUpdate()
    act(SetStaminaRecoveryDisabled)

    if DamageCommonFunction(TO_GUARDON, ESTEP_NONE, FALL_TYPE_DEFAULT) == TRUE then

    end
end

function GuardDamageMiddle_onUpdate()
    act(SetStaminaRecoveryDisabled)

    if DamageCommonFunction(TO_GUARDON, ESTEP_NONE, FALL_TYPE_DEFAULT) == TRUE then

    end
end

function GuardDamageLarge_onUpdate()
    act(SetStaminaRecoveryDisabled)

    if DamageCommonFunction(TO_GUARDON, ESTEP_NONE, FALL_TYPE_DEFAULT) == TRUE then

    end
end

function GuardBreak_onUpdate()
    if DamageCommonFunction(FALSE, ESTEP_NONE, FALL_TYPE_DEFAULT) == TRUE then

    end
end

function GuardBreakRight_onUpdate()
    if DamageCommonFunction(FALSE, ESTEP_NONE, FALL_TYPE_DEFAULT) == TRUE then

    end
end

function Repelled_Wall_onUpdate()
    act(Unknown2027)

    if DamageCommonFunction(FALSE, ESTEP_NONE, FALL_TYPE_DEFAULT) == TRUE then

    end
end

function Repelled_Small_onUpdate()
    if DamageCommonFunction(FALSE, ESTEP_NONE, FALL_TYPE_DEFAULT) == TRUE then

    end
end

function Repelled_Large_onUpdate()
    if DamageCommonFunction(FALSE, ESTEP_NONE, FALL_TYPE_DEFAULT) == TRUE then

    end
end

function GuardDamageExLarge_onUpdate()
    if DamageCommonFunction(FALSE, ESTEP_DOWN, FALL_TYPE_DEFAULT) == TRUE then

    end
end

function DeathIdle_onActivate()
    act(SetDeathStay, TRUE)
end

function DeathIdle_onDeactivate()
    act(SetDeathStay, FALSE)
end

function QuickTurnLeft180_Upper_onUpdate()
    if QuickTurnCommonFunction() == TRUE then
        return
    elseif GetVariable("IsLockon") == false then
        ExecEventNoReset("W_Idle")
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventNoReset("W_Idle")
    end
end

function QuickTurnRight180_Upper_onUpdate()
    if QuickTurnCommonFunction() == TRUE then
        return
    elseif GetVariable("IsLockon") == false then
        ExecEventNoReset("W_Idle")
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventNoReset("W_Idle")
    end
end

function AttackRight_Activate()
    SetAttackHand(HAND_RIGHT)
    SetGuardHand(HAND_RIGHT)
end

function AttackRightWhileGuard_Activate()
    SetAttackHand(HAND_RIGHT)
    SetGuardHand(HAND_LEFT)
end

function AttackRightLight1_onUpdate()
    local r1 = "W_AttackRightLight2"

    if g_ComboReset == TRUE then
        r1 = "W_AttackRightLight1"
    end

    if AttackCommonFunction(r1, "W_AttackRightHeavy1SubStart", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight2", "W_AttackBothHeavy1Start", FALSE, TRUE, 1) == TRUE then

    end
end

function AttackRightLight2_onUpdate()
    if IsEnableNextAttack(2, HAND_RIGHT) == TRUE then
        local r1 = "W_AttackRightLight3"
        if TRUE == g_ComboReset then
            r1 = "W_AttackRightLight1"
        end
        if AttackCommonFunction(r1, "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight3", "W_AttackBothHeavy1Start", FALSE, TRUE, 2) == TRUE then
            return
        end
    elseif AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
    end
end

function AttackRightLight3_onUpdate()
    if IsEnableNextAttack(3, HAND_RIGHT) == TRUE then
        local r1 = "W_AttackRightLight4"
        if TRUE == g_ComboReset then
            r1 = "W_AttackRightLight1"
        end
        if AttackCommonFunction(r1, "W_AttackRightHeavy1SubStart", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight4", "W_AttackBothHeavy1Start", FALSE, TRUE, 3) == TRUE then
            return
        end
    elseif AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
    end
end

function AttackRightLight4_onUpdate()
    if IsEnableNextAttack(4, HAND_RIGHT) == TRUE then
        local r1 = "W_AttackRightLight5"
        if TRUE == g_ComboReset then
            r1 = "W_AttackRightLight1"
        end
        if AttackCommonFunction(r1, "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 4) == TRUE then
            return
        end
    elseif AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight2", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
    end
end

function AttackRightLight5_onUpdate()
    if IsEnableNextAttack(5, HAND_RIGHT) == TRUE then
        local r1 = "W_AttackRightLight6"
        if TRUE == g_ComboReset then
            r1 = "W_AttackRightLight1"
        end
        if AttackCommonFunction(r1, "W_AttackRightHeavy1SubStart", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight6", "W_AttackBothHeavy1Start", FALSE, TRUE, 5) == TRUE then
            return
        end
    elseif AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
    end
end

function AttackRightLight6_onUpdate()
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
    end
end

function AttackRightLightStep_onUpdate()
    local r1 = "W_AttackRightLightSubStart"
    if g_ComboReset == TRUE then
        r1 = "W_AttackRightLight1"
    end
    if AttackCommonFunction(r1, "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 1) == TRUE then
    end
end

function AttackRightLightStealth_onUpdate()
    local r1 = "W_AttackRightLightSubStart"
    if g_ComboReset == TRUE then
        r1 = "W_AttackRightLight1"
    end
    if AttackCommonFunction(r1, "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 1) == TRUE then
    end
end

function AttackRightLightFastStep_onUpdate()
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
    end
end

function AttackRightLightDash_onUpdate()
    local r1 = "W_AttackRightLightSubStart"
    if g_ComboReset == TRUE then
        r1 = "W_AttackRightLight1"
    end
    if AttackCommonFunction(r1, "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 1) == TRUE then
    end
end

function AttackRightHeavyDash_onUpdate()
    local r1 = "W_AttackRightLightSubStart"
    if g_ComboReset == TRUE then
        r1 = "W_AttackRightLight1"
    end
    if AttackCommonFunction(r1, "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 1) == TRUE then
    end
end

function AttackRightWhileGuard_onUpdate()
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", TO_GUARDON, TRUE, 0) == TRUE then
    end
end

function AttackRightHeavy1SubStart_onUpdate()
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy2Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy2Start", FALSE, TRUE, 0) == TRUE then
        return
    elseif TRUE == env(GetEventEzStateFlag, 0) or TRUE == env(IsAnimEnd, 1) then
        act(SetSpecialInterpolation, 0, TRUE)
        ExecEventAllBody("W_AttackRightHeavy1Start")
    end
end

function AttackRightLightSubStart_onUpdate()
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy2Start", FALSE, TRUE, 0) == TRUE then
        return
    elseif TRUE == env(GetEventEzStateFlag, 0) or TRUE == env(IsAnimEnd, 1) then
        act(SetSpecialInterpolation, 0, TRUE)
        ExecEventAllBody("W_AttackRightLight2")
    end
end

function AttackRightHeavy1Start_onUpdate()
    act(SetSpecialInterpolation, 0, FALSE)
    if IsEnableSpecialAttack(HAND_RIGHT) == TRUE and 0 < env(ActionDuration, ACTION_ARM_R2) and 0 < env(ActionDuration, ACTION_ARM_SP_MOVE) and TRUE == env(GetSpEffectID, 100290) then
        ExecEventAllBody("W_AttackRightSpecial1")
        return
    end
    local r1 = "W_AttackRightLightSubStart"
    if TRUE == g_ComboReset then
        r1 = "W_AttackRightLight1"
    end
    if AttackCommonFunction(r1, "W_AttackRightHeavy2Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 1) == TRUE then
        return
    elseif 0 >= env(ActionDuration, ACTION_ARM_R2) and (env(GetGeneralTAEFlag, TAE_FLAG_CHARGING) == 1 or TRUE == env(GetSpEffectID, 100280)) then
        ExecEventAllBody("W_AttackRightHeavy1End")
    end
end

function AttackRightHeavy1End_onUpdate()
    local r1 = "W_AttackRightLightSubStart"
    if g_ComboReset == TRUE then
        r1 = "W_AttackRightLight1"
    end
    if AttackCommonFunction(r1, "W_AttackRightHeavy2Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy2Start", FALSE, TRUE, 1) == TRUE then
    end
end

function AttackRightHeavy2Start_onUpdate()
    if IsEnableSpecialAttack(HAND_RIGHT) == TRUE and env(ActionDuration, ACTION_ARM_R2) > 0 and env(ActionDuration, ACTION_ARM_SP_MOVE) > 0 and TRUE == env(GetSpEffectID, 100290) then
        ExecEventAllBody("W_AttackRightSpecial2")
        return
    elseif AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
        return
    elseif env(ActionDuration, ACTION_ARM_R2) <= 0 and (env(GetGeneralTAEFlag, TAE_FLAG_CHARGING) == 1 or TRUE == env(GetSpEffectID, 100280)) then
        ExecEventAllBody("W_AttackRightHeavy2End")
    end
end

function AttackRightHeavy2End_onUpdate()
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
    end
end

function AttackRightHeavySpecial1SubStart_onUpdate()
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy2Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy2Start", FALSE, TRUE, 0) == TRUE then
        return
    elseif TRUE == env(GetEventEzStateFlag, 0) or TRUE == env(IsAnimEnd, 1) then
        act(SetSpecialInterpolation, 0, TRUE)
        ExecEventAllBody("W_AttackRightHeavySpecial1Start")
    end
end

function AttackRightHeavySpecial1Start_onUpdate()
    act(SetSpecialInterpolation, 0, FALSE)
    if env(IsAnimEnd, 0) == TRUE then
        SetRightSpecialHeavyAttackGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
        return
    end
    local gen_trans = FALSE
    if env(GetEquipWeaponSpecialCategoryNumber, HAND_RIGHT) == 852 then
        gen_trans = TRUE
    end
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy2Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy2Start", FALSE, TRUE, 0, gen_trans) == TRUE then
        return
    elseif 0 >= env(ActionDuration, ACTION_ARM_R2) and (env(GetGeneralTAEFlag, TAE_FLAG_CHARGING) == 1 or env(GetSpEffectID, 100280) == TRUE) then
        ExecEventAllBody("W_AttackRightHeavySpecial1End")
    end
end

function AttackRightHeavySpecial1End_onUpdate()
    if env(IsAnimEnd, 0) == TRUE then
        SetRightSpecialHeavyAttackGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
        return
    end
    local gen_trans = FALSE
    if env(GetEquipWeaponSpecialCategoryNumber, HAND_RIGHT) == 852 then
        gen_trans = TRUE
    end
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy2Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy2Start", FALSE, TRUE, 0, gen_trans) == TRUE then
    end
end

function AttackRightHeavySpecial2Start_onUpdate()
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
        return
    elseif 0 >= env(ActionDuration, ACTION_ARM_R2) and (env(GetGeneralTAEFlag, TAE_FLAG_CHARGING) == 1 or TRUE == env(GetSpEffectID, 100280)) then
        ExecEventAllBody("W_AttackRightHeavySpecial2End")
    end
end

function AttackRightHeavySpecial2End_onUpdate()
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
    end
end

function AttackRightSpecial1_onUpdate()
    if AttackCommonFunction("W_AttackRightBackstep", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
    end
end

function AttackRightSpecial2_onUpdate()
    if AttackCommonFunction("W_AttackRightBackstep", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
    end
end

function AttackRightBackstep_onUpdate()
    local r1 = "W_AttackRightLightSubStart"
    if g_ComboReset == TRUE then
        r1 = "W_AttackRightLight1"
    end
    if AttackCommonFunction(r1, "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 1) == TRUE then
    end
end

function AttackLeft_Activate()
    SetAttackHand(HAND_LEFT)
    SetGuardHand(HAND_LEFT)
    ActivateRightArmAdd(START_FRAME_A02)
end

function AttackLeft_Update()
    SetVariable("IndexDamageParryHand", 1)
    UpdateRightArmAdd()
end

function AttackLeft_Deactivate()
    SetVariable("IndexDamageParryHand", 0)
end

function AttackLeftLight1_onUpdate()
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
    end
end

function AttackLeftHeavy1_onUpdate()
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", nil, "W_AttackLeftHeavy2", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
    end
end

function AttackLeftHeavy2_onUpdate()
    if IsEnableNextAttack(2, HAND_LEFT) == TRUE then
        if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", nil, "W_AttackLeftHeavy3", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
            return
        end
    elseif AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", nil, "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
    end
end

function AttackLeftHeavy3_onUpdate()
    if IsEnableNextAttack(3, HAND_LEFT) == TRUE then
        if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", nil, "W_AttackLeftHeavy4", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 3) == TRUE then
            return
        end
    elseif AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", nil, "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
    end
end

function AttackLeftHeavy4_onUpdate()
    if IsEnableNextAttack(4, HAND_LEFT) == TRUE then
        if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", nil, "W_AttackLeftHeavy5", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
            return
        end
    elseif AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", nil, "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
    end
end

function AttackLeftHeavy5_onUpdate()
    if IsEnableNextAttack(5, HAND_LEFT) == TRUE then
        if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", nil, "W_AttackLeftHeavy6", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
            return
        end
    elseif AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", nil, "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
    end
end

function AttackLeftHeavy6_onUpdate()
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", nil, "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
    end
end

function AttackDual_Activate()
    SetAttackHand(HAND_RIGHT)
    SetGuardHand(HAND_LEFT)
    act(SetThrowPossibilityState_Defender, 400000)
end

function AttackDualLight1_onUpdate()
    local l1 = "W_AttackLeftLight2"
    if g_ComboReset == TRUE or GetDualAttackMaxNumber(HAND_RIGHT) <= 1 then
        l1 = "W_AttackLeftLight1"
    end
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", l1, "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 1) == TRUE then
    end
end

function AttackDualLight2_onUpdate()
    local l1 = "W_AttackLeftLight3"
    if g_ComboReset == TRUE or GetDualAttackMaxNumber(HAND_RIGHT) <= 2 then
        l1 = "W_AttackLeftLight1"
    end
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", l1, "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 1) == TRUE then
    end
end

function AttackDualLight3_onUpdate()
    local l1 = "W_AttackLeftLight4"
    if g_ComboReset == TRUE or GetDualAttackMaxNumber(HAND_RIGHT) <= 3 then
        l1 = "W_AttackLeftLight1"
    end
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", l1, "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 1) == TRUE then
    end
end

function AttackDualLight4_onUpdate()
    local l1 = "W_AttackLeftLight5"
    if g_ComboReset == TRUE or GetDualAttackMaxNumber(HAND_RIGHT) <= 4 then
        l1 = "W_AttackLeftLight1"
    end
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", l1, "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 1) == TRUE then
    end
end

function AttackDualLight5_onUpdate()
    local l1 = "W_AttackLeftLight6"
    if g_ComboReset == TRUE or GetDualAttackMaxNumber(HAND_RIGHT) <= 5 then
        l1 = "W_AttackLeftLight1"
    end
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", l1, "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 1) == TRUE then
    end
end

function AttackDualLight6_onUpdate()
    local l1 = "W_AttackLeftLight1"
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", l1, "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 1) == TRUE then
    end
end

function AttackDualDash_onUpdate()
    local l1 = "W_AttackLeftLight2"
    if g_ComboReset == TRUE then
        l1 = "W_AttackLeftLight1"
    end
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", l1, "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 1) == TRUE then
    end
end

function AttackDualRolling_onUpdate()
    local l1 = "W_AttackLeftLight2"
    if g_ComboReset == TRUE then
        l1 = "W_AttackLeftLight1"
    end
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", l1, "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 1) == TRUE then
    end
end

function AttackDualStealth_onUpdate()
    local l1 = "W_AttackLeftLight2"
    if g_ComboReset == TRUE then
        l1 = "W_AttackLeftLight1"
    end
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", l1, "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 1) == TRUE then
    end
end

function AttackDualBackStep_onUpdate()
    local l1 = "W_AttackLeftLight2"
    if g_ComboReset == TRUE then
        l1 = "W_AttackLeftLight1"
    end
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", l1, "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 1) == TRUE then
    end
end

function AttackBoth_Activate()
    local hand = HAND_RIGHT
    if c_Style == HAND_LEFT_BOTH then
        hand = HAND_LEFT
    end
    SetAttackHand(hand)
    SetGuardHand(hand)
end

function AttackBothLight1_onUpdate()
    local b1 = "W_AttackBothLight2"
    if g_ComboReset == TRUE then
        b1 = "W_AttackBothLight1"
    end
    if AttackCommonFunction("W_AttackRightLight2", "W_AttackRightHeavy1Start", "W_AttackBothLeft2", "W_AttackLeftHeavy1", b1, "W_AttackBothHeavy1SubStart", FALSE, TRUE, 1) == TRUE then
    end
end

function AttackBothLight2_onUpdate()
    if IsEnableNextAttack(2, HAND_RIGHT) == TRUE then
        local b1 = "W_AttackBothLight3"
        if TRUE == g_ComboReset then
            b1 = "W_AttackBothLight1"
        end
        if AttackCommonFunction("W_AttackRightLight3", "W_AttackRightHeavy1Start", "W_AttackBothLeft3", "W_AttackLeftHeavy1", b1, "W_AttackBothHeavy1Start", FALSE, TRUE, 2) == TRUE then
            return
        end
    elseif AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
    end
end

function AttackBothLight3_onUpdate()
    if IsEnableNextAttack(3, HAND_RIGHT) == TRUE then
        local b1 = "W_AttackBothLight4"
        if TRUE == g_ComboReset then
            b1 = "W_AttackBothLight1"
        end
        if AttackCommonFunction("W_AttackRightLight4", "W_AttackRightHeavy1Start", "W_AttackBothLeft2", "W_AttackLeftHeavy1", b1, "W_AttackBothHeavy1SubStart", FALSE, TRUE, 3) == TRUE then
            return
        end
    elseif AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
    end
end

function AttackBothLight4_onUpdate()
    if IsEnableNextAttack(4, HAND_RIGHT) == TRUE then
        local b1 = "W_AttackBothLight5"
        if TRUE == g_ComboReset then
            b1 = "W_AttackBothLight1"
        end
        if AttackCommonFunction("W_AttackRightLight5", "W_AttackRightHeavy1Start", "W_AttackBothLeft2", "W_AttackLeftHeavy1", b1, "W_AttackBothHeavy1SubStart", FALSE, TRUE, 4) == TRUE then
            return
        end
    elseif AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
    end
end

function AttackBothLight5_onUpdate()
    if IsEnableNextAttack(5, HAND_RIGHT) == TRUE then
        local b1 = "W_AttackBothLight6"
        if TRUE == g_ComboReset then
            b1 = "W_AttackBothLight1"
        end
        if AttackCommonFunction("W_AttackRightLight6", "W_AttackRightHeavy1Start", "W_AttackBothLeft2", "W_AttackLeftHeavy1", b1, "W_AttackBothHeavy1SubStart", FALSE, TRUE, 5) == TRUE then
            return
        end
    elseif AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
    end
end

function AttackBothLight6_onUpdate()
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackBothLeft2", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1SubStart", FALSE, TRUE, 0) == TRUE then
    end
end

function AttackBothLeft1_onUpdate()
    if AttackCommonFunction("W_AttackRightLight2", "W_AttackRightHeavy1Start", "W_AttackBothLeft2", "W_AttackLeftHeavy1", "W_AttackBothLight2", "W_AttackBothHeavy1Start", FALSE, TRUE, 1) == TRUE then
    end
end

function AttackBothLeft2_onUpdate()
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackBothLeft3", "W_AttackLeftHeavy1", "W_AttackBothLight3", "W_AttackBothHeavy1Start", FALSE, TRUE, 2) == TRUE then
    end
end

function AttackBothLeft3_onUpdate()
    if AttackCommonFunction("W_AttackRightLight2", "W_AttackRightHeavy1Start", "W_AttackBothLeft2", "W_AttackLeftHeavy1", "W_AttackBothLight2", "W_AttackBothHeavy1Start", FALSE, TRUE, 3) == TRUE then
    end
end

function AttackBothLeftDash_onUpdate()
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackBothLeft1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
    end
end

function AttackBothLeftStep_onUpdate()
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackBothLeft1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
    end
end

function AttackBothLightSubStart_onUpdate()
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy2Start", FALSE, TRUE, 0) == TRUE then
        return
    elseif TRUE == env(GetEventEzStateFlag, 0) or TRUE == env(IsAnimEnd, 1) then
        act(SetSpecialInterpolation, 0, TRUE)
        ExecEventAllBody("W_AttackBothLight2")
    end
end

function AttackBothHeavy1SubStart_onUpdate()
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackBothLeft1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy2Start", FALSE, TRUE, 0) == TRUE then
        return
    elseif TRUE == env(GetEventEzStateFlag, 0) or TRUE == env(IsAnimEnd, 1) then
        act(SetSpecialInterpolation, 0, TRUE)
        ExecEventAllBody("W_AttackBothHeavy1Start")
    end
end

function AttackBothHeavy1Start_onUpdate()
    act(SetSpecialInterpolation, 0, FALSE)
    if IsEnableSpecialAttack(HAND_RIGHT) == TRUE and 0 < env(ActionDuration, ACTION_ARM_R2) and 0 < env(ActionDuration, ACTION_ARM_SP_MOVE) and TRUE == env(GetSpEffectID, 100290) then
        ExecEventAllBody("W_AttackBothSpecial1")
        return
    end
    local b1 = "W_AttackBothLightSubStart"
    if TRUE == g_ComboReset then
        b1 = "W_AttackBothLight1"
    end
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy2Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, "W_AttackBothHeavy2Start", FALSE, TRUE, 1) == TRUE then
        return
    elseif 0 >= env(ActionDuration, ACTION_ARM_R2) and (env(GetGeneralTAEFlag, TAE_FLAG_CHARGING) == 1 or TRUE == env(GetSpEffectID, 100280)) then
        ExecEventAllBody("W_AttackBothHeavy1End")
    end
end

function AttackBothHeavy1End_onUpdate()
    local b1 = "W_AttackBothLightSubStart"
    if g_ComboReset == TRUE then
        b1 = "W_AttackBothLight1"
    end
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy2Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, "W_AttackBothHeavy2Start", FALSE, TRUE, 1) == TRUE then
    end
end

function AttackBothHeavy2Start_onUpdate()
    if IsEnableSpecialAttack(HAND_RIGHT) == TRUE and env(ActionDuration, ACTION_ARM_R2) > 0 and env(ActionDuration, ACTION_ARM_SP_MOVE) > 0 and TRUE == env(GetSpEffectID, 100290) then
        ExecEventAllBody("W_AttackBothSpecial2")
        return
    elseif AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackBothLeft1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
        return
    elseif env(ActionDuration, ACTION_ARM_R2) <= 0 and (env(GetGeneralTAEFlag, TAE_FLAG_CHARGING) == 1 or TRUE == env(GetSpEffectID, 100280)) then
        ExecEventAllBody("W_AttackBothHeavy2End")
    end
end

function AttackBothHeavy2End_onUpdate()
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackBothLeft1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
    end
end

function AttackBothHeavySpecial1SubStart_onUpdate()
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackBothLeft1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy2Start", FALSE, TRUE, 0) == TRUE then
        return
    elseif TRUE == env(GetEventEzStateFlag, 0) or TRUE == env(IsAnimEnd, 1) then
        act(SetSpecialInterpolation, 0, TRUE)
        ExecEventAllBody("W_AttackBothHeavySpecial1Start")
    end
end

function AttackBothHeavySpecial1Start_onUpdate()
    act(SetSpecialInterpolation, 0, FALSE)
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackBothLeft1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy2Start", FALSE, TRUE, 0) == TRUE then
        return
    elseif 0 >= env(ActionDuration, ACTION_ARM_R2) and (env(GetGeneralTAEFlag, TAE_FLAG_CHARGING) == 1 or TRUE == env(GetSpEffectID, 100280)) then
        ExecEventAllBody("W_AttackBothHeavySpecial1End")
    end
end

function AttackBothHeavySpecial1End_onUpdate()
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackBothLeft1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy2Start", FALSE, TRUE, 0) == TRUE then
    end
end

function AttackBothHeavySpecial2Start_onUpdate()
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackBothLeft1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
        return
    elseif 0 >= env(ActionDuration, ACTION_ARM_R2) and (env(GetGeneralTAEFlag, TAE_FLAG_CHARGING) == 1 or TRUE == env(GetSpEffectID, 100280)) then
        ExecEventAllBody("W_AttackBothHeavySpecial2End")
    end
end

function AttackBothHeavySpecial2End_onUpdate()
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackBothLeft1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
    end
end

function AttackBothSpecial1_onUpdate()
    if AttackCommonFunction("W_AttackRightBackstep", "W_AttackRightHeavy1Start", "W_AttackBothLeft1", "W_AttackLeftHeavy1", "W_AttackBothBackstep", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
    end
end

function AttackBothSpecial2_onUpdate()
    if AttackCommonFunction("W_AttackRightBackstep", "W_AttackRightHeavy1Start", "W_AttackBothLeft1", "W_AttackLeftHeavy1", "W_AttackBothBackstep", "W_AttackBothHeavy1Start", FALSE, TRUE, 0) == TRUE then
    end
end

function AttackBothDash_onUpdate()
    local b1 = "W_AttackBothLightSubStart"
    if g_ComboReset == TRUE then
        b1 = "W_AttackBothLight1"
    end
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, "W_AttackBothHeavy1Start", FALSE, TRUE, 1) == TRUE then
    end
end

function AttackBothHeavyDash_onUpdate()
    local b1 = "W_AttackBothLightSubStart"
    if g_ComboReset == TRUE then
        b1 = "W_AttackBothLight1"
    end
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, "W_AttackBothHeavy1Start", FALSE, TRUE, 1) == TRUE then
    end
end

function AttackBothLightStep_onUpdate()
    local b1 = "W_AttackBothLightSubStart"
    if g_ComboReset == TRUE then
        b1 = "W_AttackBothLight1"
    end
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, "W_AttackBothHeavy1Start", FALSE, TRUE, 1) == TRUE then
    end
end

function AttackBothLightStealth_onUpdate()
    local b1 = "W_AttackBothLightSubStart"
    if g_ComboReset == TRUE then
        b1 = "W_AttackBothLight1"
    end
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, "W_AttackBothHeavy1Start", FALSE, TRUE, 1) == TRUE then
    end
end

function AttackBothBackstep_onUpdate()
    local b1 = "W_AttackBothLightSubStart"
    if g_ComboReset == TRUE then
        b1 = "W_AttackBothLight1"
    end
    if AttackCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, "W_AttackBothHeavy1Start", FALSE, TRUE, 1) == TRUE then
    end
end

function AttackRightLightCounter_onUpdate()
    local r1 = "W_AttackRightLightSubStart"
    if g_ComboReset == TRUE then
        r1 = "W_AttackRightLight1"
    end
    if AttackCommonFunction(r1, "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight2", "W_AttackBothHeavy1Start", FALSE, TRUE, 1) == TRUE then
    end
end

function AttackRightHeavyCounter_onUpdate()
    local r1 = "W_AttackRightLightSubStart"
    local b1 = "W_AttackBothLightSubStart"
    if g_ComboReset == TRUE then
        r1 = "W_AttackRightLight1"
        b1 = "W_AttackBothLight1"
    end
    if AttackCommonFunction(r1, "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, "W_AttackBothHeavy1Start", FALSE, TRUE, 1) == TRUE then
    end
end

function AttackBothLightCounter_onUpdate()
    local r1 = "W_AttackRightLightSubStart"
    if g_ComboReset == TRUE then
        r1 = "W_AttackRightLight1"
    end
    if AttackCommonFunction(r1, "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLightSubStart", "W_AttackBothHeavy1Start", FALSE, TRUE, 1) == TRUE then
    end
end

function AttackBothHeavyCounter_onUpdate()
    local b1 = "W_AttackBothLightSubStart"
    if g_ComboReset == TRUE then
        b1 = "W_AttackBothLight1"
    end
    if AttackCommonFunction("W_AttackRightLight2", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, "W_AttackBothHeavy1Start", FALSE, TRUE, 1) == TRUE then
    end
end

function AttackArrowRight_Activate()
    local hand = HAND_RIGHT
    if c_Style == HAND_LEFT_BOTH then
        hand = HAND_LEFT
    end
    SetAttackHand(hand)
    SetGuardHand(hand)
end

function AttackArrowLeft_Activate()
    local hand = HAND_RIGHT
    if c_Style == HAND_LEFT_BOTH then
        hand = HAND_LEFT
    end
    SetAttackHand(hand)
    SetGuardHand(hand)
end

function AttackArrowRightStart_Upper_onUpdate()
    act(SetIsPreciseShootingPossible)
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if ArrowCommonFunction(blend_type, FALSE, TURN_TYPE_STANCE) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        if g_ArrowSlot == 0 then
            if env(ActionDuration, ACTION_ARM_R1) > 0 then
                ExecEventHalfBlend(Event_AttackArrowRightLoop, blend_type)
                return
            else
                ExecEventHalfBlend(Event_AttackArrowRightFireMove, blend_type)
                return
            end
        elseif env(ActionDuration, ACTION_ARM_R2) > 0 then
            ExecEventHalfBlend(Event_AttackArrowRightLoop, blend_type)
            return
        else
            ExecEventHalfBlend(Event_AttackArrowRightFireMove, blend_type)
            return
        end
    elseif ArrowLowerCommonFunction(Event_AttackArrowRightStart, lower_state, FALSE) == TRUE then
    end
end

function AttackArrowRightStartContinue_Upper_onUpdate()
    act(SetIsPreciseShootingPossible)
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if ArrowCommonFunction(blend_type, FALSE, TURN_TYPE_STANCE) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        if g_ArrowSlot == 0 then
            if env(ActionDuration, ACTION_ARM_R1) > 0 then
                ExecEventHalfBlend(Event_AttackArrowRightLoop, blend_type)
                return
            else
                ExecEventHalfBlend(Event_AttackArrowRightFireMove, blend_type)
                return
            end
        elseif env(ActionDuration, ACTION_ARM_R2) > 0 then
            ExecEventHalfBlend(Event_AttackArrowRightLoop, blend_type)
            return
        else
            ExecEventHalfBlend(Event_AttackArrowRightFireMove, blend_type)
            return
        end
    elseif ArrowLowerCommonFunction(Event_AttackArrowRightStartContinue, lower_state, FALSE) == TRUE then
    end
end

function AttackArrowRightLoop_Upper_onUpdate()
    act(SetIsPreciseShootingPossible)
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if ArrowCommonFunction(blend_type, FALSE, TURN_TYPE_STANCE) == TRUE then
        return
    elseif g_ArrowSlot == 0 then
        if 0 >= env(ActionDuration, ACTION_ARM_R1) then
            ExecEventHalfBlend(Event_AttackArrowRightFireMove, blend_type)
            return
        end
    elseif 0 >= env(ActionDuration, ACTION_ARM_R2) then
        ExecEventHalfBlend(Event_AttackArrowRightFireMove, blend_type)
        return
    end
    if ArrowLowerCommonFunction(Event_AttackArrowRightLoop, lower_state, FALSE) == TRUE then
    end
end

function AttackArrowRightFire_onUpdate()
    act(SetIsPreciseShootingPossible)
    if ArrowCommonFunction(ALLBODY, TRUE, TURN_TYPE_DEFAULT) == TRUE then
        return
    elseif env(GetStamina) > 0 then
        local request = GetAttackRequest(FALSE)
        if request == ATTACK_REQUEST_ARROW_FIRE_RIGHT or request == ATTACK_REQUEST_ARROW_FIRE_RIGHT2 then
            if env(GetEquipWeaponCategory, HAND_RIGHT) ~= WEAPON_CATEGORY_LARGE_ARROW then
                if TRUE == env(IsOutOfAmmo, 1) then
                    ExecEventAllBody("W_NoArrow")
                    return
                else
                    SetVariable("NoAmmo", 0)
                    ExecEventHalfBlend(Event_AttackArrowRightStartContinue, ALLBODY)
                    return
                end
            elseif TRUE == env(IsOutOfAmmo, 1) then
                ExecEventAllBody("W_NoArrow")
                return
            else
                ExecEventHalfBlend(Event_AttackArrowRightStartContinue, ALLBODY)
                return
            end
        end
    end
    if TRUE == MoveStartonCancelTiming(Event_Move, FALSE) then
    end
end

function AttackArrowRightFireMove_Upper_onUpdate()
    act(SetIsPreciseShootingPossible)
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if ArrowCommonFunction(blend_type, TRUE, TURN_TYPE_DEFAULT) == TRUE then
        return
    elseif env(GetStamina) > 0 then
        local request = GetAttackRequest(FALSE)
        if request == ATTACK_REQUEST_ARROW_FIRE_RIGHT or request == ATTACK_REQUEST_ARROW_FIRE_RIGHT2 then
            if env(GetEquipWeaponCategory, HAND_RIGHT) ~= WEAPON_CATEGORY_LARGE_ARROW then
                if TRUE == env(IsOutOfAmmo, 1) then
                    ExecEventAllBody("W_NoArrow")
                    return
                else
                    SetVariable("NoAmmo", 0)
                    act(DebugLogOutput, "AttackArrowRightStartContinue 0")
                    ExecEventHalfBlend(Event_AttackArrowRightStartContinue, blend_type)
                    act(DebugLogOutput, "AttackArrowRightStartContinue")
                    return
                end
            elseif TRUE == env(IsOutOfAmmo, 1) then
                ExecEventAllBody("W_NoArrow")
                return
            else
                ExecEventHalfBlend(Event_AttackArrowRightStartContinue, blend_type)
                return
            end
        end
    end
    if TRUE == MoveStartonCancelTiming(Event_Move, FALSE) then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif ArrowLowerCommonFunction(Event_AttackArrowRightFireMove, lower_state, FALSE) == TRUE then
    end
end

function AttackArrowRightFireDash_onUpdate()
    act(SetIsPreciseShootingPossible)
    if ArrowCommonFunction(ALLBODY, TRUE, TURN_TYPE_DEFAULT) == TRUE then
        return
    elseif env(GetStamina) > 0 then
        local request = GetAttackRequest(FALSE)
        if request == ATTACK_REQUEST_ARROW_FIRE_RIGHT or request == ATTACK_REQUEST_ARROW_FIRE_RIGHT2 then
            if env(GetEquipWeaponCategory, HAND_RIGHT) ~= WEAPON_CATEGORY_LARGE_ARROW then
                if TRUE == env(IsOutOfAmmo, 1) then
                    ExecEventAllBody("W_NoArrow")
                    return
                else
                    SetVariable("NoAmmo", 0)
                    ExecEventHalfBlend(Event_AttackArrowRightStartContinue, ALLBODY)
                    return
                end
            elseif TRUE == env(IsOutOfAmmo, 1) then
                ExecEventAllBody("W_NoArrow")
                return
            else
                ExecEventHalfBlend(Event_AttackArrowRightStartContinue, ALLBODY)
                return
            end
        end
    end
    if TRUE == MoveStartonCancelTiming(Event_Move, FALSE) then
    end
end

function AttackArrowRightFireStep_onUpdate()
    act(SetIsPreciseShootingPossible)
    if ArrowCommonFunction(ALLBODY, TRUE, TURN_TYPE_DEFAULT) == TRUE then
        return
    elseif env(GetStamina) > 0 then
        local request = GetAttackRequest(FALSE)
        if request == ATTACK_REQUEST_ARROW_FIRE_RIGHT or request == ATTACK_REQUEST_ARROW_FIRE_RIGHT2 then
            if env(GetEquipWeaponCategory, HAND_RIGHT) ~= WEAPON_CATEGORY_LARGE_ARROW then
                if TRUE == env(IsOutOfAmmo, 1) then
                    ExecEventAllBody("W_NoArrow")
                    return
                else
                    SetVariable("NoAmmo", 0)
                    ExecEventHalfBlend(Event_AttackArrowRightStartContinue, ALLBODY)
                    return
                end
            elseif TRUE == env(IsOutOfAmmo, 1) then
                ExecEventAllBody("W_NoArrow")
                return
            else
                ExecEventHalfBlend(Event_AttackArrowRightStartContinue, ALLBODY)
                return
            end
        end
    end
    if TRUE == MoveStartonCancelTiming(Event_Move, FALSE) then
    end
end

function AttackArrowLeftStart_Upper_onUpdate()
    act(SetIsPreciseShootingPossible)
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if ArrowCommonFunction(blend_type, FALSE, TURN_TYPE_STANCE) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        if g_ArrowSlot == 0 then
            if env(ActionDuration, ACTION_ARM_R1) > 0 then
                ExecEventHalfBlend(Event_AttackArrowLeftLoop, blend_type)
                return
            else
                ExecEventHalfBlend(Event_AttackArrowLeftFireMove, blend_type)
                return
            end
        elseif env(ActionDuration, ACTION_ARM_R2) > 0 then
            ExecEventHalfBlend(Event_AttackArrowLeftLoop, blend_type)
            return
        else
            ExecEventHalfBlend(Event_AttackArrowLeftFireMove, blend_type)
            return
        end
    elseif ArrowLowerCommonFunction(Event_AttackArrowLeftStart, lower_state, FALSE) == TRUE then
    end
end

function AttackArrowLeftStartContinue_Upper_onUpdate()
    act(SetIsPreciseShootingPossible)
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if ArrowCommonFunction(blend_type, FALSE, TURN_TYPE_STANCE) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        if g_ArrowSlot == 0 then
            if env(ActionDuration, ACTION_ARM_R1) > 0 then
                ExecEventHalfBlend(Event_AttackArrowLeftLoop, blend_type)
                return
            else
                ExecEventHalfBlend(Event_AttackArrowLeftFireMove, blend_type)
                return
            end
        elseif env(ActionDuration, ACTION_ARM_R2) > 0 then
            ExecEventHalfBlend(Event_AttackArrowLeftLoop, blend_type)
            return
        else
            ExecEventHalfBlend(Event_AttackArrowLeftFireMove, blend_type)
            return
        end
    elseif ArrowLowerCommonFunction(Event_AttackArrowLeftStartContinue, lower_state, FALSE) == TRUE then
    end
end

function AttackArrowLeftLoop_Upper_onUpdate()
    act(SetIsPreciseShootingPossible)
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if ArrowCommonFunction(blend_type, FALSE, TURN_TYPE_STANCE) == TRUE then
        return
    elseif g_ArrowSlot == 0 then
        if 0 >= env(ActionDuration, ACTION_ARM_R1) then
            ExecEventHalfBlend(Event_AttackArrowLeftFireMove, blend_type)
            return
        end
    elseif 0 >= env(ActionDuration, ACTION_ARM_R2) then
        ExecEventHalfBlend(Event_AttackArrowLeftFireMove, blend_type)
        return
    end
    if ArrowLowerCommonFunction(Event_AttackArrowLeftLoop, lower_state, FALSE) == TRUE then
    end
end

function AttackArrowLeftFire_onUpdate()
    act(SetIsPreciseShootingPossible)
    if ArrowCommonFunction(ALLBODY, TRUE, TURN_TYPE_DEFAULT) == TRUE then
        return
    elseif env(GetStamina) <= 0 then
        return
    end
    local request = GetAttackRequest(FALSE)
    if request == ATTACK_REQUEST_ARROW_FIRE_LEFT or request == ATTACK_REQUEST_ARROW_FIRE_LEFT2 then
        if env(GetEquipWeaponCategory, HAND_LEFT) ~= WEAPON_CATEGORY_LARGE_ARROW then
            if TRUE == env(IsOutOfAmmo, 0) then
                ExecEventAllBody("W_NoArrow")
                return
            elseif env(GetEquipWeaponCategory, HAND_LEFT) == WEAPON_CATEGORY_ARROW then
                ExecEventHalfBlend(Event_AttackArrowLeftStartContinue, ALLBODY)
            else
                ExecEventHalfBlend(Event_AttackArrowLeftStart, ALLBODY)
            end
            return
        elseif TRUE == env(IsOutOfAmmo, 0) then
            ExecEventAllBody("W_NoArrow")
            return
        else
            ExecEventHalfBlend(Event_AttackArrowLeftStart, ALLBODY)
            return
        end
    elseif TRUE == MoveStartonCancelTiming(Event_Move, FALSE) then
    end
end

function AttackArrowLeftFireMove_Upper_onUpdate()
    act(SetIsPreciseShootingPossible)
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if ArrowCommonFunction(blend_type, TRUE, TURN_TYPE_DEFAULT) == TRUE then
        return
    elseif env(GetStamina) > 0 then
        local request = GetAttackRequest(FALSE)
        if request == ATTACK_REQUEST_ARROW_FIRE_LEFT or request == ATTACK_REQUEST_ARROW_FIRE_LEFT2 then
            if env(GetEquipWeaponCategory, HAND_LEFT) ~= WEAPON_CATEGORY_LARGE_ARROW then
                if TRUE == env(IsOutOfAmmo, 0) then
                    ExecEventAllBody("W_NoArrow")
                    return
                else
                    SetVariable("NoAmmo", 0)
                    ExecEventHalfBlend(Event_AttackArrowLeftStartContinue, blend_type)
                    return
                end
            elseif TRUE == env(IsOutOfAmmo, 0) then
                ExecEventAllBody("W_NoArrow")
                return
            else
                ExecEventHalfBlend(Event_AttackArrowLeftStartContinue, blend_type)
                return
            end
        end
    end
    if TRUE == MoveStartonCancelTiming(Event_Move, FALSE) then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif ArrowLowerCommonFunction(Event_AttackArrowLeftFireMove, lower_state, FALSE) == TRUE then
    end
end

function AttackArrowLeftFireDash_onUpdate()
    act(SetIsPreciseShootingPossible)
    if ArrowCommonFunction(ALLBODY, TRUE, TURN_TYPE_DEFAULT) == TRUE then
        return
    elseif TRUE == MoveStartonCancelTiming(Event_Move, FALSE) then
    end
end

function AttackArrowLeftFireStep_onUpdate()
    act(SetIsPreciseShootingPossible)
    if ArrowCommonFunction(ALLBODY, TRUE, TURN_TYPE_DEFAULT) == TRUE then
        return
    elseif TRUE == MoveStartonCancelTiming(Event_Move, FALSE) then
    end
end

function NoArrow_onUpdate()
    if ArrowCommonFunction(ALLBODY, TRUE, TURN_TYPE_DEFAULT) == TRUE then
        return
    elseif TRUE == MoveStartonCancelTiming(Event_Move, FALSE) then
    end
end

function AttackCrossbowRight_Activate()
    local hand = HAND_RIGHT
    if c_Style == HAND_LEFT_BOTH then
        hand = HAND_LEFT
    end
    SetAttackHand(hand)
    SetGuardHand(hand)
end

function AttackCrossbowLeft_Activate()
    SetAttackHand(HAND_LEFT)
    SetGuardHand(HAND_LEFT)
    ActivateRightArmAdd(START_FRAME_A02)
end

function AttackCrossbowLeft_Update()
    UpdateRightArmAdd()
end

function AttackCrossbowRightStart_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if CrossbowCommonFunction(blend_type, FALSE) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) or TRUE == env(GetEventEzStateFlag, 0) then
        if 0 == g_ArrowSlot then
            if env(ActionDuration, ACTION_ARM_R1) > 0 then
                ExecEventHalfBlend(Event_AttackCrossbowRightLoop, blend_type)
                return
            else
                ExecEventHalfBlend(Event_AttackCrossbowRightFire, blend_type)
                return
            end
        elseif env(ActionDuration, ACTION_ARM_R2) > 0 then
            ExecEventHalfBlend(Event_AttackCrossbowRightLoop, blend_type)
            return
        else
            ExecEventHalfBlend(Event_AttackCrossbowRightFire, blend_type)
            return
        end
    elseif HalfBlendLowerCommonFunction(Event_AttackCrossbowRightLoop, lower_state, FALSE) == TRUE then
    end
end

function AttackCrossbowRightLoop_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if CrossbowCommonFunction(blend_type, FALSE) == TRUE then
        return
    elseif g_ArrowSlot == 0 then
        if 0 >= env(ActionDuration, ACTION_ARM_R1) then
            ExecEventHalfBlend(Event_AttackCrossbowRightFire, blend_type)
            return
        end
    elseif 0 >= env(ActionDuration, ACTION_ARM_R2) then
        ExecEventHalfBlend(Event_AttackCrossbowRightFire, blend_type)
        return
    end
    if HalfBlendLowerCommonFunction(Event_AttackCrossbowRightLoop, lower_state, FALSE) == TRUE then
    end
end

function AttackCrossbowRightFire_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if CrossbowCommonFunction(blend_type, TRUE) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_AttackCrossbowRightFire, lower_state, FALSE) == TRUE then
    end
end

function AttackCrossbowRightReload_Upper_onUpdate()
    act(Set4DirectionMovementThreshold, 60, 80, 60, 60)
    local blend_type, lower_state = GetHalfBlendInfo()
    if CrossbowCommonFunction(blend_type, TRUE) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_AttackCrossbowRightReload, lower_state, FALSE) == TRUE then
    end
end

function AttackCrossbowRightEmpty_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if CrossbowCommonFunction(blend_type, TRUE) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_AttackCrossbowRightEmpty, lower_state, FALSE) == TRUE then
    end
end

function AttackCrossbowLeftStart_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if CrossbowCommonFunction(blend_type, FALSE) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) or TRUE == env(GetEventEzStateFlag, 0) then
        if 0 == g_ArrowSlot then
            if env(ActionDuration, ACTION_ARM_L1) > 0 then
                ExecEventHalfBlend(Event_AttackCrossbowLeftLoop, blend_type)
                return
            else
                ExecEventHalfBlend(Event_AttackCrossbowLeftFire, blend_type)
                return
            end
        elseif env(ActionDuration, ACTION_ARM_L2) > 0 then
            ExecEventHalfBlend(Event_AttackCrossbowLeftLoop, blend_type)
            return
        else
            ExecEventHalfBlend(Event_AttackCrossbowLeftFire, blend_type)
            return
        end
    elseif HalfBlendLowerCommonFunction(Event_AttackCrossbowLeftLoop, lower_state, FALSE) == TRUE then
    end
end

function AttackCrossbowLeftLoop_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if CrossbowCommonFunction(blend_type, FALSE) == TRUE then
        return
    elseif g_ArrowSlot == 0 then
        if 0 >= env(ActionDuration, ACTION_ARM_L1) then
            ExecEventHalfBlend(Event_AttackCrossbowLeftFire, blend_type)
            return
        end
    elseif 0 >= env(ActionDuration, ACTION_ARM_L2) then
        ExecEventHalfBlend(Event_AttackCrossbowLeftFire, blend_type)
        return
    end
    if HalfBlendLowerCommonFunction(Event_AttackCrossbowLeftLoop, lower_state, FALSE) == TRUE then
    end
end

function AttackCrossbowLeftFire_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if CrossbowCommonFunction(blend_type, TRUE) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_AttackCrossbowLeftFire, lower_state, FALSE) == TRUE then
    end
end

function AttackCrossbowLeftReload_Upper_onUpdate()
    act(Set4DirectionMovementThreshold, 60, 45, 60, 60)
    local blend_type, lower_state = GetHalfBlendInfo()
    if CrossbowCommonFunction(blend_type, TRUE) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_AttackCrossbowLeftReload, lower_state, FALSE) == TRUE then
    end
end

function AttackCrossbowLeftEmpty_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if CrossbowCommonFunction(blend_type, TRUE) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_AttackCrossbowLeftEmpty, lower_state, FALSE) == TRUE then
    end
end

function AttackCrossbowBothLeftStart_Upper_onUpdate()
    act(SetIsPreciseShootingPossible)
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if CrossbowCommonFunction(blend_type, FALSE) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        if g_ArrowSlot == 0 then
            if env(ActionDuration, ACTION_ARM_L1) > 0 then
                ExecEventHalfBlend(Event_AttackCrossbowBothLeftLoop, blend_type)
                return
            else
                ExecEventHalfBlend(Event_AttackCrossbowBothLeftFire, blend_type)
                return
            end
        elseif env(ActionDuration, ACTION_ARM_l2) > 0 then
            ExecEventHalfBlend(Event_AttackCrossbowBothLeftLoop, blend_type)
            return
        else
            ExecEventHalfBlend(Event_AttackCrossbowBothLeftFire, blend_type)
            return
        end
    elseif HalfBlendLowerCommonFunction(Event_AttackCrossbowBothLeftLoop, lower_state, FALSE) == TRUE then
    end
end

function AttackCrossbowBothLeftLoop_Upper_onUpdate()
    act(SetIsPreciseShootingPossible)
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if CrossbowCommonFunction(blend_type, FALSE) == TRUE then
        return
    elseif g_ArrowSlot == 0 then
        if 0 >= env(ActionDuration, ACTION_ARM_L1) then
            ExecEventHalfBlend(Event_AttackCrossbowBothLeftFire, blend_type)
            return
        end
    elseif 0 >= env(ActionDuration, ACTION_ARM_L2) then
        ExecEventHalfBlend(Event_AttackCrossbowBothLeftFire, blend_type)
        return
    end
    if HalfBlendLowerCommonFunction(Event_AttackCrossbowBothLeftLoop, lower_state, FALSE) == TRUE then
    end
end

function AttackCrossbowBothLeftFire_Upper_onUpdate()
    act(SetIsPreciseShootingPossible)
    local blend_type, lower_state = GetHalfBlendInfo()
    if CrossbowCommonFunction(blend_type, TRUE) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_AttackCrossbowBothLeftFire, lower_state, FALSE) == TRUE then
    end
end

function AttackCrossbowBothLeftReload_Upper_onUpdate()
    act(Set4DirectionMovementThreshold, 60, 80, 60, 60)
    local blend_type, lower_state = GetHalfBlendInfo()
    if CrossbowCommonFunction(blend_type, TRUE) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_AttackCrossbowBothLeftReload, lower_state, FALSE) == TRUE then
    end
end

function AttackCrossbowBothLeftEmpty_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if CrossbowCommonFunction(blend_type, TRUE) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_AttackCrossbowBothLeftEmpty, lower_state, FALSE) == TRUE then
    end
end

function AttackCrossbowBothRightStart_Upper_onUpdate()
    act(SetIsPreciseShootingPossible)
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if CrossbowCommonFunction(blend_type, FALSE) == TRUE then
        return
    end
    local fireEvent = Event_AttackCrossbowBothRightFire
    if c_Style == HAND_LEFT_BOTH then
        fireEvent = Event_AttackCrossbowBothLeftFire
    end
    if TRUE == env(IsAnimEnd, 1) or TRUE == env(GetEventEzStateFlag, 0) then
        if 0 == g_ArrowSlot then
            if env(ActionDuration, ACTION_ARM_R1) > 0 then
                ExecEventHalfBlend(Event_AttackCrossbowBothRightLoop, blend_type)
                return
            else
                ExecEventHalfBlend(fireEvent, blend_type)
                return
            end
        elseif env(ActionDuration, ACTION_ARM_R2) > 0 then
            ExecEventHalfBlend(Event_AttackCrossbowBothRightLoop, blend_type)
            return
        else
            ExecEventHalfBlend(fireEvent, blend_type)
            return
        end
    elseif HalfBlendLowerCommonFunction(Event_AttackCrossbowBothRightLoop, lower_state, FALSE) == TRUE then
    end
end

function AttackCrossbowBothRightStartContinue_Upper_onUpdate()
    act(SetIsPreciseShootingPossible)
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if CrossbowCommonFunction(blend_type, FALSE) == TRUE then
        return
    end
    local fireEvent = Event_AttackCrossbowBothRightFire
    if c_Style == HAND_LEFT_BOTH then
        fireEvent = Event_AttackCrossbowBothLeftFire
    end
    if TRUE == env(IsAnimEnd, 1) or TRUE == env(GetEventEzStateFlag, 0) then
        if 0 == g_ArrowSlot then
            if env(ActionDuration, ACTION_ARM_R1) > 0 then
                ExecEventHalfBlend(Event_AttackCrossbowBothRightLoop, blend_type)
                return
            else
                ExecEventHalfBlend(fireEvent, blend_type)
                return
            end
        elseif env(ActionDuration, ACTION_ARM_R2) > 0 then
            ExecEventHalfBlend(Event_AttackCrossbowBothRightLoop, blend_type)
            return
        else
            ExecEventHalfBlend(fireEvent, blend_type)
            return
        end
    elseif HalfBlendLowerCommonFunction(Event_AttackCrossbowBothRightLoop, lower_state, FALSE) == TRUE then
    end
end

function AttackCrossbowBothRightLoop_Upper_onUpdate()
    act(SetIsPreciseShootingPossible)
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if CrossbowCommonFunction(blend_type, FALSE) == TRUE then
        return
    end
    local fireEvent = Event_AttackCrossbowBothRightFire
    if c_Style == HAND_LEFT_BOTH then
        fireEvent = Event_AttackCrossbowBothLeftFire
    end
    if g_ArrowSlot == 0 then
        if 0 >= env(ActionDuration, ACTION_ARM_R1) then
            ExecEventHalfBlend(fireEvent, blend_type)
            return
        end
    elseif 0 >= env(ActionDuration, ACTION_ARM_R2) then
        ExecEventHalfBlend(fireEvent, blend_type)
        return
    end
    if HalfBlendLowerCommonFunction(Event_AttackCrossbowBothRightLoop, lower_state, FALSE) == TRUE then
    end
end

function AttackCrossbowBothRightFire_Upper_onUpdate()
    act(SetIsPreciseShootingPossible)
    if c_Style == HAND_LEFT_BOTH then
    end
    local blend_type, lower_state = GetHalfBlendInfo()
    if CrossbowCommonFunction(blend_type, TRUE) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_AttackCrossbowBothRightFire, lower_state, FALSE) == TRUE then
    end
end

function AttackCrossbowBothRightReload_Upper_onUpdate()
    act(SetIsPreciseShootingPossible)
    act(Set4DirectionMovementThreshold, 60, 80, 60, 60)
    local blend_type, lower_state = GetHalfBlendInfo()
    if CrossbowCommonFunction(blend_type, TRUE) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_AttackCrossbowBothRightReload, lower_state, FALSE) == TRUE then
    end
end

function AttackCrossbowBothRightEmpty_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if CrossbowCommonFunction(blend_type, TRUE) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_AttackCrossbowBothRightEmpty, lower_state, FALSE) == TRUE then
    end
end

function StealthAttackCrossbowRightStart_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if CrossbowCommonFunction(blend_type, FALSE) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        if g_ArrowSlot == 0 then
            if env(ActionDuration, ACTION_ARM_R1) > 0 then
                ExecEventHalfBlend(Event_StealthAttackCrossbowRightLoop, blend_type)
                return
            else
                ExecEventHalfBlend(Event_StealthAttackCrossbowRightFire, blend_type)
                return
            end
        elseif env(ActionDuration, ACTION_ARM_R2) > 0 then
            ExecEventHalfBlend(Event_StealthAttackCrossbowRightLoop, blend_type)
            return
        else
            ExecEventHalfBlend(Event_StealthAttackCrossbowRightFire, blend_type)
            return
        end
    elseif HalfBlendLowerCommonFunction(Event_StealthAttackCrossbowRightLoop, lower_state, FALSE) == TRUE then
    end
end

function StealthAttackCrossbowRightLoop_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if CrossbowCommonFunction(blend_type, FALSE) == TRUE then
        return
    elseif g_ArrowSlot == 0 then
        if 0 >= env(ActionDuration, ACTION_ARM_R1) then
            ExecEventHalfBlend(Event_StealthAttackCrossbowRightFire, blend_type)
            return
        end
    elseif 0 >= env(ActionDuration, ACTION_ARM_R2) then
        ExecEventHalfBlend(Event_StealthAttackCrossbowRightFire, blend_type)
        return
    end
    if HalfBlendLowerCommonFunction(Event_StealthAttackCrossbowRightLoop, lower_state, FALSE) == TRUE then
    end
end

function StealthAttackCrossbowRightFire_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if CrossbowCommonFunction(blend_type, TRUE) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_StealthAttackCrossbowRightFire, lower_state, FALSE) == TRUE then
        return
    elseif TRUE == env(IsMoveCancelPossible) then
        if GetVariable("MoveSpeedLevel") > 0 then
            MoveStart(ALLBODY, Event_Stealth_Move, FALSE)
            return
        end
        hkbFireEvent("W_Stealth_Idle")
    end
end

function StealthAttackCrossbowRightEmpty_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if CrossbowCommonFunction(blend_type, TRUE) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_StealthAttackCrossbowRightEmpty, lower_state, FALSE) == TRUE then
        return
    elseif TRUE == env(IsMoveCancelPossible) then
        if GetVariable("MoveSpeedLevel") > 0 then
            MoveStart(ALLBODY, Event_Stealth_Move, FALSE)
            return
        end
        hkbFireEvent("W_Stealth_Idle")
    end
end

function StealthAttackCrossbowRightReload_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if CrossbowCommonFunction(blend_type, TRUE) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_StealthAttackCrossbowRightReload, lower_state, FALSE) == TRUE then
        return
    elseif TRUE == env(IsMoveCancelPossible) then
        if GetVariable("MoveSpeedLevel") > 0 then
            MoveStart(ALLBODY, Event_Stealth_Move, FALSE)
            return
        end
        hkbFireEvent("W_Stealth_Idle")
    end
end

function StealthAttackCrossbowLeftStart_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if CrossbowCommonFunction(blend_type, FALSE) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        if g_ArrowSlot == 0 then
            if env(ActionDuration, ACTION_ARM_L1) > 0 then
                ExecEventHalfBlend(Event_StealthAttackCrossbowLeftLoop, blend_type)
                return
            else
                ExecEventHalfBlend(Event_StealthAttackCrossbowLeftFire, blend_type)
                return
            end
        elseif env(ActionDuration, ACTION_ARM_L2) > 0 then
            ExecEventHalfBlend(Event_StealthAttackCrossbowLeftLoop, blend_type)
            return
        else
            ExecEventHalfBlend(Event_StealthAttackCrossbowLeftFire, blend_type)
            return
        end
    elseif HalfBlendLowerCommonFunction(Event_StealthAttackCrossbowLeftLoop, lower_state, FALSE) == TRUE then
        return
    elseif TRUE == env(IsMoveCancelPossible) then
        if 0 < GetVariable("MoveSpeedLevel") then
            MoveStart(ALLBODY, Event_Stealth_Move, FALSE)
            return
        end
        hkbFireEvent("W_Stealth_Idle")
    end
end

function StealthAttackCrossbowLeftLoop_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if CrossbowCommonFunction(blend_type, FALSE) == TRUE then
        return
    elseif g_ArrowSlot == 0 then
        if 0 >= env(ActionDuration, ACTION_ARM_L1) then
            ExecEventHalfBlend(Event_StealthAttackCrossbowLeftFire, blend_type)
            return
        end
    elseif 0 >= env(ActionDuration, ACTION_ARM_L2) then
        ExecEventHalfBlend(Event_StealthAttackCrossbowLeftFire, blend_type)
        return
    end
    if HalfBlendLowerCommonFunction(Event_StealthAttackCrossbowLeftLoop, lower_state, FALSE) == TRUE then
    end
end

function StealthAttackCrossbowLeftFire_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if CrossbowCommonFunction(blend_type, TRUE) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_StealthAttackCrossbowLeftFire, lower_state, FALSE) == TRUE then
        return
    elseif TRUE == env(IsMoveCancelPossible) then
        if GetVariable("MoveSpeedLevel") > 0 then
            MoveStart(ALLBODY, Event_Stealth_Move, FALSE)
            return
        end
        hkbFireEvent("W_Stealth_Idle")
    end
end

function StealthAttackCrossbowLeftEmpty_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if CrossbowCommonFunction(blend_type, TRUE) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_StealthAttackCrossbowLeftEmpty, lower_state, FALSE) == TRUE then
        return
    elseif TRUE == env(IsMoveCancelPossible) then
        if GetVariable("MoveSpeedLevel") > 0 then
            MoveStart(ALLBODY, Event_Stealth_Move, FALSE)
            return
        end
        hkbFireEvent("W_Stealth_Idle")
    end
end

function StealthAttackCrossbowLeftReload_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if CrossbowCommonFunction(blend_type, TRUE) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_StealthAttackCrossbowLeftReload, lower_state, FALSE) == TRUE then
        return
    elseif TRUE == env(IsMoveCancelPossible) then
        if GetVariable("MoveSpeedLevel") > 0 then
            MoveStart(ALLBODY, Event_Stealth_Move, FALSE)
            return
        end
        hkbFireEvent("W_Stealth_Idle")
    end
end

function StealthAttackCrossbowBothLeftStart_Upper_onUpdate()
    act(SetIsPreciseShootingPossible)
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if CrossbowCommonFunction(blend_type, FALSE) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        if g_ArrowSlot == 0 then
            if env(ActionDuration, ACTION_ARM_L1) > 0 then
                ExecEventHalfBlend(Event_StealthAttackCrossbowBothLeftLoop, blend_type)
                return
            else
                ExecEventHalfBlend(Event_StealthAttackCrossbowBothLeftFire, blend_type)
                return
            end
        elseif env(ActionDuration, ACTION_ARM_l2) > 0 then
            ExecEventHalfBlend(Event_StealthAttackCrossbowBothLeftLoop, blend_type)
            return
        else
            ExecEventHalfBlend(Event_StealthAttackCrossbowBothLeftFire, blend_type)
            return
        end
    elseif HalfBlendLowerCommonFunction(Event_StealthAttackCrossbowBothLeftLoop, lower_state, FALSE) == TRUE then
    end
end

function StealthAttackCrossbowBothLeftLoop_Upper_onUpdate()
    act(SetIsPreciseShootingPossible)
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if CrossbowCommonFunction(blend_type, FALSE) == TRUE then
        return
    elseif g_ArrowSlot == 0 then
        if 0 >= env(ActionDuration, ACTION_ARM_L1) then
            ExecEventHalfBlend(Event_StealthAttackCrossbowBothLeftFire, blend_type)
            return
        end
    elseif 0 >= env(ActionDuration, ACTION_ARM_L2) then
        ExecEventHalfBlend(Event_StealthAttackCrossbowBothLeftFire, blend_type)
        return
    end
    if HalfBlendLowerCommonFunction(Event_StealthAttackCrossbowBothLeftLoop, lower_state, FALSE) == TRUE then
    end
end

function StealthAttackCrossbowBothLeftFire_Upper_onUpdate()
    act(SetIsPreciseShootingPossible)
    local blend_type, lower_state = GetHalfBlendInfo()
    if CrossbowCommonFunction(blend_type, TRUE) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_StealthAttackCrossbowBothLeftFire, lower_state, FALSE) == TRUE then
        return
    elseif TRUE == env(IsMoveCancelPossible) then
        if GetVariable("MoveSpeedLevel") > 0 then
            MoveStart(ALLBODY, Event_Stealth_Move, FALSE)
            return
        end
        hkbFireEvent("W_Stealth_Idle")
    end
end

function StealthAttackCrossbowBothLeftEmpty_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if CrossbowCommonFunction(blend_type, TRUE) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_StealthAttackCrossbowBothLeftEmpty, lower_state, FALSE) == TRUE then
        return
    elseif TRUE == env(IsMoveCancelPossible) then
        if GetVariable("MoveSpeedLevel") > 0 then
            MoveStart(ALLBODY, Event_Stealth_Move, FALSE)
            return
        end
        hkbFireEvent("W_Stealth_Idle")
    end
end

function StealthAttackCrossbowBothLeftReload_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if CrossbowCommonFunction(blend_type, TRUE) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_StealthAttackCrossbowBothLeftReload, lower_state, FALSE) == TRUE then
        return
    elseif TRUE == env(IsMoveCancelPossible) then
        if GetVariable("MoveSpeedLevel") > 0 then
            MoveStart(ALLBODY, Event_Stealth_Move, FALSE)
            return
        end
        hkbFireEvent("W_Stealth_Idle")
    end
end

function StealthAttackCrossbowBothRightStart_Upper_onUpdate()
    act(SetIsPreciseShootingPossible)
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if CrossbowCommonFunction(blend_type, FALSE) == TRUE then
        return
    end
    local fireEvent = Event_StealthAttackCrossbowBothRightFire
    if c_Style == HAND_LEFT_BOTH then
        fireEvent = Event_StealthAttackCrossbowBothLeftFire
    end
    if TRUE == env(IsAnimEnd, 1) then
        if g_ArrowSlot == 0 then
            if env(ActionDuration, ACTION_ARM_R1) > 0 then
                ExecEventHalfBlend(Event_StealthAttackCrossbowBothRightLoop, blend_type)
                return
            else
                ExecEventHalfBlend(fireEvent, blend_type)
                return
            end
        elseif env(ActionDuration, ACTION_ARM_R2) > 0 then
            ExecEventHalfBlend(Event_StealthAttackCrossbowBothRightLoop, blend_type)
            return
        else
            ExecEventHalfBlend(fireEvent, blend_type)
            return
        end
    elseif HalfBlendLowerCommonFunction(Event_StealthAttackCrossbowBothRightLoop, lower_state, FALSE) == TRUE then
    end
end

function StealthAttackCrossbowBothRightLoop_Upper_onUpdate()
    act(SetIsPreciseShootingPossible)
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if CrossbowCommonFunction(blend_type, FALSE) == TRUE then
        return
    end
    local fireEvent = Event_StealthAttackCrossbowBothRightFire
    if c_Style == HAND_LEFT_BOTH then
        fireEvent = Event_StealthAttackCrossbowBothLeftFire
    end
    if g_ArrowSlot == 0 then
        if 0 >= env(ActionDuration, ACTION_ARM_R1) then
            ExecEventHalfBlend(fireEvent, blend_type)
            return
        end
    elseif 0 >= env(ActionDuration, ACTION_ARM_R2) then
        ExecEventHalfBlend(fireEvent, blend_type)
        return
    end
    if HalfBlendLowerCommonFunction(Event_StealthAttackCrossbowBothRightLoop, lower_state, FALSE) == TRUE then
    end
end

function StealthAttackCrossbowBothRightFire_Upper_onUpdate()
    act(SetIsPreciseShootingPossible)
    local blend_type, lower_state = GetHalfBlendInfo()
    if CrossbowCommonFunction(blend_type, TRUE) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_StealthAttackCrossbowBothRightFire, lower_state, FALSE) == TRUE then
        return
    elseif TRUE == env(IsMoveCancelPossible) then
        if GetVariable("MoveSpeedLevel") > 0 then
            MoveStart(ALLBODY, Event_Stealth_Move, FALSE)
            return
        end
        hkbFireEvent("W_Stealth_Idle")
    end
end

function StealthAttackCrossbowBothRightReload_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if CrossbowCommonFunction(blend_type, TRUE) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_StealthAttackCrossbowBothRightReload, lower_state, FALSE) == TRUE then
        return
    elseif TRUE == env(IsMoveCancelPossible) then
        if GetVariable("MoveSpeedLevel") > 0 then
            MoveStart(ALLBODY, Event_Stealth_Move, FALSE)
            return
        end
        hkbFireEvent("W_Stealth_Idle")
    end
end

function StealthAttackCrossbowBothRightEmpty_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if CrossbowCommonFunction(blend_type, TRUE) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_StealthAttackCrossbowBothRightEmpty, lower_state, FALSE) == TRUE then
        return
    elseif TRUE == env(IsMoveCancelPossible) then
        if GetVariable("MoveSpeedLevel") > 0 then
            MoveStart(ALLBODY, Event_Stealth_Move, FALSE)
            return
        end
        hkbFireEvent("W_Stealth_Idle")
    end
end

function SwordArts_Activate()
    SetAttackHand(c_SwordArtsHand)
    SetGuardHand(REG0)
    ActivateRightArmAdd(START_FRAME_NONE)
end

function SwordArts_Update()
    UpdateRightArmAdd()
end

function DrawStanceRightStart_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if GetEquipType(c_SwordArtsHand, WEAPON_CATEGORY_SMALL_ARROW, WEAPON_CATEGORY_ARROW, WEAPON_CATEGORY_LARGE_ARROW) == TRUE then
        act(SetIsPreciseShootingPossible)
        if ArrowCommonFunction(blend_type, FALSE, TURN_TYPE_STANCE) == TRUE then
            return
        elseif ArrowStanceCommonFunction(blend_type, FALSE) == TRUE then
            return
        end
    end
    local r1 = "W_DrawStanceRightAttackLight"
    local r2 = "W_DrawStanceRightAttackHeavy"
    local b1 = "W_DrawStanceRightAttackLight"
    local b2 = "W_DrawStanceRightAttackHeavy"
    if c_SwordArtsID == 239 then -- 1.09 change
        r1 = "W_AttackRightLight2"
        r2 = "W_AttackRightHeavy1Start"
        b1 = "W_AttackBothLight2"
        b2 = "W_AttackBothHeavy1Start"
    end
    if TRUE == env(GetSpEffectID, 100530) then
        r1 = "W_SwordArtsStanceAttackLightStart"
        r2 = "W_SwordArtsStanceAttackHeavyStart"
        b1 = "W_SwordArtsStanceAttackLightStart"
        b2 = "W_SwordArtsStanceAttackHeavyStart"
    elseif TRUE == env(GetSpEffectID, 100540) then
        r1 = "W_SwordArtsStanceAttackLight180"
        r2 = "W_SwordArtsStanceAttackHeavy180"
        b1 = "W_SwordArtsStanceAttackLight180"
        b2 = "W_SwordArtsStanceAttackHeavy180"
    end
    if ArtsStanceCommonFunction(r1, r2, "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, b2, blend_type, TURN_TYPE_STANCE, TRUE, TRUE, FALSE) == TRUE then
        return
    elseif TRUE == env(GetGeneralTAEFlag, 10) and (env(ActionDuration, ACTION_ARM_L2) < 200 or TRUE == env(ActionCancelRequest, ACTION_ARM_L2)) then
        ExecEventHalfBlend(Event_DrawStanceRightEnd, blend_type)
        return
    elseif TRUE == env(IsAnimEnd, 1) or TRUE == env(GetEventEzStateFlag, 0) then
        local index = c_SwordArtsID
        if index == 10 or index == 11 then
            drawStanceNoSyncLoop_NoMP = GetVariable("IsEnoughArtPointsL2")
            ExecEventHalfBlendNoReset(Event_DrawStanceNoSyncLoop, blend_type)
        else
            ExecEventHalfBlendNoReset(Event_DrawStanceRightLoop, blend_type)
        end
        return
    elseif HalfBlendLowerCommonFunction(Event_DrawStanceRightStart, lower_state, FALSE) == TRUE then
    end
end

function DrawStanceRightLoop_Upper_onUpdate()
    SetSwordArtsPointInfo(ACTION_ARM_L2, TRUE)
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if TRUE == GetEquipType(c_SwordArtsHand, WEAPON_CATEGORY_SMALL_ARROW, WEAPON_CATEGORY_ARROW, WEAPON_CATEGORY_LARGE_ARROW) then
        act(DebugLogOutput, "ArrowStanceRightLoop")
        act(SetIsPreciseShootingPossible)
        if ArrowCommonFunction(blend_type, FALSE, TURN_TYPE_STANCE) == TRUE then
            return
        elseif ArrowStanceCommonFunction(blend_type, FALSE) == TRUE then
            return
        end
    end
    local r1 = "W_DrawStanceRightAttackLight"
    local r2 = "W_DrawStanceRightAttackHeavy"
    local b1 = "W_DrawStanceRightAttackLight"
    local b2 = "W_DrawStanceRightAttackHeavy"
    if TRUE == env(GetSpEffectID, 100530) then
        r1 = "W_SwordArtsStanceAttackLightStart"
        r2 = "W_SwordArtsStanceAttackHeavyStart"
        b1 = "W_SwordArtsStanceAttackLightStart"
        b2 = "W_SwordArtsStanceAttackHeavyStart"
    elseif TRUE == env(GetSpEffectID, 100540) then
        r1 = "W_SwordArtsStanceAttackLight180"
        r2 = "W_SwordArtsStanceAttackHeavy180"
        b1 = "W_SwordArtsStanceAttackLight180"
        b2 = "W_SwordArtsStanceAttackHeavy180"
    end
    if ArtsStanceCommonFunction(r1, r2, "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, b2, blend_type, TURN_TYPE_STANCE, TRUE, TRUE, FALSE) == TRUE then
        return
    elseif c_SwordArtsID == 239 then
        if env(GetStamina) <= 0 then
            ExecEventHalfBlend(Event_DrawStanceRightEnd, blend_type)
            return
        elseif GetVariable("IsEnoughArtPointsL2") == 1 then
            ExecEventHalfBlend(Event_DrawStanceRightEnd, blend_type)
            return
        end
    end
    if c_SwordArtsID == 25 and env(GetStamina) <= 0 then
        ExecEventHalfBlend(Event_DrawStanceRightEnd, blend_type)
        return
    elseif TRUE == GetEquipType(c_SwordArtsHand, WEAPON_CATEGORY_LARGE_ARROW) and TRUE == MoveStartonCancelTiming(Event_Move, FALSE) then
        return
    elseif env(ActionDuration, ACTION_ARM_L2) <= 0 or env(ActionCancelRequest, ACTION_ARM_L2) == TRUE then
        ExecEventHalfBlend(Event_DrawStanceRightEnd, blend_type)
        return
    elseif GetEquipType(c_SwordArtsHand, WEAPON_CATEGORY_LARGE_ARROW) == FALSE and c_SwordArtsID ~= 105 and c_SwordArtsID ~= 108 and c_SwordArtsID ~= 169 and HalfBlendLowerCommonFunction(Event_DrawStanceRightLoop, lower_state, FALSE) == TRUE then
    end
end

drawStanceNoSyncLoop_NoMP = 0

function DrawStanceNoSyncLoop_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    SetSwordArtsPointInfo(ACTION_ARM_L2, TRUE)
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 90, 90)
    end
    local r1 = "W_DrawStanceRightAttackLight"
    local r2 = "W_DrawStanceRightAttackHeavy"
    local b1 = "W_DrawStanceRightAttackLight"
    local b2 = "W_DrawStanceRightAttackHeavy"
    if TRUE == env(GetSpEffectID, 100530) then
        r1 = "W_SwordArtsStanceAttackLightStart"
        r2 = "W_SwordArtsStanceAttackHeavyStart"
        b1 = "W_SwordArtsStanceAttackLightStart"
        b2 = "W_SwordArtsStanceAttackHeavyStart"
    elseif TRUE == env(GetSpEffectID, 100540) then
        r1 = "W_SwordArtsStanceAttackLight180"
        r2 = "W_SwordArtsStanceAttackHeavy180"
        b1 = "W_SwordArtsStanceAttackLight180"
        b2 = "W_SwordArtsStanceAttackHeavy180"
    end
    if ArtsStanceCommonFunction(r1, r2, "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, b2, blend_type, TURN_TYPE_STANCE, TRUE, TRUE, FALSE) == TRUE then
        return
    elseif TRUE == env(GetEventEzStateFlag, 0) and (env(ActionDuration, ACTION_ARM_L2) <= 0 or env(ActionCancelRequest, ACTION_ARM_L2) == TRUE or env(GetStamina) <= 0 or FALSE == drawStanceNoSyncLoop_NoMP and GetVariable("IsEnoughArtPointsL2") == 1) then
        ExecEventHalfBlend(Event_DrawStanceRightEnd, blend_type)
        return
    elseif HalfBlendLowerCommonFunctionNoSync(Event_DrawStanceNoSyncLoop, lower_state, FALSE, TRUE) == TRUE then
    end
end

function DrawStanceNoSyncLoopMax_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 90, 90)
    end
    local r1 = "W_DrawStanceRightAttackMaxLight"
    local r2 = "W_DrawStanceRightAttackMaxHeavy"
    local b1 = "W_DrawStanceRightAttackMaxLight"
    local b2 = "W_DrawStanceRightAttackMaxHeavy"
    if env(GetSpEffectID, 100530) == TRUE then
        r1 = "W_DrawStanceRightAttackMaxLightR90"
        r2 = "W_DrawStanceRightAttackMaxHeavyR90"
        b1 = "W_DrawStanceRightAttackMaxLightR90"
        b2 = "W_DrawStanceRightAttackMaxHeavyR90"
    elseif env(GetSpEffectID, 100540) == TRUE then
        r1 = "W_DrawStanceRightAttackMaxLight180"
        r2 = "W_DrawStanceRightAttackMaxHeavy180"
        b1 = "W_DrawStanceRightAttackMaxLight180"
        b2 = "W_DrawStanceRightAttackMaxHeavy180"
    elseif env(GetSpEffectID, 100550) == TRUE then
        r1 = "W_DrawStanceRightAttackMaxLightL90"
        r2 = "W_DrawStanceRightAttackMaxHeavyL90"
        b1 = "W_DrawStanceRightAttackMaxLightL90"
        b2 = "W_DrawStanceRightAttackMaxHeavyL90"
    end
    if ArtsStanceCommonFunction(r1, r2, "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, b2, blend_type, TRUE, TRUE, FALSE) == TRUE then
        return
    elseif env(ActionDuration, ACTION_ARM_L2) <= 0 or env(ActionCancelRequest, ACTION_ARM_L2) == TRUE then
        ExecEventHalfBlend(Event_DrawStanceRightEnd, blend_type)
        return
    end
    local sp_kind = env(GetEquipWeaponSpecialCategoryNumber, c_SwordArtsHand)
    if sp_kind == 248 and env(GetStamina) <= 0 then
        ExecEventHalfBlend(Event_DrawStanceRightEnd, blend_type)
        return
    elseif HalfBlendLowerCommonFunctionNoSync(Event_DrawStanceRightLoopMaxNoSync, lower_state, FALSE, TRUE) == TRUE then
    end
end

function DrawStanceRightEnd_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    end
    if GetEquipType(c_SwordArtsHand, WEAPON_CATEGORY_SMALL_ARROW, WEAPON_CATEGORY_ARROW, WEAPON_CATEGORY_LARGE_ARROW) == TRUE then
        act(SetIsPreciseShootingPossible)
        if ArrowCommonFunction(blend_type, FALSE, TURN_TYPE_STANCE) == TRUE then
            return
        end
    end
    if ArtsStanceCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", blend_type, TURN_TYPE_DEFAULT, FALSE, FALSE, TRUE) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        SetArtsGeneratorTransitionIndex()
        return
    elseif lower_state == LOWER_END_TURN then
        SetArtsGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
    elseif HalfBlendLowerCommonFunction(Event_DrawStanceRightEnd, lower_state, FALSE) == TRUE then
    end
end

function DrawStanceRightAttackLight_onUpdate()
    if GetEquipType(c_SwordArtsHand, WEAPON_CATEGORY_SMALL_ARROW, WEAPON_CATEGORY_ARROW, WEAPON_CATEGORY_LARGE_ARROW) == TRUE then
        act(SetIsPreciseShootingPossible)
        if ArrowCommonFunction(ALLBODY, TRUE, TURN_TYPE_DEFAULT) == TRUE then
            return
        elseif TRUE == env(GetSpEffectID, 100280) and (not (g_ArrowSlot ~= 0 or env(ActionDuration, ACTION_ARM_R1) > 0) or g_ArrowSlot == 1 and env(ActionDuration, ACTION_ARM_R2) <= 0) then
            ExecEventAllBody("W_DrawStanceRightAttackLightCancel")
            return
        elseif ArrowStanceCommonFunction(ALLBODY, TRUE) == TRUE then
            return
        end
    end
    local r1 = "W_AttackRightLight1"
    local r2 = "W_AttackRightHeavy1Start"
    local b1 = "W_AttackBothLight1"
    local b2 = "W_AttackBothHeavy1Start"
    if env(GetEquipWeaponCategory, HAND_RIGHT) == WEAPON_CATEGORY_STRAIGHT_SWORD then
        r1 = "W_AttackRightLight2"
        r2 = "W_AttackRightHeavy2Start"
        b1 = "W_AttackBothLight2"
        b2 = "W_AttackBothHeavy2Start"
    end
    if ArtsCommonFunction(r1, r2, "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, b2, FALSE, FALSE, FALSE, TRUE, FALSE, ALLBODY) == TRUE then
        return
    elseif TRUE == env(GetEventEzStateFlag, 0) then
        local blend_type = ALLBODY
        if c_SwordArtsID ~= 105 and c_SwordArtsID ~= 108 and c_SwordArtsID ~= 169 and TRUE == MoveStart(LOWER, Event_Move, FALSE) then
            blend_type = UPPER
        end
        if env(ActionDuration, ACTION_ARM_L2) <= 0 then
            ExecEventHalfBlend(Event_DrawStanceRightEnd, blend_type)
        else
            ExecEventHalfBlend(Event_DrawStanceRightLoop, blend_type)
        end
    end
    if TRUE == env(IsAnimEnd, 0) then
        SetArtsGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
    end
end

function DrawStanceRightAttackLightCancel_onUpdate()
    if GetEquipType(c_SwordArtsHand, WEAPON_CATEGORY_SMALL_ARROW, WEAPON_CATEGORY_ARROW, WEAPON_CATEGORY_LARGE_ARROW) == TRUE then
        act(SetIsPreciseShootingPossible)
        if ArrowCommonFunction(ALLBODY, TRUE, TURN_TYPE_DEFAULT) == TRUE then
            return
        elseif ArrowStanceCommonFunction(ALLBODY, TRUE) == TRUE then
            return
        end
    end
    local r1 = "W_AttackRightLight1"
    local r2 = "W_AttackRightHeavy1Start"
    local b1 = "W_AttackBothLight1"
    local b2 = "W_AttackBothHeavy1Start"
    if ArtsCommonFunction(r1, r2, "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, b2, FALSE, FALSE, FALSE, TRUE, FALSE, ALLBODY) == TRUE then
        return
    elseif TRUE == env(GetEventEzStateFlag, 0) then
        local blend_type = ALLBODY
        if TRUE == MoveStart(LOWER, Event_Move, FALSE) then
            blend_type = UPPER
        end
        if env(ActionDuration, ACTION_ARM_L2) <= 0 then
            ExecEventHalfBlend(Event_DrawStanceRightEnd, blend_type)
        else
            ExecEventHalfBlend(Event_DrawStanceRightLoop, blend_type)
        end
    end
    if TRUE == env(IsAnimEnd, 0) then
        SetArtsGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
    end
end

function SwordArtsStanceAttackLightStart_onUpdate()
    local r1 = "W_AttackRightLight1"
    local r2 = "W_AttackRightHeavy1Start"
    local b1 = "W_AttackBothLight1"
    local b2 = "W_AttackBothHeavy1Start"
    if env(GetEquipWeaponCategory, HAND_RIGHT) == WEAPON_CATEGORY_STRAIGHT_SWORD then
        r1 = "W_AttackRightLight2"
        r2 = "W_AttackRightHeavy2Start"
        b1 = "W_AttackBothLight2"
        b2 = "W_AttackBothHeavy2Start"
    end
    if ArtsCommonFunction(r1, r2, "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, b2, FALSE, FALSE, FALSE, TRUE, FALSE, ALLBODY) == TRUE then
        return
    elseif env(IsAnimEnd, 0) == TRUE then
        SetArtsGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
    end
end

function SwordArtsStanceAttackLight180_onUpdate()
    local r1 = "W_AttackRightLight1"
    local r2 = "W_AttackBothRightHeavy1Start"
    local b1 = "W_AttackBothLight1"
    local b2 = "W_AttackBothHeavy1Start"
    if env(GetEquipWeaponCategory, HAND_RIGHT) == WEAPON_CATEGORY_STRAIGHT_SWORD then
        r1 = "W_AttackRightLight2"
        r2 = "W_AttackRightHeavy2Start"
        b1 = "W_AttackBothLight2"
        b2 = "W_AttackBothHeavy2Start"
    end
    if ArtsCommonFunction(r1, r2, "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, b2, FALSE, FALSE, FALSE, TRUE, FALSE, ALLBODY) == TRUE then
        return
    elseif env(IsAnimEnd, 0) == TRUE then
        SetArtsGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
    end
end

function DrawStanceRightAttackHeavy_onUpdate()
    local r1 = "W_AttackRightLight1"
    local b1 = "W_AttackBothLight1"
    local f429_local0 = nil
    local f429_local1 = nil
    if env(GetSpEffectID, 100250) == TRUE then
        f429_local0 = "W_DrawStanceRightAttackHeavy2"
        f429_local1 = "W_DrawStanceRightAttackHeavy2"
    else
        f429_local0 = "W_AttackRightHeavy1Start"
        f429_local1 = "W_AttackBothHeavy1Start"
    end
    if env(GetEquipWeaponCategory, HAND_RIGHT) == WEAPON_CATEGORY_STRAIGHT_SWORD then
        r1 = "W_AttackRightLight2"
        f429_local0 = "W_AttackRightHeavy2Start"
        b1 = "W_AttackBothLight2"
        f429_local1 = "W_AttackBothHeavy2Start"
    end
    if ArtsCommonFunction(r1, f429_local0, "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, f429_local1, FALSE, FALSE, FALSE, TRUE, FALSE, ALLBODY) == TRUE then
        return
    elseif env(IsAnimEnd, 0) == TRUE then
        SetArtsGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
    end
end

function DrawStanceRightAttackHeavy2_onUpdate()
    if ArtsCommonFunction(r1, r2, "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, b2, FALSE, FALSE, FALSE, TRUE, FALSE, ALLBODY) == TRUE then
    end
end

function SwordArtsStanceAttackHeavyStart_onUpdate()
    local r1 = "W_AttackRightLight1"
    local r2 = "W_AttackRightHeavy1Start"
    local b1 = "W_AttackBothLight1"
    local b2 = "W_AttackBothHeavy1Start"
    if env(GetEquipWeaponCategory, HAND_RIGHT) == WEAPON_CATEGORY_STRAIGHT_SWORD then
        r1 = "W_AttackRightLight2"
        r2 = "W_AttackRightHeavy2Start"
        b1 = "W_AttackBothLight2"
        b2 = "W_AttackBothHeavy2Start"
    end
    if ArtsCommonFunction(r1, r2, "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, b2, FALSE, FALSE, FALSE, TRUE, FALSE, ALLBODY) == TRUE then
        return
    elseif env(IsAnimEnd, 0) == TRUE then
        SetArtsGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
    end
end

function SwordArtsStanceAttackHeavy180_onUpdate()
    local r1 = "W_AttackRightLight1"
    local r2 = "W_AttackRightHeavy1Start"
    local b1 = "W_AttackBothLight1"
    local b2 = "W_AttackBothHeavy1Start"
    if env(GetEquipWeaponCategory, HAND_RIGHT) == WEAPON_CATEGORY_STRAIGHT_SWORD then
        r1 = "W_AttackRightLight2"
        r2 = "W_AttackRightHeavy2Start"
        b1 = "W_AttackBothLight2"
        b2 = "W_AttackBothHeavy2Start"
    end
    if ArtsCommonFunction(r1, r2, "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, b2, FALSE, FALSE, FALSE, TRUE, FALSE, ALLBODY) == TRUE then
        return
    elseif env(IsAnimEnd, 0) == TRUE then
        SetArtsGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
    end
end

function SwordArtsOneShot_onUpdate()
    local canThrow = FALSE
    if c_SwordArtsID == 130 or c_SwordArtsID == 55 then
        canThrow = TRUE
    end
    local r1 = "W_AttackRightLight1"
    local b1 = "W_AttackBothLight1"
    local r2 = "W_AttackRightHeavy1Start"
    local b2 = "W_AttackBothHeavy1Start"
    if TRUE == env(GetSpEffectID, 100054) then
        r1 = "W_SwordArtsOneShotComboEnd"
        b1 = "W_SwordArtsOneShotComboEnd"
    elseif TRUE == env(GetSpEffectID, 100055) then
        r1 = "W_SwordArtsOneShotComboEnd_2"
        b1 = "W_SwordArtsOneShotComboEnd_2"
    end
    if TRUE == env(GetSpEffectID, 100050) then
        r2 = "W_SwordArtsOneShotComboEnd"
        b2 = "W_SwordArtsOneShotComboEnd"
    elseif TRUE == env(GetSpEffectID, 100051) then
        r2 = "W_SwordArtsOneShotComboEnd_2"
        b2 = "W_SwordArtsOneShotComboEnd_2"
    end
    if c_SwordArtsID == 157 or c_SwordArtsID == 113 then
        r1 = "W_AttackRightLightStep"
        b1 = "W_AttackBothLightStep"
    end
    if c_SwordArtsID == 1 or c_SwordArtsID == 2 or c_SwordArtsID == 6 or c_SwordArtsID == 7 or c_SwordArtsID == 130 or c_SwordArtsID == 131 or c_SwordArtsID == 170 or c_SwordArtsID == 171 or c_SwordArtsID == 191 or c_SwordArtsID == 198 or c_SwordArtsID == 65 or c_SwordArtsID == 243 then
        r1 = "W_AttackRightLight2"
        b1 = "W_AttackBothLight2"
    end
    if (c_SwordArtsID == 115 or c_SwordArtsID == 116 or c_SwordArtsID == 193) and TRUE == env(GetSpEffectID, 100660) then
        if TRUE == env(IsTruelyLanding) then
            ExecEventAllBody("W_SwordArtsLoopEnd")
        else
            ExecEventAllBody("W_SwordArtsLoopLoop")
        end
    end
    if c_SwordArtsID == 229 then
        if TRUE == env(IsAnimEnd, 0) then
            ExecEventAllBody("W_SwordArtsLoopEnd")
        elseif TRUE == env(GetSpEffectID, 100670) and TRUE == env(IsTruelyLanding) then
            ExecEventAllBody("W_SwordArtsLoopEnd")
        end
    end
    if ArtsCommonFunction(r1, r2, "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, b2, FALSE, TRUE, TRUE, TRUE, canThrow, ALLBODY) == TRUE then
        return
    elseif env(ActionDuration, ACTION_ARM_L2) <= 0 then
        if TRUE == env(GetSpEffectID, 100285) then
            local idle_cat = env(GetStayAnimCategory)
            local wep_cat = env(GetEquipWeaponCategory, c_SwordArtsHand)
            local arts_diff_cat = GetSwordArtsDiffCategory(c_SwordArtsID, idle_cat, wep_cat)
            local arts_idx = 0
            if arts_diff_cat == WEAPON_CATEGORY_LARGE_SHIELD then
                arts_idx = 1
            elseif arts_diff_cat == WEAPON_CATEGORY_SMALL_SHIELD then
                arts_idx = 2
            end
            SetVariable("SwordArtsChargeCategory", arts_idx)
            ExecEventAllBody("W_SwordArtsChargeCancelEarly")
            return
        elseif TRUE == env(GetSpEffectID, 100286) then
            ExecEventAllBody("W_SwordArtsChargeCancelLate")
            return
        end
    end
    if TRUE == env(IsAnimEnd, 0) then
        local arts_category = c_SwordArtsID + 600
        local loop_animID = SWORDARTS_ANIM_ID_RIGHT_LOOP
        if env(DoesAnimExist, arts_category, loop_animID) == TRUE and (not (c_SwordArtsID == 201 or c_SwordArtsID == 202) or FALSE == GetVariable("IsEnoughArtPointsL2")) then
            if env(ActionDuration, ACTION_ARM_L2) > 0 then
                ExecEventAllBody("W_SwordArtsLoopLoop")
            else
                ExecEventAllBody("W_SwordArtsLoopEnd")
            end
            return
        end
        SetArtsGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
    end
end

function SwordArtsHalfOneShot_Upper_onUpdate()
    local canThrow = FALSE
    if c_SwordArtsID == 130 or c_SwordArtsID == 55 then
        canThrow = TRUE
    end
    local blend_type, lower_state = GetHalfBlendInfo()
    local r1 = "W_AttackRightLight1"
    local b1 = "W_AttackBothLight1"
    local r2 = "W_AttackRightHeavy1Start"
    local b2 = "W_AttackBothHeavy1Start"
    if TRUE == env(GetSpEffectID, 100054) then
        r1 = "W_SwordArtsOneShotComboEnd"
        b1 = "W_SwordArtsOneShotComboEnd"
    elseif TRUE == env(GetSpEffectID, 100055) then
        r1 = "W_SwordArtsOneShotComboEnd_2"
        b1 = "W_SwordArtsOneShotComboEnd_2"
    end
    if TRUE == env(GetSpEffectID, 100050) then
        r2 = "W_SwordArtsOneShotComboEnd"
        b2 = "W_SwordArtsOneShotComboEnd"
    elseif TRUE == env(GetSpEffectID, 100051) then
        r2 = "W_SwordArtsOneShotComboEnd_2"
        b2 = "W_SwordArtsOneShotComboEnd_2"
    end
    if ArtsCommonFunction(r1, r2, "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, b2, FALSE, TRUE, TRUE, TRUE, canThrow, blend_type) == TRUE then
        return
    elseif env(ActionDuration, ACTION_ARM_L2) <= 0 then
        if TRUE == env(GetSpEffectID, 100285) then
            ExecEventAllBody("W_SwordArtsChargeCancelEarly")
            return
        elseif TRUE == env(GetSpEffectID, 100286) then
            ExecEventAllBody("W_SwordArtsChargeCancelLate")
            return
        end
    end
    if c_SwordArtsID == 206 and env(ActionDuration, ACTION_ARM_L2) <= 0 and FALSE == env(GetSpEffectID, 100700) then
        ExecEventHalfBlend(Event_SwordArtsHalfLoopEnd, blend_type)
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        local arts_category = c_SwordArtsID + 600
        local loop_animID = SWORDARTS_ANIM_ID_RIGHT_LOOP
        if env(DoesAnimExist, arts_category, loop_animID) == TRUE and (not (c_SwordArtsID == 201 or c_SwordArtsID == 202) or FALSE == GetVariable("IsEnoughArtPointsL2")) then
            if env(ActionDuration, ACTION_ARM_L2) > 0 then
                ExecEventHalfBlend(Event_SwordArtsHalfLoopLoop, blend_type)
            else
                ExecEventHalfBlend(Event_SwordArtsHalfLoopEnd, blend_type)
            end
            return
        else
            SetArtsGeneratorTransitionIndex()
            ExecEventAllBody("W_Idle")
            return
        end
    elseif lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_DEFAULT)
    end
    if lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_SwordArtsHalfOneShot, lower_state, FALSE) == TRUE then
    end
end

function SwordArtsOneShotComboEnd_onUpdate()
    local r1 = "W_AttackRightLight1"
    local b1 = "W_AttackBothLight1"
    local r2 = "W_AttackRightHeavy1Start"
    local b2 = "W_AttackBothHeavy1Start"
    if env(GetSpEffectID, 100054) == TRUE then
        r1 = "W_SwordArtsOneShotComboEnd"
        b1 = "W_SwordArtsOneShotComboEnd"
    elseif env(GetSpEffectID, 100055) == TRUE then
        r1 = "W_SwordArtsOneShotComboEnd_2"
        b1 = "W_SwordArtsOneShotComboEnd_2"
    end
    if env(GetSpEffectID, 100050) == TRUE then
        r2 = "W_SwordArtsOneShotComboEnd"
        b2 = "W_SwordArtsOneShotComboEnd"
    elseif env(GetSpEffectID, 100051) == TRUE then
        r2 = "W_SwordArtsOneShotComboEnd_2"
        b2 = "W_SwordArtsOneShotComboEnd_2"
    end
    if c_SwordArtsID == 113 then
        r1 = "W_AttackRightLightStep"
        b1 = "W_AttackBothLightStep"
    end
    if env(ActionDuration, ACTION_ARM_L2) <= 0 then
        if env(GetSpEffectID, 100285) == TRUE then
            ExecEventAllBody("W_SwordArtsChargeCancelEarly2")
            return
        elseif env(GetSpEffectID, 100286) == TRUE then
            ExecEventAllBody("W_SwordArtsChargeCancelEarly2")
            return
        end
    end
    if ArtsCommonFunction(r1, r2, "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, b2, FALSE, TRUE, TRUE, TRUE, FALSE, ALLBODY) == TRUE then
        return
    elseif env(IsAnimEnd, 0) == TRUE then
        SetArtsGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
    end
end

function SwordArtsHalfOneShotComboEnd_Upper_onUpdate()
    local canThrow = FALSE
    if c_SwordArtsID == 130 or c_SwordArtsID == 55 then
        canThrow = TRUE
    end
    local blend_type, lower_state = GetHalfBlendInfo()
    local r1 = "W_AttackRightLight1"
    local b1 = "W_AttackBothLight1"
    local r2 = "W_AttackRightHeavy1Start"
    local b2 = "W_AttackBothHeavy1Start"
    if TRUE == env(GetSpEffectID, 100054) then
        r1 = "W_SwordArtsOneShotComboEnd"
        b1 = "W_SwordArtsOneShotComboEnd"
    elseif TRUE == env(GetSpEffectID, 100055) then
        r1 = "W_SwordArtsOneShotComboEnd_2"
        b1 = "W_SwordArtsOneShotComboEnd_2"
    end
    if TRUE == env(GetSpEffectID, 100050) then
        r2 = "W_SwordArtsOneShotComboEnd"
        b2 = "W_SwordArtsOneShotComboEnd"
    elseif TRUE == env(GetSpEffectID, 100051) then
        r2 = "W_SwordArtsOneShotComboEnd_2"
        b2 = "W_SwordArtsOneShotComboEnd_2"
    end
    if ArtsCommonFunction(r1, r2, "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, b2, FALSE, TRUE, TRUE, TRUE, canThrow, blend_type) == TRUE then
        return
    elseif env(ActionDuration, ACTION_ARM_L2) <= 0 then
        if TRUE == env(GetSpEffectID, 100285) then
            ExecEventAllBody("W_SwordArtsChargeCancelEarly2")
            return
        elseif TRUE == env(GetSpEffectID, 100286) then
            ExecEventAllBody("W_SwordArtsChargeCancelEarly2")
            return
        end
    end
    if TRUE == env(IsAnimEnd, 1) then
        SetArtsGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
        return
    elseif lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_DEFAULT)
    end
    if lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_SwordArtsHalfOneShotCombo1, lower_state, FALSE) == TRUE then
    end
end

function SwordArtsOneShotComboEnd_2_onUpdate()
    local r1 = "W_AttackRightLight1"
    local b1 = "W_AttackBothLight1"
    local r2 = "W_AttackRightHeavy1Start"
    local b2 = "W_AttackBothHeavy1Start"
    if env(GetSpEffectID, 100054) == TRUE then
        r1 = "W_SwordArtsOneShotComboEnd"
        b1 = "W_SwordArtsOneShotComboEnd"
    elseif env(GetSpEffectID, 100055) == TRUE then
        r1 = "W_SwordArtsOneShotComboEnd_2"
        b1 = "W_SwordArtsOneShotComboEnd_2"
    end
    if env(GetSpEffectID, 100050) == TRUE then
        r2 = "W_SwordArtsOneShotComboEnd"
        b2 = "W_SwordArtsOneShotComboEnd"
    elseif env(GetSpEffectID, 100051) == TRUE then
        r2 = "W_SwordArtsOneShotComboEnd_2"
        b2 = "W_SwordArtsOneShotComboEnd_2"
    end
    if ArtsCommonFunction(r1, r2, "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, b2, FALSE, TRUE, TRUE, TRUE, FALSE, ALLBODY) == TRUE then
        return
    elseif env(IsAnimEnd, 0) == TRUE then
        SetArtsGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
    end
end

function SwordArtsHalfOneShotComboEnd_2_Upper_onUpdate()
    local canThrow = FALSE
    if c_SwordArtsID == 130 or c_SwordArtsID == 55 then
        canThrow = TRUE
    end
    local blend_type, lower_state = GetHalfBlendInfo()
    local r1 = "W_AttackRightLight1"
    local b1 = "W_AttackBothLight1"
    local r2 = "W_AttackRightHeavy1Start"
    local b2 = "W_AttackBothHeavy1Start"
    if TRUE == env(GetSpEffectID, 100054) then
        r1 = "W_SwordArtsOneShotComboEnd"
        b1 = "W_SwordArtsOneShotComboEnd"
    elseif TRUE == env(GetSpEffectID, 100055) then
        r1 = "W_SwordArtsOneShotComboEnd_2"
        b1 = "W_SwordArtsOneShotComboEnd_2"
    end
    if TRUE == env(GetSpEffectID, 100050) then
        r2 = "W_SwordArtsOneShotComboEnd"
        b2 = "W_SwordArtsOneShotComboEnd"
    elseif TRUE == env(GetSpEffectID, 100051) then
        r2 = "W_SwordArtsOneShotComboEnd_2"
        b2 = "W_SwordArtsOneShotComboEnd_2"
    end
    if ArtsCommonFunction(r1, r2, "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, b2, FALSE, TRUE, TRUE, TRUE, canThrow, blend_type) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        SetArtsGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
        return
    elseif lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_DEFAULT)
    end
    if lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_SwordArtsHalfOneShotCombo2, lower_state, FALSE) == TRUE then
    end
end

function SwordArtsOneShotShieldLeft_onUpdate()
    local index = SWORDARTS_PARRY + GetVariable("SwordArtsOneShotShieldIndex")
    local canThrow = FALSE
    if index == SWORDARTS_PARRY or index == SWORDARTS_SPELL_PARRY or index == SWORDARTS_PROJECTILE_PARRY or index == SWORDARTS_BUCKLER_PARRY or index == SWORDARTS_DAGGER_PARRY then
        canThrow = TRUE
    end
    if env(ActionDuration, ACTION_ARM_L2) <= 0 then
        local idle_cat = env(GetStayAnimCategory)
        local wep_cat = env(GetEquipWeaponCategory, c_SwordArtsHand)
        local arts_diff_cat = GetSwordArtsDiffCategory(c_SwordArtsID, idle_cat, wep_cat)
        local arts_idx = 0
        if arts_diff_cat == WEAPON_CATEGORY_LARGE_SHIELD then
            arts_idx = 1
        elseif arts_diff_cat == WEAPON_CATEGORY_SMALL_SHIELD then
            arts_idx = 2
        end
        SetVariable("SwordArtsOneShotShieldCancelCategory", arts_idx)
        if TRUE == env(GetSpEffectID, 100285) then
            ExecEventAllBody("W_SwordArtsOneShotShieldLeft_Cancel")
        elseif TRUE == env(GetSpEffectID, 100286) then
            ExecEventAllBody("W_SwordArtsOneShotShieldLeft_Cancel")
        end
    end
    if ArtsCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, TRUE, TRUE, canThrow, ALLBODY) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 0) then
        local arts_category = c_SwordArtsID + 600
        local loop_animID = SWORDARTS_ANIM_ID_RIGHT_LOOP
        if env(DoesAnimExist, arts_category, loop_animID) == TRUE and (not (c_SwordArtsID == 201 or c_SwordArtsID == 202) or GetVariable("IsEnoughArtPointsL2") == FALSE) then
            if env(ActionDuration, ACTION_ARM_L2) > 0 then
                ExecEventAllBody("W_SwordArtsLeftLoopLoop")
            else
                ExecEventAllBody("W_SwordArtsLeftLoopEnd")
            end
            return
        end
        SetArtsGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
    end
end

function SwordArtsHalfOneShotShieldLeft_Upper_onUpdate()
    local index = SWORDARTS_PARRY + GetVariable("SwordArtsOneShotShieldIndex")
    local canThrow = FALSE
    if index == SWORDARTS_PARRY or index == SWORDARTS_SPELL_PARRY or index == SWORDARTS_PROJECTILE_PARRY or index == SWORDARTS_BUCKLER_PARRY or index == SWORDARTS_DAGGER_PARRY then
        canThrow = TRUE
    end
    local blend_type, lower_state = GetHalfBlendInfo()
    local idle_cat = env(GetStayAnimCategory)
    local wep_cat = env(GetEquipWeaponCategory, c_SwordArtsHand)
    local arts_diff_cat = GetSwordArtsDiffCategory(c_SwordArtsID, idle_cat, wep_cat)
    local arts_idx = 0
    if arts_diff_cat == WEAPON_CATEGORY_LARGE_SHIELD then
        arts_idx = 1
    elseif arts_diff_cat == WEAPON_CATEGORY_SMALL_SHIELD then
        arts_idx = 2
    end
    SetVariable("SwordArtsOneShotShieldCancelCategory", arts_idx)
    if 0 >= env(ActionDuration, ACTION_ARM_L2) then
        if TRUE == env(GetSpEffectID, 100285) then
            ExecEventAllBody("W_SwordArtsOneShotShieldLeft_Cancel")
        elseif TRUE == env(GetSpEffectID, 100286) then
            ExecEventAllBody("W_SwordArtsOneShotShieldLeft_Cancel")
        end
    end
    if ArtsCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, TRUE, FALSE, canThrow, ALLBODY) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        local arts_category = c_SwordArtsID + 600
        local loop_animID = SWORDARTS_ANIM_ID_RIGHT_LOOP
        if env(DoesAnimExist, arts_category, loop_animID) == TRUE and (not (c_SwordArtsID == 201 or c_SwordArtsID == 202) or GetVariable("IsEnoughArtPointsL2") == FALSE) then
            if 0 < env(ActionDuration, ACTION_ARM_L2) then
                ExecEventHalfBlend(Event_SwordArtsHalfLeftLoopLoop, blend_type)
            else
                ExecEventHalfBlend(Event_SwordArtsHalfLeftLoopEnd, blend_type)
            end
            return
        else
            SetArtsGeneratorTransitionIndex()
            ExecEventAllBody("W_Idle")
            return
        end
    elseif lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_DEFAULT)
    end
    if lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_SwordArtsHalfOneShotShieldLeft, lower_state, FALSE) == TRUE then
    end
end

function SwordArtsOneShotShieldLeft_Cancel_onUpdate()
    local index = SWORDARTS_PARRY + GetVariable("SwordArtsOneShotShieldIndex")
    local canThrow = FALSE
    if index == SWORDARTS_PARRY or index == SWORDARTS_SPELL_PARRY or index == SWORDARTS_PROJECTILE_PARRY or index == SWORDARTS_BUCKLER_PARRY or index == SWORDARTS_DAGGER_PARRY then
        canThrow = TRUE
    end
    if ArtsCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, TRUE, FALSE, canThrow, ALLBODY) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 0) then
        SetArtsGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
    end
end

function SwordArtsOneShotShieldBoth_onUpdate()
    local index = SWORDARTS_PARRY + GetVariable("SwordArtsOneShotShieldIndex")
    local canThrow = FALSE
    if index == SWORDARTS_PARRY or index == SWORDARTS_SPELL_PARRY or index == SWORDARTS_PROJECTILE_PARRY or index == SWORDARTS_BUCKLER_PARRY or index == SWORDARTS_DAGGER_PARRY then
        canThrow = TRUE
    end
    if env(ActionDuration, ACTION_ARM_L2) <= 0 then
        local idle_cat = env(GetStayAnimCategory)
        local wep_cat = env(GetEquipWeaponCategory, c_SwordArtsHand)
        local arts_diff_cat = GetSwordArtsDiffCategory(c_SwordArtsID, idle_cat, wep_cat)
        local arts_idx = 0
        if arts_diff_cat == WEAPON_CATEGORY_LARGE_SHIELD then
            arts_idx = 1
        elseif arts_diff_cat == WEAPON_CATEGORY_SMALL_SHIELD then
            arts_idx = 2
        end
        SetVariable("SwordArtsOneShotShieldCancelCategory", arts_idx)
        if TRUE == env(GetSpEffectID, 100285) then
            ExecEventAllBody("W_SwordArtsOneShotShieldBoth_Cancel")
        elseif TRUE == env(GetSpEffectID, 100286) then
            ExecEventAllBody("W_SwordArtsOneShotShieldBoth_Cancel")
        end
    end
    if ArtsCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, TRUE, TRUE, canThrow, ALLBODY) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 0) then
        local arts_category = c_SwordArtsID + 600
        local loop_animID = SWORDARTS_ANIM_ID_RIGHT_LOOP
        if env(DoesAnimExist, arts_category, loop_animID) == TRUE and (not (c_SwordArtsID == 201 or c_SwordArtsID == 202) or GetVariable("IsEnoughArtPointsL2") == FALSE) then
            if env(ActionDuration, ACTION_ARM_L2) > 0 then
                ExecEventAllBody("W_SwordArtsBothLoopLoop")
            else
                ExecEventAllBody("W_SwordArtsBothLoopEnd")
            end
            return
        end
        SetArtsGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
    end
end

function SwordArtsOneShotShieldBoth_Cancel_onUpdate()
    local index = SWORDARTS_PARRY + GetVariable("SwordArtsOneShotShieldIndex")
    local canThrow = FALSE
    if index == SWORDARTS_PARRY or index == SWORDARTS_SPELL_PARRY or index == SWORDARTS_PROJECTILE_PARRY or index == SWORDARTS_BUCKLER_PARRY or index == SWORDARTS_DAGGER_PARRY then
        canThrow = TRUE
    end
    if ArtsCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, TRUE, FALSE, canThrow, ALLBODY) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 0) then
        SetArtsGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
    end
end

function SwordArtsRolling_onUpdate()
    SetEnableAimMode()
    local r1 = "W_AttackRightLightStep"
    local b1 = "W_AttackBothLightStep"
    if GetVariable("SwordArtsRollingDirection") ~= 0 then
        r1 = "W_AttackRightBackstep"
        b1 = "W_AttackBothBackstep"
    end
    if EvasionCommonFunction(FALL_TYPE_DEFAULT, r1, "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, "W_AttackBothHeavy1Start", QUICKTYPE_ROLLING) == TRUE then
        return
    elseif env(IsAnimEnd, 0) == TRUE then
        SetArtsGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
    end
end

function SwordArtsRolling_SelfTrans_onUpdate()
    SetEnableAimMode()
    local r1 = "W_AttackRightLightStep"
    local b1 = "W_AttackBothLightStep"
    if GetVariable("SwordArtsRollingDirection") ~= 0 then
        r1 = "W_AttackRightBackstep"
        b1 = "W_AttackBothBackstep"
    end
    if EvasionCommonFunction(FALL_TYPE_DEFAULT, r1, "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, "W_AttackBothHeavy1Start", QUICKTYPE_ROLLING) == TRUE then
        return
    elseif env(IsAnimEnd, 0) == TRUE then
        SetArtsGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
    end
end

function SwordArtsRolling_SelfTrans2_onUpdate()
    SetEnableAimMode()
    local r1 = "W_AttackRightLightStep"
    local b1 = "W_AttackBothLightStep"
    if GetVariable("SwordArtsRollingDirection") ~= 0 then
        r1 = "W_AttackRightBackstep"
        b1 = "W_AttackBothBackstep"
    end
    if EvasionCommonFunction(FALL_TYPE_DEFAULT, r1, "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, "W_AttackBothHeavy1Start", QUICKTYPE_ROLLING) == TRUE then
        return
    elseif env(IsAnimEnd, 0) == TRUE then
        SetArtsGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
    end
end

function SwordArtsLoopLoop_onUpdate()
    if c_SwordArtsID == 115 or c_SwordArtsID == 116 or c_SwordArtsID == 193 then
        local height = env(GetFallHeight) / 100
        local damage_type = env(GetReceivedDamageType)
        if damage_type == DAMAGE_TYPE_DEATH_FALLING then
            ExecEventAllBody("W_FallDeath")
            return TRUE
        elseif height >= 60 then
            if env(GetStateChangeType, 266) == TRUE then
            else
                ExecEventAllBody("W_FallDeath")
                return TRUE
            end
        end
        if env(GetSpEffectID, 100670) == TRUE and env(IsTruelyLanding) == TRUE then
            ExecEventAllBody("W_SwordArtsLoopEnd")
        end
    elseif c_SwordArtsID == 13 then
        SetSwordArtsPointInfo(ACTION_ARM_R2, TRUE)
        if env(ActionDuration, ACTION_ARM_L2) <= 0 or env(GetStamina) <= 0 or env(HasEnoughArtsPoints, ACTION_ARM_R2, c_SwordArtsHand) == FALSE then
            ExecEventAllBody("W_SwordArtsLoopEnd")
            return
        end
    elseif env(ActionDuration, ACTION_ARM_L2) <= 0 or env(GetStamina) <= 0 or 0 == GetVariable("IsEnoughArtPointsL2") and env(HasEnoughArtsPoints, ACTION_ARM_L2, c_SwordArtsHand) == FALSE then
        ExecEventAllBody("W_SwordArtsLoopEnd")
        return
    end
    if ArtsCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, TRUE, TRUE, FALSE, ALLBODY) == TRUE then
    end
end

function SwordArtsHalfLoopLoop_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ArtsCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, TRUE, TRUE, canThrow, blend_type) == TRUE then
        return
    elseif FALSE == env(GetSpEffectID, 100700) and (env(ActionDuration, ACTION_ARM_L2) <= 0 or env(GetStamina) <= 0 or 0 == GetVariable("IsEnoughArtPointsL2") and FALSE == env(HasEnoughArtsPoints, ACTION_ARM_L2, c_SwordArtsHand)) then
        ExecEventHalfBlend(Event_SwordArtsHalfLoopEnd, blend_type)
        return
    elseif lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_DEFAULT)
    end
    if lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_SwordArtsHalfLoopLoop, lower_state, FALSE) == TRUE then
    end
end

function SwordArtsLoopEnd_onUpdate()
    if ArtsCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, TRUE, TRUE, FALSE, ALLBODY) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 0) then
        SetArtsGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
    end
end

function SwordArtsHalfLoopEnd_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ArtsCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, TRUE, TRUE, canThrow, blend_type) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        SetArtsGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
        return
    elseif lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_DEFAULT)
    end
    if lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_SwordArtsHalfLoopEnd, lower_state, FALSE) == TRUE then
    end
end

function SwordArtsBothLoopLoop_onUpdate()
    if env(ActionDuration, ACTION_ARM_L2) <= 0 then
        ExecEventAllBody("W_SwordArtsBothLoopEnd")
        return
    elseif ArtsCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, TRUE, FALSE, canThrow, ALLBODY) == TRUE then
    end
end

function SwordArtsBothLoopEnd_onUpdate()
    if ArtsCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, TRUE, TRUE, FALSE, ALLBODY) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 0) then
        SetArtsGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
    end
end

function SwordArtsLeftLoopLoop_onUpdate()
    if env(ActionDuration, ACTION_ARM_L2) <= 0 then
        ExecEventAllBody("W_SwordArtsLeftLoopEnd")
        return
    elseif ArtsCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, TRUE, FALSE, canThrow, ALLBODY) == TRUE then
    end
end

function SwordArtsHalfLeftLoopLoop_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    SetSwordArtsPointInfo(ACTION_ARM_L2, TRUE)
    if ArtsCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, TRUE, FALSE, canThrow, ALLBODY) == TRUE then
        return
    elseif env(ActionDuration, ACTION_ARM_L2) <= 0 or env(ActionCancelRequest, ACTION_ARM_L2) == TRUE or env(GetStamina) <= 0 or GetVariable("IsEnoughArtPointsL2") == 1 then
        ExecEventHalfBlend(Event_SwordArtsHalfLeftLoopEnd, blend_type)
        return
    elseif lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_DEFAULT)
    end
    if lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_SwordArtsHalfLeftLoopLoop, lower_state, FALSE) == TRUE then
    end
end

function SwordArtsLeftLoopEnd_onUpdate()
    if ArtsCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, TRUE, FALSE, FALSE, ALLBODY) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 0) then
        SetArtsGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
    end
end

function SwordArtsHalfLeftLoopEnd_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ArtsCommonFunction("W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", FALSE, TRUE, TRUE, TRUE, canThrow, blend_type) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        SetArtsGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
        return
    elseif lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_DEFAULT)
    end
    if lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_SwordArtsHalfLeftLoopEnd, lower_state, FALSE) == TRUE then
    end
end

function SwordArtsChargeCancelEarly_onUpdate()
    if env(IsAnimEnd, 0) == TRUE then
        SetArtsGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
        return
    end
    local r1 = "W_AttackRightLight1"
    local b1 = "W_AttackBothLight1"
    local r2 = "W_AttackRightHeavy1Start"
    local b2 = "W_AttackBothHeavy1Start"
    if c_SwordArtsID == 198 then
        r1 = "W_AttackRightLight2"
        b1 = "W_AttackBothLight2"
    end
    if env(GetSpEffectID, 100054) == TRUE then
        r1 = "W_SwordArtsOneShotComboEnd"
        b1 = "W_SwordArtsOneShotComboEnd"
    elseif env(GetSpEffectID, 100055) == TRUE then
        r1 = "W_SwordArtsOneShotComboEnd_2"
        b1 = "W_SwordArtsOneShotComboEnd_2"
    end
    if env(GetSpEffectID, 100050) == TRUE then
        r2 = "W_SwordArtsOneShotComboEnd"
        b2 = "W_SwordArtsOneShotComboEnd"
    elseif env(GetSpEffectID, 100051) == TRUE then
        r2 = "W_SwordArtsOneShotComboEnd_2"
        b2 = "W_SwordArtsOneShotComboEnd_2"
    end
    if ArtsCommonFunction(r1, r2, "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, b2, FALSE, TRUE, TRUE, TRUE, FALSE, ALLBODY) == TRUE then
    end
end

function SwordArtsChargeCancelLate_onUpdate()
    if env(IsAnimEnd, 0) == TRUE then
        SetArtsGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
        return
    end
    local r1 = "W_AttackRightLight1"
    local b1 = "W_AttackBothLight1"
    local r2 = "W_AttackRightHeavy1Start"
    local b2 = "W_AttackBothHeavy1Start"
    if env(GetSpEffectID, 100054) == TRUE then
        r1 = "W_SwordArtsOneShotComboEnd"
        b1 = "W_SwordArtsOneShotComboEnd"
    elseif env(GetSpEffectID, 100055) == TRUE then
        r1 = "W_SwordArtsOneShotComboEnd_2"
        b1 = "W_SwordArtsOneShotComboEnd_2"
    end
    if env(GetSpEffectID, 100050) == TRUE then
        r2 = "W_SwordArtsOneShotComboEnd"
        b2 = "W_SwordArtsOneShotComboEnd"
    elseif env(GetSpEffectID, 100051) == TRUE then
        r2 = "W_SwordArtsOneShotComboEnd_2"
        b2 = "W_SwordArtsOneShotComboEnd_2"
    end
    if ArtsCommonFunction(r1, r2, "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, b2, FALSE, TRUE, TRUE, TRUE, FALSE, ALLBODY) == TRUE then
    end
end

function SwordArtsChargeCancelEarly2_onUpdate()
    if env(IsAnimEnd, 0) == TRUE then
        SetArtsGeneratorTransitionIndex()
        ExecEventAllBody("W_Idle")
        return
    end
    local r1 = "W_AttackRightLight1"
    local b1 = "W_AttackBothLight1"
    local r2 = "W_AttackRightHeavy1Start"
    local b2 = "W_AttackBothHeavy1Start"
    if env(GetSpEffectID, 100054) == TRUE then
        r1 = "W_SwordArtsOneShotComboEnd"
        b1 = "W_SwordArtsOneShotComboEnd"
    elseif env(GetSpEffectID, 100055) == TRUE then
        r1 = "W_SwordArtsOneShotComboEnd_2"
        b1 = "W_SwordArtsOneShotComboEnd_2"
    end
    if env(GetSpEffectID, 100050) == TRUE then
        r2 = "W_SwordArtsOneShotComboEnd"
        b2 = "W_SwordArtsOneShotComboEnd"
    elseif env(GetSpEffectID, 100051) == TRUE then
        r2 = "W_SwordArtsOneShotComboEnd_2"
        b2 = "W_SwordArtsOneShotComboEnd_2"
    end
    if ArtsCommonFunction(r1, r2, "W_AttackLeftLight1", "W_AttackLeftHeavy1", b1, b2, FALSE, TRUE, TRUE, TRUE, FALSE, ALLBODY) == TRUE then
    end
end

function SwordArtsStandDodge_onUpdate()
    if ExecDamage(FALSE, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecFallAttack() then
        return
    elseif TRUE == env(IsFalling) or TRUE == env(IsAnimEnd, 0) then
        ExecEventAllBody("W_FallLoop")
    end
end

function SwordArtsLeft_Activate()
    SetAttackHand(HAND_LEFT)
    SetGuardHand(HAND_LEFT)
end

function SwordArtsArrowStanceStart_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    act(SetIsPreciseShootingPossible)
    if ArrowCommonFunction(blend_type, FALSE, TURN_TYPE_STANCE) == TRUE then
        return
    elseif ArrowStanceCommonFunction(blend_type, FALSE) == TRUE then
        return
    elseif TRUE == env(GetEventEzStateFlag, 0) and (env(ActionDuration, ACTION_ARM_L2) <= 0 or TRUE == env(ActionCancelRequest, ACTION_ARM_L2)) then
        ExecEventHalfBlend(Event_SwordArtsArrowStanceEnd, blend_type)
        if lower_state == LOWER_MOVE then
            ExecEventHalfBlendNoReset(Event_Move, LOWER)
        end
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventHalfBlend(Event_SwordArtsArrowStanceLoop, blend_type)
        return
    elseif HalfBlendLowerCommonFunction(Event_SwordArtsArrowStanceStartMirror, lower_state, FALSE) == TRUE then
    end
end

function SetSwordArtsWepCategory_DrawStanceRightAttackLight()
    local idle_cat = env(GetStayAnimCategory)
    local wep_cat = env(GetEquipWeaponCategory, c_SwordArtsHand)
    local arts_idx = 0
    if GetSwordArtsDiffCategory(c_SwordArtsID, idle_cat, wep_cat) == WEAPON_CATEGORY_LARGE_ARROW then
        arts_idx = 1
    end
    SetVariable("DrawStanceRightAttackLightCategory", arts_idx)
end

function ArrowStanceCommonFunction(blend_type, checkHold)
    local request = GetAttackRequest(FALSE)
    local arrowHand = HAND_RIGHT
    if c_Style == HAND_LEFT_BOTH then
        arrowHand = HAND_LEFT
    end
    if (request == ATTACK_REQUEST_ARROW_FIRE_LEFT or request == ATTACK_REQUEST_ARROW_FIRE_RIGHT) and (checkHold == FALSE or env(ActionDuration, ACTION_ARM_L2) > 0) then
        g_ArrowSlot = 0
        act(ChooseBowAndArrowSlot, 0)
        if env(IsOutOfAmmo, arrowHand) == TRUE then
            ExecEventAllBody("W_NoArrow")
            return TRUE
        elseif env(GetStamina) > 0 then
            SetSwordArtsPointInfo(ACTION_ARM_R1, TRUE)
            SetSwordArtsWepCategory_DrawStanceRightAttackLight()
            ExecEventAllBody("W_DrawStanceRightAttackLight")
            return TRUE
        end
    elseif (request == ATTACK_REQUEST_ARROW_FIRE_LEFT2 or request == ATTACK_REQUEST_ARROW_FIRE_RIGHT2) and (checkHold == FALSE or env(ActionDuration, ACTION_ARM_L2) > 0) then
        act(ResetInputQueue)
        g_ArrowSlot = 1
        act(ChooseBowAndArrowSlot, 1)
        if env(IsOutOfAmmo, arrowHand) == TRUE then
            ExecEventAllBody("W_NoArrow")
            return TRUE
        elseif env(GetStamina) > 0 then
            SetSwordArtsPointInfo(ACTION_ARM_R1, TRUE)
            SetSwordArtsWepCategory_DrawStanceRightAttackLight()
            ExecEventAllBody("W_DrawStanceRightAttackLight")
            return TRUE
        end
    end
    return FALSE
end

function SwordArtsArrowStanceLoop_Upper_onUpdate()
    act(SetIsPreciseShootingPossible)
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if ArrowCommonFunction(blend_type, FALSE, TURN_TYPE_STANCE) == TRUE then
        return
    elseif ArrowStanceCommonFunction(blend_type, FALSE) == TRUE then
        return
    elseif env(ActionDuration, ACTION_ARM_L2) <= 0 or TRUE == env(ActionCancelRequest, ACTION_ARM_L2) then
        ExecEventHalfBlend(Event_SwordArtsArrowStanceEnd, blend_type)
        return
    elseif HalfBlendLowerCommonFunction(Event_SwordArtsArrowStanceLoop, lower_state, FALSE) == TRUE then
    end
end

function SwordArtsArrowDrawStart_Upper_onUpdate()
    act(SetIsPreciseShootingPossible)
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if ArrowCommonFunction(blend_type, FALSE, TURN_TYPE_STANCE) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventHalfBlend(Event_SwordArtsArrowDrawLoop, blend_type)
        return
    elseif HalfBlendLowerCommonFunction(Event_SwordArtsArrowStanceStartMirror, lower_state, FALSE) == TRUE then
    end
end

function SwordArtsArrowDrawLoop_Upper_onUpdate()
    act(SetIsPreciseShootingPossible)
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if ArrowCommonFunction(blend_type, FALSE, TURN_TYPE_STANCE) == TRUE then
        return
    elseif not (g_ArrowSlot ~= 0 or 0 < env(ActionDuration, ACTION_ARM_R1)) or g_ArrowSlot == 1 and 0 >= env(ActionDuration, ACTION_ARM_R2) then
        SetSwordArtsPointInfo(ACTION_ARM_R1, TRUE)
        ExecEventAllBody("W_SwordArtsArrowFire")
        return
    elseif HalfBlendLowerCommonFunction(Event_SwordArtsArrowStanceLoop, lower_state, FALSE) == TRUE then
    end
end

function SwordArtsArrowFire_onUpdate()
    act(SetIsPreciseShootingPossible)
    if ArrowCommonFunction(ALLBODY, TRUE, TURN_TYPE_DEFAULT) == TRUE then
        return
    elseif TRUE == env(GetSpEffectID, 100280) and (not (g_ArrowSlot ~= 0 or env(ActionDuration, ACTION_ARM_R1) > 0) or g_ArrowSlot == 1 and env(ActionDuration, ACTION_ARM_R2) <= 0) then
        ExecEventAllBody("W_SwordArtsArrowFireEnd")
        return
    elseif ArrowStanceCommonFunction(ALLBODY, TRUE) == TRUE then
        return
    elseif TRUE == env(GetEventEzStateFlag, 0) or TRUE == env(IsAnimEnd, 0) then
        if env(ActionDuration, ACTION_ARM_L2) > 0 then
            ExecEventHalfBlendNoReset(Event_SwordArtsArrowStanceLoop, ALLBODY)
            return
        end
        ExecEventHalfBlend(Event_SwordArtsArrowStanceEnd, ALLBODY)
    end
end

function SwordArtsArrowFireEnd_onUpdate()
    act(SetIsPreciseShootingPossible)
    if ArrowCommonFunction(ALLBODY, TRUE, TURN_TYPE_DEFAULT) == TRUE then
        return
    elseif ArrowStanceCommonFunction(ALLBODY, TRUE) == TRUE then
        return
    elseif TRUE == env(GetEventEzStateFlag, 0) or TRUE == env(IsAnimEnd, 0) then
        if env(ActionDuration, ACTION_ARM_L2) > 0 then
            ExecEventHalfBlendNoReset(Event_SwordArtsArrowStanceLoop, ALLBODY)
            return
        end
        ExecEventHalfBlend(Event_SwordArtsArrowStanceEnd, ALLBODY)
    end
end

function SwordArtsArrowStanceEnd_Upper_onUpdate()
    act(SetIsPreciseShootingPossible)
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_DEFAULT)
    end
    if ArrowCommonFunction(blend_type, FALSE, TURN_TYPE_DEFAULT) == TRUE then
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_SwordArtsArrowStanceEnd, lower_state, TRUE) == TRUE then
    end
end

function WeaponChangeStart_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if WeaponChangeCommonFunction(blend_type) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventHalfBlendNoReset(Event_WeaponChangeEnd, blend_type)
        return
    elseif HalfBlendLowerCommonFunction(Event_WeaponChangeStartMirror, lower_state, FALSE) == TRUE then
    end
end

function StealthWeaponChangeStart_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if WeaponChangeCommonFunction(blend_type) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventHalfBlendNoReset(Event_StealthWeaponChangeEnd, blend_type)
        return
    elseif HalfBlendLowerCommonFunction(Event_StealthWeaponChangeStart, lower_state, FALSE) == TRUE then
    end
end

function WeaponChangeEnd_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if WeaponChangeCommonFunction(blend_type) == TRUE then
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_WeaponChangeEndMirror, lower_state, FALSE) == TRUE then
    end
end

function StealthWeaponChangeEnd_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if WeaponChangeCommonFunction(blend_type) == TRUE then
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Stealth_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_StealthWeaponChangeEnd, lower_state, FALSE) == TRUE then
    end
end

function HandChangeStart_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if HandChangeCommonFunction(blend_type) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventHalfBlendNoReset(Event_HandChangeEnd, blend_type)
        return
    elseif HalfBlendLowerCommonFunction(Event_HandChangeStartMirror, lower_state, FALSE) == TRUE then
    end
end

function StealthHandChangeStart_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if HandChangeCommonFunction(blend_type) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventHalfBlendNoReset(Event_StealthHandChangeEnd, blend_type)
        return
    elseif HalfBlendLowerCommonFunction(Event_StealthHandChangeStart, lower_state, FALSE) == TRUE then
    end
end

function HandChangeEnd_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if HandChangeCommonFunction(blend_type) == TRUE then
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_HandChangeEndMirror, lower_state, FALSE) == TRUE then
    end
end

function HandChangeEnd_Upper_onDeactivate()
    HandChangeTest_ToR1 = FALSE
    HandChangeTest_ToR2 = FALSE
    HandChangeTest_ToL1 = FALSE
    HandChangeTest_ToL2 = FALSE
end

function StealthHandChangeEnd_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if HandChangeCommonFunction(blend_type) == TRUE then
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Stealth_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_StealthHandChangeEnd, lower_state, FALSE) == TRUE then
    end
end

function StealthHandChangeEnd_Upper_onDeactivate()
    HandChangeTest_ToR1 = FALSE
    HandChangeTest_ToR2 = FALSE
    HandChangeTest_ToL1 = FALSE
    HandChangeTest_ToL2 = FALSE
end

function Item_Upper_Activate()
    ActivateRightArmAdd(START_FRAME_NONE)
end

function Item_Upper_Update()
    UpdateRightArmAdd()
end

function QuickItemEnchantNormal_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if QuickItemCommonFunction(g_r1, g_r2, g_l1, g_l2, g_b1, g_b2, blend_type, QUICKTYPE_NORMAL) == TRUE then
        return
    elseif blend_type ~= UPPER and TRUE == ExecQuickTurn(LOWER, TURN_TYPE_DEFAULT) then
        return TRUE
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        ClearAttackQueue()
        return
    elseif HalfBlendLowerCommonFunction(Event_QuickItemEnchantNormal, lower_state, FALSE, TRUE) == TRUE then
    end
end

function QuickItemEnchantDash_Upper_onActivate()
    act(LockonFixedAngleCancel)
end

function QuickItemEnchantDash_Upper_onUpdate()
    act(LockonFixedAngleCancel)
    local r1 = "W_AttackRightLight1"
    local r2 = "W_AttackRightHeavy1Start"
    local b1 = "W_AttackBothLight1"
    local b2 = "W_AttackBothHeavy1Start"
    if GetVariable("MoveSpeedIndex") >= 1 then
        r1 = "W_AttackRightLightDash"
        r2 = "W_AttackRightHeavyDash"
        b1 = "W_AttackBothDash"
        b2 = "W_AttackBothHeavyDash"
    end
    local blend_type, lower_state = GetHalfBlendInfo()
    if QuickItemCommonFunction(r1, r2, g_l1, g_l2, b1, b2, blend_type, QUICKTYPE_NORMAL) == TRUE then
        return
    elseif env(GetSpEffectID, 100220) == FALSE and HalfBlendLowerCommonFunction(Event_StopHalfBlendDashStop, lower_state, FALSE) == TRUE then
        SetVariable("MoveSpeedLevelReal", 0)
        return
    elseif TRUE == env(IsMoveCancelPossible) then
        ExecEvent("W_Idle")
    end
end

function QuickItemEnchantStep_Upper_onUpdate()
    if QuickItemCommonFunction(g_r1, g_r2, g_l1, g_l2, g_b1, g_b2, ALLBODY, QUICKTYPE_NORMAL) == TRUE then
    end
end

function QuickItemEnchantAttackRight_Upper_onUpdate()
    if QuickItemCommonFunction(g_r1, g_r2, g_l1, g_l2, g_b1, g_b2, ALLBODY, QUICKTYPE_NORMAL) == TRUE then
    end
end

function QuickItemEnchantAttackLeft_Upper_onUpdate()
    if QuickItemCommonFunction(g_r1, g_r2, g_l1, g_l2, g_b1, g_b2, ALLBODY, QUICKTYPE_NORMAL) == TRUE then
    end
end

function QuickItemThrowKnifeNormal_Upper_onUpdate()
    if QuickItemCommonFunction(g_r1, g_r2, g_l1, g_l2, g_b1, g_b2, ALLBODY, QUICKTYPE_COMBO) == TRUE then
    end
end

function QuickItemThrowKnifeDash_Upper_onUpdate()
    if QuickItemCommonFunction(g_r1, g_r2, g_l1, g_l2, g_b1, g_b2, ALLBODY, QUICKTYPE_COMBO) == TRUE then
    end
end

function QuickItemThrowKnifeStep_Upper_onUpdate()
    if QuickItemCommonFunction(g_r1, g_r2, g_l1, g_l2, g_b1, g_b2, ALLBODY, QUICKTYPE_COMBO) == TRUE then
    end
end

function QuickItemThrowKnifeAttackRight_Upper_onUpdate()
    if QuickItemCommonFunction(g_r1, g_r2, g_l1, g_l2, g_b1, g_b2, ALLBODY, QUICKTYPE_COMBO) == TRUE then
    end
end

function QuickItemThrowKnifeAttackRight2_Upper_onUpdate()
    if QuickItemCommonFunction(g_r1, g_r2, g_l1, g_l2, g_b1, g_b2, ALLBODY, QUICKTYPE_ATTACK) == TRUE then
    end
end

function QuickItemThrowKnifeAttackLeft_Upper_onUpdate()
    if QuickItemCommonFunction(g_r1, g_r2, g_l1, g_l2, g_b1, g_b2, ALLBODY, QUICKTYPE_COMBO) == TRUE then
    end
end

function QuickItemThrowKnifeAttackLeft2_Upper_onUpdate()
    if QuickItemCommonFunction(g_r1, g_r2, g_l1, g_l2, g_b1, g_b2, ALLBODY, QUICKTYPE_ATTACK) == TRUE then
    end
end

function ItemRecover_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemRecover, lower_state, FALSE) == TRUE then
    end
end

function ItemEatJerky_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemRecover, lower_state, FALSE) == TRUE then
    end
end

function ItemLanternOn_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemRecover, lower_state, FALSE, TRUE) == TRUE then
    end
end

function ItemLanternOff_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemRecover, lower_state, FALSE, TRUE) == TRUE then
    end
end

function ItemElixir_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemRecover, lower_state, FALSE) == TRUE then
    end
end

function ItemHorn_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemRecover, lower_state, FALSE, TRUE) == TRUE then
    end
end

function ItemWeaponEnchant_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemWeaponEnchant, lower_state, FALSE, TRUE) == TRUE then
    end
end

function ItemThrowKnife_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemThrowKnife, lower_state, FALSE, TRUE) == TRUE then
    end
end

function ItemThrowBottle_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemThrowBottle, lower_state, FALSE, TRUE) == TRUE then
    end
end

function ItemMeganeStart_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        act(RemoveBinoculars)
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventHalfBlend(Event_ItemMeganeLoop, blend_type)
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemMeganeStart, lower_state, FALSE, TRUE) == TRUE then
        act(RemoveBinoculars)
    end
end

function ItemMeganeLoop_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        act(RemoveBinoculars)
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemMeganeLoop, lower_state, FALSE) == TRUE then
        act(RemoveBinoculars)
    end
end

function ItemMeganeEnd_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemMeganeEnd, lower_state, FALSE) == TRUE then
    end
end

function ItemWeaponRepair_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemWeaponRepair, lower_state, FALSE) == TRUE then
    end
end

function ItemSoul_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemSoul, lower_state, FALSE) == TRUE then
    end
end

function ItemMessage_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemMessage, lower_state, FALSE, TRUE) == TRUE then
    end
end

function ItemPray_Upper_onUpdate()
    act(SetAllowedThrowDefenseType, 255)
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif GetVariable("RideOnSummonTest") == 1 then
        if TRUE == env(IsMovingOnMount) then
            FireRideEvent("W_RideOn", "W_RideOn", FALSE)
            return TRUE
        elseif TRUE == env(IsIdleOnMount) then
            ExecEventAllBody("W_Idle")
            return TRUE
        end
    elseif TRUE == env(IsSummoningRide) then
        if TRUE == env(Unknown552) then
            SetVariable("RideOnSummonTest", 1)
            FireRideEvent("W_RideOn", "W_RideOn", FALSE)
        else
            SetVariable("RideOnSummonTest", 0)
            ExecEventAllBody("W_RideAdjustFromCalling")
        end
        return TRUE
    elseif TRUE == env(GetEventEzStateFlag, 0) then
        act(Unknown3000)
        return TRUE
    end
    if HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemPray, lower_state, FALSE, TRUE) == TRUE then
    end
end

function ItemTrap_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemTrap, lower_state, FALSE, TRUE) == TRUE then
    end
end

function ItemDrinkStart_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    end
    local isEnd = env(IsAnimEnd, 1)
    if TRUE == env(GetEventEzStateFlag, 0) or isEnd == TRUE then
        local item_type = env(GetItemAnimType)
        if item_type ~= ITEM_NO_DRINK then
            ExecEventHalfBlendNoReset(Event_ItemDrinking, blend_type)
            return
        elseif item_type == ITEM_NO_DRINK and isEnd == TRUE then
            ExecEventHalfBlendNoReset(Event_ItemDrinkEmpty, blend_type)
            return
        end
    end
    if HalfBlendLowerCommonFunction(Event_ItemDrinkStart, lower_state, FALSE) == TRUE then
    end
end

function ItemDrinkNothing_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemDrinkNothing, lower_state, FALSE) == TRUE then
    end
end

function ItemDrinking_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventHalfBlendNoReset(Event_ItemDrinkEnd, blend_type)
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemDrinking, lower_state, FALSE) == TRUE then
    end
end

function ItemDrinkEnd_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemDrinkEnd, lower_state, FALSE) == TRUE then
    end
end

function ItemShockWeaveStart_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemShockWeaveStart, lower_state, FALSE) == TRUE then
    end
end

function ItemShockWeaveEnd_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemShockWeaveEnd, lower_state, FALSE) == TRUE then
    end
end

function ItemDrinkStartMP_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif TRUE == env(GetEventEzStateFlag, 0) then
        ExecEventHalfBlendNoReset(Event_ItemDrinkingMP, blend_type)
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemDrinkStartMP, lower_state, FALSE) == TRUE then
    end
end

function ItemDrinkingMP_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventHalfBlendNoReset(Event_ItemDrinkEnd, blend_type)
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemDrinkingMP, lower_state, FALSE) == TRUE then
    end
end

function ItemThrowSpear_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemThrowSpear, lower_state, FALSE, TRUE) == TRUE then
    end
end

function DragonFullStartAfter_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemThrowSpear, lower_state, FALSE, TRUE) == TRUE then
    end
end

function ItemPrayMulti_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemPrayMulti, lower_state, FALSE, TRUE) == TRUE then
    end
end

function ItemReturnBuddy_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemReturnBuddy, lower_state, FALSE, TRUE) == TRUE then
    end
end

function ItemSummonBuddy_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemSummonBuddy, lower_state, FALSE, TRUE) == TRUE then
    end
end

function ItemCopySleep_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemCopySleep, lower_state, FALSE) == TRUE then
    end
end

function ItemVoice_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemVoice, lower_state, FALSE, TRUE) == TRUE then
    end
end

function ItemHolySymbol_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemHolySymbol, lower_state, FALSE, TRUE) == TRUE then
    end
end

function ItemHost_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemHost, lower_state, FALSE, TRUE) == TRUE then
    end
end

function ItemMultKick_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemMultKick, lower_state, FALSE, TRUE) == TRUE then
    end
end

function ItemTongue_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemTongue, lower_state, FALSE, TRUE) == TRUE then
    end
end

function ItemThrowBackBottle_Upper_onUpdate()
    act(LockonFixedAngleCancel)
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemThrowBackBottle, lower_state, FALSE, TRUE) == TRUE then
    end
end

function ItemAromaWide_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemAromaWide, lower_state, FALSE, TRUE) == TRUE then
    end
end

function ItemAromaUp_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemAromaUp, lower_state, FALSE, TRUE) == TRUE then
    end
end

function ItemAromaBreath_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemAromaBreath, lower_state, FALSE, TRUE) == TRUE then
    end
end

function ItemAromaDrink_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemAromaDrink, lower_state, FALSE, TRUE) == TRUE then
    end
end

function ItemAromaFront_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemAromaFront, lower_state, FALSE, TRUE) == TRUE then
    end
end

function ItemDrinkEmpty_Upper_onActivate()
    if env(IsCOMPlayer) == TRUE then
        act(AddSpEffect, 5630)
    end
end

function ItemDrinkEmpty_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemDrinkEmpty, lower_state, FALSE) == TRUE then
    end
end

function ItemOneShot_Upper_onUpdate()
    if GetVariable("IndexItemUseAnim") == 52 then
        SetEnableMimicry()
    end
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemOneShot, lower_state, FALSE, TRUE) == TRUE then
    end
end

function ItemOneShot_SelfTrans_Upper_onUpdate()
    if GetVariable("IndexItemUseAnim_SelfTrans") == 52 then
        SetEnableMimicry()
    end
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemOneShot_SelfTrans, lower_state, FALSE, TRUE) == TRUE then
    end
end

function ItemCombo_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemCombo, lower_state, FALSE, TRUE) == TRUE then
    end
end

IsSummonDash = FALSE

function ItemDash_Upper_onUpdate()
    act(LockonFixedAngleCancel)
    act(SetAllowedThrowDefenseType, 255)
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif GetLocomotionState() == PLAYER_STATE_MOVE and GetVariable("MoveSpeedIndex") >= 1 and GetVariable("ItemDashSpeedIndex") == 0 then
        act(DebugLogOutput, "SummonHorse ChangeSpeedIndex")
        IsSummonDash = TRUE
        SetVariable("ItemDashSpeedIndex", 1)
    end
    if TRUE == env(IsSummoningRide) then
        act(DebugLogOutput, "SummonHorse SummonRequest true")
        if TRUE == env(Unknown552) and TRUE == IsSummonDash then
            act(DebugLogOutput, "SummonHorse RideOnDash")
            SetVariable("RideOnSummonTest", 2)
            FireRideEvent("W_RideOn", "W_RideOnDash", FALSE)
        elseif TRUE == env(Unknown552) then
            act(DebugLogOutput, "SummonHorse RideOn")
            SetVariable("RideOnSummonTest", 1)
            FireRideEvent("W_RideOn", "W_RideOn", FALSE)
        else
            SetVariable("RideOnSummonTest", 0)
            ExecEventAllBody("W_RideAdjustFromCalling")
        end
        return
    elseif TRUE == env(GetEventEzStateFlag, 0) then
        if GetVariable("MoveSpeedLevel") >= 0.8999999761581421 then
        else
            IsSummonDash = FALSE
        end
        if TRUE == env(IsAnimEnd, 1) then
            ExecEventAllBody("W_Idle")
        end
        act(Unknown3000)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemDash, lower_state, FALSE, TRUE) == TRUE then
    end
end

function ItemInvalid_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if ItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_ItemInvalid, lower_state, FALSE, TRUE) == TRUE then
    end
end

function ItemLadderRecoverRight_onUpdate()
    LadderSetActionState(LADDER_ACTION_IDLE_RIGHT)
    if LadderItemCommonFunction(HAND_STATE_RIGHT, FALSE) == TRUE then
    end
end

function ItemLadderSoulRight_onUpdate()
    LadderSetActionState(LADDER_ACTION_IDLE_RIGHT)
    if LadderItemCommonFunction(HAND_STATE_RIGHT, FALSE) == TRUE then
    end
end

function ItemLadderElixirRight_onUpdate()
    LadderSetActionState(LADDER_ACTION_IDLE_RIGHT)
    if LadderItemCommonFunction(HAND_STATE_RIGHT, FALSE) == TRUE then
    end
end

function ItemLadderEatJerkyRight_onUpdate()
    LadderSetActionState(LADDER_ACTION_IDLE_RIGHT)
    if LadderItemCommonFunction(HAND_STATE_RIGHT, FALSE) == TRUE then
    end
end

function ItemLadderDrinkStartRight_onUpdate()
    LadderSetActionState(LADDER_ACTION_IDLE_RIGHT)
    if LadderItemCommonFunction(HAND_STATE_RIGHT, TRUE) == TRUE then
        return
    end
    local isEnd = env(IsAnimEnd, 1)
    if TRUE == env(GetEventEzStateFlag, 0) or isEnd == TRUE then
        local item_type = env(GetItemAnimType)
        if item_type ~= ITEM_NO_DRINK then
            ExecEvent("W_ItemLadderDrinkingRight")
            return
        elseif item_type == ITEM_NO_DRINK and isEnd == TRUE then
            ExecEvent("W_ItemLadderDrinkEmptyRight")
        end
    end
end

function ItemLadderDrinkingRight_onUpdate()
    LadderSetActionState(LADDER_ACTION_IDLE_RIGHT)
    if LadderItemCommonFunction(HAND_STATE_RIGHT, TRUE) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEvent("W_ItemLadderDrinkEndRight")
    end
end

function ItemLadderDrinkMPStartRight_onUpdate()
    LadderSetActionState(LADDER_ACTION_IDLE_RIGHT)
    if LadderItemCommonFunction(HAND_STATE_RIGHT, TRUE) == TRUE then
        return
    elseif TRUE == env(GetEventEzStateFlag, 0) then
        ExecEvent("W_ItemLadderDrinkingMPRight")
    end
end

function ItemLadderDrinkingMPRight_onUpdate()
    LadderSetActionState(LADDER_ACTION_IDLE_RIGHT)
    if LadderItemCommonFunction(HAND_STATE_RIGHT, TRUE) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEvent("W_ItemLadderDrinkEndRight")
    end
end

function ItemLadderDrinkEndRight_onUpdate()
    LadderSetActionState(LADDER_ACTION_IDLE_RIGHT)
    if LadderItemCommonFunction(HAND_STATE_RIGHT, FALSE) == TRUE then
    end
end

function ItemLadderDrinkEmptyRight_onUpdate()
    LadderSetActionState(LADDER_ACTION_IDLE_RIGHT)
    if LadderItemCommonFunction(HAND_STATE_RIGHT, FALSE) == TRUE then
    end
end

function ItemLadderDrinkNothingRight_onUpdate()
    LadderSetActionState(LADDER_ACTION_IDLE_RIGHT)
    if LadderItemCommonFunction(HAND_STATE_RIGHT, FALSE) == TRUE then
    end
end

function ItemLadderInvalidRight_onUpdate()
    LadderSetActionState(LADDER_ACTION_IDLE_RIGHT)
    if LadderItemCommonFunction(HAND_STATE_RIGHT, FALSE) == TRUE then
    end
end

function ItemLadderRecoverLeft_onUpdate()
    LadderSetActionState(LADDER_ACTION_IDLE_LEFT)
    if LadderItemCommonFunction(HAND_STATE_LEFT, FALSE) == TRUE then
    end
end

function ItemLadderSoulLeft_onUpdate()
    LadderSetActionState(LADDER_ACTION_IDLE_LEFT)
    if LadderItemCommonFunction(HAND_STATE_LEFT, FALSE) == TRUE then
    end
end

function ItemLadderElixirLeft_onUpdate()
    LadderSetActionState(LADDER_ACTION_IDLE_LEFT)
    if LadderItemCommonFunction(HAND_STATE_LEFT, FALSE) == TRUE then
    end
end

function ItemLadderEatJerkyLeft_onUpdate()
    LadderSetActionState(LADDER_ACTION_IDLE_LEFT)
    if LadderItemCommonFunction(HAND_STATE_LEFT, FALSE) == TRUE then
    end
end

function ItemLadderDrinkStartLeft_onUpdate()
    LadderSetActionState(LADDER_ACTION_IDLE_LEFT)
    if LadderItemCommonFunction(HAND_STATE_LEFT, TRUE) == TRUE then
        return
    end
    local isEnd = env(IsAnimEnd, 1)
    if TRUE == env(GetEventEzStateFlag, 0) or isEnd == TRUE then
        local item_type = env(GetItemAnimType)
        if item_type ~= ITEM_NO_DRINK then
            ExecEvent("W_ItemLadderDrinkingLeft")
            return
        elseif item_type == ITEM_NO_DRINK and isEnd == TRUE then
            ExecEvent("W_ItemLadderDrinkEmptyLeft")
        end
    end
end

function ItemLadderDrinkingLeft_onUpdate()
    LadderSetActionState(LADDER_ACTION_IDLE_LEFT)
    if LadderItemCommonFunction(HAND_STATE_LEFT, TRUE) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEvent("W_ItemLadderDrinkEndLeft")
    end
end

function ItemLadderDrinkMPStartLeft_onUpdate()
    LadderSetActionState(LADDER_ACTION_IDLE_LEFT)
    if LadderItemCommonFunction(HAND_STATE_LEFT, TRUE) == TRUE then
        return
    elseif TRUE == env(GetEventEzStateFlag, 0) then
        ExecEvent("W_ItemLadderDrinkingMPLeft")
    end
end

function ItemLadderDrinkingMPLeft_onUpdate()
    LadderSetActionState(LADDER_ACTION_IDLE_LEFT)
    if LadderItemCommonFunction(HAND_STATE_LEFT, TRUE) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEvent("W_ItemLadderDrinkEndLeft")
    end
end

function ItemLadderDrinkEndLeft_onUpdate()
    LadderSetActionState(LADDER_ACTION_IDLE_LEFT)
    if LadderItemCommonFunction(HAND_STATE_LEFT, FALSE) == TRUE then
    end
end

function ItemLadderDrinkEmptyLeft_onUpdate()
    LadderSetActionState(LADDER_ACTION_IDLE_LEFT)
    if LadderItemCommonFunction(HAND_STATE_LEFT, FALSE) == TRUE then
    end
end

function ItemLadderDrinkNothingLeft_onUpdate()
    LadderSetActionState(LADDER_ACTION_IDLE_LEFT)
    if LadderItemCommonFunction(HAND_STATE_LEFT, FALSE) == TRUE then
    end
end

function ItemLadderInvalidLeft_onUpdate()
    LadderSetActionState(LADDER_ACTION_IDLE_LEFT)
    if LadderItemCommonFunction(HAND_STATE_LEFT, FALSE) == TRUE then
    end
end

function GestureStart_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if GestureCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_GestureStart, lower_state, FALSE) == TRUE then
    end
end

function GestureLoopStart_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if GestureLoopCommonFunction(blend_type, lower_state, TRUE) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventHalfBlend(Event_GestureLoop, blend_type)
        return
    elseif HalfBlendLowerCommonFunction(Event_GestureLoopStart, lower_state, FALSE) == TRUE then
    end
end

function GestureLoop_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if GestureLoopCommonFunction(blend_type, lower_state, FALSE) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_GestureLoop, lower_state, FALSE) == TRUE then
    end
end

function GestureEnd_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if GestureCommonFunction() == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_GestureEnd, lower_state, FALSE) == TRUE then
    end
end

function Magic_Upper_Activate()
end

function MagicRight_Upper_Activate()
    local style = c_Style
    act(DebugLogOutput, "MagicRight_Upper_Activate check" .. style .. " ==" .. HAND_LEFT_BOTH)
    if style == HAND_LEFT_BOTH then
        SetAttackHand(HAND_LEFT)
        SetGuardHand(HAND_LEFT)
    else
        SetAttackHand(HAND_RIGHT)
        SetGuardHand(HAND_RIGHT)
    end
    ActivateRightArmAdd(START_FRAME_NONE)
end

function MagicRight_Upper_Update()
    UpdateRightArmAdd()
end

function MagicLeft_Upper_Activate()
    act(DebugLogOutput, "MagicLeft_Upper_Activate")
    SetAttackHand(HAND_LEFT)
    SetGuardHand(HAND_LEFT)
    ActivateRightArmAdd(START_FRAME_A02)
end

function MagicLeft_Upper_Update()
    UpdateRightArmAdd()
end

function MagicLaunchRight_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(blend_type, QUICKTYPE_NORMAL, FALSE) == TRUE then
        return
    elseif env(GetMagicAnimType) ~= MAGIC_REQUEST_CRYSTAL_MOON and blend_type ~= UPPER and TRUE == ExecQuickTurn(LOWER, TURN_TYPE_DEFAULT) then
        return TRUE
    elseif TRUE == env(IsAnimEndBySkillCancel) or TRUE == env(IsAnimEnd, 1) then
        ExecEventHalfBlend(Event_MagicFireRight, blend_type)
        return
    elseif HalfBlendLowerCommonFunction(Event_MagicLaunchRight, lower_state, FALSE) == TRUE then
    end
end

function MagicLoopRight_Upper_onUpdate()
    act(Unknown2050, IDX_AINOTE_STATETYPE, IDX_AINOTE_STATETYPE_CHARGEMAGIC)
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(blend_type, QUICKTYPE_NORMAL, FALSE) == TRUE then
        return
    end
    local wep_hand = HAND_RIGHT
    if c_Style == HAND_LEFT_BOTH then
        wep_hand = HAND_LEFT
    end
    if env(ActionDuration, ACTION_ARM_R1) <= 0 or env(IsMagicUseable, wep_hand, 1) == FALSE or env(GetStamina) <= 0 then
        local magic_index = env(GetMagicAnimType)
        if magic_index == MAGIC_REQUEST_EX_LARGE_ARROW then
            ExecEventHalfBlend(Event_MagicFireRightCancel2, blend_type)
        else
            ExecEventHalfBlend(Event_MagicFireRightCancel, blend_type)
        end
        return
    elseif HalfBlendLowerCommonFunction(Event_MagicLoopRight, lower_state, FALSE) == TRUE then
    end
end

function MagicFireRight_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    local is_throw = FALSE
    local magic_index = env(GetMagicAnimType)
    if magic_index == MAGIC_REQUEST_MAD_THROW then
        is_throw = TRUE
    end
    if MagicCommonFunction(ALLBODY, QUICKTYPE_NORMAL, is_throw) == TRUE then
        return
    end
    local wep_hand = HAND_RIGHT
    if c_Style == HAND_LEFT_BOTH then
        wep_hand = HAND_LEFT
    end
    if env(GetSpEffectID, 100610) == TRUE and (env(ActionDuration, ACTION_ARM_R1) <= 0 or env(IsMagicUseable, wep_hand, 1) == FALSE) then
        ExecEventHalfBlend(Event_MagicFireRightCancel, blend_type)
        return
    elseif TRUE == CheckIfHoldMagic() and (env(IsAnimEndBySkillCancel) == TRUE or env(IsAnimEnd, 1) == TRUE) then
        if env(ActionDuration, ACTION_ARM_R1) > 0 then
            ExecEventHalfBlend(Event_MagicLoopRight, blend_type)
            return
        else
            ExecEventHalfBlend(Event_MagicFireRightCancel, blend_type)
            return
        end
    elseif lower_state == LOWER_MOVE and env(IsMoveCancelPossible) == TRUE then
        SetMagicGeneratorTransitionIndex()
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        SetMagicGeneratorTransitionIndex()
        return
    elseif HalfBlendLowerCommonFunction(Event_MagicFireRight, lower_state, FALSE) == TRUE then
        SetMagicGeneratorTransitionIndex()
    end
end

function MagicFireRightCancel_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(ALLBODY, QUICKTYPE_NORMAL, FALSE) == TRUE then
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        SetMagicGeneratorTransitionIndex()
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        SetMagicGeneratorTransitionIndex()
        return
    elseif HalfBlendLowerCommonFunction(Event_MagicFireRightCancel, lower_state, FALSE) == TRUE then
        SetMagicGeneratorTransitionIndex()
    end
end

function MagicLaunchLeft_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(blend_type, QUICKTYPE_NORMAL, FALSE) == TRUE then
        return
    elseif env(GetMagicAnimType) ~= MAGIC_REQUEST_CRYSTAL_MOON and blend_type ~= UPPER and TRUE == ExecQuickTurn(LOWER, TURN_TYPE_DEFAULT) then
        return TRUE
    elseif TRUE == env(IsAnimEndBySkillCancel) or TRUE == env(IsAnimEnd, 1) then
        ExecEventHalfBlend(Event_MagicFireLeft, blend_type)
    end
    if HalfBlendLowerCommonFunction(Event_MagicLaunchLeft, lower_state, FALSE) == TRUE then
    end
end

function MagicLoopLeft_Upper_onUpdate()
    act(Unknown2050, IDX_AINOTE_STATETYPE, IDX_AINOTE_STATETYPE_CHARGEMAGIC)
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(blend_type, QUICKTYPE_NORMAL, FALSE) == TRUE then
        return
    elseif env(ActionDuration, ACTION_ARM_L1) <= 0 or FALSE == env(IsMagicUseable, HAND_LEFT, 1) or env(GetStamina) <= 0 then
        local magic_index = env(GetMagicAnimType)
        if magic_index == MAGIC_REQUEST_EX_LARGE_ARROW then
            ExecEventHalfBlend(Event_MagicFireLeftCancel2, blend_type)
        else
            ExecEventHalfBlend(Event_MagicFireLeftCancel, blend_type)
        end
    end
    if HalfBlendLowerCommonFunction(Event_MagicLoopLeft, lower_state, FALSE) == TRUE then
    end
end

function MagicFireLeftCancel_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(ALLBODY, QUICKTYPE_NORMAL, FALSE) == TRUE then
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        SetMagicGeneratorTransitionIndex()
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        SetMagicGeneratorTransitionIndex()
        return
    elseif HalfBlendLowerCommonFunction(Event_MagicFireLeftCancel, lower_state, FALSE) == TRUE then
        SetMagicGeneratorTransitionIndex()
    end
end

function MagicFireRight2_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(ALLBODY, QUICKTYPE_NORMAL, FALSE) == TRUE then
        return
    end
    local mp_condition = 0
    if GetVariable("IndexChargeMagicType") == 2 then
        mp_condition = 33
    end
    if TRUE == env(GetSpEffectID, 100610) and (0 >= env(ActionDuration, ACTION_ARM_R1) or mp_condition >= env(GetFP)) then
        ExecEventHalfBlend(Event_MagicFireRightCancel2, blend_type)
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_MagicFireRight2, lower_state, FALSE) == TRUE then
    end
end

function MagicFireRight3_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(ALLBODY, QUICKTYPE_NORMAL, FALSE) == TRUE then
        return
    end
    local mp_condition = 0
    if GetVariable("IndexChargeMagicType") == 2 then
        mp_condition = 33
    end
    if TRUE == env(GetSpEffectID, 100610) and (0 >= env(ActionDuration, ACTION_ARM_R1) or mp_condition >= env(GetFP)) then
        ExecEventHalfBlend(Event_MagicFireRightCancel3, blend_type)
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_MagicFireRight3, lower_state, FALSE) == TRUE then
    end
end

function MagicFireLeft_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    local is_throw = FALSE
    local magic_index = env(GetMagicAnimType)
    if magic_index == MAGIC_REQUEST_MAD_THROW then
        is_throw = TRUE
    end
    if MagicCommonFunction(ALLBODY, QUICKTYPE_NORMAL, is_throw) == TRUE then
        return
    elseif env(GetSpEffectID, 100610) == TRUE and (env(ActionDuration, ACTION_ARM_L1) <= 0 or FALSE == env(IsMagicUseable, HAND_LEFT, 1)) then
        ExecEventHalfBlend(Event_MagicFireLeftCancel, blend_type)
        return
    elseif TRUE == CheckIfHoldMagic() and (env(IsAnimEndBySkillCancel) == TRUE or env(IsAnimEnd, 1) == TRUE) then
        if env(ActionDuration, ACTION_ARM_L1) > 0 then
            ExecEventHalfBlend(Event_MagicLoopLeft, blend_type)
            return
        else
            ExecEventHalfBlend(Event_MagicFireLeftCancel, blend_type)
            return
        end
    elseif lower_state == LOWER_MOVE and env(IsMoveCancelPossible) == TRUE then
        SetMagicGeneratorTransitionIndex()
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        SetMagicGeneratorTransitionIndex()
        return
    elseif HalfBlendLowerCommonFunction(Event_MagicFireLeft, lower_state, FALSE) == TRUE then
        SetMagicGeneratorTransitionIndex()
    end
end

function MagicFireRightCancel2_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(ALLBODY, QUICKTYPE_NORMAL, FALSE) == TRUE then
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        SetMagicGeneratorTransitionIndex()
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        SetMagicGeneratorTransitionIndex()
        return
    elseif HalfBlendLowerCommonFunction(Event_MagicFireRight2, lower_state, FALSE) == TRUE then
        SetMagicGeneratorTransitionIndex()
    end
end

function MagicFireRightCancel3_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(ALLBODY, QUICKTYPE_NORMAL, FALSE) == TRUE then
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_MagicFireRight3, lower_state, FALSE) == TRUE then
    end
end

function MagicFireLeftCancel2_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(ALLBODY, QUICKTYPE_NORMAL, FALSE) == TRUE then
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        SetMagicGeneratorTransitionIndex()
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        SetMagicGeneratorTransitionIndex()
        return
    elseif HalfBlendLowerCommonFunction(Event_MagicFireLeft2, lower_state, FALSE) == TRUE then
        SetMagicGeneratorTransitionIndex()
    end
end

function MagicFireLeft2_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(ALLBODY, QUICKTYPE_NORMAL, FALSE) == TRUE then
        return
    elseif TRUE == env(GetSpEffectID, 100610) and (env(ActionDuration, ACTION_ARM_L1) <= 0 or FALSE == env(IsMagicUseable, HAND_LEFT, 1)) then
        ExecEventHalfBlend(Event_MagicFireLeftCancel2, blend_type)
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_MagicFireLeft2, lower_state, FALSE) == TRUE then
    end
end

function MagicFireLeftCancel3_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(ALLBODY, QUICKTYPE_NORMAL, FALSE) == TRUE then
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_MagicFireLeftCancel3, lower_state, FALSE) == TRUE then
    end
end

function MagicFireLeft3_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(ALLBODY, QUICKTYPE_NORMAL, FALSE) == TRUE then
        return
    elseif TRUE == env(GetSpEffectID, 100610) and (env(ActionDuration, ACTION_ARM_L1) <= 0 or FALSE == env(IsMagicUseable, HAND_LEFT, 1)) then
        ExecEventHalfBlend(Event_MagicFireLeftCancel3, blend_type)
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_MagicFireLeftCancel3, lower_state, FALSE) == TRUE then
    end
end

function QuickMagicFireRightDash_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(blend_type, QUICKTYPE_ATTACK, FALSE) == TRUE then
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_QuickMagicFireRightDash, lower_state, FALSE) == TRUE then
    end
end

function QuickMagicFireRightStep_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(blend_type, QUICKTYPE_ATTACK, FALSE) == TRUE then
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_QuickMagicFireRightStep, lower_state, FALSE) == TRUE then
    end
end

function QuickMagicFireRightBackStep_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(blend_type, QUICKTYPE_ATTACK, FALSE) == TRUE then
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_QuickMagicFireRightBackStep, lower_state, FALSE) == TRUE then
    end
end

function QuickMagicFireRightAttackLeft_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(blend_type, QUICKTYPE_ATTACK, FALSE) == TRUE then
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_QuickMagicFireRightAttackLeft, lower_state, FALSE) == TRUE then
    end
end

function QuickMagicFireRightAttackRight_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(blend_type, QUICKTYPE_ATTACK, FALSE) == TRUE then
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_QuickMagicFireRightAttackRight, lower_state, FALSE) == TRUE then
    end
end

function QuickMagicFireLeftDash_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(blend_type, QUICKTYPE_ATTACK, FALSE) == TRUE then
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_QuickMagicFireLeftDash, lower_state, FALSE) == TRUE then
    end
end

function QuickMagicFireLeftStep_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(blend_type, QUICKTYPE_ATTACK, FALSE) == TRUE then
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_QuickMagicFireLeftStep, lower_state, FALSE) == TRUE then
    end
end

function QuickMagicFireLeftBackStep_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(blend_type, QUICKTYPE_ATTACK, FALSE) == TRUE then
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_QuickMagicFireLeftBackStep, lower_state, FALSE) == TRUE then
    end
end

function QuickMagicFireLeftAttackRight_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(blend_type, QUICKTYPE_ATTACK, FALSE) == TRUE then
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_QuickMagicFireLeftAttackRight, lower_state, FALSE) == TRUE then
    end
end

function QuickMagicFireLeftAttackLeft_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(blend_type, QUICKTYPE_ATTACK, FALSE) == TRUE then
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_QuickMagicFireLeftAttackRight, lower_state, FALSE) == TRUE then
    end
end

function MagicFireRightJump_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(ALLBODY, QUICKTYPE_NORMAL, FALSE) == TRUE then
        return
    end
    local wep_hand = HAND_RIGHT
    if c_Style == HAND_LEFT_BOTH then
        wep_hand = HAND_LEFT
    end
    if TRUE == env(GetSpEffectID, 100610) and (env(ActionDuration, ACTION_ARM_R1) <= 0 or env(IsMagicUseable, wep_hand, 1) == FALSE) then
        ExecEventHalfBlend(Event_MagicFireRightJumpCancel, blend_type)
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_MagicFireRightJump, lower_state, FALSE) == TRUE then
    end
end

function MagicFireRightJumpCancel_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(ALLBODY, QUICKTYPE_NORMAL, FALSE) == TRUE then
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_MagicFireRightJumpCancel, lower_state, FALSE) == TRUE then
    end
end

function MagicFireLeftJump_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(ALLBODY, QUICKTYPE_NORMAL, FALSE) == TRUE then
        return
    end
    local wep_hand = HAND_LEFT
    if TRUE == env(GetSpEffectID, 100610) and (env(ActionDuration, ACTION_ARM_L1) <= 0 or env(IsMagicUseable, wep_hand, 1) == FALSE) then
        ExecEventHalfBlend(Event_MagicFireRightJumpCancel, blend_type)
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_MagicFireLeftJump, lower_state, FALSE) == TRUE then
    end
end

function MagicFireLeftJumpCancel_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(ALLBODY, QUICKTYPE_NORMAL, FALSE) == TRUE then
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_MagicFireLeftJumpCancel, lower_state, FALSE) == TRUE then
    end
end

function StealthMagicRightLaunch_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(blend_type, QUICKTYPE_NORMAL, FALSE) == TRUE then
        return
    elseif TRUE == env(IsAnimEndBySkillCancel) or TRUE == env(IsAnimEnd, 1) then
        ExecEventHalfBlend(Event_StealthMagicRightFire, blend_type)
        return
    elseif HalfBlendLowerCommonFunction(Event_StealthMagicRightLaunch, lower_state, FALSE, FALSE) == TRUE then
    end
end

function StealthMagicRightFire_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(blend_type, QUICKTYPE_NORMAL, FALSE) == TRUE then
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Stealth_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_StealthMagicRightFire, lower_state, FALSE, FALSE) == TRUE then
    end
end

function StealthMagicLeftLaunch_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(blend_type, QUICKTYPE_NORMAL, FALSE) == TRUE then
        return
    elseif TRUE == env(IsAnimEndBySkillCancel) or TRUE == env(IsAnimEnd, 1) then
        ExecEventHalfBlend(Event_StealthMagicLeftFire, blend_type)
        return
    elseif HalfBlendLowerCommonFunction(Event_StealthMagicLeftLaunch, lower_state, FALSE, FALSE) == TRUE then
    end
end

function StealthMagicLeftFire_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(blend_type, QUICKTYPE_NORMAL, FALSE) == TRUE then
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Stealth_Move, UPPER)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_StealthMagicLeftFire, lower_state, FALSE, FALSE) == TRUE then
    end
end

function MagicInvalid_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if MagicCommonFunction(ALLBODY, QUICKTYPE_ATTACK, FALSE) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_MagicInvalidMirror, lower_state, FALSE) == TRUE then
    end
end

function ThrowBackStab_Activate()
    act(InvokeBackstab)
    local hand = HAND_RIGHT
    if c_Style == HAND_LEFT_BOTH then
        hand = HAND_LEFT
    end
    SetAttackHand(hand)
    SetGuardHand(hand)
end

function ThrowBackStab_onActivate()
    SetVariable("ThrowHandIndex", 0)
end

function ThrowBackStab_onUpdate()
    if env(HasThrowRequest) == FALSE then
        if BackStabCommonFunction() == TRUE then
            return
        end
    else
        ResetRequest()
    end
end

function Throw_Activate()
    ResetRequest()
    SetVariable("MoveSpeedLevelReal", 0)
    SetThrowInvalid()
    local id = env(GetThrowAnimID)
    if id >= 0 then
        SetVariable("ThrowID", id)
    end
    if c_Style == HAND_LEFT_BOTH then
        SetAttackHand(HAND_LEFT)
        SetGuardHand(HAND_LEFT)
    else
        SetAttackHand(HAND_RIGHT)
        SetGuardHand(HAND_RIGHT)
    end
    SetVariable("ThrowHandIndex", 0)
    SetVariable("ThrowHoldBlendWeight", 0)
    SetVariable("ThrowHolding", false)
    SetVariable("ThrowNoRegistTime", 0)
end

function Throw_Update()
    SetThrowInvalid()
end

function Throw_Deactivate()
    act(RequestThrowAnimInterrupt)
end

function ThrowAtk_onActivate()
    Replanning()
end

function ThrowAtk_onUpdate()
    if ThrowCommonFunction(FALSE) == TRUE then
        act(RequestThrowAnimInterrupt)
    end
end

function ThrowDef_onActivate()
    Replanning()
end

function ThrowDef_onUpdate()
    SetThrowDefBlendWeight()
    if env(IsThrowSelfDeath) == TRUE then
        ExecEvent("ThrowDeath")
        return
    elseif env(IsThrowSuccess) == TRUE then
        ExecEvent("W_ThrowEscape")
        return
    elseif TRUE == ThrowCommonFunction(ESTEP_DOWN) then
        act(RequestThrowAnimInterrupt)
    end
end

function ThrowEscape_onUpdate()
    if ThrowCommonFunction() == TRUE then
        act(RequestThrowAnimInterrupt)
    end
end

function ThrowDeath_onActivate()
    act(SetThrowState, THROW_TYPE_DEATH)
end

function ThrowDeathIdle_onActivate()
    act(SetThrowState, THROW_TYPE_INVALID)
end

function Event_onActivate()
    ResetEventState()
    SetVariable("TestIsEventBlend", 1)
    if GetVariable("TestIsEventBlend") then
        local testmoveangle = env(GetObjActTargetDirection)
        SetVariable("TestMoveAngle", testmoveangle)
        TestBlendrate = 0
    end
    blendtimemax = env(GetObjActRemainingInterpolateTime)
end

function Event_onUpdate()
    if GetVariable("TestIsEventBlend") then
        blendtime = env(GetObjActRemainingInterpolateTime)
        if blendtime > 0 then
            if EVENT_BLEND_RATE * 2 < blendtime then
                SetVariable("TestEventBlend_Move", 1)
                SetVariable("TestEventBlend_Event", 0)
            else
                local blendstoptime = blendtimemax / 2
                if blendstoptime < 300 then
                elseif blendstoptime > 750 then
                end
                local blendmove = (blendtime - 300) / EVENT_BLEND_RATE
                local blendevent = 1 - (blendtime - 300) / EVENT_BLEND_RATE
                if blendmove < 0 then
                    blendmove = 0
                end
                if blendevent > 1 then
                    blendevent = 1
                end
                SetVariable("TestEventBlend_Move", blendmove)
                SetVariable("TestEventBlend_Event", blendevent)
            end
        end
    end
end

function Event26001_onActivate()
    ResetEventState()
    act(SetTurnAnimCorrectionRate, 90)
end

function Event26001_onUpdate()
    act(SetIsTurnAnimInProgress)
    if EventCommonFunction() == TRUE then
    end
end

function Event26011_onActivate()
    ResetEventState()
    act(SetTurnAnimCorrectionRate, 90)
end

function Event26011_onUpdate()
    act(SetIsTurnAnimInProgress)
    if EventCommonFunction() == TRUE then
    end
end

function Event26020_onActivate()
    ResetEventState()
end

function Event26020_onUpdate()
    act(SetIsEventActionPossible, TRUE)
    if TRUE == EventCommonFunction() then
        act(SetIsEventActionPossible, FALSE)
    end
end

function Event26030_onActivate()
    ResetEventState()
end

function Event26030_onUpdate()
    act(SetIsEventActionPossible, TRUE)
    if TRUE == EventCommonFunction() then
        act(SetIsEventActionPossible, FALSE)
    end
end

function Event26021_onActivate()
    ResetEventState()
    act(SetTurnAnimCorrectionRate, 180)
end

function Event26021_onUpdate()
    act(SetIsTurnAnimInProgress)
    if EventCommonFunction() == TRUE then
    end
end

function Event26031_onActivate()
    ResetEventState()
    act(SetTurnAnimCorrectionRate, 180)
end

function Event26031_onUpdate()
    act(SetIsTurnAnimInProgress)
    if EventCommonFunction() == TRUE then
    end
end

function Event50050_onActivate()
    ResetEventState()
end

function Event50050_onUpdate()
    act(SetIsEventActionPossible, TRUE)
    if TRUE == EventCommonFunction() then
        act(SetIsEventActionPossible, FALSE)
    end
end

function Event50050_onDeactivate()
    act(SetIsEventActionPossible, FALSE)
end

function Event50250_onActivate()
    ResetEventState()
end

function Event50250_onUpdate()
    act(SetIsEventActionPossible, TRUE)
    if TRUE == EventCommonFunction() then
        act(SetIsEventActionPossible, FALSE)
    end
end

function Event50250_onDeactivate()
    act(SetIsEventActionPossible, FALSE)
end

function Event60000_onActivate()
    ResetEventState()
end

function Event60000_onUpdate()
    act(SetIsEventActionPossible, TRUE)
    if TRUE == EventCommonFunction() then
        act(SetIsEventActionPossible, FALSE)
    end
end

function Event60000_onDeactivate()
    act(SetIsEventActionPossible, FALSE)
end

function Event60001_onActivate()
    ResetEventState()
end

function Event60001_onUpdate()
    act(SetIsEventActionPossible, TRUE)
    if TRUE == EventCommonFunction() then
        act(SetIsEventActionPossible, FALSE)
    end
end

function Event60001_onDeactivate()
    act(SetIsEventActionPossible, FALSE)
end

function Event60002_onActivate()
    ResetEventState()
end

function Event60002_onUpdate()
    act(SetIsEventActionPossible, TRUE)
    if TRUE == EventCommonFunction() then
        act(SetIsEventActionPossible, FALSE)
    end
end

function Event60002_onDeactivate()
    act(SetIsEventActionPossible, FALSE)
end

function Event60003_onActivate()
    ResetEventState()
end

function Event60003_onUpdate()
    act(SetIsEventActionPossible, TRUE)
    if TRUE == EventCommonFunction() then
        act(SetIsEventActionPossible, FALSE)
    end
end

function Event60003_onDeactivate()
    act(SetIsEventActionPossible, FALSE)
end

function Event60010_onActivate()
    ResetEventState()
end

function Event60010_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60020_onActivate()
    ResetEventState()
end

function Event60020_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60030_onActivate()
    ResetEventState()
end

function Event60030_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60040_onActivate()
    ResetEventState()
end

function Event60040_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60060_onActivate()
    ResetEventState()
end

function Event60060_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60070_onActivate()
    ResetEventState()
end

function Event60070_onUpdate()
    act(SetIsEventActionPossible, TRUE)
    if TRUE == EventCommonFunction() then
        act(SetIsEventActionPossible, FALSE)
    end
end

function Event60070_onDeactivate()
    act(SetIsEventActionPossible, FALSE)
end

function Event60071_onActivate()
    ResetEventState()
end

function Event60071_onUpdate()
    act(SetIsEventActionPossible, TRUE)
    if TRUE == EventCommonFunction() then
        act(SetIsEventActionPossible, FALSE)
    end
end

function Event60071_onDeactivate()
    act(SetIsEventActionPossible, FALSE)
end

function EventHalfBlend60071_Upper_onActivate()
    ResetEventState()
end

function EventHalfBlend60071_Upper_onUpdate()
    act(SetIsEventActionPossible, TRUE)
    act(Wait)
    local blend_type, lower_state = GetHalfBlendInfo()
    if TRUE == EventCommonFunction() then
        act(SetIsEventActionPossible, FALSE)
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Move, UPPER)
        act(SetIsEventActionPossible, FALSE)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        act(SetIsEventActionPossible, FALSE)
        return
    elseif HalfBlendLowerCommonFunction(Event_EventHalfBlend60071, lower_state, FALSE) == TRUE then
        act(SetIsEventActionPossible, FALSE)
    end
end

function EventHalfBlend60071_Upper_onDeactivate()
    act(SetIsEventActionPossible, FALSE)
end

function EventHalfBlend360070_Upper_onActivate()
    ResetEventState()
end

function EventHalfBlend360070_Upper_onUpdate()
    act(SetIsEventActionPossible, TRUE)
    act(Wait)
    local blend_type, lower_state = GetHalfBlendInfo()
    if TRUE == EventCommonFunction() then
        act(SetIsEventActionPossible, FALSE)
        return
    elseif lower_state == LOWER_MOVE and TRUE == env(IsMoveCancelPossible) then
        ExecEventHalfBlendNoReset(Event_Stealth_Move, UPPER)
        act(SetIsEventActionPossible, FALSE)
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        act(SetIsEventActionPossible, FALSE)
        return
    elseif HalfBlendLowerCommonFunction(Event_EventHalfBlend360070, lower_state, FALSE) == TRUE then
        act(SetIsEventActionPossible, FALSE)
    end
end

function EventHalfBlend360070_Upper_onDeactivate()
    act(SetIsEventActionPossible, FALSE)
end

function Event60080_onActivate()
    ResetEventState()
end

function Event60080_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60090_onActivate()
    ResetEventState()
end

function Event60090_onUpdate()
    act(SetIsEventActionPossible, TRUE)
    if TRUE == EventCommonFunction() then
        act(SetIsEventActionPossible, FALSE)
    end
end

function Event60090_onDeactivate()
    act(SetIsEventActionPossible, FALSE)
end

function Event60100_onActivate()
    ResetEventState()
end

function Event60100_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60110_onActivate()
    ResetEventState()
end

function Event60110_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60120_onActivate()
    ResetEventState()
end

function Event60120_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60130_onActivate()
    ResetEventState()
end

function Event60130_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60131_onActivate()
    ResetEventState()
end

function Event60131_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60160_onActivate()
    ResetEventState()
end

function Event60160_onUpdate()
    act(SetIsEventActionPossible, TRUE)
    if TRUE == EventCommonFunction() then
        act(SetIsEventActionPossible, FALSE)
    end
end

function Event60160_onDeactivate()
    act(SetIsEventActionPossible, FALSE)
end

function Event60170_onActivate()
    ResetEventState()
end

function Event60170_onUpdate()
    act(SetIsEventActionPossible, TRUE)
    if TRUE == EventCommonFunction() then
        act(SetIsEventActionPossible, FALSE)
    end
end

function Event60170_onDeactivate()
    act(SetIsEventActionPossible, FALSE)
end

function Event60180_onActivate()
    ResetEventState()
end

function Event60180_onUpdate()
    act(SetIsEventActionPossible, TRUE)
    if TRUE == EventCommonFunction() then
        act(SetIsEventActionPossible, FALSE)
    end
end

function Event60180_onDeactivate()
    act(SetIsEventActionPossible, FALSE)
end

function Event60190_onActivate()
    ResetEventState()
end

function Event60190_onUpdate()
    act(SetIsEventActionPossible, TRUE)
    if TRUE == EventCommonFunction() then
        act(SetIsEventActionPossible, FALSE)
    end
end

function Event60190_onDeactivate()
    act(SetIsEventActionPossible, FALSE)
end

function Event60200_onActivate()
    ResetEventState()
end

function Event60200_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60201_onActivate()
    ResetEventState()
end

function Event60201_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60202_onActivate()
    ResetEventState()
end

function Event60202_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60210_onActivate()
    ResetEventState()
end

function Event60210_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60220_onActivate()
    ResetEventState()
end

function Event60220_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60230_onActivate()
    ResetEventState()
end

function Event60230_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60231_onActivate()
    ResetEventState()
end

function Event60231_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60240_onActivate()
    ResetEventState()
end

function Event60240_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60241_onActivate()
    ResetEventState()
end

function Event60241_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60250_onActivate()
    ResetEventState()
end

function Event60250_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60260_onActivate()
    ResetEventState()
end

function Event60260_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60265_onActivate()
    ResetEventState()
end

function Event60265_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60270_onActivate()
    ResetEventState()
end

function Event60270_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60370_onActivate()
    ResetEventState()
end

function Event60370_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60380_onActivate()
    ResetEventState()
end

function Event60380_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60390_onActivate()
    ResetEventState()
end

function Event60390_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60400_onActivate()
    ResetEventState()
end

function Event60400_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60450_onActivate()
    ResetEventState()
end

function Event60450_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60451_onActivate()
    ResetEventState()
end

function Event60451_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60455_onActivate()
    ResetEventState()
end

function Event60455_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60456_onActivate()
    ResetEventState()
end

function Event60455_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60460_onActivate()
    ResetEventState()
end

function Event60460_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60470_onActivate()
    ResetEventState()
end

function Event60470_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60471_onActivate()
    ResetEventState()
end

function Event60471_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60472_onActivate()
    ResetEventState()
end

function Event60472_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60473_onActivate()
    ResetEventState()
end

function Event60473_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60480_onActivate()
    ResetEventState()
end

function Event60480_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60481_onActivate()
    ResetEventState()
end

function Event60481_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60482_onActivate()
    ResetEventState()
end

function Event60482_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60490_onActivate()
    ResetEventState()
end

function Event60490_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60500_onActivate()
    ResetEventState()
end

function Event60500_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60501_onActivate()
    ResetEventState()
end

function Event60501_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60502_onActivate()
    ResetEventState()
end

function Event60502_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60503_onActivate()
    ResetEventState()
end

function Event60503_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60504_onActivate()
    ResetEventState()
end

function Event60504_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60505_onActivate()
    ResetEventState()
end

function Event60505_onUpdate()
    if env(IsAnimEnd, 1) == TRUE then
        act(Unknown2030)
    end
end

function Event60505_onDeactivate()
    act(Unknown2030)
end

function Event60520_onActivate()
    ResetEventState()
end

function Event60520_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60521_onActivate()
    ResetEventState()
end

function Event60521_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60522_onActivate()
    ResetEventState()
end

function Event60522_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60523_onActivate()
    ResetEventState()
end

function Event60523_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60524_onActivate()
    ResetEventState()
end

function Event60524_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60525_onActivate()
    ResetEventState()
end

function Event60525_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60530_onActivate()
    ResetEventState()
end

function Event60530_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60550_onActivate()
    ResetEventState()
end

function Event60550_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60560_onActivate()
    ResetEventState()
end

function Event60560_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60750_onActivate()
    ResetEventState()
end

function Event60750_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60760_onActivate()
    ResetEventState()
end

function Event60760_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60780_onActivate()
    ResetEventState()
end

function Event60780_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60790_onActivate()
    ResetEventState()
end

function Event60790_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60800_onActivate()
    ResetEventState()
end

function Event60800_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event60810_onActivate()
    ResetEventState()
end

function Event60810_onUpdate()
    act(SetIsEventActionPossible, TRUE)
    if TRUE == EventCommonFunction() then
    end
end

function Event60811_onActivate()
    ResetEventState()
end

function Event60811_onUpdate()
    act(SetIsEventActionPossible, TRUE)
    if TRUE == EventCommonFunction() then
    end
end

function Event63000_onActivate()
    ResetEventState()
end

function Event63000_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event63010_onActivate()
    ResetEventState()
end

function Event63010_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event63020_onActivate()
    ResetEventState()
end

function Event63020_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event63021_onActivate()
    ResetEventState()
end

function Event63040_onActivate()
    ResetEventState()
end

function Event63040_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event63050_onActivate()
    ResetEventState()
end

function Event63050_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event63060_onActivate()
    ResetEventState()
end

function Event63060_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event63061_onActivate()
    ResetEventState()
end

function Event63061_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event63070_onActivate()
    ResetEventState()
end

function Event63070_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event63080_onActivate()
    ResetEventState()
end

function Event63080_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event63090_onActivate()
    ResetEventState()
end

function Event63090_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event65012_onActivate()
    ResetEventState()
end

function Event65012_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event65013_onActivate()
    ResetEventState()
end

function Event65013_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event67000_onActivate()
    ResetEventState()
end

function Event67000_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event67001_onActivate()
    ResetEventState()
end

function Event67001_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event67010_onActivate()
    ResetEventState()
end

function Event67010_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event67011_onActivate()
    ResetEventState()
end

function Event67011_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event67020_onActivate()
    ResetEventState()
end

function Event67020_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event67030_onActivate()
    ResetEventState()
end

function Event67030_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event67040_onActivate()
    ResetEventState()
end

function Event67040_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event67050_onActivate()
    ResetEventState()
end

function Event67050_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event67060_onActivate()
    ResetEventState()
end

function Event67060_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event67070_onActivate()
    ResetEventState()
end

function Event67070_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event67080_onActivate()
    ResetEventState()
end

function Event67080_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event67090_onActivate()
    ResetEventState()
end

function Event67090_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event67080_onActivate()
    ResetEventState()
end

function Event67080_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event67100_onActivate()
    ResetEventState()
end

function Event67100_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event68043_onActivate()
    ResetEventState()
end

function Event68043_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event68110_onActivate()
    ResetEventState()
end

function Event68110_onUpdate()
    if env(IsAnimEnd, 1) == TRUE then
        ExecEvent("W_BonfireLevelUpLoop")
        return
    elseif TRUE == EventCommonFunction() then
    end
end

function Event69000_onActivate()
    ResetEventState()
end

function Event69000_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event69001_onActivate()
    ResetEventState()
end

function Event69001_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event69002_onActivate()
    ResetEventState()
end

function Event69002_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event69003_onActivate()
    ResetEventState()
end

function Event69003_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event69010_onActivate()
    ResetEventState()
end

function Event69010_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event69030_onActivate()
    ResetEventState()
end

function Event69030_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event6000_onActivate()
    ResetEventState()
end

function Event6000_onUpdate()
    act(SetIsEventActionPossible, TRUE)
    if TRUE == EventCommonFunction() then
        act(SetIsEventActionPossible, FALSE)
    end
end

function Event6000_onDeactivate()
    act(SetIsEventActionPossible, FALSE)
end

function Event6001_onActivate()
    ResetEventState()
end

function Event6001_onUpdate()
    if env(GetSpEffectID, 10665) == TRUE then
        act(SetIsEventActionPossible, FALSE)
    else
        act(SetIsEventActionPossible, TRUE)
    end
    if TRUE == EventCommonFunction() then
        act(SetIsEventActionPossible, FALSE)
    end
end

function Event6001_onDeactivate()
    act(SetIsEventActionPossible, FALSE)
end

function Event6002_onActivate()
    ResetEventState()
end

function Event6002_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event17140_onActivate()
    ResetEventState()
end

function Event18140_onActivate()
    ResetEventState()
end

function Event18140_onUpdate()
    act(SetDeathStay, TRUE)
end

function Event18140_onDeactivate()
    act(SetDeathStay, FALSE)
end

function Event99999_onActivate()
    ResetEventState()
end

function Event99999_onUpdate()
    if EventCommonFunction() == TRUE then
    end
end

function Event150250_onActivate()
    ResetEventState()
end

function Event150250_onUpdate()
    act(SetIsEventActionPossible, TRUE)
    if TRUE == RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        act(SetIsEventActionPossible, FALSE)
        return
    end
    local lower_only = TRUE
    local enable_turn = FALSE
    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end
    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
        act(SetIsEventActionPossible, FALSE)
    end
end

function Event150250_onDeactivate()
    act(SetIsEventActionPossible, FALSE)
end

function Event160070_onActivate()
    ResetEventState()
end

function Event160070_onUpdate()
    act(SetIsEventActionPossible, TRUE)
    if TRUE == RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        act(SetIsEventActionPossible, FALSE)
        return
    end
    local lower_only = TRUE
    local enable_turn = FALSE
    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end
    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
        act(SetIsEventActionPossible, FALSE)
    end
end

function Event160070_onDeactivate()
    act(SetIsEventActionPossible, FALSE)
end

function Event360070_onActivate()
    ResetEventState()
end

function Event360070_onUpdate()
    act(SetIsEventActionPossible, TRUE)
    if TRUE == env(IsAnimEnd, 0) then
        ExecEventAllBody("W_Stealth_Idle")
        act(SetIsEventActionPossible, FALSE)
        return
    elseif TRUE == EventCommonFunction() then
        act(SetIsEventActionPossible, FALSE)
    end
end

function Event360070_onDeactivate()
    act(SetIsEventActionPossible, FALSE)
end

function Ladder_Activate()
    act(ClearSlopeInfo)
    act(SetIsEquipmentChangeableFromMenu)
    Flag_LadderDamage = LADDER_DAMAGE_NONE
    Flag_LadderJump = LADDER_JUMP_INVALID
    SetThrowInvalid()
end

function Ladder_Update()
    SetThrowInvalid()
    LadderSetActionState(INVALID)
end

function LadderAttachBottom_onUpdate()
    if env(IsObjActInterpolatedMotion) == TRUE then
        return
    else
        ExecEvent("W_LadderStartBottom")
    end
end

function LadderAttachTop_onUpdate()
    if env(IsObjActInterpolatedMotion) == TRUE then
        return
    else
        ExecEvent("W_LadderStartTop")
    end
end

function LadderStartTop_onActivate()
    act(ClearSlopeInfo)
end

function LadderStartTop_onUpdate()
    LadderSetActionState(LADDER_ACTION_START_TOP)
    if LadderMoveCommonFunction(HAND_STATE_LEFT, TRUE) == TRUE then
    end
end

function LadderStartBottom_onActivate()
    act(ClearSlopeInfo)
end

function LadderStartBottom_onUpdate()
    LadderSetActionState(LADDER_ACTION_START_BOTTOM)
    if LadderMoveCommonFunction(HAND_STATE_LEFT, TRUE) == TRUE then
    end
end

function LadderUpRight_onActivate()
    LadderSendCommand(LADDER_CALL_UP)
end

function LadderUpRight_onUpdate()
    LadderSetActionState(LADDER_ACTION_UP_RIGHT)
    if LadderMoveCommonFunction(HAND_STATE_LEFT, FALSE) == TRUE then
    end
end

function LadderUpLeft_onActivate()
    LadderSendCommand(LADDER_CALL_UP)
end

function LadderUpLeft_onUpdate()
    LadderSetActionState(LADDER_ACTION_UP_LEFT)
    if LadderMoveCommonFunction(HAND_STATE_RIGHT, FALSE) == TRUE then
    end
end

function LadderDownLeft_onActivate()
    LadderSendCommand(LADDER_CALL_DOWN)
end

function LadderDownLeft_onUpdate()
    LadderSetActionState(LADDER_ACTION_DOWN_LEFT)
    if LadderMoveCommonFunction(HAND_STATE_RIGHT, FALSE) == TRUE then
    end
end

function LadderDownRight_onActivate()
    LadderSendCommand(LADDER_CALL_DOWN)
end

function LadderDownRight_onUpdate()
    LadderSetActionState(LADDER_ACTION_DOWN_RIGHT)
    if LadderMoveCommonFunction(HAND_STATE_LEFT, FALSE) == TRUE then
    end
end

function LadderEndBottomLeft_onActivate()
    LadderSendCommand(LADDER_EVENT_COMMAND_EXIT)
end

function LadderEndBottomLeft_onUpdate()
    LadderSetActionState(LADDER_ACTION_END_BOTTOM)
    if LadderEndCommonFunction() == TRUE then
    end
end

function LadderEndBottomRight_onActivate()
    LadderSendCommand(LADDER_CALL_DOWN)
end

function LadderEndBottomRight_onUpdate()
    LadderSetActionState(LADDER_ACTION_END_BOTTOM)
    if LadderEndCommonFunction() == TRUE then
    end
end

function LadderEndTopLeft_onActivate()
    LadderSendCommand(LADDER_CALL_UP)
end

function LadderEndTopLeft_onUpdate()
    LadderSetActionState(LADDER_ACTION_END_TOP)
    if LadderEndCommonFunction() == TRUE then
    end
end

function LadderEndTopRight_onActivate()
    LadderSendCommand(LADDER_CALL_UP)
end

function LadderEndTopRight_onUpdate()
    LadderSetActionState(LADDER_ACTION_END_TOP)
    if LadderEndCommonFunction() == TRUE then
    end
end

function LadderIdleLeft_onUpdate()
    LadderSetActionState(LADDER_ACTION_IDLE_LEFT)
    if LadderIdleCommonFunction(HAND_STATE_LEFT) == TRUE then
    end
end

function LadderIdleRight_onUpdate()
    LadderSetActionState(LADDER_ACTION_IDLE_RIGHT)
    if LadderIdleCommonFunction(HAND_STATE_RIGHT) == TRUE then
    end
end

function LadderAttackUpRight_onUpdate()
    LadderSetActionState(LADDER_ACTION_ATTACK_UP_RIGHT)
    if LadderAttackCommonFunction(HAND_STATE_RIGHT) == TRUE then
    end
end

function LadderAttackUpLeft_onUpdate()
    LadderSetActionState(LADDER_ACTION_ATTACK_UP_LEFT)
    if LadderAttackCommonFunction(HAND_STATE_LEFT) == TRUE then
    end
end

function LadderAttackDownRight_onUpdate()
    LadderSetActionState(LADDER_ACTION_ATTACK_DOWN_RIGHT)
    if LadderAttackCommonFunction(HAND_STATE_RIGHT) == TRUE then
    end
end

function LadderAttackDownLeft_onUpdate()
    LadderSetActionState(LADDER_ACTION_ATTACK_DOWN_RIGHT)
    if LadderAttackCommonFunction(HAND_STATE_LEFT) == TRUE then
    end
end

function LadderCoastStart_onUpdate()
    LadderSetActionState(LADDER_ACTION_COAST_START)
    if LadderCoastCommonFunction(HAND_STATE_LEFT, TRUE) == TRUE then
    end
end

function LadderCoastRight_onActivate()
    LadderSendCommand(LADDER_CALL_DOWN)
end

function LadderCoastRight_onUpdate()
    LadderSetActionState(LADDER_ACTION_COAST_RIGHT)
    if LadderCoastCommonFunction(HAND_STATE_LEFT, FALSE) == TRUE then
    end
end

function LadderCoastLeft_onActivate()
    LadderSendCommand(LADDER_CALL_DOWN)
end

function LadderCoastLeft_onUpdate()
    LadderSetActionState(LADDER_ACTION_COAST_LEFT)
    if LadderCoastCommonFunction(HAND_STATE_RIGHT, FALSE) == TRUE then
    end
end

function LadderCoastStopLeft_onUpdate()
    LadderSetActionState(LADDER_ACTION_COAST_STOP)
    if LadderMoveCommonFunction(HAND_STATE_LEFT, FALSE) == TRUE then
    end
end

function LadderCoastStopRight_onUpdate()
    LadderSetActionState(LADDER_ACTION_COAST_STOP)
    if LadderMoveCommonFunction(HAND_STATE_RIGHT, FALSE) == TRUE then
    end
end

function LadderCoastLanding_onActivate()
    LadderSendCommand(LADDER_CALL_DOWN)
end

function LadderCoastLanding_onUpdate()
    LadderSetActionState(LADDER_ACTION_COAST_LANDING)
    if LadderEndCommonFunction() == TRUE then
    end
end

function LadderDamageLargeRight_onUpdate()
    LadderSetActionState(LADDER_ACTION_DAMAGE_LARGE)
    if LadderDamageCommonFunction(HAND_STATE_RIGHT) == TRUE then
    end
end

function LadderDamageSmallRight_onUpdate()
    LadderSetActionState(LADDER_ACTION_DAMAGE_SMALL)
    if LadderDamageCommonFunction(HAND_STATE_RIGHT) == TRUE then
    end
end

function LadderDamageLargeLeft_onUpdate()
    LadderSetActionState(LADDER_ACTION_DAMAGE_LARGE)
    if LadderDamageCommonFunction(HAND_STATE_LEFT) == TRUE then
    end
end

function LadderDamageSmallLeft_onUpdate()
    LadderSetActionState(LADDER_ACTION_DAMAGE_SMALL)
    if LadderDamageCommonFunction(HAND_STATE_LEFT) == TRUE then
    end
end

function LadderDeathStart_onActivate()
    LadderSendCommand(LADDER_EVENT_COMMAND_EXIT)
end

function LadderDeathLoop_onUpdate()
    if env(IsLanding) == TRUE then
        ExecEvent("LadderDeathLand")
    end
    local height = env(GetFallHeight) / 100
    if height > 60 then
        ExecEvent("W_LadderDeathIdle")
    end
end

function LadderDeathIdle_onActivate()
    act(SetDeathStay, TRUE)
end

function LadderDeathIdle_onDeactivate()
    act(SetDeathStay, FALSE)
end

function LadderFallStart_onActivate()
    LadderSendCommand(LADDER_EVENT_COMMAND_EXIT)
end

function LadderFallLoop_onUpdate()
    if FallCommonFunction(TRUE, FALSE, FALL_LADDER) == TRUE then
    end
end

function LadderFallLanding_onUpdate()
    if LandCommonFunction() == TRUE then
    end
end

function LadderDrop_onUpdate()
    act(SetMovementScaleMult, math.random(160, 200) / 100)
    act(SetIsEquipmentChangeableFromMenu)
    if env(IsFalling) == TRUE then
        ExecEventAllBody("W_FallLoop")
    end
end

function Initialize()
    SetBonfireIndex()
    ClearAttackQueue()
    act(AddSpEffect, 6990)
    act(AddSpEffect, 6300)
    if env(IsFemale) == FALSE then
        c_IsFemale = TRUE
    end
end

function SetBonfireIndex()
    SetVariable("IndexBonfire", 0)
end

function SetThrowAtkInvalid()
    act(SetAllowedThrowAttackType, THROW_STATE_INVALID)
end

function SetThrowDefInvalid()
    act(SetAllowedThrowDefenseType, THROW_STATE_INVALID)
end

function SetThrowInvalid()
    act(SetAllowedThrowAttackType, THROW_STATE_INVALID)
    act(SetAllowedThrowDefenseType, THROW_STATE_INVALID)
end

function AddDamageDefault_onUpdate()
    SetVariable("AddDamageBlend", 0)
end

function AddDamageDefaultGuard_onUpdate()
    SetVariable("AddDamageGuardBlend", 0)
end

function SAMagic_Default_onUpdate()
    SetVariable("SAMagicBlendRate", 0)
end

function DamageDirNoAdd_onUpdate()
    SetVariable("DamageDirBlendRate", 0)
end

function AddDamageLv0_Default_onUpdate()
    SetVariable("AddDamageLv0_Blend", 0)
end

function ChangeMoveSpeedIndex(index)
    SetVariable("MoveSpeedIndex", index)
    if index >= 2 then
        SetVariable("MoveSpeedIndexBLR", 1)
    else
        SetVariable("MoveSpeedIndexBLR", index)
    end
end

function SpeedUpdate()
    local stick_level = GetVariable("MoveSpeedLevel")

    GetVariable("MoveAngle")

    local is_aim = env(IsPrecisionShoot)

    GetVariable("IsLockon")

    if is_aim == TRUE then
        if stick_level > 1 then
            stick_level = 1
        end
    elseif env(GetSpEffectID, 100020) == TRUE and stick_level > 1 then
        stick_level = 1
    end

    local speed = GetMoveSpeed(stick_level)

    SetVariable("MoveSpeedLevelReal", speed)

    if env(GetStamina) <= 0 then
        act(AddSpEffect, 100020)
    end

    local weight = math.mod(env(GetMoveAnimParamID), 20)

    if is_aim == TRUE then
        ChangeMoveSpeedIndex(0)
    elseif weight == WEIGHT_OVERWEIGHT then
        ChangeMoveSpeedIndex(0)
    elseif env(GetSpEffectID, 503520) == TRUE then
        ChangeMoveSpeedIndex(0)
    elseif env(GetSpEffectID, 4101) == TRUE then
        ChangeMoveSpeedIndex(0)
    elseif TRUE == g_IsMimicry then
        if stick_level > 1.100000023841858 then
            ResetMimicry()
        else
            ChangeMoveSpeedIndex(0)
        end
    elseif env(GetSpEffectID, 4101) == TRUE then
        if stick_level > 1.100000023841858 then
            ChangeMoveSpeedIndex(1)
        end
    elseif env(GetSpEffectID, 425) == TRUE then
        if stick_level > 1.100000023841858 then
            ChangeMoveSpeedIndex(1)
        end
    elseif env(GetSpEffectID, 100220) == TRUE then
        ChangeMoveSpeedIndex(2)
    else
        local runLevel = 0.6000000238418579

        if GetVariable("IsEnableToggleDashTest") >= 1 and GetVariable("MoveSpeedIndex") >= 1 then
            runLevel = 0.4000000059604645
        end

        -- Sprint (stick + O)
        if stick_level > 1.100000023841858 then
            if env(GetSpEffectID, 100020) == TRUE then
                ChangeMoveSpeedIndex(1)
                SetVariable("ToggleDash", 0)
            else
                act(LockonFixedAngleCancel)
                ChangeMoveSpeedIndex(2)
            end
            -- Normal Walk (stick)
        elseif runLevel < stick_level then
            ChangeMoveSpeedIndex(1)
            if env(GetSpEffectID, 100002) == FALSE and (GetVariable("IsEnableToggleDashTest") >= 2 or env(GetSpEffectID, 100301) == FALSE) then
                SetVariable("ToggleDash", 0)
            end
            -- Stop
        else
            ChangeMoveSpeedIndex(0)
            if env(GetSpEffectID, 100002) == FALSE and (GetVariable("IsEnableToggleDashTest") >= 2 or env(GetSpEffectID, 100301) == FALSE) then
                SetVariable("ToggleDash", 0)
            end
        end
    end

    if env(GetSpEffectID, 100002) == TRUE then
        act(SetStaminaRecoveryDisabled)
    end
end

function GetMoveSpeed(stick_level)
    local speed = GetVariable("MoveSpeedLevelReal")
    local inc_val = ACCELERATION_WALK_SPEED_UP
    local dec_val = ACCELERATION_SPEED_DOWN
    if stick_level == 2 then
        inc_val = ACCELERATION_DASH_SPEED_UP
        dec_val = ACCELERATION_DASH_SPEED_DOWN
    end
    local ret = ConvergeValue(stick_level, speed, inc_val, dec_val)
    return ret
end

function StealthTransitionIndexUpdate()
    local move_speed_level = GetVariable("MoveSpeedLevel")
    local MoveIndex = GetVariable("MoveSpeedIndex")
    if MoveIndex == 2 then
        SetVariable("StealthTransitionIndex", 3)
    elseif MoveIndex == 1 then
        SetVariable("StealthTransitionIndex", 2)
    elseif move_speed_level > 0 then
        SetVariable("StealthTransitionIndex", 1)
    else
        SetVariable("StealthTransitionIndex", 0)
    end
end

function SetThrowDefBlendWeight()
    if env(DoesAnimExist, GetVariable("ThrowID") + 4) == FALSE then
        return
    end
    local regist_num = env(GetThrowDefenseCount)
    local dT = GetDeltaTime()
    local blend_weight = GetVariable("ThrowHoldBlendWeight")
    local is_holding = GetVariable("ThrowHolding")
    local no_regist_time = GetVariable("ThrowNoRegistTime")
    if regist_num > 0 then
        is_holding = true
    end
    if is_holding == true then
        if regist_num <= 0 then
            no_regist_time = no_regist_time + dT
        end
        if no_regist_time > 0.699999988079071 then
            is_holding = false
        else
            blend_weight = blend_weight + 2 * dT
            if blend_weight > 0.9900000095367432 then
                blend_weight = 0.9900000095367432
            end
            SetVariable("IsEnableTAEThrowHold", true)
        end
    else
        no_regist_time = 0
        blend_weight = blend_weight - 4 * dT
        if blend_weight < 0.009999999776482582 then
            blend_weight = 0.009999999776482582
            SetVariable("IsEnableTAEThrowHold", false)
        else
            SetVariable("IsEnableTAEThrowHold", true)
        end
    end
    SetVariable("ThrowHoldBlendWeight", blend_weight)
    SetVariable("ThrowHolding", is_holding)
    SetVariable("ThrowNoRegistTime", no_regist_time)
end

function SetNpcTurnSpeed(turn_speed)
    if env(IsCOMPlayer) == TRUE and turn_speed >= 0 then
        act(SetTurnSpeed, turn_speed)
    end
end

function GetDeltaTime()
    return env(ObtainedDT) / 1000
end

function GetConstVariable()
    c_HasActionRequest = CheckActionRequest()
    c_RollingAngle = env(GetRollAngle) * 0.009999999776482582
    c_ArtsRollingAngle = env(GetSwordArtsRollAngle) * 0.009999999776482582
    c_SwordArtsID, c_SwordArtsHand = GetSwordArtInfo()
    c_IsEnableSwordArts = IsEnableSwordArts()
    c_Style = env(GetWeaponSwitchState)
    c_IsStealth = env(GetSpEffectID, 8001)
end

function GetHalfBlendInfo()
    local blend_type = ALLBODY
    local lower_state = LOWER_IDLE
    if GetLocomotionState() == PLAYER_STATE_MOVE then
        blend_type = UPPER
        lower_state = LOWER_MOVE
    elseif IsLowerQuickTurn() == TRUE then
        if TRUE == ExitQuickTurnLower() then
            lower_state = LOWER_END_TURN
        else
            blend_type = UPPER
            lower_state = LOWER_TURN
        end
    end
    return blend_type, lower_state
end

-------------------------------
-- Main Update
-------------------------------
function Update()
    GetConstVariable()
    SetStyleSpEffect()

    act(SwitchMotion, FALSE)

    if env(ActionDuration, ACTION_ARM_ACTION) > 0 then
        SetThrowAtkInvalid()
    end

    SetVariable("EyeBlinkBlend", 1 - g_TimeActEditor_11)

    act(LockonSystemUnableToTurnAngle, 0, 0)

    if env(IsOnMount) == TRUE then
        act(LockonFixedAngleCancel)
        if env(GetSpiritspringJumpHeight) > 0 or env(GetSpEffectID, 183) == TRUE then
            act(AddSpEffect, 185)
        end
    end

    SetVariable("LocomotionState", GetLocomotionState())

    SetMoveType()

    ChangeWaistTwist(-10, 0, -20, 0)

    if TRUE == IsLowerQuickTurn() then
        SetVariable("LookAtTwist30_OnGain", 1)
    else
        SetVariable("LookAtTwist30_OnGain", 0.10000000149011612)
    end

    GreyOutSwordArtFE()
    SetArtCancelType()

    if GetVariable("IsKeepAttackQueue") == false then
        ClearAttackQueue()
    end

    if c_Style == HAND_LEFT_BOTH then
        SetVariable("IndexHandBothStyle", 1)
    else
        SetVariable("IndexHandBothStyle", 0)
    end

    GetTimeActEditorVariable()
    UpdatePostureTwist()

    g_IsMimicry = env(GetSpEffectID, 503040)

    if FALSE == g_EnableMimicry and TRUE == g_IsMimicry then
        ResetMimicry()
    end

    g_EnableMimicry = FALSE

    if env(GetSpEffectID, 503317) == TRUE then
        if env(GetSpEffectID, 503315) == TRUE then
            act(AddSpEffect, 503312)
        elseif env(GetSpEffectID, 9642) == TRUE then
        else
            act(AddSpEffect, 503313)
        end
    end

    g_FrameCount = g_FrameCount + 1
end

function CopyLocalMatrix(source, dest)
    local sourceMatrix = hkbGetBoneLocalSpace(source)
    hkbSetBoneLocalSpace(dest, sourceMatrix)
end

function CopyModelMatrix(source, dest)
    local sourceMatrix = hkbGetBoneModelSpace(source)
    hkbSetBoneModelSpace(dest, sourceMatrix)
end

function CalculateFootTarget2(source, YaxisOffset, dest)
    local sourceMatrix = hkbGetBoneModelSpace(dest)
    local f977_local0 = hkbGetBoneModelSpace(source)
    local sourcePosition = f977_local0:getTranslation()
    sourcePosition[1] = sourcePosition[1] + YaxisOffset
    sourceMatrix:setTranslation(sourcePosition)
    hkbSetBoneModelSpace(dest, sourceMatrix)
end

function Master_Layer_onGenerate()
    local offset = 0.8659999966621399
    CalculateFootTarget2("L_Foot", offset, "L_Foot_Target2")
    CopyModelMatrix("L_Foot", "L_Foot_Target")
    CalculateFootTarget2("R_Foot", offset, "R_Foot_Target2")
    CopyModelMatrix("R_Foot", "R_Foot_Target")
end

function ModifiersLayer_onGenerate()
    CopyLocalMatrix("Neck", "Collar")
end

----------------------------------------
-- Torrent
----------------------------------------
RIDE_MOVE_TYPE_IDLE = 0
RIDE_MOVE_TYPE_WALK = 1
RIDE_MOVE_TYPE_RUN = 2
RIDE_MOVE_TYPE_DASH = 3
RIDE_MOVE_TYPE_GALLOP = 4
RIDE_MOVE_TYPE_OTHER = 10
RIDE_ISENABLE_DOUBLEJUMP = TRUE

function Ride_Activate()
end

function Ride_Update()
    if IsEnableFeedAddBlend == TRUE then
        Ride_Feed_Rate = 1
        act(ApplyRideBlend, "Ride_Feed_AddBlend", 1)
    else
        Ride_Feed_Rate = ConvergeValue(0, Ride_Feed_Rate, 4, 4)
        act(ApplyRideBlend, "Ride_Feed_AddBlend", Ride_Feed_Rate)
    end

    if RIDE_ISENABLE_DOUBLEJUMP == FALSE and env(IsMountInFallLoop) == TRUE then
        RIDE_ISENABLE_DOUBLEJUMP = TRUE
    end
end

function Ride_Deactivate()
    if IsNodeActive("Jump_RideOff LayerGenerator") == FALSE then
        act(Unknown3005)
    end
end

function Ride_NoThrow_Activate()
    SetThrowInvalid()
end

function Ride_NoThrow_Update()
    SetThrowInvalid()

    local hand = HAND_RIGHT

    if c_Style == HAND_LEFT_BOTH then
        hand = HAND_LEFT
    end

    SetAttackHand(hand)
    SetGuardHand(hand)
end

function ExecRide()
    if env(IsSummoningRide) == TRUE then
        SetVariable("RideOnSummonTest", 1)
        FireRideEvent("W_RideOn", "W_RideOn", FALSE)
        return TRUE
    elseif env(ActionRequest, ACTION_ARM_RIDEON) == TRUE then
        act(Unknown3000)

        return TRUE
    else
        return FALSE
    end
end

function FireRideEvent(upper_event, lower_event, lower_only)
    if lower_only == TRUE then
        act(PlayRideAnim, lower_event)
    else
        ExecEventAllBody(upper_event)
        act(PlayRideAnim, lower_event)
    end
end

function FireRideEventNoReset(upper_event, lower_event, lower_only)
    if lower_only == TRUE then
        act(PlayRideAnim, lower_event)
    else
        ExecEventNoReset(upper_event)
        act(PlayRideAnim, lower_event)
    end
end

-- Torrent Dismount
function ExecRideOff(is_force, rideOffAnyway)
    if is_force == FALSE and FALSE == env(ActionRequest, ACTION_ARM_L3) then
        return FALSE
    elseif is_force == FALSE and (env(GetGeneralTAEFlag, TAE_FLAG_CHARGING) == 1 or env(GetSpEffectID, 100280) == TRUE) then
        ResetRequest()
        return FALSE
    end

    local unhorseDir = -1

    if env(GetMountReceivedDamageDirection, 2) == TRUE then
        unhorseDir = 2
    elseif env(GetMountReceivedDamageDirection, 3) == TRUE then
        unhorseDir = 3
    elseif env(GetMountReceivedDamageDirection, 1) == TRUE then
        unhorseDir = 1
    end

    if unhorseDir < 0 then
        if rideOffAnyway == FALSE then
            return FALSE
        end
        unhorseDir = 2
    end

    local event = "W_RideOff"
    local event_under = "W_RideOff"

    if GetVariable("MoveSpeedLevel") >= 0.8999999761581421 and rideOffAnyway ~= TRUE then
        event = "W_Jump_RideOff"

        if GetVariable("MoveSpeedLevel") >= 1.5 or 1 <= GetVariable("ToggleDash") then
            event_under = "W_RideOffGallop"
            SetVariable("RideOff_Jump_Speed", 1)
        else
            event_under = "W_RideOffDash"
            SetVariable("RideOff_Jump_Speed", 0)
        end

        local style = c_Style

        if style == HAND_RIGHT then
            SetVariable("JumpAttack_HandCondition", 0)
        elseif style == HAND_RIGHT_BOTH then
            SetVariable("JumpAttack_HandCondition", 1)
        elseif style == HAND_LEFT_BOTH then
            if TRUE == GetEquipType(HAND_LEFT, WEAPON_CATEGORY_CROSSBOW) then
                SetVariable("JumpAttack_HandCondition", 4)
            else
                SetVariable("JumpAttack_HandCondition", 1)
            end
        end

        SetVariable("JumpAttackForm", 0)
        SetVariable("JumpUseMotion_Bool", false)
        SetVariable("JumpMotion_Override", 0.009999999776482582)
        SetVariable("JumpAttack_Land", 0)
        SetVariable("SwingPose", 0)
        SetVariable("IsEnableDirectionJumpTAE", true)

        if 2 == GetVariable("IsEnableToggleDashTest") then
            SetVariable("ToggleDash", 0)
        end
    elseif unhorseDir == 2 then
        SetVariable("Int16Variable02", 0)
    elseif unhorseDir == 3 then
        SetVariable("Int16Variable02", 1)
    elseif unhorseDir == 1 then
        SetVariable("Int16Variable02", 2)
    end

    FireRideEvent(event, event_under, FALSE)

    return TRUE
end

function RideReActionFunction()
    local isEnableForceRideOff = FALSE

    if env(Unknown368) == TRUE then
        if env(Unknown548) == TRUE and env(Unknown555) == TRUE and env(IsMountInFallLoop) == TRUE then
            isEnableForceRideOff = TRUE
        end
    elseif (env(Unknown548) == TRUE or env(Unknown365) == TRUE or env(Unknown362, 433) == TRUE) and env(Unknown555) == TRUE and env(IsMountInFallLoop) == TRUE then
        isEnableForceRideOff = TRUE
    end

    if isEnableForceRideOff == TRUE then
        ExecRideOff(TRUE, TRUE)
        act(AddSpEffect, 181)
        return TRUE
    elseif TRUE == ExecRideDeath() then
        return TRUE
    elseif TRUE == ExecRideDamage() then
        return TRUE
    elseif TRUE == ExecRideEventAnim() then
        return TRUE
    else
        return FALSE
    end
end

function ExecRideDeath()
    if env(GetDamageSpecialAttribute, 3) == TRUE then
        SetVariable("IndexRideDeath", RIDE_DEATH_TYPE_STONE)
        FireRideEvent("W_RideDeath", "W_RideDeath", FALSE)

        return TRUE
    elseif env(GetHP) <= 0 then

        if env(GetDamageSpecialAttribute, 6) == TRUE or env(GetSpecialAttribute) == 25 then
            SetVariable("IndexRideDeath", RIDE_DEATH_TYPE_MAD)
        else
            SetVariable("IndexRideDeath", RIDE_DEATH_TYPE_COMMON)
        end

        FireRideEvent("W_RideDeath", "W_RideDeath", FALSE)

        return TRUE
    elseif env(IsMountDead) <= 0 then
        FireRideEvent("W_RideDamage_Fall", "W_RideDeath", FALSE)

        return TRUE
    else
        return FALSE
    end
end

function ExecRideDamage()
    local damage_level = env(GetDamageLevel)
    local damage_type = env(GetReceivedDamageType)
    local is_damaged = env(HasReceivedAnyDamage)
    local damage_angle = env(GetReceivedDamageDirection)
    local damage_level_under = env(GetMountDamageLevel)
    local damage_type_under = env(GetMountRecievedDamageType)
    local is_damaged_under = env(HasMountReceivedAnyDamage)
    local damage_angle_under = env(GetMountRecievedDamageAngle)

    if damage_type == DAMAGE_TYPE_PARRY then
        FireRideEvent("W_RideDamage_Fall", "W_RideRun_End", FALSE)

        return TRUE
    elseif damage_type == DAMAGE_TYPE_WALL_RIGHT or damage_type == DAMAGE_TYPE_WALL_LEFT then
        if GetVariable("RideAttackHand") == HAND_LEFT then
            SetVariable("GuardDamageIndex", 2)
        else
            SetVariable("GuardDamageIndex", 0)
        end

        ExecEventAllBody("W_RideRepelledWall")
        return TRUE
    elseif damage_type == DAMAGE_TYPE_GUARDED or damage_type == DAMAGE_TYPE_GUARDED_LEFT then
        Replanning()

        if GetVariable("RideAttackHand") == HAND_LEFT then
            SetVariable("GuardDamageIndex", 2)
        else
            SetVariable("GuardDamageIndex", 0)
        end

        if damage_level == DAMAGE_LEVEL_NONE or damage_level == DAMAGE_LEVEL_MINIMUM or damage_level == DAMAGE_LEVEL_SMALL then
            SetVariable("DamageDirection", 2)
            act(SetDamageAnimType, DAMAGE_FLAG_SMALL)
            ExecEventAllBody("W_RideRepelledSmall")
            return TRUE
        else
            act(SetDamageAnimType, DAMAGE_FLAG_LARGE)
            SetVariable("DamageDirection", 2)
            ExecEventAllBody("W_RideRepelledLarge")
            return TRUE
        end
    elseif damage_type == DAMAGE_TYPE_GUARD then
        if env(GetSpEffectID, 175) == TRUE then
            return FALSE
        elseif env(GetSpEffectID, 176) == TRUE then
            return FALSE
        else
            FireRideEvent("W_Ride_SA_Add_Guard", "W_Ride_SA_Add", FALSE)
            SetVariable("Ride_SA_Add_Blend", 1)
            act(ApplyRideBlend, "Ride_SA_Add_Blend", 1)

            return FALSE
        end
    elseif damage_type == DAMAGE_TYPE_GUARDBREAK then
        act(SetDamageAnimType, DAMAGE_FLAG_LARGE)
        SetVariable("DamageDirection", 2)
        ExecEventAllBody("W_RideRepelledLarge")

        return TRUE
    elseif env(IsMountFalling) == TRUE then
        FireRideEvent("W_RideFall_Start", "W_RideFall_Start", FALSE)

        return TRUE
    elseif env(Unknown400) <= 0 and (damage_level > DAMAGE_LEVEL_NONE or damage_level_under > DAMAGE_LEVEL_NONE) and (is_damaged == TRUE or is_damaged_under == TRUE) then
        FireRideEvent("W_RideDamage_Fall", "W_RideRun_End", FALSE)

        return TRUE
    elseif env(GetDamageSpecialAttribute, 5) == TRUE then
        FireRideEvent("W_RideDamage_Fall", "W_RideRun_End", FALSE)

        return TRUE
    elseif env(GetDamageSpecialAttribute, 6) == TRUE then
        FireRideEvent("W_RideDamageMad", "W_RideRun_End", FALSE)
        Replanning()

        return TRUE
    elseif (env(GetSpecialAttribute) == 5 or env(GetMountSpecialAttribute) == 5) and GetVariable("MoveSpeedLevel") > 1.5 then
        SetVariable("DamageDirection", 2)
        act(ApplyRideBlend, "DamageDirection", 2)
        SetVariable("RideDamageDefaultState", 1)
        act(ApplyRideBlend, "RideDamageDefaultState", 1)
        act(ApplyDamageFlag, DAMAGE_FLAG_MIDDLE)
        Replanning()
        FireRideEvent("W_RideDamageMiddle", "W_Ride_DamageMiddle", FALSE)

        return TRUE
    elseif env(GetSpecialAttribute) == 8 or env(GetMountSpecialAttribute) == 8 then
        SetVariable("DamageDirection", 2)
        act(ApplyRideBlend, "DamageDirection", 2)
        SetVariable("RideDamageDefaultState", 1)
        act(ApplyRideBlend, "RideDamageDefaultState", 1)
        act(ApplyDamageFlag, DAMAGE_FLAG_MIDDLE)
        Replanning()
        FireRideEvent("W_RideDamageMiddle", "W_Ride_DamageMiddle", FALSE)

        return TRUE
    elseif env(GetDamageSpecialAttribute, 2) == TRUE or env(GetDamageSpecialAttribute, 4) == TRUE then
        if damage_level == DAMAGE_LEVEL_NONE then
            damage_level = DAMAGE_LEVEL_SMALL
        elseif damage_level ~= DAMAGE_LEVEL_SMALL and damage_level ~= DAMAGE_LEVEL_MIDDLE and damage_level == DAMAGE_LEVEL_MINIMUM then

        else

        end
    end

    if damage_level <= DAMAGE_LEVEL_NONE and damage_level_under <= DAMAGE_LEVEL_NONE and (not (is_damaged ~= FALSE or is_damaged_under ~= FALSE) or env(IsPartDamageAdditiveBlendInvalid) == TRUE) and (damage_type == DAMAGE_TYPE_INVALID or damage_type == DAMAGE_TYPE_WEAK_POINT or damage_type == DAMAGE_LEVEL_MINIMUM) and (damage_type_under == DAMAGE_TYPE_INVALID or damage_type_under == DAMAGE_TYPE_WEAK_POINT or damage_type_under == DAMAGE_LEVEL_MINIMUM) then
        return FALSE
    end

    SetVariable("BlendRideDamageFire", 0)
    act(ApplyRideBlend, "BlendRideDamageFire", 0)
    SetVariable("Ride_SA_Add_Blend", 0)
    act(ApplyRideBlend, "Ride_SA_Add_Blend", 0)

    if env(GetSpecialAttribute) == 5 or env(GetSpecialAttribute) == 8 or env(GetMountSpecialAttribute) == 5 or env(GetMountSpecialAttribute) == 8 then
        return FALSE
    elseif env(GetIsWeakPoint) == TRUE then
        SetVariable("DamageDirection", 2)
        act(ApplyRideBlend, "DamageDirection", 2)
        act(ApplyDamageFlag, DAMAGE_FLAG_WEAK)
        FireRideEvent("W_RideDamageWeakTop", "W_Ride_DamageWeakTop", FALSE)
        Replanning()

        return TRUE
    elseif env(GetMountIsWeakPoint) == TRUE then
        SetVariable("DamageDirection", 2)
        act(ApplyRideBlend, "DamageDirection", 2)
        act(ApplyDamageFlag, DAMAGE_FLAG_WEAK)
        FireRideEvent("W_RideDamageWeakUnder", "W_Ride_DamageWeakUnder", FALSE)
        Replanning()

        return TRUE
    elseif damage_level == DAMAGE_LEVEL_EXLARGE or damage_level == DAMAGE_LEVEL_SMALL_BLOW or damage_level == DAMAGE_LEVEL_UPPER or damage_level == DAMAGE_LEVEL_EX_BLAST or damage_level == DAMAGE_LEVEL_BREATH or damage_level_under == DAMAGE_LEVEL_EXLARGE or damage_level_under == DAMAGE_LEVEL_SMALL_BLOW or damage_level_under == DAMAGE_LEVEL_UPPER or damage_level_under == DAMAGE_LEVEL_EX_BLAST or damage_level_under == DAMAGE_LEVEL_BREATH then
        local damage_angle_real = damage_angle

        if damage_level <= DAMAGE_LEVEL_NONE then
            damage_angle_real = damage_angle_under
        end

        SetVariable("DamageDirection", damage_angle_real)
        act(ApplyRideBlend, "DamageDirection", damage_angle_real)
        act(ApplyDamageFlag, DAMAGE_FLAG_LARGE_BLOW)
        FireRideEvent("W_RideDamageExLarge", "W_Ride_DamageExLarge", FALSE)
        Replanning()

        return TRUE
    elseif damage_level == DAMAGE_LEVEL_LARGE or damage_level == DAMAGE_LEVEL_FLING or damage_level_under == DAMAGE_LEVEL_LARGE or damage_level_under == DAMAGE_LEVEL_FLING then
        if env(GetSpecialAttribute) == DAMAGE_ELEMENT_FIRE or env(GetMountSpecialAttribute) == DAMAGE_ELEMENT_FIRE then
            SetVariable("BlendRideDamageFire", 1)
            act(ApplyRideBlend, "BlendRideDamageFire", 1)
            act(ApplyRideBlend, "IndexFireRideDamageVariation", 0)
            FireRideEvent("W_RideFireMiddleDamageBlend_Add", "W_Ride_FireMiddleDamageBlend_Add", FALSE)
        end

        SetVariable("DamageDirection", 2)
        act(ApplyRideBlend, "DamageDirection", 2)
        SetVariable("RideDamageDefaultState", 2)
        act(ApplyRideBlend, "RideDamageDefaultState", 2)
        act(ApplyDamageFlag, DAMAGE_FLAG_LARGE)
        FireRideEvent("W_RideDamageLarge", "W_Ride_DamageLarge", FALSE)
        Replanning()

        return TRUE
    elseif damage_level == DAMAGE_LEVEL_MIDDLE or damage_level == DAMAGE_LEVEL_PUSH or damage_level_under == DAMAGE_LEVEL_MIDDLE or damage_level_under == DAMAGE_LEVEL_PUSH then
        if env(GetSpecialAttribute) == DAMAGE_ELEMENT_FIRE or env(GetMountSpecialAttribute) == DAMAGE_ELEMENT_FIRE then
            SetVariable("BlendRideDamageFire", 1)
            act(ApplyRideBlend, "BlendRideDamageFire", 1)
            act(ApplyRideBlend, "IndexFireRideDamageVariation", 0)
            FireRideEvent("W_RideFireMiddleDamageBlend_Add", "W_Ride_FireMiddleDamageBlend_Add", FALSE)
        end

        SetVariable("DamageDirection", 2)
        act(ApplyRideBlend, "DamageDirection", 2)
        SetVariable("RideDamageDefaultState", 1)
        act(ApplyRideBlend, "RideDamageDefaultState", 1)
        act(ApplyDamageFlag, DAMAGE_FLAG_MEDIUM)
        FireRideEvent("W_RideDamageMiddle", "W_Ride_DamageMiddle", FALSE)
        Replanning()

        return TRUE
    elseif damage_level == DAMAGE_LEVEL_SMALL or damage_level_under == DAMAGE_LEVEL_SMALL then
        if env(GetSpecialAttribute) == DAMAGE_ELEMENT_FIRE or env(GetMountSpecialAttribute) == DAMAGE_ELEMENT_FIRE then
            SetVariable("BlendRideDamageFire", 1)
            act(ApplyRideBlend, "BlendRideDamageFire", 1)
            act(ApplyRideBlend, "IndexFireRideDamageVariation", 0)
            FireRideEvent("W_RideFireSmallDamageBlend_Add", "W_Ride_FireSmallDamageBlend_Add", FALSE)
        end

        SetVariable("DamageDirection", 2)
        act(ApplyRideBlend, "DamageDirection", 2)
        SetVariable("RideDamageDefaultState", 0)
        act(ApplyRideBlend, "RideDamageDefaultState", 0)
        act(ApplyDamageFlag, DAMAGE_FLAG_SMALL)
        FireRideEvent("W_RideDamageSmall", "W_Ride_DamageSmall", FALSE)
        Replanning()

        return TRUE
    elseif damage_level == DAMAGE_LEVEL_NONE or damage_level == DAMAGE_LEVEL_MINIMUM or damage_level_under == DAMAGE_LEVEL_NONE or damage_level_under == DAMAGE_LEVEL_MINIMUM then
        local index = 0

        SetVariable("IndexRide_SA_Add_Random", index)
        act(ApplyRideBlend, "IndexRide_SA_Add_Random", index)
        act(ApplyDamageFlag, DAMAGE_FLAG_MINIMUM)
        FireRideEvent("W_Ride_SA_Add", "W_Ride_SA_Add", FALSE)
        SetVariable("Ride_SA_Add_Blend", 1)
        act(ApplyRideBlend, "Ride_SA_Add_Blend", 1)
    end

    return FALSE
end

function RideFallCommonFunction()
    local damage_type = env(GetReceivedDamageType)

    if damage_type == DAMAGE_TYPE_DEATH_FALLING and env(GetSpEffectID, 185) == FALSE then
        FireRideEvent("W_RideDeath", "W_RideDeath", FALSE)
        return TRUE
    elseif env(ActionRequest, 6) == TRUE and env(GetSpEffectID, 100902) == TRUE and RIDE_ISENABLE_DOUBLEJUMP == TRUE then
        local height = env(GetMountFallHeight) / 100

        if env(GetStamina) <= 0 or height > DISABLEJUMP_FALLDIST then
            ResetRequest()
        else
            act(ChangeStamina, STAMINA_REDUCE_RIDE_JUMP)

            if GetVariable("MoveSpeedLevel") >= 1.5 then
                FireRideEvent("W_RideJump2_D", "W_RideJump2_D", FALSE)
            elseif GetVariable("MoveSpeedLevel") >= 0.6000000238418579 then
                FireRideEvent("W_RideJump2_F", "W_RideJump2_F", FALSE)
            else
                FireRideEvent("W_RideJump2_N", "W_RideJump2_N", FALSE)
            end
        end

        RIDE_ISENABLE_DOUBLEJUMP = FALSE

        return TRUE
    else
        return FALSE
    end
end

function RideRequestFunction(ride_move_type, enable_turn, lower_only)
    if env(IsOnMount) == FALSE then
        act(Unknown3005)
        ExecEventAllBody("W_Idle")

        return TRUE
    elseif enable_turn == TRUE then
        if GetVariable("MoveSpeedLevel") >= 0.8999999761581421 then
            SetVariable("Int16Variable01", 1)
        else
            SetVariable("Int16Variable01", 0)
        end

        local turn_angle = GetVariable("TurnAngle")

        if math.abs(turn_angle) >= 135 and 0 == RIDE_TURN_STATE then
            if turn_angle < 0 then
                FireRideEvent("W_RideTurn_Left180", "W_RideTurn_Left180", FALSE)
            else
                FireRideEvent("W_RideTurn_Right180", "W_RideTurn_Right180", FALSE)
            end

            return TRUE
        end
    end

    if ExecRideStop(ride_move_type, lower_only) == TRUE then
        if lower_only == FALSE then
            return TRUE
        else
            return FALSE
        end
    end

    local move_speed_level = GetVariable("MoveSpeedLevel")
    local move_angle = GetVariable("MoveAngle")
    local next_ride_move_type = RIDE_MOVE_TYPE_IDLE

    -- Out of Stamina: limit move speed
    if env(GetSpEffectID, 100020) == TRUE and move_speed_level > 1 then
        move_speed_level = 1
    end

    if math.abs(move_angle) <= 45 then
        -- Gallop
        if move_speed_level > 1.5 or GetVariable("IsEnableToggleDashTest") >= 1 and GetVariable("ToggleDash") == 1 and GetVariable("MoveSpeedLevel") >= 0.8999999761581421 then
            next_ride_move_type = RIDE_MOVE_TYPE_GALLOP
            -- Dash
        elseif move_speed_level > 0.6000000238418579 then
            next_ride_move_type = RIDE_MOVE_TYPE_DASH
            -- Walk
        elseif move_speed_level > 0 then
            next_ride_move_type = RIDE_MOVE_TYPE_WALK
            -- Idle
        else
            next_ride_move_type = RIDE_MOVE_TYPE_IDLE
        end
    end

    if ride_move_type ~= next_ride_move_type or env(GetMountSpEffectID, 101008) == TRUE then
        if next_ride_move_type == RIDE_MOVE_TYPE_IDLE then
            if GetVariable("IsEnableToggleDashTest") == 4 then
                SetVariable("ToggleDash", 0)
            end

            if env(GetMountSpEffectID, 101005) == FALSE and env(GetMountSpEffectID, 101006) == FALSE and env(GetMountSpEffectID, 101007) == FALSE then
                FireRideEvent("W_RideIdle", "W_RideIdle", lower_only)
            else
                return FALSE
            end
        elseif next_ride_move_type == RIDE_MOVE_TYPE_WALK then
            if GetVariable("IsEnableToggleDashTest") == 4 then
                SetVariable("ToggleDash", 0)
            end

            FireRideEvent("W_RideWalk", "W_RideWalk", lower_only)
        elseif next_ride_move_type == RIDE_MOVE_TYPE_DASH then
            if env(GetSpEffectID, 100901) == TRUE and (ride_move_type == RIDE_MOVE_TYPE_IDLE or ride_move_type == RIDE_MOVE_TYPE_OTHER) and lower_only == TRUE then
                FireRideEvent("W_RideDash", "W_RideRun", lower_only)
            else
                FireRideEvent("W_RideDash", "W_RideDash", lower_only)
            end
        elseif env(GetSpEffectID, 100901) == TRUE and (ride_move_type == RIDE_MOVE_TYPE_IDLE or ride_move_type == RIDE_MOVE_TYPE_OTHER) and lower_only == TRUE then
            FireRideEvent("W_RideDash", "W_RideRun", lower_only)
        else
            FireRideEvent("W_RideGallop", "W_RideGallop", lower_only)
        end

        if lower_only == FALSE then
            return TRUE
        end
    end

    return FALSE
end

function ExecRideStop(ride_move_type, lower_only)
    local move_speed_level = GetVariable("MoveSpeedLevel")

    if move_speed_level > 0 then
        return FALSE
    elseif env(GetMountSpEffectID, 101005) == TRUE or env(GetMountSpEffectID, 101006) == TRUE or env(GetMountSpEffectID, 101007) == TRUE then
        return FALSE
    end

    local stop_speed_type = ride_move_type

    if ride_move_type == RIDE_MOVE_TYPE_IDLE or ride_move_type == RIDE_MOVE_TYPE_OTHER then
        if env(GetMountSpEffectID, 101000) == TRUE then
            stop_speed_type = RIDE_MOVE_TYPE_WALK
        elseif env(GetMountSpEffectID, 101001) == TRUE then
            stop_speed_type = RIDE_MOVE_TYPE_DASH
        elseif env(GetMountSpEffectID, 101002) == TRUE then
            stop_speed_type = RIDE_MOVE_TYPE_GALLOP
        end
    end

    if stop_speed_type == RIDE_MOVE_TYPE_IDLE or stop_speed_type == RIDE_MOVE_TYPE_OTHER then
        return FALSE
    elseif stop_speed_type == RIDE_MOVE_TYPE_WALK then
        FireRideEvent("W_RideWalk_End", "W_RideWalk_End", lower_only)
    elseif stop_speed_type == RIDE_MOVE_TYPE_DASH then
        FireRideEvent("W_RideDash_End", "W_RideDash_End", lower_only)
    else
        FireRideEvent("W_RideGallop_End", "W_RideGallop_End", lower_only)
    end

    return TRUE
end

function ExecRideAttack(r1, r2, l1, l2)
    local attackHand = HAND_RIGHT

    if c_Style == HAND_LEFT_BOTH then
        attackHand = HAND_LEFT
    end

    local is_arrow = GetEquipType(attackHand, WEAPON_CATEGORY_SMALL_ARROW, WEAPON_CATEGORY_ARROW, WEAPON_CATEGORY_CROSSBOW)
    local is_staff = GetEquipType(attackHand, WEAPON_CATEGORY_STAFF)

    if env(ActionDuration, ACTION_ARM_ACTION) > 0 then
        return FALSE
    elseif env(GetStamina) < 0 then
        ResetRequest()
        return FALSE
    elseif not (env(ActionRequest, ACTION_ARM_R1) ~= TRUE or is_staff ~= FALSE) or env(ActionRequest, ACTION_ARM_R2) == TRUE and is_staff == TRUE then
        act(ResetInputQueue)
        SetVariable("RideAttackHand", HAND_RIGHT)

        if is_arrow == TRUE then
            if GetEquipType(attackHand, WEAPON_CATEGORY_CROSSBOW) == TRUE and env(GetBoltLoadingState, attackHand) == FALSE then
                if attackHand == HAND_LEFT then
                    ExecEventAllBody("W_RideAttackCrossbowLeftReload")
                else
                    ExecEventAllBody("W_RideAttackCrossbowRightReload")
                end

                return TRUE
            else
                g_ArrowSlot = 0
                act(ChooseBowAndArrowSlot, 0)

                if env(IsOutOfAmmo, attackHand) == TRUE then
                    ExecEventAllBody("W_RideNoArrow")

                    return TRUE
                else
                    ExecEventAllBody("W_RideAttackArrowStart")

                    return TRUE
                end
            end
        end

        ExecEventAllBody(r1)
    elseif env(ActionRequest, ACTION_ARM_R2) == TRUE then
        act(ResetInputQueue)
        SetVariable("RideAttackHand", HAND_RIGHT)

        if is_arrow == TRUE then
            if GetEquipType(attackHand, WEAPON_CATEGORY_CROSSBOW) == TRUE and env(GetBoltLoadingState, attackHand) == FALSE then
                if attackHand == HAND_LEFT then
                    ExecEventAllBody("W_RideAttackCrossbowLeftReload")
                else
                    ExecEventAllBody("W_RideAttackCrossbowRightReload")
                end
                return TRUE
            else
                g_ArrowSlot = 1
                act(ChooseBowAndArrowSlot, 1)
                if env(IsOutOfAmmo, attackHand) == TRUE then
                    ExecEventAllBody("W_RideNoArrow")
                    return TRUE
                else
                    ExecEventAllBody("W_RideAttackArrowStart")
                    return TRUE
                end
            end
        elseif GetEquipType(attackHand, WEAPON_CATEGORY_STAFF) == TRUE then
            return FALSE
        end

        ExecEventAllBody(r2)
    elseif env(ActionRequest, ACTION_ARM_L1) == TRUE or env(ActionRequest, ACTION_ARM_L2) == TRUE and is_staff == TRUE then
        act(ResetInputQueue)
        SetVariable("RideAttackHand", HAND_LEFT)

        if is_arrow == TRUE then
            return FALSE
        end

        ExecEventAllBody(l1)
    elseif env(ActionRequest, ACTION_ARM_L2) == TRUE then
        act(ResetInputQueue)
        SetVariable("RideAttackHand", HAND_LEFT)

        if is_arrow == TRUE then
            return FALSE
        end

        ExecEventAllBody(l2)
    else
        return FALSE
    end

    SetInterruptType(INTERRUPT_FINDATTACK)

    return TRUE
end

function ExecRideItem()
    if c_HasActionRequest == FALSE then
        return FALSE
    elseif FALSE == env(ActionRequest, ACTION_ARM_USE_ITEM) then
        return FALSE
    elseif env(IsItemUseMenuOpened) == TRUE then
        return FALSE
    elseif env(IsItemUseMenuOpening) == TRUE then
        ResetRequest()
        act(OpenMenuWhenUsingItem)

        return TRUE
    end

    act(UseItemDecision)

    local item_type = env(GetItemAnimType)
    local is_combo = env(GetSpEffectID, 100800)

    if is_combo == TRUE and item_type ~= ITEM_NIGHT_BELL then
        return FALSE
    end

    local pre_item_type = GetVariable("PreItemType")
    SetVariable("PreItemType", item_type)

    if item_type == ITEM_DRINK then
        if env(GetStateChangeType, CONDITION_TYPE_NO_EST) == TRUE then
            ExecEventAllBody("W_RideItemDrinkNothing")
        elseif TRUE == IsNodeActive("RideItemDrinking_CMSG") and pre_item_type == ITEM_DRINK then
            ExecEventAllBody("W_RideItemDrinking")
        else
            ExecEventAllBody("W_RideItemDrinkStart")
        end
    elseif item_type == ITEM_DRINK_MP then
        if env(GetStateChangeType, CONDITION_TYPE_NO_EST) == TRUE then
            ExecEventAllBody("W_RideItemDrinkNothing")
        elseif TRUE == IsNodeActive("RideItemDrinking_CMSG") and pre_item_type == ITEM_DRINK_MP then
            ExecEventAllBody("W_RideItemDrinking")
        else
            ExecEventAllBody("W_RideItemDrinkStart")
        end
    elseif item_type == ITEM_SUMMONHORSE then
        ExecRideOff(TRUE, FALSE)
    elseif item_type == ITEM_MEGANE then
        if env(GetStateChangeType, 15) == TRUE then
            ExecEventAllBody("W_RideItemMeganeEnd")
        else
            ExecEventAllBody("W_RideItemMeganeStart")
        end
    elseif item_type == 27 then
        if env(GetSpEffectID, 3245) == TRUE then
            ExecEventAllBody("W_RideItemLanternOff")
        else
            SetVariable("IndexItemUseAnim", item_type)
            ExecEventAllBody("W_RideItemOneShot")
        end
    elseif item_type == ITEM_ELIXIR then
        ExecEventAllBody("W_RideItemElixir")
    elseif item_type == ITEM_QUICK_THROW_KNIFE then
        if TRUE == IsNodeActive("RideItemQuick1_CMSG") or TRUE == IsNodeActive("RideItemQuick3_CMSG") then
            ExecEventAllBody("W_RideItemQuick2")
        elseif TRUE == IsNodeActive("RideItemQuick2_CMSG") then
            ExecEventAllBody("W_RideItemQuick3")
        else
            ExecEventAllBody("W_RideItemQuick1")
        end
    elseif item_type == ITEM_NIGHT_BELL then
        if is_combo == TRUE then
            ExecEventAllBody("W_RideItemCombo")
        else
            SetVariable("IndexItemUseAnim", item_type)
            ExecEventAllBody("W_RideItemOneShot")
        end
    elseif item_type == ITEM_NO_DRINK then
        if TRUE == IsNodeActive("RideItemDrinking_CMSG") then
            ExecEventAllBody("W_RideItemDrinkEmpty")
        else
            ExecEventAllBody("W_RideItemDrinkStart")
        end
    elseif item_type == ITEM_INVALID then
        ExecEventAllBody("W_RideItemInvalid")
    else
        SetVariable("IndexItemUseAnim", item_type)
        ExecEventAllBody("W_RideItemOneShot")
    end

    act(ApplyRideBlend, "Ride_Feed_AddBlend", 0)
    act(SetIsItemAnimationPlaying)
    act(Unknown2025, env(Unknown404))
    SetAIActionState()

    return TRUE
end

function ExecRideMagic()
    if ExecMagic(QUICKTYPE_NORMAL, ALLBODY, TRUE) == TRUE then
        return TRUE
    else
        return FALSE
    end
end

function ExecRideGesture()
    if c_HasActionRequest == FALSE then
        return FALSE
    elseif FALSE == env(ActionRequest, ACTION_ARM_GESTURE) then
        return FALSE
    else
        ResetRequest()
        return FALSE
    end
end

function ExecRideWeaponChange(blend_type)
    local weapon_change_type = nil
    local ride_weapon_change_end_type = nil

    if env(ActionRequest, ACTION_ARM_CHANGE_WEAPON_R) == TRUE then
        weapon_change_type = GetWeaponChangeType(HAND_RIGHT)
        ride_weapon_change_end_type = GetWeaponChangeType(HAND_RIGHT)
    elseif env(ActionRequest, ACTION_ARM_CHANGE_WEAPON_L) == TRUE then
        if c_Style == HAND_LEFT_BOTH then
            weapon_change_type = GetWeaponChangeType(HAND_LEFT) + 4
            ride_weapon_change_end_type = GetWeaponChangeType(HAND_RIGHT) + 8
        else
            weapon_change_type = GetWeaponChangeType(HAND_LEFT)
            ride_weapon_change_end_type = GetWeaponChangeType(HAND_LEFT)
        end
    else
        return FALSE
    end

    if weapon_change_type == WEAPON_CHANGE_REQUEST_INVALID then
        return FALSE
    elseif env(GetGeneralTAEFlag, TAE_FLAG_CHARGING) == 1 or env(GetSpEffectID, 100280) == TRUE then
        ResetRequest()

        return FALSE
    else
        SetVariable("WeaponChangeType", weapon_change_type)
        SetVariable("RideWeaponChangeEndType", ride_weapon_change_end_type)
        ExecEventAllBody("W_RideWeaponChangeStart")
        act(Unknown2025, env(Unknown404))
        SetAIActionState()

        return TRUE
    end
end

function ExecRideHandChange(hand, is_force)
    if is_force == FALSE then
        if FALSE == c_HasActionRequest or env(IsPrecisionShoot) == TRUE then
            return FALSE
        elseif env(IsCOMPlayer) == TRUE then
            if env(ActionRequest, ACTION_ARM_CHANGE_STYLE_R) == TRUE then
            elseif env(ActionRequest, ACTION_ARM_CHANGE_STYLE_L) == TRUE then
                hand = HAND_LEFT
            else
                return FALSE
            end
        elseif env(ActionDuration, ACTION_ARM_ACTION) <= 0 then
            return FALSE
        elseif env(ActionRequest, ACTION_ARM_R1) == TRUE or env(ActionRequest, ACTION_ARM_R2) == TRUE then
            if c_Style == HAND_RIGHT or c_Style == HAND_RIGHT_BOTH then
                hand = HAND_LEFT
            else
                hand = HAND_RIGHT
            end
        elseif env(ActionRequest, ACTION_ARM_L1) == TRUE or env(ActionRequest, ACTION_ARM_L2) == TRUE then
            if c_Style == HAND_RIGHT or c_Style == HAND_RIGHT_BOTH then
                hand = HAND_LEFT
            else
                hand = HAND_RIGHT
            end
        else
            return FALSE
        end
    end

    if env(GetGeneralTAEFlag, TAE_FLAG_CHARGING) == 1 or env(GetSpEffectID, 100280) == TRUE then
        ResetRequest()
        return FALSE
    end

    local style = c_Style
    local kind = GetHandChangeType(HAND_RIGHT)
    local leftKind = GetHandChangeType(HAND_LEFT)

    env(GetEquipWeaponSpecialCategoryNumber, HAND_LEFT) -- Unused?
    env(GetEquipWeaponSpecialCategoryNumber, HAND_RIGHT) -- Unused?

    if style == HAND_RIGHT or style == HAND_RIGHT_BOTH then
        if hand == HAND_RIGHT then
            return FALSE
        elseif FALSE == env(IsTwoHandPossible, HAND_LEFT) then
            return FALSE
        end

        local right_change_transition = nil

        if kind == WEAPON_CHANGE_REQUEST_RIGHT_WAIST then
            right_change_transition = RIDE_RIGHT_TO_WAIST
        elseif kind == WEAPON_CHANGE_REQUEST_RIGHT_BACK then
            right_change_transition = RIDE_RIGHT_TO_BACK
        elseif kind == WEAPON_CHANGE_REQUEST_RIGHT_SHOULDER then
            right_change_transition = RIDE_RIGHT_TO_SHOULDER
        else
            right_change_transition = RIDE_RIGHT_TO_SPEAR
        end

        local left_change_transition = nil

        if leftKind == WEAPON_CHANGE_REQUEST_LEFT_WAIST then
            left_change_transition = RIDE_BOTHLEFT_FROM_WAIST
        elseif leftKind == WEAPON_CHANGE_REQUEST_LEFT_BACK then
            left_change_transition = RIDE_BOTHLEFT_FROM_BACK
        elseif leftKind == WEAPON_CHANGE_REQUEST_LEFT_SHOULDER then
            left_change_transition = RIDE_BOTHLEFT_FROM_SHOULDER
        else
            left_change_transition = RIDE_BOTHLEFT_FROM_SPEAR
        end

        act(DebugLogOutput, "RideHandChange ToBothLeft start=" .. right_change_transition .. " end" .. left_change_transition)
        SetHandChangeStyle(right_change_transition, left_change_transition)
        act(Unknown9999, 2)
    elseif style == HAND_LEFT_BOTH then
        local right_change_transition = nil

        if leftKind == WEAPON_CHANGE_REQUEST_LEFT_WAIST then
            right_change_transition = RIDE_LEFT_TO_WAIST
        elseif leftKind == WEAPON_CHANGE_REQUEST_LEFT_BACK then
            right_change_transition = RIDE_LEFT_TO_BACK
        elseif leftKind == WEAPON_CHANGE_REQUEST_LEFT_SHOULDER then
            right_change_transition = RIDE_LEFT_TO_SHOULDER
        else
            right_change_transition = RIDE_LEFT_TO_SPEAR
        end

        local left_change_transition = nil

        if kind == WEAPON_CHANGE_REQUEST_RIGHT_WAIST then
            left_change_transition = RIDE_RIGHT_FROM_LEFTWAIST_FROM_MIDDLE
        elseif kind == WEAPON_CHANGE_REQUEST_RIGHT_BACK then
            left_change_transition = RIDE_RIGHT_FROM_RIGHTBACK_FROM_MIDDLE
        elseif kind == WEAPON_CHANGE_REQUEST_RIGHT_SHOULDER then
            left_change_transition = RIDE_RIGHT_FROM_RIGHTSHOULDER_FROM_MIDDLE
        else
            left_change_transition = RIDE_RIGHT_FROM_RIGHTSPEAR_FROM_MIDDLE
        end

        SetHandChangeStyle(right_change_transition, left_change_transition)
        act(Unknown9999, 1)
    end

    ExecEventAllBody("W_RideHandChangeStart")
    act(Unknown2025, env(Unknown404))
    SetAIActionState()

    return TRUE
end

function RideWeaponChangeStart_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
end

function RideWeaponChangeStart_onUpdate()
    SetAIActionState()
    act(DisallowAdditiveTurning, TRUE)

    if TRUE == RideReActionFunction() then
        return
    elseif TRUE == env(IsAnimEnd, 0) then
        ExecEventAllBody("W_RideWeaponChangeEnd")
    end

    local lower_only = TRUE

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, FALSE, lower_only) == TRUE then
    end
end

function RideWeaponChangeStart_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function RideWeaponChangeEnd_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
end

function RideWeaponChangeEnd_onUpdate()
    SetAIActionState()
    act(DisallowAdditiveTurning, TRUE)

    if TRUE == RideReActionFunction() then
        return
    elseif TRUE == RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
        return
    elseif TRUE == env(IsMoveCancelPossible) then
        ExecEventNoReset("W_RideIdle")
    end
end

function RideWeaponChangeEnd_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function RideHandChangeStart_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
end

function RideHandChangeStart_onUpdate()
    SetAIActionState()
    act(DisallowAdditiveTurning, TRUE)

    if TRUE == RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end

    local lower_only = TRUE

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, FALSE, lower_only) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventAllBody("W_RideHandChangeEnd")
    end
end

function RideHandChangeStart_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function RideHandChangeEnd_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
end

function RideHandChangeEnd_onUpdate()
    SetAIActionState()
    act(DisallowAdditiveTurning, TRUE)

    if TRUE == RideReActionFunction() then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
        return
    elseif TRUE == env(IsMoveCancelPossible) then
        ExecEventNoReset("W_RideIdle")
    end
end

function RideHandChangeEnd_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function IsEnableRideAttackHard2(hand)
    local style = c_Style

    if style == HAND_LEFT_BOTH then
        hand = HAND_LEFT
    end

    local kind = env(GetEquipWeaponCategory, hand)

    if kind == WEAPON_CATEGORY_RAPIER or kind == WEAPON_CATEGORY_LARGE_RAPIER then
        return TRUE
    else
        return FALSE
    end
end

function RideGesture_onUpdate()
    SetAIActionState()
    act(DisallowAdditiveTurning, TRUE)

    if TRUE == RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    elseif TRUE == env(MovementRequest) and GetVariable("MoveSpeedLevel") > 0 and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, TRUE, FALSE) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 0) then
        FireRideEvent("W_RideIdle", "W_RideIdle", FALSE)
    end
end

function RideGestureUpper_onUpdate()
    SetAIActionState()

    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideMagicLaunch_onUpdate()
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    elseif TRUE == env(IsAnimEndBySkillCancel) or TRUE == env(IsAnimEnd, 0) then
        ExecEventAllBody("W_RideMagicFire")
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideMagicLaunch_Upper_onUpdate()
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    elseif TRUE == env(IsAnimEndBySkillCancel) or TRUE == env(IsAnimEnd, 0) then
        ExecEventAllBody("W_RideMagicFire")
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideMagicFire_onUpdate()
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    end

    local wep_hand = HAND_RIGHT

    if c_Style == HAND_LEFT_BOTH then
        wep_hand = HAND_LEFT
    end

    if TRUE == env(GetSpEffectID, 100610) and (not (env(ActionDuration, ACTION_ARM_R1) > 0 or env(ActionDuration, ACTION_ARM_L1) > 0) or env(IsMagicUseable, wep_hand, 1) == FALSE) then
        ExecEventAllBody("W_RideMagicFireCancel")
        return
    elseif TRUE == CheckIfHoldMagic() and (TRUE == env(IsAnimEndBySkillCancel) or TRUE == env(IsAnimEnd, 0)) then
        if env(ActionDuration, ACTION_ARM_R1) > 0 then
            ExecEventAllBody("W_RideMagicLoop")
            return
        else
            ExecEventAllBody("W_RideMagicFireCancel")
            return
        end
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideMagicLoop_onUpdate()
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    end

    local wep_hand = HAND_RIGHT

    if c_Style == HAND_LEFT_BOTH then
        wep_hand = HAND_LEFT
    end

    if not (env(ActionDuration, ACTION_ARM_R1) > 0 or env(ActionDuration, ACTION_ARM_L1) > 0 or env(ActionDuration, ACTION_ARM_L1) > 0) or env(IsMagicUseable, wep_hand, 1) == FALSE or env(GetStamina) <= 0 then
        local magic_index = env(GetMagicAnimType)

        if magic_index == MAGIC_REQUEST_EX_LARGE_ARROW then
            ExecEventAllBody("W_RideMagicFireCombo1Cancel")
        else
            ExecEventAllBody("W_RideMagicFireCancel")
        end
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideMagicFireCancel_onUpdate()
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideMagicFireCombo1_onUpdate()
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    end

    local wep_hand = HAND_RIGHT

    if c_Style == HAND_LEFT_BOTH then
        wep_hand = HAND_LEFT
    end

    if TRUE == env(GetSpEffectID, 100610) and (not (env(ActionDuration, ACTION_ARM_R1) > 0 or env(ActionDuration, ACTION_ARM_L1) > 0) or env(IsMagicUseable, wep_hand, 1) == FALSE) then
        ExecEventAllBody("W_RideMagicFireCombo1Cancel")
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideMagicFireCombo1Cancel_onUpdate()
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideMagicFireCombo2_onUpdate()
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    end

    local wep_hand = HAND_RIGHT

    if c_Style == HAND_LEFT_BOTH then
        wep_hand = HAND_LEFT
    end

    if TRUE == env(GetSpEffectID, 100610) and (not (env(ActionDuration, ACTION_ARM_R1) > 0 or env(ActionDuration, ACTION_ARM_L1) > 0) or env(IsMagicUseable, wep_hand, 1) == FALSE) then
        ExecEventAllBody("W_RideMagicFireCombo2Cancel")
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideMagicFireCombo2Cancel_onUpdate()
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideMagicInvalid_onUpdate()
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideItemDrinkStart_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
end

function RideItemDrinkStart_onUpdate()
    SetAIActionState()
    act(DisallowAdditiveTurning, TRUE)
    act(SetIsItemAnimationPlaying)

    if TRUE == RideReActionFunction() then
        return
    elseif TRUE == RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end

    local isEnd = env(IsAnimEnd, 1)

    if TRUE == env(GetEventEzStateFlag, 0) or isEnd == TRUE then
        local item_type = env(GetItemAnimType)
        if item_type ~= ITEM_NO_DRINK then
            ExecEventNoReset("W_RideItemDrinking")
            return
        elseif item_type == ITEM_NO_DRINK and isEnd == TRUE then
            ExecEventNoReset("W_RideItemDrinkEmpty")
            return
        end
    end

    if TRUE == RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideItemDrinking_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
end

function RideItemDrinking_onUpdate()
    SetAIActionState()
    act(SetIsItemAnimationPlaying)

    if RideReActionFunction() == TRUE then
        return
    elseif TRUE == ExecRideItem() then
        return TRUE
    elseif TRUE == RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventNoReset("W_RideItemDrinkEnd")
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideItemDrinkEnd_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
end

function RideItemDrinkEnd_onUpdate()
    SetAIActionState()
    act(SetIsItemAnimationPlaying)

    if RideReActionFunction() == TRUE then
        return
    elseif TRUE == ExecRideItem() then
        return TRUE
    elseif TRUE == RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 1) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideItemDrinkEmpty_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
end

function RideItemDrinkEmpty_onUpdate()
    SetAIActionState()
    act(SetIsItemAnimationPlaying)

    if RideReActionFunction() == TRUE then
        return
    elseif TRUE == ExecRideItem() then
        return TRUE
    elseif TRUE == RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventNoReset("W_RideIdle")
    end
end

function RideItemInvalid_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
end

function RideItemInvalid_onUpdate()
    SetAIActionState()
    act(SetIsItemAnimationPlaying)

    if RideReActionFunction() == TRUE then
        return
    elseif TRUE == ExecRideItem() then
        return TRUE
    elseif TRUE == RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 1) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventNoReset("W_RideIdle")
    end
end

function RideItemDrinkNothing_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
end

function RideItemDrinkNothing_onUpdate()
    SetAIActionState()
    act(SetIsItemAnimationPlaying)

    if RideReActionFunction() == TRUE then
        return
    elseif TRUE == ExecRideItem() then
        return TRUE
    elseif TRUE == RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventNoReset("W_RideIdle")
    end
end

function RideItemWhistle_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
end

function RideItemWhistle_onUpdate()
    SetAIActionState()
    act(SetIsItemAnimationPlaying)

    if RideReActionFunction() == TRUE then
        return
    elseif TRUE == ExecRideItem() then
        return TRUE
    elseif TRUE == RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventNoReset("W_RideIdle")
    end
end

function RideItemElixir_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
end

function RideItemElixir_onUpdate()
    SetAIActionState()
    act(SetIsItemAnimationPlaying)

    if RideReActionFunction() == TRUE then
        return
    elseif TRUE == ExecRideItem() then
        return TRUE
    elseif TRUE == RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventNoReset("W_RideIdle")
    end
end

function RideItemHorn_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
end

function RideItemHorn_onUpdate()
    SetAIActionState()
    act(SetIsItemAnimationPlaying)

    if RideReActionFunction() == TRUE then
        return
    elseif TRUE == ExecRideItem() then
        return TRUE
    elseif TRUE == RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventNoReset("W_RideIdle")
    end
end

function RideItemQuick1_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
end

function RideItemQuick1_onUpdate()
    SetAIActionState()
    act(SetIsItemAnimationPlaying)

    if RideReActionFunction() == TRUE then
        return
    elseif TRUE == ExecRideItem() then
        return TRUE
    elseif TRUE == RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 1) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventNoReset("W_RideIdle")
    end
end

function RideItemQuick2_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
end

function RideItemQuick2_onUpdate()
    SetAIActionState()
    act(SetIsItemAnimationPlaying)

    if RideReActionFunction() == TRUE then
        return
    elseif TRUE == ExecRideItem() then
        return TRUE
    elseif TRUE == RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 1) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventNoReset("W_RideIdle")
    end
end

function RideItemQuick3_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
end

function RideItemQuick3_onUpdate()
    SetAIActionState()
    act(SetIsItemAnimationPlaying)

    if RideReActionFunction() == TRUE then
        return
    elseif TRUE == ExecRideItem() then
        return TRUE
    elseif TRUE == RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 1) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventNoReset("W_RideIdle")
    end
end

function RideItemOneShot_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
end

function RideItemOneShot_onUpdate()
    if GetVariable("PreItemType") == ITEM_HORSE_FEED then
        IsEnableFeedAddBlend = TRUE
    end

    act(SetIsItemAnimationPlaying)
    SetAIActionState()

    if TRUE == RideReActionFunction() then
        return
    elseif TRUE == ExecRideItem() then
        return TRUE
    elseif TRUE == RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventNoReset("W_RideIdle")
    end
end

function RideItemOneShot_onDeactivate()
    IsEnableFeedAddBlend = FALSE
end

function RideItemLanternOff_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
end

function RideItemLanternOff_onUpdate()
    act(SetIsItemAnimationPlaying)
    SetAIActionState()

    if RideReActionFunction() == TRUE then
        return
    elseif TRUE == ExecRideItem() then
        return TRUE
    elseif TRUE == RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventNoReset("W_RideIdle")
    end
end

function RideItemCombo_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
end

function RideItemCombo_onUpdate()
    act(SetIsItemAnimationPlaying)
    SetAIActionState()

    if RideReActionFunction() == TRUE then
        return
    elseif TRUE == ExecRideItem() then
        return TRUE
    elseif TRUE == RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventNoReset("W_RideIdle")
    end
end

function RideItemMeganeStart_onUpdate()
    act(SetIsItemAnimationPlaying)
    SetAIActionState()

    if RideReActionFunction() == TRUE then
        return
    elseif TRUE == ExecRideItem() then
        return TRUE
    elseif TRUE == RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideItemMeganeLoop_onUpdate()
    SetAIActionState()
    if env(GetStateChangeType, 15) == FALSE then
        act(SetIsItemAnimationPlaying)
    end

    if RideReActionFunction() == TRUE then
        return
    elseif TRUE == ExecRideItem() then
        return TRUE
    elseif TRUE == RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if env(MovementRequest) == TRUE or env(IsAnimEnd, 0) == TRUE then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideItemMeganeEnd_onUpdate()
    SetAIActionState()
    act(SetIsItemAnimationPlaying)

    if RideReActionFunction() == TRUE then
        return
    elseif TRUE == ExecRideItem() then
        return TRUE
    elseif TRUE == RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventNoReset("W_RideIdle")
    end
end

function RideAdjust_onUpdate()
    act(SetAllowedThrowDefenseType, 255)

    if env(IsMovingOnMount) == TRUE then
        FireRideEvent("W_RideOn", "W_RideOn", FALSE)

        return TRUE
    elseif env(IsIdleOnMount) == TRUE then
        ExecEventAllBody("W_Idle")

        return TRUE
    else
    end
end

function RideAdjustFromCalling_onUpdate()
    act(SetAllowedThrowDefenseType, 255)

    if env(IsMovingOnMount) == TRUE then
        if GetVariable("RideOnSummonTest") == 1 then
            FireRideEvent("W_RideOn", "W_RideOn", FALSE)
        else
            ExecEventAllBody("W_RideOn")
        end

        return TRUE
    elseif env(IsIdleOnMount) == TRUE then
        ExecEventAllBody("W_Idle")

        return TRUE
    else
    end
end

function RideOn_onUpdate()
    act(ApplyRideBlend, "AddBlend02", 0)
    Ride_HeadDown_Rate = 0

    act(SetAllowedThrowDefenseType, 255)
    SetAIActionState()
    SetVariable("Int16Variable01", 0)

    local lower_only = TRUE

    if TRUE == env(IsMoveCancelPossible) or env(IsAnimEnd, 0) == TRUE then
        lower_only = FALSE
    elseif env(GetEventEzStateFlag, 0) ~= TRUE then
        return
    end

    local move_speed_level = GetVariable("MoveSpeedLevel")
    local move_angle = GetVariable("MoveAngle")
    local next_ride_move_type = RIDE_MOVE_TYPE_IDLE

    if math.abs(move_angle) <= 45 then
        if move_speed_level > 1.5 or GetVariable("IsEnableToggleDashTest") >= 1 and GetVariable("ToggleDash") == 1 and GetVariable("MoveSpeedLevel") >= 0.8999999761581421 then
            next_ride_move_type = RIDE_MOVE_TYPE_GALLOP
        elseif move_speed_level > 0.6000000238418579 then
            next_ride_move_type = RIDE_MOVE_TYPE_DASH
        elseif move_speed_level > 0 then
            next_ride_move_type = RIDE_MOVE_TYPE_WALK
        else
            next_ride_move_type = RIDE_MOVE_TYPE_IDLE
        end
    end

    if next_ride_move_type == RIDE_MOVE_TYPE_IDLE then
        if lower_only == FALSE then
            FireRideEvent("W_RideIdle", "W_RideIdle", lower_only)
        end
    elseif next_ride_move_type == RIDE_MOVE_TYPE_WALK then
        FireRideEvent("W_RideWalk", "W_RideWalk", lower_only)
    elseif next_ride_move_type == RIDE_MOVE_TYPE_DASH then
        FireRideEvent("W_RideDash", "W_RideDash", lower_only)
    else
        FireRideEvent("W_RideGallop", "W_RideGallop", lower_only)
    end
end

function RideOnDash_onUpdate()
    act(SetAllowedThrowDefenseType, 255)
    SetAIActionState()
    SetVariable("Int16Variable01", 0)

    local lower_only = TRUE

    if TRUE == env(MovementRequest) or env(IsAnimEnd, 0) == TRUE then
        lower_only = FALSE
    elseif env(GetEventEzStateFlag, 0) ~= TRUE then
        return
    end

    local move_speed_level = GetVariable("MoveSpeedLevel")
    local move_angle = GetVariable("MoveAngle")
    local next_ride_move_type = RIDE_MOVE_TYPE_IDLE

    if math.abs(move_angle) <= 45 then
        if move_speed_level > 1.5 or GetVariable("IsEnableToggleDashTest") >= 1 and GetVariable("ToggleDash") == 1 and GetVariable("MoveSpeedLevel") >= 0.8999999761581421 then
            next_ride_move_type = RIDE_MOVE_TYPE_GALLOP
        elseif move_speed_level > 0.6000000238418579 then
            next_ride_move_type = RIDE_MOVE_TYPE_DASH
        elseif move_speed_level > 0 then
            next_ride_move_type = RIDE_MOVE_TYPE_WALK
        else
            next_ride_move_type = RIDE_MOVE_TYPE_IDLE
        end
    end

    if next_ride_move_type == RIDE_MOVE_TYPE_IDLE then
        if lower_only == FALSE then
            FireRideEvent("W_RideIdle", "W_RideIdle", lower_only)
        end
    elseif next_ride_move_type == RIDE_MOVE_TYPE_WALK then
        FireRideEvent("W_RideWalk", "W_RideWalk", lower_only)
    elseif next_ride_move_type == RIDE_MOVE_TYPE_DASH then
        FireRideEvent("W_RideDash", "W_RideDash", lower_only)
    else
        FireRideEvent("W_RideGallop", "W_RideGallop", lower_only)
    end
end

function RideOff_onUpdate()
    act(SetAllowedThrowDefenseType, 0)
    act(SetAllowedThrowAttackType, 1)
    SetAIActionState()
    SetVariable("Int16Variable01", 0)

    if EvasionCommonFunction(FALL_TYPE_DEFAULT, "W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", QUICKTYPE_NORMAL) == TRUE then
        act(Unknown3005)

        return
    elseif TRUE == env(MovementRequest) or env(IsAnimEnd, 0) == TRUE then
        act(Unknown3005)
        ExecEventAllBody("W_Idle")

        return TRUE
    else
    end
end

function RideIdle_onActivate()
    act(Wait)
end

function RideIdle_onUpdate()
    act(Wait)
    SetVariable("Int16Variable01", 0)
    SetEnableAimMode()

    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    elseif RideRequestFunction(RIDE_MOVE_TYPE_IDLE, TRUE, FALSE) == TRUE then
        return
    elseif GetVariable("IsEnableToggleDashTest") >= 1 then
        SetVariable("ToggleDash", 0)
    end
end

function RideWalk_onUpdate()
    act(Wait)
    SetEnableAimMode()

    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    elseif RideRequestFunction(RIDE_MOVE_TYPE_WALK, TRUE, FALSE) == TRUE then
        return
    elseif GetVariable("IsEnableToggleDashTest") >= 1 then
        SetVariable("ToggleDash", 0)
    end
end

function RideWalk_End_onUpdate()
    act(Wait)
    SetEnableAimMode()

    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 0) then
        FireRideEvent("W_RideIdle", "W_RideIdle", FALSE)
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_IDLE, TRUE, FALSE) == TRUE then
    end
end

function RideDash_onUpdate()
    act(Wait)
    SetEnableAimMode()

    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    elseif RideRequestFunction(RIDE_MOVE_TYPE_DASH, TRUE, FALSE) == TRUE then
        return
    elseif GetVariable("IsEnableToggleDashTest") >= 1 then
        SetVariable("ToggleDash", 0)
    end
end

-- Initial Movement after "O" Press (approx 6 seconds)
function RideDashAccelerate_onUpdate()
    act(Wait)
    SetEnableAimMode()

    if env(GetStamina) <= 0 then
        act(AddSpEffect, 100020)
    end

    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    elseif TRUE == ExecRideStop(RIDE_MOVE_TYPE_OTHER, FALSE) then
        return
    elseif (env(IsMoveCancelPossible) == TRUE or env(IsAnimEnd, 0) == TRUE) and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, TRUE, FALSE) == TRUE then

    end
end

-- Initial Movement after secondary "O" Press during Dash (approx 6 seconds)
function RideDashAccelerateContinue_onUpdate()
    act(Wait)
    SetEnableAimMode()

    if env(GetStamina) <= 0 then
        act(AddSpEffect, 100020)
    end

    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    elseif TRUE == ExecRideStop(RIDE_MOVE_TYPE_OTHER, FALSE) then
        return
    elseif (env(IsMoveCancelPossible) == TRUE or env(IsAnimEnd, 0) == TRUE) and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, TRUE, FALSE) == TRUE then

    end
end

function RideMoveStaminaConsume()
    if env(IsOnMount) == FALSE then
        return
    elseif env(GetStamina) <= 0 then
        act(AddSpEffect, 100020)
    end

    -- Gallop
    if env(GetMountSpEffectID, 101002) == TRUE then
        act(SetStaminaRecoveryDisabled)

        local dT = GetDeltaTime()
        dash_dt_sum = dash_dt_sum + dT
        if dash_dt_sum > 0.06499999761581421 then
            dash_dt_sum = 0
            act(ChangeStamina, -1)
        end
    end
end

function RideDash_End_onUpdate()
    act(Wait)
    SetEnableAimMode()

    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 0) then
        FireRideEvent("W_RideIdle", "W_RideIdle", FALSE)
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_IDLE, TRUE, FALSE) == TRUE then
    end
end

-- Sustained Movement after "O" Press
function RideGallop_onUpdate()
    act(Wait)
    SetEnableAimMode()

    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    elseif RideRequestFunction(RIDE_MOVE_TYPE_GALLOP, TRUE, FALSE) == TRUE then
        return
    elseif GetVariable("IsEnableToggleDashTest") >= 1 then

    else

    end
end

function RideGallop_End_onUpdate()
    act(Wait)
    SetEnableAimMode()

    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 0) then
        FireRideEvent("W_RideIdle", "W_RideIdle", FALSE)
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_IDLE, TRUE, FALSE) == TRUE then
    end
end

function RideDamage_onUpdate()
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    elseif (TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0)) and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, TRUE, FALSE) == TRUE then
    end
end

function RideDamage_M_onUpdate()
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    elseif (TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0)) and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, TRUE, FALSE) == TRUE then
    end
end

function RideDamage_H_onUpdate()
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    elseif (TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0)) and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, TRUE, FALSE) == TRUE then
    end
end

function RideRepelledWall_onUpdate()
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideRepelledSmall_onUpdate()
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideRepelledLarge_onUpdate()
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideDamageSmall_onUpdate()
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    elseif (TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 1)) and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, TRUE, FALSE) == TRUE then
    end
end

function RideDamageMiddle_onUpdate()
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    elseif (TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 1)) and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, TRUE, FALSE) == TRUE then
    end
end

function RideDamageLarge_onUpdate()
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    elseif (TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 1)) and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, TRUE, FALSE) == TRUE then
    end
end

function RideDamageExLarge_onUpdate()
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    elseif (TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 1)) and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, TRUE, FALSE) == TRUE then
    end
end

function RideDamageWeakTop_onUpdate()
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    elseif (TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 1)) and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, TRUE, FALSE) == TRUE then
    end
end

function RideDamageWeakUnder_onUpdate()
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    elseif (TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 1)) and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, TRUE, FALSE) == TRUE then
    end
end

function Ride_SA_Add_Default_onUpdate()
    SetVariable("Ride_SA_Add_Blend", 0)
    act(ApplyRideBlend, "BlendRidden_SA_Add", 0)
end

function RideFireDamageBlend_Default_onUpdate()
    SetVariable("BlendRideDamageFire", 0)
    act(ApplyRideBlend, "BlendRiddenDamageFire", 0)
end

function RideDamage_Fall_onUpdate()
    act(SetAllowedThrowDefenseType, 0)
    act(SetAllowedThrowAttackType, 1)
    SetAIActionState()
    SetVariable("Int16Variable01", 0)
    act(Unknown3005)

    if DamageCommonFunction(FALSE, ESTEP_NONE, FALL_TYPE_FORCE) == TRUE then
        return TRUE
    elseif TRUE == env(MovementRequest) or env(IsAnimEnd, 0) == TRUE then
        ExecEventAllBody("W_Idle")
    end
end

function RideDamageMad_onUpdate()
    act(SetAllowedThrowDefenseType, 0)
    act(SetAllowedThrowAttackType, 1)
    SetAIActionState()
    SetVariable("Int16Variable01", 0)

    if env(GetSpecialAttribute) == 25 and 0 >= env(GetHP) and env(IsOnMount) == TRUE then
        SetVariable("IndexRideDeath", RIDE_DEATH_TYPE_MAD)
        FireRideEvent("W_RideDeath", "W_RideDeath", FALSE)
        return
    end

    act(Unknown3005)

    if TRUE == DamageCommonFunction(FALSE, ESTEP_NONE, FALL_TYPE_FORCE) then
        return TRUE
    elseif env(MovementRequest) == TRUE or env(IsAnimEnd, 0) == TRUE then
        ExecEventAllBody("W_Idle")
    end
end

function RideDeath_Idle_onActivate()
    act(SetDeathStay, TRUE)
end

function RideDeath_Idle_onDeactivate()
    act(SetDeathStay, FALSE)
end

function RideAttackCommonFunction(r1, r2, l1, l2)
    if RideCommonFunction(r1, r2, l1, l2) == TRUE then
        return TRUE
    elseif c_Style == HAND_LEFT_BOTH then
        SetAttackHand(HAND_LEFT)
        SetGuardHand(HAND_LEFT)
    else
        SetAttackHand(HAND_RIGHT)
        SetGuardHand(HAND_RIGHT)
    end

    return FALSE
end

Ride_HighJump_Height = 0
Ride_HeadDown_Rate = 0
Ride_Feed_Rate = 0
IsEnableFeedAddBlend = FALSE

function RideCommonFunction(r1, r2, l1, l2)
    Ride_HeadDown_Rate = EaseInOutVal(g_TimeActEditor_07, Ride_HeadDown_Rate, 0.800000011920929, 1.5, "EaseInOutStartVal1", "EaseInOutTargetVal1", "EaseInOutTimer1")

    act(ApplyRideBlend, "AddBlend02", Ride_HeadDown_Rate)

    if RideReActionFunction() == TRUE then
        return TRUE
    elseif TRUE == ExecRideDashAccelerate() then
        return TRUE
    elseif TRUE == ExecRideWeaponChange() then
        return TRUE
    elseif TRUE == ExecRideOff(FALSE, FALSE) then
        return TRUE
    end

    local attackHand = HAND_RIGHT

    if c_Style == HAND_LEFT_BOTH then
        attackHand = HAND_LEFT
    end

    local isShield = GetEquipType(attackHand, WEAPON_CATEGORY_LARGE_SHIELD, WEAPON_CATEGORY_SMALL_SHIELD, WEAPON_CATEGORY_MIDDLE_SHIELD)

    if TRUE == env(ActionRequest, ACTION_ARM_JUMP) and (not (env(GetGeneralTAEFlag, TAE_FLAG_CHARGING) == 1 or FALSE ~= env(GetSpEffectID, 100280)) or isShield == TRUE) then
        if env(GetStamina) <= 0 then
            ResetRequest()
        else
            local highJumpHeight = env(GetSpiritspringJumpHeight)

            -- Normal Spiritspring Jump
            if highJumpHeight > 0 then
                act(DebugLogOutput, "RideJumpHigh Height=" .. highJumpHeight .. "cm")
                Ride_HighJump_Height = highJumpHeight + 700
                FireRideEvent("W_RideJumpHigh", "W_RideJumpHigh", FALSE)
                return TRUE
            end

            -- Normal Jump
            act(ChangeStamina, STAMINA_REDUCE_RIDE_JUMP)

            if 1.5 <= GetVariable("MoveSpeedLevel") then
                FireRideEvent("W_RideJump_D", "W_RideJump_D", FALSE)
            elseif GetVariable("MoveSpeedLevel") >= 0.6000000238418579 then
                FireRideEvent("W_RideJump_F", "W_RideJump_F", FALSE)
            else
                FireRideEvent("W_RideJump_N", "W_RideJump_N", FALSE)
            end

            return TRUE
        end
    end

    if TRUE == ExecRideHandChange(HAND_RIGHT, FALSE) then
        return TRUE
    elseif TRUE == ExecRideMagic() then
        return TRUE
    elseif ExecRideAttack(r1, r2, l1, l2) == TRUE then
        return TRUE
    elseif TRUE == ExecRideItem() then
        return TRUE
    elseif TRUE == ExecRideGesture() then
        return TRUE
    else
        return FALSE
    end
end

RideDashAccelerateTest = 0

function ExecRideDashAccelerate()
    if env(GetStamina) <= 0 or env(GetSpEffectID, 100020) == TRUE then
        ResetRequest()
        return FALSE
    end

    SetVariable("IsEnableToggleDashTest", 4)

    local evasionRequest = env(ActionRequest, ACTION_ARM_SP_MOVE)

    if evasionRequest == TRUE and env(GetStamina) <= 0 then
        ResetRequest()
    end

    -- Gallop started already
    if env(GetSpEffectID, 100903) == TRUE then
        return FALSE
        -- "O" Pressed
    elseif evasionRequest == TRUE then
        act(ChangeStamina, STAMINA_REDUCE_RIDE_DASH)

        SetVariable("ToggleDash", 1)

        if TRUE == IsNodeActive("RideDashAccelerate CMSG") or TRUE == IsNodeActive("RideDashAccelerateContinue CMSG") then
            FireRideEvent("W_RideDashAccelerateContinue", "W_RideDashAccelerateContinue", FALSE)
        else
            FireRideEvent("W_RideDashAccelerate", "W_RideDashAccelerate", FALSE)
        end

        return TRUE
    end

    -- Original decompiled code, appears to be pointless as the above replicates the normal vanilla dash behavior properly.
    -- local testControl = 3

    -- if testControl == 2 or testControl == 12 then
    -- SetVariable("IsEnableToggleDashTest", 0)

    -- if env(ActionRequest, ACTION_ARM_ROLLING) == TRUE and env(GetStamina) <= 0 then
    -- ResetRequest()
    -- end

    -- local evasionRequest = GetEvasionRequest()

    -- if evasionRequest == ATTACK_REQUEST_ROLLING then
    -- act(ChangeStamina, STAMINA_REDUCE_RIDE_DASH)

    -- if TRUE == IsNodeActive("RideDashAccelerate CMSG") or TRUE == IsNodeActive("RideDashAccelerateContinue CMSG") then
    -- FireRideEvent("W_RideDashAccelerateContinue", "W_RideDashAccelerateContinue", FALSE)
    -- else
    -- FireRideEvent("W_RideDashAccelerate", "W_RideDashAccelerate", FALSE)
    -- end

    -- return TRUE
    -- end
    -- else
    -- if testControl == 3 or testControl == 13 then
    -- SetVariable("IsEnableToggleDashTest", 4)

    -- local evasionRequest = env(ActionRequest, ACTION_ARM_SP_MOVE)

    -- if evasionRequest == TRUE and env(GetStamina) <= 0 then
    -- ResetRequest()
    -- end

    -- -- Gallop started already
    -- if env(GetSpEffectID, 100903) == TRUE then
    -- return FALSE
    -- elseif evasionRequest == TRUE then
    -- act(ChangeStamina, STAMINA_REDUCE_RIDE_DASH)

    -- SetVariable("ToggleDash", 1)

    -- if TRUE == IsNodeActive("RideDashAccelerate CMSG") or TRUE == IsNodeActive("RideDashAccelerateContinue CMSG") then
    -- FireRideEvent("W_RideDashAccelerateContinue", "W_RideDashAccelerateContinue", FALSE)
    -- else
    -- FireRideEvent("W_RideDashAccelerate", "W_RideDashAccelerate", FALSE)
    -- end

    -- return TRUE
    -- end
    -- end

    -- SetVariable("IsEnableToggleDashTest", 0)

    -- if 0 == RideDashAccelerateTest and env(ActionDuration, ACTION_ARM_SP_MOVE) > 0 then
    -- act(DebugLogOutput, "RideDashAccel")
    -- end

    -- local evasionRequest = env(ActionDuration, ACTION_ARM_SP_MOVE)

    -- if (env(IsStayState) == TRUE or env(IsGeneralAnimCancelPossible) == TRUE) and evasionRequest > 0 and 0 > RideDashAccelerateTest and env(GetStamina) > 0 then
    -- act(AdjustStamina, STAMINA_REDUCE_RIDE_DASH)

    -- if TRUE == IsNodeActive("RideDashAccelerate CMSG") or TRUE == IsNodeActive("RideDashAccelerateContinue CMSG") then
    -- FireRideEvent("W_RideDashAccelerateContinue", "W_RideDashAccelerateContinue", FALSE)
    -- else
    -- FireRideEvent("W_RideDashAccelerate", "W_RideDashAccelerate", FALSE)
    -- end

    -- return TRUE
    -- end

    -- RideDashAccelerateTest = env(ActionDuration, ACTION_ARM_SP_MOVE)

    -- if FALSE == IsNodeActive("RideDashAccelerate CMSG") and FALSE == IsNodeActive("RideDashAccelerateContinue CMSG") then
    -- if env(ActionRequest, ACTION_ARM_ROLLING) == TRUE and env(GetStamina) <= 0 then
    -- ResetRequest()
    -- end

    -- local evasionRequest = GetEvasionRequest()

    -- if evasionRequest == ATTACK_REQUEST_ROLLING and env(GetStamina) > 0 then
    -- act(ChangeStamina, STAMINA_REDUCE_RIDE_DASH)

    -- act(AddSpEffect, 151902)

    -- if TRUE == IsNodeActive("RideDashAccelerate CMSG") or TRUE == IsNodeActive("RideDashAccelerateContinue CMSG") then
    -- FireRideEvent("W_RideDashAccelerateContinue", "W_RideDashAccelerateContinue", FALSE)
    -- else
    -- FireRideEvent("W_RideDashAccelerate", "W_RideDashAccelerate", FALSE)
    -- end

    -- return TRUE
    -- end
    -- end
    -- end

    return FALSE
end

function RideAttack_BackKick_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
end

function RideAttack_BackKick_onUpdate()
    SetAIActionState()
    act(DisallowAdditiveTurning, TRUE)
    if TRUE == RideAttackCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    elseif TRUE == env(MovementRequest) and GetVariable("MoveSpeedLevel") > 0 and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, TRUE, FALSE) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 0) then
        FireRideEvent("W_RideIdle", "W_RideIdle", FALSE)
    end
end

function RideAttack_BackKick_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function RideAttack_R_Top_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
end

function RideAttack_R_Top_onUpdate()
    SetAIActionState()
    act(DisallowAdditiveTurning, TRUE)
    if TRUE == RideAttackCommonFunction("W_RideAttack_R_Top02", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end
    local lower_only = TRUE
    local enable_turn = FALSE
    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end
    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideAttack_R_Top_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function RideAttack_R_Top02_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
end

function RideAttack_R_Top02_onUpdate()
    SetAIActionState()
    act(DisallowAdditiveTurning, TRUE)
    if TRUE == RideAttackCommonFunction("W_RideAttack_R_Top03", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end
    local lower_only = TRUE
    local enable_turn = FALSE
    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end
    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideAttack_R_Top02_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function RideAttack_R_Top03_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
end

function RideAttack_R_Top03_onUpdate()
    SetAIActionState()
    act(DisallowAdditiveTurning, TRUE)
    if TRUE == RideAttackCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end
    local lower_only = TRUE
    local enable_turn = FALSE
    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end
    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideAttack_R_Top03_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function RideAttack_R_Hard1_Start_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
    SetVariable("RideAttack_JumpCondition", 0)
end

function RideAttack_R_Hard1_Start_onUpdate()
    SetAIActionState()
    act(DisallowAdditiveTurning, TRUE)

    local r2 = "W_RideAttack_R_Hard1_Start"

    if TRUE == IsEnableRideAttackHard2(HAND_RIGHT) then
        r2 = "W_RideAttack_R_Hard2_Start"
    end

    if RideAttackCommonFunction("W_RideAttack_R_Top", r2, "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
        return
    end

    local attackHand = HAND_RIGHT

    if c_Style == HAND_LEFT_BOTH then
        attackHand = HAND_LEFT
    end

    local isShield = GetEquipType(attackHand, WEAPON_CATEGORY_LARGE_SHIELD, WEAPON_CATEGORY_SMALL_SHIELD, WEAPON_CATEGORY_MIDDLE_SHIELD)

    if TRUE == env(ActionRequest, 6) and (env(GetGeneralTAEFlag, TAE_FLAG_CHARGING) == 1 or TRUE == env(GetSpEffectID, 100280)) and isShield == FALSE then
        local jumpEvent = "W_RideJump_N"
        if GetVariable("MoveSpeedLevel") >= 1.5 then
            jumpEvent = "W_RideJump_D"
        elseif GetVariable("MoveSpeedLevel") >= 0.6000000238418579 then
            jumpEvent = "W_RideJump_F"
        end
        act(ChangeStamina, STAMINA_REDUCE_RIDE_JUMP)
        SetVariable("RideJumpAttack_Land", 0)
        FireRideEvent("W_RideAttack_Jump_R_Hard1", jumpEvent, FALSE)
        return TRUE
    elseif env(ActionDuration, ACTION_ARM_R2) <= 0 and (env(GetGeneralTAEFlag, TAE_FLAG_CHARGING) == 1 or TRUE == env(GetSpEffectID, 100280)) then
        ExecEventAllBody("W_RideAttack_R_Hard1_End")
    end
end

function RideAttack_R_Hard1_Start_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function RideAttack_R_Hard1_End_onActivate()
    act(ResetInputQueue)
end

function RideAttack_R_Hard1_End_onUpdate()
    act(DisallowAdditiveTurning, TRUE)

    local r2 = "W_RideAttack_R_Hard1_Start"

    if TRUE == IsEnableRideAttackHard2(HAND_RIGHT) then
        r2 = "W_RideAttack_R_Hard2_Start"
    end

    if RideAttackCommonFunction("W_RideAttack_R_Top", r2, "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if FALSE == env(GetSpEffectID, 131) and (0 == GetVariable("RideAttack_JumpCondition") or TRUE == env(IsMoveCancelPossible)) and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideAttack_R_Hard1_End_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function RideAttack_R_Hard2_Start_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
    SetVariable("RideAttack_JumpCondition", 0)
end

function RideAttack_R_Hard2_Start_onUpdate()
    SetAIActionState()
    act(DisallowAdditiveTurning, TRUE)

    if TRUE == RideAttackCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
        return
    end

    local attackHand = HAND_RIGHT

    if c_Style == HAND_LEFT_BOTH then
        attackHand = HAND_LEFT
    end

    local isShield = GetEquipType(attackHand, WEAPON_CATEGORY_LARGE_SHIELD, WEAPON_CATEGORY_SMALL_SHIELD, WEAPON_CATEGORY_MIDDLE_SHIELD)

    if TRUE == env(ActionRequest, 6) and (env(GetGeneralTAEFlag, TAE_FLAG_CHARGING) == 1 or TRUE == env(GetSpEffectID, 100280)) and isShield == FALSE then
        local jumpEvent = "W_RideJump_N"
        if GetVariable("MoveSpeedLevel") >= 1.5 then
            jumpEvent = "W_RideJump_D"
        elseif GetVariable("MoveSpeedLevel") >= 0.6000000238418579 then
            jumpEvent = "W_RideJump_F"
        end
        act(ChangeStamina, STAMINA_REDUCE_RIDE_JUMP)
        SetVariable("RideJumpAttack_Land", 0)
        FireRideEvent("W_RideAttack_Jump_R_Hard2", jumpEvent, FALSE)
        return TRUE
    elseif env(ActionDuration, ACTION_ARM_R2) <= 0 and (env(GetGeneralTAEFlag, TAE_FLAG_CHARGING) == 1 or TRUE == env(GetSpEffectID, 100280)) then
        ExecEventAllBody("W_RideAttack_R_Hard2_End")
    end
end

function RideAttack_R_Hard2_Start_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function RideAttack_R_Hard2_End_onActivate()
    act(ResetInputQueue)
end

function RideAttack_R_Hard2_End_onUpdate()
    act(DisallowAdditiveTurning, TRUE)

    if TRUE == RideAttackCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if FALSE == env(GetSpEffectID, 131) and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideAttack_R_Hard2_End_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function RideAttack_L_Hard1_Start_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
    SetVariable("RideAttack_JumpCondition", 0)
end

function RideAttack_L_Hard1_Start_onUpdate()
    SetAIActionState()
    act(DisallowAdditiveTurning, TRUE)

    local l2 = "W_RideAttack_L_Hard1_Start"

    if TRUE == IsEnableRideAttackHard2(HAND_RIGHT) then
        l2 = "W_RideAttack_L_Hard2_Start"
    end

    if RideAttackCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", l2) == TRUE then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
        return
    end

    local attackHand = HAND_RIGHT

    if c_Style == HAND_LEFT_BOTH then
        attackHand = HAND_LEFT
    end

    local isShield = GetEquipType(attackHand, WEAPON_CATEGORY_LARGE_SHIELD, WEAPON_CATEGORY_SMALL_SHIELD, WEAPON_CATEGORY_MIDDLE_SHIELD)

    if TRUE == env(ActionRequest, 6) and (env(GetGeneralTAEFlag, TAE_FLAG_CHARGING) == 1 or TRUE == env(GetSpEffectID, 100280)) and isShield == FALSE then
        local jumpEvent = "W_RideJump_N"
        if GetVariable("MoveSpeedLevel") >= 1.5 then
            jumpEvent = "W_RideJump_D"
        elseif GetVariable("MoveSpeedLevel") >= 0.6000000238418579 then
            jumpEvent = "W_RideJump_F"
        end
        act(ChangeStamina, STAMINA_REDUCE_RIDE_JUMP)
        SetVariable("RideJumpAttack_Land", 0)
        FireRideEvent("W_RideAttack_Jump_L_Hard1", jumpEvent, FALSE)
        return TRUE
    elseif env(ActionDuration, ACTION_ARM_L2) <= 0 and (env(GetGeneralTAEFlag, TAE_FLAG_CHARGING) == 1 or TRUE == env(GetSpEffectID, 100280)) then
        ExecEventAllBody("W_RideAttack_L_Hard1_End")
    end
end

function RideAttack_L_Hard1_Start_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function RideAttack_L_Hard1_End_onActivate()
    act(ResetInputQueue)
end

function RideAttack_L_Hard1_End_onUpdate()
    act(DisallowAdditiveTurning, TRUE)

    local l2 = "W_RideAttack_L_Hard1_Start"

    if TRUE == IsEnableRideAttackHard2(HAND_RIGHT) then
        l2 = "W_RideAttack_L_Hard2_Start"
    end

    if RideAttackCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", l2) == TRUE then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if FALSE == env(GetSpEffectID, 131) and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideAttack_L_Hard1_End_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function RideAttack_L_Hard2_Start_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
    SetVariable("RideAttack_JumpCondition", 0)
end

function RideAttack_L_Hard2_Start_onUpdate()
    SetAIActionState()
    act(DisallowAdditiveTurning, TRUE)

    if TRUE == RideAttackCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
        return
    end

    local attackHand = HAND_RIGHT

    if c_Style == HAND_LEFT_BOTH then
        attackHand = HAND_LEFT
    end

    local isShield = GetEquipType(attackHand, WEAPON_CATEGORY_LARGE_SHIELD, WEAPON_CATEGORY_SMALL_SHIELD, WEAPON_CATEGORY_MIDDLE_SHIELD)

    if TRUE == env(ActionRequest, 6) and (env(GetGeneralTAEFlag, TAE_FLAG_CHARGING) == 1 or TRUE == env(GetSpEffectID, 100280)) and isShield == FALSE then
        local jumpEvent = "W_RideJump_N"

        if GetVariable("MoveSpeedLevel") >= 1.5 then
            jumpEvent = "W_RideJump_D"
        elseif GetVariable("MoveSpeedLevel") >= 0.6000000238418579 then
            jumpEvent = "W_RideJump_F"
        end

        act(ChangeStamina, STAMINA_REDUCE_RIDE_JUMP)
        SetVariable("RideJumpAttack_Land", 0)
        FireRideEvent("W_RideAttack_Jump_L_Hard2", jumpEvent, FALSE)

        return TRUE
    elseif env(ActionDuration, ACTION_ARM_L2) <= 0 and (env(GetGeneralTAEFlag, TAE_FLAG_CHARGING) == 1 or TRUE == env(GetSpEffectID, 100280)) then
        ExecEventAllBody("W_RideAttack_L_Hard2_End")
    end
end

function RideAttack_L_Hard2_Start_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function RideAttack_L_Hard2_End_onActivate()
    act(ResetInputQueue)
end

function RideAttack_L_Hard2_End_onUpdate()
    act(DisallowAdditiveTurning, TRUE)

    if TRUE == RideAttackCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if FALSE == env(GetSpEffectID, 131) and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideAttack_L_Hard2_End_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function RideAttack_L_Top_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
end

function RideAttack_L_Top_onUpdate()
    SetAIActionState()
    act(DisallowAdditiveTurning, TRUE)

    local r1 = "W_RideAttack_R_Top"

    if RideAttackCommonFunction(r1, "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top02", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideAttack_L_Top_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function RideAttack_L_Top02_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
end

function RideAttack_L_Top02_onUpdate()
    SetAIActionState()
    act(DisallowAdditiveTurning, TRUE)

    local r1 = "W_RideAttack_R_Top"

    if RideAttackCommonFunction(r1, "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top03", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideAttack_L_Top02_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function RideAttack_L_Top03_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
    act(ResetInputQueue)
end

function RideAttack_L_Top03_onUpdate()
    SetAIActionState()
    act(DisallowAdditiveTurning, TRUE)

    local r1 = "W_RideAttack_R_Top"

    if RideAttackCommonFunction(r1, "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideAttack_L_Top03_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function RideAttackArrowStart_onUpdate()
    SetAIActionState()
    act(SetIsPreciseShootingPossible)
    act(DisallowAdditiveTurning, TRUE)

    if TRUE == RideAttackCommonFunction() then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        if 0 == g_ArrowSlot then
            if env(ActionDuration, ACTION_ARM_R1) > 0 then
                ExecEventAllBody("W_RideAttackArrowLoop")
                return
            end

            local fireEvent = "W_RideAttackArrowFire"

            if c_Style == HAND_LEFT_BOTH and TRUE == GetEquipType(HAND_LEFT, WEAPON_CATEGORY_CROSSBOW) then
                fireEvent = "W_RideAttackCrossbowLeftFire"
            end

            ExecEventAllBody(fireEvent)

            return
        elseif env(ActionDuration, ACTION_ARM_R2) > 0 then
            ExecEventAllBody("W_RideAttackArrowLoop")

            return
        end

        local fireEvent = "W_RideAttackArrowFire"

        if c_Style == HAND_LEFT_BOTH and TRUE == GetEquipType(HAND_LEFT, WEAPON_CATEGORY_CROSSBOW) then
            fireEvent = "W_RideAttackCrossbowLeftFire"
        end

        ExecEventAllBody(fireEvent)
    end
end

function RideAttackArrowStartContinue_onUpdate()
    SetAIActionState()
    act(SetIsPreciseShootingPossible)
    act(DisallowAdditiveTurning, TRUE)

    if TRUE == RideAttackCommonFunction() then
        return
    elseif TRUE == RideReActionFunction() then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        if g_ArrowSlot == 0 then
            if env(ActionDuration, ACTION_ARM_R1) > 0 then
                hkbFireEvent("W_RideAttackArrowLoop")
                return
            else
                hkbFireEvent("W_RideAttackArrowFire")
                return
            end
        elseif env(ActionDuration, ACTION_ARM_R2) > 0 then
            hkbFireEvent("W_RideAttackArrowLoop")
            return
        else
            hkbFireEvent("W_RideAttackArrowFire")
            return
        end
    elseif TRUE == ExecRideItem() then
        return TRUE
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
    end
end

function RideAttackArrowLoop_onUpdate()
    SetAIActionState()
    act(SetIsPreciseShootingPossible)
    act(DisallowAdditiveTurning, TRUE)

    if TRUE == RideAttackCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        act(SetAttackType, -1)
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
        return
    elseif 0 == g_ArrowSlot then
        if env(ActionDuration, ACTION_ARM_R1) <= 0 then
            local fireEvent = "W_RideAttackArrowFire"

            if c_Style == HAND_LEFT_BOTH and TRUE == GetEquipType(HAND_LEFT, WEAPON_CATEGORY_CROSSBOW) then
                fireEvent = "W_RideAttackCrossbowLeftFire"
            end

            ExecEventAllBody(fireEvent)

            return
        end
    elseif env(ActionDuration, ACTION_ARM_R2) <= 0 then
        local fireEvent = "W_RideAttackArrowFire"

        if c_Style == HAND_LEFT_BOTH and TRUE == GetEquipType(HAND_LEFT, WEAPON_CATEGORY_CROSSBOW) then
            fireEvent = "W_RideAttackCrossbowLeftFire"
        end

        ExecEventAllBody(fireEvent)
    end
end

function RideAttackArrowFire_onUpdate()
    SetAIActionState()
    act(SetIsPreciseShootingPossible)
    act(DisallowAdditiveTurning, TRUE)

    local arrowHand = 1

    if c_Style == HAND_LEFT_BOTH then
        arrowHand = 0
    end

    local is_crossbow = GetEquipType(arrowHand, WEAPON_CATEGORY_CROSSBOW)

    if TRUE == env(ActionRequest, 0) and is_crossbow == FALSE then
        act(ResetInputQueue)
        g_ArrowSlot = 0
        act(ChooseBowAndArrowSlot, 0)

        if env(IsOutOfAmmo, arrowHand) == TRUE then
            ExecEventAllBody("W_RideNoArrow")

            return TRUE
        else
            ExecEventAllBody("W_RideAttackArrowStartContinue")

            return TRUE
        end
    elseif TRUE == env(ActionRequest, 1) and env(ActionDuration, 1) > 0 and is_crossbow == FALSE then
        act(ResetInputQueue)
        g_ArrowSlot = 1
        act(ChooseBowAndArrowSlot, 1)

        if env(IsOutOfAmmo, arrowHand) == TRUE then
            ExecEventAllBody("W_RideNoArrow")

            return TRUE
        else
            ExecEventAllBody("W_RideAttackArrowStartContinue")

            return TRUE
        end
    elseif TRUE == RideAttackCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 0) then
        hkbFireEvent("W_RideIdle")
    end
end

function RideAttackArrowFire_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function RideAttackCrossbowLeftFire_onUpdate()
    SetAIActionState()
    act(SetIsPreciseShootingPossible)
    act(DisallowAdditiveTurning, TRUE)

    local arrowHand = 1

    if c_Style == HAND_LEFT_BOTH then
        arrowHand = 0
    end

    local is_crossbow = GetEquipType(arrowHand, WEAPON_CATEGORY_CROSSBOW)

    if TRUE == env(ActionRequest, 0) and is_crossbow == FALSE then
        act(ResetInputQueue)
        g_ArrowSlot = 0
        act(ChooseBowAndArrowSlot, 0)

        if env(IsOutOfAmmo, arrowHand) == TRUE then
            ExecEventAllBody("W_RideNoArrow")
            return TRUE
        else
            ExecEventAllBody("W_RideAttackArrowStartContinue")
            return TRUE
        end
    elseif TRUE == env(ActionRequest, 1) and env(ActionDuration, 1) > 0 and is_crossbow == FALSE then
        act(ResetInputQueue)
        g_ArrowSlot = 1
        act(ChooseBowAndArrowSlot, 1)

        if env(IsOutOfAmmo, arrowHand) == TRUE then
            ExecEventAllBody("W_RideNoArrow")
            return TRUE
        else
            ExecEventAllBody("W_RideAttackArrowStartContinue")
            return TRUE
        end
    elseif TRUE == RideAttackCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 0) then
        hkbFireEvent("W_RideIdle")
    end
end

function RideAttackCrossbowLeftFire_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function RideNoArrow_onUpdate()
    SetAIActionState()
    act(SetIsPreciseShootingPossible)

    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 0) then
        hkbFireEvent("W_RideIdle")
    end
end

function RideAttackCrossbowRightReload_onUpdate()
    SetAIActionState()
    act(SetIsPreciseShootingPossible)

    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 0) then
        hkbFireEvent("W_RideIdle")
    end
end

function RideAttackCrossbowLeftReload_onUpdate()
    SetAIActionState()
    act(SetIsPreciseShootingPossible)

    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    end

    local lower_only = TRUE
    local enable_turn = FALSE

    if TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        lower_only = FALSE
        enable_turn = TRUE
    end

    if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, enable_turn, lower_only) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        hkbFireEvent("W_RideIdle")
    end
end

RideJumpLoop_IsSecond = FALSE
DISABLEJUMP_FALLDIST = 20

function RideJumpCommonFunction(jump_type, lower_only, isSecond, isHighJump)
    act(DisallowAdditiveTurning, TRUE)
    SetVariable("Int16Variable01", 1)

    local damage_type = env(GetReceivedDamageType)

    if damage_type == DAMAGE_TYPE_DEATH_FALLING and isHighJump == FALSE and env(GetSpEffectID, 185) == FALSE then
        FireRideEvent("W_RideDeath", "W_RideDeath", FALSE)
        return TRUE
    end

    local height = env(GetMountFallHeight) / 100

    if TRUE == env(IsMountTrulyLanding) and IsLandDead(height) == TRUE and isHighJump == FALSE and env(GetSpEffectID, 185) == FALSE then
        act(DebugLogOutput, height)
        FireRideEvent("W_RideDeath", "W_RideDeath", FALSE)

        return
    elseif TRUE == RideReActionFunction() then
        return TRUE
    elseif TRUE == env(ActionRequest, 6) and TRUE == env(GetSpEffectID, 100902) and TRUE == RIDE_ISENABLE_DOUBLEJUMP then
        if env(GetStamina) <= 0 or height > DISABLEJUMP_FALLDIST then
            ResetRequest()
        else
            act(ChangeStamina, STAMINA_REDUCE_RIDE_JUMP)

            if GetVariable("MoveSpeedLevel") >= 1.5 then
                FireRideEvent("W_RideJump2_D", "W_RideJump2_D", FALSE)
            elseif GetVariable("MoveSpeedLevel") >= 0.6000000238418579 then
                FireRideEvent("W_RideJump2_F", "W_RideJump2_F", FALSE)
            else
                FireRideEvent("W_RideJump2_N", "W_RideJump2_N", FALSE)
            end

            RIDE_ISENABLE_DOUBLEJUMP = FALSE

            return TRUE
        end
    end

    if TRUE == env(IsMountTrulyLanding) and TRUE == env(GetMountSpEffectID, 98) and env(GetMountSpEffectID, 140) == FALSE then
        if GetVariable("MoveSpeedLevel") > 1.5 then
            FireRideEvent("W_RideJump_Land_To_Gallop", "W_RideJump_Land_To_Gallop", lower_only)
            return TRUE
        elseif GetVariable("MoveSpeedLevel") > 0.6000000238418579 then
            FireRideEvent("W_RideJump_Land_To_Dash", "W_RideJump_Land_To_Dash", lower_only)
            return TRUE
        end

        local landEvent = "W_RideJump_Land_N"

        if jump_type == 3 then
            landEvent = "W_RideJump_Land_D"
        elseif jump_type == 2 then
            landEvent = "W_RideJump_Land_F"
        end

        act(DebugLogOutput, landEvent)
        FireRideEvent(landEvent, landEvent, lower_only)

        return TRUE
    end

    local enable_jumpAttack = TRUE
    local attackHand = HAND_RIGHT

    if c_Style == HAND_LEFT_BOTH then
        attackHand = HAND_LEFT
    end

    if GetEquipType(attackHand, WEAPON_CATEGORY_ARROW, WEAPON_CATEGORY_SMALL_ARROW, WEAPON_CATEGORY_CROSSBOW) == TRUE then
        enable_jumpAttack = FALSE
    end

    local is_staff = GetEquipType(attackHand, WEAPON_CATEGORY_STAFF)

    if enable_jumpAttack == TRUE then
        if not (TRUE ~= env(ActionRequest, ACTION_ARM_R1) or is_staff ~= FALSE) or TRUE == env(ActionRequest, ACTION_ARM_R2) and is_staff == TRUE then
            SetVariable("RideJumpAttack_Land", 0)
            SetVariable("IndexRideJumpType", jump_type)
            ExecEventAllBody("W_RideAttack_Jump_R")
            RideJumpLoop_IsSecond = isSecond

            return TRUE
        elseif not (TRUE ~= env(ActionRequest, ACTION_ARM_L1) or is_staff ~= FALSE) or TRUE == env(ActionRequest, ACTION_ARM_L2) and is_staff == TRUE then
            SetVariable("RideJumpAttack_Land", 0)
            SetVariable("IndexRideJumpType", jump_type)
            ExecEventAllBody("W_RideAttack_Jump_L")
            RideJumpLoop_IsSecond = isSecond

            return TRUE
        end
    end

    if TRUE == env(IsAnimEnd, 0) and lower_only == FALSE then
        SetVariable("IndexRideJumpType", jump_type)
        if isHighJump == TRUE then
            ExecEventNoReset("W_RideJumpHigh_FallLoop")
        elseif isSecond == TRUE then
            ExecEventNoReset("W_RideJump2_Loop")
        else
            ExecEventNoReset("W_RideJump_Loop")
        end
        return TRUE
    else
        return FALSE
    end
end

function RideJump_N_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
end

function RideJump_N_onUpdate()
    if RideJumpCommonFunction(0, FALSE, FALSE, FALSE) == TRUE then
    end
end

function RideJump_F_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
end

function RideJump_F_onUpdate()
    if RideJumpCommonFunction(2, FALSE, FALSE, FALSE) == TRUE then
    end
end

function RideJump_D_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
end

function RideJump_D_onUpdate()
    if RideJumpCommonFunction(3, FALSE, FALSE, FALSE) == TRUE then
    end
end

function RideJump_Loop_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
end

function RideJump_Loop_onUpdate()
    if env(IsHamariFallDeath, 12) == TRUE and env(GetSpEffectID, 185) == FALSE then
        FireRideEvent("W_RideDeath", "W_RideDeath", FALSE)
        return
    elseif env(GetSpiritspringJumpHeight) > 0 or env(GetSpEffectID, 183) == TRUE then
        act(AddSpEffect, 186)
    end
    if TRUE == RideJumpCommonFunction(GetVariable("IndexRideJumpType"), FALSE, FALSE, FALSE) then
    end
end

function RideJump2_N_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
end

function RideJump2_N_onUpdate()
    if RideJumpCommonFunction(0, FALSE, TRUE, FALSE) == TRUE then
    end
end

function RideJump2_F_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
end

function RideJump2_F_onUpdate()
    if RideJumpCommonFunction(2, FALSE, TRUE, FALSE) == TRUE then
    end
end

function RideJump2_D_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
end

function RideJump2_D_onUpdate()
    if RideJumpCommonFunction(3, FALSE, TRUE) == TRUE then
    end
end

function RideJump2_Loop_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
end

function RideJump2_Loop_onUpdate()
    if env(IsHamariFallDeath, 12) == TRUE then
        FireRideEvent("W_RideDeath", "W_RideDeath", FALSE)
        return
    elseif env(GetSpiritspringJumpHeight) > 0 or env(GetSpEffectID, 183) == TRUE then
        act(AddSpEffect, 186)
    end
    if RideJumpCommonFunction(GetVariable("IndexRideJumpType"), FALSE, TRUE, FALSE) == TRUE then
    end
end

function RideJump_Land_N_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
end

function RideJump_Land_N_onUpdate()
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    elseif TRUE == env(IsMoveCancelPossible) then
        local moveType = RIDE_MOVE_TYPE_IDLE
        if TRUE == env(IsAnimEnd, 0) then
            moveType = RIDE_MOVE_TYPE_OTHER
        end
        if RideRequestFunction(moveType, TRUE, FALSE) == TRUE then
            return
        end
    end
    if TRUE == env(IsAnimEnd, 0) then
        FireRideEvent("W_RideIdle", "W_RideIdle", FALSE)
    end
end

function RideJump_Land_F_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
end

function RideJump_Land_F_onUpdate()
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    elseif TRUE == env(IsMoveCancelPossible) or TRUE == env(IsAnimEnd, 0) then
        local moveType = RIDE_MOVE_TYPE_IDLE
        if TRUE == env(IsAnimEnd, 0) then
            moveType = RIDE_MOVE_TYPE_OTHER
        end
        if RideRequestFunction(moveType, TRUE, FALSE) == TRUE then
        end
    end
end

function RideJump_Land_D_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
end

function RideJump_Land_D_onUpdate()
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    elseif TRUE == env(IsMoveCancelPossible) or TRUE == env(IsAnimEnd, 0) then
        local moveType = RIDE_MOVE_TYPE_IDLE
        if TRUE == env(IsAnimEnd, 0) then
            moveType = RIDE_MOVE_TYPE_OTHER
        end
        if RideRequestFunction(moveType, TRUE, FALSE) == TRUE then
        end
    end
end

function RideJump_Land_To_Dash_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
end

function RideJump_Land_To_Dash_onUpdate()
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    elseif TRUE == ExecRideStop(RIDE_MOVE_TYPE_OTHER, FALSE) then
        return
    elseif (TRUE == env(IsMoveCancelPossible) or TRUE == env(IsAnimEnd, 0)) and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, TRUE, FALSE) == TRUE then
    end
end

function RideJump_Land_To_Gallop_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
end

function RideJump_Land_To_Gallop_onUpdate()
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    elseif TRUE == ExecRideStop(RIDE_MOVE_TYPE_OTHER, FALSE) then
        return
    elseif (TRUE == env(IsMoveCancelPossible) or TRUE == env(IsAnimEnd, 0)) and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, TRUE, FALSE) == TRUE then
    end
end

function RideJumpHigh_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
end

function RideJumpHigh_onUpdate()
    act(AddSpEffect, 185)
    if env(ActionRequest, 6) == TRUE then
        FireRideEvent("W_RideJumpHigh2", "W_RideJumpHigh2", FALSE)
        RIDE_ISENABLE_DOUBLEJUMP = FALSE
        return
    elseif env(IsAnimEnd, 0) == TRUE or env(GetEventEzStateFlag, 0) == TRUE then
        rideJumpHighLoop_StopTime = 0
        lastFallHeight = 0
        rideJumpHighLoop_IsStop = FALSE
        FireRideEvent("W_RideJumpHighLoop", "W_RideJumpHighLoop", FALSE)
        return
    elseif RideJumpCommonFunction(0, FALSE, FALSE, TRUE) == TRUE then
    end
end

function RideJumpHighLoop_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
end

rideJumpHighLoop_StopTime = 0
lastFallHeight = 0
rideJumpHighLoop_IsStop = FALSE

function RideJumpHighLoop_onUpdate()
    act(AddSpEffect, 185)
    local fallHeight = env(GetMountFallHeight)
    local dT = env(ObtainedDT) / 1000
    local upSpeed = (fallHeight - lastFallHeight) / dT
    if upSpeed < 50 then
        rideJumpHighLoop_IsStop = TRUE
        rideJumpHighLoop_StopTime = rideJumpHighLoop_StopTime + dT
        act(DebugLogOutput, "RideJumpHigh current=" .. fallHeight .. "cm target=" .. Ride_HighJump_Height .. "cm upSpeed=" .. upSpeed .. "cm stopTime=" .. rideJumpHighLoop_StopTime)
        if rideJumpHighLoop_StopTime > 5 then
            act(DebugLogOutput, "RideJumpHigh Force end")
            FireRideEvent("W_RideJumpHighEnd", "W_RideJumpHighEnd", FALSE)
            return
        end
    else
        rideJumpHighLoop_IsStop = FALSE
        rideJumpHighLoop_StopTime = 0
        act(DebugLogOutput, "RideJumpHigh current=" .. fallHeight .. "cm target=" .. Ride_HighJump_Height .. "cm upSpeed=" .. upSpeed)
    end
    if -fallHeight > Ride_HighJump_Height then
        FireRideEvent("W_RideJumpHighEnd", "W_RideJumpHighEnd", FALSE)
        return
    end
    lastFallHeight = fallHeight
    if RideJumpCommonFunction(0, FALSE, FALSE, TRUE) == TRUE then
    end
end

function RideJumpHighEnd_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
end

function RideJumpHighEnd_onUpdate()
    act(AddSpEffect, 185)
    if env(ActionRequest, 6) == TRUE then
        FireRideEvent("W_RideJumpHigh2", "W_RideJumpHigh2", FALSE)
        RIDE_ISENABLE_DOUBLEJUMP = FALSE
        return
    elseif RideJumpCommonFunction(0, FALSE, FALSE, TRUE) == TRUE then
    end
end

function RideJumpHigh2_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
end

function RideJumpHigh2_onUpdate()
    act(AddSpEffect, 185)
    if RideJumpCommonFunction(0, FALSE, FALSE, TRUE) == TRUE then
    end
end

function RideJumpHigh_FallLoop_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
end

function RideJumpHigh_FallLoop_onUpdate()
    act(AddSpEffect, 185)
    if RideJumpCommonFunction(GetVariable("IndexRideJumpType"), FALSE, FALSE, TRUE) == TRUE then
    end
end

function RideJump_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
end

function RideJump_onUpdate()
    SetAIActionState()
    if GetVariable("IsEnableToggleDashTest") == 2 or GetVariable("IsEnableToggleDashTest") == 4 then
        SetVariable("ToggleDash", 0)
    end
    act(DisallowAdditiveTurning, TRUE)
    SetVariable("Int16Variable01", 1)
    if TRUE == RideReActionFunction() then
        SetVariable("Int16Variable05", 0)
        return
    elseif env(IsMountInFallLoop) == FALSE then
        if TRUE == env(ActionRequest, ACTION_ARM_R1) and TRUE == env(GetMountSpEffectID, 98) then
            act(ResetInputQueue)
            SetVariable("RideJumpAttack_Land", 0)
            ExecEventAllBody("W_RideAttack_Jump_R")
            return
        elseif TRUE == env(ActionRequest, ACTION_ARM_R2) and 0 < env(ActionDuration, 1) and env(GetMountSpEffectID, 98) == FALSE then
            act(ResetInputQueue)
            SetVariable("Int16Variable05", 0)
            hkbFireEvent("W_RideAttack_R_Hard1_Start")
            return
        elseif TRUE == env(ActionRequest, ACTION_ARM_L1) and TRUE == env(GetMountSpEffectID, 98) then
            act(ResetInputQueue)
            SetVariable("RideJumpAttack_Land", 0)
            ExecEventAllBody("W_RideAttack_Jump_L")
            return
        elseif TRUE == env(ActionRequest, ACTION_ARM_L2) and 0 < env(ActionDuration, 3) then
            act(ResetInputQueue)
            SetVariable("Int16Variable05", 0)
            hkbFireEvent("W_RideAttack_L_Hard1_Start")
            return
        end
    elseif TRUE == RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    end
    if TRUE == env(MovementRequest) and GetVariable("MoveSpeedLevel") > 0 and env(IsMountFalling) == FALSE and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, TRUE, FALSE) == TRUE then
        SetVariable("Int16Variable05", 0)
        return
    elseif env(IsAnimEnd, 0) == TRUE then
        FireRideEvent("W_RideIdle", "W_RideIdle", FALSE)
        SetVariable("Int16Variable05", 0)
    end
end

function RideAttack_Jump_R_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
end

function RideAttack_Jump_R_onUpdate()
    SetAIActionState()
    act(DisallowAdditiveTurning, TRUE)
    SetVariable("Int16Variable01", 1)

    if 1 == GetVariable("RideJumpAttack_Land") then
        if TRUE == RideCommonFunction("W_RideAttack_R_Top02", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
            return
        elseif TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
            if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, TRUE, FALSE) == TRUE then
                return
            end
        elseif ExecRideStop(RIDE_MOVE_TYPE_OTHER, TRUE) == TRUE then
            return
        elseif (TRUE == env(GetMountSpEffectID, 101100) or TRUE == env(GetMountSpEffectID, 101006) or TRUE == env(GetMountSpEffectID, 101005)) and GetVariable("MoveSpeedLevel") > 0 and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, FALSE, TRUE) == TRUE then
            return
        end
    elseif TRUE == env(GetMountSpEffectID, 98) and TRUE == env(IsTruelyLanding) and env(GetMountSpEffectID, 140) == FALSE then
        SetVariable("RideJumpAttack_Land", 1)
        RideJumpCommonFunction(GetVariable("IndexRideJumpType"), TRUE, FALSE, FALSE)
    elseif TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        if TRUE == RideJumpLoop_IsSecond then
            FireRideEvent("W_RideJump2_Loop", "W_RideJump2_Loop", FALSE)
        else
            FireRideEvent("W_RideJump_Loop", "W_RideJump_Loop", FALSE)
        end
    end
end

function RideAttack_Jump_R_Hard1_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
end

function RideAttack_Jump_R_Hard1_onUpdate()
    SetAIActionState()
    act(DisallowAdditiveTurning, TRUE)
    SetVariable("Int16Variable01", 1)
    if 1 == GetVariable("RideJumpAttack_Land") then
        local r2 = "W_RideAttack_R_Hard1_Start"
        if TRUE == IsEnableRideAttackHard2(HAND_RIGHT) then
            r2 = "W_RideAttack_R_Hard2_Start"
        end
        if RideCommonFunction("W_RideAttack_R_Top", r2, "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
            return
        elseif TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
            if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, TRUE, FALSE) == TRUE then
                return
            end
        elseif ExecRideStop(RIDE_MOVE_TYPE_OTHER, TRUE) == TRUE then
            return
        elseif (TRUE == env(GetMountSpEffectID, 101100) or TRUE == env(GetMountSpEffectID, 101006) or TRUE == env(GetMountSpEffectID, 101005)) and GetVariable("MoveSpeedLevel") > 0 and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, FALSE, TRUE) == TRUE then
            return
        end
    elseif TRUE == env(GetMountSpEffectID, 98) and TRUE == env(IsTruelyLanding) and env(GetMountSpEffectID, 140) == FALSE then
        SetVariable("RideJumpAttack_Land", 1)
        RideJumpCommonFunction(GetVariable("IndexRideJumpType"), TRUE, FALSE, FALSE)
    elseif TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        FireRideEvent("W_RideJump_Loop", "W_RideJump_Loop", FALSE)
    end
end

function RideAttack_Jump_R_Hard2_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
end

function RideAttack_Jump_R_Hard2_onUpdate()
    SetAIActionState()
    act(DisallowAdditiveTurning, TRUE)
    SetVariable("Int16Variable01", 1)
    if 1 == GetVariable("RideJumpAttack_Land") then
        if TRUE == RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
            return
        elseif TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
            if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, TRUE, FALSE) == TRUE then
                return
            end
        elseif ExecRideStop(RIDE_MOVE_TYPE_OTHER, TRUE) == TRUE then
            return
        elseif (TRUE == env(GetMountSpEffectID, 101100) or TRUE == env(GetMountSpEffectID, 101006) or TRUE == env(GetMountSpEffectID, 101005)) and GetVariable("MoveSpeedLevel") > 0 and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, FALSE, TRUE) == TRUE then
            return
        end
    elseif TRUE == env(GetMountSpEffectID, 98) and TRUE == env(IsTruelyLanding) and env(GetMountSpEffectID, 140) == FALSE then
        SetVariable("RideJumpAttack_Land", 1)
        RideJumpCommonFunction(GetVariable("IndexRideJumpType"), TRUE, FALSE, FALSE)
    elseif TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        FireRideEvent("W_RideJump_Loop", "W_RideJump_Loop", FALSE)
    end
end

function RideAttack_Jump_L_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
end

function RideAttack_Jump_L_onUpdate()
    SetAIActionState()
    act(DisallowAdditiveTurning, TRUE)
    SetVariable("Int16Variable01", 1)
    if 1 == GetVariable("RideJumpAttack_Land") then
        if TRUE == RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top02", "W_RideAttack_L_Hard1_Start") then
            return
        elseif TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
            if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, TRUE, FALSE) == TRUE then
                return
            end
        elseif ExecRideStop(RIDE_MOVE_TYPE_OTHER, TRUE) == TRUE then
            return
        elseif (TRUE == env(GetMountSpEffectID, 101100) or TRUE == env(GetMountSpEffectID, 101006) or TRUE == env(GetMountSpEffectID, 101005)) and GetVariable("MoveSpeedLevel") > 0 and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, FALSE, TRUE) == TRUE then
            return
        end
    elseif TRUE == env(GetMountSpEffectID, 98) and TRUE == env(IsTruelyLanding) and env(GetMountSpEffectID, 140) == FALSE then
        SetVariable("RideJumpAttack_Land", 1)
        RideJumpCommonFunction(GetVariable("IndexRideJumpType"), TRUE, FALSE, FALSE)
    elseif TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        FireRideEvent("W_RideJump_Loop", "W_RideJump_Loop", FALSE)
    end
end

function RideAttack_Jump_L_Hard1_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
end

function RideAttack_Jump_L_Hard1_onUpdate()
    SetAIActionState()
    act(DisallowAdditiveTurning, TRUE)
    SetVariable("Int16Variable01", 1)
    if 1 == GetVariable("RideJumpAttack_Land") then
        local l2 = "W_RideAttack_L_Hard1_Start"
        if TRUE == IsEnableRideAttackHard2(HAND_RIGHT) then
            l2 = "W_RideAttack_L_Hard2_Start"
        end
        if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", l2) == TRUE then
            return
        elseif TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
            if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, TRUE, FALSE) == TRUE then
                return
            end
        elseif ExecRideStop(RIDE_MOVE_TYPE_OTHER, TRUE) == TRUE then
            return
        elseif (TRUE == env(GetMountSpEffectID, 101100) or TRUE == env(GetMountSpEffectID, 101006) or TRUE == env(GetMountSpEffectID, 101005)) and GetVariable("MoveSpeedLevel") > 0 and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, FALSE, TRUE) == TRUE then
            return
        end
    elseif TRUE == env(GetMountSpEffectID, 98) and TRUE == env(IsTruelyLanding) and env(GetMountSpEffectID, 140) == FALSE then
        SetVariable("RideJumpAttack_Land", 1)
        RideJumpCommonFunction(GetVariable("IndexRideJumpType"), TRUE, FALSE, FALSE)
    elseif TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        FireRideEvent("W_RideJump_Loop", "W_RideJump_Loop", FALSE)
    end
end

function RideAttack_Jump_L_Hard2_onActivate()
    SetAIActionState()
    act(Unknown2025, env(Unknown404))
end

function RideAttack_Jump_L_Hard2_onUpdate()
    SetAIActionState()
    act(DisallowAdditiveTurning, TRUE)
    SetVariable("Int16Variable01", 1)
    if 1 == GetVariable("RideJumpAttack_Land") then
        if TRUE == RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
            return
        elseif TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
            if RideRequestFunction(RIDE_MOVE_TYPE_OTHER, TRUE, FALSE) == TRUE then
                return
            end
        elseif ExecRideStop(RIDE_MOVE_TYPE_OTHER, TRUE) == TRUE then
            return
        elseif (TRUE == env(GetMountSpEffectID, 101100) or TRUE == env(GetMountSpEffectID, 101006) or TRUE == env(GetMountSpEffectID, 101005)) and GetVariable("MoveSpeedLevel") > 0 and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, FALSE, TRUE) == TRUE then
            return
        end
    elseif TRUE == env(GetMountSpEffectID, 98) and TRUE == env(IsTruelyLanding) and env(GetMountSpEffectID, 140) == FALSE then
        SetVariable("RideJumpAttack_Land", 1)
        RideJumpCommonFunction(GetVariable("IndexRideJumpType"), TRUE, FALSE, FALSE)
    elseif TRUE == env(MovementRequest) or TRUE == env(IsAnimEnd, 0) then
        FireRideEvent("W_RideJump_Loop", "W_RideJump_Loop", FALSE)
    end
end

function RideTurn_Left180_onUpdate()
    RIDE_TURN_STATE = 1
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    elseif TRUE == env(MovementRequest) and GetVariable("MoveSpeedLevel") > 0 and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, TRUE, FALSE) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 0) then
        FireRideEvent("W_RideIdle", "W_RideIdle", FALSE)
    end
end

function RideTurn_Left180_onDeactivate()
    RIDE_TURN_STATE = 0
end

function RideTurn_Right180_onUpdate()
    RIDE_TURN_STATE = 1
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    elseif TRUE == env(MovementRequest) and GetVariable("MoveSpeedLevel") > 0 and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, TRUE, FALSE) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 0) then
        FireRideEvent("W_RideIdle", "W_RideIdle", FALSE)
    end
end

function RideTurn_Right180_onDeactivate()
    RIDE_TURN_STATE = 0
end

function RideTurn_Left90_onUpdate()
    RIDE_TURN_STATE = 1
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    elseif TRUE == env(MovementRequest) and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, TRUE, FALSE) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 0) then
        FireRideEvent("W_RideIdle", "W_RideIdle", FALSE)
    end
end

function RideTurn_Left90_onDeactivate()
    RIDE_TURN_STATE = 0
end

function RideTurn_Right90_onUpdate()
    RIDE_TURN_STATE = 1
    if RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") == TRUE then
        return
    elseif TRUE == env(MovementRequest) and RideRequestFunction(RIDE_MOVE_TYPE_OTHER, TRUE, FALSE) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 0) then
        FireRideEvent("W_RideIdle", "W_RideIdle", FALSE)
    end
end

function RideTurn_Right90_onDeactivate()
    RIDE_TURN_STATE = 0
end

function RideFall_Start_onUpdate()
    if RideFallCommonFunction() == TRUE then
        return
    elseif TRUE == env(IsMountInFallLoop) then
        local height = env(GetMountFallHeight)
        if IsLandDead(height / 100) == TRUE then
            FireRideEvent("W_RideDeath", "W_RideDeath", FALSE)
            return
        elseif height < 900 and height >= 200 then
            if GetVariable("MoveSpeedLevel") > 1.5 then
                FireRideEvent("W_RideJump_Land_To_Gallop", "W_RideJump_Land_To_Gallop", lower_only)
                return
            elseif GetVariable("MoveSpeedLevel") > 0.6000000238418579 then
                FireRideEvent("W_RideJump_Land_To_Dash", "W_RideJump_Land_To_Dash", lower_only)
                return
            else
                FireRideEvent("W_RideFall_Land", "W_RideFall_Land", FALSE)
                return
            end
        elseif height >= 200 then
            FireRideEvent("W_RideFall_Land", "W_RideFall_Land", FALSE)
            return
        elseif GetVariable("MoveSpeedLevel") > 1.5 or GetVariable("IsEnableToggleDashTest") >= 1 and GetVariable("ToggleDash") == 1 and GetVariable("MoveSpeedLevel") >= 0.8999999761581421 then
            FireRideEvent("W_RideGallop", "W_RideGallop", FALSE)
            return
        elseif GetVariable("MoveSpeedLevel") >= 0.6000000238418579 then
            FireRideEvent("W_RideDash", "W_RideDash", FALSE)
            return
        elseif GetVariable("MoveSpeedLevel") > 0 then
            FireRideEvent("W_RideWalk", "W_RideWalk", FALSE)
            return
        else
            FireRideEvent("W_RideIdle", "W_RideIdle", FALSE)
            return
        end
    elseif TRUE == env(IsAnimEnd, 0) then
        FireRideEvent("W_RideFall_Loop", "W_RideFall_Loop", FALSE)
    end
end

function RideFall_Loop_onUpdate()
    if RideFallCommonFunction() == TRUE then
        return
    elseif env(GetSpiritspringJumpHeight) > 0 or TRUE == env(GetSpEffectID, 183) then
        act(AddSpEffect, 186)
    end
    if TRUE == env(IsHamariFallDeath, 12) and env(GetSpEffectID, 185) == FALSE then
        FireRideEvent("W_RideDeath", "W_RideDeath", FALSE)
        return
    elseif TRUE == env(IsMountInFallLoop) then
        local height = env(GetMountFallHeight)
        if IsLandDead(height / 100) == TRUE and env(GetSpEffectID, 185) == FALSE then
            FireRideEvent("W_RideDeath", "W_RideDeath", FALSE)
            return
        elseif height < 900 then
            if GetVariable("MoveSpeedLevel") > 1.5 then
                FireRideEvent("W_RideJump_Land_To_Gallop", "W_RideJump_Land_To_Gallop", lower_only)
                return
            elseif GetVariable("MoveSpeedLevel") > 0.6000000238418579 then
                FireRideEvent("W_RideJump_Land_To_Dash", "W_RideJump_Land_To_Dash", lower_only)
                return
            end
        end
        FireRideEvent("W_RideFall_Land", "W_RideFall_Land", FALSE)
    end
end

function RideFall_Land_onUpdate()
    if RideFallCommonFunction() == TRUE then
        return
    elseif TRUE == RideCommonFunction("W_RideAttack_R_Top", "W_RideAttack_R_Hard1_Start", "W_RideAttack_L_Top", "W_RideAttack_L_Hard1_Start") then
        return
    elseif TRUE == env(IsMoveCancelPossible) or TRUE == env(IsAnimEnd, 0) then
        local moveType = RIDE_MOVE_TYPE_IDLE
        if TRUE == env(IsAnimEnd, 0) then
            moveType = RIDE_MOVE_TYPE_OTHER
        end
        if RideRequestFunction(moveType, TRUE, FALSE) == TRUE then
        end
    end
end

Jump_InitWeaponRef = FALSE
Jump_LeftWeaponRef = FALSE

function Jump_Activate()
    Jump_InitWeaponRef = FALSE
    Jump_LeftWeaponRef = FALSE

    ActivateRightArmAdd(START_FRAME_A02)
    ResetDamageCount()
end

function Jump_Update()
    UpdateRightArmAdd()

    if Jump_LeftWeaponRef == FALSE and (IsNodeActive("Jump_N Selector_Magic_Left") == TRUE or IsNodeActive("Jump_F Selector_Magic_Left") == TRUE or IsNodeActive("Jump_D Selector_Magic_Left") == TRUE or IsNodeActive("Jump_Loop_Magic_Left_CMSG") == TRUE or IsNodeActive("Jump_Land_Common_Magic_Left_Swing_Selector") == TRUE or IsNodeActive("JumpMagic_Start_Falling_ConditionSelector_Left") == TRUE or IsNodeActive("JumpMagic_Start_Falling_F_ConditionSelector_Left") == TRUE or IsNodeActive("JumpMagic_Start_Falling_D_ConditionSelector_Left") == TRUE or IsNodeActive("JumpMagic_Start_Falling_D_ConditionSelector_Left") == TRUE) then
        SetAttackHand(HAND_LEFT)
        SetGuardHand(HAND_LEFT)
        Jump_InitWeaponRef = TRUE
        Jump_LeftWeaponRef = TRUE
    end

    if FALSE == Jump_InitWeaponRef then
        local hand = HAND_RIGHT

        if c_Style == HAND_LEFT_BOTH then
            hand = HAND_LEFT
        end

        SetAttackHand(hand)
        SetGuardHand(hand)
        Jump_InitWeaponRef = TRUE

        act(SetThrowPossibilityState_Defender, 400000)
    end
end

function JumpAttackRight_Activate()
    SetAttackHand(HAND_RIGHT)
    SetGuardHand(HAND_LEFT)
end

function JumpAttackLeft_Activate()
    SetAttackHand(HAND_LEFT)
    SetGuardHand(HAND_LEFT)
end

function JumpAttackBoth_Activate()
    local hand = HAND_RIGHT
    if c_Style == HAND_LEFT_BOTH then
        hand = HAND_LEFT
    end
    SetAttackHand(hand)
    SetGuardHand(hand)
end

-- Called from:
-- JumpAttack_Start_Falling_onUpdate
-- JumpAttack_Start_Falling_F_onUpdate
-- JumpAttack_Start_Falling_D_onUpdate
-- JumpCommonFunction
-- Jump_Loop_onUpdate
function Act_Jump()
    SetEnableAimMode()

    if env(GetSpEffectID, 32) == FALSE then
        SetThrowAtkInvalid()
    end

    local damage_type = env(GetReceivedDamageType)

    if damage_type == DAMAGE_TYPE_DEATH_FALLING then
        ExecEventAllBody("W_FallDeath")
        return TRUE
    elseif env(GetHP) <= 0 and (env(GetSpecialAttribute) == DAMAGE_ELEMENT_POISON or env(GetSpecialAttribute) == DAMAGE_ELEMENT_BLIGHT) then
        SetVariable("IndexDeath", DEATH_TYPE_POISON)
        ExecEventAllBody("W_DeathStart")
        return TRUE
    else
        local height = env(GetFallHeight) / 100

        if env(IsTruelyLanding) == TRUE and IsLandDead(height) == TRUE then
            if height > 8 then
                SetVariable("IndexDeath", DEATH_TYPE_LAND)
            else
                SetVariable("IndexDeath", DEATH_TYPE_LAND_LOW)
            end
            ExecEventAllBody("W_DeathStart")
            return TRUE
        elseif ExecDamage(FALSE, FALSE) == TRUE then
            return TRUE
        else

        end
    end
end

function ExecArrowBothJumpLandAttack()
    local is_both_large_arrow = FALSE
    local is_both_ballista = FALSE
    local arrowHand = 0
    local fireEvent = Event_AttackArrowRightFireMove
    local loopEvent = Event_AttackArrowRightLoop

    if c_Style == HAND_RIGHT_BOTH then
        is_both_large_arrow = GetEquipType(HAND_RIGHT, WEAPON_CATEGORY_LARGE_ARROW)
        is_both_ballista = GetEquipType(HAND_RIGHT, WEAPON_CATEGORY_BALLISTA)
        arrowHand = 1

        if is_both_ballista == TRUE then
            fireEvent = Event_AttackCrossbowBothRightFire
            loopEvent = Event_AttackCrossbowBothRightLoop
        end
    elseif c_Style == HAND_LEFT_BOTH then
        is_both_large_arrow = GetEquipType(HAND_LEFT, WEAPON_CATEGORY_LARGE_ARROW, WEAPON_CATEGORY_BALLISTA)
        is_both_ballista = GetEquipType(HAND_LEFT, WEAPON_CATEGORY_BALLISTA)
        arrowHand = 0

        if is_both_ballista == TRUE then
            fireEvent = Event_AttackCrossbowBothRightFire
            loopEvent = Event_AttackCrossbowBothRightLoop
        else
            fireEvent = Event_AttackArrowLeftFireMove
            loopEvent = Event_AttackArrowLeftLoop
        end
    end

    if is_both_large_arrow == FALSE and is_both_ballista == FALSE then
        return FALSE
    elseif 0 == g_ArrowSlot then
        act(ChooseBowAndArrowSlot, 0)
        if env(IsOutOfAmmo, arrowHand) == TRUE then
            if is_both_ballista == TRUE then
                ExecEventHalfBlend(Event_AttackCrossbowBothRightEmpty, ALLBODY)
            else
                ExecEventAllBody("W_NoArrow")
            end

            return TRUE
        elseif 0 < env(ActionDuration, ACTION_ARM_R1) then
            ExecEventHalfBlend(loopEvent, ALLBODY)

            return TRUE
        elseif 1 <= GetVariable("JumpAttack_HandCondition") then
            ExecEventHalfBlend(fireEvent, ALLBODY)
            return TRUE
        end
    else
        act(ChooseBowAndArrowSlot, 1)

        if env(IsOutOfAmmo, arrowHand) == TRUE then
            if is_both_ballista == TRUE then
                ExecEventHalfBlend(Event_AttackCrossbowBothRightEmpty, ALLBODY)
            else
                ExecEventAllBody("W_NoArrow")
            end

            return TRUE
        elseif 0 < env(ActionDuration, ACTION_ARM_R2) then
            ExecEventHalfBlend(loopEvent, ALLBODY)

            return TRUE
        elseif 1 <= GetVariable("JumpAttack_HandCondition") then
            ExecEventHalfBlend(fireEvent, ALLBODY)
            return TRUE
        end
    end

    return FALSE
end

function JumpAttack_Start_Falling_onActivate()
    act(ResetInputQueue)
    act(Unknown4002)
    SetAIActionState()
end

function JumpAttack_Start_Falling_onUpdate()
    act(Unknown4002)
    SetAIActionState()

    if Act_Jump() == TRUE then
        return
    elseif GetVariable("JumpAttackFormRequest") == 0 then
        SetVariable("JumpAttackForm", 1)
    elseif GetVariable("JumpAttackFormRequest") == 1 then
        SetVariable("JumpAttackForm", 2)
    elseif GetVariable("JumpAttackFormRequest") == 2 then
        SetVariable("JumpAttackForm", 3)
    end

    if TRUE == env(GetSpEffectID, 98) and TRUE == env(IsTruelyLanding) and env(GetSpEffectID, 140) == FALSE and GetVariable("JumpAttack_Land") == 0 then
        local height = env(GetFallHeight) / 100
        local landIndex = GetLandIndex(height, FALSE)

        if landIndex == LAND_HEAVY then
            SetVariable("JumpAttack_Land", 2)
        else
            SetVariable("JumpAttack_Land", 1)
        end

        return
    elseif TRUE == env(GetSpEffectID, 146) then
        if GetVariable("JumpAttack_Land") == 2 then
            SetVariable("SwingPose", 5)
        else
            SetVariable("SwingPose", 4)
        end

        hkbFireEvent("W_Jump_Land_N")
        return
    elseif TRUE == env(GetEventEzStateFlag, 0) and TRUE == ExecArrowBothJumpLandAttack() then
        return
    elseif TRUE == EvasionCommonFunction(FALL_TYPE_DEFAULT, "W_AttackRightLight2", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLightStep", "W_AttackBothHeavy1Start", QUICKTYPE_ROLLING) then
    end
end

function JumpAttack_Start_Falling_F_onActivate()
    act(ResetInputQueue)
    act(Unknown4002)
    SetAIActionState()
end

function JumpAttack_Start_Falling_F_onUpdate()
    act(Unknown4002)
    SetAIActionState()

    if Act_Jump() == TRUE then
        return
    elseif GetVariable("JumpAttackFormRequest") == 0 then
        SetVariable("JumpAttackForm", 1)
    elseif GetVariable("JumpAttackFormRequest") == 1 then
        SetVariable("JumpAttackForm", 2)
    elseif GetVariable("JumpAttackFormRequest") == 2 then
        SetVariable("JumpAttackForm", 3)
    end

    if GetVariable("JumpAttackForm") >= 0 then

    else

    end

    if TRUE == env(GetSpEffectID, 98) and TRUE == env(IsTruelyLanding) and env(GetSpEffectID, 140) == FALSE then
        SetVariable("JumpAttack_Land", 1)
        return
    elseif TRUE == env(GetSpEffectID, 146) then
        SetVariable("SwingPose", 4)
        hkbFireEvent("W_Jump_Land_F")
        return
    elseif TRUE == env(GetEventEzStateFlag, 0) and TRUE == ExecArrowBothJumpLandAttack() then
        return
    elseif TRUE == EvasionCommonFunction(FALL_TYPE_DEFAULT, "W_AttackRightLight2", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLightStep", "W_AttackBothHeavy1Start", QUICKTYPE_ROLLING) then
    end
end

function JumpAttack_Start_Falling_D_onActivate()
    act(ResetInputQueue)
    act(Unknown4002)
    SetAIActionState()
end

function JumpAttack_Start_Falling_D_onUpdate()
    act(Unknown4002)
    SetAIActionState()

    if Act_Jump() == TRUE then
        return
    elseif GetVariable("JumpAttackFormRequest") == 0 then
        SetVariable("JumpAttackForm", 1)
    elseif GetVariable("JumpAttackFormRequest") == 1 then
        SetVariable("JumpAttackForm", 2)
    elseif GetVariable("JumpAttackFormRequest") == 2 then
        SetVariable("JumpAttackForm", 3)
    end

    if GetVariable("JumpAttackForm") >= 0 then

    else

    end

    if TRUE == env(GetSpEffectID, 98) and TRUE == env(IsTruelyLanding) and env(GetSpEffectID, 140) == FALSE then
        SetVariable("JumpAttack_Land", 1)
        return
    elseif TRUE == env(GetSpEffectID, 146) then
        SetVariable("SwingPose", 4)
        hkbFireEvent("W_Jump_Land_D")
        return
    elseif TRUE == env(GetEventEzStateFlag, 0) and TRUE == ExecArrowBothJumpLandAttack() then
        return
    elseif TRUE == EvasionCommonFunction(FALL_TYPE_DEFAULT, "W_AttackRightLight2", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLightStep", "W_AttackBothHeavy1Start", QUICKTYPE_ROLLING) then
    end
end

function JumpCommonFunction(jump_type)
    act(Unknown4002)

    if GetVariable("JumpAttackForm") == 0 then
        act(Unknown2050, IDX_AINOTE_STATETYPE, IDX_AINOTE_STATETYPE_JUMP_NONATTACK)
    end

    act(DisallowAdditiveTurning, TRUE)

    local height = env(GetFallHeight) / 100
    local equip_arm_no = 1

    if c_Style == HAND_LEFT_BOTH then
        equip_arm_no = 0
    end

    -- Jump
    if Act_Jump() == TRUE then
        return TRUE
        -- Jump Fall
    elseif env(GetSpEffectID, 145) == FALSE and GetVariable("JumpAttack_Land") == 0 then
        hkbFireEvent("W_Jump_Loop")
        return TRUE
    end

    local arrowHand = HAND_RIGHT

    if c_Style == HAND_LEFT_BOTH then
        arrowHand = HAND_LEFT
    end

    local is_arrow = GetEquipType(arrowHand, WEAPON_CATEGORY_SMALL_ARROW, WEAPON_CATEGORY_ARROW, WEAPON_CATEGORY_LARGE_ARROW, WEAPON_CATEGORY_CROSSBOW, WEAPON_CATEGORY_BALLISTA)

    if is_arrow == TRUE then
        if env(ActionRequest, 0) == TRUE then
            act(ChooseBowAndArrowSlot, 0)
            g_ArrowSlot = 0
        elseif TRUE == env(ActionRequest, 1) then
            act(ChooseBowAndArrowSlot, 1)
            g_ArrowSlot = 1
        end
    end

    local is_staff = GetEquipType(equip_arm_no, WEAPON_CATEGORY_STAFF)

    -- Magic
    if ExecJumpMagic(jump_type) == TRUE then
        -- Catalyst: R1
    elseif is_staff == TRUE and env(ActionRequest, 0) == TRUE then
        -- Bow
    elseif is_arrow == TRUE and (c_Style == HAND_RIGHT_BOTH or c_Style == HAND_LEFT_BOTH) and env(IsOutOfAmmo, arrowHand) == TRUE then
        -- Other
    else
        -- Crossbow
        if GetEquipType(arrowHand, WEAPON_CATEGORY_CROSSBOW) == TRUE then
            if env(GetBoltLoadingState, arrowHand) ~= FALSE then
                if env(IsOutOfAmmo, arrowHand) == TRUE then

                elseif TRUE == env(GetSpEffectID, 140) and GetVariable("JumpAttackForm") == 0 then
                    if TRUE == env(ActionRequest, ACTION_ARM_R1) or is_arrow == TRUE and TRUE == env(ActionRequest, ACTION_ARM_R2) then
                        ExecEventSync("Event_JumpNormalAttack_Add")
                        SetVariable("JumpAttackFormRequest", 0)
                        SetVariable("JumpAttackForm", 1)
                        SetInterruptType(INTERRUPT_FINDATTACK)
                        act(Unknown2025, env(Unknown404))
                        SetAIActionState()

                        return TRUE
                    elseif TRUE == env(ActionRequest, ACTION_ARM_R2) then
                        ExecEventSync("Event_JumpNormalAttack_Add")
                        SetVariable("JumpAttackFormRequest", 1)
                        SetVariable("JumpAttackForm", 2)
                        SetInterruptType(INTERRUPT_FINDATTACK)
                        act(Unknown2025, env(Unknown404))
                        SetAIActionState()

                        return TRUE
                    elseif TRUE == env(ActionRequest, ACTION_ARM_L1) and HAND_RIGHT == IsEnableDualWielding() then
                        ExecEventSync("Event_JumpNormalAttack_Add")
                        SetVariable("JumpAttackFormRequest", 2)
                        SetVariable("JumpAttackForm", 3)
                        SetInterruptType(INTERRUPT_FINDATTACK)
                        act(Unknown2025, env(Unknown404))
                        SetAIActionState()

                        return TRUE
                    elseif TRUE == env(GetSpEffectID, 98) and TRUE == env(IsTruelyLanding) and env(GetSpEffectID, 140) == FALSE then
                        if jump_type == 0 then
                            SetVariable("JumpAttack_Land", 1)
                            SetVariable("JumpMotion_Override", 0)
                            if GetVariable("JumpMotion_Override") < 0.009999999776482582 then
                                SetVariable("JumpUseMotion_Bool", 1)
                            end
                        elseif jump_type >= 1 then
                            ExecEventAllBody("W_Jump_Attack_Land_F")
                        end

                        return TRUE
                    end
                elseif env(GetSpEffectID, 140) == FALSE and GetVariable("JumpAttack_Land") == 0 and GetVariable("JumpAttackForm") == 0 then
                    SetVariable("JumpAttack_Land", 0)
                    if TRUE == env(ActionRequest, ACTION_ARM_R1) or is_arrow == TRUE and TRUE == env(ActionRequest, ACTION_ARM_R2) then
                        SetVariable("JumpAttackFormRequest", 0)
                        SetInterruptType(INTERRUPT_FINDATTACK)
                        act(Unknown2025, env(Unknown404))
                        SetAIActionState()
                        if jump_type == 0 then
                            ExecEventNoReset("W_JumpAttack_Start_Falling")
                        elseif jump_type == 1 then
                            ExecEventNoReset("W_JumpAttack_Start_Falling_F")
                        elseif jump_type == 2 then
                            ExecEventNoReset("W_JumpAttack_Start_Falling_D")
                        end

                        return TRUE
                    elseif TRUE == env(ActionRequest, ACTION_ARM_R2) then
                        SetVariable("JumpAttackFormRequest", 1)
                        SetInterruptType(INTERRUPT_FINDATTACK)
                        act(Unknown2025, env(Unknown404))
                        SetAIActionState()
                        if jump_type == 0 then
                            ExecEventNoReset("W_JumpAttack_Start_Falling")
                        elseif jump_type == 1 then
                            ExecEventNoReset("W_JumpAttack_Start_Falling_F")
                        elseif jump_type == 2 then
                            ExecEventNoReset("W_JumpAttack_Start_Falling_D")
                        end

                        return TRUE
                    elseif TRUE == env(ActionRequest, ACTION_ARM_L1) and HAND_RIGHT == IsEnableDualWielding() then
                        SetInterruptType(INTERRUPT_FINDATTACK)
                        act(Unknown2025, env(Unknown404))
                        SetAIActionState()
                        SetVariable("JumpAttackFormRequest", 2)
                        if jump_type == 0 then
                            ExecEventNoReset("W_JumpAttack_Start_Falling")
                        elseif jump_type == 1 then
                            ExecEventNoReset("W_JumpAttack_Start_Falling_F")
                        elseif jump_type == 2 then
                            ExecEventNoReset("W_JumpAttack_Start_Falling_D")
                        end

                        return TRUE
                    end
                end
            else
                if TRUE == env(GetSpEffectID, 98) and TRUE == env(IsTruelyLanding) and env(GetSpEffectID, 140) == FALSE and env(Unknown701) == FALSE then
                    local landIndex = GetLandIndex(height, FALSE)
                    SetVariable("LandIndex", landIndex)

                    if GetVariable("JumpAttackForm") == 0 then
                        local JumpMoveLevel = 0
                        if GetVariable("MoveSpeedLevel") > 1.100000023841858 then
                            JumpMoveLevel = 2
                        elseif GetVariable("MoveSpeedLevel") > 0.6000000238418579 then
                            JumpMoveLevel = 1
                        end
                        if TRUE == env(GetSpEffectID, 503520) then
                            JumpMoveLevel = 0
                        elseif TRUE == env(GetSpEffectID, 5520) then
                            JumpMoveLevel = 0
                        elseif TRUE == env(GetSpEffectID, 425) then
                            JumpMoveLevel = 0
                        elseif TRUE == env(GetSpEffectID, 4101) then
                            JumpMoveLevel = 0
                        elseif TRUE == env(GetSpEffectID, 4100) then
                            JumpMoveLevel = 0
                        end
                        if JumpMoveLevel == 2 then
                            hkbFireEvent("W_Jump_Land_To_Dash")
                        elseif JumpMoveLevel == 1 then
                            SetVariable("JumpLandMoveDirection", GetVariable("MoveDirection"))
                            hkbFireEvent("W_Jump_Land_To_Run")
                        elseif jump_type == 0 then
                            ExecEventNoReset("W_Jump_Land_N")
                        elseif jump_type == 1 then
                            ExecEventNoReset("W_Jump_Land_F")
                        elseif jump_type == 2 then
                            ExecEventNoReset("W_Jump_Land_D")
                        end
                        return TRUE
                    elseif jump_type == 0 then
                        SetVariable("JumpAttack_Land", 1)
                        SetVariable("JumpMotion_Override", 0)
                        if GetVariable("JumpMotion_Override") < 0.009999999776482582 then
                            SetVariable("JumpUseMotion_Bool", 1)
                        end
                    elseif jump_type >= 1 then
                        ExecEventAllBody("W_Jump_Attack_Land_F")
                    end

                    return TRUE
                elseif TRUE == env(GetSpEffectID, 146) and GetVariable("JumpAttackForm") ~= 0 then
                    SetVariable("SwingPose", 4)
                    if jump_type == 0 then
                        ExecEventNoReset("W_Jump_Land_N")
                    elseif jump_type == 1 then
                        ExecEventNoReset("W_Jump_Land_F")
                    elseif jump_type == 2 then
                        ExecEventNoReset("W_Jump_Land_D")
                    end
                    return TRUE
                elseif env(GetEventEzStateFlag, 0) == TRUE and GetVariable("JumpAttackForm") ~= 0 and TRUE == ExecArrowBothJumpLandAttack() then
                    return TRUE
                else
                    return FALSE
                end
            end
        elseif TRUE == env(GetSpEffectID, 140) and GetVariable("JumpAttackForm") == 0 then
            if TRUE == env(ActionRequest, ACTION_ARM_R1) or is_arrow == TRUE and TRUE == env(ActionRequest, ACTION_ARM_R2) then
                ExecEventSync("Event_JumpNormalAttack_Add")
                SetVariable("JumpAttackFormRequest", 0)
                SetVariable("JumpAttackForm", 1)
                SetInterruptType(INTERRUPT_FINDATTACK)
                act(Unknown2025, env(Unknown404))
                SetAIActionState()
                return TRUE
            elseif TRUE == env(ActionRequest, ACTION_ARM_R2) then
                ExecEventSync("Event_JumpNormalAttack_Add")
                SetVariable("JumpAttackFormRequest", 1)
                SetVariable("JumpAttackForm", 2)
                SetInterruptType(INTERRUPT_FINDATTACK)
                act(Unknown2025, env(Unknown404))
                SetAIActionState()
                return TRUE
            elseif TRUE == env(ActionRequest, ACTION_ARM_L1) and HAND_RIGHT == IsEnableDualWielding() then
                ExecEventSync("Event_JumpNormalAttack_Add")
                SetVariable("JumpAttackFormRequest", 2)
                SetVariable("JumpAttackForm", 3)
                SetInterruptType(INTERRUPT_FINDATTACK)
                act(Unknown2025, env(Unknown404))
                SetAIActionState()
                return TRUE
            elseif TRUE == env(GetSpEffectID, 98) and TRUE == env(IsTruelyLanding) and env(GetSpEffectID, 140) == FALSE then
                if jump_type == 0 then
                    SetVariable("JumpAttack_Land", 1)
                    SetVariable("JumpMotion_Override", 0)
                    if GetVariable("JumpMotion_Override") < 0.009999999776482582 then
                        SetVariable("JumpUseMotion_Bool", 1)
                    end
                elseif jump_type >= 1 then
                    ExecEventAllBody("W_Jump_Attack_Land_F")
                end
                return TRUE
            end
        elseif env(GetSpEffectID, 140) == FALSE and GetVariable("JumpAttack_Land") == 0 and GetVariable("JumpAttackForm") == 0 then
            SetVariable("JumpAttack_Land", 0)
            if TRUE == env(ActionRequest, ACTION_ARM_R1) or is_arrow == TRUE and TRUE == env(ActionRequest, ACTION_ARM_R2) then
                SetVariable("JumpAttackFormRequest", 0)
                SetInterruptType(INTERRUPT_FINDATTACK)
                act(Unknown2025, env(Unknown404))
                SetAIActionState()
                if jump_type == 0 then
                    ExecEventNoReset("W_JumpAttack_Start_Falling")
                elseif jump_type == 1 then
                    ExecEventNoReset("W_JumpAttack_Start_Falling_F")
                elseif jump_type == 2 then
                    ExecEventNoReset("W_JumpAttack_Start_Falling_D")
                end
                return TRUE
            elseif TRUE == env(ActionRequest, ACTION_ARM_R2) then
                SetVariable("JumpAttackFormRequest", 1)
                SetInterruptType(INTERRUPT_FINDATTACK)
                act(Unknown2025, env(Unknown404))
                SetAIActionState()
                if jump_type == 0 then
                    ExecEventNoReset("W_JumpAttack_Start_Falling")
                elseif jump_type == 1 then
                    ExecEventNoReset("W_JumpAttack_Start_Falling_F")
                elseif jump_type == 2 then
                    ExecEventNoReset("W_JumpAttack_Start_Falling_D")
                end
                return TRUE
            elseif TRUE == env(ActionRequest, ACTION_ARM_L1) and HAND_RIGHT == IsEnableDualWielding() then
                SetInterruptType(INTERRUPT_FINDATTACK)
                act(Unknown2025, env(Unknown404))
                SetAIActionState()
                SetVariable("JumpAttackFormRequest", 2)
                if jump_type == 0 then
                    ExecEventNoReset("W_JumpAttack_Start_Falling")
                elseif jump_type == 1 then
                    ExecEventNoReset("W_JumpAttack_Start_Falling_F")
                elseif jump_type == 2 then
                    ExecEventNoReset("W_JumpAttack_Start_Falling_D")
                end
                return TRUE
            end
        end
    end

    -- Landing
    if env(GetSpEffectID, 98) == TRUE and env(IsTruelyLanding) == TRUE and env(GetSpEffectID, 140) == FALSE and env(Unknown701) == FALSE then
        local landIndex = GetLandIndex(height, FALSE)
        SetVariable("LandIndex", landIndex)

        if GetVariable("JumpAttackForm") == 0 then
            local JumpMoveLevel = 0

            if GetVariable("MoveSpeedLevel") > 1.100000023841858 then
                JumpMoveLevel = 2
            elseif GetVariable("MoveSpeedLevel") > 0.6000000238418579 then
                JumpMoveLevel = 1
            end

            -- Ironjar Aromatic
            if TRUE == env(GetSpEffectID, 503520) then
                JumpMoveLevel = 0
                -- Unknown
            elseif TRUE == env(GetSpEffectID, 5520) then
                JumpMoveLevel = 0
                -- Slug: Slow
            elseif TRUE == env(GetSpEffectID, 425) then
                JumpMoveLevel = 0
                -- Sanguine Noble: Slow
            elseif TRUE == env(GetSpEffectID, 4101) then
                JumpMoveLevel = 0
                -- Sanguine Noble: Slow
            elseif TRUE == env(GetSpEffectID, 4100) then
                JumpMoveLevel = 0
            end

            if JumpMoveLevel == 2 then
                hkbFireEvent("W_Jump_Land_To_Dash")
            elseif JumpMoveLevel == 1 then
                SetVariable("JumpLandMoveDirection", GetVariable("MoveDirection"))
                hkbFireEvent("W_Jump_Land_To_Run")
            elseif jump_type == 0 then
                ExecEventNoReset("W_Jump_Land_N")
            elseif jump_type == 1 then
                ExecEventNoReset("W_Jump_Land_F")
            elseif jump_type == 2 then
                ExecEventNoReset("W_Jump_Land_D")
            end

            return TRUE
        elseif jump_type == 0 then
            SetVariable("JumpAttack_Land", 1)
            SetVariable("JumpMotion_Override", 0)

            if GetVariable("JumpMotion_Override") < 0.009999999776482582 then
                SetVariable("JumpUseMotion_Bool", 1)
            end
        elseif jump_type >= 1 then
            ExecEventAllBody("W_Jump_Attack_Land_F")
        end

        return TRUE
        -- 146 "[HKS] Swing Window"
    elseif TRUE == env(GetSpEffectID, 146) and GetVariable("JumpAttackForm") ~= 0 then
        SetVariable("SwingPose", 4)

        if jump_type == 0 then
            ExecEventNoReset("W_Jump_Land_N")
        elseif jump_type == 1 then
            ExecEventNoReset("W_Jump_Land_F")
        elseif jump_type == 2 then
            ExecEventNoReset("W_Jump_Land_D")
        end

        return TRUE
    elseif env(GetEventEzStateFlag, 0) == TRUE and GetVariable("JumpAttackForm") ~= 0 and TRUE == ExecArrowBothJumpLandAttack() then
        return TRUE
    else
        return FALSE
    end
end

function ExecJumpMagic(jump_type)
    if c_HasActionRequest == FALSE then
        return FALSE
    elseif FALSE == env(ActionRequest, ACTION_ARM_MAGIC_R) and FALSE == env(ActionRequest, ACTION_ARM_MAGIC_L) then
        return FALSE
    elseif env(GetStamina) <= 0 then
        ResetRequest()
        return FALSE
    elseif GetVariable("JumpAttackForm") >= 1 or IS_ATTACKED_JUMPMAGIC == TRUE then
        ResetRequest()
        return FALSE
    elseif env(IsMagicUseMenuOpened) == TRUE then
        return FALSE
    end

    local style = c_Style
    local magic_hand = HAND_RIGHT
    local hand = nil

    if env(ActionRequest, ACTION_ARM_MAGIC_R) == TRUE then
        if style == HAND_LEFT_BOTH then
            if FALSE == GetEquipType(HAND_LEFT, WEAPON_CATEGORY_STAFF) then
                return FALSE
            end

            hand = HAND_LEFT
        else
            if FALSE == GetEquipType(HAND_RIGHT, WEAPON_CATEGORY_STAFF) then
                return FALSE
            end

            hand = HAND_RIGHT
        end
    elseif env(ActionRequest, ACTION_ARM_MAGIC_L) == TRUE then
        if style == HAND_RIGHT_BOTH or style == HAND_LEFT_BOTH then
            return FALSE
        elseif FALSE == GetEquipType(HAND_LEFT, WEAPON_CATEGORY_STAFF) then
            return FALSE
        end

        hand = HAND_LEFT
        magic_hand = HAND_LEFT

        act(DebugLogOutput, "MagicLeft")
    else
        return FALSE
    end

    act(Unknown2026)
    act(MarkOfGreedyPersonSlipDamageDisable)

    if FALSE == IsJumpMagic() and FALSE == IsQuickMagic() then
        ResetRequest()
        return FALSE
    elseif env(IsMagicUseable, hand, 0) == FALSE then
        ResetRequest()
        return FALSE
    end

    local magic_index = env(GetMagicAnimType)

    if magic_index == 254 or magic_index == 255 then
        ResetRequest()
        return FALSE
    end

    if magic_index == MAGIC_REQUEST_WHIP or magic_index == MAGIC_REQUEST_SLASH or magic_index == MAGIC_REQUEST_QUICKSLASH or magic_index == MAGIC_REQUEST_FLAME_GRAB or magic_index == MAGIC_REQUEST_CRUSH or magic_index == MAGIC_REQUEST_CHOP or magic_index == MAGIC_REQUEST_SCYTHE then

    end

    if TRUE == IsJumpMagic() then
        if magic_hand == HAND_RIGHT then
            ExecEventHalfBlend(Event_MagicFireRightJump, ALLBODY)
        else
            ExecEventHalfBlend(Event_MagicFireLeftJump, ALLBODY)
        end

        IS_ATTACKED_JUMPMAGIC = TRUE
        act(SetIsMagicInUse, TRUE)
        act(Unknown2025, env(Unknown404))
        SetAIActionState()

        return TRUE
    elseif env(GetSpEffectID, 140) == TRUE and 0 == GetVariable("JumpAttackForm") then
        ExecEventSync("Event_JumpNormalAttack_Add")
        SetVariable("JumpAttackFormRequest", 3)
        SetVariable("JumpAttackForm", 4)

        if hand == HAND_LEFT and c_Style == HAND_RIGHT then
            SetVariable("JumpAttack_HandCondition", 2)
        else
            SetVariable("JumpAttack_HandCondition", 0)
        end

        act(SetIsMagicInUse, TRUE)
        act(Unknown2025, env(Unknown404))
        SetAIActionState()

        return TRUE
    elseif FALSE == env(GetSpEffectID, 140) and 0 == GetVariable("JumpAttack_Land") and 0 == GetVariable("JumpAttackForm") then
        SetVariable("JumpAttack_Land", 0)
        SetVariable("JumpAttackFormRequest", 3)
        SetVariable("JumpAttackForm", 4)

        if hand == HAND_LEFT and c_Style == HAND_RIGHT then
            SetVariable("JumpAttack_HandCondition", 2)
        else
            SetVariable("JumpAttack_HandCondition", 0)
        end

        if jump_type == 0 then
            ExecEventNoReset("W_JumpAttack_Start_Falling")
        elseif jump_type == 1 then
            ExecEventNoReset("W_JumpAttack_Start_Falling_F")
        elseif jump_type == 2 then
            ExecEventNoReset("W_JumpAttack_Start_Falling_D")
        end

        act(SetIsMagicInUse, TRUE)
        act(Unknown2025, env(Unknown404))
        SetAIActionState()

        return TRUE
    else

    end
end

function ExecFallMagic()
    if c_HasActionRequest == FALSE then
        return FALSE
    elseif FALSE == env(ActionRequest, ACTION_ARM_MAGIC_R) and FALSE == env(ActionRequest, ACTION_ARM_MAGIC_L) then
        return FALSE
    elseif env(GetStamina) <= 0 then
        ResetRequest()
        return FALSE
    elseif GetVariable("JumpAttackForm") >= 1 or IS_ATTACKED_JUMPMAGIC == TRUE then
        ResetRequest()
        return FALSE
    elseif env(IsMagicUseMenuOpened) == TRUE then
        return FALSE
    end

    local style = c_Style
    local magic_hand = HAND_RIGHT
    local hand = nil

    if env(ActionRequest, ACTION_ARM_MAGIC_R) == TRUE then
        if style == HAND_LEFT_BOTH then
            if FALSE == GetEquipType(HAND_LEFT, WEAPON_CATEGORY_STAFF) then
                return FALSE
            end

            hand = HAND_LEFT
        else
            if FALSE == GetEquipType(HAND_RIGHT, WEAPON_CATEGORY_STAFF) then
                return FALSE
            end

            hand = HAND_RIGHT
        end
    elseif env(ActionRequest, ACTION_ARM_MAGIC_L) == TRUE then
        if style == HAND_RIGHT_BOTH or style == HAND_LEFT_BOTH then
            return FALSE
        elseif FALSE == GetEquipType(HAND_LEFT, WEAPON_CATEGORY_STAFF) then
            return FALSE
        end

        hand = HAND_LEFT
        magic_hand = HAND_LEFT

        act(DebugLogOutput, "MagicLeft")
    else
        return FALSE
    end

    act(Unknown2026)
    act(MarkOfGreedyPersonSlipDamageDisable)

    if FALSE == IsJumpMagic() and FALSE == IsQuickMagic() then
        ResetRequest()
        return FALSE
    elseif env(IsMagicUseable, hand, 0) == FALSE then
        ResetRequest()
        return FALSE
    end

    local magic_index = env(GetMagicAnimType)

    if magic_index == 254 or magic_index == 255 then
        ResetRequest()
        return FALSE
    end

    if magic_index == MAGIC_REQUEST_WHIP or magic_index == MAGIC_REQUEST_SLASH or magic_index == MAGIC_REQUEST_QUICKSLASH or magic_index == MAGIC_REQUEST_FLAME_GRAB or magic_index == MAGIC_REQUEST_CRUSH or magic_index == MAGIC_REQUEST_CHOP or magic_index == MAGIC_REQUEST_SCYTHE then

    end

    if TRUE == IsJumpMagic() then
        if magic_hand == HAND_RIGHT then
            ExecEventHalfBlend(Event_MagicFireRightJump, ALLBODY)
        else
            ExecEventHalfBlend(Event_MagicFireLeftJump, ALLBODY)
        end

        IS_ATTACKED_JUMPMAGIC = TRUE
        act(SetIsMagicInUse, TRUE)
        act(Unknown2025, env(Unknown404))
        SetAIActionState()

        return TRUE
    end

    SetVariable("JumpAttack_Land", 0)
    SetVariable("JumpAttackFormRequest", 3)
    SetVariable("JumpAttackForm", 4)

    if hand == HAND_LEFT and c_Style == HAND_RIGHT then
        SetVariable("JumpAttack_HandCondition", 2)
    else
        SetVariable("JumpAttack_HandCondition", 0)
    end

    ExecEventNoReset("W_JumpAttack_Start_Falling")
    act(SetIsMagicInUse, TRUE)
    act(Unknown2025, env(Unknown404))
    SetAIActionState()

    return TRUE
end

function Jump_Overweight_onActivate()
    SetAIActionState()
end

function Jump_Overweight_onUpdate()
    SetAIActionState()

    if EvasionCommonFunction(FALL_TYPE_DEFAULT, "W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", QUICKTYPE_ROLLING) == TRUE then
    end
end

function Jump_Overweight_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function Jump_N_onActivate()
    act(Unknown4002)
    SetAIActionState()
end

function Jump_N_onUpdate()
    SetAIActionState()
    JUMP_STATE_1 = 1
    JUMP_STATE_2 = 0
    JUMP_STATE_3 = 0

    if 0 == GetVariable("JumpReachSelector") and 0 < GetVariable("MoveSpeedLevel") then
        SetVariable("JumpReachSelector", 1)

        if GetVariable("IsLockon") == true then
            local jumpangle = GetVariable("MoveAngle")
            if jumpangle > -45 and jumpangle < 45 then
                SetVariable("JumpDirection", 0)
            elseif jumpangle >= 45 and jumpangle <= 135 then
                SetVariable("JumpDirection", 3)
            elseif jumpangle >= -135 and jumpangle <= -45 then
                SetVariable("JumpDirection", 2)
            else
                SetVariable("JumpDirection", 1)
            end
        else
            SetVariable("JumpDirection", 0)
        end
    end

    if JumpCommonFunction(0) == TRUE then
    end
end

function Jump_N_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function Jump_F_onActivate()
    act(Unknown4002)
    SetAIActionState()
end

function Jump_F_onUpdate()
    SetAIActionState()
    JUMP_STATE_1 = 0
    JUMP_STATE_2 = 1
    JUMP_STATE_3 = 0

    local rolling_angle = GetVariable("JumpAngle")
    local addratio = 0.4000000059604645
    local jump_movement_mult = 1 + addratio * math.abs(math.sin(math.rad(2 * rolling_angle)))

    jump_movement_mult = math.abs(jump_movement_mult)

    act(SetMovementScaleMult, jump_movement_mult)

    if JumpCommonFunction(1) == TRUE then
    end
end

function Jump_F_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function Jump_D_onActivate()
    act(Unknown4002)
    SetAIActionState()
end

function Jump_D_onUpdate()
    SetAIActionState()
    JUMP_STATE_1 = 0
    JUMP_STATE_2 = 0
    JUMP_STATE_3 = 1

    if 0 == GetVariable("JumpAttackForm") then
        act(LockonFixedAngleCancel)
    end

    if JumpCommonFunction(2) == TRUE then
    end
end

function Jump_D_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function Jump_RideOff_onActivate()
    act(Unknown4002)
    SetAIActionState()
end

function Jump_RideOff_onUpdate()
    SetAIActionState()
    JUMP_STATE_1 = 0
    JUMP_STATE_2 = 0
    JUMP_STATE_3 = 1

    if 0 == GetVariable("JumpAttackForm") then
        act(LockonFixedAngleCancel)
    end

    if JumpCommonFunction(2) == TRUE then
        act(Unknown3005)
    end
end

function Jump_RideOff_onDeactivate()
    act(Unknown3005)
    act(DisallowAdditiveTurning, FALSE)
end

function Jump_Loop_onActivate()
    SetAIActionState()
end

function Jump_Loop_onUpdate()
    SetAIActionState()
    act(DisallowAdditiveTurning, TRUE)

    if TRUE == env(IsHamariFallDeath, 12) then
        ExecEvent("W_FallDeath")
        return
    end
    local height = env(GetFallHeight) / 100
    if height >= 60 then
        if TRUE == env(GetStateChangeType, 266) then
        else
            ExecEventAllBody("W_FallDeath")
            return TRUE
        end
    end
    if TRUE == Act_Jump() then
        return
    end
    local equip_arm_no = 1

    if c_Style == HAND_LEFT_BOTH then
        equip_arm_no = 0
    end

    local arrowHand = 1

    if c_Style == HAND_LEFT_BOTH then
        arrowHand = 0
    end

    local is_arrow = GetEquipType(arrowHand, WEAPON_CATEGORY_SMALL_ARROW, WEAPON_CATEGORY_ARROW, WEAPON_CATEGORY_LARGE_ARROW, WEAPON_CATEGORY_CROSSBOW, WEAPON_CATEGORY_BALLISTA)

    if is_arrow == TRUE then
        if TRUE == env(ActionRequest, 0) then
            act(ChooseBowAndArrowSlot, 0)
            g_ArrowSlot = 0
        elseif TRUE == env(ActionRequest, 1) then
            act(ChooseBowAndArrowSlot, 1)
            g_ArrowSlot = 1
        end
    end

    if TRUE == ExecJumpMagic(0) then
    elseif env(GetEquipWeaponCategory, equip_arm_no) == WEAPON_CATEGORY_STAFF and TRUE == env(ActionRequest, 0) then
    elseif is_arrow == TRUE and (c_Style == HAND_RIGHT_BOTH or c_Style == HAND_LEFT_BOTH or GetEquipType(arrowHand, WEAPON_CATEGORY_CROSSBOW) == TRUE) and env(IsOutOfAmmo, arrowHand) == TRUE then
    elseif GetEquipType(arrowHand, WEAPON_CATEGORY_CROSSBOW) == TRUE and env(GetBoltLoadingState, arrowHand) == FALSE then
    elseif TRUE == env(ActionRequest, ACTION_ARM_R1) and 0 == GetVariable("JumpAttackForm") then
        SetVariable("JumpAttackForm", 1)
        SetVariable("JumpAttackFormRequest", 0)
        hkbFireEvent("W_JumpAttack_Start_Falling")
        return
    elseif TRUE == env(ActionRequest, ACTION_ARM_R2) and 0 == GetVariable("JumpAttackForm") then
        if is_arrow == TRUE then
            SetVariable("JumpAttackForm", 1)
            SetVariable("JumpAttackFormRequest", 0)
            hkbFireEvent("W_JumpAttack_Start_Falling")
            return
        else
            SetVariable("JumpAttackForm", 2)
            SetVariable("JumpAttackFormRequest", 1)
            hkbFireEvent("W_JumpAttack_Start_Falling")
            return
        end
    elseif TRUE == env(ActionRequest, ACTION_ARM_L1) and IsEnableDualWielding() == HAND_RIGHT then
        SetVariable("JumpAttackForm", 3)
        SetVariable("JumpAttackFormRequest", 2)
        hkbFireEvent("W_JumpAttack_Start_Falling")
        return
    end

    if 1 <= GetVariable("JumpAttackForm") then
        act(ResetInputQueue)
    end

    local landIndex = GetLandIndex(height, FALSE)

    if TRUE == env(GetSpEffectID, 141) then
        SetVariable("SwingPose", 0)
    elseif TRUE == env(GetSpEffectID, 142) then
        SetVariable("SwingPose", 0)
    elseif TRUE == env(GetSpEffectID, 143) then
        SetVariable("SwingPose", 0)
    elseif TRUE == env(GetSpEffectID, 144) then
        if landIndex == LAND_HEAVY then
            SetVariable("SwingPose", 3)
        else
            SetVariable("SwingPose", 2)
        end
    elseif TRUE == env(GetSpEffectID, 145) then
        SetVariable("SwingPose", 4)
    elseif landIndex == LAND_HEAVY then
        SetVariable("SwingPose", 3)
    else
        SetVariable("SwingPose", 2)
    end

    if TRUE == env(GetSpEffectID, 98) and TRUE == env(IsTruelyLanding) then
        SetVariable("LandIndex", landIndex)
        local JumpMoveLevel = 0

        if landIndex == 0 and 0 == GetVariable("JumpAttackForm") then
            if GetVariable("MoveSpeedLevel") > 1.100000023841858 then
                JumpMoveLevel = 2
            elseif GetVariable("MoveSpeedLevel") > 0.6000000238418579 then
                JumpMoveLevel = 1
            end
        end

        if TRUE == env(GetSpEffectID, 503520) then
            JumpMoveLevel = 0
        elseif TRUE == env(GetSpEffectID, 5520) then
            JumpMoveLevel = 0
        elseif TRUE == env(GetSpEffectID, 425) then
            JumpMoveLevel = 0
        elseif TRUE == env(GetSpEffectID, 4101) then
            JumpMoveLevel = 0
        elseif TRUE == env(GetSpEffectID, 4100) then
            JumpMoveLevel = 0
        end
        if JumpMoveLevel == 2 then
            ExecEventNoReset("W_Jump_Land_To_Dash")
            return
        elseif JumpMoveLevel == 1 then
            SetVariable("JumpLandMoveDirection", GetVariable("MoveDirection"))
            ExecEventNoReset("W_Jump_Land_To_Run")
            return
        elseif landIndex > 0 then
            ResetRequest()
        end
        if 1 == JUMP_STATE_1 then
            ExecEventNoReset("W_Jump_Land_N")
        elseif 1 == JUMP_STATE_2 then
            ExecEventNoReset("W_Jump_Land_F")
        elseif 1 == JUMP_STATE_3 then
            ExecEventNoReset("W_Jump_Land_D")
        else
            ExecEventNoReset("W_Jump_Land_N")
        end
    end
end

function Jump_Loop_onDeactivate()
    act(DisallowAdditiveTurning, FALSE)
end

function Jump_LandAttack_Normal_onActivate()
    act(ResetInputQueue)
    SetAIActionState()
end

function Jump_LandAttack_Normal_onUpdate()
    SetAIActionState()

    if EvasionCommonFunction(FALL_TYPE_DEFAULT, "W_AttackRightLight2", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight2", "W_AttackBothHeavy1Start", QUICKTYPE_ROLLING) == TRUE then
    end
end

function Jump_LandAttack_Normal_onDeactivate()
    SetVariable("JumpAttackForm", 0)
    SetVariable("SwingPose", 0)
end

function Jump_LandAttack_Hard_onActivate()
    act(ResetInputQueue)
    SetAIActionState()
end

function Jump_LandAttack_Hard_onUpdate()
    SetAIActionState()

    if EvasionCommonFunction(FALL_TYPE_DEFAULT, "W_AttackRightLight2", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight2", "W_AttackBothHeavy1Start", QUICKTYPE_ROLLING) == TRUE then
    end
end

function Jump_LandAttack_Hard_onDeactivate()
    SetVariable("JumpAttackForm", 0)
    SetVariable("SwingPose", 0)
end

function JumpLandCommonFunction()
    SetEnableAimMode()

    if env(GetSpEffectID, 141) == TRUE then
        if TRUE == EvasionCommonFunction(FALL_TYPE_DEFAULT, "W_Jump_LandAttack_Normal", "W_Jump_LandAttack_Hard", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_Jump_LandAttack_Normal", "W_Jump_LandAttack_Hard", QUICKTYPE_ROLLING) then
            return TRUE
        end
    elseif GetVariable("JumpAttackForm") == 1 or GetVariable("JumpAttackForm") == 2 or GetVariable("JumpAttackForm") == 3 then
        if env(GetEventEzStateFlag, 0) == TRUE and TRUE == ExecArrowBothJumpLandAttack() then
            return TRUE
        end

        local r1 = "W_AttackRightLightSubStart"
        local b1 = "W_AttackBothLightSubStart"

        if TRUE == g_ComboReset then
            r1 = "W_AttackRightLight1"
            b1 = "W_AttackBothLight1"
        end

        if EvasionCommonFunction(FALL_TYPE_DEFAULT, r1, "W_AttackRightHeavy1Start", "W_AttackLeftLight2", "W_AttackLeftHeavy1", b1, "W_AttackBothHeavy1Start", QUICKTYPE_ROLLING) == TRUE then
            return TRUE
        end
    elseif TRUE == EvasionCommonFunction(FALL_TYPE_DEFAULT, "W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", QUICKTYPE_ROLLING) then
        return TRUE
    end

    return FALSE
end

function Jump_Land_N_onUpdate()
    if JumpLandCommonFunction() == TRUE then
    end
end

function Jump_Land_N_onDeactivate()
    SetVariable("JumpAttack_Land", 0)
end

function Jump_Land_F_onUpdate()
    if JumpLandCommonFunction() == TRUE then
    end
end

function Jump_Land_D_onUpdate()
    if JumpLandCommonFunction() == TRUE then
    end
end

function Jump_Attack_Land_F_onUpdate()
    if JumpLandCommonFunction() == TRUE then
        return
    elseif TRUE == env(GetSpEffectID, 146) then
        SetVariable("SwingPose", 4)
        hkbFireEvent("W_Jump_Land_N")
    end
end

function Jump_Land_To_Run_onUpdate()
    act(SwitchMotion, TRUE)
    SetEnableAimMode()
    SetVariable("JumpLandMoveDirection", GetVariable("MoveDirection"))
    SetVariable("MoveSpeedLevelReal", 1)

    if TRUE == ExecStop() then
        return
    elseif TRUE == env(IsMoveCancelPossible) and TRUE == MoveStart(ALLBODY, Event_MoveLong, FALSE) then
        return
    elseif TRUE == EvasionCommonFunction(FALL_TYPE_DEFAULT, "W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", QUICKTYPE_NORMAL) then
    end
end

function Jump_Land_To_Dash_onUpdate()
    act(LockonFixedAngleCancel)
    SetEnableAimMode()
    SetVariable("MoveSpeedLevelReal", 2)

    if ExecStop() == TRUE then
        return
    elseif TRUE == env(IsMoveCancelPossible) and TRUE == MoveStart(ALLBODY, Event_MoveLong, FALSE) then
        return
    elseif TRUE == EvasionCommonFunction(FALL_TYPE_DEFAULT, "W_AttackRightLightDash", "W_AttackRightHeavyDash", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothDash", "W_AttackBothHeavyDash", QUICKTYPE_NORMAL) then
    end
end

function JumpDamage_Start_onActivate()
    act(ResetInputQueue)
end

function JumpDamage_Start_onUpdate()
    JUMP_STATE_1 = 1
    JUMP_STATE_2 = 0
    JUMP_STATE_3 = 0

    act(DenyEventAnimPlaybackRequest)

    local height = env(GetFallHeight) / 100
    local damage_type = env(GetReceivedDamageType)

    if env(IsHamariFallDeath, 12) == TRUE or damage_type == DAMAGE_TYPE_DEATH_FALLING or height >= 60 then
        ExecEventAllBody("W_FallDeath")
        return TRUE
    elseif env(GetSpEffectID, 98) == TRUE and env(IsTruelyLanding) == TRUE then
        hkbFireEvent("W_JumpDamage_Land")
    end
end

function JumpDamage_Land_onActivate()
    act(ResetInputQueue)
end

function JumpDamage_Land_onUpdate()
    act(DenyEventAnimPlaybackRequest)
    if EvasionCommonFunction(FALL_TYPE_DEFAULT, "W_AttackRightLight1", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLight1", "W_AttackBothHeavy1Start", QUICKTYPE_ROLLING) == TRUE then
    end
end

function SetStealthState(state)
    SetVariable("StealthState", state)
end

function Stealth_Deactivate()
    SetStealthState(STEALTH_NONE)
end

function StealthActionCommonFunction(fall_type, r1, r2, l1, l2, b1, b2, quick_type)
    SetAIActionState()
    SetEnableAimMode()
    if ExecPassiveAction(FALSE, fall_type, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecJump() then
        return TRUE
    elseif ExecHandChange(HAND_RIGHT, FALSE, ALLBODY) == TRUE then
        return TRUE
    elseif ExecGuardOnCancelTiming(FALSE, ALLBODY) == TRUE then
        return TRUE
    elseif TRUE == ExecWeaponChange(ALLBODY) then
        return TRUE
    elseif ExecEvasion(FALSE, ESTEP_NONE, FALSE) == TRUE then
        return TRUE
    elseif ExecItem(quick_type, ALLBODY) == TRUE then
        return TRUE
    elseif ExecMagic(quick_type, ALLBODY, FALSE) == TRUE then
        return TRUE
    elseif TRUE == ExecArtsStanceOnCancelTiming(ALLBODY) then
        return TRUE
    elseif ExecAttack(r1, r2, l1, l2, b1, b2, FALSE, ALLBODY, FALSE, FALSE, FALSE) == TRUE then
        return TRUE
    elseif MoveStartonCancelTiming(Event_MoveLong, FALSE) == TRUE then
        return TRUE
    else
        return FALSE
    end
end

function StealthAttackArrow_Activate()
    local hand = HAND_RIGHT
    if c_Style == HAND_LEFT_BOTH then
        hand = HAND_LEFT
    end
    SetAttackHand(hand)
end

function StealthAttackArrowStart_Upper_onActivate()
    act(ResetInputQueue)
end

function StealthAttackArrowStart_Upper_onUpdate()
    act(SetIsPreciseShootingPossible)
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if ArrowCommonFunction(blend_type, FALSE, TURN_TYPE_STANCE) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        if g_ArrowSlot == 0 then
            if env(ActionDuration, ACTION_ARM_R1) > 0 then
                ExecEventHalfBlend(Event_StealthAttackArrowLoop, blend_type)
                return
            else
                ExecEventAllBody("W_StealthAttackArrowShot")
                return
            end
        elseif env(ActionDuration, ACTION_ARM_R2) > 0 then
            ExecEventHalfBlend(Event_StealthAttackArrowLoop, blend_type)
            return
        else
            ExecEventAllBody("W_StealthAttackArrowShot")
            return
        end
    elseif ArrowLowerCommonFunction(Event_StealthAttackArrowStart, lower_state, FALSE) == TRUE then
    end
end

function StealthAttackArrowStartContinue_Upper_onActivate()
    act(ResetInputQueue)
end

function StealthAttackArrowStartContinue_Upper_onUpdate()
    act(SetIsPreciseShootingPossible)
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if ArrowCommonFunction(blend_type, FALSE, TURN_TYPE_STANCE) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        if g_ArrowSlot == 0 then
            if env(ActionDuration, ACTION_ARM_R1) > 0 then
                ExecEventHalfBlend(Event_StealthAttackArrowLoop, blend_type)
                return
            else
                ExecEventAllBody("W_StealthAttackArrowShot")
                return
            end
        elseif env(ActionDuration, ACTION_ARM_R2) > 0 then
            ExecEventHalfBlend(Event_StealthAttackArrowLoop, blend_type)
            return
        else
            ExecEventAllBody("W_StealthAttackArrowShot")
            return
        end
    elseif ArrowLowerCommonFunction(Event_StealthAttackArrowStartContinue, lower_state, FALSE) == TRUE then
    end
end

function StealthAttackArrowLoop_Upper_onUpdate()
    act(SetIsPreciseShootingPossible)
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if ArrowCommonFunction(blend_type, FALSE, TURN_TYPE_STANCE) == TRUE then
        return
    elseif g_ArrowSlot == 0 then
        if 0 >= env(ActionDuration, ACTION_ARM_R1) then
            ExecEventAllBody("W_StealthAttackArrowShot")
            return
        end
    elseif 0 >= env(ActionDuration, ACTION_ARM_R2) then
        ExecEventAllBody("W_StealthAttackArrowShot")
        return
    end
    if ArrowLowerCommonFunction(Event_StealthAttackArrowLoop, lower_state, FALSE) == TRUE then
    end
end

function StealthAttackArrowShot_onUpdate()
    act(SetIsPreciseShootingPossible)
    SetStealthState(STEALTH_ATTACK_ARROWSHOT)
    if ArrowCommonFunction(blend_type, FALSE, TURN_TYPE_STANCE) == TRUE then
        return
    elseif env(GetStamina) > 0 then
        local request = GetAttackRequest(FALSE)
        local hand = HAND_RIGHT
        local IsContinue = FALSE
        if request == ATTACK_REQUEST_ARROW_FIRE_RIGHT or request == ATTACK_REQUEST_ARROW_FIRE_RIGHT2 then
            IsContinue = TRUE
        elseif request == ATTACK_REQUEST_ARROW_FIRE_LEFT or request == ATTACK_REQUEST_ARROW_FIRE_LEFT2 then
            IsContinue = TRUE
            hand = HAND_LEFT
        end
        if IsContinue == TRUE then
            if env(GetEquipWeaponCategory, hand) ~= WEAPON_CATEGORY_LARGE_ARROW then
                if env(IsOutOfAmmo, hand) == TRUE then
                    ExecEventAllBody("W_NoArrow")
                    return
                else
                    SetVariable("NoAmmo", 0)
                    ExecEventHalfBlend(Event_StealthAttackArrowStartContinue, ALLBODY)
                    return
                end
            elseif env(IsOutOfAmmo, hand) == TRUE then
                ExecEventAllBody("W_NoArrow")
                return
            else
                ExecEventHalfBlend(Event_StealthAttackArrowStartContinue, ALLBODY)
                return
            end
        end
    end
    if TRUE == env(IsMoveCancelPossible) then
        if 0 < GetVariable("MoveSpeedLevel") then
            MoveStart(ALLBODY, Event_Stealth_Move, FALSE)
            return
        end
        hkbFireEvent("W_Stealth_Idle")
    end
end

function StealthItemOneShot_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if StealthItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_StealthItemOneShot, lower_state, FALSE) == TRUE then
    end
end

function StealthItemOneShot_SelfTrans_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if StealthItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_StealthItemOneShot, lower_state, FALSE) == TRUE then
    end
end

function StealthItemDrinkStart_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if StealthItemCommonFunction(blend_type) == TRUE then
        return
    end
    local isEnd = env(IsAnimEnd, 1)
    if TRUE == env(GetEventEzStateFlag, 0) or isEnd == TRUE then
        local item_type = env(GetItemAnimType)
        if item_type ~= ITEM_NO_DRINK then
            ExecEventHalfBlendNoReset(Event_StealthItemDrinking, blend_type)
            return
        elseif item_type == ITEM_NO_DRINK and isEnd == TRUE then
            ExecEventHalfBlendNoReset(Event_StealthItemDrinkEmpty, blend_type)
            return
        end
    end
    if HalfBlendLowerCommonFunction(Event_StealthItemOneShot, lower_state, FALSE) == TRUE then
    end
end

function StealthItemDrinking_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if StealthItemCommonFunction(blend_type) == TRUE then
        return
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventHalfBlendNoReset(Event_StealthItemDrinkEnd, blend_type)
        return
    elseif HalfBlendLowerCommonFunction(Event_StealthItemOneShot, lower_state, FALSE) == TRUE then
    end
end

function StealthItemDrinkEnd_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if StealthItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_StealthItemOneShot, lower_state, FALSE) == TRUE then
    end
end

function StealthItemDrinkEmpty_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if StealthItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_StealthItemOneShot, lower_state, FALSE) == TRUE then
    end
end

function StealthItemDrinkNothing_Upper_onUpdate()
    local blend_type, lower_state = GetHalfBlendInfo()
    if lower_state == LOWER_IDLE then
        act(LockonSystemUnableToTurnAngle, 45, 45)
    elseif lower_state == LOWER_TURN then
        SetVariable("TurnType", TURN_TYPE_STANCE)
    end
    if StealthItemCommonFunction(blend_type) == TRUE then
        return
    elseif HalfBlendUpperCommonFunction(lower_state) == TRUE then
        return
    elseif HalfBlendLowerCommonFunction(Event_StealthItemOneShot, lower_state, FALSE) == TRUE then
    end
end

function Stealth_to_Stealth_Idle_onUpdate()
    act(SwitchMotion, TRUE)
    act(SetAllowedThrowAttackType, THROW_STATE_STEALTH)
    SetEnableAimMode()
    SetStealthState(STEALTH_TO_STEALTHIDLE)
    SpeedUpdate()
    StealthTransitionIndexUpdate()
    if GetVariable("MoveSpeedIndex") == 2 then
        act(LockonFixedAngleCancel)
    end
    if TRUE == env(IsMoveCancelPossible) and GetVariable("MoveSpeedLevel") > 0 then
        MoveStart(ALLBODY, Event_Stealth_Move, FALSE)
        return
    elseif TRUE == StealthActionCommonFunction(FALL_TYPE_DEFAULT, "W_AttackRightLightStealth", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLightStealth", "W_AttackBothHeavy1Start", QUICKTYPE_ROLLING) then
    end
end

function Stealth_to_Idle_onUpdate()
    act(SwitchMotion, TRUE)
    act(SetAllowedThrowAttackType, THROW_STATE_STEALTH)
    SetEnableAimMode()
    SetStealthState(STEALTH_TO_IDLE)
    SpeedUpdate()
    StealthTransitionIndexUpdate()
    if GetVariable("MoveSpeedIndex") == 2 then
        act(LockonFixedAngleCancel)
    end
    if TRUE == env(IsMoveCancelPossible) and GetVariable("MoveSpeedLevel") > 0 then
        MoveStart(ALLBODY, Event_Move, FALSE)
        return
    elseif TRUE == StealthActionCommonFunction(FALL_TYPE_DEFAULT, "W_AttackRightLightStealth", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLightStealth", "W_AttackBothHeavy1Start", QUICKTYPE_ROLLING) then
    end
end

function Stealth_Idle_onUpdate()
    act(Wait)
    act(SetAllowedThrowAttackType, THROW_STATE_STEALTH)
    SetEnableAimMode()
    SetStealthState(STEALTH_IDLE)
    if IdleCommonFunction() == TRUE then
        return
    elseif TRUE == ExecArtsStance(ALLBODY) then
        return
    elseif TRUE == ExecGuard(Event_GuardStart, ALLBODY) then
    end
end

function Stealth_Move_onActivate()
    act(SwitchMotion, TRUE)
end

function Stealth_Move_onUpdate()
    act(SwitchMotion, TRUE)
    local move_speed = GetVariable("MoveSpeedIndex")
    if move_speed == 2 then
        SetThrowAtkInvalid()
    end
    if g_TimeActEditor_08 >= 1 then
        act(Set4DirectionMovementThreshold, GetVariable("MagicRightWalkAngle_FrontLeft"), GetVariable("MagicRightWalkAngle_FrontRight"), GetVariable("MagicRightWalkAngle_BackLeft"), GetVariable("MagicRightWalkAngle_BackRight"))
    elseif 1 <= g_TimeActEditor_09 then
        act(Set4DirectionMovementThreshold, GetVariable("MagicLeftWalkAngle_FrontLeft"), GetVariable("MagicLeftWalkAngle_FrontRight"), GetVariable("MagicLeftWalkAngle_BackLeft"), GetVariable("MagicLeftWalkAngle_BackRight"))
    elseif hkbGetVariable("MoveType") < 0.5 then
        act(Set4DirectionMovementThreshold, 60, 45, 60, 60)
    elseif hkbGetVariable("StanceMoveType") == 0 then
        act(Set4DirectionMovementThreshold, 70, 40, 60, 20)
    else
        act(Set4DirectionMovementThreshold, 40, 70, 60, 20)
    end
    SpeedUpdate()

    if TRUE == env(IsCOMPlayer) then
        local npc_turn_speed = 240
        if move_speed == 2 then
            npc_turn_speed = 180
        else
            local dir = GetVariable("MoveDirection")
            if dir == 0 then
                npc_turn_speed = 90
            end
        end
        SetTurnSpeed(npc_turn_speed)
    end

    if hkbGetVariable("MoveDirection") == 3 or 2 == hkbGetVariable("MoveDirection") then
        act(SetMovementScaleMult, 0.9599999785423279)
    elseif 1 == hkbGetVariable("MoveDirection") then
        act(SetMovementScaleMult, 0.9599999785423279)
    elseif hkbGetVariable("MoveDirection") == 0 then
        act(SetMovementScaleMult, 0.9800000190734863)
    end
end

function Stealth_Move_Upper_onUpdate()
    act(SetAllowedThrowAttackType, THROW_STATE_STEALTH)
    SetWeightIndex()
    if MoveCommonFunction(UPPER) == TRUE then
    end
end

function StealthStopCommonFunction(is_dash_stop)
    act(Wait)
    act(SwitchMotion, TRUE)
    act(SetAllowedThrowAttackType, THROW_STATE_STEALTH)
    SetEnableAimMode()
    SetStealthState(STEALTH_STOP)
    if StopCommonFunction(is_dash_stop) == TRUE then
        return TRUE
    elseif TRUE == env(IsAnimEnd, 1) then
        ExecEventAllBody("W_Stealth_Idle")
        return TRUE
    else
        return FALSE
    end
end

function StealthDashStop_onUpdate()
    if StealthStopCommonFunction(TRUE) == TRUE then
    end
end

function StealthRunStopFront_onUpdate()
    if StealthStopCommonFunction(FALSE) == TRUE then
    end
end

function StealthRunStopBack_onUpdate()
    if StealthStopCommonFunction(FALSE) == TRUE then
    end
end

function StealthRunStopLeft_onUpdate()
    if StealthStopCommonFunction(FALSE) == TRUE then
    end
end

function StealthRunStopRight_onUpdate()
    if StealthStopCommonFunction(FALSE) == TRUE then
    end
end

function Stealth_Rolling_onUpdate()
    act(SetAllowedThrowAttackType, THROW_STATE_STEALTH)
    SetWeightIndex()
    SetStealthState(STEALTH_ROLLING)
    if env(IsAnimEnd, 1) == TRUE then
        hkbFireEvent("W_Stealth_Idle")
        return
    elseif env(IsMoveCancelPossible) == TRUE and TRUE == MoveStart(ALLBODY, Event_Stealth_Move, FALSE) then
        return
    elseif TRUE == EvasionCommonFunction(FALL_TYPE_DEFAULT, "W_AttackRightLightStep", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLightStep", "W_AttackBothHeavy1Start", QUICKTYPE_ROLLING) then
        return
    else
        SetRollingTurnCondition(FALSE)
    end
end

function Stealth_RollingSelftrans_onUpdate()
    act(SetAllowedThrowAttackType, THROW_STATE_STEALTH)
    SetWeightIndex()
    SetStealthState(STEALTH_ROLLING_SELFTRANS)
    if env(IsAnimEnd, 1) == TRUE and TRUE == MoveStart(ALLBODY, Event_Stealth_Move, FALSE) then
        return
    elseif env(IsMoveCancelPossible) == TRUE and GetVariable("MoveSpeedLevel") <= 0 then
        MoveStart(ALLBODY, Event_Stealth_Move, FALSE)
        return
    elseif TRUE == EvasionCommonFunction(FALL_TYPE_DEFAULT, "W_AttackRightLightStep", "W_AttackRightHeavy1Start", "W_AttackLeftLight1", "W_AttackLeftHeavy1", "W_AttackBothLightStep", "W_AttackBothHeavy1Start", QUICKTYPE_ROLLING) then
        return
    else
        SetRollingTurnCondition(TRUE)
    end
end

function AddBlendSpeak_onUpdate()
    if env(IsAnimEnd, 2) == TRUE then
        SetVariable("AddBlendSpeakIndex", math.random(0, 2))
        act(DebugLogOutput, "AddBlendSpeak_end")
        ExecEventAllBody("W_AddBlendSpeak")
    end
end

------------------------------------------
-- Core: Includes from common_define
------------------------------------------
-- ivi: Constants for distinction of regular numbers to what exactly these mean.
SWORD_ART_DIFF_CAT_DEFAULT = 0
SWORD_ART_DIFF_CAT_LARGE_WEAPON = 2
SWORD_ART_DIFF_CAT_POLEARM = 3
SWORD_ART_DIFF_CAT_LARGE_WEAPON_SMALL_SHIELD = 4
SWORD_ART_DIFF_CAT_POLEARM_SMALL_SHIELD = 5
SWORD_ART_DIFF_CAT_LARGE_WEAPON_LARGE_SHIELD = 8
SWORD_ART_DIFF_CAT_POLEARM_LARGE_SHIELD = 9

-- Stores possible override animations that exist for Sword Arts.
-- Key: Sword Art ID (TAE ID minus 600)
-- Possible values:
--
-- 0: Idle (Default or Large Rapier)
-- 2: Idle (Great Weapon)
-- 3: Idle (Polearm)
-- 4: Idle (Great Weapon) + Small Shield
-- 5: Idle (Polearm) + Small Shield
-- 8: Idle (Great Weapon) + Large Shield
-- 9: Idle (Polearm) + Large Shield
-- 20-59: Weapon Category
SwordArtsCategory = {
    [0] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [1] = {SWORD_ART_DIFF_CAT_DEFAULT, SWORD_ART_DIFF_CAT_LARGE_WEAPON, SWORD_ART_DIFF_CAT_POLEARM, WEAPON_CATEGORY_FIST},
    [2] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [3] = {SWORD_ART_DIFF_CAT_DEFAULT, SWORD_ART_DIFF_CAT_LARGE_WEAPON, SWORD_ART_DIFF_CAT_POLEARM, WEAPON_CATEGORY_TWINBLADE},
    [4] = {SWORD_ART_DIFF_CAT_DEFAULT, SWORD_ART_DIFF_CAT_LARGE_WEAPON, SWORD_ART_DIFF_CAT_POLEARM},
    [5] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [6] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [7] = {SWORD_ART_DIFF_CAT_DEFAULT, SWORD_ART_DIFF_CAT_LARGE_WEAPON, SWORD_ART_DIFF_CAT_POLEARM},
    [8] = {SWORD_ART_DIFF_CAT_DEFAULT, SWORD_ART_DIFF_CAT_LARGE_WEAPON, SWORD_ART_DIFF_CAT_POLEARM},
    [9] = {SWORD_ART_DIFF_CAT_DEFAULT, SWORD_ART_DIFF_CAT_LARGE_WEAPON, SWORD_ART_DIFF_CAT_POLEARM},
    [10] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [11] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [12] = {SWORD_ART_DIFF_CAT_DEFAULT, SWORD_ART_DIFF_CAT_LARGE_WEAPON, SWORD_ART_DIFF_CAT_POLEARM},
    [13] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [14] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [15] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [16] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [17] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [18] = {SWORD_ART_DIFF_CAT_DEFAULT, SWORD_ART_DIFF_CAT_POLEARM},
    [19] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [20] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [21] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [22] = {SWORD_ART_DIFF_CAT_DEFAULT, SWORD_ART_DIFF_CAT_POLEARM, WEAPON_CATEGORY_TWINBLADE},
    [23] = {SWORD_ART_DIFF_CAT_DEFAULT, SWORD_ART_DIFF_CAT_POLEARM, WEAPON_CATEGORY_TWINBLADE},
    [24] = {SWORD_ART_DIFF_CAT_DEFAULT, SWORD_ART_DIFF_CAT_LARGE_WEAPON, SWORD_ART_DIFF_CAT_POLEARM, WEAPON_CATEGORY_TWINBLADE},
    [25] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [50] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [51] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [52] = {SWORD_ART_DIFF_CAT_DEFAULT, WEAPON_CATEGORY_TWINBLADE},
    [53] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [54] = {SWORD_ART_DIFF_CAT_DEFAULT, SWORD_ART_DIFF_CAT_LARGE_WEAPON, WEAPON_CATEGORY_TWINBLADE},
    [55] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [56] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [57] = {SWORD_ART_DIFF_CAT_DEFAULT, SWORD_ART_DIFF_CAT_LARGE_WEAPON},
    [58] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [59] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [61] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [62] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [63] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [64] = {SWORD_ART_DIFF_CAT_DEFAULT, WEAPON_CATEGORY_FIST},
    [65] = {SWORD_ART_DIFF_CAT_DEFAULT, SWORD_ART_DIFF_CAT_POLEARM},
    [66] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [67] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [68] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [69] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [70] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [71] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [72] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [73] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [74] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [75] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [76] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [90] = {SWORD_ART_DIFF_CAT_DEFAULT, WEAPON_CATEGORY_LARGE_SHIELD, WEAPON_CATEGORY_SMALL_SHIELD},
    [91] = {SWORD_ART_DIFF_CAT_DEFAULT, SWORD_ART_DIFF_CAT_LARGE_WEAPON, SWORD_ART_DIFF_CAT_POLEARM, SWORD_ART_DIFF_CAT_LARGE_WEAPON_SMALL_SHIELD, SWORD_ART_DIFF_CAT_POLEARM_SMALL_SHIELD, SWORD_ART_DIFF_CAT_LARGE_WEAPON_LARGE_SHIELD, SWORD_ART_DIFF_CAT_POLEARM_LARGE_SHIELD, WEAPON_CATEGORY_LARGE_SHIELD, WEAPON_CATEGORY_SMALL_SHIELD},
    [92] = {SWORD_ART_DIFF_CAT_DEFAULT, WEAPON_CATEGORY_SHORT_SWORD, WEAPON_CATEGORY_CURVEDSWORD, WEAPON_CATEGORY_SMALL_SHIELD},
    [93] = {SWORD_ART_DIFF_CAT_DEFAULT, SWORD_ART_DIFF_CAT_LARGE_WEAPON, SWORD_ART_DIFF_CAT_POLEARM},
    [94] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [95] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [96] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [97] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [98] = {SWORD_ART_DIFF_CAT_DEFAULT, WEAPON_CATEGORY_LARGE_SHIELD, WEAPON_CATEGORY_SMALL_SHIELD},
    [99] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [100] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [101] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [102] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [103] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [105] = {SWORD_ART_DIFF_CAT_DEFAULT, WEAPON_CATEGORY_LARGE_ARROW},
    [106] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [108] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [110] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [107] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [109] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [111] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [112] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [113] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [114] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [115] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [116] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [117] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [118] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [130] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [131] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [132] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [133] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [134] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [135] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [136] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [137] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [140] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [141] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [142] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [143] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [144] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [150] = {SWORD_ART_DIFF_CAT_DEFAULT, SWORD_ART_DIFF_CAT_LARGE_WEAPON, WEAPON_CATEGORY_FIST},
    [151] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [152] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [155] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [156] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [157] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [160] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [165] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [166] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [167] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [168] = {SWORD_ART_DIFF_CAT_DEFAULT},
    [196] = {SWORD_ART_DIFF_CAT_DEFAULT, SWORD_ART_DIFF_CAT_LARGE_WEAPON, SWORD_ART_DIFF_CAT_POLEARM}
}

-- Determines which override of a Sword Art animation to play, based on the size or type of the weapon.
-- The return of this function is processed to a different ID by the cases that use it.
--
-- artID: Weapon Arts ID (TAE id minus 600)
--      swordArtsTypeNew in SwordArtsParam
-- idleCat: Stay Anim Category (Idle animation index for weapon)
--      wepmotionOneHandId and wepmotionBothHandId in EquipParamWeapon
-- wepCat: Weapon Animation Category (TAE ID for weapon type)
--      wepmotionCategory in EquipParamWeapon
--
-- Possible returns:
--
-- 0: Idle (Default or Large Rapier)
-- 2: Idle (Great Weapon)
-- 3: Idle (Polearm)
-- 4: Idle (Great Weapon) + Small Shield
-- 5: Idle (Polearm) + Small Shield
-- 8: Idle (Great Weapon) + Large Shield
-- 9: Idle (Polearm) + Large Shield
-- 20-59: Weapon Category
function GetSwordArtsDiffCategory(artID, idleCat, wepCat)
    -- If TAE ID above 770 (except 796), no overrides, only a single default animation.
    if artID >= 170 and artID ~= 196 then
        return SWORD_ART_DIFF_CAT_DEFAULT

    -- For TAE ID 769 (Radahn's Rain), return 45 (Greatbow)
    elseif artID == 169 then
        return WEAPON_CATEGORY_LARGE_ARROW
    end

    -- Allows some weapon categories to query for whether the Sword Art permits a cousin category.
    -- Only used to allow Claws to use Fist Sword Arts.
    local wep_cat1
    if wepCat == WEAPON_CATEGORY_CLAW then
        wep_cat1 = WEAPON_CATEGORY_FIST
    end

    -- Idle animation TAEs. Two-hand is ignored.
    local idle_cat0 = idleCat
    if idle_cat0 >= 10 then
        idle_cat0 = idle_cat0 - 10
    end

    -- Override for heavy thrusting swords (usually 3)
    if wepCat == WEAPON_CATEGORY_LARGE_RAPIER then
        idle_cat0 = SWORD_ART_DIFF_CAT_DEFAULT
    end

    -- ivi: CASE 0: Not in table
    if SwordArtsCategory[artID] == nil then
        return SWORD_ART_DIFF_CAT_DEFAULT
    end

    -- CASE 1: Shields
    if c_SwordArtsHand == HAND_LEFT and c_Style ~= HAND_LEFT_BOTH then
        local shield_cat = -1
        if idle_cat0 == 2 and wepCat == WEAPON_CATEGORY_SMALL_SHIELD then
            shield_cat = SWORD_ART_DIFF_CAT_LARGE_WEAPON_SMALL_SHIELD
        elseif idle_cat0 == 3 and wepCat == WEAPON_CATEGORY_SMALL_SHIELD then
            shield_cat = SWORD_ART_DIFF_CAT_POLEARM_SMALL_SHIELD
        elseif idle_cat0 == 2 and wepCat == WEAPON_CATEGORY_LARGE_SHIELD then
            shield_cat = SWORD_ART_DIFF_CAT_LARGE_WEAPON_LARGE_SHIELD
        elseif idle_cat0 == 3 and wepCat == WEAPON_CATEGORY_LARGE_SHIELD then
            shield_cat = SWORD_ART_DIFF_CAT_POLEARM_LARGE_SHIELD
        end
        if shield_cat ~= -1 then
            -- Only check if shields
            for i = 1, #SwordArtsCategory[artID], 1 do
                if SwordArtsCategory[artID][i] == shield_cat then
                    act(9000, "GetSwordArtsDiffCategory shield_cat:" .. shield_cat)
                    return shield_cat
                end
            end
        end
    end

    -- CASE 2: Weapon Categories
    for j = 1, #SwordArtsCategory[artID], 1 do
        if SwordArtsCategory[artID][j] == wepCat then
            act(9000, "GetSwordArtsDiffCategory wepCat0:" .. wepCat)
            return wepCat
        end
    end

    -- ivi: Additional check to avoid unnecessary second loop
    if wep_cat1 ~= nil then
        -- CASE 3: Auxiliary weapon category (Some weapon categories count the same as others)
        for j = 1, #SwordArtsCategory[artID], 1 do
            if SwordArtsCategory[artID][j] == wep_cat1 then
                act(9000, "GetSwordArtsDiffCategory wepCat1:" .. wep_cat1)
                return wep_cat1
            end
        end
    end

    -- Shield Arts (90 is Shield Bash, 99 is Thops Barrier)
    if artID >= 90 and artID <= 99 and (c_SwordArtsHand ~= HAND_LEFT or c_Style == HAND_LEFT_BOTH) then
        return SWORD_ART_DIFF_CAT_DEFAULT
    end

    -- CASE 4: Idle categories
    for j = 1, #SwordArtsCategory[artID], 1 do
        if SwordArtsCategory[artID][j] == idle_cat0 then
            act(9000, "GetSwordArtsDiffCategory idle_cat0:" .. idle_cat0)
            return idle_cat0
        end
    end

    return SWORD_ART_DIFF_CAT_DEFAULT
end

-- Table storing information about weapon arts.
-- Concerns playing a "weapon retrieval" animation after
-- the sword art was executed.
--
-- Table key: Sword Art ID (TAE ID minus 600)
-- Value 1: Right hand, weapon art cast from right hand
-- Value 2: Right hand, weapon art cast from left hand
-- Value 3: Left hand
--
-- TRUE: Weapon was sheathed during animation, play retrieval animation.
-- FALSE: Weapon was used to perform the sword art, no retrieval animation.
SwordArtPutOppositeWeapon = {
    [0] = {TRUE, FALSE, TRUE},
    [1] = {TRUE, FALSE, TRUE},
    [2] = {TRUE, FALSE, TRUE},
    [3] = {TRUE, FALSE, TRUE},
    -- 4 (Not present)
    [5] = {TRUE, FALSE, TRUE},
    [6] = {TRUE, FALSE, TRUE},
    [7] = {TRUE, FALSE, TRUE},
    [8] = {FALSE, FALSE, TRUE},
    [9] = {FALSE, FALSE, TRUE},
    [10] = {TRUE, FALSE, TRUE},
    [11] = {TRUE, FALSE, TRUE},
    [12] = {TRUE, FALSE, TRUE},
    [13] = {TRUE, FALSE, TRUE},
    [14] = {TRUE, FALSE, TRUE},
    [15] = {TRUE, FALSE, TRUE},
    [16] = {TRUE, FALSE, TRUE},
    [17] = {FALSE, FALSE, FALSE},
    [18] = {TRUE, FALSE, TRUE},
    [19] = {TRUE, FALSE, TRUE},
    [20] = {TRUE, FALSE, TRUE},
    -- 21 (Present)
    [22] = {TRUE, FALSE, TRUE},
    [23] = {TRUE, FALSE, TRUE},
    [24] = {FALSE, FALSE, TRUE},
    [25] = {TRUE, FALSE, TRUE},
    -- 26-49 (Not present)
    [50] = {FALSE, FALSE, TRUE},
    [51] = {TRUE, FALSE, TRUE},
    [52] = {TRUE, FALSE, TRUE},
    [53] = {FALSE, FALSE, TRUE},
    [54] = {TRUE, FALSE, TRUE},
    [55] = {TRUE, FALSE, FALSE},
    [56] = {TRUE, FALSE, TRUE},
    [57] = {TRUE, FALSE, TRUE},
    [58] = {TRUE, FALSE, TRUE},
    [59] = {TRUE, FALSE, TRUE},
    [61] = {TRUE, FALSE, TRUE},
    [62] = {TRUE, FALSE, FALSE},
    [63] = {TRUE, FALSE, TRUE},
    [64] = {FALSE, FALSE, TRUE},
    [65] = {TRUE, FALSE, TRUE},
    [66] = {TRUE, FALSE, TRUE},
    [67] = {TRUE, FALSE, TRUE},
    [68] = {TRUE, FALSE, TRUE},
    [69] = {TRUE, FALSE, TRUE},
    [70] = {TRUE, FALSE, TRUE},
    [71] = {TRUE, FALSE, TRUE},
    [72] = {TRUE, FALSE, TRUE},
    [73] = {TRUE, FALSE, TRUE},
    [74] = {FALSE, FALSE, TRUE},
    [75] = {TRUE, FALSE, TRUE},
    [76] = {TRUE, FALSE, TRUE},
    -- 77-89 (Not present)
    [90] = {TRUE, FALSE, TRUE},
    [91] = {FALSE, FALSE, FALSE},
    [92] = {FALSE, FALSE, TRUE},
    [93] = {FALSE, FALSE, TRUE},
    [94] = {FALSE, FALSE, TRUE},
    [95] = {FALSE, FALSE, TRUE},
    [96] = {FALSE, FALSE, TRUE},
    [97] = {FALSE, FALSE, TRUE},
    [98] = {TRUE, TRUE, TRUE},
    [99] = {FALSE, FALSE, FALSE},
    [100] = {FALSE, FALSE, FALSE},
    [101] = {FALSE, FALSE, FALSE},
    [102] = {FALSE, FALSE, FALSE},
    [103] = {FALSE, FALSE, FALSE},
    -- 104 (Not present)
    [105] = {FALSE, FALSE, FALSE},
    [106] = {FALSE, FALSE, FALSE},
    -- 107 (Present)
    [108] = {FALSE, FALSE, FALSE},
    -- 109 (Not present)
    [110] = {FALSE, FALSE, TRUE},
    [111] = {FALSE, FALSE, TRUE},
    [112] = {FALSE, FALSE, TRUE},
    [113] = {FALSE, FALSE, TRUE},
    [114] = {TRUE, FALSE, TRUE},
    [115] = {FALSE, FALSE, TRUE},
    [116] = {FALSE, FALSE, TRUE},
    [117] = {TRUE, FALSE, TRUE},
    [118] = {TRUE, FALSE, TRUE},
    -- 119-129 (Not present)
    [130] = {FALSE, FALSE, TRUE},
    [131] = {FALSE, FALSE, TRUE},
    [132] = {TRUE, FALSE, TRUE},
    [133] = {FALSE, FALSE, TRUE},
    [134] = {TRUE, FALSE, TRUE},
    [135] = {TRUE, FALSE, TRUE},
    [136] = {TRUE, FALSE, TRUE},
    [137] = {FALSE, FALSE, TRUE},
    [140] = {FALSE, FALSE, TRUE},
    [141] = {FALSE, FALSE, TRUE},
    [142] = {FALSE, FALSE, TRUE},
    [143] = {FALSE, FALSE, TRUE},
    [144] = {TRUE, FALSE, TRUE},
    [150] = {TRUE, FALSE, TRUE},
    [151] = {FALSE, FALSE, TRUE},
    [152] = {TRUE, TRUE, TRUE},
    [155] = {FALSE, FALSE, TRUE},
    [156] = {FALSE, FALSE, TRUE},
    [157] = {FALSE, FALSE, TRUE},
    [160] = {FALSE, FALSE, TRUE},
    [165] = {TRUE, FALSE, TRUE},
    [166] = {TRUE, FALSE, TRUE},
    [167] = {TRUE, FALSE, TRUE},
    [168] = {TRUE, FALSE, TRUE},
    [169] = {FALSE, FALSE, FALSE},
    [170] = {TRUE, FALSE, TRUE},
    [171] = {FALSE, FALSE, TRUE},
    [172] = {TRUE, FALSE, FALSE},
    [173] = {TRUE, FALSE, TRUE},
    [174] = {FALSE, FALSE, TRUE},
    [175] = {TRUE, FALSE, TRUE},
    [176] = {TRUE, FALSE, TRUE},
    [177] = {TRUE, FALSE, TRUE},
    [178] = {TRUE, FALSE, TRUE},
    [179] = {TRUE, FALSE, TRUE},
    -- 180
    -- 181
    [182] = {FALSE, FALSE, TRUE},
    [183] = {TRUE, FALSE, TRUE},
    [184] = {TRUE, FALSE, TRUE},
    [185] = {TRUE, FALSE, TRUE},
    [186] = {TRUE, FALSE, TRUE},
    [187] = {FALSE, FALSE, TRUE},
    [188] = {TRUE, FALSE, TRUE},
    [189] = {TRUE, FALSE, TRUE},
    [190] = {FALSE, FALSE, FALSE},
    [191] = {TRUE, FALSE, FALSE},
    [192] = {TRUE, FALSE, TRUE},
    [193] = {FALSE, FALSE, TRUE},
    [194] = {FALSE, FALSE, TRUE},
    [195] = {FALSE, TRUE, FALSE},
    [196] = {FALSE, FALSE, FALSE},
    [197] = {FALSE, FALSE, FALSE},
    [198] = {FALSE, FALSE, TRUE},
    [199] = {TRUE, FALSE, TRUE},
    [200] = {TRUE, FALSE, TRUE},
    [201] = {TRUE, TRUE, FALSE},
    [202] = {TRUE, TRUE, FALSE},
    [203] = {TRUE, FALSE, TRUE},
    [204] = {TRUE, FALSE, TRUE},
    [205] = {TRUE, FALSE, TRUE},
    [206] = {FALSE, FALSE, TRUE},
    [207] = {TRUE, FALSE, TRUE},
    [208] = {TRUE, FALSE, TRUE},
    [209] = {TRUE, FALSE, TRUE},
    [210] = {FALSE, FALSE, TRUE},
    [211] = {FALSE, FALSE, FALSE},
    [212] = {FALSE, FALSE, TRUE},
    [213] = {TRUE, FALSE, TRUE},
    [214] = {TRUE, FALSE, TRUE},
    [215] = {TRUE, FALSE, TRUE},
    [216] = {FALSE, FALSE, TRUE},
    [217] = {FALSE, FALSE, TRUE},
    [218] = {TRUE, FALSE, TRUE},
    [219] = {TRUE, FALSE, FALSE},
    [220] = {FALSE, FALSE, TRUE},
    [221] = {FALSE, FALSE, TRUE},
    [222] = {TRUE, FALSE, TRUE},
    [223] = {TRUE, FALSE, TRUE},
    [224] = {TRUE, FALSE, TRUE},
    [225] = {TRUE, FALSE, TRUE},
    [226] = {TRUE, FALSE, TRUE},
    [227] = {TRUE, FALSE, TRUE},
    [228] = {TRUE, FALSE, TRUE},
    [229] = {TRUE, FALSE, TRUE},
    [230] = {FALSE, FALSE, TRUE},
    [231] = {TRUE, FALSE, TRUE},
    [232] = {TRUE, FALSE, FALSE},
    [233] = {TRUE, FALSE, TRUE},
    [234] = {TRUE, FALSE, TRUE},
    [235] = {TRUE, FALSE, TRUE},
    [236] = {TRUE, FALSE, TRUE},
    [237] = {TRUE, FALSE, TRUE},
    [238] = {TRUE, FALSE, TRUE},
    [239] = {TRUE, FALSE, TRUE},
    [240] = {TRUE, FALSE, TRUE},
    [241] = {TRUE, FALSE, TRUE},
    [242] = {TRUE, FALSE, TRUE},
    [243] = {TRUE, FALSE, TRUE},
    [244] = {TRUE, FALSE, TRUE},
    [245] = {FALSE, FALSE, TRUE},
    [246] = {TRUE, FALSE, TRUE},
    [247] = {FALSE, FALSE, FALSE},
    [248] = {TRUE, FALSE, FALSE},
    [249] = {TRUE, FALSE, FALSE},
    [250] = {TRUE, FALSE, TRUE},
    [251] = {TRUE, FALSE, TRUE},
    [252] = {TRUE, FALSE, FALSE},
    [253] = {TRUE, FALSE, TRUE},
    [254] = {TRUE, FALSE, TRUE}
}

-- Decides whether to perform a "retrieve weapon" animation after finishing a Weapon Art.
-- See the above table for reference.
function GetSwordArtsPutOppositeWeapon()
    -- ivi: In Fromsoft's original code, this was nil by default. FALSE is more forgiving for custom weapon arts.
    local result = FALSE

    -- ivi: Add sanity check for absent entries (custom Sword Arts).
    if SwordArtPutOppositeWeapon[c_SwordArtsID] ~= nil then
        if c_Style == HAND_RIGHT then
            if HAND_RIGHT == c_SwordArtsHand then
                result = SwordArtPutOppositeWeapon[c_SwordArtsID][1] -- Right hand, weapon art cast from right hand
            else
                result = SwordArtPutOppositeWeapon[c_SwordArtsID][2] -- Right hand, weapon art cast from left hand
            end
        else
            result = SwordArtPutOppositeWeapon[c_SwordArtsID][3] -- Left hand
        end
    end

    return result
end

------------------------------------------
-- Core: Helper Functions
------------------------------------------
function Contains(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return TRUE
        end
    end

    return FALSE
end

------------------------
-- Core: Global Variables
------------------------
HandChangeTest_ToR1 = FALSE
HandChangeTest_ToR2 = FALSE
HandChangeTest_ToL1 = FALSE
HandChangeTest_ToL2 = FALSE
HandChangeTest_L = FALSE
HandChangeTest_R = FALSE
HandChangeTest_Time = 233

JUMP_STATE_1 = 0
JUMP_STATE_2 = 0
JUMP_STATE_3 = 0
RIDE_TURN_STATE = 0
PROTO5 = 0
DAMAGE_ELEMENT_DEFAULT = 0
DAMAGE_ELEMENT_MAGIC = 10
DAMAGE_ELEMENT_FIRE = 11
DAMAGE_ELEMENT_LIGHTNING = 12
DAMAGE_ELEMENT_DARK = 13
DAMAGE_ELEMENT_POISON = 20
DAMAGE_ELEMENT_BLIGHT = 21
DAMAGE_ELEMENT_BLOOD = 22
DAMAGE_ELEMENT_FROSTBITE = 23
DAMAGE_ELEMENT_SLEEP = 24
DAMAGE_ELEMENT_MAD = 25
DAMAGE_ELEMENT_CURSE = 26
DAMAGE_ELEMENT_NONE = 254
DAMAGE_ELEMENT_MATERIAL_1 = 255
DAMAGE_PHYSICAL_SLASH = 0
DAMAGE_PHYSICAL_BLUNT = 1
DAMAGE_PHYSICAL_THRUST = 2
DAMAGE_PHYSICAL_NORMAL = 3

IS_ATTACKED_JUMPMAGIC = FALSE

g_IsMimicry = 0
g_EnableMimicry = 0
g_ComboReset = FALSE
lastUsedMagicAnim = -1

Event_MoveQuick = { "W_MoveQuick", MOVE_DEF0 }

-- Added
ACTION_ARM_JUMP = ACTION_ARM_CHANGE_STYLE

------------------------
-- Conditions
-- env( <condition>, <args> )
-- *<args> are optional
------------------------
IsGeneralAnimEnd = 0
IsAttackAnimEnd = 1
AnimIDOffset = 9
AdditiveBlendAnim = 10
AdditiveBlendAnimOfSlot = 11

IsAtkRequest = 100 -- args: <attack request index>
IsAtkReleaseRequest = 101
IsChainAtkRequest = 102
GetAtkDuration = 103
GetWeaponSwitchRequest = 104
GetCommandIDFromEvent = 105
GetAIActionType = 106
GetAIChainActionType = 107
GetChainEvadeRequest = 108
GetWeaponChangeRequest = 109
GetAnimIDFromMoveParam = 110
IsThereAnyAtkRequest = 111
IsThereAnyChainAtkRequest = 112
IsItemUseMenuOpening = 113
IsMagicUseMenuOpening = 114
IsItemUseMenuOpened = 115
IsMagicUseMenuOpened = 116
GetBlendAnimIDFromMoveParam = 117
GetAIChainStepType = 118
GetTransitionToSpecialStayAnimID = 119
GetAIAtkCancelType = 120
GetWeaponCancelType = 121 -- args: <hand index>
IsWeaponCancelPossible = 122
GetAIDefenseCancelType = 123
GetAIVersusBackstabCancelType = 124

IsFalling = 200
IsLanding = 201
GetReceivedDamageType = 202
IsActiveActionValid = 203
GetActionEventNumber = 204
IsNormalDmgPassThroughDuringThrow = 205
IsThrowing = 206
GetWeaponSwitchState = 207
IsEquipmentSwitchPossible = 209
IsAnimCancelPossibleInAtkRelease = 210
IsEmergencyStopAnimPlaying = 211
GetLockRangeState = 212
GetLockAngleState = 213
IsAnimCancelPossibleInDamageHit = 214
IsChangeToScrapeAtk = 215
IsChangeToDeflectAtk = 216
IsChangeToAfterParrySuccess = 217
IsChangeFromNormalToBigAtk = 218
GetMovementType = 219
IsLargeAtkComboPossible = 220
IsMapActionPossible = 221
GetReceivedDamageDirection = 222
GetMapActionID = 223
GetFallHeight = 224
GetEquipWeaponCategory = 225 -- args: <hand index>
IsHoldingBow = 226
GetMagicAnimType = 227
WasNotLargeAtk = 228
IsBackAtkPossible = 229
IsAfterParryAtkPossible = 230
GetItemAnimType = 231
IsMagicUseable = 232 -- args: <hand index>, <unknown index>
IsItemUseable = 233
IsPrecisionShoot = 234
IsFireDamaged = 235
GetDamageLevel = 236
GetGuardLevelAction = 237
IsNewLeftHandAtkFromStay = 238
IsParryFromIdle = 239
IsGuardFromIdle = 240
IsNewLeftHandAtkFromAtkCancel = 241
IsParryFromAtkCancel = 242
IsGuardFromAtkCancel = 243
IsTiedUp = 244
IsOutOfAmmo = 245 -- args: <slot index> # 1 is left slot, 0 is right slot
IsUseCatLanding = 246
GetHoverMoveState = 247
IsTruelyLanding = 248
IsRightHandMagic = 249
IsChangeToSpecialStayAnim = 250
GetSpecialStayAnimID = 251
AcquireSpecialDamageAnimationID = 252
IsRunTurnAnimPlaying = 253
IsGenerateAction = 254
GetSpecialStayCancelAnimID = 255
HasReceivedAnyDamage = 256
GetMoveAnimParamID = 257
GetGuardLevel = 258
IsRequestTurnAnimStart = 259
IsTurningWithAnim = 260
IsFlying = 261
IsAbilityInsufficient = 262 -- args: <hand index>
GetEquipWeightRatioForFalling = 263
GetFlightMotionState = 264
GetIsWeakPoint = 265
GetMoveAnimBlendRatio = 266
GetLadderActionState = 267
IsInDisguise = 268
IsCoopWait = 269
IsCoop = 270
IsSpecialTransitionPossible = 271
GetLandingAnimBlendRatio = 272
GetThrowAnimID = 273
DidOpponentDieFromThrow = 274
HasThrowEnded = 275
IsThrowSelfDeath = 276
IsThrowSuccess = 277
GetGuardMotionCategory = 278 -- args: <hand index>
IsBeingThrown = 279
IsSelfThrow = 280
IsThrowDeathState = 281
GetNewLockState = 282
IsOnLadder = 283
GetPhysicalAttribute = 284
GetSpecialAttribute = 285
GetSpecialStayDeathAnimID = 286
HasReceivedAnyDamage_AnimEnd = 287
EggGrowth_IsHeadScratch = 288
EggGrowth_IsBecomeEggHead = 289
IsStop = 290
IsSomeoneOnLadder = 291 -- args: <check distance>, <unknown index>
IsSomeoneUnderLadder = 292 -- args: <check distance>, <unknown index>
GetLadderHandState = 293
DoesLadderHaveCharacters = 294 -- args: <check distance>, <unknown index>, <unknown index>
IsLadderRightHandStayState = 295
IsDescendingToFloor = 296
IsInputDirectionMatch = 297
IsSpecialTransition2Possible = 298
IsVersusDivineDamage = 299

IsGeneralAnimCancelPossible = 300
GetEventEzStateFlag = 301 -- args: <EzState command id>
IsLadderEventEnd = 302
IsReachBottomOfLadder = 303
IsReachTopOfLadder = 304
GetStateChangeType = 305 -- args: <state change id>
IsOnLastRungOfLadder = 306
GetWeaponDurability = 311
IsWeaponBroken = 312
IsAnimEndBySkillCancel = 313
EggGrowth_IsBecomeEgghead_SecondStage = 314
IsHamariFallDeath = 315 -- args: <unknown index>
IsClient = 316
IsSlope = 317
IsSwitchState = 318
IsPressUpKey = 319
IsSpecialTurning = 320
GetIntValueForTest = 321
IsObjActInterpolatedMotion = 322
GetObjActTargetDirection = 323
GetObjActRemainingInterpolateTime = 324
IsGap = 325
GetWeaponID = 326 -- args: <hand index>
IsMovingLaterally = 327
IsNet = 328
HasBrokenSA = 329
IsEmergencyQuickTurnActivated = 330
IsDoubleChantPossible = 331
IsAnimOver = 332
ObtainedDT = 333
GetBehaviorID = 334 -- args: <hand index>
IsTwoHandPossible = 335 -- args: <hand index>
IsPartDamageAdditiveBlendInvalid = 336
IsThrowPosRealign = 337
GetBoltLoadingState = 338 -- args: <slot index>
IsAnimEnd = 339 -- args: <unknown index>
IsTwinSwords = 340 -- args: <hand index>
GetTurnAngleForDelayedTurn = 341
GetThrowDefenseCount = 342
IsEmergencyEvasionPossible = 343 -- args: <unknown index>
HasEnoughArtsPoints = 344 -- args: <button index>, <hand index>
GetEquipWeaponSpecialCategoryNumber = 345 -- args: <hand index>
CheckForEventAnimPlaybackRequest = 346
IsFemale = 347
GetDelayTurnAngleDifference = 348
IsDamageMotionOff = 349
HasReachedStatsNeededForWeapon = 350 -- args: <hand index>
UpperArmControlOuterAngle = 351
UpperArmControlTopAndBottomAngle = 352
CompleteLadderSlideDown = 353
GetLadderRungCount = 354
GetNumberOfRungsBelowOnLadder = 355
GetBowAndArrowSlot = 356
GetWeaponStorageSpotType = 357 -- args: <hand index>
GetStayAnimCategory = 358
GetWeaponSwitchStatus = 359
IsEquipmentMenuOpen = 360
GetRemainingArrowCount = 361
Unknown362 = 362 -- args: <unknown>
GetEventID = 364
Unknown365 = 365
GetSpiritspringJumpHeight = 366
Unknown368 = 368

Unknown400 = 400
Unknown404 = 404
Unknown405 = 405
GetRollAngle = 406
GetJumpAngle = 407
GetSwordArtsRollAngle = 408
GetDamageSpecialAttribute = 409 -- args: <index>

IsOnMount = 500
IsSummoningRide = 504
IsMovingOnMount = 505
IsIdleOnMount = 506
GetMountReceivedDamageDirection = 522 -- args: <unknown>
GetMountDamageLevel = 530
GetMountRecievedDamageAngle = 533
GetMountRecievedDamageType = 534
HasMountReceivedAnyDamage = 535
IsMountFalling = 537
GetMountFallHeight = 538
IsMountInFallLoop = 539
IsMountTrulyLanding = 540
GetMountSpecialAttribute = 543
IsMountDead = 545
GetMountIsWeakPoint = 546
Unknown548 = 548
GetMountSpEffectID = 549
Unknown552 = 552
Unknown555 = 555

Unknown700 = 700
Unknown701 = 701

GetHP = 1000
GetStamina = 1001
IsGhost = 1002
GetRandomInt = 1003
GetRandomFloat = 1004
IsUnableToDie = 1005
IsResurrectionPossible = 1006
IsCOMPlayer = 1007
GetAITargetAwareState = 1008
IsAIChangeToAwareState = 1009
GetAITargetAwareStatePreviousFrame = 1010

GetTestDamageAnimID = 1100
IsInvincibleDebugMode = 1101
WasGameLaunchedInPGTestMode = 1102
IsTiltingStick = 1103
GetGestureRequestNumber = 1104
IsStayState = 1105
ActionRequest = 1106 -- args: <action arm index>
ActionCancelRequest = 1107 -- args: <action arm index>
ActionDuration = 1108 -- args: <action arm index>
HasActionRequest = 1109
MovementRequest = 1110
MovementRequestDuration = 1111
HasThrowRequest = 1112
IsGuardCancelPossible = 1113
DoesAnimExist = 1114 -- args: <anim id>, *<anim id>
GetAIMovementType = 1115
GetSpEffectID = 1116
IsConversationEnd = 1117
IsLocked = 1118
GetAtkDirection = 1119
GetPartGroup = 1120
GetKnockbackDistance = 1121

IsMoveCancelPossible = 2000
GetSpecialMovementType = 2002
GetGeneralTAEFlag = 2003 -- args: <flag>
IsSwingHitTarget = 2004
GetCeremonyState = 2005
GetSuccessiveGuardCount = 2006
GetMinLuck = 2007
GetAccumulatedLuck = 2008
GetMaxLuck = 2009
GetMaxStamina = 2010
GetGeneralMSBParameter = 2011
IsHitWall = 2012
GetSafetyDirection = 2013
IsInCeremony = 2014
IsDoingCorpseCarryKeyframe = 2015
GetFP = 2016
IsCeremonyComplete = 2017
IsCeremonyInterrupt = 2018

------------------------
-- Commands
-- act( <command>, <args> )
-- *<args> are optional
------------------------
ChangeGeneralAnim = 0
ChangeUpperBodyAnim = 1
ChangeStayAnim = 2
ChangeGeneralAnimCategorized = 3 -- args: <anim category>, <anim id>, <layer index>, <blend>, <isLoop>
ChangeUpperBodyAnimCategorized = 4
ChangeGeneralAnimAdditiveCategorized = 5
ChangeUpperBodyAnimAdditiveCategorized = 6
ChangeGeneralAnimCategorizedMatchPlaybackTime = 7
ChangeUpperBodyAnimCategorizedMatchPlaybackTime = 8
SetAnimIDOffset = 9
SetAdditiveBlendAnimation = 10
SetAdditiveBlendAnimationSlotted = 11
ChangeBlendAnimationCategorized = 12
ChangeUpperAndLowerBodySyncedAnimCategorized = 13

SetActiveActionState = 100
SwitchMotion = 101 -- args: <bool>
SetAllowedThrowAttackType = 102 -- args: <index> # ENUM: THROW_STATE
SetAllowedThrowDefenseType = 103 -- args: <index> # ENUM: THROW_STATE
SwitchEquippedWeapon = 104
SetReadyForAtkFinish = 105
SetEquipmentChangeable = 106
SetUnableToFall = 107
SendMessageIDToEvents = 108 -- args: <event call>
SetAttackType = 109 -- args: <index> # -1
SetStaminaRecoveryDisabled = 110
SetAIBusyDoingAction = 111
BowTurn = 112
SetBowStance = 113
SetPreciseAimMode = 114
SetSpecialMovement = 115
SetIsWeaponChanging = 116
SetIsItemInUse = 117 -- args: <bool>
SetIsMagicInUse = 118 -- args: <bool>
SetHoverState = 119
RemoveBinoculars = 120
ChangeToSpecialStay = 121
SetIsHeadTurnPossible = 122
OpenMenuWhenUsingItem = 123
OpenMenuWhenUsingMagic = 124 -- args: <action arm index>
BlowDamageTurn = 125
SetDeathStay = 126 -- args: <bool> # TRUE, FALSE
CloseMenuWhenUsingItem = 127
CloseMenuWhenUsingMagic = 128
DisallowAdditiveTurning = 129 -- args: <bool>
ChangeFlightStatus = 130
ShowFixedYAxisDirectionDisplay = 131
WhiffPossibility = 132
SetLadderActionState = 133 -- args: <index>
SetInsufficientStrengthAnimID = 134
ForceCancelThrowAnim = 135
SetThrowState = 136 -- args: <index> # ENUM: THROW_TYPE
StartSlidingDownLadder = 137
SetIsEventActionPossible = 138 -- args: <bool>
RequestThrowAnimInterrupt = 139
SetHandStateOfLadder = 140
SetDamageAnimType = 141 -- args: <index> # ENUM: DAMAGE_FLAG
DownwardSlideTurn = 142 -- args: <index>
InterruptAttack = 143
SkyDeathWarp = 144
ClearSlopeInfo = 145
ReceiveStateInput = 146
SetIsEquipmentChangeableFromMenu = 147
SetHavokVariable = 148 -- args: <string>, <value>
AimAtSelfPosition = 149
SetIsItemAnimationPlaying = 150
DoAIReplanningAtCancelTiming = 151
DenyEventAnimPlaybackRequest = 152
InvokeBackstab = 153
WeaponParameterReference = 154 -- args: <hand index>
AINotifyAttackType = 155 -- args: <index>
SetAutoCaptureTarget = 156
ClearAutoCaptureTarget = 157
RequestAIReplanning = 158
TurnTowardAttacker = 159
SetThrowPossibilityState_Attacker = 160 -- args: <index>
SetThrowPossibilityState_Defender = 161 -- args: <index>
MarkOfGreedyPersonSlipDamageDisable = 162
Unknown163 = 163

StateIdentifier = 200

ChangeHP = 1000 -- args: <value>
ChangeStamina = 1001 -- args: <value> # ENUM: STAMINA_REDUCE

SyncAtInit_Active = 1100
SyncAtInit_Passive = 1101

SetMovementScaleMult = 2001 -- args: <value>
AddSpEffect = 2002 -- args: <id>
SetFastStealthThrowEnabled = 2003
SetTurnSpeed = 2004 -- args: <degrees>
SetCeremonyState = 2005
SetDamageMotionBlendRatio = 2006 -- args: <value>
SetForceTurnTarget = 2007
ForceTurn = 2008
SpecialTurn = 2009
SetInSpecialGuard = 2010
SetWeaponCancelType = 2011 -- args: <index>
SetIsPreciseShootingPossible = 2012
ChooseBowAndArrowSlot = 2013 -- args: <slot index> # 0, 1
Set4DirectionMovementThreshold = 2014 -- args: <front right angle>, <front left angle>, <back left angle>, <back right angle> #
LockonSystemUnableToTurnAngle = 2015 -- args: <angle>, <angle>
ReserveArtsPointsUse = 2016 -- args: <button index>, <hand index>
SetArtsPointFEDisplayState = 2017 -- args: <value> # 0, 1
LockonFixedAngleCancel = 2018
TurnToLockonTargetImmediately = 2019 -- args: *<value>
SetSpecialInterpolation = 2020 -- args: <value>, <bool>
LadderSlideDownCancel = 2021
DisableMagicIDSwitching = 2022
DisableToolIDSwitching = 2023
UseItemDecision = 2024
Unknown2025 = 2025 -- args: <value>
Unknown2026 = 2026
Unknown2027 = 2027
Unknown2029 = 2029 -- args: <value>
Unknown2030 = 2030
PlayEventSync = 2031
Unknown2040 = 2040
Unknown2050 = 2050 -- args: <index>, <index> # IDX_AINOTE_STATETYPE, IDX_AINOTE_STATETYPE

Unknown3000 = 3000
Unknown3001 = 3001
Unknown3002 = 3002
PlayRideAnim = 3003
ApplyRideBlend = 3004 -- args: <blend anim>, <rate>
Unknown3005 = 3005
ApplyDamageFlag = 3007 -- args: <index>

Unknown4000 = 4000
Unknown4001 = 4001
Unknown4002 = 4002

DebugLogOutput = 9000
Test_SpEffectDelete = 9001
Test_SpEffectTypeSpecifyDelete = 9002
MarkerStart = 9003
MarkerEnd = 9004

Wait = 9100
ResetInputQueue = 9101
SetIsEventAnim = 9102
SetAIAttackState = 9103 -- args: <index>
SetIsTurnAnimInProgress = 9104
SetTurnAnimCorrectionRate = 9105 -- args: <degrees>

Unknown9999 = 9999 -- args: <value> # 1, 2, 3

------------------------------------------
-- Must be last for the global variables to be read
------------------------------------------
global = {}
function dummy()
    return
end

global.__index = function(table, element)
    return dummy
end

setmetatable(_G, global)
return

