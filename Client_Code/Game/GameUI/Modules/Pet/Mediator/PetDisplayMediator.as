package GameUI.Modules.Pet.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Mediator.UiNetAction;
	import GameUI.Modules.Bag.Proxy.GridUnit;
	import GameUI.Modules.GmTools.Utils.LoadSwfTool;
	import GameUI.Modules.Hint.Events.HintEvents;
	import GameUI.Modules.Pet.Data.PetEvent;
	import GameUI.Modules.Pet.Data.PetPropConstData;
	import GameUI.Modules.Pet.Proxy.PetNetAction;
	import GameUI.Modules.Pet.UI.PetUIManager;
	import GameUI.Modules.Pet.UI.ShowPetModuleComponent;
	import GameUI.Proxy.DataProxy;
	import GameUI.UIConfigData;
	import GameUI.View.BaseUI.PanelBase;
	import GameUI.View.items.UseItem;
	import Net.ActionProcessor.PlayerAction;
	import Net.ActionProcessor.ItemInfo;
	
	import OopsEngine.Role.GamePetRole;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PetDisplayMediator extends Mediator
	{
		public static const NAME:String = "PetDisplayMediator";
		private var panelBase:PanelBase;
		private var parentView:MovieClip;
		private var equipGridUnitList:Array = new Array(4);
//		private var _fight:int = 0; //0 休息，1 站斗
		private var timer:Timer;
		private var timerOut:Timer;
		
//		private var petMoreInfoMediator:PetMoreInfoMediator;
		private var _showPetModule:ShowPetModuleComponent = null;
		private var petEquipNameList:Array = ["equipment_necklace","equipment_weapon","equipment_ring","equipment_shoe"];
		private var loadswfTool:LoadSwfTool;
		
		private var cacheCells:Array=[];
		
		public function PetDisplayMediator(parentMc:MovieClip, _loadswfTool:LoadSwfTool=null)
		{
			parentView = parentMc;
			super(NAME);
			this.loadswfTool = _loadswfTool;
		}

		public function get PetDisplay():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				EventList.INITPETPANEL,
				PetEvent.PET_UPDATE_SHOW_INFO,			//更新数据
				EventList.OPENPETDISPLAY,					//打开宠物浏览
				PetEvent.UPDATE_PET_EQUIPINFO,
				PetEvent.SHOW_PET_EQUIP_INFO,
				PetEvent.HIDE_PET_EQUIP_INFO,
				EventList.CLOSEPETDISPLAY					//关闭宠物浏览
				
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case EventList.INITPETPANEL:
//					facade.sendNotification(EventList.GETRESOURCE, {type:UIConfigData.MOVIECLIP, mediator:this, name:"petDisplay"});
					this.setViewComponent(this.loadswfTool.GetResource().GetClassByMovieClip("petDisplay"));
					this.PetDisplay.mouseEnabled=false;
					timer = new Timer(5000, 1);
					timerOut = new Timer(5000, 1);
					break;
				case EventList.OPENPETDISPLAY:
					registerView();
					initData();
					
					PetDisplay.x = 167;
					PetDisplay.y = 43;
					PetDisplay.mouseEnabled = false;
					parentView.addChild(PetDisplay);
					break;
				case EventList.CLOSEPETDISPLAY:
					retrievedView();
					parentView.removeChild(PetDisplay);
					break;
				case PetEvent.PET_UPDATE_SHOW_INFO:
					initData();
					if(PetPropConstData.curPage==1)
					{
						initEquip();
					}
//					
					break;
				case PetEvent.UPDATE_PET_EQUIPINFO:
					var index:int = notification.getBody() as int;
					
					showPetEquipInfo(index);
					break;
				case PetEvent.SHOW_PET_EQUIP_INFO:
					initEquip();
					break;
				case PetEvent.HIDE_PET_EQUIP_INFO:
					clearEquip();
					break;
			}
		}
		
		private function initData():void
		{
			//获取宠物数据
//			initPetUiManager();
			if(_showPetModule != null)
			{
				_showPetModule.deleteView();
				_showPetModule = null;
			}
			
			PetDisplay.mcSex.visible = false;
			(PetDisplay.mcSex as MovieClip).mouseEnabled = false;
			var tmpPet:GamePetRole = GameCommonData.Player.Role.PetSnapList[PetPropConstData.selectedPetId];
			if(tmpPet == null)return;
			var petClass:String = tmpPet.FaceType.toString();
			_showPetModule = new ShowPetModuleComponent(PetDisplay);
			if(PetPropConstData.newPetModuleSwf[petClass])
			{
				petClass = PetPropConstData.newPetModuleSwf[petClass];
			}
			_showPetModule.showView(petClass);
			
			PetDisplay.txtQuality.text = tmpPet.Potential;
			PetDisplay.txtScore.text = 100;
			PetDisplay.mcSex.visible = true;
			if(tmpPet.Sex == 0)//雄
			{
				PetDisplay.mcSex.gotoAndStop(2);
			}else
			{
				PetDisplay.mcSex.gotoAndStop(1);
			}
			if(PetPropConstData.curPage == 0)
			{
				if(tmpPet.State == 0)
				{
					PetDisplay.mc_Fight.visible = true;
					(PetDisplay.mc_Fight as MovieClip).mouseEnabled = true
					PetDisplay.mc_Rest.visible = false;
					(PetDisplay.mc_Rest as MovieClip).mouseEnabled = false
				}else
				{
					PetDisplay.mc_Fight.visible = false;
					(PetDisplay.mc_Fight as MovieClip).mouseEnabled = false
					PetDisplay.mc_Rest.visible = true;
					(PetDisplay.mc_Rest as MovieClip).mouseEnabled = true
				}
			}
		}
		
		private function initEquip():void
		{
			this.clearEquip();
			var pet:Object = GameCommonData.Player.Role.PetSnapList[PetPropConstData.selectedPetId];
			if(!pet)return;
			if(pet.equipment_necklace != 0)
			{
				if(PetPropConstData.petEquipInfoList[pet.equipment_necklace])
				{
					showPetEquipInfo(0);
				}
				else
				{
					UiNetAction.GetPetInfo(
						pet.equipment_necklace,
						GameCommonData.Player.Role.Id,
						GameCommonData.Player.Role.Name,
						ItemInfo.PET_UI_UPDATE_NECK,
						PetPropConstData.selectedPetId,
						21);
				}
			}
			if(pet.equipment_weapon != 0)
			{
				if(PetPropConstData.petEquipInfoList[pet.equipment_weapon])
				{
					showPetEquipInfo(1);
				}
				else
				{
					UiNetAction.GetPetInfo(
						pet.equipment_weapon,
						GameCommonData.Player.Role.Id,
						GameCommonData.Player.Role.Name,
						ItemInfo.PET_UI_UPDATE_WEAPON,
						PetPropConstData.selectedPetId,
						22);
				}
				
			}
			if(pet.equipment_ring != 0)
			{
				if(PetPropConstData.petEquipInfoList[pet.equipment_ring])
				{
					showPetEquipInfo(2);
				}
				else
				{
					UiNetAction.GetPetInfo(
						pet.equipment_ring,
						GameCommonData.Player.Role.Id,
						GameCommonData.Player.Role.Name,
						ItemInfo.PET_UI_UPDATE_RING,
						PetPropConstData.selectedPetId,
						23);
				}
				
			}
			if(pet.equipment_shoe != 0)
			{
				if(PetPropConstData.petEquipInfoList[pet.equipment_shoe])
				{
					showPetEquipInfo(3);
				}
				else
				{
					UiNetAction.GetPetInfo(
						pet.equipment_shoe,
						GameCommonData.Player.Role.Id,
						GameCommonData.Player.Role.Name,
						ItemInfo.PET_UI_UPDATE_SHOES,
						PetPropConstData.selectedPetId,
						24);
				}
				
			}
			
//			for(var i:int=0;i<4;i++)
//			{
//				showPetEquipInfo(i);
//			}
		}
		
		private function clearEquip():void
		{
			for(var i:int=0;i<4;i++)
			{
				this.clearPetEquipInfo(i);
			}
		}
		
		/**
		 * 装备栏显示宠物装备
		 */
		private function showPetEquipInfo(index:int):void
		{
			
			if(PetPropConstData.selectedPetId)
			{
				//获取宠物信息
				var a:Object = PetPropConstData.petEquipInfoList;
				var pet:Object = GameCommonData.Player.Role.PetSnapList[PetPropConstData.selectedPetId];
				if(!pet)return;
				//				
				//				for(var i:int = 0;i<equipGridUnitList.length; i++)
				//				{
				//					if(pet[petEquipNameList[index]]==0)return;
				//					//获取装备信息
				var item:Object = PetPropConstData.petEquipInfoList[pet[petEquipNameList[index]]];
				//item为空，表示
				if(item)
				{
					this.clearPetEquipInfo(index);
					
					var useItem:UseItem = this.getCells(item.index, item.type, PetDisplay);
					useItem.x = PetDisplay["petEquip_"+index.toString()].x+2;
					useItem.y = PetDisplay["petEquip_"+index.toString()].y+2;
					useItem.Id = item.id;
					useItem.IsBind = item.isBind;
					useItem.Type = item.type;
					
					PetDisplay.addChild(useItem);
					
//					var gridUnit:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("petEquip_"+index.toString());
//					gridUnit.x = PetDisplay["petEquip_"+index.toString()].x;
//					gridUnit.y = PetDisplay["petEquip_"+index.toString()].y;
//					PetDisplay.addChild(gridUnit);
					var equip:GridUnit = new GridUnit(PetDisplay["petEquip_"+index.toString()], true);//选中装备
					equip.parent = PetDisplay;									//设置父级
					equip.Item = useItem;
					equip.Index = item.index;
//					equip.Grid.name = "bag_" + item.index.toString()+"_"+index.toString();
					equip.Grid.addEventListener(MouseEvent.DOUBLE_CLICK,onUnEquip);
					
					equipGridUnitList[index] = equip;
				}
				else
				{
					this.clearPetEquipInfo(index);
					//						if(pet[petEquipNameList[i]] == 0)
					//						{
					//							continue;
					//						}
					//							
					//						UiNetAction.GetItemInfo(pet[petEquipNameList[i]], GameCommonData.Player.Role.Id, GameCommonData.Player.Role.Name, ItemInfo.PET_UI_UPDATE);
				}
				//				}
				
			}
		}
		
		private function onUnEquip(e:MouseEvent):void
		{
			var index:String = e.currentTarget.name.split("_")[1];
			var id:int = equipGridUnitList[index].Item.Id;
			switch(index)
			{
				case "0":
					PetNetAction.opPet(PlayerAction.NEWPET_PLAY_UNEQUIP, PetPropConstData.selectedPetId,"",id);
					break;
				case "1":
					PetNetAction.opPet(PlayerAction.NEWPET_PLAY_UNEQUIP, PetPropConstData.selectedPetId,"",id);
					break;
				case "2":
					PetNetAction.opPet(PlayerAction.NEWPET_PLAY_UNEQUIP, PetPropConstData.selectedPetId,"",id);
					break;
				case "3":
					PetNetAction.opPet(PlayerAction.NEWPET_PLAY_UNEQUIP, PetPropConstData.selectedPetId,"",id);
					break;
			}
		}
		
		private function clearPetEquipInfo(index:int):void
		{
			var equip:GridUnit = equipGridUnitList[index];
			if(equip != null && equip.Item != null)
			{
//				clearMaterialAtIndex(equip.Item.Id);
				equip.Item.reset();
				equip.Item.gc();
				if(PetDisplay.contains(equip.Item as UseItem))
				{
					PetDisplay.removeChild(equip.Item as UseItem);
				}
//				if(PetDisplay.contains(equip.Grid))
//				{
//					equip.Grid.removeEventListener(MouseEvent.CLICK,onUnEquip);
//					PetDisplay.removeChild(equip.Grid);
//				}
				equip.Grid.removeEventListener(MouseEvent.DOUBLE_CLICK,onUnEquip);
				equipGridUnitList[index] = null;
			}
		}
		
		private function registerView():void
		{
			//初始化素材事件
			
			PetDisplay.btnLeft.addEventListener(MouseEvent.CLICK,onBtnClick);
			PetDisplay.btnRight.addEventListener(MouseEvent.CLICK,onBtnClick);
			
			PetDisplay.mcSex.gotoAndStop(1);
			PetDisplay.mc_Together.gotoAndStop(1);
			PetDisplay.mc_Fight.gotoAndStop(1);
			PetDisplay.mc_Rest.gotoAndStop(1);
			PetDisplay.mc_Fight.visible = false;
			
			(PetDisplay.mc_Fight as MovieClip).mouseChildren = false;
			(PetDisplay.mc_Rest as MovieClip).mouseChildren = false;
			
			PetDisplay.mc_Together.visible = false;
			PetDisplay.mc_Together.mouseEnabled = false;
			PetDisplay.mc_Together.mouseChildren = false;
			
			PetDisplay.mc_Together.addEventListener(MouseEvent.CLICK,onBtnClick);
			PetDisplay.mc_Fight.addEventListener(MouseEvent.CLICK,onBtnClick);
			PetDisplay.mc_Rest.addEventListener(MouseEvent.CLICK,onBtnClick);
			
			PetDisplay.mc_Together.addEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
			PetDisplay.mc_Fight.addEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
			PetDisplay.mc_Rest.addEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
			
			PetDisplay.mc_Together.addEventListener(MouseEvent.MOUSE_OUT,onBtnOut);
			PetDisplay.mc_Fight.addEventListener(MouseEvent.MOUSE_OUT,onBtnOut);
			PetDisplay.mc_Rest.addEventListener(MouseEvent.MOUSE_OUT,onBtnOut);
			
			PetDisplay.mc_Together.addEventListener(MouseEvent.MOUSE_UP,onBtnUp);
			PetDisplay.mc_Fight.addEventListener(MouseEvent.MOUSE_UP,onBtnUp);
			PetDisplay.mc_Rest.addEventListener(MouseEvent.MOUSE_UP,onBtnUp);
			
			PetDisplay.mc_Together.addEventListener(MouseEvent.MOUSE_DOWN,onBtnDown);
			PetDisplay.mc_Fight.addEventListener(MouseEvent.MOUSE_DOWN,onBtnDown);
			PetDisplay.mc_Rest.addEventListener(MouseEvent.MOUSE_DOWN,onBtnDown);
			
			for(var i:int=0;i<4;i++)
			{
				PetDisplay["petEquip_"+i].visible = false;
				PetDisplay["petEquip_"+i].mouseChildren = false;
			}
		}
		
		private function retrievedView():void
		{
			//释放素材事件
			PetDisplay.mc_Together.removeEventListener(MouseEvent.CLICK,onBtnClick);
			PetDisplay.btnLeft.removeEventListener(MouseEvent.CLICK,onBtnClick);
			PetDisplay.btnRight.removeEventListener(MouseEvent.CLICK,onBtnClick);
			PetDisplay.mc_Fight.removeEventListener(MouseEvent.CLICK,onBtnClick);
			
			
			PetDisplay.mc_Together.removeEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
			PetDisplay.mc_Fight.removeEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
			PetDisplay.mc_Together.removeEventListener(MouseEvent.MOUSE_OUT,onBtnOut);
			PetDisplay.mc_Fight.removeEventListener(MouseEvent.MOUSE_OUT,onBtnOut);
			PetDisplay.mc_Together.removeEventListener(MouseEvent.MOUSE_UP,onBtnUp);
			PetDisplay.mc_Fight.removeEventListener(MouseEvent.MOUSE_UP,onBtnUp);
			PetDisplay.mc_Together.removeEventListener(MouseEvent.MOUSE_DOWN,onBtnDown);
			PetDisplay.mc_Fight.removeEventListener(MouseEvent.MOUSE_DOWN,onBtnDown);
			
			if(_showPetModule != null)
			{
				_showPetModule.deleteView();
				_showPetModule = null;
			}
		}
		
		private function onBtnClick(e:MouseEvent):void
		{
			var name:String = e.currentTarget.name;
			switch(name)
			{
				case "btnRight":	//左转
					if(_showPetModule)
					{
						_showPetModule.turnLeft();
					}
					
					break;
				case "btnLeft":	//右转
					if(_showPetModule)
					{
						_showPetModule.turnRight();
					}
					
					break;
				case "mc_Together":	//合体
					//判断是否装备合体符
					if(PetPropConstData.selectedPetId!=0)
					{
						sendNotification(PetEvent.LOOKPETINFO_BYID,{petId:PetPropConstData.selectedPetId,ownerId:GameCommonData.Player.Role.Id});
					}
					
					break;
				case "mc_Fight":
					if(PetPropConstData.selectedPetId!=0)
					{
						var tmpPet:GamePetRole = GameCommonData.Player.Role.PetSnapList[PetPropConstData.selectedPetId];
						if(tmpPet == null)return;
						
						if(timer.running) {
							facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_pet_med_petp_han_3" ], color:0xffff00});  // 5秒后才可以再让宠物出战
							return;
						}
						facade.sendNotification(PetEvent.PET_COMEOUT_FIGHT_OUTSIDE_INTERFACE,PetPropConstData.selectedPetId);
						timerOut.reset();
						timerOut.start();
						sendNotification(PetEvent.LOOKPETINFO_BYID,{petId:PetPropConstData.selectedPetId,ownerId:GameCommonData.Player.Role.Id});
					}
					break;
				case "mc_Rest":
					if(GameCommonData.Player.Role.UsingPet != null && PetPropConstData.selectedPetId==GameCommonData.Player.Role.UsingPet.Id)
					{
						if(timerOut.running) {
							facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_pet_med_petp_han_4" ], color:0xffff00});  // 5秒后才可以再让宠物休息
							return;
						}
						facade.sendNotification(PetEvent.PET_REST_OUTSIDE_INTERFACE,PetPropConstData.selectedPetId);
						timer.reset();
						timer.start();		//5秒后才可以再招宠物
						sendNotification(PetEvent.LOOKPETINFO_BYID,{petId:PetPropConstData.selectedPetId,ownerId:GameCommonData.Player.Role.Id});
					}
					break;
			}
		}
		
		private function onBtnOver(e:MouseEvent):void
		{
			var name:String = e.currentTarget.name;
//			
//			var tmpPet:GamePetRole = GameCommonData.Player.Role.PetSnapList[PetPropConstData.selectedPetId];
//			if(tmpPet == null)return;
			
			switch(name)
			{
				case "mc_Together":
					PetDisplay.mc_Together.gotoAndStop(2);
					break;
				case "mc_Fight":
					PetDisplay.mc_Fight.gotoAndStop(2);
					break;
				case "mc_Rest":
					PetDisplay.mc_Rest.gotoAndStop(2);
					break;
			}
		}
		
		private function onBtnOut(e:MouseEvent):void
		{
			var name:String = e.currentTarget.name;
//			
//			var tmpPet:GamePetRole = GameCommonData.Player.Role.PetSnapList[PetPropConstData.selectedPetId];
//			if(tmpPet == null)return;
//			
			switch(name)
			{
				case "mc_Together":
					PetDisplay.mc_Together.gotoAndStop(1);
					break;
				case "mc_Fight":
					PetDisplay.mc_Fight.gotoAndStop(1);
					break;
				case "mc_Rest":
					PetDisplay.mc_Rest.gotoAndStop(1);
					break;
			}
		}
		
		private function onBtnUp(e:MouseEvent):void
		{
			var name:String = e.currentTarget.name;
//			
//			var tmpPet:GamePetRole = GameCommonData.Player.Role.PetSnapList[PetPropConstData.selectedPetId];
//			if(tmpPet == null)return;
//			
			switch(name)
			{
				case "mc_Together":
					
					PetDisplay.mc_Together.gotoAndStop(2);
					PetDisplay.mc_Together.addEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
					break;
				case "mc_Fight":
					PetDisplay.mc_Fight.addEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
					PetDisplay.mc_Fight.gotoAndStop(2);
					break;
				case "mc_Rest":
					PetDisplay.mc_Rest.addEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
					PetDisplay.mc_Rest.gotoAndStop(2);
					break;
			}
		}
		
		private function onBtnDown(e:MouseEvent):void
		{
			var name:String = e.currentTarget.name;
//			
//			var tmpPet:GamePetRole = GameCommonData.Player.Role.PetSnapList[PetPropConstData.selectedPetId];
//			if(tmpPet == null)return;
//			
			switch(name)
			{
				case "mc_Together":
					PetDisplay.mc_Together.removeEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
					PetDisplay.mc_Together.gotoAndStop(1);
					break;
				case "mc_Fight":
					PetDisplay.mc_Fight.removeEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
					PetDisplay.mc_Fight.gotoAndStop(1);
					break;
				case "mc_Rest":
					PetDisplay.mc_Rest.addEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
					PetDisplay.mc_Rest.gotoAndStop(1);
					break;
			}
		}
		
		/** 创建UseItem实例 */
		protected function getCells(pos:int, icon:String, parent:DisplayObjectContainer):UseItem{
			
			var useItem:UseItem=this.cacheCells.shift();
			useItem=new UseItem(pos,icon,parent);
			return useItem;
		}
	}
}