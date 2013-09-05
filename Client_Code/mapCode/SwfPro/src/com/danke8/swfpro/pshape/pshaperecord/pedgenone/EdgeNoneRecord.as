package com.danke8.swfpro.pshape.pshaperecord.pedgenone
{
	import com.danke8.swfpro.pbasic.DDate;
	import com.danke8.swfpro.pshape.pshaperecord.ShapeRecord;
	
	import flash.utils.ByteArray;

	public class EdgeNoneRecord extends ShapeRecord
	{
		public static function readShapeRecord(dData:DDate,numFillBits:uint,numLineBits:uint):ShapeRecord{
			var EndOfShapeFlag:uint=dData.readUInt(5);
			var record:ShapeRecord;
			if(EndOfShapeFlag==0){
				record= EndShapeRecord.readShapeRecord(dData);
			}else{
				record= StyleChangeRecord.readShapeRecord(dData,EndOfShapeFlag,numFillBits,numLineBits);
			}
			record.typeFlag=false;
			return record;
		}
		
		public static function writeShapeRecord(dData:DDate,shapeRecord:EdgeNoneRecord,numFillBits:uint,numLineBits:uint):void{
			
			if(shapeRecord is EndShapeRecord){
				EndShapeRecord.writeShapeRecord(dData,shapeRecord as EndShapeRecord);
			}else if(shapeRecord is StyleChangeRecord){
				StyleChangeRecord.writeShapeRecord(dData,shapeRecord as StyleChangeRecord,numFillBits,numLineBits);
			}
		}
	}
}