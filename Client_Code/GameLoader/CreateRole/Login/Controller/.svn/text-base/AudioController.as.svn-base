package CreateRole.Login.Controller
{
	import CreateRole.Login.Audio.AudioEngine;
	
	import Data.GameLoaderData;
	
	import flash.events.Event;
	
	
	/** 游戏音频控制  */
	public class AudioController
	{	
		/** 门派声音 */
		public static var homeSound:AudioEngine;
		/** 登录背景音乐 */
		public static var loginBgSound:AudioEngine;	
		
		
		
		
		
		/** 门派音效  */
		public static function SoundHomeOn(soundSource:*):void
		{
			if(GameLoaderData.isOpenSoundSwitch == false)
			{
				return;
			}
			homeSound = new AudioEngine(soundSource);//GameCommonData.GameInstance.Content.Load("Resources/GameDLC/" + contentPath).GetClassBySound(SoundName));
			homeSound.Loop = 1;
			homeSound.Play();
			homeSound.Volume = 100;
			if(loginBgSound) loginBgSound.Volume = 30;
		}
		/** 门派音效关闭 */
		public static function SoundHomeOff():void
		{
			if(homeSound)
			{
				homeSound.Stop();
				homeSound = null;
				if(loginBgSound) loginBgSound.Volume = 60;
			}
		}
		/** 登录背景音乐  */
		public static function SoundLoginOn():void
		{
			if(GameLoaderData.isOpenSoundSwitch == false)
			{
				return;
			}
			loginBgSound = new AudioEngine(GameLoaderData.outsideDataObj.SourceURL + "LoginSound.mp3");
			loginBgSound.PlayComplete = SoundComplete;			
			loginBgSound.Volume = 100;
			loginBgSound.Play();
		}
		
		public static function SoundComplete():void
		{
		    if(GameLoaderData.isOpenSoundSwitch == false)
			{
				return;
			}
			if(loginBgSound != null)
			{
				loginBgSound = new AudioEngine(GameLoaderData.outsideDataObj.SourceURL + "LoginSound.mp3");
				loginBgSound.PlayComplete = SoundComplete;	
			}		
			loginBgSound.Volume = 100;
			loginBgSound.Play();
		}
		
		
		/** 关闭背景音乐 */
		public static function SoundLoginOff():void
		{
			if(loginBgSound)
			{
				loginBgSound.Stop();
				loginBgSound = null;
			}
		}
		/** 打开登录声音开关 */
		public static function OpenLoginSwitch(btnOff:Object , btnOn:Object):void
		{
			btnOn.visible = true;
			btnOff.visible = false;
			AudioController.SoundLoginOn();
		}
		/** 关闭登录声音开关 */
		public static function CloseLoginSwitch(btnOff:Object , btnOn:Object):void
		{
			btnOn.visible = false;
			btnOff.visible = true;
			AudioController.SoundLoginOff();
			AudioController.SoundHomeOff();
		}
		
		/** 从loader结束时调用 */
		public static function loaderIsDone( btnOff:Object , btnOn:Object ):void
		{
			if(loginBgSound != null)
			{
				loginBgSound.PlayComplete  = null;
				GameLoaderData.outsideDataObj.loginSound = loginBgSound._sound;
				GameLoaderData.outsideDataObj.loginSoundChannel = loginBgSound._soundChannel;
				GameLoaderData.outsideDataObj.loginSoundTransform = loginBgSound._soundTransform;
			}
//			GameLoaderData.outsideDataObj.loginSound.play();
//			AudioController.SoundLoginOff();
			AudioController.SoundHomeOff();
		}
		
	}
}