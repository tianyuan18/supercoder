package control
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;

	
	public class ImgBmpDataCollection extends BaseBmpDataCollection{
		//横向切割数
		private var _w:int;
		//纵向切割数
		private var _h:int;
		//资源地址列表
		private var _imgURL:Array;
		//加载器
		private var _load:Loader=new Loader;
		
		/**
		 * 构造方法
		 * @param imgURL 图片列表
		 * @param w 横向切割数
		 * @param h 纵向切割数
		 */		
		public function ImgBmpDataCollection(imgURL:Array,w:int,h:int){
			var s:String="";
			for(var i:int=0;i<imgURL.length;i++){
				s+=imgURL[i].toString();
			}
			super(s);
			if(!isLoad()){
				_w=w;
				_h=h;
				_imgURL=imgURL;
				loading();
			}
		}
		
		private function loading():void{
			if(_imgURL!=null && _imgURL.length>0){
				_load.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
				_load.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError);
				_load.load(new URLRequest(_imgURL[0]));
			}
		}
		
		private function onError(event:IOErrorEvent):void{
			_load.contentLoaderInfo.removeEventListener(Event.COMPLETE,onComplete);
			_load.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onError);
			trace("加载角色图标时出现错误");
			_imgURL.shift();
			loading();
		}
		
		//事件：加载图片完成
		private function onComplete(event:Event):void{
			_load.contentLoaderInfo.removeEventListener(Event.COMPLETE,onComplete);
			_load.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onError);
			
			var objBitmap:BitmapData = new BitmapData(_load.width, _load.height, true,0x00FFFFFF);
			objBitmap.draw(_load, new Matrix);
			var wWidth:int=_load.width/_w;
			var wHeight:int=_load.height/_h;
			for (var i:uint=0; i < _h; i++){
				var tmpAnimeBDList:Vector.<BitmapData>=new Vector.<BitmapData>();
				for (var j:uint=0; j < _w; j++){
					var bmd:BitmapData=new BitmapData(wWidth,wHeight,true,0x00FFFFFF);
					//获取单个角色的BitmapData对象; 
					bmd.copyPixels(objBitmap,new Rectangle(wWidth * j,wHeight * i,wWidth,wHeight),new Point(0,0));
					tmpAnimeBDList.push(bmd);
				}
				animeBDList.push(tmpAnimeBDList);
			}
			//释放sBmd资源; 
			objBitmap.dispose();
			_imgURL.shift();
			loading();
		}
	}
}