package CreateRole.Login.UITool
{
	
	import CreateRole.Login.StartMediator.CreateRoleMediator;
	
	import Data.GameLoaderData;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	public class LoadSwfTool
	{
		public var sendShow:Function;				/** 完成后显示UI*/
		
		private var _mediator:CreateRoleMediator;
		public function LoadSwfTool(path:String , mediator:CreateRoleMediator)
		{
			_mediator = mediator;
//			_isLoadedComplete = isLoadedComplete;
			var picLoader:ImageItem = new ImageItem(GameLoaderData.outsideDataObj.SourceURL + path, 
																	"movieclip" ,
																	path);
			picLoader.addEventListener(ProgressEvent.PROGRESS , onProgressHandler);
			picLoader.addEventListener(Event.COMPLETE, onPicComplete);
			picLoader.load();
		}
		/** 加载中 */
		private function onProgressHandler(e:Event):void
		{
//			LoadingView.getInstance().showLoading();
		}
		/** 下载项完成事件 */
		private function onPicComplete(e:Event):void 
		{
//			LoadingView.getInstance().removeLoading();
			var picLoader:Object  = e.target as Object;
			var view:MovieClip = picLoader.content.content as MovieClip;
			picLoader.destroy();
			picLoader.removeEventListener(Event.COMPLETE, onPicComplete);
			if(sendShow != null) sendShow(view);
			view = null;
		}

	}
}