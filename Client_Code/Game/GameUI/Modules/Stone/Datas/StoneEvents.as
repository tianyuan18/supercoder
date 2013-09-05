package GameUI.Modules.Stone.Datas
{
	public class StoneEvents
	{
		public function StoneEvents()
		{
		}
		/** 打开宝石界面 */
		public static const OPEN_STONE_VIEW:String = "OPEN_STONE_VIEW";
		
		/** 初始化宝石界面 加载素材*/
		public static const INIT_STONE_UILIB:String = "INIT_STONE_UILIB";
		
		/** 关闭宝石界面 */
		public static const CLOSE_STONE_UI:String = "CLOSE_STONE_UI";
		
		/** 初始化宝石子界面 宝石镶嵌和合成*/
		public static const INIT_STONE_UI:String = "INIT_STONE_UI";
		
		/** 打开宝石镶嵌*/
		public static const SHOW_STONE_MOSAIC_UI:String = "SHOW_STONE_MOSAIC_UI";
		
		/** 关闭宝石镶嵌*/
		public static const CLOSE_STONE_MOSAIC_UI:String = "CLOSE_STONE_MOSAIC_UI";
		
		/** 打开宝石合成*/
		public static const SHOW_STONE_COMPOSE_UI:String = "SHOW_STONE_COMPOSE_UI";
		
		/** 关闭宝石合成*/
		public static const CLOSE_STONE_COMPOSE_UI:String = "CLOSE_STONE_COMPOSE_UI";
		
		/** 选中背包宝石事件*/
		public static const SELECT_ITEM_ONMOUSEDOWN:String = "SELECT_ITEM_ONMOUSEDOWN";
		
		/** 插入宝石事件*/
		public static const SELECT_MATERIAL_ONMOUSEDOWN:String = "SELECT_MATERIAL_ONMOUSEDOWN";
		
		/** 放入宝石事件*/
		public static const SELECT_STONE_ONMOUSEDOWN:String = "SELECT_STONE_ONMOUSEDOWN";
		
		/** 刷新装备信息*/
		public static const UPDATE_STONE_MOSAIC_UI:String = "UPDATE_STONE_MOSAIC_UI";
		
		/** 刷新装备嵌入宝石信息*/
		public static const UPDATE_EQUIP_STONE_UI:String = "UPDATE_EQUIP_STONE_UI";
	}
}