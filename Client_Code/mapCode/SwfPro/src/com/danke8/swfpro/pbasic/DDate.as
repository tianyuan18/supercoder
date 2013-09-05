package com.danke8.swfpro.pbasic
{
	import flash.utils.ByteArray;

	/**
	 * 蛋壳数据 
	 */	
	public class DDate
	{
		public var index:uint=0;
		public var data:ByteArray;
		public var str:String="";
		
		public function DDate(data:ByteArray):void{
			this.data=data;
		}
		
		/**
		 * 读取32位以下数据
		 * 从临时数据读取相应长度的数据，当临时数据不够时从data加载一个byte，转化为uint
		 */		
		public function readUInt(count:uint):uint{
			while(index>str.length-count){
				var tmp:uint=data.readUnsignedByte();
				str+=DInt.toBinary(tmp);
			}
			var ret:uint=parseInt(str.substr(index,count),2);
			index+=count;
			return ret;
		}
		
		/**
		 * 读取bool型数据 
		 */		
		public function readBoolean():Boolean{
			if(index>str.length-1){
				str+=DInt.toBinary(data.readUnsignedByte());
			}
			return str.substr(index++,1)=="1";
		}
		
		/**
		 * 丢弃 tmpStr剩余数据
		 */		
		public function drop():void{
			str="";
			index=0;
		}
		
		/**
		 * 写入32位以下数据
		 * 将数据写入到临时数据，如果临时数据超过一个byte，写入到data
		 */		
		public function writeUInt(value:uint,count:uint):void{
			str+=DInt.toBinary(value,count);
			while(index<=str.length-8){
				var tmp:int=parseInt(str.substr(index,8),2);
				data.writeByte(tmp);
				index+=8;
			}
		}
		
		/**
		 * 写入bool型数据 
		 */		
		public function writeBoolean(value:Boolean):void{
			str+=value?"1":"0";
			if(index<=str.length-8){
				data.writeByte(parseInt(str.substr(index,8),2));
				index+=8;
			}
		}
		
		/**
		 * 完成写入
		 */		
		public function flush():void{
			if(index<str.length){
				var tmpStr:String=str.substr(index,str.length-index);
				while(tmpStr.length<8){
					tmpStr+="0";
				}
				data.writeByte(parseInt(tmpStr,2));
			}
			index=0;
			str="";
		}
		
	}
}