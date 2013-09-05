package GameUI.Modules.Forge.Proxy
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Bag.Command.UseItemCommand;
	import GameUI.Modules.Bag.Proxy.BagData;
	import GameUI.Modules.Bag.Proxy.GridUnit;
	import GameUI.Modules.Forge.Data.ForgeData;
	import GameUI.Modules.Forge.Data.ForgeEvent;
	import GameUI.Modules.Maket.Data.MarketEvent;
	import GameUI.SetFrame;
	import GameUI.UICore.UIFacade;
	import GameUI.View.BaseUI.ItemBase;
	import GameUI.View.items.DropEvent;
	import GameUI.View.items.SkillItem;
	
	import OopsEngine.Skill.GameSkillMode;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class ForgeBuyGridManager extends Proxy
	{
		public static const NAME:String = "PetSkillGridManager";
		
		public function ForgeBuyGridManager()
		{
			super(NAME);
		}
		
		public function init():void
		{
			for( var i:int = 0; i<ForgeData.forgeBuyGridList.length; i++ )
			{
				var tmpBuy:MovieClip = ForgeData.forgeBuyGridList[i] as MovieClip;
				if(tmpBuy)
				{
					tmpBuy.btnBuy.addEventListener(MouseEvent.CLICK,onFastBuy);
				}
				
//				var gridUint:GridUnit = ForgeData.forgeBuyGridList[i] as GridUnit;
//
//				if(gridUint)
//				{
//					gridUint.Grid.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
//					gridUint.Grid.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
//				}
			}
		}
		
		public function gc():void
		{
			for( var i:int = 0; i<ForgeData.forgeBuyGridList.length; i++ )
			{
				var tmpBuy:MovieClip = ForgeData.forgeBuyGridList[i] as MovieClip;
				if(tmpBuy)
				{
					if(ForgeData.curPage == 3)
					{
						tmpBuy.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					}else
					{
						tmpBuy.btnBuy.removeEventListener(MouseEvent.CLICK,onFastBuy);
					}
					if(tmpBuy.parent)
					{
						tmpBuy.parent.removeChild(tmpBuy);
						delete ForgeData.forgeBuyGridList[i];
					}
				}
				
//				var gridUint:GridUnit = ForgeData.forgeBuyGridList[i] as GridUnit;
//
//				if(gridUint)
//				{
//					gridUint.Grid.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
//					gridUint.Grid.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
//					
//				}
				
			}
		}
		
		private function onFastBuy(e:MouseEvent):void
		{
			var type:int = e.currentTarget.parent.txtType.text;
			var good:Object = new Object();
			good.type = type;		//商品typeId
			good.count = 1;		//购买数量
			good.payType = 1;	//支付方式
			GameCommonData.UIFacadeIntance.sendNotification(MarketEvent.BUY_ITEM_MARKET,good);
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
//			(event.target as MovieClip).mouseChildren = false;
//			SetFrame.RemoveFrame(event.currentTarget.parent);
//			SetFrame.RemoveFrame(event.currentTarget.parent, "FrameChoose");
			var type:int = event.currentTarget.parent.txtType.text;
			if(BagData.hasItemNum(type)>0)
			{
				ForgeData.selectMaterial = BagData.getItemByType(type);
				GameCommonData.UIFacadeIntance.sendNotification(ForgeEvent.SELECT_MATERIAL_ONMOUSEDOWN);
			}
//			var index:int = int(event.currentTarget.name.split("_")[1]);
//			if(ForgeData.forgeBuyGridList[index].Item)
//			{
//				SetFrame.UseFrame(ForgeData.forgeBuyGridList[index].Grid,"FrameChoose");
//				
//				ForgeData.selectMaterial = ForgeData.forgeBuyGridList[index];
//			}
//			GameCommonData.UIFacadeIntance.sendNotification(ForgeEvent.SELECT_MATERIAL_ONMOUSEDOWN);
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
//			(event.target as MovieClip).mouseChildren = true;
		}

//		
//		//添加外框
//		private function UseFrame(grid:DisplayObject):void
//		{
//			var yellowFrame:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("");
//			yellowFrame.name = name;
//			yellowFrame.mouseEnabled = false;
//			yellowFrame.mouseChildren = false;
//			grid.parent.addChild(yellowFrame);
//			grid.parent.setChildIndex(yellowFrame, grid.parent.numChildren-1);
//			//grid.parent.parent.setChildIndex(grid.parent, grid.parent.parent.numChildren-1);
//			yellowFrame.x = grid.x;
//			yellowFrame.y = grid.y;	
//		}		
//		
//		//移除黄框
//		private function RemoveFrame(parent:DisplayObjectContainer):void
//		{
//			if(parent==null)return;
//			var count:int = parent.numChildren-1;
//			while(count)
//			{
//				if(parent.getChildByName(name)) 
//				{
//					parent.removeChild(parent.getChildByName(name));
//				}
//				count--;
//			}
//		}
	}
}