package com.danke8.swfpro.pfilter
{
	import flash.utils.ByteArray;

	public class GradientBevelFilter  extends DFilter
	{
		public static function readFilter(data:ByteArray):GradientBevelFilter{
			var filter:GradientBevelFilter=new GradientBevelFilter();
			return filter;
		}
		public static function writeFilter(data:ByteArray,filter:GradientBevelFilter):void{
			
		}
	}
}