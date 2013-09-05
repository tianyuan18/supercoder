package OopsEngine.Scene.StrategyElement.Person
{
	import OopsEngine.Scene.StrategyElement.GameElementData;
	import OopsEngine.Scene.StrategyElement.GameElementSkins;
	
	import OopsFramework.Collections.DictionaryCollection;
	
	import flash.display.MovieClip;

	public class GameElementNPCData extends GameElementData
	{
		public function GameElementNPCData(animationData:Object = null)
		{
			if (!animationData)
			{
//														   上	     下        左       左上	 左下
				this.action[GameElementSkins.ACTION_STATIC] = ["1-5"   ,"1-5"     ,"1-5"   ,"1-5"  ,"1-5"];
				this.action[GameElementSkins.ACTION_RUN] 	= ["1-5"   ,"1-5"     ,"1-5"   ,"1-5"  ,"1-5"];
			}
			else
			{
				for (var k:String in animationData)
				{
					this.action[k] = animationData[k];
				}
			}
		}
		
		public override function Analyze(data:*,frames:DictionaryCollection = null):void
		{
			
			try{
				var mc:MovieClip = data as MovieClip;
				var mcf:String = "1-"+mc.totalFrames;
				this.action[GameElementSkins.ACTION_STATIC] = [mcf,mcf,mcf,mcf,mcf];
				this.action[GameElementSkins.ACTION_RUN] 	= [mcf,mcf,mcf,mcf,mcf];
			}catch(e:Error){
				
			}
			
		 	this.CreateActionClips(GameElementSkins.ACTION_STATIC		 , this.action[GameElementSkins.ACTION_STATIC]);
		 	this.CreateActionClips(GameElementSkins.ACTION_RUN			 , this.action[GameElementSkins.ACTION_RUN]);
		 	
			super.Analyze(data);
		}
	}
}