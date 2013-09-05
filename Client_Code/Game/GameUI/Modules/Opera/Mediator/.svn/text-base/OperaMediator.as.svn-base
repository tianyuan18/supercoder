package GameUI.Modules.Opera.Mediator
{
	import Controller.CopyController;
	import Controller.TalkController;
	
	import GameUI.ConstData.EventList;
	import GameUI.Modules.Chat.Command.HeadTalkCommand;
	import GameUI.Modules.Opera.Data.OperaConfig;
	import GameUI.Modules.Opera.Data.OperaEvents;
	import GameUI.Modules.Opera.View.PurdahPanel;
	
	import OopsEngine.AI.PathFinder.MapTileModel;
	import OopsEngine.Role.GameRole;
	import OopsEngine.Scene.StrategyElement.GameElementAnimal;
	import OopsEngine.Scene.StrategyElement.Person.GameElementEnemy;
	import OopsEngine.Scene.StrategyElement.Person.GameElementNPC;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class OperaMediator extends Mediator
	{
		public static const NAME:String = "OperaMediator";
		private var timeId:uint = 0;						//保存setTimeOut标示
		public static var OperaDic:Array;					//剧情存储器
		private static var OperaRolesDic:Dictionary;				//动画人物存储器
		private var playerId:int = 500000;					//人物ID
		private var purdahPanel:PurdahPanel = null;
		public function OperaMediator()
		{
			OperaRolesDic = new Dictionary();
			super(NAME);
		}
		
		private function get bag():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [	
				OperaEvents.INITOPERA,		//初始化剧情
				OperaEvents.RUNOPERA,       //播放剧情动画
				OperaEvents.CLEAROPERA,		//关闭剧情动画
				OperaEvents.INITROLES,		//初始化人物	
				EventList.STAGECHANGE		//自动适应屏幕大小
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			//锁定鼠标事件
			var player:GameElementAnimal = null;
			var i:int = 0
			
			switch(notification.getName())
			{
				case OperaEvents.INITOPERA:
					//加载动画配置文件
					var OperaName:String = notification.getBody().OperaName;
					var operaConfig:OperaConfig = new OperaConfig(OperaName);
					operaConfig.Load();
					purdahPanel = new PurdahPanel();
					
					GameCommonData.GameInstance.TooltipLayer.addChild(purdahPanel);
					
					purdahPanel.talkHandler = this.talkHandler;
					purdahPanel.init();
					
					//在此处锁定屏幕，添加帷幕，提示动画正在加载中
//					player = TalkController.talk(GameCommonData.Player.Role.Name);
//					player.Stop();
					GameCommonData.Scene.PlayerStop();
					purdahPanel.mouseEnabled = false;
					purdahPanel.skipFunction = skipOpera;
					GameCommonData.GameInstance.GameScene.GetGameScene.MouseEnabled = false;
					break;
				
				case OperaEvents.INITROLES:

					var role:Object = OperaDic.shift();
					for(i=0;i<role.roleList.length; i++)
					{
						playerId++;
						
						
						if(role.roleList[i].type == "NPC")
						{
							player = new GameElementNPC(GameCommonData.GameInstance);
							
							player.Role 			   = new GameRole();
							var npc:XML = GameCommonData.ModelOffsetNPC[role.roleList[i].skinId.toString()];
							if(npc!=null)
							{
								player.Offset 			   = new Point(npc.@X,npc.@Y);
								player.OffsetHeight 	   = npc.@H;
								//								player.Role.Direction 	   = npc.@Dir;
								player.Role.Direction 	   = 1;
								player.Role.Title		   = npc.@Title;
								player.Role.IsSimpleNPC = (npc.@Simple == "true");
								player.Role.PersonSkinName = "Resources\\NPC\\" + role.roleList[i].skinId + ".swf";
								
								player.Role.MissionState = 0;
								player.Role.TitleColor       = 0x4affd2;
								player.Role.TitleBorderColor = 0x004940;
								player.Role.NameColor		 = "#46f0ff";
								player.Role.NameBorderColor  = 0x000000;
								player.Role.Type 		     = GameRole.TYPE_NPC;
							}
						}else
						{
							player = new GameElementEnemy(GameCommonData.GameInstance);
							
							player.Role 			   = new GameRole();
							player.Role.PersonSkinName = "Resources\\Enemy\\" + role.roleList[i].skinId + ".swf";
							
							player.Role.PersonSkinID   = role.roleList[i].skinId;
							player.Role.NameColor = "#ff00ff";
							player.Role.Type 		   = GameRole.TYPE_ENEMY;
						}
						player.Role.Name		   = role.roleList[i].name;

						player.Role.Id			   = playerId;
						player.Role.HP			   = 10000;
						
						player.SetMoveSpend(1);
						
						player.SetDirection(role.roleList[i].direct);
						player.Role.TileX = role.roleList[i].X;
						player.Role.TileY = role.roleList[i].Y;
						GameCommonData.Scene.AddPlayer(player);
						player.Visible = false;
						GameCommonData.SameSecnePlayerList[playerId] = player;
						OperaRolesDic[playerId] = player;
					}
					
					facade.sendNotification(OperaEvents.RUNOPERA);
					break;
				
				case OperaEvents.RUNOPERA:
					
					//清理计时器
					if(timeId != 0){
						clearTimeout(timeId);
					}
					//每次播放动画时候，去处存储器中第一项动画，然后将此动画删除
					if(OperaDic.length == 0 )
					{
						//动画播放完毕后，清理动画场景
						sendNotification(OperaEvents.CLEAROPERA);
						return;
					}
					
					var obj:Object = OperaDic.shift();
					
					for(i=0; i<obj.segment.length; i++)
					{
						var type:String = obj.segment[i].type.toString();
						player = null;
						var playerNo:*;
						var playerName:String = "";
						var x:Number;
						var y:Number 
						switch(type)
						{
							case "1":										//人物移动
//								trace("segment.type ="+type+" case 1");
								x = obj.segment[i].X;
								y = obj.segment[i].Y;
								var endPoint:Point = new Point(x, y);
								
								playerName = obj.segment[i].player
								if(playerName == "")
								{
									playerName = GameCommonData.Player.Role.Name;
									GameCommonData.Scene.PlayerStop();
								}
								player = TalkController.talk(playerName);
//								player.Stop();
								player.Move(MapTileModel.GetTilePointToStage(endPoint.x, endPoint.y));
								break;
							case "2":										//对话
//								trace("segment.type ="+type+" case 2");
								purdahPanel.setSkipVisible(true);
								
								for(playerNo in OperaRolesDic)
								{
									TalkController.removeTalk(OperaRolesDic[playerNo]);
								}
								var tmp:Object = new Object();
								tmp.nColor = 16777215;
								var talkObj:Array = new Array();
								playerName = obj.segment[i].player.toString()
								if(playerName == "")
								{
									//人物名
									talkObj[0] = GameCommonData.Player.Role.Name;
									//人物头像
									talkObj[1] = GameCommonData.Player.Role.CurrentJobID+"_"+GameCommonData.Player.Role.Sex;
								}
								else
								{
									talkObj[0] = obj.segment[i].player.toString();    //对话人物
									talkObj[1] = obj.segment[i].skinId.toString();
								}
								
								talkObj[3] = talkObj[0]+":  "+obj.segment[i].talkInfo.toString();
								tmp.talkObj = talkObj;
								purdahPanel.talk(talkObj);
								purdahPanel.addRoleImage(talkObj[1]);
								
								if(obj.segment[i].talkInfo.toString().length>24)
								{
									var talkInfo:String = obj.segment[i].talkInfo.toString().substr(0,24);
									talkInfo += "...";
									talkObj[3] = talkInfo;  //对话内容
									
									tmp.talkObj = talkObj;
								}
								
//								var play:GameElementAnimal = TalkController.talk(talkObj[0]); 
//								facade.sendNotification(HeadTalkCommand.NAME,tmp);

								break;
							case "3":										//人物打斗
								break;
							case "4":										//播放动画swf
								break;
							case "5":										//添加人物进场
								//人物入场代码
								playerName = obj.segment[i].player;
								player = TalkController.talk(playerName);
								if(player != null)
								{
									player.Visible = true;
								}
								break;
							case "6":										//人物或物品从场景消失
								
								playerName = obj.segment[i].player;
								player = TalkController.talk(playerName);
								player.Visible = false;
								for(playerNo in OperaRolesDic)
								{
									if(player.Role.Id == playerNo)
									{
										GameCommonData.Scene.DeletePlayer(playerNo);
										delete GameCommonData.SameSecnePlayerList[playerNo];
										delete OperaRolesDic[playerNo];	
									}
								}
								break;
						}
					}
					
					purdahPanel.mouseEnabled = false;
					var t:int = obj.timeout;
					setTimeout(resumeMouseEnable,t);
					
					//每10秒钟自动播放动画
					timeId = setTimeout(runOperaFunction,4*1000);
					break;
				case OperaEvents.CLEAROPERA:	
					
					//清理计时器
					purdahPanel.setSkipVisible(false);
					if(timeId != 0){
						clearTimeout(timeId);
					}
					
					//释放所有动画资源，进入正常游戏场景
					for(playerNo in OperaRolesDic)
					{
						player = OperaRolesDic[playerNo];
						player.Visible = false;
						GameCommonData.Scene.DeletePlayer(playerNo);
						delete GameCommonData.SameSecnePlayerList[playerNo];
						delete OperaRolesDic[playerNo];
					}
					if(purdahPanel!=null)
					{
						purdahPanel.removeImage();
						purdahPanel.exited = exited;
						purdahPanel.exit();
						
					}
					
					resumeMouseEnable();
					
//					GameCommonData.GameInstance.TooltipLayer.removeChild(purdahPanel);
//					purdahPanel = null;
					GameCommonData.GameInstance.GameScene.GetGameScene.MouseEnabled = true;
					break;
				
				case EventList.STAGECHANGE:
					if(purdahPanel == null) return;
					purdahPanel.reSize();
					break;
			}
		}
		
		private function exited():void{
			this.purdahPanel = null;
			CopyController.getInstance().start();
		}
		
		public function skipOpera():void
		{
			facade.sendNotification(OperaEvents.CLEAROPERA);
		}
		
		private function resumeMouseEnable():void
		{
			//开启鼠标事件
			if(purdahPanel == null)return;
			purdahPanel.mouseEnabled = true;
		}
		
		private function runOperaFunction():void
		{
			facade.sendNotification(OperaEvents.RUNOPERA);
		}
		
		private function talkHandler(e:MouseEvent):void {
			facade.sendNotification(OperaEvents.RUNOPERA);
		}
	}
}