package GameUI.Modules.ToolTip.Mediator.UI
{
	import GameUI.Modules.Buff.UI.BuffUI;
	import GameUI.Modules.ToolTip.Const.IntroConst;
	import GameUI.View.Components.UISprite;
	
	import OopsEngine.Graphics.Font;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class BuffToolTip implements IToolTip
	{
		private var toolTip:Sprite = null;
		private var data:Object;
		private var back:MovieClip;
		private var content:Sprite;
		private var _target:Object;
		private var max:uint = 150;
		private var runTimeTF:TextField;
		public var fixedWidth:Number = NaN;
		
		public function BuffToolTip(view:Sprite,data:Object)
		{
			this.toolTip = view;
			this.data = data.data;
			_target = data.target;
			if(_target.hasOwnProperty('timeChangeFun'))
				_target.timeChangeFun = runTime;
		}
		
		public function GetType():String
		{
			return "TextToolTip";
		}

		public function Show():void
		{
			back = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("ToolTipBackSmall");
			toolTip.addChild(back);
			setContent();
			upDatePos();
		}
		
		private function setContent():void
		{
			content = new Sprite();
			var contents:Array = [{text:BuffUI.timeChange(_target.time), color:IntroConst.COLOR,currnet:'runTimeTF'},{text:data, color:IntroConst.COLOR,currnet:null}];
			showContent(contents);
			toolTip.addChild(content);
		}
		
		private function showContent(contents:Array):void
		{
			for(var i:int = 0; i<contents.length; i++)
			{
				var TF:TextFormat = new TextFormat();
					TF.leading = 3;
//				if(contents[i]==null ||contents[i]==undefined)continue;
				var tf:TextField = new TextField();
				tf.defaultTextFormat = setFormat();
				tf.autoSize=TextFieldAutoSize.LEFT;
//				tf.setTextFormat(setFormat());
				tf.width = toolTip.width;
				tf.wordWrap = true;
				tf.x = 2;
				tf.y = 2;
				tf.filters = Font.Stroke(0);
//				tf.autoSize = TextFieldAutoSize.LEFT;
				tf.textColor = contents[i].color;
				tf.htmlText = contents[i].text ? contents[i].text:"";				//杨龙在11.4号改,原text改为htmlText
				if(max > tf.textWidth)
				{
					max = tf.textWidth+10;
				}
				tf.setTextFormat( TF );
//				max=Math.max(tf.textWidth+10,max);
				if(contents[i].currnet != null)
					this[contents[i].currnet] = tf;
				
				content.addChild(tf);
				tf.y = i*18;
			}
		}
		
		private function setFormat():TextFormat
		{
			var format:TextFormat = new TextFormat();
			format.font = "宋体";          //宋体
			format.align = TextFormatAlign.LEFT;
			return format;
		}
		private function runTime(value:int):void{
			var sTime:String = BuffUI.timeChange(value);
			runTimeTF.text = sTime;
		}
		private function upDatePos():void
		{
			var i:int = 1;
			var ypos:Number = 0;
			back.width = content.width;
//			back.width = content.width;
			back.height = content.height+2;
		}
		
		public function BackWidth():Number
		{
			return back.width;
		}
		
		public function Update(obj:Object):void
		{
		}
		
		public function Remove():void
		{
			if(_target.hasOwnProperty('timeChangeFun'))
				_target.timeChangeFun = null;
			_target = null;
		}
	}
}