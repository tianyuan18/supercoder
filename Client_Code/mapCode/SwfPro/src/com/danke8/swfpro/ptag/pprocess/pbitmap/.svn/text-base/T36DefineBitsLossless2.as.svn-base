package com.danke8.swfpro.ptag.pprocess.pbitmap
{
	import com.danke8.swfpro.DSWF;
	import com.danke8.swfpro.pbasic.AlphaBitmapData;
	import com.danke8.swfpro.pbasic.AlphaColorMapData;
	import com.danke8.swfpro.pbasic.AlphaData;
	import com.danke8.swfpro.pbasic.DInt;
	import com.danke8.swfpro.ptag.DTag;
	import com.danke8.swfpro.ptag.DankeCharacter;
	
	import flash.utils.ByteArray;


	
	public class T36DefineBitsLossless2  extends DankeCharacter
	{
		public var bitmapFormat:uint;
		public var bitmapWidth:uint;
		public var bitmapHeight:uint;
		public var bitmapColorTableSize:uint;
		public var zlibBitmapData:AlphaData;
		
		public function T36DefineBitsLossless2(){
			type=36;
		}
		
		public override  function read():void{
			 
			characterID=DInt.readB(data,2,false);
			bitmapFormat=data.readUnsignedByte();
			bitmapWidth=DInt.readB(data,2,false);
			bitmapHeight=DInt.readB(data,2,false);
			var sizeTmp:uint=bitmapWidth*bitmapHeight;
			if(bitmapFormat==3){
				bitmapColorTableSize=data.readUnsignedByte();
				zlibBitmapData=AlphaColorMapData.readAlphaColorMapData(data,bitmapColorTableSize,sizeTmp);
			}else if(bitmapFormat==4 || bitmapFormat==5){
				zlibBitmapData=AlphaBitmapData.readAlphaBitmapData(data,sizeTmp);
			} 
			if(DSWF.characterDic[characterID]==null){
				DSWF.characterDic[characterID]=this;
			}
		}
		
		public override function write():void{
			
		}
	}
}