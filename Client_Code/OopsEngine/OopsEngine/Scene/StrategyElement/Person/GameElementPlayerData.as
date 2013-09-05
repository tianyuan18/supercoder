package OopsEngine.Scene.StrategyElement.Person
{
	import OopsEngine.Scene.StrategyElement.GameElementData;
	import OopsEngine.Scene.StrategyElement.GameElementSkins;
	
	import OopsFramework.Collections.DictionaryCollection;
	
	import flash.utils.getTimer;
	
	public class GameElementPlayerData extends GameElementData
	{		
		
		public function GameElementPlayerData()
		{
			//													 上		        下                右         右下	      右上
			this.action[GameElementSkins.ACTION_NEAR_ATTACK] = ["29-35"   ,"1-7"     ,"15-21"   ,"22-28"  ,"8-14"];
			this.action[GameElementSkins.ACTION_NEAR_ATTACK1] = ["64-70"   ,"36-42"   ,"50-56"   ,"57-63"  ,"43-49"];
			this.action[GameElementSkins.ACTION_STATIC] 	 = ["99-105"  ,"71-77"   ,"85-91"   ,"92-98"  ,"78-84"];
			this.action[GameElementSkins.ACTION_RUN] 		 =  ["134-140" ,"106-112" ,"120-126" ,"127-133","113-119"];
			this.action[GameElementSkins.ACTION_DEAD] 		 =	["145-146" ,"141-142" ,"143-144" ,"143-144","143-144"];// 没有左上、左下方向;
			this.action[GameElementSkins.ACTION_JUMP]		 = ["151-151" ,"147-147" ,"149-149" ,"150-150","148-148"];;//
			this.action[GameElementSkins.ACTION_JUMP_OVER]		 = ["168-171" ,"152-155" ,"160-163" ,"164-167","156-159"];
		}
		
		public override function Analyze(data:*,frames:DictionaryCollection = null):void
		{
			super.Analyze(data);
		 	
		 	this.CreateActionClips(GameElementSkins.ACTION_STATIC		 , this.action[GameElementSkins.ACTION_STATIC]);
			this.CreateActionClips(GameElementSkins.ACTION_NEAR_ATTACK   , this.action[GameElementSkins.ACTION_NEAR_ATTACK]);
			this.CreateActionClips(GameElementSkins.ACTION_NEAR_ATTACK1   , this.action[GameElementSkins.ACTION_NEAR_ATTACK1]);
		 	this.CreateActionClips(GameElementSkins.ACTION_DEAD			 , this.action[GameElementSkins.ACTION_DEAD]);
			this.CreateActionClips(GameElementSkins.ACTION_RUN			 , this.action[GameElementSkins.ACTION_RUN]);
			this.CreateActionClips(GameElementSkins.ACTION_JUMP			 , this.action[GameElementSkins.ACTION_JUMP]);
			this.CreateActionClips(GameElementSkins.ACTION_JUMP_OVER	, this.action[GameElementSkins.ACTION_JUMP_OVER]);
		}
	}
}