package control
{
	import common.App;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import modelExtend.MapExtend;
	
	import mx.core.DesignLayer;
	import mx.core.IVisualElement;
	import mx.geom.TransformOffsets;

	
	/**
	 * 网格面板 
	 */	
	public class GridPanel extends MapPanel{
		
		public function GridPanel(){
			super();
		}
		
		private function get _map():MapExtend{
			if(App.proCurrernt!=null && App.proCurrernt.MapCurrent!=null){
				return App.proCurrernt.MapCurrent;
			}
			else{
				
				return null;
			}
		}
		
		/**
		 * 绘制网格
		 */		
		public function drawGrid(c:int,r:int,w:int,h:int):void{
			var col:int =  c;
			var row:int =  int(r/2);
			var _wHalfTile:int = int(w/2);
			var _hHalfTile:int = int(h/2); 
			graphics.clear();
			graphics.lineStyle(1, 0xbbbbbb, 1);
			var dblMapWidth:int = col*2 + 1;
			var dblMapHeight:int = row*2 + 1;
			for (var i:int=1; i<dblMapWidth; i = i+2){
				graphics.moveTo( i*_wHalfTile, 0 );
				if (dblMapHeight+i >= dblMapWidth){
					graphics.lineTo( dblMapWidth*_wHalfTile, (dblMapWidth-i)*_hHalfTile );
				}
				else{
					graphics.lineTo( (dblMapHeight+i)*_wHalfTile, dblMapHeight*_hHalfTile );
				}
				
				graphics.moveTo( i*_wHalfTile, 0 );
				if (i <= dblMapHeight){
					graphics.lineTo( 0, i*_hHalfTile );
				}
				else{
					graphics.lineTo( (i - dblMapHeight)*_wHalfTile, dblMapHeight*_hHalfTile );//i-row-1
				}
			}
			
			for (var j:int=1; j<dblMapHeight; j=j+2){
				
				graphics.moveTo( 0, j*_hHalfTile );
				if (dblMapHeight-j >= dblMapWidth){
					graphics.lineTo( dblMapWidth*_wHalfTile, (dblMapWidth+j)*_hHalfTile );
				}
				else{
					graphics.lineTo( (dblMapHeight-j)*_wHalfTile, dblMapHeight*_hHalfTile );
				}
			}
			
			for (var m:int=0; m<dblMapHeight; m=m+2){
				graphics.moveTo( dblMapWidth*_wHalfTile, m*_hHalfTile );
				if (dblMapWidth-dblMapHeight+m < 0){
					graphics.lineTo( 0, (dblMapWidth+m)*_hHalfTile );
				}
				else{
					graphics.lineTo( (dblMapWidth-dblMapHeight+m)*_wHalfTile, dblMapHeight*_hHalfTile );
				}
			}
		}
		
		 
	}
}