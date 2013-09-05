package Net
{
	import Data.GameLoaderData;
	
	import Net.ActionProcessor.ChatInl;
	import Net.ActionProcessor.RegisterInl;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/** 游戏服务器Socket */	
	public class GameNetLoader
	{
		private var socket:BaseSocketLoader;
		private var intervalId:uint;
		
		public function GameNetLoader(ip:String = "", port:uint = 0)
		{
			this.socket = new BaseSocketLoader(ip,port);
			this.socket.addEventListener(BaseSocketEvent.CONNECT,onConnect);
			this.socket.addEventListener(BaseSocketEvent.RECEIVED,onReceived);
			this.socket.addEventListener(BaseSocketEvent.DECODE_ERROR, deCodeError);
			this.socket.addEventListener(BaseSocketEvent.CLOSE,onClose); 
			this.socket.addEventListener(BaseSocketEvent.SECURITY_ERROR,deCodeError);
			this.socket.Connect();  
			GameLoaderData.outsideDataObj.gameSocket = this.socket._socket;
		}
		
		/** 发送数据并序列化给Socket */
		public function Send(datas:ByteArray):void
		{
			if(socket)
			{ 
				this.socket.Send(datas);
			} 
		}
		
		private function onConnect(e:BaseSocketEvent):void
		{
			var obj:Object = new Object();
			var parm:Array = new Array();
			obj.type       = 1052;
			parm.push(GameLoaderData.outsideDataObj.GServerInfo.idAccount);
			parm.push(GameLoaderData.outsideDataObj.GServerInfo.dwData);
			parm.push("1");
			obj.data = parm;
			GameServerConnect(obj);
		}
		
		private function onReceived(e:BaseSocketEvent):void
		{	 
			if ( e.Data.data!=null )
			{
				var protocol:uint   = e.Data.protocol;
				var data:ByteArray  = e.Data.data;
				if ( e.Data.protocol == 1052 )
				{
					GameLoaderData.gameServerInfo.Processor( data );		
				}
				else if ( e.Data.protocol == 1004 )
				{
					ChatInl.Processor( data );
				}
				else if ( e.Data.protocol == 1001 )
				{
					RegisterInl.Processor( data );
				}
			}
		}
		
		private function deCodeError(e:BaseSocketEvent):void
		{
//			Logger.Info(this,"deCodeError","安全错");
		}
		
		private function onClose(e:BaseSocketEvent):void
		{
			this.socket    				       = null;
		}
		
		public function endGameNet():void
		{
			this.socket.Close();
			this.socket    				       = null;
		}
		
		public function removeListener():void
		{
			socket.removeLis();
			socket.removeEventListener(BaseSocketEvent.CONNECT,onConnect);
			socket.removeEventListener(BaseSocketEvent.RECEIVED,onReceived);
			socket.removeEventListener(BaseSocketEvent.DECODE_ERROR, deCodeError);
			socket.removeEventListener(BaseSocketEvent.CLOSE,onClose); 
			socket.removeEventListener(BaseSocketEvent.SECURITY_ERROR,deCodeError);
		}
		
		private function GameServerConnect(obj:Object):void 
		{
			var sendBytes:ByteArray = new ByteArray();
			sendBytes.endian = Endian.LITTLE_ENDIAN;
			sendBytes.writeShort(336);														//原来为76  332
			sendBytes.writeShort(obj.type);

			sendBytes.writeUnsignedInt(obj.data.shift());
			sendBytes.writeUnsignedInt(obj.data.shift());

			sendBytes.writeUnsignedInt(0);
			
			var tempBytes:ByteArray = new ByteArray();
			tempBytes.writeMultiByte(obj.data.shift(),GameLoaderData.wordCode);
			sendBytes.writeBytes(tempBytes,0,tempBytes.length);

			while (sendBytes.position!=336) {											//原来为76   332
				sendBytes.writeByte(0);
			}
			Send(sendBytes);	
		}
	}
}