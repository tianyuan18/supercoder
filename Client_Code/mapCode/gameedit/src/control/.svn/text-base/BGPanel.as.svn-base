package control
{
	import common.App;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import modelExtend.GameFullExtend;
	import modelExtend.MapExtend;

	public class BGPanel extends MapPanel{
		
		private var bgImg:Bitmap=new Bitmap();
		
		public function BGPanel(){
			
			super();
			bgImg.x=30;
			bgImg.y=15;
			this.addChild(bgImg);
		}
		
		private function get _pro():GameFullExtend{
			if(App.proCurrernt!=null ){
				return App.proCurrernt;
			}
			else{
				return null;
			}
		}
		
		private function get _map():MapExtend{
			if(App.proCurrernt!=null && App.proCurrernt.MapCurrent!=null){
				return App.proCurrernt.MapCurrent;
			}
			else{
				return null;
			}
		}
		
		public function loadBG():void{
			bgImg.bitmapData=null;
			var loader:Loader=new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onBGLoadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError);
			loader.load(new URLRequest(_pro.pathRoot+"images\\maps\\"+_map.name+"\\"+"bg.jpg"));
		}
		
		
		//事件：背景加载完毕
		private function onBGLoadComplete(event:Event):void{
			var loaderInfo:LoaderInfo=event.target as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE,onBGLoadComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onError);
			bgImg.bitmapData=loaderInfo.content["bitmapData"] as BitmapData;
			_map.bgBitmapData=bgImg.bitmapData;
			//_mapInfo.setMapInfo();
		}
		
		private function onError(event:IOErrorEvent):void{
			var loaderInfo:LoaderInfo=event.target as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE,onBGLoadComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onError);
			trace("加载背景图片失败")
		}
		
	}
}