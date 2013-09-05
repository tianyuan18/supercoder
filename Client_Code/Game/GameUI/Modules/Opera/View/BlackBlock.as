package GameUI.Modules.Opera.View
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	public class BlackBlock extends Sprite
	{
		private var flag:int = 0;
		public var textField:TextField;
		private var format:TextFormat;
//		public function BlackBlock(x:Number,y:Number,width:Number,height:Number,flag:int)
//		{
//			super();
//			this.x = x;
//			this.y = y;
//			
//			this.flag = flag;
//			this.graphics.lineStyle(1,0,0);
//			this.graphics.beginFill(0x000000,1);
//			this.graphics.drawRect(0,0,width,height);
//			this.graphics.endFill();
//			textField = new TextField();
//			textField.visible = false;
//			addChild(textField);
//			
//			format = new TextFormat(); 
//			format.size = 16;
//			format.color = 0xffffff;
//		}
		
		public function BlackBlock(width:Number,height:Number)
		{
			super();
			this.graphics.lineStyle(1,0,0);
			this.graphics.beginFill(0x000000,1);
			this.graphics.drawRect(0,0,width,height);
			this.graphics.endFill();
			textField = new TextField();
			textField.visible = false;
			textField.width = 600;
//			textField.x = 400;
			textField.wordWrap=true;
			addChild(textField);
			
			format = new TextFormat(); 
			format.size = 16;
			format.color = 0xffffff;
		}
		
		public function setText(str:String):void {

			this.textField.text = str;
			textField.setTextFormat(format);
			textField.x = 350;
//			textField.autoSize = TextFieldAutoSize.CENTER;
		}
		
		public function setTextPosition(x:int,y:int):void
		{
			textField.x = x;
			textField.y = y;
		}
	}
}