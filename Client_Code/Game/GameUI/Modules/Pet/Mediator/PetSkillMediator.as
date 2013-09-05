package GameUI.Modules.Pet.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Bag.Proxy.BagData;
	import GameUI.Modules.Bag.Proxy.GridUnit;
	import GameUI.Modules.Bag.Proxy.NetAction;
	import GameUI.Modules.GmTools.Utils.LoadSwfTool;
	import GameUI.Modules.Pet.Data.PetEvent;
	import GameUI.Modules.Pet.Data.PetPropConstData;
	import GameUI.Modules.Pet.Proxy.PetLearnSkillGridManager;
	import GameUI.Modules.Pet.Proxy.PetNetAction;
	import GameUI.Proxy.DataProxy;
	import GameUI.SetFrame;
	import GameUI.UIConfigData;
	import GameUI.View.BaseUI.PanelBase;
	import GameUI.View.items.UseItem;
	
	import Net.ActionProcessor.OperateItem;
	import Net.ActionProcessor.PlayerAction;
	
	import OopsEngine.Role.GamePetRole;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PetSkillMediator extends Mediator
	{
		public static const NAME:String = "PetSkillMediator";
		private var panelBase:PanelBase;
		private var parentView:MovieClip;
		private var petSkillDataList:Array = null;			//存放所有技能书
		private var petSkillGrid:PetLearnSkillGridManager = null;
		private var cacheCells:Array=[];
		private var loadswfTool:LoadSwfTool;
		private var selectItem:UseItem = null;
		
		private var isSkillPanelOpen:Boolean = false;
		
		private var skillUseItemList:Dictionary = new Dictionary();
		
		private var subIndexPage:int = 0;
		private var maxIndexPage:int = 1;
		
		public function PetSkillMediator(parentMc:MovieClip, _loadswfTool:LoadSwfTool=null)
		{
			parentView = parentMc;
			super(NAME);
			this.loadswfTool = _loadswfTool;
		}
		
		public function get PetSkill():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				EventList.INITPETPANEL,
				EventList.OPENPETSKILL,					//打开宠物技能
				PetEvent.UPDATE_PET_SKILL_INFO,
				PetEvent.PET_UPDATE_EQUIP_INFO,
				EventList.CLOSEPETSKILL					//关闭宠物技能
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case EventList.INITPETPANEL:
//					facade.sendNotification(EventList.GETRESOURCE, {type:UIConfigData.MOVIECLIP, mediator:this, name:"petSkill"});
					this.setViewComponent(this.loadswfTool.GetResource().GetClassByMovieClip("petSkill"));
					this.PetSkill.mouseEnabled=false;
					petSkillGrid = new PetLearnSkillGridManager();
					petSkillGrid.btnDownFunc = this.onSelectSkillBook;
					break;
				case EventList.OPENPETSKILL:
					registerView();
					initData();
					initPetSkillData();
					initAllSkillInfo();
					initGrid();
					petSkillGrid.init();
					PetSkill.x = 160;
					PetSkill.y = 43;
					PetSkill.mouseEnabled = false;
					PetPropConstData.SelectedPetItem = null;
					showPetSkill();
					parentView.addChild(PetSkill);
					isSkillPanelOpen = true;
					break;
				case EventList.CLOSEPETSKILL:
					retrievedView();
					parentView.removeChild(PetSkill);
					petSkillDataList = null;
					cacheCells = [];
					petSkillGrid.gc();
					isSkillPanelOpen = false;
					break;
				case PetEvent.UPDATE_PET_SKILL_INFO://刷新技能,index=-1时，表示全部刷新
					if(PetPropConstData.curPage==4)
					{
						var index:int = int(notification.getBody());
						
						if(isSkillPanelOpen)
						{
							if(index == -1)
							{
								this.clearAllSkillInfo();
								initAllSkillInfo();
							}
							else
							{
								initSkillInfo(index);
								
							}
							this.clearSkillBook();
							PetPropConstData.SelectedSkillPos = -1;
						}
					}
					
					break;
				case PetEvent.PET_UPDATE_EQUIP_INFO://刷新技能书
					if(PetPropConstData.curPage==4)
					{
						petSkillGrid.gc();
						petSkillDataList = null;
						
						initPetSkillData();
						initGrid();
						
						petSkillGrid.init();
						showPetSkill(this.subIndexPage);
					}
					
					break;
			}
		}
		
		private function initData():void
		{
			//获取宠物数据
		}
		
		private function registerView():void
		{
			//初始化素材事件
			PetSkill.mcLeft.gotoAndStop(1);
			PetSkill.mcRight.gotoAndStop(1);
			(PetSkill.mcLeft as MovieClip).addEventListener(MouseEvent.CLICK,onBtnClick);
			(PetSkill.mcRight as MovieClip).addEventListener(MouseEvent.CLICK,onBtnClick);
			(PetSkill.mcLeft as MovieClip).addEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
			(PetSkill.mcRight as MovieClip).addEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
			(PetSkill.mcLeft as MovieClip).addEventListener(MouseEvent.MOUSE_OUT,onBtnOut);
			(PetSkill.mcRight as MovieClip).addEventListener(MouseEvent.MOUSE_OUT,onBtnOut);
			(PetSkill.mcLeft as MovieClip).addEventListener(MouseEvent.MOUSE_DOWN,onBtnDown);
			(PetSkill.mcRight as MovieClip).addEventListener(MouseEvent.MOUSE_DOWN,onBtnDown);
			(PetSkill.mcLeft as MovieClip).addEventListener(MouseEvent.MOUSE_UP,onBtnUp);
			(PetSkill.mcRight as MovieClip).addEventListener(MouseEvent.MOUSE_UP,onBtnUp);
			
			PetSkill.petSkillShow_0.gotoAndStop(4);
			PetSkill.petSkillShow_1.gotoAndStop(1);
//			PetSkill.petSkillShow_1.addEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
//			PetSkill.petSkillShow_1.addEventListener(MouseEvent.MOUSE_OUT,onBtnOut);
			PetSkill.petSkillShow_2.gotoAndStop(1);
//			PetSkill.petSkillShow_2.addEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
//			PetSkill.petSkillShow_2.addEventListener(MouseEvent.MOUSE_OUT,onBtnOut);
			
			(PetSkill.btnLearn as SimpleButton).addEventListener(MouseEvent.CLICK, onBtnLearnSkill);
			(PetSkill.btnForget as SimpleButton).addEventListener(MouseEvent.CLICK, onBtnLearnSkill);
			(PetSkill.btnSave as SimpleButton).addEventListener(MouseEvent.CLICK, onBtnLearnSkill);
			(PetSkill.btnForgetName as MovieClip).mouseEnabled = false;
			(PetSkill.btnSaveName as MovieClip).mouseEnabled = false;
			(PetSkill.btnLearnName as MovieClip).mouseEnabled = false;
//			for(var i:int=0;i<3;i++)
//			{
//				(PetSkill["petSkillShow_"+i.toString()] as MovieClip).addEventListener(MouseEvent.CLICK, onSkillSelect);
//			}
		}
		
		private function onBtnClick(e:MouseEvent):void
		{
			var name:String = e.currentTarget.name;
			switch(name)
			{
				case "mcLeft":
					if(subIndexPage>0)
					{
						subIndexPage--;
						facade.sendNotification(PetEvent.PET_UPDATE_EQUIP_INFO);
					}
					
					break;
				case "mcRight":
					if(subIndexPage<maxIndexPage)
					{
						subIndexPage++;
						facade.sendNotification(PetEvent.PET_UPDATE_EQUIP_INFO);
					}
					break;
			}
		}
		
		private function onBtnOver(e:MouseEvent):void
		{
			var name:String = e.currentTarget.name;
			switch(name)
			{
				case "mcLeft":
					(PetSkill.mcLeft as MovieClip).gotoAndStop(2);
					break;
				case "mcRight":
					(PetSkill.mcRight as MovieClip).gotoAndStop(2);
					break;
				case "petSkillShow_1":
					(PetSkill.petSkillShow_1 as MovieClip).gotoAndStop(2);
					break;
				case "petSkillShow_2":
					(PetSkill.petSkillShow_2 as MovieClip).gotoAndStop(3);
					break;
			}
		}
		
		private function onBtnOut(e:MouseEvent):void
		{
			var name:String = e.currentTarget.name;
			var tmpPet:GamePetRole = GameCommonData.Player.Role.PetSnapList[PetPropConstData.selectedPetId];
			if(tmpPet)
			{
				switch(name)
				{
					case "mcLeft":
						(PetSkill.mcLeft as MovieClip).gotoAndStop(1);
						break;
					case "mcRight":
						(PetSkill.mcRight as MovieClip).gotoAndStop(1);
						break;
					case "petSkillShow_1":
						(PetSkill.petSkillShow_1 as MovieClip).gotoAndStop(1);
						break;
					case "petSkillShow_2":
						(PetSkill.petSkillShow_2 as MovieClip).gotoAndStop(1);
						break;
				}
			}
			
		}
		
		private function onBtnDown(e:MouseEvent):void
		{
			var name:String = e.currentTarget.name;
			switch(name)
			{
				case "mcLeft":
					(PetSkill.mcLeft as MovieClip).gotoAndStop(1);
					break;
				case "mcRight":
					(PetSkill.mcRight as MovieClip).gotoAndStop(1);
					break;
			}
		}
		
		private function onBtnUp(e:MouseEvent):void
		{
			var name:String = e.currentTarget.name;
			switch(name)
			{
				case "mcLeft":
					(PetSkill.mcLeft as MovieClip).gotoAndStop(2);
					break;
				case "mcRight":
					(PetSkill.mcRight as MovieClip).gotoAndStop(2);
					break;
			}
		}
		
		private function retrievedView():void
		{
			//释放素材事件
			(PetSkill.mcLeft as MovieClip).removeEventListener(MouseEvent.CLICK,onBtnClick);
			(PetSkill.mcRight as MovieClip).removeEventListener(MouseEvent.CLICK,onBtnClick);
			(PetSkill.mcLeft as MovieClip).removeEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
			(PetSkill.mcRight as MovieClip).removeEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
			(PetSkill.mcLeft as MovieClip).removeEventListener(MouseEvent.MOUSE_OUT,onBtnOut);
			(PetSkill.mcRight as MovieClip).removeEventListener(MouseEvent.MOUSE_OUT,onBtnOut);
			(PetSkill.mcLeft as MovieClip).removeEventListener(MouseEvent.MOUSE_DOWN,onBtnDown);
			(PetSkill.mcRight as MovieClip).removeEventListener(MouseEvent.MOUSE_DOWN,onBtnDown);
			(PetSkill.mcLeft as MovieClip).removeEventListener(MouseEvent.MOUSE_UP,onBtnUp);
			(PetSkill.mcRight as MovieClip).removeEventListener(MouseEvent.MOUSE_UP,onBtnUp);

			PetSkill.petSkillShow_1.removeEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
			PetSkill.petSkillShow_1.removeEventListener(MouseEvent.MOUSE_OUT,onBtnOut);
			PetSkill.petSkillShow_2.removeEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
			PetSkill.petSkillShow_2.removeEventListener(MouseEvent.MOUSE_OUT,onBtnOut);
			
			(PetSkill.btnLearn as SimpleButton).removeEventListener(MouseEvent.CLICK, onBtnLearnSkill);
			(PetSkill.btnForget as SimpleButton).removeEventListener(MouseEvent.CLICK, onBtnLearnSkill);
			(PetSkill.btnSave as SimpleButton).removeEventListener(MouseEvent.CLICK, onBtnLearnSkill);
			
			for(var i:int=0;i<3;i++)
			{
				clearSkillInfo(i);
			}
		}
		
		/** 初始化技能栏 
		 *  index,count用于分页
		 *  index表示当前页的开始索引
		 *  count表示当前页的结尾索引
		 * */
		private function initGrid():void
		{
			var index:int = this.subIndexPage*PetPropConstData.petSkillGridNum;
			var count:int = petSkillDataList.length<(index+PetPropConstData.petSkillGridNum)?petSkillDataList.length:(index+PetPropConstData.petSkillGridNum);
			
			for( var i:int = index; i<count; i++ ) 
			{
				var gridUnit:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
				gridUnit.x = PetSkill["petSkillBook_"+(i-index).toString()].x;
				gridUnit.y = PetSkill["petSkillBook_"+(i-index).toString()].y;
//				gridUnit.name = "petSkillBook_" + i.toString();
				PetSkill.addChild(gridUnit);
				var gridUint:GridUnit = new GridUnit(gridUnit, true);
				gridUint.parent = PetSkill;									//设置父级
				gridUint.Index = petSkillDataList[i].index;											//格子的位置		
				gridUint.HasBag = true;										//是否是可用的背包
				gridUint.IsUsed	= false;									//是否已经使用
				gridUint.Item	= null;										//格子的物品
				PetPropConstData.petSkillGridList[petSkillDataList[i].index]=gridUint;
			}
		}
		
		/** 获取宠物技能信息 */
		private function initAllSkillInfo():void
		{
			var tmpPet:GamePetRole = GameCommonData.Player.Role.PetSnapList[PetPropConstData.selectedPetId];
			if(tmpPet)
			{
				for(var i:int=0;i<tmpPet.SkillLevel.length;i++)
				{
//					var gridUnit:MovieClip = this.loadswfTool.GetResource().GetClassByMovieClip("petSkill");
//					gridUnit.x = PetSkill["petSkillShow_"+i].x;
//					gridUnit.y = PetSkill["petSkillShow_"+i].y;
//					//				gridUnit.name = "petSkillBook_" + i.toString();
//					PetSkill.addChild(gridUnit);
//					
//					var gridUint:GridUnit = new GridUnit(gridUnit, true);
//					gridUint.parent = PetSkill;									//设置父级
					
					initSkillInfo(i);
				}
			}
		}
		
		private function initSkillInfo(i:int):void
		{
			clearSkillInfo(i);
			
			var tmpPet:GamePetRole = GameCommonData.Player.Role.PetSnapList[PetPropConstData.selectedPetId];
			if(tmpPet)
			{
				switch(tmpPet.SkillLevel[i])
				{
					case 0:
						PetSkill["petSkillShow_"+i.toString()].gotoAndStop(4);
//						PetSkill["petSkillShow_"+i.toString()].addEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
//						PetSkill["petSkillShow_"+i.toString()].addEventListener(MouseEvent.MOUSE_OUT,onBtnOut);
						break;
					case 99999:
						
						PetSkill["petSkillShow_"+i.toString()].addEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
						PetSkill["petSkillShow_"+i.toString()].addEventListener(MouseEvent.MOUSE_OUT,onBtnOut);
						break;
					default:
						var id:int = tmpPet.SkillLevel[i].gameSkill.SkillID;
						var useItem:UseItem = this.getCells(0, id.toString(), PetSkill);
						useItem.x = PetSkill["petSkillShow_"+i].x+3;
						useItem.y = PetSkill["petSkillShow_"+i].y+3;
						useItem.setImageScale(60,60);
						PetSkill.addChild(useItem);
						useItem.mouseChildren = false;
						useItem.mouseEnabled = false;
						
						(PetSkill["petSkillShow_"+i.toString()] as MovieClip).addEventListener(MouseEvent.CLICK, onSkillSelect);
						
						PetSkill["petSkillShow_"+i.toString()].gotoAndStop(4);
						
						skillUseItemList[i] = useItem;
						break;
				}
			}
		}
		
		private function clearAllSkillInfo():void
		{
//			var tmpPet:GamePetRole = GameCommonData.Player.Role.PetSnapList[PetPropConstData.selectedPetId];
//			if(tmpPet)
//			{
				for(var i:int=0;i<3;i++)
				{
					clearSkillInfo(i);
				}
				
//			}
		}
		
		private function clearSkillInfo(i:int):void
		{
			if(skillUseItemList[i])
			{
				if(skillUseItemList[i].parent)
				{
					skillUseItemList[i].gc();
					skillUseItemList[i].parent.removeChild(skillUseItemList[i]);
					delete skillUseItemList[i];
				}
				(PetSkill["petSkillShow_"+i.toString()] as MovieClip).removeEventListener(MouseEvent.CLICK, onSkillSelect);
			}
			
		}
		
		/** 获取宠物相关技能书信息 */
		private function initPetSkillData():void
		{
			petSkillDataList = new Array();
			for(var i:int=0;i<BagData.AllUserItems[0].length;i++)
			{
				if(BagData.AllUserItems[0][i] != null && BagData.AllUserItems[0][i] != undefined && BagData.AllUserItems[0][i].type>503145 && BagData.AllUserItems[0][i].type<503167)
				{
					petSkillDataList.push(BagData.AllUserItems[0][i]);
				}
			}
			maxIndexPage = petSkillDataList.length/PetPropConstData.petSkillGridNum + 1;
			
			PetSkill.txtPage.text = (this.subIndexPage+1)+"/"+this.maxIndexPage;
		}
		
		/** 显示宠物技能书
		 * 
		 * 	index 代表翻页
		 * 
		 *  */
		private function showPetSkill(index:int=0):void
		{			
			//移除所有界面上的物品	
			
			removeAllItem();
			
			//			var a:Array = BagData.BagNum;
			if(PetPropConstData.petSkillGridList.length == 0) return;
			var count:int = 0;
			for(var i:int = index*PetPropConstData.petSkillGridNum; i<(index+1)*PetPropConstData.petSkillGridNum; i++)
			{
				//无数据,背包为空
				if(petSkillDataList[i]) 
				{
					//添加物品
					addItem(petSkillDataList[i],i%((index+1)*PetPropConstData.petSkillGridNum));
				}
			}
			//目前有锁定的物品则显示操作按钮，加外框		
			if(PetPropConstData.SelectedPetItem)
			{
				SetFrame.UseFrame(PetPropConstData.SelectedPetItem.Grid);
			}	
		}
		
		private function removeAllItem():void
		{
			
		}
		
		/**添加物品，初始化格子数组,如果有物品在cd添加cd
		 * index 对应装备框位置
		 */
		private function addItem(item:Object,index:int):void
		{
			/** 此处item是从物品数组中取出，item。index对应的是背包的位置
			 * 	使用UseItem实例才能和后台通行，使用装备
			 *  */
			var useItem:UseItem = this.getCells(item.index, item.type, PetSkill);
			useItem.x = PetPropConstData.petSkillGridList[item.index].Grid.x+2;
			useItem.y = PetPropConstData.petSkillGridList[item.index].Grid.y+2;
			useItem.Id = item.id;
			useItem.IsBind = item.isBind;
			useItem.Type = item.type;
			
			PetPropConstData.petSkillGridList[item.index].Item = useItem;
			PetPropConstData.petSkillGridList[item.index].IsUsed = true;
			PetPropConstData.petSkillGridList[item.index].HasBag = true;
			(PetPropConstData.petSkillGridList[item.index] as GridUnit).Grid.name = "bag_" + item.index.toString();
			
			PetSkill.addChild(useItem);	
		}
		
		/** 创建UseItem实例 */
		protected function getCells(pos:int, icon:String, parent:DisplayObjectContainer):UseItem{
			
			var useItem:UseItem=this.cacheCells.shift();
			useItem=new UseItem(pos,icon,parent);
			return useItem;
		}
		
		private function onSelectSkillBook():void
		{
			var item:Object = BagData.getItemById(PetPropConstData.SelectedPetItem.Item.Id);
			if(item)
			{
				this.clearSkillBook();
				selectItem = this.getCells(item.index, item.type, PetSkill);
				selectItem.x = PetSkill.petSkillBookSelect.x+2;
				selectItem.y = PetSkill.petSkillBookSelect.y+2;
				selectItem.Id = item.id;
				selectItem.IsBind = item.isBind;
				selectItem.Type = item.type;
				selectItem.setImageScale(PetSkill.petSkillBookSelect.width-4,PetSkill.petSkillBookSelect.height-4);
				(PetSkill.petSkillBookSelect as MovieClip).addEventListener(MouseEvent.CLICK,onBtnClear);
				PetSkill.addChild(selectItem);
			}
			
		}
		
		private function onBtnClear(e:MouseEvent):void
		{
			this.clearSkillBook();
			(PetSkill.petSkillBookSelect as MovieClip).removeEventListener(MouseEvent.CLICK,onBtnClear);
		}
		
		private function clearSkillBook():void
		{
			if(selectItem)
			{
				selectItem.reset();
				selectItem.gc();
				selectItem = null;
			}
		}
		
		private function onBtnLearnSkill(e:MouseEvent):void
		{
			var name:String = e.currentTarget.name;
			
			var tmpPet:GamePetRole = GameCommonData.Player.Role.PetSnapList[PetPropConstData.selectedPetId];
			if(!tmpPet)return;
			switch(name)
			{
				case "btnLearn":
					var item:Object = PetPropConstData.SelectedPetItem;
					if(selectItem==null||PetPropConstData.SelectedPetItem == null||PetPropConstData.SelectedPetItem.Item == null)return;
//					NetAction.UseItem(OperateItem.USE,1,PetPropConstData.SelectedPetItem.Index,PetPropConstData.SelectedPetItem.Item.Id);
					PetNetAction.PetLearnSkill(PlayerAction.PET_SKILL_LEARN, PetPropConstData.selectedPetId,PetPropConstData.SelectedPetItem.Item.Id);//学习技能
					break;
				case "btnForget":
//					PetNetAction.PetForgetSkill(PlayerAction.PET_SKILL_LEARN_FAIL, PetPropConstData.selectedPetId,PetPropConstData.SelectedPetItem.Item.Id);
					if(PetPropConstData.SelectedSkillPos>=0)
					{
						PetNetAction.PetForgetSkill(PlayerAction.PET_SKILL_LEARN_FAIL, PetPropConstData.selectedPetId,tmpPet.SkillLevel[PetPropConstData.SelectedSkillPos].gameSkill.SkillID);
						
					}
					break;
				case "btnSave":
					if(PetPropConstData.SelectedSkillPos>=0)
					{
						PetNetAction.PetSkillSeal(PlayerAction.PET_SKILL_SEAL, PetPropConstData.selectedPetId,tmpPet.SkillLevel[PetPropConstData.SelectedSkillPos].gameSkill.SkillID);//封印技能 
					}
					
					break;
			}
					//	PetNetAction.PetLearnSkill(PlayerAction.PET_SKILL_LEARN, PetPropConstData.selectedPetId,PetPropConstData.SelectedPetItem.Item.Id);//学习技能

		}
		
		private function onSkillSelect(e:MouseEvent):void
		{
			/** 添加选中框，保存选中位置 */
			var index:int = int(e.currentTarget.name.split("_")[1]);
			if(index>-1 && index<3)
			{
				PetPropConstData.SelectedSkillPos = index;
			}
		}
	}
}