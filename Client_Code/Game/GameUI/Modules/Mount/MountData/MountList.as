package GameUI.Modules.Mount.MountData
{
	
	import GameUI.View.items.UseItem;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class MountList extends Sprite
	{
		public var firstMountIndex:int = 0;
//		public var panelArray:Array = null;
		private var mountShowMaxNum:int = 0;
		private var panelList:MovieClip = null;
		
		public var onUpClickFuc:Function = null;
		public var onDownClickFuc:Function = null;
		public var onSelectFuc:Function = null;
		public var useItemList:Dictionary = new Dictionary;
		
		private var _nRed:Number=0.3086;
		private var _nGreen:Number=0.6094;
		private var _nBlue:Number=0.0820;
		
		private var filterDic:Dictionary = new Dictionary;//存放装备滤镜
		
		/** 对应界面5个宠物栏，不是对应panelList数组，换算方法是curSelectMount+firstMountIndex就是对应数组的位置*/
		public var curSelectMount:int = 0;
		
		public function MountList(num:int)
		{
			panelList = MountData.loadswfTool.GetResource().GetClassByMovieClip("MountList");
			this.addChild(panelList);
			mountShowMaxNum = num;
			for(var i:int=0;i<mountShowMaxNum; i++)
			{
//				panelList["mount_"+i].visible = false;
//				panelList["mount_"+i].SelectedFrame.visible = false;
			}
			(panelList.btnUp as SimpleButton).addEventListener(MouseEvent.CLICK,onUpClick);
			(panelList.btnDown as SimpleButton).addEventListener(MouseEvent.CLICK,onDownClick);
		}
		
		public function onUpClick(e:MouseEvent):void
		{
			if(firstMountIndex>0 && MountData.mountSkinList.length>mountShowMaxNum)
			{
				firstMountIndex--;
				if(onUpClickFuc != null)onUpClickFuc();
			}
		}
		
		public function onDownClick(e:MouseEvent):void
		{
			if(firstMountIndex+mountShowMaxNum < MountData.mountSkinList.length)
			{
				firstMountIndex++;
				//				createMountUI();
				if(onDownClickFuc != null)onDownClickFuc();
			}
		}
		
		public function createListUI(mountItem:Object,i:int,state:int=0):void
		{
			
			var index:int = i-firstMountIndex;
			panelList["mount_"+index].visible = true;
			
			
			var useItem:UseItem=new UseItem(0,mountItem.id,panelList);
//			useItem.x = panelList["mount_"+index].x+2;
//			useItem.y = panelList["mount_"+index].y+2;
			useItem.x = 2;
			useItem.y = 2;
			useItem.Id = mountItem.id;
			useItem.Type = mountItem.type;
			useItem.setImageScale(48,48);
//			panelList.addChild(useItem);
			panelList["mount_"+index].addChild(useItem);
//			panelList.addChild(useItem);
			useItemList[index] = useItem;
			
			if(mountItem.id>MountData.SelectedMountId)
			{
				filterDic[index] = (panelList["mount_"+index] as MovieClip).filters;
				(panelList["mount_"+index] as MovieClip).filters = [new ColorMatrixFilter([_nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, 0, 0, 0, 1, 0])];
			}else
			{
				if(filterDic[index])
				{
					(panelList["mount_"+index] as MovieClip).filters = filterDic[index];
				}
				panelList["mount_"+index].addEventListener(MouseEvent.CLICK,onSelectClick);
			}
			
//			panelList["mount_"+index].txtName.text = name;
//			panelList["mount_"+index].txtLevel.text = lev;
//			(panelList["mount_"+index].SelectedFrame as MovieClip).mouseEnabled = false;
//			(panelList["mount_"+index].SelectedFrame as MovieClip).mouseChildren = false;
			switch(state)
			{
				case 0://休息
//					panelList["mount_"+index].mc_State.visible = false;
					break;
				case 1://出战
//					panelList["mount_"+index].mc_State.visible = true;
//					panelList["mount_"+index].mc_State.gotoAndStop(1);
					break;
				case 4://附体
//					panelList["mount_"+index].mc_State.visible = true;
//					panelList["mount_"+index].mc_State.gotoAndStop(2);
					break;
				default:
//					panelList["mount_"+index].mc_State.visible = false;
					break;
			}
		}
		
		public function releaseListUI(i:int):void
		{
			if(useItemList[index])
			{
				var index:int = i-firstMountIndex;
				panelList["mount_"+index].removeEventListener(MouseEvent.CLICK,onSelectClick);
				panelList["mount_"+index].visible = false;
				
				(useItemList[index] as UseItem).gc();
				if(panelList["mount_"+index].contains(useItemList[index] as UseItem))
				{
					panelList["mount_"+index].removeChild((useItemList[index] as UseItem));
				}
				
				delete (useItemList[index] as UseItem);
			}
			
//			panelList["mount_"+index].SelectedFrame.visible = false;
		}
		
		private function onSelectClick(e:MouseEvent):void
		{
			var index:int = e.currentTarget.name.split("_")[1];
//			panelList["mount_"+curSelectMount].SelectedFrame.visible = false;
//			panelList["mount_"+index].SelectedFrame.visible = true;
			MountData.SelectedMount.id = MountData.mountSkinList[index+firstMountIndex].id;

			if(onSelectFuc != null)onSelectFuc(index);
		}
		
		public function setFrame(i:int):void
		{
			if(i>=mountShowMaxNum)return;
//			panelList["mount_"+i].SelectedFrame.visible = true;
		}
	}
}