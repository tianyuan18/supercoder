package control
{
	import common.App;
	import common.STDispatcher;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	import frame.ProjectWindow.WindowMap;
	
	import model.MapState;
	import model.STEvent;
	
	import modelBase.MapItem;
	import modelBase.MapItemType;
	
	import modelExtend.MapExtend;
	
	import mx.controls.Alert;
	
	
	public class MapItemPanel extends MapPanel
	{
		private var _windowMap:WindowMap;
		private var moveItem:Sprite=null;
		private var tmpPoint:Point=null;
		
		private function get _map():MapExtend{
			
			if(App.proCurrernt!=null && App.proCurrernt.MapCurrent!=null){
				return App.proCurrernt.MapCurrent;
			}else{
				this.hide();
				return null;
			}
		}
		public function MapItemPanel()
		{
			super();
			STDispatcher.dis.addEventListener(STEvent.MAP_ITEMTYPE_CREATE_START,onNpcRoleCreateStart);
		}
		
		public function set windowMap(value:WindowMap):void
		{
			_windowMap = value;
		}

		public function get windowMap():WindowMap
		{
			return _windowMap;
		}
		
		
		public override function show():void{
			removeAll();
			var types:Vector.<MapItemType>=App.proCurrernt.mapItemTypes;
			for(var t:int=0;t<types.length;t++){
				
				for(var i:int=0;i<_map.mapItems.length;i++)
				{
					var mapItem:MapItem=_map.mapItems[i];
					if(types[t].iD==mapItem.typeid){
						var npcAnim:TempMapItemPlayer=new TempMapItemPlayer(mapItem);
						npcAnim.x=mapItem.x;
						npcAnim.y=mapItem.y;
						this.addChild(npcAnim);
						npcAnim.parent.parent .addEventListener(MouseEvent.MOUSE_DOWN,onStartMOUSE_DOWN);
						//npcAnim.parent.parent .addEventListener(KeyboardEvent.KEY_DOWN,onStartKeyboard_DOWN);
					}
				}
			}
			super.show();
		}

		/**
		 *新建一个地图元素对象到地图上 
		 * @param evt
		 * 
		 */		
		private function onNpcRoleCreateStart(evt:STEvent):void{
			
			if(_map.mapState!=MapState.NPCSET){
				windowMap.setState(MapState.NPCSET);
			}
			
			if(_windowMap!=null){
			
				var mapItem:MapItem=evt.Data as MapItem;
				var npcAnim:TempMapItemPlayer=new TempMapItemPlayer(mapItem);
				mapItem.x=npcAnim.x=mapItem.x+_windowMap.horizontalScrollPosition;
				mapItem.y=npcAnim.y=mapItem.y+_windowMap.verticalScrollPosition;
				this.addChild(npcAnim);
				_map.mapItems.push(mapItem);
				npcAnim.parent.parent .addEventListener(MouseEvent.MOUSE_DOWN,onStartMOUSE_DOWN);
				
			}
			windowMap.mapItemBar.RefreshDataTree();
		}
		/**
		 *按下del键删除当前选中的地图元素 
		 * @param evt
		 * 
		 */		
		private function onStartKeyboard_DOWN(evt:KeyboardEvent):void{
			if((evt.charCode == 127)&&(moveItem != null)){
				this.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onStartKeyboard_DOWN);
				if(moveItem is TempMapItemPlayer){
					delMoveItem(moveItem);
				}
				
			}
		}
		/**
		 *删除一个地图对象 
		 * @param _moveItem
		 * 
		 */		
		private function delMoveItem(_moveItem:Sprite):void{
			if(_moveItem is TempMapItemPlayer){
				for(var i:int=0;i<_map.mapItems.length;i++){
					var mapItem:MapItem=_map.mapItems[i];
					if((_moveItem as TempMapItemPlayer).mapItem.id ==mapItem.id ){
						_map.mapItems.splice(i,1);						
					}
					
				}
				_moveItem.parent.removeChild(_moveItem);
				_moveItem = null;
			}
		}
		
		//开始移动npc
		private function onStartMOUSE_DOWN(evt:MouseEvent):void{
			var r:int=20;
			moveItem=null;
			if(_map.mapState!=MapState.NPCSET){
				return;
			}else{
				//找到需要移动的npc
				var lp:Point= this.globalToLocal(new Point(evt.stageX,evt.stageY));
				for(var i:int=0;i<this.numChildren;i++){
					var item:Sprite=this.getChildAt(i) as Sprite;
					if(item.x-r<lp.x && item.y-r<lp.y && item.x+r>lp.x && item.y+r>lp.y){
						moveItem=item;
						if(moveItem is TempMapItemPlayer){
							SelectNpc((moveItem as TempMapItemPlayer).mapItem.id);
						}
						
						break;
					}
				}
				if(moveItem==null){
					return;
				}
			}
				
			tmpPoint=new Point(evt.stageX-moveItem.x,evt.stageY-moveItem.y);
			moveItem.parent.setChildIndex(moveItem,moveItem.parent.numChildren-1);
			moveItem.parent.parent .removeEventListener(MouseEvent.MOUSE_DOWN,onStartMOUSE_DOWN);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			this.stage.removeEventListener(MouseEvent.MOUSE_DOWN,onMOUSE_DOWN);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			
		}
		
		//移动中
		private function onMove(evt:MouseEvent):void{
			
			if(_map.mapState!=MapState.NPCSET){
				if(moveItem!=null){
					if(moveItem is TempMapItemPlayer){
						moveItem.x=(moveItem as TempMapItemPlayer).mapItem.x;
						moveItem.y=(moveItem as TempMapItemPlayer).mapItem.y;
					}
				}
				this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
				this.stage.removeEventListener(MouseEvent.MOUSE_DOWN,onMOUSE_DOWN);
				return;
			}
			
			if(moveItem!=null){
				this.stage.removeEventListener(MouseEvent.MOUSE_DOWN,onMOUSE_DOWN);
				this.stage.addEventListener(MouseEvent.MOUSE_DOWN,onMOUSE_DOWN);
				moveItem.x=evt.stageX-tmpPoint.x;
				moveItem.y=evt.stageY-tmpPoint.y;
			}else{
				this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
				this.stage.removeEventListener(MouseEvent.MOUSE_DOWN,onMOUSE_DOWN);
			}
		}
		
		//确定最终位置
		private function onMOUSE_DOWN(evt:MouseEvent):void{
			if(_map.mapState!=MapState.NPCSET){
				if(moveItem!=null){
					if(moveItem is TempMapItemPlayer){
						moveItem.x=(moveItem as TempMapItemPlayer).mapItem.x;
						moveItem.y=(moveItem as TempMapItemPlayer).mapItem.y;
					}
				}
				this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
				this.stage.removeEventListener(MouseEvent.MOUSE_DOWN,onMOUSE_DOWN);
				return;
			}
			
			if(moveItem is TempMapItemPlayer){
				(moveItem as TempMapItemPlayer).mapItem.x=moveItem.x;
				(moveItem as TempMapItemPlayer).mapItem.y=moveItem.y;
			}
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			this.stage.removeEventListener(MouseEvent.MOUSE_DOWN,onMOUSE_DOWN);
			if(moveItem.parent != null){
				moveItem.parent.parent.removeEventListener(MouseEvent.MOUSE_DOWN,onStartMOUSE_DOWN);
				moveItem.parent.parent.addEventListener(MouseEvent.MOUSE_DOWN,onStartMOUSE_DOWN);
			}
			
			moveItem=null;
		}
		
		public function SelectNpc(nocID:int):void{
			for(var i:int=0;i<this.numChildren;i++){
				var item:Sprite=this.getChildAt(i) as Sprite;
				var iid:int=0;
				if(item is TempMapItemPlayer){
					iid=(item as TempMapItemPlayer).mapItem.id;
				}
				
				if(nocID==iid){
					item.filters= [new GlowFilter(0xfaf674,1,10,10,3)];
					this.stage.addEventListener(KeyboardEvent.KEY_DOWN,onStartKeyboard_DOWN);
				}else{
					item.filters=[];
				}
			}
		}
		
		
		public function removeAll():void{
			while(this.numChildren>0){
				var npcAnim:Sprite=this.getChildAt(0) as  Sprite;
				npcAnim.parent.parent .removeEventListener(MouseEvent.MOUSE_DOWN,onStartMOUSE_DOWN);
				if(this.stage.hasEventListener(KeyboardEvent.KEY_DOWN)){
					this.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onStartKeyboard_DOWN);
				}
				this.removeChildAt(0);
			}
		}
	}
}

import common.App;

import control.BaseAnimeObject;
import control.BaseBmpDataCollection;
import control.SwfBmpDataCollection;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import modelBase.MapItem;
import modelBase.MapItemType;
import flash.display.Loader;
import flash.events.Event;
import flash.display.LoaderInfo;
import flash.display.Bitmap;
import flash.net.URLRequest;

class TempMapItemPlayer extends Sprite
{
	
	public var mapItem:MapItem;
	public function TempMapItemPlayer(mapItem:MapItem)
	{
		super();
		this.mapItem=mapItem;
		var npcRole:MapItemType=App.proCurrernt.getMapItemType(mapItem.typeid);
		var animStr:String=App.proCurrernt.pathRoot+"images\\npcRole\\"+npcRole.iD+".png";
		{
			var loader1:Loader=new Loader();
			var mapItemPanelTmp:Sprite=this;
			var bitmap:Bitmap=new Bitmap();
			loader1.contentLoaderInfo.addEventListener(Event.COMPLETE,function(evt1:Event):void{
				
				bitmap.bitmapData=((evt1.currentTarget as LoaderInfo).content as Bitmap).bitmapData;
				bitmap.x=-bitmap.width/2;
				bitmap.y=-bitmap.height;
				
			});
			loader1.load(new URLRequest(App.proCurrernt.pathRoot+"images\\mapItemType\\"+npcRole.iD+".png"));
			mapItemPanelTmp.addChild(bitmap);
		}
		
		var type:TextField=new TextField();
		type.autoSize=TextFieldAutoSize.LEFT;
		type.height=18;
		type.text=App.proCurrernt.getMapItemType(mapItem.typeid).name;
		type.x=-(type.width/2);
		type.y=-20;
		this.addChild(type);
		
		var txt:TextField=new TextField();
		txt.autoSize=TextFieldAutoSize.LEFT;
		txt.height=18;
		txt.text=mapItem.id+mapItem.name;
		txt.x=-(txt.width/2);
		txt.y=-2;
		this.addChild(txt);
		
		var textFormat:TextFormat=new TextFormat();
		textFormat.color=0xff0000;
		txt.setTextFormat(textFormat);
		type.setTextFormat(textFormat);
		
		graphics.clear();
		graphics.beginFill(0x00ff00,1);
		graphics.drawCircle(0,0,5);
		graphics.endFill();
	}
	
	public function onComplete(event:*):void
	{
		
	}
}