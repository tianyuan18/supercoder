package GameUI.MouseCursor
{
	import OopsEngine.Utils.MovieAnimation;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class DestinationCursor
	{
		public static var Instance:DestinationCursor;
		private var sceneLayer:DisplayObjectContainer
		public var desIcon:Sprite=new Sprite();
		private var mm:MovieAnimation;
		public function DestinationCursor(container:DisplayObjectContainer)
		{
			this.sceneLayer=container;
			var movtoMc:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("SceneCursor");
			mm = new MovieAnimation(movtoMc);
			mm.FrameRate = 20;
			mm.PlayComplete = PlayComplete;
			GameCommonData.GameInstance.GameUI.Elements.Add(mm);
			this.desIcon.addChild(mm);
			this.desIcon.mouseChildren=false;
			this.desIcon.mouseEnabled=false;
			this.sceneLayer.addChild(this.desIcon);
		}
		
		private function PlayComplete(obj1:Object,obj2:Object):void{
			hide();
			mm.Pause();
		}
		
		public static function getInstance(container:DisplayObjectContainer):DestinationCursor{
			Instance=new DestinationCursor(container);
			return Instance;
		}
		
		public function show():void{
			mm.gotoAndPlay(1);
			this.desIcon.visible=true;
			this.desIcon.x=sceneLayer.mouseX;
			this.desIcon.y=sceneLayer.mouseY;
		}
		
		public function hide():void{
			this.desIcon.visible=false;
		} 

	}
}