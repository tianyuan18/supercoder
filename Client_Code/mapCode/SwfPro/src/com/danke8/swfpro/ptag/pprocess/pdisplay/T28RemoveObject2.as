package com.danke8.swfpro.ptag.pprocess.pdisplay
{
	import com.danke8.swfpro.pbasic.DInt;
	import com.danke8.swfpro.pbasic.RemoveObject2;
	import com.danke8.swfpro.ptag.DTag;
	
	import flash.utils.ByteArray;

	public class T28RemoveObject2 extends DTag
	{
		public var depth:uint;
		
		public function T28RemoveObject2(){
			type=28;
		}
		
		public override function read():void{
			depth= DInt.readB(data,2,false);
		}
		
		public override function write():void{
			DInt.writeB(data,depth,2,false);
		}
		
	}
}