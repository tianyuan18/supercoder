package GameUI.Modules.Bag.Mediator.DealItem
{
	import GameUI.Modules.Bag.Proxy.BagData;
	import GameUI.Modules.Bag.Proxy.GridUnit;
	import GameUI.Modules.Bag.Proxy.NetAction;
	
	import Net.ActionProcessor.OperateItem;
	
	public class ThrowItem
	{
		public function ThrowItem()
		{
		}
		
		public static function ThrowNone(grid:GridUnit):void
		{
			trace("Throw");
			if(grid == null) return;
			var index:int = grid.Index;
			OperateItem.IsSelfThrow = true;
			NetAction.OperateItem(OperateItem.DROP, 1, BagData.AllUserItems[0][grid.Item.Pos].id, BagData.AllUserItems[0][grid.Item.Pos]);
		}
	}
}