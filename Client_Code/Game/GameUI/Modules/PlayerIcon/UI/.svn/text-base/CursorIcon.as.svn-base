package GameUI.Modules.PlayerIcon.UI
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class CursorIcon extends Sprite
	{
		protected var cursorName:String;
		
		private var mc:MovieClip;
		public function CursorIcon(cursorName:String)
		{
			super();
			this.mouseEnabled 		  = false;
			this.mouseChildren 		  = false;
			this.cursorName    		  = cursorName;
			if(GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary)==null){
				return;
			}
			mc = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip(cursorName);	
			this.addChild(mc);
		}
		public function play():void{
			mc.gotoAndPlay(1);
		}
		public function stop():void{
			mc.stop();
		}
	}
}