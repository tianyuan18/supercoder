package com.danke8.swfpro.pfilter
{
	import flash.utils.ByteArray;

	public class DropShadowFilter extends DFilter
	{
		public static function readFilter(data:ByteArray):DropShadowFilter{
			var filter:DropShadowFilter=new DropShadowFilter();
			return filter;
		}
		public static function writeFilter(data:ByteArray,filter:DropShadowFilter):void{
			
		}
	}
}