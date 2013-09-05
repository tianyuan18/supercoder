package com.danke8.swfpro.pbasic
{
	import flash.utils.ByteArray;

	/**
	 * 
	 */	
	public class CxFormWithAlpha
	{
		public var hasAddTerms:Boolean;
		
		public var hasMultTerms:Boolean;
		
		public var bbits:uint;
		
		public var redMultTerm:uint;
		
		public var greenMultTerm:uint;
		
		public var blueMultTerm:uint;
		
		public var alphaMultTerm:uint;
		
		public var redAddTerm:uint;
		
		public var greenAddTerm:uint;
		
		public var blueAddTerm:uint;
		
		public var alphaAddTerm:uint;
		
		/**
		 * 
		 */		
		public static function readCxFormWithAlpha(data:ByteArray):CxFormWithAlpha{
			
			var cxf:CxFormWithAlpha=new CxFormWithAlpha();
			var dData:DDate=new DDate(data);
			cxf.hasAddTerms=dData.readBoolean();
			cxf.hasMultTerms=dData.readBoolean();
			cxf.bbits=dData.readUInt(2);
			if(cxf.hasMultTerms){
				 
				cxf.redMultTerm=dData.readUInt(cxf.bbits);
				cxf.greenMultTerm=dData.readUInt(cxf.bbits);
				cxf.blueMultTerm=dData.readUInt(cxf.bbits);
				cxf.alphaMultTerm=dData.readUInt(cxf.bbits);
				cxf.redAddTerm=dData.readUInt(cxf.bbits);
				cxf.greenAddTerm=dData.readUInt(cxf.bbits);
				cxf.blueAddTerm=dData.readUInt(cxf.bbits);
				cxf.alphaAddTerm=dData.readUInt(cxf.bbits);
			}
			return cxf;
		}
		
		/**
		 * 
		 * @param data
		 * @param cxf 
		 */		
		public static function writeCxFormWithAlpha(data:ByteArray,cxf:CxFormWithAlpha):void{
			var dData:DDate=new DDate(data);
			dData.writeBoolean(cxf.hasAddTerms);
			dData.writeBoolean(cxf.hasMultTerms);
			dData.writeUInt(cxf.bbits,2);
			if(cxf.hasMultTerms){
				dData.writeUInt(cxf.redMultTerm,cxf.bbits);
				dData.writeUInt(cxf.greenMultTerm,cxf.bbits);
				dData.writeUInt(cxf.blueMultTerm,cxf.bbits);
				dData.writeUInt(cxf.alphaMultTerm,cxf.bbits);
				dData.writeUInt(cxf.redAddTerm,cxf.bbits);
				dData.writeUInt(cxf.greenAddTerm,cxf.bbits);
				dData.writeUInt(cxf.blueAddTerm,cxf.bbits);
				dData.writeUInt(cxf.alphaAddTerm,cxf.bbits);
			}
				
		}
	}
}