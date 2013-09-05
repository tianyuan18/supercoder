package com.danke8.swfpro.ptag.pprocess.pshape
{
	import com.danke8.swfpro.pbasic.DInt;
	import com.danke8.swfpro.pbasic.DRectangle;
	import com.danke8.swfpro.pshape.ShapeType;
	import com.danke8.swfpro.pshape.ShapeWithStyle;
	import com.danke8.swfpro.ptag.DTag;
	
	import flash.utils.ByteArray;

	public class T22DefineShape2 extends T02DefineShape1
	{
		public function T22DefineShape2(){
			
			type=22;
		}
		
		public override function read():void{
			characterID=DInt.readB(data,2,false);
			shapeBounds=DRectangle.readRectgle(data);
			shapeStyles=ShapeWithStyle.readShapeWithStyle(data,ShapeType.Shape2);
			
		}
		
		public override function write():void{
			DInt.writeB(data,characterID,2,false);
			DRectangle.writeRectangle(data,shapeBounds);
			ShapeWithStyle.writeShapeWithStyle(data,shapeStyles,ShapeType.Shape2);
		}

	}
}