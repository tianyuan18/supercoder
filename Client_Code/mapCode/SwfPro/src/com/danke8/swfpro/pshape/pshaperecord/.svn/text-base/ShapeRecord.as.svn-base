package com.danke8.swfpro.pshape.pshaperecord
{
	import com.danke8.swfpro.pbasic.DDate;
	import com.danke8.swfpro.pshape.pshaperecord.pedge.EdgeRecord;
	import com.danke8.swfpro.pshape.pshaperecord.pedgenone.EdgeNoneRecord;
	import com.danke8.swfpro.pshape.pshaperecord.pedgenone.EndShapeRecord;
	
	import flash.utils.ByteArray;

	/**
	 * 形状记录 
	 * @author 小程序员
	 * 
	 */	
	public class ShapeRecord
	{
		/**
		 * 类型标记 
		 */		
		public var typeFlag:Boolean;
		
		
		public static function readShapeRecords(data:ByteArray,numFillBits:uint,numLineBits:uint):Vector.<ShapeRecord>{
			var shapeRecords:Vector.<ShapeRecord>=new Vector.<ShapeRecord>();
			var dData:DDate=new DDate(data);
			while(data.position<data.length){
				var type:Boolean=dData.readBoolean()
				var shapeRecord:ShapeRecord;
				if(type){
					shapeRecord= EdgeRecord.readShapeRecord(dData);
					shapeRecord.typeFlag=true;
				}else{
					shapeRecord= EdgeNoneRecord.readShapeRecord(dData,numFillBits,numLineBits);
					shapeRecord.typeFlag=false;
				}
				shapeRecords.push(shapeRecord);
			}
			dData.drop();
			return shapeRecords;
		}
		
		public static function writeShapeRecords(data:ByteArray,records:Vector.<ShapeRecord>,numFillBits:uint,numLineBits:uint):void{
			var dData:DDate=new DDate(data);
			for(var i:int=0;i<records.length;i++){
				if(records[i] is EdgeRecord){
					dData.writeBoolean(true);
					EdgeRecord.writeShapeRecord(dData,records[i] as EdgeRecord);
				}else if(records[i] is EdgeNoneRecord){
					dData.writeBoolean(false);
					EdgeNoneRecord.writeShapeRecord(dData,records[i] as EdgeNoneRecord,numFillBits,numLineBits);
				}
			}
			dData.flush();
		}
	}
}