package GameUI.View.BaseUI
{

	import GameUI.ConstData.SoundList;
	import GameUI.Sound.SoundManager;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.*; 

	public class PanelBase extends Sprite 
	{
		//边角宽
		private static const EDGEWIDTH:Number=6;
		//边角高
		private static const EDGEHEIGHT:Number=27;
		//显示内容X位置
		private static const XPOS:Number=18;
		//显示内容Y位置
		private static const YPOS:Number=55;
		//背景层
		private var back:MovieClip = null;
		//左边板
//		private var left:Bitmap = new Bitmap();
//		//右边板
//		private var right:Bitmap = new Bitmap();
		//标题框
//		private var title:MovieClip = null;
		//标题左花纹
		private var titleLeft:MovieClip = null;
		//标题右花纹
		private var titleRight:MovieClip = null;
		//面板容器
		private var container:Sprite = new Sprite();
		//关闭按钮
		private var closeBtn:SimpleButton = null;
		//标题宽度
		private var titleWidth:Number=0;
		//背景宽度
		private var backWidth:Number=0;
		//显示的内容
		public var content:MovieClip=null;
		//拖动开关
		private var isDrag:Boolean = true;
		//文本层
		private var tf:TextField = new TextField();
		//UI名称
		private var titleName:MovieClip = null;
		//拖动边界
		private var dragPoint:Point = new Point();
//		private var dragRect:Rectangle;
		
		private var distanceX:Number;
		private var distanceY:Number;
		private var point:Point;
		public var closeFunc:Function = null;
		private var titleH:Number = 45;

		public function PanelBase(_content:MovieClip,_titleWidth:Number, _backWidth:Number) {
			titleWidth=_titleWidth;
			backWidth=_backWidth;
			this.content=_content;
			initialize();
		}
	
		private function initialize():void
		{
//			left.bitmapData = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmapData("Left");
//			right.bitmapData = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmapData("Right");
//			title.bitmapData = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmapData("Title");
//			title = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("Title");
			back = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("Back");
			closeBtn = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByButton("CloseBtn");
			
			//设置拖动边界
//			this.dragPoint.x = 200;
//			this.dragPoint.y = 0;
//			this.dragRect = new Rectangle ( dragPoint.x,dragPoint.y,GameCommonData.GameInstance.MainStage.stageWidth+(this.titleWidth-160),GameCommonData.GameInstance.MainStage.stageHeight-50-this.title.height );
			GameCommonData.panelBaseArr.push( this );
			initView();
		}
		
		public function updateDragRect():void
		{
//			this.dragRect = new Rectangle ( dragPoint.x,dragPoint.y,GameCommonData.GameInstance.MainStage.stageWidth+(this.titleWidth-160),GameCommonData.GameInstance.MainStage.stageHeight-50-this.title.height );
		}
		
		public function updatePoint():void
		{
			if( dragPoint.x > this.x || this.x > (dragPoint.x + GameCommonData.GameInstance.MainStage.stageWidth+this.titleWidth-160) || dragPoint.y > this.y || this.y > (dragPoint.y + GameCommonData.GameInstance.MainStage.stageHeight-50-titleH) )
			{
				this.x = 80;
				this.y = 58;
			} 
			
		}
		
		/**
		 * 重新设置面板宽度 
		 * @param value
		 * 
		 */		
		public function setWidth(value:uint):void{
			this.titleWidth=value;
			this.getView();
			tf.x=(this.titleWidth-tf.width)/2;
			dragMc.graphics.clear();
			dragMc.graphics.beginFill(0xff00ff);
			dragMc.graphics.drawRect(0,back.y, back.width-6, titleH);
			dragMc.graphics.endFill();
			dragMc.alpha = 0;
		}
		
		/** 禁用关闭按钮(隐藏掉) */
		public function disableClose():void
		{
			closeBtn.visible = false;
		}
		
		/** 是否可以关闭 */
		public function canClose(canClose:Boolean):void
		{
			closeBtn.mouseEnabled = canClose;
		}
		//_______________________________________________________________________________
		
		/** 设置文本标题  */
		public function SetTitleTxt(titleTxt:String):void {
			tf.defaultTextFormat = fontTf();
			tf.text = titleTxt;
			tf.selectable = false;
			tf.mouseEnabled = false; 
			tf.width = tf.textWidth + 10;
			//tf.setTextFormat(fontTf());
			//tf.defaultTextFormat = fontTf();
			this.addChild(tf);
			tf.x = int((back.width - tf.textWidth)/2);
			tf.y = 4;
			
		}
		/**使用美术素材显示标题 */
		public function SetTitleName(titleTxt:String):void{
			
			titleName = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip(titleTxt);	
			if(titleName == null) return;
			
			titleName.x = int((back.width - titleName.width)/2);
			titleName.y = int((titleH-titleName.height)/2+5);
			titleName.mouseEnabled = false;
			titleName.mouseChildren = false;
			this.addChild(titleName);
		}
		
		
		/**使用美术素材显示标题 */
		public function SetTitleMc(titleMc:MovieClip):void{
			
			titleName = titleMc;
			titleName.mouseChildren = false;
			titleName.mouseEnabled = false;
			if(titleName == null) return;
			
			titleName.x = int((back.width - titleName.width)/2);
			titleName.y = int((titleH-titleName.height)/2+5);
			this.addChild(titleName);
		}
		
		/** 设置标题花纹 */
		public function SetTitleDesign():void{
			
//			titleLeft = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("TitleLeft");
//			titleRight = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("TitleRight");
//			titleLeft.x = titleName.x - titleLeft.width - 15;
//			titleLeft.y = titleName.y;
//			titleRight.x = titleName.x + titleName.width + 15;
//			titleRight.y = titleName.y;
//			titleLeft.mouseEnabled = false;
//			titleRight.mouseEnabled = false;
//			this.addChild(titleLeft);
//			this.addChild(titleRight);
		}
		
		public function setTitlePos( _pos:Point ):void
		{
			tf.x = _pos.x;
			tf.y = _pos.y;
		}
		
		//___________________________________________________________________________private
		private function initView():void {
			this.addChild(container);
			container.addChild(back);//背景层
//			container.addChild(left);//左花纹
//			container.addChild(right);//右花纹
//			container.addChild(title);//标题栏
			container.addChild(closeBtn);//关闭按钮
			closeBtn.addEventListener(MouseEvent.CLICK, onCloseHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN, setChildIndexHandler);
			getView();
			setDragBar(); //设置拖动条
		}

		private function getView():void {
//			getTitleView();//设置标题宽
//			getLeftAndRight();//设置左右花纹
			getBackView();//设置背景
			getBtnView();//设置关闭按钮
			container.addChild(content);
			content.x=XPOS;
			content.y=YPOS;
		}
		
		/** 固定标题位置 */
		private function getTitleView():void {
			var offset:int = back.width/2;
			back.width=titleWidth+8;
			back.x=0;
//			title.x = -titleWidth/2;
		}

		/** 固定背景位置 */	
		private function getBackView():void {
			
//			back.y=title.y+title.height;
//			back.alpha=.7;
//			getBoundLine(back);
			back.width=this.titleWidth+XPOS+8;
			back.height=backWidth+YPOS+5;
			back.x=0;
			back.y=0;
		}
		
		/** 在左右两边各偏移1像素 */
		private function getLeftAndRight():void {
//			left.x=1;
//			right.x=left.width+title.width-1;
		}
		
		/** 生成关闭按钮的位置  */
		private function getBtnView():void {
			closeBtn.x=int(back.width-closeBtn.width-11);
			closeBtn.y=int(closeBtn.height)-3;
		}
		
		/** 关闭面板  */
		public function onCloseHandler(evt:MouseEvent):void { 
			if (this.contains(container)) {
				//this.removeChild(container);
				//this.removeChild(tf);
				
				SoundManager.PlaySound(SoundList.PANECLOSE); 
				this.dispatchEvent(new Event(Event.CLOSE));
//				if(closeFunc != null) closeFunc();
				//gc();
			}
		}
		
		/** 关闭处理Gc  */
		private function gc():void {
			back=null;
//			left=null;
//			right=null;
//			title=null;
			container=null;
			closeBtn=null;
			content=null;
			titleName=null;
		}
		
		protected var dragMc:Sprite;
		
		/** 已标题大小设置一个拖动对象  */
		private function setDragBar():void {
			 dragMc = new Sprite();
			dragMc.graphics.beginFill(0xff00ff);
			dragMc.graphics.drawRect(0, 5, back.width-closeBtn.width-6, titleH);
			dragMc.graphics.endFill();
			dragMc.alpha = 0;
			this.addChild(dragMc);
			dragMc.addEventListener(MouseEvent.MOUSE_DOWN, dragMcMouseDown);
			dragMc.addEventListener(MouseEvent.MOUSE_UP, dragMcMouseUp);
		}
		
		private function dragMcMouseDown(event:MouseEvent):void {
			if(isDrag) 
			{
				point = this.parent.localToGlobal( new Point(this.x, this.y) );
				distanceX = event.stageX - point.x;
				distanceY = event.stageY - point.y;
				GameCommonData.GameInstance.stage.addEventListener( MouseEvent.MOUSE_MOVE, onMove );
				GameCommonData.GameInstance.stage.addEventListener( MouseEvent.MOUSE_UP, dragMcMouseUp);
			}
		}
		
		private function dragMcMouseUp(event:MouseEvent):void {
			if(isDrag) 
			{
				GameCommonData.GameInstance.stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMove );
				GameCommonData.GameInstance.stage.removeEventListener( MouseEvent.MOUSE_UP, dragMcMouseUp );
			}
		}
		
		private function onMove( e:MouseEvent ):void
		{
			this.x = int(e.stageX - distanceX);
			if(this.x < (this.titleWidth - 100)*(-1) )
			{
				this.x = (int(this.titleWidth) - 100)*(-1);
			}
			else if( this.x > GameCommonData.GameInstance.stage.stageWidth - 100 )
			{
				this.x = GameCommonData.GameInstance.stage.stageWidth - 100;
			}
			this.y = int(e.stageY - distanceY);
			if( this.y < -5 )
			{
				this.y = -5;
			}
			else if( this.y > GameCommonData.GameInstance.stage.stageHeight - 60 )
			{
				this.y = GameCommonData.GameInstance.stage.stageHeight - 60;
			}
		}
		
//		private function dragMcMouseDown(event:MouseEvent):void {
//			if(isDrag) 
//			{
//				this.startDrag( false,this.dragRect );
//			}
//		}
//		
//		private function dragMcMouseUp(event:MouseEvent):void {
//			if(isDrag) 
//			{
//				this.stopDrag();
//			}
//		}
		
		//标题文本格式
		private function fontTf():TextFormat {
//			var ft:Font = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByFont("Font_HWKT");	//华文楷体字体
			var tf:TextFormat = new TextFormat();
			tf.size = 17;
			tf.color = 0xDAB475;
			tf.font = "STKaiti";	//华文楷体  STKaiti
			tf.align = TextFormatAlign.LEFT;
			return tf;
		}
		
		private function setChildIndexHandler(event:MouseEvent):void 
		{
			if(GameCommonData.GameInstance.GameUI.contains(this))
			{
				GameCommonData.GameInstance.GameUI.addChild(this);
			}
		}
		//___________________________________________________________________________
		//_____________________________________________________________GETTER&&SETTER
		public function set IsDrag(v:Boolean):void {
			isDrag = v;
		}
		
		public function get IsDrag():Boolean {
			return isDrag;
		}
		
		public function dispose():void
		{
			var len:int = GameCommonData.panelBaseArr.length;
			var panelBases:Array =  GameCommonData.panelBaseArr;
			for(var i:int = 0; i < len; i ++)
			{
				if(panelBases[i] == this)
				{
					panelBases.splice(i,1)
					break;
				}
			}
			closeBtn.removeEventListener(MouseEvent.CLICK, onCloseHandler);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, setChildIndexHandler);
			dragMc.removeEventListener(MouseEvent.MOUSE_DOWN, dragMcMouseDown);
			dragMc.removeEventListener(MouseEvent.MOUSE_UP, dragMcMouseUp);
			this.gc();
		}
	}
}