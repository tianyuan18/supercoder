package GameUI.Modules.Forge.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Forge.Data.ForgeData;
	import GameUI.Modules.Forge.Data.ForgeEvent;
	import GameUI.Modules.Forge.Mediator.*;
	import GameUI.Modules.GmTools.Utils.LoadSwfTool;
	import GameUI.Proxy.DataProxy;
	import GameUI.UIConfigData;
	import GameUI.View.BaseUI.PanelBase;
	
	import Net.ActionProcessor.OperateItem;
	import Net.ActionProcessor.PlayerAction;
	
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
	
	public class ForgeMediator extends Mediator
	{
		public static const NAME:String = "ForgeMediator";
		private var panelBase:PanelBase;
		private var dataProxy:DataProxy = null;
		
		private var forgeBag:ForgeBagMediator = null;
		
		private var quality:QualityMediator = null; //品质
		private var mosaic:MosaicMediator = null; //宝石镶嵌
		private var strengthen:StrengthenMediator = null; //强化
		private var inherit:InheritMediator = null; //继承
		private var decompose:DecomposeMediator = null; //分解
		private var baptize:BaptizeMediator = null; //洗炼
		
		private var curPage:int = 0; //当前页面
		private var back:MovieClip = null;
		
		public function ForgeMediator()
		{
			super(NAME);
		}
		
		public function get ForgeProp():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				EventList.INITVIEW,
				ForgeEvent.SHOW_FORGE_UI,
				ForgeEvent.INIT_FORGE_UILIB,
				ForgeEvent.CLOSE_FORGE_UI
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case EventList.INITVIEW:
					dataProxy = facade.retrieveProxy(DataProxy.NAME) as DataProxy;
					break;
				
				case ForgeEvent.INIT_FORGE_UILIB:
					registerMediator();
					curPage = 0;
					ForgeData.curPage = 0;
					initView();
					initPropUI();
					var p:Point = UIConstData.getPos(panelBase.width,panelBase.height);
					panelBase.x = p.x;
					panelBase.y = p.y;
					GameCommonData.GameInstance.GameUI.addChild(panelBase);
					break;
				case ForgeEvent.SHOW_FORGE_UI:
//					var a:Object = UIConstData.ItemDic_1;
					if(ForgeProp == null){
						ForgeData.loadswfTool = new LoadSwfTool(GameConfigData.ForgeUI , this);
						ForgeData.loadswfTool.sendShow = sendShow;
					}
					else
					{
						facade.sendNotification(ForgeEvent.INIT_FORGE_UILIB);
					}
					dataProxy.ForgeIsOpen = true;
					break;
				case ForgeEvent.CLOSE_FORGE_UI:
					//释放所有面板，暂时未处理
					panelCloseHandler(null);
					
					break;
			}
			
		}
		
		private function sendShow(view:MovieClip):void{
			
			this.setViewComponent(ForgeData.loadswfTool.GetResource().GetClassByMovieClip(UIConfigData.FORGEVIEW));
			
			back = ForgeData.loadswfTool.GetResource().GetClassByMovieClip("ForgeBack");
			this.ForgeProp.mouseEnabled=false;
			panelBase = new PanelBase(ForgeProp, back.width+10, 520);
//			ForgeProp.x = 40;
			back.y -= 13;
			ForgeProp.addChild(back);
			panelBase.name = "ForgeProp";
			panelBase.addEventListener(Event.CLOSE, panelCloseHandler);
			panelBase.SetTitleMc(ForgeData.loadswfTool.GetResource().GetClassByMovieClip("ForgeIcon"));
//			panelBase.SetTitleDesign();
			
			panelBase.closeFunc = closePanel;
			
			
			facade.sendNotification(ForgeEvent.INIT_FORGE_UILIB);
		}
		
		private function registerMediator():void
		{		
			forgeBag = new ForgeBagMediator(ForgeProp);
			mosaic = new MosaicMediator(ForgeProp);
			strengthen = new StrengthenMediator(ForgeProp);
			inherit = new InheritMediator(ForgeProp);
			quality = new QualityMediator(ForgeProp);
			baptize = new BaptizeMediator(ForgeProp);
			decompose = new DecomposeMediator(ForgeProp);
			
			
			facade.registerMediator(forgeBag);
			facade.registerMediator(mosaic);
			facade.registerMediator(strengthen);
			facade.registerMediator(inherit);
			facade.registerMediator(quality);
			facade.registerMediator(baptize);
			facade.registerMediator(decompose);
			
			//初始化宠物面板素材
			facade.sendNotification(ForgeEvent.INIT_FORGE_UI);
		}
		
		private function initView():void
		{
			//打开坐骑面板，初始化打开坐骑列表，坐骑展示和坐骑属性面板
			facade.sendNotification(ForgeEvent.SHOW_FORGE_BAG_UI);
			facade.sendNotification(ForgeEvent.SHOW_FORGE_STRENGTHEN_UI);
		}
		
		private function initPropUI():void
		{
			for( var i:int = 0; i<6; i++ )
			{
				ForgeProp["Prop_"+i].gotoAndStop(1);
				ForgeProp["Prop_"+i].addEventListener(MouseEvent.CLICK, selectView);
				ForgeProp["Prop_"+i].mouseEnabled = true;
			}
			ForgeProp["Prop_0"].gotoAndStop(3);
			ForgeProp["Prop_0"].mouseEnabled = false;
		}
		
		private function selectView(e:MouseEvent):void
		{
			var lastPage:int = curPage;
			curPage = e.currentTarget.name.split("_")[1];
			
			ForgeProp["Prop_"+lastPage].gotoAndStop(1);
			ForgeProp["Prop_"+curPage].gotoAndStop(3);
			ForgeProp["Prop_"+lastPage].mouseEnabled = true;
			ForgeProp["Prop_"+curPage].mouseEnabled = false;
			
			
			closeSubPanel(lastPage);
			openSubPanel(curPage);
		}
		
		private function closeSubPanel(index:int):void
		{
			switch(index)
			{
				case 0:
					facade.sendNotification(ForgeEvent.CLOSE_FORGE_STRENGTHEN_UI);
					break;
				case 1:
					facade.sendNotification(ForgeEvent.CLOSE_FORGE_BAPTIZE_UI);
					break;
				case 2:
					facade.sendNotification(ForgeEvent.CLOSE_FORGE_QUALITY_UI);
					break;
				case 3:
					facade.sendNotification(ForgeEvent.CLOSE_FORGE_MOSAIC_UI);
					break;
				case 4:
					facade.sendNotification(ForgeEvent.CLOSE_FORGE_DECOMPOSE_UI);
					break;
				case 5:
					facade.sendNotification(ForgeEvent.CLOSE_FORGE_INHERIT_UI);
					break;
			}
		}
		
		private function openSubPanel(index:int):void
		{
			switch(index)
			{
				case 0:
					facade.sendNotification(ForgeEvent.SHOW_FORGE_STRENGTHEN_UI);
					ForgeData.curPage = 0;
					break;
				case 1:
					facade.sendNotification(ForgeEvent.SHOW_FORGE_BAPTIZE_UI);
					ForgeData.curPage = 1;
					break;
				case 2:
					facade.sendNotification(ForgeEvent.SHOW_FORGE_QUALITY_UI);
					ForgeData.curPage = 2;
					break;
				case 3:
					facade.sendNotification(ForgeEvent.SHOW_FORGE_MOSAIC_UI);
					ForgeData.curPage = 3;
					break;
				case 4:
					facade.sendNotification(ForgeEvent.SHOW_FORGE_DECOMPOSE_UI);
					ForgeData.curPage = 4;
					break;
				case 5:
					facade.sendNotification(ForgeEvent.SHOW_FORGE_INHERIT_UI);
					ForgeData.curPage = 5;
					break;
			}
			facade.sendNotification(ForgeEvent.UPDATE_ITEM_LIST,null);
		}
		
		private function closePanel():void
		{
			panelCloseHandler(null);
		}
		
		private function panelCloseHandler(event:Event):void
		{
			facade.sendNotification(ForgeEvent.CLOSE_FORGE_BAG_UI);

			closeSubPanel(curPage);
			if(GameCommonData.GameInstance.GameUI.contains(panelBase))
			{
				for( var i:int = 0; i<6; i++ )
				{
					ForgeProp["Prop_"+i].removeEventListener(MouseEvent.CLICK, selectView);
				}
				GameCommonData.GameInstance.GameUI.removeChild(panelBase); 
			}
			dataProxy.ForgeIsOpen = false;
			ForgeData.curPage = -1;
			
			facade.removeMediator(ForgeBagMediator.NAME);
			facade.removeMediator(MosaicMediator.NAME);
			facade.removeMediator(StrengthenMediator.NAME);
			facade.removeMediator(InheritMediator.NAME);
			facade.removeMediator(QualityMediator.NAME);
			facade.removeMediator(BaptizeMediator.NAME);
			facade.removeMediator(DecomposeMediator.NAME);
		}
	}
}