package com.danke8.swfpro.pshape
{
	import com.danke8.swfpro.pbasic.DInt;
	import com.danke8.swfpro.pbasic.DMatrix;
	import com.danke8.swfpro.pcolor.ColorType;
	import com.danke8.swfpro.pcolor.DColor;
	import com.danke8.swfpro.pgradient.FocalGradient;
	import com.danke8.swfpro.pgradient.Gradient;
	
	import flash.utils.ByteArray;

	/**
	 * 填充样式 
	 * @author 小程序员
	 * 
	 */	
	public class FillStyle
	{
		/**
		 * 填充类型 
		 */		
		public var fillType:int;
		/**
		 * 颜色
		 * If type = 0x00, RGBA (if Shape3)
		 * RGB (if Shape1 or Shape2)
		 */		
		public var color:DColor;
		/**
		 * 渐变矩阵（如果类型为渐变10/12/13,MATRIX） 
		 */		
		public var gradientMatrix:DMatrix;
		/**
		 * 渐变
		 * If type = 0x10 or 0x12, GRADIENT
		 * If type = 0x13, FOCALGRADIENT
		 * (SWF 8 and later only)
		 */		
		public var gradient:Gradient;
		/**
		 * （只有位图填充的情况下）
		 */		
		public var bitmapID:int;
		/**
		 * （只有位图填充的情况下）
		 */		
		public var bitmapMatrix:DMatrix;
		
		/**
		 * 从字节数组中读取填充样式列表
		 * @param data 字节数组
		 */		
		public static function readFillStyles(data:ByteArray,shapeType:uint):Vector.<FillStyle>{
			var styleCount:int=data.readUnsignedByte();
			if(styleCount==0xff){
				styleCount=DInt.readB(data,2,false);
			}
			var styles:Vector.<FillStyle>=new Vector.<FillStyle>();;
			for(var i:int=0;i<styleCount;i++){
				var style:FillStyle=readFillStyle(data,shapeType);
				styles.push(style);
			}
			
			return styles;
		}
		
		/**
		 * 从字节数组总读取填充样式
		 * @param data 字节数组
		 * @param shapeType 形状类型
		 */
		public static function readFillStyle(data:ByteArray,shapeType:uint):FillStyle{
			 
			var fst:FillStyle=new FillStyle();
			fst.fillType=data.readUnsignedByte();
			
			
			if(fst.fillType==FillStyleType.SOLID_FILL){
				if(shapeType==ShapeType.Shape1 || shapeType==ShapeType.Shape2){
					fst.color=DColor.readColor(data,ColorType.RGB);
				}else if(shapeType==ShapeType.Shape3){
					fst.color=DColor.readColor(data,ColorType.RGBA);
				}
			}
			
			if(fst.fillType==FillStyleType.FOCAL_RADIAL_GRADIENT_FILL || fst.fillType==FillStyleType.LINEAR_GRADIENT_FILL || fst.fillType==FillStyleType.RADIAL_GRADIENT_FILL){
				fst.gradientMatrix=DMatrix.readMatrix(data);
			}
			
			if(fst.fillType==FillStyleType.LINEAR_GRADIENT_FILL || fst.fillType==FillStyleType.RADIAL_GRADIENT_FILL){
				fst.gradient=Gradient.readGradient(data,shapeType);
			}else if(fst.fillType==FillStyleType.FOCAL_RADIAL_GRADIENT_FILL){
				fst.gradient=FocalGradient.readFocalGradient(data,shapeType);
			}
			
			if(fst.fillType==FillStyleType.REPEATING_BITMAP_FILL ||fst.fillType==FillStyleType.CLIPPED_BITMAP_FILL || fst.fillType==FillStyleType.NON_SMOOTHED || fst.fillType==FillStyleType.NON_SMOOTHED_CLIPPED){
				fst.bitmapID=DInt.readB(data,2,false);
				fst.bitmapMatrix=DMatrix.readMatrix(data);
			}
			return fst;
		}
		
		
		
		/**
		 * 把填充样式列表写入到字节数组
		 * @param data 字节数组
		 */		
		public static function writeFillStyles(data:ByteArray,fillStyles:Vector.<FillStyle>,shapeType:uint):void{
			if(fillStyles.length>=0xff){
				data.writeByte(0xff);
				DInt.writeB(data,fillStyles.length,2,false);
			}else{
				data.writeByte(fillStyles.length);
			}
			 
			for(var i:int=0;i<fillStyles.length;i++){
				writeFillStyle(data,fillStyles[i],shapeType);
			}
		}
		
		public static function writeFillStyle(data:ByteArray,fst:FillStyle,shapeType:uint):void{
			data.writeByte(fst.fillType);
			if(fst.fillType==FillStyleType.SOLID_FILL){
				if(shapeType==ShapeType.Shape1 || shapeType==ShapeType.Shape2){
					DColor.writeColor(data,fst.color,ColorType.RGB);
				}else{
					DColor.writeColor(data,fst.color,ColorType.RGBA);
				}
			}
			
			if(fst.fillType==FillStyleType.FOCAL_RADIAL_GRADIENT_FILL || fst.fillType==FillStyleType.LINEAR_GRADIENT_FILL || fst.fillType==FillStyleType.RADIAL_GRADIENT_FILL){
				DMatrix.writeMatrix(data,fst.gradientMatrix);
			}
			
			if(fst.fillType==FillStyleType.LINEAR_GRADIENT_FILL || fst.fillType==FillStyleType.RADIAL_GRADIENT_FILL){
				Gradient.writeGradient(data,fst.gradient,shapeType);
			}else if(fst.fillType==FillStyleType.FOCAL_RADIAL_GRADIENT_FILL){
				FocalGradient.writeFocalGradient(data,fst.gradient as FocalGradient,shapeType);
			}
			
			if(fst.fillType==FillStyleType.REPEATING_BITMAP_FILL ||fst.fillType==FillStyleType.CLIPPED_BITMAP_FILL || fst.fillType==FillStyleType.NON_SMOOTHED || fst.fillType==FillStyleType.NON_SMOOTHED_CLIPPED){
				DInt.writeB(data,fst.bitmapID,2,false);
				DMatrix.writeMatrix(data,fst.bitmapMatrix);
			}
		}
	}
}