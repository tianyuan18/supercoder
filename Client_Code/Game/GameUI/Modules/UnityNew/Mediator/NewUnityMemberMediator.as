package GameUI.Modules.UnityNew.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Chat.Mediator.QuickSelectMediator;
	import GameUI.Modules.Hint.Events.HintEvents;
	import GameUI.Modules.UnityNew.Data.NewUnityCommonData;
	import GameUI.Modules.UnityNew.Net.RequestUnity;
	import GameUI.Modules.UnityNew.Proxy.NewUnityResouce;
	import GameUI.Modules.UnityNew.Proxy.UnityMemberVo;
	import GameUI.Modules.UnityNew.View.IUnityCell;
	import GameUI.Modules.UnityNew.View.SingleHasUnityListCell;
	import GameUI.Modules.UnityNew.View.SingleMemberListCell;
	import GameUI.UIUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	/**
	 * 帮派成员管理页面 标签页1
	 * **/
	public class NewUnityMemberMediator extends Mediator
	{
		public static const NAME:String = "NewUnityMemberMediator";
		
		private var parentContainer:MovieClip;
		private var main_mc:MovieClip;
		private var container:Sprite;
		private var yellowFrame:Shape;
		private var currentPage:int = 1;
		private var totalPage:int = 1;
		private var openState:Boolean = false;
		private var allMembers:Array = [];								//所有的帮派成员
		private var aCurList:Array = [];
		
		private var currentMemberVo:UnityMemberVo;//当前选中成员
		private var getOutTimer:Timer = new Timer(200, 1);	//物品取出计时器
		private var reqestTimer:Timer;									//请求数据计时器
		public static var isRequestState:Boolean = true;					//是否请求数据状态
	//	private var singleMemberListMediator:SingleMemberListMediator;
	//	private var singleContributeMediator:SingleContributeMediator;
	//	private var singleApplyListMediator:SingleApplyListMediator;
		
		public function NewUnityMemberMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super( NAME, viewComponent );
		}
		
		public override function listNotificationInterests():Array
		{
			return [
							NewUnityCommonData.CHANG_NEW_UNITY_PAGE,
							NewUnityCommonData.CLEAR_UNITY_LAST_OPEN_PANEL,
							NewUnityCommonData.RECEIVE_ALL_UNITY_MEMBERS
						];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch ( notification.getName() )
			{
				case NewUnityCommonData.CHANG_NEW_UNITY_PAGE:
					parentContainer = notification.getBody() as MovieClip;
					if ( NewUnityCommonData.currentPage == 3 )
					{
						openMe();
					}
				break;
				case NewUnityCommonData.CLEAR_UNITY_LAST_OPEN_PANEL:
					if ( notification.getBody() == 3 )
					{
						clearMe();
					}
					
				case NewUnityCommonData.RECEIVE_ALL_UNITY_MEMBERS:
					analyData( NewUnityCommonData.allUnityMemberArr );
				break;
			}
		}
		
		private function initView():void
		{
			main_mc = NewUnityResouce.getMovieClipByName("FactionMemberPanel");
			
			container = new Sprite();
			container.x = 19;
			container.y = 45;
			main_mc.addChild( container );
			var mc:DisplayObject=parentContainer.getChildByName("factionTabs");
			main_mc.y=mc.y+23;
			yellowFrame = UIUtils.createFrame( 604,29 );
			
//			singleApplyListMediator = new SingleApplyListMediator();
//			singleMemberListMediator = new SingleMemberListMediator();
//			singleContributeMediator = new SingleContributeMediator();
//			
//			singleMemberListMediator.setViewComponent( this.main_mc );
//			singleApplyListMediator.setViewComponent( this.main_mc );
//			singleContributeMediator.setViewComponent( this.main_mc );
//			changPage();
		}
		
		private function openMe():void
		{
			if ( !main_mc )
			{
				initView();
			}
			
			parentContainer.addChildAt( main_mc,0 );
				
			checkRequest();
			
			( main_mc.left_btn as SimpleButton ).addEventListener( MouseEvent.CLICK,goLeft );
			( main_mc.right_btn as SimpleButton ).addEventListener( MouseEvent.CLICK,goRight );
			( main_mc.apply_btn as SimpleButton).addEventListener(MouseEvent.CLICK,onAppplyHandle);
			( main_mc.appoint_btn as SimpleButton).addEventListener(MouseEvent.CLICK,onAppointHandle);//任命
			( main_mc.delete_btn as SimpleButton).addEventListener(MouseEvent.CLICK,onDeleteMember);//踢出帮派
			( main_mc["show_online_btn"] as MovieClip ).gotoAndStop(2);//只显示在线成员勾选框
			
			UIConstData.FocusIsUsing = true;
			
//			else
//			{
//				sendNotification( NewUnityCommonData.CLICK_MEMBER_PAGE_COME );
//			}
			
//			facade.registerMediator( singleApplyListMediator );
//			facade.registerMediator( singleMemberListMediator );
//			facade.registerMediator( singleContributeMediator );
		
//			changPage();
//			parentContainer.addChildAt( main_mc,0 );
//			for ( var i:uint=0; i<2; i++ )
//			{
//				( main_mc[ "memPage_"+i ] as MovieClip ).buttonMode = true;
//				( main_mc[ "memPage_"+i ] as MovieClip ).addEventListener( MouseEvent.CLICK,onClickPage );
//			}
		}
		
		
		/**打开申请面板**/
		private function onAppplyHandle(evt:MouseEvent):void
		{
			sendNotification(NewUnityCommonData.SHOW_APPLY_LIST_UINTY_NEW);
		}
		
		/**任命**/
		private function onAppointHandle(evt:MouseEvent):void
		{
			if(!currentMemberVo)
			{
				sendNotification(HintEvents.RECEIVEINFO, {info:"请选中要任命的帮派成员", color:0xffff00} );
				return;
			}
			
			if ( !facade.hasMediator( NewUnityOrderMediator.NAME ) )
			{
				facade.registerMediator( new NewUnityOrderMediator() );
			}
			sendNotification( NewUnityCommonData.OPEN_NEW_UNITY_ORDER_PANEL,currentMemberVo );
		}
		
		/**踢出帮派**/
		private function onDeleteMember(evt:MouseEvent):void
		{
			if(!currentMemberVo)
			{
				sendNotification(HintEvents.RECEIVEINFO, {info:"请选中踢出对象", color:0xffff00} );
				return;
			}
		
			if ( currentMemberVo.unityJob >= GameCommonData.Player.Role.unityJob )
			{
				sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_uni_med_alm_agr_1" ], color:0xffff00} );
				return;
			}
			
			var hintInfo:String = "<font color='#e2cca5'>"+GameCommonData.wordDic[ "mod_uni_med_umme_let_1" ] + "<font color='#ffff00'>"+currentMemberVo.name+"</font>"+GameCommonData.wordDic[ "mod_uni_med_umme_let_2" ]+"</font>";
			sendNotification(EventList.SHOWALERT, {comfrim:letOutTrade, cancel:cancelFilter, isShowClose:false, info:hintInfo , 
				title:GameCommonData.wordDic[ "often_used_tip" ], comfirmTxt:GameCommonData.wordDic[ "often_used_commit" ], cancelTxt:GameCommonData.wordDic[ "often_used_cancel2" ] } );
		}
		
		//踢出帮派
		private function letOutTrade():void
		{
			RequestUnity.send( 213,0,currentMemberVo.id );
		}
		
		private function cancelFilter():void
		{
			
		}
		
		//请求数据
		private function checkRequest():void
		{
			if ( isRequestState )
			{
				NewUnityCommonData.allUnityMemberArr = [];
				RequestUnity.send( 301,0 );
				isRequestState = false;
			}
			else
			{
				analyData( NewUnityCommonData.allUnityMemberArr );
			}
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
			//			arr = arr.sortOn( "unityJob",Array.NUMERIC ).reverse();
			for ( var i:uint=0; i<totalPage; i++ )
			{
				this.allMembers[ i ] = arr.slice( i*14,i*14+14 );
			}
			updataMe();
		}
		
		private function updataMe():void
		{

			clearContainer();
			createCells();
			showBottomInfo();
		}
		
		private function clearContainer():void
		{
			var des:*;
			while ( container.numChildren>0 )
			{
				des = container.removeChildAt( 0 );
				if ( des is IUnityCell )
				{
					(des as IUnityCell).gc();
				}
				des = null;
			}
		}
		
		/**创建文本条**/
		private function createCells():void
		{
			this.aCurList = allMembers[ currentPage-1 ].concat();  
			var cell:SingleMemberListCell;
			for ( var k:uint=0; k<aCurList.length; k++ )
			{
				cell = new SingleMemberListCell( aCurList[ k ] );
				cell.init();
				cell.y = 29*k;
				cell.clickMe = clickCell;
				container.addChild( cell );	
			}
		}
		
		
		private function clickCell( cell:SingleMemberListCell ):void
		{
			cell.addChild( yellowFrame );
			currentMemberVo=cell.unityVo;
//			if ( !facade.hasMediator( QuickSelectMediator.NAME ) )
//			{
//				facade.registerMediator( new QuickSelectMediator() );
//			}
//			if ( cell.unityVo.name != GameCommonData.Player.Role.Name )
//			{
//				sendNotification( NewUnityCommonData.SHOW_SINGLE_MEMBLER_SKIRT,cell.unityVo );
//			}
		}
		
		private function goLeft(evt:MouseEvent):void
		{
//			if ( currentPage > 1 )
//			{
//				currentPage --;
//				showBottomInfo();
//				checkRequest();
//			}
		}
		
		private function goRight(evt:MouseEvent):void
		{
//			if ( currentPage < totalPage )
//			{
//				if ( !startTimer() ) return;
//				currentPage ++;
//				showBottomInfo();
//				checkRequest();
//			}
		}
		
		private function clearMe():void
		{
			if ( main_mc && parentContainer.contains( main_mc ) )
			{
				( main_mc.left_btn as SimpleButton ).removeEventListener( MouseEvent.CLICK,goLeft );
				( main_mc.right_btn as SimpleButton ).removeEventListener( MouseEvent.CLICK,goRight );
								
				parentContainer.removeChild( main_mc );
			}
			openState = false;
			UIConstData.FocusIsUsing = false;
		}
		
		private function showBottomInfo():void
		{
			( main_mc.page_txt as TextField ).text = GameCommonData.wordDic[ "mod_her_med_lea_vie_1" ] + currentPage + "/" + totalPage + GameCommonData.wordDic[ "mod_her_med_lea_vie_2" ];     //第         页	
		}
		
		//分析数据
		//		private function analyData( arr:Array ):void
		//		{
		//			this.totalPage = Math.ceil( arr.length/14 );		//总页码
		//			if ( this.totalPage == 0 )
		//			{
		//				totalPage = 1;
		//				return;
		//			}
		//			for ( var i:uint=0; i<totalPage; i++ )
		//			{
		//				this.allUnitys[ i ] = arr.slice( i*14,i*14+14 );
		//			}
		//			this.aCurList = allUnitys[ currentPage-1 ];
		//			updataMe();
		//		}
		
		
//		private function onClickPage( evt:MouseEvent ):void
//		{
//			var index:int = evt.currentTarget.name.split( "_" )[ 1 ];
//			if ( NewUnityCommonData.currentMemPage == index )
//			{
//				return;
//			}
//			sendNotification( NewUnityCommonData.CLEAR_MEMBER_PAGE_GO,NewUnityCommonData.currentMemPage );
//			NewUnityCommonData.currentMemPage = index;
//			changPage();
//		}
		
//		private function changPage():void
//		{
//			for ( var i:uint=0; i<2; i++ )
//			{
//				( main_mc[ "memPage_"+i ] as MovieClip ).gotoAndStop( 2 );
//			}
//			main_mc[ "memPage_" + NewUnityCommonData.currentMemPage ].gotoAndStop( 1 ); 
//			main_mc.gotoAndStop( NewUnityCommonData.currentMemPage + 1 );
//			
//			sendNotification( NewUnityCommonData.CLICK_MEMBER_PAGE_COME );
//		}
		
//		private function clearMe():void
//		{
//			if ( main_mc && parentContainer.contains( main_mc ) )
//			{
////				for ( var i:uint=0; i<2; i++ )
////				{
////					( main_mc[ "memPage_"+i ] as MovieClip ).removeEventListener( MouseEvent.CLICK,onClickPage );
////				}
//				
//				sendNotification( NewUnityCommonData.CLEAR_MEMBER_PAGE_GO,NewUnityCommonData.currentMemPage );		//清理当前面板
//				parentContainer.removeChild( main_mc );
//				
//	//			facade.removeMediator( SingleApplyListMediator.NAME );
//				facade.removeMediator( SingleMemberListMediator.NAME );
//	//			facade.removeMediator( SingleContributeMediator.NAME );
//			}
//		}
		
	}
}