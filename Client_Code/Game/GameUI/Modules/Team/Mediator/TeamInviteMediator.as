package GameUI.Modules.Team.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.Modules.Hint.Events.HintEvents;
	import GameUI.Modules.PlayerInfo.Command.PlayerInfoComList;
	import GameUI.Modules.Team.Datas.TeamDataProxy;
	import GameUI.Modules.Team.Datas.TeamEvent;
	import GameUI.Modules.Team.Datas.TeamNetAction;
	import GameUI.Modules.Team.UI.TeamItem;
	import GameUI.Proxy.DataProxy;
	import GameUI.View.BaseUI.PanelBase;
	import GameUI.View.items.FaceItem;
	
	import Net.ActionProcessor.TeamAction;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.controls.Alert;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class TeamInviteMediator extends Mediator
	{
		public static const NAME:String = "TeamInviteMediator";
		public static const TEAMINVITE_POS:Point = new Point(600, 95);
		public static const ITEMSTART_POS:Point  = new Point(8.5, 30);
		
		private var teamDataProxy:TeamDataProxy = null;
		private var invitePanel:PanelBase = null;
		private var dataProxy:DataProxy = null;
		
		public function TeamInviteMediator()
		{
			super(NAME);
		}
		
		private function get teamInvite():MovieClip
		{
			return viewComponent as MovieClip;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				TeamEvent.SHOWINVITE,			//显示邀请界面
				TeamEvent.SHOWINVITETEAMINFO,	//显示邀请的队伍信息
				TeamEvent.REMOVEINVITE,			//移除邀请界面
				TeamEvent.INVITEINIT,			//打开面板
				TeamEvent.INIT_INVITE_PANEL		//初始化邀请面板 (8.26)
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case TeamEvent.INIT_INVITE_PANEL:
					dataProxy = facade.retrieveProxy(DataProxy.NAME) as DataProxy;
					teamDataProxy = facade.retrieveProxy(TeamDataProxy.NAME) as TeamDataProxy;
					break;
				case TeamEvent.INVITEINIT:
					showView();
					break;
				case TeamEvent.SHOWINVITE:
					break;
				case TeamEvent.REMOVEINVITE:
					break;
				case TeamEvent.SHOWINVITETEAMINFO:
					break;
			}
		}
		/**
		 * 当前窗口类型。
		 * 0：邀请我的队伍
		 * 1：申请进入我队伍 
		 */		
		private var type:int = 0;
		private var _currnetData:Object;
		private function showView():void{
			var playerName:String = "";
			var actionName:String = "";
			var hasTrue:Boolean = false;
			var useData:Object;
			if(teamDataProxy.inviteIdList.length > 0){//不是队长，并且没有队伍。被人邀请我加入的队伍信息列表
				type = 0;
				actionName = "邀请你加入队伍";
				hasTrue = true;
				useData = teamDataProxy.inviteIdList[0];
				teamDataProxy.inviteIdList.shift();
			}else if(teamDataProxy.inviteMemList.length > 0){//队长，别人申请加入队伍信息列表
				type =1;
				actionName = "申请加入队伍";
				hasTrue = true;
				useData = teamDataProxy.inviteMemList[0];
				teamDataProxy.inviteMemList.shift();
			}
			if(!hasTrue)
				return;
			_currnetData = useData;
			playerName = useData.szPlayerName;
			
			var infoTxt:String = "<P ALIGN='CENTER'><FONT FACE='SimSun' SIZE='13' COLOR='#00CC00' LETTERSPACING='0' KERNING='1'><U><A HREF='event:"+useData.idPlayer+"' TARGET=''>"+playerName+"</A></U>"
								  +"</FONT><FONT FACE='SimSun' SIZE='13' COLOR='#cccccc' LETTERSPACING='0' KERNING='1'>"+actionName+"</FONT></P>";
			facade.sendNotification(EventList.SHOWALERT,{
				comfrim:comfirmEvent, 
				cancel:cancelEvent, 
				extendsFn:extendsEvent,
				linkFn:linkEvent,
				info:infoTxt,
				htmlText:true, 
				comfirmTxt:"同意", 
				cancelTxt:"取消",
				isShowClose:false});
			teamDataProxy.inviteIsOpen = true;
			isSend = false;
		}
		
		private var isSend:Boolean = false;//是否发送了数据
		private function comfirmEvent():void{
			teamDataProxy.inviteIsOpen = false;
			teamDataProxy.palyerId = _currnetData.idPlayer;
			if(type == 0)//同意邀请
				teamDataProxy.sendData(TeamAction._MSGTEAM_ACCEPTINVITE);
			else//同意申请
				teamDataProxy.sendData(TeamAction._MSGTEAM_AGREEJOIN);
			isSend = true;
		}
		
		private function cancelEvent():void{
			teamDataProxy.inviteIsOpen = false;
			teamDataProxy.palyerId = _currnetData.idPlayer;
			teamDataProxy.playerName = _currnetData.szPlayerName;
			if(type == 0)//拒绝邀请
				teamDataProxy.sendData(TeamAction._MSGTEAM_DENY_INVITE);
			else//拒绝申请
				teamDataProxy.sendData(TeamAction._MSGTEAM_DENY_APPLY);
				
			isSend = true;
		}
		
		private function extendsEvent():void{
			if(!isSend)//如果直接关闭窗口，没有发送数据，那么发送拒绝数据
				cancelEvent();
			showView();
		}
		private function linkEvent(text:String):void{
			facade.sendNotification(PlayerInfoComList.QUERY_PLAYER_DETAILINFO,{id:text});
		}
	}
}
