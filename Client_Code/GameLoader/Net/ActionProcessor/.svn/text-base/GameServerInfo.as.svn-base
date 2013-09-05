package Net.ActionProcessor
{
	import Data.GameLoaderData;
	
	import Net.AccNet;
	import Net.BaseSocketLoader;
	import Net.GameNetLoader;
	
	import Vo.RoleVo;
	
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/** 连接游戏服务器  */
	public class GameServerInfo
	{
		private var securSocket:BaseSocketLoader;
		private var timeOutId:uint;
		
		private var gameServerArr:Array;
		private var isConnectAcc:Boolean = false;							//是否连接过账号服务器
		private var isReceive1052:Boolean = false;							//是否连接过游戏服务器
		
		public var nextStep:Function;
		public var noRoleHandler:Function;
		
		private var reg:RegExp = /重复/g;						//重复登陆
		private var reConnectId:int;									//重新登录延时
		
		private var repeatTime:uint = 0;
		
		private var reConnectAccId:int;
		
		public function GameServerInfo()
		{
																																																						
		}
		public function Processor(bytes:ByteArray):void 
		{
			bytes.position     = 4;
			var szReg:RegExp = /com/g;
			var idAccount:uint = bytes.readUnsignedInt(); 				// idAccount
			var dwData:uint    = bytes.readUnsignedInt();				// dwData
			var gsIndex:uint = bytes.readUnsignedInt();      			//游戏服务器索引
			var szInfo:String  = bytes.readMultiByte(320,GameLoaderData.wordCode); 		    
			var obj:Object = null;
			trace ( "   szInfo:  "+szInfo );
																		
			//获取游戏服务器信息
			if ( !isConnectAcc ) 																		
			{	
				trace ( "ddddddddddddddddd" );
				if ( reg.test( szInfo ) )
				{
					if ( repeatTime == 0 )
					{
						GameLoaderData.outsideDataObj.AccNets.Close();
						GameLoaderData.outsideDataObj.AccNets = null;
						reConnectAccId = setTimeout( connetAccServe,3000 );
						return;
					}
					else
					{
						GameLoaderData.outsideDataObj.tiao.content_txt.x = 30;
						GameLoaderData.outsideDataObj.tiao.content_txt.text = szInfo.toString();
					}
				}		
				isConnectAcc = true;																		
				gameServerArr = szInfo.split(";");																				
				GameLoaderData.outsideDataObj.GameServerArr = gameServerArr;																										
				var gsIp:String = gameServerArr[gsIndex].split(":")[1];									//游戏服务器ip											
				initGameNetInfo(gsIndex);
																																							
				obj 	      = new Object();
				obj.len	      = 336;															
//				obj.ip 	      = GameConfigData.GameSocketIP;
				obj.dwData    = dwData;
				obj.idAccount = idAccount;
				GameLoaderData.outsideDataObj.GServerInfo = obj;
//				CreateRoleConstData.playerobj.id = obj.idAccount;	                //将游戏ID保存在创建人物的数据里
				
				if(!gsIp)
				{
					GameLoaderData.outsideDataObj.tiao.content_txt.x = 120;
					GameLoaderData.outsideDataObj.tiao.content_txt.text = szInfo.toString();
					return;
				}
				var checkArr:Array = gsIp.split( "." );
				if ( checkArr[ checkArr.length-1 ] == "com" || gsIp.split(".").length == 4 || szReg.test(gsIp) || checkArr[ checkArr.length-1 ] == "cn" || checkArr[ checkArr.length-1 ] == "tw" )
				{
//					GameLoaderData.outsideDataObj.AccNets.Close();
//					GameLoaderData.outsideDataObj.AccNets = null;
					GameLoaderData.outsideDataObj.tiao.tiao_mc.scale_mc.width = 50;
					GameLoaderData.outsideDataObj.tiao.numPercent_txt.text 	   = "13%";
					
					timeOutId = setTimeout( connetGameServe,500 );			//延迟500毫秒连游戏服务器
				} 
				return;
			} 
			else 
			{
				if( isReceive1052 )
				{
					return;
				}
				trace ( "aaaaaaaaaaaaaa" );		
		
				var roleNum:int = bytes.readUnsignedInt();

				GameLoaderData.outsideDataObj.RoleList			  = new Array(); 
				for( var i:int = 0; i<roleNum; i++ ) 
				{
					var role:RoleVo = new RoleVo();											
					role.UserId = bytes.readUnsignedInt();								
					role.Level  = bytes.readUnsignedShort();							
					role.Photo  = bytes.readUnsignedShort();                  //头像
					role.FirJob = bytes.readUnsignedShort();    			 //主职业
					role.FirLev = bytes.readUnsignedShort();               	 //主职业等级
					role.SecJob = bytes.readUnsignedShort();                 //副职业
					role.SecLev = bytes.readUnsignedShort();                 //副职业等级
					
					role.Coattype 	     = bytes.readUnsignedInt();			 //外装
					role.Wapon 		     = bytes.readUnsignedInt(); 		 //武器
					role.Mount		     = bytes.readUnsignedInt();          //坐骑
					role.sexindex        = bytes.readUnsignedInt();          //第二职业改为性别 
					bytes.readUnsignedInt();
					bytes.readUnsignedInt();				
					role.SzName		= bytes.readMultiByte(16,GameLoaderData.wordCode); 
					GameLoaderData.outsideDataObj.RoleList.push(role);	
				}
				
				isReceive1052 = true;
				GameLoaderData.outsideDataObj.tiao.tiao_mc.scale_mc.width = 100;
				GameLoaderData.outsideDataObj.tiao.numPercent_txt.text 	   = "26%";
				
				if ( GameLoaderData.outsideDataObj.RoleList.length == 1 )										//如果已有一个角色，加载资源后进入游戏
				{
					if ( nextStep != null )
					{
						nextStep();
					}
//					facade.sendNotification(CommandList.SELECTROLECOMMAND,0);
				}
				else if ( GameLoaderData.outsideDataObj.RoleList.length == 0 )								//如果没有角色，直接进入创建角色界面
				{
					if ( noRoleHandler != null )
					{
						noRoleHandler();
					}	
				}
				
			}
		}
		
		private function connetAccServe():void
		{
			repeatTime ++;
			clearTimeout( reConnectAccId );
			isConnectAcc = false;	
			trace ( "重新重复登录："+ GameLoaderData.outsideDataObj.AccSocketIP +" port:  "+GameLoaderData.outsideDataObj.AccSocketPort );
			Security.loadPolicyFile("xmlsocket://" + GameLoaderData.outsideDataObj.AccSocketIP+ ":843");
			GameLoaderData.outsideDataObj.AccNets = new AccNet( GameLoaderData.outsideDataObj.AccSocketIP, GameLoaderData.outsideDataObj.AccSocketPort );
		}
		
		private function connetGameServe():void
		{
			clearTimeout(timeOutId);
			Security.loadPolicyFile("xmlsocket://"+GameLoaderData.outsideDataObj.GameSocketIP+":843");
			GameLoaderData.outsideDataObj.GameNets = new GameNetLoader(GameLoaderData.outsideDataObj.GameSocketIP,GameLoaderData.outsideDataObj.GameSocketPort);
		}
		
		//选择要进入的游戏服务器
		private function initGameNetInfo(index:int):void
		{
			if ( GameLoaderData.outsideDataObj.GameSocketName  == "" )
			{
				var arr:Array = GameLoaderData.outsideDataObj.GameServerArr[index].split(":");
				GameLoaderData.outsideDataObj.GameSocketName = arr[0];				
				GameLoaderData.outsideDataObj.GameSocketIP = arr[1];						//游戏服务器ip
				GameLoaderData.outsideDataObj.GameSocketPort = uint( arr[2] );				//游戏服务器端口
				GameLoaderData.outsideDataObj.GameSeverNum = uint( arr[3] );				//游戏服务器当前人数
			}
			else
			{
				try
				{
					for ( var i:uint=0; i<GameLoaderData.outsideDataObj.GameServerArr.length-1; i++ )
					{
						var aTotalInfo:Array = GameLoaderData.outsideDataObj.GameServerArr[i].split(":");
						if ( aTotalInfo[0] == GameLoaderData.outsideDataObj.GameSocketName )
						{
							GameLoaderData.outsideDataObj.GameSocketIP = aTotalInfo[1];						//游戏服务器ip											
							GameLoaderData.outsideDataObj.GameSocketPort = uint(aTotalInfo[2]);			//游戏服务器端口								
							GameLoaderData.outsideDataObj.GameSeverNum = uint(aTotalInfo[3]);																			
						}
					}
				}
				catch ( e:Error )
				{
					
				}
			}
		}
	}
}