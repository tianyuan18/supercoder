package com.danke8.swfpro.ptag.pprocess.pdisplay
{
	import com.danke8.swfpro.pbasic.CxFormWithAlpha;
	import com.danke8.swfpro.pbasic.DInt;
	import com.danke8.swfpro.pbasic.DMatrix;
	import com.danke8.swfpro.ptag.DankeCharacterUser;
	
	import flash.utils.ByteArray;
	
	public class T04PlaceObject  extends DankeCharacterUser
	{
		/**
		 * 深度
		 */		
		public var depth:uint;
		
		/**
		 * 矩阵
		 */		
		public var matrix:DMatrix;
		/**
		 * 颜色转化
		 */		
		public var colorTransform:CxFormWithAlpha;
		
		public function T04PlaceObject(){
			type=4;
		}
		
		public override function read():void{
			
			userCharacterID=DInt.readB(data,2,false);
			depth=DInt.readB(data,2,false);
			matrix=DMatrix.readMatrix(data);
			colorTransform=CxFormWithAlpha.readCxFormWithAlpha(data);
		}
		
		
		public override function write():void{
			outData=new ByteArray();
			DInt.writeB(outData,userCharacterID,2,false);
			DInt.writeB(outData,depth,2,false);
			DMatrix.writeMatrix(outData,matrix);
			CxFormWithAlpha.writeCxFormWithAlpha(outData,colorTransform);
		}
		
	}
}