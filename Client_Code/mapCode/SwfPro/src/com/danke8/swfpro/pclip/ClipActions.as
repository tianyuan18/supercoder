package com.danke8.swfpro.pclip{
	import com.danke8.swfpro.pbasic.DInt;
	
	import flash.utils.ByteArray;
	
	public class ClipActions{
		
		public var reserved:uint;
		public var allEventFlags:ClipEventFlags;
		public var clipActionRecords:Vector.<ClipActionRecord>;
		public var clipActionEndFlag:uint;
		
		public static function readClipActions(data:ByteArray):ClipActions{
			var clipActions:ClipActions=new ClipActions();
			clipActions.reserved=DInt.readB(data,4,false);
			clipActions.allEventFlags=ClipEventFlags.readClipEventFlags(data);
			clipActions.clipActionRecords=new Vector.<ClipActionRecord>();
			while(data.position<data.length-5){
				clipActions.clipActionRecords.push(ClipActionRecord.readClipActionRecord(data));
			}
			clipActions.clipActionEndFlag=DInt.readB(data,4,false);
			return clipActions;
		}
		
		public static function writeClipActions(data:ByteArray,clipActions:ClipActions):void{
			DInt.writeB(data,clipActions.reserved,4,false);
			ClipEventFlags.writeClipEventFlags(data,clipActions.allEventFlags);
			for(var i:int=0;i<clipActions.clipActionRecords.length;i++){
				ClipActionRecord.writeClipActionRecord(data,clipActions.clipActionRecords[i]);
			}
			DInt.writeB(data,clipActions.clipActionEndFlag,4,false);
		}
	}
}