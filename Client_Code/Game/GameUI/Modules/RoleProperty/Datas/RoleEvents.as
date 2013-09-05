package GameUI.Modules.RoleProperty.Datas
{
	public class RoleEvents
	{
		public function RoleEvents()
		{
		}
		/** 初始化人物属性界面  */
		public static const INITROLEVIEW:String = "InitRoleView";
		
		/** 收到装备  */
		public static const GETOUTFIT:String = "GetOutFit";
		
		/** 非拖动收到装备  */
		public static const GETOUTFITBYCLICK:String = "GetOutFitByClick";
		
		/** 更新装备  */
		public static const UPDATEOUTFIT:String = "UpdateOutfit";
		
		/** 打开背包的同时请求装备  */
		public static const GETFITOUTBYBAG:String = "GetFiooutbyBag";
		
		/** 显示属性栏  */
		public static const SHOWPROPELEMENT:String = "ShowPropElement";
		
		/** 更新属性  */
		public static const UPDATEADDATT:String = "updateAddAtt";
	
		/** 回收处理  */
		public static const MEDIATORGC:String = "MediatorGc";
		
		/** 收到人物火，冰，玄，毒属性*/
		public static const ATTENDPROPELEMENT:String = "ATTENDPROPELEMENT"; 
		
		/** 玩家职业发生改变*/
		public static const PLAYER_CHANGE_JOB:String = "player_change_job"
		
		/** 重置人物属性面板的位置 */
		public static const HEROPROP_PANEL_INIT_POS:String = "heroprop_panel_init_pos";
		
		/** 人物属性禁用面板拖动 */
		public static const HEROPROP_PANEL_STOP_DRAG:String = "heroprop_panel_stop_drag";
		
		/** 人物属性界面初始化 */
		public static const INIT_ROLE_UI:String = "init_role_ui";
		
		/** 更新人物其他信息  */
		public static const UPDATE_OTHER_INFO:String = "UPDATE_OTHER_INFO";
		/** 是否显示时装 */
		public static const ISSHOWDRESS:String = "ISSHOWDRESS";
		
		public static const CHANGE_MODEL:String = "change_model";
		
		/** 隐藏人物装备界面 */
		public static const CLOSEEQUIPPANEL:String = "CLOSEEQUIPPANEL";
		/** 显示人物装备界面 */
		public static const SHOWEQUIPPANEL:String = "SHOWEQUIPPANEL";
		/** 隐藏称号界面 */
		public static const CLOSDESIGNATIONPANEL:String = "CLOSDESIGNATIONPANEL";
		
		/** 显示称号界面 */
		public static const OPENDESIGNATIONPANEL:String = "OPENDESIGNATIONPANEL";
		
		/** 卸载文字称号 */
		public static const UNLOADTITLE:String = "UNLOADTITLE";
		
		/** 更新佩戴称号界面 */
		public static const UPDATE_MY_TITLE:String = "UPDATE_MY_TITLE";
	}
}