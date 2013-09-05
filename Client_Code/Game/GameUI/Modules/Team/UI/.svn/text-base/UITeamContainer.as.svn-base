package GameUI.Modules.Team.UI
{
	import flash.display.Sprite;
	import GameUI.View.items.FaceItem;
	import flash.events.MouseEvent;
	/**
	 * 附近队伍显示信息ScrollPanel 
	 * @author Administrator
	 * 
	 */	
	public class UITeamContainer extends UIUserContainer
	{
		public function UITeamContainer()
		{
			super();
		}
		
		protected override function createChildren(data:Object):void
		{			
			var cellRenderer:CellRenderer = this.getCell(data);
			cellRenderer.addEventListener(MouseEvent.CLICK,onCellClick);
			this.addChild(cellRenderer);
			f=new FaceItem(String(data.idTarget),null,"face");
			f.scaleX = 0.6;
			f.scaleY = 0.6;			
			f.x = 0;
			f.y = 0;
			cellRenderer.addChild(f); 
			
			cellRenderer.x = 0;
			cellRenderer.y = 4 + (cellRenderer.height+4)*roleCount;
			cellRenderer.cell.txtArea.text = "1服";
			cellRenderer.cell.txtName.text = data.szPlayerName;
			cellRenderer.cell.txtCount.text = "3/"+data.usPro.toString();
			cellRenderer.cell.txtLevel.text = data.usLev.toString();
			cellRenderer.cell.txtFighting.text = data.usProLev.toString();
            if(data.usPro>3){
				cellRenderer.cell.txtCount.text = "队伍已满";
				cellRenderer.cell.txtCount.textColor = "ff0000";
			}
//			if(data.idMap==0){
//				cellRenderer.cell.txtGroup.text = "未组队";
//			}else{
//				cellRenderer.cell.txtGroup.text = "已组队";
//			}
		}
		
		/**
		 * 获取渲染器
		 * @return 渲染器 
		 * 
		 */		
		protected override function getCell(data:Object):*{
			//var cell:*=this.cacheCells.shift();
			var cell:*;
			if(cell==null){
				cell= new CellRenderer(data.idPlayer,"teamCell",false,data);
				//this.addChild(cell);
				
			}
			this.cells.push(cell);
			return cell;
		}
	}
}