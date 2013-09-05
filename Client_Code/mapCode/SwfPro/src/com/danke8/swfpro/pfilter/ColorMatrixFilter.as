package com.danke8.swfpro.pfilter
{
	import flash.utils.ByteArray;

	public class ColorMatrixFilter  extends DFilter
	{
		public static function readFilter(data:ByteArray):ColorMatrixFilter{
			var filter:ColorMatrixFilter=new ColorMatrixFilter();
			return filter;
		}
		public static function writeFilter(data:ByteArray,filter:ColorMatrixFilter):void{
			
		}
	}
}