package com.danke8.swfpro.ptag.pprocess.pdisplay
{
	import com.danke8.swfpro.pfilter.DFilter;

	public class T70PlaceObject3 extends T26PlaceObject2
	{
		public var reserved:uint;
		public var hasImage:Boolean;
		public var hasClassName:Boolean;
		public var hasCacheAsBitmap:Boolean;
		public var hasBlendMode:Boolean;
		public var hasFilterList:Boolean;
		public var className:String;
		public var surfaceFilterList:Vector.<DFilter>;
		public var blendMode:uint;
		public var bitmapCache:uint;
		
		public function T70PlaceObject3(){
			type=70;
		}

	}
}