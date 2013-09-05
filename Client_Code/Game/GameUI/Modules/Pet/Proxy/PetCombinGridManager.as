package GameUI.Modules.Pet.Proxy
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Bag.Command.UseItemCommand;
	import GameUI.Modules.Bag.Proxy.BagData;
	import GameUI.Modules.Bag.Proxy.GridUnit;
	import GameUI.Modules.Pet.Data.PetPropConstData;
	import GameUI.SetFrame;
	import GameUI.UICore.UIFacade;
	import GameUI.View.BaseUI.ItemBase;
	import GameUI.View.items.DropEvent;
	import GameUI.View.items.SkillItem;
	//	import GameUI.View.items.UseItem;
	
	import OopsEngine.Skill.GameSkillMode;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class PetCombinGridManager extends Proxy
	{
		public static const NAME:String = "PetCombinGridManager";
		
		public function PetCombinGridManager()
		{
			super(NAME);
			init();
		}
		
		public function init():void
		{
			for( var i:int = 0; i<PetPropConstData.petRuneGridList.length; i++ )
			{
				var gridUint:GridUnit = PetPropConstData.petRuneGridList[i] as GridUnit;
				gridUint.Grid.addEventListener(MouseEvent.MOUSE_OVER, onMouseMove);
				gridUint.Grid.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				gridUint.Grid.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				gridUint.Grid.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
			}
		}
		
		public function gc():void
		{
			for( var i:int = 0; i<PetPropConstData.petRuneGridList.length; i++ )
			{
				var gridUint:GridUnit = PetPropConstData.petRuneGridList[i] as GridUnit;
				gridUint.Grid.removeEventListener(MouseEvent.MOUSE_OVER, onMouseMove);
				gridUint.Grid.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				gridUint.Grid.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				gridUint.Grid.removeEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
			}
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			if(PetPropConstData.SelectedPetItem)
			{
				if(event.currentTarget.name.split("_")[1] == PetPropConstData.SelectedPetItem.Index) return;
			}
			SetFrame.UseFrame(event.currentTarget as DisplayObject, "RedFrame");		
		}
		
		private function onMouseOut(event:MouseEvent):void
		{
			SetFrame.RemoveFrame(event.currentTarget.parent, "RedFrame");
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			SetFrame.RemoveFrame(event.currentTarget.parent);
			SetFrame.RemoveFrame(event.currentTarget.parent, "RedFrame");
			var index:int = int(event.target.name.split("_")[1]);
			if(PetPropConstData.petRuneGridList[index].Item)
			{
				SetFrame.UseFrame(PetPropConstData.petRuneGridList[index].Grid);
				
				PetPropConstData.SelectedPetItem = BagData.GridUnitList[index];
				
				var displayObj:DisplayObject=event.target as DisplayObject;
				if(displayObj.mouseX<=2 || displayObj.mouseX>=displayObj.width-2){
					return;
				}
				if(displayObj.mouseY<=2 || displayObj.mouseY>=displayObj.height-2){
					return;
				}
				PetPropConstData.petRuneGridList[index].Item.addEventListener(DropEvent.DRAG_DROPPED, dragDroppedHandler);
				PetPropConstData.petRuneGridList[index].Item.onMouseDown();
			}
			
		}
		
		private function doubleClickHandler(event:MouseEvent):void
		{
			if(!PetPropConstData.SelectedPetItem) return;
			if(!PetPropConstData.SelectedPetItem.Item) {
				return;
			}
			if(PetPropConstData.SelectedPetItem.Item.IsLock == true) return;
			if(BagData.AllUserItems[0][PetPropConstData.SelectedPetItem.Index]==undefined)
			{
				sendNotification(EventList.UPDATEBAG);
				return;
			}
			
			facade.sendNotification(UseItemCommand.NAME);
		}
		
		private function dragDroppedHandler(e:DropEvent):void
		{
			e.target.removeEventListener(DropEvent.DRAG_DROPPED, dragDroppedHandler);
			var obj:Object=UIConstData.getItem(e.Data.source.Type);
			
			switch(e.Data.type)
			{
				case "selectedRune":
					
					break;
			}
		}
	}
}