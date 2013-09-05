package GameUI.Modules.Forge.Proxy
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Bag.Command.UseItemCommand;
	import GameUI.Modules.Bag.Proxy.BagData;
	import GameUI.Modules.Bag.Proxy.GridUnit;
	import GameUI.Modules.Forge.Data.ForgeData;
	import GameUI.Modules.Forge.Data.ForgeEvent;
	import GameUI.SetFrame;
	import GameUI.UICore.UIFacade;
	import GameUI.View.BaseUI.ItemBase;
	import GameUI.View.items.DropEvent;
	import GameUI.View.items.SkillItem;
	
	import OopsEngine.Skill.GameSkillMode;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class ForgeBagGridManager extends Proxy
	{
		public static const NAME:String = "PetSkillGridManager";
		public var mouseDownClick:Function = null;

		private var _nRed:Number=0.3086;
		private var _nGreen:Number=0.6094;
		private var _nBlue:Number=0.0820;
		
		public function ForgeBagGridManager()
		{
			super(NAME);
		}
		
		public function init():void
		{
			for( var i:int = 0; i<ForgeData.forgeEquipGridList.length; i++ )
			{
				var gridUint:GridUnit = ForgeData.forgeEquipGridList[i] as GridUnit;

				if(gridUint)
				{
					gridUint.Grid.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
//					gridUint.Grid.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					
				}
			}
			
		}
		
		public function gc():void
		{
			for( var i:int = 0; i<ForgeData.forgeEquipGridList.length; i++ )
			{
				var gridUint:GridUnit = ForgeData.forgeEquipGridList[i] as GridUnit;

				if(gridUint)
				{
					gridUint.Grid.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
//					gridUint.Grid.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				}
			}
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			SetFrame.RemoveFrame(event.currentTarget.parent);
			SetFrame.RemoveFrame(event.currentTarget.parent, "FrameChoose");
			var index:int = int(event.currentTarget.name.split("_")[2]);

			if(ForgeData.forgeEquipGridList[index].Item)
			{
				SetFrame.UseFrame(ForgeData.forgeEquipGridList[index].Grid,"FrameChoose");
				ForgeData.lastsItem = ForgeData.selectItem;
				ForgeData.selectItem = ForgeData.forgeEquipGridList[index];
			}
			
			GameCommonData.UIFacadeIntance.sendNotification(ForgeEvent.SELECT_ITEM_ONMOUSEDOWN,index);
		}

	}
}