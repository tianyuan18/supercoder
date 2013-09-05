package GameUI.Modules.Mount.Proxy
{
	import Net.ActionSend.OperatorItemSend;
	import Net.ActionSend.PlayerActionSend;
	import Net.Protocol;
	
	public class MountNetAction
	{
		public function MountNetAction()
		{
		}
		
		public static function opMount(action:int,mountSkin:int):void
		{
			var obj:Object = new Object();
			obj.type = Protocol.PLAYER_ACTION;
			obj.data = new Array();
			obj.data.push(0);
			obj.data.push(0);
			obj.data.push(0);
			obj.data.push(0);
			obj.data.push(0);
			obj.data.push(mountSkin);							//自己添加250，自己锁定251, 取消繁殖253
			obj.data.push(action);
			obj.data.push(0);
			obj.data.push(0);							//名字  改名时用，
			PlayerActionSend.PlayerAction(obj);
		}
	}
}