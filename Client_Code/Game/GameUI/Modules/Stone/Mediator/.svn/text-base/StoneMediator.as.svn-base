package GameUI.Modules.Stone.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.GmTools.Utils.LoadSwfTool;
	import GameUI.Modules.Stone.Datas.*;
	import GameUI.Modules.Stone.Mediator.MosaicMediator;
	import GameUI.Modules.Stone.Proxy.StoneGridManager;
	import GameUI.Modules.Stone.Mediator.StoneComposeMediator;
	import GameUI.Proxy.DataProxy;
	import GameUI.UIConfigData;
	import GameUI.View.BaseUI.PanelBase;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class StoneMediator extends Mediator
	{
		public static const NAME:String = "StoneMediator";
		private var panelBase:PanelBase;
		private var dataProxy:DataProxy = null;
		
		private var mosaic:MosaicMediator = null; //宝石镶嵌
		private var stoneCompose:StoneComposeMediator = null; // 宝石合成
		
		public function StoneMediator()
		{
			super(NAME);
		}
		
		public function get StoneProp():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				EventList.INITVIEW,
				StoneEvents.INIT_STONE_UILIB,
				StoneEvents.CLOSE_STONE_UI,
				StoneEvents.OPEN_STONE_VIEW
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case EventList.INITVIEW:
					dataProxy = facade.retrieveProxy(DataProxy.NAME) as DataProxy;
					break;

				case StoneEvents.INIT_STONE_UILIB:
					registerMediator();
//					stoneCurPage = 0;
					StoneDatas.stoneCurPage = 0;
					initView();
					initPropUI();
					var p:Point = UIConstData.getPos(panelBase.width,panelBase.height);
					panelBase.x = p.x;
					panelBase.y = p.y;
					GameCommonData.GameInstance.GameUI.addChild(panelBase);
					break;
				
				case StoneEvents.OPEN_STONE_VIEW:
					//					var a:Object = UIConstData.ItemDic_1;
					if(StoneProp == null){
						StoneDatas.stoneLoadswfTool = new LoadSwfTool(GameConfigData.StoneUI , this);
						StoneDatas.stoneLoadswfTool.sendShow = sendShow;
					}
					else
					{
						facade.sendNotification(StoneEvents.INIT_STONE_UILIB);
					}
					dataProxy.StoneIsOpen = true;
					break;
				
				case StoneEvents.CLOSE_STONE_UI:
					//释放所有面板，暂时未处理
					panelCloseHandler(null);
					
					break;
			}
		}
		
		private function registerMediator():void
		{		
			stoneCompose = new StoneComposeMediator(StoneProp);
			mosaic = new MosaicMediator(StoneProp);

			facade.registerMediator(stoneCompose);
			facade.registerMediator(mosaic);

			//初始化宠物面板素材
			facade.sendNotification(StoneEvents.INIT_STONE_UI);
		}
		
		private function sendShow(view:MovieClip):void{
			
			this.setViewComponent(StoneDatas.stoneLoadswfTool.GetResource().GetClassByMovieClip("StoneProp"));
			
			this.StoneProp.mouseEnabled=false;
			panelBase = new PanelBase(StoneProp, 700, 480);

			panelBase.name = "StoneProp";
			panelBase.addEventListener(Event.CLOSE, panelCloseHandler);
			panelBase.SetTitleMc(StoneDatas.stoneLoadswfTool.GetResource().GetClassByMovieClip("StoneIcon"));
			//			panelBase.SetTitleDesign();
			
			panelBase.closeFunc = closePanel;
			
			
			facade.sendNotification(StoneEvents.INIT_STONE_UILIB);
		}
		
		private function initView():void
		{
			//打开坐骑面板，初始化打开坐骑列表，坐骑展示和坐骑属性面板
			facade.sendNotification(StoneEvents.SHOW_STONE_MOSAIC_UI);
//			facade.sendNotification(ForgeEvent.SHOW_FORGE_STRENGTHEN_UI);
		}
		
		private function initPropUI():void
		{
			for( var i:int = 0; i<2; i++ )
			{
				StoneProp["Prop_"+i].gotoAndStop(1);
				StoneProp["Prop_"+i].addEventListener(MouseEvent.CLICK, selectView);
				StoneProp["Prop_"+i].mouseEnabled = true;
				StoneProp["Prop_"+i].buttonMode = true;
			}
			StoneProp["Prop_0"].gotoAndStop(3);
			StoneProp["Prop_0"].mouseEnabled = false;
		}
		
		private function selectView(e:MouseEvent):void
		{
			var lastPage:int = StoneDatas.stoneCurPage;
			StoneDatas.stoneCurPage = e.currentTarget.name.split("_")[1];
			
			StoneProp["Prop_"+lastPage].gotoAndStop(1);
			StoneProp["Prop_"+StoneDatas.stoneCurPage].gotoAndStop(3);
			StoneProp["Prop_"+lastPage].mouseEnabled = true;
			StoneProp["Prop_"+StoneDatas.stoneCurPage].mouseEnabled = false;
			
			
			closeSubPanel(lastPage);
			openSubPanel(StoneDatas.stoneCurPage);
		}
		
		private function closeSubPanel(index:int):void
		{
			switch(index)
			{
				case 0:
					facade.sendNotification(StoneEvents.CLOSE_STONE_MOSAIC_UI);
					break;
				case 1:
					facade.sendNotification(StoneEvents.CLOSE_STONE_COMPOSE_UI);
					break;
			}
		}
		
		private function openSubPanel(index:int):void
		{
			switch(index)
			{
				case 0:
					facade.sendNotification(StoneEvents.SHOW_STONE_MOSAIC_UI);
					StoneDatas.stoneCurPage = 0;
					break;
				case 1:
					facade.sendNotification(StoneEvents.SHOW_STONE_COMPOSE_UI);
					StoneDatas.stoneCurPage = 1;
					break;
			}
//			facade.sendNotification(ForgeEvent.UPDATE_ITEM_LIST);
		}
		
		private function closePanel():void
		{
			panelCloseHandler(null);
		}
		
		
		private function panelCloseHandler(event:Event):void
		{
//			facade.sendNotification(ForgeEvent.CLOSE_FORGE_BAG_UI);
			
			closeSubPanel(StoneDatas.stoneCurPage);
			if(GameCommonData.GameInstance.GameUI.contains(panelBase))
			{
				for( var i:int = 0; i<2; i++ )
				{
					StoneProp["Prop_"+i].removeEventListener(MouseEvent.CLICK, selectView);
				}
				GameCommonData.GameInstance.GameUI.removeChild(panelBase); 
			}
			dataProxy.StoneIsOpen = false;
			StoneDatas.stoneCurPage = -1;
			
			facade.removeMediator(StoneComposeMediator.NAME);
			facade.removeMediator(MosaicMediator.NAME);
		}
	}
}