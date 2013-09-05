package com.danke8.swfpro.pbasic
{
	import com.danke8.swfpro.pcolor.ColorType;
	import com.danke8.swfpro.pcolor.DColor;
	
	import flash.utils.ByteArray;
	
	import mx.messaging.AbstractConsumer;

	public class AlphaColorMapData implements AlphaData
	{
		public var colorTableRGB:Vector.<DColor>=new Vector.<DColor>();
		public var colormapPixelData:ByteArray;
		
		public static function readAlphaColorMapData(data:ByteArray,colorTableSize:uint,imgDataSize:uint):AlphaColorMapData{
			var acm:AlphaColorMapData=new AlphaColorMapData();
			for(var i:int=0;i<colorTableSize;i++){
				acm.colorTableRGB.push(DColor.readColor(data,ColorType.RGBA));
			}
			data.readBytes(acm.colormapPixelData,0,imgDataSize);
			return acm;
		}
		
		public static function writeAlphaColorMapData(data:ByteArray,dbj3:AlphaColorMapData):void{
			for(var i:int=0;i<dbj3.colorTableRGB.length;i++){
				DColor.writeColor(data,dbj3.colorTableRGB[i],ColorType.RGBA);
			}
			data.writeBytes(dbj3.colormapPixelData);
		}
	}
}