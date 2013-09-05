package com.danke8.swfpro.pgradient
{
	import com.danke8.swfpro.pbasic.DInt;
	
	import flash.utils.ByteArray;

	public class Gradient
	{
		public var spreadMode:uint
		public var interpolationMode:uint
		public var numGradients:uint
		public var gradientRecords:Vector.<GradRecord>;
		
		/**
		 * 从字节数组读取渐变
		 * @param data
		 * @param shapeType 形状类型
		 * @return 
		 */		
		public static function readGradient(data:ByteArray,shapeType:uint):Gradient
		{
			var gradient:Gradient=new Gradient();
			var tmpStr:String=DInt.toBinary(data.readUnsignedByte());
			gradient.spreadMode=parseInt(tmpStr.substr(0,2),2);
			gradient.interpolationMode=parseInt(tmpStr.substr(2,2),2);
			gradient.numGradients=parseInt(tmpStr.substr(4,4),2);
			gradient.gradientRecords=new Vector.<GradRecord>();
			for(var i:int=0;i<gradient.numGradients;i++){
				gradient.gradientRecords.push(GradRecord.readGradRecord(data,shapeType));
			}
			
			return gradient;
		}
		
		/**
		 * 把渐变写入字节数组
		 * @param data
		 * @param gradient 渐变
		 * @param shapeType 形状类型
		 */		
		public static function writeGradient(data:ByteArray,gradient:Gradient,shapeType:uint):void
		{
			var tmpStr:String=DInt.toBinary(gradient.spreadMode,2)+
				DInt.toBinary(gradient.interpolationMode ,2)+
				DInt.toBinary(gradient.numGradients,4);
			data.writeByte(parseInt(tmpStr,2));
			for(var i:int=0;i<gradient.numGradients;i++){
				GradRecord.writeGradRecord(data,gradient.gradientRecords[i],shapeType);
			}
		}
	}
}