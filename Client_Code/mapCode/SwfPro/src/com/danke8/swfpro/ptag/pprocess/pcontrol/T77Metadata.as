package com.danke8.swfpro.ptag.pprocess.pcontrol
{
	import com.danke8.swfpro.pbasic.DEncoded;
	import com.danke8.swfpro.ptag.DTag;
	
	import flash.utils.ByteArray;

	/**
	 * Metadata
	 */	
	public class T77Metadata extends DTag
	{
		public var xml:XML;
		
		public function T77Metadata(){
			type=77;
		}
		
		public override function read():void{
			xml=new XML(data.readMultiByte(data.length,"GB2312"));
		}
		
		public override function write():void{
			data.writeMultiByte(xml.toString(),"GB2312");
		}
	}
}