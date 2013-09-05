package com.danke8.swfpro.ptag
{

	/**
	 * 蛋壳资源类 
	 * @author 小程序员
	 * 
	 */	
	public class DankeCharacter extends DTag
	{
		public var characterID:uint;
		public var isShowFrame:Boolean;
		
		public function targets():Vector.<DankeCharacter>{
			var targets:Vector.<DankeCharacter>=new Vector.<DankeCharacter>();
			targets.push(this);
			return targets;
		}
	}
}