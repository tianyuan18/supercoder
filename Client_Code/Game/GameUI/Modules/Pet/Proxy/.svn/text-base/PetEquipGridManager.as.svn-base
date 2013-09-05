package GameUI.Modules.Pet.Proxy
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Bag.Command.UseItemCommand;
	import GameUI.Modules.Bag.Proxy.BagData;
	import GameUI.Modules.Bag.Proxy.GridUnit;
	import GameUI.Modules.Pet.Data.PetPropConstData;
	import GameUI.Modules.Pet.Proxy.PetNetAction;
	import GameUI.SetFrame;
	import GameUI.UICore.UIFacade;
	import GameUI.View.BaseUI.ItemBase;
	import GameUI.View.items.DropEvent;
	import GameUI.View.items.SkillItem;
	import GameUI.View.items.UseItem;
	
	import Net.ActionProcessor.PlayerAction;
	
	import OopsEngine.Role.GamePetRole;
	import OopsEngine.Skill.GameSkillMode;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class PetEquipGridManager extends Proxy
	{
		public static const NAME:String = "PetSkillGridManager";

		public function PetEquipGridManager()
		{
			super(NAME);
			init();
		}
		
		public function init():void
		{
			for( var i:int = 0; i<PetPropConstData.petEquipGridList.length; i++ )
			{
				if(PetPropConstData.petEquipGridList[i])
				{
					var gridUint:GridUnit = PetPropConstData.petEquipGridList[i] as GridUnit;
					gridUint.Grid.addEventListener(MouseEvent.MOUSE_OVER, onMouseMove);
					gridUint.Grid.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
					gridUint.Grid.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					gridUint.Grid.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
				}
			}
		}
		
		public function gc():void
		{
			for( var i:int = 0; i<PetPropConstData.petEquipGridList.length; i++ )
			{
//				var gridUint:GridUnit = PetPropConstData.petEquipGridList[i] as GridUnit;
//				if(PetPropConstData.petEquipGridList[i])
//				{
//					gridUint.Grid.removeEventListener(MouseEvent.MOUSE_OVER, onMouseMove);
//					gridUint.Grid.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
//					gridUint.Grid.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
//					gridUint.Grid.removeEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
//				}
				var gridUint:GridUnit = PetPropConstData.petEquipGridList[i] as GridUnit;
				if(gridUint)
				{
					gridUint.Grid.removeEventListener(MouseEvent.MOUSE_OVER, onMouseMove);
					gridUint.Grid.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
					gridUint.Grid.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					gridUint.Grid.removeEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
					
					if(gridUint.Item&&(gridUint.Item as UseItem).parent)
					{
						(gridUint.Item as UseItem).parent.removeChild(gridUint.Item as UseItem);
						(gridUint.Item as UseItem).reset();
						(gridUint.Item as UseItem).gc();
					}
				}
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
			if(PetPropConstData.petEquipGridList[index].Item)
			{
				SetFrame.UseFrame(PetPropConstData.petEquipGridList[index].Grid);
//				var p:Object = BagData.AllUserItems[0];
				PetPropConstData.SelectedPetItem = PetPropConstData.petEquipGridList[index];
				var displayObj:DisplayObject=event.target as DisplayObject;
				if(displayObj.mouseX<=2 || displayObj.mouseX>=displayObj.width-2){
					return;
				}
				if(displayObj.mouseY<=2 || displayObj.mouseY>=displayObj.height-2){
					return;
				}
				PetPropConstData.petEquipGridList[index].Item.addEventListener(DropEvent.DRAG_DROPPED, dragDroppedHandler);
				PetPropConstData.petEquipGridList[index].Item.onMouseDown();
			}
			
		}
		
		private function doubleClickHandler(event:MouseEvent):void
		{
//			if(!PetPropConstData.SelectedPetItem) return;
//			if(!PetPropConstData.SelectedPetItem.Item) {
//				return;
//			}
//			if(PetPropConstData.SelectedPetItem.Item.IsLock == true) return;
//			if(BagData.AllUserItems[0][PetPropConstData.SelectedPetItem.Index]==undefined)
//			{
//				sendNotification(EventList.UPDATEBAG);
//				return;
//			}
//			
//			facade.sendNotification(UseItemCommand.NAME);
//			var index:int = int(e.Data.target.name.split("_")[1]);
			
			if(PetPropConstData.SelectedPetItem)
			{
				var item:Object = PetPropConstData.SelectedPetItem.Item;
				if(item)
				{
					//							var pet:GamePetRole = GameCommonData.Player.Role.PetSnapList[PetPropConstData.selectedPetId];
					//穿戴装备
					PetNetAction.opPet(PlayerAction.NEWPET_PLAY_EQUIP, PetPropConstData.selectedPetId,"",item.Id);
				}
			}
		}
		
		private function dragDroppedHandler(e:DropEvent):void
		{
			e.target.removeEventListener(DropEvent.DRAG_DROPPED, dragDroppedHandler);
			var obj:Object=UIConstData.getItem(e.Data.source.Type);
			
			switch(e.Data.type)
			{
				case "petEquip":
					var index:int = int(e.Data.target.name.split("_")[1]);
					
					if(PetPropConstData.SelectedPetItem)
					{
						var item:Object = PetPropConstData.SelectedPetItem.Item;
						//项链
//						if(PetPropConstData.SelectedPetItem.Item.Type>1500000 && PetPropConstData.SelectedPetItem.Item.Type<1600000 && index == 0)
//						{
//							
//						}
//						//戒子
//						else if(PetPropConstData.SelectedPetItem.Item.Type>2100000 && PetPropConstData.SelectedPetItem.Item.Type<2200000 && index == 1)
//						{
//							
//						}
//						//武器
//						else if(PetPropConstData.SelectedPetItem.Item.Type>1400000 && PetPropConstData.SelectedPetItem.Item.Type<1500000 && index == 2)
//						{
//							
//						}
//						//鞋子
//						else if(PetPropConstData.SelectedPetItem.Item.Type>1900000 && PetPropConstData.SelectedPetItem.Item.Type<2000000 && index == 3)
//						{
//							
//						}
						if(item)
						{
//							var pet:GamePetRole = GameCommonData.Player.Role.PetSnapList[PetPropConstData.selectedPetId];
							//穿戴装备
							PetNetAction.opPet(PlayerAction.NEWPET_PLAY_EQUIP, PetPropConstData.selectedPetId,"",item.Id);
						}
					}
					break;
			}
		}
	}
}