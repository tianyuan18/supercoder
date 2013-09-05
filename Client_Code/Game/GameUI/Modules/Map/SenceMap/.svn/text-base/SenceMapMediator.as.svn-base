package GameUI.Modules.Map.SenceMap
{
	import Controller.PlayerController;
	
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Hint.Events.HintEvents;
	import GameUI.Modules.Map.SmallMap.SmallMapConst.SmallConstData;
	import GameUI.Modules.NewerHelp.Data.NewerHelpData;
	import GameUI.Modules.NewerHelp.Data.NewerHelpEvent;
	import GameUI.Modules.Task.Commamd.MoveToCommon;
	import GameUI.Proxy.DataProxy;
	import GameUI.UIConfigData;
	import GameUI.UIUtils;
	import GameUI.View.BaseUI.PanelBase;
	import GameUI.View.Components.LoadingView;
	import GameUI.View.Components.UIScrollPane;
	import GameUI.View.Components.UISprite;
	import GameUI.View.ResourcesFactory;
	
	import Net.ActionSend.PlayerActionSend;
	import Net.Protocol;
	
	import OopsEngine.AI.PathFinder.MapTileModel;
	
	import OopsFramework.Content.Provider.BulkLoaderResourceProvider;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.getClassByAlias;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class SenceMapMediator extends Mediator
	{
		public static const NAME:String = "SenceMapMediator";
		public var drawMapFunction:Function;
		private var dataProxy:DataProxy;
		private var panelBase:PanelBase = null;
		
		private var symbolLayer:Bitmap;                             //标记层
		private var mapLayer:Bitmap;                                //地图层
		private var loader:BulkLoaderResourceProvider;
		private var senceMapContainer:MovieClip;
		private var mapContainer:Sprite  							//地图容器
		
		
		private var minWidth:Number =560;							//场景地图最小Width
		private var minHeight:Number = 370;							//场景地图最小Height
		
		private var npcInitPosX:Point = new Point(5,116);
		private var transInitPosX:Point = new Point(5,32);
		private var _containerNpc:UISprite;
		private var _scrollPaneNpc:UIScrollPane;
//		private var mapControl:MovieClip;		                    //功能MC		
		private var closeBtn:SimpleButton;							//关闭按钮
		private var scenceName:String;                              //场景名称,这个不一定是人物所在场景，可以是世界地图中选中的场景
		private var scenceXML:XML=null;							//小地图显示场景对应XML
		private var pathSprite:UISprite;                            //路径显示图
		private var corner:MovieClip;
		private var mapInfo:MovieClip;
		private var bigMap:MovieClip;
		
		private var isCurrentScene:Boolean=false;
		private var SceneMapBg:MovieClip;
		
		private var SenceMapBtn:MovieClip;

		private var mapLayerContainer:Sprite;
		
		private var SmapBtn:MovieClip;
		
		private var sName:String;
		
		private var playerIcon:MovieClip;                          //玩家标记图标
		private const direction:Array=[0,-27,-90,-153,0,0,180,27,90,153];       
		private var flag:Boolean=true;                            //导航地图路线是否显示的标识
		/** 是否正在进行预加载*/
		private var isProLoading:Boolean;
		private var isLoading:Boolean;
		
		private var mapImgDic:Dictionary=new Dictionary();
		
		private var npcList:Array = new Array();
		private var transList:Array = new Array();

		private var maxNumMap:uint=9;
		
		private var mapPos:Point = null;
		private var timer:Timer;
		
		private var btnTypeReturn:int = 0; //按钮功能类型，判断是返回功能，还是寻路功能
		
		public function SenceMapMediator()
		{
			super(NAME);
		}
		
		//		public function get DrawMapFunction():Function
		//		{
		//			flag = true;
		//			return drawMapFunction;
		//		}
		
		//边框层
		private function get SenceMap():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				EventList.INITVIEW,
				EventList.SHOWSENCEMAP,
				EventList.CLOSESCENEMAP,
				EventList.UPDATE_SMALLMAP_DATA,
				EventList.UPDATE_SMALLMAP_PATH,
				EventList.CHANGE_SCENEMAP_EVENT,
				EventList.SHOWBIGMAP,
				EventList.SHOW_SCENE_TEAMINFO
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case EventList.INITVIEW:
					
					dataProxy = facade.retrieveProxy(DataProxy.NAME) as DataProxy;
					drawMapFunction = this.drawPath;
					//facade.sendNotification(EventList.GETRESOURCE, {type:UIConfigData.MOVIECLIP, mediator:this, name:UIConfigData.SENCEMAP});
					//(this.viewComponent as DisplayObjectContainer).mouseEnabled=false;
					//功能控制层
//					mapControl=GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("ControlBg");
//					mapControl.mouseEnabled=false;
					//					(mapControl.btn_forceChar as SimpleButton).addEventListener(MouseEvent.CLICK,onForceCharClick);
					
					//背景层
					SceneMapBg=GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("SenceMapBg");
					SceneMapBg.mouseEnabled=false;
					SceneMapBg.y += 20;
					mapInfo=GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("mapInfo");
					mapInfo.mouseEnabled = false;
					mapInfo.visible = false;
					mapInfo.x = SceneMapBg.x + SceneMapBg.width + 5;
					mapInfo.y = SceneMapBg.y;
					SenceMapBtn = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("SenceMapBtn");
					SenceMapBtn.mouseEnabled = false;
//					(mapControl.btn_bigMap as SimpleButton).addEventListener(MouseEvent.CLICK,onBigMapChangeHandler);
//					optionControl = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("OptionSymbol");
//					coordControl = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("CoordSymbol");
					corner = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("corner");

					corner.mouseEnabled = false;
					corner.mouseChildren = false;
//					corner.visible = false;

//					coordControl.btn_translation.addEventListener(MouseEvent.CLICK,onTranslationClick);
					senceMapContainer = new MovieClip();
					senceMapContainer.name = "senceMapContainer";
					senceMapContainer.mouseEnabled = false;
					mapContainer = new Sprite();
//					mapContainer.buttonMode = true;
					mapLayerContainer=new Sprite();
					mapLayerContainer.mouseEnabled=false;
					mapContainer.mouseEnabled=false;
					this.playerIcon=GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("SelfPos");
					this.senceMapContainer.addChild(mapInfo);
					
					this.senceMapContainer.addChild(SceneMapBg);
					this.senceMapContainer.addChild(mapLayerContainer);
					//this.senceMapContainer.addChild(SenceMap);
					this.senceMapContainer.addChild(this.mapContainer);
//					this.mapLayerContainer.addChild(this.mapContainer);
					this.senceMapContainer.addChild(SenceMapBtn);
//					this.senceMapContainer.addChild(mapControl);
					this.senceMapContainer.addChild(corner);
					//this.senceMapContainer.addChild(closeBtn);
					
					SmapBtn = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("fx");
					SmapBtn.buttonMode = true;
					SmapBtn.visible = false;
					SmapBtn.addEventListener(MouseEvent.CLICK,onTranslationClick);
					
					
					var x:int = SceneMapBg.position.mapX.text;
					var y:int = SceneMapBg.position.mapX.text;
					
					SceneMapBg.position.addEventListener(FocusEvent.FOCUS_OUT,chcekTxtContentEvent);
					SceneMapBg.position.addEventListener(FocusEvent.FOCUS_IN,foucusInEvent);
					
//					this.senceMapContainer.addChild(SmapBtn);
					
					this._containerNpc=new UISprite();
					this._containerNpc.width=mapInfo.width-10;
//					this._containerNpc.height = 270;
					if(!timer){
						timer = new Timer(500,1);
					}
					break;
				case EventList.SHOWSENCEMAP:
					SmapBtn.visible = false;
					if(this.isLoading){
						return;
					}
					this.isLoading=true;
//					LoadingView.getInstance().showLoading();
					if(notification.getBody()==null){
						this.isCurrentScene=true;
						if(flag){
							GameCommonData.Player.SMapPathUpdate=drawPath;
						}
						this.scenceName=GameCommonData.GameInstance.GameScene.GetGameScene.name;
						this.pathSprite=new UISprite();
					}else{
						this.pathSprite=new UISprite();
						this.isCurrentScene=false;
						this.scenceName=notification.getBody().toString();
					}
					
					if(dataProxy.BigMapIsOpen){
						sendNotification(EventList.CLOSEBIGMAP);
					}
					
					dataProxy.SenceMapIsOpen=true;
					loadMap();
					SceneMapBg.visible = true;
					break;
				case EventList.CLOSESCENEMAP:
					if(this.isLoading)return;
					panelCloseHandler(null);
					this.closeMap(null);
					dataProxy.BigMapIsOpen = false;
					break;
				case EventList.UPDATE_SMALLMAP_DATA:
					
					if(dataProxy.SenceMapIsOpen==false || this.isCurrentScene==false)return;
					var obj:Object=notification.getBody();
					var type:uint=obj.type;    
					var id:uint=obj.id;
					if(type==5 && this.playerIcon!=null){
						this.changePlayerPos();
					}
					if(type==6 && this.playerIcon!=null){
						this.changePlayerDirection();
					}
					break;	
				
				case EventList.UPDATE_SMALLMAP_PATH:
					var pathType:uint=uint(notification.getBody());
					if(pathType==0 || pathType==1){
						this.flag=false;
						if(this.pathSprite!=null){
							pathSprite.graphics.clear();
						}
					}else if(pathType==2){
						if(this.flag){
							this.drawPath();
						}
					}else if(pathType==3){
						this.changePath();
					}
					break;
				//切换场景地图进行预加载	
				case EventList.CHANGE_SCENEMAP_EVENT:
//					var o:Object = this.mapImgDic;
//					sName=GameCommonData.GameInstance.GameScene.GetGameScene.name;
					if(/*this.mapImgDic[sName]!=null &&*/dataProxy.SenceMapIsOpen&&!this.isProLoading){
//						this.isProLoading=true;
//						sName=GameCommonData.GameInstance.GameScene.GetGameScene.name;
//						loader=new BulkLoaderResourceProvider();
//						loader.Download.Add(GameCommonData.GameInstance.Content.RootDirectory + "Scene/"+sName+"/SceneMapBottom.jpg");
//						loader.Download.Add(GameCommonData.GameInstance.Content.RootDirectory + "Scene/"+sName+"/SceneMapTop.png");
//						loader.LoadComplete=onPreLoadComplete
////						loader.LoadComplete=onLoaderComplete;
//						loader.Download.Load()
						closeMap();
						(SenceMapBtn.btn_current as MovieClip).gotoAndStop(3);
						(SenceMapBtn.btn_current as MovieClip).mouseEnabled = false;
						(SenceMapBtn.btn_world as MovieClip).gotoAndStop(1);
						(SenceMapBtn.btn_world as MovieClip).mouseEnabled = true;
						dataProxy.BigMapIsOpen = false;
						var xt:int = panelBase.x;
						var yt:int = panelBase.y;
						panelCloseHandler(null);
						this.closeMap(null);
						facade.sendNotification(EventList.SHOWSENCEMAP);
						panelBase.x = xt;
						panelBase.y = yt;
					}
					break;	
				case EventList.SHOW_SCENE_TEAMINFO:
					this.showTeamerScale(notification.getBody() as Array);
					break;	
				case EventList.CLOSE_NPC_ALL_PANEL:
					
					panelCloseHandler(null);
					
					break;
				
				
				case EventList.SHOWBIGMAP:
//					closeMap();
					if(!this.bigMap)
					{
						ResourcesFactory.getInstance().getResource(GameCommonData.GameInstance.Content.RootDirectory + "Resources/GameDLC/BigMap.swf",onLoadComplete);
						LoadingView.getInstance().showLoading();
					}
					else{
						this.showBigMap();
					}
					SceneMapBg.visible = false;
					break;
			}	
		}
		/**
		 * 势力分析图  
		 * @param e
		 * 
		 */		
		protected function onForceCharClick(e:MouseEvent):void{
			facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_map_sen_sen_onF" ], color:0xffff00});//"此功能还未开放" 
		}
		
		
		/**
		 * 传送 
		 * @param e
		 * 
		 */		
		protected function onTranslationClick(e:MouseEvent):void
		{
			if(timer.running) {
				return;
			}
			var xyNode:Array = GameCommonData.Player.PathTileXY;
			var targetPos:Point=null;
			if(this.isCurrentScene)
			{
				var xyList:Array = xyNode[xyNode.length-1]; 
				if(xyList != null){
					
					targetPos = new Point;
					targetPos.x = xyList[0];
					targetPos.y = xyList[1];
				}
				
			}else
			{
				var clickStagePoint:Point = new Point(this.pathSprite.mouseX/getRatio(),this.pathSprite.mouseY/getRatio());
				var pos:Point = GetTileStageToPoint(clickStagePoint.x,clickStagePoint.y);
				targetPos = pos;
			}
			if(targetPos)
			{
				if(MoveToCommon.FlyTo(uint(this.scenceName),targetPos.x,targetPos.y,0,0))
				{
					SmapBtn.visible = false;
					e.stopImmediatePropagation();
					e.stopPropagation();
					timer.reset();
					timer.start();
				}
			}
		}
		
		/**
		 * 当失去文本焦点的时候，对文本内的数值进行验证 
		 * @param e
		 * 
		 */		
		private function chcekTxtContentEvent(e:FocusEvent):void{
			var tf:TextField;
			if(e.target is TextField){
				tf = e.target as TextField;
				if(tf.type == TextFieldType.INPUT){
					GameCommonData.isFocusIn = false;
				}
			}
		}
		private function foucusInEvent(e:FocusEvent):void{
			if(e.target is TextField){
				var tf:TextField = e.target as TextField;
				if(tf.type == TextFieldType.INPUT){
					GameCommonData.isFocusIn = true;
				}
			}
		}
		
		protected function onPreLoadComplete():void{
			if(!this.isProLoading)return;
			var map:Bitmap = loader.GetResource(GameCommonData.GameInstance.Content.RootDirectory  + "Scene/" + sName + "/SceneMapBottom.jpg").GetBitmap();
			var symbol:Bitmap =loader.GetResource(GameCommonData.GameInstance.Content.RootDirectory + "Scene/" + sName + "/SceneMapTop.png").GetBitmap();
			scenceXML = loader.GetResource(GameCommonData.GameInstance.Content.RootDirectory + "Scene/" + sName + "/Config.xml").GetXML();
			this.mapImgDic[sName]={mapLayer:map,symbolLayer:symbol,map:scenceXML};
			this.isProLoading=false;
			loadMap();
		}
		
		protected function onBigMapChangeHandler(e:MouseEvent):void{
//			if(GameCommonData.GameInstance.GameScene.GetGameScene.name=="1026"){
//				return;
//			}
			
			this.panelCloseHandler(null);
			sendNotification(EventList.SHOWBIGMAP);
		}
		
		private var clickTilePoint:Point = new Point();
		
		/**
		 * 点击地图事件
		 */ 
		protected function onSmallClickHandler(e:MouseEvent):void{
			GameCommonData.isAutoPath=false;
			GameCommonData.IsMoveTargetAnimal = false;
			this.flag=true;
			this.pathSprite.graphics.clear();
			
			var clickStagePoint:Point = new Point(this.pathSprite.mouseX/getRatio(),this.pathSprite.mouseY/getRatio());
			var tilePoint:Point = MapTileModel.GetTileStageToPoint(clickStagePoint.x,clickStagePoint.y);
			
//			var x:int = tilePoint.x;
//			var y:int = tilePoint.y;
//			var map:Array = GameCommonData.GameInstance.GameScene.GetGameScene.Map.Map;
//			var mapWidth : int = map.length;
//			var mapHeight : int = map[0].length;
//			var pos:int = map[x][y];
//			trace("x="+x+"  y="+y+" pos="+pos);
//			if(pos == 0 || pos == 2)
//			{
			
			clickTilePoint = tilePoint
			
			
			if(this.isCurrentScene)
			{
				GameCommonData.Scene.MapPlayerMove(clickStagePoint,0,scenceName);
				GameCommonData.Player.SMapPathUpdate = drawPath;
				PlayerController.EndAutomatism();
				var nodes:Array = GameCommonData.Player.PathMap;
				if(nodes == null) return;
				var lastPoint:Point = nodes[nodes.length-1] as Point;
				if(lastPoint)
				{
					var smapPoint:Point = new Point(lastPoint.x*getRatio(),lastPoint.y*getRatio());
					var xyNode:Array = GameCommonData.Player.PathTileXY;
					var xyList:Array = xyNode[xyNode.length-1]; 
					clickTilePoint = new Point(xyList[0],xyList[1]);
					SmapBtn.x = smapPoint.x-10;
					SmapBtn.y=  smapPoint.y-5; 
					SmapBtn.visible = true;	
				}
			}else
			{
				tilePoint = GetTileStageToPoint(clickStagePoint.x,clickStagePoint.y);
				
				var index:int = tilePoint.x*this.mapImgDic[scenceName].map.col+tilePoint.y;
				var pos:int = this.mapImgDic[scenceName].map.mapData[index];
				if(pos == 0 || pos == 2 || pos == 5)
				{
					SmapBtn.x = this.pathSprite.mouseX-10;
					SmapBtn.y=  this.pathSprite.mouseY-5; 
					SmapBtn.visible = true;
					GameCommonData.Scene.MapPlayerMove(clickStagePoint,0,scenceName);
					PlayerController.EndAutomatism();
					
				}
			}
					
//			}
				
		}

		/**
		 * 绘制寻路路线
		 */
		protected function drawPath():void{
			if(flag && this.isCurrentScene)
			{
				var path:Array=GameCommonData.Player.PathMap;	
				if(pathSprite==null)
					return;
				this.pathSprite.graphics.clear();
				if(path==null)return;
				this.pathSprite.graphics.beginFill(0xff0000,1);
				var len:uint=path.length;
				for(var i:uint=0;i<len;i++){
					pathSprite.graphics.drawCircle(path[i].x*getRatio(),path[i].y*getRatio(),1);
				}
				this.pathSprite.graphics.endFill();
			}
		}
		protected function changePath():void{
			SmapBtn.visible = false;
		}
		
		/** 改变位置*/
		private function changePlayerPos():void{
			this.playerIcon.x=uint(GameCommonData.Player.GameX*getRatio());
			this.playerIcon.y=uint(GameCommonData.Player.GameY*getRatio());
		}
		
		/**改变方向 */
		private function changePlayerDirection():void{
			this.playerIcon.rotation=this.direction[GameCommonData.Player.Role.Direction];
		}
		
		private function loadMap():void
		{
			
			if(this.mapImgDic[scenceName]!=null){
				this.processMap();
				return;
			}
			if(GameCommonData.GameInstance.GameScene.GetGameScene.name==scenceName && this.isProLoading){
				this.isProLoading=false;
			}
			loader=new BulkLoaderResourceProvider();
			loader.Download.Add(GameCommonData.GameInstance.Content.RootDirectory + "Scene/"+scenceName+"/SceneMapBottom.jpg");
			loader.Download.Add(GameCommonData.GameInstance.Content.RootDirectory + "Scene/"+scenceName+"/SceneMapTop.png");
			loader.Download.Add(GameCommonData.GameInstance.Content.RootDirectory + "Scene/"+scenceName+"/Config.xml");
			loader.Download.Load()
			loader.LoadComplete=onLoaderComplete;
			LoadingView.getInstance().showLoading();
		}
		
		private function onLoaderComplete():void
		{
			var map:Bitmap = loader.GetResource(GameCommonData.GameInstance.Content.RootDirectory  + "Scene/" + scenceName + "/SceneMapBottom.jpg").GetBitmap();
			var symbol:Bitmap =loader.GetResource(GameCommonData.GameInstance.Content.RootDirectory + "Scene/" + scenceName + "/SceneMapTop.png").GetBitmap();
			scenceXML = loader.GetResource(GameCommonData.GameInstance.Content.RootDirectory + "Scene/" + scenceName + "/Config.xml").GetXML();
			var mapInfoData:Object = new Object();
			var mapData:Array = [];
			var area:String     = scenceXML.Floor.text();
			var areaArray:Array = area.split(",");
			var row:int = scenceXML.Floor.@Row;
			var col:int = scenceXML.Floor.@Col;
			var OFFSET_TAB_X:int = scenceXML.Floor.@OffsetX;
			var OFFSET_TAB_Y:int = scenceXML.Floor.@OffsetY;
			for(var i:uint = 0 ; i < row ; i++)
			{
//				mapData[i] = new Array();
				for(var j:uint = 0 ; j < col ; j++)		// 每一次存两格数据
				{
//					mapData[i][j] = areaArray[i * col + j];
					mapData[i * col + j] = areaArray[i * col + j];
				}
			}
			var scale:Number = scenceXML.@Scale;
			mapInfoData.mapData = mapData;
			mapInfoData.scale = scale;
			mapInfoData.OFFSET_TAB_X = OFFSET_TAB_X;
			mapInfoData.OFFSET_TAB_Y = OFFSET_TAB_Y;
			mapInfoData.col = col;
			this.mapImgDic[scenceName]={mapLayer:map,symbolLayer:symbol,mapXML:scenceXML,map:mapInfoData};
			processMap();
		}
		
		private function processMap():void{
			
			mapLayer = this.mapImgDic[scenceName].mapLayer;
			symbolLayer=this.mapImgDic[scenceName].symbolLayer;
//			scenceXML = this.mapImgDic[scenceName].map.scale;
			initMap();
		}
		
		
		private function initMap():void
		{		
			while(this.mapLayerContainer.numChildren>0){
				this.mapLayerContainer.removeChildAt(0);
			}
			while(this.mapContainer.numChildren>0){
				this.mapContainer.removeChildAt(0);     
			}
			
			symbolLayer.x = mapLayer.x = corner.width/2 - mapLayer.width/2;
			symbolLayer.y = mapLayer.y = corner.height/2 - mapLayer.height/2;
			mapContainer.x = mapLayer.x+10;
			mapContainer.y = mapLayer.y+28;
			
			this.mapLayerContainer.addChild(mapLayer);
//			this.mapContainer.addChild(symbolLayer);
			this.mapLayerContainer.addChild(symbolLayer);
			
			/** 加载按钮事件 */
			if(dataProxy.BigMapIsOpen)
			{
				(SenceMapBtn.btn_current as MovieClip).gotoAndStop(1);
				(SenceMapBtn.btn_world as MovieClip).gotoAndStop(3);
				
				(SenceMapBtn.btn_current as MovieClip).mouseEnabled = true;
				(SenceMapBtn.btn_world as MovieClip).mouseEnabled = false;
			}
			else
			{
				(SenceMapBtn.btn_current as MovieClip).gotoAndStop(3);
				(SenceMapBtn.btn_world as MovieClip).gotoAndStop(1);
				
				(SenceMapBtn.btn_current as MovieClip).mouseEnabled = false;
				(SenceMapBtn.btn_world as MovieClip).mouseEnabled = true;
			}
			
			(SenceMapBtn.btn_current as MovieClip).addEventListener(MouseEvent.CLICK,onSelectMapMode);
			(SenceMapBtn.btn_world as MovieClip).addEventListener(MouseEvent.CLICK,onSelectMapMode);
			(SceneMapBg.find as SimpleButton).addEventListener(MouseEvent.CLICK,onShowMapInfo);

			if(dataProxy.BigMapIsOpen)
			{
				(SceneMapBg.position as MovieClip).visible = false;
				SceneMapBg.btnName.text = "返回世界地图";
				btnTypeReturn = 1;
			}
			else
			{
				(SceneMapBg.position as MovieClip).visible = true;
				(SceneMapBg.position as MovieClip).mouseEnabled = false;
				SceneMapBg.position.mapX.text = "";
				SceneMapBg.position.mapY.text = "";
				SceneMapBg.btnName.text = "自动寻路";
				btnTypeReturn = 0;
			}
			SceneMapBg.btnName.mouseEnabled = false;
			SceneMapBg.btnFunc.addEventListener(MouseEvent.CLICK,onFindPath);
			
			clearMapNpc();

			npcList = new Array();
			transList = new Array();
			var xml:XML;
			if(this.isCurrentScene)
			{
				xml = GameCommonData.GameInstance.GameScene.GetGameScene.ConfigXml;
			}else
			{
				xml = this.mapImgDic[scenceName].mapXML;
			}
			this._containerNpc.height = 0;
			var textField:TextField;
			var name:String;
			for(var i:int = 0; i< xml.Location.length();i++)
			{
				var npc:Object = new Object();
				
//				npc.Name = xml.Location[i].Name;
				npc.X = int(xml.Location[i].@X);
				npc.Y = int(xml.Location[i].@Y);
				textField = new TextField();		
				name = String(xml.Location[i].@Name);
				textField.htmlText = "<font color='#FFFFFF'>"+name+"</font>";
				npc.transBtn = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByButton("transBtn");
				textField.x = 10;
				textField.y = 28*i;
				npc.transBtn.x = 90;
				npc.transBtn.y = 28*i;
				npc.textField = textField;
				npc.transBtn.name = i;
				this._containerNpc.height += 28;
				npc.transBtn.addEventListener(MouseEvent.CLICK,onFlyTo);
				this._containerNpc.addChild(npc.textField);
				this._containerNpc.addChild(npc.transBtn);
				npcList.push(npc);
			}

			for(i = 0; i< xml.Element.length();i++)
			{
				var trans:Object = new Object();
				trans.Name = xml.Element[i].Name;
				trans.X = int(xml.Element[i].@X);
				trans.Y = int(xml.Element[i].@Y)+1;
				
				textField = new TextField();		
				name = String(xml.Element[i].@Name);
				textField.htmlText = "<font color='#FFFFFF'>"+name+"</font>";
				trans.transBtn = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByButton("transBtn");
				textField.x = 10+this.transInitPosX.x;
				textField.y = 28*i + this.transInitPosX.y;
				trans.transBtn.x = 90+this.transInitPosX.x;
				trans.transBtn.y = 28*i+ this.transInitPosX.y;
				trans.textField = textField;
				trans.transBtn.name = i;
				trans.transBtn.addEventListener(MouseEvent.CLICK,onFlyToTrans);
				
				transList.push(trans);
				mapInfo.addChild(trans.textField);
				mapInfo.addChild(trans.transBtn);
			}
			
			this._scrollPaneNpc=new UIScrollPane(this._containerNpc);
			this._scrollPaneNpc.setHideType(0);
			this._scrollPaneNpc.mouseEnabled=false;
			this._scrollPaneNpc.width=this._containerNpc.width; 
			this._scrollPaneNpc.height=270;
			this._scrollPaneNpc.x=this.npcInitPosX.x; 
			this._scrollPaneNpc.y=this.npcInitPosX.y;
			this._scrollPaneNpc.scrollPolicy=UIScrollPane.SCROLLBAR_AS_NEEDED;
			mapInfo.addChild(this._scrollPaneNpc);
			this._scrollPaneNpc.refresh();
			
//			if(this.isCurrentScene){
				this.mapContainer.addChild(this.pathSprite);
				mapContainer.mouseEnabled = false;
				if(GameCommonData.Player.Role.idTeam>0){	
					this.getTeamPosAction();
				}
				if(this.isCurrentScene)
				{
					var pos:Point=new Point(uint(GameCommonData.Player.GameX*getRatio()),uint(GameCommonData.Player.GameY*getRatio()));
					this.pathSprite.addChild(this.playerIcon);
					this.playerIcon.x=pos.x;
					this.playerIcon.y=pos.y;
					this.pathSprite.addEventListener(MouseEvent.MOUSE_MOVE,onPathSpriteMove);
					this.pathSprite.addEventListener(MouseEvent.ROLL_OUT,onRollOutPathSprite);
				}	
				
				this.pathSprite.addEventListener(MouseEvent.CLICK,onSmallClickHandler);
				this.pathSprite.mouseEnabled=true;
				this.pathSprite.buttonMode = true;
				this.pathSprite.addChild(SmapBtn);
//			}
//						SenceMap.addEventListener(MouseEvent.MOUSE_DOWN, senceMapStart);
			this.doLayout();
		}
		
		private function clearMapNpc():void
		{
			for(var i:int = 0;i<npcList.length; i++)
			{
				if(this._containerNpc.contains(npcList[i].textField))
				{
					this._containerNpc.removeChild(npcList[i].textField);
				}
				if(this._containerNpc.contains(npcList[i].transBtn))
				{
					this._containerNpc.removeChild(npcList[i].transBtn);
				}
				npcList[i].transBtn.removeEventListener(MouseEvent.CLICK,onFlyTo);
			}
			
			for(i = 0;i<transList.length; i++)
			{
				if(this.mapInfo.contains(transList[i].textField))
				{
					this.mapInfo.removeChild(transList[i].textField);
				}
				if(this.mapInfo.contains(transList[i].transBtn))
				{
					this.mapInfo.removeChild(transList[i].transBtn);
				}
			}
			
			if(this._scrollPaneNpc&&mapInfo.contains(this._scrollPaneNpc))
			{
				this._scrollPaneNpc.refresh();
				mapInfo.removeChild(this._scrollPaneNpc);
			}
		}
		
		/**
		 * 显示同场景的队友信息 
		 * @param list
		 * 
		 */		
		protected function showTeamerScale(list:Array):void{
			var len:uint=list.length;
			if(this.pathSprite==null)return;
			for(var i:uint=0;i<len;i++){
				var point:MovieClip=GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("BigBulePoint");   //队友
				var pos:Point=MapTileModel.GetTilePointToStage(list[i].nPosX,list[i].nPosY);
				this.pathSprite.addChild(point);
				point.x=Math.floor(pos.x*getRatio());
				point.y=Math.floor(pos.y*getRatio());
				point.name="SMALLMAP_"+list[i].memName;
			}
		}
		
		/**
		 *   获取队友位置信息action
		 * 
		 */		
		protected function getTeamPosAction():void{
			var obj:Object = new Object();
			obj.type = Protocol.PLAYER_ACTION;
			obj.data = new Array();
			obj.data.push(0);
			obj.data.push(0);
			obj.data.push(0);
			obj.data.push(0);
			obj.data.push(0);
			obj.data.push(0);
			obj.data.push(290);
			obj.data.push(0);
			PlayerActionSend.PlayerAction(obj);
		}
		
		
		private function onRollOutPathSprite(e:MouseEvent):void{
			/**
			 * 修改显示坐标，by xiongdian 将网格坐标改为逻辑坐标
			 * */
//			var dP:Point = new Point(GameCommonData.Player.Role.TileY,GameCommonData.Player.Role.TileX);
//			var lP:Point = UIUtils.getLogicPoint(dP,GameCommonData.Scene.gameScenePlay.MapHeight/15);
//			(coordControl.txt_posX as TextField).text=lP.y.toString();
//			(coordControl.txt_posY as TextField).text=lP.x.toString();
			//			(mapControl.txt_posX as TextField).text=GameCommonData.Player.Role.TileX.toString();
			//			(mapControl.txt_posY as TextField).text=GameCommonData.Player.Role.TileY.toString();
		}
		
		private function onPathSpriteMove(e:MouseEvent):void{	
//			var stagePoint:Point=new Point(e.currentTarget.mouseX/getRatio(),e.currentTarget.mouseY/getRatio())
//			var point:Point=MapTileModel.GetTileStageToPoint(stagePoint.x,stagePoint.y);
			
			/**
			 * 修改显示坐标，by xiongdian 将网格坐标改为逻辑坐标
			 * */
//			var dP:Point = new Point(point.y,point.x);
//			var lP:Point = UIUtils.getLogicPoint(dP,GameCommonData.Scene.gameScenePlay.MapHeight/15);
//			(coordControl.txt_posX as TextField).text=lP.y.toString();
//			(coordControl.txt_posY as TextField).text=lP.x.toString();
			//			(mapControl.txt_posX as TextField).text=String(point.x);
			//			(mapControl.txt_posY as TextField).text=String(point.y);
		}
		
		private function doLayout():void
		{
//			SenceMapBtn.y = 5;
//			SenceMapBtn.x = 25;
			var width:int = Math.max(minWidth,mapLayer.width);
			var height:int =Math.max(minHeight,mapLayer.height);
			//			SenceMap.width = Math.max(minWidth,mapLayer.width)+20;
			//			SenceMap.height= Math.max(minHeight,mapLayer.height) + 50;
//			this.SceneMapBg.width=width+14;
//			this.SceneMapBg.height=height+mapControl.height+7;
//			this.SceneMapBg.y = SenceMapBtn.y+SenceMapBtn.height-7;
			
			
			//this.mapLayer.x=20;
//			mapContainer.y = mapLayerContainer.y = SenceMapBtn.y+SenceMapBtn.height;
			corner.x = this.SceneMapBg.mapBG.x -2;
			corner.y = this.SceneMapBg.mapBG.y + 17;
			
			mapLayerContainer.y= corner.y;
//			mapLayerContainer.width = corner.width;
//			mapLayerContainer.height = corner.height;
			mapLayerContainer.x = corner.x;
//			if(isCurrentScene){
//				this.pathSprite.x=this.mapLayer.x;
				this.pathSprite.width=this.mapLayer.width;
				this.pathSprite.height=this.mapLayer.height;
//			}

			//			senceMapContainer.x = (GameCommonData.GameInstance.GameUI.stage.stageWidth - senceMapContainer.width) / 2;
			//			senceMapContainer.y = (GameCommonData.GameInstance.GameUI.stage.stageHeight - senceMapContainer.height) / 2;
			
			//mapLayer.x=this.mapContainer.x+20;
			//mapLayer.y=this.mapContainer.y;

//			this.mapControl.y=mapLayerContainer.y+mapLayerContainer.height;
//			this.mapControl.y = SceneMapBg.y+(SceneMapBg.height-mapControl.height);
//			this.mapControl.width = SceneMapBg.width;
			
//			senceMapContainer.addChild(coordControl);
			
			
	
			//布局完后才出现
			LoadingView.getInstance().removeLoading();
//			if(panelBase && GameCommonData.GameInstance.GameUI.contains(panelBase))
//			{
//				var x:int = panelBase.x;
//				var y:int = panelBase.y;
//			}
//				GameCommonData.GameInstance.GameUI.removeChild(panelBase); 
			panelBase = new PanelBase(senceMapContainer, senceMapContainer.width+3-mapInfo.width, 470);
			panelBase.name = "SenceMapContainer";
			panelBase.SetTitleName("MapIcon");
			panelBase.SetTitleDesign();
			panelBase.addEventListener(Event.CLOSE, panelCloseHandler);
			var p:Point = UIConstData.getPos(senceMapContainer.width+3-mapInfo.width,470);
			panelBase.x = p.x;
			panelBase.y = p.y;
			if(mapPos)
			{
				panelBase.x = mapPos.x;
				panelBase.y = mapPos.y;
				mapPos = null;
			}
			GameCommonData.GameInstance.GameUI.addChild(panelBase); 
			this.isLoading=false;
			
			if(NewerHelpData.newerHelpIsOpen) {
				sendNotification(NewerHelpEvent.OPEN_SENCE_MAP_NOTICE_NEWER_HELP);	//通知新手引导
			}
		}
		
		private function senceMapStart(event:MouseEvent):void
		{
			senceMapContainer.startDrag();
			SenceMap.addEventListener(MouseEvent.MOUSE_UP, senceMapStop);
		}
		
		private function senceMapStop(event:MouseEvent):void
		{
			senceMapContainer.stopDrag();
			SenceMap.removeEventListener(MouseEvent.MOUSE_UP, senceMapStop);
		}
		
		private function panelCloseHandler(event:Event = null):void
		{
			GameCommonData.Player.SMapPathUpdate=null;
			
			
			if(GameCommonData.GameInstance.GameUI.contains(panelBase))
			{
				GameCommonData.GameInstance.GameUI.removeChild(panelBase);
				dataProxy.SenceMapIsOpen = false;					
			}
			
			while(mapContainer.numChildren>0){
				mapContainer.removeChildAt(0);
			}
			this.mapLayer=null;
			this.symbolLayer=null;
			if(pathSprite){
				this.pathSprite.removeEventListener(MouseEvent.MOUSE_MOVE,onPathSpriteMove);
				this.pathSprite.removeEventListener(MouseEvent.ROLL_OUT,onRollOutPathSprite);
				this.pathSprite.removeEventListener(MouseEvent.CLICK,onSmallClickHandler);
			}
			this.pathSprite=null;
			
			if(NewerHelpData.newerHelpIsOpen) {	//通知新手引导
				sendNotification(NewerHelpEvent.CLOSE_SENCE_MAP_NOTICE_NEWER_HELP);
			}
		}
		
		private function onSelectMapMode(e:MouseEvent):void
		{
			var name:String = e.currentTarget.name;
			var x:int = panelBase.x;
			var y:int = panelBase.y;
			switch(name)
			{
				case "btn_current":
					this.closeMap(null);
					(SenceMapBtn.btn_current as MovieClip).gotoAndStop(3);
					(SenceMapBtn.btn_current as MovieClip).mouseEnabled = false;
					(SenceMapBtn.btn_world as MovieClip).gotoAndStop(1);
					(SenceMapBtn.btn_world as MovieClip).mouseEnabled = true;
					dataProxy.BigMapIsOpen = false;
					panelCloseHandler(null);
					this.closeMap(null);
					facade.sendNotification(EventList.SHOWSENCEMAP);
					
					var path:Array=GameCommonData.Player.PathMap
					if(path && path.length>0)
					{
						SmapBtn.visible = true;
					}
					break;
				
				case "btn_world":
//					this.panelCloseHandler(null);
//					this.closeMap(null);
					dataProxy.BigMapIsOpen = true;
					(SenceMapBtn.btn_current as MovieClip).gotoAndStop(1);
					(SenceMapBtn.btn_world as MovieClip).gotoAndStop(3);
					sendNotification(EventList.SHOWBIGMAP);
					(SenceMapBtn.btn_current as MovieClip).mouseEnabled = true;
					(SenceMapBtn.btn_world as MovieClip).mouseEnabled = false;
					break;
			}
			panelBase.x = x;
			panelBase.y = y;
		}
		
		private function onShowMapInfo(e:MouseEvent):void
		{
			if(mapInfo.visible)
			{
				mapInfo.visible = false;
			}else
			{
				mapInfo.visible = true;
			}
		}
		
		private function onFindPath(e:MouseEvent):void
		{
			if(btnTypeReturn==0)
			{
				var x:int = SceneMapBg.position.mapX.text;
				var y:int = SceneMapBg.position.mapY.text;
				if(x == 0 || y == 0)
					return;
				var tilePoint:Point =new Point(x,y);
				var pos:int = this.mapImgDic[scenceName].map.mapData[x*this.mapImgDic[this.scenceName].map.col+y];
				if(pos == 0 || pos == 2)
				{
					var secnePoint:Point = MapTileModel.GetTilePointToStage(tilePoint.x,tilePoint.y);
					GameCommonData.Scene.MapPlayerMove(secnePoint,0,scenceName);
					GameCommonData.Player.SMapPathUpdate = drawPath;
					PlayerController.EndAutomatism();
					var nodes:Array = GameCommonData.Player.PathMap;
					if(nodes == null) return;
					var lastPoint:Point = nodes[nodes.length-1] as Point;
					if(lastPoint)
					{
						var smapPoint:Point = new Point(lastPoint.x*getRatio(),lastPoint.y*getRatio());
						var xyNode:Array = GameCommonData.Player.PathTileXY;
						var xyList:Array = xyNode[xyNode.length-1]; 
						clickTilePoint = new Point(xyList[0],xyList[1]);
						SmapBtn.x = smapPoint.x-10;
						SmapBtn.y=  smapPoint.y-5; 
						SmapBtn.visible = true;	
					}
				}	
//				var pos:int = this.mapImgDic[scenceName].map.mapData[x*this.mapImgDic[this.scenceName].map.col+y];
//				if(pos == 0 || pos == 2)
//				{
//					MoveToCommon.MoveTo(int(GameCommonData.GameInstance.GameScene.GetGameScene.name),x,y);
//					var nodes:Array = GameCommonData.Player.PathMap;
//					var lastPoint:Point = nodes[nodes.length-1] as Point;
//					if(lastPoint)
//					{
//						var smapPoint:Point = new Point(lastPoint.x*getRatio(),lastPoint.y*getRatio());
//						var xyNode:Array = GameCommonData.Player.PathTileXY;
//						var xyList:Array = xyNode[xyNode.length-1]; 
//						clickTilePoint = new Point(xyList[0],xyList[1]);
//						SmapBtn.x = mapContainer.x + smapPoint.x-10;
//						SmapBtn.y=  mapContainer.y + smapPoint.y-5; 
//						SmapBtn.visible = true;	
//					}
//				}
			}
			else
			{
//				this.closeMap(null);
				dataProxy.BigMapIsOpen = true;
				(SenceMapBtn.btn_current as MovieClip).gotoAndStop(1);
				(SenceMapBtn.btn_world as MovieClip).gotoAndStop(3);
				sendNotification(EventList.SHOWBIGMAP);
				(SenceMapBtn.btn_current as MovieClip).mouseEnabled = true;
				(SenceMapBtn.btn_world as MovieClip).mouseEnabled = false;
			}
		}
		
		private function onFlyTo(e:MouseEvent):void
		{
			if(timer.running) {
				return;
			}
			var index:int = e.currentTarget.name;
			if(npcList[index])
			{
				var pos:Point = new Point(npcList[index].X,npcList[index].Y);
				MoveToCommon.FlyTo(uint(this.scenceName),pos.x,pos.y,0,0);
				this.SmapBtn.visible = false;
				timer.reset();
				timer.start();
			}
			
		}
		
		private function onFlyToTrans(e:MouseEvent):void
		{
			if(timer.running) {
				return;
			}
			var index:int = e.currentTarget.name;
			if(transList[index])
			{
				var pos:Point = new Point(transList[index].X,transList[index].Y);
				MoveToCommon.FlyTo(uint(this.scenceName),pos.x,pos.y,0,0);
				this.SmapBtn.visible = false;
				timer.reset();
				timer.start();
			}
			
		}
		
		private const RATIO_NORMAL:Number = 0.14;
		private const RATIO_2016:Number = 0.0765;
		
		private function getRatio():Number
		{
			
			if(this.mapImgDic[scenceName])
			{
				var scale:Number = this.mapImgDic[scenceName].map.scale;
				return scale;
			}
			else
			{
				return GameCommonData.GameInstance.GameScene.GetGameScene.Scale;
			}
		}
		
		/**
		 * 地图加载完毕
		 **/ 
		private function onLoadComplete():void
		{
			LoadingView.getInstance().removeLoading();	
			var tempMc:MovieClip = ResourcesFactory.getInstance().getMovieClip(GameCommonData.GameInstance.Content.RootDirectory + "Resources/GameDLC/BigMap.swf");
			bigMap= new (tempMc.loaderInfo.applicationDomain.getDefinition("BigMap"))();
			this.bigMap.name = "BigMap";
			this.bigMap.mouseEnabled = true;

			this.initSet();
			this.showBigMap();
		}
		
		private function showBigMap():void{
//			if(ChatData.txtIsFoucs) return;
//			if(dataProxy.BigMapIsOpen)
//			{
//				closeMap(null);
//			}
//			else
//			{
				dataProxy.BigMapIsOpen = true;
				while(this.mapLayerContainer.numChildren>0){
					this.mapLayerContainer.removeChildAt(0);
				}
				while(this.mapContainer.numChildren>0){
					this.mapContainer.removeChildAt(0);     
				}
				
				mapLayerContainer.addChild(bigMap);
				
				if(this.pathSprite)
				{
					this.pathSprite.removeEventListener(MouseEvent.MOUSE_MOVE,onPathSpriteMove);
					this.pathSprite.removeEventListener(MouseEvent.ROLL_OUT,onRollOutPathSprite);
					this.pathSprite.removeEventListener(MouseEvent.CLICK,onSmallClickHandler);
				}
				
				SmapBtn.visible = false;
//				this.playerIcon.visible = false;	
//				GameCommonData.GameInstance.WorldMap.addChild(bigMap);
//			}
		}
		/**
		 *  初始化操作
		 * 
		 */		
		private function initSet():void{
			for(var i:uint=1;i<=this.maxNumMap;i++){
				this.setMc(this.bigMap["map_"+i]);	
			}
		}
		
		private function setMc(mc:MovieClip):void{
			
			mc.addEventListener(MouseEvent.CLICK,onMapClickHandler);
		}
		
		
		private function onMapClickHandler(e:MouseEvent):void{
			
			var str:String=e.currentTarget.name;
			e.currentTarget.gotoAndStop(1);
			var arr:Array=str.split("_");
			var name:String=SmallConstData.getInstance().getSceneNameById(uint(arr[1]));
			if(name==null)return;
			
			mapPos = new Point();
			mapPos.x = panelBase.x;
			mapPos.y = panelBase.y;
			
			this.panelCloseHandler(null);

			if(name==String(GameCommonData.GameInstance.GameScene.GetGameScene.name)){
				sendNotification(EventList.SHOWSENCEMAP);
//				dataProxy.BigMapIsOpen = false;
			}else{
				sendNotification(EventList.SHOWSENCEMAP,name);
//				dataProxy.BigMapIsOpen = false;
			}
			
		}
		
		private function closeMap(event:MouseEvent = null):void
		{
			if(bigMap)
			{
				if(mapLayerContainer && mapLayerContainer.contains(bigMap))
				{
					mapLayerContainer.removeChild(bigMap);
					dataProxy.BigMapIsOpen = false;
//					bigMap=null;
				}
			}
		}
		
		private function GetTileStageToPoint(stageX:int, stageY:int):Point
		{
			//界面坐标 计算以屏幕左上为原点的世界坐标
			var dataTempy:int = stageX  - stageY * 2;
			if(dataTempy < 0)
			{
				dataTempy -= 60;
			}
			var dataTempx:int = stageY * 2 + stageX;
			
			var dataTempx1:int = (dataTempx + 30) / 60;
			var dataTempy1:int = (dataTempy + 30) / 60;
			
			//加上偏移
			return new Point(this.mapImgDic[scenceName].map.OFFSET_TAB_X + dataTempx1, this.mapImgDic[scenceName].map.OFFSET_TAB_Y + dataTempy1);
		}
		
	}
}