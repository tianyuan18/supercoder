package GameUI.Modules.Stone.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Mediator.UiNetAction;
	import GameUI.Modules.Bag.Proxy.BagData;
	import GameUI.Modules.Bag.Proxy.GridUnit;
	import GameUI.Modules.RoleProperty.Datas.RolePropDatas;
	import GameUI.Modules.Stone.Datas.*;
	import GameUI.Modules.Stone.Proxy.StoneGridManager;
	import GameUI.Modules.ToolTip.Const.IntroConst;
	import GameUI.Proxy.DataProxy;
	import GameUI.UIConfigData;
	import GameUI.View.BaseUI.PanelBase;
	import GameUI.View.items.UseItem;
	
	import Net.ActionSend.EquipSend;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class MosaicMediator extends Mediator
	{
		public static const NAME:String = "MosaicMediator";
//		private var panelBase:PanelBase;
		private var parentView:MovieClip;
		private var cacheCells:Array=[];
		private var equip:GridUnit = null;
		private var item:Object = null;
		private var ItemArr:Array = [];//存放孔数据
		private var delayNum:Number = 0;
		
		private var stoneList:Array = [];//存放孔UI
		
		private var useId:int = 0;//存放配置文件物品ID
		
		private var _nRed:Number=0.3086;
		private var _nGreen:Number=0.6094;
		private var _nBlue:Number=0.0820;
		private var lastIndex:int = -1;
		private var lastFilter:Array = null;
		private var stoneGrid:StoneGridManager=null;
		
		private var subIndexPage:int = 0;
		private var maxIndexPage:int = 1;
		
		private var stoneIndexPage:int = 0;
		private var maxStoneIndexPage:int = 1;
		
		private var equipGridList:Array = new Array();
		
		public var STARTPOS:Point = new Point(17, 45);
		
		private var selectPosition:int = -1;
		
//		private var itemEquipList:Array = new Array();
		
		public function MosaicMediator(parentMc:MovieClip)
		{
			parentView = parentMc;
			super(NAME);
		}
		
		public function get Mosaic():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				StoneEvents.INIT_STONE_UI,
				StoneEvents.SHOW_STONE_MOSAIC_UI,					//打开装备
				StoneEvents.CLOSE_STONE_MOSAIC_UI,					//关闭装备
				StoneEvents.UPDATE_EQUIP_STONE_UI,
				StoneEvents.UPDATE_STONE_MOSAIC_UI,
				StoneEvents.SELECT_MATERIAL_ONMOUSEDOWN
//				ForgeEvent.SELECT_MATERIAL_ONMOUSEDOWN,
//				ForgeEvent.UPDATE_SELECT_ITEM,
//				EventList.UPDATEMONEY,
//				ForgeEvent.SELECT_ITEM_ONMOUSEDOWN					//选中物品事件
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case StoneEvents.INIT_STONE_UI:
//					facade.sendNotification(EventList.GETRESOURCE, {type:UIConfigData.MOVIECLIP, mediator:this, name:"Mosaic"});
					this.setViewComponent(StoneDatas.stoneLoadswfTool.GetResource().GetClassByMovieClip("Mosaic"));
					this.Mosaic.mouseEnabled=false;
					stoneGrid = new StoneGridManager();
					initGrid();
					Mosaic.x = 0;
					Mosaic.y = -3;
					break;
				case StoneEvents.SHOW_STONE_MOSAIC_UI:			
					registerView();
					initData();
					
					initEquipData();
					showEquipData(this.subIndexPage);
					initStoneData();
					showStoneData(this.subIndexPage);
					stoneGrid.init();
					parentView.addChild(Mosaic);
					break;
				case StoneEvents.CLOSE_STONE_MOSAIC_UI:
					stoneGrid.gc();
					this.retrievedView();
					parentView.removeChild(Mosaic);
					break;
//				case StoneEvents.SELECT_ITEM_ONMOUSEDOWN:
////					trace(StoneDatas.curPage);
//					if(StoneDatas.curPage == 3)
//					{
//						this.clearEquip();
//						this.clearStoneList();
//						showEquip(notification.getBody() as int);
//						this.onSelectEquip(notification.getBody() as int);
//					}
//					break;
				case StoneEvents.SELECT_MATERIAL_ONMOUSEDOWN:
					if(StoneDatas.stoneCurPage == 0)
					{
						var index:int = int(notification.getBody());
						showStone(index);
					}
					break;
//				case ForgeEvent.UPDATE_SELECT_ITEM:
//					if(StoneDatas.curPage == 3)
//					{
//						var id:int = notification.getBody() as int;
//						if(StoneDatas.stoneSelectItem == null || id != StoneDatas.stoneSelectItem.Item.Id) return;
//						this.clearStoneList();
//						this.showEquipInfo(id);
//					}
//					break;
//				case EventList.UPDATEMONEY:															//更新钱
//					
//					switch (notification.getBody().target){
//						case "mcUnBind"://copper
//							Mosaic.TipsInfo.copper.text = notification.getBody().money;
//							break;
//						case "mcBind"://copperBind
//							Mosaic.TipsInfo.copperBind.text = notification.getBody().money;
//							break;
//						case "mcRmb"://gold
//							Mosaic.TipsInfo.gold.text = notification.getBody().money;
//							break;
//						case "mcBindRmb"://goldBind
//							Mosaic.TipsInfo.goldBind.text = notification.getBody().money;
//							break;
//						
//					}
//					break;
				case StoneEvents.UPDATE_STONE_MOSAIC_UI:
					if(StoneDatas.stoneCurPage == 0)
					{
						stoneGrid.gc();
						initEquipData();
						showEquipData(this.subIndexPage);
						initStoneData();
						showStoneData(this.subIndexPage);
						stoneGrid.init();
					}
					
					break;
				
				case StoneEvents.UPDATE_EQUIP_STONE_UI:
					
					if(StoneDatas.stoneCurPage == 0)
					{
						if(selectPosition > -1)
						{
							this.showEquip(selectPosition);
						}
					}
					break;
			}

		}
		
		private function initData():void
		{
			//获取装备数据
			this.Mosaic.txtBtnName_1.mouseEnabled = false;			
			this.Mosaic.txtBtnName_1.text = "打孔";
//			this.Mosaic.("txtBtnName_"+"1").text
			var btn:SimpleButton = this.getSimpBtn(0);
			var txt:TextField = this.getTextField(0);
//			trace(btn);
			
			var gridUnit:MovieClip = StoneDatas.stoneLoadswfTool.GetResource().GetClassByMovieClip("BigGrid");
			gridUnit.x = Mosaic.equip.x +　(Mosaic.equip.width - gridUnit.width)/2;
			gridUnit.y = Mosaic.equip.y + (Mosaic.equip.height - gridUnit.height)/2;
			Mosaic.addChild(gridUnit);
			equip = new GridUnit(gridUnit, true);//选中装备
			equip.parent = Mosaic;									//设置父级
			equip.Item	= null;										//格子的物品
			
//			StoneDatas.stoneSelectIdArray = new Dictionary();
//			var gridUnit:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
//			gridUnit.x = Mosaic.equip.x +　(Mosaic.equip.width - gridUnit.width)/2;
//			gridUnit.y = Mosaic.equip.y + (Mosaic.equip.height - gridUnit.height)/2;
//			Mosaic.addChild(gridUnit);
//			equip = new GridUnit(gridUnit, true);//选中装备
//			equip.parent = Mosaic;									//设置父级
//			equip.Item	= null;		
			Mosaic.TipsInfo.copper.text = GameCommonData.Player.Role.UnBindMoney;
			Mosaic.TipsInfo.copperBind.text = GameCommonData.Player.Role.BindMoney;
			Mosaic.TipsInfo.gold.text = GameCommonData.Player.Role.UnBindRMB;
			Mosaic.TipsInfo.goldBind.text = GameCommonData.Player.Role.BindRMB;
			
			//初始化右上装备栏
//			fastBuyStone();
		}
		
		/**  初始化格子 */
		private function initGrid():void
		{
			
			var gridUnit:MovieClip;
			var gridUint:GridUnit;
			StoneDatas.stoneMaterialGridList = new Array();
			for( var i:int = 0; i<14; i++ ) 
			{
				gridUnit = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
				gridUnit.x = (gridUnit.width+7) * (i%7) + STARTPOS.x;
				gridUnit.y = (gridUnit.height+5) * int(i/7) + STARTPOS.y;
//				gridUnit.name = "bag_" + i.toString();
				Mosaic.Stones.addChild(gridUnit);
				gridUint = new GridUnit(gridUnit, true);
				gridUint.parent = Mosaic.Stones;										//设置父级
				gridUint.Index = i;											//格子的位置		
				gridUint.HasBag = true;										//是否是可用的背包
				gridUint.IsUsed	= false;									//是否已经使用
				gridUint.Item	= null;										//格子的物品
				StoneDatas.stoneMaterialGridList.push(gridUint);
			}
			
			for(i=0;i<8; i++)
			{
				gridUnit = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
				gridUnit.x = Mosaic.Equips["item_"+(i)].item.x;
				gridUnit.y = Mosaic.Equips["item_"+(i)].item.y;

				Mosaic.Equips["item_"+(i)].addChild(gridUnit);
				
				gridUint = new GridUnit(gridUnit, true);
				gridUint.parent = Mosaic.Equips["item_"+(i)];									//设置父级
				
				equipGridList[i] = gridUint;
			}
		}
		
		/** 显示当前页装备 */
		private function showEquipData(index:int):void
		{
			clearEquipBagData();
			
			/**
			 * 页面刷新时，先还原选中状态 
			 */
			if(selectPosition>-1)
			{
				Mosaic.Equips["item_"+selectPosition].filters=lastFilter;
				Mosaic.Equips["item_"+selectPosition].mouseEnabled = true;
				Mosaic.Equips["item_"+selectPosition].mouseChildren = true;
			}
			
			var a:Object = StoneDatas.stoneEquipList;
			var beginInt:int = index*8;
			var count:int= (index+1)*8>StoneDatas.stoneEquipList.length?StoneDatas.stoneEquipList.length:(index+1)*8;
			for(var i:int =beginInt ; i<count; i++)
			{
				var item:Object;
				if(i<StoneDatas.stoneCountEquiped)
				{
					item = RolePropDatas.getItemByType(StoneDatas.stoneEquipList[i].type);
				}
				else
				{
					item = BagData.getItemById(StoneDatas.stoneEquipList[i].id);
				}
				if(item)
				{
					var useItem:UseItem = new UseItem(item.index, item.type, Mosaic.Equips);
					useItem.x =Mosaic.Equips["item_"+(i-beginInt)].item.x+2;
					useItem.y = Mosaic.Equips["item_"+(i-beginInt)].item.y+2;
					useItem.Id = item.id;
					useItem.IsBind = item.isBind;
					useItem.Type = item.type;
					useItem.setImageScale(34,34);
					Mosaic.Equips["item_"+(i-beginInt)].addChild(useItem);
					
					if(i<StoneDatas.stoneCountEquiped)
					{
						Mosaic.Equips["item_"+(i-beginInt)].equiped.visible = true;
						equipGridList[i-beginInt].Grid.name = "hero_"+item.position.toString();
					}
					else
					{
						Mosaic.Equips["item_"+(i-beginInt)].equiped.visible = false;
						equipGridList[i-beginInt].Grid.name = "bag_"+item.index.toString();
					}
					equipGridList[i-beginInt].Item = useItem;
					
					if(equip && equip.Item && equip.Item.Type == item.type)
					{
						lastFilter = Mosaic.Equips["item_"+(i-beginInt)].filters;
						Mosaic.Equips["item_"+(i-beginInt)].filters=[new ColorMatrixFilter([_nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, 0, 0, 0, 1, 0])];
						Mosaic.Equips["item_"+(i-beginInt)].mouseEnabled = false;
						Mosaic.Equips["item_"+(i-beginInt)].mouseChildren = false;
					}
				}
				
				
				item = IntroConst.ItemInfo[StoneDatas.stoneEquipList[i].id];
				var index:int = 0;
				if(item)
				{
					index = int(StoneDatas.stoneEquipList[i].color);
					Mosaic.Equips["item_"+(i-beginInt)].txtName.htmlText = "<font COLOR='"+StoneDatas.stoneEquipColorList[index]+"'>"+item.itemName+"</font>";
					
				}else
				{
					item = UIConstData.ItemDic_1[StoneDatas.stoneEquipList[i].type];
					index = int(StoneDatas.stoneEquipList[i].color);
					Mosaic.Equips["item_"+(i-beginInt)].txtName.htmlText = "<font COLOR='"+StoneDatas.stoneEquipColorList[index]+"'>"+item.Name+"</font>";
					Mosaic.Equips["item_"+(i-beginInt)].stoneHole.text = "";
				}
				
				Mosaic.Equips["item_"+(i-beginInt)].addEventListener(MouseEvent.CLICK,onSelectEquipEvent);
			}
			for(var j:int = i-beginInt;j<8;j++)
			{
				Mosaic.Equips["item_"+j].txtName.text= "";
				Mosaic.Equips["item_"+j].stoneHole.text = "";
				Mosaic.Equips["item_"+j].equiped.visible = false;
				Mosaic.Equips["item_"+j].removeEventListener(MouseEvent.CLICK,onSelectEquipEvent);
			}

			Mosaic.Equips.txtPage.text = (subIndexPage+1) + "/" + maxIndexPage;
		}
		
		/**
		 * 清空右侧栏装备
		 */
		private function clearEquipBagData():void
		{
			for(var i:int=0; i<equipGridList.length; i++)
			{
				if(equipGridList[i].Item)
				{
					equipGridList[i].Item.reset();
					equipGridList[i].Item.gc();
					if(Mosaic.Equips["item_"+i].contains(equipGridList[i].Item as UseItem))
					{
						Mosaic.Equips["item_"+i].removeChild(equipGridList[i].Item);
					}
					equipGridList[i].Item = null;
					equipGridList[i].Grid.name = "instance_"+i;
				}
			}
		}
		
		/** 选中装备事件 */
		private function onSelectEquipEvent(e:MouseEvent):void
		{
			var index:int = int( (e.currentTarget.name as String).split("_")[1] );
			StoneDatas.stoneSelectItem = StoneDatas.stoneEquipList[subIndexPage*8+index];
			
			this.onSelectEquip(index);
			this.showEquip(subIndexPage*8+index);
		}
		
		/** 分页事件 */
		private function onBtnClick(e:MouseEvent):void
		{
			var name:String = e.currentTarget.name;
			switch(name)
			{
				case "btnLeft":
					if(subIndexPage>0)
					{
						subIndexPage--;
						showEquipData(subIndexPage);
					}
					
					break;
				case "btnRight":
					if(subIndexPage<maxIndexPage-1)
					{
						subIndexPage++;
						showEquipData(subIndexPage);
					}
					break;
				case "btnTop":
					showEquipData(0);
					break;
				case "btnDown":
					showEquipData(maxIndexPage-1);
					break;
			}
		}
		
		/** 分页事件 */
		private function onBtnStoneBagClick(e:MouseEvent):void
		{
			var name:String = e.currentTarget.name;
			switch(name)
			{
				case "btnLeft":
					if(stoneIndexPage>0)
					{
						stoneIndexPage--;
						showStoneData(stoneIndexPage);
					}
					
					break;
				case "btnRight":
					if(stoneIndexPage<maxStoneIndexPage-1)
					{
						stoneIndexPage++;
						showStoneData(stoneIndexPage);
					}
					break;
				case "btnTop":
					showStoneData(0);
					break;
				case "btnDown":
					showStoneData(maxStoneIndexPage-1);
					break;
			}
		}
		
		/**
		 * 右侧宝石初始化
		 */
		private function initStoneData():void
		{
			var type:int = 0;
			var equipId:int = 0;
			var item:Object;
			var i:int=0;
			StoneDatas.stoneMaterialList = new Array();
			
			for(i=0;i<BagData.AllUserItems[0].length;i++)
			{
				item = BagData.AllUserItems[0][i];
				if(BagData.AllUserItems[0][i] != null && BagData.AllUserItems[0][i] != undefined)
				{
					type = BagData.AllUserItems[0][i].type;
					equipId = type/100000;
					if(equipId==4)
					{
						StoneDatas.stoneMaterialList.push(BagData.AllUserItems[0][i]);
						if(!IntroConst.ItemInfo[BagData.AllUserItems[0][i].id])
						{
							UiNetAction.GetItemInfo(BagData.AllUserItems[0][i].id,GameCommonData.Player.Role.Id,GameCommonData.Player.Role.Name);
						}
					}
				}
			}
			
			maxStoneIndexPage = (StoneDatas.stoneMaterialList.length-1)/8+1;
		}
		
		
		/**
		 * 分页显示右侧宝石
		 * 
		 * index是右边宝石蓝格子下标
		 */
		private function showStoneData(index:int):void
		{
			this.clearStoneBag();
			var a:Object = StoneDatas.stoneMaterialGridList;
			var beginInt:int = index*14;
			var count:int= (index+1)*14>StoneDatas.stoneMaterialList.length?StoneDatas.stoneMaterialList.length:(index+1)*14;
			for(var i:int =beginInt ; i<count; i++)
			{
				var item:Object = StoneDatas.stoneMaterialList[i];
				var useItem:UseItem = useItem=new UseItem(item.index,item.type,Mosaic.Stones);
				
				useItem.x = StoneDatas.stoneMaterialGridList[(i-beginInt)].Grid.x + 2;
				useItem.y = StoneDatas.stoneMaterialGridList[(i-beginInt)].Grid.y + 2;
				useItem.Id = item.id;
				useItem.setImageScale(34,34);
				useItem.IsBind = item.isBind;
				useItem.Num = item.amount;
				useItem.Type = item.type;
				useItem.setImageScale(34,34);
				
				//bag+背包索引+右边栏索引
				StoneDatas.stoneMaterialGridList[(i-beginInt)].Grid.name = "bag_"+item.index.toString()+"_"+(i-beginInt).toString();
				StoneDatas.stoneMaterialGridList[(i-beginInt)].Item = useItem;
				StoneDatas.stoneMaterialGridList[(i-beginInt)].Index = item.index;
				StoneDatas.stoneMaterialGridList[(i-beginInt)].IsUsed = true;
				
				Mosaic.Stones.addChild(useItem);
			}
			
//			for(i=0; i<this.stoneList.length;i++)
//			{
//				if(this.item.stoneList[i]==88888 && stoneList[i] && stoneList[i].Item == null)//有孔并且没宝石，则装上宝石
//				{
//					//有孔没镶嵌宝石的位置，如果用户已经放入宝石，则扣除
//					if(stoneList[i].Item && stoneList[i].Index>-1)
//					{
//						var obj:Object = BagData.AllUserItems[0][stoneList[i].Index];
//						if(obj)
//						{
//							var num:int = this.getEquipStoneNumByIndex(obj.index);
//							if(num>=obj.amount)return;
//							
//							var index:int = stoneList[i].Grid.name.split("_")[2];
//							if(StoneDatas.stoneMaterialGridList[index].Item.Index == obj.index)
//							{
//								StoneDatas.stoneMaterialGridList[index].Item.Num = obj.amount-num;
//							}
//							
//						}
//						
//					}
//				}
//			}
			
			Mosaic.Stones.txtPage.text = (stoneIndexPage+1) + "/" + maxStoneIndexPage;
		}
		
		private function resetStoneNum():void
		{
			if(StoneDatas.stoneMaterialList)
			{
				var index:int = this.subIndexPage;
				var beginInt:int = index*14;
				var count:int= (index+1)*14>StoneDatas.stoneMaterialList.length?StoneDatas.stoneMaterialList.length:(index+1)*14;
				for(var i:int =beginInt ; i<count; i++)
				{
					if(StoneDatas.stoneMaterialGridList[(i-beginInt)]&& StoneDatas.stoneMaterialGridList[(i-beginInt)].Item)
					{
						StoneDatas.stoneMaterialGridList[(i-beginInt)].Item.Num = StoneDatas.stoneMaterialList[i].amount;
					}
					
				}
			}
			
		}
		
		/**
		 * 清理右侧宝石
		 */
		private function clearStoneBag():void
		{
			for(var i:int=0; i<StoneDatas.stoneMaterialGridList.length; i++)
			{
				if(StoneDatas.stoneMaterialGridList[i].Item)
				{
					
					StoneDatas.stoneMaterialGridList[i].Item.reset();
					StoneDatas.stoneMaterialGridList[i].Item.gc();
					if(Mosaic.Stones.contains(StoneDatas.stoneMaterialGridList[i].Item as UseItem))
					{
						Mosaic.Stones.removeChild(StoneDatas.stoneMaterialGridList[i].Item as UseItem);
					}
//					if(Mosaic.Stones.contains(StoneDatas.stoneMaterialGridList[i].Grid as MovieClip))
//					{
//						Mosaic.Stones.removeChild(StoneDatas.stoneMaterialGridList[i].Grid as MovieClip);
//					}
					StoneDatas.stoneMaterialGridList[i].Item = null;

				}
			}
		}
		
		private function clearStoneGrid():void
		{
			for(var i:int=0; i<StoneDatas.stoneMaterialGridList.length; i++)
			{
				if(Mosaic.Stones.contains(StoneDatas.stoneMaterialGridList[i].Grid as MovieClip))
				{
					Mosaic.Stones.removeChild(StoneDatas.stoneMaterialGridList[i].Grid as MovieClip);
				}
			}
		}
		
		/**
		 * 初始化右侧装备数据
		 */
		private function initEquipData():void
		{
			StoneDatas.stoneCountEquiped = 0;
			var type:int = 0;
			var equipId:int = 0;
			var item:Object;
			var i:int=0;
			StoneDatas.stoneEquipList = new Array();
			
			for(i=0;i<RolePropDatas.ItemList.length;i++)
			{
				item = RolePropDatas.ItemList[i];
				if(RolePropDatas.ItemList[i] != null && RolePropDatas.ItemList[i] != undefined && item.color>1)
				{
					type = RolePropDatas.ItemList[i].type;
					equipId = type/10000;
					if( (equipId>10 && equipId<16) || (equipId>16 && equipId<20) || (equipId>20 && equipId<24)/* && equipId!=16*/)
					{
						StoneDatas.stoneEquipList.push(RolePropDatas.ItemList[i]);
						if(!IntroConst.ItemInfo[RolePropDatas.ItemList[i].id])
						{
							UiNetAction.GetItemInfo(RolePropDatas.ItemList[i].id,GameCommonData.Player.Role.Id,GameCommonData.Player.Role.Name);
						}
						StoneDatas.stoneCountEquiped++;
					}
					
				}
			}
			for(i=0;i<BagData.AllUserItems[0].length;i++)
			{
				item = BagData.AllUserItems[0][i];
				if(BagData.AllUserItems[0][i] != null && BagData.AllUserItems[0][i] != undefined && item.color>1)
				{
					type = BagData.AllUserItems[0][i].type;
					equipId = type/10000;
					if((equipId>10 && equipId<16) || (equipId>16 && equipId<20) || (equipId>20 && equipId<24)/* && equipId!=16*/)
					{
						StoneDatas.stoneEquipList.push(BagData.AllUserItems[0][i]);
						if(!IntroConst.ItemInfo[BagData.AllUserItems[0][i].id])
						{
							UiNetAction.GetItemInfo(BagData.AllUserItems[0][i].id,GameCommonData.Player.Role.Id,GameCommonData.Player.Role.Name);
						}
					}
				}
			}
			
			maxIndexPage = (StoneDatas.stoneEquipList.length-1)/8+1;
		}
		
//		private function fastBuyStone():void
//		{
//			var buyList:Array = new Array();
//			var good:Object = null;
//			for(var i:int=0;i<BagData.AllUserItems[0].length;i++)
//			{
//				if(BagData.AllUserItems[0][i] != null && BagData.AllUserItems[0][i] != undefined /** 筛选 */)
//				{
//					var type:int = BagData.AllUserItems[0][i].type/100000;
//					if(type == 4)//第一位为4表示镶嵌宝石
//					{
//						good = new Object();
//						good.type = BagData.AllUserItems[0][i].type;
//						good.name = BagData.AllUserItems[0][i].name;
//						good.num = BagData.hasItemNum(good.type);
//						buyList.push(good);
//					}
//				}
//			}
//			
//			facade.sendNotification(ForgeEvent.UPDATE_ITEM_FASTBUY,{data:buyList});
//		}
		
		private function initEvent():void{
			var btn:SimpleButton;
			for(var i:int=0;i<4;i++){
				btn = this.getSimpBtn(i);
				btn.addEventListener(MouseEvent.CLICK,onMouseHandler);
			}
		}
		private function removeEvent():void{
			var btn:SimpleButton;
			for(var i:int=0;i<4;i++){
				btn = this.getSimpBtn(i);
				btn.removeEventListener(MouseEvent.CLICK,onMouseHandler);
			}
		}
		
		/**
		 * 鼠标点击（镶嵌，拆除）按钮事件
		 */
		private function onMouseHandler(e:MouseEvent):void{
			if(item == null)return;
			var str:String = e.currentTarget.name;
			var strName:int = int(str.substr(4,1));

			var arr:Array = item.stoneList;
			var id:int = int(arr[strName]);
			var param:Array = null;
			switch(id)
			{
				case 0://没有孔
					break;
				case 99999://有孔没开
					//打孔
					param=[1,0,23,item.id,1];
					EquipSend.createMsgCompound(param);
					break;
				case 88888://有孔打开无宝石
					//镶嵌
					if(stoneList[strName]==null || stoneList[strName].Item==null)return;
					var stone:Object = BagData.AllUserItems[0][stoneList[strName].Index];
					param=[1,strName+1,6,item.id,stone.id];
					EquipSend.createMsgCompound(param);
					break;
				default://有宝石
					//取宝石
					if(stoneList[strName]==null || stoneList[strName].Item==null)return;
					param=[1,0,70,item.id,strName+1];
					EquipSend.createMsgCompound(param);
					break;
			}
		}
		
		/**
		 * index 表示在右边装备栏的位置
		 */
		private function showEquip(index:int=0):void
		{
			//显示选中装备
			
			if(StoneDatas.stoneSelectItem == null)return;
			var item:Object;
			if(index<StoneDatas.stoneCountEquiped)
			{
				item = RolePropDatas.getItemByType(StoneDatas.stoneSelectItem.type);
			}
			else
			{
				item = BagData.getItemById(StoneDatas.stoneSelectItem.id);
			}
			if(item)
			{
				var useItem:UseItem = this.getCells(item.index, item.type, Mosaic);
				useItem.x = Mosaic.equip.x+2;
				useItem.y = Mosaic.equip.y+2;
				useItem.Id = item.id;
//				useItem.IsBind = item.isBind;
				useItem.Type = item.type;
				useItem.setImageScale(62,62);
				clearEquip();
				selectPosition = index-subIndexPage*8;
				equip.Item = useItem;

				if(index<StoneDatas.stoneCountEquiped)
				{
					equip.Grid.name = "hero_" + item.position.toString()+"_"+index.toString();
				}
				else
				{
					equip.Grid.name = "bag_" + item.index.toString() +"_"+ index.toString();
				}
				equip.Grid.addEventListener(MouseEvent.CLICK,onUnEquip);
				Mosaic.addChild(useItem);
				
				showEquipInfo(item.id);
			}
		}
		
		/**  
		 * 改变装备选中状态，保存选中装备，选中装备为灰色
		 * */
		private function onSelectEquip(index:int):void
		{
			if(lastIndex!=-1)
			{
				Mosaic.Equips["item_"+lastIndex].filters=lastFilter;
				
				Mosaic.Equips["item_"+lastIndex].mouseEnabled = true;
				Mosaic.Equips["item_"+lastIndex].mouseChildren = true;
			}
			lastFilter = Mosaic.Equips["item_"+index].filters;
			Mosaic.Equips["item_"+index].filters=[new ColorMatrixFilter([_nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, 0, 0, 0, 1, 0])];
			Mosaic.Equips["item_"+index].mouseEnabled = false;
			Mosaic.Equips["item_"+index].mouseChildren = false;
			lastIndex = index;
		}
		
		/** 卸载装备 */
		private function onUnEquip(e:MouseEvent):void
		{
			
			this.clearEquip();
			this.clearStoneList();
			StoneDatas.stoneSelectItem = null;
			
			var index:int = e.currentTarget.name.split("_")[2];
			if(lastIndex!=-1)
			{
				
				StoneDatas.stoneEquipGridList[lastIndex].Grid.filters=lastFilter;
				
				StoneDatas.stoneEquipGridList[lastIndex].Grid.mouseEnabled = true;
				StoneDatas.stoneEquipGridList[lastIndex].Grid.mouseChildren = true;
				var item:Object = StoneDatas.stoneEquipGridList[index];
//				delete StoneDatas.stoneSelectIdArray[item.Item.Id];
				
				equip.Grid.addEventListener(MouseEvent.CLICK,onUnEquip);
				lastIndex = -1;
			}
		}
		
		/** 显示选中宝石 */
		private function showStone(index:int = -1):void
		{
			if(StoneDatas.stoneSelectMaterial == null)return;
			if(equip.Item == null || item == null)return;
			var material:Object = StoneDatas.stoneSelectMaterial;
			if(material == null)return;

			//当格物品已经全部放入孔中，不能继续放入。
			var count:int = this.getEquipStoneNumByIndex(int(material.index));
			if(count>=material.amount)return;
			
			for(var i:int=0; i<this.stoneList.length;i++)
			{
				if(item.stoneList[i]==88888 && stoneList[i].Item == null)//有孔并且没宝石，则装上宝石
				{
					var useItem:UseItem = this.getCells(material.index, material.type, Mosaic);
					useItem.x = stoneList[i].Grid.x +　2;
					useItem.y = stoneList[i].Grid.y + 2;
					useItem.Id = material.id;
					useItem.IsBind = material.isBind;
					useItem.Type = material.type;
					useItem.setImageScale(34,34);
					if(stoneList[i].Item != null)
					{
						stoneList[i].Item.reset();
						stoneList[i].Item.gc();
						if(Mosaic.contains(stoneList[i].Item as UseItem))
						{
							Mosaic.removeChild(stoneList[i].Item as UseItem);
						}
						stoneList[i].Item = null;
					}
						
					stoneList[i].Item = useItem;
					stoneList[i].Index = material.index;
					//bag+背包索引+孔位置索引+右侧边栏位置索引
					stoneList[i].Grid.name = "bag_" + material.index.toString()+"_"+i.toString()+"_"+index.toString();
					stoneList[i].Grid.addEventListener(MouseEvent.CLICK,onUnEquipStone);
					this.Mosaic["btn_"+i.toString()].visible = true;
					this.Mosaic["txtBtnName_"+i.toString()].visible = true;
					this.Mosaic["txtBtnName_"+i.toString()].text = "镶嵌";
					Mosaic.addChild(useItem);
					
					if(index>-1&&StoneDatas.stoneMaterialGridList[index].Item.Num>0)
					{
						StoneDatas.stoneMaterialGridList[index].Item.Num = material.amount - count -1;
					}
					return;
				}
			}
			
		}
		
		/**
		 * 根据背包索引查询装备上宝石的数量
		 * index 背包索引
		 */
		private function getEquipStoneNumByIndex(index:int):int
		{
			var count:int=0;
			for(var i:int=0;i<this.stoneList.length;i++)
			{
				if(stoneList[i].Item && stoneList[i].Index == index)
				{
					count++;
				}
			}
			return count;
		}
		
		/** 卸未镶嵌宝石 */
		private function onUnEquipStone(e:MouseEvent):void
		{
			var name:Array = e.currentTarget.name.split("_");
 
			if(stoneList[int(name[2])].Item == null)return;
			stoneList[int(name[2])].Item.reset();
			stoneList[int(name[2])].Item.gc();
			if(Mosaic.contains(stoneList[int(name[2])].Item as UseItem))
			{
				Mosaic.removeChild(stoneList[int(name[2])].Item as UseItem);
			}
//			stoneList[int(name[2])].Grid.addEventListener(MouseEvent.CLICK,onUnEquip);
			stoneList[int(name[2])].Grid.removeEventListener(MouseEvent.CLICK,onUnEquipStone);
			stoneList[int(name[2])].Item = null;
			
			var index:int = name[3];
			if(index>-1&&StoneDatas.stoneMaterialGridList[index].Item.Num>0)
			{
				StoneDatas.stoneMaterialGridList[index].Item.Num += 1;
			}
		}
		
		/** 清除选中装备 */
		private function clearEquip():void
		{
			//显示选中装备
			selectPosition = -1;
			if(equip.Item == null)return;
			equip.Item.reset();
			equip.Item.gc();
			if(Mosaic.contains(equip.Item as UseItem))
			{
				Mosaic.removeChild(equip.Item as UseItem);
			}
			equip.Item = null;
		}
		
		private function showEquipInfo(id:int):void
		{
			this.clearStoneList();
			this.resetStoneNum();
			clearInterval(delayNum);
			this.item = IntroConst.ItemInfo[id];
			if(this.item == null)
			{
				this.item = RolePropDatas.getRoleItemById(id);
			}
			if(item)
			{
				ItemArr = item.stoneList;
				initHole(ItemArr);
				if(item.color<5)
				{
					this.Mosaic["btn_3"].visible = false;
					this.Mosaic["txtBtnName_3"].visible = false;
				}else
				{
					
				}
			}
			else
			{
				
				this.delayNum = setInterval(showEquipInfo,100,id);
			}
		}
		
		/** 清理孔信息 */
		private function clearStoneList():void
		{
			if(stoneList)
			{
				for(var i:int=0; i<this.stoneList.length; i++)
				{
					if(this.stoneList[i] != null)
					{
						if(stoneList[i].Item != null)
						{
							stoneList[i].Item.reset();
							stoneList[i].Item.gc();
							if(Mosaic.contains(stoneList[i].Item as UseItem))
							{
								Mosaic.removeChild(stoneList[i].Item as UseItem);
							}
							stoneList[i].Item = null;
							stoneList[i].Index = -1;
						}
						
						if(Mosaic.contains(stoneList[i].Grid as MovieClip))
						{
							Mosaic.removeChild(stoneList[i].Grid as MovieClip);
						}
						stoneList[i].Grid = null;
						
						this.stoneList[i] = null;
					}	
				}
				for(var j:int=0;j<4;j++)
				{
					(this.Mosaic["btn_"+j.toString()] as SimpleButton).visible = false;
					(this.Mosaic["txtBtnName_"+j.toString()]).visible = false;
					//				(this.Mosaic["txtHole_"+j.toString()]).visible = false;
					//				(this.Mosaic["txtNum_"+j.toString()]).visible = false;
				}
			}
			
		}
		
		/**
		 * 初始化孔数 
		 * 
		 */		
		private function initHole(arr:Array):void
		{
			var btnLock:Boolean = false;
			for(var i:int=0;i<arr.length;i++)
			{
				var id:int = int(arr[i]);
				var gridUnit:MovieClip = null;
				var material:GridUnit = null;
				switch(id)
				{
					case 0://没有孔
						gridUnit = StoneDatas.stoneLoadswfTool.GetResource().GetClassByMovieClip("GridUnitLock");
						gridUnit.x = Mosaic["stone_"+i.toString()].x;
						gridUnit.y = Mosaic["stone_"+i.toString()].y;
						Mosaic.addChild(gridUnit);
						material = new GridUnit(gridUnit, true);//选中装备
						material.parent = Mosaic;									//设置父级
						material.Item	= null;										//格子的物品
						this.stoneList[i] = material;
						
						break;
					case 99999://有孔没开
						gridUnit = StoneDatas.stoneLoadswfTool.GetResource().GetClassByMovieClip("GridUnitLock");
						gridUnit.x = Mosaic["stone_"+i.toString()].x;
						gridUnit.y = Mosaic["stone_"+i.toString()].y;
						Mosaic.addChild(gridUnit);
						material = new GridUnit(gridUnit, true);//选中装备
						material.parent = Mosaic;									//设置父级
						material.Item	= null;										//格子的物品
						this.stoneList[i] = material;
						if(!btnLock)
						{
							this.Mosaic["btn_"+i.toString()].visible = true;
							this.Mosaic["txtBtnName_"+i.toString()].visible = true;
							this.Mosaic["txtBtnName_"+i.toString()].text = "打孔";
							btnLock = true;
						}

						break;
					case 88888://有孔打开无宝石
						gridUnit = StoneDatas.stoneLoadswfTool.GetResource().GetClassByMovieClip("GridUnit");
						gridUnit.x = Mosaic["stone_"+i.toString()].x;
						gridUnit.y = Mosaic["stone_"+i.toString()].y;
						Mosaic.addChild(gridUnit);
						material = new GridUnit(gridUnit, true);//选中装备
						material.parent = Mosaic;									//设置父级
						material.Item	= null;										//格子的物品
						this.stoneList[i] = material;
//						if(!btnLock)
//						{
//							this.Mosaic["btn_"+i.toString()].visible = true;
//							this.Mosaic["txtBtnName_"+i.toString()].visible = true;
//							this.Mosaic["txtBtnName_"+i.toString()].text = "镶嵌";
//							btnLock = true;//锁定按钮
//						}
						
						break;
					default://有宝石
						gridUnit = StoneDatas.stoneLoadswfTool.GetResource().GetClassByMovieClip("GridUnit");
						gridUnit.x = Mosaic["stone_"+i.toString()].x;
						gridUnit.y = Mosaic["stone_"+i.toString()].y;
						Mosaic.addChild(gridUnit);
						material = new GridUnit(gridUnit, true);//选中装备
						material.parent = Mosaic;									//设置父级
						material.Item	= null;										//格子的物品
						
						var stoneItem:Object = UIConstData.ItemDic_1[id];
//						var stoneItem:Object = BagData.getItemById(id);
						if(stoneItem == null)return;

						var useItem:UseItem = this.getCells(stoneItem.index, stoneItem.type, Mosaic);
						useItem.x = Mosaic["stone_"+i.toString()].x+2;
						useItem.y = Mosaic["stone_"+i.toString()].y+2;
						useItem.Id = stoneItem.id;
						useItem.IsBind = stoneItem.isBind;
						useItem.Type = stoneItem.type;
						useItem.setImageScale(34,34);
						material.Item = useItem;
						material.Grid.name = "Decompose_"+stoneItem.type.toString();
						material.Index = stoneItem.index;
						Mosaic.addChild(useItem);
						
						this.stoneList[i] = material;
						if(!btnLock)
						{
							this.Mosaic["btn_"+i.toString()].visible = true;
							this.Mosaic["txtBtnName_"+i.toString()].visible = true;
							this.Mosaic["txtBtnName_"+i.toString()].text = "拆除";
						}
						
						break;
				}
				setHole(i,arr[i]);
			}
		}
		/**
		 * 
		 * @param id  第几个孔
		 * @param isHasGemstone  是否有宝石
		 * 
		 */		
		private function setHole(id:int,isHasHole:Boolean,isHasGemstone:Boolean = false):void{
			var txt:TextField;
			if(isHasHole){  //打了孔的
				if(isHasGemstone){  //插了宝石
					
 				}else{   //未插宝石
					
				}
				
			}else{     //未打孔的处理
				txt = getTextField(id);
				txt.mouseEnabled = false;
				txt.text = "打孔";
			}
		}
		
		private function getSimpBtn(id:int):SimpleButton{
			var strName:String = "btn_"+ String(id);
			var simpBtn:SimpleButton = this.Mosaic.getChildByName(strName) as SimpleButton;
			return simpBtn;
		}
		private function getTextField(id:int):TextField{
			var strName:String = "txtBtnName_"+ String(id);
			var txt:TextField = this.Mosaic.getChildByName(strName) as TextField;
			return txt;
		}

		
		private function registerView():void
		{
			initEvent();
			this.clearStoneList();
			//初始化素材事件		
			for(var j:int=0;j<4;j++)
			{
				(this.Mosaic["btn_"+j.toString()] as SimpleButton).visible = false;
				(this.Mosaic["txtBtnName_"+j.toString()] as TextField).mouseEnabled = false;
				(this.Mosaic["txtBtnName_"+j.toString()]).visible = false;
				this.Mosaic["txtStoneName_"+j.toString()].text = "";
//				(this.Mosaic["txtHole_"+j.toString()]).visible = false;
//				(this.Mosaic["txtNum_"+j.toString()]).visible = false;
			}
			
			Mosaic.Equips.prop_0.gotoAndStop(3);

			for(var i:int=0;i<2;i++)
			{
				(Mosaic.Stones["prop_"+i] as MovieClip).gotoAndStop(1);
				(Mosaic.Stones["prop_"+i] as MovieClip).addEventListener(MouseEvent.CLICK,onBtnSelectStoneOrHole);
				(Mosaic.Stones["prop_"+i] as MovieClip).mouseEnabled = true;
				(Mosaic.Stones["prop_"+i] as MovieClip).buttonMode = true;
			}
			(Mosaic.Stones.prop_0 as MovieClip).gotoAndStop(3);
			(Mosaic.Stones.prop_0 as MovieClip).mouseEnabled = false;
			
			Mosaic.Equips.btnLeft.addEventListener(MouseEvent.CLICK,onBtnClick);
			Mosaic.Equips.btnRight.addEventListener(MouseEvent.CLICK,onBtnClick);
			Mosaic.Equips.btnTop.addEventListener(MouseEvent.CLICK,onBtnClick);
			Mosaic.Equips.btnDown.addEventListener(MouseEvent.CLICK,onBtnClick);
			
			Mosaic.Stones.btnLeft.addEventListener(MouseEvent.CLICK,onBtnStoneBagClick);
			Mosaic.Stones.btnRight.addEventListener(MouseEvent.CLICK,onBtnStoneBagClick);
			Mosaic.Stones.btnTop.addEventListener(MouseEvent.CLICK,onBtnStoneBagClick);
			Mosaic.Stones.btnDown.addEventListener(MouseEvent.CLICK,onBtnStoneBagClick);
		}
		
		private function retrievedView():void
		{
			//释放素材事件
			
			removeEvent();
			clearEquip();
			clearStoneList();
			clearStoneGrid();
			
			Mosaic.Equips.btnLeft.removeEventListener(MouseEvent.CLICK,onBtnClick);
			Mosaic.Equips.btnRight.removeEventListener(MouseEvent.CLICK,onBtnClick);
			Mosaic.Equips.btnTop.removeEventListener(MouseEvent.CLICK,onBtnClick);
			Mosaic.Equips.btnDown.removeEventListener(MouseEvent.CLICK,onBtnClick);
			
			Mosaic.Stones.btnLeft.removeEventListener(MouseEvent.CLICK,onBtnStoneBagClick);
			Mosaic.Stones.btnRight.removeEventListener(MouseEvent.CLICK,onBtnStoneBagClick);
			Mosaic.Stones.btnTop.removeEventListener(MouseEvent.CLICK,onBtnStoneBagClick);
			Mosaic.Stones.btnDown.removeEventListener(MouseEvent.CLICK,onBtnStoneBagClick);
			
			lastIndex = -1;
		}
		
		/**  
		 * 
		 * */
		private function onBtnSelectStoneOrHole(e:MouseEvent):void
		{
			
		}
		
		/** 创建UseItem实例 */
		protected function getCells(pos:int, icon:String, parent:DisplayObjectContainer):UseItem{
			
			var useItem:UseItem=this.cacheCells.shift();
			useItem=new UseItem(pos,icon,parent);
			return useItem;
		}
	}
}