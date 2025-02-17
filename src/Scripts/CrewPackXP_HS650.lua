--[[
    Crew Pack Script for Hot Start Challenger 650

    Voices by https://www.naturalreaders.com/
    Captain - Will
    FO - Rodney

    Copyright (C) 2022  N1K340

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License version 3 as published by
    the Free Software Foundation.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/gpl-3.0.html>.
]]

if AIRCRAFT_FILENAME == "CL650.acf" then
    -- Initiialisation Variables
    local cpxpVersion = "CrewPack XP : Hot Start CL-650 v1.4"

    local cpxpInitDelay = 10
    local cpxpStartTime = 0
    dataref("cpxp_SIM_TIME", "sim/time/total_running_time_sec")

    -- dependencies
    local LIP = require("LIP")
    require "graphics"

    -- Status HUD Position
    local intHudXStart = 15 -- Moves Settings HUD left and right, 0 being far left of screen
    local intHudYStart = 15 -- Moves Settings HUD up and down, 0 being bottom of screen

    -- Var
    local cpxpBubbleTimer = 0
    local cpxpMsgStr = ""
    local cpxpReady = false
    local cpxpStartPlayed = false
    local cpxpLeftStart = false
    local cpxpRightStart = false
    local cpxpPaTimer = 230
    local cpxpFaPlaySeq = 0
    local cpxpFlightOccoured = false

    local cpxpCrewPackXPSettings = {}
    local cpxpShowSettingsWindow = false
    local cpxpMaster = true
    local cpxpStartMsg = true
    local cpxpPaVol = 0.3
    local cpxpSoundVol = 1.0
    local cpxpEngStartType = 1
    local cpxpFLCH = true
    local cpxpLocgsCalls = true
    local cpxpFoPreflight = true

    local cpxpFlapPos = 0
    local cpxpFlapTime = 3
    local cpxpFlapInd = 0
    local cpxpFlapIndTime = 3
    local cpxpFlap0IndPlay = false
    local cpxpFlap20IndPlay = false

    -- Sounds
    local cpxpStart1 = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/start_1.wav")
    local cpxpStart2 = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/start_2.wav")
    local cpxpStart3 = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/start_3.wav")
    local cpxpStart4 = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/start_4.wav")
    local Output_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/output.wav")
    local cpxpStartLeft_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pf_StartLeft.wav")
    local cpxpStartRight_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pf_StartRight.wav")
    local cpxpStartLeft1_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pf_Start1.wav")
    local cpxpStartRight2_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pf_Start2.wav")
    local cpxpSetThrust_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pf_SetThrust.wav")
    local cpxpThrustSet_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pnf_ThrustSet.wav")
    local cpxpEightyKts_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pnf_80kts.wav")
    local cpxpV1_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pnf_V1.wav")
    local cpxpVR_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pnf_VR.wav")
    local cpxpV2_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pnf_V2.wav")
    local cpxpPosRate_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pnf_PosRate.wav")
    local cpxpClimbThrust_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pf_pnf_ClimbThrust.wav")
    local cpxpGearUp_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pf_GearUp.wav")
    local cpxpGearIsUp_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pnf_GearUp.wav")
    local cpxpGearDn_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pf_GearDn.wav")
    local cpxpGearIsDn_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pnf_GearDn.wav")
    local cpxpFlap0_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pf_Flap0.wav")
    local cpxpFlap20_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pf_Flap20.wav")
    local cpxpFlap30_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pf_Flap30.wav")
    local cpxpFlap45_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pf_Flap45.wav")
    local cpxpFlapIs0_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pnf_Flap0.wav")
    local cpxpFlapIs20_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pnf_Flap20.wav")
    local cpxpFlapIs30_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pnf_Flap30.wav")
    local cpxpFlapIs45_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pnf_Flap45.wav")
    local cpxpGScap_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pnf_GS.wav")
    local cpxpLOCcap_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pnf_LOC.wav")
    local cpxpLOCGScap_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pnf_LOCandGS.wav")
    local cpxpAltAlert_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pnf_AltAlert.wav")
    local cpxpFLCH_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/SpeedMode.wav")
    local cpxpAutopilot_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/Autopilot.wav")
    local cpxp2Green_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pnf_RevGreen.wav")
    local cpxpRevUnsafe_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/HS650/pnf_RevUnsafe.wav")

    function CPXPSetGain()
        set_sound_gain(cpxpStart1, cpxpSoundVol)
        set_sound_gain(cpxpStart2, cpxpSoundVol)
        set_sound_gain(cpxpStart3, cpxpSoundVol)
        set_sound_gain(cpxpStart4, cpxpSoundVol)
        set_sound_gain(cpxpStartLeft_snd, cpxpSoundVol)
        set_sound_gain(cpxpStartRight_snd, cpxpSoundVol)
        set_sound_gain(cpxpStartLeft1_snd, cpxpSoundVol)
        set_sound_gain(cpxpStartRight2_snd, cpxpSoundVol)
        set_sound_gain(cpxpSetThrust_snd, cpxpSoundVol)
        set_sound_gain(cpxpThrustSet_snd, cpxpSoundVol)
        set_sound_gain(cpxpEightyKts_snd, cpxpSoundVol)
        set_sound_gain(cpxpV1_snd, cpxpSoundVol)
        set_sound_gain(cpxpVR_snd, cpxpSoundVol)
        set_sound_gain(cpxpV2_snd, cpxpSoundVol)
        set_sound_gain(cpxpPosRate_snd, cpxpSoundVol)
        set_sound_gain(cpxpClimbThrust_snd, cpxpSoundVol)
        set_sound_gain(cpxpGearUp_snd, cpxpSoundVol)
        set_sound_gain(cpxpGearIsUp_snd, cpxpSoundVol)
        set_sound_gain(cpxpGearDn_snd, cpxpSoundVol)
        set_sound_gain(cpxpGearIsDn_snd, cpxpSoundVol)
        set_sound_gain(cpxpFlap0_snd, cpxpSoundVol)
        set_sound_gain(cpxpFlap20_snd, cpxpSoundVol)
        set_sound_gain(cpxpFlap30_snd, cpxpSoundVol)
        set_sound_gain(cpxpGScap_snd, cpxpSoundVol)
        set_sound_gain(cpxpLOCcap_snd, cpxpSoundVol)
        set_sound_gain(cpxpLOCGScap_snd, cpxpSoundVol)
        set_sound_gain(cpxpAltAlert_snd, cpxpSoundVol)
        set_sound_gain(cpxpFLCH_snd, cpxpSoundVol)
        set_sound_gain(cpxpAutopilot_snd, cpxpSoundVol)
        set_sound_gain(cpxp2Green_snd, cpxpSoundVol)
        set_sound_gain(cpxpRevUnsafe_snd, cpxpSoundVol)
    end

    -- Generic Datarefs
    dataref("cpxpASI", "sim/flightmodel/position/indicated_airspeed")
    dataref("cpxpLEFT_STARTER", "CL650/overhead/eng_start/start_L")
    dataref("cpxpRIGHT_STARTER", "CL650/overhead/eng_start/start_R")
    dataref("cpxpBEACON", "sim/cockpit2/switches/beacon_on")
    dataref("cpxpWEIGHT_ON_WHEELS", "sim/cockpit2/tcas/targets/position/weight_on_wheels", "readonly", 0)
    dataref("cpxpENG1_N2", "sim/flightmodel2/engines/N2_percent", "readonly", 0)
    dataref("cpxpENG2_N2", "sim/flightmodel2/engines/N2_percent", "readonly", 1)
    dataref("cpxpENG1_N1", "sim/flightmodel2/engines/N1_percent", "readonly", 0)
    dataref("cpxpENG2_N1", "sim/flightmodel2/engines/N1_percent", "readonly", 1)
    dataref("cpxpIAS", "sim/flightmodel/position/indicated_airspeed")
    dataref("cpxpVSI", "sim/cockpit2/gauges/indicators/vvi_fpm_pilot")
    dataref("cpxpAGL", "sim/flightmodel/position/y_agl")


    print("CrewPackXP: Initialising cpxpVersion " .. cpxpVersion)
    print("CrewPackXP: Starting at sim time " .. math.floor(cpxp_SIM_TIME))

    -- Bubble for messages
    function CPXPDisplayMessage()
        bubble(20, get("sim/graphics/view/window_height") - 100, cpxpMsgStr)
    end

    function CPXPmsg()
        if cpxpBubbleTimer < 3 then
            CPXPDisplayMessage()
        else
            cpxpMsgStr = ""
        end
    end

    function CPXPBubbleTiming()
        if cpxpBubbleTimer < 3 then
            cpxpBubbleTimer = cpxpBubbleTimer + 1
        end
    end

    do_every_draw("CPXPmsg()")
    do_often("CPXPBubbleTiming()")

    --	Delaying initialisation of datarefs till aircraft loaded
    function CPXPDelayedInit()
        -- Dealy based on time

        if cpxpStartTime == 0 then
            cpxpStartTime = (cpxp_SIM_TIME + cpxpInitDelay)
            cpxpBubbleTimer = 0 - cpxpInitDelay
            ParseCrewPackXPSettings()
        end
        if (cpxp_SIM_TIME < cpxpStartTime) then
            print(
                "CrewPackXP: Init Delay " ..
                math.floor(cpxp_SIM_TIME) .. " waiting for " .. math.floor(cpxpStartTime) .. " --"
            )
            cpxpMsgStr = "CrewPackXP Loading in " .. math.floor(cpxpStartTime - cpxp_SIM_TIME) .. " seconds"
            return
        end
        -- Delay based on CL650 specific variables

        if (XPLMFindDataRef("CL650/pedestal/flaps") ~= nil) then
            dataref("cpxpFLAP_LEVER", "CL650/pedestal/flaps")
        end
        if (XPLMFindDataRef("CL650/fo_state/flaps_ind") ~= nil) then
            dataref("cpxpFLAP_IND", "CL650/fo_state/flaps_ind")
        end
        if (XPLMFindDataRef("CL650/pedestal/gear/ldg_value") ~= nil) then
            dataref("cpxpGEAR_LEVER", "CL650/pedestal/gear/ldg_value")
        end
        if (XPLMFindDataRef("CL650/fo_state/gear_up_all") ~= nil) then
            dataref("cpxpGEAR_UPIND", "CL650/fo_state/gear_up_all")
        end
        if (XPLMFindDataRef("CL650/fo_state/gear_dn_all") ~= nil) then
            dataref("cpxpGEAR_DNIND", "CL650/fo_state/gear_dn_all")
        end

        if (XPLMFindDataRef("CL650/overhead/elec/batt_master") == nil) then
            return
        end

        if not cpxpReady then
            print("CrewPackXP: Datarefs Initialised for " .. PLANE_ICAO .. " at time " .. math.floor(cpxp_SIM_TIME))
            cpxpMsgStr = "CrewPackXP Initialised for " .. PLANE_ICAO
            cpxpBubbleTimer = 0
            cpxpReady = true
        end
    end -- End of DelayedInit

    do_often("CPXPDelayedInit()")

    -- All sounds muted when moved to external view
    local cpxpExternalView = 0

    function CPXPOutsideMute()
        if not cpxpReady then
            return
        end

        if cpxpExternalView ~= get("sim/graphics/view/view_is_external") then
            cpxpExternalView = get("sim/graphics/view/view_is_external")
            if cpxpExternalView == 1 then
                cpxpSoundVol = 0.01
                CPXPSetGain()
            else
                ParseCrewPackXPSettings()
            end
        end
    end

    do_every_frame("CPXPOutsideMute()")

    -- Start Up Sounds
    function CPXPStartSound()
        if not cpxpReady then
            return
        end
        if cpxpStartMsg and not cpxpStartPlayed then
            local soundFile = {
                cpxpStart1,
                cpxpStart2,
                cpxpStart3,
                cpxpStart4
            }
            math.randomseed(os.time())
            play_sound(soundFile[math.random(1, 4)])
            cpxpStartPlayed = true
            set("CL650/CDU/1/idx", 1)
            set("CL650/CDU/2/idx", 1)
            set("CL650/CDU/3/idx", 1)
            set("CL650/CCP/1/cas", 1)
            set("CL650/glareshield/master_warn_L", 1)
            set("CL650/pedestal/throttle/at_disc_L", 1)
        end
    end

    do_often("CPXPStartSound()")

    -- FO Preflight Aircraft
    local cpxpFoPreflighComplete = false
    local cpxpFoDoor = false

    function CPXPFoDoor()
        if not cpxpReady then
            return
        end
        if not cpxpFoDoor and cpxpFoPreflight then
            if get("CL650/doors/main/door") ~= 1 then
                if get("CL650/doors/main/ext_handle_inout_value") == 0 then
                    set("CL650/doors/main/ext_handle_inout", 1)
                end
                if get("CL650/doors/main/ext_handle_inout_value") == 1 and
                    get("CL650/doors/main/ext_handle_rotate_value") == 0
                then
                    set("CL650/doors/main/ext_handle_rotate", 1)
                end
                if get("CL650/doors/main/ext_handle_rotate_value") == 1 then
                    set("CL650/doors/main/door", 1)
                end
                if get("CL650/doors/main/door_value") == 1 then
                    cpxpFoDoor = true
                end
            end
        end
    end

    do_often("CPXPFoDoor()")

    local cpxpFoPre_Basics = false
    local cpxpFoPre_ApuOnline = false
    local cpxpFoPre_AfterPower = false
    local cpxpFoPre_CDU1 = false
    local cpxpFoPre_CDU2 = false
    local cpxpFoPre_CDU3 = false
    local cpxpFoPre_CDU1S = false
    local cpxpFoPre_CDU2S = false
    local cpxpFoPre_CDU3S = false
    local cpxpFoPre_CDUS = false
    local cpxpFoPre_ECS = false

    local cpxpHoldTimer = 0
    function CPXPFoPreflight()
        if not cpxpReady then
            return
        end
        if cpxp_SIM_TIME > (cpxpStartTime + 10) then
            if cpxpFoPreflight and not cpxpFoPreflighComplete then
                if cpxpBEACON == 0 then
                    cpxpMsgStr = "CrewPackXP: Conducting Preflight"
                    cpxpBubbleTimer = 0
                    if not cpxpFoPre_Basics then
                        print("starting preflight")
                        -- Remove Mains Chocks
                        print("removing chocks")
                        set_array("CL650/gear/chocks", 0, 1)
                        set_array("CL650/gear/chocks", 1, 0)
                        set_array("CL650/gear/chocks", 2, 0)

                        -- Remove covers
                        print("removing covers")
                        set("CL650/covers/pitot/pilot", 0)
                        set("CL650/covers/pitot/standby", 0)
                        set("CL650/covers/aoa/pilot", 0)
                        set("CL650/covers/ice/pilot", 0)
                        set("CL650/covers/pitot/copilot", 0)
                        set("CL650/covers/ice/copilot", 0)
                        set("CL650/covers/aoa/copilot", 0)

                        -- Remove Pins
                        print("removing pins")
                        set("CL650/gear/pins/left", 0)
                        set("CL650/gear/pins/nose", 0)
                        set("CL650/gear/pins/right", 0)
                        set("CL650/gear/pins/adg", 0)
                        set("CL650/gear/pins/door", 0)

                        -- Open Blinds
                        set("CL650/window/blinds/1R", 1)
                        set("CL650/window/blinds/2R", 1)
                        set("CL650/window/blinds/3R", 1)
                        set("CL650/window/blinds/4R", 1)
                        set("CL650/window/blinds/5R", 1)
                        set("CL650/window/blinds/6R", 1)
                        set("CL650/window/blinds/7R", 1)
                        set("CL650/window/blinds/8R", 1)
                        set("CL650/window/blinds/1L", 1)
                        set("CL650/window/blinds/2L", 1)
                        set("CL650/window/blinds/3L", 1)
                        set("CL650/window/blinds/4L", 1)
                        set("CL650/window/blinds/5L", 1)
                        set("CL650/window/blinds/6L", 1)
                        set("CL650/window/blinds/7L", 1)
                        print("Blinds Opened")

                        -- Move HUD out of way
                        set("CL650/overhead/hud_combiner", 0)
                        -- Move Control columns down
                        set("CL650/contcoll/0/compact", 1)
                        set("CL650/contcoll/1/compact", 1)

                        -- Cockpit Lighting
                        set("CL650/overhead/ext_lts/nav", 1)
                        set("CL650/overhead/int_lts/overhead", 1)
                        set("CL650/pedestal/lighting/L/flood", 0.2)
                        set("CL650/pedestal/lighting/L/integ", 1)
                        set("CL650/pedestal/lighting/L/integ", 1)
                        set("CL650/pedestal/lighting/C/flood", 0.2)
                        set("CL650/pedestal/lighting/R/integ", 1)
                        set("CL650/pedestal/lighting/R/flood", 0.2)
                        set("CL650/overhead/map_lt/lh", 1)
                        set("CL650/overhead/map_lt/rh", 1)
                        --
                        if get("CL650/lamps/svc/DS5LC_board_dome") == 0 then
                            command_once("CL650/overhead/int_lts/board_down")
                        end
                        set("CL650/galley_lts/entry_dome", 1)
                        set("CL650/cabin_lts/downwash", 0.5)
                        set("CL650/lav_lts/dome", 1)
                        set("CL650/bag_lts/dome", 1)
                        -- Power up interior fuel panel
                        print("Starting interior fuel panel")
                        command_once("CL650/fuelpnl/int/power_up")
                        command_once("CL650/fuelpnl/int/power_up")
                        cpxpFoPre_Basics = true
                        print("Basics complete")
                    end

                    -- Establish power
                    if not cpxpFoPre_ApuOnline then
                        if get("CL650/overhead/elec/batt_master") == 0 then
                            set("CL650/overhead/elec/batt_master", 1)
                            print("turning on power")
                            print("Battery")
                            set("CL650/CCP/1/dc_elec", 1)
                            cpxpHoldTimer = cpxp_SIM_TIME + 3
                        else
                            if cpxpHoldTimer < cpxp_SIM_TIME and get("CL650/overhead/apu/pwr_fuel") == 0 then
                                set("CL650/overhead/apu/pwr_fuel", 1)
                                print("APU Master")
                                cpxpHoldTimer = cpxp_SIM_TIME + 3
                            else
                                if cpxpHoldTimer < cpxp_SIM_TIME and get("CL650/overhead/apu/start_stop") == 0 then
                                    set("CL650/overhead/apu/start_stop", 1)
                                    print("APU Start")
                                    set("CL650/CCP/1/ac_elec", 1)
                                else
                                    if get("libelec/comp/APU_GEN/in_volts") > 110 then
                                        set("CL650/overhead/elec/apu_gen", 1)
                                        print("APU Online")
                                        cpxpHoldTimer = (cpxp_SIM_TIME + 20)
                                        print("Timer = " .. cpxpHoldTimer)
                                        cpxpFoPre_ApuOnline = true
                                        set("CL650/overhead/elec/ac_dc_util", 0)

                                    end
                                end
                            end
                        end
                    end

                    if cpxpFoPre_ApuOnline and cpxp_SIM_TIME > cpxpHoldTimer and not cpxpFoPre_AfterPower then
                        print("After power items")
                        -- Hydr Auto/On
                        set("CL650/overhead/hyd/hyd_1B", -1)
                        set("CL650/overhead/hyd/hyd_3A", 1)
                        set("CL650/overhead/hyd/hyd_3B", -1)
                        set("CL650/overhead/hyd/hyd_2B", -1)
                        -- Close nose door
                        if (get("CL650/svcpnl/ac/nose_door")) ~= 0 then
                            print("closing nose door")
                            command_once("CL650/svcpnl/ac/nose_door")
                        end
                        -- Pedestal
                        command_once("CL650/pedestal/trim/stab_trim_ch_1")
                        command_once("CL650/pedestal/trim/stab_trim_ch_2")
                        if get("CL650/lamps/pedestal/trim/mach_trim") ~= 0 then
                            set("CL650/pedestal/trim/mach", 1)
                            print("Yes i pressed mach trim")
                        end
                        command_once("CL650/pedestal/yd/yd_1")
                        command_once("CL650/pedestal/yd/yd_2")
                        command_once("CL650/pedestal/throttle/ats_disc_L")
                        command_once("CL650/glareshield/master_warn_L")
                        command_once("CL650/CCP/1/cas")
                        command_once("CL650/pedestal/throttle/toga_L")

                        set("CL650/overhead/signs/no_smoking", -1)
                        set("CL650/overhead/signs/emer_lts", 1)
                        set("CL650/ACP/1/vhf2_tog", 1)

                        cpxpFoPre_AfterPower = true
                    end

                    -- Set FMS to status
                    if cpxpFoPre_ApuOnline and cpxp_SIM_TIME > cpxpHoldTimer then
                        if cpxpFoPre_ApuOnline and not cpxpFoPre_CDU1 then
                            if get("CL650/CDU/1/screen/text_line0") ~= "" then
                                if get("CL650/CDU/1/screen/text_line0") == "         INDEX      1/2 " then
                                    cpxpFoPre_CDU1 = true
                                elseif get("CL650/CDU/1/screen/text_line0") ~= "         INDEX      1/2 " then
                                    command_once("CL650/CDU/1/idx")
                                end
                            end
                        end

                        if cpxpFoPre_ApuOnline and not cpxpFoPre_CDU3 then
                            if get("CL650/CDU/3/screen/text_line0") ~= "" then
                                print("CDU3 not blank")
                                if get("CL650/CDU/3/screen/text_line0") == "         INDEX      1/2 " then
                                    cpxpFoPre_CDU3 = true
                                elseif get("CL650/CDU/3/screen/text_line0") ~= "         INDEX      1/2 " then
                                    print("CDU3 pressing index")
                                    command_once("CL650/CDU/3/idx")
                                end
                            end
                        end

                        if cpxpFoPre_CDU1 and not cpxpFoPre_CDU1S then
                            if get("CL650/CDU/1/screen/text_line0") == "         INDEX      1/2 " then
                                command_once("CL650/CDU/1/lsk_l3")
                            elseif get("CL650/CDU/1/screen/text_line0") == "         STATUS     1/2 " then
                                cpxpFoPre_CDU1S = true
                                print("cdu1 done")
                            end
                        end

                        if cpxpFoPre_CDU3 and not cpxpFoPre_CDU3S then
                            if get("CL650/CDU/3/screen/text_line0") == "         INDEX      1/2 " then
                                print("CDU3 in index, pressing LSK3")
                                command_once("CL650/CDU/3/perf")
                                cpxpFoPre_CDU3S = true
                            end
                        end

                        if cpxpFoPre_CDU1S and cpxpFoPre_CDU3S then
                            cpxpFoPre_CDUS = true
                            print("CDU's all complete")
                        end
                    end
                    -- ECS
                    if not cpxpFoPre_ECS and cpxpFoPre_ApuOnline and cpxp_SIM_TIME > cpxpHoldTimer then
                        set("CL650/overhead/bleed/10st/apu_lcv", 1)
                        set("CL650/overhead/bleed/10st/isol", 1)
                        set("CL650/overhead/aircond/pack_L", 1)
                        set("CL650/overhead/aircond/pack_R", 1)
                        cpxpFoPre_ECS = true
                    end

                    -- done
                    if cpxpFoPre_ECS and cpxpFoPre_Basics and cpxpFoPre_ApuOnline and cpxpFoPre_AfterPower and
                        cpxpFoPre_CDUS then
                        set("CL650/pedestal/trim/mach", 1)
                        print("fo preflight complete")
                        cpxpFoPreflighComplete = true
                    end
                else
                    print("CrewPackXP: Skipping FO Preflight, Beacon is on")
                    cpxpFoPreflighComplete = true
                end
            end
        end
    end

    do_often("CPXPFoPreflight()")
    do_often("CPXPFoDoor()")

    -- Fo Securing Checks

    local cpxpApuShutdown = false
    local cpxpDoorclosed = false
    local cpxpFoShutDownRun = false
    local cpxpBasicFoShutDown = false
    local cpxpDoorSeq = 0

    function CPXPFoShutdown()
        if not cpxpReady then
            return
        end
        if cpxpBEACON == 0 and cpxpENG1_N2 < 5 and cpxpENG2_N2 < 5 and cpxpFoShutDownRun then
            cpxpMsgStr = "CrewPackXP: FO is packing it up"
            cpxpBubbleTimer = 0


            if not cpxpBasicFoShutDown then
                set("CL650/overhead/signs/emer_lts", 0)
                if get("CL650/overhead/elec/ac_dc_util") == 0 then
                    command_once("CL650/overhead/elec/ac_dc_util")
                end
                -- Open nose door
                if (get("CL650/svcpnl/ac/nose_door")) == 0 then
                    print("opening nose door")
                    command_once("CL650/svcpnl/ac/nose_door")
                end
                -- Power down interior fuel panel
                command_once("CL650/fuelpnl/int/power_down")
                set("CL650/pedestal/thr_rev/arm_L", 0)
                set("CL650/pedestal/thr_rev/arm_R", 0)
                set("CL650/pedestal/gear/nws", 0)
                set("CL650/overhead/hyd/hyd_1B", 0)
                set("CL650/overhead/hyd/hyd_3A", 0)
                set("CL650/overhead/hyd/hyd_3B", 0)
                set("CL650/overhead/hyd/hyd_2B", 0)
                set("CL650/overhead/ext_lts/nav", 0)
                set("CL650/overhead/ext_lts/logo", 0)
                set("CL650/overhead/elec/apu_gen_value", 0)
                if get("CL650/overhead/apu/start_stop") ~= 0 then
                    command_once("CL650/overhead/apu/start_stop")
                end
                if get("CL650/overhead/apu/pwr_fuel") ~= 0 then
                    command_once("CL650/overhead/apu/pwr_fuel")
                end
                if get("CL650/overhead/aircond/pack_L") ~= 0 then
                    command_once("CL650/overhead/aircond/pack_L")
                end
                if get("CL650/overhead/aircond/pack_R") ~= 0 then
                    command_once("CL650/overhead/aircond/pack_R")
                end
                if get("CL650/overhead/bleed/10st/apu_lcv") ~= 0 then
                    command_once("CL650/overhead/bleed/10st/apu_lcv")
                end
                if get("CL650/overhead/bleed/10st/isol") ~= 0 then
                    command_once("CL650/overhead/bleed/10st/isol")
                end


                set("CL650/fuelpnl/int/sov/l_main_value", 0)
                set("CL650/fuelpnl/int/sov/tail_value", 0)
                set("CL650/fuelpnl/int/sov/aux_value", 0)
                set("CL650/fuelpnl/int/sov/r_main_value", 0)
                set("CL650/fuelpnl/int/sov/r_main_value", 0)
                set("CL650/galley_lts/entry_dome", 0)
                set("CL650/cabin_lts/downwash", 0)
                set("CL650/lav_lts/dome", 0)
                set("CL650/bag_lts/dome", 0)

                -- Mains Chocks
                print("Installing chocks")
                set_array("CL650/gear/chocks", 0, 1)
                set_array("CL650/gear/chocks", 1, 1)
                set_array("CL650/gear/chocks", 2, 1)

                -- Remove covers
                print("Installing covers")
                set("CL650/covers/pitot/pilot", 1)
                set("CL650/covers/pitot/standby", 1)
                set("CL650/covers/aoa/pilot", 1)
                set("CL650/covers/ice/pilot", 1)
                set("CL650/covers/pitot/copilot", 1)
                set("CL650/covers/ice/copilot", 1)
                set("CL650/covers/aoa/copilot", 1)

                -- Install Pins
                print("Installing main gear pins")
                set("CL650/gear/pins/left", 1)
                set("CL650/gear/pins/right", 1)

                -- Open Blinds
                set("CL650/window/blinds/1R", 0)
                set("CL650/window/blinds/2R", 0)
                set("CL650/window/blinds/3R", 0)
                set("CL650/window/blinds/4R", 0)
                set("CL650/window/blinds/5R", 0)
                set("CL650/window/blinds/6R", 0)
                set("CL650/window/blinds/7R", 0)
                set("CL650/window/blinds/8R", 0)
                set("CL650/window/blinds/1L", 0)
                set("CL650/window/blinds/2L", 0)
                set("CL650/window/blinds/3L", 0)
                set("CL650/window/blinds/4L", 0)
                set("CL650/window/blinds/5L", 0)
                set("CL650/window/blinds/6L", 0)
                set("CL650/window/blinds/7L", 0)
                print("Blinds Closed")
                print("Basic items complete, waiting on APU")
                cpxpBasicFoShutDown = true
            end

            if not cpxpApuShutdown and get("sim/cockpit/engine/APU_N1") == 0 then
                set("CL650/overhead/elec/batt_master_value", 0)
                cpxpApuShutdown = true
                cpxpDoorSeq = 1
                print("Installing nose gear pins")
                set("CL650/gear/pins/nose", 1)
                set("CL650/gear/pins/door", 1)
                set("CL650/gear/pins/adg", 1)
                print("CrewPackXP: APU Shutdown, door should be closing")
            end

            if not cpxpDoorclosed and cpxpDoorSeq == 2 then
                print("Door Closed")
                set("CL650/doors/main/ext_handle_rotate_value", 0)
                cpxpDoorSeq = 3
            end

            if not cpxpDoorclosed and cpxpDoorSeq == 3 then
                set("CL650/doors/main/ext_handle_inout_value", 0)
                print("Locking Door")
                cpxpDoorSeq = 4
            end

            if cpxpDoorSeq == 4 then
                cpxpFoShutDownRun = false
                cpxpApuShutdown = false
                cpxpDoorclosed = false
                cpxpBasicFoShutDown = false
                cpxpDoorSeq = 0
                print("CrewPackXP: FO has finished shutting down the Challenger")
            end

        end
    end

    function CPXPcloseTheDoor()
        if not cpxpReady then
            return
        end
        if cpxpApuShutdown and cpxpDoorSeq == 1 then
            if get("CL650/doors/main/door") > 0.002 then
                set("CL650/doors/main/door_value", 0.0)
                -- print("Closing Door")
            elseif get("CL650/doors/main/door") < 0.002 then
                cpxpDoorSeq = 2
                print("Next Step")
            end
        end
    end

    do_every_frame("CPXPcloseTheDoor()")
    do_often("CPXPFoShutdown()")


    -- Engine Start Calls

    function CPXPEngineStart()
        if not cpxpReady then
            return
        end
        if cpxpLEFT_STARTER == 1 and not cpxpLeftStart then
            print("CrewPackXP: Start Left Engine")
            if cpxpEngStartType == 1 then
                play_sound(cpxpStartLeft_snd)
            else
                play_sound(cpxpStartLeft1_snd)
            end
            cpxpLeftStart = true
        end
        if cpxpLEFT_STARTER == 0 then
            cpxpLeftStart = false
        end
        if cpxpRIGHT_STARTER == 1 and not cpxpRightStart then
            print("CrewPackXP: Start Right Engine")
            if cpxpEngStartType == 1 then
                play_sound(cpxpStartRight_snd)
            else
                play_sound(cpxpStartRight2_snd)
            end
            cpxpRightStart = true
        end
        if cpxpRIGHT_STARTER == 0 then
            cpxpRightStart = false
        end
    end

    do_often("CPXPEngineStart()")


    local cpxpCDU3Mode = ""
    local cpxpTORaw = ""
    local cpxpCLBRaw = ""
    local cpxpTON1 = ""
    local cpxpTOACT = ""
    local cpxpCLBN1 = ""
    local cpxpCLBACT = ""

    --[[function testreading()
        if not cpxpReady then
            return
        end
        cpxpCDU3Mode = tostring(get("CL650/CDU/3/screen/text_line0"))
        if cpxpCDU3Mode == "      THRUST LIMIT      " then
            print("Yeet we are in thrust")
            cpxpCLBRaw = tostring(get("CL650/CDU/3/screen/text_line4"))
            cpxpClbN1 = string.sub(cpxpCLBRaw, 1, 4)
            print("Climb Thrust is : " .. cpxpClbN1)
            cpxpClbInt = tonumber(cpxpClbN1) - 10
            print("Is it numerical? " .. cpxpClbInt)
            cpxpCLBRaw = tostring(get("CL650/CDU/3/screen/text_line4"))
            cpxpClbAct = string.sub(cpxpCLBRaw, 7, 9)
            print("Is Climb Mode Active? " .. cpxpClbAct)
        else
            print("Mode is wrong " .. cpxpCDU3Mode)
            set("CL650/CDU/3/perf_value" ,1)
            print("Attempting to change mode")
        end
        print("CDU 3 Reading: " .. tostring(get("CL650/CDU/3/screen/text_line0")))
        print("CDU3Var = " .. cpxpCDU3Mode)
    end

    do_sometimes ("testreading()")]]

    function CPXPThrustRef()
        -- Cant directly read the mode ooofty
        -- Routine Called as req
        if cpxpENG1_N2 >= 60 and cpxpENG2_N2 >= 60 then
            -- Check CDU 3 is showing thrust ref
            cpxpCDU3Mode = tostring(get("CL650/CDU/3/screen/text_line0"))
            if cpxpCDU3Mode == "      THRUST LIMIT  1/2 " then
                print("CDU3 Display Valid")
                cpxpTORaw = tostring(get("CL650/CDU/3/screen/text_line2"))
                cpxpCLBRaw = tostring(get("CL650/CDU/3/screen/text_line4"))
                -- Convert to useable
                if cpxpTORaw ~= nil then
                    cpxpTON1 = string.sub(cpxpTORaw, 1, 4)
                    cpxpTOACT = string.sub(cpxpTORaw, 7, 9)
                else
                    cpxpTON1 = 90
                    print("CrewPackXP: TO N1 not found, using 90")
                end
                if cpxpCLBRaw ~= nil then
                    cpxpCLBN1 = string.sub(cpxpCLBRaw, 1, 4)
                    cpxpCLBACT = string.sub(cpxpCLBRaw, 7, 9)
                else
                    cpxpCLBN1 = 90
                    print("CrewPackXP: CLB N1 not found, using 90")
                end

            else
                print("CrewPackXP: CDU3 Mode is wrong " .. cpxpCDU3Mode)
                set("CL650/CDU/3/perf_value", 1)
                print("CrewPackXP: Attempting to change mode")
                cpxpTON1 = 90
                print("CrewPackXP: TO N1 not found, substituting 90%")
            end
        end
    end

    local cpxpToEngRate = false


    function CPXPEngRateMonitor()
        if not cpxpReady then
            return
        end
        -- Check for TO Thrust Ref
        if not cpxpToEngRate and get("CL650/fo_state/ats_n1_to") == 1 then
            cpxpToEngRate = true
            print("CrewPackXP: TO Mode Detected")
            cpxpMsgStr = "CrewPackXP: Takeoff Calls Armed"
            cpxpBubbleTimer = 0
        end
    end

    do_often("CPXPEngRateMonitor()")

    -- Takeoff Calls

    local cpxpToCalloutMode = false
    local cpxpCalloutTimer = 5
    local cpxpPlaySeq = 0
    local cpxpSixtyPlayed = true
    local cpxpClimbThrustPressed = false
    local cpxpV1 = 0
    local cpxpVR = 0
    local cpxpV2 = 0
    local cpxpFLCHPress = false
    local cpxpFLCHPlay = false

    function CPXPTakeoffTrigger()
        -- TO Callout mode - Reset by climb thurst set call
        if cpxpToEngRate and cpxpWEIGHT_ON_WHEELS == 1 then
            cpxpToCalloutMode = true
            -- print("CrewPackXP: TO Callouts Armed")
        end

    end

    do_often("CPXPTakeoffTrigger()")

    function CPXPTakeoffCalls()
        if not cpxpReady then
            return
        end

        -- TO Call Timer
        if cpxpCalloutTimer < 4 then
            cpxpCalloutTimer = (cpxpCalloutTimer + 1)
            print("CrewPackXP: Call Timer" .. cpxpCalloutTimer)
        end

        -- Set Thrust
        if cpxpToCalloutMode and cpxpENG1_N1 >= 60 and cpxpENG2_N1 >= 60 and cpxpPlaySeq == 0 then
            play_sound(cpxpSetThrust_snd)
            cpxpCalloutTimer = 0
            print("CrewPackXP: TO Mode > 60 N1 Set Thrust")
            cpxpPlaySeq = 1
            CPXPThrustRef()
        end
        if cpxpToCalloutMode and cpxpPlaySeq == 1 then
            if cpxpTON1 ~= nil and cpxpCalloutTimer >= 2 then
                if cpxpENG1_N1 >= (cpxpTON1 - 5) then
                    play_sound(cpxpThrustSet_snd)
                    cpxpCalloutTimer = 0
                    print("CrewPackXP: Looking for TO Thrust of " .. cpxpTON1)
                    print("CrewPackXP: TO Thrust Set")
                    cpxpPlaySeq = 2
                end
            elseif cpxpTON1 == nil then
                cpxpPlaySeq = 2
                print("CrewPackXP: TO Thrust Skiped")
            end
        end

        -- 80 Kts
        if cpxpToCalloutMode and cpxpPlaySeq == 2 and cpxpIAS > 78 and cpxpCalloutTimer >= 2 then
            play_sound(cpxpEightyKts_snd)
            cpxpCalloutTimer = 0
            cpxpSixtyPlayed = false
            cpxpPlaySeq = 3
        end

        -- Obtain EFIS VSpeeds
        if get("CL650/xp_sys_bridge/efis/v1") > 0 and cpxpV1 ~= get("CL650/xp_sys_bridge/efis/v1") then
            cpxpV1 = get("CL650/xp_sys_bridge/efis/v1")
        end

        if get("CL650/xp_sys_bridge/efis/vr") > 0 and cpxpVR ~= get("CL650/xp_sys_bridge/efis/vr") then
            cpxpVR = get("CL650/xp_sys_bridge/efis/vr")
        end

        if get("CL650/xp_sys_bridge/efis/v2") > 0 and cpxpV2 ~= get("CL650/xp_sys_bridge/efis/v2") then
            cpxpV2 = get("CL650/xp_sys_bridge/efis/v2")
            cpxpMsgStr = "CrewPackXP: vSpeeds Captured"
            cpxpBubbleTimer = 0
        end

        -- V1
        if cpxpToCalloutMode and cpxpV1 ~= 0 and cpxpIAS > (cpxpV1 - 3) and cpxpPlaySeq == 3 and cpxpCalloutTimer >= 1 then
            play_sound(cpxpV1_snd)
            cpxpCalloutTimer = 0
            print("CrewPackXP: V1 of " .. math.floor(cpxpV1) .. " Played at " .. math.floor(cpxpIAS) .. " kts")
            cpxpPlaySeq = 4
        elseif cpxpToCalloutMode and cpxpV1 == 0 and cpxpPlaySeq == 3 then
            cpxpPlaySeq = 4
            print("CrewPackXP: V1 Speed not valid")
        end

        -- VR
        if cpxpToCalloutMode and cpxpVR ~= 0 and cpxpIAS > (cpxpVR - 3) and cpxpPlaySeq == 4 and cpxpCalloutTimer >= 1 then
            play_sound(cpxpVR_snd)
            cpxpCalloutTimer = 0
            print("CrewPackXP: VR of " .. math.floor(cpxpVR) .. " Played at " .. math.floor(cpxpIAS) .. " kts")
            cpxpPlaySeq = 5
        elseif cpxpToCalloutMode and cpxpVR == 0 and cpxpPlaySeq == 4 then
            cpxpPlaySeq = 5
            print("CrewPackXP: VR Speed not valid")
        end

        -- V2
        if cpxpToCalloutMode and cpxpV2 ~= 0 and cpxpIAS > (cpxpV2 - 3) and cpxpPlaySeq == 5 and cpxpCalloutTimer >= 1 then
            play_sound(cpxpV2_snd)
            cpxpCalloutTimer = 0
            print("CrewPackXP: V2 of " .. math.floor(cpxpVR) .. " Played at " .. math.floor(cpxpIAS) .. " kts")
            cpxpPlaySeq = 6
        elseif cpxpToCalloutMode and cpxpV2 == 0 and cpxpPlaySeq == 5 then
            cpxpPlaySeq = 6
            print("CrewPackXP: V2 Speed not valid")
        end

        -- Pos Rate
        if cpxpToCalloutMode and cpxpWEIGHT_ON_WHEELS == 0 and cpxpVSI > 50 and cpxpAGL > 10 and cpxpPlaySeq == 6 and
            cpxpCalloutTimer >= 2 then
            play_sound(cpxpPosRate_snd)
            cpxpCalloutTimer = 0
            print("CrewPackXP: Positive Rate " ..
                math.floor(cpxpAGL / 0.3048) .. " AGL and " .. math.floor(cpxpVSI) .. " ft/min")
            cpxpPlaySeq = 7
        end

        -- FLCH

        if cpxpFLCH and cpxpToCalloutMode and cpxpVSI > 50 and cpxpAGL > 457 and cpxpPlaySeq == 7 and not cpxpFLCHPress then
            set("CL650/FCP/flc_mode", 1)
            cpxpFLCHPress = true
            cpxpCalloutTimer = 0
            print("CrewPackXP: Pressing FLCH")
        end

        if cpxpFLCH and cpxpPlaySeq == 7 and cpxpFLCHPress and cpxpCalloutTimer > 2 and not cpxpFLCHPlay then
            if get("CL650/lamps/glareshield/FCP/flc_1") ~= 0 then
                play_sound(cpxpFLCH_snd)
                cpxpFLCHPlay = true
                cpxpCalloutTimer = 0
                print("CrewPackXP: FLCH Engaged")
            else
                cpxpFLCHPlay = true
                print("CrewPackXP: Appears FLCH Failed " .. tostring(get("CL650/lamps/glareshield/FCP/flc_1")))
            end
        end

        -- Climb Thrust Workaround
        if cpxpToCalloutMode and cpxpPlaySeq == 7 and cpxpAGL > 365 and not cpxpClimbThrustPressed then
            CPXPThrustRef()
            if cpxpFlap0IndPlay and cpxpGEAR_UPIND == 1 and cpxpCalloutTimer >= 2 then
                if tostring(get("CL650/CDU/3/screen/text_line0")) == "      THRUST LIMIT  1/2 " and cpxpCLBACT ~= "ACT" then
                    set("CL650/CDU/3/lsk_l2_value", 1)
                    print("CrewPackXP Attempting to set climb thrust")
                elseif cpxpCLBACT == "ACT" then
                    play_sound(cpxpClimbThrust_snd)
                    cpxpCalloutTimer = 0
                    cpxpClimbThrustPressed = true
                    cpxpToCalloutMode = false
                    print("CrewPackXP: ClimbThrust at " .. math.floor(cpxpAGL / 0.3048))
                    print("CrewPackXP: TO Mode off")
                end
            end
        end
    end

    do_every_frame("CPXPTakeoffCalls()")

    --Autopilot on
    local cpxpAPmode = 0
    local cpxpAPPlay = false

    function CPXPAutoPilot()
        if not cpxpReady then
            return
        end

        if get("CL650/lamps/glareshield/FCP/ap_eng_1") ~= cpxpAPmode then
            if get("CL650/lamps/glareshield/FCP/ap_eng_1") ~= 0 and not cpxpAPPlay and cpxpCalloutTimer > 2 then
                play_sound(cpxpAutopilot_snd)
                cpxpCalloutTimer = 0
                print("CrewPackXP: AP On")
                cpxpAPmode = 1
                cpxpAPPlay = true
            elseif get("CL650/lamps/glareshield/FCP/ap_eng_1") == 0 and cpxpAPmode ~= 0 then
                cpxpAPmode = 0
                cpxpAPPlay = false
            end
        end
    end

    do_often("CPXPAutoPilot()")

    -- Gear Selection
    local cpxpGearUpSelectedPlay = false
    local cpxpGearUpIndPlay = true
    local cpxpGearDnSelectedPlay = true
    local cpxpGearDnIndPlay = true

    function CPXPGearSelection()
        if not cpxpReady then
            return
        end
        if cpxpAGL > 15 and cpxpGEAR_LEVER == 1 and cpxpCalloutTimer >= 2 and not cpxpGearUpSelectedPlay then
            play_sound(cpxpGearUp_snd)
            cpxpCalloutTimer = 0
            cpxpGearUpSelectedPlay = true
            cpxpGearUpIndPlay = false
            cpxpGearDnSelectedPlay = false
            cpxpFlightOccoured = true
            --  cpxpApuStart = false
            --  cpxpSpdBrkNotPlayed = false
            -- cpxpSpdBrkPlayed = false
            --  cpxpSixtyPlayed = false
            --  cpxpHorsePlayed = false
            --  cpxpTodPaPlayed = false
            --  cpxpSeatsLandingPlayed = false
            --  cpxpPaxSeatBeltsPlayed = false
            --  set("1-sim/lights/landingN/switch", 0)
            print("CrewPackXP: Gear Up Selected")
        end
        if cpxpAGL > 15 and cpxpGEAR_LEVER == 1 and cpxpGEAR_UPIND == 1 and cpxpCalloutTimer >= 2 and
            not cpxpGearUpIndPlay then
            play_sound(cpxpGearIsUp_snd)
            cpxpCalloutTimer = 0
            cpxpGearUpIndPlay = true
            print("CrewPackXP: Gear Up Indicated")
        end

        -- Gear Down
        if cpxpAGL > 15 and cpxpGEAR_LEVER == 0 and cpxpCalloutTimer >= 2 and not cpxpGearDnSelectedPlay then
            play_sound(cpxpGearDn_snd)
            cpxpCalloutTimer = 0
            cpxpGearUpSelectedPlay = false
            cpxpGearDnSelectedPlay = true
            cpxpGearDnIndPlay = false
            cpxpFLCHPress = false
            cpxpFLCHPlay = false
            cpxpClimbThrustPressed = false
            -- cpxpTogaEvent = false
            -- cpxpTogaMsg = false
            -- set("1-sim/lights/landingN/switch", 1)
            print("CrewPackXP: Gear Down")
        end
        if cpxpAGL > 15 and cpxpGEAR_LEVER == 0 and cpxpGEAR_DNIND == 1 and cpxpCalloutTimer >= 2 and
            not cpxpGearDnIndPlay then
            play_sound(cpxpGearIsDn_snd)
            cpxpCalloutTimer = 0
            cpxpGearDnIndPlay = true
            print("CrewPackXP: Gear Down Indicated")
        end
    end

    do_often("CPXPGearSelection()")


    -- Flaps Callouts in air only


    function CPXPFlapsSelection()
        if not cpxpReady then
            return
        end

        if cpxpFlapPos == 0 and cpxpFlapTime == 1 and cpxpWEIGHT_ON_WHEELS == 0 then
            play_sound(cpxpFlap0_snd)
            cpxpCalloutTimer = 0
            print("CrewPackXP: Flaps 0 Selected for 1 Seconds -- ")
        end
        if cpxpFLAP_IND == 0 and cpxpCalloutTimer >= 2 and cpxpFlapIndTime == 1 and not cpxpFlap0IndPlay and
            cpxpWEIGHT_ON_WHEELS == 0 then
            play_sound(cpxpFlapIs0_snd)
            cpxpCalloutTimer = 0
            print("CrewPackXP: Flaps 0 Indicated")
            cpxpFlap0IndPlay = true
        end

        if cpxpFlapPos == 1 and cpxpFlapTime == 1 and cpxpWEIGHT_ON_WHEELS == 0 then
            play_sound(cpxpFlap20_snd)
            cpxpCalloutTimer = 0
            print("CrewPackXP: Flaps 20 Selected for 1 Seconds -- ")
        end
        if cpxpFLAP_IND == 20 and cpxpCalloutTimer >= 2 and cpxpFlapIndTime == 1 and not cpxpFlap20IndPlay and
            cpxpWEIGHT_ON_WHEELS == 0 then
            play_sound(cpxpFlapIs20_snd)
            cpxpCalloutTimer = 0
            print("CrewPackXP: Flaps 20 Indicated")
            cpxpFlap20IndPlay = true
        end

        if cpxpFlapPos == 2 and cpxpFlapTime == 1 and cpxpWEIGHT_ON_WHEELS == 0 then
            play_sound(cpxpFlap30_snd)
            cpxpCalloutTimer = 0
            print("CrewPackXP: Flaps 30 Selected for 1 Seconds -- ")
        end
        if cpxpFLAP_IND == 30 and cpxpCalloutTimer >= 2 and cpxpFlapIndTime == 1 and cpxpWEIGHT_ON_WHEELS == 0 then
            play_sound(cpxpFlapIs30_snd)
            cpxpCalloutTimer = 0
            print("CrewPackXP: Flaps 30 Indicated")
        end

        if cpxpFlapPos == 3 and cpxpFlapTime == 1 and cpxpWEIGHT_ON_WHEELS == 0 then
            play_sound(cpxpFlap45_snd)
            cpxpCalloutTimer = 0
            print("CrewPackXP: Flaps 45 Selected for 1 Seconds -- ")
        end
        if cpxpFLAP_IND == 45 and cpxpCalloutTimer >= 2 and cpxpFlapIndTime == 1 and cpxpWEIGHT_ON_WHEELS == 0 then
            play_sound(cpxpFlapIs45_snd)
            cpxpCalloutTimer = 0
            print("CrewPackXP: Flaps 45 Indicated")
        end

    end

    do_often("CPXPFlapsSelection()")

    --Monitor Flap Movement
    function CPXPFlapPosCheck()
        if not cpxpReady then
            return
        end
        if cpxpFlapPos ~= cpxpFLAP_LEVER then
            cpxpFlapTime = 0
            cpxpFlapPos = cpxpFLAP_LEVER
            cpxpFlap0IndPlay = false
            cpxpFlap20IndPlay = false
            print("CrewPackXP: Flaps Moved to " .. cpxpFlapPos)
        else
            if cpxpFlapTime <= 1 then
                cpxpFlapTime = cpxpFlapTime + 1
                print("CrewPackXP: cpxpFlapTime = " .. cpxpFlapTime)
            end
        end
        if cpxpFlapInd ~= cpxpFLAP_IND then
            cpxpFlapIndTime = 0
            cpxpFlapInd = cpxpFLAP_IND
            print("CrewPackXP: Flaps Set to " .. cpxpFlapPos)
        else
            if cpxpFlapIndTime <= 1 then
                cpxpFlapIndTime = cpxpFlapIndTime + 1
                print("CrewPackXP: cpxpFlapTime = " .. cpxpFlapIndTime)
            end
        end
    end -- End FlapPosCheck

    do_often("CPXPFlapPosCheck()")


    -- 1000 to go call
    local cpxpAltAlert = 0
    local cpxpAltAlertPlay = false

    function CPXPAltAlert()
        if get("CL650/snd/reu/alt_alert", 0) ~= cpxpAltAlert then
            if get("CL650/snd/reu/alt_alert", 0) == 1 and not cpxpAltAlertPlay then
                play_sound(cpxpAltAlert_snd)
                print("1000 to go")
                cpxpAltAlert = 1
                cpxpAltAlertPlay = true
            elseif get("CL650/snd/reu/alt_alert", 0) == 0 and cpxpAltAlert == 1 then
                cpxpAltAlert = 0
                cpxpAltAlertPlay = false
            end
        end
    end

    do_often("CPXPAltAlert()")

    -- Localiser / GlideSlope

    local cpxpLocPlayed = true
    local cpxpGsPlayed = true

    dataref("cpxpLOC_DEVIATION", "sim/cockpit/radios/nav1_hdef_dot")
    dataref("cpxpLOC_RECEIVED", "libradio/nav1/have_loc_signal")
    dataref("cpxpGS_DEVIATION", "sim/cockpit/radios/nav1_vdef_dot")
    dataref("cpxpGS_RECEIVED", "libradio/nav1/have_gp_signal")
    dataref("cpxpAPPR", "CL650/lamps/glareshield/FCP/appr_1")

    function CPXPLocGsAlive()
        if not cpxpReady then
            return
        end
        -- Loc Capture Right of localiser (CDI Left) Reset by: Full scale LOC deflection
        if cpxpLocgsCalls then
            if cpxpWEIGHT_ON_WHEELS == 0 and cpxpAPPR ~= 0 and cpxpLOC_DEVIATION > -1.8 and cpxpLOC_DEVIATION <= 1 and
                not cpxpLocPlayed and not cpxpToCalloutMode then
                if cpxpGS_RECEIVED == 1 and cpxpGS_DEVIATION > -1.8 and cpxpGS_DEVIATION < 1 and cpxpCalloutTimer > 2 then
                    play_sound(cpxpLOCGScap_snd)
                    cpxpCalloutTimer = 0
                    print("CrewPackXP: LOC and GS Active")
                    cpxpCalloutTimer = 0
                    cpxpLocPlayed = true
                    cpxpGsPlayed = true
                else
                    play_sound(cpxpLOCcap_snd)
                    cpxpCalloutTimer = 0
                    print("CrewPackXP: LOC Active")
                    cpxpCalloutTimer = 0
                    cpxpLocPlayed = true
                end
            end

            if cpxpLOC_DEVIATION <= -2.5 and cpxpLocPlayed then
                print("CrewPackXP: Reset Loc Active Logic")
                print("CrewPackXP: Reset GS Alive Logic")
                cpxpLocPlayed = false
                cpxpGsPlayed = false
            end
            -- Loc Capture Left of localiser (CDI Right)
            if cpxpWEIGHT_ON_WHEELS == 0 and cpxpAPPR ~= 0 and cpxpLOC_DEVIATION < 1.8 and cpxpLOC_DEVIATION >= 1 and
                not cpxpLocPlayed and not cpxpToCalloutMode then
                if cpxpGS_RECEIVED == 1 and cpxpGS_DEVIATION > -1.8 and cpxpGS_DEVIATION < 1 and cpxpCalloutTimer > 2 then
                    play_sound(cpxpLOCGScap_snd)
                    cpxpCalloutTimer = 0
                    print("CrewPackXP: LOC and GS Active")
                    cpxpCalloutTimer = 0
                    cpxpLocPlayed = true
                    cpxpGsPlayed = true
                else
                    play_sound(cpxpLOCcap_snd)
                    cpxpCalloutTimer = 0
                    print("CrewPackXP: LOC Active")
                    cpxpCalloutTimer = 0
                    cpxpLocPlayed = true
                end
            end

            if cpxpLOC_DEVIATION >= 2.5 and cpxpLocPlayed then
                cpxpLocPlayed = false
                cpxpGsPlayed = false
                print("CrewPackXP: Reset Loc Active Logic")
                print("CrewPackXP: Reset GS Alive Logic")
            end
            -- GS
            if cpxpWEIGHT_ON_WHEELS == 0 and cpxpAPPR ~= 0 and cpxpGS_RECEIVED == 1 and cpxpGS_DEVIATION > -1.95 and
                cpxpGS_DEVIATION < 1 and cpxpLocPlayed and not cpxpGsPlayed and cpxpCalloutTimer >= 2 and
                not cpxpToCalloutMode then
                play_sound(cpxpGScap_snd)
                cpxpCalloutTimer = 0
                print("CrewPackXP: GS Alive")
                cpxpGsPlayed = true
            end
        end
    end

    do_often("CPXPLocGsAlive()")


    -- Landing Roll / Speedbrakes - Reset by: Gear Up

    local cpxpRevPlayed = true
    local cpxpRevTime = 0

    dataref("CPXP_REV1", "CL650/pedestal/throttle/reverse_L")
    dataref("CPXP_REV2", "CL650/pedestal/throttle/reverse_R")
    dataref("CPXP_REV1ACT", "CL650/anim/engines/thrust_reverser_deploy_ratio", 0)
    dataref("CPXP_REV2ACT", "CL650/anim/engines/thrust_reverser_deploy_ratio", 1)


    function CPXPLanding()
        if not cpxpReady then
            return
        end

        if cpxpWEIGHT_ON_WHEELS == 1 and cpxpFlightOccoured then
            if CPXP_REV1 ~= 0 and CPXP_REV2 ~= 0 and CPXP_REV1ACT ~= 0 and CPXP_REV2ACT ~= 0 and not cpxpRevPlayed then
                play_sound(cpxp2Green_snd)
                cpxpRevPlayed = true
                print("CrewPackXP: Both Eng in Reverse")
            end
            if cpxpRevTime == 2 and CPXP_REV1 ~= 0 and CPXP_REV1ACT == 0 and not cpxpRevPlayed then
                play_sound(cpxpRevUnsafe_snd)
                cpxpRevPlayed = true
                cpxpCalloutTimer = 0
                print("CrewPackXP: Eng 1 not in Reverse")
            elseif cpxpRevTime == 2 and CPXP_REV2 ~= 0 and CPXP_REV2ACT == 0 and not cpxpRevPlayed and
                cpxpCalloutTimer > 2 then
                play_sound(cpxpRevUnsafe_snd)
                cpxpRevPlayed = true
                print("CrewPackXP: Eng 2 not in Reverse")
            end
        end
    end

    do_often("CPXPLanding()")

    function CPXPRevCheck()
        if not cpxpReady then
            return
        end

        if CPXP_REV1 == 0 and CPXP_REV2 == 0 then
            cpxpRevTime = 0
            cpxpRevPlayed = false
        else
            if cpxpRevTime < 2 then
                cpxpRevTime = cpxpRevTime + 1
                print("CrewPackXP: Rev Time " .. cpxpRevTime)
            end
        end
    end -- End of OnGrndCheck

    do_often("CPXPRevCheck()")


    -- Reset Variables for next Flight
    function CPXPMasterReset()
        if not cpxpReady then
            return
        end
        if cpxpIAS < 2 and cpxpWEIGHT_ON_WHEELS == 1 and get("CL650/pedestal/park_brake") ~= 0 then
            cpxpPlaySeq = 0
            cpxpFlightOccoured = false
            print("CrewPackXP: TO Calls Reset")
        end
    end

    do_often("CPXPMasterReset()")



    -- Settings

    if not SUPPORTS_FLOATING_WINDOWS then
        -- to make sure the script doesn't stop old FlyWithLua versions
        print("imgui not supported by your FlyWithLua cpxpVersion, please update to latest cpxpVersion")
    end

    -- Create Settings window
    function ShowCrewPackXPSettings_wnd()
        ParseCrewPackXPSettings()
        CrewPackXPSettings_wnd = float_wnd_create(450, 280, 0, true)
        float_wnd_set_title(CrewPackXPSettings_wnd, "CrewPackXP Settings")
        float_wnd_set_imgui_builder(CrewPackXPSettings_wnd, "CrewPackXPSettings_contents")
        float_wnd_set_onclose(CrewPackXPSettings_wnd, "CloseCrewPackXPSettings_wnd")
    end

    function CrewPackXPSettings_contents(CrewPackXPSettings_wnd, x, y)
        local winWidth = imgui.GetWindowWidth()
        local winHeight = imgui.GetWindowHeight()
        local titleText = cpxpVersion
        local titleTextWidth, titileTextHeight = imgui.CalcTextSize(titleText)

        imgui.SetCursorPos(winWidth / 2 - titleTextWidth / 2, imgui.GetCursorPosY())
        imgui.TextUnformatted(titleText)

        imgui.Separator()
        imgui.TextUnformatted("")

        imgui.SetCursorPos(20, imgui.GetCursorPosY())
        local changed, newVal = imgui.Checkbox("CrewPackXP on/off", cpxpMaster)
        if changed then
            cpxpMaster = newVal
            SaveCrewPackXPData()
            print("CrewPackXP: Plugin turned on" .. tostring(cpxpMaster))
        end

        imgui.SetCursorPos(20, imgui.GetCursorPosY())
        local changed, newVal = imgui.Checkbox("Play corny sound bite on loading", cpxpStartMsg)
        if changed then
            cpxpStartMsg = newVal
            SaveCrewPackXPData()
            print("CrewPackXP: Start message logic set to " .. tostring(cpxpStartMsg))
        end

        imgui.SetCursorPos(20, imgui.GetCursorPosY())
        if imgui.BeginCombo("Engine Start Call", "", imgui.constant.ComboFlags.NoPreview) then
            if imgui.Selectable("Left / Right", cpxpEngStartType == 1) then
                cpxpEngStartType = 1
                SaveCrewPackXPData()
                print("CrewPackXP: Engine start call set to Left / Right")
            end
            if imgui.Selectable("1 / 2", cpxpEngStartType == 2) then
                cpxpEngStartType = 2
                SaveCrewPackXPData()
                print("CrewPackXP: Engine start call set to 1 / 2")
            end
            imgui.EndCombo()
        end

        imgui.SetCursorPos(20, imgui.GetCursorPosY())
        local changed, newVal = imgui.Checkbox("Play Localiser and Glideslop calls", cpxpLocgsCalls)
        if changed then
            cpxpLocgsCalls = newVal
            SaveCrewPackXPData()
            print("CrewPackXP: LOC / GS Call logic set to " .. tostring(syncAlt))
        end
        imgui.SetCursorPos(20, imgui.GetCursorPosY())
        local changed, newVal = imgui.Checkbox("Automate FLCH at 400ft on TO", cpxpFLCH)
        if changed then
            cpxpFLCH = newVal
            SaveCrewPackXPData()
            print("CrewPackXP: FLCH press at 400ft set to " .. tostring(syncAlt))
        end
        imgui.SetCursorPos(20, imgui.GetCursorPosY())
        local changed, newVal = imgui.Checkbox("FO Automatically Performs Preflight", cpxpFoPreflight)
        if changed then
            cpxpFoPreflight = newVal
            SaveCrewPackXPData()
            print("CrewPackXP: FO PreScan logic set to " .. tostring(cpxpFoPreflight))
        end
        imgui.TextUnformatted("")
        imgui.SetCursorPos(30, imgui.GetCursorPosY())
        local changed, newVal = imgui.SliderFloat("Crew Volume", (cpxpSoundVol * 100), 1, 100, "%.0f")
        if changed then
            cpxpSoundVol = (newVal / 100)
            set_sound_gain(Output_snd, cpxpSoundVol)
            play_sound(Output_snd)
            SaveCrewPackXPData()
            print("CrewPackXP: Volume set to " .. (cpxpSoundVol * 100) .. " %")
        end

        imgui.Separator()
        imgui.TextUnformatted("")
        imgui.SetCursorPos(200, imgui.GetCursorPosY())
        if imgui.Button("CLOSE") then
            CloseCrewPackXPSettings_wnd()
        end
    end

    function CloseCrewPackXPSettings_wnd()
        if CrewPackXPSettings_wnd then
            cpxpShowSettingsWindow = false
            float_wnd_destroy(CrewPackXPSettings_wnd)
        end
    end

    function ToggleCrewPackXPSettings()
        if not cpxpShowSettingsWindow then
            ShowCrewPackXPSettings_wnd()
            cpxpShowSettingsWindow = true
        elseif cpxpShowSettingsWindow then
            CloseCrewPackXPSettings_wnd()
            cpxpShowSettingsWindow = false
        end
    end

    function ParseCrewPackXPSettings()
        local f = io.open(AIRCRAFT_PATH .. "/CrewPackXPSettings.ini", "r")
        if f ~= nil then
            io.close(f)
            cpxpCrewPackXPSettings = LIP.load(AIRCRAFT_PATH .. "/CrewPackXPSettings.ini")
            cpxpMaster = cpxpCrewPackXPSettings.CrewPackXP.cpxpMaster
            cpxpStartMsg = cpxpCrewPackXPSettings.CrewPackXP.cpxpStartMsg
            cpxpSoundVol = cpxpCrewPackXPSettings.CrewPackXP.cpxpSoundVol
            cpxpPaVol = cpxpCrewPackXPSettings.CrewPackXP.cpxpPaVol
            cpxpEngStartType = cpxpCrewPackXPSettings.CrewPackXP.cpxpEngStartType
            cpxpFLCH = cpxpCrewPackXPSettings.CrewPackXP.cpxpFLCH
            cpxpLocgsCalls = cpxpCrewPackXPSettings.CrewPackXP.cpxpLocgsCalls
            cpxpFoPreflight = cpxpCrewPackXPSettings.CrewPackXP.cpxpFoPreflight
            print("CrewPackXP: Settings Loaded")
            CPXPSetGain()
        else
            print("CPXP: No settings file found, using defaults")
        end
    end

    function SaveCrewPack767Settings(cpxpCrewPackXPSettings)
        LIP.save(AIRCRAFT_PATH .. "/CrewPackXPSettings.ini", cpxpCrewPackXPSettings)
    end

    function SaveCrewPackXPData()
        cpxpCrewPackXPSettings = {
            CrewPackXP = {
                cpxpStartMsg = cpxpStartMsg,
                cpxpMaster = cpxpMaster,
                cpxpSoundVol = cpxpSoundVol,
                cpxpPaVol = cpxpPaVol,
                cpxpEngStartType = cpxpEngStartType,
                cpxpFLCH = cpxpFLCH,
                cpxpLocgsCalls = cpxpLocgsCalls,
                cpxpFoPreflight = cpxpFoPreflight,
            }
        }
        print("CrewPackXP: Settings Saved")
        cpxpBubbleTimer = 0
        cpxpMsgStr = "CrewPackXP settings saved"
        CPXPSetGain()
        SaveCrewPack767Settings(cpxpCrewPackXPSettings)
    end

    add_macro("CrewPackXP Settings", "ShowCrewPackXPSettings_wnd()", "CloseCrewPackXPSettings_wnd()", "deactivate")
    create_command(
        "FlyWithLua/CrewPackXP/toggle_settings",
        "Toggle CrewPackXP Settings",
        "ToggleCrewPackXPSettings()",
        "",
        ""
    )
    --]]

    --[[ Draw Settings side window

    The HUD section of code is a reapplication of the FSE Hud written by Togfox.
    Used with permission for freware as per licence https://forums.x-plane.org/index.php?/files/file/53617-fse-hud/

    ]]

    local fltTransparency = 0.25 --alpha value for the boxes
    local fltCurrentTransparency = fltTransparency --use this to fade the gui in and out
    local fltTextVanishingPoint = 0.75 -- this is the transparency value where text needs to 'hide'
    local intButtonHeight = 30 --the clickable 'panels' are called buttons
    local intButtonWidth = 140 --the clickable 'panels' are called buttons
    local intHeadingHeight = 30
    local intFrameBorderSize = 5

    function tfCPXP_DrawOutsidePanel()
        --Draws the overall box
        local x1 = intHudXStart
        local y1 = intHudYStart
        local x2 = x1 + intFrameBorderSize + intButtonWidth + intButtonWidth + intFrameBorderSize
        local y2 = y1 + intFrameBorderSize + intButtonHeight + intButtonHeight + intHeadingHeight + intFrameBorderSize

        graphics.set_color(1, 1, 1, fltCurrentTransparency) --white
        graphics.draw_rectangle(x1, y1, x2, y2)
    end

    function tfCPXP_DrawInsidePanel()
        --Draws the inside panel
        local x1 = intHudXStart + intFrameBorderSize
        local y1 = intHudYStart + intFrameBorderSize
        local x2 = x1 + intButtonWidth + intButtonWidth
        local y2 = y1 + intButtonHeight + intButtonHeight + intHeadingHeight

        graphics.set_color(1, 1, 1, fltCurrentTransparency) --white
        graphics.draw_rectangle(x1, y1, x2, y2)
    end

    function tfCPXP_DrawHeadingPanel()
        --Draws the heading panel and text at the top of the inside panel
        local x1 = intHudXStart + intFrameBorderSize
        local y1 = intHudYStart + intFrameBorderSize + intButtonHeight + intButtonHeight
        local x2 = x1 + intButtonWidth + intButtonWidth
        local y2 = y1 + intHeadingHeight

        local fltStringTransparency = fltCurrentTransparency / fltTransparency -- change the RGB of the text based on expected fade level
        if fltStringTransparency > fltTextVanishingPoint then -- this stops drawing text when the transparency gets too low.
            graphics.draw_string((x1 + (intButtonWidth * 0.25)), (y1 + (intButtonHeight * 0.5)), cpxpVersion, 0, 0, 0)
        end
        graphics.set_color(1, 1, 1, fltCurrentTransparency) --white
        graphics.draw_rectangle(x1, y1, x2, y2)
    end

    function tfCPXP_DrawStatusPanel()
        local x1 = intHudXStart + intFrameBorderSize
        local y1 = intHudYStart + intFrameBorderSize
        local x2 = x1 + intButtonWidth + intButtonWidth
        local y2 = y1 + intButtonHeight

        if cpxpReady then
            local fltStringTransparency = fltCurrentTransparency / fltTransparency -- change the RGB of the text based on expected fade level
            if fltStringTransparency > fltTextVanishingPoint then -- this stops drawing text when the transparency gets too low.
                local cpxptomodestate = nil
                local cpxpVspeedsstr = nil
                if cpxpToCalloutMode == true then
                    cpxptomodestate = 'Armed'
                else
                    cpxptomodestate = 'Not Armed'
                end
                local cpxpToStatus = "To Mode is: " .. cpxptomodestate
                if cpxpV1 > 0 then
                    cpxpVspeedsstr = "Current Vspeeds: V1 " .. cpxpV1 .. ", VR " .. cpxpVR .. ", V2 " .. cpxpV2
                else
                    cpxpVspeedsstr = "Current Vspeeds: V1 'nil', VR 'nil', V2 'nil'"
                end
                graphics.draw_string(x1 + (intButtonWidth * 0.05), y1 + (intButtonHeight * 0.6), cpxpToStatus, 0, 0, 0)
                graphics.draw_string(x1 + (intButtonWidth * 0.05), y1 + (intButtonHeight * 0.2), cpxpVspeedsstr, 0, 0, 0)
            end
        end

        graphics.set_color(1, 1, 1, fltCurrentTransparency) --white
        graphics.draw_rectangle(x1, y1, x2, y2)
    end

    function tfCPXP_DrawAlphaState()
        -- FO preflight and Packup Options enabled

        --There are two buttons side by side in this state
        local x1 = intHudXStart + intFrameBorderSize
        local y1 = intHudYStart + intFrameBorderSize + intButtonHeight
        local x2 = x1 + intButtonWidth
        local y2 = y1 + intButtonHeight

        local fltStringTransparency = fltCurrentTransparency / fltTransparency -- change the RGB of the text based on expected fade level
        if fltStringTransparency > fltTextVanishingPoint then -- this stops drawing text when the transparency gets too low.
            graphics.draw_string(x1 + (intButtonWidth * 0.15), y1 + (intButtonHeight * 0.4), "Ask FO to Preflight", 0, 0
                , 0)
        end
        graphics.set_color(0.27, 0.51, 0.71, fltCurrentTransparency)
        graphics.draw_rectangle(x1, y1, x2, y2)

        --draw button outline
        local fltStringTransparency = (fltCurrentTransparency / fltTransparency) * 0.5 -- change the line transparency. 0.5 is zero transparency
        graphics.set_color(0, 0, 0, fltStringTransparency) --black
        graphics.draw_line(x1, y1, x2, y1)
        graphics.draw_line(x2, y1, x2, y2)
        graphics.draw_line(x2, y2, x1, y2)
        graphics.draw_line(x1, y2, x1, y1)

        --Draw the second button
        x1 = x2
        --y1 = y1		--y1 doesn't change value
        x2 = x1 + intButtonWidth
        y2 = y1 + intButtonHeight

        local fltStringTransparency = fltCurrentTransparency / fltTransparency -- change the RGB of the text based on expected fade level
        if fltStringTransparency > fltTextVanishingPoint then -- this stops drawing text when the transparency gets too low.
            graphics.draw_string(x1 + (intButtonWidth * 0.1), y1 + (intButtonHeight * 0.4), "Ask FO to Packup", 0, 0, 0)
        end
        graphics.set_color(0.27, 0.51, 0.71, fltCurrentTransparency)
        graphics.draw_rectangle(x1, y1, x2, y2)

        --draw button outline
        local fltStringTransparency = (fltCurrentTransparency / fltTransparency) * 0.5 -- change the line transparency. 0.5 is zero transparency
        graphics.set_color(0, 0, 0, fltStringTransparency) --black
        graphics.draw_line(x1, y1, x2, y1)
        graphics.draw_line(x2, y1, x2, y2)
        graphics.draw_line(x2, y2, x1, y2)
        graphics.draw_line(x1, y2, x1, y1)


    end

    function tfCPXP_DrawBetaState()
        -- Inflight options greyed out
        local x1 = intHudXStart + intFrameBorderSize
        local y1 = intHudYStart + intFrameBorderSize + intButtonHeight
        local x2 = x1 + intButtonWidth + intButtonWidth
        local y2 = y1 + intButtonHeight

        local fltStringTransparency = fltCurrentTransparency / fltTransparency -- change the RGB of the text based on expected fade level
        if fltStringTransparency > fltTextVanishingPoint then -- this stops drawing text when the transparency gets too low.
            graphics.draw_string(x1 + (intButtonWidth * 0.15), y1 + (intButtonHeight * 0.4), "Detected in flight", 0, 0,
                0)
        end
        graphics.set_color(4, 1, 4, fltCurrentTransparency) -- greyed out
        graphics.draw_rectangle(x1, y1, x2, y2)

        --draw button outline
        local fltStringTransparency = (fltCurrentTransparency / fltTransparency) * 0.5 -- change the line transparency. 0.5 is zero transparency
        graphics.set_color(0, 0, 0, fltStringTransparency) --black
        graphics.draw_line(x1, y1, x2, y1)
        graphics.draw_line(x2, y1, x2, y2)
        graphics.draw_line(x2, y2, x1, y2)
        graphics.draw_line(x1, y2, x1, y1)
    end

    function tfCPXP_DrawCharlieState()
        -- Not initialised
        local x1 = intHudXStart + intFrameBorderSize
        local y1 = intHudYStart + intFrameBorderSize + intButtonHeight
        local x2 = x1 + intButtonWidth + intButtonWidth
        local y2 = y1 + intButtonHeight

        local fltStringTransparency = fltCurrentTransparency / fltTransparency -- change the RGB of the text based on expected fade level
        if fltStringTransparency > fltTextVanishingPoint then -- this stops drawing text when the transparency gets too low.
            graphics.draw_string(x1 + (intButtonWidth * 0.15), y1 + (intButtonHeight * 0.4), cpxpMsgStr, 0, 0, 0)
        end
    end

    function tfCPXP_DrawButtons()
        -- If on ground with engines off allow FO to preflight or packup
        if not cpxpReady then
            tfCPXP_DrawCharlieState()
        elseif cpxpBEACON == 0 and cpxpWEIGHT_ON_WHEELS == 1 then
            tfCPXP_DrawAlphaState()
        else
            tfCPXP_DrawBetaState()
        end
    end

    function tfCPXP_Draw()
        tfCPXP_DrawOutsidePanel()
        tfCPXP_DrawInsidePanel()
        tfCPXP_DrawHeadingPanel()
        tfCPXP_DrawStatusPanel()
        tfCPXP_DrawButtons()
    end

    function tfCPXP_DrawThings()
        XPLMSetGraphicsState(0, 0, 0, 1, 1, 0, 0)

        --check for mouse over before drawing
        local x1 = intHudXStart
        local y1 = intHudYStart
        local x2 = x1 + intFrameBorderSize + intButtonWidth + intButtonWidth + intFrameBorderSize
        local y2 = y1 + intFrameBorderSize + intButtonHeight + intButtonHeight + intHeadingHeight + intFrameBorderSize
        if (MOUSE_X < x1 or MOUSE_X > x2 or MOUSE_Y < y1 or MOUSE_Y > y2) then
            --don't draw - fade out
            fltCurrentTransparency = fltCurrentTransparency - 0.010
            if fltCurrentTransparency < 0 then
                fltCurrentTransparency = 0
            end
            tfCPXP_Draw()
        else
            fltCurrentTransparency = fltCurrentTransparency + 0.025
            if fltCurrentTransparency > fltTransparency then
                fltCurrentTransparency = fltTransparency
            end

            tfCPXP_Draw()

        end
    end

    function tfCPXP_MouseClick()
        -- Trigger mouse clicks
        local x1 = intHudXStart + intFrameBorderSize
        local y1 = intHudYStart + intFrameBorderSize + intButtonHeight
        local x2 = x1 + intButtonWidth
        local y2 = y1 + intButtonHeight
        -- left button
        if MOUSE_X >= x1 and MOUSE_X <= x2 and MOUSE_Y >= y1 and MOUSE_Y < y2 then
            if cpxpBEACON == 0 and cpxpWEIGHT_ON_WHEELS == 1 then
                cpxpFoPre_Basics = false
                cpxpFoPre_ApuOnline = false
                cpxpFoPre_AfterPower = false
                cpxpFoPre_CDU1 = false
                cpxpFoPre_CDU2 = false
                cpxpFoPre_CDU3 = false
                cpxpFoPre_CDU1S = false
                cpxpFoPre_CDU2S = false
                cpxpFoPre_CDU3S = false
                cpxpFoPre_CDUS = false
                cpxpFoPre_ECS = false
                cpxpFoPreflighComplete = false
                cpxpFoDoor = false
                cpxpFoPreflight = true
                CPXPFoPreflight()
                CPXPFoDoor()
            end
        end
        --This bit is the right button
        x1 = x2
        x2 = x1 + intButtonWidth
        y2 = y1 + intButtonHeight
        if MOUSE_X >= x1 and MOUSE_X <= x2 and MOUSE_Y >= y1 and MOUSE_Y < y2 then
            print("Right Button")
            if cpxpBEACON == 0 and cpxpWEIGHT_ON_WHEELS == 1 then
                cpxpFoShutDownRun = true
                print("i made it here")
            end
        end
        -- Header settigns trigger
        local x1 = intHudXStart + intFrameBorderSize + (intButtonWidth / 3)
        local y1 = intHudYStart + intFrameBorderSize + intButtonHeight + intButtonHeight
        local x2 = x1 + (intButtonWidth * 1.5)
        local y2 = y1 + intHeadingHeight
        if MOUSE_X >= x1 and MOUSE_X <= x2 and MOUSE_Y >= y1 and MOUSE_Y < y2 then
            ToggleCrewPackXPSettings()
        end

    end

    do_every_draw("tfCPXP_DrawThings()")
    do_on_mouse_click("tfCPXP_MouseClick()")

    -- end of Togfox code

end -- Master end
