return {
	Tab_Name = "드론",
	Subtab_1 = "언어",
	Subtab_2 = "스탯",
	Subtab_3 = "가격",
	Subtab_4 = "기타",
	Subtab_5 = "외형",
	
	FlyingHP_String = "비행 드론 체력",
	AndroidHP_String = "안드로이드 체력",
	MechHP_String = "메크 체력",
	
	FlyingDPS_String = "비행 드론 피해",
	AndroidDPS_String = "안드로이드 피해",
	MechDPS_String = "메크 피해",
	
	HP_Desc = "체력 배수를 설정합니다.",
	DPS_Desc = "피해 배수를 설정합니다.",

	Drone_Core_Price_String = "드론 모듈",
	Drone_Core_Price_Desc = "아이템 가격을 설정합니다.",
	
	Disable_Android_Voices_String = "안드로이드 음성 비활성화",
	Disable_Android_Voices_Description = "안드로이드 전투 대사를 전환합니다.",
	
	Permanent_Mechs_String = "영구 메크",
	Permanent_Mechs_Description = "메크의 체력 감소를 비활성화합니다. 세이브 재로드 필요.",
	
	MeleeAndroidAppearance_String = "근접 안드로이드",
	RangedAndroidAppearance_String = "원거리 안드로이드",
	ShotgunnerAndroidAppearance_String = "산탄총 안드로이드",
	NetrunnerAndroidAppearance_String = "넷러너 안드로이드",
	TechieAndroidAppearance_String = "테키 안드로이드",
	SniperAndroidAppearance_String = "스나이퍼 안드로이드",

	BombusAppearance_String = "봄버스",
	
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
	
	SelectAppearance_Description = "드론의 외형을 선택합니다.",

	
	SystemExSlot_String = "System-EX 슬롯",
	SystemExSlot_Description = "System-EX 사용 시 테크덱을 넣을 슬롯을 선택합니다.",
	SystemExSlot1 = "사이버덱 슬롯",
	SystemExSlot2 = "OS 슬롯",
	
	Drone_Core_String = "드론 모듈",
	Drone_Core_Desc = "모든 드론 운영체제의 핵심 부품.",
	
	RequiresTechDeck_String = "",
	
	Arasaka_Octant_String = "아라사카 옥턴트 드론",
	Arasaka_Octant_Desc = "옥턴트 드론 동료를 조립합니다.\\n\\n"..RequiresTechDeck_String.."목표를 향해 연속 사격을 합니다.\\n\\n이 드론에 적용된 테크핵의 지속시간이 50% 증가합니다.\\n\\n테크핵은 이 드론의 방어력을 30% 증가시킵니다.",
	
	Militech_Octant_String = "밀리텍 옥턴트 드론",
	Militech_Octant_Desc = "옥턴트 드론 동료를 조립합니다.\\n\\n"..RequiresTechDeck_String.."목표를 향해 연속 사격.\\n\\n탄환은 명중 시 폭발합니다.\\n\\n피격 시 3초에 걸쳐 체력 5% 회복합니다.",
	
	Bombus_Desc = "봄버스 드론 동료를 조립합니다. \\n\\n"..RequiresTechDeck_String.."레이저를 발사합니다.\\n\\n체력이 낮으면 표적으로 돌진해 자폭합니다.",
	
	Wyvern_Desc = "와이번 드론 동료를 조립합니다." .. RequiresTechDeck_String .. "\\n\\n스마트 탄환을 발사합니다.\\n\\n탄환은 대상을 혼란시킬 수 있습니다.",
	
	Griffin_Desc = "그리핀 드론 동료를 조립합니다." .. RequiresTechDeck_String .. "\\n\\n연속 사격을 합니다.\\n\\n피격 시 일시적으로 방어력이 증가합니다.",
	
	Mech_Unstable_String = "\\n\\n불안정하여 30분에 걸쳐 체력이 감소합니다.",
	
	Militech_Mech_Desc = "메크 동료를 조립합니다. \\n\\n"..RequiresTechDeck_String.."무거운 스마트 탄환을 발사합니다.\\n\\n근처 적을 짓밟습니다.\\n\\n탄환은 명중 시 폭발합니다. \\n\\n약점 체력이 50% 증가합니다.\\n\\n치유 불가." .. Mech_Unstable_String,
	Militech_Mech_Permanent_Desc = "메크 동료를 조립합니다. \\n\\n"..RequiresTechDeck_String.."무거운 스마트 탄환을 발사합니다.\\n\\n근처 적을 짓밟습니다.\\n\\n탄환은 명중 시 폭발합니다. \\n\\n약점 체력이 50% 증가합니다.\\n\\n치유 불가.",

	Arasaka_Mech_Desc = "메크 동료를 조립합니다. \\n\\n"..RequiresTechDeck_String.."무거운 스마트 탄환을 발사합니다.\\n\\n근처 적을 짓밟습니다.\\n\\n테크핵 지속시간 50% 증가. \\n\\n전투 중 모든 드론을 하이라이트하고 벽 너머 테크핵을 가능하게 합니다.\\n\\n치유 불가." .. Mech_Unstable_String,
	Arasaka_Mech_Permanent_Desc = "메크 동료를 조립합니다. \\n\\n"..RequiresTechDeck_String.."무거운 스마트 탄환을 발사합니다.\\n\\n근처 적을 짓밟습니다.\\n\\n테크핵 지속시간 50% 증가. \\n\\n전투 중 모든 드론을 하이라이트하고 벽 너머 테크핵을 가능하게 합니다.\\n\\n치유 불가.",

	NCPD_Mech_Desc = "메크 동료를 조립합니다. \\n\\n"..RequiresTechDeck_String.."무거운 스마트 탄환을 발사합니다.\\n\\n근처 적을 짓밟습니다.\\n\\n저품질이라 체력과 피해가 감소합니다.\\n\\n치유 불가." .. Mech_Unstable_String,
	NCPD_Mech_Permanent_Desc = "메크 동료를 조립합니다. \\n\\n"..RequiresTechDeck_String.."무거운 스마트 탄환을 발사합니다.\\n\\n근처 적을 짓밟습니다.\\n\\n저품質이라 체력과 피해가 감소합니다.\\n\\n치유 불가.",

	NCPD_Mech_String = "NCPD 메크",
	
	Android_Ranged_Desc = "원거리 안드로이드 동료를 조립합니다." .. RequiresTechDeck_String .. "\\n\\n돌격소총을 사용합니다.",
	Android_Ranged_String = "원거리 안드로이드",

	Android_Melee_Desc = "근접 안드로이드 동료를 조립합니다." .. RequiresTechDeck_String .. "\\n\\n근접 무기를 사용합니다.",
	Android_Melee_String = "근접 안드로이드",

	Android_Shotgunner_Desc = "산탄총 안드로이드 동료를 조립합니다." .. RequiresTechDeck_String .. "\\n\\n산탄총을 사용합니다.",
	Android_Shotgunner_String = "산탄총 안드로이드",

	Android_Netrunner_Desc = "넷러너 안드로이드 동료를 조립합니다." .. RequiresTechDeck_String .. "\\n\\n권총을 사용합니다.\\n\\n적에게 다양한 핵을 업로드합니다.",
	Android_Netrunner_String = "넷러너 안드로이드",

	Android_Techie_Desc = "테키 안드로이드 동료를 조립합니다." .. RequiresTechDeck_String .. "\\n\\n리볼버를 사용합니다.\\n\\n적에게 각종 수류탄을 투척합니다.",
	Android_Techie_String = "테키 안드로이드",

	Android_Sniper_Desc = "스나이퍼 안드로이드 동료를 조립합니다." .. RequiresTechDeck_String .. "\\n\\n저격총을 사용합니다.",
	Android_Sniper_String = "스나이퍼 안드로이드",
	
	Crafting_Tab_String = "드론",
	
	No_TechDeck_String = "테크덱이 설치되어 있지 않습니다.",
	Combat_Disabled_String = "전투가 비활성화되었습니다. 안전구역을 벗어나십시오.",
	Mech_Active_String =  "메크가 이미 활성화되어 있습니다.",
	Maximum_Drones_String = "활성화된 드론이 최대치입니다.",
	Exit_Vehicle_String = "먼저 차량에서 내려야 합니다.",
	V_Busy_String = "V가 바쁩니다.",
	Exit_Elevator_String = "먼저 엘리베이터에서 내려야 합니다.",
	
	Mech_No_Repair_String = "메크는 '수리'로 치유할 수 없습니다.",
	Shutdown_No_Combat_String = "전투 중에는 사용할 수 없습니다.",
	Kerenzikov_Not_Android_String = "안드로이드에만 사용할 수 있습니다.",
	
	One_Drone_String = "드론 1기 조종 가능.",
	Two_Drones_String = "드론 2기 조종 가능.",
	Three_Drones_String = "드론 3기 조종 가능.",
	Accuracy_String = "드론 명중률이 30% 증가합니다.",
	Armor_String = "드론 방어력이 20% 증가합니다.",
	Health_String = "드론 체력이 20% 증가합니다.",
	
	FlyingSE_String = "드론이 처치 시 체력 15% 회복.",
	FlyingCheap_String = "‘폭발’ 테크핵 사용 시 드론이 죽지 않습니다.",
	FlyingExplosion_String = "‘폭발’은 15초 동안 드론의 피해를 10% 증가시킵니다. 최대 5중첩.",
	
	MechRegen_String = "테크핵 비용을 50% 감소시킵니다.",
	TechHackCooldown_String = "테크핵 재사용 대기시간을 50% 감소시킵니다.",
	OverdriveAll_String = "과충전이 모든 드론에 적용됩니다.",

	AndroidRegen_String = "전투 중 드론이 초당 체력 1%를 재생합니다.",
	AndroidDilation_String = "드론이 산데비스탄 능력을 획득합니다.",
	AndroidWeapons_String = "드론이 하이테크 무기를 사용할 수 있습니다.",

	Nomad1Stats_String = Two_Drones_String.."\\n"..Health_String.."\\n"..Armor_String,
	Nomad2Stats_String = Two_Drones_String.."\\n"..Health_String.."\\n"..Armor_String.."\\n"..MechRegen_String.."\\n"..TechHackCooldown_String,
	Nomad3Stats_String = Three_Drones_String.."\\n"..Health_String.."\\n"..Armor_String.."\\n"..MechRegen_String.."\\n"..TechHackCooldown_String.."\\n"..OverdriveAll_String,

	Corpo1Stats_String = Two_Drones_String.."\\n"..Accuracy_String.."\\n"..Armor_String.."\\n"..AndroidRegen_String.."\\n"..AndroidDilation_String,
	Corpo2Stats_String = Three_Drones_String.."\\n"..Accuracy_String.."\\n"..Armor_String.."\\n"..AndroidRegen_String.."\\n"..AndroidDilation_String.."\\n"..AndroidWeapons_String,

	Street1Stats_String = Two_Drones_String.."\\n"..Health_String.."\\n"..Accuracy_String,
	Street2Stats_String = Two_Drones_String.."\\n"..Health_String.."\\n"..Accuracy_String.."\\n"..FlyingSE_String.."\\n"..FlyingCheap_String,
	Street3Stats_String = Three_Drones_String.."\\n"..Health_String.."\\n"..Accuracy_String.."\\n"..FlyingSE_String.."\\n"..FlyingCheap_String.."\\n"..FlyingExplosion_String,

	Nomad0_Name = "메타 트랜스포터 Mk. I",
	Nomad1_Name = "메타 트랜스포터 Mk. I",
	Nomad2_Name = "메타 트랜스포터 Mk. II",
	Nomad3_Name = "메타 트랜스포터 Mk. III",

	Street0_Name = "모크스 서킷 드라이버 Mk. I",
	Street1_Name = "모크스 서킷 드라이버 Mk. I",
	Street2_Name = "모크스 서킷 드라이버 Mk. II",
	Street3_Name = "모크스 서킷 드라이버 Mk. III",

	Corpo0_Name = "캉타오 뉴럴 시뮬레이터 Mk. I",
	CorpoRare_Name = "캉타오 뉴럴 시뮬레이터 Mk. I",
	Corpo1_Name = "캉타오 뉴럴 시뮬레이터 Mk. I",
	Corpo2_Name = "캉타오 뉴럴 시뮬레이터 Mk. II",

	Nomad0_Desc = "노마드는 스스로와 장비를 스스로 돌보는 법을 배워야 한다.",
	Nomad1_Desc = "메타가 독립을 선언했을 때, 이 장치と 수천 대의 도난 수리 드론이 그들의 선박을 지탱했다.",
	Nomad2_Desc = "업그레이드된 테크덱 덕분에 메타 드론은 모래폭풍과 적대 지역을 가르는 새로운 항로를 개척했다.",
	Nomad3_Desc = "최신의 코프×노마드 기술. 어떤 배송도 시간에 맞춘다.",

	Street0_Desc = "더 크롬한 적들과 겨루기 위한 모크스의 훈련용 덱.",
	Street1_Desc = "드론 구조에 손상 없이 폭발을 방출하도록 한 특수 개조 덕분에 모크스는 NC 전역에서 존경받는다.",
	Street2_Desc = "모크스가 먹잇감을 먹어치우듯, 드론도 그렇게 한다.",
	Street3_Desc = "꿰뚫고, 불태우고, 폭파한다. 대부분의 도시라면 모크스가 악당이겠지만, 나이트 시티는 다르다.",
	
	Corpo0_Desc = "새내기 코프에게 무엇이든 통제권을 쥐어주는 단순한 모델.",
	Corpo1_Desc = "부자들을 위해 죽을 의향이 있는 사람의 극심한 부족을 감안해 설계.",
	Corpo2_Desc = "코프 세계의 초최신 알고리즘이 가득하다. 이 이상은 드론을 전장에 보내는 게 비인도적일 정도.",

	TechDeck_Module_String = "",
	
	Rare_Module_String = "",
	Epic_Module_String = "",
	Legendary_Module_String = "",
	
	Optics_Enhancer_String = "크리티컬 조준 소프트웨어",
	Optics_Enhancer_Desc = "모든 테크핵이 드론 피해를 10% 증가시킵니다." .. Rare_Module_String,
	
	Malfunction_Coordinator_String = "오작동 조정기",
	Malfunction_Coordinator_Desc = "드론의 폭발 피해가 50% 증가합니다." .. Rare_Module_String,
	
	Trigger_Software_String = "옵틱스 인핸서",
	Trigger_Software_Desc = "‘옵틱 쇼크’ 테크핵을 해금합니다.\\n\\n드론의 명중률이 완벽해집니다." .. Rare_Module_String,
	
	Plate_Energizer_String = "플레이트 에너자이저",
	Plate_Energizer_Desc = "광학 위장 중 초당 2% 체력을 재생합니다." .. Epic_Module_String,
	
	Extra_Sensory_Processor_String = "초감각 프로세서",
	Extra_Sensory_Processor_Desc = "‘케렌지코프’ 테크핵을 해금합니다.\\n\\n모든 안드로이드에 케렌지코프 능력을 부여합니다." .. Epic_Module_String,
	
	Insta_Repair_Unit_String = "인스턴트 수리 유닛",
	Insta_Repair_Unit_Desc = "드론 수리 시간이 50% 단축됩니다." .. Epic_Module_String,
	
	Mass_Distortion_Core_String = "질량 왜곡 코어",
	Mass_Distortion_Core_Desc = "광학 위장이 모든 드론에 적용됩니다." .. Legendary_Module_String,
	
	Circuit_Charger_String = "회로 충전기",
	Circuit_Charger_Desc = "‘긴급 무기 시스템’ 테크핵을 해금합니다.\\n\\n모든 드론의 회로를 과부하시켜 무작위 폭발을 일으키고, 명중 시 감전/연소/중독을 부여합니다." .. Legendary_Module_String,
	
	CPU_Overloader_String = "CPU 오버로더",
	CPU_Overloader_Desc = "과충전의 가속 효과가 추가로 100% 증가합니다." .. Legendary_Module_String
}