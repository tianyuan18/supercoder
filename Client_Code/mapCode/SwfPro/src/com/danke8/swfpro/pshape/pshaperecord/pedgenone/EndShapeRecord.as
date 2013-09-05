package com.danke8.swfpro.pshape.pshaperecord.pedgenone
{
	import com.danke8.swfpro.pbasic.DDate;
	import com.danke8.swfpro.pshape.pshaperecord.ShapeRecord;

	/**
	 * 形状末端 
	 * @author 小程序员
	 * 
	 */	
	public class EndShapeRecord extends EdgeNoneRecord
	{

		public var endOfShape:uint=0;
		
		public static function readShapeRecord(dData:DDate):ShapeRecord{
			var record:EndShapeRecord=new EndShapeRecord();
			return record;
		}
		
		public static function writeShapeRecord(dData:DDate,record:EndShapeRecord):void{
			dData.writeUInt(record.endOfShape,5);
		}
	}
}