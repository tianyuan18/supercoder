package com.danke8.swfpro.pbasic
{
	import flash.utils.ByteArray;

	public class RemoveObject2
	{
		public var depth:uint;
		
		public static function readRemoveObject2(data:ByteArray):RemoveObject2{
			var ro2:RemoveObject2=new RemoveObject2();
			ro2.depth= DInt.readB(data,2,false);
			return ro2;
		}
		
		public static function writeRemoveObject2(data:ByteArray,ro2:RemoveObject2):void{
			DInt.writeB(data,ro2.depth,2,false);
		}
	}
}