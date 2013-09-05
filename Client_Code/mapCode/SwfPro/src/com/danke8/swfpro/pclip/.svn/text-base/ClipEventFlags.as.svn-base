package com.danke8.swfpro.pclip
{
	import com.danke8.swfpro.pbasic.DInt;
	
	import flash.utils.ByteArray;

	public class ClipEventFlags{
		
		public function ClipEventFlags(){
		}
		public var clipEventKeyUp:Boolean;
		
		public var clipEventKeyDown:Boolean;
		
		public var clipEventMouseUp:Boolean;
		
		public var clipEventMouseDown:Boolean;
		
		public var clipEventMouseMove:Boolean;
		
		public var clipEventUnload:Boolean;
		
		public var clipEventEnterFrame:Boolean;
		
		public var clipEventLoad:Boolean;
		
		public var clipEventDragOver:Boolean;
		
		public var clipEventRollOut:Boolean;
		
		public var clipEventRollOver:Boolean;
		
		public var clipEventReleaseOutside:Boolean;
		
		public var clipEventRelease:Boolean;
		
		public var clipEventPress:Boolean;
		
		public var clipEventInitialize:Boolean;
		
		public var clipEventData:Boolean;
		
		
		public var reserved1:uint;
		
		public var clipEventConstruct:Boolean;
		
		public var clipEventKeyPress:Boolean;
		
		public var clipEventDragOut:Boolean;
		
		public var reserved2:uint;
		
		public static function readClipEventFlags(data:ByteArray):ClipEventFlags{
			var cef:ClipEventFlags=new ClipEventFlags();
			var tmpStr:String=DInt.toBinary(data.readUnsignedByte());
			cef.clipEventKeyUp=tmpStr.substr(0,1)=="1";
			cef.clipEventKeyDown=tmpStr.substr(1,1)=="1";
			cef.clipEventMouseUp=tmpStr.substr(2,1)=="1";
			cef.clipEventMouseDown=tmpStr.substr(3,1)=="1";
			cef.clipEventMouseMove=tmpStr.substr(4,1)=="1";
			cef.clipEventUnload=tmpStr.substr(5,1)=="1";
			cef.clipEventEnterFrame=tmpStr.substr(6,1)=="1";
			cef.clipEventLoad=tmpStr.substr(7,1)=="1";
			
			tmpStr=DInt.toBinary(data.readUnsignedByte());
			cef.clipEventDragOver=tmpStr.substr(0,1)=="1";
			cef.clipEventRollOut=tmpStr.substr(0,1)=="1";
			cef.clipEventRollOver=tmpStr.substr(0,1)=="1";
			cef.clipEventReleaseOutside=tmpStr.substr(0,1)=="1";
			cef.clipEventRelease=tmpStr.substr(0,1)=="1";
			cef.clipEventPress=tmpStr.substr(0,1)=="1";
			cef.clipEventInitialize=tmpStr.substr(0,1)=="1";
			cef.clipEventData=tmpStr.substr(0,1)=="1";

			tmpStr=DInt.toBinary(data.readUnsignedByte());
			cef.reserved1=parseInt(tmpStr.substr(0,5),2);
			cef.clipEventConstruct=tmpStr.substr(5,1)=="1";
			cef.clipEventKeyPress=tmpStr.substr(6,1)=="1";
			cef.clipEventDragOut=tmpStr.substr(7,1)=="1";

			cef.reserved2=data.readUnsignedByte();
			return cef;
		} 
		
		public static function writeClipEventFlags(data:ByteArray,cef:ClipEventFlags):void{
			var tmpStr:String="";
			
			tmpStr=cef.clipEventKeyUp?"1":"0";
			tmpStr+=cef.clipEventKeyDown?"1":"0";
			tmpStr+=cef.clipEventMouseUp?"1":"0";
			tmpStr+=cef.clipEventMouseDown?"1":"0";
			tmpStr+=cef.clipEventMouseMove?"1":"0";
			tmpStr+=cef.clipEventUnload?"1":"0";
			tmpStr+=cef.clipEventEnterFrame?"1":"0";
			tmpStr+=cef.clipEventLoad?"1":"0";
			data.writeByte(parseInt(tmpStr,2));
			
			
			tmpStr=cef.clipEventDragOver?"1":"0";
			tmpStr+=cef.clipEventRollOut?"1":"0";
			tmpStr+=cef.clipEventRollOver?"1":"0";
			tmpStr+=cef.clipEventReleaseOutside?"1":"0";
			tmpStr+=cef.clipEventRelease?"1":"0";
			tmpStr+=cef.clipEventPress?"1":"0";
			tmpStr+=cef.clipEventInitialize?"1":"0";
			tmpStr+=cef.clipEventData?"1":"0";
			data.writeByte(parseInt(tmpStr,2));
			
			tmpStr=DInt.toBinary(cef.reserved1,5);
			tmpStr+=cef.clipEventConstruct?"1":"0";
			tmpStr+=cef.clipEventKeyPress?"1":"0";
			tmpStr+=cef.clipEventDragOut?"1":"0";
			data.writeByte(parseInt(tmpStr,2));
			
			data.writeByte(cef.reserved2);
		}
		
	}
}