package OopsEngine.Scene.StrategyElement.Person
{
	import OopsEngine.Scene.StrategyElement.GameElementData;
	import OopsEngine.Scene.StrategyElement.GameElementSkins;
	
	import OopsFramework.Collections.DictionaryCollection;
	
	public class GameElementEnemyData extends GameElementData
	{
		public function GameElementEnemyData()
		{
			//													 上		    下           右          右上		右下
			this.action[GameElementSkins.ACTION_STATIC] 	 = ["64-70"   ,"36-42"   ,"50-56"   ,"57-63"  ,"43-49"];
			this.action[GameElementSkins.ACTION_NEAR_ATTACK] = ["29-35"   ,"1-7"     ,"15-21"   ,"22-28"  ,"8-14"];
			this.action[GameElementSkins.ACTION_DEAD] 		 = ["110-111" ,"106-107"   ,"108-109" ,"108-109","108-109"];			// 没有左上、左下方向
			this.action[GameElementSkins.ACTION_RUN] 		 = ["99-105"   ,"71-77"   ,"85-91"   ,"92-98"  ,"78-84"];
		}
		
		public override function Analyze(data:*,frames:DictionaryCollection = null):void
		{
			super.Analyze(data);
		 	
		 	this.CreateActionClips(GameElementSkins.ACTION_STATIC		 , this.action[GameElementSkins.ACTION_STATIC]);
		 	this.CreateActionClips(GameElementSkins.ACTION_NEAR_ATTACK   , this.action[GameElementSkins.ACTION_NEAR_ATTACK]);
		 	this.CreateActionClips(GameElementSkins.ACTION_DEAD			 , this.action[GameElementSkins.ACTION_DEAD]);
		 	this.CreateActionClips(GameElementSkins.ACTION_RUN			 , this.action[GameElementSkins.ACTION_RUN]);
		 	
		}	
	}
}