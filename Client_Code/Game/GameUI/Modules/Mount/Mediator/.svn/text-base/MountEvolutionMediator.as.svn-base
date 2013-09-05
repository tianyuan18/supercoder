package GameUI.Modules.Mount.Mediator
{
	import Controller.PlayerSkinsController;
	
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Bag.Proxy.BagData;
	import GameUI.Modules.Maket.Data.MarketEvent;
	import GameUI.Modules.Mount.MountData.*;
	import GameUI.Modules.ToolTip.Const.IntroConst;
	import GameUI.Proxy.DataProxy;
	import GameUI.UIConfigData;
	import GameUI.View.BaseUI.PanelBase;
	import GameUI.View.PlayerModel;
	import GameUI.View.items.UseItem;
	
	import Net.ActionSend.EquipSend;
	
	import OopsEngine.Role.SkinNameController;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class MountEvolutionMediator extends Mediator
	{
		public static const NAME:String = "MountEvolutionMediator";
		private var panelBase:PanelBase;
		private var parentView:MovieClip;
		private var play:PlayerModel;
		public var isAutoBuy:int = 1;
		private var timer:Timer;
		private var cacheCells:Array=[];
		
		private var lock:int = 0;//0是解锁，1是加锁
		
		public function MountEvolutionMediator(parentMc:MovieClip)
		{
			parentView = parentMc;
			super(NAME);
		}
		
		public function get MountEvolution():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				MountEvent.INIT_MOUNT_UI,
				MountEvent.OPEN_MOUNT_EVOLUTION,					//打开宠物装备
				MountEvent.UPDATE_MOUNT_DISPLAY,
				MountEvent.CLOSE_MOUNT_EVOLUTION					//关闭宠物装备
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case MountEvent.INIT_MOUNT_UI:
//					facade.sendNotification(EventList.GETRESOURCE, {type:UIConfigData.MOVIECLIP, mediator:this, name:"MountEvolution"});
					this.setViewComponent(MountData.loadswfTool.GetResource().GetClassByMovieClip("MountEvolution"));
					this.MountEvolution.mouseEnabled=false;
					timer = new Timer(500, 1);
					break;
				case MountEvent.OPEN_MOUNT_EVOLUTION:
					registerView();
					if(MountData.SelectedMount)
					{
						initData();
					}
					MountEvolution.x = 88;
					MountEvolution.y = 27;
					parentView.addChild(MountEvolution);
					break;
				case MountEvent.CLOSE_MOUNT_EVOLUTION:
					resetData();
					retrievedView();
					
					parentView.removeChild(MountEvolution);
					break;
				
				case MountEvent.UPDATE_MOUNT_DISPLAY:
					if(MountData.curPage == 2)
					{
						initData();
					}
					break;
			}
		}
		
		private function initData():void
		{
			//获取宠物数据
//			(MountEvolution.mc_Name as MovieClip).visible = false;
//			(MountEvolution.mc_Name as MovieClip).mouseEnabled = false;
//			(MountEvolution.mc_Name as MovieClip).mouseChildren = false;
			resetData();
			if(MountData.SelectedMountId)
			{
				var skinNames:SkinNameController = PlayerSkinsController.GetSkinName(GameCommonData.Player);
				play = new PlayerModel("","","Resources\\Player\\MountR\\"+MountData.SelectedMountId+".swf");
//				play = new PlayerModel("","",MountData.SelectedMountId.toString());
				play.x = 190;
				play.y = 190;
				play.play();
				MountEvolution.addChild(play);
				
				showMaterial();
			}
			
		}
		
		private function presee():void
		{
			var a:Object = MountData.mountSkinList;
			var b:int = MountData.SelectedMountId;
			
			if(MountData.SelectedMountId<MountData.mountSkinList[MountData.mountSkinList.length-1].id)
			{
				
				resetData();
				if(MountData.SelectedMountId>0)
				{
					
					var skinNames:SkinNameController = PlayerSkinsController.GetSkinName(GameCommonData.Player);
					play = new PlayerModel("","","Resources\\Player\\MountR\\"+(MountData.SelectedMountId+1).toString()+".swf");
					
					play.x = 190;
					play.y = 190;
					play.play();
					MountEvolution.addChild(play);
					
					showMaterial();
				}
			}
		}
		
		private function resetData():void
		{
			if(play)
			{
				play.stop();
				if(MountEvolution.contains(play))
				{
					MountEvolution.removeChild(play);
				}
			}
		}
		
		private function registerView():void
		{
			//初始化素材事件
			(MountEvolution.curlevel as MovieClip).visible = false;
			(MountEvolution.curlevel as MovieClip).mouseEnabled = false;
			(MountEvolution.curlevel as MovieClip).mouseChildren = false;
			(MountEvolution.nextlevel as MovieClip).visible = false;
			(MountEvolution.nextlevel as MovieClip).mouseEnabled = false;
			(MountEvolution.nextlevel as MovieClip).mouseChildren = false;
			(MountEvolution.mcLucky as MovieClip).gotoAndStop(1);
			(MountEvolution.mcLucky as MovieClip).mouseEnabled = false;
			(MountEvolution.txtLucy as TextField).text = "0/1";
			//			(MountEvolution.txtNeedNum as TextField).text = "0";
			(MountEvolution.txtNeedMoney as TextField).text = "0";
			//			(MountEvolution.txtMyNum as TextField).text = "0";
			(MountEvolution.AutoBuy as MovieClip).gotoAndStop(1);
			(MountEvolution.AutoBuy as MovieClip).addEventListener(MouseEvent.CLICK,onChangeBuyType);
			//			MountEvolution.btnBuy.addEventListener(MouseEvent.CLICK,onSelectBtn);
			MountEvolution.btnEvolution.addEventListener(MouseEvent.CLICK,onSelectBtn);
			MountEvolution.btnEvolution.addEventListener(MouseEvent.MOUSE_OVER,onPresee);
			MountEvolution.btnEvolution.addEventListener(MouseEvent.MOUSE_OUT,onPresee);
			(MountEvolution.btnName as MovieClip).mouseEnabled = false;
			(MountEvolution.btnName as MovieClip).mouseChildren = false;
			MountEvolution.materialBuy.visible = false;
		}
		
		private function onPresee(e:MouseEvent):void
		{
			trace("----"+lock);
			if(lock==0)//当前解锁状态
			{
				lock = 1;//加锁
				this.presee();
			}else
			{
				facade.sendNotification(MountEvent.UPDATE_MOUNT_DISPLAY);
				lock = 0;
			}
		}
		
		private function retrievedView():void
		{
			//释放素材事件.
			(MountEvolution.AutoBuy as MovieClip).removeEventListener(MouseEvent.CLICK,onChangeBuyType);
			//			MountEvolution.btnBuy.addEventListener(MouseEvent.CLICK,onSelectBtn);
			MountEvolution.btnEvolution.removeEventListener(MouseEvent.CLICK,onSelectBtn);
		}
		
		private function showMaterial():Boolean
		{
			var item:Object = IntroConst.ItemInfo[MountData.SelectedMount.id];
			
			if(item)
			{
				MountEvolution.materialBuy.visible = true;
				
				var a:Object = UIConstData.MarketGoodList;
				
				var luckyType:Array = new Array();//存放进阶材料
				var strengthenList:Array = UIConstData.MarketGoodList[1];
				//				var s:String = item.type;
				//				var strengthLev:String = s.charAt(s.length-1);
				var strengthLev:String = (int(item.type)%100000).toString();
				var count:int = 0;
				var strengthenItem:Object = null;
				var luckyItem:Object = null;
				
				if(strengthLev == "12") return false;
				for(var i:int=0; i<strengthenList.length; i++)
				{
					if(strengthenList[i].type2 == 3 && strengthenList[i].type3 == strengthLev)
					{
						luckyType.push(strengthenList[i]);//商城表查找进阶符
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
					//					MountEvolution.txtStoneNum_1.text = count.toString() + "/1";
					
					if(luckyItem)
					{
						//显示幸运石快速购买
						var stone:UseItem = this.getCells(0, luckyItem.type, MountEvolution);
						stone.x = MountEvolution.materialBuy.item.x+2;
						stone.y = MountEvolution.materialBuy.item.y+2;
						stone.setImageScale(34,34);
						MountEvolution.materialBuy.mouseEnabled = false;
						MountEvolution.materialBuy.addChild(stone);
						MountEvolution.materialBuy.txtName.text = luckyItem.Name;
						MountEvolution.materialBuy.txtNum.text = "X"+count;
						MountEvolution.materialBuy.txtType.text = luckyItem.type;
						MountEvolution.materialBuy.txtType.visible = false;
						MountEvolution.materialBuy.btnBuy.addEventListener(MouseEvent.CLICK,onFastBuy);
					}
				}
				
				
			}
			return false;
		}
		
		private function clearMaterial():void
		{
			MountEvolution.materialBuy.btnBuy.removeEventListener(MouseEvent.CLICK,onFastBuy);
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
		
		private function onChangeBuyType(evt:MouseEvent):void
		{
//			if(isAutoBuy == 1)
//			{
//				(MountEvolution.AutoBuy as MovieClip).gotoAndStop(++isAutoBuy);
//			}
//			else
//			{
//				(MountEvolution.AutoBuy as MovieClip).gotoAndStop(--isAutoBuy);
//			}
			var curFrame:uint = evt.currentTarget.currentFrame;
			var newFrame:uint;
			curFrame == 1 ? newFrame=2 : newFrame=1;
			evt.currentTarget.gotoAndStop( newFrame );
		}
		
		private function onSelectBtn(e:MouseEvent):void
		{
			var name:String = e.currentTarget.name;
			switch(name)
			{
				case "btnBuy":
					break;
				case "btnEvolution":
					if(timer.running)
					{
						return;
					}
					if(MountData.SelectedMount)
					{
						var param:Array=[1,0,65,MountData.SelectedMount.id,0];
						EquipSend.createMsgCompound(param);
						timer.reset();
						timer.start();
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