package 
{
	import GameUI.Command.RecLoaderDataCommand;
	import GameUI.ConstData.EventList;
	import GameUI.Modules.Login.StartMediator.TestLogin;
	import GameUI.UICore.UIFacade;
	
	import Net.AccNet;
	
	import OopsEngine.Engine;
	import OopsEngine.Scene.StrategyScene.GameScenePlay;
	
	import OopsFramework.GameTime;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.system.Security;
	import flash.utils.*;
	
	[SWF(width="1024",height="760")]
	public class Game extends Engine
	{
		private var timeOutId:int;
		public function Game(stage:Stage = null, info:Object=null)
		{
			super(stage);
			Security.allowDomain("*");  
			Engine.UILibrary            = GameConfigData.UILibrary;
			GameCommonData.GameInstance = this;
			
			if(info)  
			{
				UIFacade.GetInstance( UIFacade.FACADEKEY ).registerCommand( RecLoaderDataCommand.NAME, RecLoaderDataCommand );
				UIFacade.GetInstance( UIFacade.FACADEKEY ).sendNotification( RecLoaderDataCommand.NAME,{ info:info } );
			}
			else
			{
				GameConfigData.AccSocketIP   = "192.168.0.200"; 
				//GameConfigData.AccSocketIP   = "192.168.1.111"; 
				//			    GameConfigData.AccSocketIP   = "s5.yjjh.kuwo.cn"
				//				Content.RootDirectory        = "http://yjjh-r.my4399.com:8080/";
				//				Content.RootDirectory   	 = "http://192.168.0.200/";
				Content.RootDirectory   	 = "E:/Client_Code/"; 
				//				GameCommonData.LoginName     ="wlufowl1";
				//				GameCommonData.LoginPassword ="105837767"; 
				
				//				GameCommonData.LoginName     = "kongliang19821214";						 		  		 						// yygm002 yyyjjh2 yygm001  
				//				GameCommonData.LoginPassword = "79340986"; 
				
				
				//测试服
				//				GameConfigData.AccSocketIP   = "192.168.6.206";
				//				GameConfigData.AccSocketIP   = "yjjh8-s.kuaiwan.com";
				//				GameConfigData.AccSocketIP   = "s1.yjjh.05wan.com";
				//				GameConfigData.AccSocketIP   = "s11.yjjh.wan.360.cn";
				//				GameConfigData.AccSocketIP   = "yjjh-test888.my4399.com";
				//				GameConfigData.AccSocketIP   = "yjjh56-s.my4399.com";  
				//				GameConfigData.AccSocketIP   = "192.168.6.85";
				//				GameConfigData.AccSocketIP   = "yjjh-test888.my4399.com";
				//				Content.RootDirectory   	 = "http://192.168.6.205:8888/lh/";
				//				Content.RootDirectory        = "http://yjjh-test777.my4399.com:8080/";
				//				Content.RootDirectory        = "http://s1-r.yjjh.05wan.com/";
				//				Content.RootDirectory        = "http://s11.yjjh.wan.360.cn:8080/";
				//				Content.RootDirectory   = "http://yjjh52-s.my4399.com:8080/";  
				//				Content.RootDirectory        = "http://yjjh8-s.kuaiwan.com:8080/";
				//				Content.RootDirectory        = "http://yjjh56-s.my4399.com:8080/";
				//				Content.RootDirectory   	 = "http://192.168.6.206/";
				//				GameCommonData.LoginName     = "197203311a";						 		  		 						// yygm002 yyyjjh2 yygm001  
				//				GameCommonData.LoginPassword = "117466817"; 
				GameCommonData.LoginName     = "y001";						 		  		 						// yygm002 yyyjjh2 yygm001  
				GameCommonData.LoginPassword = "111111"; 
				//内网 
				/* GameConfigData.AccSocketIP   = "yjjh-test888.my4399.com";
				GameCommonData.LoginName     = "test001";						 		  		 						// yygm002 yyyjjh2 yygm001  
				GameCommonData.LoginPassword = "1"; */  
				
				//                GameConfigData.AccSocketIP   = "yjjh-test888.my4399.com";
				//				this.Content.RootDirectory   = "http://yjjh-test777.my4399.com:8080/"; 
				////				Content.RootDirectory        = "http://192.168.6.205:8888/lh/";
				//				GameCommonData.LoginName     = "1skill";						 		  		 						// yygm002 yyyjjh2 yygm001  
				//				GameCommonData.LoginPassword = "1";  
				//				
				/* GameConfigData.AccSocketIP   = "yjjh1001-s.91wan.com";
				Content.RootDirectory        = "yjjh-test777.my4399.com:8080/";
				Content.RootDirectory   	 = "http://192.168.6.205:8888/lh/";
				GameCommonData.LoginName     = "wlufowl";						 		  		 						// yygm002 yyyjjh2 yygm001  
				GameCommonData.LoginPassword = "1702322456"; */
				//				//360
				//				GameConfigData.AccSocketIP   = "s4.yjjh.wan.360.cn"; 	  
				//				Content.RootDirectory   = "http://s4.yjjh.wan.360.cn:8080/";   
				//				GameCommonData.LoginName     = "32879835";						 		  		 						// yygm002 yyyjjh2 yygm001  
				//				GameCommonData.LoginPassword = "32879835";  
				//				//91wan
				/* 	GameConfigData.AccSocketIP   = "yjjh1-s.91wan.com"; 	  
				Content.RootDirectory   = "http://yjjh1001-s.91wan.com:8080/";   
				GameCommonData.LoginName     = "xajh516";						 		  		 						// yygm002 yyyjjh2 yygm001  
				GameCommonData.LoginPassword = "400222600";  */
				//				
				//				GameConfigData.AccSocketIP   = "s4.yjjh.kuwo.cn"; 
				//				Content.RootDirectory   	 = "http://s1.yjjh.kuwo.cn:8080/"; 
				//				GameCommonData.LoginName     = "xiaoll520";						 		  		 						// yygm002 yyyjjh2 yygm001  
				//				GameCommonData.LoginPassword = "48778006";  
				//				//4399
				//				GameConfigData.AccSocketIP   = "yjjh1-s.my4399.com"; 
				//				Content.RootDirectory        = "http://yjjh-r.my4399.com:8080/"; 
				//				GameCommonData.LoginName     = "dongrunbinnb";						 		  		 						// yygm002 yyyjjh2 yygm001  
				//				GameCommonData.LoginPassword = "139445642";  
				
				//				GameConfigData.AccSocketIP   = "113.107.160.179";													// yjjh3-s.my4399.com			
				//				GameConfigData.AccSocketIP   = "s1.yjjh.wan.360.cn"; 	 
				//				GameConfigData.AccSocketIP   = "s1.yjjh.kuwo.cn"; 		 		
				//				GameConfigData.AccSocketIP   = "yjjh20-s.91wan.com"; 
				//				GameConfigData.AccSocketIP   = "yjjh1-static.web.woyo.com";			  
				//				GameConfigData.AccSocketIP   = "127.0.0.1";	
				
				//				GameConfigData.AccSocketIP   = "s3.yjjh.wan.360.cn";	
				//				GameConfigData.AccSocketIP   = "s1.yjjh.37wan.com"; 
				
				//				GameConfigData.AccSocketIP   = "192.168.6.205";		
				//				GameCommonData.LoginName     = "fc100";																	// yygm002 yyyjjh2 yygm001  
				//				GameCommonData.LoginPassword = "4606908"; //88639648	//1400629884
				//				GameCommonData.LoginName     = "yjjhadm01";								  		 						// yygm002 yyyjjh2 yygm001  
				//				GameCommonData.LoginPassword = "88945383"; //88639648 //79340986	                                             //http://192.168.1.53:8089/	
				//				GameCommonData.LoginName     = "killbad";						 		  		 						// yygm002 yyyjjh2 yygm001  
				//				GameCommonData.LoginPassword = "77650014"; //88639648 //79340986			
				//				GameCommonData.LoginName     = "908087098";						 		  		 						// yygm002 yyyjjh2 yygm001  
				//				GameCommonData.LoginPassword = "38041090"; //88639648 //79340986 		
				//				GameCommonData.LoginName     = "ppagi007";						 		  		 						// yygm002 yyyjjh2 yygm001  
				//				GameCommonData.LoginPassword = "1785355"; //88639648 //79340986 	                                             //http://192.168.1.53:8089/
				//88639648 //79340986	    		
				//				this.Content.RootDirectory   = "http://yjjh1-s.5awan.com:8080/";   
				//				this.Content.RootDirectory   = "http://s1.yjjh.wan.360.cn:8080/";      
				//				this.Content.RootDirectory   = "http://s1.yjjh.kuwo.cn:8080/";  
				//				GameConfigData.GmPhpPath     = "http://yjjh1-bak.my4399.com/" + GameConfigData.GmPhpPath;
				//				this.Content.RootDirectory   = "http://yjjh31-s.91wan.com:8080/";
				//				this.Content.RootDirectory   = "http://192.168.6.206/"; 
				//				this.Content.RootDirectory   = "http://s3.yjjh.wan.360.cn:8080/"; 
				//				this.Content.RootDirectory   = "http://192.168.6.200:8080/"; 
				//				this.Content.RootDirectory   = "http://yjjh-r.my4399.com:8080/";                        
				//				this.Content.RootDirectory   = "http://yjjh-test777.my4399.com:8080/";      
				//				this.Content.RootDirectory   = "http://s1.yjjh.37wan.com:8080/";  
				
			}
			
			this.GameScene.GameScenes.Add(GameCommonData.SCENE_GAME,GameScenePlay);
			
			addBack();																									//添加从loader过来的图片
			if( !GameCommonData.isLoginFromLoader )  
			{
				TestLogin.login();
			}
			
			this.Resize = this.changeResize;					//自适应，暂时屏蔽掉
			//			this.Components.Add(new FpsComponent(this));
		}
		
		private function connectAccServer():void
		{
			clearTimeout( timeOutId );
			Security.loadPolicyFile("xmlsocket://" + GameConfigData.AccSocketIP + ":843");
			GameCommonData.AccNets = new AccNet(GameConfigData.AccSocketIP, GameConfigData.AccSocketPort);
		}
		
		protected override function Update(gameTime:GameTime):void
		{
			super.Update(gameTime);
			if(UIFacade.UIFacadeInstance)
			{
				UIFacade.UIFacadeInstance.gameHeartPoint(gameTime);
			}
		}
		
		private function addBack():void
		{
			//			if(GameCommonData.BackGround)
			//			{
			//				GameCommonData.GameInstance.GameScene.addChild(GameCommonData.BackGround);	
			//			}
			
			if(GameCommonData.Tiao)
			{
				//				GameCommonData.Tiao.x = 310;
				//				GameCommonData.Tiao.y = 465;
				//				GameCommonData.Tiao.content_txt.x = 1; 
				//				GameCommonData.Tiao.content_txt.y = -18;
				GameCommonData.GameInstance.GameScene.addChild(GameCommonData.Tiao);
			}
		}
		
		public function changeResize(e:Event):void
		{
			//			UIFacade.GetInstance( UIFacade.FACADEKEY ).registerMediator( new AutoSizeMediator() );
			UIFacade.GetInstance( UIFacade.FACADEKEY ).sendNotification( EventList.STAGECHANGE );
		}
	}
}