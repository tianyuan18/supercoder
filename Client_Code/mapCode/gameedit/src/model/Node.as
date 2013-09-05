package model
{
	import flash.geom.Point;

	/**
	 * Represents a specific node evaluated as part of a pathfinding algorithm.
	 */
	public class Node
	{
		public var point:Point;
		public var dPoint:Point;
		
		public var walkNum:String;
		
		
		public function Node(x:int, y:int)
		{
			dPoint=new Point(x,y);
		}
	}
}