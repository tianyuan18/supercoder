package OopsEngine.Graphics
{
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	public class Font
	{
		public static function Stroke(fontStrokeColor:uint=0):Array
		{
			var txtGF:GlowFilter = new GlowFilter(fontStrokeColor,1,2,2,12);
			var filters:Array = new Array();
			filters.push(txtGF);
			return filters;
		}
		
		public static function equipeTipNameFilters():Array
		{
			var txtDF1:DropShadowFilter = new DropShadowFilter(1,0,0x000000,1,1,1,255,1);
			var txtDF2:DropShadowFilter = new DropShadowFilter(1,90,0x000000,1,1,1,255,1);
			var txtDF3:DropShadowFilter = new DropShadowFilter(1,180,0x000000,1,1,1,255,1);
			var txtDF4:DropShadowFilter = new DropShadowFilter(1,270,0x000000,1,1,1,255,1);
			var filters:Array = new Array();
			filters.push(txtDF1);
			filters.push(txtDF2);
			filters.push(txtDF3);
			filters.push(txtDF4);
			return filters;
		}
		
		/**
		 * 图形变灰滤镜
		 * 
		 **/
		public static function grayFilters():Array {
			var matrix:Array = [
			0.3,0.59,0.11,0,0,
			0.3,0.59,0.11,0,0,
			0.3,0.59,0.11,0,0,
			0,0,0,1,0
			];
			var cf:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			var filters:Array = new Array();
			filters.push(cf);
			return filters;
		}
	}
}