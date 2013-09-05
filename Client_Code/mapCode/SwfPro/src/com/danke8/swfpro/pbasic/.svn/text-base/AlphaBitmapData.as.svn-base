package com.danke8.swfpro.pbasic
{
	import com.danke8.swfpro.pcolor.ColorType;
	import com.danke8.swfpro.pcolor.DColor;
	
	import flash.utils.ByteArray;

	public class AlphaBitmapData implements AlphaData{
		
		public var bitmapPixelData:Vector.<DColor>=new Vector.<DColor>();
		
		public static function readAlphaBitmapData(data:ByteArray,imgDataSize:uint):AlphaBitmapData{
			var abd:AlphaBitmapData=new AlphaBitmapData();
			for(var i:int=0;i<imgDataSize;i++){
				abd.bitmapPixelData.push(DColor.readColor(data,ColorType.ARGB));
			}
			return abd;
		}
		
		public static function writeAlphaBitmapData(data:ByteArray,dbj3:AlphaBitmapData):void{
			for(var i:int=0;i<dbj3.bitmapPixelData.length;i++){
				DColor.writeColor(data,dbj3.bitmapPixelData[i],ColorType.RGBA);
			}
		}
	}
}