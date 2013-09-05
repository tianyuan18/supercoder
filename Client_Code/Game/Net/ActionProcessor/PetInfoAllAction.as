package Net.ActionProcessor
{
	import Controller.PetController;
	
	import GameUI.Modules.Pet.Data.PetEvent;
	import GameUI.Modules.Pet.Data.PetPropConstData;
	import GameUI.Proxy.DataProxy;
	
	import Net.GameAction;
	
	import OopsEngine.Role.GamePetRole;
	import OopsEngine.Skill.GameSkill;
	import OopsEngine.Skill.GameSkillLevel;
	
	import flash.utils.ByteArray;

	public class PetInfoAllAction extends GameAction
	{
		private var dataProxy:DataProxy;
		
		public function PetInfoAllAction(isUsePureMVC:Boolean=true)
		{
			super(isUsePureMVC);
			dataProxy = facade.retrieveProxy(DataProxy.NAME) as DataProxy;
		}
		
		/**  处理接收到的消息 宠物详细信息查询*/
		public override function Processor(bytes:ByteArray):void 
		{
		 	bytes.position = 4;
		 	var eudemoninfo:GamePetRole = new GamePetRole();	
		 	
			eudemoninfo.Id = bytes.readUnsignedInt();				//id
		 	eudemoninfo.OwnerId = bytes.readUnsignedInt();			//拥有者ID
		 	eudemoninfo.ClassId = bytes.readUnsignedInt();			//类型 兔子 
		 	eudemoninfo.TakeLevel = bytes.readUnsignedInt();		//携带等级（需人物达到该等级才可携带）
		 	eudemoninfo.HpNow = bytes.readUnsignedInt();			//HP
			eudemoninfo.HpMax = bytes.readUnsignedInt();			//HPmax
			eudemoninfo.MpNow = bytes.readUnsignedInt();			//MP
			eudemoninfo.MpMax = bytes.readUnsignedInt();			//MPmax
			eudemoninfo.EnergyNow = bytes.readUnsignedInt();			//精力
			eudemoninfo.EnergyMax = bytes.readUnsignedInt();			//精力最大值
		 	eudemoninfo.ExpNow = bytes.readUnsignedInt();			//当前经验
			eudemoninfo.ExpMax = bytes.readUnsignedInt();			//当前经验
		 	
		 	eudemoninfo.FaceType = bytes.readUnsignedInt();		//头像
			eudemoninfo.Quality = bytes.readUnsignedInt();		//品质

		 	eudemoninfo.Level = bytes.readUnsignedInt();			//等级
		 	eudemoninfo.Type = bytes.readUnsignedInt();			//类型 0野生 1宝宝 2二代

		 	eudemoninfo.State = bytes.readUnsignedInt();			//状态  休息 战斗中
		 	eudemoninfo.Sex = bytes.readUnsignedInt();		 	//性别
   
		 	eudemoninfo.Appraise = bytes.readUnsignedInt();			//评价  评分

		 	
		 	eudemoninfo.PhyAttack = bytes.readUnsignedInt();		//普攻
		 	eudemoninfo.PhyDef = bytes.readUnsignedInt();		//普防
           eudemoninfo.Hit = bytes.readUnsignedInt();				//命中
		 	eudemoninfo.Hide = bytes.readUnsignedInt();				//躲闪
		 	eudemoninfo.Crit = bytes.readUnsignedInt();				//暴击
		 	eudemoninfo.Toughness = bytes.readUnsignedInt();		//坚韧
			eudemoninfo.dwFaery_security = bytes.readUnsignedInt();			//仙抗
			eudemoninfo.dwGoblin_security = bytes.readUnsignedInt();			//妖抗
		 	eudemoninfo.dwTao_security = bytes.readUnsignedInt();			//道抗
		 	
			eudemoninfo.rear_value_hp = bytes.readUnsignedInt();		//气血球
			eudemoninfo.rear_value_mp = bytes.readUnsignedInt();		//发力球
			eudemoninfo.rear_value_attack = bytes.readUnsignedInt();				//攻击球
			eudemoninfo.rear_value_security = bytes.readUnsignedInt();				//防御球
			eudemoninfo.rear_value_hit = bytes.readUnsignedInt();		//命中球
			eudemoninfo.rear_value_jink = bytes.readUnsignedInt();		//闪避球
			eudemoninfo.rear_value_crit = bytes.readUnsignedInt();				//暴击球
			eudemoninfo.rear_value_toughness = bytes.readUnsignedInt();				//韧性球
			eudemoninfo.rear_culture_value = bytes.readUnsignedInt();				///** 当前培养值 */
			eudemoninfo.rear_culture_Maxvalue = bytes.readUnsignedInt();				///** 培养条最大值 */
			eudemoninfo.culture_Item_num = bytes.readUnsignedInt();	//需消耗的培养丹 
			
			eudemoninfo.HP_Add = bytes.readUnsignedInt();
			eudemoninfo.MP_Add = bytes.readUnsignedInt();
			eudemoninfo.Attack_Add = bytes.readUnsignedInt();
			eudemoninfo.Security_Add = bytes.readUnsignedInt();
			eudemoninfo.Hit_add = bytes.readUnsignedInt();
			eudemoninfo.Jink_add = bytes.readUnsignedInt();
			eudemoninfo.Crit_add = bytes.readUnsignedInt();
			eudemoninfo.Toughness_add = bytes.readUnsignedInt();
			
			eudemoninfo.RearTimes = bytes.readUnsignedInt();
			eudemoninfo.SpareRearTimes = bytes.readUnsignedInt();
			
			eudemoninfo.Rear_hp_times = bytes.readUnsignedInt();
			eudemoninfo.Rear_mp_times = bytes.readUnsignedInt();
			eudemoninfo.Rear_attack_times = bytes.readUnsignedInt();
			eudemoninfo.Rear_security_times = bytes.readUnsignedInt();
			eudemoninfo.Rear_hit_times = bytes.readUnsignedInt();
			eudemoninfo.Rear_jink_times = bytes.readUnsignedInt();
			eudemoninfo.Rear_crit_times = bytes.readUnsignedInt();
			eudemoninfo.Rear_toughness_times = bytes.readUnsignedInt();
			
			eudemoninfo.equipment_necklace = bytes.readUnsignedInt();
			eudemoninfo.equipment_weapon = bytes.readUnsignedInt();
			eudemoninfo.equipment_ring = bytes.readUnsignedInt();
			eudemoninfo.equipment_shoe = bytes.readUnsignedInt();
			eudemoninfo.equipment_sign = bytes.readUnsignedInt();
		 	//if(eudemoninfo.Type != 1) eudemoninfo.BreedMax = 0;
//		 	
			var skillNum:int;
//			if(PetPropConstData.isNewPetVersion)
//			{
//				skillNum = 10;
//			}
//			else
//			{
				skillNum = 3;
//			}
		 	for(var j:int = 0; j < skillNum; j++) {
		 		 var skill:uint =  bytes.readUnsignedInt();
		 		 if(PetPropConstData.isNewPetVersion)
		 		 {
			 		 if(skill == 0 || skill == 99999)		//第一个技能格子，始终放主动技能（或回血，回蓝），没有就空着
			 		 {
//			 		 	if(j == 0) 
//			 		 	{
						 eudemoninfo.SkillLevel.push(skill);
//			 		 	}
			 		 }
			 		 else
			 		 {  
			 		 	var idNew:int = skill/1000;
	//		 		 	var lev:int = skill % 100;
					 	var gameSkillNew:GameSkill = GameCommonData.SkillList[idNew] as GameSkill;
					 	var gameSkillLevelNew:GameSkillLevel = new GameSkillLevel(gameSkillNew);
					 	gameSkillLevelNew.Level = eudemoninfo.Level;//lev;
					 	eudemoninfo.SkillLevel.push(gameSkillLevelNew);
			 		 }
		 		 }
		 		 else
		 		 {
		 		 	if(skill != 0)
		 		 	{
			 		 	var id:int = skill/1000;
	//		 		 	var lev:int = skill % 100;
					 	var gameSkill:GameSkill = GameCommonData.SkillList[id] as GameSkill;
					 	var gameSkillLevel:GameSkillLevel = new GameSkillLevel(gameSkill);
					 	gameSkillLevel.Level = eudemoninfo.Level;//lev;
					 	eudemoninfo.SkillLevel.push(gameSkillLevel);
		 		 	}
		 		 }
		 	}
		 	
		 	var nDataSeeNum:int = bytes.readByte();
			var nDataSee:int = 0;				
			for(var i:int = 0;i < nDataSeeNum; i++)
			{
				nDataSee = bytes.readByte();
				if(nDataSee != 0)
				{
					if(i == 0)
					{
						eudemoninfo.PetName = bytes.readMultiByte(nDataSee ,GameCommonData.CODE); //名字
					}
				}
			}
			if(eudemoninfo.OwnerId == GameCommonData.Player.Role.Id) {
				if(GameCommonData.Player.Role.PetSnapList[eudemoninfo.Id]) GameCommonData.Player.Role.PetSnapList[eudemoninfo.Id] = eudemoninfo;
				GameCommonData.Player.Role.PetList[eudemoninfo.Id] = eudemoninfo;
			} 
			if(eudemoninfo.State == 1 && eudemoninfo.OwnerId == GameCommonData.Player.Role.Id) { //自己的宠物出战
				GameCommonData.Player.Role.UsingPet = eudemoninfo;
				sendNotification(PetEvent.PET_TO_FIGHT_AFTER_GETINFO);
				PetController.BuffUseSkill();
			}
			//普通查询详细信息
			sendNotification(PetEvent.RETURN_TO_SHOW_PET_INFO, eudemoninfo);
		}
		
	}
}