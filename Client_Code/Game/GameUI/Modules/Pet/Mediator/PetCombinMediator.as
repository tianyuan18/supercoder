package GameUI.Modules.Pet.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Proxy.DataProxy;
	import GameUI.UIConfigData;
	import GameUI.Modules.Bag.Proxy.BagData;
	import GameUI.View.BaseUI.PanelBase;
	import GameUI.Modules.Pet.Data.PetPropConstData;
	import GameUI.Modules.Bag.Proxy.GridUnit;
	import GameUI.Modules.Pet.Proxy.PetCombinGridManager;
	import GameUI.View.items.UseItem;
	import GameUI.SetFrame;
	import GameUI.Modules.GmTools.Utils.LoadSwfTool;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PetCombinMediator extends Mediator
	{
		public static const NAME:String = "PetCombinMediator";
		private var panelBase:PanelBase;
		private var parentView:MovieClip;
		private var petRuneDataList:Array = null;
		private var petCombinGrid:PetCombinGridManager = null;
		private var cacheCells:Array=[];
		
		private var loadswfTool:LoadSwfTool;
		
		public function PetCombinMediator(parentMc:MovieClip, _loadswfTool:LoadSwfTool=null)
		{
			parentView = parentMc;
			super(NAME);
			this.loadswfTool = _loadswfTool;
		}
		
		public function get PetCombin():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				EventList.INITPETPANEL,
				EventList.OPENPETCOMBINATION,					//打开宠物合体
				EventList.CLOSEPETCOMBINATION					//关闭宠物合体
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case EventList.INITPETPANEL:
//					facade.sendNotification(EventList.GETRESOURCE, {type:UIConfigData.MOVIECLIP, mediator:this, name:"petCombination"});
					this.setViewComponent(this.loadswfTool.GetResource().GetClassByMovieClip("petCombination"));
					this.PetCombin.mouseEnabled=false;
					petCombinGrid = new PetCombinGridManager();
					break;
				case EventList.OPENPETCOMBINATION:
					
					registerView();
					initData();
					initGrid();
					initPetRuneData();
					petCombinGrid.init();
					PetCombin.x =160;
					PetCombin.y = 260;
					PetCombin.mouseEnabled = false;
					PetPropConstData.SelectedPetItem = null;
					showPetRune();
					parentView.addChild(PetCombin);
					break;
				case EventList.CLOSEPETCOMBINATION:
					retrievedView();
					parentView.removeChild(PetCombin);
					break;
			}
		}
		
		private function initData():void
		{
			//获取宠物数据
			for( var i:int = 0; i<PetPropConstData.petRuneGridNum; i++ ) 
			{
				var gridUnit:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
				gridUnit.x = PetCombin["Rune_"+i].x;
				gridUnit.y = PetCombin["Rune_"+i].y;
//				gridUnit.name = "Rune_" + i.toString();
				PetCombin.addChild(gridUnit);
				var gridUint:GridUnit = new GridUnit(gridUnit, true);
				gridUint.parent = PetCombin;								//设置父级
				gridUint.Index = i;											//格子的位置		
				gridUint.HasBag = true;										//是否是可用的背包
				gridUint.IsUsed	= false;									//是否已经使用
				gridUint.Item	= null;										//格子的物品
				PetPropConstData.petRuneGridList.push(gridUint);
			}
		}
		
		private function initPetRuneData():void
		{
			petRuneDataList = new Array();
			for(var i:int=0;i<BagData.AllUserItems[0].length;i++)
			{
				if(BagData.AllUserItems[0][i] != null && BagData.AllUserItems[0][i] != undefined/* && BagData.AllUserItems[0][i].id>1799 && BagData.AllUserItems[0][i].id<2000*/)
				{
					
					petRuneDataList.push(BagData.AllUserItems[0][i]);
				}
			}
		}
		
		/** 初始化合体符栏 */
		private function initGrid():void
		{
			for( var i:int = 0; i<PetPropConstData.petRuneGridNum; i++ ) 
			{
				var gridUnit:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
				gridUnit.x = PetCombin["Rune_"+i].x;
				gridUnit.y = PetCombin["Rune_"+i].y;
				gridUnit.name = "Rune_" + i.toString();
				PetCombin.addChild(gridUnit);
				var gridUint:GridUnit = new GridUnit(gridUnit, true);
				gridUint.parent = PetCombin;									//设置父级
				gridUint.Index = i;											//格子的位置		
				gridUint.HasBag = true;										//是否是可用的背包
				gridUint.IsUsed	= false;									//是否已经使用
				gridUint.Item	= null;										//格子的物品
				PetPropConstData.petRuneGridList.push(gridUint);
			}
		}
		
		private function registerView():void
		{
			//初始化素材事件
			(PetCombin.mcLeft as MovieClip).gotoAndStop(1);
			(PetCombin.mcRight as MovieClip).gotoAndStop(1);
			
		}
		
		private function retrievedView():void
		{
			//释放素材事件
		}
		
		/** 显示宠物合体符
		 * 
		 * 	index 代表翻页
		 * 
		 *  */
		private function showPetRune(index:int=0):void
		{			
			//移除所有界面上的物品	
			
			removeAllItem();
			
			//			var a:Array = BagData.BagNum;
			if(PetPropConstData.petRuneGridList.length == 0) return;
			var count:int = 0;
			for(var i:int = index*PetPropConstData.petEuipGridNum; i<(index+1)*PetPropConstData.petEuipGridNum; i++)
			{
				//无数据,背包为空
				if(petRuneDataList[i] == null) 
				{
					return;
				};
				//添加物品
				addItem(petRuneDataList[i],i%((index+1)*PetPropConstData.petEuipGridNum));	
			}
			//目前有锁定的物品则显示操作按钮，加外框		
			if(PetPropConstData.SelectedPetItem)
			{
				SetFrame.UseFrame(PetPropConstData.SelectedPetItem.Grid);
			}	
		}
		
		private function removeAllItem():void
		{
			
		}
		
		/**添加物品，初始化格子数组,如果有物品在cd添加cd
		 * index 对应装备框位置
		 */
		private function addItem(item:Object,index:int):void
		{
			/** 此处item是从物品数组中取出，item。index对应的是背包的位置
			 * 	使用UseItem实例才能和后台通行，使用装备
			 *  */
			var useItem:UseItem = this.getCells(item.index, item.type, PetCombin);
			useItem.x = PetPropConstData.petRuneGridList[index].Grid.x+2;
			useItem.y = PetPropConstData.petRuneGridList[index].Grid.y+2;
			useItem.Id = item.id;
			useItem.IsBind = item.isBind;
			useItem.Type = item.type;
			
			PetPropConstData.petRuneGridList[index].Item = useItem;
			PetPropConstData.petRuneGridList[index].IsUsed = true;
			PetPropConstData.petRuneGridList[index].HasBag = true;
			(PetPropConstData.petRuneGridList[index] as GridUnit).Grid.name = "bag_" + item.index.toString();
			PetCombin.addChild(useItem);	
		}
		
		/** 创建UseItem实例 */
		protected function getCells(pos:int, icon:String, parent:DisplayObjectContainer):UseItem{
			
			var useItem:UseItem=this.cacheCells.shift();
			useItem=new UseItem(pos,icon,parent);
			return useItem;
		}
	}
}