package GameUI.Modules.Bag
{
	import GameUI.Modules.Bag.Proxy.BagData;
	
	public class BagUtils
	{
		public function BagUtils()
		{
		}
		
		/**
		 * count代表物品数量
		 */
		public static function TestBagIsFull(index:int):uint
		{
			var bagList:Array = BagData.AllUserItems[index];	
			var count:uint = 0;
			for(var j:int=0; j<4; j++)
			{
				for(var i:int = 0; i<BagData.BagNum[j]; i++)
				{
					if(bagList[i] != undefined)
					{								
						count++;
					}
				}
			}
			
			return count;
		}
		
		/** 找到背包中的空格子 */
		public static function getNullItemIndex(bagIndex:int):int
		{
			var bagList:Array = BagData.AllUserItems[bagIndex];	
			var res:int = -1;		
			for(var i:int = 0; i < BagData.BagNum[bagIndex]; i++) {
				if(bagList[i] == undefined) {
					res = i;
					break;
				}
			}
			return res;
		}
		
	}
}