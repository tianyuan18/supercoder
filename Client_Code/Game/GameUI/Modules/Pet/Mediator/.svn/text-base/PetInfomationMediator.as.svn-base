package GameUI.Modules.Pet.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Pet.Data.PetEvent;
	import GameUI.Modules.Pet.Data.PetPropConstData;
	import GameUI.Proxy.DataProxy;
	import GameUI.UIConfigData;
	import GameUI.View.BaseUI.PanelBase;
	import GameUI.Modules.GmTools.Utils.LoadSwfTool;
	
	import OopsEngine.Role.GamePetRole;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class PetInfomationMediator extends Mediator
	{
		public static const NAME:String = "PetInfomationMediator";
		private var panelBase:PanelBase;
		private var parentView:MovieClip;
		private var fighting:int = 0; //0代表休息，1代表出战
		
		private var loadswfTool:LoadSwfTool;
		
		public function PetInfomationMediator(parentMc:MovieClip, _loadswfTool:LoadSwfTool=null)
		{
			parentView = parentMc;
			super(NAME);
			this.loadswfTool = _loadswfTool;
		}

		public function get PetInfomation():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				EventList.INITPETPANEL,
				PetEvent.PET_UPDATE_SHOW_INFO,			//更新数据
				EventList.OPENPETINFO,					//打开宠物信息
				EventList.CLOSEPETINFO,					//关闭宠物信息
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case EventList.INITPETPANEL:
//					facade.sendNotification(EventList.GETRESOURCE, {type:UIConfigData.MOVIECLIP, mediator:this, name:"petInfo"});
					this.setViewComponent(this.loadswfTool.GetResource().GetClassByMovieClip("petInfo"));
					this.PetInfomation.mouseEnabled=false;
					break;
				case EventList.OPENPETINFO:
					registerView();
					initData();
					PetInfomation.x = 161;
					PetInfomation.y = 280;
					PetInfomation.mouseEnabled = false;
					parentView.addChild(PetInfomation);
					break;
				case EventList.CLOSEPETINFO:
					retrievedView();
					parentView.removeChild(PetInfomation);
					break;
				case PetEvent.PET_UPDATE_SHOW_INFO:
					initData();
					break;
			}
		}
		private function initData():void
		{
			//获取宠物数据
			var tmpPet:GamePetRole = GameCommonData.Player.Role.PetSnapList[PetPropConstData.selectedPetId];
			if(tmpPet == null)
			{
				PetInfomation.txtName.text = "";
				PetInfomation.txtProfession.text = "";
				PetInfomation.txtLevel.text = "";
				
				PetInfomation.txtSprite.text = 0+"/"+0;
				PetInfomation.mc_Sprite.gotoAndStop(1);
				return;
			}
			PetInfomation.txtName.text = tmpPet.PetName;
			PetInfomation.txtProfession.text = "战争之影";
			PetInfomation.txtLevel.text = tmpPet.Level;
			
			PetInfomation.txtSprite.text = tmpPet.EnergyNow+"/"+tmpPet.EnergyMax;
			PetInfomation.mc_Sprite.gotoAndStop(int(tmpPet.EnergyNow*100/tmpPet.EnergyMax));
		}
		
		private function registerView():void
		{
			//初始化素材事件
//			PetInfomation.btnTogether.addEventListener(MouseEvent.CLICK,onBtnClick);
			
			PetInfomation.btnFeed.addEventListener(MouseEvent.CLICK,onBtnClick);
		}
		
		private function retrievedView():void
		{
			//释放素材事件
//			PetInfomation.btnTogether.removeEventListener(MouseEvent.CLICK,onBtnClick);
//			PetInfomation.btnRest.removeEventListener(MouseEvent.CLICK,onBtnClick);
		}
		
		private function onBtnClick(e:MouseEvent):void
		{
			var name:String = e.currentTarget.name;
			switch(name)
			{
				case "btnTogether":
					break;
				case "btnFeed":
					break;
			}
		}
	}
}