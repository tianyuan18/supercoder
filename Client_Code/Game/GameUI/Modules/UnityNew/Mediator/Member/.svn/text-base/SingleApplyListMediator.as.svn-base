package GameUI.Modules.UnityNew.Mediator.Member
{
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Chat.Data.ChatEvents;
	import GameUI.Modules.Chat.Mediator.QuickSelectMediator;
	import GameUI.Modules.Hint.Events.HintEvents;
	import GameUI.Modules.UnityNew.Data.NewUnityCommonData;
	import GameUI.Modules.UnityNew.Net.RequestUnity;
	import GameUI.Modules.UnityNew.Proxy.NewUnityResouce;
	import GameUI.Modules.UnityNew.View.IUnityCell;
	import GameUI.Modules.UnityNew.View.SingleApplyListCell;
	import GameUI.UIUtils;
	import GameUI.View.BaseUI.PanelBase;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	

	/**
	 * 
	 * xuxiao
	 * 帮派申请面板(显示申请入本帮派的其他玩家列表）
	 * 
	 * **/
	public class SingleApplyListMediator extends Mediator
	{
		public static const NAME:String = "SingleApplyListMediator";
		
		private var container:Sprite;
		private var main_mc:MovieClip;
		
		private var aCurList:Array = [];//成员条
		private var currentPage:int = 1;//当前页数
		private var totalPage:int = 1;//总页数
		
		private var getOutTimer:Timer = new Timer(200, 1);	//物品取出计时器
		private var reqestTimer:Timer;									//请求数据计时器
		private var aData:Array = new Array();							
		private var allMembers:Array = [];								//所有的申请成员
		
		private var openState:Boolean = false;						//是否打开状态
		
		private var isRequest:Boolean = false;
		private var yellowFrame:Shape;								//选中某一成员时候显示黄色框
		private var panelBase:PanelBase;
		public function SingleApplyListMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super( NAME, viewComponent );
		}
		
		public override function listNotificationInterests():Array
		{
			return [NewUnityCommonData.CLOSE_APPLY_LIST_UINTY_NEW,
				NewUnityCommonData.SHOW_APPLY_LIST_UINTY_NEW,
				NewUnityCommonData.UPDATA_UNITY_APPLY_LIST_DATA]
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch ( notification.getName() )
			{
				case NewUnityCommonData.SHOW_APPLY_LIST_UINTY_NEW:
					
						if(openState==false)
						{
							showMe();
						}
						else
						{
							clearMe();
						}
						
				break;
				case NewUnityCommonData.CLOSE_APPLY_LIST_UINTY_NEW:
						
						clearMe();
				break;
				case NewUnityCommonData.UPDATA_UNITY_APPLY_LIST_DATA:
//					if ( openState )
//					{
//						var obj:Object = notification.getBody();
//						this.totalPage = obj.totalPage;
//						this.aCurList = obj.dataList;
//						aData[ currentPage - 1 ] = aCurList.concat();
//						updataMe();
//					}
					isRequest = true;
					analyData( notification.getBody() as Array );
				break;
			}
		}
		
		/**分析申请的成员列表数据**/
		private function analyData( arr:Array ):void
		{
			this.totalPage = Math.ceil( arr.length/14 );		//总页码
			if ( totalPage==0 )
			{
				totalPage = 1; 
				clearContainer();
				return;
			} 
			for ( var i:uint=0; i<totalPage; i++ )
			{
				this.allMembers[ i ] = arr.slice( i*14,i*14+14 );
			}
			updataMe();
		}
		
		/**显示页面**/
		private function showMe():void
		{
			if ( !container )
			{
				initView();
			}
			
			panelBase.addEventListener( Event.CLOSE,panelClosed );
			GameCommonData.GameInstance.GameUI.addChild( panelBase );
			currentPage = 1;
			
			checkRequest();
			//initTimer();
			( main_mc.left_btn as SimpleButton ).addEventListener( MouseEvent.CLICK,goLeft );
			( main_mc.right_btn as SimpleButton ).addEventListener( MouseEvent.CLICK,goRight );
			openState = true;
		}
		
		/**初始化窗口**/
		private function initView():void
		{
			main_mc=NewUnityResouce.getMovieClipByName("FactionApplyPanel");
			container = new Sprite();
			container.x = 19;
			container.y = 46;
			main_mc.addChild( container );
			(main_mc["auto_pass_btn"] as MovieClip).gotoAndStop(2);//自动通过申请玩家勾选按钮,默认为不打勾
			panelBase = new PanelBase(main_mc,650,420);
			panelBase.SetTitleMc(NewUnityResouce.getMovieClipByName("TitleFactionMc"));
			if( GameCommonData.fullScreen == 2 ) 
			{
				panelBase.x = UIConstData.DefaultPos1.x + Math.floor(GameCommonData.GameInstance.GameUI.stage.stageWidth - GameConfigData.GameWidth)/2;
				panelBase.y = UIConstData.DefaultPos1.y + Math.floor(GameCommonData.GameInstance.GameUI.stage.stageHeight - GameConfigData.GameHeight)/2;
			}else{
				panelBase.x = UIConstData.DefaultPos1.x;
				panelBase.y = UIConstData.DefaultPos1.y;
			}
			yellowFrame = UIUtils.createFrame( 604,29 );
		}
		
		/**初始化操作延时时间**/
		private function initTimer():void
		{
			if ( !reqestTimer )
			{
				reqestTimer = new Timer( 1800 * 1000,1 );
				//reqestTimer = new Timer( 1000,1 );
				reqestTimer.addEventListener( TimerEvent.TIMER_COMPLETE,timerComplete );
				reqestTimer.start();
			}
		}

		/**操作延时时间**/
		private function timerComplete( evt:TimerEvent ):void
		{
			for ( var i:uint=0; i<aData.length; i++ )
			{
				aData[ i ] = null;
			}
			if ( openState )
			{
				reqestTimer.start();
			}
			else
			{
				reqestTimer.removeEventListener( TimerEvent.TIMER_COMPLETE,timerComplete );
				reqestTimer = null;
			}
		}
		
		/**请求数据**/
		private function checkRequest():void
		{
			if ( !isRequest )
			{
				NewUnityCommonData.allApplyMemberArr = [];
				RequestUnity.send( 303,0 );
				//isRequest = true;
			}
			else
			{
				updataMe();
				analyData( NewUnityCommonData.allApplyMemberArr );
			}
		}
		
		/**更新显示**/
		private function updataMe():void
		{
			if ( openState )
			{
				clearContainer();
				createCells();
				showBottomInfo();
			}
		}
		
		/**删除成员条(每一行一个显示对象)**/
		private function clearContainer():void
		{
			var des:*;
			while ( container.numChildren>0 )
			{
				des = container.removeChildAt( 0 );
				if ( des is IUnityCell )
				{
					( des as IUnityCell ).gc();
				}
				des = null;
			}
		}
		
		/**创建成员条(每一行一个显示对象)**/
		private function createCells():void
		{
			this.aCurList = allMembers[ currentPage-1 ];
			if ( !aCurList ) return;
			var cell:SingleApplyListCell;
			for ( var i:uint=0; i<aCurList.length; i++ )
			{
				cell = new SingleApplyListCell( aCurList[ i ] );
				cell.init();
				cell.y = 23*i;
				cell.clickMe = clickCell;
				container.addChild( cell );	
			}
		}
		
		/**点击了当行（选中成员)**/
		private function clickCell( cell:SingleApplyListCell ):void
		{
			cell.addChild( this.yellowFrame );
//			if ( !facade.hasMediator( QuickSelectMediator.NAME ) )
//			{
//				facade.registerMediator( new QuickSelectMediator() );
//			}
//			sendNotification( ChatEvents.SHOWQUICKOPERATOR,cell.unityVo.name );
		}
		
		/**左翻页**/
		private function goLeft(evt:MouseEvent):void
		{
			if ( currentPage > 1 )
			{
				currentPage --;
				showBottomInfo();
				//clearContainer();
				checkRequest();
			}
		}
		
		/**右边翻页**/
		private function goRight(evt:MouseEvent):void
		{
			if ( currentPage < totalPage )
			{
				if ( !startTimer() ) return;
				currentPage ++;
				showBottomInfo();
				//clearContainer();
				checkRequest();
			}
		}
		
		/**显示页数**/
		private function showBottomInfo():void
		{
			( main_mc.page_txt as TextField ).text = GameCommonData.wordDic[ "mod_her_med_lea_vie_1" ] + currentPage + "/" + totalPage + GameCommonData.wordDic[ "mod_her_med_lea_vie_2" ];     //第         页
			//( main_mc.page_txt as TextField ).mouseEnabled = false;
		}
		
		/**操作延时器**/
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
		
		/**清楚显示内容**/
		private function clearMe():void
		{
			clearContainer();
			
			if ( panelBase && GameCommonData.GameInstance.GameUI.contains( panelBase ) )
			{
				( main_mc.left_btn as SimpleButton ).removeEventListener( MouseEvent.CLICK,goLeft );
				( main_mc.right_btn as SimpleButton ).removeEventListener( MouseEvent.CLICK,goRight );
				
				panelBase.removeEventListener( Event.CLOSE,panelClosed );
				GameCommonData.GameInstance.GameUI.removeChild( panelBase );
			}
			openState = false;
			
		}
		
		/**关闭窗口**/
		private function panelClosed( evt:Event ):void
		{
			clearContainer();
			
			if ( panelBase && GameCommonData.GameInstance.GameUI.contains( panelBase ) )
			{
				( main_mc.left_btn as SimpleButton ).removeEventListener( MouseEvent.CLICK,goLeft );
				( main_mc.right_btn as SimpleButton ).removeEventListener( MouseEvent.CLICK,goRight );
		
				panelBase.removeEventListener( Event.CLOSE,panelClosed );
				GameCommonData.GameInstance.GameUI.removeChild( panelBase );
			}
			openState = false;

		}
		
		
		
	}
}