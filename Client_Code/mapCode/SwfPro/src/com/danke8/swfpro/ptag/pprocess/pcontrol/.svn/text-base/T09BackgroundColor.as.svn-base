package com.danke8.swfpro.ptag.pprocess.pcontrol
{
	import com.danke8.swfpro.pcolor.ColorType;
	import com.danke8.swfpro.pcolor.DColor;
	import com.danke8.swfpro.ptag.DTag;
	
	import flash.utils.ByteArray;

	/**
	 * 背景颜色 
	 */	
	public class T09BackgroundColor extends DTag
	{
		public var color:DColor;
		
		public function T09BackgroundColor(){
			type=9;
		}
		
		public override function read():void{
			color=DColor.readColor(data,ColorType.RGB);
		}
		
		public override function write():void{
			outData=new ByteArray();
			DColor.writeColor(outData,color,ColorType.RGB);
		}
	}
}