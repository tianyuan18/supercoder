package com.danke8.swfpro.pshape.pshaperecord.pedge
{
	import com.danke8.swfpro.pbasic.DDate;
	import com.danke8.swfpro.pshape.pshaperecord.ShapeRecord;

	/**
	 * 直线边缘 
	 * @author 小程序员
	 */	
	public class StraightEdgeRecord extends EdgeRecord{
		
		public var numBits:uint;
		public var generalLineFlag:Boolean;
		public var vertLineFlag:Boolean;
		public var deltaX:uint;
		public var deltaY:uint;
		
		public static function readShapeRecord(dData:DDate):ShapeRecord{
			var record:StraightEdgeRecord=new StraightEdgeRecord();
			record.straightFlag=true;
			record.numBits=dData.readUInt(4);
			
			record.generalLineFlag=dData.readBoolean();
			if(!record.generalLineFlag){
				record.vertLineFlag=dData.readBoolean();
			}
			if(record.generalLineFlag || !record.vertLineFlag){
				record.deltaX=dData.readUInt(record.numBits+2);
			}
			if(record.generalLineFlag || record.vertLineFlag){
				record.deltaY=dData.readUInt(record.numBits+2);
			}
			return record;
		}
		
		public static function writeShapeRecord(dData:DDate,record:StraightEdgeRecord):void{
			dData.writeUInt(record.numBits,4);
			dData.writeBoolean(record.generalLineFlag);
			if(!record.generalLineFlag){
				dData.writeBoolean(record.vertLineFlag);
			}
			if(record.generalLineFlag || !record.vertLineFlag){
				dData.writeUInt(record.deltaX,record.numBits+2);
			}
			if(record.generalLineFlag || record.vertLineFlag){
				dData.writeUInt(record.deltaY,record.numBits+2);
			}
		}
	}
}