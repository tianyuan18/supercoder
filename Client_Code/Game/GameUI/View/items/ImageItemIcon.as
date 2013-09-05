package GameUI.View.items
{
	import GameUI.View.ResourcesFactory;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class ImageItemIcon extends Sprite
	{
		private var IconBmp:Bitmap;
		private var _mir:String;
		private var _iconId:String;
		public function ImageItemIcon(iconId:String,mir:String = "Icon")
		{
			super();
			_iconId = iconId;
			_mir = mir;
			ResourcesFactory.getInstance().getResource(GameCommonData.GameInstance.Content.RootDirectory + "Resources/"+mir+"/" + iconId + ".png",onLoabdComplete);
		}
		private function onLoabdComplete():void{
			IconBmp = ResourcesFactory.getInstance().getBitMapResourceByUrl(GameCommonData.GameInstance.Content.RootDirectory + "Resources/"+_mir+"/" + _iconId + ".png");
			this.addChild(IconBmp);
		}
	}
}