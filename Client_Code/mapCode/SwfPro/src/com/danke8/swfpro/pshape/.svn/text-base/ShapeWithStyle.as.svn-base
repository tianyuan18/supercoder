package com.danke8.swfpro.pshape
{
	import com.danke8.swfpro.pbasic.DInt;
	
	import flash.utils.ByteArray;
	import com.danke8.swfpro.pshape.pshaperecord.ShapeRecord;

	public class ShapeWithStyle
	{
		public var fillStyles:Vector.<FillStyle>;
		public var lineStyles:Vector.<LineStyle>;
		public var numFillBits:uint;
		public var numLineBits:uint;
		public var shapeRecords:Vector.<ShapeRecord>;
		
		public static function readShapeWithStyle(data:ByteArray,shapeType:uint):ShapeWithStyle{
			
			var sws:ShapeWithStyle=new ShapeWithStyle();
			sws.fillStyles=FillStyle.readFillStyles(data,shapeType);
			sws.lineStyles=LineStyle.readLineStyles(data,shapeType);
			var tmpStr:String=DInt.toBinary(data.readUnsignedByte());
			sws.numFillBits=parseInt(tmpStr.substr(0,4),2);
			sws.numLineBits=parseInt(tmpStr.substr(4,4),2);
			sws.shapeRecords=ShapeRecord.readShapeRecords(data,sws.numFillBits,sws.numLineBits);
			return sws;
		}
		
		public static function writeShapeWithStyle(data:ByteArray,sws:ShapeWithStyle,shapeType:uint):void{
			FillStyle.writeFillStyles(data,sws.fillStyles,shapeType);
			LineStyle.writeLineStyles(data,sws.lineStyles,shapeType);
			var tmp:int=parseInt((DInt.toBinary(sws.numFillBits,4)+DInt.toBinary(sws.numLineBits,4)),2);
			data.writeByte(tmp);
			ShapeRecord.writeShapeRecords(data,sws.shapeRecords,sws.numFillBits,sws.numLineBits);
		}
	}
}