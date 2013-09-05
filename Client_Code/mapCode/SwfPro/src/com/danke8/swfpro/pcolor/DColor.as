package com.danke8.swfpro.pcolor
{
	import com.danke8.swfpro.pbasic.DString;
	
	import flash.utils.ByteArray;

	/**
	 * 蛋壳颜色类 
	 * @author 小程序员
	 */	
	public class DColor
	{
		/**
		 * 红 
		 */		
		public var r:uint;
		/**
		 * 绿
		 */		
		public var g:uint;
		/**
		 * 蓝
		 */		
		public var b:uint;
		/**
		 * 透明度
		 */		
		public var a:uint=0xff;
		
		/**
		 * 从字节数读取颜色值 
		 * @param data 字节数组
		 * @param type 颜色类型ColorType
		 */		
		public static function readColor(data:ByteArray,type:uint):DColor{
			var color:DColor=new DColor();
			if(type==ColorType.RGBA){
				color.a=data.readUnsignedByte();
			}
			color.r=data.readUnsignedByte();
			color.g=data.readUnsignedByte();
			color.b=data.readUnsignedByte();
			if(type==ColorType.RGBA){
				color.a=data.readUnsignedByte();
			}
			return color;
		}
		
		/**
		 * 将颜色值写入字节数组 
		 * @param data
		 * @param color
		 * @param type
		 */		
		public static function writeColor(data:ByteArray,color:DColor,type:uint):void{
			if(type==ColorType.ARGB){
				data.writeByte(color.a);
			}
			data.writeByte(color.r);
			data.writeByte(color.g);
			data.writeByte(color.b);
			if(type==ColorType.RGBA){
				data.writeByte(color.a);
			}
		}
		
		/**
		 * 生成16进制rbga字符串 
		 */		
		public function toRGB16String():String{
			var ret:String=DString.addZeroBefore(r.toString(16),2)+
				DString.addZeroBefore(g.toString(16),2)+
				DString.addZeroBefore(b.toString(16),2)+
				DString.addZeroBefore(a.toString(16),2);
			return ret;
		}
	}
}