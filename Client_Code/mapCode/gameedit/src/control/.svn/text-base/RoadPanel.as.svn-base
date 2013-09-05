package control
{
	import common.App;
	import common.MapUtils;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import frame.ProjectWindow.WindowMap;
	
	import model.CellType;
	import model.EditType;
	import model.MapState;
	import model.Node;
	
	import modelExtend.MapExtend;
	
	/**
	 * 路点层 
	 * @author Administrator
	 */	
	public class RoadPanel extends MapPanel{
		
		private var loadSprite:Sprite=new Sprite();	//路点绘画层
		private var _drawPanel:DrawTmpPanel=new DrawTmpPanel();	//临时绘画层
		private var _windowMap:WindowMap;
		private var _startPoint:Node;
		
		private static var _roadPanel:RoadPanel;
		public static function get isShow():Boolean{
			if(_roadPanel!=null && _roadPanel.parent!=null && _roadPanel.visible){
				return true;
			}
			return false;
		}
		
		private function get _map():MapExtend{
			
			if(App.proCurrernt!=null && App.proCurrernt.MapCurrent!=null){
				return App.proCurrernt.MapCurrent;
			}else{
				this.hide();
				return null;
			}
		}
		
		public function RoadPanel(windowMap:WindowMap){
			super();
			this._windowMap=windowMap;
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedStage);
			this.addChild(loadSprite);
			this.addChild(_drawPanel);
			_roadPanel=this;
		}
		
		
		private function resetAllEvent():void{
			_drawPanel.graphics.clear();
			parent.removeEventListener(MouseEvent.MOUSE_DOWN,onLoadMouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,onLoadEndMouseDown);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onDrawMouseMove);
			parent.addEventListener(MouseEvent.MOUSE_DOWN,onLoadMouseDown);
		}
		
		private function onAddedStage(event:Event):void{
			if(event.target==this){
				resetAllEvent();
			}
		}
		
		//事件：点击路点Start
		private function onLoadMouseDown(event:MouseEvent):void{
			var pointLocal:Point=this.globalToLocal(new Point(event.stageX,event.stageY));
			if(_map.mapState!=MapState.ROADSET){
				return;
			}
			
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,onLoadEndMouseDown);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onDrawMouseMove);
			if(_windowMap._loadOperate!=""){
				var point:Point= MapUtils.getCellPoint(pointLocal.x,pointLocal.y);
				if( point.y>=0 && point.y<_map.cells.length && point.x>=0 && point.x<_map.cells[point.y].length ){
					
					var cellTmp:Point=_map.cells[point.y][point.x];
					var dCellTmp:Node=_map.dCells[cellTmp.y][cellTmp.x];
					if(_windowMap._drawType==EditType.SPOINT){
						//绘制小点
						dCellTmp.walkNum=_windowMap._loadOperate;
						drawPoint(dCellTmp.point.x,dCellTmp.point.y,_windowMap._loadOperate);
					}else if(_windowMap._drawType==EditType.CPOINT){
						//绘制中点
						setAndDrawD(cellTmp.x,cellTmp.y);
						setAndDrawD(cellTmp.x,cellTmp.y+1);
						setAndDrawD(cellTmp.x,cellTmp.y-1);
						setAndDrawD(cellTmp.x+1,cellTmp.y);
						setAndDrawD(cellTmp.x-1,cellTmp.y);
					}else if(_windowMap._drawType==EditType.BPOINT){
						//绘制大点
						setAndDrawD(cellTmp.x,cellTmp.y);
						setAndDrawD(cellTmp.x-1,cellTmp.y-1);
						setAndDrawD(cellTmp.x-1,cellTmp.y+1);
						setAndDrawD(cellTmp.x+1,cellTmp.y-1);
						setAndDrawD(cellTmp.x+1,cellTmp.y+1);
						
						setAndDrawD(cellTmp.x,cellTmp.y+1);
						setAndDrawD(cellTmp.x,cellTmp.y-1);
						setAndDrawD(cellTmp.x+1,cellTmp.y);
						setAndDrawD(cellTmp.x-1,cellTmp.y);
					}else if(_windowMap._drawType==EditType.SLINE){
						
						//绘制细线
						parent.removeEventListener(MouseEvent.MOUSE_DOWN,onLoadMouseDown);
						this.stage.addEventListener(MouseEvent.MOUSE_MOVE,onDrawMouseMove);
						_startPoint=dCellTmp;
						setAndDrawD(dCellTmp.dPoint.x,dCellTmp.dPoint.y);
					}else if(_windowMap._drawType==EditType.BLINE){
						//绘制粗线
						parent.removeEventListener(MouseEvent.MOUSE_DOWN,onLoadMouseDown);
						this.stage.addEventListener(MouseEvent.MOUSE_MOVE,onDrawMouseMove);
						_startPoint=dCellTmp;
						setAndDrawD(dCellTmp.dPoint.x,dCellTmp.dPoint.y);
					}else if(_windowMap._drawType==EditType.DSHAPE){
						//绘制菱形
						parent.removeEventListener(MouseEvent.MOUSE_DOWN,onLoadMouseDown);
						this.stage.addEventListener(MouseEvent.MOUSE_MOVE,onDrawMouseMove);
						_startPoint=dCellTmp;
						setAndDrawD(dCellTmp.dPoint.x,dCellTmp.dPoint.y);
					}else if(_windowMap._drawType==EditType.RSHAPE){
						//绘制矩形
						parent.removeEventListener(MouseEvent.MOUSE_DOWN,onLoadMouseDown);
						this.stage.addEventListener(MouseEvent.MOUSE_MOVE,onDrawMouseMove);
						_startPoint=dCellTmp;
						setAndDrawD(dCellTmp.dPoint.x,dCellTmp.dPoint.y);
					}
				}
			}
		}
		
		//事件：移动中
		private function onDrawMouseMove(event:MouseEvent):void{
			var pointLocal:Point=this.globalToLocal(new Point(event.stageX,event.stageY));
			parent.removeEventListener(MouseEvent.MOUSE_DOWN,onLoadMouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,onLoadEndMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,onLoadEndMouseDown);
			var startPx:Point=MapUtils.getPixelPoint(_startPoint.point.x,_startPoint.point.y);
			//绘制细线
			if(_windowMap._drawType==EditType.SLINE){
				_drawPanel.drawLoadLine(startPx,new Point(pointLocal.x,pointLocal.y),_windowMap._loadOperate,1);
			}
			//绘制粗线
			if(_windowMap._drawType==EditType.BLINE){
				_drawPanel.drawLoadLine(startPx,new Point(pointLocal.x,pointLocal.y),_windowMap._loadOperate,3);
			}
			else if(_windowMap._drawType==EditType.DSHAPE){
				var endPoint:Point=MapUtils.getCellPoint(pointLocal.x,pointLocal.y);
				var cellTmp:Point=_map.cells[endPoint.y][endPoint.x];
				var dCellTmp:Node=_map.dCells[cellTmp.y][cellTmp.x];
				
				var topPointPx:Point=startPx;
				var bottomPointPx:Point=MapUtils.getPixelPoint(endPoint.x,endPoint.y);
				
				var xss:*=dCellTmp.dPoint.x-_startPoint.dPoint.x;
				var yss:*=dCellTmp.dPoint.y-_startPoint.dPoint.y;
				var leftPointPx:Point=new Point(startPx.x+xss*_map.cellWidth/2,startPx.y-xss*_map.cellHeight/2);
				var rightPointPx:Point=new Point(startPx.x+yss*_map.cellWidth/2,startPx.y+yss*_map.cellHeight/2);
				
				
				_drawPanel.drawD(topPointPx,leftPointPx,bottomPointPx,rightPointPx,_windowMap._loadOperate);
			}
			else if(_windowMap._drawType==EditType.RSHAPE){
				_drawPanel.drawRectangle( startPx,new Point(pointLocal.x,pointLocal.y),_windowMap._loadOperate);
			}
		}
		
		
		//事件：点击路点End
		private function onLoadEndMouseDown(event:MouseEvent):void{
			var pointLocal:Point=this.globalToLocal(new Point(event.stageX,event.stageY));
			parent.removeEventListener(MouseEvent.MOUSE_DOWN,onLoadMouseDown);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onDrawMouseMove);
			var endPoint:Point= MapUtils.getCellPoint(pointLocal.x,pointLocal.y);
			if(_map==null){
				stage.removeEventListener(MouseEvent.MOUSE_DOWN,onLoadEndMouseDown);
				parent.addEventListener(MouseEvent.MOUSE_DOWN,onLoadMouseDown);
				return;
			}
			
			if( endPoint.y>=0 && endPoint.y<_map.cells.length && endPoint.x>=0 && endPoint.x<_map.cells[endPoint.y].length ){
				_drawPanel.graphics.clear();
				stage.removeEventListener(MouseEvent.MOUSE_DOWN,onLoadEndMouseDown);
				parent.addEventListener(MouseEvent.MOUSE_DOWN,onLoadMouseDown);
				
				if(_windowMap._loadOperate!=""){
					var cellTmp:Point=_map.cells[endPoint.y][endPoint.x];
					var dCellTmp:Node=_map.dCells[cellTmp.y][cellTmp.x];
					var i:int;
					var tempx:int;
					var tempy:int;
					var loadLength:int;
					//绘制细线
					if(_windowMap._drawType==EditType.SLINE){
						loadLength=Math.max(Math.abs(dCellTmp.dPoint.x-_startPoint.dPoint.x),Math.abs(dCellTmp.dPoint.y-_startPoint.dPoint.y));
						for(i=0;i<=loadLength;i++){
							tempx=dCellTmp.dPoint.x+Math.round((_startPoint.dPoint.x-dCellTmp.dPoint.x)/loadLength*i);
							tempy=dCellTmp.dPoint.y+Math.round((_startPoint.dPoint.y-dCellTmp.dPoint.y)/loadLength*i);
							setAndDrawD(tempx,tempy);
						}
					}
						//绘制粗线
					else if(_windowMap._drawType==EditType.BLINE){
						loadLength=Math.max(Math.abs(dCellTmp.dPoint.x-_startPoint.dPoint.x),Math.abs(dCellTmp.dPoint.y-_startPoint.dPoint.y));
						for(i=1;i<loadLength;i++){
							tempx=dCellTmp.dPoint.x+Math.round((_startPoint.dPoint.x-dCellTmp.dPoint.x)/loadLength*i);
							tempy=dCellTmp.dPoint.y+Math.round((_startPoint.dPoint.y-dCellTmp.dPoint.y)/loadLength*i);
							setAndDrawD(tempx,tempy);
							
							setAndDrawD(tempx,tempy+1);
							setAndDrawD(tempx,tempy-1);
							setAndDrawD(tempx+1,tempy);
							setAndDrawD(tempx-1,tempy);
							
							if(i==1 || i==loadLength-1){
								setAndDrawD(tempx-1,tempy-1);
								setAndDrawD(tempx-1,tempy+1);
								setAndDrawD(tempx+1,tempy-1);
								setAndDrawD(tempx+1,tempy+1);
							}
						}
					}
						//绘制菱形
					else if(_windowMap._drawType==EditType.DSHAPE){
						var xdMin:int=Math.min(dCellTmp.dPoint.x,_startPoint.dPoint.x);
						var xdMax:int=Math.max(dCellTmp.dPoint.x,_startPoint.dPoint.x);
						var ydMin:int=Math.min(dCellTmp.dPoint.y,_startPoint.dPoint.y);
						var ydMax:int=Math.max(dCellTmp.dPoint.y,_startPoint.dPoint.y);
						for(var yyyd:int=ydMin;yyyd<=ydMax;yyyd++){
							for(var xxxd:int=xdMin;xxxd<=xdMax;xxxd++){
								setAndDrawD(xxxd,yyyd);
							}
						}
					}
						//绘制矩形
					else if(_windowMap._drawType==EditType.RSHAPE){
						var xMin:int=Math.min(dCellTmp.point.x,_startPoint.point.x);
						var xMax:int=Math.max(dCellTmp.point.x,_startPoint.point.x);
						var yMin:int=Math.min(dCellTmp.point.y,_startPoint.point.y);
						var yMax:int=Math.max(dCellTmp.point.y,_startPoint.point.y);
						for(var yyy:int=yMin;yyy<=yMax;yyy++){
							for(var xxx:int=xMin;xxx<=xMax;xxx++){
								setAndDraw(xxx,yyy);
							}
						}
					}
				}
			}
		}
		
		//根据地图编辑器坐标绘制点
		private function setAndDraw(cx:int,cy:int):void{
			if( cy>=0 && cy<_map.cells.length && cx>=0 && cx<_map.cells[cy].length ){
				var cellTmp:Point=_map.cells[cy][cx];
				var dCellTmp:Node=_map.dCells[cellTmp.y][cellTmp.x];
				dCellTmp.walkNum=_windowMap._loadOperate;
				drawPoint(cx,cy,_windowMap._loadOperate);
			}
		}
		
		//根据直角逻辑坐标画点
		private function setAndDrawD(dx:int,dy:int):void{
			if(dy>=0 && dy< _map.dCells.length && dx>=0 && dx<_map.dCells[dy].length){
				var dCellTmp:Node=_map.dCells[dy][dx];
				if(dCellTmp.point!=null){
					var cx:int=dCellTmp.point.x;
					var cy:int=dCellTmp.point.y;
					if( cy>=0 && cy<_map.cells.length && cx>=0 && cx<_map.cells[cy].length ){
						dCellTmp.walkNum=_windowMap._loadOperate;
						drawPoint(cx,cy,_windowMap._loadOperate);
					}
				}
			}
		}
		
		
		/**
		 * 绘制路点
		 */		
		public function drawLoad():void{
			if(App.proCurrernt!=null){
				if(App.proCurrernt.MapCurrent!=null){
					loadSprite.graphics.clear();
					
					var map:MapExtend=App.proCurrernt.MapCurrent;
					for(var i:int=0;i<map.cellRow;i++){
						for(var j:int=0;j<map.cellCol;j++){
							var pointPx:Point=MapUtils.getPixelPoint(j,i);
							var cellTmp:Point=map.cells[i][j];
							var walkNum:String=map.dCells[cellTmp.y][cellTmp.x].walkNum;
							if(walkNum==CellType.ROAD){
								loadSprite.graphics.beginFill(CellType.ROAD_COLOR,0);
								loadSprite.graphics.drawCircle(pointPx.x,pointPx.y,5);
							
							}else if(walkNum==CellType.Barrier){
								loadSprite.graphics.beginFill(CellType.BARRIER_COLOR);
								loadSprite.graphics.drawCircle(pointPx.x,pointPx.y,5);
							}
							else if(walkNum==CellType.Mask){
								loadSprite.graphics.beginFill(CellType.MASK_COLOR);
								loadSprite.graphics.drawCircle(pointPx.x,pointPx.y,5);
							}
							else if(walkNum==CellType.Trap){
								loadSprite.graphics.beginFill(CellType.TRAP_COLOR);
								loadSprite.graphics.drawCircle(pointPx.x,pointPx.y,5);
							}
							else{
								
							}
						}
					}
					loadSprite.graphics.endFill();
				}
			}
		}
	
		//画点
		public function drawPoint(x:int,y:int,cellType:String):void{
			var pointPx:Point=MapUtils.getPixelPoint(x,y);
			if(cellType==CellType.ROAD){
				loadSprite.graphics.beginFill(CellType.ROAD_COLOR,1);
				loadSprite.graphics.drawCircle(pointPx.x,pointPx.y,5);
			}
			else if(cellType==CellType.Barrier){
				loadSprite.graphics.beginFill(CellType.BARRIER_COLOR);
				loadSprite.graphics.drawCircle(pointPx.x,pointPx.y,5);
			}
			else if(cellType==CellType.Mask){
				loadSprite.graphics.beginFill(CellType.MASK_COLOR);
				loadSprite.graphics.drawCircle(pointPx.x,pointPx.y,5);
			}
			else if(cellType==CellType.Trap){
				loadSprite.graphics.beginFill(CellType.TRAP_COLOR);
				loadSprite.graphics.drawCircle(pointPx.x,pointPx.y,5);
			}
			else{
				
			}
			loadSprite.graphics.endFill();
		}
	}
}