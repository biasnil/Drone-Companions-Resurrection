return {
    -- NATIVE SETTINGS INTEGRATION
    Tab_Name = "Drones",
    Subtab_1 = "Statistiques",
    Subtab_2 = "Prix",
    Subtab_3 = "Divers",
    Subtab_4 = "Apparences",
    Subtab_5 = "Langue",
    
    -- Stats
    FlyingHP_String = "Santé des Drones Volants",
    AndroidHP_String = "Santé des Androïdes",
    MechHP_String = "Santé des Mechs",
    
    FlyingDPS_String = "Dégâts des Drones Volants",
    AndroidDPS_String = "Dégâts des Androïdes",
    MechDPS_String = "Dégâts des Mechs",
    
    HP_Desc = "Définir le multiplicateur de santé.",
    DPS_Desc = "Définir le multiplicateur de dégâts.",

    -- Pricing
    Drone_Core_Price_String = "Module de Drone",
    Drone_Core_Price_Desc = "Définir le coût de l'objet.",
    
    -- Miscellaneous
    Disable_Android_Voices_String = "Désactiver les Voix d'Androïdes",
    Disable_Android_Voices_Description = "Active/désactive les bavardages de combat des androïdes.",
    
    Permanent_Mechs_String = "Mechs Permanents",
    Permanent_Mechs_Description = "Désactive la dégradation de santé des Mechs. Nécessite de recharger une sauvegarde.",
    
    -- Language
    Language_String = "Langue",
    Language_Description = "Sélectionner la langue du mod",
    
    -- Appearances
    MeleeAndroidAppearance_String = "Androïde de Mêlée",
    RangedAndroidAppearance_String = "Androïde à Distance",
    ShotgunnerAndroidAppearance_String = "Androïde Fusil à Pompe",
    NetrunnerAndroidAppearance_String = "Androïde Netrunner",
    TechieAndroidAppearance_String = "Androïde Technicien",
    SniperAndroidAppearance_String = "Androïde Sniper",
    BombusAppearance_String = "Bombus",
    
    SelectAppearance_Description = "Sélectionner l'apparence du drone.",
    
    -- Appearance lists (keeping English names for faction references)
    android_app_list = {
        "Maelstrom 1", "Maelstrom 2", "Maelstrom 3", "Maelstrom 4",
        "Nomades 1", "Nomades 2", "Nomades 3", "Nomades 4", "Nomades 5",
        "Charognards 1", "Charognards 2", "Charognards 3", "Charognards 4", "Charognards 5", "Charognards 6",
        "Sixth Street 1", "Sixth Street 2", "Sixth Street 3", "Sixth Street 4", "Sixth Street 5", "Sixth Street 6",
        "Kerry 1", "Kerry 2", "Kerry 3", "Kerry 4", "Kerry 5",
        "Arasaka 1", "NCPD 1", "Militech 1", "MaxTac 1", "Kang Tao 1", "KangTao 2",
        "Badlands 1", "Badlands 2"
    },
    
    bombus_app_list = {
        "Police", "Netwatch", "Violet", "Blanc", "Faisceau", "Bleu", "Service", "Delamain"
    },
    
    -- BASE DRONES
    Drone_Core_String = "Module de Drone",
    Drone_Core_Desc = "Pièce essentielle du système d'exploitation de tous les drones.",
    
    RequiresTechDeck_String = "",
    
    Arasaka_Octant_String = "Drone Octant Arasaka",
    Arasaka_Octant_Desc = "Assembler un compagnon Drone Octant.\\n\\nTire des rafales de balles sur sa cible.\\n\\nLes TechHacks appliqués à ce Drone durent 50% plus longtemps.\\n\\nLes TechHacks augmentent l'armure de ce Drone de 30%.",
    
    Militech_Octant_String = "Drone Octant Militech",
    Militech_Octant_Desc = "Assembler un compagnon Drone Octant.\\n\\nTire des rafales de balles sur sa cible.\\n\\nLes balles explosent à l'impact.\\n\\nRégénère 5% de santé sur 3 secondes quand touché.",
    
    Bombus_Desc = "Assembler un compagnon Drone Bombus.\\n\\nTire un laser sur sa cible.\\n\\nFoncera vers une cible et s'autodétruira à faible santé.",
    
    Wyvern_Desc = "Assembler un compagnon Drone Wyvern.\\n\\nTire des balles intelligentes sur sa cible.\\n\\nLes balles ont une chance de désorienter leur cible.",
    
    Griffin_Desc = "Assembler un compagnon Drone Griffin.\\n\\nTire des rafales de balles sur sa cible.\\n\\nAugmente temporairement l'armure quand touché.",
    
    Mech_Unstable_String = "\\n\\nInstable, perd de la santé sur une période de 30 minutes.",
    
    Militech_Mech_Desc = "Assembler un compagnon Mech.\\n\\nTire des balles intelligentes lourdes sur sa cible.\\n\\nPiétine les ennemis proches.\\n\\nLes balles explosent à l'impact.\\n\\nLes points faibles ont 50% de santé en plus.\\n\\nNe peut pas se soigner.",
    Militech_Mech_Permanent_Desc = "Assembler un compagnon Mech.\\n\\nTire des balles intelligentes lourdes sur sa cible.\\n\\nPiétine les ennemis proches.\\n\\nLes balles explosent à l'impact.\\n\\nLes points faibles ont 50% de santé en plus.\\n\\nNe peut pas se soigner.",

    Arasaka_Mech_Desc = "Assembler un compagnon Mech.\\n\\nTire des balles intelligentes lourdes sur sa cible.\\n\\nPiétine les ennemis proches.\\n\\nLes TechHacks appliqués à ce Drone durent 50% plus longtemps.\\n\\nSurligne tous les Drones pendant le combat et permet de les TechHacker à travers les murs.\\n\\nNe peut pas se soigner.",
    Arasaka_Mech_Permanent_Desc = "Assembler un compagnon Mech.\\n\\nTire des balles intelligentes lourdes sur sa cible.\\n\\nPiétine les ennemis proches.\\n\\nLes TechHacks appliqués à ce Drone durent 50% plus longtemps.\\n\\nSurligne tous les Drones pendant le combat et permet de les TechHacker à travers les murs.\\n\\nNe peut pas se soigner.",

    NCPD_Mech_Desc = "Assembler un compagnon Mech.\\n\\nTire des balles intelligentes lourdes sur sa cible.\\n\\nPiétine les ennemis proches.\\n\\nQualité faible, santé et dégâts réduits.\\n\\nNe peut pas se soigner.",
    NCPD_Mech_Permanent_Desc = "Assembler un compagnon Mech.\\n\\nTire des balles intelligentes lourdes sur sa cible.\\n\\nPiétine les ennemis proches.\\n\\nQualité faible, santé et dégâts réduits.\\n\\nNe peut pas se soigner.",

    NCPD_Mech_String = "Mech NCPD",
    
    Android_Ranged_Desc = "Assembler un compagnon Androïde à Distance.\\n\\nUtilise un Fusil d'Assaut.",
    Android_Ranged_String = "Androïde à Distance",

    Android_Melee_Desc = "Assembler un compagnon Androïde de Mêlée.\\n\\nUtilise une Arme de Mêlée.",
    Android_Melee_String = "Androïde de Mêlée",

    Android_Shotgunner_Desc = "Assembler un compagnon Androïde Fusil à Pompe.\\n\\nUtilise un Fusil à Pompe.",
    Android_Shotgunner_String = "Androïde Fusil à Pompe",

    Android_Netrunner_Desc = "Assembler un compagnon Androïde Netrunner.\\n\\nUtilise un Pistolet.\\n\\nTélécharge divers hacks sur les ennemis.",
    Android_Netrunner_String = "Androïde Netrunner",

    Android_Techie_Desc = "Assembler un compagnon Androïde Technicien.\\n\\nUtilise un Revolver.\\n\\nLance diverses grenades sur les ennemis.",
    Android_Techie_String = "Androïde Technicien",

    Android_Sniper_Desc = "Assembler un compagnon Androïde Sniper.\\n\\nUtilise un Fusil de Sniper.",
    Android_Sniper_String = "Androïde Sniper",
    
    -- DRONE SPAWNING
    Crafting_Tab_String = "Drones",
    
    No_TechDeck_String = "AUCUN TECHDECK INSTALLÉ.",
    Combat_Disabled_String = "LE COMBAT EST DÉSACTIVÉ. DOIT QUITTER LA ZONE SÛRE.",
    Mech_Active_String = "MECH DÉJÀ ACTIF.",
    Maximum_Drones_String = "NOMBRE MAXIMUM DE DRONES ACTIFS.",
    Exit_Vehicle_String = "DOIT D'ABORD SORTIR DU VÉHICULE.",
    V_Busy_String = "V EST OCCUPÉ.",
    Exit_Elevator_String = "DOIT D'ABORD SORTIR DE L'ASCENSEUR.",
    
    -- TECHDECKS
    Mech_No_Repair_String = "Les Mechs ne peuvent pas être soignés avec Réparation.",
    Shutdown_No_Combat_String = "Ne peut pas être effectué en combat.",
    Kerenzikov_Not_Android_String = "Ne peut être utilisé que sur les Androïdes.",
    
    One_Drone_String = "Permet le contrôle d'1 Drone.",
    Two_Drones_String = "Permet le contrôle de 2 Drones.",
    Three_Drones_String = "Permet le contrôle de 3 Drones.",
    Accuracy_String = "Augmente la précision des Drones de 30%.",
    Armor_String = "Augmente l'armure des Drones de 20%.",
    Health_String = "Augmente la santé des Drones de 20%.",
    
    FlyingSE_String = "Les Drones soignent 15% en tuant une cible.",
    FlyingCheap_String = "Les Drones ne meurent plus en utilisant le TechHack Exploser.",
    FlyingExplosion_String = "Exploser augmente les dégâts du Drone de 10% pendant 15 secondes. Cumule jusqu'à 5 fois.",
    
    MechRegen_String = "Réduit le coût des TechHacks de 50%.",
    TechHackCooldown_String = "Réduit les temps de recharge des TechHacks de 50%.",
    OverdriveAll_String = "Surcharge s'applique à tous les Drones.",

    AndroidRegen_String = "Les Drones régénèrent 1% de leur Santé par seconde en combat.",
    AndroidDilation_String = "Les Drones gagnent des capacités Sandevistan.",
    AndroidWeapons_String = "Les Drones peuvent utiliser des armes high-tech.",

    -- TechDeck Names and Descriptions
    Nomad0_Name = "Meta Transporteur Mk. I",
    Nomad1_Name = "Meta Transporteur Mk. I",
    Nomad2_Name = "Meta Transporteur Mk. II",
    Nomad3_Name = "Meta Transporteur Mk. III",

    Street0_Name = "Circuit Driver Mox Mk. I",
    Street1_Name = "Circuit Driver Mox Mk. I",
    Street2_Name = "Circuit Driver Mox Mk. II",
    Street3_Name = "Circuit Driver Mox Mk. III",

    Corpo0_Name = "Simulateur Neural Kang Tao Mk. I",
    CorpoRare_Name = "Simulateur Neural Kang Tao Mk. I",
    Corpo1_Name = "Simulateur Neural Kang Tao Mk. I",
    Corpo2_Name = "Simulateur Neural Kang Tao Mk. II",

    Nomad0_Desc = "Chaque Nomade doit apprendre à prendre soin de lui-même et de son équipement.",
    Nomad1_Desc = "Quand Meta a déclaré son indépendance pour la première fois, ceci et les milliers de drones de réparation volés étaient tout ce qui maintenait leurs vaisseaux à flot.",
    Nomad2_Desc = "Le TechDeck amélioré a permis aux drones Meta d'ouvrir de nouvelles routes commerciales à travers des tempêtes de sable et des territoires hostiles.",
    Nomad3_Desc = "La technologie Corporative-Nomade la plus moderne, garantissant que chaque livraison est effectuée à temps.",

    Street0_Desc = "Deck d'entraînement utilisé pour s'assurer que les Mox restent à jour contre leurs adversaires plus chromés.",
    Street1_Desc = "Modifications spéciales conçues pour émettre des explosions sans nuire à l'intégrité du Drone, garantissant que les Mox restent respectés dans Night City.",
    Street2_Desc = "Tout comme les Mox se nourrissent de leurs proies, leurs Drones aussi.",
    Street3_Desc = "Transformer les gens en gruyère, les mettre en feu et les faire exploser. Dans la plupart des endroits, les Mox seraient les méchants, mais pas à Night City.",
    
    Corpo0_Desc = "Modèle simple utilisé par les nouvelles recrues Corpo pour avoir du pouvoir sur quelque chose, n'importe quoi.",
    Corpo1_Desc = "Construit pour gérer le nombre étonnamment faible d'individus valides prêts à mourir pour les riches.",
    Corpo2_Desc = "Certains des algorithmes les plus avancés connus du monde corporatif sont intégrés dans ce deck. Aller plus loin serait inhumain d'envoyer des drones au combat.",

    TechDeck_Module_String = "",
    
    Rare_Module_String = "",
    Epic_Module_String = "",
    Legendary_Module_String = "",
    
    Optics_Enhancer_String = "Logiciel de Ciblage Critique",
    Optics_Enhancer_Desc = "Tous les TechHacks augmentent les dégâts des Drones de 10%.",
    
    Malfunction_Coordinator_String = "Coordinateur de Dysfonctionnement",
    Malfunction_Coordinator_Desc = "Augmente les dégâts d'explosion des Drones de 50%.",
    
    Trigger_Software_String = "Améliorateur d'Optiques",
    Trigger_Software_Desc = "Débloque le TechHack Choc Optique.\\n\\nRend le Drone parfaitement précis.",
    
    Plate_Energizer_String = "Énergiseur de Plaque",
    Plate_Energizer_Desc = "Le Camo Optique régénère 2% de la santé du Drone par seconde.",
    
    Extra_Sensory_Processor_String = "Processeur Extra-Sensoriel",
    Extra_Sensory_Processor_Desc = "Débloque le TechHack Kerenzikov.\\n\\nPermet à tous les Androïdes d'utiliser les capacités Kerenzikov.",
    
    Insta_Repair_Unit_String = "Unité de Réparation Instantanée",
    Insta_Repair_Unit_Desc = "Réparer les Drones prend 50% moins de temps.",
    
    Mass_Distortion_Core_String = "Noyau de Distorsion Massive",
    Mass_Distortion_Core_Desc = "Le Camo Optique s'applique à tous les Drones.",
    
    Circuit_Charger_String = "Chargeur de Circuit",
    Circuit_Charger_Desc = "Débloque le TechHack Système d'Armes d'Urgence.\\n\\nSurcharge les circuits de tous les Drones, les faisant émettre aléatoirement des explosions et appliquer Choc, Brûlure ou Poison en frappant.",
    
    CPU_Overloader_String = "Surcharge CPU",
    CPU_Overloader_Desc = "La Surcharge accélère les Drones 100% de plus."
}