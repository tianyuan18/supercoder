package Resource
{
	import Data.GameLoaderData;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	public class ResLoader
	{
		private var loader:Loader;
		private var resArr:Array;
		private var loadItems:uint = 0;
		
		public var allDoneHandler:Function;								//资源全部加载完成
		
		public function ResLoader()
		{
			resArr = [GameLoaderData.GameUrl];
			initLoader();
		}
		
		private function initLoader():void
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS,onProgress );
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE,onComplete );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR,reLoad );
			if ( loadItems<resArr.length )
			{
				loader.load( new URLRequest( resArr[ loadItems ].toString() ) );
			}
		}
		
		private function onProgress( evt:ProgressEvent ):void
		{
			if ( GameLoaderData.outsideDataObj.tiao )
			{
				var progress:int = Math.round(evt.bytesLoaded/evt.bytesTotal*100);
				var mainProgress:int = Math.round(progress*GameLoaderData.outsideDataObj.mainPercent/100)
				GameLoaderData.outsideDataObj.tiao.total_mc.gotoAndStop(mainProgress);
				GameLoaderData.outsideDataObj.tiao.totalPercent_txt.htmlText = "<font color='#FFFFFF' size='12'>总进度："+mainProgress+"%";
				
				GameLoaderData.outsideDataObj.tiao.item_mc.gotoAndStop(progress);
				GameLoaderData.outsideDataObj.tiao.itemPercent_txt.htmlText = "<font color='#FFFFFF' size='12'>当前进度："+progress+"%";
				
				var currnetFrame:int = GameLoaderData.outsideDataObj.tiao.total_mc.currentFrame;
				GameLoaderData.outsideDataObj.tiao.time_txt.htmlText = "<font color='#ffff00' size='14'>剩余时间："+( 20 - int(currnetFrame/10)*2)+" 秒</font>";
			}
		}
		
		private function onComplete( evt:Event ):void
		{
			if ( GameLoaderData.outsideDataObj.tiao )
			{
				GameLoaderData.outsideDataObj.tiao.total_mc.gotoAndStop(GameLoaderData.outsideDataObj.mainPercent);
				GameLoaderData.outsideDataObj.tiao.item_mc.gotoAndStop(100);
				
				GameLoaderData.outsideDataObj.tiao.totalPercent_txt.htmlText = "<font color='#FFFFFF' size='12'>总进度："+GameLoaderData.outsideDataObj.mainPercent+"%";
				GameLoaderData.outsideDataObj.tiao.itemPercent_txt.htmlText = "<font color='#FFFFFF' size='12'>当前进度：100%";
			}
			if ( allDoneHandler != null )
			{
				allDoneHandler( loader );
			}
			gc();
		}
		
		private function reLoad( evt:IOErrorEvent ):void
		{
			
		}
		
		private function gc():void
		{
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,onProgress);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onComplete);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,reLoad);
//			loader.close();
			loader = null;
		}

	}
}