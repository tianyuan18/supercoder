package GameUI.Modules.UnityNew.Mediator
{
	import GameUI.Modules.UnityNew.Data.NewUnityCommonData;
	import GameUI.Modules.UnityNew.Proxy.NewUnityResouce;
	import GameUI.View.BaseUI.PanelBase;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	/**帮派神兽
	 * xuxiao
	 * **/
	public class NewUnityPetMediator extends Mediator
	{
		
		private var main_mc:MovieClip;
		private var panelBase:PanelBase;
		private var selectIndex:int;
		private var maxCheckBox:int;
		
		public function NewUnityPetMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		
		public override function listNotificationInterests():Array
		{
			return [ 
				NewUnityCommonData.OPEN_NEW_UNITY_ORDER_PANEL,
				NewUnityCommonData.CLOSE_NEW_UNITY_ORDER_PANEL 
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch ( notification.getName() )
			{
				case NewUnityCommonData.CHANG_NEW_UNITY_PAGE:
					
					break;
				case NewUnityCommonData.CLEAR_UNITY_LAST_OPEN_PANEL:
					
					break;
			}
		}
		
		private function initView():void
		{
			
		}
		
		private function openMe():void
		{
			
		}
		
		private function onClickPage( evt:MouseEvent):void
		{
			
		}
		
		private function changPage():void
		{
			
		}
		
		private function clearMe():void
		{
			
		}
	}
}