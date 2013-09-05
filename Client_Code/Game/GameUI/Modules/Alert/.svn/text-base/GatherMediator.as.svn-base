package GameUI.Modules.Alert
{
	import GameUI.ConstData.EventList;
	import GameUI.UIConfigData;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class GatherMediator extends Mediator
	{
		public static const NAME:String = "GatherMediator";
		/* 0:没在采集 1：正在采集  **/
		public static var GATHERING:int = 0;
		public function GatherMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME);
		}
		
		private function get gatherView():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				EventList.INITVIEW,
				EventList.SHOW_GATHER_VIEW,
				EventList.CANCEL_GATHER_VIEW,
				EventList.STAGECHANGE
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case EventList.INITVIEW:
					facade.sendNotification(EventList.GETRESOURCE, {type:UIConfigData.MOVIECLIP, mediator:this, name:"GatherView"});
					
					gatherView.gotoAndStop(1);
					break;
				case EventList.SHOW_GATHER_VIEW:
					
					if(gatherView.currentFrame==1){
						var rec:Rectangle = gatherView.getRect(gatherView); 
						gatherView.x = (GameCommonData.GameInstance.GameUI.stage.stageWidth - rec.width/2) / 2;
						gatherView.y = (GameCommonData.GameInstance.GameUI.stage.stageHeight - rec.height) / 2+200;
						GameCommonData.GameInstance.GameUI.addChild(gatherView);
						gatherView.addEventListener(Event.ENTER_FRAME,onEnterFrame);
						gatherView.play();
						GATHERING = 1;
					}
					break;
					
				case EventList.CANCEL_GATHER_VIEW:
					if(GameCommonData.GameInstance.GameUI.contains(gatherView)){
						gatherView.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
						GameCommonData.GameInstance.GameUI.removeChild(gatherView);
						gatherView.gotoAndStop(1);
						GATHERING = 0;
					}
					
					break;
				case EventList.STAGECHANGE:
						if(gatherView){
							var rec1:Rectangle = gatherView.getRect(gatherView); 
							gatherView.x = (GameCommonData.GameInstance.GameUI.stage.stageWidth - rec1.width/2) / 2;
							gatherView.y = (GameCommonData.GameInstance.GameUI.stage.stageHeight - rec1.height) / 2+200;
						}
					break;
			}
			
		}
		
		private function onEnterFrame(e:Event):void {
		
			gatherView.txt_gather.text = "采集中..."+gatherView.currentFrame+"%";
			if(gatherView.currentFrame == gatherView.totalFrames){
				gatherView.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				GameCommonData.GameInstance.GameUI.removeChild(gatherView);
				gatherView.gotoAndStop(1);
				GATHERING = 0;
				GameCommonData.Scene.DelayGather();
				
			}
			
		}
				
				
	}
}