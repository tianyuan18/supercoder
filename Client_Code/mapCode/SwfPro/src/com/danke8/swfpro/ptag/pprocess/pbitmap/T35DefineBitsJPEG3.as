package com.danke8.swfpro.ptag.pprocess.pbitmap
{
	import com.danke8.swfpro.DSWF;
	import com.danke8.swfpro.pbasic.DInt;
	import com.danke8.swfpro.ptag.DTag;
	import com.danke8.swfpro.ptag.DankeCharacter;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.utils.ByteArray;


	public class T35DefineBitsJPEG3 extends DankeCharacter
	{
		public var alphaDataOffset:uint;
		public var imageData:ByteArray;
		public var bitmapAlphaData:ByteArray;
		
		public var bmp:Bitmap=new Bitmap();
		
		public function T35DefineBitsJPEG3(){
			type=35;
		}
		
		public override function read():void{
			
			characterID=DInt.readB(data,2,false);
			alphaDataOffset=DInt.readB(data,4,false);
			imageData=new ByteArray();
			bitmapAlphaData=new ByteArray();
			data.readBytes(imageData,0,alphaDataOffset);
			data.readBytes(bitmapAlphaData);
			bitmapAlphaData.uncompress();
			
			var loader:Loader=new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(evt:Event):void{
				var bmpData:BitmapData=((evt.currentTarget as LoaderInfo).content as Bitmap).bitmapData;
				bmp.bitmapData=bmpData;
			});
			loader.loadBytes(imageData);
			if(DSWF.characterDic[characterID]==null){
				DSWF.characterDic[characterID]=this;
			}
		}
		
		public override function write():void{
			imageData.position=0;
			bitmapAlphaData.position=0;
			
			outData=new ByteArray();
			DInt.writeB(outData,characterID,2,false);
			DInt.writeB(outData,alphaDataOffset,4,false);
			outData.writeBytes(imageData);
			bitmapAlphaData.compress();
			outData.writeBytes(bitmapAlphaData);
			bitmapAlphaData.uncompress();
		}
	}
}