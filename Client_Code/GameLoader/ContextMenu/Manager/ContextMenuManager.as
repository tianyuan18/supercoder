package ContextMenu.Manager
{
	import Data.GameLoaderData;
	
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	/**
	 * 右键菜单管理器
	 * @author:Ginoo
	 * @version:1.0
	 * @langVersion:3.0
	 * @playerVersion:10.0
	 * @since:9/10/2010
	 */
	public class ContextMenuManager
	{
		/** 懒汉 */
		private static var _instance:ContextMenuManager;
		
		/** 舞台 */
		private var _gameSprite:Sprite;
		
		/** 游戏版本号 */
		private var _gameVersin:String
		
		/** 菜单名数组 */
		private var _itemNameArr:Array = [];
		
		/** 函数数组 */
		private var _funArr:Array = [];
		
		//////////////////////////////////////////////////////////
		//constructor function
		
		public function ContextMenuManager(s:Singleton)
		{
			if(!s) throw new Error("Error getting ContextMenuManager");
		}
		
		private var _gameMainVersion:String = "";
		//////////////////////////////////////////////////////////
		//public function
		
		public static function getInstance():ContextMenuManager
		{
			if(!_instance) {
				_instance =  new ContextMenuManager(new Singleton());
				return _instance;
			} else {
				return null;
			}
		}
		
		public function init(game:Sprite, helpFun:Function,mainVersionFun:Function, gameVersion:String=""):void
		{
			_gameSprite = game;
			_gameVersin = gameVersion;
			_gameMainVersion = mainVersionFun();
			if ( GameLoaderData.outsideDataObj.language == 1 )
			{
				_itemNameArr = ["收藏游戏", "江湖指南", "游戏版本：" + _gameVersin+"-"+_gameMainVersion, "操作系统："+ Capabilities.os]; //, "开发商：武汉游悦信息技术有限公司", "《御剑江湖》招聘信息"
			}
			else
			{
				_itemNameArr = ["收藏遊戲", "江湖指南", "遊戲版本：" + _gameVersin+"-"+_gameMainVersion, "操作系統："+ Capabilities.os]; 
			}
			_funArr = [fun_0, fun_1, fun_2, fun_3];	//, fun_3, fun_4
			
			_gameSprite.stage.showDefaultContextMenu = false;
			var cm:ContextMenu = new ContextMenu();
			cm.hideBuiltInItems();
			
			for(var i:int = 0; i < _itemNameArr.length; i++) {
				var item:ContextMenuItem = new ContextMenuItem(_itemNameArr[i]);
				if(i == 1 && helpFun != null) {
					item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, helpFun);
				} else {
					item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, _funArr[i]);
				}
				if(i == 2 || i == 3 || i == 4) item.enabled = false;
				cm.customItems.push(item);
			}
			_gameSprite.contextMenu = cm;
		}
		
		///////////////////////////////////////////////////////////
		//private function
		
		private function fun_0(e:ContextMenuEvent):void
		{
			ExternalInterface.call("addfavor");
		}
		
		private function fun_1(e:ContextMenuEvent):void
		{
			
		}
		
		private function fun_2(e:ContextMenuEvent):void
		{
			
		}
		
		private function fun_3(e:ContextMenuEvent):void
		{
			
		}
		
		private function fun_4(e:ContextMenuEvent):void
		{
			navigateToURL(new URLRequest("http://www.youyuegame.com/rczp.aspx"), "_blank");
		} 
	
		
	}
}

class Singleton
{
	
}
