package control
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	/**
	 * swf位图搜集器 
	 * @author Administrator
	 * @time 
	 */	
	public class SwfBmpDataCollection extends BaseBmpDataCollection{
		private var _loader:Loader;
		public function SwfBmpDataCollection(swfURL:String){
			super(swfURL);
			if(!isLoad()){
				_loader=new Loader();
				_loader.load(new URLRequest(swfURL));
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError);
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
			}
		}
		
		//事件：加载完毕
		private function onComplete(event:Event):void{   
			var loaderInfo:LoaderInfo=event.target as LoaderInfo;
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onError);
			loaderInfo.removeEventListener(Event.COMPLETE,onComplete);
			
			animeBook=(loaderInfo.content as Object).animeBook as Dictionary;
			animeNames=(loaderInfo.content as Object).animeNames;
			animeSpeed=(loaderInfo.content as Object).animeSpeed;
			
			var domain:ApplicationDomain=loaderInfo.applicationDomain as ApplicationDomain;
			animeBDList.splice(0,animeBDList.length);
			for(var i:int=0;i< animeNames.length;i++){
				var tmpAnimeBDList:Vector.<BitmapData>=new Vector.<BitmapData>();
				for(var j:int=0;j<animeBook[animeNames[i]].length;j++){
					var TmpClass:Class=domain.getDefinition(animeBook[animeNames[i]][j]) as Class;
					var bitmapData:BitmapData=new TmpClass(0,0) as BitmapData;
					tmpAnimeBDList.push(bitmapData);
				}
				animeBDList.push(tmpAnimeBDList);
			}
			this.dispatchEvent(new Event(LOADCONMPLETE,false));
		}   
		
		//事件加载失败
		private function onError(event:IOErrorEvent):void{
			var loaderInfo:LoaderInfo=event.target as LoaderInfo;
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onError);
			loaderInfo.removeEventListener(Event.COMPLETE,onComplete);
		}
	}
}