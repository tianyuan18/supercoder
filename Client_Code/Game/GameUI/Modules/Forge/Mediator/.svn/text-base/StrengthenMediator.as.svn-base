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
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class StrengthenMediator extends Mediator
	{
		public static const NAME:String = "StrengthenMediator";
		private var panelBase:PanelBase;
		private var parentView:MovieClip;
		private var cacheCells:Array=[];
		
		private var equip:GridUnit = null;
		private var Material_1:GridUnit = null;
		private var Material_2:GridUnit = null;
		
		private var item:Object = null;
		private var newItem:Object = null;
		private var delayNum:Number = 0;
		private var timer:Timer;
		private var btnStrengthFilter:Array = null;
		private var Material_1Filter:Array = null;
		private var Material_2Filter:Array = null;
		
		private var _nRed:Number=0.3086;
		private var _nGreen:Number=0.6094;
		private var _nBlue:Number=0.0820;
		
		private var useId:int = 0; //查询配置表ID
		
		private var lastIndex:int = -1;
		private var laseFilter:Array = null;
		
		public function StrengthenMediator(parentMc:MovieClip)
		{
			parentView = parentMc;
			super(NAME);
		}
		
		public function get Strengthen():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				ForgeEvent.INIT_FORGE_UI,
				ForgeEvent.SHOW_FORGE_STRENGTHEN_UI,					//打开宠物装备
				ForgeEvent.SELECT_ITEM_ONMOUSEDOWN,						//选中物品事件
				ForgeEvent.UPDATE_SELECT_ITEM,
				EventList.UPDATEMONEY,
				ForgeEvent.CLOSE_FORGE_STRENGTHEN_UI					//关闭宠物装备
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ForgeEvent.INIT_FORGE_UI:
//					facade.sendNotification(EventList.GETRESOURCE, {type:UIConfigData.MOVIECLIP, mediator:this, name:"Strengthen"});
					this.setViewComponent(ForgeData.loadswfTool.GetResource().GetClassByMovieClip("Strengthen"));
					this.Strengthen.mouseEnabled=false;
					timer = new Timer(500, 1);
//					Strengthen.x = 0;
					Strengthen.y = 27;
					break;
				case ForgeEvent.SHOW_FORGE_STRENGTHEN_UI:
					ForgeData.selectItem = null;
					
					registerView();
					initData();
					parentView.addChild(Strengthen);
					break;
				case ForgeEvent.CLOSE_FORGE_STRENGTHEN_UI:
					retrievedView();
					parentView.removeChild(Strengthen);
					break;
				case ForgeEvent.SELECT_ITEM_ONMOUSEDOWN:
					if(ForgeData.curPage == 0)
					{
						if(ForgeData.selectItem!=null)
						{
							var tmpItem:Object = IntroConst.ItemInfo[ForgeData.selectItem.Item.Id];
							if(tmpItem == null)return;
							if(tmpItem.level<12)
							{
								clearEquip();
								this.clearMaterial1();
								this.clearMaterial2();
								this.clearInfo();
								
								showEquip(notification.getBody() as int);
								this.onSelectEquip(notification.getBody() as int);
							}
							else
							{
								clearEquip();
								this.clearMaterial1();
								this.clearMaterial2();
								this.clearInfo();
								this.item = null;
								
								this.onSelectEquip(notification.getBody() as int);
								ForgeData.selectItem = ForgeData.lastsItem;
							}	
						}
						
					}
					break;
				case ForgeEvent.UPDATE_SELECT_ITEM:
					if(ForgeData.curPage == 0)
					{	
						var id:int = notification.getBody() as int;
						var index:int= ForgeData.getIndexById(id);
						facade.sendNotification(ForgeEvent.SELECT_ITEM_ONMOUSEDOWN,index);
						
//						if(ForgeData.selectItem == null || id != ForgeData.selectItem.Item.Id) return;
//						var reItem:Object = IntroConst.ItemInfo[id];
//						if(reItem.level<12)
//						{
//							this.clearInfo();
//							this.showEquipInfo(id);
//						}
//						else
//						{
//							this.clearEquip();
//							this.clearInfo();
//							this.clearMaterial1();
//							this.clearMaterial2();
//						}
					}
					break;
				case EventList.UPDATEMONEY:															//更新钱
					
					switch (notification.getBody().target){
						case "mcUnBind"://copper
							Strengthen.TipsInfo.copper.text = notification.getBody().money;
							break;
						case "mcBind"://copperBind
							Strengthen.TipsInfo.copperBind.text = notification.getBody().money;
							break;
						case "mcRmb"://gold
							Strengthen.TipsInfo.gold.text = notification.getBody().money;
							break;
						case "mcBindRmb"://goldBind
							Strengthen.TipsInfo.goldBind.text = notification.getBody().money;
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
			
			Strengthen.TipsInfo.copper.text = GameCommonData.Player.Role.UnBindMoney;
			Strengthen.TipsInfo.copperBind.text = GameCommonData.Player.Role.BindMoney;
			Strengthen.TipsInfo.gold.text = GameCommonData.Player.Role.UnBindRMB;
			Strengthen.TipsInfo.goldBind.text = GameCommonData.Player.Role.BindRMB;
		}
		
		private function registerView():void
		{
			//初始化素材事件
			var gridUnit:MovieClip = ForgeData.loadswfTool.GetResource().GetClassByMovieClip("BigGrid");
			gridUnit.x = Strengthen.equip.x;
			gridUnit.y = Strengthen.equip.y;
			Strengthen.addChild(gridUnit);
			equip = new GridUnit(gridUnit, true);//选中装备
			equip.parent = Strengthen;									//设置父级
			equip.Item	= null;										//格子的物品
			
			gridUnit = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
			gridUnit.x = Strengthen.Material_1.x;
			gridUnit.y = Strengthen.Material_1.y;
			Strengthen.addChild(gridUnit);
			Material_1 = new GridUnit(gridUnit, true); //材料1
			Material_1.parent = Strengthen;									//设置父级
			Material_1.Item	= null;										//格子的物品
			
			gridUnit = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
			gridUnit.x = Strengthen.Material_2.x;
			gridUnit.y = Strengthen.Material_2.y;
			Strengthen.addChild(gridUnit);
			Material_2 = new GridUnit(gridUnit, true);//材料2
			Material_2.parent = Strengthen;									//设置父级
			Material_2.Item	= null;										//格子的物品
			
			(Strengthen.btnStrong as SimpleButton).addEventListener(MouseEvent.CLICK,onBtnClick);
			btnStrengthFilter = (Strengthen.btnStrong as SimpleButton).filters;
			(Strengthen.btnStrong as SimpleButton).filters=[new ColorMatrixFilter([_nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, 0, 0, 0, 1, 0])];
//			(Strengthen.btnStrong as SimpleButton).mouseEnabled = false;
			(Strengthen.btnName as MovieClip).mouseEnabled = false;
			(Strengthen.btnName as MovieClip).mouseChildren = false;
			
			(Strengthen.mc_Lucky as MovieClip).gotoAndStop(1);
			
			Strengthen.txtCurAtrribute_0.text = "";
			Strengthen.txtNextAtrribute_0.text = "";
//			Strengthen.txtUpAtrribute_0.text = "";
			
			Strengthen.txtCurAtrribute_1.text = "";
			Strengthen.txtNextAtrribute_1.text = "";
//			Strengthen.txtUpAtrribute_1.text = "";
			
			Strengthen.txtCurAtrribute_2.text = "";
			Strengthen.txtNextAtrribute_2.text = "";
//			Strengthen.txtUpAtrribute_2.text = "";
			
			Strengthen.txtCurAtrribute_3.text = "";
			Strengthen.txtNextAtrribute_3.text = "";
//			Strengthen.txtUpAtrribute_3.text = "";
			
			Strengthen.txtStoneNum_0.text = "";
			Strengthen.txtStoneNum_1.text = "";
			
			Strengthen.txtStrengthenLev.text = "";
			Strengthen.txtShcoolLucky.text = "";
			Strengthen.txtVipLucky.text = "";
			Strengthen.txtLucky.text = "0/0";
			Strengthen.txtTotelLucky.text = "";
			
			Strengthen.txtMoney.text = "0";
			
			Strengthen.txtCurAtrribute.visible = false;
			Strengthen.txtNextAtrribute.visible = false;
		}
		
		private function retrievedView():void
		{
			//释放素材事件
			
			clearEquip();
			this.clearMaterial1();
			this.clearMaterial2();
			this.clearInfo();
			equip = null;
			Material_1 = null;
			Material_2 = null;
			item = null;
			newItem = null;
			Strengthen.btnStrong.removeEventListener(MouseEvent.CLICK,onBtnClick);
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
			if(item)
			{
				var useItem:UseItem = this.getCells(item.index, item.type, Strengthen);
				useItem.x = equip.Grid.x+2;
				useItem.y = equip.Grid.y+2;
				useItem.Id = item.id;
				useItem.IsBind = item.isBind;
				useItem.Type = item.type;
				useItem.setImageScale(48,48);
				this.clearEquip();
				equip.Item = useItem;
				equip.Grid.mouseChildren = false;
				if(index<ForgeData.countEquiped)
				{
					equip.Grid.name = "hero_" + item.position.toString()+"_"+index.toString();
				}
				else
				{
					equip.Grid.name = "bag_" + item.index.toString() +"_"+ index.toString();
				}
				
				equip.Grid.addEventListener(MouseEvent.CLICK,onUnEquip);
				Strengthen.addChild(useItem);
				
				showEquipInfo(item.id);
				if(showMaterial(item.id))
				{
					(Strengthen.btnStrong as SimpleButton).filters = btnStrengthFilter;
					(Strengthen.btnStrong as SimpleButton).mouseEnabled = true;
				}
				else
				{
					(Strengthen.btnStrong as SimpleButton).filters = [new ColorMatrixFilter([_nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, 0, 0, 0, 1, 0])];;
//					(Strengthen.btnStrong as SimpleButton).mouseEnabled = false;
				}
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
			var o:Object = ForgeData.selectItem;
			ForgeData.selectIdArray[ForgeData.selectItem.Item.Id] = ForgeData.selectItem.Item.Id;
			lastIndex = index;
		}
		
		/** 卸载装备 */
		private function onUnEquip(e:MouseEvent):void
		{
			this.clearEquip();
			this.clearInfo();
			this.clearMaterial1();
			this.clearMaterial2();
			//将选中状态清除，做相应逻辑
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
		
		/** 清除选中装备 */
		private function clearEquip():void
		{
			//显示选中装备

			if(equip.Item == null)return;
			equip.Item.reset();
			equip.Item.gc();
			if(Strengthen.contains(equip.Item as UseItem))
			{
				Strengthen.removeChild(equip.Item as UseItem);
			}
			equip.Grid.removeEventListener(MouseEvent.CLICK,onUnEquip);
			equip.Grid.name = "instance_equip";
			equip.Item = null;
		}
		
		private function clearMaterial1():void
		{
			if(Material_1.Item == null)return;
			Material_1.Item.reset();
			Material_1.Item.gc();
			if(Strengthen.contains(Material_1.Item as UseItem))
			{
				Strengthen.removeChild(Material_1.Item as UseItem);
			}
			Material_1.Grid.name = "instance_Material_1";
			Material_1.Item = null;
		}
		
		private function clearMaterial2():void
		{
			if(Material_2.Item == null)return;
			Material_2.Item.reset();
			Material_2.Item.gc();
			if(Strengthen.contains(Material_2.Item as UseItem))
			{
				Strengthen.removeChild(Material_2.Item as UseItem);
			}
			Material_2.Grid.name = "instance_Material_2";
			Material_2.Item = null;
		}
		
		private function clearInfo():void
		{
			Strengthen.txtCurAtrribute_0.text = "";
			Strengthen.txtNextAtrribute_0.text = "";
//			Strengthen.txtUpAtrribute_0.text = "";
			
			Strengthen.txtCurAtrribute_1.text = "";
			Strengthen.txtNextAtrribute_1.text = "";
//			Strengthen.txtUpAtrribute_1.text = "";
			
			Strengthen.txtCurAtrribute_2.text = "";
			Strengthen.txtNextAtrribute_2.text = "";
//			Strengthen.txtUpAtrribute_2.text = "";
			
			Strengthen.txtCurAtrribute_3.text = "";
			Strengthen.txtNextAtrribute_3.text = "";
//			Strengthen.txtUpAtrribute_3.text = "";
			Strengthen.txtStrengthenLev.text = "";
			
			Strengthen.txtStoneNum_0.text = "";
			Strengthen.txtStoneNum_1.text = "";
			
			Strengthen.txtCurAtrribute.visible = false;
			Strengthen.txtNextAtrribute.visible = false;
		}
		
		/** 显示需要材料 */
		private function showMaterial(id:int):Boolean
		{
			this.clearMaterial1();
			this.clearMaterial2();
			this.item = IntroConst.ItemInfo[id];
			if(this.item == null)
			{
				this.item = RolePropDatas.getRoleItemById(id);
			}
			
			if(item)
			{
				var fastBuyList:Array = new Array();
				var strengthenType:Array = new Array();//存放强化材料type
				var luckyType:Array = new Array();//存放强化材料type
				var strengthenList:Array = UIConstData.MarketGoodList[1];
//				var s:String = item.type;
//				var strengthLev:String = s.charAt(s.length-1);
				var strengthLev:String = item.level;
				var count:int = 0;
				var strengthenItem:Object = null;
				var luckyItem:Object = null;
				
				var good:Object = null;
				
				if(strengthLev == "12") return false;
				for(var i:int=0; i<strengthenList.length; i++)
				{
					if(strengthenList[i].type2 == 1 && strengthenList[i].type3 == strengthLev)
					{
						strengthenType.push(strengthenList[i]);
					}
					if(strengthenList[i].type2 == 2 && strengthenList[i].type3 == strengthLev)
					{
						luckyType.push(strengthenList[i]);
					}
				}
				
				

				if(luckyType.length > 0)
				{
//					if( BagData.isHasItem(luckyType[0]))
//					{
					count = BagData.hasItemNum(luckyType[0].type);
					//						count += BagData.hasItemNum(luckyType[1]);
					
					luckyItem = BagData.getItemByType(luckyType[0].type);
					if(luckyItem == null)
					{
						luckyItem = UIConstData.ItemDic_1[luckyType[0].type];
					}
//					}
					if(luckyItem)
					{
						var a:Object = UIConstData.ItemDic_1;
						Strengthen.txtStoneNum_1.text = count.toString() + "/1";
						
						var useItem2:UseItem = this.getCells(0, luckyItem.type, Strengthen);
						useItem2.x = Strengthen.Material_2.x+2;
						useItem2.y = Strengthen.Material_2.y+2;
						useItem2.Id = luckyItem.id;
						useItem2.IsBind = luckyItem.isBind;
						useItem2.Type = luckyItem.type;
						useItem2.setImageScale(34,34);
						//						this.clearMaterial2();
						
						Material_2.Item = useItem2;
						Material_2.Index = luckyItem.index;
						Material_2.Grid.name = "Decompose_"+luckyItem.type.toString();
						Strengthen.addChild(useItem2);
						
						Strengthen.txtStoneNum_1.text = BagData.hasItemNum(luckyItem.type)+"/"+ForgeData.forgeCommDataList[useId].runeNum;
						
						if(count == 0)
						{	
							Material_2.Item.filters=[new ColorMatrixFilter([_nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, 0, 0, 0, 1, 0])];
						}
						good = new Object();
						good.type = luckyItem.type;
						good.name = luckyItem.Name;
						good.num = count;
						fastBuyList.push(good);
					}
					
				}
				
				var vipRate:Number = 0;
				if(GameCommonData.Player.Role.VIP != 0)
				{
					vipRate = 0.2;
				}
				var schoolRate:Number = 0;
				if(GameCommonData.Player.Role.unityId != 0)
				{
					schoolRate = 0.2;
				}
				var baseRate:Number = ForgeData.forgeCommDataList[useId].rate/10000;
				Strengthen.txtVipLucky.text = vipRate*100+"%";
				Strengthen.txtShcoolLucky.text = schoolRate*100+"%";
				var totel:int = baseRate*(1+vipRate+schoolRate)*100>100?100:baseRate*(1+vipRate+schoolRate)*100
				Strengthen.txtTotelLucky.text = totel+"%";
				
				if(strengthenType.length > 0)
				{
//					if( BagData.isHasItem(strengthenType[0]))
//					{
					count = BagData.hasItemNum(strengthenType[0].type);
					//						count += BagData.hasItemNum(strengthenType[1]);
//					strengthenItem = BagData.getItemByType(strengthenType[0].type);
//					
//					if(strengthenItem == null)
//					{
						//							strengthenItem = BagData.getItemByType(strengthenType[1]);
						strengthenItem = UIConstData.ItemDic_1[strengthenType[0].type];
//					}
//					}
					if(strengthenItem)
					{
						Strengthen.txtStoneNum_0.text = count.toString() + "/1";
						
						var useItem1:UseItem = this.getCells(0, strengthenItem.type, Strengthen);
						useItem1.x = Strengthen.Material_1.x+2;
						useItem1.y = Strengthen.Material_1.y+2;
						useItem1.Id = strengthenItem.id;
						useItem1.IsBind = strengthenItem.isBind;
						useItem1.Type = strengthenItem.type;
						useItem1.setImageScale(34,34);
						//						this.clearMaterial1();
						
						Material_1.Item = useItem1;
						Material_1.Index = strengthenItem.index;
						Material_1.Grid.name = "Decompose_" + strengthenItem.type.toString();
						Strengthen.addChild(useItem1);
						
						//材料数量
						Strengthen.txtStoneNum_0.text = BagData.hasItemNum(strengthenItem.type)+"/"+ForgeData.forgeCommDataList[useId].stoneNum;
						
						good = new Object();
						good.type = strengthenItem.type;
						good.name = strengthenItem.Name;
						good.num = count;
						fastBuyList.push(good);
						
						facade.sendNotification(ForgeEvent.UPDATE_ITEM_FASTBUY,{data:fastBuyList});
						
						if(count == 0)
						{	
							//Material_1.Item.icon.filters=[new ColorMatrixFilter([_nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, 0, 0, 0, 1, 0])];
							Material_1.Item.filters=[new ColorMatrixFilter([_nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, 0, 0, 0, 1, 0])];
							return false;
						}
						else
						{
							return true;
						}
					}
				}
			}
			return false;
		}
		
		/** 显示基本属性 */
		private function showEquipInfo(id:int):void
		{
			this.item = IntroConst.ItemInfo[id];
			if(this.item == null)
			{
				this.item = RolePropDatas.getRoleItemById(id);
			}
			if(item)
			{
				var s:String = "";
				var baseNum:int = 0;
				var itemConstData:Object = UIConstData.ItemDic_1[item.type];
				Strengthen.txtStrengthenLev.text = "强化等级+"+item.level.toString();
				var lev:int = int(item.level);
				if(int(item.baseAtt1 % 10000) != 0)
				{
//					var a:Object = IntroConst.STENS_INCREMENT;
					var realStren1:String = IntroConst.AttDic[int(item.baseAtt1 / 10000)-1] + "：+" + int(item.baseAtt1 % 10000);

					Strengthen.txtCurAtrribute_0.text = realStren1;
					Strengthen.txtCurAtrribute.visible = true;
					//取基本数值/1.3的12-旧装备等级次方
					if(lev<12)
					{
						baseNum = int(itemConstData.BaseList[0]%10000);
						if(baseNum<25)
						{
							baseNum=25;
						}
						var num:Number = Math.pow(ForgeData.ratio,ForgeData.MAX_STRENGTH-item.level);
						Strengthen.txtNextAtrribute_0.text = IntroConst.AttDic[int(item.baseAtt1 / 10000)-1] + "：+" + (int(item.baseAtt1 % 10000)+int( baseNum/num)).toString();
						Strengthen.txtNextAtrribute.visible = true;
					}
					
				}
				
				if(int(item.baseAtt2 % 10000) != 0)
				{
					s = (int(item.baseAtt2 / 10000) == 28) ? "%" : ""; 
					var realStren2:String = IntroConst.AttDic[int(item.baseAtt2 / 10000)-1] + "：+" + int(item.baseAtt2 % 10000);

					Strengthen.txtCurAtrribute_1.text = realStren2;

					
					//取基本数值*1.3的12-旧装备等级次方
					if(lev<12)
					{
						baseNum = int(itemConstData.BaseList[1]%10000);
						if(baseNum<25)
						{
							baseNum=25;
						}
						
						Strengthen.txtNextAtrribute_1.text = IntroConst.AttDic[int(item.baseAtt2 / 10000)-1] + "：+" + (int(item.baseAtt2 % 10000)+int( baseNum/num)).toString();
						
					}
					
				}
				
				if(int(item.baseAtt3 % 10000) != 0)
				{
					s = (int(item.baseAtt3 / 10000) == 28) ? "%" : ""; 
					var realStren3:String = IntroConst.AttDic[int(item.baseAtt3 / 10000)-1] + "：+" + int(item.baseAtt3 % 10000);

					Strengthen.txtCurAtrribute_2.text = realStren3;

					
					//取基本数值*1.3的12-旧装备等级次方
					if(lev<12)
					{
						baseNum = int(itemConstData.BaseList[2]%10000);
						if(baseNum<25)
						{
							baseNum=25;
						}
						Strengthen.txtNextAtrribute_2.text = IntroConst.AttDic[int(item.baseAtt3 / 10000)-1] + "：+" + (int(item.baseAtt3 % 10000)+int( baseNum/num)).toString();
						
					}
					
				}
				
				if(int(item.baseAtt4 % 10000) != 0)
				{
					s = (int(item.baseAtt4 / 10000) == 28) ? "%" : ""; 
					var realStren4:String = IntroConst.AttDic[int(item.baseAtt4 / 10000)-1] + "：+" + int(item.baseAtt4 % 10000);

					Strengthen.txtCurAtrribute_3.text = realStren4;

					
					//取基本数值*1.3的12-旧装备等级次方
					if(lev<12)
					{
						baseNum = int(itemConstData.BaseList[3]%10000);
						if(baseNum<25)
						{
							baseNum=25;
						}
						Strengthen.txtNextAtrribute_3.text = IntroConst.AttDic[int(item.baseAtt4 / 10000)-1] + "：+" + (int(item.baseAtt4 % 10000)+int( baseNum/num)).toString();
						
					}
					
				}
				useId = 100+item.level;
				var a:Object = ForgeData.forgeCommDataList;
				Strengthen.txtMoney.text = ForgeData.forgeCommDataList[useId].stoneMoney;
			}
			else
			{
				setTimeout(showEquipInfo,100,id);
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
				return;
			}
			if(equip.Item && item)
			{
				var lev:int = item.level;
				if(lev<12)
				{
					trace("lev= "+lev);
					var param:Array = [1,0,62,item.id,0];
					EquipSend.createMsgCompound(param);
					timer.reset();
					timer.start();
				}
			}
		}
	}
}