package OopsEngine.Skill
{
	import OopsFramework.Content.Provider.BulkLoaderResourceProvider;
	
	import flash.display.BlendMode;
	
	/** 游戏人物技能（管理技能效果、技能影响、影响的目标数量 */ 
	public class GameSkill
	{
		/** 目标HP变化  */
		public static const TARGET_HP 		     : String = "target_hp";
		/** 目标HP暴击变化  */
		public static const TARGET_ERUPTIVE_HP   : String = "target_eruptive_hp";
		/** 目标死亡变化  */
		public static const TARGET_DEAD          : String = "target_dead";
		/** 目标闪避  */
		public static const TARGET_EVASION       : String = "target_evasion";
		/** 目标吸收  */
		public static const TARGET_SUCK          : String = "target_suck";
		/*目标免疫*/
		public static const TARGET_IMMUNE		:String = "target_immune";
		/** 目标改变移动速度  */
		public static const TARGET_SPEED          : String = "target_speed";

		/* -------------------------------------------------- */
		
		/**获取技能所造成的伤害状态*/
		public static function GetSkillState(nstate:int):String
		{
			var state:String = "";
			switch(nstate)
			{
				case (0):state = TARGET_HP; break;
				case (1):state = TARGET_EVASION;break;
				case (2):state = TARGET_ERUPTIVE_HP;break;
				         
			}	
			return state;
		}
			
		/** 技能编号 */
		public var SkillID:int;
		/** 技能名 */
		public var SkillName:String;
	    /** 技能说明*/
		public var SkillReamark:String;			
		/**职业编号*/
		public var Job:int;  // -1 普通所有  然后按职业编写
		private var _skillIcon:String = "";
		public function get skillIcon():String{
			if(_skillIcon == ""){
				if(this.Job != 99)
					_skillIcon = String(this.SkillID).substr(0,3)+"01";
				else
					_skillIcon  = String(this.SkillID);
			}
			return _skillIcon;	
		}
	    /** 学习需要等级*/
        public var NeedLevel:int;
		/** 技能攻击距离 */
		public var Distance:Number;
		/** 技能飞行效果动画 */
		public var Effect:String;
		/**攻击效果动画**/
	    public var StartEffect:String;
		/** 技能击中后动画*/
		public var HitEffect:String;
		/** 经验等级*/
        public var Exp:int;
		/** 技能模式*/
	    public var SkillMode:int;
	    /** 技能范围*/
	    public var SkillArea:int;
        /** 书的编号*/
        public var BookID:int;
        /** BUFF 编号**/
        public var Buff:int;
        /** 怒气*/
        public var SP:int;
		/** 技能冷却时间 */
		public var CoolTime:int;
		/** 技能冷却时间增值 */
		public var LevelCoolTime:Number;
	    /** 技能消耗基础蓝*/
        public var MP:int;
        /** 每级增加蓝的基数*/
        public var LevelMP:int;
		/** 攻击基础伤害*/
		public var Attack:int;
		/** 攻击增值伤害*/
		public var LevelAttack:Number;
		
		//add new p
		/** 技能等级*/
		public var SkillLv:int = 0;
		/** 技能最大等级*/
		public var maxSkillLv:int = 0;
		/**学习所需要技能ID*/
		public var needSkillId:int = 0;
		/**学习所需要技能ID等级*/
		public var needSkillLv:int = 0;
		/**下一级技能Id**/
		public var SkillNextId:int = 0;
		/**升级需要消耗的铜钱**/
		public var SkillUpGold:int = 0;
		/**升级需要消耗的经验**/
		public var SkillUpExp:int = 0;
		/** 增加怒气值 */
		public var SkillAddAng:int = 0; 
		/** 伤害 **/
		public var ExAttack:int = 0;
		/** 技能类型 1.主动 2.被动 3.BUFF技能**/ 
		public var SkillClass:int = 0; 
		
		/*技能攻击频率*/
		public var frequency:int = 0;
		private var _blendMode1:String = "";
		private var _blendMode2:String = "";
		private var _blendMode3:String = "";
		

		public function get blendMode1():String
		{
			if(_blendMode1 == "")
				_blendMode1 = BlendMode.NORMAL;
			return _blendMode1;
		}

		public function set blendMode1(value:String):void
		{
			_blendMode1 = value;
		}
		public function get blendMode2():String
		{
			if(_blendMode2 == "")
				_blendMode2 = BlendMode.NORMAL;
			return _blendMode2;
		}
		
		public function set blendMode2(value:String):void
		{
			_blendMode2 = value;
		}
		public function get blendMode3():String
		{
			if(_blendMode3 == "")
				_blendMode3 = BlendMode.NORMAL;
			return _blendMode3;
		}
		
		public function set blendMode3(value:String):void
		{
			_blendMode3 = value;
		}
	}
}