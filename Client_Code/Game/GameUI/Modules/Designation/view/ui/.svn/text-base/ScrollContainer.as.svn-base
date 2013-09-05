package GameUI.Modules.Designation.view.ui
{
	import GameUI.Modules.Designation.Data.DesignationEvent;
	import GameUI.Modules.RoleProperty.Datas.RolePropDatas;
	import GameUI.View.Components.UIScrollPane;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	public class ScrollContainer extends Sprite
	{
		private var cellContainer:Sprite;//装条目的容器
		private var scroll:UIScrollPane;
		private var _dataArr:Array;
		private var _txtArr:Array;
		private var tempTxt:TextContent;
		public var textContentList:Dictionary = new Dictionary;
		
		public function ScrollContainer()
		{
			
		}
		/**添加每个条目的小项*/
		public function createCells(dataArr:Array,_width:Number = 0,_height:Number = 0,visible:Boolean = true):void
		{
			this.mouseEnabled = false;
			_dataArr = dataArr;
			_txtArr = [];
			cellContainer = new Sprite();
			var h:int = 0;
			textContentList = new Dictionary;
			var textContent:TextContent = null;
			var obj:Object = null;
			var split:MovieClip = null;
			
			for each(obj in _dataArr)
			{
				if(obj.type == 0)
				{
					textContent = new TextContent(obj);
					textContent.setSelectVisble(visible);
					textContent._title.x = 1;
					textContent._title.y = h;
					//				textContent._title.y = 39*tag;
					cellContainer.addChild(textContent._title);
					split = RolePropDatas.loadswfTool.GetResource().GetClassByMovieClip("splitLine");
					split.x = 1;
					split.y = (int(obj.type) == 0)?textContent._title.y+75:textContent._title.y+40;
					cellContainer.addChild(split);
					h = split.y;
					textContentList[int(obj.id)*100+int(obj.level)] = textContent;
				}
			}
			
			for each(obj in _dataArr)
			{
				if(obj.type == 1)
				{
					textContent = new TextContent(obj);
					textContent.setSelectVisble(visible);
					textContent._title.x = 1;
					textContent._title.y = h;
					//				textContent._title.y = 39*tag;
					cellContainer.addChild(textContent._title);
					split = RolePropDatas.loadswfTool.GetResource().GetClassByMovieClip("splitLine");
					split.x = 1;
					split.y = (int(obj.type) == 0)?textContent._title.y+75:textContent._title.y+40;
					cellContainer.addChild(split);
					h = split.y;
					textContentList[int(obj.id)*100+int(obj.level)] = textContent;
				}
			}

			cellContainer.mouseEnabled = false;
			scroll = new UIScrollPane(cellContainer);
			scroll.width = _width;
			scroll.height = _height;
			scroll.setHideType(0);
			scroll.scrollPolicy = UIScrollPane.SCROLLBAR_AS_NEEDED;
			scroll.refresh();
			this.addChild(scroll);
			
			if(visible)
			{
				setSelectState();
			}
			
		}
		
		public function createCellsNoSplit(dataArr:Array,_width:Number = 0,_height:Number = 0,visible:Boolean = true):void
		{
			this.mouseEnabled = false;
			_dataArr = dataArr;

			cellContainer = new Sprite();
			var h:int = 0;
			
			var textContent:TextContent = null;
			var obj:Object = null;
			var split:MovieClip = null;
			
			cellContainer.mouseEnabled = false;
			
			textContentList = new Dictionary;
			
			for(var i:int = dataArr.length-1;i>=0;i--)
			{
				obj = GameCommonData.NewDesignation[int(dataArr[i])];

				if(obj)
				{
					textContent = new TextContent(obj);
					textContent.setSelectVisble(visible);
					textContent._title.x = 1;
					textContent._title.y = h;
					cellContainer.addChild(textContent._title);
					h = (int(obj.type) == 0)?h+75:h+40;	
					textContentList[int(obj.id)*100+int(obj.level)] = textContent;
				}
			}
			scroll = new UIScrollPane(cellContainer);
			scroll.width = _width;
			scroll.height = _height;
			scroll.scrollPolicy = UIScrollPane.SCROLLBAR_AS_NEEDED;
			scroll.refresh();
			this.addChild(scroll);
		}
		
		public function setSelectState():void
		{

			for(var i:int=1;i<GameCommonData.Player.Role.DesignationCallList.length; i++)
			{
				if(GameCommonData.Player.Role.DesignationCallList[i] != 0)
				{
					if(textContentList[GameCommonData.Player.Role.DesignationCallList[i]])
					{
						(textContentList[GameCommonData.Player.Role.DesignationCallList[i]] as TextContent)._title.select.gotoAndStop(1);
					}
					
				}
			}
			
		}
		
//		public function getTxtArr():Array
//		{
//			return _txtArr;
//		}
		public function gc():void
		{
			if(textContentList)
			{
				for each(var tContent:Object in textContentList)
				{
					(tContent as TextContent).gc();
					tContent = null;
				}
				
			}
			if(scroll)
			{
				this.removeChild(scroll);
				scroll = null;
			}
			cellContainer = null;
			
			_dataArr = null;
			_txtArr = null;
		}

		public override function set width(value:Number):void
		{
			scroll.width = value;
		}
		public override function set height(value:Number):void
		{
			scroll.height = value;
		}
		public override function get height():Number
		{
			return scroll.height;
		}
	}
}