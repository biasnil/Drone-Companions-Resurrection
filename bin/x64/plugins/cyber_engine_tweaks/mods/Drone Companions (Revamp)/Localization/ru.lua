return {
	Tab_Name = "Дроны",
	Subtab_1 = "Язык",
	Subtab_2 = "Характеристики",
	Subtab_3 = "Цены",
	Subtab_4 = "Разное",
	Subtab_5 = "Внешний вид",
	
	FlyingHP_String = "Здоровье летающих дронов",
	AndroidHP_String = "Здоровье андроидов",
	MechHP_String = "Здоровье мехов",
	
	FlyingDPS_String = "Урон летающих дронов",
	AndroidDPS_String = "Урон андроидов",
	MechDPS_String = "Урон мехов",
	
	HP_Desc = "Задайте множитель здоровья.",
	DPS_Desc = "Задайте множитель урона.",

	Drone_Core_Price_String = "Модуль дрона",
	Drone_Core_Price_Desc = "Задайте цену предмета.",
	
	Disable_Android_Voices_String = "Отключить голоса андроидов",
	Disable_Android_Voices_Description = "Переключить боевые реплики андроидов.",
	
	Permanent_Mechs_String = "Постоянные мехи",
	Permanent_Mechs_Description = "Отключает спад здоровья меха. Требуется перезагрузка сохранения.",
	
	MeleeAndroidAppearance_String = "Андроид‑боец",
	RangedAndroidAppearance_String = "Андроид‑стрелок",
	ShotgunnerAndroidAppearance_String = "Андроид с дробовиком",
	NetrunnerAndroidAppearance_String = "Андроид‑нетраннер",
	TechieAndroidAppearance_String = "Андроид‑техник",
	SniperAndroidAppearance_String = "Андроид‑снайпер",

	BombusAppearance_String = "Бомбус",
	
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
	
	SelectAppearance_Description = "Выберите внешний вид дрона.",

	
	SystemExSlot_String = "Слот System‑EX",
	SystemExSlot_Description = "Выберите слот для техдеков при использовании мода System‑EX.",
	SystemExSlot1 = "Слот кибердека",
	SystemExSlot2 = "Слот ОС",
	
	Drone_Core_String = "Модуль дрона",
	Drone_Core_Desc = "Неотъемлемая часть операционных систем всех дронов.",
	
	RequiresTechDeck_String = "",
	
	Arasaka_Octant_String = "Дрон «Октант» Арасаки",
	Arasaka_Octant_Desc = "Соберите спутника — дрона «Октант».\\n\\n"..RequiresTechDeck_String.."Ведёт огонь очередями.\\n\\nТеххаки действуют на 50% дольше.\\n\\nТеххаки увеличивают броню дрона на 30%.",
	
	Militech_Octant_String = "Дрон «Октант» Милитеха",
	Militech_Octant_Desc = "Соберите спутника — дрона «Октант».\\n\\n"..RequiresTechDeck_String.."Ведёт огонь очередями.\\n\\nПули взрываются при попадании.\\n\\nПри попадании восстанавливает 5% здоровья за 3 секунды.",
	
	Bombus_Desc = "Соберите дрона «Бомбус». \\n\\n"..RequiresTechDeck_String.."Стреляет лазером по цели.\\n\\nПри низком здоровье врезается в цель и самоуничтожается.",
	
	Wyvern_Desc = "Соберите дрона «Виверна»." .. RequiresTechDeck_String .. "\\n\\nСтреляет самонаводящимися пулями.\\n\\nПули могут дезориентировать цель.",
	
	Griffin_Desc = "Соберите дрона «Грифон»." .. RequiresTechDeck_String .. "\\n\\nСтреляет очередями.\\n\\nВременно повышает броню при попадании.",
	
	Mech_Unstable_String = "\\n\\nНестабилен: здоровье убывает в течение 30 минут.",
	
	Militech_Mech_Desc = "Соберите спутника — меха. \\n\\n"..RequiresTechDeck_String.."Стреляет тяжёлыми самонаводящимися пулями.\\n\\nТопчет близких врагов.\\n\\nПули взрываются при попадании. \\n\\nУязвимые места имеют на 50% больше здоровья.\\n\\nНельзя лечить." .. Mech_Unstable_String,
	Militech_Mech_Permanent_Desc = "Соберите спутника — меха. \\n\\n"..RequiresTechDeck_String.."Стреляет тяжёлыми самонаводящимися пулями.\\n\\nТопчет близких врагов.\\n\\nПули взрываются при попадании. \\n\\nУязвимые места имеют на 50% больше здоровья.\\n\\nНельзя лечить.",

	Arasaka_Mech_Desc = "Соберите спутника — меха. \\n\\n"..RequiresTechDeck_String.."Стреляет тяжёлыми самонаводящимися пулями.\\n\\nТопчет близких врагов.\\n\\nТеххаки действуют на 50% дольше. \\n\\nПодсвечивает в бою всех дронов и позволяет взламывать их через стены.\\n\\nНельзя лечить." .. Mech_Unstable_String,
	Arasaka_Mech_Permanent_Desc = "Соберите спутника — меха. \\n\\n"..RequiresTechDeck_String.."Стреляет тяжёлыми самонаводящимися пулями.\\n\\nТопчет близких врагов.\\n\\nТеххаки действуют на 50% дольше. \\n\\nПодсвечивает в бою всех дронов и позволяет взламывать их через стены.\\n\\nНельзя лечить.",

	NCPD_Mech_Desc = "Соберите спутника — меха. \\n\\n"..RequiresTechDeck_String.."Стреляет тяжёлыми самонаводящимися пулями.\\n\\nТопчет близких врагов.\\n\\nНизкое качество — снижены здоровье и урон.\\n\\nНельзя лечить." .. Mech_Unstable_String,
	NCPD_Mech_Permanent_Desc = "Соберите спутника — меха. \\n\\n"..RequiresTechDeck_String.."Стреляет тяжёлыми самонаводящимися пулями.\\n\\nТопчет близких врагов.\\n\\nНизкое качество — снижены здоровье и урон.\\n\\nНельзя лечить.",

	NCPD_Mech_String = "Мех NCPD",
	
	Android_Ranged_Desc = "Соберите спутника — андроида‑стрелка." .. RequiresTechDeck_String .. "\\n\\nИспользует штурмовую винтовку.",
	Android_Ranged_String = "Андроид‑стрелок",

	Android_Melee_Desc = "Соберите спутника — андроида‑бойца." .. RequiresTechDeck_String .. "\\n\\nИспользует холодное оружие.",
	Android_Melee_String = "Андроид‑боец",

	Android_Shotgunner_Desc = "Соберите спутника — андроида с дробовиком." .. RequiresTechDeck_String .. "\\n\\nИспользует дробовик.",
	Android_Shotgunner_String = "Андроид с дробовиком",

	Android_Netrunner_Desc = "Соберите спутника — андроида‑нетраннера." .. RequiresTechDeck_String .. "\\n\\nИспользует пистолет.\\n\\nЗагружает на врагов различные хаки.",
	Android_Netrunner_String = "Андроид‑нетраннер",

	Android_Techie_Desc = "Соберите спутника — андроида‑техника." .. RequiresTechDeck_String .. "\\n\\nИспользует револьвер.\\n\\nБросает во врагов различные гранаты.",
	Android_Techie_String = "Андроид‑техник",

	Android_Sniper_Desc = "Соберите спутника — андроида‑снайпера." .. RequiresTechDeck_String .. "\\n\\nИспользует снайперскую винтовку.",
	Android_Sniper_String = "Андроид‑снайпер",
	
	Crafting_Tab_String = "Дроны",
	
	No_TechDeck_String = "НЕТ УСТАНОВЛЕННОГО TECHDECK.",
	Combat_Disabled_String = "БОЙ ОТКЛЮЧЁН. ВЫЙДИТЕ ИЗ БЕЗОПАСНОЙ ЗОНЫ.",
	Mech_Active_String =  "МЕХ УЖЕ АКТИВЕН.",
	Maximum_Drones_String = "МАКСИМАЛЬНОЕ ЧИСЛО ДРОНОВ АКТИВНО.",
	Exit_Vehicle_String = "СНАЧАЛА ВЫЙДИТЕ ИЗ ТРАНСПОРТА.",
	V_Busy_String = "V ЗАНЯТ(А).",
	Exit_Elevator_String = "СНАЧАЛА ВЫЙДИТЕ ИЗ ЛИФТА.",
	
	Mech_No_Repair_String = "Мехов нельзя лечить с помощью «Ремонта».",
	Shutdown_No_Combat_String = "Нельзя выполнить в бою.",
	Kerenzikov_Not_Android_String = "Только для андроидов.",
	
	One_Drone_String = "Позволяет управлять 1 дроном.",
	Two_Drones_String = "Позволяет управлять 2 дронами.",
	Three_Drones_String = "Позволяет управлять 3 дронами.",
	Accuracy_String = "Точность дронов повышается на 30%.",
	Armor_String = "Броня дронов повышается на 20%.",
	Health_String = "Здоровье дронов повышается на 20%.",
	
	FlyingSE_String = "Дроны восстанавливают 15% здоровья при убийстве цели.",
	FlyingCheap_String = "Дроны больше не умирают при использовании теххака «Взрыв».",
	FlyingExplosion_String = "«Взрыв» повышает урон дрона на 10% на 15 с. Суммируется до 5 раз.",
	
	MechRegen_String = "Стоимость теххаков снижена на 50%.",
	TechHackCooldown_String = "Время перезарядки теххаков снижено на 50%.",
	OverdriveAll_String = "«Перегрузка» применяется ко всем дронам.",

	AndroidRegen_String = "В бою дроны восстанавливают 1% здоровья в секунду.",
	AndroidDilation_String = "Дроны получают способности «Сандевистана».",
	AndroidWeapons_String = "Дроны могут использовать высокотехнологичное оружие.",

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

	Nomad0_Desc = "Каждый кочевник должен уметь заботиться о себе и своём снаряжении.",
	Nomad1_Desc = "Когда Meta объявили независимость, только это и тысячи украденных ремонтных дронов держали их корабли на плаву.",
	Nomad2_Desc = "Улучшенный техдек открыл для Meta новые маршруты через песчаные бури и враждебные территории.",
	Nomad3_Desc = "Самые современные корпо‑кочевнические технологии. Любая доставка — точно в срок.",

	Street0_Desc = "Учебная колода, чтобы «Мокс» не отставали от более «хромированных» противников.",
	Street1_Desc = "Особые модификации, позволяющие излучать взрывы без ущерба для корпуса дрона, гарантируют «Мокс» уважение по всему Найт‑Сити.",
	Street2_Desc = "Как «Мокс» питаются своей добычей, так и их дроны.",
	Street3_Desc = "Изрешетить, поджечь, взорвать. В большинстве мест «Мокс» были бы злодеями, но только не в Найт‑Сити.",
	
	Corpo0_Desc = "Простая модель для новобранцев‑корпо, чтобы иметь власть хоть над чем‑то.",
	Corpo1_Desc = "Создана с учётом шокирующего дефицита желающих умереть за богачей.",
	Corpo2_Desc = "Здесь упакованы одни из самых продвинутых алгоритмов корп‑мира. Дальше отправлять дронов в бой уже было бы негуманно.",

	TechDeck_Module_String = "",
	
	Rare_Module_String = "",
	Epic_Module_String = "",
	Legendary_Module_String = "",
	
	Optics_Enhancer_String = "ПО «Критический прицел»",
	Optics_Enhancer_Desc = "Все теххаки увеличивают урон дрона на 10%." .. Rare_Module_String,
	
	Malfunction_Coordinator_String = "Координатор неисправностей",
	Malfunction_Coordinator_Desc = "Увеличивает урон взрывов дронов на 50%." .. Rare_Module_String,
	
	Trigger_Software_String = "Оптический усилитель",
	Trigger_Software_Desc = "Открывает теххак «Оптический шок».\\n\\nДелает точность дрона идеальной." .. Rare_Module_String,
	
	Plate_Energizer_String = "Энергайзер брони",
	Plate_Energizer_Desc = "Оптический камуфляж восстанавливает 2% здоровья в секунду." .. Epic_Module_String,
	
	Extra_Sensory_Processor_String = "Экстрасенсорный процессор",
	Extra_Sensory_Processor_Desc = "Открывает теххак «Керензиков».\\n\\nДаёт всем андроидам способности «Керензикова»." .. Epic_Module_String,
	
	Insta_Repair_Unit_String = "Модуль мгновенного ремонта",
	Insta_Repair_Unit_Desc = "Ремонт дронов занимает на 50% меньше времени." .. Epic_Module_String,
	
	Mass_Distortion_Core_String = "Ядро массовой дисторсии",
	Mass_Distortion_Core_Desc = "Оптический камуфляж применяется ко всем дронам." .. Legendary_Module_String,
	
	Circuit_Charger_String = "Зарядник цепей",
	Circuit_Charger_Desc = "Открывает теххак «Аварийная оружейная система».\\n\\nПерегружает цепи всех дронов, из‑за чего они случайно вызывают взрывы и накладывают Шок, Горение или Яд при попадании." .. Legendary_Module_String,
	
	CPU_Overloader_String = "Перегрузчик CPU",
	CPU_Overloader_Desc = "«Перегрузка» ускоряет дронов ещё на 100%." .. Legendary_Module_String
}