package GameUI.Modules.Maket.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.SoundList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Buff.UI.BuffUI;
	import GameUI.Modules.GmTools.Utils.LoadSwfTool;
	import GameUI.Modules.Maket.Data.MarketEvent;
	import GameUI.Modules.Maket.Proxy.MarketNetAction;
	import GameUI.View.items.ImageItemIcon;
	import GameUI.Proxy.DataProxy;
	import GameUI.Sound.SoundManager;
	import GameUI.UIConfigData;
	import GameUI.UIUtils;
	import GameUI.View.BaseUI.PanelBase;
	
	import Net.ActionProcessor.MarketAction;
	import Net.ActionSend.MarketSend;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import mx.utils.StringUtil;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import spark.effects.Move;

	public class MarketMediator extends Mediator
	{
		public static const NAME:String = "MarketMediator";
		
		private var panelBase:PanelBase;
		private var dataProxy:DataProxy;
		
		/** 搜索文本中的内容 */
		private var searchText:String = "";
		private var time:Timer;
		
		public function MarketMediator()
		{
			super(NAME);
		}
		
		private function get marketView():MovieClip
		{
			return viewComponent as MovieClip;
		}
		private var loadswfTool:LoadSwfTool;
		public override function listNotificationInterests():Array
		{
			return [
				EventList.INITVIEW,
				EventList.SHOWMARKETVIEW,
				EventList.CLOSEMARKETVIEW,
				MarketEvent.ADDTO_SHOPCAR_MARKET,
				MarketEvent.BUY_ITEM_MARKET,
				MarketEvent.UPDATE_MONEY_MARKET,
				EventList.UPDATEMONEY,
				MarketEvent.MARKET_STOP_DROG,
				MarketEvent.REC_MARKET_DIS_GOOD,
				MarketEvent.UPDATE_MARKET_GOODS_NUM,
				MarketEvent.UPDATE_COUPONS_BUTTON
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case EventList.INITVIEW:											//初始化
					dataProxy = facade.retrieveProxy(DataProxy.NAME) as DataProxy;
					break;
				case EventList.SHOWMARKETVIEW:										//打开商店(可以直接打开到指定商品页签)
					if(marketView){
						showView();
						//SoundManager.playSoundCanInterrupt(SoundList.OPEN_MARKET_SOUND);
					}else{
						loadswfTool = new LoadSwfTool(GameConfigData.MarketUI , this);
						loadswfTool.sendShow = sendShow;
					}
					break; 
				case EventList.CLOSEMARKETVIEW:										//关闭
					break;
				case MarketEvent.BUY_ITEM_MARKET:									//购买某物品，外部接口
					var goodToBuy:Object = notification.getBody();
					
					if(goodToBuy) {
						_buyItemData = goodToBuy;
						if(marketView){
							buyItem(goodToBuy);
						}else{
							loadswfTool = new LoadSwfTool(GameConfigData.MarketUI , this);
							loadswfTool.sendShow = buyItemShow;
						}
					}
					break;
				case EventList.UPDATEMONEY:
					switch (notification.getBody().target){
						case "mcRmb"://gold
							if(marketView)
								changeTxtInfo();
							break;
						case "mcBindRmb"://goldBind
							if(marketView)
								changeTxtInfo();
							break;
					}
					break;
				case MarketEvent.UPDATE_MONEY_MARKET:
					break;
				case MarketEvent.MARKET_STOP_DROG:									//背包禁止拖动是还原位置	
//					if(panelBase) {
//						panelBase.x = UIConstData.DefaultPos1.x;
//						panelBase.y = UIConstData.DefaultPos1.y;
//						panelBase.IsDrag = false;
//					}
					break;
				case MarketEvent.REC_MARKET_DIS_GOOD:
					var aDiscountGoods:Array = notification.getBody() as Array; 
//					recDisGood( aDiscountGoods );
					break;
				case MarketEvent.UPDATE_MARKET_GOODS_NUM:
					var aNumGoods:Array = notification.getBody() as Array; 
					initSale( aNumGoods );
					break;
				case MarketEvent.UPDATE_COUPONS_BUTTON:
//					uiManager.setCouponsOpen( notification.getBody() as Boolean );
					break;
			}
		}
		private function sendShow(view:MovieClip):void{
			initView();
			sendNotification(EventList.SHOWMARKETVIEW);
		}
		private var _buyItemData:Object;
		private function buyItemShow(view:MovieClip):void{
			initView();
			sendNotification(MarketEvent.BUY_ITEM_MARKET,_buyItemData);
		}
		
		private var viewW:Number;
		private var viewH:Number;
		/**
		 * 永久性初始化页面（只会被初始化一次） 
		 */		
		private function initView():void
		{
			this.setViewComponent(this.loadswfTool.GetResource().GetClassByMovieClip(UIConfigData.MARKETVIEW));
			viewW = marketView.width-136;
			viewH = marketView.height;
			panelBase = new PanelBase(marketView, marketView.width-136, marketView.height);
			panelBase.name = "marketView";
			panelBase.SetTitleMc(this.loadswfTool.GetResource().GetClassByMovieClip("marketTilteName"));
			panelBase.SetTitleDesign();
			panelBase.addEventListener(Event.CLOSE, panelCloseHandler);
			
			this.marketView.addEventListener(MouseEvent.CLICK,markeyViewClickEvent);
			this.marketView.addEventListener(FocusEvent.FOCUS_OUT,chcekTxtContentEvent);
			this.marketView.addEventListener(FocusEvent.FOCUS_IN,foucusInEvent);
			(this.marketView.searchTxt as TextField).addEventListener(Event.CHANGE,searthTxtEvent);
			for (var i:int = 1; i < 7; i++) 
			{
				(this.marketView["buts_"+i] as MovieClip).buttonMode = true;
				(this.marketView["buts_"+i] as MovieClip).mouseChildren = false;
			}
			time = new Timer(1000);
			time.addEventListener(TimerEvent.TIMER,runTimerEvent);
		}
		
		private function runTimerEvent(e:TimerEvent):void{
			
			if(hotDataList != null && hotDataList.length > 0){
				this.hotTime -= 1000;
				if(this.hotTime <= 0 && dataProxy.MarketIsOpen){
					time.stop();
					requestCountData();
					return;
				}
				this.marketView.hotTimeTxt.text = BuffUI.timeChange(hotTime);
				var tf:TextFormat = new TextFormat();
				tf.bold = true;
				tf.color = 0xccff;
				(this.marketView.hotTimeTxt as TextField).setTextFormat(tf);
			}
		}

		/**
		 * 调用显示商城
		 */		
		private function showView():void{
			
			dataProxy.MarketIsOpen = true;
			changeShowType(_currnetType);
			var p:Point = UIConstData.getPos(panelBase.width,panelBase.height);
			panelBase.x = p.x;
			panelBase.y = p.y;
			GameCommonData.GameInstance.GameUI.addChild(panelBase); 
			
			//请求打折信息
			requestCountData();
			relseSearchTxt();
		}
		/**
		 * 点击商场页面，对商城页面的点击对象进行过滤，并且执行对应的操作。 
		 * @param e
		 * 
		 */		
		private function markeyViewClickEvent(e:MouseEvent):void{
			var name:String = e.target.name;
			if(name.indexOf('buts_') == 0){//点击 类别商品按钮，对商品的显示进行切换。
				this._currnetType = int(name.replace("buts_",""));
				beforeType = this._currnetType;
				changeShowType(this._currnetType);
			}else if(name == 'itemBuyBtn'){//点击购买按钮
				buyItemByBtn(e.target as SimpleButton);
			}else if(name == 'addNumBtn' || name =='reduceNumBtn'){
				var type:int = name=='addNumBtn'?1:-1;
				changeNumByBtn(e.target as SimpleButton,type);
			}else if(name == 'downBtn' || name == 'upBtn'){
				var num:int = name=='downBtn'?1:-1;
				changeThePage(num);
			}else if(name == 'hotDownBtn' || name == 'hotUpBtn'){
				var hotnum:int = name=='hotDownBtn'?1:-1;
				changeTheHotPage(hotnum);
			}
		}
		
		/**
		 * 根据当前点击的购买按钮，得到当前需要购买物品的信息
		 * @param btn
		 * 
		 */		
		private function buyItemByBtn(btn:SimpleButton):void{
			var target:Object = btn.parent;//获取父级对象
			if(target.name.indexOf('item_') == 0 || target.name.indexOf('hotitem_') == 0){//对父级对象进行验证，是否是获取到正确的对象。
				var buyItemId:int = int(target.itemIdTxt.text);
				var num:int = int(target.itemNumTxt.text);
				
				var itemData:Object = UIUtils.getGoodsAtMarket(buyItemId);
				var allPrice:int = int(itemData.PriceIn)*num;
				
				var payType:int = 0;
				if(this._currnetType == 6){
					payType = 1;
					if(allPrice > GameCommonData.Player.Role.BindRMB){
//						提示绑定元宝不够
						return;
					}
				}else{
					payType = 0;
					if(allPrice > GameCommonData.Player.Role.UnBindRMB){
						//提示充值.
						return;
					}
				}
				MarketNetAction.buyItem(MarketAction.MARKET_BUY, buyItemId, num, payType);		//发送购买命令
			}
		}
		
		/**
		 * 根据当前点击的增加数量,修改对应的信息  
		 * @param btn
		 * 
		 */		
		private function changeNumByBtn(btn:SimpleButton,type:int):void{
			var target:Object = btn.parent;//获取父级对象
			if(target.name.indexOf('item_') == 0 || target.name.indexOf('hotitem_') == 0){//对父级对象进行验证，是否是获取到正确的对象。
				var num:int = int(target.itemNumTxt.text);
				num+=type;
				if(num < 1)
					num = 1;
				target.itemNumTxt.text = num.toString();
			}
		}
		
		/**
		 * 当失去文本焦点的时候，对文本内的数值进行验证 
		 * @param e
		 * 
		 */		
		private function chcekTxtContentEvent(e:FocusEvent):void{
			var tf:TextField;
			if(e.target.name == 'itemNumTxt'){//
				tf = e.target as TextField;
				var value:int = int(tf.text);
				if(value == 0)
					tf.text = '1';
				else
					tf.text = value+"";
			}
			if(e.target is TextField){
				tf = e.target as TextField;
				if(tf.type == TextFieldType.INPUT){
					GameCommonData.isFocusIn = false;
				}
				if(e.target.name == 'searchTxt'){//商品搜索输入框，失去焦点的时候，对里面的文字进行判断,并且做出不同的处理
					var txt:String = StringUtil.trim(tf.text);
					if(txt == '')
						relseSearchTxt();
				}
			}
		}
		private function foucusInEvent(e:FocusEvent):void{
			if(e.target is TextField){
				var tf:TextField = e.target as TextField;
				if(tf.type == TextFieldType.INPUT){
					GameCommonData.isFocusIn = true;
				}
				if(tf.name == 'searchTxt'){//商品搜索输入框，失去焦点的时候，对里面的文字进行判断,并且做出不同的处理
					relseSearchTxt(0);
				}
			}
		}
		
		/**
		 * 商品搜索输入框处理 
		 * @param type
		 * 
		 */		
		private function relseSearchTxt(type:int = 1):void{
			if(type == 1){
				this.marketView.searchTxt.text = '输入关键字进行搜索';
				(this.marketView.searchTxt as TextField).textColor = 0x8E8C88;
			}else{
				this.marketView.searchTxt.text = '';
				(this.marketView.searchTxt as TextField).textColor = 0xffffff;
			}
		}
		
		private var beforeType:int = 1;
		/**
		 * 搜索输入 
		 * @param e
		 */		
		private function searthTxtEvent(e:Event):void{
			var txt:String = StringUtil.trim(this.marketView.searchTxt.text);
			if(txt == ""){
				_currnetType = beforeType;
				changeShowType(_currnetType);
			}else{
				var dataList:Array  = UIUtils.getGoodsAtMarketByTxt(txt);
				_currnetType = 1;
				if(dataList.length > 0){
					_dataList = dataList;
					showItems(dataList);
				}
			}
		}
		/**
		 * 当前选择显示的种类 
		 * 1新品热卖
		 * 2常用道具
		 * 3宝石护符
		 * 4伙伴坐骑
		 * 5个性装扮
		 * 6绑定专区
		 * -1搜索显示
		 */		
		private var _currnetType:int = 1;
		/**
		 * 记录当前商品显示操作的Mc名称。 
		 */		
		private var _currnetMcName:String = "";
		/**
		 * 根据 _currnetType 状态显示当前商品
		 */		
		private function changeShowType(type:int):void{
			switch(type){
				case 1:
					//热销商品只显示8个，另外加3个显示优惠
					this.marketView["all"].visible = false;
					this.marketView["sale"].visible = true;
					_currnetMcName = "sale";
					maxpage = 8;
					break;
				default:
					this.marketView["all"].visible = true;
					this.marketView["sale"].visible = false;
					_currnetMcName = "all";//通用的，除开显示热销商品
					maxpage = 12;
					break;
			}
			var dataList:Array = UIConstData.MarketGoodList[type];
			_dataList = dataList;
			showBtnState(type);
			showItems(_dataList);
		}
		/**
		 * 根据 _currnetType 状态显示当前选择按钮的状态
		 * @param type
		 */		
		private function showBtnState(type:int):void{
			if(type!=-1){
				for (var i:int = 1; i < 7; i++) 
				{
					if(type == i)
						this.marketView["buts_"+i].gotoAndStop(3);
					else
						this.marketView["buts_"+i].gotoAndStop(1);
				}
			}
			curPage = 1;
		}
		
		private var _dataList:Array;//当前类型显示的数据source
		private var curPage:uint = 0;
		private var pageCount:uint = 0; 
		private var maxpage:uint = 0;
		/**
		 * 显示商品数据 
		 * @param dataList
		 */		
		private function showItems(dataList:Array):void{
			pageCount = Math.ceil(dataList.length/maxpage);
			if(pageCount == 0)
				pageCount = 1;
			var mcPanel:MovieClip = this.marketView[_currnetMcName];
			for (var i:int = 0; i < maxpage; i++) 
			{
				var mcItem:MovieClip = mcPanel["item_"+i];
				var index:int = i+((curPage-1)*maxpage);
				if(index >= dataList.length){//超出商品的显示区域范围，对显示内容进行隐藏
					mcItem.visible = false;
					continue;
				}
				var itemData:Object = dataList[index];
				initItemInfo(mcItem,itemData);
			}
			changeTxtInfo();
		}
		
		/**
		 * 设置当前一个item的显示信息 
		 * @param mc
		 * @param data
		 * 
		 */		
		private function initItemInfo(mc:MovieClip,data:Object):void{
			
			mc.visible = true;
			(mc.itemNumTxt as TextField).restrict = '0-9';
			mc.itemIdTxt.visible = false;
			if(this._currnetType != 6)
				mc.lockKeyMc.visible = false;
			else 
				mc.lockKeyMc.visible = true;
			
			
			if((mc.iconMc as MovieClip).numChildren == 2)
				(mc.iconMc as MovieClip).removeChildAt(1);
			
			if(!data.hasOwnProperty("defaultNum"))
				data.defaultNum = 1;
			mc.itemNameTxt.text = data.Name;//商品名称
			var tf:TextFormat = new TextFormat();
			tf.align = 'center';
			tf.bold = true;
			tf.color = 0xccff;
			(mc.itemNameTxt as TextField).setTextFormat(tf);
			
			mc.priceTxt.text = data.PriceIn;//商品价格
			mc.itemIdTxt.text = data.type;//隐藏的商品ID
			mc.itemNumTxt.text = data.defaultNum;//默认显示的商品数量
			var mii:ImageItemIcon = new ImageItemIcon(data.type);
			mii.name = 'Decompose_'+data.type;
			(mc.iconMc as MovieClip).addChild(mii);
		}
		
		/**
		 * 根据当前的状态，显示对应文本显示信息 
		 */		
 		private function changeTxtInfo():void{
			this.marketView.pageInfoTxt.text = this.curPage+"/"+this.pageCount;
			this.marketView.glodTxt.text = GameCommonData.Player.Role.UnBindRMB;
			this.marketView.unglodTxt.text = GameCommonData.Player.Role.BindRMB;
		}
		/**
		 * 翻页 
		 */		
		private function changeThePage(type:int):void{
			this.curPage += type;
			if(this.curPage >0 && this.curPage <= this.pageCount){
				changePageUpdate();
			}else{
				this.curPage -= type;
			}
		}
		/**
		 * 翻页更新对应的显示信息 
		 */		
		private function changePageUpdate():void{
			showItems(_dataList);
		}
		
		///////////////////////////////////////////////////////////////////////////////及时抢购代码
		private var hotDataList:Array;
		/**
		 * 初始化及时抢购数据 
		 * 
		 */		
		private function initSale(value:Array):void{
			hotDataList = value;
			hotCurPage = 1;
			saleItems(hotDataList);
			time.start();
		}
		private var hotCurPage:int = 1;
		private var hotCountPage:int = 1;
		private var hotMaxPage:int = 3;
		/**
		 * 显示热销产品信息(热销右侧的独立信息)
		 */		
		private function saleItems(hotDataList:Array):void{
			if(hotDataList == null)
				hotDataList = [];
			hotCountPage = Math.ceil(hotDataList.length/hotMaxPage);
			if(hotCountPage == 0)
				hotCountPage = 1;
			var mcPanel:MovieClip = this.marketView[_currnetMcName];
			for (var i:int = 0; i < hotMaxPage; i++) 
			{
				var mcItem:MovieClip = mcPanel["hotitem_"+i];
				var index:int = i+((hotCurPage-1)*hotMaxPage);
				if(index >= hotDataList.length){//超出商品的显示区域范围，对显示内容进行隐藏
					mcItem.visible = false;
					continue;
				}
				mcItem.visible = true;
				

				(mcItem.itemNumTxt as TextField).restrict = '0-9';
				mcItem.itemIdTxt.visible = false;
				var itemData:Object = hotDataList[index];
				var baseItemData:Object = UIUtils.getGoodsAtMarket(itemData.type);
				itemData.Name = baseItemData.Name;
				itemData.PriceIn = baseItemData.PriceIn;
				hotTime = itemData.time;
				initItemInfo(mcItem,itemData);
				mcItem.hotpriceTxt.text = itemData.price;
			}
			changeHotTxtInfo();
		}
		
		private var hotTime:Number;
		/**
		 * 及时抢购翻页显示 
		 * 
		 */		
		private function changeHotTxtInfo():void{
			this.marketView.sale.hotPageTxt.text = hotCurPage+"/"+hotCountPage;
		}
		/**
		 * 及时抢购翻页  
		 * @param type
		 */		
		private function changeTheHotPage(type:int):void{
			hotCurPage += type;
			if(hotCurPage >0 && hotCurPage <= hotCountPage){
				saleItems(hotDataList);//翻页后，刷新显示数据
			}else{
				this.curPage -= type;
			}
		}
		private function panelCloseHandler(e:Event):void{
			this._currnetType = 1;
			this.beforeType = 1;
			dataProxy.MarketIsOpen = false;
			GameCommonData.GameInstance.GameUI.removeChild(panelBase); 
		}
		
		
		private var littleBuyPanel:PanelBase;
		private var littleMarketView:MovieClip;
		/** 外部接口，购买商品 */
		private function buyItem(good:Object):void
		{
			var type:uint	 = good.type;		//商品typeId
			var count:uint 	 = good.count;		//购买数量
			var payType:uint = good.payType;	//支付方式
			
			if(littleBuyPanel == null){
				littleMarketView = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip(UIConfigData.LITTLEMARKETVIEW);
				littleBuyPanel = new PanelBase(littleMarketView, littleMarketView.width-2, littleMarketView.height-30);
				littleBuyPanel.name = "QuickBuyView";
				littleBuyPanel.SetTitleDesign();
				littleBuyPanel.addEventListener(Event.CLOSE, littlePanelCloseHandler);
				littleMarketView.itemIdTxt.visible = false;
			}
			
			littleMarketView.itemIdTxt.text = type;
			var itemData:Object = UIUtils.getGoodsAtMarket(type);
			itemData.defaultNum = count;
			
			initItemInfo(littleMarketView,itemData);
			
			littleBuyPanel.x = (GameCommonData.GameInstance.MainStage.stageWidth - littleMarketView.width)/2;
			littleBuyPanel.y =  (GameCommonData.GameInstance.MainStage.stageHeight - littleMarketView.height)/2;
			
			GameCommonData.GameInstance.GameUI.addChild(littleBuyPanel);
		}
		

		private function littlePanelCloseHandler(e:Event):void{
			GameCommonData.GameInstance.GameUI.removeChild(littleBuyPanel);
		}
		
		
		
		//请求打折商品信息
		private function requestCountData():void
		{
			if(this.hotTime <= 0)
				sendDataToServer();
			else
				sendNotification( MarketEvent.UPDATE_MARKET_GOODS_NUM,hotDataList);
		}
		private function sendDataToServer():void
		{
			MarketSend.inquiresDiscount();
		}
	}
}
