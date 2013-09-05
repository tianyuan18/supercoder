package GameUI.Modules.UnityNew.Mediator
{
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Chat.Mediator.QuickSelectMediator;
	import GameUI.Modules.Hint.Events.HintEvents;
	import GameUI.Modules.UnityNew.Data.NewUnityCommonData;
	import GameUI.Modules.UnityNew.Mediator.Member.SingleApplyListMediator;
	import GameUI.Modules.UnityNew.Mediator.Member.SingleMemberListMediator;
	import GameUI.Modules.UnityNew.Proxy.NewUnityResouce;
	import GameUI.Proxy.DataProxy;
	import GameUI.View.BaseUI.AutoPanelBase;
	import GameUI.View.BaseUI.PanelBase;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class NewUnityMainMediator extends Mediator
	{
		public static const NAME:String = "NewUnityMainMediator";
		
		private var main_mc:MovieClip;
		private var dataProxy:DataProxy;
		private var panelBase:PanelBase;
		private var parentContainer:MovieClip;
		private var quickSelectMediator:QuickSelectMediator;
		private var newLookUnityMediator:NewLookUnityMediator;
		
		public function NewUnityMainMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super( NAME, viewComponent );
		}
		
		public override function listNotificationInterests():Array
		{
			return [
							NewUnityCommonData.CLICK_NEW_UNITY_BTN,
							NewUnityCommonData.CLOSE_NEW_UNITY_MAIN_PANEL
						]
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch ( notification.getName() )
			{
				case NewUnityCommonData.CLICK_NEW_UNITY_BTN:
					
						dataProxy = facade.retrieveProxy( DataProxy.NAME ) as DataProxy;
						if(dataProxy.UnityIsOpen==false)//关闭状态
						{
							if ( NewUnityCommonData.newUintyRes==null)
							{
								NewUnityCommonData.newUintyRes = new NewUnityResouce();
								NewUnityCommonData.newUintyRes.resDoneHandler = resDoneHandler;
							}
							else
							{
								showView();
							}
						}
						else
						{
							panelClosed(null);
						}
				break;
				case NewUnityCommonData.CLOSE_NEW_UNITY_MAIN_PANEL:
					dataProxy = facade.retrieveProxy( DataProxy.NAME ) as DataProxy;
					if ( dataProxy.UnityIsOpen )
					{
						panelClosed(null);
					}
				break;
			}
		}
		
		/**加载帮派资源回调**/
		private function resDoneHandler():void
		{
			//checkIsJoin();
			showView();
			if ( !newLookUnityMediator )
			{
				newLookUnityMediator = new NewLookUnityMediator();
				facade.registerMediator( newLookUnityMediator );
			}
		}
		
//		private function checkIsJoin():void
//		{
//			dataProxy = facade.retrieveProxy( DataProxy.NAME ) as DataProxy;
//			
//			if ( GameCommonData.Player.Role.unityId != 0 )//有帮派
//			{
//				hasUnity();
//			}
//			else
//			{
//				hasNotUnity();
//			}
//			
//			if ( !newLookUnityMediator )
//			{
//				newLookUnityMediator = new NewLookUnityMediator();
//				facade.registerMediator( newLookUnityMediator );
//			}
//		}
		
		/**显示帮派**/
		private function showView():void
		{
	
				main_mc = NewUnityResouce.getMovieClipByName("FactionTabs");//获取标签
				main_mc.name="factionTabs";
				parentContainer = new MovieClip();							//帮派主界面容器
				main_mc.x = 20;
				main_mc.y = 0;
				parentContainer.addChild( main_mc );
				panelBase = new PanelBase(parentContainer,650,420);
				panelBase.SetTitleMc(NewUnityResouce.getMovieClipByName("TitleFactionMc"));
				panelBase.addEventListener( Event.CLOSE,panelClosed );
				var p:Point = UIConstData.getPos(panelBase.width,panelBase.height);			//居中
				panelBase.x = p.x;
				panelBase.y = p.y;
				GameCommonData.GameInstance.GameUI.addChild( panelBase );
				
				//注册面板
				facade.registerMediator( new NewUnityInfoMediator() );//帮派信息
				facade.registerMediator( new NewUnityMemberMediator() );//帮派成员
				facade.registerMediator( new NewUnityListMediator() );//帮派列表
				facade.registerMediator( new NewUnityPlaceMediator() );//帮派建筑
				facade.registerMediator( new NewUnityHistoryMediator());//帮派日志
				facade.registerMediator(new SingleApplyListMediator());//申请面板
				facade.registerMediator(new NewUnityGoalMediator());//帮派目标
				
				changPage();		
				//注册标签页点击事件
				for ( var i:uint=0; i<6; i++ )
				{
					( main_mc[ "mcPage_"+i ] as MovieClip ).buttonMode = true;
					main_mc[ "mcPage_"+i ].addEventListener( MouseEvent.CLICK,onClickPage );
				}
				dataProxy.UnityIsOpen=true;
		}
		
		//有帮
//		private function hasUnity():void
//		{
//			if ( !main_mc )
//			{
//				main_mc = NewUnityResouce.getMovieClipByName("FactionTabs");
//				main_mc.name="factionTabs";
//				parentContainer = new MovieClip();
//				main_mc.x = 20;
//				main_mc.y = 0;
//				parentContainer.addChild( main_mc );
//				
//				facade.registerMediator( new NewUnityInfoMediator() );//帮派信息
//				facade.registerMediator( new NewUnityMemberMediator() );//帮派成员
//				facade.registerMediator( new NewUnityListMediator() );//帮派列表
//				facade.registerMediator( new NewUnityPlaceMediator() );//帮派建筑
//				facade.registerMediator( new NewUnityHistoryMediator());//帮派日志
//				facade.registerMediator(new SingleApplyListMediator());//申请面板
//				facade.registerMediator(new NewUnityGoalMediator());//帮派目标
//				
//				panelBase = new PanelBase(parentContainer,650,420);
//				
//				if( GameCommonData.fullScreen == 2 ) 
//				{
//					panelBase.x = UIConstData.DefaultPos1.x + Math.floor(GameCommonData.GameInstance.GameUI.stage.stageWidth - GameConfigData.GameWidth)/2;
//					panelBase.y = UIConstData.DefaultPos1.y + Math.floor(GameCommonData.GameInstance.GameUI.stage.stageHeight - GameConfigData.GameHeight)/2;
//				}else{
//					panelBase.x = UIConstData.DefaultPos1.x;
//					panelBase.y = UIConstData.DefaultPos1.y;
//				}
//				
//				panelBase.SetTitleMc(NewUnityResouce.getMovieClipByName("TitleFactionMc"));
//			}
//			
//			if ( dataProxy.UnityIsOpen )
//			{
//				panelClosed( null );
//			}
//			else
//			{
//				openUnity();
//			}
//		}
		
		/**打开帮派面板**/
//		private function openUnity():void
//		{
//			panelBase.addEventListener( Event.CLOSE,panelClosed );
//			var p:Point = UIConstData.getPos(panelBase.width,panelBase.height);
//			panelBase.x = p.x;
//			panelBase.y = p.y;
//			GameCommonData.GameInstance.GameUI.addChild( panelBase );
//			changPage();
//			for ( var i:uint=0; i<6; i++ )
//			{
//				( main_mc[ "mcPage_"+i ] as MovieClip ).buttonMode = true;
//				main_mc[ "mcPage_"+i ].addEventListener( MouseEvent.CLICK,onClickPage );
//			}
//			dataProxy.UnityIsOpen = true;
//		}
		
		/**标签页点击响应事件**/
		private function onClickPage( evt:MouseEvent ):void
		{
			var index:int = evt.currentTarget.name.split( "_" )[ 1 ];
			if ( NewUnityCommonData.currentPage == index ) 
			{
				return;
			}
			
			//帮派，建筑，日志，目标。暂时关闭
			if(index == 2 || index==4 || index==5)
			{
				/**帮派功能正在调试，暂时关闭**/
				facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "Modules_MainSence_Mediator_MainSenceMediator_7" ],color:0xffff00});	
				return;
			}
			sendNotification( NewUnityCommonData.CLEAR_UNITY_LAST_OPEN_PANEL,NewUnityCommonData.currentPage );
			NewUnityCommonData.currentPage = index;
			changPage();
		}
		
		/**改变标签页**/
		private function changPage():void
		{
			for ( var i:uint=0; i<6; i++ )
			{
				( main_mc[ "mcPage_"+i ] as MovieClip ).gotoAndStop( 1 );
			}
			main_mc[ "mcPage_" + NewUnityCommonData.currentPage ].gotoAndStop( 3 ); 
			sendNotification( NewUnityCommonData.CHANG_NEW_UNITY_PAGE,this.parentContainer );
		}
		
		//没帮
//		private function hasNotUnity():void
//		{
//			if ( !facade.hasMediator( JoinUnityMediator.NAME ) )
//			{
//				facade.registerMediator( new JoinUnityMediator() );
//			}
//			
//			if ( dataProxy.UnitInfoIsOpen )
//			{
////				dataProxy.UnitInfoIsOpen = false;
//				sendNotification( NewUnityCommonData.CLOSE_JOIN_UNITY_NEW );
//			}
//			else
//			{
////				dataProxy.UnitInfoIsOpen = true;
//				sendNotification( NewUnityCommonData.SHOW_JOIN_UINTY_NEW );
//			}
//		}
		
		private function panelClosed( evt:Event ):void
		{
			if ( panelBase && GameCommonData.GameInstance.GameUI.contains( panelBase ) )
			{
				sendNotification( NewUnityCommonData.CLEAR_UNITY_LAST_OPEN_PANEL,NewUnityCommonData.currentPage );
				for ( var i:uint=0; i<6; i++ )
				{
					main_mc[ "mcPage_"+i ].removeEventListener( MouseEvent.CLICK,onClickPage );
				}
				
				panelBase.removeEventListener( Event.CLOSE,panelClosed );
				GameCommonData.GameInstance.GameUI.removeChild( panelBase );
				
				panelBase=null;
				dataProxy.UnityIsOpen = false;
			}
			if ( facade.hasMediator( QuickSelectMediator.NAME ) )
			{
				facade.removeMediator( QuickSelectMediator.NAME ) ;
			}
			if ( newLookUnityMediator )
			{
				facade.removeMediator( NewLookUnityMediator.NAME );
				newLookUnityMediator = null;
			}
		}
	
		
	}
}