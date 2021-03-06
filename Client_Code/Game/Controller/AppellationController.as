package Controller
{
	import GameUI.Modules.Designation.Data.DesignationProxy;
	import GameUI.UICore.UIFacade;
	
	import OopsEngine.Scene.StrategyElement.GameElementAnimal;
	//import OopsEngine.Utils.LoadInfo;
	import OopsEngine.Utils.MovieAnimation;
	                                                
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * stlyou 非常蛋疼的一个类，加了资源加载优化效果，但是逻辑不是很理想，有时间需要修改 
	 * @author Administrator
	 * 
	 */	
	public class AppellationController
	{
		private static var _instance:AppellationController;
		public static function getInstance():AppellationController{
			if(_instance == null)
				_instance = new AppellationController();
			return _instance;
		}
		/**
		 * 记录当前正在等待资源加载完毕的玩家列表 
		 */		
		private var noPlayerList:Object = {};
		/**
		 * 设置玩家的称号 
		 * @param playerID
		 * 
		 */		
		public function ShowAppellation(playerID:int):void		
		{
		    var player:GameElementAnimal =  PlayerController.GetPlayer(playerID);
		    if(player != null)
		    {
				var appList:Array = [];
				//资源存在标志位
				var loadKey:Boolean = true;
				if(player.Role.DesignationCallList[0] != 0)
					appList.push(player.Role.DesignationCallList[0]);
				for (var i:int = 1; i < player.Role.DesignationCallList.length; i++) 
				{
					var appId:int = int(player.Role.DesignationCallList[i]);
					if(appId != 0){//判断当前是否存在正确的称号
						if(GameCommonData.AppellationLoadList[appId] == null){//判断是否存在资源
							noPlayerList[playerID] = 1;//当资源不存在的时候，将当前玩家添加到资源等待列表当中
							loadKey = false;
							GameCommonData.AppellationLoadList[appId] = null;
							loadMovie(appId);
						}
						appList.push(appId);
					}
				}
				if(appList.length == 0)
			    	player.ShowAppellation(null);
				else if(loadKey){//资源全部存在，直接构建人物显示图形
					playerSetAppellation(playerID);
				}
		    }
			
		}
		
		/**
		 * 资源加载队列全部完成,将所有在队列当中的玩家数据显示出来 
		 */		
		private function showAllPlayerAppellation():void{
			for(var playerId:String in noPlayerList) 
			{
				playerSetAppellation(int(playerId));
			}
			noPlayerList = {};
		}
		
		/**
		 * 显示单个玩家的称号资源(当前状态下,资源已经加载到内存当中了.) 
		 * @param playerID
		 * 
		 */		
		private function playerSetAppellation(playerID:int):void{
			var player:GameElementAnimal;
			if(playerID == GameCommonData.Player.Role.Id)
				player = GameCommonData.Player;
			else
				player = GameCommonData.SameSecnePlayerList[playerID];
			if(player == null)
				return;
			var DisList:Array = new Array();
			for (var j:int = 0; j < player.Role.DesignationCallList.length; j++) 
			{
				var value:int = player.Role.DesignationCallList[j];
				if(value == 0)
					continue;
				var apVo:Object = GameCommonData.NewDesignation[value];
				var a:Object =GameCommonData.NewDesignation;
				var dis:DisplayObject;
				if(j == 0){
					var tf:TextField = new TextField();
					tf.height = 20;
					tf.width = 130;
					
					var format2:TextFormat = new TextFormat();
					format2.align 		   = TextFormatAlign.CENTER;
					format2.size		   = 12;
					format2.font		   = "宋体";
					format2.color 		   = 0xffffff;
					tf.defaultTextFormat = format2;
					tf.cacheAsBitmap     = true;
					tf.mouseEnabled      = false;
					tf.selectable 		  = false;
					tf.text = apVo.name;
					dis = tf;
				}else{
					var mclip:MovieAnimation = new MovieAnimation(GameCommonData.AppellationLoadList[value]);
					mclip.FrameRate = 8;
					mclip.Play();
					dis = mclip;
				}
				DisList.push(dis);
			}
			player.ShowAppellation(DisList);
		}
		
		/**
		 * 加载资源 
		 * @param appId
		 * 
		 */		
		private function loadMovie(appId:int):void{
			var url:String = GameCommonData.GameInstance.Content.RootDirectory+"Resources\\Designation\\" +  appId + ".swf"; 
			//var load:LoadInfo = new LoadInfo(url);
			//load.data = appId;
			//load.loadComplte = LoadComplete;
			//load.load();
		}
		
		/**
		 * 单个资源加载完毕 
		 * @param info
		 */		
//		private function LoadComplete(info:LoadInfo):void{
//			GameCommonData.AppellationLoadList[int(info.data)] = info.Content.GetMovieClip();
//			for each(var obj:Object in GameCommonData.AppellationLoadList){
//				if(obj == null)
//					return;
//			}
//			if(loadCallBack!=null)
//				loadCallBack(GameCommonData.AppellationLoadList[int(info.data)]);
//			showAllPlayerAppellation();
//		}
		
		private var loadCallBack:Function;
		/**
		 * 提供给外部调用的获取称号资源信息 
		 * @param appId
		 * @param callback （value） value:MovieClip
		 */		
		public function getMovieByAppId(appId:int,callback:Function):void{
			loadCallBack = callback;
			if(GameCommonData.AppellationLoadList[appId] != null)
				callback(GameCommonData.AppellationLoadList[appId])
			else
				loadMovie(appId);
		}
	}
}