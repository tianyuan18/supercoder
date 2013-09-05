package GameUI.Modules.Pet.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.GmTools.Utils.LoadSwfTool;
	import GameUI.Modules.Pet.Data.PetEvent;
	import GameUI.Modules.Pet.Data.PetPropConstData;
	import GameUI.Proxy.DataProxy;
	import GameUI.UIConfigData;
	import GameUI.View.BaseUI.PanelBase;
	import GameUI.View.Components.PanelList;
	
	import OopsEngine.Role.GamePetRole;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PetListMediator extends Mediator
	{
		public static const NAME:String = "PetListMediator";
		private var panelBase:PanelBase;
		private var parentView:MovieClip = null;
		private var PetList:PanelList = null;

		private const petShowMaxNum:int = 5;
		
		private var loadswfTool:LoadSwfTool=null;
		
		public function PetListMediator(parentMc:MovieClip, _loadswfTool:LoadSwfTool=null)
		{
			parentView = parentMc;
			super(NAME);
			this.loadswfTool = _loadswfTool;
		}

		public override function listNotificationInterests():Array
		{
			return [
				EventList.INITPETPANEL,
				PetEvent.PET_UPDATE_SHOW_INFO,			//更新数据
				EventList.OPENPETLIST,					//显示宠物列表
				EventList.CLOSEPETLIST					//关闭宠物列表
				
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case EventList.INITPETPANEL:
					PetList = new PanelList(petShowMaxNum,this.loadswfTool);
					PetList.onUpClickFuc= onUpClick;
					PetList.onDownClickFuc = onDownClick;
					PetList.onSelectFuc = onSelectClick;
					break;
				case EventList.OPENPETLIST:
					initData();
					registerView();
					PetList.x = 2;
					PetList.y = 38;
					PetList.mouseEnabled = false;
					parentView.addChild(PetList);
					if(PetList.panelArray != null && PetList.panelArray[0] != null)
					{
						PetList.setFrame(0);
						sendNotification(PetEvent.LOOKPETINFO_BYID,{petId:PetList.panelArray[0],ownerId:GameCommonData.Player.Role.Id});
					}
					
					break;
				case EventList.CLOSEPETLIST:
					retrievedView();
					parentView.removeChild(PetList);
					break;
				case PetEvent.PET_UPDATE_SHOW_INFO:
//					sendNotification(PetEvent.LOOKPETINFO_BYID,{petId:PetPropConstData.selectedPetId,ownerId:GameCommonData.Player.Role.Id});
					createPetUI();
					break;
			}
		}
		
		private function initData():void
		{
			//获取宠物数据

			PetList.panelArray = new Array();
			for(var key:* in GameCommonData.Player.Role.PetSnapList)
			{
				PetList.panelArray.push(key);
			}
			if(PetList.panelArray.length > 0)
			{
				PetPropConstData.selectedPetId = PetList.panelArray[0];
			}
		}
		
		private function registerView():void
		{
			//初始化素材事件
			if(PetList.panelArray.length > 0) createPetUI();
		}
		
		private function retrievedView():void
		{
			//释放素材事件
			for(var i:int = 0; i<petShowMaxNum; i++)
			{
				PetList.releaseListUI(i);
			}
			PetList.panelArray = null;
		}
		
		private function onUpClick():void
		{
				createPetUI();
		}
		
		private function onDownClick():void
		{
				createPetUI();
		}
		
		private function createPetUI():void
		{
			if(PetList.panelArray == null) return;
			var p:Object = GameCommonData.Player.Role.PetSnapList;
			for(var i:int=PetList.firstPetIndex; i<PetList.panelArray.length; i++)
			{
				var tmpPet:GamePetRole = GameCommonData.Player.Role.PetSnapList[PetList.panelArray[i]];
				
				PetList.createListUI(tmpPet.PetName,"LV."+tmpPet.Level,i,tmpPet.State);
				
				if(i>=PetList.firstPetIndex+petShowMaxNum-1)return;
			}
		}
		
		private function onSelectClick():void
		{
//			//发送更新信息
			PetPropConstData.selectedPetId = PetList.panelArray[PetList.firstPetIndex+PetList.curSelectPet];
			var a:Object = GameCommonData.Player.Role.PetSnapList;
			var b:Object = GameCommonData.Player.Role.PetList;
			if(GameCommonData.Player.Role.PetList[PetPropConstData.selectedPetId] == null)
			{
				sendNotification(PetEvent.LOOKPETINFO_BYID,{petId:PetPropConstData.selectedPetId,ownerId:GameCommonData.Player.Role.Id});
				
			}
			facade.sendNotification(PetEvent.UPDATE_PET_SKILL_INFO,-1);
			facade.sendNotification(PetEvent.PET_UPDATE_SHOW_INFO);
		}
	}
}