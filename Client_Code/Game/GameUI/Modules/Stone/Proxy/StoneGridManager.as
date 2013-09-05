package GameUI.Modules.Stone.Proxy
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Bag.Proxy.GridUnit;
	import GameUI.Modules.Bag.Proxy.BagData;
	import GameUI.Modules.Stone.Datas.StoneDatas;
	import GameUI.Modules.Stone.Datas.StoneEvents;
	import GameUI.SetFrame;
	import GameUI.UICore.UIFacade;
	import GameUI.View.items.DropEvent;
	import GameUI.View.items.SkillItem;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class StoneGridManager extends Proxy
	{
		public static const NAME:String = "StoneGridManager";
		
		public function StoneGridManager()
		{
			super(NAME);
		}
		
		public function init():void
		{
			for( var i:int = 0; i<StoneDatas.stoneMaterialGridList.length; i++ )
			{
				var gridUint:GridUnit = StoneDatas.stoneMaterialGridList[i] as GridUnit;
				
				if(gridUint && gridUint.Item)
				{
					gridUint.Grid.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					
				}
			}
			
		}
		
		public function gc():void
		{
			for( var i:int = 0; i<StoneDatas.stoneMaterialGridList.length; i++ )
			{
				var gridUint:GridUnit = StoneDatas.stoneMaterialGridList[i] as GridUnit;
				
				if(gridUint && gridUint.Item)
				{
					gridUint.Grid.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				}
			}
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			SetFrame.RemoveFrame(event.currentTarget.parent);
			SetFrame.RemoveFrame(event.currentTarget.parent, "FrameChoose");
			
			var index:int = int(event.currentTarget.name.split("_")[2]);
			
			if(StoneDatas.stoneMaterialGridList[index].Item)
			{
//				SetFrame.RemoveFrame(StoneDatas.stoneMaterialGridList[StoneDatas.lastStoneGridIndex].Grid);
//				SetFrame.UseFrame(StoneDatas.stoneMaterialGridList[index].Grid,"FrameChoose");
//				StoneDatas. = ForgeData.selectItem;
//				ForgeData.selectItem = ForgeData.forgeEquipGridList[index];
				
				StoneDatas.stoneSelectMaterial = BagData.getItemByType(StoneDatas.stoneMaterialGridList[index].Item.Type);
				GameCommonData.UIFacadeIntance.sendNotification(StoneEvents.SELECT_MATERIAL_ONMOUSEDOWN,index);
			}
		}
	}
}