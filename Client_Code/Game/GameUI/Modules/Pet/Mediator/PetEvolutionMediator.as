package GameUI.Modules.Pet.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Proxy.DataProxy;
	import GameUI.UIConfigData;
	import GameUI.View.BaseUI.PanelBase;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PetEvolutionMediator extends Mediator
	{
		public static const NAME:String = "PetEvolutionMediator";
		private var panelBase:PanelBase;
		private var parentView:MovieClip;
		
		public function PetEvolutionMediator(parentMc:MovieClip)
		{
			parentView = parentMc;
			super(NAME);
		}
		
		public function get PetEvolution():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				EventList.INITPETPANEL,
				EventList.OPENPETEVOLUTION,					//打开宠物进化
				EventList.CLOSEPETEVOLUTION					//关闭宠物进化
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case EventList.INITPETPANEL:
					facade.sendNotification(EventList.GETRESOURCE, {type:UIConfigData.MOVIECLIP, mediator:this, name:"petEvolution"});
					this.PetEvolution.mouseEnabled=false;
					break;
				case EventList.OPENPETEVOLUTION:
					registerView();
					initData();
					parentView.addChild(PetEvolution);
					break;
				case EventList.CLOSEPETEVOLUTION:
					retrievedView();
					parentView.removeChild(PetEvolution);
					break;
			}
		}
		
		private function initData():void
		{
			//获取宠物数据
		}
		
		private function registerView():void
		{
			//初始化素材事件
		}
		
		private function retrievedView():void
		{
			//释放素材事件
		}
	}
}