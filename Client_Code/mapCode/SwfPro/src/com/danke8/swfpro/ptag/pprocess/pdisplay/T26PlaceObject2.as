package com.danke8.swfpro.ptag.pprocess.pdisplay{
	import com.danke8.swfpro.pbasic.CxFormWithAlpha;
	import com.danke8.swfpro.pbasic.DInt;
	import com.danke8.swfpro.pbasic.DMatrix;
	import com.danke8.swfpro.pclip.ClipActions;
	import com.danke8.swfpro.ptag.DTag;
	
	import flash.utils.ByteArray;

	
	/**
	 * PlaceObject2
	 */	
	public class T26PlaceObject2  extends T04PlaceObject{
		
		/**
		 * 是否有剪辑动作
		 */		
		public var hasClipActions:Boolean;
		/**
		 * 是否有剪辑深度
		 */		
		public var hasClipDepth:Boolean;
		/**
		 * 是否有名称
		 */		
		public var hasName:Boolean;
		/**
		 * 是否有比率
		 */		
		public var hasRatio:Boolean;
		/**
		 * 是否有颜色转换 
		 */		
		public var hasColorTransform:Boolean;
		/**
		 * 是否有矩阵 
		 */		
		public var hasMatrix:Boolean;
		/**
		 * 是否有字体
		 */		
		public var hasCharacter:Boolean;
		/**
		 * 
		 */		
		public var move:Boolean;
		
		
		/**
		 * 比率
		 */		
		public var ratio:uint;
		/**
		 * 名称
		 */		
		public var name:String;
		/**
		 * 剪辑深度
		 */		
		public var clipDepth:uint;
		/**
		 * 剪辑动作
		 */		
		public var clipActions:ClipActions;
		
		public function T26PlaceObject2(){
			type=26;
		}
		
		public override function read():void{
			
			var tmpStr:String=DInt.toBinary(data.readUnsignedByte());
			hasClipActions=tmpStr.substr(0,1)=="1";
			hasClipDepth=tmpStr.substr(1,1)=="1";
			hasName=tmpStr.substr(2,1)=="1";
			hasRatio=tmpStr.substr(3,1)=="1";
			hasColorTransform=tmpStr.substr(4,1)=="1";
			hasMatrix=tmpStr.substr(5,1)=="1";
			hasCharacter=tmpStr.substr(6,1)=="1";
			move=tmpStr.substr(7,1)=="1";
			
			depth=DInt.readB(data,2,false);
			if(hasCharacter){
				userCharacterID=DInt.readB(data,2,false);
			}
			if(hasMatrix){
				matrix=DMatrix.readMatrix(data);
			}
			if(hasColorTransform){
				colorTransform=CxFormWithAlpha.readCxFormWithAlpha(data);
			}
			if(hasRatio){
				ratio=DInt.readB(data,2,false);
			}
			if(hasName){
				name=data.readUTF();
			}
			if(hasClipDepth){
				clipDepth=DInt.readB(data,2,false);
			}
			if(hasClipActions){
				clipActions=ClipActions.readClipActions(data);
			}
		}
		
		
		public override function write():void{
			outData=new ByteArray();
			var tmpStr:String="";
			tmpStr+=hasClipActions?"1":"0";
			tmpStr+=hasClipDepth?"1":"0";
			tmpStr+=hasName?"1":"0";
			tmpStr+=hasRatio?"1":"0";
			tmpStr+=hasColorTransform?"1":"0";
			tmpStr+=hasMatrix?"1":"0";
			tmpStr+=hasCharacter?"1":"0";
			tmpStr+=move?"1":"0";
			outData.writeByte(parseInt(tmpStr,2));
			
			DInt.writeB(outData,depth,2,false);
			if(hasCharacter){
				DInt.writeB(outData,userCharacterID,2,false);
			}
			if(hasMatrix){
				DMatrix.writeMatrix(outData,matrix);
			}
			if(hasColorTransform){
				CxFormWithAlpha.writeCxFormWithAlpha(outData,colorTransform);
			}
			if(hasRatio){
				DInt.writeB(outData,ratio,2,false);
			}
			if(hasName){
				outData.writeUTF(name);
			}
			if(hasClipDepth){
				DInt.writeB(outData,clipDepth,2,false);
			}
			if(hasClipActions){
				ClipActions.writeClipActions(outData,clipActions);
			}
		}
		 
	}
}