package GameUI.Modules.Stone.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Bag.Proxy.BagData;
	import GameUI.Modules.Bag.Proxy.GridUnit;
	import GameUI.Modules.Equipment.command.ComposeCommand;
	import GameUI.Modules.Stone.Datas.*;
	import GameUI.Proxy.DataProxy;
	import GameUI.UIConfigData;
	import GameUI.UIUtils;
	import GameUI.View.BaseUI.PanelBase;
	import GameUI.View.items.FaceItem;
	import GameUI.View.items.UseItem;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class StoneComposeMediator extends Mediator
	{
		
		public static const NAME:String="StoneComposeMediator";
		private var parentView:MovieClip;
		private var curColor:int = 0; //当前筛选颜色，0全部，1绿色，2蓝色，3紫色，4橙色
		private var curPageType:int = 0;  //当前小分类
		private var subIndexPage:int = 0;  //当前小分页
		private var maxIndexPage:int = 1;
		
		private var aStoneId:Array;															//宝石Id数组	
		
		private var stoneList:Array = null;
		
		private var stoneBagList:Array = new Array();
		
		private var stoneArr:Array = new Array();
		
		public function StoneComposeMediator(parentMc:MovieClip)
		{
			parentView = parentMc;
			super(NAME);
		}
		
		public function get StoneCompose():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				StoneEvents.INIT_STONE_UI,
				StoneEvents.SHOW_STONE_COMPOSE_UI,					//打开装备
				StoneEvents.CLOSE_STONE_COMPOSE_UI,					//关闭装备
				StoneEvents.UPDATE_STONE_MOSAIC_UI,
				StoneEvents.SELECT_STONE_ONMOUSEDOWN
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case StoneEvents.INIT_STONE_UI:
					this.setViewComponent(StoneDatas.stoneLoadswfTool.GetResource().GetClassByMovieClip("Together"));
					this.StoneCompose.mouseEnabled=false;
//					stoneGrid = new StoneGridManager();
					StoneCompose.x = 0;
					StoneCompose.y = -3;
					facade.registerCommand(ComposeCommand.NAME,ComposeCommand);
					break;
				
				case StoneEvents.SHOW_STONE_COMPOSE_UI:
					registerView();
					
					initStoneData();
					showStoneData(curPageType,subIndexPage);
					parentView.addChild(StoneCompose);
					break;
				
				case StoneEvents.CLOSE_STONE_COMPOSE_UI:
					this.clearStoneBag();
					clearStone();
					stoneArr = [];
					parentView.removeChild(StoneCompose);
					break;
				
				case StoneEvents.SELECT_STONE_ONMOUSEDOWN:
					break;
				
				case StoneEvents.UPDATE_STONE_MOSAIC_UI:
					if(StoneDatas.stoneCurPage == 1)
					{
						initStoneData();
						showStoneData(curPageType,subIndexPage);
					}
					
					break;
			}
		}
		
		private function registerView():void
		{
			for( var i:int = 0; i<5; i++ )
			{
				StoneCompose["Prop_"+i].gotoAndStop(1);
				StoneCompose["Prop_"+i].addEventListener(MouseEvent.CLICK, selectView);
				StoneCompose["Prop_"+i].mouseEnabled = true;
				(StoneCompose["Prop_"+i] as MovieClip).buttonMode = true;
			}
			StoneCompose["Prop_0"].gotoAndStop(3);
			StoneCompose["Prop_0"].mouseEnabled = false;
			
			stoneList = new Array();
			var gridUnit:MovieClip;
			var gridUint:GridUnit;
			
			for (i=0;i<5;i++)
			{
				gridUnit = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
				gridUnit.x = StoneCompose["stone_"+i].x;
				gridUnit.y = StoneCompose["stone_"+i].y;

				StoneCompose.addChild(gridUnit);
				gridUint = new GridUnit(gridUnit, true);
				gridUint.parent = StoneCompose;										//设置父级
				gridUint.HasBag = true;										//是否是可用的背包
				gridUint.IsUsed	= false;									//是否已经使用
				gridUint.Item	= null;
				
				stoneList.push(gridUint);
			}
			
			for(i=0;i<16; i++)
			{
				gridUnit = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
				gridUnit.x = StoneCompose["item_"+(i)].item.x;
				gridUnit.y = StoneCompose["item_"+(i)].item.y;
//				gridUnit.name = "bag_"+item.index.toString()+"_";
				StoneCompose["item_"+(i)].addChild(gridUnit);
				
				gridUint = new GridUnit(gridUnit, true);
				gridUint.parent = StoneCompose["item_"+(i)];									//设置父级										//格子的位置		
//				gridUint.Item	= useItem;
				
				stoneBagList[i] = gridUint;
			}
			
			StoneCompose.btnLeft.addEventListener(MouseEvent.CLICK,onBtnClick);
			StoneCompose.btnRight.addEventListener(MouseEvent.CLICK,onBtnClick);
			StoneCompose.btnTop.addEventListener(MouseEvent.CLICK,onBtnClick);
			StoneCompose.btnDown.addEventListener(MouseEvent.CLICK,onBtnClick);
			
			aStoneId = [];
			
			StoneCompose.btnCompose.addEventListener(MouseEvent.CLICK, onBtnCompose);
		}
		
		private function releaseVIew():void
		{
			this.clearStone();
			for(var i:int=0;i<stoneList.length;i++)
			{
				if(StoneCompose.contains(stoneList[i].Grid))
				{
					StoneCompose.removeChild(stoneList[i].Grid);
				}
			}
			
			for( i = 0; i<5; i++ )
			{
				StoneCompose["Prop_"+i].removeEventListener(MouseEvent.CLICK, selectView);
			}
		}
		
		private function initData():void
		{
			
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
						showStoneData(curPageType,subIndexPage);
					}
					
					break;
				case "btnRight":
					if(subIndexPage<maxIndexPage-1)
					{
						subIndexPage++;
						showStoneData(curPageType,subIndexPage);
					}
					break;
				case "btnTop":
					showStoneData(curPageType,0);
					break;
				case "btnDown":
					showStoneData(curPageType,maxIndexPage-1);
					break;
			}
		}
		
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
//						if(!IntroConst.ItemInfo[BagData.AllUserItems[0][i].id])
//						{
//							UiNetAction.GetItemInfo(BagData.AllUserItems[0][i].id,GameCommonData.Player.Role.Id,GameCommonData.Player.Role.Name);
//						}
					}
				}
			}
		}
		
		/**
		 * color分类
		 * index分页
		 * 
		 */
		private function showStoneData(color:int,index:int):void
		{
			clearStoneBag();
			this.clearStone();
			StoneDatas.stoneAllStoneList = new Array();
			for(var n:int =0;n<StoneDatas.stoneMaterialList.length;n++)
			{
				var obj:Object = StoneDatas.stoneMaterialList[n];
				if(StoneDatas.stoneMaterialList[n].color==(color+1) || color==0)
				{
					StoneDatas.stoneAllStoneList.push(StoneDatas.stoneMaterialList[n]);
				}
			}
			maxIndexPage = StoneDatas.stoneMaterialList.length/16+1;
			StoneCompose.page.text = (index+1) + "/" + maxIndexPage;
			
			var a:Object = StoneDatas.stoneAllStoneList;
			var beginInt:int = index*16;
			var count:int= (index+1)*16>StoneDatas.stoneAllStoneList.length?StoneDatas.stoneAllStoneList.length:(index+1)*16;
			for(var i:int =beginInt ; i<count; i++)
			{
				var index:int = 0;
				
				var item:Object = UIConstData.ItemDic_1[StoneDatas.stoneAllStoneList[i].type];
				index = int(StoneDatas.stoneAllStoneList[i].color);
				StoneCompose["item_"+(i-beginInt)].txtName.htmlText = "<font COLOR='"+StoneDatas.stoneEquipColorList[index]+"'>"+item.Name+"</font>";
				StoneCompose["item_"+(i-beginInt)].stoneHole.text = "";
				StoneCompose["item_"+(i-beginInt)].equiped.visible = false;
				StoneCompose["item_"+(i-beginInt)].equiped.mouseEnabled = false;
				StoneCompose["item_"+(i-beginInt)].equiped.mouseChildren = false
				StoneCompose["item_"+(i-beginInt)].addEventListener(MouseEvent.CLICK,onSelectStoneEvent);
				
				item = BagData.getItemById(StoneDatas.stoneAllStoneList[i].id);
				if(item)
				{
					var useItem:UseItem = new UseItem(item.index, item.type, StoneCompose);
					useItem.x =StoneCompose["item_"+(i-beginInt)].item.x+2;
					useItem.y = StoneCompose["item_"+(i-beginInt)].item.y+2;
					useItem.Id = item.id;
					useItem.IsBind = item.isBind;
					useItem.Type = item.type;
					useItem.setImageScale(34,34);
					StoneCompose["item_"+(i-beginInt)].addChild(useItem);
					StoneCompose["item_"+(i-beginInt)].stoneHole.text = "数量："+item.amount;
					stoneBagList[i-beginInt].Grid.name = "bag_"+item.index.toString();
					stoneBagList[i-beginInt].Item = useItem;
				}
			}
			
			for(var j:int = i-beginInt;j<16;j++)
			{
				StoneCompose["item_"+j].txtName.text= "";
				StoneCompose["item_"+j].stoneHole.text = "";
				StoneCompose["item_"+j].equiped.visible = false;
				StoneCompose["item_"+j].equiped.mouseEnabled = false;
				StoneCompose["item_"+j].equiped.mouseChildren = false
				StoneCompose["item_"+j].removeEventListener(MouseEvent.CLICK,onSelectStoneEvent);
			}
		}
		
		private function clearStoneBag():void
		{
			for(var i:int=0; i<stoneBagList.length; i++)
			{
				if(stoneBagList[i].Item)
				{
					stoneBagList[i].Item.reset();
					stoneBagList[i].Item.gc();
					if(StoneCompose["item_"+i].contains(stoneBagList[i].Item as UseItem))
					{
						StoneCompose["item_"+i].removeChild(stoneBagList[i].Item);
					}
					stoneBagList[i].Item = null;
					stoneBagList[i].Grid.name = "instance_"+i;
				}
			}
		}
		
		/** 选中宝石事件 */
		private function onSelectStoneEvent(e:MouseEvent):void
		{
			var index:int = int( (e.currentTarget.name as String).split("_")[1] );
			
			this.showStone(index);
		}
		
		private function selectView(e:MouseEvent):void
		{
			var lastPage:int = curPageType;
			curPageType = e.currentTarget.name.split("_")[1];
			
			StoneCompose["Prop_"+lastPage].gotoAndStop(1);
			StoneCompose["Prop_"+curPageType].gotoAndStop(3);
			StoneCompose["Prop_"+lastPage].mouseEnabled = true;
			StoneCompose["Prop_"+curPageType].mouseEnabled = false;
			
			subIndexPage = 0;
			showStoneData(curPageType,subIndexPage);
		}
		
		/**
		 * index 代表物品框下标
		 */
		private function showStone(index:int):void
		{
			
			var obj:Object = BagData.getItemById(StoneDatas.stoneAllStoneList[curPageType*16+index].id);
			
			var stoneTypeArr:Array = BagData.getAllItemByType(obj.type,obj.isBind);
			if(aStoneId.length>0 && aStoneId.length<5 && stoneArr[0].type == obj.type && stoneArr[0].isBind == obj.isBind)
			{
				/**
				 * 同种物品，绑定状态不一样
				 * */

				for(var i:int=aStoneId.length-1; i<5; i++)
				{
					var item:Object = stoneTypeArr.shift();
					if(item)
					{
						stoneArr[i] = item;
					}
				}
				
			}else
			{
				stoneArr = [];
				var count:int = stoneTypeArr.length>5?5:stoneTypeArr.length;
				for(var j:int=0; j<count; j++)
				{
					stoneArr[j] = stoneTypeArr[j];
				}
			}
//			if(stoneArr.length>5)
//			{
//				StoneCompose["item_"+index].stoneHole.text = (stoneTypeArr.length-5).toString();
//				addStone(5,index);
//			}else
//			{
			this.clearStone();
			StoneCompose["item_"+index].stoneHole.text = "";
			addStone(stoneArr,index);
//			}
		}
		
		private function addStone(arr:Array,index:int):void
		{
			this.clearStone();
			var count:int = 0;
			for(var i:int=0;i<arr.length;i++)
			{
				for(var j:int=0;j<arr[i].amount;j++)
				{
					if(count >= 5)return;
					var useItem:UseItem = new UseItem(arr[i].index, arr[i].type, StoneCompose);
					useItem.x = StoneCompose["stone_"+count].x+2;
					useItem.y = StoneCompose["stone_"+count].y+2;
					useItem.Id = arr[i].id;
					useItem.IsBind = arr[i].isBind;
					useItem.Type = arr[i].type;
					useItem.setImageScale(34,34);
					StoneCompose.addChild(useItem);
					this.stoneList[count].Item = useItem;
					this.stoneList[count].Grid.name = "bag_"+arr[i].index;
					aStoneId.push(arr[i].type);
					count++;
				}
			}
		}
		
		private function clearStone():void
		{
			if(stoneList)
			{
				for(var i:int=0;i<stoneList.length;i++)
				{
					if(stoneList[i].Item)
					{
						stoneList[i].Item.reset();
						stoneList[i].Item.gc();
						if(StoneCompose.contains(stoneList[i].Item as UseItem))
						{
							StoneCompose.removeChild(stoneList[i].Item as UseItem);
						}
						stoneList[i].Item = null;
						stoneList[i].Grid.name = "instance_"+i;
					}
				}
			}
			
			aStoneId = [];
		}
		
		private function onBtnCompose(e:MouseEvent):void
		{
			if(aStoneId.length>0)
			{
				var id:int = getPeiFangByType(aStoneId[0]);
				facade.sendNotification(ComposeCommand.NAME,{idStoneArr:aStoneId,idFu:id});
				this.clearStone();
			}
		}
		
		private function getPeiFangByType(type:int):int
		{
			var arr:Array = UIConstData.FireInStoneList[0];
			if(arr)
			{
				for(var i:int=0;i<arr.length;i++)
				{
					if(arr[i].type1 == type)
					{
						return arr[i].id;
					}
				}
			}
			
			return 0;
		}
	}
}