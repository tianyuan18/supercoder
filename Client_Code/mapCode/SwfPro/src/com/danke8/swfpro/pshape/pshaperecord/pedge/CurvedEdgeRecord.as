package com.danke8.swfpro.pshape.pshaperecord.pedge
{
	import com.danke8.swfpro.pbasic.DDate;
	import com.danke8.swfpro.pshape.pshaperecord.ShapeRecord;

	/**
	 * 曲线边缘 
	 * @author 小程序员
	 */	
	public class CurvedEdgeRecord extends EdgeRecord{
		
		public var numBits:uint;
		
		public var controlDeltaX:uint;
		
		public var controlDeltaY:uint;
		
		public var anchorDeltaX:uint;
		
		public var anchorDeltaY:uint;
		
		
		public static function readShapeRecord(dData:DDate):ShapeRecord{
			var record:CurvedEdgeRecord=new CurvedEdgeRecord();
			record.straightFlag=false;
			record.numBits=dData.readUInt(4);
			record.controlDeltaX=dData.readUInt(record.numBits+2);
			record.controlDeltaY=dData.readUInt(record.numBits+2);
			record.anchorDeltaX=dData.readUInt(record.numBits+2);
			record.anchorDeltaY=dData.readUInt(record.numBits+2);
			return record;
		}
		
		
		public static function writeShapeRecord(dData:DDate,record:CurvedEdgeRecord):void{
			dData.writeUInt(record.numBits,4);
			dData.writeUInt(record.controlDeltaX,record.numBits+2);
			dData.writeUInt(record.controlDeltaY,record.numBits+2);
			dData.writeUInt(record.anchorDeltaX,record.numBits+2);
			dData.writeUInt(record.anchorDeltaY,record.numBits+2);
		}
	}
}