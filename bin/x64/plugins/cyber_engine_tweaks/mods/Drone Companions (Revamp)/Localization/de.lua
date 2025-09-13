return {
	Tab_Name = "Drohnen",
	Subtab_1 = "Sprache",
	Subtab_2 = "Statuswerte",
	Subtab_3 = "Preise",
	Subtab_4 = "Verschiedenes",
	Subtab_5 = "Aussehen",
	
	FlyingHP_String = "Lebenspunkte (Flugdrohne)",
	AndroidHP_String = "Lebenspunkte (Android)",
	MechHP_String = "Lebenspunkte (Mech)",
	
	FlyingDPS_String = "Schaden (Flugdrohne)",
	AndroidDPS_String = "Schaden (Android)",
	MechDPS_String = "Schaden (Mech)",
	
	HP_Desc = "Multiplikator für Lebenspunkte festlegen.",
	DPS_Desc = "Multiplikator für Schaden festlegen.",

	Drone_Core_Price_String = "Drohnen‑Modul",
	Drone_Core_Price_Desc = "Preis des Gegenstands festlegen.",
	
	Disable_Android_Voices_String = "Android‑Stimmen deaktivieren",
	Disable_Android_Voices_Description = "Gefechtskommentare der Androiden umschalten.",
	
	Permanent_Mechs_String = "Dauerhafte Mechs",
	Permanent_Mechs_Description = "Lebenspunkte‑Verfall der Mechs deaktivieren. Neuladen eines Spielstands erforderlich.",
	
	MeleeAndroidAppearance_String = "Nahkampf‑Android",
	RangedAndroidAppearance_String = "Fernkampf‑Android",
	ShotgunnerAndroidAppearance_String = "Schrotflinten‑Android",
	NetrunnerAndroidAppearance_String = "Netrunner‑Android",
	TechieAndroidAppearance_String = "Tech‑Android",
	SniperAndroidAppearance_String = "Scharfschützen‑Android",

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
	
	SelectAppearance_Description = "Aussehen der Drohne auswählen.",

	
	SystemExSlot_String = "System‑EX‑Steckplatz",
	SystemExSlot_Description = "Steckplatz für Techdecks wählen, wenn das Mod „System‑EX“ genutzt wird.",
	SystemExSlot1 = "Cyberdeck‑Slot",
	SystemExSlot2 = "OS‑Slot",
	
	Drone_Core_String = "Drohnen‑Modul",
	Drone_Core_Desc = "Unverzichtbares Bauteil für die Betriebssysteme aller Drohnen.",
	
	RequiresTechDeck_String = "",
	
	Arasaka_Octant_String = "Arasaka‑Octant‑Drohne",
	Arasaka_Octant_Desc = "Baue einen Octant‑Drohnen‑Gefährten zusammen.\\n\\n"..RequiresTechDeck_String.."Feuert Salven auf das Ziel.\\n\\nAuf diese Drohne angewandte TechHacks halten 50% länger.\\n\\nTechHacks erhöhen die Panzerung dieser Drohne um 30%.",
	
	Militech_Octant_String = "Militech‑Octant‑Drohne",
	Militech_Octant_Desc = "Baue einen Octant‑Drohnen‑Gefährten zusammen.\\n\\n"..RequiresTechDeck_String.."Feuert Salven auf das Ziel.\\n\\nGeschosse explodieren beim Aufschlag.\\n\\nErhält bei Treffern 5% Leben über 3 Sekunden zurück.",
	
	Bombus_Desc = "Baue einen Bombus‑Drohnen‑Gefährten. \\n\\n"..RequiresTechDeck_String.."Feuert einen Laser auf das Ziel.\\n\\nStürzt sich bei wenig Leben ins Ziel und zerstört sich selbst.",
	
	Wyvern_Desc = "Baue einen Wyvern‑Drohnen‑Gefährten." .. RequiresTechDeck_String .. "\\n\\nFeuert Smart‑Geschosse auf das Ziel.\\n\\nGeschosse können das Ziel desorientieren.",
	
	Griffin_Desc = "Baue einen Griffin‑Drohnen‑Gefährten." .. RequiresTechDeck_String .. "\\n\\nFeuert Salven auf das Ziel.\\n\\nErhöht die Panzerung bei Treffern vorübergehend.",
	
	Mech_Unstable_String = "\\n\\nInstabil – verliert über 30 Minuten Lebenspunkte.",
	
	Militech_Mech_Desc = "Baue einen Mech‑Gefährten. \\n\\n"..RequiresTechDeck_String.."Feuert schwere Smart‑Geschosse.\\n\\nStampft nahe Gegner.\\n\\nGeschosse explodieren beim Aufschlag. \\n\\nSchwachpunkte haben 50% mehr Lebenspunkte.\\n\\nKann nicht geheilt werden." .. Mech_Unstable_String,
	Militech_Mech_Permanent_Desc = "Baue einen Mech‑Gefährten. \\n\\n"..RequiresTechDeck_String.."Feuert schwere Smart‑Geschosse.\\n\\nStampft nahe Gegner.\\n\\nGeschosse explodieren beim Aufschlag. \\n\\nSchwachpunkte haben 50% mehr Lebenspunkte.\\n\\nKann nicht geheilt werden.",

	Arasaka_Mech_Desc = "Baue einen Mech‑Gefährten. \\n\\n"..RequiresTechDeck_String.."Feuert schwere Smart‑Geschosse.\\n\\nStampft nahe Gegner.\\n\\nTechHacks wirken 50% länger. \\n\\nMarkiert im Kampf alle Drohnen und ermöglicht TechHacks durch Wände.\\n\\nKann nicht geheilt werden." .. Mech_Unstable_String,
	Arasaka_Mech_Permanent_Desc = "Baue einen Mech‑Gefährten. \\n\\n"..RequiresTechDeck_String.."Feuert schwere Smart‑Geschosse.\\n\\nStampft nahe Gegner.\\n\\nTechHacks wirken 50% länger. \\n\\nMarkiert im Kampf alle Drohnen und ermöglicht TechHacks durch Wände.\\n\\nKann nicht geheilt werden.",

	NCPD_Mech_Desc = "Baue einen Mech‑Gefährten. \\n\\n"..RequiresTechDeck_String.."Feuert schwere Smart‑Geschosse.\\n\\nStampft nahe Gegner.\\n\\nGeringe Qualität – verringerte Lebenspunkte und Schaden.\\n\\nKann nicht geheilt werden." .. Mech_Unstable_String,
	NCPD_Mech_Permanent_Desc = "Baue einen Mech‑Gefährten. \\n\\n"..RequiresTechDeck_String.."Feuert schwere Smart‑Geschosse.\\n\\nStampft nahe Gegner.\\n\\nGeringe Qualität – verringerte Lebenspunkte und Schaden.\\n\\nKann nicht geheilt werden.",

	NCPD_Mech_String = "NCPD‑Mech",
	
	Android_Ranged_Desc = "Baue einen Fernkampf‑Androiden‑Gefährten." .. RequiresTechDeck_String .. "\\n\\nVerwendet ein Sturmgewehr.",
	Android_Ranged_String = "Fernkampf‑Android",

	Android_Melee_Desc = "Baue einen Nahkampf‑Androiden‑Gefährten." .. RequiresTechDeck_String .. "\\n\\nVerwendet eine Nahkampfwaffe.",
	Android_Melee_String = "Nahkampf‑Android",

	Android_Shotgunner_Desc = "Baue einen Schrotflinten‑Androiden‑Gefährten." .. RequiresTechDeck_String .. "\\n\\nVerwendet eine Schrotflinte.",
	Android_Shotgunner_String = "Schrotflinten‑Android",

	Android_Netrunner_Desc = "Baue einen Netrunner‑Androiden‑Gefährten." .. RequiresTechDeck_String .. "\\n\\nVerwendet eine Handfeuerwaffe.\\n\\nLädt verschiedene Hacks auf Gegner hoch.",
	Android_Netrunner_String = "Netrunner‑Android",

	Android_Techie_Desc = "Baue einen Tech‑Androiden‑Gefährten." .. RequiresTechDeck_String .. "\\n\\nVerwendet einen Revolver.\\n\\nWirft verschiedene Granaten auf Gegner.",
	Android_Techie_String = "Tech‑Android",

	Android_Sniper_Desc = "Baue einen Scharfschützen‑Androiden‑Gefährten." .. RequiresTechDeck_String .. "\\n\\nVerwendet ein Scharfschützengewehr.",
	Android_Sniper_String = "Scharfschützen‑Android",
	
	Crafting_Tab_String = "Drohnen",
	
	No_TechDeck_String = "KEIN TECHDECK INSTALLIERT.",
	Combat_Disabled_String = "KAMPF DEAKTIVIERT. VERLASSE DIE SICHERHEITSZONE.",
	Mech_Active_String =  "MECH BEREITS AKTIV.",
	Maximum_Drones_String = "MAXIMALE ANZAHL DROHNEN AKTIV.",
	Exit_Vehicle_String = "ZUERST FAHRZEUG VERLASSEN.",
	V_Busy_String = "V IST BESCHÄFTIGT.",
	Exit_Elevator_String = "ZUERST AUFZUG VERLASSEN.",
	
	Mech_No_Repair_String = "Mechs können nicht mit „Reparieren“ geheilt werden.",
	Shutdown_No_Combat_String = "Kann im Kampf nicht ausgeführt werden.",
	Kerenzikov_Not_Android_String = "Nur für Androiden.",
	
	One_Drone_String = "Ermöglicht die Kontrolle über 1 Drohne.",
	Two_Drones_String = "Ermöglicht die Kontrolle über 2 Drohnen.",
	Three_Drones_String = "Ermöglicht die Kontrolle über 3 Drohnen.",
	Accuracy_String = "Erhöht die Genauigkeit von Drohnen um 30%.",
	Armor_String = "Erhöht die Panzerung von Drohnen um 20%.",
	Health_String = "Erhöht die Lebenspunkte von Drohnen um 20%.",
	
	FlyingSE_String = "Drohnen heilen 15% beim Töten eines Ziels.",
	FlyingCheap_String = "Drohnen sterben beim Einsatz des TechHacks „Explodieren“ nicht mehr.",
	FlyingExplosion_String = "„Explodieren“ erhöht den Schaden 15 Sek. lang um 10%. Stapelt bis zu 5‑mal.",
	
	MechRegen_String = "Reduziert die Kosten von TechHacks um 50%.",
	TechHackCooldown_String = "Reduziert TechHack‑Abklingzeiten um 50%.",
	OverdriveAll_String = "Überladung wirkt auf alle Drohnen.",

	AndroidRegen_String = "Drohnen regenerieren im Kampf 1% Leben pro Sekunde.",
	AndroidDilation_String = "Drohnen erhalten Sandevistan‑Fähigkeiten.",
	AndroidWeapons_String = "Drohnen können High‑Tech‑Waffen verwenden.",

	Nomad1Stats_String = Two_Drones_String.."\\n"..Health_String.."\\n"..Armor_String,
	Nomad2Stats_String = Two_Drones_String.."\\n"..Health_String.."\\n"..Armor_String.."\\n"..MechRegen_String.."\\n"..TechHackCooldown_String,
	Nomad3Stats_String = Three_Drones_String.."\\n"..Health_String.."\\n"..Armor_String.."\\n"..MechRegen_String.."\\n"..TechHackCooldown_String.."\\n"..OverdriveAll_String,

	Corpo1Stats_String = Two_Drones_String.."\\n"..Accuracy_String.."\\n"..Armor_String.."\\n"..AndroidRegen_String.."\\n"..AndroidDilation_String,
	Corpo2Stats_String = Three_Drones_String.."\\n"..Accuracy_String.."\\n"..Armor_String.."\\n"..AndroidRegen_String.."\\n"..AndroidDilation_String.."\\n"..AndroidWeapons_String,

	Street1Stats_String = Two_Drones_String.."\\n"..Health_String.."\\n"..Accuracy_String,
	Street2Stats_String = Two_Drones_String.."\\n"..Health_String.."\\n"..Accuracy_String.."\\n"..FlyingSE_String.."\\n"..FlyingCheap_String,
	Street3Stats_String = Three_Drones_String.."\\n"..Health_String.."\\n"..Accuracy_String.."\\n"..FlyingSE_String.."\\n"..FlyingCheap_String.."\\n"..FlyingExplosion_String,

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

	Nomad0_Desc = "Jeder Nomade muss lernen, sich um sich selbst und seine Ausrüstung zu kümmern.",
	Nomad1_Desc = "Als Meta die Unabhängigkeit erklärte, hielten nur dies und Tausende gestohlener Reparaturdrohnen ihre Schiffe am Laufen.",
	Nomad2_Desc = "Dank verbessertem Techdeck erschlossen Meta‑Drohnen neue Routen durch Sandstürme und feindliche Gebiete.",
	Nomad3_Desc = "Modernste Corpo‑Nomaden‑Technik: Jede Lieferung kommt rechtzeitig an.",

	Street0_Desc = "Trainingsdeck, damit die Mox gegen stärker verchromte Gegner mithalten.",
	Street1_Desc = "Spezialmodifikationen, die Explosionen ohne Strukturverlust der Drohne erlauben, verschaffen den Mox Respekt in ganz NC.",
	Street2_Desc = "Wie die Mox sich von ihrer Beute nähren, so auch ihre Drohnen.",
	Street3_Desc = "Zerlöchern, anzünden, in die Luft jagen. Anderswo wären die Mox die Bösen – nicht in Night City.",
	
	Corpo0_Desc = "Einfaches Modell für neue Corpo‑Rekruten, um wenigstens über etwas Macht zu besitzen.",
	Corpo1_Desc = "Ausgelegt auf den schockierenden Mangel an Menschen, die bereit sind, für Reiche zu sterben.",
	Corpo2_Desc = "Vollgestopft mit einigen der fortschrittlichsten Algorithmen der Konzernwelt. Darüber hinaus wäre es unmenschlich, Drohnen noch in den Kampf zu schicken.",

	TechDeck_Module_String = "",
	
	Rare_Module_String = "",
	Epic_Module_String = "",
	Legendary_Module_String = "",
	
	Optics_Enhancer_String = "Kritische Zielsoftware",
	Optics_Enhancer_Desc = "Alle TechHacks erhöhen den Drohnenschaden um 10%." .. Rare_Module_String,
	
	Malfunction_Coordinator_String = "Fehlfunktions‑Koordinator",
	Malfunction_Coordinator_Desc = "Erhöht den Explosionsschaden von Drohnen um 50%." .. Rare_Module_String,
	
	Trigger_Software_String = "Optik‑Verstärker",
	Trigger_Software_Desc = "Schaltet den TechHack „Optischer Schock“ frei.\\n\\nMacht die Drohne perfekt präzise." .. Rare_Module_String,
	
	Plate_Energizer_String = "Panzerplatten‑Energizer",
	Plate_Energizer_Desc = "Optische Tarnung regeneriert 2% Leben pro Sekunde." .. Epic_Module_String,
	
	Extra_Sensory_Processor_String = "Extrasensorischer Prozessor",
	Extra_Sensory_Processor_Desc = "Schaltet den TechHack „Kerenzikov“ frei.\\n\\nGewährt allen Androiden Kerenzikov‑Fähigkeiten." .. Epic_Module_String,
	
	Insta_Repair_Unit_String = "Sofort‑Reparatureinheit",
	Insta_Repair_Unit_Desc = "Reparieren von Drohnen dauert 50% weniger lang." .. Epic_Module_String,
	
	Mass_Distortion_Core_String = "Massendistortions‑Kern",
	Mass_Distortion_Core_Desc = "Optische Tarnung wirkt auf alle Drohnen." .. Legendary_Module_String,
	
	Circuit_Charger_String = "Schaltkreis‑Lader",
	Circuit_Charger_Desc = "Schaltet den TechHack „Notwaffensystem“ frei.\\n\\nÜberlädt die Schaltkreise aller Drohnen, wodurch sie zufällig Explosionen auslösen und bei Treffern Schock, Brand oder Gift anwenden." .. Legendary_Module_String,
	
	CPU_Overloader_String = "CPU‑Überlader",
	CPU_Overloader_Desc = "Überladung beschleunigt Drohnen um weitere 100%." .. Legendary_Module_String
}