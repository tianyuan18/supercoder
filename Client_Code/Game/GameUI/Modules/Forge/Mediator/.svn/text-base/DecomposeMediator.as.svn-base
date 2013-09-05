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
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class DecomposeMediator extends Mediator
	{
		public static const NAME:String = "DecomposeMediator";
		private var panelBase:PanelBase;
		private var parentView:MovieClip;
		private var cacheCells:Array=[];
		
		private var equipList:Array = new Array(12);
		private var MaterialList:Array = new Array(5);
		private var MaterialNumList:Array = [0,0,0,0,0];
		
		private var count:int = 0;//计算放入装备数
		
//		private var decomposeFilter:Array = null;//存放装备滤镜
		private var filterDic:Dictionary = null;//存放装备滤镜
		private var _nRed:Number=0.3086;
		private var _nGreen:Number=0.6094;
		private var _nBlue:Number=0.0820;	
		
		public function DecomposeMediator(parentMc:MovieClip)
		{
			parentView = parentMc;
			super(NAME);
		}
		
		public function get Decompose():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				ForgeEvent.INIT_FORGE_UI,
				ForgeEvent.SHOW_FORGE_DECOMPOSE_UI,					//打开宠物装备
				ForgeEvent.SELECT_ITEM_ONMOUSEDOWN,					//选中物品事件
				ForgeEvent.DECOMPOSE_SUCCESS,
				EventList.UPDATEMONEY,
				ForgeEvent.CLOSE_FORGE_DECOMPOSE_UI					//关闭宠物装备
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ForgeEvent.INIT_FORGE_UI:
					this.setViewComponent(ForgeData.loadswfTool.GetResource().GetClassByMovieClip("Decompose"));
					this.Decompose.mouseEnabled=false;
					Decompose.x = 0;
					Decompose.y = 27;
					break;
				case ForgeEvent.SHOW_FORGE_DECOMPOSE_UI:
					registerView();
					initData();
					parentView.addChild(Decompose);
					break;
				case ForgeEvent.CLOSE_FORGE_DECOMPOSE_UI:
					retrievedView();
					parentView.removeChild(Decompose);
					break;
				case ForgeEvent.SELECT_ITEM_ONMOUSEDOWN:
					if(ForgeData.curPage == 4)
					{
						showEquip(notification.getBody() as int);
						this.onSelectEquip(notification.getBody() as int);
					}
					break;
				case ForgeEvent.DECOMPOSE_SUCCESS:
					this.clearEquip();
					Decompose.txtMaterial_0.text = "0";
					Decompose.txtMaterial_1.text = "0";
					Decompose.txtMaterial_2.text = "0"; 
					Decompose.txtMaterial_3.text = "0"; 
					Decompose.txtMaterial_4.text = "0"; 
					break;
				case EventList.UPDATEMONEY:															//更新钱
					
					switch (notification.getBody().target){
						case "mcUnBind"://copper
							Decompose.TipsInfo.copper.text = notification.getBody().money;
							break;
						case "mcBind"://copperBind
							Decompose.TipsInfo.copperBind.text = notification.getBody().money;
							break;
						case "mcRmb"://gold
							Decompose.TipsInfo.gold.text = notification.getBody().money;
							break;
						case "mcBindRmb"://goldBind
							Decompose.TipsInfo.goldBind.text = notification.getBody().money;
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
			
			Decompose.TipsInfo.copper.text = GameCommonData.Player.Role.UnBindMoney;
			Decompose.TipsInfo.copperBind.text = GameCommonData.Player.Role.BindMoney;
			Decompose.TipsInfo.gold.text = GameCommonData.Player.Role.UnBindRMB;
			Decompose.TipsInfo.goldBind.text = GameCommonData.Player.Role.BindRMB;
		}
		
		private function registerView():void
		{
			//初始化素材事件
			Decompose.btnDecompose.addEventListener(MouseEvent.CLICK,onBtnClick);
//			decomposeFilter = Decompose.btnDecompose.filters;
//			Decompose.btnDecompose.filters=[new ColorMatrixFilter([_nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, 0, 0, 0, 1, 0])];
//			(Decompose.btnName as MovieClip).mouseEnabled = false;
//			(Decompose.btnName as MovieClip).mouseChildren = false;
//			Decompose.btnPutAll.visible = false;
			Decompose.txtMaterial_0.text = "0";
			Decompose.txtMaterial_1.text = "0";
			Decompose.txtMaterial_2.text = "0"; 
			Decompose.txtMaterial_3.text = "0"; 
			Decompose.txtMaterial_4.text = "0"; 
		}
		
		private function retrievedView():void
		{
			//释放素材事件
			Decompose.btnDecompose.removeEventListener(MouseEvent.CLICK,onBtnClick);
			clearEquip();
		}
		
		/** 装备选中变灰 */
		private function onSelectEquip(index:int):void
		{
			if(count > -1)
			{
				filterDic[index] = ForgeData.forgeEquipGridList[index].Grid.filters;
				ForgeData.forgeEquipGridList[index].Grid.filters=[new ColorMatrixFilter([_nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, 0, 0, 0, 1, 0])];
				
				ForgeData.forgeEquipGridList[index].Grid.mouseEnabled = false;
				ForgeData.forgeEquipGridList[index].Grid.mouseChildren = false;
				
				ForgeData.selectIdArray[ForgeData.selectItem.Item.Id] = ForgeData.selectItem.Item.Id;
			}
		}
		
		/** 加入选中装备 
		 *  index 装备在右边框中的位置
		 * */
		private function showEquip(index:int=0):void
		{
			count = getEquipIndex();
			if(count > -1)
			{
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
					if(item.color<1)return;
					if(this.isExist(item.id))return;
					
					
					var useItem:UseItem = this.getCells(item.index, item.type, Decompose);
					useItem.x = Decompose["equip_"+count.toString()].x+2;
					useItem.y = Decompose["equip_"+count.toString()].y+2;
					useItem.Id = item.id;
					useItem.IsBind = item.isBind;
					useItem.Type = item.type;
					useItem.setImageScale(34,34);
					Decompose.addChild(useItem);
					
					var gridUnit:MovieClip = ForgeData.loadswfTool.GetResource().GetClassByMovieClip("GridUnit");
					gridUnit.x = Decompose["equip_"+count.toString()].x;
					gridUnit.y = Decompose["equip_"+count.toString()].y;
					Decompose.addChild(gridUnit);
					var equip:GridUnit = new GridUnit(gridUnit, true);//选中装备
					equip.parent = Decompose;									//设置父级
					equip.Item = useItem;
					equip.Index = item.index;
					/**
					 * item.index.toString()物品在背包中的索引
					 * index.toString()物品有右边栏中的索引
					 * count 物品在左边栏中的索引
					 */ 
					if(index<ForgeData.countEquiped)
					{
						equip.Grid.name = "hero_" + item.position.toString()+"_"+count.toString()+"_"+index.toString();
					}
					else
					{
						equip.Grid.name = "bag_" + item.index.toString()+"_"+count.toString()+"_"+index.toString();
					}
					
					equip.Grid.addEventListener(MouseEvent.CLICK,onUnEquip);
					equipList[count] = equip;
					
					showMaterial(item.id);
				}
			}
		}
		
		private function getEquipIndex():int
		{
			for(var i:int=0;i<12; i++)
			{
				if(equipList[i])
				{
					continue;
				}
				else
				{
					return i;
				}
			}
			return -1;
		}
		
		private function onUnEquip(e:MouseEvent):void
		{
			var name:Array = e.currentTarget.name.split("_");
			this.clearEquipAtIndex(int(name[2]),int(name[3]));
		}
		
		private function showMaterial(id:int):void
		{
			/**
			 * item 装备对象
			 */
			var item:Object;
			item = IntroConst.ItemInfo[id];
			if(item == null)
			{
				item = RolePropDatas.getRoleItemById(id);
			}
			if(item)
			{
				var color:int = item.color;
				var useItem:UseItem = null;
				var gridUnit:MovieClip = null;
				var equip:GridUnit = null;
//				var type:int = 0;
				var count:int = 0;
				switch(color)
				{
					case 1://白色
						break;
					case 2://绿色
						trace("MaterialList[0]"+MaterialList[0]+"  ");
						if(MaterialList[0] == null)
						{
							item = UIConstData.ItemDic_1[ForgeData.stoneList[0]];
							if(item == null) return;
							useItem = this.getCells(item.index, item.type, Decompose);
							useItem.x = Decompose["Material_0"].x+2;
							useItem.y = Decompose["Material_0"].y+2;
							useItem.Id = item.id;
							useItem.IsBind = item.isBind;
							useItem.Type = item.type;
							useItem.setImageScale(34,34);
							Decompose.addChild(useItem);
							
							gridUnit = ForgeData.loadswfTool.GetResource().GetClassByMovieClip("GridUnit");
							gridUnit.x = Decompose["Material_0"].x;
							gridUnit.y = Decompose["Material_0"].y;
							Decompose.addChild(gridUnit);
							equip = new GridUnit(gridUnit, true);//选中装备
							equip.parent = Decompose;									//设置父级
							equip.Item = useItem;
							equip.Grid.name = "Decompose_" + ForgeData.stoneList[0];
							MaterialList[0] = equip;
						}
						this.MaterialNumList[0]++;
						Decompose.txtMaterial_0.text = this.MaterialNumList[0].toString();
						break;
					case 3://蓝色
						if(MaterialList[1] == null)
						{
							item = UIConstData.ItemDic_1[ForgeData.stoneList[1]];
							if(item == null) return;

							useItem = this.getCells(item.index, item.type, Decompose);
							useItem.x = Decompose["Material_1"].x+2;
							useItem.y = Decompose["Material_1"].y+2;
							useItem.Id = item.id;
							useItem.IsBind = item.isBind;
							useItem.Type = item.type;
							useItem.setImageScale(34,34);
							Decompose.addChild(useItem);
							
							gridUnit = ForgeData.loadswfTool.GetResource().GetClassByMovieClip("GridUnit");
							gridUnit.x = Decompose["Material_1"].x;
							gridUnit.y = Decompose["Material_1"].y;
							Decompose.addChild(gridUnit);
							equip = new GridUnit(gridUnit, true);//选中装备
							equip.parent = Decompose;									//设置父级
							equip.Item = useItem;
							equip.Grid.name = "Decompose_" + ForgeData.stoneList[1];
							MaterialList[1] = equip;
						}
						
						this.MaterialNumList[1]++;

						Decompose.txtMaterial_1.text = this.MaterialNumList[1].toString();
						break;
					case 4://紫色
						if(MaterialList[2] == null)
						{
							item = UIConstData.ItemDic_1[ForgeData.stoneList[2]];
							if(item == null) return;
							useItem = this.getCells(item.index, item.type, Decompose);
							useItem.x = Decompose["Material_2"].x+2;
							useItem.y = Decompose["Material_2"].y+2;
							useItem.Id = item.id;
							useItem.IsBind = item.isBind;
							useItem.Type = item.type;
							useItem.setImageScale(34,34);
							Decompose.addChild(useItem);
							
							gridUnit = ForgeData.loadswfTool.GetResource().GetClassByMovieClip("GridUnit");
							gridUnit.x = Decompose["Material_2"].x;
							gridUnit.y = Decompose["Material_2"].y;
							Decompose.addChild(gridUnit);
							equip = new GridUnit(gridUnit, true);//选中装备
							equip.parent = Decompose;									//设置父级
							equip.Item = useItem;
							equip.Grid.name = "Decompose_" + ForgeData.stoneList[2];
							MaterialList[2] = equip;
						}
						this.MaterialNumList[2]++;

						Decompose.txtMaterial_2.text = this.MaterialNumList[2].toString();
						break;
					case 5://橙色
						if(MaterialList[3] == null)
						{
							item = UIConstData.ItemDic_1[ForgeData.stoneList[3]];
							if(item == null) return;
							useItem = this.getCells(item.index, item.type, Decompose);
							useItem.x = Decompose["Material_3"].x+2;
							useItem.y = Decompose["Material_3"].y+2;
							useItem.Id = item.id;
							useItem.IsBind = item.isBind;
							useItem.Type = item.type;
							useItem.setImageScale(34,34);
							Decompose.addChild(useItem);
							
							gridUnit = ForgeData.loadswfTool.GetResource().GetClassByMovieClip("GridUnit");
							gridUnit.x = Decompose["Material_3"].x;
							gridUnit.y = Decompose["Material_3"].y;
							Decompose.addChild(gridUnit);
							equip = new GridUnit(gridUnit, true);//选中装备
							equip.parent = Decompose;									//设置父级
							equip.Item = useItem;
							equip.Grid.name = "Decompose_" + ForgeData.stoneList[3];
							MaterialList[3] = equip;
						}

						this.MaterialNumList[3]++;

						Decompose.txtMaterial_3.text = this.MaterialNumList[3].toString();
						break;
				}
				
				
			}

		}
		
		/** true表示存在，false表示不存在 */
		private function isExist(id:int):Boolean
		{
			for(var i:int=0; i<equipList.length; i++)
			{
				if(equipList[i] != null && equipList[i].Item.Id == id)
				{
					return true;
				}
			}
			return false;
		}
		
		/** 清除单个装备 
		 *  count 装备在左边栏索引
		 *  index 装备在右边栏中的索引
		 * */
		private function clearEquipAtIndex(count:int,index:int):void
		{
			var equip:GridUnit = equipList[count];
			if(equip != null && equip.Item != null)
			{
				clearMaterialAtIndex(equip.Item.Id);
				equip.Item.reset();
				equip.Item.gc();
				if(Decompose.contains(equip.Item as UseItem))
				{
					Decompose.removeChild(equip.Item as UseItem);
				}
				if(Decompose.contains(equip.Grid))
				{
					equip.Grid.removeEventListener(MouseEvent.CLICK,onUnEquip);
					Decompose.removeChild(equip.Grid);
				}
				equipList[count] = null;
				
				ForgeData.forgeEquipGridList[index].Grid.filters=filterDic[index];
				ForgeData.forgeEquipGridList[index].Grid.mouseEnabled = true;
				ForgeData.forgeEquipGridList[index].Grid.mouseChildren = true;
				var item:Object = ForgeData.forgeEquipGridList[index];
				delete ForgeData.selectIdArray[item.Item.Id];
				filterDic[index] = null;
			}
		}
		
		/** 清除单个材料 */
		private function clearMaterialAtIndex(id:int):void
		{
			var item:Object = IntroConst.ItemInfo[id];
			if(item)
			{
				var color:int = item.color;
				var equip:GridUnit = null;
				switch(color)
				{
					case 1://白
						break;
					case 2://绿
						if(MaterialNumList[0] != 0)MaterialNumList[0]--;//材料数量减1
						equip = MaterialList[0];
						if(MaterialNumList[0]==0)
						{
							if(equip != null && equip.Item != null)
							{
								equip.Item.reset();
								equip.Item.gc();
								if(Decompose.contains(equip.Item as UseItem))
								{
									Decompose.removeChild(equip.Item as UseItem);
								}
								if(Decompose.contains(equip.Grid))
								{
									Decompose.removeChild(equip.Grid);
								}
								equip = null;
							}
						}
						Decompose.txtMaterial_0.text = this.MaterialNumList[0].toString();
						break;
					case 3://蓝
						if(MaterialNumList[1] != 0)MaterialNumList[1]--;//材料数量减1
						equip = MaterialList[1];
						if(MaterialNumList[1]==0)
						{
							if(equip != null && equip.Item != null)
							{
								equip.Item.reset();
								equip.Item.gc();
								if(Decompose.contains(equip.Item as UseItem))
								{
									Decompose.removeChild(equip.Item as UseItem);
								}
								if(Decompose.contains(equip.Grid))
								{
									Decompose.removeChild(equip.Grid);
								}
								equip = null;
							}
						}
						Decompose.txtMaterial_1.text = this.MaterialNumList[1].toString();
						break;
					case 4://紫
						if(MaterialNumList[2] != 0)MaterialNumList[2]--;//材料数量减1
						equip = MaterialList[2];
						if(MaterialNumList[2]==0)
						{
							if(equip != null && equip.Item != null)
							{
								equip.Item.reset();
								equip.Item.gc();
								if(Decompose.contains(equip.Item as UseItem))
								{
									Decompose.removeChild(equip.Item as UseItem);
								}
								if(Decompose.contains(equip.Grid))
								{
									Decompose.removeChild(equip.Grid);
								}
								equip = null;
							}
						}
						Decompose.txtMaterial_2.text = this.MaterialNumList[2].toString();
						break;
					case 5://橙
						if(MaterialNumList[3] != 0)MaterialNumList[3]--;//材料数量减1
						equip = MaterialList[3];
						if(MaterialNumList[3]==0)
						{
							if(equip != null && equip.Item != null)
							{
								equip.Item.reset();
								equip.Item.gc();
								if(Decompose.contains(equip.Item as UseItem))
								{
									Decompose.removeChild(equip.Item as UseItem);
								}
								if(Decompose.contains(equip.Grid))
								{
									Decompose.removeChild(equip.Grid);
								}
								equip = null;
							}
						}
						Decompose.txtMaterial_3.text = this.MaterialNumList[3].toString();
						break;
				}
			}		
		}
		
		/** 清除所有装备装备 */
		private function clearEquip():void
		{
			for(var i:int=0; i<equipList.length; i++)
			{
				if(equipList[i] != null && equipList[i].Item != null)
				{
					equipList[i].Item.reset();
					equipList[i].Item.gc();
					if(Decompose.contains(equipList[i].Item))
					{
						Decompose.removeChild(equipList[i].Item);
					}
					if(Decompose.contains(equipList[i].Grid))
					{
						Decompose.removeChild(equipList[i].Grid);
					}
					equipList[i] = null;
				}
			}
			for(var j:int=0; j<5; j++)
			{
				if(MaterialList[j] != null)
				{
					MaterialList[j].Item.reset();
					MaterialList[j].Item.gc();
					if(Decompose.contains(MaterialList[j].Item))
					{
						Decompose.removeChild(MaterialList[j].Item);
					}
					MaterialList[j] = null;
				}
			}
			MaterialNumList = [0,0,0,0,0];
			count = 0;
		}
		
		/** 创建UseItem实例 */
		protected function getCells(pos:int, icon:String, parent:DisplayObjectContainer):UseItem{
			
			var useItem:UseItem=this.cacheCells.shift();
			useItem=new UseItem(pos,icon,parent);
			return useItem;
		}
		
		private function onBtnClick(e:MouseEvent):void
		{
			//按钮事件
			for(var i:int=0;i<equipList.length;i++)
			{
				if(equipList[i]==null || equipList[i].Item==null)return;
				
				var param:Array=[1,0,88,equipList[i].Item.Id,0];
				EquipSend.createMsgCompound(param);
			}
			
		}
	}
}