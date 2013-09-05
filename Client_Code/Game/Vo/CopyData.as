package Vo
{
	public class CopyData
	{
		private var map:String;
		private var front:String;
		private var behind:String;
		private var count:int;
		private var taskId:int;
		public function CopyData(map:String="",front:String="",behind:String="",count:int=0,taskId:int=0)
		{
			this.map = map;
			this.front = front;
			this.behind = behind;
			this.count = count;
			this.taskId = taskId;
		}
		
		public function  set setMap(map:String):void{
			this.map = map;
		}
		
		public function get getMap():String{
			return this.map;
		}
		
		public function set setFront(front:String):void{
			this.front = front;
		}
		
		public function get getFront():String{
			return this.front;
		}
		
		public function set setBehind(behind:String):void{
			this.behind = behind;
		}
		
		public function get getBehind():String{
			return this.behind;
		}
		
		public function set setCount(count:int):void{
			this.count = count;
		}
		
		public function get getCount():int{
			return this.count;
		}
		
		public function set setTaskId(taskId:int):void{
			this.taskId = taskId;
		}
		
		public function get getTaskId():int {
			return this.taskId;
		}
		
		
	}
}