package control
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import mx.containers.Panel;
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	
	import spark.components.Group;

	public class GameMoveWindow extends GameWindow{
		private var _moveEnable:Boolean=true;
		private var _alphaEnable:Boolean=true;
		private var _isMD:Boolean=false;
		private var _sPoint:Point;
		private var _group:Group;
		public function GameMoveWindow(){
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onCreationComplete);
			this.visible=true;
		}
		
		protected function gamemovewindow1_mouseOverHandler(event:MouseEvent):void{
			this.alpha=1;
		}
		
		
		protected function gamemovewindow1_mouseOutHandler(event:MouseEvent):void{
			if(_moveEnable && _alphaEnable){
				this.alpha=0.8;
			}
		}
		
		protected function group_mouseOverHandler(event:MouseEvent):void{
			Mouse.cursor = MouseCursor.HAND;
		}

		protected function group_mouseOutHandler(event:MouseEvent):void{
			Mouse.cursor = MouseCursor.ARROW;
		}
		
		
		//事件：初始化完毕
		private function onCreationComplete(event:FlexEvent):void{
		    _group=new Group();
			_group.width=width-60;
			_group.height=30;
			_group.addEventListener(MouseEvent.MOUSE_OUT,group_mouseOutHandler);
			_group.addEventListener(MouseEvent.MOUSE_OVER,group_mouseOverHandler);
			_group.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			
			titleBar.addChild(_group);
			
			
			this.addEventListener(MouseEvent.MOUSE_OUT,gamemovewindow1_mouseOutHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER,gamemovewindow1_mouseOverHandler);
			this.alpha=_moveEnable && _alphaEnable?0.8:1;
		}
		
		private function onMouseDown(event:MouseEvent):void{
			if(!_moveEnable){
				return;
			}
			_isMD=true;
			//Alert.show("按下");
			_sPoint=new Point(event.stageX-this.x,event.stageY-this.y);
			_group.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			
			this.stage .addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			this.stage .addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			//parent.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			var pG:Group=(parent as Group);
			pG.setElementIndex(this,pG.numElements-1);
		}
		
		private function onMouseMove(event:MouseEvent):void{
			if(_isMD && moveEnable){
				this.alpha=.8;
				var xxx:int=event.stageX-_sPoint.x;
				var yyy:int=event.stageY-_sPoint.y;
				if(xxx<0){
					this.x=0;
				}
//				else if(xxx>parent.width-this.width){
//					this.x=parent.width-this.width
//				}
				else{
					this.x=xxx;
				}
				
				
				if(yyy<0){
					this.y=0;
				}
//				else if(yyy>parent.height-this.height){
//					this.y=parent.height-this.height
//				}
				else{
					this.y=yyy;
				}
			}
		}
		
		private function onMouseUp(event:MouseEvent):void{
			_isMD=false;
			this.alpha=1;
			this.stage .removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			this.stage .removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			//parent.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			
			_group.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}
		
		public function get moveEnable():Boolean{
			return _moveEnable;
		}

		public function set moveEnable(value:Boolean):void{
			_moveEnable = value;
		}

		public function get alphaEnable():Boolean{
			return _alphaEnable;
		}

		public function set alphaEnable(value:Boolean):void{
			_alphaEnable = value;
		}


	}
}