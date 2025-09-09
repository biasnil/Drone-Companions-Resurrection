-- Localization/LanguageSystem.lua
-- Language management system for DCO

local LanguageSystem = {}

-- Default language (fallback)
local defaultLanguage = "en"
local currentLanguage = "en"

-- Language strings table
local languageStrings = {}

function LanguageSystem:LoadLanguage(language)
    currentLanguage = language or defaultLanguage
    
    -- Try to load the specific language file
    local languageFile = "Localization/" .. currentLanguage .. ".lua"
    
    -- Check if language file exists and load it
    local success, result = pcall(dofile, languageFile)
    
    if success and result then
        languageStrings = result
        print("DCO: Loaded language pack - " .. currentLanguage)
    else
        -- Fallback to English if the requested language fails
        if currentLanguage ~= defaultLanguage then
            print("DCO: Language pack " .. currentLanguage .. " not found, falling back to " .. defaultLanguage)
            currentLanguage = defaultLanguage
            local fallbackSuccess, fallbackResult = pcall(dofile, "Localization/" .. defaultLanguage .. ".lua")
            if fallbackSuccess and fallbackResult then
                languageStrings = fallbackResult
            else
                -- If even English fails, use hardcoded defaults
                print("DCO: Warning - Using hardcoded language strings")
                languageStrings = self:GetHardcodedStrings()
            end
        else
            languageStrings = self:GetHardcodedStrings()
        end
    end
    
    -- Set all the global variables
    self:SetLanguageVariables()
end

function LanguageSystem:SetLanguageVariables()
    -- NATIVE SETTINGS INTEGRATION
    Tab_Name = languageStrings.Tab_Name or "Drones"
    Subtab_1 = languageStrings.Subtab_1 or "Stats"
    Subtab_2 = languageStrings.Subtab_2 or "Pricing"
    Subtab_3 = languageStrings.Subtab_3 or "Miscellaneous"
    Subtab_4 = languageStrings.Subtab_4 or "Appearances"
    Subtab_5 = languageStrings.Subtab_5 or "Language"
    
    FlyingHP_String = languageStrings.FlyingHP_String or "Flying Drone Health"
    AndroidHP_String = languageStrings.AndroidHP_String or "Android Health"
    MechHP_String = languageStrings.MechHP_String or "Mech Health"
    
    FlyingDPS_String = languageStrings.FlyingDPS_String or "Flying Drone Damage"
    AndroidDPS_String = languageStrings.AndroidDPS_String or "Android Damage"
    MechDPS_String = languageStrings.MechDPS_String or "Mech Damage"
    
    HP_Desc = languageStrings.HP_Desc or "Set multiplier for Health."
    DPS_Desc = languageStrings.DPS_Desc or "Set multiplier for Damage."

    Drone_Core_Price_String = languageStrings.Drone_Core_Price_String or "Drone Module"
    Drone_Core_Price_Desc = languageStrings.Drone_Core_Price_Desc or "Set cost of item."
    
    Disable_Android_Voices_String = languageStrings.Disable_Android_Voices_String or "Disable Android Voices"
    Disable_Android_Voices_Description = languageStrings.Disable_Android_Voices_Description or "Toggle Android's combat chatter."
    
    Permanent_Mechs_String = languageStrings.Permanent_Mechs_String or "Permanent Mechs"
    Permanent_Mechs_Description = languageStrings.Permanent_Mechs_Description or "Disables Mech's health decay. Requires reloading a save."
    
    Language_String = languageStrings.Language_String or "Language"
    Language_Description = languageStrings.Language_Description or "Select mod language"
    
    -- Appearance strings
    MeleeAndroidAppearance_String = languageStrings.MeleeAndroidAppearance_String or "Melee Android"
    RangedAndroidAppearance_String = languageStrings.RangedAndroidAppearance_String or "Ranged Android"
    ShotgunnerAndroidAppearance_String = languageStrings.ShotgunnerAndroidAppearance_String or "Shotgunner Android"
    NetrunnerAndroidAppearance_String = languageStrings.NetrunnerAndroidAppearance_String or "Netrunner Android"
    TechieAndroidAppearance_String = languageStrings.TechieAndroidAppearance_String or "Techie Android"
    SniperAndroidAppearance_String = languageStrings.SniperAndroidAppearance_String or "Sniper Android"
    BombusAppearance_String = languageStrings.BombusAppearance_String or "Bombus"
    
    SelectAppearance_Description = languageStrings.SelectAppearance_Description or "Select Drone's appearance."
    
    -- Android appearance lists (translated)
    android_app_list = languageStrings.android_app_list or {
        "Maelstrom 1", "Maelstrom 2", "Maelstrom 3", "Maelstrom 4",
        "Wraiths 1", "Wraiths 2", "Wraiths 3", "Wraiths 4", "Wraiths 5",
        "Scavengers 1", "Scavengers 2", "Scavengers 3", "Scavengers 4", "Scavengers 5", "Scavengers 6",
        "Sixth Street 1", "Sixth Street 2", "Sixth Street 3", "Sixth Street 4", "Sixth Street 5", "Sixth Street 6",
        "Kerry 1", "Kerry 2", "Kerry 3", "Kerry 4", "Kerry 5",
        "Arasaka 1", "NCPD 1", "Militech 1", "MaxTac 1", "Kang Tao 1", "KangTao 2",
        "Badlands 1", "Badlands 2"
    }
    
    bombus_app_list = languageStrings.bombus_app_list or {
        "Police", "Netwatch", "Purple", "White", "Beam", "Blue", "Service", "Delamain"
    }
    
    -- BASE DRONES
    Drone_Core_String = languageStrings.Drone_Core_String or "Drone Module"
    Drone_Core_Desc = languageStrings.Drone_Core_Desc or "Essential piece of all drones' operating systems."
    
    RequiresTechDeck_String = languageStrings.RequiresTechDeck_String or ""
    
    Arasaka_Octant_String = languageStrings.Arasaka_Octant_String or "Arasaka Octant Drone"
    Arasaka_Octant_Desc = languageStrings.Arasaka_Octant_Desc or "Assemble an Octant Drone companion."
    
    Militech_Octant_String = languageStrings.Militech_Octant_String or "Militech Octant Drone"
    Militech_Octant_Desc = languageStrings.Militech_Octant_Desc or "Assemble an Octant Drone companion."
    
    Bombus_Desc = languageStrings.Bombus_Desc or "Assemble a Bombus Drone companion."
    Wyvern_Desc = languageStrings.Wyvern_Desc or "Assemble a Wyvern Drone companion."
    Griffin_Desc = languageStrings.Griffin_Desc or "Assemble a Griffin Drone companion."
    
    Mech_Unstable_String = languageStrings.Mech_Unstable_String or ""
    
    Militech_Mech_Desc = languageStrings.Militech_Mech_Desc or "Assemble a Mech companion."
    Militech_Mech_Permanent_Desc = languageStrings.Militech_Mech_Permanent_Desc or "Assemble a Mech companion."

    Arasaka_Mech_Desc = languageStrings.Arasaka_Mech_Desc or "Assemble a Mech companion."
    Arasaka_Mech_Permanent_Desc = languageStrings.Arasaka_Mech_Permanent_Desc or "Assemble a Mech companion."

    NCPD_Mech_Desc = languageStrings.NCPD_Mech_Desc or "Assemble a Mech companion."
    NCPD_Mech_Permanent_Desc = languageStrings.NCPD_Mech_Permanent_Desc or "Assemble a Mech companion."

    NCPD_Mech_String = languageStrings.NCPD_Mech_String or "NCPD Mech"
    
    Android_Ranged_Desc = languageStrings.Android_Ranged_Desc or "Assemble a Ranged Android companion."
    Android_Ranged_String = languageStrings.Android_Ranged_String or "Ranged Android"

    Android_Melee_Desc = languageStrings.Android_Melee_Desc or "Assemble a Melee Android companion."
    Android_Melee_String = languageStrings.Android_Melee_String or "Melee Android"

    Android_Shotgunner_Desc = languageStrings.Android_Shotgunner_Desc or "Assemble a Shotgunner Android companion."
    Android_Shotgunner_String = languageStrings.Android_Shotgunner_String or "Shotgunner Android"

    Android_Netrunner_Desc = languageStrings.Android_Netrunner_Desc or "Assemble a Netrunner Android companion."
    Android_Netrunner_String = languageStrings.Android_Netrunner_String or "Netrunner Android"

    Android_Techie_Desc = languageStrings.Android_Techie_Desc or "Assemble a Techie Android companion."
    Android_Techie_String = languageStrings.Android_Techie_String or "Techie Android"

    Android_Sniper_Desc = languageStrings.Android_Sniper_Desc or "Assemble a Sniper Android companion."
    Android_Sniper_String = languageStrings.Android_Sniper_String or "Sniper Android"
    
    -- DRONE SPAWNING
    Crafting_Tab_String = languageStrings.Crafting_Tab_String or "Drones"
    
    No_TechDeck_String = languageStrings.No_TechDeck_String or "NO TECHDECK INSTALLED."
    Combat_Disabled_String = languageStrings.Combat_Disabled_String or "COMBAT IS DISABLED. MUST EXIT SAFE AREA."
    Mech_Active_String = languageStrings.Mech_Active_String or "MECH ALREADY ACTIVE."
    Maximum_Drones_String = languageStrings.Maximum_Drones_String or "MAXIMUM DRONES ACTIVE."
    Exit_Vehicle_String = languageStrings.Exit_Vehicle_String or "MUST EXIT VEHICLE FIRST."
    V_Busy_String = languageStrings.V_Busy_String or "V IS BUSY."
    Exit_Elevator_String = languageStrings.Exit_Elevator_String or "MUST EXIT ELEVATOR FIRST."
    
    -- TECHDECKS
    Mech_No_Repair_String = languageStrings.Mech_No_Repair_String or "Mechs cannot be healed with Repair."
    Shutdown_No_Combat_String = languageStrings.Shutdown_No_Combat_String or "Cannot be performed in combat."
    Kerenzikov_Not_Android_String = languageStrings.Kerenzikov_Not_Android_String or "Can only be used on Androids."
    
    One_Drone_String = languageStrings.One_Drone_String or "Allows control of 1 Drone."
    Two_Drones_String = languageStrings.Two_Drones_String or "Allows control of 2 Drones."
    Three_Drones_String = languageStrings.Three_Drones_String or "Allows control of 3 Drones."
    Accuracy_String = languageStrings.Accuracy_String or "Increases Drone accuracy by 30%."
    Armor_String = languageStrings.Armor_String or "Increases Drone armor by 20%."
    Health_String = languageStrings.Health_String or "Increases Drone health by 20%."
    
    FlyingSE_String = languageStrings.FlyingSE_String or "Drones heal 15% when killing a target."
    FlyingCheap_String = languageStrings.FlyingCheap_String or "Drones no longer die when using the Explode TechHack."
    FlyingExplosion_String = languageStrings.FlyingExplosion_String or "Explode increases Drone's damage by 10% for 15 seconds. Stacks up to 5 times."
    
    MechRegen_String = languageStrings.MechRegen_String or "Reduces TechHack cost by 50%."
    TechHackCooldown_String = languageStrings.TechHackCooldown_String or "Reduces TechHack cooldowns by 50%."
    OverdriveAll_String = languageStrings.OverdriveAll_String or "Overcharge applies to all Drones."

    AndroidRegen_String = languageStrings.AndroidRegen_String or "Drones regenerate 1% of their Health per second in combat."
    AndroidDilation_String = languageStrings.AndroidDilation_String or "Drones gain Sandevistan abilities."
    AndroidWeapons_String = languageStrings.AndroidWeapons_String or "Drones can use high-tech weaponry."

    -- TechDeck stats combinations
    Nomad1Stats_String = languageStrings.Nomad1Stats_String or (Two_Drones_String.."\n"..Health_String.."\n"..Armor_String)
    Nomad2Stats_String = languageStrings.Nomad2Stats_String or (Two_Drones_String.."\n"..Health_String.."\n"..Armor_String.."\n"..MechRegen_String.."\n"..TechHackCooldown_String)
    Nomad3Stats_String = languageStrings.Nomad3Stats_String or (Three_Drones_String.."\n"..Health_String.."\n"..Armor_String.."\n"..MechRegen_String.."\n"..TechHackCooldown_String.."\n"..OverdriveAll_String)

    Corpo1Stats_String = languageStrings.Corpo1Stats_String or (Two_Drones_String.."\n"..Accuracy_String.."\n"..Armor_String.."\n"..AndroidRegen_String.."\n"..AndroidDilation_String)
    Corpo2Stats_String = languageStrings.Corpo2Stats_String or (Three_Drones_String.."\n"..Accuracy_String.."\n"..Armor_String.."\n"..AndroidRegen_String.."\n"..AndroidDilation_String.."\n"..AndroidWeapons_String)

    Street1Stats_String = languageStrings.Street1Stats_String or (Two_Drones_String.."\n"..Health_String.."\n"..Accuracy_String)
    Street2Stats_String = languageStrings.Street2Stats_String or (Two_Drones_String.."\n"..Health_String.."\n"..Accuracy_String.."\n"..FlyingSE_String.."\n"..FlyingCheap_String)
    Street3Stats_String = languageStrings.Street3Stats_String or (Three_Drones_String.."\n"..Health_String.."\n"..Accuracy_String.."\n"..FlyingSE_String.."\n"..FlyingCheap_String.."\n"..FlyingExplosion_String)

    -- TechDeck Names
    Nomad0_Name = languageStrings.Nomad0_Name or "Meta Transporter Mk. I"
    Nomad1_Name = languageStrings.Nomad1_Name or "Meta Transporter Mk. I"
    Nomad2_Name = languageStrings.Nomad2_Name or "Meta Transporter Mk. II"
    Nomad3_Name = languageStrings.Nomad3_Name or "Meta Transporter Mk. III"

    Street0_Name = languageStrings.Street0_Name or "Mox Circuit Driver Mk. I"
    Street1_Name = languageStrings.Street1_Name or "Mox Circuit Driver Mk. I"
    Street2_Name = languageStrings.Street2_Name or "Mox Circuit Driver Mk. II"
    Street3_Name = languageStrings.Street3_Name or "Mox Circuit Driver Mk. III"

    Corpo0_Name = languageStrings.Corpo0_Name or "Kang Tao Neural Simulator Mk. I"
    CorpoRare_Name = languageStrings.CorpoRare_Name or "Kang Tao Neural Simulator Mk. I"
    Corpo1_Name = languageStrings.Corpo1_Name or "Kang Tao Neural Simulator Mk. I"
    Corpo2_Name = languageStrings.Corpo2_Name or "Kang Tao Neural Simulator Mk. II"

    -- TechDeck Descriptions
    Nomad0_Desc = languageStrings.Nomad0_Desc or "Every Nomad's gotta learn to take care of themselves, and their equipment."
    Nomad1_Desc = languageStrings.Nomad1_Desc or "When Meta first declared independence, this, and the thousands of stolen repair drones, were all that kept their ships afloat."
    Nomad2_Desc = languageStrings.Nomad2_Desc or "Upgraded TechDeck allowed for Meta drones allowed for new shipping routes through harsh sandstorms and hostile territory."
    Nomad3_Desc = languageStrings.Nomad3_Desc or "The most modern Corporate-Nomad technology, ensuring that every delivery is made on time."

    Street0_Desc = languageStrings.Street0_Desc or "Training deck used to ensure the Mox stays up to speed against their more chromed-out adversaries."
    Street1_Desc = languageStrings.Street1_Desc or "Special modifications designed to emit explosive blasts without harming the integrity of the Drone ensure the Mox stay respected throughout NC."
    Street2_Desc = languageStrings.Street2_Desc or "Just as the Mox feed on their prey, so do their Drones."
    Street3_Desc = languageStrings.Street3_Desc or "Turning people into swiss cheese, setting them on fire, and blowing them up. In most places the Mox would be the bad guys, but not Night City."
    
    Corpo0_Desc = languageStrings.Corpo0_Desc or "Simple model used by new Corpo recruits to have power over something, anything."
    Corpo1_Desc = languageStrings.Corpo1_Desc or "Built to handle the startingly low supply of able-bodied individuals willing to die for the rich."
    Corpo2_Desc = languageStrings.Corpo2_Desc or "Some of the most advanced algorithms known to the corporate world are packed into this deck. Any further, and it'd be inhumane to send drones into battle anymore."

    -- TechDeck Modules
    TechDeck_Module_String = languageStrings.TechDeck_Module_String or ""
    
    Rare_Module_String = languageStrings.Rare_Module_String or ""
    Epic_Module_String = languageStrings.Epic_Module_String or ""
    Legendary_Module_String = languageStrings.Legendary_Module_String or ""
    
    Optics_Enhancer_String = languageStrings.Optics_Enhancer_String or "Critical Targetting Software"
    Optics_Enhancer_Desc = languageStrings.Optics_Enhancer_Desc or "All TechHacks increase Drone damage by 10%."
    
    Malfunction_Coordinator_String = languageStrings.Malfunction_Coordinator_String or "Malfunction Coordinator"
    Malfunction_Coordinator_Desc = languageStrings.Malfunction_Coordinator_Desc or "Increases Drone explosion damage by 50%."
    
    Trigger_Software_String = languageStrings.Trigger_Software_String or "Optics Enhancer"
    Trigger_Software_Desc = languageStrings.Trigger_Software_Desc or "Unlocks the Optic Shock TechHack. Makes Drone perfectly accurate."
    
    Plate_Energizer_String = languageStrings.Plate_Energizer_String or "Plate Energizer"
    Plate_Energizer_Desc = languageStrings.Plate_Energizer_Desc or "Optical Camo regenerates 2% of Drone health per second."
    
    Extra_Sensory_Processor_String = languageStrings.Extra_Sensory_Processor_String or "Extra-Sensory Processor"
    Extra_Sensory_Processor_Desc = languageStrings.Extra_Sensory_Processor_Desc or "Unlocks the Kerenzikov TechHack. Enables all Androids to use Kerenzikov abilities."
    
    Insta_Repair_Unit_String = languageStrings.Insta_Repair_Unit_String or "Insta-Repair Unit"
    Insta_Repair_Unit_Desc = languageStrings.Insta_Repair_Unit_Desc or "Repairing Drones takes 50% less time."
    
    Mass_Distortion_Core_String = languageStrings.Mass_Distortion_Core_String or "Mass Distortion Core"
    Mass_Distortion_Core_Desc = languageStrings.Mass_Distortion_Core_Desc or "Optical Camo applies to all Drones."
    
    Circuit_Charger_String = languageStrings.Circuit_Charger_String or "Circuit Charger"
    Circuit_Charger_Desc = languageStrings.Circuit_Charger_Desc or "Unlocks Emergency Weapons System TechHack. Overloads all Drones' circuits, causing them to randomly emit explosions and apply Shock, Burn, or Poison on hit."
    
    CPU_Overloader_String = languageStrings.CPU_Overloader_String or "CPU Overloader"
    CPU_Overloader_Desc = languageStrings.CPU_Overloader_Desc or "Overcharge speeds up Drones 100% more."
end

function LanguageSystem:GetHardcodedStrings()
    -- Return hardcoded English strings as absolute fallback
    return {
        Tab_Name = "Drones",
        Subtab_1 = "Stats",
        Subtab_2 = "Pricing",
        Subtab_3 = "Miscellaneous",
        Subtab_4 = "Appearances",
        Subtab_5 = "Language",
        Language_String = "Language",
        Language_Description = "Select mod language",
        FlyingHP_String = "Flying Drone Health",
        AndroidHP_String = "Android Health",
        MechHP_String = "Mech Health",
        FlyingDPS_String = "Flying Drone Damage",
        AndroidDPS_String = "Android Damage",
        MechDPS_String = "Mech Damage",
        HP_Desc = "Set multiplier for Health.",
        DPS_Desc = "Set multiplier for Damage.",
        Drone_Core_String = "Drone Module",
        Drone_Core_Desc = "Essential piece of all drones' operating systems."
    }
end

function LanguageSystem:GetCurrentLanguage()
    return currentLanguage
end

function LanguageSystem:GetAvailableLanguages()
    -- Return list of available languages
    return {
        {code = "en", name = "English"},
        {code = "fr", name = "Français"},
        {code = "de", name = "Deutsch"},
        {code = "es", name = "Español"},
        {code = "it", name = "Italiano"},
        {code = "pt", name = "Português"},
        {code = "ru", name = "Русский"},
        {code = "ja", name = "日本語"},
        {code = "ko", name = "한국어"},
        {code = "zh", name = "中文"}
    }
end

function LanguageSystem:ReloadLanguage(newLanguage)
    self:LoadLanguage(newLanguage)
end

return LanguageSystem