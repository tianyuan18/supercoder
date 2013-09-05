package OopsEngine.Skill
{
	import flash.utils.Dictionary;

	public class GameSkillMode
	{
		//被动技能(人物和宠物)                             0
		//普通近战(人物)                                  1
		//普通远战(人物)                                  2
		//宠物普通攻击                                         19
		
		//魔法近战单体(人物)                               3
		//魔法单体治疗(人物)对友方                              5
		//只能对自己释放的治疗                                  18
		//群加的治疗                                           32
		
		//远程单体魔法                                         4
		
		//BUFF单体技能对所有玩家                               6
		//BUFF单体技能只能是自己                               20
		
		//DOT单体技能减益                                     7	
		//DOT单体技能增益                                     9
		
		//宠物连续释放技能                                     11
		//宠物自动释放技能有动画（孙子）                        33
		//宠物Buff技能                                        12
		//宠物主动单体释放技能                                 14
		
		//以人为中心放群伤                                     13
		//以人选地为中心放群伤                                 15
		//选定目标为中心放群伤                                 21
			
		//以宠物为中心放群                                     16
		//以宠物选地为中心放群攻击                              17
		//以宠物自身放群治疗                                    26
		
		//瞬移技能                                            22
		//刷CD                                         23
		//击退                                               27
		//背刺                                               28
		//无敌斩                                             29		
		//回城                                               24
		//坐骑                                               25
		
		//多重箭 多个飞弹                                     30
		//退后 远程 攻击                                      31	
	    //大面积魔法                                         40
		
		public static var SkillModeList:Dictionary = new Dictionary();
		
		//是否是抖动技能
		public static function IsDither(SkillID:int):Boolean
		{
			return true;
		}
		
		
		//是否是DOT加血技能
		public static function IsAddHp(SkillID:int):Boolean
		{
			if(SkillID == 1404)
			{
				return true;
			}		
			return false;
		}
		
		//是否是回蓝技能
		public static function IsAddMp(SkillID:int):Boolean
		{
			if(SkillID == 1142)
			{
				return true;
			}
			return false;
		}
		
		//必须播放的动画
		public static function IsPlay(nModeID:int):Boolean
		{	
			var sm:SkillModeVO = SkillModeList[nModeID] as SkillModeVO;
			if(sm.action == 0)
				return false;
			else
				return true;
		}
		
		/**是否需要再次锁定追击目标**/
		public static function IsAddTarget(nModeID:int):Boolean
		{
			var sm:SkillModeVO = SkillModeList[nModeID] as SkillModeVO;
			return Boolean(sm.selectAginTarget);
		}
		
		/**是否是宠物技能**/
		public static function IsPetSkill(nModeID:int):Boolean
		{
			var sm:SkillModeVO = SkillModeList[nModeID] as SkillModeVO;
			return Boolean(sm.petSkill);
		}

        /**是否显示技能名称*/
	    public  static  function  IsShowSkillName(nModeID:int):Boolean
	    { 
			var sm:SkillModeVO = SkillModeList[nModeID] as SkillModeVO;
			return Boolean(sm.displayName); 
	    }
	    
	    /**是否普通攻击*/
	    public static function IsCommon(nModeID:int):Boolean
	    { 
			var sm:SkillModeVO = SkillModeList[nModeID] as SkillModeVO;
			return Boolean(sm.defaultSkill);
	    }
	    
	    /***是否是单体治疗**/
	    public static function IsSingleDoctorSkill(nModeID:int):Boolean
	    {
			var sm:SkillModeVO = SkillModeList[nModeID] as SkillModeVO;
			return Boolean(sm.treat); 
	    }
	    
	    /**是否治疗技能  用于判断是红字显示 还是绿字显示*/
	    public  static  function  IsDoctorSkill(nModeID:int):Boolean
	    { 
			var sm:SkillModeVO = SkillModeList[nModeID] as SkillModeVO;
			return Boolean(sm.colorTreat); 
	    }
	    
	    /**是否是宠物Buff技能 发送的协议不一样 用于判断宠物以上线就刷的BUFF*/
	    public  static  function  IsPetBuffSkill(nModeID:int):Boolean
	    { 
			var sm:SkillModeVO = SkillModeList[nModeID] as SkillModeVO;
			return Boolean(sm.petBuffSkill);
	    }
	    
	    /**是否是人物BUFF技能**/
	    public  static  function  IsPersonBuffSkill(nModeID:int):Boolean
	    { 
			var sm:SkillModeVO = SkillModeList[nModeID] as SkillModeVO;
			return Boolean(sm.buffSkill); 
	    }
	    
	    /**可以对队友释放 并且可以对自己释放的群治疗 挂机使用**/
	    public static function UseTeamSkill(nModeID:int):Boolean
	    {
			var sm:SkillModeVO = SkillModeList[nModeID] as SkillModeVO;
			return Boolean(sm.teamSkill); 
	    }
	       
	    /**返回打击方式  发送的协议的参数不一样**/  // 1 指定玩家  2 以自身为基点释放群 3 以点释放群 4 为友方加BUff  5 只能对自己释放的魔法  6 只能对自己的buff 7要带方向
	    public static function Affect(nModeID:int):int
	    {
			var sm:SkillModeVO = SkillModeList[nModeID] as SkillModeVO;
			return sm.skillEffect
	    }
	    
	    
	    /**该技能是否存在目标(单体攻击与群体攻击的判断)*/ // 1 指定玩家伤害  2 只能对自己释放 3 宠物只能对主人释放  4 群放魔法不需要判断 5 只能对玩家释放
	    public static function TargetState(nModeID:int):int
	    { 
			var sm:SkillModeVO = SkillModeList[nModeID] as SkillModeVO;
			return sm.selectTarget
	    }
	    
	    /**宠物是否是自动释放技能**/
	    public static function IsPetAutomatism(nModeID:int):Boolean
	    { 
			var sm:SkillModeVO = SkillModeList[nModeID] as SkillModeVO;
			return Boolean(sm.autoPet); 
	    }
	    
	    /**人物是否是自动释放技能**/
	    public static function IsPersonAutomatism(nModeID:int):Boolean
	    { 
			var sm:SkillModeVO = SkillModeList[nModeID] as SkillModeVO;
			return Boolean(sm.autoRole); 
	    }
	    
	    /**获取挂机技能处理状态**/
	    public static function GetAutomatismState(nModeID:int):int
	    { 
	    	//攻击模式 1 BUFF模式 2 治疗模式 3
	    	var state:int = 1;
	    	
	    	//是否是BUFF
	    	if(IsPersonBuffSkill(nModeID))
	    	{
	    		state = 2;
	    	}
	    	
	    	if(IsDoctorSkill(nModeID))
	    	{
	    		state = 3;
	    	}
	    	
	    	return state;    	
	    }
	    
	    /**判断宠物技能是否可以拖动**/
	    public static function IsPetPull(nModeID:int):Boolean
	    {
			var sm:SkillModeVO = SkillModeList[nModeID] as SkillModeVO;
			return Boolean(sm.dragPetSkill);
	    }
	    
	    /**技能受击打也许没对象**/
	    public static function IsNoTarget(nModeID:int):Boolean
	    {
//	      if(nModeID != 13 && nModeID != 15 && nModeID != 16 && nModeID != 17 && nModeID != 22 && nModeID != 23 && nModeID != 24 && nModeID != 26
//	      && nModeID != 40)
//	       	 return  false;
//	       else
	         return  true;
	    }
	    
	    /**修改朝向**/
	    public static function IsNoChangeDir(nModeID:int):Boolean
	    {
			var sm:SkillModeVO = SkillModeList[nModeID] as SkillModeVO;
			return Boolean(sm.direction);
	    }
	    
	    /**是否显示地效图标**/
	    public static function IsShowRect(nModeID:int):Boolean
	    {	      
			var sm:SkillModeVO = SkillModeList[nModeID] as SkillModeVO;
			return Boolean(sm.rect);    
	    }
	}
}