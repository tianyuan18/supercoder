package GameUI.Modules.UnityNew.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Unity.Data.UnityEvent;
	import GameUI.Modules.UnityNew.Data.NewUnityCommonData;
	import GameUI.Modules.UnityNew.Proxy.NewUnityResouce;
	import GameUI.Proxy.DataProxy;
	import GameUI.View.BaseUI.PanelBase;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	/**
	 *xuxiao
	 * 帮派邀请列表面板
	 * **/
	public class UnityInviteMediator extends Mediator
	{
		
		public static const NAME:String = "UnityInviteMediator";
		private var dataProxy:DataProxy = null;
		private var panelBase:PanelBase = null;
		private var currentPage:int;
		private var totalPage:int;
		private var Amount:int;
		private var dataArr:Array = new Array();								//包含操作号,帮派ID的数组
		private var idArr:Array = new Array();									//从服务器获取到一页的帮派id数组
		private var unityObj:Object = new Object();								//储存当前选中帮派的信息对象,id，帮派名，通告
		private var H:int;														//选中的行数
		private var inviteIsOpen:Boolean=false;
		
		public function UnityInviteMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME);
		}
		
		public function get inviteUnityView():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				EventList.INITVIEW,
				UnityEvent.SHOWUNITYINVITEVIEW,
				UnityEvent.CLOSEUNITYINVITEVIEW,
			]
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case EventList.INITVIEW:
					dataProxy = facade.retrieveProxy(DataProxy.NAME) as DataProxy;
					break;
				
				case UnityEvent.SHOWUNITYINVITEVIEW:
					if (inviteIsOpen )
					{
						gcAll();
					}
					else
					{
						showView();                                 					//将创建面板加入游戏中
					}
					break;
				
				case UnityEvent.CLOSEUNITYINVITEVIEW:
					gcAll();
					break;
			}
		}
		
		private function showView():void
		{
			this.setViewComponent(NewUnityResouce.getMovieClipByName("") as Object);
			panelBase = new PanelBase(inviteUnityView, inviteUnityView.width+8, inviteUnityView.height+12);
			panelBase.name = "IviteUnityView";
			panelBase.addEventListener(Event.CLOSE, panelCloseHandler);
			panelBase.x = UIConstData.DefaultPos2.x - 180;
			panelBase.y = UIConstData.DefaultPos2.y;
			GameCommonData.GameInstance.GameUI.addChild(panelBase); 
			inviteIsOpen=true;
		}
		
		private function panelCloseHandler(e:Event):void
		{
			gcAll();
		}
		
		private function gcAll():void
		{
			panelBase.removeEventListener(Event.CLOSE, panelCloseHandler);
			if(panelBase && GameCommonData.GameInstance.GameUI.contains(panelBase)) {
				GameCommonData.GameInstance.GameUI.removeChild(panelBase);	
			}
			inviteIsOpen=false;
		}
		
		
	}
}