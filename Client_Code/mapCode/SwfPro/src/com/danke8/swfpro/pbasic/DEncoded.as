package com.danke8.swfpro.pbasic
{
	import flash.utils.ByteArray;

	public class DEncoded
	{
		/**
		 * 读取32位以下数据
		 */		
		public static function readUInt(data:ByteArray):uint{
			var tmpStr:String="";
			var str:String="";
			do{
				tmpStr=DInt.toBinary(data.readUnsignedByte());
				str+=tmpStr.substr(1,7);
			}while(tmpStr.substr(0,1)=="1")
			return parseInt(str,2);
		}
		
		public static function readString(data:ByteArray):String{
			var ret:String="";
			var tmp:uint=0;
			while((tmp=data.readUnsignedByte())!=0){
				ret=ret+"%"+DString.addZeroBefore(tmp.toString(16),2);
			}
			ret=decodeURI(ret);
			return ret;
		}
		
		private static var tmpObj:Array=[{num:0x30,arr:["0","1","2","3","4","5","6","7","8","9"]},
			{num:0x61,arr:["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]},
			{num:0x41,arr:["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]}
		]
		/**
		 * 将uint值写入字节数组 
		 * @param data
		 * @param value
		 */		
		public static function writeUInt(data:ByteArray,value:uint):void{
			var tmp:String="0"+DInt.toBinary(value,7);
			data.writeByte(parseInt(tmp,2));
		}
		
		public static function writeString(data:ByteArray,value:String):void{
			
			for(var i:int=0;i<tmpObj.length;i++){
				for(var j:int=0;j<tmpObj[i].arr.length;j++){
					value=value.replace(new RegExp("["+tmpObj[i].arr[j]+"]","g"),"."+tmpObj[i].arr[j])
				}
			}
			var str:String= encodeURI(value);
			for(i=0;i<tmpObj.length;i++){
				for(j=0;j<tmpObj[i].arr.length;j++){
					str=str.replace(new RegExp("[.]["+tmpObj[i].arr[j]+"]","g"),"%"+DString.addZeroBefore((tmpObj[i].num+j).toString(16),2));
				}
			}
			
			str=str.replace(/[%]/g,"")+"00";
			var index:int=0;
			while(index<=str.length-2){
				data.writeByte(parseInt(str.substr(index,2),16));
				index+=2;
			}
		}
	}
}