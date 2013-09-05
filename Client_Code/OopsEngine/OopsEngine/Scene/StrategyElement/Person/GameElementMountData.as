package OopsEngine.Scene.StrategyElement.Person
{
	import OopsEngine.Scene.StrategyElement.GameElementData;
	import OopsEngine.Scene.StrategyElement.GameElementSkins;
	
	import OopsFramework.Collections.DictionaryCollection;

	public class GameElementMountData extends GameElementData
	{
		public function GameElementMountData()
		{
			//											  上		        下                 右         右下	      右上	
			this.action[GameElementSkins.ACTION_STATIC]= ["29-35"   ,"1-7"     ,"15-21"   ,"22-28"  ,"8-14"];
			this.action[GameElementSkins.ACTION_RUN]   = ["64-70"   ,"36-42"   ,"50-56"   ,"57-63"  ,"43-49"];

			this.action[GameElementSkins.ACTION_JUMP]		 = ["75-75" ,"71-71" ,"73-73" ,"74-74","72-72"];
			this.action[GameElementSkins.ACTION_JUMP_OVER]		 = ["84-85" ,"76-77" ,"80-81" ,"82-83","78-79"];
		}
		
		public override function Analyze(data:*,frames:DictionaryCollection = null):void
		{
			super.Analyze(data);
			this.CreateActionClips(GameElementSkins.ACTION_STATIC		 , this.action[GameElementSkins.ACTION_STATIC]);
		 	this.CreateActionClips(GameElementSkins.ACTION_RUN			 , this.action[GameElementSkins.ACTION_RUN]);	
			this.CreateActionClips(GameElementSkins.ACTION_JUMP			 , this.action[GameElementSkins.ACTION_JUMP]);
			this.CreateActionClips(GameElementSkins.ACTION_JUMP_OVER	, this.action[GameElementSkins.ACTION_JUMP_OVER]);
		}
	}
}