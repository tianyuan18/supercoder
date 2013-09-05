package GameUI.Modules.NewerHelp.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.GmTools.Utils.LoadSwfTool;
	import GameUI.Modules.MainSence.Data.MainSenceData;
	import GameUI.Modules.NewerHelp.Data.NewerHelpEvent;
	import GameUI.View.BaseUI.PanelBase;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class NewMenuMediator extends Mediator
	{
		public static var NAME:String = "NewMenuMediator";
		public function NewMenuMediator()
		{
			super(NAME);
		}
		private var popPanel:MovieClip;
		public override function getViewComponent():Object{
			return popPanel;
		}
		public override function setViewComponent(viewComponent:Object):void{
			popPanel = viewComponent as MovieClip;
		}
		public override function listNotificationInterests():Array
		{
			return [
				EventList.INITVIEW,
				NewerHelpEvent.OPEN_MENU_PANLE];
		}
		public var loadswfTool:LoadSwfTool;
		private var openFunc:Function;
		private var panelBase:PanelBase;
		private var openTaskId:int;
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case EventList.INITVIEW://进入游戏成功，直接加载资源
					if(this.getViewComponent() == null){
						loadswfTool = new LoadSwfTool(GameConfigData.Open_Menu_SWF , this);
						loadswfTool.sendShow = loadOver;
					}
				break;
				case NewerHelpEvent.OPEN_MENU_PANLE:
					openTaskId = int(notification.getBody());
					if(this.getViewComponent() == null)
						openFunc = showView;
					else
						showView();
					break;
			}
		}
		/**
		 * 资源加载完成 
		 * @param mc
		 * 
		 */		
		private function loadOver(mc:MovieClip):void{
			setViewComponent(loadswfTool.GetResource().GetClassByMovieClip("MenuOpenView"))
			if(openFunc != null){
				openFunc();
				openFunc = null;
			}
		}
		/**
		 * 显示面板 
		 */		
		private function showView():void{
			initView();
			var frame:int = MainSenceData.getIndexByTask(openTaskId)+1;
			popPanel.MenuListMc.gotoAndStop(frame);
			var p:Point = UIConstData.getPos(panelBase.width,panelBase.height);
			panelBase.x = p.x;
			panelBase.y = p.y;
			
			GameCommonData.GameInstance.GameUI.addChild(panelBase); 
		}
		
		/**
		 * 初始化面板，以及事件的监听 
		 */		
		private function initView():void{
			if(panelBase == null){
				panelBase = new PanelBase(popPanel, popPanel.width, popPanel.height);
				panelBase.name = "NewMenuPanel";
				panelBase.SetTitleMc(GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("TishiIcon"));
				panelBase.SetTitleDesign();
				panelBase.addEventListener(Event.CLOSE, panelCloseHandler);
				popPanel.okBtn.addEventListener(MouseEvent.CLICK, panelCloseHandler);
			}
		}
		private function panelCloseHandler(e:Object = null):void{
			openFunc = null;
			//通知MainScene播放添加功能按钮事件
			var param:Array = [];
			param.push(MainSenceData.getOpenMenuNames(this.openTaskId));
			param.push(MainSenceData.getMenuNameByTask(this.openTaskId));
			
			facade.sendNotification(MainSenceData.INITMAINITEM,param);
			GameCommonData.GameInstance.GameUI.removeChild(panelBase); 
		}
	}
}