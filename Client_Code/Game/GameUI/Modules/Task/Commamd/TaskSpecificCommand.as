package GameUI.Modules.Task.Commamd
{
	import GameUI.MouseCursor.RepeatRequest;
	import GameUI.View.ResourcesFactory;
	
	import OopsEngine.Utils.MovieAnimation;
	
	import flash.display.MovieClip;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class TaskSpecificCommand extends SimpleCommand
	{
		private var pathStr:String;
		private var type:int;
		public function TaskSpecificCommand()
		{
			super();
		}
		
		public override function execute(notification:INotification):void{
			if(RepeatRequest.getInstance().successFlags[5]==false)return;
			var id:int=int(notification.getBody());
			var type:int=int(notification.getType());
			this.type = type;
			if(id==101)return;
		 	if(type==1){
				pathStr=GameCommonData.GameInstance.Content.RootDirectory + "Resources/GameDLC/taskAccept.swf";
			}else if(type==2){
				pathStr=GameCommonData.GameInstance.Content.RootDirectory + "Resources/GameDLC/taskComplete.swf";
			} 
			ResourcesFactory.getInstance().getResource(pathStr,onCompleteLoad);	
		}
		
		
		protected function onCompleteLoad():void{
			var view:MovieClip=ResourcesFactory.getInstance().getMovieClip(pathStr);
			var clip:MovieClip;
			if(type==1){
				clip = new (view.loaderInfo.applicationDomain.getDefinition("taskAccept"));
			}else{
				clip = new (view.loaderInfo.applicationDomain.getDefinition("taskComplete"));
			}
			
			
			clip.y=170;
			
			
			clip.x = GameCommonData.GameInstance.GameUI.stage.stageWidth/2;
		  
			clip.gotoAndPlay(1);
		    GameCommonData.GameInstance.GameUI.addChild(clip);
		
//			view.x=502;
//			view.y=170;
//			if( GameCommonData.GameInstance.GameUI.stage.stageWidth > GameConfigData.GameWidth )
//			{
//			    view.x += (GameCommonData.GameInstance.GameUI.stage.stageWidth - GameConfigData.GameWidth - 80)/2;
//		    }
//			view.gotoAndPlay(1);
//			GameCommonData.GameInstance.GameUI.addChild(view);
		}
		
		
		
	}
}