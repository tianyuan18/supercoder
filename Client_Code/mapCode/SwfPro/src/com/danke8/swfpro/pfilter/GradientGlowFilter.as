package com.danke8.swfpro.pfilter
{
	import flash.utils.ByteArray;

	public class GradientGlowFilter  extends DFilter
	{
		public static function readFilter(data:ByteArray):GradientGlowFilter{
			var filter:GradientGlowFilter=new GradientGlowFilter();
			return filter;
		}
		public static function writeFilter(data:ByteArray,filter:GradientGlowFilter):void{
			
		}
	}
}