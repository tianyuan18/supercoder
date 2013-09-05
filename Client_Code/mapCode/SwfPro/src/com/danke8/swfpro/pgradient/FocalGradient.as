package com.danke8.swfpro.pgradient
{
	import com.danke8.swfpro.pbasic.DInt;
	import com.danke8.swfpro.pbasic.Fixed8;
	
	import flash.utils.ByteArray;

	public class FocalGradient extends Gradient
	{
		public var focalPoint:Fixed8;
		
		public static function readFocalGradient(data:ByteArray,shapeType:uint):Gradient{
			var gradient:FocalGradient=new FocalGradient();
			var tmpStr:String=DInt.toBinary(data.readUnsignedByte());
			gradient.spreadMode=parseInt(tmpStr.substr(0,2),2);
			gradient.interpolationMode=parseInt(tmpStr.substr(2,2),2);
			gradient.numGradients=parseInt(tmpStr.substr(4,4),2);
			gradient.gradientRecords=new Vector.<GradRecord>();
			for(var i:int=0;i<gradient.numGradients;i++){
				gradient.gradientRecords.push(GradRecord.readGradRecord(data,shapeType));
			}
			gradient.focalPoint=Fixed8.readFixed8(data);
			return gradient;
		}
		
		public static function writeFocalGradient(data:ByteArray,gradient:FocalGradient,shapeType:uint):void{
			var tmpStr:String=DInt.toBinary(gradient.spreadMode,2)+
				DInt.toBinary(gradient.interpolationMode ,2)+
				DInt.toBinary(gradient.numGradients,4);
			data.writeByte(parseInt(tmpStr,2));
			for(var i:int=0;i<gradient.numGradients;i++){
				GradRecord.writeGradRecord(data,gradient.gradientRecords[i],shapeType);
			}
			Fixed8.writeFixed8(data,gradient.focalPoint);
		}
		
	}
}