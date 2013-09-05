package CreateRole.Login.Audio
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	/** 音乐引擎 */
	public class AudioEngine
	{
		private var sound:Sound;
		private var soundChannel:SoundChannel;
		private var soundTransform:SoundTransform;
		private var volume:Number = 1;
		
		public var Position:Number   = 0;				// 当前播放位置
		public var IsPlaying:Boolean = false;			// 是否播放状态
		public var Loop:int 		 = 1;
		
		/** 音乐播放完成 */
		public var PlayComplete:Function;
		
		/** 音量 */
		public function get Volume():Number
		{
			return this.volume * 100;
		}
		public function set Volume(value:Number):void
		{
			if(value > 100)
			{
				this.volume = 1;
			}
			if(value < 0)
			{
				this.volume = 0;
			}
			else
			{
				this.volume = value / 100;
			}
			
			if(this.IsPlaying==true && this.soundChannel!=null)
			{
			    this.soundTransform              = new SoundTransform(this.volume, 0);
			    this.soundChannel.soundTransform = soundTransform;
			}
		}
		
		public function AudioEngine(soundSource:*)
		{
			if(soundSource is Sound)
			{
				this.sound = soundSource;
			}
			else if(soundSource is String)
			{
				this.sound = new Sound();
				this.sound.load(new URLRequest(soundSource));
			}
			this.sound.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
		}
		
		private function onIOError(e:IOErrorEvent):void
		{
			
		}
		
		private function onComplete(e:Event):void
		{
			this.IsPlaying = false;
			if(PlayComplete!=null) PlayComplete();
		}
		
		/** 播放 */
		public function Play(startTime:Number = 0):void
		{
			if(this.IsPlaying==false)
			{
				this.IsPlaying     				 = true;
				this.soundChannel   			 = this.sound.play(startTime,Loop);				// 声卡没驱动会为空
				if(this.soundChannel!=null)				
				{
					this.soundTransform              = new SoundTransform(this.volume, 0);
					this.soundChannel.soundTransform = soundTransform;
					this.soundChannel.addEventListener(Event.SOUND_COMPLETE,onComplete);
				}
				else
				{
					this.IsPlaying = false;
				}
			}
		}
		
		/** 暂停 */
		public function Pause():void
		{
			if(IsPlaying==true)
			{
				this.Position = soundChannel.position;
				this.Stop();
			}
			else
			{
				this.Play(this.Position);
			}
		}
		
		/** 停止 */
		public function Stop():void
		{
			if(this.IsPlaying==true)
			{
				this.PlayComplete = null;
				
				this.sound.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
				this.soundChannel.removeEventListener(Event.SOUND_COMPLETE,onComplete);
				
				if(this.soundChannel!=null)
				{
					this.soundChannel.stop();
					this.soundChannel = null;
				}
				this.soundTransform = null
				this.sound		    = null;
				this.IsPlaying      = false;
			}
		}
		
		public function get _sound():Sound
		{
			return this.sound;
		}
		
		public function get _soundChannel():SoundChannel
		{
			return this.soundChannel;
		}
		
		public function get _soundTransform():SoundTransform
		{
			return this.soundTransform;
		}
	}
}