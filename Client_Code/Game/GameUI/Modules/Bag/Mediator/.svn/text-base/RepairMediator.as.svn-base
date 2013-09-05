package GameUI.Modules.Bag.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Bag.Datas.BagEvents;
	import GameUI.Modules.Bag.Proxy.BagData;
	import GameUI.Modules.GmTools.Utils.LoadSwfTool;
	import GameUI.Modules.Maket.Data.MarketConstData;
	import GameUI.Modules.Maket.Data.MarketEvent;
	import GameUI.UIConfigData;
	import GameUI.UIUtils;
	import GameUI.View.BaseUI.PanelBase;
	import GameUI.View.ShowMoney;
	import GameUI.View.items.UseItem;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class RepairMediator extends Mediator
	{
		public static const NAME:String = "RepairMediator";
		private var panelBase:PanelBase = null;
		private var loadswfTool:LoadSwfTool=null;
		
		public function RepairMediator(_loadswfTool:LoadSwfTool=null)
		{
			super(NAME);
			this.loadswfTool = _loadswfTool;
		}
		
		private function get RepairPanel():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				BagEvents.OPENREPAIRPANEL,
				BagEvents.CLOSEREPAIRPANEL
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case BagEvents.OPENREPAIRPANEL:
					//在此处加载寄售面板所有的素材
//					facade.sendNotification(EventList.GETRESOURCE, {type:UIConfigData.MOVIECLIP, mediator:this, name:UIConfigData.REPAIRPANEL});
					this.setViewComponent(this.loadswfTool.GetResource().GetClassByMovieClip(UIConfigData.REPAIRPANEL));
					panelBase = new PanelBase(RepairPanel, RepairPanel.width+7, RepairPanel.height+20);
					panelBase.name = "RepairPanel";
					panelBase.addEventListener(Event.CLOSE, panelCloseHandler);
					var point:Point = UIUtils.getMiddlePos(panelBase);
					
					var pos:Object = notification.getBody();
					panelBase.x =  pos.repairX - RepairPanel.width-10;//(GameCommonData.GameInstance.GameUI.width - panelBase.width)/2;
					panelBase.y = pos.repairY;//(GameCommonData.GameInstance.GameUI.height - panelBase.height)/2;
//					panelBase.SetTitleTxt( GameCommonData.wordDic[ "mod_bag_med_ext_han_1" ] );   // 背包扩充
	
//					RepairPanel.btnSellItem.addEventListener(MouseEvent.CLICK, openConsignPanel);
//					panelBase.SetTitleName("RepairIcon");
					panelBase.SetTitleMc(this.loadswfTool.GetResource().GetClassByMovieClip("RepairIcon"));
					panelBase.closeFunc = closeBagPanel;
					RepairPanel.equipMc.gotoAndStop(2);
					RepairPanel.bagMc.gotoAndStop(1);
					
					RepairPanel.equipMc.addEventListener(MouseEvent.CLICK, onClickPanel);
					RepairPanel.bagMc.addEventListener(MouseEvent.CLICK, onClickPanel);
					
					GameCommonData.GameInstance.GameUI.addChild(panelBase);
					BagData.RepairPanelOpen = true;
				break;
				case BagEvents.CLOSEREPAIRPANEL:
					if(BagData.RepairPanelOpen) {
						panelBase.onCloseHandler(null);
//						panelCloseHandler(null);
					}
				break;
			}
		}
		
		private function onClickPanel(e:MouseEvent):void
		{
			var btnName:String = e.currentTarget.name;
			switch(btnName)
			{
				case "equipMc":
					RepairPanel.equipMc.gotoAndStop(2);
					RepairPanel.bagMc.gotoAndStop(1);
					break;
				case "bagMc":
					RepairPanel.equipMc.gotoAndStop(1);
					RepairPanel.bagMc.gotoAndStop(2);
					break;
			}
		}
//		private function openConsignPanel(event:MouseEvent):void{
//			
//			var btnName:String = event.target.name;
//			switch(btnName)
//			{
//				case "btnSellItem":
//					saleMoneyMc.visible = false;
//					mySaleMc.visible = false;
//					saleItemMc.visible = true;
//					break;
//				case "btnSellMoney":
//					saleMoneyMc.visible = true;
//					mySaleMc.visible = false;
//					saleItemMc.visible = false;
//					break;
//				case "btnMySell":
//					saleMoneyMc.visible = false;
//					mySaleMc.visible = true;
//					saleItemMc.visible = false;
//					break;
//			}
//		}
		
		private function closeBagPanel():void
		{
			panelCloseHandler(null);
		}
		
		private function panelCloseHandler(event:Event):void
		{
			BagData.RepairPanelOpen = false;

			GameCommonData.GameInstance.GameUI.removeChild(panelBase);
			panelBase = null;
			this.viewComponent = null;
			facade.removeMediator(NAME);
		}
	}
}