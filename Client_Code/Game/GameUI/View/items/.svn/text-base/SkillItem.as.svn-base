package GameUI.View.items
{
	import Controller.CooldownController;
	
	import GameUI.UICore.UIFacade;
	import GameUI.View.BaseUI.ItemBase;
	import GameUI.View.ResourcesFactory;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class SkillItem extends ItemBase
	{
		private var icon:Bitmap;
	
	
		private var startDragTmp:Sprite = null;
		private var _w:Number;
		private var _h:Number;
		public function SkillItem(icon:String, parent:DisplayObjectContainer, mkDir:String = "Icon",w:Number = 0,h:Number = 0)
		{
			this.Id=uint(icon);
			this.Type=this.Id;
			_w = w;
			_h = h;
			super(icon, parent, mkDir);
		}
				
		protected override function onLoabdComplete():void
		{
			icon = ResourcesFactory.getInstance().getBitMapResourceByUrl(GameCommonData.GameInstance.Content.RootDirectory+ "Resources/"+mkDir+"/" + this.iconName + ".png");
			if(this.icon==null){
				this.icon=GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("NoResource");
			}
			if(_w != 0)
				icon.width = _w;
			if(_h != 0)
				icon.height = _h;
			
			this.addChild(icon);
			super.onLoabdComplete();
			this.setSkillMask();
		}
		
		public function onMouseDown():void
		{
//			trace("on mouse is down ");
			//if(!CooldownController.getInstance().cooldownReady(this.Type)) return;
			tmpX = this.x;
			tmpY = this.y;
			//绘制可拖的bitmap_____________________________________________________
			var bitmap:Bitmap = new Bitmap();
			var bmd:BitmapData = new BitmapData(WIDTH, HEIGHT);
			bmd.draw(this.icon);
			bitmap.bitmapData = bmd;
			startDragTmp = new Sprite();
			startDragTmp.alpha = .8;
			startDragTmp.addChild(bitmap);
			startDragTmp.mouseChildren = false;
			startDragTmp.mouseEnabled = false;
			var point:Point = this.localToGlobal(new Point(this.x, this.y)) as Point;
			startDragTmp.x = point.x;
			startDragTmp.y = point.y;
			startDragTmp.startDrag();
			GameCommonData.GameInstance.GameUI.addChild(startDragTmp);
			
			//____________________________________________________________________
			//在主场景中添加该绘制
			GameCommonData.GameInstance.GameUI.addEventListener(MouseEvent.MOUSE_UP, gameUIMouseUp);
			GameCommonData.GameInstance.GameUI.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			GameCommonData.GameInstance.GameUI.mouseEnabled = true;
		}
		
		/**
		 * 设置图片的大小 
		 * @param width
		 * @param height
		 * 
		 */		
		public function setImageScale(width:int,height:int):void
		{
			if(icon)
			{
				this.icon.width = _w;
				this.icon.height = _w;
			}
			_w = width;
			_h = height;
		}
		
		//移动物品，在拖动过程中永远让该拖动对象处在最上层
		private function onMouseMove(e:MouseEvent):void
		{
			GameCommonData.GameInstance.GameUI.addChild(startDragTmp);
		} 
		
		public function getBitmap():Bitmap
		{
			var btmData:BitmapData = new BitmapData(WIDTH, HEIGHT);
			btmData.draw(this.icon);
			var btm:Bitmap = new Bitmap(btmData);
			return btm;
		}
		
		//场景UP事件
		private function gameUIMouseUp(e:MouseEvent):void
		{
			//移除选择框
			removeFrame(e.target.parent);
			GameCommonData.GameInstance.GameUI.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			//关闭GameUI的鼠标事件
			GameCommonData.GameInstance.GameUI.mouseEnabled = false;
			startDragTmp.stopDrag();
			GameCommonData.GameInstance.GameUI.removeEventListener(MouseEvent.MOUSE_UP, gameUIMouseUp);
			GameCommonData.GameInstance.GameUI.removeChild(startDragTmp);
			startDragTmp = null;
			if(e.target == this.parent){//点击时候，作用在同一个对象上面，不做任何的处理
				return;
			}
			//tory 
			var type:String = e.target.name.split("_")[0];
			var index:int = int(e.target.name.split("_")[1]);
			var obj:Object = new Object();
			if(type == "UILayer")
			{
				this.dispatchEvent(new DropEvent(DropEvent.DRAG_THREW, this));
			}
			else
			{
				obj.type = type;
				obj.index = index;
				obj.target = e.target;
				obj.source = this;
				this.dispatchEvent(new DropEvent(DropEvent.DRAG_DROPPED,obj));
				if(this.Type<100000){
					UIFacade.GetInstance(UIFacade.FACADEKEY).dragItem(obj);
				}	
			}			
		}
		
		//移除外框
		//移除黄框
		private function removeFrame(parent:DisplayObjectContainer):void
		{
			if(parent.getChildByName("yellowFrame")) 
    		{
    			parent.removeChild(parent.getChildByName("yellowFrame"));
    		}	
		} 
	}
}