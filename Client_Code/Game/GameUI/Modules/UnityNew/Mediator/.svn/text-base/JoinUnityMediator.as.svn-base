package GameUI.Modules.UnityNew.Mediator
{
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Hint.Events.HintEvents;
	import GameUI.Modules.Unity.Data.UnityEvent;
	import GameUI.Modules.UnityNew.Data.NewUnityCommonData;
	import GameUI.Modules.UnityNew.Net.RequestUnity;
	import GameUI.Modules.UnityNew.Proxy.NewUnityResouce;
	import GameUI.Modules.UnityNew.View.IUnityCell;
	import GameUI.Modules.UnityNew.View.SingleJoinUnityCell;
	import GameUI.Proxy.DataProxy;
	import GameUI.UIUtils;
	import GameUI.View.BaseUI.AutoPanelBase;
	import GameUI.View.BaseUI.PanelBase;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	/**
	 * xuxiao
	 * 加入帮派面板
	 * **/
	public class JoinUnityMediator extends Mediator
	{
		public static const NAME:String = "JoinUnityMediator";
		
		private var main_mc:MovieClip;
		//private var panelBase:AutoPanelBase;
		private var panelBase:PanelBase;
		private var getOutTimer:Timer = new Timer(200, 1);	//物品取出计时器
		private var yellowFrame:Shape;
		
		private var container:Sprite;
		private var allUnitys:Array = [];
		private var aCurList:Array = [];
		
		private var currentPage:int = 1;
		private var totalPage:int = 1;
		private var openState:Boolean = false;
		private var dataProxy:DataProxy;
		
		private var seekUnity:String;
		private 	var seekBoss:String;
		
		public function JoinUnityMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		public override function listNotificationInterests():Array
		{
			return [
							NewUnityCommonData.SHOW_JOIN_UINTY_NEW,
							NewUnityCommonData.CLOSE_JOIN_UNITY_NEW,
							NewUnityCommonData.RECEIVE_ALL_UNITYS_LIST
						];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch ( notification.getName() )
			{
				case NewUnityCommonData.SHOW_JOIN_UINTY_NEW:
					
					if(openState == false)//关闭状态
					{
						if ( NewUnityCommonData.newUintyRes==null)
						{
							NewUnityCommonData.newUintyRes = new NewUnityResouce();
							NewUnityCommonData.newUintyRes.resDoneHandler = resDoneHandler;
						}
						else
						{
							openMe();
						}
					}
					else
					{
						panelClosed(null);
					}
					
					
					
				break;
				case NewUnityCommonData.CLOSE_JOIN_UNITY_NEW:
					panelClosed(null);
				break;
				case NewUnityCommonData.RECEIVE_ALL_UNITYS_LIST:
					analyData( notification.getBody() as Array );
				break;
			}
		}
		
		/**加载帮派资源回调**/
		private function resDoneHandler():void
		{
			openMe();
		}
		
		//分析数据
		private function analyData( arr:Array ):void
		{
			this.totalPage = Math.ceil( arr.length/14 );		//总页码
			if ( this.totalPage == 0 )
			{
				totalPage = 1;
				return;
			}
			for ( var i:uint=0; i<totalPage; i++ )
			{
				this.allUnitys[ i ] = arr.slice( i*14,i*14+14 );
			}
			this.aCurList = allUnitys[ currentPage-1 ];
			updataMe();
		}
		
		/**初始化帮派界面**/
		private function initView():void
		{
			main_mc = NewUnityResouce.getMovieClipByName("FactionJoinPanel");
			dataProxy = facade.retrieveProxy( DataProxy.NAME ) as DataProxy;
			( main_mc.page_txt as TextField ).mouseEnabled = false;
			//( main_mc.createBtn_txt as TextField ).mouseEnabled = false;
			//panelBase = new AutoPanelBase( main_mc,main_mc.width+8,main_mc.height+12 );
			panelBase = new PanelBase( main_mc,main_mc.width+8,main_mc.height+12 );
			if( GameCommonData.fullScreen == 2 )
			{
				panelBase.x = UIConstData.DefaultPos1.x + (GameCommonData.GameInstance.GameUI.stage.stageWidth - GameConfigData.GameWidth)/2;
				panelBase.y = UIConstData.DefaultPos1.y + (GameCommonData.GameInstance.GameUI.stage.stageHeight - GameConfigData.GameHeight)/2;
			}else
			{
				panelBase.x = UIConstData.DefaultPos1.x;
				panelBase.y = UIConstData.DefaultPos1.y;
			}
			panelBase.SetTitleMc(NewUnityResouce.getMovieClipByName("TitleFactionMc"));       //帮 派
			container = new Sprite();
			container.x = 19;
			container.y = 46;
			main_mc.addChild( container );
			yellowFrame = UIUtils.createFrame( 604,29 );
		}
		
		private function openMe():void
		{
			if ( !main_mc )
			{
				initView();
			}
			
			panelBase.addEventListener( Event.CLOSE,panelClosed );
			GameCommonData.GameInstance.GameUI.addChild( panelBase );
			dataProxy.UnitInfoIsOpen = true;
			
			checkRequest();
			( main_mc.left_btn as SimpleButton ).addEventListener( MouseEvent.CLICK,goLeft );
			( main_mc.right_btn as SimpleButton ).addEventListener( MouseEvent.CLICK,goRight );
			//( main_mc.seek_btn as SimpleButton ).addEventListener( MouseEvent.CLICK,seekUnityInviteHandle );
			( main_mc.create_btn as SimpleButton ).addEventListener( MouseEvent.CLICK,createUnityHandler );
			( main_mc["show_noFull_btn"] as MovieClip).gotoAndStop(2);//只显示成员还没满的帮派勾选框
			( main_mc["show_autoPass_btn"] as MovieClip).gotoAndStop(2);//只显示自动申请通过的帮派勾选框
//			( main_mc.showNotFull_btn as MovieClip).addEventListener( MouseEvent.CLICK,showNotFullHangle );
//			( main_mc.showGrandmaster_btn as MovieClip).addEventListener( MouseEvent.CLICK,showGrandMasterHandle );
//			( main_mc.showNotFull_btn as MovieClip).buttonMode=true;
//			( main_mc.showGrandmaster_btn as MovieClip).buttonMode=true;
//			( main_mc.showNotFull_btn as MovieClip).gotoAndStop(2);
//			( main_mc.showGrandmaster_btn as MovieClip).gotoAndStop(2);
			
//			
//			
//			main_mc.unityName_txt.addEventListener( Event.CHANGE,textHandler );
//			main_mc.unityBoss_txt.addEventListener( Event.CHANGE,textHandler );
//			UIUtils.addFocusLis( main_mc.unityName_txt );
//			UIUtils.addFocusLis( main_mc.unityBoss_txt );
			UIConstData.FocusIsUsing = true;
			openState=true;
		}
		
		
		/**只显示帮派人数没满的**/
		private function showNotFullHangle(evt:MouseEvent):void
		{
			if(( main_mc.showNotFull_btn as MovieClip).currentFrame==1)
			{
				( main_mc.showNotFull_btn as MovieClip).gotoAndStop(2);
			}
			else
			{
				( main_mc.showNotFull_btn as MovieClip).gotoAndStop(1);
			}
			
		}
		
		/**只显示帮主或副帮主在线的**/
		private function showGrandMasterHandle(evt:MouseEvent):void
		{
			if(( main_mc.showGrandmaster_btn as MovieClip).currentFrame==1)
			{
				( main_mc.showGrandmaster_btn as MovieClip).gotoAndStop(2);
			}
			else
			{
				( main_mc.showGrandmaster_btn as MovieClip).gotoAndStop(1);
			}
		}
		
		
		private function textHandler( evt:Event ):void
		{
			var targetTxt:TextField = evt.target as TextField;

			if ( evt.target.name == "unityName_txt" )
			{
				this.seekUnity = targetTxt.text;
			}
			else if ( evt.target.name == "unityBoss_txt" )
			{
				this.seekBoss = targetTxt.text;
			}
			if ( this.seekUnity=="" && this.seekBoss=="" )
			{
				this.aCurList = allUnitys[ currentPage-1 ];
				updataMe();
			}
		}
		
		private function createUnityHandler( evt:MouseEvent ):void
		{
			sendNotification( UnityEvent.SHOWCREATEUNITYVIEW );
		}
		
		private function checkRequest():void
		{
			NewUnityCommonData.allUnityArr = [];
			RequestUnity.send( 304,0 );
		}
		
		private function updataMe():void
		{
			if ( openState )
			{
				clearContainer();
				createCells();
				showBottomInfo();
			}
		}
		
		private function clearContainer():void
		{
			var des:*;
			while ( container && container.numChildren>0 ) 
			{
				des = container.removeChildAt( 0 );
				if ( des is IUnityCell )
				{
					( des as IUnityCell ).gc();
				}
				des = null;
			}
		}
		
		private function createCells():void
		{
			this.aCurList = allUnitys[ currentPage-1 ];
			
			var cell:SingleJoinUnityCell;
			for ( var i:uint=0; i<aCurList.length; i++ )
			{
				cell = new SingleJoinUnityCell( aCurList[ i ] );
				cell.init();
				cell.clickMe = clickCell;
				cell.y = 29*i;
				container.addChild( cell );	
			}
		}
		
		private function clickCell( cell:SingleJoinUnityCell ):void
		{
			cell.addChild( yellowFrame );
		}
		
		private function goLeft(evt:MouseEvent):void
		{
			if ( currentPage > 1 )
			{
				currentPage --;
				showBottomInfo();
				checkRequest();
			}
		}
		
		private function goRight(evt:MouseEvent):void
		{
			if ( currentPage < totalPage )
			{
				if ( !startTimer() ) return;
				currentPage ++;
				showBottomInfo();
				checkRequest();
			}
		}
		
		
		/**查看帮派邀请列表**/
		private function seekUnityInviteHandle(evt:MouseEvent):void
		{
			sendNotification(UnityEvent.SHOWUNITYINVITEVIEW);
		}
		
		//查看帮派
//		private function seekUnityHandler( evt:MouseEvent ):void
//		{
//			if ( main_mc.unityName_txt.text=="" && main_mc.unityBoss_txt.text=="" )
//			{
//				sendNotification( HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_unityN_med_joi_see_1" ], color:0xffff00 } );        //请先输入帮派或帮主名称
//				return;
//			}
//			
//			seekUnity = main_mc.unityName_txt.text;
//			seekBoss = main_mc.unityBoss_txt.text;
//			this.aCurList = [];
//			if ( allUnitys.length>0 )
//			{
//				for ( var i:uint=0; i<allUnitys.length; i++ )
//				{
//					for ( var j:uint=0; j<allUnitys[i].length; j++ )
//					{
//						if ( seekUnity.length>0 )
//						{
//							if ( allUnitys[i][j].name.indexOf( seekUnity ) > -1 )
//							{
//								aCurList.push( allUnitys[i][j] );
//							}
//						}
//						if ( seekBoss.length>0 )
//						{
//							if ( allUnitys[i][j].boss.indexOf( seekBoss ) > -1 )
//							{
//								aCurList.push( allUnitys[i][j] );
//							}
//						}
//					}
//				}
//			}
//			updataMe();
//		}
		
		private function showBottomInfo():void
		{
			( main_mc.page_txt as TextField ).text = GameCommonData.wordDic[ "mod_her_med_lea_vie_1" ] + currentPage + "/" + totalPage + GameCommonData.wordDic[ "mod_her_med_lea_vie_2" ];     //第         页	
		}
		
		//操作延时器
		private function startTimer():Boolean
		{
			if(getOutTimer.running) 
			{
				facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_dep_pro_ite_sta" ], color:0xffff00});//"请稍后"
				return false;
			} 
			else 
			{
				getOutTimer.reset();
				getOutTimer.start();
				return true;
			}
		}
		
		private function panelClosed( evt:Event ):void
		{
			if ( panelBase && GameCommonData.GameInstance.GameUI.contains( panelBase ) )
			{
				( main_mc.left_btn as SimpleButton ).removeEventListener( MouseEvent.CLICK,goLeft );
				( main_mc.right_btn as SimpleButton ).removeEventListener( MouseEvent.CLICK,goRight );
				//( main_mc.seek_btn as SimpleButton ).removeEventListener( MouseEvent.CLICK,seekUnityInviteHandle);
				( main_mc.create_btn as SimpleButton ).removeEventListener( MouseEvent.CLICK,createUnityHandler );
				//( main_mc.showNotFull_btn as MovieClip).removeEventListener( MouseEvent.CLICK,showNotFullHangle );
				//( main_mc.showGrandmaster_btn as MovieClip).removeEventListener( MouseEvent.CLICK,showGrandMasterHandle );
				
			//	main_mc.unityName_txt.removeEventListener( Event.CHANGE,textHandler );
			//	main_mc.unityBoss_txt.removeEventListener( Event.CHANGE,textHandler );
				
				panelBase.removeEventListener( Event.CLOSE,panelClosed );
				GameCommonData.GameInstance.GameUI.removeChild( panelBase );
			}
			openState = false;
			dataProxy.UnitInfoIsOpen = false;
			UIConstData.FocusIsUsing = false;
		}
		
	}
}