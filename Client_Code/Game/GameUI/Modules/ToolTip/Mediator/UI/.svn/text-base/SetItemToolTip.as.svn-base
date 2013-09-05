package GameUI.Modules.ToolTip.Mediator.UI
{
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.ToolTip.Const.IntroConst;
	import GameUI.UIUtils;
	import GameUI.View.items.FaceItem;
	
	import OopsEngine.Graphics.Font;
	import OopsEngine.Utils.MovieAnimation;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class SetItemToolTip implements IToolTip
	{
		private var toolTip:Sprite;
		
		private var back:MovieClip;
		private var head:MovieClip;
		private var title:MovieClip;
		private var info:MovieClip;
		private var type:MovieClip;
		private var describe:MovieClip;
		private var gatherWay:MovieClip;
		private var outPrice:MovieClip;
		private var content:Sprite;
		private var data:Object;
		
		private var closeHandler:Function;
		private var isDrag:Boolean = false;
		private var lastTimeSp:Sprite;
		
		//关闭按钮
		private var closeBtn:SimpleButton = null;
		
		public function SetItemToolTip(view:Sprite, data:Object, isDrag:Boolean = false, closeHandler:Function = null)
		{
			this.toolTip = view;
			this.data = data;
			this.isDrag = isDrag;
			this.closeHandler = closeHandler;	
		}
		
		public function Show():void
		{
			back = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("tipBack");
			toolTip.addChild(back);
			setHead();
			setBaseInfo();
			setDescribe();
			setUseWay();
			setGatherWay();
			setOutPrice();
			upDatePos();
		}
		/**
		 * 名字 
		 * 绑定 未绑定 
		 */		
		protected function setHead():void {
			head = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("mcToolTipHead");
			head.name = "head"; 
			var txtName:String = UIConstData.getItem(data.type).Name;
			head.txtName.textColor = IntroConst.itemColors[data.color];
			head.txtName.text = txtName;
			head.txtName.x = 48;
			head.mouseChildren = false;
			head.mouseEnabled = false;
			if(data.isBind)
			{
				head.txt_bind.text = "已绑定"; 
				head.txt_bind.textColor = 0xCC0033;
			}
			else
			{
				head.txt_bind.text = "未绑定";
				head.txt_bind.textColor = 0x33CC00;
			}
			
			toolTip.addChild(head);
			var faceItem:FaceItem = new FaceItem(data.type, head);//装备图片
			head.iconMc.addChild(faceItem);
			faceItem.setImageScale(32,32);
			faceItem.x = 2;
			faceItem.y = 2;
		}
		/**
		 * 物品基本属性说明 
		 */
		private function setBaseInfo():void
		{
			info = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("itemBasePro");
			toolTip.addChild(info);
			
			info.txt_itemType.text = UIConstData.getItem(data.type).UseType;//道具类型
			info.txt_level.text = UIConstData.getItem(data.type).Level;//使用等级
			info.txt_max.text = data.maxAmount;
			setLastTime(info.txt_outDate);
		}
		
		
		/**
		 * 描述 
		 */		
		private function setDescribe():void {
			describe = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("itemDescribe");
			var txt:TextField = describe.txt_describe; 
			txt.wordWrap=true;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.text = UIConstData.getItem(data.type).description;;
			describe.addChild(txt);
			toolTip.addChild(describe);
		}
		
		/**
		 * 使用途径
		 */		
		private function setUseWay():void {
			var txtValue:String = UIConstData.getItem(data.type).description1;
			if(txtValue != ""){
				var mc:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("mcUseBase");
				var txt:TextField = mc.txt_use; 
				txt.wordWrap=true;
				txt.autoSize = TextFieldAutoSize.LEFT;
				txt.text = txtValue;
				mc.addChild(txt);
				toolTip.addChild(mc);
			}
		}
		
		/**
		 * 获取途径
		 */		
		private function setGatherWay():void {
			var txtValue:String = UIConstData.getItem(data.type).description2;
			if(txtValue != ""){
				var mc:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("gatherWay");
				var txt:TextField = mc.txt_way; 
				txt.wordWrap=true;
				txt.autoSize = TextFieldAutoSize.LEFT;
				txt.text = txtValue;
				mc.addChild(txt);
				toolTip.addChild(mc);
			}
		}
		
		/**
		 * 出售价格 
		 */		
		private function setOutPrice():void {
			var outPrice:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("outPrice");
			outPrice.txt_price.text = UIConstData.getItem(data.type).PriceOut+"铜币";
			toolTip.addChild(outPrice);
		}
		
		protected function upDatePos():void
		{
			var i:int = 1;
			var ypos:int = 8;
			for(; i < toolTip.numChildren; i++)
			{
				var child:DisplayObject = toolTip.getChildAt(i);
				child.x = 3;
				child.y = ypos;
				ypos = child.y+child.height+4;
			}
			back.width = 220;
			back.height = int(toolTip.height + 9);
			if(isDrag)
			{
				this.toolTip.mouseEnabled = true
				this.toolTip.mouseChildren = true;;			
				back.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				closeBtn = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByButton("CloseBtn");
				closeBtn.addEventListener(MouseEvent.CLICK, onClose);
				closeBtn.x = this.back.width - closeBtn.width;
				closeBtn.y = 0;
				this.toolTip.addChild(closeBtn);
			}
		}
		public function GetType():String
		{
			return "SetItemToolTip";
		}
		
		public function Update(obj:Object):void
		{
			
		}
		private function onMouseDown(event:MouseEvent):void
		{
			this.toolTip.startDrag();	
			back.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			this.toolTip.stopDrag();
		}
		
		private function onClose(event:MouseEvent):void
		{
			closeHandler();
		}
		
		public function Remove():void
		{
			var count:int = toolTip.numChildren-1;
			while(count>=0)
			{
				toolTip.removeChildAt(count);
				count--;	
			}
			toolTip = null;
			back = null;
			title = null;
			info = null;
			type = null;
			content = null;
			data = null;
		}
		
		/** 显示过期时间 */
		private function setLastTime(tf:TextField):void
		{
			if(data.isActive == 0) {							//0-不需要检测剩余时间
				return;
			} else if(data.isActive == 1) {						//1-需检测剩余时间
				var lastTime:String = data.lifeTime.toString();
				var year:String   = "20" + lastTime.substr(0, 2);
				var month:String  = lastTime.substr(2, 2);
				var day:String    = lastTime.substr(4, 2);
				var hour:String	  = lastTime.substr(6, 2);
				var minite:String = lastTime.substr(8, 2);
				if(month.charAt(0) == "0")  month = month.substr(1, 1);
				if(day.charAt(0) == "0") 	day = day.substr(1, 1);
				if(hour.charAt(0) == "0")   hour = hour.substr(1, 1);
				if(minite.charAt(0) == "0") minite = minite.substr(1, 1);
				
				var timeDes:String = GameCommonData.wordDic[ "mod_too_med_ui_equ_setl_1" ]+year+GameCommonData.wordDic[ "mod_too_med_ui_equ_setl_2" ]+month+GameCommonData.wordDic[ "mod_too_med_ui_equ_setl_3" ]+day+GameCommonData.wordDic[ "mod_too_med_ui_equ_setl_4" ]+hour+GameCommonData.wordDic[ "mod_too_med_ui_equ_setl_5" ]+minite+GameCommonData.wordDic[ "mod_too_med_ui_equ_setl_6" ];       //过期时间：     年     月     日      时      分
				tf.text = timeDes;
			} else if(data.isActive == 2) {											//2-已过期的
				tf.text = GameCommonData.wordDic[ "mod_too_med_ui_equ_setl_7" ];               //该物品已过期
			}
		}
		
		public function BackWidth():Number
		{
			return back.width;
		}
	}
}