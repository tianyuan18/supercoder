package GameUI.Modules.GmTools.Utils
{
	import GameUI.View.Components.LoadingView;
	
	import OopsFramework.Content.ContentTypeReader;
	import OopsFramework.Content.Loading.BulkLoader;
	import OopsFramework.Content.Loading.ImageItem;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class LoadSwfTool
	{
		public var sendShow:Function;				/** 完成后显示UI*/
		
		private var _mediator:Mediator;
		public function LoadSwfTool(path:String , mediator:Mediator)
		{
			_mediator = mediator;
//			_isLoadedComplete = isLoadedComplete;
			var picLoader:ImageItem = new ImageItem(GameCommonData.GameInstance.Content.RootDirectory + path, 
																	BulkLoader.TYPE_MOVIECLIP ,
																	path);
			picLoader.addEventListener(ProgressEvent.PROGRESS , onProgressHandler);
			picLoader.addEventListener(Event.COMPLETE, onPicComplete);
			picLoader.load();
		}
		/** 加载中 */
		private function onProgressHandler(e:Event):void
		{
			LoadingView.getInstance().showLoading();
		}
		private var _res:ContentTypeReader;
		/** 下载项完成事件 */
		private function onPicComplete(e:Event):void 
		{
			LoadingView.getInstance().removeLoading();
			var picLoader:Object  = e.target as Object;
			var view:MovieClip = picLoader.content.content as MovieClip;
			
			// 添加下载的资源到此资源提供器的集合中
			_res = new ContentTypeReader();
			_res.Content = picLoader.content;
			
			picLoader.destroy();
			picLoader.removeEventListener(Event.COMPLETE, onPicComplete);
			if(sendShow != null) sendShow(view);
			view = null;
		}
		public function GetResource():ContentTypeReader{
			return _res;
		}
	}
}