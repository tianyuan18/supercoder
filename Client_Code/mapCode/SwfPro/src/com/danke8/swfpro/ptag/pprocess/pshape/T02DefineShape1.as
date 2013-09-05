package com.danke8.swfpro.ptag.pprocess.pshape
{
	import com.danke8.swfpro.DSWF;
	import com.danke8.swfpro.pbasic.DInt;
	import com.danke8.swfpro.pbasic.DRectangle;
	import com.danke8.swfpro.pshape.FillStyle;
	import com.danke8.swfpro.pshape.FillStyleType;
	import com.danke8.swfpro.pshape.ShapeType;
	import com.danke8.swfpro.pshape.ShapeWithStyle;
	import com.danke8.swfpro.ptag.DTag;
	import com.danke8.swfpro.ptag.DankeCharacter;
	
	import flash.utils.ByteArray;


	/**
	 * 
	 */	
	public class T02DefineShape1 extends DankeCharacter
	{
		public var shapeBounds:DRectangle;
		public var shapeStyles:ShapeWithStyle;
		
		public function T02DefineShape1(){
			
			type=2;
		}
		
		public override function read():void{
			characterID=DInt.readB(data,2,false);
			shapeBounds=DRectangle.readRectgle(data);
			shapeStyles=ShapeWithStyle.readShapeWithStyle(data,ShapeType.Shape1);
			if(DSWF.characterDic[characterID]==null){
				DSWF.characterDic[characterID]=this;
			}
		}
		
		public override function write():void{
			outData=new ByteArray();
			DInt.writeB(outData,characterID,2,false);
			DRectangle.writeRectangle(outData,shapeBounds);
			ShapeWithStyle.writeShapeWithStyle(outData,shapeStyles,ShapeType.Shape1);
		}
		
		public override function targets():Vector.<DankeCharacter>{
			var targets:Vector.<DankeCharacter>=new Vector.<DankeCharacter>();
			for(var i:int;i<shapeStyles.fillStyles.length;i++){
				var sItem:FillStyle=shapeStyles.fillStyles[i];
				if(sItem.fillType==FillStyleType.NON_SMOOTHED_CLIPPED || sItem.fillType==FillStyleType.REPEATING_BITMAP_FILL || sItem.fillType==FillStyleType.CLIPPED_BITMAP_FILL || sItem.fillType==FillStyleType.NON_SMOOTHED){
					var c:DankeCharacter=DSWF.characterDic[sItem.bitmapID] as DankeCharacter;
					if(c!=null){
						targets.push(c);
					}
				}
			}
			targets.push(this);
			return targets;
		}
		
	}
}