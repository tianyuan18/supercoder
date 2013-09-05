package OopsEngine.Role
{
	import OopsEngine.Scene.StrategyElement.GameElementAnimal;
	
	/**
	 * 宠物VO
	 * @version:1.0
	 * @playerVersion:10.0
	 * @date:7/5/2010
	 */
	public class GamePetRole
	{
		////////////////////////////////////////////////////////////////////////////////////////
		//constructor function
		public function GamePetRole()
		{
		}
		
		////////////////////////////////////////////////////////////////////////////////////////
		//public var
		
		public var Id:uint;					/** 编号 */
		public var OwnerId:uint;			/** 主人ID */
		public var PetName:String; 			/** 名字 */
		public var FaceType:int;			/** 头像 */
		public var Sex:int;					/** 性别 0-雄，	1-雌  2 幻化*/ 
		public var Type:int;				/** 类型 0-野生，1-宝宝，2-二代 */
		public var TakeLevel:int;			/** 携带等级，人物达到一定等级才可携带 */
		public var Character:int;			/** 性格 0-勇猛， 1-胆小，2-精明，3-谨慎，4-忠诚 */    //性格 0-胆小，1-精明，2-谨慎，3-忠诚，4-勇猛
		public var ClassId:int;				/** 种类 猴子、狐狸、熊= (每种生物是一类ID) */
		public var Level:int;				/** 等级 */
		public var Genius:int;				/** 天赋 */
		public var Appraise:int;			/** 评价，对应UIUtil.as中相应等级 */
		public var State:int;				/** 状态 0-休息，1-出战  4 附体  5 分离*/
		public var Grade:int;				/** 成长等级 数值 普通、优秀、杰出、卓越、完美 */						
		public var Savvy:int;				/** 悟性 */	
		public var LoseTime:int;			/** 合成失败次数 */		
		
		public var HappyMax:int = 100; 		/** 最大快乐值 */
		public var HappyNow:int;			/** 当前快乐值 */
		public var LifeMax:int;				/** 最大寿命值 */
		public var LifeNow:int;				/** 当前寿命值 */
		public var ExpMax:int;				/** 最大经验值 */
		public var ExpNow:int;				/** 当前经验值 */
		public var HpMax:int;				/** 最大生命值 */
		public var HpNow:int;				/** 当前生命值 */
		public var MpMax:int;				/** 最大法力值 */
		public var MpNow:int;				/** 当前法力值 */
		public var EnergyMax:int;				/** 最大精力值 */
		public var EnergyNow:int;				/** 当前精力值 */
		public var Quality:int;				/** 品质 */
		public var BreedMax:int = 3;		/** 最大繁殖代 */
		public var BreedNow:int;			/** 当前繁殖代 */
		
		public var ForceInitMax:int;		/** 初始最大力量资质 */
		public var SpiritPowerInitMax:int;	/** 初始最大灵力资质 */
		public var PhysicalInitMax:int;		/** 初始最大体力资质 */
		public var ConstantInitMax:int;		/** 初始最大定力资质 */						
		public var MagicInitMax:int;		/** 初始最大身法资质 */						
		public var ForceInit:int;			/** 初始力量资质 */
		public var SpiritPowerInit:int;		/** 初始灵力资质 */
		public var PhysicalInit:int;		/** 初始体力资质 */
		public var ConstantInit:int;		/** 初始定力资质 */						
		public var MagicInit:int;			/** 初始身法资质 */
		
		public var Force:int;				/** 力量 */					
		public var SpiritPower:int;			/** 灵力 */					
		public var Physical:int;			/** 体力 */					
		public var Constant:int;			/** 定力 */					
		public var Magic:int;				/** 身法 */					
		
		public var ForceApt:int;			/** 力量资质 */					
		public var SpiritPowerApt:int;		/** 灵力资质 */					
		public var PhysicalApt:int;			/** 体力资质 */					
		public var ConstantApt:int;			/** 定力资质 */					
		public var MagicApt:int;			/** 身法资质 */		
		
		public var PhyAttack:int;			/** 外攻 */
		public var MagicAttack:int;			/** 内攻 */
		public var PhyDef:int;				/** 外防 */
		public var MagicDef:int;			/** 内防 */
		
		public var Hit:int;					/** 命中 */
		public var Hide:int;				/** 躲闪 */
		public var Crit:int;				/** 暴击 */
		public var Toughness:int;			/** 坚韧 */
		public var  dwFaery_security:int;/** 仙抗 */
		public var  dwGoblin_security:int;/** 妖抗 */
		public var  dwTao_security:int;/** 道抗 */
		
		public var rear_value_hp:int;					/** 训练气血球 */
		public var rear_value_mp:int;				/** 训练法力球 */
		public var rear_value_attack:int;				/** 训练攻击球*/
		public var rear_value_security:int;			/** 训练防御球 */
		public var rear_value_hit:int;					/**训练命中球  */
		public var rear_value_jink:int;				/** 训练闪避球 */
		public var rear_value_crit:int;				/** 训练暴击球 */
		public var rear_value_toughness:int;			/** 训练坚韧球 */
		
		public var rear_culture_value:int;				/** 当前培养值 */
		public var rear_culture_Maxvalue:int;			/** 培养条最大值 */
		public var culture_Item_num:int;			/** 需消耗的培养丹 */
		
		public var HP_Add:int;                     /** 气血成长值 */
		public var MP_Add:int;/** 法力成长值 */
		public var Attack_Add:int;/** 攻击成长值 */
		public var Security_Add:int;/** 防御成长值 */
		public var Hit_add:int;/** 命中成长值 */
		public var Jink_add:int;/** 闪避成长值 */
		public var Crit_add:int;/** 暴击成长值 */
		public var Toughness_add:int;/** 韧性成长值 */
		
		public var RearTimes:int;/** 池水满训练总次数 */
		public var SpareRearTimes:int;/** 最大池水满训练次数 */
		
		public var Rear_hp_times:int;/** 气血池最大训练次数 */
		public var Rear_mp_times:int;/** 魔法池最大训练次数 */
		public var Rear_attack_times:int;/** 攻击池最大训练次数 */
		public var Rear_security_times:int;/** 防御池最大训练次数 */
		public var Rear_hit_times:int;/** 命中池最大训练次数 */
		public var Rear_jink_times:int;/** 闪避池最大训练次数 */
		public var Rear_crit_times:int;/** 暴击池最大训练次数 */
		public var Rear_toughness_times:int;/** 韧性池最大训练次数 */
		public var equipment_necklace:int; /** 宠物装备项链 */
		public var equipment_weapon:int; /** 宠物装备武器 */
		public var equipment_ring:int; /** 宠物装备戒子 */
		public var equipment_shoe:int; /** 宠物装备鞋子*/
		public var equipment_sign:int; /** 宠物装备合体符 */
		public var Rear_ball_1:int;
		public var Rear_ball_2:int;
		public var Rear_ball_3:int;
		
		public var Potential:int;			/** 潜力值 */
		public var Points:Array = [0, 0, 0, 0, 0];	/** 临时加点 力量、灵力、体力、定力、身法 */
		public var BuffList:Array = [];		/** Buff列表 */
		
		public var Price:uint = 0;			/** 宠物售价 */
		public var IsLock:Boolean = false;	/** 是否锁定 */
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////
		//如需加东西，加在下面
		public var PetSkinName:String;      /** 宠物外貌*/ 		
		public var SkillLevel:Array = []; 	/** 技能信息列表(里面是对象是 技能信息对象 技能等级)**/ 
		
		//新加属性
		public var winning:int;					/**灵性*/
		public var privity:int;					/**默契*/
		public var isFantasy:Boolean;			/**是否幻化*/
		public var playNumber:int;				/**玩耍数量*/
		
	}
}
