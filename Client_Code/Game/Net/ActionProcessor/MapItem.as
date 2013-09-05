package Net.ActionProcessor
{
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.AutoPlay.Data.AutoPlayData;
	import GameUI.Modules.Bag.Proxy.BagData;
	import GameUI.MouseCursor.SysCursor;
	import GameUI.UICore.UIFacade;
	import GameUI.View.items.DroppedItem;
	
	import Net.ActionSend.Zippo;
	import Net.GameAction;
	
	import OopsEngine.AI.PathFinder.MapTileModel;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;

	/** 地图掉包  掉落物品*/
	public class MapItem extends GameAction
	{
		/* 消息类型  */
		public static const CREATE:uint 	 = 1;     //接收 创建
		public static const DELETE:uint 	 = 2; 	  //接收删除 已经无用
		public static const PICK:uint        = 3; 	  //发送捡取
		public static const PICKINRANGE:uint = 4; 	  //发送范围捡取
		
		public static const PackageTypeName:String = "Package";
		
		
		public override function Processor(bytes:ByteArray):void 
		{
			bytes.position       = 4;
			var obj:Object       = null;
			var action:uint      = bytes.readUnsignedInt();			// action 
			var id:uint  	     = bytes.readUnsignedInt();			// 物口编号
			var nPosX:uint       = bytes.readUnsignedShort();		// X
			var nPosY:uint       = bytes.readUnsignedShort();		// Y
			var nTime:uint       = bytes.readUnsignedInt();			// time
			var nItemAmount:uint = bytes.readUnsignedInt();			// 物品数量

			var article:Array = new Array();
			for(var i:int = 0; i < nItemAmount ; i ++)
			{
				var idType:uint = bytes.readUnsignedInt();			// 掉落物品type
				var droppedItem:DroppedItem = new DroppedItem(String(idType));
				droppedItem.Type=idType;
				droppedItem.ID=id;
				droppedItem.name=PackageTypeName+"_"+id+"_"+idType;
				droppedItem.titleX=nPosX;
				droppedItem.titleY=nPosY;
				article.push(droppedItem);
			}
		
			GameCommonData.PackageList[id] = article;//掉落物品包缓存
			// 显示掉落的包
//			var Package:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("McPackage");
//			Package.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
//			Package.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
//			Package.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStageHandler);
//			Package.name		  = PackageTypeName + id;
//			Package.ID   		  = id;
//			Package.Data		  = article;
//			Package.TileX         = nPosX;
//			Package.TileY         = nPosY;
//			Package.isPicked    = false;
//			Package.visible=false;
				
			// 延时显示物品包
			setTimeout(ShowPackage,1000,article);
		}
		
		/** 显示掉包
		 * @param id 包id
		 * @param article 物品数组
		 *   */
		private function ShowPackage(article:Array):void
		{
			if(GameCommonData.Scene.IsSceneLoaded == true)
			{
				//掉落物品
				for(var i:int=0; i<article.length; i++)
				{
					var droppedItem:DroppedItem = article[i] as DroppedItem;
					var p:Point = MapTileModel.GetTilePointToStage(droppedItem.titleX,droppedItem.titleY);
					droppedItem.x = p.x+Math.random()*180-90;
					droppedItem.y = p.y+Math.random()*180-90;
					droppedItem.addEventListener(MouseEvent.CLICK,onMouseClick);
					droppedItem.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
					droppedItem.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
					droppedItem.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStageHandler);
					GameCommonData.GameInstance.GameScene.GetGameScene.BottomLayer.addChild(droppedItem);
				}
				
			}
			if(GameCommonData.Player.IsAutomatism && (AutoPlayData.aSaveTick[5]==0 || AutoPlayData.aSaveTick[6]==0) )
			{
				UIFacade.UIFacadeInstance.autoPickBag();
			}
		}
		
		/**
		 * 拾取物品
		 * **/
		private function onMouseClick(e:MouseEvent):void
		{
			var strName:String=e.currentTarget.name;
			var names:Array=strName.split("_");
			var packId:int=int(names[1]);				//包id
			var typeId:int=int(names[2]);				//物品type
			if(GameCommonData.PackageList[packId] != null)
			{
				var article:Array=GameCommonData.PackageList[packId] as Array;
				for(var i:int=0; i<article.length; i++)
				{
					var droppedItem:DroppedItem = article[i] as DroppedItem;
					if(droppedItem.Type==typeId)
					{
						
						var item:Object = UIConstData.ItemDic_1[typeId];
						//判断背包已经满
						if(BagData.bagIsFull(typeId))
						{
							
						}
						else
						{
							article.splice(i,1);
							var pos:Point=new Point(droppedItem.x,droppedItem.y);
							GameCommonData.GameInstance.GameScene.GetGameScene.BottomLayer.removeChild(droppedItem);
							Zippo.SendPickItem(packId,typeId);
							GameCommonData.UIFacadeIntance.playItemFlyMovie(typeId,pos);
							e.stopImmediatePropagation();//停止传播事件
						}
				
					}
				}
			}
			
		}
		
		/**显示拾取手势**/
		private function onMouseOver(e:MouseEvent):void
		{
			SysCursor.GetInstance().setMouseType(SysCursor.PICK_CURSOR);
		}
		
		/**还原鼠标**/
		private function onMouseOut(e:MouseEvent):void
		{
			SysCursor.GetInstance().revert();
		}
		
		/**物品移除舞台**/
		protected function onRemoveFromStageHandler(e:Event):void
		{
			var mc:MovieClip = e.target as MovieClip;
			mc.removeEventListener(MouseEvent.CLICK,onMouseClick);
			mc.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			mc.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			mc.removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStageHandler);
		}		
		
	}	
}