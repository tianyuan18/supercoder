package Controller
{
	import GameUI.UIUtils;
	
	import Net.ActionSend.Zippo;
	
	import OopsEngine.Role.GameRole;
	import OopsEngine.Scene.StrategyElement.GameElementAnimal;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	
	public class CombatController
	{
		public static var attackTime:Number = 0;
	    public static var skillTime:Number = 0;
		public var INTERACT_ATTACK:int = 2;		// （普通攻击）
		public var INTERACT_SHOOT:int  = 21;	// （魔法攻击）		
		
		/** 人上坐骑  */
		public function ReserveMount(Mount:int):void
		{
			Zippo.SendAttack(GameCommonData.Player.Role.Id,
							 Mount,
							 0,
							 0,
							 300);
		}
		
		/** 人的普通攻击  */
		public function ReserveAttack(targetAnimal:GameElementAnimal):void
		{
			if(GameCommonData.Player.Role.HP > 0)
			{
				var date:Date = new Date();
				if(date.time - attackTime < 2000 
				&& GameCommonData.Player.IsAutomatism == false)
				{
					return;
				}
				attackTime = date.time;			
				Zippo.SendAttack(GameCommonData.Player.Role.Id,
								 targetAnimal.Role.Id,
								 0,
								 0,
								 INTERACT_ATTACK);						 
			}
		}

		/** 宠物普通攻击  */
		public function PetReserveAttack(targetAnimal:GameElementAnimal):void
		{
			//宠物不能走
			Zippo.SendAttack(GameCommonData.Player.Role.UsingPetAnimal.Role.Id,
							 targetAnimal.Role.Id,
							 0,
							 0,
							 INTERACT_ATTACK);
		}
		
		/**以人物为范围**/
		public function ReserveAffectSkillAttack(skill:int,level:int,targetAnimal:GameElementAnimal):void
		{	
			if(targetAnimal.Role.HP > 0)
			{	
				Zippo.SendSkill(targetAnimal.Role.Id,
								targetAnimal.Role.Id,
			                    0,
								0,
								INTERACT_SHOOT,
								skill,level);
			}
		
		}
		
		/**以点为范围**/
		public function ReservePointAffectSkillAttack(skill:int,level:int,point:Point):void
		{
		    Zippo.SendSkill(GameCommonData.Player.Role.Id,
		                    0,
		                    point.x,
							point.y,
							INTERACT_SHOOT,
							skill,level);
		}
		

		/**人物选中目标的技能**/
		public function ReserveSkillAttack(skill:int,level:int,targetAnimal:GameElementAnimal):void
		{
			if(GameCommonData.Player.Role.HP > 0)
			{	
				var date:Date = new Date();
				if(date.time - CombatController.skillTime < 500)
				{
					return;							
				}
				CombatController.skillTime = date.time;			

			    Zippo.SendSkill(GameCommonData.Player.Role.Id,
			                    targetAnimal.Role.Id,
			                    0,
								0,
								INTERACT_SHOOT,
								skill,level);					
			}
							
//			// 如果攻击者不是自己
//			if(GameCommonData.Player.Role.Id != targetAnimal.Role.Id)	
//			{			
//				ReserveAttack(targetAnimal);
//			}
		}
		
		/**宠物选中目标的技能**/
		public function ReservePetSkillAttack(skill:int,level:int,targetAnimal:GameElementAnimal):void
		{
		    Zippo.SendSkill(GameCommonData.Player.Role.UsingPetAnimal.Role.Id,
		                    targetAnimal.Role.Id,
		                    0,
							0,
							INTERACT_SHOOT,
							skill,level);
		}
		
	    /**宠物自身为范围**/
		public function ReservePetAffectSkillAttack(skill:int,level:int):void
		{
		    Zippo.SendSkill(GameCommonData.Player.Role.UsingPetAnimal.Role.Id,
		                    0,
		                    0,
							0,
							INTERACT_SHOOT,
							skill,level);
		}
		
	    /**宠物点地为范围**/
		public function ReservePetPointAffectSkillAttack(skill:int,level:int,point:Point):void
		{
		    Zippo.SendSkill(GameCommonData.Player.Role.UsingPetAnimal.Role.Id,
		                    0,
		                    point.x,
							point.y,
							INTERACT_SHOOT,
							skill,level);
		}
		
		/**人的BUFF**/
	    public function ReserveBuffSkillAttack(skill:int,level:int,targetAnimal:GameElementAnimal):void
		{
			if(GameCommonData.Player.Role.HP > 0)
			{	
				var date:Date = new Date();
				if(date.time - CombatController.skillTime < 1000)
				{
					return;							
				}
				
			    Zippo.SendBuffSkill(GameCommonData.Player.Role.Id,
			                    targetAnimal.Role.Id,
			                    0,
								0,
								INTERACT_SHOOT,
								skill,level);
			}
		}
		
		public function ReserveDirSkillAttack(skill:int,level:int,targetAnimal:GameElementAnimal):void
		{
		    Zippo.SendSkill(GameCommonData.Player.Role.Id,
		                    0,
		                    0,
							0,
							INTERACT_SHOOT,
							skill,level, GameCommonData.Player.Role.Direction);
		}
		
		/**宠物的buff**/
		 public function ReservePetBuffSkillAttack(skill:int,level:int,targetAnimal:GameElementAnimal):void
		{
			if(GameCommonData.Player.Role.UsingPetAnimal != null)
			{
			    Zippo.SendBuffSkill(GameCommonData.Player.Role.UsingPetAnimal.Role.Id,
			                    targetAnimal.Role.Id,
			                    0,
								0,
								INTERACT_SHOOT,
								skill,level);
			}
		}
		
		/** 回复HP提示  */
		public static function RestoreHPPrompt(target:DisplayObject, hp:int):void
		{
			Prompt(target,"",1,hp,"jxCBM");
		}
		
		/** 回复MP提示  */
		public static function RestoreMPPrompt(target:DisplayObject, hp:int):void
		{
//			Prompt(target, hp.toString(), "CombatPrompt_Right_Magic");
		}	
		
				
		/**
		 * 攻击掉血 
		 * @param target 对象
		 * @param hp 影响的HP
		 * @param isCriticalHit 是否暴击
		 * @param point
		 * 
		 */		
		public static function AttackPrompt(target:DisplayObject, hp:int,isCriticalHit:Boolean,point:Point=null):void
		{
			if(isCriticalHit)
			{
				Prompt(target,"bjZHCBM",0,hp,"bjCBM");
			}
			else
			{
				Prompt(target,"",2,hp,"shCBM");
			}
		}
		
		/** 被攻击提示  */
		public static function ByAttackPrompt(target:DisplayObject, hp:int,isCriticalHit:Boolean,point:Point=null):void
		{
			if(isCriticalHit)
			{
				Prompt(target,"bjZHCBM",0,hp,"bjCBM");
			}
			else
			{
				Prompt(target,"",2,hp,"ssCBM");
			}
		}
		
		
		/** 攻击目标提示扣血提示 */
		public static function PetAttackPrompt(target:DisplayObject, hp:int,isCriticalHit:Boolean,point:Point=null):void
		{
			if(isCriticalHit)
			{
				Prompt(target,"bjZHCBM",0,hp,"bjCBM");
			}
			else
			{
				Prompt(target,"",2,hp,"shCBM");
			}
		}
		
		
		/** 闪避 */
		public static function EvasionPrompt(target:DisplayObject):void
		{
			Prompt(target,"sbZHCBM",0,0,"");
		}
		
		/** 吸收 */
		public static function SuckPrompt(target:DisplayObject):void
		{
			//暂时用闪避代替
			Prompt(target,"sbZHCBM",0,0,"");
		}
		
		/** 加速  */
		public static function SpeedPrompt(target:DisplayObject,speed:int):void
		{
			
			//加速暂时去掉。没有任何提示
//			Prompt(target, GameCommonData.wordDic["con_com_speed_1"], "CombatPrompt_Left_Evasion"); // 吸收
		}
		
		/**技能提示*/
		public static function Skill(target:DisplayObject,text:String):void
		{
			//Prompt(target, text, "CombatPrompt_UP_Skill");		
		}
		
	    /**加血提示*/
		public static function SkillAddHP(target:DisplayObject,text:String,px:int,py:int):void
		{
			Prompt(target,"",1,int(text),"jxCBM");
		}

		
		/**
		 * 显示战斗文字效果
		 * @param target 目标对象。
		 * 暴击 - 1000
		 * @param mainTxt 代表最前面显示的文字 
		 * @param type 代表+ - 号，0为没有 1：+ 2：-
		 * @param num 后面跟的数值
		 * @param numText 获取数字的资源文件前缀
		 * 
		 */		
		public static function Prompt(target:DisplayObject,mainTxt:String,type:int,num:int,numText:String):void
		{
			var role:GameElementAnimal = target as GameElementAnimal;	
			if(role.Role.idMonsterType >= 300 && role.Role.idMonsterType < 500){//采集，没有任何提示
				return;
			}
			var moiveName:String = "";
			//根据主文字显示，获取不同的动画播放类型
			if(mainTxt == "sbZHCBM"){//闪避
				moiveName = "sbMovieDis";
			}else if(mainTxt == "bjZHCBM"){
				moiveName = "bjMovieDis";
			}else{
				moiveName = "ptMovieDis";
			}
			
			var contentSp:Sprite = createNumMc(mainTxt,type,num,numText);
			
			
			
			var moiveDis:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip(moiveName);
			(moiveDis.inMc as MovieClip).addChild(contentSp);
			GameCommonData.GameInstance.GameScene.GetGameScene.TopLayer.addChild(moiveDis);
			moiveDis.x = target.x+40;
			moiveDis.y = target.y-12;
			
			role.updateBloodItem();
		}

		/**
		 * 构建显示文字SP 
		 * 暴击 - 1000
		 * @param mainTxt 代表最前面显示的文字 
		 * @param type 代表+ - 号，0为没有 1：+ 2：-
		 * @param num 后面跟的数值
		 * @param numText 获取数字的资源文件前缀
		 * @return 
		 * 
		 */		
		private static function createNumMc(mainTxt:String,type:int,num:int,numText:String):Sprite{
			var all:Array = new Array();
			if(num != 0){
				var strs:Array = UIUtils.getCharByStr(num.toString());
				for (var i:int = 0; i < strs.length; i++) 
				{
					all.push(numText+""+strs[i]);
				}
				if(numText != ""){
					switch(type){
						case 1:
							all.unshift(numText+"+");
							break;
						case 2:
							all.unshift(numText+"-");
							break;
					}
				}
			}
			if(mainTxt != "")
				all.unshift(mainTxt);
			return UIUtils.getFlashText(all);
		}
	}
}
