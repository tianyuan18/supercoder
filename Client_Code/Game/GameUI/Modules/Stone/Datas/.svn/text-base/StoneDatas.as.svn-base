package GameUI.Modules.Stone.Datas
{
	import GameUI.Modules.Bag.Proxy.GridUnit;
	import GameUI.Modules.GmTools.Utils.LoadSwfTool;
	
	import flash.utils.Dictionary;
	
	public class StoneDatas
	{
		public function StoneDatas()
		{
		}
		
		public static var stoneCurPage:int= 0;
		
		/** 资源加载获取类 */
		public static var stoneLoadswfTool:LoadSwfTool=null;
		
		public static var stoneSelectItem:Object = null;
		public static var stoneLastItem:Object = null;
		public static var stoneUpdataItemId:int = 0;//记录操作成功后返回的装备id
		
		public static var stoneCountEquiped:int=0;//记录装备上物品的数量
		
		public static var lastStoneGridIndex:int = 0;
		
		/** 右侧装备列表 */
		public static var stoneEquipList:Array = null;
		
		/** 右侧下栏宝石列表 */
		public static var stoneMaterialList:Array = null;
		
		/** 当前分类列表 */
		public static var stoneAllStoneList:Array = null;
		
		public static var stoneSelectMaterial:Object = null;
		
		public static var stoneEquipGridList:Array = new Array();
		
		public static var stoneMaterialGridList:Array = new Array();
		
		public static var stoneSelectIdArray:Dictionary = null;//选中物品的id
		
		/** 装备颜色 白，绿，蓝，紫，橙*/
		public static const stoneEquipColorList:Array = ["#FFFFFF","#FFFFFF","#00ff00","#0098FF","#9727ff","#FF6532","#730E54","#dd00ac"];
		
		/** 装备品质 普通，优秀，精良，完美*/
		public static const stoneEquipStarList:Array = ["普通","普通","优秀","精良","完美"];
		
		public static function getIndexByIdFromStone(id:int):int
		{
			for(var i:int=0;i<stoneEquipList.length; i++)
			{
				if(stoneEquipList[i]!= null&&stoneEquipList[i]!=undefined)
				{
					if(stoneEquipList[i].id == id)
					{
						return i;
					}
				}
			}
			return -1;
		}
		
	}
}