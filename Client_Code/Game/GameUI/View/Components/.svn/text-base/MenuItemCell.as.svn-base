package GameUI.View.Components
{
	import GameUI.Modules.Pk.Data.PkData;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	public class MenuItemCell extends Sprite
	{
		public static const textWidth:Number = 53;
		public static const textHeight:Number =18;
		
		public var lightBg:MovieClip;
		public var selectMC:MovieClip;

		private var itemText:TextField;
		private var minWidth:Number;
		private var isShowSelect:Boolean;
	
		
		/** 数据绑定 */
		public var data:Object={};
		private var myFormat:TextFormat;
		public function MenuItemCell(text:String,minWidth:Number,isSelect:Boolean)
		{
			super();
			this.isShowSelect = isSelect
			this.buttonMode=true;
			this.minWidth = minWidth;
			this.lightBg = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("LightFrame");
			
			
			
			this.selectMC = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("Selected");
			
			
			itemText = new TextField();
			itemText.width=textWidth;
			itemText.height = textHeight;
			itemText.textColor = 0xffffff;
			itemText.text = text;
			itemText.mouseEnabled = false;
			setFormat();
			lightBg.visible = false;
			lightBg.name = "lightBg";
			selectMC.visible = false;
			selectMC.name = "selectMC";
			if(PkData.dataArr[GameCommonData.Player.Role.PkState].cellText==itemText.text){
				
				selectMC.visible = true;
			}
			
			createChildren();
		}
		
		private function setFormat():void {
			myFormat = new TextFormat();
			myFormat.align = TextFormatAlign.CENTER;
			itemText.backgroundColor = 0x66FF66;
			itemText.setTextFormat(myFormat);
		}
		
		private function createChildren():void {
			doLayer();
			
			
			addChild(itemText);
			if(isShowSelect){
				addChild(selectMC);
			}
			
			addChild(lightBg);
			
			
			
			
			
			
		}
		
		private function doLayer():void {
			if(itemText.width+selectMC.width+2<minWidth){
				lightBg.width = minWidth;
				
			}else{
				lightBg.width = itemText.width+selectMC.width+2;;
			} 
				
				
		    itemText.x = (lightBg.width-itemText.width)/2;
			selectMC.x = itemText.x+itemText.width+2;
		
			selectMC.y = (itemText.height -selectMC.height) / 2;
			lightBg.height = textHeight;
			lightBg.alpha = 0.28;
			
			
			
			
			
			
			
			
		}
		
		
		
		
	}
}