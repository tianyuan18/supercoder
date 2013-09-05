package GameUI.Modules.Mount.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Bag.Proxy.BagData;
	import GameUI.Modules.Bag.Proxy.GridUnit;
	import GameUI.Modules.Forge.Data.*;
	import GameUI.Modules.Maket.Data.MarketEvent;
	import GameUI.Modules.Mount.MountData.*;
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
	import flash.utils.Timer;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class MountStrongMediator extends Mediator
	{
		public static const NAME:String = "MountStrongMediator";
		private var panelBase:PanelBase;
		private var parentView:MovieClip;
		private var useItem:UseItem = null;
		
		private var Material_1:GridUnit = null;
		private var Material_2:GridUnit = null;
		
		private var Material_1Filter:Array = null;
		private var Material_2Filter:Array = null;
		
		private var _nRed:Number=0.3086;
		private var _nGreen:Number=0.6094;
		private var _nBlue:Number=0.0820;
		
		private var timer:Timer;
		
		private var cacheCells:Array=[];
		private var useId:int = 0; //查询配置表ID
		
		public var isAutoBuy:int = 1;
		
		public function MountStrongMediator(parentMc:MovieClip)
		{
			parentView = parentMc;
			super(NAME);
		}
		
		public function get MountStrong():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				MountEvent.INIT_MOUNT_UI,
				MountEvent.OPEN_MOUNT_STRONG,					//打开宠物装备
				MountEvent.CLOSE_MOUNT_STRONG					//关闭宠物装备
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case MountEvent.INIT_MOUNT_UI:
//					facade.sendNotification(EventList.GETRESOURCE, {type:UIConfigData.MOVIECLIP, mediator:this, name:"MountStronger"});
					this.setViewComponent(MountData.loadswfTool.GetResource().GetClassByMovieClip("MountStronger"));
					this.MountStrong.mouseEnabled=false;
					timer = new Timer(1000, 1);
					break;
				case MountEvent.OPEN_MOUNT_STRONG:
					registerView();
					if(MountData.SelectedMount)
					{
						initData();
					}
					MountStrong.x = 4;
					MountStrong.y = 27;
					parentView.addChild(MountStrong);
					break;
				case MountEvent.CLOSE_MOUNT_STRONG:
					retrievedView();
					parentView.removeChild(MountStrong);
					break;
				
				case MountEvent.UPDATE_MOUNT_DISPLAY:
					break;
			}
		}
		
		private function initData():void
		{
			//获取宠物数据
			useItem=new UseItem(0,MountData.SelectedMount.type,MountStrong);
			useItem.x = 2;
			useItem.y = 2;
//			useItem.Id = mountItem.id;
			useItem.Type = MountData.SelectedMount.type;
			useItem.setImageScale(48,48);
			MountStrong.mc_Display.addChild(useItem);
			
			showMaterial(MountData.SelectedMount.id);
		}
		
		private function registerView():void
		{
			//初始化素材事件
//			(MountStrong.btnUp as MovieClip).gotoAndStop(1);
//			(MountStrong.btnDown as MovieClip).gotoAndStop(1);
			(MountStrong.AutoBuy as MovieClip).gotoAndStop(2);
			(MountStrong.AutoBuy as MovieClip).addEventListener(MouseEvent.CLICK,onChangeBuyType);
			(MountStrong.bind as MovieClip).gotoAndStop(2);
			(MountStrong.bind as MovieClip).addEventListener(MouseEvent.CLICK,onChangeBuyType);
//			MountStrong.btnBuy.addEventListener(MouseEvent.CLICK,onSelectBtn);
			MountStrong.btnStrong.addEventListener(MouseEvent.CLICK,onSelectBtn);
			(MountStrong.btnName as MovieClip).mouseEnabled = false;
			(MountStrong.btnName as MovieClip).mouseChildren = false;
			MountStrong.StrongLevel.text = "";
//			MountStrong.txtBase.text = "";
//			MountStrong.txtVIP.text = "";
//			MountStrong.txtFaction.text = "";
			MountStrong.txtAll.text = "";
			MountStrong.txtNeedPrice.text = "0";
//			MountStrong.txtLeftNum.text = "0";
//			MountStrong.txtRightNum.text = "0";
//			MountStrong.txtStoneNum.text = "0";
			
			var gridUnit:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
			gridUnit.x = MountStrong.mc_Left.x;
			gridUnit.y = MountStrong.mc_Left.y;
			MountStrong.addChild(gridUnit);
			Material_1 = new GridUnit(gridUnit, true); //材料1
			Material_1.parent = MountStrong;									//设置父级
			Material_1.Item	= null;										//格子的物品
			
			gridUnit = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
			gridUnit.x = MountStrong.mc_Right.x;
			gridUnit.y = MountStrong.mc_Right.y;
			MountStrong.addChild(gridUnit);
			Material_2 = new GridUnit(gridUnit, true);//材料2
			Material_2.parent = MountStrong;									//设置父级
			Material_2.Item	= null;										//格子的物品
			
			MountStrong.stoneBuy.visible = false;
			MountStrong.materialBuy.visible = false;
		}
		
		private function retrievedView():void
		{
			//释放素材事件
			if(useItem && (MountStrong.mc_Display as MovieClip).contains(useItem))
			{
				MountStrong.mc_Display.removeChild(useItem);
				useItem.reset();
				useItem.gc();
				useItem = null;
			}
			
			this.clearMaterial1();
			this.clearMaterial2();
			
			Material_1 = null;
			Material_2 = null;
			
			(MountStrong.AutoBuy as MovieClip).removeEventListener(MouseEvent.CLICK,onChangeBuyType);
			(MountStrong.bind as MovieClip).removeEventListener(MouseEvent.CLICK,onChangeBuyType);
		}
		
		/** 显示需要材料 */
		private function showMaterial(id:int):Boolean
		{
			this.clearMaterial1();
			this.clearMaterial2();
			var item:Object = IntroConst.ItemInfo[id];
			
			if(item)
			{
				MountStrong.stoneBuy.visible = true;
				MountStrong.materialBuy.visible = true;
				
				useId = 100+item.level;
				var a:Object = UIConstData.MarketGoodList;
				
				var strengthenType:Array = new Array();//存放强化材料type
				var luckyType:Array = new Array();//存放强化材料type
				var strengthenList:Array = UIConstData.MarketGoodList[1];
//				var s:String = item.type;
//				var strengthLev:String = s.charAt(s.length-1);
				var strengthLev:String = item.level;
				var count:int = 0;
				var strengthenItem:Object = null;
				var luckyItem:Object = null;
				
				if(strengthLev == "12") return false;
				for(var i:int=0; i<strengthenList.length; i++)
				{
					if(strengthenList[i].type2 == 1 && strengthenList[i].type3 == strengthLev)
					{
						strengthenType.push(strengthenList[i]);//
					}
					if(strengthenList[i].type2 == 2 && strengthenList[i].type3 == strengthLev)
					{
						luckyType.push(strengthenList[i]);//商城表查找幸运石
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
					a = UIConstData.ItemDic_1;
//					MountStrong.txtStoneNum_1.text = count.toString() + "/1";
					
					if(luckyItem)
					{
						var useItem2:UseItem = this.getCells(0, luckyItem.type, MountStrong);
						useItem2.x = MountStrong.mc_Right.x+2;
						useItem2.y = MountStrong.mc_Right.y+2;
						useItem2.Id = luckyItem.id;
						useItem2.IsBind = luckyItem.isBind;
						useItem2.Type = luckyItem.type;
						
						//						this.clearMaterial2();
						
						Material_2.Item = useItem2;
						Material_2.Index = luckyItem.index;
						//					Material_2.Grid.name = "bag_"+luckyItem.index.toString();
						MountStrong.addChild(useItem2);
						
						//显示幸运石快速购买
						var stone:UseItem = this.getCells(0, luckyItem.type, MountStrong);
						stone.x = MountStrong.materialBuy.item.x;
						stone.y = MountStrong.materialBuy.item.y;
//						stone.Id = luckyItem.id;
//						stone.Type = luckyItem.type;
//						stone.name = "buy";
						
						MountStrong.materialBuy.mouseEnabled = false;
						MountStrong.materialBuy.addChild(stone);
						MountStrong.materialBuy.txtName.text = luckyItem.Name;
						MountStrong.materialBuy.txtNum.text = "X"+count;
						MountStrong.materialBuy.txtType.text = luckyItem.type;
						MountStrong.materialBuy.txtType.visible = false;
						MountStrong.materialBuy.btnBuy.addEventListener(MouseEvent.CLICK,onFastBuy);
					}
//					MountStrong.txtStoneNum_1.text = BagData.hasItemNum(luckyItem.type)+"/"+ForgeData.forgeCommDataList[useId].runeNum;
					
					if(count == 0 && Material_2.Item)
					{	
						Material_2.Item.filters=[new ColorMatrixFilter([_nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, 0, 0, 0, 1, 0])];
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
//				MountStrong.txtVipLucky.text = vipRate*100+"%";
//				MountStrong.txtShcoolLucky.text = schoolRate*100+"%";
//				MountStrong.txtTotelLucky.text = baseRate*(1+vipRate+schoolRate)*100+"%";
				
				if(strengthenType.length > 0)
				{
					//					if( BagData.isHasItem(strengthenType[0]))
					//					{
					count = BagData.hasItemNum(strengthenType[0].type);
					//						count += BagData.hasItemNum(strengthenType[1]);
					strengthenItem = BagData.getItemByType(strengthenType[0].type);
					
					if(strengthenItem == null)
					{
						//							strengthenItem = BagData.getItemByType(strengthenType[1]);
						strengthenItem = UIConstData.ItemDic_1[strengthenType[0].type];
					}
					//					}
					
//					MountStrong.txtStoneNum_0.text = count.toString() + "/1";
					
					if(strengthenItem)
					{
						var useItem1:UseItem = this.getCells(0, strengthenItem.type, MountStrong);
						useItem1.x = MountStrong.mc_Left.x+2;
						useItem1.y = MountStrong.mc_Left.y+2;
						useItem1.Id = strengthenItem.id;
						useItem1.IsBind = strengthenItem.isBind;
						useItem1.Type = strengthenItem.type;
						
						//						this.clearMaterial1();
						
						Material_1.Item = useItem1;
						Material_1.Index = strengthenItem.index;
						//					Material_1.Grid.name = "bag_" + strengthenItem.index.toString();
						MountStrong.addChild(useItem1);
						
						//显示强化石快速购买
						var lucky:UseItem = this.getCells(0, strengthenItem.type, MountStrong);

						lucky.x = MountStrong.stoneBuy.item.x;
						lucky.y = MountStrong.stoneBuy.item.y;
//						lucky.Id = luckyItem.id;
//						lucky.Type = luckyItem.type;
//						lucky.name = "buy";
						
						MountStrong.stoneBuy.mouseEnabled = false;
						MountStrong.stoneBuy.addChild(lucky);
						MountStrong.stoneBuy.txtName.text = strengthenItem.Name;
						MountStrong.stoneBuy.txtNum.text = "X"+count;
						MountStrong.stoneBuy.txtType.text = strengthenItem.type;
						MountStrong.stoneBuy.txtType.visible = false;
						MountStrong.stoneBuy.btnBuy.addEventListener(MouseEvent.CLICK,onFastBuy);
					}

					//材料数量
//					MountStrong.txtStoneNum_0.text = BagData.hasItemNum(strengthenItem.type)+"/"+ForgeData.forgeCommDataList[useId].stoneNum;
					
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
			return false;
		}
		
		private function onFastBuy(e:MouseEvent):void
		{
			var type:int = e.currentTarget.parent.txtType.text;
			var good:Object = new Object();
			good.type = type;		//商品typeId
			good.count = 1;		//购买数量
			good.payType = 1;	//支付方式
			facade.sendNotification(MarketEvent.BUY_ITEM_MARKET,good);
		}
		
		private function clearMaterial1():void
		{
			if(Material_1 == null ||Material_1.Item == null)return;
			Material_1.Item.reset();
			Material_1.Item.gc();
			if(MountStrong.contains(Material_1.Item as UseItem))
			{
				MountStrong.removeChild(Material_1.Item as UseItem);
			}
			Material_1.Grid.name = "instance_Material_1";
			Material_1.Item = null;
		}
		
		private function clearMaterial2():void
		{
			if(Material_2 == null || Material_2.Item == null)return;
			Material_2.Item.reset();
			Material_2.Item.gc();
			if(MountStrong.contains(Material_2.Item as UseItem))
			{
				MountStrong.removeChild(Material_2.Item as UseItem);
			}
			Material_2.Grid.name = "instance_Material_2";
			Material_2.Item = null;
		}
		
		private function onChangeBuyType(evt:MouseEvent):void
		{
			var name:String = evt.target.name;
			
			var curFrame:uint = evt.currentTarget.currentFrame;
			var newFrame:uint;
			curFrame == 1 ? newFrame=2 : newFrame=1;
			evt.currentTarget.gotoAndStop( newFrame );
			
			switch(name)
			{
				case "AutoBuy":
					if(isAutoBuy == 1)
					{
//						(MountStrong.AutoBuy as MovieClip).gotoAndStop(++isAutoBuy);
					}
					else
					{
//						(MountStrong.AutoBuy as MovieClip).gotoAndStop(--isAutoBuy);
					}
					break;
				case "bind":
					break;
			}
			
		}
		
		private function onSelectBtn(e:MouseEvent):void
		{
			var name:String = e.currentTarget.name;
			switch(name)
			{
				case "btnBuy":
					break;
				case "btnStrong":
					if(timer.running) {
						return;
					}
					if(MountData.SelectedMount)
					{
						var lev:int = MountData.SelectedMount.level;
						if(lev<12)
						{
							var param:Array = [1,0,62,MountData.SelectedMount.id,0];
							EquipSend.createMsgCompound(param);
							timer.reset();
							timer.start();
						}
					}
					break;
			}
		}
		
		/** 创建UseItem实例 */
		protected function getCells(pos:int, icon:String, parent:DisplayObjectContainer):UseItem{
			
			var useItem:UseItem=this.cacheCells.shift();
			useItem=new UseItem(pos,icon,parent);
			return useItem;
		}
	}
}