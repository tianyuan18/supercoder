package GameUI.View.Components
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import GameUI.Modules.GmTools.Utils.LoadSwfTool;
	
	public class PanelList extends Sprite
	{
		public var firstPetIndex:int = 0;
		public var panelArray:Array = null;
		private var petShowMaxNum:int = 0;
		private var panelList:MovieClip = null;
		
		public var onUpClickFuc:Function = null;
		public var onDownClickFuc:Function = null;
		public var onSelectFuc:Function = null;
		
		/** 对应界面5个宠物栏，不是对应panelList数组，换算方法是curSelectPet+firstPetIndex就是对应数组的位置*/
		public var curSelectPet:int = 0;
		private var loadswfTool:LoadSwfTool=null;
		
		public function PanelList(num:int,_loadswfTool:LoadSwfTool=null)
		{
			this.loadswfTool = _loadswfTool;
//			panelList = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("petList");
			panelList = this.loadswfTool.GetResource().GetClassByMovieClip("petList");
			
			this.addChild(panelList);
			petShowMaxNum = num;
			for(var i:int=0;i<petShowMaxNum; i++)
			{
				panelList["pet_"+i].visible = false;
				panelList["pet_"+i].SelectedFrame.visible = false;
				panelList["pet_"+i].btnFree.visible = false;
				panelList["pet_"+i].btnFreeName.visible = false;
			}
			curSelectPet = 0;
		}

		public function onUpClick(e:MouseEvent):void
		{
			if(firstPetIndex>0 && panelArray.length>petShowMaxNum)
			{
				firstPetIndex--;
				if(onUpClickFuc != null)onUpClickFuc();
			}
		}
		
		public function onDownClick(e:MouseEvent):void
		{
			if(firstPetIndex+petShowMaxNum < panelArray.length)
			{
				firstPetIndex++;
//				createPetUI();
				if(onDownClickFuc != null)onDownClickFuc();
			}
		}
		
		public function createListUI(name:String,lev:String,i:int,state:int=0):void
		{
			
			var index:int = i-firstPetIndex;
			panelList["pet_"+index].visible = true;
			panelList["pet_"+index].addEventListener(MouseEvent.CLICK,onSelectClick);
			panelList["pet_"+index].txtName.text = name;
			panelList["pet_"+index].txtLevel.text = lev;
			(panelList["pet_"+index].SelectedFrame as MovieClip).mouseEnabled = false;
			(panelList["pet_"+index].SelectedFrame as MovieClip).mouseChildren = false;
			switch(state)
			{
				case 0://休息
					panelList["pet_"+index].mc_State.visible = false;
					break;
				case 1://出战
					panelList["pet_"+index].mc_State.visible = true;
					panelList["pet_"+index].mc_State.gotoAndStop(1);
					break;
				case 4://附体
					panelList["pet_"+index].mc_State.visible = true;
					panelList["pet_"+index].mc_State.gotoAndStop(2);
					break;
				default:
					panelList["pet_"+index].mc_State.visible = false;
					break;
			}
		}
		
		public function releaseListUI(i:int):void
		{
			var index:int = i-firstPetIndex;
			panelList["pet_"+index].removeEventListener(MouseEvent.CLICK,onSelectClick);
			panelList["pet_"+index].visible = false;
			panelList["pet_"+index].SelectedFrame.visible = false;
			panelList["pet_"+index].btnFree.visible = false;
			panelList["pet_"+index].btnFreeName.visible = false;
		}
		
		private function onSelectClick(e:MouseEvent):void
		{
			var index:int = e.currentTarget.name.split("_")[1];
			panelList["pet_"+curSelectPet].SelectedFrame.visible = false;
			panelList["pet_"+index].SelectedFrame.visible = true;
			panelList["pet_"+curSelectPet].btnFree.visible = false;
			panelList["pet_"+curSelectPet].btnFreeName.visible = false;
			panelList["pet_"+index].btnFree.visible = true;
			panelList["pet_"+index].btnFreeName.visible = true;
			curSelectPet = index;
			if(onSelectFuc != null)onSelectFuc();
		}
		
		public function setFrame(i:int):void
		{
			if(i>=petShowMaxNum)return;
			panelList["pet_"+i].SelectedFrame.visible = true;
			panelList["pet_"+i].btnFree.visible = true;
			panelList["pet_"+i].btnFreeName.visible = true;
		}
	}
}