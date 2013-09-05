package GameUI.Modules.Opera.View
{
	
	import GameUI.Modules.Opera.View.BlackBlock;
	import GameUI.View.ResourcesFactory;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	public class PurdahPanel extends Sprite
	{
		public  var flag:int = 0;
		private var topBlock:BlackBlock;
		private var buttomBlock:BlackBlock;
		private var npcPhoto:Bitmap;
		private var imageRec:Sprite;
		
		private var npcID:String = "";
		
		private var maskMc:Sprite;
	    public var talkHandler:Function;
		public var exited:Function;
		private var textSkip:TextField;
		public var skipFunction:Function = null;
		
		public function PurdahPanel()
		{
			
			
			
		}
		
		public function init():void {
			
			this.graphics.lineStyle(1,0,0);
			this.graphics.beginFill(0x000000,0);
			this.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			this.graphics.endFill();
			addBlock();
		}
		
		
		
		private function addBlock():void {
			
//			topBlock = new BlackBlock(0,-130,stage.stageWidth,130,0);
			topBlock = new BlackBlock(stage.stageWidth,130);	
//			buttomBlock = new BlackBlock(0,stage.stageHeight,stage.stageWidth,130,1);
			buttomBlock = new BlackBlock(stage.stageWidth,130);
			topBlock.x = 0;
			topBlock.y = -130
			buttomBlock.textField.x = (buttomBlock.width - buttomBlock.textField.width) / 2;
			buttomBlock.textField.y = (buttomBlock.height - buttomBlock.textField.height/2) / 2;
			buttomBlock.x = 0;
			buttomBlock.y = stage.stageHeight;
			
			//跳过按钮
			textSkip = new TextField();
			textSkip.visible = false;
			textSkip.text = "跳过";
			
			textSkip.y = stage.stageHeight - 50;
			textSkip.x = buttomBlock.width - 70;
			textSkip.addEventListener(MouseEvent.CLICK,skipOpera);
			
			var format:TextFormat = new TextFormat(); 
			format.size = 16;
			format.color = 0xff00ff;
			textSkip.setTextFormat(format);
			
			addChild(topBlock);
			addChild(buttomBlock);
			this.addChild(textSkip);
			this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			this.addEventListener(MouseEvent.CLICK,talkHandler);
		}
		
		public function setSkipVisible(visible:Boolean):void
		{
			textSkip.visible = visible;
		}
		
		public function addRoleImage(npcId:String):void
		{
			npcID = npcId;
			ResourcesFactory.getInstance().getResource(GameCommonData.GameInstance.Content.RootDirectory + "Resources/NpcPhoto/" + npcID + ".png",onLoabdComplete);
//			buttomBlock.addChild(imageRec);
		}

		private function onLoabdComplete():void
		{
			removeImage();
			
			npcPhoto = ResourcesFactory.getInstance().getBitMapResourceByUrl(GameCommonData.GameInstance.Content.RootDirectory + "Resources/NpcPhoto/" + npcID + ".png");
			
			if(npcPhoto)
			{
				npcPhoto.x = 0;
				npcPhoto.y = buttomBlock.y + buttomBlock.height-npcPhoto.height-10;
				
				this.addChild(npcPhoto);
			}
			
		}
		
		public function removeImage():void
		{
			if(npcPhoto && this.contains(npcPhoto))
			{
				this.removeChild(npcPhoto);
			}
			
		}
		
		public function reSize():void{
			
			topBlock.width = stage.stageWidth;
			
			buttomBlock.x = 0;
			buttomBlock.y = stage.stageHeight - 130;
			buttomBlock.width = stage.stageWidth;
			
			textSkip.y = stage.stageHeight - 50;
			textSkip.x = buttomBlock.width - 70;
			
			if(npcPhoto)
			{
				npcPhoto.x = 0;
				npcPhoto.y = buttomBlock.y + buttomBlock.height-npcPhoto.height-10;
			}
		}
		
		private function skipOpera(e:MouseEvent):void
		{
			if(skipFunction!=null)skipFunction();
			
			textSkip.text = "";
		}
		
		private function onEnterFrame(e:Event):void {
			if(flag==0){
				if(topBlock.y < 0){
					topBlock.y += 5;
				}
				if(buttomBlock.y > stage.stageHeight - 130){
					buttomBlock.y -= 5;
				}
				
				if(topBlock.y >= 0 && buttomBlock.y <=stage.stageHeight - 130){
					this.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
					
					this.buttomBlock.textField.visible = true;
					
				}
			}else {
				if(topBlock.y >-130){
					topBlock.y -= 5;
				}
				
				if(buttomBlock.y < stage.stageHeight){
					buttomBlock.y += 5;
				}
				
				if(topBlock.y <= -130 && buttomBlock.y >=stage.stageHeight){
					this.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
					if(exited != null){
						this.exited();
					}
					this.parent.removeChild(this);
					
					if(textSkip)
					{
						textSkip.parent.removeChild(textSkip);
					}
					if(topBlock)
					{
						topBlock.parent.removeChild(topBlock);
					}
					if(buttomBlock)
					{
						buttomBlock.parent.removeChild(buttomBlock);
					}
				}
			}
			
			
		}
		
		
		
		public function talk(obj:Object):void {

			this.buttomBlock.setText(obj[3] as String);	
		}
		
		
		
		public function exit():void {
			this.flag = 1;
			
			this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
			
	}
}