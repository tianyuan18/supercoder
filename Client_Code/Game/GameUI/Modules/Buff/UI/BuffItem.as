package GameUI.Modules.Buff.UI
{
	import GameUI.View.Components.UISprite;
	import GameUI.View.items.FaceItem;
	
	import OopsEngine.Graphics.Font;
	import OopsEngine.Skill.GameSkillBuff;
	
	import com.greensock.TweenLite;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	

	public class BuffItem extends UISprite
	{
		protected var timeField:TextField;
		public var buffSprite:FaceItem;
		public var buff:GameSkillBuff;
		private var _index:int;
		
		public var deleteOwn:Function;			/** 删除自己 */
		public var timeChangeFun:Function;
		
		private var _time:int;
		public function BuffItem(buff:GameSkillBuff)
		{
			this.buff = buff;
			_time = buff.BuffTime;
			loadBuff(buff);
			createTxt();
			index = buff.BuffID;
			this.width = 24;
			this.height = 24;
			this.mouseEnabled = true;
		}
		public function loadBuff(buff:GameSkillBuff):void
		{
			buffSprite = new FaceItem(String(buff.TypeID),null,"icon",24/30);
			this.name = "buffIcon_" + buff.BuffName;
			buffSprite.x = 0;
			buffSprite.y = 0;
			this.addChild(buffSprite);
		}
		public function createTxt():void
		{
			if(buff.BuffTime == -1) return;			//-1为永久BUFF
			timeField = new TextField();
			timeField.mouseEnabled = false;
			time = buff.BuffTime;
			
			//timeField.text = BuffUI.timeChange(buff.BuffTime);
			timeField.autoSize = TextFieldAutoSize.LEFT;
			timeField.textColor = 0xFFFFFF;
			timeField.filters = Font.Stroke(0x000000);
			//新版本当中，不需要倒计时
//			this.addChild(timeField);
			timeField.x = (32 - timeField.textWidth)/2;
			timeField.y = 32;
		}
		/** Buff时间*/
		public function get time():int
		{
			return _time;
		}
		public function set time(vaule:int):void
		{
			if(vaule == -1) return;
			_time = vaule;
			timeField.text = BuffUI.timeChange(vaule);
			
			if(timeChangeFun!=null)
				timeChangeFun(vaule);
			
			if(vaule < 1 && deleteOwn != null) deleteOwn(this.buff);
			
			if(vaule <= 10){
				if(begin)
					return;
				begin = true;
				flicker();
			}
		}
		
		private var begin:Boolean = false;
		private function flicker():void{
			TweenLite.to(buffSprite, 0.3, {
				alpha:0.5,
				onComplete:this.contineFlicker
			});
		}
		private function contineFlicker():void{
			TweenLite.to(buffSprite, 0.3, {
				alpha:1,
				onComplete:this.flicker
			});
		}
		
		
		/** 序列号 */
		public function get index():int
		{
			return _index;
		}
		public function set index(vaule:int):void
		{
			_index = vaule;
		}
		
	}
}