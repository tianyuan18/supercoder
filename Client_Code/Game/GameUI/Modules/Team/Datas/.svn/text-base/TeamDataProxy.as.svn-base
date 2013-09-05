package GameUI.Modules.Team.Datas
{
	
	import GameUI.ConstData.EventList;
	import GameUI.Modules.Hint.Events.HintEvents;
	import GameUI.Modules.PlayerInfo.Command.PlayerInfoComList;
	import GameUI.UICore.UIFacade;
	
	import Net.ActionProcessor.TeamAction;
	
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	public class TeamDataProxy extends Proxy
	{
		public static const NAME:String = "TeamDataProxy";
		
		public function TeamDataProxy()
		{
			super(NAME, data);
		}
		//------------------------发送需要数据
		public var palyerId:int = 0;//当前申请加入队伍的队长ID
		public var playerName:String = "";
		//-----------------------
		/**
		 * 邀请队伍信息面板是否打开 
		 */		
		public var inviteIsOpen:Boolean = false;
		
		
		/**
		 * 是否正在被邀请
		 */		
		public var isInviting:Boolean = false;
		/**
		 * 我所在队伍 的成员列表
		 */		
		public var teamMemberList:Array = [];
		
		/**
		 * 邀请我的队伍信息列表 
		 */		
		public var inviteIdList:Array = [];
		
		/**
		 * 向我队伍申请入队的人员列表 
		 */		
		public var inviteMemList:Array = [];
		
		
		/** 队伍坐标信息*/
		public static var teamDataDic:Dictionary=new Dictionary(true);
		
		
		/** 发命令到Sever */
		public function sendData(action:int):void
		{
			switch(action) {
				case TeamAction._MSGTEAM_CREATE:																//建立队伍
					TeamNetAction.sendTeamOrder(TeamAction._MSGTEAM_CREATE, GameCommonData.Player.Role.Id);
					break;
				case TeamAction._MSGTEAM_ASKINFO:															//查询队伍详细信息
					if(GameCommonData.Player && GameCommonData.Player.Role && GameCommonData.Player.Role.Id) 
						TeamNetAction.sendTeamOrder(TeamAction._MSGTEAM_ASKINFO, GameCommonData.Player.Role.Id);
					break;
				case TeamAction._MSGTEAM_KICKOUT:																//移除队员
					TeamNetAction.sendTeamOrder(TeamAction._MSGTEAM_KICKOUT, palyerId);
					break;
				case TeamAction._MSGTEAM_CHG_LEADER_APPLY:														//转交队长
					TeamNetAction.sendTeamOrder(TeamAction._MSGTEAM_CHG_LEADER_APPLY, palyerId);
					break;
				case TeamAction._MSGTEAM_LEAVE:																	//退出队伍
					TeamNetAction.sendTeamOrder(TeamAction._MSGTEAM_LEAVE, GameCommonData.Player.Role.Id);
					if(teamMemberList[0] && teamMemberList[0].id == GameCommonData.Player.Role.Id) {
						GameCommonData.Player.SetTeamLeader(false);
					} else {
						GameCommonData.Player.SetTeam(false);
					}
					GameCommonData.TeamPlayerList = new Dictionary();
					notiFan();
					break;
				case TeamAction._MSGTEAM_AGREEJOIN:																//同意申请
					TeamNetAction.sendTeamOrder(TeamAction._MSGTEAM_AGREEJOIN, palyerId);
					break;
				case TeamAction._MSGTEAM_DENY_APPLY:															//拒绝申请
					sendNotification(TeamEvent.SHOWTEAMINFORMATION, {type:17});
					TeamNetAction.sendTeamOrder(TeamAction._MSGTEAM_DENY_APPLY, palyerId);
					break;
				case TeamAction._MSGTEAM_ACCEPTINVITE:															//同意邀请
					TeamNetAction.sendTeamOrder(TeamAction._MSGTEAM_ACCEPTINVITE, palyerId, 0, GameCommonData.Player.Role.Name);
					break;
				case TeamAction._MSGTEAM_DENY_INVITE:															//拒绝邀请
					TeamNetAction.sendTeamOrder(TeamAction._MSGTEAM_DENY_INVITE, palyerId, 0, playerName);
					break;
				case TeamAction._MSGTEAM_APPLYJOIN:																//申请加入
					sendNotification(TeamEvent.SHOWTEAMINFORMATION, {type:15});
					TeamNetAction.sendTeamOrder(TeamAction._MSGTEAM_APPLYJOIN, palyerId);
					break;
				case TeamAction._MSGTEAM_INVITE:																//邀请加入
					var idToInvite:int = palyerId;
					if( (teamMemberList[0] && teamMemberList[0].id && teamMemberList[0].id == GameCommonData.Player.Role.Id)) {//自己是队长
						if(isMemberById(idToInvite)) {
							facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_team_med_teamm_sen_1" ], color:0xffff00});            //你们已经是队友
						} else if(isFullTeam()) {
							facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_team_med_teamm_sen_2" ], color:0xffff00});              //队伍已满
						} else {
							TeamNetAction.sendTeamOrder(TeamAction._MSGTEAM_INVITE, idToInvite, 0, "", "");
						}
					} else if(teamMemberList.length == 0){
						//						trace("没有队伍，发出邀请");
						TeamNetAction.sendTeamOrder(TeamAction._MSGTEAM_INVITE, idToInvite, 0, "", "");
					} else {//自己不是队长，发出申请
						if(isMemberById(idToInvite)) {
							facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_team_med_teamm_sen_1" ], color:0xffff00});               //你们已经是队友
						} else if(isFullTeam()) {
							facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_team_med_teamm_sen_2" ], color:0xffff00});               //队伍已满
						} else {
							sendNotification(TeamEvent.SHOWTEAMINFORMATION, {type:9});
							TeamNetAction.sendTeamOrder(TeamAction._MSGTEAM_MEMMBER_APPLY, idToInvite, 0, "", "");
						}
					}
					break;
				default:
					
					break;
			}
		}
		/** 显示组队相关的信息提示文字 */
		public function showTeamInformation(infoObj:Object):void
		{
			switch(infoObj.type) {
				case 1:																											//建立队伍
					facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_team_med_teamm_sho_1" ], color:0xffff00});          //你建立了一个队伍
					break;
				case 2:																											//某人加入了队伍
					var joinPlayerName:String = "";
					//					trace(joinPlayerName);
					if(joinPlayerName == GameCommonData.Player.Role.Name) {
						var leaderName:String = teamMemberList[0].szName;
						facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_team_med_teamm_sho_2" ]+"<font color='#ff0000'>["+leaderName+"]</font>"+GameCommonData.wordDic[ "mod_team_med_teamm_sho_3" ], color:0xffff00});  //你加入了     的队伍
					} else {
						facade.sendNotification(HintEvents.RECEIVEINFO, {info:"<font color='#ff0000'>["+joinPlayerName+"]</font>"+GameCommonData.wordDic[ "mod_team_med_teamm_sho_4" ], color:0xffff00});  //加入了队伍
					}
					joinPlayerName = "";
					break;
				case 3:																											//自己退出队伍
					if(teamMemberList[0]) {
						var leaderName1:String = teamMemberList[0].szName;
						if(leaderName1 == GameCommonData.Player.Role.Name) {
							facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_team_med_teamm_sho_5" ], color:0xffff00});          //你退出了队伍
						} else {
							facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_team_med_teamm_sho_6" ]+"<font color='#ff0000'>["+leaderName1+"]</font>"+GameCommonData.wordDic[ "mod_team_med_teamm_sho_3" ], color:0xffff00});     //你退出了         的队伍 
						}
					}
					break;
				case 4:																											//某人退出了队伍
					var leavePlayerName:String = infoObj.data.szPlayerName;
					if(leavePlayerName == GameCommonData.Player.Role.Name) return;
					facade.sendNotification(HintEvents.RECEIVEINFO, {info:"<font color='#ff0000'>["+leavePlayerName+"]</font>"+GameCommonData.wordDic[ "mod_team_med_teamm_sho_7" ], color:0xffff00});       //退出了队伍
					break;
				case 5:																											//队长变更了
					if(teamMemberList.length == 0) return;
					var newLeaderName:String = infoObj.data.szPlayerName;
					if(newLeaderName == GameCommonData.Player.Role.Name) {
						facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_team_med_teamm_sho_8" ], color:0xffff00});          //你被提升为队长
					} else {
						facade.sendNotification(HintEvents.RECEIVEINFO, {info:"<font color='#ff0000'>["+newLeaderName+"]</font>"+GameCommonData.wordDic[ "mod_team_med_teamm_sho_9" ], color:0xffff00});          //被提升为队长
					}
					break;
				case 6:																											//自己已经是队长了
					facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_team_med_teamm_sho_10" ], color:0xffff00});            //你已经是队长
					break;
				case 7:																											//某玩家被踢出队伍
					var beiJuName:String = infoObj.data.szPlayerName;
					var bossName:String  = teamMemberList[0].szName;
					if(bossName == GameCommonData.Player.Role.Name) {
						facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_team_med_teamm_sho_11" ]+"<font color='#ff0000'>["+beiJuName+"]</font>"+GameCommonData.wordDic[ "mod_team_med_teamm_sho_12" ], color:0xffff00});    //你将        请离了队伍
						return;
					}
					if(beiJuName == GameCommonData.Player.Role.Name) {
						GameCommonData.Player.SetTeam(false);
						facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_team_med_teamm_sho_13" ]+"<font color='#ff0000'>["+teamMemberList[0].szName+"]</font>"+GameCommonData.wordDic[ "mod_team_med_teamm_sho_3" ], color:0xffff00});        //你被请离了         的队伍
						clearTeamLocal();
					}
					break;
				case 8:
//					facade.sendNotification(HintEvents.RECEIVEINFO, {info:"你的组队邀请已发出", color:0xffff00});
					break;
				case 9:
					facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_team_med_teamm_sho_14" ], color:0xffff00});        //你的组队邀请已发出，需要队长确认
					break;
				case 10:
					var inviteLeaderName:String = infoObj.data.szPlayerName;
					var inviterName:String = infoObj.data.szTargetName;
					if(inviterName) {
						facade.sendNotification(HintEvents.RECEIVEINFO, {info:"<font color='#ff0000'>["+inviterName+"]</font>"+GameCommonData.wordDic[ "mod_team_med_teamm_sho_15" ]+"<font color='#ff0000'>["+inviteLeaderName+"]</font>"+GameCommonData.wordDic[ "mod_team_med_teamm_sho_3" ], color:0xffff00});    //邀请你加入           的队伍
					} else {
						facade.sendNotification(HintEvents.RECEIVEINFO, {info:"<font color='#ff0000'>["+inviteLeaderName+"]</font>"+GameCommonData.wordDic[ "mod_team_med_teamm_sho_16" ], color:0xffff00});        //邀请你加入队伍
					}
					break;
				case 11:
					facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_team_med_teamm_sho_17" ], color:0xffff00});         //加入队伍失败
					break;
				case 12:
					//					facade.sendNotification(HintEvents.RECEIVEINFO, {info:"该队伍已满，加入队伍失败", color:0xffff00});
					break;
				case 13:
					var denyInviter:String = infoObj.data.szPlayerName;
					facade.sendNotification(HintEvents.RECEIVEINFO, {info:"<font color='#ff0000'>["+denyInviter+"]</font>"+GameCommonData.wordDic[ "mod_team_med_teamm_sho_18" ], color:0xffff00});          //拒绝了你的组队邀请
					break;
				case 14:
					var inTeamLeader:String = teamMemberList[0].szName;
					facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_team_med_teamm_sho_19" ]+"<font color='#ff0000'>["+inTeamLeader+"]</font>"+GameCommonData.wordDic[ "mod_team_med_teamm_sho_20" ], color:0xffff00});     //你已经在            的队伍中，无法加入其他队伍
					break;
				case 15:
					//					facade.sendNotification(HintEvents.RECEIVEINFO, {info:"你的组队申请已发出", color:0xffff00});
					break;
				case 16:
					facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_team_med_teamm_sho_21" ], color:0xffff00});        //你收到一个组队申请
					break;
				case 17:
//					facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_team_med_teamm_sho_22" ]+"<font color='#ff0000'>["+teamReqSelected.szName+"]</font>"+GameCommonData.wordDic[ "mod_team_med_teamm_sho_23" ], color:0xffff00});        //你拒绝了          的组队申请
					break;
				case 18:
					var denyApplyLeader:String = infoObj.data.szPlayerName;
					facade.sendNotification(HintEvents.RECEIVEINFO, {info:"<font color='#ff0000'>["+denyApplyLeader+"]</font>"+GameCommonData.wordDic[ "mod_team_med_teamm_sho_24" ], color:0xffff00});          //拒绝了你的组队申请
					break;
				case 19:
					facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_team_med_teamm_sho_25" ], color:0xffff00});             //请先选择玩家
					break;
				case 20:
					facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_team_med_teamm_sho_26" ], color:0xffff00});            //不能添加自己为好友
					break;
				case 21:
					
					break;
			}
		}
		/** 本地清除组队，用于自己被踢出队伍 */
		public function clearTeamLocal():void
		{
			var obj:Object = {};
			obj.teamMemList = [];
			obj.teamReqList = [];
			sendNotification(EventList.UPDATETEAM, obj);	//更新组队界面
			sendNotification(PlayerInfoComList.MSG_LEAVE_TEAM);	//通知主界面 清除队伍坐标列表
			notiFan();
		}
		
		/**
		 * 通知页面 
		 */		
		public function notiFan():void
		{
			UIFacade.GetInstance(UIFacade.FACADEKEY).upDateInfo(1);
		}
		
		/**
		 * 添加一个邀请我的队伍到列表当中。 
		 * @param data
		 */		
		public function addInvitePlayer(data:Object):void{
			for (var i:int = 0; i < inviteIdList.length; i++) 
			{
				var item:Object = inviteIdList[i];
				if(item.idPlayer == data.idPlayer)
					return;
			}
			inviteIdList.push(data);			
		}
		
		
		/**
		 * 添加一个邀请我的队伍到列表当中。 
		 * @param data
		 */		
		public function addApplyPlayer(data:Object):void{
			for (var i:int = 0; i < inviteMemList.length; i++) 
			{
				var item:Object = inviteMemList[i];
				if(item.idPlayer == data.idPlayer)
					return;
			}
			inviteMemList.push(data);			
		}
		
		/**
		 * 判断是否在队伍当中 
		 * @param id
		 * @return 
		 */		
		public function isMemberById(id:int):Boolean
		{
			var result:Boolean = false;
			for(var i:int = 0; i < teamMemberList.length; i++) {
				if(id == teamMemberList[i].id) {
					result = true;
					break;
				}
			}
			return result;
		}
		
		/** 更新队员 */
		public function updateMemOnlineState(info:Object):void
		{
			var idPlayer:int = info.id; 
			var state:int    = info.state;			//1-上线，0-离线
			for(var i:int = 0; i < teamMemberList.length; i++) {
				if(idPlayer == teamMemberList[i].id) {
					teamMemberList[i].onlineStatus = state;
					GameCommonData.TeamPlayerList[idPlayer]["state"] = state;
				}
			}
		}
		/**
		 * 判断队伍是否满了 
		 * @return 
		 */		
		public function isFullTeam():Boolean
		{
			if(teamMemberList && teamMemberList.length == 6) return true;
			return false;
		}
	}
}