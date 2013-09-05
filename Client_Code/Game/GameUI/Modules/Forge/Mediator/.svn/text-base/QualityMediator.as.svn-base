package GameUI.Modules.Forge.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Bag.Proxy.BagData;
	import GameUI.Modules.Bag.Proxy.GridUnit;
	import GameUI.Modules.Forge.Data.*;
	import GameUI.Modules.RoleProperty.Datas.RolePropDatas;
	import GameUI.Modules.ToolTip.Const.IntroConst;
	import GameUI.Proxy.DataProxy;
	import GameUI.UIConfigData;
	import GameUI.View.BaseUI.PanelBase;
	import GameUI.View.items.UseItem;
	
	import Net.ActionSend.EquipSend;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class QualityMediator extends Mediator
	{
		public static const NAME:String = "QualityMediator";
		private var panelBase:PanelBase;
		private var parentView:MovieClip;
		private var cacheCells:Array=[];
		
		private var item:Object = null;
		private var useItem:UseItem = null;
		
		private var equip:GridUnit = null;
		private var material:GridUnit = null;
		private var newEquip:GridUnit = null;
		private var delayNum:Number = 0;
		private var timer:Timer;
		
		private var countGetItem:int = 0;//查询物品详细信息次数
		private var useId:int = 0;
		
		private var materialTypeList:Array = new Array();//同一种材料分为绑定和非绑定
		
		private var btnQualityFilter:Array = null;
		
		private var _nRed:Number=0.3086;
		private var _nGreen:Number=0.6094;
		private var _nBlue:Number=0.0820;
		
		private var lastIndex:int = -1;
		private var laseFilter:Array = null;
		
		public function QualityMediator(parentMc:MovieClip)
		{
			parentView = parentMc;
			super(NAME);
		}
		
		public function get Quality():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				ForgeEvent.INIT_FORGE_UI,
				ForgeEvent.SHOW_FORGE_QUALITY_UI,					//打开宠物装备
				ForgeEvent.SELECT_ITEM_ONMOUSEDOWN,					//选中物品事件
				ForgeEvent.UPDATE_SELECT_ITEM,
				EventList.UPDATEMONEY,
				ForgeEvent.CLOSE_FORGE_QUALITY_UI					//关闭宠物装备
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ForgeEvent.INIT_FORGE_UI:
					this.setViewComponent(ForgeData.loadswfTool.GetResource().GetClassByMovieClip("Quality"));
					this.Quality.mouseEnabled=false;
					timer = new Timer(500, 1);
					Quality.x = 0;
					Quality.y = 27;
					break;
				case ForgeEvent.SHOW_FORGE_QUALITY_UI:
					registerView();
					initData();
					parentView.addChild(Quality);
					break;
				case ForgeEvent.CLOSE_FORGE_QUALITY_UI:
					retrievedView();
					parentView.removeChild(Quality);
					break;
				case ForgeEvent.SELECT_ITEM_ONMOUSEDOWN:
					if(ForgeData.curPage == 2)
					{
						showEquip(notification.getBody() as int);
						this.onSelectEquip(notification.getBody() as int);
					}
					break;
				case ForgeEvent.UPDATE_SELECT_ITEM:
					if(ForgeData.curPage == 2)
					{
						if(ForgeData.selectItem==null)return;
						var id:int = notification.getBody() as int;
						this.clearEquip();
						this.clearMaterial();
						this.clearNewEquip();
						var item:Object = BagData.getItemById(id);
						if(item == null)
						{
//							if(countGetItem == 0)
//							{
							setTimeout(updateItem,200,id);
//								countGetItem = 1;
//							}
							
						}else
						{
							var index:int = ForgeData.getIndexById(item.id);
							ForgeData.selectItem = ForgeData.forgeEquipGridList[index];
							facade.sendNotification(ForgeEvent.SELECT_ITEM_ONMOUSEDOWN,index);
						}
					}
					break;
				case EventList.UPDATEMONEY:															//更新钱
					
					switch (notification.getBody().target){
						case "mcUnBind"://copper
							Quality.TipsInfo.copper.text = notification.getBody().money;
							break;
						case "mcBind"://copperBind
							Quality.TipsInfo.copperBind.text = notification.getBody().money;
							break;
						case "mcRmb"://gold
							Quality.TipsInfo.gold.text = notification.getBody().money;
							break;
						case "mcBindRmb"://goldBind
							Quality.TipsInfo.goldBind.text = notification.getBody().money;
							break;
						
					}
					break;
			}
		}
		
		private function initData():void
		{
			//获取宠物数据
			ForgeData.selectIdArray = new Dictionary();
			lastIndex = -1;
			
			Quality.TipsInfo.copper.text = GameCommonData.Player.Role.UnBindMoney;
			Quality.TipsInfo.copperBind.text = GameCommonData.Player.Role.BindMoney;
			Quality.TipsInfo.gold.text = GameCommonData.Player.Role.UnBindRMB;
			Quality.TipsInfo.goldBind.text = GameCommonData.Player.Role.BindRMB;
		}
		
		private function registerView():void
		{
			//初始化素材事件
			var gridUnit:MovieClip = ForgeData.loadswfTool.GetResource().GetClassByMovieClip("GridUnit");
			gridUnit.x = Quality.equip.x;
			gridUnit.y = Quality.equip.y;
			Quality.addChild(gridUnit);
			equip = new GridUnit(gridUnit, true);//选中装备
			equip.parent = Quality;									//设置父级
			equip.Item	= null;										//格子的物品
			
			gridUnit = ForgeData.loadswfTool.GetResource().GetClassByMovieClip("GridUnit");
			gridUnit.x = Quality.Material.x;
			gridUnit.y = Quality.Material.y;
			Quality.addChild(gridUnit);
			material = new GridUnit(gridUnit, true);//选中装备
			material.parent = Quality;									//设置父级
			material.Item	= null;										//格子的物品
			
			gridUnit = ForgeData.loadswfTool.GetResource().GetClassByMovieClip("BigGrid");
			gridUnit.x = Quality.newEquip.x;
			gridUnit.y = Quality.newEquip.y;
			Quality.addChild(gridUnit);
			newEquip = new GridUnit(gridUnit, true);//选中装备
			newEquip.parent = Quality;									//设置父级
			newEquip.Item	= null;										//格子的物品
			
			Quality.btnQuality.addEventListener(MouseEvent.CLICK,onBtnClick);
			(Quality.btnName as MovieClip).mouseEnabled = false;
			(Quality.btnName as MovieClip).mouseChildren = false;
			btnQualityFilter = Quality.btnQuality.filters;
			Quality.btnQuality.filters =[new ColorMatrixFilter([_nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, 0, 0, 0, 1, 0])];
			Quality.txtEquip.htmlText="";
			Quality.txtNewEquip.text="";
			Quality.txtMaterialNum.text="";
			Quality.txtMoney.text="0";
			
			this.clearEquip();
			this.clearMaterial();
			this.clearNewEquip();
		}
		
		private function retrievedView():void
		{
			//释放素材事件
			Quality.btnQuality.removeEventListener(MouseEvent.CLICK,onBtnClick);
			this.clearEquip();
			this.clearMaterial();
			this.clearNewEquip();
			ForgeData.selectItem==null
		}
		
		private function onBtnClick(e:MouseEvent):void
		{
			//按钮事件
			if(timer.running)
			{
				return;
			}
			if(item)
			{
				var param:Array=[1,0,65,item.id,0];
				EquipSend.createMsgCompound(param);
				timer.reset();
				timer.start();
			}
			
		}
		
		/**  
		 * 改变装备选中状态，保存选中装备，选中装备为灰色
		 * */
		private function onSelectEquip(index:int):void
		{
			laseFilter = ForgeData.forgeEquipGridList[index].Grid.filters;
			ForgeData.forgeEquipGridList[index].Grid.filters=[new ColorMatrixFilter([_nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, 0, 0, 0, 1, 0])];
			
			ForgeData.forgeEquipGridList[index].Grid.mouseEnabled = false;
			ForgeData.forgeEquipGridList[index].Grid.mouseChildren = false;
			
			if(lastIndex!=-1)
			{
				
				ForgeData.forgeEquipGridList[lastIndex].Grid.filters=laseFilter;
				
				ForgeData.forgeEquipGridList[lastIndex].Grid.mouseEnabled = true;
				ForgeData.forgeEquipGridList[lastIndex].Grid.mouseChildren = true;
				delete ForgeData.selectIdArray[ForgeData.forgeEquipGridList[lastIndex].Item.Id];
				
			}
			if(ForgeData.selectItem)
			ForgeData.selectIdArray[ForgeData.selectItem.Item.Id] = ForgeData.selectItem.Item.Id;
			lastIndex = index;
		}
		
		private function updateItem(id:int):void
		{
//			facade.sendNotification(ForgeEvent.UPDATE_SELECT_ITEM,id);
			var item:Object = BagData.getItemById(id);
			if(item == null)
			{
				item = RolePropDatas.getRoleItemById(id);
			}
			
			if(item)
			{
				var index:int = ForgeData.getIndexById(item.id);
				ForgeData.selectItem = ForgeData.forgeEquipGridList[index];
				facade.sendNotification(ForgeEvent.SELECT_ITEM_ONMOUSEDOWN,index);
//				countGetItem = 0;//查询到后，设置为0
			}
//			else
//			{
//				setInterval(updateItem,300,id);
//			}
		}
		
		/** 显示选中装备 */
		private function showEquip(index:int=0):void
		{
			//显示选中装备
			clearInterval(delayNum);
			if(ForgeData.selectItem == null || ForgeData.selectItem.Item==null)return;
			var item:Object;
			if(index<ForgeData.countEquiped)
			{
				item = RolePropDatas.getItemByType(ForgeData.selectItem.Item.Type);
			}
			else
			{
				item = BagData.AllUserItems[0][ForgeData.selectItem.Index];
			}

			if(item)
			{
				useItem = this.getCells(item.index, item.type, Quality);
				useItem.x = equip.Grid.x+2;
				useItem.y = equip.Grid.y+2;
				useItem.Id = item.id;
				useItem.IsBind = item.isBind;
				useItem.Type = item.type;
				useItem.setImageScale(34,34);
				clearEquip();
				
				equip.Item = useItem;
				if(index<ForgeData.countEquiped)
				{
					equip.Grid.name = "hero_" + item.position.toString()+"_"+index.toString();
				}else
				{
					equip.Grid.name = "bag_" + item.index.toString() +"_"+ index.toString();
				}
				
				equip.Grid.addEventListener(MouseEvent.CLICK,onUnEquip);
				Quality.addChild(useItem);
				
				setTimeout(delayGetItem,200,item);
			}
			
		}
		
		private function delayGetItem(item:Object):void
		{
			this.item = IntroConst.ItemInfo[item.id];
			if(this.item == null)
			{
				this.item = RolePropDatas.ItemList[item.position]
			}
			//			var lev:int = (this.item.type % 10000)%4;
			this.clearNewEquip();
			this.clearMaterial();
			if(this.item == null)
			{
//				setInterval(delayGetItem,100,item);
				return;
			}
//			if(this.item.color<1)
//			{
//				this.clearEquip();
//				return;
//			}
			if(this.item.star < 4)
			{
				showNewEquip(item.type);
				showMaterial(item.id,item.type);
				
				useId = 500+int(this.item.star)-1;
				Quality.txtMoney.text = ForgeData.forgeCommDataList[useId].qualityMoney;
			}
			
			Quality.txtEquip.htmlText="<font color='"+ForgeData.equipColorList[this.item.color]+"'>"+"【"+ForgeData.equipStarList[this.item.star]+"】"+this.item.itemName+"</font>";
			Quality.txtEquip.visible = true;
		}
		/** 卸载装备 */
		private function onUnEquip(e:MouseEvent):void
		{
			this.clearEquip();
			this.clearMaterial();
			this.clearNewEquip();
			ForgeData.selectItem = null;
			var index:int = e.currentTarget.name.split("_")[2];
			if(lastIndex!=-1)
			{
				
				ForgeData.forgeEquipGridList[lastIndex].Grid.filters=laseFilter;
				
				ForgeData.forgeEquipGridList[lastIndex].Grid.mouseEnabled = true;
				ForgeData.forgeEquipGridList[lastIndex].Grid.mouseChildren = true;
				var item:Object = ForgeData.forgeEquipGridList[index];
				delete ForgeData.selectIdArray[item.Item.Id];
				lastIndex = -1;
			}
		}
		
		/** 显示材料 */
		private function showMaterial(id:int,type:int):Boolean
		{
			this.item = IntroConst.ItemInfo[id];
			if(this.item == null)
			{
				this.item = RolePropDatas.getRoleItemById(id);
			}
			materialTypeList = new Array();
			if(item)
			{
				
				var strengthenList:Array = UIConstData.MarketGoodList[1];
				var fastBuyList:Array = new Array();
				var good:Object = null;
				var materialItem:Object =null; 
				
				for(var i:int=0; i<strengthenList.length; i++)
				{
					if(strengthenList[i].type2 == 5)
					{
						materialTypeList.push(strengthenList[i].type);
					}
				}
				
				if(materialTypeList.length == 0)return false;
				
//				var materialItem:Object = UIConstData.ItemDic_1[materialTypeList[0]];
//				var materialItem:Object = BagData.getItemByType(materialTypeList[0]);
//				if(materialItem == null)
//				{
					materialItem = UIConstData.ItemDic_1[materialTypeList[0]];
//				}
				if(materialItem != null)
				{
					var useItem1:UseItem = this.getCells(materialItem.index, materialItem.type, Quality);
					useItem1.x = Quality.Material.x+2;
					useItem1.y = Quality.Material.y+2;
					useItem1.Id = materialItem.id;
					useItem1.IsBind = materialItem.isBind;
					useItem1.Type = materialItem.type;
					useItem.setImageScale(34,34);
					clearMaterial();
					
					material.Item = useItem1;
					material.Index = materialItem.index;
//					material.Grid.name = "bag_"+materialItem.index.toString();
					Quality.addChild(useItem1);
					
					useId = 500+int(item.star)-1;
					
					var count:int = BagData.hasItemNum(materialItem.type);
					Quality.txtMaterialNum.text=count+"/"+ForgeData.forgeCommDataList[useId].qualityNum;
					
					materialItem = UIConstData.ItemDic_1[materialTypeList[0]];
					
					good = new Object();
					
					if(materialItem)
					{
						good.type = materialItem.type;
						good.name = materialItem.Name;
						good.num = count;
						fastBuyList.push(good);
					}
					
					facade.sendNotification(ForgeEvent.UPDATE_ITEM_FASTBUY,{data:fastBuyList});
					
					if(count>=ForgeData.forgeCommDataList[useId].qualityNum)
					{
						return true;
					}
					else
					{
						material.Item.filters = [new ColorMatrixFilter([_nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, 0, 0, 0, 1, 0])];
						return false;
					}
					
				}
				else
				{
					return false;
				}
			}
			return false;
		}
		
		/** 预显示新装备 */
		private function showNewEquip(type:int):void
		{
			var lev:int = (type % 10000)%4;
			var newType:int = 0;
			switch(lev)
			{
				case 0://完美
					newType = type;
					break;
				case 1://普通
				case 2://优秀
				case 3://精良
					newType = type+1;
					break;
			}
			var newItem:Object = UIConstData.ItemDic_1[newType];
			if(newItem==null)return; 
			useItem = this.getCells(equip.Index, newItem.type, Quality);
			useItem.x = newEquip.Grid.x+2;
			useItem.y = newEquip.Grid.y+2;
			useItem.Id = newItem.id;
			useItem.IsBind = newItem.isBind;
			useItem.Type = newItem.type;
			useItem.setImageScale(48,48);
			clearNewEquip();
			newEquip.Item = useItem;
			newEquip.Grid.name = "newEquip_"+equip.Index.toString();
//			newEquip.Grid.addEventListener(MouseEvent.MOUSE_OVER,onShowNewEquip);
//			newEquip.Grid.name = "bag_" + item.index.toString();
			Quality.addChild(useItem);
			Quality.txtNewEquip.htmlText="<font color='"+ForgeData.equipColorList[this.item.color]+"'>"+"【"+ForgeData.equipStarList[this.item.star+1]+"】"+this.item.itemName+"</font>";
		}
		
//		private function onShowNewEquip(e:MouseEvent):void
//		{
//			if(equip==null||equip.Item==null||newEquip==null||newEquip.Item==null)return;
//			
//		}
		
		/** 清除选中装备 */
		private function clearEquip():void
		{
			//显示选中装备
			Quality.txtEquip.text="";
			Quality.txtEquip.visible = false;
			if(equip.Item == null)return;
			equip.Item.reset();
			equip.Item.gc();
			if(Quality.contains(equip.Item as UseItem))
			{
				Quality.removeChild(equip.Item as UseItem);
			}
			equip.Grid.name = "instance_Material";
			equip.Grid.addEventListener(MouseEvent.CLICK,onUnEquip);
			equip.Item = null;
		}
		
		private function clearMaterial():void
		{
			if(material.Item == null)return;
			material.Item.reset();
			material.Item.gc();
			if(Quality.contains(material.Item as UseItem))
			{
				Quality.removeChild(material.Item as UseItem);
			}
			material.Grid.name = "instance_Material";
			material.Item = null;
			
			Quality.txtMaterialNum.text="";
		}
		
		private function clearNewEquip():void
		{
			if(newEquip.Item == null)return;
			newEquip.Item.reset();
			newEquip.Item.gc();
			if(Quality.contains(newEquip.Item as UseItem))
			{
				Quality.removeChild(newEquip.Item as UseItem);
			}
			newEquip.Grid.name = "instance_newEquip";
			newEquip.Item = null;
			Quality.txtNewEquip.text="";
		}
		
		/** 创建UseItem实例 */
		protected function getCells(pos:int, icon:String, parent:DisplayObjectContainer):UseItem{
			
			var useItem:UseItem=this.cacheCells.shift();
			useItem=new UseItem(pos,icon,parent);
			return useItem;
		}
	}
}