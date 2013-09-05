package model
{
	import flash.events.Event;

	//全局事件
	public class STEvent extends Event
	{
		public static const PROJECT_CREATED:String="ProjectCreated";//项目新建完成
		public static const PROJECT_Open:String="ProjectOpen";		//项目打开
		public static const MAP_ITEMTYPE_CREATED:String="MapItemTypeCreated"//地图元素类型创建完成
		public static const MAP_CREATED:String="MapCreated";		//地图新建完成
		public static const MAP_Open:String="MapOpen";				//地图打开
		public static const MAP_ITEMTYPE_CREATE_START:String="MapItemTypeCreateStart";//开始创建地图元素类型
	
		private var _name:String;
		private var _data:Object;
		
		/**
		 * @param name 事件名
		 * @param data 传递数据
		 */		
		public function STEvent(name:String ,data:Object)
		{
			super(name,false);
			_name=name;
			_data=data;
		}
	
		public function get Data():Object
		{
			return _data;
		}

		public function get Name():String
		{
			return _name;
		}

	}
}