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
	import flash.utils.setTimeout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class InheritMediator extends Mediator
	{
		public static const NAME:String = "InheritMediator";
		private var panelBase:PanelBase;
		private var parentView:MovieClip;
		
		private var item:Object = null;
		private var newItem:Object = null;
		private var cacheCells:Array=[];
		
		private var equip1:GridUnit = null;
		private var equip2:GridUnit = null;
		private var Material:GridUnit = null;
		private var look:GridUnit = null;
		private var delayNum:Number = 0;
		
		private var useId:int = 0;//存放配置文件物品ID		
		private var inheritStoneList:Array = new Array();
		private var filterDic:Dictionary = null;//存放装备滤镜
		private var inheritFilter:Array = null;
		private var _nRed:Number=0.3086;
		private var _nGreen:Number=0.6094;
		private var _nBlue:Number=0.0820;
		
		public function InheritMediator(parentMc:MovieClip)
		{
			parentView = parentMc;
			super(NAME);
		}
		
		public function get Inherit():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				ForgeEvent.INIT_FORGE_UI,
				ForgeEvent.SHOW_FORGE_INHERIT_UI,					//打开宠物装备
				ForgeEvent.SELECT_ITEM_ONMOUSEDOWN,					//选中物品事件
				ForgeEvent.INHERIT_SUCCESS,
				EventList.UPDATEMONEY,
				ForgeEvent.CLOSE_FORGE_INHERIT_UI					//关闭宠物装备
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ForgeEvent.INIT_FORGE_UI:
					this.setViewComponent(ForgeData.loadswfTool.GetResource().GetClassByMovieClip("Inherit"));
					this.Inherit.mouseEnabled=false;
					Inherit.x = 0;
					Inherit.y = 27;
					break;
				case ForgeEvent.SHOW_FORGE_INHERIT_UI:
					registerView();
					initData();
					parentView.addChild(Inherit);
					break;
				case ForgeEvent.CLOSE_FORGE_INHERIT_UI:
					retrievedView();
					parentView.removeChild(Inherit);
					break;
				case ForgeEvent.SELECT_ITEM_ONMOUSEDOWN:
					if(ForgeData.curPage == 5)
					{
						if(showEquip(notification.getBody() as int))
						{
							this.onSelectEquip(notification.getBody() as int);
						}
					}
					break;
				case ForgeEvent.INHERIT_SUCCESS:
					clearEquip1();
					this.clearEquip2();
					this.clearLook();
					this.clearMaterial();
					break;
				case EventList.UPDATEMONEY:															//更新钱
					
					switch (notification.getBody().target){
						case "mcUnBind"://copper
							Inherit.TipsInfo.copper.text = notification.getBody().money;
							break;
						case "mcBind"://copperBind
							Inherit.TipsInfo.copperBind.text = notification.getBody().money;
							break;
						case "mcRmb"://gold
							Inherit.TipsInfo.gold.text = notification.getBody().money;
							break;
						case "mcBindRmb"://goldBind
							Inherit.TipsInfo.goldBind.text = notification.getBody().money;
							break;
						
					}
					break;
			}
		}
		
		private function initData():void
		{
			//获取宠物数据
			ForgeData.selectIdArray = new Dictionary();
			filterDic = new Dictionary();
			
			Inherit.TipsInfo.copper.text = GameCommonData.Player.Role.UnBindMoney;
			Inherit.TipsInfo.copperBind.text = GameCommonData.Player.Role.BindMoney;
			Inherit.TipsInfo.gold.text = GameCommonData.Player.Role.UnBindRMB;
			Inherit.TipsInfo.goldBind.text = GameCommonData.Player.Role.BindRMB;
		}
		
		private function registerView():void
		{
			//初始化素材事件
			Inherit.btnInherit.addEventListener(MouseEvent.CLICK,onBtnClick);
			(Inherit.btnName as MovieClip).mouseEnabled = false;
			(Inherit.btnName as MovieClip).mouseChildren = false;
//			Inherit.btnInherit.mouseEnabled = false;
			inheritFilter = Inherit.btnInherit.filters;
			Inherit.btnInherit.filters = [new ColorMatrixFilter([_nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, 0, 0, 0, 1, 0])];
				
			var gridUnit:MovieClip = ForgeData.loadswfTool.GetResource().GetClassByMovieClip("GridUnit");
			gridUnit.x = Inherit.equip_1.x;
			gridUnit.y = Inherit.equip_1.y;
			Inherit.addChild(gridUnit);
			equip1 = new GridUnit(gridUnit, true);//选中装备
			equip1.parent = Inherit;									//设置父级
			equip1.Item	= null;										//格子的物品
			
			gridUnit = ForgeData.loadswfTool.GetResource().GetClassByMovieClip("GridUnit");
			gridUnit.x = Inherit.equip_2.x;
			gridUnit.y = Inherit.equip_2.y;
			Inherit.addChild(gridUnit);
			equip2 = new GridUnit(gridUnit, true);//选中装备
			equip2.parent = Inherit;									//设置父级
			equip2.Item	= null;										//格子的物品
			
			gridUnit = ForgeData.loadswfTool.GetResource().GetClassByMovieClip("BigGrid");
			gridUnit.x = Inherit.Material.x;
			gridUnit.y = Inherit.Material.y;
			Inherit.addChild(gridUnit);
			Material = new GridUnit(gridUnit, true); //材料1
			Material.parent = Inherit;									//设置父级
			Material.Item	= null;										//格子的物品
			
			gridUnit = ForgeData.loadswfTool.GetResource().GetClassByMovieClip("GridUnit");
			gridUnit.x = Inherit.look.x;
			gridUnit.y = Inherit.look.y;
			Inherit.addChild(gridUnit);
			look = new GridUnit(gridUnit, true); //材料1
			look.parent = Inherit;									//设置父级
			look.Item	= null;										//格子的物品
			
			Inherit.txtEquipName_1.text = "";
			Inherit.txtEquipName_2.text = "";
			Inherit.txtLookName.text = "";
			
			Inherit.txtMoney.text = "0";
		}
		
		private function retrievedView():void
		{
			//释放素材事件
			Inherit.btnInherit.removeEventListener(MouseEvent.CLICK,onBtnClick);
			clearEquip1();
			this.clearEquip2();
			this.clearLook();
			this.clearMaterial();
			item = null;
			newItem = null
			equip1 = null;
			equip2 = null;
			Material = null;
			look = null;
		}
		
		/** 装备选中变灰 */
		private function onSelectEquip(index:int):void
		{
//			if(equip1.Item == null || equip2.Item == null)
//			{
				filterDic[index] = ForgeData.forgeEquipGridList[index].Grid.filters;
				ForgeData.forgeEquipGridList[index].Grid.filters=[new ColorMatrixFilter([_nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, 0, 0, 0, 1, 0])];
				
				ForgeData.forgeEquipGridList[index].Grid.mouseEnabled = false;
				ForgeData.forgeEquipGridList[index].Grid.mouseChildren = false;
				ForgeData.selectIdArray[ForgeData.selectItem.Item.Id] = ForgeData.selectItem.Item.Id;
//			}
		}
		
		/** 显示选中装备 */
		private function showEquip(index:int=0):Boolean
		{
			//显示选中装备
//			if(equip1.Item != null && equip2.Item != null)return false;
			if(ForgeData.selectItem == null || ForgeData.selectItem.Item==null)return false;
			var item:Object;//选中装备
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
				this.item = IntroConst.ItemInfo[item.id];
				if(this.item ==null)
				{
					//					setTimeout(showEquip,100,item);
					return false;
				}
				
				//如果已经有两件装备放入，则取下两件装备，放入当前选中装备
				if(equip1.Item != null && equip2.Item != null)
				{
					this.onLeftGridClick(null);
					this.onRightGridClick(null);
				}else if(equip1.Item != null && equip2.Item == null)
				{
					var type1:int = equip1.Item.Type/10000;
					var type2:int = item.type/10000;
					if(type1 != type2)
					{
						//如果第二件装备类型和第一件不一样，则替换掉第一件装备
						this.onLeftGridClick(null);
					}
				}
				
				if(equip1.Item == null)
				{
					var useItem1:UseItem = this.getCells(item.index, item.type, Inherit);
					useItem1.x = equip1.Grid.x+2;
					useItem1.y = equip1.Grid.y+2;
					useItem1.Id = item.id;
					useItem1.IsBind = item.isBind;
					useItem1.Type = item.type;
					useItem1.setImageScale(34,34);
					equip1.Item = useItem1;
					equip1.Index = item.index;
					if(index<ForgeData.countEquiped)
					{
						equip1.Grid.name = "hero_" + item.position.toString()+"_"+index.toString();
					}
					else
					{
						equip1.Grid.name = "bag_" + item.index.toString() +"_"+ index.toString();
					}
					
					(equip1.Grid as MovieClip).addEventListener(MouseEvent.CLICK,onLeftGridClick);
					Inherit.addChild(useItem1);
					Inherit.txtEquipName_1.htmlText="<font color='"+ForgeData.equipColorList[this.item.color]+"'>"+"【"+ForgeData.equipStarList[this.item.star]+"】"+this.item.itemName+"+"+this.item.level+"</font>";
					
				}
				else if(equip2.Item == null)
				{
					
//					if(equip1.Item.Id == item.id)return false;
					var useItem2:UseItem = this.getCells(item.index, item.type, Inherit);
					useItem2.x = equip2.Grid.x+2;
					useItem2.y = equip2.Grid.y+2;
					useItem2.Id = item.id;
					useItem2.IsBind = item.isBind;
					useItem2.Type = item.type;
					useItem2.setImageScale(34,34);
					(equip2.Grid as MovieClip).addEventListener(MouseEvent.CLICK,onRightGridClick);
					equip2.Item = useItem2;
					equip2.Index = item.index;
					if(index<ForgeData.countEquiped)
					{
						equip2.Grid.name = "hero_" + item.position.toString()+"_"+index.toString();
					}
					else
					{
						equip2.Grid.name = "bag_" + item.index.toString() +"_"+ index.toString();
					}
					
					Inherit.addChild(useItem2);
					Inherit.txtEquipName_2.htmlText="<font color='"+ForgeData.equipColorList[this.item.color]+"'>"+"【"+ForgeData.equipStarList[this.item.star]+"】"+this.item.itemName+"+"+this.item.level+"</font>";
					
				}
				
				if(equip1.Item != null && equip2.Item != null)
				{
					showNewEquip(equip1.Item.Id,equip2.Item.Id);
					if(showMaterial(item.type))
					{
						Inherit.btnInherit.filters = inheritFilter;
						Inherit.btnInherit.mouseEnabled = true;
					}
					else
					{
						Inherit.btnInherit.filters = [new ColorMatrixFilter([_nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, 0, 0, 0, 1, 0])];;
						//						Inherit.btnInherit.mouseEnabled = false;
					}
				}
			}
			return true;
		}
		
		/** 显示继承后的装备 */
		private function showMaterial(type:int):Boolean
		{
			var inheritList:Array = UIConstData.MarketGoodList[1];
			var fastBuyList:Array = new Array();
			var good:Object = null;
			var materialItem:Object =null; 
			
			inheritStoneList = new Array();
			for(var i:int=0; i<inheritList.length; i++)
			{
				if(inheritList[i].type2 == 7)
				{
					inheritStoneList.push(inheritList[i].type);
				}
			}
			
			if(inheritStoneList.length == 0)return false;
//			materialItem = BagData.getItemByType(inheritStoneList[0]);
//			if(materialItem == null)
//			{
				materialItem = UIConstData.ItemDic_1[inheritStoneList[0]];
				
//			}
			if(materialItem != null)
			{
				var useItem1:UseItem = this.getCells(0, materialItem.type, Inherit);
				useItem1.x = Inherit.Material.x+2;
				useItem1.y = Inherit.Material.y+2;
				useItem1.Id = materialItem.id;
				useItem1.IsBind = materialItem.isBind;
				useItem1.Type = materialItem.type;
				useItem1.setImageScale(48,48);
				Material.Item = useItem1;
				Material.Index = materialItem.index;
				Material.Grid.name = "Decompose_"+materialItem.type.toString();
				Inherit.addChild(useItem1);
				
				var count:int = BagData.hasItemNum(materialItem.type);
				Inherit.txtMaterialNum.text = BagData.hasItemNum(materialItem.type)+"/1";
				
				good = new Object();
				good.type = materialItem.type;
				good.name = materialItem.Name;
				good.num = count;
				fastBuyList.push(good);
				
				facade.sendNotification(ForgeEvent.UPDATE_ITEM_FASTBUY,{data:fastBuyList});
				
				if(count==0)
				{
					Material.Item.filters = [new ColorMatrixFilter([_nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, 0, 0, 0, 1, 0])];
					return false;
				}
				else
				{
					return true;
				}
			}
			else
			{
				return false;
			}
		}
		
		/** 显示继承后的装备 */
		private function showNewEquip(leftId:int,rightId:int):void
		{
			/**
			 * 优先选取等级高物品
			 * 前缀不做筛选，跟随物品等级高的前缀
			 * 颜色不做筛选，跟随物品等级高的颜色变化
			 * 强化等级选取强化等级高的
			 * 洗炼属性选取洗炼属性评级高的
			 * 
			 * 此处只为显示物品图片，暂时还未做筛选
			 */
			var item1:Object = IntroConst.ItemInfo[leftId];
			if(item1 == null)return;
			var item2:Object = IntroConst.ItemInfo[rightId];
			if(item2 == null)return;
			
			var obj1:Object = UIConstData.ItemDic_1[item1.type];
			var obj2:Object = UIConstData.ItemDic_1[item2.type];
			
			var useItem:UseItem = null;
			
			if(obj1.Level > obj2.Level)//先判断等级高的
			{
				this.newItem = item1;
				useItem = this.getCells(equip1.Index, newItem.type, Inherit);
			}
			else/* if(item1.level < item2.level)*/
			{
				this.newItem = item2;
				useItem = this.getCells(equip2.Index, newItem.type, Inherit);
			}

			useItem.x = look.Grid.x+2;
			useItem.y = look.Grid.y+2;
			useItem.Id = newItem.id;
			useItem.IsBind = newItem.isBind;
			useItem.Type = newItem.type;
			useItem.setImageScale(34,34);
			look.Item = useItem;
			look.Grid.name = "inheritEquip_"+leftId.toString()+"_"+rightId.toString();
			Inherit.addChild(useItem);
			
			var newColor:int = item1.color>item2.color?item1.color:item2.color;
			Inherit.txtLookName.htmlText="<font color='"+ForgeData.equipColorList[newColor]+"'>"+"【"+ForgeData.equipStarList[this.newItem.star]+"】"+this.newItem.itemName+"+"+this.newItem.level+"</font>";
			useId = 400;
			Inherit.txtMoney.text = ForgeData.forgeCommDataList[useId].inheritMoney;			
		}
		
		/** 清除选中装备 */
		private function clearEquip1():void
		{
			//显示选中装备
			if(equip1.Item != null)
			{
				equip1.Item.reset();
				equip1.Item.gc();
				if(Inherit.contains(equip1.Item as UseItem))
				{
					Inherit.removeChild(equip1.Item as UseItem);
				}
				equip1.Item = null;
				equip1.Grid.name = "instance_equip1";
				(equip1.Grid as MovieClip).removeEventListener(MouseEvent.CLICK,onLeftGridClick);
				Inherit.txtEquipName_1.text = "";
			}
		}
		
		private function clearEquip2():void
		{
			if(equip2.Item != null)
			{
				equip2.Item.reset();
				equip2.Item.gc();
				if(Inherit.contains(equip2.Item as UseItem))
				{
					Inherit.removeChild(equip2.Item as UseItem);
				}
				equip2.Item = null;
				equip2.Grid.name = "instance_equip2";
				(equip2.Grid as MovieClip).removeEventListener(MouseEvent.CLICK,onRightGridClick);
				Inherit.txtEquipName_2.text = "";
			}
		}
		
		private function clearMaterial():void
		{
			if(Material.Item != null)
			{
				Material.Item.reset();
				Material.Item.gc();
				if(Inherit.contains(Material.Item as UseItem))
				{
					Inherit.removeChild(Material.Item as UseItem);
				}
				Material.Grid.name = "instance_Material";
				Material.Item = null;
			}
		}
		
		private function clearLook():void
		{
			if(look.Item != null)
			{
				look.Item.reset();
				look.Item.gc();
				if(Inherit.contains(look.Item as UseItem))
				{
					Inherit.removeChild(look.Item as UseItem);
				}
				look.Grid.name = "instance_look";
				look.Item = null;
				Inherit.txtLookName.text = "";
			}
		}
		
		private function onBtnClick(e:MouseEvent):void
		{
			//按钮事件
			if(equip1.Item!=null && equip2.Item!=null/* && Material.Item != null*/)
			{
				var param:Array=[1,equip1.Item.Id,91,equip2.Item.Id,0];
				EquipSend.createMsgCompound(param);
			}
		}
		
		private function onLeftGridClick(e:MouseEvent):void
		{
			//取下装备事件
			var index:int = equip1.Grid.name.split("_")[2];
			ForgeData.forgeEquipGridList[index].Grid.filters=filterDic[index];
			ForgeData.forgeEquipGridList[index].Grid.mouseEnabled = true;
			ForgeData.forgeEquipGridList[index].Grid.mouseChildren = true;
			var item:Object = ForgeData.forgeEquipGridList[index];
			delete ForgeData.selectIdArray[item.Item.Id];
			filterDic[index] = null;
			
			this.clearEquip1();
			this.clearLook();
			this.clearMaterial();
		}
		
		private function onRightGridClick(e:MouseEvent):void
		{
			//取下装备事件
			var index:int = equip2.Grid.name.split("_")[2];
			ForgeData.forgeEquipGridList[index].Grid.filters=filterDic[index];
			ForgeData.forgeEquipGridList[index].Grid.mouseEnabled = true;
			ForgeData.forgeEquipGridList[index].Grid.mouseChildren = true;
			var item:Object = ForgeData.forgeEquipGridList[index];
			delete ForgeData.selectIdArray[item.Item.Id];
			filterDic[index] = null;
			
			this.clearEquip2();
			this.clearLook();
			this.clearMaterial();
		}
		
		/** 创建UseItem实例 */
		protected function getCells(pos:int, icon:String, parent:DisplayObjectContainer):UseItem{
			
			var useItem:UseItem=this.cacheCells.shift();
			useItem=new UseItem(pos,icon,parent);
			return useItem;
		}
	}
}