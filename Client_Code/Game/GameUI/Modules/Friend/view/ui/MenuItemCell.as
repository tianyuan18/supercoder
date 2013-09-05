package GameUI.Modules.Friend.view.ui
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class MenuItemCell extends Sprite
	{
		
		/** 内容MC */
		public var content:MovieClip;
		/** 数据绑定 */
		public var data:Object={};
		
		public function MenuItemCell()
		{
			super();
			this.buttonMode=true;
			this.content=GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("FriendMenuItemRenderer");
			
			this.addChild(this.content);
			(this.content.txtName as TextField).mouseEnabled=false;
			this.addEventListener(MouseEvent.ROLL_OVER,onMouseRollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT,onMouseRollOutHandler);			
		}
		
		
		/**
		 * 设置渲染器文本值 
		 * @param value
		 * 
		 */		
		public function setText(value:String):void{
			(this.content.txtName as TextField).text=value;
		}
		
		protected function onMouseRollOverHandler(e:MouseEvent):void{
			(this.content.itemLight as MovieClip).visible = true;
			this.content.txtName.textColor = 0xFFFF00;
		}
		
		protected function onMouseRollOutHandler(e:MouseEvent):void{
			(this.content.itemLight as MovieClip).visible = false;
			this.content.txtName.textColor = 0xFFFFFF;
		}
		
	}
}