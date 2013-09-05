package Net.ActionProcessor  
{	
	import Data.GameLoaderData;
	
	import flash.utils.ByteArray;
	
	/** 聊天频道 */
	public class ChatInl
	{
		public static function Processor(bytes:ByteArray):void 
		{
			bytes.position  = 4;
			var obj:Object  = new Object();
			obj.nColor      = bytes.readUnsignedInt();	  	 	 //话的颜色
			obj.nAtt 	    = bytes.readUnsignedShort(); 		 //话的频道			
			obj.nSty 	    = bytes.readUnsignedShort(); 	 	 //话的风格
			obj.nTimet 	    = bytes.readUnsignedInt(); 			 //时间
			obj.nGm 	    = bytes.readUnsignedInt();    		 //GM工具所用
			obj.nItem 		= bytes.readUnsignedInt();  		 //话里面带的物品ID
			obj.nItemTypeID = bytes.readUnsignedInt(); 	 		 //话里面带的物品typeID
			obj.talkObj	= [];
			var nDataSeeNum:int = bytes.readByte();
			var nDataSee:int    = 0;	
			for(var i:int = 0;i < nDataSeeNum; i++)  
			{
				nDataSee = bytes.readUnsignedByte();	//发言内容长度  
				obj.talkObj[i] = 0;
				if(nDataSee != 0) 
				{
					obj.talkObj[i] = bytes.readMultiByte(nDataSee ,GameLoaderData.wordCode );
				}		
			}
			if(obj.nAtt == 2100)
			{
			    GameLoader.createRole.createRoleOver(obj);
				return;
			}
		
		}
	}
}