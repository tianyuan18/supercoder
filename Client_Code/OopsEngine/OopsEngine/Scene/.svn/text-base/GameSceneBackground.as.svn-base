package OopsEngine.Scene
{
	import OopsEngine.AI.PathFinder.MapTileModel;
	import OopsEngine.Scene.MapEffectData;
	import OopsEngine.Skill.GameSkillData;
	import OopsEngine.Skill.SkillAnimation;
	
	import OopsFramework.Content.ContentTypeReader;
	import OopsFramework.Content.Loading.BulkLoader;
	import OopsFramework.Content.Loading.ImageItem;
	import OopsFramework.Content.Provider.BulkLoaderResourceProvider;
	import OopsFramework.Game;
	import OopsFramework.IDisposable;
	import OopsFramework.Utils.Timer;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	/** 游戏场景背景分块加载管理  */
	public class GameSceneBackground extends Shape implements IDisposable                                                         
	{
		/** 地图块宽  */
		public var MapTileWidth :int = 240;                     //数值修改 by xiongdian 地图切片大小改为240*270
		/** 地图块高  */
		public var MapTileHeight:int = 270;                     //数值修改 by xiongdian
		
		private var gameScene:GameScene;
		private var picMaxX:int;							// 图片最大 X	
		private var picMaxY:int;							// 图片最大 Y	
		private var maps:Dictionary;						// 图片块缓存
		private var mapMaxCount:int;
		private var mapCount:int;
		
		/**
		 * 地图特效相关存储器  by xiongdian
		 */
		private var mapEffectArray:Dictionary;             //当前地图特效存储器
		private var loadingCatch:Dictionary;               //等待加载的特效
		private var loadedMapEffect:Array;                 //已经加载特效
		private var loadLock:Boolean;						//资源下载锁
		private var mcArray:Array;							//mc存储器
		private var RootPath:String;						//存放根目录
		private var geeds:Object = new Object();
		public var mapEffects:Array = new Array();
//		private var loading:Boolean;

		private var LoaderResource:BulkLoaderResourceProvider=null;  //资源加载器
		
		public function GameSceneBackground(gameScene:GameScene)
		{
			this.maps 		  = new Dictionary();
			this.gameScene    = gameScene;
			this.picMaxX 	  = this.gameScene.MapWidth  / MapTileWidth  - 1;
			this.picMaxY 	  = this.gameScene.MapHeight / MapTileHeight - 1;
			this.mapMaxCount  = (this.picMaxX + 1) * (this.picMaxY + 1);
			
			// 画马塞克图背景图
			var gameSceneRealWidth:int  = this.gameScene.MapWidth  + this.gameScene.OffsetX;
			var gameSceneRealHeight:int = this.gameScene.MapHeight + this.gameScene.OffsetY;
			var matrix:Matrix 			= new Matrix();
			matrix.a 					= gameSceneRealWidth  / this.gameScene.SmallMap.width;
			matrix.d 					= gameSceneRealHeight / this.gameScene.SmallMap.height;
			this.graphics.beginBitmapFill(this.gameScene.SmallMap.bitmapData, matrix, false, false);
			this.graphics.drawRect(0, 0, gameSceneRealWidth, gameSceneRealHeight);
			this.graphics.endFill();

			matrix = null;
			
			/**
			 * 加载地图特效信息 by xiongdian
			 * 初始化容器
			 */
			mapEffectArray = new Dictionary();
			loadingCatch = new Dictionary();
			loadedMapEffect = new Array();
			mcArray = new Array();
			loadLock = false;
			RootPath = this.gameScene.Games.Content.RootDirectory + "Scene/MapEffect/";
			
			var xml:XML = this.gameScene.ConfigXml;
			for(var i:int = 0; i< xml.MapEffect.length();i++)
			{
				//<MapEffect Name="瀑布水" PicName="4_8" Y="94" X="86" Remark="你好，我叫瀑布水" Id="1004"/>
				var obj:MapEffectData=new MapEffectData();
				obj.id=xml.MapEffect[i].@Id;
				obj.effectName=xml.MapEffect[i].@Name;
				obj.x=xml.MapEffect[i].@X;
				obj.y=xml.MapEffect[i].@Y;
				
				var picName:String=xml.MapEffect[i].@PicName;
				obj.picNameArray=picName.split(",");
				mapEffectArray[obj.id]=obj;
//				mapEffectArray[obj.id] = obj;
			}
		}
		
		/** 地图块加载（默认四个方向都多加载一格图片）  */
		public function LoadMap():void
		{
			if(this.maps!=null && this.mapMaxCount != this.mapCount)
			{
				var CurrentPicX:int    = int(Math.abs(this.gameScene.x) / MapTileWidth);
				var CurrentPicY:int    = int(Math.abs(this.gameScene.y) / MapTileHeight);
				
				var CurrentPicMaxX:int;
				var CurrentPicMaxY:int;
				if(this.gameScene.Games.ScreenWidth<1800 || this.gameScene.Games.ScreenHeight<1000)
				{
					CurrentPicMaxX = int(Math.abs(1800  - this.gameScene.x) / this.MapTileWidth);
					CurrentPicMaxY = int(Math.abs(1000 - this.gameScene.y) / this.MapTileHeight);
				}
				else
				{
					CurrentPicMaxX = int(Math.abs(this.gameScene.Games.ScreenWidth  - this.gameScene.x) / this.MapTileWidth);
					CurrentPicMaxY = int(Math.abs(this.gameScene.Games.ScreenHeight - this.gameScene.y) / this.MapTileHeight);
				}
				CurrentPicX -= 2;
				
				CurrentPicX    = (CurrentPicX <= 0 ? 0 : CurrentPicX);
				CurrentPicY    = (CurrentPicY <= 0 ? 0 : CurrentPicY);
				CurrentPicMaxX = (CurrentPicMaxX >= picMaxX ? picMaxX : CurrentPicMaxX);
				CurrentPicMaxY = (CurrentPicMaxY >= picMaxY ? picMaxY : CurrentPicMaxY);
				
				// 多加载一圈小地图
//				CurrentPicX    = (CurrentPicX <= 0 ? 0 : CurrentPicX - 1);
//				CurrentPicY    = (CurrentPicY <= 0 ? 0 : CurrentPicY - 1);
//				CurrentPicMaxX = (CurrentPicMaxX >= picMaxX ? picMaxX : CurrentPicMaxX + 1);
//				CurrentPicMaxY = (CurrentPicMaxY >= picMaxY ? picMaxY : CurrentPicMaxY + 1);

				for (var i:int = CurrentPicX; i<= CurrentPicMaxX; i++) 
				{
					for (var j:int = CurrentPicY; j <= CurrentPicMaxY; j++) 
					{
						var picName:String = i + "_" + j;
						if(this.maps[picName]==null)
						{
							this.maps[picName]	    = true;
							var picLoader:ImageItem = new ImageItem(this.gameScene.Games.Content.RootDirectory + "Scene/" + this.gameScene.name + "/" + picName + ".jpg", 
																	BulkLoader.TYPE_IMAGE, 
																	picName);
							picLoader.Version		= BulkLoader.version;
							picLoader.addEventListener(Event.COMPLETE, onPicComplete);
							picLoader.load();
							this.mapCount++;
							
							/**
							 * 将需要加载的地图特效信息加入待加载缓存 by xiongdian
							 * 
							 */
							var idList:String = isExistEffect(picName);
							if( idList != ""){
								
								var idArray:Array = idList.split(",");
								for each(var id:int in idArray){
									
									if( !isLoaded(id) ){
										
										loadingCatch[id]=mapEffectArray[id];
										loadLock = true;
									}
								}
							}
						}
					}
				}
				
				/**
				 * 加载缓存中的所有地图特效 by xiongdian
				 * 特效再地图全部加载完成后加载
				 * 
				 */
				if(loadLock){
					
					loadLock = false;
//					LoaderResource = new BulkLoaderResourceProvider(1,this.gameScene.Games);
					LoaderResource = new BulkLoaderResourceProvider();
					LoaderResource.LoadComplete = onLoadEffectComplete;
					
					for each (var _mapEffect:MapEffectData in loadingCatch)
					{
						
						if( !isMCLoad(_mapEffect.effectName) ){
							
							loadEffect(_mapEffect.effectName);
							loadLock = true;
						}
					}
					if(loadLock){
						
						LoaderResource.Load();
					}else{
						
						onLoadEffectComplete();
					}
					
					loadLock = false;
				}
			}
		}
		
		private function onPicComplete(e:Event):void
		{
			var picLoader:ImageItem   = e.target as ImageItem;
			var pos:Array 			  = picLoader.name.split("_");
			var i:uint	  			  = pos[0];
			var j:uint 	  		      = pos[1];
			
			this.graphics.beginBitmapFill(picLoader.content.content.bitmapData);
			this.graphics.drawRect(i * this.MapTileWidth, j * this.MapTileHeight, this.MapTileWidth, this.MapTileHeight);
			this.graphics.endFill();
			
			picLoader.removeEventListener(Event.COMPLETE, onPicComplete);
			picLoader.destroy();
			picLoader = null;
		}
		
		/** IDisposable Start */
		public function Dispose():void
		{
			//清理mc
			for each(var name:String in mcArray){
				
				var url:String = RootPath + name + ".swf";
				this.gameScene.Games.Content.Cache.RemoveStrategyStorage(url);
			}
			
			this.maps      = null;
			this.gameScene = null;
			mapEffectArray = null;
			loadingCatch = null;
			loadedMapEffect = null;
			mcArray = null;
			
			for(var str:String in geeds){
				delete geeds[str];
			}
			geeds = null;
			
			// 父级对象移除
			if(this.parent != null)
			{
				this.parent.removeChild(this);
			}		
		}
		/** IDisposable End */
		
		/** 判断切片中是否存在地图特效 */
		public function isExistEffect(value:String):String{
			
			var idList:String= "";
			for each (var _tmpEffect:MapEffectData in mapEffectArray){

				if(_tmpEffect.isExistEffect(value)){
//					return _tmpEffect;
					idList += _tmpEffect.id.toString()+",";
				}
			}
			if(idList != "" && idList.charAt(idList.length-1)==","){
				
				idList = idList.substr(0,idList.length-1)
			}

			return idList;
		}
		
		/** 判断特效是否加载过 */
		public function isLoaded(id:int):Boolean{
			
			for each (var effectid:int in loadedMapEffect){
				
				if(id == effectid){
					
					return true;
				}
			}
			return false;
		}
		
		/** 判断mc是否加载过 */
		public function isMCLoad(name:String):Boolean{
			
			for each (var effectName:String in mcArray){

				if(name == effectName){
					
					return true;
				}
			}
			return false;
		}
		
		/** 特效资源加载 */
		public function loadEffect(effectName:String):void{

			var url:String = this.gameScene.Games.Content.RootDirectory + "Scene/MapEffect/" + effectName + ".swf"
			if( this.gameScene.Games.Content.Cache.GetStrategyStorage(url) == null ){
				
				LoaderResource.Download.Add(url);
				mcArray.push(effectName);
			}
		}
		
		public function onLoadEffectComplete():void{
			
			var timer:flash.utils.Timer = new flash.utils.Timer(100,1);;
			timer.addEventListener(TimerEvent.TIMER,timer_func);
			timer.start();

//				var url:String = this.gameScene.Games.Content.RootDirectory + "Scene/MapEffect/" + _tmpEffect.effectName + ".swf";
//
//				if( LoaderResource.IsResourceExist(url) ){
//					
//					var tmpClass:Class = LoaderResource.GetResource(url).GetClass("EffectClass") as Class;
//					_tmpEffect.effectMC = MovieClip(new tmpClass()) ;
//
//					var p1:Point = MapTileModel.GetTilePointToStage(_tmpEffect.x,_tmpEffect.y);
//					_tmpEffect.effectMC.x = p1.x;
//					_tmpEffect.effectMC.y = p1.y;
//					this.gameScene.BottomLayer.addChild(_tmpEffect.effectMC);
//					
//					delete loadingCatch[_tmpEffect.id];
//					loadedMapEffect.push(_tmpEffect.id);
//				}
				
//				var url:String = "Scene/MapEffect/" + _tmpEffect.effectName + ".swf";
//				var reader:ContentTypeReader = this.gameScene.Games.Content.Load(url);
//				if(reader == null){	
//					continue;
//				}
//				var tmpClass:Class = reader.GetClass("EffectClass") as Class;
//				
//				_tmpEffect.effectMC = MovieClip(new tmpClass()) ;
//				var p1:Point = MapTileModel.GetTilePointToStage(_tmpEffect.x,_tmpEffect.y);
//				_tmpEffect.effectMC.x = p1.x;
//				_tmpEffect.effectMC.y = p1.y;
//				this.gameScene.BottomLayer.addChild(_tmpEffect.effectMC);
//				
//				delete loadingCatch[_tmpEffect.id];
//				loadedMapEffect.push(_tmpEffect.id);				
		}
		
		private function timer_func(evt:TimerEvent):void{
			
			for each (var _tmpEffect:MapEffectData in loadingCatch){
				
				var url:String = this.gameScene.Games.Content.RootDirectory + "Scene/MapEffect/" + _tmpEffect.effectName + ".swf";
				var reader:ContentTypeReader = null;
				if(this.gameScene.Games.Content.Cache.GetStrategyStorage(url) == null){
					
					reader = LoaderResource.GetResource(url);
					if(reader == null){	
						continue;
					}
					this.gameScene.Games.Content.Cache.AddStrategyStorage(url,LoaderResource.GetResource(url));
				}
				else{
					
					reader = this.gameScene.Games.Content.Cache.GetStrategyStorage(url);
					if(reader == null){	
						continue;
					}
				}
				
				var tmpClass:Class = reader.GetClass("EffectClass") as Class;
				_tmpEffect.effectMC = MovieClip(new tmpClass()) ;
				_tmpEffect.effectMC.mouseEnabled = false;
				_tmpEffect.effectMC.mouseChildren = false;
				//				var p1:Point = MapTileModel.GetTilePointToStage(_tmpEffect.x,_tmpEffect.y);
				switch(_tmpEffect.effectName)
				{
					case "lightString":
//					case "light":
						_tmpEffect.effectMC.x = _tmpEffect.x;
						_tmpEffect.effectMC.y = _tmpEffect.y;
						_tmpEffect.effectMC.width = _tmpEffect.effectMC.width*2;
						_tmpEffect.effectMC.height = _tmpEffect.effectMC.height*2;
						this.gameScene.BottomLayer.addChild(_tmpEffect.effectMC);
						delete loadingCatch[_tmpEffect.id];
						loadedMapEffect.push(_tmpEffect.id);
						return;
						break;
				}
				
				var animationSkill:SkillAnimation = new SkillAnimation();				
				var geed:GameSkillData = new GameSkillData(animationSkill);
				geed.Analyze(_tmpEffect.effectMC);
				
				animationSkill.offsetX = _tmpEffect.x;
				animationSkill.offsetY = _tmpEffect.y;
				//				animationSkill.skillID = 4011;

				animationSkill.StartClip("jn");

				switch(_tmpEffect.effectName)
				{
//					case "lightString":
//						animationSkill.frameRate.Frequency = 35;
//						break;
					case "lightSpots":
					case "starLight":
						animationSkill.frameRate.Frequency = 15;
						break;
					case "light":
						animationSkill.frameRate.Frequency = 15;
						animationSkill.width = animationSkill.width*2;
						animationSkill.height = animationSkill.height*2;
						break;
					case "dragonEffect":
						animationSkill.frameRate.Frequency = 20;
						animationSkill.width = animationSkill.width*2;
						animationSkill.height = animationSkill.height*2;
						break;
					case "rightCloud":
					case "rightDownCloud":
						animationSkill.frameRate.Frequency = 7;
						animationSkill.width = animationSkill.width*1.5;
						animationSkill.height = animationSkill.height*1.5;
						break;
					default:
						animationSkill.frameRate.Frequency = 8;
						break;
				}
				
				mapEffects.push(animationSkill);
				//				_tmpEffect.effectMC.x = _tmpEffect.x;
				//				_tmpEffect.effectMC.y = _tmpEffect.y;
				
				this.gameScene.BottomLayer.addChild(animationSkill);
				
				delete loadingCatch[_tmpEffect.id];
				loadedMapEffect.push(_tmpEffect.id);
			}
		}
				
	}	
}