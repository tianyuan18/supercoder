package GameUI.Modules.RoleProperty.Datas
{
	import GameUI.Modules.GmTools.Utils.LoadSwfTool;
	import GameUI.Modules.RoleProperty.Prxoy.ItemUnit;
	
	public class RolePropDatas
	{
		public function RolePropDatas()
		{
		}
		
		/** 资源加载获取类 */
		public static var loadswfTool:LoadSwfTool=null;
		
		//装备栏列表
		public static var ItemUnitList:Array = new Array();
		
		//当前界面
		public static var CurView:int 	= 0;//人物属性大界面跳转
		
		//当前界面
		public static var DesignCurView:int 	= 0;//人物属性大界面跳转
		
		//玩家拥有称号
		public static var UserTitleList:Array = [];
		
		//装备个数，显示在装备栏的装备个数
		public static var EquipNum:int = 13;
		//装备列表，此列表包含了坐骑，法宝
		public static var ItemList:Array = new Array(14);
		
		//选择当前的装备
		public static var SelectedOutfit:ItemUnit = null;
		
		//选择当前的装备
		public static var ItemPos:Array = [14,13,12,11,19,15,22,17,21,18,23,20,16,22];
		// 14= 武器  13= 头部  12= 胸部  11= 腿部  19= 脚部  15= 项链  22= 护符  17= 手腕  21= 戒指  18= 腰带  23= 时装  20= 坐骑 16= 翅膀
//		public static var ItemPos:Array = [14,13,12,11,19,15,22,17,21,18,23,20];
		/** 选择的属性面板代号 */
		public static var selectedPageIndex:uint=1;
		/** 请求上次其他人物信息的时间 */
		public static var lastRequestOtherTime:Number = 0;
		
		public static function getItemByType(type:uint):Object
		{
			for(var i:int=0; i<ItemList.length; i++)
			{
				if(ItemList[i] != null && ItemList[i] != undefined && ItemList[i].type == type)
				{
					return ItemList[i];
				}
			}
			return null;
		}
		
		public static function getRoleItemById(id:int):Object
		{
			for(var i:int=0; i<ItemList.length; i++)
			{
				if(ItemList[i] != null && ItemList[i] != undefined && ItemList[i].id == id)
				{
					return ItemList[i];
				}
			}
			return null;
		}
		
		public static function getDoubleTimeStr(time:uint):String
		{
			if (time<=0)
			{
				return "0";
			}
			var hourStr:String = ( int(time/3600) ).toString();
			var miniteStr:String = ( int( (time%3600)/60 ) ).toString();
			if ( hourStr=="0" )
			{
				return miniteStr + GameCommonData.wordDic[ "mod_rp_dat_rpd_gdt_1" ];   //"分"
			}
			else
			{
				return hourStr + GameCommonData.wordDic[ "mod_rp_dat_rpd_gdt_2" ] + miniteStr + GameCommonData.wordDic[ "mod_rp_dat_rpd_gdt_1" ];		//"时"   "分"	
			}
		}
		
		public static function getVipTime(time:int):String
		{
			if (time<=0)
			{
				return GameCommonData.wordDic[ "mod_rank_med_rm_hn_3" ];    //"无"
			}
			var dayStr:String = ( int(time/86400) ).toString();
			var hourStr:String = ( int((time%86400)/3600)).toString();
			var miniteStr:String = ( int( (time%3600)/60 ) ).toString();
			if ( dayStr == "0" )
			{
				if ( hourStr == "0" )
				{
					return miniteStr+GameCommonData.wordDic[ "mod_rp_dat_rpd_gdt_1" ];    //"分"
				}
				else
				{
					return hourStr+GameCommonData.wordDic[ "mod_rp_dat_rpd_gdt_2" ]+miniteStr+GameCommonData.wordDic[ "mod_rp_dat_rpd_gdt_1" ];  //"时"  "分"
				}
			}
			else
			{
				return dayStr+GameCommonData.wordDic[ "mod_rp_dat_rpd_gvt" ]+hourStr+GameCommonData.wordDic[ "mod_rp_dat_rpd_gdt_2" ]+miniteStr+GameCommonData.wordDic[ "mod_rp_dat_rpd_gdt_1" ];	  //"天"   "时"   "分"
			}
		}
		
	}
}