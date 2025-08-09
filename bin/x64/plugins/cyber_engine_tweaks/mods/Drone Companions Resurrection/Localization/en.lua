-- Localization/en.lua
-- English strings for Drone Companions (Resurrection)

return {
  -- =========================
  -- Native Settings (UI-only)
  -- =========================
  ns = {
    tab_name = "Drones",

    subtabs = {
      stats        = "Stats",
      pricing      = "Pricing",
      misc         = "Miscellaneous",
      appearances  = "Appearances",
    },

    labels = {
      -- Sliders
      flying_hp   = "Flying Drone Health",
      android_hp  = "Android Health",
      mech_hp     = "Mech Health",

      flying_dps  = "Flying Drone Damage",
      android_dps = "Android Damage",
      mech_dps    = "Mech Damage",

      drone_core_price = "Drone Module", -- match in-game loc key 1882
      system_ex_slot   = "System-EX Slot",

      -- Toggles
      disable_android_voices = "Disable Android Voices",
      permanent_mechs        = "Permanent Mechs",

      -- Appearance selectors
      melee_android     = "Melee Android",
      ranged_android    = "Ranged Android",
      shotgunner        = "Shotgunner Android",
      netrunner         = "Netrunner Android",
      techie            = "Techie Android",
      sniper            = "Sniper Android",
      bombus            = "Bombus",
    },

    desc = {
      hp_mult    = "Set multiplier for Health.",
      dps_mult   = "Set multiplier for Damage.",
      price_desc = "Set cost of item.",

      disable_android_voices = "Toggle Android's combat chatter.",
      permanent_mechs        = "Disables Mech's health decay. Requires reloading a save.",

      select_appearance = "Select Drone's appearance.",

      system_ex_slot = "Select the slot the Techdecks go into when using the mod System-EX.",
      system_ex_slot1 = "Cyberdeck Slot",
      system_ex_slot2 = "OS Slot",
    },

    -- Appearance option lists (used by selectors)
    options = {
      android_app_list = {
        "Maelstrom 1","Maelstrom 2","Maelstrom 3","Maelstrom 4",
        "Wraiths 1","Wraiths 2","Wraiths 3","Wraiths 4","Wraiths 5",
        "Scavengers 1","Scavengers 2","Scavengers 3","Scavengers 4","Scavengers 5","Scavengers 6",
        "Sixth Street 1","Sixth Street 2","Sixth Street 3","Sixth Street 4","Sixth Street 5","Sixth Street 6",
        "Kerry 1","Kerry 2","Kerry 3","Kerry 4","Kerry 5",
        "Arasaka 1","NCPD 1","Militech 1","MaxTac 1","Kang Tao 1","KangTao 2",
        "Badlands 1","Badlands 2",
      },
      bombus_app_list = {
        "Police","Netwatch","Purple","White","Beam","Blue","Service","Delamain",
      },
    },
  },

  -- =========================
  -- Crafting / Items / Blueprints
  -- =========================
  crafting = {
    tab = "Drones",

    -- Core item
    drone_core_name = "Drone Module", -- match in-game loc key 1882
    drone_core_desc = "Essential piece of all drones' operating systems.",

    -- Optional fragments (kept for flexibility if you reintroduce them)
    fragments = {
      requires_techdeck = "Requires a TechDeck to craft.\n\n",
      mech_unstable     = "\n\nUnstable, decays Health over a 30 minute period.",
      techdeck_module_suffix = ": TechDeck Module",
      rare_slot_suffix       = "\n\nPlaced in the first TechDeck slot.",
      epic_slot_suffix       = "\n\nPlaced in the second TechDeck slot.",
      legendary_slot_suffix  = "\n\nPlaced in the third TechDeck slot.",
    },

    -- Base drones (names & descriptions)
    drones = {
      arasaka_octant_name = "Arasaka Octant Drone",
      arasaka_octant_desc = "Assemble an Octant Drone companion.\n\nShoots bursts of bullets at its target.\n\nTechHacks applied to this Drone will last 50% longer.\n\nTechHacks will increase this Drone's armor by 30%.",

      militech_octant_name = "Militech Octant Drone",
      militech_octant_desc = "Assemble an Octant Drone companion.\n\nShoots bursts of bullets at its target.\n\nBullets explode on impact.\n\nRegenerates 5% health over 3 seconds when struck.",

      bombus_name = "Bombus",
      bombus_desc = "Assemble a Bombus Drone companion. \n\nFires a laser at its target.\n\nWill run into a target and self-destruct on low health.",

      wyvern_name = "Wyvern",
      wyvern_desc = "Assemble a Wyvern Drone companion.\n\nShoots smart bullets at its target.\n\nBullets have a chance to disorient their target.",

      griffin_name = "Griffin",
      griffin_desc = "Assemble a Griffin Drone companion.\n\nShoots bursts of bullets at its target.\n\nTemporarily increases armor when hit.",
    },

    -- Mechs (permanent & unstable variants)
    mechs = {
      militech_mech_name = "Militech Mech",
      militech_mech_desc = "Assemble a Mech companion. \n\nShoots heavy smart bullets at its target.\n\nWill stomp nearby enemies.\n\nBullets explode on impact. \n\nWeakspots have 50% more Health.\n\nCannot heal.",
      militech_mech_desc_unstable = "Assemble a Mech companion. \n\nShoots heavy smart bullets at its target.\n\nWill stomp nearby enemies.\n\nBullets explode on impact. \n\nWeakspots have 50% more Health.\n\nCannot heal.\n\nUnstable, decays Health over a 30 minute period.",

      arasaka_mech_name = "Arasaka Mech",
      arasaka_mech_desc = "Assemble a Mech companion. \n\nShoots heavy smart bullets at its target.\n\nWill stomp nearby enemies.\n\nTechHacks applied to this Drone will last 50% longer. \n\nHighlights all Drones during combat, and enables for them to be TechHacked through walls.\n\nCannot heal.",
      arasaka_mech_desc_unstable = "Assemble a Mech companion. \n\nShoots heavy smart bullets at its target.\n\nWill stomp nearby enemies.\n\nTechHacks applied to this Drone will last 50% longer. \n\nHighlights all Drones during combat, and enables for them to be TechHacked through walls.\n\nCannot heal.\n\nUnstable, decays Health over a 30 minute period.",

      ncpd_mech_name = "NCPD Mech",
      ncpd_mech_desc = "Assemble a Mech companion. \n\nShoots heavy smart bullets at its target.\n\nWill stomp nearby enemies.\n\nLow quality, has reduced Health and Damage.\n\nCannot heal.",
      ncpd_mech_desc_unstable = "Assemble a Mech companion. \n\nShoots heavy smart bullets at its target.\n\nWill stomp nearby enemies.\n\nLow quality, has reduced Health and Damage.\n\nCannot heal.\n\nUnstable, decays Health over a 30 minute period.",
    },

    -- Androids
    androids = {
      ranged_name = "Ranged Android",
      ranged_desc = "Assemble a Ranged Android companion.\n\nUses an Assault Rifle.",

      melee_name = "Melee Android",
      melee_desc = "Assemble a Melee Android companion.\n\nUses a Melee Weapon.",

      shotgunner_name = "Shotgunner Android",
      shotgunner_desc = "Assemble a Shotgunner Android companion.\n\nUses a Shotgun.",

      netrunner_name = "Netrunner Android",
      netrunner_desc = "Assemble a Netrunner Android companion.\n\nUses a Handgun.\n\nWill upload various hacks onto enemies.",

      techie_name = "Techie Android",
      techie_desc = "Assemble a Techie Android companion.\n\nUses a Revolver.\n\nWill throw various grenades at enemies.",

      sniper_name = "Sniper Android",
      sniper_desc = "Assemble a Sniper Android companion.\n\nUses a Sniper Rifle.",
    },
  },

  -- =========================
  -- Spawn / Runtime messages
  -- =========================
  messages = {
    no_techdeck        = "NO TECHDECK INSTALLED.",
    combat_disabled    = "COMBAT IS DISABLED. MUST EXIT SAFE AREA.",
    mech_active        = "MECH ALREADY ACTIVE.",
    max_drones_active  = "MAXIMUM DRONES ACTIVE.",
    must_exit_vehicle  = "MUST EXIT VEHICLE FIRST.",
    v_busy             = "V IS BUSY.",
    must_exit_elevator = "MUST EXIT ELEVATOR FIRST.",
  },

  -- =========================
  -- Techdecks: restrictions, perks, decks, modules
  -- =========================
  techdecks = {
    restrictions = {
      mech_no_repair         = "Mechs cannot be healed with Repair.",
      shutdown_no_combat     = "Cannot be performed in combat.",
      kerenzikov_android_only= "Can only be used on Androids.",
    },

    perks = {
      one_drone   = "Allows control of 1 Drone.",
      two_drones  = "Allows control of 2 Drones.",
      three_drones= "Allows control of 3 Drones.",
      accuracy    = "Increases Drone accuracy by 30%.",
      armor       = "Increases Drone armor by 20%.",
      health      = "Increases Drone health by 20%.",

      flying_se        = "Drones heal 15% when killing a target.",
      flying_safe_expl = "Drones no longer die when using the Explode TechHack.",
      flying_explosion = "Explode increases Drone's damage by 10% for 15 seconds. Stacks up to 5 times.",

      mech_regen          = "Reduces TechHack cost by 50%.",
      techhack_cooldown   = "Reduces TechHack cooldowns by 50%.",
      overdrive_all       = "Overcharge applies to all Drones.",

      android_regen       = "Drones regenerate 1% of their Health per second in combat.",
      android_dilation    = "Drones gain Sandevistan abilities.",
      android_weapons     = "Drones can use high-tech weaponry.",
    },

    -- Deck stat blurbs (as shown in your strings)
    deck_stats = {
      nomad1  = "Allows control of 2 Drones.\nIncreases Drone health by 20%.\nIncreases Drone armor by 20%.",
      nomad2  = "Allows control of 2 Drones.\nIncreases Drone health by 20%.\nIncreases Drone armor by 20%.\nReduces TechHack cost by 50%.\nReduces TechHack cooldowns by 50%.",
      nomad3  = "Allows control of 3 Drones.\nIncreases Drone health by 20%.\nIncreases Drone armor by 20%.\nReduces TechHack cost by 50%.\nReduces TechHack cooldowns by 50%.\nOvercharge applies to all Drones.",

      corpo1  = "Allows control of 2 Drones.\nIncreases Drone accuracy by 30%.\nIncreases Drone armor by 20%.\nDrones regenerate 1% of their Health per second in combat.\nDrones gain Sandevistan abilities.",
      corpo2  = "Allows control of 3 Drones.\nIncreases Drone accuracy by 30%.\nIncreases Drone armor by 20%.\nDrones regenerate 1% of their Health per second in combat.\nDrones gain Sandevistan abilities.\nDrones can use high-tech weaponry.",

      street1 = "Allows control of 2 Drones.\nIncreases Drone health by 20%.\nIncreases Drone accuracy by 30%.",
      street2 = "Allows control of 2 Drones.\nIncreases Drone health by 20%.\nIncreases Drone accuracy by 30%.\nDrones heal 15% when killing a target.\nDrones no longer die when using the Explode TechHack.",
      street3 = "Allows control of 3 Drones.\nIncreases Drone health by 20%.\nIncreases Drone accuracy by 30%.\nDrones heal 15% when killing a target.\nDrones no longer die when using the Explode TechHack.\nExplode increases Drone's damage by 10% for 15 seconds. Stacks up to 5 times.",
    },

    deck_names = {
      nomad0   = "Meta Transporter Mk. I",
      nomad1   = "Meta Transporter Mk. I",
      nomad2   = "Meta Transporter Mk. II",
      nomad3   = "Meta Transporter Mk. III",

      street0  = "Mox Circuit Driver Mk. I",
      street1  = "Mox Circuit Driver Mk. I",
      street2  = "Mox Circuit Driver Mk. II",
      street3  = "Mox Circuit Driver Mk. III",

      corpo0        = "Kang Tao Neural Simulator Mk. I",
      corpo_rare    = "Kang Tao Neural Simulator Mk. I",
      corpo1        = "Kang Tao Neural Simulator Mk. I",
      corpo2        = "Kang Tao Neural Simulator Mk. II",
    },

    deck_desc = {
      nomad0 = "Every Nomad's gotta learn to take care of themselves, and their equipment.",
      nomad1 = "When Meta first declared independence, this, and the thousands of stolen repair drones, were all that kept their ships afloat.",
      nomad2 = "Upgraded TechDeck allowed for Meta drones allowed for new shipping routes through harsh sandstorms and hostile territory.",
      nomad3 = "The most modern Corporate-Nomad technology, ensuring that every delivery is made on time.",

      street0 = "Training deck used to ensure the Mox stays up to speed against their more chromed-out adversaries.",
      street1 = "Special modifications designed to emit explosive blasts without harming the integrity of the Drone ensure the Mox stay respected throughout NC.",
      street2 = "Just as the Mox feed on their prey, so do their Drones.",
      street3 = "Turning people into swiss cheese, setting them on fire, and blowing them up. In most places the Mox would be the bad guys, but not Night City.",

      corpo0 = "Simple model used by new Corpo recruits to have power over something, anything.",
      corpo1 = "Built to handle the startingly low supply of able-bodied individuals willing to die for the rich.",
      corpo2 = "Some of the most advanced algorithms known to the corporate world are packed into this deck. Any further, and it'd be inhumane to send drones into battle anymore.",
    },

    -- Module names & descriptions (with optional slot suffixes kept separate above)
    modules = {
      optics_enhancer_name = "Critical Targetting Software",
      optics_enhancer_desc = "All TechHacks increase Drone damage by 10%.",

      malfunction_coordinator_name = "Malfunction Coordinator",
      malfunction_coordinator_desc  = "Increases Drone explosion damage by 50%.",

      trigger_software_name = "Optics Enhancer",
      trigger_software_desc = "Unlocks the Optic Shock TechHack.\n\nMakes Drone perfectly accurate.",

      plate_energizer_name = "Plate Energizer",
      plate_energizer_desc = "Optical Camo regenerates 2% of Drone health per second.",

      extra_sensory_processor_name = "Extra-Sensory Processor",
      extra_sensory_processor_desc = "Unlocks the Kerenzikov TechHack.\n\nEnables all Androids to use Kerenzikov abilities.",

      insta_repair_unit_name = "Insta-Repair Unit",
      insta_repair_unit_desc = "Repairing Drones takes 50% less time.",

      mass_distortion_core_name = "Mass Distortion Core",
      mass_distortion_core_desc = "Optical Camo applies to all Drones.",

      circuit_charger_name = "Circuit Charger",
      circuit_charger_desc = "Unlocks Emergency Weapons System TechHack.\n\nOverloads all Drones' circuits, causing them to randomly emit explosions and apply Shock, Burn, or Poison on hit.",

      cpu_overloader_name = "CPU Overloader",
      cpu_overloader_desc = "Overcharge speeds up Drones 100% more.",
    },
  },
}
