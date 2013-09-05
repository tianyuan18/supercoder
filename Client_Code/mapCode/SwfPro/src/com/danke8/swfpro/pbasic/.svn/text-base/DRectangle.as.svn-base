package com.danke8.swfpro.pbasic
{
	import flash.utils.ByteArray;

	/**
	 * 蛋壳矩形类 
	 * @author 小程序员
	 * 
	 */	
	public class DRectangle
	{
		public var dataLenLen:uint=5;
		public var dataLen:uint=15;
		
		public var x:int;
		public var y:int;
		public var width:int;
		public var height:int;
			
		public function DRectangle(x:int=0,y:int=0,w:int=0,h:int=0){
			this.x=x;
			this.y=y;
			this.width=w;
			this.height=h;
		}
		
		/**
		 * 从字节数组中读出矩形数据 
		 * @param data 字节数组
		 */		
		public static function readRectgle(data:ByteArray):DRectangle{
			
			var rect:DRectangle=new DRectangle();
			var dData:DDate=new DDate(data);
			rect.dataLen=dData.readUInt(rect.dataLenLen);
			var tmpArr:Vector.<uint>=new Vector.<uint>();
			tmpArr.push(dData.readUInt(rect.dataLen)/20);
			tmpArr.push(dData.readUInt(rect.dataLen)/20);
			tmpArr.push(dData.readUInt(rect.dataLen)/20);
			tmpArr.push(dData.readUInt(rect.dataLen)/20);
			rect.x=tmpArr[0];
			rect.y=tmpArr[2];
			rect.width=tmpArr[1]-tmpArr[0];
			rect.height=tmpArr[3]-tmpArr[2];
			return rect;
		}
		
		public static function writeRectangle(data:ByteArray,rect:DRectangle):void{
			var dData:DDate=new DDate(data);
			dData.writeUInt(rect.dataLen,rect.dataLenLen);
			dData.writeUInt(rect.x*20,rect.dataLen);
			dData.writeUInt(rect.x*20+rect.width*20,rect.dataLen);
			dData.writeUInt(rect.y*20,rect.dataLen);
			dData.writeUInt(rect.y*20+rect.height*20,rect.dataLen);
			dData.flush();
		}
	}
}