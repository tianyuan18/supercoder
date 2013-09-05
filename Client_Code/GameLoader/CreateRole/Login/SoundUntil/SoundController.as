package CreateRole.Login.SoundUntil
{
	import CreateRole.Login.Controller.AudioController;
	
	import Data.GameLoaderData;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class SoundController
	{
		private var soundSwitchOn:Bitmap;
		private var soundSwitchOff:Bitmap;
		private var mcVolume:MovieClip;
		private var spriteOn:Sprite;
		private var spriteOff:Sprite;
		private var isLogin:Boolean;
		private var _point:Point;
		private var isClose:Boolean = false;
		private var _soundType:int = 0;				/** 控制的声音类型 1是音乐 2是音效*/
		private var _soundControllName:String;
		private var _uiLayer:Sprite = new Sprite();	/** 层 */
		
		public var clickFunction:Function;			/** 点击小喇叭事件 */
		/** 如果isLogin = true声音就是一键关闭，否则有调控器 */
		public function SoundController(path:String , point:Point , isLogin:Boolean = true , soundOnBitmap:Bitmap = null , soundOffBitmap:Bitmap = null , isSwc:Boolean = false , soundType:int = 1 , uiLayer:* = null,soundControllName:String = null) //1是音乐    2是音效
		{
			if(!uiLayer) this._uiLayer = new Sprite();
			GameLoaderData.loaderStage.addChild(this._uiLayer);
			if(!soundControllName) _soundControllName = "SoundControll";
			else this._soundControllName = soundControllName;
			this.isLogin = isLogin;
			this._soundType = soundType;
			_point = point;
			soundSwitchOn = new Bitmap(GameLoaderData.outsideDataObj.soundOn_bmp);
			soundSwitchOff = new Bitmap(GameLoaderData.outsideDataObj.soundOff_bmp);
	        spriteOn = new Sprite();
	        spriteOff = new Sprite(); 
	        spriteOn.name = "btn_SoundOn";
	        spriteOff.name = "btn_SoundOff";
	        spriteOn.addChild(soundSwitchOn);
	        spriteOff.addChild(soundSwitchOff);
			_uiLayer.addChild(spriteOn);
			_uiLayer.addChild(spriteOff);
			spriteOn.buttonMode = true;
			spriteOff.buttonMode = true;
			spriteOn.x = point.x;
			spriteOn.y = point.y;
			spriteOff.x = point.x;
			spriteOff.y = point.y;
			showSwitch();
			spriteOn.addEventListener(MouseEvent.CLICK,soundOnHandler);										  //点击声音开启状态
			spriteOff.addEventListener(MouseEvent.CLICK,soundOnHandler);									  //点击声音关闭状态
			if(mcVolume != null)
			{
				mcVolume.x = point.x;
				mcVolume.y = point.y + soundSwitchOn.height;
			}
			if(isLogin == false)				//这个判断是需要只出现控制条不需要喇叭的情况
			{
				_uiLayer.removeChild(spriteOn);
				_uiLayer.removeChild(spriteOff);
				volumeController();
			}
			if(GameLoaderData.isOpenSoundSwitch) openSound();
		}
		/** 点击声音开启状态，弹出音量管理 或 关闭音乐*/     
		private function soundOnHandler(e:MouseEvent):void
		{
			if(mcVolume == null || this.isLogin == true)
			{
				if(clickFunction != null) clickFunction();
				if(GameLoaderData.isOpenSoundSwitch == false)
				{
					openSound();									//控制音乐
				} 
				else if(GameLoaderData.isOpenSoundSwitch == true)
				{
					closeSound();
				}
			}
		}   
		
		/** 点击舞台 */
		private function stageClickHandler(e:MouseEvent):void
		{
			gcAll();
		}
		
		
		/** 点击音量控制器 */
		private function mcVolumeClickHandler(e:MouseEvent):void
		{
			e.stopPropagation();
		}
		
		/** 控制音量 */
		private function volumeController():void
		{
			_uiLayer.addChild(mcVolume);
		}
		private function closeSound():void
		{
//			GameLoaderData.isOpenFightSoundSwitch 	= false;
			GameLoaderData.isOpenSoundSwitch		= false;
			spriteOn.visible = false;
			spriteOff.visible = true;
			if(mcVolume == null)  
			{
				AudioController.CloseLoginSwitch(soundSwitchOff , soundSwitchOn);
			}
		}
		private function openSound():void
		{
//			GameLoaderData.isOpenFightSoundSwitch 	= true;
			GameLoaderData.isOpenSoundSwitch		= true;
			spriteOn.visible = true;
			spriteOff.visible = false;
			if(mcVolume == null) AudioController.OpenLoginSwitch(soundSwitchOff , soundSwitchOn);
		}
		/** 清除 */
		public function clearSoundSwitch():void
		{
			if(soundSwitchOn == null || soundSwitchOn == null)
			{
				return;
			}
			if(mcVolume == null)  
			{
				AudioController.loaderIsDone( soundSwitchOff , soundSwitchOn ); 
			}
			spriteOn.removeEventListener(MouseEvent.CLICK,soundOnHandler);										
			spriteOff.removeEventListener(MouseEvent.CLICK,soundOnHandler);	
			_uiLayer.removeChild(spriteOn);
			_uiLayer.removeChild(spriteOff);	
			spriteOn = null;	
			spriteOff = null;	
		}
		
		/** 是否可视 */
		public function isableSee(isSee:Boolean):void
		{
			if(isSee == false)
			{
				spriteOn.visible = false;
				spriteOff.visible = false;
			}
			else
			{
				showSwitch();
			}
		}
		private function showSwitch():void
		{
			if(soundSwitch == false)
			{
				spriteOn.visible = false;
				spriteOff.visible = true;
			}
			else
			{
				spriteOn.visible = true;
				spriteOff.visible = false;
			}
		}
		private function gcAll():void
		{
			spriteOn.stage.removeEventListener(MouseEvent.CLICK , stageClickHandler);							  //点击舞台
			_uiLayer.removeChild(mcVolume);
		}
//		public static function loaderSound(isClear:Boolean = false):void
//		{
//			if(isClear == false)
//			{
//				var soundSwitch:Function = 
//				var isSoundOn:Boolean = soundSwitch();
//				if(isSoundOn) openSound();
//				else closeSound();	
//			}
//			else soundSwitch = null;
//		}
		private function set soundVolume(value:int):void
		{
			if(_soundType == 1) 	GameLoaderData.soundVolume = value; 										//控制的是音效还是音乐
		}
		/** 控制的声音開關*/
		private function get soundSwitch():Boolean
		{
			var _soundSwitch:Boolean;
			if(_soundType == 1) _soundSwitch = GameLoaderData.isOpenSoundSwitch;
			return _soundSwitch;
		}
		private function set soundSwitch(_switch:Boolean):void
		{
			if(_soundType == 1) GameLoaderData.isOpenSoundSwitch = _switch;
		}
		public function get mcVolumeInstance():MovieClip
		{
			return this.mcVolume;
		}
		/** 设置声音关闭，开启 */
		public function soundOnOrOff(onSwitch:Boolean):void
		{
			if(onSwitch)
			{
				if(_soundType == 1) openSound();
			}
			else
			{
				if(_soundType == 1) closeSound();
			}
		}
		/** 喇叭禁用图标的显示 */
		public function soundPicSet():void
		{
			if(GameLoaderData.isOpenSoundSwitch == false)
			{
				spriteOn.visible = false;
				spriteOff.visible = true;						
			} 
			else if(GameLoaderData.isOpenSoundSwitch == true)
			{
				spriteOn.visible = true;
				spriteOff.visible = false;
			} 
		}
	}
}