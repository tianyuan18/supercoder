package control
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * 基本位图搜集器 
	 * @author Administrator
	 * 
	 */	
	public class BaseBmpDataCollection extends EventDispatcher{
		
		/**
		 * 事件：加载完毕 
		 */		
		public static const LOADCONMPLETE:String="LoadComplete";
		public static var bmpDataCollectionList:Vector.<BaseBmpDataCollection>=new Vector.<BaseBmpDataCollection>;
		
		public var animeName:String;
		//动画速度
		public var animeSpeed:Array;
		//位图数据列表
		public var animeBDList:Vector.<Vector.<BitmapData>>=new Vector.<Vector.<BitmapData>>;
		//动画字典
		public var animeBook:Dictionary;
		//动画名称列表
		public var animeNames:Array;
		
		public function BaseBmpDataCollection(animeName:String){
			this.animeName=animeName;
			for(var i:int=0;i<bmpDataCollectionList.length;i++){
				if(bmpDataCollectionList[i].animeName==animeName){
					animeSpeed=bmpDataCollectionList[i].animeSpeed;
					animeBDList=bmpDataCollectionList[i].animeBDList;
					animeBook=bmpDataCollectionList[i].animeBook;
					animeNames=bmpDataCollectionList[i].animeNames;
					return;
				}
			}
			bmpDataCollectionList.push(this);
		}
		
		
		public function isLoad():Boolean{
			if(animeBDList!=null && animeBDList.length>0){
				return true;
			}
			else{
				return false;
			}
		}
		
		public static function deleteAmin(animeName:String):void{
			for(var i:int=0;i<bmpDataCollectionList.length;i++){
				if(bmpDataCollectionList[i].animeName==animeName){
					bmpDataCollectionList.splice(i,1);
					return;
				}
			}
		}
		
	}
}