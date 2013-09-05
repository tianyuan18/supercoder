package GameUI.Modules.Rank.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Chat.Data.ChatData;
	import GameUI.Modules.Chat.Data.ChatEvents;
	import GameUI.Modules.Chat.Mediator.QuickSelectMediator;
	import GameUI.Modules.GmTools.Utils.LoadSwfTool;
	import GameUI.Modules.Hint.Events.HintEvents;
	import GameUI.Modules.Rank.Data.RankConstData;
	import GameUI.Modules.Rank.Data.RankEvent;
	import GameUI.Modules.Unity.Data.UnityNumTopChange;
	import GameUI.MouseCursor.SysCursor;
	import GameUI.Proxy.DataProxy;
	import GameUI.View.BaseUI.PanelBase;
	
	import Net.ActionSend.Zippo;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class RankMediator extends Mediator
	{
		public static const NAME:String="RankMediator";
		private static var rankIndex:int;			                                //当前按钮的序号
		
		private var panelBase:PanelBase = null;
		
		private var dataProxy:DataProxy;
		private var ranking:MovieClip;
		private var totalPage  :int = RankConstData.totalPage;                      //总页数 
		private var currentPage:int = 1;					//当前页数					
		private var dataArr:Array;                                                 //接受数据的数组
		private var isSendOver:Boolean = true;										//是否数据接收成功
		
		private var mcContent:Object = new Object();
		public function RankMediator()
		{
			super(NAME);
		}
		private var loadswfTool:LoadSwfTool;
		
		public override function listNotificationInterests():Array
		{
			return [
				EventList.INITVIEW,
			    EventList.SHOWRANKVIEW,       //打开排行榜界面
			    EventList.CLOSERANKVIEW,      //关闭排行榜界面
			    RankEvent.UPDATERANKDATA,  	  //更新数据
			    RankEvent.MYRANK              //我的排行
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case EventList.INITVIEW:
					RankConstData.rankAllListInit();
					dataProxy = facade.retrieveProxy(DataProxy.NAME) as DataProxy;
				break;
				case EventList.SHOWRANKVIEW:
					if(ranking == null){
						loadswfTool = new LoadSwfTool(GameConfigData.RankUI , this);
						loadswfTool.sendShow = initRank;
					}else{
						showRankView();
					}
				  	if(dataProxy.RankIsOpen){
				  		gcAll();
				  	 	return;
				  	}
//				  	sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
				break;
				case EventList.CLOSERANKVIEW:
				    if(dataProxy.RankIsOpen)
				    {
				  	  gcAll();//清理内存
				    }
				    break;
				case RankEvent.UPDATERANKDATA:
				  isSendOver = true;					//传输成功	
				  if(ranking == null)
				  {
				  	RankConstData.rankAllList[rankIndex][currentPage] =  notification.getBody() as Array;
			        return;
				  }
				break;
				case  RankEvent.MYRANK:
				   RankConstData.rankAllList[rankIndex].myRank = ranking.txtmyrank.text;				//缓存
				break;
			}
		}
		
		/**
		 * 初始化设置，（单词） 
		 * @param mc
		 * 
		 */		
		private function initRank(mc:MovieClip):void
		{
			ranking = this.loadswfTool.GetResource().GetClassByMovieClip("Ranking");
			panelBase = new PanelBase(ranking, ranking.width+7, ranking.height+11);                    //创建一个外壳，将ranking添加到外壳里
			panelBase.name = "rankPanel";
			panelBase.SetTitleMc(this.loadswfTool.GetResource().GetClassByMovieClip("SplitIcon"));
			panelBase.addEventListener(Event.CLOSE, rankCloseHandler);
			
			ranking.treeListMc.addEventListener(MouseEvent.CLICK, clickTreeEvent);
			ranking.addEventListener(MouseEvent.MOUSE_MOVE, moveTreeEvent);
			showRankView();
		}
		
		/**
		 * 显示面板 
		 */		
		private function showRankView():void{
			
			ranking.treeListMc.gotoAndStop(1);
			var p:Point = UIConstData.getPos(panelBase.width,panelBase.height);
			panelBase.x = p.x;
			panelBase.y = p.y;
			GameCommonData.GameInstance.GameUI.addChild(panelBase); 
			crrnetTreeIndex = 0;
		}
		
		private var crrnetTreeIndex:int = 0;
		private var beforeTreeLiseMc:MovieClip;
		/**
		 * 点击左侧的树形 
		 * @param e
		 */		
		private function clickTreeEvent(e:MouseEvent):void{
			var param:Array = String(e.target.name).split("_");
			switch(param[0]){
				case "maintree":
					var frameIndex:int = param[1];
					if(crrnetTreeIndex == frameIndex){
						ranking.treeListMc.gotoAndStop(1);
						crrnetTreeIndex = 0;
					}else{
						ranking.treeListMc.gotoAndStop(frameIndex);
						crrnetTreeIndex = frameIndex;
						switch(frameIndex){
							case 2:
								showList(1);
								break
							case 3:
								showList(6);
								break
							case 4:
								showList(8);
								break
							case 5:
								showList(9);
								break
							case 6:
								showList(12);
								break
						}
					}
				break;
				case "treeList":
					var valueIndex:int = param[1];
					showList(valueIndex);
				break;
			}
		}
		
		private var beforeMoveTarget:MovieClip;
		private function moveTreeEvent(e:MouseEvent):void{
			var target:MovieClip = e.target as MovieClip;
			if(target){
				var param:Array = String(target.name).split("_"); 
				if(param[0] == "treeList"){
					if(beforeMoveTarget)
						beforeMoveTarget.gotoAndStop(1);
					target.gotoAndStop(2);
					beforeMoveTarget = target;
				}else{
					if(beforeMoveTarget)
						beforeMoveTarget.gotoAndStop(1);
				}
				if(beforeTreeLiseMc)
					beforeTreeLiseMc.gotoAndStop(2);
			}
		}
		
		/**
		 * 当前数据显示的List mc对象 
		 */		
		private var currentDataListMc:MovieClip;
		/**
		 * 当前展示模型的 mc对象 
		 */		
		private var currnetShowMc:MovieClip;
		private function showList(type:int):void{
			var statusMc:MovieClip = ranking.treeListMc["treeList_"+type] as MovieClip;
			if(beforeTreeLiseMc == statusMc)
				return;
			
			if(beforeTreeLiseMc != null){
				beforeTreeLiseMc.gotoAndStop(1);
			}
			beforeTreeLiseMc = statusMc;
			statusMc.gotoAndStop(2);
			
			
			var data:Object = RankConstData.LAB_POS[type-1];
			//初始化显示数据。设置显示数据
			var listMcName:String = data["mcName"];//显示数据的List模版名称
			var showViewName:String = data["showName"];//显示右侧展示模型模版名称
			
			
			//获取当前的面板
			var dataListTmp:MovieClip = mcContent[listMcName];
			if(dataListTmp == null){
				dataListTmp = this.loadswfTool.GetResource().GetClassByMovieClip(listMcName);
				mcContent[listMcName] = dataListTmp; 
			}
			
			if(currentDataListMc && currentDataListMc != dataListTmp){//移除之前的面板
				currentDataListMc.parent.removeChild(currentDataListMc);
			}
			
			ranking.addChild(dataListTmp);
			dataListTmp.x = 149;
			dataListTmp.y = 60;
			
			currentDataListMc = dataListTmp;
			createListTitle(data);
			
			if(showViewName != null && showViewName != ""){//判断是否存在展示试图
				
				var showTmp:MovieClip = mcContent[showViewName]; 
				if(showTmp == null){
					showTmp = this.loadswfTool.GetResource().GetClassByMovieClip(showViewName);
					mcContent[showViewName] = showTmp;	
				}
				if(currnetShowMc && currnetShowMc != showTmp){//移除之前的面板
					currnetShowMc.parent.removeChild(currnetShowMc);
				}
				ranking.addChild(showTmp);
				showTmp.x = 570;
				currnetShowMc = showTmp;
			}else{//不需要展示的模型数据
				if(currnetShowMc)
					currnetShowMc.parent.removeChild(currnetShowMc);
				
				currnetShowMc = null;
			}
			
			
		}
		/**
		 * 创建List的 title文字显示 
		 * @param data
		 * 
		 * 149 60
		 */		
		private function createListTitle(data:Object):void{
			for (var i:int = 1; i < 7; i++) 
			{
				var name:String = "titile_"+i;
				var txt:TextField = currentDataListMc[name];
				if(txt){
					txt.text = data[name];
				}
			}
			defaultShowList();
		}
		/**
		 * 清空List显示 
		 */		
		private function defaultShowList():void{
			for (var i:int = 1; i < 11; i++) 
			{
				for (var j:int = 1; j < 7; j++) 
				{
					var txt:TextField = currentDataListMc["item_"+i]["txt_"+j];
					if(txt){
						txt.text = "";
					}
				}
				
			}
		}
		
		/** 垃圾回收 */
		private function gcAll():void
		{
			dataProxy.RankIsOpen = false;
		}
		
		private function rankCloseHandler(e:Event):void{
			GameCommonData.GameInstance.GameUI.removeChild(panelBase); 
			
		}
	}
}