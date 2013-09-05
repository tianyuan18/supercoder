package GameUI.Modules.Mount.Mediator
{
	import Controller.PetController;
	
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Mount.Mediator.*;
	import GameUI.Modules.Mount.MountData.MountEvent;
	import GameUI.Proxy.DataProxy;
	import GameUI.UIConfigData;
	import GameUI.View.BaseUI.PanelBase;
	import GameUI.Modules.Bag.Proxy.NetAction;
	import GameUI.Modules.Mount.MountData.MountData;
	import GameUI.Modules.GmTools.Utils.LoadSwfTool;
	
	import Net.ActionProcessor.OperateItem;
	import Net.ActionProcessor.PlayerAction;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class MountMediator extends Mediator
	{
		public static const NAME:String = "MountMediator";
		private var panelBase:PanelBase;
		private var dataProxy:DataProxy = null;
		
		//坐骑面板
		private var mountList:MountListMediator = null;
		private var mountArribute:MountAttributeMediator = null;
		private var mountDisplay:MountDisplayMediator = null;
		private var mountEvolution:MountEvolutionMediator = null;
		private var mountStrong:MountStrongMediator = null;

		private var back:MovieClip = null;
		private var timer:Timer;
		private var timerOut:Timer;
		
		public function MountMediator()
		{
			super(NAME);
		}
		
		public function get MountProp():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				EventList.INITVIEW,
				MountEvent.SHOW_MOUNT_UI,
				MountEvent.INIT_MOUNT_UILIB,
				MountEvent.CLOSE_MOUNT_UI
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case EventList.INITVIEW:
					dataProxy = facade.retrieveProxy(DataProxy.NAME) as DataProxy;
					
					break;
				
				case MountEvent.INIT_MOUNT_UILIB:

					MountData.curPage = 0;
					MountData.SelectedMountId = 0;
					MountData.SelectedMount = null;
					initView();
					initPropUI();
//					sendNotification(MountEvent.LOOKMOUNTINFO_BYID);
					var p:Point = UIConstData.getPos(panelBase.width,panelBase.height);
					panelBase.x = p.x;
					panelBase.y = p.y;
					GameCommonData.GameInstance.GameUI.addChild(panelBase);
					dataProxy.MountIsOpen = true;
					break;
				
				case MountEvent.SHOW_MOUNT_UI:
					if(MountProp == null){
						MountData.loadswfTool = new LoadSwfTool(GameConfigData.MountUI , this);
						MountData.loadswfTool.sendShow = sendShow;
					}
					else
					{
						facade.sendNotification(MountEvent.INIT_MOUNT_UILIB);
					}
					
					break;
				
				case MountEvent.CLOSE_MOUNT_UI:
					//释放所有面板，暂时未处理
					panelCloseHandler(null);
					break;
				
				case MountEvent.LOOKMOUNTINFO_BYID:								//通过ID去服务器查询，查看宠物属性
//					var ids:Object = notification.getBody(); 
//					if(ids.petId > 0) {
//						NetAction.RequestItems();
//					}
					break;
			}
			
		}
		
		private function sendShow(view:MovieClip):void{
			
			this.setViewComponent(MountData.loadswfTool.GetResource().GetClassByMovieClip(UIConfigData.MOUNTVIEW));
			back = MountData.loadswfTool.GetResource().GetClassByMovieClip("MountBack");
			this.MountProp.mouseEnabled=false;
			panelBase = new PanelBase(MountProp, back.width+10, 457);
//			back.x -=10;
			MountProp.addChild(back);
			panelBase.name = "MountProp";
			panelBase.addEventListener(Event.CLOSE, panelCloseHandler);
			panelBase.SetTitleMc(MountData.loadswfTool.GetResource().GetClassByMovieClip("MountPropIcon"));
//			panelBase.SetTitleName("MountPropIcon");
			panelBase.SetTitleDesign();
			
			panelBase.closeFunc = closePanel;
			registerMediator();
			
			timer = new Timer(1000, 1);
			timerOut = new Timer(1000, 1);
			
			facade.sendNotification(MountEvent.INIT_MOUNT_UILIB);
		}
		
		private function registerMediator():void
		{		
			mountList = new MountListMediator(MountProp);
			mountArribute = new MountAttributeMediator(MountProp);
			mountDisplay = new MountDisplayMediator(MountProp);
			mountEvolution = new MountEvolutionMediator(MountProp);
			mountStrong = new MountStrongMediator(MountProp);

			
			facade.registerMediator(mountList);
			facade.registerMediator(mountArribute);
			facade.registerMediator(mountDisplay);
			facade.registerMediator(mountEvolution);
			facade.registerMediator(mountStrong);
//			
			facade.sendNotification(MountEvent.INIT_MOUNT_UI);
			//初始化宠物面板素材
			
		}
		
		private function initView():void
		{
			//打开坐骑面板，初始化打开坐骑列表，坐骑展示和坐骑属性面板

			facade.sendNotification(MountEvent.OPEN_MOUNT_LIST);
			facade.sendNotification(MountEvent.OPEN_MOUNT_DISPLAY);
			facade.sendNotification(MountEvent.OPEN_MOUNT_ARRIBUTE);
		}
		
		private function initPropUI():void
		{
			for( var i:int = 0; i<3; i++ )
			{
				MountProp["Prop_"+i].gotoAndStop(1);
				MountProp["Prop_"+i].addEventListener(MouseEvent.CLICK, selectView);
				MountProp["Prop_"+i].mouseEnabled = true;
				MountProp["Prop_"+i].buttonMode = true;
			}
			MountProp["Prop_0"].gotoAndStop(3);
			MountProp["Prop_0"].mouseEnabled = false;
		}
		
		private function selectView(e:MouseEvent):void
		{
			var lastPage:int = MountData.curPage;
			MountData.curPage = e.currentTarget.name.split("_")[1];
			
			MountProp["Prop_"+lastPage].gotoAndStop(1);
			MountProp["Prop_"+MountData.curPage].gotoAndStop(3);
			MountProp["Prop_"+lastPage].mouseEnabled = true;
			MountProp["Prop_"+MountData.curPage].mouseEnabled = false;
			
			
			closeSubPanel(lastPage);
			openSubPanel(MountData.curPage);
		}
		
		private function closeSubPanel(index:int):void
		{
			switch(index)
			{
				case 0:
					facade.sendNotification(MountEvent.CLOSE_MOUNT_DISPLAY);
					break;
				case 1:
					facade.sendNotification(MountEvent.CLOSE_MOUNT_STRONG);
					break;
				case 2:
					facade.sendNotification(MountEvent.CLOSE_MOUNT_EVOLUTION);
					break;
			}
		}
		
		private function openSubPanel(index:int):void
		{
			switch(index)
			{
				case 0:
					facade.sendNotification(MountEvent.OPEN_MOUNT_DISPLAY);
					break;
				case 1:
					facade.sendNotification(MountEvent.OPEN_MOUNT_STRONG);
					break;
				case 2:
					facade.sendNotification(MountEvent.OPEN_MOUNT_EVOLUTION);
					break;
			}
		}
		
		private function closePanel():void
		{
			panelCloseHandler(null);
		}
		
		private function panelCloseHandler(event:Event):void
		{
			facade.sendNotification(MountEvent.CLOSE_MOUNT_ARRIBUTE);
			facade.sendNotification(MountEvent.CLOSE_MOUNT_LIST);
			closeSubPanel(MountData.curPage);
			if(GameCommonData.GameInstance.GameUI.contains(panelBase))
			{
				for( var i:int = 0; i<3; i++ )
				{
					MountProp["Prop_"+i].removeEventListener(MouseEvent.CLICK, selectView);
				}
				GameCommonData.GameInstance.GameUI.removeChild(panelBase); 
			}
			dataProxy.MountIsOpen = false;
		}
	}
}