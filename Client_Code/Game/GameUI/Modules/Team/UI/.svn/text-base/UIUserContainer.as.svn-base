package GameUI.Modules.Team.UI
{
	import GameUI.Modules.Team.UI.CellRenderer;
	import GameUI.View.ResourcesFactory;
	import GameUI.View.items.FaceItem;
	import GameUI.Modules.Team.Datas.TeamDataProxy;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 附近玩家显示信息ScrollPanel 
	 * @author Administrator
	 * 
	 */	
	public class UIUserContainer extends Sprite
	{
		/** 渲染器数组  */
		protected var cells:Array = new Array();
		private var teamSwf:MovieClip;
		private var cell:MovieClip;
		
		//数据提供者
		protected var _fListDataPro:Array = new Array();;
		protected var roleCount:int = 0;
		public function UIUserContainer()
		{
			super();
			ResourcesFactory.getInstance().getResource(GameCommonData.GameInstance.Content.RootDirectory + "Resources/GameDLC/NewTeam.swf", onPanelLoadComplete);
		}
		
		private function onPanelLoadComplete():void {
			this.teamSwf = ResourcesFactory.getInstance().getMovieClip(GameCommonData.GameInstance.Content.RootDirectory + "Resources/GameDLC/NewTeam.swf");			
			//this.cell = new (this.userSwf.loaderInfo.applicationDomain.getDefinition("userCell"));
			
		}
	    
		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set fListDataPro(value:Array):void{
			//this.sortOn(value);
			this._fListDataPro=value;
//			this.setRoleList(this._fListDataPro);
//			//this.setPage();
			this.toRepaint();	
		
		}
		
		public function get fListDataPro():Array{
			return this._fListDataPro;
		}
		
		/**
		 * 重绘 
		 * 
		 */		
		protected function toRepaint():void{
			this.removeAllCells();
			//this.createMenu();
			//			for(var i:int = this.currentPage * onePageNum;i < this.roleList.length; i++){
			//				if(i < (this.currentPage +1)*onePageNum){
			//					this.createChildren(this.roleList[i] as PlayerInfoStruct);
			//					this.roleCount += 1;
			//				}
			//			}
			
			for(var i:int = 0;i < this._fListDataPro.length; i++){
				
				this.createChildren(this._fListDataPro[i] as Object);
				this.roleCount += 1;
				
			}
			
			
		}
		
		
		/**
		 * 创建并初始化UI 
		 * 
		 */
		protected var f:FaceItem;		
		protected function createChildren(data:Object):void
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
			cellRenderer.cell.txtLevel.text = data.usLev;
			cellRenderer.cell.txtRace.text = GameCommonData.RolesListDic[data.usPro];
			cellRenderer.cell.txtGang.text = data.szTargetName;
			cellRenderer.cell.txtFighting.text = data.usProLev;
			if(data.idMap==0){
				cellRenderer.cell.txtGroup.text = "未组队";
			}else{
				cellRenderer.cell.txtGroup.text = "已组队";
			}
		}
		
		protected function onCellClick(e:MouseEvent):void {
			
			for(var i:int=0;i<cells.length;i++){
				if(cells[i].isSelected){
					cells[i].isSelected = false;
					cells[i].cell["cellBack"].visible = false;
				}
			}
			e.target.isSelected = true;
			e.target.cell.cellBack.visible = true;
			
			
		}
		
		/**
		 * 
		 * @param type: 
		 * @param sort 升降序 1:升序 2:降序
		 */	
	    protected function softOn(type:int,sort:uint):void{
			
		}
		/**
		 * 移除所有的渲染器 
		 * 
		 */		
//		public function removeAllCells():void{
//			for each(var cell:MovieClip in this.cells){
//				if(this.contains(cell)){
//					
//					cell.removeEventListener(MouseEvent.CLICK,onCellClickHandler);
//					this.removeChild(cell);
//					this.roleCount = 0;
//					//this.cacheCells.push(cell);
//				}	
//			}
//			this.cells=[];				
//		}	
		
		/**
		 * 移除所有的渲染器 
		 * 
		 */		
		public function removeAllCells():void{
			
			for each(var cell:CellRenderer in this.cells){
				if(this.contains(cell)){
					//					if(this.contains(this.shape)){
					//						this.removeChild(this.shape);
					//					}
					//					if(cell.contains(f)){
					//						cell.removeChild(f);
					//					}
//					cell.removeEventListener(MouseEvent.CLICK,onCellClickHandler);
					this.removeChild(cell);
					this.roleCount = 0;
					//this.cacheCells.push(cell);
				}	
			}
			this.cells=[];				
		}	
		
		/**
		 * 获取渲染器
		 * @return 渲染器 
		 * 
		 */		
		protected function getCell(data:Object):*{
			//var cell:*=this.cacheCells.shift();
			var cell:*;
			if(cell==null){
				cell= new CellRenderer(data.idPlayer,"userCell",false,data);
				//this.addChild(cell);
			
			}
			this.cells.push(cell);
			return cell;
		}
	}
}