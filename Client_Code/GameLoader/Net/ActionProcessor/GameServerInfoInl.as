package Net.ActionProcessor
{
	import Data.GameLoaderData;
	
	import Net.AccNetInl;
	import Net.BaseSocketLoader;
	import Net.GameNetLoader;
	
	import Vo.RoleVo;
	
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/** 连接游戏服务器  */
	public class GameServerInfoInl
	{
		private var securSocket:BaseSocketLoader;
		private var timeOutId:uint;
		
		private var gameServerArr:Array;
		public var isConnectAcc:Boolean = false;							//是否连接过账号服务器
		public var isReceive1052:Boolean = false;							//是否连接过游戏服务器
		
		public var nextStep:Function;
		public var noRoleHandler:Function;
		public var choiceRoleHandler:Function;
		public var connectServer:Function;
		
		private var reg:RegExp = /重复/g;						//重复登陆
		private var reConnectId:int;									//重新登录延时
		
		private var repeatTime:uint = 0;
		private var reConnectAccId:int;
		private var gsIp:String;
		private var lineArr:Array;
		private var personNumber:Array;
		private var tempArray:Array;
		private var isStop:Boolean = false;
		private var isFirst:Boolean = true;
		
		public function GameServerInfoInl()
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
				GameLoaderData.outsideDataObj.AccNets.Close();
				GameLoaderData.outsideDataObj.AccNets = null;
				if ( reg.test( szInfo ) )
				{
					if ( repeatTime == 0 )
					{
//						reConnectAccId = setTimeout( connetAccServe,3000 );
//						GameLoaderData.outsideDataObj.tiao.content_txt.x = 110;
//						GameLoaderData.outsideDataObj.tiao.content_txt.text = szInfo.toString();
						return;
					}
					else
					{
//						GameLoaderData.outsideDataObj.tiao.content_txt.x = 30;
//						GameLoaderData.outsideDataObj.tiao.content_txt.text = szInfo.toString();
					}
				}		
				isConnectAcc = true;																		
				gameServerArr = szInfo.split(";");			
//				gameServerArr = ["一线:192.168.6.85:8846:10", "二线:192.168.6.85:8846:20", "三线:192.168.6.85:8846:30", "四线:192.168.6.85:8846:40", "五线:192.168.6.85:8846:50", "六线:192.168.6.85:8846:60"];														
				GameLoaderData.outsideDataObj.GameServerArr = gameServerArr;	
					
				if( check(gameServerArr[gsIndex].split(":")[0]) )
				{
					filterLine();
					this.personNumber = new Array();
//					trace(GameLoaderData.outsideDataObj.fiterGameServerArr);
					for(var j:uint=0; j<GameLoaderData.outsideDataObj.fiterGameServerArr.length-1; j++)
					{
						this.personNumber.push(GameLoaderData.outsideDataObj.fiterGameServerArr[j].split(":")[3]);
//						trace(GameLoaderData.outsideDataObj.fiterGameServerArr[j].split(":")[3]);	
					}
//					trace(personNumber);
					tempArray = this.personNumber.sort( Array.NUMERIC | Array.RETURNINDEXEDARRAY );
					isStop = true;
					gsIp = gameServerArr[gsIndex].split(":")[1];									//游戏服务器ip											
					initGameNetInfo(gsIndex);
				}else{
					if( isStop )
					{
						isStop = false;
						var name:String = GameLoaderData.outsideDataObj.fiterGameServerArr[int(tempArray[0])].split(":")[0];;
						if ( GameLoaderData.outsideDataObj.GameSocketName  != "" )
						{
							if( name == "s" )
							{
								GameLoaderData.outsideDataObj.GameSocketName = GameLoaderData.outsideDataObj.fiterGameServerArr[int(tempArray[1])].split(":")[0];
							}
							else
							{
								GameLoaderData.outsideDataObj.GameSocketName = GameLoaderData.outsideDataObj.fiterGameServerArr[int(tempArray[0])].split(":")[0];
							}
						}
						if( name == "s" )
						{
							gsIp = GameLoaderData.outsideDataObj.fiterGameServerArr[int(tempArray[1])].split(":")[1];
							initGameNetInfo(int(tempArray[1]));
						}
						else
						{
							gsIp = GameLoaderData.outsideDataObj.fiterGameServerArr[int(tempArray[0])].split(":")[1];
							initGameNetInfo(int(tempArray[0]));
						}
						
					}else{
						if( GameLoaderData.outsideDataObj.hideLines && GameLoaderData.outsideDataObj.hideLines != "" ) 
						{
							filterLine();
						}else
						{
							GameLoaderData.outsideDataObj.fiterGameServerArr = GameLoaderData.outsideDataObj.GameServerArr;
						}
						gsIp = gameServerArr[gsIndex].split(":")[1];									//游戏服务器ip											
						initGameNetInfo(gsIndex);
					}
				}
																																							
				obj 	      = new Object();
				obj.len	      = 336;															
//				obj.ip 	      = GameConfigData.GameSocketIP;
				obj.dwData    = dwData;
				obj.idAccount = idAccount;
				GameLoaderData.outsideDataObj.GServerInfo = obj;
//				CreateRoleConstData.playerobj.id = obj.idAccount;	                //将游戏ID保存在创建人物的数据里
				
				if(!gsIp)
				{
					if((GameLoaderData.outsideDataObj.language == 1 && szInfo.toString().indexOf("验证码") > -1) || (GameLoaderData.outsideDataObj.language == 2 && szInfo.toString().indexOf("驗證碼") > -1))
					{
//						GameLoaderData.outsideDataObj.tiao.content_txt.x = 75;
//						GameLoaderData.outsideDataObj.tiao.content_txt.width = 260;
					}
					else
					{
//						GameLoaderData.outsideDataObj.tiao.content_txt.x = 120;
					}
//					GameLoaderData.outsideDataObj.tiao.content_txt.text = szInfo.toString();
					return;
				}
				var checkArr:Array = gsIp.split( "." );
				if ( checkArr[ checkArr.length-1 ] == "com" || gsIp.split(".").length == 4 || szReg.test(gsIp) || checkArr[ checkArr.length-1 ] == "cn" || checkArr[ checkArr.length-1 ] == "tw" )
//				if (gsIp.split(".")[2] == "com" || gsIp.split(".").length == 4 || szReg.test(gsIp))
				{
					if( isFirst )
					{
						GameLoaderData.outsideDataObj.tiao.tiao_mc.scale_mc.width = 50;
						GameLoaderData.outsideDataObj.tiao.numPercent_txt.text 	   = "13%";
					}
					
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
					GameLoaderData.faceNumArr.push( uint(role.Photo) );
				}
				
				//虚拟数据
//				for( var i:int = 0; i<5; i++ ) 
//				{
//					var role:RoleVo = new RoleVo();											
//					role.UserId = 44545;								
//					role.Level  = 1;							
//					role.Photo  = 3;                  //头像
//					role.FirJob = 1;    			 //主职业
//					role.FirLev = 0;               	 //主职业等级
//					role.SecJob = 1;                 //副职业
//					role.SecLev = 0;                 //副职业等级
//					
//					role.Coattype 	     = 0;			 //外装
//					role.Wapon 		     = 0; 		 //武器
//					role.Mount		     = 0;          //坐骑
//					role.sexindex        = 1;          //第二职业改为性别 				
//					role.SzName		= "猥琐神教"; 
//					GameLoaderData.outsideDataObj.RoleList.push(role);	
//					GameLoaderData.faceNumArr.push( uint(role.Photo) );
//				}
				
				isReceive1052 = true;
				GameLoaderData.outsideDataObj.tiao.total_mc.gotoAndStop(26);
				GameLoaderData.outsideDataObj.tiao.totalPercent_txt.text 	   = "26%";
				
				if( isStop )
				{
					isConnectAcc = false;							//是否连接过账号服务器
					isReceive1052 = false;
		            GameLoaderData.outsideDataObj.GameNets.endGameNet();
		            GameLoaderData.outsideDataObj.GameSocketName = GameLoaderData.outsideDataObj.fiterGameServerArr[tempArray[0]].split(":")[0];
//					connectServer();
					setTimeout( connectServer,500 );
					return;
				}
				/////////////////台服修改bug，暂时屏蔽掉
				if ( GameLoaderData.outsideDataObj.RoleList.length == 1 )										//如果已有一个角色，加载资源后进入游戏
				{
					GameLoaderData.outsideDataObj.Filter_Switch = false;
					if ( nextStep != null )
					{
						nextStep();
					}
				}
				else if ( GameLoaderData.outsideDataObj.RoleList.length == 0 )								//如果没有角色，直接进入创建角色界面
				{
					GameLoaderData.outsideDataObj.Filter_Switch = true;
					if ( noRoleHandler != null )
					{
						noRoleHandler();
					}	
				}
				else if ( GameLoaderData.outsideDataObj.RoleList.length > 1 )                               //如果有多个角色，进入选择角色界面
				{
					if ( GameLoaderData.outsideDataObj.language == 2 )
					{
						if ( nextStep != null )
						{
							nextStep();
						}
					}
					else
					{
						if( choiceRoleHandler != null ) 
						{
							choiceRoleHandler();
						}
					}
					
				}   
				
			}
		}
		
		private function check( str:String ):Boolean
		{
			if( GameLoaderData.outsideDataObj.hideLines )
			{
				lineArr = GameLoaderData.outsideDataObj.hideLines.split("_");
//				trace( lineArr );
//				trace( str );
				for each( var num:* in lineArr )
				{
					if( GameLoaderData.lineNameArr[int(num)-1] == str ) return true;
				}
			}
			return false;
		}
		
		private function filterLine():void
		{
			var s:String;
			GameLoaderData.outsideDataObj.fiterGameServerArr = new Array();
			for(var i:uint=0; i<gameServerArr.length; i++)
			{
				s = gameServerArr[i].split(":")[0];
				var bool:Boolean = true;
				for(var j:uint=0; j<lineArr.length; j++)
				{
					if( s == GameLoaderData.lineNameArr[int(lineArr[j])-1] )
					{
						bool = false;
						break;
					}
				}
				if( bool ) GameLoaderData.outsideDataObj.fiterGameServerArr.push( gameServerArr[i] );
			}
//			trace( GameLoaderData.outsideDataObj.fiterGameServerArr );
		}
		
		private function connetAccServe():void
		{
			repeatTime ++;
			clearTimeout( reConnectAccId );
			isConnectAcc = false;	
//			trace ( "重新重复登录："+ GameLoaderData.outsideDataObj.AccSocketIP +" port:  "+GameLoaderData.outsideDataObj.AccSocketPort );			
			Security.loadPolicyFile("xmlsocket://" + GameLoaderData.outsideDataObj.AccSocketIP+ ":843");			
			GameLoaderData.outsideDataObj.AccNets = new AccNetInl( GameLoaderData.outsideDataObj.AccSocketIP, GameLoaderData.outsideDataObj.AccSocketPort );
		}
		
		private function connetGameServe():void
		{
			clearTimeout(timeOutId);
			Security.loadPolicyFile("xmlsocket://"+GameLoaderData.outsideDataObj.GameSocketIP+":843");
			var obj:Object = GameLoaderData.outsideDataObj;
			GameLoaderData.outsideDataObj.GameNets = new GameNetLoader(GameLoaderData.outsideDataObj.GameSocketIP,GameLoaderData.outsideDataObj.GameSocketPort);
		}
		
		//选择要进入的游戏服务器
		private function initGameNetInfo(index:int):void
		{
			if( !isFirst && GameLoaderData.outsideDataObj.fiterGameServerArr && GameLoaderData.outsideDataObj.fiterGameServerArr.length > 0 )
			{
				if ( GameLoaderData.outsideDataObj.GameSocketName  == "" )
				{
					var array:Array = GameLoaderData.outsideDataObj.fiterGameServerArr[index].split(":");
					GameLoaderData.outsideDataObj.GameSocketName = array[0];				
					GameLoaderData.outsideDataObj.GameSocketIP = array[1];						//游戏服务器ip
					GameLoaderData.outsideDataObj.GameSocketPort = uint( array[2] );				//游戏服务器端口
					GameLoaderData.outsideDataObj.GameSeverNum = uint( array[3] );				//游戏服务器当前人数
				}
				else
				{
					try
					{
						for ( var k:uint=0; k<GameLoaderData.outsideDataObj.fiterGameServerArr.length-1; k++ )
						{
							var aTotalInfoArr:Array = GameLoaderData.outsideDataObj.fiterGameServerArr[k].split(":");
							if ( aTotalInfoArr[0] == GameLoaderData.outsideDataObj.GameSocketName )
							{
								GameLoaderData.outsideDataObj.GameSocketIP = aTotalInfoArr[1];						//游戏服务器ip											
								GameLoaderData.outsideDataObj.GameSocketPort = uint(aTotalInfoArr[2]);			//游戏服务器端口								
								GameLoaderData.outsideDataObj.GameSeverNum = uint(aTotalInfoArr[3]);																			
							}
						}
					}
					catch ( e:Error )
					{
						
					}
				}
				trace("进入线路信息：" + GameLoaderData.outsideDataObj.GameSocketName, GameLoaderData.outsideDataObj.GameSocketIP, GameLoaderData.outsideDataObj.GameSocketPort, GameLoaderData.outsideDataObj.GameSeverNum );
			}else{
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
				trace("进入线路信息：" + GameLoaderData.outsideDataObj.GameSocketName, GameLoaderData.outsideDataObj.GameSocketIP, GameLoaderData.outsideDataObj.GameSocketPort, GameLoaderData.outsideDataObj.GameSeverNum );
				isFirst = false;
			}
			
		}
	}
}