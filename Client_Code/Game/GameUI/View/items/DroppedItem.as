package GameUI.View.items
{
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.ToolTip.Const.IntroConst;
	import GameUI.View.ResourcesFactory;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * xuxiao
	 * 2013-3-28
	 * 掉落的显示物品
	 * **/
	public class DroppedItem extends MovieClip
	{
		
		private var _Type:int = 0;
		public var iconName:String = "";
		protected var mkDir:String = "icon";
		public var icon:Bitmap;
		public var ID:int;//每一批掉落物品的id
		public var titleX:int;
		public var titleY:int;
		
		/**
		 * @param icon 物品type
		 * **/
		public function DroppedItem(icon:String)
		{
			
			if(uint(icon) > 100000/* && uint(iconName)!=800001*/) //410101
			{	
				if(UIConstData.getItem(uint(icon)).img != null) 
				{
					iconName = String(UIConstData.getItem(uint(icon)).img);
				}
			}
			else
			{
				iconName = String(icon);
			}
			
			this.Type=uint(icon);
			this.mouseChildren = true;
			this.mouseEnabled = true;
			var loadingIcon:MovieClip=GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("BuffGrid");
			loadingIcon.gotoAndStop(1);
			var bitMapData:BitmapData=new BitmapData(32,32); //素材替换时做临时修改
			bitMapData.draw(loadingIcon);
			this.icon=new Bitmap(bitMapData);
			this.addChildAt(this.icon,0);
			
			/**显示物品名字**/
			var item:Object = UIConstData.ItemDic_1[Type];
			var textName:TextField=new TextField();
			textName.mouseEnabled=false;
			textName.defaultTextFormat=new TextFormat(GameCommonData.wordDic["mod_cam_med_ui_UIC1_getI"], 12);//"宋体" 
			textName.htmlText=UIConstData.ItemDic_1[Type].Name;
			textName.textColor = IntroConst.itemColors[item.Color];
			textName.height=26;
			textName.y=-20;
			this.addChild(textName);
			loadIcon();
		}
		
		
		
		public function set Type(value:int):void{
			_Type = value;
		}
		public function get Type():int{
			return _Type;
		}
		
		/**加载icon**/
		private function loadIcon():void
		{	
			ResourcesFactory.getInstance().getResource(GameCommonData.GameInstance.Content.RootDirectory + "Resources/"+mkDir+"/" + iconName + ".png",onLoabdComplete);
		}
		
		/**加载完成**/
		protected function onLoabdComplete():void
		{ 
			this.removeChild(this.icon);
			icon = ResourcesFactory.getInstance().getBitMapResourceByUrl(GameCommonData.GameInstance.Content.RootDirectory + "Resources/"+mkDir+"/" + this.iconName + ".png");
			if(icon==null)
			{
				icon = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("NoResource");
			}
			
			if(icon)
			{
				this.addChildAt(icon,0);
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
			
		}
		
		
	}
}