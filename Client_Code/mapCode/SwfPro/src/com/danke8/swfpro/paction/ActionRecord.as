package com.danke8.swfpro.paction
{
	import com.danke8.swfpro.pbasic.DInt;
	
	import flash.utils.ByteArray;

	public class ActionRecord
	{
		public var actionCode:int;
		public var len:int;
		
		public static function readActionRecord(data:ByteArray):ActionRecord{
			var actionRecord:ActionRecord=new ActionRecord();
			actionRecord.actionCode=data.readUnsignedByte();
			if(actionRecord.actionCode>0x80){
				actionRecord.len=DInt.readB(data,2,false);
			}
			return actionRecord;
		}
		
		public static function writeActionRecord(data:ByteArray,actionRecord:ActionRecord):void{
			data.writeByte(actionRecord.actionCode);
			if(actionRecord.actionCode>0x80){
				DInt.writeB(data,actionRecord.len,2,false);
			}
		}
	}
}