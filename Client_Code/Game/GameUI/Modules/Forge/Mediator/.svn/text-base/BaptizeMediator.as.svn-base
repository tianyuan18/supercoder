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
	import GameUI.UIUtils;
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
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class BaptizeMediator extends Mediator
	{
		public static const NAME:String = "BaptizeMediator";
		private var panelBase:PanelBase;
		private var parentView:MovieClip;
		private var cacheCells:Array=[];
		
		private var equip:GridUnit = null;
		private var material:GridUnit = null;
		private var timer:Timer;
				
		private var item:Object = null;
		
		private var useId:int = 0;//存放配置文件物品ID
//		private var useItem:UseItem = null;
		private var baptizeFilter:Array = null;
		private var _nRed:Number=0.3086;
		private var _nGreen:Number=0.6094;
		private var _nBlue:Number=0.0820;
		
		private var lastIndex:int = -1;
		private var laseFilter:Array = null;
		
		public function BaptizeMediator(parentMc:MovieClip)
		{
			parentView = parentMc;
			super(NAME);
		}
		
		public function get Baptize():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				ForgeEvent.INIT_FORGE_UI,
				ForgeEvent.SHOW_FORGE_BAPTIZE_UI,					//打开宠物装备
				ForgeEvent.SELECT_ITEM_ONMOUSEDOWN,
				ForgeEvent.UPDATE_SELECT_ITEM,
				ForgeEvent.LOCK_BAPTIZE_ATTRIBUTE,
				EventList.UPDATEMONEY,
				ForgeEvent.CLOSE_FORGE_BAPTIZE_UI					//关闭宠物装备
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			var index:int;
			switch(notification.getName())
			{
				case ForgeEvent.INIT_FORGE_UI:
					this.setViewComponent(ForgeData.loadswfTool.GetResource().GetClassByMovieClip("Baptize"));
					this.Baptize.mouseEnabled=false;
					timer = new Timer(500, 1);
					Baptize.x = 0;
					Baptize.y = 27;
					break;
				case ForgeEvent.SHOW_FORGE_BAPTIZE_UI:
					ForgeData.selectItem = null;
					registerView();
					initData();
					parentView.addChild(Baptize);
					break;
				case ForgeEvent.CLOSE_FORGE_BAPTIZE_UI:
					retrievedView();
					parentView.removeChild(Baptize);
					break;
				case ForgeEvent.SELECT_ITEM_ONMOUSEDOWN:
					if(ForgeData.curPage == 1)
					{
						showEquip(notification.getBody() as int);
						this.onSelectEquip(notification.getBody() as int);
					}
					break;
				case ForgeEvent.UPDATE_SELECT_ITEM:
					if(ForgeData.curPage == 1)
					{
						var id:int = notification.getBody() as int;
						index= ForgeData.getIndexById(id);
						facade.sendNotification(ForgeEvent.SELECT_ITEM_ONMOUSEDOWN,index);
//						if(ForgeData.selectItem == null || id != ForgeData.selectItem.Item.Id) return;
//						this.showEquipInfo(id);
						
					}
					break;
				case ForgeEvent.LOCK_BAPTIZE_ATTRIBUTE:
					if(ForgeData.selectBaptizeIndex == -1)return;
					index = ForgeData.selectBaptizeIndex;
					if(ForgeData.AddLockList[index] == 0)//未锁定
					{
						(Baptize["select_"+index.toString()] as MovieClip).gotoAndStop(2);
						Baptize["txtLock_"+index.toString()].htmlText = "已锁";
						ForgeData.AddLockList[index] = 1;
					}else
					{
						(Baptize["select_"+index.toString()] as MovieClip).gotoAndStop(1);
						Baptize["txtLock_"+index.toString()].htmlText = "未锁定";
						ForgeData.AddLockList[index] = 0;
					}
					
					break;
				case EventList.UPDATEMONEY:															//更新钱
					
					switch (notification.getBody().target){
						case "mcUnBind"://copper
							Baptize.TipsInfo.copper.text = notification.getBody().money;
							break;
						case "mcBind"://copperBind
							Baptize.TipsInfo.copperBind.text = notification.getBody().money;
							break;
						case "mcRmb"://gold
							Baptize.TipsInfo.gold.text = notification.getBody().money;
							break;
						case "mcBindRmb"://goldBind
							Baptize.TipsInfo.goldBind.text = notification.getBody().money;
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
			
			Baptize.TipsInfo.copper.text = GameCommonData.Player.Role.UnBindMoney;
			Baptize.TipsInfo.copperBind.text = GameCommonData.Player.Role.BindMoney;
			Baptize.TipsInfo.gold.text = GameCommonData.Player.Role.UnBindRMB;
			Baptize.TipsInfo.goldBind.text = GameCommonData.Player.Role.BindRMB;
		}
		
		private function registerView():void
		{
			//初始化素材事件
			Baptize.btnBaptize.addEventListener(MouseEvent.CLICK,onBtnClick);
			(Baptize.btnName as MovieClip).mouseEnabled = false;
			(Baptize.btnName as MovieClip).mouseChildren = false;
			this.baptizeFilter = Baptize.btnBaptize.filters;
			Baptize.btnBaptize.filters = [new ColorMatrixFilter([_nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, 0, 0, 0, 1, 0])];
//			Baptize.btnBaptize.mouseEnabled = false;
			
			var gridUnit:MovieClip = ForgeData.loadswfTool.GetResource().GetClassByMovieClip("BigGrid");
			gridUnit.x = Baptize.equip.x;
			gridUnit.y = Baptize.equip.y;
			Baptize.addChild(gridUnit);
			equip = new GridUnit(gridUnit, true);//选中装备
			equip.parent = Baptize;									//设置父级
			equip.Item	= null;										//格子的物品
			
			gridUnit = ForgeData.loadswfTool.GetResource().GetClassByMovieClip("GridUnit");
			gridUnit.x = Baptize.Material.x;
			gridUnit.y = Baptize.Material.y;
			Baptize.addChild(gridUnit);
			material = new GridUnit(gridUnit, true);//选中装备
			material.parent = Baptize;									//设置父级
			material.Item	= null;										//格子的物品
			
			Baptize.txtAlert.text = "";
			Baptize.txtMoney.text = "0";
			Baptize.txtMaterial.text = "";
			for(var i:int; i<5; i++)
			{
				Baptize["txtAdd_"+i.toString()].htmlText = "";
				(Baptize["select_"+i.toString()] as MovieClip).visible = false;
				Baptize["txtLock_"+i.toString()].htmlText = "";
			}
		}
		
		private function retrievedView():void
		{
			//释放素材事件
			Baptize.btnBaptize.removeEventListener(MouseEvent.CLICK,onBtnClick);
			clearEquip();
			clearMaterial();
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
			ForgeData.selectIdArray[ForgeData.selectItem.Item.Id] = ForgeData.selectItem.Item.Id;
			lastIndex = index;
		}
		
		private function onSelectClick(e:MouseEvent):void
		{
			//“锁”事件
			if(item==null)return;
			var param:Array = null;
			var i:int = (e.currentTarget.name as String).split("_")[1];
			if(ForgeData.AddLockList[i] == 0)//未锁定
			{
//				(Baptize["select_"+i.toString()] as MovieClip).gotoAndStop(2);
//				Baptize["txtLock_"+i.toString()].htmlText = "已锁";
//				ForgeData.AddLockList[i] = 1;
				ForgeData.selectBaptizeIndex = i;
				param=[1,i,105,item.id,1];
				EquipSend.createMsgCompound(param);
			}else
			{
//				(Baptize["select_"+i.toString()] as MovieClip).gotoAndStop(1);
//				Baptize["txtLock_"+i.toString()].htmlText = "未锁定";
//				ForgeData.AddLockList[i] = 0;
				ForgeData.selectBaptizeIndex = i;
				param=[1,i,105,item.id,0];
				EquipSend.createMsgCompound(param);
			}
			
		}
		
		/** 显示选中装备 
		 *  index 表示在右边装备栏的位置
		 * */
		private function showEquip(index:int=0):void
		{
			//显示选中装备
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
			if(item == null || item.color<2)
			{
				
			}
//			if(equip.Item != null && equip.Item.Id == item.id)return;
			
			if(equip.Item != null &&equip.Item.Id==item.id)
			{
				//同一个物品更新属性不需要清理锁
				
			}else
			{
				clearBaptizeLock();
			}
			
			var param:Array=[1,0,106,item.id,0];
			EquipSend.createMsgCompound(param);
			
			var useItem:UseItem = this.getCells(item.index, item.type, Baptize);
			useItem.x = equip.Grid.x+2;
			useItem.y = equip.Grid.y+2;
			useItem.Id = item.id;
			useItem.IsBind = item.isBind;
			useItem.Type = item.type;
			useItem.setImageScale(48,48);
			clearEquip();
			equip.Item = useItem;
			equip.Grid.name = "bag_" + item.index.toString() +"_"+ index.toString();
			equip.Grid.mouseChildren = false;
			equip.Grid.addEventListener(MouseEvent.CLICK,onUnEquip);
			Baptize.addChild(equip.Item as UseItem);
			this.clearMaterial();
			showEquipInfo(item.id);
			if(showMaterial(item.id))
			{
				Baptize.btnBaptize.filters = this.baptizeFilter;
				Baptize.btnBaptize.mouseEnabled = true;
			}
			else
			{
				Baptize.btnBaptize.filters = [new ColorMatrixFilter([_nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, 0, 0, 0, 1, 0])];
//				Baptize.btnBaptize.mouseEnabled = false;
			}
		}
		
		/** 卸载装备 */
		private function onUnEquip(e:MouseEvent):void
		{
			this.clearEquip();
			this.clearMaterial();
			this.clearBaptizeLock();
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
		
		/** 清除洗炼锁信息 */
		private function clearBaptizeLock():void
		{
			ForgeData.selectBaptizeIndex = -1;
			for(var i:int=0;i<ForgeData.AddLockList.length;i++)
			{
				ForgeData.AddLockList[i] = 0;
				Baptize["txtAdd_"+i.toString()].htmlText = "";
				(Baptize["select_"+i.toString()] as MovieClip).visible = false;
				Baptize["txtLock_"+i.toString()].htmlText = "";
			}
		}
		
		/** 清除选中装备 */
		private function clearEquip():void
		{
			//显示选中装备

			if(equip.Item == null)return;
			equip.Item.reset();
			equip.Item.gc();
			if(Baptize.contains(equip.Item as UseItem))
			{
				Baptize.removeChild(equip.Item as UseItem);
			}
			equip.Item = null;
			
		}
		private function clearMaterial():void
		{
			if(this.material.Item == null)return;
			this.material.Item.reset();
			this.material.Item.gc();
			if(Baptize.contains(this.material.Item as UseItem))
			{
				Baptize.removeChild(this.material.Item as UseItem);
			}
			this.material.Grid.name = "instance_equip";
			this.material.Item = null;
			
			Baptize.txtMoney.text = "0";
		}
		
		/** 显示基本属性 */
		private function showEquipInfo(id:int):void
		{
			item = IntroConst.ItemInfo[id];
			
			for(var j:int; j<5; j++)
			{
				Baptize["txtAdd_"+j.toString()].htmlText = "";
				(Baptize["select_"+j.toString()] as MovieClip).visible = false;
				Baptize["txtLock_"+j.toString()].htmlText = "";
			}
			
			if(item)
			{
//				item.addAtt = ["10120","50121","90122","100123","10124"];
				if(item.addAtt) {
					for(var i:int = 0; i<item.addAtt.length; i++)
					{
						if(item.addAtt[i] != 0)
						{
							if(int(item.addAtt[i] % 10000) != 0)
							{
								var starStr:String = "";
								var starTmp:String = IntroConst.AttDic[int(item.addAtt[i] / 10000)-1] + "：+" + int(item.addAtt[i] % 10000);
								if(item.star && item.star > 0) {
									starTmp = UIUtils.textfillWithSpace(starTmp, 20);
									var starAdd:int = int(item.addAtt[i] % 10000) - int((Number(item.addAtt[i] % 10000) / IntroConst.STARS_INCREMENT[item.star].str).toFixed(0));
									if(starAdd == 0) starAdd = 1;
									starStr = "<font color='" + IntroConst.STARS_INCREMENT[item.star].color + "'>(+" + starAdd  + ")</font>"
								}
								Baptize["txtAdd_"+i.toString()].htmlText = starTmp;
								
								if(ForgeData.AddLockList[i] == 0)
								{
									(Baptize["select_"+i.toString()] as MovieClip).gotoAndStop(1);
									(Baptize["select_"+i.toString()] as MovieClip).visible = true;
									(Baptize["select_"+i.toString()] as MovieClip).addEventListener(MouseEvent.CLICK,onSelectClick);
									Baptize["txtLock_"+i.toString()].htmlText = "未锁定";
								}else
								{
									(Baptize["select_"+i.toString()] as MovieClip).gotoAndStop(2);
									(Baptize["select_"+i.toString()] as MovieClip).visible = true;
									(Baptize["select_"+i.toString()] as MovieClip).addEventListener(MouseEvent.CLICK,onSelectClick);
									Baptize["txtLock_"+i.toString()].htmlText = "已锁";
								}
							}
						}
					}
				}
				useId = 300+int(this.item.color)-2;
				Baptize.txtMoney.text = ForgeData.forgeCommDataList[useId].baptizeMoney;
			}
		}
		
		/** 显示需要材料 */
		private function showMaterial(id:int):Boolean
		{
			this.item = IntroConst.ItemInfo[id];
			if(this.item == null)
			{
				this.item = RolePropDatas.getRoleItemById(id);
			}
			if(item)
			{
				var color:int = item.color;
				var fastBuyList:Array = new Array();
				var good:Object = null;
				
				var stone:Object = null;
				switch(color)
				{
					case 1://白色
						break;
					case 2://绿色
						stone = UIConstData.ItemDic_1[ForgeData.stoneList[0]];//暂时从数据表里查找，应该从背包查找
//						stone = BagData.getItemByType(ForgeData.stoneList[0]);
						break;
					case 3://蓝色
						stone = UIConstData.ItemDic_1[ForgeData.stoneList[1]];
//						item = BagData.getItemByType(ForgeData.stoneList[1]);
						break;
					case 4://紫色
						stone = UIConstData.ItemDic_1[ForgeData.stoneList[2]];
//						item = BagData.getItemByType(ForgeData.stoneList[2]);
						break;
					case 5://橙色
						stone = UIConstData.ItemDic_1[ForgeData.stoneList[3]];
//						item = BagData.getItemByType(ForgeData.stoneList[3]);
						break;
					
				}
				
				if(stone == null)return false;
				var useItem:UseItem = this.getCells(0, stone.type, Baptize);
				useItem.x = Baptize.Material.x+2;
				useItem.y = Baptize.Material.y+2;
				useItem.Id = stone.id;
				useItem.IsBind = stone.isBind;
				useItem.Type = stone.type;
				useItem.setImageScale(34,34);
				clearMaterial();
				material.Item = useItem;
				material.Grid.name = "Decompose_"+stone.type;
				
				Baptize.addChild(material.Item as UseItem);
				
				var count:int = BagData.hasItemNum(stone.type);
				
				good = new Object();
				good.type = stone.type;
				good.name = stone.Name;
				good.num = count;
				fastBuyList.push(good);
				
				facade.sendNotification(ForgeEvent.UPDATE_ITEM_FASTBUY,{data:fastBuyList});

				if(count==0)
				{
					material.Item.filters = [new ColorMatrixFilter([_nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, 0, 0, 0, 1, 0])];
					return false;
				}
				else
				{
					Baptize.txtMaterial.text = count+"/1";
					return true;
				}
				
			}
			else
			{
				return false;
			}
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
			if(timer.running) {
//				facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_pet_med_petp_han_3" ], color:0xffff00});  // 5秒后才可以再让宠物出战
				return;
			}
			if(item)
			{
				var param:Array=[1,0,104,item.id,0];
				EquipSend.createMsgCompound(param);
				timer.reset();
				timer.start();
			}
		}
	}
}