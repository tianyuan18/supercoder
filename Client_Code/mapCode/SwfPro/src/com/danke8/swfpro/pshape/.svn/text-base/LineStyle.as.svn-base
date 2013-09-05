package com.danke8.swfpro.pshape
{
	import com.danke8.swfpro.pbasic.DInt;
	import com.danke8.swfpro.pcolor.ColorType;
	import com.danke8.swfpro.pcolor.DColor;
	
	import flash.utils.ByteArray;

	/**
	 * 线条样式 
	 */	
	public class LineStyle
	{
		/**
		 * 
		 */		
		public var width:uint;
		/**
		 * 
		 */		
		public var color:DColor;
		
		public function LineStyle(){
			
		}
		
		/**
		 * 从字节数组读取线条样式列表 
		 * @param data
		 * @param shapeType
		 * @return 
		 * 
		 */		
		public static function readLineStyles(data:ByteArray,shapeType:uint):Vector.<LineStyle>{
			var styleCount:int=data.readUnsignedByte();
			if(styleCount==0xff){
				styleCount=DInt.readB(data,2,false);
			}
			var styles:Vector.<LineStyle>=new Vector.<LineStyle>();
			for(var i:int=0;i<styleCount;i++){
				if(shapeType!=ShapeType.Shape4){
					var style:LineStyle=readLineStyle(data,shapeType);
					styles.push(style);
				}
			}
			return styles;
		}
		
		/**
		 * 从字节数组读取线条样式 
		 * @param data
		 * @param shapeType
		 * @return 
		 * 
		 */		
		public static function readLineStyle(data:ByteArray,shapeType:uint):LineStyle{
			var ls:LineStyle= new LineStyle();
			ls.width=DInt.readB(data,2,false);
			if(shapeType==ShapeType.Shape1 || shapeType==ShapeType.Shape2){
				ls.color=DColor.readColor(data,ColorType.RGB);
			}else if(shapeType==ShapeType.Shape3){
				ls.color=DColor.readColor(data,ColorType.RGBA);
			}
			return ls;
		}
		
		/**
		 * 将线条样式列表写入字节数组 
		 * @param data
		 * @param styles
		 * @param shapeType
		 * 
		 */		
		public static function writeLineStyles(data:ByteArray,styles:Vector.<LineStyle>,shapeType:uint):void{
			if(styles.length>=0xff){
				data.writeByte(0xff);
				DInt.writeB(data,styles.length,2,false);
			}else{
				data.writeByte(styles.length);
			}
			for(var i:int=0;i<styles.length;i++){
				if(shapeType!=ShapeType.Shape4){
					writeLineStyle(data,styles[i],shapeType);
				}
			} 
		}
		
		/**
		 * 将线条样式写入字节数组 
		 * @param data
		 * @param ls
		 * @param shapeType
		 * 
		 */		
		public static function writeLineStyle(data:ByteArray,ls:LineStyle,shapeType:uint):void{
			DInt.writeB(data,ls.width,2,false);
			if(shapeType==ShapeType.Shape1 || shapeType==ShapeType.Shape2){
				DColor.writeColor(data,ls.color,ColorType.RGB);
			}else if(shapeType==ShapeType.Shape3){
				DColor.writeColor(data,ls.color,ColorType.RGBA);
			}
		}
	}
}











