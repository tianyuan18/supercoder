package control
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import mx.containers.Panel;
	import mx.events.FlexEvent;
	
	import spark.components.Group;
	import spark.components.Label;

	/**
	 * 大面积容器窗口(可控制滚动显示/右键拖动显示) 
	 */	
	public class GameContainerWindow extends GameWindow{
		private var _group:Group=new Group();
		private var _lblContainer:Label=new Label();
		private var _isRDown:Boolean=false;	//是否右键点下
		private var _rStartPoint:Point;		//鼠标点下时的偏移
		
		public function GameContainerWindow(){
			this.addElement(_lblContainer);
			addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,onMapViewMouseDown);
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onCreationCompleteHandler);
		}
		
		protected function onCreationCompleteHandler(evt:FlexEvent):void{
			this.titleBar.addChild(_group);
		}
		
		public function get elementContainer():Group{
			return _group;
		}

		/**
		 * 容器  
		 */		
		public function get moveChildContainer():Label{
			return _lblContainer;
		}
		
		//鼠标点下（移动开始）
		private function onMapViewMouseDown(evt:MouseEvent):void{
			Mouse.cursor = MouseCursor.HAND;
			removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN,onMapViewMouseDown);
			_rStartPoint=new Point(horizontalScrollPosition+evt.stageX,verticalScrollPosition+evt.stageY);
			_isRDown=true;
			addEventListener(MouseEvent.MOUSE_MOVE,onMovemap);
			addEventListener(MouseEvent.RIGHT_MOUSE_UP,onMapViewMouseUp);
		}
		
		//鼠标移动(移动中...)
		private function onMovemap(evt:MouseEvent):void{
			if(_isRDown){
				this.scrollTo(new Point(_rStartPoint.x-evt.stageX,_rStartPoint.y-evt.stageY));
			}
		}
		
		//鼠标抬起(移动结束)
		private function onMapViewMouseUp(evt:MouseEvent):void{
			Mouse.cursor = MouseCursor.ARROW;
			_isRDown=false;
			removeEventListener(MouseEvent.MOUSE_MOVE,onMovemap);
			removeEventListener(MouseEvent.RIGHT_MOUSE_UP,onMapViewMouseUp);
			addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,onMapViewMouseDown);
		}
		
		/**
		 * 滚动到xy位置 
		 * @param sp 坐标
		 */		
		public function scrollTo(sp:Point):void{
			if(sp.x<0 ){
				horizontalScrollPosition=0;
			}
			else if(sp.x>maxHorizontalScrollPosition ){
				horizontalScrollPosition=maxHorizontalScrollPosition;
			}
			else{
				horizontalScrollPosition=sp.x;
			}
			
			if(sp.y<0){
				verticalScrollPosition=0;
			}
			else if(sp.y>maxVerticalScrollPosition){
				verticalScrollPosition=maxVerticalScrollPosition;
			}
			else{
				verticalScrollPosition=sp.y;
			}
		}
	}
}