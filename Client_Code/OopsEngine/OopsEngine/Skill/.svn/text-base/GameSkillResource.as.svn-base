package OopsEngine.Skill
{
	import OopsFramework.Content.ContentTypeReader;
	import OopsFramework.Content.Provider.BulkLoaderResourceProvider;
	
	import flash.display.MovieClip;
	
	public class GameSkillResource
	{
		/**动画路径**/
		public var EffectPath:String;
		/**动画名称**/
		public var EffectName:String;
		/** 技能飞行效果动画BulkLoaderResourceProvider */
		public var EffectBR:BulkLoaderResourceProvider = new BulkLoaderResourceProvider();
		/**加载成功**/
		public var OnLoadEffect:Function;
		/**技能编号**/
		public var SkillID:int = 0;
		/**人物编号**/
		public var playerID:int;
		//        /**动画数据**/
		//        public var animationskill:AnimationSkill;
		
		/**动画Datas**/
		public var geeds:Object = new Object();

		
		/**动画加载完成**/
		public function onEffectComplete():void
		{
			if(OnLoadEffect != null)
				OnLoadEffect(this);
		}
		/**
		 * 
		 * frames [0] = 需要解析该动画的  x-y （从x帧开始，到y帧结束）
		 * frames [1] = 是否需要翻转，true false
		 * 
		 */		
		public function GetAnimation(frames:Array = null):SkillAnimation
		{
			var animationSkill:SkillAnimation = new SkillAnimation();
			if(EffectPath != null)
			{
				//        		try
				//        		{
				var fname:String =  'all';
				if(frames !=null)
					fname = frames[0]+frames[1].toString();
				var geed:GameSkillData = geeds[fname];
				if(geed == null)
				{
					var mc:MovieClip =   contentTypeReader.GetMovieClip();
					// 游戏动画数据
					animationSkill       = new SkillAnimation();				
					geed                 = new GameSkillData(animationSkill);
					if(frames != null)
						geed.Analyze(mc,frames);
					else
						geed.Analyze(mc);
					
					geeds[fname] = geed;
				}
				else
				{
					geed.SetAnimationData(animationSkill);
				}
				//	        	}
				//	        	catch(e:Error)
				//	        	{
				//	        		throw new Error("EffectName  "+ EffectName+ "   EffectPath " + EffectPath+e.message);
				//	        	}		
			}
			
			return animationSkill;
		}
		public function get contentTypeReader():ContentTypeReader{
			return EffectBR.GetResource(EffectPath);
		}
		public function clear():void{
			EffectBR = null;
			for(var str:String in geeds){
				delete geeds[str];
			}
			geeds = null;
		}
	}
}