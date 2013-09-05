package Resource
{
	import Data.GameLoaderData;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	//创建角色加载器
	public class CreateRoleLoader
	{
		private var loader:Loader;
		private var xmlLoader:URLLoader = null;
		private var resArr:Array;
		private var loadItems:uint = 0;
		
		public var roleResComplete:Function;								//资源全部加载完成
		
		public function CreateRoleLoader()
		{
			resArr = [ 	GameLoaderData.outsideDataObj.SourceURL+ "Resources/Filter.swf",
				//人物职业信息描述文件
				GameLoaderData.outsideDataObj.SourceURL + "Resources/GameDLC/Tips.xml",
//加载人物角色创建资源
								GameLoaderData.outsideDataObj.SourceURL + "Resources/GameDLC/UILibrary_Role.swf"
//废弃的原本人物创建。
//								GameLoaderData.outsideDataObj.SourceURL + "Resources/GameDLC/SimpleCreateRole.swf"
								
							 ];
			initLoader();
		}
		
		private function initLoader():void
		{
//			xmlLoader = new URLLoader();
//			xmlLoader.addEventListener(Event.COMPLETE,onXmlComplete);
//			xmlLoader.load(new URLRequest(resArr[ 2 ].toString()));
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS,onProgress );
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE,onComplete );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR,reLoad );
			if ( loadItems<resArr.length )
			{
				loader.load( new URLRequest( resArr[ loadItems ].toString() ) );
			}
		}
		
//		private function onXmlComplete(ev:Event):void
//		{
//			if(xmlLoader == null){return;}
//			
//			GameLoaderData.RoleDiscribeXml = new XML(ev.target.data);
//			xmlLoader.removeEventListener(Event.COMPLETE,onXmlComplete);
//			xmlLoader = null;
//			//trace(GameLoaderData.RoleDiscribeXml);
//		}
		
		private function onProgress( evt:ProgressEvent ):void
		{
			if ( GameLoaderData.outsideDataObj.tiao )
			{
				
				var progress:int = Math.round(evt.bytesLoaded/evt.bytesTotal*100);
				var totalProgress:int = 0;
				if ( loadItems == 0 )
				{
					totalProgress = Math.round(progress*0.5);
				}else if ( loadItems == 1 ){
					totalProgress = Math.round(progress*0.5)+30;
				}
				else if ( loadItems == 2 )
				{
					totalProgress = Math.round(progress*0.5)+60;
				}
				
				GameLoaderData.outsideDataObj.tiao.total_mc.gotoAndStop(totalProgress);
				GameLoaderData.outsideDataObj.tiao.totalPercent_txt.htmlText = "<font color='#FFFFFF' size='12'>总进度："+totalProgress+"%";
				
				GameLoaderData.outsideDataObj.tiao.item_mc.gotoAndStop(progress);
				GameLoaderData.outsideDataObj.tiao.itemPercent_txt.htmlText = "<font color='#FFFFFF' size='12'>当前进度："+progress+"%";
				
				var currnetFrame:int = (GameLoaderData.outsideDataObj.tiao.total_mc as MovieClip).currentFrame;
				GameLoaderData.outsideDataObj.tiao.time_txt.htmlText = "<font color='#ffff00' size='14'>剩余时间："+( 20 - int(currnetFrame/10)*2)+" 秒</font>";
			}
		}
		
		private function onComplete( evt:Event ):void
		{
			if ( loadItems == 0 )
			{
				GameLoaderData.outsideDataObj.Filter_ad = ( loader.content as Object ).filter_dic_ad;
				GameLoaderData.outsideDataObj.Filter_chat = ( loader.content as Object ).filter_dic_chat;
				GameLoaderData.outsideDataObj.Filter_okName = ( loader.content as Object ).filter_dic_okName;
				GameLoaderData.outsideDataObj.Filter_role = ( loader.content as Object ).filter_dic_name;
				loadItems ++;

				//完成第一个swf文件加载后，开始注册xml文件加载
				xmlLoader = new URLLoader();
				xmlLoader.addEventListener(ProgressEvent.PROGRESS,onProgress);
				xmlLoader.addEventListener(Event.COMPLETE,onComplete);
				xmlLoader.load(new URLRequest( resArr[ loadItems ].toString() ));
				
			}else if ( loadItems == 1 )
			{
				//xml文件加载完成后，注册第三个文件的加载
				GameLoaderData.RoleDiscribeXml = new XML(evt.target.data);

				loadItems ++;
				loader.load( new URLRequest( resArr[ loadItems ].toString() ) );
			}
			else if ( loadItems == 2 )
			{
				if ( GameLoaderData.outsideDataObj.tiao )
				{
					GameLoaderData.outsideDataObj.tiao.total_mc.gotoAndStop(100);
					GameLoaderData.outsideDataObj.tiao.totalPercent_txt.htmlText = "<font color='#FFFFFF' size='12'>总进度：100%";
					
					GameLoaderData.outsideDataObj.tiao.item_mc.gotoAndStop(100);
					GameLoaderData.outsideDataObj.tiao.itemPercent_txt.htmlText = "<font color='#FFFFFF' size='12'>当前进度：100%";
					
					GameLoaderData.outsideDataObj.tiao.time_txt.htmlText = "<font color='#ffff00' size='14'>剩余时间：0 秒</font>";
				}
				
				GameLoaderData.CreateRoleMC = getObject( "CreateRole" ) as MovieClip;
				GameLoaderData.OccupationIntroductionMC = getObject( "tipsBg" ) as MovieClip;     //职业介绍面板
				//tipsBg
				GameLoaderData.AlertViewMC = getObject( "AlertView" ) as MovieClip;
				GameLoaderData.TipMC = getObject("TipFrame") as MovieClip;
//				GameLoaderData.LoadCircleMC = getObject( "LoadCircle" ) as MovieClip;
//				GameLoaderData.SimpleCreateRoleMC = getObject( "SimpleRole" ) as MovieClip;
				GameLoaderData.randomNameList = ( loader.content as Object ).random_role_name;
				
				if ( roleResComplete != null )
				{
					roleResComplete();
				}
				gc();
			}
		}
		
		private function reLoad( evt:IOErrorEvent ):void
		{
			//trace ( "asdfasdfads" );
		}
		
		private function getObject( _name:String ):Object
		{
			var obj:Object;
			if ( loader.contentLoaderInfo.applicationDomain.hasDefinition( _name ) )
			{
				var BgClass:Class = loader.contentLoaderInfo.applicationDomain.getDefinition( _name ) as Class;
				obj 						  = new BgClass();
			}
			return obj;
		}
		
		private function gc():void
		{
			xmlLoader.removeEventListener(Event.COMPLETE,onComplete);
			xmlLoader.removeEventListener(ProgressEvent.PROGRESS,onProgress);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,onProgress);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onComplete);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,reLoad);
//			loader.close();
			xmlLoader = null;
			loader = null;
		}

	}
}