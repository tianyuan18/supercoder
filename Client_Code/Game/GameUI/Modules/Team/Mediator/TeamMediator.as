package GameUI.Modules.Team.Mediator
{
	import Controller.PlayerController;
	import Controller.TargetController;
	
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Friend.command.FriendCommandList;
	import GameUI.Modules.GmTools.Utils.LoadSwfTool;
	import GameUI.Modules.Hint.Events.HintEvents;
	import GameUI.Modules.Icon.Data.IconData;
	import GameUI.Modules.PlayerInfo.Command.PlayerInfoComList;
	import GameUI.Modules.Stall.Data.StallConstData;
	import GameUI.Modules.Team.Command.TeamCommandList;
	import GameUI.Modules.Team.Datas.TeamDataProxy;
	import GameUI.Modules.Team.Datas.TeamEvent;
	import GameUI.Modules.Team.Datas.TeamNetAction;
	import GameUI.Modules.Team.UI.CellRenderer;
	import GameUI.Modules.Team.UI.TeamItem;
	import GameUI.Modules.Team.UI.TeamModelManager;
	import GameUI.Modules.Team.UI.UITeamContainer;
	import GameUI.Modules.Team.UI.UIUserContainer;
	import GameUI.Proxy.DataProxy;
	import GameUI.UIConfigData;
	import GameUI.UICore.UIFacade;
	import GameUI.View.BaseUI.ListComponent;
	import GameUI.View.BaseUI.PanelBase;
	import GameUI.View.Components.UIScrollPane;
	import GameUI.View.ResourcesFactory;
	import GameUI.View.items.FaceItem;
	
	import Net.ActionProcessor.TeamAction;
	
	import OopsEngine.Graphics.Font;
	import OopsEngine.Scene.StrategyElement.GameElementAnimal;
	import OopsEngine.Utils.MovieAnimation;
	
	import OopsFramework.GameTime;
	import OopsFramework.IUpdateable;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	/**
	 * 组队UI管理器
	 * @author:Ginoo
	 * @date:5/24/2010
	 */
	public class TeamMediator extends Mediator
	{	
		public static const NAME:String = "TeamMediator";
		public static const TEAMITEM_STARTPOS:Point = new Point(9.3, 28);			/** 队员组件开始坐标 */
		public static const TEAMREQLITEM_STARTPOS:Point = new Point(179.3, 28);
		
		
		private var dataProxy:DataProxy;
		private var teamDataProxy:TeamDataProxy;
		
		private var panelBase:PanelBase = null;							/** 组队UI基面板 */
		
		private var notiData:Object = new Object();						/** 消息数据 */
		private var inviteDataArr:Array = new Array();					/** 某队员邀请某玩家的数据 队列 */
		private var inviteData:Object = new Object();					/** 某队员邀请某玩家的数据 */
		private var joinPlayerName:String = "";							/** 新加入的玩家名字 */
		
		private var userArray:Array = [];
		private var teamArray:Array = [];
		
		private var isUserFreshed:Boolean = false;
		private var isTeamFreshed:Boolean = false;
		
		private var sendDataListGapTime:int = 2000;//请求数据的时间间隔 单位：毫秒
		private var timer:Timer;	
		
		private var animals:Array = new Array();
		public function TeamMediator()
		{
			super(NAME);
		}
		
		private function get teamView():MovieClip
		{
			return viewComponent as MovieClip;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				EventList.INITVIEW,					//加载资源
				EventList.SHOWTEAM,					//显示组队界面，在主界面点击“组队”时立刻显示组队面板，然后在此处请求服务器，同时显示lodgingMC，禁用UI上的按钮等，等服务器返回数据给我后，我这边移除loadingMC，更新画面数据，放开UI上的按钮等。
				EventList.UPDATETEAM,				//收到服务器返回的数据，更新界面数据
				EventList.ASKTEAMINFO,				//收到服务器命令，向服务器发送请求获取数据

				TeamEvent.HAVAINVITE,				//受到邀请
				TeamEvent.INVITETEAMBYNAME,			//邀请组队，对外接口，用名字查询
				EventList.MEMBER_ONLINE_STATUS_TEAM,	//更新队员在线状态 
				TeamEvent.MEMBERINVITESOMEONE,		//某个队员邀请了某人，此时自己是队长
				EventList.REMOVETEAM,				//删除组队界面				
				
				TeamEvent.SHOWTEAMINFORMATION,		//显示组队相关的提示信息
				
				TeamEvent.SUPER_MAKE_TEAM,			//超级组队模式，根据对方ID
				TeamEvent.SUPER_MAKE_TEAM_BY_NAME,	//超级组队模式，根据对方名字
				EventList.APPLYTEAM,				//申请入队，对外的接口
				EventList.INVITETEAM,				//邀请入队，对外的接口
				EventList.LEAVETEAMCOMMON,			//离开队伍，对外的接口
				EventList.KICKOUTTEAMCOMMON,		//踢出队伍，对外的接口
				EventList.CHANGELEADERTEAMCOMMON,	//移交队长，对外的接口
				EventList.SETUPTEAMCOMMON,			//建立队伍，对外的接口

				TeamEvent.LEAVE_TEAM_AFTER_CHANGE_LINE,	//换线成功，客户端自己清除组队数据				
				TeamCommandList.UPDATE_USER_LIST,	//更新附近用户列表
				TeamCommandList.UPDATE_TEAM_LIST	//更新附近队伍列表
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case EventList.INITVIEW:													//初始化
					//facade.sendNotification(EventList.GETRESOURCE, {type:UIConfigData.MOVIECLIP, mediator:this, name:UIConfigData.TEAM});
					dataProxy = facade.retrieveProxy(DataProxy.NAME) as DataProxy;
					teamDataProxy = new TeamDataProxy();
					facade.registerProxy(teamDataProxy);
					facade.registerMediator(new TeamInviteMediator());
					sendNotification(TeamEvent.INIT_INVITE_PANEL);	//初始化邀请面板
					break;
				case EventList.SHOWTEAM:
					dataProxy.TeamIsOpen = true;
					loadTeamView();
					break;
				case TeamCommandList.UPDATE_USER_LIST:
					if(isSendPalyer){
						userArray = [];
						isSendPalyer = false;
					}
					var userInfo:Object = notification.getBody();
					userArray.push(userInfo);
					showPlayerList();
					break;
				case TeamCommandList.UPDATE_TEAM_LIST:
					if(isSendTeam){
						teamArray = [];
						isSendTeam = false;
					}
					
					var teamObj:Object = notification.getBody();
					teamArray.push(teamObj);
					showTeamList();
					break;
				case TeamEvent.SHOWTEAMINFORMATION:
					var infoObj:Object = notification.getBody();
					teamDataProxy.showTeamInformation(infoObj);
					break;
				case EventList.SETUPTEAMCOMMON://建立队伍
					teamDataProxy.sendData(TeamAction._MSGTEAM_CREATE);
					break;
				case EventList.LEAVETEAMCOMMON:					//离开队伍，对外的接口
					sendNotification(TeamEvent.SHOWTEAMINFORMATION, {type:3});
					teamDataProxy.sendData(TeamAction._MSGTEAM_LEAVE);
					
					teamDataProxy.teamMemberList = [];
					dataProxy.isTeamLeader = false;
					dataProxy.isTeamMember = false;
					initMyTeamInfo();
					//功能未实现。不知道干什么的。
					sendNotification(PlayerInfoComList.MSG_LEAVE_TEAM);	//通知主界面 清除队伍坐标列表
					break;	
				case EventList.KICKOUTTEAMCOMMON:				//踢出队伍，对外的接口
					notiData = notification.getBody();
					teamDataProxy.palyerId = notiData.id;
					teamDataProxy.sendData(TeamAction._MSGTEAM_KICKOUT);
					break;
				case EventList.UPDATETEAM://队伍信息更新
					var teamInfo:Object = notification.getBody();
					teamDataProxy.teamMemberList = teamInfo.teamMemList;
					
					var isMember:Boolean = false;//是否存在组队
					var isLeader:Boolean = false;//是否是队长
					for(var i:int = 0; i < teamDataProxy.teamMemberList.length; i++) {		//通知聊天栏，增加或删除组队栏目
						if(teamDataProxy.teamMemberList[i] && teamDataProxy.teamMemberList[i].id && teamDataProxy.teamMemberList[i].id == GameCommonData.Player.Role.Id) {
							isMember = true;
							if(i == 0) isLeader = true;
							break;
						}
					}
					if(isMember) {				//在队伍中
						if(isLeader) {			//是队长	
							GameCommonData.Player.SetTeamLeader(true);
							GameCommonData.Player.SetTeam(false);
						} else {				//是队员
							GameCommonData.Player.SetTeamLeader(false);
							GameCommonData.Player.SetTeam(true);
						}
					}
					sendNotification(EventList.HASTEAM, isMember);
					dataProxy.isTeamMember = isMember;
					dataProxy.isTeamLeader = isLeader;
					
					initMyTeamInfo();//更新我的队伍信息
					break;
				case EventList.ASKTEAMINFO:					//向服务器查询组队详细信息
					var oB:Object = notification.getBody();
					if(oB.unAction == TeamAction._MSGTEAM_TARGET_INTEAM && teamDataProxy.isInviting) {
						return;
					}
					teamDataProxy.isInviting = false;
					
					if(oB.unAction == TeamAction._MSGTEAM_JOINTEAM) {
						joinPlayerName = String(oB.szPlayerName);
					} else if(oB.unAction == TeamAction._MSGTEAM_AGREEJOIN) {
						joinPlayerName = GameCommonData.Player.Role.Name;
					}
					
					if(dataProxy.TeamIsOpen) {
						//teamModelManager.setModel(0);
					} else if(oB.unAction == TeamAction._MSGTEAM_APPLYJOIN) {//有人申请
						if(teamDataProxy.teamMemberList[0] && teamDataProxy.teamMemberList[0].id == GameCommonData.Player.Role.Id) {//自己是队长
							if(UIConstData.AUTO_ACCEPT_TEAM_INTITE_AND_APPLY) {	//挂机中 自动接受申请和邀请
								TeamNetAction.sendTeamOrder(TeamAction._MSGTEAM_AGREEJOIN, oB.idPlayer);
							} else {
								teamDataProxy.addApplyPlayer(oB);
								sendNotification(IconData.SHOW_ICON, {index:2, message:"zhudui"});
								sendNotification(TeamEvent.SHOWTEAMINFORMATION, {type:16});
							}
						}
					} else if(oB.unAction == TeamAction._MSGTEAM_INVITE) {	//有人邀请自己
						teamDataProxy.isInviting = true;
						sendNotification(IconData.SHOW_ICON, {index:2, message:"zhudui"});
					}
					teamDataProxy.sendData(TeamAction._MSGTEAM_ASKINFO); 
					
					break;
				case EventList.APPLYTEAM://申请入队
					var data:Object = notification.getBody();
					teamDataProxy.palyerId = data.id;
					teamDataProxy.sendData(TeamAction._MSGTEAM_APPLYJOIN);
					break;
				case EventList.INVITETEAM://邀请如队伍
					var inviteData:Object = notification.getBody();
					teamDataProxy.palyerId = inviteData.id;
					teamDataProxy.sendData(TeamAction._MSGTEAM_INVITE);
					break;
				case TeamEvent.HAVAINVITE:
					var inviteObj:Object = notification.getBody();
					if(UIConstData.AUTO_ACCEPT_TEAM_INTITE_AND_APPLY) {		//挂机 自动接受邀请
						TeamNetAction.sendTeamOrder(TeamAction._MSGTEAM_ACCEPTINVITE, inviteObj.idPlayer, 0, "");
					} else {
						teamDataProxy.isInviting = true;
						teamDataProxy.addInvitePlayer(inviteObj);
						sendNotification(IconData.SHOW_ICON, {index:2, message:"zhudui"});
					}
					break;
				case EventList.MEMBER_ONLINE_STATUS_TEAM:			//更新队员在线状态     新功能
					if(UIConstData.AUTO_KICKOUT_LEAVE_MEMBER) {	//挂机 自动踢出离线队员
						var stateData:Object = notification.getBody();
						var state:uint = stateData.state;
						if(state == 0) {
							if(GameCommonData.Player.Role.idTeamLeader > 0 && GameCommonData.Player.Role.idTeamLeader == GameCommonData.Player.Role.Id) {
								TeamNetAction.sendTeamOrder(TeamAction._MSGTEAM_KICKOUT, stateData.id);
								return;
							}
						}
					}
					teamDataProxy.updateMemOnlineState(notification.getBody());
					break;
				case EventList.CHANGELEADERTEAMCOMMON:			//移交队长，对外的接口
					notiData = notification.getBody();
					teamDataProxy.palyerId = notiData.id;
					teamDataProxy.sendData(TeamAction._MSGTEAM_CHG_LEADER_APPLY);
					break;
				case EventList.REMOVETEAM:													//删除组队面板
					panelCloseHandler(null);
					break;

			}
		}
		
		private var loadswfTool:LoadSwfTool;
		private function loadTeamView():void{
			if(teamView == null){
				loadswfTool = new LoadSwfTool(GameConfigData.NewTeamUI , this);
				loadswfTool.sendShow = initView;
			}else{
				showTeamView();
			}
		}
		
		/**
		 * 初始化页面，只会初始化一次。 
		 * @param mc
		 */		
		private function initView(mc:MovieClip):void{
			this.setViewComponent(loadswfTool.GetResource().GetClassByMovieClip("MainTeamView"));
			
			
			panelBase = new PanelBase(teamView, teamView.width+8, teamView.height+12);
			panelBase.name = "TeamView";
			panelBase.SetTitleMc(this.loadswfTool.GetResource().GetClassByMovieClip("TeamIcon"));
			panelBase.SetTitleDesign();
			
			
			(teamView.teamTypeBtn as MovieClip).addEventListener(MouseEvent.CLICK,showTypeViewEvent);
			(teamView.teamTypeBtn as MovieClip).addEventListener(MouseEvent.MOUSE_MOVE,typeBtnMoveEvent);
			(teamView.teamTypeBtn as MovieClip).addEventListener(MouseEvent.MOUSE_OUT,typeBtnOutEvent);
			
			(teamView.playerTypeBtn as MovieClip).addEventListener(MouseEvent.CLICK,showTypeViewEvent);
			(teamView.playerTypeBtn as MovieClip).addEventListener(MouseEvent.MOUSE_MOVE,typeBtnMoveEvent);
			(teamView.playerTypeBtn as MovieClip).addEventListener(MouseEvent.MOUSE_OUT,typeBtnOutEvent);
			
			(teamView.playerTypeBtn as MovieClip).mouseChildren = (teamView.teamTypeBtn as MovieClip).mouseChildren = false;
			(teamView.invtaPlayCk as MovieClip).buttonMode = (teamView.inTeamCk as MovieClip).buttonMode = (teamView.playerTypeBtn as MovieClip).buttonMode = (teamView.teamTypeBtn as MovieClip).buttonMode = true;
			
			teamView.addEventListener(TextEvent.LINK,textLinkEvent);
			
			teamView.refresBtn.addEventListener(MouseEvent.CLICK,refresListEvent);
			teamView.firstBtn.addEventListener(MouseEvent.CLICK,changePageEvent);
			teamView.endBtn.addEventListener(MouseEvent.CLICK,changePageEvent);
			teamView.upBtn.addEventListener(MouseEvent.CLICK,changePageEvent);
			teamView.downBtn.addEventListener(MouseEvent.CLICK,changePageEvent);
			teamView.leavaTeamBtn.addEventListener(MouseEvent.CLICK,leavaTeamEvent);
			teamView.createTeamBtn.addEventListener(MouseEvent.CLICK,createTeamEvent);
			
			
			panelBase.addEventListener(Event.CLOSE, panelCloseHandler);
			
			showTeamView();
		}

		/**
		 * 显示队伍面板 
		 */		
		private function showTeamView():void{
			var p:Point = UIConstData.getPos(panelBase.width,panelBase.height);
			panelBase.x = p.x;
			panelBase.y = p.y;
			
			GameCommonData.GameInstance.GameUI.addChild(panelBase); 
			_currnetType = 0;//默认显示附近队伍
			initMyTeamInfo();
			changShowTypeBtnStatus();
			reShowList();
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER,runTimerEvent);
		}
		
		/**
		 * 选择显示不同的类型 
		 * @param e
		 */		
		private function showTypeViewEvent(e:MouseEvent):void{
			if(e.target == teamView.playerTypeBtn)
				_currnetType = 1;
			else
				_currnetType = 0;
			
			changShowTypeBtnStatus();
			currnetPage = 1;
			reShowList();
		}
		
		private var teamTime:Number = 0;//记录上次刷新队伍的时间
		private var playerTime:Number = 0;//记录上次刷新附近玩家的时间
		
		
		/**
		 * 当前选择的显示类型 0：附近的队伍  1：附近的玩家 
		 */		
		private var _currnetType:int = 0;
		/**
		 * 改变按钮的选择状态 
		 */		
		private function changShowTypeBtnStatus():void{
			if(_currnetType == 0){
				(teamView.teamTypeBtn as MovieClip).gotoAndStop(3);
				(teamView.playerTypeBtn as MovieClip).gotoAndStop(1);
				if(teamTime == 0){
					teamTime = new Date().time - sendDataListGapTime-1;
				}
			}else{
				(teamView.teamTypeBtn as MovieClip).gotoAndStop(1);
				(teamView.playerTypeBtn as MovieClip).gotoAndStop(3);
				if(teamTime == 0){
					playerTime = new Date().time - sendDataListGapTime-1;
				}
			}
			sendGetDataList();
		}
		/**
		 * 鼠标移动上去的效果该表 
		 * @param e
		 */		
		private function typeBtnMoveEvent(e:MouseEvent):void{
			if(e.target == teamView.playerTypeBtn){
				(teamView.playerTypeBtn as MovieClip).gotoAndStop(3);
			}else{
				(teamView.teamTypeBtn as MovieClip).gotoAndStop(3);
			}
		}
		/**
		 * 鼠标离开上去的效果改变
		 * @param e
		 */	
		private function typeBtnOutEvent(e:MouseEvent):void{
			changShowTypeBtnStatus();
		}
		
		private var isSendTeam:Boolean = false;
		private var isSendPalyer:Boolean = false;
		/**
		 * 发送获取当前显示对象数据(统一使用此接口)
		 */		
		private function sendGetDataList():void{
			var currnetTime:Number = new Date().time;
			if(_currnetType == 0){
				if((currnetTime - teamTime) > this.sendDataListGapTime){
					teamTime = currnetTime;
					isSendTeam = true;
					TeamNetAction.sendTeamOrder(TeamAction._MSGTEAM_TEAM_NEARBY);
				}
			}else{
				if((currnetTime - playerTime) > this.sendDataListGapTime){
					playerTime = currnetTime;
					isSendPalyer = true;
					TeamNetAction.sendTeamOrder(TeamAction._MSGTEAM_USER_NEARBY);
				}
			}
		}
		//定数刷新数据显示
		private function runTimerEvent(event:TimerEvent):void{
			sendGetDataList();
		}
		
		/**
		 * 显示物件列表 
		 */		
		private function showPlayerList():void{
			reShowList();
		}
		/**
		 * 显示队伍列表 
		 */		
		private function showTeamList():void{
			reShowList();
		}
		
		/**
		 * 离开队伍 
		 * @param e
		 */		
		private function leavaTeamEvent(e:MouseEvent):void{
			facade.sendNotification(EventList.LEAVETEAMCOMMON);
		}
		
		/**
		 * 创建队伍 
		 * @param e
		 */		
		private function createTeamEvent(e:MouseEvent):void{
			facade.sendNotification(EventList.SETUPTEAMCOMMON);
		}
		/**
		 * 刷新 
		 * @param e
		 */		
		private function refresListEvent(e:MouseEvent):void{
			sendGetDataList();
		}
		private var currnetPage:int = 1;//当前页
		private var maxPage:int = 1;//总页数
		private const pageNum:int = 8;//每页显示的数量
		/**
		 * 翻页相关操作  
		 * @param e
		 */		
		private function changePageEvent(e:MouseEvent):void{
			var name:String = e.target.name;
			var tmpPage:int = 0;
			switch(name){
				case "firstBtn":
					tmpPage 1;
					break;
				case "endBtn":
					tmpPage = maxPage;
					break;
				case "upBtn":
					tmpPage = currnetPage - 1;
					if(tmpPage < 1){
						tmpPage = 1;
					}
					break;
				case "downBtn":
					tmpPage = currnetPage + 1;
					if(tmpPage > maxPage){
						tmpPage = maxPage;
					}
					break;
			}
			if(tmpPage != currnetPage)
				reShowList();
		}
		/**
		 * 改变翻页显示 
		 */		
		private function changePageInfoTxt():void{
			teamView.pageInfoTxt.text = currnetPage+" / "+maxPage;
		}
		/**
		 * 刷新显示
		 */			
		private function reShowList():void{
			var dataList:Array;
			if(_currnetType == 0){
				dataList = this.teamArray;
				teamView.typeInfoTxt.text = "附近的队伍数量："+dataList.length;
			}else{
				dataList = this.userArray;
				teamView.typeInfoTxt.text = "附近的玩家数量："+dataList.length;;
			}
			
			for (var i:int = 0; i < pageNum; i++) 
			{
				var index:int = (currnetPage - 1)*pageNum+i;
				var mc:MovieClip = teamView["item_"+i];
				if(index < dataList.length){
					var data:Object = dataList[index];
					if(mc.iconMc.getChildByName("Face") != null)
						(mc.iconMc as MovieClip).removeChildAt(0);
					var face:FaceItem = new FaceItem(String(data.usPro),null,"Face");
					face.setImageScale(28,28);
					(mc.iconMc as MovieClip).addChild(face);
					mc.nameTxt.text = data.szPlayerName;
					var jobName:String = GameCommonData.wordDic[ "often_used_"+data.usPro];
					if(jobName == null)
						jobName = data.usPro;
					mc.jobNameTxt.text = jobName; 
					mc.lvTxt.text = data.usLev;
					if(_currnetType == 0){
						mc.statusTxt.htmlText = "<P ALIGN='LEFT'><U><FONT FACE='SimSun' SIZE='13' COLOR='#00CC00' LETTERSPACING='0' KERNING='1'><A HREF='event:0_"+data.idPlayer+"' TARGET=''>加入</A></FONT></U></P>";
					}else{ 
						mc.statusTxt.htmlText = "<P ALIGN='LEFT'><U><FONT FACE='SimSun' SIZE='13' COLOR='#00CC00' LETTERSPACING='0' KERNING='1'><A HREF='event:1_"+data.idPlayer+"' TARGET=''>邀请</A></FONT></U></P>";
					}
					mc.visible = true;
				}else{
					mc.visible = false;
				}
			}
			changePageInfoTxt();
		}
		
		
		/**
		 * 初始化我的队伍 
		 */		
		private function initMyTeamInfo():void{
			var isCaptain:Boolean = false;//自己是不是队长
			var teamDic:Dictionary = new Dictionary(false);
			
			for (var i:int = 0; i < 5; i++) 
			{
				var mc:MovieClip;
				if(teamView)//页面没有初始化。数据需要存在
					mc = teamView["teamItem_"+i];
				if(i < teamDataProxy.teamMemberList.length){
					var data:Object = teamDataProxy.teamMemberList[i];
					i == 0 ? teamDic[data.id] ={isCaption:true, id:data.id, state:data.onlineStatus} : teamDic[data.id] ={isCaption:false, id:data.id, state:data.onlineStatus};
					
					if(!teamView)//页面没有初始化。数据需要存在
						continue;
					
					if(mc.iconMc.getChildByName("Face") != null)
						(mc.iconMc as MovieClip).removeChildAt(0);
					var face:FaceItem = new FaceItem(String(data.usPro),null,"Face");
					face.setImageScale(28,28);
					(mc.iconMc as MovieClip).addChild(face);
					mc.nameTxt.text = data.szName;
					mc.jobNameTxt.text = GameCommonData.wordDic[ "often_used_"+data.usPro]; 
					mc.lvTxt.text = data.usLev;
					if(i == 0){//第一位数据是队长。
						if(data.id == GameCommonData.Player.Role.Id){
							isCaptain = true;//标记自己是队长
						}
						mc.captainIcon.visible = true;
					}else{//如果自己不是队长。
						mc.captainIcon.visible = false;
					}
					
					if(isCaptain){//如果自己是队长。所有人显示可以踢出
						mc.statusTxt.htmlText = "<P ALIGN='LEFT'><U><FONT FACE='SimSun' SIZE='13' COLOR='#00CC00' LETTERSPACING='0' KERNING='1'><A HREF='event:2_"+data.id+"' TARGET=''>踢出</A></FONT></U></P>";
					}else{
						mc.statusTxt.htmlText = "<P ALIGN='LEFT'><U><FONT FACE='SimSun' SIZE='13' COLOR='#00CC00' LETTERSPACING='0' KERNING='1'><A HREF='event:"+data.id+"' TARGET=''></A></FONT></U></P>";
					}
					
					if(data.id == GameCommonData.Player.Role.Id){//自己，显示离队的操作
						mc.statusTxt.htmlText = "<P ALIGN='LEFT'><U><FONT FACE='SimSun' SIZE='13' COLOR='#00CC00' LETTERSPACING='0' KERNING='1'><A HREF='event:3_"+data.id+"' TARGET=''>离队</A></FONT></U></P>";
					}
					mc.visible = true;
				}else{
					if(mc)
						mc.visible = false;
				}
			}
			GameCommonData.TeamPlayerList = teamDic;
			teamDataProxy.notiFan();
		}
		
		private function textLinkEvent(e:TextEvent):void{
			var value:Array = e.text.split("_");
			var playerId:int = int(value[1]);
			var data:Object;
			switch(int(value[0])){
				case 0://加入队伍
					data = {id:playerId};
					facade.sendNotification(EventList.APPLYTEAM,data);
				break;
				case 1://邀请入队
					data = {id:playerId};
					facade.sendNotification(EventList.INVITETEAM,data);
				break;
				case 2://踢出队伍
					data = {id:playerId};
					facade.sendNotification(EventList.KICKOUTTEAMCOMMON,data);
				break;
				case 3://离开队伍
					facade.sendNotification(EventList.LEAVETEAMCOMMON);
				break;
			}
		}
		
		/** 自动踢出离线玩家 */
		public function autoKickOutLevMem():void
		{
			if(GameCommonData.Player.Role.idTeamLeader > 0 && GameCommonData.Player.Role.idTeamLeader == GameCommonData.Player.Role.Id) {
				for(var i:int = 0; i < teamDataProxy.teamMemberList.length; i++) {
					var mem:Object = teamDataProxy.teamMemberList[i];
					if(mem.onlineStatus == 0) {
						TeamNetAction.sendTeamOrder(TeamAction._MSGTEAM_KICKOUT, mem.id);
					}
				}
			}
		}
		
		//关闭页面时候，回收不要的资源
		private function gc():void{
			timer.removeEventListener(TimerEvent.TIMER,runTimerEvent);
			timer = null;
		}
		private function panelCloseHandler(e:Event):void{
			gc();
			GameCommonData.GameInstance.GameUI.removeChild(panelBase); 
			dataProxy.TeamIsOpen = false;
		}
	}
}
