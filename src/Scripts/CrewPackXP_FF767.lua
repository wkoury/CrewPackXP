--[[
Crew Pack Script for Flight Factor B757 / B767

Voices by https://www.naturalreaders.com/
Captn: Guy
FO: Ranald
Ground Crew: en-AU-B-Male (what a name...)
Safety: Leslie

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

--]]
local coded_aircraft = {
   ["757-200_xp11.acf"] = true,
   ["757-300_xp11.acf"] = true,
   ["757-c32_xp11.acf"] = true,
   ["757-RF_xp11.acf"] = true,
   ["767-200ER_xp11.acf"] = true,
   ["767-300ER_xp11.acf"] = true,
   ["767-F_xp11.acf"] = true,
}

if coded_aircraft[AIRCRAFT_FILENAME] then 

   --------
   -- Initialisation Variables
   local cpxpVersion = "CrewPack XP : FF 767 v1.4"
   local cpxpInitDelay = 15
   local cpxpStartTime = 0
   dataref("cpxp_SIM_TIME", "sim/time/total_running_time_sec")

   -- Status HUD Position
   local intHudXStart = 15 -- Moves Settings HUD left and right, 0 being far left of screen
   local intHudYStart = 475 -- Moves Settings HUD up and down, 0 being bottom of screen

   -- dependencies
   local LIP = require("LIP")
   require "graphics"

   -- Local Variables

   local cpxpBubbleTimer = 0
   local cpxpMsgStr = ""
   local cpxpReady = false
   local cpxpStartPlayed = false
   local cpxpPlaySeq = 0
   local cpxpPosRatePlayed = false
   local cpxpGearUpPlayed = false
   local cpxpFlapPos = 0.000000
   local cpxpFlapTime = 3
   local cpxpGearDownPlayed = true
   local cpxpSpdBrkPlayed = false
   local cpxpSpdBrkNotPlayed = false
   local cpxpSixtyPlayed = true
   local cpxpGndTime = 0
   local cpxpHorsePlayed = true
   local cpxpLocPlayed = false
   local cpxpGsPlayed = false
   local cpxpCockpitSetup = false
   local cpxpFlightOccoured = false
   local cpxpGaPlayed = false
   local cpxpTogaMsg = false
   local cpxpVnavPlayed = true
   local cpxpVnavPressed = true
   local cpxpFlaps20Retracted = true
   local cpxpToEngRate = false
   local cpxpTogaEvent = false
   local cpxpTogaState = nil
   local cpxpToCalloutMode = false
   local cpxpCalloutTimer = 4
   local cpxpInvalidVSpeed = false
   local cpxpClbThrustPlayed = false
   local cpxpFlchPressed = true
   local cpxpGaVnavPressed = true
   local cpxpLnavPressed = true
   local cpxpGpuDisconnect = true
   local cpxpLeftStart = false
   local cpxpRightStart = false
   --  local rightBaro = nil
   local cpxpShowSettingsWindow = false
   local cpxpFoPreflight = false
   local cpxpGseOnBeacon = false
   --  local syncAlt = false
   local cpxpLocgsCalls = false
   local cpxpGaAutomation = false
   local cpxpStartMsg = false
   local cpxpCrewPackXPSettings = {}
   local cpxpSoundVol = 1.0
   local cpxpMaster = true
   local cpxpGpuConnect = false
   local cpxpApuConnect = false
   local cpxpApuStart = true
   local cpxpBeaconSetup = false
   local cpxpDefaultFA = true
   local cpxpFaOnboard = true
   local cpxpFaPlaySeq = 0
   local cpxpPaTimer = 230
   local cpxpPaVol = 0.3
   local cpxpEngStartType = 1
   local cpxpTodPaPlayed = true
   local cpxpSeatsLandingPlayed = true
   local cpxpPaxSeatBeltsPlayed = true
   local cpxpFaTaxiInPaPlayed = true
   local cpxpFOAfterLand = true
   local cpxpFOLandFlow = true

   -- Sound Files
   local cpxpEightyKts_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/pnf_pf_80kts.wav")
   local cpxpV1_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/pnf_V1.wav")
   local cpxpVR_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/pnf_VR.wav")
   local cpxpPosRate_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/pnf_PosRate.wav")
   local cpxpGearUp_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/pf_GearUp.wav")
   local cpxpGearDwn_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/pf_GearDn.wav")
   local cpxpFlap0_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/pf_Flap0.wav")
   local cpxpFlap1_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/pf_Flap1.wav")
   local cpxpFlap5_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/pf_Flap5.wav")
   local cpxpFlap15_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/pf_Flap15.wav")
   local cpxpFlap20_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/pf_Flap20.wav")
   local cpxpFlap25_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/pf_Flap25.wav")
   local cpxpFlap30_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/pf_Flap30.wav")
   local cpxpSpdBrkUp_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/pnf_SpdBrkUp.wav")
   local cpxpSpdBrkNot_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/pnf_SpdBrkNot.wav")
   local cpxpSixtyKts_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/pnf_60kts.wav")
   local cpxpGScap_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/pnf_GS.wav")
   local cpxpLOCcap_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/pnf_LOC.wav")
   local cpxpLOCGScap_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/pnf_LOCandGS.wav")
   local cpxpHorse_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/gnd_horse.wav")
   local cpxpClbThrust_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/pf_ClbThr.wav")
   local cpxpVNAV_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/pf_VNAV.wav")
   local cpxpLNAV_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/pf_LNAV.wav")
   local cpxpStartLeft_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/pf_StartLeft.wav")
   local cpxpStartRight_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/pf_StartRight.wav")
   local cpxpStartLeft1_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/pf_Start1.wav")
   local cpxpStartRight2_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/pf_Start2.wav")
   local Output_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/output.wav")
   local cpxpStart1 = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/start_1.wav")
   local cpxpStart2 = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/start_2.wav")
   local cpxpStart3 = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/start_3.wav")
   local cpxpStart4 = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/start_4.wav")
   local cpxpFA_Welcome_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/fa_welcome.wav")
   local cpxpSafetyDemo767_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/safetyDemo767.wav")
   local cpxpCabinSecure_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/fa_cabinSecure.wav")
   local cpxpTOD_PA_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/pnf_todPa.wav")
   local cpxpSeatLand_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/fa_seatsLanding.wav")
   local cpxpPax_Seatbelts_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/fa_paxseatbelt.wav")
   local cpxpTaxiInPA_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/fa_goodbye.wav")
   local cpxpFoShutdown_snd = load_WAV_file(SCRIPT_DIRECTORY .. "CrewPackXP/Sounds/FF767/fo_shutdown.wav")

   function cpxpSetGain()
      set_sound_gain(cpxpEightyKts_snd, cpxpSoundVol)
      set_sound_gain(cpxpV1_snd, cpxpSoundVol)
      set_sound_gain(cpxpVR_snd, cpxpSoundVol)
      set_sound_gain(cpxpPosRate_snd, cpxpSoundVol)
      set_sound_gain(cpxpGearUp_snd, cpxpSoundVol)
      set_sound_gain(cpxpGearDwn_snd, cpxpSoundVol)
      set_sound_gain(cpxpFlap0_snd, cpxpSoundVol)
      set_sound_gain(cpxpFlap1_snd, cpxpSoundVol)
      set_sound_gain(cpxpFlap5_snd, cpxpSoundVol)
      set_sound_gain(cpxpFlap15_snd, cpxpSoundVol)
      set_sound_gain(cpxpFlap20_snd, cpxpSoundVol)
      set_sound_gain(cpxpFlap25_snd, cpxpSoundVol)
      set_sound_gain(cpxpFlap30_snd, cpxpSoundVol)
      set_sound_gain(cpxpSpdBrkUp_snd, cpxpSoundVol)
      set_sound_gain(cpxpSpdBrkNot_snd, cpxpSoundVol)
      set_sound_gain(cpxpSixtyKts_snd, cpxpSoundVol)
      set_sound_gain(cpxpGScap_snd, cpxpSoundVol)
      set_sound_gain(cpxpLOCcap_snd, cpxpSoundVol)
      set_sound_gain(cpxpLOCGScap_snd, cpxpSoundVol)
      set_sound_gain(cpxpHorse_snd, cpxpSoundVol)
      set_sound_gain(cpxpClbThrust_snd, cpxpSoundVol)
      set_sound_gain(cpxpVNAV_snd, cpxpSoundVol)
      set_sound_gain(cpxpLNAV_snd, cpxpSoundVol)
      set_sound_gain(cpxpStartLeft_snd, cpxpSoundVol)
      set_sound_gain(cpxpStartRight_snd, cpxpSoundVol)
      set_sound_gain(cpxpStartLeft1_snd, cpxpSoundVol)
      set_sound_gain(cpxpStartRight2_snd, cpxpSoundVol)
      set_sound_gain(cpxpStart1, cpxpSoundVol)
      set_sound_gain(cpxpStart2, cpxpSoundVol)
      set_sound_gain(cpxpStart3, cpxpSoundVol)
      set_sound_gain(cpxpStart4, cpxpSoundVol)
      set_sound_gain(cpxpFA_Welcome_snd, cpxpPaVol)
      set_sound_gain(cpxpSafetyDemo767_snd, cpxpPaVol)
      set_sound_gain(cpxpTOD_PA_snd, cpxpPaVol)
      set_sound_gain(cpxpSeatLand_snd, cpxpPaVol)
      set_sound_gain(cpxpPax_Seatbelts_snd, cpxpPaVol)
      set_sound_gain(cpxpTaxiInPA_snd, cpxpPaVol)
      set_sound_gain(cpxpCabinSecure_snd, cpxpSoundVol)
      set_sound_gain(cpxpFoShutdown_snd, cpxpSoundVol)
      print("Gain change" .. cpxpPaVol)
   end

   -- Generic Datarefs
   dataref("cpxpAGL", "sim/flightmodel/position/y_agl")
   dataref("cpxpFLAP_LEVER", "sim/flightmodel/controls/flaprqst", "writeable")
   dataref("cpxpGEAR_HANDLE", "1-sim/cockpit/switches/gear_handle")
   dataref("cpxpSPEED_BRAKE", "sim/cockpit2/controls/speedbrake_ratio")
   dataref("cpxpWEIGHT_ON_WHEELS", "sim/cockpit2/tcas/targets/position/weight_on_wheels", "readonly", 0)
   dataref("cpxpPARK_BRAKE", "sim/cockpit2/controls/parking_brake_ratio")
   dataref("cpxpENG1_N2", "sim/flightmodel2/engines/N2_percent", "readonly", 0)
   dataref("cpxpENG2_N2", "sim/flightmodel2/engines/N2_percent", "readonly", 1)
   dataref("cpxpLOC_DEVIATION", "sim/cockpit/radios/nav2_hdef_dot")
   dataref("cpxpLOC_RECEIVED", "1-sim/radios/isReceivingIlsLoc1")
   dataref("cpxpGS_DEVIATION", "sim/cockpit/radios/nav2_vdef_dot")
   dataref("cpxpGS_RECEIVED", "1-sim/radios/isReceivingIlsGs1")
   --  dataref("cpxpSTROBE_SWITCH", "sim/cockpit2/switches/strobe_lights_on")
   dataref("cpxpENGINE_MODE", "1-sim/eng/thrustRefMode") --TOGA 6 -- TO 1 / 11 / 12
   --  dataref("cpxpMCP_SPEED", "sim/cockpit/autopilot/airspeed", "writeable")
   dataref("cpxpFLCH_BUTTON", "1-sim/AP/flchButton", "writeable")
   dataref("cpxpVNAV_ENGAGED_LT", "1-sim/AP/lamp/4")
   dataref("cpxpVNAV_BUTTON", "1-sim/AP/vnavButton", "writeable")
   dataref("cpxpLNAV_BUTTON", "1-sim/AP/lnavButton", "writeable")
   --  dataref("cpxpAUTO_BRAKE", "1-sim/gauges/autoBrakeModeSwitcher", "writeable")
   dataref("cpxpTOGA_BUTTON", "1-sim/AP/togaButton")
   dataref("cpxpBEACON", "sim/cockpit2/switches/beacon_on")
   dataref("cpxpLEFT_STARTER", "sim/flightmodel2/engines/starter_is_running", "readonly", 0)
   dataref("cpxpRIGHT_STARTER", "sim/flightmodel2/engines/starter_is_running", "readonly", 1)
   dataref("cpxpBELTS_SIGN", "sim/cockpit2/annunciators/fasten_seatbelt")



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
         "CrewPackXP: Init Delay " .. math.floor(cpxp_SIM_TIME) .. " waiting for " .. math.floor(cpxpStartTime) .. " --"
         )
         cpxpMsgStr = "CrewPackXP Loading in " .. math.floor(cpxpStartTime - cpxp_SIM_TIME) .. " seconds"
         return
      end
      -- Delay based on 757 specific variables
      if (XPLMFindDataRef("757Avionics/adc1/outIas") ~= nil) then
         dataref("IAS", "757Avionics/adc1/outIas")
      end
      if (XPLMFindDataRef("757Avionics/fms/v1") ~= nil) then
         dataref("cpxpV1", "757Avionics/fms/v1")
      end
      if (XPLMFindDataRef("757Avionics/fms/vr") ~= nil) then
         dataref("cpxpVR", "757Avionics/fms/vr")
      end
      if (XPLMFindDataRef("757Avionics/fms/v2") ~= nil) then
         dataref("cpxpV2", "757Avionics/fms/v2")
      end
      if (XPLMFindDataRef("757Avionics/adc1/outVs") ~= nil) then
         dataref("VSI", "757Avionics/adc1/outVs")
      end
      if (XPLMFindDataRef("757Avionics/fms/accel_height") ~= nil) then
         dataref("FMS_ACCEL_HT", "757Avionics/fms/accel_height")
      end
      if (XPLMFindDataRef("757Avionics/adc1/adc_fail") ~= nil) then
         dataref("ADC1", "757Avionics/adc1/adc_fail")
      end
      if (XPLMFindDataRef("757Avionics/fms/vref30") ~= nil) then
         dataref("VREF_30", "757Avionics/fms/vref30")
      end
      if (XPLMFindDataRef("757Avionics/options/ND/advEfisPanel") ~= nil) then
         dataref("EFIS_TYPE", "1-sim/ngpanel")
      end
      if (XPLMFindDataRef("757Avionics/fms/vnav_phase") ~= nil) then
         dataref("FMS_MODE", "757Avionics/fms/vnav_phase")
      end

      if (XPLMFindDataRef("anim/17/button") == nil) then
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
            cpxpStart4,
         }
         math.randomseed(os.time())
         play_sound(soundFile[math.random(1,4)])
         cpxpStartPlayed = true
      end
   end

   do_often("CPXPStartSound()")

   -- Adjust sound gain for view points
   local cpxpCockpitDoor = 0
   local cpxpExternalView = 0

   -- PA volume with cockpit door open increase by 0.5 to max of 0.9
   function CPXPSoundDoor()
      if not cpxpReady then
         return
      end
      
      if cpxpCockpitDoor ~= get("anim/cabindoor") then
         cpxpCockpitDoor = get("anim/cabindoor")
         if cpxpCockpitDoor == 0 then
            ParseCrewPackXPSettings()
         elseif cpxpCockpitDoor == 1 then
            ParseCrewPackXPSettings()
            if (cpxpPaVol + 0.5) < 1 then
               cpxpPaVol = cpxpPaVol + 0.5
            else
               cpxpPaVol = 0.9
            end
            cpxpSetGain()
         end
      end
   end

   -- All sounds muted when moved to external view
   function CPXPOutsideMute()
      if not cpxpReady then
         return
      end

      if cpxpExternalView ~= get("sim/graphics/view/view_is_external") then
         cpxpExternalView = get("sim/graphics/view/view_is_external")
         if cpxpExternalView == 1 then
            cpxpPaVol = 0.01
            cpxpSoundVol = 0.01
            cpxpSetGain()
         else
            if get("anim/cabindoor") == 0 then
               ParseCrewPackXPSettings()
            elseif get("anim/cabindoor") == 1 then
               ParseCrewPackXPSettings()
               if (cpxpPaVol + 0.5) < 1 then
                  cpxpPaVol = cpxpPaVol + 0.5
               else
                  cpxpPaVol = 0.9
               end
               cpxpSetGain()
            end
         end
      end
   end

   do_every_frame("CPXPSoundDoor()")
   do_every_frame("CPXPOutsideMute()")
   
   -- Monitor for ADC1 Failure
   function CPXPMonitorADC1()
      if not cpxpReady then
         return
      end
      if ADC1 == 1 then
         print("CrewPackXP: ADC1 Failure, callouts degraded")
         cpxpMsgStr = "CrewPackXP: Aircraft data computer failure detected"
         cpxpBubbleTimer = 0
      end
   end -- End of MonitorADC1

   do_often("CPXPMonitorADC1()")

   -- Cockpit Setup
   local B757 = {
      ["757-200_xp11.acf"] = true,
      ["757-300_xp11.acf"] = true,
      ["757-c32_xp11.acf"] = true,
      ["757-RF_xp11.acf"] = true,
   }

   local B767 = {
      ["767-200ER_xp11.acf"] = true,
      ["767-300ER_xp11.acf"] = true,
      ["767-F_xp11.acf"] = true,
   }

   function CPXPCockpitSetup()
      if not cpxpReady then
         return
      end
      if not cpxpCockpitSetup then
         set("anim/armCapt/1", 2)
         set("anim/armFO/1", 2)
         set("lights/ind_rhe", 1)
         set("lights/cabin_com", 1)
         if get("sim/graphics/scenery/sun_pitch_degrees") < 0 then
            set("lights/glareshield1_rhe", 0.1)
            set("lights/aux_rhe", 0.05)
            set("lights/buttomflood_rhe", 0.2)
            set("lights/aisel_rhe", 0.5)
            set("lights/dome/flood_rhe", 1)
            set("anim/52/button", 1)
            set("lights/ind_rhe", 0)
            set("lights/cabin_com", 0.6)
            set("lights/chart_rhe", 0.5)
            set("lights/panel_rhe", 0.2)
            set("lights/flood_rhe", 0.4)
            set("1-sim/CDU/R/CDUbrtRotary", 0.5)
            set("1-sim/CDU/L/CDUbrtRotary", 0.5)
         end
         if EFIS_TYPE == 1 then -- New Type 757
            set("1-sim/ndpanel/1/hsiModeRotary", 2)
            set("1-sim/ndpanel/1/hsiRangeRotary", 1)
            set("1-sim/ndpanel/1/hsiRangeButton", 1)
            set("1-sim/ndpanel/2/hsiModeRotary", 2)
            set("1-sim/ndpanel/2/hsiRangeRotary", 2)
            set("1-sim/ndpanel/1/hsiRangeButton", 1)
            --  set("1-sim/inst/HD/L", 0)
            --  set("1-sim/inst/HD/R", 0)
         end
         if EFIS_TYPE == 0 then
            set("1-sim/ndpanel/1/hsiModeRotary", 4)
            set("1-sim/ndpanel/1/hsiRangeRotary", 1)
            set("1-sim/ndpanel/1/hsiRangeButton", 1)
            set("1-sim/ndpanel/2/hsiModeRotary", 4)
            set("1-sim/ndpanel/2/hsiRangeRotary", 2)
            set("1-sim/ndpanel/1/hsiRangeButton", 1)
            set("1-sim/ndpanel/1/dhRotary", 0.00)
            set("1-sim/ndpanel/2/dhRotary", 0.00)
         end
         set("1-sim/ndpanel/1/hsiTerr", 1)
         set("1-sim/ndpanel/2/hsiTerr", 1)
         cpxpCalloutTimer = 0
         set("anim/14/button", 1)
         set("1-sim/electrical/stbyPowerSelector", 1)
         if cpxpWEIGHT_ON_WHEELS == 1 and cpxpBEACON == 0 and cpxpENG1_N2 < 20 and cpxpENG2_N2 < 20 then
            if PLANE_ICAO == "B762" or PLANE_ICAO == "B763" then
               set_array("sim/cockpit2/switches/custom_slider_on", 2, 1)
               set_array("sim/cockpit2/switches/custom_slider_on", 3, 1)
               set_array("sim/cockpit2/switches/custom_slider_on", 0, 1)
            end
            if PLANE_ICAO == "B753" or PLANE_ICAO == "B752" then
               set_array("sim/cockpit2/switches/custom_slider_on", 6, 1)
               set_array("sim/cockpit2/switches/custom_slider_on", 7, 1)
               set_array("sim/cockpit2/switches/custom_slider_on", 0, 1)
            end
            set("params/LSU", 1)
            set("params/stop", 1)
            set("params/gate", 1)
            set("sim/cockpit2/controls/elevator_trim", 0.046353)
            set("1-sim/WX/tiltRotary", 1)
            set("1-sim/vor1/isAuto", 1)
            set("1-sim/vor1/isAuto", 2)
            set("1-sim/mic_sel/1/1/volume_button", 1)
            set("1-sim/mic_sel/1/3/volume_button", 1)
            set("1-sim/mic_sel/1/1/volume", 1)
            set("1-sim/mic_sel/1/3/volume", 1)
         end
         cpxpCockpitSetup = true
         print("CrewPackXP: Attempting basic setup")
         -- blinds
         for i = 1, 90, 1 do
            local ref = "anim/blind/L/"..i
            set(ref, 0)
         end
         for i = 1, 90, 1 do
            local ref = "anim/blind/R/"..i
            set(ref, 0)
         end
         -- FO Preflight
         if cpxpFoPreflight then
            cpxpMsgStr = "CrewPackXP: FO Attempting to setup cockpit"
            cpxpBubbleTimer = 0
            set("1-sim/cockpitDoor/switch", 0)
            set("anim/1/button", 1)
            set("anim/2/button", 1)

            if B767[AIRCRAFT_FILENAME] then
               set("anim/3/button", 1)
               set("anim/4/button", 1)

               set("1-sim/hyd/airSwitch", 0)
               set("anim/8/button", 1)
               set("anim/11/button", 11)
               set("anim/9/button", 0)
               set("anim/10/button", 0)
               
            end

            if B757[AIRCRAFT_FILENAME] then
               set("anim/12/button", 1)
               set("anim/9/button", 0)
               set("anim/10/button", 0)
               set("anim/13/button", 1)
            end

            set("1-sim/irs/cdu/dsplSel", 1)
            set("1-sim/irs/1/modeSel", 2)
            set("1-sim/irs/2/modeSel", 2)
            set("1-sim/irs/3/modeSel", 2)
            set("anim/3/button", 1)
            set("anim/4/button", 1)
            set("anim/8/button", 1)
            set("anim/11/button", 1)
            set("anim/17/button", 1)
            set("anim/18/button", 1)
            set("anim/20/button", 1)
            set("anim/21/button", 1)
            set("anim/22/button", 1)
            set("anim/25/button", 1)
            set("anim/30/button", 1)
            set("anim/31/button", 1)
            set("lights/aux_rhe", 0.2)
            set("lights/buttomflood_rhe", 0.2)
            set("lights/glareshield1_rhe", 0.2)
            set("lights/aisel_rhe", 1)
            set("1-sim/emer/lightsCover", 0)
            set("1-sim/engine/ignitionSelector", 0)
            set("anim/rhotery/8", 1)
            set("anim/rhotery/9", 1)
            set("anim/43/button", 1)
            set("anim/47/button", 1)
            set("anim/48/button", 1)
            set("anim/49/button", 1)
            set("anim/50/button", 1)
            set("anim/53/button", 1)
            set("sim/cockpit/switches/no_smoking", 2)
            set("sim/cockpit/switches/fasten_seat_belts", 0)
            set("1-sim/press/rateLimitSelector", 0.3)
            math.randomseed(os.time())
            set("1-sim/press/modeSelector", (math.random(0, 1)))
            set("1-sim/cond/fltdkTempControl", 0.5)
            set("1-sim/cond/fwdTempControl", 0.5)
            set("1-sim/cond/midTempControl", 0.5)
            set("1-sim/cond/aftTempControl", 0.5)
            set("anim/54/button", 1)
            set("anim/55/button", 1)
            set("anim/56/button", 1)
            set("1-sim/cond/leftPackSelector", 1)
            set("1-sim/cond/rightPackSelector", 1)
            set("anim/59/button", 1)
            set("anim/87/button", 1)
            set("anim/90/button", 1)
            set("anim/60/button", 1)
            set("anim/61/button", 1)
            set("anim/62/button", 1)
            set("1-sim/AP/fd2Switcher", 0)
            set("1-sim/eicas/stat2but", 1)
            set("757Avionics/CDU/init_ref", 1)
            set("757Avionics/CDU2/prog", 1)
            set(
            "sim/cockpit/misc/barometer_setting",
            (math.floor((tonumber(get("sim/weather/barometer_sealevel_inhg"))) * 100) / 100)
            )
            set(
            "sim/cockpit/misc/barometer_setting2",
            (math.floor((tonumber(get("sim/weather/barometer_sealevel_inhg"))) * 100) / 100)
            )
            set("1-sim/press/landingAltitudeSelector", ((math.ceil(get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") / 10))/100) - 2)
         else
            print("FO Preflight inhibited by settings")
            cpxpMsgStr = "CrewPackXP: FO Preflight inhibited by settings"
            cpxpBubbleTimer = 0
         end
      end
   end -- End of cpxpCockpitSetup

   do_often("CPXPCockpitSetup()")

   -- AutoSync Alt Settings

   function CPXPSyncBaro()
      if not cpxpReady then
         return
      end
      if syncAlt then
         if get("sim/cockpit/misc/barometer_setting") ~= rightBaro then
            rightBaro = get("sim/cockpit/misc/barometer_setting")
            if EFIS_TYPE == 0 then
               print("CrewPackXP: FO Altimiter Synced")
               set("sim/cockpit/misc/barometer_setting2", rightBaro)
            else
               print("CrewPackXP: Unable to sync altimeters in new style 757")
            end
         end
      elseif syncAlt and EFIS_TYPE == 1 then
         print("CrewPackXP: Unable to sync baros in new 757 EFIS")
      end
   end

   do_sometimes("CPXPSyncBaro()")

   -- FO Shutdown Procedure
   local cpxpFoShutdownRun = false


   function CPXPFoShutdown()
      if not cpxpReady then
         return
      end
      if cpxpFoShutdownRun and cpxpWEIGHT_ON_WHEELS == 1 and cpxpBEACON == 0 and cpxpENG1_N2 < 5 and cpxpENG2_N2 < 5 then
         cpxpMsgStr = "CrewPackXP: FO powering it down"
         cpxpBubbleTimer = 0
         print("Shutting it down")
         -- Shutdown Checklist Items
         set("anim/41/button", 0)
         set("anim/42/button", 0)
         set("sim/cockpit/switches/fasten_seat_belts", 0)

         --Hydr
         if B757[AIRCRAFT_FILENAME] then
            set("anim/12/button", 0)
            set("anim/9/button", 0)
            set("anim/10/button", 0)
            set("anim/13/button", 0)
         end

         if B767[AIRCRAFT_FILENAME] then
            set("1-sim/hyd/airSwitch", 0)
            set("anim/8/button", 0)
            set("anim/9/button", 0)
            set("anim/10/button", 0)
            set("anim/11/button", 0)
         end
         
         -- Fuel
         set("anim/32/button", 0)
         set("anim/33/button", 0)
         set("anim/34/button", 0)
         set("anim/35/button", 0)
         set("anim/36/button", 0)
         set("anim/37/button", 0)
         set("anim/38/button", 0)
         set("anim/39/button", 0)

         set("anim/44/button", 0)
         set("anim/59/button", 1)
         set("1-sim/AP/fd1Switcher", 1)
         set("1-sim/AP/fd2Switcher", 1)
         set("anim/rhotery/35", 1)

         -- Secure
         set("anim/rhotery/3", 0)
         set("anim/rhotery/4", 0)
         set("anim/rhotery/5", 0)
         set("1-sim/emer/lightsCover", 1)
         set("1-sim/emer/lights", 0)
         set("anim/47/button", 0)
         set("anim/48/button", 0)
         set("anim/49/button", 0)
         set("anim/50/button", 0)
         set("1-sim/cond/leftPackSelector", 0)
         set("1-sim/cond/rightPackSelector", 0)
         set("1-sim/engine/APUStartSelector", 0)
         if get("sim/cockpit/engine/APU_N1") < 25 then
            set("anim/16/button", 0)
            set("1-sim/electrical/stbyPowerSelector", 0)
            set("1-sim/electrical/batteryCover", 1)
            set("anim/14/button", 0)
            cpxpFoShutdownRun = false
         end  
      end 
   end

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

   -- Flight Attendant Interactions

   function CPXPFlightAttendant()
      if not cpxpReady then
         return
      end
      if cpxpDefaultFA then
         set("params/saiftydone", 1)
      end
      if cpxpPaTimer < 241 then
         cpxpPaTimer = cpxpPaTimer + 1
         --print("CrewPackXP: Cabin timer " .. cpxpPaTimer)
      end
      if cpxpFaOnboard then
         if cpxpBEACON == 1 and cpxpWEIGHT_ON_WHEELS == 1 and cpxpENG2_N2 > 10 and cpxpFaPlaySeq == 0 then
            cpxpPaTimer = 150
            play_sound(cpxpFA_Welcome_snd)
            cpxpFaPlaySeq = 1
            print("CrewPackXP: Playing FA welcome PA - Engine Start")
         end
         if cpxpBEACON == 1 and cpxpWEIGHT_ON_WHEELS == 1 and (math.floor(get("sim/flightmodel2/position/groundspeed"))) ~= 0 and cpxpFaPlaySeq == 0 then
            cpxpPaTimer = 150
            play_sound(cpxpFA_Welcome_snd)
            cpxpFaPlaySeq = 1
            print("CrewPackXP: Playing FA welcome PA, GS "..(math.floor(get("sim/flightmodel2/position/groundspeed"))))
         end
         if cpxpBEACON == 1 and cpxpWEIGHT_ON_WHEELS == 1 and cpxpFaPlaySeq == 1 and cpxpPaTimer == 241 then
            cpxpPaTimer = 0
            play_sound(cpxpSafetyDemo767_snd)
            print("CrewPackXP: Playing Safety Demo")

            cpxpFaPlaySeq = 2
         end
         if cpxpBEACON == 1 and cpxpWEIGHT_ON_WHEELS == 1 and cpxpFaPlaySeq == 2 and cpxpPaTimer == 241 then
            play_sound(cpxpCabinSecure_snd)
            print("CrewPackXP: Played Cabin Secure")
            cpxpFaPlaySeq = 3
         end
         if FMS_MODE == 4 and not cpxpTodPaPlayed then
            play_sound(cpxpTOD_PA_snd)
            print("CrewPackXP: Played FO TOD PA")
            cpxpTodPaPlayed = true
            for i = 1, 90, 1 do
               local ref = "anim/blind/L/"..i
               set(ref, 0)
            end
            for i = 1, 90, 1 do
               local ref = "anim/blind/R/"..i
               set(ref, 0)
            end
         end
         if FMS_MODE == 4 and not cpxpPaxSeatBeltsPlayed and cpxpBELTS_SIGN == 2 then
            play_sound(cpxpPax_Seatbelts_snd)
            print("CrewPackXP: Seatbelts selected on during descent")
            cpxpPaxSeatBeltsPlayed = true
         end
         if cpxpGearDownPlayed and cpxpCalloutTimer >=2 and not cpxpSeatsLandingPlayed then
            play_sound(cpxpSeatLand_snd)
            for i = 1, 90, 1 do
               local ref = "anim/blind/L/"..i
               set(ref, 0)
            end
            for i = 1, 90, 1 do
               local ref = "anim/blind/R/"..i
               set(ref, 0)
            end
            print("CrewPackXP: Played seats for landing")
            cpxpSeatsLandingPlayed = true
         end
         if cpxpWEIGHT_ON_WHEELS == 1 and cpxpFlightOccoured and not cpxpFaTaxiInPaPlayed and IAS <= 30 then
            play_sound(cpxpTaxiInPA_snd)
            for i = 1, 90, 1 do
               local ref = "anim/blind/L/"..i
               set(ref, 0)
            end
            for i = 1, 90, 1 do
               local ref = "anim/blind/R/"..i
               set(ref, 0)
            end
            print("CrewPackXP: After landing PA")
            cpxpFaTaxiInPaPlayed = true
         end
      end
   end

   do_often("CPXPFlightAttendant()")

   -- Engine Rate Monitor - Reset by: VNAV action in TO and GA as appropriate
   --TOGA 6 | TO 1, 11, 12 |
   function CPXPEngRateMonitor()
      if not cpxpReady then
         return
      end
      if cpxpENGINE_MODE == 6 and not cpxpTogaMsg then
         -- GAEngRate = true
         print("CrewPackXP: GA Mode Armed")
         cpxpTogaMsg = true
      end
      if not cpxpToEngRate and cpxpENGINE_MODE == 1 then
         cpxpToEngRate = true
         print("CrewPackXP: TO Mode detected")
      end
      if not cpxpToEngRate and cpxpENGINE_MODE == 11 then
         cpxpToEngRate = true
         print("CrewPackXP: TO Mode detected")
      end
      if not cpxpToEngRate and cpxpENGINE_MODE == 12 then
         cpxpToEngRate = true
         print("CrewPackXP: TO Mode detected")
      end
      if not cpxpToEngRate and cpxpENGINE_MODE == 2 then
         cpxpToEngRate = true
         print("CrewPackXP: TO Mode detected")
      end
      if not cpxpToEngRate and cpxpENGINE_MODE == 21 then
         cpxpToEngRate = true
         print("CrewPackXP: TO Mode detected")
      end
      if not cpxpToEngRate and cpxpENGINE_MODE == 22 then
         cpxpToEngRate = true
         print("CrewPackXP: TO Mode detected")
      end
   end

   do_every_frame("CPXPEngRateMonitor()")

   -- Takeoff Calls - Reset by: Master Reset
   function CPXPTakeoffCalls()
      if not cpxpReady then
         return
      end

      -- TO Callout Mode - Reset by: VNAV call at accel
      if cpxpToEngRate and cpxpWEIGHT_ON_WHEELS == 1 then
         cpxpToCalloutMode = true
      end

      -- TO Call Times
      if cpxpCalloutTimer < 4 then
         cpxpCalloutTimer = (cpxpCalloutTimer + 1)
         print("CrewPackXP: Call Timer" .. cpxpCalloutTimer)
      end

      -- 80 Kts
      if cpxpToCalloutMode and IAS > 78 and cpxpPlaySeq == 0 then
         play_sound(cpxpEightyKts_snd)
         cpxpCalloutTimer = 0
         print("CrewPackXP: 80 Kts Played at " .. math.floor(IAS) .. " kts")
         -- Confirm XPDR TA/RA and Brakes RTO
         set("anim/rhotery/35", 5)
         set("1-sim/gauges/autoBrakeModeSwitcher", -1)
         cpxpSixtyPlayed = false
         cpxpPlaySeq = 1
      end

      -- V1
      if cpxpToCalloutMode and IAS > cpxpV1 - 3 and cpxpPlaySeq == 1 and cpxpCalloutTimer >= 2 then
         play_sound(cpxpV1_snd)
         cpxpCalloutTimer = 0
         print("CrewPackXP: V1 of " .. math.floor(cpxpV1) .. " Played at " .. math.floor(IAS) .. " kts")
         cpxpPlaySeq = 2
      end

      -- VR
      if cpxpToCalloutMode and IAS > cpxpVR - 3 and cpxpPlaySeq == 2 and cpxpCalloutTimer >= 2 then
         play_sound(cpxpVR_snd)
         cpxpCalloutTimer = 0
         print("CrewPackXP: VR of " .. math.floor(cpxpVR) .. " Played at " .. math.floor(IAS) .. " kts")
         cpxpPlaySeq = 3
      end

      -- Positive Rate
      if cpxpToCalloutMode and cpxpWEIGHT_ON_WHEELS == 0 and VSI > 0 and cpxpPlaySeq == 3 and cpxpCalloutTimer >= 2 then
         play_sound(cpxpPosRate_snd)
         cpxpCalloutTimer = 0
         print("CrewPackXP: Positive Rate " .. math.floor(cpxpAGL) .. " AGL and " .. math.floor(VSI) .. " ft/min")
         cpxpPlaySeq = 4
      end
   end

   do_often("CPXPTakeoffCalls()")

   -- TakeoffNoSpeeds - Reset by: Master Reset
   function CPXPTakeoffNoSpeeds()
      if not cpxpReady then
         return
      end
      if not cpxpInvalidVSpeed and cpxpToCalloutMode and IAS > 100 and cpxpV1 < 100 then
         print("CrewPackXP: V1 Speed invalid value " .. math.floor(cpxpV1))
         cpxpInvalidVSpeed = true
         -- cpxpMsgStr = "CrewPackXP: Invalid V-Speeds detected"
         -- cpxpBubbleTimer = 0
      end
      if not cpxpInvalidVSpeed and cpxpToCalloutMode and IAS > 100 and cpxpVR < 100 then
         print("CrewPackXP: VR Speed invalid value " .. math.floor(cpxpVR))
         cpxpInvalidVSpeed = true
         -- cpxpMsgStr = "CrewPackXP: Invalid V-Speeds detected"
         -- cpxpBubbleTimer = 0
      end
   end

   do_often("CPXPTakeoffNoSpeeds()")

   -- Takeoff VNAV Call - Reset by Master Reset
   function CPXPTakeoffVNAV()
      if not cpxpReady then
         return
      end
      if cpxpToCalloutMode and (cpxpAGL / 0.3048) > FMS_ACCEL_HT + 100 and not cpxpVnavPressed then
         if cpxpVNAV_ENGAGED_LT == 0 then
            if cpxpVNAV_BUTTON == 0 and not cpxpVnavPressed then
               set("1-sim/AP/vnavButton", 1)
               print("CrewPackXP: VNAV pressed")
               cpxpVnavPressed = true
            end
            if cpxpVNAV_BUTTON == 1 and not cpxpVnavPressed then
               set("1-sim/AP/vnavButton", 0)
               print("CrewPackXP: VNAV pressed")
               cpxpVnavPressed = true
            end
         elseif cpxpVNAV_ENGAGED_LT > 0 then
            cpxpVnavPressed = true
         end
      end
      if cpxpVnavPressed and not cpxpVnavPlayed and cpxpVNAV_ENGAGED_LT > 0 then
         play_sound(cpxpVNAV_snd)
         cpxpCalloutTimer = 0
         cpxpVnavPlayed = true
         cpxpVnavPressed = true
         cpxpToCalloutMode = false
         print("CrewPackXP: VNAV at ".. math.floor(cpxpAGL / 0.3048) .. ", " .. FMS_ACCEL_HT .. " accel height")
         print("CrewPackXP: TO Mode off")
      end
   end

   do_often("CPXPTakeoffVNAV()")

   -- Gear Selection
   function CPXPGearSelection()
      if not cpxpReady then
         return
      end
      if cpxpAGL > 15 and cpxpGEAR_HANDLE == 0 and cpxpCalloutTimer >= 2 and not cpxpGearUpPlayed then
         play_sound(cpxpGearUp_snd)
         cpxpCalloutTimer = 0
         cpxpGearUpPlayed = true
         cpxpGearDownPlayed = false
         cpxpFlightOccoured = true
         cpxpApuStart = false
         cpxpFOLandFlow = false
         cpxpSpdBrkNotPlayed = false
         cpxpSpdBrkPlayed = false
         cpxpSixtyPlayed = false
         cpxpHorsePlayed = false
         cpxpTodPaPlayed = false
         cpxpSeatsLandingPlayed = false
         cpxpPaxSeatBeltsPlayed = false
         set("1-sim/lights/landingN/switch", 0)
         print("CrewPackXP: Gear Up")
      end
      -- Gear Down
      if cpxpAGL > 15 and cpxpGEAR_HANDLE == 1 and cpxpCalloutTimer >= 2 and not cpxpGearDownPlayed then
         play_sound(cpxpGearDwn_snd)
         cpxpCalloutTimer = 0
         cpxpGearUpPlayed = false
         cpxpGearDownPlayed = true
         cpxpPosRatePlayed = false
         cpxpTogaEvent = false
         cpxpTogaMsg = false
         set("1-sim/lights/landingN/switch", 1)
         print("CrewPackXP: Gear Down")
      end
   end

   do_often("CPXPGearSelection()")

   -- Flaps Selection

   -- Flaps Callouts in air only
   function CPXPFlapsSelection()
      if not cpxpReady then
         return
      end
      if cpxpFlapPos == 0 and cpxpFlapTime == 1 and cpxpWEIGHT_ON_WHEELS == 0 then
         play_sound(cpxpFlap0_snd)
         cpxpCalloutTimer = 0
         print("CrewPackXP: Flaps 0 position for 1 Seconds -- ")
      end
      if cpxpFlapPos > 0 and cpxpFlapPos < 0.2 and cpxpFlapTime == 1 then
         play_sound(cpxpFlap1_snd)
         cpxpCalloutTimer = 0
         print("CrewPackXP: Flaps 1 position for 1 Seconds -- ")
      end
      if cpxpFlapPos > 0.3 and cpxpFlapPos < 0.4 and cpxpFlapTime == 1 then
         play_sound(cpxpFlap5_snd)
         cpxpCalloutTimer = 0
         print("CrewPackXP: Flaps 5 position for 1 Seconds -- ")
      end
      if cpxpFlapPos == 0.5 and cpxpFlapTime == 1 then
         play_sound(cpxpFlap15_snd)
         cpxpCalloutTimer = 0
         print("CrewPackXP: 15 position for 1 Seconds -- ")
      end
      if cpxpFlapPos > 0.6 and cpxpFlapPos < 0.7 and cpxpFlapTime == 1 then
         play_sound(cpxpFlap20_snd)
         cpxpCalloutTimer = 0
         print("CrewPackXP: Flaps 20 position for 1 Seconds -- ")
      end
      if cpxpFlapPos > 0.8 and cpxpFlapPos < 0.9 and cpxpFlapTime == 1 then
         play_sound(cpxpFlap25_snd)
         cpxpCalloutTimer = 0
         print("CrewPackXP: Flaps 25 position for 1 Seconds -- ")
      end
      if cpxpFlapPos == 1 and cpxpFlapTime == 1 then
         play_sound(cpxpFlap30_snd)
         cpxpCalloutTimer = 0
         print("CrewPackXP: Flaps 30 position for 1 Seconds -- ")
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
         print("CrewPackXP: cpxpFlapPos = " .. cpxpFlapPos)
         print("CrewPackXP: FLAP_LEVER = " .. cpxpFLAP_LEVER)
         print("CrewPackXP: Flaps Moved to " .. cpxpFlapPos .. " --")
      else
         if cpxpFlapTime <= 1 then
            cpxpFlapTime = cpxpFlapTime + 1
            print("CrewPackXP: cpxpFlapTime = " .. cpxpFlapTime)
         end
      end
   end -- End FlapPosCheck

   do_often("CPXPFlapPosCheck()")

   -- Localiser / GlideSlope
   function CPXPLocGsAlive()
      if not cpxpReady then
         return
      end
      -- Loc Capture Right of localiser (CDI Left) Reset by: Full scale LOC deflection
      if cpxpLocgsCalls then
         if  cpxpWEIGHT_ON_WHEELS == 0 and cpxpLOC_RECEIVED == 1 and cpxpLOC_DEVIATION > -1.95 and cpxpLOC_DEVIATION <= 0 and not cpxpLocPlayed and not cpxpTogaEvent and not cpxpToCalloutMode then
            if cpxpGS_RECEIVED == 1 and cpxpGS_DEVIATION > -1.95 and cpxpGS_DEVIATION < 1  then
               play_sound(cpxpLOCGScap_snd)
               print("CrewPackXP: LOC and GS Active")
               cpxpCalloutTimer = 0
               cpxpLocPlayed = true
               cpxpGsPlayed = true
            else
               play_sound(cpxpLOCcap_snd)
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
         if cpxpWEIGHT_ON_WHEELS == 0 and cpxpLOC_RECEIVED == 1 and cpxpLOC_DEVIATION < 1.95 and cpxpLOC_DEVIATION >= 0 and not cpxpLocPlayed and not cpxpTogaEvent and not cpxpToCalloutMode then
            if cpxpGS_RECEIVED == 1 and cpxpGS_DEVIATION > -1.95 and cpxpGS_DEVIATION < 1  then
               play_sound(cpxpLOCGScap_snd)
               print("CrewPackXP: LOC and GS Active")
               cpxpCalloutTimer = 0
               cpxpLocPlayed = true
               cpxpGsPlayed = true
            else
               play_sound(cpxpLOCcap_snd)
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
         if
         cpxpWEIGHT_ON_WHEELS == 0 and  cpxpGS_RECEIVED == 1 and cpxpGS_DEVIATION > -1.95 and cpxpGS_DEVIATION < 1 and cpxpLocPlayed and not cpxpGsPlayed and cpxpCalloutTimer >= 2 and not cpxpTogaEvent and not cpxpToCalloutMode then
            play_sound(cpxpGScap_snd)
            print("CrewPackXP: GS Alive")
            cpxpGsPlayed = true
         end
      end
   end

   do_often("CPXPLocGsAlive()")

   -- Landing Roll / Speedbrakes - Reset by: Gear Up

   function CPXPLanding()
      if not cpxpReady then
         return
      end
      if cpxpWEIGHT_ON_WHEELS == 1 and cpxpFlightOccoured then
         if cpxpSPEED_BRAKE == 1 and not cpxpSpdBrkPlayed then
            play_sound(cpxpSpdBrkUp_snd)
            cpxpSpdBrkPlayed = true
            print("CrewPackXP: Speed Brake On Landing")
         end
         if cpxpSPEED_BRAKE ~= 1 and cpxpGndTime == 5 and not cpxpSpdBrkPlayed and not cpxpSpdBrkNotPlayed then
            play_sound(cpxpSpdBrkNot_snd)
            cpxpSpdBrkNotPlayed = true
            print("CrewPackXP: Speed Brake Not Up On Landing")
         end
      end
      if cpxpWEIGHT_ON_WHEELS == 1 and cpxpFlightOccoured and not cpxpSixtyPlayed and IAS <= 62 then
         play_sound(cpxpSixtyKts_snd)
         cpxpSixtyPlayed = true
         print("CrewPackXP: 60kts on landing played at " .. math.floor(IAS))
      end
      if cpxpWEIGHT_ON_WHEELS == 1 and cpxpFlightOccoured and cpxpApuConnect and not cpxpApuStart and IAS <= 30 then
         set("1-sim/engine/APUStartSelector", 2)
         cpxpApuStart = true
         cpxpMsgStr = "CrewPackXP: Starting APU"
         cpxpBubbleTimer = 0
      end
      if cpxpWEIGHT_ON_WHEELS == 1 and cpxpFlightOccoured and cpxpFOAfterLand and not cpxpFOLandFlow and IAS <= 30 then
         cpxpMsgStr = "CrewPackXP: FO After Ladning Flow"
         cpxpBubbleTimer = 0
         set("1-sim/WX/tiltRotary",1)
         set("1-sim/ndpanel/1/hsiWxr", 0)
         set("1-sim/ndpanel/2/hsiWxr", 0)
         set("1-sim/WX/modeSwitcher", 0)
         set("anim/rhotery/25", 0)
         set("sim/flightmodel/controls/flaprqst", 0)
         set("anim/rhotery/35", 3)
         cpxpFOLandFlow = true
      end
   end

   do_often("CPXPLanding()")

   function CPXPOnGrndCheck()
      if not cpxpReady then
         return
      end
      if cpxpWEIGHT_ON_WHEELS == 0 then
         cpxpGndTime = 0
      else
         if cpxpGndTime <= 5 then
            cpxpGndTime = cpxpGndTime + 1
         end
         if cpxpGndTime == 5 then
            print("CrewPackXP: Sustained Weight on wheels for " .. cpxpGndTime .. " seconds")
         end
      end
   end -- End of OnGrndCheck

   do_often("CPXPOnGrndCheck()")

   -- Reset Variables for next Flight
   function CPXPMasterReset()
      if not cpxpReady then
         return
      end
      if IAS > 30 and IAS < 40 and cpxpWEIGHT_ON_WHEELS == 1 then
         cpxpPlaySeq = 0
         cpxpPosRatePlayed = false
         cpxpGearUpPlayed = false
         cpxpGearDownPlayed = true
         cpxpToEngRate = false
         cpxpInvalidVSpeed = false
         cpxpVnavPlayed = false
         cpxpVnavPressed = false
         cpxpGpuDisconnect = false
         print("CrewPackXP: Reset For Flight")
      end
   end

   do_often("CPXPMasterReset()")

   -- Shut Down Message Reset by: Gear Up
   function CPXPShutDown()
      if not cpxpReady then
         return
      end

      if
      cpxpENG1_N2 < 25 and cpxpENG2_N2 < 25 and cpxpBEACON == 0 and cpxpWEIGHT_ON_WHEELS == 1 and cpxpPARK_BRAKE == 1 and cpxpFlightOccoured and
      not cpxpHorsePlayed
      then
         play_sound(cpxpHorse_snd)
         cpxpHorsePlayed = true
         cpxpFlightOccoured = false
         cpxpCalloutTimer = 0
         cpxpFaPlaySeq = 0
         set("params/stop", 1)
         print("CrewPackXP: You Suck")
         print("CrewPackXP: " .. math.floor(cpxpENG1_N2) .. " | " .. math.floor(cpxpENG2_N2))
      end
      if
      cpxpGseOnBeacon and cpxpENG1_N2 < 25 and cpxpENG2_N2 < 25 and cpxpWEIGHT_ON_WHEELS == 1 and cpxpPARK_BRAKE == 1 and
      cpxpCalloutTimer > 3 and
      cpxpHorsePlayed and
      cpxpBEACON == 0 and not cpxpBeaconSetup
      then
         set("1-sim/cockpitDoor/switch", 0)
         set("params/stop", 1)
         cpxpBubbleTimer = 0
         cpxpMsgStr = "CrewPackXP: Ground crew attending to aircraft"
         if cpxpGpuConnect then
            set("params/gpu", 1)
            cpxpMsgStr = "CrewPackXP: GPU Connected"
            cpxpBubbleTimer = 0
         end
         if cpxpApuConnect then
            set("1-sim/engine/APUStartSelector", 2)
            print("CrewPackXP: Starting APU")
            set("anim/15/button", 1)
         end
         if PLANE_ICAO == "B762" or PLANE_ICAO == "B763" then
            set_array("sim/cockpit2/switches/custom_slider_on", 2, 1)
            set_array("sim/cockpit2/switches/custom_slider_on", 3, 1)
            set_array("sim/cockpit2/switches/custom_slider_on", 0, 1)
         elseif PLANE_ICAO == "B753" or PLANE_ICAO == "B752" then
            set_array("sim/cockpit2/switches/custom_slider_on", 6, 1)
            set_array("sim/cockpit2/switches/custom_slider_on", 7, 1)
            set_array("sim/cockpit2/switches/custom_slider_on", 0, 1)
         end
         set("anim/cabindoor", 1)
         set("params/LSU", 1)
         set("params/gate", 1)
         set("params/fuel_truck", 1)
         cpxpGpuDisconnect = false
         cpxpBeaconSetup = true
      end
   end

   do_often("CPXPShutDown()")

   -- Clear GSE for departure Reset by: Beacon

   function CPXPClearGse()
      if not cpxpReady then
         return
      end
      if cpxpGseOnBeacon and cpxpBEACON == 1 and cpxpENG1_N2 < 25 and cpxpENG2_N2 < 25 and cpxpHorsePlayed and not cpxpGpuDisconnect then
         cpxpMsgStr = "CrewPackXP: Ground crew closing doors"
         cpxpBubbleTimer = 0
         set("anim/16/button", 0)
         set("1-sim/cockpitDoor/switch", 1)
         cpxpCalloutTimer = 0
         set_array("sim/cockpit2/switches/custom_slider_on", 0, 0)
         set_array("sim/cockpit2/switches/custom_slider_on", 1, 0)
         set_array("sim/cockpit2/switches/custom_slider_on", 2, 0)
         set_array("sim/cockpit2/switches/custom_slider_on", 3, 0)
         set_array("sim/cockpit2/switches/custom_slider_on", 4, 0)
         set_array("sim/cockpit2/switches/custom_slider_on", 5, 0)
         set_array("sim/cockpit2/switches/custom_slider_on", 6, 0)
         set_array("sim/cockpit2/switches/custom_slider_on", 7, 0)
         set("params/LSU", 0)
         set("params/gate", 0)
         set("params/stop", 0)
         set("params/fuel_truck", 0)
         cpxpGpuDisconnect = true
         cpxpBeaconSetup = false
      end
      if cpxpBEACON == 1 and get("params/gpu") == 1 and cpxpCalloutTimer > 3 then
         set("params/gpu", 0)
      end
   end

   do_often("CPXPClearGse()")

   -- Go Around Monitor

   function CPXPTogaTrigger()
      cpxpTogaEvent = true
      cpxpFlaps20Retracted = false
      cpxpFlchPressed = false
      cpxpGaVnavPressed = false
      cpxpLnavPressed = false
      cpxpGaPlayed = false
      print("CrewPackXP: TOGA Event Detected at time " .. math.floor(cpxp_SIM_TIME))
      cpxpMsgStr = "CrewPackXP: GO Around Mode"
      cpxpBubbleTimer = 0
      cpxpTogaState = cpxpTOGA_BUTTON
   end

   function CPXPTogaMonitor()
      if cpxpTogaState == nil then
         cpxpTogaState = cpxpTOGA_BUTTON
      elseif cpxpTogaState ~= cpxpTOGA_BUTTON then
         CPXPTogaTrigger()
      end
   end

   do_often("CPXPTogaMonitor()")

   -- Go Around Function - Reset by Toga Trigger, cancels on FMS Accel height

   function CPXPGoAround()
      if cpxpWEIGHT_ON_WHEELS == 0 and cpxpTogaEvent and cpxpENGINE_MODE == 6 and cpxpGaAutomation and not cpxpFlaps20Retracted then
         if cpxpFlapPos > 0.8 then
            set("sim/flightmodel/controls/flaprqst", 0.66667)
            print("CrewPackXP: Go Around - Flaps 20 selected")
            cpxpFlaps20Retracted = true
         end
      end
      if cpxpTogaEvent and not cpxpPosRatePlayed and VSI > 10 then
         play_sound(cpxpPosRate_snd)
         set("1-sim/cockpit/switches/gear_handle", 0)
         print(
         "CrewPackXP: Go Around Positive Rate " ..
         math.floor(cpxpAGL / 0.3048) .. " AGL and " .. math.floor(VSI) .. " ft/min"
         )
         print("CrewPackXP: Waiting for accel height of " .. FMS_ACCEL_HT .. " ft")
         cpxpPosRatePlayed = true
      end
      if
      cpxpTogaEvent and cpxpGaAutomation and cpxpGEAR_HANDLE == 0 and (cpxpAGL / 0.3048) > 410 and cpxpPosRatePlayed and
      not cpxpLnavPressed and
      cpxpLNAV_BUTTON == 0
      then
         set("1-sim/AP/lnavButton", 1)
         print("CrewPackXP: Attempting to engage LNAV")
         cpxpLnavPressed = true
      end
      if
      cpxpTogaEvent and cpxpGaAutomation and cpxpGEAR_HANDLE == 0 and (cpxpAGL / 0.3048) > 410 and cpxpPosRatePlayed and
      not cpxpLnavPressed and
      cpxpLNAV_BUTTON == 1
      then
         set("1-sim/AP/lnavButton", 0)
         print("CrewPackXP: Attempting to engage LNAV")
         cpxpLnavPressed = true
      end
      if cpxpTogaEvent and (cpxpAGL / 0.3048) > FMS_ACCEL_HT and not cpxpClbThrustPlayed then
         set("1-sim/eng/thrustRefMode", 32)
         play_sound(cpxpClbThrust_snd)
         cpxpClbThrustPlayed = true
         print("CrewPackXP: Go Around Climb Thrust " .. FMS_ACCEL_HT)
      end
      if
      cpxpTogaEvent and cpxpGaAutomation and (cpxpAGL / 0.3048) > FMS_ACCEL_HT and cpxpClbThrustPlayed and cpxpVNAV_BUTTON == 0 and
      not cpxpGaVnavPressed
      then
         set("1-sim/AP/vnavButton", 1)
         print("CrewPackXP: Attempting VNAV")
         cpxpGaVnavPressed = true
      end
      if
      cpxpTogaEvent and cpxpGaAutomation and (cpxpAGL / 0.3048) > FMS_ACCEL_HT and cpxpClbThrustPlayed and cpxpVNAV_BUTTON == 1 and
      not cpxpGaVnavPressed
      then
         set("1-sim/AP/vnavButton", 0)
         print("CrewPackXP: Attempting VNAV")
         cpxpGaVnavPressed = true
      end
      if
      cpxpTogaEvent and cpxpGaAutomation and (cpxpAGL / 0.3048) > FMS_ACCEL_HT and cpxpGaVnavPressed and
      cpxpVNAV_ENGAGED_LT ~= 0.8 and
      cpxpFLCH_BUTTON == 0 and
      not cpxpFlchPressed
      then
         set("1-sim/AP/flchButton", 1)
         print("CrewPackXP: Negative VNAV " .. cpxpVNAV_ENGAGED_LT .. " , attempting FLCH")
         cpxpFlchPressed = true
      end
      if
      cpxpTogaEvent and cpxpGaAutomation and (cpxpAGL / 0.3048) > FMS_ACCEL_HT and cpxpGaVnavPressed and
      cpxpVNAV_ENGAGED_LT ~= 0.8 and
      cpxpFLCH_BUTTON == 1 and
      not cpxpFlchPressed
      then
         set("1-sim/AP/flchButton", 0)
         print("CrewPackXP: Negative VNAV " .. cpxpVNAV_ENGAGED_LT .. " , attempting FLCH")
         cpxpFlchPressed = true
      end
      if cpxpTogaEvent and not cpxpGaPlayed and (cpxpAGL / 0.3048) > (FMS_ACCEL_HT + 100) then
         if cpxpGaAutomation and cpxpFlchPressed then
            set("757Avionics/ap/spd_act", math.ceil(VREF_30 + 80))
            print("CrewPackXP: FLCH Vref+80 = " .. math.floor(VREF_30 + 80))
         end
         cpxpGaPlayed = true
         cpxpTogaEvent = false
         print("CrewPackXP: GA Mode Off")
      end
   end

   do_often("CPXPGoAround()")

   -- Settings

   if not SUPPORTS_FLOATING_WINDOWS then
      -- to make sure the script doesn't stop old FlyWithLua versions
      print("imgui not supported by your FlyWithLua cpxpVersion, please update to latest cpxpVersion")
   end

   -- Create Settings window
   function ShowCrewPackXPSettings_wnd()
      ParseCrewPackXPSettings()
      CrewPackXPSettings_wnd = float_wnd_create(450, 480, 0, true)
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
      local changed, newVal = imgui.Checkbox("Supress default flight attendant from pestering", cpxpDefaultFA)
      if changed then
         cpxpDefaultFA = newVal
         SaveCrewPackXPData()
         print("CrewPackXP: Default FA logic set to " .. tostring(cpxpFoPreflight))
      end
      imgui.SetCursorPos(20, imgui.GetCursorPosY())
      local changed, newVal = imgui.Checkbox("Crew Pack FA Onboard?", cpxpFaOnboard)
      if changed then
         cpxpFaOnboard = newVal
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
         if imgui.Selectable("Engine 1 / 2", cpxpEngStartType == 2) then
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
      local changed, newVal = imgui.Checkbox("FO Performs Preflight Scan Flow", cpxpFoPreflight)
      if changed then
         cpxpFoPreflight = newVal
         SaveCrewPackXPData()
         print("CrewPackXP: FO PreScan logic set to " .. tostring(cpxpFoPreflight))
      end
      imgui.SetCursorPos(20, imgui.GetCursorPosY())
      local changed, newVal = imgui.Checkbox("FO Afterlanding Scan flow", cpxpFOAfterLand)
      if changed then
         cpxpFOAfterLand = newVal
         SaveCrewPackXPData()
         print("CrewPackXP: FO Afterlanding scan flow set to " .. tostring(cpxpFOAfterLand))
      end
      imgui.SetCursorPos(20, imgui.GetCursorPosY())
      local changed, newVal = imgui.Checkbox("FO automation on go around", cpxpGaAutomation)
      if changed then
         cpxpGaAutomation = newVal
         SaveCrewPackXPData()
         print("CrewPackXP: Go Around automation logic set to " .. tostring(cpxpGaAutomation))
      end
      imgui.SetCursorPos(20, imgui.GetCursorPosY())
      local changed, newVal = imgui.Checkbox("Chocks, Doors and belt loaders tied to Beacon on/off", cpxpGseOnBeacon)
      if changed then
         cpxpGseOnBeacon = newVal
         SaveCrewPackXPData()
         print("CrewPackXP: GSE on beacon set to " .. tostring(cpxpGseOnBeacon))
      end
      imgui.SetCursorPos(20, imgui.GetCursorPosY())
      local changed, newVal = imgui.Checkbox("Auto sync Cpt and FO Altimiters", syncAlt)
      if changed then
         syncAlt = newVal
         SaveCrewPackXPData()
         print("CrewPackXP: Altimiter Sync logic set to " .. tostring(syncAlt))
      end
      imgui.SetCursorPos(20, imgui.GetCursorPosY())
      imgui.TextUnformatted("Auto power connections: ")
      imgui.SetCursorPos(20, imgui.GetCursorPosY())
      local changed, newVal = imgui.Checkbox("GPU on bay", cpxpGpuConnect)
      if changed then
         cpxpGpuConnect = newVal
         SaveCrewPackXPData()
         print("CrewPackXP: GPU Power on ground")
      end
      imgui.SameLine()
      local changed, newVal = imgui.Checkbox("APU smart start", cpxpApuConnect)
      if changed then
         cpxpApuConnect = newVal
         SaveCrewPackXPData()
         print("CrewPackXP: APU started on ground")
      end
      imgui.TextUnformatted("")
      imgui.SetCursorPos(75, imgui.GetCursorPosY())
      local changed, newVal = imgui.SliderFloat("Crew Volume", (cpxpSoundVol * 100), 1, 100, "%.0f")
      if changed then
         cpxpSoundVol = (newVal / 100)
         set_sound_gain(Output_snd, cpxpSoundVol)
         play_sound(Output_snd)
         SaveCrewPackXPData()
         print("767CrewPacks: Volume set to " .. (cpxpSoundVol * 100) .. " %")
      end
      imgui.TextUnformatted("")
      imgui.SetCursorPos(75, imgui.GetCursorPosY())
      local changed, newVal1 = imgui.SliderFloat("PA Volume", (cpxpPaVol * 100), 1, 100, "%.0f")
      if changed then
         cpxpPaVol = (newVal1 / 100)
         set_sound_gain(Output_snd, cpxpPaVol)
         play_sound(Output_snd)
         SaveCrewPackXPData()
         print("767CrewPacks: Volume set to " .. (cpxpPaVol * 100) .. " %")
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
      local f = io.open(AIRCRAFT_PATH .. "/CrewPackXPSettings.ini","r")
      if f ~= nil then
         io.close(f)
         cpxpCrewPackXPSettings = LIP.load(AIRCRAFT_PATH .. "/CrewPackXPSettings.ini")
         cpxpFoPreflight = cpxpCrewPackXPSettings.CrewPack767.cpxpFoPreflight
         cpxpGseOnBeacon = cpxpCrewPackXPSettings.CrewPack767.cpxpGseOnBeacon
         syncAlt = cpxpCrewPackXPSettings.CrewPack767.syncAlt
         cpxpGaAutomation = cpxpCrewPackXPSettings.CrewPack767.cpxpGaAutomation
         cpxpStartMsg = cpxpCrewPackXPSettings.CrewPack767.cpxpStartMsg
         cpxpLocgsCalls = cpxpCrewPackXPSettings.CrewPack767.cpxpLocgsCalls
         cpxpSoundVol = cpxpCrewPackXPSettings.CrewPack767.cpxpSoundVol
         cpxpPaVol = cpxpCrewPackXPSettings.CrewPack767.cpxpPaVol
         cpxpMaster = cpxpCrewPackXPSettings.CrewPack767.cpxpMaster
         cpxpApuConnect = cpxpCrewPackXPSettings.CrewPack767.cpxpApuConnect
         cpxpGpuConnect = cpxpCrewPackXPSettings.CrewPack767.cpxpGpuConnect
         cpxpDefaultFA = cpxpCrewPackXPSettings.CrewPack767.cpxpDefaultFA
         cpxpFaOnboard = cpxpCrewPackXPSettings.CrewPack767.cpxpFaOnboard
         cpxpEngStartType = cpxpCrewPackXPSettings.CrewPack767.cpxpEngStartType
         cpxpFOAfterLand = cpxpCrewPackXPSettings.CrewPack767.cpxpFOAfterLand
         print("CrewPackXP: Settings Loaded")
         cpxpSetGain()
      else
         print("CPXP: No settings file found, using defaults")
      end
   end

   function SaveCrewPack767Settings(cpxpCrewPackXPSettings)
      LIP.save(AIRCRAFT_PATH .. "/CrewPackXPSettings.ini", cpxpCrewPackXPSettings)
   end

   function SaveCrewPackXPData()
      cpxpCrewPackXPSettings = {
         CrewPack767 = {
            cpxpFoPreflight = cpxpFoPreflight,
            cpxpGseOnBeacon = cpxpGseOnBeacon,
            syncAlt = syncAlt,
            cpxpGaAutomation = cpxpGaAutomation,
            cpxpStartMsg = cpxpStartMsg,
            cpxpLocgsCalls = cpxpLocgsCalls,
            cpxpSoundVol = cpxpSoundVol,
            cpxpMaster = cpxpMaster,
            cpxpGpuConnect = cpxpGpuConnect,
            cpxpApuConnect = cpxpApuConnect,
            cpxpDefaultFA = cpxpDefaultFA,
            cpxpFaOnboard = cpxpFaOnboard,
            cpxpPaVol = cpxpPaVol,
            cpxpEngStartType = cpxpEngStartType,
            cpxpFOAfterLand = cpxpFOAfterLand,

         }
      }
      print("CrewPackXP: Settings Saved")
      cpxpBubbleTimer = 0
      cpxpMsgStr = "CrewPackXP settings saved"
      cpxpSetGain()
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

       --[[ Draw Settings side window

    The HUD section of code is a reapplication of the FSE Hud written by Togfox.
    Used with permission for freware as per licence https://forums.x-plane.org/index.php?/files/file/53617-fse-hud/

    ]]

    local fltTransparency = 0.25		--alpha value for the boxes
    local fltCurrentTransparency = fltTransparency		--use this to fade the gui in and out
    local fltTextVanishingPoint = 0.75	-- this is the transparency value where text needs to 'hide'
    local intButtonHeight = 30			--the clickable 'panels' are called buttons
    local intButtonWidth = 140			--the clickable 'panels' are called buttons
    local intHeadingHeight = 30
    local intFrameBorderSize = 5

    function tfCPXP_DrawOutsidePanel()
        --Draws the overall box
        local x1 = intHudXStart
        local y1 = intHudYStart
        local x2 = x1 + intFrameBorderSize + intButtonWidth + intButtonWidth + intFrameBorderSize
        local y2 = y1 + intFrameBorderSize + intButtonHeight + intButtonHeight + intHeadingHeight + intFrameBorderSize
        
        graphics.set_color(1, 1, 1, fltCurrentTransparency) --white
        graphics.draw_rectangle(x1,y1,x2,y2)
    end

    function tfCPXP_DrawInsidePanel()
        --Draws the inside panel
        local x1 = intHudXStart + intFrameBorderSize
        local y1 = intHudYStart + intFrameBorderSize
        local x2 = x1 + intButtonWidth + intButtonWidth
        local y2 = y1 + intButtonHeight + intButtonHeight + intHeadingHeight
    
        graphics.set_color(1, 1, 1, fltCurrentTransparency) --white
        graphics.draw_rectangle(x1,y1,x2,y2)
    end

    function tfCPXP_DrawHeadingPanel()
        --Draws the heading panel and text at the top of the inside panel
        local x1 = intHudXStart + intFrameBorderSize
        local y1 = intHudYStart + intFrameBorderSize + intButtonHeight + intButtonHeight
        local x2 = x1 + intButtonWidth + intButtonWidth
        local y2 = y1 + intHeadingHeight
        
        local fltStringTransparency = fltCurrentTransparency/fltTransparency	-- change the RGB of the text based on expected fade level
        if fltStringTransparency > fltTextVanishingPoint then	-- this stops drawing text when the transparency gets too low.
            graphics.draw_string((x1 + (intButtonWidth * 0.50)),(y1 + (intButtonHeight * 0.5)), cpxpVersion, 0, 0, 0)
        end
        graphics.set_color(1, 1, 1, fltCurrentTransparency) --white
        graphics.draw_rectangle(x1,y1,x2,y2)	
    end

    function tfCPXP_DrawStatusPanel()
        local x1 = intHudXStart + intFrameBorderSize
        local y1 = intHudYStart + intFrameBorderSize
        local x2 = x1 + intButtonWidth + intButtonWidth
        local y2 = y1 + intButtonHeight

        if cpxpReady then
            local fltStringTransparency = fltCurrentTransparency/fltTransparency	-- change the RGB of the text based on expected fade level
            if fltStringTransparency > fltTextVanishingPoint then	-- this stops drawing text when the transparency gets too low.
                local cpxptomodestate = nil
                local cpxpVspeedsstr = nil
                if cpxpToCalloutMode == true then
                    cpxptomodestate = 'Armed'
                else
                    cpxptomodestate = 'Not Armed'
                end
                local cpxpToStatus = "To Mode is: " .. cpxptomodestate
                if cpxpV1 > 0 then
                    cpxpVspeedsstr = "Current Vspeeds: V1 " .. cpxpV1 .. ", VR " .. cpxpVR.. ", V2 " .. cpxpV2
                else
                    cpxpVspeedsstr = "Current Vspeeds: V1 'nil', VR 'nil', V2 'nil'"
                end
                graphics.draw_string(x1 + (intButtonWidth * 0.05),y1 + (intButtonHeight * 0.6),cpxpToStatus, 0, 0, 0)
                graphics.draw_string(x1 + (intButtonWidth * 0.05), y1 + (intButtonHeight * 0.2), cpxpVspeedsstr, 0, 0, 0)	
            end
        end
            
        graphics.set_color(1, 1, 1, fltCurrentTransparency) --white
        graphics.draw_rectangle(x1,y1,x2,y2)
    end

    function tfCPXP_DrawAlphaState()
	-- FO preflight and Packup Options enabled
	
	--There are two buttons side by side in this state
	local x1 = intHudXStart + intFrameBorderSize
	local y1 = intHudYStart + intFrameBorderSize + intButtonHeight
	local x2 = x1 + intButtonWidth
	local y2 = y1 + intButtonHeight
	
	local fltStringTransparency = fltCurrentTransparency/fltTransparency	-- change the RGB of the text based on expected fade level
	if fltStringTransparency > fltTextVanishingPoint then	-- this stops drawing text when the transparency gets too low.
		graphics.draw_string(x1 + (intButtonWidth * 0.15), y1 + (intButtonHeight * 0.4), "Ask FO to Preflight", 0, 0, 0)
	end
	graphics.set_color(0.27, 0.51, 0.71, fltCurrentTransparency)
	graphics.draw_rectangle(x1,y1,x2,y2)	
	
	--draw button outline
	local fltStringTransparency = (fltCurrentTransparency/fltTransparency) * 0.5	-- change the line transparency. 0.5 is zero transparency
	graphics.set_color(0,0,0,fltStringTransparency)	--black
	graphics.draw_line(x1,y1,x2,y1)
	graphics.draw_line(x2,y1,x2,y2)
	graphics.draw_line(x2,y2,x1,y2)
	graphics.draw_line(x1,y2,x1,y1)
	
	--Draw the second button
	x1 = x2
	--y1 = y1		--y1 doesn't change value
	x2 = x1 + intButtonWidth
	y2 = y1 + intButtonHeight	
	
	local fltStringTransparency = fltCurrentTransparency/fltTransparency	-- change the RGB of the text based on expected fade level
	if fltStringTransparency > fltTextVanishingPoint then	-- this stops drawing text when the transparency gets too low.
		graphics.draw_string(x1 + (intButtonWidth * 0.1), y1 + (intButtonHeight * 0.4), "Ask FO to Packup", 0, 0, 0)
	end
	graphics.set_color(0.27, 0.51, 0.71, fltCurrentTransparency)
	graphics.draw_rectangle(x1,y1,x2,y2)

	--draw button outline
	local fltStringTransparency = (fltCurrentTransparency/fltTransparency) * 0.5	-- change the line transparency. 0.5 is zero transparency
	graphics.set_color(0,0,0,fltStringTransparency)	--black
	graphics.draw_line(x1,y1,x2,y1)
	graphics.draw_line(x2,y1,x2,y2)
	graphics.draw_line(x2,y2,x1,y2)
	graphics.draw_line(x1,y2,x1,y1)	

	
    end

    function tfCPXP_DrawBetaState()
        -- Inflight options greyed out
        local x1 = intHudXStart + intFrameBorderSize
        local y1 = intHudYStart + intFrameBorderSize + intButtonHeight
        local x2 = x1 + intButtonWidth + intButtonWidth
        local y2 = y1 + intButtonHeight
        
        local fltStringTransparency = fltCurrentTransparency/fltTransparency	-- change the RGB of the text based on expected fade level
        if fltStringTransparency > fltTextVanishingPoint then	-- this stops drawing text when the transparency gets too low.
            graphics.draw_string(x1 + (intButtonWidth * 0.15), y1 + (intButtonHeight * 0.4), "Detected in flight", 0, 0, 0)
        end
        graphics.set_color( 4, 1, 4, fltCurrentTransparency) -- greyed out
        graphics.draw_rectangle(x1,y1,x2,y2)
        
        --draw button outline
        local fltStringTransparency = (fltCurrentTransparency/fltTransparency) * 0.5	-- change the line transparency. 0.5 is zero transparency
        graphics.set_color(0,0,0,fltStringTransparency)	--black
        graphics.draw_line(x1,y1,x2,y1)
        graphics.draw_line(x2,y1,x2,y2)
        graphics.draw_line(x2,y2,x1,y2)
        graphics.draw_line(x1,y2,x1,y1)
    end
    
    function tfCPXP_DrawCharlieState()
        -- Not initialised
        local x1 = intHudXStart + intFrameBorderSize
        local y1 = intHudYStart + intFrameBorderSize + intButtonHeight
        local x2 = x1 + intButtonWidth + intButtonWidth
        local y2 = y1 + intButtonHeight

        local fltStringTransparency = fltCurrentTransparency/fltTransparency	-- change the RGB of the text based on expected fade level
        if fltStringTransparency > fltTextVanishingPoint then	-- this stops drawing text when the transparency gets too low.
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
        XPLMSetGraphicsState(0,0,0,1,1,0,0)
        
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
            fltCurrentTransparency = fltCurrentTransparency +0.025
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
               cpxpCockpitSetup = false
               cpxpFoPreflight = true
               cpxpHorsePlayed = true
               CPXPCockpitSetup()
               CPXPShutDown()
            end
         end
         --This bit is the right button
         x1 = x2
         x2 = x1 + intButtonWidth
         y2 = y1 + intButtonHeight			
         if MOUSE_X >= x1 and MOUSE_X <= x2 and MOUSE_Y >= y1 and MOUSE_Y < y2 then
            print("Right Button")
            if cpxpBEACON == 0 and cpxpWEIGHT_ON_WHEELS == 1 then
               cpxpFoShutdownRun = true
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


end -- Master End
