package model
{
	/**
	 * 路点类型 
	 */	
	public class CellType
	{
		public static const ROAD:String="a";
		public static const Barrier:String="b";
		public static const Mask:String="c";
		public static const Trap:String="d";
		
		public static const ROAD_COLOR:uint=0x00ff00;
		public static const BARRIER_COLOR:uint=0xff0000;
		public static const MASK_COLOR:uint=0xffff00;
		public static const TRAP_COLOR:uint=0x0000ff;
	}
}