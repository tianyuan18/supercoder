package Net.ActionProcessor
{
	import Data.GameLoaderData;
	
	import flash.utils.ByteArray;
	
	public class RegisterInl
	{
		public function RegisterInl()
		{
		}
		
		public static function Processor(bytes:ByteArray):void
		{
			bytes.position  = 4;

			var userName:String = bytes.readMultiByte(16,GameLoaderData.wordCode);//姓名
			var userPwd:String = bytes.readMultiByte(16,GameLoaderData.wordCode);
			var unAction:uint = bytes.readUnsignedInt();		// Action
			var ucLook:uint = bytes.readShort();				// 头像
			var ucGender:uint = bytes.readShort();				// 性别
			GameLoader.createRole.addMessage({sex:ucGender , name:userName});
		}

	}
}