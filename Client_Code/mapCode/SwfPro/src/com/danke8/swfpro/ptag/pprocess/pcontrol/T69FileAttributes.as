package com.danke8.swfpro.ptag.pprocess.pcontrol
{
	import com.danke8.swfpro.pbasic.DInt;
	import com.danke8.swfpro.ptag.DTag;
	
	import flash.utils.ByteArray;

	/**
	 * FileAttributes
	 */	
	public class T69FileAttributes extends DTag
	{
		/**
		 * 
		 */		
		public var reserved1:Boolean;
		/**
		 * (see note followingtable) 
		 */		
		public var useDirectBlit:Boolean;
		/**
		 * (see note following table) 
		 */		
		public var useGPU:Boolean; 
		/**
		 * 
		 */		
		public var hasMetadata :Boolean;
		/**
		 * 
		 */		
		public var actionScript3:Boolean;
		/**
		 * 
		 */		
		public var reserved2:uint;
		/**
		 * 
		 */		
		public var useNetwork:Boolean;
		/**
		 * 
		 */		
		public var reserved3:uint
		 
		public function T69FileAttributes(){
			type=69;
		}
	  
		public override function read():void{
			
			var tmpStr:String=DInt.toBinary(data.readUnsignedByte());
			reserved1 =tmpStr.substr(0,1)=="1";
			useDirectBlit =tmpStr.substr(1,1)=="1";
			useGPU =tmpStr.substr(2,1)=="1";
			hasMetadata =tmpStr.substr(3,1)=="1";
			actionScript3 =tmpStr.substr(4,1)=="1";
			reserved2 =parseInt(tmpStr.substr(5,2),2);
			useNetwork =tmpStr.substr(7,1)=="1";
			reserved3 =DInt.readB(data,3,false);
		}
		
		public override function write():void{
			outData=new ByteArray();
			var tmpStr:String="";
			tmpStr+=reserved1?"1":"0";
			tmpStr+=useDirectBlit?"1":"0";
			tmpStr+=useGPU?"1":"0";
			tmpStr+=hasMetadata?"1":"0";
			tmpStr+=actionScript3?"1":"0";
			tmpStr+=DInt.toBinary(reserved2,2);
			tmpStr+=useNetwork?"1":"0";
			outData.writeByte(parseInt(tmpStr,2));
			
			DInt.writeB(outData,reserved3,3,false);
		}
	}
}