package com.danke8.swfpro.pbasic
{
	import flash.utils.ByteArray;

	public class DInt
	{
		/**
		 * 转换为二进制字符串 
		 */		
		public static function toBinary(num:uint,len:int=8):String
		{
			var str:String=num.toString(2);
			return DString.addZeroBefore(str,len);
		}
		
		/**
		 * 读取字节数组的值
		 * @param data 字节数组
		 * @param bCount 读取字节数（范围：1-4）
		 * @param order 是否顺序
		 */		
		public static function readB(data:ByteArray,count:int=1,order:Boolean=true):uint{
			var ret:uint=0;
			var tmpCount:int=count;
			while(tmpCount>0){
				var moveCount:int=order?((tmpCount-1)<<3):((count-tmpCount)<<3)
				ret+=(data.readUnsignedByte()<<moveCount);
				tmpCount--;
			}
			return ret;
		}
		
		/**
		 * 将值写入字节数组 
		 * @param data 字节数组
		 * @param v 值
		 * @param count 写入长度（范围：1-4）
		 * @param order 是否顺序
		 */		
		public static function writeB(data:ByteArray,v:uint,count:int=1,order:Boolean=true):void{
			var tmpStr:String=DString.addZeroBefore(DInt.toBinary(v),32);
			var tmpCount:int=count;
			while(tmpCount>0){
				var wV:int=order?parseInt(tmpStr.substr(32-(tmpCount<<3),8),2):parseInt(tmpStr.substr(32-((count-tmpCount+1)<<3),8),2)
				data.writeByte(wV);
				tmpCount--;
			}
		}
//		
//		/**
//		 * 将值写入字节数组 
//		 * @param data 字节数组
//		 * @param v 值
//		 * @param count 写入长度（范围：1-4）
//		 * @param order 是否顺序
//		 */		
//		public static function writeBString(v:uint,count:int=1,order:Boolean=true):String{
//			var tmpStr:String=DString.addZeroBefore(DInt.toBinary(v),32);
//			var tmpCount:int=count;
//			while(tmpCount>0){
//				var wV:int=order?parseInt(tmpStr.substr(32-(tmpCount<<3),8),2):parseInt(tmpStr.substr(32-((count-tmpCount+1)<<3),8),2)
//				data.writeByte(wV);
//				tmpCount--;
//			}
//		}
	}
}