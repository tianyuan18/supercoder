package common
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import model.STEvent;
	
	public class STDispatcher {
		
		private static var _dis:EventDispatcher=new EventDispatcher();
		
		public static function get dis():EventDispatcher{
			return _dis;
		}
		
		public static function sendEvent(stEvent:String,data:Object):void{
			dis.dispatchEvent(new STEvent(stEvent,data));
		}
	}
}