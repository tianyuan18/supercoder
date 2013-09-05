package GameUI.Modules.RoleProperty.Mediator
{
	import Controller.PlayerSkinsController;
	
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Bag.Datas.BagEvents;
	import GameUI.Modules.Bag.Proxy.BagData;
	import GameUI.Modules.Hint.Events.HintEvents;
	import GameUI.Modules.NewerHelp.Data.NewerHelpData;
	import GameUI.Modules.NewerHelp.Data.NewerHelpEvent;
	import GameUI.Modules.RoleProperty.Datas.RoleEvents;
	import GameUI.Modules.RoleProperty.Datas.RolePropDatas;
	import GameUI.Modules.RoleProperty.Mediator.UI.PlayerAttribute;
	import GameUI.Modules.RoleProperty.Net.NetAction;
	import GameUI.Modules.RoleProperty.Prxoy.ItemManager;
	import GameUI.Modules.RoleProperty.Prxoy.ItemUnit;
	import GameUI.Modules.Soul.Data.SoulData;
	import GameUI.Modules.Soul.Mediator.SoulMediator;
	import GameUI.Modules.ToolTip.Const.IntroConst;
	import GameUI.Proxy.DataProxy;
	import GameUI.UIConfigData;
	import GameUI.UIUtils;
	import GameUI.View.BaseUI.ItemBase;
	import GameUI.View.PlayerModel;
	import GameUI.View.items.EquipItem;
	
	import Net.ActionProcessor.OperateItem;
	import Net.ActionSend.PlayerActionSend;
	
	import OopsEngine.Role.RoleJob;
	import OopsEngine.Role.SkinNameController;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class EquipMediator extends Mediator
	{
		public static const NAME:String = "EquipMediator";
		public static const TYPE:int = 0;
		private var itemManager:ItemManager;
		private var isGet:Boolean = false;
		private var parentView:MovieClip = null;
		private var curJob:RoleJob = null;
		public var playerAttribute:PlayerAttribute = null;
		
		private var lastRingPos:int = 0;	//上次装备的戒指位置
		private var lastJadePos:int = 0;	//上次装备的饰品位置
		
		private var startTime:Number;		//切换显示时装的上次时间
		private const HANDLERTIME:int = 10;	//显示换装的间隔，10秒
		
		private var animal:PlayerModel;
		
		public function EquipMediator(parent:MovieClip)
		{
			parentView = parent;
			super(NAME);
		}
		
		private function get equip():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				RoleEvents.INITROLEVIEW,
				RoleEvents.SHOWPROPELEMENT,
				RoleEvents.GETOUTFIT,
				//				EventList.CLOSEHEROPROP,
				EventList.GOHEROVIEW,
				RoleEvents.UPDATEOUTFIT,
				RoleEvents.GETOUTFITBYCLICK,
				RoleEvents.GETFITOUTBYBAG,
				EventList.UPDATEATTRIBUATT,
				RoleEvents.UPDATEADDATT,
				RoleEvents.ATTENDPROPELEMENT,
				RoleEvents.PLAYER_CHANGE_JOB,
				RoleEvents.CLOSEEQUIPPANEL,
				RoleEvents.SHOWEQUIPPANEL,
				RoleEvents.ISSHOWDRESS,
				RoleEvents.CHANGE_MODEL
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case RoleEvents.INITROLEVIEW:
					this.setViewComponent(RolePropDatas.loadswfTool.GetResource().GetClassByMovieClip(UIConfigData.EQUIPPANE));
					this.equip.mouseEnabled=false;
					viewComponent.y += 10;
					itemManager = new ItemManager();
					facade.registerProxy(itemManager);
					playerAttribute = new PlayerAttribute(equip);
					initView();
					break;
				case RoleEvents.GETFITOUTBYBAG:
					if(!isGet)
					{
						//						NetAction.RequestOutfit();
						
						if(GameCommonData.Player.Role.ViceJob.Job != 0)
						{
							var cur:uint=GameCommonData.Player.Role.CurrentJob==1 ? 2 : 1;
							NetAction.GetRoleInfo(cur);
						}
						isGet = true;
					}
					break;
				case RoleEvents.SHOWPROPELEMENT:
					if(notification.getBody() as int != TYPE) return;					
					parentView.addChildAt(equip, 4);
					if(!isGet)
					{
						NetAction.RequestOutfit();
						isGet = true;	
					} else {
						initItem();	
						playerAttribute.ShowPropData();		
					}
					facade.sendNotification(RoleEvents.ISSHOWDRESS , GameCommonData.Player.Role.IsShowDress);
					if(animal&&!animal.running){
						animal.play();
					}
					
					break;
				case RoleEvents.GETOUTFIT:
					initItem();
					playerAttribute.ShowPropData();		
					break;
				case RoleEvents.UPDATEOUTFIT:
					initItem();
					break;
				
				case EventList.UPDATEATTRIBUATT:
					playerAttribute.UpDateAttribute(notification.getBody());
				case RoleEvents.UPDATEADDATT:
					playerAttribute.UpDateExtendAttribute(notification.getBody());
					break;
				//				case RoleEvents.ATTENDPROPELEMENT:		//人物追加的冰火玄毒属性
				//					var attendArray:Array = notification.getBody() as Array;
				//					for(var i:int =0; i < 8 ; i++)
				//					{
				//						if(i == attendArray[0]) GameCommonData.Player.Role.AttendPro[i] = attendArray[1] as int;
				//					}
				//				break;
				
				case RoleEvents.PLAYER_CHANGE_JOB:
					initItem();	
					playerAttribute.ShowPropData();
					break;		
				case RoleEvents.ISSHOWDRESS:			//是否显示时装
					if(notification.getBody())
					{
						GameCommonData.Player.Role.IsShowDress = true;
						if(equip) 
						{
							//						 equip.mcCheckBox.gotoAndStop(2);
							
						}
					}
					else
					{
						GameCommonData.Player.Role.IsShowDress = false;
						//						if(equip) equip.mcCheckBox.gotoAndStop(1);
					}
					break;
				case RoleEvents.CLOSEEQUIPPANEL:
					equip.visible = false;
					if(animal&&animal.running){
						animal.play();
					}
					break;
				
				case RoleEvents.SHOWEQUIPPANEL:
					equip.visible = true;
					if(animal&&!animal.running){
						animal.stop();
					}
					break;
				case RoleEvents.CHANGE_MODEL:
					changeModel(notification.getBody() as Object);
					break;
			}
			
		}
		
		private function initView():void
		{
			equip.roleName.text = GameCommonData.Player.Role.Name;
			var p:Array = RolePropDatas.ItemList;
			for(var i:int = 1; i<=RolePropDatas.EquipNum; i++)
			{
				var itemUnit:ItemUnit = new ItemUnit();
				if(i != 16)
				{
					itemUnit.Grid = equip["hero_"+i];
					itemUnit.Grid.mouseChildren = false;
				}
				else
				{
					//					itemUnit.Grid = (facade.retrieveMediator(SoulMediator.NAME) as SoulMediator).soulView["hero_"+i];
				}
				itemUnit.Item = null;
				itemUnit.Index  = i-1;
				itemUnit.IsUsed = false;
				RolePropDatas.ItemUnitList.push(itemUnit);
				equip["hero_12"].visible = false;
				equip["hero_12"].mouseEnabled = false;
			}
			//			equip.mcCheckBox.addEventListener(MouseEvent.CLICK, showDress);
			itemManager.Initialize();
			
			
			var skinNames:SkinNameController = PlayerSkinsController.GetSkinName(GameCommonData.Player);
			
			animal = new PlayerModel(skinNames.PersonSkinName.replace("Person","PersonR"),skinNames.WeaponSkinName.replace("Weapon","WeaponR"));
			
			equip.mc_model.addChild(animal);
			(equip.mc_model as MovieClip).mouseChildren = false;
			(equip.mc_model as MovieClip).mouseEnabled = false;
			equip.btnClose.gotoAndStop(2);
			equip.btnFly.gotoAndStop(2);
		}
		
		//任务换装更改模型
		private function changeModel(data:Object):void {
			var type:int = data[0] as int;
		
			if(animal){
				var skinNames:SkinNameController = PlayerSkinsController.GetSkinName(GameCommonData.Player);
				if(type  >= 140000 && type < 150000){
					//武器
					if(String(data[1])){
						animal.changeWeapon(skinNames.WeaponSkinName.replace("Weapon","WeaponR"));
					}else{
						animal.changeWeapon("");
					}
					
				}else if(type  >= 120000 && type  <  130000){
					//衣服
					if(String(data[1])){
						animal.changePerson(skinNames.PersonSkinName.replace("Person","PersonR"));
					}else{
						animal.changePerson("");
					}
					
				}
			}
		}
		
		/**
		 * 初始化装备图标或更新装备图标 
		 * 
		 */					
		private function initItem():void
		{
			removeAllItem();
			if(RolePropDatas.ItemUnitList.length == 0) return;
			for(var i:int = 0; i<RolePropDatas.ItemList.length; i++)
			{
				if(i>11) return;
				if(RolePropDatas.ItemList[i] == undefined) continue; 
				var useItem:EquipItem;
				//				var useItem:UseItem = new UseItem(RolePropDatas.ItemList[i].position - 1, RolePropDatas.ItemList[i].type, equip);
				//				if(i != RolePropDatas.ItemList.length -1)
				//				{
				//					
				useItem = new EquipItem(RolePropDatas.ItemList[i].position - 1, RolePropDatas.ItemList[i].type, equip, RolePropDatas.ItemList[i].color);
				var quickBgName:String;
				if(int(RolePropDatas.ItemList[i].color) > 1){
					quickBgName = "quickBg"+int(RolePropDatas.ItemList[i].color);
				}else{
					quickBgName = "QuickEQItemBg";
				}
				var bg:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip(quickBgName);	
				bg.name = 'itemBg';
				bg.x = -3;
				bg.y = -3;
				useItem.addChild(bg);
				
				useItem.setImageScale(32,32);
				//				}
				//				else
				//				{
				//					var parentDis:DisplayObjectContainer = (facade.retrieveMediator(SoulMediator.NAME) as SoulMediator).soulView;
				//					useItem = new EquipItem(RolePropDatas.ItemList[i].position - 1, RolePropDatas.ItemList[i].type, parentDis, RolePropDatas.ItemList[i].color);
				//					useItem.name = "soulHer_16";
				//					return;
				//				}
				useItem.x = RolePropDatas.ItemUnitList[i].Grid.x + 3;
				useItem.y = RolePropDatas.ItemUnitList[i].Grid.y + 3;
				useItem.Id = RolePropDatas.ItemList[i].id;
				useItem.IsBind = RolePropDatas.ItemList[i].isBind;
				useItem.Type = RolePropDatas.ItemList[i].type;
				useItem.Pos = i;
				var u:Object = RolePropDatas.ItemUnitList;
				var ri:Object = RolePropDatas.ItemList;
				
				RolePropDatas.ItemUnitList[RolePropDatas.ItemList[i].position - 1].Item = useItem;
				RolePropDatas.ItemUnitList[RolePropDatas.ItemList[i].position - 1].IsUsed = true;
				var obj:Object=UIConstData.getItem(useItem.Type); 
				var objInfo:Object=IntroConst.ItemInfo[useItem.Id];
				//职业不符漂红
				useItem.setNoFitJobShape(false);
				if(GameCommonData.Player.Role.MainJob.Job!=4096){
					if(GameCommonData.Player.Role.CurrentJob==1){
						if(obj!=null && obj.Job!=0 && obj.Job!=GameCommonData.Player.Role.MainJob.Job){
							useItem.setNoFitJobShape(true);
						}
					}else if(GameCommonData.Player.Role.CurrentJob==2){
						if(obj!=null && obj.Job!=0 && obj.Job!=GameCommonData.Player.Role.ViceJob.Job){
							useItem.setNoFitJobShape(true);
						}
					}	
				}
				//耐久不够漂红
				if(objInfo!=null){
					//耐久不够漂红
					if(objInfo.type != 250000)
					{
						if(objInfo.amount==0){
							useItem.setNoFitJobShape(true);
						}
					}
					//过期也漂红
					if(objInfo.isActive==2){
						useItem.setNoFitJobShape(true);
					}
				}
				useItem.IsLock = false;
				if(i != RolePropDatas.ItemList.length - 1)
				{
					if(i!=11)
					{
						equip.addChild(useItem); 
					}
					
				}
				else
				{
					(facade.retrieveMediator(SoulMediator.NAME) as SoulMediator).soulView.addChild(useItem);
				}
			}
		}
		
		/** 通知新手指导系统 */
		private function noticeNewerHelp(type:uint):void
		{
			if(type == 142000) {	//侠义剑
				sendNotification(NewerHelpEvent.DRESSON_NOTICE_NEWER_HELP, 1);	//sendNotification(NewerHelpEvent.REMOVE_NEWER_HELP_BY_TYPE, 1);
				return;
			}
			if(type == 120000) {	//侠义袍
				sendNotification(NewerHelpEvent.REMOVE_NEWER_HELP_BY_TYPE, 3);
				return;
			}
			if(type == 130016) {	//侠义冠
				sendNotification(NewerHelpEvent.REMOVE_NEWER_HELP_BY_TYPE, 5);
				return;
			}
			if(type == 144000) {	//湛卢剑
				sendNotification(NewerHelpEvent.REMOVE_NEWER_HELP_BY_TYPE, 8);
				return;
			}
			var pos:int = NewerHelpData.getTypePos(type);
			if(pos >= 0) {			//穿套装
				sendNotification(NewerHelpEvent.LOOP_DELETE_GRID_NOTICE_NEWER_HELP, {type:11, pos:pos});
				return;
			}
			pos = NewerHelpData.getFirstBagPos(type);
			if(pos >= 0) {
				sendNotification(NewerHelpEvent.LOOP_DELETE_GRID_NOTICE_NEWER_HELP, {type:41, pos:pos});
				return;
			}
			pos = NewerHelpData.getSecondBagPos(type);
			if(pos >= 0) {
				sendNotification(NewerHelpEvent.LOOP_DELETE_GRID_NOTICE_NEWER_HELP, {type:44, pos:pos});
				return;
			}
		}
		
		/** 点击显示时装 */
		private function showDress(event:MouseEvent):void
		{
			var list:Array = RolePropDatas.ItemList;
			var date:Date = new Date();
			if(date.getTime() - this.startTime < this.HANDLERTIME * 1000)
			{
				facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_rp_med_em_4" ] + (this.HANDLERTIME - int((date.getTime() - this.startTime) / 1000)) +GameCommonData.wordDic[ "mod_rp_med_em_5" ], color:0xffff00});   //"离下次操作还需等待"   "秒" 
				date = null;
				return;
			} 
			this.startTime = date.getTime();
			date = null;
			for(var i:int = 0; i< RolePropDatas.ItemList.length; i++)
			{
				if(RolePropDatas.ItemList[i] && int(RolePropDatas.ItemList[i].type / 10000) == 23 )
				{
					var data:Array = [];
					//显示 或 隐藏时装的代码
					if(GameCommonData.Player.Role.IsShowDress)
					{
						data =[0,GameCommonData.Player.Role.Id,0,0,0,0,299,0,0];
						//						facade.sendNotification(RoleEvents.ISSHOWDRESS , false);
					}
					else
					{
						data =[0,GameCommonData.Player.Role.Id,0,0,1,0,299,0,0];
						//						facade.sendNotification(RoleEvents.ISSHOWDRESS , true);
					}
					var obj:Object={type:1010,data:data};
					PlayerActionSend.PlayerAction(obj);
					data = null;
					obj = null;
					//
					return;
				}
			}
			
			//目前没有，测试
			facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_rp_med_em_6" ], color:0xffff00});    //"请先穿上时装"
		}
		
		private function removeAllItem():void
		{
			var count:int = equip.numChildren - 1;
			while(count>=0)
			{
				if(equip.getChildAt(count) is ItemBase)
				{
					var item:ItemBase = equip.getChildAt(count) as ItemBase;
					equip.removeChild(item);
					item = null;
				}
				count--;
			}
			if(RolePropDatas.ItemUnitList.length == 0) return;
			for( var i:int = 0; i<RolePropDatas.ItemUnitList.length; i++ ) 
			{
				if( i == RolePropDatas.ItemUnitList.length - 1)
				{
					var soulItem:DisplayObject = RolePropDatas.ItemUnitList[i].Item;
					if(soulItem)
					{
						if(soulItem.parent)
						{
							soulItem.parent.removeChild(soulItem);
						}
					}
				}
				RolePropDatas.ItemUnitList[i].Item = null;
				RolePropDatas.ItemUnitList[i].IsUsed = false
			}
		}
	}
}