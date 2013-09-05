package GameUI.Modules.HeroSkill.SkillConst
{
	import Controller.SceneController;
	
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Hint.Events.HintEvents;
	import GameUI.Modules.MainSence.Data.QuickBarData;
	import GameUI.Modules.MainSence.Mediator.MainSenceMediator;
	import GameUI.Modules.MainSence.Proxy.QuickGridManager;
	import GameUI.Modules.UnityNew.Data.NewUnityCommonData;
	import GameUI.UICore.UIFacade;
	import GameUI.View.items.UseItem;
	
	import Net.ActionSend.PlayerActionSend;
	import Net.Protocol;
	
	import OopsEngine.Role.RoleJob;
	import OopsEngine.Skill.GameSkill;
	import OopsEngine.Skill.GameSkillLevel;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class SkillData
	{
		public static var isLifeSeeking:Boolean = false;					//是否正在采集生活技能
		public static var aMainSkillObj:Array = [];							//主职业面板技能信息
		public static var aViceSkillObj:Array = [];								//副职业面板技能信息
		public static var aNormalSkillObj:Array = [];						//普通面板技能信息
		public static var aUnitySkillObj:Array = [];
		
		public static var aMainSkillId:Array = [];
		public static var aViceSkillId:Array = [];
		public static var aNormalSkillId:Array = [];
		
		public static var aMainAutoIndex:Array = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]; 
		public static var aViceAutoIndex:Array = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
		public static var aUnityAutoIndex:Array = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]; 
		
		public static var aUnitySkillId:Array = [ 2101,2102,2103,2201,2202,2203,2301,2302,2303,2401,2402,2403 ];
		public static var aGreenSkillId:Array = [ 2101,2102,2103 ];								//青龙堂技能id
		public static var aWhiteSkillId:Array = [ 2201,2202,2203 ];								//白虎堂
		public static var aRedSkillId:Array = [ 2301,2302,2303 ];									//朱雀堂
		public static var aXuanSkillId:Array = [ 2401,2402,2403 ];								//玄武堂
		
		
		/**  人物当前职业等级   */
		public static var curJobLevel:uint = (GameCommonData.Player.Role.RoleList [GameCommonData.Player.Role.CurrentJob-1] as RoleJob).Level;
		public static var curJob:int =  (GameCommonData.Player.Role.RoleList [GameCommonData.Player.Role.CurrentJob-1] as RoleJob).Job;
		
		//根据技能id取等级
		public static function countSkillLevel( id:uint ):int
		{
			if ( !GameCommonData.Player.Role.SkillList[ id ] )
			{
				return 0;
			}
			else
			{
				return ( GameCommonData.Player.Role.SkillList[ id ] as GameSkillLevel ).Level;
			}
		}
		
		public static function addVipTail(vip:int):String
		{
			var str:String;
			switch ( vip )
			{
				case 0:
					str = "";
					break;
					
				case 1:
					str = "<font color='#0098FF'>[VIP]</font>";
					break;
					
				case 2:
					str = "<font color='#7a3fe9'>[VIP]</font>";
					break;
					
				case 3:
					str = "<font color='#FF6532'>[VIP]</font>";
					break;
					
				case 4:
					str = "<font color='#00FF00'>[VIP]</font>";
					break;
				
				default:
					break;
			}
			return str;
		}
		
		//使用生活技能
		public static function useLifeSkill(skillId:uint):void
		{
			
			if ( SkillData.isLifeSeeking )
			{
				return;
			}
			
			var mapId:String = GameCommonData.GameInstance.GameScene.GetGameScene.MapId.toString();
			var identify:String = mapId.slice(0,2);
			var mapLevel:uint = uint(mapId)%100;
			var skillLevel:uint = 0;
			if ( GameCommonData.Player.Role.LifeSkillList[skillId] )
			{
				skillLevel = ( GameCommonData.Player.Role.LifeSkillList[skillId] as GameSkillLevel ).Level;
			}
			
			switch(skillId)
			{
				case 6001:
					if ( identify != "11" )
					{
						UIFacade.UIFacadeInstance.ShowHint(GameCommonData.wordDic[ "mod_her_med_skillD_use_1" ]);//"这里不能伐木"
						return;
					}
					else
					{
						if ( skillLevel<mapLevel )
						{
							UIFacade.UIFacadeInstance.ShowHint(GameCommonData.wordDic[ "mod_her_med_skillD_use_2" ]);//"你的伐木技能等级不够，无法在此伐木"
							return;
						}
					}
				break;
				
				case 6002:
					if ( identify != "12" )
					{
						UIFacade.UIFacadeInstance.ShowHint(GameCommonData.wordDic[ "mod_her_med_skillD_use_3" ]);//"这里不能采矿"
						return;
					}
					else
					{
						if ( skillLevel<mapLevel )
						{
							UIFacade.UIFacadeInstance.ShowHint(GameCommonData.wordDic[ "mod_her_med_skillD_use_4" ]);//"你的采矿技能等级不够，无法在此采矿"
							return;
						}
					}
				break;
				
				case 6003:
					if ( identify != "13" )
					{
						UIFacade.UIFacadeInstance.ShowHint(GameCommonData.wordDic[ "mod_her_med_skillD_use_5" ]);//"这里不能狩猎"
						return;
					}
					else
					{
						if ( skillLevel<mapLevel )
						{
							UIFacade.UIFacadeInstance.ShowHint(GameCommonData.wordDic[ "mod_her_med_skillD_use_6" ]);//"你的狩猎技能等级不够，无法在此狩猎"
							return;
						}
					}
				break;
			}
			if ( GameCommonData.Player.Role.Ene <= 0 )
			{
				UIFacade.UIFacadeInstance.ShowHint(GameCommonData.wordDic[ "mod_her_med_skillD_use_7" ]);//"活力值不足，无法使用生活采集技能"
				return;
			}
			
			var obj:Object = new Object();
			var parm:Array = [];
			parm.push(0);
			parm.push(GameCommonData.Player.Role.Id);
			parm.push(0);
			parm.push(0);
			parm.push(0);
			parm.push(0);
			parm.push(282);							//发送采集消息
			parm.push(0);
			obj.type = Protocol.PLAYER_ACTION;
			obj.data = parm;
			PlayerActionSend.PlayerAction(obj);

		}
		
		public static function isCanPromote(limitLevel:uint):Boolean
		{
			var cJob:uint = (GameCommonData.Player.Role.RoleList [GameCommonData.Player.Role.CurrentJob-1] as RoleJob).Job;
//			trace("cjob:" +cJob);
			for ( var gSkill:* in GameCommonData.SkillList )
			{
				if ( ( (GameCommonData.SkillList[gSkill] as GameSkill).Job == cJob ) && ( (GameCommonData.SkillList[gSkill] as GameSkill).BookID == 0 ) )
				{
					var sId:int = (GameCommonData.SkillList[gSkill] as GameSkill).SkillID;
//					trace("jineng id :"+sId);
					if ( !GameCommonData.Player.Role.SkillList[sId] )
					{
						GameCommonData.UIFacadeIntance.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_her_med_skillD_isC_1" ]+limitLevel+GameCommonData.wordDic[ "mod_her_med_skillD_isC_2" ], color:0xffff00});//"所有技能等级达到"		"级才可继续提升职业等级"		
						return false;
					}
					else
					{
						if ( (GameCommonData.Player.Role.SkillList[sId] as GameSkillLevel).Level < limitLevel )
						{
//							trace("技能等级不够 :"+(GameCommonData.Player.Role.SkillList[sId] as GameSkillLevel).Level);
							GameCommonData.UIFacadeIntance.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_her_med_skillD_isC_1" ]+limitLevel+GameCommonData.wordDic[ "mod_her_med_skillD_isC_2" ], color:0xffff00});//"所有技能等级达到"		"级才可继续提升职业等级"		
							return false;
						}
					}
				}
			}
			return true;
		}
		
		//至少需要几个技能达到多少级
		public static function checkNumSkillLevel(num:uint,limitLevel:uint):Boolean
		{
			var cJob:uint = (GameCommonData.Player.Role.RoleList [GameCommonData.Player.Role.CurrentJob-1] as RoleJob).Job;
			var checkNum:uint=0;
			for ( var gSkill:* in GameCommonData.SkillList )
			{
				if ( ( (GameCommonData.SkillList[gSkill] as GameSkill).Job == cJob ) && ( (GameCommonData.SkillList[gSkill] as GameSkill).BookID == 0 ) )
				{
					var sId:int = (GameCommonData.SkillList[gSkill] as GameSkill).SkillID;
					if ( GameCommonData.Player.Role.SkillList[sId] &&
						  (GameCommonData.Player.Role.SkillList[sId] as GameSkillLevel).Level>=limitLevel )
						  {
						  	checkNum++;
						  	if ( checkNum >= num )
							{
								return true;
							}
						  }
				}
			}
			if ( checkNum < num )
			{
				GameCommonData.UIFacadeIntance.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_her_med_skillD_che_1" ]+"<font color='#ff0000'>"+num+"</font>"+GameCommonData.wordDic[ "mod_her_med_skillD_che_2" ]+"<font color='#ff0000'>"+limitLevel+"</font>"+GameCommonData.wordDic[ "mod_her_med_skillD_che_3" ], color:0xffff00});//至少	个技能达到	"级才可继续提升职业等级"		
				return false;
			}
			else
			{
				return true;
			}
		}
		
		public static function getUnityJob():String
		{
			var str:String;
			var res:String = GameCommonData.Player.Role.unityJob.toString();
			str = res.substr( res.length-1,1 );
			if ( str == "0" )
			{
				if ( res == "100" || res == "90" )
				{
					str = "all";
				}
				else
				{
					str = "noOne";
				}
			}
			return str; 
		}
		
		//传入一个帮派技能id，判断是否可提升
		public static function canPromtUnitySkill( id:int,addLevel:int = 0 ):Boolean
		{
			var gameSkill:GameSkill = GameCommonData.SkillList[ id ];
			if ( GameCommonData.Player.Role.Level < gameSkill.NeedLevel )		//人物等级是否足够
			{
				return false;
			}
			
			for ( var i:int=0; i<NewUnityCommonData.aUnitySkillId.length; i++ )
			{
				var arr:Array = NewUnityCommonData.aUnitySkillId[ i ];
				if ( arr.indexOf( id ) > -1 )
				{
					if ( NewUnityCommonData.unityPlaceLevelArr[i] <= 0 )			//分堂等级
					{
						return false;
					}
					else
					{
						if ( !GameCommonData.Player.Role.SkillList[ id ] )
						{
							return true;
						}
						else
						{
							var gameSkillLevel:GameSkillLevel = GameCommonData.Player.Role.SkillList[ id ];
							if ( gameSkillLevel.Level + addLevel < NewUnityCommonData.unityPlaceLevelArr[i]*10 ) 
							{
								return true;
							}
							else
							{
								return false;
							}
						}
					}
				}
			}
			return false;
		}
		
		/**
		 * 将学习完成的技能，添加到快捷栏当中 
		 * @param skillId
		 */		
		public static function skillLearnAddQuickItem(skillId:int):void{
			var mainSkillId:int = skillId + 1;
			var gameSkillVo:GameSkill = GameCommonData.SkillList[mainSkillId];
			var txtColor:uint = 0xFF3300;
			var skillTypeName:String = "";
			if(gameSkillVo.SkillClass == 1)//只有主动技能，才会添加到快捷栏
			{
				var dic:Dictionary = QuickBarData.getInstance().quickKeyDic;
				var dicF:Dictionary = QuickBarData.getInstance().expandKeyDic;
				
				var mainSenceMediator:MainSenceMediator = GameCommonData.UIFacadeIntance.retrieveMediator( MainSenceMediator.NAME ) as MainSenceMediator;
				var mainScene:MovieClip = mainSenceMediator.mainSence;
				//寻找可以添加的位置。
				var type:String = "quick";
				var index:int = 1;
				var toItemPos:MovieClip;
				for (var i:int = 0; i < 10; i++) 
				{
					if(dic[i] == null){
						index = i;
						toItemPos = mainScene.mcQuickBar0["quick_"+index]
						break;
					}
				}
				if(!toItemPos){
					for (i = 0 ; i < 10; i++) 
					{
						if(dicF[i] == null){
							type = "quickf";
							index = i;
							toItemPos = mainScene.mcQuickBar1["quickf_"+index]
							break;
						}
					}
				}
				var iii:UseItem = new UseItem(0,String(mainSkillId),GameCommonData.GameInstance.GameUI);
				iii.mouseChildren = false;
				iii.buttonMode = false;
				iii.name = "skillIcon";
				var toPoint:Rectangle = toItemPos.getBounds(GameCommonData.GameInstance.GameUI);
				
				var p:Point = UIConstData.getPos(34,34);
				iii.x = p.x;
				iii.y = p.y;
				GameCommonData.GameInstance.GameUI.addChild(iii);
				TweenLite.to(iii, 0.8,{
					x:toPoint.x,
					y:toPoint.y,
					onComplete:addMenuMoveOver,
					ease:Linear.easeNone
				});	
				function addMenuMoveOver():void{
					GameCommonData.GameInstance.GameUI.removeChild(iii);
					var quickGridManager:QuickGridManager = UIFacade.GetInstance(UIFacade.FACADEKEY).retrieveProxy(QuickGridManager.NAME) as QuickGridManager;
					var data:Object = {type:type,index:index,source:iii};
					quickGridManager.addUseItem(data);
				}
			}	
		}
	}
}