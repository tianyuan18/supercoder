package control
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import mx.containers.Panel;
	import mx.controls.Button;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import spark.components.Group;
	import spark.components.HGroup;
	
	/**
	 * 游戏设置窗口 
	 */	
	public class GameWindow extends Panel{
		//关闭按钮
		private var _btnClose:Button=new Button();
		[Bindable]
		public var isVisible:Boolean=false;
		public function GameWindow(){
			super();
			//添加事件
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onCreationComplete);
			this.addEventListener(ResizeEvent.RESIZE,onResize);
			this.visible=false;
		}
		
		/**
		 * 显示(打开)窗体 
		 */		
		public function show():void{
			
			if(parent!=null){
				visible=true;
				isVisible=true;
				var pG:Group=(parent as Group);
				pG.setElementIndex(this,pG.numElements-1);
			}
		}
		
		/**
		 * 显示(打开)窗体 
		 */		
		public function showXY(x:int,y:int):void{
			
			if(parent!=null){
				this.x=x;
				this.y=y;
			}
			show();
		}
		
		/**
		 * 隐藏(关闭)窗体
		 */		
		public function hide():void{
			isVisible=false;
			this.visible=false;
		}
		
		public function toogle():void{
			if(visible){
				hide();
			}else{
				show();
			}
		}
		
		//事件：初始化完毕
		private function onCreationComplete(event:FlexEvent):void{
			_btnClose.label="X";
			_btnClose.width=40;
			_btnClose.height=20;
			_btnClose.buttonMode=true;
			_btnClose.addEventListener(MouseEvent.MOUSE_OUT,btnClose_mouseOutHandler);
			_btnClose.addEventListener(MouseEvent.MOUSE_OVER,btnClose_mouseOverHandler);
			_btnClose.addEventListener(MouseEvent.CLICK,onCloseClick);
			this.titleBar.addChild(_btnClose);
			
			resize();
		}
		
		//事件：窗口大小变化
		private function onResize(event:ResizeEvent):void{
			resize();
		}
		
		//事件：点击关闭按钮
		private function onCloseClick(event:MouseEvent):void{
			hide();
		}
		
		//大小变化
		private function resize():void{
			_btnClose.y=6;
			_btnClose.x=this.width-_btnClose.width-10;
		}
		
		protected function btnClose_mouseOverHandler(event:MouseEvent):void{
			Mouse.cursor = MouseCursor.BUTTON;
		}
		
		protected function btnClose_mouseOutHandler(event:MouseEvent):void{
			Mouse.cursor = MouseCursor.ARROW;
		}
		
	}
}