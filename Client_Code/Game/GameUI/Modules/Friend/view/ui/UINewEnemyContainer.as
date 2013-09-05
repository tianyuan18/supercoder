package GameUI.Modules.Friend.view.ui
{
	import GameUI.Modules.Friend.command.MenuEvent;
	import GameUI.Modules.Friend.model.vo.PlayerInfoStruct;
	import GameUI.View.Components.UIScrollPane;
	import GameUI.View.ResourcesFactory;
	import GameUI.View.items.FaceItem;
	
	import OopsEngine.Graphics.Font;
	import Net.ActionSend.FriendSend;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * 仇人
	 */
	public class UINewEnemyContainer extends Sprite
	{
		/** 渲染器数组  */
		protected var cells:Array = new Array();
		/** 渲染器缓冲  */		
		protected var cacheCells:Array = new Array();
		
		/**  各组好友的数据提供者（【组】【name,name....】） */
		protected var _fListDataPro:Array = new Array();

		/** 选中索引 */
		protected var selectedIndex:uint=0;
		
		private var friendCell:MovieClip;
		
		private var friendView:MovieClip;
		private static var onePageNum:int = 14;
		private var currentPage:int = 0;
		private var pageNum:int = 0;
		private var roleCount:int = 0;		
		private var roleList:Array = new Array();
		private var friendSwf:MovieClip;
		/** 是否已经单击*/
		protected var countClick:uint=0;		
		/** 菜单*/
		public var menu:MenuItem;		
		/** 当前位置 */
		protected var currendPos:Point;
		protected var isShow:Boolean=false;
		
		public var w:Number=148;
		public var h:Number=279;
		
		
		public function UINewEnemyContainer(friendView:MovieClip)
		{
			super();  
			this.friendView = friendView;
			ResourcesFactory.getInstance().getResource(GameCommonData.GameInstance.Content.RootDirectory + "Resources/GameDLC/NewFriend.swf", onPanelLoadComplete);
		}
		
		private function onPanelLoadComplete():void
		{
			friendSwf = ResourcesFactory.getInstance().getMovieClip(GameCommonData.GameInstance.Content.RootDirectory + "Resources/GameDLC/NewFriend.swf");			
			this.friendCell = new (friendSwf.loaderInfo.applicationDomain.getDefinition("friendCell"));
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set fListDataPro(value:Array):void{
			this.sortOn(value);
			this._fListDataPro=value;
			this.setRoleList(this._fListDataPro);
			this.toRepaint(this.currentPage);	
		}
		
		
		public function get fListDataPro():Array{
			return this._fListDataPro;
		}
		
		public function setRoleList(arr:Array):void
		{
			var group:int = 0;
				for(var i:uint=0;i<arr.length;i++){
					if(this.roleList[i] == null)
					{
						var val:PlayerInfoStruct=arr[i].roleInfo as PlayerInfoStruct;	
						this.roleList.push(val);
					}					
				group += 1;
			}				
		}
		
		/**
		 *  对一维数组进行排序 
		 * @param arr
		 * 
		 */		
		protected function sortOn(arr:Array):void{
			for(var i:uint=0;i<arr.length;i++){
				for(var j:uint=0;j<arr.length-i-1;j++){
					var val1:PlayerInfoStruct=arr[j].roleInfo as PlayerInfoStruct;
					var val2:PlayerInfoStruct=arr[j+1].roleInfo as PlayerInfoStruct;
					if(val1!=null && val2!=null){
						if(val1.isOnline<val2.isOnline){
							var temp:Object=arr[j];
							arr[j]=arr[j+1];
							arr[j+1]=temp;
						}
					}
						
				}
			}
		}
		
		/**
		 * 创建并初始化UI 
		 * 
		 */
		private var f:FaceItem; 		
		protected function createChildren(data:PlayerInfoStruct):void
		{			
			var friendcell:MovieClip = this.getCell();
			this.addChild(friendcell);
			
			friendcell.addEventListener(MouseEvent.CLICK,onCellClickHandler);
			var isOnline:uint=data.isOnline;
			if(isOnline != 0){
				friendcell.txtArea.text = "["+isOnline+"服]";
				friendcell.filters = [];
			}else{
				friendcell.txtArea.text = "[离线]";
				friendcell.filters = Font.grayFilters();
			}			
			friendcell["roleInfo"]=data;
			friendcell.txtName.text = data.roleName;//名字
			friendcell.txtLevel.text = data.level+"级";//等级
			f=new FaceItem(String(data.face),null,"Face");
			var scale:Number = friendcell.height/f.height - 0.3;
			f.scaleX = 0.6;
			f.scaleY = 0.6;			
			f.x = 0;
			f.y = 0;
			friendcell.addChild(f); 
			
			friendcell.y = 4 + (friendcell.height+4)*roleCount;
			friendcell.mouseChildren = false;
			friendcell.buttonMode = true;
		}

		/**
		 * 移除所有的渲染器 
		 * 
		 */		
		public function removeAllCells():void{
			for each(var cell:MovieClip in this.cells){
				if(this.contains(cell)){
				
					cell.removeEventListener(MouseEvent.CLICK,onCellClickHandler);
					this.removeChild(cell);
					this.roleCount = 0;
					//this.cacheCells.push(cell);
				}	
			}
			this.cells=[];				
		}				

		public var shape:Shape= new Shape();		
		protected var id:uint=0;		
		protected function onCellClickHandler(e:MouseEvent):void{
			this.countClick=0;
			
			
			this.currendPos=new Point(e.stageX,e.stageY);
			this.menu.roleInfo=e.currentTarget["roleInfo"];
			var dataList:Array=[];
			dataList=[
				{cellText:GameCommonData.wordDic[ "mod_fri_view_med_friendA_han_1" ],data:{hasChild:false,type:GameCommonData.wordDic[ "mod_fri_view_med_friendA_han_1" ]}},//"私聊"	"私聊"
				{cellText:GameCommonData.wordDic[ "mod_fri_view_med_friendA_han_2" ],data:{hasChild:false,type:GameCommonData.wordDic[ "mod_fri_view_med_friendA_han_2" ]}},//"复制名字"		"复制名字"
				{cellText:GameCommonData.wordDic[ "mod_fri_view_med_friendA_han_5" ],data:{type:GameCommonData.wordDic[ "mod_fri_view_med_friendA_han_5" ]}},//"删除"		"删除"				
				{cellText:GameCommonData.wordDic[ "mod_fri_view_med_friendA_han_6" ],data:{hasChild:false,type:GameCommonData.wordDic[ "mod_fri_view_med_friendA_han_6" ]}}];//"复制名字"		"复制名字"
		
			if(this.menu.roleInfo.friendGroupId==6)dataList.shift();
			this.menu.dataPro=dataList;
			
			var m1:DisplayObject=GameCommonData.GameInstance.GameUI.getChildByName("MENU");
			if(m1!=null){
				GameCommonData.GameInstance.GameUI.removeChild(m1);
			}
			GameCommonData.GameInstance.GameUI.addChild(this.menu);
			this.menu.x=this.currendPos.x;
			this.menu.y=this.currendPos.y;
			e.stopPropagation();
		}

		protected function onMouseDoubleClick(roleInfo:*):void{
			this.dispatchEvent(new MenuEvent(MenuEvent.CELL_DOUBLE_CLICK, false, false,null,roleInfo));
		
		}
		
	
		/**
		 * 创建菜单 
		 * 
		 */		
		protected function createMenu():void{
			this.menu=new MenuItem();
			this.menu.addEventListener(MenuEvent.Cell_Click,onMenuCellClick);
			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveStage);
		} 
		/**
		 * 点击菜单选项事件
		 * @param e
		 * 
		 */		
		protected function onMenuCellClick(e:MenuEvent):void{
			this.dispatchEvent(new MenuEvent(e.type,false,false,e.cell,this.menu.roleInfo));
		}
		
		
		protected function onRemoveStage(e:Event):void{
			this.stage.removeEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			if(GameCommonData.GameInstance.GameUI.contains(this.menu)){
				GameCommonData.GameInstance.GameUI.removeChild(this.menu);
			}
		}
		
		protected function onAddToStage(e:Event):void{
			this.stage.addEventListener(MouseEvent.CLICK,onStageMouseClickHanlder);
		}
		
		protected function onStageMouseClickHanlder(e:MouseEvent):void{
			if(this.stage==null)return;
			if(GameCommonData.GameInstance.GameUI.contains(this.menu) ){
				GameCommonData.GameInstance.GameUI.removeChild(this.menu);
				this.isShow=false;
			}
		}		
						
		/**
		 * 重绘 
		 * 
		 */		
		protected function toRepaint(page:int):void{
			this.removeAllCells();
			this.createMenu();
			for(var i:int = this.currentPage * onePageNum;i < this.roleList.length; i++){
				if(i < (this.currentPage +1)*onePageNum){
					this.createChildren(this.roleList[i] as PlayerInfoStruct);
					this.roleCount += 1;
				}
			}
			this.roleList = [];
			//this.doLayout();
		}
		
		
		/**
		 * 获取渲染器
		 * @return 渲染器 
		 * 
		 */		
		protected function getCell():*{
			//var cell:*=this.cacheCells.shift();
			var cell:*;
			if(cell==null){
				cell=new (friendSwf.loaderInfo.applicationDomain.getDefinition("friendCell"));
				//this.addChild(cell);
			}
			this.cells.push(cell);
			return cell;
		}
	}
}