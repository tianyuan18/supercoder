package GameUI.Modules.Pet.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Mediator.UiNetAction;
	import GameUI.Modules.Bag.Proxy.BagData;
	import GameUI.Modules.Bag.Proxy.GridUnit;
	import GameUI.Modules.GmTools.Utils.LoadSwfTool;
	import GameUI.Modules.Pet.Data.PetEvent;
	import GameUI.Modules.Pet.Data.PetPropConstData;
	import GameUI.Modules.Pet.Proxy.PetEquipGridManager;
	import GameUI.Proxy.DataProxy;
	import GameUI.SetFrame;
	import GameUI.UIConfigData;
	import GameUI.View.BaseUI.PanelBase;
	import GameUI.View.items.UseItem;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PetEquipMediator extends Mediator
	{
		public static const NAME:String = "PetEquipMediator";
		private var panelBase:PanelBase;
		private var parentView:MovieClip;
		private var petEquipGrid:PetEquipGridManager = null;
		private var petEquipDataList:Array = null;
		private var cacheCells:Array=[];
		private var loadswfTool:LoadSwfTool;
		private var subIndexPage:int = 0;
		private var maxIndexPage:int = 1;
		
		public function PetEquipMediator(parentMc:MovieClip, _loadswfTool:LoadSwfTool=null)
		{
			parentView = parentMc;
			super(NAME);
			this.loadswfTool = _loadswfTool;
		}

		public function get PetEquip():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				EventList.INITPETPANEL,
				PetEvent.PET_UPDATE_EQUIP_INFO,			//更新数据
				EventList.OPENPETEQUIP,					//打开宠物装备
				
				EventList.CLOSEPETEQUIP					//关闭宠物装备
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case EventList.INITPETPANEL:
//					facade.sendNotification(EventList.GETRESOURCE, {type:UIConfigData.MOVIECLIP, mediator:this, name:"petEquip"});
					this.setViewComponent(this.loadswfTool.GetResource().GetClassByMovieClip("petEquip"));
					this.PetEquip.mouseEnabled=false;
					petEquipGrid = new PetEquipGridManager();
					break;
				case EventList.OPENPETEQUIP:
					
					registerView();
					initData();
					initPetEquipData();
					initGrid();
					petEquipGrid.init();
					PetEquip.x = 160;
					PetEquip.y = 250;
					PetEquip.mouseEnabled = false;
					PetPropConstData.SelectedPetItem = null;
					showPetEquip();
//					showPetEquipInfo();
					parentView.addChild(PetEquip);
					break;
				case EventList.CLOSEPETEQUIP:
					retrievedView();
					parentView.removeChild(PetEquip);
					petEquipDataList = null;
					petEquipGrid.gc();
					break;
				case PetEvent.PET_UPDATE_EQUIP_INFO:
					if(PetPropConstData.curPage==1)
					{
						petEquipGrid.gc();
						initPetEquipData();
						initGrid();
						
						initData();
						petEquipGrid.init();
						showPetEquip(this.subIndexPage);
					}
					
//					showPetEquipInfo();
					break;
				
			}
		}
		
		private function initData():void
		{
			//获取宠物数据
			
		}
		
		private function registerView():void
		{
			//初始化素材事件
//			(PetEquip.mcLeft as MovieClip).gotoAndStop(1);
//			(PetEquip.mcRight as MovieClip).gotoAndStop(1);
//			
			PetEquip.mcLeft.addEventListener(MouseEvent.CLICK,onBtnClick);
			PetEquip.mcRight.addEventListener(MouseEvent.CLICK,onBtnClick);
		}
		
		private function retrievedView():void
		{
			//释放素材事件
			PetEquip.mcLeft.removeEventListener(MouseEvent.CLICK,onBtnClick);
			PetEquip.mcRight.removeEventListener(MouseEvent.CLICK,onBtnClick);
		}
		
		/** 初始化装备栏 */
		private function initGrid():void
		{
			var index:int = this.subIndexPage*PetPropConstData.petEuipGridNum;
			var count:int = petEquipDataList.length<(index+PetPropConstData.petEuipGridNum)?petEquipDataList.length:(index+PetPropConstData.petEuipGridNum);
			for( var i:int = index; i<count; i++ ) 
			{
				var gridUnit:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
				gridUnit.x = PetEquip["PetEquipBag_"+(i-index).toString()].x;
				gridUnit.y = PetEquip["PetEquipBag_"+(i-index).toString()].y;
				PetEquip.addChild(gridUnit);
				var gridUint:GridUnit = new GridUnit(gridUnit, true);
				gridUint.parent = PetEquip;									//设置父级
				gridUint.Index = petEquipDataList[i].Index;											//格子的位置		
				gridUint.HasBag = true;										//是否是可用的背包
				gridUint.IsUsed	= false;									//是否已经使用
				gridUint.Item	= null;										//格子的物品
				PetPropConstData.petEquipGridList[petEquipDataList[i].index] = gridUint;
			}
		}
		
		private function onBtnClick(e:MouseEvent):void
		{
			var name:String = e.currentTarget.name;
			switch(name)
			{
				case "mcLeft":
					if(subIndexPage>0)
					{
						subIndexPage--;
						facade.sendNotification(PetEvent.PET_UPDATE_EQUIP_INFO);
					}
					
					break;
				case "mcRight":
					if(subIndexPage<maxIndexPage-1)
					{
						subIndexPage++;
						facade.sendNotification(PetEvent.PET_UPDATE_EQUIP_INFO);
					}
					break;
			}
		}
		
		private function initPetEquipData():void
		{
			petEquipDataList = new Array();
			for(var i:int=0;i<BagData.AllUserItems[0].length;i++)
			{
				var item:Object = BagData.AllUserItems[0][i];
				if(BagData.AllUserItems[0][i] != null && BagData.AllUserItems[0][i] != undefined)
				{
					var type:int = BagData.AllUserItems[0][i].type;
					if((type>140000 && type<160000)||(type>190000 && type<220000))
					{
						petEquipDataList.push(item);
					}
					
				}
			}
			
			maxIndexPage = (petEquipDataList.length-1)/PetPropConstData.petEuipGridNum + 1;
			
			PetEquip.txtPage.text = (this.subIndexPage+1)+"/"+this.maxIndexPage;
		}
		
		/** 显示宠物装备
		 * 
		 * 	index 代表翻页
		 * 
		 *  */
		private function showPetEquip(index:int=0):void
		{			
			//移除所有界面上的物品	
			
			removeAllItem();
			
			//			var a:Array = BagData.BagNum;
			if(PetPropConstData.petEquipGridList.length == 0) return;
			var count:int = 0;
			for(var i:int = index*PetPropConstData.petEuipGridNum; i<petEquipDataList.length&&i<(index+1)*PetPropConstData.petEuipGridNum; i++)
			{
				//无数据,背包为空
				if(petEquipDataList[i]) 
				{
					//添加物品
					addItem(petEquipDataList[i],i%((index+1)*PetPropConstData.petEuipGridNum));	
				}
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
			var useItem:UseItem = this.getCells(item.index, item.type, PetEquip);
			useItem.x = PetPropConstData.petEquipGridList[petEquipDataList[index].index].Grid.x+2;
			useItem.y = PetPropConstData.petEquipGridList[petEquipDataList[index].index].Grid.y+2;
			useItem.Id = item.id;
			useItem.IsBind = item.isBind;
			useItem.Type = item.type;

			PetPropConstData.petEquipGridList[petEquipDataList[index].index].Item = useItem;
			PetPropConstData.petEquipGridList[petEquipDataList[index].index].IsUsed = true;
			PetPropConstData.petEquipGridList[petEquipDataList[index].index].HasBag = true;
			(PetPropConstData.petEquipGridList[petEquipDataList[index].index] as GridUnit).Grid.name = "bag_" + item.index.toString();

			PetEquip.addChild(useItem);	
		}
		
		/** 创建UseItem实例 */
		protected function getCells(pos:int, icon:String, parent:DisplayObjectContainer):UseItem{
			
			var useItem:UseItem=this.cacheCells.shift();
			useItem=new UseItem(pos,icon,parent);
			return useItem;
		}
	}
}