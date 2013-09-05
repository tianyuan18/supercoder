package GameUI.Modules.Bag.Mediator
{
	import Controller.CooldownController;
	
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Bag.Command.DealItemCommand;
	import GameUI.Modules.Bag.Command.SetCdData;
	import GameUI.Modules.Bag.Command.SplitCommand;
	import GameUI.Modules.Bag.Command.UseItemCommand;
	import GameUI.Modules.Bag.Datas.BagEvents;
	import GameUI.Modules.Bag.Mediator.ConsignSaleMediator;
	import GameUI.Modules.Bag.Mediator.DealItem.SplitItem;
	import GameUI.Modules.Bag.Mediator.DealItem.ThrowItem;
	import GameUI.Modules.Bag.Mediator.DealItem.Use;
	import GameUI.Modules.Bag.Mediator.RepairMediator;
	import GameUI.Modules.Bag.Proxy.BagData;
	import GameUI.Modules.Bag.Proxy.GridManager;
	import GameUI.Modules.Bag.Proxy.GridUnit;
	import GameUI.Modules.GmTools.Utils.LoadSwfTool;
	import GameUI.Modules.Hint.Events.HintEvents;
	import GameUI.Modules.NPCChat.Command.NPCChatComList;
	import GameUI.Modules.NewerHelp.Data.NewerHelpData;
	import GameUI.Modules.NewerHelp.Data.NewerHelpEvent;
	import GameUI.Modules.RoleProperty.Datas.RoleEvents;
	import GameUI.Modules.Soul.Data.SoulData;
	import GameUI.Modules.Soul.Data.SoulVO;
	import GameUI.Proxy.DataProxy;
	import GameUI.SetFrame;
	import GameUI.UIConfigData;
	import GameUI.UIUtils;
	import GameUI.View.BaseUI.ItemBase;
	import GameUI.View.BaseUI.PanelBase;
	import GameUI.View.items.EquipItem;
	import GameUI.View.items.MoneyItem;
	import GameUI.View.items.UseItem;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class BagMediator extends Mediator
	{
		public static const NAME:String = "BagMediator";

		public static const MAXPAGE:uint = 4;

		public static const MAXBTN:uint = 5;
		public static const STARTPOS:Point = new Point(23, 38);
		
		public var comfrim:Function = comfrimDrop;
		public var cancel:Function = cancelDrop;
		
		private var panelBase:PanelBase = null;
		private var dataProxy:DataProxy = null;
		private var isGet:Boolean = false;
		private var gridManager:GridManager = null;
		private var splitMediator:SplitItemMediator = null;
		private var throwItem:ThrowItem = new ThrowItem();
		private var useItem:Use = new Use();
		private var splitItem:SplitItem = new SplitItem();
		
		private var cacheCells:Array=[];
		
//		private var loadswfTool:LoadSwfTool=null;
//		protected var moneyBind:MoneyItem;
//		protected var moneyUnBind:MoneyItem;
//		protected var moneyRmb:MoneyItem;
		
		/** 点击整理延时计时器 */
		private var dealItemDelayTime:Number=0;
		
		public function BagMediator()
		{
			super(NAME);
		}
		
		private function get bag():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [	
				EventList.INITVIEW,					//初始化
				EventList.ENTERMAPCOMPLETE,			//进入场景
				EventList.SHOWBAG,					//显示背包
				EventList.GETITEMS,					//得到物品
				EventList.UPDATEBAG,				//更新背包物品
				EventList.GOTRADEVIEWFAULT,			//将物品放入交易栏失败
				EventList.BAGITEMUNLOCK,			//物品解锁
				EventList.TRADECOMPLETE,			//交易完成
//				EventList.TRADEFAULT,				//交易失败物品解锁
				EventList.CLOSEBAG,					//关闭背包
				BagEvents.DROPITEM,					//丢弃物品
				BagEvents.ADDITEM,					//增加物品
				EventList.UPDATEMONEY,				//更新背包钱
				BagEvents.SHOWBTN,
				BagEvents.UPDATEITEMNUM,
				BagEvents.EXTENDBAG,
				BagEvents.BAG_STOP_DROG,			//背包禁止拖动
				BagEvents.BAG_INIT_POS,				//背包还原位置
				BagEvents.INIT_BAG_UI,
				RoleEvents.HEROPROP_PANEL_INIT_POS,
				BagEvents.BAG_GOTO_SOME_INDEX		//背包跳页
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			
			
			switch(notification.getName())
			{
				case EventList.INITVIEW:															//初始化
					dataProxy = facade.retrieveProxy(DataProxy.NAME) as DataProxy;
					
				break;
				case BagEvents.INIT_BAG_UI:
					
					initView();
					this.updataBag();
					var p:Point;
					if( dataProxy.HeroPropIsOpen )
					{
						facade.sendNotification(RoleEvents.HEROPROP_PANEL_INIT_POS);
						
					}else{
						p = UIConstData.getPos(panelBase.width,panelBase.height);
						panelBase.x = p.x;
						panelBase.y = p.y;
					}
					GameCommonData.GameInstance.GameUI.addChild(panelBase); 
					panelBase.height = int(panelBase.height);
					//showItems(BagData.AllUserItems[BagData.SelectIndex]);
					showItems(BagData.AllItems[BagData.SelectPageIndex]); //wuzhouhai
					if(NewerHelpData.newerHelpIsOpen)	//打开背包通知新手指导
						sendNotification(NewerHelpEvent.OPEN_BAG_NOTICE_NEWER_HELP);
					
					break;
				case EventList.ENTERMAPCOMPLETE:													//进入场景
//					NetAction.RequestItems();
//					facade.sendNotification(RoleEvents.GETFITOUTBYBAG);
					GameCommonData.GameInstance.GameUI.tabChildren = false;
					GameCommonData.GameInstance.GameUI.tabEnabled = false;
				break;
				
				case EventList.SHOWBAG:	
					if(bag == null){
						BagData.loadswfTool = new LoadSwfTool(GameConfigData.BagUI , this);
						BagData.loadswfTool.sendShow = sendShow;
					}
					else
					{
						facade.sendNotification(BagEvents.INIT_BAG_UI);
					}
					dataProxy.BagIsOpen = true;
				break;
				
				case EventList.GETITEMS:															//得到物品
					//showItems(BagData.AllUserItems[BagData.SelectIndex]);
//					showItems(BagData.AllItems[BagData.SelectPageIndex]);//wuzhouhai
				break;
				case EventList.UPDATEBAG:															//更新背包物品
					//showItems(BagData.AllUserItems[BagData.SelectIndex]);
					if(bag == null)return;
					this.updataBag();
					trace(BagData.SelectPageIndex);
					var a:Array = BagData.AllItems;
					showItems(BagData.AllItems[BagData.SelectPageIndex]);//wuzhouhai
				break;
				
				case RoleEvents.HEROPROP_PANEL_INIT_POS:
					var point:Point = UIConstData.getPos(880,panelBase.height);
					
					panelBase.x = point.x+512;
					panelBase.y = point.y;
					break;
				
				case EventList.GOTRADEVIEWFAULT:													//将物品放入交易栏失败
					BagData.SelectedItem.Item.IsLock = false;
				break;
				case EventList.BAGITEMUNLOCK:														//物品解锁
					var id:int = notification.getBody() as int;
					bagItemUnLock(id);
				break;
				case EventList.TRADECOMPLETE:														//交易完成
					showItems(BagData.AllItems[BagData.SelectPageIndex]);
				break;
				
				case EventList.CLOSEBAG:															//交易完成
					panelCloseHandler(null);
				break;
				case BagEvents.DROPITEM:															//丢弃物品
					removeItem(notification.getBody());
				break;
				case BagEvents.ADDITEM:																//增加物品
					addItem(notification.getBody());
				break;
				case EventList.UPDATEMONEY:															//更新钱
					if(bag)
					{
						initTxtView();
					}
					
				break;
				case BagEvents.SHOWBTN:
					var bool:Boolean = notification.getBody() as Boolean;							//变更操作物品按钮的状态
					showBtn(bool);
				break;
				case BagEvents.UPDATEITEMNUM:														//更新物品数量
					updateNum();
				break;
				case BagEvents.EXTENDBAG:															//背包扩展
					extendGrid();
				break;
				case BagEvents.BAG_STOP_DROG:														//背包禁用拖动
					if(panelBase)
						panelBase.IsDrag = false;
				break;
				case BagEvents.BAG_INIT_POS:												//背包位置还原
//					var point:Point;
//					if( dataProxy.HeroPropIsOpen )
//					{
//						point = UIConstData.getPos(panelBase.width+400,panelBase.height);
//						
//						panelBase.x = point.x+450;
//						panelBase.y = point.y;
//					}else{
//						point = UIConstData.getPos(panelBase.width,panelBase.height);
//						panelBase.x = point.x;
//						panelBase.y = point.y;
//					}
				break;
				case BagEvents.BAG_GOTO_SOME_INDEX:													//背包跳页
					var indexPage:int = notification.getBody() as int;
					this.choicePagefunc(indexPage);
				break;
			}
		}
		
		private function sendShow(view:MovieClip):void{
			
//			facade.sendNotification(EventList.GETRESOURCE, {type:UIConfigData.MOVIECLIP, mediator:this, name:UIConfigData.BAG});
			this.setViewComponent(BagData.loadswfTool.GetResource().GetClassByMovieClip(UIConfigData.BAG));
			panelBase = new PanelBase(bag, bag.width+12, bag.height+12);
			panelBase.name = "Bag";
			panelBase.addEventListener(Event.CLOSE, panelCloseHandler);
			//					panelBase.x = 586;
			//					panelBase.y = 55;
			//					panelBase.SetTitleTxt( GameCommonData.wordDic[ "mod_bag_med_bag_han_1" ] );	 // 背 包
//			panelBase.SetTitleName("BagIcon");
			panelBase.SetTitleMc(BagData.loadswfTool.GetResource().GetClassByMovieClip("BagIcon"));
			panelBase.SetTitleDesign();
			panelBase.closeFunc = closeBagPanel;
			gridManager = new GridManager();
			facade.registerProxy(gridManager);
			BagData.bagView = bag;
			facade.registerCommand(UseItemCommand.NAME, UseItemCommand);
			facade.registerCommand(DealItemCommand.NAME, DealItemCommand);
			facade.registerCommand(SplitCommand.NAME, SplitCommand);
			
			initGrid();
			initView();
			var i:int = 0;
			
			facade.sendNotification(BagEvents.INIT_BAG_UI);
		}
		
		private function updataBag():void
		{
			/**
			 * 装备	1000000-3000000
			 * 药品	2000-2999
			 * 宝石	53000-53999
			 * 
			 */
			for(var j:int=0;j<BagData.AllItems.length;++j)
			{
				BagData.AllItems[j] = new Array(BagData.BagPerNum);
			}
			
			var count:int = 0;
			for(var i:int=0;i<BagData.AllUserItems[0].length;i++)
			{
				var n:int = i/BagData.BagPerNum;
				switch(BagData.SelectIndex)
				{
					case 0:
						if(BagData.AllUserItems[0][i] != null && BagData.AllUserItems[0][i] != undefined)
						{
							BagData.AllItems[n][count] = BagData.AllUserItems[0][i];
							count++;
						}
						break;
					case 1:
						if(BagData.AllUserItems[0][i] != null && BagData.AllUserItems[0][i] != undefined && BagData.AllUserItems[0][i].type>110000 && BagData.AllUserItems[0][i].type<240000)
						{	
							BagData.AllItems[n][count] = BagData.AllUserItems[0][i];
							count++;
						}
						break;
					case 2:
						if(BagData.AllUserItems[0][i] != null && BagData.AllUserItems[0][i] != undefined && BagData.AllUserItems[0][i].type>300000 && BagData.AllUserItems[0][i].type<400000)
						{
							BagData.AllItems[n][count] = BagData.AllUserItems[0][i];
							count++;
						}
						break;
					case 3:
						if(BagData.AllUserItems[0][i] != null && BagData.AllUserItems[0][i] != undefined && BagData.AllUserItems[0][i].type>400000 && BagData.AllUserItems[0][i].type<500000)
						{
							BagData.AllItems[n][count] = BagData.AllUserItems[0][i];
							count++;
						}
						break;
					case 4:
						if(BagData.AllUserItems[0][i] != null && BagData.AllUserItems[0][i] != undefined && BagData.AllUserItems[0][i].type>500000)
						{
							BagData.AllItems[n][count] = BagData.AllUserItems[0][i];
							count++;
						}
						break;
				}
				
			}
//			var a:Array = BagData.AllItems;
//			var n:int=0;
		}
		private function initView():void
		{
			for(var i:int = 0; i<5; i++)
			{
				bag["mcPage_"+i].buttonMode = true;
				bag["mcPage_"+i].addEventListener(MouseEvent.CLICK, choiceBagHandler);
				bag["mcPage_"+i].gotoAndStop(1);
			}
			bag["mcPage_0"].gotoAndStop(3);
			for(var j:int = 0; j<4; j++)
			{
				bag["bagPage_"+j].buttonMode = true;
				bag["bagPage_"+j].addEventListener(MouseEvent.CLICK, choicePageHandler);
				bag["bagPage_"+j].addEventListener(MouseEvent.MOUSE_OVER, dragMoveHandler);
				bag["bagPage_"+j].gotoAndStop(1);
			}
			bag["bagPage_0"].gotoAndStop(3);
			showBtn(false);
//			bag.btnSall.addEventListener(MouseEvent.CLICK, btnClickHandler);
//			bag.btnSplit.buttonMode = true;
//			bag.consignBtn.buttonMode = true;
//			bag.btnDeal.buttonMode = true;
//			bag.repairBtn.buttonMode = true;
//			
//			bag.btnSplit.gotoAndStop(1);
//			bag.consignBtn.gotoAndStop(1);
//			bag.btnDeal.gotoAndStop(1);
//			bag.repairBtn.gotoAndStop(1);
//			bag.sellBtn.gotoAndStop(1);
			
			bag.btnSplit.addEventListener(MouseEvent.CLICK, btnClickHandler);
			bag.consignBtn.addEventListener(MouseEvent.CLICK, btnClickHandler);
			bag.sell.addEventListener(MouseEvent.CLICK, btnClickHandler);
//			bag.btnDrop.addEventListener(MouseEvent.CLICK, btnClickHandler);
			bag.btnDeal.addEventListener(MouseEvent.CLICK, btnClickHandler);
			bag.repairBtn.addEventListener(MouseEvent.CLICK, btnClickHandler);
			
			bag.bagContain.text = "";
//			bag.btnUse.addEventListener(MouseEvent.CLICK, btnClickHandler);	
			
			//显示钱
//			bag.btnSplit.addEventListener(MouseEvent.MOUSE_OVER, buttonMCOver);
//			bag.sellBtn.addEventListener(MouseEvent.MOUSE_OVER, buttonMCOver);
//			bag.consignBtn.addEventListener(MouseEvent.MOUSE_OVER, buttonMCOver);
//			bag.btnDeal.addEventListener(MouseEvent.MOUSE_OVER, buttonMCOver);
//			bag.repairBtn.addEventListener(MouseEvent.MOUSE_OVER, buttonMCOver);
//			
//			bag.btnSplit.addEventListener(MouseEvent.MOUSE_OUT, buttonMCOut);
//			bag.sellBtn.addEventListener(MouseEvent.MOUSE_OUT, buttonMCOut);
//			bag.consignBtn.addEventListener(MouseEvent.MOUSE_OUT, buttonMCOut);
//			bag.btnDeal.addEventListener(MouseEvent.MOUSE_OUT, buttonMCOut);
//			bag.repairBtn.addEventListener(MouseEvent.MOUSE_OUT, buttonMCOut);
//			this.moneyBind.update(UIUtils.getMoneyStandInfo(GameCommonData.Player.Role.UnBindMoney, ["\\se","\\ss","\\sc"]));
//			this.moneyUnBind.update(UIUtils.getMoneyStandInfo(GameCommonData.Player.Role.BindMoney, ["\\ce","\\cs","\\cc"]));
			initTxtView();
		}
		
		
		private function initTxtView():void{
			bag.copper.text = GameCommonData.Player.Role.UnBindMoney;
			bag.copperBind.text = GameCommonData.Player.Role.BindMoney;
			
			bag.gold.text = GameCommonData.Player.Role.UnBindRMB;
			bag.goldBind.text = GameCommonData.Player.Role.BindRMB;
		}
		private function buttonMCOver(e:MouseEvent):void
		{
			e.currentTarget.gotoAndStop(2);
		}
		
		private function buttonMCOut(e:MouseEvent):void
		{
			e.currentTarget.gotoAndStop(1);
		}
		
//		/** 背包跳页(跳到指定页) */
//		private function bagToIndex(index:uint):void
//		{
//			if(BagData.SelectIndex == index) return;
//			BagData.SelectIndex = index;
//			for(var i:int = 0; i<5; i++) {
//				bag["bagPage_"+i].gotoAndStop(1);
//				bag["bagPage_"+i].addEventListener(MouseEvent.CLICK, choicePageHandler);
//			}
//			bag["bagPage_"+index].removeEventListener(MouseEvent.CLICK, choicePageHandler);	
//			BagData.SelectedItem = null;
//			showBtn(false);
//			bag["bagPage_"+index].gotoAndStop(2);
//			showLock();
//			SetFrame.RemoveFrame(bag);
//			showItems(BagData.AllItems[BagData.SelectPageIndex]);
//		}

		/** 背包分类 */
		private function choiceBagHandler(event:MouseEvent):void
		{
			for(var j:int = 0; j<5; j++)
			{
				bag["mcPage_"+j].gotoAndStop(1);
				bag["mcPage_"+j].addEventListener(MouseEvent.CLICK, choiceBagHandler);
				//bag["mcPage_"+j].addEventListener(MouseEvent.CLICK, choicePageHandler);
			}
			
			var index:uint = uint(event.currentTarget.name.split("_")[1]);
			bag["mcPage_"+index].removeEventListener(MouseEvent.CLICK, choiceBagHandler);
			BagData.SelectIndex = index;
			BagData.SelectedItem = null;
			bag["mcPage_"+index].gotoAndStop(3);
//			showLock();
			this.initBagPage();
			/* if(bag.getChildByName("yellowFrame"))
			{
			bag.removeChild(bag.getChildByName("yellowFrame"));
			} */
			SetFrame.RemoveFrame(bag);
			sendNotification(BagEvents.REMOVE_BAG_EXTENDS);
			//initGrid();
//			showItems(BagData.AllItems[BagData.SelectPageIndex]);	////wuzhouhai
			sendNotification(EventList.UPDATEBAG);
			//showItems(BagData.AllUserItems[BagData.SelectIndex]);
		}
		
		private function choicePagefunc(index:int):void
		{
			for(var i:int = 0; i<MAXPAGE; i++)
			{
				bag["bagPage_"+i].gotoAndStop(1);
				bag["bagPage_"+i].addEventListener(MouseEvent.CLICK, choicePageHandler);
				bag["bagPage_"+i].addEventListener(MouseEvent.MOUSE_OVER, dragMoveHandler);
			}
			
			
			bag["bagPage_"+index].removeEventListener(MouseEvent.CLICK, choicePageHandler);	
//			BagData.SelectedItem = null;
			BagData.SelectPageIndex = index;
			bag["bagPage_"+index].gotoAndStop(3);
			
			SetFrame.RemoveFrame(bag);
			sendNotification(BagEvents.REMOVE_BAG_EXTENDS);
			showItems(BagData.AllItems[BagData.SelectPageIndex]);
			sendNotification(EventList.UPDATEBAG);
		}
		
		/** 背包翻页 */
		private function choicePageHandler(event:MouseEvent):void
		{
			var index:uint = uint(event.currentTarget.name.split("_")[1]);
			this.choicePagefunc(index);
		}
		
		/** 初始化背包翻页 */
		private function initBagPage():void
		{
			for(var i:int = 0; i<MAXPAGE; i++)
			{
				bag["bagPage_"+i].gotoAndStop(1);
				bag["bagPage_"+i].addEventListener(MouseEvent.CLICK, choicePageHandler);
				bag["bagPage_"+i].addEventListener(MouseEvent.MOUSE_OVER, dragMoveHandler);
			}
			var index:uint = 0;
			bag["bagPage_"+index].removeEventListener(MouseEvent.MOUSE_OVER, dragMoveHandler);
			bag["bagPage_"+index].removeEventListener(MouseEvent.CLICK, choicePageHandler);	
			BagData.SelectedItem = null;
			BagData.SelectPageIndex = 0;
			bag["bagPage_"+index].gotoAndStop(3);
		}
		
		private function dragMoveHandler(e:MouseEvent):void
		{
			if(BagData.SelectedItem == null || BagData.AutoPage == false)return;

			var name:Array = (e.currentTarget.name as String).split("_");
			if(name[0]=="bagPage")
			{
				facade.sendNotification(BagEvents.BAG_GOTO_SOME_INDEX,int(name[1]));
			}
		}
		
		//物品设置锁定锁定
		private function showLock():void
		{
			for(var i:int = 0; i<BagData.BagPerNum; i++)
			{
				BagData.GridUnitList[i].Item.IsLock = BagData.AllLocks[0][i];
			}
		}
		
		/**  初始化格子 */
		private function initGrid():void
		{
			for( var i:int = 0; i<BagData.BagPerNum; i++ ) 
			{
				var gridUnit:MovieClip = BagData.loadswfTool.GetResource().GetClassByMovieClip("GridUnit");
				gridUnit.x = (gridUnit.width+7) * (i%7) + STARTPOS.x;
				gridUnit.y = (gridUnit.height+5) * int(i/7) + STARTPOS.y;
				gridUnit.name = "bag_" + i.toString();
				bag.addChild(gridUnit);
				var gridUint:GridUnit = new GridUnit(gridUnit, true);
				gridUint.parent = bag;										//设置父级
				gridUint.Index = i;											//格子的位置		
				gridUint.HasBag = true;										//是否是可用的背包
				gridUint.IsUsed	= false;									//是否已经使用
				gridUint.Item	= null;										//格子的物品
				BagData.GridUnitList.push(gridUint);
			}		
		}
		
		private function showItems(list:Array,index:int=0):void
		{			
			//移除所有界面上的物品	
			
			removeAllItem();
			//显示钱
			//			initView();			
			//管理器初始化	

			gridManager.Initialize();
			
//			var a:Array = BagData.BagNum;
			if(BagData.GridUnitList.length == 0) return;
			var count:int = 0;
			for(var i:int = 0; i<BagData.BagPerNum; i++)
			{
				BagData.GridUnitList[i].HasBag = true;
				//添加未开的格子数据
				var a:Object = BagData.BagNum;
				if(i > BagData.BagNum[BagData.SelectPageIndex]-1)
				{
					var noBag:MovieClip = null;
					if(count < 7)
					{
						noBag = BagData.loadswfTool.GetResource().GetClassByMovieClip("NoBag_"+count.toString());
						count++;
						
					}else
					{
						noBag = BagData.loadswfTool.GetResource().GetClassByMovieClip("NoBag");
					}
					noBag.x = BagData.GridUnitList[i].Grid.x;
					noBag.y = BagData.GridUnitList[i].Grid.y;
					noBag.mouseEnabled = false;
					noBag.mouseChildren= false;
					noBag.name = "noBag";
					BagData.GridUnitList[i].HasBag = false;	
					BagData.GridUnitList[i].Item = noBag;	
					bag.addChild(noBag);
				} 
				//无数据,背包为空
				if(list[i] == undefined) 
				{
					continue;
				};
				//添加物品
				if(BagData.SelectIndex == 0)
				{
					addItem(list[i]);
				}else
				{
					addItemM(list[i],i);
				}
				
			}
			//目前有锁定的物品则显示操作按钮，加外框		
			if(BagData.SelectedItem)
			{
				showBtn(true);
				SetFrame.UseFrame(BagData.SelectedItem.Grid);
			}
			var countBag:int=0;
			for(i=0;i<BagData.BagNum.length;i++)
			{
				countBag+=BagData.BagNum[i];
			}
			var countItem:uint = BagData.hasAllItemNum();
			
			bag.bagContain.text = countItem+"/"+countBag;
		}
		
		protected function getCells(pos:int, icon:String, parent:DisplayObjectContainer,quality:int):UseItem{
//			var useItem:UseItem=this.cacheCells.shift();
//			if(useItem==null){
//			 	useItem = new UseItem(pos,icon,parent);
//			}else{
//				useItem.reset();
//				useItem.init(icon,parent,pos);
//			}
			var useItem:EquipItem = new EquipItem(pos,icon,parent,quality);
			if(quality > 1){
				var quickBgName:String = "quickBg"+quality;
				var bg:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip(quickBgName);	
				bg.name = 'itemBg';
				bg.x = -3;
				bg.y = -3;
				useItem.addChild(bg);
			}
			return useItem;
		}
		
		//添加物品，初始化格子数组,如果有物品在cd添加cd
		private function addItem(item:Object):void
		{
			var gList:Array = BagData.GridUnitList;			
			var useItem:UseItem = this.getCells(item.index, item.type, bag,item.color);
			if(int(item.type) < 300000)
			{
				useItem.Num = 1;
			}
			else if(int(item.type) > 300000)
			{
				useItem.Num = item.amount;
			}
			useItem.setImageScale(34,34);
			useItem.x = gList[item.index].Grid.x+2;
			useItem.y = gList[item.index].Grid.y+2;
			useItem.Id = item.id;
			useItem.IsBind = item.isBind;
			useItem.Type = item.type;
			useItem.IsLock = BagData.AllLocks[0][item.index];
			gList[item.index].Item = useItem;
			gList[item.index].Grid.name = "bag_"+item.index.toString();
			gList[item.index].Index = item.index;
			gList[item.index].IsUsed = true;
			
			var cdObj:Object=SetCdData.searchCdObjByType(item.type);
			if(cdObj!=null){
//				useItem.startCd(cdObj.cdtimer,cdObj.count);
				//CooldownController.getInstance().triggerCD(useItem.Type, cdObj.cdtimer);
			}
				
			if(SetCdData.cdItemCollection[0][item.index] != undefined)
			{
				if(SetCdData.cdItemCollection[0][item.index].isCd)
				{
//					useItem.startCd(SetCdData.cdItemCollection[BagData.SelectIndex][item.index].cdtimer, SetCdData.cdItemCollection[BagData.SelectIndex][item.index].count+1);
				}
			}
			bag.addChild(useItem);	
			CooldownController.getInstance().registerCDItem(useItem.Type, useItem);
		}
		
		private function addItemM(item:Object,index:int):void
		{
//			var BagData.GridUnitList:Array = BagData.GridUnitList;
//			var gList:Array = BagData.AllItems[BagData.SelectPageIndex];	
			var useItem:UseItem = this.getCells(item.index, item.type, bag,item.color);
			if(int(item.type) < 300000)
			{
				useItem.Num = 1;
			}
			else if(int(item.type) > 300000)
			{
				useItem.Num = item.amount;
			}
			
			useItem.setImageScale(34,34);
			useItem.x = BagData.GridUnitList[index].Grid.x + 2;
			useItem.y = BagData.GridUnitList[index].Grid.y + 2;
			useItem.Id = item.id;
			useItem.IsBind = item.isBind;
			useItem.Type = item.type;
			useItem.setImageScale(34,34);
			useItem.IsLock = BagData.AllLocks[0][item.index];
			BagData.GridUnitList[index].Grid.name = "bag_"+item.index.toString();
			BagData.GridUnitList[index].Item = useItem;
			BagData.GridUnitList[index].Index = item.index;
			BagData.GridUnitList[index].IsUsed = true;
			
			var cdObj:Object=SetCdData.searchCdObjByType(item.type);
			if(cdObj!=null){
				//				useItem.startCd(cdObj.cdtimer,cdObj.count);
				//CooldownController.getInstance().triggerCD(useItem.Type, cdObj.cdtimer);
			}
			
			if(SetCdData.cdItemCollection[0][index] != undefined)
			{
				if(SetCdData.cdItemCollection[0][index].isCd)
				{
					//					useItem.startCd(SetCdData.cdItemCollection[BagData.SelectIndex][item.index].cdtimer, SetCdData.cdItemCollection[BagData.SelectIndex][item.index].count+1);
				}
			}
			bag.addChild(useItem);	
			CooldownController.getInstance().registerCDItem(useItem.Type, useItem);
		}
		
		//扩展背包，先移除所有的未开启背包的，再添加
		private function extendGrid():void
		{
			var count:int = 0;
			removeAllnoBag();
			for(var i:int  = 0; i<36; i++)
			{
				BagData.GridUnitList[i].HasBag = true;
				if(BagData.GridUnitList[i].Item && BagData.GridUnitList[i].Item.name == "noBag") BagData.GridUnitList[i].Item = null;
				if(i > BagData.BagNum[BagData.SelectIndex]-1)
				{
					var noBag:MovieClip = BagData.loadswfTool.GetResource().GetClassByMovieClip("NoBag");
					noBag.x = BagData.GridUnitList[i].Grid.x;
					noBag.y = BagData.GridUnitList[i].Grid.y;
					noBag.mouseEnabled = false;
					noBag.mouseChildren= false;
					noBag.name = "noBag";
					BagData.GridUnitList[i].HasBag = false;	
					BagData.GridUnitList[i].Item = noBag;	
					bag.addChild(noBag);
				}
			}
		}
		
		//更新数量，根据type, 如果是装备不用更新
		private function updateNum():void
		{
			return;
			var curList:Array = BagData.AllItems[BagData.SelectPageIndex];
			for(var i:int = 0; i<curList.length; i++)
			{
				if(curList[i] == undefined) continue;
				if(BagData.GridUnitList[i].HasBag == false) continue;
				if(curList[i].type < 300000)
				{
					BagData.GridUnitList[i].Item.Num = 1;
				}
				else if(curList[i].type > 300000)
				{
					BagData.GridUnitList[i].Item.Num = curList[i].amount;
				}
			}
		}
		
		private function removeItem(item:Object):void
		{
			for( var i:int = 0; i<BagData.GridUnitList.length; i++)
			{
				if(BagData.GridUnitList[i].Item)
				{
					if(BagData.GridUnitList[i].Item.Id == item.id)
					{
						if(BagData.SelectedItem)
						{
							if(BagData.SelectedItem.Index == i)
							{
								SetFrame.RemoveFrame(bag);
								BagData.SelectedItem = null;
								showBtn(false);
							}
						}
						if(bag.contains(BagData.GridUnitList[i].Item))
						{
							bag.removeChild(BagData.GridUnitList[i].Item);
//							if(BagData.GridUnitList[i].Item is UseItem){
//							
////								(BagData.GridUnitList[i].Item as UseItem).reset();
////								BagData.GridUnitList[i].Item=null;
////								this.cacheCells.push(BagData.GridUnitList[i].Item);
//							}
						}
						BagData.GridUnitList[i].Item = null;	
						BagData.GridUnitList[i].IsUsed = false;
					}
				}		
			}
		}

		//物品的快捷操作		
		private function btnClickHandler(event:MouseEvent):void
		{
			switch(event.target.name)
			{
				case "sell":
//					//摆摊
//					facade.sendNotification(EventList.SHOWSTALL);
					
					//出售

					if(dataProxy.DepotIsOpen)
					{
						sendNotification(EventList.CLOSEDEPOTVIEW);
					}else
					{
						sendNotification(EventList.SELECTED_NPC_ELEMENT,{npcId:207, newerData:null});
						sendNotification(NPCChatComList.SEND_NPC_MSG,"1");
					}
					

				break;
				case "btnSplit":
					//拆分
					if(BagData.SplitIsOpen) return;
					if(BagData.SelectedItem) {
						if(BagData.SelectedItem.Item.IsLock)
						{
							facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_bag_med_bag_btn_1" ], color:0xffff00});  // 此物品已锁定，无法拆分
							return;
						}
						facade.sendNotification(SplitCommand.NAME);
					}
				break;
				case "consignBtn":
					if(BagData.ConsignSaleOpen) return;
					/** 寄售面板 */
					facade.registerMediator( new ConsignSaleMediator(BagData.loadswfTool) );
					facade.sendNotification(BagEvents.OPENCONSIGNSALE,{repairX:panelBase.x,repairY:panelBase.y});
					break;
				case "repairBtn":
					if(BagData.RepairPanelOpen)
					{
						facade.sendNotification(BagEvents.CLOSEREPAIRPANEL);
						return;
					}
					/** 修理面板 */
					facade.registerMediator( new RepairMediator(BagData.loadswfTool) );
					facade.sendNotification(BagEvents.OPENREPAIRPANEL,{repairX:panelBase.x,repairY:panelBase.y});
					break;
//				case "btnDrop":
//					if(BagData.SelectedItem) {
//						var obj:Object = UIConstData.getItem(BagData.SelectedItem.Item.Type); 
//						if(obj != null) {
//							var mask:uint = obj.Monopoly & 0x40;
//							if(mask > 0){
//								facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_bag_med_bag_btn_2" ], color:0xffff00});   // 此物品不能丢弃
//								return;
//							}
//							if(int(obj.type/10) == 25000)  //是魂魄
//							{
//								if(SoulData.SoulDetailInfos[BagData.SelectedItem.Item.Id])
//								{
//									if((SoulData.SoulDetailInfos[BagData.SelectedItem.Item.Id] as SoulVO).composeLevel >= 3)
//									{
//										facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_bag_med_bag_btn_2" ], color:0xffff00});  // 此物品不能丢弃
//										return;
//									}
//								}
//							}
//						}
//						if(BagData.SelectedItem.Item.IsLock) {
//							facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_bag_med_bag_btn_2" ], color:0xffff00});    // 此物品不能丢弃 
//							return;
//						}
//						// 物品丢弃将消失，确定要丢弃么？
//						facade.sendNotification(EventList.SHOWALERT, {comfrim:comfrimDrop, cancel:cancelDrop, info:GameCommonData.wordDic[ "mod_bag_med_bag_btn_3" ] });  // 物品丢弃将消失，确定要丢弃么？
//					}
//				break;
				//整理
				case "btnDeal":
					var curTime:Number=getTimer();
					if(curTime-this.dealItemDelayTime>1700){
						this.dealItemDelayTime=curTime;
						facade.sendNotification(DealItemCommand.NAME, bag);
					}else{
//						facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_bag_med_bag_btn_5" ], color:0xffff00});   // 物品整理过快，请稍后再整理
					}
				break;
				//使用
//				case "btnUse":
//					if(BagData.SelectedItem) 
//					{
//						if(BagData.SelectedItem.Item.IsLock)
//						{
//							facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_bag_med_bag_btn_4" ], color:0xffff00});   // 此物品已锁定，无法使用
//							return;
//						}
//						facade.sendNotification(UseItemCommand.NAME);
//					}
//				break;
			}
		}
		
		//丢弃物品处理
		public function comfrimDrop():void { ThrowItem.ThrowNone(BagData.SelectedItem); }
		
		public function cancelDrop():void {}
		/**
		 * 做全刷新
		 * 移除所有的物品 
		 * 将所有的格子都初始化 
		 * */
		private function removeAllItem():void
		{
			var count:int = bag.numChildren - 1;
			while(count>=0)
			{
				if(bag.getChildAt(count) is ItemBase)
				{
					var item:ItemBase = bag.getChildAt(count) as ItemBase;
					CooldownController.getInstance().unregisterCDItem(item.Type, item);
					bag.removeChild(item);
					item=null;
//					this.cacheCells.push(item);
//					item.reset();
				}
				count--;
			}
			removeAllnoBag();
			SetFrame.RemoveFrame(bag);
			for( var i:int = 0; i<BagData.BagPerNum; i++ ) 
			{
				if(BagData.GridUnitList[i] == null) continue;
				BagData.GridUnitList[i].Item = null;
//				if(bag.contains(BagData.GridUnitList[i].Item))
//				{
//					bag.removeChild(BagData.GridUnitList[i].Item);
//				}
				BagData.GridUnitList[i].IsUsed = false;
			}
			gridManager.Gc();
//			System.CollectEMS();
			
			var j:int = 0
			if(BagData.SelectIndex == 0)
			{
				for( j = 0; j<BagData.BagPerNum; j++ ) 
				{
					BagData.GridUnitList[j].Grid.name="bag_"+j.toString();
				}
			}else
			{
				for( j = 0; j<BagData.BagPerNum; j++ ) 
				{
					BagData.GridUnitList[j].Grid.name="";
				}
			}
			
			
		}
		
		private function removeAllnoBag():void
		{
			var count2:int = bag.numChildren - 1;
			while(count2>=0)
			{
				var name:Array = bag.getChildAt(count2).name.split("_");
				if(name[0] == "noBag")
				{
					var noBag:MovieClip = bag.getChildAt(count2) as MovieClip;
					bag.removeChild(noBag);
					noBag = null;
				}
				count2--; 
			}
		}
				
		private function closeBagPanel():void
		{
			panelCloseHandler(null);
		}
		private function panelCloseHandler(event:Event):void
		{
			panelBase.IsDrag = true;
			if(panelBase.parent)
			{
				panelBase.parent.removeChild(panelBase);
			}
//			GameCommonData.GameInstance.GameUI.removeChild(panelBase);
			if(BagData.SplitIsOpen) sendNotification(BagEvents.REMOVE_SPLIT);
//			SoundManager.PlaySound(SoundList.PANECLOSE);
			for(var i:int = 0; i<MAXPAGE; i++)
			{
				bag["mcPage_"+i].removeEventListener(MouseEvent.CLICK, choiceBagHandler);
			}
			for(var j:int = 0; j<4; j++)
			{
				bag["bagPage_"+j].removeEventListener(MouseEvent.CLICK, choicePageHandler);
				bag["bagPage_"+j].removeEventListener(MouseEvent.MOUSE_OVER, dragMoveHandler);
			}
//			bag.btnSall.removeEventListener(MouseEvent.CLICK, btnClickHandler);
			bag.btnSplit.removeEventListener(MouseEvent.CLICK, btnClickHandler);
//			bag.btnDrop.removeEventListener(MouseEvent.CLICK, btnClickHandler);
			bag.btnDeal.removeEventListener(MouseEvent.CLICK, btnClickHandler);
			bag.sell.removeEventListener(MouseEvent.CLICK, btnClickHandler);
			bag.consignBtn.removeEventListener(MouseEvent.CLICK, btnClickHandler);
			bag.repairBtn.removeEventListener(MouseEvent.CLICK, btnClickHandler);
//			bag.btnUse.removeEventListener(MouseEvent.CLICK, btnClickHandler);	
			gridManager.Gc();
			dataProxy.BagIsOpen = false;
			if(NewerHelpData.newerHelpIsOpen)
				sendNotification(NewerHelpEvent.CLOSE_BAG_NOTICE_NEWER_HELP);		//通知新手帮助系统做关闭类处理
			BagData.SelectPageIndex = 0;
			BagData.SelectIndex = 0;
		}
		
		/** 根据ID对物品解锁  */
		private function bagItemUnLock(id:int):void
		{
//			for(var i:int = 0; i<BagData.AllUserItems.length; i++)
//			{
//				if(i == BagData.SelectIndex)
//				{
		
			for(var j:int = 0; j<BagData.GridUnitList.length; j++)
			{
				if(BagData.GridUnitList[j].Item)
				{
					if(id == BagData.GridUnitList[j].Item.Id)
					{
						BagData.GridUnitList[j].Item.IsLock = false;
					}
				}
			}
//				}
			for(var n:int = 0; n<BagData.AllUserItems[0].length; n++)
			{
				if(BagData.AllUserItems[0][n] == undefined) continue;
				if(id == BagData.AllUserItems[0][n].id)
				{
					BagData.AllLocks[0][n] = false
				}
			}
//			}
		}
		
		private function showBtn(bool:Boolean):void
		{
//			bag.btnSplit.visible = bool;
//			bag.btnDrop.visible = bool;
//			bag.btnUse.visible = bool;
//			if(bool)
//			{
//				if(BagData.SelectedItem.Item)
//				{
//					if(BagData.SelectedItem.Item.Type < 300000)
//					{
//						bag.btnSplit.visible = false;
//					}
//				}
//			}
		}
	}
}