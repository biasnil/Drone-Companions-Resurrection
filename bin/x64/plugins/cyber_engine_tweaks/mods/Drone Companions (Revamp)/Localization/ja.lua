return {
	Tab_Name = "ドローン",
	Subtab_1 = "言語",
	Subtab_2 = "ステータス",
	Subtab_3 = "価格",
	Subtab_4 = "その他",
	Subtab_5 = "外見",
	
	FlyingHP_String = "飛行ドローンの体力",
	AndroidHP_String = "アンドロイドの体力",
	MechHP_String = "メックの体力",
	
	FlyingDPS_String = "飛行ドローンのダメージ",
	AndroidDPS_String = "アンドロイドのダメージ",
	MechDPS_String = "メックのダメージ",
	
	HP_Desc = "体力の倍率を設定します。",
	DPS_Desc = "ダメージの倍率を設定します。",

	Drone_Core_Price_String = "ドローン・モジュール",
	Drone_Core_Price_Desc = "アイテムの価格を設定します。",
	
	Disable_Android_Voices_String = "アンドロイドのボイスを無効化",
	Disable_Android_Voices_Description = "アンドロイドの戦闘ボイスを切り替えます。",
	
	Permanent_Mechs_String = "メックを常駐化",
	Permanent_Mechs_Description = "メックの体力減衰を無効化します。セーブの再読み込みが必要です。",
	
	MeleeAndroidAppearance_String = "近接アンドロイド",
	RangedAndroidAppearance_String = "射撃アンドロイド",
	ShotgunnerAndroidAppearance_String = "ショットガン・アンドロイド",
	NetrunnerAndroidAppearance_String = "ネットランナー・アンドロイド",
	TechieAndroidAppearance_String = "テッキー・アンドロイド",
	SniperAndroidAppearance_String = "スナイパー・アンドロイド",

	BombusAppearance_String = "ボンバス",
	
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
	
	SelectAppearance_Description = "ドローンの外見を選択します。",

	
	SystemExSlot_String = "System-EX スロット",
	SystemExSlot_Description = "System-EX を使用する場合、テックデックを挿すスロットを選択します。",
	SystemExSlot1 = "サイバーデック・スロット",
	SystemExSlot2 = "OS スロット",
	
	Drone_Core_String = "ドローン・モジュール",
	Drone_Core_Desc = "すべてのドローンのOSに不可欠な部品。",
	
	RequiresTechDeck_String = "",
	
	Arasaka_Octant_String = "アラサカ・オクタント・ドローン",
	Arasaka_Octant_Desc = "オクタント・ドローンの相棒を組み立てる。\\n\\n"..RequiresTechDeck_String.."目標にバースト射撃を行う。\\n\\nテックハックの効果時間が50%延長。\\n\\nテックハックによりこのドローンのアーマーが30%増加。",
	
	Militech_Octant_String = "ミリテク・オクタント・ドローン",
	Militech_Octant_Desc = "オクタント・ドローンの相棒を組み立てる。\\n\\n"..RequiresTechDeck_String.."目標にバースト射撃。\\n\\n弾丸は着弾時に爆発。\\n\\n被弾時に3秒で体力を5%回復。",
	
	Bombus_Desc = "ボンバス・ドローンの相棒を組み立てる。 \\n\\n"..RequiresTechDeck_String.."目標にレーザーを発射。\\n\\n体力が低いと対象に突撃して自爆。",
	
	Wyvern_Desc = "ワイバーン・ドローンの相棒を組み立てる。" .. RequiresTechDeck_String .. "\\n\\n目標にスマート弾を発射。\\n\\n弾丸は対象を混乱させる場合がある。",
	
	Griffin_Desc = "グリフィン・ドローンの相棒を組み立てる。" .. RequiresTechDeck_String .. "\\n\\n目標にバースト射撃。\\n\\n被弾時に一時的にアーマーが増加。",
	
	Mech_Unstable_String = "\\n\\n不安定で、30分かけて体力が減衰する。",
	
	Militech_Mech_Desc = "メックの相棒を組み立てる。 \\n\\n"..RequiresTechDeck_String.."重いスマート弾を発射。\\n\\n近くの敵を踏みつける。\\n\\n弾丸は着弾時に爆発。 \\n\\n弱点の体力が50%増加。\\n\\n回復不可。" .. Mech_Unstable_String,
	Militech_Mech_Permanent_Desc = "メックの相棒を組み立てる。 \\n\\n"..RequiresTechDeck_String.."重いスマート弾を発射。\\n\\n近くの敵を踏みつける。\\n\\n弾丸は着弾時に爆発。 \\n\\n弱点の体力が50%増加。\\n\\n回復不可。",

	Arasaka_Mech_Desc = "メックの相棒を組み立てる。 \\n\\n"..RequiresTechDeck_String.."重いスマート弾を発射。\\n\\n近くの敵を踏みつける。\\n\\nテックハックの効果時間が50%延長。 \\n\\n戦闘中、すべてのドローンをハイライトし、壁越しのテックハックを可能にする。\\n\\n回復不可。" .. Mech_Unstable_String,
	Arasaka_Mech_Permanent_Desc = "メックの相棒を組み立てる。 \\n\\n"..RequiresTechDeck_String.."重いスマート弾を発射。\\n\\n近くの敵を踏みつける。\\n\\nテックハックの効果時間が50%延長。 \\n\\n戦闘中、すべてのドローンをハイライトし、壁越しのテックハックを可能にする。\\n\\n回復不可。",

	NCPD_Mech_Desc = "メックの相棒を組み立てる。 \\n\\n"..RequiresTechDeck_String.."重いスマート弾を発射。\\n\\n近くの敵を踏みつける。\\n\\n低品質で、体力とダメージが低下。\\n\\n回復不可。" .. Mech_Unstable_String,
	NCPD_Mech_Permanent_Desc = "メックの相棒を組み立てる。 \\n\\n"..RequiresTechDeck_String.."重いスマート弾を発射。\\n\\n近くの敵を踏みつける。\\n\\n低品質で、体力とダメージが低下。\\n\\n回復不可。",

	NCPD_Mech_String = "NCPDメック",
	
	Android_Ranged_Desc = "射撃アンドロイドの相棒を組み立てる。" .. RequiresTechDeck_String .. "\\n\\nアサルトライフルを使用。",
	Android_Ranged_String = "射撃アンドロイド",

	Android_Melee_Desc = "近接アンドロイドの相棒を組み立てる。" .. RequiresTechDeck_String .. "\\n\\n近接武器を使用。",
	Android_Melee_String = "近接アンドロイド",

	Android_Shotgunner_Desc = "ショットガン・アンドロイドの相棒を組み立てる。" .. RequiresTechDeck_String .. "\\n\\nショットガンを使用。",
	Android_Shotgunner_String = "ショットガン・アンドロイド",

	Android_Netrunner_Desc = "ネットランナー・アンドロイドの相棒を組み立てる。" .. RequiresTechDeck_String .. "\\n\\nハンドガンを使用。\\n\\nさまざまなハックを敵にアップロード。",
	Android_Netrunner_String = "ネットランナー・アンドロイド",

	Android_Techie_Desc = "テッキー・アンドロイドの相棒を組み立てる。" .. RequiresTechDeck_String .. "\\n\\nリボルバーを使用。\\n\\n敵に各種グレネードを投げる。",
	Android_Techie_String = "テッキー・アンドロイド",

	Android_Sniper_Desc = "スナイパー・アンドロイドの相棒を組み立てる。" .. RequiresTechDeck_String .. "\\n\\nスナイパーライフルを使用。",
	Android_Sniper_String = "スナイパー・アンドロイド",
	
	Crafting_Tab_String = "ドローン",
	
	No_TechDeck_String = "テックデックがインストールされていません。",
	Combat_Disabled_String = "戦闘は無効です。セーフゾーンから出てください。",
	Mech_Active_String =  "メックは既に展開中。",
	Maximum_Drones_String = "ドローンの最大数に達しました。",
	Exit_Vehicle_String = "まず車両から降りてください。",
	V_Busy_String = "V は現在操作できません。",
	Exit_Elevator_String = "まずエレベーターを出てください。",
	
	Mech_No_Repair_String = "メックは「修理」で回復できません。",
	Shutdown_No_Combat_String = "戦闘中には実行できません。",
	Kerenzikov_Not_Android_String = "アンドロイドにのみ使用できます。",
	
	One_Drone_String = "ドローンを1体操作可能。",
	Two_Drones_String = "ドローンを2体操作可能。",
	Three_Drones_String = "ドローンを3体操作可能。",
	Accuracy_String = "ドローンの命中精度が30%上昇。",
	Armor_String = "ドローンのアーマーが20%上昇。",
	Health_String = "ドローンの体力が20%上昇。",
	
	FlyingSE_String = "ドローンはキル時に体力を15%回復。",
	FlyingCheap_String = "テックハック「爆破」を使用してもドローンは死なない。",
	FlyingExplosion_String = "爆破は15秒間ドローンのダメージを10%上昇。最大5回までスタック。",
	
	MechRegen_String = "テックハックのコストを50%削減。",
	TechHackCooldown_String = "テックハックのクールダウンを50%短縮。",
	OverdriveAll_String = "オーバーチャージがすべてのドローンに適用。",

	AndroidRegen_String = "戦闘中、ドローンは毎秒体力の1%を再生。",
	AndroidDilation_String = "ドローンはサンデヴィスタン能力を得る。",
	AndroidWeapons_String = "ドローンはハイテク武器を使用可能。",

	Nomad1Stats_String = Two_Drones_String.."\\n"..Health_String.."\\n"..Armor_String,
	Nomad2Stats_String = Two_Drones_String.."\\n"..Health_String.."\\n"..Armor_String.."\\n"..MechRegen_String.."\\n"..TechHackCooldown_String,
	Nomad3Stats_String = Three_Drones_String.."\\n"..Health_String.."\\n"..Armor_String.."\\n"..MechRegen_String.."\\n"..TechHackCooldown_String.."\\n"..OverdriveAll_String,

	Corpo1Stats_String = Two_Drones_String.."\\n"..Accuracy_String.."\\n"..Armor_String.."\\n"..AndroidRegen_String.."\\n"..AndroidDilation_String,
	Corpo2Stats_String = Three_Drones_String.."\\n"..Accuracy_String.."\\n"..Armor_String.."\\n"..AndroidRegen_String.."\\n"..AndroidDilation_String.."\\n"..AndroidWeapons_String,

	Street1Stats_String = Two_Drones_String.."\\n"..Health_String.."\\n"..Accuracy_String,
	Street2Stats_String = Two_Drones_String.."\\n"..Health_String.."\\n"..Accuracy_String.."\\n"..FlyingSE_String.."\\n"..FlyingCheap_String,
	Street3Stats_String = Three_Drones_String.."\\n"..Health_String.."\\n"..Accuracy_String.."\\n"..FlyingSE_String.."\\n"..FlyingCheap_String.."\\n"..FlyingExplosion_String,

	Nomad0_Name = "メタ・トランスポーター Mk. I",
	Nomad1_Name = "メタ・トランスポーター Mk. I",
	Nomad2_Name = "メタ・トランスポーター Mk. II",
	Nomad3_Name = "メタ・トランスポーター Mk. III",

	Street0_Name = "モックス・サーキットドライバー Mk. I",
	Street1_Name = "モックス・サーキットドライバー Mk. I",
	Street2_Name = "モックス・サーキットドライバー Mk. II",
	Street3_Name = "モックス・サーキットドライバー Mk. III",

	Corpo0_Name = "カン・タオ ニューラル・シミュレーター Mk. I",
	CorpoRare_Name = "カン・タオ ニューラル・シミュレーター Mk. I",
	Corpo1_Name = "カン・タオ ニューラル・シミュレーター Mk. I",
	Corpo2_Name = "カン・タオ ニューラル・シミュレーター Mk. II",

	Nomad0_Desc = "ノーマッドは自分自身と装備を自分で面倒見る術を学ばなければならない。",
	Nomad1_Desc = "メタが独立を宣言した当初、これと数千体の盗難修理ドローンだけが艦船を支えた。",
	Nomad2_Desc = "強化されたテックデックにより、メタのドローンは過酷な砂嵐と敵対地域を抜ける新航路を開拓した。",
	Nomad3_Desc = "最新のコーポ×ノーマッド技術。どんな配送も必ず時間通り。",

	Street0_Desc = "よりクロームな相手にも負けないよう、モックスが用いる訓練用デッキ。",
	Street1_Desc = "ドローンの構造を損なわず爆発を放てる特注改造により、モックスはナイトシティ全域で尊敬を集める。",
	Street2_Desc = "モックスが獲物を喰らうように、彼らのドローンもまた喰らう。",
	Street3_Desc = "蜂の巣にして、燃やして、吹き飛ばす。多くの街ならモックスは悪党だが、ナイトシティは違う。",
	
	Corpo0_Desc = "新米コーポが何かに権限を持てるようにするための簡易モデル。",
	Corpo1_Desc = "富裕層のために死ぬ覚悟のある人材が著しく不足している現状に合わせて設計。",
	Corpo2_Desc = "企業世界最高峰のアルゴリズムが詰め込まれている。これ以上は、ドローンを戦場に送るのが非人道的な域。",

	TechDeck_Module_String = "",
	
	Rare_Module_String = "",
	Epic_Module_String = "",
	Legendary_Module_String = "",
	
	Optics_Enhancer_String = "クリティカル照準ソフトウェア",
	Optics_Enhancer_Desc = "すべてのテックハックがドローンのダメージを10%上昇。" .. Rare_Module_String,
	
	Malfunction_Coordinator_String = "マルファンクション・コーディネーター",
	Malfunction_Coordinator_Desc = "ドローンの爆発ダメージが50%上昇。" .. Rare_Module_String,
	
	Trigger_Software_String = "オプティクス・エンハンサー",
	Trigger_Software_Desc = "「オプティック・ショック」テックハックをアンロック。\\n\\nドローンの命中精度が完全になる。" .. Rare_Module_String,
	
	Plate_Energizer_String = "プレート・エナジャイザー",
	Plate_Energizer_Desc = "光学迷彩中、ドローンは毎秒2%体力を再生。" .. Epic_Module_String,
	
	Extra_Sensory_Processor_String = "エクストラ・センソリー・プロセッサ",
	Extra_Sensory_Processor_Desc = "「ケレンジコフ」テックハックをアンロック。\\n\\nすべてのアンドロイドにケレンジコフ能力を付与。" .. Epic_Module_String,
	
	Insta_Repair_Unit_String = "インスタ・リペア・ユニット",
	Insta_Repair_Unit_Desc = "ドローンの修理時間が50%短縮。" .. Epic_Module_String,
	
	Mass_Distortion_Core_String = "質量歪曲コア",
	Mass_Distortion_Core_Desc = "光学迷彩がすべてのドローンに適用。" .. Legendary_Module_String,
	
	Circuit_Charger_String = "サーキット・チャージャー",
	Circuit_Charger_Desc = "「緊急兵器システム」テックハックをアンロック。\\n\\n全ドローンの回路を過負荷にし、ランダムな爆発と感電・燃焼・毒を付与。" .. Legendary_Module_String,
	
	CPU_Overloader_String = "CPU オーバーローダー",
	CPU_Overloader_Desc = "オーバーチャージの加速効果がさらに100%増加。" .. Legendary_Module_String
}