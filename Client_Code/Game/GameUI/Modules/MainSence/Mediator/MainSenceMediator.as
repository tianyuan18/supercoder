package GameUI.Modules.MainSence.Mediator
{
	import Controller.TaskController;
	
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.SoundList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.AutoPlay.Data.AutoPlayData;
	import GameUI.Modules.Bag.Proxy.BagData;
	import GameUI.Modules.Campaign.Data.CampaignData;
	import GameUI.Modules.Designation.Data.DesignationEvent;
	import GameUI.Modules.Equipment.command.EquipCommandList;
	import GameUI.Modules.Forge.Data.ForgeEvent;
	import GameUI.Modules.Friend.command.FriendCommandList;
	import GameUI.Modules.Friend.model.proxy.MessageWordProxy;
	import GameUI.Modules.HeroSkill.SkillConst.SkillConst;
	import GameUI.Modules.Hint.Events.HintEvents;
	import GameUI.Modules.IdentifyTreasure.Data.TreasureData;
	import GameUI.Modules.MainSence.Command.OnsyncBagQuickBarCommand;
	import GameUI.Modules.MainSence.Command.SendQuickBarCommand;
	import GameUI.Modules.MainSence.Data.MainSenceData;
	import GameUI.Modules.MainSence.Proxy.QuickGridManager;
	import GameUI.Modules.Manufactory.Data.ManufactoryData;
	import GameUI.Modules.Master.Data.MasterData;
	import GameUI.Modules.Meridians.model.MeridiansEvent;
	import GameUI.Modules.Mount.MountData.MountEvent;
	import GameUI.Modules.NewerHelp.Data.NewerHelpData;
	import GameUI.Modules.NewerHelp.Data.NewerHelpEvent;
	import GameUI.Modules.NewerHelp.Mediator.NewMenuMediator;
	import GameUI.Modules.OnlineGetReward.Data.OnLineAwardData;
	import GameUI.Modules.Pet.Data.PetEvent;
	import GameUI.Modules.PlayerInfo.Command.PlayerInfoComList;
	import GameUI.Modules.PlayerInfo.Mediator.CounterWorkerInfoMediator;
	import GameUI.Modules.PlayerInfo.Mediator.PetInfoMediator;
	import GameUI.Modules.PlayerInfo.Mediator.PlayerDetailInfoMediator;
	import GameUI.Modules.PlayerInfo.Mediator.SelfInfoMediator;
	import GameUI.Modules.PlayerInfo.Mediator.TeamListInfoMediator;
	import GameUI.Modules.PrepaidLevel.Data.PrepaidUIData;
	import GameUI.Modules.Stall.Data.StallConstData;
	import GameUI.Modules.Stone.Datas.StoneEvents;
	import GameUI.Modules.SystemMessage.Data.SysMessageEvent;
	import GameUI.Modules.SystemSetting.data.SystemSettingData;
	import GameUI.Modules.UnityNew.Data.NewUnityCommonData;
	import GameUI.Modules.UnityNew.Mediator.JoinUnityMediator;
	import GameUI.Modules.UnityNew.Mediator.NewUnityMainMediator;
	import GameUI.MouseCursor.SysCursor;
	import GameUI.Proxy.DataProxy;
	import GameUI.Sound.SoundManager;
	import GameUI.UIConfigData;
	import GameUI.View.BaseUI.ItemBase;
	import GameUI.Modules.Stone.Datas.StoneEvents;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class MainSenceMediator extends Mediator
	{
		public static const NAME:String = "MainSenceMediator";
		private var dataProxy:DataProxy = null;
		private var quickBarFlag:Boolean = false;
		private var quickBarFlagRight:Boolean = false;
		private var quickGridManager:QuickGridManager;
		protected var expSprite:Sprite=new Sprite();
		private var redFrame:MovieClip = null;
		private var oldTime:int ;
		public var mainItem:Array = new Array();        //游戏主菜单项；
		private var mainItemArr:Array = new Array();
		
		protected const ColorArr:Array= [0xFF0000
										,0xE42200
										,0xCE3E00
										,0xB45F00
										,0xA37400
										,0x9F7A00
										,0x998100
										,0x8E8F00
										,0x809F00
										,0x77AB00
										,0x67BF00
										,0x60C800
										,0x4FDD00
										,0x45E900
										,0x33FF00];
										
										
		public function MainSenceMediator()
		{
			super(NAME);
		}
		
		public function get mainSence():MovieClip
		{
			return this.viewComponent as MovieClip;	
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				EventList.INITVIEW,
				EventList.ENTERMAPCOMPLETE,
				EventList.DROPINQUICK,
				FriendCommandList.FRIEND_MESSAGE,
				FriendCommandList.LEAVE_WORD,
				FriendCommandList.READED_MESSAGE,
				EventList.UPDATE_MAINSECEN_EXP,
				EventList.DROPSKILLINQUICK,
				EventList.USE_EXTENDSKILL_MSG,
				EventList.SHOW_MAINSENCE_BTN_FLASH,
				EventList.PET_RESTORDEAD_MSG,
				EventList.CHANGE_QUICKBAR_UI,
				EventList.RECEIVE_QUICKBAR_MSG,
				PlayerInfoComList.SHOW_EXPANDTEAM_ICON,
				PlayerInfoComList.HIDE_EXPANDTEAM_ICON,
				EventList.PLAY_SOUND_OPEN_PANEL,
				PetEvent.PET_TO_FIGHT_AFTER_GETINFO,
				EventList.ADDQUICKFLOW,
				SysMessageEvent.SYSMESSAGE_FLASH_MAIN_SENCE,
				EventList.REMOVEQUICKFLOW,
				OnLineAwardData.GET_AWARD_POINT,
				MainSenceData.USETEAMBUTTON,
				MainSenceData.INITMAINITEM
			];
		}
		
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case EventList.INITVIEW:
//					//var mainItemArr:Array = ["btn_Role","btn_Bag","btn_Skill","btn_Partner","btn_Tendons","btn_Mount","btn_Strengthen","btn_Gang","btn_Shennong_tripod","btn_Demon_pot","btn_Synthesis","btn_Weapon","btn_Market"];
					//var mainItemArr:Array = ["btn_Role","btn_Bag","btn_Skill","btn_Partner","btn_Tendons","btn_Mount","btn_Strengthen","btn_Gang","btn_bazaar","btn_xianfu","btn_compose"];
					SysCursor.GetInstance().setMouseType();
					facade.sendNotification(EventList.GETRESOURCE, {type:UIConfigData.MOVIECLIP, mediator:this, name:UIConfigData.MAINSENCE});
					redFrame = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("RedFrame");
					redFrame.name = "redFrame";
					
//					(this.mainSence["btn_expandTeam_up"] as SimpleButton).addEventListener(MouseEvent.CLICK,onExpandTeamClick);
//					(this.mainSence["btn_expandTeam_down"] as SimpleButton).addEventListener(MouseEvent.CLICK,onExpandTeamClick);
//					(this.mainSence["btn_expandTeam_up"] as SimpleButton).visible=false;
//					(this.mainSence["btn_expandTeam_down"] as SimpleButton).visible=false;

					dataProxy = facade.retrieveProxy( DataProxy.NAME) as DataProxy;
					facade.registerMediator(new SelfInfoMediator());
					facade.registerMediator(new CounterWorkerInfoMediator());
					facade.registerMediator(new PetInfoMediator());
					facade.registerMediator(new TeamListInfoMediator());
					facade.registerMediator(new PlayerDetailInfoMediator());
					facade.sendNotification(PlayerInfoComList.INIT_PLAYERINFO_UI);
					facade.registerProxy(new MessageWordProxy());  //注册留言板 
					facade.registerCommand(EventList.SEND_QUICKBAR_MSG,SendQuickBarCommand);
					facade.registerCommand(EventList.ONSYNC_BAG_QUICKBAR,OnsyncBagQuickBarCommand);
//					facade.registerCommand(EventList.OPEN_PANEL_TOGETHER, OpenPanelTogetherCommand); 
					this.mainSence.addEventListener(Event.ADDED_TO_STAGE, initResize);
					MainSenceData.initOpenDic();
				break;
				case PetEvent.PET_TO_FIGHT_AFTER_GETINFO:
					sendNotification(PlayerInfoComList.UPDATE_PET_UI);
					this.quickGridManager.addPetInitiativeSkill();  
				break;
				
				case EventList.ENTERMAPCOMPLETE: 
					this.quickGridManager=new QuickGridManager(this.mainSence);
					setMainItem(mainItem);	
					initMainSence();
					this.updateExp();
				break;
				case EventList.DROPINQUICK:
					this.quickGridManager.addUseItem(notification.getBody());
				break;
				//宠物休息或死亡（清除宠物的技能）
				case EventList.PET_RESTORDEAD_MSG:
					this.quickGridManager.clearAllPetSkill();
					sendNotification(EventList.SEND_QUICKBAR_MSG); //同步快捷栏
				break;
				case EventList.USE_EXTENDSKILL_MSG:
					this.quickGridManager.clearAllPlayerSkillCd();
				break;
				case EventList.SHOW_MAINSENCE_BTN_FLASH:
					var flashObj:uint = uint(notification.getBody());
					showBtnFlash(flashObj);
				break;
				//好友消息
				case FriendCommandList.FRIEND_MESSAGE:
					showFriendFlash();
					break;
				//好友留言	
				case FriendCommandList.LEAVE_WORD:
					showFriendFlash();
					break;
				//已经读完消息 停止提示 	
				case FriendCommandList.READED_MESSAGE:
					this.hideFriendFlash();
					 break;
				//更新界面中的经险值	 
				case EventList.UPDATE_MAINSECEN_EXP:
					this.updateExp();
					break;	 	
				//切换职业，改变快捷栏	
				case EventList.CHANGE_QUICKBAR_UI:
					this.quickGridManager.changeJob();
				 	break;	
				case EventList.RECEIVE_QUICKBAR_MSG:
					setPageBtn();
					break;
				//隐藏（隐藏或显示队伍图标	第一帧是向上的 二帧是向下的）	
				case PlayerInfoComList.SHOW_EXPANDTEAM_ICON:
//					if((this.mainSence["btn_expandTeam_down"] as SimpleButton).visible){
//						return;
//					}
//					(this.mainSence["btn_expandTeam_up"] as SimpleButton).visible=true;
//					(this.mainSence["btn_expandTeam_down"] as SimpleButton).visible=true;
					break;
				//显示（隐藏或显示队伍图标	）
				case PlayerInfoComList.HIDE_EXPANDTEAM_ICON:
//					(this.mainSence["btn_expandTeam_up"] as SimpleButton).visible=false;
//					(this.mainSence["btn_expandTeam_down"] as SimpleButton).visible=false;
					break;	
				case EventList.PLAY_SOUND_OPEN_PANEL:
					playSoundOpenPanel();
					break;	 
				case EventList.ADDQUICKFLOW:
					if(quickGridManager)
					{
						//tory
						//quickGridManager.addQuickFlow(notification.getBody());
					}
					break;	
				case EventList.REMOVEQUICKFLOW:
					//tory
						//quickGridManager.removeQuickFlow(notification.getBody());
					break;
				case SysMessageEvent.SYSMESSAGE_FLASH_MAIN_SENCE:
					showFriendFlash()
//					mainSence.mcSysFlash.play();
//					mainSence.mcSysFlash.visible = true;
					break;
				case OnLineAwardData.GET_AWARD_POINT:
				    getPoint();
				    break;
		    	case MainSenceData.USETEAMBUTTON:
				    var btnIndex:uint = notification.getBody() as uint;
				    useQuickBtn(MainSenceData.mainItemArr[btnIndex]);
				    break;
				case MainSenceData.INITMAINITEM:
					var params:Array = notification.getBody() as Array;
					if(params != null){
						iniMainItem(params[0]);
						setMainItem(mainItem,params[1]);
					}
					break;
			}
		}
		
		private var _menuNames:Array;
		/**
		 * 
		 * 初始化主菜单选项；
		 * @param mainArr
		 */		
		private function iniMainItem(menuNames:Array):void{
			var item:SimpleButton = new SimpleButton();
			var itemName:String = "";
			_menuNames = menuNames;
			for(var i:int=0;i<_menuNames.length;i++){
				itemName = _menuNames[i];
				item = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByButton(itemName);
				item.name = itemName;
				mainItem.push(item);
			}					
		}
		/**
		 * 设置主菜单项的位置,摆放位置;
		 * _mainItemArr:功能列表
		 * isNewOpenName:对应开通的功能名称
		 */		
		private function setMainItem(_mainItemArr:Array,isNewOpenName:String = ""):void{
			if(_mainItemArr == null)
				return;
			var tmpItem:SimpleButton;
			var itemX:Number = 545;
			var itemY:Number = 77;      //调第一层菜单的高度
			var wval:int = 43;　　　 //调菜单的宽度
			var hval:int = 54;
			var trueI:int = 0;
			for(var i:int=0; i <_mainItemArr.length ;i++){
				tmpItem = _mainItemArr[i];
				if(tmpItem == null || tmpItem.parent != null)
					continue;
				var name:String = tmpItem.name;
				
				
				if(_menuNames.length <= 8){
					tmpItem.x = itemX+(trueI%8)*wval+(8-_menuNames.length)*wval;
				}else{
					if(trueI < 8){
						tmpItem.x = itemX+(trueI%8)*wval;
					}else{
						tmpItem.x = itemX+(trueI%8)*wval+(8-(_menuNames.length-8))*wval;
					}
				}
				
				
				tmpItem.y = (itemY - int(trueI/8)*hval);
				
				if(isNewOpenName != "" && isNewOpenName == name){
					tmpItem.visible = false;
					mainSence.addChild(tmpItem);
					//播放添加功能的动画。
					playAddMenuMovie(tmpItem,isNewOpenName);
				}
				if(isNewOpenName == ""){
					mainSence.addChild(tmpItem);
				}
				tmpItem.addEventListener(MouseEvent.CLICK, onQuickBtn);
				trueI++;
			}
		}
		
		private function playAddMenuMovie(tmpItem:SimpleButton,isNewOpenName:String):void{
			var nmm:NewMenuMediator = facade.retrieveMediator(NewMenuMediator.NAME) as NewMenuMediator;
			var startMc:MovieClip = nmm.loadswfTool.GetResource().GetClassByMovieClip("addMenuStartMc");
			var p:Point = UIConstData.getPos(startMc.width,startMc.height);
			startMc.x = p.x;
			startMc.y = p.y;
			GameCommonData.GameInstance.GameUI.addChild(startMc);
			
			
			var toX:int = tmpItem.x + tmpItem.parent.x;
			var toY:int = tmpItem.y + tmpItem.parent.y;
			
			var endMc:MovieClip = nmm.loadswfTool.GetResource().GetClassByMovieClip("addMenuEndMc");
			
			setTimeout(startMove,900);
			
			function startMove():void{
				TweenLite.to(startMc, 0.8,{
					x:toX,
					y:toY,
					onComplete:addMenuMoveOver,
					ease:Linear.easeNone
				});	
			}			
			function addMenuMoveOver():void{
				GameCommonData.GameInstance.GameUI.removeChild(startMc);
				GameCommonData.GameInstance.GameUI.addChild(endMc);
				endMc.x = toX;
				endMc.y = toY;
				createMenus();
				setTimeout(endOver,900);
			}
			function createMenus():void{
				if(mainItem != null){
					var items:SimpleButton;
					for (var j:int = 0; j < mainItem.length; j++) 
					{
						items = mainItem[j] as SimpleButton;
						if(items!= null && items.parent != null && items.name != isNewOpenName){
							items.parent.removeChild(items);
							mainItem[j] = null;
						}
					}
					for (var i:int = 0; i < mainItem.length; i++) 
					{
						items = mainItem[i] as SimpleButton;
						if(items != null){
							mainSence.addChild(items);
						}
					}
				}
				var tempList:Array = new Array();
				for (var k:int = 0; k < mainItem.length; k++) 
				{
					var nullItem:Object = mainItem[k];
					if(nullItem)
						tempList.push(nullItem);
				}
				mainItem = tempList;
			}
			
			tmpItem.alpha = 0.2;
			function endOver():void{
				tmpItem.visible = true;
				GameCommonData.GameInstance.GameUI.removeChild(endMc);
				TweenLite.to(tmpItem, 0.5,{
					alpha:1,
					ease:Linear.easeNone
				});
				facade.sendNotification(NewerHelpEvent.OPEN_NEW_SUC);
			}
		}
		
		
		private function getPoint():void
		{
//			var p:Point = mainSence.localToGlobal(new Point(mainSence.btn_4.x, mainSence.btn_4.y));
//			sendNotification( OnLineAwardData.MOVE_AWARD, p );
		}
		
		/** 打开面板时播放声音 */
		private function playSoundOpenPanel():void
		{
			SoundManager.PlaySound(SoundList.PANECLOSE);
		}
		
		/**
		 * 收缩与展开队伍按钮 
		 * @param e
		 * 
		 */		
		protected function onExpandTeamClick(e:MouseEvent):void{
//			if((this.mainSence["btn_expandTeam_up"] as SimpleButton).visible){
//				(this.mainSence["btn_expandTeam_up"] as SimpleButton).visible=false;
//				
//				sendNotification(PlayerInfoComList.HIDE_TEAM_UI);
//			}else{
//				(this.mainSence["btn_expandTeam_up"] as SimpleButton).visible=true;
//				sendNotification(PlayerInfoComList.SHOW_TEAM_UI);
//				
//			}
		}
		
		/**
		 * 更新经验值 
		 * 
		 */		
		protected function updateExp():void{
			var maxExp:uint=UIConstData.ExpDic[GameCommonData.Player.Role.Level];
			var exp:uint=GameCommonData.Player.Role.Exp;
			if(exp>maxExp)exp=maxExp;
			
			var expPro:int = exp/maxExp*100;
			mainSence["expBarMc"].gotoAndStop(expPro);
			mainSence["expTxt"].text = expPro+"%";
		}
		
		/**
		 * 停止好友消息提示 
		 * 
		 */		
		protected function hideFriendFlash():void{
			mainSence["btn_5"].mcFlash.stop()
			mainSence["btn_5"].mcFlash.visible = false;
		}
		
		/**
		 * 好友消息提示 
		 * 
		 */		
		protected function showFriendFlash():void{
//			mainSence["btn_5"].mcFlash.play();
//			mainSence["btn_5"].mcFlash.visible = true;
		}
		
		/** 
		 * 让按钮或箭头闪起
		 * @param btnIndex:要闪按钮的下标
		 */
		private function showBtnFlash(type:uint):void
		{
//			for( var i:int = 0; i < 4; i++ ) {
//				mainSence["btn_"+i].mcFlash.stop();
//				mainSence["btn_"+i].mcFlash.visible = false;	
//			}
//			if(type > 7) return;
//			mainSence["btn_"+type].mcFlash.play();
//			mainSence["btn_"+type].mcFlash.visible = true;
//			
//			var point:Point = (mainSence["btn_"+type] as DisplayObject).localToGlobal(new Point(mainSence["btn_"+type].mcFlash.x, mainSence["btn_"+type].mcFlash.y));
//			NewerHelpData.point = point;
//			
//			if(NewerHelpData.curType)
//			{
//				switch(NewerHelpData.curType) {
//					case 3:
//					    this.sendNotification(NewerHelpEvent.SHOW_NEWER_HELP, 3);
//					    break;
//					case 4:
//                        this.sendNotification(NewerHelpEvent.SHOW_NEWER_HELP, 4);
//					    break;
//					case 5:
//                        this.sendNotification(NewerHelpEvent.SHOW_NEWER_HELP, 5);
//					    break;
//					case 6:
//                        this.sendNotification(NewerHelpEvent.SHOW_NEWER_HELP, 6);
//					    break;
//					case 7:
//                        this.sendNotification(NewerHelpEvent.SHOW_NEWER_HELP, 7);
//					    break;
//					case 8:
//                        this.sendNotification(NewerHelpEvent.RECALL_TASK_HELP);
//					    break;
//					case 11:
//                        this.sendNotification(NewerHelpEvent.SHOW_NEWER_HELP, 11);
//					    break;
//					case 13:
//                        this.sendNotification(NewerHelpEvent.RECALL_TASK_HELP);
//					    break;
//					case 34:
//                        this.sendNotification(NewerHelpEvent.SHOW_NEWER_HELP, 34);
//					    break;
//					case 35:
//                        this.sendNotification(NewerHelpEvent.SHOW_NEWER_HELP, 35);
//					    break;
//					case 41:
//                        this.sendNotification(NewerHelpEvent.SHOW_NEWER_HELP, 41);
//					    break;
//					default:
//					    break;
//				}
//			}
		}
		
		private function initMainSence():void
		{
			
			GameCommonData.GameInstance.GameUI.addChild(mainSence);
			for(var j:int=0;j<10;j++){
				(mainSence.mcQuickBar0["quick_"+j] as MovieClip).addEventListener(MouseEvent.MOUSE_MOVE,onMouseMoveHandler);
				(mainSence.mcQuickBar0["quick_"+j] as MovieClip).addEventListener(MouseEvent.MOUSE_OUT,onMouseOutHandler);
				
				(mainSence.mcQuickBar1["quickf_"+j] as MovieClip).addEventListener(MouseEvent.MOUSE_MOVE,onMouseMoveHandler);
				(mainSence.mcQuickBar1["quickf_"+j] as MovieClip).addEventListener(MouseEvent.MOUSE_OUT,onMouseOutHandler);
			}
			facade.registerProxy(quickGridManager);	
			mainSence.mcQuickBar1.visible = quickBarFlag;
			mainSence.btnQuickLanUp.addEventListener(MouseEvent.CLICK, onPageBtn);	
			mainSence.btnQuickLanDown.addEventListener(MouseEvent.CLICK, onPageBtn);
			mainSence.btnShopMain.addEventListener(MouseEvent.CLICK, onShopHandler);	
		}
		
		
		
		// ---------------------------------------------------------------------------------------需要转移的

//		private function onQuickHandler(e:MouseEvent):void
//		{
		
		//		mainSence.btn_help.addEventListener(MouseEvent.CLICK,onHelpHandler); //帮助
		//		mainSence.btnQuickSys.addEventListener(MouseEvent.CLICK, onQuickHandler);	
		//		mainSence.btnVIP.addEventListener(MouseEvent.CLICK, onQuickHandler);
		//		mainSence.BtnTeam.addEventListener(MouseEvent.CLICK, onQuickHandler);
//			var name:String = e.currentTarget.name;
//			switch(name) {
//				case "btnQuickAutoPlay":	//快速挂机
//					sendNotification( AutoPlayEventList.START_AUTO_PLAY );
//					break;
//				case "btnSysMessage":		//系统消息
////					mainSence.mcSysFlash.stop();
////					mainSence.mcSysFlash.visible = false;
//					if(SysMessageData.messageListIsOpen){
//						facade.sendNotification(SysMessageEvent.CLOSEMESSAGEVIEW);
//					}else{
//						facade.sendNotification(SysMessageEvent.SHOWMESSAGEVIEW );
//					}
//					break;
//				case "btnQuickSys":			//系统设置
//					facade.sendNotification(SystemSettingData.OPEN_SETTING_UI);
//					break;
//				case "btnVIP":				//VIP按钮
//					if( VipShowData.IsVipShowOpen )
//					{
//						sendNotification( VipShowData.CLOSE_VIPSHOW_VIEW );
//					}
//					else
//					{
//						if(getTimer() - oldTime > 5000)
//						{
//							oldTime = getTimer();
//							if(!VipShowData.IsVipShowOpen)
//							{
//								var obj:Object = {action: 1 ,pageIndex: 1 , amount: 13 ,memID: 0 };
//								VipListSend.sendVipListAction(obj);
//							}
//						}
//						else
//						{
//							var vipShowMediator:VipShowMediator = facade.retrieveMediator( VipShowMediator.NAME ) as VipShowMediator;
//							vipShowMediator.initView();
//						}
//					}
//					break;
//				case "BtnTeam":				//组队设置
//					useQuickBtn(7);
//					break;
//			}
//		}
//		
//		/**
//		 * 打开帮助文档 
//		 * @param e
//		 * 
//		 */		
//		protected function onHelpHandler(e:MouseEvent):void{
//			facade.sendNotification(DataEvent.OUTSHOWPK);
//		}
		// ---------------------------------------------------------------------------------------需要转移的**/
		
		private function onShopHandler(e:MouseEvent):void
		{
			if(dataProxy.MarketIsOpen) {
				sendNotification(EventList.CLOSEMARKETVIEW);
				sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
			} else {
				sendNotification(EventList.SHOWMARKETVIEW);
			}
		}
		
		protected function onMouseMoveHandler(e:MouseEvent):void{
			var mc:DisplayObject=e.currentTarget as DisplayObject;
			mc.parent.addChild(this.redFrame);
			redFrame.width = 40;
			redFrame.height = 40;
			redFrame.x=mc.x+2;
			redFrame.y=mc.y+2;
		}
		
		protected function onMouseOutHandler(e:MouseEvent):void{
			if(e.currentTarget.parent.contains(redFrame)){
				e.currentTarget.parent.removeChild(redFrame);
			}
		}
		
		public function getQuickfPoint():Point
		{
			var point:Point = mainSence.localToGlobal( new Point(mainSence.mcQuickBar1.x, mainSence.mcQuickBar1.y) );
			return point;
		}
		
		public function isVisible():Boolean
		{
			if( !quickBarFlag )
			{
				quickBarFlag = true;
				mainSence.mcQuickBar1.visible = quickBarFlag;
				mainSence.btnQuickLanUp.visible = false;
				mainSence.btnQuickLanDown.visible = true;
				return false;
			}
			return true;
		}
		
		private function onPageBtn(e:MouseEvent):void
		{
			
			quickBarFlag = !quickBarFlag;
			mainSence.mcQuickBar1.visible = quickBarFlag;
			switch(quickBarFlag)
			{
				case true:
					mainSence.btnQuickLanUp.visible = false;
					mainSence.btnQuickLanDown.visible = true;
				break;
				case false:
					mainSence.btnQuickLanUp.visible = true;
					mainSence.btnQuickLanDown.visible = false;
				break;
			}
			
			if(quickBarFlag){
				GameCommonData.dialogStatus=GameCommonData.dialogStatus | 2;
			}else{
				GameCommonData.dialogStatus=GameCommonData.dialogStatus & (uint.MAX_VALUE-2);
			}		
		}
		/** 右栏按钮触发事件 */
		private function rightBtnHandler(e:MouseEvent):void
		{
//			for(var i:int = 0; i < 8;i++){
//				mainSence["btnRight_" + i].visible = quickBarFlagRight;
//			}
//			mainSence.mc_settingBtns.visible = quickBarFlagRight;
				
			switch(quickBarFlagRight)
			{
				case true:
					if(GameCommonData.GameInstance.GameUI.getChildByName("NewPlayerAwardButton") != null) {
						GameCommonData.GameInstance.GameUI.getChildByName("NewPlayerAwardButton").x = 965; //910
					}
					if(GameCommonData.GameInstance.GameUI.getChildByName("CopyLeadButton") != null) {
						GameCommonData.GameInstance.GameUI.getChildByName("CopyLeadButton").x = 965; //910
					}
//					mainSence.btnQuickLanRight.visible = true;
//					mainSence.btnQuickLanLeft.visible = false;
				break;
				case false:
					if(GameCommonData.GameInstance.GameUI.getChildByName("NewPlayerAwardButton") != null) {
						GameCommonData.GameInstance.GameUI.getChildByName("NewPlayerAwardButton").x = 965;
					}
					if(GameCommonData.GameInstance.GameUI.getChildByName("CopyLeadButton") != null) {
						GameCommonData.GameInstance.GameUI.getChildByName("CopyLeadButton").x = 965;
					}
//					mainSence.btnQuickLanRight.visible = false;
//					mainSence.btnQuickLanLeft.visible = false;
				break;
			}
			quickBarFlagRight = !quickBarFlagRight;
		}
		/** 设置快捷栏的展开与收缩方式*/
		private function setPageBtn():void{
			var maskBit:uint=GameCommonData.dialogStatus & 2;
			quickBarFlag=Boolean(maskBit);
			mainSence.mcQuickBar1.visible = quickBarFlag;
			switch(quickBarFlag)
			{
				case true:
					mainSence.btnQuickLanUp.visible = false;
					mainSence.btnQuickLanDown.visible = true;
				break;
				case false:
					mainSence.btnQuickLanUp.visible = true;
					mainSence.btnQuickLanDown.visible = false;
				break;
			}
			
		}
		
		private function getAllNum(item:ItemBase):int
		{
			var num:int = 0;
			for( var i:int = 0; i<BagData.AllUserItems.length; i++ )
			{
				for( var j:int = 0; j<BagData.AllUserItems[i].length; j++ )
				{
					if(BagData.AllUserItems[i][j] == undefined) continue;
					if(item.Type ==  BagData.AllUserItems[i][j].type)
					{
						num += BagData.AllUserItems[i][j].amount;
					}
				}
			}
			return num;
		}
		
		private function showTeamFlash():void
		{
			mainSence["btn_7"].mcFlash.play();
			mainSence["btn_7"].mcFlash.visible = true;
		}
		
		private function onQuickBtn(e:MouseEvent):void
		{
//			var type:uint = (e.currentTarget.name as String).split("_")[1];
			var name:String = e.currentTarget.name;
//			if( type == 7 )
//			{
//				useRightQuickBtn(3);    //挑战 又原组队修改
//			}
//			else
//			{
//				useQuickBtn(type);
//			}
			useQuickBtn(name);
		}
		
		private function clickBtnRightHandler(e:MouseEvent):void
		{
			var type:uint = (e.currentTarget.name as String).split("_")[1];
			useRightQuickBtn(type);
		}
		
		public function useRightQuickBtn(type:uint):void
		{
			switch(type)
			{
				case 0:			//离线挂机
					if( GameCommonData.Player.Role.Level >= 10 )
					{
						if(AutoPlayData.dataIsSendOver == false) facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_mai_med_mai_use_1" ], color:0xffff00});//"正在传输数据，请稍后"
						else 
						{
//							PrepaidLevelNet.sendPrepaidDemand(1); 
//							PrepaidUIData.openFrom = "offline";
							facade.sendNotification( PrepaidUIData.SHOW_OFFLINE_VIEW );
						}
					}
					else
					{
						/** = "达到10级才能领取离线经验";*/
						facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "Modules_MainSence_Mediator_MainSenceMediator_1" ], color:0xffff00});	

					}
				break;
				case 1:			//活动日程
					if( GameCommonData.Player.Role.Level >= 15 )
					{
						facade.sendNotification(CampaignData.INIT_CAMPAIGN);
					}
					else
					{
						/** = "达到15级才能查看活动列表";*/
						facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "Modules_MainSence_Mediator_MainSenceMediator_2" ], color:0xffff00});	
					}	
				break;
				case 2:			//生产
//					var simulateObj:Object={
//						simulateDes:'<font face="宋体"  size="12" color="#ffffff">刀剑磨得快，才能锻造出好兵器。只要将武器装备强化升星后，再加上适合相应职业的宝石，就能号令武林、称霸天下！</font>',
//						simulateDataPro:[{iconUrl:"symbol_talk",showText:"装备强化",linkText:"装备强化"},
//						{iconUrl:"symbol_talk",showText:"装备升星",linkText:"装备升星"},
//						{iconUrl:"symbol_talk",showText:"装备打孔",linkText:"装备打孔"},
//						{iconUrl:"symbol_talk",showText:"宝石合成",linkText:"宝石合成"},
//						{iconUrl:"symbol_talk",showText:"宝石镶嵌",linkText:"宝石镶嵌"},
//						{iconUrl:"symbol_talk",showText:"宝石取出",linkText:"宝石取出"},	
//						{iconUrl:"symbol_ask",showText:"装备玩法说明",linkText:"装备玩法说明"}	
//						]		
//					};
//					facade.sendNotification(NPCChatComList.SHOW_SIMULATE_NPC_CHAT,simulateObj);
					if( GameCommonData.Player.Role.Level >= 25 )
					{
						if(dataProxy.TradeIsOpen) 
						{
							sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_mai_med_mai_use_2" ], color:0xffff00});//"交易时不能生产"
							return;
						}
						 else if(StallConstData.stallSelfId > 0) 
						 {
							sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_mai_med_mai_use_3" ], color:0xffff00});//"摆摊时不能生产"
							return;
						}
						if ( ManufactoryData.ResourseIsLoaded )
						{
							facade.sendNotification( ManufactoryData.SHOW_MANUFACTORY_UI,{view:false} );
						}
						else
						{
							facade.sendNotification( ManufactoryData.INIT_MANUFACTORY_UI );
						}
					}
					else
					{

						/** = "达到25级才能进行生产制造";*/
						facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "Modules_MainSence_Mediator_MainSenceMediator_3" ], color:0xffff00});	

					}
				break;
				case 3:			//开箱子
					//屏蔽北京ip
					if ( GameCommonData.cztype == 1 )
					{
						facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_mai_med_mai_use_4" ], color:0xffff00});//"此功能暂未开放"	
						return;
					}
					if ( GameCommonData.openTreasureStragety == 1 )
					{
						if ( !TreasureData.TreaResourceLoaded )
						{
							sendNotification( TreasureData.LOAD_TREASURE_RES );
						}
						else
						{
							if ( dataProxy.treasurePanelIsOpen )
							{
								sendNotification( TreasureData.CLOSE_TREASURE_UI );
							}	
							else
							{
								sendNotification( TreasureData.SHOW_TREASURE_UI );
							}
						}
					}
					else if ( GameCommonData.openTreasureStragety == 2 )
					{ 
						if ( TreasureData.packageDateArr.length == 0 )
						{
							facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_mai_med_mai_use_5" ], color:0xffff00});//"宝物包裹无任何物品"	
							return;
						}
						if ( !TreasureData.TreaResourceLoaded )
						{
							sendNotification( TreasureData.LOAD_TREASURE_RES );
						}
						else
						{
							if ( dataProxy.treasurePackageIsOpen )
							{
								sendNotification( TreasureData.CLOSE_MY_TREA_PACKAGE );
							}	
							else
							{
								sendNotification( TreasureData.OPEN_MY_TREA_PACKAGE );
							}
						}
					}
					else if ( GameCommonData.openTreasureStragety == 3 )
					{
						facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_mai_med_mai_use_4" ], color:0xffff00});//"此功能暂未开放"	
					}
				break;
				case 4:			//强化
					if( GameCommonData.Player.Role.Level >= 10 )
					{
						facade.sendNotification(EquipCommandList.SHOW_EQUIPSTRENGEN_UI);
					}
					else
					{

						/** = "达到10级才能强化装备";*/
						facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "Modules_MainSence_Mediator_MainSenceMediator_4" ], color:0xffff00});	
					}	
				break;
				case 5:			//万兽		
					if( GameCommonData.Player.Role.Level >= 15 )
					{
						if(dataProxy.petRuleIsOpen) {
							sendNotification(EventList.CLOSE_PET_PLAYRULE_VIEW);
						} else {
							sendNotification(EventList.SHOW_PET_PLAYRULE_VIEW, {type:UIConstData.PET_RULE_BASE, index:0});
						}
					}
					else
					{

						/** = "达到15级才能强化宠物";*/
						facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "Modules_MainSence_Mediator_MainSenceMediator_5" ], color:0xffff00});	
					}		
				break;
				case 6:			//称号
					facade.sendNotification(DesignationEvent.OPEN_DESIGNATION_PANEL);
					break;
				case 7: 		//系统设置
					facade.sendNotification(SystemSettingData.OPEN_SETTING_UI);
					break;
				case 8:			//师徒 
					if ( GameCommonData.Player.Role.Level < 10 )
					{
						/** = "10级才能拜师";*/
						sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "Modules_MainSence_Mediator_MainSenceMediator_6" ], color:0xffff00});//"10级才能拜师"	
						return;
					}

					sendNotification( MasterData.CLICK_MASTER_NPC );
					break;
			}
		}
		
		//"btn_Role","btn_Bag","btn_Skill","btn_Partner","btn_Mount"
		public function useQuickBtn(name:String):void
		{
			switch(name) {
				case MainSenceData.mainItemArr[0]://人物
					if(!dataProxy.HeroPropIsOpen)
					{
						//关掉其他面板
						facade.sendNotification(EventList.SHOWONLY, "hero");
						dataProxy.HeroPropIsOpen = true;
						facade.sendNotification(EventList.SHOWHEROPROP);
//						sendNotification(EventList.OPEN_PANEL_TOGETHER);	//组合打开面板
					}
					else
					{
						facade.sendNotification(EventList.CLOSEHEROPROP);
					}
					sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
//					mainSence["btn_0"].mcFlash.stop()
//					mainSence["btn_0"].mcFlash.visible = false;
					break;
				case MainSenceData.mainItemArr[1]://背包
					if(!dataProxy.BagIsOpen)
					{
						sendNotification(EventList.SHOWONLY_CENTER_FIVE_PANEL, "bag");
						facade.sendNotification(EventList.SHOWBAG);
						dataProxy.BagIsOpen = true;
//						sendNotification(EventList.OPEN_PANEL_TOGETHER);	//组合打开面板
					}
					else
					{
						facade.sendNotification(EventList.CLOSEBAG);
					}
					sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
//					mainSence["btn_4"].mcFlash.stop()
//					mainSence["btn_4"].mcFlash.visible = false;
					break;
				case MainSenceData.mainItemArr[2]://技能
					if(!dataProxy.LearnSkillIsOpen)
					{
						//关掉其他面板
//						facade.sendNotification(EventList.SHOWONLY, "skill");
//						dataProxy.SkillIsOpen = true;
//						facade.sendNotification(EventList.SHOWSKILLVIEW);
						
						dataProxy.LearnSkillIsOpen = true;
						facade.sendNotification(SkillConst.LEARNSKILL,{ID:GameCommonData.Player.Role.MainJob.Job});
						
//						sendNotification(EventList.OPEN_PANEL_TOGETHER);	//组合打开面板
					}
					else
					{
						facade.sendNotification(EventList.CLOSE_LEARNSKILL_VIEW);
					}
					sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
//					mainSence["btn_1"].mcFlash.stop()
//					mainSence["btn_1"].mcFlash.visible = false;
					break;
				case MainSenceData.mainItemArr[3]://宠物
					if(!dataProxy.PetCanOperate) 
					{
						facade.sendNotification(EventList.SHOWPETVIEW);
						return;
					}
					if(!dataProxy.PetIsOpen)
					{
						//关掉其他面板
						facade.sendNotification(EventList.SHOWONLY, "pet");
						facade.sendNotification(EventList.SHOWPETVIEW);
//						sendNotification(EventList.OPEN_PANEL_TOGETHER);	//组合打开面板
					}
					else
					{
						facade.sendNotification(EventList.CLOSEPETVIEW);
					}
					sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
//					mainSence["btn_2"].mcFlash.stop()
//					mainSence["btn_2"].mcFlash.visible = false;
					break;
				case MainSenceData.mainItemArr[4]://经脉
					if(GameCommonData.Player.Role.Level >= 13)
					{
						sendNotification(MeridiansEvent.SHOW_MERIDIANS_MAIN_NEW);
					}
					else
					{
						facade.sendNotification(HintEvents.RECEIVEINFO, {info:"需要角色等级13级",color:0xffff00});	
					}
					
					break;
				case MainSenceData.mainItemArr[5]://坐骑
					if(!dataProxy.MountIsOpen)
					{
						//关掉其他面板
//						facade.sendNotification(EventList.SHOWONLY, "pet");
						facade.sendNotification(MountEvent.SHOW_MOUNT_UI);
//						sendNotification(EventList.OPEN_PANEL_TOGETHER);	//组合打开面板
						
					}
					else
					{
						facade.sendNotification(MountEvent.CLOSE_MOUNT_UI);
						
					}
					sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
					break;
				
				case MainSenceData.mainItemArr[6]://锻造
					if(!dataProxy.ForgeIsOpen)
					{
						facade.sendNotification(ForgeEvent.SHOW_FORGE_UI);
						
					}
					else
					{
						facade.sendNotification(ForgeEvent.CLOSE_FORGE_UI);
						
					}
					sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
					break;
				case MainSenceData.mainItemArr[7]://帮派xuxiao
					
					if(GameCommonData.Player.Role.unityId ==0 )//没有帮派
					{
						if ( !facade.hasMediator( JoinUnityMediator.NAME ) )
						{
							facade.registerMediator( new JoinUnityMediator() );
						}
						sendNotification( NewUnityCommonData.SHOW_JOIN_UINTY_NEW );//打开帮派加入面板
					}
					else
					{
						if ( !facade.hasMediator( NewUnityMainMediator.NAME ) )
						{
							facade.registerMediator( new NewUnityMainMediator() );
						}
						sendNotification( NewUnityCommonData.CLICK_NEW_UNITY_BTN );//打开自己的帮派面板
						//dataProxy.UnityIsOpen = true;
						//facade.sendNotification(EventList.SHOWUNITYVIEW);
						//sendNotification(EventList.SHOWONLY_CENTER_FIVE_PANEL, "unity");
						//sendNotification(EventList.OPEN_PANEL_TOGETHER);	//组合打开面板
					}
				
					break;
				
				case MainSenceData.mainItemArr[10]: //宝石 jewel
					if(!dataProxy.StoneIsOpen)
					{
						sendNotification(StoneEvents.OPEN_STONE_VIEW);
					}
					else
					{
						sendNotification(StoneEvents.CLOSE_STONE_UI);
					}
					break;
					
//				case 3:
//					if(!dataProxy.TaskIsOpen)
//					{
//						//关掉其他面板
//						facade.sendNotification(EventList.SHOWONLY, "task");
//						dataProxy.TaskIsOpen = true;
//						facade.sendNotification(EventList.SHOWTASKVIEW);
//						sendNotification(EventList.OPEN_PANEL_TOGETHER);	//组合打开面板
//					}
//					else
//					{
//						facade.sendNotification(EventList.CLOSETASKVIEW);
//					}
//					sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
//					mainSence["btn_3"].mcFlash.stop()
//					mainSence["btn_3"].mcFlash.visible = false;
//					break;
//				case 5:
//					//有消息
//					if(mainSence["btn_5"].mcFlash.visible){
//						this.sendNotification(FriendCommandList.SHOW_RECEIVE_MSG);
//					 }else{
//						 if(!dataProxy.FriendsIsOpen){
////							sendNotification(EventList.SHOWONLY_CENTER_FIVE_PANEL, "friend");
//							facade.sendNotification(FriendCommandList.SHOWFRIEND);
//							dataProxy.FriendsIsOpen=true;
//							sendNotification(EventList.OPEN_PANEL_TOGETHER);	//组合打开面板
//						}else{
//							facade.sendNotification(FriendCommandList.HIDEFRIEND);
//						} 	 
//					}
//					sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
//					break;
//				case 6:
//					if ( NewUnityCommonData.closeUnity )
//					{
//						facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "Modules_MainSence_Mediator_MainSenceMediator_7" ]/** = "帮派功能正在调试，暂时关闭";*/, color:0xffff00});	
//						return;
//					}
////					if(!dataProxy.UnityIsOpen)
////					{
////						if ( GameCommonData.wordVersion == 2 )
////						{
////							facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "Modules_MainSence_Mediator_MainSenceMediator_7" ]/** = "帮派功能正在调试，暂时关闭";*/, color:0xffff00});	
////						}
////						else
////						{
//							if ( !facade.hasMediator( NewUnityMainMediator.NAME ) )
//							{
//								facade.registerMediator( new NewUnityMainMediator() );
//							}
//							sendNotification( NewUnityCommonData.CLICK_NEW_UNITY_BTN );
////						}
////						else
////						{
////							dataProxy.UnityIsOpen = true;
////							facade.sendNotification(EventList.SHOWUNITYVIEW);
////							sendNotification(EventList.SHOWONLY_CENTER_FIVE_PANEL, "unity");
////							sendNotification(EventList.OPEN_PANEL_TOGETHER);	//组合打开面板
////						}
////					}
////					else
////					{
////						facade.sendNotification(EventList.CLOSEUNITYVIEW);
////					}
//					sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
//					mainSence["btn_6"].mcFlash.stop()
//					mainSence["btn_6"].mcFlash.visible = false;
//					break;
//				case 7:
//					if(!dataProxy.TeamIsOpen)
//					{
//						facade.sendNotification(EventList.SHOWTEAM);
//						sendNotification(EventList.SHOWONLY_CENTER_FIVE_PANEL, "team");
//						sendNotification(EventList.OPEN_PANEL_TOGETHER);	//组合打开面板
//					}
//					else 
//					{
//						facade.sendNotification(EventList.REMOVETEAM);
//					}
//					sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
////					mainSence["btn_7"].mcFlash.stop();
////					mainSence["btn_7"].mcFlash.visible = false;
//					break;
//				case 8:
//					if(dataProxy.buildPanelIsOpen){
//						sendNotification(BuildCommonList.CLOSE_BUILD_UI);
//					}else{
//						sendNotification(BuildCommonList.SHOW_BUILD_UI);
//					}
				
				
//					facade.sendNotification(HintEvents.RECEIVEINFO, {info:"此功能暂未开放", color:0xffff00});
 					
//					break;
//				case 9:
					
//					break;
			}
		}
		
		
		protected function initResize(event:Event):void
		{
			sendNotification(EventList.STAGECHANGE);
		}
	}
}