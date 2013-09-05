package OopsEngine.AI.PathFinder
{
	/**
	 * 地图模型接口
	 * 
	 * @author eidiot (http://eidiot.net)
	 * @version	1.0
	 * @date	070416
	 */	
	public interface IMapTileModel
	{
		/**
		 * 是否为障碍
		 * @param startX	始点X坐标
		 * @param startY	始点Y坐标
		 * @param endX		终点X坐标
		 * @param endY		终点Y坐标
		 * @return			0为障碍 1为通路
		 */
		function IsBlock(startX : int, startY : int, endX : int, endY : int) : int;
		/** 
		 * 判断a点到b点 2点之间的线上是否有障碍物
		 * @param startX		始点X坐标
		 * @param startY		始点Y坐标
		 * @param endX			终点X坐标
		 * @param endY			终点Y坐标
		 * @param checkDistance 检查点距离
		 * @return true为通过 false为不可通过
		 * */
		function IsPassAToB(startX:int,startY:int,endX:int,endY:int,checkDistance:Number):Boolean;
	}
}