package Net.ActionSend
{
	import GameUI.Modules.AutoPlay.Data.AutoPlayData;
	import GameUI.UIUtils;
	
	import Net.Protocol;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class AutoPlaySend
	{
		public static function send():void
		{
			var sendBytes:ByteArray = new ByteArray();
			sendBytes.endian = Endian.LITTLE_ENDIAN;
			sendBytes.writeShort(84);
			sendBytes.writeShort( Protocol.MSG_AUTO_PLAY );
			sendBytes.writeUnsignedInt( 0 );
			sendBytes.writeUnsignedInt( GameCommonData.Player.Role.Id );
//			trace ( GameCommonData.Player.Role.Id );
			
			sendBytes.writeUnsignedInt( UIUtils.ArrayBitwiseAndToInteger( AutoPlayData.aSaveTick ) );				//开关
			
			for ( var i:uint=0; i<9; i++ )
			{
				sendBytes.writeShort( AutoPlayData.aSaveNum[i] );
			}
			
			sendBytes.writeUnsignedInt( UIUtils.ArrayBitwiseAndToInteger( AutoPlayData.aSkillTick ) );				//技能开关
			
			sendBytes.writeShort(0);
			
			/**
			 * 原来的物品栏，修改为自动释放技能
			 */
			for ( var j:uint=0; j<11; j++ )
			{
				sendBytes.writeUnsignedInt( AutoPlayData.aSaveType[j] );
			}
			
			
			
			GameCommonData.GameNets.Send(sendBytes);
		}

	}
}