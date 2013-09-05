package GameUI.Modules.Friend.view.mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Friend.command.FriendCommandList;
	import GameUI.Modules.Friend.model.vo.PlayerInfoStruct;
	import GameUI.UIConfigData;
	import GameUI.UICore.UIFacade;
	import GameUI.View.BaseUI.PanelBase;
	
	import Net.ActionSend.FriendSend;
	
	import OopsEngine.Graphics.Font;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class FriendAlterMediator extends Mediator
	{
		public static const NAME:String="FriendAlterMediator";
		protected var basePanel:PanelBase;
		protected var playerInfo:PlayerInfoStruct;
		protected var roleName:String="";
		
		public function FriendAlterMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		public function get viewUi():MovieClip{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array{
			return [
				FriendCommandList.SHOW_FRIEND_ALTER,
				FriendCommandList.CLOSE_FRIEND_ALTER
			];
		}
		
		public override function handleNotification(notification:INotification):void{
			switch (notification.getName()){
				case FriendCommandList.SHOW_FRIEND_ALTER:
					playerInfo=notification.getBody() as PlayerInfoStruct;
					var str:String='<font color="#ff0000">'+playerInfo.roleName+'</font><font color="#ffffff">申请加你为好友</font>';//申请加你为好友？
					UIFacade.UIFacadeInstance.sendNotification(EventList.SHOWALERT,{comfrim:onAgreeHandler, cancel:onDisagreeHandler, isShowClose:false, info:str,htmlText:true, comfirmTxt:"是", cancelTxt:"否"});
					break;
				case FriendCommandList.CLOSE_FRIEND_ALTER:
					UIFacade.UIFacadeInstance.sendNotification(EventList.CLOSEALERT);
					break;		
			}
		}
		
		
		/**
		 * 同意 
		 * @param e
		 * 
		 */		
		protected function onAgreeHandler():void{
			FriendSend.getInstance().recallApplyToFriend(this.playerInfo.frendId,2,this.playerInfo.friendGroupId,0,this.playerInfo.roleName);
		}
		
		
		/**
		 * 拒绝  
		 * @param e
		 * 
		 */		
		protected function onDisagreeHandler():void{
			FriendSend.getInstance().recallApplyToFriend(this.playerInfo.frendId,3,this.playerInfo.friendGroupId,1,this.playerInfo.roleName);
		}
	}
}