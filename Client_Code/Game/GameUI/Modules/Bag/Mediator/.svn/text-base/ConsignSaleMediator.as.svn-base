package GameUI.Modules.Bag.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Bag.Datas.BagEvents;
	import GameUI.Modules.Bag.Proxy.BagData;
	import GameUI.Modules.Maket.Data.MarketConstData;
	import GameUI.Modules.Maket.Data.MarketEvent;
	import GameUI.UIConfigData;
	import GameUI.UIUtils;
	import GameUI.View.BaseUI.PanelBase;
	import GameUI.View.ShowMoney;
	import GameUI.Modules.GmTools.Utils.LoadSwfTool;
	import GameUI.View.items.UseItem;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class ConsignSaleMediator extends Mediator
	{
		public static const NAME:String = "ConsignSaleMediator";
		private var panelBase:PanelBase = null;
		private var saleMoneyMc:MovieClip = null;
		private var mySaleMc:MovieClip = null;
		private var saleItemMc:MovieClip = null;
		private var loadswfTool:LoadSwfTool=null;
		
		public function ConsignSaleMediator(_loadswfTool:LoadSwfTool=null)
		{
			super(NAME);
			this.loadswfTool = _loadswfTool;
		}
		
		private function get ConsignSale():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				BagEvents.OPENCONSIGNSALE,
				BagEvents.CLOSECONSIGNSALE
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case BagEvents.OPENCONSIGNSALE:
					//在此处加载寄售面板所有的素材
//					facade.sendNotification(EventList.GETRESOURCE, {type:UIConfigData.MOVIECLIP, mediator:this, name:UIConfigData.CONSIGNSALE});
					this.setViewComponent(BagData.loadswfTool.GetResource().GetClassByMovieClip(UIConfigData.CONSIGNSALE));
					panelBase = new PanelBase(ConsignSale, ConsignSale.width+7, ConsignSale.height+5);
					panelBase.name = "ConsignSale";
					panelBase.addEventListener(Event.CLOSE, panelCloseHandler);
					var point:Point = UIUtils.getMiddlePos(panelBase);

					var pos:Object = notification.getBody();
					panelBase.x =  pos.repairX - ConsignSale.width-10;//(GameCommonData.GameInstance.GameUI.width - panelBase.width)/2;
					panelBase.y = pos.repairY;//(GameCommonData.GameInstance.GameUI.height - panelBase.height)/2;
//					panelBase.SetTitleTxt( GameCommonData.wordDic[ "mod_bag_med_ext_han_1" ] );   // 背包扩充
//					panelBase.SetTitleName("ConsignSaleIcon");
					panelBase.SetTitleMc(BagData.loadswfTool.GetResource().GetClassByMovieClip("ConsignSaleIcon"));
					panelBase.closeFunc = closeBagPanel;
					saleMoneyMc = ConsignSale.SaleMoneyMC;
					mySaleMc = ConsignSale.MySaleMC;
					saleItemMc = ConsignSale.SaleItemMC;
					
					ConsignSale.btnSellItem.addEventListener(MouseEvent.CLICK, openConsignPanel);
					ConsignSale.btnSellMoney.addEventListener(MouseEvent.CLICK, openConsignPanel);
					ConsignSale.btnMySell.addEventListener(MouseEvent.CLICK, openConsignPanel);
					
					ConsignSale.btnSellItem.gotoAndStop(2);
					ConsignSale.btnSellMoney.gotoAndStop(1);
					ConsignSale.btnMySell.gotoAndStop(1);
					
					saleMoneyMc.visible = false;
					mySaleMc.visible = false;
					saleItemMc.visible = true;
					
					
					
					GameCommonData.GameInstance.GameUI.addChild(panelBase);
					BagData.ConsignSaleOpen = true;
				break;
				case BagEvents.CLOSECONSIGNSALE:
					if(BagData.ConsignSaleOpen) {
						panelCloseHandler(null);
					}
				break;
			}
		}
		
		private function openConsignPanel(event:MouseEvent):void{
			
			var btnName:String = event.target.name;
			switch(btnName)
			{
				case "btnSellItem":
					saleMoneyMc.visible = false;
					mySaleMc.visible = false;
					saleItemMc.visible = true;
					ConsignSale.btnSellItem.gotoAndStop(2);
					ConsignSale.btnSellMoney.gotoAndStop(1);
					ConsignSale.btnMySell.gotoAndStop(1);
					ConsignSale.btnSellItem.mouseEnabled = false;
					ConsignSale.btnSellMoney.mouseEnabled = true;
					ConsignSale.btnMySell.mouseEnabled = true;
					break;
				case "btnSellMoney":
					saleMoneyMc.visible = true;
					mySaleMc.visible = false;
					saleItemMc.visible = false;
					ConsignSale.btnSellItem.gotoAndStop(1);
					ConsignSale.btnSellMoney.gotoAndStop(2);
					ConsignSale.btnMySell.gotoAndStop(1);
					ConsignSale.btnSellItem.mouseEnabled = true;
					ConsignSale.btnSellMoney.mouseEnabled = false;
					ConsignSale.btnMySell.mouseEnabled = true;
					break;
				case "btnMySell":
					saleMoneyMc.visible = false;
					mySaleMc.visible = true;
					saleItemMc.visible = false;
					ConsignSale.btnSellItem.gotoAndStop(1);
					ConsignSale.btnSellMoney.gotoAndStop(1);
					ConsignSale.btnMySell.gotoAndStop(2);
					ConsignSale.btnSellItem.mouseEnabled = true;
					ConsignSale.btnSellMoney.mouseEnabled = true;
					ConsignSale.btnMySell.mouseEnabled = false;
					break;
			}
		}

		private function closeBagPanel():void
		{
			panelCloseHandler(null);
		}
		
		private function panelCloseHandler(event:Event):void
		{
			BagData.ConsignSaleOpen = false;
			GameCommonData.GameInstance.GameUI.removeChild(panelBase);
			panelBase = null;
			this.viewComponent = null;
			facade.removeMediator(NAME);
		}
	}
}