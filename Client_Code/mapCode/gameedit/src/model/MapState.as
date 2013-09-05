package model{
	
	/**
	 * 地图状态 
	 * @author Administrator
	 */	
	public class MapState {
		
		/**
		 * 状态：无
		 */		
		public static const NONE:MapState=new MapState("None");
		
		/**
		 * 状态：路点设置 
		 */		
		public static const ROADSET:MapState=new MapState("roadSet");
		
		/**
		 * 状态：Npc设置 
		 */		
		public static const NPCSET:MapState=new MapState("npcSet");
		
		/**
		 * 状态：导出
		 */		
		public static const OUTPUT:MapState=new MapState("output");
		
		private var _vle:String;
		public function MapState(vle:String):void{
			_vle=vle;
		}
	}
}
