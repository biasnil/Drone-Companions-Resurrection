return {
	Tab_Name = "Drones",
	Subtab_1 = "Langue",
	Subtab_2 = "Statistiques",
	Subtab_3 = "Prix",
	Subtab_4 = "Divers",
	Subtab_5 = "Apparences",
	
	FlyingHP_String = "Santé des Drones Volants",
	AndroidHP_String = "Santé des Androïdes",
	MechHP_String = "Santé des Mechs",
	
	FlyingDPS_String = "Dégâts des Drones Volants",
	AndroidDPS_String = "Dégâts des Androïdes",
	MechDPS_String = "Dégâts des Mechs",
	
	HP_Desc = "Définir le multiplicateur de santé.",
	DPS_Desc = "Définir le multiplicateur de dégâts.",

	Drone_Core_Price_String = "Module de Drone",
	Drone_Core_Price_Desc = "Définir le coût de l'objet.",
	
	Disable_Android_Voices_String = "Désactiver les Voix d'Androïdes",
	Disable_Android_Voices_Description = "Activer/désactiver les dialogues de combat des Androïdes.",
	
	Permanent_Mechs_String = "Mechs Permanents",
	Permanent_Mechs_Description = "Désactive la dégradation de santé des Mechs. Rechargement d'une sauvegarde requis.",
	
	MeleeAndroidAppearance_String = "Androïde de Mêlée",
	RangedAndroidAppearance_String = "Androïde à Distance",
	ShotgunnerAndroidAppearance_String = "Androïde Fusil à Pompe",
	NetrunnerAndroidAppearance_String = "Androïde Netrunner",
	TechieAndroidAppearance_String = "Androïde Technicien",
	SniperAndroidAppearance_String = "Androïde Sniper",

	BombusAppearance_String = "Bombus",
	
	android_app_list = 
	{[1] = "Maelstrom 1",
	[2] = "Maelstrom 2",
	[3] = "Maelstrom 3",
	[4] = "Maelstrom 4",
	[5] = "Wraiths 1",
	[6] = "Wraiths 2",
	[7] = "Wraiths 3",
	[8] = "Wraiths 4",
	[9] = "Wraiths 5",
	[10] = "Scavengers 1",
	[11] = "Scavengers 2",
	[12] = "Scavengers 3",
	[13] = "Scavengers 4",
	[14] = "Scavengers 5",
	[15] = "Scavengers 6",
	[16] = "Sixth Street 1",
	[17] = "Sixth Street 2",
	[18] = "Sixth Street 3",
	[19] = "Sixth Street 4",
	[20] = "Sixth Street 5",
	[21] = "Sixth Street 6",
	[22] = "Kerry 1",
	[23] = "Kerry 2",
	[24] = "Kerry 3",
	[25] = "Kerry 4",
	[26] = "Kerry 5",
	[27] = "Arasaka 1",
	[28] = "NCPD 1",
	[29] = "Militech 1",
	[30] = "MaxTac 1",
	[31] = "Kang Tao 1",
	[32] = "KangTao 2",
	[33] = "Badlands 1",
	[34] = "Badlands 2"},
	
	bombus_app_list = 
	{[1] = "Police",
	[2] = "Netwatch",
	[3] = "Purple",
	[4] = "White",
	[5] = "Beam",
	[6] = "Blue",
	[7] = "Service",
	[8] = "Delamain"},
	
	SelectAppearance_Description = "Sélectionner l'apparence du Drone.",

	
	SystemExSlot_String = "Emplacement System-EX",
	SystemExSlot_Description = "Sélectionner l'emplacement des Techdecks lors de l'utilisation du mod System-EX.",
	SystemExSlot1 = "Emplacement Cyberdeck",
	SystemExSlot2 = "Emplacement OS",
	
	Drone_Core_String = "Module de Drone",
	Drone_Core_Desc = "Pièce essentielle du système d'exploitation de tous les Drones.",
	
	RequiresTechDeck_String = "",
	
	Arasaka_Octant_String = "Drone Octant Arasaka",
	Arasaka_Octant_Desc = "Assembler un compagnon Drone Octant.\\n\\n"..RequiresTechDeck_String.."Tire des rafales sur sa cible.\\n\\nLes TechHacks appliqués à ce Drone durent 50% plus longtemps.\\n\\nLes TechHacks augmentent l'armure de ce Drone de 30%.",
	
	Militech_Octant_String = "Drone Octant Militech",
	Militech_Octant_Desc = "Assembler un compagnon Drone Octant.\\n\\n"..RequiresTechDeck_String.."Tire des rafales sur sa cible.\\n\\nLes balles explosent à l'impact.\\n\\nRégénère 5% de santé sur 3 secondes quand touché.",
	
	Bombus_Desc = "Assembler un compagnon Drone Bombus. \\n\\n"..RequiresTechDeck_String.."Tire un laser sur sa cible.\\n\\nFonce vers une cible et s'autodétruit à faible santé.",
	
	Wyvern_Desc = "Assembler un compagnon Drone Wyvern." .. RequiresTechDeck_String .. "\\n\\nTire des balles intelligentes sur sa cible.\\n\\nLes balles peuvent désorienter la cible.",
	
	Griffin_Desc = "Assembler un compagnon Drone Griffin." .. RequiresTechDeck_String .. "\\n\\nTire des rafales sur sa cible.\\n\\nAugmente temporairement l'armure quand touché.",
	
	Mech_Unstable_String = "\\n\\nInstable, la santé se dégrade sur 30 minutes.",
	
	Militech_Mech_Desc = "Assembler un compagnon Mech. \\n\\n"..RequiresTechDeck_String.."Tire des balles intelligentes lourdes.\\n\\nPiétine les ennemis proches.\\n\\nLes balles explosent à l'impact. \\n\\nLes points faibles ont 50% de santé en plus.\\n\\nNe peut pas se soigner." .. Mech_Unstable_String,
	Militech_Mech_Permanent_Desc = "Assembler un compagnon Mech. \\n\\n"..RequiresTechDeck_String.."Tire des balles intelligentes lourdes.\\n\\nPiétine les ennemis proches.\\n\\nLes balles explosent à l'impact. \\n\\nLes points faibles ont 50% de santé en plus.\\n\\nNe peut pas se soigner.",

	Arasaka_Mech_Desc = "Assembler un compagnon Mech. \\n\\n"..RequiresTechDeck_String.."Tire des balles intelligentes lourdes.\\n\\nPiétine les ennemis proches.\\n\\nLes TechHacks appliqués à ce Drone durent 50% plus longtemps. \\n\\nMet en surbrillance tous les Drones en combat et permet de les TechHacker à travers les murs.\\n\\nNe peut pas se soigner." .. Mech_Unstable_String,
	Arasaka_Mech_Permanent_Desc = "Assembler un compagnon Mech. \\n\\n"..RequiresTechDeck_String.."Tire des balles intelligentes lourdes.\\n\\nPiétine les ennemis proches.\\n\\nLes TechHacks appliqués à ce Drone durent 50% plus longtemps. \\n\\nMet en surbrillance tous les Drones en combat et permet de les TechHacker à travers les murs.\\n\\nNe peut pas se soigner.",

	NCPD_Mech_Desc = "Assembler un compagnon Mech. \\n\\n"..RequiresTechDeck_String.."Tire des balles intelligentes lourdes.\\n\\nPiétine les ennemis proches.\\n\\nQualité faible : santé et dégâts réduits.\\n\\nNe peut pas se soigner." .. Mech_Unstable_String,
	NCPD_Mech_Permanent_Desc = "Assembler un compagnon Mech. \\n\\n"..RequiresTechDeck_String.."Tire des balles intelligentes lourdes.\\n\\nPiétine les ennemis proches.\\n\\nQualité faible : santé et dégâts réduits.\\n\\nNe peut pas se soigner.",

	NCPD_Mech_String = "Mech NCPD",
	
	Android_Ranged_Desc = "Assembler un compagnon Androïde à Distance." .. RequiresTechDeck_String .. "\\n\\nUtilise un fusil d'assaut.",
	Android_Ranged_String = "Androïde à Distance",

	Android_Melee_Desc = "Assembler un compagnon Androïde de Mêlée." .. RequiresTechDeck_String .. "\\n\\nUtilise une arme de mêlée.",
	Android_Melee_String = "Androïde de Mêlée",

	Android_Shotgunner_Desc = "Assembler un compagnon Androïde Fusil à Pompe." .. RequiresTechDeck_String .. "\\n\\nUtilise un fusil à pompe.",
	Android_Shotgunner_String = "Androïde Fusil à Pompe",

	Android_Netrunner_Desc = "Assembler un compagnon Androïde Netrunner." .. RequiresTechDeck_String .. "\\n\\nUtilise un pistolet.\\n\\nTélécharge divers hacks sur les ennemis.",
	Android_Netrunner_String = "Androïde Netrunner",

	Android_Techie_Desc = "Assembler un compagnon Androïde Technicien." .. RequiresTechDeck_String .. "\\n\\nUtilise un revolver.\\n\\nLance diverses grenades sur les ennemis.",
	Android_Techie_String = "Androïde Technicien",

	Android_Sniper_Desc = "Assembler un compagnon Androïde Sniper." .. RequiresTechDeck_String .. "\\n\\nUtilise un fusil de sniper.",
	Android_Sniper_String = "Androïde Sniper",
	
	Crafting_Tab_String = "Drones",
	
	No_TechDeck_String = "AUCUN TECHDECK INSTALLÉ.",
	Combat_Disabled_String = "LE COMBAT EST DÉSACTIVÉ. QUITTEZ LA ZONE SÛRE.",
	Mech_Active_String =  "MECH DÉJÀ ACTIF.",
	Maximum_Drones_String = "NOMBRE MAXIMUM DE DRONES ACTIFS.",
	Exit_Vehicle_String = "QUITTER D'ABORD LE VÉHICULE.",
	V_Busy_String = "V EST OCCUPÉ.",
	Exit_Elevator_String = "QUITTER D'ABORD L'ASCENSEUR.",
	
	Mech_No_Repair_String = "Les Mechs ne peuvent pas être soignés avec Réparation.",
	Shutdown_No_Combat_String = "Impossible en combat.",
	Kerenzikov_Not_Android_String = "Utilisable uniquement sur les Androïdes.",
	
	One_Drone_String = "Permet le contrôle d'1 Drone.",
	Two_Drones_String = "Permet le contrôle de 2 Drones.",
	Three_Drones_String = "Permet le contrôle de 3 Drones.",
	Accuracy_String = "Augmente la précision des Drones de 30 %.",
	Armor_String = "Augmente l'armure des Drones de 20 %.",
	Health_String = "Augmente la santé des Drones de 20 %.",
	
	FlyingSE_String = "Les Drones soignent 15 % en tuant une cible.",
	FlyingCheap_String = "Les Drones ne meurent plus en utilisant le TechHack « Explosion ».",
	FlyingExplosion_String = "« Explosion » augmente les dégâts du Drone de 10 % pendant 15 s. Cumul jusqu'à 5 fois.",
	
	MechRegen_String = "Réduit le coût des TechHacks de 50 %.",
	TechHackCooldown_String = "Réduit les temps de recharge des TechHacks de 50 %.",
	OverdriveAll_String = "Surcharge s'applique à tous les Drones.",

	AndroidRegen_String = "En combat, les Drones régénèrent 1 % de leur santé par seconde.",
	AndroidDilation_String = "Les Drones gagnent des capacités Sandevistan.",
	AndroidWeapons_String = "Les Drones peuvent utiliser des armes high‑tech.",

	Street1Stats_String = Two_Drones_String.."\\n"..Health_String.."\\n"..Accuracy_String,
	Street2Stats_String = Two_Drones_String.."\\n"..Health_String.."\\n"..Accuracy_String.."\\n"..FlyingSE_String.."\\n"..FlyingCheap_String,
	Street3Stats_String = Three_Drones_String.."\\n"..Health_String.."\\n"..Accuracy_String.."\\n"..FlyingSE_String.."\\n"..FlyingCheap_String.."\\n"..FlyingExplosion_String,

	Nomad1Stats_String = Two_Drones_String.."\\n"..Health_String.."\\n"..Armor_String,
	Nomad2Stats_String = Two_Drones_String.."\\n"..Health_String.."\\n"..Armor_String.."\\n"..MechRegen_String.."\\n"..TechHackCooldown_String,
	Nomad3Stats_String = Three_Drones_String.."\\n"..Health_String.."\\n"..Armor_String.."\\n"..MechRegen_String.."\\n"..TechHackCooldown_String.."\\n"..OverdriveAll_String,

	Corpo1Stats_String = Two_Drones_String.."\\n"..Accuracy_String.."\\n"..Armor_String.."\\n"..AndroidRegen_String.."\\n"..AndroidDilation_String,
	Corpo2Stats_String = Three_Drones_String.."\\n"..Accuracy_String.."\\n"..Armor_String.."\\n"..AndroidRegen_String.."\\n"..AndroidDilation_String.."\\n"..AndroidWeapons_String,

	Nomad0_Name = "Meta Transporter Mk. I",
	Nomad1_Name = "Meta Transporter Mk. I",
	Nomad2_Name = "Meta Transporter Mk. II",
	Nomad3_Name = "Meta Transporter Mk. III",

	Street0_Name = "Mox Circuit Driver Mk. I",
	Street1_Name = "Mox Circuit Driver Mk. I",
	Street2_Name = "Mox Circuit Driver Mk. II",
	Street3_Name = "Mox Circuit Driver Mk. III",

	Corpo0_Name = "Kang Tao Neural Simulator Mk. I",
	CorpoRare_Name = "Kang Tao Neural Simulator Mk. I",
	Corpo1_Name = "Kang Tao Neural Simulator Mk. I",
	Corpo2_Name = "Kang Tao Neural Simulator Mk. II",

	Nomad0_Desc = "Chaque Nomade doit apprendre à prendre soin de lui et de son matériel.",
	Nomad1_Desc = "Quand Meta a déclaré son indépendance, ceci et des milliers de drones de réparation volés maintenaient leurs navires à flot.",
	Nomad2_Desc = "Grâce au TechDeck amélioré, les drones Meta ont ouvert de nouvelles routes à travers les tempêtes de sable et les territoires hostiles.",
	Nomad3_Desc = "La technologie Corpo‑Nomade la plus moderne, pour des livraisons toujours à l'heure.",

	Street0_Desc = "Deck d'entraînement pour que les Mox restent au niveau face aux adversaires plus chromés.",
	Street1_Desc = "Des mods spéciaux permettent d'émettre des explosions sans endommager la structure du Drone, assurant le respect des Mox dans tout NC.",
	Street2_Desc = "Comme les Mox se repaissent de leurs proies, leurs Drones aussi.",
	Street3_Desc = "Les cribler, les brûler, les faire exploser. Ailleurs, les Mox seraient les méchants – pas à Night City.",
	
	Corpo0_Desc = "Modèle simple pour que les nouvelles recrues Corpo aient du pouvoir sur quelque chose.",
	Corpo1_Desc = "Conçu face au manque criant de volontaires prêts à mourir pour les riches.",
	Corpo2_Desc = "Bourré d'algorithmes parmi les plus avancés du monde corpo. Au‑delà, envoyer des Drones au combat serait inhumain.",

	TechDeck_Module_String = "",
	
	Rare_Module_String = "",
	Epic_Module_String = "",
	Legendary_Module_String = "",
	
	Optics_Enhancer_String = "Logiciel de Ciblage Critique",
	Optics_Enhancer_Desc = "Tous les TechHacks augmentent les dégâts des Drones de 10 %." .. Rare_Module_String,
	
	Malfunction_Coordinator_String = "Coordinateur de Dysfonctionnement",
	Malfunction_Coordinator_Desc = "Augmente les dégâts d'explosion des Drones de 50 %." .. Rare_Module_String,
	
	Trigger_Software_String = "Améliorateur d'Optiques",
	Trigger_Software_Desc = "Débloque le TechHack « Choc Optique ».\\n\\nRend le Drone parfaitement précis." .. Rare_Module_String,
	
	Plate_Energizer_String = "Énergiseur de Plaque",
	Plate_Energizer_Desc = "Le camouflage optique régénère 2 % de santé par seconde." .. Epic_Module_String,
	
	Extra_Sensory_Processor_String = "Processeur Extra‑Sensoriel",
	Extra_Sensory_Processor_Desc = "Débloque le TechHack « Kerenzikov ».\\n\\nPermet à tous les Androïdes d'utiliser les capacités Kerenzikov." .. Epic_Module_String,
	
	Insta_Repair_Unit_String = "Unité de Réparation Instantanée",
	Insta_Repair_Unit_Desc = "La réparation des Drones prend 50 % moins de temps." .. Epic_Module_String,
	
	Mass_Distortion_Core_String = "Noyau de Distorsion de Masse",
	Mass_Distortion_Core_Desc = "Le camouflage optique s'applique à tous les Drones." .. Legendary_Module_String,
	
	Circuit_Charger_String = "Chargeur de Circuit",
	Circuit_Charger_Desc = "Débloque le TechHack « Système d'Armes d'Urgence ».\\n\\nSurcharge les circuits de tous les Drones, provoquant des explosions aléatoires et l'application de Choc, Brûlure ou Poison à l'impact." .. Legendary_Module_String,
	
	CPU_Overloader_String = "Surcharge CPU",
	CPU_Overloader_Desc = "La Surcharge accélère les Drones de 100 % supplémentaires." .. Legendary_Module_String
}