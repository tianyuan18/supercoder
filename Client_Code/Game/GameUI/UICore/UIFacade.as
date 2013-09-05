package GameUI.UICore
{
	import Controller.PlayerSkinsController;
	import Controller.TargetController;
	
	import GameUI.Command.AccLoginCommand;
	import GameUI.Command.GServerLoginCommand;
	import GameUI.Command.PlayerActionCommand;
	import GameUI.Command.StartupCommand;
	import GameUI.Command.StartupCommandRole;
	import GameUI.ConstData.CommandList;
	import GameUI.ConstData.EventList;
	import GameUI.Modules.AutoPlay.command.AutoPlayEventList;
	import GameUI.Modules.Buff.Data.BuffEvent;
	import GameUI.Modules.Campaign.Data.CampaignData;
	import GameUI.Modules.CardFiles.NewerCardNewMediator;
	import GameUI.Modules.ChangeLine.Data.ChgLineData;
	import GameUI.Modules.Chat.Data.ChatData;
	import GameUI.Modules.Chat.Data.ChatEvents;
	import GameUI.Modules.Equipment.command.EquipCommandList;
	import GameUI.Modules.Friend.command.FriendCommandList;
	import GameUI.Modules.Help.Data.DataEvent;
	import GameUI.Modules.Hint.Events.HintEvents;
	import GameUI.Modules.MainSence.Data.MainSenceData;
	import GameUI.Modules.MainSence.Mediator.MainSenceMediator;
	import GameUI.Modules.MainSence.Proxy.QuickGridManager;
	import GameUI.Modules.Manufactory.Data.ManufactoryData;
	import GameUI.Modules.Master.Data.MasterData;
	import GameUI.Modules.Pick.PickData.PickConst;
	import GameUI.Modules.PlayerInfo.Command.PlayerInfoComList;
	import GameUI.Modules.Relive.Data.ReliveEvent;
	import GameUI.Modules.Stall.Data.StallConstData;
	import GameUI.Modules.Task.Commamd.TaskCommandList;
	import GameUI.Modules.TimeCountDown.TimeData.TimeCountDownEvent;
	import GameUI.Modules.Unity.Data.UnityConstData;
	import GameUI.Modules.Unity.Data.UnityEvent;
	import GameUI.Proxy.DataProxy;
	import GameUI.View.BaseUI.PanelBase;
	import GameUI.View.items.DroppedItem;
	
	import Net.ActionProcessor.PlayerAction;
	import Net.ActionSend.PlayerActionSend;
	import Net.ActionSend.Zippo;
	import Net.Protocol;
	
	import OopsEngine.Role.GameRole;
	import OopsEngine.Scene.StrategyElement.GameElementSkins;
	import OopsEngine.Skill.GameSkillBuff;
	
	import OopsFramework.GameTime;
	import OopsFramework.Utils.Timer;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class UIFacade extends Facade
	{
		public static const FACADEKEY:String = "UIFacade";
		public static var UIFacadeInstance:UIFacade;
		
		public function UIFacade(key:String) 
		{
			super(key);
			timer = new Timer();
			timer.DistanceTime = 300000;	//5分钟一次心跳	300000
		}
		
		public static function GetInstance(key:String):UIFacade 
		{
			if(UIFacadeInstance == null) 
			{
				UIFacadeInstance = new UIFacade(FACADEKEY);
			}
			return UIFacadeInstance;
		}
		
		protected override function initializeController():void 
		{
			super.initializeController();
			this.registerCommand(CommandList.STARTUP, StartupCommand);
			this.registerCommand(CommandList.STARTUPROLE, StartupCommandRole);
			this.registerCommand(CommandList.LOGINACCSEVERCOMMAND, AccLoginCommand);
			this.registerCommand(CommandList.LOGINGSEVERCOMMAND, GServerLoginCommand);
//			this.registerCommand(CommandList.SELECTROLECOMMAND, SelectRoleCommand);
			this.registerCommand(CommandList.PLAYERACTIONCOMMAND, PlayerActionCommand);
		} 
		
		public function StartUp():void {
			this.sendNotification(CommandList.STARTUP);
		}
		/** 启动角色管理 */
		public function roleStartUp():void
		{
			this.sendNotification(CommandList.STARTUPROLE);
		}
		
		/** 侦听键盘事件 */
		public function GetKeyCode(code:int):void
		{
			var btnType:uint = 0;
			var mainSenceMediator:MainSenceMediator = retrieveMediator(MainSenceMediator.NAME) as MainSenceMediator;
			var dataProxy:DataProxy = retrieveProxy(DataProxy.NAME) as DataProxy;
			switch (code){
				case Keyboard.ENTER:
					this.sendNotification(EventList.KEYBORADEVENT, code);
				break;
				case Keyboard.ESCAPE: //循环关闭界面  
					this.sendNotification(EventList.KEYBORADEVENT, code);
					escClearPanelBase();
					break;	
				case 77:	//快捷键Ｑ 循环打开关闭场景地图
//					var dataProxy:DataProxy = retrieveProxy(DataProxy.NAME) as DataProxy;
					if(dataProxy.SenceMapIsOpen) {
						this.sendNotification(EventList.CLOSESCENEMAP);
					} else {
						this.sendNotification(EventList.SHOWSENCEMAP);
					}
					break;
				
				case 81:	//快捷键Ｑ　上下坐骑
					//btnType = 0;
					if(GameCommonData.Player.Role.MountSkinID != 0)//下坐骑
					{
						PlayerSkinsController.UnMount();
					}
					else//上坐骑
					{
						PlayerSkinsController.SetMount();
					}
					//mainSenceMediator.useQuickBtn(MainSenceData.mainItemArr[btnType]);
					break;
				case 87:	//快捷键Ｗ　坐骑界面
					btnType = 5;
					mainSenceMediator.useQuickBtn(MainSenceData.mainItemArr[btnType]);
					break;
				case 84:	//快捷键Ｔ　组队界面
					//btnType = 0;
					//mainSenceMediator.useQuickBtn(MainSenceData.mainItemArr[btnType]);
					if(dataProxy.TeamIsOpen == false)
						sendNotification(EventList.SHOWTEAM);
					else
						sendNotification(EventList.REMOVETEAM);
					break;
				case 89:	//快捷键Ｙ　强化界面
					btnType = 6;
					mainSenceMediator.useQuickBtn(MainSenceData.mainItemArr[btnType]);
					break;
				case 85:	//快捷键Ｕ　合成界面
//					btnType = 0;
//					mainSenceMediator.useQuickBtn(btnType);
					break;
				case 79:	//快捷键Ｏ　设置界面
//					btnType = 0;
//					mainSenceMediator.useQuickBtn(btnType);
					break;
				case 80:	//快捷键Ｐ　宠物界面
					btnType = 3;
					mainSenceMediator.useQuickBtn(MainSenceData.mainItemArr[btnType]);
					break;
//				case 65:	//快捷键Ａ　挂机界面
//					var dis:DisplayObject = GameCommonData.GameInstance.GameUI.getChildByName(NewerCardNewMediator.CARD_NAEM);
//					if(dis)
//					{
//						return;
//					}
//					if(dataProxy.autoPlayIsOpen)
//					{
//						sendNotification(AutoPlayEventList.HIDE_AUTOPLAY_UI);
//						sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
//					}else
//					{
//						sendNotification(AutoPlayEventList.SHOW_AUTOPLAY_UI);
//					}
//					break;
				case 83:	//快捷键Ｓ　技能界面
					btnType = 2;
					mainSenceMediator.useQuickBtn(MainSenceData.mainItemArr[btnType]);
					break;
				case 68:	//快捷键Ｄ　法宝界面
//					btnType = 0;
//					mainSenceMediator.useQuickBtn(btnType);
					break;
				case 70:	//快捷键Ｆ　好友界面
//					btnType = 0;
//					mainSenceMediator.useQuickBtn(btnType);
					break;
				case 71:	//快捷键Ｇ　帮派界面
					btnType = 7;
					mainSenceMediator.useQuickBtn(MainSenceData.mainItemArr[btnType]);
					break;
				case 72:	//快捷键Ｈ 预留 帮助界面
					sendNotification(DataEvent.OUTSHOWPK);
					break;
				case 74:	//快捷键J　日常活动
//					btnType = 0;
//					mainSenceMediator.useQuickBtn(btnType);
					break;
				case 76:	//快捷键L　任务界面
					if(dataProxy.TaskIsOpen) {
						this.sendNotification(EventList.CLOSETASKVIEW);
					} else {
						this.sendNotification(EventList.SHOWTASKVIEW);
					}
					break;
				case 90:	//快捷键Z　拾取动作
					if(dataProxy.pickBagIsOpen)
					{
						sendNotification(EventList.ALL_PICK_BAG);
					}else
					{
						PickConst.aPackage = [];
						for(var keyPackage:Object in GameCommonData.PackageList)
						{
							var obj:Object = new Object;
							obj.items = GameCommonData.PackageList[keyPackage].Data;
							obj.id = GameCommonData.PackageList[keyPackage].ID;
							PickConst.aPackage.push(obj);
						}
						if(PickConst.aPackage.length > 0)
						{
							if(PickConst.pickNum >= PickConst.aPackage.length)
							{
								PickConst.pickNum = 0;
							}
							PickItem(PickConst.aPackage[PickConst.pickNum]);
							PickConst.pickNum++;
						}
					}
					break;
				case 88:	//快捷键X　打坐动作
//					btnType = 0;
//					mainSenceMediator.useQuickBtn(btnType);
					break;
				case 67:	//快捷键C　角色界面
					btnType = 0;
					mainSenceMediator.useQuickBtn(MainSenceData.mainItemArr[btnType]);
					break;
				case 86:	//快捷键V　经脉界面
					btnType = 4;
					mainSenceMediator.useQuickBtn(MainSenceData.mainItemArr[4]);
					break;
				case 66:	//快捷键B　背包界面
					btnType = 1;
					mainSenceMediator.useQuickBtn(MainSenceData.mainItemArr[btnType]);
					break;
//				case 77:	//快捷键M 关联地图
//					GameCommonData.UIFacadeIntance.showBigMap();
//					break;
	
			
//				case 75:   //快捷键H，打开排行榜
//					if( dataProxy.RankIsOpen){
//						sendNotification(EventList.CLOSERANKVIEW);
//						sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
//					}else{
//						sendNotification(EventList.SHOWONLY_CENTER_FIVE_PANEL, "rank");
//						sendNotification(EventList.SHOWRANKVIEW);
//					}
//					break;
				
//				case Keyboard.SPACE:											//空格捡包
//					if(dataProxy.pickBagIsOpen)
//					{
//						sendNotification(EventList.ALL_PICK_BAG);
//					}else
//					{
//						PickConst.aPackage = [];
//						for(var keyPackage:Object in GameCommonData.PackageList)
//						{
//							var obj:Object = new Object;
//							obj.items = GameCommonData.PackageList[keyPackage].Data;
//							obj.id = GameCommonData.PackageList[keyPackage].ID;
//							PickConst.aPackage.push(obj);
//						}
//						if(PickConst.aPackage.length > 0)
//						{
//							if(PickConst.pickNum >= PickConst.aPackage.length)
//							{
//								PickConst.pickNum = 0;
//							}
//							PickItem(PickConst.aPackage[PickConst.pickNum]);
//							PickConst.pickNum++;
//						}
//					}
				
				//下面的是测试的,  
//				case 105:
////					sendNotification(SkillConst.LEARNSKILL,{ID:16});      //这个测试技能学习
////					sendNotification(EventList.STONE_COMPOSE_UI);		//这个测试宝石合成
////					sendNotification(MasterData.SHOW_MAIN_VIEW); 
//					sendNotification(SkillConst.LEARN_LIFE_SKILL_PAN); 
//					break;
//				case 104:
////					sendNotification(MasterData.BETRAY_MASTER);
//					sendNotification(ChatEvents.SHOW_BIG_LEO);
//					break;
			}
		}
		
		/** 转场后清除选中的目标头像 */
		public function clearTargetPhoto():void
		{
			sendNotification(PlayerInfoComList.HIDE_COUNTERWORKER_UI);
		}
		
		/** 按ESC键循环关闭打开的窗口 */
		public function escClearPanelBase():void
		{
			sendNotification(PlayerInfoComList.HIDE_COUNTERWORKER_UI);
			var dataProxy:DataProxy = retrieveProxy(DataProxy.NAME) as DataProxy;
			if(dataProxy.MarketIsOpen) {
				sendNotification(EventList.CLOSEMARKETVIEW);
				return;
			}
			if(dataProxy.BigMapIsOpen) {
				sendNotification(EventList.CLOSEBIGMAP);
				return;
			}
			if(dataProxy.SenceMapIsOpen) {
				sendNotification(EventList.CLOSESCENEMAP);
				return;
			}
			var num:int = GameCommonData.GameInstance.TooltipLayer.numChildren;
			for(var j:int = num-1; j >= 0; j--) {
				var childTP:DisplayObject = GameCommonData.GameInstance.TooltipLayer.getChildAt(j);
				if(childTP is PanelBase) {
					(childTP as PanelBase).onCloseHandler(null);
					return;
				}
			}
			num = GameCommonData.GameInstance.GameUI.numChildren;
			for(var i:int = num-1; i >= 0; i--) {
				var childUI:DisplayObject = GameCommonData.GameInstance.GameUI.getChildAt(i);
				if(childUI is PanelBase) {
					(childUI as PanelBase).onCloseHandler(null);
					return;
				}
			}
		}
		
		/**
		 * 转移场景的时候，调用这个方法，关闭当前场景的所有已打开面板
		 */
		 
		public function closeOpenPanel():void
		{
			var dataProxy:DataProxy = retrieveProxy(DataProxy.NAME) as DataProxy;
			//关闭  技能、人物属性、宠物、任务
			sendNotification(EventList.SHOWONLY, "");	
			//关闭 组队、背包、商城、大地图、好友、屏蔽列表、小喇叭、物品拾取框
			if(dataProxy.TeamIsOpen) 		sendNotification(EventList.REMOVETEAM);
			if(dataProxy.BagIsOpen)			sendNotification(EventList.CLOSEBAG);
			if(dataProxy.MarketIsOpen)		sendNotification(EventList.CLOSEMARKETVIEW);
			if(dataProxy.BigMapIsOpen)		sendNotification(EventList.CLOSEBIGMAP);
			if(dataProxy.pickBagIsOpen)		sendNotification(EventList.CLOSE_PICK_PANEL);
			if(dataProxy.FriendsIsOpen)		sendNotification(FriendCommandList.HIDEFRIEND);
											sendNotification(ChatEvents.HIDEFILTERLIST);
											sendNotification(ChatEvents.CLOSELEO);
			//关闭装备强化、升星、打孔、镶嵌、取出面板
			sendNotification(EquipCommandList.CLOSE_EQ_PANELS_CHANGE_SENCE);
			
			//关闭 江湖指南、排行榜、帮派、帮派信息、创建帮派、响应帮派
			if(dataProxy.HelpViewOpen)   			this.sendNotification(EventList.CLOSEHELPVIEW);
			if(dataProxy.RankIsOpen)      			this.sendNotification(EventList.CLOSERANKVIEW);
			if(dataProxy.UnityIsOpen)     			this.sendNotification(EventList.CLOSEUNITYVIEW);
			if(dataProxy.UnitInfoIsOpen)  			this.sendNotification(UnityEvent.CLOSEUNITYINFOVIEW);
			if(dataProxy.CreateUnitIsOpen)			this.sendNotification(UnityEvent.CLOSECREATEUNITYVIEW);
			if(UnityConstData.respondViewIsOpen)	this.sendNotification(UnityEvent.CLOSERESPONDUNITYVIEW);
			this.sendNotification(TimeCountDownEvent.CLOSETIMECOUNTDOWN);						//关闭倒计时面板
			/* 关闭自动寻路，技能学习，答题  活动日程 */
			if(dataProxy.AutoRoadIsOpen)	this.sendNotification(EventList.HIDE_AUTOPATH_UI);
			if(dataProxy.LearnSkillIsOpen) 	this.sendNotification(EventList.CLOSE_LEARNSKILL_VIEW);
			if(dataProxy.answerPanelIsOpen) this.sendNotification(EventList.CLOSE_ANSWER_VIEW);
			if(dataProxy.CampaignPanIsOpen) this.sendNotification(CampaignData.CLOSE_CAMPAIGN_PANEL);
			if ( dataProxy.masterPanelIsOpen ) sendNotification( MasterData.CLOSE_MASTER_VIEW );
		}
		
		/** 打开/关闭 江湖指南 */
		public function openHelpView():void
		{
			sendNotification(DataEvent.OUTSHOWPK);
		}
		
		/**
		 * 更新信息
		 * @param type 0:由Id号决定  1:队伍 2：玩家自己  3：对方玩家 4：宠物 6:攻击提示 
		 * 											31:目标对象清除	41:清除宠物信息
		 * 
		 */	
		public function upDateInfo(type:uint=0,id:int=-1):void
		{			
			sendNotification(EventList.ALLROLEINFO_UPDATE,{type:type,id:id});
		}
		
		/**
		 * 更新小地图的显示 
		 * @param obj
		 * {type:1}  5   6
		 */		
		public function updateSmallMap(obj:Object):void{
			sendNotification(EventList.UPDATE_SMALLMAP_DATA,obj);
		}
		
		/** 选中了玩家 */
		public function selectPlayer():void
		{
			this.sendNotification(PlayerInfoComList.SELECT_ELEMENT,GameCommonData.TargetAnimal.Role);
		}
		
		/** 提示不能移动 type: 1-交易中，2-摆摊中 */
		public function showNoMoveInfo(type:int):void
		{
			switch(type) {
				case 1:
					sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "gUI_UIC_Uif_showN_1" ], color:0xffff00});//"交易时无法移动"
					break;
				case 2:
					sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "gUI_UIC_Uif_showN_2" ], color:0xffff00});//"摆摊时无法移动"
					break;
			}
		}
		
		/** 点击了摊位（查看） */
		public function selectStall(stallId:int):void
		{
			sendNotification(EventList.GETSTAllUserItems, stallId);	
		}
		
		/** 显示死亡复活界面 */
		public function showRelive():void
		{
			sendNotification(ManufactoryData.CLOSE_MANUFACTORY_UI);			//关闭打造
			sendNotification(ReliveEvent.SHOWRELIVE);
		}
		
		/** 移除死亡复活界面 */
		public function removeRelive():void
		{
			sendNotification(ReliveEvent.REMOVERELIVE);
		}
		
		/** 显示断线界面 */
		public function showBreak():void
		{
			sendNotification(ReliveEvent.SHOWBREAK);
		} 
		
		/** 拾取物品*/
		public function PickItem(obj:Object):void
		{
			//从列表中删除
//			var itemList:Array=GameCommonData.PackageList[obj.ID].Data;
//			for(var i:int=0; i<itemList.length;i++)
//			{
//				if(obj==itemList[i])
//				{
//					itemList.splice(i,1);
//				}
//			}
//			
//			var mainSenceMe:MainSenceMediator=retrieveMediator(MainSenceMediator.NAME) as MainSenceMediator;
//			var mainSenceView:MovieClip=mainSenceMe.getViewComponent() as MovieClip;
//			var bagButton:SimpleButton=mainSenceMe.mainItem[1] as SimpleButton;
//			trace(bagButton.name);
//			var bagPos:Point=mainSenceView.localToGlobal(new Point(bagButton.x,bagButton.y));
//			var ep:Point = GameCommonData.GameInstance.GameScene.GetGameScene.BottomLayer.globalToLocal(new Point(bagPos.x,bagPos.y));
//			TweenLite.to(obj as DroppedItem, 1.0, {x:ep.x,y:ep.y,ease:Back.easeIn,onComplete:done});
//			function done():void{
//				GameCommonData.GameInstance.GameScene.GetGameScene.BottomLayer.removeChild(obj as DroppedItem);
//			}
		}
		
		/**拾取物品动画
		 * @param idType物品id
		 * **/
		public function playItemFlyMovie(idType:int,pos:Point):void{
			
			var droppedItem:DroppedItem=new DroppedItem(String(idType));
			var ep:Point = GameCommonData.GameInstance.GameScene.GetGameScene.BottomLayer.localToGlobal(new Point(pos.x,pos.y));
			droppedItem.x = ep.x;//p.x;
			droppedItem.y = ep.y;//p.y;
			
			
			GameCommonData.GameInstance.GameUI.addChild(droppedItem);
			
			
			//获取背包位置
			var mainSenceMe:MainSenceMediator=retrieveMediator(MainSenceMediator.NAME) as MainSenceMediator;
			var mainSenceView:MovieClip=mainSenceMe.getViewComponent() as MovieClip;
			var tmpItem:SimpleButton=mainSenceMe.mainItem[1] as SimpleButton;
			var toX:int = tmpItem.x + tmpItem.parent.x-10;
			var toY:int = tmpItem.y + tmpItem.parent.y-30;
			
			
			setTimeout(startMove,300);
			
			function startMove():void{
				TweenLite.to(droppedItem, 0.8,{
					x:toX,
					y:toY,
					onComplete:itemMoveOver,
					ease:Linear.easeNone
				});	
			}			
			function itemMoveOver():void{
				GameCommonData.GameInstance.GameUI.removeChild(droppedItem);
			}
			
		}
		
		
		/** 从场景上移除包 */
		public function DeletePackage(id:uint):void
		{
			this.sendNotification(EventList.DELETEPACKAGE, id);
		}
		
		/** 打开排行榜 */
		public function openRank():void
		{
			this.sendNotification(EventList.SHOWRANKVIEW);
		}
				
		/** 显示获得经验  */
		public function ShowHint(str:String):void
		{
			this.sendNotification(HintEvents.RECEIVEINFO, {info:str, color:0xffff00});
		}	
		
		/** 显示获得经验  */
		public function ShowExp(str:String):void
		{
			setTimeout(delayFn, 1000, str);	
		}	
		
		private function delayFn(str:String):void
		{
			this.sendNotification(HintEvents.RECEIVEINFO, {info:str, color:0xffff00});
		}
		
		/** 显示大地图  */
		public function showBigMap():void
		{
			this.sendNotification(EventList.SHOWBIGMAP);
		}
		
		/** 把队伍选中为目标*/
		public function selectTeam(role:GameRole):void{
			if(GameCommonData.SameSecnePlayerList[role.Id]!=null){
				TargetController.SetTarget(GameCommonData.SameSecnePlayerList[role.Id]);
				sendNotification(PlayerInfoComList.SELECTEDSELF,GameCommonData.SameSecnePlayerList[role.Id].Role);
			}else{
				
			}
		}
		
		/** 点击任务  */
		public function selectedTask(id:uint):void{
			sendNotification(TaskCommandList.SHOW_SELECTED_TASK,id);
		}
		
//		/** 点击人物升级按钮 */
//		public function clickLevUpRole():void
//		{
//			sendNotification(NewerHelpEvent.ROLE_LEVUP_NOTICE_NEWER_HELP, 0);
//		} 
		 
		/**显示提示信息 */
		public function showPrompt(info:String,color:uint):void{
			sendNotification(HintEvents.RECEIVEINFO, {info:info, color:color});
		}
		
		/**
		 * 显示上方主屏信息，比如xx送xx什么鲜花，xx获得了牛逼装备
		 * @param info 显示的字符串
		 * @param color 字体颜色
		 * **/
		public function showOperatePormpt(info:String,color:uint):void
		{
			sendNotification(HintEvents.RECEIVE_OPERATE_INFO, {info:info, color:color});
		}
		
		/**显示中间的操作信息，比如金钱不够，等级不够之类的提示
		 * @param info 显示的字符串
		 * @param color 字体颜色
		 * **/
		public function showPormptControl(info:String,color:uint):void
		{
			
		}
		
		/**显示右下角打怪信息，经验什么的
		 * @param info 显示的字符串
		 * @param color 字体颜色
		 * **/
		public function showPormptExp(info:String,color:uint):void
		{
			
		}
		
		
		
		
		/** 拖动物品*/
		public function dragItem(obj:Object):void{
			var quickGridManager:QuickGridManager=retrieveProxy(QuickGridManager.NAME) as QuickGridManager;	
			quickGridManager.addUseItem(obj);
		}
		
		/** 鼠标点击地图，改变路径*/
		// 0:改变了路径  1：路径走完  type值决定导航地图的路线是否显示;为０时不显示，为３的时候总是一直显示
		public function changePath(type:uint=3):void{
			sendNotification(EventList.UPDATE_SMALLMAP_PATH,type);
		}
		
		
		/**
		 *  改变Npc对话框状态
		 *  @param type 1:打开Npc对话窗口  2:取消自己寻路  3:关闭对话框
		 * 
		 */		
		public function changeNpcWin(type:uint,npcId:uint=0, data:Object=null):void{
			switch(type){
				case 1:
					if(npcId!=0){
						sendNotification(EventList.SELECTED_NPC_ELEMENT,{npcId:npcId, newerData:data});
					}else{
						sendNotification(EventList.SELECTED_NPC_ELEMENT,{npcId:GameCommonData.targetID, newerData:data});
					}
					GameCommonData.targetID = -1;
					break;
				case 2:
					GameCommonData.isAutoPath=false;
					break;
				case 3:
					sendNotification(EventList.CLOSE_NPC_ALL_PANEL);
					GameCommonData.NPCDialogIsOpen=false;
					break;		
			}
		}
		
		/**
		 * 更新玩家自己的buff与DeBuff
		 * @param type 1:buff添加 2：buff:更新 3：buff删除 4：deBuff添加 5：debuff更新 6：deBuff:删除
		 * id:人物Id
		 * 
		 */			
		public function changeBuffStatus(type:uint,id:uint=0,buff:GameSkillBuff = null):void {
			if(id==0){
				sendNotification(EventList.ALLROLEINFO_UPDATE,{id:GameCommonData.Player.Role.Id,type:1001});
				switch(type)
				{
					case 1:
						this.sendNotification(BuffEvent.ADDBUFF , buff);
					break;
					case 2:
						this.sendNotification(EventList.SHOWBUFF , buff);
					break;
					case 3:
						this.sendNotification(BuffEvent.DELETEBUFF , buff);
					break;
					case 4:
						this.sendNotification(BuffEvent.ADDDEBUFF , buff);
					break;
					case 5:
						this.sendNotification(EventList.SHOWDEBUFF , buff);
					break;
					case 6:
						this.sendNotification(BuffEvent.DELETEDEBUFF , buff);
					break;
				}
			}else{
				
				sendNotification(EventList.ALLROLEINFO_UPDATE,{id:id,type:1001});
			}
			
		}
		
		/**
		 * 游戏心跳
		 * @param type 心跳类型 0-向服务器发送心跳，1-服务器返回心跳进行处理
		 */ 
		private var timer:Timer;
		private var heartTime:int;
		private var heartTurns:int;
		public function gameHeartPoint(gameTime:GameTime,type:uint=0):void
		{
			if(type == 0) 
			{
				if(gameTime && this.timer.IsNextTime(gameTime) && GameCommonData.Player!=null)
				{
						heartTime = getTimer();
						sendHeartPoint();
				}
			}
			else 
			{ 
				var timeReturn:uint = new Date().getTime();
				if(getTimer() - this.heartTime > 60000)
				{
					heartTurns++;
					if(heartTurns == 3)
					{
						sendNotification(ReliveEvent.SHOWBREAK); 
					}
				}
				else
				{
					this.heartTurns = 0;
				}
				this.heartTime = 0; 
			}
		}
		
		/** 发送心跳（禁止直接调用该函数） */
		public static function sendHeartPoint():void
		{
			GameCommonData.netDelayStartTime = getTimer();				//开始延迟计时
			var obj:Object = new Object();
			obj.type = Protocol.PLAYER_ACTION;
			obj.data = new Array();
			obj.data.push(0);
			obj.data.push(GameCommonData.Player.Role.Id);
			obj.data.push(0);
			obj.data.push(0);
			obj.data.push(0);
			obj.data.push(0);
			obj.data.push(PlayerAction.HEARTPOINT);
			obj.data.push(0);
			PlayerActionSend.PlayerAction(obj);
		}
		
		/** 是否正在查看摊位 */
		public function isLookStall():Boolean
		{
			var dataProxy:DataProxy = retrieveProxy(DataProxy.NAME) as DataProxy;
			if(dataProxy.StallIsOpen) {
				return true;
			} else {
				return false;
			}
		}
		
		/** 是否在交易 */
		public function isTrading():Boolean
		{
			var dataProxy:DataProxy = retrieveProxy(DataProxy.NAME) as DataProxy;
			if(dataProxy.TradeIsOpen) {
				return true;
			} else {
				return false;
			}
		}
		
		//发送切线成功事件
		public function chgLineSuc():void
		{
			sendNotification(ChgLineData.CHG_LINE_SUC);
		}
		
		  /** 检测是否可以换线 */
		public function checkCanCL():Boolean
		{	
			var result:Boolean = true;
			var dataProxy:DataProxy = retrieveProxy(DataProxy.NAME) as DataProxy;
			if(dataProxy.TradeIsOpen) {
				sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "gUI_UIC_Uif_che_1" ], color:0xffff00});//"交易时不能换线"
				result = false;
			} else if(StallConstData.stallSelfId > 0) {
				sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "gUI_UIC_Uif_che_2" ], color:0xffff00});//"摆摊时不能换线"
				result = false;
			} else if(GameCommonData.Player.Role.ActionState == GameElementSkins.ACTION_DEAD) {
				sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "gUI_UIC_Uif_che_3" ], color:0xffff00});//"死亡状态不能换线"
				result = false;
			} else if(GameCommonData.Player.Role.IsAttack) {	//战斗状态不能换线 -调用战斗时间边缘接口来判断时间
				sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "gUI_UIC_Uif_che_4" ], color:0xffff00});//"该状态暂不能换线，请稍后再试"
				result = false;
			}
			else if(GameCommonData.GameInstance.GameScene.GetGameScene.name != GameCommonData.GameInstance.GameScene.GetGameScene.MapId) {	//战斗状态不能换线 -调用战斗时间边缘接口来判断时间
				sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "gUI_UIC_Uif_che_5" ], color:0xffff00});//"副本中不能换线"
				result = false;
			}else if(GameCommonData.Player.IsAutomatism)
			{
				sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "gUI_UIC_Uif_che_6" ], color:0xffff00});//"挂机时不能换线"
				result = false;
			}
			return result;
		}
		
		/** 检测是否可以挂机 */
		public function checkAutoPlay():Boolean
		{
			var result:Boolean = true;
			var dataProxy:DataProxy = retrieveProxy(DataProxy.NAME) as DataProxy;
			if(dataProxy.TradeIsOpen) {
				sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "gUI_UIC_Uif_che_7" ], color:0xffff00});//"交易时不能挂机"
				result = false;
			} else if(StallConstData.stallSelfId > 0) {
				sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "gUI_UIC_Uif_che_8" ], color:0xffff00});//"摆摊时不能挂机"
				result = false;
			} else if(dataProxy.DepotIsOpen) {
				sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "gUI_UIC_Uif_che_9" ], color:0xffff00});//"请先关闭仓库"
				result = false;
			}
			return result;
		}
		
		//挂机自动捡包
		public function autoPickBag():void
		{
			sendNotification(PickConst.AUTO_PICK_PACKAGE);
		}
		 
		/** 播放公告 */
		public function playGameNotice(time:String):void
		{
			var chatObj:Object = {};
			var talkObj:Array = [];
			
			talkObj.push(0);		//发送方
			talkObj.push(0);		//接收方
			talkObj.push(0);
			talkObj.push(ChatData.GAME_SCROLL_NOTICE_DIC[time]);
			talkObj.push(0);
			
			chatObj.nAtt   = 2036;	//频道
			chatObj.nColor = 0;		//颜色
			chatObj.talkObj = talkObj;
			
			sendNotification(CommandList.RECEIVECOMMAND, chatObj);
		}
	}
}














