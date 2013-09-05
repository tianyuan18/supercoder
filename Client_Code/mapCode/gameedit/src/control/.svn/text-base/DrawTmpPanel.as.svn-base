package control
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import model.CellType;
	
	/**
	 * 临时绘画面板 
	 * 用于编辑完成前的状态显示
	 */	
	public class DrawTmpPanel extends Sprite{
		public function DrawTmpPanel(){
			super();
		}
		
		/**
		 * 绘制线条 
		 * @param pStart 起点
		 * @param pEnd 终点
		 * @param loadType 路点类型
		 * @param borderWidth 线条宽度
		 */		
		public function drawLoadLine(pStart:Point,pEnd:Point,loadType:String,borderWidth:int):void{
			graphics.clear();
			switch(loadType){
				case CellType.ROAD: graphics.lineStyle(borderWidth, CellType.ROAD_COLOR, 1);break;
				case CellType.Barrier: graphics.lineStyle(borderWidth, CellType.BARRIER_COLOR, 1);break;
				case CellType.Mask: graphics.lineStyle(borderWidth, CellType.MASK_COLOR, 1);break;
				case CellType.Trap: graphics.lineStyle(borderWidth, CellType.TRAP_COLOR, 1);break;
				default : graphics.lineStyle(borderWidth, 0xbbbbbb, 1);break;
			}
			
			graphics.moveTo(pStart.x,pStart.y);
			graphics.lineTo(pEnd.x,pEnd.y);
			graphics.endFill();
		}
		
		/**
		 * 绘制矩形 
		 * @param pStart 起点
		 * @param pEnd	终点
		 * @param loadType 路点类型
		 */
		public function drawRectangle(pStart:Point,pEnd:Point,loadType:String):void{
			graphics.clear();
			switch(loadType){
				case CellType.ROAD: graphics.lineStyle(2, CellType.ROAD_COLOR, 1);break;
				case CellType.Barrier: graphics.lineStyle(2, CellType.BARRIER_COLOR, 1);break;
				case CellType.Mask: graphics.lineStyle(2, CellType.MASK_COLOR, 1);break;
				case CellType.Trap: graphics.lineStyle(2, CellType.TRAP_COLOR, 1);break;
				default : graphics.lineStyle(2, 0xbbbbbb, 1);break;
			}
			
			graphics.moveTo(pStart.x,pStart.y);
			graphics.lineTo(pStart.x,pEnd.y);
			graphics.lineTo(pEnd.x,pEnd.y);
			graphics.lineTo(pEnd.x,pStart.y);
			graphics.lineTo(pStart.x,pStart.y);
			graphics.endFill();
		}
		
		/**
		 * 绘制四边形 
		 * @param p1 点1
		 * @param p2 点2
		 * @param p3 点3
		 * @param p4 点4
		 * @param loadType 路点类型
		 */		
		public function drawD(p1:Point,p2:Point,p3:Point,p4:Point,loadType:String):void{
			graphics.clear();
			switch(loadType){
				case CellType.ROAD: graphics.lineStyle(2, CellType.ROAD_COLOR, 1);break;
				case CellType.Barrier: graphics.lineStyle(2, CellType.BARRIER_COLOR, 1);break;
				case CellType.Mask: graphics.lineStyle(2, CellType.MASK_COLOR, 1);break;
				case CellType.Trap: graphics.lineStyle(2, CellType.TRAP_COLOR, 1);break;
				default : graphics.lineStyle(2, 0xbbbbbb, 1);break;
			}
			
			graphics.moveTo(p1.x,p1.y);
			graphics.lineTo(p2.x,p2.y);
			graphics.lineTo(p3.x,p3.y);
			graphics.lineTo(p4.x,p4.y);
			graphics.lineTo(p1.x,p1.y);
			graphics.endFill();
		}
	}
}