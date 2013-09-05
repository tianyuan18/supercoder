package com.danke8.swfpro.pshape.pshaperecord.pedgenone
{
	import com.danke8.swfpro.pbasic.DDate;
	import com.danke8.swfpro.pbasic.DInt;
	import com.danke8.swfpro.pshape.FillStyle;
	import com.danke8.swfpro.pshape.LineStyle;
	import com.danke8.swfpro.pshape.ShapeType;
	import com.danke8.swfpro.pshape.pshaperecord.ShapeRecord;

	/**
	 * 样式变化 
	 * @author 小程序员
	 * 
	 */	
	public class StyleChangeRecord extends EdgeNoneRecord
	{

		public var stateNewStyles:Boolean;
		public var stateLineStyle:Boolean;
		public var stateFillStyle1:Boolean;
		public var stateFillStyle0:Boolean;
		public var stateMoveTo:Boolean;
		
		public var moveBits:uint;
		public var moveDeltaX:uint;
		public var moveDeltaY:uint;
		public var fillStyle0:uint;
		public var fillStyle1:uint;
		public var lineStyle:uint;
		public var fillStyles:Vector.<FillStyle>
		public var lineStyles:Vector.<LineStyle>
		public var numFillBits:uint;
		public var numLineBits:uint;
		
		public static function readShapeRecord(dData:DDate,fiveP:uint,numFillBits:uint,numLineBits:uint):ShapeRecord{
			
			var record:StyleChangeRecord=new StyleChangeRecord();
			var tmpStr:String=DInt.toBinary(fiveP,5);
			record.stateNewStyles=tmpStr.substr(0,1)=="1";
			record.stateLineStyle=tmpStr.substr(1,1)=="1";
			record.stateFillStyle1=tmpStr.substr(2,1)=="1";
			record.stateFillStyle0=tmpStr.substr(3,1)=="1";
			record.stateMoveTo=tmpStr.substr(4,1)=="1";
			if(record.stateMoveTo){
				record.moveBits=dData.readUInt(5);
				record.moveDeltaX=dData.readUInt(record.moveBits);
				record.moveDeltaY=dData.readUInt(record.moveBits);
			}
			//我靠怎么搞啊
			if(record.stateFillStyle0){
				record.fillStyle0=dData.readUInt(numFillBits);
			}
			if(record.stateFillStyle1){
				record.fillStyle1=dData.readUInt(numFillBits);
			}
			if(record.stateLineStyle){
				record.lineStyle=dData.readUInt(numLineBits);
			}
			if(record.stateNewStyles){
				dData.drop();
				record.fillStyles=FillStyle.readFillStyles(dData.data,ShapeType.Shape1);
				record.lineStyles=LineStyle.readLineStyles(dData.data,ShapeType.Shape1);
				record.numFillBits=dData.readUInt(4);
				record.numLineBits=dData.readUInt(4);
			}
			
			return record;
		}
		
		public static function writeShapeRecord(dData:DDate,record:StyleChangeRecord,numFillBits:uint,numLineBits:uint):void{
			var tmpStr:String="";
			tmpStr+=record.stateNewStyles?"1":"0";
			tmpStr+=record.stateLineStyle?"1":"0";
			tmpStr+=record.stateFillStyle1?"1":"0";
			tmpStr+=record.stateFillStyle0?"1":"0";
			tmpStr+=record.stateMoveTo?"1":"0";
			dData.writeUInt(parseInt(tmpStr,2),5);
			if(record.stateMoveTo){
				dData.writeUInt(record.moveBits,5);
				dData.writeUInt(record.moveDeltaX,record.moveBits);
				dData.writeUInt(record.moveDeltaY,record.moveBits);
			}
			//我靠怎么搞啊
			if(record.stateFillStyle0){
				dData.writeUInt(record.fillStyle0,numFillBits);
			}
			if(record.stateFillStyle1){
				dData.writeUInt(record.fillStyle1,numFillBits);
			}
			if(record.stateLineStyle){
				dData.writeUInt(record.lineStyle,numLineBits);
			}
			if(record.stateNewStyles){
				dData.flush();
				FillStyle.writeFillStyles(dData.data,record.fillStyles,ShapeType.Shape1);
				LineStyle.writeLineStyles(dData.data,record.lineStyles,ShapeType.Shape1);
				dData.writeUInt(record.numFillBits,4);
				dData.writeUInt(record.numLineBits,4);
				dData.flush();
			}
		}
	}
}