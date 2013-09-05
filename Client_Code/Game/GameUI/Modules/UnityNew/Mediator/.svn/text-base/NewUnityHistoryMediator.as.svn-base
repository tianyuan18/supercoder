package GameUI.Modules.UnityNew.Mediator
{
	import GameUI.Modules.UnityNew.Data.NewUnityCommonData;
	import GameUI.Modules.UnityNew.Proxy.NewUnityResouce;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	
	/**
	 * 帮派历史页面 xuxiao
	 * **/
	public class NewUnityHistoryMediator extends Mediator
	{
		public static const NAME:String = "NewUnityHistoryMediator";
		
		private var parentContainer:MovieClip;
		private var main_mc:MovieClip;

		public function NewUnityHistoryMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME);
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				NewUnityCommonData.CHANG_NEW_UNITY_PAGE,
				NewUnityCommonData.CLEAR_UNITY_LAST_OPEN_PANEL
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch ( notification.getName() )
			{
				case NewUnityCommonData.CHANG_NEW_UNITY_PAGE:
					parentContainer = notification.getBody() as MovieClip;
					if ( NewUnityCommonData.currentPage == 4 )
					{
						openMe();
					}
					break;
				case NewUnityCommonData.CLEAR_UNITY_LAST_OPEN_PANEL:
					if ( notification.getBody() == 4 )
					{
						clearMe();
					}
					break;
			}
		}
		
		private function initView():void
		{
			main_mc = NewUnityResouce.getMovieClipByName("FactionHistoryPanel");
			var mc:DisplayObject=parentContainer.getChildByName("factionTabs");
			main_mc.y=mc.y+23;
			changPage();
		}
		
		private function openMe():void
		{
			if ( !main_mc )
			{
				initView();
			}
			
			changPage();
			parentContainer.addChildAt( main_mc,0 );
			
			for ( var i:uint=0; i<4; i++ )
			{
				( main_mc[ "memPage_"+i ] as MovieClip ).buttonMode = true;
				( main_mc[ "memPage_"+i ] as MovieClip ).addEventListener( MouseEvent.CLICK,onClickPage );
			}
		}
		
		private function onClickPage( evt:MouseEvent):void
		{
			var index:int = evt.currentTarget.name.split( "_" )[ 1 ];
			if ( NewUnityCommonData.currentMemPage == index )
			{
				return;
			}
			sendNotification( NewUnityCommonData.CLEAR_MEMBER_PAGE_GO,NewUnityCommonData.currentMemPage );
			NewUnityCommonData.currentMemPage = index;
			changPage();
		}
		
		private function changPage():void
		{
			for ( var i:uint=0; i<4; i++ )
			{
				( main_mc[ "memPage_"+i ] as MovieClip ).gotoAndStop( 2 );
			}
			main_mc[ "memPage_" + NewUnityCommonData.currentMemPage ].gotoAndStop( 1 ); 
			main_mc.gotoAndStop( NewUnityCommonData.currentMemPage + 1 );
			
			//sendNotification( NewUnityCommonData.CLICK_MEMBER_PAGE_COME );
		}
		
		private function clearMe():void
		{
			if ( main_mc && parentContainer.contains( main_mc ) )
			{
				for ( var i:uint=0; i<4; i++ )
				{
					( main_mc[ "memPage_"+i ] as MovieClip ).removeEventListener( MouseEvent.CLICK,onClickPage );
				}
				
				sendNotification( NewUnityCommonData.CLEAR_MEMBER_PAGE_GO,NewUnityCommonData.currentMemPage );		//清理当前面板
				parentContainer.removeChild( main_mc );
			}
			
		}
		
	}
}