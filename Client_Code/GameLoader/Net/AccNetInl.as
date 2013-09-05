package Net
{
	import Data.GameLoaderData;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/** 登录服务器Socket */	
	public class AccNetInl
	{
		private var socket:BaseSocketLoader;
		public function AccNetInl(ip:String = "", port:uint = 0)
		{
			this.socket = new BaseSocketLoader(ip,port);
			this.socket.addEventListener(BaseSocketEvent.CONNECT,onConnect);
			this.socket.addEventListener(BaseSocketEvent.RECEIVED,onReceived);
			this.socket.addEventListener(BaseSocketEvent.CLOSE,onClose);
			this.socket.Connect();
		}
		
		/** 发送数据并序列化给Socket */
		public function Send(datas:ByteArray):void 
		{
			this.socket.Send(datas);	
		}
		
		/** 关闭Socket  */
		public function Close():void 
		{
			removeLis();
			this.socket.Close();	
			this.socket = null;
		}
		
		private function onConnect(e:BaseSocketEvent):void
		{
			var obj:Object = new Object();
			var parm:Array = new Array();
			parm.push( GameLoaderData.outsideDataObj.userName );
			parm.push( GameLoaderData.outsideDataObj.password );
			parm.push( GameLoaderData.outsideDataObj.GameSocketName );	
			parm.push("111111111111");
			obj.type = 1051;
			obj.data = parm;
			AccLoginCreate(obj);
		}
		
		private function onReceived(e:BaseSocketEvent):void
		{
			if(e.Data.data!=null && e.Data.protocol == 1052 )
			{
				var protocol:String = e.Data.protocol;
				var data:ByteArray  = e.Data.data;
				GameLoaderData.gameServerInfo.Processor(data);
			}
		}
		
		private function onClose(e:BaseSocketEvent):void
		{
			removeLis();
			this.socket.Close();
			this.socket    				       = null;
		}
		
		private function removeLis():void 
		{
			this.socket.removeEventListener(BaseSocketEvent.CONNECT,onConnect);
			this.socket.removeEventListener(BaseSocketEvent.RECEIVED,onReceived);
			this.socket.removeEventListener(BaseSocketEvent.CLOSE,onClose);
		}
		
		private function AccLoginCreate(obj:Object):void 
		{
			var sendBytes:ByteArray = new ByteArray();
			sendBytes.endian = Endian.LITTLE_ENDIAN;
			sendBytes.writeShort(76);
			sendBytes.writeShort(obj.type);

			var tempBytes:ByteArray = new ByteArray();
			tempBytes.writeMultiByte(obj.data.shift(),GameLoaderData.wordCode);
			sendBytes.writeBytes(tempBytes,0,tempBytes.length);

			while (sendBytes.position!=28) {
				sendBytes.writeByte(0);
			}

			tempBytes=new ByteArray();
			tempBytes.writeMultiByte(obj.data.shift(),GameLoaderData.wordCode);
			sendBytes.writeBytes(tempBytes,0,tempBytes.length);


			while (sendBytes.position!=44) {
				sendBytes.writeByte(0);
			}

			tempBytes=new ByteArray  ;
			tempBytes.writeMultiByte(obj.data.shift(),GameLoaderData.wordCode);
			sendBytes.writeBytes(tempBytes,0,tempBytes.length);

			while (sendBytes.position!=60) {
				sendBytes.writeByte(0);
			}

			tempBytes=new ByteArray  ;
			tempBytes.writeMultiByte(obj.data.shift(),GameLoaderData.wordCode);
			sendBytes.writeBytes(tempBytes,0,tempBytes.length);

			while (sendBytes.position!=76) {
				sendBytes.writeByte(0);
			}
			this.Send(sendBytes);
		}
	
	}
}