package GameUI.Modules.Screen.Data
{
	public class ScreenData
	{
		
		public static const INITEVENT:String = "open_screen_initView";
		/**
		 * 打开屏蔽设置面板 
		 */		
		public static const OPEN_SCREEN:String = "open_screen";
		
		/**
		 * 是否屏蔽玩家 
		 */		
		public static var screen_player:Boolean = false;
		/**
		 * 是否屏蔽宠物 
		 */		
		public static var screen_pet:Boolean = false;
		
		/**
		 * 是否屏蔽怪物 
		 */		
		public static var screen_enemy:Boolean = false;
		/**
		 * 是否屏蔽技能特效 
		 */		
		public static var  screen_skillEf:Boolean = false;
		
		/**
		 * 是否屏蔽帮派成员 
		 */		
		public static var screen_gang:Boolean = false;
		/**
		 * 是否屏蔽同服玩家
		 */		
		public static var screen_severPlayer:Boolean = false;
		
		
		public static var view_Open:Boolean = false;
		public function ScreenData()
		{
			
		}
	}
}