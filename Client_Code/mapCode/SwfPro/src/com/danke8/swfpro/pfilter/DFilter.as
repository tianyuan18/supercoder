package com.danke8.swfpro.pfilter
{
	import flash.utils.ByteArray;

	/**
	 * 
	 */	
	public class DFilter
	{
		public static function readFilter(data:ByteArray):DFilter{
			var filter:DFilter;
			var type:uint=data.readUnsignedByte();
			if(type==FilterType.DropShadowFilter){
				filter=DropShadowFilter.readFilter(data);
			}
			if(type==FilterType.BlurFilter){
				filter=BlurFilter.readFilter(data);
			}
			if(type==FilterType.GlowFilter){
				filter=GlowFilter.readFilter(data);
			}
			if(type==FilterType.BevelFilter){
				filter=BevelFilter.readFilter(data);
			}
			if(type==FilterType.GradientGlowFilter){
				filter=GradientGlowFilter.readFilter(data);
			}
			if(type==FilterType.ConvolutionFilter){
				filter=ConvolutionFilter.readFilter(data);
			}
			if(type==FilterType.ColorMatrixFilter){
				filter=ColorMatrixFilter.readFilter(data);
			}
			if(type==FilterType.GradientBevelFilter){
				filter=GradientBevelFilter.readFilter(data);
			}
			
			return filter;
		}
		
		public static function writeFilter(data:ByteArray,filter:DFilter):void{
			
			if(filter is DropShadowFilter){
				data.writeByte(FilterType.DropShadowFilter);
				DropShadowFilter.writeFilter(data,filter as DropShadowFilter);
			}
			if(filter is BlurFilter){
				data.writeByte(FilterType.BlurFilter);
				BlurFilter.writeFilter(data,filter as BlurFilter);
			}
			if(filter is DropShadowFilter){
				data.writeByte(FilterType.GlowFilter);
				GlowFilter.writeFilter(data,filter as GlowFilter);
			}
			if(filter is DropShadowFilter){
				data.writeByte(FilterType.BevelFilter);
				BevelFilter.writeFilter(data,filter as BevelFilter);
			}
			if(filter is DropShadowFilter){
				data.writeByte(FilterType.GradientGlowFilter);
				GradientGlowFilter.writeFilter(data,filter as GradientGlowFilter);
			}
			if(filter is DropShadowFilter){
				data.writeByte(FilterType.ConvolutionFilter);
				ConvolutionFilter.writeFilter(data,filter as ConvolutionFilter);
			}
			if(filter is DropShadowFilter){
				data.writeByte(FilterType.ColorMatrixFilter);
				ColorMatrixFilter.writeFilter(data,filter as ColorMatrixFilter);
			}	
			if(filter is DropShadowFilter){
				data.writeByte(FilterType.GradientBevelFilter);
				GradientBevelFilter.writeFilter(data,filter as GradientBevelFilter);
			}
		}
	}
}