package OopsEngine.Skill
{
	import OopsEngine.Graphics.Animation.AnimationClip;
	import OopsEngine.Graphics.Animation.AnimationFrame;
	import OopsEngine.Graphics.Animation.AnimationPlayer;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class GameSkillData
	{
		
		protected var action:Dictionary = new Dictionary();
		
		private var animationskill:SkillAnimation;
		private var clips:Dictionary  = new Dictionary();			// 动画剪辑集合
		private var frames:Dictionary = new Dictionary();			// 动画帧集合
		private var MiddlePoint:Point;						     	// 动画中心点
		
		
		public function GameSkillData(animationskill:SkillAnimation)
		{
			this.animationskill = animationskill;
		}
		
		
		/** 生成影片剪辑  */
		private function CreateClip(frameIndex:int,clip:AnimationClip):void
		{
			clip.Name    		   = "jn";
			
			clip.Frame.push(frameIndex);
			this.clips[clip.Name] = clip;
		}
		
		/**
		 * 解析动画格式 
		 * @param data
		 * @param 
		 * frames [0] = 需要解析该动画的  x-y （从x帧开始，到y帧结束）
		 * frames [1] = 是否需要翻转，true false
		 * 
		 */      	
		public function Analyze(data:*,frames:Array = null):void
		{
			var mc:MovieClip = data as MovieClip;
			mc.cacheAsBitmap = true;
			
			var beginFrames:int = 1;
			var endFrames:int = mc.totalFrames;
			var TurnType:Boolean = false;
			if(frames != null){
				var fsl:Array =	String(frames[0]).split("-");
				beginFrames = int(fsl[0]);
				try{
					endFrames = int(fsl[1]);
				}catch(e:Error){
					endFrames = int(fsl[0]);
				}
				TurnType = frames[1];
			}
			
			for (var i:uint = beginFrames ; i <= endFrames ; i++)
			{
				mc.gotoAndStop(i);
				var rect:Rectangle = mc.getBounds(mc);
				var matrix:Matrix  = new Matrix();
				matrix.translate(-rect.x,-rect.y);
				var bitmapData:BitmapData = new BitmapData(rect.width, rect.height, true, 0);
				bitmapData.draw(mc, matrix);
				var frame:AnimationFrame  = new AnimationFrame();
				frame.FrameBitmapData     = bitmapData;
				frame.X					  = rect.x;
				frame.Y					  = rect.y;
				frame.Width				  = rect.width;
				frame.Height			  = rect.height;
				//		 		frame.Index				  = i;
				this.frames[(i - beginFrames+1).toString()] = frame;
			}
			
			// 创建影片剪辑
			var clip:AnimationClip = new AnimationClip();
			clip.TurnType = TurnType;
			var whereM:int = (endFrames - beginFrames)+1;
			for (var m:uint = 1 ; m <= whereM ; m++)
			{
				CreateClip(m,clip);
			}
			
			this.animationskill.Clips  = this.clips;
			this.animationskill.Frames = this.frames;
		}
		
		public function SetAnimationData(animationPlayer:SkillAnimation):void
		{
			animationPlayer.Clips     = this.clips;
			animationPlayer.Frames    = this.frames;
		}
	}
}