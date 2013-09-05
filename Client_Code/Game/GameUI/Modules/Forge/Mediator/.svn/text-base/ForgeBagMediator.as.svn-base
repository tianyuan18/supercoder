package GameUI.Modules.Forge.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Mediator.UiNetAction;
	import GameUI.Modules.Bag.Proxy.BagData;
	import GameUI.Modules.Bag.Proxy.GridUnit;
	import GameUI.Modules.Forge.Data.ForgeData;
	import GameUI.Modules.Forge.Data.ForgeEvent;
	import GameUI.Modules.Forge.Proxy.*;
	import GameUI.Modules.RoleProperty.Datas.RolePropDatas;
	import GameUI.Modules.ToolTip.Const.IntroConst;
	import GameUI.Proxy.DataProxy;
	import GameUI.UIConfigData;
	import GameUI.View.BaseUI.PanelBase;
	import GameUI.View.Components.UIScrollPane;
	import GameUI.View.Components.UISprite;
	import GameUI.View.items.UseItem;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ForgeBagMediator extends Mediator
	{
		public static const NAME:String = "ForgeBagMediator";
		private var panelBase:PanelBase;
		private var parentView:MovieClip;
		private var _container:UISprite;
		private var _containerBuy:UISprite;
		protected var _scrollPaneEquip:UIScrollPane;
		protected var _scrollPaneBuy:UIScrollPane;
		protected var _w1:uint = 270;
		protected var _h1:uint = 305;
		private var _x1:uint = 10;
		private var _y1:uint = 10;
		
		protected var _w2:uint = 270;
		protected var _h2:uint = 122;
		private var _x2:uint = 10;
		private var _y2:uint = 355;

		private var itemShowList:Array = null;

		private var cacheCells:Array=[];
		
		private var forBagGrid:ForgeBagGridManager = null;
		private var buyGrid:ForgeBuyGridManager = null;
		
//		private var delayNum:Number = 0;
		private var countGetItem:int = 0;
//		private var cacheEquip:Array = null;
//		private var cacheBuy:Array = null;
		private var _nRed:Number=0.3086;
		private var _nGreen:Number=0.6094;
		private var _nBlue:Number=0.0820;
		
		public function ForgeBagMediator(parentMc:MovieClip)
		{
			parentView = parentMc;
			super(NAME);
		}
		
		public function get ForgeBag():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				ForgeEvent.INIT_FORGE_UI,
				ForgeEvent.SHOW_FORGE_BAG_UI,					//打开宠物装备
				ForgeEvent.UPDATE_ITEM_LIST,
				ForgeEvent.UPDATE_ITEM_FASTBUY,
				ForgeEvent.CLOSE_FORGE_BAG_UI					//关闭宠物装备
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ForgeEvent.INIT_FORGE_UI:
//					facade.sendNotification(EventList.GETRESOURCE, {type:UIConfigData.MOVIECLIP, mediator:this, name:"ForgeBag"});
					this.setViewComponent(ForgeData.loadswfTool.GetResource().GetClassByMovieClip("ForgeBag"));
					this.ForgeBag.mouseEnabled=false;
					ForgeBag.x = 408;
					ForgeBag.y = 27;
					forBagGrid = new ForgeBagGridManager();
					buyGrid = new ForgeBuyGridManager();
					break;
				case ForgeEvent.SHOW_FORGE_BAG_UI:
					ForgeData.selectIdArray = new Dictionary();
					registerView();
					this.initEquipData();
//					this.initBuyData();
					this.initEquipGrid();
					this.initBuyGrid();
					
					countGetItem = 1;
					setTimeout(delayGetItem,200);
					
					forBagGrid.init();
					buyGrid.init();
					parentView.addChild(ForgeBag);
					break;
				case ForgeEvent.CLOSE_FORGE_BAG_UI:
					retrievedView();
					parentView.removeChild(ForgeBag);
					forBagGrid.gc();
					buyGrid.gc();
					break;
				case ForgeEvent.UPDATE_ITEM_LIST:
//					retrievedView();
//					parentView.removeChild(ForgeBag);
//					forBagGrid.gc();
					
					
//					registerView();
//					this.initEquipData();
//					this.initBuyData();
//					this.initEquipGrid();
//					this.initBuyGrid();
//					forBagGrid.init();
//					buyGrid.init();
//					parentView.addChild(ForgeBag);
					
					removeBag();
					forBagGrid.gc();
					
					initBag();
					this.initEquipData();
					this.initEquipGrid();
					forBagGrid.init();
					initBuyData();
					break;
				case ForgeEvent.UPDATE_ITEM_FASTBUY:
					var buyList:Array = notification.getBody().data;
					
					removeBuy();
					buyGrid.gc();
					
					initBuy();
//					this.initBuyData();
					this.initBuyGrid(buyList);
					buyGrid.init();
					break;
			}
		}
		
		private function initEquipData():void
		{
			//获取装备栏数据
			ForgeData.equipList = new Array();//前14位存放装备身上的装备

			var type:int = 0;
			var equipId:int = 0;
			ForgeData.countEquiped = 0;
			var item:Object;
			var i:int=0;
			
			switch(ForgeData.curPage)
			{
				case 0:
				case 1:
				case 2:
				case 3:
				case 4:
					
					
					for(i=0;i<RolePropDatas.ItemList.length;i++)
					{
						item = RolePropDatas.ItemList[i];
						if(RolePropDatas.ItemList[i] != null && RolePropDatas.ItemList[i] != undefined/** 筛选 */)
						{
							if(item.color<2)continue;
							type = RolePropDatas.ItemList[i].type;
							equipId = type/10000;
							if( (equipId>10 && equipId<16) || (equipId>16 && equipId<20) || (equipId>20 && equipId<24)/* && equipId!=16*/)
							{
								ForgeData.equipList.push(RolePropDatas.ItemList[i]);
								if(!IntroConst.ItemInfo[RolePropDatas.ItemList[i].id])
								{
									UiNetAction.GetItemInfo(RolePropDatas.ItemList[i].id,GameCommonData.Player.Role.Id,GameCommonData.Player.Role.Name);
								}
								ForgeData.countEquiped++;
							}
							
						}
					}
					for(i=0;i<BagData.AllUserItems[0].length;i++)
					{
						item = BagData.AllUserItems[0][i];
						if(BagData.AllUserItems[0][i] != null && BagData.AllUserItems[0][i] != undefined/** 筛选 */)
						{
							if(item.color<2)continue;
							type = BagData.AllUserItems[0][i].type;
							equipId = type/10000;
							if((equipId>10 && equipId<16) || (equipId>16 && equipId<20) || (equipId>20 && equipId<24)/* && equipId!=16*/)
							{
								ForgeData.equipList.push(BagData.AllUserItems[0][i]);
								if(!IntroConst.ItemInfo[BagData.AllUserItems[0][i].id])
								{
									UiNetAction.GetItemInfo(BagData.AllUserItems[0][i].id,GameCommonData.Player.Role.Id,GameCommonData.Player.Role.Name);
								}
							}
						}
					}
					break;
				case 5:

					for(i=0;i<RolePropDatas.ItemList.length;i++)
					{
						item = RolePropDatas.ItemList[i];
						if(RolePropDatas.ItemList[i] != null && RolePropDatas.ItemList[i] != undefined && item.color>3)
						{
							type = RolePropDatas.ItemList[i].type;
							equipId = type/10000;
							if( (equipId>10 && equipId<16) || (equipId>16 && equipId<20) || (equipId>20 && equipId<24)/* && equipId!=16*/)
							{
								ForgeData.equipList.push(RolePropDatas.ItemList[i]);
								if(!IntroConst.ItemInfo[RolePropDatas.ItemList[i].id])
								{
									UiNetAction.GetItemInfo(RolePropDatas.ItemList[i].id,GameCommonData.Player.Role.Id,GameCommonData.Player.Role.Name);
								}
								ForgeData.countEquiped++;
							}
							
						}
					}
					for(i=0;i<BagData.AllUserItems[0].length;i++)
					{
						item = BagData.AllUserItems[0][i];
						if(BagData.AllUserItems[0][i] != null && BagData.AllUserItems[0][i] != undefined && item.color>3)
						{
							type = BagData.AllUserItems[0][i].type;
							equipId = type/10000;
							if((equipId>10 && equipId<16) || (equipId>16 && equipId<20) || (equipId>20 && equipId<24)/* && equipId!=16*/)
							{
								ForgeData.equipList.push(BagData.AllUserItems[0][i]);
								if(!IntroConst.ItemInfo[BagData.AllUserItems[0][i].id])
								{
									UiNetAction.GetItemInfo(BagData.AllUserItems[0][i].id,GameCommonData.Player.Role.Id,GameCommonData.Player.Role.Name);
								}
							}
						}
					}
					break;
			}
		}
		
		private function initBuyData():void
		{
			/**获取自动购买栏数据
			*/
			
			switch(ForgeData.curPage)
			{
				case 0:
//					
//					for(i=0;i<BagData.AllUserItems[0].length;i++)
//					{
//						if(BagData.AllUserItems[0][i] != null && BagData.AllUserItems[0][i] != undefined && BagData.AllUserItems[0][i].id>60420 && BagData.AllUserItems[0][i].id<60500/** 筛选 */)
//						{
//							buyList.push(BagData.AllUserItems[0][i]);
//						}
//					}
					break;
				case 1:
//				for(i=0;i<BagData.AllUserItems[0].length;i++)
//				{
//					if(BagData.AllUserItems[0][i] != null && BagData.AllUserItems[0][i] != undefined && BagData.AllUserItems[0][i].id>60600 && BagData.AllUserItems[0][i].id<60650/** 筛选 */)
//					{
//						buyList.push(BagData.AllUserItems[0][i]);
//					}
//				}
//				break;
				case 2:
//				for(i=0;i<BagData.AllUserItems[0].length;i++)
//				{
//					if(BagData.AllUserItems[0][i] != null && BagData.AllUserItems[0][i] != undefined && BagData.AllUserItems[0][i].id>60600 && BagData.AllUserItems[0][i].id<60650/** 筛选 */)
//					{
//						buyList.push(BagData.AllUserItems[0][i]);
//					}
//				}
//				break;
				case 3:
//					var buyList:Array = new Array();
//					var good:Object = new Object();
//					var i:int=0;
//					for(i=0;i<BagData.AllUserItems[0].length;i++)
//					{
//						if(BagData.AllUserItems[0][i] != null && BagData.AllUserItems[0][i] != undefined /** 筛选 */)
//						{
//							var type:int = BagData.AllUserItems[0][i].type/100000;
//							if(type == 4)//第一位为4表示镶嵌宝石
//							{
//								good = new Object();
//								good.type = BagData.AllUserItems[0][i].type;
//								good.name = BagData.AllUserItems[0][i].name;
//								good.num = BagData.hasItemNum(good.type);
//								buyList.push(good);
//							}
//						}
//					}
//					facade.sendNotification(ForgeEvent.UPDATE_ITEM_FASTBUY,{data:buyList});
				break;
//				case 4:
//				for(i=0;i<BagData.AllUserItems[0].length;i++)
//				{
//					if(BagData.AllUserItems[0][i] != null && BagData.AllUserItems[0][i] != undefined && BagData.AllUserItems[0][i].id>60600 && BagData.AllUserItems[0][i].id<60650/** 筛选 */)
//					{
//						buyList.push(BagData.AllUserItems[0][i]);
//					}
//				}
//				break;
//				case 5:
//				for(i=0;i<BagData.AllUserItems[0].length;i++)
//				{
//					if(BagData.AllUserItems[0][i] != null && BagData.AllUserItems[0][i] != undefined && BagData.AllUserItems[0][i].id>60680 && BagData.AllUserItems[0][i].id<60690/** 筛选 */)
//					{
//						buyList.push(BagData.AllUserItems[0][i]);
//					}
//				}
//				break;
			}
		}

		private function delayGetItem():void
		{
			var newItem:Object = null;

			for(var i:int=0; i<itemShowList.length; i++)
			{
				newItem = IntroConst.ItemInfo[ForgeData.equipList[i].id];
				if(newItem)
				{
					itemShowList[i].txtStrenghLev.text = "强化+"+newItem.level;
				}
			}
			if(countGetItem == 1)
			{
				setTimeout(delayGetItem,1000);
				countGetItem = 0;
			}
		}
		
		private function initEquipGrid():void
		{
			itemShowList = new Array();
			
			var h:int = 0;
			for(var i:int=0; i<ForgeData.equipList.length; i++)
			{
				if(ForgeData.equipList[i] == null)continue;
				var tmpShow:MovieClip = ForgeData.loadswfTool.GetResource().GetClassByMovieClip("ItemShow");
				if(i%2 == 0)
				{
					tmpShow.x = 1;
					h+=58;
				}else
				{
					tmpShow.x = 125;
				}
				tmpShow.y = (int(i/2))*58;
				tmpShow.name = "tmpShow__"+i.toString();

				(tmpShow.Equiped as MovieClip).visible = false;
				(tmpShow.Equiped as MovieClip).mouseChildren = false;
				(tmpShow.Equiped as MovieClip).mouseEnabled = false;
				
				var useItem:UseItem = this.getCells(ForgeData.equipList[i].index, ForgeData.equipList[i].type, tmpShow);
				useItem.x = 6;
				useItem.y = 10;
				useItem.Id = ForgeData.equipList[i].id;
				useItem.IsBind = ForgeData.equipList[i].isBind;
				useItem.Type = ForgeData.equipList[i].type;
				useItem.setImageScale(34,34);
				
				var gridUnit:MovieClip = null;
				var gridUint:GridUnit = null;
				
				if(i<ForgeData.countEquiped)//前14位存放装备身上的装备
				{
					(tmpShow.Equiped as MovieClip).visible = true;
					gridUnit = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
					gridUnit.x = 4;
					gridUnit.y = 8;
					gridUnit.name = "hero_"+ForgeData.equipList[i].position.toString()+"_"+i;
					gridUnit.mouseChildren = false;
					tmpShow.addChild(gridUnit);
					
					gridUint = new GridUnit(tmpShow, true);
					gridUint.parent = tmpShow;									//设置父级
					gridUint.Index = ForgeData.equipList[i].index;											//格子的位置		
					gridUint.Item	= useItem;								//格子的物品
//					gridUint.Grid.name = "bag_"+ForgeData.equipList[i].index.toString();
					ForgeData.forgeEquipGridList[i] = gridUint;
				}else
				{
					gridUnit = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
					gridUnit.x = 4;
					gridUnit.y = 8;
					gridUnit.name = "bag_"+ForgeData.equipList[i].index.toString()+"_"+i;
					tmpShow.addChild(gridUnit);
					
					gridUint = new GridUnit(tmpShow, true);
					gridUint.parent = tmpShow;									//设置父级
					gridUint.Index = ForgeData.equipList[i].index;											//格子的位置		
					gridUint.Item	= useItem;								//格子的物品
//					gridUint.Grid.name = "bag_"+ForgeData.equipList[i].index.toString();
					ForgeData.forgeEquipGridList[i] = gridUint;
				}
				
				
				tmpShow.addChild(useItem);
				
				var newItem:Object = IntroConst.ItemInfo[ForgeData.equipList[i].id];
				if(newItem)
				{
					var index:int = int(ForgeData.equipList[i].color);
					tmpShow.txtName.htmlText = "<font COLOR='"+ForgeData.equipColorList[index]+"'>"+newItem.itemName+"</font>";
					tmpShow.txtStrenghLev.text = "强化+"+newItem.level;
				}
				else
				{
					newItem = UIConstData.ItemDic_1[ForgeData.equipList[i].type];
					index = int(ForgeData.equipList[i].color);
					tmpShow.txtName.htmlText = "<font COLOR='"+ForgeData.equipColorList[index]+"'>"+newItem.Name+"</font>";
					tmpShow.txtStrenghLev.text = "加载中...";
				}
				
				var a:Object = ForgeData.selectIdArray;
				if(ForgeData.selectIdArray[ForgeData.equipList[i].id])
				{
					ForgeData.forgeEquipGridList[i].Grid.filters=[new ColorMatrixFilter([_nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, 0, 0, 0, 1, 0])];
					
					ForgeData.forgeEquipGridList[i].Grid.mouseEnabled = false;
					ForgeData.forgeEquipGridList[i].Grid.mouseChildren = false;
				}
				itemShowList.push(tmpShow);
				this._container.addChild(tmpShow);
			}
			this._container.height = h;
			this._scrollPaneEquip.refresh();
		}
		
		private function initBuyGrid(buyList:Array = null):void
		{
			if(buyList == null)return;
			var h:int = 0;
			for(var i:int=0; i<buyList.length; i++)
			{
				var tmpBuy:MovieClip = ForgeData.loadswfTool.GetResource().GetClassByMovieClip("ItemBuy");
				if(i%2 == 0)
				{
					tmpBuy.x = 1;
					h+=58;
				}else
				{
					tmpBuy.x = 125;
				}
				tmpBuy.y = (int(i/2))*58;
				tmpBuy.name ="tmpBuy" + i.toString();
				tmpBuy.item.mouseEnabled = false;
				tmpBuy.item.mouseChildren = false;
				tmpBuy.mouseEnabled = false;
//				tmpBuy.name ="Decompose_" + buyList[i].type.toString();
				
				var useItem:UseItem = this.getCells(buyList[i].index, buyList[i].type, tmpBuy);
				useItem.x = tmpBuy.item.x+2;
				useItem.y = tmpBuy.item.y+2;
				useItem.Id = buyList[i].id;
				useItem.IsBind = buyList[i].isBind;
				useItem.Type = buyList[i].type;
				useItem.setImageScale(34,34);
//				useItem.name = "Decompose_"+buyList[i].type.toString();
				(useItem as Sprite).mouseChildren = false;
				tmpBuy.addChild(useItem);
				var gridUnit:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
				gridUnit.x = tmpBuy.item.x;
				gridUnit.y = tmpBuy.item.y;
//				tmpBuy.addChild(gridUnit);
				
				var gridUint:GridUnit = new GridUnit(gridUnit, true);
				gridUint.parent = ForgeBag;									//设置父级
				gridUint.Index = buyList[i].index;											//格子的位置		
				gridUint.Item	= useItem;	
				gridUint.Grid = gridUnit;//格子的物品
				gridUint.Grid.name = "Decompose_"+buyList[i].type.toString();
				
				tmpBuy.addChild(gridUnit);
				tmpBuy.txtName.text = buyList[i].name;
				tmpBuy.txtNum.text = "X"+buyList[i].num;
				tmpBuy.txtType.text = buyList[i].type;
				tmpBuy.txtType.visible = false;
				
				ForgeData.forgeBuyGridList[i] = tmpBuy;
				this._containerBuy.addChild(tmpBuy);
			}
			this._containerBuy.height = h;
			this._scrollPaneBuy.refresh();
		}
		
		private function registerView():void
		{
			//初始化素材事件

			initBag();
			initBuy();
			ForgeBag.mouseEnabled=false;
			
			ForgeBag.bindFirst.gotoAndStop(2);
			(ForgeBag.bindFirst as MovieClip).addEventListener(MouseEvent.CLICK,onSelectBuyType);
			ForgeBag.autoBuy.gotoAndStop(2);
			(ForgeBag.autoBuy as MovieClip).addEventListener(MouseEvent.CLICK,onSelectBuyType);
		}
		
		private function initBag():void
		{
			this._container=new UISprite();
			this._container.width=this._w1-16;
			this._container.height=this._h1;
			this._scrollPaneEquip=new UIScrollPane(this._container);
			this._scrollPaneEquip.setHideType(1);
			
			this._scrollPaneEquip.mouseEnabled=false;
			this._scrollPaneEquip.width=this._w1; 
			this._scrollPaneEquip.height=this._h1;
			this._scrollPaneEquip.x=this._x1; 
			this._scrollPaneEquip.y=this._y1;
			this._scrollPaneEquip.scrollPolicy=UIScrollPane.SCROLLBAR_AS_NEEDED;
			ForgeBag.addChild(this._scrollPaneEquip);
			
			this._scrollPaneEquip.refresh();
		}
		
		private function initBuy():void
		{
			this._containerBuy=new UISprite();
			this._containerBuy.width=this._w2-16;
			
			this._scrollPaneBuy=new UIScrollPane(this._containerBuy);
			this._scrollPaneBuy.setHideType(1);
			this._scrollPaneBuy.mouseEnabled=false;
			this._scrollPaneBuy.width=this._w2; 
			this._scrollPaneBuy.height=this._h2;
			this._scrollPaneBuy.x=this._x2; 
			this._scrollPaneBuy.y=this._y2;
			this._scrollPaneBuy.scrollPolicy=UIScrollPane.SCROLLBAR_AS_NEEDED;
			ForgeBag.addChild(this._scrollPaneBuy);
			
			this._scrollPaneBuy.refresh();
		}

		private function retrievedView():void
		{
			//释放素材事件
			removeBag();
			removeBuy();			
		}
		
		private function removeBag():void
		{
			
			if(this._scrollPaneEquip&&ForgeBag.contains(this._scrollPaneEquip))
			{
				this._scrollPaneEquip.refresh();
				ForgeBag.removeChild(this._scrollPaneEquip);
			}
		}
		
		private function removeBuy():void
		{
			if(this._scrollPaneBuy&&ForgeBag.contains(this._scrollPaneBuy))
			{
				this._scrollPaneBuy.refresh();
				ForgeBag.removeChild(this._scrollPaneBuy);
			}
		}
		
		protected function getCells(pos:int, icon:String, parent:DisplayObjectContainer):UseItem{
			
			var useItem:UseItem=this.cacheCells.shift();
			useItem=new UseItem(pos,icon,parent);
			return useItem;
		}
		
		private function onSelectBuyType(e:MouseEvent):void
		{
			var name:String = e.currentTarget.name;
			
			switch(name)
			{
				case "bindFirst":
					break;
				case "autoBuy":
					break;
			}
		}
	}
}