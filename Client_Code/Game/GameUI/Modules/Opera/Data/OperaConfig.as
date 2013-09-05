package GameUI.Modules.Opera.Data
{
	import GameUI.Modules.Opera.Mediator.OperaMediator;
	
	import OopsEngine.Exception.ExceptionResources;
	
	import OopsFramework.Content.Loading.BulkProgressEvent;
	import OopsFramework.Content.Provider.BulkLoaderResourceProvider;
	import OopsFramework.Game;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notifier;
	
	public class OperaConfig extends BulkLoaderResourceProvider
	{
		public var Progress:Function;
		private var configXmlUrl:String;
		
		public function OperaConfig(OperaName:String)
		{
			this.configXmlUrl = GameCommonData.GameInstance.Content.RootDirectory + "Resources/Opera/" + OperaName + ".xml";
		}
		
		public override function Load():void
		{
			//			this.Download.Version = Game.Version;
			this.Download.Add(this.configXmlUrl);
			super.Load();
		}
		
		protected override function onBulkProgress(e:BulkProgressEvent):void
		{
			super.onBulkProgress(e);
			if(Progress!=null) Progress(e);
		}
		
		protected override function onBulkCompleteAll():void 
		{
			//加载完了配置文件，将信息分析储存在动画存储器重
			var ConfigXml:XML  = this.GetResource(this.configXmlUrl).GetXML();
			
			OperaMediator.OperaDic = new Array();
			var xml:XML = ConfigXml;
			
			var role:Object = new Object();
			var roleList:Array = new Array();
			var count:int = xml.roleList.player.length();
			for(var i:int = 0; i<xml.roleList.player.length(); i++)
			{
				var player:Object = new Object();
				player.name = xml.roleList.player[i].@name.toString();
				player.type = xml.roleList.player[i].@type.toString();
				player.skinId = xml.roleList.player[i].@skinId.toString();
				player.direct = int(xml.roleList.player[i].@direct);
				player.X = int(xml.roleList.player[i].@X);
				player.Y = int(xml.roleList.player[i].@Y);
				roleList[i] = player;
			}
			role.roleList = roleList;
			OperaMediator.OperaDic[0] = role;			
			
			for(var ii:int = 0; ii< xml.opera.length();ii++)
			{
				var obj:Object = new Object();
				obj.step = xml.opera[ii].@step;
				obj.timeout = xml.opera[ii].@timeout;
				var segment:Array = new Array();
				for(var jj:int=0; jj<xml.opera[ii].segment.length();jj++)
				{
					var seg:Object = new Object();
					seg.type = xml.opera[ii].segment[jj].@type.toString();
					seg.player = xml.opera[ii].segment[jj].@player.toString();
					trace("seg.type = " + seg.type);
					switch(seg.type.toString())
					{
						case "1":
							seg.X = int(xml.opera[ii].segment[jj].@X);
							seg.Y = int(xml.opera[ii].segment[jj].@Y);
							trace(seg.X+ "--"+seg.Y);
							break;
						case "2":
							seg.talkInfo = xml.opera[ii].segment[jj].@talkinfo.toString();
							seg.skinId = xml.opera[ii].segment[jj].@skinId.toString();
							trace(seg.talkInfo);
							break;
						case "3":										//人物打斗
							break;
						case "4":										//播放动画swf
							break;
						case "5":										//添加人物进场
							seg.X = int(xml.opera[ii].segment[jj].@X);
							seg.Y = int(xml.opera[ii].segment[jj].@Y);
							seg.skinId = xml.opera[ii].segment[jj].@skinId.toString();
							break;
						case "6":										//人物或物品从场景消失
							break;
					}
					segment[jj]=seg;
				}
				obj.segment = segment;
				OperaMediator.OperaDic[obj.step] = obj;
			}
			
			super.onBulkCompleteAll();
			
			//存储完成后就可以开始播放动画
//			UIFacade.UIFacadeInstance.sendNotification(OperaEvents.INITROLES);
			GameCommonData.UIFacadeIntance.sendNotification(OperaEvents.INITROLES);
		}
		
		protected override function onBulkError(e:BulkProgressEvent):void
		{
			throw new Error(ExceptionResources.ErrorGameSceneConfig + "：" + e.ErrorMessage);
		}
	}
}