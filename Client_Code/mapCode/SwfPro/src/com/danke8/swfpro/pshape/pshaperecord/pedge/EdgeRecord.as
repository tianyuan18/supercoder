package com.danke8.swfpro.pshape.pshaperecord.pedge
{
	import com.danke8.swfpro.pbasic.DDate;
	import com.danke8.swfpro.pshape.pshaperecord.ShapeRecord;
	
	import flash.utils.ByteArray;

	public class EdgeRecord extends ShapeRecord{
		
		/**
		 * 直线标记 
		 */		
		public var straightFlag:Boolean;
		
		public static function readShapeRecord(dData:DDate):ShapeRecord{
			var straightFlag:Boolean=dData.readBoolean();
			if(straightFlag){
				return StraightEdgeRecord.readShapeRecord(dData);
			}else{
				return CurvedEdgeRecord.readShapeRecord(dData);
			}
		}
		
		public static function writeShapeRecord(dData:DDate,record:EdgeRecord):void{
			dData.writeBoolean(record.straightFlag);
			if(record is StraightEdgeRecord){
				StraightEdgeRecord.writeShapeRecord(dData,record as StraightEdgeRecord);
			}else if(record is CurvedEdgeRecord){
				CurvedEdgeRecord.writeShapeRecord(dData,record as CurvedEdgeRecord);
			}
		}
	}
}