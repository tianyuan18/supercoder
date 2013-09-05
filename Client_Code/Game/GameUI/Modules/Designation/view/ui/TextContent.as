package GameUI.Modules.Designation.view.ui
{
	import GameUI.Modules.Designation.Data.DesignationEvent;
	import GameUI.Modules.RoleProperty.Datas.RolePropDatas;
	
	import Net.ActionProcessor.PlayerAction;
	import Net.ActionSend.PlayerActionSend;
	
	import OopsEngine.Utils.MovieAnimation;
	import OopsFramework.Content.ContentTypeReader;
	import OopsFramework.Content.Provider.BulkLoaderResourceProvider;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/***小条目组件*/
	public class TextContent
	{
		private var _dataObj:Object;
		private var LoaderResource:BulkLoaderResourceProvider=null;  //资源加载器
		public var _title:MovieClip = null;
		private var _titleMc:MovieClip = null;
		private var url:String = "";
		private var mclip:MovieAnimation=null;
		
		public function TextContent(obj:Object)
		{
			super();
//			this.width = 224;
//			this.height = (int(obj.type) == 0)?75:40;
			_dataObj = obj;
			init();	
//			this.mouseEnabled = false;
			_title.mouseEnabled = true;
			_title.mouseChildren = true;
			(_title.select as MovieClip).mouseEnabled = true;
			_title.container.mouseEnabled = true;
		}
		private function init():void
		{
			if(_dataObj.type == 0)//动画称号
			{
				_title = RolePropDatas.loadswfTool.GetResource().GetClassByMovieClip("BigTitle");
				
				url = GameCommonData.GameInstance.GameScene.Games.Content.RootDirectory + "Resources/Designation/" + (_dataObj.id*100+_dataObj.level).toString() + ".swf";
				var content:ContentTypeReader = GameCommonData.GameInstance.GameScene.Games.Content.Cache.permanentStorage[url]
				if( content == null )
				{
					
					LoaderResource = new BulkLoaderResourceProvider();
					LoaderResource.LoadComplete = onLoadComplete;
					LoaderResource.Download.Add(url);
					LoaderResource.Load();
//					this.width = 224;
//					this.height = 72;
				}
				else
				{
					mclip = new MovieAnimation(content.GetMovieClip());
					mclip.FrameRate = 8;
					mclip.Play();
					GameCommonData.GameInstance.GameUI.Elements.Add(mclip);
					if(_title.container.numChildren != 0){
						_title.container.addChildAt(mclip,_title.container.numChildren-1);
					}
//					_titleMc = content.GetMovieClip();
//					_titleMc.mouseEnabled = false;
//					_titleMc.mouseChildren = false;
//					_title.container.addChild(_titleMc);
					
				}
				(_title.select as MovieClip).gotoAndStop(2);
			}
			else
			{
				_title = RolePropDatas.loadswfTool.GetResource().GetClassByMovieClip("SmallTitle");
				_title.txtName.text = _dataObj.name.toString();
				_title.txtName.mouseEnabled = false;
				var a:Object = GameCommonData.Player.Role.DesignationCallList;
				if(GameCommonData.Player.Role.DesignationCallList[0] == int(_dataObj.id)*100+int(_dataObj.level))
				{
					(_title.select as MovieClip).gotoAndStop(1);
				}
				else
				{
					(_title.select as MovieClip).gotoAndStop(2);
				}
//				this.width = 224;
//				this.height = 39;
				_title.x = 0;
				_title.y = 0;
			}
			
			(_title.select as MovieClip).buttonMode = true;
			(_title.select as MovieClip).addEventListener(MouseEvent.CLICK,onSelectTitle);
			_title.container.addEventListener(MouseEvent.CLICK,txtClickHandler);
			
//			this.addChild(_title);
		}

		public function get dataObj():Object
		{
			return this._dataObj;
		}

		private function onLoadComplete():void
		{
			if(LoaderResource.GetResource(url))
			{
				_titleMc = LoaderResource.GetResource(url).GetMovieClip();
//				_titleMc.mouseEnabled = false;
//				_titleMc.mouseChildren = false;
				mclip = new MovieAnimation(_titleMc);
				mclip.FrameRate = 8;
				mclip.Play();
				GameCommonData.GameInstance.GameUI.Elements.Add(mclip);
				if(_title&&_title.container.numChildren != 0){
					_title.container.addChildAt(mclip,_title.container.numChildren-1);
				}
				
//				_title.container.addChild(_titleMc);
				GameCommonData.GameInstance.GameScene.Games.Content.Cache.AddPermanentStorage(url,LoaderResource.GetResource(url));
			}
			
		}
		
		private function onSelectTitle(e:MouseEvent):void
		{
			
//			if(_dataObj.type == 1 && GameCommonData.Player.Role.DesignationCallList[0] != 0)
//				return;

			var curFrame:uint = e.target.currentFrame;
			var newFrame:uint;
			curFrame == 1 ? newFrame=2 : newFrame=1;
			
			
			var role:Object=GameCommonData.Player.Role;
			
			var obj:Object={type:1010};
			var palyerId:int = GameCommonData.Player.Role.Id;
			
			var pos:int = this.getPositionFromDList(_dataObj.id*100+_dataObj.level);//查询对应id位置
			
			
			if(newFrame == 2)//卸载称号
			{
//				if(pos == 0)return;
				obj.data = [0,palyerId,0,0,pos,0,PlayerAction.SEND_DESIGNATION_INFO,0];//SEND_DESIGNATION_INFO == 295
			}
			else//装备称号
			{
				if(_dataObj.type == 0)//动画称号
				{
					pos = this.getPositionFromDList();//查询可用位置
					if(pos == 0)return;
					obj.data = [0,palyerId,_dataObj.id,_dataObj.level,pos,0,PlayerAction.SEND_DESIGNATION_INFO,0];//SEND_DESIGNATION_INFO == 295
				}
				else //文字称号
				{
//					if(GameCommonData.Player.Role.DesignationCallList[0]==0)//当前没有文字称号
//					{
						obj.data = [0,palyerId,_dataObj.id,_dataObj.level,0,0,PlayerAction.SEND_DESIGNATION_INFO,0];
//					}
				}
				
			}
			
			PlayerActionSend.PlayerAction(obj);
			
			e.target.gotoAndStop( newFrame );
		}

		private function txtClickHandler(e:MouseEvent):void
		{
//			if(e.currentTarget as TextContent)
//			{
				GameCommonData.GameInstance.GameScene.dispatchEvent(new DesignationEvent(DesignationEvent.DESIGNATION_EVENT,false,false,_dataObj));
				
//			}
			
		}
		
		public function setSelectVisble(visible:Boolean):void
		{
			if(_title)
			{
				(_title.select as MovieClip).visible = visible;
			}
		}
		
		public function gc():void
		{
			if(mclip)
			{
				GameCommonData.GameInstance.GameUI.Elements.Remove(mclip);
				mclip = null;
			}
			
			if(_title)
			{
				while(_title.container.numChildren>0){
					_title.container.removeChildAt(0);
				}
				(_title.select as MovieClip).removeEventListener(MouseEvent.CLICK,onSelectTitle);
				_title.container.removeEventListener(MouseEvent.CLICK,txtClickHandler);
			}
			_titleMc = null;
			_title = null;
		}
		
		private function getPositionFromDList(id:int=0):int
		{
			var a:Object  =GameCommonData.Player.Role.DesignationCallList;
			for(var i:int=1;i<GameCommonData.Player.Role.DesignationCallList.length;i++)
			{
				if(GameCommonData.Player.Role.DesignationCallList[i]==id)
				{
					return i+1;
				}
			}
			return 0;
		}
	}
}