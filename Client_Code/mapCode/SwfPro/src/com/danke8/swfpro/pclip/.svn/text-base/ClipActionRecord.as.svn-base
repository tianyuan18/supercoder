package com.danke8.swfpro.pclip{
	import com.danke8.swfpro.paction.ActionRecord;
	
	import flash.utils.ByteArray;
	
	public class ClipActionRecord{
		
		public var eventFlags:ClipEventFlags;
		public var actionRecordSize:uint;
		public var keyCode:uint;
		public var actions:Vector.<ActionRecord>;
		
		public static function readClipActionRecord(data:ByteArray):ClipActionRecord{
			var car:ClipActionRecord=new ClipActionRecord();
			car.eventFlags=ClipEventFlags.readClipEventFlags(data);
			if(car.eventFlags.clipEventKeyPress){
				car.keyCode=data.readUnsignedByte();
			}
			car.actions=new Vector.<ActionRecord>();
			while(data.position<data.length-1){
				car.actions.push(ActionRecord.readActionRecord(data));
			}
			return car;
		}
		
		public static function writeClipActionRecord(data:ByteArray,car:ClipActionRecord):void{
			ClipEventFlags.writeClipEventFlags(data,car.eventFlags);
			if(car.eventFlags.clipEventKeyPress){
				data.writeByte(car.keyCode);
			}
			for(var i:int=0;i<car.actions.length;i++){
				ActionRecord.writeActionRecord(data,car.actions[i]);
			}
		}
	}
}