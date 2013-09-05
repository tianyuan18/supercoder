package OopsEngine.Scene
{
	import flash.display.MovieClip;

	/**
	 * 特效信息类 by xiongdian
	 */
	public class MapEffectData
	{
		//特效名
		private var _effectName:String;
		
		//切片地图名
		public var picNameArray:Array;
		
		//特效坐标，以矩形左上角为标准
		private var _x:int;	
		private var _y:int;
		
		//特效id，此id是具体特效的唯一标示，例如地图中有两个瀑布的特效，此id将区别两个瀑布
		private var _id:int;
		
		//地图特效MC
		private var _effectMC:MovieClip;
		
		/**
		 * 判断传入切片是否存在地图特效
		 */
		public function isExistEffect(value:String):Boolean{
			
			for each (var picName:String in picNameArray){
				
				if(value == picName){
					
					return true;
				}
			}
			return false;
		}
		/**
		 * 特效名
		 */
		public function get effectName():String{
			
			return _effectName;
		}
		
		/**
		 * 特效名
		 */
		public function set effectName(value:String):void{
			
			_effectName=value;
		}
		
		/**
		 * 地图特效MC
		 */
		public function get effectMC():MovieClip{
			
			return _effectMC;
		}
		
		/**
		 * 地图特效MC
		 */
		public function set effectMC(value:MovieClip):void{
			
			_effectMC=value;
		}
		
		/**
		 * x坐标
		 */
		public function get x():int{
			
			return _x;
		}
		
		/**
		 * x坐标
		 */
		public function set x(value:int):void{
			
			_x=value;
		}
		/**
		 * y坐标
		 */
		public function get y():int{
			
			return _y;
		}
		
		/**
		 * y坐标
		 */
		public function set y(value:int):void{
			
			_y=value;
		}
		/**
		 * 特效id，此id是具体特效的唯一标示，例如地图中有两个瀑布的特效，此id将区别两个瀑布
		 */
		public function get id():int{
			
			return _id;
		}
		
		/**
		 * 特效id，此id是具体特效的唯一标示，例如地图中有两个瀑布的特效，此id将区别两个瀑布
		 */
		public function set id(value:int):void{
			
			_id=value;
		}
		
	}
}