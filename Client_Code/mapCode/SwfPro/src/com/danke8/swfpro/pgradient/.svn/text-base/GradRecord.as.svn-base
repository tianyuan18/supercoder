package com.danke8.swfpro.pgradient
{
	import com.danke8.swfpro.pcolor.ColorType;
	import com.danke8.swfpro.pcolor.DColor;
	import com.danke8.swfpro.pshape.ShapeType;
	
	import flash.utils.ByteArray;

	public class GradRecord
	{
		public var ratio:uint
		public var color:DColor;
		
		/**
		 * 从字节数组中读出渐变记录
		 * @param data
		 * @param shapeType 形状类型
		 * @return 
		 * 
		 */		
		public static function readGradRecord(data:ByteArray,shapeType:uint):GradRecord{
			
			var gr:GradRecord=new GradRecord();
			gr.ratio=data.readUnsignedByte();
			if(shapeType==ShapeType.Shape1 || shapeType==ShapeType.Shape2){
				gr.color=DColor.readColor(data,ColorType.RGB);
			}else if(shapeType==ShapeType.Shape3){
				gr.color=DColor.readColor(data,ColorType.RGBA);
			}
			return gr;
			
		}
		
		/**
		 * 把渐变记录写入字节数组 
		 * @param data 字节数组
		 * @param gr 渐变记录
		 * @param shapeType 形状类型
		 */		
		public static function writeGradRecord(data:ByteArray,gr:GradRecord,shapeType:uint):void{
			data.writeByte(gr.ratio);
			if(shapeType==ShapeType.Shape1 || shapeType==ShapeType.Shape2){
				DColor.writeColor(data,gr.color,ColorType.RGB);
			}else if(shapeType==ShapeType.Shape3){
				DColor.writeColor(data,gr.color,ColorType.RGBA);
			}
		}
	}
}