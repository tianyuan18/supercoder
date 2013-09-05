package OopsEngine.Utils
{
	import OopsEngine.Graphics.Animation.AnimationClip;
	import OopsEngine.Graphics.Animation.AnimationFrame;
	
	import OopsFramework.GameTime;
	import OopsFramework.IUpdateable;
	import OopsFramework.Utils.Timer;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	
	public class MovieAnimation extends Bitmap implements IUpdateable
	{
		public static const LOOP   : int = -1;						// 无限循环
		public static const SINGLE : int = 1;						// 播放一次
		
		public var PlayCompleteParam:Array = new Array();
		public var PlayComplete:Function;							// 播放完成一件事件
		public var PlayFrame:Function;								// 帧事件
		public var skillID:int = 0;
		
		public var Frames:Dictionary = new Dictionary();								// 动画帧集合
		public var MaxWidth:int = 0;									// 动画最大宽
		public var MaxHeight:int = 0;									// 动画最大高
		public var totalFrames:int = 0;
		protected var playCount:int;								// 已播放次数
		protected var playMaxCount:int  = LOOP;						// 最大已播放次数
		protected var isPlaying:Boolean = true;					// 是否正在播放
		
		protected var clipName:String;
		
		public  var IsPlayComplete:Boolean = false;                 //是否播放完成
		
		public var CurrentClipFrameIndex:int = 1;
		
		public var frameRate:Timer = new Timer();								// 动画帧速控制
		
		/** 每秒多少帧（默认24帧）*/
		public function get FrameRate():uint
		{
			return this.frameRate.Frequency;
		}
		public function set FrameRate(value:uint):void
		{
			this.frameRate.Frequency = value; 
		}
		
		public function MovieAnimation(mc:MovieClip){
			Analyze(mc);
			this.Play();
		}
		
		private var AnalyzeI:int = 0;
		private var AnalyzeLen:int = 0;
		/**
		 * 每次解析动画帧数 (可调整)
		 */		
		public var AnalyzeSize:int = 50;
		/**
		 * 每次解析动画的时间间隔(可调整) 
		 */		
		public var AnalyzeTime:int = 200;
		private function Analyze(mc:MovieClip):void{
			
			totalFrames = mc.totalFrames;
			
			if(totalFrames <= AnalyzeSize){
				AnalyzeSize = totalFrames;
			}
				
			AnalyzeLen = Math.ceil(totalFrames/AnalyzeSize); 
				
			for (var i:uint = (1+(AnalyzeSize*AnalyzeI)) ; i <= ((AnalyzeI+1)*AnalyzeSize) ; i++)
			{
				if(i > totalFrames)
					break;
				
				mc.gotoAndStop(i);
				
				var rect:Rectangle = mc.getBounds(mc);
				var bitmapData:BitmapData = new BitmapData(rect.width, rect.height, true, 0);
				bitmapData.draw(mc,new Matrix(1, 0, 0, 1, -rect.x, -rect.y));
				var frame:AnimationFrame  = new AnimationFrame();
				frame.FrameBitmapData     = bitmapData;
				frame.X					  = rect.x;
				frame.Y					  = rect.y;
				frame.Width				  = rect.width;
				frame.Height			  = rect.height;
				if(MaxWidth < rect.width)
					MaxWidth = rect.width;
				if(MaxHeight < rect.height)
					MaxHeight = rect.height;
				
				this.Frames[i] = frame;
			}
			AnalyzeI++;
			if(AnalyzeI < AnalyzeLen)
				setTimeout(Analyze,AnalyzeTime,mc);	
		}
		
		public function AnimationPlayer(playMaxCount:int = LOOP):void
		{
        	this.playMaxCount  = playMaxCount;
        	this.cacheAsBitmap = true;
		}
		
		/** 播放动画 */
		public function Play():void
		{
			this.playCount			 = 0;
		    var frame:AnimationFrame = this.Frames[CurrentClipFrameIndex] as AnimationFrame;
		    
		    this.CalculateOffset(frame);
			this.bitmapData = frame.FrameBitmapData;
			
			// 剪辑只有一帧时，组件不在更新帧了（因为FALSH有封装了重绘过程，设置了第一帧就可以了）
			if(totalFrames > 1)
			{
				this.isPlaying = true;
			}
			else
			{
				if(PlayFrame!=null) PlayFrame(CurrentClipFrameIndex);
				this.isPlaying = false;
			}
		}
		
		public function gotoAndPlay(frame:int):void{
			CurrentClipFrameIndex = frame-1;
			if(CurrentClipFrameIndex <= 0)
				CurrentClipFrameIndex = 1;
			Play();
		}
		
		/** 暂停动画 */
		public function Pause():void
		{
			if(this.isPlaying == true)
			{
				this.isPlaying = false;
			}
			else
			{
				this.isPlaying = true;
			}
		}
		
		
		/** 动画帧更新新 */
        public function Update(gameTime:GameTime):void
		{
			if(frameRate.IsNextTime(gameTime))
			{
	            if(this.isPlaying)
	            {
	            	if((this.playMaxCount == LOOP || this.playCount < this.playMaxCount))
	            	{
		            	// 当前影片剪辑动画指针递增
						CurrentClipFrameIndex++;				
		        
		            	// 判断是否进去下一个动画循环
		            	if(CurrentClipFrameIndex > totalFrames)
		            	{
							CurrentClipFrameIndex = 1;
		            		this.playCount++;
		            		if(PlayComplete!=null) PlayComplete(this,PlayCompleteParam); 
		            	}
	
						if(this.playMaxCount == LOOP || this.playCount < this.playMaxCount)
		            	{
			            	var frame:AnimationFrame = this.Frames[CurrentClipFrameIndex] as AnimationFrame;
							this.bitmapData = frame.FrameBitmapData;
							this.CalculateOffset(frame);
			            	if(PlayFrame!=null) PlayFrame(CurrentClipFrameIndex);
		            	}
		            	else
		            	{
							this.isPlaying = false;
		            	}
		            }
	            }
            }
		}
		
		
		/**  */
		private function CalculateOffset(frame:AnimationFrame):void
		{
			super.x = frame.X+offsetX;
			super.y = frame.Y+offsetY;
		}
		public var offsetX:Number = 0;	
		public var offsetY:Number = 0;	
		
		public override function set x(value:Number):void{
			var frame:AnimationFrame = this.Frames[CurrentClipFrameIndex] as AnimationFrame;
			offsetX = value;
			super.x = frame.X + offsetX;
		}
		public override function get x():Number{
			return offsetX;
		}
		
		public override function set y(value:Number):void{
			var frame:AnimationFrame = this.Frames[CurrentClipFrameIndex] as AnimationFrame;
			offsetY = value;			
			super.y = frame.Y + offsetY;
		}
		public override function get y():Number{
			return offsetY;
		}
		
		public override function get width():Number{
			return this.MaxWidth;
		}
		public override function get height():Number{
			return this.MaxHeight;
		}
		
		public function get UpdateOrder():int{return 0}			// 更新优先级（数值小的优先更新）
		public function get EnabledChanged():Function{return null};
		public function set EnabledChanged(value:Function):void{};
		public function get UpdateOrderChanged():Function{return null};
		public function set UpdateOrderChanged(value:Function):void{};
		private var enabled:Boolean = true;
		public function get Enabled():Boolean
		{
			return enabled;
		}
	}
}