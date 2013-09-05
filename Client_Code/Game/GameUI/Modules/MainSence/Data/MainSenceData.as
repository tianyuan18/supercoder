package GameUI.Modules.MainSence.Data
{
	import flash.utils.Dictionary;

	public class MainSenceData
	{
		public static const MOVEQUICKF:String = "moveQuickf";
		public static const USETEAMBUTTON:String = "useTeamBtn";
		public static const INITMAINITEM:String = "initMainItem";
		public static var taskId:uint = 0;
		public static const mainItemArr:Array = ["btn_Role",//角色 0
											"btn_Bag",//背包 1
											"btn_Skill",//技能 2
											"btn_Partner",//仙宠 3  
											"btn_Tendons",//武魂 4
											"btn_Mount",//坐骑 5
											"btn_Strengthen",//铸造 6
											"btn_Gang",//帮派 7
											"btn_bazaar",//市场 8
											"btn_xianfu",//仙府 9
											"btn_jewel",//宝石 10
											"btn_compose"];//合成 11
		
		public function MainSenceData()
		{
			
		}
		
		public static const openDic:Array = [];		
		public static function initOpenDic():void {
			var item:Object;
			item = {task:10005,index:2};
			openDic.push(item);
			
			item = {task:10017,index:3};
			openDic.push(item);
			
			item = {task:10023,index:4};
			openDic.push(item);
			
			item = {task:10044,index:6};
			openDic.push(item);
			
			item = {task:10048,index:7};
			openDic.push(item);
			
			item = {task:10053,index:5};
			openDic.push(item);
			
			item = {task:10072,index:10};
			openDic.push(item);
			
			item = {task:10077,index:8};
			openDic.push(item);
			
			item = {task:10098,index:11};
			openDic.push(item);
			
			item = {task:10106,index:9};
			openDic.push(item);
		}
		
		
		
		/**
		 * 根据当前任务Id，获取当前位于开始功能列表的下标值
		 * @param id
		 * @return 
		 */		
		public static function getIndexByTask(id:int):int{
			for (var i:int = 0; i < openDic.length; i++) 
			{
				var item:Object = openDic[i];
				if(item.task == id){
					return i;
				}
			}
			return -1;
		}
		
		
		/**
		 * 根据当前任务Id，获取当前位于开始功能列表的下标值
		 * @param id
		 * @return 
		 */		
		public static function getMenuIndexByTask(id:int):int{
			for (var i:int = 0; i < openDic.length; i++) 
			{
				var item:Object = openDic[i];
				if(item.task == id){
					return item.index;
				}
			}
			return -1;
		}
		/**
		 * 根据当前任务Id，获取当前位于开始功能列表的名称
		 * @param id
		 * @return 
		 */		
		public static function getMenuNameByTask(id:int):String{
			var index:int = getMenuIndexByTask(id);
			if(index != -1){
				return mainItemArr[index];
			}
			return "";
		}
		/**
		 * 获取当前所有开通的功能 
		 * @param id
		 * 
		 */		
		public static function getOpenMenuNames(id:int):Array{
			var result:Array = [0,1];
			for (var i:int = 0; i < openDic.length; i++) 
			{
				var item:Object = openDic[i];
				if(item.task <= id){
					result.push(item.index);
				}
			}
			result = result.sort(Array.NUMERIC);
			var returnList:Array = new Array();
			for (var j:int = 0; j < result.length; j++) 
			{
				returnList.push(mainItemArr[result[j]]);
			}
			return returnList;
		}
		/**
		 * 判断当前任务是否存在新功能的开启 
		 * @param id
		 * @return 
		 * 
		 */		
		public static function isNewOpen(id:int):Boolean {
			var flag:Boolean = false;
			for (var i:int = 0; i < openDic.length; i++) 
			{
				var item:Object = openDic[i];
				if(item.task == id){
					return true;
				}
			}
			return false;
		}
	}
}