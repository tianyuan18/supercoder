package com.danke8.swfpro.pbasic
{
	import flash.utils.ByteArray;

	public class Fixed8
	{
		public var x:int;
		
		public var y:int;
		
		public static function readFixed8(data:ByteArray):Fixed8{
			var fix:Fixed8=new Fixed8();
			fix.x=data.readUnsignedByte();
			fix.y=data.readUnsignedByte();
			return fix
		}
		
		public static function writeFixed8(data:ByteArray,fix:Fixed8):void{
			 
			data.writeByte(fix.x);
			data.writeByte(fix.y);
		}
	}
}