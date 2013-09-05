package
{
	import Net.AccNetInl;
	import Net.GameNetLoader;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.Socket;
	
	//外部数据对象
	public class OutsideDataObject
	{
		//从网页获取的参数
		public var userName:String;					//账号
		public var password:String;			
		public var serverid:String;						//服务器id
		public var AccSocketIP:String;				
		public var AccSocketPort:uint;				
		public var SourceURL:String;					
		public var cztype:int;								//是否显示充值开关
		public var preventWallowTime:Number;	//防沉迷定时器
		public var showAccount:int;	//防沉迷弹出次数
		public var fcmPower:int;	//平台防沉迷开关 1 开启  0 关闭  111 旧的php平台
		public var fcmConfig:int;	//单个用户防沉迷开关 0 没通过，要弹窗  1 已经通过，不弹
		public var isNew:int = 0;	//0 旧平台  100新平台  
		public var swfver:String;							//版本号
		public var version:String;			 			//版本号全称
		public var IsTransferScene:int;		//孔亮的东西
		
		public var tiao:MovieClip;
		/**
		 * 设置加载主程序的百分比进度条 
		 */		
		public var mainPercent:int = 20;
		
		public var GameSocketName:String = "";					//游戏服务器名字
		public var GameSocketIP:String;
		public var GameSocketPort:uint;
		public var GameSeverNum:int;
		
		public var GameServerArr:Array;
		
		public var AccNets:AccNetInl;
		public var GameNets:GameNetLoader;
		
		public var RoleList:Array;
		public var GServerInfo:Object;
		
		//游戏服务器socket
		public var gameSocket:Socket;
		
		public var Filter_Switch:Boolean; 
		//过滤字典信息
		public var Filter_ad:Array = null;
		public var Filter_chat:Array = null;
		public var Filter_role:Array = null;
		public var Filter_okName:Array = null;
		
		//是否更新版本
		public var isUpdataVersion:int = 0;
		
		public var loginSound:Sound;
		public var loginSoundChannel:SoundChannel;
		public var loginSoundTransform:SoundTransform;
		
		public var isOpenSoundSwitch:Boolean;
		
		//语言种类
		public var language:int;
		//加载notice的方式
		public var loadNoticeWay:int;
		//屏蔽的线路
		public var hideLines:String;
		//过滤后的线路
		public var fiterGameServerArr:Array;
		
		//开箱子策略信息  从网页获取
		public var openTreasureStragety:uint = 1; 
		
		//选中的角色
		public var selectRoleIndex:int;
		
		public function dispose():void
		{
			if ( AccNets )
			{
				AccNets.Close();
				AccNets = null;
			}
			if ( GameNets )
			{
				GameNets.endGameNet();
				GameNets = null;
			}
		}

		// 是否从EXE客户端打开
		public var isExe:Boolean = false;
	}
}