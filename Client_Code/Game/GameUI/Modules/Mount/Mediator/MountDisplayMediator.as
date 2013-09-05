package GameUI.Modules.Mount.Mediator
{
	import Controller.PlayerSkinsController;
	
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Bag.Proxy.BagData;
	import GameUI.Modules.Mount.MountData.MountData;
	import GameUI.Modules.Mount.MountData.MountEvent;
	import GameUI.Modules.Mount.Proxy.MountNetAction;
	import GameUI.Modules.Mount.UI.ShowMountModuleComponent;
	import GameUI.Modules.Pet.Data.PetPropConstData;
	import GameUI.Modules.RoleProperty.Datas.RoleEvents;
	import GameUI.Modules.RoleProperty.Datas.RolePropDatas;
	import GameUI.Modules.RoleProperty.Net.NetAction;
	import GameUI.Proxy.DataProxy;
	import GameUI.UIConfigData;
	import GameUI.View.BaseUI.PanelBase;
	
	import Net.ActionProcessor.OperateItem;
	
	import OopsEngine.Role.GamePetRole;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class MountDisplayMediator extends Mediator
	{
		public static const NAME:String = "MountDisplayMediator";
		private var panelBase:PanelBase;
		private var parentView:MovieClip;
		private var _showMountModule:ShowMountModuleComponent = null;
		private var mountState:int = 0; //0休息，1装备
		
		public function MountDisplayMediator(parentMc:MovieClip)
		{
			parentView = parentMc;
			super(NAME);
		}
		
		public function get MountDisplay():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				MountEvent.INIT_MOUNT_UI,
//				MountEvent.MOUNT_UPDATE_INFO,
				MountEvent.OPEN_MOUNT_DISPLAY,					//打开宠物装备
				MountEvent.UPDATE_MOUNT_DISPLAY,
				MountEvent.CLOSE_MOUNT_DISPLAY					//关闭宠物装备
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case MountEvent.INIT_MOUNT_UI:
//					facade.sendNotification(EventList.GETRESOURCE, {type:UIConfigData.MOVIECLIP, mediator:this, name:"MountDisplay"});
					this.setViewComponent(MountData.loadswfTool.GetResource().GetClassByMovieClip("MountDisplay"));
					this.MountDisplay.mouseEnabled=false;
					
					break;
				case MountEvent.OPEN_MOUNT_DISPLAY:
					registerView();
					initData();
					MountDisplay.x = 88;
					MountDisplay.y = 27;
					parentView.addChild(MountDisplay);
					break;
				case MountEvent.CLOSE_MOUNT_DISPLAY:
					retrievedView();
					parentView.removeChild(MountDisplay);
					break;
				case MountEvent.UPDATE_MOUNT_DISPLAY:
					if(MountData.curPage == 0)
					{
						initData();
					}
					
					break;
			}
		}
		
		private function initData():void
		{
			//获取宠物数据
			
			if(RolePropDatas.ItemList[11])
			{
				if(RolePropDatas.ItemList[11]!=null && MountData.SelectedMountId == RolePropDatas.ItemList[11].type)//当前选中坐骑已经装备
				{
					if(GameCommonData.Player.Role.MountSkinID != 0)
					{
						mountState = 1;
						(MountDisplay.btnName as MovieClip).gotoAndStop(1);//已经装备的坐骑显示休息按钮
					}
					else
					{
						mountState = 0;
						(MountDisplay.btnName as MovieClip).gotoAndStop(2);//未装备的坐骑显示乘骑按钮
					}
					
				}
				
				
				if(_showMountModule != null)
				{
					_showMountModule.deleteView();
					_showMountModule = null;
				}
				
				//			var tmpPet:GamePetRole = GameCommonData.Player.Role.PetSnapList[PetPropConstData.selectedPetId];
				//			if(tmpPet == null)return;
				var petClass:String = MountData.SelectedMountId.toString();
				_showMountModule = new ShowMountModuleComponent(MountDisplay);
				//			if(PetPropConstData.newPetModuleSwf[petClass])
				//			{
				//				petClass = PetPropConstData.newPetModuleSwf[petClass];
				//			}
				_showMountModule.show_x = 185;
				_showMountModule.show_y = 250;
				if(petClass=="0")return;
				_showMountModule.showView(petClass);
			}
			
		}
		
		private function registerView():void
		{
			//初始化素材事件
			(MountDisplay.btnName as MovieClip).gotoAndStop(1);
			(MountDisplay.btnName as MovieClip).mouseEnabled = false;
			
			MountDisplay.btnLeft.addEventListener(MouseEvent.CLICK,onBtnClick);
			MountDisplay.btnRight.addEventListener(MouseEvent.CLICK,onBtnClick);
			MountDisplay.btnRest.addEventListener(MouseEvent.CLICK,onBtnClick);
			MountDisplay.btnChange.addEventListener(MouseEvent.CLICK,onBtnClick);
//			MountDisplay.btnChange.visible = false;
		}
		
		private function retrievedView():void
		{
			//释放素材事件
			if(_showMountModule != null)
			{
				_showMountModule.deleteView();
				_showMountModule = null;
			}
		}
		
		private function onBtnClick(e:MouseEvent):void
		{
			var name:String = e.currentTarget.name;
			switch(name)
			{
				case "btnRight":	//左转
					if(_showMountModule)
					{
						_showMountModule.turnLeft();
					}
					
					break;
				case "btnLeft":	//右转
					if(_showMountModule)
					{
						_showMountModule.turnRight();
						
					}
					
					break;
				case "btnChange":
					var a:Object = MountData.SelectedMount;
					var i:int = MountData.curMountId;
					if(MountData.SelectedMount/* && MountData.curMountId != MountData.SelectedMount.type*/)
					{
//						MountData.curMountId = MountData.SelectedMount.type;
						
						//调用更换坐骑皮肤接口
						MountNetAction.opMount(329,MountData.SelectedMountId);
						MountData.curMountId = MountData.SelectedMountId;
					}
					break;
				case "btnRest":	//休息
//					if(this.mountState == 1)//坐骑已经装备，按钮执行休息功能
//					{
//						PlayerSkinsController.UnMount();
////						NetAction.UnEquip(OperateItem.UNEQUIP, 1, 12, 51, getMountIndex());
//					}
//					else
//					{
//						if(MountData.SelectedMountId>0)
//						{
//							MountData.SelectedMount = getMountItemById(MountData.SelectedMountId);
//							if(MountData.SelectedMount == null)return;
//							NetAction.UseItem(OperateItem.USE,1,12,MountData.SelectedMount.id);
////							facade.sendNotification(RoleEvents.GETOUTFITBYCLICK, MountData.SelectedMount);
//							
//						}
					if(MountData.SelectedMount && RolePropDatas.ItemList[11]!=null/* && MountData.SelectedMountId == RolePropDatas.ItemList[11].type*/)
					{
						if(GameCommonData.Player.Role.MountSkinID != 0)//下坐骑
						{
							PlayerSkinsController.UnMount();
						}
						else//上坐骑
						{
							PlayerSkinsController.SetMount();
						}
					}
					
						
//					}
					
					break;
			}
		}
		
		public static function getMountItemById(id:int):Object
		{
			if(RolePropDatas.ItemList[11] && RolePropDatas.ItemList[11].id == id)
			{
				return RolePropDatas.ItemList[11];
			}
//			for(var key:* in BagData.AllUserItems[1])
			var a:Array = BagData.AllUserItems[1];
			for(var i:int=1;i<BagData.AllUserItems[1].length;i++)
			{
				if(BagData.AllUserItems[1][i] && BagData.AllUserItems[1][i].id == id)
				{
					return BagData.AllUserItems[1][i];
				}
			}
			return null;
		}
		
		private function getMountIndex():int
		{
			for(var i:int=1;i<BagData.AllUserItems[1].length;i++)
			{
				if(BagData.AllUserItems[1][i] == null)
				{
					return i;
				}
			}
			return BagData.AllUserItems[1].length;
		}
	}
}