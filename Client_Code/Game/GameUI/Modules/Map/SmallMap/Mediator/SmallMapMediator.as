package GameUI.Modules.Map.SmallMap.Mediator
{
	import Controller.PKController;
	import Controller.PlayerController;
	import Controller.TargetController;
	import Controller.TerraceController;
	
	import GameUI.ConstData.EventList;
	import GameUI.Modules.AutoPlay.command.AutoPlayEventList;
	import GameUI.Modules.Campaign.Data.CampaignData;
	import GameUI.Modules.Friend.command.FriendCommandList;
	import GameUI.Modules.Help.Data.DataEvent;
	import GameUI.Modules.Hint.Events.HintEvents;
	import GameUI.Modules.Login.SoundUntil.SoundController;
	import GameUI.Modules.MainSence.Mediator.MainSenceMediator;
	import GameUI.Modules.Map.SmallMap.SmallMapConst.SmallConstData;
	import GameUI.Modules.Master.Data.MasterData;
	import GameUI.Modules.NewerHelp.Data.NewerHelpData;
	import GameUI.Modules.NewerHelp.Data.NewerHelpEvent;
	import GameUI.Modules.PlayerInfo.Command.PlayerInfoComList;
	import GameUI.Modules.Screen.Data.ScreenData;
	import GameUI.Modules.Screen.ScreenMediator;
	import GameUI.Modules.TimeCountDown.TimeUIUtils;
	import GameUI.Proxy.DataProxy;
	import GameUI.UIConfigData;
	import GameUI.UIUtils;
	import GameUI.View.Components.UISprite;
	
	import OopsEngine.AI.PathFinder.MapTileModel;
	import OopsEngine.Role.GameRole;
	import OopsEngine.Scene.StrategyElement.GameElementAnimal;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	

	public class SmallMapMediator extends Mediator
	{
		public static const NAME:String = "SmallMapMediator";
		
		public var mapScaleX:Number = 1;
		public var mapScaleY:Number = 1;
		public var drawMapFunction:Function;
		public var changePathFunciton:Function;
		private var showMap:Boolean = true;
		
		private var date:Date = null;
		private var map:Bitmap;
		private var mapContainer:Sprite;
	
		
		private var playerIcon:MovieClip;
		private var animalDic:Dictionary=new Dictionary();
		private var dataProxy:DataProxy;
		private var mapDic:Dictionary = new Dictionary();
		private var pathSprite:UISprite;
		private var flag:Boolean=true;
		
		private var timeUtils:TimeUIUtils;  //显示服务器时间组件
		
		
		private const direction:Array=[0,-27,-90,-153,0,0,180,27,90,153];
		private var doFirst:Boolean=false;
		private var teamDic:Dictionary=new Dictionary();
		private var soundController:SoundController;
		public static var isFullScreen:Boolean = true;  
		
		
		
		public function SmallMapMediator()
		{
			super(NAME, viewComponent);
		}
		
		public function get SmallMap():MovieClip 
		{
			return this.viewComponent as MovieClip;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				EventList.INITVIEW,
				EventList.ENTERMAPCOMPLETE,
				EventList.UPDATE_SMALLMAP_DATA,
				PlayerInfoComList.UPDATE_TEAM,
				EventList.UPDATE_SMALLMAP_PATH,
				EventList.SHOW_SMALL_MAP,
				EventList.SHOW_TIME
			];
		} 
	
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case EventList.INITVIEW:
					facade.sendNotification(EventList.GETRESOURCE, {type:UIConfigData.MOVIECLIP, mediator:this, name:UIConfigData.SMALLMAP});
					this.SmallMap.mouseEnabled=false;			
					soundController = new SoundController();
					soundController.createSoundInfo(GameConfigData.UILibrary , new Point(147,37) , true,null,null,false,1,this.SmallMap.downPanel);
					this.SmallMap.addEventListener(Event.ADDED_TO_STAGE, initResize);
					
					//屏蔽玩家控制器
					facade.registerMediator(new ScreenMediator());
					facade.sendNotification(ScreenData.INITEVENT);
				break;
				case EventList.ENTERMAPCOMPLETE:
					GameCommonData.GameInstance.GameUI.addChild(SmallMap);
					dataProxy=facade.retrieveProxy(DataProxy.NAME) as DataProxy;
					addLis();
					initView();
				break;
				
				case PlayerInfoComList.UPDATE_TEAM:
					this.changeTeam();
				break;
				
				case EventList.UPDATE_SMALLMAP_DATA:
					var obj:Object=notification.getBody();
					var type:uint=obj.type;    
					var id:uint=obj.id;
					switch (type){
						case 1:
							this.changeMapPos();
							break;
						case 2:
							this.updateAnimalPos(id);
							break;
						case 3:
							this.addAnimal(id);
							break;
						case 4:
							this.removeAnimal(id);
							break;
						case 5:
							this.changePlayerPos();
							break;
						case 6:
							this.changePlayerDirection();
							break;
						case 7:
							this.changeSence();
							sendNotification(EventList.CHANGE_SCENEMAP_EVENT);
							
							break;	
					}
//					if(mapContainer && map){
//						trace("mapContainer.x:"+mapContainer.x + "mapContainer.y: "+ mapContainer.y);
//						trace("mapContainer.width: "+ mapContainer.width + "mapContainer.height: "+mapContainer.height);
//						trace("mapContainer.numChildren "+ mapContainer.numChildren);
//						trace("map.width: " + map.width + "map.height: "+ map.height);
//						trace("map.x: " + map.x + "map.y: " + map.y);
//						trace("playerIcon.x "+playerIcon.x+ "playerIcon.y "+playerIcon.y);
//					}
					
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
					}
					break;
				case EventList.SHOW_SMALL_MAP:			//外部调用的 显示小地图
					break;
				case EventList.SHOW_TIME:				//显示服务器时间
					timeUtils = TimeUIUtils.getInstance(SmallMap.txtCurTime);
					SmallMap.txtCurTime.visible = false;                               //右上方的时间暂不显示　以后要做修改
					timeShow(notification.getBody() as Array);
					break;
			}
		}
		
		private function initView():void
		{
			(this.SmallMap.downPanel.btn_rank as SimpleButton).addEventListener(MouseEvent.CLICK,onClickRanKHandler);
			(this.SmallMap.downPanel.btn_sceneMap as SimpleButton).addEventListener(MouseEvent.CLICK,onSceneMapClickHandler);
			(this.SmallMap.downPanel.btn_autoPlay as SimpleButton).addEventListener(MouseEvent.CLICK,onAutoPalyClickHandler);
			(this.SmallMap.upPanel.btn_narrowPanel  as SimpleButton).addEventListener(MouseEvent.CLICK,onNarrowPanelClickHandler);
			(this.SmallMap.downPanel.ScreenBtn  as SimpleButton).addEventListener(MouseEvent.CLICK,openScreen);
			(this.SmallMap.downPanel.btn_friends as SimpleButton).addEventListener(MouseEvent.CLICK,onFriendClickHandler);
			(this.SmallMap.downPanel.BtnTeam as SimpleButton).addEventListener(MouseEvent.CLICK,onTeamClickHandler);
			drawMapFunction = this.drawPath;
			
			
			this.playerIcon=GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("SelfPos");
			
			if (GameCommonData.isExe)
			{
//				this.SmallMap.downPanel.fullScreen.visible = false;
			}
		}
		
		private function openScreen(e:MouseEvent):void
		{
			facade.sendNotification(ScreenData.OPEN_SCREEN);
		}
		
		/**
		 * 打开PK开关 
		 * @param e
		 * 
		 */		
		protected function onPkClickHandler(e:MouseEvent):void{
			sendNotification(EventList.SHOWPKVIEW);
			e.stopPropagation();				
		}
		
		/**
		 * 打开场景地图 
		 * @param e
		 * 
		 */		
		protected function onSceneMapClickHandler(e:MouseEvent):void{
			if(this.dataProxy.SenceMapIsOpen){
				this.sendNotification(EventList.CLOSESCENEMAP);
			}else{
				this.sendNotification(EventList.SHOWSENCEMAP);
			}
		}
		/**
		 * 打开世界地图 
		 * @param e
		 * 
		 */		
		protected function onBigMapClickHanler(e:MouseEvent):void{
			sendNotification(EventList.SHOWBIGMAP);
		}
		/**
		 * 打开帮助文档 
		 * @param e
		 * 
		 */		
		protected function onHelpHandler(e:MouseEvent):void{
			facade.sendNotification(DataEvent.OUTSHOWPK);
		}
		
		/**
		 * 自动挂机 
		 * @param e
		 * 
		 */		
		protected function onAutoPalyClickHandler(e:MouseEvent):void{
			if(this.dataProxy.autoPlayIsOpen){
				sendNotification(AutoPlayEventList.HIDE_AUTOPLAY_UI);
				sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
			}else{
				sendNotification(AutoPlayEventList.SHOW_AUTOPLAY_UI);
			}
		}
		
		protected function onFriendClickHandler(e:MouseEvent):void {
			if(dataProxy.FriendsIsOpen == false)
			{
				sendNotification(FriendCommandList.SHOWFRIEND);
			}else{
				sendNotification(FriendCommandList.HIDEFRIEND)
			}
		}
		
		protected function onTeamClickHandler(e:MouseEvent):void{
			if(dataProxy.TeamIsOpen == false)
				sendNotification(EventList.SHOWTEAM);
			else
				sendNotification(EventList.REMOVETEAM);
		}
		/**
		 * 点击收缩放小地图框 
		 * @param e
		 * 
		 */		
		private function onNarrowPanelClickHandler(e:MouseEvent):void{
			if(this.SmallMap.downPanel.visible){
				
				this.SmallMap.downPanel.visible = false;		
				SmallMap.txtCurPoint.visible = false;
				SmallMap.achievement.visible = false;
				SmallMap.smallBack.visible = false;
			}else{
				this.SmallMap.downPanel.visible = true;
				SmallMap.txtCurPoint.visible = true;
				SmallMap.achievement.visible = true;
				SmallMap.smallBack.visible = true;
			}
		}
		/***
		 * 打开GM
		 * 
		 * 
		 */
		protected function onGmClickHandler(e:MouseEvent):void{
			facade.sendNotification(TerraceController.NAME , "GMTools");
		}
		
		/** 全屏 */
//		protected function onFullScreenHandler(e:MouseEvent):void{
//			
//
//			if( GameCommonData.fullScreen == 1 )
//			{
//				GameCommonData.fullScreen = 2;
//				UIUtils.callJava( "intofullscreen" );
//			}else{
//				GameCommonData.fullScreen = 1;
//				UIUtils.callJava( "exitfullscreen" );
//			}
//			if( GameCommonData.Scene.IsSceneLoaded )
//			{
//				GameCommonData.Scene.gameScenePlay.Background.LoadMap();
//			}
//		}
		
		protected function onClickRanKHandler(e:MouseEvent):void{
			if( GameCommonData.Player.Role.Level >= 20 )
			{
				if( this.dataProxy.RankIsOpen){
					sendNotification(EventList.CLOSERANKVIEW);
					sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
				}else{
					sendNotification(EventList.SHOWONLY_CENTER_FIVE_PANEL, "rank");
					sendNotification(EventList.SHOWRANKVIEW);
				}
			}
			else
			{
				facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "Modules_Map_SmallMap_Mediator_SmallMapMediator_1" ]/** = "达到20级才能看到排行榜";*/, color:0xffff00});	
			}

		}
		
		private function onAutoRoadHandler(e:MouseEvent):void{
			if(!dataProxy.AutoRoadIsOpen){
				sendNotification(EventList.SHOW_AUTOPATH_UI);
			}else{
				sendNotification(EventList.HIDE_AUTOPATH_UI);
				sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
			}
		}
		
		/**
		 * 分组改变时，更新小地图的显示 
		 * 
		 */		
		private function changeTeam():void{

			//队伍列表
			for(var id:* in this.teamDic){
				//在同场景中
				if(GameCommonData.SameSecnePlayerList[id]!=null){
					var point:MovieClip=this.teamDic[id];
					if(point!=null && this.mapContainer.contains(point)){
						this.mapContainer.removeChild(point);
						delete this.teamDic[id];
					}
					this.addAnimal(id);
				}	
			}

			for(var teamId:* in GameCommonData.TeamPlayerList){
				if(GameCommonData.SameSecnePlayerList[teamId]!=null){
					if(this.teamDic[teamId]==null && this.animalDic[teamId]!=null){
						var p:MovieClip=this.teamDic[teamId];
						if(p!=null && this.mapContainer.contains(p)){
							this.mapContainer.removeChild(p);
						}
						this.addAnimal(teamId);
					}
				}
			}
		}
		
		/**
		 * 导航小地图的位移控制
		 * 
		 */
		private function changeMapPos():void{
			
			//当前地图的X
			var bigMapX:Number=GameCommonData.GameInstance.GameScene.GetGameScene.x;
			//当前地图的Y
			var bigMapY:Number=GameCommonData.GameInstance.GameScene.GetGameScene.y;
			//小地图缩放比例
			var scale:Number=GameCommonData.GameInstance.GameScene.GetGameScene.Scale;
			//大地图高度宽度
			var h:Number=GameCommonData.GameInstance.GameScene.GetGameScene.MapHeight;
			//大地图高度宽度
			var w:Number=GameCommonData.GameInstance.GameScene.GetGameScene.MapWidth;
			
			//获取所在的地图中心点坐标位置
			var centerX:Number = bigMapX-GameCommonData.GameInstance.GameUI.stage.stageWidth/2-GameCommonData.Player.Skins.MaxBodyWidth/2;
			var centerY:Number = bigMapY-GameCommonData.GameInstance.GameUI.stage.stageHeight/2;
			
			var sCenterX:Number = centerX*scale;
			var sCenterY:Number = centerY*scale;
			mapContainer.x = sCenterX+70;
			mapContainer.y = sCenterY+70;
			
//			var smallData:Object = SmallConstData.getInstance().smallMapDic[GameCommonData.GameInstance.GameScene.GetGameScene.name]; 
//			mapContainer.x = bigMapX*scale+smallData[0] * mapScaleX;
//			mapContainer.y = bigMapY*scale+smallData[1] * mapScaleY;
			
			
			
			mapContainer.x += 30;
			mapContainer.y += 28;
			
			
			// 如果走到了边缘,对显示范围进行重新计算.
			if(mapContainer.x > SmallMap.downPanel.mcMapMask.x){
				mapContainer.x = SmallMap.downPanel.mcMapMask.x;
			}else if(mapContainer.x < SmallMap.downPanel.mcMapMask.x - (map.width - SmallMap.downPanel.mcMapMask.width)){
				mapContainer.x = SmallMap.downPanel.mcMapMask.x - (map.width - SmallMap.downPanel.mcMapMask.width);
			}
			if(mapContainer.y > SmallMap.downPanel.mcMapMask.y){
				mapContainer.y = SmallMap.downPanel.mcMapMask.y;
			}else if(mapContainer.y < SmallMap.downPanel.mcMapMask.y - (map.height - SmallMap.downPanel.mcMapMask.height)){
				mapContainer.y = SmallMap.downPanel.mcMapMask.y - (map.height - SmallMap.downPanel.mcMapMask.height);
			}
			SmallMap.txtCurPoint.text = GameCommonData.Player.Role.TileX+", "+GameCommonData.Player.Role.TileY;
			
		}
		
		 
		/**
		 * 改变场景玩家位置(包括改变他的队友信息)  
		 * 
		 */		
		 //2:
		private function updateAnimalPos(id:uint):void{
			if(GameCommonData.SameSecnePlayerList!=null)
			{
				var animal:GameElementAnimal=GameCommonData.SameSecnePlayerList[id] as GameElementAnimal;
				var point:MovieClip=this.animalDic[id] as MovieClip;
//				if(animal!=null && point==null && animal.Role.Type==GameRole.TYPE_PLAYER){
//					if(GameCommonData.Player.Role.idTeam!=0 && GameCommonData.Player.Role.idTeam==animal.Role.idTeam){
//						if(this.teamDic[id]!=null)return;
//						
//						point=GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("BulePoint");
//						this.mapContainer.addChild(point);
//						this.animalDic[id]=point;
//						this.teamDic[id]=point;
//						point.name="SMALLMAP_"+animal.Role.Name;
//					}
//				}
			}
			if(animal==null || point==null)return;
			if(animal.Role.isHidden)return;
			
			var p:Point = MapTileModel.GetTilePointToStage(animal.Role.TileX,animal.Role.TileY);
			point.x=p.x*GameCommonData.GameInstance.GameScene.GetGameScene.Scale;
			point.y=p.y*GameCommonData.GameInstance.GameScene.GetGameScene.Scale;

		}
		
		/**
		 * 添加玩家  
		 * 
		 */
		private function addAnimal(id:uint):void{
			var obj:Object = new Object();
			obj.id = id;
			obj.delayID = setInterval(showAnimal, 20, obj);			
		}
		
		private function showAnimal(obj:Object):void
		{
			if(!this.mapContainer) return;
			clearInterval(obj.delayID);
			if(this.animalDic[obj.id]!=null){
				this.removeAnimal(obj.id);
			}
			
			// 2010-09-07 董刚修改
			if(GameCommonData.SameSecnePlayerList==null)return;
			
			var animal:GameElementAnimal=GameCommonData.SameSecnePlayerList[obj.id] as GameElementAnimal;
			if(animal==null)return;
			if(animal.Role.isHidden)return;
			var point:MovieClip;
			if(animal.Role.Type==GameRole.TYPE_PLAYER){
				//进入pk场景
				if(TargetController.IsPKTeam())	{
					point = new MovieClip();
					point.graphics.beginFill(uint(PKController.getPKPersonColor(animal.Role.PKteam)));
					point.graphics.drawCircle(3,3,3);
					point.graphics.endFill();
				} 
				else{
					if(animal.Role.idTeam==0){
						point=GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GreenPoint");   //非队友
					}else if(GameCommonData.Player.Role.idTeam==animal.Role.idTeam){
						point=GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("BulePoint");   //队友
						this.teamDic[obj.id]=point;
					}else{
						point=GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GreenPoint");   //非队友
					}
				}
			}else if(animal.Role.Type==GameRole.TYPE_ENEMY){
				point=GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("RedPoint");
			}else if(animal.Role.Type==GameRole.TYPE_NPC){
				point=GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("YellowPoint");
			}
			if(point==null)return;
			this.animalDic[obj.id]=point;
			point.name="SMALLMAP_"+animal.Role.Name;
			this.mapContainer.addChild(point);
			
			var p:Point = MapTileModel.GetTilePointToStage(animal.Role.TileX,animal.Role.TileY);
			point.x=p.x*GameCommonData.GameInstance.GameScene.GetGameScene.Scale;
			point.y=p.y*GameCommonData.GameInstance.GameScene.GetGameScene.Scale;
		}
		/**
		 *删除玩家 
		 * 
		 */	
		 //4	
		private function removeAnimal(id:uint):void{
			var mc:MovieClip=this.animalDic[id] as MovieClip;
			if(mc!=null && this.mapContainer.contains(mc)){
				delete this.animalDic[id];
				delete this.teamDic[id];
				this.mapContainer.removeChild(mc);
			}
		}
		
		/**
		 * 普通边沿 playerIcon位置的显示
		 * @param errorVale  误差值通常是10;
		 * 
		 */		
		private function setPlayerIconNotBoundary(errorVale:Number = 10):void{
			var radius_w:Number = Math.round(SmallMap.downPanel.mcMapMask.width/2) + 30;
			var p1:Point;
			var p2:Point;
			
			
			if(!((playerIcon.x < radius_w)||(playerIcon.y < radius_w)||(playerIcon.x > map.width - radius_w)||(playerIcon.y > map.height - radius_w))){
				return;
			}
			//左边
			if(playerIcon.x < radius_w){
				//左上角
				playerIcon.x = playerIcon.x + errorVale;                           // 加errorVale是因为左右两边导航地图都到不了边沿尽头,左边做加10误差处理;
				if(playerIcon.y < radius_w){
					p2 = new Point(radius_w,radius_w);
					p1 = new Point(playerIcon.x,playerIcon.y);
					if(getTwoPointDistance(p1,p2) < radius_w){
						return;
					}
					playerIcon.x = radius_w -(radius_w -p1.x)*radius_w/getTwoPointDistance(p1,p2);
					playerIcon.y = radius_w -(radius_w -p1.y)*radius_w/getTwoPointDistance(p1,p2);
					return;
				}
				//左下角
				if(playerIcon.y > map.height - radius_w){
					p2 = new Point(radius_w,map.height - radius_w);
					p1 = new Point(playerIcon.x,playerIcon.y);
					if(getTwoPointDistance(p1,p2) < radius_w){
						return;
					}
					playerIcon.x = radius_w -(radius_w -p1.x)*radius_w/getTwoPointDistance(p1,p2);
					playerIcon.y = map.height - (radius_w - radius_w/getTwoPointDistance(p1,p2)*(radius_w - (map.height - playerIcon.y)))

					return;
				}				
				
			}
			//在右边
			if(playerIcon.x > map.width - radius_w){
				playerIcon.x = playerIcon.x - errorVale - 8;                     // 减errorVale是因为左右两边导航地图都到不了边沿尽头,右边做减15做误差处理;
				if(playerIcon.y < radius_w){
					p2 = new Point(map.width - radius_w,radius_w);
					p1 = new Point(playerIcon.x,playerIcon.y);
					if(getTwoPointDistance(p1,p2) < radius_w){
						return;
					}
					playerIcon.x = map.width - radius_w + (radius_w - (map.width - playerIcon.x))*radius_w/getTwoPointDistance(p1,p2);
					playerIcon.y = radius_w - radius_w/getTwoPointDistance(p1,p2) * (radius_w - playerIcon.y);
					return;
				}
				if(playerIcon.y > map.height - radius_w){
					
					p2 = new Point(map.width - radius_w,map.height - radius_w);
					p1 = new Point(playerIcon.x,playerIcon.y);
					if(getTwoPointDistance(p1,p2) < radius_w){
						return;
					}
					playerIcon.x = map.width - radius_w + (radius_w - (map.width - playerIcon.x))*radius_w/getTwoPointDistance(p1,p2);
					playerIcon.y = map.height - radius_w +(radius_w - (map.height - playerIcon.y))*radius_w/getTwoPointDistance(p1,p2);
					return;
				}
			}		
		}
		
		/**
		 * 取得两点之间的直线距离 
		 * @param p1
		 * @param p2
		 * @return 
		 * 
		 */		
		private function getTwoPointDistance(p1:Point,p2:Point):Number{
			var lang:Number = 0;
			lang = Math.sqrt(Math.pow((p2.x - p1.x),2)+Math.pow((p2.y - p1.y),2));
			return lang;
		}
		
		
		/**
		 * 特殊角落playerIcon的显示 
		 * 
		 */		
		private function setPlayerIconSpecialCornerPos(a:Number,b:Number,radius:Number):Boolean{
			var c:Number = 0;
			var valBool:Boolean = false;
			c = Math.sqrt(Math.pow(a,2)+Math.pow(b,2));
			if(c > radius ){
				valBool = true;
			}			
			return valBool;
		}
		
		/**
		 * 改变玩家自己的坐标
		 * 
		 */	
		 //5	
		private function changePlayerPos():void{
			
			this.mapContainer.addChild(this.playerIcon);
			this.playerIcon.x=GameCommonData.Player.GameX*GameCommonData.GameInstance.GameScene.GetGameScene.Scale;
			this.playerIcon.y=GameCommonData.Player.GameY*GameCommonData.GameInstance.GameScene.GetGameScene.Scale;
			setPlayerIconNotBoundary(10);
			var arr:Array=SmallConstData.getInstance().smallMapDic[GameCommonData.GameInstance.GameScene.GetGameScene.name] as Array;
			if(arr[6]==true){
				if(this.playerIcon.x>arr[7]){
					this.playerIcon.x=arr[7];
				}
			}
			if(arr[8]==true){
				
				if(this.playerIcon.x>arr[9]){
					this.playerIcon.x=arr[9];
				}
			}
			
		}
		
		/**
		 *改变玩家自己的方向 
		 * 
		 */	
		 //6	
		private function changePlayerDirection():void{
			if(this.playerIcon==null)return;
			this.playerIcon.rotation=this.direction[GameCommonData.Player.Role.Direction];
		}
		
		
		
		private function changeSence():void{
			this.animalDic=new Dictionary();
			if(this.mapContainer){
				while(mapContainer.numChildren>0){
					mapContainer.removeChildAt(0);
				}
				mapContainer.removeEventListener(MouseEvent.CLICK,onSmallClickHandler);
				SmallMap.downPanel.removeChild(mapContainer);
				mapContainer = null;
			}			
			this.playerIcon=GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("SelfPos");
			this.map=GameCommonData.GameInstance.GameScene.GetGameScene.RealSmallMap;
			this.setMapPos();
			
		}
		/** 显示服务器的时间 */
		private function timeShow(timeList:Array):void
		{
			timeUtils.showText(timeList);
		}
		
		//显示客户端时间
//		private function onTimer(event:TimerEvent):void
//		{
//			date = new Date();
//			SmallMap.txtCurTime.text = date.getHours() + ":" + (date.getMinutes()<10?"0"+date.getMinutes():date.getMinutes());
//		}
		
		//添加事件
		private function addLis():void
		{
//			SmallMap.huodong.addEventListener(MouseEvent.CLICK,onHuoDongHandler);
//			timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		private function onHuoDongHandler(e:MouseEvent):void
		{
//			if(dataProxy.MarketIsOpen) {
//				sendNotification(EventList.CLOSEMARKETVIEW);
//				sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
//			} else {
//				sendNotification(EventList.SHOWMARKETVIEW);
//			}
			if( GameCommonData.Player.Role.Level >= 15 )
			{
				facade.sendNotification(CampaignData.INIT_CAMPAIGN);
			}
			else
			{
				facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "Modules_Map_SmallMap_Mediator_SmallMapMediator_2" ]/** = "达到15级才能查看活动列表";*/, color:0xffff00});	
			}	
		}
		
		
		//点击小地图寻路
		protected function onSmallClickHandler(e:MouseEvent):void{
			if(!GameCommonData.Scene.IsFirstLoad)return;
			if(GameCommonData.Player.IsAutomatism)return;
			GameCommonData.isAutoPath=false;
			GameCommonData.IsMoveTargetAnimal = false;
			this.flag=true;
			GameCommonData.Scene.MapPlayerMove(new Point(this.mapContainer.mouseX/GameCommonData.GameInstance.GameScene.GetGameScene.Scale,this.mapContainer.mouseY/GameCommonData.GameInstance.GameScene.GetGameScene.Scale));	
			GameCommonData.Player.MapPathUpdate = drawPath;
			PlayerController.EndAutomatism();
		}
		
		protected function drawPath():void{
			if(flag)
			{
				var path:Array=GameCommonData.Player.PathMap;	
				this.mapContainer.addChild(this.pathSprite);
				this.pathSprite.graphics.clear();
				if(path==null){
					return;
				}
				this.pathSprite.graphics.beginFill(0xff0000,1);
				var scale:Number=GameCommonData.GameInstance.GameScene.GetGameScene.Scale;
				var len:uint=path.length;
				for(var i:uint=0;i<len;i++){
					pathSprite.graphics.drawCircle(path[i].x*scale,path[i].y*scale,1);
				}
				this.pathSprite.graphics.endFill();
			}
		}
		/**
		 * 设置子项显示在父容器的中心位置 
		 * 
		 */		
		private function setDisplayCenter(parentDisplayObject:DisplayObject,childDisplayObject:DisplayObject):void{
		
			childDisplayObject.x = (parentDisplayObject.width - childDisplayObject.width)/2;	
			//childDisplayObject.y = (parentDisplayObject.height -childDisplayObject.height )/2;
		}
		/**
		 * 设置地图名相关信息 
		 * 
		 */		
		private function setMapname():void{
			var mapName:String = GameCommonData.GameInstance.GameScene.GetGameScene.MapName.toString();
			if(mapName != ""){
//				SmallMap.upPanel.txtMapName.width = mapName.length * 13 + 2;                   // 根据字符长度设置文本的宽度,一个字符长13;
				setDisplayCenter(SmallMap.upPanel,SmallMap.upPanel.txtMapName);
				SmallMap.upPanel.txtMapName.text = mapName;
			}else{
				SmallMap.upPanel.txtMapName.text = "地图名"                                   //地图名为空时的处理;
//				SmallMap.upPanel.txtMapName.width = 41; 
				setDisplayCenter(SmallMap.upPanel,SmallMap.upPanel.txtMapName);
			}
		}
		
		private function setMapPos():void
		{
			mapContainer=new Sprite();
			mapContainer.addChild(map);
			
			setMapname();
			MasterData.addGlowFilter(SmallMap.txtMapName);
			mapContainer.addEventListener(MouseEvent.CLICK,onSmallClickHandler);
			mapContainer.addChild(this.playerIcon);			
			this.changeMapPos();
			this.changePlayerPos();
			this.changePlayerDirection();
			
			pathSprite=new UISprite();
			pathSprite.width=map.width;
			pathSprite.height=map.height;

			mapContainer.mask = SmallMap.downPanel.mcMapMask;
			SmallMap.downPanel.addChildAt(mapContainer,0);
			var pos:uint=SmallConstData.getInstance().mapItemDic[GameCommonData.GameInstance.GameScene.GetGameScene.name].id
				
				
//			trace("mapContainer.x:"+mapContainer.x + "mapContainer.y: "+ mapContainer.y);
//			trace("mapContainer.width: "+ mapContainer.width + "mapContainer.height: "+mapContainer.height);
//			trace("mapContainer.numChildren "+ mapContainer.numChildren);
//			trace("map.width: " + map.width + "map.height: "+ map.height);
//			trace("map.x: " + map.x + "map.y: " + map.y);
			
			
			/////第一次进入蝴蝶谷，通知新手指导系统
			if(NewerHelpData.newerHelpIsOpen) {
				var mask:uint=GameCommonData.BigMapMaskLow & Math.pow(2,0);
				var sceneName:String = GameCommonData.GameInstance.GameScene.GetGameScene.name;
				if(mask==0 && this.doFirst && (sceneName == "1002" || sceneName == "1035" || sceneName == "1037" || sceneName == "1039" || sceneName == "1041") && NewerHelpData.isFirst){
					sendNotification(NewerHelpEvent.SHOW_NEWER_HELP, 15);
					NewerHelpData.isFirst = false;
				}
			}
			/////
			GameCommonData.BigMapMaskLow=GameCommonData.BigMapMaskLow | Math.pow(2,(pos-1))
			//toDo 向服务器发一下
			
			if(!this.doFirst){

				return;
			}
			
			sendNotification(EventList.SEND_QUICKBAR_MSG);
			
			//过场景关闭场景地图
			sendNotification(EventList.CLOSESCENEMAP);
			
			
		}
		
		protected function initResize(event:Event):void
		{
			sendNotification(EventList.STAGECHANGE);
		}
	}
}