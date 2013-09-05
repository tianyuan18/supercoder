package com.danke8.swfpro.ptag
{
	import com.danke8.swfpro.DSWF;
	import com.danke8.swfpro.ptag.pprocess.pdisplay.T01ShowFrame;

	public class DankeCharacterUser extends DTag
	{
		/**
		 * 引用的资源id
		 */		
		public var userCharacterID:uint;
		
		public function targets():Vector.<DTag>{
			var targets:Vector.<DTag>=new Vector.<DTag>();
			 
			var c:DankeCharacter=DSWF.characterDic[userCharacterID] as DankeCharacter;
			var cList:Vector.<DankeCharacter>=c.targets();
			for(var i:int=0;i<cList.length;i++){
				targets.push(cList[i]);
			}
			targets.push(this);
			targets.push(new T01ShowFrame());
			return targets;
		}
	}
}