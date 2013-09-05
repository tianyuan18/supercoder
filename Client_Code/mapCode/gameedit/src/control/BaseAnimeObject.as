package control
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * 基础动画类 
	 * @author Administrator
	 * 
	 */	
	public class BaseAnimeObject extends Sprite{
		//位图搜集器
		private var _data:BaseBmpDataCollection;
		//定时器
		private var _timer:Timer ;
		//位图(用来显示的对象)
		private var _myBitmap:Bitmap=new Bitmap();
		//动画技术器(播放第几个动画)
		private var _animeIndex:int=0;
		//帧计数器(播放第几帧)
		private var _frameIndex:int=int.MAX_VALUE-10;
		//加载前的位图数据
		private var _beforeLoadData:BitmapData;
		public var animObjectName:String;
		
		public function BaseAnimeObject(data:BaseBmpDataCollection,beforeLoadData:BitmapData=null,speed:int=12){
			super();
			animObjectName=data.animeName;
			this._beforeLoadData=beforeLoadData;
			this.addChild(_myBitmap);
			_timer= new Timer((int)(1000/speed));
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
			_timer.stop();
			this._data=data;
			_timer.start();
		}
		
		//计时器
		private function onTimer(event:TimerEvent):void{
			if(_data!=null && _data.animeBDList.length>_animeIndex && _animeIndex>-1){   
				if(++_frameIndex>=_data.animeBDList[_animeIndex].length){
					_frameIndex=0;
				}
				_myBitmap.bitmapData=_data.animeBDList[_animeIndex][_frameIndex];
				_myBitmap.x=-_myBitmap.width/2;
				_myBitmap.y=-_myBitmap.height+10;
				
			}else{
				//在数据尚未加载前，显示编译位图
				if(_beforeLoadData!=null){
					//如果编译图片数据存在，显示到位图中
					_myBitmap.bitmapData=_beforeLoadData;
					_myBitmap.x=-_myBitmap.width/2;
					_myBitmap.y=-_myBitmap.height+10;
				}else{
					_myBitmap.bitmapData=null;
				}
			}
		}
		
		/**
		 * @return 获取当前正在播放第几个帧
		 */		
		public function get frameIndex():int{
			return _frameIndex;
		}
		
		/**
		 * @param value 设置当前播放第几个帧
		 */		
		public function set frameIndex(value:int):void{
			_frameIndex = value;
		}
		
		/**
		 * @return 获取当前正在播放第几个动画
		 */	
		public function get animeIndex():int{
			return _animeIndex;
		}
		
		/**
		 * @param value 设置当前播放第几个动画
		 */		
		public function set animeIndex(value:int):void{
			_animeIndex = value;
		}
	}
}