package GameUI.Modules.RoleProperty.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Designation.view.mediator.DesignationMediator;
	import GameUI.Modules.Meridians.view.MeridiansMediator;
	import GameUI.Modules.NewerHelp.Data.NewerHelpEvent;
	import GameUI.Modules.RoleProperty.Datas.RoleEvents;
	import GameUI.Modules.RoleProperty.Datas.RolePropDatas;
	import GameUI.Modules.Bag.Datas.BagEvents;
	import GameUI.Modules.Bag.Proxy.BagData;
	import GameUI.Modules.Hint.Events.HintEvents;
	import GameUI.Modules.RoleProperty.Net.NetAction;
	import GameUI.Modules.Soul.Mediator.SoulMediator;
	import GameUI.Modules.Soul.Proxy.SoulProxy;
	import GameUI.Proxy.DataProxy;
	import GameUI.UIConfigData;
	import GameUI.View.BaseUI.PanelBase;
	import GameUI.Modules.GmTools.Utils.LoadSwfTool;
	import GameUI.Modules.NewerHelp.Data.NewerHelpData;
	import GameUI.UIUtils;
	import GameUI.Modules.NewerHelp.Data.NewerHelpEvent;
	import GameUI.Modules.ToolTip.Const.IntroConst;
	import Net.ActionProcessor.OperateItem;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class RoleMediator extends Mediator
	{
		public static const NAME:String = "RoleMediator";
		private var panelBase:PanelBase;
		private var dataProxy:DataProxy;
		private var isGet:Boolean = false;
		private var tmpItem:Object = null;	//穿装备时临时数据
		//pane
		private var equipMediator:EquipMediator = null;
		private var meridiansMediator:MeridiansMediator = null;
		private var otherMediator:OtherMediator = null;
		private var sourceMediator:SourceMediator = null;
		
		public function RoleMediator()
		{
			super(NAME);
		}
		
		public function get heroProp():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				EventList.INITVIEW,
				EventList.SHOWHEROPROP,
				EventList.CLOSEHEROPROP,
				RoleEvents.HEROPROP_PANEL_INIT_POS,
				RoleEvents.INIT_ROLE_UI,
				EventList.GOHEROVIEW,
				RoleEvents.GETOUTFITBYCLICK,
				RoleEvents.ATTENDPROPELEMENT,
				RoleEvents.HEROPROP_PANEL_STOP_DRAG
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case EventList.INITVIEW:
					dataProxy = facade.retrieveProxy(DataProxy.NAME) as DataProxy;
					
					break;
				
				case RoleEvents.INIT_ROLE_UI:
					facade.sendNotification(RoleEvents.GETFITOUTBYBAG);
					initView();
					//通知新手引导系统
					sendNotification(NewerHelpEvent.OPEN_HEROPROP_PANEL_NOTICE_NEWER_HELP);  //if(NewerHelpData.newerHelpIsOpen) 
					break;
				
				case EventList.SHOWHEROPROP:
					if(heroProp == null){
						RolePropDatas.loadswfTool = new LoadSwfTool(GameConfigData.RolePropUI , this);
						RolePropDatas.loadswfTool.sendShow = sendShow;
					}
					else
					{
						facade.sendNotification(RoleEvents.INIT_ROLE_UI);
					}
					dataProxy.HeroPropIsOpen = true;
					break;
				
				case EventList.CLOSEHEROPROP:
					panelCloseHandler(null);
					break;
				
				case RoleEvents.HEROPROP_PANEL_INIT_POS:	
//					panelBase.x = UIConstData.DefaultPos1.x;
//					panelBase.y = UIConstData.DefaultPos1.y;
					var p:Point = UIConstData.getPos(880,panelBase.height);
					
					panelBase.x = p.x;
					panelBase.y = p.y;
					break;
				
				case RoleEvents.HEROPROP_PANEL_STOP_DRAG:
					if(panelBase) panelBase.IsDrag = false;
					break;
				case RoleEvents.ATTENDPROPELEMENT:		//人物追加的冰火玄毒属性
					var attendArray:Array = notification.getBody() as Array;
					for(var i:int =0; i < 8 ; i++)
					{
						if(i == attendArray[0]) GameCommonData.Player.Role.AttendPro[i] = attendArray[1] as int;
					}
					break;
				case EventList.GOHEROVIEW:
					getoutFit(notification.getBody());
					break;
				case RoleEvents.GETOUTFITBYCLICK:
					getOutFitByClick(notification.getBody());
					break;
			}
		}
		
		private function sendShow(view:MovieClip):void{
			
			this.setViewComponent(RolePropDatas.loadswfTool.GetResource().GetClassByMovieClip(UIConfigData.HEROPROPPANE));
			this.heroProp.mouseEnabled=false;
			panelBase = new PanelBase(heroProp, 505, 440);
			panelBase.name = "HeroProp";
			panelBase.addEventListener(Event.CLOSE, panelCloseHandler);
			panelBase.SetTitleMc(RolePropDatas.loadswfTool.GetResource().GetClassByMovieClip("RolePropIcon"));
			panelBase.SetTitleDesign();
			registerMediator();
			
			facade.sendNotification(RoleEvents.INIT_ROLE_UI);
		}
		
		public function registerMediator():void
		{
			equipMediator = new EquipMediator(heroProp);
			facade.registerMediator(equipMediator);
//			meridiansMediator = new MeridiansMediator(heroProp);
//			facade.registerMediator(meridiansMediator);
//			facade.registerMediator(new SoulMediator(heroProp)); //注册魂魄Mediator
//			facade.sendNotification(SoulProxy.INITSOULMEDIATOR); 
//			otherMediator = new OtherMediator(heroProp);
//			facade.registerMediator(otherMediator);
//			sourceMediator = new SourceMediator(heroProp);
//			facade.registerMediator(sourceMediator);
			facade.sendNotification(RoleEvents.INITROLEVIEW);
			//注册称号mediat
			facade.registerMediator(new DesignationMediator(heroProp));
		}
		
		private function initView():void
		{
//			SoundManager.PlaySound(SoundList.PANEOPEN);
			var p:Point;
			if( dataProxy.BagIsOpen )
			{
				facade.sendNotification(RoleEvents.HEROPROP_PANEL_INIT_POS);
				
			}else{
				p = UIConstData.getPos(505,440);
				panelBase.x = p.x;
				panelBase.y = p.y;
			}
			GameCommonData.GameInstance.GameUI.addChild(panelBase); 
			setPage();
			facade.sendNotification(RoleEvents.SHOWPROPELEMENT, RolePropDatas.CurView);
		}
		
		private function setPage():void
		{
			for( var i:int = 0; i<4; i++ )
			{
				heroProp["prop_"+i].gotoAndStop(1);
				heroProp["prop_"+i].addEventListener(MouseEvent.CLICK, selectView);
				heroProp["prop_"+i].mouseEnabled = true;
				heroProp["prop_"+i].buttonMode = true;
			}
			heroProp["prop_"+RolePropDatas.CurView].gotoAndStop(3);
			heroProp["prop_"+RolePropDatas.CurView].mouseEnabled = false;

			heroProp["prop_2"].mouseEnabled = false;
			heroProp["prop_3"].mouseEnabled = false;
			
		}
		
		private function selectView(e:MouseEvent):void
		{
			var lastPage:int = RolePropDatas.CurView;
			RolePropDatas.CurView = e.currentTarget.name.split("_")[1];
			
			heroProp["prop_"+lastPage].gotoAndStop(1);
			heroProp["prop_"+RolePropDatas.CurView].gotoAndStop(3);
			heroProp["prop_"+lastPage].mouseEnabled = true;
			heroProp["prop_"+RolePropDatas.CurView].mouseEnabled = false;

			closeSubPanel(lastPage);
			openSubPanel(RolePropDatas.CurView);
		}

		private function closeSubPanel(index:int):void
		{
			switch(index)
			{
				case 0:
					facade.sendNotification(RoleEvents.CLOSEEQUIPPANEL);
					break;
				case 1:
					facade.sendNotification(RoleEvents.CLOSDESIGNATIONPANEL);
					break;
//				case 2:
//					facade.sendNotification(EventList.CLOSEPETCOMBINATION);
//					break;
//				case 3:
//					facade.sendNotification(EventList.CLOSEPETFEED);
//					break;

			}
		}
		
		private function openSubPanel(index:int):void
		{
			switch(index)
			{
				case 0:
					facade.sendNotification(RoleEvents.SHOWEQUIPPANEL);

					break;
				case 1:
					facade.sendNotification(RoleEvents.OPENDESIGNATIONPANEL);

					break;
//				case 2:
//					facade.sendNotification(EventList.OPENPETCOMBINATION);
//					this.setEquipVisible(false);
//					this.setBtnVisible(false);
//					facade.sendNotification(PetEvent.HIDE_PET_EQUIP_INFO);
//					break;
//				case 3:
//					this.setEquipVisible(false);
//					this.setBtnVisible(false);
//					facade.sendNotification(EventList.OPENPETFEED);
//					facade.sendNotification(PetEvent.HIDE_PET_EQUIP_INFO);
//					break;
			}
		}
		
		private function panelCloseHandler(event:Event):void
		{
			if(GameCommonData.GameInstance.GameUI.contains(panelBase))
			{
				for( var i:int = 0; i<4; i++ )
				{
					heroProp["prop_"+i].removeEventListener(MouseEvent.CLICK, selectView);
				}
				facade.sendNotification(RoleEvents.MEDIATORGC);
				GameCommonData.GameInstance.GameUI.removeChild(panelBase); 
//				SoundManager.PlaySound(SoundList.PANECLOSE);
				dataProxy.HeroPropIsOpen = false;
				panelBase.IsDrag = true;
				//通知新手引导系统
				sendNotification(NewerHelpEvent.CLOSE_HEROPROP_PANEL_NOTICE_NEWER_HELP);   //if(NewerHelpData.newerHelpIsOpen) 
			}
			
			
		}
		
		private function getoutFit(item:Object):void
		{
			var pos:int = int(item.source.Type/10000);
			var index:int = item.index;
			if(RolePropDatas.ItemPos[index-1] == pos)
			{
				if(UIConstData.getItem(item.source.Type).Sex != GameCommonData.Player.Role.Sex + 1 && UIConstData.getItem(item.source.Type).Sex != 0)
				{
					facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_rp_med_em_1" ], color:0xffff00});   //"性别不符，不能使用"
					BagData.AllLocks[0][BagData.SelectedItem.Index] = false; 	
					BagData.SelectedItem = null;
					facade.sendNotification(BagEvents.SHOWBTN, false);			
					return;
				}
				var o:Object = {}; 
				o.id = item.source.Id;
				o.type = item.source.Type;
				o.isBind = item.source.IsBind;
				if(IntroConst.ItemInfo[item.Id])
					o = IntroConst.ItemInfo[item.Id];
				if(UIUtils.getBindShow(o) == GameCommonData.wordDic[ "mod_rp_med_em_2" ]) {		//装备后绑定的道具先提示    //"装备后绑定"
					tmpItem = item;
					tmpItem.tmpIndex = index;
					facade.sendNotification(EventList.SHOWALERT, {comfrim:dressOn, cancel:cancelDress, extendsFn:cancelDress, info:GameCommonData.wordDic[ "mod_rp_med_em_3" ], title:GameCommonData.wordDic[ "often_used_warning" ]});  //"此物品装备后会绑定，确定要装备上吗？"  //"警 告"
				} else {										//直接装备
					BagData.lockBagGridUnit(false);
					BagData.lockBtnCleanAndPage(false);
					NetAction.UseItem(OperateItem.USE, 1, index, item.source.Id);
//					if(NewerHelpData.newerHelpIsOpen) noticeNewerHelp(item.source.Type);	//通知新手指导系统
				}
			} else {
				BagData.AllLocks[0][BagData.SelectedItem.Index] = false; 	
				item.source.IsLock = false;
			}
		}
		
		private function getOutFitByClick(item:Object):void
		{
			var a:Array = RolePropDatas.ItemPos;
			var typeInt:int = item.Type;
			var type:int = int(typeInt/10000);
			for(var i:int = 0; i<RolePropDatas.ItemPos.length; i++)
			{
				if(RolePropDatas.ItemPos[i] == type)
				{

					if(UIConstData.getItem(item.Type).Sex != GameCommonData.Player.Role.Sex + 1 && UIConstData.getItem(item.Type).Sex != 0)
					{
						facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_rp_med_em_1" ], color:0xffff00});   //"性别不符，不能使用"
						BagData.AllLocks[0][BagData.SelectedItem.Index] = false; 	
						item.IsLock = false;
						BagData.SelectedItem = null;
						facade.sendNotification(BagEvents.SHOWBTN, false);			
						return;
					}
					var o:Object = {}; 
					o.id = item.Id;
					o.type = item.Type;
					o.isBind = item.IsBind;
					if(IntroConst.ItemInfo[item.Id])
						o = IntroConst.ItemInfo[item.Id];
					if(UIUtils.getBindShow(o) == GameCommonData.wordDic[ "mod_rp_med_em_2" ]) {		//装备后绑定的道具先提示     //"装备后绑定"
						tmpItem = {};
						tmpItem.source = item;
						tmpItem.tmpIndex = i+1;
						facade.sendNotification(EventList.SHOWALERT, {comfrim:dressOn, cancel:cancelDress, extendsFn:cancelDress, info:GameCommonData.wordDic[ "mod_rp_med_em_3" ], title:GameCommonData.wordDic[ "often_used_warning" ]});  //"此物品装备后会绑定，确定要装备上吗？"   "警 告"  
					} else {				
						//点击背包中魂魄时，打开魂魄界面，并装备
						//						var tmp:Object = BagData.SelectedItem.Item;
						//						if(int(BagData.SelectedItem.Item.type/10) == SoulData.soulType/10)
						//						{
						//							var dataProxy:DataProxy = facade.retrieveProxy(DataProxy.NAME) as DataProxy;
						//							if(!dataProxy.HeroPropIsOpen)
						//							{
						//								dataProxy.HeroPropIsOpen = true;
						//								facade.sendNotification(EventList.SHOWHEROPROP);
						//								sendNotification(EventList.OPEN_PANEL_TOGETHER);
						//							}
						//							if(RolePropDatas.CurView != SoulMediator.TYPE)
						//							{
						//								(facade.retrieveMediator(RoleMediator.NAME) as RoleMediator).heroProp["prop_2"].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
						//							}
						//						}						//直接装备
						BagData.lockBagGridUnit(false);
						BagData.lockBtnCleanAndPage(false); 
						//						if(RolePropDatas.ItemPos[i] == 21) {
						//							lastRingPos = i;
						//						} else if(RolePropDatas.ItemPos[i] == 22) {
						//							lastJadePos = i;
						//						}
						
						NetAction.UseItem(OperateItem.USE, 1, i+1, item.Id);
						BagData.AllLocks[0][BagData.SelectedItem.Index] = false; 	
						item.IsLock = false;
//						if(NewerHelpData.newerHelpIsOpen) noticeNewerHelp(item.Type);	//通知新手指导系统
					}
					break;
				}
			}
		}
		
		/** 不装备物品 */
		private function cancelDress():void
		{
			if(tmpItem) {
				sendNotification(EventList.BAGITEMUNLOCK, tmpItem.source.Id);
				tmpItem = null;
			}
		}
		
		/** 确定装备上物品 */
		private function dressOn():void
		{
			if(tmpItem) {
//				//点击背包中魂魄时，打开魂魄界面，并装备
//				if(int(BagData.SelectedItem.Item.Type/10) == SoulData.soulType/10)
//				{
//					var dataProxy:DataProxy = facade.retrieveProxy(DataProxy.NAME) as DataProxy;
//					if(!dataProxy.HeroPropIsOpen)
//					{
//						dataProxy.HeroPropIsOpen = true;
//						facade.sendNotification(EventList.SHOWHEROPROP);
//						sendNotification(EventList.OPEN_PANEL_TOGETHER);
//					}
//					if(RolePropDatas.CurView != SoulMediator.TYPE)
//					{
//						(facade.retrieveMediator(RoleMediator.NAME) as RoleMediator).heroProp["prop_2"].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
//					}
//				}
				
				BagData.lockBagGridUnit(false);
				BagData.lockBtnCleanAndPage(false);
//				if(RolePropDatas.ItemPos[tmpItem.tmpIndex-1] == 21) {
//					lastRingPos = tmpItem.tmpIndex-1;
//				} else if(RolePropDatas.ItemPos[tmpItem.tmpIndex-1] == 22) {
//					lastJadePos = tmpItem.tmpIndex-1;
//				}
				NetAction.UseItem(OperateItem.USE, 1, tmpItem.tmpIndex, tmpItem.source.Id);
				tmpItem = null;
			}
		}
	}
}