package model
{
	/**
	 * 游戏功能类型
	 */	
	public class GameFunctionType extends Object
	{
		private var _str:String="";
		public function GameFunctionType(str:String)
		{
			_str=str;
		}
		
		/**
		 * 功能：地图传送 
		 */		
		public static const MAP_TRANSMISSION:GameFunctionType=new GameFunctionType("MapTransmission");
			
		/**
		 * 功能：Npc讲话 
		 */		
		public static const NPC_SPEEK:GameFunctionType=new GameFunctionType("NPCSpeek");
	}
}