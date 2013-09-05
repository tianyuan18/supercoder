package GameUI.View.Components
{
	import GameUI.Command.MenuEvent;
	import GameUI.Modules.Friend.model.vo.PlayerInfoStruct;
	import GameUI.View.Components.MenuItemCell;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import GameUI.Modules.Pk.Data.PkData;
	public class MenuItem extends Sprite
	{
		public static const MINWIDTH:Number = 60;
		
		public static var crossGap:Number = 8; //横向距离
		public static var longGap:Number = 5;  //纵向距离
		
		
		
		public var minWidth:Number;
		
		/** 数据提供者 */
		protected var _dataPro:Array;
		/** 内容面板 */
		private var contentPanel:MovieClip;
		private var lightFrame:MovieClip;
		private var selected:MovieClip;
		private var roleInfo:PlayerInfoStruct;
		
		protected var cells:Array;
		public var spacer:Class;
		public function MenuItem(data:Array=null)
		{
			super();
			this.name="MENU";
			this._dataPro=data;
			this.contentPanel=GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("CommonPanel");
			this.contentPanel.width = width;
			this.spacer = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClass("Spacer");
			
			
			this.addChild(this.contentPanel);
			this.createChildren();
		}
		
		/**
		 * 初始化UI 
		 * 
		 */		 
		protected  function createChildren():void{
			cells = [];
			for each(var cellData:Object in this._dataPro){
				if(cellData == null)return;
				var cell:MenuItemCell = new MenuItemCell(cellData["cellText"],MINWIDTH,true);
				cell.addEventListener(MouseEvent.CLICK,onCellMouseClick);
				if(cellData["cellText"]!=PkData.dataArr[GameCommonData.Player.Role.PkState].cellText){
					cell.addEventListener(MouseEvent.ROLL_OUT,onCellMouseRollOut);
					cell.addEventListener(MouseEvent.ROLL_OVER,onCellMouseRollOver);
				}
				
			
				
				if(cellData.hasOwnProperty("data")){
					cell.data = cellData["data"];
				}
				
				this.addChild(cell);
				
				this.cells.push(cell);
				
			}
//			this.cells=[];
//			for each(var cellData:Object in this.dataPro){
//				var cell:MenuItemCell=this.getCell();
//				cell.setText(cellData["cellText"]);
//				if(cellData.hasOwnProperty("data")){
//					cell.data=cellData["data"];
//				}
//				
//				this.addChild(cell);
//				this.cells.push(cell);
//			}
			
			this.doLayout();
		}
		
		protected function doLayout():void{
			var spaceHeight:Number = MovieClip(new spacer()).height;
			var currentY:Number = longGap;
			for each(var cell:MenuItemCell in this.cells){
				
				cell.y=currentY;
				cell.x=crossGap;
				var space:MovieClip = MovieClip(new spacer());
				space.y = cell.y+cell.height;
				space.x = cell.x;
				space.width = cell.width;
				addChild(space);
				
				currentY+=(cell.height+spaceHeight);
			}
			this.contentPanel.height=currentY + longGap+spaceHeight;
			this.contentPanel.width= cell.width+crossGap*2;
		    
		}
		
		private function onCellMouseClick(e:MouseEvent):void {
			this.dispatchEvent(new MenuEvent(MenuEvent.Cell_Click,false,false,e.currentTarget as MenuItemCell,this.roleInfo));
		}
		
		private function onCellMouseRollOut(e:MouseEvent):void {
			var cell:MenuItemCell = e.target as MenuItemCell;
			cell.getChildByName("lightBg").visible = false;
			cell.getChildByName("selectMC").visible = false;
			e.stopPropagation();
		}
		
		private function onCellMouseRollOver(e:MouseEvent):void {
			var cell:MenuItemCell = e.target as MenuItemCell;
			cell.getChildByName("lightBg").visible = true;
			cell.getChildByName("selectMC").visible = true;
			e.stopPropagation();
		    
			
		}
			
			
	}
}