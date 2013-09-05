package GameUI.Modules.Rank.Data
{
	public class RankConstData
	{
	public static var totalPage  :int = 10;                  	//总页数 ;
	public static var currentPage:int;							//当前页数;
		public static var total_h:int;                    	 	//总行数 ;
		public function RankConstData()
		{
		}
		
		public static const LAB_POS:Array = [
			{titile_1:'角色',titile_2:'性别',titile_3:'职业',titile_4:'帮派',titile_5:'战斗力',mcName:"listContentSix",showName:'personView'},
			{titile_1:'角色',titile_2:'性别',titile_3:'职业',titile_4:'帮派',titile_5:'等级',mcName:"listContentSix",showName:'personView'},
			{titile_1:'角色',titile_2:'性别',titile_3:'职业',titile_4:'帮派',titile_5:'非绑定银两',mcName:"listContentSix",showName:'personView'},
			{titile_1:'角色',titile_2:'性别',titile_3:'职业',titile_4:'帮派',titile_5:'武魂战斗力',mcName:"listContentSix",showName:'personView'},
			{titile_1:'角色',titile_2:'性别',titile_3:'职业',titile_4:'帮派',titile_5:'声望值',mcName:"listContentSix",showName:'personView'},
			{titile_1:'伙伴',titile_2:'主人',titile_3:'伙伴战斗力',mcName:"listContentFour",showName:'petView'},
			{titile_1:'伙伴',titile_2:'主人',titile_3:'伙伴等级',mcName:"listContentFour",showName:'petView'},
			{titile_1:'坐骑',titile_2:'主人',titile_3:'坐骑战斗力',mcName:"listContentFour",showName:'mountView'},
			{titile_1:'装备',titile_2:'角色',titile_3:'性别',titile_4:'职业',titile_5:'战斗力',mcName:"listContentSix"},
			{titile_1:'装备',titile_2:'角色',titile_3:'性别',titile_4:'职业',titile_5:'战斗力',mcName:"listContentSix"},
			{titile_1:'装备',titile_2:'角色',titile_3:'性别',titile_4:'职业',titile_5:'战斗力',mcName:"listContentSix"},
			{titile_1:'角色',titile_2:'性别',titile_3:'职业',titile_4:'帮派',titile_5:'胜场数',mcName:"listContentSix"},
			{titile_1:'角色',titile_2:'性别',titile_3:'职业',titile_4:'帮派',titile_5:'胜场总数',mcName:"listContentSix"}
										];
		public static var rankAllList:Array = new Array(13);			/** 缓存数组 */
		public static function rankAllListInit():void
		{
			for(var i:int = 0;i < 13;i++)
			{
				var obj:Object = new Object();
				obj.i = null;
				rankAllList[i] = obj;
			}
		} 

	}
}