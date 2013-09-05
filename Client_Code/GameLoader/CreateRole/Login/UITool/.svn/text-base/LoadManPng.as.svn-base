package CreateRole.Login.UITool
{
	
	
	import CreateRole.Login.Data.CreateRoleConstData;
	import CreateRole.Login.StartMediator.CreateRoleMediator;
	
	import Data.GameLoaderData;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	
	
	public class LoadManPng
	{
		public var sendShow:Function;				/** 完成后显示UI*/
		public static var path:String;
		
		private var _mediator:CreateRoleMediator;
		public function LoadManPng(path:String , mediator:CreateRoleMediator)
		{
			LoadManPng.path = path;
			_mediator = mediator;
		}
		public function load():void
		{
			if(CreateRoleConstData.rolePicList[path] != null)
			{
				if(sendShow != null)
				{
					sendShow(CreateRoleConstData.rolePicList[LoadManPng.path] , CreateRoleConstData.roleInfoList[LoadInfoPng.path]);			//缓存
					CreateRoleConstData.loadNum = 0;
				} 
				return;
			}
			var picLoader:ImageItem = new ImageItem(GameLoaderData.outsideDataObj.SourceURL + path, 
																	"movieclip" ,
																	path);
			picLoader.addEventListener(ProgressEvent.PROGRESS , onProgressHandler);
			picLoader.addEventListener(Event.COMPLETE, onPicComplete);
			picLoader.load();
			CreateRoleConstData.roleLoading = true;
		}
		/** 加载中 */
		private function onProgressHandler(e:Event):void
		{
			var precent:int = (e.target as ImageItem).bytesLoaded / (e.target as ImageItem).bytesTotal * 100;
			GameLoaderData.LoadCircleMC.txtPrecent.text = precent + "%";
			CreateRoleLoading.getInstance().showLoading();
		}
		/** 下载项完成事件 */
		private function onPicComplete(e:Event):void 
		{
			CreateRoleConstData.loadNum += 1;
			CreateRoleLoading.getInstance().removeLoading();
			var picLoader:ImageItem  = e.target as ImageItem;
			CreateRoleConstData.currentLoadMan = picLoader.content.content as MovieClip;
			var soundClass:Class = picLoader.GetDefinitionByName("roleSound")
			var roleSound:Sound = new soundClass();
			CreateRoleConstData.rolePicList[LoadManPng.path] = CreateRoleConstData.currentLoadMan;
			CreateRoleConstData.roleSoundList[LoadManPng.path] = roleSound;
			picLoader.destroy();
			picLoader.removeEventListener(Event.COMPLETE, onPicComplete);
			if(CreateRoleConstData.loadNum == 2)
			{
				CreateRoleConstData.roleLoading = false;
				CreateRoleConstData.loadNum = 0;
				if(sendShow != null) sendShow(CreateRoleConstData.currentLoadMan ,  CreateRoleConstData.roleInfoList[LoadInfoPng.path]);
				
			}
		}

	}
}