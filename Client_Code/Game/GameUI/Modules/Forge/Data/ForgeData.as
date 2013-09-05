package GameUI.Modules.Forge.Data
{
	import GameUI.Modules.Bag.Proxy.GridUnit;
	import GameUI.Modules.GmTools.Utils.LoadSwfTool;
	
	import flash.utils.Dictionary;
	
	public class ForgeData
	{
		public function ForgeData()
		{
		}
		
		public static const forgeEquipGridList:Array = new Array();
		
		public static const forgeBuyGridList:Array = new Array();
		
		public static var curPage:int = -1;
		
		public static var countEquiped:int=0;//记录装备上物品的数量
		
		public static var equipList:Array = null;
		
		public static var selectItem:GridUnit = null;
		public static var lastsItem:GridUnit = null;
		public static var updataItemId:int = 0;//记录操作成功后返回的装备id
		
		public static var newItem:Object = null;//品质提升装备预显示
		
		public static var selectIdArray:Dictionary = null;//选中物品的id
		
		public static var selectMaterial:Object = null;
		
		public static var updateLock:Boolean = false;//true打开，false关闭
		
		/** 记录第几个洗炼属性被锁定 */
		public static var selectBaptizeIndex:int = -1;
		
		/** 资源加载获取类 */
		public static var loadswfTool:LoadSwfTool=null;
		
		/** 计算强化值系数 */
		public static const ratio:Number = 1.3;
		
		/** 强化最高值 */
		public static const MAX_STRENGTH:int = 12;
		
		/** 洗炼属性锁 */
		public static var AddLockList:Array = [0,0,0,0,0];//0代表未锁定，1代表锁定
		
		/** 洗炼石 */
		public static const stoneList:Array = [610300,610301,610302,610303];
		
		/** 装备颜色 白，绿，蓝，紫，橙*/
		public static const equipColorList:Array = ["#FFFFFF","#FFFFFF","#00ff00","#0098FF","#9727ff","#FF6532","#730E54","#dd00ac"];
		
		/** 装备品质 普通，优秀，精良，完美*/
		public static const equipStarList:Array = ["普通","普通","优秀","精良","完美"];
		
		/** 锻造通用配置表 */
		public static var forgeCommDataList:Dictionary = new Dictionary();
		
		public static function getIndexById(id:int):int
		{
			for(var i:int=0;i<equipList.length; i++)
			{
				if(equipList[i]!= null&&equipList[i]!=undefined)
				{
					if(equipList[i].id == id)
					{
						return i;
					}
				}
			}
			return -1;
		}
	}
}