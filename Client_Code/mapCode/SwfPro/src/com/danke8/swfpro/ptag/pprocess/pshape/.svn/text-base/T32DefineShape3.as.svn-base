package com.danke8.swfpro.ptag.pprocess.pshape
{
	import com.danke8.swfpro.DSWF;
	import com.danke8.swfpro.pbasic.DInt;
	import com.danke8.swfpro.pbasic.DRectangle;
	import com.danke8.swfpro.pshape.ShapeType;
	import com.danke8.swfpro.pshape.ShapeWithStyle;
	import com.danke8.swfpro.ptag.DTag;
	import com.danke8.swfpro.ptag.DankeCharacter;
	
	import flash.utils.ByteArray;

	public class T32DefineShape3 extends T02DefineShape1
	{
		public function T32DefineShape3(){
			
			type=32;
		}
		
		public override function read():void{
			characterID=DInt.readB(data,2,false);
			shapeBounds=DRectangle.readRectgle(data);
			shapeStyles=ShapeWithStyle.readShapeWithStyle(data,ShapeType.Shape3);
			if(DSWF.characterDic[characterID]==null){
				DSWF.characterDic[characterID]=this;
			}
		}
		
		public override function write():void{
			DInt.writeB(data,characterID,2,false);
			DRectangle.writeRectangle(data,shapeBounds);
			ShapeWithStyle.writeShapeWithStyle(data,shapeStyles,ShapeType.Shape3);
		}
	}
}