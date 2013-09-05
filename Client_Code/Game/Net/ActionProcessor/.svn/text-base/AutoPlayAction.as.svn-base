package Net.ActionProcessor
{
	import GameUI.Modules.AutoPlay.Data.AutoPlayData;
	import GameUI.Modules.AutoPlay.command.AutoPlayEventList;
	import GameUI.UIUtils;
	
	import Net.GameAction;
	
	import flash.utils.ByteArray;

	public class AutoPlayAction extends GameAction
	{
		public function AutoPlayAction(isUsePureMVC:Boolean=true)
		{
			super(isUsePureMVC);
		}
		
		public override function Processor(bytes:ByteArray):void
		{
			bytes.position = 4;
			var b:uint = bytes.readUnsignedInt();					//action
			var a:uint = bytes.readUnsignedInt();					//userid 
			
			AutoPlayData.aSaveTick = UIUtils.IntegerBitwiseAnd( bytes.readUnsignedInt() ).slice( 0,23 );

			for ( var i:uint=0; i<9; i++ )
			{
				AutoPlayData.aSaveNum[i] = bytes.readUnsignedShort();
			}
			
			AutoPlayData.aSkillTick = UIUtils.IntegerBitwiseAnd( bytes.readUnsignedInt() ).slice( 0,10 );
			var skill:Object = AutoPlayData.aSkillTick;
			bytes.readUnsignedShort();
			
			for ( var j:uint=0; j<11; j++ )
			{
				AutoPlayData.aSaveType[j] = bytes.readUnsignedInt();
			}
			
			sendNotification( AutoPlayEventList.AUTO_PLAY_RECEIVE_SERVER );
		}
		
	}
}