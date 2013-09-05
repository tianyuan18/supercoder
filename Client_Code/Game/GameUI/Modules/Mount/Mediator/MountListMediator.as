package GameUI.Modules.Mount.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Mediator.UiNetAction;
	import GameUI.Modules.Bag.Proxy.BagData;
	import GameUI.Modules.Mount.MountData.MountData;
	import GameUI.Modules.Mount.MountData.MountEvent;
	import GameUI.Modules.Mount.MountData.MountList;
	import GameUI.Modules.Pet.Data.PetEvent;
	import GameUI.Modules.Pet.Data.PetPropConstData;
	import GameUI.Modules.RoleProperty.Datas.RolePropDatas;
	import GameUI.Modules.ToolTip.Const.IntroConst;
	import GameUI.Proxy.DataProxy;
	import GameUI.UIConfigData;
	import GameUI.View.BaseUI.PanelBase;
	
	import Net.ActionProcessor.ItemInfo;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class MountListMediator extends Mediator
	{
		public static const NAME:String = "MountListMediator";
//		private var panelBase:PanelBase;
		private var parentView:MovieClip;
		private const mountShowMaxNum:int = 5;
		private var mountList:MountList = null;

		
		public function MountListMediator(parentMc:MovieClip)
		{
			parentView = parentMc;
			super(NAME);
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				MountEvent.INIT_MOUNT_UI,
				MountEvent.OPEN_MOUNT_LIST,					//打开宠物装备
				MountEvent.UPDATE_MOUNT_LIST,
				MountEvent.CLOSE_MOUNT_LIST					//关闭宠物装备
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case MountEvent.INIT_MOUNT_UI:
					mountList = new MountList(mountShowMaxNum);
					mountList.onUpClickFuc= onUpClick;
					mountList.onDownClickFuc = onDownClick;
					mountList.onSelectFuc = onSelectClick;
					mountList.x=4;
					mountList.y=27;
					break;
				case MountEvent.OPEN_MOUNT_LIST:
					initData();
					registerView();
					parentView.addChild(mountList);
//					if(mountList.panelArray != null && mountList.panelArray[0] != null)
//					{
//						mountList.setFrame(0);
//						sendNotification(PetEvent.LOOKPETINFO_BYID,{petId:mountList.panelArray[0],ownerId:GameCommonData.Player.Role.Id});
//					}
					break;
				case MountEvent.CLOSE_MOUNT_LIST:
					retrievedView();
					parentView.removeChild(mountList);
					break;
				case MountEvent.UPDATE_MOUNT_LIST:
					initData();
					registerView();
					break;
			}
		}
		
		private function initData():void
		{
			/**获取宠物数据
			 * 
			 * 宠物数据从两个列表中获得
			 * 一个是MountList，存放未装备上的坐骑
			 * 一个是RolePropDatas.ItemList，存放装备上的坐骑
			 */
			
//			mountList.panelArray = new Array();
			var a:Array = RolePropDatas.ItemList;
			if(RolePropDatas.ItemList[11])
			{
				//装备上的坐骑，新版的坐骑一直装备在人物身上
//				mountList.panelArray.push(RolePropDatas.ItemList[11]);
				MountData.SelectedMount = RolePropDatas.ItemList[11]; //当前坐骑
				
				if(MountData.SelectedMountId == 0)//没有选中皮肤，用装备上的坐骑皮肤代替
				{
					MountData.SelectedMountId = MountData.SelectedMount.type;//选中坐骑皮肤TypeID
				}
				
				MountData.curMountId = MountData.SelectedMountId;//暂时用当前选中坐骑赋值，curMountId应该是当前幻化的皮肤
				
				sendNotification(MountEvent.LOOKMOUNTINFO_BYID);
			}
			
		}
		
		private function registerView():void
		{
			//初始化素材事件
			createPetUI();
		}
		
		private function retrievedView():void
		{
			//释放素材事件
			var max:int = (mountList.firstMountIndex+mountShowMaxNum)>MountData.mountSkinList.length?MountData.mountSkinList.length:(mountList.firstMountIndex+mountShowMaxNum);
			for(var i:int=mountList.firstMountIndex; i<max; i++)
			{
				mountList.releaseListUI(i);
			}
//			mountList.panelArray = null;
		}
		
		private function onUpClick():void
		{
			//先清理，在创建
//			if(mountList.firstMountIndex>0)
//			{
//				mountList.firstMountIndex--;
				createPetUI();
//			}
			
		}
		
		private function onDownClick():void
		{
			//先清理，在创建
//			if((mountList.firstMountIndex+mountShowMaxNum)<MountData.mountSkinList.length)
//			{
//				mountList.firstMountIndex++;
				createPetUI();
//			}
			
		}
		
		private function createPetUI():void
		{
//			if(MountData.mountSkinList == null) return;
			retrievedView();
			var max:int = (mountList.firstMountIndex+mountShowMaxNum)>MountData.mountSkinList.length?MountData.mountSkinList.length:(mountList.firstMountIndex+mountShowMaxNum);
			for(var i:int=mountList.firstMountIndex; i<max; i++)
			{
//				var tmpPet:Object = BagData.AllUserItems[1][mountList.panelArray[i]];
//				mountList.createListUI("","休息中",i);
				if(MountData.mountSkinList[i])
				{
					mountList.createListUI(MountData.mountSkinList[i],i);
				}
				else
				{
					return;
				}
			}
		}
		
		private function onSelectClick(index:int):void
		{
			//发送更新信息
			mountList.curSelectMount = index;
			MountData.SelectedMountId = MountData.mountSkinList[mountList.firstMountIndex+mountList.curSelectMount].id;
			facade.sendNotification(MountEvent.UPDATE_MOUNT_DISPLAY);
//			MountData.SelectedMount = MountData.mountSkinList[mountList.firstMountIndex+mountList.curSelectMount];
////			sendNotification(PetEvent.LOOKPETINFO_BYID,{petId:PetPropConstData.selectedPetId,ownerId:GameCommonData.Player.Role.Id});
////			facade.sendNotification(MountEvent.MOUNT_UPDATE_INFO);
//			if(!IntroConst.ItemInfo[MountData.SelectedMount.id])
//			{
//				UiNetAction.GetItemInfo(MountData.SelectedMount.id,GameCommonData.Player.Role.Id,GameCommonData.Player.Role.Name,ItemInfo.MOUNT_UI_UPDATE);
//			}
			
			//选中新的皮肤，需要更新坐骑展示，当前选中皮肤，不需要更新当前皮肤和当前本质坐骑
			
		}
		
//		private function initData():void
//		{
//			//获取宠物数据
//			panelList = new Array();
//
//			for(var key:* in GameCommonData.Player.Role.PetSnapList)
//			{
//				panelList.push(key);
//			}
//			if(panelList.length > 0)
//			{
//				PetPropConstData.selectedPetId = panelList[0];
//			}
//		}
//		
//		private function registerView():void
//		{
//			//初始化素材事件
//			//			createPetUI();
//			for(var i:int = 0; i<mountShowMaxNum; i++)
//			{
//				mountList["pet_"+i].visible = false;
//				mountList["pet_"+i].SelectedFrame.visible = false;
//				
//			}
//			
//			mountList.btnUp.addEventListener(MouseEvent.CLICK,onUpClick);
//			mountList.btnDown.addEventListener(MouseEvent.CLICK,onDownClick);
//			
//			mountList["pet_"+curSelectPet].SelectedFrame.visible = true;
//			if(panelList.length > 0) createPetUI();
//		}
//		
//		private function retrievedView():void
//		{
//			//释放素材事件
//			for(var i:int = 0; i<mountShowMaxNum; i++)
//			{
//				mountList["pet_"+i].removeEventListener(MouseEvent.CLICK,onSelectClick);
//			}
//			
//			mountList.btnUp.removeEventListener(MouseEvent.CLICK,onUpClick);
//			mountList.btnDown.removeEventListener(MouseEvent.CLICK,onDownClick);
//			panelList = null;
//		}
//		
//		private function onUpClick(e:MouseEvent):void
//		{
//			if(firstPetIndex>0 && panelList.length>mountShowMaxNum)
//			{
//				firstPetIndex--;
//				createPetUI();
//			}
//		}
//		
//		private function onDownClick(e:MouseEvent):void
//		{
//			if(firstPetIndex+mountShowMaxNum < panelList.length)
//			{
//				firstPetIndex++;
//				createPetUI();
//			}
//		}
//		
//		private function createPetUI():void
//		{
//			if(panelList == null || panelList.length==0)return;
//			var tmp:* = GameCommonData.Player.Role.PetSnapList;
//			for(var i:int=firstPetIndex;i<panelList.length;i++)
//			{
//				var index:int = i-firstPetIndex;
//				mountList["pet_"+index].visible = true;
//				mountList["pet_"+index].addEventListener(MouseEvent.CLICK,onSelectClick);
//				var tmpPet:GamePetRole = GameCommonData.Player.Role.PetSnapList[panelList[i]];
//				mountList["pet_"+index].txtName.text = tmpPet.PetName;
//				if(i>=firstPetIndex+mountShowMaxNum-1)return;
//			}
//		}
//		
//		private function onSelectClick(e:MouseEvent):void
//		{
//			var index:int = e.currentTarget.name.split("_")[1];
//			mountList["pet_"+curSelectPet].SelectedFrame.visible = false;
//			mountList["pet_"+index].SelectedFrame.visible = true;
//			curSelectPet = index;
//			PetPropConstData.selectedPetId = panelList[firstPetIndex+curSelectPet];
//		}
	}
}